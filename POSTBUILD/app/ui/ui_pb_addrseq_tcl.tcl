#0

#=======================================================================
proc UI_PB_ProgTpth_WordSeq {book_id mseq_page} {
  global paOption
  set Page::($mseq_page,page_id) [$book_id subwidget \
  $Page::($mseq_page,page_name)]
  UI_PB_mseq_SetPageAttributes mseq_page
  UI_PB_mseq_CreateMastSeqCanvas mseq_page
  set label_list {"gPB(nav_button,default,Label)" \
  "gPB(nav_button,restore,Label)"}
  set cb_arr(gPB(nav_button,default,Label)) \
  "UI_PB_mseq_DefaultCallBack $mseq_page"
  set cb_arr(gPB(nav_button,restore,Label)) \
  "UI_PB_mseq_RestoreCallBack $mseq_page"
  set bot_frm $Page::($mseq_page,box)
  UI_PB_com_CreateButtonBox $bot_frm label_list cb_arr
  set bot_canvas $Page::($mseq_page,bot_canvas)
  set menu [menu $bot_canvas.pop]
  $menu config -bg $paOption(popup) -tearoff 0
  set Page::($mseq_page,menu) $menu
  bind $bot_canvas <3> "UI_PB_mseq_PopupSetOptions $mseq_page %X %Y %x %y"
 }

#=======================================================================
proc UI_PB_mseq_CreateMastSeqElements { PAGE_OBJ } {
  upvar $PAGE_OBJ page_obj
  PB_int_RetAddressObjList add_obj_list
  foreach addr_obj $add_obj_list \
  {
   address::RestoreMseqAttr $addr_obj
  }
  UI_PB_mseq_SortAddresses add_obj_list
  UI_PB_mseq_CreateComponents page_obj add_obj_list
 }

#=======================================================================
proc UI_PB_mseq_SetPageAttributes { PAGE_OBJ } {
  upvar $PAGE_OBJ page_obj
  set Page::($page_obj,no_rowelem) 12
  set Page::($page_obj,h_cell)     30       ;# cell height
  set Page::($page_obj,w_cell)     52       ;# cell width
  set Page::($page_obj,w_divi)     6        ;# divider width
  set Page::($page_obj,x_orig)     100      ;# upper-left corner of 1st cell
  set Page::($page_obj,y_orig)     80
  set Page::($page_obj,row_dist)   80
  set Page::($page_obj,in_focus_cell_obj) 0
  set Page::($page_obj,out_focus_cell_obj) 0
  set Page::($page_obj,in_focus_divi_obj) 0
  set Page::($page_obj,out_focus_divi_obj) 0
  set Page::($page_obj,drag_sensitivity) 5
  set Page::($page_obj,x_icon) 0
  set Page::($page_obj,cell_color) 0
  set Page::($page_obj,divi_color) 0
  set Page::($page_obj,undo_flag) 0
  set Page::($page_obj,being_dragged) 0
  set Page::($page_obj,source_elem_obj) 0
  set Page::($page_obj,add_act) 0
 }

#=======================================================================
proc UI_PB_mseq_CreateMastSeqCanvas { PAGE_OBJ } {
  upvar $PAGE_OBJ page_obj
  global paOption
  global gPB
  set page_id $Page::($page_obj,page_id)
  set top_canvas_dim(0) 80 ;# was 100 <gsl>
  set top_canvas_dim(1) 100
  set bot_canvas_dim(0) 1000
  set bot_canvas_dim(1) 1000
  set fy [frame $page_id.f]
  pack $fy -fill both -expand yes
  set canvas_frame [frame $fy.f]
  pack $canvas_frame -expand yes -fill both
  set Page::($page_obj,canvas_frame) $canvas_frame
  Page::CreateCanvas $page_obj top_canvas_dim bot_canvas_dim
  pack config $Page::($page_obj,bot_canvas) -padx 0
  pack config $Page::($page_obj,box)        -padx 0 -pady 0
  pack config $Page::($page_obj,canvas_frame).frame -pady 3
  set top_canvas  $Page::($page_obj,top_canvas)
  set frm1 [frame $top_canvas.fm1]
  set frm2 [frame $top_canvas.fm2]
  $top_canvas create window 130 20 -window $frm1 -anchor nw
  $top_canvas create window 530 20 -window $frm2 -anchor nw
  if 0 {
   pack $frm1 $frm2 -side left -padx 130 -pady 20 -fill both -expand yes
  }
  label $frm1.bit1 -height 1 -width 2 -background $paOption(sunken_bg) -relief sunken -bd 2
  label $frm1.l1 -text "$gPB(wseq,active_out,Label)"
  label $frm2.l2 -text "$gPB(wseq,suppressed_out,Label)"
  label $frm2.bit2 -height 1 -width 2 -background $paOption(raised_bg) -relief raised -bd 2
  pack $frm1.l1 $frm1.bit1 -side right -padx 4 -pady 8
  pack $frm2.bit2 $frm2.l2 -side left -padx 4 -pady 8
 }

#=======================================================================
proc UI_PB_mseq_PopupSetOptions { page_obj X Y x y } {
  global gPB
  if { ![info exists Page::($page_obj,popup_flag)] } \
  {
   set Page::($page_obj,popup_flag) 0
  }
  set popup_flag $Page::($page_obj,popup_flag)
  set menu $Page::($page_obj,menu)
  set bot_canvas $Page::($page_obj,bot_canvas)
  if { $popup_flag == 0 } \
  {
   $menu delete 0 end
   $menu add command -label "$gPB(wseq,popup_new,Label)" -state normal \
   -command "UI_PB_mseq_NewAddress $page_obj 0 0"
   $menu add sep
   if { $Page::($page_obj,undo_flag) } \
   {
    $menu add command -label "$gPB(wseq,popup_undo,Label)" -state normal \
    -command "UI_PB_mseq_UndoMseqPage $page_obj"
   } else \
   {
    $menu add command -label "$gPB(wseq,popup_undo,Label)" -state disabled
   }
   $menu add sep
   $menu add command -label "$gPB(wseq,popup_all,Label)" -state normal \
   -command "UI_PB_mseq_ActivateAllIcons $page_obj"
   } else { ;# On element
   $menu delete 0 end
   set xx [$bot_canvas canvasx $x]
   set yy [$bot_canvas canvasy $y]
   UI_PB_mseq_GetBlkElemObjFromCursorPos page_obj add_obj "rect_dim" $xx $yy
   $menu add command -label "$gPB(wseq,popup_new,Label)"  -state normal \
   -command "UI_PB_mseq_NewAddress $page_obj 1 $add_obj"
   if { ![PB_com_object_is_external $add_obj] } {
    $menu add command -label "$gPB(wseq,popup_edit,Label)" -state normal \
    -command "UI_PB_mseq_EditAddress $page_obj $add_obj"
    } else {
    $menu add command -label "$gPB(block,view_popup,Label)" -state normal \
    -command "UI_PB_mseq_EditAddress $page_obj $add_obj"
   }
   $menu add sep
   address::readMseqAttr $add_obj mseq_attr
   if { $mseq_attr(4) == 1 && ![PB_com_object_is_external $add_obj] } \
   {
    $menu add command -label "$gPB(wseq,popup_delete,Label)" \
    -command "UI_PB_mseq_DeleteAddress $page_obj $add_obj"
   } else \
   {
    $menu add command -label "$gPB(wseq,popup_delete,Label)" -command "" -state disabled
   }
   set Page::($page_obj,popup_flag) 0
  }
  global gPB_help_tips
  if { $gPB_help_tips(state) } \
  {
   PB_cancel_balloon
  }
  PB_disable_balloon $bot_canvas
  global gPB_use_balloons
  set gPB_use_balloons 0
  update
  tk_popup $menu $X $Y
 }

#=======================================================================
proc UI_PB_mseq_PopupMenu { page_obj } {
  set Page::($page_obj,popup_flag) 1
 }

#=======================================================================
proc UI_PB_mseq_DisableMseqPageWidgets { page_obj } {
  set bot_canvas $Page::($page_obj,bot_canvas)
  UI_PB_mseq_UnBindProcs page_obj
  bind $bot_canvas <3> ""
  $bot_canvas config -cursor ""
 }

#=======================================================================
proc UI_PB_mseq_ActivateMseqPageWidgets { page_obj win_index } {
  global gPB
  if { $gPB(toplevel_disable_$win_index) } \
  {
   set bot_canvas $Page::($page_obj,bot_canvas)
   UI_PB_mseq_BindProcs page_obj
   bind $bot_canvas <3> "UI_PB_mseq_PopupSetOptions $page_obj %X %Y %x %y"
   set gPB(toplevel_disable_$win_index) 0
  }
 }

#=======================================================================
proc UI_PB_mseq_DeleteAddress { mseq_page_obj add_obj } {
  global gPB
  if { $address::($add_obj,blk_elem_list) != "" } \
  {
   set address_name $address::($add_obj,add_name)
   tk_messageBox  -parent [UI_PB_com_AskActiveWindow] -type ok -icon error \
   -title $gPB(msg,error,title) \
   -message "Address \"$address_name\" is referenced. \
   It cannot be deleted."
  } else \
  {
   UI_PB_mseq_DeleteMastSeqElems mseq_page_obj
   PB_int_RemoveAddObjFromList add_obj
   PB_int_RetAddressObjList add_obj_list
   UI_PB_mseq_SortAddresses add_obj_list
   UI_PB_mseq_CreateComponents mseq_page_obj add_obj_list
  }
 }

#=======================================================================
proc UI_PB_mseq_NewAddress { mseq_page_obj elem_flag add_obj } {
  global gPB
  set mseq_addr_list $Page::($mseq_page_obj,mseq_addr_list)
  if { $elem_flag } \
  {
   if { $add_obj } \
   {
    set add_index [lsearch $mseq_addr_list $add_obj]
    set new_add_index [expr $add_index + 1]
   } else \
   {
    set new_add_index [llength $mseq_addr_list]
   }
  } else \
  {
   set new_add_index [llength $mseq_addr_list]
  }
  UI_PB_mseq_DeleteMastSeqElems mseq_page_obj
  set sel_base_addr "$gPB(User_Def_Add)"
  PB_int_CreateNewAddress sel_base_addr new_add_obj new_add_index
  set mseq_addr_list [linsert $mseq_addr_list $new_add_index $new_add_obj]
  UI_PB_mseq_CreateComponents mseq_page_obj mseq_addr_list
  address::readvalue $new_add_obj ADDRESSOBJATTR
  set add_name [string tolower $ADDRESSOBJATTR(0)]
  set canvas_frame $Page::($mseq_page_obj,canvas_frame)
  set win [toplevel $canvas_frame.add]
  set toplevel_index [llength $gPB(toplevel_list)]
  set win_index [expr $toplevel_index + 1]
  set gPB(toplevel_disable_$win_index) 1
  UI_PB_com_CreateTransientWindow $win \
  "$gPB(wseq,transient_win,Label) : $ADDRESSOBJATTR(0)" \
  "500x600+100+200" "" "UI_PB_mseq_DisableMseqPageWidgets $mseq_page_obj" "" \
  "UI_PB_mseq_ActivateMseqPageWidgets $mseq_page_obj $win_index"
  UI_PB_addr_CreateAddressPage $win $new_add_obj new_add_page 1
  set bot_frame $Page::($new_add_page,bottom_frame)
  set cb_arr(gPB(nav_button,default,Label)) \
  "UI_PB_addr_AddDefaultCallBack $new_add_page"
  set cb_arr(gPB(nav_button,restore,Label)) \
  "UI_PB_addr_AddRestoreCallBack $new_add_page"
  set cb_arr(gPB(nav_button,cancel,Label)) \
  "UI_PB_mseq_NewMseqCancelCallBack $mseq_page_obj \
  $new_add_page $win $new_add_obj"
  set cb_arr(gPB(nav_button,ok,Label))  \
  "UI_PB_mseq_NewMseqOkCallBack $mseq_page_obj \
  $new_add_page $win $new_add_obj"
  UI_PB_com_CreateActionElems $bot_frame cb_arr $win
  wm protocol $win WM_DELETE_WINDOW [list UI_PB_mseq_NewMseqCancelCallBack $mseq_page_obj \
  $new_add_page $win $new_add_obj]
  UI_PB_com_PositionWindow $win
 }

#=======================================================================
proc UI_PB_mseq_NewMseqCancelCallBack { mseq_page_obj add_page_obj win \
  add_obj } {
  set mseq_addr_list $Page::($mseq_page_obj,mseq_addr_list)
  UI_PB_mseq_DeleteMastSeqElems mseq_page_obj
  PB_int_RemoveAddObjFromList add_obj
  destroy $win
  PB_com_DeleteObject $add_page_obj
  set index [lsearch $mseq_addr_list $add_obj]
  if { $index != -1 } \
  {
   set mseq_addr_list [lreplace $mseq_addr_list $index $index]
  }
  UI_PB_mseq_CreateComponents mseq_page_obj mseq_addr_list
 }

#=======================================================================
proc UI_PB_mseq_NewMseqOkCallBack { mseq_page_obj new_add_page win \
  add_obj } {
  global ADDRESSOBJATTR
  global gPB_address_name
  global gPB
  if { [UI_PB_addr_CheckAddressName gPB_address_name add_obj] } \
  {
   return [ UI_PB_addr_DenyAddrRename ]
   } elseif { $ADDRESSOBJATTR(1) == "" } \
  {
   tk_messageBox -parent [UI_PB_com_AskActiveWindow] -type ok -icon error \
   -title $gPB(msg,error,title) \
   -message "Format has not been selected for the address."
   return
  }
  set ADDRESSOBJATTR(0) $gPB_address_name
  set fmt_name $ADDRESSOBJATTR(1)
  PB_int_RetFmtObjFromName fmt_name fmt_obj
  set ADDRESSOBJATTR(1) $fmt_obj
  array set def_add_attr $address::($add_obj,def_value)
  format::DeleteFromAddressList $def_add_attr(1) add_obj
  address::DefaultValue $add_obj ADDRESSOBJATTR
  set ADDRESSOBJATTR(1) $fmt_name
  __MseqEditOkCallBack $mseq_page_obj $new_add_page $win $add_obj
  PB_int_GetWordVarDesc WordDescArray
  set base_addr $address::($add_obj,add_name)
  set WordDescArray($base_addr) ""
  PB_int_UpdateAddVariablesAttr WordDescArray base_addr
  address::RestoreMseqAttr $add_obj
 }

#=======================================================================
proc __MseqEditOkCallBack { mseq_page_obj add_page_obj win addr_obj } {
  global paOption
  set bot_canvas $Page::($mseq_page_obj,bot_canvas)
  UI_PB_addr_ApplyCurrentAddrData add_page_obj
  $bot_canvas delete $address::($addr_obj,image_id)
  address::readMseqAttr $addr_obj addr_mseq_attr
  UI_PB_com_RetImageAppdText addr_obj addr_mseq_attr(0) \
  temp_image_name addr_app_text
  if { $addr_mseq_attr(4) == 1 } \
  {
   set addr_mseq_attr(2) ($address::($addr_obj,add_name))
   address::SetMseqAttr $addr_obj addr_mseq_attr
  }
  set xc $address::($addr_obj,xc)
  set yc $address::($addr_obj,yc)
  set image_id [UI_PB_blk_CreateIcon $bot_canvas $temp_image_name \
  $addr_app_text]
  set icon_id [$bot_canvas create image  $xc $yc -image $image_id \
  -tag movable]
  set address::($addr_obj,image_id) $icon_id
  set address::($addr_obj,icon_id) $image_id
  if { $address::($addr_obj,word_status) == 0 } \
  {
   $image_id configure -relief sunken -background $paOption(sunken_bg)
  } else \
  {
   $image_id configure -relief raised -background $paOption(raised_bg)
  }
  PB_com_DeleteObject $add_page_obj
  destroy $win
 }

#=======================================================================
proc UI_PB_mseq_EditAddress { mseq_page_obj add_obj } {
  global gPB
  address::readvalue $add_obj ADDRESSOBJATTR
  set add_name [string tolower $ADDRESSOBJATTR(0)]
  set canvas_frame $Page::($mseq_page_obj,canvas_frame)
  set win [toplevel $canvas_frame.add]
  set toplevel_index [llength $gPB(toplevel_list)]
  set win_index [expr $toplevel_index + 1]
  set gPB(toplevel_disable_$win_index) 1
  UI_PB_com_CreateTransientWindow $win \
  "$gPB(wseq,transient_win,Label) : $ADDRESSOBJATTR(0)" \
  "500x600+100+200" "" "UI_PB_mseq_DisableMseqPageWidgets $mseq_page_obj" "" \
  "UI_PB_mseq_ActivateMseqPageWidgets $mseq_page_obj $win_index"
  UI_PB_addr_CreateAddressPage $win $add_obj new_add_page 0
  set bot_frame $Page::($new_add_page,bottom_frame)
  set cb_arr(gPB(nav_button,default,Label)) \
  "UI_PB_addr_AddDefaultCallBack $new_add_page"
  set cb_arr(gPB(nav_button,restore,Label)) \
  "UI_PB_addr_AddRestoreCallBack $new_add_page"
  set cb_arr(gPB(nav_button,ok,Label)) \
  "__MseqEditOkCallBack $mseq_page_obj \
  $new_add_page $win $add_obj"
  set cb_arr(gPB(nav_button,cancel,Label)) \
  "UI_PB_add_EditCancelCallBack $new_add_page $win"
  UI_PB_com_CreateActionElems $bot_frame cb_arr
  wm protocol $win WM_DELETE_WINDOW [list UI_PB_add_EditCancelCallBack $new_add_page $win]
  UI_PB_com_PositionWindow $win
 }

#=======================================================================
proc UI_PB_mseq_ActivateAllIcons { page_obj } {
  global paOption
  UI_PB_mseq_SetUndoDataOfAddress page_obj
  set Page::($page_obj,undo_flag) 1
  foreach elem_obj $Page::($page_obj,mseq_addr_list) \
  {
   if { $address::($elem_obj,word_status) } \
   {
    $address::($elem_obj,icon_id) configure \
    -relief sunken -background $paOption(sunken_bg)
    set address::($elem_obj,word_status) 0
   }
  }
 }

#=======================================================================
proc UI_PB_mseq_ApplyMastSeq { PAGE_OBJ } {
  upvar $PAGE_OBJ page_obj
  if { [info exists Page::($page_obj,mseq_addr_list)] } \
  {
   set index 0
   foreach addr_obj $Page::($page_obj,mseq_addr_list) \
   {
    set address::($addr_obj,seq_no) $index
    incr index
   }
  }
 }

#=======================================================================
proc UI_PB_mseq_DeleteMastSeqElems { PAGE_OBJ } {
  upvar $PAGE_OBJ page_obj
  set bot_canvas $Page::($page_obj,bot_canvas)
  if { [info exists Page::($page_obj,mseq_addr_list)] } {
   foreach elem_obj $Page::($page_obj,mseq_addr_list) \
   {
    $bot_canvas delete $address::($elem_obj,image_id)
    $bot_canvas delete $address::($elem_obj,divi_id)
    $bot_canvas delete $address::($elem_obj,rect_id)
   }
   unset Page::($page_obj,mseq_addr_list)
  }
  if { [info exists Page::($page_obj,dummy_add_list)] } {
   foreach dummy_obj $Page::($page_obj,dummy_add_list) \
   {
    $bot_canvas delete $address::($dummy_obj,divi_id)
    PB_com_DeleteObject $dummy_obj
   }
  }
  set Page::($page_obj,dummy_add_list) ""
 }

#=======================================================================
proc UI_PB_mseq_UndoMseqPage { page_obj } {
  UI_PB_mseq_DeleteMastSeqElems page_obj
  UI_PB_mseq_SetUndoDataAsActive page_obj
  set mseq_addr_list $Page::($page_obj,mseq_addr_list)
  UI_PB_mseq_SortAddresses mseq_addr_list
  UI_PB_mseq_CreateComponents page_obj mseq_addr_list
  set Page::($page_obj,undo_flag) 0
 }

#=======================================================================
proc UI_PB_mseq_SetUndoDataOfAddress { PAGE_OBJ } {
  upvar $PAGE_OBJ page_obj
  if { [info exists Page::($page_obj,mseq_addr_list)] } \
  {
   set mseq_addr_list $Page::($page_obj,mseq_addr_list)
   set index 0
   foreach addr_obj $mseq_addr_list \
   {
    address::readMseqAttr $addr_obj mseq_addr_attr
    set mseq_addr_attr(3) $index
    address::SetUndoMseqAttr $addr_obj mseq_addr_attr
    incr index
   }
   set Page::($page_obj,undo_mseq_addr_list) $mseq_addr_list
  }
 }

#=======================================================================
proc UI_PB_mseq_SetUndoDataAsActive { PAGE_OBJ } {
  upvar $PAGE_OBJ page_obj
  if { [info exists Page::($page_obj,undo_mseq_addr_list)] } \
  {
   set mseq_addr_list $Page::($page_obj,undo_mseq_addr_list)
   foreach addr_obj $mseq_addr_list \
   {
    address::ReadUndoMseqAttr $addr_obj mseq_addr_attr
    address::SetMseqAttr $addr_obj mseq_addr_attr
   }
  }
  set Page::($page_obj,mseq_addr_list) $mseq_addr_list
 }

#=======================================================================
proc UI_PB_mseq_RestoreCallBack { page_obj } {
  UI_PB_mseq_SetUndoDataOfAddress page_obj
  set Page::($page_obj,undo_flag) 1
  UI_PB_mseq_DeleteMastSeqElems page_obj
  PB_adr_RetAddressObjList add_obj_list
  foreach addr_obj $add_obj_list \
  {
   array set add_mseq_attr $address::($addr_obj,rest_mseq_attr)
   address::SetMseqAttr $addr_obj add_mseq_attr
   unset add_mseq_attr
  }
  UI_PB_mseq_SortAddresses add_obj_list
  UI_PB_mseq_CreateComponents page_obj add_obj_list
 }

#=======================================================================
proc UI_PB_mseq_DefaultCallBack { page_obj } {
  UI_PB_mseq_SetUndoDataOfAddress page_obj
  set Page::($page_obj,undo_flag) 1
  UI_PB_mseq_DeleteMastSeqElems page_obj
  PB_adr_RetAddressObjList add_obj_list
  foreach addr_obj $add_obj_list \
  {
   array set add_mseq_attr $address::($addr_obj,def_mseq_attr)
   address::SetMseqAttr $addr_obj add_mseq_attr
   unset add_mseq_attr
  }
  UI_PB_mseq_SortAddresses add_obj_list
  UI_PB_mseq_CreateComponents page_obj add_obj_list
 }

#=======================================================================
proc UI_PB_mseq_CreateComponents { PAGE_OBJ ADD_OBJ_LIST } {
  upvar $PAGE_OBJ page_obj
  upvar $ADD_OBJ_LIST add_obj_list
  global tixOption paOption
  set bot_canvas $Page::($page_obj,bot_canvas)
  set no_rowelem $Page::($page_obj,no_rowelem)
  set h_cell $Page::($page_obj,h_cell)
  set w_cell $Page::($page_obj,w_cell)
  set w_divi $Page::($page_obj,w_divi)
  set x_orig $Page::($page_obj,x_orig)
  set y_orig $Page::($page_obj,y_orig)
  set row_dist $Page::($page_obj,row_dist)
  set cell_color paleturquoise
  set divi_color turquoise
  set dummy_obj_list ""
  set Page::($page_obj,no_rowelem) $no_rowelem
  set total_elems [llength $add_obj_list]
  set rows [expr $total_elems / $no_rowelem]
  if { [expr $total_elems % $no_rowelem] } \
  {
   incr rows
  }
  set x0 $x_orig
  set y0 $y_orig
  set yc [expr $y0 + [expr $h_cell / 2]]
  set count 0
  for {set no 0} {$no < $rows} {incr no} \
  {
   set ii 0
   while { $ii < $no_rowelem && $count < $total_elems } \
   {
    set addr_obj [lindex $add_obj_list $count]
    address::readMseqAttr $addr_obj addr_mseq_attr
    lappend mseq_addr_list $addr_obj
    set y1 [expr $y0 + $h_cell]
    set x1 [expr $x0 + $w_divi]
    lappend corner $x0 $y0 $x1 $y1
    set address::($addr_obj,divi_dim) $corner
    unset corner
    set address::($addr_obj,divi_id) [UI_PB_com_CreateRectangle \
    $page_obj $x0 $y0 $x1 $y1 $divi_color $divi_color "" ""]
    set x0 $x1
    set x1 [expr $x0 + $w_cell]
    lappend corner $x0 $y0 $x1 $y1
    set address::($addr_obj,rect_dim) $corner
    unset corner
    set address::($addr_obj,rect_id) [UI_PB_com_CreateRectangle \
    $page_obj $x0 $y0 $x1 $y1 $cell_color $divi_color "" ""]
    set xc [expr [expr $x0 + $x1] / 2]
    UI_PB_com_RetImageAppdText addr_obj addr_mseq_attr(0) \
    temp_image_name addr_app_text
    set image_id [UI_PB_blk_CreateIcon $bot_canvas $temp_image_name \
    $addr_app_text]
    set icon_id [$bot_canvas create image  $xc $yc \
    -image $image_id -tag movable]
    unset temp_image_name
    unset addr_app_text
    set address::($addr_obj,image_id) $icon_id
    set address::($addr_obj,icon_id) $image_id
    set address::($addr_obj,xc) $xc
    set address::($addr_obj,yc) $yc
    if { $address::($addr_obj,word_status) == 0 } \
    {
     $image_id configure -relief sunken -background $paOption(sunken_bg)
    } else \
    {
     $image_id configure -relief raised -background $paOption(raised_bg)
    }
    set x0 $x1
    incr count
    incr ii
   }
   if { $ii != 0 } \
   {
    PB_int_CreateMseqAddObj dummy_add_obj
    set x1 [expr $x0 + $w_divi]
    lappend corner $x0 $y0 $x1 $y1
    set address::($dummy_add_obj,divi_dim) $corner
    set address::($dummy_add_obj,divi_id) [UI_PB_com_CreateRectangle \
    $page_obj $x0 $y0 $x1 $y1 $divi_color $divi_color "" ""]
    set address::($dummy_add_obj,image_id) ""
    set address::($dummy_add_obj,icon_id) ""
    set address::($dummy_add_obj,xc) ""
    set address::($dummy_add_obj,yc) ""
    set address::($dummy_add_obj,rect_dim) ""
    set x0 $x_orig
    set y0 [expr $y0 + $h_cell + $row_dist]
    set yc [expr $y0 + [expr $h_cell / 2]]
    unset corner
    lappend dummy_obj_list $dummy_add_obj
   }
   if { $count == $total_elems } { break }
  }
  set Page::($page_obj,dummy_add_list) $dummy_obj_list
  if { [info exist mseq_addr_list] } \
  {
   set Page::($page_obj,mseq_addr_list) $mseq_addr_list
   unset mseq_addr_list
  }
  UI_PB_mseq_BindProcs page_obj
  global gPB
  set gPB(c_help,$bot_canvas,movable)     "wseq,word"
 }

#=======================================================================
proc UI_PB_mseq_UnBindProcs { PAGE_OBJ } {
  upvar $PAGE_OBJ page_obj
  set bot_canvas $Page::($page_obj,bot_canvas)
  $bot_canvas bind movable <1>   ""
  $bot_canvas bind movable <B1-Motion>  ""
  $bot_canvas bind movable <ButtonRelease-1> ""
  $bot_canvas bind movable <3>     ""
  $bot_canvas bind movable <Enter> ""
  $bot_canvas bind movable <Leave>  ""
 }

#=======================================================================
proc UI_PB_mseq_BindProcs { PAGE_OBJ } {
  upvar $PAGE_OBJ page_obj
  set bot_canvas $Page::($page_obj,bot_canvas)
  $bot_canvas bind movable <1>               "UI_PB_mseq_ItemStartDrag $page_obj %x %y"
  $bot_canvas bind movable <B1-Motion>       "UI_PB_mseq_ItemDrag $page_obj %x %y"
  $bot_canvas bind movable <ButtonRelease-1> "UI_PB_mseq_ItemEndDrag $page_obj"
  $bot_canvas bind movable <3>               "UI_PB_mseq_PopupMenu $page_obj"
  $bot_canvas bind movable <Enter>           "UI_PB_mseq_ItemFocusOn $page_obj %x %y"
  $bot_canvas bind movable <Leave>           "UI_PB_mseq_ItemFocusOff  $page_obj"
 }

#=======================================================================
proc UI_PB_mseq_HighLightDividers { page_obj x y } {
  set bot_canvas $Page::($page_obj,bot_canvas)
  set x [$bot_canvas canvasx $x]
  set y [$bot_canvas canvasy $y]
  set focus_addrelem 0
  set check_type "divi_dim"
  UI_PB_mseq_GetBlkElemObjFromCursorPos page_obj focus_addrelem \
  $check_type $x $y
  set Page::($page_obj,in_focus_divi_obj) $focus_addrelem
  if { $Page::($page_obj,in_focus_divi_obj) } \
  {
   set Page::($page_obj,add_act) "insert"
  }
  if { $Page::($page_obj,in_focus_divi_obj) != \
  $Page::($page_obj,out_focus_divi_obj) } \
  {
   UI_PB_mseq_UnHighLightCellDividers page_obj
   if { !$Page::($page_obj,in_focus_divi_obj) } { return }
   set cell_highlight_color navyblue
   set in_focus_obj $Page::($page_obj,in_focus_divi_obj)
   set Page::($page_obj,divi_color) [lindex [$bot_canvas itemconfigure \
   $address::($in_focus_obj,divi_id) -fill] end]
   $bot_canvas itemconfigure $address::($in_focus_obj,divi_id) \
   -fill $cell_highlight_color
   set Page::($page_obj,out_focus_divi_obj) \
   $Page::($page_obj,in_focus_divi_obj)
  }
 }

#=======================================================================
proc UI_PB_mseq_GetBlkElemObjFromCursorPos { PAGE_OBJ ADDR_ELEM_OBJ \
  check_type x y } {
  upvar $PAGE_OBJ page_obj
  upvar $ADDR_ELEM_OBJ addr_elem_obj
  set no_rowelem $Page::($page_obj,no_rowelem)
  set h_cell $Page::($page_obj,h_cell)
  set w_cell $Page::($page_obj,w_cell)
  set w_divi $Page::($page_obj,w_divi)
  set x_orig $Page::($page_obj,x_orig)
  set y_orig $Page::($page_obj,y_orig)
  set row_dist $Page::($page_obj,row_dist)
  set bot_canvas_height $Page::($page_obj,bot_height)
  set row_top $y_orig
  set no_addrs [llength $Page::($page_obj,mseq_addr_list)]
  set no_addr_rows [expr $no_addrs / $no_rowelem]
  if { [expr $no_addrs % $no_rowelem] } \
  {
   incr no_addr_rows
  }
  set row_no 0
  set count 1
  while { $count <= $no_addr_rows } \
  {
   if { $y > [expr $row_top - 40] &&  \
   $y < [expr $row_top + $h_cell + [expr $row_dist / 2]] } \
   {
    set row_no $count
    break
    } elseif { $y < 40 } \
   {
    set row_no 0
    break
   }
   set row_top [expr $row_top + $h_cell + $row_dist]
   incr count
  }
  if { $row_no } \
  {
   set start_no [expr [expr $row_no - 1] * $no_rowelem]
   set end_no   [expr $row_no * $no_rowelem]
   if { $end_no > $no_addrs } \
   {
    set end_no [expr $no_addrs - 1]
   } else \
   {
    set end_no [expr $end_no - 1]
   }
   set mseq_addr_list [lrange $Page::($page_obj,mseq_addr_list) \
   $start_no $end_no]
  } else \
  {
   set mseq_addr_list ""
   return
  }
  foreach addr_obj $mseq_addr_list \
  {
   set corner $address::($addr_obj,$check_type)
   if { $x >= [lindex $corner 0] && $x < [lindex $corner 2]    &&\
    $y >= [expr [lindex $corner 1] - [expr $row_dist / 2]] &&\
   $y <  [expr [lindex $corner 3] + [expr $row_dist / 2]] } \
   {
    set addr_elem_obj $addr_obj
    break
   }
  }
  if { $check_type == "divi_dim" } \
  {
   foreach addr_obj $Page::($page_obj,dummy_add_list) \
   {
    set corner $address::($addr_obj,$check_type)
    if { $x >= [lindex $corner 0] && $x < [lindex $corner 2] && \
     $y >= [expr [lindex $corner 1] - $h_cell] && \
    $y <  [expr [lindex $corner 3] + $h_cell] } \
    {
     set addr_elem_obj $addr_obj
     break
    }
   }
  }
 }

#=======================================================================
proc UI_PB_mseq_UnHighLightCellDividers { PAGE_OBJ } {
  upvar $PAGE_OBJ page_obj
  set bot_canvas $Page::($page_obj,bot_canvas)
  if { $Page::($page_obj,out_focus_cell_obj) } \
  {
   set addr_obj $Page::($page_obj,out_focus_cell_obj)
   $bot_canvas itemconfigure $address::($addr_obj,rect_id) \
   -fill $Page::($page_obj,cell_color)
   set Page::($page_obj,out_focus_cell_obj) 0
  }
  if { $Page::($page_obj,out_focus_divi_obj) } \
  {
   set addr_obj $Page::($page_obj,out_focus_divi_obj)
   $bot_canvas itemconfigure $address::($addr_obj,divi_id) \
   -fill $Page::($page_obj,divi_color)
   set Page::($page_obj,out_focus_divi_obj) 0
  }
  if { [info exists Page::($page_obj,balloon)] == 1 } \
  {
   $bot_canvas delete $Page::($page_obj,balloon)
   $bot_canvas delete $Page::($page_obj,ball_text)
  }
 }

#=======================================================================
proc UI_PB_mseq_ItemFocusOn { page_obj x y} {
  global paOption
  global gPB_help_tips
  set bot_canvas $Page::($page_obj,bot_canvas)
  set x [$bot_canvas canvasx $x]
  set y [$bot_canvas canvasy $y]
  set focus_addrelem 0
  if { $Page::($page_obj,being_dragged) == 0 } \
  {
   global gPB
   if { $gPB(use_info) } \
   {
    $bot_canvas config -cursor question_arrow
   } else \
   {
    $bot_canvas config -cursor hand2
   }
  }
  set check_type "rect_dim"
  UI_PB_mseq_GetBlkElemObjFromCursorPos page_obj focus_addrelem \
  $check_type $x $y
  set Page::($page_obj,in_focus_cell_obj) $focus_addrelem
  if { $gPB_help_tips(state) } \
  {
   if { !$Page::($page_obj,in_focus_cell_obj) } \
   {
    global dragged_balloon
    if { [info exists dragged_balloon] } \
    {
     PB_init_balloons -color $paOption(balloon)
     set gPB_help_tips($bot_canvas) $dragged_balloon
    }
   }
  }
  if { $Page::($page_obj,in_focus_cell_obj) != \
  $Page::($page_obj,out_focus_cell_obj) } \
  {
   UI_PB_mseq_UnHighLightCellDividers page_obj
   if { $gPB_help_tips(state) } \
   {
    PB_init_balloons -color $paOption(balloon)
   }
   if { $gPB_help_tips(state) } \
   {
    global dragged_cell
    if { [info exists dragged_cell] } \
    {
     if { $Page::($page_obj,in_focus_cell_obj) != $dragged_cell } \
     {
      PB_init_balloons -color $paOption(special_fg)
     }
    }
   }
   if { !$Page::($page_obj,in_focus_cell_obj) } { return }
   set cell_highlight_color navyblue
   set in_focus_obj $Page::($page_obj,in_focus_cell_obj)
   set Page::($page_obj,cell_color) [lindex [$bot_canvas itemconfigure \
   $address::($in_focus_obj,rect_id) -fill] end]
   $bot_canvas itemconfigure $address::($in_focus_obj,rect_id) \
   -fill $cell_highlight_color
   if { $gPB_help_tips(state) } \
   {
    UI_PB_mseq_CreateBalloon page_obj
   }
   set Page::($page_obj,out_focus_cell_obj) \
   $Page::($page_obj,in_focus_cell_obj)
  }
 }

#=======================================================================
proc UI_PB_mseq_CreateBalloon { PAGE_OBJ } {
  upvar $PAGE_OBJ page_obj
  global mom_sys_arr
  set c $Page::($page_obj,bot_canvas)
  set in_focus_obj $Page::($page_obj,in_focus_cell_obj)
  set add_name $address::($in_focus_obj,add_name)
  set desc $address::($in_focus_obj,word_desc)
  set add_leader $address::($in_focus_obj,add_leader)
  PB_int_RetMOMVarAsscAddress add_name add_mom_var_list
  set word_desc ""
  set word_val_list ""
  foreach mom_var $add_mom_var_list \
  {
   PB_com_MapMOMVariable mom_sys_arr in_focus_obj mom_var elem_app_text
   PB_int_ApplyFormatAppText in_focus_obj elem_app_text
   if { $elem_app_text != "" && \
   [lsearch $word_val_list $elem_app_text] == -1 } \
   {
    lappend word_val_list $elem_app_text
    append word $add_leader $elem_app_text
    lappend word_desc $word
    unset word
   }
  }
  if { $word_desc == "" } \
  {
   set word_desc $add_leader
  } else \
  {
   set word_desc [lsort -dictionary $word_desc]
   set word_desc [join $word_desc "/ "]
  }
  if { $word_desc == "" } {
   append bal_desc $add_name " - " $desc
   } else {
   append bal_desc $add_name " - " $desc " \($word_desc\)"
  }
  set word_desc $bal_desc
  global gPB_help_tips
  set gPB_help_tips($c) "$word_desc"
 }

#=======================================================================
proc UI_PB_mseq_ItemFocusOff { page_obj } {
  set bot_canvas $Page::($page_obj,bot_canvas)
  if { $Page::($page_obj,out_focus_cell_obj) } \
  {
   set out_focus_obj $Page::($page_obj,out_focus_cell_obj)
   $bot_canvas itemconfigure $address::($out_focus_obj,rect_id) \
   -fill $Page::($page_obj,cell_color)
   if { [info exists Page::($page_obj,balloon)] == 1 } \
   {
    $bot_canvas delete $Page::($page_obj,balloon)
    $bot_canvas delete $Page::($page_obj,ball_text)
   }
  }
  global gPB_help_tips
  if { $gPB_help_tips(state) } \
  {
   if { [info exists gPB_help_tips($bot_canvas)] } {
    unset gPB_help_tips($bot_canvas)
   }
   PB_cancel_balloon
  }
  set Page::($page_obj,in_focus_cell_obj) 0
  set Page::($page_obj,out_focus_cell_obj) 0
  if { $Page::($page_obj,being_dragged) == 0 } \
  {
   $bot_canvas config -cursor ""
  }
 }

#=======================================================================
proc UI_PB_mseq_ItemStartDrag { page_obj x y} {
  set bot_canvas $Page::($page_obj,bot_canvas)
  set Page::($page_obj,being_dragged) 1
  $bot_canvas bind movable <3> ""
  bind $bot_canvas <3> ""
  $bot_canvas raise current
  set Page::($page_obj,x_icon) [$bot_canvas find withtag current]
  set origin_x [$bot_canvas canvasx $x]
  set origin_y [$bot_canvas canvasy $y]
  set Page::($page_obj,last_x)   $origin_x
  set Page::($page_obj,last_y)   $origin_y
  UI_PB_mseq_ItemFocusOn $page_obj $x $y
  UI_PB_com_ChangeCursor $bot_canvas
  global gPB_help_tips
  global dragged_balloon dragged_cell
  if { $gPB_help_tips(state) } \
  {
   if { [info exists gPB_help_tips($bot_canvas)] } {
    set dragged_balloon $gPB_help_tips($bot_canvas)
   }
   set dragged_cell $Page::($page_obj,in_focus_cell_obj)
  }
 }

#=======================================================================
proc UI_PB_mseq_ItemDrag { page_obj x y} {
  if { $Page::($page_obj,being_dragged) == 0 } { return }
  if { $Page::($page_obj,being_dragged) < $Page::($page_obj,drag_sensitivity) } \
  {
   incr Page::($page_obj,being_dragged)
  }
  set bot_canvas $Page::($page_obj,bot_canvas)
  set xc [$bot_canvas canvasx $x]
  set yc [$bot_canvas canvasy $y]
  $bot_canvas move current [expr $xc - $Page::($page_obj,last_x)] \
  [expr $yc - $Page::($page_obj,last_y)]
  set Page::($page_obj,last_x) $xc
  set Page::($page_obj,last_y) $yc
  set Page::($page_obj,add_act) 0
  UI_PB_mseq_ItemFocusOn $page_obj $x $y
  UI_PB_mseq_HighLightDividers $page_obj $x $y
  UI_PB_mseq_DrawConnectLine page_obj
  if { $Page::($page_obj,in_focus_cell_obj) } \
  {
   set in_focus_obj $Page::($page_obj,in_focus_cell_obj)
   $bot_canvas raise $address::($in_focus_obj,rect_id)
   set Page::($page_obj,add_act) "swap"
  }
  if { $Page::($page_obj,in_focus_divi_obj) } \
  {
   set in_focus_obj $Page::($page_obj,in_focus_divi_obj)
   $bot_canvas raise $address::($in_focus_obj,divi_id)
  }
  $bot_canvas raise movable
 }

#=======================================================================
proc UI_PB_mseq_DrawConnectLine { PAGE_OBJ } {
  upvar $PAGE_OBJ page_obj
  global paOption
  set bot_canvas $Page::($page_obj,bot_canvas)
  if { $Page::($page_obj,in_focus_cell_obj) || \
  $Page::($page_obj,in_focus_divi_obj) } \
  {
   set vtx {}
   if { $Page::($page_obj,in_focus_cell_obj) } \
   {
    set in_focus_obj $Page::($page_obj,in_focus_cell_obj)
    set coords [$bot_canvas coords $address::($in_focus_obj,rect_id)]
   } else \
   {
    set in_focus_obj $Page::($page_obj,in_focus_divi_obj)
    set coords [$bot_canvas coords $address::($in_focus_obj,divi_id)]
   }
   set x0 [lindex $coords 0]
   set y0 [lindex $coords 1]
   set x1 [lindex $coords 2]
   set y1 [lindex $coords 3]
   lappend vtx [expr [expr $x0 + $x1] / 2] [expr [expr $y0 + $y1] / 2]
   set coords [$bot_canvas coords current]
   set x1 [expr [lindex $coords 0] + 1]
   set y1 [lindex $coords 1]
   lappend vtx $x1 $y1
   set x1 [expr $x1 - 2]
   lappend vtx $x1 $y1
   if { [$bot_canvas gettags connect_line] == "connect_line" } {
    eval { $bot_canvas coords connect_line } $vtx
    } else {
    eval { $bot_canvas create poly } $vtx { -fill $paOption(focus) \
     -outline $paOption(focus) \
    -tag connect_line }
   }
   } else {
   if { [$bot_canvas gettags connect_line] == "connect_line" } \
   {
    $bot_canvas delete connect_line
   }
  }
 }

#=======================================================================
proc UI_PB_mseq_ItemEndDrag { page_obj } {
  global paOption
  set bot_canvas $Page::($page_obj,bot_canvas)
  UI_PB_mseq_UnHighLightCellDividers page_obj
  $bot_canvas delete connect_line
  foreach addr_obj $Page::($page_obj,mseq_addr_list) \
  {
   if { $address::($addr_obj,image_id) == $Page::($page_obj,x_icon) } \
   {
    set Page::($page_obj,source_elem_obj) $addr_obj
    break;
   }
  }
  if { $Page::($page_obj,being_dragged) && \
  $Page::($page_obj,being_dragged) < $Page::($page_obj,drag_sensitivity) } \
  {
   $bot_canvas config -cursor watch
   if { [__mseq_SuppressElemOK $addr_obj] } \
   {
    set im [$bot_canvas itemconfigure current -image]
    set relief_status [[lindex $im end] cget -relief]
    UI_PB_mseq_SetUndoDataOfAddress page_obj
    set Page::($page_obj,undo_flag) 1
    switch $relief_status \
    {
     raised {
      [lindex $im end] configure -relief sunken \
      -background $paOption(sunken_bg)
      set address::($addr_obj,word_status) 0
     }
     sunken {
      [lindex $im end] configure -relief raised \
      -background $paOption(raised_bg)
      set address::($addr_obj,word_status) 1
     }
    }
    UI_PB_mseq_ReturnCell page_obj
   }
   } elseif { ![string compare $Page::($page_obj,add_act) "swap"] } \
  {
   UI_PB_mseq_SetUndoDataOfAddress page_obj
   set Page::($page_obj,undo_flag) 1
   UI_PB_mseq_SwapCells page_obj
   } elseif { ![string compare $Page::($page_obj,add_act) "insert"] } \
  {
   UI_PB_mseq_SetUndoDataOfAddress page_obj
   set Page::($page_obj,undo_flag) 1
   UI_PB_mseq_InsertCell page_obj
  } else \
  {
   UI_PB_mseq_ReturnCell page_obj
  }
  set Page::($page_obj,add_act)            0
  set Page::($page_obj,x_icon)             0
  set Page::($page_obj,in_focus_cell_obj)  0
  set Page::($page_obj,out_focus_cell_obj) 0
  set Page::($page_obj,in_focus_divi_obj)  0
  set Page::($page_obj,out_focus_divi_obj) 0
  set Page::($page_obj,source_elem_obj)    0
  set Page::($page_obj,being_dragged)      0
  global gPB_help_tips
  if { $gPB_help_tips(state) } \
  {
   if { [info exists gPB_help_tips($bot_canvas)] } {
    unset gPB_help_tips($bot_canvas)
   }
   PB_cancel_balloon
   global dragged_balloon dragged_cell
   if { [info exists dragged_balloon] } { unset dragged_balloon }
   if { [info exists dragged_cell] }    { unset dragged_cell }
  }
  $bot_canvas bind movable <3>  "UI_PB_mseq_PopupMenu $page_obj"
  $bot_canvas config -cursor ""
  bind $bot_canvas <3> "UI_PB_mseq_PopupSetOptions $page_obj %X %Y %x %y"
  update idletasks
 }

#=======================================================================
proc __mseq_SuppressElemOK { addr_obj } {
  global post_object
  if { $address::($addr_obj,word_status) == 1 } {
   return 1
  }
  if { [llength $address::($addr_obj,blk_elem_list)] == 0 } {
   return 1
  }
  foreach b $address::($addr_obj,blk_elem_list) \
  {
   catch { set blk($b) $block_element::($b,parent_name) }
  }
  set this_add_name $address::($addr_obj,add_name)
  set blk_list [array get blk]
  set blk_obj_list $Post::($post_object,blk_obj_list)
  for { set i 1 } { $i < [llength $blk_list] } { incr i 2 } \
  {
   set b [lindex $blk_list $i]
   UI_PB_debug_ForceMsg "Address $this_add_name suppressed from Block : $b"
   PB_com_RetObjFrmName b blk_obj_list blk_obj
   if { $blk_obj <= 0 } { continue }
   set blk_elem_list $block::($blk_obj,elem_addr_list)
   set new_blk_add_list [list]
   foreach elem $blk_elem_list {
    set addr $block_element::($elem,elem_add_obj)
    if { $address::($addr,word_status) == 0 } {
     lappend new_blk_add_list $addr
    }
   }
   if { [llength $new_blk_add_list] == 1 } {
    set evt_list [list]
    set evt_elm_list $block::($blk_obj,evt_elem_list)
    foreach e $evt_elm_list \
    {
     if { [info exists event_element::($e,event_obj)] } \
     {
      set evt_obj $event_element::($e,event_obj)
      set evt $event::($evt_obj,event_name)
      if { [lsearch $evt_list $evt] < 0 } \
      {
       lappend evt_list $evt
      }
     }
    }
    set msg_arr($b) $evt_list
   }
  }
  if { $this_add_name == "X" || \
   $this_add_name == "Y" || \
   $this_add_name == "Z" } {
   set add_obj_list $Post::($post_object,add_obj_list)
   set add_x "X"
   set add_y "Y"
   set add_z "Z"
   PB_com_RetObjFrmName add_x add_obj_list add_obj_x
   PB_com_RetObjFrmName add_y add_obj_list add_obj_y
   PB_com_RetObjFrmName add_z add_obj_list add_obj_z
   array set mom_var_arr $Post::($post_object,mom_sys_var_list)
   set rap_1_obj $mom_var_arr(\$pb_rapid_1)
   set rap_2_obj $mom_var_arr(\$pb_rapid_2)
   if 0 {{
    set rap_blk_1 ""
    set rap_blk_2 ""
    if { $rap_1_obj != "" } {
     set rap_blk_1 $block::($rap_1_obj,block_name)
    }
    if { $rap_2_obj != "" } {
     if { [info exists block::($rap_2_obj,block_name)] } {
      set rap_blk_2 $block::($rap_2_obj,block_name)
     }
    }
   }}
   if { $rap_1_obj != "" } {
    set blk_elem_list $block::($rap_1_obj,elem_addr_list)
    UI_PB_debug_ForceMsg "\n +++++  $rap_1_obj blk elem list : >$blk_elem_list< +++++ "
    } else {
    set blk_elem_list [list]
   }
   set blk_add_list [list]
   foreach elem $blk_elem_list {
    set addr $block_element::($elem,elem_add_obj)
    set addr_name $address::($addr,add_name)
    switch $addr_name {
     "rapid1" -
     "rapid2" -
     "rapid3" {}
     default {
      lappend blk_add_list $addr
     }
    }
   }
   lappend blk_add_list $add_obj_x
   lappend blk_add_list $add_obj_y
   lappend blk_add_list $add_obj_z
   set new_blk_add_list [list]
   foreach addr $blk_add_list {
    if { $address::($addr,word_status) == 0 } {
     lappend new_blk_add_list $addr
    }
   }
   if { [llength $new_blk_add_list] == 1 } {
    set msg_arr(rapid_traverse) {{Rapid Move}}
   }
   if { $rap_2_obj != "" } {
    set blk_elem_list $block::($rap_2_obj,elem_addr_list)
    set blk_add_list [list]
    foreach elem $blk_elem_list {
     set addr $block_element::($elem,elem_add_obj)
     set addr_name $address::($addr,add_name)
     switch $addr_name {
      "rapid1" -
      "rapid2" -
      "rapid3" {}
      default {
       lappend blk_add_list $addr
      }
     }
    }
    lappend blk_add_list $add_obj_x
    lappend blk_add_list $add_obj_y
    lappend blk_add_list $add_obj_z
    set new_blk_add_list [list]
    foreach addr $blk_add_list {
     if { $address::($addr,word_status) == 0 } {
      lappend new_blk_add_list $addr
     }
    }
    if { [llength $new_blk_add_list] == 1 } {
     set msg_arr(rapid_spindle) {{Rapid Move}}
    }
   }
  }
  if { [info exists msg_arr] } \
  {
   global gPB_help_tips
   PB_cancel_balloon
   set balloon_state $gPB_help_tips(state)
   set gPB_help_tips(state) 0
   update
   set lis [array get msg_arr]
   for {set i 0} {$i < [llength $lis]} {incr i 2} \
   {
    set lis [lreplace $lis $i $i "\nBlock \"[lindex $lis $i]\""]
    set j [expr $i + 1]
    if { [llength [lindex $lis $j]] } \
    {
     set lis [lreplace $lis $j $j "of \"[join [lindex $lis $j] "\", \""]\" Event"]
    }
   }
   set msg [join $lis]
   global gPB
   tk_messageBox -parent [UI_PB_com_AskActiveWindow] \
   -title $gPB(msg,error,title) -type ok -icon error -message \
   "\"$this_add_name\" $gPB(wseq,cannot_suppress_msg)\
   \n$msg.\n\
   \n$gPB(wseq,empty_block_msg)"
   set gPB_help_tips(state) $balloon_state
   return 0
  } else \
  {
   return 1
  }
 }

#=======================================================================
proc UI_PB_mseq_ReturnCell { PAGE_OBJ  } {
  upvar $PAGE_OBJ page_obj
  set bot_canvas $Page::($page_obj,bot_canvas)
  set source_elem_obj $Page::($page_obj,source_elem_obj)
  if { $source_elem_obj } \
  {
   $bot_canvas coords $address::($source_elem_obj,image_id) \
   $address::($source_elem_obj,xc) $address::($source_elem_obj,yc)
  }
 }

#=======================================================================
proc UI_PB_mseq_SwapCells { PAGE_OBJ } {
  upvar $PAGE_OBJ page_obj
  set bot_canvas $Page::($page_obj,bot_canvas)
  set source_elem_obj $Page::($page_obj,source_elem_obj)
  set target_elem_obj $Page::($page_obj,in_focus_cell_obj)
  if { !$target_elem_obj }\
  {
   set target_elem_obj $source_elem_obj
  }
  $bot_canvas coords $address::($source_elem_obj,image_id) \
  $address::($target_elem_obj,xc) $address::($target_elem_obj,yc)
  $bot_canvas coords $address::($target_elem_obj,image_id) \
  $address::($source_elem_obj,xc) $address::($source_elem_obj,yc)
  set x $address::($source_elem_obj,xc)
  set y $address::($source_elem_obj,yc)
  set address::($source_elem_obj,xc) $address::($target_elem_obj,xc)
  set address::($source_elem_obj,yc) $address::($target_elem_obj,yc)
  set address::($target_elem_obj,xc) $x
  set address::($target_elem_obj,yc) $y
  set rect_corner $address::($source_elem_obj,rect_dim)
  set divi_corner $address::($source_elem_obj,divi_dim)
  set address::($source_elem_obj,rect_dim) \
  $address::($target_elem_obj,rect_dim)
  set address::($source_elem_obj,divi_dim) \
  $address::($target_elem_obj,divi_dim)
  set address::($target_elem_obj,rect_dim) $rect_corner
  set address::($target_elem_obj,divi_dim) $divi_corner
  set rect_id $address::($source_elem_obj,rect_id)
  set divi_id $address::($source_elem_obj,divi_id)
  set address::($source_elem_obj,rect_id) $address::($target_elem_obj,rect_id)
  set address::($source_elem_obj,divi_id) $address::($target_elem_obj,divi_id)
  set address::($target_elem_obj,rect_id) $rect_id
  set address::($target_elem_obj,divi_id) $divi_id
  set temp_elem_obj_list $Page::($page_obj,mseq_addr_list)
  unset Page::($page_obj,mseq_addr_list)
  set source_index [lsearch $temp_elem_obj_list $source_elem_obj]
  set target_index [lsearch $temp_elem_obj_list $target_elem_obj]
  set temp_elem_obj_list [lreplace $temp_elem_obj_list $source_index \
  $source_index $target_elem_obj]
  set temp_elem_obj_list [lreplace $temp_elem_obj_list $target_index \
  $target_index $source_elem_obj]
  set Page::($page_obj,mseq_addr_list) $temp_elem_obj_list
  unset temp_elem_obj_list
 }

#=======================================================================
proc UI_PB_mseq_GetActualTargetElem { PAGE_OBJ TARGET_ELEM_OBJ DUMMY_INDEX } {
  upvar $PAGE_OBJ page_obj
  upvar $TARGET_ELEM_OBJ target_elem_obj
  upvar $DUMMY_INDEX dummy_index
  set dummy_obj_list $Page::($page_obj,dummy_add_list)
  set dummy_obj_index [lsearch $dummy_obj_list $target_elem_obj]
  set dummy_index 0
  if { $dummy_obj_index != -1 } \
  {
   set mseq_addr_list $Page::($page_obj,mseq_addr_list)
   set no_addr [llength $mseq_addr_list]
   set no_rowelem $Page::($page_obj,no_rowelem)
   set act_index [ expr $no_rowelem * [expr $dummy_obj_index + 1]]
   if { $act_index >= $no_addr } \
   {
    set act_index [expr $no_addr - 1]
    set target_elem_obj [lindex $mseq_addr_list $act_index]
    set dummy_index 1
   } else \
   {
    set target_elem_obj [lindex $mseq_addr_list $act_index]
   }
  }
 }

#=======================================================================
proc UI_PB_mseq_InsertCell { PAGE_OBJ } {
  upvar $PAGE_OBJ page_obj
  set bot_canvas $Page::($page_obj,bot_canvas)
  set mseq_addr_list $Page::($page_obj,mseq_addr_list)
  set source_elem_obj $Page::($page_obj,source_elem_obj)
  set target_elem_obj $Page::($page_obj,in_focus_divi_obj)
  if { $target_elem_obj == 0 } { set target_elem_obj $source_elem_obj }
  UI_PB_mseq_GetActualTargetElem page_obj target_elem_obj dummy_index
  set source_cell_num [lsearch $mseq_addr_list $source_elem_obj]
  set target_cell_num [lsearch $mseq_addr_list $target_elem_obj]
  if { $target_cell_num > $source_cell_num } \
  {
   set expression { set test [expr $ii > $source_cell_num ] }
   if { !$dummy_index } { incr target_cell_num -1 }
   set inc_num -1
  } else \
  {
   set expression { set test [expr $ii < $source_cell_num ] }
   set inc_num 1
  }
  set source_xc $address::($source_elem_obj,xc)
  set source_yc $address::($source_elem_obj,yc)
  set source_rect_dim $address::($source_elem_obj,rect_dim)
  set source_divi_dim $address::($source_elem_obj,divi_dim)
  set source_rect_id $address::($source_elem_obj,rect_id)
  set source_divi_id $address::($source_elem_obj,divi_id)
  set temp_elem_obj $source_elem_obj
  for {set ii $target_cell_num} { [eval $expression] } {incr ii $inc_num} \
  {
   set elem_obj [lindex $mseq_addr_list $ii]
   $bot_canvas coords $address::($temp_elem_obj,image_id) \
   $address::($elem_obj,xc) $address::($elem_obj,yc)
   set address::($temp_elem_obj,xc) $address::($elem_obj,xc)
   set address::($temp_elem_obj,yc) $address::($elem_obj,yc)
   set address::($temp_elem_obj,rect_dim) $address::($elem_obj,rect_dim)
   set address::($temp_elem_obj,divi_dim) $address::($elem_obj,divi_dim)
   set address::($temp_elem_obj,rect_id) $address::($elem_obj,rect_id)
   set address::($temp_elem_obj,divi_id) $address::($elem_obj,divi_id)
   set mseq_addr_list [lreplace $mseq_addr_list $ii $ii $temp_elem_obj]
   set temp_elem_obj $elem_obj
  }
  set address::($temp_elem_obj,xc) $source_xc
  set address::($temp_elem_obj,yc) $source_yc
  set address::($temp_elem_obj,rect_dim) $source_rect_dim
  set address::($temp_elem_obj,divi_dim) $source_divi_dim
  set address::($temp_elem_obj,rect_id) $source_rect_id
  set address::($temp_elem_obj,divi_id) $source_divi_id
  $bot_canvas coords $address::($temp_elem_obj,image_id) \
  $source_xc $source_yc
  set mseq_addr_list [lreplace $mseq_addr_list $source_cell_num \
  $source_cell_num $temp_elem_obj]
  unset Page::($page_obj,mseq_addr_list)
  set Page::($page_obj,mseq_addr_list) $mseq_addr_list
  unset mseq_addr_list
 }

#=======================================================================
proc UI_PB_mseq_SortAddresses { ADD_OBJ_LIST } {
  upvar $ADD_OBJ_LIST add_obj_list
  set new_add_list [list]
  foreach add_obj $add_obj_list \
  {
   if { [string compare $address::($add_obj,rep_mom_var) ""] } {
    lappend new_add_list $add_obj
    } elseif { [string compare $address::($add_obj,add_name) "Text"] && \
    [string compare $address::($add_obj,add_name) "N"   ] } {
    lappend new_add_list $add_obj
   }
  }
  set add_obj_list $new_add_list
  set no_elements [llength $add_obj_list]
  for { set ii 0 } { $ii < [expr $no_elements - 1] } { incr ii } \
  {
   for { set jj [expr $ii + 1] } { $jj < $no_elements } { incr jj } \
   {
    set addr_ii_obj [lindex $add_obj_list $ii]
    set addr_ii_indx $address::($addr_ii_obj,seq_no)
    set addr_jj_obj [lindex $add_obj_list $jj]
    set addr_jj_indx $address::($addr_jj_obj,seq_no)
    if { $addr_jj_indx < $addr_ii_indx } \
    {
     set add_obj_list [lreplace $add_obj_list $ii $ii $addr_jj_obj]
     set add_obj_list [lreplace $add_obj_list $jj $jj $addr_ii_obj]
    }
   }
  }
 }
