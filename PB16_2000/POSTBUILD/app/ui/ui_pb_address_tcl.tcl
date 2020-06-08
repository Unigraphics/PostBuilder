#13

#=======================================================================
proc UI_PB_Def_Address {book_id addr_page_obj} {
  global tixOption
  global paOption
  global add_dis_attr
  global AddObjAttr
  set add_dis_attr(0) 0
  set add_dis_attr(1) 0
  set add_dis_attr(2) 0
  set Page::($addr_page_obj,page_id) [$book_id subwidget \
  $Page::($addr_page_obj,page_name)]
  Page::CreatePane $addr_page_obj
  UI_PB_addr_AddCompLeftPane addr_page_obj
  Page::CreateTree $addr_page_obj
  UI_PB_addr_CreateTreeElements addr_page_obj
  UI_PB_addr_AddDisplayParams $addr_page_obj 0
  __CreateAddressPageParams addr_page_obj
  UI_PB_addr_CreateActionButtons addr_page_obj
 }

#=======================================================================
proc UI_PB_addr_CreateTreeElements { PAGE_OBJ } {
  upvar $PAGE_OBJ page_obj
  global paOption
  set tree $Page::($page_obj,tree)
  set h [$tree subwidget hlist]
  $h config -bg $paOption(tree_bg)
  $tree config \
  -command   "UI_PB_addr_AddrItemSelec $page_obj" \
  -browsecmd "UI_PB_addr_AddrItemSelec $page_obj"
 }

#=======================================================================
proc UI_PB_addr_AddCompLeftPane { PAGE_OBJ } {
  upvar $PAGE_OBJ page_obj
  global gPB
  global paOption
  set left_pane $Page::($page_obj,left_pane_id)
  set but [frame $left_pane.f]
  pack $but -side top -fill x -padx 7
  set new [button $but.new -text "$gPB(tree,create,Label)" \
  -bg $paOption(app_butt_bg) \
  -command "UI_PB_addr_CreateAddress $page_obj"]
  set del [button $but.del -text "$gPB(tree,cut,Label)" \
  -bg $paOption(app_butt_bg) \
  -command "UI_PB_addr_CutAddress $page_obj"]
  set pas [button $but.pas -text "$gPB(tree,paste,Label)" \
  -bg $paOption(app_butt_bg) \
  -command "UI_PB_addr_PasteAddress $page_obj"]
  pack $new $del $pas -side left -fill x -expand yes
  set gPB(c_help,$new)   "tree,create"
  set gPB(c_help,$del)   "tree,cut"
  set gPB(c_help,$pas)   "tree,paste"
 }

#=======================================================================
proc UI_PB_addr_DisplayNameList { PAGE_OBJ OBJ_INDEX } {
  upvar $PAGE_OBJ page_obj
  upvar $OBJ_INDEX obj_index
  global paOption
  global gPB
  if { ![info exists Page::($page_obj,tree)] } { return }
  set tree $Page::($page_obj,tree)
  set h [$tree subwidget hlist]
  set file  [tix getimage pb_address]
  $h delete all
  $h add 0  -itemtype imagetext -text "" -image $paOption(folder) \
  -state disabled
  PB_int_RetAddressObjList addr_obj_list
  set style $gPB(font_style_normal)
  set count [llength $addr_obj_list]
  for {set ix 0} {$ix < $count} {incr ix}\
  {
   set addr_obj [lindex $addr_obj_list $ix]
   set addr_name $address::($addr_obj,add_name)
   $h add 0.$ix -itemtype imagetext -text $addr_name -image $file -style $style
  }
  if {$obj_index >= 0} \
  {
   $h selection set 0.$obj_index
  } else \
  {
   $h selection set 0.0
  }
  $tree autosetmode
 }

#=======================================================================
proc UI_PB_addr_CreateAddress { page_obj } {
  global ADDRESSOBJATTR
  UI_PB_addr_ApplyCurrentAddrData page_obj
  set act_addr_obj $Page::($page_obj,act_addr_obj)
  PB_int_AddCreateObject act_addr_obj ADDRESSOBJATTR obj_index
  set add_name $ADDRESSOBJATTR(0)
  set ADDRESSOBJATTR(1) $format::($ADDRESSOBJATTR(1),for_name)
  UI_PB_addr_UpdateAddrAttr ADDRESSOBJATTR $add_name
  UI_PB_addr_DisplayNameList page_obj obj_index
  UI_PB_addr_AddDisplayParams $page_obj $obj_index
  UI_PB_addr_ActivateAddrParams $page_obj
 }

#=======================================================================
proc UI_PB_addr_CutAddress { page_obj } {
  global ADDRESSOBJATTR
  set tree $Page::($page_obj,tree)
  set HLIST [$tree subwidget hlist]
  set ent [$HLIST info selection]
  set obj_index [string range $ent 2 [string length $ent]]
  set act_add_obj $Page::($page_obj,act_addr_obj)
  if {$address::($act_add_obj,blk_elem_list) != ""} \
  {
   set address_name $address::($act_add_obj,add_name)
   tk_messageBox  -parent [UI_PB_com_AskActiveWindow] -type ok -icon error\
   -message "Address \"$address_name\" is used by the Block Elements. \
   Address cannot be deleted"
   return
  }
  PB_int_AddCutObject act_add_obj obj_index add_mom_var add_var_desc \
  add_mseq_attr
  set Page::($page_obj,add_buff_obj_attr) [array get ADDRESSOBJATTR]
  set Page::($page_obj,add_buff_mom_var) $add_mom_var
  set Page::($page_obj,add_buff_var_desc) $add_var_desc
  set Page::($page_obj,add_buff_mseq_attr) [array get add_mseq_attr]
  set add_name $ADDRESSOBJATTR(0)
  UI_PB_addr_UnsetAddrAttr $add_name
  UI_PB_addr_DisplayNameList page_obj obj_index
  UI_PB_addr_AddDisplayParams $page_obj $obj_index
  UI_PB_addr_ActivateAddrParams $page_obj
 }

#=======================================================================
proc UI_PB_addr_PasteAddress { page_obj } {
  set tree $Page::($page_obj,tree)
  set HLIST [$tree subwidget hlist]
  set ent [$HLIST info selection]
  set obj_index [string range $ent 2 [string length $ent]]
  if {![info exists Page::($page_obj,add_buff_obj_attr)]} \
  {
   return
  }
  array set add_buff_obj_attr $Page::($page_obj,add_buff_obj_attr)
  set add_mom_var $Page::($page_obj,add_buff_mom_var)
  set add_var_desc $Page::($page_obj,add_buff_var_desc)
  array set add_mseq_attr $Page::($page_obj,add_buff_mseq_attr)
  set temp_index $obj_index
  PB_int_AddPasteObject add_buff_obj_attr obj_index add_mom_var add_var_desc \
  add_mseq_attr
  unset Page::($page_obj,add_buff_obj_attr)
  unset Page::($page_obj,add_buff_mom_var)
  unset Page::($page_obj,add_buff_var_desc)
  unset Page::($page_obj,add_buff_mseq_attr)
  if {$temp_index != $obj_index } \
  {
   set add_name $add_buff_obj_attr(0)
   set add_buff_obj_attr(1) $format::($add_buff_obj_attr(1),for_name)
   UI_PB_addr_UpdateAddrAttr add_buff_obj_attr $add_name
   UI_PB_addr_DisplayNameList page_obj obj_index
   UI_PB_addr_AddDisplayParams $page_obj $obj_index
   UI_PB_addr_ActivateAddrParams $page_obj
  }
 }

#=======================================================================
proc UI_PB_addr_CreateLeaderPopup { PAGE_OBJ } {
  upvar $PAGE_OBJ page_obj
  global AddObjAttr
  global add_dis_attr
  global gPB
  set f $Page::($page_obj,middle_frame)
  set menu [menu $f.pop]
  bind $f.lea_val <1> "focus %W"
  bind $f.lea_val <3> "tk_popup $menu %X %Y"
  set options_list {A B C D E F G H I J K L M N O \
  P Q R S T U V W X Y Z "gPB(address,none_popup,Label)"}
  set bind_widget $f.lea_val
  set callback "UI_PB_addr_SelectLeader"
  UI_PB_addr_SetPopupOptions page_obj menu options_list callback \
  bind_widget
 }

#=======================================================================
proc UI_PB_addr_CreateAddrFrames { PAGE_OBJ } {
  upvar $PAGE_OBJ page_obj
  set canvas_frame $Page::($page_obj,canvas_frame)
  set top_frame [tixButtonBox $canvas_frame.top \
  -orientation horizontal \
  -bd 2 \
  -relief sunken \
  -bg gray85]
  set Page::($page_obj,top_frame) $top_frame
  pack $top_frame -side top -fill x -padx 3 -pady 3
  UI_PB_mthd_CreateScrollWindow $canvas_frame addsrc src_win
  set middle_frame [frame $src_win.mid]
  pack $middle_frame -side top -pady 10 -fill both
  set Page::($page_obj,middle_frame) $middle_frame
  set bottom_frame [frame $canvas_frame.bot]
  set Page::($page_obj,bottom_frame) $bottom_frame
  pack $bottom_frame -side bottom -fill x
 }

#=======================================================================
proc UI_PB_addr_CreateComboAttr { PAGE_OBJ } {
  upvar $PAGE_OBJ page_obj
  global Format_Name
  set fmt_frm [$Page::($page_obj,middle_frame).fmt subwidget frame]
  set fmt_sel $fmt_frm.fmt_sel
  set lbx [$fmt_sel subwidget listbox]
  $lbx delete 0 end
  PB_int_RetFormatObjList fmt_obj_list
  set name_arr_size [llength $fmt_obj_list]
  for {set ind 0} {$ind < $name_arr_size} {incr ind}\
  {
   set fmt_obj [lindex $fmt_obj_list $ind]
   set fmt_name $format::($fmt_obj,for_name)
   $fmt_sel insert end $fmt_name
  }
 }

#=======================================================================
proc UI_PB_addr_CreateMiddleFrameParam { PAGE_OBJ } {
  upvar $PAGE_OBJ page_obj
  global gPB
  global add_dis_attr
  global tixOption
  global paOption
  global ADDRESSOBJATTR
  global gPB_help_tips
  global Format_Name
  global mom_sys_arr
  set f $Page::($page_obj,middle_frame)
  label $f.blk -text " "
  label $f.lea -text "$gPB(address,leader,Label)"
  entry $f.lea_val -textvariable "ADDRESSOBJATTR(8)" \
  -cursor hand2 \
  -width 5 -borderwidth 4 \
  -highlightcolor lightYellow \
  -background royalBlue \
  -foreground yellow \
  -selectbackground lightYellow \
  -selectforeground black
  bind  $f.lea_val <Return> "+UI_PB_addr__ApplyLeader $page_obj "
  UI_PB_addr_CreateLeaderPopup page_obj
  tixLabelFrame $f.fmt -label "$gPB(address,format,Label)"
  set fmt_frm [$f.fmt subwidget frame]
  set fmt_sel [tixComboBox $fmt_frm.fmt_sel \
  -dropdown   yes \
  -editable   false \
  -variable   Format_Name \
  -command    "UI_PB_addr_SelectFormat $page_obj" \
  -selectmode immediate \
  -grab       local \
  -listwidth  45 \
  -options {
   listbox.height   4
   listbox.anchor   w
   entry.width      12
  }]
  set fmt_edit [button $fmt_frm.but -text "$gPB(address,format,edit,Label)" \
  -font $tixOption(bold_font) \
  -command "UI_PB_addr_EditFormat $page_obj $fmt_sel"]
  pack $fmt_edit -side left -padx 10 -pady 5
  pack $fmt_sel  -side right -padx 10 -pady 5
  [$fmt_sel subwidget entry] config -bg lightBlue -cursor ""
  global lbx
  set lbx [$fmt_sel subwidget listbox]
  UI_PB_addr_CreateComboAttr page_obj
  tixSetSilent $fmt_sel $ADDRESSOBJATTR(1)
  tixLabelFrame $f.max -label "$gPB(address,max,frame,Label)"
  set max [$f.max subwidget frame]
  global var_max_val
  tixLabelEntry $max.val \
  -label "$gPB(address,value,text,Label)" \
  -options {
   label.width 18
   label.anchor w
   entry.width 12
   entry.anchor e
   entry.textVariable ADDRESSOBJATTR(4)
  }
  set m_opts {Truncate Warning Abort}
  set m_opt_labels(Truncate)  "$gPB(address,trunc_drop,Label)"
  set m_opt_labels(Warning)   "$gPB(address,warn_drop,Label)"
  set m_opt_labels(Abort)     "$gPB(address,abort_drop,Label)"
  tixOptionMenu $max.err \
  -label "$gPB(address,max,error_handle,Label)" \
  -variable ADDRESSOBJATTR(5) \
  -options {
   label.width 18
   label.anchor w
   menubutton.width 12
  }
  foreach opt $m_opts {
   $max.err add command $opt -label "$m_opt_labels($opt)"
  }
  pack $max.val -side top    -fill x -padx 10 -pady 4
  pack $max.err -side bottom -fill x -padx 10 -pady 2
  tixLabelFrame $f.min -label "$gPB(address,min,frame,Label)"
  set min [$f.min subwidget frame]
  global var_min_val
  tixLabelEntry $min.val \
  -label "$gPB(address,value,text,Label)" \
  -options {
   label.width 18
   label.anchor w
   entry.width 12
   entry.anchor e
   entry.textVariable ADDRESSOBJATTR(6)
  }
  tixOptionMenu $min.err \
  -label "$gPB(address,min,error_handle,Label)" \
  -variable ADDRESSOBJATTR(7) \
  -options {
   label.width 18
   label.anchor w
   menubutton.width 12
  }
  foreach opt $m_opts {
   $min.err add command $opt -label "$m_opt_labels($opt)"
  }
  pack $min.val -side top    -fill x -padx 10 -pady 4
  pack $min.err -side bottom -fill x -padx 10 -pady 2
  set opts {off once always}
  set opt_labels(off)      "$gPB(address,modal_drop,off,Label)"
  set opt_labels(once)     "$gPB(address,modal_drop,once,Label)"
  set opt_labels(always)   "$gPB(address,modal_drop,always,Label)"
  set tmp_mod_val $ADDRESSOBJATTR(2)
  tixOptionMenu $f.mod \
  -label "$gPB(address,modality,Label)" \
  -variable ADDRESSOBJATTR(2) \
  -options {
   label.width 22
   label.anchor w
   menubutton.width 8
  }
  foreach opt $opts {
   $f.mod add command $opt -label "$opt_labels($opt)"
  }
  if {![info exists ADDRESSOBJATTR(2)]  ||  $ADDRESSOBJATTR(2) == ""} {
   set ADDRESSOBJATTR(2) once
  }
  $f.mod config -value $tmp_mod_val
  label $f.tra -text "$gPB(address,trailer,Label)"
  entry $f.tra_val -textvariable ADDRESSOBJATTR(9) \
  -cursor hand2 \
  -width 5 -borderwidth 4 \
  -highlightcolor lightYellow \
  -background royalBlue \
  -foreground yellow \
  -selectbackground lightYellow \
  -selectforeground black
  bind  $f.tra_val <Return> "+UI_PB_addr__ApplyTrailer $page_obj "
  set ADDRESSOBJATTR(10) 1
  UI_PB_addr_SetCheckButPopStatus $page_obj ADDRESSOBJATTR(10)
  set menu [menu $f.pop1]
  bind $f.tra_val <1> "focus %W"
  bind $f.tra_val <3> "tk_popup $menu %X %Y"
  set bind_widget $f.tra_val
  set options_list {A B C D E F G H I J K L M N O \
  P Q R S T U V W X Y Z "gPB(address,none_popup,Label)"}
  set callback "UI_PB_addr_SelectTrailer"
  UI_PB_addr_SetPopupOptions page_obj menu options_list callback \
  bind_widget
  grid $f.blk            -
  grid $f.lea     -row 1 -col 0 -padx 5 -pady 3 -sticky w
  grid $f.lea_val -row 1 -col 1 -padx 5 -pady 3 -sticky nse
  grid $f.fmt            -      -padx 1 -pady 3 -sticky ew
  grid $f.tra     -row 3 -col 0 -padx 5 -pady 3 -sticky w
  grid $f.tra_val -row 3 -col 1 -padx 5 -pady 3 -sticky nse
  grid $f.mod            -      -padx 5 -pady 3 -sticky ew
  grid $f.max            -      -padx 1 -pady 3 -sticky ew
  grid $f.min            -      -padx 1 -pady 1 -sticky ew
  global gPB
  set gPB(c_help,$f.lea_val)      "address,leader"
  set gPB(c_help,$fmt_edit)      "address,format,edit"
  set gPB(c_help,[$fmt_sel subwidget arrow])    "address,format,select"
  set gPB(c_help,$f.tra_val)      "address,trailer"
  set gPB(c_help,[$f.mod subwidget menubutton])    "address,modality"
  set gPB(c_help,[$max.val subwidget entry])    "address,max,value"
  set gPB(c_help,[$max.err subwidget menubutton])  "address,max,error_handle"
  set gPB(c_help,[$min.val subwidget entry])    "address,min,value"
  set gPB(c_help,[$min.err subwidget menubutton])  "address,min,error_handle"
 }

#=======================================================================
proc UI_PB_addr_EditFormat { page_obj comb_widget } {
  global Format_Name
  global gPB
  set canvas_frame $Page::($page_obj,canvas_frame)
  PB_int_RetFmtObjFromName Format_Name fmt_obj
  format::readvalue $fmt_obj FORMATOBJATTR
  set win [toplevel $canvas_frame.fmt]
  set toplevel_index [llength $gPB(toplevel_list)]
  set win_index [expr $toplevel_index + 1]
  set gPB(toplevel_disable_$win_index) 1
  UI_PB_com_CreateTransientWindow $win \
  "$gPB(address,format_trans,title,Label) : $FORMATOBJATTR(0)" \
  "500x500+200+200" "UI_PB_addr_DisableAddPageWidgets $page_obj" "" \
  "UI_PB_addr_ActivateAddPageWidgets $page_obj $win_index"
  UI_PB_fmt_CreateFmtPage $page_obj $fmt_obj $win comb_widget
 }

#=======================================================================
proc UI_PB_addr_ActivateAddPageWidgets { page_obj win_index } {
  global gPB
  if { $gPB(toplevel_disable_$win_index) } \
  {
   tixEnableAll $Page::($page_obj,page_id)
   if { [info exists Page::($page_obj,tree)] } \
   {
    set t $Page::($page_obj,tree)
    set h [$t subwidget hlist]
    UI_PB_com_EnableTree $h [$h info children 0]
   }
   set gPB(toplevel_disable_$win_index) 0
  }
 }

#=======================================================================
proc UI_PB_addr_DisableAddPageWidgets { page_obj } {
  tixDisableAll $Page::($page_obj,page_id)
  if { [info exists Page::($page_obj,tree)] } \
  {
   set t $Page::($page_obj,tree)
   set h [$t subwidget hlist]
   UI_PB_com_DisableTree $h [$h info children 0] GRAY
  }
 }

#=======================================================================
proc UI_PB_addr_SetCheckButtonState {widget STATE} {
  upvar $STATE state
  switch $state\
  {
   0      {$widget config -state disabled}
   1      {$widget config -state normal}
  }
 }

#=======================================================================
proc UI_PB_addr_CreateActionButtons { PAGE_OBJ } {
  upvar $PAGE_OBJ page_obj
  global paOption
  set bottom_frame $Page::($page_obj,bottom_frame)
  set cb_arr(gPB(nav_button,default,Label)) \
  "UI_PB_addr_AddDefaultCallBack $page_obj"
  set cb_arr(gPB(nav_button,restore,Label)) \
  "UI_PB_addr_AddRestoreCallBack $page_obj"
  set label_list {"gPB(nav_button,default,Label)" \
  "gPB(nav_button,restore,Label)"}
  UI_PB_com_CreateButtonBox $bottom_frame label_list cb_arr
 }

#=======================================================================
proc UI_PB_addr_CreateLeadFmtTrailButtons { PAGE_OBJ } {
  upvar $PAGE_OBJ page_obj
  global tixOption
  global paOption
  set top_frame $Page::($page_obj,top_frame)
  global forget_flag
  button $top_frame.ldr -text "" -cursor "" \
  -font $tixOption(bold_font) \
  -bg darkSeaGreen3 -relief flat \
  -state disabled -disabledforeground lightYellow
  button $top_frame.fmt -text "" -cursor "" \
  -font $tixOption(bold_font) \
  -bg darkSeaGreen3 -relief flat \
  -state disabled -disabledforeground lightYellow
  button $top_frame.trl -text "" -cursor "" \
  -font $tixOption(bold_font) \
  -bg darkSeaGreen3 -relief flat \
  -state disabled -disabledforeground lightYellow
  grid $top_frame.ldr -row 1 -column 1 -pady 10
  grid $top_frame.fmt -row 1 -column 2 -pady 10
  grid $top_frame.trl -row 1 -column 3 -pady 10
  set forget_flag 0
  $top_frame.ldr configure -activebackground darkSeaGreen3
  $top_frame.fmt configure -activebackground darkSeaGreen3
  $top_frame.trl configure -activebackground darkSeaGreen3
  bind $top_frame <Enter> "%W config -bg $paOption(focus)"
  bind $top_frame <Leave> "%W config -bg gray85"
  global gPB
  set gPB(c_help,$top_frame)                    "address,verify"
  set gPB(c_help,$top_frame.ldr)                "address,verify"
  set gPB(c_help,$top_frame.fmt)                "address,verify"
  set gPB(c_help,$top_frame.trl)                "address,verify"
 }

#=======================================================================
proc Browse_Cmd {LBX FORMATNAMELIST x y} {
  upvar $LBX lbx
  upvar $FORMATNAMELIST FormatNameList
  global gPB_help_tips
  global old_ind
  global balloon_on
  set ind [$lbx index @$x,$y]
  set wh [winfo height $lbx]
  set ww [winfo width $lbx]
  if {![info exists balloon_on]} {
   set balloon_on 0
  }
  if {$gPB_help_tips(state)} \
  {
   if {$x >= 0 && $x <= $ww && $y >= 0 && $y <= $wh} \
   {
    set px [winfo pointerx $lbx]
    set py [winfo pointery $lbx]
    if [info exists old_ind] \
    {
     if {$ind != $old_ind} \
     {
      PB_reset_balloon $lbx $px $py $ind
      set balloon_on 1
     }
    }
    if {$balloon_on == 0} \
    {
     PB_reset_balloon $lbx $px $py $ind
     set balloon_on 1
    }
   } else \
   {
    PB_cancel_balloon
    set balloon_on 0
   }
  }
  set old_ind $ind
 }

#=======================================================================
proc UI_PB_addr_ApplyCurrentAddrData { PAGE_OBJ } {
  upvar $PAGE_OBJ page_obj
  global ADDRESSOBJATTR
  global Format_Name
  if {[info exist Page::($page_obj,act_addr_obj)]} \
  {
   set act_addr_obj $Page::($page_obj,act_addr_obj)
   set ADDRESSOBJATTR(1) $Format_Name
   set addr_name $ADDRESSOBJATTR(0)
   UI_PB_addr_UpdateAddrAttr ADDRESSOBJATTR $addr_name
   PB_int_AddApplyObject act_addr_obj ADDRESSOBJATTR
  }
 }

#=======================================================================
proc UI_PB_addr_AddressApply { PAGE_OBJ } {
  upvar $PAGE_OBJ page_obj
  if {[info exist Page::($page_obj,act_addr_obj)]} \
  {
   set act_addr_obj $Page::($page_obj,act_addr_obj)
   array set rest_addressobjattr $Page::($page_obj,rest_addressobjattr)
   set fmt_name $rest_addressobjattr(1)
   PB_int_RetFmtObjFromName fmt_name fmt_obj
   set rest_addressobjattr(1) $format::($fmt_obj,for_name)
   UI_PB_addr_ApplyCurrentAddrData page_obj
   unset Page::($page_obj,act_addr_obj)
   unset Page::($page_obj,act_addr_name)
   address::readvalue $act_addr_obj act_addr_attr
   set act_addr_fmt $act_addr_attr(1)
   format::DeleteFromAddressList $fmt_obj act_addr_obj
   format::AddToAddressList $act_addr_fmt act_addr_obj
  }
 }

#=======================================================================
proc UI_PB_addr_AddDefaultCallBack { page_obj } {
  global ADDRESSOBJATTR
  set act_addr_obj $Page::($page_obj,act_addr_obj)
  array set def_addr_obj_attr $address::($act_addr_obj,def_value)
  set fmt_obj $def_addr_obj_attr(1)
  set def_addr_obj_attr(1) $format::($fmt_obj,for_name)
  address::readvalue $act_addr_obj act_addr_attr
  set act_addr_fmt $act_addr_attr(1)
  format::DeleteFromAddressList $act_addr_fmt act_addr_obj
  format::AddToAddressList $fmt_obj act_addr_obj
  set cur_addr_name $def_addr_obj_attr(0)
  UI_PB_addr_UpdateAddrAttr def_addr_obj_attr $cur_addr_name
  UI_PB_addr_SetAddressAttr $page_obj
  UI_PB_addr_ActivateAddrParams $page_obj
 }

#=======================================================================
proc UI_PB_addr_AddRestoreCallBack { page_obj } {
  set act_addr_obj $Page::($page_obj,act_addr_obj)
  array set rest_addressobjattr $Page::($page_obj,rest_addressobjattr)
  set cur_addr_name $rest_addressobjattr(0)
  address::readvalue $act_addr_obj act_addr_attr
  set act_addr_fmt $act_addr_attr(1)
  set act_fmt_name $format::($act_addr_fmt,for_name)
  if { [string compare $act_fmt_name $rest_addressobjattr(1)] } \
  {
   format::DeleteFromAddressList $act_addr_fmt act_addr_obj
   PB_int_RetFmtObjFromName rest_addressobjattr(1) cur_fmt_obj
   format::AddToAddressList $cur_fmt_obj act_addr_obj
  }
  UI_PB_addr_UpdateAddrAttr rest_addressobjattr $cur_addr_name
  UI_PB_addr_SetAddressAttr $page_obj
  UI_PB_addr_ActivateAddrParams $page_obj
 }

#=======================================================================
proc UI_PB_addr_SelectFormat {page_obj args} {
  global ADDRESSOBJATTR
  global add_dis_attr
  global Format_Name
  set ADDRESSOBJATTR(1) $Format_Name
  PB_int_DisplayFormatValue ADDRESSOBJATTR(1) ADDRESSOBJATTR(0) \
  add_dis_attr(1) fmt_disp
  set add_dis_attr(1) $fmt_disp
  UI_PB_addr__ConfigureAddrFormat page_obj
 }

#=======================================================================
proc UI_PB_addr_SetPopupOptions {PAGE_OBJ MENU OPTIONS_LIST \
  CALLBACK BIND_WIDGET} {
  upvar $PAGE_OBJ page_obj
  upvar $MENU menu1
  upvar $OPTIONS_LIST options_list
  upvar $CALLBACK callback
  upvar $BIND_WIDGET bind_widget
  global gPB
  set count 1
  foreach ELEMENT $options_list \
  {
   if {$ELEMENT == "Help"} \
   {
    $menu1 add command -label $ELEMENT
    } elseif {$ELEMENT == "gPB(address,none_popup,Label)"} \
   {
    $menu1 add command -label [set $ELEMENT] -command \
    "$callback $page_obj $bind_widget \"\""
   } else \
   {
    if {$count == 1} \
    {
     $menu1 add command -label $ELEMENT -columnbreak 1 -command \
     "$callback $page_obj $bind_widget $ELEMENT"
    } else \
    {
     $menu1 add command -label $ELEMENT -command \
     "$callback $page_obj $bind_widget $ELEMENT"
    }
   }
   if {$count == 9} \
   {
    set count 0
   }
   incr count
  }
 }

#=======================================================================
proc UI_PB_addr_SelectLeader {page_obj b str} {
  global ADDRESSOBJATTR
  global add_dis_attr
  UI_PB_addr__UpdateEntry $b $str
  set ADDRESSOBJATTR(8) $str
  set add_dis_attr(0) $ADDRESSOBJATTR(8)
  UI_PB_addr__ConfigureAddrLeader page_obj
  $b selection range 0 end
 }

#=======================================================================
proc UI_PB_addr__UpdateEntry {e str} {
  $e delete 0 end
  $e insert 0 $str
 }

#=======================================================================
proc UI_PB_addr_SelectTrailer {page_obj b str} {
  global ADDRESSOBJATTR
  global add_dis_attr
  UI_PB_addr__UpdateEntry $b $str
  set ADDRESSOBJATTR(9) $str
  set add_dis_attr(2) $ADDRESSOBJATTR(9)
  UI_PB_addr__ConfigureAddrTrailer page_obj
  $b selection range 0 end
 }

#=======================================================================
proc UI_PB_addr__ApplyLeader {page_obj} {
  global add_dis_attr
  global ADDRESSOBJATTR
  set f $Page::($page_obj,middle_frame)
  set ADDRESSOBJATTR(8) [ $f.lea_val get ]
  set add_dis_attr(0) $ADDRESSOBJATTR(8)
  UI_PB_addr__ConfigureAddrLeader page_obj
  $f.lea_val selection range 0 end
 }

#=======================================================================
proc UI_PB_addr__ApplyTrailer {page_obj} {
  global add_dis_attr
  global ADDRESSOBJATTR
  set f $Page::($page_obj,middle_frame)
  set ADDRESSOBJATTR(9) [ $f.tra_val get ]
  set add_dis_attr(2) $ADDRESSOBJATTR(9)
  UI_PB_addr__ConfigureAddrTrailer page_obj
  $f.tra_val selection range 0 end
 }

#=======================================================================
proc UI_PB_addr_AddrItemSelec { page_obj args } {
  set tree $Page::($page_obj,tree)
  set HLIST [$tree subwidget hlist]
  set ent [$HLIST info selection]
  set index [string range $ent 2 [string length $ent]]
  if {[string compare $index ""] == 0}\
  {
   set index 0
   $HLIST selection clear
   $HLIST anchor clear
   $HLIST selection set 0.0
   $HLIST anchor set 0.0
  }
  UI_PB_addr_AddressApply page_obj
  UI_PB_addr_AddDisplayParams $page_obj $index
  UI_PB_addr_ActivateAddrParams $page_obj
 }

#=======================================================================
proc UI_PB_addr_AddDisplayParams { page_obj index} {
  global ADDRESSOBJATTR
  PB_int_RetAddressObjList addr_obj_list
  if {$index >= 0} \
  {
   set addr_obj [lindex $addr_obj_list $index]
   set Page::($page_obj,act_addr_obj) $addr_obj
   set Page::($page_obj,act_addr_name) $address::($addr_obj,add_name)
   UI_PB_addr_SetAddressAttr $page_obj
   if {[info exists Page::($page_obj,rest_addressobjattr)]} \
   {
    unset Page::($page_obj,rest_addressobjattr)
   }
   set Page::($page_obj,rest_addressobjattr) [array get ADDRESSOBJATTR]
  }
 }

#=======================================================================
proc UI_PB_addr_ActivateAddrParams { page_obj } {
  global ADDRESSOBJATTR
  global add_dis_attr
  global mom_sys_arr
  set middle_frame $Page::($page_obj,middle_frame)
  UI_PB_addr_SetCheckButtonState $middle_frame.mod ADDRESSOBJATTR(3)
  UI_PB_addr_SetCheckButtonState $middle_frame.min_val ADDRESSOBJATTR(7)
  UI_PB_addr_SetCheckButtonState $middle_frame.max_val ADDRESSOBJATTR(5)
  UI_PB_addr__UpdateEntry $middle_frame.lea_val $ADDRESSOBJATTR(8)
  UI_PB_addr__UpdateEntry $middle_frame.tra_val $ADDRESSOBJATTR(9)
  set add_obj $Page::($page_obj,act_addr_obj)
  set addr_name $address::($add_obj,add_name)
  set addr_glob_var $address::($add_obj,rep_mom_var)
  PB_com_MapMOMVariable mom_sys_arr add_obj addr_glob_var blk_elem_text
  PB_int_GetElemDisplayAttr addr_name blk_elem_text add_dis_attr
  UI_PB_addr__ConfigureAddrAttributes page_obj
  UI_PB_addr_SetCheckButPopStatus $page_obj ADDRESSOBJATTR(10)
 }

#=======================================================================
proc UI_PB_addr_SetAddressAttr { page_obj } {
  global gpb_addr_var
  global ADDRESSOBJATTR
  global Format_Name
  set add_name $Page::($page_obj,act_addr_name)
  set ADDRESSOBJATTR(0) $gpb_addr_var($add_name,name)
  set ADDRESSOBJATTR(1) $gpb_addr_var($add_name,fmt_name)
  set ADDRESSOBJATTR(2) $gpb_addr_var($add_name,modal)
  set ADDRESSOBJATTR(3) $gpb_addr_var($add_name,modl_status)
  set ADDRESSOBJATTR(4) $gpb_addr_var($add_name,add_max)
  set ADDRESSOBJATTR(5) $gpb_addr_var($add_name,max_status)
  set ADDRESSOBJATTR(6) $gpb_addr_var($add_name,add_min)
  set ADDRESSOBJATTR(7) $gpb_addr_var($add_name,min_status)
  set ADDRESSOBJATTR(8) $gpb_addr_var($add_name,leader_name)
  set ADDRESSOBJATTR(9) $gpb_addr_var($add_name,trailer)
  set ADDRESSOBJATTR(10) $gpb_addr_var($add_name,trail_status)
  set ADDRESSOBJATTR(11) $gpb_addr_var($add_name,incremental)
  set ADDRESSOBJATTR(12) $gpb_addr_var($add_name,zero_format)
  set Format_Name $ADDRESSOBJATTR(1)
 }

#=======================================================================
proc UI_PB_addr_UpdateAddrAttr { TEMP_ADDOBJATTR add_name } {
  upvar $TEMP_ADDOBJATTR temp_addobjattr
  global gpb_addr_var
  set gpb_addr_var($add_name,name) $temp_addobjattr(0)
  set gpb_addr_var($add_name,fmt_name) $temp_addobjattr(1)
  set gpb_addr_var($add_name,modal) $temp_addobjattr(2)
  set gpb_addr_var($add_name,modl_status) $temp_addobjattr(3)
  set gpb_addr_var($add_name,add_max) $temp_addobjattr(4)
  set gpb_addr_var($add_name,max_status) $temp_addobjattr(5)
  set gpb_addr_var($add_name,add_min) $temp_addobjattr(6)
  set gpb_addr_var($add_name,min_status) $temp_addobjattr(7)
  set gpb_addr_var($add_name,leader_name) $temp_addobjattr(8)
  set gpb_addr_var($add_name,trailer) $temp_addobjattr(9)
  set gpb_addr_var($add_name,trail_status) $temp_addobjattr(10)
  set gpb_addr_var($add_name,incremental) $temp_addobjattr(11)
  set gpb_addr_var($add_name,zero_format) $temp_addobjattr(12)
 }

#=======================================================================
proc UI_PB_addr_UnsetAddrAttr { add_name } {
  global gpb_addr_var
  unset gpb_addr_var($add_name,name)
  unset gpb_addr_var($add_name,fmt_name)
  unset gpb_addr_var($add_name,modal)
  unset gpb_addr_var($add_name,modl_status)
  unset gpb_addr_var($add_name,add_max)
  unset gpb_addr_var($add_name,max_status)
  unset gpb_addr_var($add_name,add_min)
  unset gpb_addr_var($add_name,min_status)
  unset gpb_addr_var($add_name,leader_name)
  unset gpb_addr_var($add_name,trailer)
  unset gpb_addr_var($add_name,trail_status)
  unset gpb_addr_var($add_name,incremental)
  unset gpb_addr_var($add_name,zero_format)
 }

#=======================================================================
proc UI_PB_addr_SetCheckButPopStatus {page_obj STATE} {
  upvar $STATE state
  global add_dis_attr
  global forget_flag
  set middle_frame $Page::($page_obj,middle_frame)
  if {!$state}\
  {
   $middle_frame.tra_val configure -state disabled -cursor ""
   bind $middle_frame.tra_val <3> ""
   set forget_flag 1
  } else\
  {
   $middle_frame.tra_val configure -state normal -cursor hand2
   bind $middle_frame.tra_val <1> "focus %W"
   bind $middle_frame.tra_val <3> "tk_popup $middle_frame.pop1 %X %Y"
   set forget_flag 0
  }
  UI_PB_addr__ConfigureAddrAttributes page_obj
 }

#=======================================================================
proc UI_PB_addr__ConfigureAddrLeader { PAGE_OBJ } {
  upvar $PAGE_OBJ page_obj
  global add_dis_attr
  set top_frame $Page::($page_obj,top_frame)
  $top_frame.ldr configure -text $add_dis_attr(0)
  if {[string compare $add_dis_attr(0) ""]} \
  {
   grid $top_frame.ldr -row 1 -column 1 -pady 10
  } else \
  {
   grid forget $top_frame.ldr
  }
 }

#=======================================================================
proc UI_PB_addr__ConfigureAddrFormat { PAGE_OBJ } {
  upvar $PAGE_OBJ page_obj
  global add_dis_attr
  set top_frame $Page::($page_obj,top_frame)
  $top_frame.fmt configure -text $add_dis_attr(1)
 }

#=======================================================================
proc UI_PB_addr__ConfigureAddrTrailer { PAGE_OBJ } {
  upvar $PAGE_OBJ page_obj
  global add_dis_attr
  global forget_flag
  set top_frame $Page::($page_obj,top_frame)
  $top_frame.trl configure -text $add_dis_attr(2)
  if {[string compare $add_dis_attr(2) ""]} \
  {
   if {$forget_flag == 0} \
   {
    grid $top_frame.trl -row 1 -column 3 -pady 10
   } else \
   {
    grid forget $top_frame.trl
   }
  } else \
  {
   grid forget $top_frame.trl
  }
 }

#=======================================================================
proc UI_PB_addr__ConfigureAddrAttributes { PAGE_OBJ } {
  upvar $PAGE_OBJ page_obj
  UI_PB_addr__ConfigureAddrLeader  page_obj
  UI_PB_addr__ConfigureAddrFormat  page_obj
  UI_PB_addr__ConfigureAddrTrailer page_obj
 }

#=======================================================================
proc UI_PB_addr_TabAddressCreate { addr_page_obj } {
  set tree $Page::($addr_page_obj,tree)
  set HLIST [$tree subwidget hlist]
  set ent [$HLIST info selection]
  set index [string range $ent 2 [string length $ent]]
  if {[string compare $index ""] == 0} \
  {
   set index 0
  }
  UI_PB_addr_DisplayNameList addr_page_obj index
  UI_PB_addr_AddrItemSelec $addr_page_obj
  UI_PB_addr_CreateComboAttr addr_page_obj
 }

#=======================================================================
proc UI_PB_addr_CreateAddressPage { win add_obj NEW_ADD_PAGE } {
  upvar $NEW_ADD_PAGE new_add_page
  global ADDRESSOBJATTR
  global Format_Name
  global paOption
  global add_dis_attr
  set add_dis_attr(0) 0
  set add_dis_attr(1) 0
  set add_dis_attr(2) 0
  address::readvalue $add_obj ADDRESSOBJATTR
  format::readvalue $ADDRESSOBJATTR(1) fmt_obj_attr
  set ADDRESSOBJATTR(1) $fmt_obj_attr(0)
  set pname $ADDRESSOBJATTR(0)
  set Format_Name $ADDRESSOBJATTR(1)
  set new_add_page [new Page $pname $pname]
  set Page::($new_add_page,page_id) $win
  set Page::($new_add_page,canvas_frame) $win
  set Page::($new_add_page,act_addr_obj) $add_obj
  set Page::($new_add_page,act_addr_name) $ADDRESSOBJATTR(0)
  set Page::($new_add_page,rest_addressobjattr) [array get ADDRESSOBJATTR]
  __CreateAddressPageParams new_add_page
 }

#=======================================================================
proc __CreateAddressPageParams { ADD_PAGE_OBJ } {
  upvar $ADD_PAGE_OBJ add_page_obj
  UI_PB_addr_CreateAddrFrames add_page_obj
  UI_PB_addr_CreateLeadFmtTrailButtons add_page_obj
  UI_PB_addr_CreateMiddleFrameParam add_page_obj
  UI_PB_addr_ActivateAddrParams $add_page_obj
 }

#=======================================================================
proc UI_PB_add_MseqEditOkCallBack { mseq_page_obj add_page_obj win addr_obj } {
  set bot_canvas $Page::($mseq_page_obj,bot_canvas)
  UI_PB_addr_ApplyCurrentAddrData add_page_obj
  $bot_canvas delete $address::($addr_obj,image_id)
  address::readMseqAttr $addr_obj addr_mseq_attr
  UI_PB_com_RetImageAppdText addr_obj addr_mseq_attr(0) \
  temp_image_name addr_app_text
  set xc $address::($addr_obj,xc)
  set yc $address::($addr_obj,yc)
  set image_id [UI_PB_blk_CreateIcon $bot_canvas $temp_image_name \
  $addr_app_text]
  set icon_id [$bot_canvas create image  $xc $yc -image $image_id \
  -tag movable]
  set address::($addr_obj,image_id) $icon_id
  set address::($addr_obj,icon_id) $image_id
  if { $address::($addr_obj,word_status) == 0} \
  {
   $image_id configure -relief sunken -background pink
  } else \
  {
   $image_id configure -relief raised -background #c0c0ff
  }
  delete $add_page_obj
  destroy $win
 }

#=======================================================================
proc UI_PB_add_EditOkCallBack { blk_page_obj add_page_obj win blk_elem_obj } {
  global elem_text_var
  set block_element::($blk_elem_obj,elem_mom_variable) $elem_text_var
  UI_PB_addr_ApplyCurrentAddrData add_page_obj
  set add_obj $block_element::($blk_elem_obj,elem_add_obj)
  set base_addr $address::($add_obj,add_name)
  UI_PB_blk_ReplaceIcon blk_page_obj $base_addr $blk_elem_obj
  UI_PB_blk_ConfigureLeader blk_page_obj blk_elem_obj
  delete $add_page_obj
  destroy $win
 }

#=======================================================================
proc UI_PB_add_EditCancelCallBack { add_page_obj win } {
  delete $add_page_obj
  destroy $win
 }

#=======================================================================
proc UI_PB_add_NewBlkCancelCallBack { blk_page_obj add_page_obj win \
  blk_elem_obj } {
  set add_obj $block_element::($blk_elem_obj,elem_add_obj)
  set Page::($blk_page_obj,source_elem_obj) $blk_elem_obj
  UI_PB_blk_UpdateCells blk_page_obj
  PB_int_RemoveAddObjFromList add_obj
  destroy $win
  delete $add_page_obj
 }

#=======================================================================
proc UI_PB_add_NewEvtCancelCallBack { blk_page_obj event_obj evt_elem_obj \
  new_add_page win blk_elem_obj } {
  set add_obj $block_element::($blk_elem_obj,elem_add_obj)
  PB_int_RemoveAddObjFromList add_obj
  set Page::($blk_page_obj,source_blk_elem_obj) $blk_elem_obj
  set Page::($blk_page_obj,source_evt_elem_obj) $evt_elem_obj
  destroy $win
  delete $new_add_page
  UI_PB_tpth_PutBlockElemTrash blk_page_obj event_obj
  set Page::($blk_page_obj,source_blk_elem_obj) 0
  set Page::($blk_page_obj,source_evt_elem_obj) 0
 }

#=======================================================================
proc UI_PB_add_NewOkCallBack { blk_page_obj add_page_obj win blk_elem_obj \
  page_name } {
  global elem_text_var
  if { $elem_text_var == "" } \
  {
   tk_messageBox -parent [UI_PB_com_AskActiveWindow] -type ok -icon error \
   -message "Expression Entry cannot be empty."
   return
  }
  UI_PB_addr_ApplyCurrentAddrData add_page_obj
  PB_int_GetWordVarDesc WordDescArray
  set block_element::($blk_elem_obj,elem_mom_variable) $elem_text_var
  set addr_obj $block_element::($blk_elem_obj,elem_add_obj)
  set base_addr $address::($addr_obj,add_name)
  set WordDescArray($base_addr) ""
  PB_int_UpdateAddVariablesAttr WordDescArray base_addr
  UI_PB_blk_ReplaceIcon blk_page_obj $base_addr $blk_elem_obj
  UI_PB_blk_ConfigureLeader blk_page_obj blk_elem_obj
  UI_PB_blk_CreateMenuOptions blk_page_obj $page_name
  destroy $win
  delete $add_page_obj
 }

#=======================================================================
proc UI_PB_add_NewMseqOkCallBack { mseq_page_obj new_add_page win \
  add_obj } {
  UI_PB_add_MseqEditOkCallBack $mseq_page_obj $new_add_page $win $add_obj
  PB_int_GetWordVarDesc WordDescArray
  set base_addr $address::($add_obj,add_name)
  set WordDescArray($base_addr) ""
  PB_int_UpdateAddVariablesAttr WordDescArray base_addr
 }

#=======================================================================
proc UI_PB_add_NewMseqCancelCallBack { mseq_page_obj add_page_obj win \
  add_obj } {
  set mseq_addr_list $Page::($page_obj,mseq_addr_list)
  UI_PB_mseq_DeleteMastSeqElems mseq_page_obj
  PB_int_RemoveAddObjFromList add_obj
  destroy $win
  delete $add_page_obj
  set index [lsearch $mseq_addr_list $add_obj]
  if { $index != -1 } \
  {
   set mseq_addr_list [lreplace $mseq_addr_list $index $index]
  }
  UI_PB_mseq_CreateComponents mseq_page_obj mseq_addr_list
 }
