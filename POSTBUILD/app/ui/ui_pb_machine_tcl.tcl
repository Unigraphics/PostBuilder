proc UI_PB_mach_DisableWindow { PAGE_OBJ args } {
upvar $PAGE_OBJ page_obj
global machData
global gPB
set tree $Page::($page_obj,tree)
set h [$tree subwidget hlist]
set sty_n  $gPB(font_style_normal)
set sty_ng $gPB(font_style_normal_gray)
$h entryconfig 0.0 -state disabled -style $sty_ng
switch $machData(1) \
{
"4-Axis" \
{
$h entryconfig 0.1 -state disabled -style $sty_ng
}
"5-Axis" \
{
$h entryconfig 0.1 -state disabled -style $sty_ng
$h entryconfig 0.2 -state disabled -style $sty_ng
}
}
set anc [$h info anchor]
$h entryconfig $anc -state normal -style $sty_n
tixDisableAll $Page::($page_obj,page_id)
}
proc UI_PB_mach_EnableWindow { PAGE_OBJ args } {
upvar $PAGE_OBJ page_obj
global machData
global gPB
set tree $Page::($page_obj,tree)
set h [$tree subwidget hlist]
set sty_n  $gPB(font_style_normal)
set sty_ng $gPB(font_style_normal_gray)
$h entryconfig 0.0 -state normal -style $sty_n
switch $machData(1) \
{
"4-Axis" \
{
$h entryconfig 0.1 -state normal -style $sty_n
}
"5-Axis" \
{
$h entryconfig 0.1 -state normal -style $sty_n
$h entryconfig 0.2 -state normal -style $sty_n
}
}
tixEnableAll $Page::($page_obj,page_id)
}
proc UI_PB_MachineTool { book_id mctl_page_obj } {
global paOption
global machData
set Page::($mctl_page_obj,page_id) \
[$book_id subwidget $Page::($mctl_page_obj,page_name)]
set machData(0) "Mill"
set machData(1) 3-Axis
set machData(2) Vertical
set machData(3) "pb_mill_3axis.gif"
set machData(4) "Milimeter(mm)"
set machData(5) empty
set machData(6) empty
set machData(7) "gPB(machine,gen,Label)"
set machData(8) "gPB(machine,axis,fourth,Label)"
set machData(9) "gPB(machine,axis,fifth,Label)"
UI_PB_mach_AddMachParam mctl_page_obj
set Page::($mctl_page_obj,cur_tree_index) -1
if {$::env(PB_UDE_ENABLED) == 1} {
set olist [PB_ude_ConvertObjs]
set so [lindex $olist 0]
global post_object
set seq_obj_list $Post::($post_object,seq_obj_list)
foreach seqobj $seq_obj_list {
if ![string compare $sequence::($seqobj,seq_name) "Machine Control"] {
set non_mach_ctrl_evt_list $sequence::($so,evt_obj_list)
set temp_list [concat $sequence::($seqobj,evt_obj_list) $non_mach_ctrl_evt_list]
set sequence::($seqobj,evt_obj_list) $temp_list
sequence::readvalue $seqobj obj_attr
sequence::DefaultValue $seqobj obj_attr
}
}
if {$machData(0) == "Mill"} {
set so_cycle [lindex $olist 1]
set seq_obj_list $Post::($post_object,seq_obj_list)
foreach seqobj $seq_obj_list {
if ![string compare $sequence::($seqobj,seq_name) "Cycles"] {
set cycle_obj_list $sequence::($so_cycle,evt_obj_list)
set temp_list [concat $sequence::($seqobj,evt_obj_list) $cycle_obj_list]
set sequence::($seqobj,evt_obj_list) $temp_list
sequence::readvalue $seqobj obj_attr
sequence::DefaultValue $seqobj obj_attr
}
}
}
}
}
proc UI_PB_mach_SetMachKinvars { MACH_PAGE_OBJ } {
upvar $MACH_PAGE_OBJ mach_page_obj
global machData
if [string match "XZC" $machData(1)] {
set mill_general_param {"\$mom_kin_post_data_unit" "\$mom_kin_output_unit" \
"\$mom_kin_spindle_axis(0)" "\$mom_kin_spindle_axis(1)" "\$mom_kin_spindle_axis(2)" \
"\$mom_kin_x_axis_limit" "\$mom_kin_y_axis_limit" \
"\$mom_kin_z_axis_limit" "\$mom_sys_home_pos(0)" \
"\$mom_sys_home_pos(1)" "\$mom_sys_home_pos(2)" \
"\$mom_kin_machine_resolution" "\$mom_kin_rapid_feed_rate" \
"\$cir_record_output" \
"\$mill_turn_spindle_axis" \
"\$mom_sys_millturn_yaxis" \
"\$mom_sys_mill_turn_type" \
"\$mom_sys_lathe_postname" \
"\$mom_sys_coordinate_output_mode" \
"\$mom_sys_xzc_arc_output_mode" \
"\$xaxis_dia_prog" "\$i_dia_prog" \
"\$yaxis_dia_prog" "\$j_dia_prog" \
"\$xaxis_mirror" "\$yaxis_mirror" "\$zaxis_mirror" \
"\$i_mirror" "\$j_mirror" "\$k_mirror"}
set mill_4th_param {"\$mom_kin_4th_axis_min_incr" \
"\$mom_kin_4th_axis_max_limit" \
"\$mom_kin_4th_axis_min_limit" \
"\$mom_kin_4th_axis_rotation" \
"\$mom_kin_4th_axis_center_offset(0)" \
"\$mom_kin_4th_axis_center_offset(1)" \
"\$mom_kin_4th_axis_center_offset(2)" \
"\$mom_kin_4th_axis_zero" \
"\$mom_kin_4th_axis_plane" \
"\$mom_kin_4th_axis_direction" \
"\$mom_sys_radius_output_mode" \
"\$mom_kin_4th_axis_leader" \
"\$mom_kin_max_dpm" \
"\$mom_kin_linearization_flag" \
"\$mom_kin_linearization_tol" \
"\$mom_kin_4th_axis_limit_action" \
"\$mom_kin_4th_axis_incr_switch"}
} else {
set mill_general_param {"\$mom_kin_post_data_unit" "\$mom_kin_output_unit" \
"\$mom_kin_x_axis_limit" "\$mom_kin_y_axis_limit" \
"\$mom_kin_z_axis_limit" "\$mom_sys_home_pos(0)" \
"\$mom_sys_home_pos(1)" "\$mom_sys_home_pos(2)" \
"\$mom_kin_machine_resolution" "\$mom_kin_rapid_feed_rate" \
"\$xaxis_dia_prog" "\$i_dia_prog" \
"\$yaxis_dia_prog" "\$j_dia_prog" \
"\$xaxis_mirror" "\$yaxis_mirror" "\$zaxis_mirror" \
"\$i_mirror" "\$j_mirror" "\$k_mirror" \
"\$cir_record_output"}
set mill_4th_param {"\$mom_kin_4th_axis_min_incr" \
"\$mom_kin_4th_axis_max_limit" \
"\$mom_kin_4th_axis_min_limit" \
"\$mom_kin_4th_axis_rotation" \
"\$mom_kin_4th_axis_center_offset(0)" \
"\$mom_kin_4th_axis_center_offset(1)" \
"\$mom_kin_4th_axis_center_offset(2)" \
"\$mom_kin_4th_axis_zero" \
"\$mom_kin_4th_axis_plane" \
"\$mom_kin_4th_axis_direction" \
"\$mom_kin_pivot_gauge_offset" \
"\$mom_kin_4th_axis_leader" \
"\$mom_kin_max_dpm" \
"\$mom_kin_linearization_flag" \
"\$mom_kin_linearization_tol" \
"\$mom_kin_4th_axis_limit_action" \
"\$mom_kin_4th_axis_incr_switch"}
}
set mill_5th_param {"\$mom_kin_5th_axis_min_incr" \
"\$mom_kin_5th_axis_max_limit" \
"\$mom_kin_5th_axis_min_limit" \
"\$mom_kin_5th_axis_rotation" \
"\$mom_kin_5th_axis_center_offset(0)" \
"\$mom_kin_5th_axis_center_offset(1)" \
"\$mom_kin_5th_axis_center_offset(2)" \
"\$mom_kin_5th_axis_zero" \
"\$mom_kin_5th_axis_direction" \
"\$mom_kin_pivot_gauge_offset" \
"\$mom_kin_max_dpm" "\$mom_kin_linearization_flag" \
"\$mom_kin_linearization_tol" \
"\$mom_kin_4th_axis_limit_action" \
"\$mom_kin_5th_axis_incr_switch"}
set lathe_general_param {"\$mom_kin_post_data_unit" "\$mom_kin_output_unit" \
"\$mom_kin_x_axis_limit" "\$mom_kin_z_axis_limit"
"\$mom_sys_home_pos(0)" "\$mom_sys_home_pos(2)" \
"\$mom_kin_machine_resolution" "\$mom_kin_rapid_feed_rate" \
"\$cir_record_output" \
"\$xaxis_dia_prog" "\$i_dia_prog" \
"\$xaxis_mirror" "\$zaxis_mirror" \
"\$i_mirror" "\$k_mirror" \
"\$lathe_output_method"}
set lathe_4th_param {"\$mom_kin_4th_axis_min_incr" \
"\$mom_kin_4th_axis_max_limit" \
"\$mom_kin_4th_axis_min_limit" \
"\$mom_kin_4th_axis_rotation" \
"\$mom_kin_4th_axis_center_offset(0)" \
"\$mom_kin_4th_axis_center_offset(1)" \
"\$mom_kin_4th_axis_center_offset(2)" \
"\$mom_kin_4th_axis_zero" \
"\$mom_kin_4th_axis_direction" \
"\$mom_kin_4th_axis_plane" \
"\$mom_kin_pivot_gauge_offset" \
"\$mom_kin_4th_axis_leader" \
"\$mom_kin_max_dpm" \
"\$mom_kin_linearization_flag" \
"\$mom_kin_linearization_tol" \
"\$mom_kin_4th_axis_limit_action"}
switch $machData(0) \
{
"Mill" \
{
switch $machData(1) \
{
"3-Axis" {
set Page::($mach_page_obj,general_param)  $mill_general_param
}
"XZC" -
"4-Axis" {
set Page::($mach_page_obj,general_param)  $mill_general_param
set Page::($mach_page_obj,axis_4th_param) $mill_4th_param
}
"5-Axis" {
set Page::($mach_page_obj,general_param)  $mill_general_param
set Page::($mach_page_obj,axis_4th_param) $mill_4th_param
set Page::($mach_page_obj,axis_5th_param) $mill_5th_param
}
}
}
"Lathe" \
{
switch $machData(1) \
{
"2-Axis" {
set Page::($mach_page_obj,general_param) $lathe_general_param
}
"4-Axis" {
set Page::($mach_page_obj,general_param) $lathe_general_param
set Page::($mach_page_obj,axis_4th_param) $lathe_4_param
}
}
}
}
}
proc UI_PB_mach_AddMachParam { PAGE_OBJ } {
upvar $PAGE_OBJ page_obj
global tixOption
global paOption
global machData
global axisoption
global gPB
Page::CreatePane $page_obj
set left_pane_id $Page::($page_obj,left_pane_id)
set but [frame $left_pane_id.f]
set disp [button $but.disp -text "$gPB(machine,display,Label)" \
-bg $paOption(app_butt_bg) -command "UI_PB_mach_AddMachImage"]
pack $disp -expand yes
pack $but -side top -fill x -padx 7
set gPB(c_help,$disp)    "machine,display"
Page::CreateTree $page_obj
UI_PB_mach_BuildMachTreeList page_obj
UI_PB_mach_SetMachKinvars page_obj
set right_pane $Page::($page_obj,canvas_frame)
set machData(info) [frame $right_pane.info -relief flat -bd 0]
UI_PB_mach_DisplayPostInfo page_obj $machData(info)
set machData(gen) [frame $right_pane.gen -relief flat -bd 0]
switch $machData(0) \
{
"Mill" \
{
UI_PB_mach_MillGeneralParams page_obj $machData(gen) \
"general_param"
switch $machData(1) \
{
"XZC" -
"4-Axis" \
{
set machData(4th) [frame $right_pane.4th -relief flat -bd 0]
set tmp $machData(1)
if [string match "XZC" $tmp] {
set machData(1) "4-Axis"
}
UI_PB_mach_AddRotaryAxisParams page_obj $machData(4th) \
"axis_4th_param" 4
set machData(1) $tmp
}
"5-Axis" \
{
set machData(4th) [frame $right_pane.4th -relief flat -bd 0]
set machData(5th) [frame $right_pane.5th -relief flat -bd 0]
UI_PB_mach_AddRotaryAxisParams page_obj $machData(4th) \
"axis_4th_param" 4
UI_PB_mach_AddRotaryAxisParams page_obj $machData(5th) \
"axis_5th_param" 5
}
}
}
"Lathe" \
{
UI_PB_mach_LatheGeneralParams page_obj $machData(gen) "general_param"
switch $machData(1) \
{
"4-Axis" \
{
set machData(4th) [frame $right_pane.4th -relief flat -bd 0]
UI_PB_mach_AddRotaryAxisParams page_obj $machData(4th) \
"axis_4th_param" 4
}
}
}
"Wire EDM" \
{
UI_PB_mach_WedmGeneralParams page_obj $machData(gen) \
"general_param" $machData(1)
}
}
}
proc UI_PB_mach_BuildMachTreeList { PAGE_OBJ } {
upvar $PAGE_OBJ page_obj
global machData
global paOption tixOption
global gPB
set tree $Page::($page_obj,tree)
set h [$tree subwidget hlist]
$h config -bg $paOption(tree_bg)
uplevel #0 set TRANSPARENT_GIF_COLOR [$h cget -bg]
set mach_comp [tix getimage pb_mach_kin]
UI_PB_mach_SetMachTreeTitle
set style  $gPB(font_style_bold)
set style1 $gPB(font_style_normal)
set showtext ""
switch $machData(1) {
"2-Axis" {
set showtext $gPB(new,axis_2,Label)
}
"3-Axis" {
set showtext $gPB(new,axis_3,Label)
}
"4-Axis" {
set showtext $gPB(new,axis_4,Label)
}
"5-Axis" {
set showtext $gPB(new,axis_5,Label)
}
"XZC"    {
set showtext $gPB(new,axis_XZC,Label)
}
default   {}
}
switch $machData(0) {
"Mill"     {
append showtext " " $gPB(new,mill,Label)
}
"Lathe"    {
append showtext " " $gPB(new,lathe,Label)
}
"Wire EDM" {
append showtext " " $gPB(new,wire,Label)
}
default    {}
}
$h add 0    -itemtype imagetext -text "$showtext" \
-image $paOption(folder) -style $style -state normal
$h add 0.0  -itemtype imagetext -text [set $machData(7)] -image $mach_comp \
-style $style1
if { ![string match "Wire EDM" $machData(0)] } {
switch $machData(1) \
{
"XZC" \
{
$h add 0.1 -itemtype imagetext -text $gPB(machine,axis,rotary,Label) \
-image $mach_comp -style $style1
}
"4-Axis" \
{
$h add 0.1 -itemtype imagetext -text [set $machData(8)] \
-image $mach_comp -style $style1
}
"5-Axis" \
{
$h add 0.1 -itemtype imagetext -text [set $machData(8)] \
-image $mach_comp -style $style1
$h add 0.2 -itemtype imagetext -text [set $machData(9)] \
-image $mach_comp -style $style1
}
default {}
}
}
$h anchor set 0.0
$h selection set 0.0
$tree config \
-browsecmd "UI_PB_mach_MachDisplayParams $page_obj machData"
}
proc UI_PB_mach_SetMachTreeTitle {} {
global machType axisoption machData
set machData(0) $machType
switch -- $machType \
{
"Mill" {
switch -- $axisoption \
{
"3"   {
set machData(1) "3-Axis"
}
"3MT" {
set machData(1) "XZC"
}
"4T" -
"4H"  {
set machData(1) "4-Axis"
}
"5HH" -
"5TT" -
"5HT" {
set machData(1) "5-Axis"
}
default {
set machData(1) "3-Axis"
}
}
}
"Lathe" {
switch -- $axisoption \
{
"2" {
set machData(1) "2-Axis"
}
"4" {
set machData(1) "4-Axis"; #<11-21-01 gsl> was 2-Axis
}
default {
set machData(1) "2-Axis"
}
}
}
"Wire EDM" {
switch -- $axisoption \
{
"2" {
set machData(1) "2-Axis"
}
"4" {
set machData(1) "4-Axis"
}
default {
set machData(1) "2-Axis"
}
}
}
}
}
proc UI_PB_mach_MachDisplayParams { page_obj MACHDATA args} {
upvar $MACHDATA machData
global gPB
set tree $Page::($page_obj,tree)
set HLIST [$tree subwidget hlist]
set ent   [$HLIST info anchor]
if [string match "0" $ent] {
if { $Page::($page_obj,cur_tree_index) == -1 } {
return
}
pack forget $machData(info)
if { [info exists machData(5th)] && [winfo exists $machData(5th)]} \
{
pack forget $machData(5th)
}
if { [info exists machData(4th)] && [winfo exists $machData(4th)]} \
{
pack forget $machData(4th)
}
pack forget $machData(gen)
set gPB(post_description_restore) ""
set text_list [$gPB(post_description_text_win) dump -text 1.0 end]
set len [llength $text_list]
set str [lindex $text_list [expr $len - 2]]
if { [string match "" $str] || [string match "\n" $str] } {
set len [expr $len - 3]
}
for { set i 1 } { $i < $len } { incr i 3 } {
set line [lindex $text_list $i]
lappend gPB(post_description_restore) $line
}
pack $machData(info) -expand yes -fill both
set Page::($page_obj,cur_tree_index) -1
return
}
pack forget $machData(info)
set indx  [string range $ent 2 [string length $ent]]
if { $Page::($page_obj,cur_tree_index) == $indx } { return }
if { [info exists machData(5th)] && [winfo exists $machData(5th)]} \
{
pack forget $machData(5th)
}
if { [info exists machData(4th)] && [winfo exists $machData(4th)]} \
{
pack forget $machData(4th)
}
pack forget $machData(gen)
switch $machData([expr $indx + 7])\
{
"gPB(machine,gen,Label)" \
{
pack $machData(gen) -expand yes -fill both
}
"gPB(machine,axis,fourth,Label)" \
{
pack $machData(4th) -expand yes -fill both
}
"gPB(machine,axis,fifth,Label)" \
{
pack $machData(5th) -expand yes -fill both
}
}
set Page::($page_obj,cur_tree_index) $indx
}
proc _mach_AddDescPopUpMenu { t menu x y } {
global gPB
set sel_buffer ""
catch { set sel_buffer [$t get sel.first sel.last] }
set gPB(post_description_selection_buffer) $sel_buffer
if { [$menu index end] == "none" } {
$menu add command -label "$gPB(nav_button,cut,Label)"     -command "_mach_CutDesc $t"
$menu add command -label "$gPB(nav_button,copy,Label)"    -command "_mach_CopyDesc"
$menu add command -label "$gPB(nav_button,paste,Label)"   -command "_mach_PasteDesc $t"
}
if { ![catch {set sel [selection get -selection CLIPBOARD -type STRING]} ] } {
set gPB(post_description_paste_buffer) $sel
}
if { $gPB(post_description_paste_buffer) != "" } {
$menu entryconfig 2 -state normal
} else {
$menu entryconfig 2 -state disabled
}
if { $sel_buffer != "" } {
$menu entryconfig 0 -state normal
$menu entryconfig 1 -state normal
} else {
$menu entryconfig 0 -state disabled
$menu entryconfig 1 -state disabled
}
tk_popup $menu $x $y
}
proc _mach_CutDesc { t args } {
$t delete sel.first sel.last
_mach_CopyDesc
}
proc _mach_CopyDesc { args } {
global gPB
clipboard clear
clipboard append -type STRING -- $gPB(post_description_selection_buffer)
}
proc _mach_PasteDesc { t args } {
global gPB
set sel_buffer ""
catch { set sel_buffer [$t get sel.first sel.last] }
if { $sel_buffer != "" } {
$t delete sel.first sel.last
}
$t insert insert "$gPB(post_description_paste_buffer)"
}
proc _mach_RestoreDesc { args } {
global gPB
set t $gPB(post_description_text_win)
$t delete 1.0 end
$t insert end [join $gPB(post_description_restore) ""]
}
proc _mach_DefaultDesc { args } {
global gPB
set t $gPB(post_description_text_win)
$t delete 1.0 end
$t insert end [join $gPB(post_description_default) \n]
}
proc UI_PB_mach_DisplayPostInfo { PAGE_OBJ win } {
upvar $PAGE_OBJ page_obj
global machData
global paOption
global tixOption
global mom_kin_var
global gPB
if { ![info exists gPB(post_description)] } {
set gPB(post_description) [list]
}
set gPB(post_description_default) $gPB(post_description)
if { ![info exists gPB(post_controller)] } {
set gPB(post_controller) [list]
}
if { ![info exists gPB(post_history)] } {
set gPB(post_history) [list]
}
if {[info exists ::env(INCH_METRIC)] && $::env(INCH_METRIC) == 1} {
set output_unit "Inch and Metric"
} else {
switch $mom_kin_var(\$mom_kin_output_unit) {
"IN"    { set output_unit "Inch" }
"MM"    { set output_unit "Metric" }
default { set output_unit $mom_kin_var(\$mom_kin_output_unit) }
}
}
global axisoption
switch $machData(0) {
Mill {
switch -- $axisoption {
"3"   {
set mach_kin $machData(1)
}
"3MT" {
set mach_kin "3-Axis Mill-Turn (XZC)"
}
"4T"  {
set mach_kin "$machData(1) Table"
}
"4H"  {
set mach_kin "$machData(1) Head"
}
"5HH" {
set mach_kin "$machData(1) Dual Heads"
}
"5TT" {
set mach_kin "$machData(1) Dual Tables"
}
"5HT" {
set mach_kin "$machData(1) Head Table"
}
}
}
Lathe -
"Wire EDM" -
default {
set mach_kin $machData(1)
}
}
set bot_frm [frame $win.bbox]
pack $bot_frm -side bottom -padx 3 -pady 3 -fill x
set label_list {"gPB(nav_button,default,Label)" \
"gPB(nav_button,restore,Label)"}
set cb_arr(gPB(nav_button,default,Label)) \
"_mach_DefaultDesc"
set cb_arr(gPB(nav_button,restore,Label)) \
"_mach_RestoreDesc"
UI_PB_com_CreateButtonBox $bot_frm label_list cb_arr
set top_frm [frame $win.f -relief sunken -bd 1]
pack $top_frm -side top -padx 3 -pady 0 -fill both -expand yes
set title [label $top_frm.title -text "$gPB(machine,info,title,Label)" \
-font $tixOption(bold_font) \
-bg $paOption(title_bg) -fg $paOption(title_fg) -bd 2 -relief raised -anchor c]
pack $title -side top -fill x
UI_PB_mthd_CreateScrollWindow $top_frm body info_win y
pack forget $top_frm.body
pack $top_frm.body -side top -expand yes -fill both -padx 0 -pady 0
set win_bg [lindex [$top_frm config -bg] end]  ;# Window background
set lbl_bg $win_bg                             ;# Labels background
set ent_bg $paOption(entry_disabled_bg)        ;# Entries background
set ent_relief sunken                          ;# Entries relief
set desc_lbl [label $info_win.desc_lbl -text "$gPB(machine,info,desc,Label)" \
-bg $lbl_bg -font $tixOption(bold_font) -justify center]
set desc_txt [tixScrolledText $info_win.desc \
-height 100 -width 500]
set text [$desc_txt subwidget text]
$text config -bg $paOption(tree_bg)
[$desc_txt subwidget vsb]  config -width $paOption(trough_wd) \
-troughcolor $paOption(trough_bg)
[$desc_txt subwidget hsb]  config -width $paOption(trough_wd) \
-troughcolor $paOption(trough_bg)
grid [label $info_win.xxx -text ""]
grid $desc_lbl
grid $desc_txt -padx 20 -pady 2 -sticky ew
$text insert end [join $gPB(post_description) \n]
set gPB(post_description_text_win) $text
set gPB(post_description_paste_buffer) ""
if [winfo exists $text.pop] {
set menu $text.pop
} else {
set menu [menu $text.pop -tearoff 0 -cursor ""]
}
bind $text <3> "_mach_AddDescPopUpMenu $text $menu %X %Y"
focus $text
set oth [frame $info_win.oth -relief flat -bd 0]
grid $oth -sticky ew
label $oth.mach_lbl -text "$gPB(machine,info,type,Label)" -bg $lbl_bg \
-font $tixOption(bold_font) -justify left -anchor w
entry $oth.mach_ent -width 60 -relief $ent_relief
$oth.mach_ent insert 0 $machData(0)
$oth.mach_ent config -bg $ent_bg -state disabled
label $oth.kine_lbl -text "$gPB(machine,info,kinematics,Label)" -bg $lbl_bg \
-font $tixOption(bold_font) -justify left -anchor w
entry $oth.kine_ent -width 60 -relief $ent_relief
$oth.kine_ent insert 0 $mach_kin
$oth.kine_ent config -bg $ent_bg -state disabled
label $oth.cntl_lbl -text "$gPB(machine,info,controller,Label)" -bg $lbl_bg \
-font $tixOption(bold_font) -justify left -anchor w
set desc_txt [tixScrolledText $oth.cntl_ent -height 37 -width 400 -scrollbar x]
set text [$desc_txt subwidget text]
$text config -bg $ent_bg -font $tixOption(font) -wrap none -bd 2 ;#<10-14-04 gsl> Added -bd 2.
[$desc_txt subwidget hsb] config -width $paOption(trough_wd) \
-troughcolor $paOption(trough_bg)
$text insert end "$gPB(post_controller)"
$text config -state disabled -relief $ent_relief
label $oth.unit_lbl -text "$gPB(machine,info,unit,Label)" -bg $lbl_bg \
-font $tixOption(bold_font) -justify left -anchor w
entry $oth.unit_ent -width 60 -relief $ent_relief
$oth.unit_ent insert 0 $output_unit
$oth.unit_ent config -bg $ent_bg -state disabled
label $oth.hist_lbl -text "$gPB(machine,info,history,Label)" -bg $lbl_bg \
-font $tixOption(bold_font) -justify center
set slis [tixScrolledListBox $oth.hist_lis -scrollbar auto -height 120]
set lis [$slis subwidget listbox]
$lis config -font $tixOption(fixed_font)
set i 0
foreach h $gPB(post_history) {
$lis insert end "$i - $h"
incr i
}
$lis see 0
set gPB(post_history_list_win) $lis
grid [label $oth.xxx -text ""]
grid $oth.mach_lbl $oth.mach_ent -padx 20 -pady 4 -sticky ew
grid $oth.kine_lbl $oth.kine_ent -padx 20 -pady 4 -sticky ew
grid $oth.unit_lbl $oth.unit_ent -padx 20 -pady 4 -sticky ew
grid $oth.cntl_lbl $oth.cntl_ent -padx 20 -pady 4 -sticky ew
grid $oth.hist_lbl -                      -pady 8
grid $oth.hist_lis -             -padx 20 -pady 1 -sticky ew
}
if 0 {
proc UI_PB_mach_DisplayPostInfo { PAGE_OBJ win } {
upvar $PAGE_OBJ page_obj
global machData
global paOption
global tixOption
global mom_kin_var
global gPB
if { ![info exists gPB(post_description)] } {
set gPB(post_description) [list]
}
if { ![info exists gPB(post_controller)] } {
set gPB(post_controller) [list]
}
if { ![info exists gPB(post_history)] } {
set gPB(post_history) [list]
}
switch $mom_kin_var(\$mom_kin_output_unit) {
"IN"    { set output_unit "Inch" }
"MM"    { set output_unit "Metric" }
default { set output_unit $mom_kin_var(\$mom_kin_output_unit) }
}
global axisoption
switch $machData(0) {
Mill {
switch -- $axisoption {
"3"   {
set mach_kin $machData(1)
}
"3MT" {
set mach_kin "3-Axis Mill-Turn (XZC)"
}
"4T"  {
set mach_kin "$machData(1) Table"
}
"4H"  {
set mach_kin "$machData(1) Head"
}
"5HH" {
set mach_kin "$machData(1) Dual Heads"
}
"5TT" {
set mach_kin "$machData(1) Dual Tables"
}
"5HT" {
set mach_kin "$machData(1) Head Table"
}
}
}
Lathe -
"Wire EDM" -
default {
set mach_kin $machData(1)
}
}
set top_frm [frame $win.f -relief sunken -bd 1]
pack $top_frm -side top -padx 3 -pady 0 -fill both -expand yes
set lla [label $top_frm.la -text "Post Information" -font $tixOption(bold_font) \
-bg $paOption(title_bg) -fg $paOption(title_fg) -bd 2 -relief raised -anchor c]
pack $lla -side top -fill x
set lsw [tixScrolledText $top_frm.lsw]
[$lsw subwidget hsb] config -troughcolor $paOption(trough_bg) \
-width $paOption(trough_wd)
[$lsw subwidget vsb] config -troughcolor $paOption(trough_bg) \
-width $paOption(trough_wd)
pack $lsw -side bottom -expand yes -fill both
set text [$lsw subwidget text]
$text insert end "\n\n\n"
foreach line $gPB(post_description) {
$text insert end "\t $line\n"
}
$text insert end "\n\n\n"
$text insert end "\t Machine Type \t\t $machData(0)\n"
$text insert end "\t Kinematics \t\t $mach_kin\n"
$text insert end "\t Controller \t\t $gPB(post_controller)\n\n"
$text insert end "\t Output Unit \t\t $output_unit\n\n"
$text insert end "\t History\n"
$text insert end "\t\t $gPB(post_history)\n"
$text config -bg $paOption(entry_disabled_bg) \
-font $tixOption(bold_font) \
-height 200 -wrap none -bd 5 -relief flat \
-state disabled
}
} ;# if 0
proc UI_PB_mach_SwitchUnit {} {
global gPB UNIT_INFO
if {$gPB(current_unit) == "Inch"} {
set gPB(unit_flag) in
set names [array names UNIT_INFO]
foreach one $names {
if ![winfo exists $one] {continue}
set gb_arr [lindex $UNIT_INFO($one) 1]
set var    [lindex $UNIT_INFO($one) 2]
if {[lindex $UNIT_INFO($one) 0] == 1} {
global $gb_arr
set pre_var [lindex [$one config -textvariable] end]
if [string match $pre_var ${gb_arr}(${var}_IN)] {
set ${gb_arr}(${var}_MM) [expr [set ${gb_arr}(${var}_IN)] * 25.4]
} else {
$one config -textvariable ${gb_arr}(${var}_IN)
set ${gb_arr}(${var}_IN) [expr [set ${gb_arr}(${var}_MM)] / 25.4]
}
} else {
$one config -textvariable ${gb_arr}(${var}_IN)
}
}
} else {
set gPB(unit_flag) mm
set names [array names UNIT_INFO]
foreach one $names {
if ![winfo exists $one] {continue}
set gb_arr [lindex $UNIT_INFO($one) 1]
set var    [lindex $UNIT_INFO($one) 2]
if {[lindex $UNIT_INFO($one) 0] == 1} {
global $gb_arr
set pre_var [lindex [$one config -textvariable] end]
if [string match $pre_var ${gb_arr}(${var}_MM)] {
set ${gb_arr}(${var}_IN) [expr [set ${gb_arr}(${var}_MM)] / 25.4]
} else {
$one config -textvariable ${gb_arr}(${var}_MM)
set ${gb_arr}(${var}_MM) [expr [set ${gb_arr}(${var}_IN)] * 25.4]
}
} else {
$one config -textvariable ${gb_arr}(${var}_MM)
}
}
}
}
proc UI_PB_mach_MillGeneralParams { PAGE_OBJ gen_frm axis_param } {
upvar $PAGE_OBJ page_obj
global paOption
global tixOption
global mom_kin_var
global mom_sys_arr
global gPB
global axisoption
global mom_sys_arr
UI_PB_mthd_CreateScrollWindow $gen_frm millgen top_win y
set top_frm [frame $top_win.f]
pack $top_frm -side top -pady 40 -fill both
switch $mom_kin_var(\$mom_kin_output_unit) \
{
"IN"    { set output_unit "Inch" }
"MM"    { set output_unit "Metric" }
default { set output_unit $mom_kin_var(\$mom_kin_output_unit) }
}
if {[info exists ::env(INCH_METRIC)] && $::env(INCH_METRIC) == 1} {
Page::CreateLblFrame $top_frm unit "$gPB(machine,gen,out_unit,Label)"
}
Page::CreateLblFrame $top_frm limit  "$gPB(machine,gen,travel_limit,Label)"
Page::CreateLblFrame $top_frm home   "$gPB(machine,gen,home_pos,Label)"
Page::CreateLblFrame $top_frm res    "$gPB(machine,gen,step_size,Label)"
Page::CreateLblFrame $top_frm trav   "$gPB(machine,gen,traverse_feed,Label)"
Page::CreateLblFrame $top_frm circ   "$gPB(machine,gen,circle_record,Label)"
if {[info exists ::env(INCH_METRIC)] && $::env(INCH_METRIC) == 1} {
set fu [$top_frm.unit subwidget frame]
}
set fl [$top_frm.limit subwidget frame]
set fh [$top_frm.home subwidget frame]
set fr [$top_frm.res subwidget frame]
set ft [$top_frm.trav subwidget frame]
set fc [$top_frm.circ subwidget frame]
set gPB(current_unit) Inch
set gPB(unit_flag) in
if {[info exists ::env(INCH_METRIC)] && $::env(INCH_METRIC) == 1} {
radiobutton $fu.inch -text "$gPB(machine,gen,out_unit,inch,Label) "  -variable gPB(current_unit) \
-font $tixOption(bold_font) -fg royalBlue \
-value Inch -activeforeground royalBlue \
-command [list UI_PB_mach_SwitchUnit]
radiobutton $fu.metric  -text "$gPB(machine,gen,out_unit,metric,Label) " -variable gPB(current_unit) \
-font $tixOption(bold_font) -fg royalBlue \
-value Metric -activeforeground royalBlue \
-command [list UI_PB_mach_SwitchUnit]
pack $fu.inch -side left  -padx 15 -expand yes -pady 3
pack $fu.metric  -side right -padx 15 -expand yes -pady 3
} else {
set pf [frame $top_frm.pf -bg royalBlue -relief solid -bd 1]
label $pf.postunit -text "$gPB(machine,gen,out_unit,Label) $output_unit" \
-font $tixOption(bold_font) -fg $paOption(special_fg) -bg $paOption(header_bg)
pack $pf.postunit -pady 10
set gPB(c_help,$pf.postunit)      "machine,gen,out_unit"
set gPB(c_help,$pf)               "machine,gen,out_unit"
}
set x_frm [frame $fl.xfrm]
Page::CreateLblEntry f \$mom_kin_x_axis_limit $x_frm x_asso_unit \
"$gPB(machine,gen,travel_limit,x,Label)" 1
pack $x_frm -fill x
set y_frm [frame $fl.yfrm]
Page::CreateLblEntry f \$mom_kin_y_axis_limit $y_frm y_asso_unit \
"$gPB(machine,gen,travel_limit,y,Label)" 1
pack $y_frm -fill x
set z_frm [frame $fl.zfrm]
Page::CreateLblEntry f \$mom_kin_z_axis_limit $z_frm z_asso_unit \
"$gPB(machine,gen,travel_limit,z,Label)" 1
pack $z_frm -fill x
set gPB(c_help,$x_frm.1_x)   "machine,gen,travel_limit,x"
set gPB(c_help,$y_frm.1_y)   "machine,gen,travel_limit,y"
set gPB(c_help,$z_frm.1_z)   "machine,gen,travel_limit,z"
set x_frm [frame $fh.xhom]
Page::CreateLblEntry f \$mom_sys_home_pos(0) $x_frm x_asso_unit \
"$gPB(machine,gen,home_pos,x,Label)"
pack $x_frm -fill x
set y_frm [frame $fh.yhom]
Page::CreateLblEntry f \$mom_sys_home_pos(1) $y_frm y_asso_unit \
"$gPB(machine,gen,home_pos,y,Label)"
pack $y_frm -fill x
set z_frm [frame $fh.zhom]
Page::CreateLblEntry f \$mom_sys_home_pos(2) $z_frm z_asso_unit \
"$gPB(machine,gen,home_pos,z,Label)"
pack $z_frm -fill x
set gPB(c_help,$x_frm.1_x)   "machine,gen,home_pos,x"
set gPB(c_help,$y_frm.1_y)   "machine,gen,home_pos,y"
set gPB(c_help,$z_frm.1_z)   "machine,gen,home_pos,z"
set res [frame $fr.res]
Page::CreateLblEntry f \$mom_kin_machine_resolution $res min_unit \
"$gPB(machine,gen,step_size,min,Label)" 1
pack $res -fill x
set gPB(c_help,$res.1_min)   "machine,gen,step_size,min"
set max_f [frame $ft.res]
Page::CreateLblEntry f \$mom_kin_rapid_feed_rate $max_f max_unit \
"$gPB(machine,gen,traverse_feed,max,Label)" 1
pack $max_f -fill x
set gPB(c_help,$max_f.1_max)   "machine,gen,traverse_feed,max"
radiobutton $fc.yes -text "$gPB(machine,gen,circle_record,yes,Label)" \
-variable mom_sys_arr(\$cir_record_output)\
-value YES -command "UI_PB_mach_SetCirKinVar"
radiobutton $fc.no  -text "$gPB(machine,gen,circle_record,no,Label)" \
-variable mom_sys_arr(\$cir_record_output)\
-value NO -command "UI_PB_mach_SetCirKinVar"
pack $fc.yes -side left  -padx 15 -expand yes -pady 3
pack $fc.no  -side right -padx 15 -expand yes -pady 3
set gPB(c_help,$fc.yes)   "machine,gen,circle_record,yes"
set gPB(c_help,$fc.no)    "machine,gen,circle_record,no"
if [string match "3MT" $axisoption] {
set dy 5
} else {
set dy 15
}
if {[info exists ::env(INCH_METRIC)] && $::env(INCH_METRIC) == 1} {
grid $top_frm.unit -row 0 -column 0 -padx 5 -pady [expr $dy + 5] -sticky ew
} else {
grid $pf -row 0 -column 0 -padx 10 -pady [expr $dy + 5] -sticky ew
}
grid $top_frm.circ -row 0 -column 1 -padx 5 -pady [expr $dy - 5] -sticky we
grid $top_frm.limit $top_frm.home -padx 5  -pady $dy -sticky we
grid $top_frm.res $top_frm.trav -padx 5  -pady $dy -sticky we
if [string match "3MT" $axisoption] {
Page::CreateLblFrame $top_frm spdl "$gPB(machine,gen,spindle_axis,Label)"
set fs [$top_frm.spdl subwidget frame]
set opts_list {"Z Axis" "+X Axis" "-X Axis" "Y Axis"}
set var "\$mill_turn_spindle_axis"
Page::CreateOptionalMenu $var $fs spndl $opts_list ""
$fs.spndl config -command "__mach_MapMillTurnSpindleAxis $fs.yaxis"
pack $fs.spndl -padx 3 -pady 3
set gPB(c_help,[$fs.spndl subwidget menubutton])  "machine,gen,spindle_axis"
set var "\$mom_sys_millturn_yaxis"
Page::CreateCheckButton  $var $fs yaxis "$gPB(machine,gen,position_in_yaxis,Label)"
$fs.yaxis config -onvalue TRUE -offvalue FALSE
set gPB(c_help,$fs.yaxis)   "machine,gen,position_in_yaxis"
__mach_MapMillTurnSpindleAxis $fs.yaxis
set Page::($page_obj,xzc_spindle_yaxis_frm) $fs.yaxis
Page::CreateLblFrame $top_frm mach "$gPB(machine,gen,mach_mode,Label)"
set fm [$top_frm.mach subwidget frame]
set gPB(c_help,$fm)   "machine,gen,mach_mode"
set fmm [frame $fm.frm]
grid $fmm -sticky ew
radiobutton $fmm.xzc       -text "$gPB(machine,gen,mach_mode,xzc_mill,Label)" \
-anchor w  -value XZC_MILL \
-variable mom_sys_arr(\$mom_sys_mill_turn_type) \
-command "__mach_ToggleLathePostEntry $fm.lathe_post"
radiobutton $fmm.mill_turn -text "$gPB(machine,gen,mach_mode,mill_turn,Label)" \
-anchor w -value SIMPLE_MILL_TURN \
-variable mom_sys_arr(\$mom_sys_mill_turn_type) \
-command "__mach_ToggleLathePostEntry $fm.lathe_post"
pack $fmm.xzc       -side left  -padx 10 -expand yes
pack $fmm.mill_turn -side right -padx 10 -expand yes
set gPB(c_help,$fmm.xzc)         "machine,gen,mach_mode,xzc_mill"
set gPB(c_help,$fmm.mill_turn)   "machine,gen,mach_mode,mill_turn"
set flp [frame $fm.lathe_post]
grid $flp - -sticky ew -padx 5 -pady 2
label $flp.lbl -text "$gPB(machine,gen,mill_turn,lathe_post,Label) " -justify left
entry $flp.ent -width 15 -relief sunken \
-textvariable mom_sys_arr(\$mom_sys_lathe_postname)
button $flp.but -text "$gPB(machine,gen,lathe_post,select_name,Label)" \
-command "__mach_BrowseAPost"
pack $flp.lbl $flp.ent $flp.but -side left -fill x -padx 2
set gPB(c_help,$flp.ent)         "machine,gen,mill_turn,lathe_post"
set gPB(c_help,$flp.but)         "machine,gen,lathe_post,select_name"
__mach_ToggleLathePostEntry $flp
set Page::($page_obj,xzc_lathe_post_frm) $flp
Page::CreateLblFrame $top_frm out  "$gPB(machine,gen,coord_mode,Label)"
set fo [$top_frm.out subwidget frame]
set gPB(c_help,$fo)         "machine,gen,coord_mode"
radiobutton $fo.polar -text "$gPB(machine,gen,coord_mode,polar,Label)" \
-anchor w -value POLAR \
-variable mom_sys_arr(\$mom_sys_coordinate_output_mode)
radiobutton $fo.cartn -text "$gPB(machine,gen,coord_mode,cart,Label)" \
-anchor w -value CARTESIAN \
-variable mom_sys_arr(\$mom_sys_coordinate_output_mode)
pack $fo.polar -side left  -padx 10 -expand yes
pack $fo.cartn -side right -padx 10 -expand yes
set gPB(c_help,$fo.polar)         "machine,gen,coord_mode,polar"
set gPB(c_help,$fo.cartn)         "machine,gen,coord_mode,cart"
Page::CreateLblFrame $top_frm cir  "$gPB(machine,gen,xzc_arc_mode,Label)"
set fc [$top_frm.cir subwidget frame]
set gPB(c_help,$fc)         "machine,gen,xzc_arc_mode"
if ![info exists mom_sys_arr(\$mom_sys_xzc_arc_output_mode)] {
set mom_sys_arr(\$mom_sys_xzc_arc_output_mode) CARTESIAN
}
radiobutton $fc.polar -text "$gPB(machine,gen,xzc_arc_mode,polar,Label)" \
-anchor w -value POLAR \
-variable mom_sys_arr(\$mom_sys_xzc_arc_output_mode)
radiobutton $fc.cartn -text "$gPB(machine,gen,xzc_arc_mode,cart,Label)" \
-anchor w -value CARTESIAN \
-variable mom_sys_arr(\$mom_sys_xzc_arc_output_mode)
pack $fc.polar -side left  -padx 10 -expand yes
pack $fc.cartn -side right -padx 10 -expand yes
set gPB(c_help,$fc.polar)         "machine,gen,xzc_arc_mode,polar"
set gPB(c_help,$fc.cartn)         "machine,gen,xzc_arc_mode,cart"
grid $top_frm.spdl $top_frm.mach -padx 5 -pady $dy -sticky news
grid $top_frm.out $top_frm.cir -padx 5 -pady $dy -sticky news
}
Page::CreateLblFrame $top_frm mul  "$gPB(machine,gen,axis_multi,Label)"
if 1 {
set fm [$top_frm.mul subwidget frame]
Page::CreateLblFrame $fm frm  "$gPB(machine,gen,axis_multi,dia,Label)"
set frm [$fm.frm subwidget frame]
if 1 {
set fl [frame $frm.left  -relief flat]
set fr [frame $frm.right -relief flat]
pack $fl $fr -side left -expand yes -fill both
set pdx 5
set exp yes
set fil both
checkbutton $fl.xdpg -text "$gPB(machine,gen,axis_multi,2x,Label)" \
-variable mom_sys_arr(\$xaxis_dia_prog) \
-relief flat -bd 2 -anchor w
checkbutton $fr.idpg -text "$gPB(machine,gen,axis_multi,2i,Label)" \
-variable mom_sys_arr(\$i_dia_prog) \
-relief flat -bd 2 -anchor w
$fl.xdpg config -command "__mach_SetIOption $fr.idpg"
__mach_SetIOption $fr.idpg
checkbutton $fl.ydpg -text "$gPB(machine,gen,axis_multi,2y,Label)" \
-variable mom_sys_arr(\$yaxis_dia_prog) \
-relief flat -bd 2 -anchor w
checkbutton $fr.jdpg -text "$gPB(machine,gen,axis_multi,2j,Label)" \
-variable mom_sys_arr(\$j_dia_prog) \
-relief flat -bd 2 -anchor w
$fl.ydpg config -command "__mach_SetJOption $fr.jdpg"
__mach_SetJOption $fr.jdpg
pack $fl.xdpg $fl.ydpg -padx $pdx -expand $exp -fill $fil
pack $fr.idpg $fr.jdpg -padx $pdx -expand $exp -fill $fil
}
Page::CreateLblFrame $fm fmm  "$gPB(machine,gen,axis_multi,mir,Label)"
set fmm [$fm.fmm subwidget frame]
if 1 {
set fml [frame $fmm.left  -relief flat]
set fmr [frame $fmm.right -relief flat]
pack $fml $fmr -side left -expand yes -fill both
checkbutton $fml.xmir -text "$gPB(machine,gen,axis_multi,x,Label)" \
-variable mom_sys_arr(\$xaxis_mirror) \
-relief flat -bd 2 -anchor w
checkbutton $fmr.imir -text "$gPB(machine,gen,axis_multi,i,Label)" \
-variable mom_sys_arr(\$i_mirror) \
-relief flat -bd 2 -anchor w
checkbutton $fml.ymir -text "$gPB(machine,gen,axis_multi,y,Label)" \
-variable mom_sys_arr(\$yaxis_mirror) \
-relief flat -bd 2 -anchor w
checkbutton $fmr.jmir -text "$gPB(machine,gen,axis_multi,j,Label)" \
-variable mom_sys_arr(\$j_mirror) \
-relief flat -bd 2 -anchor w
checkbutton $fml.zmir -text "$gPB(machine,gen,axis_multi,z,Label)" \
-variable mom_sys_arr(\$zaxis_mirror) \
-relief flat -bd 2 -anchor w
checkbutton $fmr.kmir -text "$gPB(machine,gen,axis_multi,k,Label)" \
-variable mom_sys_arr(\$k_mirror) \
-relief flat -bd 2 -anchor w
pack $fml.xmir $fml.ymir $fml.zmir -padx $pdx -expand $exp -fill $fil
pack $fmr.imir $fmr.jmir $fmr.kmir -padx $pdx -expand $exp -fill $fil
}
pack $fm.frm $fm.fmm -padx 3 -pady 3 -expand yes -fill both
set gPB(c_help,$fl.xdpg)     "machine,gen,axis_multi,2x"
set gPB(c_help,$fl.ydpg)     "machine,gen,axis_multi,2y"
set gPB(c_help,$fr.idpg)     "machine,gen,axis_multi,2i"
set gPB(c_help,$fr.jdpg)     "machine,gen,axis_multi,2j"
set gPB(c_help,$fml.xmir)    "machine,gen,axis_multi,x"
set gPB(c_help,$fml.ymir)    "machine,gen,axis_multi,y"
set gPB(c_help,$fml.zmir)    "machine,gen,axis_multi,z"
set gPB(c_help,$fmr.imir)    "machine,gen,axis_multi,i"
set gPB(c_help,$fmr.jmir)    "machine,gen,axis_multi,j"
set gPB(c_help,$fmr.kmir)    "machine,gen,axis_multi,k"
}
if ![string match "3MT" $axisoption] {
Page::CreateLblFrame $top_frm spi "$gPB(machine,gen,def_spindle_axis,Label)"
if 1 {
set fs [$top_frm.spi subwidget frame]
set fi [frame $fs.i]
Page::CreateLblEntry f \$mom_kin_spindle_axis(0) $fi ent "I"
pack $fi -fill x
set fj [frame $fs.j]
Page::CreateLblEntry f \$mom_kin_spindle_axis(1) $fj ent "J"
pack $fj -fill x
set fk [frame $fs.k]
Page::CreateLblEntry f \$mom_kin_spindle_axis(2) $fk ent "K"
pack $fk -fill x
if { [PB_is_ver 3.4] == 0 } {
if { [info exists gPB(HIGHLIGHT_NEW_FEATURE)] && $gPB(HIGHLIGHT_NEW_FEATURE) } {
$top_frm.spi config -background $gPB(NEW_FEATURE_COLOR)
}
}
set gPB(c_help,$top_frm.spi)  "machine,gen,def_spindle_axis"
}
}
if ![string match "3MT" $axisoption] {
grid $top_frm.mul $top_frm.spi -padx 5 -pady $dy -sticky new
} else {
grid $top_frm.mul -padx 5 -pady $dy -sticky new
}
set bot_frm [frame $gen_frm.ff]
pack $bot_frm -side bottom -padx 3 -pady 3 -fill x
UI_PB_mach_AddActionButtons page_obj $bot_frm $axis_param
if ![string compare $::tix_version 8.4] {
UI_PB_mthd_WheelForFrame $gen_frm.millgen.sf
}
}
proc __mach_BrowseAPost { args } {
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
if { ![info exists gPB(mill_turn_lathe_post)] } {
set gPB(mill_turn_lathe_post) ""
}
if {$tcl_platform(platform) == "unix"} \
{
UI_PB_file_SelectFile_unx PUI gPB(mill_turn_lathe_post) open
} elseif {$tcl_platform(platform) == "windows"} \
{
UI_PB_file_SelectFile_win PUI gPB(mill_turn_lathe_post) open
__file_EnableWidgets
}
set gPB(mill_turn_lathe_post) [string trim $gPB(mill_turn_lathe_post) \"]
if { ![string match "" $gPB(mill_turn_lathe_post)] } {
global mom_sys_arr
set post [file rootname [file tail $gPB(mill_turn_lathe_post)]]
set mom_sys_arr(\$mom_sys_lathe_postname) $post
}
}
proc __mach_ToggleLathePostEntry { w args } {
global mom_sys_arr
global paOption gPB
if [string match "XZC_MILL" $mom_sys_arr(\$mom_sys_mill_turn_type)] {
$w.ent config -state disabled -fg gray -bg $paOption(entry_disabled_bg)
$w.but config -state disabled
} else {
$w.ent config -state normal -fg black -bg $gPB(entry_color)
$w.but config -state normal
}
}
proc UI_PB_mach_WedmGeneralParams { PAGE_OBJ gen_frm axis_param n_axis } {
upvar $PAGE_OBJ page_obj
global paOption
global tixOption
global mom_kin_var
global mom_sys_arr
global gPB
UI_PB_mthd_CreateScrollWindow $gen_frm millgen top_win
set top_frm [frame $top_win.f]
if ![string compare $::tix_version 8.4] {
pack $top_frm -side top -pady [list 40 10] -fill both
} else {
pack $top_frm -side top -pady 40 -fill both
}
switch $mom_kin_var(\$mom_kin_output_unit) \
{
"IN"    { set output_unit "Inch" }
"MM"    { set output_unit "Metric" }
default { set output_unit $mom_kin_var(\$mom_kin_output_unit) }
}
if {[info exists ::env(INCH_METRIC)] && $::env(INCH_METRIC) == 1} {
Page::CreateLblFrame $top_frm unit "$gPB(machine,gen,out_unit,Label)"
}
Page::CreateLblFrame $top_frm limit  "$gPB(machine,gen,travel_limit,Label)"
Page::CreateLblFrame $top_frm home   "$gPB(machine,gen,home_pos,Label)"
Page::CreateLblFrame $top_frm res    "$gPB(machine,gen,step_size,Label)"
if 1 {
Page::CreateLblFrame $top_frm trav   "$gPB(machine,gen,traverse_feed,Label)"
}
Page::CreateLblFrame $top_frm circ   "$gPB(machine,gen,circle_record,Label)"
if {[info exists ::env(INCH_METRIC)] && $::env(INCH_METRIC) == 1} {
set fu [$top_frm.unit subwidget frame]
}
set fl [$top_frm.limit subwidget frame]
set fh [$top_frm.home subwidget frame]
set fr [$top_frm.res subwidget frame]
if 1 {
set ft [$top_frm.trav subwidget frame]
}
set fc [$top_frm.circ subwidget frame]
set gPB(current_unit) Inch
set gPB(unit_flag) in
if {[info exists ::env(INCH_METRIC)] && $::env(INCH_METRIC) == 1} {
radiobutton $fu.inch -text "$gPB(machine,gen,out_unit,inch,Label) "  -variable gPB(current_unit) \
-font $tixOption(bold_font) -fg royalBlue \
-value Inch -activeforeground royalBlue \
-command [list UI_PB_mach_SwitchUnit]
radiobutton $fu.metric  -text "$gPB(machine,gen,out_unit,metric,Label) " -variable gPB(current_unit) \
-font $tixOption(bold_font) -fg royalBlue \
-value Metric -activeforeground royalBlue \
-command [list UI_PB_mach_SwitchUnit]
pack $fu.inch -side left  -padx 15 -expand yes -pady 3
pack $fu.metric  -side right -padx 15 -expand yes -pady 3
} else {
set pf [frame $top_frm.pf -bg royalBlue -relief solid -bd 1]
label $pf.postunit -text "$gPB(machine,gen,out_unit,Label) $output_unit" \
-font $tixOption(bold_font) -fg $paOption(special_fg) -bg $paOption(header_bg)
pack $pf.postunit -pady 10
set gPB(c_help,$pf.postunit)      "machine,gen,out_unit"
set gPB(c_help,$pf)               "machine,gen,out_unit"
}
set x_frm [frame $fl.xfrm]
Page::CreateLblEntry f \$mom_kin_x_axis_limit $x_frm x_asso_unit \
"$gPB(machine,gen,travel_limit,x,Label)" 1
pack $x_frm -fill x
set y_frm [frame $fl.yfrm]
Page::CreateLblEntry f \$mom_kin_y_axis_limit $y_frm y_asso_unit \
"$gPB(machine,gen,travel_limit,y,Label)" 1
pack $y_frm -fill x
set gPB(c_help,$x_frm.1_x)   "machine,gen,travel_limit,x"
set gPB(c_help,$y_frm.1_y)   "machine,gen,travel_limit,y"
set x_frm [frame $fh.xhom]
Page::CreateLblEntry f \$mom_sys_home_pos(0) $x_frm x_asso_unit \
"$gPB(machine,gen,home_pos,x,Label)"
pack $x_frm -fill x
set y_frm [frame $fh.yhom]
Page::CreateLblEntry f \$mom_sys_home_pos(1) $y_frm y_asso_unit \
"$gPB(machine,gen,home_pos,y,Label)"
pack $y_frm -fill x
set gPB(c_help,$x_frm.1_x)   "machine,gen,home_pos,x"
set gPB(c_help,$y_frm.1_y)   "machine,gen,home_pos,y"
set res [frame $fr.res]
Page::CreateLblEntry f \$mom_kin_machine_resolution $res min_unit \
"$gPB(machine,gen,step_size,min,Label)" 1
pack $res -fill x
set gPB(c_help,$res.1_min)   "machine,gen,step_size,min"
if 1 {
set max_f [frame $ft.res]
Page::CreateLblEntry f \$mom_kin_rapid_feed_rate $max_f max_unit \
"$gPB(machine,gen,traverse_feed,max,Label)" 1
pack $max_f -fill x
set gPB(c_help,$max_f.1_max)   "machine,gen,traverse_feed,max"
}
radiobutton $fc.yes -text "$gPB(machine,gen,circle_record,yes,Label)" \
-variable mom_sys_arr(\$cir_record_output)\
-value YES -command "UI_PB_mach_SetCirKinVar"
radiobutton $fc.no  -text "$gPB(machine,gen,circle_record,no,Label)" \
-variable mom_sys_arr(\$cir_record_output)\
-value NO -command "UI_PB_mach_SetCirKinVar"
pack $fc.yes -side left  -padx 15 -pady 5
pack $fc.no  -side right -padx 15 -pady 5
set gPB(c_help,$fc.yes)   "machine,gen,circle_record,yes"
set gPB(c_help,$fc.no)    "machine,gen,circle_record,no"
if {[info exists ::env(INCH_METRIC)] && $::env(INCH_METRIC) == 1} {
grid $top_frm.unit -row 0 -column 0 -padx 5 -pady 20 -sticky ew
} else {
grid $pf -row 0 -column 0 -padx 10 -pady 20 -sticky ew
}
grid $top_frm.circ -row 0 -column 1 -padx 5 -pady 10 -sticky we
grid $top_frm.limit $top_frm.home -padx 5  -pady 15 -sticky we
if 1 {
grid $top_frm.res $top_frm.trav -padx 5  -pady 15 -sticky we
} else {
grid $top_frm.res -padx 5  -pady 15 -sticky we
}
if [string match "4-Axis" $n_axis] {
Page::CreateLblFrame $top_frm tilt  "$gPB(machine,gen,wedm,wire_tilt)"
set tilt [$top_frm.tilt subwidget frame]
radiobutton $tilt.ang -text "$gPB(machine,gen,wedm,angle)" -anchor w \
-variable mom_kin_var(\$mom_kin_wire_tilt_output_type) -value ANGLES
radiobutton $tilt.coo -text "$gPB(machine,gen,wedm,coord)" -anchor w \
-variable mom_kin_var(\$mom_kin_wire_tilt_output_type) -value COORDINATES
grid $tilt.ang $tilt.coo -sticky ew -padx 5 -pady 2
grid $top_frm.tilt -padx 5  -pady 15 -sticky we
}
set bot_frm [frame $gen_frm.ff]
pack $bot_frm -side bottom -padx 3 -pady 3 -fill x
UI_PB_mach_AddActionButtons page_obj $bot_frm $axis_param
}
proc UI_PB_mach_LatheGeneralParams { PAGE_OBJ gen_frm axis_param } {
upvar $PAGE_OBJ page_obj
global paOption
global tixOption
global mom_sys_arr
global mom_kin_var
global gPB
switch $mom_kin_var(\$mom_kin_output_unit) \
{
"IN"    { set output_unit "Inch" }
"MM"    { set output_unit "Metric" }
default { set output_unit $mom_kin_var(\$mom_kin_output_unit) }
}
UI_PB_mthd_CreateScrollWindow $gen_frm lathegen top_win y
set top_frm [frame $top_win.f]
pack $top_frm -side top -pady 20 -fill both -expand yes
if {[info exists ::env(INCH_METRIC)] && $::env(INCH_METRIC) == 1} {
Page::CreateLblFrame $top_frm unit "$gPB(machine,gen,out_unit,Label)"
}
Page::CreateLblFrame $top_frm limit  "$gPB(machine,gen,travel_limit,Label)"
Page::CreateLblFrame $top_frm home   "$gPB(machine,gen,home_pos,Label)"
Page::CreateLblFrame $top_frm res    "$gPB(machine,gen,step_size,Label)"
Page::CreateLblFrame $top_frm trav   "$gPB(machine,gen,traverse_feed,Label)"
Page::CreateLblFrame $top_frm circ   "$gPB(machine,gen,circle_record,Label)"
Page::CreateLblFrame $top_frm turret "$gPB(machine,gen,turret,Label)"
Page::CreateLblFrame $top_frm multi  "$gPB(machine,gen,axis_multi,Label)"
Page::CreateLblFrame $top_frm output "$gPB(machine,gen,output,Label)"
if {[info exists ::env(INCH_METRIC)] && $::env(INCH_METRIC) == 1} {
set fu [$top_frm.unit subwidget frame]
}
set fl [$top_frm.limit subwidget frame]
set fh [$top_frm.home subwidget frame]
set fr [$top_frm.res subwidget frame]
set ft [$top_frm.trav subwidget frame]
set fc [$top_frm.circ subwidget frame]
set fmult [$top_frm.multi subwidget frame]
set ftur [$top_frm.turret subwidget frame]
set fout [$top_frm.output subwidget frame]
set gPB(current_unit) Inch
set gPB(unit_flag) in
if {[info exists ::env(INCH_METRIC)] && $::env(INCH_METRIC) == 1} {
radiobutton $fu.inch -text "$gPB(machine,gen,out_unit,inch,Label) "  -variable gPB(current_unit) \
-font $tixOption(bold_font) -fg royalBlue \
-value Inch -activeforeground royalBlue \
-command [list UI_PB_mach_SwitchUnit]
radiobutton $fu.metric  -text "$gPB(machine,gen,out_unit,metric,Label) " -variable gPB(current_unit) \
-font $tixOption(bold_font) -fg royalBlue \
-value Metric -activeforeground royalBlue \
-command [list UI_PB_mach_SwitchUnit]
pack $fu.inch -side left  -padx 15 -expand yes -pady 3
pack $fu.metric  -side right -padx 15 -expand yes -pady 3
} else {
set pf [frame $top_frm.pf -bg royalBlue -relief solid -bd 1]
label $pf.postunit -text "$gPB(machine,gen,out_unit,Label) $output_unit" \
-font $tixOption(bold_font) -fg $paOption(special_fg) -bg $paOption(header_bg)
pack $pf.postunit -pady 10
set gPB(c_help,$pf.postunit)      "machine,gen,out_unit"
set gPB(c_help,$pf)               "machine,gen,out_unit"
}
set x_frm [frame $fl.xfrm]
Page::CreateLblEntry f \$mom_kin_x_axis_limit $x_frm x_asso_unit \
"$gPB(machine,gen,travel_limit,x,Label)" 1
pack $x_frm -fill x
set y_frm [frame $fl.yfrm]
Page::CreateLblEntry f \$mom_kin_y_axis_limit $y_frm y_asso_unit \
"$gPB(machine,gen,travel_limit,y,Label)" 1
pack $y_frm -fill x
set z_frm [frame $fl.zfrm]
Page::CreateLblEntry f \$mom_kin_z_axis_limit $z_frm z_asso_unit \
"$gPB(machine,gen,travel_limit,z,Label)" 1
pack $z_frm -fill x
set gPB(c_help,$x_frm.1_x)   "machine,gen,travel_limit,x"
set gPB(c_help,$y_frm.1_y)   "machine,gen,travel_limit,y"
set gPB(c_help,$z_frm.1_z)   "machine,gen,travel_limit,z"
set x_frm [frame $fh.xhom]
Page::CreateLblEntry f \$mom_sys_home_pos(0) $x_frm x_asso_unit \
"$gPB(machine,gen,home_pos,x,Label)"
pack $x_frm -fill x
set y_frm [frame $fh.yhom]
Page::CreateLblEntry f \$mom_sys_home_pos(1) $y_frm y_asso_unit \
"$gPB(machine,gen,home_pos,y,Label)"
pack $y_frm -fill x
set z_frm [frame $fh.zhom]
Page::CreateLblEntry f \$mom_sys_home_pos(2) $z_frm z_asso_unit \
"$gPB(machine,gen,home_pos,z,Label)"
pack $z_frm -fill x
set gPB(c_help,$x_frm.1_x)   "machine,gen,home_pos,x"
set gPB(c_help,$y_frm.1_y)   "machine,gen,home_pos,y"
set gPB(c_help,$z_frm.1_z)   "machine,gen,home_pos,z"
set res [frame $fr.res]
Page::CreateLblEntry f \$mom_kin_machine_resolution $res min_unit \
"$gPB(machine,gen,step_size,min,Label)" 1
pack $res -fill x
set gPB(c_help,$res.1_min)   "machine,gen,step_size,min"
set max_f [frame $ft.res]
Page::CreateLblEntry f \$mom_kin_rapid_feed_rate $max_f max_unit \
"$gPB(machine,gen,traverse_feed,max,Label)" 1
pack $max_f -fill x
set gPB(c_help,$max_f.1_max)   "machine,gen,traverse_feed,max"
radiobutton $fc.yes -text "$gPB(machine,gen,circle_record,yes,Label)" \
-variable mom_sys_arr(\$cir_record_output)\
-value YES -command "UI_PB_mach_SetCirKinVar"
radiobutton $fc.no  -text "$gPB(machine,gen,circle_record,no,Label)" \
-variable mom_sys_arr(\$cir_record_output)\
-value NO -command "UI_PB_mach_SetCirKinVar"
pack $fc.yes -side left  -padx 15 -pady 5
pack $fc.no  -side right -padx 15 -pady 5
set gPB(c_help,$fc.yes)   "machine,gen,circle_record,yes"
set gPB(c_help,$fc.no)    "machine,gen,circle_record,no"
set fm $fmult
Page::CreateLblFrame $fm frm  "$gPB(machine,gen,axis_multi,dia,Label)"
set frm [$fm.frm subwidget frame]
set fl [frame $frm.left  -relief flat]
set fr [frame $frm.right -relief flat]
pack $fl $fr -side left -expand yes -fill both
set pdx 5
set exp yes
set fil both
checkbutton $fl.xdpg -text "$gPB(machine,gen,axis_multi,2x,Label)" \
-variable mom_sys_arr(\$xaxis_dia_prog) \
-relief flat -bd 2 -anchor w
checkbutton $fr.idpg -text "$gPB(machine,gen,axis_multi,2i,Label)" \
-variable mom_sys_arr(\$i_dia_prog) \
-relief flat -bd 2 -anchor w
$fl.xdpg config -command "__mach_SetIOption $fr.idpg"
__mach_SetIOption $fr.idpg
pack $fl.xdpg -padx $pdx -expand $exp -fill $fil
pack $fr.idpg -padx $pdx -expand $exp -fill $fil
Page::CreateLblFrame $fm fmm  "$gPB(machine,gen,axis_multi,mir,Label)"
set fmm [$fm.fmm subwidget frame]
set fml [frame $fmm.left  -relief flat]
set fmr [frame $fmm.right -relief flat]
pack $fml $fmr -side left -expand yes -fill both
checkbutton $fml.xmir -text "$gPB(machine,gen,axis_multi,x,Label)" \
-variable mom_sys_arr(\$xaxis_mirror) \
-relief flat -bd 2 -anchor w
checkbutton $fmr.imir -text "$gPB(machine,gen,axis_multi,i,Label)" \
-variable mom_sys_arr(\$i_mirror) \
-relief flat -bd 2 -anchor w
checkbutton $fml.zmir -text "$gPB(machine,gen,axis_multi,z,Label)" \
-variable mom_sys_arr(\$zaxis_mirror) \
-relief flat -bd 2 -anchor w
checkbutton $fmr.kmir -text "$gPB(machine,gen,axis_multi,k,Label)" \
-variable mom_sys_arr(\$k_mirror) \
-relief flat -bd 2 -anchor w
pack $fml.xmir $fml.zmir -padx $pdx -expand $exp -fill $fil
pack $fmr.imir $fmr.kmir -padx $pdx -expand $exp -fill $fil
pack $fm.frm $fm.fmm -padx 3 -pady 3 -expand yes -fill both
set gPB(c_help,$fl.xdpg)     "machine,gen,axis_multi,2x"
set gPB(c_help,$fr.idpg)     "machine,gen,axis_multi,2i"
set gPB(c_help,$fml.xmir)    "machine,gen,axis_multi,x"
set gPB(c_help,$fml.zmir)    "machine,gen,axis_multi,z"
set gPB(c_help,$fmr.imir)    "machine,gen,axis_multi,i"
set gPB(c_help,$fmr.kmir)    "machine,gen,axis_multi,k"
set tur_no [frame $ftur.no]
radiobutton $tur_no.one -text "$gPB(machine,gen,turret,one,Label)" \
-variable mom_sys_arr(\$no_of_turrets) -value 1 \
-command "UI_PB_mach_SecHeadParam $ftur"
radiobutton $tur_no.two  -text "$gPB(machine,gen,turret,two,Label)" \
-variable mom_sys_arr(\$no_of_turrets) -value 2 \
-command "UI_PB_mach_SecHeadParam $ftur"
pack $tur_no.one -side left  -padx 15 -pady 5
pack $tur_no.two -side right -padx 15 -pady 5
grid $tur_no -row 0 -column 0
set gPB(c_help,$tur_no.one)       "machine,gen,turret,one"
set gPB(c_help,$tur_no.two)       "machine,gen,turret,two"
set bb [tixButtonBox $ftur.bb -orientation horizontal]
$bb config -relief sunken -bd 1 -bg royalBlue -pady 5
$bb add spec -text "$gPB(machine,gen,turret,conf,Label)" -width 20
grid $bb -row 1 -column 0
set b [$bb subwidget spec]
$b config -command "UI_PB_mach_LatheTurretConfig $page_obj"
set gPB(c_help,$b)    "machine,gen,turret,conf"
radiobutton $fout.tip -text "$gPB(machine,gen,output,tool_tip,Label)" \
-variable mom_sys_arr(\$lathe_output_method) -value "TOOL_TIP"  \
-command "UI_PB_mach_LatheOutputMethod"
radiobutton $fout.turret -text "$gPB(machine,gen,output,turret_ref,Label)" \
-variable mom_sys_arr(\$lathe_output_method) \
-value "TURRET_REF" -command "UI_PB_mach_LatheOutputMethod"
pack $fout.tip -side left  -padx 15 -pady 5
pack $fout.turret -side right -padx 15 -pady 5
set gPB(c_help,$fout.tip)       "machine,gen,output,tool_tip"
set gPB(c_help,$fout.turret)    "machine,gen,output,turret_ref"
if {[info exists ::env(INCH_METRIC)] && $::env(INCH_METRIC) == 1} {
grid $top_frm.unit -row 0 -column 0 -padx 5 -pady 20 -sticky ew
} else {
grid $pf -row 0 -column 0 -padx 10 -pady 20 -sticky ew
}
grid $top_frm.circ -row 0 -column 1 -padx 5 -pady 10 -sticky we
grid $top_frm.limit $top_frm.home -padx 5  -pady 15 -sticky news
grid $top_frm.res $top_frm.trav -padx 5  -pady 15 -sticky news
if 0 {
grid $top_frm.multi $top_frm.turret -padx 5  -pady 15 -sticky news
grid $top_frm.output -padx 5 -pady 15 -sticky news
}
grid $top_frm.output $top_frm.turret -padx 5  -pady 15 -sticky news
grid $top_frm.multi -padx 5 -pady 15 -sticky news
set bot_frm [frame $gen_frm.ff]
pack $bot_frm -side bottom -padx 3 -pady 3 -fill x
UI_PB_mach_AddActionButtons page_obj $bot_frm $axis_param
UI_PB_mach_SecHeadParam $ftur
if ![string compare $::tix_version 8.4] {
UI_PB_mthd_WheelForFrame $gen_frm.lathegen.sf
}
}
proc __mach_SetIOption { w args } {
global mom_sys_arr
if $mom_sys_arr(\$xaxis_dia_prog) {
$w config -state normal
} else {
$w config -state disabled
}
}
proc __mach_SetJOption { w args } {
global mom_sys_arr
if $mom_sys_arr(\$yaxis_dia_prog) {
$w config -state normal
} else {
$w config -state disabled
}
}
proc UI_PB_mach_LatheTurretConfig { page_obj } {
global gPB
set canvas_frame $Page::($page_obj,canvas_frame)
set w $canvas_frame.turconf
toplevel $w
set toplevel_index [llength $gPB(toplevel_list)]
set win_index [expr $toplevel_index + 1]
set gPB(toplevel_disable_$win_index) 1
UI_PB_com_CreateTransientWindow $w \
"$gPB(machine,gen,turret,conf_trans,Label)" "+400+200" \
"" "UI_PB_mach_DisableMachPageWidgets $page_obj" "" \
"UI_PB_mach_ActivateMachPageWidgets $page_obj $win_index"
set page_frm [frame $w.f1 -relief sunken -bd 1]
pack $page_frm -fill both -expand yes -padx 6 -pady 5
set head_opt_list {"FRONT" "REAR" "RIGHT" "LEFT" "SIDE" "SADDLE"}
Page::CreateLblFrame $page_frm prim "$gPB(machine,gen,turret,prim,Label)"
set prim_head [$page_frm.prim subwidget frame]
Page::CreateOptionalMenu \$primary_head $prim_head phed \
$head_opt_list "$gPB(machine,gen,turret,designation,Label)"
Page::CreateLblFrame $page_frm sechead "$gPB(machine,gen,turret,sec,Label)"
set tur_head [$page_frm.sechead subwidget frame]
set sec_head [frame $tur_head.secd]
Page::CreateOptionalMenu \$secondary_head $sec_head shed \
$head_opt_list "$gPB(machine,gen,turret,designation,Label)"
pack $sec_head -fill x
set xof_frm [frame $tur_head.xof]
Page::CreateLblEntry f \$mom_kin_ind_to_dependent_head_x $xof_frm \
x_unit "$gPB(machine,gen,turret,xoff,Label)"
pack $xof_frm -fill x
set zof_frm [frame $tur_head.zof]
Page::CreateLblEntry f \$mom_kin_ind_to_dependent_head_z $zof_frm \
z_unit "$gPB(machine,gen,turret,zoff,Label)"
pack $zof_frm -fill x
grid $page_frm.prim  -padx 15 -pady 15 -sticky news
grid $page_frm.sechead  -padx 15 -pady 15 -sticky news
set frame [frame $w.f2]
pack $frame -side bottom -fill x -padx 3 -pady 3
UI_PB_mach_LatheTurretActionButt $w $frame
set gPB(c_help,[$prim_head.phed subwidget menubutton]) \
"machine,gen,turret,prim"
set gPB(c_help,[$sec_head.shed subwidget menubutton]) \
"machine,gen,turret,sec"
set gPB(c_help,$xof_frm.1_x)        "machine,gen,turret,xoff"
set gPB(c_help,$zof_frm.1_z)        "machine,gen,turret,zoff"
UI_PB_com_PositionWindow $w
}
proc UI_PB_mach_LatheTurretActionButt { win frame } {
set cb_arr(gPB(nav_button,default,Label)) "UI_PB_mach_TurretConfDef_CB"
set cb_arr(gPB(nav_button,restore,Label)) "UI_PB_mach_TurretConfRes_CB"
set cb_arr(gPB(nav_button,cancel,Label)) \
"UI_PB_mach_TurretConfCanc_CB $win"
set cb_arr(gPB(nav_button,ok,Label))  \
"UI_PB_mach_TurretConfOk_CB $win"
UI_PB_com_CreateActionElems $frame cb_arr
}
proc UI_PB_mach_TurretConfOk_CB { win } {
global mom_sys_arr
global mom_kin_var
global gPB
if { $mom_sys_arr(\$primary_head) == $mom_sys_arr(\$secondary_head) } \
{
tk_messageBox -parent [UI_PB_com_AskActiveWindow] -type ok \
-icon warning \
-message "$gPB(machine,gen,lathe_turret,msg)"
return
}
set mom_kin_var(\$mom_kin_independent_head) \
$mom_sys_arr(\$primary_head)
set mom_kin_var(\$mom_kin_dependent_head) \
$mom_sys_arr(\$secondary_head)
destroy $win
}
proc UI_PB_mach_TurretConfCanc_CB { win } {
UI_PB_mach_TurretConfRes_CB
destroy $win
}
proc UI_PB_mach_TurretConfDef_CB { } {
global mom_kin_var
global mom_sys_arr
PB_int_RetDefKinVars def_mom_kin_var
set mom_var(0) "\$primary_head"
set mom_var(1) "\$secondary_head"
PB_int_RetDefMOMVarValues mom_var mom_var_value
set mom_sys_arr(\$primary_head) \
$mom_var_value(\$primary_head)
set mom_sys_arr(\$secondary_head) \
$mom_var_value(\$secondary_head)
set mom_kin_var(\$mom_kin_ind_to_dependent_head_x) \
$def_mom_kin_var(\$mom_kin_ind_to_dependent_head_x)
set mom_kin_var(\$mom_kin_ind_to_dependent_head_z) \
$def_mom_kin_var(\$mom_kin_ind_to_dependent_head_z)
}
proc UI_PB_mach_TurretConfRes_CB { } {
global mom_kin_var
global mom_sys_arr
global rest_mom_kin_var
global rest_mom_sys_arr
set mom_sys_arr(\$primary_head) \
$rest_mom_sys_arr(\$primary_head)
set mom_sys_arr(\$secondary_head) \
$rest_mom_sys_arr(\$secondary_head)
set mom_kin_var(\$mom_kin_ind_to_dependent_head_x) \
$rest_mom_kin_var(\$mom_kin_ind_to_dependent_head_x)
set mom_kin_var(\$mom_kin_ind_to_dependent_head_z) \
$rest_mom_kin_var(\$mom_kin_ind_to_dependent_head_z)
}
proc UI_PB_mach_LatheOutputMethod { } {
global gPB
tk_messageBox -parent [UI_PB_com_AskActiveWindow] -type ok \
-icon warning \
-message "$gPB(machine,gen,turret_chg,msg)"
}
proc UI_PB_mach_SecHeadParam { ftur } {
global mom_sys_arr
global mom_kin_var
global gPB
set config_but [$ftur.bb subwidget spec]
switch $mom_sys_arr(\$no_of_turrets) \
{
1 {
set mom_kin_var(\$mom_kin_independent_head) "NONE"
set mom_kin_var(\$mom_kin_dependent_head) "NONE"
$config_but config -state disabled
}
2 {
$config_but config -state normal
}
}
}
proc UI_PB_mach_SetCirKinVar { } {
global mom_sys_arr
global mom_kin_var
switch $mom_sys_arr(\$cir_record_output) \
{
"YES" {
set mom_kin_var(\$mom_kin_arc_output_mode) "FULL_CIRCLE"
}
"NO"  {
set mom_kin_var(\$mom_kin_arc_output_mode) "LINEAR"
}
}
}
proc UI_PB_mach_AddRotaryAxisParams { PAGE_OBJ frame_id axis_param n_axis} {
upvar $PAGE_OBJ page_obj
global tixOption
global paOption
global machData
global mom_kin_var
global gPB
switch $n_axis \
{
4 {
set axis_rotation       "\$mom_kin_4th_axis_rotation"
set axis_max_limit      "\$mom_kin_4th_axis_max_limit"
set axis_min_limit      "\$mom_kin_4th_axis_min_limit"
set axis_min_incr       "\$mom_kin_4th_axis_min_incr"
set axis_center_offset0 "\$mom_kin_4th_axis_center_offset(0)"
set axis_center_offset1 "\$mom_kin_4th_axis_center_offset(1)"
set axis_center_offset2 "\$mom_kin_4th_axis_center_offset(2)"
set axis_ang_offset     "\$mom_kin_4th_axis_zero"
set axis_limit_action   "\$mom_kin_4th_axis_limit_action"
set axis_pivot_offset   "\$mom_kin_pivot_gauge_offset"
set axis_max_dpm        "\$mom_kin_max_dpm"
set axis_linear_tol     "\$mom_kin_linearization_tol"
set axis_direction      "\\\$mom_kin_4th_axis_direction"
set local_var_dir       "\$4th_axis_direction"
set axis_incr           "\$mom_kin_4th_axis_incr_switch"
set axis_offset_label   "$gPB(machine,axis,offset,4,Label)"
}
5 {
set axis_rotation       "\$mom_kin_5th_axis_rotation"
set axis_min_incr       "\$mom_kin_5th_axis_min_incr"
set axis_max_limit      "\$mom_kin_5th_axis_max_limit"
set axis_min_limit      "\$mom_kin_5th_axis_min_limit"
set axis_center_offset0 "\$mom_kin_5th_axis_center_offset(0)"
set axis_center_offset1 "\$mom_kin_5th_axis_center_offset(1)"
set axis_center_offset2 "\$mom_kin_5th_axis_center_offset(2)"
set axis_ang_offset     "\$mom_kin_5th_axis_zero"
set axis_limit_action   "\$mom_kin_4th_axis_limit_action"
set axis_pivot_offset   "\$mom_kin_pivot_gauge_offset"
set axis_max_dpm        "\$mom_kin_max_dpm"
set axis_linear_tol     "\$mom_kin_linearization_tol"
set axis_direction      "\\\$mom_kin_5th_axis_direction"
set local_var_dir       "\$5th_axis_direction"
set axis_incr           "\$mom_kin_5th_axis_incr_switch"
set axis_offset_label   "$gPB(machine,axis,offset,5,Label)"
}
default {}
}
UI_PB_mthd_CreateScrollWindow $frame_id axis top_win y
set f [frame $top_win.f]
pack $f -side top -pady 40 -fill both
tixLabelFrame $f.mach      -label "$gPB(machine,axis,rotary,Label)"
tixLabelFrame $f.loffset   -label "$axis_offset_label"
tixLabelFrame $f.rotation  -label "$gPB(machine,axis,rotation,Label)"
tixLabelFrame $f.direction -label "$gPB(machine,axis,direction,Label)"
tixLabelFrame $f.combine   -label "$gPB(machine,axis,con_motion,Label)"
tixLabelFrame $f.action    -label "$gPB(machine,axis,violation,Label)"
tixLabelFrame $f.limits    -label "$gPB(machine,axis,limits,Label)"
frame $f.incr -relief flat -bd 0
checkbutton $f.incr.chk \
-text "$gPB(machine,axis,incr_text)" \
-variable mom_kin_var($axis_incr) \
-onvalue "ON" -offvalue "OFF"
pack $f.incr.chk -anchor w -fill both -expand yes
set fm [$f.mach subwidget frame]
set fo [$f.loffset subwidget frame]
set fr [$f.rotation subwidget frame]
set fd [$f.direction subwidget frame]
set fc [$f.combine subwidget frame]
set fa [$f.action  subwidget frame]
set fl [$f.limits subwidget frame]
if {$n_axis == 4} \
{
switch $machData(1) \
{
"4-Axis" {
UI_PB_mach_ConfigParms $fm 4TH_AXIS
set ftol [frame $fm.lintol]
pack $ftol -anchor w -fill x -padx 5
set positive 1
Page::CreateLblEntry f \$mom_kin_linearization_tol $ftol par_unit \
"$gPB(machine,axis,rotary_lintol,Label)" "$positive" \
"machine,axis,rotary_lintol"
}
"5-Axis" {
UI_PB_mach_CreateRotaryAxisConfig $page_obj $fm
}
}
} else \
{
UI_PB_mach_CreateRotaryAxisConfig $page_obj $fm
}
set min_frm [frame $f.resolution]
Page::CreateLblEntry f $axis_min_incr $min_frm par \
"$gPB(machine,axis,rotary_res,Label)" 1
pack $min_frm -fill x
set minlimit_frm [frame $fl.minlmt]
Page::CreateLblEntry f $axis_min_limit $minlimit_frm par \
"$gPB(machine,axis,limits,min,Label)"
pack $minlimit_frm -fill x
set maxlimit_frm [frame $fl.maxlmt]
Page::CreateLblEntry f $axis_max_limit $maxlimit_frm par \
"$gPB(machine,axis,limits,max,Label)"
pack $maxlimit_frm -fill x
set gPB(c_help,$min_frm.1_par)         "machine,axis,rotary_res"
set gPB(c_help,$minlimit_frm.1_par)    "machine,axis,limits,min"
set gPB(c_help,$maxlimit_frm.1_par)    "machine,axis,limits,max"
set mom_kin_var($axis_rotation) [string tolower $mom_kin_var($axis_rotation)]
radiobutton $fr.normal -text "$gPB(machine,axis,rotation,norm,Label)" \
-width 13 -anchor w \
-variable mom_kin_var($axis_rotation) -value standard
radiobutton $fr.reverse -text "$gPB(machine,axis,rotation,rev,Label)" \
-width 14 -anchor w \
-variable mom_kin_var($axis_rotation) -value reverse
grid $fr.normal $fr.reverse -padx 5 -pady 16
set gPB(c_help,$fr.normal)    "machine,axis,rotation,norm"
set gPB(c_help,$fr.reverse)   "machine,axis,rotation,rev"
set dir_label ""
set dir_opt_list [list "Magnitude Determines Direction" \
"Sign Determines Direction"]
Page::CreateOptionalMenu $local_var_dir $fd opt $dir_opt_list $dir_label
$fd.opt config -command "UI_PB_mach_MapAxisDirection $axis_direction"
set gPB(c_help,[$fd.opt subwidget menubutton]) "machine,axis,direction"
set xoff_frm [frame $fo.xoff]
Page::CreateLblEntry f $axis_center_offset0 $xoff_frm x_asso_unit \
"$gPB(machine,axis,offset,x,Label)"
pack $xoff_frm -fill x
set yoff_frm [frame $fo.yoff]
Page::CreateLblEntry f $axis_center_offset1 $yoff_frm y_asso_unit \
"$gPB(machine,axis,offset,y,Label)"
pack $yoff_frm -fill x
set zoff_frm [frame $fo.zoff]
Page::CreateLblEntry f $axis_center_offset2 $zoff_frm z_asso_unit \
"$gPB(machine,axis,offset,z,Label)"
pack $zoff_frm -fill x
set gPB(c_help,$xoff_frm.1_x)  "machine,axis,offset,x"
set gPB(c_help,$yoff_frm.1_y)  "machine,axis,offset,y"
set gPB(c_help,$zoff_frm.1_z)  "machine,axis,offset,z"
set ang_frm [frame $f.aoffset]
Page::CreateLblEntry f $axis_ang_offset $ang_frm par \
"$gPB(machine,axis,ang_offset,Label)"
if {[info exists ::env(INCH_METRIC)] && $::env(INCH_METRIC) == 1} {
global axisoption
if ![string match "3MT" $axisoption] {
if {$::tcl_version == "8.4"} {
pack $ang_frm.1_par -padx [expr $::paOption(unit_width) + 10]
} else {
pack $ang_frm.1_par -padx $::paOption(unit_width)
}
}
}
set dist_frm [frame $f.dist]
global axisoption
if [string match "3MT" $axisoption] {
set dir_label "$gPB(machine,axis,radius_output,Label)"
set dir_opt_list [list "Shortest Distance" \
"Always Positive" \
"Always Negative"]
set local_var "\$mom_sys_radius_output_mode"
Page::CreateOptionalMenu $local_var $dist_frm opt $dir_opt_list $dir_label
set gPB(c_help,[$dist_frm.opt subwidget menubutton])     "machine,axis,radius_output"
} else {
Page::CreateLblEntry f $axis_pivot_offset $dist_frm par_asso_unit \
"$gPB(machine,axis,pivot,Label)"
if {[info exists ::env(INCH_METRIC)] && $::env(INCH_METRIC) == 1} {
if {$::tcl_version == "8.4"} {
pack $dist_frm.unit_lbl -padx [list 0 [expr $::paOption(unit_width) - 17]]
}
}
set gPB(c_help,$dist_frm.1_par)     "machine,axis,pivot"
}
set dpm_frm [frame $f.dpm]
Page::CreateLblEntry f $axis_max_dpm $dpm_frm par \
"$gPB(machine,axis,max_feed,Label)" 1
set gPB(c_help,$ang_frm.1_par)      "machine,axis,ang_offset"
set gPB(c_help,$dpm_frm.1_par)      "machine,axis,max_feed"
checkbutton $fc.rotary_motion \
-text "$gPB(machine,axis,con_motion,combine,Label)" \
-variable mom_kin_var(\$mom_kin_linearization_flag) \
-command "UI_PB_mach_SetTolState $fc"
pack $fc.rotary_motion -anchor w
set tol_frm [frame $fc.tol]
Page::CreateLblEntry f \$mom_kin_linearization_tol $tol_frm par \
"$gPB(machine,axis,con_motion,tol,Label)" 1
pack $tol_frm -fill x
set gPB(c_help,$fc.rotary_motion) "machine,axis,con_motion,combine"
set gPB(c_help,$tol_frm.1_par)    "machine,axis,con_motion,tol"
radiobutton $fa.warning -text "$gPB(machine,axis,violation,warn,Label)" \
-width 27 -anchor w \
-variable mom_kin_var($axis_limit_action) \
-value Warning
radiobutton $fa.ret -text "$gPB(machine,axis,violation,ret,Label)" \
-width 27 -anchor w \
-variable mom_kin_var($axis_limit_action) \
-value "Retract / Re-Engage"
set gPB(c_help,$fa.warning)    "machine,axis,violation,warn"
set gPB(c_help,$fa.ret)        "machine,axis,violation,ret"
grid $fa.warning       -sticky w -padx 5 -pady 2
grid $fa.ret           -sticky w -padx 5 -pady 2
grid $f.mach       $f.loffset   -padx 5 -pady 5 -sticky news
grid $f.resolution $f.dist      -padx 5 -pady 5 -sticky ew
grid $f.dpm        $f.aoffset   -padx 5 -pady 5 -sticky ew
grid $f.rotation   $f.direction -padx 5 -pady 5 -sticky news
if { $n_axis == 4 } \
{
switch $machData(1) \
{
"4-Axis" {
grid $f.limits     $f.action    -padx 5 -pady 5 -sticky news
}
"5-Axis" {
grid $f.limits  -padx 5 -pady 5 -sticky news
}
}
} else {
grid $f.limits  -padx 5 -pady 5 -sticky news
}
grid $f.incr      -padx 5 -pady 10 -sticky w
set ff [frame $frame_id.ff]
pack $ff -side bottom -padx 3 -pady 3 -fill x
UI_PB_mach_AddActionButtons page_obj $ff $axis_param
if ![string compare $::tix_version 8.4] {
UI_PB_mthd_WheelForFrame $frame_id.axis.sf
}
}
proc __mach_MapMillTurnSpindleAxis { w_yaxis args } {
global mom_sys_arr
if { [llength $args] > 0 } {
set option [lindex $args 0]
} else {
set option $mom_sys_arr(\$mill_turn_spindle_axis)
}
switch "\"$option\"" {
"\"Z_Axis\"" {
set mom_sys_arr(\$mom_sys_spindle_axis(0)) 0.0
set mom_sys_arr(\$mom_sys_spindle_axis(1)) 0.0
set mom_sys_arr(\$mom_sys_spindle_axis(2)) 1.0
}
"\"+X_Axis\"" {
set mom_sys_arr(\$mom_sys_spindle_axis(0)) 1.0
set mom_sys_arr(\$mom_sys_spindle_axis(1)) 0.0
set mom_sys_arr(\$mom_sys_spindle_axis(2)) 0.0
}
"\"-X_Axis\"" {
set mom_sys_arr(\$mom_sys_spindle_axis(0)) -1.0
set mom_sys_arr(\$mom_sys_spindle_axis(1)) 0.0
set mom_sys_arr(\$mom_sys_spindle_axis(2)) 0.0
}
"\"Y_Axis\"" {
set mom_sys_arr(\$mom_sys_spindle_axis(0)) 0.0
set mom_sys_arr(\$mom_sys_spindle_axis(1)) 1.0
set mom_sys_arr(\$mom_sys_spindle_axis(2)) 0.0
}
}
global mom_kin_var
foreach i { 0 1 2 } {
set mom_kin_var(\$mom_kin_spindle_axis($i)) $mom_sys_arr(\$mom_sys_spindle_axis\($i\))
}
if [winfo exists $w_yaxis] {
set option [string toupper $option]
if [string match "Z_AXIS" $option] {
set mom_sys_arr(\$mom_sys_millturn_yaxis) FALSE
$w_yaxis config -state disabled
} else {
$w_yaxis config -state normal
}
}
}
proc UI_PB_mach_MapAxisDirection { axis_direction sel_value } {
global mom_kin_var
set mom_kin_var($axis_direction) \
[string toupper $sel_value]
}
proc UI_PB_mach_SetTolState { fc } {
global mom_kin_var
global gPB
set e $fc.tol.1_par
if { $mom_kin_var(\$mom_kin_linearization_flag) } \
{
$e config -state normal
set positive 1
bind $e <KeyPress> "UI_PB_com_ValidateDataOfEntry %W %K f $positive"
bind $e <KeyRelease> { %W config -state normal }
} else \
{
$e config -state disabled
bind $e <KeyPress> ""
bind $e <KeyRelease> ""
}
}
proc UI_PB_mach_AddActionButtons { PAGE_OBJ frame_id axis_param } {
upvar $PAGE_OBJ page_obj
global paOption
set label_list {"gPB(nav_button,default,Label)" \
"gPB(nav_button,restore,Label)"}
set cb_arr(gPB(nav_button,default,Label)) \
"UI_PB_mach_DefaultCallBack $page_obj $axis_param"
set cb_arr(gPB(nav_button,restore,Label)) \
"UI_PB_mach_RestoreCallBack $page_obj $axis_param"
UI_PB_com_CreateButtonBox $frame_id label_list cb_arr
}
proc UI_PB_mach_CreateRotaryAxisConfig { page_obj frame_id } {
global gPB
set bb [tixButtonBox $frame_id.bb -orientation horizontal]
switch $::tix_version {
8.4 {
$bb config -relief sunken -bd 1 -bg royalBlue -pady 0 -padx 2 ;#<12-17-07 gsl> -padx was 0.
}
4.1 {
$bb config -relief sunken -bd 1 -bg royalBlue -pady 5
}
}
$bb add spec -text "$gPB(machine,axis,config,Label)" -width 20
grid $bb
set b [$bb subwidget spec]
$b config -command "UI_PB_mach_ConfigRotaryAxisWin $page_obj $b"
set gPB(c_help,$b)  "machine,axis,config"
}
proc UI_PB_mach_ConfigRotaryAxisWin { page_obj frame_id } {
global gPB
set canvas_frame $Page::($page_obj,canvas_frame)
set w $canvas_frame.axis_config
toplevel $w
set toplevel_index [llength $gPB(toplevel_list)]
set win_index [expr $toplevel_index + 1]
set gPB(toplevel_disable_$win_index) 1
UI_PB_com_CreateTransientWindow $w \
"$gPB(machine,axis,r_axis_conf_trans,Label)" "+500+300" \
"" "UI_PB_mach_DisableMachPageWidgets $page_obj" "" \
"UI_PB_mach_ActivateMachPageWidgets $page_obj $win_index"
set page_frm [frame $w.f1 -relief sunken -bd 1]
pack $page_frm -fill both -expand yes -padx 3 -pady 3
UI_PB_mach_ConfigRotaryAxisParms $page_frm
set frame [frame $w.f2]
pack $frame -side bottom -fill x -padx 3 -pady 3
UI_PB_mach_ConfigRotaryAxisNavButtons $w $frame
UI_PB_com_PositionWindow $w
}
proc UI_PB_mach_ConfigRotaryAxisParms { widget_id } {
global tixOption
global paOption
global machData
global mom_kin_var
global gPB
tixLabelFrame $widget_id.4th      -label "$gPB(machine,axis,4th_axis,Label)"
tixLabelFrame $widget_id.5th      -label "$gPB(machine,axis,5th_axis,Label)"
grid $widget_id.4th $widget_id.5th -padx 10 -pady 20
set f4 [$widget_id.4th subwidget frame]
set f5 [$widget_id.5th subwidget frame]
UI_PB_mach_ConfigParms $f4 4TH_AXIS
UI_PB_mach_ConfigParms $f5 5TH_AXIS
set fm [frame $widget_id.lintol]
grid $fm - -pady 10
set positive 1
Page::CreateLblEntry f \$mom_kin_linearization_tol $fm par_unit \
"$gPB(machine,axis,rotary_lintol,Label)" "$positive" \
"machine,axis,rotary_lintol"
tixLabelFrame $widget_id.limit -label "$gPB(machine,axis,violation,Label)"
grid $widget_id.limit - -padx 10 -pady 20
set fa [$widget_id.limit subwidget frame]
set axis_limit_action   "\$mom_kin_4th_axis_limit_action"
radiobutton $fa.warning -text "$gPB(machine,axis,violation,warn,Label)" \
-width 27 -anchor w \
-variable mom_kin_var($axis_limit_action) \
-value Warning
radiobutton $fa.ret -text "$gPB(machine,axis,violation,ret,Label)" \
-width 27 -anchor w \
-variable mom_kin_var($axis_limit_action) \
-value "Retract / Re-Engage"
set gPB(c_help,$fa.warning)    "machine,axis,violation,warn"
set gPB(c_help,$fa.ret)        "machine,axis,violation,ret"
grid $fa.warning       -sticky w -padx 5 -pady 2
grid $fa.ret           -sticky w -padx 5 -pady 2
}
proc UI_PB_mach_ConfigParms { frame_id axis_type } {
global paOption
global mom_kin_var
global gPB
if { $axis_type == "4TH_AXIS" } \
{
set AXIS \$mom_kin_4th_axis
} else \
{
set AXIS \$mom_kin_5th_axis
}
set temp_name $mom_kin_var($AXIS\_plane)
append head_var $AXIS _type
switch $mom_kin_var($head_var) {
"Head" {
set lbl $gPB(machine,axis,head,Label)
}
"Table" {
set lbl $gPB(machine,axis,table,Label)
}
}
global tixOption
label $frame_id.type -text "$lbl" \
-font $tixOption(bold_font) \
-fg $paOption(special_fg) -bg $paOption(special_bg)
set plane_axis_list {XY YZ ZX Other}
append plane_type $AXIS _plane
set plane_frm [frame $frame_id.plane]
Page::CreateOptionalMenu $plane_type $plane_frm opt $plane_axis_list \
"$gPB(machine,axis,plane,Label)"
if {[info exists ::env(INCH_METRIC)] && $::env(INCH_METRIC) == 1} {
set mb [$plane_frm.opt subwidget menubutton]
pack $mb -padx [expr $::paOption(unit_width) - 5]
}
set mom_kin_var($plane_type) $temp_name
$plane_frm.opt config -command "UI_PB_mach_SetPlaneNormalVector $axis_type"
UI_PB_mach_SetPlaneNormalVector $axis_type
[$plane_frm.opt subwidget menu] entryconfig 3 -command "__mach_InquirePlaneNormalVector $axis_type"
if { [PB_is_ver 3.4] == 0 } {
if { [info exists gPB(HIGHLIGHT_NEW_FEATURE)] && $gPB(HIGHLIGHT_NEW_FEATURE) } {
[$plane_frm.opt subwidget menubutton]  config -background $gPB(NEW_FEATURE_COLOR)
[$plane_frm.opt subwidget menu] entryconfig 3 -background $gPB(NEW_FEATURE_COLOR)
}
}
global axisoption
if [string match "3MT" $axisoption] {
set mom_kin_var($plane_type) "XY"
[$plane_frm.opt subwidget menubutton] config -state disabled -bg $paOption(disabled_fg)
}
set f [frame $frame_id.address]
append rotary_leader $AXIS _leader
label $f.lbl -text "$gPB(machine,axis,leader,Label)"
entry $f.ent -textvariable mom_kin_var($rotary_leader) \
-cursor hand2 \
-width 5 -borderwidth 4 \
-highlightcolor $paOption(focus) \
-background $paOption(header_bg) \
-foreground $paOption(seq_bg) \
-selectbackground $paOption(focus) \
-selectforeground black
set menu [menu $f.pop1 -tearoff 0]
bind $f.ent <1> "focus %W"
bind $f.ent <3> "focus %W"
bind $f.ent <3> "+tk_popup $menu %X %Y"
set options_list {A B C D E F G H I J K L M N O \
P Q R S T U V W X Y Z "gPB(address,none_popup,Label)"}
__mach_AddLeaderPopupOptions  menu options_list $f.ent $rotary_leader $axis_type
pack $f.lbl -side left  -padx 3 -pady 3; #<01-02-08 peter> -padx was 2
pack $f.ent -side right -padx $::paOption(unit_width) -pady 4; #<01-02-08 peter> -padx was 2
pack $frame_id.type -anchor w -padx 5 -pady 2
pack $frame_id.plane -anchor w -padx 5 -fill x
pack $frame_id.address -anchor w -padx 5 -fill x
if 0 {
grid $frame_id.type                 -sticky w  -padx 5
grid $frame_id.plane      -         -sticky ewsn -padx 5
grid $frame_id.address    -         -sticky ew -padx 5
}
set gPB(c_help,[$plane_frm.opt subwidget menubutton])  "machine,axis,plane"
set gPB(c_help,$f.ent)      "machine,axis,leader"
}
proc UI_PB_mach_SetPlaneNormalVector { axis_type args } {
global mom_kin_var
global gPB
if [string match "4TH_AXIS" $axis_type] {
set plane $mom_kin_var(\$mom_kin_4th_axis_plane)
} else {
set plane $mom_kin_var(\$mom_kin_5th_axis_plane)
}
switch $plane {
"XY" {
set vi 0
set vj 0
set vk 1
}
"YZ" {
set vi 1
set vj 0
set vk 0
}
"ZX" {
set vi 0
set vj 1
set vk 0
}
default {
return
}
}
if [string match "4TH_AXIS" $axis_type] {
set mom_kin_var(\$mom_kin_4th_axis_vector(0)) $vi
set mom_kin_var(\$mom_kin_4th_axis_vector(1)) $vj
set mom_kin_var(\$mom_kin_4th_axis_vector(2)) $vk
} else {
set mom_kin_var(\$mom_kin_5th_axis_vector(0)) $vi
set mom_kin_var(\$mom_kin_5th_axis_vector(1)) $vj
set mom_kin_var(\$mom_kin_5th_axis_vector(2)) $vk
}
}
proc __mach_InquirePlaneNormalVector { axis_type args } {
global mom_kin_var
global gPB
set display_dialog 1
if $display_dialog {
__mach_PlaneNormalSetRestore $axis_type
set win [UI_PB_com_AskActiveWindow].plane_normal
toplevel $win
UI_PB_com_CreateTransientWindow $win \
"$gPB(machine,axis,plane,normal,Label)" "+400+200" "" "" "" ""
set frm [frame $win.frm -relief sunken -bd 1]
pack $frm -fill both -expand yes -padx 3 -pady 3
if [string match "4TH_AXIS" $axis_type] {
tixLabelFrame $frm.vec -label "$gPB(machine,axis,plane,4th,Label)"
} else {
tixLabelFrame $frm.vec -label "$gPB(machine,axis,plane,5th,Label)"
}
pack $frm.vec -padx 20 -pady 20
if { [PB_is_ver 3.4] == 0 } {
if { [info exists gPB(HIGHLIGHT_NEW_FEATURE)] && $gPB(HIGHLIGHT_NEW_FEATURE) } {
$frm.vec config -background $gPB(NEW_FEATURE_COLOR)
}
}
set vec [$frm.vec subwidget frame]
set fi [frame $vec.fi]
set fj [frame $vec.fj]
set fk [frame $vec.fk]
if [string match "4TH_AXIS" $axis_type] {
UI_PB_mthd_CreateLblEntry f \$mom_kin_4th_axis_vector(0) $fi i "I"
UI_PB_mthd_CreateLblEntry f \$mom_kin_4th_axis_vector(1) $fj j "J"
UI_PB_mthd_CreateLblEntry f \$mom_kin_4th_axis_vector(2) $fk k "K"
} else {
UI_PB_mthd_CreateLblEntry f \$mom_kin_5th_axis_vector(0) $fi i "I"
UI_PB_mthd_CreateLblEntry f \$mom_kin_5th_axis_vector(1) $fj j "J"
UI_PB_mthd_CreateLblEntry f \$mom_kin_5th_axis_vector(2) $fk k "K"
}
pack $fi -fill x
pack $fj -fill x
pack $fk -fill x
set fb [frame $win.fb]
pack $fb -side bottom -fill x -padx 3 -pady 3
__mach_ConfigPlaneNormalNavButtons $win $fb $axis_type
UI_PB_com_PositionWindow $win
set gPB(c_help,$frm.vec)  "machine,axis,plane,normal"
}
}
proc __mach_ConfigPlaneNormalNavButtons { win frame axis_type } {
set cb_arr(gPB(nav_button,default,Label)) "__mach_PlaneNormalDefCallBack $axis_type"
set cb_arr(gPB(nav_button,restore,Label)) "__mach_PlaneNormalResCallBack $axis_type"
set cb_arr(gPB(nav_button,cancel,Label)) \
"__mach_PlaneNormalCancCallBack $win $axis_type"
set cb_arr(gPB(nav_button,ok,Label))     \
"__mach_PlaneNormalOkCallBack   $win $axis_type"
UI_PB_com_CreateActionElems $frame cb_arr
}
proc __mach_PlaneNormalCancCallBack { win axis_type } {
__mach_PlaneNormalResCallBack $axis_type
destroy $win
}
proc __mach_PlaneNormalResCallBack { axis_type } {
global mom_kin_var
global rest_mom_kin_var
if [string match "4TH_AXIS" $axis_type] {
set mom_kin_var(\$mom_kin_4th_axis_vector(0)) \
$rest_mom_kin_var(\$mom_kin_4th_axis_vector\(0\))
set mom_kin_var(\$mom_kin_4th_axis_vector(1)) \
$rest_mom_kin_var(\$mom_kin_4th_axis_vector\(1\))
set mom_kin_var(\$mom_kin_4th_axis_vector(2)) \
$rest_mom_kin_var(\$mom_kin_4th_axis_vector\(2\))
} else {
set mom_kin_var(\$mom_kin_5th_axis_vector(0)) \
$rest_mom_kin_var(\$mom_kin_5th_axis_vector\(0\))
set mom_kin_var(\$mom_kin_5th_axis_vector(1)) \
$rest_mom_kin_var(\$mom_kin_5th_axis_vector\(1\))
set mom_kin_var(\$mom_kin_5th_axis_vector(2)) \
$rest_mom_kin_var(\$mom_kin_5th_axis_vector\(2\))
}
}
proc __mach_PlaneNormalDefCallBack { axis_type } {
PB_int_RetDefKinVars def_mom_kin_var
global mom_kin_var
if [string match "4TH_AXIS" $axis_type] {
set mom_kin_var(\$mom_kin_4th_axis_vector(0)) \
$def_mom_kin_var(\$mom_kin_4th_axis_vector\(0\))
set mom_kin_var(\$mom_kin_4th_axis_vector(1)) \
$def_mom_kin_var(\$mom_kin_4th_axis_vector\(1\))
set mom_kin_var(\$mom_kin_4th_axis_vector(2)) \
$def_mom_kin_var(\$mom_kin_4th_axis_vector\(2\))
} else {
set mom_kin_var(\$mom_kin_5th_axis_vector(0)) \
$def_mom_kin_var(\$mom_kin_5th_axis_vector\(0\))
set mom_kin_var(\$mom_kin_5th_axis_vector(1)) \
$def_mom_kin_var(\$mom_kin_5th_axis_vector\(1\))
set mom_kin_var(\$mom_kin_5th_axis_vector(2)) \
$def_mom_kin_var(\$mom_kin_5th_axis_vector\(2\))
}
}
proc __mach_PlaneNormalOkCallBack { win axis_type } {
set ret_code [__mach_PlaneNormalAppCallBack $axis_type]
if { $ret_code == "TCL_OK" } \
{
destroy $win
}
}
proc __mach_PlaneNormalAppCallBack { axis_type } {
global mom_kin_var
global rest_mom_kin_var
__mach_PlaneNormalSetRestore $axis_type
set axis [string tolower $axis_type]
global mom_kin_var
set mom_kin_var(\$mom_kin_${axis}_plane) "Other"
return TCL_OK
}
proc __mach_PlaneNormalSetRestore { axis_type } {
global mom_kin_var
global rest_mom_kin_var
if [string match "4TH_AXIS" $axis_type] {
set rest_mom_kin_var(\$mom_kin_4th_axis_vector(0)) \
$mom_kin_var(\$mom_kin_4th_axis_vector\(0\))
set rest_mom_kin_var(\$mom_kin_4th_axis_vector(1)) \
$mom_kin_var(\$mom_kin_4th_axis_vector\(1\))
set rest_mom_kin_var(\$mom_kin_4th_axis_vector(2)) \
$mom_kin_var(\$mom_kin_4th_axis_vector\(2\))
} else {
set rest_mom_kin_var(\$mom_kin_5th_axis_vector(0)) \
$mom_kin_var(\$mom_kin_5th_axis_vector\(0\))
set rest_mom_kin_var(\$mom_kin_5th_axis_vector(1)) \
$mom_kin_var(\$mom_kin_5th_axis_vector\(1\))
set rest_mom_kin_var(\$mom_kin_5th_axis_vector(2)) \
$mom_kin_var(\$mom_kin_5th_axis_vector\(2\))
}
}
proc __mach_AddLeaderPopupOptions { MENU OPTIONS_LIST ent_widget var axis_type} {
upvar $MENU menu
upvar $OPTIONS_LIST options_list
global mom_kin_var
global gPB
set count 1
foreach ELEMENT $options_list \
{
if {$ELEMENT == "gPB(address,none_popup,Label)"} \
{
$menu add command -label [set $ELEMENT] \
-command " __mach_UpdateLeaderEntry $ent_widget \"\" \\$var $axis_type "
} else \
{
if {$count == 1} \
{
$menu add command -label $ELEMENT -columnbreak 1 \
-command " __mach_UpdateLeaderEntry $ent_widget $ELEMENT \\$var $axis_type "
} else \
{
$menu add command -label $ELEMENT \
-command " __mach_UpdateLeaderEntry $ent_widget $ELEMENT \\$var $axis_type "
}
}
if {$count == 9} \
{
set count 0
}
incr count
}
}
proc __mach_UpdateLeaderEntry { ent_widget str var axis_type } {
global mom_kin_var
global gpb_addr_var
$ent_widget delete 0 end
$ent_widget insert 0 "$str"
set mom_kin_var($var) "$str"
if { $axis_type == "4TH_AXIS" } {
set add_name "fourth_axis"
} elseif { $axis_type == "5TH_AXIS" } {
set add_name "fifth_axis"
} else {
return TCL_ERROR
}
set gpb_addr_var($add_name,leader_name) "$str"
}
proc UI_PB_mach_ConfigRotaryAxisNavButtons { win frame } {
set cb_arr(gPB(nav_button,default,Label)) "UI_PB_mach_RotaryDefCallBack"
set cb_arr(gPB(nav_button,restore,Label)) "UI_PB_mach_RotaryResCallBack"
set cb_arr(gPB(nav_button,cancel,Label)) \
"UI_PB_mach_RotaryCancCallBack $win"
set cb_arr(gPB(nav_button,ok,Label))  \
"UI_PB_mach_RotaryOkCallBack $win"
UI_PB_com_CreateActionElems $frame cb_arr
}
proc UI_PB_mach_RotaryCancCallBack { win } {
UI_PB_mach_RotaryResCallBack
destroy $win
}
proc UI_PB_mach_RotaryResCallBack { } {
global mom_kin_var
global rest_mom_kin_var
set mom_kin_var(\$mom_kin_4th_axis_type) \
$rest_mom_kin_var(\$mom_kin_4th_axis_type)
set mom_kin_var(\$mom_kin_4th_axis_plane) \
$rest_mom_kin_var(\$mom_kin_4th_axis_plane)
set mom_kin_var(\$mom_kin_4th_axis_leader) \
$rest_mom_kin_var(\$mom_kin_4th_axis_leader)
set mom_kin_var(\$mom_kin_5th_axis_type) \
$rest_mom_kin_var(\$mom_kin_5th_axis_type)
set mom_kin_var(\$mom_kin_5th_axis_plane) \
$rest_mom_kin_var(\$mom_kin_5th_axis_plane)
set mom_kin_var(\$mom_kin_5th_axis_leader) \
$rest_mom_kin_var(\$mom_kin_5th_axis_leader)
set mom_kin_var(\$mom_kin_linearization_tol) \
$rest_mom_kin_var(\$mom_kin_linearization_tol)
}
proc UI_PB_mach_RotaryAppCallBack { } {
global mom_kin_var
global rest_mom_kin_var
global gpb_addr_var
set ret_code [ValidateMachObjAttr 5]
if { $ret_code == "TCL_ERROR" } { return TCL_ERROR }
set rest_mom_kin_var(\$mom_kin_4th_axis_type) \
$mom_kin_var(\$mom_kin_4th_axis_type)
set rest_mom_kin_var(\$mom_kin_4th_axis_plane) \
$mom_kin_var(\$mom_kin_4th_axis_plane)
set rest_mom_kin_var(\$mom_kin_4th_axis_leader) \
$mom_kin_var(\$mom_kin_4th_axis_leader)
set add_name "fourth_axis"
PB_int_RetAddrObjFromName add_name fourth_add_obj
set address::($fourth_add_obj,add_leader) \
$mom_kin_var(\$mom_kin_4th_axis_leader)
set gpb_addr_var($add_name,leader_name) $mom_kin_var(\$mom_kin_4th_axis_leader)
set rest_mom_kin_var(\$mom_kin_5th_axis_type) \
$mom_kin_var(\$mom_kin_5th_axis_type)
set rest_mom_kin_var(\$mom_kin_5th_axis_plane) \
$mom_kin_var(\$mom_kin_5th_axis_plane)
set rest_mom_kin_var(\$mom_kin_5th_axis_leader) \
$mom_kin_var(\$mom_kin_5th_axis_leader)
set add_name "fifth_axis"
PB_int_RetAddrObjFromName add_name fifth_add_obj
set address::($fifth_add_obj,add_leader) \
$mom_kin_var(\$mom_kin_5th_axis_leader)
set gpb_addr_var($add_name,leader_name) $mom_kin_var(\$mom_kin_5th_axis_leader)
set rest_mom_kin_var(\$mom_kin_linearization_tol) \
$mom_kin_var(\$mom_kin_linearization_tol)
return TCL_OK
}
proc UI_PB_mach_RotaryDefCallBack { } {
PB_int_RetDefKinVars def_mom_kin_var
global mom_kin_var
set mom_kin_var(\$mom_kin_4th_axis_type) \
$def_mom_kin_var(\$mom_kin_4th_axis_type)
set mom_kin_var(\$mom_kin_4th_axis_plane) \
$def_mom_kin_var(\$mom_kin_4th_axis_plane)
set mom_kin_var(\$mom_kin_4th_axis_leader) \
$def_mom_kin_var(\$mom_kin_4th_axis_leader)
set mom_kin_var(\$mom_kin_5th_axis_type) \
$def_mom_kin_var(\$mom_kin_5th_axis_type)
set mom_kin_var(\$mom_kin_5th_axis_plane) \
$def_mom_kin_var(\$mom_kin_5th_axis_plane)
set mom_kin_var(\$mom_kin_5th_axis_leader) \
$def_mom_kin_var(\$mom_kin_5th_axis_leader)
set mom_kin_var(\$mom_kin_linearization_tol) \
$def_mom_kin_var(\$mom_kin_linearization_tol)
}
proc UI_PB_mach_RotaryOkCallBack { win } {
set ret_code [UI_PB_mach_RotaryAppCallBack]
if { $ret_code == "TCL_OK" } \
{
destroy $win
}
}
proc UI_PB_mach_DefaultCallBack { page_obj axis_param } {
global mom_kin_var
global mom_sys_arr
if {[string compare $axis_param "general_param"] == 0} \
{
set mom_var_list $Page::($page_obj,general_param)
} elseif { [string compare $axis_param "axis_4th_param"] == 0 } \
{
set mom_var_list $Page::($page_obj,axis_4th_param)
} else \
{
set mom_var_list $Page::($page_obj,axis_5th_param)
}
PB_int_RetDefKinVarValues mom_var_list def_mom_kin_var
foreach kin_var $mom_var_list \
{
if { [string match "\$mom_kin*" $kin_var] } \
{
set mom_kin_var($kin_var) $def_mom_kin_var($kin_var)
} else \
{
set mom_sys_arr($kin_var) $def_mom_kin_var($kin_var)
}
}
if { [info exists Page::($page_obj,xzc_spindle_yaxis_frm)] && \
[winfo exists $Page::($page_obj,xzc_spindle_yaxis_frm)] } {
__mach_MapMillTurnSpindleAxis $Page::($page_obj,xzc_spindle_yaxis_frm)
}
if { [info exists Page::($page_obj,xzc_lathe_post_frm)] && \
[winfo exists $Page::($page_obj,xzc_lathe_post_frm)] } {
__mach_ToggleLathePostEntry $Page::($page_obj,xzc_lathe_post_frm)
}
}
proc UI_PB_mach_RestoreCallBack { page_obj axis_param } {
global mom_kin_var
global mom_sys_arr
global rest_mom_kin_var
global rest_mom_sys_arr
if {[string compare $axis_param "general_param"] == 0} \
{
set mom_var_list $Page::($page_obj,general_param)
} elseif { [string compare $axis_param "axis_4th_param"] == 0 } \
{
set mom_var_list $Page::($page_obj,axis_4th_param)
} else \
{
set mom_var_list $Page::($page_obj,axis_5th_param)
}
foreach kin_var $mom_var_list \
{
if { [string match "\$mom_kin*" $kin_var] } \
{
set mom_kin_var($kin_var) $rest_mom_kin_var($kin_var)
} else \
{
set mom_sys_arr($kin_var) $rest_mom_sys_arr($kin_var)
}
}
if { [info exists Page::($page_obj,xzc_spindle_yaxis_frm)] && \
[winfo exists $Page::($page_obj,xzc_spindle_yaxis_frm)] } {
__mach_MapMillTurnSpindleAxis $Page::($page_obj,xzc_spindle_yaxis_frm)
}
if { [info exists Page::($page_obj,xzc_lathe_post_frm)] && \
[winfo exists $Page::($page_obj,xzc_lathe_post_frm)] } {
__mach_ToggleLathePostEntry $Page::($page_obj,xzc_lathe_post_frm)
}
}
set w 0
proc DisplayMachImage {} {
global w
if {[winfo exists $w]} \
{
if {[wm state $w] == "iconic"}\
{
wm deiconify $w
} else\
{
raise $w
focus $w
}
} else \
{
UI_PB_mach_AddMachImage
}
}
proc UI_PB_mach_AddMachImage {} {
global paOption
global machData
global w
global machType axisoption
global mom_kin_var
global imagefile ImageWindowText
global 4x1 4y1 4x2 4y2 4ax1 4ay1 4ax2 4ay2 4sx 4sy
global 5x1 5y1 5x2 5y2 5ax1 5ay1 5ax2 5ay2 5sx 5sy
global 5ox 5oy
if {[info exists w]} {
destroy $w
}
set imagefile ""
ConstructMachDisplayParameters
global gPB
if { $imagefile == "" } {
tk_messageBox -parent [UI_PB_com_AskActiveWindow] -type ok \
-icon question \
-message "$gPB(msg,no_display)"
return
}
set w $gPB(active_window).mach_image
toplevel $w
if ![string compare $::tix_version 8.4] {
bind all <MouseWheel> {}
bind all <Shift-MouseWheel> {}
wm protocol $w WM_DELETE_WINDOW { bind all <MouseWheel> [list UI_PB_mthd_MouseWheel %W %D %X %Y]; \
bind all <Shift-MouseWheel> [list UI_PB_mthd_MouseWheel %W %D %X %Y x] ; \
tk_focusFollowsMouse; destroy $w}
bind all <Enter> {}
}
wm title $w "$gPB(show_mt,title,Label)"
wm geometry $w 800x700+300+200
label $w.lab  -justify left -text $ImageWindowText
pack $w.lab -anchor c -padx 10 -pady 6
tixCObjView $w.c
pack $w.c -expand yes -fill both -padx 4 -pady 2
image create photo machphoto -file $imagefile
[$w.c subwidget canvas] create image 390 340 -image machphoto \
-anchor c
if { $machType == "Mill"  &&  $axisoption != "3" } {
set 4xmin $mom_kin_var(\$mom_kin_4th_axis_min_limit)
set 4xmax $mom_kin_var(\$mom_kin_4th_axis_max_limit)
set 4dire $mom_kin_var(\$mom_kin_4th_axis_rotation)
set 4address $mom_kin_var(\$mom_kin_4th_axis_leader)
if { $4dire == "standard" } {
set 4sign +$4address
} else {
set 4sign -$4address
}
if { $4dire == "standard" } {
[$w.c subwidget canvas] create text $4x1 $4y1 -text $4xmin \
-fill $paOption(special_fg) -font {helvetica 18 bold}
[$w.c subwidget canvas] create text $4x2 $4y2 -text $4xmax \
-fill $paOption(special_fg) -font {helvetica 18 bold}
} else {
[$w.c subwidget canvas] create text $4x2 $4y2 -text $4xmin \
-fill $paOption(special_fg) -font {helvetica 18 bold}
[$w.c subwidget canvas] create text $4x1 $4y1 -text $4xmax \
-fill $paOption(special_fg) -font {helvetica 18 bold}
}
eval {[$w.c subwidget canvas] create line} {$4ax1 $4ay1 $4ax2 $4ay2} \
{-tag arrow -arrow last -arrowshape [list 20 25 8] -fill yellow}
[$w.c subwidget canvas] create text $4sx $4sy -text $4sign \
-fill $paOption(special_fg) -font {helvetica 22 bold}
if { $axisoption == "5HH" || \
$axisoption == "5TT" || \
$axisoption == "5HT" } {
set 5xmin $mom_kin_var(\$mom_kin_5th_axis_min_limit)
set 5xmax $mom_kin_var(\$mom_kin_5th_axis_max_limit)
set 5dire $mom_kin_var(\$mom_kin_5th_axis_rotation)
set 5address $mom_kin_var(\$mom_kin_5th_axis_leader)
if { $5dire == "standard" } {
set 5sign +$5address
} else {
set 5sign -$5address
}
if { $5dire == "standard" } {
[$w.c subwidget canvas] create text $5x1 $5y1 -text $5xmin \
-fill $paOption(special_fg) -font {helvetica 18 bold}
[$w.c subwidget canvas] create text $5x2 $5y2 -text $5xmax \
-fill $paOption(special_fg) -font {helvetica 18 bold}
} else {
[$w.c subwidget canvas] create text $5x2 $5y2 -text $5xmin \
-fill $paOption(special_fg) -font {helvetica 18 bold}
[$w.c subwidget canvas] create text $5x1 $5y1 -text $5xmax \
-fill $paOption(special_fg) -font {helvetica 18 bold}
}
eval {[$w.c subwidget canvas] create line} \
{$5ax1 $5ay1 $5ax2 $5ay2} \
{-tag arrow -arrow last -arrowshape [list 20 25 8] -fill yellow}
[$w.c subwidget canvas] create text $5sx $5sy -text $5sign \
-fill $paOption(special_fg) -font {helvetica 22 bold}
if { $axisoption == "5TT" } {
if { $mom_kin_var(\$mom_kin_5th_axis_plane) == "ZX" } {
set offset $mom_kin_var(\$mom_kin_5th_axis_center_offset\(1\))
} elseif { $mom_kin_var(\$mom_kin_5th_axis_plane) == "XY" } {
set offset $mom_kin_var(\$mom_kin_5th_axis_center_offset\(2\))
} elseif {  $mom_kin_var(\$mom_kin_5th_axis_plane) == "YZ" } {
set offset $mom_kin_var(\$mom_kin_5th_axis_center_offset\(0\))
} else {
set offset "???"
}
[$w.c subwidget canvas] create text $5ox $5oy -text $offset \
-fill $paOption(special_fg) -font {helvetica 18 bold}
}
}
}
$w.c adjustscrollregion
UI_PB_com_PositionWindow $w
}
proc ConstructMachDisplayParameters { } {
global machType axisoption
global imagefile directory
global ImageWindowText
global env
global gPB
set directory "$env(PB_HOME)/images/mach_tool/"
switch $machType \
{
"Mill" \
{
switch -- $axisoption \
{
"3" {
set ImageWindowText [list $gPB(new,axis_3,Label) $gPB(new,mill,Label)]
append imagefile $directory pb_m3x_v.gif
}
"4T" -
"4H" {
global mom_kin_var
if { [info exists mom_kin_var(\$mom_kin_4th_axis_plane)] &&\
[string match "Other" $mom_kin_var(\$mom_kin_4th_axis_plane)] } {
return
}
if { [ValidateMachObjAttr 4] == "TCL_ERROR" } { return }
set ImageWindowText [list $gPB(new,axis_4,Label) $gPB(new,mill,Label)]
Construct4thAxisDisplayParameter
}
"5HH" -
"5TT" -
"5HT" {
global mom_kin_var
if { [info exists mom_kin_var(\$mom_kin_4th_axis_plane)] &&\
[string match "Other" $mom_kin_var(\$mom_kin_4th_axis_plane)] } {
return
}
if { [info exists mom_kin_var(\$mom_kin_5th_axis_plane)] &&\
[string match "Other" $mom_kin_var(\$mom_kin_5th_axis_plane)] } {
return
}
if { [ValidateMachObjAttr 5] == "TCL_ERROR" } { return }
set ImageWindowText [list $gPB(new,axis_5,Label) $gPB(new,mill,Label)]
Construct5thAxisDisplayParameter
}
}
}
"Lathe" \
{
switch $axisoption \
{
"2" {
set ImageWindowText [list $gPB(new,axis_2,Label) $gPB(new,lathe,Label)]
append imagefile $directory pb_l2x.gif
}
"4" {
set ImageWindowText [list $gPB(new,axis_4,Label) $gPB(new,lathe,Label)]
append imagefile $directory pb_l2x.gif
}
}
}
}
if { [info exists ImageWindowText] } {
regsub -all \{ $ImageWindowText "" ImageWindowText
regsub -all \} $ImageWindowText "" ImageWindowText
}
}
proc Construct4thAxisDisplayParameter {} {
global mom_kin_var
global imagefile directory
global gPB
set 4address $mom_kin_var(\$mom_kin_4th_axis_leader)
switch $mom_kin_var(\$mom_kin_4th_axis_plane) \
{
"YZ" \
{
switch $mom_kin_var(\$mom_kin_4th_axis_type) \
{
"Table" {
Set4thDispParams 200 380 320 390 258 374 \
313 421 308 407 \
220 411 223 383
append imagefile $directory pb_m4x_TA_h.gif
}
"Head" {
Set4thDispParams 550 450 550 380 458 440 \
507 367 525 374 \
517 442 536 425
append imagefile $directory pb_m4x_HA_h.gif
}
}
}
"ZX" \
{
switch $mom_kin_var(\$mom_kin_4th_axis_type) \
{
"Table" {
Set4thDispParams 550 430 330 430 434 515 \
359 482 333 478 \
520 463 545 452
append imagefile $directory pb_m4x_TB_h.gif
}
"Head" {
Set4thDispParams 585 319 490 325 538 309 \
514 348 526 362 \
581 349 574 363
append imagefile $directory pb_m4x_HB_h.gif
}
}
}
default {
tk_messageBox -parent [UI_PB_com_AskActiveWindow] -type ok \
-icon question \
-message "$gPB(msg,no_display)"
return
}
}
}
proc Set4thDispParams { x1 y1 x2 y2 sx sy ax1_1 ay1_1 ax2_1 ay2_1 \
ax1_2 ay1_2 ax2_2 ay2_2 } {
global mom_kin_var
global 4x1 4y1 4x2 4y2 4ax1 4ay1 4ax2 4ay2 4sx 4sy
set 4dire $mom_kin_var(\$mom_kin_4th_axis_rotation)
set 4x1 $x1; set 4y1 $y1
set 4x2 $x2; set 4y2 $y2
set 4sx $sx; set 4sy $sy
if { $4dire == "standard" } {
set 4ax1 $ax1_1; set 4ay1 $ay1_1
set 4ax2 $ax2_1; set 4ay2 $ay2_1
} else {
set 4ax1 $ax1_2; set 4ay1 $ay1_2
set 4ax2 $ax2_2; set 4ay2 $ay2_2
}
}
proc Set5thDispParams { x1 y1 x2 y2 sx sy ax1_1 ay1_1 ax2_1 ay2_1 \
ax1_2 ay1_2 ax2_2 ay2_2 ox oy } {
global mom_kin_var
global 5x1 5y1 5x2 5y2 5ax1 5ay1 5ax2 5ay2 5sx 5sy
global 5ox 5oy
set 5dire $mom_kin_var(\$mom_kin_5th_axis_rotation)
set 5x1 $x1; set 5y1 $y1
set 5x2 $x2; set 5y2 $y2
set 5sx $sx; set 5sy $sy
if { $5dire == "standard" } {
set 5ax1 $ax1_1; set 5ay1 $ay1_1
set 5ax2 $ax2_1; set 5ay2 $ay2_1
} else {
set 5ax1 $ax1_2; set 5ay1 $ay1_2
set 5ax2 $ax2_2; set 5ay2 $ay2_2
}
set 5ox $ox
set 5oy $oy
}
proc Construct5thAxisDisplayParameter {} {
global imagefile directory
global axisoption
global mom_kin_var
global gPB
set 4plane $mom_kin_var(\$mom_kin_4th_axis_plane)
set 4address $mom_kin_var(\$mom_kin_4th_axis_leader)
set 5plane $mom_kin_var(\$mom_kin_5th_axis_plane)
set 5address $mom_kin_var(\$mom_kin_5th_axis_leader)
switch $mom_kin_var(\$mom_kin_4th_axis_plane) \
{
"YZ" \
{
switch $mom_kin_var(\$mom_kin_5th_axis_plane) \
{
"ZX" \
{
switch $axisoption \
{
"5HH" {
Set4thDispParams 470 270 450 220 381 281 \
424 253 444 237 \
451 304 467 293
Set5thDispParams 540 270 500 300 580 347 \
497 346 494 316 \
545 290 530 285 \
0 0
append imagefile $directory pb_m5x_HA_HB_v.gif
}
"5TT" {
Set4thDispParams 250 420 370 450 307 439 \
361 491 354 471 \
267 470 271 443
Set5thDispParams 470 550 480 440 531 477 \
506 413 492 422 \
509 535 485 531 \
240 536
append imagefile $directory pb_m5x_TA_TB_v.gif
}
"5HT" {
Set4thDispParams 470 240 390 280 393 253 \
420 283 419 256 \
462 269 452 255
Set5thDispParams 540 500 680 440 607 469 \
678 474 670 461 \
564 530 570 502 \
0 0
append imagefile $directory pb_m5x_HA_TB_v.gif
}
}
}
"XY" \
{
switch $axisoption \
{
"5HH" \
{
tk_messageBox -parent [UI_PB_com_AskActiveWindow] -type ok \
-icon question -message "$gPB(msg,no_display)"
return
}
"5TT" \
{
Set4thDispParams 230 480 340 480 286 460 \
342 512 337 496 \
255 495 259 470
Set5thDispParams 410 390 460 470 478 393 \
495 446 474 448 \
420 413 399 423 \
240 530
append imagefile $directory pb_m5x_TA_TC_v.gif
}
"5HT" \
{
Set4thDispParams 430 220 355 250 355 223 \
386 255 385 228 \
426 241 417 228
Set5thDispParams 610 450 380 460 479 476 \
393 507 373 505 \
589 484 607 477 \
0 0
append imagefile $directory  pb_m5x_HA_TC_v.gif
}
}
}
default {
tk_messageBox -parent [UI_PB_com_AskActiveWindow] -type ok \
-icon question -message "$gPB(msg,no_display)"
return
}
}
}
"ZX" \
{
switch $mom_kin_var(\$mom_kin_5th_axis_plane) \
{
"YZ" \
{
switch $axisoption \
{
"5HH" {
Set4thDispParams 580 240 520 250 610 280 \
539 288 529 272 \
581 275 578 257
Set5thDispParams 480 280 440 290 396 327 \
442 328 440 309 \
486 305 476 293 \
0 0
append imagefile $directory pb_m5x_HB_HA_v.gif
}
"5TT" {
Set4thDispParams 550 400 650 410 560 556 \
647 447 646 427 \
555 432 568 411
Set5thDispParams 410 475 455 350 439 412 \
462 369 448 365 \
433 460 413 440 \
690 500
append imagefile $directory pb_m5x_TB_TA_v.gif
}
"5HT" {
Set4thDispParams 520 230 450 280 553 314 \
483 306 481 279 \
532 252 517 248
Set5thDispParams 310 410 400 500 347 465 \
385 535 385 520 \
294 451 309 434 \
0 0
append imagefile $directory pb_m5x_HB_TA_v.gif
}
}
}
"XY" \
{
switch $axisoption \
{
"5HH" {
tk_messageBox -parent [UI_PB_com_AskActiveWindow] -type ok \
-icon question -message "$gPB(msg,no_display)"
return
}
"5TT" {
Set4thDispParams 460 460 560 420 534 577 \
565 450 557 438 \
467 496 471 474
Set5thDispParams 380 425 470 360 393 355 \
443 376 457 383 \
373 403 393 408 \
590 510
append imagefile $directory pb_m5x_TB_TC_v.gif
}
"5HT" {
Set4thDispParams 465 190 401 235 488 271 \
431 254 430 232 \
474 218 462 209
Set5thDispParams 570 465 376 477 459 548 \
396 509 380 506 \
556 490 571 484 \
0 0
append imagefile $directory pb_m5x_HB_TC_v.gif
}
}
}
default {
tk_messageBox -parent [UI_PB_com_AskActiveWindow] -type ok \
-icon question \
-message "$gPB(msg,no_display)"
return
}
}
}
"XY" \
{
switch $mom_kin_var(\$mom_kin_5th_axis_plane) \
{
"YZ" \
{
switch $axisoption \
{
"5HH" {
Set4thDispParams 410 190 590 220 603 262 \
562 252 584 246 \
419 219 429 204
Set5thDispParams 490 290 410 330 410 304 \
442 331 441 303 \
485 313 476 301 \
0 0
append imagefile $directory pb_m5x_HC_HA_v.gif
}
default {
tk_messageBox -parent [UI_PB_com_AskActiveWindow] -type ok \
-icon question -message "$gPB(msg,no_display)"
return
}
}
}
"ZX" \
{
switch $axisoption \
{
"5HH" {
Set4thDispParams 370 200 540 230 560 265 \
510 254 529 249 \
374 220 385 211
Set5thDispParams 530 330 460 290 504 299 \
482 314 500 304 \
519 356 522 343 \
0 0
append imagefile $directory pb_m5x_HC_HB_v.gif
}
default {
tk_messageBox -parent [UI_PB_com_AskActiveWindow] -type ok \
-icon question -message "$gPB(msg,no_display)"
return
}
}
}
default {
tk_messageBox -parent [UI_PB_com_AskActiveWindow] -type ok \
-icon question \
-message "$gPB(msg,no_display)"
return
}
}
}
default {
tk_messageBox -parent [UI_PB_com_AskActiveWindow] -type ok \
-icon question \
-message "$gPB(msg,no_display)"
return
}
}
}
proc ValidateMachObjAttr { axis_type } {
global mom_kin_var
global gPB
switch -- $axis_type \
{
3 {
return TCL_OK
}
4 {
if { $mom_kin_var(\$mom_kin_4th_axis_plane) == "XY" && \
$mom_kin_var(\$mom_kin_4th_axis_leader) == "C" && \
$mom_kin_var(\$mom_kin_4th_axis_type) == "Table" } \
{
tk_messageBox -parent [UI_PB_com_AskActiveWindow] -type ok \
-icon error -message "$gPB(msg,no_4th_ctable)"
return TCL_ERROR
}
set 4xmin $mom_kin_var(\$mom_kin_4th_axis_min_limit)
set 4xmax $mom_kin_var(\$mom_kin_4th_axis_max_limit)
set 4range [expr $4xmax - $4xmin]
if { $4range == 0 } \
{
tk_messageBox -parent [UI_PB_com_AskActiveWindow] -type ok \
-icon error -message "$gPB(msg,no_4th_max_min)"
return TCL_ERROR
} elseif { $4xmax < 0 && $4xmin < 0 } {
tk_messageBox -parent [UI_PB_com_AskActiveWindow] -type ok \
-icon error -message "$gPB(msg,no_4th_both_neg)"
return TCL_ERROR
}
}
5 {
if { [string match "Other" $mom_kin_var(\$mom_kin_4th_axis_plane)] ||\
[string match "Other" $mom_kin_var(\$mom_kin_5th_axis_plane)] } \
{
} else \
{
if { $mom_kin_var(\$mom_kin_4th_axis_plane) == \
$mom_kin_var(\$mom_kin_5th_axis_plane) } \
{
tk_messageBox -parent [UI_PB_com_AskActiveWindow] -type ok \
-icon error -message "$gPB(msg,no_4th_5th_plane)"
return TCL_ERROR
}
}
if { $mom_kin_var(\$mom_kin_4th_axis_plane) == "XY" && \
$mom_kin_var(\$mom_kin_4th_axis_leader) == "C" && \
$mom_kin_var(\$mom_kin_4th_axis_type) == "Table" } \
{
tk_messageBox -parent [UI_PB_com_AskActiveWindow] -type ok \
-icon error -message "$gPB(msg,no_4th_ctable)"
return TCL_ERROR
}
if { $mom_kin_var(\$mom_kin_4th_axis_type) == "Table" && \
$mom_kin_var(\$mom_kin_5th_axis_type) == "Head" } \
{
tk_messageBox -parent [UI_PB_com_AskActiveWindow] -type ok \
-icon error -message "$gPB(msg,no_4thT_5thH)"
return TCL_ERROR
}
set 4xmin $mom_kin_var(\$mom_kin_4th_axis_min_limit)
set 4xmax $mom_kin_var(\$mom_kin_4th_axis_max_limit)
set 4range [expr $4xmax - $4xmin]
if { $4range == 0 } \
{
tk_messageBox -parent [UI_PB_com_AskActiveWindow] -type ok \
-icon error -message "$gPB(msg,no_4th_max_min)"
return TCL_ERROR
} elseif { $4xmax < 0 && $4xmin < 0 } {
tk_messageBox -parent [UI_PB_com_AskActiveWindow] -type ok \
-icon error -message "$gPB(msg,no_4th_both_neg)"
return TCL_ERROR
}
set 5xmin $mom_kin_var(\$mom_kin_5th_axis_min_limit)
set 5xmax $mom_kin_var(\$mom_kin_5th_axis_max_limit)
set 5range [expr $5xmax - $5xmin]
if { $5range == 0 } \
{
tk_messageBox -parent [UI_PB_com_AskActiveWindow] -type ok \
-icon error -message "$gPB(msg,no_5th_max_min)"
return TCL_ERROR
} elseif { $5xmax < 0 && $5xmin < 0 } {
tk_messageBox -parent [UI_PB_com_AskActiveWindow] -type ok \
-icon error -message "$gPB(msg,no_5th_both_neg)"
return TCL_ERROR
}
}
}
return TCL_OK
}
proc UI_PB_mach_UpdateMachinePageParams { MACH_PAGE_OBJ } {
upvar $MACH_PAGE_OBJ mach_page_obj
global mom_kin_var
global mom_sys_arr
PB_int_UpdateKinVar mom_kin_var
if { ![string match "*_wedm" $mom_kin_var(\$mom_kin_machine_type)] } {
set mom_sys_arr(\$mom_sys_lathe_x_double) 1
set mom_sys_arr(\$mom_sys_lathe_i_double) 1
set mom_sys_arr(\$mom_sys_lathe_x_factor) 1
set mom_sys_arr(\$mom_sys_lathe_z_factor) 1
set mom_sys_arr(\$mom_sys_lathe_i_factor) 1
set mom_sys_arr(\$mom_sys_lathe_k_factor) 1
if { $mom_sys_arr(\$xaxis_dia_prog) == 1 } \
{
set mom_sys_arr(\$mom_sys_lathe_x_double) 2
}
if { $mom_sys_arr(\$i_dia_prog) == 1 && $mom_sys_arr(\$xaxis_dia_prog) == 1 } \
{
set mom_sys_arr(\$mom_sys_lathe_i_double) 2
}
if { $mom_sys_arr(\$xaxis_mirror) == 1 } \
{
set mom_sys_arr(\$mom_sys_lathe_x_factor) -1
}
if { $mom_sys_arr(\$zaxis_mirror) == 1 } \
{
set mom_sys_arr(\$mom_sys_lathe_z_factor) -1
}
if { $mom_sys_arr(\$i_mirror) == 1 } \
{
set mom_sys_arr(\$mom_sys_lathe_i_factor) -1
}
if { $mom_sys_arr(\$k_mirror) == 1 } \
{
set mom_sys_arr(\$mom_sys_lathe_k_factor) -1
}
}
if { ![string match "*_wedm" $mom_kin_var(\$mom_kin_machine_type)] && \
[string match "*_axis_*" $mom_kin_var(\$mom_kin_machine_type)] } {
set mom_sys_arr(\$mom_sys_lathe_y_double) 1
set mom_sys_arr(\$mom_sys_lathe_j_double) 1
set mom_sys_arr(\$mom_sys_lathe_y_factor) 1
set mom_sys_arr(\$mom_sys_lathe_j_factor) 1
if { $mom_sys_arr(\$yaxis_dia_prog) == 1 } \
{
set mom_sys_arr(\$mom_sys_lathe_y_double) 2
}
if { $mom_sys_arr(\$j_dia_prog) == 1 && $mom_sys_arr(\$yaxis_dia_prog) == 1 } \
{
set mom_sys_arr(\$mom_sys_lathe_j_double) 2
}
if { $mom_sys_arr(\$yaxis_mirror) == 1 } \
{
set mom_sys_arr(\$mom_sys_lathe_y_factor) -1
}
if { $mom_sys_arr(\$j_mirror) == 1 } \
{
set mom_sys_arr(\$mom_sys_lathe_j_factor) -1
}
}
PB_int_UpdateMOMVar mom_sys_arr
}
proc UI_PB_mach_CreateTabAttr { mach_page_obj } {
global mom_kin_var
global mom_sys_arr
global rest_mom_kin_var
global rest_mom_sys_arr
if { [info exists mom_kin_var(\$mom_kin_4th_axis_leader)] } \
{
set add_name "fourth_axis"
PB_int_RetAddrObjFromName add_name fourth_add_obj
if [info exists address::($fourth_add_obj,add_leader)] {
set mom_kin_var(\$mom_kin_4th_axis_leader) \
$address::($fourth_add_obj,add_leader)
}
}
if { [info exists mom_kin_var(\$mom_kin_5th_axis_leader)] } \
{
set add_name "fifth_axis"
PB_int_RetAddrObjFromName add_name fifth_add_obj
if [info exists address::($fifth_add_obj,add_leader)] {
set mom_kin_var(\$mom_kin_5th_axis_leader) \
$address::($fifth_add_obj,add_leader)
}
}
array set rest_mom_kin_var [array get mom_kin_var]
array set rest_mom_sys_arr [array get mom_sys_arr]
}
proc UI_PB_mach_ActivateMachPageWidgets { page_obj win_index } {
global gPB
if { $gPB(toplevel_disable_$win_index) } \
{
set gPB(toplevel_disable_$win_index) 0
}
}
proc UI_PB_mach_DisableMachPageWidgets { page_obj } {
}
