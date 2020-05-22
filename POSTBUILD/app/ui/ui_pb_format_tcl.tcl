proc UI_PB_Def_Format {book_id fmt_page_obj} {
global tixOption
global FORMATOBJATTR
global fmt_dis_attr
set Page::($fmt_page_obj,page_id) [$book_id subwidget \
$Page::($fmt_page_obj,page_name)]
Page::CreatePane $fmt_page_obj
UI_PB_fmt_AddCompLeftPane fmt_page_obj
Page::CreateTree $fmt_page_obj
UI_PB_fmt_CreateTreePopup fmt_page_obj
UI_PB_fmt_CreateTreeElements fmt_page_obj
UI_PB_fmt_FormatDisplayParams fmt_page_obj 0
__CreateFmtPageParams fmt_page_obj 0
UI_PB_fmt_CreateActionButtons fmt_page_obj
set Page::($fmt_page_obj,double_click_flag) 0
}
proc UI_PB_fmt_CreateTreeElements { PAGE_OBJ } {
upvar $PAGE_OBJ page_obj
global paOption
set tree $Page::($page_obj,tree)
set h [$tree subwidget hlist]
$h config -bg $paOption(tree_bg)
$tree config \
-command "UI_PB_fmt_EditFormatName $page_obj" \
-browsecmd "UI_PB_fmt_SelectItem $page_obj"
}
proc UI_PB_fmt_CreateTreePopup { PAGE_OBJ } {
upvar $PAGE_OBJ page_obj
set tree $Page::($page_obj,tree)
set h [$tree subwidget hlist]
set popup [menu $h.pop -tearoff 0]
set Page::($page_obj,tree_popup) $popup
bind $h <3> "__fmt_CreateTreePopupElements $page_obj %X %Y %x %y"
}
proc __fmt_CreateTreePopupElements { page_obj X Y x y } {
UI_PB_com_CreateTreePopupElements $page_obj $X $Y $x $y \
"UI_PB_fmt_SelectItem" \
"UI_PB_fmt_CreateFormat" \
"UI_PB_fmt_CutFormat" \
"UI_PB_fmt_PasteFormat" \
"UI_PB_fmt_EditFormatName"
}
proc UI_PB_fmt_EditFormatName { page_obj index } {
global gPB_format_name
global gPB
global paOption
set tree $Page::($page_obj,tree)
set HLIST [$tree subwidget hlist]
$HLIST delete entry $index
set col [string range $index 2 end]
if { [winfo exists $HLIST.fmt] != 1 } \
{
set new_frm [frame $HLIST.fmt -bg $paOption(tree_bg)]
label $new_frm.lbl -text " " -bg $paOption(tree_bg)
set img_id [image create compound -window $new_frm.lbl]
$img_id add image -image [tix getimage pb_format]
$new_frm.lbl config -image $img_id
unset img_id
pack $new_frm.lbl -side left
entry $new_frm.ent -bd 1 -relief solid -state normal \
-textvariable gPB_format_name
pack $new_frm.ent -side left -padx 2
} else \
{
set new_frm $HLIST.fmt
}
$new_frm.ent config -width $gPB(MOM_obj_name_len)
focus $new_frm.ent
$HLIST add $index -itemtype window -window $new_frm -at $col
bind $new_frm.ent <Return> "UI_PB_fmt_UpdateFmtEntry $page_obj $index"
bind $new_frm.ent <KeyPress> "UI_PB_com_DisableSpecialChars %W %K"
bind $new_frm.ent <KeyPress> "+UI_PB_com_RestrictStringLength %W %K"
bind $new_frm.ent <KeyRelease> { %W config -state normal }
__fmt_RestoreNamePopup $new_frm.ent $page_obj
$new_frm.ent selection range 0 end
$new_frm.ent icursor end
set Page::($page_obj,double_click_flag) 1
set Page::($page_obj,rename_index) $index
$HLIST entryconfig $index -state disabled
bind $new_frm.lbl <1> "UI_PB_fmt_UpdateFmtEntry $page_obj $index"
grab $Page::($page_obj,page_id)
}
proc __fmt_RestoreNamePopup { w page_obj } {
global gPB
global gPB_format_name
if { ![winfo exists $w.pop] } {
menu $w.pop -tearoff 0
$w.pop add command -label "$gPB(nav_button,restore,Label)"
}
set active_fmt $Page::($page_obj,act_fmt_obj)
$w.pop entryconfig 0 -command "$w config -state normal;\
set gPB_format_name $format::($active_fmt,for_name);\
$w icursor end"
bind $w <3> "%W config -state disabled"
bind $w <3> "+tk_popup $w.pop %X %Y"
}
proc UI_PB_fmt_UpdateFmtEntry { page_obj index } {
global gPB
global gPB_format_name
global gpb_addr_var
if { ![info exists Page::($page_obj,rename_index)] } { return }
if { ![info exists Page::($page_obj,act_fmt_obj)] } { return }
set active_fmt $Page::($page_obj,act_fmt_obj)
set ret_code [UI_PB_fmt_CheckFormatName gPB_format_name active_fmt]
if {$ret_code == 0} \
{
set tree $Page::($page_obj,tree)
set HLIST [$tree subwidget hlist]
set style $gPB(font_style_normal)
set file   [tix getimage pb_format]
set col [string range $index 2 end]
$HLIST delete entry $index
$HLIST add $index -itemtype imagetext -text $gPB_format_name \
-image $file -style $style -at $col
$HLIST selection set $index
$HLIST anchor set $index
set Page::($page_obj,double_click_flag) 0
} else \
{
return [ UI_PB_fmt_DenyFmtRename $ret_code $page_obj $index ]
}
UI_PB_fmt_UpdateFmtNameData page_obj
grab release $Page::($page_obj,page_id)
unset Page::($page_obj,rename_index)
}
proc UI_PB_fmt_DenyFmtRename { error_no args } {
global gPB
set argc [llength $args]
if { $argc > 0 } \
{
set page_obj [lindex $args 0]
if { $page_obj } \
{
set tree $Page::($page_obj,tree)
set HLIST [$tree subwidget hlist]
$HLIST selection clear
$HLIST anchor clear
if { $argc > 1 } \
{
set index [lindex $args 1]
} else \
{
set index [$HLIST info selection]
}
if { $index != "" } \
{
$HLIST entryconfig $index -state disabled
}
if { [winfo exists $HLIST.fmt.ent] } \
{
focus $HLIST.fmt.ent
}
}
}
global gPB_format_name
if { $error_no == 1 } \
{
tk_messageBox  -parent [UI_PB_com_AskActiveWindow] -type ok \
-icon error\
-message "\"$gPB_format_name\" $gPB(msg,name_exists)"
} elseif { $error_no == 2 } \
{
tk_messageBox  -parent [UI_PB_com_AskActiveWindow] -type ok \
-icon error -message "$gPB(format,name_msg)"
}
return UI_PB_ERROR
}
proc UI_PB_fmt_UpdateFmtNameData { PAGE_OBJ } {
upvar $PAGE_OBJ page_obj
global gPB_format_name
global FORMATOBJATTR
global gpb_addr_var
set active_fmt $Page::($page_obj,act_fmt_obj)
set prev_fmt_name $format::($active_fmt,for_name)
set cur_fmt_name $gPB_format_name
if { [string compare $cur_fmt_name $prev_fmt_name] != 0 } \
{
UI_PB_fmt_UnsetFmtArr $prev_fmt_name
set add_obj_list $format::($active_fmt,fmt_addr_list)
foreach add_obj $add_obj_list \
{
set add_name $address::($add_obj,add_name)
set gpb_addr_var($add_name,fmt_name) $cur_fmt_name
}
UI_PB_fmt_UpdateFmtArr FORMATOBJATTR $cur_fmt_name
format::readvalue $active_fmt fmt_obj_attr
set fmt_obj_attr(0) $gPB_format_name
format::setvalue $active_fmt fmt_obj_attr
array set def_fmt_attr $format::($active_fmt,def_value)
set def_fmt_attr(0) $gPB_format_name
format::DefaultValue $active_fmt def_fmt_attr
array set rest_fmt_attr $Page::($page_obj,rest_formatobjattr)
set rest_fmt_attr(0) $gPB_format_name
set Page::($page_obj,rest_formatobjattr) [array get rest_fmt_attr]
set FORMATOBJATTR(0) $gPB_format_name
global post_object
global mom_sys_arr
array set mom_sys_arr $Post::($post_object,mom_sys_var_list)
if { $prev_fmt_name == "$mom_sys_arr(\$zero_int_fmt)" } {
set mom_sys_arr(\$zero_int_fmt) $gPB_format_name
}
if { $prev_fmt_name == "$mom_sys_arr(\$zero_real_fmt)" } {
set mom_sys_arr(\$zero_real_fmt) $gPB_format_name
}
set Post::($post_object,mom_sys_var_list) [array get mom_sys_arr]
}
}
proc UI_PB_fmt_AddCompLeftPane { PAGE_OBJ } {
upvar $PAGE_OBJ page_obj
global gPB
global paOption
set left_pane $Page::($page_obj,left_pane_id)
set but [frame $left_pane.f]
pack $but -side top -fill x -padx 7
button $but.new -text "$gPB(tree,create,Label)" \
-bg $paOption(app_butt_bg) -state normal \
-command "UI_PB_fmt_CreateFormat $page_obj"
button $but.del -text "$gPB(tree,cut,Label)" \
-bg $paOption(app_butt_bg) -state normal \
-command "UI_PB_fmt_CutFormat $page_obj"
button $but.pas -text "$gPB(tree,paste,Label)" \
-bg $paOption(app_butt_bg) -state disabled \
-command "UI_PB_fmt_PasteFormat $page_obj"
pack $but.new $but.del $but.pas -side left -fill x -expand yes
set gPB(c_help,$but.new)   "tree,create"
set gPB(c_help,$but.del)   "tree,cut"
set gPB(c_help,$but.pas)   "tree,paste"
}
proc UI_PB_fmt_FmtObjListFilter {fmt_obj_list} {
set no_names [llength $fmt_obj_list]
set ex_list [list AbsCoord Coordinate Feed]
set temp_fmt_obj_list [list]
for {set index 0} {$index < $no_names} {incr index} {
set fmt_obj [lindex $fmt_obj_list $index]
set fmt_name $format::($fmt_obj,for_name)
if {[lsearch $ex_list $fmt_name] < 0} {
lappend temp_fmt_obj_list $fmt_obj
}
}
return $temp_fmt_obj_list
}
proc UI_PB_fmt_GetFmtObjIndexInDatabase {format_name} {
PB_int_RetFormatObjList fmt_obj_list
set no_names [llength $fmt_obj_list]
set real_index -1
for {set index 0} {$index < $no_names} {incr index} {
set fmt_obj [lindex $fmt_obj_list $index]
set fmt_name $format::($fmt_obj,for_name)
if [string match $fmt_name $format_name] {
set real_index $index
break
}
}
return $real_index
}
proc UI_PB_fmt_GetFmtObjDisplayIndex {format_name} {
PB_int_RetFormatObjList fmt_obj_list
set fmt_obj_list [UI_PB_fmt_FmtObjListFilter $fmt_obj_list]
set no_names [llength $fmt_obj_list]
set display_index -1
for {set index 0} {$index < $no_names} {incr index} {
set fmt_obj [lindex $fmt_obj_list $index]
set fmt_name $format::($fmt_obj,for_name)
if [string match $fmt_name $format_name] {
set display_index $index
break
}
}
return $display_index
}
proc UI_PB_fmt_DisplayNameList { PAGE_OBJ OBJ_INDEX } {
upvar $PAGE_OBJ page_obj
upvar $OBJ_INDEX obj_index
global paOption
if { ![info exists Page::($page_obj,tree)] } { return }
set tree $Page::($page_obj,tree)
set HLIST [$tree subwidget hlist]
$HLIST delete all
$HLIST add 0 -itemtype imagetext -text ""  -image $paOption(folder) \
-state disabled
set file [tix getimage pb_format]
PB_int_RetFormatObjList fmt_obj_list
global gPB
set style $gPB(font_style_normal)
if {[info exists ::env(INCH_METRIC)] && $::env(INCH_METRIC) == 1} {
set fmt_obj_list [UI_PB_fmt_FmtObjListFilter $fmt_obj_list]
}
set no_names [llength $fmt_obj_list]
for {set count 0} {$count < $no_names} {incr count}\
{
set fmt_obj [lindex $fmt_obj_list $count]
set fmt_name $format::($fmt_obj,for_name)
$HLIST add 0.$count -itemtype imagetext -text $fmt_name -image $file \
-style $style
}
if { $obj_index >= $no_names } \
{
set obj_index [expr $no_names - 1]
$HLIST selection set 0.$obj_index
} elseif { $obj_index >= 0 }\
{
$HLIST selection set 0.$obj_index
} else\
{
$HLIST selection set 0
}
}
proc UI_PB_fmt_CreateFormat { page_obj } {
global FORMATOBJATTR
global gPB
if { [info exists Page::($page_obj,rename_index)] } \
{
if { [UI_PB_fmt_UpdateFmtEntry $page_obj \
$Page::($page_obj,rename_index)] == "UI_PB_ERROR" } {
return
}
}
set act_fmt_obj $Page::($page_obj,act_fmt_obj)
PB_int_CheckIsFmtZeroFmt act_fmt_obj ret_code
if { $ret_code } \
{
tk_messageBox  -parent [UI_PB_com_AskActiveWindow] -type ok -icon error\
-message "$gPB(format,zero_msg)"
return
}
if { $Page::($page_obj,double_click_flag) } \
{
set Page::($page_obj,double_click_flag) 0
unset Page::($page_obj,rename_index)
}
PB_int_FormatCreateObject act_fmt_obj FORMATOBJATTR obj_index
set fmt_name $FORMATOBJATTR(0)
UI_PB_fmt_UpdateFmtArr FORMATOBJATTR $fmt_name
if {[info exists ::env(INCH_METRIC)] && $::env(INCH_METRIC) == 1} {
set obj_index [UI_PB_fmt_GetFmtObjDisplayIndex $fmt_name]
}
UI_PB_fmt_DisplayNameList page_obj obj_index
UI_PB_fmt_FormatDisplayParams page_obj $obj_index
UI_PB_fmt_PackFormatAttr $page_obj
set Page::($page_obj,selected_index) "0.$obj_index"
}
proc UI_PB_fmt_CutFormat { page_obj } {
global FORMATOBJATTR
global gPB
set active_fmt_obj $Page::($page_obj,act_fmt_obj)
set format_name $format::($active_fmt_obj,for_name)
if {[info exists ::env(INCH_METRIC)] && $::env(INCH_METRIC) == 1} {
set system_format [list Coordinate_IN Coordinate_MM AbsCoord_IN \
AbsCoord_MM Feed_DPM Feed_FRN Feed_IPM \
Feed_INV Feed_IPR Feed_MMPM Feed_MMPR]
if {[lsearch $system_format $format_name] >= 0} {
tk_messageBox  -parent [UI_PB_com_AskActiveWindow] -type ok -icon error\
-message "System Format"
return
}
}
PB_int_CheckIsFmtZeroFmt active_fmt_obj ret_code
if { $ret_code } \
{
tk_messageBox  -parent [UI_PB_com_AskActiveWindow] -type ok -icon error\
-message "$gPB(format,zero_cut_msg)"
return
}
if {$format::($active_fmt_obj,fmt_addr_list) != ""} \
{
tk_messageBox  -parent [UI_PB_com_AskActiveWindow] -type ok -icon error\
-message "$gPB(msg,in_use)"
return
}
global post_object
Post::GetObjList $post_object command cmd_obj_list
foreach cmd_obj $cmd_obj_list {
foreach fmt $command::($cmd_obj,fmt_list) {
if [string match "$format_name" $fmt] {
tk_messageBox  -parent [UI_PB_com_AskActiveWindow] -type ok -icon error\
-message "$gPB(cust_cmd,fmt,msg) $format_name\n\n\
$gPB(cust_cmd,referenced,msg) \"$command::($cmd_obj,name)\"\
$gPB(cust_cmd,cannot_delete,msg)"
return
}
}
}
set Page::($page_obj,buff_obj_attr) [array get FORMATOBJATTR]
if { $Page::($page_obj,double_click_flag) } \
{
set ent $Page::($page_obj,rename_index)
set obj_index [string range $ent 2 end]
set Page::($page_obj,double_click_flag) 0
unset Page::($page_obj,rename_index)
grab release $Page::($page_obj,page_id)
} else \
{
set tree $Page::($page_obj,tree)
set HLIST [$tree subwidget hlist]
set ent [$HLIST info selection]
set obj_index [string range $ent 2 end]
}
set fmt_name $FORMATOBJATTR(0)
if {[info exists ::env(INCH_METRIC)] && $::env(INCH_METRIC) == 1} {
set real_obj_index [UI_PB_fmt_GetFmtObjIndexInDatabase $fmt_name]
} else {
set real_obj_index $obj_index
}
PB_int_FormatCutObject active_fmt_obj real_obj_index
UI_PB_fmt_UnsetFmtArr $fmt_name
UI_PB_fmt_DisplayNameList page_obj obj_index
UI_PB_fmt_FormatDisplayParams page_obj $obj_index
UI_PB_fmt_PackFormatAttr $page_obj
set left_pane_id $Page::($page_obj,left_pane_id)
$left_pane_id.f.pas config -state normal
set Page::($page_obj,selected_index) "0.$obj_index"
}
proc UI_PB_fmt_PasteFormat { page_obj } {
if {![info exists Page::($page_obj,buff_obj_attr)]} \
{
return
}
if { [info exists Page::($page_obj,rename_index)] } \
{
if { [UI_PB_fmt_UpdateFmtEntry $page_obj \
$Page::($page_obj,rename_index)] == "UI_PB_ERROR" } {
return
}
}
if { $Page::($page_obj,double_click_flag) } \
{
set ent $Page::($page_obj,rename_index)
set obj_index [string range $ent 2 end]
set Page::($page_obj,double_click_flag) 0
unset Page::($page_obj,rename_index)
} else \
{
set tree $Page::($page_obj,tree)
set HLIST [$tree subwidget hlist]
set ent [$HLIST info selection]
set obj_index [string range $ent 2 end]
}
array set buff_obj_attr $Page::($page_obj,buff_obj_attr)
if {[info exists ::env(INCH_METRIC)] && $::env(INCH_METRIC) == 1} {
set fmt_name $::FORMATOBJATTR(0)
set real_obj_index [UI_PB_fmt_GetFmtObjIndexInDatabase $fmt_name]
} else {
set real_obj_index $obj_index
}
set temp_index $real_obj_index
PB_int_FormatPasteObject buff_obj_attr real_obj_index
if {$temp_index != $real_obj_index } \
{
if {[info exists ::env(INCH_METRIC)] && $::env(INCH_METRIC) == 1} {
set obj_index [UI_PB_fmt_GetFmtObjDisplayIndex $buff_obj_attr(0)]
}
UI_PB_fmt_DisplayNameList page_obj obj_index
set fmt_name $buff_obj_attr(0)
UI_PB_fmt_UpdateFmtArr buff_obj_attr $fmt_name
UI_PB_fmt_FormatDisplayParams page_obj $obj_index
UI_PB_fmt_PackFormatAttr $page_obj
}
set left_pane_id $Page::($page_obj,left_pane_id)
$left_pane_id.f.pas config -state disabled
set Page::($page_obj,selected_index) "0.$obj_index"
unset Page::($page_obj,buff_obj_attr)
}
proc UI_PB_fmt_CreateFmtFrames { PAGE_OBJ } {
global paOption
upvar $PAGE_OBJ page_obj
set canvas_frame $Page::($page_obj,canvas_frame)
set name_frame [frame $canvas_frame.name \
-bd 0 \
-relief flat \
-bg $paOption(name_bg)]
set Page::($page_obj,name_frame) $name_frame
pack $name_frame -side top -fill x
set top_frame [tixButtonBox $canvas_frame.top \
-orientation horizontal \
-bd 2 \
-relief sunken \
-bg gray85]
set Page::($page_obj,top_frame) $top_frame
pack $top_frame -side top  -fill x -padx 3 -pady 3
UI_PB_mthd_CreateScrollWindow $canvas_frame fmtsrc fmt_win
set middle_frame [frame $fmt_win.mid]
set Page::($page_obj,middle_frame) $middle_frame
pack $middle_frame -side top -fill both -pady 30
set bottom_frame [frame $canvas_frame.bot]
set Page::($page_obj,bottom_frame) $bottom_frame
pack $bottom_frame -side bottom -fill x -padx 3
}
proc UI_PB_fmt_CreateFmtDisplay { PAGE_OBJ } {
upvar $PAGE_OBJ page_obj
global tixOption
global paOption
set top_frame $Page::($page_obj,top_frame)
global forget_flag
button $top_frame.fmt -text "" -cursor "" \
-font $tixOption(bold_font) \
-bg $paOption(title_bg) -relief flat \
-state disabled -disabledforeground $paOption(title_fg)
grid $top_frame.fmt -row 1 -column 1 -pady 10
set forget_flag 0
$top_frame.fmt configure -activebackground $paOption(title_bg)
UI_PB_fmt__ConfigureFmtDisplay $page_obj
bind $top_frame <Enter> "%W config -bg $paOption(focus)"
bind $top_frame <Leave> "%W config -bg gray85"
global gPB
set gPB(c_help,$top_frame)                    "format,verify"
set gPB(c_help,$top_frame.fmt)                "format,verify"
}
proc UI_PB_fmt_CreateFmtNameEntry { PAGE_OBJ } {
upvar $PAGE_OBJ page_obj
UI_PB_com_CreateNameEntry $page_obj "format"
}
proc UI_PB_fmt_AddPageFmtParm { PAGE_OBJ } {
upvar $PAGE_OBJ page_obj
global tixOption
global FORMATOBJATTR
global gPB
set fch $Page::($page_obj,middle_frame)
tixLabelFrame $fch.typ -label "$gPB(format,data,type,Label)"
set frm1 [$fch.typ subwidget frame]
set Page::($page_obj,fmt_data_widget) $frm1
set frm3 [frame $fch.ent]
set Page::($page_obj,data_ent_widget) $frm3
global pls_sel
checkbutton $fch.pls -text "$gPB(format,data,plus,Label)" \
-variable FORMATOBJATTR(2) \
-relief flat -bd 2 -pady 5 -anchor w \
-command " UI_PB_fmt__ConfigureFmtDisplay $page_obj "
set Page::($page_obj,lead_plus_widget) $fch.pls
checkbutton $fch.r_lead -text "$gPB(format,data,num,lead,Label)" \
-command "UI_PB_fmt__ConfigureFmtDisplay $page_obj" \
-variable FORMATOBJATTR(3) \
-relief flat -bd 2 -anchor w -pady 5
checkbutton $fch.r_tral -text "$gPB(format,data,num,trail,Label)" \
-command "UI_PB_fmt__ConfigureFmtDisplay $page_obj" \
-variable FORMATOBJATTR(4) \
-relief flat -bd 2 -anchor w -pady 5
grid $fch.typ -row 1 -column 0 -pady 25 -sticky nw
grid $fch.ent -row 1 -column 1 -sticky w
switch -exact -- $FORMATOBJATTR(1) {
"Numeral" {
grid $fch.pls - -sticky nw
grid $fch.r_lead - -sticky nw
grid $fch.r_tral - -sticky nw
}
"Text String" {
grid forget $fch.pls
grid forget $fch.r_lead
grid forget $fch.r_tral
}
}
grid columnconfig $fch 1 -minsize 180
pack $fch -side top -pady 30 -fill both
UI_PB_fmt_CreateDataTypes page_obj
UI_PB_fmt_CreateDataElements page_obj
global gPB
set gPB(c_help,$frm1)                       "format,data,type"
set gPB(c_help,$frm1.0)                     "format,data,num"
set gPB(c_help,$frm1.1)                     "format,data,text"
set gPB(c_help,[$frm3.f.a subwidget entry]) "format,data,num,integer"
set gPB(c_help,[$frm3.f.b subwidget entry]) "format,data,num,fraction"
set gPB(c_help,$frm3.dec)                   "format,data,num,decimal"
set gPB(c_help,$fch.pls)                    "format,data,plus"
set gPB(c_help,$fch.r_lead)                "format,data,num,lead"
set gPB(c_help,$fch.r_tral)                "format,data,num,trail"
}
proc UI_PB_fmt_CreateDataTypes { PAGE_OBJ } {
upvar $PAGE_OBJ page_obj
global gPB
global FORMATOBJATTR
set frm1 $Page::($page_obj,fmt_data_widget)
set b 0
set Page::($page_obj,typ_sel_old) $FORMATOBJATTR(1)
set fmt_label(gPB(format,data,num,Label))   "Numeral"
set fmt_label(gPB(format,data,text,Label))  "Text String"
foreach typ {gPB(format,data,num,Label) gPB(format,data,text,Label)} \
{
radiobutton $frm1.$b -text [set $typ] \
-variable FORMATOBJATTR(1) \
-relief flat -value $fmt_label($typ) -bd 2 -width 15 -anchor w \
-command "UI_PB_fmt_PackFormatAttr $page_obj"
pack $frm1.$b -side top -anchor w -padx 6
incr b
}
}
proc UI_PB_fmt_CreateDataElements { PAGE_OBJ } {
upvar $PAGE_OBJ page_obj
global gPB
global FORMATOBJATTR
set frm3 $Page::($page_obj,data_ent_widget)
set fch $Page::($page_obj,middle_frame)
set f4 [frame $frm3.f]
set callback " UI_PB_fmt__ConfigureFmtDisplay $page_obj "
tixControl $f4.a -integer true -min 0 -max 9 \
-command    $callback \
-selectmode immediate \
-variable FORMATOBJATTR(5) \
-options {
entry.width 4
label.anchor e
}
global tixOption
label $f4.lab -text "." -font $tixOption(bold_font)
tixControl $f4.b -integer true -min 0 -max 9 \
-command    $callback \
-selectmode immediate \
-variable FORMATOBJATTR(7) \
-options {
entry.width 4
label.anchor e
}
grid $f4.a $f4.lab $f4.b
grid config $f4.a -padx 2
checkbutton $frm3.dec -text "$gPB(format,data,num,decimal,Label)" \
-command $callback \
-variable FORMATOBJATTR(6) \
-relief flat -bd 2 -pady 0 -anchor w
$f4.a.frame.entry config -relief flat
$f4.b.frame.entry config -relief flat
$f4.a.frame config -relief sunken -bd 1
$f4.b.frame config -relief sunken -bd 1
pack $f4.a.frame.entry -side right
pack $f4.a.frame.incr -side top
pack $f4.a.frame.decr -side bottom
switch -exact -- $FORMATOBJATTR(1) {
"Numeral" {
pack $frm3.f   -side top    -padx 5 -pady 10 -anchor w
pack $frm3.dec -side bottom -padx 5 -pady 0  -anchor w
}
"Text String" {
}
}
}
proc UI_PB_fmt_CreateActionButtons { PAGE_OBJ } {
upvar $PAGE_OBJ page_obj
set tree $Page::($page_obj,tree)
set ff   $Page::($page_obj,bottom_frame)
set label_list {"gPB(nav_button,default,Label)" \
"gPB(nav_button,restore,Label)"}
set cb_arr(gPB(nav_button,default,Label)) \
"UI_PB_fmt_DefaultCallBack $page_obj"
set cb_arr(gPB(nav_button,restore,Label)) \
"UI_PB_fmt_RestoreCallBack $page_obj"
UI_PB_com_CreateButtonBox $ff label_list cb_arr
}
proc UI_PB_fmt_UnsetFmtArr { fmt_name } {
global gpb_fmt_var
unset gpb_fmt_var($fmt_name,name)
unset gpb_fmt_var($fmt_name,dtype)
unset gpb_fmt_var($fmt_name,plus_status)
unset gpb_fmt_var($fmt_name,lead_zero)
unset gpb_fmt_var($fmt_name,trailzero)
unset gpb_fmt_var($fmt_name,integer)
unset gpb_fmt_var($fmt_name,decimal)
unset gpb_fmt_var($fmt_name,fraction)
}
proc UI_PB_fmt_UpdateFmtArr { TEMP_FMT_ARR fmt_name } {
upvar $TEMP_FMT_ARR temp_fmt_arr
global gpb_fmt_var
set gpb_fmt_var($fmt_name,name) $temp_fmt_arr(0)
set gpb_fmt_var($fmt_name,dtype) $temp_fmt_arr(1)
set gpb_fmt_var($fmt_name,plus_status) $temp_fmt_arr(2)
set gpb_fmt_var($fmt_name,lead_zero) $temp_fmt_arr(3)
set gpb_fmt_var($fmt_name,trailzero) $temp_fmt_arr(4)
set gpb_fmt_var($fmt_name,integer) $temp_fmt_arr(5)
set gpb_fmt_var($fmt_name,decimal) $temp_fmt_arr(6)
set gpb_fmt_var($fmt_name,fraction) $temp_fmt_arr(7)
}
proc UI_PB_fmt_CheckFormatName { FORMAT_NAME FMT_OBJ } {
upvar $FORMAT_NAME format_name
upvar $FMT_OBJ fmt_obj
set format_name [string trim $format_name " "]
if { $format_name == "" } \
{
return 2
}
PB_int_RetFormatObjList fmt_obj_list
set fmt_indx [lsearch $fmt_obj_list $fmt_obj]
if { $fmt_indx != -1 } \
{
set fmt_obj_list [lreplace $fmt_obj_list $fmt_indx $fmt_indx]
}
set ret_code 0
PB_com_RetObjFrmName format_name fmt_obj_list ret_code
if { $ret_code == 0 } \
{
return 0
} else \
{
return 1
}
}
proc UI_PB_fmt_ApplyCurrentFmtData { PAGE_OBJ } {
upvar $PAGE_OBJ page_obj
global FORMATOBJATTR
if {[info exists Page::($page_obj,act_fmt_obj)]} \
{
set act_fmt_obj $Page::($page_obj,act_fmt_obj)
set cur_fmt_name $FORMATOBJATTR(0)
format::setvalue $act_fmt_obj FORMATOBJATTR
set Page::($page_obj,rest_formatobjattr) [array get FORMATOBJATTR]
UI_PB_fmt_UpdateFmtArr FORMATOBJATTR $cur_fmt_name
}
}
proc UI_PB_fmt_ApplyFormat { PAGE_OBJ } {
upvar $PAGE_OBJ page_obj
global gPB_format_name
set ret_code 0
if {[info exists Page::($page_obj,act_fmt_obj)]} \
{
set act_fmt_obj $Page::($page_obj,act_fmt_obj)
set ret_code [UI_PB_fmt_CheckFormatName gPB_format_name act_fmt_obj]
if { $ret_code } \
{
return [UI_PB_fmt_DenyFmtRename $ret_code]
} else \
{
UI_PB_fmt_ApplyCurrentFmtData page_obj
unset Page::($page_obj,act_fmt_obj)
}
}
return $ret_code
}
proc UI_PB_fmt_DefaultCallBack { page_obj } {
global FORMATOBJATTR
set act_fmt_obj $Page::($page_obj,act_fmt_obj)
array set FORMATOBJATTR $format::($act_fmt_obj,def_value)
UI_PB_fmt_PackFormatAttr $page_obj
}
proc UI_PB_fmt_RestoreCallBack { page_obj } {
global FORMATOBJATTR
global gPB_format_name
set act_fmt_obj $Page::($page_obj,act_fmt_obj)
array set FORMATOBJATTR $Page::($page_obj,rest_formatobjattr)
set gPB_format_name $FORMATOBJATTR(0)
UI_PB_fmt_PackFormatAttr $page_obj
}
proc UI_PB_fmt_PackFormatAttr { page_obj } {
global FORMATOBJATTR
update idletasks
set fch $Page::($page_obj,middle_frame)
set frm3 $Page::($page_obj,data_ent_widget)
set typ_sel_old $Page::($page_obj,typ_sel_old)
if { $FORMATOBJATTR(1) != $typ_sel_old } {
switch -exact -- $typ_sel_old {
"Numeral" {
grid forget $fch.r_lead $fch.r_tral
pack forget $frm3.f $frm3.dec
grid forget $fch.pls
}
"Text String" {
}
}
switch -exact -- $FORMATOBJATTR(1) \
{
"Numeral" \
{
pack $frm3.f   -side top    -padx 5 -pady 10 -anchor w
pack $frm3.dec -side bottom -padx 5 -pady 0  -anchor w
grid $fch.pls - -sticky nw
grid $fch.r_lead - -sticky nw
grid $fch.r_tral - -sticky nw
}
"Text String" \
{
}
}
}
set Page::($page_obj,typ_sel_old) $FORMATOBJATTR(1)
UI_PB_fmt__ConfigureFmtDisplay $page_obj
}
proc UI_PB_fmt_SelectItem {page_obj args} {
global FORMATOBJATTR
global gPB_format_name
global gPB
if { [info exists Page::($page_obj,rename_index)] } \
{
if { [UI_PB_fmt_UpdateFmtEntry $page_obj \
$Page::($page_obj,rename_index)] == "UI_PB_ERROR" } {
return
}
}
set tree $Page::($page_obj,tree)
set HLIST [$tree subwidget hlist]
set ent [lindex $args 0]
if { $ent == "" } {
set Page::($page_obj,selected_index) -1
set ent [$HLIST info selection]
} elseif { [string match "0" $ent] } {
$HLIST selection clear
$HLIST anchor clear
$HLIST selection set 0.0
$HLIST anchor set 0.0
set Page::($page_obj,selected_index) -1
set ent 0.0
}
PB_int_RetFormatObjList fmt_obj_list
if { [info exists Page::($page_obj,selected_index)] } \
{
if [string match "$ent" $Page::($page_obj,selected_index)] \
{
return [UI_PB_fmt_EditFormatName $page_obj $ent]
}
}
if 0 {
set index [string range $ent 2 end]
if {[string compare $index ""] == 0} \
{
__Pause "index : $index"
set index 0
$HLIST selection clear
$HLIST anchor clear
$HLIST selection set 0.0
$HLIST anchor set 0.0
}
set fmt_obj [lindex $fmt_obj_list $index]
if [info exists Page::($page_obj,act_fmt_obj)] \
{
if { $fmt_obj == $Page::($page_obj,act_fmt_obj) } \
{
__Pause "same obj"
return
}
}
}
if { [info exists Page::($page_obj,act_fmt_obj)] } \
{
set active_fmt_obj $Page::($page_obj,act_fmt_obj)
set act_index [lsearch $fmt_obj_list $active_fmt_obj]
set err [UI_PB_fmt_Validate]
if { $err } \
{
$HLIST selection clear
$HLIST anchor clear
$HLIST selection set 0.$act_index
$HLIST anchor set 0.$act_index
UI_PB_fmt_DisplayErrorMessage $err
return
}
set ret_code [UI_PB_fmt_CheckFormatName gPB_format_name active_fmt_obj]
if { $ret_code } \
{
return [ UI_PB_fmt_DenyFmtRename $ret_code $page_obj \
$Page::($page_obj,rename_index) ]
} else \
{
if { $Page::($page_obj,double_click_flag) } \
{
set style $gPB(font_style_normal)
set file   [tix getimage pb_format]
$HLIST delete entry 0.$act_index
$HLIST add 0.$act_index -itemtype imagetext \
-text $gPB_format_name -image $file -style $style \
-at $act_index
set Page::($page_obj,double_click_flag) 0
UI_PB_fmt_UpdateFmtNameData page_obj
unset Page::($page_obj,rename_index)
}
UI_PB_fmt_ApplyCurrentFmtData page_obj
}
}
set Page::($page_obj,selected_index) $ent
UI_PB_fmt_FormatDisplayParams page_obj [string range $ent 2 end]
UI_PB_fmt_PackFormatAttr $page_obj
$HLIST selection clear
$HLIST anchor clear
$HLIST selection set $ent
$HLIST anchor set $ent
}
proc UI_PB_fmt_Validate { } {
global FORMATOBJATTR
set err 0
if { $FORMATOBJATTR(1) == "Numeral" } \
{
if { $FORMATOBJATTR(5) == 0  &&  $FORMATOBJATTR(7) == 0 } \
{
set err 1
}
if { $FORMATOBJATTR(6) == 0 } \
{
if { $FORMATOBJATTR(3) == 0  &&  $FORMATOBJATTR(4) == 0 } \
{
set err [expr $err + 2]
}
}
}
return $err
}
proc UI_PB_fmt_DisplayErrorMessage { err } {
global FORMATOBJATTR
global gPB
switch $err \
{
"1" \
{
tk_messageBox -parent [UI_PB_com_AskActiveWindow] -type ok \
-title "$FORMATOBJATTR(0) $gPB(format,error,title)" \
-icon error -message "$gPB(format,data,no_digit,msg)"
}
"2" \
{
tk_messageBox -parent [UI_PB_com_AskActiveWindow] -type ok \
-title "$FORMATOBJATTR(0) $gPB(format,error,title)" \
-icon error -message "$gPB(format,data,dec_zero,msg)"
}
"3" \
{
tk_messageBox -parent [UI_PB_com_AskActiveWindow] -type ok \
-title "$FORMATOBJATTR(0) $gPB(format,error,title)" \
-icon error -message "$gPB(format,data,no_digit,msg) \n\
\n$gPB(format,data,dec_zero,msg)"
}
}
}
proc UI_PB_fmt_FormatDisplayParams { PAGE_OBJ index } {
upvar $PAGE_OBJ page_obj
global FORMATOBJATTR
global gPB_format_name
if {$index >= 0} \
{
PB_int_RetFormatObjList fmt_obj_list
if {[info exists ::env(INCH_METRIC)] && $::env(INCH_METRIC) == 1} {
set fmt_obj_list [UI_PB_fmt_FmtObjListFilter $fmt_obj_list]
}
set fmt_obj [lindex $fmt_obj_list $index]
set Page::($page_obj,act_fmt_obj) $fmt_obj
format::readvalue $fmt_obj FORMATOBJATTR
set gPB_format_name $FORMATOBJATTR(0)
if {[info exists Page::($page_obj,rest_formatobjattr)]} \
{
unset Page::($page_obj,rest_formatobjattr)
}
set Page::($page_obj,rest_formatobjattr) [array get FORMATOBJATTR]
}
}
proc UI_PB_fmt__ConfigureFmtDisplay { page_obj args } {
global fmt_dis_attr
global FORMATOBJATTR
PB_int_GetFormat FORMATOBJATTR fmt_value
set fmt_dis_attr $fmt_value
set top_frame $Page::($page_obj,top_frame)
$top_frame.fmt configure -text $fmt_dis_attr
}
proc UI_PB_fmt_CreateFmtPage { add_page_obj fmt_obj new_fmt_page win comb_widget args } {
global FORMATOBJATTR
global gPB_format_name
format::readvalue $fmt_obj FORMATOBJATTR
set pname $FORMATOBJATTR(0)
set gPB_format_name $FORMATOBJATTR(0)
set Page::($new_fmt_page,page_id) $win
set Page::($new_fmt_page,canvas_frame) $win
set Page::($new_fmt_page,act_fmt_obj) $fmt_obj
set Page::($new_fmt_page,rest_formatobjattr) [array get FORMATOBJATTR]
if { [llength $args] && [lindex $args 0] == 1 } \
{
set fmt_flag 1
set mode New
} else \
{
set fmt_flag 0
set mode Edit
}
__CreateFmtPageParams new_fmt_page $fmt_flag
set bot_frame $Page::($new_fmt_page,bottom_frame)
pack $bot_frame -padx 3 -pady 3 -fill x
set cb_arr(gPB(nav_button,default,Label)) \
"UI_PB_fmt_DefaultCallBack $new_fmt_page"
set cb_arr(gPB(nav_button,restore,Label)) \
"UI_PB_fmt_RestoreCallBack $new_fmt_page"
if { $fmt_flag } \
{
set cb_arr(gPB(nav_button,cancel,Label))  \
"UI_PB_fmt_NewCancelCallBack $new_fmt_page $win"
} else \
{
set cb_arr(gPB(nav_button,cancel,Label))  \
"UI_PB_fmt_EditCancelCallBack $new_fmt_page $win"
}
set cb_arr(gPB(nav_button,ok,Label)) \
"UI_PB_fmt_OkCallBack $add_page_obj $new_fmt_page $win \
$comb_widget $mode"
if { $fmt_flag } \
{
UI_PB_com_CreateActionElems $bot_frame cb_arr $win
} else \
{
UI_PB_com_CreateActionElems $bot_frame cb_arr
}
}
proc __CreateFmtPageParams { FMT_PAGE_OBJ entry_flag } {
global gPB
upvar $FMT_PAGE_OBJ fmt_page_obj
UI_PB_fmt_CreateFmtFrames fmt_page_obj
if { $entry_flag } \
{
UI_PB_fmt_CreateFmtNameEntry fmt_page_obj
} else \
{
pack forget $Page::($fmt_page_obj,name_frame)
}
UI_PB_fmt_CreateFmtDisplay fmt_page_obj
UI_PB_fmt_AddPageFmtParm fmt_page_obj
set gPB(NEW_OBJ_OK) 0
}
proc UI_PB_fmt_OkCallBack { add_page_obj fmt_page_obj win comb_widget \
fmt_mode} {
global FORMATOBJATTR
global gPB
global gPB_format_name
set active_fmt_obj $Page::($fmt_page_obj,act_fmt_obj)
set ret_code [UI_PB_fmt_CheckFormatName gPB_format_name active_fmt_obj]
if { $ret_code } \
{
return [ UI_PB_fmt_DenyFmtRename $ret_code ]
}
set err [UI_PB_fmt_Validate]
if $err \
{
UI_PB_fmt_DisplayErrorMessage $err
return
}
UI_PB_fmt_UpdateFmtNameData fmt_page_obj
UI_PB_fmt_ApplyCurrentFmtData fmt_page_obj
format::DefaultValue $active_fmt_obj FORMATOBJATTR
if {[info exists ::env(INCH_METRIC)] && $::env(INCH_METRIC) == 1} {
if {[string match "Coordinate_IN" "$FORMATOBJATTR(0)"] ||
[string match "Coordinate_MM" "$FORMATOBJATTR(0)"] ||
[string match "AbsCoord_IN" "$FORMATOBJATTR(0)"] ||
[string match "AbsCoord_MM" "$FORMATOBJATTR(0)"]} {
set temp_value [lindex [split $FORMATOBJATTR(0) _] 0]
} else {
set temp_value "$FORMATOBJATTR(0)"
}
} else {
set temp_value "$FORMATOBJATTR(0)"
}
set lbx [$comb_widget subwidget listbox]
$comb_widget config -value "$temp_value"
$lbx delete 0 end
PB_int_RetFormatObjList fmt_obj_list
set name_arr_size [llength $fmt_obj_list]
for {set ind 0} {$ind < $name_arr_size} {incr ind} \
{
set fmt_obj [lindex $fmt_obj_list $ind]
set fmt_name $format::($fmt_obj,for_name)
if {[info exists ::env(INCH_METRIC)] && $::env(INCH_METRIC) == 1} {
set ex_list [list Coordinate_IN Coordinate_MM AbsCoord_IN AbsCoord_MM \
Feed_DPM Feed_FRN Feed_INV Feed_IPM Feed_IPR \
Feed_MMPM Feed_MMPR]
if {[lsearch $ex_list $fmt_name] < 0} {
$comb_widget insert end $fmt_name
}
} else {
$comb_widget insert end $fmt_name
}
}
if { $fmt_mode == "Edit" } {
if { [info exists Page::($add_page_obj,rest_addressobjattr)] } \
{
array set rest_addressobjattr $Page::($add_page_obj,rest_addressobjattr)
set rest_addressobjattr(1) $FORMATOBJATTR(0)
set Page::($add_page_obj,rest_addressobjattr) [array get rest_addressobjattr]
}
}
set gPB(NEW_OBJ_OK) 1
PB_com_DeleteObject $fmt_page_obj
destroy $win
}
proc UI_PB_fmt_EditCancelCallBack { fmt_page_obj win } {
PB_com_DeleteObject $fmt_page_obj
destroy $win
}
proc UI_PB_fmt_NewCancelCallBack { fmt_page_obj win } {
global gPB
if [info exists gPB(NEW_OBJ_OK)] {
if $gPB(NEW_OBJ_OK) {
unset gPB(NEW_OBJ_OK)
return
} else {
unset gPB(NEW_OBJ_OK)
}
} else {
return
}
if { [info exists Page::($fmt_page_obj,act_fmt_obj)] } \
{
set fmt_obj $Page::($fmt_page_obj,act_fmt_obj)
set fmt_name $format::($fmt_obj,for_name)
PB_int_RetFormatObjList fmt_obj_list
set obj_index [lsearch $fmt_obj_list $fmt_obj]
PB_int_FormatCutObject fmt_obj obj_index
UI_PB_fmt_UnsetFmtArr $fmt_name
}
UI_PB_fmt_EditCancelCallBack $fmt_page_obj $win
}
proc UI_PB_fmt_TabFormatCreate { page_obj } {
set tree $Page::($page_obj,tree)
set HLIST [$tree subwidget hlist]
set ent [$HLIST info selection]
set index [string range $ent 2 end]
if {[string compare $index ""] == 0} \
{
if { [info exists Page::($page_obj,rename_index)] } \
{
set ent $Page::($page_obj,rename_index)
set index [string range $ent 2 end]
} else \
{
set index 0
}
}
UI_PB_fmt_DisplayNameList page_obj index
UI_PB_fmt_SelectItem $page_obj
}
