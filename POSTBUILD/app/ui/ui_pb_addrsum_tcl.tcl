#0
set __INCLUDE_OTHER_CDL_AND_DEF 1

#=======================================================================
proc UI_PB_ProgTpth_AddSum {book_id page_obj} {
  global paOption
  set Page::($page_obj,page_id) [$book_id subwidget \
  $Page::($page_obj,page_name)]
  set page_id $Page::($page_obj,page_id)
  set top_frm [frame $page_id.top]
  set mid_frm [frame $page_id.mid]
  set bot_frm [frame $page_id.bot]
  pack $bot_frm -side bottom -fill both -expand yes
  pack $mid_frm -side bottom -fill x -pady 5 ;#<08-28-01 gsl>
  pack $top_frm -side top -fill both -expand yes
  tixScrolledGrid $top_frm.scr -bd 0 -scrollbar auto
  [$top_frm.scr subwidget hsb] config -troughcolor $paOption(trough_bg) \
  -width $paOption(trough_wd)
  [$top_frm.scr subwidget vsb] config -troughcolor $paOption(trough_bg) \
  -width $paOption(trough_wd)
  pack $top_frm.scr -padx 3 -pady 0 -expand yes
  set grid [$top_frm.scr subwidget grid]
  global gPB
  set gPB(tix_grid) $grid
  switch $::tix_version {
   8.4 {
    $grid config -relief sunken -bd 3 \
    -formatcmd "UI_PB_ads_SimpleFormat $grid" \
    -state normal \
    -height 10 -width 9
   }
   4.1 {
    $grid config -relief sunken -bd 3 \
    -formatcmd "UI_PB_ads_SimpleFormat $grid" \
    -state disabled \
    -height 10 -width 9
   }
  }
  $grid size col default -size auto -pad0 5 -pad1 5
  $grid size row default -size auto -pad0 3 -pad1 4
  UI_PB_ads__CreateAdrAttributes page_obj $grid
  UI_PB_ads__CreateSpecCharButton page_obj $mid_frm
  UI_PB_ads__CreateActionButtons $bot_frm page_obj
  set Page::($page_obj,addsum_flag) 0
 }

#=======================================================================
proc UI_PB_ads_SimpleFormat {w area x1 y1 x2 y2} {
  global margin
  global paOption
  set bg(s-margin) royalBlue
  set bg(x-margin) $paOption(title_bg)
  set bg(y-margin) $paOption(table_bg)
  set bg(main)     gray20
  case $area {
   main {
    $w format grid $x1 $y1 $x2 $y2 -anchor se
   }
   {x-margin} {
    $w format border $x1 $y1 $x2 $y2 \
    -fill 1 -relief raised -bd 2 -bg $bg($area)
   }
   {y-margin} {
    $w format border $x1 $y1 $x2 $y2 \
    -fill 1 -relief raised -bd 2 -bg $bg($area)
   }
   {s-margin} {
    $w format border $x1 $y1 $x2 $y2 \
    -fill 1 -relief raised -bd 2 -bg $bg($area)
   }
  }
 }

#=======================================================================
proc UI_PB_ads__CreateAdrAttributes { PAGE_OBJ grid } {
  upvar $PAGE_OBJ page_obj
  global gPB
  global paOption tixOption
  global addr_app_text
  global gpb_addr_var
  global gpb_fmt_var
  set title_col(0)  "$gPB(addrsum,col_addr,Label)"
  set title_col(1)  "$gPB(addrsum,col_lead,Label)"
  set title_col(2)  "$gPB(addrsum,col_data,Label)"
  set title_col(3)  "$gPB(addrsum,col_plus,Label)"
  set title_col(4)  "$gPB(addrsum,col_lzero,Label)"
  set title_col(5)  "$gPB(addrsum,col_int,Label)"
  set title_col(6)  "$gPB(addrsum,col_dec,Label)"
  set title_col(7)  "$gPB(addrsum,col_frac,Label)"
  set title_col(8)  "$gPB(addrsum,col_tzero,Label)"
  set title_col(9)  "$gPB(addrsum,col_modal,Label)"
  set title_col(10) "$gPB(addrsum,col_min,Label)"
  set title_col(11) "$gPB(addrsum,col_max,Label)"
  set title_col(12) "$gPB(addrsum,col_trail,Label)"
  set no_col 13
  set style [tixDisplayStyle text -refwindow $grid \
  -fg $paOption(title_fg) \
  -anchor c -font $tixOption(bold_font)]
  if 0 {
   $grid set 0 0 -itemtype text -text $title_col(0) \
   -style [tixDisplayStyle text -refwindow $grid \
   -fg $paOption(seq_bg) -anchor c -font $tixOption(bold_font)]
  }
  $grid set 0 0 -itemtype text -text $title_col(0) \
  -style $style
  for {set col 1} {$col < $no_col} {incr col} {
   $grid set $col 0 -itemtype text -text $title_col($col) -style $style
  }
  PB_int_AddrSummaryAttr addsum_add_name_list addr_app_text add_desc_arr
  set no_addr [llength $addsum_add_name_list]
  set cur_addsum_list ""
  for {set count 0} {$count < $no_addr} {incr count} \
  {
   set add_name [lindex $addsum_add_name_list $count]
   set add_desc $add_desc_arr($count)
   UI_PB_ads__CreateFirstColAttr $page_obj $grid [expr $count + 1] \
   $add_name $add_desc
   UI_PB_ads__CreateSecColAttr  $page_obj $grid [expr $count + 1] $add_name
   lappend cur_addsum_list $add_name
  }
  set Page::($page_obj,cur_addsum_list) $cur_addsum_list
  set Page::($page_obj,total_no_rows) [expr $count + 1]
 }

#=======================================================================
proc UI_PB_ads__CreateFirstColAttr { page_obj grid no_row add_name add_desc } {
  global paOption tixOption
  global addr_app_text
  global gpb_addr_var
  set name_frm $grid.name_$add_name
  if { ![winfo exists $name_frm] } {
   set name_frm [frame $grid.name_$add_name -bg $paOption(table_bg)]
   set addn [button $name_frm.name -text $add_name \
   -font $tixOption(bold_font) \
   -width 10 -anchor w \
   -relief flat -bd 1 \
   -background $paOption(table_bg) \
   -highlightbackground $paOption(table_bg) \
   -state normal \
   -foreground blue \
   -command "UI_PB_ads_EditAddress $page_obj $add_name $name_frm.name"]
   bind $addn <Enter> "%W config -bg $paOption(focus) -relief solid"
   bind $addn <Leave> "%W config -bg $paOption(table_bg) -relief flat"
   bind $addn <Enter> "+%W config -highlightbackground $paOption(special_bg)"
   bind $addn <Leave> "+%W config -highlightbackground $paOption(table_bg)"
   pack $addn -side right -anchor e -padx 3
   PB_enable_balloon $addn
   global gPB_help_tips
   set gPB_help_tips($addn) $add_desc
  }
  $grid set 0 $no_row -itemtype window -window $name_frm
  set add_frm $grid.add_$add_name
  if { ![winfo exists $add_frm] } {
   set add_frm [frame $grid.add_$add_name]
   set but [entry $add_frm.but \
   -textvariable gpb_addr_var($add_name,leader_name) \
   -cursor hand2 \
   -width 5 -borderwidth 4 \
   -highlightcolor $paOption(focus) \
   -background $paOption(header_bg) \
   -foreground $paOption(seq_bg) \
   -selectbackground $paOption(focus) \
   -selectforeground black]
   bind $but <Enter> " CB__AttachPopupMenu page_obj $add_frm $add_name LEADER "
   set ent [entry $add_frm.ent -textvariable addr_app_text($add_name) \
   -state disabled -relief solid -width 6 -borderwidth 1 \
   -justify left -bg $paOption(entry_disabled_bg)]
   pack $but -side left -anchor ne -padx 2
   pack $ent -side right -anchor nw -padx 2 -pady 5
   global gPB
   set gPB(c_help,$addn)     "addrsum,col_addr"
   set gPB(c_help,$but)      "address,leader"
   set gPB(c_help,$ent)      "format,verify"
  }
  $grid set 1 $no_row -itemtype window -window $add_frm
 }

#=======================================================================
proc CB__AttachPopupMenu {PAGE_OBJ w add_name attr} {
  upvar $PAGE_OBJ     page_obj
  global gPB
  if { !$gPB(use_info) } \
  {
   if { ![winfo exists $w.pop] } \
   {
    set menu [menu $w.pop -tearoff 0]
    bind $w.but <1>      "focus %W"
    bind $w.but <3>      "focus %W"
    bind $w.but <3>      "+tk_popup $menu %X %Y"
    UI_PB_ads__SetPopupOptions page_obj menu $w $add_name $attr
   }
  } else \
  {
   destroy $w.pop
  }
 }

#=======================================================================
proc getAttrType {attr} {
  if { $attr == "LEADER" } \
  {
   set type leader_name
   } elseif { $attr == "TRAILER" } \
  {
   set type trailer
  } else \
  {
   set answer [tk_messageBox  -parent [UI_PB_com_AskActiveWindow] \
   -message "Attribute type should be LEADER or TRAILER! \

#=======================================================================
\n(proc getAttrType)" -type ok -icon error]
 set type leader_name
}
return $type
}

#=======================================================================
proc UI_PB_ads_EditAddress { page_obj add_name add_button_id } {
  global gPB
  global paOption
  set page_id $Page::($page_obj,page_id)
  set win [toplevel $page_id.add]
  set toplevel_index [llength $gPB(toplevel_list)]
  set win_index [expr $toplevel_index + 1]
  set gPB(toplevel_disable_$win_index) 1
  UI_PB_com_CreateTransientWindow $win \
  "$gPB(addrsum,addr_trans,title,Label) : $add_name" \
  "500x575+100+200" "" "UI_PB_ads_DisableAddrSumPageWidgets $page_obj" \
  "" \
  "UI_PB_ads_ActivateAddrSumPageWidgets $page_obj $win_index"
  UI_PB_ads_UpdateAddressObjects
  $add_button_id config -background $paOption(title_fg) -relief sunken
  PB_int_RetAddrObjFromName add_name add_obj
  UI_PB_addr_CreateAddressPage $win $add_obj new_add_page 0
  wm protocol $win WM_DELETE_WINDOW "UI_PB_ads_EditCancel_CB $new_add_page $win $add_button_id"
  set bot_frame $Page::($new_add_page,bottom_frame)
  set cb_arr(gPB(nav_button,default,Label)) \
  "UI_PB_addr_AddDefaultCallBack $new_add_page"
  set cb_arr(gPB(nav_button,restore,Label)) \
  "UI_PB_addr_AddRestoreCallBack $new_add_page"
  set cb_arr(gPB(nav_button,cancel,Label))  \
  "UI_PB_ads_EditCancel_CB $new_add_page $win \
  $add_button_id"
  set cb_arr(gPB(nav_button,ok,Label)) \
  "UI_PB_ads_EditOk_CB $page_obj $new_add_page \
  $win $add_button_id"
  UI_PB_com_CreateActionElems $bot_frame cb_arr
  pack $bot_frame -side bottom -fill x -padx 3 -pady 3
  UI_PB_com_PositionWindow $win
 }

#=======================================================================
proc UI_PB_ads_EditCancel_CB { new_add_page win add_button_id } {
  global paOption
  PB_com_DeleteObject $new_add_page
  destroy $win
  $add_button_id config -background lightSkyBlue -relief flat \
  -highlightbackground $paOption(table_bg)
 }

#=======================================================================
proc UI_PB_ads_EditOk_CB { page_obj new_add_page win add_button_id } {
  global paOption
  global gpb_fmt_var
  global prev_add_fmt
  set add_name $Page::($new_add_page,act_addr_name)
  UI_PB_addr_ApplyCurrentAddrData new_add_page
  PB_com_DeleteObject $new_add_page
  destroy $win
  $add_button_id config -background lightSkyBlue -relief flat \
  -highlightbackground $paOption(table_bg)
  set add_name_list $Page::($page_obj,cur_addsum_list)
  set index [lsearch $add_name_list $add_name]
  UI_PB_ads_UpdateWidgetVars $page_obj $add_name $index
  array set gpb_fmt_var [array get gpb_fmt_var]
  UI_PB_ads_UpdateAddrSumPage page_obj
 }

#=======================================================================
proc UI_PB_ads__SetPopupOptions {PAGE_OBJ MENU add_frm add_name attr} {
  upvar $PAGE_OBJ     page_obj
  upvar $MENU         menu
  global gpb_addr_var
  global gPB
  set type [getAttrType $attr]
  set options_list {A B C D E F G H I J K L M N O \
  P Q R S T U V W X Y Z "gPB(address,none_popup,Label)"}
  set count 1
  foreach ELEMENT $options_list \
  {
   if { $ELEMENT == "gPB(address,none_popup,Label)" } \
   {
    set elmt "\"\""
    $menu add command -label [set $ELEMENT] \
    -command "setLeaderTrailer $add_frm $add_name $type $elmt"
    } elseif { $ELEMENT == "Help" } \
   {
    $menu add command -label $ELEMENT
   } else \
   {
    if { $count == 1 } \
    {
     $menu add command -label $ELEMENT -columnbreak 1 \
     -command "setLeaderTrailer $add_frm $add_name $type $ELEMENT"
    } else \
    {
     $menu add command -label $ELEMENT \
     -command "setLeaderTrailer $add_frm $add_name $type $ELEMENT"
    }
   }
   if { $count == 9 } \
   {
    set count 0
   }
   incr count
  }
 }

#=======================================================================
proc setLeaderTrailer {add_frm add_name type elmt } {
  global gpb_addr_var
  global add_dis_attr
  global AddObjAttr
  if { $type == "leader_name" } \
  {
   set add_dis_attr(0) $elmt
  } else \
  {
   set add_dis_attr(2) $elmt
  }
  set gpb_addr_var($add_name,$type) $elmt
  $add_frm.but selection range 0 end
 }

#=======================================================================
proc UI_PB_ads__RadDataCallBack { page_obj grid row_no data_type format_name } {
  global gPB
  set grid $gPB(tix_grid)
  set prev_addsum_list $Page::($page_obj,cur_addsum_list)
  PB_int_GetAddrListFormat format_name fmt_addr_list
  foreach add_name $fmt_addr_list \
  {
   if { [lsearch $prev_addsum_list $add_name] != -1 } \
   {
    UI_PB_ads__DisableDataAttr $grid $add_name $data_type $format_name
   }
  }
 }

#=======================================================================
proc UI_PB_ads__DisableDataAttr { grid add_name data_type fmt_name } {
  global gpb_fmt_var
  switch $data_type \
  {
   "Numeral"  {
    $grid.plus_$add_name.ch config -state normal
    $grid.lez_$add_name.ch config -state normal
    $grid.int_$add_name.con config -state normal
    $grid.dec_$add_name.ch config -state normal
    $grid.fra_$add_name.con config -state normal
    $grid.trz_$add_name.ch config -state normal
    $grid.min_$add_name.ent config -state normal
    $grid.max_$add_name.ent config -state normal
    update idletasks
   }
   "Text"  {
    $grid.plus_$add_name.ch config -state disabled
    $grid.lez_$add_name.ch config -state disabled
    $grid.int_$add_name.con config -state disabled
    $grid.dec_$add_name.ch config -state disabled
    $grid.fra_$add_name.con config -state disabled
    $grid.trz_$add_name.ch config -state disabled
    $grid.min_$add_name.ent config -state disabled
    $grid.max_$add_name.ent config -state disabled
    update idletasks
   }
  }
 }

#=======================================================================
proc UI_PB_ads__CreateSecColAttr { page_obj grid no_row add_name } {
  global gpb_addr_var
  global gpb_fmt_var
  global prev_add_fmt
  global paOption
  global gPB
  set temp_var $gpb_addr_var($add_name,modal)
  set fmt_name $gpb_addr_var($add_name,fmt_name)
  set prev_add_fmt($add_name) $fmt_name
  set dat_frm $grid.dat_$add_name
  if { ![winfo exists $dat_frm] } \
  {
   set dat_frm [frame $grid.dat_$add_name]
   radiobutton $dat_frm.num -text "$gPB(addrsum,radio_num,Label)" \
   -variable gpb_fmt_var($fmt_name,dtype) -value Numeral \
   -command "UI_PB_ads__RadDataCallBack $page_obj $grid $no_row Numeral \
   $fmt_name"
   radiobutton $dat_frm.text -text "$gPB(addrsum,radio_text,Label)" \
   -variable gpb_fmt_var($fmt_name,dtype) -value "Text String" \
   -command "UI_PB_ads__RadDataCallBack $page_obj $grid $no_row Text \
   $fmt_name"
   pack $dat_frm.num -side left -anchor ne
   pack $dat_frm.text -side right -anchor nw
   set gPB(c_help,$dat_frm.num)    "format,data,num"
   set gPB(c_help,$dat_frm.text)   "format,data,text"
  }
  $grid set 2 $no_row -itemtype window -window $dat_frm
  set pls_frm $grid.plus_$add_name
  if { ![winfo exists $pls_frm] } \
  {
   set pls_frm [frame $grid.plus_$add_name]
   set plus [checkbutton $pls_frm.ch \
   -command "UI_PB_UpdateAllAddFmt $page_obj $fmt_name" \
   -variable gpb_fmt_var($fmt_name,plus_status)]
   pack $plus -anchor n
   set gPB(c_help,$plus)       "format,data,plus"
  }
  $grid set 3 $no_row -itemtype window -window $pls_frm
  set lez_frm $grid.lez_$add_name
  if { ![winfo exists $lez_frm] } \
  {
   set lez_frm [frame $grid.lez_$add_name]
   set lead_zero [checkbutton $lez_frm.ch \
   -command "UI_PB_UpdateAllAddFmt $page_obj $fmt_name" \
   -variable gpb_fmt_var($fmt_name,lead_zero)]
   pack $lead_zero -anchor n
   set gPB(c_help,$lead_zero)  "format,data,num,lead"
  }
  $grid set 4 $no_row -itemtype window -window $lez_frm
  set int_frm $grid.int_$add_name
  if { ![winfo exists $int_frm] } \
  {
   set int_frm [frame $grid.int_$add_name]
   set var 0
   UI_PB_ads__CreateIntControl $page_obj $int_frm con $fmt_name $add_name \
   [expr $no_row - 1]
   set gPB(c_help,[$int_frm.con subwidget entry])  \
   "format,data,num,integer"
  }
  $grid set 5 $no_row -itemtype window -window $int_frm
  set dec_frm $grid.dec_$add_name
  if { ![winfo exists $dec_frm] } \
  {
   set dec_frm [frame $grid.dec_$add_name]
   set dec_pt [checkbutton $dec_frm.ch \
   -command "UI_PB_UpdateAllAddFmt $page_obj $fmt_name" \
   -variable gpb_fmt_var($fmt_name,decimal)]
   pack $dec_pt -anchor n
   set gPB(c_help,$dec_pt) "format,data,num,decimal"
  }
  $grid set 6 $no_row -itemtype window -window $dec_frm
  set fra_frm $grid.fra_$add_name
  if { ![winfo exists $fra_frm] } \
  {
   set fra_frm [frame $grid.fra_$add_name]
   set var 0
   UI_PB_ads__CreateFracControl $page_obj $fra_frm con $fmt_name $add_name \
   [expr $no_row - 1]
   set gPB(c_help,[$fra_frm.con subwidget entry])  \
   "format,data,num,fraction"
  }
  $grid set 7 $no_row -itemtype window -window $fra_frm
  set trz_frm $grid.trz_$add_name
  if { ![winfo exists $trz_frm] } \
  {
   set trz_frm [frame $grid.trz_$add_name]
   set trail_zero [checkbutton $trz_frm.ch \
   -command "UI_PB_UpdateAllAddFmt $page_obj $fmt_name" \
   -variable gpb_fmt_var($fmt_name,trailzero)]
   pack $trail_zero -anchor n
   set gPB(c_help,$trail_zero)    "format,data,num,trail"
  }
  $grid set 8 $no_row -itemtype window -window $trz_frm
  set mod_frm $grid.modl_$add_name
  if { ![winfo exists $mod_frm] } \
  {
   set mod_frm [frame $grid.modl_$add_name]
   if 0 {
    tixOptionMenu $mod_frm.opt \
    -variable gpb_addr_var($add_name,modal) \
    -options { menubutton.width 6 }
    set opt_value(always) "$gPB(address,modal_drop,always,Label)"
    set opt_value(once) "$gPB(address,modal_drop,once,Label)"
    set opt_value(off) "$gPB(address,modal_drop,off,Label)"
    foreach opt {always once off} \
    {
     $mod_frm.opt add command $opt -label "$opt_value($opt)"
    }
    $mod_frm.opt config -value $temp_var
    tixForm $mod_frm.opt -top 3 -left %10 -right %95
    set gPB(c_help,[$mod_frm.opt subwidget menubutton])  "address,modality"
   }
   radiobutton $mod_frm.yes -text "$gPB(nav_button,yes,Label)" \
   -variable gpb_addr_var($add_name,modal) \
   -value off
   radiobutton $mod_frm.no  -text "$gPB(nav_button,no,Label)" \
   -variable gpb_addr_var($add_name,modal) \
   -value always
   pack $mod_frm.yes -side left
   pack $mod_frm.no  -side right
   set gPB(c_help,$mod_frm.yes)      "address,modality"
   set gPB(c_help,$mod_frm.no)       "address,modality"
  }
  $grid set 9 $no_row -itemtype window -window $mod_frm
  set min_frm $grid.min_$add_name
  if { ![winfo exists $min_frm] } \
  {
   set min_frm [frame $grid.min_$add_name]
   entry $min_frm.ent -width 8 -relief sunken \
   -textvariable gpb_addr_var($add_name,add_min)
   tixForm $min_frm.ent -top 3 -left %10 -right %95
   bind $min_frm.ent <KeyPress> "UI_PB_com_ValidateDataOfEntry %W %K f"
   bind $min_frm.ent <KeyRelease> { %W config -state normal }
   set gPB(c_help,$min_frm.ent)   "address,min,value"
  }
  $grid set 10 $no_row -itemtype window -window $min_frm
  set max_frm $grid.max_$add_name
  if { ![winfo exists $max_frm] } \
  {
   if { [string match "N" $add_name] } {
    if { [string match "" $gpb_addr_var($add_name,add_max)] } {
     global mom_sys_arr
     set gpb_addr_var($add_name,add_max) $mom_sys_arr(seqnum_max)
    }
   }
   set max_frm [frame $grid.max_$add_name]
   entry $max_frm.ent -width 8 -relief sunken \
   -textvariable gpb_addr_var($add_name,add_max)
   tixForm $max_frm.ent -top 3 -left %10 -right %95
   bind $max_frm.ent <KeyPress> "UI_PB_com_ValidateDataOfEntry %W %K f"
   bind $max_frm.ent <KeyRelease> { %W config -state normal }
   set gPB(c_help,$max_frm.ent)   "address,max,value"
  }
  $grid set 11 $no_row -itemtype window -window $max_frm
  set tra_frm $grid.trail_$add_name
  if { ![winfo exists $tra_frm] } \
  {
   set tra_frm [frame $grid.trail_$add_name]
   set but [entry $tra_frm.but \
   -textvariable gpb_addr_var($add_name,trailer) \
   -cursor hand2 \
   -width 5 -borderwidth 4 \
   -highlightcolor $paOption(focus) \
   -background $paOption(header_bg) \
   -foreground $paOption(seq_bg) \
   -selectbackground $paOption(focus) \
   -selectforeground black]
   bind $but <Enter> " CB__AttachPopupMenu page_obj $tra_frm $add_name \
   TRAILER "
   tixForm $but -top 3 -left 5
   set gPB(c_help,$but) "address,trailer"
  }
  $grid set 12 $no_row -itemtype window -window $tra_frm
 }

#=======================================================================
proc UI_PB_ads__CreateFracControl { page_obj inp_frm ext fmt_name add_name \
  no_row} {
  global gpb_fmt_var
  tixControl $inp_frm.$ext -integer true -min 0 -max 9 \
  -command "UI_PB_UpdateFmtDisplay $page_obj $add_name $fmt_name \
  $no_row" \
  -selectmode immediate \
  -variable gpb_fmt_var($fmt_name,fraction) \
  -options {
   entry.width 3
   label.anchor e
  }
  $inp_frm.$ext.frame config -relief sunken -bd 1
  $inp_frm.$ext.frame.entry config -relief flat
  set ent_widget [$inp_frm.$ext subwidget entry]
  bind $ent_widget <KeyPress> "UI_PB_com_ValidateDataOfEntry %W %K i"
  bind $ent_widget <KeyRelease> {%W config -state normal }
  grid $inp_frm.$ext -padx 5 -pady 4
 }

#=======================================================================
proc UI_PB_ads__CreateIntControl { page_obj inp_frm ext fmt_name add_name \
  no_row} {
  global gpb_fmt_var
  tixControl $inp_frm.$ext -integer true -min 0 -max 9 \
  -command "UI_PB_UpdateFmtDisplay $page_obj $add_name $fmt_name \
  $no_row" \
  -selectmode immediate \
  -variable gpb_fmt_var($fmt_name,integer) \
  -options {
   entry.width 3
   label.anchor e
  }
  $inp_frm.$ext.frame config -relief sunken -bd 1
  $inp_frm.$ext.frame.entry config -relief flat
  set ent_widget [$inp_frm.$ext subwidget entry]
  bind $ent_widget <KeyPress> "UI_PB_com_ValidateDataOfEntry %W %K i"
  bind $ent_widget <KeyRelease> {%W config -state normal }
  grid $inp_frm.$ext -padx 5 -pady 4
  pack $inp_frm.$ext.frame.entry -side right
  pack $inp_frm.$ext.frame.incr -side top
  pack $inp_frm.$ext.frame.decr -side bottom
 }

#=======================================================================
proc UI_PB_UpdateAllAddFmt { page_obj fmt_name args } {
  set addr_name_list $Page::($page_obj,cur_addsum_list)
  PB_int_GetAddrListFormat fmt_name fmt_addr_list
  if { [info exists fmt_addr_list] } \
  {
   set fmt_addr_list [lsort -dictionary $fmt_addr_list]
   set count 0
   while { $count < [llength $fmt_addr_list] } \
   {
    set first_add [lindex $fmt_addr_list $count]
    set sec_add [lindex $fmt_addr_list [expr $count + 1]]
    set temp_index [lsearch $addr_name_list $first_add]
    if { $temp_index != -1 && \
    [string compare $first_add $sec_add] == 0 } \
    {
     UI_PB_UpdateFmtDisplay $page_obj $first_add $fmt_name
     incr count 2
     } elseif { $temp_index == -1 && \
    [string compare $first_add $sec_add] == 0 } \
    {
     incr count 2
    } else \
    {
     incr count 1
    }
   }
  }
 }

#=======================================================================
proc UI_PB_UpdateFmtDisplay { page_obj add_name fmt_name args } {
  global gpb_fmt_var
  global gpb_addr_var
  global addr_app_text
  if { $gpb_fmt_var($fmt_name,decimal) == 1 } \
  {
   set fmt_obj_attr(1) "Numeral"
   } elseif { $gpb_fmt_var($fmt_name,decimal) == 0 && \
  $gpb_fmt_var($fmt_name,integer) == 0 } \
  {
   set fmt_obj_attr(1) "Text String"
   } elseif { $gpb_fmt_var($fmt_name,decimal) == 0 } \
  {
   set fmt_obj_attr(1) "Numeral"
  }
  set fmt_obj_attr(2) $gpb_fmt_var($fmt_name,plus_status)
  set fmt_obj_attr(3) $gpb_fmt_var($fmt_name,lead_zero)
  set fmt_obj_attr(4) $gpb_fmt_var($fmt_name,trailzero)
  set fmt_obj_attr(5) $gpb_fmt_var($fmt_name,integer)
  set fmt_obj_attr(6) $gpb_fmt_var($fmt_name,decimal)
  set fmt_obj_attr(7) $gpb_fmt_var($fmt_name,fraction)
  set addr_name_list $Page::($page_obj,cur_addsum_list)
  if { [lsearch $addr_name_list $add_name] != -1 } \
  {
   PB_int_GetAdsFmtValue add_name fmt_obj_attr dis_attr
   set addr_app_text($add_name) $dis_attr
  }
 }

#=======================================================================
proc UI_PB_ads__CreateSpecCharButton { PAGE_OBJ mid_frm } {
  upvar $PAGE_OBJ page_obj
  global paOption
  global gPB
  set bb [tixButtonBox $mid_frm.bb -orientation horizontal]
  switch $::tix_version {
   8.4 {
    $bb config -relief sunken -bd 1 -bg $paOption(header_bg) -padx 1 -pady 0 ;#<12-07-07 gsl> -padx was 0.
   }
   4.1 {
    $bb config -relief sunken -bd 1 -bg $paOption(header_bg) -padx 5 -pady 5
   }
  }
  $bb add spec -text "$gPB(other,tab,Label)"
  pack $bb -side bottom
  [$bb subwidget spec] config -padx 10 -command \
  "UI_PB_ads__CreateSpecialCharsWin $page_obj"
 }

#=======================================================================
proc UI_PB_ads__RestoreProtectedVars { w } {
  if { ![string match [winfo class $w] "Toplevel"] } {
   return
  }
  global gPB
  if { [info exists gPB(UDE_items_pro)] && $gPB(UDE_items_pro) != "" } {
   set gPB([lindex $gPB(UDE_items_pro) 0]) [lindex $gPB(UDE_items_pro) 1]
   set gPB([lindex $gPB(UDE_items_pro) 2]) [lindex $gPB(UDE_items_pro) 3]
   set gPB([lindex $gPB(UDE_items_pro) 4]) [lindex $gPB(UDE_items_pro) 5]
   __ads_ToggleUDE
   __ads_ToggleIhrUDE
   __ads_ToggleOwnUDE
  }
 }

#=======================================================================
proc UI_PB_ads__CreateSpecialCharsWin { page_obj } {
  global paOption tixOption
  global gPB
  set w [toplevel $gPB(active_window).spec]
  set toplevel_index [llength $gPB(toplevel_list)]
  set win_index [expr $toplevel_index + 1]
  set gPB(toplevel_disable_$win_index) 1
  UI_PB_com_CreateTransientWindow $w \
  "$gPB(addrsum,other_trans,title,Label)" "+200+100" \
  "" "UI_PB_ads_DisableAddrSumPageWidgets $page_obj" "" \
  "UI_PB_ads_ActivateAddrSumPageWidgets $page_obj $win_index"
  set page_frm [frame $w.f1 -relief sunken -bd 1]
  pack $page_frm -fill both -expand yes -padx 3 -pady 3 ;#<03-05-08 gsl> -padx 6 -pady 5
  set gPB(UDE_items_pro) [list]
  if { [info exists gPB(Include_UDE_Frame)] && \
   [winfo exists [lindex $gPB(Include_UDE_Frame) 0]] } {
   lappend gPB(UDE_items_pro) Include_UDE_Frame $gPB(Include_UDE_Frame) \
   Inherit_UDE_Frame $gPB(Inherit_UDE_Frame) \
   Inherit_OWN_UDE_Frame $gPB(Inherit_OWN_UDE_Frame)
  }
  UI_PB_ads_CreateSpecialChars page_obj $page_frm
  bind $w <Destroy> "+ UI_PB_ads__RestoreProtectedVars %W"
  set frame [frame $w.f2]
  pack $frame -side bottom -fill x -padx 3 -pady 3
  set box1_frm [frame $frame.box1]
  set box2_frm [frame $frame.box2]
  tixForm $box1_frm -top 0 -left 0 -right %60 -padright 20
  tixForm $box2_frm -top 0 -left $box1_frm -right %100
  set first_list  {"gPB(nav_button,default,Label)"\
   "gPB(nav_button,restore,Label)"\
  "gPB(nav_button,apply,Label)"}
  set second_list {"gPB(nav_button,cancel,Label)"\
  "gPB(nav_button,ok,Label)"}
  set cb_arr(gPB(nav_button,default,Label)) "UI_PB_ads_SpecDefaultCallBack"
  set cb_arr(gPB(nav_button,restore,Label)) "UI_PB_ads_SpecRestCallBack $page_obj"
  set cb_arr(gPB(nav_button,apply,Label))   "UI_PB_ads_SpecApplyCallBack $page_obj"
  set cb_arr(gPB(nav_button,cancel,Label)) "UI_PB_ads_SpecCancelCallBack $page_obj $w"
  set cb_arr(gPB(nav_button,ok,Label))     "UI_PB_ads_SpecOkCallBack $page_obj $w"
  UI_PB_com_CreateButtonBox $box1_frm first_list cb_arr
  UI_PB_com_CreateButtonBox $box2_frm second_list cb_arr
  UI_PB_com_PositionWindow $w
 }

#=======================================================================
proc UI_PB_ads_ActivateAddrSumPageWidgets { page_obj win_index } {
  global gPB
  global paOption
  set grid $gPB(tix_grid)
  if { $gPB(toplevel_disable_$win_index) } \
  {
   if 0 {
    tixEnableAll $Page::($page_obj,page_id)
   }
   set gPB(toplevel_disable_$win_index) 0
   PB_int_RetAddrNameList add_name_list
   foreach add_name $add_name_list \
   {
    set addn $grid.name_$add_name.name
    bind $addn <Enter> "%W config -bg $paOption(focus) -relief solid"
    bind $addn <Enter> "+%W config -highlightbackground $paOption(special_bg)"
    bind $addn <Leave> "%W config -bg $paOption(table_bg) -relief flat"
    bind $addn <Leave> "+%W config -highlightbackground $paOption(table_bg)"
    PB_enable_balloon $addn
    set add_frm $grid.add_$add_name
    bind $add_frm.but <Enter> " CB__AttachPopupMenu page_obj \
    $add_frm $add_name LEADER "
    set trail_frm $grid.trail_$add_name
    bind $trail_frm.but <Enter> " CB__AttachPopupMenu page_obj \
    $trail_frm $add_name TRAILER "
   }
   set grid $gPB(tix_grid)
   $grid config -state disabled
  }
 }

#=======================================================================
proc UI_PB_ads_DisableAddrSumPageWidgets { page_obj } {
  global gPB
  set grid $gPB(tix_grid)
  PB_int_RetAddrNameList add_name_list
  foreach add_name $add_name_list \
  {
   set w $grid.add_$add_name
   bind $w.but <Enter> ""
   bind $w.but <3> ""
   if { [winfo exists $w.pop] } {
    destroy $w.pop
   }
   set w $grid.trail_$add_name
   bind $w.but <Enter> ""
   bind $w.but <3> ""
   if { [winfo exists $w.pop] } {
    destroy $w.pop
   }
   PB_disable_balloon $grid.name_$add_name.name
  }
  if 0 {
   tixDisableAll $grid
   tixDisableAll $Page::($page_obj,page_id)
  }
 }

#=======================================================================
proc UI_PB_ads_SpecOkCallBack { page_obj w } {
  if { ![UI_PB_ads_SpecApplyCallBack $page_obj] } {
   return
  }
  destroy $w
 }

#=======================================================================
proc UI_PB_ads_SpecDefaultCallBack { } {
  global mom_sys_arr
  global special_char
  if 0 {
   set mom_var_list {0 "seqnum_start" 1 "seqnum_incr" 2 "seqnum_freq" \
    3 "\$mom_sys_gcodes_per_block" 4 "\$mom_sys_mcodes_per_block" \
    5 "\$mom_sys_opskip_block_leader" 6 "Word_Separator" \
   7 "End_of_Block" 8 "Comment_Start" 9 "Comment_End"}
  }
  set mom_var_list {0 "seqnum_start" 1 "seqnum_incr" 2 "seqnum_freq" 3 "seqnum_max" \
   4 "\$mom_sys_gcodes_per_block" 5 "\$mom_sys_mcodes_per_block" \
   6 "\$mom_sys_opskip_block_leader" 7 "Word_Separator" \
  8 "End_of_Block" 9 "Comment_Start" 10 "Comment_End"}
  if { [PB_is_v 3.1] } {
   lappend mom_var_list 11 "Include_UDE" 12 "Inherit_UDE"
   if { $::env(PB_UDE_ENABLED) == 1 } {
    lappend mom_var_list 13 "Own_UDE" 14 "OWN_CDL_File_Folder"
   }
  }
  array set mom_var_arr $mom_var_list
  PB_int_RetDefMOMVarValues mom_var_arr mom_var_value
  set nvar [array size mom_var_arr]
  for {set count 0} {$count < $nvar} {incr count} \
  {
   set var $mom_var_arr($count)
   set mom_sys_arr($var) $mom_var_value($var)
  }
  for {set count 7} {$count < 11} {incr count} \
  {
   set option_lab $mom_var_arr($count)
   UI_PB_ads__GetValuesForSpecOptions option_lab opt_value
   set special_char($option_lab,label) $opt_value
   set special_char($option_lab,char) $mom_sys_arr($option_lab)
  }
  if { [PB_is_v 3.1] } {
   global ads_cdl_arr
   __ads_cdl_DeleteAllCdlFiles
   set type_list [list $ads_cdl_arr(type_other) $ads_cdl_arr(type_inherit)]
   foreach cdl_type $type_list {
    set ads_cdl_arr($cdl_type,cdl_list) $ads_cdl_arr($cdl_type,def_cdl_list)
    foreach opt_val $ads_cdl_arr($cdl_type,cdl_list) {
     __ads_cdl_CreateOption $ads_cdl_arr($cdl_type,wtext) $cdl_type $opt_val
    }
    __ads_cdl_SetPopupMenuState $ads_cdl_arr($cdl_type,wtext) $cdl_type
    __ads_cdl_SetListBalloonState $ads_cdl_arr($cdl_type,wtext) $cdl_type
   }
  }
  if { [PB_is_v 3.1] } {
   __ads_ToggleUDE
   __ads_ToggleIhrUDE
   if { $::env(PB_UDE_ENABLED) == 1 } {
    __ads_ToggleOwnUDE
   }
  }
 }

#=======================================================================
proc UI_PB_ads_SpecRestCallBack { page_obj } {
  global mom_sys_arr
  global special_char
  set mom_var_list {"seqnum_start" "seqnum_incr" "seqnum_freq" "seqnum_max" \
   "\$mom_sys_gcodes_per_block" "\$mom_sys_mcodes_per_block" \
   "\$mom_sys_opskip_block_leader" "Word_Separator" \
  "End_of_Block" "Comment_Start" "Comment_End"}
  if { [PB_is_v 3.1] } {
   lappend mom_var_list "Include_UDE" "Inherit_UDE"
   if { $::env(PB_UDE_ENABLED) == 1 } {
    lappend mom_var_list "Own_UDE"  "OWN_CDL_File_Folder"
   }
  }
  array set rest_mom_value $Page::($page_obj,rest_spec_momvar)
  foreach var $mom_var_list \
  {
   set mom_sys_arr($var) $rest_mom_value($var)
  }
  for {set count 7} {$count < 11} {incr count} \
  {
   set option_lab [lindex $mom_var_list $count]
   UI_PB_ads__GetValuesForSpecOptions option_lab opt_value
   set special_char($option_lab,label) $opt_value
   set special_char($option_lab,char) $mom_sys_arr($option_lab)
  }
  if { [PB_is_v 3.1] } {
   global ads_cdl_arr
   __ads_cdl_DeleteAllCdlFiles
   set type_list [list $ads_cdl_arr(type_other) $ads_cdl_arr(type_inherit)]
   foreach cdl_type $type_list {
    set ads_cdl_arr($cdl_type,cdl_list) $ads_cdl_arr($cdl_type,rest_cdl_list)
    foreach opt_val $ads_cdl_arr($cdl_type,cdl_list) {
     __ads_cdl_CreateOption $ads_cdl_arr($cdl_type,wtext) $cdl_type $opt_val
    }
    __ads_cdl_SetPopupMenuState $ads_cdl_arr($cdl_type,wtext) $cdl_type
    __ads_cdl_SetListBalloonState $ads_cdl_arr($cdl_type,wtext) $cdl_type
   }
  }
  if { [PB_is_v 3.1] } {
   __ads_ToggleUDE
   __ads_ToggleIhrUDE
   if { $::env(PB_UDE_ENABLED) == 1 } {
    __ads_ToggleOwnUDE
   }
  }
 }

#=======================================================================
proc UI_PB_ads_SpecCancelCallBack { page_obj w } {
  UI_PB_ads_SpecRestCallBack $page_obj
  destroy $w
 }

#=======================================================================
proc UI_PB_ads_ValidateIncludeItems {PASS ERROR_INFO check_display} {
  upvar $PASS pass
  upvar $ERROR_INFO error_info
  global mom_sys_arr
  global gPB
  if { $check_display == 1 || $check_display == 2 } {
   if { 0 && [info exists mom_sys_arr(Inherit_UDE)] && $mom_sys_arr(Inherit_UDE) == 1 } {
    if { $mom_sys_arr(PST_File_Name) == "" } {
     set pass 1
     set error_info 2
    }
    if 0 {
     if { $mom_sys_arr(PST_File_Folder) == "" || \
      ![string match "\$UGII_*" $mom_sys_arr(PST_File_Folder)] } {
      set pass 1
      set error_info 3
     }
     } else {
     if { [string length $mom_sys_arr(PST_File_Folder)] && \
      ![string match "\$UGII_*" $mom_sys_arr(PST_File_Folder)] } {
      set pass 1
      set error_info 3
     }
    }
   }
   if { [info exists mom_sys_arr(Own_UDE)] && $mom_sys_arr(Own_UDE) == 1 } {
    if 0 {
     if { $mom_sys_arr(OWN_CDL_File_Folder) == "" || \
      ![string match "\$UGII_*" $mom_sys_arr(OWN_CDL_File_Folder)] } {
      set pass 1
      set error_info 4
     }
     } else {
     if {  [string length $mom_sys_arr(OWN_CDL_File_Folder)] && \
      ![string match "\$UGII_*" $mom_sys_arr(OWN_CDL_File_Folder)] } {
      set pass 1
      set error_info 4
     }
    }
   }
  }
  if { $check_display == 2 || $check_display == 3 } {
   if { $pass == 1 } {
    switch $error_info {
     2 {
      tk_messageBox -parent [UI_PB_com_AskActiveWindow] \
      -type ok -icon error \
      -message "$gPB(msg,no_cdl_name)"
     }
     3 {
      tk_messageBox -parent [UI_PB_com_AskActiveWindow] \
      -type ok -icon error \
      -message "$gPB(msg,no_def_name)"
     }
     4 {
      tk_messageBox -parent [UI_PB_com_AskActiveWindow] \
      -type ok -icon error \
      -message "$gPB(msg,no_own_name)"
     }
     8 {
      tk_messageBox -parent [UI_PB_com_AskActiveWindow] \
      -type ok -icon error \
      -message "$gPB(msg,no_oth_ude_name)"
     }
     9 {
      tk_messageBox -parent [UI_PB_com_AskActiveWindow] \
      -type ok -icon error \
      -message "$gPB(msg,not_oth_cdl_file)"
     }
     default {}
    }
   }
  }
 }

#=======================================================================
proc UI_PB_ads_SpecApplyCallBack { page_obj } {
  global mom_sys_arr
  global special_char
  global gPB
  set mom_var_list {"Word_Separator" "End_of_Block" \
  "Comment_Start" "Comment_End"}
  set max [UI_PB_ads_ExceedMaxSeqNum]
  if { $max } {
   tk_messageBox -parent [UI_PB_com_AskActiveWindow] \
   -type ok -icon error \
   -message "$gPB(msg,seq_num_max) $max."
   return 0
  }
  set pass 0
  set error_code 0
  set check_display 2
  UI_PB_ads_ValidateIncludeItems pass error_code $check_display
  if { $pass == 1 } {
   return 0
  }
  foreach var $mom_var_list {
   set mom_sys_arr($var) $special_char($var,char)
  }
  PB_int_UpdateMOMVar mom_sys_arr
  __ads_UpdateSpecChars $page_obj
  return 1
 }

#=======================================================================
proc UI_PB_ads_ExceedMaxSeqNum { args } {
  global post_object
  global mom_sys_arr
  set obj -1
  set fmt ""
  if { [llength $args] } {
   Post::GetObjList $post_object format obj_list
   set fmt [lindex $args 0]
   PB_com_RetObjFrmName fmt obj_list obj
  }
  if 0 {
   if { $obj <= 0 } {
    Post::GetObjList $post_object address obj_list
    set name N
    PB_com_RetObjFrmName name obj_list obj
    address::readvalue $obj obj_attr
    set obj $obj_attr(1)
   }
   } else {
   Post::GetObjList $post_object address obj_list
   set name N
   PB_com_RetObjFrmName name obj_list add_obj
   address::readvalue $add_obj obj_attr
   set fmt_obj $obj_attr(1)
   if { $obj <= 0 } {
    set obj $fmt_obj
    } else {
    if { ![string match "$fmt" $format::($fmt_obj,for_name)] } {
     return 0
    }
   }
  }
  set max [PB_com_GetFmtMaxVal $obj]
  if { $mom_sys_arr(seqnum_max) > $max } {
   return $max
   } else {
   return 0
  }
 }

#=======================================================================
proc UI_PB_ads_CreateSpecialChars { PAGE_OBJ page_frm } {
  upvar $PAGE_OBJ page_obj
  global paOption tixOption
  global mom_sys_arr
  global gPB
  set f [frame $page_frm.f]
  pack $f -side top -pady 3
  tixLabelFrame $f.top  -label "$gPB(other,seq_num,Label)"
  tixLabelFrame $f.bot  -label "$gPB(other,chars,Label)"
  tixLabelFrame $f.gmcd -label "$gPB(other,gm_codes,Label)"
  tixLabelFrame $f.ops  -label "$gPB(other,opskip,Label)"
  set include_ude_cdl 0
  if { [PB_is_v 3.1] } {
   set include_ude_cdl 1
  }
  if { $include_ude_cdl } {
   tixLabelFrame $f.ude  -label "$gPB(other,ude,Label)"
   __ads_CreateCDLFrame $page_obj $f.ude
  }
  if 0 {
   tixForm $f.top -top 10 -right %50 -pady 5 -padx 10
   tixForm $f.bot -top 10 -bottom &$f.top -left $f.top -pady 5 -padx 10
   tixForm $f.ops -top $f.bot -left &$f.top -right $f.bot \
   -pady 5 -padx 10
   if { $include_ude_cdl } {
    tixForm $f.ude  -top $f.top -left $f.ops -right &$f.bot \
    -pady 5 -padx 10
   }
   } else {
   set padx 12
   set pady 2 ;#<03-18-10 wbh> 2 was 3.
   if 0 {
    tixForm $f.bot -top $f.top -right %50                   -pady $pady -padx 10
    tixForm $f.top -top 10     -right %50    -left  &$f.bot -pady $pady -padx 10
    tixForm $f.ude -top 10     -left  $f.top                -pady $pady -padx 10
    tixForm $f.ops -top $f.ude -left  $f.bot -right &$f.ude -pady $pady -padx 10
    } elseif 0 {
    tixForm $f.top -top 10 -right %50                      -pady $pady -padx 10
    tixForm $f.bot -top 10 -bottom &$f.top -left $f.top    -pady $pady -padx 10
    tixForm $f.ops -top $f.bot -left &$f.top -right $f.bot -pady 80    -padx 10
    tixForm $f.ude -top $f.top -left $f.ops -right &$f.bot -pady $pady -padx 10
    } elseif 0 {
    tixForm $f.ude -top 10     -left  %47                    -pady $pady -padx $padx
    tixForm $f.ops -top $f.ude -left  %47    -left  &$f.ude  -pady $pady -padx $padx \
    -right &$f.ude
    tixForm $f.bot -top $f.top -right $f.ude -bottom &$f.ops -pady $pady -padx $padx
    tixForm $f.top -top 10     -right $f.ude -left  &$f.bot  -pady $pady -padx $padx
    } elseif 1 {
    if 0 {
     tixForm $f.ude -top 0       -left %47                     -pady $pady -padx $padx
     tixForm $f.bot -top $f.top                 -right $f.ude  -pady $pady -padx $padx
     tixForm $f.top -top 0       -left &$f.bot  -right $f.ude  -pady $pady -padx $padx
     tixForm $f.ops -top $f.bot  -left &$f.bot  -right $f.ude  -pady $pady -padx $padx  -bottom &$f.ude
     } else {
     tixForm $f.bot -top $f.top                  -right %47      -pady $pady -padx $padx
     tixForm $f.top -top 0        -left &$f.bot  -right &$f.bot  -pady $pady -padx $padx
     tixForm $f.ops -top $f.bot   -left &$f.bot  -right &$f.bot  -pady $pady -padx $padx
     tixForm $f.ude -top &$f.top  -left $f.top                   -pady $pady -padx $padx  -bottom &$f.ops
    }
   }
  }
  set top_frm [$f.top subwidget frame]
  set label ""
  set start_frm [frame $top_frm.start]
  pack $start_frm -side top -fill x -expand yes -padx 10 -pady 3 ;# was 5
  set start_left  [frame $start_frm.left]
  set start_right [frame $start_frm.right]
  pack $start_left  -side left
  pack $start_right -side right
  set lab_start [label $start_left.lbl -anchor w \
  -text "$gPB(other,seq_num,start,Label)"]
  pack $lab_start -side left -fill both
  Page::CreateIntControl seqnum_start $start_right int $label
  set gPB(c_help,[$start_right.int subwidget entry])          "other,seq_num,start"
  if 0 {
   pack $start_frm -side top -fill x -expand yes -padx 5 -pady 3
   UI_PB_mthd_CreateLblEntry i seqnum_start \
   $start_frm par "$gPB(other,seq_num,start,Label)"
   bind $start_frm.1_par <KeyPress> "UI_PB_com_ValidateDataOfEntry %W %K i 1"
   set gPB(c_help,$start_frm.1_par)               "other,seq_num,start"
  }
  set incr_frm [frame $top_frm.incr]
  pack $incr_frm -side top -fill x -expand yes -padx 10 -pady 3 ;# was 5
  set incr_left  [frame $incr_frm.left]
  set incr_right [frame $incr_frm.right]
  pack $incr_left  -side left
  pack $incr_right -side right
  set lab_incr [label $incr_left.lbl -anchor w \
  -text "$gPB(other,seq_num,inc,Label)"]
  pack $lab_incr -side left -fill both
  Page::CreateIntControl seqnum_incr $incr_right int $label
  $incr_right.int config -min 1
  $incr_right.int config -integer false
  $incr_right.int config -min 0
  $incr_right.int config -value $mom_sys_arr(seqnum_incr)
  set gPB(c_help,[$incr_right.int subwidget entry])               "other,seq_num,inc"
  if 0 {
   pack $incr_frm -side top -fill x -expand yes -padx 5 -pady 3
   UI_PB_mthd_CreateLblEntry f seqnum_incr \
   $incr_frm par "$gPB(other,seq_num,inc,Label)"
   bind $incr_frm.1_par <KeyPress> "UI_PB_com_ValidateDataOfEntry %W %K f 1"
   set gPB(c_help,$incr_frm.1_par) "other,seq_num,inc"
  }
  set freq_frm [frame $top_frm.freq]
  pack $freq_frm -side top -fill x -expand yes -padx 10 -pady 3 ;# was 5
  set freq_left  [frame $freq_frm.left]
  set freq_right [frame $freq_frm.right]
  pack $freq_left  -side left
  pack $freq_right -side right
  set lab_freq [label $freq_left.lbl -anchor w \
  -text "$gPB(other,seq_num,freq,Label)"]
  $lab_freq config -width 25
  pack $lab_freq -side left -fill both
  Page::CreateIntControl seqnum_freq $freq_right int $label
  $freq_right.int config -min 1
  if { [PB_is_v3] >= 0 } {
   set max_frm [frame $top_frm.max]
   pack $max_frm -side top -fill x -expand yes -padx 5 -pady 3
   UI_PB_mthd_CreateLblEntry f seqnum_max \
   $max_frm par "$gPB(other,seq_num,max,Label)"
   bind $max_frm.1_par <KeyPress> "UI_PB_com_ValidateDataOfEntry %W %K f 1"
   pack $max_frm.1_par -padx 10
   set gPB(c_help,$max_frm.1_par) "other,seq_num,max"
  }
  set spc_frm [$f.bot subwidget frame]
  set option_1 {"gPB(other,opt_none,Label)"  "gPB(other,opt_space,Label)" \
   "gPB(other,opt_dec,Label)"   "gPB(other,opt_comma,Label)" \
   "gPB(other,opt_semi,Label)"  "gPB(other,opt_colon,Label)" \
  "gPB(other,opt_text,Label)"}
  set option_2 {"gPB(other,opt_none,Label)"  "gPB(other,opt_left,Label)" \
   "gPB(other,opt_right,Label)" "gPB(other,opt_pound,Label)" \
   "gPB(other,opt_aster,Label)" "gPB(other,opt_comma,Label)" \
   "gPB(other,opt_semi,Label)"  "gPB(other,opt_colon,Label)" \
  "gPB(other,opt_slash,Label)" "gPB(other,opt_text,Label)" }
  set label_list {"Word_Separator" "End_of_Block" "Comment_Start" \
  "Comment_End"}
  set count 0
  foreach label $label_list \
  {
   if { $count < 1 } \
   {
    set options $option_1
    } elseif { $count == 1 } \
   {
    set options $option_1
    lappend options "gPB(other,opt_new_line,Label)"
   } else \
   {
    set options $option_2
   }
   UI_PB_ads__GetValuesForSpecOptions label default
   UI_PB_ads__CreateSpecAttr $spc_frm $label $options $count default
   incr count
   unset options
  }
  set ops_frm [$f.ops subwidget frame]
  UI_PB_mthd_CreateLblEntry s \$mom_sys_opskip_block_leader \
  $ops_frm par $gPB(other,opskip,leader,Label)
  tixForm $ops_frm -padx 5 ;#<03-06-03 gsl> was 10
  set gmcd_frm [$f.gmcd subwidget frame]
  set gcd_frm [frame $gmcd_frm.gcd]
  set mcd_frm [frame $gmcd_frm.mcd]
  checkbutton $gcd_frm.chk -variable mom_sys_arr(\$gcode_status) \
  -relief flat -bd 2 -text "$gPB(other,g_codes,num,Label)" \
  -anchor w -command "UI_PB_ads__SetStatusGMButton gcd $gcd_frm.int"
  pack $gcd_frm.chk -side left
  Page::CreateIntControl \$mom_sys_gcodes_per_block $gcd_frm int ""
  checkbutton $mcd_frm.chk -variable om_sys_arr(\$mcode_status) \
  -relief flat -bd 2 -text "$gPB(other,m_codes,Label)" \
  -anchor w -command "UI_PB_ads__SetStatusGMButton mcd $mcd_frm.int"
  pack $mcd_frm.chk -side left
  Page::CreateIntControl \$mom_sys_mcodes_per_block $mcd_frm int ""
  UI_PB_ads__SetStatusGMButton gcd $gcd_frm.int
  UI_PB_ads__SetStatusGMButton mcd $mcd_frm.int
  global gPB
  set gPB(c_help,[$freq_right.int subwidget entry])       "other,seq_num,freq"
  set gPB(c_help,[$spc_frm.0.opt subwidget menubutton])   "other,chars,word_sep"
  set gPB(c_help,[$spc_frm.1.opt subwidget menubutton])   "other,chars,end_of_block"
  set gPB(c_help,[$spc_frm.2.opt subwidget menubutton])   "other,chars,comment_start"
  set gPB(c_help,[$spc_frm.3.opt subwidget menubutton])   "other,chars,comment_end"
  set gPB(c_help,$gcd_frm.chk)                "other,g_codes"
  set gPB(c_help,[$gcd_frm.int subwidget entry])      "other,g_codes,num"
  set gPB(c_help,$mcd_frm.chk)                "other,m_codes"
  set gPB(c_help,[$mcd_frm.int subwidget entry])      "other,m_codes,num"
  set gPB(c_help,$ops_frm.1_par)                              "other,opskip,leader"
 }

#=======================================================================
proc __ads_BrowsePost {} {
  global gPB
  global tcl_platform
  global mom_sys_arr
  set action OK
  UI_PB_com_SetStatusbar "$gPB(ude,import,sel,pui,status)"
  if { ![info exists gPB(ude_post)] } {
   set gPB(ude_post) ""
  }
  if { $tcl_platform(platform) == "unix" } \
  {
   UI_PB_file_SelectFile_unx PUI gPB(ude_post) open
   } elseif { $tcl_platform(platform) == "windows" } \
  {
   UI_PB_com_GrayOutSaveOptions
   UI_PB_com_DisableMain
   UI_PB_file_SelectFile_win PUI gPB(ude_post) open 1
   set length [llength $gPB(ude_post)]
   if { $length == 2 } {
    set action [lindex $gPB(ude_post) end]
    set gPB(ude_post) [lindex $gPB(ude_post) 0]
   }
   UI_PB_com_EnableMain
   UI_PB_com_UnGraySaveOptions
  }
  set gPB(ude_post) [string trim $gPB(ude_post) \"]
  if { [file exists $gPB(ude_post)] && \
   [string match OK $action] && \
   [file isfile $gPB(ude_post)] } {
   if 0 {
    if { [file exists [file rootname $gPB(ude_post)].cdl] } {
     set post "\$UGII_CAM_POST_DIR/[lindex [split [file tail $gPB(ude_post) ] .] 0]"
     set mom_sys_arr(PST_File_Name) $post.cdl
     set mom_sys_arr(PST_File_Folder) $post.def
     } else {
     if 0 {
      tk_messageBox -message $gPB(msg,no_cdl_file) -icon warning \
      -parent [UI_PB_com_AskActiveWindow]
      __ads_BrowsePost
      } else {
      set post "\$UGII_CAM_POST_DIR/[lindex [split [file tail $gPB(ude_post) ] .] 0]"
      set mom_sys_arr(PST_File_Name) $post.cdl
      set mom_sys_arr(PST_File_Folder) $post.def
     }
    }
   }
   set mom_sys_arr(PST_File_Name) [lindex [split [file tail $gPB(ude_post)] .] 0]
   if { [string match $mom_sys_arr(PST_File_Folder) ""] } {
    set mom_sys_arr(PST_File_Folder) "\$UGII_CAM_POST_DIR/"
   }
   tk_messageBox -message $gPB(msg,cdl_info) -icon info \
   -parent [UI_PB_com_AskActiveWindow]
  }
 }

#=======================================================================
proc __ads_BrowseUDE { w args } {
  global gPB
  global tcl_platform
  UI_PB_com_SetStatusbar "$gPB(ude,import,sel,cdl,status)"
  if { ![info exists gPB(ude_cdl)] } {
   set gPB(ude_cdl) ""
  }
  if { $tcl_platform(platform) == "unix" } \
  {
   UI_PB_file_SelectFile_unx CDL gPB(ude_cdl) open
   } elseif { $tcl_platform(platform) == "windows" } \
  {
   if { [PB_file_is_JE_POST_DEV] || $::__INCLUDE_OTHER_CDL_AND_DEF } {
    UI_PB_file_SelectFile_win CDL_DEF gPB(ude_cdl) open
    } else {
    UI_PB_file_SelectFile_win CDL gPB(ude_cdl) open
   }
  }
  if 0 {
   if { $gPB(ude_cdl) != "" } {
    if { [string match "windows" $tcl_platform(platform)] } {
     set post [join [split $gPB(ude_cdl) \\] /]
     } else {
     set post $gPB(ude_cdl)
    }
    $w delete 0 end
    $w insert 0 $post
   }
  }
  set gPB(ude_cdl) [string trim $gPB(ude_cdl) \"]
  if { $gPB(ude_cdl) != "" } {
   set post "\$UGII_CAM_USER_DEF_EVENT_DIR/[file tail $gPB(ude_cdl)]"
   $w delete 0 end
   $w insert 0 $post
  }
 }

#=======================================================================
proc __ads_ToggleUDE {} {
  global gPB mom_sys_arr
  global ads_cdl_arr
  set lst [lindex $gPB(Include_UDE_Frame) 0]
  if { $mom_sys_arr(Include_UDE) } {
   __ads_cdl_SetListWidgetState $lst $ads_cdl_arr(type_other) normal
   } else {
   __ads_cdl_SetListWidgetState $lst $ads_cdl_arr(type_other) disabled
  }
  set mom_sys_arr(other_cdl_list) $ads_cdl_arr($ads_cdl_arr(type_other),cdl_list)
 }

#=======================================================================
proc __ads_Sync_Filename {varName index op} {
  global mom_sys_arr
  set var ${varName}\(${index}\)
  set filename [lindex [split [set $var] .] 0]
  if { ![string match "*$filename.cdl" $mom_sys_arr(OWN_CDL_File_Folder)] } {
   set old_str_list [split $mom_sys_arr(OWN_CDL_File_Folder) /]
   if { [llength $old_str_list] == 1 } {
    set str "\$UGII_CAM_USER_DEF_EVENT_DIR/$filename.cdl"
    set mom_sys_arr(OWN_CDL_File_Folder) $str
    } else {
    set str_list [lreplace $old_str_list end end $filename.cdl]
    set str [join $str_list /]
    set mom_sys_arr(OWN_CDL_File_Folder) $str
   }
  }
 }

#=======================================================================
proc __ads_ToggleOwnUDE {} {
  global gPB
  global mom_sys_arr
  global tix_version
  global paOption
  global post_object
  set ent [lindex $gPB(Inherit_OWN_UDE_Frame) 0]
  set lbl [lindex $gPB(Inherit_OWN_UDE_Frame) 1]
  if { $mom_sys_arr(Own_UDE) } {
   $ent config -state normal
   bind $ent <KeyPress> "__ads_ValidateIncludeUdePath %W %K %A folder"
   bind $ent <KeyRelease> "__ads_ValidateIncludeUdePath_Release %W %K"
   if 0 {
    if { [string match $mom_sys_arr(OWN_CDL_File_Folder) ""] } {
     set filename [lindex [split $Post::($post_object,out_pui_file) .] 0]
     set str "\$UGII_CAM_USER_DEF_EVENT_DIR/$filename.cdl"
     set mom_sys_arr(OWN_CDL_File_Folder) $str
     trace variable Post::($post_object,out_pui_file) w __ads_Sync_Filename
     } else {
     set Post::($post_object,out_pui_file) $Post::($post_object,out_pui_file)
    }
   }
   if 0 {
    if { [string match $mom_sys_arr(OWN_CDL_File_Folder) "PST_File_Folder"] } {
     set mom_sys_arr(OWN_CDL_File_Folder) "\$UGII_CAM_USER_DEF_EVENT_DIR/"
    }
   }
   if { $tix_version == "4.1" } {
    $ent config -bg $gPB(entry_color)
   }
   if { $::tix_version == "8.4" } {
    $lbl config -state normal
   }
   } else {
   $ent config -state disabled
   bind $ent <KeyPress> {}
   bind $ent <KeyRelease> {}
   if { $tix_version == "4.1" } {
    $ent config -bg $paOption(entry_disabled_bg)
   }
   if { $::tix_version == "8.4" } {
    $lbl config -state disabled
   }
  }
 }

#=======================================================================
proc __ads_ValidateIncludeUdePath {w keysum ascii type} {
  set str [$w get]
  if { [$w selection present] } {
   set sel_first [$w index sel.first]
   set sel_end [$w index sel.last]
   set str "[string range $str 0 [expr $sel_first - 1]][string range $str $sel_end end]"
   set idx $sel_first
   if { [info exists ::gPB(prev_key)] && \
    [regexp {(Control_L)|(Control_R)} $::gPB(prev_key)] } {
    if { [regexp {[v]} $keysum] } {
     if { [catch { set str_in_mem [selection get -selection CLIPBOARD] }] } {
      set temp_str "[string range $str 0 [expr $idx - 1]]$ascii[string range $str $idx end]"
      } else {
      set temp_str "[string range $str 0 [expr $idx - 1]]$str_in_mem[string range $str $idx end]"
     }
     } else {
     set temp_str "[string range $str 0 [expr $idx - 1]]$ascii[string range $str $idx end]"
    }
    } else {
    set temp_str "[string range $str 0 [expr $idx - 1]]$ascii[string range $str $idx end]"
   }
   } else {
   set idx [$w index insert]
   if { [info exists ::gPB(prev_key)] && \
    [regexp {(Control_L)|(Control_R)} $::gPB(prev_key)] } {
    if { [regexp {[v]} $keysum] } {
     if { [catch { set str_in_mem [selection get -selection CLIPBOARD] }] } {
      set temp_str "[string range $str 0 [expr $idx - 1]]$ascii[string range $str $idx end]"
      } else {
      set temp_str "[string range $str 0 [expr $idx - 1]]$str_in_mem[string range $str $idx end]"
     }
     } else {
     set temp_str "[string range $str 0 [expr $idx - 1]]$ascii[string range $str $idx end]"
    }
    } else {
    set temp_str "[string range $str 0 [expr $idx - 1]]$ascii[string range $str $idx end]"
   }
  }
  switch -exact $type {
   "fname"  {
    set pattern1 {^[a-z0-9A-Z_-]+$}
    set pattern2 {(\.)|(/)|(\$)}
   }
   "folder" {
    set pattern1 {^(\$?)[a-z0-9A-Z_/-]+$|^\$$}
    set pattern2 {(\.)|(//)|(^\$[^$]*\$[^$]*$)}
   }
   "both"   {
    set pattern1 {^(\$?)[a-z0-9A-Z_./-]+$|^\$$}
    set pattern2 {(\.[^.]*\.[^.]*)|(//)|(^\$[^$]+\$[^$]*$)}
   }
  }
  set disable_flag 0
  if { ![regexp {^$} $temp_str] } {
   if { ![regexp $pattern1 $temp_str] } {
    set disable_flag 1
    } elseif { [regexp $pattern2 $temp_str] } {
    set disable_flag 1
   }
  }
  if { $disable_flag == 1 } {
   if  ![regexp {(Return)|(BackSpace)|(Delete)} $keysum] {
    set do_disabled 0
    if { [info exists ::gPB(prev_key)] && \
     [regexp {(Control_L)|(Control_R)} $::gPB(prev_key)] } {
     if { ![regexp {[cvx]} $keysum] } {
      set do_disabled 1
      } elseif { [regexp $pattern2 $temp_str] } {
      set do_disabled 1
     }
     } else {
     set do_disabled 1
    }
    if { $do_disabled == 1 } {
     $w config -state disabled
    }
   }
  }
  if { [regexp {(Control_L)|(Control_R)} $keysum] } {
   set ::gPB(prev_key) $keysum
  }
 }

#=======================================================================
proc __ads_ValidateIncludeUdePath_Release {w keysum} {
  $w config -state normal
  if { [info exists ::gPB(prev_key)] } {
   unset ::gPB(prev_key)
  }
 }

#=======================================================================
proc __ads_ToggleIhrUDE {} {
  global gPB mom_sys_arr
  global ads_cdl_arr
  set lst [lindex $gPB(Inherit_UDE_Frame) 0]
  if { [info exists mom_sys_arr(Inherit_UDE)] && $mom_sys_arr(Inherit_UDE) != 0 && $mom_sys_arr(Inherit_UDE) != "" } {
   __ads_cdl_SetListWidgetState $lst $ads_cdl_arr(type_inherit) normal
   } else {
   __ads_cdl_SetListWidgetState $lst $ads_cdl_arr(type_inherit) disabled
  }
  set mom_sys_arr(inherit_cdl_list) $ads_cdl_arr($ads_cdl_arr(type_inherit),cdl_list)
 }

#=======================================================================
proc UI_PB_ads__SetStatusGMButton { type widget_id } {
  global mom_sys_arr
  switch $type \
  {
   "gcd" {
    if { $mom_sys_arr(\$gcode_status) } \
    {
     $widget_id config -state normal
    } else \
    {
     $widget_id config -state disabled
    }
   }
   "mcd" {
    if { $mom_sys_arr(\$mcode_status) } \
    {
     $widget_id config -state normal
    } else \
    {
     $widget_id config -state disabled
    }
   }
  }
 }

#=======================================================================
proc UI_PB_ads__CreateSpecAttr { spc_frm label options count DEFAULT} {
  upvar $DEFAULT default
  global special_char
  global tixOption
  global paOption
  if { [lsearch $options "$default"] < 0 } {
   set default "gPB(other,opt_text,Label)"
  }
  set special_char($label,label) $default
  set frame [frame $spc_frm.$count]
  pack $frame -side top -fill both -padx 5
  set temp_lab [split $label "_"]
  set disp_lab [join $temp_lab " "]
  global gPB
  switch $label {
   "Word_Separator" {
    set disp_lab $gPB(other,chars,word_sep,Label)
   }
   "End_of_Block" {
    set disp_lab $gPB(other,chars,end_of_block,Label)
   }
   "Comment_Start" {
    set disp_lab $gPB(other,chars,comment_start,Label)
   }
   "Comment_End" {
    set disp_lab $gPB(other,chars,comment_end,Label)
   }
   default {
   }
  }
  set lbl [label $frame.lbl -text $disp_lab -anchor w \
  -font $tixOption(font)]
  pack $lbl -side left -padx 5 -pady 2
  set ent [entry $frame.ent -textvariable special_char($label,char) \
  -font $tixOption(bold_font) \
  -selectbackground yellow \
  -relief sunken -width 4 -bd 2]
  set opt_menu [tixOptionMenu $frame.opt -variable special_char($label,label) \
  -command "UI_PB_ads__SetSpecChar $spc_frm $count $label" \
  -options { menubutton.width 14
   menubutton.height 1
  }]
  UI_PB_ads__SetSpecChar $spc_frm $count $label
  foreach opt $options \
  {
   $opt_menu add command $opt -label [set $opt]
  }
  pack $opt_menu $ent -side right -fill x -padx 5 -pady 2
  $opt_menu config -value $default
 }

#=======================================================================
proc UI_PB_ads__GetValuesForSpecOptions { OPTION_LAB OPT_VALUE } {
  upvar $OPTION_LAB option_lab
  upvar $OPT_VALUE opt_value
  global mom_sys_arr
  if { [string compare $mom_sys_arr($option_lab) " "] == 0 } \
  {
   set opt_value "gPB(other,opt_space,Label)"
   } elseif { [string compare $mom_sys_arr($option_lab) ""] == 0 } \
  {
   set opt_value "gPB(other,opt_none,Label)"
  } else \
  {
   switch $mom_sys_arr($option_lab) \
   {
    "."     {set opt_value "gPB(other,opt_dec,Label)"}
    ","     {set opt_value "gPB(other,opt_comma,Label)"}
    ";"     {set opt_value "gPB(other,opt_semi,Label)"}
    ":"     {set opt_value "gPB(other,opt_colon,Label)"}
    "("     {set opt_value "gPB(other,opt_left,Label)"}
    ")"     {set opt_value "gPB(other,opt_right,Label)"}
    "\#"    {set opt_value "gPB(other,opt_pound,Label)"}
    "*"     {set opt_value "gPB(other,opt_aster,Label)"}
    "/"     {set opt_value "gPB(other,opt_slash,Label)"}
    "\\012"  {set opt_value "gPB(other,opt_new_line,Label)"}
    default {
     set opt_value "gPB(other,opt_text,Label)"
    }
   }
  }
 }

#=======================================================================
proc UI_PB_ads__SetSpecChar { frame count option_lab args } {
  global special_char
  global mom_sys_arr
  global paOption
  global gPB
  switch $special_char($option_lab,label) \
  {
   "gPB(other,opt_none,Label)" \
   {
    set special_char($option_lab,char) ""
   }
   "gPB(other,opt_space,Label)" \
   {
    set special_char($option_lab,char) " "
   }
   "gPB(other,opt_dec,Label)" \
   {
    set special_char($option_lab,char) "."
   }
   "gPB(other,opt_comma,Label)" \
   {
    set special_char($option_lab,char) ","
   }
   "gPB(other,opt_semi,Label)" \
   {
    set special_char($option_lab,char) ";"
   }
   "gPB(other,opt_colon,Label)" \
   {
    set special_char($option_lab,char) ":"
   }
   "gPB(other,opt_text,Label)" \
   {
    set special_char($option_lab,char) $mom_sys_arr($option_lab)
   }
   "gPB(other,opt_left,Label)" \
   {
    set special_char($option_lab,char) "("
   }
   "gPB(other,opt_right,Label)" \
   {
    set special_char($option_lab,char) ")"
   }
   "gPB(other,opt_pound,Label)" \
   {
    set special_char($option_lab,char) "\#"
   }
   "gPB(other,opt_aster,Label)" \
   {
    set special_char($option_lab,char) "*"
   }
   "gPB(other,opt_slash,Label)"
   {
    set special_char($option_lab,char) "/"
   }
   "gPB(other,opt_new_line,Label)" \
   {
    set special_char($option_lab,char) "\\012"
   }
  }
  if { $special_char($option_lab,label) == "gPB(other,opt_text,Label)" } {
   $frame.$count.ent config -state normal -bg $gPB(entry_color)
   } else {
   $frame.$count.ent config -state disabled -bg $paOption(entry_disabled_bg)
  }
  $frame.$count.ent selection range 0 end
 }

#=======================================================================
proc UI_PB_ads__CreateActionButtons { act_frm PAGE_OBJ } {
  upvar $PAGE_OBJ page_obj
  global paOption
  set label_list {"gPB(nav_button,default,Label)" \
  "gPB(nav_button,restore,Label)"}
  set cb_arr(gPB(nav_button,default,Label)) \
  "UI_PB_ads__DefaultCallBack $page_obj"
  set cb_arr(gPB(nav_button,restore,Label)) \
  "UI_PB_ads__RestoreCallBack $page_obj"
  UI_PB_com_CreateButtonBox $act_frm label_list cb_arr
 }

#=======================================================================
proc UI_PB_ads_UpdateDataWidgets { PAGE_OBJ } {
  upvar $PAGE_OBJ page_obj
  global gpb_fmt_var gpb_addr_var
  global gPB
  set grid $gPB(tix_grid)
  set add_name_list $Page::($page_obj,cur_addsum_list)
  foreach add_name $add_name_list \
  {
   set fmt_name $gpb_addr_var($add_name,fmt_name)
   set data_type $gpb_fmt_var($fmt_name,dtype)
   switch $data_type \
   {
    "Numeral"      { set data_type "Numeral" }
    "Text String"  { set data_type "Text" }
   }
   UI_PB_ads__DisableDataAttr $grid $add_name $data_type $fmt_name
  }
 }

#=======================================================================
proc __ads_UpdateSpecChars { page_obj } {
  global mom_sys_arr
  set mom_var_list {"seqnum_start" "seqnum_incr" "seqnum_freq" "seqnum_max" \
   "\$mom_sys_gcodes_per_block" "\$mom_sys_mcodes_per_block" \
   "\$mom_sys_opskip_block_leader" "Word_Separator" \
  "End_of_Block" "Comment_Start" "Comment_End"}
  if { [PB_is_v 3.1] } {
   if 0 {
    lappend mom_var_list "Include_UDE" "UDE_File_Name"
    lappend mom_var_list "Inherit_UDE" "PST_File_Name" "PST_File_Folder"
   } ;#end if 0
   lappend mom_var_list "Include_UDE" "Inherit_UDE"
   if { $::env(PB_UDE_ENABLED) == 1 } {
    lappend mom_var_list "Own_UDE" "OWN_CDL_File_Folder"
   }
   global ads_cdl_arr
   set cdl_type_list [list $ads_cdl_arr(type_other) $ads_cdl_arr(type_inherit)]
   foreach cdl_type $cdl_type_list {
    set ads_cdl_arr($cdl_type,rest_cdl_list) $ads_cdl_arr($cdl_type,cdl_list)
   }
  }
  foreach var $mom_var_list \
  {
   if { ![info exists mom_sys_arr($var)] } {
    set mom_sys_arr($var) ""
   }
   set rest_spec_momvar($var) $mom_sys_arr($var)
  }
  set Page::($page_obj,rest_spec_momvar) [array get rest_spec_momvar]
 }

#=======================================================================
proc UI_PB_ads_UpdateAddrSumPage { PAGE_OBJ } {
  upvar $PAGE_OBJ page_obj
  global gpb_fmt_var
  global gpb_addr_var
  global mom_sys_arr
  set Page::($page_obj,rest_gpb_fmt_var) [array get gpb_fmt_var]
  set Page::($page_obj,rest_gpb_addr_var) [array get gpb_addr_var]
  __ads_UpdateSpecChars $page_obj
  PB_int_RetFormatObjList fmt_obj_list
  foreach fmt_obj $fmt_obj_list \
  {
   set fmt_name $format::($fmt_obj,for_name)
   UI_PB_UpdateAllAddFmt $page_obj $fmt_name
  }
  UI_PB_ads_UpdateDataWidgets page_obj
 }

#=======================================================================
proc UI_PB_ads__DefaultCallBack { page_obj } {
  global gpb_fmt_var gpb_addr_var
  PB_int_RetDefAddrFmtArrys gpb_fmt_var gpb_addr_var
  UI_PB_ads_UpdateDataWidgets page_obj
 }

#=======================================================================
proc UI_PB_ads__RestoreCallBack { page_obj } {
  global gpb_fmt_var
  global gpb_addr_var
  array set gpb_fmt_var $Page::($page_obj,rest_gpb_fmt_var)
  array set gpb_addr_var $Page::($page_obj,rest_gpb_addr_var)
  UI_PB_ads_UpdateDataWidgets page_obj
 }

#=======================================================================
proc UI_PB_ads_UpdateAddressObjects { } {
  global gpb_addr_var
  global gpb_fmt_var
  PB_int_RetAddressObjList add_obj_list
  foreach add_obj $add_obj_list \
  {
   address::readvalue $add_obj add_obj_attr
   set add_name $add_obj_attr(0)
   set add_obj_attr(2)  $gpb_addr_var($add_name,modal)
   set add_obj_attr(3)  $gpb_addr_var($add_name,modl_status)
   set add_obj_attr(4)  $gpb_addr_var($add_name,add_max)
   set add_obj_attr(5)  $gpb_addr_var($add_name,max_status)
   set add_obj_attr(6)  $gpb_addr_var($add_name,add_min)
   set add_obj_attr(7)  $gpb_addr_var($add_name,min_status)
   set add_obj_attr(8)  $gpb_addr_var($add_name,leader_name)
   set add_obj_attr(9)  $gpb_addr_var($add_name,trailer)
   set add_obj_attr(10) $gpb_addr_var($add_name,trail_status)
   set add_obj_attr(11) $gpb_addr_var($add_name,incremental) ;#<12-06-02 gsl> $ was missing.
   address::setvalue $add_obj add_obj_attr
   unset add_obj_attr
  }
  PB_int_RetFormatObjList fmt_obj_list
  foreach fmt_obj $fmt_obj_list \
  {
   format::readvalue $fmt_obj fmt_obj_attr
   set fmt_name $fmt_obj_attr(0)
   set fmt_obj_attr(1) $gpb_fmt_var($fmt_name,dtype)
   set fmt_obj_attr(2) $gpb_fmt_var($fmt_name,plus_status)
   set fmt_obj_attr(3) $gpb_fmt_var($fmt_name,lead_zero)
   set fmt_obj_attr(4) $gpb_fmt_var($fmt_name,trailzero)
   set fmt_obj_attr(5) $gpb_fmt_var($fmt_name,integer)
   set fmt_obj_attr(6) $gpb_fmt_var($fmt_name,decimal)
   set fmt_obj_attr(7) $gpb_fmt_var($fmt_name,fraction)
   format::setvalue $fmt_obj fmt_obj_attr
   unset fmt_obj_attr
  }
 }

#=======================================================================
proc UI_PB_ads_UpdateWidgetVars { page_obj add_name row_no } {
  global gPB
  global gpb_fmt_var
  global gpb_addr_var
  global addr_app_text
  global prev_add_fmt
  set grid $gPB(tix_grid)
  set fmt_name $gpb_addr_var($add_name,fmt_name)
  if { [string compare $fmt_name $prev_add_fmt($add_name)] == 0 } { return }
  PB_int_AddrSummaryAttr addsum_add_name_list addr_app_text add_desc_arr
  set prev_add_fmt($add_name) $fmt_name
  $grid.add_$add_name.but config \
  -textvariable gpb_addr_var($add_name,leader_name)
  $grid.add_$add_name.ent config \
  -textvariable addr_app_text($add_name)
  $grid.dat_$add_name.num config -command ""
  $grid.dat_$add_name.text config -command ""
  $grid.plus_$add_name.ch config -command ""
  $grid.lez_$add_name.ch config -command ""
  $grid.int_$add_name.con config -command ""
  $grid.dec_$add_name.ch config -command ""
  $grid.fra_$add_name.con config -command ""
  $grid.trz_$add_name.ch config -command ""
  $grid.dat_$add_name.num config -variable gpb_fmt_var($fmt_name,dtype) \
  -command "UI_PB_ads__RadDataCallBack $page_obj $grid $row_no Numeral \
  $fmt_name"
  $grid.dat_$add_name.text config -variable gpb_fmt_var($fmt_name,dtype) \
  -command "UI_PB_ads__RadDataCallBack $page_obj $grid $row_no Text \
  $fmt_name"
  switch $gpb_fmt_var($fmt_name,dtype) \
  {
   "Numeral"      { set dtype Numeral }
   "Text String"  { set dtype Text }
  }
  UI_PB_ads__RadDataCallBack $page_obj $grid $row_no $dtype $fmt_name
  $grid.plus_$add_name.ch config -variable gpb_fmt_var($fmt_name,plus_status) \
  -command "UI_PB_UpdateAllAddFmt $page_obj $fmt_name"
  $grid.lez_$add_name.ch config -variable gpb_fmt_var($fmt_name,lead_zero) \
  -command "UI_PB_UpdateAllAddFmt $page_obj $fmt_name"
  $grid.int_$add_name.con config -variable gpb_fmt_var($fmt_name,integer) \
  -command "UI_PB_UpdateFmtDisplay $page_obj $add_name $fmt_name \
  $row_no"
  $grid.dec_$add_name.ch config -variable gpb_fmt_var($fmt_name,decimal) \
  -command "UI_PB_UpdateAllAddFmt $page_obj $fmt_name"
  $grid.fra_$add_name.con config -variable gpb_fmt_var($fmt_name,fraction) \
  -command "UI_PB_UpdateFmtDisplay $page_obj $add_name $fmt_name \
  $row_no"
  $grid.trz_$add_name.ch config -variable gpb_fmt_var($fmt_name,trailzero) \
  -command "UI_PB_UpdateAllAddFmt $page_obj $fmt_name"
  UI_PB_UpdateFmtDisplay $page_obj $add_name $fmt_name
 }

#=======================================================================
proc UI_PB_ads_TabAddrsumCreate { PAGE_OBJ } {
  upvar $PAGE_OBJ page_obj
  global gPB
  set grid $gPB(tix_grid)
  if { [info exists Page::($page_obj,cur_addsum_list)] } {
   set prev_addsum_list $Page::($page_obj,cur_addsum_list)
   } else {
   set prev_addsum_list [list]
  }
  set prev_no_adds [llength $prev_addsum_list]
  PB_int_RetAddrNameList addr_name_list
  set page_id $Page::($page_obj,page_id)
  set top $page_id.top
  set tf $top.f
  if { ![winfo exists $tf] } {
   set tf [frame $top.f]
  }
  place $tf -x 0 -y 0 -relwidth 1 -relheight 1
  raise $tf
  update
  set act_addsum_list ""
  set count 1
  set no_of_deletes 0
  foreach add_name $prev_addsum_list \
  {
   set index [lsearch $addr_name_list $add_name]
   if { $index == -1 }\
   {
    set act_row_no [expr $count - $no_of_deletes]
    UI_PB_ads_UpdateGridRows $grid $act_row_no $add_name $prev_no_adds
    incr prev_no_adds -1
    incr no_of_deletes
   } else \
   {
    lappend act_addsum_list $add_name
   }
   incr count
  }
  place forget $tf
  update
  set new_add_list ""
  foreach add_name $addr_name_list \
  {
   set index [lsearch $prev_addsum_list $add_name]
   if { $index == -1 } \
   {
    incr prev_no_adds
    PB_int_RetAddrObjFromName add_name add_obj
    set add_desc $address::($add_obj,word_desc)
    UI_PB_ads__CreateFirstColAttr $page_obj $grid $prev_no_adds \
    $add_name $add_desc
    UI_PB_ads__CreateSecColAttr  $page_obj $grid $prev_no_adds $add_name
    lappend new_add_list $add_name
   } else \
   {
    UI_PB_ads_UpdateWidgetVars $page_obj $add_name $index
   }
  }
  foreach new_add $new_add_list \
  {
   lappend act_addsum_list $new_add
  }
  set Page::($page_obj,cur_addsum_list) $act_addsum_list
  UI_PB_ads_UpdateAddrSumPage page_obj
 }

#=======================================================================
proc UI_PB_ads_UpdateGridRows { grid row_no add_name total_no_rows } {
  $grid config -height 1
  update idletasks
  $grid delete row $row_no $row_no
  if { $row_no < $total_no_rows } \
  {
   set move_row [expr $row_no + 1]
   $grid move row $move_row $total_no_rows -1
  }
  if { $total_no_rows > 9 } {
   $grid config -height 10
   } else {
   $grid config -height $total_no_rows
  }
  update idletasks
 }

#=======================================================================
proc UI_PB_ads_ValidateAllFormats { args } {
  global gpb_fmt_var
  global gPB
  global FORMATOBJATTR
  PB_int_RetFormatObjList fmt_obj_list
  foreach fmt_obj $fmt_obj_list {
   set fmt_name $format::($fmt_obj,for_name)
   if { [info exists gpb_fmt_var($fmt_name,dtype)] } {
    PB_int_GetAddrListFormat fmt_name fmt_addr_list
    if { [info exists fmt_addr_list] && [llength $fmt_addr_list] } {
     set FORMATOBJATTR(0)  $fmt_name
     set FORMATOBJATTR(1)  $gpb_fmt_var($fmt_name,dtype)
     set FORMATOBJATTR(2)  $gpb_fmt_var($fmt_name,plus_status)
     set FORMATOBJATTR(3)  $gpb_fmt_var($fmt_name,lead_zero)
     set FORMATOBJATTR(4)  $gpb_fmt_var($fmt_name,trailzero)
     set FORMATOBJATTR(5)  $gpb_fmt_var($fmt_name,integer)
     set FORMATOBJATTR(6)  $gpb_fmt_var($fmt_name,decimal)
     set FORMATOBJATTR(7)  $gpb_fmt_var($fmt_name,fraction)
     set err [UI_PB_fmt_Validate]
     if { $err } {
      return $err
     }
    }
   }
  }
  return 0
 }

#=======================================================================
proc UI_PB_ads_DisplayErrorMessage { err } {
  global FORMATOBJATTR
  global gPB
  PB_int_GetAddrListFormat FORMATOBJATTR(0) fmt_addr_list
  for { set i 0 } { $i < [llength $fmt_addr_list] } { incr i} {
   lappend addr_list [lindex $fmt_addr_list $i]
  }
  set msg "$gPB(format,error,msg) $addr_list."
  switch $err \
  {
   "1" \
   {
    tk_messageBox -parent [UI_PB_com_AskActiveWindow] -type ok \
    -title "$FORMATOBJATTR(0) $gPB(format,error,title)" \
    -icon error -message "$gPB(format,data,no_digit,msg)\n\n$msg"
   }
   "2" \
   {
    tk_messageBox -parent [UI_PB_com_AskActiveWindow] -type ok \
    -title "$FORMATOBJATTR(0) $gPB(format,error,title)" \
    -icon error -message "$gPB(format,data,dec_zero,msg)\n\n$msg"
   }
   "3" \
   {
    tk_messageBox -parent [UI_PB_com_AskActiveWindow] -type ok \
    -title "$FORMATOBJATTR(0) $gPB(format,error,title)" \
    -icon error -message "$gPB(format,data,no_digit,msg) \n\
    \n$gPB(format,data,dec_zero,msg)\n\n$msg"
   }
  }
 }

#=======================================================================
proc UI_PB_ads_ValidateMaxN {} {
  global post_object
  global gpb_addr_var
  global gpb_fmt_var
  global mom_sys_arr
  set tmp $mom_sys_arr(seqnum_max)
  set mom_sys_arr(seqnum_max) $gpb_addr_var(N,add_max)
  set fmt $gpb_addr_var(N,fmt_name)
  Post::GetObjList $post_object format fmt_obj_list
  PB_com_RetObjFrmName fmt fmt_obj_list fmt_obj
  format::readvalue $fmt_obj fmt_obj_attr
  set fmt_obj_attr_tmp(0) $fmt
  set fmt_obj_attr_tmp(1) $gpb_fmt_var($fmt,dtype)
  set fmt_obj_attr_tmp(2) $gpb_fmt_var($fmt,plus_status)
  set fmt_obj_attr_tmp(3) $gpb_fmt_var($fmt,lead_zero)
  set fmt_obj_attr_tmp(4) $gpb_fmt_var($fmt,trailzero)
  set fmt_obj_attr_tmp(5) $gpb_fmt_var($fmt,integer)
  set fmt_obj_attr_tmp(6) $gpb_fmt_var($fmt,decimal)
  set fmt_obj_attr_tmp(7) $gpb_fmt_var($fmt,fraction)
  format::setvalue $fmt_obj fmt_obj_attr_tmp
  set max [UI_PB_ads_ExceedMaxSeqNum $fmt]
  if { $max } {
   return $max
  }
  return 0
 }

#=======================================================================
proc __ads_CreateCDLFrame { page_obj label_frame } {
  global gPB mom_sys_arr
  global ads_cdl_arr
  set ads_cdl_arr(page_obj)          $page_obj
  set ads_cdl_arr(opt_highlight)     lightblue
  set ads_cdl_arr(opt_selectcolor)   blue
  set ads_cdl_arr(opt_curcolor)      burlyWood1
  set ads_cdl_arr(show_dlg_flag)     0
  if { [info exists mom_sys_arr(Include_UDE)] && $mom_sys_arr(Include_UDE) == "" } {
   set mom_sys_arr(Include_UDE) 0
  }
  if { [info exists mom_sys_arr(Inherit_UDE)] && $mom_sys_arr(Inherit_UDE) == "" } {
   set mom_sys_arr(Inherit_UDE) 0
  }
  if { [info exists mom_sys_arr(Own_UDE)] && $mom_sys_arr(Own_UDE) == "" } {
   set mom_sys_arr(Own_UDE) 0
  }
  if { [info exists mom_sys_arr(other_cdl_list)] && \
   [info exists mom_sys_arr(Include_UDE)] && \
   !$mom_sys_arr(Include_UDE) } {
   set ads_cdl_arr($ads_cdl_arr(type_other),cdl_list) $mom_sys_arr(other_cdl_list)
  }
  if { [info exists mom_sys_arr(inherit_cdl_list)] && \
   [info exists mom_sys_arr(Inherit_UDE)] && \
   !$mom_sys_arr(Inherit_UDE) } {
   set ads_cdl_arr($ads_cdl_arr(type_inherit),cdl_list) $mom_sys_arr(inherit_cdl_list)
  }
  set base_frm [$label_frame subwidget frame]
  set oth_chk_frm [frame $base_frm.oth_chk]
  pack $oth_chk_frm -side top -fill x
  if { [PB_file_is_JE_POST_DEV] || $::__INCLUDE_OTHER_CDL_AND_DEF } {
   UI_PB_mthd_CreateCheckButton Include_UDE $oth_chk_frm inc "$gPB(other,ude_include_def,Label)"
   } else {
   UI_PB_mthd_CreateCheckButton Include_UDE $oth_chk_frm inc "$gPB(other,ude_include,Label)"
  }
  set oth_list_frm [frame $base_frm.oth_list]
  pack $oth_list_frm -fill x -padx 5 -expand yes
  set oth_lst_wgt [__ads_cdl_CreateListWidget $oth_list_frm $ads_cdl_arr(type_other)]
  __ads_cdl_SetListBalloonState $oth_lst_wgt $ads_cdl_arr(type_other) 1
  set sepr1 [UI_PB_com_AddSeparator $base_frm.sepr1]
  pack $sepr1 -fill x -expand no -padx 5 -pady 5
  set ihr_chk_frm [frame $base_frm.ihr_chk]
  pack $ihr_chk_frm -fill x
  UI_PB_mthd_CreateCheckButton Inherit_UDE $ihr_chk_frm ihr "$gPB(ude,import,ihr,Label)"
  set ihr_list_frm [frame $base_frm.inh_list]
  pack $ihr_list_frm -fill x -padx 5 -expand yes
  set ihr_lst_wgt [__ads_cdl_CreateListWidget $ihr_list_frm $ads_cdl_arr(type_inherit)]
  __ads_cdl_SetListBalloonState $ihr_lst_wgt $ads_cdl_arr(type_inherit) 1
  set sepr2 [UI_PB_com_AddSeparator $base_frm.sepr2]
  pack $sepr2 -fill x -expand no -padx 5 -pady 5
  set own_frm [frame $base_frm.own]
  pack $own_frm -fill x
  UI_PB_mthd_CreateCheckButton Own_UDE $own_frm own "$gPB(ude,import,own,Label)"
  set own_str_frm [frame $base_frm.ostr]
  label $own_str_frm.lbl -text $gPB(ude,import,own_folder,Label) -anchor w
  entry $own_str_frm.ent -width 45 -relief sunken -textvariable mom_sys_arr(OWN_CDL_File_Folder) \
  -state disabled
  pack $own_str_frm.lbl -side left -anchor w
  pack $own_str_frm.ent -side right -fill x -expand yes -pady 3
  pack $own_str_frm -fill x -padx 5
  set dummy_frm [frame $base_frm.dummy]
  pack $dummy_frm -fill x -pady 15
  if { $::env(PB_UDE_ENABLED) != 1 } {
   $own_frm.own config -state disabled
  }
  set gPB(Include_UDE_Frame) [list $oth_lst_wgt]
  set gPB(Inherit_UDE_Frame) [list $ihr_lst_wgt]
  set gPB(Inherit_OWN_UDE_Frame) [list $own_str_frm.ent $own_str_frm.lbl]
  $oth_chk_frm.inc config -command "__ads_ToggleUDE"
  $ihr_chk_frm.ihr config -command "__ads_ToggleIhrUDE"
  $own_frm.own config -command "__ads_ToggleOwnUDE"
  __ads_ToggleUDE
  __ads_ToggleIhrUDE
  __ads_ToggleOwnUDE
  set gPB(c_help,$oth_chk_frm.inc)  "other,ude_include"
  set gPB(c_help,$ihr_chk_frm.ihr)  "ude,import,ihr"
  set gPB(c_help,$own_frm.own)      "ude,import,own"
  set gPB(c_help,$oth_lst_wgt)      "ude,import,oth_list"
  set gPB(c_help,$ihr_lst_wgt)      "ude,import,ihr_list"
 }

#=======================================================================
proc __ads_cdl_CreateListWidget { base_frm cdl_type } {
  global gPB
  global ads_cdl_arr
  set lst_frm [frame $base_frm.left]
  set btn_frm [frame $base_frm.right]
  pack $btn_frm -side right -padx 2
  pack $lst_frm -side left -fill x -expand yes -padx 2 -pady 5
  set ltxt [text $lst_frm.text -xscrollcommand "$lst_frm.xscroll set" \
  -yscrollcommand "$lst_frm.yscroll set" \
  -state disabled -cursor arrow -wrap none\
  -selectbackground white -width 5 -height 5]
  set xscl [scrollbar $lst_frm.xscroll -orient horizontal \
  -command [list $ltxt xview]]
  set yscl [scrollbar $lst_frm.yscroll -orient vertical \
  -command [list $ltxt yview]]
  grid $ltxt $yscl -sticky news
  grid $xscl -sticky news
  grid rowconfigure $lst_frm 0 -weight 1
  grid columnconfigure $lst_frm 0 -weight 1
  foreach opt_val $ads_cdl_arr($cdl_type,cdl_list) {
   __ads_cdl_CreateOption $ltxt $cdl_type $opt_val
  }
  set ads_cdl_arr($cdl_type,def_cdl_list) $ads_cdl_arr($cdl_type,cdl_list)
  set ads_cdl_arr($cdl_type,pre_sunken_opt) ""
  set ads_cdl_arr($cdl_type,wtext) $ltxt
  __ads_cdl_SetPopupMenuState $ltxt $cdl_type
  bind $ltxt <3> "__ads_cdl_ListBinding_3 $ltxt $cdl_type %X %Y"
  return $ltxt
 }

#=======================================================================
proc __ads_cdl_ListBinding_3 { wtext cdl_type x y } {
  global gPB mom_sys_arr
  global ads_cdl_arr
  if { $gPB(use_info) } { return }
  if { $cdl_type == $ads_cdl_arr(type_other) && !$mom_sys_arr(Include_UDE) } {
   return
  }
  if { $cdl_type == $ads_cdl_arr(type_inherit) && !$mom_sys_arr(Inherit_UDE) } {
   return
  }
  __ads_cdl_SetPopupMenuState $wtext $cdl_type
  set cur_opt $ads_cdl_arr($cdl_type,pre_sunken_opt)
  __ads_cdl_OptEntryBinding_3 $wtext $cdl_type $cur_opt $x $y
 }

#=======================================================================
proc __ads_cdl_ShowCdlFileDlg { wtext cdl_type {edit_flag 0} } {
  global gPB mom_sys_arr
  global ads_cdl_arr
  set win_title ""
  if { $cdl_type == $ads_cdl_arr(type_other) } {
   if { [PB_file_is_JE_POST_DEV] || $::__INCLUDE_OTHER_CDL_AND_DEF } {
    set win_title "$gPB(other,ude_include_def,Label)"
    } else {
    set win_title "$gPB(other,ude_include,Label)"
   }
   } elseif { $cdl_type == $ads_cdl_arr(type_inherit) } {
   set win_title "$gPB(ude,import,ihr,Label)"
   } else {
   return
  }
  set ads_cdl_arr(show_dlg_flag) 1
  __ads_cdl_SetAllListState "disabled"
  set page_obj $ads_cdl_arr(page_obj)
  set page_id $Page::($page_obj,page_id)
  set w [toplevel $page_id.add]
  UI_PB_com_CreateTransientWindow $w "$win_title" "+200+100" "" "" \
  "__ads_cdl_dlg_cancel $w $cdl_type" ""
  set top_frm [frame $w.t]
  set btm_frm [frame $w.b]
  pack $btm_frm -side bottom -fill x -expand yes -padx 5 -pady 5
  pack $top_frm -side top -fill both -expand yes -padx 5 -pady 5
  set label_list {"gPB(nav_button,cancel,Label)" \
  "gPB(nav_button,ok,Label)"}
  set cb_arr(gPB(nav_button,cancel,Label)) \
  "__ads_cdl_dlg_cancel $w $cdl_type"
  set cb_arr(gPB(nav_button,ok,Label)) \
  "__ads_cdl_dlg_ok $w $wtext $cdl_type $edit_flag"
  UI_PB_com_CreateButtonBox $btm_frm label_list cb_arr
  if { $cdl_type == $ads_cdl_arr(type_other) } {
   set frm1 [frame $top_frm.1]
   set frm2 [frame $top_frm.2]
   pack $frm1 $frm2 -padx 5 -expand yes -fill x
   label $frm1.lbl -text "$win_title" -anchor w
   if { [string length " $gPB(other,ude_select,Label) "] > 10 } {
    button $frm1.sel -text " $gPB(other,ude_select,Label) " \
    -command "__ads_BrowseUDE $frm2.name"
    } else {
    button $frm1.sel -text "$gPB(other,ude_select,Label)" -width 10 \
    -command "__ads_BrowseUDE $frm2.name"
   }
   pack $frm1.lbl -side left -padx 5 -pady 5
   pack $frm1.sel -side right -padx 5 -pady 5
   if 0 {
    if { $edit_flag == 0 && \
     [string match "*.cdl" $mom_sys_arr(UDE_File_Name)] } {
     set mom_sys_arr(UDE_File_Name) [file dir $mom_sys_arr(UDE_File_Name)]
     append mom_sys_arr(UDE_File_Name) "/"
    }
   }
   if { $edit_flag == 0 && \
    ([string match "*.cdl" $mom_sys_arr(UDE_File_Name)] ||\
    [string match "*.def" $mom_sys_arr(UDE_File_Name)]) } {
    set mom_sys_arr(UDE_File_Name) [file dirname $mom_sys_arr(UDE_File_Name)]
    append mom_sys_arr(UDE_File_Name) "/"
   }
   set ads_cdl_arr(restore_UDE_File_Name) $mom_sys_arr(UDE_File_Name)
   if { [PB_file_is_JE_POST_DEV] || $::__INCLUDE_OTHER_CDL_AND_DEF } {
    label $frm2.lbl -text "$gPB(main,file,Label)" -anchor w
    } else {
    label $frm2.lbl -text "$gPB(ude,import,include_cdl,Label)" -anchor w
   }
   entry $frm2.name -width 45 -relief sunken -textvariable mom_sys_arr(UDE_File_Name)
   bind $frm2.name <KeyPress> "__ads_ValidateIncludeUdePath %W %K %A both"
   bind $frm2.name <KeyRelease> "__ads_ValidateIncludeUdePath_Release %W %K"
   pack $frm2.lbl -side left -padx 5 -pady 5
   pack $frm2.name -fill x -expand yes -padx 5 -pady 5
   set gPB(c_help,$frm1.sel)  "other,ude_select"
   set gPB(c_help,$frm2.name) "other,ude_file"
   } else {
   set frm1 [frame $top_frm.1]
   set frm2 [frame $top_frm.2]
   set frm3 [frame $top_frm.3]
   pack $frm1 -padx 5 -expand yes -fill x
   pack $frm2 -side left -padx 5
   pack $frm3 -side right -padx 5 -fill x -expand yes
   label $frm1.lbl -text "$win_title" -anchor w
   if { [string length " $gPB(ude,import,sel,Label) "] > 10 } {
    button $frm1.sel -text " $gPB(ude,import,sel,Label) " \
    -command "__ads_BrowsePost"
    } else {
    button $frm1.sel -text "$gPB(ude,import,sel,Label)" -width 10 \
    -command "__ads_BrowsePost"
   }
   pack $frm1.lbl -side left -padx 5 -pady 5
   pack $frm1.sel -side right -padx 5 -pady 5
   label $frm2.top -text "$gPB(ude,import,ihr_pst,Label)" -anchor w
   label $frm2.btm -text "$gPB(ude,import,ihr_folder,Label)" -anchor w
   pack $frm2.top $frm2.btm -fill x -expand yes -padx 5 -pady 5
   if { $edit_flag == 0 } {
    set mom_sys_arr(PST_File_Name) ""
   }
   if { ![info exists mom_sys_arr(PST_File_Folder)] } {
    set mom_sys_arr(PST_File_Folder) "\$UGII_CAM_POST_DIR/"
   }
   set ads_cdl_arr(restore_PST_File_Name)   $mom_sys_arr(PST_File_Name)
   set ads_cdl_arr(restore_PST_File_Folder) $mom_sys_arr(PST_File_Folder)
   entry $frm3.top -width 45 -relief sunken -textvariable mom_sys_arr(PST_File_Name)
   entry $frm3.btm -width 45 -relief sunken -textvariable mom_sys_arr(PST_File_Folder)
   bind $frm3.top <KeyPress> "__ads_ValidateIncludeUdePath %W %K %A fname"
   bind $frm3.top <KeyRelease> "__ads_ValidateIncludeUdePath_Release %W %K"
   bind $frm3.btm <KeyPress> "__ads_ValidateIncludeUdePath %W %K %A folder"
   bind $frm3.btm <KeyRelease> "__ads_ValidateIncludeUdePath_Release %W %K"
   pack $frm3.top $frm3.btm -fill x -expand yes -padx 5 -pady 5
   set gPB(c_help,$frm1.sel) "ude,import,sel"
   set gPB(c_help,$frm3.top) "ude,import,name_cdl"
   set gPB(c_help,$frm3.btm) "ude,import,name_def"
  }
 }

#=======================================================================
proc __ads_cdl_dlg_ok { w wtext cdl_type edit_flag } {
  global ads_cdl_arr
  if { [__ads_cdl_ValidateCdlFormat $cdl_type] } {
   return
  }
  if { $edit_flag } {
   if { [__ads_cdl_EditOption $wtext $cdl_type] } {
    return
   }
   } elseif { [__ads_cdl_AddOption $wtext $cdl_type] } {
   return
  }
  destroy $w
  __ads_cdl_SetAllListState "normal"
  set ads_cdl_arr(show_dlg_flag) 0
  __ads_cdl_SetPopupMenuState $wtext $cdl_type
 }

#=======================================================================
proc __ads_cdl_dlg_cancel { w cdl_type } {
  global ads_cdl_arr mom_sys_arr
  destroy $w
  __ads_cdl_SetAllListState "normal"
  set ads_cdl_arr(show_dlg_flag) 0
  if { $cdl_type == $ads_cdl_arr(type_other) } {
   set mom_sys_arr(UDE_File_Name) $ads_cdl_arr(restore_UDE_File_Name)
   } else {
   set mom_sys_arr(PST_File_Name)   $ads_cdl_arr(restore_PST_File_Name)
   set mom_sys_arr(PST_File_Folder) $ads_cdl_arr(restore_PST_File_Folder)
  }
 }

#=======================================================================
proc __ads_cdl_EditOption { wtext cdl_type } {
  global ads_cdl_arr
  __ads_cdl_GetOptionIndexByWidget $wtext wgt_idx list_idx $cdl_type
  set opt_wgt [$wtext window cget $wgt_idx -window]
  set old_str [$opt_wgt get]
  __ads_cdl_GenerateOptValueFrmDlg $cdl_type new_str
  if { [string compare $old_str $new_str] == 0 } {
   return 0
  }
  if { [__ads_cdl_CheckOptExisting $cdl_type $new_str] } {
   return 1
  }
  set ads_cdl_arr($cdl_type,cdl_list) [lreplace $ads_cdl_arr($cdl_type,cdl_list) \
  $list_idx $list_idx $new_str]
  $opt_wgt config -state normal
  $opt_wgt delete 0 end
  $opt_wgt insert end $new_str
  $opt_wgt config -state disabled
  return 0
 }

#=======================================================================
proc __ads_cdl_AddOption { w cdl_type } {
  __ads_cdl_GenerateOptValueFrmDlg $cdl_type opt_val
  if { [__ads_cdl_CheckOptExisting $cdl_type $opt_val] } {
   return 1
  }
  __ads_cdl_GetOptionIndexByWidget $w wgt_idx list_idx $cdl_type
  __ads_cdl_CreateOption $w $cdl_type $opt_val $wgt_idx
  __ads_cdl_InsertOneCDLName $cdl_type $list_idx $opt_val
  return 0
 }

#=======================================================================
proc __ads_cdl_InsertOneCDLName { cdl_type index opt_val } {
  global ads_cdl_arr
  set old_list $ads_cdl_arr($cdl_type,cdl_list)
  if { [string match "end" $index] } {
   set temp_index end
   } else {
   set temp_index [expr $index + 1]
   if { $temp_index == [llength $old_list] } {
    set temp_index end
   }
  }
  set ads_cdl_arr($cdl_type,cdl_list) [linsert $old_list $temp_index $opt_val]
 }

#=======================================================================
proc __ads_cdl_GenerateOptValueFrmDlg { cdl_type OPT_VALUE } {
  upvar $OPT_VALUE opt_val
  global mom_sys_arr
  global ads_cdl_arr
  if { $cdl_type == $ads_cdl_arr(type_other) } {
   set opt_val "$mom_sys_arr(UDE_File_Name)"
   if { [regexp {UGII[A-Za-z0-9_]+} $opt_val ugii_var] } {
    regsub {UGII[A-Za-z0-9_]+} $opt_val [string toupper $ugii_var] opt_val
    set mom_sys_arr(UDE_File_Name) $opt_val
   }
   } else {
   set temp_str $mom_sys_arr(PST_File_Folder)
   if { ![string match $temp_str ""] } {
    set last_idx [expr [string length $temp_str] - 1]
    if { [string compare "/" [string index $temp_str $last_idx]] != 0 } {
     append temp_str "/"
    }
    if { [regexp {UGII[A-Za-z0-9_]+} $temp_str ugii_var] } {
     regsub {UGII[A-Za-z0-9_]+} $temp_str [string toupper $ugii_var] temp_str
     set mom_sys_arr(PST_File_Folder) $temp_str
    }
   }
   append temp_str $mom_sys_arr(PST_File_Name)
   set opt_val $temp_str
  }
 }

#=======================================================================
proc __ads_cdl_CheckOptExisting { cdl_type opt_val } {
  global ads_cdl_arr
  set opt_list $ads_cdl_arr($cdl_type,cdl_list)
  foreach one $opt_list {
   if { [string compare $opt_val $one] == 0 } {
    tk_messageBox -message "$::gPB(msg,exist_cdl_file)\n\n$opt_val" -icon error \
    -title $::gPB(msg,error) -parent [UI_PB_com_AskActiveWindow]
    return 1
   }
  }
  return 0
 }

#=======================================================================
proc __ads_cdl_GetOptionIndexByWidget { wtext WIDGET_INDEX LIST_INDEX \
  cdl_type {opt_widget Current} } {
  upvar $WIDGET_INDEX wgt_idx ;#The index used in the "text" widget.
  upvar $LIST_INDEX   lst_idx ;#The index used in the list.
  global ads_cdl_arr
  if { [string match "Current" $opt_widget] } {
   set opt_widget $ads_cdl_arr($cdl_type,pre_sunken_opt)
  }
  set wgt_idx end
  set lst_idx end
  if { $opt_widget == "" } {
   set wgt_idx end
   } else {
   set wgt_idx [$wtext index $opt_widget]
   set temp [string first "." $wgt_idx]
   if { $temp > 0 } {
    set temp [string range $wgt_idx 0 [expr $temp - 1]]
    set lst_idx [expr $temp - 1]
   }
  }
 }

#=======================================================================
proc __ads_cdl_CreateOption { wtext cdl_type optv {index end} } {
  set elist [$wtext window names]
  if { [llength $elist] == 0 } {
   set idx 0
   } else {
   set idxlist [list]
   foreach one $elist {
    set lastpoint [string last . $one]
    incr lastpoint
    lappend idxlist [string range $one $lastpoint end]
   }
   set idx [lindex [lsort -integer $idxlist] end]
   incr idx
  }
  if { ![string compare $::tix_version 8.4] } {
   set new_e [entry $wtext.$idx -width 0 -relief flat -cursor hand2 \
   -highlightt 1 \
   -highlightc blue \
   -highlightb white]
   $new_e config -disabledb white
   } else {
   set new_e [entry $wtext.$idx -width 0 -relief flat -cursor hand2 \
   -highlightt 1 \
   -highlightc blue \
   -highlightb white]
   $new_e config -bg white
  }
  $new_e insert end $optv
  $new_e config -state disabled
  bind $new_e <Enter> "__ads_cdl_OptEntryBinding_Enter $wtext $cdl_type %W"
  bind $new_e <Leave> "__ads_cdl_OptEntryBinding_Leave $wtext $cdl_type %W"
  bind $new_e <Button-1> "__ads_cdl_OptEntryBinding_B1 $wtext $cdl_type %W"
  bind $new_e <Double-1> "__ads_cdl_OptEntryBinding_DB1 $wtext $cdl_type %W"
  bind $new_e <3> "__ads_cdl_OptEntryBinding_3 $wtext $cdl_type %W %X %Y"
  bind $new_e <Destroy> "__ads_cdl_OptEntryBinding_Destroy %W"
  set lst_index $index
  if { ![string match "end" $index] } {
   set lst_index "$index +1 lines"
  }
  $wtext config -state normal
  if { [llength $elist] != 0 } {
   $wtext insert $lst_index "\n"
  }
  $wtext window create $lst_index -window $new_e
  $wtext window config $new_e -pady 0
  $wtext config -state disabled
 }

#=======================================================================
proc __ads_cdl_OptEntryBinding_Destroy { w } {
  return -code break
 }

#=======================================================================
proc __ads_cdl_OptEntryBinding_Enter { wtext cdl_type w } {
  global ads_cdl_arr
  if { $::gPB(use_info) } { return }
  if { ![string compare $::tix_version 8.4] } {
   $w config -disabledb $ads_cdl_arr(opt_highlight)
   } else {
   if { $ads_cdl_arr($cdl_type,pre_sunken_opt) != $w } {
    $w config -bg $ads_cdl_arr(opt_highlight)
   }
  }
  if { $ads_cdl_arr($cdl_type,pre_sunken_opt) == "" } {
   focus [winfo parent $w]
  }
 }

#=======================================================================
proc __ads_cdl_OptEntryBinding_Leave { wtext cdl_type w } {
  global ads_cdl_arr
  if { $::gPB(use_info) } { return }
  set leave_bg white
  if { [string compare $w $ads_cdl_arr($cdl_type,pre_sunken_opt)] == 0 } {
   set leave_bg $ads_cdl_arr(opt_curcolor)
  }
  if { ![string compare $::tix_version 8.4] } {
   $w config -disabledb $leave_bg
   } else {
   $w config -bg $leave_bg
  }
 }

#=======================================================================
proc __ads_cdl_OptEntryBinding_B1 { wtext cdl_type w } {
  global ads_cdl_arr
  if { $::gPB(use_info) } { return }
  if { $w != "" } {
   $w config -highlightb $ads_cdl_arr(opt_selectcolor)
   focus [winfo parent $w]
  }
  set pre_sunken_opt $ads_cdl_arr($cdl_type,pre_sunken_opt)
  if { $pre_sunken_opt == $w } {
   return
   } elseif { $pre_sunken_opt != "" } {
   $pre_sunken_opt xview 0
   $pre_sunken_opt config -highlightb white -highlightc white
   $pre_sunken_opt config -relief flat -state disabled
   if { ![string compare $::tix_version 8.4] } {
    $pre_sunken_opt config -disabledb white
    } else {
    $pre_sunken_opt config -bg white
   }
  }
  set ads_cdl_arr($cdl_type,pre_sunken_opt) $w
  __ads_cdl_SetPopupMenuState $wtext $cdl_type
 }

#=======================================================================
proc __ads_cdl_OptEntryBinding_DB1 { wtext cdl_type wopt } {
  if { $::gPB(use_info) } { return }
  __ads_cdl_OptEntryBinding_B1 $wtext $cdl_type $wopt
  __ads_cdl_CBEditOpt $wtext $cdl_type
 }

#=======================================================================
proc __ads_cdl_OptEntryBinding_3 { wtext cdl_type wopt x y } {
  global gPB
  global ads_cdl_arr
  if { $gPB(use_info) } { return }
  if { ![info exists ads_cdl_arr($cdl_type,paste_state)] } {
   set ads_cdl_arr($cdl_type,paste_state) disabled
  }
  if { $wopt != "" } {
   __ads_cdl_OptEntryBinding_B1 $wtext $cdl_type $wopt
  }
  set win $Page::($ads_cdl_arr(page_obj),page_id)
  if { $cdl_type == $ads_cdl_arr(type_other) } {
   set popup $win.oth_pop
   } else {
   set popup $win.ihr_pop
  }
  if { ![winfo exists $popup] } {
   menu $popup
  }
  $popup delete 0 end
  $popup add command -label "$gPB(wseq,popup_new,Label)" -state normal \
  -command [list __ads_cdl_ShowCdlFileDlg $wtext $cdl_type 0]
  $popup add command -label "$gPB(nav_button,edit,Label)" -state normal \
  -state $ads_cdl_arr($cdl_type,edit_state) \
  -command [list __ads_cdl_CBEditOpt $wtext $cdl_type]
  $popup add separator
  $popup add command -label "$gPB(ude,import,up,Label)" \
  -state $ads_cdl_arr($cdl_type,up_state) \
  -command [list __ads_cdl_CBUpDownOpt $wtext $cdl_type 1]
  $popup add command -label "$gPB(ude,import,down,Label)" \
  -state $ads_cdl_arr($cdl_type,down_state) \
  -command [list __ads_cdl_CBUpDownOpt $wtext $cdl_type 0]
  $popup add separator
  $popup add command -label "$gPB(ude,editor,paramdlg,CUT,Label)" \
  -state $ads_cdl_arr($cdl_type,cut_state) \
  -command [list __ads_cdl_CBCutOpt $wtext $cdl_type]
  $popup add command -label "$gPB(ude,editor,paramdlg,PASTE,Label)" \
  -state $ads_cdl_arr($cdl_type,paste_state) \
  -command [list __ads_cdl_CBPasteOpt $wtext $cdl_type]
  tk_popup $popup $x $y
 }

#=======================================================================
proc __ads_cdl_ValidateCdlFormat { cdl_type } {
  global mom_sys_arr
  global gPB
  global ads_cdl_arr
  set pass 0
  set error_info 0
  if { $cdl_type == $ads_cdl_arr(type_inherit) } {
   if { $mom_sys_arr(PST_File_Name) == "" } {
    set pass 1
    set error_info 2
   }
   if { [string length $mom_sys_arr(PST_File_Folder)] && \
    ![string match "\$UGII_*" $mom_sys_arr(PST_File_Folder)] } {
    set pass 1
    set error_info 3
   }
   } else {
   if { [string length $mom_sys_arr(UDE_File_Name)] == 0 } {
    set pass 1
    set error_info 8
    } else {
    set dir_name [file dirname $mom_sys_arr(UDE_File_Name)]
    switch "$dir_name" {
     ""   -
     "."  -
     ".." -
     ":"  {}
     default {
      if { ![string match "\$UGII_*" $mom_sys_arr(UDE_File_Name)] } {
       set pass 1
       set error_info 8
      }
     }
    }
    if { [PB_file_is_JE_POST_DEV] || $::__INCLUDE_OTHER_CDL_AND_DEF } {
     if { ![string match "*.cdl" $mom_sys_arr(UDE_File_Name)] && \
      ![string match "*.def" $mom_sys_arr(UDE_File_Name)] } {
      set pass 1
      set error_info 9
     }
     } else {
     if { ![string match "*.cdl" $mom_sys_arr(UDE_File_Name)] } {
      set pass 1
      set error_info 9
     }
    }
    if { $error_info == 0 } {
     PB_int_ReadPostFiles post_dir def_file tcl_file
     if { [string match "windows" $::tcl_platform(platform)] && [expr $::tcl_version > 8.0] } {
      if { ![string compare -nocase [PB_file_name $def_file].cdl [file tail $mom_sys_arr(UDE_File_Name)]] ||\
       ![string compare -nocase [PB_file_name $def_file].def [file tail $mom_sys_arr(UDE_File_Name)]] } {
       set pass 1
      }
      } else {
      if { ![string compare [PB_file_name $def_file].cdl [file tail $mom_sys_arr(UDE_File_Name)]] ||\
       ![string compare [PB_file_name $def_file].def [file tail $mom_sys_arr(UDE_File_Name)]] } {
       set pass 1
      }
     }
     if { $pass } {
      set error_info 10
     }
    }
   }
  }
  if { $pass == 1 } {
   switch $error_info {
    2 {
     tk_messageBox -parent [UI_PB_com_AskActiveWindow] \
     -type ok -icon error \
     -message "$gPB(msg,no_cdl_name)"
    }
    3 {
     tk_messageBox -parent [UI_PB_com_AskActiveWindow] \
     -type ok -icon error \
     -message "$gPB(msg,no_def_name)"
    }
    4 {
     tk_messageBox -parent [UI_PB_com_AskActiveWindow] \
     -type ok -icon error \
     -message "$gPB(msg,no_own_name)"
    }
    8 {
     tk_messageBox -parent [UI_PB_com_AskActiveWindow] \
     -type ok -icon error \
     -message "$gPB(msg,no_oth_ude_name)"
    }
    9 {
     tk_messageBox -parent [UI_PB_com_AskActiveWindow] \
     -type ok -icon error \
     -message "$gPB(msg,no_oth_ude_name)"
    }
    10 {
     tk_messageBox -parent [UI_PB_com_AskActiveWindow] \
     -type ok -icon error \
     -message "$gPB(msg,not_post_comp_file)"
    }
    default {}
   } ;# end switch
  } ;# endif $pass == 1
  return $pass
 }

#=======================================================================
proc __ads_cdl_CBEditOpt { wtext cdl_type } {
  global mom_sys_arr
  global ads_cdl_arr
  set cur_opt_wgt $ads_cdl_arr($cdl_type,pre_sunken_opt)
  set opt_val [$cur_opt_wgt get]
  __ads_cdl_GetNativeCDLFileFrmListElem $opt_val $cdl_type cdl_file
  if { $cdl_type == $ads_cdl_arr(type_other) } {
   set mom_sys_arr(UDE_File_Name) $cdl_file(0)
   } else {
   set mom_sys_arr(PST_File_Folder) $cdl_file(0)
   set mom_sys_arr(PST_File_Name) $cdl_file(1)
  }
  set edit_flag 1
  __ads_cdl_ShowCdlFileDlg $wtext $cdl_type $edit_flag
 }

#=======================================================================
proc __ads_cdl_CBUpDownOpt { wtext cdl_type up_flag } {
  global ads_cdl_arr
  if { $ads_cdl_arr($cdl_type,pre_sunken_opt) == "" } { return }
  __ads_cdl_GetOptionIndexByWidget $wtext wgt_idx cur_idx $cdl_type
  set cur_cdl_list $ads_cdl_arr($cdl_type,cdl_list)
  if { [string match "end" $cur_idx] } {
   set cur_idx [expr [llength $cur_cdl_list] - 1]
  }
  if { $up_flag } {
   set exc_idx [expr $cur_idx - 1]
   } else {
   set exc_idx [expr $cur_idx + 1]
  }
  set exc_opt [__ads_cdl_GetOptionWidgetByIndex $wtext $exc_idx $cdl_type]
  __ads_cdl_GetOptionIndexByWidget $wtext exc_wgt_idx exc_list_idx $cdl_type $exc_opt
  $wtext config -state normal
  $wtext window config $wgt_idx -window $exc_opt
  $wtext window config $exc_wgt_idx -window $ads_cdl_arr($cdl_type,pre_sunken_opt)
  $wtext config -state disabled
  set cur_opt_text [lindex $cur_cdl_list $cur_idx]
  set exc_opt_text [lindex $cur_cdl_list $exc_idx]
  set temp_list [lreplace $cur_cdl_list $cur_idx $cur_idx $exc_opt_text]
  set ads_cdl_arr($cdl_type,cdl_list) [lreplace $temp_list $exc_idx $exc_idx $cur_opt_text]
  __ads_cdl_SetPopupMenuState $wtext $cdl_type
 }

#=======================================================================
proc __ads_cdl_CBCutOpt { wtext cdl_type } {
  global ads_cdl_arr
  set cur_opt $ads_cdl_arr($cdl_type,pre_sunken_opt)
  set ads_cdl_arr($cdl_type,paste_opt_str) [$cur_opt get]
  __ads_cdl_GetOptionIndexByWidget $wtext wgt_idx list_idx $cdl_type
  set ads_cdl_arr($cdl_type,cdl_list) [lreplace $ads_cdl_arr($cdl_type,cdl_list) \
  $list_idx $list_idx]
  $wtext config -state normal
  $wtext delete "$cur_opt linestart" "$cur_opt lineend +1 char"
  $wtext config -state disabled
  set ads_cdl_arr($cdl_type,pre_sunken_opt) ""
  set cur_len [llength $ads_cdl_arr($cdl_type,cdl_list)]
  if { $cur_len > 0 } {
   if { $list_idx == $cur_len } {
    set list_idx end
   }
   set opt_w [__ads_cdl_GetOptionWidgetByIndex $wtext $list_idx $cdl_type]
   __ads_cdl_OptEntryBinding_B1 $wtext $cdl_type $opt_w
   __ads_cdl_OptEntryBinding_Leave $wtext $cdl_type $opt_w
  }
  set ads_cdl_arr($cdl_type,paste_state) normal
  __ads_cdl_SetListBalloonState $wtext $cdl_type
 }

#=======================================================================
proc __ads_cdl_CBPasteOpt { wtext cdl_type } {
  global ads_cdl_arr
  set ads_cdl_arr($cdl_type,paste_state) disabled
  set opt_val $ads_cdl_arr($cdl_type,paste_opt_str)
  if { [__ads_cdl_CheckOptExisting $cdl_type $opt_val] } {
   return
  }
  __ads_cdl_GetOptionIndexByWidget $wtext wgt_idx list_idx $cdl_type
  __ads_cdl_CreateOption $wtext $cdl_type $opt_val $wgt_idx
  __ads_cdl_InsertOneCDLName $cdl_type $list_idx $opt_val
  __ads_cdl_SetListBalloonState $wtext $cdl_type 0
 }

#=======================================================================
proc __ads_cdl_GetNativeCDLFileFrmListElem { list_elem cdl_type CDL_FILE } {
  upvar $CDL_FILE cdl_file_arr
  global ads_cdl_arr
  if { $cdl_type == $ads_cdl_arr(type_other) } {
   set cdl_file_arr(0) $list_elem
   } else {
   set last_ind [string last "/" $list_elem]
   if { $last_ind == -1 } {
    set folder "" ;# Folder name
    set cdl_file_arr(1) [string range $list_elem 0 end] ;# file name
    } else {
    set folder [string range $list_elem 0 $last_ind]
    set cdl_file_arr(1) [string range $list_elem [expr $last_ind + 1] end]
   }
   if [regexp {UGII[A-Za-z0-9_]+} $folder ugii_var] {
    regsub {UGII[A-Za-z0-9_]+} $folder [string toupper $ugii_var] folder
   }
   set cdl_file_arr(0) $folder
  }
 }

#=======================================================================
proc __ads_cdl_DeleteAllCdlFiles {} {
  global ads_cdl_arr
  set cdl_type_list [list $ads_cdl_arr(type_other) $ads_cdl_arr(type_inherit)]
  foreach cdl_type $cdl_type_list {
   set wtext $ads_cdl_arr($cdl_type,wtext)
   $wtext config -state normal
   $wtext delete 0.0 end
   $wtext config -state disabled
   set ads_cdl_arr($cdl_type,pre_sunken_opt) ""
   set ads_cdl_arr($cdl_type,cdl_list) [list]
   __ads_cdl_SetPopupMenuState $wtext $cdl_type
  }
 }

#=======================================================================
proc __ads_cdl_GetOptionWidgetByIndex { wtext index cdl_type } {
  global ads_cdl_arr
  set opt_wgt ""
  set opt_text [lindex $ads_cdl_arr($cdl_type,cdl_list) $index]
  set elist [$wtext window names]
  foreach one $elist {
   set exist_opt [$one get]
   if { [string compare $exist_opt $opt_text] == 0 } {
    set opt_wgt $one
    break
   }
  }
  return $opt_wgt
 }

#=======================================================================
proc __ads_cdl_SetPopupMenuState { wtext cdl_type } {
  global ads_cdl_arr
  set edit_state normal
  set up_state normal
  set down_state normal
  set cut_state normal
  set file_len [llength $ads_cdl_arr($cdl_type,cdl_list)]
  if { $ads_cdl_arr($cdl_type,pre_sunken_opt) == "" } {
   set edit_state disabled
   set up_state disabled
   set down_state disabled
   set cut_state disabled
   } elseif { $file_len <= 1 } {
   set up_state disabled
   set down_state disabled
   } else {
   __ads_cdl_GetOptionIndexByWidget $wtext wdt_idx list_idx $cdl_type
   if { [string match "end" $list_idx] } {
    set list_idx [expr $file_len - 1]
   }
   set pre_idx [expr $list_idx - 1]
   set aft_idx [expr $list_idx + 1]
   if { $pre_idx < 0 } {
    set up_state disabled
   }
   if { $aft_idx >= $file_len } {
    set down_state disabled
   }
  }
  set ads_cdl_arr($cdl_type,edit_state) $edit_state
  set ads_cdl_arr($cdl_type,up_state)   $up_state
  set ads_cdl_arr($cdl_type,down_state) $down_state
  set ads_cdl_arr($cdl_type,cut_state)  $cut_state
 }

#=======================================================================
proc __ads_cdl_SetListWidgetState { lst cdl_type state } {
  set elist [$lst window names]
  if { [string match "normal" $state] } {
   foreach one $elist {
    bind $one <Enter> "__ads_cdl_OptEntryBinding_Enter $lst $cdl_type %W"
    bind $one <Leave> "__ads_cdl_OptEntryBinding_Leave $lst $cdl_type %W"
    bind $one <Button-1> "__ads_cdl_OptEntryBinding_B1 $lst $cdl_type %W"
    bind $one <Double-1> "__ads_cdl_OptEntryBinding_DB1 $lst $cdl_type %W"
    bind $one <3> "__ads_cdl_OptEntryBinding_3 $lst $cdl_type %W %X %Y"
    $one config -highlightb white -highlightc white
    if { ![string compare $::tix_version 8.4] } {
     $one config -disabledb white
     $one config -disabledf $::SystemButtonText
     } else {
     $one config -bg white
     $one config -fg $::SystemButtonText
    }
   }
   $lst config -bg white
   __ads_cdl_SetListBalloonState $lst $cdl_type 1
   } else {
   global ads_cdl_arr
   set cur_opt $ads_cdl_arr($cdl_type,pre_sunken_opt)
   if { $cur_opt != "" } {
    global ads_cdl_arr
    if { $ads_cdl_arr(show_dlg_flag) == 0 } {
     set ads_cdl_arr($cdl_type,pre_sunken_opt) ""
    }
    __ads_cdl_OptEntryBinding_Leave $lst $cdl_type $cur_opt
   }
   foreach one $elist {
    bind $one <Enter> ""
    bind $one <Leave> ""
    bind $one <Button-1> ""
    bind $one <Double-1> ""
    bind $one <3> ""
    $one config -highlightb $::SystemButtonFace -highlightc $::SystemButtonFace
    if { ![string compare $::tix_version 8.4] } {
     $one config -disabledb $::SystemButtonFace
     $one config -disabledf $::SystemDisabledText
     } else {
     $one config -bg $::SystemButtonFace
     $one config -fg $::SystemDisabledText
    }
   }
   $lst config -bg $::SystemButtonFace
   __ads_cdl_SetListBalloonState $lst $cdl_type 0
  }
 }

#=======================================================================
proc __ads_cdl_SetListBalloonState { lst cdl_type {flag 1} } {
  global gPB gPB_help_tips
  if { $flag } {
   set elist [$lst window names]
   if { [llength $elist] > 0 } {
    set flag 0
   }
  }
  if { $flag } {
   PB_enable_balloon $lst
   if { $cdl_type == $::ads_cdl_arr(type_other) } {
    set tips $gPB(ude,import,oth_list,Context)
    } else {
    set tips $gPB(ude,import,ihr_list,Context)
   }
   regsub -all {\\} $tips "" tips
   set gPB_help_tips($lst) $tips
   } else {
   PB_disable_balloon $lst
   set gPB_help_tips($lst) ""
  }
 }

#=======================================================================
proc __ads_cdl_SetAllListState { state } {
  global gPB mom_sys_arr
  global ads_cdl_arr
  if { $mom_sys_arr(Include_UDE) } {
   set lst_wgt [lindex $gPB(Include_UDE_Frame) 0]
   __ads_cdl_SetListWidgetState $lst_wgt $ads_cdl_arr(type_other) $state
  }
  if { $mom_sys_arr(Inherit_UDE) } {
   set lst_wgt [lindex $gPB(Inherit_UDE_Frame) 0]
   __ads_cdl_SetListWidgetState $lst_wgt $ads_cdl_arr(type_inherit) $state
  }
 }
