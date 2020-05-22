#18
set gPB(no_output_events_list) {"Tool Change" "Inch Metric Mode" Feedrates Opskip}
proc PB_pui_ReadPuiCreateObjs {OBJECT POST_OBJ} {
upvar $OBJECT object
upvar $POST_OBJ post_obj
global gPB
set event_handler 0
set post_info_start 0
set description_start 0
set controller_start 0
set history_start 0
set list_file_start 0
set kinematic_var_start 0
set master_sequence_start 0
set gcode_start 0
set mcode_start 0
set glob_sequence_start 0
set evt_ui_start 0
set mom_sys_var_start 0
set comp_blk_start 0
set blk_mod_start 0
set cycle_evt_start 0
set cycle_com_evt_start 0
set cycle_share_evt_start 0
set sequence_start 0
set sequence_word_status_start 0
set prog_start_seq 0
set oper_start_seq 0
set tool_path_seq 0
set tpth_ctrl_seq 0
set tpth_mot_seq 0
set tpth_cycle_seq 0
set oper_end_seq 0
set prog_end_seq 0
set linked_posts_seq 0
set vnc_seq 0
if { ![info exists Post::($post_obj,virtual_nc_evt_list)] } {
set Post::($post_obj,virtual_nc_evt_list)       [list]
}
if { ![info exists Post::($post_obj,virtual_nc_evt_blk_list)] } {
set Post::($post_obj,virtual_nc_evt_blk_list)   [list]
}
if { ![info exists Post::($post_obj,virtual_nc_label_list)] } {
set Post::($post_obj,virtual_nc_label_list)     [list]
}
set index 0
set merge_marker 0
if { [info exists gPB(pui_marker_merge)]  &&  $gPB(pui_marker_merge) } {
set merge_marker 1
}
set pui_dir ""
set post_files(def_file) ""
set post_files(tcl_file) ""
Post::SetPostFiles $post_obj pui_dir post_files
while { [gets $File::($object,FilePointer) line] >= 0 } \
{
UI_PB_debug_DisplayMsg $line
set line_length [string length $line]
set dummy_line [string trim $line]
if { $description_start == 0 } {
if { [string length $dummy_line] == 0 } { continue }
}
set last_char_test [string index $line [expr $line_length - 1]]
if {[string compare $last_char_test \\] == 0} \
{
set line_with_space [string range $line 0 [expr $line_length - 2]]
append temp_line [string trimleft $line_with_space " "]
continue
} elseif { [info exists temp_line] } \
{
append temp_line [string trimleft $line " "]
set line $temp_line
unset temp_line
}
switch -glob -- "$line"\
{
"## POST EVENT HANDLER START"    {
set event_handler 1
continue
}
"## POST EVENT HANDLER END"      {
set event_handler 0
set pui_file_name $File::($object,FileName)
set pui_dir [file dirname $pui_file_name]
Post::SetPostFiles $post_obj pui_dir post_files
unset post_files
continue
}
"## POST INFORMATION START"      {
set post_info_start 1
continue
}
"## POST INFORMATION END"        {
set post_info_start 0
continue
}
"## LISTING FILE START"          {
set list_file_start 1
continue
}
"## LISTING FILE END"            {
set list_file_start 0
if [info exists obj_attr] \
{
PB_lfl_CreateLfileObj obj_attr obj_list
Post::ListFileObject $post_obj obj_list
unset obj_attr
}
continue
}
"## KINEMATIC VARIABLES START"   {
set kinematic_var_start 1
if [info exists Post::($post_obj,mom_kin_var_list)] \
{
array set mom_kin_var $Post::($post_obj,mom_kin_var_list)
}
continue
}
"## KINEMATIC VARIABLES END"     {
set kinematic_var_start 0
if [info exists mom_kin_var] \
{
set Post::($post_obj,mom_kin_var_list) \
[array get mom_kin_var]
set Post::($post_obj,def_mom_kin_var_list) \
[array get mom_kin_var]
unset mom_kin_var
}
continue
}
"## GCODES START"                {
set gcode_start 1
set gcd_ind 0
if [info exists Post::($post_obj,g_codes)] \
{
array set g_codes       $Post::($post_obj,g_codes)
array set g_codes_desc  $Post::($post_obj,g_codes_desc)
set gcd_ind [array size g_codes]
set len [llength $Post::($post_obj,g_codes)]
for {set i 1} {$i < $len} {incr i 2} {
set code [lindex $Post::($post_obj,g_codes) $i]
set desc [lindex $Post::($post_obj,g_codes_desc) $i]
set g_codes_arr($code) $desc
}
}
continue
}
"## GCODES END"                  {
set gcode_start 0
if [info exists g_codes] \
{
Post::InitG-Codes $post_obj g_codes g_codes_desc
unset g_codes
unset g_codes_desc
unset g_codes_arr
}
continue
}
"## MCODES START"                {
set mcode_start 1
set mcd_ind 0
if [info exists Post::($post_obj,m_codes)] \
{
array set m_codes       $Post::($post_obj,m_codes)
array set m_codes_desc  $Post::($post_obj,m_codes_desc)
set mcd_ind [array size m_codes]
set len [llength $Post::($post_obj,m_codes)]
if $len {
for {set i 1} {$i < $len} {incr i 2} {
set code [lindex $Post::($post_obj,m_codes) $i]
set desc [lindex $Post::($post_obj,m_codes_desc) $i]
set m_codes_arr($code) $desc
}
}
}
continue
}
"## MCODES END"                  {
set mcode_start 0
if [info exists m_codes] {
Post::InitM-Codes $post_obj m_codes m_codes_desc
unset m_codes
unset m_codes_desc
unset m_codes_arr
}
continue
}
"## MASTER SEQUENCE START"       {
set master_sequence_start 1
set index -1
set pre_index -1
if [info exists Post::($post_obj,msq_word_param)] \
{
array set msq_word_param  $Post::($post_obj,msq_word_param)
set msq_add_name          $Post::($post_obj,msq_add_name)
}
continue
}
"## MASTER SEQUENCE END"         {
set master_sequence_start 0
set index 0
if [info exists new_msq_add_name] {
if [info exists msq_add_name] {
foreach msq $msq_add_name {
lappend new_msq_add_name $msq
set new_msq_word_param($msq) $msq_word_param($msq)
}
unset msq_add_name
unset msq_word_param
}
Post::InitMasterSequence $post_obj new_msq_add_name \
new_msq_word_param
update idletasks
unset new_msq_add_name
unset new_msq_word_param
if [info exists msq_add_name_buff] {
unset msq_add_name_buff
}
}
if [info exists msq_add_name_buff] \
{
append msq_add_name [concat $msq_add_name_buff]
unset msq_add_name_buff
}
if [info exists msq_add_name] \
{
Post::InitMasterSequence $post_obj msq_add_name \
msq_word_param
update idletasks
unset msq_add_name
unset msq_word_param
}
continue
}
"## CYCLE EVENT START"           {
set cycle_evt_start 1
continue
}
"## CYCLE EVENT END"             {
set cycle_evt_start 0
continue
}
"## BLOCK MODALITY START"        {
set blk_mod_start 1
if { [info exists Post::($post_obj,blk_mod_list)] && \
$Post::($post_obj,blk_mod_list) != "" } \
{
array set blk_mod_arr $Post::($post_obj,blk_mod_list)
}
continue
}
"## BLOCK MODALITY END"          {
set blk_mod_start 0
if [info exists blk_mod_arr] \
{
set Post::($post_obj,blk_mod_list) [array get blk_mod_arr]
unset blk_mod_arr
} else \
{
set Post::($post_obj,blk_mod_list) ""
}
continue
}
"## COMPOSITE BLOCKS START"      {
set comp_blk_start 1
continue
}
"## COMPOSITE BLOCKS END"        {
set comp_blk_start 0
continue
}
"## SEQUENCE START"              {
set glob_sequence_start 1
continue
}
"## SEQUENCE END"                {
set glob_sequence_start 0
continue
}
"## EVENTS USER INTERFACE START" {
set evt_ui_start 1
set inx 0
set index -1
if [info exists Post::($post_obj,ui_evt_name_lis)] \
{
array set ui_evt_name_arr \
$Post::($post_obj,ui_evt_name_lis)
array set ui_evt_itm_grp_mem_arr \
$Post::($post_obj,ui_evt_itm_grp_mem_lis)
set inx [array size ui_evt_name_arr]
}
continue
}
"## EVENTS USER INTERFACE END"   {
set evt_ui_start 0
set index 0
if [info exists ui_evt_name_arr] \
{
set Post::($post_obj,ui_evt_name_lis) \
[array get ui_evt_name_arr]
set Post::($post_obj,ui_evt_itm_grp_mem_lis) \
[array get ui_evt_itm_grp_mem_arr]
unset ui_evt_name_arr
unset ui_evt_itm_grp_mem_arr
}
continue
}
"## MOM SYS VARIABLES START" {
set mom_sys_var_start 1
set add_mom_indx 0
set index -1
set mom_var_found 0
if [info exists Post::($post_obj,add_mom_var_list)] \
{
array set add_mom_var_list $Post::($post_obj,add_mom_var_list)
set mom_var_found 1
}
if [info exists Post::($post_obj,add_name_list)] \
{
array set add_name_list $Post::($post_obj,add_name_list)
set add_mom_indx [array size add_name_list]
set len [llength $Post::($post_obj,add_name_list)]
for {set i 1} {$i < $len} {incr i 2} {
set add [lindex $Post::($post_obj,add_name_list) $i]
if $mom_var_found {
set var [lindex $Post::($post_obj,add_mom_var_list) $i]
} else {
set var [list]
}
set add_mom_var_arr($add,idx) [lindex $Post::($post_obj,add_name_list) [expr $i - 1]]
set add_mom_var_arr($add,var) $var
}
}
continue
}
"## MOM SYS VARIABLES END" {
set mom_sys_var_start 0
set index 0
if [info exists add_name_list] \
{
array set mom_kin_var $Post::($post_obj,mom_kin_var_list)
array set mom_sys_var_arr $Post::($post_obj,mom_sys_var_list)
for {set i 0} {$i <= $add_mom_indx} {incr i} {
if [info exists add_name_list($i)] {
switch $add_name_list($i) {
"G_feed" -
"PB_Tcl_Var" -
"PB_Rapid" -
"PB_ZeroFmt" {
foreach e $add_mom_var_list($i) {
set var [lindex $e 0]
set val [lindex $e 1]
if { $var != "" && $val != "" } {
if { ![ catch {eval format %s "$val"} res ] } {
set mom_sys_var_arr($var) "$val"
}
}
}
}
}
}
}
for {set i 0} {$i <= $add_mom_indx} {incr i} {
if [info exists add_name_list($i)] {
switch $add_name_list($i) {
"I" -
"J" -
"K" {
if [info exists mom_sys_var_arr(\$mom_sys_cir_vector)] {
set machine [string tolower $mom_kin_var(\$mom_kin_machine_type)]
set mode $mom_sys_var_arr(\$mom_sys_cir_vector)
if [UI_PB_tpth_SetIJKExpr $machine $mode expr_i expr_j expr_k] {
UI_PB_tpth_SetIJKDesc $mode desc
if 0 {
switch $add_name_list($i) {
"I" {
set expr "$expr_i X-Axis"
}
"J" {
if { ![string match "lathe" $machine] } {
set expr "$expr_j Y-Axis"
} else {
set expr "Lathe Null Y-Axis"
}
}
"K" {
set expr "$expr_k Z-Axis"
}
}
}
switch $add_name_list($i) {
"I" {
set expr "$expr_i"
}
"J" {
if { ![string match "lathe" $machine] } {
set expr "$expr_j"
} else {
set expr "Lathe Null Y-Axis"
}
}
"K" {
set expr "$expr_k"
}
}
set add_mom_var_list($i) [list]
lappend add_mom_var_list($i) "\"$expr\""
lappend add_mom_var_list($i) "\"\""
lappend add_mom_var_list($i) "\"$desc\""
set add_mom_var_list($i) [list [join $add_mom_var_list($i)]]
if [string match "lathe" $machine] {
switch $add_name_list($i) {
"I" {
lappend add_mom_var_list($i) \
[list "\$mom_lathe_thread_lead_i" "" "$gPB(tool,ijk_desc,long_thread_lead,Label)"]
}
"K" {
lappend add_mom_var_list($i) \
[list "\$mom_lathe_thread_lead_k" "" "$gPB(tool,ijk_desc,tran_thread_lead,Label)"]
}
}
}
}
}
}
}
if 0 {
switch $add_name_list($i) {
"G_feed" -
"PB_Tcl_Var" -
"PB_Rapid" -
"PB_ZeroFmt" {
foreach e $add_mom_var_list($i) {
set var [lindex $e 0]
set val [lindex $e 1]
if { $var != "" && $val != "" } {
if { ![ catch {set val [eval format %s $val] } res ] } {
set mom_sys_var_arr($var) $val
}
}
}
}
}
}
}
}
set Post::($post_obj,mom_sys_var_list)     [array get mom_sys_var_arr]
set Post::($post_obj,def_mom_sys_var_list) [array get mom_sys_var_arr]
if 0 {{
for {set i 0} {$i < 4} {incr i} {
switch $i {
0 { set add "G_feed" }
1 { set add "PB_Tcl_Var" }
2 { set add "PB_Rapid" }
3 { set add "PB_ZeroFmt" }
}
PB_int_RetMOMVarAsscAddress add word_mom_var_list
PB_int_RetMOMVarDescAddress add word_desc_list
if [ info exists add_mom_var_arr($add,idx) ] \
{
foreach v $add_mom_var_arr($add,var) \
{
lappend word_mom_var_list [lindex $v 0]
lappend word_desc_list [lindex $v 2]
}
set word_mom_var_list [ltidy $word_mom_var_list]
set word_desc_list    [ltidy $word_desc_list]
}
}
PB_int_UpdateMOMVarOfAddress   add word_mom_var_list
PB_int_UpdateMOMVarDescAddress add word_desc_list
unset word_mom_var_list
unset word_desc_list
}}
set Post::($post_obj,add_name_list)    [array get add_name_list]
set Post::($post_obj,add_mom_var_list) [array get add_mom_var_list]
unset mom_kin_var
unset add_name_list
unset add_mom_var_list
unset add_mom_var_arr
}
set add_mom_indx 0
continue
}
}
if { $event_handler } \
{
PB_com_RemoveBlanks line
set file_type [lindex $line 0]
set file_name [join [lrange $line 1 end] " "]
switch $file_type \
{
def_file  { set post_files(def_file) $file_name }
tcl_file  { set post_files(tcl_file) $file_name }
}
}
if $post_info_start {
switch -glob -- $line \
{
"#  DESCRIPTION START"  {
set description_start 1
set post_info ""
continue
}
"#  DESCRIPTION END"    {
set description_start 0
set gPB(post_description) $post_info
set gPB(post_description_default) $post_info
unset post_info
continue
}
"#  CONTROLLER START"   {
set controller_start 1
set post_info ""
continue
}
"#  CONTROLLER END"     {
set controller_start 0
set gPB(post_controller) [join $post_info]
unset post_info
continue
}
"#  HISTORY START"      {
set history_start 1
set post_info ""
continue
}
"#  HISTORY END"        {
set history_start 0
set gPB(post_history) $post_info
unset post_info
continue
}
}
if { $description_start || $controller_start || $history_start } {
lappend post_info $line
}
}
if { $list_file_start } \
{
PB_com_RemoveBlanks line
set Name [lindex $line 0]
set Value [lindex $line 1]
switch $Name \
{
Listfileflag               {set obj_attr(listfile)   $Value}
Listfilename               {set obj_attr(fname)      $Value}
Listfileflag_head          {set obj_attr(head)       $Value}
Listfilelines              {set obj_attr(lines)      $Value}
Listfilecolumn             {set obj_attr(column)     $Value}
Listfileflag_oper          {set obj_attr(oper)       $Value}
Listfileflag_tool          {set obj_attr(tool)       $Value}
Listfileflag_start_path    {set obj_attr(start_path) $Value}
Listfileflag_tool_chng     {set obj_attr(tool_chng)  $Value}
Listfileflag_end_path      {set obj_attr(end_path)   $Value}
Listfileflag_oper_time     {set obj_attr(oper_time)  $Value}
Listfileflag_setup_time    {set obj_attr(setup_time) $Value}
Listfileflag_warn          {set obj_attr(warn)       $Value}
Listfileflag_lpt_ext       {set obj_attr(lpt_ext)    $Value}
Listfileflag_review        {set obj_attr(review)     $Value}
Listfileflag_group         {set obj_attr(group)      $Value}
Listfileflag_ncfile_ext    {set obj_attr(ncfile_ext) $Value}
Listfileflag_usertcl_check {set obj_attr(usertcl_check) $Value}
Listfileflag_usertcl_name  {set obj_attr(usertcl_name) $Value}
Listfileflag_verbose       {set obj_attr(verbose) $Value}
}
}
if { $kinematic_var_start } \
{
set var [lindex $line 0]
if { [string index $var 0] != "\$" } {
set var [format %s%s "\$" $var]
}
set mom_kin_var($var) [lindex $line 1]
}
if { $gcode_start } \
{
set var [lindex $line 0]
if { ![string match "*cycle_breakchip*" $var] } {
if { ![info exists g_codes_arr($var)] } {
set g_codes($gcd_ind)  [lindex $line 0]
set g_codes_desc($gcd_ind) [lindex $line 1]
incr gcd_ind
set g_codes_arr($var) [lindex $line 1]
}
}
}
if { $mcode_start } \
{
set var [lindex $line 0]
if { ![info exists m_codes_arr($var)] } {
set m_codes($mcd_ind)  [lindex $line 0]
set m_codes_desc($mcd_ind) [lindex $line 1]
incr mcd_ind
set m_codes_arr($var) [lindex $line 1]
}
}
if { $master_sequence_start } \
{
set mseq [lindex $line 0]
if [info exists msq_add_name] \
{
set index [lsearch $msq_add_name "$mseq"]
}
if { [info exists gPB(pui_ui_overwrite)]  &&  !$gPB(pui_ui_overwrite) } {
lappend new_msq_add_name $mseq
if [info exists msq_word_param($mseq)] {
set msq_param $msq_word_param($mseq)
unset msq_word_param($mseq)
set msq_add_name [lreplace $msq_add_name $index $index]
} else {
if { [llength $line] == 5 } {
lappend msq_param [lindex $line 1] [lindex $line 2] [lindex $line 3] [lindex $line 4]
} else {
lappend msq_param [lindex $line 1] [lindex $line 2] [lindex $line 3]
lappend msq_param 0
}
}
set msq_param [lreplace $msq_param 1 1 [lindex $line 2]]
set new_msq_word_param($mseq) $msq_param
} else {
if { $index < 0 } \
{
if { [llength $line] == 5 } \
{
lappend msq_add_name_buff $mseq
lappend msq_param [lindex $line 1] [lindex $line 2] \
[lindex $line 3] [lindex $line 4]
}
if { [llength $line] == 4 } \
{
lappend msq_add_name_buff $mseq
lappend msq_param [lindex $line 1] [lindex $line 2] [lindex $line 3]
lappend msq_param 0
}
} else \
{
if { $index < $pre_index } \
{
set msq_add_name [lreplace $msq_add_name $index $index]
set msq_add_name [linsert $msq_add_name $pre_index $mseq]
set index [lsearch $msq_add_name $mseq]
}
if [info exists msq_add_name_buff] \
{
set ml [llength $msq_add_name_buff]
for {set mi [expr $ml - 1]} {$mi > -1} {incr mi -1} \
{
set me [lindex $msq_add_name_buff $mi]
set msq_add_name [linsert $msq_add_name $index $me]
}
unset msq_add_name_buff
set index [lsearch $msq_add_name $mseq]
}
if { [llength $line] == 5 } \
{
lappend msq_param [lindex $line 1] [lindex $line 2] \
[lindex $line 3] [lindex $line 4]
}
}
if [info exists msq_param] \
{
set msq_word_param($mseq) $msq_param
}
set pre_index $index
}
if [info exists msq_param] \
{
unset msq_param
}
}
if { $blk_mod_start } \
{
set blk_mod_arr([lindex $line 0]) [lindex $line 1]
}
if { $comp_blk_start } \
{
if [info exists Post::($post_obj,comp_blk_list)] \
{
set Post::($post_obj,comp_blk_list) \
[PB_com_MergeLists $Post::($post_obj,comp_blk_list) $line]
} else \
{
set Post::($post_obj,comp_blk_list) $line
}
}
if { $cycle_evt_start } \
{
switch -glob -- "$line" \
{
"#Cycle Common Block Start"              {
set cycle_com_evt_start 1
continue
}
"#Cycle Common Block End"                {
set cycle_com_evt_start 0
if [info exists cycle_common_evt] \
{
set Post::($post_obj,cyl_com_evt) \
$cycle_common_evt
}
continue
}
"#Cycle Block Share Common Block Start"  {
set cycle_share_evt_start 1
continue
}
"#Cycle Block Share Common Block End"    {
set cycle_share_evt_start 0
if [info exists cycle_shared_evts] \
{
set Post::($post_obj,cyl_evt_sh_com_evt) \
$cycle_shared_evts
}
continue
}
}
if { $cycle_com_evt_start } \
{
set cycle_common_evt $line
}
if { $cycle_share_evt_start } \
{
set cycle_shared_evts $line
}
}
if { $glob_sequence_start } \
{
switch -glob -- "$line" \
{
"#Program Start Sequence Start"     {
set prog_start_seq 1
set index 0
if $merge_marker {
if [info exists Post::($post_obj,prog_start_evt_list)] {
array set evt_name_arr  $Post::($post_obj,prog_start_evt_list)
array set evt_blk_arr   $Post::($post_obj,prog_start_evt_blk_list)
array set evt_label_arr $Post::($post_obj,prog_start_label_list)
set index [expr [llength $Post::($post_obj,prog_start_evt_list)] / 2]
for { set i 0 } { $i < $index } { incr i } {
set evt [join [split $evt_name_arr($i)] _]
set Marker($evt,blk_list) $evt_blk_arr($i)
set Marker($evt,index)    $i
}
}
}
continue
}
"#Program Start Sequence End"       {
set prog_start_seq 0
set Post::($post_obj,prog_start_evt_list) \
[array get evt_name_arr]
set Post::($post_obj,prog_start_label_list) \
[array get evt_label_arr]
set Post::($post_obj,prog_start_evt_blk_list) \
[array get evt_blk_arr]
if [info exists evt_name_arr] \
{
unset evt_name_arr
unset evt_label_arr
unset evt_blk_arr
}
continue
}
"#Operation Start Sequence Start"   {
set oper_start_seq 1
set index 0
if $merge_marker {
if [info exists Post::($post_obj,oper_start_evt_list)] {
array set evt_name_arr  $Post::($post_obj,oper_start_evt_list)
array set evt_blk_arr   $Post::($post_obj,oper_start_evt_blk_list)
array set evt_label_arr $Post::($post_obj,oper_start_label_list)
set index [expr [llength $Post::($post_obj,oper_start_evt_list)] / 2]
for { set i 0 } { $i < $index } { incr i } {
set evt [join [split $evt_name_arr($i)] _]
set Marker($evt,blk_list) $evt_blk_arr($i)
set Marker($evt,index)    $i
}
}
}
continue
}
"#Operation Start Sequence End"     {
set oper_start_seq 0
if [info exists evt_name_arr] \
{
set Post::($post_obj,oper_start_evt_list) \
[array get evt_name_arr]
set Post::($post_obj,oper_start_label_list) \
[array get evt_label_arr]
set Post::($post_obj,oper_start_evt_blk_list) \
[array get evt_blk_arr]
unset evt_name_arr
unset evt_label_arr
unset evt_blk_arr
}
continue
}
"##Tool Path Start"                 {
set tool_path_seq 1
continue
}
"##Tool Path End"                   {
set tool_path_seq 0
continue
}
"#Operation End Sequence Start"     {
set oper_end_seq 1
set index 0
if $merge_marker {
if [info exists Post::($post_obj,oper_end_evt_list)] {
array set evt_name_arr  $Post::($post_obj,oper_end_evt_list)
array set evt_blk_arr   $Post::($post_obj,oper_end_evt_blk_list)
array set evt_label_arr $Post::($post_obj,oper_end_label_list)
set index [expr [llength $Post::($post_obj,oper_end_evt_list)] / 2]
for { set i 0 } { $i < $index } { incr i } {
set evt [join [split $evt_name_arr($i)] _]
set Marker($evt,blk_list) $evt_blk_arr($i)
set Marker($evt,index)    $i
}
}
}
continue
}
"#Operation End Sequence End"       {
set oper_end_seq 0
if [info exists evt_name_arr] \
{
set Post::($post_obj,oper_end_evt_list) \
[array get evt_name_arr]
set Post::($post_obj,oper_end_label_list) \
[array get evt_label_arr]
set Post::($post_obj,oper_end_evt_blk_list) \
[array get evt_blk_arr]
unset evt_name_arr
unset evt_label_arr
unset evt_blk_arr
}
continue
}
"#Program End Sequence Start"       {
set prog_end_seq 1
set index 0
if $merge_marker {
if [info exists Post::($post_obj,prog_end_evt_list)] {
array set evt_name_arr  $Post::($post_obj,prog_end_evt_list)
array set evt_blk_arr   $Post::($post_obj,prog_end_evt_blk_list)
array set evt_label_arr $Post::($post_obj,prog_end_label_list)
set index [expr [llength $Post::($post_obj,prog_end_evt_list)] / 2]
for { set i 0 } { $i < $index } { incr i } {
set evt [join [split $evt_name_arr($i)] _]
set Marker($evt,blk_list) $evt_blk_arr($i)
set Marker($evt,index)    $i
}
}
}
continue
}
"#Program End Sequence End"         {
set prog_end_seq 0
if [info exists evt_name_arr] \
{
set Post::($post_obj,prog_end_evt_list) \
[array get evt_name_arr]
set Post::($post_obj,prog_end_label_list) \
[array get evt_label_arr]
set Post::($post_obj,prog_end_evt_blk_list) \
[array get evt_blk_arr]
unset evt_name_arr
unset evt_label_arr
unset evt_blk_arr
}
continue
}
"#Linked Posts Sequence Start"     {
set linked_posts_seq 1
set index 0
set Post::($post_obj,linked_posts_evt_list)     [list]
set Post::($post_obj,linked_posts_evt_blk_list) [list]
set Post::($post_obj,linked_posts_label_list)   [list]
if $merge_marker {
if [info exists Post::($post_obj,linked_posts_evt_list)] {
array set evt_name_arr  $Post::($post_obj,linked_posts_evt_list)
array set evt_blk_arr   $Post::($post_obj,linked_posts_evt_blk_list)
array set evt_label_arr $Post::($post_obj,linked_posts_label_list)
set index [expr [llength $Post::($post_obj,linked_posts_evt_list)] / 2]
for { set i 0 } { $i < $index } { incr i } {
set evt [join [split $evt_name_arr($i)] _]
set Marker($evt,blk_list) $evt_blk_arr($i)
set Marker($evt,index)    $i
}
}
}
continue
}
"#Linked Posts Sequence End"       {
set linked_posts_seq 0
if [info exists evt_name_arr] \
{
set Post::($post_obj,linked_posts_evt_list) \
[array get evt_name_arr]
set Post::($post_obj,linked_posts_label_list) \
[array get evt_label_arr]
set Post::($post_obj,linked_posts_evt_blk_list) \
[array get evt_blk_arr]
unset evt_name_arr
unset evt_label_arr
unset evt_blk_arr
}
continue
}
"#Virtual NC Sequence Start" { ;#<03-12-03 gsl> IS&V VNC
set vnc_seq 1
set index 0
continue
}
"#Virtual NC Sequence End" {
set vnc_seq 0
if [info exists evt_name_arr] \
{
set Post::($post_obj,virtual_nc_evt_list)       [array get evt_name_arr]
set Post::($post_obj,virtual_nc_evt_blk_list)   [array get evt_blk_arr]
set Post::($post_obj,virtual_nc_label_list)     [array get evt_label_arr]
unset evt_name_arr
unset evt_label_arr
unset evt_blk_arr
}
continue
}
}
if { $prog_start_seq || $oper_start_seq || $oper_end_seq || $prog_end_seq } \
{
set evt [join [split [lindex $line 0]] _]
if { $merge_marker && \
[info exists Marker($evt,blk_list)] } {
set idx $Marker($evt,index)
set blk_list $Marker($evt,blk_list)
foreach blk [lindex $line 1] {
lappend blk_list $blk
}
set evt_blk_arr($idx) $blk_list
} else {
set evt_name_arr($index) [lindex $line 0]
set evt_blk_arr($index)  [lindex $line 1]
set evt_label_arr($index) [lindex $line 0]
if { [llength $line] == 3  &&  [string length [lindex $line 2]] } {
set evt_label_arr($index) [lindex $line 2]
}
incr index
}
} elseif { $tool_path_seq } \
{
switch -glob -- "$line" \
{
"#Control Functions Start"          {
set tpth_ctrl_seq 1
set index 0
continue
}
"#Control Functions End"            {
set tpth_ctrl_seq 0
if [info exists evt_name_arr] \
{
set Post::($post_obj,tpth_ctrl_evt_list) \
[array get evt_name_arr]
set Post::($post_obj,tpth_ctrl_label_list) \
[array get evt_label_arr]
set Post::($post_obj,tpth_ctrl_evt_blk_list) \
[array get evt_blk_arr]
unset evt_name_arr
unset evt_label_arr
unset evt_blk_arr
}
continue
}
"#Motions Start"                    {
set tpth_mot_seq 1
set index 0
continue
}
"#Motions End"                      {
set tpth_mot_seq 0
if [info exists evt_name_arr] \
{
set Post::($post_obj,tpth_mot_evt_list) \
[array get evt_name_arr]
set Post::($post_obj,tpth_mot_label_list) \
[array get evt_label_arr]
set Post::($post_obj,tpth_mot_evt_blk_list) \
[array get evt_blk_arr]
unset evt_name_arr
unset evt_label_arr
unset evt_blk_arr
}
continue
}
"#Cycles Start"                     {
set tpth_cycle_seq 1
set index 0
continue
}
"#Cycles End"                       {
set tpth_cycle_seq 0
if [info exists evt_name_arr] \
{
set Post::($post_obj,tpth_cycle_evt_list) \
[array get evt_name_arr]
set Post::($post_obj,tpth_cycle_label_list) \
[array get evt_label_arr]
set Post::($post_obj,tpth_cycle_evt_blk_list) \
[array get evt_blk_arr]
unset evt_name_arr
unset evt_blk_arr
unset evt_label_arr
}
continue
}
}
if { $tpth_ctrl_seq || $tpth_mot_seq || $tpth_cycle_seq } \
{
set evt_name [lindex $line 0]
set evt_name_arr($index) $evt_name
if { [lsearch $gPB(no_output_events_list) "$evt_name"] < 0 } {
set evt_blk_arr($index) [lindex $line 1]
} else {
set evt_blk_arr($index) {}
}
set evt_label_arr($index) [lindex $line 0]
if { [llength $line] == 3  &&  [string length [lindex $line 2]] } \
{
set evt_label_arr($index) [lindex $line 2]
}
incr index
}
} elseif { $linked_posts_seq } \
{
set evt_name [lindex $line 0]
set evt_name_arr($index) $evt_name
if { [lsearch $gPB(no_output_events_list) "$evt_name"] < 0 } {
set evt_blk_arr($index) [lindex $line 1]
} else {
set evt_blk_arr($index) {}
}
set evt_label_arr($index) [lindex $line 0]
if { [llength $line] == 3  &&  [string length [lindex $line 2]] } {
set evt_label_arr($index) [lindex $line 2]
}
incr index
}
}
if { $evt_ui_start } \
{
set evar [lindex $line 0]
set index -1
if [info exists ui_evt_name_arr] \
{
foreach e [array names ui_evt_name_arr] \
{
if { $evar == $ui_evt_name_arr($e) } \
{
set index $e
break
}
}
}
if { $evar != "" } \
{
if { $index == -1 } \
{
set ui_evt_name_arr($inx) $evar
if [string length [lindex $line 1]] \
{
set ui_evt_itm_grp_mem_arr($inx) [lrange $line 1 end]
}
incr inx
} else \
{
if { [info exists gPB(pui_ui_overwrite)]  &&  $gPB(pui_ui_overwrite) } {
set ui_evt_itm_grp_mem_arr($index) [lrange $line 1 end]
}
}
}
}
if {$mom_sys_var_start} \
{
set mvar [lindex $line 0]
set index -1
set line_val [lrange $line 1 end]
if { ![info exists add_mom_var_arr($mvar,var)] } \
{
set add_name_list($add_mom_indx) $mvar
set add_mom_var_list($add_mom_indx) $line_val
set add_mom_var_arr($mvar,var) $add_mom_var_list($add_mom_indx)
set add_mom_var_arr($mvar,idx) $add_mom_indx
incr add_mom_indx
} elseif { [llength $add_mom_var_arr($mvar,var)] == 0 } \
{
set index add_mom_var_arr($mvar,idx)
set add_mom_var_list($index) $line_val
set add_mom_var_arr($mvar,var) $add_mom_var_list($index)
} else \
{
set index $add_mom_var_arr($mvar,idx)
set res_list [PB_com_MergeListsOfMultiples 3 $add_mom_var_list($index) $line_val]
set add_mom_var_list($index) $res_list
set add_mom_var_arr($mvar,var) $add_mom_var_list($index)
}
} ;# mom_sys_var_start
} ;# while reading each line
}
proc PB_pui_WritePuiFile { OUTPUT_PUI_FILE } {
upvar $OUTPUT_PUI_FILE pui_file
global post_object
global gPB
set puifid [open "$pui_file" w]
fconfigure $puifid -translation lf
puts $puifid "## POSTBUILDER_VERSION=$gPB(Postbuilder_PUI_Version)"
puts $puifid "##############################################################################"
puts $puifid "#                                                                            #"
puts $puifid "#  This file is used by Post Builder to edit the parameters associated       #"
puts $puifid "#  with a specific post processor.                                           #"
puts $puifid "#                                                                            #"
puts $puifid "#                                                                            #"
puts $puifid "#  <WARNING> The contents of this file should not be modified!               #"
puts $puifid "#                                                                            #"
puts $puifid "##############################################################################"
global env
set time_string [clock format [clock seconds] -format "%c %Z"]
puts $puifid "#  Created by $env(USERNAME) @ $time_string"
puts $puifid "#  with Post Builder version $gPB(Postbuilder_Release_Version)."
puts $puifid "#============================================================================#"
puts $puifid "\n"
Post::ReadPostOutputFiles $post_object dir out_pui_file def_file tcl_file
puts $puifid "## POST EVENT HANDLER START"
puts $puifid "def_file  $def_file"
puts $puifid "tcl_file  $tcl_file"
puts $puifid "## POST EVENT HANDLER END"
puts $puifid "\n"
puts $puifid "## POST INFORMATION START"
puts $puifid "#  DESCRIPTION START"
foreach s $gPB(post_description) {
puts $puifid "$s"
}
puts $puifid "#  DESCRIPTION END"
puts $puifid "#  CONTROLLER START"
puts $puifid "[join $gPB(post_controller)]"
puts $puifid "#  CONTROLLER END"
puts $puifid "#  HISTORY START"
foreach s $gPB(post_history) {
puts $puifid "$s"
}
puts $puifid "#  HISTORY END"
puts $puifid "## POST INFORMATION END"
puts $puifid "\n"
set listfile_obj $Post::($post_object,list_obj_list)
PB_pui_WriteListingFileData puifid listfile_obj
array set mom_kin_var $Post::($post_object,mom_kin_var_list)
PB_pui_WriteKinematicVariables puifid mom_kin_var
array set g_codes $Post::($post_object,g_codes)
array set g_codes_desc $Post::($post_object,g_codes_desc)
puts $puifid "## GCODES START"
PB_pui_WriteGMCodes puifid g_codes g_codes_desc
puts $puifid "## GCODES END\n"
array set m_codes $Post::($post_object,m_codes)
array set m_codes_desc $Post::($post_object,m_codes_desc)
puts $puifid "## MCODES START"
PB_pui_WriteGMCodes puifid m_codes m_codes_desc
puts $puifid "## MCODES END\n"
set add_obj_list $Post::($post_object,add_obj_list)
PB_pui_WriteMasterSeqData puifid add_obj_list
set cyl_com_evt $Post::($post_object,cyl_com_evt)
set cyl_sh_com_evt $Post::($post_object,cyl_evt_sh_com_evt)
PB_pui_WriteCycleComSharedEvts puifid cyl_com_evt cyl_sh_com_evt
set blk_obj_list $Post::($post_object,blk_obj_list)
PB_pui_WriteBlockModality puifid  blk_obj_list
PB_pui_WriteCompositeBlks puifid
set seq_obj_list $Post::($post_object,seq_obj_list)
PB_pui_WriteSeqEvents puifid seq_obj_list
PB_pui_WriteEventUIData puifid seq_obj_list
array set add_name_list $Post::($post_object,add_name_list)
array set word_desc_arr $Post::($post_object,word_desc_array)
array set word_mom_var $Post::($post_object,word_mom_var)
array set mom_var_arr $Post::($post_object,mom_sys_var_list)
PB_pui_WriteMOMVariables puifid add_name_list add_obj_list \
word_desc_arr word_mom_var mom_var_arr
close $puifid
}
proc PB_pui_WriteListingFileData { PUIFID LISTFILE_OBJ } {
upvar $PUIFID puifid
upvar $LISTFILE_OBJ listfile_obj
ListingFile::readvalue $listfile_obj obj_attr
set arr_names [array names obj_attr]
puts $puifid "## LISTING FILE START"
foreach var_name $arr_names \
{
switch $var_name\
{
"listfile"   {puts $puifid "[format "%-30s %s" Listfileflag \
$obj_attr(listfile)]"}
"fname"      {puts $puifid "[format "%-30s %s" Listfilename \
$obj_attr(fname)]"}
"head"       {puts $puifid "[format "%-30s %s" Listfileflag_head \
$obj_attr(head)]"}
"lines"      {puts $puifid "[format "%-30s %s" Listfilelines \
$obj_attr(lines)]"}
"column"     {puts $puifid "[format "%-30s %s" Listfilecolumn \
$obj_attr(column)]"}
"oper"       {puts $puifid "[format "%-30s %s" Listfileflag_oper \
$obj_attr(oper)]"}
"tool"       {puts $puifid "[format "%-30s %s" Listfileflag_tool \
$obj_attr(tool)]"}
"start_path" {puts $puifid "[format "%-30s %s" Listfileflag_start_path \
$obj_attr(start_path)]"}
"tool_chng"  {puts $puifid "[format "%-30s %s" Listfileflag_tool_chng \
$obj_attr(tool_chng)]"}
"end_path"   {puts $puifid "[format "%-30s %s" Listfileflag_end_path \
$obj_attr(end_path)]"}
"oper_time"  {puts $puifid "[format "%-30s %s" Listfileflag_oper_time \
$obj_attr(oper_time)]"}
"setup_time" {puts $puifid "[format "%-30s %s" Listfileflag_setup_time \
$obj_attr(setup_time)]"}
"warn"       {puts $puifid "[format "%-30s %s" Listfileflag_warn \
$obj_attr(warn)]"}
"lpt_ext"    {puts $puifid "[format "%-30s %s" Listfileflag_lpt_ext \
$obj_attr(lpt_ext)]"}
"review"     {puts $puifid "[format "%-30s %s" Listfileflag_review \
$obj_attr(review)]"}
"group"      {puts $puifid "[format "%-30s %s" Listfileflag_group \
$obj_attr(group)]"}
"ncfile_ext" {puts $puifid "[format "%-30s %s" Listfileflag_ncfile_ext \
$obj_attr(ncfile_ext)]"}
"usertcl_check" {puts $puifid "[format "%-30s %s" \
Listfileflag_usertcl_check $obj_attr(usertcl_check)]"}
"usertcl_name"  {puts $puifid "[format "%-30s %s" \
Listfileflag_usertcl_name $obj_attr(usertcl_name)]"}
"verbose"  {puts $puifid "[format "%-30s %s" \
Listfileflag_verbose $obj_attr(verbose)]"}
}
}
puts $puifid "## LISTING FILE END\n"
}
proc PB_pui_WriteKinematicVariables { PUIFID MOM_KIN_VAR } {
upvar $PUIFID puifid
upvar $MOM_KIN_VAR mom_kin_var
set arr_names [array names mom_kin_var]
puts $puifid "## KINEMATIC VARIABLES START"
set arr_names [lsort -dictionary $arr_names]
foreach kin_var $arr_names \
{
set mom_kin_var($kin_var) [PB_output_EscapeSpecialControlChar $mom_kin_var($kin_var)]
puts $puifid "[format "%-40s  %s" \"$kin_var\" \"$mom_kin_var($kin_var)\"]"
}
puts $puifid "## KINEMATIC VARIABLES END\n"
}
proc PB_pui_WriteGMCodes { PUIFID CODE_VAR CODE_DESC } {
upvar $PUIFID puifid
upvar $CODE_VAR code_var
upvar $CODE_DESC code_desc
set no_of_codes [array size code_var]
for {set count 0} {$count < $no_of_codes} {incr count} \
{
puts $puifid "[format "%-40s  %s" \"$code_var($count)\" \
\"$code_desc($count)\"]"
}
}
proc PB_pui_WriteMasterSeqData { PUIFID ADD_OBJ_LIST } {
upvar $PUIFID puifid
upvar $ADD_OBJ_LIST add_obj_list
PB_adr_SortAddresses add_obj_list
puts $puifid "## MASTER SEQUENCE START"
foreach add_obj $add_obj_list \
{
set add_name $address::($add_obj,add_name)
address::readMseqAttr $add_obj mseq_attr
puts $puifid "[format "%-15s   %s  %d  %s  %d" $add_name \
\"$mseq_attr(0)\" $mseq_attr(1) \"$mseq_attr(2)\" $mseq_attr(4)]"
unset mseq_attr
}
puts $puifid "## MASTER SEQUENCE END\n"
}
proc PB_pui_WriteCycleComSharedEvts { PUIFID CYL_COM_EVT CYL_SH_COM_EVT } {
upvar $PUIFID puifid
upvar $CYL_COM_EVT cyl_com_evt
upvar $CYL_SH_COM_EVT cyl_sh_com_evt
puts $puifid "## CYCLE EVENT START"
puts $puifid "#Cycle Common Block Start"
foreach evt_name $cyl_com_evt \
{
puts $puifid "\{$evt_name\}"
}
puts $puifid "#Cycle Common Block End\n"
puts $puifid "#Cycle Block Share Common Block Start"
puts $puifid "\{ \\"
foreach evt_name [lindex $cyl_sh_com_evt 0] \
{
puts $puifid "  \{$evt_name\} \\"
}
puts $puifid "\}"
puts $puifid "#Cycle Block Share Common Block End"
puts $puifid "## CYCLE EVENT END\n"
}
proc PB_pui_WriteBlockModality { PUIFID BLK_OBJ_LIST } {
upvar $PUIFID puifid
upvar $BLK_OBJ_LIST blk_obj_list
puts $puifid "## BLOCK MODALITY START"
foreach blk_obj $blk_obj_list \
{
block::readvalue $blk_obj blk_obj_attr
set blk_mod_add_list ""
foreach blk_elem_obj $blk_obj_attr(2) \
{
block_element::readvalue $blk_elem_obj blk_elem_obj_attr
if { $blk_elem_obj_attr(4) } \
{
lappend blk_mod_add_list $address::($blk_elem_obj_attr(0),add_name)
}
unset blk_elem_obj_attr
}
if { $blk_mod_add_list != "" } \
{
puts $puifid "[format "%-30s" \{$blk_obj_attr(0)\}]  \{$blk_mod_add_list\}"
}
unset blk_obj_attr blk_mod_add_list
}
global post_object
set post_blk_list $Post::($post_object,post_blk_list)
foreach post_blk_obj $post_blk_list \
{
block::readvalue $post_blk_obj blk_obj_attr
set blk_mod_add_list ""
foreach blk_elem_obj $blk_obj_attr(2) \
{
block_element::readvalue $blk_elem_obj blk_elem_obj_attr
if { $blk_elem_obj_attr(4) } \
{
lappend blk_mod_add_list $address::($blk_elem_obj_attr(0),add_name)
}
unset blk_elem_obj_attr
}
if { $blk_mod_add_list != "" } \
{
puts $puifid "[format "%-30s" \{$blk_obj_attr(0)\}]  \{$blk_mod_add_list\}"
}
unset blk_obj_attr blk_mod_add_list
}
puts $puifid "## BLOCK MODALITY END\n"
}
proc  PB_pui_WriteCompositeBlks { PUIFID } {
upvar $PUIFID puifid
PB_output_GetCompositeBlks comp_blk_list
puts $puifid "## COMPOSITE BLOCKS START"
if { $comp_blk_list != "" } \
{
foreach blk_obj $comp_blk_list \
{
lappend comp_blk_name_list $block::($blk_obj,block_name)
}
puts $puifid "\{$comp_blk_name_list\}"
} else \
{
puts $puifid "\{\}"
}
puts $puifid "## COMPOSITE BLOCKS END\n"
}
proc PB_pui_WriteSeqEvents { PUIFID SEQ_OBJ_LIST } {
upvar $PUIFID puifid
upvar $SEQ_OBJ_LIST seq_obj_list
set no_seqs [llength $seq_obj_list]
puts $puifid "## SEQUENCE START"
for {set count 0} {$count <  $no_seqs} {incr count} \
{
PB_pui_WriteSeqHeader puifid count
set seq_obj [lindex $seq_obj_list $count]
PB_pui_WriteEventAndBlks puifid seq_obj
PB_pui_WriteSeqFooter puifid count
}
puts $puifid "## SEQUENCE END\n"
}
proc PB_pui_WriteSeqHeader { PUIFID INDEX } {
upvar $PUIFID puifid
upvar $INDEX index
switch $index \
{
0 {
puts $puifid "#Program Start Sequence Start"
}
1 {
puts $puifid "#Operation Start Sequence Start"
}
2 {
puts $puifid "##Tool Path Start"
puts $puifid "#Control Functions Start"
}
3 {
puts $puifid "#Motions Start"
}
4 {
puts $puifid "#Cycles Start"
}
5 {
puts $puifid "#Operation End Sequence Start"
}
6 {
puts $puifid "#Program End Sequence Start"
}
7 {
puts $puifid "#Linked Posts Sequence Start"
}
8 {
puts $puifid "#Virtual NC Sequence Start"
}
}
}
proc PB_pui_WriteEventAndBlks { PUIFID SEQ_OBJ } {
upvar $PUIFID puifid
upvar $SEQ_OBJ seq_obj
global post_object
if [string match "Virtual NC Controller" $sequence::($seq_obj,seq_name)] {
set seq_events_list $Post::($post_object,vnc_evt_obj_list)
} else {
set seq_events_list $sequence::($seq_obj,evt_obj_list)
}
set cyl_sh_com_evt [lindex $Post::($post_object,cyl_evt_sh_com_evt) 0]
foreach evt_obj $seq_events_list \
{
set evt_blk_list ""
set event_name $event::($evt_obj,event_name)
set evt_elem_list $event::($evt_obj,evt_elem_list)
if { [lsearch $cyl_sh_com_evt $event_name] != -1} \
{
set share_event_flag 1
} else \
{
set share_event_flag 0
}
foreach row_elem_list $evt_elem_list \
{
foreach elem_obj $row_elem_list \
{
set blk_obj $event_element::($elem_obj,block_obj)
if { $blk_obj > 0 } {
if { $share_event_flag }\
{
if {![string compare $block::($blk_obj,blk_owner) $event_name]} \
{
PB_output_GetBlkName blk_obj block_name
lappend row_blk_list $block_name
}
} else \
{
PB_output_GetBlkName blk_obj block_name
lappend row_blk_list $block_name
}
}
}
if [info exists row_blk_list] \
{
lappend evt_blk_list $row_blk_list
unset row_blk_list
}
}
set event_label $event::($evt_obj,event_label)
if [string match "Virtual NC Controller" $sequence::($seq_obj,seq_name)] {
puts $puifid "[format "%-55s  %s  %s" \{$event_name\} \{$evt_blk_list\} \{$event_label\}]"
} else {
puts $puifid "[format "%-25s  %s  %s" \{$event_name\} \{$evt_blk_list\} \{$event_label\}]"
}
}
}
proc  PB_pui_WriteSeqFooter { PUIFID INDEX } {
upvar $PUIFID puifid
upvar $INDEX index
switch $index \
{
0 {
puts $puifid "#Program Start Sequence End\n"
}
1 {
puts $puifid "#Operation Start Sequence End\n"
}
2 {
puts $puifid "#Control Functions End\n"
}
3 {
puts $puifid "#Motions End\n"
}
4 {
puts $puifid "#Cycles End"
puts $puifid "##Tool Path End\n"
}
5 {
puts $puifid "#Operation End Sequence End\n"
}
6 {
puts $puifid "#Program End Sequence End\n"
}
7 {
puts $puifid "#Linked Posts Sequence End\n"
}
8 {
puts $puifid "#Virtual NC Sequence End"
}
}
}
proc PB_pui_WriteEventUIData { PUIFID SEQ_OBJ_LIST } {
upvar $PUIFID puifid
upvar $SEQ_OBJ_LIST seq_obj_list
puts $puifid "## EVENTS USER INTERFACE START"
foreach seq_obj $seq_obj_list \
{
set seq_events_list $sequence::($seq_obj,evt_obj_list)
foreach evt_obj $seq_events_list \
{
set evt_item_obj_list $event::($evt_obj,evt_itm_obj_list)
if {[string compare $evt_item_obj_list ""] == 0} \
{
continue
}
puts $puifid "\{$event::($evt_obj,event_name)\} \\"
set no_items [llength $evt_item_obj_list]
set item_no 1
foreach item_obj $evt_item_obj_list \
{
item::readvalue $item_obj item_obj_attr
puts $puifid "     \{\{\"$item_obj_attr(0)\" $item_obj_attr(1) \
$item_obj_attr(2)\} \\"
set grp_no 1
foreach grp_obj $item_obj_attr(3) \
{
item_group::readvalue $grp_obj grp_obj_attr
puts $puifid "        \{\{\"$grp_obj_attr(0)\" $grp_obj_attr(1) \
$grp_obj_attr(2)\} \\"
set mem_no 1
foreach mem_obj $grp_obj_attr(3) \
{
group_member::readvalue $mem_obj mem_obj_attr
if {[llength $mem_obj_attr(5)] > 1} \
{
append tmp_3mem_out "\{$mem_obj_attr(5)\}"
} else \
{
append tmp_3mem_out "$mem_obj_attr(5)"
}
if { [info exists mem_obj_attr(6)]  &&  $mem_obj_attr(6) != "" } {
append tmp_3mem_out " \"$mem_obj_attr(6)\""
}
set mem_output "          \{\"$mem_obj_attr(0)\" $mem_obj_attr(1) \
$mem_obj_attr(2) $mem_obj_attr(3) $mem_obj_attr(4) $tmp_3mem_out\}"
unset tmp_3mem_out
if {$mem_no == $grp_obj_attr(1)} \
{
append temp_mem_output $mem_output "\}"
set mem_output $temp_mem_output
unset temp_mem_output
}
if {$mem_no == $grp_obj_attr(1) && \
$grp_no == $item_obj_attr(1)} \
{
append temp_mem_output $mem_output "\}"
set mem_output $temp_mem_output
unset temp_mem_output
}
if {$mem_no == $grp_obj_attr(1) && $item_no == $no_items \
&& $grp_no == $item_obj_attr(1)} \
{
puts $puifid "      $mem_output"
} else \
{
puts $puifid "      $mem_output \\"
}
incr mem_no
unset mem_obj_attr
}
incr grp_no
unset grp_obj_attr
}
incr item_no
unset item_obj_attr
}
}
}
puts $puifid "## EVENTS USER INTERFACE END\n"
}
proc PB_pui_WriteMOMVariables { PUIFID ADD_NAME_LIST ADD_OBJ_LIST \
WORD_DESC_ARR WORD_MOM_VAR MOM_VAR_ARR } {
upvar $PUIFID puifid
upvar $ADD_NAME_LIST add_name_list
upvar $ADD_OBJ_LIST add_obj_list
upvar $WORD_DESC_ARR word_desc_arr
upvar $WORD_MOM_VAR word_mom_var
upvar $MOM_VAR_ARR mom_var_arr
PB_adr_GetAddressNameList add_obj_list add_obj_name_list
set no_of_adds [array size add_name_list]
if [PB_is_v 4.0] {
set default_name [list "New_Address" "PB_Dummy" "PB_Tcl_Var" "Command" \
"Operator Message" "PB_Spindle" \
"PB_ZeroFmt" "VNC_Instruction"]
} else {
set default_name [list "New_Address" "PB_Dummy" "PB_Tcl_Var" "Command" \
"Operator Message" "PB_Spindle" \
"PB_ZeroFmt"]
}
foreach name $default_name \
{
lappend add_obj_name_list $name
}
puts $puifid "## MOM SYS VARIABLES START"
global post_object
Post::GetObjList $post_object comment cmt_blk_obj_list
foreach add_name $add_obj_name_list \
{
puts $puifid "\{$add_name\} \\"
set word_flag 0
for {set add_no 0} {$add_no < $no_of_adds} {incr add_no} \
{
if { $add_name_list($add_no) == "$add_name" } \
{
set no_mom_var [llength $word_mom_var($add_name_list($add_no))]
set word_mom_list $word_mom_var($add_name_list($add_no))
set word_flag 1
break
}
}
set no_mom_var 0
if [info exists word_mom_var($add_name)] \
{
set word_mom_var($add_name)  [ltidy $word_mom_var($add_name)]
if { $add_name == "Operator Message" } {
set j 0
foreach mom_var $word_mom_var($add_name) {
PB_com_RetObjFrmName mom_var cmt_blk_obj_list cmt_blk_obj
if { $cmt_blk_obj > 0 } {
if { ![info exists block::($cmt_blk_obj,evt_elem_list)]  || \
[llength $block::($cmt_blk_obj,evt_elem_list)] == 0 } {
set word_mom_var($add_name) [lreplace $word_mom_var($add_name) $j $j]
} else {
incr j
}
} else {
set word_mom_var($add_name) [lreplace $word_mom_var($add_name) $j $j]
}
}
}
if [string match "PB_Dummy" $add_name] {
set j [lsearch -exact $word_mom_var($add_name) "\$cir_vector"]
if { $j >= 0 } {
set word_mom_var($add_name) [lreplace $word_mom_var($add_name) $j $j]
}
}
set no_mom_var [llength $word_mom_var($add_name)]
for {set count 0} {$count < $no_mom_var} {incr count} \
{
set mom_var [lindex $word_mom_var($add_name) $count]
if { $add_name == "Command" || $add_name == "Operator Message" } \
{
if { $add_name == "Command" } {
set var_value ""
} else {
if 0 {
if [info exists mom_var_arr($mom_var)] {
set var_value $mom_var_arr($mom_var)
}
if { $var_value == "" } {
PB_com_RetObjFrmName mom_var cmt_blk_obj_list cmt_blk_obj
if { $cmt_blk_obj > 0 } {
block::readvalue $cmt_blk_obj cmt_blk_obj_attr
set blk_elem [lindex $cmt_blk_obj_attr(2) 0]
set elem_var $block_element::($blk_elem,elem_mom_variable)
}
set var_value $elem_var
}
} else {
PB_com_RetObjFrmName mom_var cmt_blk_obj_list cmt_blk_obj
if { $cmt_blk_obj > 0 } {
block::readvalue $cmt_blk_obj cmt_blk_obj_attr
set blk_elem [lindex $cmt_blk_obj_attr(2) 0]
set elem_var $block_element::($blk_elem,elem_mom_variable)
}
set var_value $elem_var
}
set var_value [join [split $var_value \\] \\\\\\]
}
set var_desc [lindex $word_desc_arr($add_name) $count]
} else \
{
if {[string match "\$mom_sys_feed_param*format*" $mom_var] || \
[string match "\$mom_sys_delay_param*format*" $mom_var] } \
{
set temp_list [split $mom_var ,]
set new_var [join $temp_list ",1_"]
if [info exists mom_var_arr($mom_var)] \
{
set fmt_name $mom_var_arr($mom_var)
PB_int_RetFmtObjFromName fmt_name fmt_obj
set mom_var_arr($new_var) $fmt_obj
} else \
{
set fmt_obj 0
}
if {$fmt_obj} {
set var_value $format::($fmt_obj,for_name)
}
} else \
{
if [info exists mom_var_arr($mom_var)] {
set var_value $mom_var_arr($mom_var)
} else {
set var_value ""
}
}
if 0 {
if { [string match $mom_var "Comment_Start"] || \
[string match $mom_var "Comment_End"] } {
set var_value [PB_output_EscapeSpecialControlChar $var_value]
}
}
set var_value [PB_output_EscapeSpecialControlChar $var_value]
if { [string first $var_value \\] != -1} \
{
set var_split [split $var_value \\]
set var_value [join $var_split "\\\\"]
}
set var_desc [lindex $word_desc_arr($add_name) $count]
}
if {$count < [expr $no_mom_var -1]} \
{
puts $puifid "      \{\"$mom_var\" \"$var_value\" \"$var_desc\"\} \\"
} else \
{
puts $puifid "      \{\"$mom_var\" \"$var_value\" \"$var_desc\"\}"
}
set var_value ""
set var_desc  ""
}
}
if { $no_mom_var == 0 } \
{
puts $puifid "      \{\"\" \"\" \"\"\}"
}
}
puts $puifid "\{PB_Rapid\} \\"
set rap_1_obj $mom_var_arr(\$pb_rapid_1)
set rap_2_obj $mom_var_arr(\$pb_rapid_2)
set rap_blk_1 ""
set rap_blk_2 ""
if { $rap_1_obj != "" } \
{
set rap_blk_1 $block::($rap_1_obj,block_name)
}
if { $rap_2_obj != "" } \
{
if [info exists block::($rap_2_obj,block_name)] {
set rap_blk_2 $block::($rap_2_obj,block_name)
}
}
puts $puifid "      \{\"\$pb_rapid_1\" \"$rap_blk_1\" \"\"\} \\"
puts $puifid "      \{\"\$pb_rapid_2\" \"$rap_blk_2\" \"\"\}"
if 0 {
puts $puifid "\{PB_ZeroFmt\} \\"
set zero_int_fmt $mom_var_arr(\$zero_int_fmt)
set zero_real_fmt $mom_var_arr(\$zero_real_fmt)
puts $puifid "      \{\"\$zero_int_fmt\" \"$zero_int_fmt\" \"\"\} \\"
puts $puifid "      \{\"\$zero_real_fmt\" \"$zero_real_fmt\" \"\"\}"
}
puts $puifid "## MOM SYS VARIABLES END"
}
proc PB_pui_PartConversion { CUR_POST_OBJ OLD_POST_OBJ } {
upvar $CUR_POST_OBJ cur_post_obj
upvar $OLD_POST_OBJ old_post_obj
Post::ReadPostFiles $old_post_obj old_pui_dir old_def old_tcl
set post_files(def_file) $old_def
set post_files(tcl_file) $old_tcl
Post::SetPostFiles $cur_post_obj old_pui_dir post_files
set old_list_obj $Post::($old_post_obj,list_obj_list)
ListingFile::readvalue $old_list_obj old_list_obj_attr
set old_list_names $ListingFile::($old_list_obj,arr_names)
set cur_list_obj $Post::($cur_post_obj,list_obj_list)
ListingFile::readvalue $cur_list_obj cur_list_obj_attr
set cur_list_names $ListingFile::($cur_list_obj,arr_names)
foreach elem $old_list_names \
{
if { [lsearch $cur_list_names $elem] != -1 } \
{
set cur_list_obj_attr($elem) $old_list_obj_attr($elem)
}
}
ListingFile::setvalue $cur_list_obj cur_list_obj_attr
array set old_kin_var $Post::($old_post_obj,mom_kin_var_list)
array set cur_kin_var $Post::($cur_post_obj,mom_kin_var_list)
set name_list [array names old_kin_var]
foreach old_var $name_list \
{
if { [string match "\$*" $old_var] == 0 } \
{
set cur_var "\$$old_var"
} else \
{
set cur_var $old_var
}
if [info exists cur_kin_var($cur_var)] \
{
switch $old_var \
{
"mom_kin_4th_axis_plane"   -
"\$mom_kin_4th_axis_plane" -
"\$mom_kin_5th_axis_plane" -
"mom_kin_5th_axis_plane" \
{
set old_kin_var($old_var) [string toupper $old_kin_var($old_var)]
}
}
set cur_kin_var($cur_var) $old_kin_var($old_var)
}
}
set Post::($cur_post_obj,mom_kin_var_list) [array get cur_kin_var]
set Post::($cur_post_obj,def_mom_kin_var_list) [array get cur_kin_var]
array set old_msq_word_param $Post::($old_post_obj,msq_word_param)
set msq_add_name $Post::($old_post_obj,msq_add_name)
foreach add_name $msq_add_name \
{
if { [lindex $old_msq_word_param($add_name) 3] == "" } \
{
set mseq_param $old_msq_word_param($add_name)
if { [string match "*user*" $add_name] } \
{
set mseq_param [lreplace $mseq_param 3 3 1]
} else \
{
set mseq_param [lreplace $mseq_param 3 3 0]
}
set old_msq_word_param($add_name) $mseq_param
}
}
Post::InitMasterSequence $cur_post_obj msq_add_name old_msq_word_param
array set blk_mod_arr $Post::($old_post_obj,blk_mod_list)
set Post::($cur_post_obj,blk_mod_list) [array get blk_mod_arr]
if [info exists Post::($old_post_obj,comp_blk_list)] {
set Post::($cur_post_obj,comp_blk_list) \
$Post::($old_post_obj,comp_blk_list)
} else {
set Post::($cur_post_obj,comp_blk_list) [list]
}
set seq_name_list {"prog_start" "oper_start" "oper_end" "prog_end" \
"tpth_ctrl" "tpth_mot" "tpth_cycle"}
foreach seq_n $seq_name_list \
{
set evt_list ${seq_n}_evt_list
set blk_list ${seq_n}_evt_blk_list
array set old_event_name_arr $Post::($old_post_obj,$evt_list)
array set old_event_blk_arr $Post::($old_post_obj,$blk_list)
array set cur_event_name_arr $Post::($cur_post_obj,$evt_list)
array set cur_event_blk_arr $Post::($cur_post_obj,$blk_list)
set no_events [array size cur_event_name_arr]
for { set count 0 } { $count < $no_events } { incr count } \
{
set event_name $cur_event_name_arr($count)
set evt_indx [lsearch $Post::($old_post_obj,$evt_list) $event_name]
if { $evt_indx != -1 } \
{
set act_indx [lindex $Post::($old_post_obj,$evt_list) \
[expr $evt_indx -1]]
set cur_event_blk_arr($count) $old_event_blk_arr($act_indx)
} else \
{
set cur_event_blk_arr($count) ""
}
}
set Post::($cur_post_obj,$evt_list) [array get cur_event_name_arr]
set Post::($cur_post_obj,$blk_list) [array get cur_event_blk_arr]
unset cur_event_name_arr cur_event_blk_arr
unset old_event_name_arr old_event_blk_arr
}
array set cur_add_name_arr $Post::($cur_post_obj,add_name_list)
array set cur_add_mom_var_arr $Post::($cur_post_obj,add_mom_var_list)
array set old_add_name_arr $Post::($old_post_obj,add_name_list)
array set old_add_mom_var_arr $Post::($old_post_obj,add_mom_var_list)
set no_old_adds [array size old_add_name_arr]
set no_cur_adds [array size cur_add_name_arr]
for { set count 0 } { $count < $no_old_adds } { incr count } \
{
set add_name $old_add_name_arr($count)
set old_add_var_list $old_add_mom_var_arr($count)
set cur_add_var_list ""
for { set add_indx 0 } { $add_indx < $no_cur_adds } { incr add_indx } \
{
if { $cur_add_name_arr($add_indx) == "$add_name" } \
{
set cur_add_var_list $cur_add_mom_var_arr($add_indx)
break
}
}
if { $add_name == "Command" || $add_name == "Operator Message" || \
$add_name == "PB_Spindle" } \
{
set cur_add_var_list ""
}
foreach var_line $old_add_var_list \
{
set var [lindex $var_line 0]
set value [lindex $var_line 1]
set cur_line_index 0
set old_var_flag 0
foreach cur_var_line $cur_add_var_list \
{
if { [string compare $var [lindex $cur_var_line 0]] == 0 } \
{
set cur_var_line [lreplace $cur_var_line 1 1 $value]
set cur_add_var_list [lreplace $cur_add_var_list \
$cur_line_index $cur_line_index $cur_var_line]
set old_var_flag 1
break
}
incr cur_line_index
}
if { $old_var_flag == 0 } \
{
lappend cur_add_var_list $var_line
}
}
if { $cur_add_var_list != "" } \
{
set cur_add_mom_var_arr($add_indx) $cur_add_var_list
}
}
set add_size [array size cur_add_name_arr]
foreach mseq_add $msq_add_name \
{
set cur_add_arr_list [array get cur_add_name_arr]
if { [lsearch $cur_add_arr_list $mseq_add] == -1 } \
{
set cur_add_name_arr($add_size) $mseq_add
set cur_add_mom_var_arr($add_size) [list "" "" ""]
incr add_size
}
}
set Post::($cur_post_obj,add_name_list) [array get cur_add_name_arr]
set Post::($cur_post_obj,add_mom_var_list) [array get cur_add_mom_var_arr]
unset cur_add_name_arr cur_add_mom_var_arr
unset old_add_name_arr old_add_mom_var_arr
}


