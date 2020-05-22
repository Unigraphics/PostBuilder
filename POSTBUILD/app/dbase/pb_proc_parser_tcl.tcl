#16
source $env(PB_HOME)/app/dbase/pb_mom.tcl
UI_PB_AddPatchMsg "2001.0.1" "<07-25-02>  Fixed problem with syntax checking of custom commands."
proc PB_pps_CollectTclFileObjs { POST_OBJECT tcl_file_name sync args } {
upvar $POST_OBJECT post_object
if { [catch { set sta [PB_pps_ParseTclFile $tcl_file_name event_proc_data $sync] } ] } {
global errorInfo
return [error "$errorInfo"]
}
if { $sta == "TCL_ERROR" } {
return [error ""]
}
set event_name_list [array get event_proc_data]
set cmd_proc_list ""
set oth_proc_list ""
set llen [llength $event_name_list]
for {set i 0} {$i < $llen} {incr i 2} \
{
set event_item [lindex $event_name_list $i]
if { ![string match "MOM*" $event_item] && [string match "*\,name" $event_item] } \
{
if { [string match "PB_CMD*" $event_item] } \
{
set event_name [lindex [split $event_item ,] 0]
set cmd_proc_list [ladd $cmd_proc_list end $event_name "no_dup"]
set cmd_proc_data($event_name,proc) $event_proc_data($event_name,proc)
set cmd_proc_data($event_name,blk_list) $event_proc_data($event_name,blk_list)
set cmd_proc_data($event_name,add_list) $event_proc_data($event_name,add_list)
set cmd_proc_data($event_name,fmt_list) $event_proc_data($event_name,fmt_list)
UI_PB_debug_DisplayMsg "Custom Command : $event_name" no_debug
} elseif { ![string match "PB*" $event_item] && \
![string match "VNC_*" $event_item] } \
{
set event_name [lindex [split $event_item ,] 0]
set oth_proc_list [ladd $oth_proc_list end $event_name "no_dup"]
set oth_proc_data($event_name,comment) $event_proc_data($event_name,comment)
set oth_proc_data($event_name,args)    $event_proc_data($event_name,args)
set oth_proc_data($event_name,proc)    $event_proc_data($event_name,proc)
UI_PB_debug_DisplayMsg "Other Command : $event_name" no_debug
}
}
}
}
proc PB_pps_CreateTclFileObjs { POST_OBJECT tcl_file_name sync args } {
upvar $POST_OBJECT post_object
global gPB
global errorInfo
if { [catch { set sta [PB_pps_ParseTclFile $tcl_file_name event_proc_data $sync] }] } {
return [error "$errorInfo"]
}
if { $sta == "TCL_ERROR" } {
return [error ""]
}
set event_name_list [array get event_proc_data]
set cmd_proc_list ""
set post_cmd_list [list]
Post::GetObjList $post_object command cmd_blk_list
foreach cc $cmd_blk_list {
command::readvalue $cc attr
if { [lsearch $post_cmd_list $attr(0)] < 0 } {
lappend post_cmd_list $attr(0)
}
}
set oth_proc_list ""
Post::GetOthProcList $post_object oth_proc_list
Post::GetOthProcData $post_object oth_proc_data
set llen [llength $event_name_list]
for {set i 0} {$i < $llen} {incr i 2} \
{
set event_item [lindex $event_name_list $i]
if { ![string match "MOM*" $event_item] && [string match "*\,name" $event_item] } \
{
if { [string match "PB_CMD*" $event_item] } \
{
set event_name [lindex [split $event_item ,] 0]
set add_proc 1
if { [string match "PB_CMD_kin_*" $event_name] } \
{
if { [info exists gPB(pui_ui_overwrite)]  &&  $gPB(pui_ui_overwrite) } \
{
} else \
{
if { [lsearch $post_cmd_list $event_name] >= 0 } \
{
UI_PB_debug_ForceMsg ">>> Skipping $event_name"
set add_proc 0
}
}
}
if { [string match "PB_CMD_vnc____*" $event_name] || \
[string match "PB_CMD_vnc__set_nc_definitions" $event_name] || \
[string match "PB_CMD_vnc__sim_other_devices" $event_name] } {
if { [lsearch $post_cmd_list $event_name] >= 0 } \
{
UI_PB_debug_ForceMsg ">>> Skipping VNC command  $event_name"
set add_proc 0
}
}
if { $add_proc } \
{
UI_PB_debug_ForceMsg ">>> Adding $event_name"
set cmd_proc_list [ladd $cmd_proc_list end $event_name "no_dup"]
set cmd_proc_data($event_name,proc) $event_proc_data($event_name,proc)
set cmd_proc_data($event_name,blk_list) $event_proc_data($event_name,blk_list)
set cmd_proc_data($event_name,add_list) $event_proc_data($event_name,add_list)
set cmd_proc_data($event_name,fmt_list) $event_proc_data($event_name,fmt_list)
}
} elseif { ![string match "PB*" $event_item] && \
![string match "VNC_*" $event_item] } \
{
set event_name [lindex [split $event_item ,] 0]
if { [info exists gPB(pui_ui_overwrite)]  &&  $gPB(pui_ui_overwrite) } {
set oth_proc_list [ladd $oth_proc_list end $event_name "no_dup"]
set oth_proc_data($event_name,comment) $event_proc_data($event_name,comment)
set oth_proc_data($event_name,args)    $event_proc_data($event_name,args)
set oth_proc_data($event_name,proc)    $event_proc_data($event_name,proc)
} else {
if { [lsearch $oth_proc_list $event_name] < 0 } {
lappend oth_proc_list $event_name
set oth_proc_data($event_name,comment) $event_proc_data($event_name,comment)
set oth_proc_data($event_name,args)    $event_proc_data($event_name,args)
set oth_proc_data($event_name,proc)    $event_proc_data($event_name,proc)
}
}
}
}
Post::GetEventProcs $post_object event_procs
if { [string match "*\,name" $event_item] } \
{
set event_name [lindex [split $event_item ,] 0]
set proc_data $event_proc_data($event_name,proc)
set proc_data [linsert $proc_data 0 \
"\#=============================================================" \
"proc\ $event_name\ \{\ \}\ \{" \
"\#============================================================="]
set proc_data [linsert $proc_data end "\}"]
set event_procs($event_name) $proc_data
}
}
if [info exists event_procs] \
{
Post::SetEventProcs $post_object event_procs
}
foreach cmd_blk $cmd_proc_list \
{
set cmd_obj_attr(0) $cmd_blk
set cmd_obj_attr(1) $cmd_proc_data($cmd_blk,proc)
set cmd_obj_attr(2) $cmd_proc_data($cmd_blk,blk_list)
set cmd_obj_attr(3) $cmd_proc_data($cmd_blk,add_list)
set cmd_obj_attr(4) $cmd_proc_data($cmd_blk,fmt_list)
PB_pps_CreateCommand cmd_obj_attr cmd_obj
}
Post::GetObjList $post_object command cmd_blk_list
PB_com_SortObjectsByNames cmd_blk_list
Post::SetObjListasAttr $post_object cmd_blk_list
if { [info exists oth_proc_list] && [info exists oth_proc_data] } {
Post::SetOthProcList $post_object oth_proc_list
Post::SetOthProcData $post_object oth_proc_data
unset oth_proc_list
unset oth_proc_data
}
}
proc PB_pps_UpdatePostAttr {} {
global post_object
uplevel 1 {
global post_object
set list_obj_list $Post::($post_object,list_obj_list)
set list_obj [lindex $list_obj_list 0]
ListingFile::readvalue $list_obj obj_attr
set mom_var_list [info vars "mom_sys_list_output"]
if [llength $mom_var_list] {
set obj_attr(listfile) $mom_sys_list_output
}
set mom_var_list [info vars "mom_sys_header_output"]
if [llength $mom_var_list] {
set obj_attr(head) $mom_sys_header_output
}
set mom_var_list [info vars "mom_sys_list_file_rows"]
if [llength $mom_var_list] {
set obj_attr(lines) $mom_sys_list_file_rows
}
set mom_var_list [info vars "mom_sys_list_file_columns"]
if [llength $mom_var_list] {
set obj_attr(column) $mom_sys_list_file_columns
}
set mom_var_list [info vars "mom_sys_warning_output"]
if [llength $mom_var_list] {
set obj_attr(warn) $mom_sys_warning_output
}
set mom_var_list [info vars "mom_sys_group_output"]
if [llength $mom_var_list] {
set obj_attr(group) $mom_sys_group_output
}
set mom_var_list [info vars "mom_sys_list_file_suffix"]
if [llength $mom_var_list] {
set obj_attr(lpt_ext) $mom_sys_list_file_suffix
}
set mom_var_list [info vars "mom_sys_output_file_suffix"]
if [llength $mom_var_list] {
set obj_attr(ncfile_ext) $mom_sys_output_file_suffix
}
ListingFile::setvalue $list_obj obj_attr
set mom_kin_list [info vars "mom_kin*"]
array set mom_kin_arr $Post::($post_object,mom_kin_var_list)
foreach v $mom_kin_list {
set var [format %s%s "\$" $v]
if [info exists mom_kin_arr($var)] {
set val [eval format %s $var]
set mom_kin_arr($var) $val
}
}
set Post::($post_object,mom_kin_var_list)     [array get mom_kin_arr]
set Post::($post_object,def_mom_kin_var_list) [array get mom_kin_arr]
set mom_sys_list [info vars "mom_sys*"]
array set mom_sys_arr $Post::($post_object,mom_sys_var_list)
foreach v $mom_sys_list {
if [array exists $v] {
set lv [array get $v]
set ll [llength $lv]
for {set i 0} {$i < $ll} {incr i 2} {
set var [format %s%s%s "\$" $v "([lindex $lv $i])"]
set val [eval format %s $var]
set mom_sys_arr($var) $val
}
} else {
set var [format %s%s "\$" $v]
set val [eval format %s $var]
set mom_sys_arr($var) $val
}
}
set Post::($post_object,mom_sys_var_list)     [array get mom_sys_arr]
set Post::($post_object,def_mom_sys_var_list) [array get mom_sys_arr]
} ;# uplevel 1
}
proc PB_pps_CreateCommand { CMD_OBJ_ATTR CMD_OBJ } {
upvar $CMD_OBJ_ATTR cmd_obj_attr
upvar $CMD_OBJ cmd_obj
global post_object
Post::GetObjList $post_object command cmd_blk_list
if [info exists cmd_obj] { unset cmd_obj }
foreach cc $cmd_blk_list {
command::readvalue $cc attr
if { $attr(0) == "$cmd_obj_attr(0)" } {
set cmd_obj $cc
break
}
}
if { ![info exists cmd_obj] } {
set cmd_obj [new command]
lappend cmd_blk_list $cmd_obj
Post::SetObjListasAttr $post_object cmd_blk_list
}
command::setvalue $cmd_obj cmd_obj_attr
command::DefaultValue $cmd_obj cmd_obj_attr
}
proc PB_pps_CreateCmdFromCmdObj { CMD_OBJ_LIST CMD_OBJ OBJ_INDEX } {
upvar $CMD_OBJ_LIST cmd_obj_list
upvar $CMD_OBJ cmd_obj
upvar $OBJ_INDEX obj_index
command::readvalue $cmd_obj cmd_obj_attr
PB_blk_GetCmdNamelist cmd_obj_list cmd_name_list
PB_com_SetDefaultName cmd_name_list cmd_obj_attr
PB_pps_CreateCommand cmd_obj_attr new_cmd_obj
set cmd_obj_list [linsert $cmd_obj_list $obj_index $new_cmd_obj]
global post_object
Post::SetObjListasAttr $post_object cmd_obj_list
}
proc PB_pps_GetCmdBlkProc { EVENT_PROC CMD_PROC } {
upvar $EVENT_PROC event_proc
upvar $CMD_PROC cmd_proc
set length [llength $event_proc]
set cmd_proc [lrange $event_proc 3 [expr $length - 2]]
}
proc PB_pps_ParseTclFile { tcl_file_name EVENT_PROC_DATA sync } {
global gPB
upvar $EVENT_PROC_DATA event_proc_data
if 0 {
rename source TCL_source
proc source { tcl_file } {
global gPB
set source_it 1
if [string match "*ugpost_base.tcl*" "$tcl_file"] {
if { ![info exists gPB(ugpost_base_sourced)] } {
set source_it 1
set gPB(ugpost_base_sourced) 1
} else {
set source_it 0
}
}
if { $source_it } {
TCL_source "$tcl_file"
}
}
}
global errorInfo
set parse_tcl 1
while { $parse_tcl } {
if [ catch {source $tcl_file_name} res ] {
UI_PB_debug_ForceMsg "$res"
if { $errorInfo != "" } {
set idx [string last "invoked from within" $errorInfo]
if { $idx > 0 } {
set errorInfo [string range $errorInfo 0 [expr $idx - 1]]
}
set gPB(err_msg) "$errorInfo\n\n\
You must correct this error in $tcl_file_name!"
return [error "" "$errorInfo"]
}
} else {
set parse_tcl 0
}
}
if 0 {
rename source ""
rename TCL_source source
}
if $sync {
PB_pps_UpdatePostAttr
}
set tcl_fid [open "$tcl_file_name" r]
set proc_start 0
set prev_proc_body ""
while { [gets $tcl_fid line] >= 0 }\
{
set temp_line [string trim $line]
if [string match "#*" $temp_line] \
{
lappend comment_lines $line
}
set temp_line $line
PB_com_RemoveBlanks temp_line
if { $temp_line == "" } \
{
if [info exists comment_lines] \
{
unset comment_lines
}
}
if { [string match "proc *" $temp_line] == 1} \
{
set event_name [lindex $temp_line 1]
set proc_is_dummy 0
foreach p $prev_proc_body {
if [string match "proc*$event_name*" $p] {
set proc_is_dummy 1
break
}
}
if 0 {
if { [string match "MOM_before_each_add_var" $event_name] || \
[string match "MOM_before_each_event" $event_name] } {
set proc_is_dummy 1
}
}
if { $proc_is_dummy } {
proc $event_name {args} {}
} else {
set proc_start 1
if { ![string match "PB_*"  $event_name]  && \
![string match "MOM_*" $event_name] } \
{
if [info exists comment_lines] \
{
set event_proc_data($event_name,comment) $comment_lines
} else \
{
set event_proc_data($event_name,comment) ""
}
}
if [info exists comment_lines] \
{
unset comment_lines
}
set event_proc_data($event_name,name) $event_name
set event_proc_data($event_name,args) [info args $event_name]
set proc_data ""
set proc_body ""
set proc_body [concat [info body $event_name]]
set proc_body [split $proc_body "\n"]
if { [string match "PB_*"  $event_name]  || \
[string match "MOM_*" $event_name] } \
{
if [string match "\#===*" [lindex $proc_body 0]] \
{
set proc_body [lreplace $proc_body 0 0]
}
}
foreach e $proc_body \
{
lappend proc_data $e
}
set event_proc_data($event_name,proc) $proc_data
set prev_proc_body ""
foreach p $proc_body {
lappend prev_proc_body [string trim $p]
}
} ;# dummy/non-existent proc
} else \
{
set proc_start 0
}
if { $proc_start  &&  ![string match "PB_*"  $event_name]  && \
![string match "MOM_*" $event_name] } \
{
rename $event_name ""
proc $event_name {args} { return 1 }
}
if { $proc_start  &&  [string match "PB_CMD*" $event_name] } \
{
global gPB
UI_PB_debug_DisplayMsg "command name = $event_name" no_debug
set proc_state [PB_proc_ValidateCustCmd $event_name $proc_body res]
if 0 {
if { [PB_is_v3] >= 0 } {
if { [string match "PB_CMD_init_multiple_post" $event_name] || \
[string match "PB_CMD_multiple_post_initialize" $event_name] } {
set event_proc_data($event_name,proc) ""
set gPB(CMD_BLK_LIST) ""
set gPB(CMD_ADD_LIST) ""
set gPB(CMD_FMT_LIST) ""
}
}
}
set keep_cmd 1
set Postbuilder_Version $gPB(Postbuilder_Version)
if [info exists gPB(Old_PUI_Version)] {
set gPB(Postbuilder_Version) $gPB(Old_PUI_Version)
}
if { [PB_is_v 3] == 0 } {
switch $event_name {
"PB_CMD_machine_mode" -
"PB_CMD_init_mill_turn" -
"PB_CMD_kin_mill_turn_initialize" -
"PB_CMD_init_mill_xzc" -
"PB_CMD_kin_mill_xzc_init" -
"PB_CMD_init_multiple_post" -
"PB_CMD_multiple_post_initialize" \
{
set keep_cmd 0
if { [info exists gPB(KEEP_OLD_PB_CMD)]  && \
$gPB(KEEP_OLD_PB_CMD) == 1 } {
set keep_cmd 1
} else {
unset event_proc_data($event_name,name)
unset event_proc_data($event_name,args)
if [info exists event_proc_data($event_name,comment)] {
unset event_proc_data($event_name,comment)
}
}
}
}
}
set gPB(Postbuilder_Version) $Postbuilder_Version
if $keep_cmd {
set event_proc_data($event_name,blk_list) $gPB(CMD_BLK_LIST)
set event_proc_data($event_name,add_list) $gPB(CMD_ADD_LIST)
set event_proc_data($event_name,fmt_list) $gPB(CMD_FMT_LIST)
}
}
if { [string match "\}*" $line] == 1} \
{
if [info exists comment_lines] \
{
unset comment_lines
}
}
}
close $tcl_fid
}
proc __RENAME { args } {}
proc __RETURN { args } {}
proc __PROC { args } {}
proc __EvalProc { proc_data RES } {
upvar $RES __PB_res
if [catch { eval [join $proc_data \n] } __PB_res] {
return 1
} else {
return 0
}
}
proc PB_proc_ValidateCustCmd { __PB_cmd_name __PB_proc_body __PB_RES args } {
upvar  $__PB_RES __PB_res
global gPB
global post_object
global errorInfo
if { ![info exists Post::($post_object,ass_cmd_list)] } {
set Post::($post_object,ass_cmd_list) ""
} else {
Post::GetObjList  $post_object command cmd_obj_list
foreach cmd_obj $cmd_obj_list {
set cmd $command::($cmd_obj,name)
set ass_idx [lsearch $Post::($post_object,ass_cmd_list) $cmd]
if { $ass_idx >= 0 } {
set Post::($post_object,ass_cmd_list) \
[lreplace $Post::($post_object,ass_cmd_list) $ass_idx $ass_idx]
}
}
}
set __PB_tmp_proc_data ""
set uplevel_global_scope 0
set uplevel_script [list]
foreach e $__PB_proc_body {
set ee [string trim $e]
if [string length $ee] {
if { ![string match "rename*" $ee] &&  ![string match "#*" $ee] } {}
if { ![string match "#*" $ee] } {
if [string match "*rename *" $ee] {
set idx [string first "rename" $ee]
set head [string range $ee 0 [expr $idx - 1]]
set idx [string wordend $ee $idx]
set tail [string range $ee $idx end]
set ee "${head}__RENAME${tail}"
}
if [string match "*return *" $ee] {
set idx [string first "return" $ee]
set head [string range $ee 0 [expr $idx - 1]]
set idx [string wordend $ee $idx]
set tail [string range $ee $idx end]
set ee "${head}__RETURN${tail}"
}
if [string match "*proc *" $ee] {
set idx [string first "proc " $ee]
set head [string range $ee 0 [expr $idx - 1]]
set idx [string wordend $ee $idx]
set tail [string range $ee $idx end]
set ee "${head}__PROC${tail}"
}
if 0 {
if [string match "*if *" $ee] {
set idx [string first "if " $ee]
set head [string range $ee 0 [expr $idx - 1]]
set idx [string last " \{" $ee]
set tail [string range $ee [expr $idx + 1] end]
set ee "${head}if 1 ${tail}"
}
}
if [string match "*uplevel *\#0 *" $ee] {
set uplevel_global_scope 1
set uplevel_brace_count 0
set uplevel_proc_scope 0
set uplevel_proc_brace_count 0
}
if $uplevel_global_scope {
set s [join [list $ee]]
regsub -all {\\\\\{} $s {}  s
regsub -all {\\\\\}} $s {}  s
set left_brace_count  [llength [split $s \{]]
set right_brace_count [llength [split $s \}]]
if [string match "__PROC *" $s] {
set uplevel_proc_scope 1
}
if { $uplevel_proc_scope == 0 } {
lappend uplevel_script $s
if [expr $left_brace_count > $right_brace_count] {
incr uplevel_brace_count
}
if [expr $left_brace_count < $right_brace_count] {
incr uplevel_brace_count -1
if [expr $uplevel_brace_count == 0] {
set uplevel_global_scope 0
}
}
} else {
if [expr $left_brace_count > $right_brace_count] {
incr uplevel_proc_brace_count
}
if [expr $left_brace_count < $right_brace_count] {
incr uplevel_proc_brace_count -1
if [expr $uplevel_proc_brace_count == 0] {
set uplevel_proc_scope 0
}
}
}
}
if [string match "*uplevel *" $ee] {
set head ""
set idx [string first "uplevel" $ee]
if { $idx >= 0 } {
set head [string range $ee 0 [expr $idx - 1]]
}
}
if [string match "*uplevel *\{*" $ee] {
set tail ""
set idx [string first "\{" $ee]
if { $idx >= 0 } {
set tail [string range $ee [expr $idx + 1] end]
}
set ee [string trim [join [list $head "uplevel\ 1\ \{" $tail]]]
} elseif [string match "*uplevel*\\" $ee] {
set ee [string trim [join [list $head "uplevel\ 1\ \\"]]]
}
lappend __PB_tmp_proc_data $ee
}
}
}
foreach v [info locals] {
if { ![string match "__PB_cmd_name"         $v] && \
![string match "__PB_RES"              $v] && \
![string match "__PB_res"              $v] && \
![string match "__PB_tmp_proc_data"    $v] && \
![string match "args"                  $v] && \
![string match "gPB"                   $v] && \
![string match "uplevel_*"             $v] && \
![string match "errorInfo"             $v] } {
foreach var $v {
unset $var
}
}
}
unset v
unset var
set gPB(CMD_BLK_LIST) [list]
set gPB(CMD_ADD_LIST) [list]
set gPB(CMD_FMT_LIST) [list]
set gPB(CMD_VAR_LIST) [list]
set __PB_proc_ok  0
set __PB_loop_idx 0 ;# counter to prevent infinite loop
if 0 {
if [catch { eval [join $__PB_tmp_proc_data \n] } __PB_res] {
if { ![string match "*no such variable*" $__PB_res]} {
set __PB_proc_ok -1
}
}
}
if { [info exists gPB(custom_command_eval_iter)] && \
$gPB(custom_command_eval_iter) > 0 } {
set __PB_n_iter  $gPB(custom_command_eval_iter)
} else {
set __PB_n_iter 20
}
set __PB_res_prev ""
PB_mom_DisguiseTclCmds_1
set Post::($post_object,unk_cmd_list) [list]
while { $__PB_proc_ok == 0 } {
PB_mom_DisguiseTclCmds_2
if [catch { eval [join $__PB_tmp_proc_data \n] } __PB_res] {
set __PB_res_more $errorInfo
UI_PB_debug_ForceMsg "Command Syntax Error : $__PB_res"
PB_mom_RestoreTclCmds_2
if [string match "$__PB_res_prev" $__PB_res] {
set __PB_proc_ok 1
continue
}
if [string match "*variable*exists*" $__PB_res] {
set __PB_idx [lsearch $__PB_res "variable"]
if { $__PB_idx >= 0 } {
set __PB_var [lindex $__PB_res [expr $__PB_idx + 1]]
set __PB_var [string trim $__PB_var "\""]
if [info exists $__PB_var] {
unset $__PB_var
}
}
} elseif { [string match "*no such variable*" $__PB_res] || \
[string match "*no such element*" $__PB_res] } {
set __PB_idx [string first ":" $__PB_res]
if { $__PB_idx >= 0 } {
set __PB_res1 [string range $__PB_res 0 [expr $__PB_idx - 1]]
set __PB_var  [lindex $__PB_res1 end]
set __PB_var  [string trim $__PB_var "\""]
if { [string index $__PB_var [expr [string length $__PB_var] - 1]] == ")" } {
set __PB_idx [string first "(" $__PB_var]
set __PB_this_var [string range $__PB_var 0 [expr $__PB_idx - 1]]
} else {
set __PB_this_var $__PB_var
}
if { ![string match "*\$$__PB_this_var*" $__PB_tmp_proc_data]} {
global $__PB_this_var
set $__PB_var 0 ;#<11-05-01 gsl> 1 was 0.
} else { ;# Variable used by current proc.
set __PB_var_is_global 0
foreach __PB_e $__PB_tmp_proc_data {
if [string match "*global*$__PB_this_var*" $__PB_e] {
UI_PB_debug_ForceMsg "Unknown var $__PB_this_var ==> Found $__PB_e"
set __PB_var_is_global 1
break
}
}
foreach __PB_e $__PB_tmp_proc_data {
if [string match "*gets * $__PB_this_var*" $__PB_e] {
UI_PB_debug_ForceMsg "Unknown var $__PB_this_var ==> Found $__PB_e ==> Set global $__PB_this_var"
set __PB_var_is_global 1
global $__PB_this_var
break
}
}
lappend gPB(CMD_VAR_LIST) $__PB_this_var
if { [llength $args] && [lindex $args 0] == "exp" } {
UI_PB_debug_ForceMsg "Unknown var $__PB_this_var in expression ==> Set global $__PB_this_var"
set __PB_var_is_global 1
global $__PB_this_var
}
if $__PB_var_is_global {
if [catch { set $__PB_var 0 } __PB_res] {
set __PB_proc_ok -1
continue
}
} else {
if $gPB(check_cc_syntax_error) {
set __PB_proc_ok -1
set __PB_idx [string first "body line" $__PB_res_more]
if { $__PB_idx >= 0 } {
set __PB_idx      [string wordend $__PB_res_more $__PB_idx];# body
set __PB_idx      [expr $__PB_idx + 1];# Skip a space
set __PB_idx      [string wordend $__PB_res_more $__PB_idx];# line
set __PB_idx      [expr $__PB_idx + 1]
set __PB_idx2     [string wordend $__PB_res_more $__PB_idx]
set __PB_line_num [string range $__PB_res_more $__PB_idx [expr $__PB_idx2 - 1]]
if { $__PB_line_num > 0 } {
set __PB_ii 1
foreach __PB_e $__PB_tmp_proc_data {
if { $__PB_ii > $__PB_line_num } { break }
set __PB_e [string trim $__PB_e]
if { ![string match "" $__PB_e] && \
![string match "\#*" $__PB_e] } {
if 0 {
if { [string match "*set *$__PB_this_var *" $__PB_e] || \
[string match "*gets * $__PB_this_var" $__PB_e] || \
[string match "*gets * $__PB_this_var *" $__PB_e] } {}
}
if { [string match "*set *$__PB_this_var *"    $__PB_e] || \
[string match "*set *$__PB_this_var\(* *" $__PB_e] || \
[string match "*gets * $__PB_this_var"    $__PB_e] || \
[string match "*gets * $__PB_this_var *"  $__PB_e] } {
UI_PB_debug_ForceMsg "Unknown var @ line $__PB_line_num : $__PB_var \
==> Found @ line $__PB_ii : $__PB_e \
==> Set global $__PB_this_var"
global $__PB_this_var
set $__PB_var 0
set __PB_proc_ok 0
break
}
incr __PB_ii
}
}
}
}
continue
} else {
set $__PB_var 0 ;#<11-05-01 gsl> 1 was 0.
}
}
}
} else {
if $gPB(check_cc_syntax_error) {
set __PB_proc_ok -1
} else {
set __PB_proc_ok 1
}
continue
}
} elseif [string match "*invalid command name*" $__PB_res] {
if 0 {
set __PB_var [lindex $__PB_res end]
set __PB_var [string trim $__PB_var "\""]
}
set __PB_bail 0
if [catch { set __PB_var [lindex $__PB_res end] }] {
if $gPB(check_cc_syntax_error) {
set __PB_proc_ok -1
}
set __PB_bail 1
} else {
set __PB_var [string trim $__PB_var "\""]
}
if { !$__PB_bail } {
if { [llength $__PB_var] > 1 } {
if $gPB(check_cc_syntax_error) {
set __PB_proc_ok -1
}
set __PB_bail 1
}
}
if $__PB_bail {
if { $__PB_proc_ok == 0 } { set __PB_proc_ok 1 }
continue
}
if $gPB(check_cc_unknown_command) {
if { [lsearch $Post::($post_object,unk_cmd_list) $__PB_var] < 0  && \
[lsearch $Post::($post_object,ass_cmd_list) $__PB_var] < 0 } {
lappend Post::($post_object,unk_cmd_list) $__PB_var
}
}
proc $__PB_var { args } { return 1 }
lappend __PB_tmp_proc_list $__PB_var
} else {
if $gPB(check_cc_syntax_error) {
set __PB_proc_ok -1
}
}
} else {
set __PB_proc_ok 1
}
incr __PB_loop_idx
if { $__PB_loop_idx > $__PB_n_iter } { set __PB_proc_ok 1 }
set __PB_res_prev $__PB_res
PB_mom_RestoreTclCmds_2
}
PB_mom_RestoreTclCmds_1
if [info exists __PB_tmp_proc_list] {
foreach __PB_p $__PB_tmp_proc_list {
rename $__PB_p ""
}
unset __PB_tmp_proc_list
}
if [llength $uplevel_script] {
if [string match "*global *" $uplevel_script] {
set __PB_proc_ok -1
set __PB_res_more "Variables should not be declared as global\
within a uplevel #0 scope!"
}
}
if { $__PB_proc_ok == 1 } {
if { [PB_is_v3] >= 0 } {
if { [string match "PB_CMD_init_multiple_post" $__PB_cmd_name]  || \
[string match "PB_CMD_multiple_post_initialize" $__PB_cmd_name] } {
uplevel 1 { ;# mom_sys_postname is defined in a uplevel scope from a PB_CMD.
global post_object
if [info exists mom_sys_postname] {
array set mom_sys_var $Post::($post_object,mom_sys_var_list)
set mom_sys_var(\$mom_sys_postname_list) [array get mom_sys_postname]
set Post::($post_object,mom_sys_var_list) [array get mom_sys_var]
unset mom_sys_postname
}
}
}
if { [string match "PB_CMD_init_mill_turn" $__PB_cmd_name]  || \
[string match "PB_CMD_kin_mill_turn_initialize" $__PB_cmd_name] } {
if 1 { ;# These vars were not defined in an uplevel scope.
global post_object
array set mom_sys_var $Post::($post_object,mom_sys_var_list)
if [info exists post_links] { unset post_links }
global mom_sys_mill_turn_type
if [info exists mom_sys_mill_turn_type] {
if [string match "SIMPLE_MILL_TURN" $mom_sys_mill_turn_type] {
set post_links {MILL this_post TURN lathe_tool_tip}
}
set mom_sys_var(\$mom_sys_mill_turn_type) $mom_sys_mill_turn_type
unset mom_sys_mill_turn_type
}
global mom_sys_lathe_postname
if [info exists mom_sys_lathe_postname] {
set lathe_post_name [file rootname [file tail $mom_sys_lathe_postname]]
if [info exists post_links] {
set post_links [lreplace $post_links 3 3 $lathe_post_name]
}
set mom_sys_var(\$mom_sys_lathe_postname) $lathe_post_name
unset mom_sys_lathe_postname
}
if [info exists post_links] {
set mom_sys_var(\$mom_sys_postname_list) $post_links
}
set Post::($post_object,mom_sys_var_list) [array get mom_sys_var]
}
}
if { [string match "PB_CMD_init_mill_xzc"     $__PB_cmd_name] || \
[string match "PB_CMD_kin_mill_xzc_init" $__PB_cmd_name] } {
uplevel 1 {
global post_object
array set mom_sys_var $Post::($post_object,mom_sys_var_list)
array set mom_kin_var $Post::($post_object,mom_kin_var_list)
if [info exists mom_sys_spindle_axis] {
set spindle_axis "Z_AXIS"
if { [expr $mom_sys_spindle_axis(0) == 1.0] && \
[expr $mom_sys_spindle_axis(1) == 0.0] && \
[expr $mom_sys_spindle_axis(2) == 0.0] } {
set spindle_axis "+X_AXIS"
}
if { [expr $mom_sys_spindle_axis(0) == -1.0] && \
[expr $mom_sys_spindle_axis(1) == 0.0] && \
[expr $mom_sys_spindle_axis(2) == 0.0] } {
set spindle_axis "-X_AXIS"
}
if { [expr $mom_sys_spindle_axis(0) == 0.0] && \
[expr $mom_sys_spindle_axis(1) == 1.0] && \
[expr $mom_sys_spindle_axis(2) == 0.0] } {
set spindle_axis "Y_AXIS"
}
if { [expr $mom_sys_spindle_axis(0) == 0.0] && \
[expr $mom_sys_spindle_axis(1) == 0.0] && \
[expr $mom_sys_spindle_axis(2) == 1.0] } {
set spindle_axis "Z_AXIS"
}
set mom_sys_var(\$mill_turn_spindle_axis) $spindle_axis
unset mom_sys_spindle_axis
}
if [info exists mom_sys_radius_output_mode] {
set mom_sys_var(\$mom_sys_radius_output_mode) $mom_sys_radius_output_mode
unset mom_sys_radius_output_mode
}
if [info exists mom_sys_millturn_yaxis] {
set mom_sys_var(\$mom_sys_millturn_yaxis) $mom_sys_millturn_yaxis
unset mom_sys_millturn_yaxis
}
if [info exists mom_sys_coordinate_output_mode] {
set mom_sys_var(\$mom_sys_coordinate_output_mode) $mom_sys_coordinate_output_mode
unset mom_sys_coordinate_output_mode
}
if [info exists mom_kin_4th_axis_direction] {
set mom_kin_var(\$mom_kin_4th_axis_direction) $mom_kin_4th_axis_direction
unset mom_kin_4th_axis_direction
}
if [info exists mom_kin_4th_axis_min_limit] {
set mom_kin_var(\$mom_kin_4th_axis_min_limit) $mom_kin_4th_axis_min_limit
unset mom_kin_4th_axis_min_limit
}
if [info exists mom_kin_4th_axis_max_limit] {
set mom_kin_var(\$mom_kin_4th_axis_max_limit) $mom_kin_4th_axis_max_limit
unset mom_kin_4th_axis_max_limit
}
if [info exists mom_kin_4th_axis_leader] {
set mom_kin_var(\$mom_kin_4th_axis_leader) $mom_kin_4th_axis_leader
unset mom_kin_4th_axis_leader
}
if [info exists mom_kin_linearization_tol] {
set mom_kin_var(\$mom_kin_linearization_tol) $mom_kin_linearization_tol
unset mom_kin_linearization_tol
}
if [info exists mom_sys_leader(fourth_axis)] {
set mom_sys_var(\$mom_sys_leader(fourth_axis)) $mom_sys_leader(fourth_axis)
unset mom_sys_leader(fourth_axis)
}
set Post::($post_object,mom_sys_var_list) [array get mom_sys_var]
set Post::($post_object,mom_kin_var_list) [array get mom_kin_var]
}
}
}
}
if { $__PB_proc_ok != 1 } {
set errorInfo $__PB_res_more
set __PB_idx [string last "invoked from within" $errorInfo]
if { $__PB_idx > 0 } {
set __PB_res [string range $errorInfo 0 [expr $__PB_idx - 1]]
} else {
set __PB_res $errorInfo
}
set __PB_res "Error found in \"$__PB_cmd_name\" : \n\n\
$__PB_res"
if 0 {
if { [llength $args] && [lindex $args 0] == "saving_post" } {
set __PB_res "Error found in Custom Command  \"$__PB_cmd_name\" : \n\n\
$__PB_res"
} else {
set __PB_res "Error found in Custom Command  \"$__PB_cmd_name\" : \n\n\
$__PB_res \n$gPB(cust_cmd,error,msg)"
}
}
set __PB_proc_ok 0 ;# Error
}
return $__PB_proc_ok
}
proc PB_pps_ValidateAllCustCmd { args } {
global post_object
Post::GetObjList $post_object command cmd_blk_list
foreach cc $cmd_blk_list {
command::readvalue $cc attr
set proc_state [PB_proc_ValidateCustCmd $attr(0) $attr(1) res]
if { $proc_state <= 0 } {
return $proc_state
}
}
}


