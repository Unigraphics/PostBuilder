#3
proc UI_PB_List { book_id output_page_obj } {
global tixOption
global ListObjectAttr
global gPB
set f [$book_id subwidget $Page::($output_page_obj,page_name)]
set w [tixNoteBook $f.nb -ipadx 5 -ipady 5]
[$w subwidget nbframe] config -tabpady 0
set output_book [new Book w]
set Page::($output_page_obj,book_obj) $output_book
Book::CreatePage $output_book lpt "$gPB(listing,tab,Label)" "" \
UI_PB_list_AddListPage UI_PB_list_ListingTab
Book::CreatePage $output_book oth "Other Options" "" \
UI_PB_list_AddOtherElemPage UI_PB_list_OtherElemTab
if [PB_is_v 4.0] {
Book::CreatePage $output_book isv "IS&V Reversed Post" "pb_vnc" \
UI_PB_list_AddRevPostPage UI_PB_list_RevPostTab
}
pack $f.nb -expand yes -fill both
set Book::($output_book,x_def_tab_img) 0
set Book::($output_book,current_tab)  -1
}
proc UI_PB_list_ListingTab { book_id page_img book_obj} {
CB_nb_def $book_id $page_img $book_obj
if { [UI_PB_list_ValidatePrevPageData book_obj] } \
{
return
}
UI_PB_list_UpdatePrevTabElems book_obj
set Book::($book_obj,current_tab) 0
UI_PB_list_CreateTabAttr book_obj
}
proc UI_PB_list_OtherElemTab { book_id page_img book_obj} {
CB_nb_def $book_id $page_img $book_obj
if 1 {
if { [UI_PB_list_ValidatePrevPageData book_obj] } \
{
return
}
}
UI_PB_list_UpdatePrevTabElems book_obj
set Book::($book_obj,current_tab) 1
UI_PB_list_CreateTabAttr book_obj
}
proc UI_PB_list_RevPostTab { book_id page_img book_obj} {
CB_nb_def $book_id $page_img $book_obj
if { [UI_PB_list_ValidatePrevPageData book_obj] } \
{
return
}
UI_PB_list_UpdatePrevTabElems book_obj
set Book::($book_obj,current_tab) 2
UI_PB_list_CreateTabAttr book_obj
}
proc UI_PB_list_ValidatePrevPageParam { BOOK_OBJ } {
upvar $BOOK_OBJ book_obj
global gPB
set raise_page 0
set current_tab $Book::($book_obj,current_tab)
set page_obj [lindex $Book::($book_obj,page_obj_list) $current_tab]
switch -exact -- $current_tab \
{
0 { ;# Listing File
}
1 { ;# Other Elements
global mom_sys_arr
if { $mom_sys_arr(Output_VNC) && [string match "Subordinate" $mom_sys_arr(VNC_Mode)] } {
if [string match "" $mom_sys_arr(Main_VNC)] {
set raise_page 1
}
}
}
2 { ;# IS&V RevPost
}
}
return $raise_page
}
proc UI_PB_list_ErrorPrevPage { BOOK_OBJ } {
upvar $BOOK_OBJ book_obj
global gPB
set current_tab $Book::($book_obj,current_tab)
set page_obj [lindex $Book::($book_obj,page_obj_list) $current_tab]
set book_id $Book::($book_obj,book_id)
set cur_page_name [$book_id raised]
set cur_page_img [$book_id pagecget $cur_page_name -image]
set prev_page_name $Page::($page_obj,page_name)
set prev_page_img [$book_id pagecget $prev_page_name -image]
set Book::($book_obj,x_def_tab_img) $cur_page_img
$book_id pageconfigure $prev_page_name \
-raisecmd "CB_nb_def $book_id $prev_page_img $book_obj"
$book_id raise $prev_page_name
switch -exact -- $current_tab \
{
0 {
}
1 {
tk_messageBox -parent [UI_PB_com_AskActiveWindow] \
-type ok -icon error \
-message "$gPB(output,vnc,main,err_msg)"
}
2 {
}
}
}
proc UI_PB_list_ValidatePrevPageData { BOOK_OBJ } {
upvar $BOOK_OBJ book_obj
global gPB
set raise_page 0
set raise_page [UI_PB_list_ValidatePrevPageParam book_obj]
if $raise_page {
UI_PB_list_ErrorPrevPage book_obj
set current_tab $Book::($book_obj,current_tab)
set page_obj [lindex $Book::($book_obj,page_obj_list) $current_tab]
set book_id $Book::($book_obj,book_id)
set cur_page_name [$book_id raised]
set cur_page_img [$book_id pagecget $cur_page_name -image]
set prev_page_name $Page::($page_obj,page_name)
set raisecmd [$book_id pagecget $prev_page_name -raisecmd]
$book_id raise $prev_page_name
$book_id pageconfigure $prev_page_name -raisecmd "$raisecmd"
switch $cur_page_name \
{
"lpt"   { set new_tab 0 }
"oth"   { set new_tab 1 }
"isv"   { set new_tab 2 }
default { set new_tab 0 }
}
set Book::($book_obj,current_tab) $new_tab
UI_PB_DeleteBookAttr book_obj
set Book::($book_obj,current_tab) $current_tab
}
return $raise_page
}
if 0 {
proc UI_PB_list_ValidatePrevPageData { BOOK_OBJ } {
upvar $BOOK_OBJ book_obj
global gPB
set raise_page 0
set lis_page_flag 0
set oth_page_flag 0
set isv_page_flag 0
set current_tab $Book::($book_obj,current_tab)
set page_obj [lindex $Book::($book_obj,page_obj_list) $current_tab]
switch -exact -- $current_tab \
{
0 { ;# Listing File
}
1 { ;# Other Elements
global mom_sys_arr
if { $mom_sys_arr(Output_VNC) && [string match "Subordinate" $mom_sys_arr(VNC_Mode)] } {
if [string match "" $mom_sys_arr(Main_VNC)] {
set raise_page 1
}
}
}
2 { ;# IS&V RevPost
}
}
if { $raise_page } \
{
set book_id $Book::($book_obj,book_id)
set cur_page_name [$book_id raised]
set cur_page_img [$book_id pagecget $cur_page_name -image]
set prev_page_name $Page::($page_obj,page_name)
set raisecmd [$book_id pagecget $prev_page_name -raisecmd]
set prev_page_img [$book_id pagecget $prev_page_name -image]
set Book::($book_obj,x_def_tab_img) $cur_page_img
$book_id pageconfigure $prev_page_name \
-raisecmd "CB_nb_def $book_id $prev_page_img $book_obj"
$book_id raise $prev_page_name
switch -exact -- $current_tab \
{
0 {
}
1 {
tk_messageBox -parent [UI_PB_com_AskActiveWindow] \
-type ok -icon error \
-message "$gPB(output,vnc,main,err_msg)"
}
2 {
}
}
$book_id raise $prev_page_name
$book_id pageconfigure $prev_page_name -raisecmd "$raisecmd"
switch $cur_page_name \
{
"lpt"   { set new_tab 0 }
"oth"   { set new_tab 1 }
"isv"   { set new_tab 2 }
default { set new_tab 0 }
}
set Book::($book_obj,current_tab) $new_tab
UI_PB_DeleteBookAttr book_obj
set Book::($book_obj,current_tab) $current_tab
}
return $raise_page
}
} ;# if 0
proc UI_PB_list_UpdatePrevTabElems { BOOK_OBJ } {
upvar $BOOK_OBJ book_obj
set current_tab $Book::($book_obj,current_tab)
set page_obj [lindex $Book::($book_obj,page_obj_list) $current_tab]
switch -exact -- $current_tab \
{
0 {
}
1 {
}
2 {
}
}
}
proc UI_PB_list_CreateTabAttr { BOOK_OBJ } {
upvar $BOOK_OBJ book_obj
global gPB
set current_tab $Book::($book_obj,current_tab)
set page_obj [lindex $Book::($book_obj,page_obj_list) $current_tab]
switch -exact -- $current_tab \
{
0 { ;# Listing File
UI_PB_com_SetStatusbar "$gPB(listing,Status)"
}
1 { ;# Other Control Elements
UI_PB_com_SetStatusbar "$gPB(listing,Status)"
global mom_sys_arr
if { ![info exists mom_sys_arr(Output_VNC)] } {
set mom_sys_arr(Output_VNC) 0
}
if { ![info exists mom_sys_arr(VNC_Mode)] } {
set mom_sys_arr(VNC_Mode) "Standalone"
}
if { ![info exists mom_sys_arr(Main_VNC)] } {
set mom_sys_arr(Main_VNC) ""
}
PB_int_UpdateMOMVar mom_sys_arr ;# Save MOM back to Post!
set Page::($page_obj,rest_output_vnc) $mom_sys_arr(Output_VNC)
set Page::($page_obj,rest_vnc_mode)   $mom_sys_arr(VNC_Mode)
set Page::($page_obj,rest_master_vnc) $mom_sys_arr(Main_VNC)
}
2 { ;# IS&V RevPost
set tree $Page::($page_obj,tree)
set hlist [$tree subwidget hlist]
__isv_CodeItemSelection $page_obj [$hlist info selection]
UI_PB_com_SetStatusbar "$gPB(listing,Status)"
}
}
}
proc UI_PB_list_AddListPage { book_id page_obj } {
global paOption
global tixOption
global gPB
global ListObjectAttr
set Page::($page_obj,page_id) [$book_id subwidget \
$Page::($page_obj,page_name)]
set w $Page::($page_obj,page_id)
set sw [tixScrolledWindow $w.s -scrollbar auto -bd 0 -relief flat]
[$sw subwidget hsb] config -troughcolor $paOption(trough_bg) \
-width $paOption(trough_wd)
[$sw subwidget vsb] config -troughcolor $paOption(trough_bg) \
-width $paOption(trough_wd)
set label_list {"gPB(nav_button,default,Label)" \
"gPB(nav_button,restore,Label)"}
set cb_arr(gPB(nav_button,default,Label)) \
"UI_PB_list_DefListObjAttr $page_obj"
set cb_arr(gPB(nav_button,restore,Label)) \
"UI_PB_list_RestoreListObjAttr $page_obj"
UI_PB_com_CreateButtonBox $w label_list cb_arr
pack $sw -side top -expand yes -fill both
set f  [$sw subwidget window]
set list [frame $f.1 -relief solid -bd 1]
set g1   [tixLabelFrame $f.2 -label "$gPB(listing,Label)"]
grid $list -sticky w -padx 5 -pady 10
grid $g1
PB_int_RetListingFileParams ListObjectAttr
set attr_list [array get ListObjectAttr]
for { set i 1 } { $i < [llength $attr_list] } { incr i 2 } {
if { [lindex $attr_list $i] == "OFF" } {
set attr_list [lreplace $attr_list $i $i 0]
} elseif { [lindex $attr_list $i] == "ON" } {
set attr_list [lreplace $attr_list $i $i 1]
}
}
array set ListObjectAttr $attr_list
checkbutton $list.lisflg -text "$gPB(listing,gen,Label)" \
-fg $paOption(special_fg) \
-bg $paOption(header_bg)\
-variable ListObjectAttr(listfile) \
-relief flat -font $tixOption(bold_font) \
-anchor w -padx 10 -pady 6 ;#<03-31-03 gsl> 6 was 10.
set g1_frm [$g1 subwidget frame]
set g1_left  [frame $g1_frm.left]
grid $g1_left  -row 0 -column 0 -padx 5 -pady 5 -sticky nw
tixLabelEntry $g1_left.lptext -label "$gPB(listing,extension,Label)" \
-options {
label.width 30
label.anchor w
entry.width 7
entry.anchor e
entry.textVariable ListObjectAttr(lpt_ext)
}
[$g1_left.lptext subwidget label] config -font $tixOption(font)
pack $g1_left.lptext -side top -fill x -padx 10 -pady 15 -anchor w
tixLabelFrame $g1_left.param -label "$gPB(listing,parms,Label)"
pack $list.lisflg
pack $g1_left.param
set f1  [$g1_left.param subwidget frame]
checkbutton $f1.x   -text "$gPB(listing,parms,x,Label)" \
-variable ListObjectAttr(x) \
-relief flat -bd 2 -anchor w -padx 5 -width 30
checkbutton $f1.y   -text "$gPB(listing,parms,y,Label)" \
-variable ListObjectAttr(y) \
-relief flat -bd 2 -anchor w -padx 5 -width 30
checkbutton $f1.z   -text "$gPB(listing,parms,z,Label)" \
-variable ListObjectAttr(z) \
-relief flat -bd 2 -anchor w -padx 5 -width 30
checkbutton $f1.4a  -text "$gPB(listing,parms,4,Label)" \
-variable ListObjectAttr(4axis) \
-relief flat -bd 2 -anchor w -padx 5 -width 30
checkbutton $f1.5a  -text "$gPB(listing,parms,5,Label)" \
-variable ListObjectAttr(5axis) \
-relief flat -bd 2 -anchor w -padx 5 -width 30
checkbutton $f1.fed -text "$gPB(listing,parms,feed,Label)" \
-variable ListObjectAttr(feed) \
-relief flat -bd 2 -anchor w -padx 5 -width 30
checkbutton $f1.spd -text "$gPB(listing,parms,speed,Label)" \
-variable ListObjectAttr(speed) \
-relief flat -bd 2 -anchor w -padx 5 -width 30
pack $f1.x $f1.y $f1.z $f1.4a $f1.5a $f1.fed $f1.spd -side top \
-anchor w
set gPB(c_help,$list.lisflg) "listing,gen"
set gPB(c_help,$f1.x)      "listing,parms,x"
set gPB(c_help,$f1.y)      "listing,parms,y"
set gPB(c_help,$f1.z)      "listing,parms,z"
set gPB(c_help,$f1.4a)     "listing,parms,4"
set gPB(c_help,$f1.5a)     "listing,parms,5"
set gPB(c_help,$f1.fed)    "listing,parms,feed"
set gPB(c_help,$f1.spd)    "listing,parms,speed"
set gPB(c_help,[$g1_left.lptext subwidget entry]) "listing,extension"
}
proc UI_PB_list_AddOtherElemPage { book_id page_obj } {
global paOption
global tixOption
global gPB
global ListObjectAttr
set Page::($page_obj,page_id) [$book_id subwidget \
$Page::($page_obj,page_name)]
set w $Page::($page_obj,page_id)
set sw [tixScrolledWindow $w.s -scrollbar auto]
[$sw subwidget hsb] config -troughcolor $paOption(trough_bg) \
-width $paOption(trough_wd)
[$sw subwidget vsb] config -troughcolor $paOption(trough_bg) \
-width $paOption(trough_wd)
set f  [$sw subwidget window]
set label_list {"gPB(nav_button,default,Label)" \
"gPB(nav_button,restore,Label)"}
set cb_arr(gPB(nav_button,default,Label)) \
"UI_PB_list_DefListObjAttr $page_obj"
set cb_arr(gPB(nav_button,restore,Label)) \
"UI_PB_list_RestoreListObjAttr $page_obj"
UI_PB_com_CreateButtonBox $w label_list cb_arr
pack $sw -side top -expand yes -fill both
set g2 [frame $f.2 ]
if { [PB_is_v $gPB(VNC_release)] == 0 } {
global mom_sys_arr
set mom_sys_arr(Output_VNC) 0
set mom_sys_arr(Main_VNC) ""
PB_int_UpdateMOMVar mom_sys_arr
}
if { [PB_is_v $gPB(VNC_release)] && ![PB_is_v 4.0] } {
global mom_sys_arr
global post_object
if 0 {
set g3 [checkbutton $f.3 -text "Generate Virtual NC Controller" \
-fg $paOption(special_fg) \
-bg $paOption(header_bg)\
-variable mom_sys_arr(Output_VNC) \
-relief solid -bd 1 -font $tixOption(bold_font) \
-anchor w -padx 10 -pady 10]
}
if 1 {
if { ![info exists mom_sys_arr(Output_VNC)] } {
set mom_sys_arr(Output_VNC) 0
}
if { ![info exists mom_sys_arr(VNC_Mode)] } {
set mom_sys_arr(VNC_Mode) "Standalone"
}
if { ![info exists mom_sys_arr(Main_VNC)] } {
set mom_sys_arr(Main_VNC) ""
}
PB_int_UpdateMOMVar mom_sys_arr ;# Save MOM back to Post!
}
if 0 {
array set def_mom_sys_arr $Post::($post_object,def_mom_sys_var_list)
if { ![info exists def_mom_sys_arr(Output_VNC)] } {
set def_mom_sys_arr(Output_VNC) $mom_sys_arr(Output_VNC)
}
if { ![info exists def_mom_sys_arr(VNC_Mode)] } {
set def_mom_sys_arr(VNC_Mode)   $mom_sys_arr(VNC_Mode)
}
if { ![info exists def_mom_sys_arr(Main_VNC)] } {
set def_mom_sys_arr(Main_VNC) $mom_sys_arr(Main_VNC)
}
set Post::($post_object,def_mom_sys_var_list) [array get def_mom_sys_arr]
}
if { ![info exists Page::($page_obj,def_output_vnc)] } {
set Page::($page_obj,def_output_vnc) $mom_sys_arr(Output_VNC)
}
if { ![info exists Page::($page_obj,def_vnc_mode)] } {
set Page::($page_obj,def_vnc_mode)   $mom_sys_arr(VNC_Mode)
}
if { ![info exists Page::($page_obj,def_master_vnc)] } {
set Page::($page_obj,def_master_vnc) $mom_sys_arr(Main_VNC)
}
set gg3 [tixLabelFrame $f.3 -labelside none]
set g3 [$gg3 subwidget frame]
set Page::($page_obj,vnc_param) $g3
checkbutton $g3.vnc     -text "$gPB(output,vnc,output,Label)" \
-command "__lst__SetVNCOutputOptionSens $page_obj" \
-fg $paOption(special_fg) \
-bg $paOption(header_bg) \
-variable mom_sys_arr(Output_VNC) \
-relief solid -bd 1 -font $tixOption(bold_font) \
-anchor w -padx 10 -pady 10
frame $g3.opt
pack $g3.vnc -side top   -padx 5 -pady 5 -fill x
pack $g3.opt -side bottom -fill x
set f3v  $g3.opt
radiobutton $f3v.std -text "$gPB(output,vnc,mode,std,Label)" \
-variable mom_sys_arr(VNC_Mode) \
-value Standalone -command "__lst__SetVNCRefSelectSens $page_obj"
radiobutton $f3v.sub -text "$gPB(output,vnc,mode,sub,Label)" \
-variable mom_sys_arr(VNC_Mode) \
-value Subordinate -command "__lst__SetVNCRefSelectSens $page_obj"
set vnc [frame $f3v.vnc]
pack $f3v.vnc -side bottom -pady 5
pack $f3v.std $f3v.sub -side left -expand yes -fill x -pady 5
entry $vnc.ent -width 15 -relief sunken \
-textvariable mom_sys_arr(Main_VNC)
label  $vnc.lbl -text "$gPB(output,vnc,main,Label)"
button $vnc.but -text "$gPB(output,vnc,main,select_name,Label)" \
-command "__lst_SelectVNCFile"
pack $vnc.lbl $vnc.ent $vnc.but -side left -fill x -padx 5 -pady 2
PB_enable_balloon $vnc.ent
global gPB_help_tips
set gPB_help_tips($vnc.ent)   {$mom_sys_arr(Main_VNC)}
grid $g2 $gg3 -padx 5
set gPB(c_help,$g3.vnc)      "output,vnc,output"
set gPB(c_help,$g3.opt)      "output,vnc,mode"
set gPB(c_help,$g3.opt.std)  "output,vnc,mode,std"
set gPB(c_help,$g3.opt.sub)  "output,vnc,mode,sub"
set gPB(c_help,$vnc.ent)     "output,vnc,main"
set gPB(c_help,$vnc.but)     "output,vnc,main,select_name"
} else {
grid $g2
}
PB_int_RetListingFileParams ListObjectAttr
set attr_list [array get ListObjectAttr]
for { set i 1 } { $i < [llength $attr_list] } { incr i 2 } {
if { [lindex $attr_list $i] == "OFF" } {
set attr_list [lreplace $attr_list $i $i 0]
} elseif { [lindex $attr_list $i] == "ON" } {
set attr_list [lreplace $attr_list $i $i 1]
}
}
array set ListObjectAttr $attr_list
tixLabelFrame $g2.out        -label "$gPB(listing,output,Label)"
tixLabelFrame $g2.tcl        -label "$gPB(listing,user_tcl,frame,Label)"
pack $g2.out -side top    -fill both
pack $g2.tcl -side bottom -fill both
set f3  [$g2.out  subwidget frame]
set f3a [$g2.tcl  subwidget frame]
if { ![info exists ListObjectAttr(verbose)] } \
{
set ListObjectAttr(verbose) 0
}
checkbutton $f3.err  -text "$gPB(listing,output,verbose,Label)" \
-variable ListObjectAttr(verbose) \
-relief flat  -bd 2 -anchor w -padx 5 -width 30
checkbutton $f3.warn -text "$gPB(listing,output,warning,Label)" \
-variable ListObjectAttr(warn) \
-relief flat  -bd 2 -anchor w -padx 5 -width 30
checkbutton $f3.rev  -text "$gPB(listing,output,review,Label)" \
-variable ListObjectAttr(review) \
-relief flat  -bd 2 -anchor w -padx 5 -width 30
checkbutton $f3.grp  -text "$gPB(listing,output,group,Label)" \
-variable ListObjectAttr(group) \
-relief flat  -bd 2 -anchor w -padx 5 -width 30
tixLabelEntry $f3.ptpext -label "$gPB(listing,nc_file,Label)" \
-options {
label.width 30
label.anchor w
entry.width 7
entry.anchor e
entry.textVariable ListObjectAttr(ncfile_ext)
}
[$f3.ptpext subwidget label] config -font $tixOption(font)
pack $f3.ptpext -fill x -anchor w -padx 10 -pady 15
pack $f3.grp    -fill x -anchor w
pack $f3.warn   -fill x -anchor w
pack $f3.err    -fill x -anchor w
pack $f3.rev    -fill x -anchor w
checkbutton $f3a.chk -text "$gPB(listing,user_tcl,check,Label)" \
-variable ListObjectAttr(usertcl_check) \
-relief flat  -bd 2 -anchor w -padx 5 -width 30 \
-command "UI_PB_lst__SetUserTclEntryState $page_obj"
tixLabelEntry $f3a.name -label "$gPB(listing,user_tcl,name,Label)" \
-options {
label.width 10
label.anchor w
entry.width 27
entry.anchor e
entry.textVariable ListObjectAttr(usertcl_name)
}
[$f3a.name subwidget label] config -font $tixOption(font)
set Page::($page_obj,usertcl_entry) $f3a.name
pack $f3a.chk  -fill x -anchor w -pady 10
pack $f3a.name -fill x -anchor w -padx 10 -pady 10
UI_PB_lst__SetUserTclEntryState $page_obj
if { [PB_is_v $gPB(VNC_release)] && ![PB_is_v 4.0] } {
__lst__SetVNCOutputOptionSens $page_obj
}
set gPB(c_help,$f3.err)    "listing,output,verbose"
set gPB(c_help,$f3.grp)    "listing,output,group"
set gPB(c_help,$f3.warn)   "listing,output,warning"
set gPB(c_help,$f3.rev)    "listing,output,review"
set gPB(c_help,[$f3.ptpext subwidget entry]) "listing,nc_file"
set gPB(c_help,$f3a.chk)                    "listing,user_tcl,check"
set gPB(c_help,[$f3a.name subwidget entry]) "listing,user_tcl,name"
}
proc __lst__SetVNCOutputOptionSens { page_obj } {
global paOption
global mom_sys_arr
set g3 $Page::($page_obj,vnc_param)
set f3v $g3.opt
__lst__SetVNCRefSelectSens $page_obj
if $mom_sys_arr(Output_VNC) {
$f3v.std config -state normal
$f3v.sub config -state normal
} else {
$f3v.std config -state disabled
$f3v.sub config -state disabled
$f3v.vnc.lbl config -fg $paOption(disabled_fg)
$f3v.vnc.ent config -fg $paOption(disabled_fg) -bg $paOption(entry_disabled_bg) \
-state disabled
$f3v.vnc.but config -state disabled
}
}
proc __lst__SetVNCRefSelectSens { page_obj } {
global paOption gPB
global mom_sys_arr
set g3 $Page::($page_obj,vnc_param)
set f3v $g3.opt
$f3v.vnc.lbl config -fg black
if [string match "Subordinate" $mom_sys_arr(VNC_Mode)] {
$f3v.vnc.but config -state normal
$f3v.vnc.ent config -state normal \
-fg black -bg $gPB(entry_color)
} else {
$f3v.vnc.but config -state disabled
$f3v.vnc.ent config -state disabled \
-fg $paOption(disabled_fg) -bg $paOption(entry_disabled_bg)
}
}
proc __lst_SelectVNCFile { args } {
global gPB
global tcl_platform
global mom_sys_arr
UI_PB_com_SetStatusbar "Select a VNC file."
if [info exists mom_sys_arr(Main_VNC)] {
set gPB(master_VNC) $mom_sys_arr(Main_VNC)
}
if { ![info exists gPB(master_VNC)] } {
set gPB(master_VNC) ""
}
if { $gPB(master_VNC) == "" } {
global env
set dir $env(UGII_BASE_DIR)/mach/resource/postprocessor
if [file exists $dir] {
set gPB(master_VNC) [file dirname $dir/.]/.
} else {
set gPB(master_VNC) [file dirname $env(PB_HOME)/pblib/.]/.
}
} else {
if { ![info exists gPB(master_vnc_dir)] } {
set gPB(master_vnc_dir) $gPB(work_dir)
}
set gPB(master_VNC) [file join $gPB(master_vnc_dir) $gPB(master_VNC)]
}
if {$tcl_platform(platform) == "unix"} \
{
UI_PB_file_SelectFile_unx TCL gPB(master_VNC) open
} elseif {$tcl_platform(platform) == "windows"} \
{
UI_PB_com_GrayOutSaveOptions
UI_PB_com_DisableMain
UI_PB_file_SelectFile_win TCL gPB(master_VNC) open
UI_PB_com_EnableMain
UI_PB_com_UnGraySaveOptions
}
if [file exists $gPB(master_VNC)] {
if { ![string match "*_vnc.tcl" $gPB(master_VNC)] } {
set res [tk_messageBox -parent [UI_PB_com_AskActiveWindow] \
-type yesno -icon question \
-message "Selected file does not match a default VNC file type. Do you want to proceed?"]
if [string match "no" $res] {
__lst_SelectVNCFile
}
}
set gPB(master_vnc_dir) [file dirname $gPB(master_VNC)]
set mom_sys_arr(Main_VNC) [file tail $gPB(master_VNC)]
}
}
if 0 {
proc UI_PB_list_AddRevPostPage { book_id page_obj } {
global paOption
global tixOption
global gPB
set Page::($page_obj,page_id) [$book_id subwidget \
$Page::($page_obj,page_name)]
set w $Page::($page_obj,page_id)
set sw [tixScrolledWindow $w.s -scrollbar auto]
[$sw subwidget hsb] config -troughcolor $paOption(trough_bg) \
-width $paOption(trough_wd)
[$sw subwidget vsb] config -troughcolor $paOption(trough_bg) \
-width $paOption(trough_wd)
set f  [$sw subwidget window]
set label_list {"gPB(nav_button,default,Label)" \
"gPB(nav_button,restore,Label)"}
set cb_arr(gPB(nav_button,default,Label)) \
""
set cb_arr(gPB(nav_button,restore,Label)) \
""
UI_PB_com_CreateButtonBox $w label_list cb_arr
pack $sw -side top -expand yes -fill both
}
} ;# if 0
proc UI_PB_list_AddRevPostPage { book_id page_obj } {
global tixOption
global paOption
global gPB
PB_int_RetSequenceObjs seq_obj_list
set seq_name "Virtual NC Controller"
PB_com_RetObjFrmName seq_name seq_obj_list seq_obj
sequence::readvalue $seq_obj seq_attr
set Page::($page_obj,evt_obj_list) $seq_attr(1)
set Page::($page_obj,seq_obj_list) $seq_obj_list
set Page::($page_obj,seq_obj) $seq_obj
set Page::($page_obj,page_id) [$book_id subwidget \
$Page::($page_obj,page_name)]
global mom_sys_arr
set page_frm $Page::($page_obj,page_id)
set gen [checkbutton $page_frm.gen -text "Generate Virtual NC Controller" \
-fg $paOption(special_fg) \
-bg $paOption(header_bg)\
-variable mom_sys_arr(Output_VNC) \
-bd 1 -relief solid -font $tixOption(bold_font) \
-anchor c -padx 10 -pady 7]
pack $gen -side top -expand no -padx 3 -pady 5
__isv_SetPageAttributes page_obj
Page::CreatePane $page_obj
__isv_AddComponentsLeftPane page_obj
Page::CreateTree $page_obj
set tree $Page::($page_obj,tree)
$tree config \
-command   "__isv_CodeItemSelection $page_obj" \
-browsecmd "__isv_CodeItemSelection $page_obj"
set obj_index 0
__isv_DisplayCodeNameList page_obj obj_index
set label_list {"gPB(nav_button,default,Label)" \
"gPB(nav_button,restore,Label)"}
set cb_arr(gPB(nav_button,default,Label)) \
"__isv_DefaultCallBack $page_obj"
set cb_arr(gPB(nav_button,restore,Label)) \
"__isv_RestoreCallBack $page_obj"
set canvas_frame $Page::($page_obj,canvas_frame)
UI_PB_com_CreateButtonBox $canvas_frame label_list cb_arr
__isv_CreateCodeParamPages $page_obj
catch {__isv_CodeItemSelection $page_obj 0.0}
}
proc __isv_DefaultCallBack { page_obj args } {
global post_object
set sel [[$Page::($page_obj,tree) subwidget hlist] info selection]
set index [string range $sel 2 end]
if [string match "" $index] {
return
}
array set vnc_evt_label_arr  $Post::($post_object,virtual_nc_label_list)
if [string match "Rapid Move" $vnc_evt_label_arr($index)] {
} elseif [string match "Cutter Compensation*" $vnc_evt_label_arr($index)] {
} elseif [string match "Tool Length Adjust*" $vnc_evt_label_arr($index)] {
} else {
UI_PB_evt_DefaultCallBack $page_obj
}
}
proc __isv_RestoreCallBack { page_obj args } {
global post_object
set sel [[$Page::($page_obj,tree) subwidget hlist] info selection]
set index [string range $sel 2 end]
if [string match "" $index] {
return
}
array set vnc_evt_label_arr  $Post::($post_object,virtual_nc_label_list)
if [string match "Rapid Move" $vnc_evt_label_arr($index)] {
} elseif [string match "Cutter Compensation*" $vnc_evt_label_arr($index)] {
} elseif [string match "Tool Length Adjust*" $vnc_evt_label_arr($index)] {
} else {
UI_PB_evt_RestoreCallBack $page_obj
}
}
proc __isv_CreateCodeParamPages { page_obj args } {
set canvas_frame $Page::($page_obj,canvas_frame)
frame $canvas_frame.dummy -relief sunken -bd 1
set g00_frm [frame $canvas_frame.g00 -relief sunken -bd 1]
set dog_img [tix getimage pb_dog]
label $g00_frm.img -image $dog_img
checkbutton $g00_frm.dogleg -text "Dogleg"
grid $g00_frm.img $g00_frm.dogleg -sticky s
frame $canvas_frame.dxx -relief sunken -bd 1
__isv_CreateTable $canvas_frame.dxx
frame $canvas_frame.hxx -relief sunken -bd 1
__isv_CreateTable $canvas_frame.hxx
set top_canvas_dim(0) 80
set top_canvas_dim(1) 400
set bot_canvas_dim(0) 3000
set bot_canvas_dim(1) 3000
Page::CreateCanvas $page_obj top_canvas_dim bot_canvas_dim
$Page::($page_obj,canvas_frame).frame config -relief sunken -bd 1
set Page::($page_obj,add_name) " Add Instruction "
Page::CreateAddTrashinCanvas $page_obj
set top_canvas $Page::($page_obj,top_canvas)
set evt_frm [frame $top_canvas.f]
$top_canvas create window 350 40 -window $evt_frm -width 250
global gPB
set gPB(VNC_elem_sel) "Linear Move"
tk_optionMenu $evt_frm.elem_sel gPB(VNC_elem_sel) "Linear Move" "Rapid Move" "Pause" \
"Message" "Command"
pack $evt_frm.elem_sel -side right -expand yes -fill x
set Page::($page_obj,elem_sel) $evt_frm.elem_sel
UI_PB_evt_AddBindProcs page_obj
global CB_Block_Name
set CB_Block_Name "Custom Command"
Page::AddComponents $page_obj
set Page::($page_obj,popup_flag) 1
set bot_canvas $Page::($page_obj,bot_canvas)
bind $bot_canvas <3> "UI_PB_evt_CanvasPopupMenu $page_obj %X %Y"
UI_PB_evt_CreatePopupMenu $page_obj
set Page::($page_obj,buff_blk_obj) ""
set Page::($page_obj,copy_flag) 0
update idletasks
}
proc UI_PB_evt_isv { PAGE_OBJ } {
upvar $PAGE_OBJ page_obj
UI_PB_evt_prog page_obj
set Page::($page_obj,cen_shift) 3
}
proc __isv_CreateTable { f } {
global paOption tixOption
global mom_sys_arr
set left  [frame $f.left]
set right [frame $f.right]
grid $left $right -sticky n
set frm $left
set grid_frm $frm.scr
tixScrolledGrid $grid_frm -bd 0 -scrollbar y
grid $grid_frm
[$grid_frm subwidget hsb] config -troughcolor $paOption(trough_bg) \
-width $paOption(trough_wd)
[$grid_frm subwidget vsb] config -troughcolor $paOption(trough_bg) \
-width $paOption(trough_wd)
set grid [$grid_frm subwidget grid]
set style [tixDisplayStyle text -refwindow $grid \
-fg $paOption(title_fg) \
-anchor c -font $tixOption(bold_font)]
$grid set 0 0 -itemtype text -text "Offset \#" -style $style
$grid set 1 0 -itemtype text -text "Offset Value" -style $style
$grid size col default -size auto -pad0 0 -pad1 1
$grid size row default -size auto -pad0 0 -pad1 1
set height 12
$grid config -relief sunken -bd 3 -state disabled -leftmargin 0 \
-formatcmd "UI_PB_ads_SimpleFormat $grid" -height $height -width 2
for { set count 0 } { $count < 20 } { incr count } {
__isv_CreateTableRowElems $grid [expr $count + 1]
}
button $right.new -text "New"   -bg $paOption(app_butt_bg)
button $right.cut -text "Cut"   -bg $paOption(app_butt_bg)
button $right.pas -text "Paste" -bg $paOption(app_butt_bg)
pack $right.new $right.cut $right.pas -side top -fill both -padx 10 -pady 3
}
proc __isv_CreateTableRowElems { grid row_no } {
set num [entry $grid.num_$row_no -width 8 -relief sunken]
bind $num <KeyPress> "UI_PB_com_ValidateDataOfEntry %W %K i"
bind $num <KeyRelease> { %W config -state normal }
$grid set 0 $row_no -itemtype window -window $num
set val [entry $grid.val_$row_no -width 12 -relief sunken]
bind $val <KeyPress> "UI_PB_com_ValidateDataOfEntry %W %K f"
bind $val <KeyRelease> { %W config -state normal }
$grid set 1 $row_no -itemtype window -window $val
}
proc __isv_CodeItemSelection { page_obj args } {
set sel [lindex $args 0]
if { ![string match "" $sel] } {
set obj_index [string range $sel 2 end]
set evt_obj [lindex $Page::($page_obj,evt_obj_list) $obj_index]
set Page::($page_obj,evt_obj) $evt_obj
} else {
set evt_obj ""
}
if { [winfo manager $Page::($page_obj,canvas_frame).dummy] == "pack" } {
pack forget $Page::($page_obj,canvas_frame).dummy
}
if { [winfo manager $Page::($page_obj,canvas_frame).frame] == "pack" } {
pack forget $Page::($page_obj,canvas_frame).frame
}
if { [winfo manager $Page::($page_obj,canvas_frame).dxx] == "pack" } {
pack forget $Page::($page_obj,canvas_frame).dxx
}
if { [winfo manager $Page::($page_obj,canvas_frame).hxx] == "pack" } {
pack forget $Page::($page_obj,canvas_frame).hxx
}
if { [winfo manager $Page::($page_obj,canvas_frame).g00] == "pack" } {
pack forget $Page::($page_obj,canvas_frame).g00
}
if [string match "" $evt_obj] {
pack $Page::($page_obj,canvas_frame).dummy -expand yes -fill both
return
}
global post_object
array set vnc_evt_label_arr  $Post::($post_object,virtual_nc_label_list)
if [string match "Rapid Move" $vnc_evt_label_arr($obj_index)] {
pack $Page::($page_obj,canvas_frame).g00 -expand yes -fill both
} elseif [string match "Cutter Compensation*" $vnc_evt_label_arr($obj_index)] {
pack $Page::($page_obj,canvas_frame).dxx -expand yes -fill both
} elseif [string match "Tool Length Adjust*" $vnc_evt_label_arr($obj_index)] {
pack $Page::($page_obj,canvas_frame).hxx -expand yes -fill both
} else {
pack $Page::($page_obj,canvas_frame).frame -expand yes -fill both
__isv_DisplayCodeItemParam $page_obj
}
}
proc __isv_DisplayCodeItemParam { page_obj args } {
global gPB
global mom_sys_arr
set tree $Page::($page_obj,tree)
set HLIST [$tree subwidget hlist]
set ent [$HLIST info anchor]
set index [string range $ent 2 [string length $ent]]
if { [string compare $index ""] == 0} \
{
set index 0
$HLIST selection clear
$HLIST anchor clear
$HLIST selection set 0.0
$HLIST anchor set 0.0
}
set seq_obj $Page::($page_obj,seq_obj)
set evt_obj $Page::($page_obj,evt_obj)
set mom_sys_arr(seq_blk_nc_code) 0
if { $Page::($page_obj,prev_seq) != $index } {
set evt_obj_list $sequence::($seq_obj,evt_obj_list)
set sequence::($seq_obj,evt_obj_list) $evt_obj
event::RestoreValue $evt_obj
UI_PB_debug_ForceMsg "$event::($evt_obj,event_name) \
$event::($evt_obj,block_nof_rows) \
$event::($evt_obj,evt_elem_list) \
$event::($evt_obj,evt_itm_obj_list) \
$event::($evt_obj,event_label)"
set prev_seq $Page::($page_obj,prev_seq)
if { $Page::($page_obj,prev_seq) == -1 } \
{
UI_PB_evt_SetSequenceObjAttr seq_obj
set Page::($page_obj,prev_seq) Virtual_NC
} else \
{
UI_PB_evt_DeleteApplyEvtElemsOfSeq page_obj
set sequence::($seq_obj,evt_obj_list) $Page::($page_obj,prev_evt_obj)
UI_PB_evt_DeleteObjectsPrevSeq page_obj
set sequence::($seq_obj,evt_obj_list) $Page::($page_obj,evt_obj)
set Page::($page_obj,prev_seq) Virtual_NC
UI_PB_evt_SetSequenceObjAttr seq_obj
$Page::($page_obj,bot_canvas) yview moveto 0
$Page::($page_obj,bot_canvas) xview moveto 0
}
UI_PB_evt_RestoreSeqObjData seq_obj
UI_PB_evt_CreateSeqAttributes page_obj
if { $prev_seq >= 2 && $prev_seq < 3 } \
{
if { $seq_index < 2 || $seq_index > 4 } \
{
UI_PB_evt_CreateMenuOptions page_obj seq_obj
}
}
set Page::($page_obj,prev_evt_obj) $evt_obj
}
}
proc __isv_SetPageAttributes { PAGE_OBJ } {
upvar $PAGE_OBJ page_obj
set Page::($page_obj,popup_flag) 0
set Page::($page_obj,fmt_flag) 0
set Page::($page_obj,h_cell) 30       ;# cell height
set Page::($page_obj,w_cell) 62       ;# cell width
set Page::($page_obj,w_divi) 4        ;# divider width
set Page::($page_obj,rect_region) 80  ;# Block rectangle region
set Page::($page_obj,x_orig) 60       ;# upper-left corner of 1st cell
set Page::($page_obj,y_orig) 120
set Page::($page_obj,add_flag) 0
set Page::($page_obj,last_xb) 0
set Page::($page_obj,last_yb) 0
set Page::($page_obj,last_xt) 0
set Page::($page_obj,last_yt) 0
set Page::($page_obj,icon_top) 0
set Page::($page_obj,source_elem_obj) 0
set Page::($page_obj,being_dragged) 0
}
proc __isv_AddComponentsLeftPane {PAGE_OBJ} {
upvar $PAGE_OBJ page_obj
global gPB
global paOption
set left_pane $Page::($page_obj,left_pane_id)
set but [frame $left_pane.f]
set new [button $but.new -text "New" \
-bg $paOption(app_butt_bg) -state normal \
-command ""]
set del [button $but.del -text "$gPB(tree,cut,Label)" \
-bg $paOption(app_butt_bg) -state normal \
-command ""]
set pas [button $but.pas -text "$gPB(tree,paste,Label)" \
-bg $paOption(app_butt_bg) -state disabled \
-command ""]
pack $new $del $pas -side left -fill x -expand yes
pack $but -side top -fill x -padx 7
set gPB(c_help,$new)   "tree,create"
set gPB(c_help,$del)   "tree,cut"
set gPB(c_help,$pas)   "tree,paste"
}
proc __isv_DisplayCodeNameList { PAGE_OBJ OBJ_INDEX } {
upvar $PAGE_OBJ page_obj
upvar $OBJ_INDEX obj_index
global paOption
global mom_sys_arr
global post_object
set tree $Page::($page_obj,tree)
set HLIST [$tree subwidget hlist]
$HLIST config -bg $paOption(tree_bg)
uplevel #0 set TRANSPARENT_GIF_COLOR [$HLIST cget -bg]
$HLIST delete all
$HLIST add 0 -itemtype imagetext -text "" -image $paOption(folder) \
-state disabled
set file   [tix getimage pb_block_s]
global gPB
set style $gPB(font_style_normal)
if { ![info exists Post::($post_object,virtual_nc_evt_list)] } {
set Post::($post_object,virtual_nc_evt_list) [list]
}
if { ![info exists Post::($post_object,virtual_nc_label_list)] } {
set Post::($post_object,virtual_nc_label_list) [list]
}
array set vnc_evt_arr        $Post::($post_object,virtual_nc_evt_list)
array set vnc_evt_label_arr  $Post::($post_object,virtual_nc_label_list)
set no_obj [array size vnc_evt_arr]
PB_int_RetAddressObjList add_obj_list
for {set count 0} {$count < $no_obj} {incr count} {
set add_name [lindex $vnc_evt_arr($count) 0]
set add_var  [lindex $vnc_evt_arr($count) 1]
if [string match "*mom_sys*" $add_var] {
set code [eval format %s $mom_sys_arr($add_var)]
} else {
set code $add_var
}
if { ![string match "__USER_" $add_name] } {
PB_com_RetObjFrmName add_name add_obj_list add_obj
PB_int_ApplyFormatAppText add_obj code
set code "$address::($add_obj,add_leader)$code$address::($add_obj,add_trailer)"
}
set desc $vnc_evt_label_arr($count)
$HLIST add 0.$count -itemtype text -text "$code - $desc" -data $vnc_evt_arr($count)
}
if { $obj_index >= $no_obj } \
{
set obj_index [expr $no_obj - 1]
}
if [catch {$HLIST selection set 0.$obj_index} ] {
if { ![string match "" [lindex [$HLIST info children 0] 0] ] } {
$HLIST selection set [lindex [$HLIST info children 0] 0]
}
}
}
proc UI_PB_list_DefListObjAttr { page_obj } {
global ListObjectAttr
global gPB
PB_int_DefListObjAttr ListObjectAttr
UI_PB_lst__SetUserTclEntryState $page_obj
if { [PB_is_v $gPB(VNC_release)] && ![PB_is_v 4.0] } {
global mom_sys_arr
if [info exists Page::($page_obj,def_output_vnc)] {
set mom_sys_arr(Output_VNC) $Page::($page_obj,def_output_vnc)
}
if [info exists Page::($page_obj,def_vnc_mode)] {
set mom_sys_arr(VNC_Mode)   $Page::($page_obj,def_vnc_mode)
}
if [info exists Page::($page_obj,def_master_vnc)] {
set mom_sys_arr(Main_VNC) $Page::($page_obj,def_master_vnc)
__lst__SetVNCOutputOptionSens $page_obj
}
}
}
proc UI_PB_list_RestoreListObjAttr { page_obj } {
global ListObjectAttr
global gPB
PB_int_RestoreListObjAttr ListObjectAttr
UI_PB_lst__SetUserTclEntryState $page_obj
if { [PB_is_v $gPB(VNC_release)] && ![PB_is_v 4.0] } {
global mom_sys_arr
if [info exists Page::($page_obj,rest_output_vnc)] {
set mom_sys_arr(Output_VNC) $Page::($page_obj,rest_output_vnc)
}
if [info exists Page::($page_obj,rest_vnc_mode)] {
set mom_sys_arr(VNC_Mode)   $Page::($page_obj,rest_vnc_mode)
}
if [info exists Page::($page_obj,rest_master_vnc)] {
set mom_sys_arr(Main_VNC) $Page::($page_obj,rest_master_vnc)
__lst__SetVNCOutputOptionSens $page_obj
}
}
}
proc UI_PB_list_ApplyListObjAttr { page_obj } {
global ListObjectAttr
PB_int_ApplyListObjAttr ListObjectAttr
}
proc UI_PB_lst__SetUserTclEntryState { page_obj } {
global ListObjectAttr
global paOption gPB
if { [info exists Page::($page_obj,usertcl_entry)] && \
[winfo exists $Page::($page_obj,usertcl_entry)] } {
set usertcl_entry $Page::($page_obj,usertcl_entry)
set ent_wdg [$usertcl_entry subwidget entry]
switch $ListObjectAttr(usertcl_check) \
{
0 {
$ent_wdg config -state disabled -fg $paOption(disabled_fg) \
-bg $paOption(entry_disabled_bg)
}
1 {
$ent_wdg config -state normal -fg black -bg $gPB(entry_color)
focus $ent_wdg
$ent_wdg icursor end
}
}
}
}


