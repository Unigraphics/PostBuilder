set gPB(VNC_release) 3.2
if { ![string match "windows" $tcl_platform(platform)] } {
if {$tcl_version == "8.0"} {
if {$gPB(PB_LICENSE) == "UG_POST_ADV_BLD"} {
set gPB(PB_LICENSE) UG_POST_MILL
}
set disable_license 1
} else {
set disable_license 0
}
} else {
set disable_license 0
}
if { [info commands UI_PB_decrypt_post] == "" } {
set disable_license 1
}
set disable_internal_user_lc 0
if [info exists gPB(PB_SITE_ID)] {
if 1 {
if [string match "For Internal UGS PLM*" $gPB(PB_SITE_ID)] {
set disable_internal_user_lc 1
if { [info exists env(PB_ENABLE_INTERNAL_LICENSE_CONTROL)] &&\
$env(PB_ENABLE_INTERNAL_LICENSE_CONTROL) } {
set disable_internal_user_lc 0
}
}
}
} else {
set gPB(lic_list) [list]
}
if { ![info exists gPB(FORCE_SYNTAX_CHECK)] } {
set gPB(FORCE_SYNTAX_CHECK) 1
}
if [file exists $env(PB_HOME)/app/ui/ui_pb_debug.tcl] {
source $env(PB_HOME)/app/ui/ui_pb_debug.tcl
}
if { ![info exists gPB(LOG_MSG_ENABLED)] } {
set gPB(LOG_MSG_ENABLED) 0
}
set gPB(Runtime_Log) ""
set gPB(Session_Log) [file nativename "$env(HOME)/pb_session.log"]
if { ![catch {file exists $gPB(Session_Log)}] } {}
if [file exists $gPB(Session_Log)] {
catch { source "$gPB(Session_Log)" }
} else {
set gPB(Session_Log) ""
}
if [info exists gPB(PB_UDE_ENABLED)] {
unset gPB(PB_UDE_ENABLED)
}
proc __MapEnvToPBvar {env_var} {
global env
set env_var [string tolower $env_var]
switch -regexp $env_var {
^en_.* {
set pbvar pb_msg_english
}
^fr_.* {
set pbvar pb_msg_french
}
^de_.* {
set pbvar pb_msg_german
}
^it_.* {
set pbvar pb_msg_italian
}
^ja_.* {
set pbvar pb_msg_japanese
}
^ko_.* {
set pbvar pb_msg_korean
}
^ru_.* {
set pbvar pb_msg_russian
}
^es_.* {
set pbvar pb_msg_spanish
}
^zh_.* {
if [string match zh_cn $env_var] {
set pbvar pb_msg_simple_chinese
} else {
set pbvar pb_msg_traditional_chinese
}
}
default {
set pbvar pb_msg_english
}
}
return $pbvar
}
proc __IsLanguageDefined {msg_file_name} {
global env gPB
set is_defined 1
if [file exists $env(PB_HOME)/msgs/${msg_file_name}.tcl] {
set gPB(LANG_TEST) 1
set is_defined [source $env(PB_HOME)/msgs/${msg_file_name}.tcl]
unset gPB(LANG_TEST)
} else {
set is_defined 0
}
return $is_defined
}
if {$::tix_version == "8.4" && $::tcl_platform(platform) == "windows"} {
if {[info exists env(LANG)] && ![info exists env(PRE_LANG)]} {
set pbvar [__MapEnvToPBvar $env(LANG)]
if [__IsLanguageDefined $pbvar] {
set gPB(LANG) $pbvar
} else {
set gPB(LANG) pb_msg_english
}
} elseif {[info exists env(LANG)] && [info exists env(PRE_LANG)]} {
set gPB(LANG) $env(PRE_LANG)
} elseif {![info exists env(LANG)] && [info exists env(PRE_LANG)]} {
set gPB(LANG) $env(PRE_LANG)
} elseif {![info exists env(LANG)] && ![info exists env(PRE_LANG)]} {
set gPB(LANG) pb_msg_english
}
if ![__IsLanguageDefined $gPB(LANG)] {
set gPB(LANG) pb_msg_english
}
} else {
set gPB(LANG) pb_msg_english
}
if [string match pb_msg_english $gPB(LANG)] {
set gPB(localization) 0
} else {
set gPB(localization) 1
}
if [catch {source [file join $env(TCL_LIBRARY) msgcat.tcl]} err] {
tk_messageBox -message $err
}
source $env(PB_HOME)/app/ui/ui_pb_language.tcl
source $env(PB_HOME)/app/ui/ui_pb_fonts.tcl
set gPB(Postbuilder_Version)        "2005.0.0"
set release_date                   "6/2/2008"
set gPB(Postbuilder_Release_Date)  [clock format [clock scan $release_date] -format "%m/%d/%Y"]
set gPB(Postbuilder_PUI_Version)   "$gPB(Postbuilder_Version)"
set phase                          ".2"
set gPB(Postbuilder_Version_Phase) $phase
set gPB(Postbuilder_PUI_Version)   "$gPB(Postbuilder_PUI_Version)$phase"
set vi  [string last "." $gPB(Postbuilder_Version)]
set ver [string range $gPB(Postbuilder_Version) 0 [expr $vi - 1]]
set ver [expr $ver - 1999.0]
set ext [string range $gPB(Postbuilder_Version) $vi end]
set gPB(Postbuilder_Release_Version)  $ver$ext
set gPB(Postbuilder_Release)       \
"$gPB(main,title,UG)/$gPB(main,title,Post_Builder) $gPB(main,title,Version) $ver$ext"
if 0 {
set gPB(Postbuilder_Release_About) \
"$gPB(main,title,UG)/$gPB(main,title,Post_Builder) $gPB(main,title,Version)\
$ver$ext$phase  ($gPB(Postbuilder_Release_Date))\n\n"
}
set gPB(Postbuilder_Release_About) \
"$gPB(Postbuilder_Release)$phase  ($gPB(Postbuilder_Release_Date))\n\n"
if ![info exists gPB(master_pid)] {
if [info exists gPB(PB_UDE_ENABLED)] {
set env(PB_UDE_ENABLED) $gPB(PB_UDE_ENABLED)
} else {
set env(PB_UDE_ENABLED) 2
}
}
set gPB(Output_Dir)           ""
set gPB(User_Def_Blk)         "user_blk"
set gPB(User_Def_Add)         "user_add"
set gPB(User_Def_Fmt)         "user_fmt"
set gPB(MOM_obj_name_len)     32
tix addbitmapdir [tixFSJoin $env(PB_HOME) images]
set tixOption(font)           $gPB(font)
set tixOption(font_sm)        $gPB(font_sm)
set tixOption(bold_font)      $gPB(bold_font)
set tixOption(bold_font_lg)   $gPB(bold_font_lg)
set tixOption(italic_font)    $gPB(italic_font)
set tixOption(fixed_font)     $gPB(fixed_font)
set tixOption(fixed_font_sm)  $gPB(fixed_font_sm)
option add *font $tixOption(bold_font) $tixOption(prioLevel)
if {$tix_version == "8.4"} {
rename tixLabelFrame tixLabelFrame_mod
proc tixLabelFrame { args } {
set cmd_str [list tixLabelFrame_mod]
foreach one $args {
lappend cmd_str $one
}
eval $cmd_str
catch {set lbl [[lindex $args 0] subwidget label]; \
$lbl config -font $::gPB(italic_font)}
return [lindex $args 0]
}
}
set paOption(title_bg)            darkSeaGreen3
set paOption(title_fg)            lightYellow
set paOption(table_bg)            lightSkyBlue
set paOption(app_bg)              #9676a2 ;# #b87888
set paOption(tree_bg)             lightYellow ;#fefae0 Linen SeaShell Ivory MintCream
set paOption(butt_bg)             Gold1 ;# #f0da1c
set paOption(app_butt_bg)         #d0c690 ;# #a8d464 #b0868e
set paOption(can_bg)              #ace8d2
set paOption(can_trough_bg)       #7cdabc
set paOption(trough_bg)           #f0da1c
set paOption(trough_wd)           12
set paOption(file)                [tix getimage pb_textfile]
set paOption(folder)              [tix getimage pb_folder]
set paOption(format)              [tix getimage pb_format]
set paOption(address)             [tix getimage pb_address]
set paOption(popup)               #e3e3e3
set paOption(seq_bg)              yellow ;#Aquamarine1 AntiqueWhite CadetBlue1 #8ceeb6 #f8de58
set paOption(seq_fg)              blue3 ;#Purple4 NavyBlue Purple3
set paOption(event)               skyBlue3
set paOption(cell_color)          paleTurquoise
set paOption(active_color)        burlyWood1
set paOption(focus)               lightYellow
set paOption(balloon)             yellow
set paOption(select_clr)          orange ;# YellowGreen PaleGreen1 Orchid
set paOption(menu_bar_bg)         lightBlue ;# Aquamarine1
set paOption(text)                lightSkyBlue
set paOption(disabled_fg)         gray
set paOption(tree_disabled_fg)    lightGray
set paOption(header_bg)           royalBlue
set paOption(special_bg)          navyBlue
set paOption(special_fg)          white
set paOption(entry_disabled_bg)   lightBlue
set paOption(sunken_bg)           pink
set paOption(raised_bg)           #c0c0ff
set paOption(name_bg)             slateGray4 ;# darkSeaGreen3 ;# deepSkyBlue4 ;# steelBlue4
set paOption(ude_bg)              SeaGreen ;#<03-29-06 peter> for ude
set paOption(udc_bg)              SeaGreen ;#<03-29-06 peter> for udc
set paOption(tree_fg)             black ;#<11-15-07 pheobe> for tree
set paOption(unit_ent_bg)         lightyellow ;#<01-16-08 peter> for inch metric project
set paOption(unit_fg)             #EE3333
proc __SetOptions { } {
uplevel #0 {
option add *font $tixOption(bold_font) $tixOption(prioLevel)
option add *Label.font            $tixOption(font)
option add *Menu.background       gray95
option add *Menu.activeBackground blue
option add *Menu.activeForeground yellow
option add *Menu.selectColor      $paOption(select_clr)
option add *Menu.activeBorderWidth    0
option add *Menu.font             $tixOption(bold_font)
option add *Menu.cursor           hand2
option add *Button.cursor         hand2
option add *Button.activeBackground       $paOption(focus)
option add *Button.activeForeground       black
option add *Button.disabledForeground     $paOption(disabled_fg)
option add *Menubutton.cursor             hand2
option add *Menubutton.activeBackground   $paOption(focus)
option add *Menubutton.font               $tixOption(bold_font)
option add *Checkbutton.cursor            hand2
option add *Checkbutton.activeBackground  $paOption(focus)
option add *Checkbutton.disabledForeground    $paOption(disabled_fg)
option add *Checkbutton.selectColor       $paOption(select_clr)
option add *Checkbutton.font              $tixOption(font)
option add *Radiobutton.cursor            hand2
option add *Radiobutton.activeBackground  $paOption(focus)
option add *Radiobutton.disabledForeground    $paOption(disabled_fg)
option add *Radiobutton.selectColor       $paOption(select_clr)
option add *Radiobutton.font              $tixOption(font)
option add *Entry.font                    $tixOption(font)
option add *TixOptionMenu.cursor          hand2
option add *TixOptionMenu.label.font      $tixOption(font)
option add *TixNoteBook.tagPadX           6
option add *TixNoteBook.tagPadY           4
option add *TixNoteBook.borderWidth       2
option add *TixLabelFrame.label.font      $tixOption(italic_font)
option add *TixLabelEntry.label.font      $tixOption(font)
option add *TixButtonBox.background       $paOption(butt_bg)
option add *Dialog.msg.wrapLength         4i
if {[string match $tix_version 8.4] && [string match $::tcl_platform(platform) windows]} {
option add *TixScrolledGrid.background              $::SystemButtonFace
option add *TixScrolledGrid*grid.background         $::SystemButtonFace
option add *TixLabelFrame.background                $::SystemButtonFace
option add *TixSelect.background                    $::SystemButtonFace
option add *TixScrolledHList*hlist.selectForeground blue
option add *TixScrolledHList*hlist.selectBackground lightblue
option add *Entry.disabledBackground                lightblue
option add *Entry.disabledForeground                black
option add *Checkbutton.activeBackground            $::SystemButtonFace
option add *Checkbutton.takeFocus                   0
option add *Radiobutton.activeBackground            $::SystemButtonFace
option add *Radiobutton.takeFocus                   0
option add *TixOptionMenu*menubutton.takeFocus      0
tk_focusFollowsMouse
bind all <MouseWheel> [list UI_PB_mthd_MouseWheel %W %D %X %Y]
bind all <Shift-MouseWheel> [list UI_PB_mthd_MouseWheel %W %D %X %Y x]
}
};#uplevel #0
}
button .b
set SystemButtonFace   [lindex [.b config -background] end]
set SystemDisabledText [lindex [.b config -disabledforeground] end]
set SystemButtonText   [lindex [.b config -foreground] end]
destroy .b
entry .e
set SystemWindow       [lindex [.e config -background] end]
destroy .e
scrollbar .s
set paOption(trough_wd) [lindex [.s config -width] end]
destroy .s
if {[info exists ::env(INCH_METRIC)] && $::env(INCH_METRIC) == 1} {
label .l -text in -font $tixOption(fixed_font) -width 2
set paOption(unit_width) [expr [winfo reqwidth .l] + 5]
destroy .l
} else {
set paOption(unit_width) 5
}
if ![info exists gPB(master_pid)] {
__SetOptions
}
proc __CreateStyle { } {
uplevel #0 {
switch $::tix_version {
8.4 {
set gPB(font_style_normal) [tixDisplayStyle imagetext \
-fg $paOption(tree_fg) -bg $paOption(tree_bg) -padx 4 -pady 1 -font $tixOption(font) \
-selectforeground blue -selectbackground lightblue]
set gPB(font_style_bold) [tixDisplayStyle imagetext \
-fg $paOption(tree_fg) -bg $paOption(tree_bg) -padx 4 -pady 2 -font $tixOption(bold_font) \
-selectforeground blue -selectbackground lightblue]
}
4.1 {
set gPB(font_style_normal) [tixDisplayStyle imagetext \
-fg $paOption(tree_fg) -bg $paOption(tree_bg) -padx 4 -pady 1 -font $tixOption(font) \
-selectforeground blue]
set gPB(font_style_bold) [tixDisplayStyle imagetext \
-fg $paOption(tree_fg) -bg $paOption(tree_bg) -padx 4 -pady 2 -font $tixOption(bold_font) \
-selectforeground blue]
}
}
set gPB(font_style_normal_gray) [tixDisplayStyle imagetext \
-fg $paOption(tree_disabled_fg) \
-bg $paOption(tree_bg) \
-padx 4 -pady 1 -font $tixOption(font)]
set gPB(font_style_bold_gray) [tixDisplayStyle imagetext \
-fg $paOption(tree_disabled_fg) \
-bg $paOption(tree_bg) \
-padx 4 -pady 2 -font $tixOption(bold_font)]
}
}
if ![info exists gPB(master_pid)] {
__CreateStyle
}
if [file exists $env(PB_HOME)/app/user/__user.tcl] {
source "$env(PB_HOME)/app/user/__user.tcl"
}
proc UI_PB_log_msg { args } {
global gPB env
if $gPB(LOG_MSG_ENABLED) {
if { [string length $gPB(Runtime_Log)] == 0 } {
if { [file exists "$env(TEMP)"] && [file writable "$env(TEMP)"] } {
set gPB(Runtime_Log) [file nativename "$env(TEMP)/$env(LOGNAME)_PB_[clock clicks].log"]
set gPB(log_msg_index) 0
} else {
set gPB(LOG_MSG_ENABLED) 0
return
}
}
set fid 0
set fid [open $gPB(Runtime_Log) a+]
if { $fid != 0 } {
set level [info level]
set str ""
for {set i 1} {$i < $level} {incr i} {
set str "$str [lindex [info level $i] 0]"
}
puts $fid "\#PB_LOG $gPB(log_msg_index) :$str\n              ==> [join $args]"
close $fid
incr gPB(log_msg_index)
}
}
}
proc UI_PB_force_log_msg { args } {
global gPB env
set state $gPB(LOG_MSG_ENABLED)
set gPB(LOG_MSG_ENABLED) 1
catch { UI_PB_log_msg [join $args] }
set gPB(LOG_MSG_ENABLED) $state
}
proc PB_is_ver { ver } {
global gPB
set lis [split $ver .]
set v [expr 1999 + [lindex $lis 0]]
set lis [lreplace $lis 0 0 $v]
set ver [join $lis .]
if { [llength $lis] == 2 } {
set ver $ver.0
} elseif { [llength $lis] == 1 } {
set ver $ver.0.0
}
return [string compare $gPB(Postbuilder_Version) "$ver"]
}
proc PB_is_v { ver } {
global gPB
set lis [split $ver .]
set v [expr 1999 + [lindex $lis 0]]
set lis [lreplace $lis 0 0 $v]
set ver [join $lis .]
if { [llength $lis] == 2 } {
set ver $ver.0
} elseif { [llength $lis] == 1 } {
set ver $ver.0.0
}
if { [string compare $gPB(Postbuilder_Version) "$ver"] >= 0 } {
return 1
} else {
return 0
}
}
proc PB_is_v6 {} {
global gPB
if { [string compare $gPB(Old_PUI_Version) "2005.0.0"] >= 0 } {
return 1
} else {
return 0
}
}
proc PB_is_v4 {} {
global gPB
if { [string compare $gPB(Postbuilder_Version) "2003.0.0"] >= 0 } {
return 1
} else {
return 0
}
}
proc PB_is_v3 {} {
global gPB
return [string compare $gPB(Postbuilder_Version) "2002.0.0"]
}
proc UI_PB_AddPatchMsg { patch_version msg } {
global gPB
if { [string compare $gPB(Postbuilder_Version) $patch_version] == 0 } {
set gPB(Postbuilder_Release_About) "$gPB(Postbuilder_Release_About)\n$msg"
}
}
proc __DisplaySplash {} {
global env gPB
set dir "$env(PB_HOME)/images/"
append imagefile $dir pb_splash.gif
if { ![file exists $imagefile] } {
unset imagefile
append imagefile $dir pb_splash_default.gif
}
if [file exists $imagefile] {
set w .splash
set gPB(pb_splash_win) $w
toplevel $w
wm title $w "$gPB(Postbuilder_Release)"
wm overrideredirect $w true
image create photo splash_photo -file $imagefile
label $w.img -image splash_photo
pack $w.img -fill both
UI_PB_com_CenterWindow $w non_deco
}
}
proc __DestroySplash {} {
global gPB
if { [info exists gPB(pb_splash_win)] && [winfo exists $gPB(pb_splash_win)] } {
if { [info exists gPB(prog_window)] && [winfo exists $gPB(prog_window)] } {
after 100 "__DestroySplash"
} else {
destroy $gPB(pb_splash_win)
unset gPB(pb_splash_win)
}
}
}
proc __RaiseSplash {} {
global gPB
if { [info exists gPB(pb_splash_win)] && [winfo exists $gPB(pb_splash_win)] } {
raise $gPB(pb_splash_win)
if { [info exists gPB(prog_window)] && [winfo exists $gPB(prog_window)] } {
raise $gPB(prog_window) $gPB(pb_splash_win)
wm withdraw $gPB(prog_window)
wm deiconify $gPB(prog_window)
}
}
}
proc UI_PB_DisplayProgress { args } {
global env gPB paOption
if { [PB_is_v3] < 0 } {
return
}
update
if [llength $args] {
set type [lindex $args 0]
} else {
set type "..."
}
$gPB(top_window) config -cursor watch
if { [info exists gPB(main_window)] && [winfo exists $gPB(main_window)] } {
$gPB(main_window) config -cursor watch
}
set w .saving
set gPB(pb_progress_win) $w
if [winfo exists $w] { destroy $w }
toplevel $w
wm title $w "$gPB(main,title,Post_Builder)"
wm withdraw $w
switch $type {
"new"   {
set label $gPB(main,file,new,Busy)
set bgcolor lightSteelBlue2
}
"open"  {
set label $gPB(main,file,open,Busy)
set bgcolor darkSeaGreen2
}
"save"  {
set label $gPB(main,file,save,Busy)
set bgcolor lightGoldenRod1
}
default {
set label "Processing..."
set bgcolor white
}
}
set fgcolor red3
set bgcolor lemonChiffon
frame $w.f -bg $bgcolor
pack $w.f -expand yes -fill both -padx 1 -pady 1
frame $w.f.f -bg $bgcolor
pack $w.f.f -expand yes -fill both -padx 10 -pady 10
label $w.f.f.l -image [tix getimage pb_hourglass] -bg $bgcolor
label $w.f.f.c -text "$label" -font $gPB(italic_font) -justify left -fg $fgcolor -bg $bgcolor
pack $w.f.f.l $w.f.f.c -side left -padx 5
UI_PB_com_CenterWindow $w
$w config -cursor watch
grab $w
if [info exists gPB(master_pid)] {
comm::comm send -async $gPB(master_pid) [list UI_PB_com_DisableProcess]
}
update
wm deiconify $w
update
}
proc UI_PB_DestroyProgress {} {
global gPB
if { [PB_is_v3] < 0 } {
return
}
if [info exists gPB(post_in_progress)] {
if ![info exists gPB(auto_qc)] {
after 100 "UI_PB_DestroyProgress"
}
} else {
if { [info exists gPB(pb_progress_win)] && \
[winfo exists $gPB(pb_progress_win)] } {
$gPB(top_window) config -cursor ""
if { [info exists gPB(main_window)] && [winfo exists $gPB(main_window)] } {
$gPB(main_window) config -cursor ""
}
grab release $gPB(pb_progress_win)
destroy $gPB(pb_progress_win)
unset gPB(pb_progress_win)
if [info exists gPB(master_pid)] {
comm::comm send -async $gPB(master_pid) [list UI_PB_com_EnableProcess]
}
}
}
}
proc UI_PB_main { w } {
global auto_path gPB_dir
global paOption tixOption
global gPB env ;#<06-15-05 peter> for the switch of interaction
__DisplaySplash
after 1000 "__DestroySplash"
set gPB(active_window_list)     [list]
set gPB(active_window)          ""
set gPB(top_window)             ""
set gPB(top_window).new         ""
set gPB(top_window).open        ""
set gPB(main_window)            ""
set gPB(main_window_disabled)   0
set gPB(toplevel_list)          [list]
set gPB(help_win_id)            0
set gPB(native_dialog_present)  0
set gPB(screen_width)  [winfo vrootwidth .] ;# This is defined in pb.c also.
set gPB(screen_height) [winfo vrootheight .]
if ![info exists gPB_dir] {
set script [info script]
if {$script != {}} {
set gPB_dir [file dirname $script]
} else {
set gPB_dir [pwd]
}
set gPB_dir [tixFSAbsPath $gPB_dir]
}
lappend auto_path $gPB_dir
tix addbitmapdir [tixFSJoin $gPB_dir bitmaps]
toplevel     $w
wm withdraw  $w
wm title     $w "$gPB(Postbuilder_Release)"
set xc 0 ;#<08-28-01 gsl> was 100
set yc 0
set gPB(TOP_WIN_HI) 107
wm geometry  $w 1000x$gPB(TOP_WIN_HI)+$xc+$yc
wm protocol  $w WM_DELETE_WINDOW "UI_PB_ExitPost"
$w config -bg $paOption(app_bg)
set gPB(top_window) $w
UI_PB_com_ClaimActiveWindow $w
set main_menu [UI_PB__main_menu   $w]
set status    [UI_PB__main_status $w]
set gPB(main_menu)  $main_menu
pack $main_menu -side top    -fill x
pack $status    -side bottom -fill x
pack forget [$gPB(help_tool) subwidget dia]
$gPB(file_tool).frame config -bg $paOption(table_bg)
$gPB(help_tool).frame config -bg $paOption(table_bg)
__main_AddOptionsMenu
__main_AddUtilMenu
__main_AddMoreHelpMenuItems
if ![string match $gPB(LANG) pb_msg_english] {
set mb [winfo child $gPB(main_menu).mb]
foreach one $mb {
$one config -underline -1
}
set menu_list [list $gPB(file_menu) $gPB(help_menu)]
foreach one $menu_list {
set last [$one index last]
for {set i 0} {$i <= $last} {incr i} {
set type [$one type $i]
if {![string match $type "tearoff"] && \
![string match $type "separator"] } {
$one entryconfigure $i -underline -1
}
}
}
}
if [llength [info commands __main_AddUserMenu] ] { __main_AddUserMenu }
UI_PB_AddVisitedPosts
set mb $gPB(main_menu_bar)
set gPB(c_help,$mb.file)                                  "main,file"
set gPB(c_help,$mb.file.m)                                "main,file,menu"
set gPB(c_help,$mb.file.m,$gPB(menu_index,file,new))      "main,file,new"
set gPB(c_help,$mb.file.m,$gPB(menu_index,file,open))     "main,file,open"
set gPB(c_help,$mb.file.m,$gPB(menu_index,file,mdfa))     "main,file,mdfa"
set gPB(c_help,$mb.file.m,$gPB(menu_index,file,save))     "main,file,save"
set gPB(c_help,$mb.file.m,$gPB(menu_index,file,save_as))  "main,file,save_as"
set gPB(c_help,$mb.file.m,$gPB(menu_index,file,close))    "main,file,close"
set gPB(c_help,$mb.file.m,$gPB(menu_index,file,exit))     "main,file,exit"
set gPB(c_help,$mb.file.m,$gPB(menu_index,file,history))  "main,file,history"
set gPB(c_help,$mb.help)                                  "main,help"
set gPB(c_help,$mb.help.m)                                "main,help,menu"
set gPB(c_help,$mb.help.m,$gPB(menu_index,help,bal))      "main,help,bal"
set gPB(c_help,$mb.help.m,$gPB(menu_index,help,chelp))    "main,help,chelp"
set gPB(c_help,$mb.help.m,$gPB(menu_index,help,manual))   "main,help,manual"
set gPB(c_help,$mb.help.m,$gPB(menu_index,help,about))    "main,help,about"
set gPB(c_help,$mb.help.m,$gPB(menu_index,help,acknow))   "main,help,acknow"
set gPB(c_help,[$main_menu.tool subwidget new]) "tool,new"
set gPB(c_help,[$main_menu.tool subwidget open])    "tool,open"
set gPB(c_help,[$main_menu.tool subwidget save])    "tool,save"
set gPB(c_help,[$main_menu.help subwidget bal]) "tool,bal"
set gPB(c_help,[$main_menu.help subwidget man]) "tool,manual"
set gPB(c_help,tool_button) [$main_menu.help subwidget inf]
$mb.file.m entryconfigure $gPB(menu_index,file,save)    -state disabled
$mb.file.m entryconfigure $gPB(menu_index,file,save_as) -state disabled
$mb.file.m entryconfigure $gPB(menu_index,file,close)   -state disabled
[$main_menu.tool subwidget save] config -state disabled
if ![info exists gPB(entry_color)] \
{
entry .xxxentry
set gPB(entry_color) [lindex [.xxxentry config -bg] end]
tixDestroy .xxxentry
}
update
set xxc [winfo rootx $gPB(top_window)]
set yyc [winfo rooty $gPB(top_window)]
set gPB(WIN_X) [expr $xxc - $xc] ;# Border width
set gPB(WIN_Y) [expr $yyc - $yc] ;# Border plus title width
set gPB(win_max_width)  [expr $gPB(screen_width)  - $gPB(WIN_X) - $gPB(WIN_X)]
set gPB(win_max_height) [expr $gPB(screen_height) - $gPB(WIN_Y) - $gPB(WIN_X)]
UI_PB_com_PositionWindow $w
wm resizable $w 1 0
bind all <Control-x> ""
bind all <Control-g><Control-l> HelpCmd_ack
bind all <F1> HelpCmd_man
global tcl_platform
switch $::tix_version {
8.4 {
bind all <Alt-f> "tk::MbPost $mb.file"
bind all <Alt-o> "tk::MbPost $mb.option"
bind all <Alt-u> "tk::MbPost $mb.util"
bind all <Alt-h> "tk::MbPost $mb.help"
bind all <Any-KeyPress>   "tk::MbButtonUp $mb.file; tk::MbButtonUp $mb.option; \
tk::MbButtonUp $mb.util; tk::MbButtonUp $mb.help"
bind all <Any-KeyRelease> "tk::MbButtonUp $mb.file; tk::MbButtonUp $mb.option; \
tk::MbButtonUp $mb.util; tk::MbButtonUp $mb.help"
if [string match "windows" $tcl_platform(platform)] {
bind all <Any-Motion>     "tk::MbButtonUp $mb.file; tk::MbButtonUp $mb.option; \
tk::MbButtonUp $mb.util; tk::MbButtonUp $mb.help"
}
}
4.1 {
bind all <Alt-f> "tkMbPost $mb.file"
bind all <Alt-o> "tkMbPost $mb.option"
bind all <Alt-u> "tkMbPost $mb.util"
bind all <Alt-h> "tkMbPost $mb.help"
bind all <Any-KeyPress>   "tkMbButtonUp $mb.file; tkMbButtonUp $mb.option; \
tkMbButtonUp $mb.util; tkMbButtonUp $mb.help"
bind all <Any-KeyRelease> "tkMbButtonUp $mb.file; tkMbButtonUp $mb.option; \
tkMbButtonUp $mb.util; tkMbButtonUp $mb.help"
if [string match "windows" $tcl_platform(platform)] {
bind all <Any-Motion>     "tkMbButtonUp $mb.file; tkMbButtonUp $mb.option; \
tkMbButtonUp $mb.util; tkMbButtonUp $mb.help"
}
}
}
if 0 {
}
bind all <Control-n> "UI_PB_NewPost"
bind all <Control-o> "UI_PB_OpenPost"
$gPB(file_menu) entryconfigure $gPB(menu_index,file,close) -accelerator ""
$gPB(file_menu) entryconfigure $gPB(menu_index,file,exit)  -accelerator ""
__RaiseSplash
if { [info exists gPB(PB_LICENSE)] } {
if { $gPB(PB_LICENSE) == "UG_POST_NO_LICENSE" } {
__NoLicenseMsg
}
}
if {[info exists ::env(MULTI_INTERP)] && $::env(MULTI_INTERP) == 1} {
package require comm
set ::PID(main_dialog)     [comm::comm self]
set ::PID(posts_list)      [list]
set ::PID(posts_name_list) [list]
set ::PID(activated)       ""
set ::PID(cur_pid)         ""
__main_AddWindowsMenu
if [string match windows $::tcl_platform(platform)] {
bind $w <Unmap> [list UI_PB_MapUnMap_binding unmap]
bind $w <Map>   [list UI_PB_MapUnMap_binding map]
}
}
wm deiconify $w
if {[info exists env(MULTI_INTERP)] && $env(MULTI_INTERP) == 1} {
set gPB(def_title) [wm title $w]
} else {
set gPB(top_window_children) [tixDescendants $gPB(top_window)]
}
if 0 {
uplevel #0 {
proc disable_saveas {} {
global LicInfo gPB
if { [info exists LicInfo(user_right_limit)] && ![string compare "YES" $LicInfo(user_right_limit)] } {
$gPB(file_menu) entryconfigure $gPB(menu_index,file,save_as) -state disabled
}
}
proc is_obj_or_name {OBJ_ATTR_1} {
upvar $OBJ_ATTR_1 obj_attr_1
global post_object
if [catch {expr $obj_attr_1 + 1}] {
set fobj_list $Post::($::post_object,fmt_obj_list)
PB_com_RetObjFrmName obj_attr_1 fobj_list ret_code
set obj_attr_1 $ret_code
}
}
}
set body_str [info body UI_PB_file_EditPost_mod]
set body_str [regsub -all {tk_messageBox -message \$gPB\(msg,limit_msg\) -icon info -parent \$gPB\(main_window\)} \
$body_str \
{disable_saveas;tk_messageBox -message $gPB(msg,limit_msg) -icon info -parent $gPB(main_window)}]
set proc_str [list proc UI_PB_file_EditPost_mod [list dlg_id file_name args] $body_str]
eval $proc_str
set body_str [info body __com_UnGraySaveOptions_mod]
set body_str [regsub -all {\$mb entryconfigure \$gPB\(menu_index,file,save_as\) -state normal} \
$body_str \
{$mb entryconfigure $gPB(menu_index,file,save_as) -state normal; \
disable_saveas}]
set proc_str [list proc __com_UnGraySaveOptions_mod [list] $body_str]
eval $proc_str
set body_str [info body PB_adr_CreateAdrObj]
set body_str [regsub -all {global post_object} \
$body_str \
{global post_object;is_obj_or_name obj_attr(1)}]
set proc_str [list proc PB_adr_CreateAdrObj [list OBJ_ATTR OBJ_LIST] $body_str]
eval $proc_str
}
if 1 {
if { [llength [info commands is_obj_or_name] ] == 0 } {
uplevel #0 {
proc is_obj_or_name { obj_attr_1 } {
global post_object
if [catch {expr $obj_attr_1 + 1}] {
set fobj_list $Post::($::post_object,fmt_obj_list)
PB_com_RetObjFrmName obj_attr_1 fobj_list ret_code
set obj_attr_1 $ret_code
}
return $obj_attr_1
}
}
if { [llength [info commands PB_adr_CreateAdrObj] ] && [llength [info commands PB_SYS_adr_CreateAdrObj] ] == 0 } {
rename PB_adr_CreateAdrObj PB_SYS_adr_CreateAdrObj
uplevel #0 {
proc PB_adr_CreateAdrObj { OBJ_ATTR OBJ_LIST } {
upvar $OBJ_ATTR obj_attr
upvar $OBJ_LIST obj_list
set obj_attr(1) [is_obj_or_name $obj_attr(1)]
PB_SYS_adr_CreateAdrObj obj_attr obj_list
}
}
}
}
if { [llength [info commands disable_saveas] ] == 0 } {
uplevel #0 {
proc disable_saveas { } {
global LicInfo gPB
if { [info exists LicInfo(user_right_limit)] && ![string compare "YES" $LicInfo(user_right_limit)] } {
$gPB(file_menu) entryconfigure $gPB(menu_index,file,save_as) -state disabled
}
}
}
if { [llength [info commands UI_PB_file_EditPost_mod] ] && [llength [info commands UI_PB_SYS_file_EditPost_mod] ] == 0 } {
rename UI_PB_file_EditPost_mod UI_PB_SYS_file_EditPost_mod
uplevel #0 {
proc UI_PB_file_EditPost_mod { dlg_id file_name args } {
UI_PB_SYS_file_EditPost_mod $dlg_id $file_name $args
disable_saveas
}
}
}
if { [llength [info commands __com_UnGraySaveOptions_mod] ] && [llength [info commands SYS__com_UnGraySaveOptions_mod] ] == 0 } {
rename __com_UnGraySaveOptions_mod SYS__com_UnGraySaveOptions_mod
uplevel #0 {
proc __com_UnGraySaveOptions_mod { } {
SYS__com_UnGraySaveOptions_mod
disable_saveas
}
}
}
if 0 {
if { [llength [info commands UI_PB_SavePostAs_mod] ] && [llength [info commands UI_PB_SYS_SavePostAs_mod] ] == 0 } {
rename UI_PB_SavePostAs_mod UI_PB_SYS_SavePostAs_mod
uplevel #0 {
proc UI_PB_SavePostAs_mod { args } {
global LicInfo
if { [info exists LicInfo(user_right_limit)] && ![string compare "YES" $LicInfo(user_right_limit)] } {
return [tk_messageBox -parent [UI_PB_com_AskActiveWindow] -type ok\
-icon error -message "You are not the author of this licensed Post and\
not allowed to rename it!"]
}
UI_PB_SYS_SavePostAs_mod $args
}
}
}
}
} ;# disable_saveas
} ;# if
}
proc UI_PB_MapUnMap_binding {type} {
global PID
if {$PID(activated) != ""} {
if {$type == "map"} {
comm::comm send -async $PID(activated) {wm deiconify $gPB(main_window)}
} else {
comm::comm send -async $PID(activated) {wm withdraw $gPB(main_window)}
}
}
}
proc UI_PB_interactive {} {
global env
if ![string compare $::tix_version 8.4] {
if [info exists env(PB_interactive)] {
if ![expr $env(PB_interactive)] {
set pb_interactive 0
vwait pb_interactive
}
} else {
set pb_interactive 0
vwait pb_interactive
}
}
}
proc __ListPui { dir POST_LIST } {
upvar $POST_LIST post_list
set file_list [glob -nocomplain $dir/*]
set dir_list [list]
foreach file $file_list {
set f [file join $dir [file tail $file]]
if { ![catch { set file_type [file type $f] }] } {
switch [file type $f] {
file {
if { [file extension $f] == ".pui" } {
lappend post_list $f
}
}
directory {
lappend dir_list $f
}
}
}
}
foreach d $dir_list {
__ListPui $d post_list
}
}
proc UI_PB_SnapShotRuntimeObjs { } {
global gPB
set gPB(globals) ""
foreach glob { gPB gpb mom } {}
foreach glob { mom } {
foreach g [info globals ${glob}*] {
global $g
lappend gPB(globals) $g
if [array exists $g] {
foreach a [array names $g] {
lappend gPB(globals) ${g}($a)
}
}
}
}
foreach item [array names gPB] {
if {![string match "globals" $item]} {
lappend gPB(globals) "gPB($item)"
}
}
set gPB(procs) ""
set gPB(procs) [info procs PB*]
}
proc UI_PB_CleanUpRuntimeObjs { } {
global gPB
foreach p [info procs PB*] {
if { [lsearch $gPB(procs) "$p"] < 0  &&\
![string match "PB_VNC_*" "$p"]  &&\
![string match "PB_SIM_*" "$p"] } {
rename $p ""
}
}
unset gPB(procs)
foreach glob { gPB gpb mom } {}
foreach glob { mom } {
foreach g [info globals ${glob}*] {
global $g
if { [array exists $g] } {
foreach a [array names $g] {
if { [lsearch $gPB(globals) ${g}($a)] < 0 } {
unset ${g}($a)
}
}
}
if { [lsearch $gPB(globals) $g] < 0 } {
unset $g
}
}
}
foreach item [array names gPB] {
if {![string match "globals" $item] &&  \
([lsearch $gPB(globals) gPB($item)] < 0) && \
![string match "open_files_list" $item] && \
![string match "file_menu_posts_list" $item]} {
unset gPB($item)
}
}
unset gPB(globals)
global isv_def_id isv_rev_id
if [info exists isv_def_id] {
unset isv_def_id
}
if [info exists isv_rev_id] {
unset isv_rev_id
}
}
proc UI_PB_OpenCmdLinePost { } {
global gPB
global env
global mom_sys_arr mom_kin_var mom_sim_arr
global post_object
if { ![info exists gPB(CMD_LINE_PUI)] || [string trim $gPB(CMD_LINE_PUI)] == "" } {
return
} else {
set save_it  0
set close_it 0
set backup_save $gPB(backup_method)
set run_autoqc 0
if { $gPB(CMD_LINE_PUI) == "autoqc" } {
set gPB(auto_qc) 1
if [string match "UG_POST_AUTHOR" $gPB(PB_LICENSE)] {
set gPB(PB_LICENSE) UG_POST_MILL
}
set gPB(CMD_LINE_PUI)      "$env(PB_AUTOQC_POST_DIR)"
set gPB(CMD_LINE_SAVE_DIR) "$env(PB_AUTOQC_SAVE_DIR)"
set gPB(CMD_LINE_PUI)      [file join $gPB(CMD_LINE_PUI)]
set gPB(CMD_LINE_SAVE_DIR) [file join $gPB(CMD_LINE_SAVE_DIR)]
set save_it 1
set close_it 1
set run_autoqc 1
set check_command_save $gPB(check_cc_unknown_command)
set check_block_save   $gPB(check_cc_unknown_block)
set check_address_save $gPB(check_cc_unknown_address)
set check_format_save  $gPB(check_cc_unknown_format)
}
set post_list [list]
set file_type [file type $gPB(CMD_LINE_PUI)]
switch $file_type {
file {
lappend post_list $gPB(CMD_LINE_PUI)
set save_dir [file dirname $gPB(CMD_LINE_PUI)]
}
directory {
if { $run_autoqc == 0 } {
return
}
__ListPui $gPB(CMD_LINE_PUI) post_list
set save_dir $gPB(CMD_LINE_PUI)
set close_it 1
set gPB(backup_method) "NO_BACKUP"
}
}
set save_post_list [list]
set sl [expr [string length $save_dir] + 1]
foreach f $post_list {
lappend save_post_list [string range $f $sl end]
}
if { [info exists gPB(CMD_LINE_SAVE_DIR)] && $gPB(CMD_LINE_SAVE_DIR) != "" } {
set save_dir $gPB(CMD_LINE_SAVE_DIR)
set save_it 1
} else {
if { [string match "directory" $file_type] } {
UI_PB_debug_Pause "Target for saving Post must be a directory!"
return
}
}
if [info exists gPB(CMD_LINE_SAVE_PUI)] {
if { [file dirname $gPB(CMD_LINE_SAVE_PUI)] != "." && \
[file dirname $gPB(CMD_LINE_SAVE_PUI)] != ""} {
set save_dir [file dirname $gPB(CMD_LINE_SAVE_PUI)]
}
set save_post_list [file tail $gPB(CMD_LINE_SAVE_PUI)]
set save_it 1
}
set tmp_list [list]
foreach f $save_post_list {
lappend tmp_list [file join $save_dir $f]
}
set save_post_list $tmp_list
if [info exists gPB(PB_LICENSE)] {
if { $gPB(PB_LICENSE) == "UG_POST_NO_LICENSE" } {
set save_it 0
}
} else {
set save_it 0
}
if { [info exists env(PB_CMD_LINE_CLOSE)] &&  $env(PB_CMD_LINE_CLOSE) } {
set close_it 1
}
if $run_autoqc {
wm title $gPB(top_window) "$gPB(Postbuilder_Release) - AutoQC"
if { ![file exists $save_dir] } {
file mkdir $save_dir
}
set log_fid [open $save_dir/__pb_autoqc_[clock clicks].log w+]
}
if [info exists log_fid] {
set time_string [clock format [clock seconds] -format "%c %Z"]
puts $log_fid "\#============================================================================"
puts $log_fid "\# Post Builder AutoQC Session Log File created by $env(USERNAME)"
puts $log_fid "\# @ $time_string."
puts $log_fid "\#============================================================================"
puts $log_fid ""
puts $log_fid "List of Posts subject to Auto QC:\n"
set i 0
foreach p $post_list {
incr i
puts $log_fid "$i\t$p"
}
flush $log_fid
}
if [info exists log_fid] {
puts $log_fid ""
}
set i 0
foreach pui $post_list save_pui $save_post_list {
incr i
if [info exists log_fid] {
puts $log_fid "$i"
}
PB_file_FindTclDefOfPui $pui tcl_file def_file
if { $tcl_file == "" || ![file exists $tcl_file] || \
$def_file == "" || ![file exists $def_file] } {
if [info exists log_fid] {
puts $log_fid "ERROR ???  Incomplete Post $pui not processed!"
flush $log_fid
}
continue
}
if [info exists log_fid] {
set c1 [clock seconds]
puts $log_fid "***  Processing $pui... \
[file size $pui] [file size $tcl_file] [file size $def_file]"
flush $log_fid
}
if { [lsearch -exact [package names] "stooop"] < 0 } {
source $env(PB_HOME)/tcl/exe/stooop.tcl
namespace import stooop::*
}
set pui [file join [file dirname $pui] [file tail $pui]]
if [catch { __open_CmdLinePost $pui } res] {
if [info exists log_fid] {
puts $log_fid "ERROR ---  Opening $pui failed! \n\n $res\n"
flush $log_fid
}
continue
} else {
if [info exists log_fid] {
set c2 [clock seconds]
puts $log_fid "       [format %[string length $save_pui]s $pui] opened.\
[file size $pui]\
[file size $tcl_file]\
[file size $def_file] -> [clock format [expr $c2 - $c1] -format %M:%S]"
flush $log_fid
}
}
update
if $save_it {
set save_dir [file dirname $save_pui]
set gpb_pui_file [file tail $save_pui]
set gpb_def_file [file rootname $gpb_pui_file].def
set gpb_tcl_file [file rootname $gpb_pui_file].tcl
if { ![file exists $save_dir] } {
file mkdir $save_dir
}
if {[info exists env(MULTI_INTERP)] && $env(MULTI_INTERP) == 1} {
comm::comm send $::PID(activated) \
[list __save_CmdLinePost $save_dir $gpb_pui_file $gpb_def_file $gpb_tcl_file $close_it $log_fid $c2]
} else {
__save_CmdLinePost $save_dir $gpb_pui_file $gpb_def_file $gpb_tcl_file $close_it $log_fid $c2
}
}
if $close_it {
if {[info exists env(MULTI_INTERP)] && $env(MULTI_INTERP) == 1} {
set pid [comm::comm send $::PID(activated) [list pid]]
UI_PB_com_UpdateWindowsMenu $::PID(activated) NULL delete
if [string match windows $::tcl_platform(platform)] {
exec taskkill /f /pid $pid
} else {
exec kill $pid
}
} else {
__close_CmdLinePost
}
}
}
}
if $run_autoqc {
set gPB(backup_method) $backup_save
set gPB(check_cc_unknown_command) $check_command_save
set gPB(check_cc_unknown_block)   $check_block_save
set gPB(check_cc_unknown_address) $check_address_save
set gPB(check_cc_unknown_format)  $check_format_save
if [info exists log_fid] {
set time_string [clock format [clock seconds] -format "%c %Z"]
puts $log_fid ""
puts $log_fid "\#============================================================================"
puts $log_fid "\# Post Builder AutoQC Complete"
puts $log_fid "\# @ $time_string."
puts $log_fid "\#============================================================================"
close $log_fid
}
bell; after 200
bell; after 100
bell; after 100
bell; after 200
bell; after 450
bell; after 200
bell; after 200
}
if { [info exists env(PB_CMD_LINE_EXIT)] && $env(PB_CMD_LINE_EXIT) } {
UI_PB_ExitPost
} else {
if { [string match "directory" $file_type] } {
UI_PB_debug_Pause "AutoQC Complete!"
}
}
}
proc __open_CmdLinePost {pui} {
global env gPB
set ret_cod [UI_PB_file_EditPost 1 $pui 1]
if {$ret_cod == "TCL_ERROR"} {
error "Error raised during opening the post!"
}
}
proc __close_CmdLinePost {} {
global post_object
global mom_sys_arr mom_kin_var mom_sim_var
UI_PB_com_DeleteTopLevelWindows
if [catch {delete $post_object} res] {
tk_messageBox -message  $res
}
if [array exists mom_sys_arr] { PB_com_unset_var mom_sys_arr }
if [array exists mom_kin_var] { PB_com_unset_var mom_kin_var }
if [array exists mom_sim_arr] { PB_com_unset_var mom_sim_arr }
set ::stooop::newId 0
unset ::stooop::fullClass
if [catch {UI_PB_CleanUpRuntimeObjs} res] {
__Pause $res
}
if [info exists gPB(ugpost_base_sourced)] {
unset gPB(ugpost_base_sourced)
}
}
proc __save_CmdLinePost {save_dir gpb_pui_file gpb_def_file gpb_tcl_file close_it log_fid c2} {
global gPB
set save_dir $save_dir
set gpb_pui_file $gpb_pui_file
set gpb_def_file $gpb_def_file
set gpb_tcl_file $gpb_tcl_file
PB_int_SetPostOutputFiles save_dir gpb_pui_file gpb_def_file gpb_tcl_file
set iter 1
for { set j 0 } { $j < $iter } { incr j } {
if { ![catch { UI_PB_save_a_post } res] } {
if [info exists log_fid] {
set c3 [clock seconds]
if [info exists gPB(master_pid)] {
comm::comm send $gPB(master_pid) [list puts $log_fid " ++    $save_dir/$gpb_pui_file saved. \
[file size $save_dir/$gpb_pui_file]\
[file size $save_dir/$gpb_tcl_file]\
[file size $save_dir/$gpb_def_file] ->\
[clock format [expr $c3 - $c2] -format %M:%S]"]
comm::comm send $gPB(master_pid) [list flush $log_fid]
} else {
puts $log_fid " ++    $save_dir/$gpb_pui_file saved. \
[file size $save_dir/$gpb_pui_file]\
[file size $save_dir/$gpb_tcl_file]\
[file size $save_dir/$gpb_def_file] ->\
[clock format [expr $c3 - $c2] -format %M:%S]"
flush $log_fid
}
set c2 $c3
}
} else {
if [info exists log_fid] {
if [info exists gPB(master_pid)] {
comm::comm send $gPB(master_pid) [list puts $log_fid "ERROR ---  Saving $save_dir/$gpb_pui_file failed! \n $res\n"]
comm::comm send $gPB(master_pid) [list flush $log_fid]
} else {
puts $log_fid "ERROR ---  Saving $save_dir/$gpb_pui_file failed! \n $res\n"
flush $log_fid
}
}
break
}
}
__ClearLicRelatedInfo
if !$close_it {
set n [expr $::stooop::newId + 1]
for { set obj_id 0 } { $obj_id < $n } { incr obj_id } {
PB_com_DeleteObject $obj_id
}
set ::stooop::newId 0
unset ::stooop::fullClass
}
}
proc __main_AddWindowsMenu {} {
global gPB paOption env
global PID
if {[info exists env(LIMIT_NUM)] && $env(LIMIT_NUM) == 1} {
return
}
if ![info exists gPB(window_menu)] {
set w $gPB(main_menu_bar)
set label_text $gPB(main,windows,Label)
if {[info exists gPB(localization)] && $gPB(localization) == 1} {
menubutton $w.window -menu $w.window.m -text $label_text \
-underline [expr [string length $label_text] - 2] \
-takefocus 1 -bg $paOption(menu_bar_bg) -relief flat
} else {
menubutton $w.window -menu $w.window.m -text $label_text \
-underline 0 \
-takefocus 1 -bg $paOption(menu_bar_bg) -relief flat
}
switch $::tix_version {
8.4 {
pack $w.window -side left -padx 10 -pady 2
}
4.1 {
pack $w.window -side left -padx 10
}
}
menu $w.window.m -tearoff 0
set gPB(window_menu) $w.window.m
}
if {[llength $PID(posts_list)] == 0} {
[winfo parent $gPB(window_menu)] config -state disabled
} else {
[winfo parent $gPB(window_menu)] config -state normal
$gPB(window_menu) delete 0 end
foreach one $PID(posts_list) {
set lbl [lindex $PID(posts_name_list) [lsearch $PID(posts_list) $one]]
$gPB(window_menu) add radiobutton -label $lbl -indicatoron 1 \
-variable PID(activated) -value $one \
-command [list __main_SwitchPosts $one]
}
}
}
proc __main_SwitchPosts {pid} {
global gPB PID
set PID(activated) $pid
if {$pid != $PID(cur_pid)} {
set PID($PID(cur_pid),title) [wm title $gPB(top_window)]
comm::comm send $pid {wm deiconify $gPB(main_window)}
comm::comm send -async $PID(cur_pid) {wm withdraw $gPB(main_window)}
if [info exists PID($pid,title)] {
wm title $gPB(top_window) $PID($pid,title)
}
set PID(cur_pid) $pid
}
}
proc __main_AddOptionsMenu {} {
global gPB paOption env
set w $gPB(main_menu_bar)
set label_text $gPB(main,options,Label)
if {[info exists gPB(localization)] && $gPB(localization) == 1} {
menubutton $w.option -menu $w.option.m -text $label_text \
-underline [expr [string length $label_text] - 2] \
-takefocus 1 -bg $paOption(menu_bar_bg) -relief flat
} else {
menubutton $w.option -menu $w.option.m -text $label_text \
-underline 0 \
-takefocus 1 -bg $paOption(menu_bar_bg) -relief flat
}
switch $::tix_version {
8.4 {
pack $w.option -side left -padx 10 -pady 2
}
4.1 {
pack $w.option -side left -padx 10
}
}
menu $w.option.m -tearoff 0
set gPB(option_menu) $w.option.m
set m $gPB(option_menu).opts
set label_text $gPB(main,options,cmd_check,Label)
if {[info exists gPB(localization)] && $gPB(localization) == 1} {
$gPB(option_menu) add cascade -label $label_text \
-menu $m
} else {
$gPB(option_menu) add cascade -label $label_text \
-menu $m -underline 0
}
menu $m -tearoff 1
set opt(0) $gPB(main,options,cmd_check,command,Label)
set opt(1) $gPB(main,options,cmd_check,block,Label)
set opt(2) $gPB(main,options,cmd_check,address,Label)
set opt(3) $gPB(main,options,cmd_check,format,Label)
if { ![info exists gPB(check_cc_unknown_command)] } {
set gPB(check_cc_unknown_command)  0
}
if { ![info exists gPB(check_cc_unknown_block)] } {
set gPB(check_cc_unknown_block)    0
}
if { ![info exists gPB(check_cc_unknown_address)] } {
set gPB(check_cc_unknown_address)  0
}
if { ![info exists gPB(check_cc_unknown_format)] } {
set gPB(check_cc_unknown_format)   0
}
set var(0) gPB(check_cc_unknown_command)
set var(1) gPB(check_cc_unknown_block)
set var(2) gPB(check_cc_unknown_address)
set var(3) gPB(check_cc_unknown_format)
if { [info exists gPB(FORCE_SYNTAX_CHECK)] && $gPB(FORCE_SYNTAX_CHECK) } {
set n_opt 4
set gPB(check_cc_syntax_error)     1
} else {
set n_opt 5
set opt(4) $gPB(main,options,cmd_check,syntax,Label)
if { ![info exists gPB(check_cc_syntax_error)] } {
set gPB(check_cc_syntax_error)     1
}
set var(4) gPB(check_cc_syntax_error)
}
for {set i 0} {$i < $n_opt} {incr i} \
{
if {[info exists env(MULTI_INTERP)] && $env(MULTI_INTERP) == 1} {
$m add checkbutton -label "$opt($i)" \
-variable $var($i) -onvalue 1 -offvalue 0 \
-command [list __SyncVar $var($i)]
} else {
$m add checkbutton -label "$opt($i)" \
-variable $var($i) -onvalue 1 -offvalue 0
}
}
$gPB(option_menu) add separator
set m $gPB(option_menu).bck
set label_text $gPB(main,options,backup,Label)
if {[info exists gPB(localization)] && $gPB(localization) == 1} {
$gPB(option_menu) add cascade -label $label_text \
-menu $m
} else {
$gPB(option_menu) add cascade -label "$label_text" \
-menu $m -underline 0
}
menu $m -tearoff 0
if {[info exists env(MULTI_INTERP)] && $env(MULTI_INTERP) == 1} {
$m add radiobutton -label "$gPB(main,options,backup,one,Label)" -indicatoron 1 \
-variable gPB(backup_method) -value "BACKUP_ONE" \
-command [list __SyncVar gPB(backup_method)]
$m add radiobutton -label "$gPB(main,options,backup,all,Label)" -indicatoron 1 \
-variable gPB(backup_method) -value "BACKUP_ALL" \
-command [list __SyncVar gPB(backup_method)]
$m add radiobutton -label "$gPB(main,options,backup,none,Label)" -indicatoron 1 \
-variable gPB(backup_method) -value "NO_BACKUP" \
-command [list __SyncVar gPB(backup_method)]
} else {
$m add radiobutton -label "$gPB(main,options,backup,one,Label)" -indicatoron 1 \
-variable gPB(backup_method) -value "BACKUP_ONE"
$m add radiobutton -label "$gPB(main,options,backup,all,Label)" -indicatoron 1 \
-variable gPB(backup_method) -value "BACKUP_ALL"
$m add radiobutton -label "$gPB(main,options,backup,none,Label)" -indicatoron 1 \
-variable gPB(backup_method) -value "NO_BACKUP"
}
if 0 {
if { ![info exists gPB(close_post_no_confirm)] } {
set gPB(close_post_no_confirm) 0
}
$gPB(option_menu) add separator
$gPB(option_menu) add checkbutton -label "Close Post without Confirmation" \
-variable gPB(close_post_no_confirm) -onvalue 1 -offvalue 0
}
if 0 { ;# It doesn't quite work dynamically!
if { ![info exists gPB(HIDE_POST_PREVIEW_PAGE)] } {
set gPB(HIDE_POST_PREVIEW_PAGE) 1
}
$gPB(option_menu) add separator
$gPB(option_menu) add checkbutton -label "Hide Post Preview Page" \
-variable gPB(HIDE_POST_PREVIEW_PAGE) -onvalue 1 -offvalue 0 \
-command "__main_AddPostPreviewTab"
}
PB_enable_balloon $w.option
set gPB_help_tips($w.option)   {$gPB(main,options,Balloon)}
global tcl_platform
if { [string match "windows" $tcl_platform(platform)] } {}
if 1 {
$gPB(option_menu) add separator
set label_text $gPB(ude,editor,enable,Label)
if 0 {
if {[info exists gPB(localization)] && $gPB(localization) == 1} {
$gPB(option_menu) add checkbutton -label $label_text \
-variable ::env(PB_UDE_ENABLED) -onvalue 1 \
-offvalue 0
} else {
$gPB(option_menu) add checkbutton -label $label_text \
-variable ::env(PB_UDE_ENABLED) -onvalue 1 \
-offvalue 0 -underline 0
}
} else {
set m $gPB(option_menu).ude
if {[info exists gPB(localization)] && $gPB(localization) == 1} {
$gPB(option_menu) add cascade -label $label_text -menu $m
} else {
$gPB(option_menu) add cascade -label $label_text -underline 0 \
-menu $m
}
menu $m -tearoff 0
$m add radiobutton -label $gPB(nav_button,yes,Label) \
-variable ::env(PB_UDE_ENABLED) \
-value 1 -command [list set ::ude_enable 1]
$m add radiobutton -label $gPB(nav_button,no,Label) \
-variable ::env(PB_UDE_ENABLED) \
-value 0 -command [list set ::ude_enable 0]
$m add radiobutton -label $gPB(ude,editor,enable,as_saved,Label) \
-variable ::env(PB_UDE_ENABLED) \
-value 2 -command [list set ::ude_enable 0]
}
} else {
set ::env(PB_UDE_ENABLED) 0
}
if {$::tix_version == "8.4" && $::tcl_platform(platform) == "windows"} {
set lan_menu [menu $gPB(option_menu).lan -tearoff 0]
set msg_files [glob -nocomplain \
[file dirname $env(PB_HOME)]/[file tail $env(PB_HOME)]/msgs/*.tcl]
set gPB(current_lan) [::msgcat::mclocale]
set gPB(localize_lan_menu_item) 0
if [llength $msg_files] {
foreach one [lsort $msg_files] {
set fn [lindex [file split [file rootname $one]] end]
set fn [string tolower $fn]
if [__IsLanguageDefined $fn] {
set state normal
} else {
set state disabled
}
if [info exists gPB($fn)] {
set lbl $gPB($fn)
} else {
set lbl $fn
set gPB($fn) $fn
}
if {$gPB(localize_lan_menu_item) == 0} {
switch $fn {
pb_msg_english {
set lbl English
}
pb_msg_french {
set lbl Fran\u00E7ais
}
pb_msg_german {
set lbl Deutsch
}
pb_msg_italian {
set lbl Italiano
}
pb_msg_japanese {
set lbl \u65E5\u672C\u8A9E
}
pb_msg_korean {
set lbl \uD55C\uAD6D\uC5B4
}
pb_msg_russian {
set lbl \u0420\u0443\u0441\u0441\u043A\u0438\u0439
}
pb_msg_simple_chinese {
set lbl \u4E2D\u6587(\u7B80\u4F53)
}
pb_msg_spanish {
set lbl Espa\u00F1ol
}
pb_msg_traditional_chinese {
set lbl \u4E2D\u6587(\u7E41\u9AD4)
}
default        {
if { [info exists gPB($fn,LABEL)] } {
set lbl $gPB($fn,LABEL)
}
}
}
}
$lan_menu add radiobutton -label $lbl \
-variable gPB(current_lan) -value $fn \
-command [list UI_PB_com_SelectLanguage $fn] \
-state $state
}
}
$gPB(option_menu) add separator
if {$gPB(localization) == 0} {
$gPB(option_menu) add cascade -label "$gPB(language,Label)" \
-menu $lan_menu -underline 0
} else {
$gPB(option_menu) add cascade -label "$gPB(language,Label)" \
-menu $lan_menu
}
}
if { [string match "windows" $tcl_platform(platform)] } {}
if 1 {
$gPB(option_menu) config -postcommand [list __enable_ude_editor $gPB(option_menu)]
}
if {$::disable_license == 1} {
return
}
if 0 {
if {[info exists gPB(PB_SITE_ID)] && [string match "For Internal UGS PLM*" $gPB(PB_SITE_ID)]} {
if {$gPB(PB_LICENSE) == "UG_POST_AUTHOR"} {
set gPB(lic_list) [list]
if [file exists $env(HOME)\\pb_license_tcl.txt] {
if [llength [info commands UI_PB_decrypt_post] ] {
if [catch {UI_PB_decrypt_post $env(HOME)\\pb_license_tcl.txt NO TRUE NO} err] {
tk_messageBox -message $err -icon error -parent $gPB(top_window)
} else {
foreach name [array names gPB MTK_License*] {
lappend gPB(lic_list) [list [lindex [split $name ,] 1] [set gPB($name)]]
unset gPB($name)
}
}
}
} else {
set gPB(license_no_list_file) 1
}
}
}
}
switch $gPB(PB_LICENSE) {
"UG_POST_AUTHOR" {
}
"UG_POST_ADV_BLD" {
catch { $gPB(file_menu) delete $gPB(menu_index,file,mdfa) }
$gPB(file_menu) insert $gPB(menu_index,file,mdfa) sep
}
}
}
proc __SyncVar { var_name } {
global PID gPB
if {[llength $PID(posts_list)] != 0} {
foreach one $PID(posts_list) {
comm::comm send -async $one [list set $var_name [set $var_name]]
}
}
}
proc __main_AddLicenseControlManagement { } {
global gPB env paOption
if { $::disable_internal_user_lc } {
return
}
if {$::disable_license == 1} {
return
}
if { [PB_is_v 4] < 0 } {
return
}
if 1 {
if { [info exists gPB(PB_SITE_ID)] } {
if {$gPB(PB_LICENSE) == "UG_POST_AUTHOR"} {
if { [info exists gPB(lic_list)]  &&  [llength $gPB(lic_list)] > 0 } {
if { [string match "*EXPIRATION *" [lindex $gPB(lic_list) 0] ] } {
set tmp_list [list]
set expiration [lindex $gPB(lic_list) 0]
set gPB(lic_list) [lreplace $gPB(lic_list) 0 0]
if { ![string match "__UGPB_ISV_internal_use" $gPB(PB_SITE_ID)] &&\
![string match "For Internal UGS PLM Use Only" $gPB(PB_SITE_ID)] } {
lappend tmp_list [string trim [string trim $expiration \{] \}]
}
foreach lic $gPB(lic_list) {
set lic  [string trim [string trim $lic \{] \}]
set name [lindex $lic 0]
set num  [lindex $lic 1]
lappend tmp_list "set gPB(MTK_License,$name) $num"
}
global LicInfo
set LicInfo(site_id) $gPB(PB_SITE_ID)
catch { UI_PB_encrypt_post $env(HOME)/pb_license_tcl.txt $tmp_list TRUE }
unset expiration
unset tmp_list
}
}
if { 0 } { ;# This case should not be needed anymore!
if { ![info exists gPB(lic_list)]  ||  ![llength $gPB(lic_list)] } {
set gPB(lic_list) [list]
if [file exists $env(HOME)\\pb_license_tcl.txt] {
if [llength [info commands UI_PB_decrypt_post] ] {
if [catch {UI_PB_decrypt_post $env(HOME)\\pb_license_tcl.txt NO TRUE NO} err] {
tk_messageBox -message $err -icon error -parent $gPB(top_window)
} else {
foreach name [array names gPB MTK_License*] {
lappend gPB(lic_list) [list [lindex [split $name ,] 1] [set gPB($name)]]
unset gPB($name)
}
}
}
} else {
set gPB(license_no_list_file) 1
}
}
}
}
}
} ;# if
wm title $gPB(top_window) "$gPB(Postbuilder_Release) - License Control"
set m $gPB(util_menu).license
$gPB(util_menu) add separator
set label_text $gPB(main,utils,blic,Label)
if {[info exists gPB(localization)] && $gPB(localization) == 1} {
$gPB(util_menu) add command -label $label_text \
-command "UI_PB_browse_licenses" -state normal
} else {
$gPB(util_menu) add command -label $label_text -underline 7 \
-command "UI_PB_browse_licenses" -state normal
}
if {[string length $gPB(lic_list)] == 0} {
$gPB(util_menu) entryconfigure 4 -state disabled
}
}
proc UI_PB_rest_license_option {} {
global gPB
if {[info exists gPB(license_authorize)] && $gPB(license_authorize) == 1 } {
set gPB(license_authorize) 0
set gPB(license_unlock) 0
set gPB(license_to_use) {}
set gPB(license_to_use_vnc) {}
unset gPB(license_select)
}
}
proc UI_PB_browse_licenses {} {
global gPB
set win [UI_PB_com_AskActiveWindow].brw_lic
toplevel $win
UI_PB_com_CreateTransientWindow $win \
"$gPB(encrypt,browser,Label)" "198x200+400+200" "" "" "" ""
set label_list {"gPB(nav_button,cancel,Label)"}
set cb_arr(gPB(nav_button,cancel,Label)) "destroy $win"
UI_PB_com_CreateButtonBox $win label_list cb_arr
frame $win.top -relief sunken -bd 1
pack $win.top -side top -fill both -expand yes
set f2 [frame $win.top.f2]
pack $f2 -fill both -expand yes -padx 10 -pady 7
set scl [scrollbar $f2.scl -command "$f2.lsb yview"]
set lsb [listbox $f2.lsb -yscrollcommand "$scl set"]
foreach one [lsort $gPB(lic_list)] {
if {[string match "CAM_KIT_POST_*" [lindex $one 0]] \
|| [string match "CAM_EX_KIT_POST_*" [lindex $one 0]]} {
$lsb insert end [lindex $one 0]
}
}
pack $scl -side right -fill y
pack $lsb -side left  -fill both -expand yes
grab $win
}
proc UI_PB_select_license_for_post { } {
global gPB paOption LicInfo
if { $::disable_internal_user_lc } {
set gPB(license_authorize) 0
if [info exists LicInfo(post_license)] {
set gPB(license_authorize) 1
set gPB(license_select) $LicInfo(post_license)
if { [string length $gPB(license_select)] > 0 } {
set gPB(license_to_use) $gPB(license_select)
set lic_num [lindex $gPB(license_select) 1]
regsub POST $gPB(license_to_use) VNC gPB(license_to_use_vnc)
set gPB(license_to_use_vnc) [lreplace $gPB(license_to_use_vnc) 1 1 [expr $lic_num + 1]]
} else {
set gPB(license_to_use)     ""
set gPB(license_to_use_vnc) ""
}
}
return
}
if {[string length $gPB(lic_list)] == 0} {
set gPB(license_authorize) 0
return
}
if {$::disable_license == 1} {
return
}
if [string match "UG_POST_AUTHOR" $gPB(PB_LICENSE)] {
if {[info exists gPB(lic_list)]} {
if {$gPB(session) == "NEW"} {
set is_needed 1
} else {
if {[info exists LicInfo(is_encrypted_file)] && $LicInfo(is_encrypted_file) == 1} {
if {$gPB(PB_SITE_ID) == $LicInfo(post_site_id)} {
if {[lsearch $gPB(lic_list) $LicInfo(post_license)] >= 0} {
set is_needed 2
} else {
set is_needed 0
}
} else {
set is_needed 0
}
} else {
set is_needed 3
}
}
} else {
set is_needed 0
}
} else {
set is_needed 0
}
if {$is_needed == 0} {
return
}
set gPB(tmp_wait_var) 1
set win [UI_PB_com_AskActiveWindow].select_lic
toplevel $win
UI_PB_com_CreateTransientWindow $win "$gPB(encrypt,title,Label)" "300x140+400+200" "" "" "" ""
if [info exists gPB(master_pid)] {
comm::comm send -async $gPB(master_pid) [list UI_PB_GrayAndUnGrayWindowMenu gray 0]
}
set label_list {"gPB(nav_button,ok,Label)"}
set cb_arr(gPB(nav_button,ok,Label)) "UI_PB_select_license_OK $win"
wm protocol $win WM_DELETE_WINDOW {set a 1}
UI_PB_com_CreateButtonBox $win label_list cb_arr
frame $win.top -relief sunken -bd 1
pack $win.top -side top -fill both -expand yes
set ckb [checkbutton $win.top.c -text $gPB(encrypt,output,Label) -onvalue 1 -offvalue 0 \
-variable gPB(license_authorize)]
set lst [tixComboBox $win.top.l -label $gPB(encrypt,license,Label) -editable false \
-dropdown true -variable gPB(license_select)]
if {$::tix_version == "8.4"} {
[$lst subwidget entry] config -readonlybackground $paOption(entry_disabled_bg)
} else {
[$lst subwidget entry] config -bg $paOption(entry_disabled_bg)
}
$ckb config -command "UI_PB_switch_Enc_Dec gPB(license_authorize) $lst"
foreach one [lsort $gPB(lic_list)] {
if { [string match "CAM_KIT_POST_*" [lindex $one 0]] ||\
[string match "CAM_EX_KIT_POST_*" [lindex $one 0]] } {
$lst insert end [lindex $one 0]
}
}
if {$is_needed == 2} {
set gPB(license_authorize) 1
set gPB(license_select) [lindex $LicInfo(post_license) 0]
} else {
set gPB(license_select) [[$lst subwidget listbox] get 0]
}
if {$gPB(license_authorize) == 0} {
$lst config -state disabled
}
pack $ckb -side top -anchor w -padx 5 -pady 8
pack $lst -expand yes -fill x -padx 5 -pady 0 -side top
grab $win
vwait gPB(tmp_wait_var)
}
if 0 {
proc UI_PB_select_license_for_post { } {
global gPB paOption LicInfo
if {[string length $gPB(lic_list)] == 0} {
set gPB(license_authorize) 0
return
}
if {$::disable_license == 1} {
return
}
if [string match "UG_POST_AUTHOR" $gPB(PB_LICENSE)] {
if {[info exists gPB(lic_list)]} {
if {$gPB(session) == "NEW"} {
set is_needed 1
} else {
if {[info exists LicInfo(is_encrypted_file)] && $LicInfo(is_encrypted_file) == 1} {
if {$gPB(PB_SITE_ID) == $LicInfo(post_site_id)} {
if {[lsearch $gPB(lic_list) $LicInfo(post_license)] >= 0} {
set is_needed 2
} else {
set is_needed 0
}
} else {
set is_needed 0
}
} else {
set is_needed 3
}
}
} else {
set is_needed 0
}
} else {
set is_needed 0
}
if {$is_needed == 0} {
return
}
set gPB(tmp_wait_var) 1
set win [UI_PB_com_AskActiveWindow].select_lic
toplevel $win
UI_PB_com_CreateTransientWindow $win \
"$gPB(encrypt,title,Label)" "300x140+400+200" "" "" "" ""
set label_list {"gPB(nav_button,ok,Label)"}
set cb_arr(gPB(nav_button,ok,Label)) "UI_PB_select_license_OK $win"
wm protocol $win WM_DELETE_WINDOW {set a 1}
UI_PB_com_CreateButtonBox $win label_list cb_arr
frame $win.top -relief sunken -bd 1
pack $win.top -side top -fill both -expand yes
set ckb [checkbutton $win.top.c -text $gPB(encrypt,output,Label) -onvalue 1 -offvalue 0 \
-variable gPB(license_authorize)]
set lst [tixComboBox $win.top.l -label $gPB(encrypt,license,Label) -editable false \
-dropdown true -variable gPB(license_select)]
if {$::tix_version == "8.4"} {
[$lst subwidget entry] config -readonlybackground $paOption(entry_disabled_bg)
} else {
[$lst subwidget entry] config -bg $paOption(entry_disabled_bg)
}
$ckb config -command "UI_PB_switch_Enc_Dec gPB(license_authorize) $lst"
foreach one [lsort $gPB(lic_list)] {
if {[string match "CAM_KIT_POST_*" [lindex $one 0]] \
|| [string match "CAM_EX_KIT_POST_*" [lindex $one 0]]} {
$lst insert end [lindex $one 0]
}
}
if {$is_needed == 2} {
set gPB(license_authorize) 1
set gPB(license_select) [lindex $LicInfo(post_license) 0]
} else {
set gPB(license_select) [[$lst subwidget listbox] get 0]
}
if {$gPB(license_authorize) == 0} {
$lst config -state disabled
}
pack $ckb -side top -anchor w -padx 5 -pady 8
pack $lst -expand yes -fill x -padx 5 -pady 0 -side top
grab $win
vwait gPB(tmp_wait_var)
}
}
proc UI_PB_switch_Enc_Dec { VAR lst } {
upvar $VAR var
if {$var == 1} {
$lst config -state normal
} else {
$lst config -state disabled
}
}
proc UI_PB_select_license_OK { win } {
global gPB
if {$gPB(license_authorize) == 1} {
set idx [lsearch $gPB(lic_list) $gPB(license_select)*]
set gPB(license_to_use) [lindex $gPB(lic_list) $idx]
if 0 {
if [string match "CAM_KIT_POST_*" $gPB(license_to_use)] {
set str [lindex $gPB(license_to_use) 0]
set s1 [string range $str 0 7]
set s2 [string range $str 12 end]
set str ${s1}VNC${s2}
} elseif [string match "CAM_EX_KIT_POST_*" $gPB(license_to_use)] {
set str [lindex $gPB(license_to_use) 0]
set s1 [string range $str 0 10]
set s2 [string range $str 15 end]
set str ${s1}VNC${s2}
} else {
set str NONE
}
set idx [lsearch $gPB(lic_list) ${str}*]
}
regsub POST [lindex $gPB(license_to_use) 0] VNC vnc_license
set idx [lsearch $gPB(lic_list) "*$vnc_license*"]
if {$idx >= 0} {
set gPB(license_to_use_vnc) [lindex $gPB(lic_list) $idx]
} else {
set gPB(license_to_use_vnc) ""
}
} else {
set gPB(license_to_use_vnc) ""
set gPB(license_to_use) ""
}
if [info exists gPB(master_pid)] {
comm::comm send -async $gPB(master_pid) [list UI_PB_GrayAndUnGrayWindowMenu ungray 0]
}
destroy $win
set gPB(tmp_wait_var) 0
unset gPB(tmp_wait_var)
}
proc __enable_ude_editor {m} {
global env
if {[info exists env(MULTI_INTERP)] && $env(MULTI_INTERP) == 1} {
global PID
if {[llength $PID(posts_list)] != 0} {
$m entryconfigure 6 -state disabled
} else {
$m entryconfigure 6 -state normal
}
if {[info exists env(LIMIT_NUM)] && $env(LIMIT_NUM) == 1} {
if {[llength $PID(posts_list)] != 0} {
$m entryconfigure 4 -state disabled
} else {
$m entryconfigure 4 -state normal
}
}
} else {
if [info exists ::post_object] {
$m entryconfigure 4 -state disabled
if {$::tix_version == "8.4"} {
$m entryconfigure 6 -state disabled
}
} else {
if {[winfo exists .widget.new] && [wm state .widget.new] == "normal"} {
$m entryconfigure 4 -state disabled
} else {
$m entryconfigure 4 -state normal
}
if {$::tix_version == "8.4"} {
if {[winfo exists .widget.new] && [wm state .widget.new] == "normal"} {
$m entryconfigure 6 -state disabled
} else {
$m entryconfigure 6 -state normal
}
}
}
}
}
if 0 { ;# It doesn't quite work dynamically!
proc __main_AddPostPreviewTab {} {
global gPB
if [info exists gPB(book)] {
if { $gPB(HIDE_POST_PREVIEW_PAGE) == 0 } {
Book::CreatePage $gPB(book) pre "$gPB(preview,tab,Label)" pb_output \
UI_PB_Preview UI_PB_PreviewTab
} else {
$Book::($gPB(book),book_id) delete pre
}
}
}
}
proc __main_AddUtilMenu {} {
global gPB env paOption
if { [PB_is_v3] < 0 } {
return
}
set w $gPB(main_menu_bar)
set label_text $gPB(main,utils,Label)
if {[info exists gPB(localization)] && $gPB(localization) == 1} {
menubutton $w.util -menu $w.util.m -text $label_text \
-underline [expr [string length $label_text] - 2] \
-takefocus 1 -bg $paOption(menu_bar_bg)
} else {
menubutton $w.util -menu $w.util.m -text $label_text -underline 0 \
-takefocus 1 -bg $paOption(menu_bar_bg)
}
pack $w.util -side right -padx 10
menu $w.util.m -tearoff 0
set gPB(util_menu) $w.util.m
set path [join [split $env(PB_HOME) \\] /]
if 0 {
$gPB(util_menu) add command -label "Edit template_post.dat" \
-command "open \"|$path/app/ugwish $path/app/edit_tpd.tcl\""
$gPB(util_menu) add separator
$gPB(util_menu) add command -label "Choose MOM Variable" \
-command "open \"|$path/app/ugwish $path/app/mom_vars_browser.tcl\""
}
set option_idx 0
if { [info exists gPB(edit_template_posts_data)]  && \
[file exists "$gPB(edit_template_posts_data)"] } {
set label_text $gPB(main,utils,etpdf,Label)
if {[info exists gPB(localization)] && $gPB(localization) == 1} {
$gPB(util_menu) add command -label $label_text \
-command "__main_EditTPD $w.install"
} else {
$gPB(util_menu) add command -label $label_text \
-underline 0 \
-command "__main_EditTPD $w.install"
}
incr option_idx
}
if { [info exists gPB(mom_vars_values)]    && \
[info exists gPB(mom_vars_browser)]   && \
[file exists "$gPB(mom_vars_values)"] && \
[file exists "$gPB(mom_vars_browser)"] } {
if $option_idx {
$gPB(util_menu) add separator
}
global gPB_mom_var_values
set gPB_mom_var_values $gPB(mom_vars_values)
set label_text $gPB(main,utils,bmv,Label)
if {[info exists gPB(localization)] && $gPB(localization) == 1} {
$gPB(util_menu) add command -label $label_text \
-command "__main_BrowseMOMVar $w.mom_var"
} else {
$gPB(util_menu) add command -label $label_text \
-underline 0 \
-command "__main_BrowseMOMVar $w.mom_var"
}
incr option_idx
}
if {$gPB(PB_LICENSE) == "UG_POST_AUTHOR"} {
__main_AddLicenseControlManagement
}
}
proc __main_EditTPD { w } {
global gPB gPB_edit_tpd
set flag 0
if { [lsearch -exact [package names] "stooop"] < 0 } {
source $env(PB_HOME)/tcl/exe/stooop.tcl
namespace import stooop::*
set flag 1
}
if { ![winfo exists $w] } {
set gPB_edit_tpd $gPB(edit_template_posts_data)
source "$gPB(edit_template_posts_data)"
}
TPD_edit_template_post $w
after 5 "raise $w"
if $flag {
namespace delete ::stooop
package forget stooop
}
}
proc __main_BrowseMOMVar { w } {
global gPB gPB_mom_var_browser
global env
set flag 0
if { [lsearch -exact [package names] "stooop"] < 0 } {
source $env(PB_HOME)/tcl/exe/stooop.tcl
namespace import stooop::*
set flag 1
}
if { ![winfo exists $w] } {
set gPB_mom_var_browser $gPB(mom_vars_browser)
source "$gPB(mom_vars_browser)"
}
_mom_chm_reader $w
after 5 "raise $w"
if $flag {
namespace delete ::stooop
package forget stooop
}
}
proc __main_AddMoreHelpMenuItems {} {
global gPB
if { [PB_is_v3] < 0 } {
return
}
if { [info exists gPB(release_notes)] && [file exists $gPB(release_notes)] } {
set label_text $gPB(main,help,rel_note,Label)
if {[info exists gPB(localization)] && $gPB(localization) == 1} {
$gPB(help_menu) add command -label "$label_text" \
-command "HelpCmd_release_notes"
} else {
$gPB(help_menu) add command -label "$label_text" -underline 0 \
-command "HelpCmd_release_notes"
}
}
if { [info exists gPB(tcl_tk_manuals)] && [file exists $gPB(tcl_tk_manuals)] } {
$gPB(help_menu) add separator
set label_text $gPB(main,help,tcl_man,Label)
if {[info exists gPB(localization)] && $gPB(localization) == 1} {
$gPB(help_menu) add command -label "$label_text" \
-command "HelpCmd_tcltk_manual"
} else {
$gPB(help_menu) add command -label "$label_text" -underline 0 \
-command "HelpCmd_tcltk_manual"
}
}
}
proc UI_PB_AddVisitedPosts { } {
global gPB
if [info exists gPB(master_pid)] {
if [info exists gPB(open_files_list)] {
comm::comm send $gPB(master_pid) [list set gPB(open_files_list) $gPB(open_files_list)]
}
comm::comm send -async $gPB(master_pid) [list UI_PB_AddVisitedPosts_mod]
} else {
UI_PB_AddVisitedPosts_mod
}
}
proc UI_PB_AddVisitedPosts_mod { } {
global gPB
if { [info exists gPB(file_menu_posts_list)] } \
{
catch { $gPB(file_menu_posts_list) delete 0 end }
destroy $gPB(file_menu_posts_list)
unset gPB(file_menu_posts_list)
catch { $gPB(file_menu) delete $gPB(menu_index,file,sep) $gPB(menu_index,file,history) }
}
if { $gPB(post_history_menu_len) == -1 } {
return
}
if { [info exists gPB(open_files_list)]  &&  [llength $gPB(open_files_list)] } \
{
set gPB(file_menu_posts_list) $gPB(file_menu).posts_list
set m $gPB(file_menu_posts_list)
$gPB(file_menu) add separator
if { $gPB(post_history_menu_len) } \
{
set label_text $gPB(main,file,history,Label)
if {[info exists gPB(localization)] && $gPB(localization) == 1} {
$gPB(file_menu) add cascade -label "$label_text" -menu $m
} else {
$gPB(file_menu) add cascade -label "$label_text" -menu $m -underline 0
}
menu $m -tearoff 0
catch { set gPB(open_files_list) [ltidy $gPB(open_files_list)] }
set i 0
foreach f $gPB(open_files_list) \
{
$m add command -label "[file rootname [file nativename $f]]" \
-command "UI_PB_OpenVisitedPost \"$f\""
incr i
if { $i == "$gPB(post_history_menu_len)" } {
break
}
}
$m add separator
set label_text $gPB(nav_button,manage,Label)
if {[info exists gPB(localization)] && $gPB(localization) == 1} {
$m add command -label "$label_text" \
-command "__CreateVisitedPostsList"
} else {
$m add command -label "$label_text" -underline 0 \
-command "__CreateVisitedPostsList"
}
} else \
{
set label_text $gPB(main,file,history,Label)
if {[info exists gPB(localization)] && $gPB(localization) == 1} {
$gPB(file_menu) add command -label "$label_text ..." \
-command "__CreateVisitedPostsList"
} else {
$gPB(file_menu) add command -label "$label_text ..." \
-underline 0 \
-command "__CreateVisitedPostsList"
}
}
}
}
proc __TidyVisitedPostsList {} {
global gPB
set new_list [list]
foreach f $gPB(open_files_list) \
{
if [file exists $f] \
{
if { [lsearch $new_list "$f"] == -1 } {
lappend new_list $f
}
}
}
return $new_list
}
proc __RefreshVisitedPostsMenu {} {
global gPB
if { $gPB(use_info) } \
{
UI_PB_chelp_DisplayMenuItemCsh $gPB(file_menu)
return
}
set gPB(open_files_list) [__TidyVisitedPostsList]
UI_PB_AddVisitedPosts
}
proc __CreateVisitedPostsList { args } {
global gPB
global paOption
if { $gPB(use_info) } \
{
UI_PB_chelp_DisplayMenuItemCsh $gPB(file_menu)
return
}
set win [toplevel $gPB(top_window).history]
set title "$gPB(main,file,history,Label)"
UI_PB_com_CreateTransientWindow $win "$title" "500x300+300+100" "" "" \
"destroy $win" "__CancelVisitedPost $win"
frame $win.f -relief flat
pack $win.f -side top -expand yes -fill both
set tl [tixScrolledListBox $win.f.tl -options {
listbox.selectMode single
} \
-command "__OpenVisitedPost $win"]
pack $tl -side left -expand yes -fill both -padx 3 -pady 3
set tlist [$tl subwidget listbox]
foreach pname $gPB(open_files_list) \
{
set f [file rootname [file nativename $pname]]
$tlist insert end "$f"
}
$tlist selection set 0
set bf [frame $win.f.b -relief flat]
pack $bf -side right -fill both
set ref_b [button $bf.ref -text $gPB(nav_button,refresh,Label) \
-bg $paOption(app_butt_bg) \
-command "__RefreshVisitedPostsList $tlist"]
set cut_b [button $bf.cut -text $gPB(nav_button,cut,Label) \
-bg $paOption(app_butt_bg) \
-command "__CutVisitedPost $bf $tlist"]
set pas_b [button $bf.pas -text $gPB(nav_button,paste,Label) \
-bg $paOption(app_butt_bg) \
-command "__PasteVisitedPost $bf $tlist"]
__SetPasteButtonState $bf
pack $ref_b $cut_b $pas_b -side top -fill x -padx 3 -pady 3
set gPB(c_help,$ref_b)     "nav_button,refresh"
set gPB(c_help,$cut_b)     "nav_button,cut"
set gPB(c_help,$pas_b)     "nav_button,paste"
frame $win.b -relief flat
pack $win.b -side bottom -expand no -fill x -padx 3 -pady 3
set box1 [frame $win.b.1]
set cb_arr(gPB(nav_button,open,Label))   "__OpenVisitedPost $win"
set cb_arr(gPB(nav_button,cancel,Label)) "__CancelVisitedPost $win"
tixForm $box1 -top 0 -left 0 -right %100
set label_list1 { "gPB(nav_button,open,Label)" "gPB(nav_button,cancel,Label)" }
UI_PB_com_CreateButtonBox $box1 label_list1 cb_arr
UI_PB_GrayOutAllFileOptions
UI_PB_com_PositionWindow $win
}
proc __SetPasteButtonState { frm } {
global gPB
set paste_button $frm.pas
if [info exists gPB(post_history_paste_buffer)] \
{
$paste_button config -state normal
} else \
{
$paste_button config -state disabled
}
}
proc __RefreshVisitedPostsList { tl } {
global gPB
set file_list [list]
foreach f $gPB(open_files_list) \
{
set f [join [split $f "\\"] "/"]
if [file exists $f] \
{
lappend file_list $f
}
}
set new_list [list]
foreach f $file_list \
{
if { [lsearch $new_list $f] < 0 } \
{
lappend new_list $f
}
}
set gPB(open_files_list) $new_list
$tl delete 0 end
foreach pname $gPB(open_files_list) \
{
set f [file rootname [file nativename $pname]]
$tl insert end "$f"
}
$tl selection set 0
}
proc __CutVisitedPost { frm tl } {
global gPB
set i [$tl curselection]
if { $i != "" } \
{
$tl delete $i
set gPB(post_history_paste_buffer) [lindex $gPB(open_files_list) $i]
set gPB(open_files_list) [lreplace $gPB(open_files_list) $i $i]
__SetPasteButtonState $frm
$tl selection set $i
$tl activate $i
}
}
proc __PasteVisitedPost { frm tl } {
global gPB
if [info exists gPB(post_history_paste_buffer)] \
{
set i [$tl curselection]
if { $i != "" } \
{
set f [file rootname [file nativename $gPB(post_history_paste_buffer)]]
set j [expr $i + 1]
$tl insert $j $f
set gPB(open_files_list) [linsert $gPB(open_files_list) $j $gPB(post_history_paste_buffer)]
unset gPB(post_history_paste_buffer)
__SetPasteButtonState $frm
$tl selection clear 0 end
$tl selection set $j
$tl activate $j
}
}
}
proc __OpenVisitedPost { w } {
global gPB
set lb [$w.f.tl subwidget listbox]
set i [$lb curselection]
if { $i != "" } \
{
set pname [lindex $gPB(open_files_list) $i]
destroy $w
UI_PB_OpenVisitedPost "$pname"
}
}
proc __CancelVisitedPost { w } {
UI_PB_OpenCancel_CB; destroy $w
UI_PB_AddVisitedPosts
}
proc __DisplayAboutPostBuilder {} {
global gPB
global paOption
set gPB(About_Post_Builder_msg) [UI_PB_com_AskActiveWindow].about_pb
set win [toplevel $gPB(About_Post_Builder_msg)]
set title "$gPB(main,help,about,Label)"
global env
set text " $gPB(Postbuilder_Release_About)\n\n\
UGII_BASE_DIR \t $env(UGII_BASE_DIR)\n\
POSTBUILD \t $env(PB_HOME)\n\
HOME \t\t $env(HOME)"
set xc [expr [winfo rootx $gPB(top_window)] + 300]
set yc [expr [winfo rooty $gPB(top_window)] + 300]
UI_PB_com_CreateTransientWindow $win "$title" "+$xc+$yc" "" "" \
"grab release $win; destroy $win" \
"grab release $win; destroy $win"
set t [frame $win.t -relief sunken -bd 2]
pack $t -side top -expand yes -fill both
set b [frame $win.b]
pack $b -side bottom -expand yes -fill x
frame $t.f -bg $gPB(entry_color)
pack $t.f -side right -expand yes -fill both
label $t.f.l -text $text -font $gPB(bold_font) -justify left \
-bg $gPB(entry_color)
pack $t.f.l -padx 10 -pady 10
label $t.a -image [tix getimage pb_post_builder] -bg $paOption(title_bg)
pack $t.a -side left -fill y
frame $b.f -relief sunken -bd 1 -takefocus 1 \
-highlightcolor black -highlightthickness 1
pack $b.f -pady 5
button $b.f.b -text "$gPB(nav_button,ok,Label)" -width 10 \
-comman "destroy $win" -takefocus 0
pack $b.f.b -side bottom -padx 1 -pady 1
UI_PB_com_PositionWindow $win
wm resizable $gPB(About_Post_Builder_msg) 0 0
grab set $win
}
proc __NoLicenseMsg {} {
global gPB
global paOption
update
set gPB(NO_LICENSE_msg) $gPB(top_window).no_license
set win [toplevel $gPB(NO_LICENSE_msg)]
set title $gPB(msg,no_license_title)
set text $gPB(msg,no_license_dialog)
set xc [expr [winfo rootx $gPB(top_window)] + 300]
set yc [expr [winfo rooty $gPB(top_window)]]
UI_PB_com_CreateTransientWindow $win "$title" "+$xc+$yc" "" \
"" "return" "return" 0
UI_PB_com_DismissActiveWindow $win
frame $win.f -relief sunken -bd 2 -bg $gPB(entry_color)
pack $win.f -side right -expand yes -fill both
frame $win.f.b -bg red
pack $win.f.b -padx 7 -pady 6
label $win.f.b.l -text $text -font $gPB(bold_font) -justify left \
-fg yellow -bg red
pack $win.f.b.l -padx 5 -pady 3
label $win.a -bitmap error
pack $win.a -side left -padx 3m -pady 3m
UI_PB_com_PositionWindow $win
wm resizable $gPB(NO_LICENSE_msg) 0 0
UI_PB_com_DeleteFromTopLevelList $gPB(NO_LICENSE_msg)
}
proc CB_HelpCmd { w opt } {
global gPB
set idx [lsearch $gPB(help_sel_var) $w]
switch -exact -- $w \
{
man -
dia -
wtd {
if {$idx >= 0} {
set gPB(help_sel_var) [lreplace $gPB(help_sel_var) $idx $idx]
} else {
return
}
}
inf {
if { $gPB(use_info) && $idx >= 0 } \
{
return
} elseif { !$gPB(use_info) && $idx < 0 } \
{
return
} else {}
}
bal {
if { $gPB(use_info) && $idx >= 0 } \
{
return
}
}
}
switch -exact -- $w \
{
man { HelpCmd_man }
dia { HelpCmd_dia }
wtd { HelpCmd_wtd }
inf { HelpCmd_inf }
bal { HelpCmd_bal }
}
}
proc HelpCmd_bal {} {
global gPB
if { [lsearch $gPB(help_sel_var) bal] >= 0 } {
set gPB(use_bal) 1
} else {
set gPB(use_bal) 0
}
SetBalloonHelp
}
proc HelpCmd_inf {} {
global gPB
if { [lsearch $gPB(help_sel_var) inf] >= 0 } {
set gPB(use_info) 1
} else {
set gPB(use_info) 0
}
UI_PB_chelp_SetContextHelp
}
proc __MenuItemCmd_nyi { m } {
global gPB
if { $gPB(use_info) } \
{
return [UI_PB_chelp_DisplayMenuItemCsh $m]
} else \
{
return [tk_messageBox -parent [UI_PB_com_AskActiveWindow] \
-type ok -icon info -message "$gPB(msg,pending)"]
}
}
proc __HelpItemCmd { doc_type } {
global gPB
global env
global tcl_platform
if { $gPB(use_info) } \
{
return [UI_PB_chelp_DisplayMenuItemCsh $gPB(help_menu)]
}
if { [llength [info commands "UI_PB_execute"]] == 0 } \
{
return [__MenuItemCmd_nyi $gPB(help_menu)]
}
switch -- $doc_type \
{
"WHAT_TO_DO" {
return [__MenuItemCmd_nyi $gPB(help_menu)]
}
"DIALOG_HELP" {
return [__MenuItemCmd_nyi $gPB(help_menu)]
}
"USER_MANUAL" {
set doc_file "$gPB(user_manual_file)"
}
"RELEASE_NOTES" {
set doc_file "$gPB(release_notes)"
}
"TCL_TK_MANUAL" {
set doc_file "$gPB(tcl_tk_manuals)"
}
default {
return [__MenuItemCmd_nyi $gPB(help_menu)]
}
}
if { ![file exists $doc_file] } {
return [tk_messageBox -parent [UI_PB_com_AskActiveWindow] \
-type ok -icon error -message "$doc_file $gPB(msg,not_installed_properly)"]
}
if { [string match "unix" $tcl_platform(platform)] } \
{
if { [string match "Darwin" $tcl_platform(os)] } {
catch { UI_PB_execute "open $doc_file" }
return
}
if { ![info exists gPB(unix_netscape)] } {
set gPB(unix_netscape) "netscape"
}
set browser $gPB(unix_netscape)
if [info exists result] { unset result }
set nav_win_found -1 ;# -1 Browser not open
;#  0 Browser open with no navigator
;#  1 Browser open with navigator
;#  2 Browser already displayed manual
if { $gPB(help_win_id) == 0 } \
{
if [catch { set result [exec xwininfo -root -tree | grep -i $browser | grep -i navigator | grep -i "post builder"] }] {
catch { set result [exec xlswins | grep -i $browser | grep -i navigator | grep -i "post builder"] }
}
if [info exists result] \
{
set nav_win_found 2
}
}
if { $gPB(help_win_id) == 0 } \
{
if [catch { set result [exec xwininfo -root -tree | grep -i $browser | grep -i navigator] }] {
catch { set result [exec xlswins | grep -i $browser | grep -i navigator] }
}
if [info exists result] \
{
set nav_win_found 1
}
}
if [info exists result] \
{
set result [join [split $result "\""] ""]
set gPB(help_win_id) [lindex $result 0]
set win(ID) $gPB(help_win_id)
} elseif { $gPB(help_win_id) != 0 } \
{
if [catch { exec xwininfo -id $gPB(help_win_id) }] \
{
set gPB(help_win_id) 0
} else \
{
set win(ID) $gPB(help_win_id)
set nav_win_found 2
}
}
set html_doc_file_1 ""
switch -- $nav_win_found \
{
2  -
1  {
if [string match "*mozilla*" $browser] {
set html_doc_file   "$browser $win(ID) -remote 'openFile($doc_file)'"
set html_doc_file_1 "$browser $win(ID) -remote 'openURL(javascript:window.focus())'"
} else {
set html_doc_file "$browser $win(ID) -raise \
-remote 'openFile($doc_file)'"
}
}
0  {
set html_doc_file "$browser -raise \
-remote 'openFile($doc_file)'"
}
-1 {
set html_doc_file "$browser $doc_file &"
}
}
if { [UI_PB_execute $html_doc_file] == 0 } \
{
return ;# Hunky-Dori
} else \
{
if { $browser != "netscape" } \
{
set html_doc_file_1 ""
set browser "netscape"
set gPB(unix_netscape) $browser
set html_doc_file "$browser $doc_file &"
if { [UI_PB_execute $html_doc_file] == 0 } \
{
return ;# ok
} else \
{
return [tk_messageBox -parent [UI_PB_com_AskActiveWindow] -type ok \
-icon error -message "$gPB(msg,invalid_browser_cmd) $html_doc_file"]
}
} else \
{
return [tk_messageBox -parent [UI_PB_com_AskActiveWindow] -type ok \
-icon error -message "$gPB(msg,invalid_browser_cmd) $browser"]
}
}
if { [string length $html_doc_file_1] > 0 } {
catch { UI_PB_execute $html_doc_file_1 }
}
} elseif { $tcl_platform(platform) == "windows" } \
{
set html_doc_file [join [split $doc_file "/"] "\\\\"]
if { [UI_PB_execute $html_doc_file] != 0 } \
{
return [tk_messageBox -parent [UI_PB_com_AskActiveWindow] -type ok \
-icon error -message "$gPB(msg,no_app_to_open) $html_doc_file"]
}
} else \
{
return [__MenuItemCmd_nyi $gPB(help_menu)]
}
}
proc HelpCmd_wtd {} {
return [__HelpItemCmd WHAT_TO_DO]
}
proc HelpCmd_dia {} {
return [__HelpItemCmd DIALOG_HELP]
}
proc HelpCmd_man {} {
return [__HelpItemCmd USER_MANUAL]
}
proc HelpCmd_release_notes {} {
return [__HelpItemCmd RELEASE_NOTES]
}
proc HelpCmd_tcltk_manual {} {
return [__HelpItemCmd TCL_TK_MANUAL]
}
proc HelpCmd_abo {} {
global gPB
if { $gPB(use_info) } \
{
return [UI_PB_chelp_DisplayMenuItemCsh $gPB(help_menu)]
} else \
{
return [__DisplayAboutPostBuilder]
}
}
proc HelpCmd_ack {} {
global gPB
if { $gPB(use_info) } \
{
return [UI_PB_chelp_DisplayMenuItemCsh $gPB(help_menu)]
} else \
{
set msg "Development team of UG/Post\ Builder\
acknowledges that Tcl/Tk, Tix and\
Stooop have been utilized in the development of\
this software.  Credits should\
be honored to the authors of these\
tool kits (John Ousterhout, Ioi Lam &\
Jean-Luc Fontaine and their\
associates), who have subconsciously\
made invaluable contribution to\
this product.\n\n\
\n Team Members:\
\n\
\n     Arun N.\
\n     Bill B.\
\n     Bing Z.\
\n     Binu P.\
\n     Byung C.\
\n     David L.\
\n     Gen S. L.\
\n     Mahendra G.\
\n     Naveen M.\
\n     Peter(Zhi-Gong) M.\
\n     Pheobe(Juan) D.\
\n     Satya C.\
\n     Stan The Man"
return [tk_messageBox -parent [UI_PB_com_AskActiveWindow] -type ok -icon info -message $msg]
}
}
proc OptionCmd_pro {} {
global gPB
return [__MenuItemCmd_nyi $gPB(option_menu)]
}
proc OptionCmd_adv {} {
global gPB
return [__MenuItemCmd_nyi $gPB(option_menu)]
}
proc SetBalloonHelp {} {
global gPB PID
SetBalloonHelp_mod
if {[info exists PID(activated)] && $PID(activated) != ""} {
comm::comm send $PID(activated) [list set gPB(help_sel_var) $gPB(help_sel_var)]
comm::comm send $PID(activated) [list set gPB(use_bal) $gPB(use_bal)]
comm::comm send -async $PID(activated) [list SetBalloonHelp_mod]
}
}
proc SetBalloonHelp_mod {} {
global gPB
global gPB_use_balloons gPB_help_tips
if { $gPB(use_info) } \
{
if { $gPB(use_bal) } {
set gPB(use_bal) 0
} else {
set gPB(use_bal) 1
}
return [UI_PB_chelp_DisplayMenuItemCsh $gPB(help_menu)]
}
set gPB_use_balloons $gPB(use_bal)
set gPB_help_tips(state) $gPB(use_bal)
set idx [lsearch $gPB(help_sel_var) bal]
if { $gPB(use_bal) && $idx >= 0 } \
{
return
} elseif { !$gPB(use_bal) && $idx < 0 } \
{
return
} else \
{
if { $gPB(use_bal) } \
{
set gPB(help_sel_var) [linsert $gPB(help_sel_var) 0 bal]
} else \
{
set gPB(help_sel_var) [lreplace $gPB(help_sel_var) $idx $idx]
}
}
}
proc UI_PB_ExitPostWithOptions { } {
global gPB PID
global exit_option
set exit_option 1
comm::comm send -async $PID(activated) [list UI_PB_com_DisableProcess]
set win $gPB(top_window).exit
set gPB(messagebox_flag) 1
toplevel $win
UI_PB_com_CreateTransientWindow $win "$gPB(exit,options,Label)" "+200+100" \
"" "" "UI_PB_ExitPostWithOptions_CNL $win" ""
set label_list {"gPB(nav_button,cancel,Label)" \
"gPB(nav_button,ok,Label)"}
set cb_arr(gPB(nav_button,cancel,Label)) [list UI_PB_ExitPostWithOptions_CNL $win]
set cb_arr(gPB(nav_button,ok,Label)) [list UI_PB_ExitPostWithOptions_OK $win]
UI_PB_com_CreateButtonBox $win label_list cb_arr
set rb1 [radiobutton $win.rb1 -text "$gPB(exit,options,SaveAll,Label)" -value 1 \
-command [list $win.lb configure -state disabled] \
-variable exit_option]
set rb2 [radiobutton $win.rb2 -text "$gPB(exit,options,SaveNone,Label)" -value 2 \
-command [list $win.lb configure -state disabled] -variable exit_option]
set rb3 [radiobutton $win.rb3 -text "$gPB(exit,options,SaveSelect,Label)" -value 3 \
-command [list $win.lb configure -state normal] -variable exit_option]
set lb  [listbox $win.lb -height 6 -selectmode multiple -takefocus 0 \
-listvariable PID(posts_name_list) \
-state disabled -selectbackground lightblue]
pack $rb1 -side top -anchor w -padx 10 -pady 10
pack $rb2 -anchor w -padx 10 -pady 0
pack $rb3 -anchor w -padx 10 -pady 10
pack $lb  -anchor w -padx 32 -pady 10 -fill both -expand yes
grab $win
focus $win
}
proc UI_PB_ExitPostWithOptions_CNL { win } {
global gPB PID
unset gPB(messagebox_flag)
wm withdraw $win
comm::comm send -async $PID(activated) [list UI_PB_com_EnableProcess]
UI_PB_com_UnGraySaveOptions
destroy $win
}
proc UI_PB_ExitPostWithOptions_OK { win } {
global exit_option PID
wm withdraw $win
comm::comm send -async $PID(activated) [list UI_PB_com_EnableProcess]
set to_save [list]
if {$exit_option == 1} {
set to_save $PID(posts_list)
} elseif {$exit_option == 2} {
set to_save [list]
} else {
set lb $win.lb
set cur_sel [$win.lb curselection]
foreach one $cur_sel {
lappend to_save [lindex $PID(posts_list) $one]
}
}
foreach one $to_save {
set PID(activated) $one
__main_SwitchPosts $one
comm::comm send $one [list UI_PB_SavePost_mod]
}
if {$PID(activated) != ""} {
comm::comm send $PID(activated) [list wm withdraw .widget.main]
}
foreach one $PID(posts_list) {
set sub_pid [comm::comm send $one [list pid]]
if [string match windows $::tcl_platform(platform)] {
exec taskkill /f /pid $sub_pid
} else {
exec kill $sub_pid
}
}
UI_PB_save_SessionLog
exit
}
proc UI_PB_ExitPost { args } {
global gPB
if [info exists gPB(save_as_now)] { return }
if { $gPB(use_info) } \
{
return [UI_PB_chelp_DisplayMenuItemCsh $gPB(file_menu)]
}
if [info exists ::gPB(messagebox_flag)]  { return }
if {[info exists ::env(MULTI_INTERP)] && $::env(MULTI_INTERP) == 1} {
global PID
if {[llength $PID(posts_list)] > 1} {
UI_PB_ExitPostWithOptions
} elseif {[llength $PID(posts_list)] == 1} {
set choice yes
if [catch {set choice [comm::comm send $PID(activated) UI_PB_ClosePost_mod]} res] {
__Pause $res
}
if {$choice != "cancel" && $choice != ""} {
unset PID(posts_list)
UI_PB_save_SessionLog
exit
}
} else {
UI_PB_save_SessionLog
exit
}
} else {
if { [info exists gPB(main_window)] && $gPB(main_window) != "" } \
{
if [catch {set choice [UI_PB_ClosePost]} res] {
__Pause $res
}
if { $choice == "yes" || $choice == "no" } \
{
UI_PB_save_SessionLog
exit
}
} else \
{
UI_PB_save_SessionLog
exit
}
}
}
proc UI_PB_save_SessionLog { args } {
global gPB env
set fid ""
if [string match "" $gPB(Session_Log)] {
set gPB(Session_Log) [file nativename "$env(HOME)/pb_session.log"]
}
catch {set fid [open $gPB(Session_Log) w+]}
if { $fid != "" } \
{
set time_string [clock format [clock seconds] -format "%c %Z"]
puts $fid "\#==============================================================================="
puts $fid "\# Post Builder Session Log File created by $env(USERNAME)"
puts $fid "\# on $time_string"
puts $fid "\#==============================================================================="
puts $fid " "
puts $fid "\#---------------"
puts $fid "\# Backup Method"
puts $fid "\#---------------"
puts $fid "set\ gPB(backup_method) \"$gPB(backup_method)\""
puts $fid " "
puts $fid "\#---------------------------------------------"
puts $fid "\# Switches for Custom Commands Validity Check"
puts $fid "\#---------------------------------------------"
puts $fid "set\ gPB(check_cc_syntax_error)    \"$gPB(check_cc_syntax_error)\""
puts $fid "set\ gPB(check_cc_unknown_command) \"$gPB(check_cc_unknown_command)\""
puts $fid "set\ gPB(check_cc_unknown_block)   \"$gPB(check_cc_unknown_block)\""
puts $fid "set\ gPB(check_cc_unknown_address) \"$gPB(check_cc_unknown_address)\""
puts $fid "set\ gPB(check_cc_unknown_format)  \"$gPB(check_cc_unknown_format)\""
puts $fid " "
puts $fid "\#--------------------------------------------"
puts $fid "\# Custom Commands Import/Export destinations"
puts $fid "\#--------------------------------------------"
if [info exists gPB(custom_command_file_import)] {
set f [join [split $gPB(custom_command_file_import) "\\"] "/"]
puts $fid "set\ gPB(custom_command_file_import) \"$f\""
}
if [info exists gPB(custom_command_file_export)] {
set f [join [split $gPB(custom_command_file_export) "\\"] "/"]
puts $fid "set\ gPB(custom_command_file_export) \"$f\""
}
if { [info exists gPB(open_files_list)]  &&  [llength $gPB(open_files_list)] } \
{
puts $fid " "
puts $fid "\#---------------"
puts $fid "\# Visited Posts"
puts $fid "\#---------------"
puts $fid "set\ gPB(open_files_list) \{ \\"
foreach f $gPB(open_files_list) {
puts $fid "                          \{$f\} \\"
}
puts $fid "                         \}"
}
if {$::tix_version == "8.4"} {
puts $fid " "
puts $fid "\#---------------"
puts $fid "\# Language"
puts $fid "\#---------------"
puts $fid "set env(PRE_LANG) [::msgcat::mclocale]"
}
if 0 {
puts $fid " "
puts $fid "\#---------------"
puts $fid "\# UDE Editor"
puts $fid "\#---------------"
global tcl_platform
if { [string match "windows" $tcl_platform(platform)] } {}
if 1 {
puts $fid "set gPB(PB_UDE_ENABLED) $::env(PB_UDE_ENABLED)"
} else {
if [info exists gPB(PB_UDE_ENABLED)] {
puts $fid "set gPB(PB_UDE_ENABLED) $gPB(PB_UDE_ENABLED)"
} else {
puts $fid "set gPB(PB_UDE_ENABLED) $::env(PB_UDE_ENABLED)"
}
}
}
close $fid
} else \
{
tk_messageBox -parent [UI_PB_com_AskActiveWindow] -type ok -icon warning \
-message "$gPB(msg,file_perm) \n $gPB(Session_Log)"
return
}
}
proc UI_PB_save_a_post { args } {
global gPB
if {$gPB(session) != "NEW" && $args != "yes"} {
UI_PB_select_license_for_post
}
UI_PB_DisplayProgress save
set gPB(post_in_progress) 1
if ![info exists gPB(auto_qc)] {
after 100 "UI_PB_DestroyProgress"
}
if 0 {
PB_int_ReadPostOutputFiles cur_dir gpb_pui_file gpb_def_file \
gpb_tcl_file
if { [file exists "$cur_dir/$gpb_pui_file"] || \
[file exists "$cur_dir/$gpb_def_file"] || \
[file exists "$cur_dir/$gpb_tcl_file"] }  \
{
set ans [tk_messageBox -parent [UI_PB_com_AskActiveWindow] -type okcancel -icon warning \
-message "$gPB(msg,file_exist)"]
if { $ans == "cancel" } \
{
return
}
}
}
if { ![info exists gPB(CONFIRM_WRITE_PERMISSION)] } {
set gPB(CONFIRM_WRITE_PERMISSION) 1
}
if $gPB(CONFIRM_WRITE_PERMISSION) {
if { ![__CheckFilePermissions] } {
return
}
}
set check_cc_syntax  $gPB(check_cc_syntax_error)
if { [info exists gPB(FORCE_SYNTAX_CHECK)] && $gPB(FORCE_SYNTAX_CHECK) } {
set gPB(check_cc_syntax_error) 1
}
set ret_flag 0
set ret_flag [UI_PB_UpdateCurrentBookPageAttr gPB(book)]
if { $ret_flag != 0 } {
set gPB(check_cc_syntax_error) $check_cc_syntax
if [info exists gPB(post_in_progress)] {
unset gPB(post_in_progress)
UI_PB_DestroyProgress
}
return
}
global post_object
Post::GetObjList $post_object command cmd_obj_list
set err_msg ""
set validate_on_save 1
if { $validate_on_save == 0 } {
if [info exists cmd_obj_list] { unset cmd_obj_list }
}
global mom_sys_arr
if { [info exists mom_sys_arr(Output_VNC)] && $mom_sys_arr(Output_VNC) } {
uplevel #0 {
PB_int_RecreateVNCCommand
}
set gPB(non_overite_mom_sim) 1
}
set gPB(cmd_obj_cleanup) 0
PB_proc_SnapShotCmdObjs
if [info exists cmd_obj_list] {
set Post::($post_object,unk_cmd_list) [list]
set Post::($post_object,unk_blk_list) [list]
set Post::($post_object,unk_add_list) [list]
set Post::($post_object,unk_fmt_list) [list]
set unk_cmd_list [list]
set unk_blk_list [list]
set unk_add_list [list]
set unk_fmt_list [list]
foreach cc $cmd_obj_list {
if 0 {
set msg ""
set msg [PB_file_ValidateDefElemsInCommand $cc]
if { $msg != "" } {
if { $err_msg == "" } {
append err_msg "\n$msg"
} else {
append err_msg "\n\n\n$msg"
}
}
}
command::readvalue $cc attr
set msg ""
set proc_state [UI_PB_cmd_ValidateCmdLineOK_ret_msg $cc $attr(1) msg "saving_post"]
if { $proc_state <= 0 && $msg != "" } {
if { $err_msg == "" } {
append err_msg "\n$msg"
} else {
append err_msg "\n\n\n$msg"
}
}
if { ![info exists worst_state] } {
set worst_state $proc_state
} elseif { $proc_state == 0  &&  $worst_state != 0 } {
set worst_state 0
}
set unk_cmd_list [lmerge $unk_cmd_list $Post::($post_object,unk_cmd_list)]
set unk_blk_list [lmerge $unk_blk_list $Post::($post_object,unk_blk_list)]
set unk_add_list [lmerge $unk_add_list $Post::($post_object,unk_add_list)]
set unk_fmt_list [lmerge $unk_fmt_list $Post::($post_object,unk_fmt_list)]
}
}
unset gPB(cmd_obj_cleanup)
PB_proc_CleanUpCmdObjs
if { $err_msg != "" } {
UI_PB_debug_DisplayMsg $err_msg no_debug
if { [info exists gPB(auto_qc)] && $gPB(auto_qc) } {
if [info exists gPB(post_in_progress)] {
unset gPB(post_in_progress)
UI_PB_DestroyProgress
}
return [ error $err_msg ]
}
if { $worst_state == 0 } { ;# Error
if [info exists gPB(post_in_progress)] {
unset gPB(post_in_progress)
UI_PB_DestroyProgress
}
set choice [tk_messageBox \
-parent [UI_PB_com_AskActiveWindow] -icon error \
-message "$err_msg \n\n\n\
You must fix all syntax errors before saving this Post!"]
set gPB(check_cc_syntax_error) $check_cc_syntax
if 0 {
set book $gPB(book)
if { $Book::($book,current_tab) == 1 } { ;# Program & Tool Path
set page_obj [lindex $Book::($book,page_obj_list) 1]
if [info exists Page::($page_obj,book_obj)] {
set page_book $Page::($page_obj,book_obj)
if { $Book::($page_book,current_tab) == 5 } { ;# Custom Commands
set page_obj [lindex $Book::($page_book,page_obj_list) 5]
$Page::($page_obj,text_widget) config -state normal
}
}
}
}
return
} else { ;# Warning
set choice [tk_messageBox \
-parent [UI_PB_com_AskActiveWindow] -type yesno -icon question \
-message "$err_msg \n\n$gPB(cust_cmd,save_post,msg)"]
if [string match "yes" $choice] {
set Post::($post_object,unk_cmd_list) $unk_cmd_list
set Post::($post_object,unk_blk_list) $unk_blk_list
set Post::($post_object,unk_add_list) $unk_add_list
set Post::($post_object,unk_fmt_list) $unk_fmt_list
PB_file_AssumeUnknownCommandsInProc
PB_file_AssumeUnknownDefElemsInProc
} else {
set gPB(check_cc_syntax_error) $check_cc_syntax
if [info exists gPB(post_in_progress)] {
unset gPB(post_in_progress)
UI_PB_DestroyProgress
}
return
}
}
}
global env
if { ![info exists gPB(post_history)] } {
set gPB(post_history) ""
}
set time_string [clock format [clock seconds] -format "%c %Z"]
if [string match "NEW" $gPB(session)] {
lappend gPB(post_history) "Created with $gPB(Postbuilder_Release)$gPB(Postbuilder_Version_Phase)\
on $time_string by $env(USERNAME)."
} else {
lappend gPB(post_history) "Saved with $gPB(Postbuilder_Release)$gPB(Postbuilder_Version_Phase)\
on $time_string by $env(USERNAME)."
}
if [info exists gPB(post_history_list_win)] {
$gPB(post_history_list_win) delete 0 end
set i 0
foreach h $gPB(post_history) {
$gPB(post_history_list_win) insert end "$i - $h"
incr i
}
$gPB(post_history_list_win) see 0
}
scan [$gPB(post_description_text_win) index end] %d numlines
set desc ""
for {set i 1} {$i < $numlines} {incr i} \
{
$gPB(post_description_text_win) mark set last $i.0
set line_text [$gPB(post_description_text_win) get last "last lineend"]
lappend desc $line_text
}
set gPB(post_description) $desc
set gPB(post_description_default) $desc
PB_CreatePostFiles
set title "$gPB(Postbuilder_Release)"
set license ""
if {[info exists ::LicInfo(to_encrypt)] && $::LicInfo(to_encrypt) == 1} {
set license [lindex $::LicInfo(license_title) 0]
}
if [string length $license] {
set title "$gPB(Postbuilder_Release) - License : $license"
} else {
if { $gPB(PB_LICENSE) == "UG_POST_AUTHOR"} {
if { $::disable_internal_user_lc } {
set title "$gPB(Postbuilder_Release)"
} else {
set title "$gPB(Postbuilder_Release) - License Control"
}
}
}
__ChangeTopWinTitle $title
UI_PB_com_SetWindowTitle
set gPB(session) EDIT
set gPB(check_cc_syntax_error) $check_cc_syntax
if [info exists gPB(master_pid)] {
set post_name "$Post::($post_object,output_dir)/$Post::($post_object,out_pui_file)"
comm::comm send -async $gPB(master_pid) \
[list UI_PB_com_UpdateWindowsMenu [comm::comm self] $post_name update]
}
if [info exists gPB(post_in_progress)] {
unset gPB(post_in_progress)
UI_PB_DestroyProgress
}
}
proc __ChangeTopWinTitle {title} {
global gPB
if [info exists gPB(master_pid)] {
comm::comm send -async $gPB(master_pid) [list wm title $gPB(top_window) $title]
} else {
wm title $gPB(top_window) $title
}
}
proc __AddWritePermission { file args} {
global tcl_platform
if [string match "windows" $tcl_platform(platform)] {
if [catch { file attributes "$file" -readonly 0 }] {
return 0
} else {
UI_PB_debug_ForceMsg "$file - removed readonly flag"
return 1
}
} else {
set perm [file attributes "$file" -permissions]
set idx [expr [string length $perm] - 3]
set lead [string range $perm 0 [expr $idx - 1]]
set perm [expr [string range $perm $idx end] + 200]
if [catch { file attributes "$file" -permissions $lead$perm }] {
return 0
} else {
UI_PB_debug_ForceMsg "$file - added write permission"
return 1
}
}
}
proc __RemoveWritePermission { file args} {
global tcl_platform
if [string match "windows" $tcl_platform(platform)] {
file attributes "$file" -readonly 1
} else {
set perm [file attributes "$file" -permissions]
set idx [expr [string length $perm] - 3]
set lead [string range $perm 0 [expr $idx - 1]]
set perm [expr [string range $perm $idx end] - 200]
file attributes "$file" -permissions $lead$perm
}
}
proc __CheckFilePermissions {args} {
global gPB env tcl_platform
set err_msg ""
set enable_write_permission 1
set deny_dir -1
set deny_pui -1
set deny_tcl -1
set deny_def -1
set deny_vnc -1
PB_int_ReadPostOutputFiles cur_dir gpb_pui_file gpb_def_file gpb_tcl_file
if { [file exists "$cur_dir"] && ![file writable "$cur_dir"] } {
set err_msg "$err_msg\n  [file nativename $cur_dir] directory"
if { ![__AddWritePermission "$cur_dir"] } {
set enable_write_permission 0
set deny_dir 1
} else {
set deny_dir 0
}
}
if { [file exists "$cur_dir/$gpb_pui_file"] && \
![file writable "$cur_dir/$gpb_pui_file"] } {
set err_msg "$err_msg\n  [file nativename $cur_dir/$gpb_pui_file]"
if { ![__AddWritePermission "$cur_dir/$gpb_pui_file"] } {
set enable_write_permission 0
set deny_pui 1
} else {
set deny_pui 0
}
}
if { [file exists "$cur_dir/$gpb_tcl_file"] && \
![file writable "$cur_dir/$gpb_tcl_file"] } {
set err_msg "$err_msg\n  [file nativename $cur_dir/$gpb_tcl_file]"
if { ![__AddWritePermission "$cur_dir/$gpb_tcl_file"] } {
set enable_write_permission 0
set deny_tcl 1
} else {
set deny_tcl 0
}
}
if { [file exists "$cur_dir/$gpb_def_file"] && \
![file writable "$cur_dir/$gpb_def_file"] } {
set err_msg "$err_msg\n  [file nativename $cur_dir/$gpb_def_file]"
if { ![__AddWritePermission "$cur_dir/$gpb_def_file"] } {
set enable_write_permission 0
set deny_def 1
} else {
set deny_def 0
}
}
set vnc_file [file rootname $gpb_tcl_file]_vnc.tcl
if { [file exists "$cur_dir/$vnc_file"] && \
![file writable "$cur_dir/$vnc_file"] } {
set err_msg "$err_msg\n  [file nativename $cur_dir/$vnc_file]"
if { ![__AddWritePermission "$cur_dir/$vnc_file"] } {
set enable_write_permission 0
set deny_vnc 1
} else {
set deny_vnc 0
}
}
set restore_file_protection 0
if { ![string match "" $err_msg] } {
if { !$enable_write_permission} {
tk_messageBox -parent [UI_PB_com_AskActiveWindow] -icon error \
-message "$gPB(msg,file_perm) \n$err_msg"
set restore_file_protection 1
} else {
set ans [tk_messageBox -parent [UI_PB_com_AskActiveWindow] \
-type yesno -icon question \
-message "$gPB(msg,file_perm) \n$err_msg\n\n\n\
$gPB(cust_cmd,save_post,msg)"]
if [string match "no" $ans] {
set restore_file_protection 1
} else {
UI_PB_DisplayProgress save
set gPB(post_in_progress) 1
after 100 "UI_PB_DestroyProgress"
}
if $restore_file_protection {
if { $deny_dir == 0 } {
__RemoveWritePermission "$cur_dir"
}
if { $deny_pui == 0 } {
__RemoveWritePermission "$cur_dir/$gpb_pui_file"
}
if { $deny_tcl == 0 } {
__RemoveWritePermission "$cur_dir/$gpb_tcl_file"
}
if { $deny_def == 0 } {
__RemoveWritePermission "$cur_dir/$gpb_def_file"
}
if { $deny_vnc == 0 } {
__RemoveWritePermission "$cur_dir/$vnc_file"
}
if [info exists gPB(post_in_progress)] {
unset gPB(post_in_progress)
}
return 0
}
}
}
return 1
}
proc UI_PB_ClosePost { args } {
global env
if {[info exists env(MULTI_INTERP)] && $env(MULTI_INTERP) == 1} {
global gPB
if [info exists gPB(master_pid)] {
UI_PB_ClosePost_mod $args
} else {
global PID
comm::comm send -async $PID(activated) [list UI_PB_ClosePost_mod $args]
}
} else {
UI_PB_ClosePost_mod $args
}
}
proc UI_PB_ClosePost_mod { args } {
global gPB
if [info exists gPB(save_as_now)] { return }
global mom_sys_arr mom_kin_var mom_sim_arr
if [info exists gPB(master_pid)] {
set prev_mssg [comm::comm send $gPB(master_pid) [list set gPB(menu_bar_status)]]
} else {
set prev_mssg $gPB(menu_bar_status)
}
if { $gPB(use_info) } \
{
return [UI_PB_chelp_DisplayMenuItemCsh $gPB(file_menu)]
}
set choice "cancel"
if { [info exists gPB(PB_LICENSE)] } {
if { $gPB(PB_LICENSE) != "UG_POST_NO_LICENSE" } {
UI_PB_com_SetStatusbar "$gPB(main,save,Status)"
set ::gPB(messagebox_flag) 1 ;#<08-15-05 peter>---fix the messageBox reappear error-------
set choice [tk_messageBox -parent [UI_PB_com_AskActiveWindow] -type yesnocancel \
-icon question -message "$gPB(msg,save)"]
PB_com_unset_var ::gPB(messagebox_flag)
} else {
set choice "no"
}
} else {
UI_PB_com_SetStatusbar "$gPB(main,save,Status)"
set choice [tk_messageBox -parent [UI_PB_com_AskActiveWindow] -type yesnocancel \
-icon question -message "$gPB(msg,save)"]
}
if { $choice == "yes" } \
{
if { [UI_PB_com_AskActiveWindow] != "$gPB(main_window)" } {
tk_messageBox -parent [UI_PB_com_AskActiveWindow] -type ok \
-icon error -message "$gPB(msg,sub_dialog_open)"
set choice "cancel"
}
}
if { $choice == "yes" } \
{
UI_PB_SavePost
UI_PB_com_SetStatusbar "$prev_mssg"
if { $gPB(session) != "EDIT" } \
{
return ""
}
} elseif { $choice == "no" } \
{
UI_PB_com_SetStatusbar "$gPB(main,default,Status)"
}
if { $choice == "yes"  ||  $choice == "no" } \
{
if [info exists gPB(master_pid)] {
comm::comm send $gPB(master_pid) [list set ::env(PB_UDE_ENABLED) 2]
comm::comm send $gPB(master_pid) [list set ::ude_enable 0]
} else {
set ::env(PB_UDE_ENABLED) 2
set ::ude_enable 0
}
if {[info exists gPB(master_pid)] && $choice != "cancel"} {
comm::comm send $gPB(master_pid) \
[list UI_PB_com_UpdateWindowsMenu [comm::comm self] NULL delete]
}
UI_PB_com_DeleteTopLevelWindows
UI_PB_AddVisitedPosts
if 0 {
if [array exists mom_sys_arr] { unset mom_sys_arr }
if [array exists mom_kin_var] { unset mom_kin_var }
} else {
if [array exists mom_sys_arr] { PB_com_unset_var mom_sys_arr }
if [array exists mom_kin_var] { PB_com_unset_var mom_kin_var }
if [array exists mom_sim_arr] { PB_com_unset_var mom_sim_arr }
global vnc_desc_arr
if [array exists vnc_desc_arr] { PB_com_unset_var vnc_desc_arr }
global rest_mom_sys_arr rest_mom_kin_var rest_mom_sim_arr
if [array exists rest_mom_sys_arr] { PB_com_unset_var rest_mom_sys_arr}
if [array exists rest_mom_kin_var] { PB_com_unset_var rest_mom_kin_var}
if [array exists rest_mom_sim_arr] { PB_com_unset_var rest_mom_sim_arr}
}
set n [expr $::stooop::newId + 1]
for { set obj_id 0 } { $obj_id < $n } { incr obj_id } {
PB_com_DeleteObject $obj_id
}
set ::stooop::newId 0
unset ::stooop::fullClass
if [catch {UI_PB_CleanUpRuntimeObjs} res] {
__Pause $res
}
if [info exists gPB(ugpost_base_sourced)] {
unset gPB(ugpost_base_sourced)
}
if [info exists gPB(post_description)] {
set gPB(post_description) [list]
}
if [info exists gPB(post_controller)] {
set gPB(post_controller) [list]
}
if [info exists gPB(post_history)] {
set gPB(post_history) [list]
}
__ClearLicRelatedInfo
}
if {$choice == "yes" || $choice == "no"} {
if [info exists ::post_object] {unset ::post_object}
}
if {[info exists gPB(master_pid)] && $choice != "cancel"} {
comm::comm send -async $gPB(master_pid) \
[list UI_PB_com_UpdateWindowsMenu [comm::comm self] NULL delete]
if [string match windows $::tcl_platform(platform)] {
exec taskkill /f /pid [pid]
} else {
exec kill [pid]
}
}
return $choice
}
proc __ClearLicRelatedInfo { } {
global LicInfo gPB
PB_com_unset_var LicInfo
UI_PB_rest_license_option
if { $gPB(PB_LICENSE) == "UG_POST_AUTHOR"} {
set title "$gPB(Postbuilder_Release) - License Control"
} else {
set title "$gPB(Postbuilder_Release)"
}
if { $::disable_internal_user_lc } {
set title "$gPB(Postbuilder_Release)"
}
__ChangeTopWinTitle $title
PB_com_unset_var gPB(start_session)
}
proc __DeletePostWidgets { } {
global gPB
if { $gPB(book) == 0 } {
return
}
if [info exists gPB(tix_grid)] \
{
global addr_app_text
PB_int_AddrSummaryAttr addr_name_list addr_app_text addr_desc_arr
set no_addr [llength $addr_name_list]
for {set count 0} {$count < [expr $no_addr + 1]} {incr count} \
{
$gPB(tix_grid) delete row $count
}
unset gPB(tix_grid)
}
UI_PB_EnableFileOptions
set gPB(book) 0
}
proc UI_PB_DeleteUIObjects { } {
global gPB
set pb_book $gPB(book)
set book_chap $Book::($pb_book,page_obj_list)
foreach chap $book_chap \
{
if { [info exists Page::($chap,book_obj)] } \
{
set book $Page::($chap,book_obj)
set chap_pages $Book::($book,page_obj_list)
foreach page_obj $chap_pages \
{
if [info exists Page::($page_obj,book_obj)] {
set book_lowlevel $Page::($page_obj,book_obj)
set low_pages $Book::($book_lowlevel,page_obj_list)
foreach low_page $low_pages {
PB_com_DeleteObject $low_page
}
}
PB_com_DeleteObject $page_obj
}
}
PB_com_DeleteObject $chap
}
PB_com_DeleteObject $pb_book
}
proc UI_PB_DeleteDataBaseObjs { } {
global post_object
if { ![info exists post_object] } {
return
}
if 0 {
if [info exists Post::($post_object,def_parse_obj)] \
{
PB_com_DeleteObject $Post::($post_object,def_parse_obj)
}
set seq_obj_list $Post::($post_object,seq_obj_list)
foreach seq_obj $seq_obj_list \
{
PB_com_DeleteObject $seq_obj
}
set blk_obj_list $Post::($post_object,blk_obj_list)
foreach blk_obj $blk_obj_list \
{
PB_com_DeleteObject $blk_obj
}
set add_obj_list $Post::($post_object,add_obj_list)
foreach add_obj $add_obj_list \
{
PB_com_DeleteObject $add_obj
}
set fmt_obj_list $Post::($post_object,fmt_obj_list)
foreach fmt_obj $fmt_obj_list \
{
PB_com_DeleteObject $fmt_obj
}
}
PB_com_DeleteObject $post_object
if 0 {
if [catch { delete $post_object } res] {
tk_messageBox -parent [UI_PB_com_AskActiveWindow] \
-type ok -icon error \
-message "Post objects are not cleaned up properly!\n $res"
}
}
if [info exists post_object] { unset post_object }
}
proc UI_PB_main_window {args} {
global gPB
global paOption
if { [info exists gPB(main_window)] } {
unset gPB(main_window)
}
if [info exists gPB(master_pid)] {
set twx [comm::comm send $gPB(master_pid) [list winfo rootx $gPB(top_window)]]
set twy [comm::comm send $gPB(master_pid) [list winfo rooty $gPB(top_window)]]
} else {
set twx [winfo rootx $gPB(top_window)]
set twy [winfo rooty $gPB(top_window)]
}
set xc [expr $twx - $gPB(WIN_X)]
set yc [expr $twy + $gPB(TOP_WIN_HI) + $gPB(WIN_X)]
set mw [toplevel $gPB(top_window).main]
UI_PB_com_CreateTransientWindow $mw "Post Processor" "1000x600+$xc+$yc" \
"" "" "UI_PB_ClosePost" "__DeletePostWidgets" 0
set gPB(main_window) $mw
UI_PB_com_SetWindowTitle
if 0 {
set sw [tixScrolledWindow $mw.sw -scrollbar auto -height 600]
[$sw subwidget hsb] config -troughcolor skyBlue \
-width $paOption(trough_wd)
[$sw subwidget vsb] config -troughcolor skyBlue \
-width $paOption(trough_wd)
pack $sw -side top -expand yes -fill both
set win [$sw subwidget window]
set w [tixNoteBook $win.nb -ipadx 3 -ipady 3]
}
set w [tixNoteBook $mw.nb -ipadx 3 -ipady 3]
[$w subwidget nbframe] config -backpagecolor $paOption(app_bg) \
-tabpadx 0 -tabpady 0
bind [$w subwidget nbframe] <Button-1> "UI_PB_NoteBookTabBinding $w %x %y"
set gPB(book) [new Book w]
Book::CreatePage $gPB(book) mac "$gPB(machine,tab,Label)" pb_machine \
UI_PB_MachineTool UI_PB_MachToolTab
Book::CreatePage $gPB(book) pro "$gPB(progtpth,tab,Label)" pb_prog \
UI_PB_ProgTpth UI_PB_ProgTpthTab
Book::CreatePage $gPB(book) def "$gPB(nc_data,tab,Label)" pb_mcd \
UI_PB_Def UI_PB_DefTab
Book::CreatePage $gPB(book) lis "$gPB(output,tab,Label)" pb_listing \
UI_PB_List UI_PB_ListTab
if 0 {
if { ![info exists gPB(HIDE_POST_PREVIEW_PAGE)] } {
set gPB(HIDE_POST_PREVIEW_PAGE) 0
}
if { $gPB(HIDE_POST_PREVIEW_PAGE) == 0 } {
Book::CreatePage $gPB(book) pre "$gPB(preview,tab,Label)" pb_output \
UI_PB_Preview UI_PB_PreviewTab
}
}
Book::CreatePage $gPB(book) isv "$gPB(isv,tab,label)" pb_vnc \
UI_PB_vnc_AddRevPostPage UI_PB_vnc_RevPostTab
set Book::($gPB(book),x_def_tab_img) 0
set Book::($gPB(book),current_tab) -1
pack $w -expand yes -fill both
update idletasks
set xxc [winfo rootx $mw]
set yyc [winfo rooty $mw]
set gPB(WIN_X) [expr $xxc - $xc]
set gPB(WIN_Y) [expr $yyc - $yc]
set gPB(win_max_width)  [expr $gPB(screen_width)  - $gPB(WIN_X) - $gPB(WIN_X)]
set gPB(win_max_height) [expr $gPB(screen_height) - $gPB(WIN_Y) - $gPB(WIN_X)]
UI_PB_com_PositionWindow $mw
global machType
global LicInfo
if { ([info exists LicInfo(user_right_limit)] && $LicInfo(user_right_limit) == "YES") ||\
[string match "Wire EDM" $machType] } {
set book_id $Book::($gPB(book),book_id)
$book_id pageconfigure isv -state disabled
set book_image [$book_id pagecget isv -image]
image delete $book_image
set isv_image [image create compound -window [$book_id subwidget nbframe] \
-pady 0 -background $paOption(focus) -showbackground 0]
set image_id [tix getimage pb_vnc]
$isv_image add image -image $image_id
$isv_image add space -width 5
$isv_image add text -text "$gPB(isv,tab,label)" -fg gray
$book_id pageconfigure isv -image $isv_image
}
if [info exists gPB(master_pid)] {
if [string match "windows" $::tcl_platform(platform)] {
update
trst [wm title $mw]
}
wm deiconify $mw
}
}
proc UI_PB_NoteBookTabBinding { book_id x y } {
global machTree
if { [info exists machTree] && ([UI_PB__MachToolValidation] == "bad") } {
return
} else {
tixNoteBook:MouseDown $book_id $x $y
}
}
proc UI_PB_MachToolTab { book_id page_img book_obj } {
CB_nb_def $book_id $page_img $book_obj
if { [UI_PB_ValidatePrevBookData book_obj] } \
{
return
}
UI_PB_DeleteBookAttr book_obj
set Book::($book_obj,current_tab) 0
UI_PB_UpdateBookAttr book_obj
}
proc UI_PB_ProgTpthTab { book_id page_img book_obj } {
CB_nb_def $book_id $page_img $book_obj
if { [UI_PB_ValidatePrevBookData book_obj] } \
{
return
}
UI_PB_DeleteBookAttr book_obj
set Book::($book_obj,current_tab) 1
UI_PB_UpdateBookAttr book_obj
}
proc UI_PB_DefTab { book_id page_img book_obj } {
CB_nb_def $book_id $page_img $book_obj
if { [UI_PB_ValidatePrevBookData book_obj] } \
{
return
}
UI_PB_DeleteBookAttr book_obj
set Book::($book_obj,current_tab) 2
UI_PB_UpdateBookAttr book_obj
}
proc UI_PB_ListTab { book_id page_img book_obj } {
CB_nb_def $book_id $page_img $book_obj
if { [UI_PB_ValidatePrevBookData book_obj] } \
{
return
}
UI_PB_DeleteBookAttr book_obj
set Book::($book_obj,current_tab) 3
UI_PB_UpdateBookAttr book_obj
}
proc UI_PB_vnc_RevPostTab { book_id page_img book_obj} {
CB_nb_def $book_id $page_img $book_obj
if { [UI_PB_ValidatePrevBookData book_obj] } \
{
return
}
UI_PB_DeleteBookAttr book_obj
set Book::($book_obj,current_tab) 4
UI_PB_UpdateBookAttr book_obj
}
proc x_UI_PB_PreviewTab { book_id page_img book_obj } {
CB_nb_def $book_id $page_img $book_obj
if { [UI_PB_ValidatePrevBookData book_obj] } \
{
return
}
UI_PB_DeleteBookAttr book_obj
set Book::($book_obj,current_tab) 4
UI_PB_UpdateBookAttr book_obj
}
proc UI_PB_AdvisorTab { book_id page_img book_obj } {
CB_nb_def $book_id $page_img $book_obj
if { [UI_PB_ValidatePrevBookData book_obj] } \
{
return
}
UI_PB_DeleteBookAttr book_obj
set Book::($book_obj,current_tab) 5
UI_PB_UpdateBookAttr book_obj
}
proc UI_PB__MachToolValidation {} {
global machTree axisoption
if { [info exists machTree] } {
switch -- $axisoption {
"3" {
set axis_type 3
}
"4H" -
"4T" {
set axis_type 4
}
"5TT" -
"5HH" -
"5HT" {
set axis_type 5
}
}
return [ValidateMachObjAttr $machTree $axis_type]
}
}
proc UI_PB_ValidateCommandPage { cmd_page CC_ERR_MSG} {
upvar $CC_ERR_MSG cc_err_msg
global gPB
set raise_page 0
set page_name $Page::($cmd_page,page_name)
if {[string match  "cod" $page_name]} {
set reg 1
} else {
set reg 0
}
if { [info exists Page::($cmd_page,active_cmd_obj)] } \
{
global pb_cmd_procname
set cmd_obj $Page::($cmd_page,active_cmd_obj)
if { $reg == 1} {
set cur_cmd_name "PB_CMD_vnc__${pb_cmd_procname}"
} else {
set cur_cmd_name "PB_CMD_${pb_cmd_procname}"
}
set cust_page_flag [PB_int_CheckForCmdBlk cmd_obj \
cur_cmd_name]
if { $cust_page_flag } \
{
set raise_page 1
}
set cc_res 1
if { ![info exists gPB(IGNORE_CC_MAIN_TAB)] } \
{
set gPB(IGNORE_CC_MAIN_TAB) 0
}
if { $gPB(IGNORE_CC_MAIN_TAB) == 0 } \
{
set cc_res [ UI_PB_cmd_SaveCmdProc_ret_msg $cmd_page cc_err_msg ]
} else \
{
set gPB(IGNORE_CC_MAIN_TAB) 0
}
if { $cc_res != 1 } \
{
set raise_page 1
}
}
if { !$raise_page } \
{
set Page::($cmd_page,selected_index) -1
}
return $raise_page
}
proc UI_PB_CommandPageRaiseSolution { page_obj cc_res cc_err_msg } {
global gPB
set page_name $Page::($page_obj,page_name)
if {[string match "cod" $page_name]} {
set reg 1
} else {
set reg 0
}
if { $cc_res == 0 } \
{
tk_messageBox -parent [UI_PB_com_AskActiveWindow] \
-type ok -icon error \
-title "$gPB(cust_cmd,error,title)" \
-message "$cc_err_msg"
} elseif { $cc_res == -1 } \
{
set res [tk_messageBox -parent [UI_PB_com_AskActiveWindow] \
-type okcancel -icon warning \
-title "$gPB(cust_cmd,error,title)" \
-message "$cc_err_msg" ]
set gPB(IGNORE_CC_MAIN_TAB) 0
if { $res == "ok" } \
{
PB_file_AssumeUnknownCommandsInProc
PB_file_AssumeUnknownDefElemsInProc
if { $reg == 1} {
set cmd_page [lindex $Book::($page_book_obj,page_obj_list) 1]
} else {
set cmd_page [lindex $Book::($page_book_obj,page_obj_list) 5]
}
if { [info exists Page::($cmd_page,active_cmd_obj)] } \
{
set cmd_obj $Page::($cmd_page,active_cmd_obj)
UI_PB_cmd_GetProcFromTextWin $cmd_page proc_text
set command::($cmd_obj,proc) $proc_text
}
$book_id pageconfigure $prev_page_name -raisecmd "$cmd_proc"
set prev_page_name $cur_page_name
set cmd_proc [$book_id pagecget $prev_page_name -raisecmd]
set Book::($book_obj,x_def_tab_img) $prev_page_img
set prev_page_img $cur_page_img
$book_id pageconfigure $prev_page_name \
-raisecmd "CB_nb_def $book_id $prev_page_img $book_obj"
$book_id raise $prev_page_name
$book_id pageconfigure $prev_page_name -raisecmd "$cmd_proc"
set gPB(IGNORE_CC_MAIN_TAB) 1
set Page::($cmd_page,selected_index) -1
return 0
}
}
}
proc UI_PB_ValidatePrevBookData { BOOK_OBJ } {
upvar $BOOK_OBJ book_obj
global gPB
set raise_page 0
set fmt_page_flag 0
set oth_page_flag 0
set blk_page_flag 0
set add_page_flag 0
set current_tab $Book::($book_obj,current_tab)
set page_obj [lindex $Book::($book_obj,page_obj_list) $current_tab]
switch -exact -- $Book::($book_obj,current_tab) \
{
0 { ;# Machine Tool
global mom_kin_var
PB_int_RetAddressObjList addr_obj_list
set addr_name "fourth_axis"
PB_com_RetObjFrmName addr_name addr_obj_list addr_obj
if { $addr_obj > 0 } {
if [info exists mom_kin_var(\$mom_kin_4th_axis_leader)] {
address::readvalue $addr_obj addr_obj_attr
set addr_obj_attr(8) $mom_kin_var(\$mom_kin_4th_axis_leader)
address::setvalue $addr_obj addr_obj_attr
}
}
set addr_name "fifth_axis"
PB_com_RetObjFrmName addr_name addr_obj_list addr_obj
if { $addr_obj > 0 } {
if [info exists mom_kin_var(\$mom_kin_5th_axis_leader)] {
address::readvalue $addr_obj addr_obj_attr
set addr_obj_attr(8) $mom_kin_var(\$mom_kin_5th_axis_leader)
address::setvalue $addr_obj addr_obj_attr
}
}
global mom_sys_arr
if { [info exists mom_sys_arr(\$mom_sys_mill_turn_type)] && \
[string match "SIMPLE_MILL_TURN" $mom_sys_arr(\$mom_sys_mill_turn_type)] } {
if [string match "" $mom_sys_arr(\$mom_sys_lathe_postname)] {
set raise_page 1
}
}
}
1 { ;# Program & Tool Path
set gPB(IGNORE_CC_MAIN_TAB) 0
if [info exists Page::($page_obj,book_obj)] \
{
set page_book_obj $Page::($page_obj,book_obj)
switch -- $Book::($page_book_obj,current_tab) \
{
3 { ;# Addresses Summary page
set addrsum_err [UI_PB_ads_ValidateAllFormats]
if $addrsum_err { set raise_page 1 }
set max [UI_PB_ads_ValidateMaxN]
if $max {
set raise_page 1
}
}
5 { ;# Custom Command page
set cmd_page [lindex $Book::($page_book_obj,page_obj_list) 5]
set cc_err_msg ""
set raise_page [UI_PB_ValidateCommandPage $cmd_page cc_err_msg]
}
6 { ;#<12-04-02 gsl> Linked Posts page
set lnkp_page [lindex $Book::($page_book_obj,page_obj_list) 6]
set raise_page [UI_PB_progtpth_ValidateLinkedPostPage $lnkp_page]
if { $raise_page == 0 } {
UI_PB_lnk_SaveData $lnkp_page
}
}
}
}
}
2 { ;# N/C Data Definitions
if {[info exists Page::($page_obj,book_obj)]} \
{
set page_book_obj $Page::($page_obj,book_obj)
switch -- $Book::($page_book_obj,current_tab) \
{
0 { ;# Blocks
set blk_page [lindex $Book::($page_book_obj,page_obj_list) 0]
if { [info exists Page::($blk_page,active_blk_obj)] } \
{
global gPB_block_name
set block_obj $Page::($blk_page,active_blk_obj)
if 0 {
set ret_code [UI_PB_blk_CheckBlockName gPB_block_name block_obj]
if { $block::($block_obj,active_blk_elem_list) == "" } { ;# Empty block
set raise_page 1
set blk_page_flag 3
} elseif { $ret_code } { ;# New block created
set raise_page 1
set blk_page_flag $ret_code
}
}
if { $block::($block_obj,active_blk_elem_list) == "" } { ;# Empty block
set raise_page 1
set blk_page_flag 3
}
}
}
1 { ;# Addresses
set addr_page [lindex $Book::($page_book_obj,page_obj_list) 1]
if { [info exists Page::($addr_page,act_addr_obj)] } \
{
global gPB_address_name
set add_obj $Page::($addr_page,act_addr_obj)
set add_page_flag [UI_PB_addr_CheckAddressName gPB_address_name add_obj]
if [string match "N" $gPB_address_name] {
global ADDRESSOBJATTR
global mom_sys_arr
set tmp $mom_sys_arr(seqnum_max)
set mom_sys_arr(seqnum_max) $ADDRESSOBJATTR(4)
set fmt $ADDRESSOBJATTR(1)
set max [UI_PB_ads_ExceedMaxSeqNum $fmt]
if $max {
set add_page_flag 4
}
set mom_sys_arr(seqnum_max) $tmp
}
if { $add_page_flag } \
{
set raise_page 1
}
}
}
2 { ;# Formats
set fmt_page [lindex $Book::($page_book_obj,page_obj_list) 2]
if { [info exists Page::($fmt_page,act_fmt_obj)] } \
{
global FORMATOBJATTR
global gPB_format_name
set fmt_obj $Page::($fmt_page,act_fmt_obj)
set ret_code [UI_PB_fmt_CheckFormatName gPB_format_name fmt_obj]
if { $ret_code } \
{
set raise_page 1
set fmt_page_flag $ret_code
} elseif { $FORMATOBJATTR(1) == "Numeral" && \
$FORMATOBJATTR(6) == 0 && \
$FORMATOBJATTR(3) == 0 && \
$FORMATOBJATTR(4) == 0 } \
{
set raise_page 1
set fmt_page_flag 3
}
}
}
3 { ;# Other Elements
set max [UI_PB_ads_ExceedMaxSeqNum]
if $max {
set raise_page 1
set oth_page_flag 1
}
UI_PB_ads_ValidateIncludeItems raise_page oth_page_flag 1
}
}
}
}
3 { ;# Output Settings
set page_obj [lindex $Book::($book_obj,page_obj_list) 3]
if [info exists Page::($page_obj,book_obj)] \
{
set page_book_obj $Page::($page_obj,book_obj)
switch -- $Book::($page_book_obj,current_tab) \
{
0 { ;# Listing File
}
1 { ;# Other Control Elements
set raise_page [UI_PB_list_ValidatePrevPageParam page_book_obj]
}
2 { ;# IS&V RevPost
}
}
}
}
4 { ;# Virtual N/C Controller
set gPB(IGNORE_CC_MAIN_TAB) 0
set page_obj [lindex $Book::($book_obj,page_obj_list) 4]
set page_book_obj $Page::($page_obj,book_obj)
switch -- $Book::($page_book_obj,current_tab) {
1 { ;# VNC code page
set cod_page [lindex $Book::($page_book_obj,page_obj_list) 1]
set cc_err_msg ""
set raise_page [UI_PB_ValidateCommandPage $cod_page cc_err_msg]
}
}
}
}
if { $raise_page } \
{
set book_id $Book::($book_obj,book_id)
set cur_page_name [$book_id raised]
set cur_page_img [$book_id pagecget $cur_page_name -image]
set prev_page_name $Page::($page_obj,page_name)
set cmd_proc [$book_id pagecget $prev_page_name -raisecmd]
set prev_page_img [$book_id pagecget $prev_page_name -image]
set Book::($book_obj,x_def_tab_img) $cur_page_img
$book_id pageconfigure $prev_page_name \
-raisecmd "CB_nb_def $book_id $prev_page_img $book_obj"
$book_id raise $prev_page_name
switch -exact -- $Book::($book_obj,current_tab) \
{
0 { ;#<02-03-03 gsl> Machine Tool
tk_messageBox -parent [UI_PB_com_AskActiveWindow] \
-type ok -icon error \
-message "You need to specify a lathe post for this Simple MIll-Turn post."
}
1 { ;# Program & ToolPath
set page_book_obj $Page::($page_obj,book_obj)
switch -- $Book::($page_book_obj,current_tab) \
{
3 { ;#<11-27-01 gsl> Addresses Summary page
if { [info exists addrsum_err] && $addrsum_err } {
UI_PB_ads_DisplayErrorMessage $addrsum_err
} elseif { $max } {
tk_messageBox -parent [UI_PB_com_AskActiveWindow] \
-type ok -icon error \
-message "$gPB(msg,add_max1) N $gPB(msg,add_max2) $max."
}
}
5 {
set page_obj [lindex $Book::($page_book_obj,page_obj_list) 5]
if { ![info exists cc_res] } { set cc_res 1 }
UI_PB_CommandPageRaiseSolution $page_obj $cc_res $cc_err_msg
}
6 { ;#<12-04-02 gsl> Linked Posts page
tk_messageBox -parent [UI_PB_com_AskActiveWindow] \
-type ok -icon error \
-message "Duplicated Head assignment is not permitted."
}
}
}
2 { ;# N/C Data Definitions
set page_book_obj $Page::($page_obj,book_obj)
switch -- $Book::($page_book_obj,current_tab) \
{
0 {
switch -- $blk_page_flag \
{
1 -
2 {
UI_PB_blk_DenyBlockRename $blk_page_flag
}
3 {
tk_messageBox -parent [UI_PB_com_AskActiveWindow] \
-type ok -icon error \
-message "$gPB(msg,min_word)"
}
}
}
1 {
if { $add_page_flag < 4 } {
UI_PB_addr_DenyAddrRename $add_page_flag
} else {
tk_messageBox -parent [UI_PB_com_AskActiveWindow] \
-type ok -icon error \
-message "$gPB(msg,add_max1) N $gPB(msg,add_max2) $max."
}
}
2 {
switch -- $fmt_page_flag \
{
1 -
2 {
UI_PB_fmt_DenyFmtRename $fmt_page_flag
}
3 {
tk_messageBox -parent [UI_PB_com_AskActiveWindow] \
-type ok -icon error \
-message "$gPB(format,data,dec_zero,msg)"
}
}
}
3 {
if {$oth_page_flag == 1} {
tk_messageBox -parent [UI_PB_com_AskActiveWindow] \
-type ok -icon error \
-message "$gPB(msg,seq_num_max) $max."
}
UI_PB_ads_ValidateIncludeItems raise_page oth_page_flag 3
}
}
}
3 { ;# Output Controls
set page_book_obj $Page::($page_obj,book_obj)
UI_PB_list_ErrorPrevPage page_book_obj
}
4 { ;# Virtual N/C Controller
set page_book_obj $Page::($page_obj,book_obj)
set cod_page [lindex $Book::($page_book_obj,page_obj_list) 1]
if { ![info exists cc_res] } { set cc_res 1 }
UI_PB_CommandPageRaiseSolution $cod_page $cc_res $cc_err_msg
}
}
$book_id raise $prev_page_name
$book_id pageconfigure $prev_page_name -raisecmd "$cmd_proc"
switch $cur_page_name \
{
"mac"   { set new_tab 0 }
"pro"   { set new_tab 1 }
"def"   { set new_tab 2 }
"lis"   { set new_tab 3 }
"isv"   { set new_tab 4 }
default { set new_tab 0 }
}
set Book::($book_obj,current_tab) $new_tab
UI_PB_DeleteBookAttr book_obj
set Book::($book_obj,current_tab) $current_tab
}
return $raise_page
}
proc UI_PB_DeleteBookAttr { BOOK_OBJ } {
upvar $BOOK_OBJ book_obj
switch -exact -- $Book::($book_obj,current_tab) \
{
0 { ;# Machine Tool
set page_obj [lindex $Book::($book_obj,page_obj_list) 0]
UI_PB_mach_UpdateMachinePageParams page_obj
}
1 { ;# Program & Tool Path
set page_obj [lindex $Book::($book_obj,page_obj_list) 1]
if {[info exists Page::($page_obj,book_obj)]} \
{
set page_book_obj $Page::($page_obj,book_obj)
UI_PB_progtpth_DeleteTabAtt page_book_obj
}
}
2 { ;# N/C Data Definitions
set page_obj [lindex $Book::($book_obj,page_obj_list) 2]
if {[info exists Page::($page_obj,book_obj)]} \
{
set page_book_obj $Page::($page_obj,book_obj)
UI_PB_Def_UpdatePrevTabElems page_book_obj
}
}
3 { ;# Output Settings
set page_obj [lindex $Book::($book_obj,page_obj_list) 3]
if {[info exists Page::($page_obj,book_obj)]} \
{
set page_book_obj $Page::($page_obj,book_obj)
UI_PB_list_ApplyListObjAttr page_book_obj
}
}
4 { ;# Virtual N/C Controller
set page_obj [lindex $Book::($book_obj,page_obj_list) 4]
if {[info exists Page::($page_obj,book_obj)]} {
set page_book_obj $Page::($page_obj,book_obj)
UI_PB_isv_DeleteTabAttr page_book_obj
}
}
}
}
proc UI_PB_UpdateBookAttr { BOOK_OBJ } {
upvar $BOOK_OBJ book_obj
global gPB
switch -exact -- $Book::($book_obj,current_tab) \
{
0 { ;# Machine Tool
set page_obj [lindex $Book::($book_obj,page_obj_list) 0]
UI_PB_mach_CreateTabAttr $page_obj
UI_PB_com_SetStatusbar "$gPB(machine,Status)"
}
1 { ;# Program & Tool Path
set page_obj [lindex $Book::($book_obj,page_obj_list) 1]
if [info exists Page::($page_obj,book_obj)] \
{
set page_book_obj $Page::($page_obj,book_obj)
UI_PB_progtpth_CreateTabAttr page_book_obj
}
}
2 { ;# N/C Data Definitions
set page_obj [lindex $Book::($book_obj,page_obj_list) 2]
if [info exists Page::($page_obj,book_obj)] \
{
set page_book_obj $Page::($page_obj,book_obj)
UI_PB_Def_CreateTabAttr page_book_obj
}
}
3 { ;# Output Settings
set page_obj [lindex $Book::($book_obj,page_obj_list) 3]
if [info exists Page::($page_obj,book_obj)] \
{
set page_book_obj $Page::($page_obj,book_obj)
UI_PB_list_CreateTabAttr page_book_obj
}
}
4 {;# <03-03-06 pheobe>Virtual N/C Controller
set page_obj [lindex $Book::($book_obj,page_obj_list) 4]
if {[info exists Page::($page_obj,book_obj)]} {
set page_book_obj $Page::($page_obj,book_obj)
UI_PB_isv_CreateTabAttr page_book_obj
UI_PB_isv_SetInitalStatus page_book_obj
}
UI_PB_com_SetStatusbar "$gPB(listing,Status)"
}
5 { ;# Post Advisor
set page_obj [lindex $Book::($book_obj,page_obj_list) 5]
UI_PB_com_SetStatusbar "$gPB(advisor,Status)"
}
}
}
proc UI_PB_cmd_ApplyCuscommand { PAGE_OBJ } {
upvar $PAGE_OBJ page_obj
global gPB
set ret_flag 0
set page_name $Page::($page_obj,page_name)
if { [string match "cod" $page_name] } {
set page_reg 0
} else {
set page_reg 1
}
if { [info exists Page::($page_obj,active_cmd_obj)] } {
global pb_cmd_procname
set active_cmd $Page::($page_obj,active_cmd_obj)
if { $page_reg == 0} {
set cur_cmd_name "PB_CMD_${pb_cmd_procname}"
} else {
set cur_cmd_name "PB_CMD_vnc__${pb_cmd_procname}"
}
set cust_page_flag [PB_int_CheckForCmdBlk active_cmd cur_cmd_name]
if { $cust_page_flag == 1 } {
UI_PB_cmd_DenyCmdRename $cust_page_flag
set ret_flag 1
} else {
if 1 {
if [UI_PB_cmd_SaveCmdProc $page_obj] {
set ret_flag 0
} else {
set ret_flag -1
update
}
} else {
set cc_res [UI_PB_cmd_SaveCmdProc_ret_msg $page_obj cc_err_msg]
switch -- $cc_res {
1 {
set ret_flag 0
}
0 {
set ret_flag -1
tk_messageBox -parent [UI_PB_com_AskActiveWindow] \
-type ok -icon error \
-title "$gPB(cust_cmd,error,title)" \
-message "$cc_err_msg"
}
-1 {
set res [tk_messageBox -parent [UI_PB_com_AskActiveWindow] \
-type okcancel -icon warning \
-title "$gPB(cust_cmd,error,title)" \
-message "$cc_err_msg" ]
set gPB(IGNORE_CC_MAIN_TAB) 0
if { $res == "ok" } {
PB_file_AssumeUnknownCommandsInProc
PB_file_AssumeUnknownDefElemsInProc
if { [info exists Page::($page_obj,active_cmd_obj)] } {
set cmd_obj $Page::($page_obj,active_cmd_obj)
UI_PB_cmd_GetProcFromTextWin $page_obj proc_text
set command::($cmd_obj,proc) $proc_text
}
set ret_flag 0
} else {
set ret_flag -1
}
}
} ;# switch
}
}
}
return $ret_flag
}
proc UI_PB_UpdateProgTpthBook { PRG_BOOK } {
upvar $PRG_BOOK prg_book
global gPB
set ret_flag 0
switch -exact -- $Book::($prg_book,current_tab) \
{
0 {
set page_obj [lindex $Book::($prg_book,page_obj_list) 0]
UI_PB_evt_GetSequenceIndex page_obj seq_index
set seq_obj [lindex $Page::($page_obj,seq_obj_list) $seq_index]
}
1 {
set page_obj [lindex $Book::($prg_book,page_obj_list) 1]
UI_PB_gcd_ApplyGcodeData $prg_book $page_obj
}
2 {
set page_obj [lindex $Book::($prg_book,page_obj_list) 2]
UI_PB_mcd_ApplyMcodeData $prg_book $page_obj
}
3 {
set page_obj [lindex $Book::($prg_book,page_obj_list) 3]
UI_PB_ads_UpdateAddressObjects
}
4 {
set page_obj [lindex $Book::($prg_book,page_obj_list) 4]
UI_PB_mseq_ApplyMastSeq page_obj
}
5 {
set page_obj [lindex $Book::($prg_book,page_obj_list) 5]
set ret_flag [UI_PB_cmd_ApplyCuscommand page_obj]
}
6 { ;#<01-15-03 gsl> Linked posts
global mom_sys_arr
set page_obj [lindex $Book::($prg_book,page_obj_list) 6]
if $mom_sys_arr(\$is_linked_post) {
set ret_flag [UI_PB_progtpth_ValidateLinkedPostPage $page_obj]
if $ret_flag {
tk_messageBox -parent [UI_PB_com_AskActiveWindow] -type ok \
-icon error \
-message "Duplicated Head assignment is not permitted."
}
}
if { $ret_flag == 0 } {
UI_PB_lnk_SaveData $page_obj
}
}
}
return $ret_flag
}
proc UI_PB_UpdateNCDefBook { DEF_BOOK } {
upvar $DEF_BOOK def_book
global gPB
set ret_flag 0
switch -exact -- $Book::($def_book,current_tab) \
{
0  {
global gPB_block_name
set page_obj [lindex $Book::($def_book,page_obj_list) 0]
set block_obj $Page::($page_obj,active_blk_obj)
if 0 {
set ret_code [UI_PB_blk_CheckBlockName gPB_block_name block_obj]
if { $block::($block_obj,active_blk_elem_list) == "" } \
{
tk_messageBox -parent [UI_PB_com_AskActiveWindow] -type ok \
-icon error \
-message "$gPB(msg,min_word)"
set ret_flag 1
} elseif { $ret_code } \
{
UI_PB_blk_DenyBlockRename $ret_code
set ret_flag 1
} else \
{
UI_PB_blk_BlkApplyCallBack $page_obj
}
}
if { $block::($block_obj,active_blk_elem_list) == "" } \
{
tk_messageBox -parent [UI_PB_com_AskActiveWindow] -type ok \
-icon error \
-message "$gPB(msg,min_word)"
set ret_flag 1
} else \
{
UI_PB_blk_BlkApplyCallBack $page_obj
}
}
1  {
global gPB_address_name
set page_obj [lindex $Book::($def_book,page_obj_list) 1]
set add_obj $Page::($page_obj,act_addr_obj)
set ret_code [UI_PB_addr_CheckAddressName gPB_address_name add_obj]
if { $ret_code } \
{
UI_PB_addr_DenyAddrRename $ret_code
set ret_flag 1
} else \
{
UI_PB_addr_ApplyCurrentAddrData page_obj
}
}
2  {
set page_obj [lindex $Book::($def_book,page_obj_list) 2]
if { [info exists Page::($page_obj,act_fmt_obj)] } \
{
global FORMATOBJATTR
global gPB_format_name
set fmt_obj $Page::($page_obj,act_fmt_obj)
set page_obj [lindex $Book::($def_book,page_obj_list) 2]
set ret_code [UI_PB_fmt_CheckFormatName gPB_format_name fmt_obj]
if { $ret_code } \
{
UI_PB_fmt_DenyFmtRename $ret_code
set ret_flag 1
} elseif { $FORMATOBJATTR(1) == "Numeral" && \
$FORMATOBJATTR(6) == 0 && $FORMATOBJATTR(3) == 0 && \
$FORMATOBJATTR(4) == 0 } \
{
tk_messageBox  -parent [UI_PB_com_AskActiveWindow] \
-type ok -icon error \
-message " $gPB(format,data,dec_zero,msg)"
set ret_flag 1
} else \
{
UI_PB_fmt_ApplyCurrentFmtData page_obj
}
}
}
3  {
set page_obj [lindex $Book::($def_book,page_obj_list) 3]
UI_PB_oth_ApplyOtherAttr
}
}
return $ret_flag
}
proc UI_PB_isv_UpdateBookAttr { BOOK_OBJ } {
upvar $BOOK_OBJ book_obj
global gPB mom_sys_arr mom_sim_arr
global post_object
PB_int_UpdateMOMVar mom_sys_arr
PB_int_UpdateSIMVar mom_sim_arr
set ret_flag 0
if { $Book::($book_obj,current_tab) == 1 } {
set page_obj [lindex $Book::($book_obj,page_obj_list) 1]
set ret_flag [UI_PB_cmd_ApplyCuscommand page_obj]
}
return $ret_flag
}
proc UI_PB_UpdateCurrentBookPageAttr { PB_BOOK } {
upvar $PB_BOOK book
set ret_flag 0
switch -exact -- $Book::($book,current_tab) \
{
0  {
set page_obj [lindex $Book::($book,page_obj_list) 0]
UI_PB_mach_UpdateMachinePageParams page_obj
}
1  {
set page_obj [lindex $Book::($book,page_obj_list) 1]
if {[info exists Page::($page_obj,book_obj)]} \
{
set page_book_obj $Page::($page_obj,book_obj)
set ret_flag [UI_PB_UpdateProgTpthBook page_book_obj]
}
}
2  {
set page_obj [lindex $Book::($book,page_obj_list) 2]
if {[info exists Page::($page_obj,book_obj)]} \
{
set page_book_obj $Page::($page_obj,book_obj)
set ret_flag [UI_PB_UpdateNCDefBook page_book_obj]
}
}
3  {
set page_obj [lindex $Book::($book,page_obj_list) 3]
set page_book_obj $Page::($page_obj,book_obj)
set ret_flag [UI_PB_list_ValidatePrevPageParam page_book_obj]
if $ret_flag {
UI_PB_list_ErrorPrevPage page_book_obj
} else {
UI_PB_list_ApplyListObjAttr page_book_obj
}
}
4  {
set page_obj [lindex $Book::($book,page_obj_list) 4]
if {[info exists Page::($page_obj,book_obj)]} \
{
set page_book_obj $Page::($page_obj,book_obj)
}
set ret_flag [UI_PB_isv_UpdateBookAttr page_book_obj]
}
}
return $ret_flag
}
proc UI_PB__main_status {top} {
global gPB
global tixOption
set w [frame $top.f3 -relief raised -bd 1]
set gPB(statusbar) \
[label $w.status -font $tixOption(bold_font) -bg black -fg gold1 \
-anchor w -relief sunken -bd 1 -textvariable gPB(menu_bar_status)]
set gPB(menu_bar_status) "$gPB(main,default,Status)"
tixForm $gPB(statusbar) -padx 3 -pady 3 -left 0 -right %70
return $w
}
