proc UI_PB_OpenPost {} {
global gPB
global env
global tcl_platform
if { $gPB(use_info) } \
{
UI_PB_chelp_DisplayMenuItemCsh $gPB(file_menu)
return
}
if { [lsearch -exact [package names] "stooop"] < 0 } {
source $env(PB_HOME)/tcl/exe/stooop.tcl
namespace import stooop::*
}
UI_PB_com_SetStatusbar "$gPB(open,Status)"
UI_PB_file_GetWorkFileDir
set file_name [file join $gPB(work_dir) $gPB(work_file)]
if { ![file exists $file_name] } {
set gPB(work_file) ""
}
if {$tcl_platform(platform) == "unix"} \
{
UI_PB_file_OpenPost_unx
} elseif {$tcl_platform(platform) == "windows"} \
{
UI_PB_file_OpenPost_win
}
}
proc UI_PB_OpenVisitedPost { post } {
global gPB
global env
if { $gPB(use_info) } \
{
UI_PB_chelp_DisplayMenuItemCsh $gPB(file_menu)
return
}
set pui [file rootname $post].pui
set def [file rootname $post].def
set tcl [file rootname $post].tcl
if { ![file exists $pui] || \
![file exists $def] || \
![file exists $tcl] } \
{
tk_messageBox -parent $gPB(top_window) -type ok -icon error \
-title $gPB(msg,dialog,title) \
-message "$gPB(msg,file_missing)."
set i [lsearch $gPB(open_files_list) $post]
set gPB(open_files_list) [lreplace $gPB(open_files_list) $i $i]
UI_PB_AddVisitedPosts
if [info exists gPB(master_pid)] {
if [string match windows $::tcl_platform(platform)] {
exec taskkill /f /pid [pid]
} else {
exec kill [pid]
}
}
return TCL_ERROR
}
if { [lsearch -exact [package names] "stooop"] < 0 } {
source $env(PB_HOME)/tcl/exe/stooop.tcl
namespace import stooop::*
}
return [UI_PB_file_EditPost 0 $post 1]
}
proc UI_PB_file_GetWorkFileDir { args } {
global gPB env
if { ![info exists gPB(open_files_list)] } {
set gPB(open_files_list) [list]
}
if { ![info exists gPB(work_dir)] || $gPB(work_dir) == "" } {
if { [llength $gPB(open_files_list)] == 0 } {
set gPB(work_file) ""
if [info exists env(HOME)] {
if [catch {file exists "$env(HOME)"}] {
set gPB(work_dir) "$env(PB_HOME)"
} else {
if [file exists "$env(HOME)"] {
set gPB(work_dir) "$env(HOME)"
} else {
set gPB(work_dir) "$env(PB_HOME)"
}
}
} else {
set gPB(work_dir) "$env(PB_HOME)"
}
} else {
set work_file [lindex $gPB(open_files_list) 0]
set gPB(work_file) [file tail $work_file]
set gPB(work_dir) [file dirname $work_file]
}
}
if { ![info exists gPB(work_file)] } {
set gPB(work_file) ""
}
set gPB(work_dir)  [file nativename $gPB(work_dir)]
set gPB(work_file) [file nativename $gPB(work_file)]
}
proc UI_PB_file_OpenPost_unx {} {
global tixOption
global paOption
global gPB
global env
set win $gPB(top_window).open
if { [winfo exists $win] } \
{
$win popup
UI_PB_com_ClaimActiveWindow $win
set fbox [$win subwidget fsbox]
catch {
$fbox config -directory $gPB(work_dir) \
-value $gPB(work_file)
}
$fbox filter
[$fbox subwidget types] pick 0
if { $gPB(work_file) != "" } {
[$fbox subwidget file] addhistory $gPB(work_file)
[$fbox subwidget file] pick 0
}
} else \
{
tixExFileSelectDialog $win -command "UI_PB_file_EditPost $win"
UI_PB_com_CreateTransientWindow $win "$gPB(open,title,Label)" \
"600x400+200+100" "" "" "" "UI_PB_OpenCancel_CB $win"
$win popup
UI_PB_com_PositionWindow $win
set fbox [$win subwidget fsbox]
set ftypes [list \{*.pui\}\ \{$gPB(open,file_type_pui)\}]
$fbox config -filetypes $ftypes
catch {
$fbox config -pattern "*.pui" \
-directory $gPB(work_dir) \
-value $gPB(work_file)
}
set fdir [[$fbox subwidget dir] subwidget entry]
set file [[$fbox subwidget file] subwidget entry]
bind $fdir <KeyPress> "UI_PB_com_DisableSpaceKey %W %K"
bind $fdir <KeyRelease> { %W config -state normal }
bind $file <KeyPress> "UI_PB_com_DisableSpaceKey %W %K"
bind $file <KeyRelease> { %W config -state normal }
[$fbox subwidget cancel] config -width 10 -bg $paOption(app_butt_bg) \
-command "UI_PB_OpenCancel_CB $win"
[$fbox subwidget ok]     config -bg $paOption(app_butt_bg) -width 10 \
-text $gPB(nav_button,open,Label)
[$fbox subwidget file] config -history yes -prunehistory yes
[$fbox subwidget dir]  config -history yes -prunehistory yes
$fbox filter
[$fbox subwidget types] pick 0
if { $gPB(work_file) != "" } {
[$fbox subwidget file] addhistory $gPB(work_file)
[$fbox subwidget file] pick 0
}
}
if 0 {
if { $gPB(work_file) != "" } {
set file_list_box [[$fbox subwidget filelist] subwidget listbox]
set selected_file_index [lsearch [$file_list_box get 0 end] $gPB(work_file)]
if { $selected_file_index < 0 } { set selected_file_index 0 }
$file_list_box selection set $selected_file_index
$file_list_box activate $selected_file_index
$file_list_box see $selected_file_index
}
}
UI_PB_GrayOutAllFileOptions
}
proc UI_PB_file_OpenPost_win {} {
global tixOption
global paOption
global gPB
global env
set types {
{ {Post Builder Session} {.pui} }
}
UI_PB_com_ChangeCHelpState disabled
if {[info exists env(MULTI_INTERP)] && $env(MULTI_INTERP) == 1} {
UI_PB_GrayAndUnGrayWindowMenu gray
}
UI_PB_GrayOutAllFileOptions
set acwin [UI_PB_com_AskActiveWindow]
set status TCL_ERROR
while { $status != "TCL_OK" } \
{
if {$::tcl_platform(platform) == "windows" && $::tcl_version == "8.4"} {
if {[info exists env(MULTI_INTERP)] && $env(MULTI_INTERP) == 1} {
after 100 [list focus -force .widget]
}
}
set filename [tk_getOpenFile -filetypes $types \
-title "$gPB(open,title,Label)" \
-parent $acwin \
-defaultextension "pui" \
-initialdir $gPB(work_dir) \
-initialfile $gPB(work_file)]
set win $acwin.__tk_filedialog
set gPB(top_window).open $win
UI_PB_com_ChangeCHelpState normal
if {$filename == ""} { ;# File selection dialog exited abnormally... (X'ed).
UI_PB_EnableFileOptions
UI_PB_com_EnableProcess
set status TCL_OK
} else {               ;# File selected.
set gPB(work_dir) [file dirname $filename]
set status [UI_PB_file_EditPost $win $filename]
}
if { $status != "TCL_OK" } {
UI_PB_DeleteDataBaseObjs
global mom_sys_arr mom_kin_var mom_sim_arr
PB_com_unset_var mom_sys_arr
PB_com_unset_var mom_kin_var
if [info exists mom_sim_arr] {PB_com_unset_var mom_sim_arr}
}
}
if {[info exists env(MULTI_INTERP)] && $env(MULTI_INTERP) == 1} {
UI_PB_GrayAndUnGrayWindowMenu ungray
}
}
proc UI_PB_OpenDestroy { win } {
UI_PB_EnableFileOptions
}
proc UI_PB_OpenCancel_CB { args } {
global gPB
if [llength $args] {
set dialog_id [lindex $args 0]
if [winfo exists $dialog_id] {
$dialog_id popdown
}
}
UI_PB_EnableFileOptions
UI_PB_com_SetStatusbar "$gPB(main,default,Status)"
}
proc UI_PB_OpenDlgFilter { dlg_id } {
UI_PB_UpdateFileListBox $dlg_id
set file_box [$dlg_id subwidget fsbox]
$file_box config -pattern "*.pui"
}
proc UI_PB_GetPostVersion { FILE_NAME VERSION args } {
global gPB
upvar $FILE_NAME file_name
upvar $VERSION version
set file_id [open $file_name r]
set kin_flag 0
set units ""
set machine ""
set version 0
if { [gets $file_id line] >= 0 } \
{
if { [string match "*POSTBUILDER_VERSION*" $line] } \
{
set line_list [split $line =]
set version [lindex $line_list 1]
} else \
{
set version 0
}
while { [gets $file_id line] >= 0 } \
{
if [llength $args] {
if [string match "#  Created by *" $line] {
set gPB(post_created_by) [string range $line 11 end]
}
if [string match "#  with Post Builder *" $line] {
set end_idx [expr [string length $line] - 2]
set gPB(post_created_with) [string range $line 3 $end_idx]
}
}
switch -glob -- $line \
{
"## KINEMATIC VARIABLES START" { set kin_flag 1 }
"## KINEMATIC VARIABLES END"   { set kin_flag 2 }
}
if { $kin_flag == 1 } \
{
set first_word [string trim [lindex $line 0]]
set sec_word [string trim [lindex $line 1]]
if { [string match "*mom_kin_output_unit*" $first_word] } \
{
set units $sec_word
} elseif { [string match "*mom_kin_machine_type*" $first_word] } \
{
set machine $sec_word
}
} elseif { $kin_flag == 2 } \
{
break
}
}
PB_com_GetMachAxisType $machine act_mach_type axis
}
close $file_id
}
proc UI_PB_file_IsOpened { pui_file } {
global PID
set idx [lsearch $PID(posts_name_list) $pui_file]
if {$idx >= 0} {
return [lindex $PID(posts_list) $idx]
} else {
return no
}
}
proc UI_PB_file_EditPost { dlg_id file_name args } {
global gPB env
if {$env(PB_UDE_ENABLED) == 2} {
if [file exists [file rootname $file_name].cdl] {
set env(PB_UDE_ENABLED) 1
} else {
set env(PB_UDE_ENABLED) 0
}
}
if {[info exists env(MULTI_INTERP)] && $env(MULTI_INTERP) == 1} {
if {$dlg_id == 0} {
set gPB(action) "open_recent_post"
} elseif {$dlg_id == 1} {
set gPB(action) "cmd_line_pui"
} else {
set gPB(action) "open"
}
set gPB(o_dlg_id) $dlg_id
set gPB(o_file_name) $file_name
set gPB(o_args) $args
exec build_post.exe [comm::comm self] &
set ::ret_cod ""
vwait ::ret_cod
return $::ret_cod
} else {
return [UI_PB_file_EditPost_mod $dlg_id $file_name $args]
}
}
proc UI_PB_file_EditPost_mod { dlg_id file_name args } {
global gPB env
UI_PB_SnapShotRuntimeObjs
set top_win $gPB(top_window)
set ret_code 0
if { $file_name != "" } \
{
set dir [file dirname $file_name]
if [file exists $dir] \
{
set gPB(work_dir) [file nativename $dir]
}
}
set extension [file extension $file_name]
if { [string compare $extension ".pui"] != 0 } \
{
if { ![info exists gPB(auto_qc)] || $gPB(auto_qc) != 1} {
tk_messageBox -parent $top_win -type ok -icon error \
-title $gPB(msg,dialog,title) \
-message "$gPB(msg,invalid_file)"
}
if [winfo exists $dlg_id] { $dlg_id popup }
return TCL_ERROR
}
set pui [file rootname $file_name].pui
if { ![file exists $pui] } \
{
if { ![info exists gPB(auto_qc)] || $gPB(auto_qc) != 1} {
tk_messageBox -parent $top_win -type ok -icon error \
-title $gPB(msg,dialog,title) \
-message "$gPB(msg,file_missing)."
}
if [winfo exists $dlg_id] { $dlg_id popup }
return TCL_ERROR
}
if [info exists gPB(master_pid)] {
set is_opened [comm::comm send $gPB(master_pid) [list UI_PB_file_IsOpened $pui]]
if ![string match $is_opened "no"] {
UI_PB_EnableFileOptions
comm::comm send $gPB(master_pid) [list UI_PB_GrayAndUnGrayWindowMenu ungray]
comm::comm send $gPB(master_pid) [list UI_PB_com_EnableProcess]
comm::comm send -async $gPB(master_pid) [list __main_SwitchPosts $is_opened]
if [string match windows $::tcl_platform(platform)] {
exec taskkill /f /pid [pid]
} else {
exec kill [pid]
}
}
}
PB_file_FindTclDefOfPui $pui tcl def
if { ![file exists $pui] || \
![file exists $def] || \
![file exists $tcl] } \
{
if { ![info exists gPB(auto_qc)] || $gPB(auto_qc) != 1} {
tk_messageBox -parent $top_win -type ok -icon error \
-title $gPB(msg,dialog,title) \
-message "$gPB(msg,file_missing)."
}
if [winfo exists $dlg_id] { $dlg_id popup }
return TCL_ERROR
}
set gPB(work_file) [file tail $file_name]
if {$::disable_license == 0} {
global LicInfo
if [file exists [file rootname $tcl]_tcl.txt] {
set LicInfo(is_encrypted_file) 1
}
}
UI_PB_DisplayProgress open
set gPB(post_in_progress) 1
after 100 "UI_PB_DestroyProgress"
UI_PB_GetPostVersion file_name version get_history
set gPB(Old_PUI_Version) $version
set ver_check [string compare $gPB(Postbuilder_PUI_Version) $version]
if { $ver_check > 0 } \
{
if [catch { PB_OpenOldVersion $file_name } result] \
{
if [info exists gPB(err_msg)] {
set result $gPB(err_msg)
unset gPB(err_msg)
}
if { ![info exists gPB(auto_qc)] || $gPB(auto_qc) != 1} {
tk_messageBox -parent $top_win -type ok -icon error \
-title $gPB(msg,dialog,title) \
-message "$result"
}
set ret_code 1
} else {
if { ![info exists gPB(post_history)] ||\
[llength $gPB(post_history)] == 0 } {
if { [info exists gPB(post_created_with)] && \
[info exists gPB(post_created_by)] } {
set gPB(post_history) ""
lappend gPB(post_history) "Created $gPB(post_created_with)\
$gPB(post_created_by)."
unset gPB(post_created_with)
unset gPB(post_created_by)
} else {
set ver [split $gPB(Old_PUI_Version) .]
set ver [lreplace $ver end end]
set v   [expr [lindex $ver 0] - 1999]
set ver [lreplace $ver 0 0 $v]
set ver [join $ver .]
set gPB(post_history) ""
lappend gPB(post_history) "Created with UG/Post Bilder Version $ver."
}
}
if { ![info exists gPB(post_controller)] } {
set gPB(post_controller) "Unknown"
}
}
} elseif { $ver_check < 0 } \
{
if { ![info exists gPB(auto_qc)] || $gPB(auto_qc) != 1} {
tk_messageBox -parent $top_win -type ok -icon error \
-title $gPB(msg,dialog,title) \
-message "$gPB(msg,version_check)"
}
set ret_code 1
} else \
{
if [catch { PB_file_Open $file_name } result] \
{
global errorInfo
if [info exists gPB(err_msg)] {
set errorInfo $gPB(err_msg)
unset gPB(err_msg)
}
if { ![info exists gPB(auto_qc)] || $gPB(auto_qc) != 1} {
tk_messageBox -parent $top_win -type ok -icon error \
-title $gPB(msg,dialog,title) \
-message "$errorInfo"
}
set ret_code 1
}
}
if { $ret_code } \
{
if [winfo exists $dlg_id] {
UI_PB_com_DismissActiveWindow $dlg_id
UI_PB_OpenCancel_CB $dlg_id
}
if { [llength $args] == 0 } { ;# Not editing a visited Post... redisplay file open dialog.
global tcl_platform
if {$tcl_platform(platform) == "unix"} {
UI_PB_file_OpenPost_unx
}
}
PB_com_unset_var gPB(post_in_progress)
return TCL_ERROR
}
set pui_file [file tail $file_name]
PB_int_ReadPostFiles dir def_file tcl_file
PB_int_SetPostOutputFiles dir pui_file def_file tcl_file
set gPB(Output_Dir) $dir
update
if {$::disable_license == 0} {
if {[info exists LicInfo(is_encrypted_file)] && $LicInfo(is_encrypted_file) == 1} {
if {$gPB(PB_LICENSE) == "UG_POST_AUTHOR" && $LicInfo(SITE_ID_IS_OK_FOR_PT) == 1} {
if {[string length $gPB(lic_list)] == 0} {
set LicInfo(user_right_limit) YES
} else {
if {[info exists gPB(lic_list)] && $gPB(lic_list) != ""} {
set idx [lsearch $gPB(lic_list) $LicInfo(post_license)]
if {$idx >= 0} {
set LicInfo(user_right_limit) NO
} else {
set LicInfo(user_right_limit) YES
}
} else {
set LicInfo(user_right_limit) YES
}
}
} else {
set LicInfo(user_right_limit) YES
}
} else {
set LicInfo(user_right_limit)  NO
}
}
if [catch { UI_PB_main_window } result] \
{
if { ![info exists gPB(auto_qc)] || $gPB(auto_qc) != 1} {
tk_messageBox -parent $top_win -type ok -icon error \
-title $gPB(msg,dialog,title) \
-message "$gPB(msg,file_corruption) : \n$result"
}
PB_com_unset_var gPB(post_in_progress)
return TCL_ERROR
} else \
{
if [winfo exists $dlg_id] \
{
UI_PB_com_DismissActiveWindow $dlg_id
}
}
if {[info exists LicInfo(is_encrypted_file)] && $LicInfo(is_encrypted_file) == 1} {
set title "$gPB(Postbuilder_Release) - License : [lindex $LicInfo(post_license) 0]"
__ChangeTopWinTitle $title
} else {
if [info exists gPB(def_title)] {
__ChangeTopWinTitle $gPB(def_title)
}
}
update
UI_PB_ActivateOpenFileOpts
AcceptMachineToolSelection
set gPB(session) EDIT
set file_name [join [split $file_name "\\"] "/"]
if [info exists gPB(open_files_list)] {
set gPB(open_files_list) [ladd $gPB(open_files_list) 0 $file_name "no_dup"]
} else {
lappend gPB(open_files_list) $file_name
}
if { $file_name != "" } {
set gPB(work_dir) [file dirname $file_name]
}
UI_PB_com_SetStatusbar "$gPB(machine,Status)"
PB_com_unset_var gPB(post_in_progress)
UI_PB_DestroyProgress
if {[info exists ::disable_license] && $::disable_license == 0} {
if {[info exists ::LicInfo(user_right_limit)] && $::LicInfo(user_right_limit) == "YES"} {
if {![info exists gPB(auto_qc)] || $gPB(auto_qc) != 1} {
tk_messageBox -message $gPB(msg,limit_msg) -icon info -parent $gPB(main_window)
}
}
}
return TCL_OK
}
proc __file_ContinueAutoQC { args } {
set wlist [tixDescendants .]
foreach witem $wlist {
if [string match "Toplevel" [winfo class $witem]] {
UI_PB_debug_ForceMsg "toplevel==$witem"
}
}
if 0 {
set err_msg_win [UI_PB_com_AskActiveWindow].__tk__messagebox
if [winfo exists $err_msg_win] {
destroy $err_msg_win
} else {
global gPB
set err_msg_win $gPB(top_window).__tk__messagebox
if [winfo exists $err_msg_win] {
destroy $err_msg_win
}
}
}
}
proc __ValidateCurrentTab { args } {
global gPB
set top_page_list $Book::($gPB(book),page_obj_list)
switch $Book::($gPB(book),current_tab) {
"2" {
set book_obj $Page::([lindex $top_page_list 2],book_obj)
switch $Book::($book_obj,current_tab) {
"3" {
set pass 0
set error_code 0
set check_display 2
UI_PB_ads_ValidateIncludeItems pass error_code $check_display
if {$pass == 1} {
return 0
}
}
}
}
}
}
proc __ValidateMaxSeqNum { args } {
global gPB
set pb_book_id        $Book::($gPB(book),book_id)
set pb_book_page_list $Book::($gPB(book),page_obj_list)
set current_book_tab  $Book::($gPB(book),current_tab)
set chap    [lindex $pb_book_page_list $current_book_tab]
if { $current_book_tab == 1 } {
set sect    $Page::($chap,book_obj)
set sect_id $Book::($sect,book_id)
set page_tab $Book::($sect,current_tab)
set page_obj [lindex $Book::($sect,page_obj_list) $page_tab]
if { $page_tab == 3 } {
set max [UI_PB_ads_ValidateMaxN]
if $max {
tk_messageBox -parent [UI_PB_com_AskActiveWindow] \
-type ok -icon error \
-message "$gPB(msg,add_max1) N $gPB(msg,add_max2) $max."
return 0
}
}
}
if { $current_book_tab == 2 } {
set sect    $Page::($chap,book_obj)
set sect_id $Book::($sect,book_id)
set page_tab $Book::($sect,current_tab)
set page_obj [lindex $Book::($sect,page_obj_list) $page_tab]
if { $page_tab == 1 } {
global ADDRESSOBJATTR
global mom_sys_arr
set tmp $mom_sys_arr(seqnum_max)
set mom_sys_arr(seqnum_max) $ADDRESSOBJATTR(4)
set max [UI_PB_ads_ExceedMaxSeqNum $ADDRESSOBJATTR(1)]
set mom_sys_arr(seqnum_max) $tmp
if $max {
tk_messageBox -parent [UI_PB_com_AskActiveWindow] \
-type ok -icon error \
-message "$gPB(msg,add_max1) N $gPB(msg,add_max2) $max."
return 0
}
}
if { $page_tab == 3 } {
set max [UI_PB_ads_ExceedMaxSeqNum]
if $max {
tk_messageBox -parent [UI_PB_com_AskActiveWindow] \
-type ok -icon error -message "$gPB(msg,seq_num_max) $max."
return 0
}
}
}
return 1
}
proc UI_PB_SavePost { args } {
global env
if {[info exists env(MULTI_INTERP)] && $env(MULTI_INTERP) == 1} {
global gPB
if [info exists gPB(master_pid)] {
UI_PB_SavePost_mod $args
} else {
global PID
comm::comm send $PID(activated) [list UI_PB_SavePost_mod $args]
}
} else {
UI_PB_SavePost_mod $args
}
}
proc UI_PB_SavePost_mod { args } {
global gPB
if { $gPB(use_info) } \
{
UI_PB_chelp_DisplayMenuItemCsh $gPB(file_menu)
return
}
if { [__ValidateMaxSeqNum] == 0 } {
return
}
if {[__ValidateCurrentTab] == 0} {
return
}
if { $gPB(session) == "NEW" } \
{
UI_PB_SavePostAs
global tcl_platform
if {$tcl_platform(platform) == "unix"} \
{
tkwait variable gPB(session)
}
} else \
{
UI_PB_save_a_post
}
}
proc UI_PB_SavePostAs { args } {
global env gPB
set l [info level]
if {$l == 1} {
if {[info exists env(MULTI_INTERP)] && $env(MULTI_INTERP) == 1} {
global PID
comm::comm send $PID(activated) [list set gPB(backup_method) "NO_BACKUP"]
comm::comm send $PID(activated) [list UI_PB_SavePostAs_mod $args]
comm::comm send $PID(activated) [list set gPB(backup_method) $gPB(backup_method)]
} else {
set old_bk $gPB(backup_method)
set gPB(backup_method) "NO_BACKUP"
UI_PB_SavePostAs_mod $args
set gPB(backup_method) $old_bk
}
} else {
UI_PB_SavePostAs_mod $args
}
}
proc UI_PB_SavePostAs_mod { args } {
global gPB
global tcl_platform
global gpb_prev_status
global env
if { $gPB(use_info) } \
{
UI_PB_chelp_DisplayMenuItemCsh $gPB(file_menu)
return
}
if { [__ValidateMaxSeqNum] == 0 } {
return
}
if {[__ValidateCurrentTab] == 0} {
return
}
if [info exists gPB(master_pid)] {
set gpb_prev_status [comm::comm send $gPB(master_pid) [list set gPB(menu_bar_status)]]
} else {
set gpb_prev_status $gPB(menu_bar_status)
}
UI_PB_com_SetStatusbar "$gPB(save_as,Status)"
UI_PB_select_license_for_post
UI_PB_file_GetWorkFileDir
if { $gPB(session) == "NEW" } {
global pb_output_file
set gPB(work_file) [file tail $pb_output_file.pui]
}
if {$tcl_platform(platform) == "unix"} \
{
UI_PB_file_SavePostAs_unx
} elseif {$tcl_platform(platform) == "windows"} \
{
UI_PB_file_SavePostAs_win
}
}
proc UI_PB_file_SavePostAs_unx { args } {
global tixOption
global paOption
global gPB
global gpb_file_ext
global gpb_pui_file
global gpb_def_file
global gpb_tcl_file
PB_int_ReadPostOutputFiles cur_dir gpb_pui_file gpb_def_file \
gpb_tcl_file
set gpb_file_ext "pui"
set win $gPB(main_window).save_as
set act_win [UI_PB_com_AskActiveWindow]
if { [winfo exists $win] } \
{
$win popup
wm transient $win $act_win
UI_PB_com_ClaimActiveWindow $win
set fbox [$win subwidget fsbox]
$fbox config -directory $gPB(work_dir) \
-value $gPB(work_file)
$fbox filter
[$fbox subwidget types] pick 0
if { $gPB(work_file) != "" } {
[$fbox subwidget file] addhistory $gPB(work_file)
[$fbox subwidget file] pick 0
[[$fbox subwidget file] subwidget entry] selection range 0 end
}
UI_PB_com_DisableMain
} else \
{
tixExFileSelectDialog $win -command "UI_PB_SavePbFiles_unx $win"
UI_PB_com_CreateTransientWindow $win "$gPB(save_as,title,Label)" \
"600x400+200+100" "" "" "" "UI_PB_SaveAsCancel_CB $win"
set fbox [$win subwidget fsbox]
UI_PB_com_PositionWindow $win
set ftypes [list \{*.pui\}\ \{$gPB(save_as,file_type_pui)\}]
$fbox config -filetypes $ftypes
[$fbox subwidget cancel] config -width 10 -bg $paOption(app_butt_bg) \
-command "UI_PB_SaveAsCancel_CB $win"
[$fbox subwidget ok]     config -width 10 -bg $paOption(app_butt_bg) \
-text $gPB(nav_button,save,Label)
$win popup
wm transient $win $act_win
set fdir [[$fbox subwidget dir] subwidget entry]
set file [[$fbox subwidget file] subwidget entry]
bind $fdir <KeyPress> "UI_PB_com_DisableSpaceKey %W %K"
bind $fdir <KeyRelease> { %W config -state normal }
bind $file <KeyPress> "UI_PB_com_DisableSpaceKey %W %K"
bind $file <KeyRelease> { %W config -state normal }
$fbox config -pattern "*.pui" \
-directory $gPB(work_dir) \
-value $gPB(work_file)
[$fbox subwidget file] config -history yes -prunehistory yes
[$fbox subwidget dir]  config -history yes -prunehistory yes
[$fbox subwidget dirlist] config -browsecmd "__file_SaveAsDirCmd_unx $fbox"
$fbox filter
[$fbox subwidget types] pick 0
if { $gPB(work_file) != "" } {
[$fbox subwidget file] addhistory $gPB(work_file)
[$fbox subwidget file] pick 0
[[$fbox subwidget file] subwidget entry] selection range 0 end
}
UI_PB_com_DisableMain
}
UI_PB_GrayOutAllFileOptions
set gPB(save_as_now) 1
if [info exists gPB(master_pid)] {
comm::comm send -async $gPB(master_pid) [list set gPB(save_as_now) 1]
}
$gPB(main_menu_bar).file.m entryconfigure $gPB(menu_index,file,exit) -state disabled
}
proc __file_SaveAsDirCmd_unx { fbox dir } {
$fbox config -directory $dir
$fbox filter
[$fbox subwidget file] pick 0
}
proc UI_PB_file_SavePostAs_win { args } {
global gPB
global env
global gpb_file_ext
global gpb_pui_file
global gpb_def_file
global gpb_tcl_file
global gpb_prev_status
PB_int_ReadPostOutputFiles cur_dir gpb_pui_file gpb_def_file \
gpb_tcl_file
set gpb_file_ext "pui"
set types {
{ {Post Builder Session} {.pui} }
}
UI_PB_com_ChangeCHelpState disabled
set acwin [UI_PB_com_AskActiveWindow]
set win $acwin.__tk_filedialog
set gPB(main_window).save_as $win
UI_PB_com_ClaimActiveWindow $win
UI_PB_com_DisableMain
UI_PB_GrayOutAllFileOptions
if [info exists gPB(master_pid)] {
comm::comm send -async $gPB(master_pid) [list UI_PB_GrayAndUnGrayWindowMenu gray 0]
}
set gPB(save_as_now) 1
if [info exists gPB(master_pid)] {
comm::comm send -async $gPB(master_pid) \
{$gPB(main_menu_bar).file.m entryconfigure $gPB(menu_index,file,exit) -state disabled}
comm::comm send -async $gPB(master_pid) [list set gPB(save_as_now) 1]
} else {
$gPB(main_menu_bar).file.m entryconfigure $gPB(menu_index,file,exit) -state disabled
}
while {1} {
set filename [tk_getSaveFile -filetypes $types \
-title "$gPB(save_as,title,Label)" \
-defaultextension "pui" \
-initialfile $gPB(work_file) \
-initialdir $gPB(work_dir) \
-parent $acwin]
if [string match "* *" [file tail $filename]] {
tk_messageBox -parent $acwin -type ok -icon error \
-title $gPB(msg,dialog,title) \
-message $gPB(msg,filename_with_space)
} else {
if [info exists gPB(master_pid)] {
set res [comm::comm send $gPB(master_pid) [list UI_PB_com_CanBeOverwrited [comm::comm self] $filename]]
if {$res == 1} {
break
} else {
tk_messageBox -parent $acwin -type ok -icon error \
-title $gPB(msg,dialog,title) \
-message $gPB(msg,filename_protection)
}
} else {
break
}
}
}
UI_PB_com_DelistActiveWindow $win
UI_PB_com_ClaimActiveWindow $acwin
UI_PB_com_EnableMain
UI_PB_com_ChangeCHelpState normal
if { $filename != "" } {
set gPB(work_dir) [file dirname $filename]
set gPB(work_file) $filename
UI_PB_SavePbFiles_win $win $filename
}
UI_PB_ActivateOpenFileOpts
if [info exists gPB(master_pid)] {
comm::comm send -async $gPB(master_pid) [list UI_PB_GrayAndUnGrayWindowMenu ungray 0]
}
}
proc UI_PB_SaveAsCancel_CB { dialog_id } {
global gPB
global gpb_prev_status
if [winfo exists $dialog_id] {
$dialog_id popdown
UI_PB_com_DismissActiveWindow $dialog_id
}
UI_PB_ActivateOpenFileOpts
UI_PB_com_SetStatusbar "$gpb_prev_status"
}
proc UI_PB_SaveAsDlgFilter { win } {
UI_PB_SaveAsSetPattern $win
UI_PB_UpdateFileListBox $win
}
proc UI_PB_UpdateFileListBox { win } {
global gPB
set file_box [$win subwidget fsbox]
set pattern [$file_box cget -pattern]
set top_filter_ent [[$file_box subwidget filter] subwidget entry]
set entry_text [$top_filter_ent get]
set dir [file dirname $entry_text]
global tcl_platform
if { $tcl_platform(platform) != "unix" } \
{
set dir [string trimright $dir "*"]
set dir [string trimright $dir "\\"]
}
$file_box config -directory $dir
set file_listbox [[$file_box subwidget filelist] subwidget listbox]
$file_listbox delete 0 end
set cur_dir [pwd]
if { [file isdirectory $dir] } \
{
cd $dir
foreach match [lsort -dictionary [glob -nocomplain -- $pattern]] \
{
$file_listbox insert end $match
}
cd $cur_dir
} else \
{
set main_win $win
tk_messageBox -parent $main_win -type ok -icon error \
-title $gPB(msg,dialog,title) \
-message "$gPB(msg,invalid_dir)"
}
}
proc UI_PB_SaveAsSetPattern { win } {
global gpb_file_ext
UI_PB_UpdateFileListBox $win
set file_box [$win subwidget fsbox]
$file_box config -pattern "*.$gpb_file_ext"
}
proc UI_PB_AssignFileName { win } {
global gpb_file_ext
global gpb_pui_file
global gpb_def_file
global gpb_tcl_file
set file_box [$win subwidget fsbox]
set file_listbox [[$file_box subwidget filelist] subwidget listbox]
set sel_ent [$file_box subwidget selection]
$sel_ent config -value $gpb_pui_file
set sel_index [$file_listbox curselection]
set sel_file_name [$file_listbox get $sel_index $sel_index]
switch $gpb_file_ext \
{
"pui"  { set gpb_pui_file $sel_file_name }
"def"  { set gpb_def_file $sel_file_name }
"tcl"  { set gpb_tcl_file $sel_file_name }
}
wm deiconify $win
}
proc UI_PB_SavePbFiles_unx { win select_file_name } {
global gPB
global gpb_pui_file
global gpb_def_file
global gpb_tcl_file
global gpb_prev_status
set win [UI_PB_com_AskActiveWindow]
set select_file_name "[file rootname $select_file_name].pui"
set new_dir [file dirname $select_file_name]
if { $new_dir != "." } \
{
set cur_dir $new_dir
}
if { [file isdirectory $new_dir] == 0 } \
{
tk_messageBox -parent $win -type ok -icon error \
-title $gPB(msg,dialog,title) \
-message "$gPB(msg,invalid_dir)"
wm deiconify $win
return
} elseif { [llength [split $select_file_name " "]] > 1 } \
{
tk_messageBox -parent $win -type ok -icon error \
-title $gPB(msg,dialog,title) \
-message "$gPB(msg,invalid_file)"
wm deiconify $win
return
} elseif { [file writable $new_dir] == 0 } \
{
tk_messageBox -parent $win -type ok -icon error \
-title $gPB(msg,dialog,title) \
-message "$gPB(msg,dir_perm)"
set file [[$win subwidget fsbox] subwidget file]
[$file subwidget listbox] delete 0
$file addhistory $gPB(work_file)
wm deiconify $win
return
}
set file_name [file rootname $select_file_name]
set file_string ""
if [file exists $file_name.def] { set file_string "$file_name.def" }
if [file exists $file_name.tcl] { set file_string "$file_name.tcl\n$file_string" }
if [file exists $file_name.pui] { set file_string "$file_name.pui\n$file_string" }
if { $file_string != "" } \
{
set ans [tk_messageBox -parent $win -type yesno -icon question \
-title $gPB(msg,dialog,title) \
-message "$file_string $gPB(msg,file_exist)"]
if { $ans == "no" } \
{
wm deiconify $win
return
}
}
set file_tail [file tail $select_file_name]
set dot_index [string last . $file_tail]
if { $dot_index != -1 } \
{
set file_tail [string range $file_tail 0 [expr $dot_index - 1]]
}
set pui_file $file_tail.pui
set def_file $file_tail.def
set tcl_file $file_tail.tcl
PB_int_SetPostOutputFiles cur_dir pui_file def_file tcl_file
set gPB(Output_Dir) $cur_dir
UI_PB_save_a_post yes
set select_file_name [join [split $select_file_name "\\"] "/"]
set gPB(open_files_list) [ladd $gPB(open_files_list) 0 $select_file_name "no_dup"]
set gPB(work_file) [file tail $select_file_name]
if { $select_file_name != "" } {
set gPB(work_dir) [file dirname $select_file_name]
}
UI_PB_SaveAsCancel_CB $win
}
proc UI_PB_SavePbFiles_win { win select_file_name } {
global gPB
set cur_dir [file dirname $select_file_name]
set file_tail [file tail $select_file_name]
set dot_index [string last . $file_tail]
if { $dot_index != -1 } \
{
set file_tail [string range $file_tail 0 [expr $dot_index - 1]]
}
set pui_file $file_tail.pui
set def_file $file_tail.def
set tcl_file $file_tail.tcl
PB_int_SetPostOutputFiles cur_dir pui_file def_file tcl_file
set gPB(Output_Dir) $cur_dir
UI_PB_save_a_post yes
set select_file_name [join [split $select_file_name "\\"] "/"]
set gPB(open_files_list) [ladd $gPB(open_files_list) 0 $select_file_name "no_dup"]
set gPB(work_file) [file tail $select_file_name]
if { $select_file_name != "" } {
set gPB(work_dir) [file dirname $select_file_name]
}
UI_PB_SaveAsCancel_CB $win
}
proc UI_PB_AttachExtToFile { FILE_NAME ext } {
upvar $FILE_NAME file_name
if { [string match *.$ext $file_name] == 0 } \
{
set file_name $file_name.$ext
}
}
proc UI_PB_GrayOutAllFileOptions { } {
global gPB
if [info exists gPB(master_pid)] {
comm::comm send $gPB(master_pid) [list UI_PB_GrayOutAllFileOptions_mod]
} else {
UI_PB_GrayOutAllFileOptions_mod
}
}
proc UI_PB_GrayOutAllFileOptions_mod { } {
global gPB
set pb_topwin $gPB(top_window)
set mb $gPB(main_menu_bar).file.m
$mb entryconfigure $gPB(menu_index,file,new)     -state disabled
$mb entryconfigure $gPB(menu_index,file,open)    -state disabled
if [catch { $mb entryconfigure $gPB(menu_index,file,mdfa) -state disabled } result] { }
$mb entryconfigure $gPB(menu_index,file,save)    -state disabled
$mb entryconfigure $gPB(menu_index,file,save_as) -state disabled
$mb entryconfigure $gPB(menu_index,file,close)   -state disabled
catch { $mb entryconfigure $gPB(menu_index,file,history) -state disabled }
set mm $gPB(main_menu).tool
[$mm subwidget new]  config -state disabled
[$mm subwidget open] config -state disabled
[$mm subwidget save] config -state disabled
if 0 {
bind all <Control-n> "UI_PB_NewPost"
bind all <Control-o> "UI_PB_OpenPost"
bind all <Control-s> "UI_PB_SavePost"
bind all <Control-a> "UI_PB_SavePostAs"
}
bind all <Control-n> ""
bind all <Control-o> ""
bind all <Control-s> ""
bind all <Control-a> ""
}
proc UI_PB_ActivateOpenFileOpts { } {
global gPB
if [info exists gPB(master_pid)] {
comm::comm send $gPB(master_pid) [list UI_PB_ActivateOpenFileOpts_mod]
} else {
UI_PB_ActivateOpenFileOpts_mod
}
}
proc UI_PB_ActivateOpenFileOpts_mod { } {
global gPB
set pb_topwin $gPB(top_window)
set mb $gPB(main_menu_bar).file.m
if {[info exists ::env(MULTI_INTERP)] && $::env(MULTI_INTERP) == 1} {
if {[info exists ::env(LIMIT_NUM)] && $::env(LIMIT_NUM) == 1} {
$mb entryconfigure $gPB(menu_index,file,new)     -state disabled ;# New
$mb entryconfigure $gPB(menu_index,file,open)    -state disabled ;# Open
} else {
$mb entryconfigure $gPB(menu_index,file,new)     -state normal ;# New
$mb entryconfigure $gPB(menu_index,file,open)    -state normal ;# Open
}
} else {
$mb entryconfigure $gPB(menu_index,file,new)     -state disabled ;# New
$mb entryconfigure $gPB(menu_index,file,open)    -state disabled ;# Open
}
if [catch { $mb entryconfigure $gPB(menu_index,file,mdfa) -state disabled } result] { }
$mb entryconfigure $gPB(menu_index,file,save)    -state normal   ;# Save
$mb entryconfigure $gPB(menu_index,file,save_as) -state normal   ;# Save As
$mb entryconfigure $gPB(menu_index,file,close)   -state normal   ;# Close
$mb entryconfigure $gPB(menu_index,file,exit)    -state normal   ;# Exit
if {[info exists ::env(MULTI_INTERP)] && $::env(MULTI_INTERP) == 1} {
if {[info exists ::env(LIMIT_NUM)] && $::env(LIMIT_NUM) == 1} {
catch { $mb entryconfigure $gPB(menu_index,file,history) -state disabled } ;# Visited Posts
} else {
catch { $mb entryconfigure $gPB(menu_index,file,history) -state normal } ;# Visited Posts
}
} else {
catch { $mb entryconfigure $gPB(menu_index,file,history) -state disabled } ;# Visited Posts
}
PB_com_unset_var gPB(save_as_now)
if {[info exists ::env(MULTI_INTERP)] && $::env(MULTI_INTERP) == 1} {
if {[info exists ::PID(activated)] && $::PID(activated) != ""} {
comm::comm send -async $::PID(activated) [list PB_com_unset_var gPB(save_as_now)]
}
}
set mm $gPB(main_menu).tool
if {[info exists ::env(MULTI_INTERP)] && $::env(MULTI_INTERP) == 1} {
if {[info exists ::env(LIMIT_NUM)] && $::env(LIMIT_NUM) == 1} {
[$mm subwidget new]  config -state disabled
[$mm subwidget open] config -state disabled
[$mm subwidget save] config -state normal
} else {
[$mm subwidget new]  config -state normal
[$mm subwidget open] config -state normal
[$mm subwidget save] config -state normal
}
} else {
[$mm subwidget new]  config -state disabled
[$mm subwidget open] config -state disabled
[$mm subwidget save] config -state normal
}
$mb entryconfigure $gPB(menu_index,file,exit) -state normal ;# Exit
bind all <Control-n> ""
bind all <Control-o> ""
bind all <Control-s> "UI_PB_SavePost"
bind all <Control-a> "UI_PB_SavePostAs"
}
proc UI_PB_GrayAndUnGrayWindowMenu { type {action_to_sub 1}} {
global gPB
if {[info exists ::env(LIMIT_NUM)] && $::env(LIMIT_NUM) == 1} {
return
}
if {$type == "gray"} {
if [winfo exists $gPB(window_menu)] {
[winfo parent $gPB(window_menu)] config -state disabled
}
if {$action_to_sub == 1} {
if {[info exists ::PID(activated)] && $::PID(activated) != ""} {
comm::comm send -async $::PID(activated) [list UI_PB_com_DisableProcess]
}
}
} else {
if [winfo exists $gPB(window_menu)] {
if {[llength $::PID(posts_list)] != 0 } {
[winfo parent $gPB(window_menu)] config -state normal
}
}
if {$action_to_sub == 1} {
if {[info exists ::PID(activated)] && $::PID(activated) != ""} {
comm::comm send -async $::PID(activated) [list UI_PB_com_EnableProcess]
}
}
}
}
proc UI_PB_NewPost { } {
global tixOption paOption
global gPB
global env
if { $gPB(use_info) } \
{
UI_PB_chelp_DisplayMenuItemCsh $gPB(file_menu)
return
}
UI_PB_com_SetStatusbar "$gPB(new,Status)"
if { [lsearch -exact [package names] "stooop"] < 0 } {
source $env(PB_HOME)/tcl/exe/stooop.tcl
namespace import stooop::*
}
set win $gPB(top_window).new
if {[info exists env(MULTI_INTERP)] && $env(MULTI_INTERP) == 1} {
UI_PB_GrayAndUnGrayWindowMenu gray
}
if [winfo exists $win] \
{
wm deiconify $win
UI_PB_com_ClaimActiveWindow $win
UI_PB_GrayOutAllFileOptions
return
}
if [winfo exists $gPB(top_window).new.user_cntl_frag] {
destroy $gPB(top_window).new.user_cntl_frag
}
PB_com_unset_var gPB(widgets_disabled)
toplevel $win
UI_PB_com_CreateTransientWindow $win "$gPB(new,title,Label)" "+200+100" \
"" "" "wm withdraw $win;destroy $win" "UI_PB_NewDestroy"
global output_unit
wm withdraw $win
global new_mach_type
global mach_axis
global pb_output_file
if {[info exists ::env(INCH_METRIC)] && $::env(INCH_METRIC) == 1} {
set output_unit "Dual"
} else {
set output_unit "Inches"
}
set new_mach_type "Mill"
set mach_axis "3"
if {[info exists env(MULTI_INTERP)] && $env(MULTI_INTERP) == 1} {
global std_file_name
if ![info exists std_file_name] {
set std_file_name "new_post1"
}
set pb_output_file $std_file_name
} else {
set pb_output_file "new_post"
}
set label_list {"gPB(nav_button,cancel,Label)" \
"gPB(nav_button,ok,Label)"}
set cb_arr(gPB(nav_button,cancel,Label)) "UI_PB_NewCancel_CB $win"
set cb_arr(gPB(nav_button,ok,Label)) "__NewPost $win"
UI_PB_com_CreateButtonBox $win label_list cb_arr
frame $win.top -relief raised -bd 1
pack $win.top -side top -fill both -expand yes
frame $win.top.level1
frame $win.top.level2
frame $win.top.level3
frame $win.top.level5
frame $win.top.level5.left
frame $win.top.level5.right
set name_lbl [label $win.top.level1.name -font $tixOption(bold_font)\
-text [format "%-10s" "$gPB(new,name,Label)"]];#<04-18-07 peter>10 was 30
set name_ent [entry $win.top.level1.ent -width 56 -relief sunken \
-textvariable pb_output_file] ;#<09-14-05 peter> width was 49
$name_ent config -bg $paOption(tree_bg)
bind $name_ent <KeyPress> "UI_PB_com_DisableSpecialChars %W %K"
bind $name_ent <KeyRelease> { %W config -state normal }
tixForm $name_lbl -left %0  -padx 10 -pady 10
tixForm $name_ent -left %25 -right %100 -padx 10 -pady 10
pack $win.top.level1 -side top -fill x -expand yes
pack $win.top.level2 -side top -fill x -expand yes
pack $win.top.level3 -side top -fill both -expand yes
pack $win.top.level5 -side top -fill both -expand yes
pack $win.top.level5.left -side left -fill both -expand yes
pack $win.top.level5.right -side right -fill both -expand yes
set desc_lab [label $win.top.level2.lab -font $tixOption(bold_font)\
-text [format "%-10s" "$gPB(new,desc,Label)"]];#<04-18-07 peter>10 was 30
set desc_txt [tixScrolledText $win.top.level2.desc \
-height 50 -width 398 -scrollbar y];#<09-14-05 peter>width was 400
set gPB(post_desc_win) [$desc_txt subwidget text]
[$desc_txt subwidget text] config -bg $paOption(tree_bg)
[$desc_txt subwidget vsb]  config -width $paOption(trough_wd) \
-troughcolor $paOption(trough_bg)
tixForm $desc_lab -left %0  -padx 10 -pady 5
tixForm $desc_txt -left %25 -right %100 -padx 10 -pady 5
if {![info exists ::env(INCH_METRIC)] || $::env(INCH_METRIC) == 0} {
tixLabelFrame $win.top.level3.lbf -label "$gPB(new,post_unit,Label)"
set out_frame [$win.top.level3.lbf subwidget frame]
pack $win.top.level3.lbf -side left -pady 10
radiobutton $out_frame.inch -text "$gPB(new,inch,Label)" \
-variable output_unit -anchor w  -value "Inches"
radiobutton $out_frame.mm -text "$gPB(new,millimeter,Label)" \
-variable output_unit -anchor w -value "Millimeters"
pack $out_frame.inch $out_frame.mm -side left -padx 10 -pady 5 -fill x
}
global ::ude_enable
set ::ude_enable $env(PB_UDE_ENABLED)
if {$::ude_enable == 2} {
set ::ude_enable 0
}
set ude_f [frame $win.top.level3.ude]
if 0 {
set ude_ckb [checkbutton $ude_f.ckb -text "$gPB(ude,editor,enable,Label)" \
-variable ::ude_enable -onvalue 1 \
-offvalue 0]
pack $ude_f -fill both -expand yes
if {![info exists ::env(INCH_METRIC)] || $::env(INCH_METRIC) == 0} {
grid $ude_ckb -column 0 -row 0 -sticky news
} else {
pack $ude_ckb -side left -padx 10 -pady 10
}
}
tixLabelFrame $ude_f.lf -labelside none
set ude_fr [$ude_f.lf subwidget frame]
set ude_ckb [checkbutton $ude_fr.ckb -text "$gPB(ude,editor,enable,Label)" \
-variable ::ude_enable -onvalue 1 \
-offvalue 0]
pack $ude_f -side right -fill x -expand yes -anchor s
if { ![info exists ::env(INCH_METRIC)] || $::env(INCH_METRIC) == 0 } {
grid $ude_f.lf -column 0 -row 0 -pady 11 -sticky news
pack $ude_ckb -side left -padx 10 -pady 10
} else {
pack $ude_f.lf -side left -pady 10
pack $ude_ckb -side left -padx 10 -pady 10
}
tixLabelFrame $win.top.level5.left.top -label "$gPB(new,machine,Label)"
set fa [$win.top.level5.left.top subwidget frame]
pack $win.top.level5.left.top -side top -fill both
tixLabelFrame $win.top.level5.left.bottom -label "$gPB(new,control,Label)"
set fb [$win.top.level5.left.bottom subwidget frame]
pack $win.top.level5.left.bottom -side top -pady 10 -fill both
radiobutton $fa.mill -text "$gPB(new,mill,Label)" \
-variable new_mach_type -anchor w \
-value "Mill" -command "CB_MachType $win Mill $fa $fb"
radiobutton $fa.lathe -text "$gPB(new,lathe,Label)" \
-variable new_mach_type -anchor w \
-value "Lathe" -command "CB_MachType $win Lathe $fa $fb"
radiobutton $fa.wedm -text "$gPB(new,wire,Label)" \
-variable new_mach_type -anchor w \
-value "Wedm" -command "CB_MachType $win Wedm $fa $fb"
radiobutton $fa.punch -text "$gPB(new,punch,Label)" \
-variable new_mach_type -anchor w \
-value "Punch" -command "CB_MachType $win Punch $fa $fb"
grid $fa.mill  -sticky w -padx 5 -pady 2
grid $fa.lathe -sticky w -padx 5 -pady 2
if { [PB_is_v3] >= 0 } {
grid $fa.wedm  -sticky w -padx 5 -pady 2
}
tixOptionMenu $fa.axis                  \
-variable mach_axis                 \
-command  "CB_MachineAxisType $win $new_mach_type" \
-options {
entry.anchor e
menubutton.width       30
}
[$fa.axis subwidget menubutton] config -font $tixOption(bold_font) \
-bg $paOption(header_bg) -fg yellow ;#<01-13-03 gsl> $paOption(special_fg)
grid $fa.axis -sticky w -padx 5 -pady 2
global mach_cntl_type
set fbt [frame $fb.type]
pack $fbt
radiobutton $fbt.g -text "$gPB(new,generic,Label)" \
-variable mach_cntl_type -anchor w  -value "Generic" \
-command "CB_CntlType $fb Generic"
radiobutton $fbt.s -text "$gPB(new,library,Label)" \
-variable mach_cntl_type -anchor w  -value "System" \
-command "CB_CntlType $fb System"
radiobutton $fbt.u -text "$gPB(new,user,Label)" \
-variable mach_cntl_type -anchor w  -value "User" \
-command "CB_CntlType $fb User"
pack $fbt.g $fbt.s $fbt.u -side left -padx 10 -pady 5 -fill x
if { [PB_is_v3] >= 0 } {
switch $::tix_version {
8.4 {
tixComboBox $fb.contr \
-dropdown   yes \
-editable   yes \
-variable   gPB(mach_sys_controller) \
-command    "" \
-selectmode immediate \
-grab       local \
-options {
listbox.anchor   w
listbox.height   2
listbox.width    31
entry.width      31
}
[$fb.contr subwidget entry] config -readonlybackground $paOption(entry_disabled_bg) \
-selectbackground lightblue \
-selectforeground black \
-cursor "" -state readonly
set gPB(LB_widget) [$fb.contr subwidget slistbox]
$gPB(LB_widget) config -width 100
pack $fb.contr -padx 5 -pady 7 -fill x -expand yes
}
4.1 {
tixComboBox $fb.contr \
-dropdown   yes \
-editable   false \
-variable   gPB(mach_sys_controller) \
-command    "" \
-selectmode immediate \
-grab       local \
-options {
listbox.anchor   w
listbox.height   2
listbox.width    31
entry.width      31
}
[$fb.contr subwidget entry] config -bg $paOption(entry_disabled_bg) -cursor ""
pack $fb.contr -padx 5 -pady 7 -fill x -expand yes
}
}
} else {
tixOptionMenu $fb.contr       \
-variable gPB(mach_sys_controller) \
-options {
entry.anchor e
menubutton.width       30
}
[$fb.contr subwidget menubutton] config -font $tixOption(bold_font) \
-bg $paOption(header_bg) -fg $paOption(special_fg)
pack $fb.contr -padx 5 -pady 2
}
set fbu [frame $fb.user]
pack $fbu -padx 5 -pady 2
entry $fbu.ent -width 25 -relief sunken -textvariable gPB(mach_user_controller)
set gPB(widgets_disabled) [list $fb $win.box]
button $fbu.but -text "$gPB(new,user,browse,Label)" -command "__file_SelectPost"
pack $fbu.ent -side left -padx 3
pack $fbu.but -side right
set mach_cntl_type "Generic"
CB_CntlType $fb Generic
canvas $win.top.level5.right.can -width 300 -height 300 -scrollregion "0 0 300 300";#peter Add the last option
$win.top.level5.right.can config -bg black -relief sunken
pack $win.top.level5.right.can -fill both -expand yes -padx 5 \
-pady 13 ;#<01-15-08 peter> was 5
image create photo myphoto -file $env(PB_HOME)/images/pb_hg500.gif
$win.top.level5.right.can create image 150 150 -image myphoto
CB_MachType $win $new_mach_type $fa $fb
UI_PB_GrayOutAllFileOptions
set gPB(c_help,$win.top.level1.ent)                     "new,name"
set gPB(c_help,[$win.top.level2.desc subwidget text])   "new,desc"
if {![info exists ::env(INCH_METRIC)] || $::env(INCH_METRIC) == 0} {
set gPB(c_help,$out_frame.inch)                         "new,inch"
set gPB(c_help,$out_frame.mm)                           "new,millimeter"
}
if { [PB_is_v3] >= 0 } {
set gPB(c_help,[$fb.contr subwidget listbox])        "new,control"
} else {
set gPB(c_help,[$fb.contr subwidget menubutton])     "new,control"
}
set gPB(c_help,$fa.mill)                                "new,mill"
set gPB(c_help,$fa.lathe)                               "new,lathe"
set gPB(c_help,$fa.wedm)                                "new,wire"
set gPB(c_help,[$fa.axis subwidget menubutton])         "new,mach_axis"
wm deiconify $win
UI_PB_com_PositionWindow $win
wm resizable $win 0 0
}
proc __file_CreateComboList { w OPTS } {
upvar $OPTS opts
global gPB
set lbx [$w subwidget listbox]
$lbx delete 0 end
set gPB(mach_sys_controller) ""
if { [info exists opts] && [llength $opts] > 0 } {
foreach opt $opts {
set opt [file rootname $opt]
$w insert end $opt
}
set opt [file rootname [lindex $opts 0]]
set gPB(mach_sys_controller) $opt
tixSetSilent $w $opt
set h [expr [llength $opts] - 1]
if { $h > 10 } { set h 10 }
[$w subwidget listbox] config -height $h
}
tixSetSilent $w $gPB(mach_sys_controller)
}
proc __file_SelectPost { args } {
global gPB
global env
global tcl_platform
if { $gPB(use_info) } \
{
UI_PB_chelp_DisplayMenuItemCsh $gPB(file_menu)
return
}
UI_PB_com_SetStatusbar "Select a Post Builder session file."
UI_PB_file_GetWorkFileDir
set file_name [file join $gPB(work_dir) $gPB(work_file)]
if { ![file exists $file_name] } {
set gPB(work_file) ""
}
__file_DisableWidgets
if { ![info exists gPB(mach_user_controller)] } {
set gPB(mach_user_controller) ""
}
set old_file_name $gPB(mach_user_controller)
if {$tcl_platform(platform) == "unix"} \
{
UI_PB_file_SelectFile_unx PUI gPB(mach_user_controller) open
} elseif {$tcl_platform(platform) == "windows"} \
{
UI_PB_file_SelectFile_win PUI gPB(mach_user_controller) open
__file_EnableWidgets
}
if { $gPB(mach_user_controller) != "" } {
namespace eval CHECK {
set is_author 1
set gPB(mach_user_controller) [string trim $gPB(mach_user_controller) \"]
set root_name [file rootname $gPB(mach_user_controller)]
catch [source ${root_name}.tcl]
if { [info exists encrypted_post_file] } {
if { [file exists $encrypted_post_file] } {
if {$::gPB(PB_LICENSE) == "UG_POST_AUTHOR"} {
if [llength [info commands UI_PB_decrypt_post] ] {
set is_author [UI_PB_decrypt_post $encrypted_post_file TRUE NO YES]
} else {
set is_author 0
}
} else {
set is_author 0
}
} else {
set is_author "-1"
}
}
}
if {$::CHECK::is_author == 0} {
namespace delete CHECK
set gPB(mach_user_controller) "$old_file_name"
tk_messageBox -parent [UI_PB_com_AskActiveWindow] -icon warning \
-message $gPB(msg,user_ctrl_limit)
__file_SelectPost
} elseif {$::CHECK::is_author == 1} {
namespace delete CHECK
} else {
namespace delete CHECK
set gPB(mach_user_controller) "$old_file_name"
tk_messageBox -parent [UI_PB_com_AskActiveWindow] -icon warning \
-message $gPB(msg,no_file)
}
}
}
proc UI_PB_file_SelectFile_unx { file_type FILE_VAR flag args } {
upvar $FILE_VAR file_var
global tixOption
global paOption
global gPB
global env
set awin [UI_PB_com_AskActiveWindow]
set ext [string tolower $file_type]
UI_PB_file_GetWorkFileDir
set file_name [file join $gPB(work_dir) $gPB(work_file)]
if { ![file exists $file_name] || \
![string match ".$ext" [file extension $file_name]] } {
set gPB(work_file) ""
}
set work_dir  $gPB(work_dir)
set work_file $gPB(work_file)
switch $ext {
"pui" {
set win $awin.user_cntl_frag
set open_file_type $gPB(open,file_type_pui)
}
"tcl" {
set win $awin.user_cust_cmd
set open_file_type $gPB(open,file_type_tcl)
}
"def" {
set win $awin.def_file
set open_file_type $gPB(open,file_type_def)
}
"cdl" {
set win $awin.ude_cdl
set open_file_type $gPB(open,file_type_cdl)
}
default {
tk_messageBox -parent $awin -type ok -icon error \
-title $gPB(msg,dialog,title) \
-message "File type \"$file_type\" is not accepted by\
procedure \"[lindex [info level 0] 0]\"."
return TCL_ERROR
}
}
if { $file_var != "" } {
set work_dir  [file dirname $file_var]
set work_file [file tail    $file_var]
}
set work_dir [file nativename $work_dir]
if { [string tolower [file extension $work_file]] != ".$ext" } {
set work_file ""
}
tixExFileSelectDialog $win -command "__file_SelectFileName $win $FILE_VAR $flag"
UI_PB_com_CreateTransientWindow $win "Select a file" \
"600x400+200+100" "" "" \
"destroy $win" \
"UI_PB_com_EnableMain; __file_EnableWidgets"
set fbox [$win subwidget fsbox]
$win popup
set ftypes [list \{*.$ext\}\ \{$open_file_type\}]
$fbox config -filetypes $ftypes
catch {
$fbox config -pattern "*.$ext" \
-directory $work_dir \
-value $work_file
}
set fdir [[$fbox subwidget dir] subwidget entry]
set file [[$fbox subwidget file] subwidget entry]
bind $fdir <KeyPress> "UI_PB_com_DisableSpaceKey %W %K"
bind $fdir <KeyRelease> { %W config -state normal }
bind $file <KeyPress> "UI_PB_com_DisableSpaceKey %W %K"
bind $file <KeyRelease> { %W config -state normal }
[$fbox subwidget cancel] config -width 10 -bg $paOption(app_butt_bg) \
-command "destroy $win"
if { [string tolower $flag] == "save" } {
set ok_label $gPB(nav_button,save,Label)
} else {
set ok_label $gPB(nav_button,open,Label)
}
[$fbox subwidget ok]     config -bg $paOption(app_butt_bg) -width 10 \
-text $ok_label
[$fbox subwidget file]   config -history yes -prunehistory yes
[$fbox subwidget dir]    config -history yes -prunehistory yes
$fbox filter
[$fbox subwidget types] pick 0
if { $work_file != "" } {
[$fbox subwidget file] addhistory $work_file
[$fbox subwidget file] pick 0
}
UI_PB_com_PositionWindow $win
vwait $FILE_VAR
}
proc UI_PB_file_SelectFile_win { file_type FILE_VAR flag args } {
upvar $FILE_VAR file_var
global tixOption
global paOption
global gPB
global env
set awin [UI_PB_com_AskActiveWindow]
set ext [string tolower $file_type]
UI_PB_file_GetWorkFileDir
set file_name [file join $gPB(work_dir) $gPB(work_file)]
if { ![file exists $file_name] || \
![string match ".$ext" [file extension $file_name]] } {
set gPB(work_file) ""
}
set work_dir  $gPB(work_dir)
set work_file $gPB(work_file)
switch $ext {
"pui" {
set win $awin.user_cntl_frag
set open_file_type $gPB(open,file_type_pui)
}
"tcl" {
set win $awin.user_cust_cmd
set open_file_type $gPB(open,file_type_tcl)
}
"def" {
set win $awin.def_file
set open_file_type $gPB(open,file_type_def)
}
"cdl" {
set win $awin.ude_cdl
set open_file_type $gPB(open,file_type_cdl)
}
default {
tk_messageBox -parent $awin -type ok -icon error \
-title $gPB(msg,dialog,title) \
-message "File type \"$file_type\" is not accepted by\
procedure \"[lindex [info level 0] 0]\"."
return TCL_ERROR
}
}
if { $file_var != "" } {
set work_dir  [file dirname $file_var]
set work_file [file tail    $file_var]
}
set work_dir [file nativename $work_dir]
if { [string tolower [file extension $work_file]] != ".$ext" } {
set work_file ""
}
UI_PB_com_ChangeCHelpState disabled
set ftypes [list \{$open_file_type\}\ \{*.$ext\}]
set status TCL_ERROR
while { $status != "TCL_OK" } \
{
set flag [string tolower $flag]
if { $flag == "open" } {
set file_name [tk_getOpenFile -filetypes $ftypes \
-title "$gPB(open_save,dlg,title,Label)" \
-parent $awin \
-defaultextension "$ext" \
-initialdir $work_dir \
-initialfile $work_file]
} else {
set file_name [tk_getSaveFile -filetypes $ftypes \
-title "$gPB(open_save,dlg,title,Label)" \
-parent $awin\
-defaultextension "$ext" \
-initialdir $work_dir \
-initialfile $work_file]
}
set win $awin.__tk_filedialog
set gPB(top_window).new.user_cntl_frag $win
if { $file_name == "" } { ;# File selection dialog closed... (Cancelled or X'ed).
if { ![info exists file_var] } {
set file_var ""
}
if [string match 1 $args] {
if [info exists file_var] {
lappend file_var CANCEL
}
}
set status TCL_OK
} else {                  ;# File selected.
set status [__file_SelectFileName $win $FILE_VAR $flag $file_name]
}
if { $status != "TCL_OK" } {
UI_PB_DeleteDataBaseObjs
global mom_sys_arr mom_kin_var mom_sim_arr
PB_com_unset_var mom_sys_arr
PB_com_unset_var mom_kin_var
if [info exists mom_sim_arr] { PB_com_unset_var mom_sim_arr}
}
}
UI_PB_com_ChangeCHelpState normal
}
proc __file_SelectFileName { win FILE_VAR flag file_name args } {
upvar $FILE_VAR file_var
global gPB
set awin [UI_PB_com_AskActiveWindow]
if { $flag == "open" } {
set ext [string tolower [file extension $file_name]]
if { $ext == ".pui" } {
set pui $file_name
PB_file_FindTclDefOfPui $pui tcl def
if { ![file exists $pui] || \
![file exists $def] || \
![file exists $tcl] } {
tk_messageBox -parent $awin -type ok -icon error \
-title $gPB(msg,dialog,title) \
-message "$gPB(msg,file_missing)."
if [winfo exists $win] { $win popup }
return TCL_ERROR
}
}
} else {
global tcl_platform
if {$tcl_platform(platform) == "unix"} {
if { [llength [split $file_name " "]] > 1 } {
tk_messageBox -parent $awin -type ok -icon error \
-title $gPB(msg,dialog,title) \
-message "$gPB(msg,invalid_file)"
if [winfo exists $win] { $win popup }
return TCL_ERROR
}
set file [[$win subwidget fsbox] subwidget file]
[$file subwidget listbox] delete 0
if [file exists $file_name] {
set ans [tk_messageBox -parent $awin -type yesno -icon question \
-title $gPB(msg,dialog,title) \
-message "$file_name $gPB(msg,file_exist)"]
if { $ans == "no" } {
if [winfo exists $win] { $win popup }
return TCL_ERROR
}
}
}
if [file exists $file_name] {
if { ![file writable $file_name] } {
tk_messageBox -parent $awin -type ok -icon error \
-title $gPB(msg,dialog,title) \
-message "$gPB(msg,file_perm) $file_name"
if [winfo exists $win] { $win popup }
return TCL_ERROR
}
} else {
set dir [file dirname $file_name]
if { ![file exists $dir] } {
file mkdir $dir
}
if { ![file writable $dir] } {
tk_messageBox -parent $awin -type ok -icon error \
-title $gPB(msg,dialog,title) \
-message "$gPB(msg,dir_perm) $dir"
if [winfo exists $win] { $win popup }
return TCL_ERROR
}
}
}
set file_var "\"$file_name\""
if [winfo exists $win] { destroy $win }
return TCL_OK
}
proc __file_DisableWidgets { args } {
if 0 {
set args [join [concat $args]]
foreach w $args {
tixDisableAll $w
}
}
global gPB
if [info exists gPB(widgets_disabled)] {
foreach w $gPB(widgets_disabled) {
tixDisableAll $w
}
}
}
proc __file_EnableWidgets { args } {
if 0 {
set args [join [concat $args]]
foreach w $args {
tixEnableAll $w
}
}
global gPB
if [info exists gPB(widgets_disabled)] {
foreach w $gPB(widgets_disabled) {
tixEnableAll $w
}
}
}
proc UI_PB_NewCancel_CB { win } {
global gPB env
UI_PB_EnableFileOptions
if {[info exists env(MULTI_INTERP)] && $env(MULTI_INTERP) == 1} {
UI_PB_GrayAndUnGrayWindowMenu ungray
}
wm withdraw $win
UI_PB_com_SetStatusbar "$gPB(main,default,Status)"
}
proc UI_PB_NewDestroy { args } {
global env
UI_PB_EnableFileOptions
if {[info exists env(MULTI_INTERP)] && $env(MULTI_INTERP) == 1} {
UI_PB_GrayAndUnGrayWindowMenu ungray
}
}
proc UI_PB_EnableFileOptions { } {
global gPB
if [info exists gPB(master_pid)] {
comm::comm send -async $gPB(master_pid) [list UI_PB_EnableFileOptions_mod]
} else {
UI_PB_EnableFileOptions_mod
}
}
proc UI_PB_EnableFileOptions_mod  { } {
global gPB env
set mb $gPB(main_menu_bar).file.m
$mb entryconfigure $gPB(menu_index,file,new)     -state normal
$mb entryconfigure $gPB(menu_index,file,open)    -state normal
if [catch { $mb entryconfigure $gPB(menu_index,file,mdfa) -state normal } result] { }
if {[info exists env(MULTI_INTERP)] && $env(MULTI_INTERP) == 1} {
global PID
if {[llength $PID(posts_list)] > 0} {
$mb entryconfigure $gPB(menu_index,file,save)    -state normal
$mb entryconfigure $gPB(menu_index,file,save_as) -state normal
$mb entryconfigure $gPB(menu_index,file,close)   -state normal
} else {
$mb entryconfigure $gPB(menu_index,file,save)    -state disabled
$mb entryconfigure $gPB(menu_index,file,save_as) -state disabled
$mb entryconfigure $gPB(menu_index,file,close)   -state disabled
}
} else {
$mb entryconfigure $gPB(menu_index,file,save)    -state disabled
$mb entryconfigure $gPB(menu_index,file,save_as) -state disabled
$mb entryconfigure $gPB(menu_index,file,close)   -state disabled
}
catch { $mb entryconfigure $gPB(menu_index,file,history) -state normal }
set mm $gPB(main_menu).tool
[$mm subwidget new]  config -state normal
[$mm subwidget open] config -state normal
if {[info exists env(MULTI_INTERP)] && $env(MULTI_INTERP) == 1} {
global PID
if {[llength $PID(posts_list)] > 0} {
[$mm subwidget save] config -state normal
} else {
[$mm subwidget save] config -state disabled
}
} else {
[$mm subwidget save] config -state disabled
}
UI_PB_com_DismissActiveWindow [UI_PB_com_AskActiveWindow]
bind all <Control-n> "UI_PB_NewPost"
bind all <Control-o> "UI_PB_OpenPost"
bind all <Control-s> ""
bind all <Control-a> ""
}
proc CreateMachineTypeOptMenu { widget mach_type } {
global mach_axis
global gPB
set opt_labels(Lathe,2)    "$gPB(new,lathe_2,Label)"
set opt_labels(Lathe,4)    "$gPB(new,lathe_4,Label)"
set opt_labels(Mill,3)     "$gPB(new,mill_3,Label)"
set opt_labels(Mill,3MT)   "$gPB(new,mill_3MT,Label)"
set opt_labels(Mill,4T)    "$gPB(new,mill_4T,Label)"
set opt_labels(Mill,4H)    "$gPB(new,mill_4H,Label)"
set opt_labels(Mill,5HH)   "$gPB(new,mill_5HH,Label)"
set opt_labels(Mill,5TT)   "$gPB(new,mill_5TT,Label)"
set opt_labels(Mill,5HT)   "$gPB(new,mill_5HT,Label)"
set opt_labels(Wedm,2)     "$gPB(new,wedm_2,Label)"
set opt_labels(Wedm,4)     "$gPB(new,wedm_4,Label)"
set opt_labels(Punch,P)    "$gPB(new,punch,Label)"
set cur_opt_names [$widget.axis entries]
foreach name $cur_opt_names \
{
$widget.axis delete $name
}
switch $mach_type \
{
"Mill"   {
set opts { 3 3MT 4T 4H 5HH 5TT 5HT }
$widget.axis config -state normal
}
"Lathe"  {
set opts { 2 }
$widget.axis config -state normal
}
"Wedm"   {
set opts { 2 4 }
$widget.axis config -state normal
}
"Punch"  {
set opts { P }
$widget.axis config -state disabled
}
default  {
set opts ""
set mach_axis ""
$widget.axis config -state disabled
}
}
foreach opt $opts \
{
$widget.axis add command $opt -label $opt_labels($mach_type,$opt)
}
}
proc CreateControllerOptMenu { widget mach_type } {
global gPB
set opts_cont { Generic }
set opt_labels_c(Generic)      "$gPB(new,generic,Label)"
set opt_labels_c(AllnBrdy)     "$gPB(new,allen,Label)"
set opt_labels_c(BrdgPrt)      "$gPB(new,bridge,Label)"
set opt_labels_c(BrwnShrp)     "$gPB(new,brown,Label)"
set opt_labels_c(Cincin)       "$gPB(new,cincin,Label)"
set opt_labels_c(KrnyTrckr)    "$gPB(new,kearny,Label)"
set opt_labels_c(Fanuc)        "$gPB(new,fanuc,Label)"
set opt_labels_c(GE)           "$gPB(new,ge,Label)"
set opt_labels_c(GN)           "$gPB(new,gn,Label)"
set opt_labels_c(GddngLws)     "$gPB(new,gidding,Label)"
set opt_labels_c(Heiden)       "$gPB(new,heiden,Label)"
set opt_labels_c(Mazak)        "$gPB(new,mazak,Label)"
set opt_labels_c(Seimens)      "$gPB(new,seimens,Label)"
global env
switch $mach_type \
{
"Mill"   {
set dir [file dirname $env(PB_HOME)/pblib/controller/.]/mill
}
"Lathe"  {
set dir [file dirname $env(PB_HOME)/pblib/controller/.]/lathe
}
"Wedm"   {
set dir [file dirname $env(PB_HOME)/pblib/controller/.]/wedm
}
}
set dir [join [split $dir \$] \\\$]
set old_dir [pwd]
set file_list_found 0
eval cd [join [split $dir] "\\ "]
if [catch {set opts [lsort [eval glob -nocomplain -- "*.pui"]] } res] {
UI_PB_debug_Pause "glob : $res"
} else {
if [llength $opts] {
set file_list_found 1
}
}
eval cd [join [split $old_dir] "\\ "]
if 0 {
if { [string index $dir 0] != "/"} {
global tcl_platform
if [string match "unix" $tcl_platform(platform)] {
if { ![catch {set opts [exec ls $dir] } res] } {
if [llength $opts] {
set file_list_found 1
}
} else {
UI_PB_debug_Pause "unix : $res"
}
} else {
if { ![catch {set opts [eval exec dir $dir] } res] } {
if [llength $opts] {
set file_list_found 1
}
} else {
UI_PB_debug_Pause "win : $res"
}
}
} else {
if { ![catch {set opts [eval tixListDir $dir 0 1 0 0] } res] } {
if [llength $opts] {
set file_list_found 1
}
} else {
UI_PB_debug_Pause "tixListDir : $res"
}
}
}
if $file_list_found {
foreach f $opts {
if { [file extension $f] == ".pui" } {
lappend file_opts $f
}
}
}
if { [PB_is_v3] >= 0 } {
__file_CreateComboList $widget.contr file_opts
} else {
set cur_opt_names [$widget.contr entries]
foreach name $cur_opt_names \
{
$widget.contr delete $name
}
if { [info exists file_opts] && [llength $file_opts] } {
foreach opt $file_opts {
set opt [file rootname $opt]
$widget.contr add command $opt -label $opt
}
}
}
if 0 {{
foreach opt $opts_cont \
{
$widget.contr add command $opt -label $opt_labels_c($opt)
}
}}
}
proc __NewPost {w} {
global gPB env
if {[info exists env(MULTI_INTERP)] && $env(MULTI_INTERP) == 1} {
global PID
if {[lsearch $PID(posts_name_list) ${::pb_output_file}.pui] >= 0} {
tk_messageBox -message "File already exists!" -icon error \
-parent $w
return
}
UI_PB_GrayAndUnGrayWindowMenu ungray
set gPB(action) new
exec build_post.exe [comm::comm self] &
} else {
__NewPost_mod $w
}
}
proc __IncrNewPostNameNum { } {
global std_file_name
global pb_output_file
if [string match $std_file_name $pb_output_file] {
set idx [string range $std_file_name 8 end]
set idx [expr $idx + 1]
set std_file_name "new_post$idx"
}
set pb_output_file $std_file_name
}
proc __NewPost_mod {w} {
global env
global gPB
global new_mach_type
global mach_axis
global pb_output_file
global output_unit
global axisoption
global controller
set env(PB_UDE_ENABLED) $::ude_enable
PB_com_unset_var gPB(Old_PUI_Version)
UI_PB_DisplayProgress new
set gPB(post_in_progress) 1
if ![info exists gPB(master_pid)] {
after 100 "UI_PB_DestroyProgress"
}
set controller $gPB(mach_sys_controller)
set mach [string tolower $new_mach_type]
global mach_cntl_type
switch $mach_cntl_type {
"Generic" {
set controller "Generic"
}
"User" {
set controller [file nativename $gPB(mach_user_controller)]
}
"System" {
if { $gPB(mach_sys_controller) == "" } {
set controller ""
} else {
set controller [file nativename \
$env(PB_HOME)/pblib/controller/$mach/$gPB(mach_sys_controller).pui]
}
}
}
set axisoption $mach_axis
if 0 { ;# There may need "Reselect". "Continue Anyway" & "Ignore It!" options.
if { $controller != "Generic" } {
PB_file_GetPostAttr $controller MACHINE_TYPE AXIS_OPTION OUTPUT_UNIT
if { $MACHINE_TYPE != $new_mach_type } {
tk_messageBox -parent $w -type ok -icon error \
-title $gPB(msg,dialog,title) \
-message "The selected controller fragment is of different type\
as the Post to be created."
return
}
}
}
if 0 {
set env(PB_TESTING) 1
if { [info exists env(PB_TESTING)]  &&  $env(PB_TESTING) } \
{
UI_PB_file_GetPostFragList pb_std_file $new_mach_type $controller $axisoption $output_unit
}
}
UI_PB_file_GetPostFragList pb_std_file $new_mach_type $controller $axisoption $output_unit
set gPB(pui_marker_merge) 0
set sw_list [list]
foreach f $pb_std_file {
lappend sw_list 1
}
if { $controller != "Generic"  &&  $controller != "" } {
set controller [join [split $controller "\\"] "\\\\"]
set idx [lsearch $pb_std_file "$controller"]
if { $idx >= 0 } { set sw_list [lreplace $sw_list $idx $idx 0] }
}
UI_PB_SnapShotRuntimeObjs
if [catch { PB_file_Create $pb_std_file $sw_list } res] {
__Pause "Caught in PB_file_Create :: $res"
PB_com_unset_var gPB(pui_ui_overwrite)
PB_com_unset_var gPB(pui_marker_merge)
global post_object
PB_com_DeleteObject $post_object
tk_messageBox -parent [UI_PB_com_AskActiveWindow] -type ok -icon error \
-title $gPB(msg,dialog,title) \
-message "$res"
PB_com_unset_var gPB(post_in_progress)
return
}
PB_com_unset_var gPB(pui_ui_overwrite)
PB_com_unset_var gPB(pui_marker_merge)
if { $gPB(Output_Dir) == "" } \
{
set dir [file dirname $pb_output_file]
if { $dir == "." } \
{
set dir [pwd]
}
set gPB(Output_Dir) $dir
} else \
{
set dir $gPB(Output_Dir)
}
set file_name [file tail $pb_output_file]
set pui_file $file_name.pui
set def_file $file_name.def
set tcl_file $file_name.tcl
PB_int_SetPostOutputFiles dir pui_file def_file tcl_file
PB_int_SetUserTclFileName file_name
if [info exists gPB(master_pid)] {
set gPB(post_description) [comm::comm send $gPB(master_pid) [list __GetDescription]]
} else {
set gPB(post_description) [__GetDescription]
}
if [string match "Generic" $mach_cntl_type] {
set cont_str $mach_cntl_type
} else {
regsub -all "\\\\\\\\" $controller "/" cntl
set cont_str "$mach_cntl_type  ($cntl)"
}
set gPB(post_controller) "[join [split $cont_str \\\\] /]"
set gPB(post_history) ""
if ![info exists gPB(master_pid)] {
UI_PB_com_DismissActiveWindow $w
wm deiconify $w
wm withdraw $w
} else {
comm::comm send -async $gPB(master_pid) [list UI_PB_com_DismissActiveWindow $w]
comm::comm send -async $gPB(master_pid) [list wm withdraw $w]
set cmd_str {if {$PID(activated) != ""} {comm::comm send $PID(activated) update}}
comm::comm send  $gPB(master_pid) [list eval $cmd_str]
}
update
if [catch { UI_PB_main_window } result] \
{
PB_com_unset_var gPB(post_in_progress)
return [tk_messageBox -parent $gPB(top_window) -type ok -icon error \
-title $gPB(msg,dialog,title) \
-message "$gPB(msg,file_corruption)"]
}
update
UI_PB_ActivateOpenFileOpts
AcceptMachineToolSelection
set gPB(session) NEW
UI_PB_com_SetStatusbar "$gPB(machine,Status)"
PB_com_unset_var gPB(post_in_progress)
UI_PB_DestroyProgress
if [info exists gPB(master_pid)] {
comm::comm send -async $gPB(master_pid) [list __IncrNewPostNameNum]
}
}
proc __GetDescription {} {
global gPB
scan [$gPB(post_desc_win) index end] %d numlines
set desc ""
for {set i 1} {$i < $numlines} {incr i} \
{
$gPB(post_desc_win) mark set last $i.0
set line_text [$gPB(post_desc_win) get last "last lineend"]
lappend desc $line_text
}
return $desc
}
proc UI_PB_file_GetPostFragList { PUI_FILE_LIST \
mach_type controller axisoption output_unit } {
upvar $PUI_FILE_LIST pui_file_list
global env
switch $mach_type \
{
"Mill" \
{
set file [file nativename $env(PB_HOME)/pblib/mill_base.pui]
lappend pui_file_list $file
set file ""
if { $controller != "Generic"  &&  $controller != "" } {
lappend pui_file_list $controller
set file [file nativename $env(PB_HOME)/pblib/mill_base.pb]
lappend pui_file_list $file
set file ""
}
switch $axisoption \
{
"3"  \
{
set file [file nativename $env(PB_HOME)/pblib/mill_kin_3axis.pb]
}
"3MT"  \
{
set file [file nativename $env(PB_HOME)/pblib/mill_kin_xzc.pb]
}
"4H"  \
{
set file [file nativename $env(PB_HOME)/pblib/mill_kin_4axis_head.pb]
}
"4T"  \
{
set file [file nativename $env(PB_HOME)/pblib/mill_kin_4axis_table.pb]
}
"5HH" \
{
set file [file nativename $env(PB_HOME)/pblib/mill_kin_5axis_dual_head.pb]
}
"5HT" \
{
set file [file nativename $env(PB_HOME)/pblib/mill_kin_5axis_head_table.pb]
}
"5TT" \
{
set file [file nativename $env(PB_HOME)/pblib/mill_kin_5axis_dual_table.pb]
}
}
if { $file != "" } \
{
lappend pui_file_list $file
set file ""
}
switch $output_unit \
{
"Inches" \
{
if [string match "3" $axisoption] \
{
set file [file nativename $env(PB_HOME)/pblib/mill_3_in.pb]
} else \
{
set file [file nativename $env(PB_HOME)/pblib/mill_5_in.pb]
}
}
"Millimeters" \
{
if [string match "3" $axisoption] \
{
set file [file nativename $env(PB_HOME)/pblib/mill_3_mm.pb]
} else \
{
set file [file nativename $env(PB_HOME)/pblib/mill_5_mm.pb]
}
}
"Dual" \
{
if [string match "3" $axisoption] \
{
set file [file nativename $env(PB_HOME)/pblib/mill_3_unit.pb]
} else \
{
set file [file nativename $env(PB_HOME)/pblib/mill_5_unit.pb]
}
}
}
if { $file != "" } \
{
lappend pui_file_list $file
set file ""
}
}
"Lathe" \
{
set file [file nativename $env(PB_HOME)/pblib/lathe_base.pui]
lappend pui_file_list $file
set file ""
if { $controller != "Generic"  &&  $controller != "" } {
lappend pui_file_list $controller
set file [file nativename $env(PB_HOME)/pblib/lathe_base.pb]
lappend pui_file_list $file
set file ""
}
switch $output_unit \
{
"Inches" \
{
set file [file nativename $env(PB_HOME)/pblib/lathe_in.pb]
}
"Millimeters" \
{
set file [file nativename $env(PB_HOME)/pblib/lathe_mm.pb]
}
"Dual" \
{
set file [file nativename $env(PB_HOME)/pblib/lathe_unit.pb]
}
}
if { $file != "" } \
{
lappend pui_file_list $file
set file ""
}
}
"Wire EDM" -
"Wedm" \
{
set file [file nativename $env(PB_HOME)/pblib/wedm_base.pui]
lappend pui_file_list $file
set file ""
if { $controller != "Generic"  &&  $controller != "" } {
lappend pui_file_list $controller
set file [file nativename $env(PB_HOME)/pblib/wedm_base.pb]
lappend pui_file_list $file
set file ""
}
switch $axisoption \
{
"2"  \
{
set file [file nativename $env(PB_HOME)/pblib/wedm_kin_2axis.pb]
}
"4"  \
{
set file [file nativename $env(PB_HOME)/pblib/wedm_kin_4axis.pb]
}
}
if { $file != "" } \
{
lappend pui_file_list $file
set file ""
}
switch $output_unit \
{
"Inches" \
{
set file [file nativename $env(PB_HOME)/pblib/wedm_in.pb]
}
"Millimeters" \
{
set file [file nativename $env(PB_HOME)/pblib/wedm_mm.pb]
}
"Dual" \
{
set file [file nativename $env(PB_HOME)/pblib/wedm_unit.pb]
}
}
if { $file != "" } \
{
lappend pui_file_list $file
set file ""
}
}
}
}
proc CB_CntlType { w cntl_type } {
global gPB
if { [winfo manager $w.contr] == "pack" } { pack forget $w.contr }
if { [winfo manager $w.user]  == "pack" } { pack forget $w.user }
switch -- $cntl_type \
{
"System"   {
if { [PB_is_v3] >= 0 } {
pack $w.contr -padx 5 -pady 7
[$w.contr subwidget entry] config -state disabled
} else {
pack $w.contr -padx 5 -pady 2
}
}
"User"     {
pack $w.user -padx 5 -pady 2
}
}
}
proc CB_MachType { win mach_type fa fb } {
global gPB
if 0 {
switch -- $mach_type \
{
"Lathe"    {
set desc "$gPB(new,lathe,desc,Label)"
}
"Wedm"     {
set desc "$gPB(new,wedm,desc,Label)"
}
"Punch"    {
set desc "$gPB(new,punch,desc,Label)."
}
"Mill"     {
set desc "$gPB(new,mill,desc,Label)"
}
}
[$win.top.level2.desc subwidget text] delete 1.0 end
[$win.top.level2.desc subwidget text] insert 1.0 $desc
}
if ![string compare $::tix_version 8.4] {
switch -- $mach_type \
{
"Lathe"    {
$::gPB(LB_widget) config -height 35;
}
"Wedm"     {
$::gPB(LB_widget) config -height 50;
}
"Mill"     {
$::gPB(LB_widget) config -height 125;
}
}
}
CreateMachineTypeOptMenu $fa $mach_type
CreateControllerOptMenu $fb $mach_type
}
proc CB_MachineAxisType { win mach_type args } {
global gPB
global mach_axis
set desc ""
switch -- $mach_type \
{
"Wedm"  {
switch -- $mach_axis \
{
"2"  {
set desc "$gPB(new,wedm_2,desc,Label)"
}
"4"  {
set desc "$gPB(new,wedm_4,desc,Label)"
}
}
}
"Lathe" {
switch -- $mach_axis \
{
"2"  {
set desc "$gPB(new,lathe_2,desc,Label)"
}
"4"  {
set desc "$gPB(new,lathe_4,desc,Label)"
}
}
}
"Mill"  {
switch -- $mach_axis \
{
"3"   {
set desc "$gPB(new,mill_3,desc,Label)"
}
"3MT" {
set desc "3-Axis Mill-Turn (XZC)"
}
"4H"  {
set desc "$gPB(new,mill_4H,desc,Label)"
}
"4T"  {
set desc "$gPB(new,mill_4T,desc,Label)"
}
"5TT" {
set desc "$gPB(new,mill_5TT,desc,Label)"
}
"5HH" {
set desc "$gPB(new,mill_5HH,desc,Label)"
}
"5HT" {
set desc "$gPB(new,mill_5HT,desc,Label)"
}
}
}
"Punch" {
switch -- $mach_axis \
{
"P" {
set desc "$gPB(new,punch,desc,Label)"
}
}
}
}
[$win.top.level2.desc subwidget text] delete 1.0 end
[$win.top.level2.desc subwidget text] insert 1.0 $desc
}
proc AcceptMachineToolSelection { } {
global gPB env
global machData
if { [info exists machData] } \
{
set pb_book $gPB(book)
set mctl_page_obj [lindex $Book::($pb_book,page_obj_list) 0]
UI_PB_mach_MachDisplayParams $mctl_page_obj machData
}
PB_pps_ConvertOldUdeDefinitionStyle
}
