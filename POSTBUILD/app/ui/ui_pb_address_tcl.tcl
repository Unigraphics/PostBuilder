#3

#=======================================================================
proc UI_PB_Def_Address {book_id addr_page_obj} {
  global tixOption
  global paOption
  global add_dis_attr
  global AddObjAttr
  set add_dis_attr(0) 0
  set add_dis_attr(1) 0
  set add_dis_attr(2) 0
  if ![string compare $::tix_version 8.4] {
   set ::gPB(scrollbar_flag) y
  }
  set Page::($addr_page_obj,page_id) [$book_id subwidget \
  $Page::($addr_page_obj,page_name)]
  Page::CreatePane $addr_page_obj
  UI_PB_addr_AddCompLeftPane addr_page_obj
  Page::CreateTree $addr_page_obj
  UI_PB_addr_CreateTreePopup addr_page_obj
  UI_PB_addr_CreateTreeElements addr_page_obj
  UI_PB_addr_AddDisplayParams $addr_page_obj 0
  __CreateAddressPageParams addr_page_obj 0
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
  -command   "UI_PB_addr_EditAddressName $page_obj" \
  -browsecmd "UI_PB_addr_SelectItem $page_obj"
 }

#=======================================================================
proc UI_PB_addr_CreateTreePopup { PAGE_OBJ } {
  upvar $PAGE_OBJ page_obj
  set tree $Page::($page_obj,tree)
  set h [$tree subwidget hlist]
  set popup [menu $h.pop -tearoff 0]
  set Page::($page_obj,tree_popup) $popup
  bind $h <3> "UI_PB_addr_CreateTreePopupElements $page_obj %X %Y %x %y"
  set Page::($page_obj,double_click_flag) 0
 }

#=======================================================================
proc UI_PB_addr_CreateTreePopupElements { page_obj X Y x y } {
  global gPB
  set tree $Page::($page_obj,tree)
  set h [$tree subwidget hlist]
  raise $gPB(main_window)
  set cursor_entry [$h nearest $y]
  set indent [$h cget -indent]
  if { [string compare $cursor_entry "0"] != 0 } \
  {
   if { [UI_PB_addr_SelectItem $page_obj $cursor_entry] == 0 } {
    return
   }
  }
  set popup $Page::($page_obj,tree_popup)
  set active_index [$h info selection]
  if { $x >= [expr $indent * 2] && \
   $Page::($page_obj,double_click_flag) == 0 && \
  $active_index == $cursor_entry } \
  {
   $popup delete 0 end
   set active_addr $Page::($page_obj,act_addr_obj)
   address::readMseqAttr $active_addr mseq_attr
   if { $mseq_attr(4) == 1} \
   {
    $popup add command -label "$gPB(tree,rename,Label)" -state normal \
    -command "UI_PB_addr_EditAddressName $page_obj $active_index"
   } else \
   {
    $popup add command -label "$gPB(tree,rename,Label)" -state disabled
   }
   $popup add sep
   if { $address::($active_addr,add_name) == "N"  || \
    $address::($active_addr,add_name) == "Text" } {
    $popup add command -label "$gPB(tree,create,Label)" -state disabled
    } else {
    $popup add command -label "$gPB(tree,create,Label)" -state normal \
    -command "UI_PB_addr_CreateAddress $page_obj"
   }
   if { $mseq_attr(4) == 1} \
   {
    $popup add command -label "$gPB(tree,cut,Label)" -state normal \
    -command "UI_PB_addr_CutAddress $page_obj"
   } else \
   {
    $popup add command -label "$gPB(tree,cut,Label)" -state disabled
   }
   if { [info exists Page::($page_obj,buff_obj_attr)] } \
   {
    if { $address::($active_addr,add_name) == "N" || \
    $address::($active_addr,add_name) == "Text" } \
    {
     $popup add command -label "$gPB(tree,paste,Label)" -state disabled
    } else \
    {
     $popup add command -label "$gPB(tree,paste,Label)" -state normal \
     -command "UI_PB_addr_PasteAddress $page_obj"
    }
   } else \
   {
    $popup add command -label "$gPB(tree,paste,Label)" -state disabled
   }
   tk_popup $popup $X $Y
  }
 }

#=======================================================================
proc UI_PB_addr_EditAddressName { page_obj index } {
  global gPB_address_name
  global gPB
  global paOption
  set tree $Page::($page_obj,tree)
  set HLIST [$tree subwidget hlist]
  set active_addr $Page::($page_obj,act_addr_obj)
  address::readMseqAttr $active_addr mseq_attr
  if { $mseq_attr(4) == 0 } { return }
  $HLIST delete entry $index
  set col [string range $index 2 end]
  if { [winfo exists $HLIST.addr] != 1 } \
  {
   set new_frm [frame $HLIST.addr -bg $paOption(tree_bg)]
   label $new_frm.lbl -text " " -bg $paOption(tree_bg)
   set img_id [image create compound -window $new_frm.lbl]
   $img_id add image -image [tix getimage pb_address]
   $new_frm.lbl config -image $img_id
   unset img_id
   pack $new_frm.lbl -side left
   entry $new_frm.ent -bd 1 -relief solid -state normal \
   -textvariable gPB_address_name
   pack $new_frm.ent -side left -padx 2
  } else \
  {
   set new_frm $HLIST.addr
  }
  $new_frm.ent config -width $gPB(MOM_obj_name_len)
  focus $new_frm.ent
  $HLIST add $index -itemtype window -window $new_frm -at $col
  bind $new_frm.ent <Return> "UI_PB_addr_UpdateAddrNameEntry $page_obj $index"
  bind $new_frm.ent <KeyPress> "UI_PB_com_DisableSpecialChars %W %K"
  bind $new_frm.ent <KeyPress> "+UI_PB_com_RestrictStringLength %W %K"
  bind $new_frm.ent <KeyRelease> { %W config -state normal }
  __addr_RestoreNamePopup $new_frm.ent $page_obj
  $new_frm.ent selection range 0 end
  $new_frm.ent icursor end
  set Page::($page_obj,double_click_flag) 1
  set Page::($page_obj,rename_index) $index
  $HLIST entryconfig $index -state disabled
  bind $new_frm.lbl <1> "UI_PB_addr_UpdateAddrNameEntry $page_obj $index"
  grab $Page::($page_obj,page_id)
 }

#=======================================================================
proc __addr_RestoreNamePopup { w page_obj } {
  global gPB
  global gPB_address_name
  if { ![winfo exists $w.pop] } \
  {
   menu $w.pop -tearoff 0
   $w.pop add command -label "$gPB(nav_button,restore,Label)"
  }
  set active_addr $Page::($page_obj,act_addr_obj)
  $w.pop entryconfig 0 -command "$w config -state normal;\
  set gPB_address_name $address::($active_addr,add_name);\
  $w icursor end"
  bind $w <3> "%W config -state disabled"
  bind $w <3> "+tk_popup $w.pop %X %Y"
 }

#=======================================================================
proc UI_PB_addr_UpdateAddrNameEntry { page_obj index } {
  global gPB
  global gPB_address_name
  if { ![info exists Page::($page_obj,rename_index)] } { return }
  if { ![info exists Page::($page_obj,act_addr_obj)] } { return }
  set tree $Page::($page_obj,tree)
  set HLIST [$tree subwidget hlist]
  set style $gPB(font_style_normal)
  set file   [tix getimage pb_address]
  set active_addr $Page::($page_obj,act_addr_obj)
  set ret_code [UI_PB_addr_CheckAddressName gPB_address_name active_addr]
  if {$ret_code == 0} \
  {
   set col [string range $index 2 end]
   $HLIST delete entry $index
   $HLIST add $index -itemtype imagetext -text $gPB_address_name \
   -image $file -style $style -at $col
   $HLIST selection set $index
   $HLIST anchor set $index
   set Page::($page_obj,double_click_flag) 0
  } else \
  {
   return [ UI_PB_addr_DenyAddrRename $ret_code $page_obj $index ]
  }
  UI_PB_addr_UpdateAddrNameData page_obj
  set ent $Page::($page_obj,rename_index)
  UI_PB_addr_SetAddrDesc $ent
  grab release $Page::($page_obj,page_id)
  unset Page::($page_obj,rename_index)
 }

#=======================================================================
proc UI_PB_addr_SetAddrDesc { ent } {
  PB_int_RetAddressObjList addr_obj_list
  set idx [string range $ent 2 end]
  set add_obj [lindex $addr_obj_list $idx]
  address::readMseqAttr $add_obj mseq_attr
  if { $mseq_attr(4) == 1 } \
  {
   set mseq_attr(2) ($address::($add_obj,add_name))
   address::SetMseqAttr $add_obj mseq_attr
  }
 }

#=======================================================================
proc UI_PB_addr_CheckAddressName { ADDRESS_NAME ADDR_OBJ } {
  upvar $ADDRESS_NAME address_name
  upvar $ADDR_OBJ addr_obj
  set address_name [string trim $address_name " "]
  if { $address_name == "" } {
   return 2
  }
  if { $address_name == "rapid1" || \
   $address_name == "rapid2" || \
   $address_name == "rapid3" } {
   return 3
  }
  PB_int_RetAddressObjList add_obj_list
  set add_indx [lsearch $add_obj_list $addr_obj]
  if { $add_indx != -1 } {
   set add_obj_list [lreplace $add_obj_list $add_indx $add_indx]
  }
  set ret_code 0
  PB_com_RetObjFrmName address_name add_obj_list ret_code
  if { $ret_code == 0 } {
   return 0
   } else {
   return 1
  }
 }

#=======================================================================
proc UI_PB_addr_DenyAddrRename { error_no args } {
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
    if { [winfo exists $HLIST.addr.ent] } \
    {
     focus $HLIST.addr.ent
    }
   }
  }
  if { $error_no == 1 } \
  {
   global gPB_address_name
   tk_messageBox  -parent [UI_PB_com_AskActiveWindow] -type ok \
   -icon error\
   -message "\"$gPB_address_name\" $gPB(msg,name_exists)"
   } elseif { $error_no == 2 } \
  {
   tk_messageBox  -parent [UI_PB_com_AskActiveWindow] -type ok \
   -icon error\
   -message "$gPB(address,name_msg)"
   } elseif { $error_no == 3 } \
  {
   tk_messageBox  -parent [UI_PB_com_AskActiveWindow] -type ok \
   -icon error\
   -message "$gPB(address,rapid_add_name_msg)"
  }
  return UI_PB_ERROR
 }

#=======================================================================
proc UI_PB_addr_UpdateAddrNameData { PAGE_OBJ } {
  upvar $PAGE_OBJ page_obj
  global gPB_address_name
  global ADDRESSOBJATTR
  set active_addr $Page::($page_obj,act_addr_obj)
  set prev_add_name $address::($active_addr,add_name)
  set cur_add_name $gPB_address_name
  if { [string compare $prev_add_name $cur_add_name] != 0 } \
  {
   set old_add_name $address::($active_addr,add_name)
   UI_PB_addr_UnsetAddrAttr $old_add_name
   PB_int_ChangeAddrNameOfParam active_addr gPB_address_name
   address::readvalue $active_addr addr_obj_attr
   set addr_obj_attr(0) $gPB_address_name
   address::setvalue $active_addr addr_obj_attr
   array set def_addr_attr $address::($active_addr,def_value)
   set def_addr_attr(0) $gPB_address_name
   address::DefaultValue $active_addr def_addr_attr
   array set rest_addr_attr $Page::($page_obj,rest_addressobjattr)
   set rest_addr_attr(0) $gPB_address_name
   set Page::($page_obj,rest_addressobjattr) [array get rest_addr_attr]
   UI_PB_addr_UpdateAddrAttr addr_obj_attr $gPB_address_name
   set ADDRESSOBJATTR(0) $gPB_address_name
  }
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
  -bg $paOption(app_butt_bg) -state normal \
  -command "UI_PB_addr_CreateAddress $page_obj"]
  set del [button $but.del -text "$gPB(tree,cut,Label)" \
  -bg $paOption(app_butt_bg) -state normal \
  -command "UI_PB_addr_CutAddress $page_obj"]
  set pas [button $but.pas -text "$gPB(tree,paste,Label)" \
  -bg $paOption(app_butt_bg) -state disabled \
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
   $h add 0.$ix -itemtype imagetext -text $addr_name -image $file \
   -style $style
  }
  if {$obj_index >= 0} \
  {
   $h selection set 0.$obj_index
  } else \
  {
   $h selection set 0.0
  }
 }

#=======================================================================
proc UI_PB_addr_CreateAddress { page_obj } {
  global ADDRESSOBJATTR
  if { [info exists Page::($page_obj,rename_index)] } \
  {
   if { [UI_PB_addr_UpdateAddrNameEntry $page_obj \
    $Page::($page_obj,rename_index)] == "UI_PB_ERROR" } {
    return
   }
  }
  UI_PB_addr_ApplyCurrentAddrData page_obj
  set act_addr_obj $Page::($page_obj,act_addr_obj)
  if { $Page::($page_obj,double_click_flag) } \
  {
   set Page::($page_obj,double_click_flag) 0
   unset Page::($page_obj,rename_index)
  }
  PB_int_AddCreateObject act_addr_obj ADDRESSOBJATTR obj_index
  set add_name $ADDRESSOBJATTR(0)
  set ADDRESSOBJATTR(1) $format::($ADDRESSOBJATTR(1),for_name)
  UI_PB_addr_UpdateAddrAttr ADDRESSOBJATTR $add_name
  UI_PB_addr_DisplayNameList page_obj obj_index
  UI_PB_addr_AddDisplayParams $page_obj $obj_index
  UI_PB_addr_SetAddrParams $page_obj
  set Page::($page_obj,selected_index) "0.$obj_index"
  set ent $Page::($page_obj,selected_index)
  UI_PB_addr_SetAddrDesc $ent
  set add_obj $Page::($page_obj,act_addr_obj)
  __addr_SetActionButtonsSens $page_obj $add_obj
 }

#=======================================================================
proc UI_PB_addr_CutAddress { page_obj } {
  global ADDRESSOBJATTR
  global gPB
  set act_add_obj $Page::($page_obj,act_addr_obj)
  set address_name $address::($act_add_obj,add_name)
  if {$address::($act_add_obj,blk_elem_list) != ""} \
  {
   tk_messageBox  -parent [UI_PB_com_AskActiveWindow] -type ok -icon error\
   -message "$gPB(msg,in_use)"
   return
  }
  global post_object
  Post::GetObjList $post_object command cmd_obj_list
  foreach cmd_obj $cmd_obj_list {
   foreach add $command::($cmd_obj,add_list) {
    if [string match "$address_name" $add] {
     tk_messageBox  -parent [UI_PB_com_AskActiveWindow] -type ok -icon error\
     -message "$gPB(cust_cmd,add,msg) $address_name\n\n\
     $gPB(cust_cmd,referenced,msg) \"$command::($cmd_obj,name)\"\
     $gPB(cust_cmd,cannot_delete,msg)"
     return
    }
   }
  }
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
  PB_int_AddCutObject act_add_obj obj_index add_mom_var add_var_desc \
  add_mseq_attr
  set Page::($page_obj,buff_obj_attr) [array get ADDRESSOBJATTR]
  set Page::($page_obj,add_buff_mom_var) $add_mom_var
  set Page::($page_obj,add_buff_var_desc) $add_var_desc
  set Page::($page_obj,add_buff_mseq_attr) [array get add_mseq_attr]
  set add_name $ADDRESSOBJATTR(0)
  UI_PB_addr_UnsetAddrAttr $add_name
  UI_PB_addr_DisplayNameList page_obj obj_index
  UI_PB_addr_AddDisplayParams $page_obj $obj_index
  UI_PB_addr_SetAddrParams $page_obj
  set add_obj $Page::($page_obj,act_addr_obj)
  __addr_SetActionButtonsSens $page_obj $add_obj
  set Page::($page_obj,selected_index) "0.$obj_index"
 }

#=======================================================================
proc UI_PB_addr_PasteAddress { page_obj } {
  if {![info exists Page::($page_obj,buff_obj_attr)]} \
  {
   return
  }
  if { [info exists Page::($page_obj,rename_index)] } \
  {
   if { [UI_PB_addr_UpdateAddrNameEntry $page_obj \
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
  set add_mom_var $Page::($page_obj,add_buff_mom_var)
  set add_var_desc $Page::($page_obj,add_buff_var_desc)
  array set add_mseq_attr $Page::($page_obj,add_buff_mseq_attr)
  set temp_index $obj_index
  PB_int_AddPasteObject buff_obj_attr obj_index add_mom_var add_var_desc \
  add_mseq_attr
  unset Page::($page_obj,buff_obj_attr)
  unset Page::($page_obj,add_buff_mom_var)
  unset Page::($page_obj,add_buff_var_desc)
  unset Page::($page_obj,add_buff_mseq_attr)
  if {$temp_index != $obj_index } \
  {
   set add_name $buff_obj_attr(0)
   set buff_obj_attr(1) $format::($buff_obj_attr(1),for_name)
   UI_PB_addr_UpdateAddrAttr buff_obj_attr $add_name
   UI_PB_addr_DisplayNameList page_obj obj_index
   UI_PB_addr_AddDisplayParams $page_obj $obj_index
   UI_PB_addr_SetAddrParams $page_obj
   set Page::($page_obj,selected_index) "0.$obj_index"
  }
  set add_obj $Page::($page_obj,act_addr_obj)
  __addr_SetActionButtonsSens $page_obj $add_obj
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
proc UI_PB_addr_CreateTrailerPopup { PAGE_OBJ } {
  upvar $PAGE_OBJ page_obj
  global AddObjAttr
  global add_dis_attr
  global gPB
  set f $Page::($page_obj,middle_frame)
  set menu [menu $f.pop1]
  bind $f.tra_val <1> "focus %W"
  bind $f.tra_val <3> "tk_popup $menu %X %Y"
  set bind_widget $f.tra_val
  set options_list {A B C D E F G H I J K L M N O \
  P Q R S T U V W X Y Z "gPB(address,none_popup,Label)"}
  set callback "UI_PB_addr_SelectTrailer"
  UI_PB_addr_SetPopupOptions page_obj menu options_list callback \
  bind_widget
 }

#=======================================================================
proc UI_PB_addr_CreateAddrFrames { PAGE_OBJ } {
  upvar $PAGE_OBJ page_obj
  global paOption
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
  pack $top_frame -side top -fill x -padx 3 -pady 3
  UI_PB_mthd_CreateScrollWindow $canvas_frame addsrc src_win y
  if 0 {
   if ![string compare $::tix_version 8.4] {
    UI_PB_mthd_CreateScrollWindow $canvas_frame addsrc src_win $::gPB(scrollbar_flag)
    } else {
    UI_PB_mthd_CreateScrollWindow $canvas_frame addsrc src_win
   }
  }
  if ![string compare $::tix_version 8.4] {
   if [string compare $::gPB(scrollbar_flag) null] {
    place $src_win -rely -0.05
   }
  }
  set middle_frame [frame $src_win.mid]
  set Page::($page_obj,middle_frame) $middle_frame
  set bottom_frame [frame $canvas_frame.bot]
  set Page::($page_obj,bottom_frame) $bottom_frame
  pack $bottom_frame -side bottom -fill x -padx 3
  pack $middle_frame -side bottom -pady 10 -fill both
 }

#=======================================================================
proc UI_PB_addr_CreateComboAttr { PAGE_OBJ } {
  upvar $PAGE_OBJ page_obj
  global Format_Name
  set fmt_frm [$Page::($page_obj,middle_frame).fmt subwidget frame]
  set fmt_sel $fmt_frm.sel
  set lbx [$fmt_sel subwidget listbox]
  $lbx delete 0 end
  PB_int_RetFormatObjList fmt_obj_list
  set name_arr_size [llength $fmt_obj_list]
  for {set ind 0} {$ind < $name_arr_size} {incr ind}\
  {
   set fmt_obj [lindex $fmt_obj_list $ind]
   set fmt_name $format::($fmt_obj,for_name)
   if {[info exists ::env(INCH_METRIC)] && $::env(INCH_METRIC) == 1} {
    set ex_list [list Coordinate_IN Coordinate_MM AbsCoord_IN AbsCoord_MM \
    Feed_DPM Feed_FRN Feed_INV Feed_IPM Feed_IPR \
    Feed_MMPM Feed_MMPR]
    if {[lsearch $ex_list $fmt_name] < 0} {
     $fmt_sel insert end $fmt_name
    }
    } else {
    $fmt_sel insert end $fmt_name
   }
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
  set f $Page::($page_obj,middle_frame)
  label $f.blk -text " "
  label $f.lea -text "$gPB(address,leader,Label)" -font $tixOption(italic_font)
  entry $f.lea_val -textvariable "ADDRESSOBJATTR(8)" \
  -cursor hand2 \
  -width 5 -borderwidth 4 \
  -highlightcolor $paOption(focus) \
  -background $paOption(header_bg) \
  -foreground $paOption(seq_bg) \
  -selectbackground $paOption(focus) \
  -selectforeground black
  bind  $f.lea_val <Return> "+UI_PB_addr__ApplyLeader $page_obj "
  UI_PB_addr_CreateLeaderPopup page_obj
  if { $Format_Name == "" } \
  {
   PB_int_RetFormatObjList fmt_obj_list
   set Format_Name $format::([lindex $fmt_obj_list 0],for_name)
  }
  set ADDRESSOBJATTR(1) $Format_Name
  tixLabelFrame $f.fmt -label "$gPB(address,format,Label)"
  set fmt_frm [$f.fmt subwidget frame]
  switch $::tix_version {
   8.4 {
    set fmt_sel [tixComboBox $fmt_frm.sel \
    -dropdown   yes \
    -editable   false \
    -variable   Format_Name \
    -command    "UI_PB_addr_SelectFormat $page_obj" \
    -selectmode immediate \
    -grab       local \
    -options {
     listbox.anchor   w
     listbox.height   4
     slistbox.width   12
     entry.width      12
    }]
    [$fmt_sel subwidget entry] config -readonlybackground $paOption(entry_disabled_bg) \
    -selectbackground lightblue \
    -selectforeground black \
    -cursor "" -state readonly
   }
   4.1 {
    set fmt_sel [tixComboBox $fmt_frm.sel \
    -dropdown   yes \
    -editable   false \
    -variable   Format_Name \
    -command    "UI_PB_addr_SelectFormat $page_obj" \
    -selectmode immediate \
    -grab       local \
    -options {
     listbox.anchor   w
     listbox.height   4
     listbox.width    12
     entry.width      12
    }]
   }
  }
  set fmt_edit [button $fmt_frm.but -text "$gPB(address,format,edit,Label)" \
  -font $tixOption(bold_font) \
  -command "UI_PB_addr_EditFormat $page_obj $fmt_sel"]
  set fmt_new [button $fmt_frm.new \
  -text "$gPB(address,format,new,Label)" \
  -font $tixOption(bold_font) \
  -command "UI_PB_addr_NewFormat $page_obj $fmt_sel"]
  pack $fmt_new  -side left  -padx 5 -pady 5
  pack $fmt_edit -side right -padx 5 -pady 5
  pack $fmt_sel  -side right -pady 5
  if { $ADDRESSOBJATTR(0) == "F" } {
   $fmt_new  config -state disabled
   $fmt_sel  config -state disabled
  }
  [$fmt_sel subwidget entry] config -bg $paOption(entry_disabled_bg) -cursor ""
  global lbx
  set lbx [$fmt_sel subwidget listbox]
  UI_PB_addr_CreateComboAttr page_obj
  tixSetSilent $fmt_sel $ADDRESSOBJATTR(1)
  tixLabelFrame $f.max -label "$gPB(address,max,value,Label)"
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
  set max_err $ADDRESSOBJATTR(5)
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
  $max.err config -value $max_err
  pack $max.val -side top    -fill x -padx 10 -pady 4
  pack $max.err -side bottom -fill x -padx 10 -pady 2
  tixLabelFrame $f.min -label "$gPB(address,min,value,Label)"
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
  set min_err $ADDRESSOBJATTR(7)
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
  $min.err config -value $min_err
  pack $min.val -side top    -fill x -padx 10 -pady 4
  pack $min.err -side bottom -fill x -padx 10 -pady 2
  if 0 {
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
  }
  frame $f.mod
  label $f.mod.label -text "$gPB(address,modality,Label)" -font $tixOption(italic_font)
  tixLabelFrame $f.mod.radio -labelside none
  pack $f.mod.label -side left -padx 11 ;# -padx was 5
  pack $f.mod.radio -side right
  if { ![info exists ADDRESSOBJATTR(2)]  ||  $ADDRESSOBJATTR(2) == "" } {
   set ADDRESSOBJATTR(2) off
  }
  set frm [$f.mod.radio subwidget frame]
  radiobutton $frm.yes -text "$gPB(nav_button,yes,Label)" \
  -variable ADDRESSOBJATTR(2) \
  -value off
  radiobutton $frm.no  -text "$gPB(nav_button,no,Label)" \
  -variable ADDRESSOBJATTR(2) \
  -value always
  pack $frm.yes -side left  -padx 15 -pady 5
  pack $frm.no -side right -padx 15 -pady 5
  label $f.tra -text "$gPB(address,trailer,Label)" -font $tixOption(italic_font)
  entry $f.tra_val -textvariable ADDRESSOBJATTR(9) \
  -cursor hand2 \
  -width 5 -borderwidth 4 \
  -highlightcolor $paOption(focus) \
  -background $paOption(header_bg) \
  -foreground $paOption(seq_bg) \
  -selectbackground $paOption(focus) \
  -selectforeground black
  bind  $f.tra_val <Return> "+UI_PB_addr__ApplyTrailer $page_obj "
  UI_PB_addr_CreateTrailerPopup page_obj
  if 0 { ;# Replace by the call above.
   set menu [menu $f.pop1]
   bind $f.tra_val <1> "focus %W"
   bind $f.tra_val <3> "tk_popup $menu %X %Y"
   set bind_widget $f.tra_val
   set options_list {A B C D E F G H I J K L M N O \
   P Q R S T U V W X Y Z "gPB(address,none_popup,Label)"}
   set callback "UI_PB_addr_SelectTrailer"
   UI_PB_addr_SetPopupOptions page_obj menu options_list callback \
   bind_widget
  }
  set ADDRESSOBJATTR(10) 1
  grid $f.blk            -
  grid $f.lea     -row 1 -column 0 -padx 11 -pady 3 -sticky w ;#<09-24-02 gsl> -padx was 5
  grid $f.lea_val -row 1 -column 1 -padx 5 -pady 3 -sticky nse
  grid $f.fmt            -      -padx 1 -pady 3 -sticky ew
  grid $f.tra     -row 3 -column 0 -padx 11 -pady 3 -sticky w ;#<09-24-02 gsl> -padx was 5
  grid $f.tra_val -row 3 -column 1 -padx 5 -pady 3 -sticky nse
  grid $f.mod            -      -padx 1 -pady 5 -sticky ew
  grid $f.max            -      -padx 1 -pady 3 -sticky ew
  grid $f.min            -      -padx 1 -pady 1 -sticky ew
  global gPB
  set gPB(c_help,$f.lea_val)      "address,leader"
  set gPB(c_help,$fmt_new)      "address,format,new"
  set gPB(c_help,$fmt_edit)      "address,format,edit"
  set gPB(c_help,[$fmt_sel subwidget arrow])    "address,format,select"
  set gPB(c_help,$f.tra_val)      "address,trailer"
  set gPB(c_help,$f.mod)                           "address,modality"
  set gPB(c_help,[$max.val subwidget entry])    "address,max,value"
  set gPB(c_help,[$max.err subwidget menubutton])  "address,max,error_handle"
  set gPB(c_help,[$min.val subwidget entry])    "address,min,value"
  set gPB(c_help,[$min.err subwidget menubutton])  "address,min,error_handle"
 }

#=======================================================================
proc UI_PB_addr_EditFormat { page_obj comb_widget } {
  global Format_Name
  global gPB
  global ADDRESSOBJATTR
  if { $ADDRESSOBJATTR(0) == "F" } {
   return [tk_messageBox -parent [UI_PB_com_AskActiveWindow] -type ok -icon info \
   -message $gPB(msg,edit_feed_fmt)]
  }
  if {[info exists ::env(INCH_METRIC)] && $::env(INCH_METRIC) == 1} {
   if {[string match "Coordinate" $ADDRESSOBJATTR(1)] ||
    [string match "AbsCoord" $ADDRESSOBJATTR(1)]} {
    if [string match "Inch" $gPB(current_unit)] {
     set Temp_Format_Name ${Format_Name}_IN
     } else {
     set Temp_Format_Name ${Format_Name}_MM
    }
    } else {
    set Temp_Format_Name $Format_Name
   }
   } else {
   set Temp_Format_Name $Format_Name
  }
  set canvas_frame $Page::($page_obj,canvas_frame)
  PB_int_RetFmtObjFromName Temp_Format_Name fmt_obj
  format::readvalue $fmt_obj FORMATOBJATTR
  set pname $FORMATOBJATTR(0)
  set new_fmt_page [new Page $pname $pname]
  set win [toplevel $canvas_frame.fmt]
  set toplevel_index [llength $gPB(toplevel_list)]
  set win_index [expr $toplevel_index + 1]
  set gPB(toplevel_disable_$win_index) 1
  UI_PB_com_CreateTransientWindow $win \
  "$gPB(address,format_trans,title,Label) : $FORMATOBJATTR(0)" \
  "500x500+200+200" \
  "" \
  "UI_PB_addr_DisableAddPageWidgets $page_obj" \
  "" \
  "UI_PB_addr_ActivateAddPageWidgets $page_obj $win_index"
  UI_PB_fmt_CreateFmtPage $page_obj $fmt_obj $new_fmt_page $win $comb_widget 0
  UI_PB_com_PositionWindow $win
 }

#=======================================================================
proc  __addr_ConstructFmtPage_cb { page_obj fmt_obj win COMB_WIDGET flag } {
  upvar $COMB_WIDGET comb_widget
  UI_PB_addr_DisableAddPageWidgets $page_obj
  format::readvalue $fmt_obj FORMATOBJATTR
  set pname $FORMATOBJATTR(0)
  set new_fmt_page [new Page $pname $pname]
  UI_PB_fmt_CreateFmtPage $page_obj $fmt_obj $new_fmt_page $win $comb_widget $flag
 }

#=======================================================================
proc UI_PB_addr_NewFormat { page_obj comb_widget } {
  global gPB
  set canvas_frame $Page::($page_obj,canvas_frame)
  set fmt_name "$gPB(User_Def_Fmt)"
  PB_int_CreateNewFormat fmt_name fmt_obj
  format::readvalue $fmt_obj FORMATOBJATTR
  UI_PB_fmt_UpdateFmtArr FORMATOBJATTR $fmt_name
  set win [toplevel $canvas_frame.fmt]
  set toplevel_index [llength $gPB(toplevel_list)]
  set win_index [expr $toplevel_index + 1]
  set gPB(toplevel_disable_$win_index) 1
  format::readvalue $fmt_obj FORMATOBJATTR
  set pname $FORMATOBJATTR(0)
  set new_fmt_page [new Page $pname $pname]
  if 0 {
   UI_PB_com_CreateTransientWindow $win \
   "$gPB(address,format_trans,title,Label) : $FORMATOBJATTR(0)" \
   "500x500+200+200" "" "UI_PB_addr_DisableAddPageWidgets $page_obj" "" \
   "UI_PB_addr_ActivateAddPageWidgets $page_obj $win_index"
  }
  UI_PB_com_CreateTransientWindow $win \
  "$gPB(address,format_trans,title,Label) : $FORMATOBJATTR(0)" \
  "500x500+200+200" \
  "" \
  "UI_PB_addr_DisableAddPageWidgets $page_obj" "" \
  "UI_PB_fmt_NewCancelCallBack $new_fmt_page $win; \
  UI_PB_addr_ActivateAddPageWidgets $page_obj $win_index"
  UI_PB_fmt_CreateFmtPage $page_obj $fmt_obj $new_fmt_page $win $comb_widget 1
  UI_PB_com_PositionWindow $win
 }

#=======================================================================
proc UI_PB_addr_ActivateAddPageWidgets { page_obj win_index } {
  return
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
   set middle_frame $Page::($page_obj,middle_frame)
   set fmt_frm [$middle_frame.fmt subwidget frame]
   if {$::tcl_version == 8.4} {
    [$fmt_frm.sel subwidget entry] config -state readonly
    } else {
    [$fmt_frm.sel subwidget entry] config -state disabled
   }
   if [info exists Page::($page_obj,name_frame)] {
    set name_frm $Page::($page_obj,name_frame)
    if [winfo exists $name_frm.name] {
     global paOption
     [$name_frm.name subwidget label] config -fg $paOption(special_fg)
    }
   }
   set top_frame $Page::($page_obj,top_frame)
   $top_frame.ldr config -state disabled
   $top_frame.fmt config -state disabled
   $top_frame.trl config -state disabled
   if [info exists Page::($page_obj,act_addr_obj)] {
    set add_obj $Page::($page_obj,act_addr_obj)
    __addr_SetActionButtonsSens $page_obj $add_obj
   }
  }
 }

#=======================================================================
proc UI_PB_addr_DisableAddPageWidgets { page_obj } {
  return
  tixDisableAll $Page::($page_obj,page_id)
  if [info exists Page::($page_obj,name_frame)] {
   set name_frm $Page::($page_obj,name_frame)
   if [winfo exists $name_frm.name] {
    global paOption
    [$name_frm.name subwidget label] config -fg $paOption(disabled_fg)
   }
  }
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
  -bg $paOption(title_bg) -relief flat \
  -state disabled -disabledforeground $paOption(title_fg)
  button $top_frame.fmt -text "" -cursor "" \
  -font $tixOption(bold_font) \
  -bg $paOption(title_bg) -relief flat \
  -state disabled -disabledforeground $paOption(title_fg)
  button $top_frame.trl -text "" -cursor "" \
  -font $tixOption(bold_font) \
  -bg $paOption(title_bg) -relief flat \
  -state disabled -disabledforeground $paOption(title_fg)
  grid $top_frame.ldr -row 1 -column 1 -pady 10
  grid $top_frame.fmt -row 1 -column 2 -pady 10
  grid $top_frame.trl -row 1 -column 3 -pady 10
  set forget_flag 0
  $top_frame.ldr configure -activebackground $paOption(title_bg)
  $top_frame.fmt configure -activebackground $paOption(title_bg)
  $top_frame.trl configure -activebackground $paOption(title_bg)
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
  if [info exists Page::($page_obj,act_addr_obj)] \
  {
   set act_addr_obj $Page::($page_obj,act_addr_obj)
   set ADDRESSOBJATTR(1) $Format_Name
   set addr_name $ADDRESSOBJATTR(0)
   if [string match "N" $addr_name] {
    global mom_sys_arr
    set mom_sys_arr(seqnum_max) $ADDRESSOBJATTR(4)
   }
   UI_PB_addr_UpdateAddrAttr ADDRESSOBJATTR $addr_name
   PB_int_AddApplyObject act_addr_obj ADDRESSOBJATTR
  }
 }

#=======================================================================
proc UI_PB_addr_AddressApply { PAGE_OBJ } {
  upvar $PAGE_OBJ page_obj
  if [info exists Page::($page_obj,act_addr_obj)] \
  {
   set act_addr_obj $Page::($page_obj,act_addr_obj)
   array set rest_addressobjattr $Page::($page_obj,rest_addressobjattr)
   set fmt_name $rest_addressobjattr(1)
   PB_int_RetFmtObjFromName fmt_name fmt_obj
   set rest_addressobjattr(1) $format::($fmt_obj,for_name)
   UI_PB_addr_ApplyCurrentAddrData page_obj
   if [info exists Page::($page_obj,act_addr_obj)] {
    unset Page::($page_obj,act_addr_obj)
   }
   if [info exists Page::($page_obj,act_addr_name)] {
    unset Page::($page_obj,act_addr_name)
   }
   address::readvalue $act_addr_obj act_addr_attr
   set act_addr_fmt $act_addr_attr(1)
   format::DeleteFromAddressList $fmt_obj act_addr_obj
   format::AddToAddressList $act_addr_fmt act_addr_obj
  }
 }

#=======================================================================
proc UI_PB_addr_AddDefaultCallBack { page_obj args } {
  global ADDRESSOBJATTR
  set act_addr_obj $Page::($page_obj,act_addr_obj)
  array set def_addr_obj_attr $address::($act_addr_obj,def_value)
  if { $def_addr_obj_attr(1) } \
  {
   set fmt_obj $def_addr_obj_attr(1)
   set def_addr_obj_attr(1) $format::($fmt_obj,for_name)
  } else \
  {
   set fmt_obj ""
   set def_addr_obj_attr(1) ""
  }
  if { [string tolower $def_addr_obj_attr(2)] == "once" } {
   set def_addr_obj_attr(2) "off"
  }
  address::readvalue $act_addr_obj act_addr_attr
  set act_addr_fmt $act_addr_attr(1)
  format::DeleteFromAddressList $act_addr_fmt act_addr_obj
  format::AddToAddressList $fmt_obj act_addr_obj
  set cur_addr_name $def_addr_obj_attr(0)
  UI_PB_addr_UpdateAddrAttr def_addr_obj_attr $cur_addr_name
  UI_PB_addr_SetAddressAttr $page_obj
  UI_PB_addr_SetAddrParams $page_obj
  if { [llength $args] > 0 } \
  {
   global elem_text_var
   set blk_elem [lindex $args 0]
   array set def_blk_elem_attr $block_element::($blk_elem,def_value)
   set elem_text_var $def_blk_elem_attr(1)
   unset def_blk_elem_attr
  }
  UI_PB_addr_SelectFormat $page_obj
 }

#=======================================================================
proc UI_PB_addr_AddRestoreCallBack { page_obj args } {
  set act_addr_obj $Page::($page_obj,act_addr_obj)
  array set rest_addressobjattr $Page::($page_obj,rest_addressobjattr)
  set cur_addr_name $rest_addressobjattr(0)
  address::readvalue $act_addr_obj act_addr_attr
  if { $act_addr_attr(1) } \
  {
   set act_addr_fmt $act_addr_attr(1)
   set act_fmt_name $format::($act_addr_fmt,for_name)
  } else \
  {
   set act_addr_fmt ""
   set act_fmt_name ""
  }
  if { [string compare $act_fmt_name $rest_addressobjattr(1)] } \
  {
   format::DeleteFromAddressList $act_addr_fmt act_addr_obj
   PB_int_RetFmtObjFromName rest_addressobjattr(1) cur_fmt_obj
   format::AddToAddressList $cur_fmt_obj act_addr_obj
  }
  UI_PB_addr_UpdateAddrAttr rest_addressobjattr $cur_addr_name
  UI_PB_addr_SetAddressAttr $page_obj
  UI_PB_addr_SetAddrParams $page_obj
  if { [llength $args] > 0 } \
  {
   global elem_text_var
   set blk_elem [lindex $args 0]
   if [info exists block_element::($blk_elem,rest_value)] \
   {
    if [llength $block_element::($blk_elem,rest_value)] \
    {
     array set rest_blk_elem_attr $block_element::($blk_elem,rest_value)
     set elem_text_var $rest_blk_elem_attr(1)
     unset rest_blk_elem_attr
    } else \
    {
     set elem_text_var ""
    }
   }
  }
 }

#=======================================================================
proc UI_PB_addr_SelectFormat {page_obj args} {
  global ADDRESSOBJATTR
  global add_dis_attr
  global Format_Name
  if [info exists ::auto_call_cmd] {
   return
  }
  if { $Format_Name == "" } { return }
  set ADDRESSOBJATTR(1) $Format_Name
  PB_int_DisplayFormatValue ADDRESSOBJATTR(1) ADDRESSOBJATTR(0) \
  add_dis_attr(1) fmt_disp
  set add_dis_attr(1) $fmt_disp
  UI_PB_addr__ConfigureAddrFormat page_obj
  UI_PB_addr_SetEditButtonStatus $page_obj $ADDRESSOBJATTR(1)
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
    $menu1 add command -label [set $ELEMENT] \
    -command "$callback $page_obj $bind_widget \"\""
   } else \
   {
    if {$count == 1} \
    {
     $menu1 add command -label $ELEMENT -columnbreak 1 \
     -command "$callback $page_obj $bind_widget $ELEMENT"
    } else \
    {
     $menu1 add command -label $ELEMENT \
     -command "$callback $page_obj $bind_widget $ELEMENT"
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
proc UI_PB_addr_SelectItem { page_obj args } {
  global gPB
  global gPB_address_name
  global ADDRESSOBJATTR
  set tree $Page::($page_obj,tree)
  set HLIST [$tree subwidget hlist]
  if { [info exists Page::($page_obj,rename_index)] } \
  {
   if { [UI_PB_addr_UpdateAddrNameEntry $page_obj \
    $Page::($page_obj,rename_index)] == "UI_PB_ERROR" } {
    return
   }
  }
  set ent [lindex $args 0]
  if { $ent == "" } \
  {
   set Page::($page_obj,selected_index) -1
   set ent [$HLIST info selection]
   } elseif { [string match "0" $ent] } \
  {
   $HLIST selection clear
   $HLIST anchor clear
   $HLIST selection set 0.0
   $HLIST anchor set 0.0
   set Page::($page_obj,selected_index) -1
   set ent 0.0
  }
  PB_int_RetAddressObjList addr_obj_list
  if [info exists Page::($page_obj,selected_index)] \
  {
   if [string match "$ent" $Page::($page_obj,selected_index)] \
   {
    return [UI_PB_addr_EditAddressName $page_obj $ent]
   }
  }
  if 0 {
   set index [string range $ent 2 end]
   if {[string compare $index ""] == 0}\
   {
    set index 0
    $HLIST selection clear
    $HLIST anchor clear
    $HLIST selection set 0.0
    $HLIST anchor set 0.0
   }
   set addr_obj [lindex $addr_obj_list $index]
   if [info exists Page::($page_obj,act_addr_obj)] \
   {
    if { $addr_obj == $Page::($page_obj,act_addr_obj) } \
    {
     return
    }
   }
   } else {
   set addr_obj [lindex $addr_obj_list [string range $ent 2 end]]
  }
  if 0 {
   if { [info exists Page::($page_obj,act_addr_obj)]} \
   {
    puts "Update previous address data"
    set active_add $Page::($page_obj,act_addr_obj)
    set act_index [lsearch $addr_obj_list $active_add]
    set ret_code [UI_PB_addr_CheckAddressName gPB_address_name active_add]
    if { $ret_code } \
    {
     return [ UI_PB_addr_DenyAddrRename $ret_code $page_obj \
     $Page::($page_obj,rename_index) ]
    } else \
    {
     puts "Check Address Name OK"
     if { $Page::($page_obj,double_click_flag) } \
     {
      set style $gPB(font_style_normal)
      set file   [tix getimage pb_address]
      $HLIST delete entry 0.$act_index
      $HLIST add 0.$act_index -itemtype imagetext \
      -text $gPB_address_name -image $file -style $style \
      -at $act_index
      set Page::($page_obj,double_click_flag) 0
      UI_PB_addr_UpdateAddrNameData page_obj
      unset Page::($page_obj,rename_index)
     }
    }
   }
  }
  if [string match "N" $gPB_address_name] {
   global mom_sys_arr
   set tmp $mom_sys_arr(seqnum_max)
   set mom_sys_arr(seqnum_max) $ADDRESSOBJATTR(4)
   set fmt $ADDRESSOBJATTR(1)
   set max [UI_PB_ads_ExceedMaxSeqNum $fmt]
   set mom_sys_arr(seqnum_max) $tmp
   if $max {
    if { $Page::($page_obj,selected_index) < 0 } {
     set Page::($page_obj,selected_index) $ent
     set Page::($page_obj,act_addr_obj) $addr_obj
    }
    $HLIST selection clear
    $HLIST anchor clear
    $HLIST selection set $Page::($page_obj,selected_index)
    $HLIST anchor set $Page::($page_obj,selected_index)
    tk_messageBox -parent [UI_PB_com_AskActiveWindow] \
    -type ok -icon error \
    -message "$gPB(msg,add_max1) N $gPB(msg,add_max2) $max."
    return 0
   }
  }
  set Page::($page_obj,selected_index) $ent
  UI_PB_addr_AddressApply page_obj
  UI_PB_addr_AddDisplayParams $page_obj [string range $ent 2 end]
  UI_PB_addr_SetAddrParams $page_obj
  $HLIST selection clear
  $HLIST anchor clear
  $HLIST selection set $ent
  $HLIST anchor set $ent
  __addr_SetActionButtonsSens $page_obj $addr_obj
  set f $Page::($page_obj,middle_frame)
  set fmt [$f.fmt subwidget frame]
  if { $ADDRESSOBJATTR(0) == "F" } {
   $fmt.new  config -state disabled
   $fmt.sel  config -state disabled
   } else {
   $fmt.new  config -state normal
   $fmt.sel  config -state normal
  }
 }

#=======================================================================
proc __addr_SetActionButtonsSens { page_obj add_obj } {
  if { ![ info exists Page::($page_obj,left_pane_id) ] } { return }
  set left_pane_id $Page::($page_obj,left_pane_id)
  $left_pane_id.f.pas config -state disabled
  if { [info exists Page::($page_obj,buff_obj_attr)] } \
  {
   $left_pane_id.f.pas config -state normal
  }
  if [info exists add_obj] \
  {
   if { $address::($add_obj,add_name) == "N" || \
   $address::($add_obj,add_name) == "Text" } \
   {
    $left_pane_id.f.pas config -state disabled
   }
   address::readMseqAttr $add_obj mseq_attr
   if { $mseq_attr(4) == 1} \
   {
    $left_pane_id.f.del config -state normal
   } else \
   {
    $left_pane_id.f.del config -state disabled
   }
  }
 }

#=======================================================================
proc UI_PB_addr_AddDisplayParams { page_obj index} {
  global ADDRESSOBJATTR
  global gPB_address_name
  PB_int_RetAddressObjList addr_obj_list
  if {$index >= 0} \
  {
   set addr_obj [lindex $addr_obj_list $index]
   set Page::($page_obj,act_addr_obj) $addr_obj
   set Page::($page_obj,act_addr_name) $address::($addr_obj,add_name)
   UI_PB_addr_SetAddressAttr $page_obj
   if { [info exists Page::($page_obj,rest_addressobjattr)] } \
   {
    unset Page::($page_obj,rest_addressobjattr)
   }
   set Page::($page_obj,rest_addressobjattr) [array get ADDRESSOBJATTR]
   set gPB_address_name $ADDRESSOBJATTR(0)
  }
 }

#=======================================================================
proc UI_PB_addr_SetAddrParams { page_obj } {
  global ADDRESSOBJATTR
  global add_dis_attr
  global mom_sys_arr
  set middle_frame $Page::($page_obj,middle_frame)
  UI_PB_addr_SetCheckButtonState $middle_frame.min_val ADDRESSOBJATTR(7)
  UI_PB_addr_SetCheckButtonState $middle_frame.max_val ADDRESSOBJATTR(5)
  UI_PB_addr__UpdateEntry $middle_frame.lea_val $ADDRESSOBJATTR(8)
  UI_PB_addr__UpdateEntry $middle_frame.tra_val $ADDRESSOBJATTR(9)
  set add_obj $Page::($page_obj,act_addr_obj)
  set addr_name $address::($add_obj,add_name)
  set addr_glob_var $address::($add_obj,rep_mom_var)
  PB_com_MapMOMVariable mom_sys_arr add_obj addr_glob_var blk_elem_text
  PB_int_GetElemDisplayAttr addr_name blk_elem_text add_dis_attr
  set add_dis_attr(0) $ADDRESSOBJATTR(8)
  set add_dis_attr(2) $ADDRESSOBJATTR(9)
  UI_PB_addr__ConfigureAddrAttributes page_obj
  UI_PB_addr_SetEditButtonStatus $page_obj $ADDRESSOBJATTR(1)
 }

#=======================================================================
proc UI_PB_addr_SetEditButtonStatus { page_obj fmt_name } {
  set middle_frame $Page::($page_obj,middle_frame)
  set fmt_frm [$middle_frame.fmt subwidget frame]
  if { $fmt_name == "" } \
  {
   $fmt_frm.but config -state disabled
  } else \
  {
   $fmt_frm.but config -state normal
  }
 }

#=======================================================================
proc UI_PB_addr_SetAddressAttr { page_obj } {
  global gpb_addr_var
  global ADDRESSOBJATTR
  global Format_Name
  set add_name $Page::($page_obj,act_addr_name)
  set ADDRESSOBJATTR(0) $gpb_addr_var($add_name,name)
  set ADDRESSOBJATTR(1) $gpb_addr_var($add_name,fmt_name)
  if [string match "N" $add_name] {
   global mom_sys_arr
   if [info exists mom_sys_arr(seqnum_max)] {
    set gpb_addr_var($add_name,add_max) $mom_sys_arr(seqnum_max)
   }
  }
  set ADDRESSOBJATTR(2) $gpb_addr_var($add_name,modal)
  if 0 {
   if { [string tolower $gpb_addr_var($add_name,modal)] == "always" } {
    set ADDRESSOBJATTR(2) "NO"
    } else {
    set ADDRESSOBJATTR(2) "YES"
   }
  }
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
  if 0 {
   set force [string tolower $temp_addobjattr(2)]
   switch $force {
    "YES" {
     set gpb_addr_var($add_name,modal) "off"
    }
    "NO"  {
     set gpb_addr_var($add_name,modal) "always"
    }
    default {
     set gpb_addr_var($add_name,modal) $temp_addobjattr(2)
    }
   }
  }
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
  set index [string range $ent 2 end]
  if {[string compare $index ""] == 0} \
  {
   set index 0
  }
  global post_object
  if { [info exists Post::($post_object,mseq_visited)] && \
  $Post::($post_object,mseq_visited) } \
  {
   PB_adr_SyncAddrObjListWithMseq
   set Post::($post_object,mseq_visited) 0
  }
  UI_PB_addr_DisplayNameList addr_page_obj index
  UI_PB_addr_SelectItem $addr_page_obj
  UI_PB_addr_CreateComboAttr addr_page_obj
 }

#=======================================================================
proc UI_PB_addr_CreateAddressPage { win add_obj NEW_ADD_PAGE addr_mode } {
  upvar $NEW_ADD_PAGE new_add_page
  global ADDRESSOBJATTR
  global Format_Name
  global gPB_address_name
  global paOption
  global add_dis_attr
  if ![string compare $::tix_version 8.4] {
   set ::gPB(scrollbar_flag) null
  }
  set add_dis_attr(0) 0
  set add_dis_attr(1) 0
  set add_dis_attr(2) 0
  address::readvalue $add_obj ADDRESSOBJATTR
  set ::auto_call_cmd 0
  if { $ADDRESSOBJATTR(1) } \
  {
   format::readvalue $ADDRESSOBJATTR(1) fmt_obj_attr
   set ADDRESSOBJATTR(1) $fmt_obj_attr(0)
   set Format_Name $ADDRESSOBJATTR(1)
  } else \
  {
   set ADDRESSOBJATTR(1) ""
   set Format_Name ""
  }
  set pname $ADDRESSOBJATTR(0)
  set gPB_address_name $ADDRESSOBJATTR(0)
  set new_add_page [new Page $pname $pname]
  set Page::($new_add_page,page_id) $win
  set Page::($new_add_page,canvas_frame) $win
  set Page::($new_add_page,act_addr_obj) $add_obj
  set Page::($new_add_page,act_addr_name) $ADDRESSOBJATTR(0)
  set Page::($new_add_page,rest_addressobjattr) [array get ADDRESSOBJATTR]
  __CreateAddressPageParams new_add_page $addr_mode
  unset ::auto_call_cmd
 }

#=======================================================================
proc __CreateAddressPageParams { ADD_PAGE_OBJ entry_flag} {
  upvar $ADD_PAGE_OBJ add_page_obj
  UI_PB_addr_CreateAddrFrames add_page_obj
  if { $entry_flag } \
  {
   UI_PB_com_CreateNameEntry $add_page_obj "address"
  } else \
  {
   pack forget $Page::($add_page_obj,name_frame)
  }
  UI_PB_addr_CreateLeadFmtTrailButtons add_page_obj
  UI_PB_addr_CreateMiddleFrameParam add_page_obj
  if {$::tix_version == 8.4} {
   if [string compare $::gPB(scrollbar_flag) null] {
    set p1 [winfo parent $Page::($add_page_obj,middle_frame)]
    UI_PB_mthd_WheelForFrame [winfo parent $p1]
   }
  }
  UI_PB_addr_SetAddrParams $add_page_obj
 }

#=======================================================================
proc UI_PB_add_CheckSpecialCharsInExpr { exp for_name } {
  set ret_flag 0
  PB_int_RetFmtObjFromName for_name fmt_obj
  if { $format::($fmt_obj,for_dtype) == "Numeral" } \
  {
   if { [string first "\!" $exp] >= 0  || \
    [string first "\"" $exp] >= 0  || \
    [string first "\#" $exp] >= 0  || \
    [string first "\&" $exp] >= 0  || \
    [string first "\'" $exp] >= 0  || \
    [string first "\." $exp] >= 0  || \
    [string first "\;" $exp] >= 0  || \
    [string first "\<" $exp] >= 0  || \
    [string first "\=" $exp] >= 0  || \
    [string first "\>" $exp] >= 0  || \
    [string first "\?" $exp] >= 0  || \
    [string first "\@" $exp] >= 0  || \
    [string first "\[" $exp] >= 0  || \
    [string first "\\" $exp] >= 0  || \
    [string first "\]" $exp] >= 0  || \
    [string first "\^" $exp] >= 0  || \
    [string first "\`" $exp] >= 0  || \
    [string first "\|" $exp] >= 0  || \
   [string first "\~" $exp] >= 0   } \
   {
    set ret_flag 1
   }
  }
  return $ret_flag
 }

#=======================================================================
proc UI_PB_add_EditOkCallBack { blk_page_obj add_page_obj win blk_elem_obj } {
  global elem_text_var
  global gPB
  global Format_Name
  if [ UI_PB_add_ValidateExp $elem_text_var $Format_Name ] {
   return
  }
  set block_element::($blk_elem_obj,elem_mom_variable) "$elem_text_var"
  set add_obj      $block_element::($blk_elem_obj,elem_add_obj)
  set add_name     $address::($add_obj,add_name)
  PB_blk_RetWordDescArr add_name elem_word_desc elem_text_var
  set block_element::($blk_elem_obj,elem_desc) "$elem_word_desc"
  if [llength $block_element::($blk_elem_obj,rest_value)] \
  {
   array set rest_blk_elem_attr $block_element::($blk_elem_obj,rest_value)
  }
  set rest_blk_elem_attr(1) "$elem_text_var"
  set rest_blk_elem_attr(3) "$elem_word_desc"
  set block_element::($blk_elem_obj,rest_value) [array get rest_blk_elem_attr]
  unset rest_blk_elem_attr
  UI_PB_addr_ApplyCurrentAddrData add_page_obj
  set add_obj $block_element::($blk_elem_obj,elem_add_obj)
  set base_addr $address::($add_obj,add_name)
  UI_PB_blk_ReplaceIcon blk_page_obj $base_addr $blk_elem_obj
  UI_PB_blk_ConfigureLeader blk_page_obj blk_elem_obj
  PB_com_DeleteObject $add_page_obj
  destroy $win
 }

#=======================================================================
proc UI_PB_add_ValidateExp { exp for_name } {
  global gPB
  PB_int_RetFmtObjFromName for_name fmt_obj
  if { $exp == "" } \
  {
   tk_messageBox -parent [UI_PB_com_AskActiveWindow] -type ok -icon error \
   -message "$gPB(address,exp,msg)"
   return 1
  }
  if { $format::($fmt_obj,for_dtype) == "Numeral" } \
  {
   set tmp_exp $exp
   set tmp_exp [string trim $tmp_exp]
   if { $tmp_exp == "" && $exp != "" } \
   {
    tk_messageBox -parent [UI_PB_com_AskActiveWindow] -type ok -icon error \
    -message "$gPB(address,exp,space_only)"
    return 1
   }
  }
  if { ![UI_PB_cmd_ValidateExpOK "Word Expression" $exp] } {
   return 1
  }
  if { $format::($fmt_obj,for_dtype) == "Numeral" } \
  {
   if { [ __add_ValidateNumericExp $exp ] } \
   {
    return 1
   }
  }
  if 0 {
   if { [ UI_PB_add_CheckSpecialCharsInExpr $exp $for_name ] } \
   {
    tk_messageBox -parent [UI_PB_com_AskActiveWindow] -type ok -icon error \
    -message "$gPB(address,exp,spec_char_msg)"
    return 1
   }
  }
  return 0
 }

#=======================================================================
proc __add_ValidateNumericExp { exp } {
  set ret_code 0
  if [ catch { eval expr $exp } res ] \
  {
   if { ![string match "*no such variable*" $res] } \
   {
    tk_messageBox -parent [UI_PB_com_AskActiveWindow] -type ok -icon error \
    -message "$res"
    set ret_code 1
   }
  }
  return $ret_code
 }

#=======================================================================
proc UI_PB_add_EditCancelCallBack { add_page_obj win args} {
  if { [llength $args] && [PB_com_HasObjectExisted [lindex $args 0]] } {
   set blk_elem [lindex $args 0]
   set block_element::($blk_elem,rest_value) $block_element::($blk_elem,rest_blk_value)
  }
  PB_com_DeleteObject $add_page_obj
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
  PB_com_DeleteObject $add_page_obj
 }

#=======================================================================
proc UI_PB_add_NewEvtCancelCallBack { blk_page_obj event_obj evt_elem_obj \
  new_add_page win blk_elem_obj } {
  set add_obj $block_element::($blk_elem_obj,elem_add_obj)
  PB_int_RemoveAddObjFromList add_obj
  set Page::($blk_page_obj,source_blk_elem_obj) $blk_elem_obj
  set Page::($blk_page_obj,source_evt_elem_obj) $evt_elem_obj
  destroy $win
  PB_com_DeleteObject $new_add_page
  UI_PB_tpth_PutBlockElemTrash blk_page_obj event_obj
  set Page::($blk_page_obj,source_blk_elem_obj) 0
  set Page::($blk_page_obj,source_evt_elem_obj) 0
 }

#=======================================================================
proc UI_PB_add_NewOkCallBack { blk_page_obj add_page_obj win blk_elem_obj \
  page_name } {
  global elem_text_var
  global ADDRESSOBJATTR
  global gPB_address_name
  global gPB
  set addr_obj $block_element::($blk_elem_obj,elem_add_obj)
  set ret_code [UI_PB_addr_CheckAddressName gPB_address_name addr_obj]
  if { $ret_code } \
  {
   return [ UI_PB_addr_DenyAddrRename $ret_code]
  }
  set elem_text_var [PB_output_EscapeSpecialControlChar $elem_text_var]
  global Format_Name
  if [ UI_PB_add_ValidateExp $elem_text_var $Format_Name ] {
   return
  }
  set ADDRESSOBJATTR(0) $gPB_address_name
  set fmt_name $ADDRESSOBJATTR(1)
  PB_int_RetFmtObjFromName fmt_name fmt_obj
  set ADDRESSOBJATTR(1) $fmt_obj
  array set def_add_attr $address::($addr_obj,def_value)
  format::DeleteFromAddressList $def_add_attr(1) addr_obj
  address::DefaultValue $addr_obj ADDRESSOBJATTR
  set ADDRESSOBJATTR(1) $fmt_name
  UI_PB_addr_ApplyCurrentAddrData add_page_obj
  PB_int_GetWordVarDesc WordDescArray
  set block_element::($blk_elem_obj,elem_mom_variable) "$elem_text_var"
  if [llength $block_element::($blk_elem_obj,rest_value)] \
  {
   array set rest_blk_elem_attr $block_element::($blk_elem_obj,rest_value)
  }
  set rest_blk_elem_attr(1) "$elem_text_var"
  set block_element::($blk_elem_obj,rest_value) [array get rest_blk_elem_attr]
  unset rest_blk_elem_attr
  set base_addr $address::($addr_obj,add_name)
  set WordDescArray($base_addr) ""
  PB_int_UpdateAddVariablesAttr WordDescArray base_addr
  UI_PB_blk_ReplaceIcon blk_page_obj $base_addr $blk_elem_obj
  UI_PB_blk_ConfigureLeader blk_page_obj blk_elem_obj
  UI_PB_blk_CreateMenuOptions blk_page_obj $page_name
  set gPB(NEW_OBJ_OK) 1
  destroy $win
  PB_com_DeleteObject $add_page_obj
 }
