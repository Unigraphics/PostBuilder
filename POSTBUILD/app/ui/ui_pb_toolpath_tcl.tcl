
#=======================================================================
proc UI_PB_tpth_ToolPath { SEQ_PAGE_OBJ SEQ_OBJ EVENT_OBJ} {
  upvar $SEQ_PAGE_OBJ seq_page_obj
  upvar $SEQ_OBJ seq_obj
  upvar $EVENT_OBJ event_obj
  global paOption gPB
  set sequence_name $sequence::($seq_obj,seq_name)
  set event_name $event::($event_obj,event_name)
  set dbase_evt_name $event_name
  set bot_canvas $Page::($seq_page_obj,bot_canvas)
  set evt_img_id $event::($event_obj,icon_id)
  set img [lindex [$bot_canvas itemconfigure $evt_img_id -image] end]
  $img config -relief sunken -bg $paOption(sunken_bg)
  set temp_event_name [split $event_name]
  set event_name [join $temp_event_name _ ]
  set event_name [string tolower $event_name]
  set win $gPB(main_window).$event_name
  if {[winfo exists $win]} \
  {
   raise $win
   focus $win
   return
   } else {
   toplevel $win
  }
  set page_obj [new Page $event_name $event_name]
  set Page::($page_obj,page_id) $win
  set Page::($page_obj,event_name) $event::($event_obj,event_name)
  set Page::($page_obj,event_obj) $event_obj
  set toplevel_index [llength $gPB(toplevel_list)]
  set win_index [expr $toplevel_index + 1]
  set gPB(toplevel_disable_$win_index) 1
  UI_PB_com_CreateTransientWindow $win \
  "$gPB(tool,event_trans,title,Label) : $dbase_evt_name" \
  "800x600+100+100" \
  "" "UI_PB_tpth_DisableTpthWidgets $seq_page_obj $seq_obj" \
  "UI_PB_tpth_CancelCallBack $seq_page_obj $page_obj $event_obj" \
  "UI_PB_tpth_ActivateTpthWidgets $seq_page_obj $seq_obj \
  $event_obj $win_index"
  PB_int_RetEvtCombElems comb_box_elems
  set item_obj_list $event::($event_obj,evt_itm_obj_list)
  set ude_flag $sequence::($seq_obj,ude_flag)
  if { [llength $item_obj_list ] > 0 } \
  {
   if { !$event::($event_obj,canvas_flag) } \
   {
    wm geometry $win 800x400+200+200
   }
   UI_PB_tpth_CreateHorzPane page_obj event_obj
   UI_PB_tpth_CreateToolPathComponents page_obj seq_page_obj seq_obj \
   event_obj
   UI_PB_tpth_CreateItemsOfEvent page_obj item_obj_list
   UI_PB_tpth_PackItems page_obj
  } else \
  {
   wm geometry $win 800x500+200+200
   set page_id $Page::($page_obj,page_id)
   set Page::($page_obj,canvas_frame) $page_id
   set Page::($page_obj,param_frame) $page_id
   set Page::($page_obj,box_frame) $page_id
   UI_PB_tpth_CreateToolPathComponents page_obj seq_page_obj seq_obj \
   event_obj
  }
  UI_PB_tpth_CreateMembersOfItem page_obj event_obj
  if {$ude_flag} \
  {
   set no_items [llength $item_obj_list]
   if {$no_items > 0} \
   {
    UI_PB_tpth_CreateUserDefIcon page_obj no_items
   }
  }
  UI_PB_tpth_GetEventMomVars event_obj evt_mom_var_list
  set Page::($page_obj,evt_mom_var_list) [array get evt_mom_var_list]
  set Page::($page_obj,dummy_blk) 0
  UI_PB_tpth_CreateElemObjects page_obj event_obj
  UI_PB_tpth_RestoreEventData page_obj event_obj
  set Page::($page_obj,block_popup_flag) 0
  UI_PB_blk_CreatePopupMenu page_obj
  set Page::($page_obj,blk_WordNameList) $comb_box_elems
  UI_PB_tpth_CreateEventBlockTemplates page_obj event_obj
  UI_PB_blk_CreateMenuOptions page_obj event
  UI_PB_com_PositionWindow $win
 }

#=======================================================================
proc UI_PB_tpth_ActivateTpthWidgets { page_obj seq_obj event_obj win_index } {
  global gPB
  global paOption
  if { $gPB(toplevel_disable_$win_index) } \
  {
   set bot_canvas $Page::($page_obj,bot_canvas)
   tixEnableAll $Page::($page_obj,page_id)
   UI_PB_evt_EvtBindProcs page_obj seq_obj
   UI_PB_evt_BindCollapseImg page_obj seq_obj
   set evt_img_id $event::($event_obj,icon_id)
   set img [lindex [$bot_canvas itemconfigure $evt_img_id -image] end]
   if { $img != "" } \
   {
    $img config -relief raised -bg $paOption(event)
   }
   set evt_text $event::($event_obj,text_id)
   $bot_canvas itemconfigure $evt_text -fill $paOption(special_fg)
   set gPB(toplevel_disable_$win_index) 0
  }
 }

#=======================================================================
proc UI_PB_tpth_DisableTpthWidgets { page_obj seq_obj } {
  tixDisableAll $Page::($page_obj,page_id)
  UI_PB_evt_UnBindEvtProcs page_obj
  UI_PB_evt_UnBindCollapseImg page_obj seq_obj
  set c $Page::($page_obj,bot_canvas)
  $c config -cursor ""
 }

#=======================================================================
proc UI_PB_tpth_ActivateTpthEvtWidgets { page_obj event_obj win_index } {
  global gPB
  global paOption
  if { $gPB(toplevel_disable_$win_index) } \
  {
   set top_canvas $Page::($page_obj,top_canvas)
   tixEnableAll $Page::($page_obj,page_id)
   UI_PB_blk_AddBindProcs page_obj
   UI_PB_tpth_IconBindProcs page_obj event_obj
   $top_canvas bind add_movable <B1-Motion> \
   "UI_PB_tpth_ItemDrag1 $page_obj $event_obj \
   %x %y"
   $top_canvas bind add_movable <ButtonRelease-1> \
   "UI_PB_tpth_ItemEndDrag1 $page_obj $event_obj \
   %x %y"
   set gPB(toplevel_disable_$win_index) 0
  }
 }

#=======================================================================
proc UI_PB_tpth_DisableTpthEvtWidgets { page_obj } {
  tixDisableAll $Page::($page_obj,page_id)
  UI_PB_tpth_IconUnBindProcs page_obj
  UI_PB_blk_AddUnBindProcs page_obj
  set c $Page::($page_obj,bot_canvas)
  $c config -cursor ""
 }

#=======================================================================
proc UI_PB_tpth_RestoreEventData { PAGE_OBJ EVENT_OBJ } {
  upvar $PAGE_OBJ page_obj
  upvar $EVENT_OBJ event_obj
  global mom_sys_arr
  global mom_kin_var
  set rest_flag 0
  if { [llength $event::($event_obj,evt_elem_list)] == 1  && \
  $Page::($page_obj,dummy_blk) == 1} \
  {
   set evt_elem_obj [lindex $event::($event_obj,evt_elem_list) 0]
   set block_obj $event_element::($evt_elem_obj,block_obj)
   if { $block::($block_obj,active_blk_elem_list) == "" } \
   {
    set rest_flag 1
   }
  }
  if { !$rest_flag } \
  {
   event::RestoreValue $event_obj
   if {[string compare $event::($event_obj,evt_elem_list) ""] != 0} \
   {
    foreach evt_elem_obj $event::($event_obj,evt_elem_list) \
    {
     event_element::RestoreValue $evt_elem_obj
     set block_obj $event_element::($evt_elem_obj,block_obj)
     block::RestoreValue $block_obj
     if {[string compare $block::($block_obj,elem_addr_list) ""] != 0} \
     {
      foreach blk_elem_obj $block::($block_obj,elem_addr_list) \
      {
       block_element::RestoreValue $blk_elem_obj
      }
     }
    }
   }
  }
  array set evt_mom_var $Page::($page_obj,evt_mom_var_list)
  set no_vars [array size evt_mom_var]
  for {set count 0} {$count < $no_vars} {incr count} \
  {
   set mom_var $evt_mom_var($count)
   if { [string match "\$mom_kin*" $mom_var] } \
   {
    set rest_evt_mom_var($mom_var) $mom_kin_var($mom_var)
   } else \
   {
    set rest_evt_mom_var($mom_var) $mom_sys_arr($mom_var)
   }
   if { [string match \$mom* $mom_var] && \
   [string match \$mom_kin* $mom_var] == 0 } \
   {
    set data_type [UI_PB_com_RetSysVarDataType mom_var]
    set mom_sys_arr($mom_var) [UI_PB_com_RetValByDataType \
    $mom_sys_arr($mom_var) $data_type]
   }
  }
  if {[info exists rest_evt_mom_var]} \
  {
   set Page::($page_obj,rest_evt_mom_var) [array get rest_evt_mom_var]
  }
 }

#=======================================================================
proc UI_PB_tpth_GetEventMomVars { EVENT_OBJ EVT_MOM_VAR_LIST } {
  upvar $EVENT_OBJ event_obj
  upvar $EVT_MOM_VAR_LIST evt_mom_var_list
  set count 0
  if {[string compare $event::($event_obj,evt_itm_obj_list) ""] != 0} \
  {
   foreach item_obj $event::($event_obj,evt_itm_obj_list) \
   {
    if {[string compare $item::($item_obj,grp_obj_list) ""] != 0} \
    {
     foreach grp_obj $item::($item_obj,grp_obj_list) \
     {
      if {[string compare $item_group::($grp_obj,mem_obj_list) ""] != 0} \
      {
       foreach mem_obj $item_group::($grp_obj,mem_obj_list) \
       {
        if {[string compare $group_member::($mem_obj,mom_var) "null"]} \
        {
         if {$group_member::($mem_obj,widget_type) == 5} \
         {
          append temp_var $group_member::($mem_obj,mom_var) _int
          set evt_mom_var_list($count) $temp_var
          unset temp_var
          incr count
          append temp_var $group_member::($mem_obj,mom_var) _dec
          set evt_mom_var_list($count) $temp_var
          unset temp_var
          incr count
         } else \
         {
          set evt_mom_var_list($count) $group_member::($mem_obj,mom_var)
          incr count
         }
        }
       }
      }
     }
    }
   }
  }
  if { [string compare "$event::($event_obj,event_name)" "Rapid Move"] == 0 } \
  {
   set evt_mom_var_list($count) "\$pb_rapid_1"
   incr count
   set evt_mom_var_list($count) "\$pb_rapid_2"
  }
 }

#=======================================================================
proc UI_PB_tpth_CreateToolPathComponents { PAGE_OBJ SEQ_PAGE_OBJ SEQ_OBJ \
  EVENT_OBJ } {
  upvar $PAGE_OBJ page_obj
  upvar $SEQ_PAGE_OBJ seq_page_obj
  upvar $SEQ_OBJ seq_obj
  upvar $EVENT_OBJ event_obj
  global paOption
  global val
  global gPB
  set top_canvas_dim(0) 80
  set top_canvas_dim(1) 400
  set bot_canvas_dim(0) 2000
  set bot_canvas_dim(1) 2000
  Page::CreateCanvas $page_obj top_canvas_dim bot_canvas_dim
  set bot_canvas $Page::($page_obj,bot_canvas)
  $bot_canvas config -height 100 -width 400
  UI_PB_tpth_AddApplyDef page_obj seq_page_obj seq_obj event_obj
  set Page::($page_obj,add_name) " $gPB(tool,add_word,button,Label) "
  Page::CreateAddTrashinCanvas $page_obj
  Page::CreateMenu $page_obj
  UI_PB_blk_AddBindProcs page_obj
  set top_canvas $Page::($page_obj,top_canvas)
  $top_canvas bind add_movable <B1-Motion> \
  "UI_PB_tpth_ItemDrag1 $page_obj $event_obj \
  %x %y"
  $top_canvas bind add_movable <ButtonRelease-1> \
  "UI_PB_tpth_ItemEndDrag1 $page_obj $event_obj \
  %x %y"
  set top_canvas $Page::($page_obj,top_canvas)
  set bot_canvas $Page::($page_obj,bot_canvas)
  set gPB(c_help,$top_canvas,add_movable)     "block,add"
  set gPB(c_help,$top_canvas,evt_trash)       "block,trash"
  set gPB(c_help,$bot_canvas,movable)         "block,word"
  set gPB(c_help,$bot_canvas,nonmovable)      "block,word"
  set comb_widget [winfo parent $Page::($page_obj,comb_widget)]
  set gPB(c_help,$comb_widget)                "block,select"
 }

#=======================================================================
proc UI_PB_tpth_CreateEventBlockTemplates { PAGE_OBJ EVENT_OBJ } {
  upvar $PAGE_OBJ page_obj
  upvar $EVENT_OBJ event_obj
  UI_PB_tpth_SetPageAttributes page_obj
  UI_PB_tpth_CreateBlkElements page_obj event_obj
 }

#=======================================================================
proc UI_PB_tpth_CreateItemsOfEvent { PAGE_OBJ ITEM_OBJ_LIST} {
  upvar $PAGE_OBJ page_obj
  upvar $ITEM_OBJ_LIST item_obj_list
  global gPB
  set param_frm $Page::($page_obj,param_frame)
  set item_row 0
  set item_col 0
  set count 0
  foreach item_obj $item_obj_list \
  {
   set item_label $item::($item_obj,label)
   if { [string match "*\$gPB(*" $item_label] } \
   {
    set item_label "[eval format %s $item_label]"
   }
   if {[string compare $item_label "null"] != 0} \
   {
    set widget_id [Page::CreateLblFrame $param_frm ent_$count $item_label]
   } else \
   {
    set widget_id [Page::CreateFrame $param_frm ent_$count]
   }
   set item::($item_obj,row) $item_row
   set item::($item_obj,col) $item_col
   set item::($item_obj,widget_id) $widget_id
   if {$item_col != 1} \
   {
    lappend row_items_list $item_obj
    lappend pack_row_items 0
    incr item_col
   } else \
   {
    incr item_row
    set item_col 0
    lappend row_items_list $item_obj
    lappend row_item_obj $row_items_list
    unset row_items_list
    lappend pack_row_items 0
    lappend packed_items $pack_row_items
    unset pack_row_items
   }
   incr count
  }
  if {[info exists row_items_list]} \
  {
   lappend row_item_obj $row_items_list
   unset row_items_list
  }
  if {[info exists pack_row_items]} \
  {
   lappend packed_items $pack_row_items
   unset pack_row_items
  }
  set Page::($page_obj,items_in_row) $row_item_obj
  set Page::($page_obj,packed_items) $packed_items
 }

#=======================================================================
proc UI_PB_tpth_CreateUserDefIcon { PAGE_OBJ NO_ITEMS } {
  if 0 {
   upvar $PAGE_OBJ page_obj
   upvar $NO_ITEMS no_items
   global gPB
   set row_items $Page::($page_obj,items_in_row)
   set param_frame $Page::($page_obj,param_frame)
   set ude_frame [Page::CreateFrame $param_frame ude]
   set no_rows [llength $Page::($page_obj,items_in_row)]
   if { $no_items == 1 } \
   {
    set topitem_obj [lindex $row_items 0]
    set ref_topitem_id $item::($topitem_obj,widget_id)
    tixForm $ude_frame  -top 10  -pady 5 \
    -bottom &$ref_topitem_id \
    -left  $ref_topitem_id  \
    -padx 70
    } elseif {[expr $no_items % 2] == 0 || $no_rows ==  1} \
   {
    set last_elem [llength [lindex $row_items [expr $no_rows - 1]]]
    set topitem_obj [lindex [lindex $row_items [expr $no_rows - 1]] \
    [expr $last_elem - 1]]
    set ref_topitem_id $item::($topitem_obj,widget_id)
    tixForm $ude_frame  -top   $ref_topitem_id  -pady 5 \
    -left  &$ref_topitem_id  \
    -right &$ref_topitem_id  -padx 25
   } else \
   {
    set topitem_obj [lindex [lindex $row_items [expr $no_rows - 2]] 1]
    set ref_topitem_id $item::($topitem_obj,widget_id)
    set sideitem_obj [lindex [lindex $row_items [expr $no_rows - 1]] 0]
    set ref_sideitem_id $item::($sideitem_obj,widget_id)
    tixForm $ude_frame  -top   $ref_topitem_id  -pady 5 \
    -bottom &$ref_sideitem_id \
    -left  &$ref_topitem_id  \
    -right &$ref_topitem_id  -padx 25
   }
   set f_image [tix getimage pb_user]
   button $ude_frame.but -image $f_image \
   -command "__MenuItemCmd_nyi $ude_frame.but"
   global gPB_help_tips
   PB_enable_balloon $ude_frame.but
   set gPB_help_tips($ude_frame.but) {User-Defined parameters}
   pack $ude_frame.but -side right -padx 5 -pady 5
  }
 }

#=======================================================================
proc UI_PB_tpth_GetItemMembersCount { ITEM_OBJ } {
  upvar $ITEM_OBJ item_obj
  set item_groups $item::($item_obj,grp_obj_list)
  set no_of_members 0
  foreach group_obj $item_groups \
  {
   set group_align $item_group::($group_obj,elem_align)
   if {[string compare $group_align "V"] == 0} \
   {
    set no_of_members [expr $item_group::($group_obj,nof_elems) + \
    $no_of_members]
   } else \
   {
    incr no_of_members
   }
  }
  return $no_of_members
 }

#=======================================================================
proc UI_PB_tpth_PackItems { PAGE_OBJ } {
  upvar $PAGE_OBJ page_obj
  foreach row_items $Page::($page_obj,items_in_row) \
  {
   if {[llength $row_items] > 1} \
   {
    set first_item_obj [lindex $row_items 0]
    set sec_item_obj [lindex $row_items 1]
    set first_grp_members [UI_PB_tpth_GetItemMembersCount \
    first_item_obj]
    set sec_grp_members [UI_PB_tpth_GetItemMembersCount \
    sec_item_obj]
   } else \
   {
    set first_item_obj [lindex $row_items 0]
    set first_grp_members 0
    set sec_grp_members 0
   }
   if {$sec_grp_members > $first_grp_members} \
   {
    set item::($sec_item_obj,ref_side) "left"
    UI_PB_tpth_TixForm page_obj sec_item_obj
    set item::($first_item_obj,ref_side) "right"
    UI_PB_tpth_TixForm page_obj first_item_obj
    } elseif {$first_grp_members == 0 && $sec_grp_members == 0} \
   {
    set item::($first_item_obj,ref_side) "right"
    UI_PB_tpth_TixForm page_obj first_item_obj
   } else \
   {
    set item::($first_item_obj,ref_side) "right"
    UI_PB_tpth_TixForm page_obj first_item_obj
    set item::($sec_item_obj,ref_side) "left"
    UI_PB_tpth_TixForm page_obj sec_item_obj
   }
  }
 }

#=======================================================================
proc UI_PB_tpth_CreateMembersOfItem { PAGE_OBJ EVENT_OBJ} {
  upvar $PAGE_OBJ page_obj
  upvar $EVENT_OBJ event_obj
  global gPB
  if {![info exists Page::($page_obj,items_in_row)]} \
  {
   return
  }
  set item_obj_list $Page::($page_obj,items_in_row)
  foreach row_items $item_obj_list \
  {
   foreach item_obj $row_items \
   {
    if {[string compare $item::($item_obj,label) "null"] != 0} \
    {
     set widget_id [$item::($item_obj,widget_id) subwidget frame]
    } else \
    {
     set widget_id $item::($item_obj,widget_id)
    }
    set item_group_list $item::($item_obj,grp_obj_list)
    set grp_no 0
    if {[string compare $item::($item_obj,grp_align) "V"] == 0} \
    {
     set pack_item "top"
    } else \
    {
     set pack_item "left"
    }
    foreach group_obj $item_group_list \
    {
     set group_align $item_group::($group_obj,elem_align)
     set members_obj_list $item_group::($group_obj,mem_obj_list)
     set grp_name $item_group::($group_obj,name)
     if { [string match "*\$gPB(*" $grp_name] } \
     {
      set grp_name "[eval format %s $grp_name]"
     }
     if {[string compare $grp_name "null"] == 0} \
     {
      set grp_frame [Page::CreateFrame $widget_id grp_$grp_no]
      pack $grp_frame -side $pack_item -expand yes -fill both -padx 5
     } else \
     {
      set grp_lblframe [Page::CreateLblFrame $widget_id grp_$grp_no \
      $grp_name]
      pack $grp_lblframe -side $pack_item -padx 0 -fill x
      set grp_frame [$grp_lblframe subwidget frame]
     }
     set memb_no 0
     if {![string compare $group_align "V"]} \
     {
      set memb_pack "top"
     } else \
     {
      set memb_pack "left"
     }
     foreach member_obj $members_obj_list \
     {
      set memb_frame [Page::CreateFrame $grp_frame memb_$memb_no]
      pack $memb_frame -side $memb_pack -expand yes -fill both
      UI_PB_tpth_CreateAWidget page_obj event_obj member_obj \
      $memb_frame $memb_no
      incr memb_no
     }
     incr grp_no
    }
   }
  }
 }

#=======================================================================
proc UI_PB_tpth_TixForm { PAGE_OBJ ITEM_OBJ} {
  upvar $PAGE_OBJ page_obj
  upvar $ITEM_OBJ item_obj
  UI_PB_tpth_GetReferenceWidgets page_obj item_obj ref_topitem_id \
  ref_sideitem_id
  if {$ref_topitem_id} \
  {
   set ref_topitem_id $item::($ref_topitem_id,widget_id)
  }
  if {$ref_sideitem_id} \
  {
   set ref_sideitem_id $item::($ref_sideitem_id,widget_id)
  }
  set packed_items $Page::($page_obj,packed_items)
  set item_row $item::($item_obj,row)
  set item_col $item::($item_obj,col)
  set row_items [lindex $packed_items $item_row]
  set row_items [lreplace $row_items $item_col $item_col $item_obj]
  set packed_items [lreplace $packed_items $item_row $item_row $row_items]
  set Page::($page_obj,packed_items) $packed_items
  set ref_side $item::($item_obj,ref_side)
  set widget_id $item::($item_obj,widget_id)
  if { $ref_topitem_id == 0  && $ref_sideitem_id == 0 } \
  {
   tixForm $widget_id  -top  10  -pady 5 \
   -$ref_side %50 -padx 25
   } elseif { $ref_topitem_id == 0 && $ref_sideitem_id != 0 } \
  {
   tixForm $widget_id  -top  10  -pady 5 \
   -bottom &$ref_sideitem_id \
   -$ref_side $ref_sideitem_id -padx 25
   } elseif { $ref_topitem_id != 0 && $ref_sideitem_id == 0} \
  {
   tixForm $widget_id  -top   $ref_topitem_id  -pady 5 \
   -left  &$ref_topitem_id  \
   -right &$ref_topitem_id  -padx 25
  } else \
  {
   tixForm $widget_id  -top   $ref_topitem_id  -pady 5 \
   -bottom &$ref_sideitem_id \
   -left  &$ref_topitem_id  \
   -right &$ref_topitem_id  -padx 25
  }
 }

#=======================================================================
proc UI_PB_tpth_GetReferenceWidgets { PAGE_OBJ ITEM_OBJ REF_TOPITEM_ID \
  REF_SIDEITEM_ID} {
  upvar $PAGE_OBJ page_obj
  upvar $ITEM_OBJ item_obj
  upvar $REF_TOPITEM_ID ref_topitem_id
  upvar $REF_SIDEITEM_ID ref_sideitem_id
  set packed_items $Page::($page_obj,packed_items)
  set ref_side $item::($item_obj,ref_side)
  set row $item::($item_obj,row)
  set col $item::($item_obj,col)
  if {$row} \
  {
   set row_item_list  [lindex $packed_items [expr $row - 1]]
   set ref_topitem_id [lindex  $row_item_list $col]
  } else \
  {
   set ref_topitem_id 0
  }
  if {[string compare $ref_side "left"] == 0} \
  {
   set ref_incr -1
  } else \
  {
   set ref_incr 1
  }
  set row_item_list  [lindex $packed_items $row]
  if {[llength $row_item_list] > 1} \
  {
   set ref_sideitem_id [lindex $row_item_list [expr $col + $ref_incr]]
  } else \
  {
   set ref_sideitem_id 0
  }
 }

#=======================================================================
proc UI_PB_tpth_CreateAWidget {PAGE_OBJ EVENT_OBJ MEMBER_OBJ inp_frm no} {
  upvar $PAGE_OBJ page_obj
  upvar $EVENT_OBJ event_obj
  upvar $MEMBER_OBJ member_obj
  global gPB
  set label $group_member::($member_obj,label)
  if { [string match "*\$gPB(*" $label] } \
  {
   set label "[eval format %s $label]"
  }
  if {[string compare $label "null"] == 0} \
  {
   set label ""
  }
  set widget_type $group_member::($member_obj,widget_type)
  set val1 $group_member::($member_obj,mom_var)
  set call_back $group_member::($member_obj,callback)
  switch $widget_type \
  {
   0 {
    set ext int_$no
    Page::CreateIntControl $val1 $inp_frm $ext $label
   }
   1 {
    set ext but_$no
    Page::CreateButton $inp_frm $ext $label
    if {[string compare $call_back "null"] != 0} \
    {
     $inp_frm.$ext config -command "$call_back $page_obj \
     $event_obj $member_obj"
    }
   }
   2 {
    set data_type $group_member::($member_obj,data_type)
    set ext lent_$no
    Page::CreateLblEntry $data_type $val1 $inp_frm $ext $label
    if {[string compare $call_back "null"] != 0} \
    {
     bind $inp_frm.1_$ext <Return> "$call_back $page_obj \
     $event_obj $member_obj"
    }
   }
   3 {
    set ext chkbut_$no
    Page::CreateCheckButton $val1 $inp_frm $ext $label
    if {[string compare $call_back "null"] != 0} \
    {
     $inp_frm.$ext config -command "$call_back $page_obj \
     $event_obj $member_obj"
    }
   }
   4 {
    set ext radbut_$no
    Page::CreateRadioButton $val1 $inp_frm $ext $label
   }
   5 {
    set ext flot_$no
    append temp1 $val1 _int
    append temp2 $val1 _dec
    set val1 $temp1
    set val2 $temp2
    unset temp1
    unset temp2
    Page::CreateFloatControl $val1 $val2 $inp_frm $ext $label
   }
   6 {
    set ext bent_$no
    Page::CreateEntry $val1 $inp_frm $ext
   }
   7 {
    set ext lb_$no
    Page::CreateLabel $inp_frm $ext $label
   }
   8 {
    set ext opt_$no
    set optional_list $group_member::($member_obj,opt_list)
    Page::CreateOptionalMenu $val1 $inp_frm $ext $optional_list \
    $label
    if {[string compare $call_back "null"] != 0} \
    {
     $inp_frm.$ext config -command "$call_back $page_obj \
     $event_obj $member_obj"
    }
   }
   9 {
    set ext com_$no
    Page::CreateFmtComboBox $val1 $inp_frm $ext
    if {[string compare $call_back "null"] != 0} \
    {
     $inp_frm.but_$ext config -command "$call_back $page_obj \
     $event_obj $member_obj"
    }
   }
   10 {
    set ext cbox_$no
    set optional_list $group_member::($member_obj,opt_list)
    Page::CreateCombBox $val1 $inp_frm $ext $optional_list
    if {[string compare $call_back "null"] != 0} \
    {
     $inp_frm.$ext config -command "$call_back $page_obj \
     $event_obj $member_obj"
    }
   }
  }
  set group_member::($member_obj,inp_frm) $inp_frm
  set group_member::($member_obj,ext) $ext
  if { $group_member::($member_obj,context_help) != "" } {
   set gPB(c_help,$inp_frm.$ext)  "$group_member::($member_obj,context_help)"
  }
 }

#=======================================================================
proc UI_PB_tpth_EditFeedFmt { page_obj event_obj member_obj } {
  global mom_sys_arr
  global gPB
  set canvas_frame $Page::($page_obj,canvas_frame)
  set mom_var $group_member::($member_obj,mom_var)
  set Format_Name $mom_sys_arr($mom_var)
  PB_int_RetFmtObjFromName Format_Name fmt_obj
  format::readvalue $fmt_obj FORMATOBJATTR
  set win [toplevel $canvas_frame.fmt]
  set toplevel_index [llength $gPB(toplevel_list)]
  set win_index [expr $toplevel_index + 1]
  set gPB(toplevel_disable_$win_index) 1
  UI_PB_com_CreateTransientWindow $win \
  "$gPB(tool,format_trans,title,Label) : $FORMATOBJATTR(0)" \
  "500x500+200+200" "" "UI_PB_tpth_DisableTpthEvtWidgets $page_obj" "" \
  "UI_PB_tpth_ActivateTpthEvtWidgets $page_obj $event_obj $win_index"
  set inp_frm $group_member::($member_obj,inp_frm)
  set ext $group_member::($member_obj,ext)
  set comb_widget $inp_frm.cb_$ext
  format::readvalue $fmt_obj FORMATOBJATTR
  set pname $FORMATOBJATTR(0)
  set new_fmt_page [new Page $pname $pname]
  UI_PB_fmt_CreateFmtPage $page_obj $fmt_obj $new_fmt_page $win $comb_widget 0
  UI_PB_com_PositionWindow $win
 }

#=======================================================================
proc UI_PB_tpth_EntryCallBack { page_obj event_obj member_obj } {
  global mom_sys_arr
  set mom_var $group_member::($member_obj,mom_var)
  UI_PB_tpth_DeleteAndRecreateIcons page_obj event_obj
 }

#=======================================================================
proc UI_PB_tpth_DelayOutput { page_obj event_obj member_obj args } {
  global mom_sys_arr
  switch $mom_sys_arr(\$delay_output_mode) \
  {
   "SECONDS_ONLY" { set mom_sys_arr(\$mom_sys_delay_output_mode) "SECONDS" }
   "REVOLUTIONS_ONLY" { set mom_sys_arr(\$mom_sys_delay_output_mode) "REVOLUTIONS" }
   "DEPENDS_ON_FEEDRATE" { set mom_sys_arr(\$mom_sys_delay_output_mode) "FEEDRATE" }
   "INVERSE_TIME" { set mom_sys_arr(\$mom_sys_delay_output_mode) "INVERSE" }
  }
 }

#=======================================================================
proc UI_PB_tpth_IJKParameters { page_obj event_obj member_obj args } {
  global mom_sys_arr
  global gPB
  set elem_desc ""
  switch $mom_sys_arr(\$mom_sys_cir_vector) \
  {
   "Vector - Arc Start to Center" \
   {
    set expr_i "\$mom_pos_arc_center(0) - \$mom_prev_pos(0)"
    set expr_j "\$mom_pos_arc_center(1) - \$mom_prev_pos(1)"
    set expr_k "\$mom_pos_arc_center(2) - \$mom_prev_pos(2)"
    set elem_desc "$gPB(tool,ijk_desc,arc_start,Label)"
   }
   "Vector-Center to Arc Start" -
   "Vector - Arc Center to Start" \
   {
    set expr_i "\$mom_prev_pos(0) - \$mom_pos_arc_center(0)"
    set expr_j "\$mom_prev_pos(1) - \$mom_pos_arc_center(1)"
    set expr_k "\$mom_prev_pos(2) - \$mom_pos_arc_center(2)"
    set elem_desc "$gPB(tool,ijk_desc,arc_center,Label)"
   }
   "Unsigned Vector - Arc Start to Center" \
   {
    set expr_i "abs(\$mom_pos_arc_center(0) - \$mom_prev_pos(0))"
    set expr_j "abs(\$mom_pos_arc_center(1) - \$mom_prev_pos(1))"
    set expr_k "abs(\$mom_pos_arc_center(2) - \$mom_prev_pos(2))"
    set elem_desc "$gPB(tool,ijk_desc,u_arc_start,Label)"
   }
   "Vector - Absolute Arc Center"
   {
    set expr_i "\$mom_pos_arc_center(0)"
    set expr_j "\$mom_pos_arc_center(1)"
    set expr_k "\$mom_pos_arc_center(2)"
    set elem_desc "$gPB(tool,ijk_desc,absolute,Label)"
   }
  }
  set add_name "I"
  PB_int_RetAddrObjFromName add_name add_obj
  set search_var "mom_pos_arc_center(0)"
  set elem_desc_i "$elem_desc X-Axis"
  UI_PB_tpth_UpdateVarAddress add_obj search_var expr_i elem_desc_i
  set add_name "J"
  PB_int_RetAddrObjFromName add_name add_obj
  set search_var "mom_pos_arc_center(1)"
  set elem_desc_j "$elem_desc Y-Axis"
  UI_PB_tpth_UpdateVarAddress add_obj search_var expr_j elem_desc_j
  set add_name "K"
  PB_int_RetAddrObjFromName add_name add_obj
  set search_var "mom_pos_arc_center(2)"
  set elem_desc_k "$elem_desc Z-Axis"
  UI_PB_tpth_UpdateVarAddress add_obj search_var expr_k elem_desc_k
  UI_PB_tpth_DeleteAndRecreateIcons page_obj event_obj
 }

#=======================================================================
proc UI_PB_tpth_EditPlaneCodes { page_obj event_obj member_obj } {
  global mom_sys_arr
  global gPB
  set canvas_frame $Page::($page_obj,canvas_frame)
  set win $canvas_frame.epc
  if {[winfo exists $win]} \
  {
   raise $win
   focus $win
   return
  } else \
  {
   toplevel $win
   set toplevel_index [llength $gPB(toplevel_list)]
   set win_index [expr $toplevel_index + 1]
   set gPB(toplevel_disable_$win_index) 1
   UI_PB_com_CreateTransientWindow $win "$gPB(tool,circ_trans,title,Label)" \
   "" "" "UI_PB_tpth_DisableTpthEvtWidgets $page_obj" "" \
   "UI_PB_tpth_ActivateTpthEvtWidgets $page_obj $event_obj $win_index"
  }
  set mom_variables { \$mom_sys_cutcom_plane_code(XY) \
   \$mom_sys_cutcom_plane_code(YZ) \
  \$mom_sys_cutcom_plane_code(ZX)}
  foreach var $mom_variables \
  {
   set rest_var($var) $mom_sys_arr($var)
  }
  set Page::($page_obj,rest_page_momvalues) [array get rest_var]
  set Page::($page_obj,page_momvars) $mom_variables
  set top_frm [frame $win.top]
  set bot_frm [frame $win.bot]
  pack $top_frm -side top -fill x -padx 10 -pady 10
  pack $bot_frm -side bottom -fill x -padx 3 -pady 3
  set plane_lbfrm [Page::CreateLblFrame $top_frm edt " Plane G Codes "]
  pack $plane_lbfrm -pady 5 -padx 25
  set pln_frm [$plane_lbfrm subwidget frame]
  set xy_frm [frame $pln_frm.xy]
  set yz_frm [frame $pln_frm.yz]
  set zx_frm [frame $pln_frm.zx]
  pack $xy_frm $yz_frm $zx_frm -anchor nw -padx 10 -pady 10
  UI_PB_mthd_CreateLblEntry a \$mom_sys_cutcom_plane_code(XY) $xy_frm \
  int "$gPB(tool,circ_trans,xy,Label)"
  UI_PB_mthd_CreateLblEntry a \$mom_sys_cutcom_plane_code(YZ) $yz_frm \
  int "$gPB(tool,circ_trans,yz,Label)"
  UI_PB_mthd_CreateLblEntry a \$mom_sys_cutcom_plane_code(ZX) $zx_frm \
  int "$gPB(tool,circ_trans,zx,Label)"
  set cb_arr(gPB(nav_button,default,Label)) \
  "UI_PB_tpth_DialogDefault_CB $page_obj"
  set cb_arr(gPB(nav_button,restore,Label)) \
  "UI_PB_tpth_DialogRestore_CB $page_obj"
  set cb_arr(gPB(nav_button,cancel,Label)) \
  "UI_PB_tpth_PlaneCodeCancel_CB $win $page_obj"
  set cb_arr(gPB(nav_button,ok,Label)) \
  "UI_PB_tpth_PlaneCodeOk_CB $win $page_obj $event_obj"
  UI_PB_com_CreateActionElems $bot_frm cb_arr
  UI_PB_com_PositionWindow $win
 }

#=======================================================================
proc UI_PB_tpth_DialogDefault_CB { page_obj } {
  global mom_sys_arr
  set mom_var_list $Page::($page_obj,page_momvars)
  set count 0
  foreach var $mom_var_list \
  {
   set mom_var_arr($count) $var
   incr count
  }
  PB_int_RetDefMOMVarValues mom_var_arr def_var_values
  foreach var $mom_var_list \
  {
   set mom_sys_arr($var) $def_var_values($var)
  }
 }

#=======================================================================
proc UI_PB_tpth_DialogRestore_CB { page_obj } {
  global mom_sys_arr
  set mom_var_list $Page::($page_obj,page_momvars)
  array set rest_var_values $Page::($page_obj,rest_page_momvalues)
  foreach var $mom_var_list \
  {
   set mom_sys_arr($var) $rest_var_values($var)
  }
 }

#=======================================================================
proc UI_PB_tpth_PlaneCodeOk_CB { win page_obj event_obj } {
  global mom_sys_arr
  set mom_var_list $Page::($page_obj,page_momvars)
  PB_int_UpdateMOMVar mom_sys_arr
  unset Page::($page_obj,rest_page_momvalues)
  unset Page::($page_obj,page_momvars)
  destroy $win
  UI_PB_tpth_DeleteAndRecreateIcons page_obj event_obj
  update idletasks
 }

#=======================================================================
proc UI_PB_tpth_PlaneCodeCancel_CB { win page_obj } {
  UI_PB_tpth_DialogRestore_CB $page_obj
  unset Page::($page_obj,rest_page_momvalues)
  unset Page::($page_obj,page_momvars)
  destroy $win
  update idletasks
 }

#=======================================================================
proc UI_PB_tpth_SpecifySpindleRangeCodes { page_obj event_obj member_obj} {
  global tixOption
  global paOption
  global mom_sys_arr
  global gPB
  set canvas_frame $Page::($page_obj,canvas_frame)
  set win $canvas_frame.tlcd
  if {[winfo exists $win]} \
  {
   raise $win
   focus $win
   return
  } else \
  {
   toplevel $canvas_frame.tlcd
   set toplevel_index [llength $gPB(toplevel_list)]
   set win_index [expr $toplevel_index + 1]
   set gPB(toplevel_disable_$win_index) 1
   UI_PB_com_CreateTransientWindow $win \
   "$gPB(tool,spindle_trans,title,Label)" "" \
   "" "UI_PB_tpth_DisableTpthEvtWidgets $page_obj" "" \
   "UI_PB_tpth_ActivateTpthEvtWidgets $page_obj $event_obj $win_index"
  }
  if { ![info exists mom_sys_arr(\$mom_sys_spindle_ranges)] } \
  {
   set mom_sys_arr(\$mom_sys_spindle_ranges) 0
  }
  set top_frm [frame $win.top]
  set mid_frm [frame $win.mid]
  set bot_frm [frame $win.bot]
  pack $top_frm -side top
  pack $mid_frm -side top -fill both -expand yes
  pack $bot_frm -side bottom -fill both -expand yes -padx 3 -pady 3
  Page::CreateLblFrame $top_frm frm  "$gPB(tool,spindle,range,type,Label)"
  set frm [$top_frm.frm subwidget frame]
  set m_opts { None Separate_M_Code(41) Range_Code_with_M_Code \
  High_or_Low_Range_S_Code}
  set m_opt_labels(None)                     "$gPB(other,opt_none,Label)"
  set m_opt_labels(Separate_M_Code(41))      "$gPB(tool,spindle,range,range_M,Label)"
  set m_opt_labels(Range_Code_with_M_Code)   "$gPB(tool,spindle,range,with_spindle_M,Label)"
  set m_opt_labels(High_or_Low_Range_S_Code) "$gPB(tool,spindle,range,hi_lo_with_S,Label)"
  tixOptionMenu $frm.opt \
  -options {
   menubutton.width 40
  }
  foreach opt $m_opts {
   $frm.opt add command $opt -label "$m_opt_labels($opt)"
  }
  pack $top_frm.frm -side top -fill x -padx 10 -pady 10
  pack $frm.opt -side top -fill x -padx 20 -pady 10
  $frm.opt config -command "UI_PB_tpth_SetSpindleRange $mid_frm"
  set label_list {"gPB(nav_button,cancel,Label)" \
  "gPB(nav_button,ok,Label)"}
  set cb_arr(gPB(nav_button,cancel,Label)) \
  "UI_PB_tpth_SpindleRangeCancel $win $page_obj $mid_frm"
  set cb_arr(gPB(nav_button,ok,Label)) \
  "UI_PB_tpth_SpindleRangeOk $win $page_obj $event_obj"
  UI_PB_com_CreateButtonBox $bot_frm label_list cb_arr
  set table_list [list code min max]
  set frm0 [frame $mid_frm.scr0 -bd 0]
  for { set row_no 1 } { $row_no <= 9 } { incr row_no } \
  {
   foreach elem $table_list \
   {
    set var "\$spindle_range(1,$row_no,$elem)"
    if { ![info exists mom_sys_arr($var)] } \
    {
     switch $elem \
     {
      "code" \
      {
       set mom_sys_arr($var) [expr 40 + $row_no]
      }
      "min" \
      {
       set mom_sys_arr($var) 1
      }
      "max" \
      {
       set mom_sys_arr($var) 9999
      }
      default \
      {
       set mom_sys_arr($var) 0
      }
     }
    }
   }
  }
  UI_PB_tpth_CreateTable $mid_frm 9 1
  for { set row_no 1 } { $row_no <= 9 } { incr row_no } \
  {
   foreach elem $table_list \
   {
    set var "\$spindle_range(2,$row_no,$elem)"
    if { ![info exists mom_sys_arr($var)] } \
    {
     switch $elem \
     {
      "code" \
      {
       set mom_sys_arr($var) $row_no
      }
      "min" \
      {
       set mom_sys_arr($var) 1
      }
      "max" \
      {
       set mom_sys_arr($var) 9999
      }
      default \
      {
       set mom_sys_arr($var) 0
      }
     }
    }
   }
  }
  UI_PB_tpth_CreateTable $mid_frm 9 2
  set mom_sys_arr(\$spindle_range(3,1,code)) +1
  set mom_sys_arr(\$spindle_range(3,2,code)) -1
  set table_list [list min max]
  for { set row_no 1 } { $row_no <= 2 } { incr row_no } \
  {
   foreach elem $table_list \
   {
    set var "\$spindle_range(3,$row_no,$elem)"
    if { ![info exists mom_sys_arr($var)] } \
    {
     switch $elem \
     {
      "min" \
      {
       set mom_sys_arr($var) 1
      }
      "max" \
      {
       set mom_sys_arr($var) 9999
      }
      default \
      {
       set mom_sys_arr($var) 0
      }
     }
    }
   }
  }
  UI_PB_tpth_CreateTable $mid_frm 2 3
  $frm.opt config -value $mom_sys_arr(\$spin_fmt_type)
  UI_PB_tpth_GetRangeAttrbutes no_rows code_edit
  if { $code_edit } \
  {
   set table_list [list code min max]
   for { set count 1 } { $count < $no_rows } { incr count } \
   {
    foreach elem $table_list \
    {
     set var "\$spindle_range($code_edit,$count,$elem)"
     set rest_range_data($var) $mom_sys_arr($var)
    }
   }
  }
  set rest_range_data(\$spin_fmt_type) $mom_sys_arr(\$spin_fmt_type)
  set rest_range_data(\$mom_sys_spindle_ranges) \
  $mom_sys_arr(\$mom_sys_spindle_ranges)
  set Page::($page_obj,rest_range_data) [array get rest_range_data]
  UI_PB_com_PositionWindow $win
 }

#=======================================================================
proc UI_PB_tpth_CreateTable { frm no_rows code_edit } {
  global paOption
  global mom_sys_arr
  set grid_frm $frm.scr$code_edit
  tixScrolledGrid $grid_frm -bd 0 -scrollbar auto
  [$grid_frm subwidget hsb] config -troughcolor $paOption(trough_bg) \
  -width $paOption(trough_wd)
  [$grid_frm subwidget vsb] config -troughcolor $paOption(trough_bg) \
  -width $paOption(trough_wd)
  set grid [$grid_frm subwidget grid]
  UI_PB_tpth_CreateTitleElems $grid
  for { set count 0 } { $count < $no_rows } { incr count } \
  {
   UI_PB_tpth_CreateRowElems $grid [expr $count + 1] $code_edit
  }
  $grid size col default -size auto -pad0 5 -pad1 5
  $grid size row default -size auto -pad0 3 -pad1 4
  set height [expr $no_rows + 1]
  $grid config -relief sunken -bd 3 -state disabled \
  -formatcmd "UI_PB_ads_SimpleFormat $grid" -height $height -width 4
 }

#=======================================================================
proc UI_PB_tpth_SpindleRangeCancel { win page_obj mid_frm } {
  global mom_sys_arr
  array set rest_range_data $Page::($page_obj,rest_range_data)
  UI_PB_tpth_SetSpindleRange $mid_frm $rest_range_data(\$spin_fmt_type)
  UI_PB_tpth_GetRangeAttrbutes no_rows code_edit
  set table_list [list code min max]
  for { set count 1 } { $count < $no_rows } { incr count } \
  {
   foreach elem $table_list \
   {
    set var "\$spindle_range($code_edit,$count,$elem)"
    if [ info exists rest_range_data($var) ] \
    {
     set mom_sys_arr($var) $rest_range_data($var)
    }
   }
  }
  PB_int_UpdateMOMVar mom_sys_arr
  unset Page::($page_obj,rest_range_data)
  destroy $win
 }

#=======================================================================
proc UI_PB_tpth_SpindleRangeOk { win page_obj event_obj } {
  global mom_sys_arr
  set add_name "PB_Spindle"
  UI_PB_tpth_GetRangeAttrbutes no_rows code_edit
  set table_list [list code min max]
  set add_mom_var ""
  set add_var_desc ""
  for { set count 1 } { $count <= $no_rows } { incr count } \
  {
   foreach elem $table_list \
   {
    lappend add_mom_var "\$spindle_range($code_edit,$count,$elem)"
    lappend add_var_desc ""
   }
  }
  PB_int_UpdateMOMVarDescAddress add_name add_var_desc
  PB_int_UpdateMOMVarOfAddress add_name add_mom_var
  PB_int_UpdateMOMVar mom_sys_arr
  UI_PB_tpth_DeleteAndRecreateIcons page_obj event_obj
  unset Page::($page_obj,rest_range_data)
  destroy $win
 }

#=======================================================================
proc UI_PB_tpth_CreateTitleElems { grid } {
  global tixOption
  global paOption
  global gPB
  set style [tixDisplayStyle text -refwindow $grid \
  -fg $paOption(title_fg) \
  -anchor c -font $tixOption(bold_font)]
  set title_col(0) "$gPB(tool,spindle_trans,range,Label)"
  set title_col(1) "$gPB(tool,spindle_trans,code,Label)"
  set title_col(2) "$gPB(tool,spindle_trans,min,Label)"
  set title_col(3) "$gPB(tool,spindle_trans,max,Label)"
  set no_col 4
  for {set col 0} {$col < $no_col} {incr col} \
  {
   $grid set $col 0 -itemtype text -text $title_col($col) -style $style
  }
 }

#=======================================================================
proc UI_PB_tpth_CreateRowElems { grid row_no code_edit } {
  global paOption
  global mom_sys_arr
  $grid set 0 $row_no -itemtype text -text $row_no
  set mcd_frm [frame $grid.mcd_$row_no]
  set var "\$spindle_range($code_edit,$row_no,code)"
  entry $mcd_frm.ent -width 8 -relief sunken \
  -textvariable mom_sys_arr($var)
  tixForm $mcd_frm.ent -top 3 -left %10 -right %95
  if { $code_edit == 2 || $code_edit == 3 } \
  {
   $mcd_frm.ent config -state disabled -bg $paOption(entry_disabled_bg)
  } else \
  {
   bind $mcd_frm.ent <KeyPress> "UI_PB_com_ValidateDataOfEntry %W %K f"
   bind $mcd_frm.ent <KeyRelease> { %W config -state normal }
  }
  $grid set 1 $row_no -itemtype window -window $mcd_frm
  set min_frm [frame $grid.min_$row_no]
  set var "\$spindle_range($code_edit,$row_no,min)"
  entry $min_frm.ent -width 8 -relief sunken \
  -textvariable mom_sys_arr($var)
  tixForm $min_frm.ent -top 3 -left %10 -right %95
  bind $min_frm.ent <KeyPress> "UI_PB_com_ValidateDataOfEntry %W %K f"
  bind $min_frm.ent <KeyRelease> { %W config -state normal }
  $grid set 2 $row_no -itemtype window -window $min_frm
  set max_frm [frame $grid.max_$row_no]
  set var "\$spindle_range($code_edit,$row_no,max)"
  entry $max_frm.ent -width 8 -relief sunken \
  -textvariable mom_sys_arr($var)
  tixForm $max_frm.ent -top 3 -left %10 -right %95
  bind $max_frm.ent <KeyPress> "UI_PB_com_ValidateDataOfEntry %W %K f"
  bind $max_frm.ent <KeyRelease> { %W config -state normal }
  $grid set 3 $row_no -itemtype window -window $max_frm
 }

#=======================================================================
proc UI_PB_tpth_GetRangeAttrbutes { NO_ROWS SEL_OPT_NO } {
  upvar $NO_ROWS no_rows
  upvar $SEL_OPT_NO sel_opt_no
  global mom_sys_arr
  set no_rows $mom_sys_arr(\$mom_sys_spindle_ranges)
  switch $mom_sys_arr(\$spin_fmt_type) \
  {
   "None"                     { set sel_opt_no 0 }
   "Separate_M_Code(41)"      { set sel_opt_no 1 }
   "Range_Code_with_M_Code"   { set sel_opt_no 2 }
   "High_or_Low_Range_S_Code" { set sel_opt_no 3 }
   "Odd_or_Even_Range_S_Code" { set sel_opt_no 4 }
   default                    { set sel_opt_no 0 }
  }
 }

#=======================================================================
proc UI_PB_tpth_UpdatePrevSelData { sel_option } {
  switch $sel_option \
  {
   "Range_Code_with_M_Code" \
   {
    set elem_expr "\$mom_sys_spindle_direction_code(\$mom_spindle_direction)"
    set elem_desc "Spindle Direction (CLW/CCLW)"
    set add_name "M_spindle"
    PB_int_RetMOMVarAsscAddress add_name add_mom_var_list
    PB_int_RetMOMVarDescAddress add_name add_mom_var_desc
    set index [lsearch $add_mom_var_list "$elem_expr"]
    if { $index != -1 } \
    {
     set elem_desc [lindex $add_mom_var_desc $index]
    }
    set search_var "mom_sys_spindle_direction_code(\$mom_spindle_direction)"
    PB_int_RetAddrObjFromName add_name add_obj
    UI_PB_tpth_UpdateVarAddress add_obj search_var elem_expr elem_desc
   }
   "High_or_Low_Range_S_Code" \
   {
    set elem_expr "\$mom_spindle_speed"
    set elem_desc "Spindle Speed"
    set add_name "S"
    PB_int_RetMOMVarAsscAddress add_name add_mom_var_list
    PB_int_RetMOMVarDescAddress add_name add_mom_var_desc
    set index [lsearch $add_mom_var_list "$elem_expr"]
    if { $index != -1 } \
    {
     set elem_desc [lindex $add_mom_var_desc $index]
    }
    PB_int_RetAddrObjFromName add_name add_obj
    set search_var "mom_spindle_speed"
    UI_PB_tpth_UpdateVarAddress add_obj search_var elem_expr elem_desc
   }
   "Odd_or_Even_Range_S_Code" \
   {
    set elem_expr "\$mom_spindle_speed"
    set elem_desc ""
    set add_name "S"
    PB_int_RetMOMVarAsscAddress add_name add_mom_var_list
    PB_int_RetMOMVarDescAddress add_name add_mom_var_desc
    set index [lsearch $add_mom_var_list $elem_expr]
    if { $index != -1 } \
    {
     set elem_desc [lindex $add_mom_var_desc $index]
    }
    PB_int_RetAddrObjFromName add_name add_obj
    set search_var "mom_spindle_speed"
    UI_PB_tpth_UpdateVarAddress add_obj search_var elem_expr elem_desc
   }
  }
 }

#=======================================================================
proc UI_PB_tpth_SetSpindleRange { mid_frm sel_option } {
  global mom_sys_arr
  global gPB
  if { $sel_option != "$mom_sys_arr(\$spin_fmt_type)" } \
  {
   UI_PB_tpth_UpdatePrevSelData "$mom_sys_arr(\$spin_fmt_type)"
   switch $sel_option \
   {
    "None" \
    {
     set elem_expr ""
     set mom_sys_arr(\$mom_sys_spindle_ranges 0
    }
    "Separate_M_Code(41)" \
    {
     set mom_sys_arr(\$mom_sys_spindle_ranges) 9
     set elem_expr "\$mom_sys_spindle_range_code(\$mom_spindle_range)"
     set elem_desc "$gPB(tool,spindle_desc,sep,Label)"
     set add_name "M_range"
     PB_int_RetAddrObjFromName add_name add_obj
     set search_var "mom_spindle_range"
     UI_PB_tpth_UpdateVarAddress add_obj search_var elem_expr elem_desc
    }
    "Range_Code_with_M_Code" \
    {
     set mom_sys_arr(\$mom_sys_spindle_ranges) 9
     set elem_expr "10 * \$mom_spindle_range + \
     \$mom_sys_spindle_direction_code(\$mom_spindle_direction)"
     set elem_desc "$gPB(tool,spindle_desc,range,Label)"
     set add_name "M_spindle"
     PB_int_RetAddrObjFromName add_name add_obj
     set search_var "mom_sys_spindle_direction_code(\$mom_spindle_direction)"
     UI_PB_tpth_UpdateVarAddress add_obj search_var elem_expr elem_desc
    }
    "High_or_Low_Range_S_Code" \
    {
     set mom_sys_arr(\$mom_sys_spindle_ranges) 2
     set elem_expr "\$mom_spindle_speed * \
     \$mom_sys_spindle_range_code(\$mom_spindle_range)"
     set elem_desc "$gPB(tool,spindle_desc,high,Label)"
     set add_name "S"
     PB_int_RetAddrObjFromName add_name add_obj
     set search_var "mom_spindle_speed"
     UI_PB_tpth_UpdateVarAddress add_obj search_var elem_expr elem_desc
    }
    "Odd_or_Even_Range_S_Code" \
    {
     set mom_sys_arr(\$mom_sys_spindle_ranges) 2
     set elem_expr "\$mom_spindle_speed + \
     \$mom_sys_spindle_range_code(\$mom_spindle_range)"
     set elem_desc "$gPB(tool,spindle_desc,odd,Label)"
     set add_name "S"
     PB_int_RetAddrObjFromName add_name add_obj
     set search_var "mom_spindle_speed"
     UI_PB_tpth_UpdateVarAddress add_obj search_var elem_expr elem_desc
    }
   }
   set mom_sys_arr(\$spin_fmt_type) $sel_option
  }
  if { [winfo manager $mid_frm.scr0] == "pack" } { pack forget $mid_frm.scr0 }
  if { [winfo manager $mid_frm.scr1] == "pack" } { pack forget $mid_frm.scr1 }
  if { [winfo manager $mid_frm.scr2] == "pack" } { pack forget $mid_frm.scr2 }
  if { [winfo manager $mid_frm.scr3] == "pack" } { pack forget $mid_frm.scr3 }
  UI_PB_tpth_GetRangeAttrbutes no_rows code_edit
  pack $mid_frm.scr$code_edit -side top
 }

#=======================================================================
proc UI_PB_tpth_ConfToolCode { page_obj event_obj member_obj } {
  global tixOption
  global paOption
  global mom_sys_arr
  global mom_kin_var
  global gPB
  global paOption
  set canvas_frame $Page::($page_obj,canvas_frame)
  set win $canvas_frame.tlcd
  if {[winfo exists $win]} \
  {
   raise $win
   focus $win
   return
  } else \
  {
   toplevel $canvas_frame.tlcd
   set toplevel_index [llength $gPB(toplevel_list)]
   set win_index [expr $toplevel_index + 1]
   set gPB(toplevel_disable_$win_index) 1
   UI_PB_com_CreateTransientWindow $win "$gPB(tool,tool_trans,title,Label)" \
   "" "" "UI_PB_tpth_DisableTpthEvtWidgets $page_obj" "" \
   "UI_PB_tpth_ActivateTpthEvtWidgets $page_obj $event_obj $win_index"
  }
  set mom_variables {\$tool_num_output}
  foreach var $mom_variables \
  {
   set rest_var($var) $mom_sys_arr($var)
  }
  set Page::($page_obj,rest_page_momvalues) [array get rest_var]
  set Page::($page_obj,page_momvars) $mom_variables
  set top_frm [tixButtonBox $win.top -orientation horizontal \
  -bd 2 -relief sunken -bg gray85]
  set mid_frm [frame $win.mid]
  set bot_frm [frame $win.bot]
  pack $top_frm -side top -fill x -padx 3 -pady 3
  pack $mid_frm -padx 10 -pady 10
  pack $bot_frm -side bottom -fill x -padx 3 -pady 3
  button $top_frm.fmt -text "" -cursor "" \
  -font $tixOption(bold_font) \
  -bg $paOption(title_bg) -relief flat \
  -state disabled -disabledforeground $paOption(title_fg)
  grid $top_frm.fmt -row 1 -column 1 -pady 20
  $top_frm.fmt configure -activebackground $paOption(title_bg)
  set out_frm [Page::CreateLblFrame $mid_frm out \
  "$gPB(tool,tool_trans,frame,Label)"]
  tixForm $out_frm -top 10 -left %10 -right %90 -pady 5 -padx 25
  set outsubfrm [$out_frm    subwidget frame]
  switch $mom_kin_var(\$mom_kin_machine_type) \
  {
   "lathe" \
   {
    set option_list [list "Tool Number Only" \
    "Tool Number And Length Offset Number" \
    "Turret Index And Tool Number" \
    "Turret Index Tool Number And Length Offset Number"]
   }
   default \
   {
    set option_list [list "Tool Number Only" \
    "Tool Number And Length Offset Number" \
    "Length Offset Number And Tool Number"]
   }
  }
  for { set count 0 } { $count < [llength $option_list] } { incr count } \
  {
   set opt_label [lindex $option_list $count]
   set frm1 [frame $outsubfrm.frm_$count]
   pack $frm1 -anchor nw -pady 10 -padx 10
   UI_PB_mthd_CreateRadioButton \$tool_num_output $frm1 rad \
   "$opt_label"
   $frm1.rad config -command "UI_PB_tpth_ChangeToolCodeOutput $top_frm"
  }
  set cb_arr(gPB(nav_button,default,Label)) \
  "UI_PB_tpth_ToolConfDefault $page_obj $top_frm"
  set cb_arr(gPB(nav_button,restore,Label)) \
  "UI_PB_tpth_ToolConfRestore $page_obj $top_frm"
  set cb_arr(gPB(nav_button,cancel,Label)) \
  "UI_PB_tpth_ToolConfigCancel_CB $win $page_obj"
  set cb_arr(gPB(nav_button,ok,Label)) \
  "UI_PB_tpth_ToolConfigOk_CB $win $page_obj \
  $event_obj"
  UI_PB_com_CreateActionElems $bot_frm cb_arr
  UI_PB_tpth_ChangeToolCodeOutput $top_frm
  UI_PB_com_PositionWindow $win
 }

#=======================================================================
proc UI_PB_tpth_UpdateVarAddress { ADD_OBJ SEARCH_VAR ELEM_EXPR ELEM_DESC } {
  upvar $ADD_OBJ add_obj
  upvar $SEARCH_VAR search_var
  upvar $ELEM_EXPR elem_expr
  upvar $ELEM_DESC elem_desc
  global mom_sys_arr
  set blk_elem_list [lsort -integer $address::($add_obj,blk_elem_list)]
  set prev_elem ""
  foreach elem_obj $blk_elem_list \
  {
   set elem_mom_var $block_element::($elem_obj,elem_mom_variable)
   if { [string match "*$search_var*" $elem_mom_var] && \
   $elem_obj != $prev_elem } \
   {
    set block_element::($elem_obj,elem_mom_variable) $elem_expr
    set block_element::($elem_obj,elem_desc) $elem_desc
    array set def_elem_attr $block_element::($elem_obj,def_value)
    set def_elem_attr(1) $elem_expr
    set def_elem_attr(3) $elem_desc
    block_element::DefaultValue $elem_obj def_elem_attr
    unset def_elem_attr
    if { [info exists block_element::($elem_obj,rest_value)] } \
    {
     array set rest_elem_attr $block_element::($elem_obj,rest_value)
     set rest_elem_attr(1) $elem_expr
     set rest_elem_attr(3) $elem_desc
     set block_element::($elem_obj,rest_value) \
     [array get rest_elem_attr]
     unset rest_elem_attr
    }
    set prev_elem $elem_obj
   }
  }
  set add_name $address::($add_obj,add_name)
  PB_int_RetMOMVarAsscAddress add_name add_mom_var
  PB_int_RetMOMVarDescAddress add_name add_mom_var_desc
  set index 0
  foreach mom_var $add_mom_var \
  {
   if { [string match "*$search_var*" $mom_var] } \
   {
    set add_mom_var [lreplace $add_mom_var $index $index $elem_expr]
    set add_mom_var_desc [lreplace $add_mom_var_desc \
    $index $index $elem_desc]
    set mom_value $mom_sys_arr($mom_var)
    unset mom_sys_arr($mom_var)
    set mom_sys_arr($elem_expr) $mom_value
    break
   }
   incr index
  }
  PB_int_UpdateMOMVarOfAddress add_name add_mom_var
  PB_int_UpdateMOMVarDescAddress add_name add_mom_var_desc
  PB_int_UpdateMOMVar mom_sys_arr
 }

#=======================================================================
proc UI_PB_tpth_ToolConfigOk_CB { win page_obj event_obj } {
  global mom_sys_arr
  set mom_var_list $Page::($page_obj,page_momvars)
  unset Page::($page_obj,rest_page_momvalues)
  unset Page::($page_obj,page_momvars)
  set tool_add "T"
  PB_int_RetAddrObjFromName tool_add toolnum_add
  address::readvalue $toolnum_add toolnum_addr_attr
  format::readvalue $toolnum_addr_attr(1) toolnum_fmt_attr
  set len_adj_add "H"
  PB_int_RetAddrObjFromName len_adj_add tooloff_add
  address::readvalue $tooloff_add tooloff_addr_attr
  format::readvalue $tooloff_addr_attr(1) tooloff_fmt_attr
  switch $mom_sys_arr(\$tool_num_output) \
  {
   TOOL_NUMBER_ONLY  \
   {
    set toolnum_fmt_attr(5) 2
    set tooloff_fmt_attr(5) 2
    set toolnum_addr_attr(4) 99
    set tl_elem_expr "\$mom_tool_number"
    set tp_elem_expr "\$mom_next_tool_number"
    set tl_elem_desc "Tool Number Only"
    set tp_elem_desc "Next Tool Number Only"
   }
   TURRET_INDEX_AND_TOOL_NUMBER \
   {
    set toolnum_fmt_attr(5) 2
    set tooloff_fmt_attr(5) 2
    set toolnum_addr_attr(4) 99
    set tl_elem_expr "10 * \$mom_sys_turret_index(\$turret_current) \
    + \$mom_tool_number"
    set tp_elem_expr "10 * \$mom_sys_turret_index(\$turret_current) \
    + \$mom_next_tool_number"
    set tl_elem_desc "Turret Index And Tool Number"
    set tp_elem_desc "Turret Index And Next Tool Number"
   }
   TOOL_NUMBER_AND_LENGTH_OFFSET_NUMBER \
   {
    set toolnum_fmt_attr(5) 4
    set tooloff_fmt_attr(5) 2
    set toolnum_addr_attr(4) 9999
    set tl_elem_expr "100 * \$mom_tool_number + \
    \$mom_tool_adjust_register"
    set tp_elem_expr "100 * \$mom_next_tool_number + \
    \$mom_tool_adjust_register"
    set tl_elem_desc "Tool Number And Length Offset Number"
    set tp_elem_desc "Next Tool Number And Length Offset Number"
   }
   LENGTH_OFFSET_NUMBER_AND_TOOL_NUMBER \
   {
    set toolnum_fmt_attr(5) 4
    set tooloff_fmt_attr(5) 2
    set toolnum_addr_attr(4) 9999
    set tl_elem_expr "100 * \$mom_tool_adjust_register + \
    \$mom_tool_number"
    set tp_elem_expr "100 * \$mom_tool_adjust_register + \
    \$mom_next_tool_number"
    set tl_elem_desc "Length Offset Number And Tool Number"
    set tp_elem_desc "Length Offset Number And Next Tool Number"
   }
   TURRET_INDEX_TOOL_NUMBER_AND_LENGTH_OFFSET_NUMBER \
   {
    set toolnum_fmt_attr(5) 4
    set tooloff_fmt_attr(5) 2
    set toolnum_addr_attr(4) 9999
    set tl_elem_expr "1000 * \$mom_sys_turret_index(\$turret_current) \
    + 100 * \$mom_tool_number + \$mom_tool_adjust_register"
    set tp_elem_expr "1000 * \$mom_sys_turret_index(\$turret_current) \
    + 100 * \$mom_next_tool_number + \$mom_tool_adjust_register"
    set tl_elem_desc "Turret Index, Tool Number And Length Offset Number"
    set tp_elem_desc "Turret Index, Next Tool Number And Length Offset Number"
   }
  }
  format::setvalue $toolnum_addr_attr(1) toolnum_fmt_attr
  format::setvalue $tooloff_addr_attr(1) tooloff_fmt_attr
  address::setvalue $toolnum_add toolnum_addr_attr
  destroy $win
  set search_var "mom_tool_number"
  UI_PB_tpth_UpdateVarAddress toolnum_add search_var tl_elem_expr tl_elem_desc
  set search_var "mom_next_tool_number"
  UI_PB_tpth_UpdateVarAddress toolnum_add search_var tp_elem_expr tp_elem_desc
  UI_PB_tpth_DeleteAndRecreateIcons page_obj event_obj
  update idletasks
 }

#=======================================================================
proc UI_PB_tpth_ToolConfigCancel_CB { win page_obj } {
  UI_PB_tpth_DialogRestore_CB $page_obj
  unset Page::($page_obj,rest_page_momvalues)
  unset Page::($page_obj,page_momvars)
  destroy $win
  update idletasks
 }

#=======================================================================
proc UI_PB_tpth_ChangeToolCodeOutput { top_frm } {
  global mom_sys_arr
  set button_widget $top_frm.fmt
  set tool_number 1
  set length_offset 2
  set tool_add "T"
  PB_int_RetAddrObjFromName tool_add toolnum_add
  address::readvalue $toolnum_add toolnum_addr_attr
  format::readvalue $toolnum_addr_attr(1) toolnum_fmt_attr
  set len_adj_add "H"
  PB_int_RetAddrObjFromName len_adj_add tooloff_add
  address::readvalue $tooloff_add tooloff_addr_attr
  format::readvalue $tooloff_addr_attr(1) tooloff_fmt_attr
  switch $mom_sys_arr(\$tool_num_output) \
  {
   TOOL_NUMBER_ONLY  \
   {
    set inp_value 1
   }
   TURRET_INDEX_AND_TOOL_NUMBER \
   {
    set toolnum_fmt_attr(5) 2
    set inp_value [expr [expr 10 * 1] + 1]
   }
   TOOL_NUMBER_AND_LENGTH_OFFSET_NUMBER \
   {
    set toolnum_fmt_attr(5) 4
    set inp_value [expr [expr 100 * 1] + 2]
   }
   LENGTH_OFFSET_NUMBER_AND_TOOL_NUMBER \
   {
    set toolnum_fmt_attr(5) 4
    set inp_value [expr [expr 100 * 2] + 1]
   }
   TURRET_INDEX_TOOL_NUMBER_AND_LENGTH_OFFSET_NUMBER \
   {
    set toolnum_fmt_attr(5) 4
    set inp_value [expr 1000 + 100 + 2]
   }
  }
  PB_fmt_RetFmtOptVal toolnum_fmt_attr inp_value fmt_value
  $top_frm.fmt configure -text $fmt_value
 }

#=======================================================================
proc UI_PB_tpth_ToolConfDefault { page_obj top_frm } {
  UI_PB_tpth_DialogDefault_CB $page_obj
  UI_PB_tpth_ChangeToolCodeOutput $top_frm
 }

#=======================================================================
proc UI_PB_tpth_ToolConfRestore { page_obj top_frm } {
  UI_PB_tpth_DialogRestore_CB $page_obj
  UI_PB_tpth_ChangeToolCodeOutput $top_frm
 }

#=======================================================================
proc UI_PB_tpth_EditRapidBlocks { page_obj event_obj member_obj } {
  global mom_sys_arr
  set variable $group_member::($member_obj,mom_var)
  set event_name $event::($event_obj,event_name)
  set evt_elem_list $event::($event_obj,evt_elem_list)
  UI_PB_tpth_DeleteTpthEventBlkAttr page_obj event_obj
  UI_PB_tpth_SetPageAttributes page_obj
  set rap1_obj $mom_sys_arr(\$pb_rapid_1)
  set rap2_obj $mom_sys_arr(\$pb_rapid_2)
  set rapid_blk_1 ""
  set rapid_blk_2 ""
  if { $rap1_obj != "" } \
  {
   set rapid_blk_1 $block::($rap1_obj,block_name)
  }
  if { $rap2_obj != "" } \
  {
   set rapid_blk_2 $block::($rap2_obj,block_name)
  }
  set index 0
  set spin_blk 0
  set trav_blk 0
  set rap_evt_tra_elem 0
  foreach evt_elem_obj $evt_elem_list \
  {
   set block_obj $event_element::($evt_elem_obj,block_obj)
   set block_name $block::($block_obj,block_name)
   if { [string compare $block_name $rapid_blk_1] == 0 } \
   {
    set trav_blk $block_obj
    set trav_index $index
    set rap_evt_tra_elem $evt_elem_obj
    } elseif { [string compare $block_name "$rapid_blk_2"] == 0} \
   {
    set spin_blk $block_obj
    set spin_index $index
   }
   incr index
  }
  if { $mom_sys_arr($variable) && $trav_blk != 0 } \
  {
   set blk_obj_attr(0) "rapid_spindle"
   set blk_type "normal"
   foreach tra_elem_obj $block::($trav_blk,active_blk_elem_list) \
   {
    set trav_elem_add $block_element::($tra_elem_obj,elem_add_obj)
    set trav_add_name $address::($trav_elem_add,add_name)
    if {[string compare $trav_add_name "rapid3"] == 0 || \
     [string compare $trav_add_name "H"] == 0 || \
    [string compare $trav_add_name "M_coolant"] == 0} \
    {
     PB_int_CreateBlkElemFromElemObj tra_elem_obj new_elem_obj \
     blk_obj_attr
     lappend spin_blk_elem $new_elem_obj
     if { [string compare $trav_add_name "rapid3"] == 0 } \
     {
      set block_element::($new_elem_obj,owner) "post"
     } else \
     {
      set block_element::($new_elem_obj,owner) $event_name
     }
    } else \
    {
     lappend tra_blk_elem $tra_elem_obj
     if {[string compare $trav_add_name "G_motion"] == 0} \
     {
      PB_int_CreateBlkElemFromElemObj tra_elem_obj new_elem_obj \
      blk_obj_attr
      lappend spin_blk_elem $new_elem_obj
      set block_element::($new_elem_obj,owner) $event_name
     }
    }
   }
   set block::($trav_blk,active_blk_elem_list) $tra_blk_elem
   PB_int_CreateNewBlock blk_obj_attr(0) spin_blk_elem event_name \
   new_blk_obj blk_type
   set block::($new_blk_obj,active_blk_elem_list) $spin_blk_elem
   PB_int_CreateNewEventElement new_blk_obj new_evt_elem_obj
   set trav_index [expr [lsearch $event::($event_obj,evt_elem_list) \
   $rap_evt_tra_elem] + 1]
   set temp_evt_elem_list [linsert $event::($event_obj,evt_elem_list) \
   $trav_index $new_evt_elem_obj]
   set event::($event_obj,evt_elem_list) $temp_evt_elem_list
   set mom_sys_arr(\$pb_rapid_2) $new_blk_obj
   } elseif { $spin_blk } \
  {
   set blk_obj_attr(0) "$rapid_blk_1"
   foreach spin_blk_elem_obj $block::($spin_blk,active_blk_elem_list) \
   {
    set spin_elem_add $block_element::($spin_blk_elem_obj,elem_add_obj)
    set blk_exist_flag 0
    foreach tra_elem_obj $block::($trav_blk,active_blk_elem_list) \
    {
     set trav_elem_add $block_element::($tra_elem_obj,elem_add_obj)
     if {$trav_elem_add == $spin_elem_add} \
     {
      set blk_exist_flag 1
      break
     }
    }
    if { !$blk_exist_flag } \
    {
     PB_int_CreateBlkElemFromElemObj spin_blk_elem_obj new_elem_obj \
     blk_obj_attr
     lappend block::($trav_blk,active_blk_elem_list) $new_elem_obj
     set add_obj $block_element::($new_elem_obj,elem_add_obj)
     if { [string compare $address::($add_obj,add_name) "rapid3"] == 0} \
     {
      set block_element::($new_elem_obj,owner) "post"
     } else \
     {
      set block_element::($new_elem_obj,owner) $event_name
     }
     set blk_exist_flag 0
    }
   }
   set mom_sys_arr(\$pb_rapid_2) ""
   PB_int_RemoveBlkObjFrmList spin_blk
   set evt_elem_list [lreplace $evt_elem_list $spin_index $spin_index]
   set event::($event_obj,evt_elem_list) $evt_elem_list
  }
  foreach evt_elem_obj $event::($event_obj,evt_elem_list) \
  {
   set elem_blk_obj $event_element::($evt_elem_obj,block_obj)
   set active_blk_elem_list $block::($elem_blk_obj,active_blk_elem_list)
   if { $block::($elem_blk_obj,blk_type) != "command" && \
   $block::($elem_blk_obj,blk_type) != "comment" } \
   {
    UI_PB_com_SortBlockElements active_blk_elem_list
   }
   set block::($elem_blk_obj,active_blk_elem_list) $active_blk_elem_list
   unset active_blk_elem_list
   UI_PB_blk_CreateBlockImages page_obj elem_blk_obj
   set block::($elem_blk_obj,x_orig) $Page::($page_obj,x_orig)
   set block::($elem_blk_obj,y_orig) $Page::($page_obj,y_orig)
   UI_PB_tpth_CreateDividers page_obj elem_blk_obj
   set block_owner $block::($elem_blk_obj,blk_owner)
   set new_blk_elem_obj 0
   UI_PB_blk_CreateBlockCells page_obj elem_blk_obj new_blk_elem_obj \
   block_owner
   set Page::($page_obj,y_orig) [expr \
   $Page::($page_obj,y_orig) + $Page::($page_obj,blk_blkdist)]
  }
 }

#=======================================================================
proc UI_PB_tpth_SetPageAttributes { PAGE_OBJ } {
  upvar $PAGE_OBJ page_obj
  set Page::($page_obj,h_cell) 30       
  set Page::($page_obj,w_cell) 62       
  set Page::($page_obj,w_divi) 4        
  set Page::($page_obj,x_orig) 80       
  set Page::($page_obj,y_orig) 30
  set Page::($page_obj,rect_region) 15  
  set Page::($page_obj,add_blk) 0
  set Page::($page_obj,add_flag) 0
  set Page::($page_obj,icon_top) 0
  set Page::($page_obj,icon_bot) 0
  set Page::($page_obj,blk_blkdist) 60
  set Page::($page_obj,in_focus_elem) 0
  set Page::($page_obj,out_focus_elem) 0
  set Page::($page_obj,active_blk_elem) 0
  set Page::($page_obj,trash_flag) 0
  set Page::($page_obj,source_blk_elem_obj) 0
  set Page::($page_obj,source_evt_elem_obj) 0
  set Page::($page_obj,being_dragged) 0
  set Page::($page_obj,last_xb) 0
  set Page::($page_obj,last_yb) 0
  set Page::($page_obj,last_xt) 0
  set Page::($page_obj,last_yt) 0
 }

#=======================================================================
proc UI_PB_tpth_CreateHorzPane { PAGE_OBJ EVENT_OBJ } {
  upvar $PAGE_OBJ page_obj
  upvar $EVENT_OBJ event_obj
  global paOption
  set page_id $Page::($page_obj,page_id)
  set canvas_flag $event::($event_obj,canvas_flag)
  if { $canvas_flag } \
  {
   set pane [tixPanedWindow $page_id.pane -orient vertical]
   pack $pane -expand yes -fill both
   set f1 [$pane add p1 -expand 1]
   set f2 [$pane add p2 -expand 1]
   $f1 config -relief flat
   $f2 config -relief flat
   set p1s [$pane subwidget p1]
   set p1p [frame $p1s.pp]
   pack $p1p -expand yes -fill both -pady 6
   tixScrolledWindow $p1p.scr
   [$p1p.scr subwidget hsb] config -troughcolor $paOption(trough_bg) \
   -width $paOption(trough_wd)
   [$p1p.scr subwidget vsb] config -troughcolor $paOption(trough_bg) \
   -width $paOption(trough_wd)
   pack $p1p.scr -padx 5 -expand yes -fill both
   set p1t [$p1p.scr subwidget window]
   set top_frm [frame $p1t.f]
   pack $top_frm -expand yes -fill both
   set p2s [$pane subwidget p2]
   set param_frm [frame $p2s.pp]
   set box_frm [frame $param_frm.bb]
   pack $param_frm -expand yes -fill both
   pack $box_frm -side bottom -expand no -fill both
  } else \
  {
   set top_frm [frame $page_id.f]
   set param_frm [frame $page_id.pp]
   set box_frm [frame $param_frm.bb]
   pack $param_frm -expand yes -fill both
   pack $box_frm -side bottom -fill x
  }
  tixScrolledWindow $param_frm.scr
  [$param_frm.scr subwidget hsb] config -troughcolor $paOption(trough_bg) \
  -width $paOption(trough_wd)
  [$param_frm.scr subwidget vsb] config -troughcolor $paOption(trough_bg) \
  -width $paOption(trough_wd)
  pack $param_frm.scr -padx 5 -pady 5 -expand yes -fill both
  set p2t [$param_frm.scr subwidget window]
  set sec_frm [frame $p2t.f]
  pack $sec_frm -fill both -expand yes
  set Page::($page_obj,canvas_frame) $top_frm
  set Page::($page_obj,param_frame) $sec_frm
  set Page::($page_obj,box_frame) $box_frm
 }

#=======================================================================
proc UI_PB_tpth_ItemDrag1 {page_obj event_obj x y} {
  set bot_canvas $Page::($page_obj,bot_canvas)
  set top_canvas $Page::($page_obj,top_canvas)
  set panel_hi $Page::($page_obj,panel_hi)
  set xx [$top_canvas canvasx $x]
  set yy [$top_canvas canvasy $y]
  $top_canvas coords $Page::($page_obj,icon_top) $xx $yy
  set dx 1
  set dy [expr $panel_hi + 2]
  set xx [$bot_canvas canvasx [expr $x + $dx]]
  set yy [$bot_canvas canvasy [expr $y - $dy]]
  UI_PB_ScrollCanvasWin $page_obj $xx $yy
  set xx [$bot_canvas canvasx [expr $x + $dx]]
  set yy [$bot_canvas canvasy [expr $y - $dy]]
  $bot_canvas coords $Page::($page_obj,icon_bot) $xx $yy
  set sel_addr $Page::($page_obj,sel_base_addr)
  UI_PB_tpth_HighlightSeperators $page_obj $event_obj \
  $sel_addr $xx $yy
 }

#=======================================================================
proc UI_PB_tpth_UnHighLightSep { PAGE_OBJ } {
  upvar $PAGE_OBJ page_obj
  global paOption
  set main_cell_color $paOption(can_bg)
  set divi_color turquoise
  set bot_canvas $Page::($page_obj,bot_canvas)
  switch $Page::($page_obj,add_flag) \
  {
   1 {
    $bot_canvas itemconfigure [lindex $Page::($page_obj,focus_rect) 0] \
    -outline $main_cell_color -fill $main_cell_color
    $bot_canvas itemconfigure [lindex $Page::($page_obj,focus_rect) 1] \
    -outline $main_cell_color -fill $main_cell_color
    $bot_canvas itemconfigure [lindex $Page::($page_obj,focus_rect) 2] \
    -outline $main_cell_color -fill $main_cell_color
    unset Page::($page_obj,focus_rect)
   }
   2 {
    set act_blk_elem $Page::($page_obj,insert_elem)
    $bot_canvas itemconfigure $block_element::($act_blk_elem,div_id) \
    -outline $divi_color -fill $divi_color
   }
   3 {
    set active_evt_elem $Page::($page_obj,active_evt_elem_obj)
    set act_blk_obj $event_element::($active_evt_elem,block_obj)
    $bot_canvas itemconfigure $block::($act_blk_obj,div_id) \
    -outline $divi_color -fill $divi_color
   }
  }
  if {[info exists Page::($page_obj,focus_sep)]} \
  {
   $bot_canvas itemconfigure $Page::($page_obj,focus_sep) \
   -outline $main_cell_color -fill $main_cell_color
   unset Page::($page_obj,focus_sep)
  }
 }

#=======================================================================
proc UI_PB_tpth_AddTextElemeToBlk { PAGE_OBJ EVENT_OBJ EVT_ELEM_OBJ \
  NEW_ELEM_OBJ text_label } {
  upvar $PAGE_OBJ page_obj
  upvar $EVENT_OBJ event_obj
  upvar $EVT_ELEM_OBJ evt_elem_obj
  upvar $NEW_ELEM_OBJ new_elem_obj
  set bot_canvas $Page::($page_obj,bot_canvas)
  set sel_base_addr $Page::($page_obj,sel_base_addr)
  UI_PB_com_CreateTextEntry page_obj new_elem_obj $text_label
  tkwait window $bot_canvas.txtent
  if {[string compare $block_element::($new_elem_obj,elem_mom_variable) \
  "000"] != 0} \
  {
   UI_PB_blk_ReplaceIcon page_obj $sel_base_addr $new_elem_obj
  } else \
  {
   set block_obj $event_element::($evt_elem_obj,block_obj)
   set no_blk_elems [llength $block::($block_obj,active_blk_elem_list)]
   set source_cell_num [lsearch $block::($block_obj,active_blk_elem_list) \
   $new_elem_obj]
   set no_event_elems [llength $event::($event_obj,evt_elem_list)]
   set elem_index [lsearch $event::($event_obj,evt_elem_list) evt_elem_obj]
   if { $no_blk_elems > 1 } \
   {
    UI_PB_tpth_DeleteElemOfRow page_obj event_obj evt_elem_obj \
    source_cell_num
    } elseif  { $no_blk_elems == 1 || \
   $elem_index == [expr $no_event_elems - 1]} \
   {
    set block_obj $event_element::($evt_elem_obj,block_obj)
    UI_PB_tpth_DeleteARow page_obj event_obj evt_elem_obj
    delete $block_obj
   }
  }
 }

#=======================================================================
proc UI_PB_tpth_ItemEndDrag1 {page_obj event_obj x y } {
  global paOption
  global gPB
  set top_canvas $Page::($page_obj,top_canvas)
  set bot_canvas $Page::($page_obj,bot_canvas)
  UI_PB_tpth_UnHighLightSep page_obj
  if {$Page::($page_obj,icon_top)} \
  {
   $top_canvas delete $Page::($page_obj,icon_top)
   set Page::($page_obj,icon_top) 0
  }
  if {$Page::($page_obj,icon_bot)} \
  {
   $bot_canvas delete $Page::($page_obj,icon_bot)
   set Page::($page_obj,icon_bot) 0
  }
  $Page::($page_obj,add) configure -relief raised \
  -bg $paOption(app_butt_bg)
  if { $Page::($page_obj,add_blk) != 0} \
  {
   set add_to_evt_elem_obj $Page::($page_obj,active_evt_elem_obj)
   set add_to_blk_obj $event_element::($add_to_evt_elem_obj,block_obj)
   set new_elem_mom_var $Page::($page_obj,new_elem_mom_var)
   set sel_base_addr $Page::($page_obj,sel_base_addr)
   set sel_var_desc $Page::($page_obj,comb_var)
   set blk_flag ""
   if { [string compare $sel_base_addr "New_Address"] == 0 } \
   {
    set sel_base_addr "$gPB(User_Def_Add)"
    PB_int_RetAddressObjList add_obj_list
    set add_index [llength $add_obj_list]
    PB_int_CreateNewAddress sel_base_addr new_add_obj add_index
    PB_int_AddNewBlockElemObj sel_base_addr new_elem_mom_var \
    add_to_blk_obj new_elem_obj
    set block_element::($new_elem_obj,owner) \
    $event::($event_obj,event_name)
    set blk_flag "new_block"
    } elseif { $sel_base_addr == "Comment" } \
   {
    set blk_flag "comment"
    set elem_name "comment_blk"
    PB_int_CreateCommentBlkElem elem_name new_elem_obj
    set block_element::($new_elem_obj,owner) \
    $event::($event_obj,event_name)
    } elseif { $sel_base_addr == "Command" } \
   {
    if { $new_elem_mom_var == "Custom Command" } \
    {
     set blk_flag "command"
     set new_elem_mom_var "PB_CMD_custom_command"
     PB_int_CreateNewCmdBlkElem new_elem_mom_var new_elem_obj
    } else \
    {
     set blk_flag ""
     PB_int_CreateCmdBlkElem new_elem_mom_var new_elem_obj
    }
    set block_element::($new_elem_obj,owner) \
    $event::($event_obj,event_name)
   } else \
   {
    PB_int_AddNewBlockElemObj sel_base_addr new_elem_mom_var \
    add_to_blk_obj new_elem_obj
    set block_element::($new_elem_obj,owner) \
    $event::($event_obj,event_name)
    set blk_flag ""
   }
   switch $Page::($page_obj,add_blk) \
   {
    "row" \
    {
     UI_PB_tpth_AddBlkElemRow page_obj add_to_evt_elem_obj \
     new_elem_obj new_blk_elem_flag
     if { $new_blk_elem_flag } \
     {
      delete $new_elem_obj
      set Page::($page_obj,add_blk) 0
      set Page::($page_obj,add_flag) 0
      return
     }
    }
    "top" \
    {
     UI_PB_tpth_AddBlkElemTopOrBottom page_obj event_obj \
     add_to_evt_elem_obj new_elem_obj
    }
    "bottom" \
    {
     UI_PB_tpth_AddBlkElemTopOrBottom page_obj event_obj \
     add_to_evt_elem_obj new_elem_obj
    }
   }
   if { [string compare $Page::($page_obj,sel_base_addr) "Text"] == 0} \
   {
    UI_PB_tpth_AddTextElemeToBlk page_obj event_obj add_to_evt_elem_obj \
    new_elem_obj Text
    } elseif { $blk_flag == "new_block" } \
   {
    UI_PB_blk_NewAddress page_obj event_obj add_to_evt_elem_obj \
    new_elem_obj event
    } elseif { $blk_flag == "comment"} \
   {
    set new_blk_obj $event_element::($add_to_evt_elem_obj,block_obj)
    UI_PB_tpth_BringCommentPage page_obj event_obj add_to_evt_elem_obj \
    new_blk_obj New
    } elseif { $blk_flag == "command"} \
   {
    set new_blk_obj $event_element::($add_to_evt_elem_obj,block_obj)
    UI_PB_tpth_BringCmdPage page_obj event_obj add_to_evt_elem_obj \
    new_blk_obj New
    } elseif { [string compare $sel_base_addr $sel_var_desc] == 0} \
   {
    set block_element::($new_elem_obj,elem_desc) \
    "$gPB(block,user,word_desc,Label)"
    UI_PB_tpth_AddTextElemeToBlk page_obj event_obj add_to_evt_elem_obj \
    new_elem_obj "$gPB(address,exp,Label)"
   }
  }
  set Page::($page_obj,add_blk) 0
  set Page::($page_obj,add_flag) 0
  $top_canvas config -cursor ""
 }

#=======================================================================
proc UI_PB_tpth_AddBlkElemRow { PAGE_OBJ ADD_TO_EVT_ELEM_OBJ NEW_BLK_ELEM_OBJ \
  NEW_BLK_ELEM_FLAG } {
  upvar $PAGE_OBJ page_obj
  upvar $ADD_TO_EVT_ELEM_OBJ add_to_evt_elem_obj
  upvar $NEW_BLK_ELEM_OBJ new_blk_elem_obj
  upvar $NEW_BLK_ELEM_FLAG new_blk_elem_flag
  global paOption
  __tpth_DeselectBlkElem $page_obj
  if 0 {
   set bot_canvas $Page::($page_obj,bot_canvas)
   if {$Page::($page_obj,active_blk_elem)} \
   {
    set act_blk_elem_obj $Page::($page_obj,active_blk_elem)
    set icon_id $block_element::($act_blk_elem_obj,icon_id)
    set im [$bot_canvas itemconfigure $icon_id -image]
    set icon_tag [lindex [$bot_canvas itemconfigure $icon_id -tags] end]
    if { $icon_tag == "nonmovable" } \
    {
     [lindex $im end] configure -relief flat -bg $paOption(raised_bg)
    } else \
    {
     [lindex $im end] configure -relief raised -bg $paOption(raised_bg)
    }
   }
  }
  set add_to_blk_obj $event_element::($add_to_evt_elem_obj,block_obj)
  if { $block_element::($new_blk_elem_obj,elem_add_obj) != "Command" && \
  $block_element::($new_blk_elem_obj,elem_add_obj) != "Comment" } \
  {
   set new_blk_elem_flag [UI_PB_com_CheckElemBlkTemplate add_to_blk_obj \
   new_blk_elem_obj]
  } else \
  {
   set new_blk_elem_flag 0
  }
  if {$new_blk_elem_flag} \
  {
   return
  }
  UI_PB_blk_DeleteCellsIcons page_obj add_to_blk_obj
  if { $block::($add_to_blk_obj,active_blk_elem_list) == "" && \
  $block_element::($new_blk_elem_obj,elem_add_obj) == "Command" } \
  {
   PB_int_RemoveBlkObjFrmList add_to_blk_obj
   set block::($add_to_blk_obj,blk_type) "command"
   } elseif { $block::($add_to_blk_obj,active_blk_elem_list) == "" && \
  $block_element::($new_blk_elem_obj,elem_add_obj) == "Comment" } \
  {
   PB_int_RemoveBlkObjFrmList add_to_blk_obj
   PB_int_RetCommentBlkName comment_blk_name
   set block::($add_to_blk_obj,blk_type) "comment"
   set block::($add_to_blk_obj,block_name) $comment_blk_name
  }
  if { $Page::($page_obj,add_flag) == 1 || \
  $Page::($page_obj,add_flag) == 3 } \
  {
   lappend block::($add_to_blk_obj,active_blk_elem_list) $new_blk_elem_obj
   switch $block_element::($new_blk_elem_obj,elem_add_obj) \
   {
    "Comment" {
     PB_int_AddCommentBlkToPost add_to_blk_obj
    }
    "Command" {
    }
   }
  } else \
  {
   set active_blk_elem_list $block::($add_to_blk_obj,active_blk_elem_list)
   set insert_elem $Page::($page_obj,insert_elem)
   set insert_indx [lsearch $active_blk_elem_list $insert_elem]
   set active_blk_elem_list [linsert $active_blk_elem_list $insert_indx \
   $new_blk_elem_obj]
   set block::($add_to_blk_obj,active_blk_elem_list) $active_blk_elem_list
   unset active_blk_elem_list
  }
  if { $block::($add_to_blk_obj,blk_type) == "normal" } \
  {
   set active_blk_elem_list $block::($add_to_blk_obj,active_blk_elem_list)
   UI_PB_com_SortBlockElements active_blk_elem_list
   set block::($add_to_blk_obj,active_blk_elem_list) $active_blk_elem_list
   unset active_blk_elem_list
  }
  UI_PB_blk_CreateBlockImages page_obj add_to_blk_obj
  UI_PB_tpth_CreateDividers page_obj add_to_blk_obj
  set Page::($page_obj,x_orig) $block::($add_to_blk_obj,x_orig)
  set Page::($page_obj,y_orig) $block::($add_to_blk_obj,y_orig)
  set block_owner $block::($add_to_blk_obj,blk_owner)
  UI_PB_blk_CreateBlockCells page_obj add_to_blk_obj new_blk_elem_obj \
  block_owner
 }

#=======================================================================
proc UI_PB_tpth_AddBlkElemTopOrBottom { PAGE_OBJ EVENT_OBJ ADD_TO_EVT_ELEM_OBJ \
  NEW_BLK_ELEM_OBJ} {
  upvar $PAGE_OBJ page_obj
  upvar $EVENT_OBJ event_obj
  upvar $ADD_TO_EVT_ELEM_OBJ add_to_evt_elem_obj
  upvar $NEW_BLK_ELEM_OBJ new_blk_elem_obj
  global paOption
  set bot_canvas $Page::($page_obj,bot_canvas)
  set event_name $event::($event_obj,event_name)
  set no_elems [llength $event::($event_obj,evt_elem_list)]
  set elem_index [lsearch $event::($event_obj,evt_elem_list) \
  $add_to_evt_elem_obj]
  if {$Page::($page_obj,active_blk_elem)} \
  {
   set act_blk_elem_obj $Page::($page_obj,active_blk_elem)
   set icon_id $block_element::($act_blk_elem_obj,icon_id)
   set im [$bot_canvas itemconfigure $icon_id -image]
   set icon_tag [lindex [$bot_canvas itemconfigure $icon_id -tags] end]
   if { $icon_tag == "nonmovable" } \
   {
    [lindex $im end] configure -relief flat -bg $paOption(raised_bg)
   } else \
   {
    [lindex $im end] configure -relief raised -bg $paOption(raised_bg)
   }
   set Page::($page_obj,active_blk_elem) 0
  }
  set elem_obj [lindex $event::($event_obj,evt_elem_list) $elem_index]
  set add_to_blk_obj $event_element::($elem_obj,block_obj)
  if {![string compare $Page::($page_obj,add_blk) "bottom"]} \
  {
   incr elem_index
  }
  for {set count $elem_index} {$count < $no_elems} {incr count} \
  {
   set del_elem [lindex $event::($event_obj,evt_elem_list) $count]
   set del_blk $event_element::($del_elem,block_obj)
   UI_PB_blk_DeleteCellsIcons page_obj del_blk
   if { $block::($del_blk,sep_id) != "" } \
   {
    set bot_canvas $Page::($page_obj,bot_canvas)
    $bot_canvas delete [lindex $block::($del_blk,sep_id) 0]
    $bot_canvas delete [lindex $block::($del_blk,sep_id) 1]
    set block::($del_blk,sep_id) ""
   }
  }
  if { $block_element::($new_blk_elem_obj,elem_add_obj) == "Command" } \
  {
   set cmd_obj $block_element::($new_blk_elem_obj,elem_mom_variable)
   if { [string match "*MOM_*" $cmd_obj] } \
   {
    set new_block_name $cmd_obj
   } else \
   {
    set new_block_name $command::($cmd_obj,name)
   }
   PB_int_CreateCmdBlock new_block_name new_blk_elem_obj new_block_obj
   set block::($new_block_obj,blk_owner) $event_name
   } elseif {$block_element::($new_blk_elem_obj,elem_add_obj) == "Comment" } \
  {
   set new_block_name "comment_blk"
   PB_int_CreateCommentBlk new_block_name new_blk_elem_obj new_block_obj
   set block::($new_block_obj,blk_owner) $event_name
  } else \
  {
   set blk_type "normal"
   UI_PB_com_ReturnBlockName event_obj new_block_name
   PB_int_CreateNewBlock new_block_name new_blk_elem_obj \
   event_name new_block_obj blk_type
  }
  PB_int_CreateNewEventElement new_block_obj new_evt_elem
  lappend block::($new_block_obj,active_blk_elem_list) $new_blk_elem_obj
  set temp_evt_elem_list $event::($event_obj,evt_elem_list)
  unset event::($event_obj,evt_elem_list)
  for {set count 0} {$count < $elem_index} {incr count} \
  {
   lappend event::($event_obj,evt_elem_list) \
   [lindex $temp_evt_elem_list $count]
  }
  lappend event::($event_obj,evt_elem_list) $new_evt_elem
  for {set count $elem_index} {$count < $no_elems} \
  {incr count} \
  {
   lappend event::($event_obj,evt_elem_list) \
   [lindex $temp_evt_elem_list $count]
  }
  if {$elem_index >= $no_elems} \
  {
   set elem_obj [lindex $event::($event_obj,evt_elem_list) \
   [expr $elem_index - 1]]
   set block_obj $event_element::($elem_obj,block_obj)
   set Page::($page_obj,x_orig) $block::($block_obj,x_orig)
   set Page::($page_obj,y_orig) [expr $block::($block_obj,y_orig) \
   + $Page::($page_obj,blk_blkdist)]
  } else \
  {
   set elem_obj [lindex $event::($event_obj,evt_elem_list) \
   [expr $elem_index + 1]]
   set block_obj $event_element::($elem_obj,block_obj)
   set Page::($page_obj,x_orig) $block::($block_obj,x_orig)
   set Page::($page_obj,y_orig) $block::($block_obj,y_orig)
  }
  UI_PB_debug_ForceMsg "y_orig ===> $Page::($page_obj,y_orig)"
  incr no_elems
  for {set count $elem_index} {$count < $no_elems} \
  {incr count} \
  {
   set elem_obj [lindex $event::($event_obj,evt_elem_list) $count]
   set block_obj $event_element::($elem_obj,block_obj)
   UI_PB_blk_CreateBlockImages page_obj block_obj
   set block::($block_obj,x_orig) $Page::($page_obj,x_orig)
   set block::($block_obj,y_orig) $Page::($page_obj,y_orig)
   UI_PB_tpth_CreateDividers page_obj block_obj
   if {$count == $elem_index} \
   {
    set active_blk_elem $new_blk_elem_obj
   } else \
   {
    set active_blk_elem 0
   }
   UI_PB_blk_CreateBlockCells page_obj block_obj active_blk_elem \
   event_name
   set Page::($page_obj,y_orig) \
   [expr $Page::($page_obj,y_orig) + $Page::($page_obj,blk_blkdist)]
  }
  set Page::($page_obj,active_blk_obj) $new_block_obj
  set add_to_evt_elem_obj $new_evt_elem
 }

#=======================================================================
proc UI_PB_tpth_HighLightTopSeperator { PAGE_OBJ EVT_ELEM_OBJ } {
  upvar $PAGE_OBJ page_obj
  upvar $EVT_ELEM_OBJ evt_elem_obj
  global paOption
  set block_obj $event_element::($evt_elem_obj,block_obj)
  set bot_canvas $Page::($page_obj,bot_canvas)
  set high_color $paOption(focus)
  set sep_id [lindex $block::($block_obj,sep_id) 0]
  $bot_canvas itemconfigure $sep_id \
  -outline $high_color -fill $high_color
  set Page::($page_obj,focus_sep) $sep_id
  set Page::($page_obj,active_evt_elem_obj) $evt_elem_obj
  set Page::($page_obj,add_blk) "top"
 }

#=======================================================================
proc UI_PB_tpth_HighLightCellDividers { PAGE_OBJ EVT_ELEM_OBJ xx yy} {
  upvar $PAGE_OBJ page_obj
  upvar $EVT_ELEM_OBJ evt_elem_obj
  global paOption
  set high_color $paOption(focus)
  set bot_canvas $Page::($page_obj,bot_canvas)
  set block_obj $event_element::($evt_elem_obj,block_obj)
  set rect_region $Page::($page_obj,rect_region)
  foreach blk_elem_obj $block::($block_obj,active_blk_elem_list) \
  {
   if { $yy > [expr $block_element::($blk_elem_obj,div_corn_y0) - \
    $rect_region] && \
    $yy < [expr $block_element::($blk_elem_obj,div_corn_y1) + \
    $rect_region] && \
    $xx > [expr $block_element::($blk_elem_obj,div_corn_x0) - 10] && \
   $xx < [expr $block_element::($blk_elem_obj,div_corn_x1) + 10]} \
   {
    $bot_canvas itemconfigure $block_element::($blk_elem_obj,div_id) \
    -fill $high_color -outline $high_color
    set Page::($page_obj,active_evt_elem_obj) $evt_elem_obj
    set Page::($page_obj,insert_elem) $blk_elem_obj
    set Page::($page_obj,add_blk) row
    set Page::($page_obj,add_flag) 2
    break
   } else \
   {
    set Page::($page_obj,add_blk) 0
    set Page::($page_obj,add_flag) 0
   }
  }
  if {$Page::($page_obj,add_blk) == 0} \
  {
   if { $yy > [expr $block::($block_obj,div_corn_y0) - \
    $rect_region] && \
    $yy < [expr $block::($block_obj,div_corn_y1) + \
    $rect_region] && \
    $xx > [expr $block::($block_obj,div_corn_x0) - 10] && \
   $xx < [expr $block::($block_obj,div_corn_x1) + 10]} \
   {
    $bot_canvas itemconfigure $block::($block_obj,div_id) \
    -fill $high_color -outline $high_color
    set Page::($page_obj,active_evt_elem_obj) $evt_elem_obj
    set Page::($page_obj,add_blk) row
    set Page::($page_obj,add_flag) 3
   } else \
   {
    set Page::($page_obj,add_blk) 0
    set Page::($page_obj,add_flag) 0
   }
  }
 }

#=======================================================================
proc UI_PB_tpth_HighLightRow { PAGE_OBJ EVT_ELEM_OBJ} {
  upvar $PAGE_OBJ page_obj
  upvar $EVT_ELEM_OBJ evt_elem_obj
  global paOption
  set block_obj $event_element::($evt_elem_obj,block_obj)
  set bot_canvas $Page::($page_obj,bot_canvas)
  set high_color $paOption(focus)
  set sep_id1 [lindex $block::($block_obj,sep_id) 0]
  $bot_canvas itemconfigure $sep_id1 \
  -outline $high_color -fill $high_color
  set sep_id2 [lindex $block::($block_obj,sep_id) 1]
  $bot_canvas itemconfigure $sep_id2 \
  -outline $high_color -fill $high_color
  $bot_canvas itemconfigure $block::($block_obj,rect) \
  -outline $high_color -fill $high_color
  lappend Page::($page_obj,focus_rect) $block::($block_obj,rect) \
  $sep_id1 $sep_id2
  set Page::($page_obj,active_evt_elem_obj) $evt_elem_obj
  set Page::($page_obj,add_blk) "row"
  set Page::($page_obj,add_flag) 1
 }

#=======================================================================
proc UI_PB_tpth_HighLightBottomSeperator { PAGE_OBJ EVT_ELEM_OBJ} {
  upvar $PAGE_OBJ page_obj
  upvar $EVT_ELEM_OBJ evt_elem_obj
  global paOption
  set block_obj $event_element::($evt_elem_obj,block_obj)
  set bot_canvas $Page::($page_obj,bot_canvas)
  set high_color $paOption(focus)
  set sep_id [lindex $block::($block_obj,sep_id) 1]
  $bot_canvas itemconfigure $sep_id \
  -outline $high_color -fill $high_color
  set Page::($page_obj,focus_sep) $sep_id
  set Page::($page_obj,active_evt_elem_obj) $evt_elem_obj
  set Page::($page_obj,add_blk) "bottom"
 }

#=======================================================================
proc UI_PB_tpth_HighlightSeperators {page_obj event_obj sel_addr x y } {
  global paOption
  global mom_sys_arr
  set h_cell $Page::($page_obj,h_cell)
  set w_divi $Page::($page_obj,w_divi)
  set rect_region $Page::($page_obj,rect_region)
  set high_color $paOption(focus)
  set main_cell_color $paOption(can_bg)
  set bot_canvas $Page::($page_obj,bot_canvas)
  set event_elem_list $event::($event_obj,evt_elem_list)
  set event_name $event::($event_obj,event_name)
  set rap_spin_blk ""
  set rap_trav_blk ""
  if { $mom_sys_arr(\$pb_rapid_2) != "" } \
  {
   set rap_spin_blk_obj $mom_sys_arr(\$pb_rapid_2)
   set rap_spin_blk $block::($rap_spin_blk_obj,block_name)
  }
  if { $mom_sys_arr(\$pb_rapid_1) != "" } \
  {
   set rap_trav_blk_obj $mom_sys_arr(\$pb_rapid_1)
   set rap_trav_blk $block::($rap_trav_blk_obj,block_name)
  }
  UI_PB_tpth_UnHighLightSep page_obj
  set Page::($page_obj,add_flag) 0
  set Page::($page_obj,add_blk) 0
  foreach elem_obj $event_elem_list \
  {
   set block_obj $event_element::($elem_obj,block_obj)
   set block_name $block::($block_obj,block_name)
   set blk_x0 $block::($block_obj,x_orig)
   set blk_y0 $block::($block_obj,y_orig)
   set blk_height $block::($block_obj,blk_h)
   set blk_width $block::($block_obj,blk_w)
   if {[string compare $event_name $block::($block_obj,blk_owner)] != 0} \
   {
    set Page::($page_obj,add_blk) 0
    continue
   }
   if {$Page::($page_obj,source_evt_elem_obj) != 0} \
   {
    set source_evt_elem_obj $Page::($page_obj,source_evt_elem_obj)
    set source_blk_obj $event_element::($source_evt_elem_obj,block_obj)
    if {[llength $block::($source_blk_obj,active_blk_elem_list)] \
    == 1 && $elem_obj == $source_evt_elem_obj} \
    {
     set Page::($page_obj,add_blk) 0
     continue
    }
   }
   if {$y > [expr $blk_y0 - $rect_region] && $y < $blk_y0 && \
    $x > [expr $blk_x0 - [expr 6 * $rect_region]] && \
   $x < [expr $blk_width + [expr 6 * $rect_region]]} \
   {
    if {$block::($block_obj,active_blk_elem_list) == ""} \
    {
     set Page::($page_obj,add_blk) 0
     continue
     } elseif { $event_name == "Rapid Move" && \
    $block_name == "$rap_spin_blk" } \
    {
     set Page::($page_obj,add_blk) 0
     continue
    }
    UI_PB_tpth_HighLightTopSeperator page_obj elem_obj
    break
    } elseif { $y >= $blk_y0 && $y <= $blk_height && \
    $x > [expr $blk_x0 - [expr 6 * $rect_region]] && \
   $x < [expr $blk_width + [expr 6 * $rect_region]]} \
   {
    if { $block::($block_obj,blk_type) == "command" || \
    $block::($block_obj,blk_type) == "comment" } \
    {
     set Page::($page_obj,add_blk) 0
     continue
     } elseif { $sel_addr == "Command" && \
    $block::($block_obj,active_blk_elem_list) !=  "" } \
    {
     set Page::($page_obj,add_blk) 0
     continue
     } elseif { $sel_addr == "Comment" && \
    $block::($block_obj,active_blk_elem_list) !=  "" } \
    {
     set Page::($page_obj,add_blk) 0
     continue
     } elseif {$Page::($page_obj,source_evt_elem_obj) != 0 && \
    [string compare $sel_addr "Text"] != 0 } \
    {
     set source_evt_elem_obj $Page::($page_obj,source_evt_elem_obj)
     set source_blk_obj $event_element::($source_evt_elem_obj,block_obj)
     if {$block_obj == $source_blk_obj} \
     {
      set Page::($page_obj,add_blk) 0
      continue
     }
    }
    if { [string compare $sel_addr "Text"] != 0} \
    {
     UI_PB_tpth_HighLightRow page_obj elem_obj
    } else \
    {
     UI_PB_tpth_HighLightCellDividers page_obj elem_obj $x $y
    }
    break
    } elseif { $y > $blk_height && $y < [expr $blk_height + $rect_region] && \
    $x > [expr $blk_x0 - [expr 6 * $rect_region]] && \
   $x < [expr $blk_width + [expr 6 * $rect_region]]} \
   {
    if {$block::($block_obj,active_blk_elem_list) == ""} \
    {
     set Page::($page_obj,add_blk) 0
     continue
     } elseif { $event_name == "Rapid Move" && \
     $mom_sys_arr(\$rap_wrk_pln_chg) &&
    $block_name == "$rap_trav_blk" } \
    {
     set Page::($page_obj,add_blk) 0
     continue
    }
    UI_PB_tpth_HighLightBottomSeperator page_obj elem_obj
    break
   } else \
   {
    set Page::($page_obj,add_blk) 0
    set Page::($page_obj,add_flag) 0
   }
  }
 }

#=======================================================================
proc UI_PB_tpth_AddApplyDef {PAGE_OBJ SEQ_PAGE_OBJ SEQ_OBJ EVENT_OBJ } {
  upvar $PAGE_OBJ page_obj
  upvar $SEQ_PAGE_OBJ seq_page_obj
  upvar $EVENT_OBJ event_obj
  upvar $SEQ_OBJ seq_obj
  global paOption
  if { [info exists Page::($page_obj,box)] } \
  {
   pack forget $Page::($page_obj,box)
  }
  set frame [frame $Page::($page_obj,box_frame).frm1]
  pack $frame -side bottom -fill x -pady 3 -padx 3
  set box1_frm [frame $frame.box1]
  set box2_frm [frame $frame.box2]
  tixForm $box1_frm -top 0 -left 0 -right %60 -padright 20
  tixForm $box2_frm -top 0 -left $box1_frm -right %100
  set first_list {"gPB(nav_button,default,Label)" \
   "gPB(nav_button,restore,Label)" \
  "gPB(nav_button,apply,Label)"}
  set second_list {"gPB(nav_button,cancel,Label)" \
  "gPB(nav_button,ok,Label)"}
  set cb_arr(gPB(nav_button,default,Label)) \
  "UI_PB_tpth_DefaultCallBack $page_obj $event_obj"
  set cb_arr(gPB(nav_button,restore,Label)) \
  "UI_PB_tpth_RestoreCallBack $page_obj $event_obj"
  set cb_arr(gPB(nav_button,apply,Label)) \
  "UI_PB_tpth_ApplyCallBack $page_obj $seq_page_obj \
  $seq_obj $event_obj"
  UI_PB_com_CreateButtonBox $box1_frm first_list cb_arr
  set cb_arr(gPB(nav_button,cancel,Label)) \
  "UI_PB_tpth_CancelCallBack $seq_page_obj $page_obj \
  $event_obj"
  set cb_arr(gPB(nav_button,ok,Label)) \
  "UI_PB_tpth_OkCallBack $page_obj $seq_page_obj $seq_obj \
  $event_obj"
  UI_PB_com_CreateButtonBox $box2_frm second_list cb_arr
 }

#=======================================================================
proc UI_PB_tpth_DeleteDummyBlock { PAGE_OBJ EVENT_OBJ } {
  upvar $PAGE_OBJ page_obj
  upvar $EVENT_OBJ event_obj
  if {[llength $event::($event_obj,evt_elem_list)] == 1} \
  {
   set evt_elem_obj [lindex $event::($event_obj,evt_elem_list) 0]
   if [info exists event_element::($evt_elem_obj,block_obj)] \
   {
    set block_obj $event_element::($evt_elem_obj,block_obj)
    if {$block::($block_obj,active_blk_elem_list) == ""} \
    {
     PB_int_RemoveBlkObjFrmList block_obj
     set event::($event_obj,evt_elem_list) [lreplace \
     $event::($event_obj,evt_elem_list) 0 0]
     delete $block_obj
     delete $evt_elem_obj
    }
   }
  }
 }

#=======================================================================
proc UI_PB_tpth_DeleteTpthBlock { SEQ_PAGE_OBJ EVENT_OBJ } {
  upvar $SEQ_PAGE_OBJ seq_page_obj
  upvar $EVENT_OBJ event_obj
  set bot_canvas $Page::($seq_page_obj,bot_canvas)
  if { $event::($event_obj,blk_text) != ""} \
  {
   $bot_canvas delete $event::($event_obj,blk_text)
   set event::($event_obj,blk_text) ""
  }
  if { $event::($event_obj,blk_rect) != "" } \
  {
   $bot_canvas delete $event::($event_obj,blk_rect)
   set event::($event_obj,blk_rect) ""
  }
  if { $event::($event_obj,extra_lines) != "" } \
  {
   $bot_canvas delete $event::($event_obj,extra_lines)
   set event::($event_obj,extra_lines) ""
  }
 }

#=======================================================================
proc UI_PB_tpth_UnsetTpthEvtBlkAttr { EVENT_OBJ } {
  upvar $EVENT_OBJ event_obj
  if { [llength $event::($event_obj,evt_elem_list)] > 0 } \
  {
   foreach elem_obj $event::($event_obj,evt_elem_list) \
   {
    set block_obj $event_element::($elem_obj,block_obj)
    if { $block::($block_obj,sep_id) != "" } \
    {
     set block::($block_obj,sep_id) ""
    }
   }
  }
 }

#=======================================================================
proc UI_PB_UpdateSequenceEvent { SEQ_PAGE_OBJ SEQ_OBJ EVENT_OBJ} {
  upvar $SEQ_PAGE_OBJ seq_page_obj
  upvar $SEQ_OBJ seq_obj
  upvar $EVENT_OBJ event_obj
  if {[string compare $event::($event_obj,evt_elem_list) ""] != 0} \
  {
   set updat_no_elems [llength $event::($event_obj,evt_elem_list)]
   array set rest_evt_obj_attr $event::($event_obj,rest_value)
   set act_no_elems [llength $rest_evt_obj_attr(2)]
   unset rest_evt_obj_attr
   UI_PB_evt_CreateElemOfTpthEvent seq_page_obj seq_obj event_obj
   set current_evt_name $event::($event_obj,event_name)
   PB_int_RetCycleComAndSharedEvts cycle_com_evt cycle_shared_evts
   if {$act_no_elems != $updat_no_elems || \
   [string compare $current_evt_name $cycle_com_evt] == 0} \
   {
    set active_evt_index [lsearch $sequence::($seq_obj,evt_obj_list) \
    $event_obj]
    UI_PB_evt_TransformEvtElem seq_page_obj seq_obj active_evt_index
   }
  }
 }

#=======================================================================
proc UI_PB_tpth_ApplyCallBack { page_obj seq_page_obj seq_obj event_obj } {
  global mom_sys_arr
  global mom_kin_var
  global paOption
  UI_PB_tpth_DeleteDummyBlock page_obj event_obj
  if {$Page::($seq_page_obj,active_seq) == $seq_obj} \
  {
   UI_PB_tpth_DeleteTpthBlock seq_page_obj event_obj
  }
  if { [llength $event::($event_obj,evt_elem_list)] > 0 } \
  {
   array set event_rest_data $event::($event_obj,rest_value)
   foreach elem_obj $event::($event_obj,evt_elem_list)\
   {
    set blk_obj $event_element::($elem_obj,block_obj)
    set block::($blk_obj,elem_addr_list) \
    $block::($blk_obj,active_blk_elem_list)
    set evt_elem_index [lsearch $event_rest_data(2) $elem_obj]
    block::readvalue $blk_obj blk_obj_attr
    set blk_obj_attr(1) [llength $block::($blk_obj,elem_addr_list)]
    block::setvalue $blk_obj blk_obj_attr
    if { ![info exists event_element::($elem_obj,event_obj)] } {
     set event_element::($elem_obj,event_obj) $event_obj
    }
    if { $evt_elem_index == -1 } \
    {
     block::DefaultValue $blk_obj blk_obj_attr
    }
    unset blk_obj_attr
    foreach blk_elm_obj $block::($blk_obj,elem_addr_list) {
     set block_element::($blk_elm_obj,parent_name) $block::($blk_obj,block_name)
     set add_obj $block_element::($blk_elm_obj,elem_add_obj)
     if { [lsearch $address::($add_obj,blk_elem_list) $blk_elm_obj] < 0 } {
      lappend address::($add_obj,blk_elem_list) $blk_elm_obj
     }
     block_element::RestoreValue $blk_elm_obj
    }
    block::RestoreValue $blk_obj
    event_element::RestoreValue $elem_obj
   }
  }
  PB_int_UpdateMOMVar mom_sys_arr
  PB_int_UpdateKinVar mom_kin_var
  UI_PB_tpth_UpdateCycleEvent event_obj seq_obj
  if {$Page::($seq_page_obj,active_seq) == $seq_obj} \
  {
   UI_PB_UpdateSequenceEvent seq_page_obj seq_obj event_obj
  }
  event::RestoreValue $event_obj
  UI_PB_tpth_RestoreEventData page_obj event_obj
  update idletasks
 }

#=======================================================================
proc UI_PB_tpth_OkCallBack { page_obj seq_page_obj seq_obj event_obj } {
  UI_PB_tpth_ApplyCallBack $page_obj $seq_page_obj $seq_obj $event_obj
  UI_PB_tpth_UnsetTpthEvtBlkAttr event_obj
  set event::($event_obj,event_open) 0
  destroy $Page::($page_obj,page_id)
  delete $page_obj
 }

#=======================================================================
proc UI_PB_tpth_CancelCallBack { seq_page_obj page_obj event_obj } {
  global mom_sys_arr
  global mom_kin_var
  UI_PB_tpth_DeleteDummyBlock page_obj event_obj
  UI_PB_tpth_RestoreCallBack $page_obj $event_obj
  if 0 {
   foreach evt_elem_obj $event::($event_obj,evt_elem_list) \
   {
    set block_obj $event_element::($evt_elem_obj,block_obj)
    block::DeleteFromEventElemList $block_obj evt_elem_obj
    foreach blk_elem $block::($block_obj,active_blk_elem_list) \
    {
     block_element::readvalue $blk_elem blk_elem_attr
     address::DeleteFromBlkElemList $blk_elem_attr(0) blk_elem
     unset blk_elem_attr
    }
   }
   array set rest_evt_obj_attr $event::($event_obj,rest_value)
   set active_elem_list $event::($event_obj,evt_elem_list)
   set rest_elem_list $rest_evt_obj_attr(2)
   UI_PB_tpth_UpdateBlkList active_elem_list rest_elem_list
   UI_PB_tpth_DeleteChangeEvtElems event_obj
   event::setvalue $event_obj rest_evt_obj_attr
   if {[string compare $event::($event_obj,evt_elem_list) ""] != 0} \
   {
    foreach elem_obj $event::($event_obj,evt_elem_list)\
    {
     if [info exists event_element::($elem_obj,block_obj)] {
      set blk_obj $event_element::($elem_obj,block_obj)
      array set rest_elem_obj_attr $event_element::($elem_obj,rest_value)
      event_element::setvalue $elem_obj rest_elem_obj_attr
      array set rest_blk_obj_attr $block::($blk_obj,rest_value)
      block::setvalue $blk_obj rest_blk_obj_attr
      block::AddToEventElemList $blk_obj elem_obj
      foreach blk_elem_obj $block::($blk_obj,elem_addr_list) \
      {
       array set blk_elem_attr $block_element::($blk_elem_obj,rest_value)
       block_element::setvalue $blk_elem_obj blk_elem_attr
       address::AddToBlkElemList $blk_elem_attr(0) blk_elem_obj
       unset blk_elem_attr
      }
     }
    }
   }
   if {[info exists Page::($page_obj,rest_evt_mom_var)]} \
   {
    array set rest_evt_mom_var $Page::($page_obj,rest_evt_mom_var)
    array set evt_mom_var $Page::($page_obj,evt_mom_var_list)
    set no_vars [array size evt_mom_var]
    for {set count 0} {$count < $no_vars} {incr count} \
    {
     set mom_var $evt_mom_var($count)
     if { [string match "\$mom_kin*" $mom_var] } \
     {
      set mom_kin_var($mom_var) $rest_evt_mom_var($mom_var)
     } else \
     {
      set mom_sys_arr($mom_var) $rest_evt_mom_var($mom_var)
     }
    }
   }
  }
  UI_PB_tpth_UnsetTpthEvtBlkAttr event_obj
  set event::($event_obj,event_open) 0
  destroy $Page::($page_obj,page_id)
  delete $page_obj
  update idletasks
 }

#=======================================================================
proc UI_PB_tpth_DeleteTpthEventBlkAttr { PAGE_OBJ EVENT_OBJ } {
  upvar $PAGE_OBJ page_obj
  upvar $EVENT_OBJ event_obj
  set bot_canvas $Page::($page_obj,bot_canvas)
  if {[string compare $event::($event_obj,evt_elem_list) ""] != 0} \
  {
   foreach evt_elem_obj $event::($event_obj,evt_elem_list) \
   {
    set block_obj $event_element::($evt_elem_obj,block_obj)
    UI_PB_blk_DeleteCellsIcons page_obj block_obj
    if { $block::($block_obj,sep_id) != "" } \
    {
     $bot_canvas delete [lindex $block::($block_obj,sep_id) 0]
     $bot_canvas delete [lindex $block::($block_obj,sep_id) 1]
     set block::($block_obj,sep_id) ""
    }
   }
  }
 }

#=======================================================================
proc UI_PB_tpth_DeleteChangeEvtElems { EVENT_OBJ } {
  upvar $EVENT_OBJ event_obj
  array set rest_evt_obj_attr $event::($event_obj,rest_value)
  array set def_evt_obj_attr $event::($event_obj,def_value)
  set evt_elem_list ""
  foreach elem_obj $event::($event_obj,evt_elem_list) \
  {
   set block_obj $event_element::($elem_obj,block_obj)
   if { [lsearch $rest_evt_obj_attr(2) $elem_obj] == -1 && \
   [lsearch $def_evt_obj_attr(2) $elem_obj] == -1 } \
   {
    delete $elem_obj
    if { $block::($block_obj,blk_type) == "normal" } \
    {
     PB_int_RemoveBlkObjFrmList block_obj
     } elseif { $block::($block_obj,blk_type) == "comment" } \
    {
     PB_int_DeleteCommentBlkFromList block_obj
    }
    delete $block_obj
   } else \
   {
    UI_PB_blk_DeleteChangeOverBlkElems block_obj
    lappend evt_elem_list $elem_obj
   }
  }
  set event::($event_obj,evt_elem_list) $evt_elem_list
 }

#=======================================================================
proc UI_PB_tpth_UpdateBlkList { ACTIVE_ELEM_LIST CHANGE_TO_ELEM_LIST } {
  upvar $ACTIVE_ELEM_LIST active_elem_list
  upvar $CHANGE_TO_ELEM_LIST change_to_elem_list
  set act_evt_blk_list ""
  foreach act_elem $active_elem_list \
  {
   if [info exists event_element::($act_elem,block_obj)] {
    lappend act_evt_blk_list $event_element::($act_elem,block_obj)
   }
  }
  set chng_evt_blk_list ""
  foreach elem_obj $change_to_elem_list \
  {
   if [info exists event_element::($elem_obj,block_obj)] {
    lappend chng_evt_blk_list $event_element::($elem_obj,block_obj)
   }
  }
  foreach blk_obj $act_evt_blk_list \
  {
   if { [lsearch $chng_evt_blk_list $blk_obj] == -1 } \
   {
    PB_int_RemoveBlkObjFrmList blk_obj
   }
  }
  foreach blk_obj $chng_evt_blk_list \
  {
   if { [lsearch $act_evt_blk_list $blk_obj] == -1 && \
   $block::($blk_obj,blk_type) == "normal" } \
   {
    PB_int_AddBlkObjToList blk_obj
   }
  }
 }

#=======================================================================
proc UI_PB_tpth_DefaultCallBack { page_obj event_obj } {
  global mom_sys_arr
  global mom_kin_var
  UI_PB_tpth_DeleteTpthEventBlkAttr page_obj event_obj
  foreach evt_elem_obj $event::($event_obj,evt_elem_list) \
  {
   set block_obj $event_element::($evt_elem_obj,block_obj)
   block::DeleteFromEventElemList $block_obj evt_elem_obj
   foreach blk_elem $block::($block_obj,active_blk_elem_list) \
   {
    block_element::readvalue $blk_elem blk_elem_attr
    address::DeleteFromBlkElemList $blk_elem_attr(0) blk_elem
    unset blk_elem_attr
   }
  }
  array set def_evt_obj_attr $event::($event_obj,def_value)
  set active_elem_list $event::($event_obj,evt_elem_list)
  set def_elem_list $def_evt_obj_attr(2)
  UI_PB_tpth_UpdateBlkList active_elem_list def_elem_list
  UI_PB_tpth_DeleteChangeEvtElems event_obj
  event::setvalue $event_obj def_evt_obj_attr
  if {[string compare $event::($event_obj,evt_elem_list) ""] != 0} \
  {
   foreach elem_obj $event::($event_obj,evt_elem_list) \
   {
    array set evt_elem_obj_attr $event_element::($elem_obj,def_value)
    event_element::setvalue $elem_obj evt_elem_obj_attr
    block::AddToEventElemList $evt_elem_obj_attr(1) elem_obj
    unset evt_elem_obj_attr
    set block_obj $event_element::($elem_obj,block_obj)
    array set blk_obj_attr $block::($block_obj,def_value)
    block::setvalue $block_obj blk_obj_attr
    unset blk_obj_attr
    foreach blk_elem_obj $block::($block_obj,elem_addr_list) \
    {
     array set blk_elem_attr $block_element::($blk_elem_obj,def_value)
     block_element::setvalue $blk_elem_obj blk_elem_attr
     address::AddToBlkElemList $blk_elem_attr(0) blk_elem_obj
     unset blk_elem_attr
    }
   }
  }
  set Page::($page_obj,dummy_blk) 0
  UI_PB_tpth_CreateElemObjects page_obj event_obj
  UI_PB_tpth_CreateEventBlockTemplates page_obj event_obj
  array set evt_mom_var $Page::($page_obj,evt_mom_var_list)
  PB_int_RetDefMOMVarValues evt_mom_var def_val_mom_var
  set no_vars [array size evt_mom_var]
  for {set count 0} {$count < $no_vars} {incr count} \
  {
   set mom_var $evt_mom_var($count)
   if { [string match "\$mom_kin*" $mom_var] } \
   {
    set mom_kin_var($mom_var) $def_val_mom_var($mom_var)
   } else \
   {
    if {[string match \$mom* $mom_var]} \
    {
     set data_type [UI_PB_com_RetSysVarDataType mom_var]
     set mom_sys_arr($mom_var) [UI_PB_com_RetValByDataType \
     $def_val_mom_var($mom_var) $data_type]
    } else \
    {
     set mom_sys_arr($mom_var) $def_val_mom_var($mom_var)
    }
   }
  }
 }

#=======================================================================
proc UI_PB_tpth_RestoreCallBack { page_obj event_obj } {
  global mom_sys_arr
  global mom_kin_var
  if { ![info exists event::($event_obj,rest_value)] } \
  {
   return
  }
  if $event::($event_obj,canvas_flag) \
  {
   UI_PB_tpth_DeleteTpthEventBlkAttr page_obj event_obj
   foreach evt_elem_obj $event::($event_obj,evt_elem_list) \
   {
    set block_obj $event_element::($evt_elem_obj,block_obj)
    block::DeleteFromEventElemList $block_obj evt_elem_obj
    foreach blk_elem $block::($block_obj,active_blk_elem_list) \
    {
     block_element::readvalue $blk_elem blk_elem_attr
     address::DeleteFromBlkElemList $blk_elem_attr(0) blk_elem
     unset blk_elem_attr
    }
   }
   array set rest_evt_obj_attr $event::($event_obj,rest_value)
   set active_elem_list $event::($event_obj,evt_elem_list)
   set rest_elem_list $rest_evt_obj_attr(2)
   UI_PB_tpth_UpdateBlkList active_elem_list rest_elem_list
   UI_PB_tpth_DeleteChangeEvtElems event_obj
   event::setvalue $event_obj rest_evt_obj_attr
   if {[llength $event::($event_obj,evt_elem_list)] > 0} \
   {
    foreach elem_obj $event::($event_obj,evt_elem_list) \
    {
     if [info exists event_element::($elem_obj,rest_value)] \
     {
      array set evt_elem_obj_attr $event_element::($elem_obj,rest_value)
      event_element::setvalue $elem_obj evt_elem_obj_attr
      unset evt_elem_obj_attr
      set block_obj $event_element::($elem_obj,block_obj)
      array set blk_obj_attr $block::($block_obj,rest_value)
      block::setvalue $block_obj blk_obj_attr
      block::AddToEventElemList $block_obj elem_obj
      unset blk_obj_attr
      foreach blk_elem_obj $block::($block_obj,elem_addr_list) \
      {
       array set blk_elem_attr $block_element::($blk_elem_obj,rest_value)
       block_element::setvalue $blk_elem_obj blk_elem_attr
       address::AddToBlkElemList $blk_elem_attr(0) blk_elem_obj
       unset blk_elem_attr
      }
     }
    }
   }
   set Page::($page_obj,dummy_blk) 0
   UI_PB_tpth_CreateElemObjects page_obj event_obj
   UI_PB_tpth_CreateEventBlockTemplates page_obj event_obj
  }
  if [info exists Page::($page_obj,rest_evt_mom_var)] \
  {
   array set rest_evt_mom_var $Page::($page_obj,rest_evt_mom_var)
   array set evt_mom_var $Page::($page_obj,evt_mom_var_list)
   set no_vars [array size evt_mom_var]
   for {set count 0} {$count < $no_vars} {incr count} \
   {
    set mom_var $evt_mom_var($count)
    if { [string match "\$mom_kin*" $mom_var] } \
    {
     set mom_kin_var($mom_var) $rest_evt_mom_var($mom_var)
    } else \
    {
     if {[string match \$mom* $mom_var]} \
     {
      set data_type [UI_PB_com_RetSysVarDataType mom_var]
      set mom_sys_arr($mom_var) [UI_PB_com_RetValByDataType \
      $rest_evt_mom_var($mom_var) $data_type]
     } else \
     {
      set mom_sys_arr($mom_var) $rest_evt_mom_var($mom_var)
     }
    }
   }
  }
 }

#=======================================================================
proc UI_PB_tpth_ValidateEventUIData { EVENT_OBJ } {
  upvar $EVENT_OBJ event_obj
  global gPB
  foreach item_obj $event::($event_obj,evt_itm_obj_list) \
  {
   foreach grp_obj $item::($item_obj,grp_obj_list) \
   {
    foreach mem_obj $item_group::($grp_obj,mem_obj_list) \
    {
     group_member::readvalue $mem_obj mem_obj_attr
     UI_PB_com_ValidateData mem_obj_attr(2) mem_obj_attr(3) ret_code
     if { $ret_code} \
     {
      tk_messageBox  -parent [UI_PB_com_AskActiveWindow] \
      -type ok -icon error \
      -message "$gPB(msg,invalid_data) $mem_obj_attr(0)"
      return 1
     }
    }
   }
  }
  return 0
 }

#=======================================================================
proc UI_PB_tpth_UpdateEventFloats { EVENT_OBJ MOM_SYS_ARR } {
  upvar $EVENT_OBJ event_obj
  upvar $MOM_SYS_ARR mom_sys_arr
  foreach item_obj $event::($event_obj,evt_itm_obj_list) \
  {
   foreach grp_obj $item::($item_obj,grp_obj_list) \
   {
    foreach mem_obj $item_group::($grp_obj,mem_obj_list) \
    {
     group_member::readvalue $mem_obj mem_obj_attr
     if {$mem_obj_attr(1) == 5} \
     {
      append var1 $mem_obj_attr(3) _int
      append var2 $mem_obj_attr(3) _dec
      append value $mom_sys_arr($var1) . $mom_sys_arr($var2)
      set mom_sys_arr($mem_obj_attr(3)) $value
      unset var1 var2 value
     }
    }
   }
  }
 }

#=======================================================================
proc UI_PB_tpth_DeleteBlkSeqEventElements { BLOCK_OBJ CUR_EVT_OBJ } {
  upvar $BLOCK_OBJ block_obj
  upvar $CUR_EVT_OBJ cur_evt_obj
  set blk_evt_elem_list $block::($block_obj,evt_elem_list)
  set blk_evt_elem_list [lsort -integer $blk_evt_elem_list ]
  set prev_elem 0
  foreach elem_obj $blk_evt_elem_list \
  {
   if { ![info exists event_element::($elem_obj,event_obj)] } \
   {
    continue
   }
   if { $prev_elem != $elem_obj } \
   {
    set event_obj $event_element::($elem_obj,event_obj)
    if { $event_obj != $cur_evt_obj } \
    {
     event::readvalue $event_obj evt_obj_attr
     set new_elem_list ""
     foreach row_elem $evt_obj_attr(2) \
     {
      set index [lsearch $row_elem $elem_obj]
      if { $index != -1 } \
      {
       set row_elem [lreplace $row_elem $index $index]
      }
      if { $row_elem != "" } \
      {
       lappend new_elem_list $row_elem
      }
     }
     set evt_obj_attr(2) $new_elem_list
     set evt_obj_attr(1) [llength $new_elem_list]
     event::setvalue $event_obj evt_obj_attr
     unset evt_obj_attr
     array set def_evt_obj_attr $event::($event_obj,def_value)
     set new_def_evt_elem_list ""
     foreach row_list $def_evt_obj_attr(2) \
     {
      set index [lsearch $row_list $elem_obj]
      if { $index != -1 } \
      {
       set row_list [lreplace $row_list $index $index]
      }
      if { $row_list != "" } \
      {
       lappend new_def_evt_elem_list $row_list
      }
     }
     set def_evt_obj_attr(2) $new_def_evt_elem_list
     set def_evt_obj_attr(1) [llength $new_def_evt_elem_list]
     set event::($event_obj,def_value) [array get def_evt_obj_attr]
     set prev_elem $elem_obj
     delete $elem_obj
    }
   }
  }
 }

#=======================================================================
proc UI_PB_tpth_DeleteApplyEvtElems { SEQ_PAGE_OBJ EVENT_OBJ } {
  upvar $SEQ_PAGE_OBJ seq_page_obj
  upvar $EVENT_OBJ event_obj
  array set event_rest_data $event::($event_obj,rest_value)
  array set event_def_data $event::($event_obj,def_value)
  foreach elem_obj $event_rest_data(2) \
  {
   if [info exists event_element::($elem_obj,block_obj)] \
   {
    set block_obj $event_element::($elem_obj,block_obj)
    if { [lsearch $event_def_data(2) $elem_obj] == -1 && \
    [lsearch $event::($event_obj,evt_elem_list) $elem_obj] == -1 } \
    {
     delete $elem_obj
     if { $block::($block_obj,blk_type) == "normal" } \
     {
      PB_int_RemoveBlkObjFrmList block_obj
      set dummy_evt 0
      UI_PB_tpth_DeleteBlkSeqEventElements block_obj dummy_evt
      UI_PB_evt_RemBlkFromBuffList seq_page_obj block_obj
      } elseif { $block::($block_obj,blk_type) == "comment" } \
     {
      PB_int_DeleteCommentBlkFromList block_obj
     }
     delete $block_obj
     } elseif {[lsearch $event::($event_obj,evt_elem_list) $elem_obj] == -1} \
    {
     if { $block::($block_obj,blk_type) == "normal" } \
     {
      PB_int_RemoveBlkObjFrmList block_obj
      UI_PB_tpth_DeleteBlkSeqEventElements block_obj event_obj
      UI_PB_evt_RemBlkFromBuffList seq_page_obj block_obj
     }
    } else \
    {
     UI_PB_blk_DeleteApplyChangeOverBlkElems block_obj
    }
   }
  }
 }

#=======================================================================
proc __UI_PB_tpth_ApplyCallBack { page_obj seq_page_obj seq_obj event_obj } {
  global mom_sys_arr
  UI_PB_tpth_DeleteTpthBlock seq_page_obj event_obj
  UI_PB_tpth_DeleteApplyEvtElems seq_page_obj event_obj
  if {[string compare $event::($event_obj,evt_elem_list) ""] != 0} \
  {
   array set event_rest_data $event::($event_obj,rest_value)
   foreach elem_obj $event::($event_obj,evt_elem_list)\
   {
    set blk_obj $event_element::($elem_obj,block_obj)
    set block::($blk_obj,elem_addr_list) \
    $block::($blk_obj,active_blk_elem_list)
    set evt_elem_index [lsearch $event_rest_data(2) $elem_obj]
    if { $evt_elem_index == -1 } \
    {
     block::readvalue $blk_obj blk_obj_attr
     set blk_obj_attr(1) [llength $block::($blk_obj,elem_addr_list)]
     block::setvalue $blk_obj blk_obj_attr
     if { ![info exists event_element::($elem_obj,event_obj)] } {
      set event_element::($elem_obj,event_obj) $event_obj
     }
     block::DefaultValue $blk_obj blk_obj_attr
     unset blk_obj_attr
    }
   }
  }
  PB_int_UpdateMOMVar mom_sys_arr
  UI_PB_tpth_DeleteAndRecreateIcons page_obj event_obj
  UI_PB_tpth_UpdateCycleEvent event_obj seq_obj
  if { $Page::($seq_page_obj,active_seq) == $seq_obj} \
  {
   UI_PB_UpdateSequenceEvent seq_page_obj seq_obj event_obj
  }
  set Page::($page_obj,active_blk_elem) 0
  UI_PB_tpth_RestoreEventData page_obj event_obj
 }

#=======================================================================
proc UI_PB_tpth_CycleRapidBlks { page_obj event_obj member_obj args } {
  global mom_sys_arr
  set cycle_blk_name "post_rapidto"
  UI_PB_tpth_UpdateCycleSetEvent page_obj event_obj cycle_blk_name
  PB_int_CreateCycleRaptoBlks event_obj mom_sys_arr
  UI_PB_tpth_CreateEventBlockTemplates page_obj event_obj
 }

#=======================================================================
proc UI_PB_tpth_CycleRetractBlks { page_obj event_obj member_obj args } {
  global mom_sys_arr
  set cycle_blk_name "post_retracto"
  UI_PB_tpth_UpdateCycleSetEvent page_obj event_obj cycle_blk_name
  PB_int_CreateCycleRetractoBlks event_obj mom_sys_arr
  UI_PB_tpth_CreateEventBlockTemplates page_obj event_obj
 }

#=======================================================================
proc UI_PB_tpth_CycleStartBlks { page_obj event_obj member_obj args } {
  global mom_sys_arr
  set cycle_blk_name "post_startblk"
  set strt_flag 0
  set elem_index 0
  foreach evt_elem_obj $event::($event_obj,evt_elem_list) \
  {
   set block_obj $event_element::($evt_elem_obj,block_obj)
   if { $block::($block_obj,block_name) == "$cycle_blk_name" } \
   {
    set strt_flag 1
    break
   }
   incr elem_index
  }
  UI_PB_tpth_UpdateCycleSetEvent page_obj event_obj cycle_blk_name
  if { $strt_flag } \
  {
   set strt_blk_index $elem_index
  } else \
  {
   set strt_blk_index 0
  }
  PB_int_CreateCycleStartBlks event_obj mom_sys_arr strt_blk_index
  UI_PB_tpth_CreateEventBlockTemplates page_obj event_obj
 }

#=======================================================================
proc UI_PB_tpth_CyclePlaneElem { page_obj event_obj member_obj args } {
  global mom_sys_arr
  set cycle_blk_name "post_plane"
  UI_PB_tpth_UpdateCycleSetEvent page_obj event_obj cycle_blk_name
  PB_int_CreateCyclePlaneElems event_obj mom_sys_arr
  UI_PB_tpth_CreateEventBlockTemplates page_obj event_obj
 }

#=======================================================================
proc UI_PB_tpth_UpdateCycleSetEvent { PAGE_OBJ EVENT_OBJ CYCLE_BLK_NAME } {
  upvar $PAGE_OBJ page_obj
  upvar $EVENT_OBJ event_obj
  upvar $CYCLE_BLK_NAME cycle_blk_name
  UI_PB_tpth_DeleteTpthEventBlkAttr page_obj event_obj
  UI_PB_tpth_DeletePostBlocks event_obj cycle_blk_name
 }

#=======================================================================
proc UI_PB_tpth_DeletePostBlocks { EVENT_OBJ CYCLE_BLK_NAME } {
  upvar $EVENT_OBJ event_obj
  upvar $CYCLE_BLK_NAME cycle_blk_name
  foreach evt_elem_obj $event::($event_obj,evt_elem_list) \
  {
   set block_obj $event_element::($evt_elem_obj,block_obj)
   set block_name $block::($block_obj,block_name)
   if {[string match "$cycle_blk_name*" $block_name]} \
   {
    continue
   } else \
   {
    set ret_code [PB_evt_CheckCycleRefWord block_obj 1]
    if { $ret_code } \
    {
     switch $cycle_blk_name \
     {
      "post_rapidto"  { set search_list [list "R"] }
      "post_retracto" { set search_list [list "K_cycle" "G_return"] }
      "post_plane"    { set search_list [list "G_plane"] }
      "default"       { set search_list ""}
     }
     foreach blk_elem_obj $block::($block_obj,active_blk_elem_list) \
     {
      set elem_mom_var $block_element::($blk_elem_obj,elem_mom_variable)
      set add_obj $block_element::($blk_elem_obj,elem_add_obj)
      set add_name $address::($add_obj,add_name)
      if { [lsearch $search_list $add_name] != -1} \
      {
       continue
      }
      lappend blk_elem_list $blk_elem_obj
     }
     if {[info exists blk_elem_list]} \
     {
      set block::($block_obj,elem_addr_list) $blk_elem_list
      unset blk_elem_list
     }
    } else \
    {
     set block::($block_obj,elem_addr_list) \
     $block::($block_obj,active_blk_elem_list)
    }
    lappend evt_elem_list $evt_elem_obj
   }
  }
  if {[info exists evt_elem_list]} \
  {
   set event::($event_obj,evt_elem_list) $evt_elem_list
   unset evt_elem_list
  }
 }

#=======================================================================
proc _tpth_DeleteCycleEvtElems { CYC_EVT_OBJ COM_EVT_NAME } {
  upvar $CYC_EVT_OBJ cyc_evt_obj
  upvar $COM_EVT_NAME com_evt_name
  set cyc_evt_name $event::($cyc_evt_obj,event_name)
  set new_evt_elem_list ""
  foreach cyc_evt_elem_obj $event::($cyc_evt_obj,evt_elem_list)\
  {
   set cyc_blk_obj $event_element::($cyc_evt_elem_obj,block_obj)
   if { [info exists block::($cyc_blk_obj,blk_owner)] && \
   $block::($cyc_blk_obj,blk_owner) == "$cyc_evt_name" } \
   {
    delete $cyc_evt_elem_obj
   }
  }
 }

#=======================================================================
proc UI_PB_tpth_DeleteComEvtBlkElems { CYC_EVT_OBJ COM_EVT_NAME } {
  upvar $CYC_EVT_OBJ cyc_evt_obj
  upvar $COM_EVT_NAME com_evt_name
  set new_evt_elem_list ""
  foreach cyc_evt_elem_obj $event::($cyc_evt_obj,evt_elem_list)\
  {
   set cyc_blk_obj $event_element::($cyc_evt_elem_obj,block_obj)
   if [info exists block::($cyc_blk_obj,blk_owner)] {
    if { $block::($cyc_blk_obj,blk_owner) == "NONE" } {
     set block::($cyc_blk_obj,blk_owner) "$com_evt_name"
    }
   }
   if { [info exists block::($cyc_blk_obj,blk_owner)] == 0 || \
    $block::($cyc_blk_obj,blk_owner) == "post" || \
   $block::($cyc_blk_obj,blk_owner) == "$com_evt_name" } \
   {
    delete $cyc_evt_elem_obj
   } else \
   {
    set blk_elem_list $block::($cyc_blk_obj,elem_addr_list)
    set new_blk_elem_list ""
    foreach blk_elem_obj $blk_elem_list \
    {
     if { ![info exists block_element::($blk_elem_obj,owner)] } \
     {
      continue
     }
     set blk_elem_owner $block_element::($blk_elem_obj,owner)
     set blk_elem_var $block_element::($blk_elem_obj,elem_mom_variable)
     if { [string compare $blk_elem_owner "$com_evt_name"] == 0 } \
     {
      } elseif { [string compare $blk_elem_owner "post"] == 0 && \
     [string match "\$mom_sys_cycle*" $blk_elem_var]== 0 } \
     {
     } else \
     {
      lappend new_blk_elem_list $blk_elem_obj
     }
    }
    set block::($cyc_blk_obj,elem_addr_list) $new_blk_elem_list
    lappend new_evt_elem_list $cyc_evt_elem_obj
   }
  }
  set event::($cyc_evt_obj,evt_elem_list) $new_evt_elem_list
 }

#=======================================================================
proc UI_PB_tpth_UpdateRepBlkElemAttr { REP_BLK_ELEM ADD_BLK_ELEM_LIST } {
  upvar $REP_BLK_ELEM rep_blk_elem
  upvar $ADD_BLK_ELEM_LIST add_blk_elem_list
  foreach blk_elem $add_blk_elem_list \
  {
   set addr_obj $block_element::($blk_elem,elem_add_obj)
   set addr_name $address::($addr_obj,add_name)
   if {[string compare "G_motion" $addr_name] == 0} \
   {
    block_element::readvalue $blk_elem blk_elem_attr
    block_element::readvalue $rep_blk_elem rep_elem_attr
    set rep_elem_attr(1) $blk_elem_attr(1)
    set rep_elem_attr(3) $blk_elem_attr(3)
    block_element::setvalue $blk_elem rep_elem_attr
    break
   }
  }
 }

#=======================================================================
proc UI_PB_tpth_AddComBlkElemToBlk { COM_BLK_OBJ ADD_BLK_ELEM_LIST \
  CUR_EVT_NAME DUP_ADDR_FLAG } {
  upvar $COM_BLK_OBJ com_blk_obj
  upvar $ADD_BLK_ELEM_LIST add_blk_elem_list
  upvar $CUR_EVT_NAME cur_evt_name
  upvar $DUP_ADDR_FLAG dup_addr_flag
  block::readvalue $com_blk_obj blk_obj_attr
  foreach blk_elem_obj $block::($com_blk_obj,elem_addr_list) \
  {
   set addr_obj $block_element::($blk_elem_obj,elem_add_obj)
   set addr_name $address::($addr_obj,add_name)
   if {$dup_addr_flag} \
   {
    if {[string compare "G_motion" $addr_name] == 0} \
    {
     UI_PB_tpth_UpdateRepBlkElemAttr blk_elem_obj add_blk_elem_list
     set block_element::($blk_elem_obj,owner) "post"
     continue
    }
   }
   if 0 {
    set idx 0
    foreach blk_elem $add_blk_elem_list {
     set cyc_addr_obj $block_element::($blk_elem,elem_add_obj)
     set cyc_addr_name $address::($cyc_addr_obj,add_name)
     if [string match "$addr_name" "$cyc_addr_name"] {
      set add_blk_elem_list [lreplace $add_blk_elem_list $idx $idx]
      break
     }
     incr idx
    }
    lappend add_blk_elem_list $blk_elem_obj
   }
   if 1 {
    set elem_found 0
    foreach blk_elem $add_blk_elem_list {
     set cyc_addr_obj $block_element::($blk_elem,elem_add_obj)
     set cyc_addr_name $address::($cyc_addr_obj,add_name)
     if [string match "$addr_name" "$cyc_addr_name"] {
      set elem_found 1
      break
     }
    }
    if { !$elem_found } {
     lappend add_blk_elem_list $blk_elem_obj
    }
   }
  }
  UI_PB_com_SortBlockElements add_blk_elem_list
 }

#=======================================================================
proc UI_PB_tpth_CreateEvtElemFrmEvtObj { EVT_ELEM_OBJ NEW_EVT_ELEM_OBJ \
  EVENT_OBJ } {
  upvar $EVT_ELEM_OBJ evt_elem_obj
  upvar $NEW_EVT_ELEM_OBJ new_evt_elem_obj
  upvar $EVENT_OBJ event_obj
  set blk_obj $event_element::($evt_elem_obj,block_obj)
  set block_name $block::($blk_obj,block_name)
  set new_evt_elem_obj [new event_element]
  set evt_elem_attr(0) $block_name
  set evt_elem_attr(1) $blk_obj
  set evt_elem_attr(2) "normal"
  PB_evt_CreateEventElement new_evt_elem_obj evt_elem_attr
  set event_element::($new_evt_elem_obj,event_obj) $event_obj
 }

#=======================================================================
proc UI_PB_tpth_UpdateDefsOfCycleEvent { COM_EVENT_OBJ CYCLE_EVT_OBJ } {
  upvar $COM_EVENT_OBJ com_event_obj
  upvar $CYCLE_EVT_OBJ cycle_evt_obj
  set com_evt_name $event::($com_event_obj,event_name)
  array set def_cyc_evt_attr $event::($cycle_evt_obj,def_value)
  set cycle_evt_name $event::($cycle_evt_obj,event_name)
  set def_cyc_evt_elem ""
  foreach evt_elem_obj $event::($cycle_evt_obj,evt_elem_list) \
  {
   set evt_blk $event_element::($evt_elem_obj,block_obj)
   set ret [PB_evt_CheckCycleRefWord evt_blk 1]
   if { $block::($evt_blk,blk_owner) == "$com_evt_name" || \
   $block::($evt_blk,blk_owner) == "post" } \
   {
    lappend def_cyc_evt_elem $evt_elem_obj
    } elseif { $ret } \
   {
    foreach cyc_evt_elem $def_cyc_evt_attr(2) \
    {
     if { [info exists event_element::($cyc_evt_elem,block_obj)] } \
     {
      set cyc_blk_obj $event_element::($cyc_evt_elem,block_obj)
      set ret_code [PB_evt_CheckCycleRefWord cyc_blk_obj 1]
      if { $ret_code} \
      {
       set com_blk_elem_list ""
       foreach blk_elem $block::($evt_blk,elem_addr_list) \
       {
        if { $block_element::($blk_elem,owner) == "$com_evt_name" || \
        $block_element::($blk_elem,owner) == "post" } \
        {
         lappend com_blk_elem_list $blk_elem
        }
       }
       array set def_blk_elem $block::($cyc_blk_obj,def_value)
       foreach blk_elem $def_blk_elem(2) \
       {
        if { [info exists block_element::($blk_elem,owner)] } \
        {
         if { $block_element::($blk_elem,owner) == "$cycle_evt_name" } \
         {
          set add_obj $block_element::($blk_elem,elem_add_obj)
          set add_name $address::($add_obj,add_name)
          set add_found 0
          foreach elem_obj $com_blk_elem_list {
           set add_obj $block_element::($elem_obj,elem_add_obj)
           if [string match "$add_name" $address::($add_obj,add_name)] {
            set add_found 1
            break
           }
          }
          if { !$add_found } {
           lappend com_blk_elem_list $blk_elem
          }
         }
        }
       }
       set def_blk_elem(2) $com_blk_elem_list
       set def_blk_elem(1) [llength $com_blk_elem_list]
       block::DefaultValue $cyc_blk_obj def_blk_elem
       lappend def_cyc_evt_elem $cyc_evt_elem
       } elseif { $block::($cyc_blk_obj,blk_owner) == "$cycle_evt_name"} \
      {
       lappend def_cyc_evt_elem $cyc_evt_elem
      }
     }
    }
   }
  }
  set def_cyc_evt_attr(2) $def_cyc_evt_elem
  set def_cyc_evt_attr(1) [llength $def_cyc_evt_elem]
  event::DefaultValue $cycle_evt_obj def_cyc_evt_attr
 }

#=======================================================================
proc _tpth_GetCycleGCodeVar { cycle_event_name } {
  switch $cycle_event_name {
   "Drill" {
    set gcode "\$mom_sys_cycle_drill_code"
   }
   "Drill Dwell" {
    set gcode "\$mom_sys_cycle_drill_dwell_code"
   }
   "Drill Deep" {
    set gcode "\$mom_sys_cycle_drill_deep_code"
   }
   "Drill Break Chip" {
    set gcode "\$mom_sys_cycle_drill_deep_code"
   }
   "Tap" {
    set gcode "\$mom_sys_cycle_tap_code"
   }
   "Bore" {
    set gcode "\$mom_sys_cycle_bore_code"
   }
   "Bore Drag" {
    set gcode "\$mom_sys_cycle_bore_drag_code"
   }
   "Bore No Drag" {
    set gcode "\$mom_sys_cycle_bore_no_drag_code"
   }
   "Bore Manual" {
    set gcode "\$mom_sys_cycle_bore_manual_code"
   }
   "Bore Dwell" {
    set gcode "\$mom_sys_cycle_bore_dwell_code"
   }
   "Bore Manual Dwell" {
    set gcode "\$mom_sys_cycle_bore_manual_code"
   }
   "Bore Back" {
    set gcode "\$mom_sys_cycle_bore_back_code"
   }
   default {
    set gcode "\$mom_sys_cycle_reps_code"
   }
  }
  return $gcode
 }

#=======================================================================
proc UI_PB_tpth_IsCycleCustom { cycle_event_name } {
  global mom_sys_arr
  set custom_cycle 0
  switch $cycle_event_name {
   "Drill" {
    if [info exists mom_sys_arr(\$mom_sys_sim_cycle_drill)] {
     if $mom_sys_arr(\$mom_sys_sim_cycle_drill) { set custom_cycle 1 }
    }
   }
   "Drill Dwell" {
    if [info exists mom_sys_arr(\$mom_sys_sim_cycle_drill_dwell)] {
     if $mom_sys_arr(\$mom_sys_sim_cycle_drill_dwell) { set custom_cycle 1 }
    }
   }
   "Drill Deep" {
    if [info exists mom_sys_arr(\$mom_sys_sim_cycle_drill_deep)] {
     if $mom_sys_arr(\$mom_sys_sim_cycle_drill_deep) { set custom_cycle 1 }
    }
   }
   "Drill Break Chip" {
    if [info exists mom_sys_arr(\$mom_sys_sim_cycle_drill_break_chip)] {
     if $mom_sys_arr(\$mom_sys_sim_cycle_drill_break_chip) { set custom_cycle 1 }
    }
   }
   "Tap" {
    if [info exists mom_sys_arr(\$mom_sys_sim_cycle_tap)] {
     if $mom_sys_arr(\$mom_sys_sim_cycle_tap) { set custom_cycle 1 }
    }
   }
   "Bore" {
    if [info exists mom_sys_arr(\$mom_sys_sim_cycle_bore)] {
     if $mom_sys_arr(\$mom_sys_sim_cycle_bore) { set custom_cycle 1 }
    }
   }
   "Bore Drag" {
    if [info exists mom_sys_arr(\$mom_sys_sim_cycle_bore_drag)] {
     if $mom_sys_arr(\$mom_sys_sim_cycle_bore_drag) { set custom_cycle 1 }
    }
   }
   "Bore No Drag" {
    if [info exists mom_sys_arr(\$mom_sys_sim_cycle_bore_nodrag)] {
     if $mom_sys_arr(\$mom_sys_sim_cycle_bore_nodrag) { set custom_cycle 1 }
    }
   }
   "Bore Manual" {
    if [info exists mom_sys_arr(\$mom_sys_sim_cycle_bore_manual)] {
     if $mom_sys_arr(\$mom_sys_sim_cycle_bore_manual) { set custom_cycle 1 }
    }
   }
   "Bore Dwell" {
    if [info exists mom_sys_arr(\$mom_sys_sim_cycle_bore_dwell)] {
     if $mom_sys_arr(\$mom_sys_sim_cycle_bore_dwell) { set custom_cycle 1 }
    }
   }
   "Bore Manual Dwell" {
    if [info exists mom_sys_arr(\$mom_sys_sim_cycle_bore_manual_dwell)] {
     if $mom_sys_arr(\$mom_sys_sim_cycle_bore_manual_dwell) { set custom_cycle 1 }
    }
   }
   "Bore Back" {
    if [info exists mom_sys_arr(\$mom_sys_sim_cycle_bore_back)] {
     if $mom_sys_arr(\$mom_sys_sim_cycle_bore_back) { set custom_cycle 1 }
    }
   }
  }
  return $custom_cycle
 }

#=======================================================================
proc UI_PB_tpth_UpdateCycleEvent { EVENT_OBJ SEQ_OBJ } {
  upvar $EVENT_OBJ event_obj
  upvar $SEQ_OBJ seq_obj
  global mom_sys_arr
  global post_object
  set current_evt_name $event::($event_obj,event_name)
  PB_int_RetCycleComAndSharedEvts cycle_com_evt cycle_shared_evts
  set evt_obj_list $sequence::($seq_obj,evt_obj_list)
  if { [string compare $cycle_com_evt $current_evt_name] == 0 } \
  {
   set cur_evt_elems [llength $event::($event_obj,evt_elem_list)]
   if $cur_evt_elems \
   {
    foreach cycle_event_name $cycle_shared_evts \
    {
     PB_com_RetObjFrmName cycle_event_name evt_obj_list cycle_evt_obj
     set custom_cycle [UI_PB_tpth_IsCycleCustom $cycle_event_name]
     if $custom_cycle {
      if { ![info exists event::($cycle_evt_obj,custom_def)] } {
       if [info exists event::($cycle_evt_obj,rest_value)] {
        array set evt_attr $event::($cycle_evt_obj,rest_value)
        set evt_elem_obj_list $evt_attr(2)
        } else {
        set evt_elem_obj_list $event::($cycle_evt_obj,evt_elem_list)
       }
       set new_evt_elem_obj_list [list]
       set blk_idx 0
       set blk_name [join [split [string tolower $cycle_event_name]] "_"]
       set blk_name cycle_$blk_name
       foreach evt_elem_obj $evt_elem_obj_list {
        set blk_obj 0
        if [info exists event_element::($evt_elem_obj,rest_value)] {
         array set evt_elem_attr $event_element::($evt_elem_obj,rest_value)
         set blk_obj $evt_elem_attr(1)
         } else {
         if [info exists event_element::($evt_elem_obj,block_obj)] {
          set blk_obj $event_element::($evt_elem_obj,block_obj)
         }
        }
        if $blk_obj {
         set block_type $block::($blk_obj,blk_type)
         switch $block_type {
          "command" {
           set cmd_blk_elem  [lindex $block::($blk_obj,elem_addr_list) 0]
           set cmd_obj $block_element::($cmd_blk_elem,elem_mom_variable)
           if { [string match "*MOM_*" $cmd_obj] } \
           {
            set cmd_name $cmd_obj
           } else \
           {
            set cmd_name $command::($cmd_obj,name)
           }
           PB_int_CreateCmdBlkElem cmd_name cmd_blk_elem
           PB_int_CreateCmdBlock cmd_name cmd_blk_elem new_blk_obj
           set blk_obj_list $Post::($post_object,cmd_blk_list)
           set block::($new_blk_obj,blk_type) "command"
          }
          "comment" {
           set cmd_blk_elem  [lindex $block::($blk_obj,elem_addr_list) 0]
           set elem_name "comment_blk"
           PB_int_CreateCommentBlkElem elem_name blk_elem_obj
           set block_element::($blk_elem_obj,elem_mom_variable) \
           $block_element::($cmd_blk_elem,elem_mom_variable)
           PB_int_CreateCommentBlk elem_name blk_elem_obj new_blk_obj
           set blk_obj_list $Post::($post_object,comment_blk_list)
           set block::($new_blk_obj,blk_type) "comment"
          }
          default {
           PB_int_CreateCopyABlock blk_obj new_blk_obj
           set blk_obj_list $Post::($post_object,blk_obj_list)
           if [string match "$blk_name*" $block::($blk_obj,block_name)] {
            set new_blk_name $block::($blk_obj,block_name)
            } else {
            set new_blk_name [PB_com_GetNextObjName $blk_name block]
           }
           set block::($new_blk_obj,block_name) $new_blk_name
           set block::($new_blk_obj,blk_type) "normal"
          }
         }
         set block::($new_blk_obj,blk_owner) "$cycle_event_name"
         set blk_elem_obj_list $block::($new_blk_obj,elem_addr_list)
         foreach blk_elem_obj $blk_elem_obj_list {
          set block_element::($blk_elem_obj,owner) "$cycle_event_name"
          set block_element::($blk_elem_obj,parent_name) "$block::($new_blk_obj,block_name)"
         }
         PB_int_CreateNewEventElement new_blk_obj new_evt_elem_obj
         event_element::readvalue $new_evt_elem_obj obj_attr
         event_element::DefaultValue $new_evt_elem_obj obj_attr
         lappend new_evt_elem_obj_list $new_evt_elem_obj
         set block::($new_blk_obj,active_blk_elem_list) $blk_elem_obj_list
         block::RestoreValue $new_blk_obj
         block::readvalue $new_blk_obj obj_attr
         block::DefaultValue $new_blk_obj obj_attr
         set idx [lsearch $blk_obj_list $blk_obj]
         set blk_obj_list [lreplace $blk_obj_list $idx $idx]
         switch $block_type {
          "command" {
           set Post::($post_object,cmd_obj_list) $blk_obj_list
          }
          "comment" {
           set Post::($post_object,comment_obj_list) $blk_obj_list
          }
          default {
           set Post::($post_object,blk_obj_list) $blk_obj_list
          }
         }
        }
       }
       if [info exists Post::($post_object,blk_obj_list)] {
        PB_com_SortObjectsByNames Post::($post_object,blk_obj_list)
       }
       if [info exists Post::($post_object,cmd_obj_list)] {
        PB_com_SortObjectsByNames Post::($post_object,cmd_obj_list)
       }
       if [info exists Post::($post_object,comment_obj_list)] {
        PB_com_SortObjectsByNames Post::($post_object,comment_obj_list)
       }
       event::readvalue $cycle_evt_obj evt_attr
       set evt_attr(1) [llength $new_evt_elem_obj_list]
       set evt_attr(2) $new_evt_elem_obj_list
       set event::($cycle_evt_obj,custom_def) [array get evt_attr]
       set event::($cycle_evt_obj,def_value) [array get evt_attr]
       } else {
       array set evt_attr $event::($cycle_evt_obj,custom_def)
      }
      event::setvalue $cycle_evt_obj evt_attr
      event::RestoreValue $cycle_evt_obj
      continue
     } 
     UI_PB_tpth_DeleteComEvtBlkElems cycle_evt_obj current_evt_name
     set act_cyc_evt_elem [list]
     foreach evt_elem_obj $event::($event_obj,evt_elem_list) \
     {
      set com_evt_blk $event_element::($evt_elem_obj,block_obj)
      set ret [PB_evt_CheckCycleRefWord com_evt_blk 1]
      if {$ret == 0} \
      {
       UI_PB_tpth_CreateEvtElemFrmEvtObj evt_elem_obj \
       new_evt_elem_obj cycle_evt_obj
       lappend act_cyc_evt_elem $new_evt_elem_obj
      } else \
      {
       set com_anc_blk $com_evt_blk
       if [info exists event::($cycle_evt_obj,custom_def)] \
       {
        set blk_obj $event_element::($evt_elem_obj,block_obj)
        PB_int_CreateCopyABlock blk_obj new_blk_obj
        set blk_name [join [split [string tolower $cycle_event_name]] "_"]
        set blk_name cycle_$blk_name
        set new_blk_name [PB_com_GetNextObjName $blk_name block]
        if { $new_blk_name == "" } { set new_blk_name $blk_name }
        PB_com_RetObjFrmName blk_name Post::($post_object,blk_obj_list) old_blk_obj
        if { $old_blk_obj > 0 } { 
         set block::($old_blk_obj,block_name) $new_blk_name
         block::readvalue $old_blk_obj obj_attr
         set obj_attr(0) $new_blk_name
         block::setvalue $old_blk_obj obj_attr
         block::DefaultValue $old_blk_obj obj_attr
        }
        set block::($new_blk_obj,block_name) $blk_name
        set block::($new_blk_obj,blk_type) "normal"
        set block::($new_blk_obj,blk_owner) "$cycle_event_name"
        PB_com_SortObjectsByNames Post::($post_object,blk_obj_list)
        PB_int_CreateNewEventElement new_blk_obj new_evt_elem_obj
        set blk_elem_obj_list $block::($new_blk_obj,elem_addr_list)
        foreach blk_elem_obj $blk_elem_obj_list {
         set block_element::($blk_elem_obj,owner) "$cycle_com_evt"
         set block_element::($blk_elem_obj,parent_name) "$block::($new_blk_obj,block_name)"
         if [string match "\$mom_sys_cycle_reps_code" \
         $block_element::($blk_elem_obj,elem_mom_variable)] {
          set block_element::($blk_elem_obj,elem_mom_variable) \
          [_tpth_GetCycleGCodeVar $cycle_event_name]
          set block_element::($blk_elem_obj,elem_desc) "$cycle_event_name"
          set block_element::($blk_elem_obj,owner) "post"
         }
         block_element::readvalue $blk_elem_obj obj_attr
         set obj_attr(1) $block_element::($blk_elem_obj,elem_mom_variable)
         set obj_attr(3) $block_element::($blk_elem_obj,elem_desc)
         block_element::setvalue $blk_elem_obj obj_attr
         block_element::DefaultValue $blk_elem_obj obj_attr
        }
        block::readvalue $new_blk_obj obj_attr
        set obj_attr(2) $block::($new_blk_obj,elem_addr_list)
        set obj_attr(1) [llength $obj_attr(2)]
        block::setvalue $new_blk_obj obj_attr
        block::DefaultValue $new_blk_obj obj_attr
        event_element::readvalue $new_evt_elem_obj obj_attr
        set obj_attr(1) $new_blk_obj
        event_element::setvalue $new_evt_elem_obj obj_attr
        event_element::DefaultValue $new_evt_elem_obj obj_attr
        lappend act_cyc_evt_elem $new_evt_elem_obj
        foreach cyc_evt_elem $event::($cycle_evt_obj,evt_elem_list) \
        {
         lappend act_cyc_evt_elem $cyc_evt_elem
        }
       } else \
       {
        foreach cyc_evt_elem $event::($cycle_evt_obj,evt_elem_list) \
        {
         set cyc_evt_blk $event_element::($cyc_evt_elem,block_obj)
         set ret_code [PB_evt_CheckCycleRefWord cyc_evt_blk 1]
         if {$ret_code == 1}\
         {
          set cyc_elem_addr_list \
          $block::($cyc_evt_blk,elem_addr_list)
          set dup_addr 1
          UI_PB_tpth_AddComBlkElemToBlk com_anc_blk \
          cyc_elem_addr_list current_evt_name dup_addr
          set block::($cyc_evt_blk,elem_addr_list) \
          $cyc_elem_addr_list
          unset cyc_elem_addr_list
         }
         lappend act_cyc_evt_elem $cyc_evt_elem
        }
       }
      }
     }
     set event::($cycle_evt_obj,evt_elem_list) $act_cyc_evt_elem
     event::RestoreValue $cycle_evt_obj
     if [info exists event::($cycle_evt_obj,custom_def)] {
      event::readvalue $cycle_evt_obj evt_attr
      set evt_attr(1) [llength $act_cyc_evt_elem]
      event::setvalue $cycle_evt_obj evt_attr
      event::DefaultValue $cycle_evt_obj evt_attr
      unset event::($cycle_evt_obj,custom_def)
      } else {
      UI_PB_tpth_UpdateDefsOfCycleEvent event_obj cycle_evt_obj
     }
    } 
   }
   } elseif { [lsearch $cycle_shared_evts $current_evt_name] != -1 } \
  {
   set index [lsearch $cycle_shared_evts $current_evt_name]
   set cycle_shared_evts [lreplace $cycle_shared_evts $index $index]
   lappend cycle_shared_evts $cycle_com_evt
   UI_PB_tpth_GetCycleRefBlkElem event_obj cur_evt_ref_elem
   if $cur_evt_ref_elem {
    foreach cycle_event_name $cycle_shared_evts \
    {
     PB_com_RetObjFrmName cycle_event_name evt_obj_list cycle_evt_obj
     UI_PB_tpth_GetCycleRefBlkElem cycle_evt_obj cycle_evt_ref_elem
     set block_element::($cycle_evt_ref_elem,elem_opt_nows_var) \
     $block_element::($cur_evt_ref_elem,elem_opt_nows_var)
     set block_element::($cycle_evt_ref_elem,force) \
     $block_element::($cur_evt_ref_elem,force)
    }
   }
   if [UI_PB_tpth_IsCycleCustom $current_evt_name] {
    event::readvalue $event_obj evt_attr
    set event::($event_obj,custom_def) [array get evt_attr]
   }
  }
 }

#=======================================================================
proc UI_PB_tpth_GetCycleRefBlkElem { EVENT_OBJ CYCLE_REF_ELEM } {
  upvar $EVENT_OBJ event_obj
  upvar $CYCLE_REF_ELEM cycle_ref_elem
  set cycle_ref_elem 0
  foreach cyc_evt_elem $event::($event_obj,evt_elem_list)\
  {
   set cyc_evt_blk $event_element::($cyc_evt_elem,block_obj)
   set ret_code [PB_evt_CheckCycleRefWord cyc_evt_blk 1]
   if {$ret_code == 1}\
   {
    foreach blk_elem $block::($cyc_evt_blk,elem_addr_list) \
    {
     set elem_add_obj $block_element::($blk_elem,elem_add_obj)
     set add_name $address::($elem_add_obj,add_name)
     if { $add_name == "G_motion" } \
     {
      set cycle_ref_elem $blk_elem
      break
     }
    }
   }
   if { $cycle_ref_elem } { break }
  }
 }

#=======================================================================
proc UI_PB_tpth_DeleteAndRecreateIcons { PAGE_OBJ EVENT_OBJ } {
  upvar $PAGE_OBJ page_obj
  upvar $EVENT_OBJ event_obj
  global paOption
  set bot_canvas $Page::($page_obj,bot_canvas)
  if {[string compare $event::($event_obj,evt_elem_list) ""] != 0} \
  {
   foreach elem_obj $event::($event_obj,evt_elem_list)\
   {
    set blk_obj $event_element::($elem_obj,block_obj)
    set blk_owner $block::($blk_obj,blk_owner)
    foreach blk_elem_obj $block::($blk_obj,active_blk_elem_list) \
    {
     $bot_canvas delete $block_element::($blk_elem_obj,icon_id)
     set blk_elem_add_name $block_element::($blk_elem_obj,elem_add_obj)
     set blk_elem_addr $block_element::($blk_elem_obj,elem_add_obj)
     set blk_elem_mom_var $block_element::($blk_elem_obj,elem_mom_variable)
     UI_PB_com_RetImageAppdText blk_elem_addr blk_elem_mom_var \
     img_name blk_elem_text
     set blk_elem_img  [UI_PB_blk_CreateIcon $bot_canvas $img_name \
     $blk_elem_text]
     append opt_img pb_ $block_element::($blk_elem_obj,elem_opt_nows_var)
     if { $block_element::($blk_elem_obj,force) } \
     {
      append opt_img _f
     }
     set name_addr [tix getimage $opt_img]
     unset opt_img
     $blk_elem_img add image -image $name_addr
     set blk_elem_owner $block_element::($blk_elem_obj,owner)
     if { $blk_elem_owner != "$blk_owner" || $blk_owner == "post" } \
     {
      set icon_id [$bot_canvas create image \
      $block_element::($blk_elem_obj,xc) \
      $block_element::($blk_elem_obj,yc) \
      -image $blk_elem_img -tag nonmovable]
      set im [$bot_canvas itemconfigure $icon_id -image]
      [lindex $im end] configure -relief flat
     } else \
     {
      set icon_id [$bot_canvas create image \
      $block_element::($blk_elem_obj,xc) \
      $block_element::($blk_elem_obj,yc) \
      -image $blk_elem_img -tag movable]
     }
     if {[string compare $blk_elem_add_name "Text"] == 0} \
     {
      set im [$bot_canvas itemconfigure $icon_id -image]
      [lindex $im end] configure -bg $paOption(text)
     }
     set block_element::($blk_elem_obj,icon_id) $icon_id
    }
   }
  }
 }

#=======================================================================
proc UI_PB_tpth_CreateDividers { PAGE_OBJ BLOCK_OBJ } {
  upvar $PAGE_OBJ page_obj
  upvar $BLOCK_OBJ block_obj
  global paOption
  set bot_canvas $Page::($page_obj,bot_canvas)
  set h_cell $Page::($page_obj,h_cell)       
  set w_cell $Page::($page_obj,w_cell)       
  set w_divi $Page::($page_obj,w_divi)       
  set x_orig $block::($block_obj,x_orig)  
  set y_orig $block::($block_obj,y_orig)
  set main_cell_color $paOption(can_bg)
  if { $block::($block_obj,active_blk_elem_list) != "" } \
  {
   set n_comp [llength $block::($block_obj,active_blk_elem_list)]
  } else \
  {
   set n_comp 0
  }
  if { $block::($block_obj,sep_id) != "" } \
  {
   $bot_canvas delete [lindex $block::($block_obj,sep_id) 0]
   $bot_canvas delete [lindex $block::($block_obj,sep_id) 1]
   set block::($block_obj,sep_id) ""
  }
  set x0 [expr $x_orig + $w_divi]
  set y0 $y_orig
  set x1 [expr $x0 + [expr [expr $w_divi + $w_cell] * $n_comp] + \
  $w_divi]
  set y1 [expr $y_orig + $w_divi]
  lappend div_id [$bot_canvas create rect $x0 $y0 $x1 $y1 \
  -fill $main_cell_color -outline $main_cell_color \
  -tag stationary]
  set y0 [expr $y_orig + $h_cell + $w_divi]
  set y1 [expr $y0 + $w_divi]
  lappend div_id [$bot_canvas create rect $x0 $y0 $x1 $y1 \
  -fill $main_cell_color -outline $main_cell_color \
  -tag stationary]
  set block::($block_obj,sep_id) $div_id
 }

#=======================================================================
proc UI_PB_tpth_CreateBlkElements { PAGE_OBJ EVENT_OBJ } {
  upvar $PAGE_OBJ page_obj
  upvar $EVENT_OBJ event_obj
  set event_name $event::($event_obj,event_name)
  foreach event_elem $event::($event_obj,evt_elem_list) \
  {
   set block_obj $event_element::($event_elem,block_obj)
   UI_PB_blk_GetBlkAttrSort page_obj block_obj
   UI_PB_blk_CreateBlockImages page_obj block_obj
   set block::($block_obj,x_orig) $Page::($page_obj,x_orig)
   set block::($block_obj,y_orig) $Page::($page_obj,y_orig)
   UI_PB_tpth_CreateDividers page_obj block_obj
   set active_blk_elem_obj 0
   UI_PB_blk_CreateBlockCells page_obj block_obj active_blk_elem_obj \
   event_name
   set Page::($page_obj,y_orig) [expr \
   $Page::($page_obj,y_orig) + $Page::($page_obj,blk_blkdist)]
  }
  UI_PB_tpth_IconBindProcs page_obj event_obj
 }

#=======================================================================
proc UI_PB_tpth_IconBindProcs { PAGE_OBJ EVENT_OBJ } {
  upvar $PAGE_OBJ page_obj
  upvar $EVENT_OBJ event_obj
  set bot_canvas $Page::($page_obj,bot_canvas)
  $bot_canvas bind movable <Enter>              "UI_PB_tpth_BlkFocusOn            $page_obj $event_obj %x %y"
  $bot_canvas bind movable <Leave>              "UI_PB_tpth_BlkFocusOff           $page_obj"
  $bot_canvas bind movable <1>                  "UI_PB_tpth_StartDragBlk          $page_obj $event_obj %x %y"
  $bot_canvas bind movable <B1-Motion>          "UI_PB_tpth_DragBlk               $page_obj $event_obj %x %y"
  $bot_canvas bind movable <ButtonRelease-1>    "UI_PB_tpth_EndDragBlk            $page_obj $event_obj"
  $bot_canvas bind movable <3>                  "UI_PB_tpth_BindRightButton       $page_obj $event_obj %x %y"
  $bot_canvas bind nonmovable <Enter>           "UI_PB_tpth_BlkFocusOn            $page_obj $event_obj %x %y"
  $bot_canvas bind nonmovable <Leave>           "UI_PB_tpth_BlkFocusOff           $page_obj"
  $bot_canvas bind nonmovable <1>               "UI_PB_tpth_StartDragBlk          $page_obj $event_obj %x %y"
  $bot_canvas bind nonmovable <ButtonRelease-1> "__tpth_EndDragNonMovableAddr     $page_obj $event_obj"
  $bot_canvas bind nonmovable <3>               "UI_PB_tpth_NonMovableRightButton $page_obj $event_obj %x %y"
  bind $bot_canvas <ButtonRelease-1>            "+UI_PB_blk_popup_close_cb $page_obj"
  bind $bot_canvas <3>                          "+UI_PB_blk_popup_close_cb $page_obj"
 }

#=======================================================================
proc UI_PB_tpth_IconUnBindProcs { PAGE_OBJ } {
  upvar $PAGE_OBJ page_obj
  set bot_canvas $Page::($page_obj,bot_canvas)
  $bot_canvas bind movable <Enter> ""
  $bot_canvas bind movable <Leave> ""
  $bot_canvas bind movable <1>   ""
  $bot_canvas bind movable <B1-Motion>  ""
  $bot_canvas bind movable <ButtonRelease-1> ""
  $bot_canvas bind movable <3>        ""
  $bot_canvas bind nonmovable <Enter> ""
  $bot_canvas bind nonmovable <Leave> ""
  $bot_canvas bind nonmovable <1>     ""
  $bot_canvas bind nonmovable <3>     ""
 }

#=======================================================================
proc UI_PB_tpth_NonMovableRightButton { page_obj event_obj x y } {
  set bot_canvas $Page::($page_obj,bot_canvas)
  UI_PB_tpth_StartDragBlk          $page_obj $event_obj $x $y
  __tpth_EndDragNonMovableAddr     $page_obj $event_obj
  UI_PB_tpth_BlkFocusOn $page_obj $event_obj $x $y
  set active_blk_elem $Page::($page_obj,in_focus_elem)
  if { $active_blk_elem <= 0 } { return }
  set act_evt_elem $Page::($page_obj,in_focus_evt_elem)
  set act_blk_obj $event_element::($act_evt_elem,block_obj)
  UI_PB_blk_SelectElement $page_obj $active_blk_elem
  set x [$bot_canvas canvasx $x]
  set y [$bot_canvas canvasy $y]
  UI_PB_blk_NonMovableElemPopup page_obj event_obj act_blk_obj \
  active_blk_elem $x $y
 }

#=======================================================================
proc UI_PB_tpth_BindRightButton { page_obj event_obj x y } {
  set bot_canvas $Page::($page_obj,bot_canvas)
  UI_PB_tpth_StartDragBlk          $page_obj $event_obj $x $y
  UI_PB_tpth_EndDragBlk            $page_obj $event_obj
  UI_PB_tpth_BlkFocusOn $page_obj $event_obj $x $y
  set act_blk_elem $Page::($page_obj,in_focus_elem)
  if { $act_blk_elem <= 0 } { return }
  set act_evt_elem $Page::($page_obj,in_focus_evt_elem)
  set act_blk_obj $event_element::($act_evt_elem,block_obj)
  UI_PB_blk_SelectElement $page_obj $act_blk_elem
  set x [$bot_canvas canvasx $x]
  set y [$bot_canvas canvasy $y]
  UI_PB_blk_BlockPopupMenu page_obj act_blk_obj act_blk_elem $x $y
 }

#=======================================================================
proc UI_PB_tpth_BlkFocusOn { page_obj event_obj x y} {
  global gPB
  if { [info exists gPB(DisableEnterCB)] && $gPB(DisableEnterCB) } { return }
  global gPB_help_tips
  set bot_canvas $Page::($page_obj,bot_canvas)
  set x [$bot_canvas canvasx $x]
  set y [$bot_canvas canvasy $y]
  UI_PB_tpth_GetEvtElemAndBlkElem event_obj act_blk_elem act_evt_elem $x $y
  set Page::($page_obj,in_focus_elem) $act_blk_elem
  set Page::($page_obj,in_focus_evt_elem) $act_evt_elem
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
  if {$Page::($page_obj,in_focus_elem) != \
  $Page::($page_obj,out_focus_elem)} \
  {
   if { $Page::($page_obj,out_focus_elem) } \
   {
    set out_focus_elem $Page::($page_obj,out_focus_elem)
    $bot_canvas itemconfigure $block_element::($out_focus_elem,rect) \
    -fill $Page::($page_obj,x_color)
   }
   if { $Page::($page_obj,in_focus_elem) } \
   {
    set cell_highlight_color navyBlue
    set in_focus_elem $Page::($page_obj,in_focus_elem)
    set Page::($page_obj,x_color) [lindex [$bot_canvas itemconfigure \
    $block_element::($in_focus_elem,rect) -fill] end]
    $bot_canvas itemconfigure $block_element::($in_focus_elem,rect) \
    -fill $cell_highlight_color
    set Page::($page_obj,out_focus_elem) $Page::($page_obj,in_focus_elem)
    if {$gPB_help_tips(state)} \
    {
     global tpth_item_focus_on
     if {![info exists tpth_item_focus_on]} \
     {
      set tpth_item_focus_on 0
     }
     if {$tpth_item_focus_on == 0} \
     {
      UI_PB_blk_CreateBalloon page_obj
      set tpth_item_focus_on 1
     }
    }
   }
  }
 }

#=======================================================================
proc UI_PB_tpth_GetEvtElemAndBlkElem { EVENT_OBJ ACTIVE_BLK_ELEM_OBJ \
  ACTIVE_EVENT_ELEM x y } {
  upvar $EVENT_OBJ event_obj
  upvar $ACTIVE_BLK_ELEM_OBJ active_blk_elem_obj
  upvar $ACTIVE_EVENT_ELEM active_event_elem
  set event_elems $event::($event_obj,evt_elem_list)
  set active_blk_elem_obj 0
  set active_event_elem 0
  set break_flag 0
  foreach elem_obj $event_elems \
  {
   set block_obj $event_element::($elem_obj,block_obj)
   set active_blk_elem_list $block::($block_obj,active_blk_elem_list)
   foreach blk_elem_obj $active_blk_elem_list \
   {
    if {$x >= $block_element::($blk_elem_obj,rect_corn_x0) && \
     $x < $block_element::($blk_elem_obj,rect_corn_x1) && \
     $y >= $block_element::($blk_elem_obj,rect_corn_y0) && \
    $y < $block_element::($blk_elem_obj,rect_corn_y1)} \
    {
     set active_blk_elem_obj $blk_elem_obj
     set active_event_elem $elem_obj
     set break_flag 1
     break;
    }
   }
   if {$break_flag} { break }
  }
 }

#=======================================================================
proc UI_PB_tpth_BlkFocusOff { page_obj } {
  set bot_canvas $Page::($page_obj,bot_canvas)
  if { $Page::($page_obj,out_focus_elem) } \
  {
   set out_focus_elem $Page::($page_obj,out_focus_elem)
   $bot_canvas itemconfigure $block_element::($out_focus_elem,rect) \
   -fill $Page::($page_obj,x_color)
  }
  set Page::($page_obj,in_focus_elem) 0
  set Page::($page_obj,out_focus_elem) 0
  if { $Page::($page_obj,being_dragged) == 0 } \
  {
   $bot_canvas config -cursor ""
  }
  global gPB_help_tips
  if {$gPB_help_tips(state)} \
  {
   if [info exists gPB_help_tips($bot_canvas)] {
    unset gPB_help_tips($bot_canvas)
   }
   PB_cancel_balloon
   global tpth_item_focus_on
   set tpth_item_focus_on 0
  }
 }

#=======================================================================
proc UI_PB_tpth_StartDragBlk { page_obj event_obj x y } {
  global paOption
  set Page::($page_obj,being_dragged) 1
  set bot_canvas $Page::($page_obj,bot_canvas)
  $bot_canvas bind movable <3>  ""
  $bot_canvas bind nonmovable <3>  ""
  __tpth_DeselectBlkElem $page_obj
  set panel_hi $Page::($page_obj,panel_hi)
  set dx 1
  set dy [expr $panel_hi + 2]
  set xx [$bot_canvas canvasx $x]
  set yy [$bot_canvas canvasy $y]
  UI_PB_tpth_GetEvtElemAndBlkElem event_obj focus_blk_elem \
  focus_evt_elem $xx $yy
  if { !$focus_blk_elem } {
   set focus_blk_elem $Page::($page_obj,active_blk_elem)
   } else {
   set Page::($page_obj,active_blk_elem) $focus_blk_elem
  }
  set c $bot_canvas
  if {$Page::($page_obj,active_blk_elem)} {
   set act_blk_elem_obj $Page::($page_obj,active_blk_elem)
   set icon_id $block_element::($act_blk_elem_obj,icon_id)
   $c raise $icon_id
   set im [$c itemconfigure $icon_id -image]
   set cur_img_tag [lindex [lindex [$c itemconfigure $icon_id -tags] end] 0]
   [lindex $im end] configure -relief sunken -bg $paOption(sunken_bg)
  }
  if 0 {
   if [llength [$c itemconfigure current]] {
    $c raise current
    set im [$c itemconfigure current -image]
    set cur_img_tag [lindex [lindex [$c itemconfigure current -tags] end] 0]
    [lindex $im end] configure -relief sunken -bg $paOption(sunken_bg)
    } else {
    set icon_id $block_element::($act_blk_elem_obj,icon_id)
    $c raise $icon_id
    set cur_img_tag [lindex [lindex [$c itemconfigure $icon_id -tags] end] 0]
   }
  }
  if { [string compare $cur_img_tag "movable"] == 0 } \
  {
   set origin_xb [$bot_canvas canvasx $x]
   set origin_yb [$bot_canvas canvasy $y]
   set Page::($page_obj,last_xb)   $origin_xb
   set Page::($page_obj,last_yb)   $origin_yb
   set blk_elem_addr $block_element::($focus_blk_elem,elem_add_obj)
   set blk_elem_mom_var $block_element::($focus_blk_elem,elem_mom_variable)
   UI_PB_com_RetImageAppdText blk_elem_addr blk_elem_mom_var \
   image_name blk_elem_text
   set Page::($page_obj,source_blk_elem_obj) $focus_blk_elem
   set Page::($page_obj,source_evt_elem_obj) $focus_evt_elem
   set origin_xt [expr [expr $block_element::($focus_blk_elem,rect_corn_x0) \
   + $block_element::($focus_blk_elem,rect_corn_x1)] / 2]
   set origin_yt [expr [expr $block_element::($focus_blk_elem,rect_corn_y0) \
   + $block_element::($focus_blk_elem,rect_corn_y1)] / 2]
   set diff_x [expr $xx - $origin_xt]
   set diff_y [expr $yy - $origin_yt]
   set top_canvas $Page::($page_obj,top_canvas)
   set img_addr [UI_PB_blk_CreateIcon $top_canvas $image_name $blk_elem_text]
   append opt_img pb_ $block_element::($focus_blk_elem,elem_opt_nows_var)
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
   [lindex $im end] configure -relief sunken -bg $paOption(sunken_bg)
   UI_PB_com_ChangeCursor $bot_canvas
  }
 }

#=======================================================================
proc __tpth_DeselectBlkElem { page_obj } {
  global paOption
  if {$Page::($page_obj,active_blk_elem)} \
  {
   set bot_canvas $Page::($page_obj,bot_canvas)
   set act_blk_elem_obj $Page::($page_obj,active_blk_elem)
   if { $block_element::($act_blk_elem_obj,elem_add_obj) == "Command" || \
   $block_element::($act_blk_elem_obj,elem_add_obj) == "Comment" } \
   {
    set act_blk_add_name $block_element::($act_blk_elem_obj,elem_add_obj)
   } else \
   {
    set act_blk_elem_add_obj \
    $block_element::($act_blk_elem_obj,elem_add_obj)
    set act_blk_add_name $address::($act_blk_elem_add_obj,add_name)
   }
   set icon_id $block_element::($act_blk_elem_obj,icon_id)
   set im [$bot_canvas itemconfigure $icon_id -image]
   set icon_tag [lindex [$bot_canvas itemconfigure $icon_id -tags] end]
   if { [string compare $icon_tag "nonmovable"] == 0 } \
   {
    [lindex $im end] configure -relief flat -bg $paOption(raised_bg)
   } else \
   {
    [lindex $im end] configure -relief raised -bg $paOption(raised_bg)
   }
   if { [string compare $act_blk_add_name "Text"] == 0 } \
   {
    [lindex $im end] configure -bg $paOption(text)
   }
  }
 }

#=======================================================================
proc UI_PB_tpth_DragBlk { page_obj event_obj x y } {
  if { $Page::($page_obj,being_dragged) == 0 } { return }
  set bot_canvas $Page::($page_obj,bot_canvas)
  UI_PB_com_ChangeCursor $bot_canvas
  set panel_hi $Page::($page_obj,panel_hi)
  set xc [$bot_canvas canvasx $x]
  set yc [$bot_canvas canvasy $y]
  UI_PB_ScrollCanvasWin $page_obj $xc $yc
  set xc [$bot_canvas canvasx $x]
  set yc [$bot_canvas canvasy $y]
  set c $bot_canvas
  if 0 {
   if [llength [$c itemconfigure current]] {
    $c move current [expr $xc - $Page::($page_obj,last_xb)] \
    [expr $yc - $Page::($page_obj,last_yb)]
    } else {
    set act_blk_elem $Page::($page_obj,active_blk_elem)
    set icon_id $block_element::($act_blk_elem,icon_id)
    $c move $icon_id [expr $xc - $Page::($page_obj,last_xb)] \
    [expr $yc - $Page::($page_obj,last_yb)]
   }
  }
  set act_blk_elem $Page::($page_obj,active_blk_elem)
  set icon_id $block_element::($act_blk_elem,icon_id)
  $c move $icon_id [expr $xc - $Page::($page_obj,last_xb)] \
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
  set focus_blk_elem $Page::($page_obj,source_blk_elem_obj)
  if { $block_element::($focus_blk_elem,elem_add_obj) == "Command" || \
  $block_element::($focus_blk_elem,elem_add_obj) == "Comment" } \
  {
   set sel_addr_name $block_element::($focus_blk_elem,elem_add_obj)
  } else \
  {
   set sel_addr_obj $block_element::($focus_blk_elem,elem_add_obj)
   set sel_addr_name $address::($sel_addr_obj,add_name)
  }
  UI_PB_tpth_HighlightSeperators $page_obj $event_obj $sel_addr_name \
  $xc $yc
 }

#=======================================================================
proc UI_PB_tpth_EndDragBlk { page_obj event_obj } {
  global paOption
  set Page::($page_obj,being_dragged) 0
  set bot_canvas $Page::($page_obj,bot_canvas)
  UI_PB_tpth_UnHighLightSep page_obj
  if {$Page::($page_obj,trash_flag)} \
  {
   UI_PB_tpth_PutBlockElemTrash page_obj event_obj
   [lindex $Page::($page_obj,trash) 0] configure \
   -bg $paOption(app_butt_bg)
   set Page::($page_obj,in_focus_elem) 0
   set Page::($page_obj,out_focus_elem) 0
   } elseif {$Page::($page_obj,add_blk) != 0} \
  {
   UI_PB_tpth_SwapBlockElements page_obj event_obj
   set Page::($page_obj,in_focus_elem) 0
   set Page::($page_obj,out_focus_elem) 0
  } else \
  {
   set source_blk_elem_obj $Page::($page_obj,source_blk_elem_obj)
   UI_PB_blk_ReturnAddr page_obj source_blk_elem_obj
  }
  $Page::($page_obj,top_canvas) delete $Page::($page_obj,icon_top)
  $Page::($page_obj,top_canvas) delete connect_line
  $bot_canvas config -cursor ""
  set last_xb $Page::($page_obj,last_xb)
  set last_yb $Page::($page_obj,last_yb)
  set Page::($page_obj,last_xb) 0
  set Page::($page_obj,last_yb) 0
  set Page::($page_obj,source_blk_elem_obj) 0
  set Page::($page_obj,source_evt_elem_obj) 0
  set Page::($page_obj,add_blk) 0
  set Page::($page_obj,add_flag) 0
  set Page::($page_obj,trash_flag) 0
  $bot_canvas bind movable <3>  \
  "UI_PB_tpth_BindRightButton $page_obj $event_obj %x %y"
  $bot_canvas bind nonmovable <3> \
  "UI_PB_tpth_NonMovableRightButton $page_obj $event_obj %x %y"
 }

#=======================================================================
proc __tpth_EndDragNonMovableAddr { page_obj event_obj } {
  global paOption
  set Page::($page_obj,being_dragged) 0
  set bot_canvas $Page::($page_obj,bot_canvas)
  $bot_canvas bind nonmovable <3>  \
  "UI_PB_tpth_NonMovableRightButton $page_obj $event_obj %x %y"
  $bot_canvas bind movable <3>  \
  "UI_PB_tpth_BindRightButton $page_obj $event_obj %x %y"
 }

#=======================================================================
proc UI_PB_tpth_SwapBlockElements {PAGE_OBJ EVENT_OBJ} {
  upvar $PAGE_OBJ page_obj
  upvar $EVENT_OBJ event_obj
  set source_blk_elem_obj $Page::($page_obj,source_blk_elem_obj)
  set source_evt_elem_obj $Page::($page_obj,source_evt_elem_obj)
  set source_blk_obj $event_element::($source_evt_elem_obj,block_obj)
  set add_to_evt_elem $Page::($page_obj,active_evt_elem_obj)
  set add_to_blk_obj $event_element::($add_to_evt_elem,block_obj)
  if {[string compare $Page::($page_obj,add_blk) "row"] == 0} \
  {
   set blk_exists_flag [UI_PB_com_CheckElemBlkTemplate add_to_blk_obj \
   source_blk_elem_obj]
   if {$blk_exists_flag} \
   {
    set source_blk_elem_obj $Page::($page_obj,source_blk_elem_obj)
    UI_PB_blk_ReturnAddr page_obj source_blk_elem_obj
    return
   }
  }
  if { $block::($source_blk_obj,blk_type) == "normal" || \
  $block::($source_blk_obj,blk_type) == "comment" } \
  {
   block::readvalue $add_to_blk_obj add_to_blk_obj_attr
   PB_int_CreateBlkElemFromElemObj source_blk_elem_obj new_blk_elem_obj \
   add_to_blk_obj_attr
   unset add_to_blk_obj_attr
  } else \
  {
   set cmd_elem $block_element::($source_blk_elem_obj,elem_mom_variable)
   if { [string match "*MOM_*" $cmd_elem] } \
   {
    set cmd_name $cmd_elem
    set cmd_obj 0
   } else \
   {
    set cmd_name $command::($cmd_elem,name)
    set cmd_obj $cmd_elem
   }
   PB_blk_CreateCmdBlkElem cmd_name cmd_obj new_blk_elem_obj
  }
  UI_PB_tpth_PutBlockElemTrash page_obj event_obj
  set source_blk_elem_obj $new_blk_elem_obj
  set block_element::($new_blk_elem_obj,owner) \
  $event::($event_obj,event_name)
  switch $Page::($page_obj,add_blk) \
  {
   "row" \
   {
    UI_PB_tpth_AddBlkElemRow page_obj add_to_evt_elem \
    source_blk_elem_obj blk_elem_flag
   }
   "top" \
   {
    UI_PB_tpth_AddBlkElemTopOrBottom page_obj event_obj add_to_evt_elem \
    source_blk_elem_obj
   }
   "bottom" \
   {
    UI_PB_tpth_AddBlkElemTopOrBottom page_obj event_obj add_to_evt_elem \
    source_blk_elem_obj
   }
  }
  set Page::($page_obj,add_blk) 0
  set Page::($page_obj,add_flag) 0
 }

#=======================================================================
proc UI_PB_tpth_PutBlockElemTrash { PAGE_OBJ EVENT_OBJ } {
  upvar $PAGE_OBJ page_obj
  upvar $EVENT_OBJ event_obj
  global paOption
  set bot_canvas $Page::($page_obj,bot_canvas)
  if {$Page::($page_obj,active_blk_elem)} \
  {
   set act_blk_elem_obj $Page::($page_obj,active_blk_elem)
   set icon_id $block_element::($act_blk_elem_obj,icon_id)
   set im [$bot_canvas itemconfigure $icon_id -image]
   set icon_tag [lindex [$bot_canvas itemconfigure $icon_id -tags] end]
   if { $icon_tag == "nonmovable" } \
   {
    [lindex $im end] configure -relief flat -bg $paOption(raised_bg)
   } else \
   {
    [lindex $im end] configure -relief raised -bg $paOption(raised_bg)
   }
   set Page::($page_obj,active_blk_elem) 0
  }
  UI_PB_tpth_BlkFocusOff $page_obj
  set source_blk_elem_obj $Page::($page_obj,source_blk_elem_obj)
  set evt_elem_obj $Page::($page_obj,source_evt_elem_obj)
  set block_obj $event_element::($evt_elem_obj,block_obj)
  set no_blk_elems [llength $block::($block_obj,active_blk_elem_list)]
  set source_cell_num [lsearch $block::($block_obj,active_blk_elem_list) \
  $source_blk_elem_obj]
  set addr_obj $block_element::($source_blk_elem_obj,elem_add_obj)
  address::DeleteFromBlkElemList $addr_obj source_blk_elem_obj
  set no_event_elems [llength $event::($event_obj,evt_elem_list)]
  set elem_index [lsearch $event::($event_obj,evt_elem_list) evt_elem_obj]
  if { $no_blk_elems > 1 } \
  {
   UI_PB_tpth_DeleteElemOfRow page_obj event_obj evt_elem_obj source_cell_num
   } elseif  { $no_blk_elems == 1 || \
  $elem_index == [expr $no_event_elems - 1]} \
  {
   UI_PB_tpth_DeleteARow page_obj event_obj evt_elem_obj
  }
 }

#=======================================================================
proc UI_PB_tpth_DeleteARow { PAGE_OBJ EVENT_OBJ EVT_ELEM_OBJ } {
  upvar $PAGE_OBJ page_obj
  upvar $EVENT_OBJ event_obj
  upvar $EVT_ELEM_OBJ evt_elem_obj
  global paOption
  set event_name $event::($event_obj,event_name)
  set elem_index [lsearch $event::($event_obj,evt_elem_list) $evt_elem_obj]
  set bot_canvas $Page::($page_obj,bot_canvas)
  set block_obj $event_element::($evt_elem_obj,block_obj)
  UI_PB_blk_DeleteCellsIcons page_obj block_obj
  if { $block::($block_obj,sep_id) != "" } \
  {
   $bot_canvas delete [lindex $block::($block_obj,sep_id) 0]
   $bot_canvas delete [lindex $block::($block_obj,sep_id) 1]
   set block::($block_obj,sep_id) ""
  }
  set x_orig $block::($block_obj,x_orig)
  set y_orig $block::($block_obj,y_orig)
  set no_elems [llength $event::($event_obj,evt_elem_list)]
  set event_elems $event::($event_obj,evt_elem_list)
  unset event::($event_obj,evt_elem_list)
  set event_elems [lreplace $event_elems $elem_index $elem_index]
  set event::($event_obj,evt_elem_list) $event_elems
  UI_PB_evt_DeleteEvtElem event_obj evt_elem_obj
  PB_int_RemoveBlkObjFrmList block_obj
  if { $elem_index == 0 && [expr $elem_index + 1] == $no_elems } \
  {
   UI_PB_tpth_CreateElemObjects page_obj event_obj
  } else \
  {
   incr no_elems -1
  }
  for {set count $elem_index} {$count < $no_elems} {incr count} \
  {
   set temp_elem_obj [lindex $event::($event_obj,evt_elem_list) $count]
   set temp_blk_obj $event_element::($temp_elem_obj,block_obj)
   UI_PB_blk_DeleteCellsIcons page_obj temp_blk_obj
   set Page::($page_obj,x_orig) $x_orig
   set Page::($page_obj,y_orig) $y_orig
   set block::($temp_blk_obj,x_orig) $Page::($page_obj,x_orig)
   set block::($temp_blk_obj,y_orig) $Page::($page_obj,y_orig)
   UI_PB_tpth_CreateDividers page_obj temp_blk_obj
   UI_PB_blk_CreateBlockImages page_obj temp_blk_obj
   set active_blk_elem_obj 0
   UI_PB_blk_CreateBlockCells page_obj temp_blk_obj active_blk_elem_obj \
   event_name
   set y_orig [expr $y_orig + $Page::($page_obj,blk_blkdist)]
  }
  if { $elem_index } \
  {
   set active_elem_obj \
   [lindex $event::($event_obj,evt_elem_list) [expr $elem_index - 1]]
   set active_blk_obj $event_element::($active_elem_obj,block_obj)
   set active_blk_elem_obj [lindex \
   $block::($active_blk_obj,active_blk_elem_list) end]
   set im [$Page::($page_obj,bot_canvas) itemconfigure \
   $block_element::($active_blk_elem_obj,icon_id) -image]
   [lindex $im end] configure -relief sunken -bg $paOption(sunken_bg)
   set Page::($page_obj,active_blk_elem) $active_blk_elem_obj
  } else \
  {
   set Page::($page_obj,active_blk_elem) 0
  }
 }

#=======================================================================
proc UI_PB_tpth_DeleteElemOfRow { PAGE_OBJ EVENT_OBJ EVT_ELEM_OBJ \
  SOURCE_CELL_NUM} {
  upvar $PAGE_OBJ page_obj
  upvar $EVENT_OBJ event_obj
  upvar $EVT_ELEM_OBJ evt_elem_obj
  upvar $SOURCE_CELL_NUM source_cell_num
  global paOption
  set bot_canvas $Page::($page_obj,bot_canvas)
  set event_name $event::($event_obj,event_name)
  set block_obj $event_element::($evt_elem_obj,block_obj)
  set no_blk_elems [llength $block::($block_obj,active_blk_elem_list)]
  set elem_index [lsearch $event::($event_obj,evt_elem_list) $evt_elem_obj]
  set no_event_elemss [llength $event::($event_obj,evt_elem_list)]
  UI_PB_blk_DeleteCellsIcons page_obj block_obj
  set source_elem_obj [lindex $block::($block_obj,active_blk_elem_list) \
  $source_cell_num]
  set block::($block_obj,active_blk_elem_list) \
  [lreplace $block::($block_obj,active_blk_elem_list) \
  $source_cell_num $source_cell_num]
  UI_PB_blk_DeleteBlkElemObj block_obj source_elem_obj
  set Page::($page_obj,x_orig) $block::($block_obj,x_orig)
  set Page::($page_obj,y_orig) $block::($block_obj,y_orig)
  if {$no_blk_elems > 1} \
  {
   if {$source_cell_num > 0} \
   {
    set active_blk_elem_obj [lindex \
    $block::($block_obj,active_blk_elem_list) [expr $source_cell_num -1]]
    } elseif {$source_cell_num == 0} \
   {
    set active_blk_elem_obj [lindex \
    $block::($block_obj,active_blk_elem_list) $source_cell_num]
   }
   } elseif {$elem_index == [expr $no_event_elems - 1]} \
  {
   if { $block::($block_obj,sep_id) != "" } \
   {
    $bot_canvas delete [lindex $block::($block_obj,sep_id) 0]
    $bot_canvas delete [lindex $block::($block_obj,sep_id) 1]
    set block::($block_obj,sep_id) ""
   }
   set event::($event_obj,evt_elem_list) \
   [lreplace $event::($event_obj,evt_elem_list) $elem_index $elem_index]
   if {$elem_index > 0} \
   {
    set active_blk_obj [lindex  \
    $event::($event_obj,evt_elem_list) [expr $elem_index -1]]
    set active_blk_elem_obj \
    [lindex $block::($active_blk_obj,active_blk_elem_list) end]
   } else \
   {
    set no_elems [llength $event::($event_obj,evt_elem_list)]
    set new_block_obj [new block]
    set blk_obj_attr(0) "sample_$no_elems"
    set blk_obj_attr(1) ""
    set blk_obj_attr(2) ""
    set blk_obj_attr(3) "normal"
    block::setvalue $new_block_obj blk_obj_attr
    set new_evt_elem_obj [new event_element]
    set evt_elem_obj_attr(0) "sample_$no_elems"
    set evt_elem_obj_attr(1) $new_block_obj
    set evt_elem_obj_attr(2) "normal"
    event_element::setvalue $new_evt_elem_obj evt_elem_obj_attr
    lappend event::($event_obj,evt_elem_list) $new_evt_elem_obj
    set block::($new_block_obj,x_orig) $Page::($page_obj,x_orig)
    set block::($new_block_obj,y_orig) $Page::($page_obj,y_orig)
    set active_blk_elem_obj 0
    set Page::($page_obj,active_evt_elem_obj) $new_evt_elem_obj
    UI_PB_tpth_CreateDividers page_obj new_block_obj
    UI_PB_blk_CreateBlockImages page_obj new_block_obj
    UI_PB_blk_CreateBlockCells page_obj new_block_obj active_blk_elem_obj \
    event_name
    set Page::($page_obj,active_blk_elem) 0
    return
   }
  } else \
  {
   set active_blk_elem_obj 0
  }
  if {[llength $block::($block_obj,active_blk_elem_list)] > 0} \
  {
   UI_PB_blk_CreateBlockImages page_obj block_obj
   UI_PB_tpth_CreateDividers page_obj block_obj
   UI_PB_blk_CreateBlockCells page_obj block_obj active_blk_elem_obj \
   event_name
  } else \
  {
   set im [$bot_canvas itemconfigure \
   $block_element::($active_blk_elem_obj,icon_id) -image]
   [lindex $im end] configure -relief sunken -bg $paOption(sunken_bg)
   set Page::($page_obj,active_blk_elem) $active_blk_elem_obj
  }
 }

#=======================================================================
proc UI_PB_tpth_CreateElemObjects { PAGE_OBJ EVENT_OBJ } {
  upvar $PAGE_OBJ page_obj
  upvar $EVENT_OBJ event_obj
  if {[llength $event::($event_obj,evt_elem_list)] > 0} \
  {
   set test_blk_obj [lindex $event::($event_obj,evt_elem_list) 0]
   if [info exists event_element::($test_blk_obj,block_obj)] \
   {
    return
   }
  } else \
  {
   set temp_event_name [split $Page::($page_obj,event_name)]
   set event_name [join $temp_event_name _ ]
   set event_name [string tolower $event_name]
   set block_name $event_name
   set blk_elem_list ""
   set blk_owner $event::($event_obj,event_name)
   set blk_type "normal"
   PB_int_CreateNewBlock block_name blk_elem_list blk_owner \
   blk_obj blk_type
   PB_int_CreateNewEventElement blk_obj evt_elem
   set block::($blk_obj,active_blk_elem_list) ""
   set event::($event_obj,evt_elem_list) $evt_elem
   set Page::($page_obj,dummy_blk) 1
  }
 }

#=======================================================================
proc UI_PB_tpth_BringCommentPage { PAGE_OBJ EVENT_OBJ EVT_ELEM_OBJ \
  BLOCK_OBJ comment_mode } {
  upvar $PAGE_OBJ page_obj
  upvar $EVENT_OBJ event_obj
  upvar $EVT_ELEM_OBJ evt_elem_obj
  upvar $BLOCK_OBJ block_obj
  global gPB
  set canvas_frame $Page::($page_obj,canvas_frame)
  set win [toplevel $canvas_frame.comment]
  set toplevel_index [llength $gPB(toplevel_list)]
  set win_index [expr $toplevel_index + 1]
  set gPB(toplevel_disable_$win_index) 1
  set blk_elem_obj [lindex $block::($block_obj,active_blk_elem_list) 0]
  if { $comment_mode == "New" } \
  {
   set win_close_cb "UI_PB_cmd_tpthCommentCancel_CB $win $page_obj $event_obj \
   $evt_elem_obj $blk_elem_obj"
  } else \
  {
   set win_close_cb ""
  }
  set block_name $block::($block_obj,block_name)
  UI_PB_com_CreateTransientWindow $win \
  "$gPB(tool,oper_trans,title,Label)" "" \
  "" "UI_PB_blk_DisableBlkPageWidgets $page_obj" "$win_close_cb" \
  "UI_PB_blk_ActivateBlkPageWidgets $page_obj $win_index"
  UI_PB_cmd_CreateCommentDlgParam $win $page_obj $block_obj $blk_elem_obj
  set box [frame $win.box -relief flat]
  pack $box -side bottom -fill x
  set box1_frm [frame $box.box1]
  pack $box1_frm -side bottom -fill x -padx 3 -pady 3
  set label_list {"gPB(nav_button,cancel,Label)" \
   "gPB(nav_button,ok,Label)" \
  "gPB(nav_button,restore,Label)"}
  set cb_arr(gPB(nav_button,restore,Label)) \
  "UI_PB_cmd_CommentRestore_CB $block_obj"
  if { $comment_mode == "New" } \
  {
   set cb_arr(gPB(nav_button,cancel,Label)) \
   "UI_PB_cmd_tpthCommentCancel_CB $win $page_obj $event_obj \
   $evt_elem_obj $blk_elem_obj"
   set cb_arr(gPB(nav_button,ok,Label)) \
   "UI_PB_cmd_tpthCommentOk_CB $win $page_obj $evt_elem_obj \
   $blk_elem_obj"
   bind $win.top.ent <Return>  "UI_PB_cmd_tpthCommentOk_CB $win $page_obj \
   $evt_elem_obj $blk_elem_obj"
  } else \
  {
   set cb_arr(gPB(nav_button,cancel,Label)) "destroy $win"
   set cb_arr(gPB(nav_button,ok,Label)) \
   "UI_PB_cmd_tpthEditCommentOk_CB $win $page_obj $block_obj \
   $blk_elem_obj"
   bind $win.top.ent <Return>  "UI_PB_cmd_tpthEditCommentOk_CB $win \
   $page_obj $block_obj $blk_elem_obj"
  }
  UI_PB_com_CreateButtonBox $box1_frm label_list cb_arr
  UI_PB_com_PositionWindow $win
 }

#=======================================================================
proc UI_PB_tpth_BringCmdPage { PAGE_OBJ EVENT_OBJ EVT_ELEM_OBJ BLOCK_OBJ \
  cmd_mode } {
  upvar $PAGE_OBJ page_obj
  upvar $EVENT_OBJ event_obj
  upvar $EVT_ELEM_OBJ evt_elem_obj
  upvar $BLOCK_OBJ block_obj
  global gPB
  set canvas_frame $Page::($page_obj,canvas_frame)
  set win [toplevel $canvas_frame.cmd]
  set toplevel_index [llength $gPB(toplevel_list)]
  set win_index [expr $toplevel_index + 1]
  set gPB(toplevel_disable_$win_index) 1
  set cmd_page_obj [new Page "Command" "Command"]
  set blk_elem_obj [lindex $block::($block_obj,active_blk_elem_list) 0]
  if { $cmd_mode == "New" } \
  {
   set win_close_cb "UI_PB_cmd_tpthCmdBlkCancel_CB $win $page_obj $event_obj \
   $evt_elem_obj $blk_elem_obj $cmd_page_obj"
  } else \
  {
   set win_close_cb ""
  }
  set block_name $block::($block_obj,block_name)
  UI_PB_com_CreateTransientWindow $win "$gPB(tool,cus_trans,title,Label)" "" \
  "" "UI_PB_blk_DisableBlkPageWidgets $page_obj" "$win_close_cb" \
  "UI_PB_blk_ActivateBlkPageWidgets $page_obj $win_index"
  set cmd_obj $block_element::($blk_elem_obj,elem_mom_variable)
  set Page::($cmd_page_obj,canvas_frame) $win
  set box [frame $win.bb]
  pack $box -side bottom -padx 3 -pady 3 -fill x
  set cb_arr(gPB(nav_button,default,Label)) \
  "UI_PB_cmd_CmdBlkDefault_CB $cmd_page_obj"
  set cb_arr(gPB(nav_button,restore,Label)) \
  "UI_PB_cmd_CmdBlkRestore_CB $cmd_page_obj"
  if { $cmd_mode == "New" } \
  {
   set cb_arr(gPB(nav_button,cancel,Label)) \
   "UI_PB_cmd_tpthCmdBlkCancel_CB $win $page_obj $event_obj \
   $evt_elem_obj $blk_elem_obj $cmd_page_obj"
   set cb_arr(gPB(nav_button,ok,Label)) \
   "UI_PB_cmd_tpthCmdBlkOk_CB $win $page_obj $block_obj \
   $blk_elem_obj $cmd_page_obj"
  } else \
  {
   set cb_arr(gPB(nav_button,cancel,Label)) \
   "UI_PB_cmd_tpthEditCmdBlkCancel_CB $win $page_obj \
   $blk_elem_obj $cmd_page_obj"
   set cb_arr(gPB(nav_button,ok,Label)) \
   "UI_PB_cmd_tpthEditCmdBlkOk_CB $win $page_obj $block_obj \
   $blk_elem_obj $cmd_page_obj"
  }
  if { $cmd_mode == "New" } \
  {
   UI_PB_com_CreateActionElems $box cb_arr $win
  } else \
  {
   UI_PB_com_CreateActionElems $box cb_arr
  }
  UI_PB_cmd_CreateCmdBlkPage cmd_page_obj 1
  UI_PB_cmd_DisplayCmdBlkAttr cmd_page_obj cmd_obj
  UI_PB_com_PositionWindow $win
 }
