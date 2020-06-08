#22

#=======================================================================
proc UI_PB_Def_Format {book_id fmt_page_obj} {
  global tixOption
  global paOption
  global FORMATOBJATTR
  global fmt_dis_attr
  set Page::($fmt_page_obj,page_id) [$book_id subwidget \
  $Page::($fmt_page_obj,page_name)]
  Page::CreatePane $fmt_page_obj
  UI_PB_fmt_AddCompLeftPane fmt_page_obj
  Page::CreateTree $fmt_page_obj
  UI_PB_fmt_CreateTreeElements fmt_page_obj
  UI_PB_fmt_FormatDisplayParams fmt_page_obj 0
  __CreateFmtPageParams fmt_page_obj
  UI_PB_fmt_CreateActionButtons fmt_page_obj
 }

#=======================================================================
proc UI_PB_fmt_CreateTreeElements { PAGE_OBJ } {
  upvar $PAGE_OBJ page_obj
  global paOption
  set tree $Page::($page_obj,tree)
  set page_id $Page::($page_obj,page_id)
  set h [$tree subwidget hlist]
  $h config -bg $paOption(tree_bg)
  set obj_index 0
  $tree config \
  -command "UI_PB_fmt_FormatItemSelec $page_obj" \
  -browsecmd "UI_PB_fmt_FormatItemSelec $page_obj"
 }

#=======================================================================
proc UI_PB_fmt_AddCompLeftPane { PAGE_OBJ } {
  upvar $PAGE_OBJ page_obj
  global gPB
  global paOption
  set left_pane $Page::($page_obj,left_pane_id)
  set but [frame $left_pane.f]
  pack $but -side top -fill x -padx 7
  button $but.new -text "$gPB(tree,create,Label)" \
  -bg $paOption(app_butt_bg) \
  -command "UI_PB_fmt_CreateFormat $page_obj"
  button $but.del -text "$gPB(tree,cut,Label)" \
  -bg $paOption(app_butt_bg) \
  -command "UI_PB_fmt_CutFormat $page_obj"
  button $but.pas -text "$gPB(tree,paste,Label)" \
  -bg $paOption(app_butt_bg) \
  -command "UI_PB_fmt_PasteFormat $page_obj"
  pack $but.new $but.del $but.pas -side left -fill x -expand yes
  set gPB(c_help,$but.new)   "tree,create"
  set gPB(c_help,$but.del)   "tree,cut"
  set gPB(c_help,$but.pas)   "tree,paste"
 }

#=======================================================================
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
  set no_names [llength $fmt_obj_list]
  for {set count 0} {$count < $no_names} {incr count}\
  {
   set fmt_obj [lindex $fmt_obj_list $count]
   set fmt_name $format::($fmt_obj,for_name)
   $HLIST add 0.$count -itemtype imagetext -text $fmt_name -image $file \
   -style $style
  }
  if {$obj_index >= 0}\
  {
   $HLIST selection set 0.$obj_index
  } else\
  {
   $HLIST selection set 0
  }
  $tree autosetmode
 }

#=======================================================================
proc UI_PB_fmt_CreateFormat { page_obj } {
  global FORMATOBJATTR
  global paOption
  global gPB
  set act_fmt_obj $Page::($page_obj,act_fmt_obj)
  PB_int_CheckIsFmtZeroFmt act_fmt_obj ret_code
  if { $ret_code } \
  {
   tk_messageBox  -parent [UI_PB_com_AskActiveWindow] -type ok -icon error\
   -message "$gPB(format,zero_msg)"
   return
  }
  PB_int_FormatCreateObject act_fmt_obj FORMATOBJATTR obj_index
  set fmt_name $FORMATOBJATTR(0)
  UI_PB_fmt_UpdateFmtArr FORMATOBJATTR $fmt_name
  UI_PB_fmt_DisplayNameList page_obj obj_index
  UI_PB_fmt_FormatDisplayParams page_obj $obj_index
  UI_PB_fmt_PackFormatAttr $page_obj
 }

#=======================================================================
proc UI_PB_fmt_CutFormat { page_obj } {
  global FORMATOBJATTR
  global gPB
  set tree $Page::($page_obj,tree)
  set HLIST [$tree subwidget hlist]
  set ent [$HLIST info selection]
  set obj_index [string range $ent 2 [string length $ent]]
  set active_fmt_obj $Page::($page_obj,act_fmt_obj)
  PB_int_CheckIsFmtZeroFmt active_fmt_obj ret_code
  if { $ret_code } \
  {
   tk_messageBox  -parent [UI_PB_com_AskActiveWindow] -type ok -icon error\
   -message "$gPB(format,zero_msg)"
   return
  }
  if {$format::($active_fmt_obj,fmt_addr_list) != ""} \
  {
   set format_name $format::($active_fmt_obj,for_name)
   tk_messageBox  -parent [UI_PB_com_AskActiveWindow] -type ok -icon error\
   -message "Format \"$format_name\" is used by the Address. \
   Format cannot be deleted"
   return
  }
  set Page::($page_obj,fmt_buff_obj_attr) [array get FORMATOBJATTR]
  PB_int_FormatCutObject active_fmt_obj obj_index
  set fmt_name $FORMATOBJATTR(0)
  UI_PB_fmt_UnsetFmtArr $fmt_name
  UI_PB_fmt_DisplayNameList page_obj obj_index
  UI_PB_fmt_FormatDisplayParams page_obj $obj_index
  UI_PB_fmt_PackFormatAttr $page_obj
 }

#=======================================================================
proc UI_PB_fmt_PasteFormat { page_obj } {
  global paOption
  set tree $Page::($page_obj,tree)
  set HLIST [$tree subwidget hlist]
  set ent [$HLIST info selection]
  set obj_index [string range $ent 2 [string length $ent]]
  if {![info exists Page::($page_obj,fmt_buff_obj_attr)]} \
  {
   return
  }
  array set fmt_buff_obj_attr $Page::($page_obj,fmt_buff_obj_attr)
  set temp_index $obj_index
  PB_int_FormatPasteObject fmt_buff_obj_attr obj_index
  if {$temp_index != $obj_index } \
  {
   UI_PB_fmt_DisplayNameList page_obj obj_index
   set fmt_name $fmt_buff_obj_attr(0)
   UI_PB_fmt_UpdateFmtArr fmt_buff_obj_attr $fmt_name
   UI_PB_fmt_FormatDisplayParams page_obj $obj_index
   UI_PB_fmt_PackFormatAttr $page_obj
  }
 }

#=======================================================================
proc UI_PB_fmt_FmtNameEntryCallBack { page_obj } {
  global FORMATOBJATTR
  if { ![info exist Page::($page_obj,tree)] } { return }
  set tree $Page::($page_obj,tree)
  set HLIST [$tree subwidget hlist]
  set ent [$HLIST info selection]
  set obj_index [string range $ent 2 [string length $ent]]
  set act_fmt_obj $Page::($page_obj,act_fmt_obj)
  set cur_fmt_name "$FORMATOBJATTR(0)"
  set ret_code [UI_PB_fmt_ApplyCurrentFmtData page_obj]
  if {$ret_code == 0} \
  {
   $HLIST entryconfigure 0.$obj_index -text "$cur_fmt_name"
  } else \
  {
   tk_messageBox  -parent [UI_PB_com_AskActiveWindow] -type ok \
   -icon error\
   -message "Format \"$cur_fmt_name\" exists, Use another name."
  }
 }

#=======================================================================
proc UI_PB_fmt_CreateFmtFrames { PAGE_OBJ } {
  upvar $PAGE_OBJ page_obj
  set canvas_frame $Page::($page_obj,canvas_frame)
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
  pack $bottom_frame -side bottom -fill x
 }

#=======================================================================
proc UI_PB_fmt_CreateFmtDisplay { PAGE_OBJ } {
  upvar $PAGE_OBJ page_obj
  global tixOption
  global paOption
  set top_frame $Page::($page_obj,top_frame)
  global forget_flag
  button $top_frame.fmt -text "" -cursor "" \
  -font $tixOption(bold_font) \
  -bg darkSeaGreen3 -relief flat \
  -state disabled -disabledforeground lightYellow
  grid $top_frame.fmt -row 1 -column 1 -pady 10
  set forget_flag 0
  $top_frame.fmt configure -activebackground darkSeaGreen3
  UI_PB_fmt__ConfigureFmtDisplay $page_obj
  bind $top_frame <Enter> "%W config -bg $paOption(focus)"
  bind $top_frame <Leave> "%W config -bg gray85"
  global gPB
  set gPB(c_help,$top_frame)                    "format,verify"
  set gPB(c_help,$top_frame.fmt)                "format,verify"
 }

#=======================================================================
proc UI_PB_fmt_AddPageFmtParm { PAGE_OBJ } {
  upvar $PAGE_OBJ page_obj
  global tixOption
  global paOption
  global FORMATOBJATTR
  global gPB
  set fch $Page::($page_obj,middle_frame)
  tixLabelEntry $fch.nam -label "$gPB(format,name,Label) " \
  -options {
   entry.width 20
   entry.anchor w
   label.anchor w
   entry.textVariable FORMATOBJATTR(0)
  }
  set fch_entry [$fch.nam subwidget entry]
  bind $fch_entry <Return> "UI_PB_fmt_FmtNameEntryCallBack $page_obj"
  bind $fch_entry <KeyPress> "UI_PB_com_DisableSpaceKey %W %K"
  bind $fch_entry <KeyRelease> { %W config -state normal }
  set Page::($page_obj,fmt_name_widget) $fch.nam
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
  grid $fch.nam - -pady 10 -sticky nw
  grid $fch.typ -row 1 -column 0 -pady 25 -sticky nw
  grid $fch.ent -row 1 -column 1 -sticky w
  grid $fch.pls - -sticky nw
  grid $fch.r_lead - -sticky nw
  grid $fch.r_tral - -sticky nw
  grid columnconfig $fch 1 -minsize 180
  pack $fch -side top -pady 30 -fill both
  UI_PB_fmt_CreateDataTypes page_obj
  UI_PB_fmt_CreateDataElements page_obj
  global gPB
  set gPB(c_help,$fch_entry)                  "format,name"
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

#=======================================================================
proc UI_PB_fmt_CreateDataTypes { PAGE_OBJ } {
  upvar $PAGE_OBJ page_obj
  global gPB
  global typ_sel
  global typ_sel_old
  global FORMATOBJATTR
  set frm1 $Page::($page_obj,fmt_data_widget)
  set b 0
  set typ_sel_old $FORMATOBJATTR(1)
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

#=======================================================================
proc UI_PB_fmt_CreateDataElements { PAGE_OBJ } {
  upvar $PAGE_OBJ page_obj
  global gPB
  global paOption
  global FORMATOBJATTR
  set frm3 $Page::($page_obj,data_ent_widget)
  set fch $Page::($page_obj,middle_frame)
  set f4 [frame $frm3.f]
  set callback " UI_PB_fmt__ConfigureFmtDisplay $page_obj "
  tixControl $f4.a -integer true -min 0 \
  -command    $callback \
  -selectmode immediate \
  -variable FORMATOBJATTR(5) \
  -options {
   entry.width 4
   label.anchor e
  }
  label $f4.lab -text "."
  tixControl $f4.b -integer true -min 0 \
  -command    $callback \
  -selectmode immediate \
  -variable FORMATOBJATTR(7) \
  -min 0 -max 99 \
  -options {
   entry.width 4
   label.anchor e
  }
  grid $f4.a $f4.lab $f4.b
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
    pack $f4 $frm3.dec -side top -pady 5 -anchor w
   }
   "Text String" {
   }
  }
 }

#=======================================================================
proc UI_PB_fmt_CreateActionButtons { PAGE_OBJ } {
  upvar $PAGE_OBJ page_obj
  global paOption
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

#=======================================================================
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

#=======================================================================
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

#=======================================================================
proc UI_PB_fmt_CheckFormatName { FORMAT_NAME FMT_OBJ } {
  upvar $FORMAT_NAME format_name
  upvar $FMT_OBJ fmt_obj
  PB_int_RetFormatObjList fmt_obj_list
  set fmt_indx [lsearch $fmt_obj_list $fmt_obj]
  if { $fmt_indx != -1 } \
  {
   set fmt_obj_list [lreplace $fmt_obj_list $fmt_indx $fmt_indx]
  }
  PB_com_RetObjFrmName format_name fmt_obj_list ret_code
  if { $ret_code == 0 } \
  {
   return 0
  } else \
  {
   return 1
  }
 }

#=======================================================================
proc UI_PB_fmt_ApplyCurrentFmtData { PAGE_OBJ } {
  upvar $PAGE_OBJ page_obj
  global FORMATOBJATTR
  global gpb_addr_var
  if {[info exists Page::($page_obj,act_fmt_obj)]} \
  {
   set act_fmt_obj $Page::($page_obj,act_fmt_obj)
   set prev_fmt_name $format::($act_fmt_obj,for_name)
   set cur_fmt_name $FORMATOBJATTR(0)
   set ret_code [UI_PB_fmt_CheckFormatName cur_fmt_name act_fmt_obj]
   if { $ret_code } { return 1 }
   if { [string compare $cur_fmt_name $prev_fmt_name] != 0 } \
   {
    UI_PB_fmt_UnsetFmtArr $prev_fmt_name
    set add_obj_list $format::($act_fmt_obj,fmt_addr_list)
    foreach add_obj $add_obj_list \
    {
     set add_name $address::($add_obj,add_name)
     set gpb_addr_var($add_name,fmt_name) $cur_fmt_name
    }
   }
   format::setvalue $act_fmt_obj FORMATOBJATTR
   set Page::($page_obj,rest_formatobjattr) [array get FORMATOBJATTR]
   UI_PB_fmt_UpdateFmtArr FORMATOBJATTR $cur_fmt_name
  }
  return 0
 }

#=======================================================================
proc UI_PB_fmt_ApplyFormat { PAGE_OBJ } {
  upvar $PAGE_OBJ page_obj
  global FORMATOBJATTR
  set ret_code 0
  if {[info exists Page::($page_obj,act_fmt_obj)]} \
  {
   set ret_code [UI_PB_fmt_ApplyCurrentFmtData page_obj]
   if { !$ret_code } \
   {
    unset Page::($page_obj,act_fmt_obj)
   }
  }
  return $ret_code
 }

#=======================================================================
proc UI_PB_fmt_DefaultCallBack { page_obj } {
  global FORMATOBJATTR
  set act_fmt_obj $Page::($page_obj,act_fmt_obj)
  array set FORMATOBJATTR $format::($act_fmt_obj,def_value)
  UI_PB_fmt_PackFormatAttr $page_obj
 }

#=======================================================================
proc UI_PB_fmt_RestoreCallBack { page_obj } {
  global FORMATOBJATTR
  set act_fmt_obj $Page::($page_obj,act_fmt_obj)
  array set FORMATOBJATTR $Page::($page_obj,rest_formatobjattr)
  UI_PB_fmt_PackFormatAttr $page_obj
 }

#=======================================================================
proc UI_PB_fmt_PackFormatAttr {page_obj} {
  global FORMATOBJATTR typ_sel_old
  set fch $Page::($page_obj,middle_frame)
  set frm3 $Page::($page_obj,data_ent_widget)
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
    pack $frm3.f $frm3.dec -side top -pady 5 -anchor w
    grid $fch.pls - -sticky nw
    grid $fch.r_lead - -sticky nw
    grid $fch.r_tral - -sticky nw
   }
   "Text String" \
   {
   }
  }
  set typ_sel_old $FORMATOBJATTR(1)
  UI_PB_fmt__ConfigureFmtDisplay $page_obj
 }

#=======================================================================
proc UI_PB_fmt_FormatItemSelec {page_obj args} {
  global FORMATOBJATTR
  global gPB
  set tree $Page::($page_obj,tree)
  set HLIST [$tree subwidget hlist]
  set ent [$HLIST info selection]
  set index [string range $ent 2 [string length $ent]]
  if {[string compare $index ""] == 0} \
  {
   set index 0
   $HLIST selection clear
   $HLIST anchor clear
   $HLIST selection set 0.0
   $HLIST anchor set 0.0
  }
  if { [info exists Page::($page_obj,act_fmt_obj)] } \
  {
   PB_int_RetFormatObjList fmt_obj_list
   set active_fmt_obj $Page::($page_obj,act_fmt_obj)
   set act_index [lsearch $fmt_obj_list $active_fmt_obj]
   if { $FORMATOBJATTR(1) == "Numeral" && $FORMATOBJATTR(6) == 0 && \
   $FORMATOBJATTR(3) == 0 && $FORMATOBJATTR(4) == 0 } \
   {
    $HLIST selection clear
    $HLIST anchor clear
    $HLIST selection set 0.$act_index
    $HLIST anchor set 0.$act_index
    tk_messageBox -parent [UI_PB_com_AskActiveWindow] -type ok \
    -icon error \
    -message "$gPB(format,data,dec_zero,msg)"
    return
   } else \
   {
    set ret_code [UI_PB_fmt_ApplyFormat page_obj]
    if { $ret_code } \
    {
     $HLIST selection clear
     $HLIST anchor clear
     $HLIST selection set 0.$act_index
     $HLIST anchor set 0.$act_index
     tk_messageBox -parent [UI_PB_com_AskActiveWindow] -type ok \
     -icon error \
     -message "Format \"$FORMATOBJATTR(0)\" exists, \
     Use another name."
     return
    } else \
    {
     $HLIST entryconfigure 0.$act_index -text "$FORMATOBJATTR(0)"
    }
   }
  }
  UI_PB_fmt_FormatDisplayParams page_obj $index
  UI_PB_fmt_PackFormatAttr $page_obj
 }

#=======================================================================
proc UI_PB_fmt_FormatDisplayParams { PAGE_OBJ index } {
  upvar $PAGE_OBJ page_obj
  global FORMATOBJATTR
  if {$index >= 0} \
  {
   PB_int_RetFormatObjList fmt_obj_list
   set fmt_obj [lindex $fmt_obj_list $index]
   set Page::($page_obj,act_fmt_obj) $fmt_obj
   format::readvalue $fmt_obj FORMATOBJATTR
   if {[info exists Page::($page_obj,rest_formatobjattr)]} \
   {
    unset Page::($page_obj,rest_formatobjattr)
   }
   set Page::($page_obj,rest_formatobjattr) [array get FORMATOBJATTR]
  }
 }

#=======================================================================
proc UI_PB_fmt__ConfigureFmtDisplay { page_obj args } {
  global fmt_dis_attr
  global FORMATOBJATTR
  PB_int_GetFormat FORMATOBJATTR fmt_value
  set fmt_dis_attr $fmt_value
  set top_frame $Page::($page_obj,top_frame)
  $top_frame.fmt configure -text $fmt_dis_attr
 }

#=======================================================================
proc UI_PB_fmt_CreateFmtPage { add_page_obj fmt_obj win COMB_WIDGET } {
  upvar $COMB_WIDGET comb_widget
  global FORMATOBJATTR
  global paOption
  format::readvalue $fmt_obj FORMATOBJATTR
  set pname $FORMATOBJATTR(0)
  set new_fmt_page [new Page $pname $pname]
  set Page::($new_fmt_page,page_id) $win
  set Page::($new_fmt_page,canvas_frame) $win
  set Page::($new_fmt_page,act_fmt_obj) $fmt_obj
  set Page::($new_fmt_page,rest_formatobjattr) [array get FORMATOBJATTR]
  __CreateFmtPageParams new_fmt_page
  set bot_frame $Page::($new_fmt_page,bottom_frame)
  set cb_arr(gPB(nav_button,default,Label)) \
  "UI_PB_fmt_DefaultCallBack $new_fmt_page"
  set cb_arr(gPB(nav_button,restore,Label)) \
  "UI_PB_fmt_RestoreCallBack $new_fmt_page"
  set cb_arr(gPB(nav_button,cancel,Label))  \
  "UI_PB_fmt_CancelCallBack $new_fmt_page $win"
  set cb_arr(gPB(nav_button,ok,Label)) \
  "UI_PB_fmt_OkCallBack $add_page_obj $new_fmt_page $win \
  $comb_widget"
  UI_PB_com_CreateActionElems $bot_frame cb_arr
 }

#=======================================================================
proc __CreateFmtPageParams { FMT_PAGE_OBJ } {
  upvar $FMT_PAGE_OBJ fmt_page_obj
  UI_PB_fmt_CreateFmtFrames fmt_page_obj
  UI_PB_fmt_CreateFmtDisplay fmt_page_obj
  UI_PB_fmt_AddPageFmtParm fmt_page_obj
 }

#=======================================================================
proc UI_PB_fmt_OkCallBack { add_page_obj fmt_page_obj win comb_widget} {
  global FORMATOBJATTR
  set ret_code [UI_PB_fmt_ApplyCurrentFmtData fmt_page_obj]
  if { $ret_code } \
  {
   tk_messageBox  -parent [UI_PB_com_AskActiveWindow] -type ok -icon error\
   -message "Format \"$FORMATOBJATTR(0)\" exists, \
   Use another name."
   return
  }
  delete $fmt_page_obj
  destroy $win
  set lbx [$comb_widget subwidget listbox]
  $comb_widget config -value "$FORMATOBJATTR(0)"
  $lbx delete 0 end
  PB_int_RetFormatObjList fmt_obj_list
  set name_arr_size [llength $fmt_obj_list]
  for {set ind 0} {$ind < $name_arr_size} {incr ind}\
  {
   set fmt_obj [lindex $fmt_obj_list $ind]
   set fmt_name $format::($fmt_obj,for_name)
   $comb_widget insert end $fmt_name
  }
  if { [info exists Page::($add_page_obj,rest_addressobjattr)] } \
  {
   array set rest_addressobjattr $Page::($add_page_obj,rest_addressobjattr)
   set rest_addressobjattr(1) $FORMATOBJATTR(0)
   set Page::($add_page_obj,rest_addressobjattr) \
   [array get rest_addressobjattr]
  }
 }

#=======================================================================
proc UI_PB_fmt_CancelCallBack { fmt_page_obj win } {
  delete $fmt_page_obj
  destroy $win
 }

#=======================================================================
proc UI_PB_fmt_TabFormatCreate { page_obj } {
  set tree $Page::($page_obj,tree)
  set HLIST [$tree subwidget hlist]
  set ent [$HLIST info selection]
  set index [string range $ent 2 [string length $ent]]
  if {[string compare $index ""] == 0} \
  {
   set index 0
  }
  UI_PB_fmt_DisplayNameList page_obj index
  UI_PB_fmt_FormatItemSelec $page_obj
 }
