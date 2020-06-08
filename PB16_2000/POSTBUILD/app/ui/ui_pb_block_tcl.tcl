#3

#=======================================================================
proc UI_PB_Def_Block {book_id blk_page_obj} {
  global tixOption
  global paOption
  global popupvar
  set blk_elm_attr(0) 0
  set blk_elm_attr(1) 0
  set blk_elm_attr(2) 0
  set Page::($blk_page_obj,page_id) [$book_id subwidget \
  $Page::($blk_page_obj,page_name)]
  UI_PB_blk_SetPageAttributes blk_page_obj
  Page::CreatePane $blk_page_obj
  UI_PB_blk_AddComponentsLeftPane blk_page_obj
  Page::CreateTree $blk_page_obj
  UI_PB_blk_CreateTreeElements blk_page_obj
  __CreateBlockPageParm blk_page_obj
  UI_PB_blk_AddActionButtons blk_page_obj
  set Page::($blk_page_obj,blk_WordNameList) ""
 }

#=======================================================================
proc UI_PB_blk_SetPageAttributes { PAGE_OBJ } {
  upvar $PAGE_OBJ page_obj
  set Page::($page_obj,block_popup_flag) 0
  set Page::($page_obj,trl_flag) 0
  set Page::($page_obj,lead_flag) 0
  set Page::($page_obj,fmt_flag) 0
  set Page::($page_obj,h_cell) 30       
  set Page::($page_obj,w_cell) 62       
  set Page::($page_obj,w_divi) 4        
  set Page::($page_obj,rect_region) 80  
  set Page::($page_obj,x_orig) 60       
  set Page::($page_obj,y_orig) 120
  set Page::($page_obj,add_flag) 0
 }

#=======================================================================
proc UI_PB_blk_AddComponentsLeftPane {PAGE_OBJ} {
  upvar $PAGE_OBJ page_obj
  global gPB
  global paOption
  set left_pane $Page::($page_obj,left_pane_id)
  set but [frame $left_pane.f]
  set new [button $but.new -text "$gPB(tree,create,Label)" \
  -command "UI_PB_blk_CreateABlock $page_obj" \
  -bg $paOption(app_butt_bg)]
  set del [button $but.del -text "$gPB(tree,cut,Label)" \
  -command "UI_PB_blk_CutABlock $page_obj" \
  -bg $paOption(app_butt_bg)]
  set pas [button $but.pas -text "$gPB(tree,paste,Label)" \
  -command "UI_PB_blk_PasteABlock $page_obj" \
  -bg $paOption(app_butt_bg)]
  pack $new $del $pas -side left -fill x -expand yes
  pack $but -side top -fill x -padx 7
  set gPB(c_help,$new)   "tree,create"
  set gPB(c_help,$del)   "tree,cut"
  set gPB(c_help,$pas)   "tree,paste"
 }

#=======================================================================
proc UI_PB_blk_CreateABlock { page_obj } {
  set active_blk_obj $Page::($page_obj,active_blk_obj)
  PB_int_BlockCreateObject active_blk_obj obj_index
  UI_PB_blk_DisplayNameList page_obj obj_index
  UI_PB_blk_BlkItemSelection $page_obj
 }

#=======================================================================
proc UI_PB_blk_CutABlock { page_obj } {
  set tree $Page::($page_obj,tree)
  set HLIST [$tree subwidget hlist]
  set ent [$HLIST info selection]
  set obj_index [string range $ent 2 [string length $ent]]
  set active_blk_obj $Page::($page_obj,active_blk_obj)
  if {$block::($active_blk_obj,evt_elem_list) != ""} \
  {
   set block_name $block::($active_blk_obj,block_name)
   tk_messageBox  -parent [UI_PB_com_AskActiveWindow] -type ok -icon error\
   -message "Block \"$block_name\" is used by an Event. \
   Block cannot be deleted"
  } else \
  {
   if { [info exists Page::($page_obj,buff_blk_obj)] } \
   {
    delete $Page::($page_obj,buff_blk_obj)
    unset Page::($page_obj,buff_blk_obj)
   }
   PB_int_BlockCutObject active_blk_obj obj_index
   set Page::($page_obj,buff_blk_obj) $active_blk_obj
   UI_PB_blk_DisplayNameList page_obj obj_index
   UI_PB_blk_BlkItemSelection $page_obj
  }
 }

#=======================================================================
proc UI_PB_blk_PasteABlock { page_obj } {
  set tree $Page::($page_obj,tree)
  set HLIST [$tree subwidget hlist]
  set ent [$HLIST info selection]
  set obj_index [string range $ent 2 [string length $ent]]
  if {![info exists Page::($page_obj,buff_blk_obj)]} \
  {
   return
  }
  set buff_blk_obj $Page::($page_obj,buff_blk_obj)
  set temp_index $obj_index
  PB_int_BlockPasteObject buff_blk_obj obj_index
  if { $temp_index != $obj_index } \
  {
   UI_PB_blk_DisplayNameList page_obj obj_index
   UI_PB_blk_BlkItemSelection $page_obj
  }
  unset Page::($page_obj,buff_blk_obj)
 }

#=======================================================================
proc UI_PB_blk_CreateTreeElements {PAGE_OBJ} {
  upvar $PAGE_OBJ page_obj
  global paOption
  set tree $Page::($page_obj,tree)
  set h [$tree subwidget hlist]
  $h config -bg $paOption(tree_bg)
  uplevel #0 set TRANSPARENT_GIF_COLOR [$h cget -bg]
  $tree config \
  -command   "UI_PB_blk_BlkItemSelection $page_obj" \
  -browsecmd "UI_PB_blk_BlkItemSelection $page_obj"
 }

#=======================================================================
proc UI_PB_blk_DisplayNameList { PAGE_OBJ OBJ_INDEX } {
  upvar $PAGE_OBJ page_obj
  upvar $OBJ_INDEX obj_index
  global paOption
  set tree $Page::($page_obj,tree)
  set HLIST [$tree subwidget hlist]
  $HLIST delete all
  $HLIST add 0 -itemtype imagetext -text "" -image $paOption(folder) -state disabled
  set file   [tix getimage pb_block_s]
  PB_int_RetBlkObjList blk_obj_list
  set no_fmt [llength $blk_obj_list]
  global gPB
  set style $gPB(font_style_normal)
  for {set count 0} {$count < $no_fmt} {incr count}\
  {
   set blk_obj [lindex $blk_obj_list $count]
   set blk_name $block::($blk_obj,block_name)
   $HLIST add 0.$count -itemtype imagetext -text $blk_name -image $file \
   -style $style
  }
  if { $obj_index >= $no_fmt } \
  {
   set obj_index [expr $no_fmt - 1]
   $HLIST selection set 0.$obj_index
   } elseif {$obj_index >= 0}\
  {
   $HLIST selection set 0.$obj_index
  } else\
  {
   $HLIST selection set 0
  }
  $tree autosetmode
 }

#=======================================================================
proc UI_PB_blk_BlkItemSelection { page_obj args } {
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
  PB_int_RetBlkObjList blk_obj_list
  set block_obj [lindex $blk_obj_list $index]
  if {[info exists Page::($page_obj,active_blk_obj)]} \
  {
   if { $block_obj == $Page::($page_obj,active_blk_obj) } \
   {
    return
   }
  }
  if {[info exists Page::($page_obj,active_blk_obj)]} \
  {
   set active_blk $Page::($page_obj,active_blk_obj)
   if { $block::($active_blk,active_blk_elem_list) == "" } \
   {
    set act_index [lsearch $blk_obj_list $active_blk]
    $HLIST selection clear
    $HLIST anchor clear
    $HLIST selection set 0.$act_index
    $HLIST anchor set 0.$act_index
    tk_messageBox -parent [UI_PB_com_AskActiveWindow] -type ok \
    -icon error \
    -message "$gPB(block,msg,min_word)"
    return
   }
   UI_PB_blk_DeleteCellsIcons page_obj active_blk
   foreach blk_elem_obj $block::($active_blk,elem_addr_list) \
   {
    unset block_element::($blk_elem_obj,rest_value)
   }
   UI_PB_blk_BlkApplyCallBack $page_obj
   unset block::($active_blk,rest_value)
  }
  UI_PB_blk_DisplayBlockAttr page_obj block_obj
 }

#=======================================================================
proc UI_PB_blk_DisplayBlockAttr { PAGE_OBJ BLOCK_OBJ } {
  upvar $PAGE_OBJ page_obj
  upvar $BLOCK_OBJ block_obj
  set Page::($page_obj,in_focus_elem) 0
  set Page::($page_obj,out_focus_elem) 0
  set Page::($page_obj,active_blk_elem) 0
  set Page::($page_obj,trash_flag) 0
  block::RestoreValue $block_obj
  foreach blk_elem_obj $block::($block_obj,elem_addr_list) \
  {
   block_element::RestoreValue $blk_elem_obj
  }
  UI_PB_blk_GetBlkAttrSort page_obj block_obj
  if { $block::($block_obj,active_blk_elem_list) != ""} \
  {
   set active_blk_elem_obj \
   [lindex $block::($block_obj,active_blk_elem_list) 0]
   if { $active_blk_elem_obj == "" } \
   {
    set active_blk_elem_obj 0
   }
  } else \
  {
   set active_blk_elem_obj 0
  }
  UI_PB_blk_CreateBlockImages page_obj block_obj
  set block_owner $block::($block_obj,blk_owner)
  UI_PB_blk_CreateBlockCells page_obj block_obj active_blk_elem_obj \
  block_owner
  UI_PB_blk_ConfigureLeader page_obj active_blk_elem_obj
  UI_PB_blk_IconBindProcs page_obj
 }

#=======================================================================
proc UI_PB_blk_GetBlkAttrSort {PAGE_OBJ BLOCK_OBJ } {
  upvar $PAGE_OBJ page_obj
  upvar $BLOCK_OBJ block_obj
  set block::($block_obj,active_blk_elem_list) ""
  if { [string compare $block::($block_obj,elem_addr_list) ""] != 0 } \
  {
   set active_blk_elem_list $block::($block_obj,elem_addr_list)
   if { $block::($block_obj,blk_type) != "command" && \
   $block::($block_obj,blk_type) != "comment" } \
   {
    UI_PB_com_ApplyMastSeqBlockElem active_blk_elem_list
   }
   set block::($block_obj,active_blk_elem_list) $active_blk_elem_list
  }
 }

#=======================================================================
proc UI_PB_blk_DeleteCellsIcons {PAGE_OBJ BLOCK_OBJ} {
  upvar $PAGE_OBJ page_obj
  upvar $BLOCK_OBJ block_obj
  set c $Page::($page_obj,bot_canvas)
  foreach blk_elem_obj $block::($block_obj,active_blk_elem_list) \
  {
   $c delete $block_element::($blk_elem_obj,rect)
   $c delete $block_element::($blk_elem_obj,div_id)
   $c delete $block_element::($blk_elem_obj,icon_id)
  }
  if { $block::($block_obj,div_id) != ""} \
  {
   $c delete $block::($block_obj,div_id)
   set block::($block_obj,div_id) ""
  }
  if { $block::($block_obj,rect) != "" } \
  {
   $c delete $block::($block_obj,rect)
   set block::($block_obj,rect) ""
  }
 }

#=======================================================================
proc UI_PB_blk_CreateBlockImages { PAGE_OBJ BLOCK_OBJ } {
  upvar $PAGE_OBJ page_obj
  upvar $BLOCK_OBJ block_obj
  if { $block::($block_obj,active_blk_elem_list) == "" } \
  {
   return
  }
  set bot_canvas $Page::($page_obj,bot_canvas)
  foreach blk_elem_obj $block::($block_obj,active_blk_elem_list) \
  {
   set blk_elem_addr $block_element::($blk_elem_obj,elem_add_obj)
   set blk_elem_mom_var $block_element::($blk_elem_obj,elem_mom_variable)
   UI_PB_com_RetImageAppdText blk_elem_addr blk_elem_mom_var \
   img_name blk_elem_text
   set blk_elem_img  [UI_PB_blk_CreateIcon $bot_canvas $img_name \
   $blk_elem_text]
   set block_element::($blk_elem_obj,blk_img) $blk_elem_img
  }
 }

#=======================================================================
proc UI_PB_blk_AddTopFrameItems {PAGE_OBJ} {
  upvar $PAGE_OBJ page_obj
  global tixOption
  global paOption
  set blk_elm_attr(0) 0
  set blk_elm_attr(1) 0
  set blk_elm_attr(2) 0
  set canvas_frame $Page::($page_obj,canvas_frame)
  set frm [tixButtonBox $canvas_frame.act \
  -orientation horizontal \
  -bd 2 \
  -relief sunken \
  -bg gray85]
  pack $frm -side bottom -fill x -padx 3 -pady 3
  button $frm.adr -text "$blk_elm_attr(0)" -cursor "" \
  -font $tixOption(bold_font) -bg darkSeaGreen3 -relief flat \
  -state disabled -disabledforeground lightYellow
  button $frm.fmt -text "$blk_elm_attr(1)" -cursor "" \
  -font $tixOption(bold_font) -bg darkSeaGreen3 -relief flat \
  -state disabled -disabledforeground lightYellow
  button $frm.trl -text "$blk_elm_attr(2)" -cursor "" \
  -font $tixOption(bold_font) -bg darkSeaGreen3 -relief flat \
  -state disabled -disabledforeground lightYellow
  $frm.adr configure -activebackground darkSeaGreen3
  $frm.fmt configure -activebackground darkSeaGreen3
  $frm.trl configure -activebackground darkSeaGreen3
  grid $frm.adr -row 1 -column 1  -pady 10
  grid $frm.fmt -row 1 -column 2  -pady 10
  grid $frm.trl -row 1 -column 3  -pady 10
  set Page::($page_obj,fmt) $frm.fmt
  set Page::($page_obj,addr) $frm.adr
  set Page::($page_obj,trailer) $frm.trl
  button $frm.xxx -text " " -cursor "" \
  -font $tixOption(bold_font) -bg gray85 -relief flat \
  -state disabled -disabledforeground gray85
  $frm.xxx configure -highlightbackground gray85
  grid $frm.xxx -row 1 -column 4  -pady 10
  bind $frm <Enter> "%W config -bg $paOption(focus)"
  bind $frm <Enter> "+%W.xxx config -bg $paOption(focus) \
  -highlightbackground $paOption(focus)"
  bind $frm <Leave> "%W config -bg gray85"
  bind $frm <Leave> "+%W.xxx config -bg gray85 \
  -highlightbackground gray85"
  set Page::($page_obj,verify) $frm
 }

#=======================================================================
proc UI_PB_blk_AddActionButtons { PAGE_OBJ } {
  upvar $PAGE_OBJ page_obj
  global paOption
  set box $Page::($page_obj,box)
  set cb_arr(gPB(nav_button,default,Label)) \
  "UI_PB_blk_DefaultCallBack $page_obj"
  set cb_arr(gPB(nav_button,restore,Label)) \
  "UI_PB_blk_RestoreCallBack $page_obj"
  set label_list {"gPB(nav_button,default,Label)" \
  "gPB(nav_button,restore,Label)"}
  UI_PB_com_CreateButtonBox $box label_list cb_arr
 }

#=======================================================================
proc UI_PB_blk_AddBindProcs {PAGE_OBJ} {
  upvar $PAGE_OBJ page_obj
  set top_canvas $Page::($page_obj,top_canvas)
  $top_canvas bind add_movable <1> \
  "UI_PB_blk_ItemStartDrag1 $page_obj \
  %x %y"
  $top_canvas bind add_movable <Enter> \
  "UI_PB_blk_ItemFocusOn1 $page_obj \
  %x %y"
  $top_canvas bind add_movable <Leave> \
  "UI_PB_blk_ItemFocusOff1 $page_obj"
 }

#=======================================================================
proc UI_PB_blk_AddUnBindProcs { PAGE_OBJ } {
  upvar $PAGE_OBJ page_obj
  set top_canvas $Page::($page_obj,top_canvas)
  $top_canvas bind add_movable <Enter> ""
  $top_canvas bind add_movable <Leave> ""
  $top_canvas bind add_movable <1> ""
  $top_canvas bind add_movable <B1-Motion> ""
  $top_canvas bind add_movable <ButtonRelease-1> ""
 }

#=======================================================================
proc UI_PB_blk_CreatePopupMenu { PAGE_OBJ } {
  upvar $PAGE_OBJ page_obj
  global tixOption
  global paOption
  global popupvar
  set bot_canvas $Page::($page_obj,bot_canvas)
  option add *Menu.tearOff   0
  set blockpopup [menu $bot_canvas.pop]
  set Page::($page_obj,blockpopup) $blockpopup
  set Page::($page_obj,block_popup_flag) 0
  bind $bot_canvas <3> "UI_PB_blk_CanvasPopupMenu $page_obj popupvar %X %Y"
 }

#=======================================================================
proc UI_PB_blk_DeleteApplyChangeOverBlkElems { BLOCK_OBJ } {
  upvar $BLOCK_OBJ block_obj
  if { [info exists block::($block_obj,rest_value)] }\
  {
   array set rest_blk_attr $block::($block_obj,rest_value)
  } else \
  {
   set rest_blk_attr(2) ""
  }
  array set def_blk_attr $block::($block_obj,def_value)
  foreach blk_elem $rest_blk_attr(2) \
  {
   if { [lsearch $block::($block_obj,active_blk_elem_list) $blk_elem] == -1 \
   && [lsearch $def_blk_attr(2) $blk_elem] == -1 } \
   {
    delete $blk_elem
   }
  }
 }

#=======================================================================
proc UI_PB_blk_BlkApplyCallBack {page_obj} {
  set WordNameList $Page::($page_obj,blk_WordNameList)
  set block_obj $Page::($page_obj,active_blk_obj)
  UI_PB_blk_DeleteApplyChangeOverBlkElems block_obj
  block::readvalue $block_obj blk_obj_attr
  set blk_obj_attr(0) $block::($block_obj,block_name)
  set blk_obj_attr(1) [llength $block::($block_obj,active_blk_elem_list)]
  set blk_obj_attr(2) $block::($block_obj,active_blk_elem_list)
  block::setvalue $block_obj blk_obj_attr
  block::RestoreValue $block_obj
 }

#=======================================================================
proc UI_PB_blk_RestoreCallBack { page_obj } {
  set block_obj $Page::($page_obj,active_blk_obj)
  UI_PB_blk_DeleteCellsIcons page_obj block_obj
  foreach blk_elem $block::($block_obj,active_blk_elem_list) \
  {
   block_element::readvalue $blk_elem blk_elem_attr
   address::DeleteFromBlkElemList $blk_elem_attr(0) blk_elem
   unset blk_elem_attr
  }
  UI_PB_blk_DeleteChangeOverBlkElems block_obj
  array set blk_obj_attr $block::($block_obj,rest_value)
  block::setvalue $block_obj blk_obj_attr
  unset blk_obj_attr
  foreach blk_elem_obj $block::($block_obj,elem_addr_list) \
  {
   array set blk_elem_obj_attr $block_element::($blk_elem_obj,rest_value)
   block_element::setvalue $blk_elem_obj blk_elem_obj_attr
   unset blk_elem_obj_attr
  }
  UI_PB_blk_GetBlkAttrSort page_obj block_obj
  if { $block::($block_obj,active_blk_elem_list) != "" } \
  {
   foreach blk_elem $block::($block_obj,active_blk_elem_list) \
   {
    block_element::readvalue $blk_elem blk_elem_attr
    address::AddToBlkElemList $blk_elem_attr(0) blk_elem
    unset blk_elem_attr
   }
   set active_blk_elem_obj \
   [lindex $block::($block_obj,active_blk_elem_list) 0]
   if { $active_blk_elem_obj == "" } \
   {
    set active_blk_elem_obj 0
   }
  } else \
  {
   set active_blk_elem_obj 0
  }
  UI_PB_blk_CreateBlockImages page_obj block_obj
  set block_owner $block::($block_obj,blk_owner)
  UI_PB_blk_CreateBlockCells page_obj block_obj active_blk_elem_obj \
  block_owner
  UI_PB_blk_ConfigureLeader page_obj active_blk_elem_obj
  UI_PB_blk_IconBindProcs page_obj
 }

#=======================================================================
proc UI_PB_blk_DeleteChangeOverBlkElems { BLOCK_OBJ } {
  upvar $BLOCK_OBJ block_obj
  if { [info exists block::($block_obj,rest_value)] } \
  {
   array set rest_blk_attr $block::($block_obj,rest_value)
  } else \
  {
   set rest_blk_attr(2) ""
  }
  array set def_blk_attr $block::($block_obj,def_value)
  set blk_elem_list ""
  foreach blk_elem $block::($block_obj,active_blk_elem_list) \
  {
   if { [lsearch $rest_blk_attr(2) $blk_elem] == -1 && \
   [lsearch $def_blk_attr(2) $blk_elem] == -1 } \
   {
    delete $blk_elem
   } else \
   {
    lappend blk_elem_list $blk_elem
   }
  }
  set block::($block_obj,active_blk_elem_list) $blk_elem_list
 }

#=======================================================================
proc UI_PB_blk_DefaultCallBack {page_obj} {
  set block_obj $Page::($page_obj,active_blk_obj)
  UI_PB_blk_DeleteCellsIcons page_obj block_obj
  foreach blk_elem $block::($block_obj,active_blk_elem_list) \
  {
   block_element::readvalue $blk_elem blk_elem_attr
   address::DeleteFromBlkElemList $blk_elem_attr(0) blk_elem
   unset blk_elem_attr
  }
  UI_PB_blk_DeleteChangeOverBlkElems block_obj
  array set blk_obj_attr $block::($block_obj,def_value)
  block::setvalue $block_obj blk_obj_attr
  unset blk_obj_attr
  foreach blk_elem_obj $block::($block_obj,elem_addr_list) \
  {
   array set blk_elem_obj_attr $block_element::($blk_elem_obj,def_value)
   block_element::setvalue $blk_elem_obj blk_elem_obj_attr
   address::AddToBlkElemList $blk_elem_obj_attr(0) blk_elem_obj
   unset blk_elem_obj_attr
  }
  UI_PB_blk_GetBlkAttrSort page_obj block_obj
  if { $block::($block_obj,active_blk_elem_list) != "" } \
  {
   set active_blk_elem_obj \
   [lindex $block::($block_obj,active_blk_elem_list) 0]
   if { $active_blk_elem_obj == "" } \
   {
    set active_blk_elem_obj 0
   }
  } else \
  {
   set active_blk_elem_obj 0
  }
  UI_PB_blk_CreateBlockImages page_obj block_obj
  set block_owner $block::($block_obj,blk_owner)
  UI_PB_blk_CreateBlockCells page_obj block_obj active_blk_elem_obj \
  block_owner
  UI_PB_blk_ConfigureLeader page_obj active_blk_elem_obj
  UI_PB_blk_IconBindProcs page_obj
 }

#=======================================================================
proc UI_PB_blk_CanvasPopupMenu {page_obj POPUPVAR x y} {
  upvar $POPUPVAR popupvar
  global gPB
  set blockpopup $Page::($page_obj,blockpopup)
  if { $Page::($page_obj,block_popup_flag) } \
  {
   tk_popup $blockpopup $x $y
   set Page::($page_obj,block_popup_flag) 0
  } else \
  {
   $blockpopup delete 0 end
   $blockpopup add command -label "$gPB(block,undo_popup,Label)" \
   -state disabled
  }
 }

#=======================================================================
proc UI_PB_blk_CombSelection { page_obj base_addr index} {
  global tixOption
  global mom_sys_arr
  global gPB
  PB_int_GetWordVarDesc WordDescArray
  set add_leader ""
  if { [string compare $base_addr "New_Address"] == 0 || \
  [string compare $base_addr "Comment"] == 0 } \
  {
   set mom_var ""
   set new_word_mom_var ""
   set app_text ""
   set word_desc "$gPB(block,oper,word_desc,Label)"
   } elseif { [string compare $base_addr "Command"] == 0} \
  {
   PB_int_RetMOMVarAsscAddress base_addr word_mom_var_list
   set app_text [lindex $word_mom_var_list $index]
   set add_leader ""
   set new_word_mom_var $app_text
   set word_desc [lindex $WordDescArray($base_addr) $index]
  } else \
  {
   PB_int_RetAddrObjFromName base_addr add_obj
   if {[string compare $address::($add_obj,add_name) "Text"] == 0} \
   {
    set mom_var ""
    set new_word_mom_var ""
   } else \
   {
    set add_leader $address::($add_obj,add_leader)
    PB_int_RetMOMVarAsscAddress base_addr word_mom_var_list
    set mom_var [lindex $word_mom_var_list $index]
    PB_int_GetNewBlockElement base_addr index new_word_mom_var
   }
   PB_com_MapMOMVariable mom_sys_arr add_obj mom_var app_text
   PB_int_ApplyFormatAppText add_obj app_text
   set word_desc [lindex $WordDescArray($base_addr) $index]
  }
  if { $word_desc == "" } \
  {
   set word_desc "$gPB(block,user,word_desc,Label)"
  }
  set desc ""
  if { $base_addr == "Comment" } \
  {
   append desc "$gPB(block,oper,word_desc,Label)" " (" \
   $add_leader $app_text - $word_desc " )"
  } else \
  {
   append desc $base_addr " (" $add_leader $app_text - $word_desc " )"
  }
  set comb_var $desc
  set Page::($page_obj,comb_var) $desc
  set Page::($page_obj,new_elem_mom_var) $new_word_mom_var
  set Page::($page_obj,sel_base_addr) $base_addr
 }

#=======================================================================
proc UI_PB_blk_GetActiveAddresses { PAGE_OBJ } {
  upvar $PAGE_OBJ page_obj
  set temp_wordnamelist ""
  PB_int_RetAddressObjList add_obj_list
  foreach addr_obj $add_obj_list \
  {
   if { $addr_obj } \
   {
    if { $address::($addr_obj,word_status) == 0} \
    {
     set addr_name $address::($addr_obj,add_name)
     if { [string compare $addr_name Text] != 0 && \
     [string compare $addr_name N] != 0} \
     {
      lappend temp_wordnamelist $addr_name
     }
    }
   }
  }
  set Page::($page_obj,blk_WordNameList) $temp_wordnamelist
 }

#=======================================================================
proc UI_PB_blk_CreateMenuElement { PAGE_OBJ comb_widget element_index \
  NO_OF_ADDR} {
  upvar $PAGE_OBJ page_obj
  upvar $NO_OF_ADDR no_of_addr
  global mom_sys_arr
  set word [lindex $Page::($page_obj,blk_WordNameList) $element_index]
  PB_int_RetAddrObjFromName word add_obj
  set add_leader $address::($add_obj,add_leader)
  PB_int_GetWordVarDesc WordDescArray
  if { [info exists WordDescArray($word)] } \
  {
   set list_len [llength $WordDescArray($word)]
   PB_int_RetMOMVarAsscAddress word word_mom_var_list
  } else \
  {
   set list_len 0
  }
  if { $list_len == 0} \
  {
   set index 0
   $comb_widget add command -label $word \
   -command "UI_PB_blk_CombSelection $page_obj $word $index"
  } else \
  {
   $comb_widget add cascade -label $word -menu  $comb_widget.m$no_of_addr
   catch {destroy $comb_widget.m$no_of_addr}
   menu $comb_widget.m$no_of_addr
   for {set count 0} {$count < $list_len} {incr count} \
   {
    set mom_var [lindex $word_mom_var_list $count]
    set desc [lindex $WordDescArray($word) $count]
    PB_com_MapMOMVariable mom_sys_arr add_obj mom_var app_text
    PB_int_ApplyFormatAppText add_obj app_text
    append sublabel $add_leader $app_text - $desc
    $comb_widget.m$no_of_addr add command  -label $sublabel \
    -command "UI_PB_blk_CombSelection $page_obj $word $count"
    unset sublabel
   }
   append sublabel $add_leader - "User Defined Expression"
   $comb_widget.m$no_of_addr add command  -label $sublabel \
   -command "UI_PB_blk_CombSelection $page_obj $word $count"
   unset sublabel
   incr no_of_addr
  }
 }

#=======================================================================
proc UI_PB_blk_CreateMenuOptions { PAGE_OBJ page_type } {
  upvar $PAGE_OBJ page_obj
  global gPB
  set comb_widget $Page::($page_obj,comb_widget)
  $comb_widget delete 0 end
  $comb_widget add command -label "$gPB(block,new_combo,Label)" \
  -command "UI_PB_blk_CombSelection $page_obj New_Address 0"
  $comb_widget add command -label "$gPB(block,text_combo,Label)" \
  -command "UI_PB_blk_CombSelection $page_obj Text 0"
  $comb_widget add separator
  if { $page_type == "event" } \
  {
   $comb_widget add command -label "$gPB(block,oper_combo,Label)" \
   -command "UI_PB_blk_CombSelection $page_obj Comment 0"
   $comb_widget add cascade -label "$gPB(block,comm_combo,Label)" \
   -menu $comb_widget.cmd
   set word "Command"
   PB_int_RetMOMVarAsscAddress word cmd_proc_list
   catch {destroy $comb_widget.cmd}
   menu $comb_widget.cmd
   for {set count 0} {$count < [llength $cmd_proc_list]} {incr count} \
   {
    set cmd_name [lindex $cmd_proc_list $count]
    $comb_widget.cmd add command  -label $cmd_name \
    -command "UI_PB_blk_CombSelection $page_obj $word $count"
   }
   $comb_widget add separator
  }
  UI_PB_blk_GetActiveAddresses page_obj
  set basewords_length [llength $Page::($page_obj,blk_WordNameList)]
  if {$basewords_length > 20} \
  {
   set no_options 20
  } else \
  {
   set no_options $basewords_length
  }
  set no_of_addr 0
  for {set ii 0} {$ii < $no_options} {incr ii} \
  {
   UI_PB_blk_CreateMenuElement page_obj $comb_widget $ii no_of_addr
  }
  if {$no_options < $basewords_length} \
  {
   set no_of_addr 0
   $comb_widget add cascade -label More -menu $comb_widget.more
   catch {destroy $comb_widget.more}
   menu $comb_widget.more
   set comb_widget $comb_widget.more
   for {set jj $no_options} {$jj < $basewords_length} {incr jj} \
   {
    UI_PB_blk_CreateMenuElement page_obj $comb_widget $jj no_of_addr
   }
  }
  set comb_label_desc [lindex $Page::($page_obj,blk_WordNameList) 0]
  UI_PB_blk_CombSelection $page_obj $comb_label_desc 0
 }

#=======================================================================
proc UI_PB_blk_CreateBlockCells { PAGE_OBJ BLOCK_OBJ ACTIVE_BLK_ELEM_OBJ \
  BLOCK_OWNER } {
  upvar $PAGE_OBJ page_obj
  upvar $BLOCK_OBJ block_obj
  upvar $ACTIVE_BLK_ELEM_OBJ active_blk_elem_obj
  upvar $BLOCK_OWNER block_owner
  global paOption
  set cell_color paleturquoise
  set divi_color turquoise
  set main_cell_color $paOption(can_bg)
  set c $Page::($page_obj,bot_canvas)
  set Page::($page_obj,active_blk_obj) $block_obj
  if { $block::($block_obj,active_blk_elem_list) != ""} \
  {
   set no_of_elements [llength $block::($block_obj,active_blk_elem_list)]
  } else \
  {
   set no_of_elements 0
  }
  set h_cell $Page::($page_obj,h_cell)       
  set w_cell $Page::($page_obj,w_cell)       
  set w_divi $Page::($page_obj,w_divi)       
  set x_orig $Page::($page_obj,x_orig)       
  set y_orig $Page::($page_obj,y_orig)
  set n_comp $no_of_elements
  set x0 $x_orig
  set y0 $y_orig
  set x1 [expr $x0 + [expr [expr $w_divi + $w_cell] * $n_comp] + \
  $w_divi + [expr 2 * $w_divi]]
  set y1 [expr $y0 + $h_cell + [expr 2 * $w_divi]]
  set block::($block_obj,rect) [UI_PB_com_CreateRectangle $c $x0 $y0 $x1 $y1 \
  $main_cell_color $main_cell_color]
  set block::($block_obj,blk_h) $y1
  set block::($block_obj,blk_w) $x1
  $c lower $block::($block_obj,rect)
  set block::($block_obj,rect_x0) $x0
  set block::($block_obj,rect_y0) $y0
  set block::($block_obj,rect_x1) $x1
  set block::($block_obj,rect_y1) $y1
  set x0 [expr $x_orig + $w_divi]
  set y0 [expr $y_orig + $w_divi]
  set yc [expr $y0 + [expr $h_cell / 2]]
  for {set i 0} {$i < $n_comp} {incr i 1} {
   set blk_elem_obj [lindex $block::($block_obj,active_blk_elem_list) $i]
   set j  [expr 2 * $i]
   set y1 [expr $y0 + $h_cell]
   set x1 [expr $x0 + $w_divi]
   set block_element::($blk_elem_obj,div_corn_x0) $x0
   set block_element::($blk_elem_obj,div_corn_y0) $y0
   set block_element::($blk_elem_obj,div_corn_x1) $x1
   set block_element::($blk_elem_obj,div_corn_y1) $y1
   set block_element::($blk_elem_obj,div_id) [UI_PB_com_CreateRectangle $c \
   $x0 $y0 $x1 $y1 $divi_color $divi_color ]
   set k [expr $j + 1]
   set x0 $x1
   set x1 [expr $x0 + $w_cell]
   set block_element::($blk_elem_obj,rect_corn_x0)   $x0
   set block_element::($blk_elem_obj,rect_corn_y0)   $y0
   set block_element::($blk_elem_obj,rect_corn_x1)   $x1
   set block_element::($blk_elem_obj,rect_corn_y1)   $y1
   set block_element::($blk_elem_obj,rect) [UI_PB_com_CreateRectangle $c \
   $x0 $y0 $x1 $y1 $cell_color $divi_color]
   set xc [expr [expr $x0 + $x1] / 2]
   append opt_img pb_ $block_element::($blk_elem_obj,elem_opt_nows_var)
   if { $block_element::($blk_elem_obj,force) } \
   {
    append opt_img _f
   }
   set name_addr [tix getimage $opt_img]
   unset opt_img
   $block_element::($blk_elem_obj,blk_img) add image -image $name_addr
   set blk_elem_owner $block_element::($blk_elem_obj,owner)
   set blk_elem_add_obj $block_element::($blk_elem_obj,elem_add_obj)
   if { $blk_elem_add_obj == "Command" || \
   $blk_elem_add_obj == "Comment" } \
   {
    set address_name $blk_elem_add_obj
   } else \
   {
    set address_name $address::($blk_elem_add_obj,add_name)
   }
   if {[string compare $blk_elem_owner $block_owner] == 0} \
   {
    set icon_id [$c create image  $xc $yc \
    -image $block_element::($blk_elem_obj,blk_img) -tag movable]
   } else \
   {
    set icon_id [$c create image  $xc $yc \
    -image $block_element::($blk_elem_obj,blk_img) -tag nonmovable]
    set im [$c itemconfigure $icon_id -image]
    [lindex $im end] configure -relief flat
   }
   if {[string compare $address_name "Text"] == 0} \
   {
    set im [$c itemconfigure $icon_id -image]
    [lindex $im end] configure -bg $paOption(text)
   }
   set block_element::($blk_elem_obj,icon_id) $icon_id
   set block_element::($blk_elem_obj,xc)   $xc
   set block_element::($blk_elem_obj,yc)   $yc
   set x0 $x1
  }
  if {[info exists k] == 1} \
  {
   set k [expr $k + 1]
  } else \
  {
   set k 0
  }
  set x1 [expr $x0 + $w_divi]
  set y1 [expr $y0 + $h_cell]
  set block::($block_obj,div_corn_x0)   $x0
  set block::($block_obj,div_corn_y0)   $y0
  set block::($block_obj,div_corn_x1)   $x1
  set block::($block_obj,div_corn_y1)   $y1
  set block::($block_obj,div_id) [UI_PB_com_CreateRectangle $c $x0 $y0 \
  $x1 $y1 $divi_color $divi_color]
  if {$active_blk_elem_obj != 0} \
  {
   set im [$c itemconfigure $block_element::($active_blk_elem_obj,icon_id) \
   -image]
   [lindex $im end] configure -relief sunken -bg pink
   set Page::($page_obj,active_blk_elem) $active_blk_elem_obj
  }
 }

#=======================================================================
proc UI_PB_blk_IconUnBindProcs { PAGE_OBJ } {
  upvar $PAGE_OBJ page_obj
  set bot_canvas $Page::($page_obj,bot_canvas)
  $bot_canvas bind movable <1> ""
  $bot_canvas bind movable <B1-Motion> ""
  $bot_canvas bind movable <Enter> ""
  $bot_canvas bind movable <Leave> ""
  $bot_canvas bind movable <ButtonRelease-1> ""
  $bot_canvas bind movable <3> ""
  $bot_canvas bind nonmovable <1> ""
  $bot_canvas bind nonmovable <Enter> ""
  $bot_canvas bind nonmovable <Leave> ""
  $bot_canvas bind nonmovable <3> ""
 }

#=======================================================================
proc UI_PB_blk_IconBindProcs {PAGE_OBJ} {
  upvar $PAGE_OBJ page_obj
  set bot_canvas $Page::($page_obj,bot_canvas)
  $bot_canvas bind movable <1>          "UI_PB_blk_StartDragAddr $page_obj \
  %x %y"
  $bot_canvas bind movable <B1-Motion>  "UI_PB_blk_DragAddr    $page_obj \
  %x %y"
  $bot_canvas bind movable <Enter>      "UI_PB_blk_AddrFocusOn $page_obj \
  %x %y"
  $bot_canvas bind movable <Leave>      "UI_PB_blk_AddrFocusOff $page_obj"
  $bot_canvas bind movable <ButtonRelease-1> "UI_PB_blk_EndDragAddr  \
  $page_obj"
  $bot_canvas bind movable <3>          "UI_PB_blk_BindRightButton $page_obj \
  %x %y"
  $bot_canvas bind nonmovable <1>       "UI_PB_blk_StartDragAddr $page_obj \
  %x %y"
  $bot_canvas bind nonmovable <Enter>   "UI_PB_blk_AddrFocusOn $page_obj \
  %x %y"
  $bot_canvas bind nonmovable <Leave>   "UI_PB_blk_AddrFocusOff $page_obj"
  $bot_canvas bind nonmovable <3>       "UI_PB_blk_NonMovableRightButton \
  $page_obj %x %y"
 }

#=======================================================================
proc UI_PB_blk_ConfigureLeader { PAGE_OBJ ACTIVE_BLK_ELEM } {
  upvar $PAGE_OBJ page_obj
  upvar $ACTIVE_BLK_ELEM active_blk_elem_obj
  global mom_sys_arr
  if {![info exist Page::($page_obj,trailer)]} { return }
  if {$active_blk_elem_obj} \
  {
   set addr_obj $block_element::($active_blk_elem_obj,elem_add_obj)
   set addr_name $address::($addr_obj,add_name)
   set blk_elem_mom_var \
   $block_element::($active_blk_elem_obj,elem_mom_variable)
   PB_com_MapMOMVariable mom_sys_arr addr_obj blk_elem_mom_var blk_elem_text
   PB_int_ApplyFormatAppText addr_obj blk_elem_text
   PB_int_GetElemDisplayAttr addr_name blk_elem_text blk_elm_attr
   } else {
   set blk_elm_attr(0) ""
   set blk_elm_attr(1) ""
   set blk_elm_attr(2) ""
  }
  if {[string compare $blk_elm_attr(0) ""]} \
  {
   if {$Page::($page_obj,lead_flag) == 1} \
   {
    grid $Page::($page_obj,addr) -row 1 -column 1 -pady 10
    $Page::($page_obj,addr) configure -text $blk_elm_attr(0)
    set Page::($page_obj,lead_flag) 0
   } else \
   {
    $Page::($page_obj,addr) configure -text $blk_elm_attr(0)
   }
  } else \
  {
   if {$Page::($page_obj,lead_flag) == 0} \
   {
    grid forget $Page::($page_obj,addr)
    set Page::($page_obj,lead_flag) 1
   }
  }
  if {[string compare $blk_elm_attr(1) ""]} \
  {
   if {$Page::($page_obj,fmt_flag) == 1} \
   {
    grid $Page::($page_obj,fmt) -row 1 -column 2 -pady 10
    $Page::($page_obj,fmt) configure -text $blk_elm_attr(1)
    set Page::($page_obj,fmt_flag) 0
   } else \
   {
    $Page::($page_obj,fmt) configure -text $blk_elm_attr(1)
   }
  } else \
  {
   if {$Page::($page_obj,fmt_flag) == 0} \
   {
    grid forget $Page::($page_obj,fmt)
    set Page::($page_obj,fmt_flag) 1
   }
  }
  if {[string compare $blk_elm_attr(2) ""]} \
  {
   if {$Page::($page_obj,trl_flag) == 1} \
   {
    grid $Page::($page_obj,trailer) -row 1 -column 3 -pady 10
    $Page::($page_obj,trailer) configure -text $blk_elm_attr(2)
    set Page::($page_obj,trl_flag) 0
   } else \
   {
    $Page::($page_obj,trailer) configure -text $blk_elm_attr(2)
   }
  } else \
  {
   if {$Page::($page_obj,trl_flag) == 0} \
   {
    grid forget $Page::($page_obj,trailer)
    set Page::($page_obj,trl_flag) 1
   }
  }
 }

#=======================================================================
proc UI_PB_blk_NonMovableRightButton { page_obj x y } {
  set block_obj $Page::($page_obj,active_blk_obj)
  set active_blk_elem $block::($block_obj,active_blk_elem)
  UI_PB_blk_NonMovableElemPopup page_obj block_obj active_blk_elem $x $y
  if { [info exists Page::($page_obj,being_dragged)] &&
  $Page::($page_obj,being_dragged) } \
  {
   UI_PB_blk_EndDragAddr $page_obj
  }
 }

#=======================================================================
proc UI_PB_blk_NonMovableElemPopup { PAGE_OBJ ACT_BLK_OBJ ACTIVE_BLK_ELEM \
  x y } {
  upvar $PAGE_OBJ page_obj
  upvar $ACT_BLK_OBJ act_blk_obj
  upvar $ACTIVE_BLK_ELEM active_blk_elem
  global gPB
  global paOption
  global popupvar
  set bot_canvas $Page::($page_obj,bot_canvas)
  set xx [$bot_canvas canvasx $x]
  set yy [$bot_canvas canvasy $y]
  if { $block_element::($active_blk_elem,elem_add_obj) == "Command" ||
  $block_element::($active_blk_elem,elem_add_obj) == "Comment" } \
  {
   set base_addr $block_element::($active_blk_elem,elem_add_obj)
   set add_leader ""
  } else \
  {
   set addr_obj $block_element::($active_blk_elem,elem_add_obj)
   set base_addr $address::($addr_obj,add_name)
   set add_leader $address::($addr_obj,add_leader)
  }
  set blockpopup $Page::($page_obj,blockpopup)
  set canvas_frame $Page::($page_obj,canvas_frame)
  UI_PB_blk_GetOptionImageName \
  $block_element::($active_blk_elem,elem_opt_nows_var) popupvar
  set popupvar(2) $block_element::($active_blk_elem,force)
  $blockpopup delete 0 end
  if { $base_addr == "Command" || $base_addr == "Comment" } \
  {
   $blockpopup add checkbutton -label "$gPB(block,opt_popup,Label)" \
   -state disabled
  } else \
  {
   $blockpopup add checkbutton -label "$gPB(block,opt_popup,Label)" \
   -variable popupvar(1) -state normal \
   -command "UI_PB_blk_AddNowsOpt $page_obj popupvar \
   $base_addr $active_blk_elem"
  }
  if { $base_addr == "Command" || $base_addr == "Comment" } \
  {
   $blockpopup add checkbutton -label "$gPB(block,no_sep_popup,Label)" \
   -state disabled
  } else \
  {
   $blockpopup add checkbutton -label "$gPB(block,no_sep_popup,Label)" \
   -variable popupvar(0)  -state normal \
   -command "UI_PB_blk_AddNowsOpt $page_obj popupvar \
   $base_addr $active_blk_elem"
  }
  if { $base_addr == "Command" || $base_addr == "Comment" } \
  {
   $blockpopup add checkbutton -label "$gPB(block,force_popup,Label)" \
   -state disabled
  } else \
  {
   $blockpopup add checkbutton -label "$gPB(block,force_popup,Label)" \
   -variable popupvar(2)  -state normal \
   -command "UI_PB_blk_AddForceOpt $page_obj popupvar \
   $base_addr $active_blk_elem"
  }
  set Page::($page_obj,block_popup_flag) 1
 }

#=======================================================================
proc UI_PB_blk_BindRightButton {page_obj x y} {
  set block_obj $Page::($page_obj,active_blk_obj)
  set active_blk_elem $block::($block_obj,active_blk_elem)
  UI_PB_blk_BlockPopupMenu page_obj block_obj active_blk_elem $x $y
  if { [info exists Page::($page_obj,being_dragged)] &&
  $Page::($page_obj,being_dragged) } \
  {
   UI_PB_blk_EndDragAddr $page_obj
  }
 }

#=======================================================================
proc UI_PB_blk_BlockPopupMenu { PAGE_OBJ ACT_BLK_OBJ ACTIVE_BLK_ELEM x y } {
  upvar $PAGE_OBJ page_obj
  upvar $ACT_BLK_OBJ act_blk_obj
  upvar $ACTIVE_BLK_ELEM active_blk_elem
  global paOption
  global popupvar
  global mom_sys_arr
  global gPB
  set bot_canvas $Page::($page_obj,bot_canvas)
  set xx [$bot_canvas canvasx $x]
  set yy [$bot_canvas canvasy $y]
  PB_int_GetWordVarDesc WordDescArray
  if { $block_element::($active_blk_elem,elem_add_obj) == "Command" ||
  $block_element::($active_blk_elem,elem_add_obj) == "Comment" } \
  {
   set base_addr $block_element::($active_blk_elem,elem_add_obj)
   set add_leader ""
  } else \
  {
   set addr_obj $block_element::($active_blk_elem,elem_add_obj)
   set base_addr $address::($addr_obj,add_name)
   set add_leader $address::($addr_obj,add_leader)
  }
  set blockpopup $Page::($page_obj,blockpopup)
  set canvas_frame $Page::($page_obj,canvas_frame)
  UI_PB_blk_GetOptionImageName \
  $block_element::($active_blk_elem,elem_opt_nows_var) popupvar
  set popupvar(2) $block_element::($active_blk_elem,force)
  $blockpopup delete 0 end
  if { [string match "*MOM_*" \
  $block_element::($active_blk_elem,elem_mom_variable)] == 0} \
  {
   $blockpopup add command -label "$gPB(block,edit_popup,Label)" \
   -state normal \
   -command "UI_PB_blk_EditAddress $page_obj $act_blk_obj $active_blk_elem"
  }
  if { $base_addr == "Command" || $base_addr == "Comment" } \
  {
   $blockpopup add command -label "$gPB(block,change_popup,Label)" \
   -state disabled
  } else \
  {
   $blockpopup add cascade -label "$gPB(block,change_popup,Label)" \
   -menu $blockpopup.change -state normal
   catch {destroy $blockpopup.change}
   menu $blockpopup.change
   PB_int_RetMOMVarAsscAddress base_addr word_mom_var_list
   set mom_var_length [llength $word_mom_var_list]
   for {set count 0} {$count < $mom_var_length} {incr count} \
   {
    set subdesc [lindex $WordDescArray($base_addr) $count]
    if {[string match $subdesc \
    $block_element::($active_blk_elem,elem_desc)] == 0} \
    {
     set mom_var [lindex $word_mom_var_list $count]
     PB_com_MapMOMVariable mom_sys_arr addr_obj mom_var app_text
     PB_int_ApplyFormatAppText addr_obj app_text
     append sublabel $add_leader $app_text - $subdesc
     $blockpopup.change add command -label $sublabel \
     -command "UI_PB_blk_PopupSelection $page_obj \
     $base_addr $count $active_blk_elem"
     unset sublabel
    }
   }
   $blockpopup.change add command -label "$gPB(block,user_popup,Label)" \
   -command "UI_PB_blk_PopupSelection $page_obj \
   $base_addr $count $active_blk_elem"
  }
  if { $base_addr == "Command" || $base_addr == "Comment" } \
  {
   $blockpopup add checkbutton -label "$gPB(block,opt_popup,Label)" \
   -state disabled
  } else \
  {
   $blockpopup add checkbutton -label "$gPB(block,opt_popup,Label)" \
   -variable popupvar(1) -state normal \
   -command "UI_PB_blk_AddNowsOpt $page_obj popupvar \
   $base_addr $active_blk_elem"
  }
  if { $base_addr == "Command" || $base_addr == "Comment" } \
  {
   $blockpopup add checkbutton -label "$gPB(block,no_sep_popup,Label)" \
   -state disabled
  } else \
  {
   $blockpopup add checkbutton -label "$gPB(block,no_sep_popup,Label)" \
   -variable popupvar(0)  -state normal \
   -command "UI_PB_blk_AddNowsOpt $page_obj popupvar \
   $base_addr $active_blk_elem"
  }
  if { $base_addr == "Command" || $base_addr == "Comment" } \
  {
   $blockpopup add checkbutton -label "$gPB(block,force_popup,Label)" \
   -state disabled
  } else \
  {
   $blockpopup add checkbutton -label "$gPB(block,force_popup,Label)" \
   -variable popupvar(2)  -state normal \
   -command "UI_PB_blk_AddForceOpt $page_obj popupvar \
   $base_addr $active_blk_elem"
  }
  $blockpopup add sep
  $blockpopup add command -label "$gPB(block,delete_popup,Label)" \
  -state normal \
  -command "UI_PB_blk_DeleteBlockElement $page_obj \
  $active_blk_elem"
  set Page::($page_obj,block_popup_flag) 1
 }

#=======================================================================
proc UI_PB_blk_ActivateBlkPageWidgets { page_obj win_index } {
  global gPB
  global popupvar
  if { $gPB(toplevel_disable_$win_index) } \
  {
   tixEnableAll $Page::($page_obj,page_id)
   set top_canvas $Page::($page_obj,top_canvas)
   set bot_canvas $Page::($page_obj,bot_canvas)
   UI_PB_blk_AddBindProcs page_obj
   bind $bot_canvas <3> "UI_PB_blk_CanvasPopupMenu $page_obj popupvar %X %Y"
   if { [info exists Page::($page_obj,event_obj)] } \
   {
    set event_obj $Page::($page_obj,event_obj)
    UI_PB_tpth_IconBindProcs page_obj event_obj
    $top_canvas bind add_movable <B1-Motion> \
    "UI_PB_tpth_ItemDrag1 $page_obj $event_obj %x %y"
    $top_canvas bind add_movable <ButtonRelease-1> \
    "UI_PB_tpth_ItemEndDrag1 $page_obj $event_obj %x %y"
   } else \
   {
    UI_PB_blk_IconBindProcs page_obj
    $top_canvas bind add_movable <B1-Motion> \
    "UI_PB_blk_ItemDrag1 $page_obj %x %y"
    $top_canvas bind add_movable <ButtonRelease-1> \
    "UI_PB_blk_ItemEndDrag1 $page_obj %x %y"
   }
   if { [info exists Page::($page_obj,tree)] } \
   {
    set t $Page::($page_obj,tree)
    set h [$t subwidget hlist]
    UI_PB_com_EnableTree $h [$h info children 0]
   }
   set top_canvas $Page::($page_obj,top_canvas)
   $top_canvas.f.ent config -state disabled
   set gPB(toplevel_disable_$win_index) 0
  }
 }

#=======================================================================
proc UI_PB_blk_DisableBlkPageWidgets { page_obj } {
  tixDisableAll $Page::($page_obj,page_id)
  UI_PB_blk_IconUnBindProcs page_obj
  UI_PB_blk_AddUnBindProcs page_obj
  if { [info exists Page::($page_obj,tree)] } \
  {
   set t $Page::($page_obj,tree)
   set h [$t subwidget hlist]
   UI_PB_com_DisableTree $h [$h info children 0] GRAY
  }
  set bot_canvas $Page::($page_obj,bot_canvas)
  set top_canvas $Page::($page_obj,top_canvas)
  $bot_canvas config -cursor ""
  $top_canvas config -cursor ""
  bind $bot_canvas <3> ""
 }

#=======================================================================
proc UI_PB_blk_EditAddress { blk_page_obj act_blk_obj active_blk_elem } {
  global gPB
  set canvas_frame $Page::($blk_page_obj,canvas_frame)
  if { $block_element::($active_blk_elem,elem_add_obj) == "Command" } \
  {
   set cmd_name $block_element::($active_blk_elem,elem_mom_variable)
   set window_title "$gPB(block,cmd_title,Label)"
   } elseif { $block_element::($active_blk_elem,elem_add_obj) == "Comment" } \
  {
   set window_title "$gPB(block,oper_title,Label)"
  } else \
  {
   set add_obj $block_element::($active_blk_elem,elem_add_obj)
   address::readvalue $add_obj ADDRESSOBJATTR
   set window_title "$gPB(block,addr_title,Label) : $ADDRESSOBJATTR(0)"
  }
  set win [toplevel $canvas_frame.add]
  set toplevel_index [llength $gPB(toplevel_list)]
  set win_index [expr $toplevel_index + 1]
  set gPB(toplevel_disable_$win_index) 1
  UI_PB_com_CreateTransientWindow $win "$window_title" "500x600+100+200" \
  "UI_PB_blk_DisableBlkPageWidgets $blk_page_obj" "" \
  "UI_PB_blk_ActivateBlkPageWidgets $blk_page_obj $win_index"
  if { $block_element::($active_blk_elem,elem_add_obj) == "Command" } \
  {
   UI_PB_tpth_EditCmdBlock $win $blk_page_obj $act_blk_obj $active_blk_elem
   } elseif { $block_element::($active_blk_elem,elem_add_obj) == "Comment" } \
  {
   UI_PB_tpth_EditCommentBlock $win $blk_page_obj $act_blk_obj $active_blk_elem
  } else \
  {
   UI_PB_blk_BringUpBlkElemPage $win $blk_page_obj $active_blk_elem
  }
 }

#=======================================================================
proc UI_PB_blk_BringUpBlkElemPage { win blk_page_obj active_blk_elem } {
  global elem_text_var
  set add_obj $block_element::($active_blk_elem,elem_add_obj)
  UI_PB_addr_CreateAddressPage $win $add_obj new_add_page
  set expr_frm [frame $win.expr]
  pack $expr_frm -side top
  set elem_text_var $block_element::($active_blk_elem,elem_mom_variable)
  label $expr_frm.lab -text Expression -anchor w
  entry $expr_frm.ent -textvariable elem_text_var -width 25 -relief sunken
  if { [string match User* $block_element::($active_blk_elem,elem_desc)] }\
  {
   $expr_frm.ent config -state normal -bg white
  } else \
  {
   $expr_frm.ent config -state disabled -bg lightBlue
  }
  pack $expr_frm.lab -side left  -pady 10
  pack $expr_frm.ent -side right -pady 10 -padx 10
  focus $expr_frm.ent
  global gPB
  set gPB(c_help,$expr_frm.ent)          "address,exp"
  set bot_frm $Page::($new_add_page,bottom_frame)
  set cb_arr(gPB(nav_button,default,Label)) \
  "UI_PB_addr_AddDefaultCallBack $new_add_page"
  set cb_arr(gPB(nav_button,restore,Label)) \
  "UI_PB_addr_AddRestoreCallBack $new_add_page"
  set cb_arr(gPB(nav_button,cancel,Label)) \
  "UI_PB_add_EditCancelCallBack $new_add_page $win"
  set cb_arr(gPB(nav_button,ok,Label)) \
  "UI_PB_add_EditOkCallBack $blk_page_obj \
  $new_add_page $win $active_blk_elem"
  UI_PB_com_CreateActionElems $bot_frm cb_arr
 }

#=======================================================================
proc UI_PB_blk_NewAddress { BLK_PAGE_OBJ EVENT_OBJ EVT_ELEM_OBJ NEW_ELEM_OBJ \
  page_name } {
  upvar $BLK_PAGE_OBJ blk_page_obj
  upvar $EVENT_OBJ event_obj
  upvar $EVT_ELEM_OBJ evt_elem_obj
  upvar $NEW_ELEM_OBJ new_elem_obj
  global elem_text_var
  global gPB
  global paOption
  set canvas_frame $Page::($blk_page_obj,canvas_frame)
  set add_obj $block_element::($new_elem_obj,elem_add_obj)
  address::readvalue $add_obj ADDRESSOBJATTR
  set add_name [string tolower $ADDRESSOBJATTR(0)]
  set win [toplevel $canvas_frame.new_add]
  set toplevel_index [llength $gPB(toplevel_list)]
  set win_index [expr $toplevel_index + 1]
  set gPB(toplevel_disable_$win_index) 1
  UI_PB_com_CreateTransientWindow $win \
  "$gPB(block,new_trans,title,Label) : $ADDRESSOBJATTR(0)" \
  "500x600+100+200" "UI_PB_blk_DisableBlkPageWidgets $blk_page_obj" "" \
  "UI_PB_blk_ActivateBlkPageWidgets $blk_page_obj $win_index"
  UI_PB_addr_CreateAddressPage $win $add_obj new_add_page
  set expr_frm [frame $win.expr]
  pack $expr_frm -side top -pady 10
  set elem_text_var ""
  label $expr_frm.lab -text "$gPB(block,user,expr,Label)" -anchor w
  entry $expr_frm.ent -textvariable elem_text_var -width 24 -relief sunken
  pack $expr_frm.lab -side left -fill both -padx 10 -pady 10
  pack $expr_frm.ent -side right -fill both -padx 5 -pady 10
  focus $expr_frm.ent
  set bot_frm $Page::($new_add_page,bottom_frame)
  set cb_arr(gPB(nav_button,default,Label)) \
  "UI_PB_addr_AddDefaultCallBack $new_add_page"
  set cb_arr(gPB(nav_button,restore,Label)) \
  "UI_PB_addr_AddRestoreCallBack $new_add_page"
  if { $page_name == "block" } \
  {
   set cb_arr(gPB(nav_button,cancel,Label)) \
   "UI_PB_add_NewBlkCancelCallBack $blk_page_obj \
   $new_add_page $win $new_elem_obj"
   } elseif { $page_name == "event" } \
  {
   set cb_arr(gPB(nav_button,cancel,Label)) \
   "UI_PB_add_NewEvtCancelCallBack $blk_page_obj \
   $event_obj $evt_elem_obj $new_add_page $win $new_elem_obj"
  }
  set cb_arr(gPB(nav_button,ok,Label)) \
  "UI_PB_add_NewOkCallBack $blk_page_obj $new_add_page \
  $win $new_elem_obj $page_name"
  UI_PB_com_CreateActionElems $bot_frm cb_arr
 }

#=======================================================================
proc UI_PB_blk_GetOptionImageName {optimagname POPUPVAR} {
  upvar $POPUPVAR popupvar
  switch $optimagname \
  {
   "both"  {
    set popupvar(0) 1
    set popupvar(1) 1
   }
   "nows"  {
    set popupvar(0) 1
    set popupvar(1) 0
   }
   "opt"   {
    set popupvar(0) 0
    set popupvar(1) 1
   }
   "blank" {
    set popupvar(0) 0
    set popupvar(1) 0
   }
  }
 }

#=======================================================================
proc UI_PB_blk_AddForceOpt { page_obj POPUPVAR base_addr active_blk_elem } {
  upvar $POPUPVAR popupvar
  set block_element::($active_blk_elem,force) $popupvar(2)
  UI_PB_blk_ReplaceIcon page_obj $base_addr $active_blk_elem
 }

#=======================================================================
proc UI_PB_blk_AddNowsOpt {page_obj POPUPVAR base_addr active_blk_elem } {
  upvar $POPUPVAR popupvar
  if {$popupvar(0) == 1 && $popupvar(1) == 1} \
  {
   set block_element::($active_blk_elem,elem_opt_nows_var) both
   } elseif {$popupvar(0) == 0 && $popupvar(1) == 1} \
  {
   set block_element::($active_blk_elem,elem_opt_nows_var) opt
   } elseif {$popupvar(0) == 1 && $popupvar(1) == 0} \
  {
   set block_element::($active_blk_elem,elem_opt_nows_var) nows
  } else \
  {
   set block_element::($active_blk_elem,elem_opt_nows_var) blank
  }
  UI_PB_blk_ReplaceIcon page_obj $base_addr $active_blk_elem
 }

#=======================================================================
proc UI_PB_blk_PopupSelection {page_obj base_addr sel_index blk_elem_obj} {
  set bot_canvas $Page::($page_obj,bot_canvas)
  PB_int_GetWordVarDesc WordDescArray
  PB_int_GetNewBlockElement base_addr sel_index word_mom_var
  if { $word_mom_var == "" } \
  {
   set word_mom_var $block_element::($blk_elem_obj,elem_mom_variable)
   UI_PB_com_CreateTextEntry page_obj blk_elem_obj Expression
   tkwait window $bot_canvas.txtent
   if { [string compare $block_element::($blk_elem_obj,elem_mom_variable) \
   "000"] == 0 } \
   {
    set block_element::($blk_elem_obj,elem_mom_variable) $word_mom_var
    return
   }
   set block_element::($blk_elem_obj,elem_desc) "User Defined Expression"
  } else \
  {
   set sel_subdesc [lindex $WordDescArray($base_addr) $sel_index]
   set block_element::($blk_elem_obj,elem_mom_variable) $word_mom_var
   set block_element::($blk_elem_obj,elem_desc) $sel_subdesc
  }
  UI_PB_blk_ReplaceIcon page_obj $base_addr $blk_elem_obj
  UI_PB_blk_ConfigureLeader page_obj blk_elem_obj
 }

#=======================================================================
proc UI_PB_blk_ReplaceIcon {PAGE_OBJ base_addr blk_elem_obj} {
  upvar $PAGE_OBJ page_obj
  global paOption
  set bot_canvas $Page::($page_obj,bot_canvas)
  if { $block_element::($blk_elem_obj,elem_add_obj) == "Command" || \
  $block_element::($blk_elem_obj,elem_add_obj) == "Comment" } \
  {
   set blk_elem_addr $block_element::($blk_elem_obj,elem_add_obj)
  } else \
  {
   set blk_elem_addr $block_element::($blk_elem_obj,elem_add_obj)
  }
  set blk_elem_mom_var $block_element::($blk_elem_obj,elem_mom_variable)
  UI_PB_com_RetImageAppdText blk_elem_addr blk_elem_mom_var \
  img_name blk_elem_text
  set img_id [UI_PB_blk_CreateIcon $bot_canvas $img_name $blk_elem_text]
  set xc [expr [expr $block_element::($blk_elem_obj,rect_corn_x0) + \
  $block_element::($blk_elem_obj,rect_corn_x1)] / 2]
  set yc [expr [expr $block_element::($blk_elem_obj,rect_corn_y0) + \
  $block_element::($blk_elem_obj,rect_corn_y1)] / 2]
  append opt_img pb_ $block_element::($blk_elem_obj,elem_opt_nows_var)
  if { $block_element::($blk_elem_obj,force) } \
  {
   append opt_img _f
  }
  $img_id add image -image [tix getimage $opt_img]
  unset opt_img
  set exist_icon_id $block_element::($blk_elem_obj,icon_id)
  set im [lindex [$bot_canvas itemconfigure $exist_icon_id -image] end]
  set relief_status [lindex [$im configure -relief] end]
  set tag_name [lindex [lindex [$bot_canvas itemconfigure $exist_icon_id -tag] end] 0]
  $bot_canvas delete $exist_icon_id
  set icon_id [$bot_canvas create image  $xc $yc -image $img_id -tag $tag_name]
  set block_element::($blk_elem_obj,icon_id) $icon_id
  if { $block_element::($blk_elem_obj,elem_add_obj) == "Command" || \
  $block_element::($blk_elem_obj,elem_add_obj) == "Comment" } \
  {
   set address_name $block_element::($blk_elem_obj,elem_add_obj)
  } else \
  {
   set blk_elem_add_obj $block_element::($blk_elem_obj,elem_add_obj)
   set address_name $address::($blk_elem_add_obj,add_name)
  }
  $img_id configure -relief $relief_status
  if {$relief_status == "sunken"} \
  {
   $img_id configure -bg pink
   set Page::($page_obj,active_blk_elem) $blk_elem_obj
   } elseif {[string compare $address_name "Text"] == 0} \
  {
   $img_id configure -bg $paOption(text)
  }
 }

#=======================================================================
proc UI_PB_blk_AddrFocusOn {page_obj x y} {
  global gPB_help_tips
  set c $Page::($page_obj,bot_canvas)
  set block_obj $Page::($page_obj,active_blk_obj)
  set active_blk_elem_list $block::($block_obj,active_blk_elem_list)
  set x [$c canvasx $x]
  set y [$c canvasy $y]
  foreach blk_elem_obj $active_blk_elem_list \
  {
   if {$x >= $block_element::($blk_elem_obj,rect_corn_x0) && \
   $x < $block_element::($blk_elem_obj,rect_corn_x1)} \
   {
    set Page::($page_obj,in_focus_elem) $blk_elem_obj
    global gPB
    if { $gPB(use_info) } {
     $c config -cursor question_arrow
     } else {
     $c config -cursor hand2
    }
    break
   }
  }
  if {$Page::($page_obj,in_focus_elem) != \
  $Page::($page_obj,out_focus_elem)} \
  {
   if { $Page::($page_obj,out_focus_elem) } \
   {
    set out_focus_elem $Page::($page_obj,out_focus_elem)
    $c itemconfigure $block_element::($out_focus_elem,rect) \
    -fill $Page::($page_obj,x_color)
   }
   set cell_highlight_color navyblue
   set in_focus_elem $Page::($page_obj,in_focus_elem)
   set Page::($page_obj,x_color) [lindex [$c itemconfigure \
   $block_element::($in_focus_elem,rect) -fill] end]
   $c itemconfigure $block_element::($in_focus_elem,rect) \
   -fill $cell_highlight_color
   set Page::($page_obj,out_focus_elem) $Page::($page_obj,in_focus_elem)
   if { $Page::($page_obj,in_focus_elem) } \
   {
    if {$gPB_help_tips(state)} \
    {
     global item_focus_on
     if {![info exists item_focus_on]} \
     {
      set item_focus_on 0
     }
     if {$item_focus_on == 0} \
     {
      UI_PB_blk_CreateBalloon page_obj
      set item_focus_on 1
     }
    }
    set block::($block_obj,active_blk_elem) $in_focus_elem
   }
  }
 }

#=======================================================================
proc UI_PB_blk_CreateBalloon { PAGE_OBJ } {
  upvar $PAGE_OBJ page_obj
  global mom_sys_arr
  set c $Page::($page_obj,bot_canvas)
  set in_focus_elem $Page::($page_obj,in_focus_elem)
  if { $block_element::($in_focus_elem,elem_add_obj) == "Command" } \
  {
   set add_leader ""
   set cmd_obj $block_element::($in_focus_elem,elem_mom_variable)
   if { [string match "*MOM_*" $cmd_obj] } \
   {
    set blk_elem_text $cmd_obj
   } else \
   {
    set blk_elem_text $command::($cmd_obj,name)
   }
   } elseif { $block_element::($in_focus_elem,elem_add_obj) == "Comment" } \
  {
   set add_leader ""
   if { $mom_sys_arr(Comment_Start) != "" } \
   {
    append temp_elem_text "$mom_sys_arr(Comment_Start) "
   }
   append temp_elem_text $block_element::($in_focus_elem,elem_mom_variable)
   if { $mom_sys_arr(Comment_End) != "" } \
   {
    append temp_elem_text " $mom_sys_arr(Comment_End)"
   }
   set blk_elem_text $temp_elem_text
   unset temp_elem_text
  } else \
  {
   set add_obj $block_element::($in_focus_elem,elem_add_obj)
   set add_leader $address::($add_obj,add_leader)
   set blk_elem_mom_var $block_element::($in_focus_elem,elem_mom_variable)
   PB_com_MapMOMVariable mom_sys_arr add_obj blk_elem_mom_var blk_elem_text
   PB_int_ApplyFormatAppText add_obj blk_elem_text
  }
  set elem_desc $block_element::($in_focus_elem,elem_desc)
  append desc $add_leader $blk_elem_text " - " $elem_desc
  global gPB_help_tips
  set desc [join [split $desc \$] \\\$]
  set gPB_help_tips($c) $desc
  unset desc
 }

#=======================================================================
proc UI_PB_blk_AddrFocusOff {page_obj} {
  set c $Page::($page_obj,bot_canvas)
  if { $Page::($page_obj,out_focus_elem) } \
  {
   set out_focus_elem $Page::($page_obj,out_focus_elem)
   $c itemconfigure $block_element::($out_focus_elem,rect) \
   -fill $Page::($page_obj,x_color)
  }
  set Page::($page_obj,in_focus_elem) 0
  set Page::($page_obj,out_focus_elem) 0
  $c config -cursor ""
  UI_PB_blk_DeleteBalloon page_obj
 }

#=======================================================================
proc UI_PB_blk_DeleteBalloon { PAGE_OBJ } {
  upvar $PAGE_OBJ page_obj
  global gPB_help_tips
  set c $Page::($page_obj,bot_canvas)
  if {$gPB_help_tips(state)} \
  {
   if [info exists gPB_help_tips($c)] {
    unset gPB_help_tips($c)
   }
   PB_cancel_balloon
   global item_focus_on
   set item_focus_on 0
  }
 }

#=======================================================================
proc UI_PB_blk_StartDragAddr {page_obj x y} {
  global paOption
  set Page::($page_obj,being_dragged) 1
  set c $Page::($page_obj,bot_canvas)
  set block_obj $Page::($page_obj,active_blk_obj)
  if {$Page::($page_obj,active_blk_elem)} \
  {
   set active_blk_elem $Page::($page_obj,active_blk_elem)
   set icon_id $block_element::($active_blk_elem,icon_id)
   set im [$c itemconfigure $icon_id -image]
   set icon_tag [lindex [$c itemconfigure $icon_id -tags] end]
   if {[string compare $icon_tag "nonmovable"] == 0} \
   {
    [lindex $im end] configure -relief flat -background #c0c0ff
   } else \
   {
    [lindex $im end] configure -relief raised -background #c0c0ff
   }
   set blk_elem_add_obj $block_element::($active_blk_elem,elem_add_obj)
   set address_name $address::($blk_elem_add_obj,add_name)
   if {[string compare $address_name "Text"] == 0} \
   {
    [lindex $im end] configure -background $paOption(text)
   }
  }
  $c raise current
  set im [$c itemconfigure current -image]
  set cur_img_tag [lindex [lindex [$c itemconfigure current -tags] end] 0]
  [lindex $im end] configure -relief sunken -background pink
  set xx [$c canvasx $x]
  set yy [$c canvasy $y]
  set active_blk_elem_list $block::($block_obj,active_blk_elem_list)
  foreach blk_elem_obj $active_blk_elem_list \
  {
   if {$xx >= $block_element::($blk_elem_obj,rect_corn_x0) && \
   $xx < $block_element::($blk_elem_obj,rect_corn_x1)} \
   {
    set focus_blk $blk_elem_obj
    set Page::($page_obj,source_elem_obj) $focus_blk
    set Page::($page_obj,active_blk_elem) $focus_blk
    break;
   }
  }
  UI_PB_blk_ConfigureLeader page_obj focus_blk
  if {[string compare $cur_img_tag "movable"] == 0} \
  {
   set origin_xb [$c canvasx $x]
   set origin_yb [$c canvasy $y]
   set Page::($page_obj,last_xb)   $origin_xb
   set Page::($page_obj,last_yb)   $origin_yb
   set panel_hi $Page::($page_obj,panel_hi)
   set dx 1
   set dy [expr $panel_hi + 2]
   set blk_elem_addr $block_element::($blk_elem_obj,elem_add_obj)
   set addr_leader $address::($blk_elem_addr,add_leader)
   set blk_elem_mom_var $block_element::($blk_elem_obj,elem_mom_variable)
   UI_PB_com_RetImageAppdText blk_elem_addr blk_elem_mom_var \
   image_name blk_elem_text
   set origin_xt [expr [expr $block_element::($focus_blk,rect_corn_x0) + \
   $block_element::($focus_blk,rect_corn_x1)] / 2]
   set origin_yt [expr [expr $block_element::($focus_blk,rect_corn_y0) + \
   $block_element::($focus_blk,rect_corn_y1)] / 2]
   set diff_x [expr $xx - $origin_xt]
   set diff_y [expr $yy - $origin_yt]
   set top_canvas $Page::($page_obj,top_canvas)
   set img_addr [UI_PB_blk_CreateIcon $top_canvas $image_name \
   $blk_elem_text]
   append opt_img pb_ $block_element::($focus_blk,elem_opt_nows_var)
   $img_addr add image -image [tix getimage $opt_img]
   unset opt_img
   set icon_top [$top_canvas create image \
   [expr $x - $dx - $diff_x] [expr $y + $dy - $diff_y] \
   -image $img_addr -tag new_comp]
   set Page::($page_obj,icon_top) $icon_top
   set last_xt [expr $x - $dx]
   set last_yt [expr $y + $dy]
   set Page::($page_obj,last_xt) $last_xt
   set Page::($page_obj,last_yt) $last_yt
   set im [$top_canvas itemconfigure $icon_top -image]
   [lindex $im end] configure -relief sunken -background pink
   $c bind movable <Enter> ""
   $c bind movable <Leave> ""
   UI_PB_com_ChangeCursor $c
  }
 }

#=======================================================================
proc UI_PB_blk_DragAddr {page_obj x y} {
  set c $Page::($page_obj,bot_canvas)
  set panel_hi $Page::($page_obj,panel_hi)
  set xc [$c canvasx $x]
  set yc [$c canvasy $y]
  $c move current [expr $xc - $Page::($page_obj,last_xb)] \
  [expr $yc - $Page::($page_obj,last_yb)]
  set dx 1
  set dy [expr $panel_hi + 2]
  set top_canvas $Page::($page_obj,top_canvas)
  set xp [$top_canvas canvasx $x]
  set yp [$top_canvas canvasy $y]
  $top_canvas move $Page::($page_obj,icon_top) \
  [expr $xp - $Page::($page_obj,last_xt) - $dx] \
  [expr $yp - $Page::($page_obj,last_yt) + $dy]
  set Page::($page_obj,last_xb) $xc
  set Page::($page_obj,last_yb) $yc
  set Page::($page_obj,last_xt) [expr $xp - $dx]
  set Page::($page_obj,last_yt) [expr $yp + $dy]
  UI_PB_blk_TrashFocusOn $page_obj $x $y
  set focus_blk_elem $Page::($page_obj,source_elem_obj)
  set addr_obj $block_element::($focus_blk_elem,elem_add_obj)
  set add_name $address::($addr_obj,add_name)
  if {[string compare $add_name "Text"] == 0} \
  {
   UI_PB_blk_HighLightCellDividers $page_obj $xc $yc
  }
 }

#=======================================================================
proc UI_PB_blk_TrashFocusOn {page_obj x y} {
  global paOption
  set panel_hi $Page::($page_obj,panel_hi)
  set trash_cell  $Page::($page_obj,trash)
  if {$x > [lindex $trash_cell 1] && $x < [lindex $trash_cell 2] && \
  $y > [lindex $trash_cell 3] && $y < [lindex $trash_cell 4]} \
  {
   [lindex $trash_cell 0] configure -background $paOption(focus)
   UI_PB_blk_TrashConnectLine page_obj
   set Page::($page_obj,trash_flag) 1
  } else \
  {
   [lindex $trash_cell 0] configure -background $paOption(app_butt_bg)
   set top_canvas $Page::($page_obj,top_canvas)
   $top_canvas delete connect_line
   set Page::($page_obj,trash_flag) 0
  }
 }

#=======================================================================
proc UI_PB_blk_EndDragAddr {page_obj} {
  global paOption
  set Page::($page_obj,being_dragged) 0
  set c $Page::($page_obj,bot_canvas)
  set target_cell_num 0
  set source_cell_num 0
  set block_obj $Page::($page_obj,active_blk_obj)
  if {$Page::($page_obj,add_flag) == 2} \
  {
   set prev_act_elem $Page::($page_obj,insert_elem)
   $c itemconfigure $block_element::($prev_act_elem,div_id) \
   -fill $Page::($page_obj,div_col) -outline $Page::($page_obj,div_col)
   $c delete connect_line
   } elseif {$Page::($page_obj,add_flag) == 3} \
  {
   $c itemconfigure $block::($block_obj,div_id) \
   -fill $Page::($page_obj,div_col) -outline $Page::($page_obj,div_col)
   $c delete connect_line
  }
  if { $Page::($page_obj,trash_flag) == 1 } \
  {
   UI_PB_blk_UpdateCells page_obj
   [lindex $Page::($page_obj,trash) 0] configure \
   -background $paOption(app_butt_bg)
   set Page::($page_obj,trash_flag) 0
   } elseif {$Page::($page_obj,add_flag)} \
  {
   UI_PB_blk_ChangeTextPosition page_obj
   set Page::($page_obj,add_flag) 0
  } else \
  {
   set source_elem_obj $Page::($page_obj,source_elem_obj)
   UI_PB_blk_ReturnAddr page_obj source_elem_obj
  }
  UI_PB_blk_DeleteBalloon page_obj
  $Page::($page_obj,top_canvas) delete $Page::($page_obj,icon_top)
  $Page::($page_obj,top_canvas) delete connect_line
  $c bind movable <Enter>           "UI_PB_blk_AddrFocusOn $page_obj \
  %x %y"
  $c bind movable <Leave>           "UI_PB_blk_AddrFocusOff $page_obj"
  $c config -cursor ""
  set last_xb $Page::($page_obj,last_xb)
  set last_yb $Page::($page_obj,last_yb)
  UI_PB_blk_AddrFocusOn  $page_obj $last_xb $last_yb
 }

#=======================================================================
proc UI_PB_blk_ChangeTextPosition { PAGE_OBJ } {
  upvar $PAGE_OBJ page_obj
  set c $Page::($page_obj,bot_canvas)
  set block_obj $Page::($page_obj,active_blk_obj)
  set source_elem_obj $Page::($page_obj,source_elem_obj)
  UI_PB_blk_DeleteCellsIcons page_obj block_obj
  set block_elem_obj_list $block::($block_obj,active_blk_elem_list)
  set cur_indx [lsearch $block_elem_obj_list $source_elem_obj]
  set block_elem_obj_list [lreplace $block_elem_obj_list \
  $cur_indx $cur_indx]
  if {$Page::($page_obj,add_flag) == 1 || \
  $Page::($page_obj,add_flag) == 3} \
  {
   lappend block_elem_obj_list $source_elem_obj
  } else \
  {
   set insert_blk_elem $Page::($page_obj,insert_elem)
   set insert_indx [lsearch $block_elem_obj_list $insert_blk_elem]
   set block_elem_obj_list [linsert $block_elem_obj_list \
   $insert_indx $source_elem_obj]
  }
  set block::($block_obj,active_blk_elem_list) $block_elem_obj_list
  UI_PB_blk_CreateBlockImages page_obj block_obj
  set block_owner $block::($block_obj,blk_owner)
  UI_PB_blk_CreateBlockCells page_obj block_obj source_elem_obj \
  block_owner
  UI_PB_blk_IconBindProcs page_obj
  UI_PB_blk_ConfigureLeader page_obj source_elem_obj
 }

#=======================================================================
proc UI_PB_blk_DeleteBlockElement { page_obj active_blk_elem } {
  if { [info exists Page::($page_obj,event_obj)] } \
  {
   set event_obj $Page::($page_obj,event_obj)
   set Page::($page_obj,source_blk_elem_obj) \
   $active_blk_elem
   set Page::($page_obj,source_evt_elem_obj) \
   $Page::($page_obj,in_focus_evt_elem)
   UI_PB_tpth_PutBlockElemTrash page_obj event_obj
   set Page::($page_obj,source_blk_elem_obj) 0
   set Page::($page_obj,source_evt_elem_obj) 0
  } else \
  {
   set Page::($page_obj,source_elem_obj) $active_blk_elem
   UI_PB_blk_UpdateCells page_obj
   set Page::($page_obj,source_elem_obj) 0
  }
 }

#=======================================================================
proc UI_PB_blk_UpdateCells {PAGE_OBJ} {
  upvar $PAGE_OBJ page_obj
  set c $Page::($page_obj,bot_canvas)
  set block_obj $Page::($page_obj,active_blk_obj)
  set source_elem_obj $Page::($page_obj,source_elem_obj)
  set source_cell_num [lsearch $block::($block_obj,active_blk_elem_list) \
  $source_elem_obj]
  $c delete $block_element::($source_elem_obj,icon_id)
  set block_obj $Page::($page_obj,active_blk_obj)
  UI_PB_blk_UpdateBlkElements page_obj block_obj source_cell_num
  if {$source_cell_num >= 0} \
  {
   set active_blk_elem [lindex $block::($block_obj,active_blk_elem_list) \
   $source_cell_num]
   UI_PB_blk_ConfigureLeader page_obj active_blk_elem
  } else \
  {
   set active_blk_elem 0
   UI_PB_blk_ConfigureLeader page_obj active_blk_elem
  }
 }

#=======================================================================
proc UI_PB_blk_DeleteBlkElemObj { BLOCK_OBJ BLK_ELEM_OBJ } {
  upvar $BLOCK_OBJ block_obj
  upvar $BLK_ELEM_OBJ blk_elem_obj
  if { [info exists block::($block_obj,rest_value)] }\
  {
   array set rest_blk_attr $block::($block_obj,rest_value)
  } else \
  {
   set rest_blk_attr(2) ""
  }
  array set def_blk_attr $block::($block_obj,def_value)
  if { [lsearch $rest_blk_attr(2) $blk_elem_obj] == -1 \
  && [lsearch $def_blk_attr(2) $blk_elem_obj] == -1 } \
  {
   delete $blk_elem_obj
  } else \
  {
   set add_obj $block_element::($blk_elem_obj,elem_add_obj)
   address::DeleteFromBlkElemList $add_obj blk_elem_obj
  }
 }

#=======================================================================
proc UI_PB_blk_UpdateBlkElements { PAGE_OBJ BLOCK_OBJ SOURCE_CELL_NUM} {
  upvar $PAGE_OBJ page_obj
  upvar $BLOCK_OBJ block_obj
  upvar $SOURCE_CELL_NUM source_cell_num
  set bot_canvas $Page::($page_obj,bot_canvas)
  set source_elem_obj $Page::($page_obj,source_elem_obj)
  UI_PB_blk_DeleteCellsIcons page_obj block_obj
  set block::($block_obj,active_blk_elem_list) \
  [lreplace $block::($block_obj,active_blk_elem_list) \
  $source_cell_num $source_cell_num]
  UI_PB_blk_DeleteBlkElemObj block_obj source_elem_obj
  set no_of_elements [llength $block::($block_obj,active_blk_elem_list)]
  if {$source_cell_num >= $no_of_elements} \
  {
   set source_cell_num [expr $source_cell_num - 1]
  }
  if {$source_cell_num >= 0} \
  {
   set active_blk_elem [lindex $block::($block_obj,active_blk_elem_list) \
   $source_cell_num]
   } else {
   set active_blk_elem 0
  }
  UI_PB_blk_CreateBlockImages page_obj block_obj
  set block_owner $block::($block_obj,blk_owner)
  UI_PB_blk_CreateBlockCells page_obj block_obj active_blk_elem \
  block_owner
 }

#=======================================================================
proc UI_PB_blk_DeleteRect {PAGE_OBJ} {
  upvar $PAGE_OBJ page_obj
  global paOption
  set x_orig $Page::($page_obj,x_orig)
  set y_orig $Page::($page_obj,y_orig)
  set h_cell $Page::($page_obj,h_cell)
  set w_cell $Page::($page_obj,w_cell)
  set w_divi $Page::($page_obj,w_divi)
  set cell_box_width 4
  set main_cell_color $paOption(can_bg)
  set c $Page::($page_obj,bot_canvas)
  set block_obj $Page::($page_obj,active_blk_obj)
  $c delete $block::($block_obj,rect)
  set no_icons [llength $block::($block_obj,active_blk_elem_list)]
  set x0 [expr $x_orig]
  set y0 [expr $y_orig]
  set x1 [expr $x0 + [expr [expr [expr $w_cell + $w_divi] * \
  $no_icons] + $w_divi + 8]]
  set y1 [expr $y0 + $h_cell + 8]
  set block::($block_obj,rect) [$c create rect $x0 $y0 $x1 $y1 \
  -fill $main_cell_color -outline $main_cell_color \
  -tag stationary]
  $c lower $block::($block_obj,rect)
  set block::($block_obj,rect_x0) $x0
  set block::($block_obj,rect_y0) $y0
  set block::($block_obj,rect_x1) $x1
  set block::($block_obj,rect_y1) $y1
 }

#=======================================================================
proc UI_PB_blk_AddTextElement { PAGE_OBJ NEW_ELEM_OBJ text_label } {
  upvar $PAGE_OBJ page_obj
  upvar $NEW_ELEM_OBJ new_elem_obj
  set bot_canvas $Page::($page_obj,bot_canvas)
  set sel_base_addr $Page::($page_obj,sel_base_addr)
  set block_obj $Page::($page_obj,active_blk_obj)
  set block_owner $block::($block_obj,blk_owner)
  UI_PB_com_CreateTextEntry page_obj new_elem_obj $text_label
  tkwait window $bot_canvas.txtent
  if {[string compare $block_element::($new_elem_obj,elem_mom_variable) \
  "000"] != 0} \
  {
   UI_PB_blk_ReplaceIcon page_obj $sel_base_addr $new_elem_obj
   UI_PB_blk_ConfigureLeader page_obj new_elem_obj
  } else \
  {
   UI_PB_blk_DeleteCellsIcons page_obj block_obj
   set block_elem_obj_list $block::($block_obj,active_blk_elem_list)
   set new_index [lsearch $block_elem_obj_list $new_elem_obj]
   delete $new_elem_obj
   set block_elem_obj_list [lreplace $block_elem_obj_list \
   $new_index $new_index]
   set block::($block_obj,active_blk_elem_list) $block_elem_obj_list
   set no_elems [llength $block_elem_obj_list]
   if { $no_elems == 0} \
   {
    set active_elem 0
    } elseif { $new_index >= 0 && $new_index < $no_elems} \
   {
    set active_elem [lindex $block_elem_obj_list $new_index]
    } elseif { $new_index == $no_elems} \
   {
    set active_elem [lindex  $block_elem_obj_list \
    [expr $new_index - 1]]
   }
   UI_PB_blk_CreateBlockImages page_obj block_obj
   UI_PB_blk_CreateBlockCells page_obj block_obj active_elem \
   block_owner
   UI_PB_blk_ConfigureLeader page_obj active_elem
  }
 }

#=======================================================================
proc UI_PB_blk_AddCell {PAGE_OBJ} {
  upvar $PAGE_OBJ page_obj
  set bot_canvas $Page::($page_obj,bot_canvas)
  set block_obj $Page::($page_obj,active_blk_obj)
  set new_elem_mom_var $Page::($page_obj,new_elem_mom_var)
  set sel_base_addr $Page::($page_obj,sel_base_addr)
  set sel_var_desc $Page::($page_obj,comb_var)
  if { [string compare $sel_base_addr "New_Address"] == 0 } \
  {
   set sel_base_addr "user_def"
   set fmt_name "String"
   PB_int_RetAddressObjList add_obj_list
   set add_index [llength $add_obj_list]
   PB_int_CreateNewAddress sel_base_addr fmt_name new_add_obj \
   add_index
  }
  PB_int_AddNewBlockElemObj sel_base_addr new_elem_mom_var \
  block_obj new_elem_obj
  set block_element::($new_elem_obj,owner) $block::($block_obj,blk_owner)
  set blk_elem_flag [UI_PB_com_CheckElemBlkTemplate block_obj \
  new_elem_obj]
  if {$blk_elem_flag} \
  {
   delete $new_elem_obj
   return
  }
  UI_PB_blk_DeleteCellsIcons page_obj block_obj
  if { $block::($block_obj,active_blk_elem_list) != "" } \
  {
   set block_elem_obj_list $block::($block_obj,active_blk_elem_list)
  }
  if {$Page::($page_obj,add_flag) == 1 || \
  $Page::($page_obj,add_flag) == 3} \
  {
   lappend block_elem_obj_list $new_elem_obj
  } else \
  {
   set insert_blk_elem $Page::($page_obj,insert_elem)
   set insert_indx [lsearch $block_elem_obj_list $insert_blk_elem]
   set block_elem_obj_list [linsert $block_elem_obj_list \
   $insert_indx $new_elem_obj]
  }
  UI_PB_com_SortBlockElements block_elem_obj_list
  set block::($block_obj,active_blk_elem_list) $block_elem_obj_list
  unset block_elem_obj_list
  UI_PB_blk_CreateBlockImages page_obj block_obj
  set block_owner $block::($block_obj,blk_owner)
  UI_PB_blk_CreateBlockCells page_obj block_obj new_elem_obj \
  block_owner
  UI_PB_blk_IconBindProcs page_obj
  UI_PB_blk_ConfigureLeader page_obj new_elem_obj
  if {[string compare $Page::($page_obj,sel_base_addr) "Text"] == 0} \
  {
   UI_PB_blk_AddTextElement page_obj new_elem_obj Text
   } elseif { [string compare $Page::($page_obj,sel_base_addr) \
  "New_Address"] == 0 } \
  {
   set event_obj 0
   set evt_elem_obj 0
   UI_PB_blk_NewAddress page_obj event_obj evt_elem_obj \
   new_elem_obj block
   } elseif { [string match "*User Defined*" $sel_var_desc] } \
  {
   set block_element::($new_elem_obj,elem_desc) "User Defined Expression"
   UI_PB_blk_AddTextElement page_obj new_elem_obj Expression
  }
 }

#=======================================================================
proc UI_PB_blk_TrashConnectLine { PAGE_OBJ } {
  global paOption
  upvar $PAGE_OBJ page_obj
  set vtx {}
  set panel_hi $Page::($page_obj,panel_hi)
  set x0 [lindex $Page::($page_obj,trash) 1]
  set x1 [lindex $Page::($page_obj,trash) 2]
  set y0 [lindex $Page::($page_obj,trash) 3]
  set y1 [lindex $Page::($page_obj,trash) 4]
  set x11 [expr [expr $x0 + $x1] / 2]
  set y11 [expr [expr [expr $y0 + $y1] / 2] + $panel_hi]
  lappend vtx $x11 $y11
  set top_canvas $Page::($page_obj,top_canvas)
  set coords [$top_canvas coords new_comp]
  set x1 [expr [lindex $coords 0] + 1]
  set y1 [lindex $coords 1]
  lappend vtx $x1 $y1
  lappend vtx [expr $x1 - 2] $y1
  if {[$top_canvas gettags connect_line] == "connect_line"} \
  {
   eval {$top_canvas coords connect_line} $vtx
  } else \
  {
   eval {$top_canvas create poly} $vtx {-fill $paOption(focus) \
    -width 1 -outline $paOption(focus) \
   -tag connect_line}
  }
  $top_canvas lower connect_line
 }

#=======================================================================
proc UI_PB_blk_ItemFocusOn1 {page_obj x y} {
  global paOption
  set top_canvas $Page::($page_obj,top_canvas)
  set im [$top_canvas itemconfigure current -image]
  if [string compare $im ""] \
  {
   [lindex $im end] configure -background $paOption(focus)
  }
  global gPB
  if { $gPB(use_info) } {
   $top_canvas config -cursor question_arrow
   } else {
   $top_canvas config -cursor hand2
  }
  set Page::($page_obj,add_button_focus_on) 1
 }

#=======================================================================
proc UI_PB_blk_ItemFocusOff1 {page_obj} {
  global paOption
  set top_canvas $Page::($page_obj,top_canvas)
  if {$Page::($page_obj,add_button_focus_on)} \
  {
   set im [$top_canvas itemconfigure current -image]
   [lindex $im end] configure -background $paOption(app_butt_bg)
   $top_canvas config -cursor ""
   set Page::($page_obj,add_button_focus_on) 0
  }
 }

#=======================================================================
proc UI_PB_blk_ItemStartDrag1 {page_obj x y} {
  global paOption
  set c $Page::($page_obj,bot_canvas)
  set Page::($page_obj,add_cell_flag) 0
  $c raise current
  set origin_xt [$c canvasx $x]
  set origin_yt [$c canvasy $y]
  set Page::($page_obj,last_xt) $origin_xt
  set Page::($page_obj,last_yt) $origin_yt
  $Page::($page_obj,add) configure -bg $paOption(focus) -relief sunken
  UI_PB_blk_DrawIconInAllCanvas $page_obj $x $y
  UI_PB_com_ChangeCursor $Page::($page_obj,top_canvas)
 }

#=======================================================================
proc UI_PB_blk_DrawIconInAllCanvas {page_obj x y } {
  set panel_hi $Page::($page_obj,panel_hi)
  set top_canvas $Page::($page_obj,top_canvas)
  set bot_canvas $Page::($page_obj,bot_canvas)
  set new_elem_mom_var $Page::($page_obj,new_elem_mom_var)
  set new_elem_addr $Page::($page_obj,sel_base_addr)
  if { [string compare $new_elem_addr "New_Address"] == 0 } \
  {
   set image_name "pb_blank_addr"
   set app_text ""
   set no_chars 5
   UI_PB_com_TrimOrFillAppText app_text no_chars
   } elseif { [string compare $new_elem_addr "Comment"] == 0 } \
  {
   set image_name "pb_blank_addr"
   set app_text "Operator Message"
   set no_chars 5
   UI_PB_com_TrimOrFillAppText app_text no_chars
   } elseif { [string compare $new_elem_addr "Command"] == 0 } \
  {
   set image_name "pb_blank_addr"
   set app_text $new_elem_mom_var
   set no_chars 5
   UI_PB_com_TrimOrFillAppText app_text no_chars
  } else \
  {
   PB_int_RetAddrObjFromName new_elem_addr add_obj
   UI_PB_com_RetImageAppdText add_obj new_elem_mom_var \
   image_name app_text
  }
  set dx 0
  set dy [expr $panel_hi + 2]
  set xc [$bot_canvas canvasx [expr $x + $dx]]
  set yc [$bot_canvas canvasy [expr $y - $dy]]
  set cmp2 [UI_PB_blk_CreateIcon $bot_canvas $image_name $app_text]
  $cmp2 add image -image [tix getimage pb_blank]
  set icon_bot [$bot_canvas create image $xc $yc \
  -image $cmp2 -tag movable]
  set Page::($page_obj,icon_bot) $icon_bot
  $cmp2 configure -relief sunken -background pink
  set xc [$top_canvas canvasx $x]
  set yc [$top_canvas canvasy $y]
  set cmp1 [UI_PB_blk_CreateIcon $top_canvas $image_name $app_text]
  $cmp1 add image -image [tix getimage pb_blank]
  set icon_top [$top_canvas create image $xc $yc \
  -image $cmp1 -tag new_comp]
  $cmp1 configure -relief sunken -background pink
  set Page::($page_obj,icon_top) $icon_top
  set Page::($page_obj,add_button_focus_on) 0
 }

#=======================================================================
proc UI_PB_blk_ItemDrag1 {page_obj x y} {
  set bot_canvas $Page::($page_obj,bot_canvas)
  set top_canvas $Page::($page_obj,top_canvas)
  set panel_hi $Page::($page_obj,panel_hi)
  set sel_addr $Page::($page_obj,sel_base_addr)
  set xx [$top_canvas canvasx $x]
  set yy [$top_canvas canvasy $y]
  $top_canvas coords $Page::($page_obj,icon_top) $xx $yy
  set dx 1
  set dy [expr $panel_hi + 2]
  set xx [$bot_canvas canvasx [expr $x + $dx]]
  set yy [$bot_canvas canvasy [expr $y - $dy]]
  $bot_canvas coords $Page::($page_obj,icon_bot) $xx $yy
  if { [string compare $sel_addr "Text"] != 0 } \
  {
   UI_PB_blk_HighlightRect $page_obj $xx $yy
  } else \
  {
   UI_PB_blk_HighLightCellDividers $page_obj $xx $yy
  }
 }

#=======================================================================
proc UI_PB_blk_HighLightCellDividers { page_obj xx yy } {
  global paOption
  set high_color $paOption(focus)
  set bot_canvas $Page::($page_obj,bot_canvas)
  set block_obj $Page::($page_obj,active_blk_obj)
  set rect_region $Page::($page_obj,rect_region)
  if {$Page::($page_obj,add_flag) == 2} \
  {
   set prev_act_elem $Page::($page_obj,insert_elem)
   $bot_canvas itemconfigure $block_element::($prev_act_elem,div_id) \
   -fill $Page::($page_obj,div_col) -outline $Page::($page_obj,div_col)
   } elseif {$Page::($page_obj,add_flag) == 3} \
  {
   $bot_canvas itemconfigure $block::($block_obj,div_id) \
   -fill $Page::($page_obj,div_col) -outline $Page::($page_obj,div_col)
  }
  set Page::($page_obj,add_flag) 0
  foreach blk_elem_obj $block::($block_obj,active_blk_elem_list) \
  {
   if { $yy > [expr $block_element::($blk_elem_obj,div_corn_y0) - \
    $rect_region] && \
    $yy < [expr $block_element::($blk_elem_obj,div_corn_y1) + \
    $rect_region] && \
    $xx > [expr $block_element::($blk_elem_obj,div_corn_x0) - 10] && \
   $xx < [expr $block_element::($blk_elem_obj,div_corn_x1) + 10]} \
   {
    set Page::($page_obj,div_col) [lindex [$bot_canvas itemconfigure \
    $block_element::($blk_elem_obj,div_id) -fill] end]
    $bot_canvas itemconfigure $block_element::($blk_elem_obj,div_id) \
    -fill $high_color -outline $high_color
    set Page::($page_obj,active_blk_obj) $block_obj
    set Page::($page_obj,insert_elem) $blk_elem_obj
    set rect_coord(0) $block_element::($blk_elem_obj,div_corn_x0)
    set rect_coord(1) $block_element::($blk_elem_obj,div_corn_y0)
    set rect_coord(2) $block_element::($blk_elem_obj,div_corn_x1)
    set rect_coord(3) $block_element::($blk_elem_obj,div_corn_y1)
    UI_PB_blk_BlockConnectLine page_obj rect_coord
    set Page::($page_obj,add_flag) 2
    break
   } else \
   {
    $bot_canvas delete connect_line
    set Page::($page_obj,add_flag) 0
   }
  }
  if {!$Page::($page_obj,add_flag)} \
  {
   if { $yy > [expr $block::($block_obj,div_corn_y0) - \
    $rect_region] && \
    $yy < [expr $block::($block_obj,div_corn_y1) + \
    $rect_region] && \
    $xx > [expr $block::($block_obj,div_corn_x0) - 10] && \
   $xx < [expr $block::($block_obj,div_corn_x1) + 10]} \
   {
    set Page::($page_obj,div_col) [lindex [$bot_canvas itemconfigure \
    $block::($block_obj,div_id) -fill] end]
    $bot_canvas itemconfigure $block::($block_obj,div_id) \
    -fill $high_color -outline $high_color
    set Page::($page_obj,active_blk_obj) $block_obj
    set rect_coord(0) $block::($block_obj,div_corn_x0)
    set rect_coord(1) $block::($block_obj,div_corn_y0)
    set rect_coord(2) $block::($block_obj,div_corn_x1)
    set rect_coord(3) $block::($block_obj,div_corn_y1)
    UI_PB_blk_BlockConnectLine page_obj rect_coord
    set Page::($page_obj,add_flag) 3
   } else \
   {
    $bot_canvas delete connect_line
    set Page::($page_obj,add_flag) 0
   }
  }
 }

#=======================================================================
proc UI_PB_blk_HighlightRect {page_obj x y} {
  global paOption
  set high_color $paOption(focus)
  set bot_canvas $Page::($page_obj,bot_canvas)
  set block_obj $Page::($page_obj,active_blk_obj)
  if {[info exists Page::($page_obj,rect_col)] == 1} \
  {
   $bot_canvas itemconfigure $block::($block_obj,rect) \
   -fill $Page::($page_obj,rect_col)
  }
  if {$x > [expr $block::($block_obj,rect_x0) - \
   [expr $Page::($page_obj,rect_region) / 1.5]] && \
   $x < [expr $block::($block_obj,rect_x1) + \
   $Page::($page_obj,rect_region)] && \
   $y > [expr $block::($block_obj,rect_y0) - \
   $Page::($page_obj,rect_region)] && \
   $y < [expr $block::($block_obj,rect_y1) + \
  $Page::($page_obj,rect_region)] } \
  {
   set Page::($page_obj,rect_col) [lindex [$bot_canvas itemconfigure \
   $block::($block_obj,rect) -fill] end]
   $bot_canvas itemconfigure $block::($block_obj,rect) -fill $high_color
   set Page::($page_obj,active_blk_obj) $block_obj
   set rect_coord(0) $block::($block_obj,rect_x0)
   set rect_coord(1) $block::($block_obj,rect_y0)
   set rect_coord(2) $block::($block_obj,rect_x1)
   set rect_coord(3) $block::($block_obj,rect_y1)
   UI_PB_blk_BlockConnectLine page_obj rect_coord
   set Page::($page_obj,add_flag) 1
  } else \
  {
   $bot_canvas delete connect_line
   set Page::($page_obj,add_flag) 0
  }
 }

#=======================================================================
proc UI_PB_blk_BlockConnectLine {PAGE_OBJ RECT_COORD} {
  upvar $PAGE_OBJ page_obj
  upvar $RECT_COORD rect_coord
  global paOption
  set panel_hi $Page::($page_obj,panel_hi)
  set vtx {}
  set top_canvas $Page::($page_obj,top_canvas)
  set bot_canvas $Page::($page_obj,bot_canvas)
  set x0 $rect_coord(0)
  set y0 $rect_coord(1)
  set x1 $rect_coord(2)
  set y1 $rect_coord(3)
  set x11 [expr [expr $x0 + $x1] / 2]
  set y11 [expr [expr $y0 + $y1] / 2]
  lappend vtx $x11 $y11
  set new_originx [$top_canvas canvasx 0]
  set coords [$top_canvas coords $Page::($page_obj,icon_top)]
  set x1 [expr [lindex $coords 0] - $new_originx]
  set y1 [lindex $coords 1]
  set y1 [expr $y1 - $panel_hi]
  set x1 [$bot_canvas canvasx $x1]
  set x1 [expr $x1 + 1]
  set y1 [$bot_canvas canvasy $y1]
  lappend vtx $x1 $y1
  set x1 [expr $x1 - 2]
  lappend vtx $x1 $y1
  if {[$bot_canvas gettags connect_line] == "connect_line"} \
  {
   eval {$bot_canvas coords connect_line} $vtx
  } else \
  {
   eval {$bot_canvas create poly} $vtx {-fill $paOption(focus) \
    -width 1 -outline $paOption(focus) \
   -tag connect_line}
   $bot_canvas lower connect_line
  }
 }

#=======================================================================
proc UI_PB_blk_ItemEndDrag1 {page_obj x1 y1} {
  global paOption
  set bot_canvas $Page::($page_obj,bot_canvas)
  set top_canvas $Page::($page_obj,top_canvas)
  set block_obj $Page::($page_obj,active_blk_obj)
  if {[info exists Page::($page_obj,rect_col)] == 1} \
  {
   $bot_canvas itemconfigure $block::($block_obj,rect) \
   -fill $Page::($page_obj,rect_col)
  }
  if {$Page::($page_obj,add_flag) == 2} \
  {
   set prev_act_elem $Page::($page_obj,insert_elem)
   $bot_canvas itemconfigure $block_element::($prev_act_elem,div_id) \
   -fill $Page::($page_obj,div_col) -outline $Page::($page_obj,div_col)
   } elseif {$Page::($page_obj,add_flag) == 3} \
  {
   $bot_canvas itemconfigure $block::($block_obj,div_id) \
   -fill $Page::($page_obj,div_col) -outline $Page::($page_obj,div_col)
  }
  if {$Page::($page_obj,icon_top)} \
  {
   $top_canvas delete $Page::($page_obj,icon_top)
   set Page::($page_obj,icon_top) 0
  }
  $Page::($page_obj,add) configure -relief raised \
  -background $paOption(app_butt_bg)
  if {$Page::($page_obj,icon_bot)} \
  {
   $bot_canvas delete $Page::($page_obj,icon_bot)
   set Page::($page_obj,icon_bot) 0
   if {$Page::($page_obj,add_flag)} \
   {
    $bot_canvas delete connect_line
    UI_PB_blk_AddCell page_obj
    set Page::($page_obj,add_flag) 0
   }
  }
  $top_canvas config -cursor ""
 }

#=======================================================================
proc UI_PB_blk_ReturnAddr {PAGE_OBJ SOURCE_BLK_ELEM} {
  upvar $PAGE_OBJ page_obj
  upvar $SOURCE_BLK_ELEM source_blk_elem
  set c $Page::($page_obj,bot_canvas)
  set icon_id $block_element::($Page::($page_obj,active_blk_elem),icon_id)
  $c coords $icon_id $block_element::($source_blk_elem,xc) \
  $block_element::($source_blk_elem,yc)
 }

#=======================================================================
proc UI_PB_blk_TabBlockDelete { blk_page_obj } {
  if {[info exists Page::($blk_page_obj,active_blk_obj)]} \
  {
   set active_blk $Page::($blk_page_obj,active_blk_obj)
   UI_PB_blk_DeleteCellsIcons blk_page_obj active_blk
   UI_PB_blk_BlkApplyCallBack $blk_page_obj
   set block::($active_blk,active_blk_elem_list) ""
   unset Page::($blk_page_obj,active_blk_obj)
  }
 }

#=======================================================================
proc UI_PB_blk_TabBlockCreate { blk_page_obj } {
  set tree $Page::($blk_page_obj,tree)
  set HLIST [$tree subwidget hlist]
  set ent [$HLIST info selection]
  set index [string range $ent 2 [string length $ent]]
  if {[string compare $index ""] == 0} \
  {
   set index 0
  }
  UI_PB_blk_DisplayNameList blk_page_obj index
  UI_PB_blk_CreateMenuOptions blk_page_obj block
  UI_PB_blk_BlkItemSelection $blk_page_obj
 }

#=======================================================================
proc UI_PB_blk_CreateBlockPage { BLOCK_OBJ WIN NEW_BLK_PAGE } {
  upvar $BLOCK_OBJ block_obj
  upvar $WIN win
  upvar $NEW_BLK_PAGE new_blk_page
  global popupvar
  global paOption
  block::readvalue $block_obj blk_obj_attr
  set pname $blk_obj_attr(0)
  set new_blk_page [new Page $pname $pname]
  set Page::($new_blk_page,page_id) $win
  set Page::($new_blk_page,canvas_frame) $win
  UI_PB_blk_SetPageAttributes new_blk_page
  set act_frm [frame $win.actbut]
  pack $act_frm -side bottom -fill x -padx 1 -pady 3
  __CreateBlockPageParm new_blk_page
  UI_PB_blk_CreateMenuOptions new_blk_page block
  pack forget $Page::($new_blk_page,box)
  set Page::($new_blk_page,box) $act_frm
  PB_int_RetEvtCombElems comb_box_elems
  set Page::($new_blk_page,blk_WordNameList) $comb_box_elems
  UI_PB_blk_DisplayBlockAttr new_blk_page block_obj
 }

#=======================================================================
proc __CreateBlockPageParm { BLK_PAGE_OBJ } {
  upvar $BLK_PAGE_OBJ blk_page_obj
  global gPB
  set top_canvas_dim(0) 80
  set top_canvas_dim(1) 400
  set bot_canvas_dim(0) 2000
  set bot_canvas_dim(1) 1000
  Page::CreateCanvas $blk_page_obj top_canvas_dim \
  bot_canvas_dim
  UI_PB_blk_AddTopFrameItems blk_page_obj
  set Page::($blk_page_obj,add_name) " $gPB(block,add,Label) "
  Page::CreateAddTrashinCanvas $blk_page_obj
  Page::CreateMenu $blk_page_obj
  UI_PB_blk_AddBindProcs blk_page_obj
  set top_canvas $Page::($blk_page_obj,top_canvas)
  $top_canvas bind add_movable <B1-Motion> \
  "UI_PB_blk_ItemDrag1 $blk_page_obj \
  %x %y"
  $top_canvas bind add_movable <ButtonRelease-1> \
  "UI_PB_blk_ItemEndDrag1 $blk_page_obj \
  %x %y"
  UI_PB_blk_CreatePopupMenu blk_page_obj
  global gPB
  set top_canvas $Page::($blk_page_obj,top_canvas)
  set bot_canvas $Page::($blk_page_obj,bot_canvas)
  set gPB(c_help,$top_canvas,add_movable)     "block,add"
  set gPB(c_help,$top_canvas,evt_trash)       "block,trash"
  set gPB(c_help,$bot_canvas,movable)         "block,word"
  set comb_widget [winfo parent $Page::($blk_page_obj,comb_widget)]
  set gPB(c_help,$comb_widget)                "block,select"
  set frm $Page::($blk_page_obj,verify)
  set gPB(c_help,$frm)                        "block,verify"
 }

#=======================================================================
proc UI_PB_blk_EditOk_CB { page_obj seq_page_obj seq_obj elem_obj } {
  global tixOption
  global gPB
  set block_obj $event_element::($elem_obj,block_obj)
  set t_shift $Page::($seq_page_obj,glob_text_shift)
  if { $block::($block_obj,active_blk_elem_list) == "" } \
  {
   tk_messageBox -parent [UI_PB_com_AskActiveWindow] -type ok -icon error \
   -message "$gPB(block,msg,min_word)"
   return
  }
  UI_PB_blk_BlkApplyCallBack $page_obj
  destroy $Page::($page_obj,canvas_frame)
  delete $page_obj
  UI_PB_evt_DeleteSeqEvents seq_page_obj seq_obj
  UI_PB_evt_CreateSeqAttributes seq_page_obj
  UI_PB_evt_CreateMenuOptions seq_page_obj seq_obj
 }

#=======================================================================
proc UI_PB_blk_EditCancel_CB { page_obj seq_page_obj seq_obj elem_obj } {
  set block_obj $event_element::($elem_obj,block_obj)
  set bot_canvas $Page::($seq_page_obj,bot_canvas)
  set blk_img_id $event_element::($elem_obj,icon_id)
  set img [lindex [$bot_canvas itemconfigure $blk_img_id -image] end]
  if { [UI_PB_evt_RetNoEvtElemsOfBlk block_obj] > 1 } \
  {
   $img config -relief raised -bg lightSkyBlue
  } else \
  {
   $img config -relief raised -bg white
  }
  foreach blk_elem $block::($block_obj,active_blk_elem_list) \
  {
   block_element::readvalue $blk_elem blk_elem_attr
   address::DeleteFromBlkElemList $blk_elem_attr(0) blk_elem
   unset blk_elem_attr
  }
  UI_PB_blk_DeleteChangeOverBlkElems block_obj
  array set blk_obj_attr $block::($block_obj,rest_value)
  block::setvalue $block_obj blk_obj_attr
  unset blk_obj_attr
  foreach blk_elem_obj $block::($block_obj,elem_addr_list) \
  {
   array set blk_elem_obj_attr $block_element::($blk_elem_obj,rest_value)
   block_element::setvalue $blk_elem_obj blk_elem_obj_attr
   address::AddToBlkElemList $blk_elem_obj_attr(1) blk_elem_obj
   unset blk_elem_obj_attr
  }
  destroy $Page::($page_obj,canvas_frame)
  delete $page_obj
 }

#=======================================================================
proc UI_PB_blk_NewBlkOk_CB { page_obj seq_page_obj seq_obj evt_obj elem_obj } {
  global tixOption
  set block_obj $event_element::($elem_obj,block_obj)
  if { $block::($block_obj,active_blk_elem_list) == "" } \
  {
   tk_messageBox -parent [UI_PB_com_AskActiveWindow] -type ok -icon error \
   -message "Block Should atleast have one word in it."
   return
  }
  UI_PB_blk_BlkApplyCallBack $page_obj
  block::readvalue $block_obj blk_obj_attr
  block::DefaultValue $block_obj blk_obj_attr
  unset blk_obj_attr
  if { $block::($block_obj,blk_type) == "command" } \
  {
   set cmd_blk_elem [lindex $block::($block_obj,elem_addr_list) 0]
   set cmd_obj $block_element::($cmd_blk_elem,elem_mom_variable)
   set blk_nc_code $command::($cmd_obj,name)
   } elseif { $block::($block_obj,blk_type) == "comment" } \
  {
   set blk_elem [lindex $block::($block_obj,elem_addr_list) 0]
   set blk_nc_code $block_element::($blk_elem,elem_mom_variable)
  } else \
  {
   set blk_elem_list $block::($block_obj,elem_addr_list)
   UI_PB_com_ApplyMastSeqBlockElem blk_elem_list
   UI_PB_com_CreateBlkNcCode blk_elem_list blk_nc_code
  }
  UI_PB_com_TrunkNcCode blk_nc_code
  set elem_text $blk_nc_code
  destroy $Page::($page_obj,canvas_frame)
  delete $page_obj
  set bot_canvas $Page::($seq_page_obj,bot_canvas)
  set t_shift $Page::($seq_page_obj,glob_text_shift)
  set elem_xc $event_element::($elem_obj,xc)
  set elem_yc $event_element::($elem_obj,yc)
  $bot_canvas delete $event_element::($elem_obj,text_id)
  set index [lsearch $sequence::($seq_obj,texticon_ids) \
  $event_element::($elem_obj,text_id)]
  set elem_icon_id [lindex $sequence::($seq_obj,texticon_ids) \
  [expr $index + 1]]
  set sequence::($seq_obj,texticon_ids) \
  [lreplace $sequence::($seq_obj,texticon_ids) $index \
  [expr $index + 1]]
  set elem_text_id [$bot_canvas create text [expr $elem_xc + $t_shift] \
  $elem_yc -text $elem_text -font $tixOption(font_sm) -justify left \
  -tag blk_movable]
  set event_element::($elem_obj,text_id) $elem_text_id
  lappend sequence::($seq_obj,texticon_ids) $elem_text_id $elem_icon_id
  set blk_img_id $event_element::($elem_obj,icon_id)
  set img [lindex [$bot_canvas itemconfigure $blk_img_id -image] end]
  $img config -relief raised -bg white
  UI_PB_evt_CreateMenuOptions seq_page_obj seq_obj
 }

#=======================================================================
proc UI_PB_blk_NewBlkCancel_CB { page_obj seq_page_obj seq_obj \
  evt_obj elem_obj } {
  set sequence::($seq_obj,drag_evt_obj) $evt_obj
  set sequence::($seq_obj,drag_blk_obj) $elem_obj
  set block_obj $event_element::($elem_obj,block_obj)
  PB_int_RemoveBlkObjFrmList block_obj
  UI_PB_evt_PutBlkInTrash seq_page_obj seq_obj
  unset sequence::($seq_obj,drag_blk_obj)
  unset sequence::($seq_obj,drag_evt_obj)
  set block::($block_obj,elem_addr_list) \
  $block::($block_obj,active_blk_elem_list)
  delete $block_obj
  destroy $Page::($page_obj,canvas_frame)
  delete $page_obj
 }

#=======================================================================
proc UI_PB_blk_ModalityDialog { SEQ_PAGE_OBJ SEQ_OBJ ELEM_OBJ WIN } {
  upvar $SEQ_PAGE_OBJ seq_page_obj
  upvar $SEQ_OBJ seq_obj
  upvar $ELEM_OBJ elem_obj
  upvar $WIN win
  global blk_modality
  global paOption
  global tixOption
  global mom_sys_arr
  set block_obj $event_element::($elem_obj,block_obj)
  block::readvalue $block_obj blk_obj_attr
  set top_frm [frame $win.top -relief ridge -bd 2]
  pack $top_frm -side top -fill both
  set bot_frm [frame $win.bot]
  pack $bot_frm -side bottom -fill x
  set label_list {"gPB(nav_button,cancel,Label)" \
  "gPB(nav_button,ok,Label)"}
  set cb_arr(gPB(nav_button,cancel,Label)) \
  "UI_PB_blk_ModalityCancel_CB $win $seq_page_obj \
  $seq_obj $elem_obj"
  set cb_arr(gPB(nav_button,ok,Label)) \
  "UI_PB_blk_ModalityOk_CB $win $seq_page_obj $seq_obj \
  $elem_obj blk_modality"
  UI_PB_com_CreateButtonBox $bot_frm label_list cb_arr
  set count 0
  foreach blk_elem_obj $blk_obj_attr(2) \
  {
   block_element::readvalue $blk_elem_obj blk_elem_obj_attr
   set blk_modality($count) $block_element::($blk_elem_obj,force)
   set add_obj $blk_elem_obj_attr(0)
   address::readvalue $add_obj add_obj_attr
   PB_com_MapMOMVariable mom_sys_arr add_obj blk_elem_obj_attr(1) app_text
   PB_int_ApplyFormatAppText add_obj app_text
   set inp_frm [frame $top_frm.$count -relief solid -bd 2]
   pack $inp_frm -side top -padx 5 -pady 5 -fill both
   append label $add_obj_attr(8) $app_text
   checkbutton $inp_frm.chk -text $label -variable blk_modality($count) \
   -font $tixOption(bold_font) -relief flat -bd 2 -anchor w
   pack $inp_frm.chk -side left -padx 15
   unset label blk_elem_obj_attr add_obj_attr
   incr count
  }
 }

#=======================================================================
proc UI_PB_blk_ModalityCancel_CB { win seq_page_obj seq_obj elem_obj} {
  destroy $win
  set block_obj $event_element::($elem_obj,block_obj)
  set bot_canvas $Page::($seq_page_obj,bot_canvas)
  set evt_img_id $event_element::($elem_obj,icon_id)
  set img [lindex [$bot_canvas itemconfigure $evt_img_id -image] end]
  if { [UI_PB_evt_RetNoEvtElemsOfBlk block_obj] > 1 } \
  {
   $img config -relief raised -bg lightSkyBlue
  } else \
  {
   $img config -relief raised -bg white
  }
  $bot_canvas bind blk_movable <Leave> \
  "UI_PB_evt_BlockFocusOff $seq_page_obj $seq_obj"
 }

#=======================================================================
proc UI_PB_blk_ModalityOk_CB { win seq_page_obj seq_obj elem_obj \
  BLK_MODALITY } {
  upvar $BLK_MODALITY blk_modality
  set block_obj $event_element::($elem_obj,block_obj)
  block::readvalue $block_obj blk_obj_attr
  set count 0
  foreach blk_elem_obj $blk_obj_attr(2) \
  {
   set block_element::($blk_elem_obj,force) $blk_modality($count)
   incr count
  }
  destroy $win
  set bot_canvas $Page::($seq_page_obj,bot_canvas)
  set evt_img_id $event_element::($elem_obj,icon_id)
  set img [lindex [$bot_canvas itemconfigure $evt_img_id -image] end]
  if { [UI_PB_evt_RetNoEvtElemsOfBlk block_obj] > 1 } \
  {
   $img config -relief raised -bg lightSkyBlue
  } else \
  {
   $img config -relief raised -bg white
  }
  $bot_canvas bind blk_movable <Leave> \
  "UI_PB_evt_BlockFocusOff $seq_page_obj $seq_obj"
 }