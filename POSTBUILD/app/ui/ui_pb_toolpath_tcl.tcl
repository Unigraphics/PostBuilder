set gPB(pb_func_icon) [tix getimage pb_function_short]
set gPB(condition_cmd_prefix)       "PB_CMD__check_block_"

#=======================================================================
proc UI_PB_tpth_LinkedPostEvent { SEQ_PAGE_OBJ SEQ_OBJ EVENT_OBJ } {
  upvar $SEQ_PAGE_OBJ seq_page_obj
  upvar $SEQ_OBJ seq_obj
  upvar $EVENT_OBJ event_obj
  global paOption gPB
  event::readvalue $event_obj evt_attr
  set event_name "$evt_attr(0)"
  UI_PB_lnk_SyncBlockNameWithEvent $event_obj
  set win [toplevel [UI_PB_com_AskActiveWindow].$event_name]
  set page_obj [new Page $event_name $event_name]
  set Page::($page_obj,page_id) $win
  set Page::($page_obj,event_name) $event::($event_obj,event_name)
  set Page::($page_obj,event_obj) $event_obj
  set toplevel_index [llength $gPB(toplevel_list)]
  set win_index [expr $toplevel_index + 1]
  set gPB(toplevel_disable_$win_index) 1
  UI_PB_com_CreateTransientWindow $win \
  "$gPB(tool,event_trans,title,Label) : $event_name" \
  "800x600+100+100" \
  "" "" \
  "UI_PB_tpth_CancelCallBack $seq_page_obj $page_obj $event_obj" \
  ""
  PB_int_RetEvtCombElems comb_box_elems
  set item_obj_list $event::($event_obj,evt_itm_obj_list)
  set ude_flag $sequence::($seq_obj,ude_flag)
  set apply_def_cb "__tpth_LinkedPostsButtons page_obj seq_page_obj seq_obj event_obj $win"
  if { [llength $item_obj_list ] > 0 } \
  {
   if { !$event::($event_obj,canvas_flag) } \
   {
    wm geometry $win 800x400+200+200
   }
   UI_PB_tpth_CreateHorzPane page_obj event_obj
   __tpth_CreateToolPathComponents page_obj seq_page_obj seq_obj event_obj "$apply_def_cb"
   UI_PB_tpth_CreateItemsOfEvent page_obj item_obj_list
   UI_PB_tpth_PackItems page_obj
  } else \
  {
   wm geometry $win 800x500+200+200
   set page_id $Page::($page_obj,page_id)
   set Page::($page_obj,canvas_frame) $page_id
   set Page::($page_obj,param_frame) $page_id
   set Page::($page_obj,box_frame) $page_id
   __tpth_CreateToolPathComponents page_obj seq_page_obj seq_obj event_obj "$apply_def_cb"
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
  if 1 { ;# It doesn't seem to be needed???
   if { ![info exists event::($event_obj,applied)] } {
    __tpth_RestoreEventData page_obj event_obj
    set event::($event_obj,applied) 1
   }
   if { ![info exists Page::($page_obj,rest_evt_mom_var)] } {
    __tpth_RestoreEventData page_obj event_obj
    set event::($event_obj,applied) 1
   }
  }
  set Page::($page_obj,block_popup_flag) 0
  UI_PB_blk_CreatePopupMenu page_obj
  set Page::($page_obj,blk_WordNameList) $comb_box_elems
  UI_PB_tpth_CreateEventBlockTemplates page_obj event_obj
  UI_PB_blk_CreateMenuOptions page_obj event
  UI_PB_com_PositionWindow $win
 }

#=======================================================================
proc __tpth_LinkedPostsButtons { PAGE_OBJ SEQ_PAGE_OBJ SEQ_OBJ EVENT_OBJ win } {
  upvar $PAGE_OBJ page_obj
  upvar $SEQ_PAGE_OBJ seq_page_obj
  upvar $EVENT_OBJ event_obj
  upvar $SEQ_OBJ seq_obj
  global paOption
  if [info exists Page::($page_obj,box)] \
  {
   pack forget $Page::($page_obj,box)
  }
  set frame [frame $Page::($page_obj,box_frame).frm1]
  pack $frame -side bottom -fill x -pady 3 -padx 3
  set box1_frm [frame $frame.box1]
  set box2_frm [frame $frame.box2]
  tixForm $box1_frm -top 0 -left 0 -right %50 -padright 20
  tixForm $box2_frm -top 0 -left $box1_frm -right %100
  set first_list  {"gPB(nav_button,default,Label)" \
  "gPB(nav_button,restore,Label)"}
  set second_list {"gPB(nav_button,cancel,Label)" \
  "gPB(nav_button,ok,Label)"}
  set cb_arr(gPB(nav_button,default,Label)) \
  "UI_PB_tpth_DefaultCallBack $page_obj $event_obj"
  set cb_arr(gPB(nav_button,restore,Label)) \
  "UI_PB_tpth_RestoreCallBack $page_obj $event_obj"
  UI_PB_com_CreateButtonBox $box1_frm first_list cb_arr
  if 0 {
   set cb_arr(gPB(nav_button,cancel,Label)) \
   "destroy $win"
   set cb_arr(gPB(nav_button,ok,Label)) \
   "destroy $win"
  }
  set cb_arr(gPB(nav_button,cancel,Label)) \
  "UI_PB_tpth_CancelCallBack $seq_page_obj $page_obj $event_obj"
  set cb_arr(gPB(nav_button,ok,Label)) \
  "UI_PB_tpth_OkCallBack $page_obj $seq_page_obj $seq_obj $event_obj"
  UI_PB_com_CreateButtonBox $box2_frm second_list cb_arr
 }

#=======================================================================
proc UI_PB_tpth_ToolPath { SEQ_PAGE_OBJ SEQ_OBJ EVENT_OBJ } {
  upvar $SEQ_PAGE_OBJ seq_page_obj
  upvar $SEQ_OBJ seq_obj
  upvar $EVENT_OBJ event_obj
  global paOption gPB
  set sequence_name $sequence::($seq_obj,seq_name)
  set event_name $event::($event_obj,event_name)
  if {[string index $event::($event_obj,event_label) 0] == "\$"} {
   set dbase_evt_name [set [string range $event::($event_obj,event_label) 1 end]]
   } else {
   set dbase_evt_name $event::($event_obj,event_label)
  }
  set bot_canvas $Page::($seq_page_obj,bot_canvas)
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
  set apply_def_cb "UI_PB_tpth_AddApplyDef page_obj seq_page_obj seq_obj event_obj"
  if { [llength $item_obj_list ] > 0 } \
  {
   if { !$event::($event_obj,canvas_flag) } \
   {
    wm geometry $win 800x400+200+200
   }
   UI_PB_tpth_CreateHorzPane page_obj event_obj
   __tpth_CreateToolPathComponents page_obj seq_page_obj seq_obj event_obj "$apply_def_cb"
   UI_PB_tpth_CreateItemsOfEvent page_obj item_obj_list
   UI_PB_tpth_PackItems page_obj
  } else \
  {
   wm geometry $win 800x500+200+200
   set page_id $Page::($page_obj,page_id)
   set Page::($page_obj,canvas_frame) $page_id
   set Page::($page_obj,param_frame) $page_id
   set Page::($page_obj,box_frame) $page_id
   __tpth_CreateToolPathComponents page_obj seq_page_obj seq_obj event_obj "$apply_def_cb"
  }
  UI_PB_tpth_CreateMembersOfItem page_obj event_obj
  if {$::tix_version == 8.4} {
   if {[llength $item_obj_list] > 0} {
    set p1 [winfo parent $Page::($page_obj,param_frame)]
    UI_PB_mthd_WheelForFrame [winfo parent $p1]
   }
  }
  if {$ude_flag} \
  {
   set no_items [llength $item_obj_list]
   if {$no_items > 0} \
   {
    UI_PB_tpth_CreateUserDefIcon page_obj no_items $event_obj ;#<25-10-05 peter> for UDE
   }
  }
  UI_PB_tpth_GetEventMomVars event_obj evt_mom_var_list
  set Page::($page_obj,evt_mom_var_list) [array get evt_mom_var_list]
  set Page::($page_obj,dummy_blk) 0
  UI_PB_tpth_CreateElemObjects page_obj event_obj
  if { ![info exists event::($event_obj,applied)] } {
   __tpth_RestoreEventData page_obj event_obj
   set event::($event_obj,applied) 1
  }
  if { ![info exists Page::($page_obj,rest_evt_mom_var)] } {
   __tpth_RestoreEventData page_obj event_obj
   set event::($event_obj,applied) 1
  }
  set Page::($page_obj,block_popup_flag) 0
  UI_PB_blk_CreatePopupMenu page_obj
  global mom_sys_arr
  if { [info exists mom_sys_arr(\$cycle_start_blk)] && \
  $mom_sys_arr(\$cycle_start_blk) } \
  {
   if { [PB_com_IsSiemensController $gPB(post_controller_type) 1] || \
   [PB_com_IsHeidenhainController $gPB(post_controller_type)] } \
   {
    PB_int_RetCycleComAndSharedEvts cycle_com_evt cycle_shared_evts
    if { [string compare $cycle_com_evt $event::($event_obj,event_name)] == 0 } \
    {
     UI_PB_tpth_AdjustPreviousBlkForCycleStartBlk $page_obj $event_obj
    }
   }
  }
  set Page::($page_obj,blk_WordNameList) $comb_box_elems
  UI_PB_tpth_CreateEventBlockTemplates page_obj event_obj
  if { $Page::($page_obj,dummy_blk) == 0 } { ;# Non-empty Cycle event
   PB_int_RetCycleComAndSharedEvts cycle_com_evt cycle_shared_evts
   lappend cycle_shared_evts $cycle_com_evt
   set evt_name $event::($event_obj,event_name)
   if { [lsearch $cycle_shared_evts $evt_name] >= 0 } {
    UI_PB_tpth_ApplyCallBack $page_obj $seq_page_obj $seq_obj $event_obj
   }
   if [string match "$cycle_com_evt" $evt_name] {
    if { [string match "" $event::($event_obj,cycle_rapid_to)]  && \
     [info exists mom_sys_arr(\$cycle_rapto_opt)] } {
     set event::($event_obj,cycle_rapid_to) $mom_sys_arr(\$cycle_rapto_opt)
    }
    if { [string match "" $event::($event_obj,cycle_retract_to)]  && \
     [info exists mom_sys_arr(\$cycle_recto_opt)] } {
     set event::($event_obj,cycle_retract_to) $mom_sys_arr(\$cycle_recto_opt)
    }
    if { [string match "" $event::($event_obj,cycle_start_blk)]  && \
     [info exists mom_sys_arr(\$cycle_start_blk)] } {
     set event::($event_obj,cycle_start_blk) $mom_sys_arr(\$cycle_start_blk)
    }
    if { [string match "" $event::($event_obj,cycle_plane_control)]  && \
     [info exists mom_sys_arr(\$cycle_plane_control_opt)] } {
     set event::($event_obj,cycle_plane_control) $mom_sys_arr(\$cycle_plane_control_opt)
    }
   }
  }
  set evt_img_id $event::($event_obj,icon_id)
  set img [lindex [$bot_canvas itemconfigure $evt_img_id -image] end]
  $img config -relief sunken -bg $paOption(sunken_bg)
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
    if {$::env(PB_UDE_ENABLED) == 1} {
     if ![string compare $sequence::($seq_obj,seq_name) "Machine Control"] {
      global post_object
      set udeobj $Post::($post_object,ude_obj)
      set seqobj $ude::($udeobj,seq_obj)
      set evt_list $sequence::($seqobj,evt_obj_list)
      if {[lsearch $evt_list $event_obj] != "-1"} {
       $img config -bg $paOption(ude_bg)
      }
     }
     if ![string compare $sequence::($seq_obj,seq_name) "Cycles"] {
      global post_object machData
      if {$machData(0) == "Mill"} {
       set udeobj $Post::($post_object,ude_obj)
       set seqobj $ude::($udeobj,seq_obj_cycle)
       set evt_list $sequence::($seqobj,evt_obj_list)
       if {[lsearch $evt_list $event_obj] != "-1"} {
        $img config -bg $paOption(udc_bg)
       }
      }
     }
    }
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
   UI_PB_blk_AddBindProcs page_obj
   UI_PB_tpth_IconBindProcs page_obj event_obj
   $top_canvas bind add_movable <B1-Motion> \
   "UI_PB_tpth_ItemDrag1 $page_obj $event_obj \
   %x %y %X %Y"
   $top_canvas bind add_movable <ButtonRelease-1> \
   "UI_PB_tpth_ItemEndDrag1 $page_obj $event_obj \
   %x %y"
   set gPB(toplevel_disable_$win_index) 0
  }
 }

#=======================================================================
proc UI_PB_tpth_DisableTpthEvtWidgets { page_obj } {
  UI_PB_tpth_IconUnBindProcs page_obj
  UI_PB_blk_AddUnBindProcs page_obj
  set c $Page::($page_obj,bot_canvas)
  $c config -cursor ""
 }

#=======================================================================
proc __tpth_RestoreEventData { PAGE_OBJ EVENT_OBJ } {
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
   if [string match "\$mom_kin*" $mom_var] \
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
  if [info exists rest_evt_mom_var] \
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
proc __tpth_CreateToolPathComponents { PAGE_OBJ SEQ_PAGE_OBJ SEQ_OBJ \
  EVENT_OBJ apply_def_cb } {
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
  eval $apply_def_cb
  set Page::($page_obj,add_name) " $gPB(tool,add_word,button,Label) "
  Page::CreateAddTrashinCanvas $page_obj
  Page::CreateMenu $page_obj
  UI_PB_blk_AddBindProcs page_obj
  set top_canvas $Page::($page_obj,top_canvas)
  $top_canvas bind add_movable <B1-Motion> \
  "UI_PB_tpth_ItemDrag1 $page_obj $event_obj \
  %x %y %X %Y"
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
proc UI_PB_tpth_CreateUserDefIcon { PAGE_OBJ NO_ITEMS {event_obj NULL}} {
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
    button $ude_frame.but -image $f_image
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
   } elseif { $ref_topitem_id != 0 && $ref_sideitem_id == 0 } \
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
    Page::CreateLblEntry $data_type $val1 $inp_frm $ext $label 0 "" 1
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
    set bt_value ""
    if { [string compare "null" $group_member::($member_obj,opt_list)] } {
     set bt_value [string toupper [lindex $group_member::($member_obj,opt_list) 0]]
     } elseif { [string match "*\$gPB(*" $group_member::($member_obj,label)] } {
     set bt_variable $group_member::($member_obj,label)
     set f_brace [string first "\(" $bt_variable]
     set l_brace [string first "\)" $bt_variable]
     set bt_variable [string range $bt_variable [expr $f_brace + 1] [expr $l_brace - 1]]
     set bt_variable [split $bt_variable ","]
     set bt_value [string toupper [lindex $bt_variable end]]
    }
    if { [string compare "" $bt_value] } {
     Page::CreateRadioButton $val1 $inp_frm $ext $label $bt_value
     } else {
     Page::CreateRadioButton $val1 $inp_frm $ext $label
    }
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
  if {[info exists ::env(INCH_METRIC)] && $::env(INCH_METRIC) == 1} {
   if {[string match "Coordinate" $Format_Name] ||
    [string match "AbsCoord" $Format_Name]} {
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
  PB_int_RetFmtObjFromName Temp_Format_Name fmt_obj
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
  global mom_kin_var
  global gPB
  global disable_IJK_message_box
  if { ![info exists event::($event_obj,cir_vec)] } {
   set event::($event_obj,cir_vec) $mom_sys_arr(\$mom_sys_cir_vector)
   set disable_IJK_message_box 1
   } else {
   if [string match $event::($event_obj,cir_vec) $mom_sys_arr(\$mom_sys_cir_vector)] {
    set Page::($page_obj,prev_cir_vec) $mom_sys_arr(\$mom_sys_cir_vector)
    return
   }
   set event::($event_obj,cir_vec) $mom_sys_arr(\$mom_sys_cir_vector)
  }
  set update_rest_val 0
  if { [info exists Page::($page_obj,event_apply_cb)]  && \
   $Page::($page_obj,event_apply_cb) } {
   set update_rest_val 1
  }
  if { ![info exists Page::($page_obj,prev_cir_vec)] } {
   set Page::($page_obj,prev_cir_vec) $mom_sys_arr(\$mom_sys_cir_vector)
  }
  set curr_cir_vec_mode [lindex $args 0]
  UI_PB_tpth_SetIJKOptions $event_obj $mom_kin_var(\$mom_kin_machine_type) \
  $curr_cir_vec_mode \
  $Page::($page_obj,prev_cir_vec) \
  $update_rest_val
  UI_PB_blk_CreateMenuOptions page_obj event
  UI_PB_tpth_DeleteAndRecreateIcons page_obj event_obj
  set Page::($page_obj,prev_cir_vec) $mom_sys_arr(\$mom_sys_cir_vector)
  set output_message [list]
  if { ![info exists disable_IJK_message_box] || !$disable_IJK_message_box } {
   foreach obj $event::($event_obj,evt_elem_list) {
    set ele_blk_obj $event_element::($obj,block_obj)
    if { ![string compare $block::($ele_blk_obj,blk_type) "normal"] } {
     foreach ele_addr_obj $block::($ele_blk_obj,elem_addr_list) {
      set addr_obj_m  $block_element::($ele_addr_obj,elem_add_obj)
      set addr_name_m $address::($addr_obj_m,add_name)
      switch -exact -- $addr_name_m \
      {
       "I" -
       "J" -
       "K" {
        if { ![string compare $block_element::($ele_addr_obj,elem_desc) "User Defined Expression"] || \
         ![string compare $block_element::($ele_addr_obj,elem_desc) "Longitudinal Thread Lead"] || \
         ![string compare $block_element::($ele_addr_obj,elem_desc) "Transversal Thread Lead"] } {
         lappend output_message "\"$addr_name_m\""
        }
       }
      }
     }
    }
   }
   if { [llength $output_message] } {
    set output_message [join $output_message ","]
    if { [string compare [string trim $output_message] ""] } {
     tk_messageBox -parent [UI_PB_com_AskActiveWindow] \
     -type ok -icon warning \
     -message "$gPB(event,circular,ijk_param,prefix,msg) $output_message \n$gPB(event,circular,ijk_param,postfix,msg)"
    }
   }
   } else {
   unset disable_IJK_message_box
  }
 }

#=======================================================================
proc UI_PB_tpth_SetIJKOptions { event_obj machine_type cir_vec_mode prev_cir_vec_mode \
  update_rest_def } {
  set machine_type [string tolower $machine_type]
  UI_PB_tpth_SetIJKExpr $machine_type \
  $cir_vec_mode \
  expr_i expr_j expr_k
  UI_PB_tpth_SetIJKExpr $machine_type \
  $prev_cir_vec_mode \
  x_expr_i x_expr_j x_expr_k
  set elem_desc ""
  UI_PB_tpth_SetIJKDesc $cir_vec_mode elem_desc
  set add_name "I"
  PB_int_RetAddrObjFromName add_name add_obj
  set search_var $x_expr_i
  if { ![info exists expr_i] } { set expr_i $search_var }
  set elem_desc_i "$elem_desc X-Axis"
  UI_PB_tpth_UpdateEventVarAddress $event_obj $add_obj $search_var \
  $expr_i $elem_desc_i $update_rest_def
  if { ![string match "*lathe" $machine_type] } {
   set add_name "J"
   PB_int_RetAddrObjFromName add_name add_obj
   set search_var $x_expr_j
   if { ![info exists expr_j] } { set expr_j $search_var }
   set elem_desc_j "$elem_desc Y-Axis"
   UI_PB_tpth_UpdateEventVarAddress $event_obj $add_obj $search_var \
   $expr_j $elem_desc_j $update_rest_def
  }
  if { ![string match "*wedm" $machine_type] } {
   set add_name "K"
   PB_int_RetAddrObjFromName add_name add_obj
   set search_var $x_expr_k
   if { ![info exists expr_k] } { set expr_k $search_var }
   set elem_desc_k "$elem_desc Z-Axis"
   UI_PB_tpth_UpdateEventVarAddress $event_obj $add_obj $search_var \
   $expr_k $elem_desc_k $update_rest_def
  }
 }

#=======================================================================
proc UI_PB_tpth_SetIJKExpr { machine mode EXPR_I EXPR_J EXPR_K } {
  upvar $EXPR_I expr_i
  upvar $EXPR_J expr_j
  upvar $EXPR_K expr_k
  switch $machine {
   "lathe" {
    switch $mode \
    {
     "Vector - Arc Start to Center" \
     {
      set expr_i "\$mom_pos_arc_center(0) - \$mom_prev_pos(0)"
      set expr_k "\$mom_pos_arc_center(2) - \$mom_prev_pos(2)"
     }
     "Vector-Center to Arc Start" -
     "Vector - Arc Center to Start" \
     {
      set expr_i "\$mom_prev_pos(0) - \$mom_pos_arc_center(0)"
      set expr_k "\$mom_prev_pos(2) - \$mom_pos_arc_center(2)"
     }
     "Unsigned Vector - Arc Start to Center" \
     {
      set expr_i "abs(\$mom_pos_arc_center(0) - \$mom_prev_pos(0))"
      set expr_k "abs(\$mom_pos_arc_center(2) - \$mom_prev_pos(2))"
     }
     "Vector - Absolute Arc Center"
     {
      set expr_i "\$mom_pos_arc_center(0)"
      set expr_k "\$mom_pos_arc_center(2)"
     }
     default {
      return 0
     }
    }
   }
   default {
    switch $mode \
    {
     "Vector - Arc Start to Center" \
     {
      set expr_i "\$mom_pos_arc_center(0) - \$mom_prev_pos(0)"
      set expr_j "\$mom_pos_arc_center(1) - \$mom_prev_pos(1)"
      set expr_k "\$mom_pos_arc_center(2) - \$mom_prev_pos(2)"
     }
     "Vector-Center to Arc Start" -
     "Vector - Arc Center to Start" \
     {
      set expr_i "\$mom_prev_pos(0) - \$mom_pos_arc_center(0)"
      set expr_j "\$mom_prev_pos(1) - \$mom_pos_arc_center(1)"
      set expr_k "\$mom_prev_pos(2) - \$mom_pos_arc_center(2)"
     }
     "Unsigned Vector - Arc Start to Center" \
     {
      set expr_i "abs(\$mom_pos_arc_center(0) - \$mom_prev_pos(0))"
      set expr_j "abs(\$mom_pos_arc_center(1) - \$mom_prev_pos(1))"
      set expr_k "abs(\$mom_pos_arc_center(2) - \$mom_prev_pos(2))"
     }
     "Vector - Absolute Arc Center"
     {
      set expr_i "\$mom_pos_arc_center(0)"
      set expr_j "\$mom_pos_arc_center(1)"
      set expr_k "\$mom_pos_arc_center(2)"
     }
     default {
      return 0
     }
    }
   }
  }
  return 1
 }

#=======================================================================
proc UI_PB_tpth_SetIJKDesc { mode DESC } {
  upvar $DESC desc
  global gPB
  switch $mode \
  {
   "Vector - Arc Start to Center" \
   {
    set desc "$gPB(tool,ijk_desc,arc_start,Label)"
   }
   "Vector-Center to Arc Start" -
   "Vector - Arc Center to Start" \
   {
    set desc "$gPB(tool,ijk_desc,arc_center,Label)"
   }
   "Unsigned Vector - Arc Start to Center" \
   {
    set desc "$gPB(tool,ijk_desc,u_arc_start,Label)"
   }
   "Vector - Absolute Arc Center"
   {
    set desc "$gPB(tool,ijk_desc,absolute,Label)"
   }
   default {
    return 0
   }
  }
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
  set plane_lbfrm [Page::CreateLblFrame $top_frm edt " $gPB(tool,circ_trans,frame,Label) "]
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
  global gPB
  set mom_var_list $Page::($page_obj,page_momvars)
  if { [llength $mom_var_list] } {
   foreach var $mom_var_list {
    if { [info exists mom_sys_arr($var)] } {
     if { ![string compare [string trim [set mom_sys_arr($var)]] ""] } {
      tk_messageBox -parent [UI_PB_com_AskActiveWindow] \
      -message "$gPB(machine,empty_entry_err,msg)" \
      -icon error
      return
     }
    }
   }
  }
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
       set mom_sys_arr($var) 0 ;# was 1
      }
      "max" \
      {
       set mom_sys_arr($var) 0 ;# was 9999
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
       set mom_sys_arr($var) 0 ;#<04-04-02 gsl> was 1
      }
      "max" \
      {
       set mom_sys_arr($var) 0 ;#<04-04-02 gsl> was 9999
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
  if [winfo exists $win] \
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
   UI_PB_com_CreateTransientWindow $win "$gPB(tool,config,title,Label)" \
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
  bind $top_frm <Enter> "%W config -bg $paOption(focus)"
  bind $top_frm <Leave> "%W config -bg gray85"
  set out_frm [Page::CreateLblFrame $mid_frm out \
  "$gPB(tool,config,output,Label)"]
  tixForm $out_frm -top 10 -left %10 -right %90 -pady 5 -padx 25
  set outsubfrm [$out_frm subwidget frame]
  switch $mom_kin_var(\$mom_kin_machine_type) \
  {
   "lathe" \
   {
    set option_list [list "$gPB(tool,config,lathe_opt1,Label)" \
    "$gPB(tool,config,lathe_opt2,Label)" \
    "$gPB(tool,config,lathe_opt3,Label)" \
    "$gPB(tool,config,lathe_opt4,Label)"]
    set val_list [list "TOOL_NUMBER_ONLY" \
    "TOOL_NUMBER_AND_LENGTH_OFFSET_NUMBER" \
    "TURRET_INDEX_AND_TOOL_NUMBER" \
    "TURRET_INDEX_TOOL_NUMBER_AND_LENGTH_OFFSET_NUMBER"]
   }
   default \
   {
    set option_list [list "$gPB(tool,config,mill_opt1,Label)" \
    "$gPB(tool,config,mill_opt2,Label)" \
    "$gPB(tool,config,mill_opt3,Label)"]
    set val_list [list "TOOL_NUMBER_ONLY" \
    "TOOL_NUMBER_AND_LENGTH_OFFSET_NUMBER" \
    "LENGTH_OFFSET_NUMBER_AND_TOOL_NUMBER"]
   }
  }
  for { set count 0 } { $count < [llength $option_list] } { incr count } \
  {
   set opt_label [lindex $option_list $count]
   set val [lindex $val_list $count]
   set frm1 [frame $outsubfrm.frm_$count]
   pack $frm1 -anchor nw -pady 10 -padx 10
   UI_PB_mthd_CreateRadioButton \$tool_num_output $frm1 rad \
   "$opt_label" $val
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
proc UI_PB_tpth_UpdateEventVarAddress { event_obj add_obj search_var \
  elem_expr elem_desc update_rest_def } {
  global mom_sys_arr
  global gPB
  if 0 {
   set blk_name_list [list]
   foreach evt_elem $event::($event_obj,evt_elem_list) {
    event_element::readvalue $evt_elem evt_elem_attr
    lappend blk_name_list "$evt_elem_attr(0)"
   }
  }
  set add_name $address::($add_obj,add_name)
  set blk_elem_list [lsort -integer $address::($add_obj,blk_elem_list)]
  set o_elem_expr $elem_expr
  set o_elem_desc $elem_desc
  set prev_elem ""
  foreach elem_obj $blk_elem_list \
  {
   if { ![string match "$event::($event_obj,event_name)" \
    $block_element::($elem_obj,owner)] } {
    if { ![string match "$elem_expr" $block_element::($elem_obj,elem_mom_variable)] } {
     set elem_expr $block_element::($elem_obj,elem_mom_variable)
     set elem_desc "$gPB(block,user,word_desc,Label)"
    }
   }
   set elem_mom_var $block_element::($elem_obj,elem_mom_variable)
   if { [string match "$search_var" $elem_mom_var] && \
   $elem_obj != $prev_elem } \
   {
    UI_PB_debug_ForceMsg "search_var==$search_var  elem_mom_var==$elem_mom_var"
    set block_element::($elem_obj,elem_mom_variable) $elem_expr
    set block_element::($elem_obj,elem_desc) $elem_desc
    if $update_rest_def {}
    if 0 {
     array set def_elem_attr $block_element::($elem_obj,def_value)
     set def_elem_attr(1) $elem_expr
     set def_elem_attr(3) $elem_desc
     block_element::DefaultValue $elem_obj def_elem_attr
     unset def_elem_attr
    }
    if $update_rest_def {
     if [info exists block_element::($elem_obj,rest_value)] \
     {
      array set rest_elem_attr $block_element::($elem_obj,rest_value)
      set rest_elem_attr(1) $elem_expr
      set rest_elem_attr(3) $elem_desc
      set block_element::($elem_obj,rest_value) \
      [array get rest_elem_attr]
      unset rest_elem_attr
     }
    }
    set prev_elem $elem_obj
   }
   set elem_expr $o_elem_expr
   set elem_desc $o_elem_desc
  }
  PB_int_RetMOMVarAsscAddress add_name add_mom_var
  PB_int_RetMOMVarDescAddress add_name add_mom_var_desc
  set index 0
  if 0 {
   foreach mom_var $add_mom_var \
   {
    if { [string match "*$search_var*" $mom_var] } \
    {
     set add_mom_var [lreplace $add_mom_var $index $index $elem_expr]
     set add_mom_var_desc [lreplace $add_mom_var_desc $index $index $elem_desc]
     set mom_value $mom_sys_arr($mom_var)
     unset mom_sys_arr($mom_var)
     set mom_sys_arr($elem_expr) $mom_value
     set add_mom_var      [ltidy $add_mom_var]
     set add_mom_var_desc [ltidy $add_mom_var_desc]
    }
    incr index
   }
  }
  set add_mom_var           [ltidy $add_mom_var]
  set add_mom_var_desc      [ltidy $add_mom_var_desc]
  set new_add_mom_var       $add_mom_var
  set new_add_mom_var_desc  $add_mom_var_desc
  foreach mom_var $add_mom_var \
  {
   if { [string match "$search_var" $mom_var] } \
   {
    UI_PB_debug_ForceMsg "search_var==$search_var  mom_var==$mom_var"
    set new_add_mom_var [lreplace $new_add_mom_var $index $index $elem_expr]
    set new_add_mom_var_desc [lreplace $new_add_mom_var_desc $index $index $elem_desc]
    set mom_value $mom_sys_arr($mom_var)
    unset mom_sys_arr($mom_var)
    set mom_sys_arr($elem_expr) $mom_value
   }
   incr index
  }
  set add_mom_var      [ltidy $new_add_mom_var]
  set add_mom_var_desc [ltidy $new_add_mom_var_desc]
  PB_int_UpdateMOMVarOfAddress   add_name add_mom_var
  PB_int_UpdateMOMVarDescAddress add_name add_mom_var_desc
  PB_int_UpdateMOMVar mom_sys_arr
 }

#=======================================================================
proc UI_PB_tpth_UpdateVarAddress { ADD_OBJ SEARCH_VAR ELEM_EXPR ELEM_DESC args } {
  upvar $ADD_OBJ add_obj
  upvar $SEARCH_VAR search_var
  upvar $ELEM_EXPR elem_expr
  upvar $ELEM_DESC elem_desc
  global mom_sys_arr
  set add_name $address::($add_obj,add_name)
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
    if { [llength $args] && [lindex $args 0] } {
     array set def_elem_attr $block_element::($elem_obj,def_value)
     set def_elem_attr(1) $elem_expr
     set def_elem_attr(3) $elem_desc
     block_element::DefaultValue $elem_obj def_elem_attr
     unset def_elem_attr
     if [info exists block_element::($elem_obj,rest_value)] \
     {
      array set rest_elem_attr $block_element::($elem_obj,rest_value)
      set rest_elem_attr(1) $elem_expr
      set rest_elem_attr(3) $elem_desc
      set block_element::($elem_obj,rest_value) \
      [array get rest_elem_attr]
      unset rest_elem_attr
     }
    }
    set prev_elem $elem_obj
   }
  }
  PB_int_RetMOMVarAsscAddress add_name add_mom_var
  PB_int_RetMOMVarDescAddress add_name add_mom_var_desc
  set index 0
  if 0 {
   foreach mom_var $add_mom_var \
   {
    if { [string match "*$search_var*" $mom_var] } \
    {
     set add_mom_var [lreplace $add_mom_var $index $index $elem_expr]
     set add_mom_var_desc [lreplace $add_mom_var_desc $index $index $elem_desc]
     set mom_value $mom_sys_arr($mom_var)
     unset mom_sys_arr($mom_var)
     set mom_sys_arr($elem_expr) $mom_value
     set add_mom_var      [ltidy $add_mom_var]
     set add_mom_var_desc [ltidy $add_mom_var_desc]
    }
    incr index
   }
  }
  set add_mom_var           [ltidy $add_mom_var]
  set add_mom_var_desc      [ltidy $add_mom_var_desc]
  set new_add_mom_var       $add_mom_var
  set new_add_mom_var_desc  $add_mom_var_desc
  foreach mom_var $add_mom_var \
  {
   if { [string match "*$search_var*" $mom_var] } \
   {
    set new_add_mom_var [lreplace $new_add_mom_var $index $index $elem_expr]
    set new_add_mom_var_desc [lreplace $new_add_mom_var_desc $index $index $elem_desc]
    set mom_value $mom_sys_arr($mom_var)
    unset mom_sys_arr($mom_var)
    set mom_sys_arr($elem_expr) $mom_value
   }
   incr index
  }
  set add_mom_var      [ltidy $new_add_mom_var]
  set add_mom_var_desc [ltidy $new_add_mom_var_desc]
  PB_int_UpdateMOMVarOfAddress   add_name add_mom_var
  PB_int_UpdateMOMVarDescAddress add_name add_mom_var_desc
  PB_int_UpdateMOMVar mom_sys_arr
 }

#=======================================================================
proc UI_PB_tpth_ToolConfigOk_CB { win page_obj event_obj } {
  global gPB
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
    set tl_elem_desc [format %s "$gPB(tool,conf_desc,num,Label)"]
    set tp_elem_desc [format %s "$gPB(tool,conf_desc,next_num,Label)"]
   }
   TOOL_NUMBER_AND_LENGTH_OFFSET_NUMBER \
   {
    set toolnum_fmt_attr(5) 4
    set tooloff_fmt_attr(5) 2
    set toolnum_addr_attr(4) 9999
    set tl_elem_expr "100 * \$mom_tool_number + \$mom_tool_adjust_register"
    set tp_elem_expr "100 * \$mom_next_tool_number + \$mom_tool_adjust_register"
    set tl_elem_desc [format %s "$gPB(tool,conf_desc,num_len,Label)"]
    set tp_elem_desc [format %s "$gPB(tool,conf_desc,next_num_len,Label)"]
   }
   LENGTH_OFFSET_NUMBER_AND_TOOL_NUMBER \
   {
    set toolnum_fmt_attr(5) 4
    set tooloff_fmt_attr(5) 2
    set toolnum_addr_attr(4) 9999
    set tl_elem_expr "100 * \$mom_tool_adjust_register + \$mom_tool_number"
    set tp_elem_expr "100 * \$mom_tool_adjust_register + \$mom_next_tool_number"
    set tl_elem_desc [format %s "$gPB(tool,conf_desc,len_num,Label)"]
    set tp_elem_desc [format %s "$gPB(tool,conf_desc,len_next_num,Label)"]
   }
   TURRET_INDEX_AND_TOOL_NUMBER \
   {
    set toolnum_fmt_attr(5) 2
    set tooloff_fmt_attr(5) 2
    set toolnum_addr_attr(4) 99
    set tl_elem_expr "10 * \$mom_sys_turret_index(\$turret_current) + \$mom_tool_number"
    set tp_elem_expr "10 * \$mom_sys_turret_index(\$turret_current) + \$mom_next_tool_number"
    set tl_elem_desc [format %s "$gPB(tool,conf_desc,index_num,Label)"]
    set tp_elem_desc [format %s "$gPB(tool,conf_desc,index_next_num,Label)"]
   }
   TURRET_INDEX_TOOL_NUMBER_AND_LENGTH_OFFSET_NUMBER \
   {
    set toolnum_fmt_attr(5) 4
    set tooloff_fmt_attr(5) 2
    set toolnum_addr_attr(4) 9999
    set tl_elem_expr "1000 * \$mom_sys_turret_index(\$turret_current) +\
    100 * \$mom_tool_number + \$mom_tool_adjust_register"
    set tp_elem_expr "1000 * \$mom_sys_turret_index(\$turret_current) +\
    100 * \$mom_next_tool_number + \$mom_tool_adjust_register"
    set tl_elem_desc [format %s "$gPB(tool,conf_desc,index_num_len,Label)"]
    set tp_elem_desc [format %s "$gPB(tool,conf_desc,index_next_num_len,Label)"]
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
    set toolnum_fmt_attr(5) 2
    set inp_value 1
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
   TURRET_INDEX_AND_TOOL_NUMBER \
   {
    set toolnum_fmt_attr(5) 2
    set inp_value [expr [expr 10 * 1] + 1]
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
  if { $rap1_obj != "" && [info exists block::($rap1_obj,block_name)] } \
  {
   set rapid_blk_1 $block::($rap1_obj,block_name)
  }
  if { $rap2_obj != "" && [info exists block::($rap2_obj,block_name)] } \
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
    if 0 {
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
    if { [string compare $trav_add_name "rapid3"] == 0    || \
     [string compare $trav_add_name "H"] == 0         || \
     [string compare $trav_add_name "G_adjust"] == 0  || \
    [string compare $trav_add_name "M_coolant"] == 0  } \
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
     if { [string compare $trav_add_name "G_motion"] == 0 || \
     [string compare $trav_add_name "G_mode"] == 0 } \
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
    $block::($elem_blk_obj,blk_type) != "comment" && \
   $block::($elem_blk_obj,blk_type) != "macro" } \
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
   block_owner $evt_elem_obj
   set Page::($page_obj,y_orig) [expr \
   $Page::($page_obj,y_orig) + $Page::($page_obj,blk_blkdist)]
  }
 }

#=======================================================================
proc UI_PB_tpth_SetPageAttributes { PAGE_OBJ } {
  upvar $PAGE_OBJ page_obj
  set Page::($page_obj,h_cell) 30       ;# cell height
  set Page::($page_obj,w_cell) 62       ;# cell width
  set Page::($page_obj,w_divi) 4        ;# divider width
  set Page::($page_obj,x_orig) 80       ;# upper-left corner of 1st cell
  set Page::($page_obj,y_orig) 30
  set Page::($page_obj,rect_region) 15  ;# Block rectangle region
  set Page::($page_obj,add_blk) 0
  set Page::($page_obj,add_flag) 0
  set Page::($page_obj,icon_top) 0
  set Page::($page_obj,icon_bot) 0
  set Page::($page_obj,blk_blkdist) 75
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
  if {$::tix_version == 8.4} {
   UI_PB_mthd_CreateScrollWindow $param_frm scr p2t y
   } else {
   tixScrolledWindow $param_frm.scr
   [$param_frm.scr subwidget hsb] config -troughcolor $paOption(trough_bg) \
   -width $paOption(trough_wd)
   [$param_frm.scr subwidget vsb] config -troughcolor $paOption(trough_bg) \
   -width $paOption(trough_wd)
   pack $param_frm.scr -padx 5 -pady 5 -expand yes -fill both
   set p2t [$param_frm.scr subwidget window]
  }
  set sec_frm [frame $p2t.f]
  pack $sec_frm -fill both -expand yes
  set Page::($page_obj,canvas_frame) $top_frm
  set Page::($page_obj,param_frame) $sec_frm
  set Page::($page_obj,box_frame) $box_frm
 }

#=======================================================================
proc UI_PB_tpth_ItemDrag1 {page_obj event_obj x y X Y} {
  set bot_canvas $Page::($page_obj,bot_canvas)
  set top_canvas $Page::($page_obj,top_canvas)
  set panel_hi $Page::($page_obj,panel_hi)
  set xx [$top_canvas canvasx $x]
  set yy [$top_canvas canvasy $y]
  $top_canvas coords $Page::($page_obj,icon_top) $xx $yy
  switch $::tix_version {
   8.4 {
    set dx 0
    set dy [expr $panel_hi + 0]
   }
   4.1 {
    set dx 1
    set dy [expr $panel_hi + 2]
   }
  }
  set xx [$bot_canvas canvasx [expr $x + $dx]]
  set yy [$bot_canvas canvasy [expr $y - $dy]]
  UI_PB_ScrollCanvasWin $page_obj $xx $yy
  set xx [$bot_canvas canvasx [expr $x + $dx]]
  set yy [$bot_canvas canvasy [expr $y - $dy]]
  $bot_canvas coords $Page::($page_obj,icon_bot) $xx $yy
  set sel_addr $Page::($page_obj,sel_base_addr)
  UI_PB_tpth_HighlightSeperators $page_obj $event_obj \
  $sel_addr $xx $yy
  if [string match * $::tix_version] {
   set canvas_x [winfo rootx $top_canvas]
   set canvas_y [winfo rooty $top_canvas]
   set canvas_height [expr {[winfo height $bot_canvas] + [winfo height $top_canvas]}]
   set canvas_width  [winfo width  $bot_canvas]
   UI_PB_mthd_MoveDDBlock $X $Y addressblock $canvas_x $canvas_y $canvas_height $canvas_width
  }
 }

#=======================================================================
proc UI_PB_tpth_UnHighLightSep { PAGE_OBJ } {
  upvar $PAGE_OBJ page_obj
  global paOption
  set main_cell_color $paOption(can_bg)
  set divi_color turquoise
  set rect_color $divi_color
  set bot_canvas $Page::($page_obj,bot_canvas)
  switch $Page::($page_obj,add_flag) \
  {
   1 {
    if [info exists Page::($page_obj,focus_rect)] {
     $bot_canvas itemconfigure [lindex $Page::($page_obj,focus_rect) 0] \
     -outline $rect_color -fill $rect_color
     $bot_canvas itemconfigure [lindex $Page::($page_obj,focus_rect) 1] \
     -outline $main_cell_color -fill $main_cell_color
     $bot_canvas itemconfigure [lindex $Page::($page_obj,focus_rect) 2] \
     -outline $main_cell_color -fill $main_cell_color
     unset Page::($page_obj,focus_rect)
    }
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
  if [info exists Page::($page_obj,focus_sep)] \
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
    PB_com_DeleteObject $block_obj
   }
  }
 }

#=======================================================================
proc UI_PB_tpth_ItemEndDrag1 {page_obj event_obj x y } {
  global paOption
  global gPB
  if [string match * $::tix_version] {
   UI_PB_mthd_DestroyDDBlock
  }
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
    } elseif { [string match "Macro" $sel_base_addr] } \
   {
    if { $new_elem_mom_var == "New Macro" } \
    {
     set blk_flag "macro"
     set new_elem_mom_var "New_Macro"
     PB_int_CreateNewFuncBlkElem new_elem_mom_var new_elem_obj
    } else \
    {
     set blk_flag ""
     PB_int_CreateFuncBlkElem new_elem_mom_var new_elem_obj
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
   set force_addr_obj 0
   switch $Page::($page_obj,add_blk) \
   {
    "row" \
    {
     UI_PB_tpth_AddBlkElemRow page_obj add_to_evt_elem_obj \
     new_elem_obj new_blk_elem_flag
     if { $new_blk_elem_flag } \
     {
      PB_com_DeleteObject $new_elem_obj
      set Page::($page_obj,add_blk) 0
      set Page::($page_obj,add_flag) 0
      return
     }
    }
    "top" \
    {
     UI_PB_tpth_AddBlkElemTopOrBottom page_obj event_obj \
     add_to_evt_elem_obj new_elem_obj force_addr_obj
    }
    "bottom" \
    {
     UI_PB_tpth_AddBlkElemTopOrBottom page_obj event_obj \
     add_to_evt_elem_obj new_elem_obj force_addr_obj
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
    } elseif { $blk_flag == "macro"} \
   {
    set new_blk_obj $event_element::($add_to_evt_elem_obj,block_obj)
    UI_PB_tpth_BringFuncPage page_obj event_obj add_to_evt_elem_obj \
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
   $block_element::($new_blk_elem_obj,elem_add_obj) != "Comment" && \
  $block_element::($new_blk_elem_obj,elem_add_obj) != "Macro" } \
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
   } elseif { $block::($add_to_blk_obj,active_blk_elem_list) == "" && \
  $block_element::($new_blk_elem_obj,elem_add_obj) == "Macro" } \
  {
   PB_int_RemoveBlkObjFrmList add_to_blk_obj
   set block::($add_to_blk_obj,blk_type) "macro"
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
    "Macro" {
     if {[llength $block::($add_to_blk_obj,elem_addr_list)] == 0} \
     {
      lappend block::($add_to_blk_obj,elem_addr_list) $new_blk_elem_obj
     }
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
  block_owner $add_to_evt_elem_obj
 }

#=======================================================================
proc UI_PB_tpth_AddBlkElemTopOrBottom { PAGE_OBJ EVENT_OBJ ADD_TO_EVT_ELEM_OBJ \
  NEW_BLK_ELEM_OBJ FORCE_ADDR_OBJ } {
  upvar $PAGE_OBJ page_obj
  upvar $EVENT_OBJ event_obj
  upvar $ADD_TO_EVT_ELEM_OBJ add_to_evt_elem_obj
  upvar $NEW_BLK_ELEM_OBJ new_blk_elem_obj
  upvar $FORCE_ADDR_OBJ force_addr_obj
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
   } elseif { $block_element::($new_blk_elem_obj,elem_add_obj) == "Macro" } \
  {
   set func_obj $block_element::($new_blk_elem_obj,elem_mom_variable)
   set new_block_name $function::($func_obj,id)
   PB_int_CreateFuncBlk new_block_name new_blk_elem_obj new_block_obj
   set block::($new_block_obj,blk_owner) $event_name
  } else \
  {
   set blk_type "normal"
   UI_PB_com_ReturnBlockName event_obj new_block_name
   PB_int_CreateNewBlock new_block_name new_blk_elem_obj \
   event_name new_block_obj blk_type
  }
  PB_int_CreateNewEventElement new_block_obj new_evt_elem $event_obj
  if { $force_addr_obj > 0 } \
  {
   lappend event_element::($new_evt_elem,force_addr_list) $force_addr_obj
  }
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
   event_name $elem_obj
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
  global gPB
  set enable_last_flag 0 ;#<07-29-09 wbh>
  set post_flag 0
  if { [PB_com_IsSiemensController $gPB(post_controller_type) 1] || \
  [PB_com_IsHeidenhainController $gPB(post_controller_type)] } \
  {
   PB_int_RetCycleComAndSharedEvts cycle_com_evt cycle_shared_evts
   if { [string compare $cycle_com_evt $event_name] == 0 } \
   {
    set post_flag 1
    } elseif { [lsearch $cycle_shared_evts $event_name] != -1 } \
   {
    set post_flag 2
    set enable_last_flag 1
    foreach elem_obj $event_elem_list \
    {
     set block_obj $event_element::($elem_obj,block_obj)
     if { [string compare $event_name $block::($block_obj,blk_owner)] == 0 || \
     [string compare "post" $block::($block_obj,blk_owner)] == 0 } \
     {
      set enable_last_flag 0
      break
     }
    }
   }
  }
  set cur_ind 0
  set len_evt_list [llength $event_elem_list]
  foreach elem_obj $event_elem_list \
  {
   set block_obj $event_element::($elem_obj,block_obj)
   set block_name $block::($block_obj,block_name)
   set blk_x0 $block::($block_obj,x_orig)
   set blk_y0 $block::($block_obj,y_orig)
   set blk_height $block::($block_obj,blk_h)
   set blk_width $block::($block_obj,blk_w)
   incr cur_ind ;#<07-29-09 wbh>
   if { $enable_last_flag && $cur_ind == $len_evt_list } \
   {
    if { $y > $blk_height && $y < [expr $blk_height + $rect_region] && \
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
    }
    continue
   }
   if { !$post_flag } \
   {
    if { [string compare $event_name $block::($block_obj,blk_owner)] != 0 } \
    {
     set Page::($page_obj,add_blk) 0
     continue
    }
   } else \
   {
    if { [string compare $event_name $block::($block_obj,blk_owner)] != 0 && \
    [string compare "post" $block::($block_obj,blk_owner)] != 0 } \
    {
     set Page::($page_obj,add_blk) 0
     continue
    }
   }
   if {$Page::($page_obj,source_evt_elem_obj) != 0} \
   {
    set source_evt_elem_obj $Page::($page_obj,source_evt_elem_obj)
    set source_blk_obj $event_element::($source_evt_elem_obj,block_obj)
    if { [llength $block::($source_blk_obj,active_blk_elem_list)] == 1 && \
    $elem_obj == $source_evt_elem_obj } \
    {
     set Page::($page_obj,add_blk) 0
     continue
    }
   }
   set special_flag 0
   if $post_flag \
   {
    if { [string match "just_mcall_sinumerik" $block::($block_obj,block_name)] || \
    [string compare "post" $block::($block_obj,blk_owner)] == 0 } \
    {
     set special_flag 1
    }
   }
   if $special_flag \
   {
    if {$y > [expr $blk_y0 - $rect_region] && $y < $blk_y0 && \
     $x > [expr $blk_x0 - [expr 6 * $rect_region]] && \
    $x < [expr $blk_width + [expr 6 * $rect_region]]} \
    {
     if {$block::($block_obj,active_blk_elem_list) == ""} \
     {
      set Page::($page_obj,add_blk) 0
      continue
     }
     UI_PB_tpth_HighLightTopSeperator page_obj elem_obj
     break
     } elseif { $post_flag == 1 && \
     $y > $blk_height && $y < [expr $blk_height + $rect_region] && \
     $x > [expr $blk_x0 - [expr 6 * $rect_region]] && \
    $x < [expr $blk_width + [expr 6 * $rect_region]]} \
    {
     if {$block::($block_obj,active_blk_elem_list) == ""} \
     {
      set Page::($page_obj,add_blk) 0
      continue
     }
     UI_PB_tpth_HighLightBottomSeperator page_obj elem_obj
     break
    }
    continue
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
     $block::($block_obj,blk_type) == "comment" || \
    $block::($block_obj,blk_type) == "macro" } \
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
     } elseif { $sel_addr == "Macro" && \
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
  if [info exists Page::($page_obj,box)] \
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
  "UI_PB_tpth_CancelCallBack $seq_page_obj $page_obj $event_obj"
  set cb_arr(gPB(nav_button,ok,Label)) \
  "UI_PB_tpth_OkCallBack $page_obj $seq_page_obj $seq_obj $event_obj"
  UI_PB_com_CreateButtonBox $box2_frm second_list cb_arr
 }

#=======================================================================
proc UI_PB_tpth_DeleteDummyBlock { PAGE_OBJ EVENT_OBJ } {
  upvar $PAGE_OBJ page_obj
  upvar $EVENT_OBJ event_obj
  if { [llength $event::($event_obj,evt_elem_list)] == 1 } \
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
     PB_com_DeleteObject $block_obj
     PB_com_DeleteObject $evt_elem_obj
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
proc X__tpth_UpdateSequenceEvent { SEQ_PAGE_OBJ SEQ_OBJ EVENT_OBJ} {
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
proc __tpth_UpdateSequenceEvent { SEQ_PAGE_OBJ SEQ_OBJ EVENT_OBJ} {
  upvar $SEQ_PAGE_OBJ seq_page_obj
  upvar $SEQ_OBJ seq_obj
  upvar $EVENT_OBJ event_obj
  set active_evt_index -1
  UI_PB_evt_TransformEvtElem seq_page_obj seq_obj active_evt_index
  PB_int_RetCycleComAndSharedEvts cycle_com_evt cycle_shared_evts
 }

#=======================================================================
proc __Validate_tpth_Data { page_obj } {
  global mom_kin_var
  global mom_sys_arr
  set page_name $Page::($page_obj,page_name)
  set ent_var_list [list]
  switch -exact $page_name {
   "tool_change" \
   {
    lappend ent_var_list "mom_sys_arr(\$mom_sys_tool_change_code)" \
    "mom_sys_arr(\$mom_sys_head_code(INDEPENDENT))" \
    "mom_sys_arr(\$mom_sys_head_code(DEPENDENT))" \
    "mom_sys_arr(\$mom_sys_turret_index(INDEPENDENT))" \
    "mom_sys_arr(\$mom_sys_turret_index(DEPENDENT))" \
    "mom_kin_var(\$mom_kin_tool_change_time)" \
    "mom_sys_arr(\$tl_retract_z_pos)"
   }
   "length_compensation" \
   {
    lappend ent_var_list "mom_sys_arr(\$mom_sys_adjust_code)"
   }
   "set_modes" \
   {
    lappend ent_var_list "mom_sys_arr(\$mom_sys_output_code(ABSOLUTE))" \
    "mom_sys_arr(\$mom_sys_output_code(INCREMENTAL))"
   }
   "spindle_rpm" \
   {
    lappend ent_var_list "mom_sys_arr(\$mom_sys_spindle_direction_code(CLW))" \
    "mom_sys_arr(\$mom_sys_spindle_direction_code(CCLW))"
   }
   "spindle_css" \
   {
    lappend ent_var_list "mom_sys_arr(\$mom_sys_spindle_mode_code(SFM))" \
    "mom_sys_arr(\$mom_sys_spindle_max_rpm_code)" \
    "mom_sys_arr(\$mom_sys_spindle_cancel_sfm_code)" \
    "mom_sys_arr(\$css_max_rpm)"
   }
   "spindle_off" \
   {
    lappend ent_var_list "mom_sys_arr(\$mom_sys_spindle_direction_code(OFF))"
   }
   "coolant_on" \
   {
    lappend ent_var_list "mom_sys_arr(\$mom_sys_coolant_code(ON))" \
    "mom_sys_arr(\$mom_sys_coolant_code(FLOOD))" \
    "mom_sys_arr(\$mom_sys_coolant_code(MIST))" \
    "mom_sys_arr(\$mom_sys_coolant_code(THRU))" \
    "mom_sys_arr(\$mom_sys_coolant_code(TAP))"
   }
   "coolant_off" \
   {
    lappend ent_var_list "mom_sys_arr(\$mom_sys_coolant_code(OFF))"
   }
   "delay" \
   {
    lappend ent_var_list "mom_sys_arr(\$mom_sys_delay_code(SECONDS))" \
    "mom_sys_arr(\$mom_sys_delay_code(REVOLUTIONS))"
   }
   "inch_metric_mode" \
   {
    lappend ent_var_list "mom_sys_arr(\$mom_sys_unit_code(IN))" \
    "mom_sys_arr(\$mom_sys_unit_code(MM))"
   }
   "feedrates" \
   {
    lappend ent_var_list "mom_sys_arr(\$mom_sys_feed_rate_mode_code(IPM))" \
    "mom_sys_arr(\$mom_sys_feed_rate_mode_code(MMPM))" \
    "mom_kin_var(\$mom_kin_max_fpm)" \
    "mom_kin_var(\$mom_kin_min_fpm)" \
    "mom_sys_arr(\$mom_sys_feed_rate_mode_code(IPR))" \
    "mom_sys_arr(\$mom_sys_feed_rate_mode_code(MMPR))" \
    "mom_kin_var(\$mom_kin_max_fpr)" \
    "mom_kin_var(\$mom_kin_min_fpr)" \
    "mom_sys_arr(\$mom_sys_feed_rate_mode_code(FRN))" \
    "mom_kin_var(\$mom_kin_max_frn)" \
    "mom_kin_var(\$mom_kin_min_frn)" \
    "mom_sys_arr(\$mom_sys_feed_rate_mode_code(DPM))" \
    "mom_kin_var(\$mom_kin_max_dpm)" \
    "mom_kin_var(\$mom_kin_min_dpm)"
   }
   "cutcom_on" \
   {
    lappend ent_var_list "mom_sys_arr(\$mom_sys_cutcom_code(LEFT))" \
    "mom_sys_arr(\$mom_sys_cutcom_code(RIGHT))"
   }
   "cutcom_off" \
   {
    lappend ent_var_list "mom_sys_arr(\$mom_sys_cutcom_code(OFF))"
   }
   "linear_move" \
   {
    lappend ent_var_list "mom_sys_arr(\$mom_sys_linear_code)"
   }
   "circular_move" \
   {
    lappend ent_var_list "mom_sys_arr(\$mom_sys_circle_code(CLW))" \
    "mom_sys_arr(\$mom_sys_circle_code(CCLW))" \
    "mom_kin_var(\$mom_kin_min_arc_radius)" \
    "mom_kin_var(\$mom_kin_max_arc_radius)" \
    "mom_kin_var(\$mom_kin_min_arc_length)"
   }
   "rapid_move" \
   {
    lappend ent_var_list "mom_sys_arr(\$mom_sys_rapid_code)"
   }
   "lathe_thread" \
   {
    lappend ent_var_list "mom_sys_arr(\$mom_sys_lathe_thread_advance_type(1))" \
    "mom_sys_arr(\$mom_sys_lathe_thread_advance_type(2))" \
    "mom_sys_arr(\$mom_sys_lathe_thread_advance_type(3))"
   }
   "cycle_parameters" \
   {
    lappend ent_var_list "mom_sys_arr(\$mom_sys_cycle_start_code)" \
    "mom_sys_arr(\$mom_sys_cycle_off)" \
    "mom_sys_arr(\$mom_sys_cycle_drill_code)" \
    "mom_sys_arr(\$mom_sys_cycle_drill_dwell_code)" \
    "mom_sys_arr(\$mom_sys_cycle_drill_deep_code)" \
    "mom_sys_arr(\$mom_sys_cycle_drill_break_chip_code)" \
    "mom_sys_arr(\$mom_sys_cycle_tap_code)" \
    "mom_sys_arr(\$mom_sys_cycle_bore_code)" \
    "mom_sys_arr(\$mom_sys_cycle_bore_drag_code)" \
    "mom_sys_arr(\$mom_sys_cycle_bore_no_drag_code)" \
    "mom_sys_arr(\$mom_sys_cycle_bore_manual_code)" \
    "mom_sys_arr(\$mom_sys_cycle_bore_dwell_code)" \
    "mom_sys_arr(\$mom_sys_cycle_bore_back_code)" \
    "mom_sys_arr(\$mom_sys_cycle_bore_manual_dwell_code)"
   }
  }
  if { [llength $ent_var_list] } {
   foreach var $ent_var_list {
    set var [string trim $var]
    if { [info exists $var] } {
     if { ![string compare [string trim [set $var]] ""] } {
      return 1
     }
    }
   }
  }
  return 0
 }

#=======================================================================
proc UI_PB_tpth_ApplyCallBack { page_obj seq_page_obj seq_obj event_obj } {
  global mom_sys_arr
  global mom_kin_var
  global paOption
  global gPB
  if {[__Validate_tpth_Data $page_obj]} {
   tk_messageBox -parent [UI_PB_com_AskActiveWindow] \
   -message "$gPB(machine,empty_entry_err,msg)" \
   -icon error
   return 1
  }
  set Page::($page_obj,event_apply_cb) 1
  UI_PB_tpth_DeleteDummyBlock page_obj event_obj
  if {$Page::($seq_page_obj,active_seq) == $seq_obj} \
  {
   UI_PB_tpth_DeleteTpthBlock seq_page_obj event_obj
  }
  UI_PB_tpth_DeleteApplyEvtElems seq_page_obj event_obj
  set length [llength $event::($event_obj,evt_elem_list)]
  set event::($event_obj,block_nof_rows) $length
  if [llength $event::($event_obj,evt_elem_list)] \
  {
   array set event_rest_data $event::($event_obj,rest_value)
   foreach elem_obj $event::($event_obj,evt_elem_list) \
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
     if { ![info exists address::($add_obj,blk_elem_list)] || \
      [lsearch $address::($add_obj,blk_elem_list) $blk_elm_obj] < 0 } {
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
   __tpth_UpdateSequenceEvent seq_page_obj seq_obj event_obj
  }
  event::RestoreValue $event_obj
  __tpth_RestoreEventData page_obj event_obj
  foreach evt_elem $event::($event_obj,evt_elem_list) {
   set cmd_obj $event_element::($evt_elem,exec_condition_obj)
   if { $cmd_obj == 0 } { continue }
   set command::($cmd_obj,condition_flag) 1
  }
  set event::($event_obj,applied) 1
  update idletasks
  set Page::($page_obj,event_apply_cb) 0
  return 0
 }

#=======================================================================
proc UI_PB_tpth_OkCallBack { page_obj seq_page_obj seq_obj event_obj } {
  if { [UI_PB_tpth_ApplyCallBack $page_obj $seq_page_obj $seq_obj $event_obj] } {
   return
  }
  UI_PB_tpth_UnsetTpthEvtBlkAttr event_obj
  set event::($event_obj,event_open) 0
  destroy $Page::($page_obj,page_id)
  PB_com_DeleteObject $page_obj
  global gPB
  foreach item [array names gPB "tool_path_event,*"] {
   unset gPB($item)
  }
 }

#=======================================================================
proc UI_PB_tpth_CancelCallBack { seq_page_obj page_obj event_obj } {
  global mom_sys_arr
  global mom_kin_var
  UI_PB_tpth_DeleteDummyBlock page_obj event_obj
  set evt_name $event::($event_obj,event_name)
  PB_int_RetCycleComAndSharedEvts cycle_com_evt cycle_shared_evts
  lappend cycle_shared_evts $cycle_com_evt
  if { [lsearch $cycle_shared_evts $evt_name] >= 0 } {
   UI_PB_tpth_RestoreCallBack $page_obj $event_obj
   } else {
   UI_PB_tpth_RestoreCallBack $page_obj $event_obj NO_GUI
  }
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
      set mom_sys_arr($mom_var) $rest_evt_mom_var($mom_var)
     }
    }
   }
  } ;# if 0
  UI_PB_tpth_UnsetTpthEvtBlkAttr event_obj
  set event::($event_obj,event_open) 0
  destroy $Page::($page_obj,page_id)
  PB_com_DeleteObject $page_obj
  update idletasks
  global gPB
  foreach item [array names gPB "tool_path_event,*"] {
   unset gPB($item)
  }
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
    PB_com_DeleteObject $elem_obj
    if { $block::($block_obj,blk_type) == "normal" } \
    {
     PB_int_RemoveBlkObjFrmList block_obj
     } elseif { $block::($block_obj,blk_type) == "comment" } \
    {
     PB_int_DeleteCommentBlkFromList block_obj
    }
    PB_com_DeleteObject $block_obj
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
  global gPB
  if { $mom_sys_arr(\$cycle_start_blk) } \
  {
   if { [PB_com_IsSiemensController $gPB(post_controller_type) 1] || \
   [PB_com_IsHeidenhainController $gPB(post_controller_type)] } \
   {
    set cur_evt_name $event::($event_obj,event_name)
    PB_int_RetCycleComAndSharedEvts cycle_com_evt cycle_shared_evts
    if { [string compare $cur_evt_name $cycle_com_evt] == 0 } \
    {
     UI_PB_tpth_AdjustPreviousBlkForCycleStartBlk $page_obj $event_obj
    }
   }
  }
  UI_PB_tpth_CreateEventBlockTemplates page_obj event_obj
 }

#=======================================================================
proc UI_PB_tpth_RestoreCallBack { page_obj event_obj args } {
  global mom_sys_arr
  global mom_kin_var
  global disable_IJK_message_box
  if { ![info exists event::($event_obj,rest_value)] } \
  {
   return
  }
  set redraw_flag 0
  if $event::($event_obj,canvas_flag) \
  {
   if { [llength $args] && [lindex $args 0] == "NO_GUI" } {
    } else {
    UI_PB_tpth_DeleteTpthEventBlkAttr page_obj event_obj
   }
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
   if [llength $event::($event_obj,evt_elem_list)] \
   {
    foreach elem_obj $event::($event_obj,evt_elem_list) \
    {
     if [info exists event_element::($elem_obj,rest_value)] \
     {
      array set evt_elem_obj_attr $event_element::($elem_obj,rest_value)
      event_element::setvalue $elem_obj evt_elem_obj_attr
      unset evt_elem_obj_attr
      set block_obj $event_element::($elem_obj,block_obj)
      if [info exists block::($block_obj,rest_value)] {
       array set blk_obj_attr $block::($block_obj,rest_value)
       block::setvalue $block_obj blk_obj_attr
       unset blk_obj_attr
      }
      block::AddToEventElemList $block_obj elem_obj
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
   if { [llength $args] && [lindex $args 0] == "NO_GUI" } {
    } else {
    UI_PB_tpth_CreateElemObjects page_obj event_obj
    set redraw_flag 1
   }
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
     if {[string match "\$mom*" $mom_var]} \
     {
      if { ![string compare $mom_var "\$mom_sys_cir_vector"] } {
       set disable_IJK_message_box 1
      }
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
  if $redraw_flag \
  {
   global gPB
   if { $mom_sys_arr(\$cycle_start_blk) } \
   {
    if { [PB_com_IsSiemensController $gPB(post_controller_type) 1] || \
    [PB_com_IsHeidenhainController $gPB(post_controller_type)] } \
    {
     set cur_evt_name $event::($event_obj,event_name)
     PB_int_RetCycleComAndSharedEvts cycle_com_evt cycle_shared_evts
     if { [string compare $cur_evt_name $cycle_com_evt] == 0 } \
     {
      UI_PB_tpth_AdjustPreviousBlkForCycleStartBlk $page_obj $event_obj
     }
    }
   }
   UI_PB_tpth_CreateEventBlockTemplates page_obj event_obj
  }
  if { [info exists disable_IJK_message_box] } {
   unset disable_IJK_message_box
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
    PB_com_DeleteObject $elem_obj
    continue
    } else {
    set event_obj $event_element::($elem_obj,event_obj)
    if { ![string length $event_obj] || !$event_obj } {
     continue
    }
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
     PB_com_DeleteObject $elem_obj
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
     PB_com_DeleteObject $elem_obj
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
     PB_com_DeleteObject $block_obj
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
   __tpth_UpdateSequenceEvent seq_page_obj seq_obj event_obj
  }
  set Page::($page_obj,active_blk_elem) 0
  __tpth_RestoreEventData page_obj event_obj
 }

#=======================================================================
proc UI_PB_tpth_CycleRapidBlks { page_obj event_obj member_obj args } {
  global mom_sys_arr
  set cycle_blk_name "post_rapidto"
  if [string match "$mom_sys_arr(\$cycle_rapto_opt)" $event::($event_obj,cycle_rapid_to)] {
   return
  }
  if { [string match "*R" $event::($event_obj,cycle_rapid_to)]  && \
   [string match "*R" $mom_sys_arr(\$cycle_rapto_opt)] } {
   PB_int_RetPostBlocks post_blk_list
   set blk_name post_cycle_set
   PB_com_RetObjFrmName blk_name post_blk_list blk_obj
   foreach blk_elem $block::($blk_obj,elem_addr_list) {
    block_element::readvalue $blk_elem blk_elem_obj_attr
    set elem_add_obj   $blk_elem_obj_attr(0)
    if [string match "R" $address::($elem_add_obj,add_name)] {
     set event::($event_obj,blk_elem_R) $blk_elem
    }
   }
  }
  UI_PB_tpth_UpdateCycleSetEvent page_obj event_obj cycle_blk_name
  PB_int_CreateCycleRaptoBlks event_obj mom_sys_arr
  UI_PB_tpth_CreateEventBlockTemplates page_obj event_obj
  set event::($event_obj,cycle_rapid_to) $mom_sys_arr(\$cycle_rapto_opt)
 }

#=======================================================================
proc UI_PB_tpth_CycleRetractBlks { page_obj event_obj member_obj args } {
  global mom_sys_arr
  set cycle_blk_name "post_retracto"
  if [string match "$mom_sys_arr(\$cycle_recto_opt)" $event::($event_obj,cycle_retract_to)] {
   return
  }
  UI_PB_tpth_UpdateCycleSetEvent page_obj event_obj cycle_blk_name
  PB_int_CreateCycleRetractoBlks event_obj mom_sys_arr
  UI_PB_tpth_CreateEventBlockTemplates page_obj event_obj
  set event::($event_obj,cycle_retract_to) $mom_sys_arr(\$cycle_recto_opt)
 }

#=======================================================================
proc UI_PB_tpth_CycleStartBlks { page_obj event_obj member_obj args } {
  global mom_sys_arr
  set cycle_blk_name "post_startblk"
  set strt_flag 0
  if { [info exists mom_sys_arr(post_startblk)] && \
  ![string match "" $mom_sys_arr(post_startblk)] } \
  {
   set cycle_blk_name $mom_sys_arr(post_startblk)
  }
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
   if { [PB_com_IsSiemensController $::gPB(post_controller_type) 1] } \
   {
    set break_flag 0
    set temp_index 0
    foreach evt_elem_obj $event::($event_obj,evt_elem_list) \
    {
     set block_obj $event_element::($evt_elem_obj,block_obj)
     if { ![string match "normal" $block::($block_obj,blk_type)] } \
     {
      incr temp_index
      continue
     }
     foreach blk_elem_obj $block::($block_obj,elem_addr_list) \
     {
      set add_obj $block_element::($blk_elem_obj,elem_add_obj)
      set add_name $address::($add_obj,add_name)
      if { [string match "X" $add_name] || [string match "Y" $add_name] || \
       [string match "Z" $add_name] || [string match "fourth_axis" $add_name] || \
      [string match "fifth_axis" $add_name] } \
      {
       set break_flag 1
       break
      }
     }
     if { $break_flag } \
     {
      set strt_blk_index $temp_index
      break
     }
     incr temp_index
    }
   }
  }
  PB_int_CreateCycleStartBlks event_obj mom_sys_arr strt_blk_index
  UI_PB_tpth_AdjustPreviousBlkForCycleStartBlk $page_obj $event_obj
  UI_PB_tpth_CreateEventBlockTemplates page_obj event_obj
  set event::($event_obj,cycle_start_blk) $mom_sys_arr(\$cycle_start_blk)
 }

#=======================================================================
proc UI_PB_tpth_AdjustPreviousBlkForCycleStartBlk { page_obj event_obj } {
  global gPB mom_sys_arr
  if { ![PB_com_IsSiemensController $gPB(post_controller_type) 1] && \
  ![PB_com_IsHeidenhainController $gPB(post_controller_type)] } \
  {
   return
  }
  set flag $mom_sys_arr(\$cycle_start_blk)
  set evt_elem_list $event::($event_obj,evt_elem_list)
  set len [llength $evt_elem_list]
  if $flag \
  {
   set head_elem_obj [lindex $evt_elem_list 0]
   set block_obj $event_element::($head_elem_obj,block_obj)
   if { ![llength $block::($block_obj,elem_addr_list)] } \
   {
    set bot_canvas $Page::($page_obj,bot_canvas)
    UI_PB_blk_DeleteCellsIcons page_obj block_obj
    if { $block::($block_obj,sep_id) != "" } \
    {
     $bot_canvas delete [lindex $block::($block_obj,sep_id) 0]
     $bot_canvas delete [lindex $block::($block_obj,sep_id) 1]
     set block::($block_obj,sep_id) ""
    }
    PB_com_DeleteObject $block_obj
    UI_PB_tpth_AddVirtaulMCallBlock mcall_blk_obj mcall_blk_elem
    set block_element::($mcall_blk_elem,owner) "post"
    set block::($mcall_blk_obj,blk_owner) $event::($event_obj,event_name)
    set event_element::($head_elem_obj,block_obj) $mcall_blk_obj
   } else \
   {
    set i 0
    foreach evt_elem $evt_elem_list \
    {
     set block_obj $event_element::($evt_elem,block_obj)
     if [string match "just_mcall_sinumerik" $block::($block_obj,block_name)] \
     {
      return
     } elseif [string match "post_startblk" $block::($block_obj,block_name)] \
     {
      break
      } elseif { [info exists mom_sys_arr(post_startblk)] && \
     [string match $mom_sys_arr(post_startblk) $block::($block_obj,block_name)] } \
     { ;#<06-08-09 wbh> add one case
      break
     }
     incr i
    }
    UI_PB_tpth_AddVirtaulMCallBlock mcall_blk_obj mcall_blk_elem
    set block_element::($mcall_blk_elem,owner) "post"
    set block::($mcall_blk_obj,blk_owner) $event::($event_obj,event_name)
    set evt_elem_obj_attr(0) "just_mcall_sinumerik"
    set evt_elem_obj_attr(1) $mcall_blk_obj
    set evt_elem_obj [new event_element]
    event_element::setvalue $evt_elem_obj evt_elem_obj_attr
    event_element::DefaultValue $evt_elem_obj evt_elem_obj_attr
    set event::($event_obj,evt_elem_list) [linsert $evt_elem_list $i $evt_elem_obj]
   }
  } else \
  {
   set i 0
   foreach evt_elem_obj $evt_elem_list \
   {
    set block_obj $event_element::($evt_elem_obj,block_obj)
    if { $block::($block_obj,block_name) == "just_mcall_sinumerik" } \
    {
     set bot_canvas $Page::($page_obj,bot_canvas)
     UI_PB_blk_DeleteCellsIcons page_obj block_obj
     if { $block::($block_obj,sep_id) != "" } \
     {
      $bot_canvas delete [lindex $block::($block_obj,sep_id) 0]
      $bot_canvas delete [lindex $block::($block_obj,sep_id) 1]
      set block::($block_obj,sep_id) ""
     }
     UI_PB_evt_DeleteEvtElem event_obj evt_elem_obj
     PB_int_RemoveBlkObjFrmList block_obj
     set event::($event_obj,evt_elem_list) [lreplace $evt_elem_list $i $i]
    }
    incr i
   }
   if { ![llength $event::($event_obj,evt_elem_list)] } \
   {
    set temp_event_name [split $Page::($page_obj,event_name)]
    set event_name [join $temp_event_name _ ]
    set event_name [string tolower $event_name]
    set block_name $event_name
    set block_name [PB_com_GetNextObjName $block_name block]
    set blk_elem_list ""
    set blk_owner $event::($event_obj,event_name)
    set blk_type "normal"
    PB_int_CreateNewBlock block_name blk_elem_list blk_owner  blk_obj blk_type
    PB_int_CreateNewEventElement blk_obj evt_elem $event_obj
    set block::($blk_obj,active_blk_elem_list) ""
    set temp_list [list]
    lappend temp_list $evt_elem
    set event::($event_obj,evt_elem_list) $temp_list
   }
  }
 }

#=======================================================================
proc UI_PB_tpth_AddVirtaulMCallBlock { BLK_OBJ BLK_ELEM } {
  upvar $BLK_OBJ blk_obj
  upvar $BLK_ELEM blk_elem
  global gPB post_object
  set macro_disp_name "MCALL CYCLE"
  if { [PB_com_IsHeidenhainController $gPB(post_controller_type)] } \
  {
   set macro_disp_name "CYCL DEF"
  }
  set elem_name "just_mcall_sinumerik"
  set function_blk_list $Post::($post_object,function_blk_list)
  PB_com_RetObjFrmName elem_name function_blk_list func_obj
  if { $func_obj == 0 } \
  {
   set func_obj [new function]
   set func_obj_attr(0) $elem_name
   set func_obj_attr(1) $macro_disp_name
   function::setvalue $func_obj func_obj_attr
   lappend Post::($post_object,function_blk_list) $func_obj
  }
  PB_blk_CreateFuncBlkElem elem_name func_obj blk_elem
  PB_blk_CreateFuncBlkObj  elem_name blk_elem blk_obj
 }

#=======================================================================
proc UI_PB_tpth_CyclePlaneElem { page_obj event_obj member_obj args } {
  global mom_sys_arr
  set cycle_blk_name "post_plane"
  if [string match "$mom_sys_arr(\$cycle_plane_control_opt)" $event::($event_obj,cycle_plane_control)] {
   return
  }
  UI_PB_tpth_UpdateCycleSetEvent page_obj event_obj cycle_blk_name
  PB_int_CreateCyclePlaneElems event_obj mom_sys_arr
  UI_PB_tpth_CreateEventBlockTemplates page_obj event_obj
  set event::($event_obj,cycle_plane_control) $mom_sys_arr(\$cycle_plane_control_opt)
 }

#=======================================================================
proc UI_PB_tpth_UpdateCycleSetEvent { PAGE_OBJ EVENT_OBJ CYCLE_BLK_NAME } {
  upvar $PAGE_OBJ page_obj
  upvar $EVENT_OBJ event_obj
  upvar $CYCLE_BLK_NAME cycle_blk_name
  if 0 {
   switch $cycle_blk_name {
    "post_rapidto"   {
     switch $event::($event_obj,cycle_rapid_to) {
      "None" {
      }
      "R" {
      }
      "Rapid_Traverse_&_R" {
      }
      "Rapid" {
      }
     }
    }
    "post_plane"     {
     switch $event::($event_obj,cycle_plane_control) {
      "None"        {
      }
      "G17/G18/G19" {
      }
     }
    }
    "post_retracto"  {
     switch $event::($event_obj,cycle_retract_to) {
      "K" \
      {
      }
      "G98/G99" \
      {
      }
      "Rapid_Spindle" \
      {
      }
      "Cycle_Off_then_Rapid_Spindle" \
      {
      }
     }
    }
    "post_startblk"  {
     switch $event::($event_obj,cycle_start_blk) {
      "1" {
      }
     }
    }
   }
   foreach evt_elem $event::($event_obj,evt_elem_list) {
    set blk_obj $event_element::($evt_elem,block_obj)
    UI_PB_debug_ForceMsg "Block   : $block::($blk_obj,block_name)\n\
    Owner   : $block::($blk_obj,blk_owner)"
    if [string match "$cycle_blk_name*" $block::($blk_obj,block_name)] {
     UI_PB_debug_ForceMsg ""
     UI_PB_debug_ForceMsg "*** $block::($blk_obj,block_name) ***\n\
     Owner   : $block::($blk_obj,blk_owner)"
     foreach blk_elem $block::($blk_obj,elem_addr_list) {
      block_element::readvalue $blk_elem blk_elem_obj_attr
      set elem_add_obj   $blk_elem_obj_attr(0)
      set elem_mom_var   $blk_elem_obj_attr(1)
      set elem_opt_nows  $blk_elem_obj_attr(2)
      set elem_desc      $blk_elem_obj_attr(3)
      set elem_force     $blk_elem_obj_attr(4)
      UI_PB_debug_ForceMsg "\n\
      Address : $address::($elem_add_obj,add_name)\n\
      MOM var : $elem_mom_var\n\
      Options : $elem_opt_nows\n\
      Desc    : $elem_desc\n\
      Force   : $elem_force"
     }
    }
   }
  }
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
   if [string match "$cycle_blk_name*" $block_name] \
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
     if [info exists blk_elem_list] \
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
    PB_com_DeleteObject $cyc_evt_elem_obj
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
   if { ![info exists block::($cyc_blk_obj,blk_owner)] || \
    $block::($cyc_blk_obj,blk_owner) == "post" || \
   $block::($cyc_blk_obj,blk_owner) == "$com_evt_name" } \
   {
    PB_com_DeleteObject $cyc_evt_elem_obj
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
     [string match "\$mom_sys_cycle*" $blk_elem_var] == 0 } \
     {
      } elseif { [string compare $blk_elem_owner "post"] == 0 && \
     [string match "\$mom_sys_cycle_ret_code*" $blk_elem_var] } \
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
  set evt_elem_attr(0) $block_name
  set evt_elem_attr(1) $blk_obj
  set evt_elem_attr(2) $event_element::($evt_elem_obj,exec_condition_obj)
  set evt_elem_attr(3) $event_element::($evt_elem_obj,suppress_flag)
  set evt_elem_attr(4) $event_element::($evt_elem_obj,force_addr_list)
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
  set special_flag 0
  if { [PB_com_IsSiemensController $::gPB(post_controller_type) 1] || \
  [PB_com_IsHeidenhainController $::gPB(post_controller_type)] } \
  {
   set special_flag 1
  }
  foreach evt_elem_obj $event::($cycle_evt_obj,evt_elem_list) \
  {
   set evt_blk $event_element::($evt_elem_obj,block_obj)
   set ret [PB_evt_CheckCycleRefWord evt_blk 1]
   if { $special_flag && \
    [info exists block::($evt_blk,use_once_flag)] && \
   $block::($evt_blk,use_once_flag) } \
   {
    unset block::($evt_blk,use_once_flag)
    set ret 1
   }
   if { $block::($evt_blk,blk_owner) == "$com_evt_name" || \
   $block::($evt_blk,blk_owner) == "post" } \
   {
    lappend def_cyc_evt_elem $evt_elem_obj
    } elseif { $ret } \
   {
    foreach cyc_evt_elem $def_cyc_evt_attr(2) \
    {
     if [info exists event_element::($cyc_evt_elem,block_obj)] \
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
        if [info exists block_element::($blk_elem,owner)] \
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
    set gcode "\$mom_sys_cycle_drill_break_chip_code"
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
      UI_PB_tpth_CustomizeOneCycleEvent cycle_evt_obj
      continue
     } ;# custom cycle
     UI_PB_tpth_DeleteComEvtBlkElems cycle_evt_obj current_evt_name
     UI_PB_tpth_AddCommonBlksToCycleEvent event_obj cycle_evt_obj
    } ;# foreach shared cycle event
    } else {
    set enable_flag 1
    set proc_level [info level]
    if { $proc_level > 2 } \
    {
     set proc_name [lindex [info level -2] 0]
     if [string match "UI_PB_tpth_ToolPath" $proc_name] \
     {
      set enable_flag 0
     }
    }
    if $enable_flag \
    {
     foreach cycle_event_name $cycle_shared_evts \
     {
      PB_com_RetObjFrmName cycle_event_name evt_obj_list cycle_evt_obj
      UI_PB_tpth_DeleteComEvtBlkElems cycle_evt_obj current_evt_name
      UI_PB_tpth_SetModalityAttrToCycleEvent cycle_evt_obj
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
proc UI_PB_tpth_CustomizeOneCycleEvent { CYCLE_EVT_OBJ } {
  upvar $CYCLE_EVT_OBJ cycle_evt_obj
  global post_object
  set cycle_event_name $event::($cycle_evt_obj,event_name)
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
      "macro" {
       set func_blk_elem  [lindex $block::($blk_obj,elem_addr_list) 0]
       set func_obj $block_element::($func_blk_elem,elem_mom_variable)
       set func_name $function::($func_obj,id)
       PB_int_CreateFuncBlkElem func_name new_blk_elem
       PB_int_CreateFuncBlk func_name new_blk_elem new_blk_obj
       if [info exists block_element::($func_blk_elem,func_prefix)] \
       {
        set block_element::($new_blk_elem,func_prefix) \
        $block_element::($func_blk_elem,func_prefix)
       }
       if [info exists block_element::($func_blk_elem,func_suppress_flag)] \
       {
        set block_element::($new_blk_elem,func_suppress_flag) \
        $block_element::($func_blk_elem,func_suppress_flag)
       }
       set blk_obj_list $Post::($post_object,function_blk_list)
       set block::($new_blk_obj,blk_type) "macro"
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
     if { [info exists evt_elem_attr] } {
      PB_int_CreateNewEventElementByAttr new_blk_obj new_evt_elem_obj evt_elem_attr
      PB_com_unset_var evt_elem_attr
      } else {
      PB_int_CreateNewEventElement new_blk_obj new_evt_elem_obj
     }
     event_element::readvalue $new_evt_elem_obj obj_attr
     event_element::DefaultValue $new_evt_elem_obj obj_attr
     lappend new_evt_elem_obj_list $new_evt_elem_obj
     set block::($new_blk_obj,active_blk_elem_list) $blk_elem_obj_list
     block::RestoreValue $new_blk_obj
     block::readvalue $new_blk_obj obj_attr
     block::DefaultValue $new_blk_obj obj_attr
     if [string match "$block::($blk_obj,block_name)" \
     $block::($new_blk_obj,block_name)] {
      set idx [lsearch $blk_obj_list $blk_obj]
      set blk_obj_list [lreplace $blk_obj_list $idx $idx]
     }
     switch $block_type {
      "command" {
       set Post::($post_object,cmd_obj_list) $blk_obj_list
      }
      "comment" {
       set Post::($post_object,comment_obj_list) $blk_obj_list
      }
      "macro" {
       set Post::($post_object,function_obj_list) $blk_obj_list
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
   if [info exists Post::($post_object,function_obj_list)] {
    PB_com_SortObjectsByNames Post::($post_object,function_obj_list)
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
 }

#=======================================================================
proc UI_PB_tpth_AddCommonBlksToCycleEvent { COM_EVT_OBJ CYCLE_EVT_OBJ } {
  upvar $COM_EVT_OBJ com_evt_obj
  upvar $CYCLE_EVT_OBJ cycle_evt_obj
  global post_object
  set cycle_com_evt $event::($com_evt_obj,event_name)
  set cycle_event_name $event::($cycle_evt_obj,event_name)
  set added_own_blks_flag 0
  set act_cyc_evt_elem [list]
  foreach evt_elem_obj $event::($com_evt_obj,evt_elem_list) \
  {
   set com_evt_blk $event_element::($evt_elem_obj,block_obj)
   set ret [PB_evt_CheckCycleRefWord com_evt_blk 1 MCALL]
   if {$ret == 0} \
   {
    UI_PB_tpth_CreateEvtElemFrmEvtObj evt_elem_obj new_evt_elem_obj cycle_evt_obj
    event_element::RestoreValue $new_evt_elem_obj
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
     if { $old_blk_obj > 0 } { ;#<12-28-01 gsl> > was >=.
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
     set new_evt_elem_attr(2) $event_element::($evt_elem_obj,exec_condition_obj)
     set new_evt_elem_attr(3) $event_element::($evt_elem_obj,suppress_flag)
     set new_evt_elem_attr(4) $event_element::($evt_elem_obj,force_addr_list)
     PB_int_CreateNewEventElementByAttr new_blk_obj new_evt_elem_obj new_evt_elem_attr
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
     event_element::RestoreValue $new_evt_elem_obj
     lappend act_cyc_evt_elem $new_evt_elem_obj
     foreach cyc_evt_elem $event::($cycle_evt_obj,evt_elem_list) \
     {
      lappend act_cyc_evt_elem $cyc_evt_elem
     }
     set added_own_blks_flag 1
    } else \
    {
     set first_flag 1
     foreach cyc_evt_elem $event::($cycle_evt_obj,evt_elem_list) \
     {
      set cyc_evt_blk $event_element::($cyc_evt_elem,block_obj)
      set ret_code [PB_evt_CheckCycleRefWord cyc_evt_blk 1]
      if { $ret_code == 1 } \
      {
       set event_element::($cyc_evt_elem,exec_condition_obj) \
       $event_element::($evt_elem_obj,exec_condition_obj)
       set event_element::($cyc_evt_elem,suppress_flag) \
       $event_element::($evt_elem_obj,suppress_flag)
       set event_element::($cyc_evt_elem,force_addr_list) \
       $event_element::($evt_elem_obj,force_addr_list)
       set cyc_elem_addr_list $block::($cyc_evt_blk,elem_addr_list)
       set dup_addr 1
       UI_PB_tpth_AddComBlkElemToBlk com_anc_blk \
       cyc_elem_addr_list current_evt_name dup_addr
       set block::($cyc_evt_blk,elem_addr_list) $cyc_elem_addr_list
       unset cyc_elem_addr_list
      }
      lappend act_cyc_evt_elem $cyc_evt_elem
      if $first_flag \
      {
       set evt_blk_obj $event_element::($cyc_evt_elem,block_obj)
       set block::($evt_blk_obj,use_once_flag) 1
       set first_flag 0
      }
     } ;# foreach event element
     set added_own_blks_flag 1
    } ;# Non-custom cycle
   } ;# Adding anchor block
  } ;# Adds the common blocks to the cycle event
  if !$added_own_blks_flag {
   set index -1
   set i 0
   foreach temp_evt_elem $act_cyc_evt_elem \
   {
    if [string match "post_startblk" $event_element::($temp_evt_elem,evt_elem_name)] \
    {
     set index $i
     break
    }
    incr i
   }
   foreach cyc_evt_elem $event::($cycle_evt_obj,evt_elem_list) \
   {
    if { $index >= 0 } \
    {
     set act_cyc_evt_elem [linsert $act_cyc_evt_elem $index $cyc_evt_elem]
     incr index
    } else \
    {
     lappend act_cyc_evt_elem $cyc_evt_elem
    }
   }
  }
  if [llength $act_cyc_evt_elem] \
  {
   set head_evt_elem [lindex $act_cyc_evt_elem 0]
   set head_blk_obj $event_element::($head_evt_elem,block_obj)
   if ![llength $block::($head_blk_obj,elem_addr_list)] \
   {
    set act_cyc_evt_elem [lreplace $act_cyc_evt_elem 0 0]
   }
  }
  set event::($cycle_evt_obj,evt_elem_list) $act_cyc_evt_elem
  UI_PB_tpth_SetModalityAttrToCycleEvent cycle_evt_obj
  event::RestoreValue $cycle_evt_obj
  if [info exists event::($cycle_evt_obj,custom_def)] {
   event::readvalue $cycle_evt_obj evt_attr
   set evt_attr(1) [llength $act_cyc_evt_elem]
   event::setvalue $cycle_evt_obj evt_attr
   event::DefaultValue $cycle_evt_obj evt_attr
   unset event::($cycle_evt_obj,custom_def)
   } else {
   UI_PB_tpth_UpdateDefsOfCycleEvent com_evt_obj cycle_evt_obj
  }
 }

#=======================================================================
proc UI_PB_tpth_SetModalityAttrToCycleEvent { CYCLE_EVT_OBJ } {
  upvar $CYCLE_EVT_OBJ cycle_evt_obj
  global gPB mom_sys_arr
  set flag $mom_sys_arr(\$cycle_start_blk)
  set act_cyc_evt_elem $event::($cycle_evt_obj,evt_elem_list)
  if [PB_com_IsSiemensController $gPB(post_controller_type) 1] \
  {
   foreach cyc_evt_elem $act_cyc_evt_elem \
   {
    set blk_obj $event_element::($cyc_evt_elem,block_obj)
    if [string match "macro" $block::($blk_obj,blk_type)] \
    {
     if $flag \
     {
      set blk_elem_obj [lindex $block::($blk_obj,elem_addr_list) 0]
      set block_element::($blk_elem_obj,func_prefix) "MCALL"
      set block_element::($blk_elem_obj,com_mcall_enable) 1
     } else \
     {
      set blk_elem_obj [lindex $block::($blk_obj,elem_addr_list) 0]
      if { [info exists block_element::($blk_elem_obj,com_mcall_enable)] && \
      $block_element::($blk_elem_obj,com_mcall_enable) } \
      {
       set block_element::($blk_elem_obj,com_mcall_enable) 0
       set block_element::($blk_elem_obj,func_prefix) ""
      }
     }
    }
   };#end foreach
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
  set h_cell $Page::($page_obj,h_cell)       ;# cell height
  set w_cell $Page::($page_obj,w_cell)       ;# cell width
  set w_divi $Page::($page_obj,w_divi)       ;# divider width
  set x_orig $block::($block_obj,x_orig)  ;# upper-left corner of 1st cell
  set y_orig $block::($block_obj,y_orig)
  set main_cell_color $paOption(can_bg)
  if [info exists block::($block_obj,wider_cell)] {
   set w_cell $block::($block_obj,wider_cell)
  }
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
  set x0 $x_orig
  set y0 [expr $y_orig - $w_divi]
  set x1 [expr $x0 + [expr [expr $w_divi + $w_cell] * $n_comp] + \
  $w_divi * 3]
  set y1 $y_orig
  lappend div_id [UI_PB_com_CreateRectangle $page_obj \
  $x0 $y0 $x1 $y1 \
  $main_cell_color $main_cell_color "" "stationary"]
  set y0 [expr $y_orig + $h_cell + $w_divi * 4]
  set y1 [expr $y0 + $w_divi]
  lappend div_id [UI_PB_com_CreateRectangle $page_obj \
  $x0 $y0 $x1 $y1 \
  $main_cell_color $main_cell_color "" "stationary"]
  set block::($block_obj,sep_id) $div_id
 }

#=======================================================================
proc UI_PB_tpth_CreateBlkElements { PAGE_OBJ EVENT_OBJ } {
  upvar $PAGE_OBJ page_obj
  upvar $EVENT_OBJ event_obj
  set event_name $event::($event_obj,event_name)
  if 0 {
   UI_PB_debug_ForceMsg "\n\
   ++++++\n\
   $event_name elements --> $event::($event_obj,evt_elem_list)\n\
   ++++++"
  }
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
   event_name $event_elem
   set Page::($page_obj,y_orig) [expr \
   $Page::($page_obj,y_orig) + $Page::($page_obj,blk_blkdist)]
  }
  UI_PB_tpth_IconBindProcs page_obj event_obj
 }

#=======================================================================
proc UI_PB_tpth_CreateExecAttrSymbols { PAGE_OBJ EVENT_ELEM } {
  upvar $PAGE_OBJ page_obj
  upvar $EVENT_ELEM evt_elem
  global gPB
  set bot_canvas $Page::($page_obj,bot_canvas)
  set block_obj $event_element::($evt_elem,block_obj)
  if { [info exists block::($block_obj,x_orig)] } {
   set x_orig $block::($block_obj,x_orig);
   set y_orig $block::($block_obj,y_orig);
   } else {
   set x_orig $Page::($page_obj,x_orig);
   set y_orig $Page::($page_obj,y_orig);
  }
  set w_divi $Page::($page_obj,w_divi);
  set h_cell $Page::($page_obj,h_cell);
  if { $event_element::($evt_elem,exec_condition_obj) > 0 } \
  {
   set x0 $x_orig
   set y0 [expr $y_orig + 2*$w_divi - 7] ;#<11-17-10 gsl> Add -7
   set x1 [expr $x0     + 2*$w_divi - 3] ;#<11-17-10 gsl> Add -1
   set y1 [expr $y0     + $h_cell/2 + 7]
   set cond_color $gPB(elem_condition_color)
   set block::($block_obj,cond_symb_rect) [UI_PB_com_CreateRectangle $page_obj \
   $x0 $y0 $x1 $y1 $cond_color $cond_color "" "whole_block"]
  }
  if { $event_element::($evt_elem,suppress_flag) } \
  {
   set x0 $x_orig
   set y0 [expr $y_orig + 2*$w_divi + $h_cell/2]
   set x1 [expr $x0     + 2*$w_divi - 3]
   set y1 [expr $y_orig + 2*$w_divi + $h_cell + 7]
   set supp_color $gPB(elem_suppress_color)
   set block::($block_obj,supp_symb_rect) [UI_PB_com_CreateRectangle $page_obj \
   $x0 $y0 $x1 $y1 $supp_color $supp_color "" "whole_block"]
  }
  update
 }

#=======================================================================
proc UI_PB_tpth_ReplaceExecAttrSymbols { PAGE_OBJ EVENT_ELEM type } {
  upvar $PAGE_OBJ page_obj
  upvar $EVENT_ELEM evt_elem
  global gPB
  if { [info exists Page::($page_obj,page_type)] && \
  [string match "seq" $Page::($page_obj,page_type)] } \
  {
   return
  }
  set bot_canvas $Page::($page_obj,bot_canvas)
  set block_obj $event_element::($evt_elem,block_obj)
  if { [info exists block::($block_obj,x_orig)] } {
   set x_orig $block::($block_obj,x_orig);
   set y_orig $block::($block_obj,y_orig);
   } else {
   set x_orig $Page::($page_obj,x_orig);
   set y_orig $Page::($page_obj,y_orig);
  }
  set w_divi $Page::($page_obj,w_divi);
  set h_cell $Page::($page_obj,h_cell);
  if { [string match "cond" $type] } \
  {
   if { $event_element::($evt_elem,exec_condition_obj) > 0 } \
   {
    if { [info exists block::($block_obj,cond_symb_rect)] && \
    $block::($block_obj,cond_symb_rect) != "" } \
    {
     $bot_canvas raise $block::($block_obj,cond_symb_rect)
     return
    }
    set x0 $x_orig
    set y0 [expr $y_orig + 2*$w_divi - 7] ;#<11-17-10 gsl> Add -7
    set x1 [expr $x0     + 2*$w_divi - 3] ;#<11-17-10 gsl> Add -1
    set y1 [expr $y0     + $h_cell/2 + 7]
    set cond_color $gPB(elem_condition_color)
    set block::($block_obj,cond_symb_rect) [UI_PB_com_CreateRectangle $page_obj \
    $x0 $y0 $x1 $y1 $cond_color $cond_color "" "whole_block"]
   } else \
   {
    if { [info exists block::($block_obj,cond_symb_rect)] && \
    $block::($block_obj,cond_symb_rect) != "" } \
    {
     $bot_canvas delete $block::($block_obj,cond_symb_rect)
     set block::($block_obj,cond_symb_rect) ""
    }
   }
   update
   return
  }
  if { [string match "suppress" $type] } \
  {
   if { $event_element::($evt_elem,suppress_flag) } \
   {
    if { [info exists block::($block_obj,supp_symb_rect)] && \
    $block::($block_obj,supp_symb_rect) != "" } \
    {
     $bot_canvas raise $block::($block_obj,supp_symb_rect)
     return
    }
    set x0 $x_orig
    set y0 [expr $y_orig + 2*$w_divi + $h_cell/2]
    set x1 [expr $x0     + 2*$w_divi - 3]
    set y1 [expr $y_orig + 2*$w_divi + $h_cell + 7]
    set supp_color $gPB(elem_suppress_color)
    set block::($block_obj,supp_symb_rect) [UI_PB_com_CreateRectangle $page_obj \
    $x0 $y0 $x1 $y1 $supp_color $supp_color "" "whole_block"]
   } else \
   {
    if { [info exists block::($block_obj,supp_symb_rect)] && \
    $block::($block_obj,supp_symb_rect) != "" } \
    {
     $bot_canvas delete $block::($block_obj,supp_symb_rect)
     set block::($block_obj,supp_symb_rect) ""
    }
   }
   update
   return
  }
 }

#=======================================================================
proc UI_PB_tpth_DeleteExecAttrSymbols { PAGE_OBJ BLOCK_OBJ } {
  upvar $PAGE_OBJ page_obj
  upvar $BLOCK_OBJ block_obj
  set bot_canvas $Page::($page_obj,bot_canvas)
  if { [info exists block::($block_obj,cond_symb_rect)] && \
  $block::($block_obj,cond_symb_rect) != "" } \
  {
   $bot_canvas delete $block::($block_obj,cond_symb_rect)
   set block::($block_obj,cond_symb_rect) ""
  }
  if { [info exists block::($block_obj,supp_symb_rect)] && \
  $block::($block_obj,supp_symb_rect) != "" } \
  {
   $bot_canvas delete $block::($block_obj,supp_symb_rect)
   set block::($block_obj,supp_symb_rect) ""
  }
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
  $bot_canvas bind whole_block <Enter>           "UI_PB_tpth_WholeBlkFocusOn      $page_obj $event_obj %x %y"
  $bot_canvas bind whole_block <Leave>           "UI_PB_tpth_WholeBlkFocusOff     $page_obj"
  $bot_canvas bind whole_block <1>               "UI_PB_tpth_WholeBlkStartDrag    $page_obj $event_obj %x %y"
  $bot_canvas bind whole_block <B1-Motion>       "UI_PB_tpth_WholeBlkDrag         $page_obj $event_obj %x %y %X %Y"
  $bot_canvas bind whole_block <ButtonRelease-1> "UI_PB_tpth_WholeBlkEndDrag      $page_obj $event_obj"
  $bot_canvas bind whole_block <3>               "UI_PB_tpth_WholeBlkRightButton  $page_obj $event_obj %x %y %X %Y"
  bind $bot_canvas <ButtonRelease-1>            "+UI_PB_blk_popup_close_cb $page_obj"
  bind $bot_canvas <3>                          "+UI_PB_blk_popup_close_cb $page_obj"
 }

#=======================================================================
proc UI_PB_tpth_GetEvtElemByPos { PAGE_OBJ EVENT_OBJ ACT_EVT_ELEM x y } {
  upvar $PAGE_OBJ page_obj
  upvar $EVENT_OBJ event_obj
  upvar $ACT_EVT_ELEM act_evt_elem
  set act_evt_elem 0
  set bot_canvas $Page::($page_obj,bot_canvas)
  set panel_hi $Page::($page_obj,panel_hi)
  set xc [$bot_canvas canvasx $x]
  set yc [$bot_canvas canvasy $y]
  UI_PB_ScrollCanvasWin $page_obj $xc $yc
  set xc [$bot_canvas canvasx $x]
  set yc [$bot_canvas canvasy $y]
  set event_elems $event::($event_obj,evt_elem_list)
  foreach elem_obj $event_elems {
   foreach elem $elem_obj {
    set block_obj $event_element::($elem,block_obj)
    set coord_list [$bot_canvas coords $block::($block_obj,rect)]
    set x0 [expr [lindex $coord_list 0] - 1]
    set y0 [expr [lindex $coord_list 1] - 1]
    set x1 [expr [lindex $coord_list 2] + 1]
    set y1 [expr [lindex $coord_list 3] + 1]
    if { $xc >= $x0 && $xc <= $x1 && $yc >= $y0 && $yc <= $y1 } {
     if { $block::($block_obj,active_blk_elem_list) == "" } {
      return 0
     }
     set act_evt_elem $elem
     set mid_y [expr [expr $y0 + $y1] / 2]
     set res 1
     if { $mid_y < $yc } {
      set res 2
     }
     return $res
    }
   }
  }
  return 0
 }

#=======================================================================
proc UI_PB_tpth_HighLightBlockRow { PAGE_OBJ EVT_ELEM_OBJ } {
  upvar $PAGE_OBJ page_obj
  upvar $EVT_ELEM_OBJ evt_elem_obj
  global paOption gPB
  set block_obj $event_element::($evt_elem_obj,block_obj)
  set bot_canvas $Page::($page_obj,bot_canvas)
  set high_color navyBlue
  $bot_canvas itemconfigure $block::($block_obj,rect)  -outline $high_color -fill $high_color
  set Page::($page_obj,add_blk) 0
  set gPB(highlight_whole_blk_flag) 1
 }

#=======================================================================
proc UI_PB_tpth_UnHighLightBlockRow { PAGE_OBJ EVT_ELEM_OBJ } {
  upvar $PAGE_OBJ page_obj
  upvar $EVT_ELEM_OBJ evt_elem_obj
  global gPB
  set block_obj $event_element::($evt_elem_obj,block_obj)
  set bot_canvas $Page::($page_obj,bot_canvas)
  set rect_color turquoise
  $bot_canvas itemconfigure $block::($block_obj,rect)  -outline $rect_color -fill $rect_color
  set Page::($page_obj,add_blk) 0
  set gPB(highlight_whole_blk_flag) 0
 }

#=======================================================================
proc UI_PB_tpth_WholeBlkFocusOn { page_obj event_obj x y } {
  global gPB
  if { [info exists gPB(DisableEnterCB)] && $gPB(DisableEnterCB) } { return }
  if { $Page::($page_obj,being_dragged) == 1 } { return }
  UI_PB_tpth_GetEvtElemByPos page_obj event_obj act_evt_elem $x $y
  if { $act_evt_elem == 0 } { return }
  if { ! [__CheckRefWordInBlock $event_obj $act_evt_elem "normal"] } {
   if { $Page::($page_obj,being_dragged) == 0 } {
    set bot_canvas $Page::($page_obj,bot_canvas)
    if { $gPB(use_info) } {
     $bot_canvas config -cursor question_arrow
     } else {
     $bot_canvas config -cursor hand2
    }
   }
  }
  UI_PB_tpth_HighLightBlockRow page_obj act_evt_elem
  set Page::($page_obj,focus_evt_elem_obj) $act_evt_elem
 }

#=======================================================================
proc UI_PB_tpth_WholeBlkFocusOff { page_obj } {
  global gPB
  if { $Page::($page_obj,being_dragged) == 0 } {
   set bot_canvas $Page::($page_obj,bot_canvas)
   $bot_canvas config -cursor ""
   } else {
   return
  }
  if { [info exists gPB(whole_blk_RB_flag)] && $gPB(whole_blk_RB_flag) } { return }
  if { [info exists gPB(highlight_whole_blk_flag)] && $gPB(highlight_whole_blk_flag) } {
   set focus_evt_elem $Page::($page_obj,focus_evt_elem_obj)
   UI_PB_tpth_UnHighLightBlockRow page_obj focus_evt_elem
  }
 }

#=======================================================================
proc UI_PB_tpth_WholeBlkStartDrag { page_obj event_obj x y } {
  UI_PB_tpth_GetEvtElemByPos page_obj event_obj act_evt_elem $x $y
  if { $act_evt_elem == 0 } { return }
  if { [__CheckRefWordInBlock $event_obj $act_evt_elem "normal"] } { return }
  set Page::($page_obj,being_dragged) 1
  set bot_canvas $Page::($page_obj,bot_canvas)
  $bot_canvas bind whole_block <3> ""
  set Page::($page_obj,source_evt_elem_obj) $act_evt_elem
  set Page::($page_obj,dest_evt_elem_obj) $act_evt_elem
  set Page::($page_obj,dest_evt_elem_add_type) 1
  set Page::($page_obj,ddblock_flag) 0
 }

#=======================================================================
proc UI_PB_tpth_WholeBlkDrag { page_obj event_obj x y X Y } {
  global paOption
  if { $Page::($page_obj,being_dragged) == 0 } { return }
  set bot_canvas $Page::($page_obj,bot_canvas)
  UI_PB_com_ChangeCursor $bot_canvas
  UI_PB_tpth_UnHighLightSep page_obj
  set src_evt_elem $Page::($page_obj,source_evt_elem_obj)
  UI_PB_tpth_HighLightBlockRow page_obj src_evt_elem
  set Page::($page_obj,add_blk)  0
  if { $Page::($page_obj,ddblock_flag) == 0 } {
   __GetPlainNCTextFromBlock $src_evt_elem blk_nc_code
   UI_PB_mthd_CreateDDBlock $X $Y eventblock_whole NULL NULL $blk_nc_code
   set Page::($page_obj,ddblock_flag) 1
   } else {
   set top_canvas $Page::($page_obj,top_canvas)
   set canvas_x [winfo rootx $top_canvas]
   set canvas_y [winfo rooty $top_canvas]
   set canvas_height [expr {[winfo height $bot_canvas] + [winfo height $top_canvas]}]
   set canvas_width  [expr {[winfo width  $bot_canvas]}]
   UI_PB_mthd_MoveDDBlock $X $Y eventblock_whole $canvas_x $canvas_y $canvas_height $canvas_width
  }
  UI_PB_blk_TrashFocusOn $page_obj $x $y
  set add_type [UI_PB_tpth_GetEvtElemByPos page_obj event_obj cur_evt_elem $x $y]
  if { $cur_evt_elem == 0 } {
   set Page::($page_obj,dest_evt_elem_obj) $src_evt_elem
   return
  }
  set Page::($page_obj,dest_evt_elem_obj) $cur_evt_elem
  set Page::($page_obj,dest_evt_elem_add_type) $add_type
  if { $cur_evt_elem == $src_evt_elem } { return }
  set cur_blk_obj $event_element::($cur_evt_elem,block_obj)
  if { [string match "post_startblk" $block::($cur_blk_obj,block_name)] } {
   set Page::($page_obj,dest_evt_elem_obj) $src_evt_elem
   return
  }
  set evt_elem_list $event::($event_obj,evt_elem_list)
  if { $add_type == 1 } {
   if { [__CheckRefWordInBlock $event_obj $cur_evt_elem "highlight"] } {
    set index [lsearch $evt_elem_list $cur_evt_elem]
    if { $index > 0 } {
     set prev_elem_obj [lindex $evt_elem_list [expr $index - 1]]
     if { [__CheckRefWordInBlock $event_obj $prev_elem_obj "highlight"] } {
      set Page::($page_obj,dest_evt_elem_obj) $src_evt_elem
      return
     }
    }
   }
   UI_PB_tpth_HighLightTopSeperator page_obj cur_evt_elem
   } else {
   if { [__CheckRefWordInBlock $event_obj $cur_evt_elem "highlight"] } {
    set index [lsearch $evt_elem_list $cur_evt_elem]
    set last_index [expr [llength $evt_elem_list] - 1]
    if { $index < $last_index } {
     set after_elem_obj [lindex $evt_elem_list [expr $index + 1]]
     if { [__CheckRefWordInBlock $event_obj $after_elem_obj "highlight"] } {
      set Page::($page_obj,dest_evt_elem_obj) $src_evt_elem
      return
     }
    }
   }
   UI_PB_tpth_HighLightBottomSeperator page_obj cur_evt_elem
  }
  set Page::($page_obj,add_blk) 0
 }

#=======================================================================
proc __GetPlainNCTextFromBlock { evt_elem_obj BLK_NC_CODE } {
  upvar $BLK_NC_CODE blk_nc_code
  global mom_sys_arr
  set blk_nc_code ""
  set block_obj $event_element::($evt_elem_obj,block_obj)
  set blk_type $block::($block_obj,blk_type)
  set blk_elem_list $block::($block_obj,active_blk_elem_list)
  switch $blk_type {
   normal   {
    UI_PB_com_ApplyMastSeqBlockElem blk_elem_list
    UI_PB_com_CreateBlkNcCode blk_elem_list blk_nc_code
   }
   comment  {
    set elem_obj [lindex $blk_elem_list 0]
    if { $mom_sys_arr(Comment_Start) != "" } {
     set tmp_string [PB_output_EscapeSpecialControlChar $mom_sys_arr(Comment_Start)]
     append blk_nc_code "$tmp_string"
    }
    set desc $block_element::($elem_obj,elem_mom_variable)
    set desc [PB_output_EscapeSpecialControlChar $desc]
    set desc [join [split $desc \$] \\\$]
    append blk_nc_code $desc
    if { $mom_sys_arr(Comment_End) != "" } {
     set tmp_string [PB_output_EscapeSpecialControlChar $mom_sys_arr(Comment_End)]
     append blk_nc_code "$tmp_string"
    }
   }
   command  {
    set cmd_elem_obj [lindex $blk_elem_list 0]
    set cmd_obj $block_element::($cmd_elem_obj,elem_mom_variable)
    if { [string match "*MOM_*" $cmd_obj] } {
     set blk_nc_code $cmd_obj
     } else {
     set blk_nc_code $command::($cmd_obj,name)
    }
   }
   macro    {
    set func_elem_obj [lindex $blk_elem_list 0]
    set func_obj $block_element::($func_elem_obj,elem_mom_variable)
    function::GetDisplayText $func_obj blk_nc_code
    if { [info exists block_element::($func_elem_obj,func_prefix)] && \
     $block_element::($func_elem_obj,func_prefix) != "" } {
     set temp_str $block_element::($func_elem_obj,func_prefix)
     append temp_str " " $blk_nc_code
     set blk_nc_code $temp_str
     unset temp_str
    }
   }
  }
 }

#=======================================================================
proc __CheckRefWordInBlock { event_obj evt_elem_obj check_type } {
  set evt_name $event::($event_obj,event_name)
  set block_obj $event_element::($evt_elem_obj,block_obj)
  if { [string match "highlight" $check_type] } {
   PB_int_RetCycleComAndSharedEvts cycle_com_evt cycle_shared_evts
   if { [string match "$cycle_com_evt" "$evt_name"] || \
    [lsearch $cycle_shared_evts "$evt_name"] >= 0 } {
    foreach blk_elem_obj $block::($block_obj,elem_addr_list) {
     set blk_elem_mom_variable $block_element::($blk_elem_obj,elem_mom_variable)
     if { [string match "\$mom_sys_cycle_reps_code" "$blk_elem_mom_variable"] || \
      [string match "\$mom_sys_cycle_drill_*" "$blk_elem_mom_variable"] || \
      [string match "\$mom_sys_cycle_bore_*" "$blk_elem_mom_variable"] || \
      [string match "\$mom_sys_cycle_tap_code" "$blk_elem_mom_variable"] } {
      return 0
     }
    }
   }
  }
  if { ! [string match "$evt_name" "$block::($block_obj,blk_owner)"] } {
   return 1
  }
  foreach blk_elem_obj $block::($block_obj,elem_addr_list) {
   if { [string match "post" "$block_element::($blk_elem_obj,owner)"] } {
    return 1
   }
  }
  return 0
 }

#=======================================================================
proc UI_PB_tpth_WholeBlkEndDrag { page_obj event_obj } {
  if { $Page::($page_obj,being_dragged) == 0 } { return }
  set Page::($page_obj,being_dragged) 0
  set bot_canvas $Page::($page_obj,bot_canvas)
  UI_PB_tpth_UnHighLightSep page_obj
  UI_PB_mthd_DestroyDDBlock
  set src_evt_elem $Page::($page_obj,source_evt_elem_obj)
  set des_evt_elem $Page::($page_obj,dest_evt_elem_obj)
  set add_type $Page::($page_obj,dest_evt_elem_add_type)
  if { $Page::($page_obj,trash_flag) } {
   CB__DeleteOneRow $page_obj $event_obj $src_evt_elem
   $bot_canvas bind whole_block <3> "UI_PB_tpth_WholeBlkRightButton  $page_obj $event_obj %x %y %X %Y"
   return
  }
  set reposition_flag 0
  if { $src_evt_elem != $des_evt_elem } {
   set src_indx [lsearch $event::($event_obj,evt_elem_list) $src_evt_elem]
   set des_indx [lsearch $event::($event_obj,evt_elem_list) $des_evt_elem]
   if { $add_type == 1 } {
    if { $src_indx != [expr $des_indx - 1] } {
     set reposition_flag 1
    }
    } elseif { $src_indx != [expr $des_indx + 1] } {
    set reposition_flag 1
   }
   if { $reposition_flag } {
    set new_list [lreplace $event::($event_obj,evt_elem_list) $src_indx $src_indx]
    if { $src_indx < $des_indx } {
     set des_indx [expr $des_indx - 1]
    }
    if { $add_type != 1 } {
     incr des_indx
    }
    set event::($event_obj,evt_elem_list) [linsert $new_list $des_indx $src_evt_elem]
    $bot_canvas delete all
    foreach evt_elem $event::($event_obj,evt_elem_list) {
     set blk_obj $event_element::($evt_elem,block_obj)
     set block::($blk_obj,elem_addr_list) $block::($blk_obj,active_blk_elem_list)
    }
    UI_PB_tpth_CreateEventBlockTemplates page_obj event_obj
   }
  }
  if { ! $reposition_flag } {
   UI_PB_tpth_UnHighLightBlockRow page_obj src_evt_elem
  }
  set Page::($page_obj,source_evt_elem_obj) 0
  set Page::($page_obj,dest_evt_elem_obj) 0
  $bot_canvas bind whole_block <3> "UI_PB_tpth_WholeBlkRightButton  $page_obj $event_obj %x %y %X %Y"
 }

#=======================================================================
proc UI_PB_tpth_WholeBlkRightButton { page_obj event_obj x y winX winY } {
  global gPB
  UI_PB_tpth_GetEvtElemByPos page_obj event_obj act_evt_elem $x $y
  if { $act_evt_elem == 0 } { return }
  set Page::($page_obj,in_focus_evt_elem) $act_evt_elem
  set block_obj $event_element::($act_evt_elem,block_obj)
  set blk_type $block::($block_obj,blk_type)
  set force_flag 0
  if { [string match "normal" $blk_type] } {
   set force_flag 1
  }
  set Page::($page_obj,active_blk_obj) $block_obj
  if { [info exists Page::($page_obj,force_show_popup_options)] && \
   $Page::($page_obj,force_show_popup_options) == 1 } {
   } elseif { [__CheckRefWordInBlock $event_obj $act_evt_elem "normal"] } {
   if { ! [string match "Rapid Move" "$event::($event_obj,event_name)"] } {
    set blk_type "NONE"
   }
  }
  set gPB(DisableEnterCB) 1
  set blockpopup $Page::($page_obj,blockpopup)
  $blockpopup delete 0 end
  if { $force_flag } {
   $blockpopup add command -label "$gPB(seq,force_popup,Label)" -state normal \
   -command "UI_PB_tpth_EvtBlockModality $page_obj $event_obj $act_evt_elem"
   $blockpopup add sep
  }
  UI_PB_tpth_AddPopupForWholeBlk $page_obj $event_obj $act_evt_elem blockpopup event $blk_type
  set gPB(whole_blk_RB_flag) 1
  tk_popup $blockpopup $winX $winY
  set gPB(whole_blk_RB_flag) 0
  UI_PB_tpth_WholeBlkFocusOff $page_obj
 }

#=======================================================================
proc UI_PB_tpth_EvtBlockModality { page_obj event_obj evt_elem } {
  global gPB paOption
  set bot_canvas $Page::($page_obj,bot_canvas)
  set canvas_frame $Page::($page_obj,canvas_frame)
  set win [toplevel $canvas_frame.mode]
  set toplevel_index [llength $gPB(toplevel_list)]
  set win_index [expr $toplevel_index + 1]
  set gPB(toplevel_disable_$win_index) 1
  UI_PB_com_CreateTransientWindow $win "$gPB(seq,force_trans,title,Label)" \
  "AT_CURSOR" "" "UI_PB_blk_DisableBlkPageWidgets $page_obj" \
  "UI_PB_blk_ModalityCancel_CB $win $page_obj $event_obj $evt_elem" \
  "UI_PB_blk_ActivateBlkPageWidgets $page_obj $win_index"
  wm maxsize $win 400 600
  UI_PB_blk_ModalityDialog page_obj event_obj evt_elem win
  UI_PB_com_PositionWindow $win
 }

#=======================================================================
proc UI_PB_tpth_AddPopupForWholeBlk { page_obj event_obj evt_elem \
  POPUPMENU page_type blk_type args } {
  upvar $POPUPMENU blockpopup
  global gPB
  global popupvar
  set Page::($page_obj,page_type) $page_type
  set condition_cmd $event_element::($evt_elem,exec_condition_obj)
  set exec_attr_flag 0
  if { [string match "normal" $blk_type] || \
   [string match "macro" $blk_type] } {
   set exec_attr_flag 1
  }
  if { $exec_attr_flag } {
   set state "normal"
   $blockpopup add cascade -label "$gPB(block,exec_cond,set,Label)" \
   -menu $blockpopup.exec_cond -state $state
   catch {destroy $blockpopup.exec_cond}
   menu $blockpopup.exec_cond
   set cond_menu $blockpopup.exec_cond
   set cmd_name "new_cmd"
   $cond_menu add command -label "$gPB(block,exec_cond,new,Label)" \
   -state $state \
   -command "CB__SetExecCondition $page_obj $event_obj $evt_elem $cmd_name"
   if { $condition_cmd == 0 } {
    set state "disabled"
   }
   set cmd_name "edit_cmd"
   $cond_menu add command -label "$gPB(block,exec_cond,edit,Label)" \
   -state $state \
   -command "CB__SetExecCondition $page_obj $event_obj $evt_elem $cmd_name"
   set cmd_name "remove_cmd"
   $cond_menu add command -label "$gPB(block,exec_cond,remove,Label)" \
   -state $state \
   -command "CB__SetExecCondition $page_obj $event_obj $evt_elem $cmd_name"
   $cond_menu add sep
   global post_object
   Post::GetObjList $post_object command cmd_obj_list
   foreach cmd_obj $cmd_obj_list {
    if { [string match "$gPB(condition_cmd_prefix)*" $command::($cmd_obj,name)] == 0 } {
     continue
    }
    set cmd_name $command::($cmd_obj,name)
    set state "normal"
    if { $cmd_obj == $condition_cmd } {
     set state "disabled"
    }
    $cond_menu add command -label "$cmd_name" -state $state \
    -command "CB__SetExecCondition $page_obj $event_obj $evt_elem $cmd_obj"
   }
   set state "normal"
   set popupvar(0) $event_element::($evt_elem,suppress_flag)
   $blockpopup add checkbutton -label "$gPB(block,suppress_popup,Label)" \
   -variable popupvar(0) -state $state \
   -command "CB__SuppressSeqNumber $page_obj popupvar $evt_elem"
   if { [string match "macro" $blk_type] } {
    set block_obj $event_element::($evt_elem,block_obj)
    set active_blk_elem [lindex $block::($block_obj,elem_addr_list) 0]
    if { ![info exists block_element::($active_blk_elem,func_prefix)] } {
     set block_element::($active_blk_elem,func_prefix) ""
    }
    if { $block_element::($active_blk_elem,func_prefix) == "" } {
     set popupvar(prefix) 0
     set state "disabled"
     } else {
     set popupvar(prefix) 1
     set state "normal"
    }
    set func_obj [UI_PB_func_GetFuncObjFrmBlkElem $active_blk_elem]
    $blockpopup add sep
    $blockpopup add checkbutton -label "$gPB(block,prefix_popup,add,Label)" \
    -variable popupvar(prefix) -state normal \
    -command "UI_PB_blk_EditFuncPrefix $page_obj $evt_elem $func_obj $active_blk_elem Add $args"
    $blockpopup add command -label "$gPB(block,prefix_popup,edit,Label)" \
    -state $state \
    -command "UI_PB_blk_EditFuncPrefix $page_obj $evt_elem $func_obj $active_blk_elem Edit $args"
   }
  }
  if { [string match "event" $page_type] } {
   if { $exec_attr_flag } {
    $blockpopup add sep
   }
   $blockpopup add command -label "$gPB(block,delete_row,Label)" \
   -command "CB__DeleteOneRow $page_obj $event_obj $evt_elem"
  }
 }

#=======================================================================
proc CB__SetExecCondition { page_obj event_obj evt_elem name_or_obj } {
  set block_obj $event_element::($evt_elem,block_obj)
  if { [string match "new_cmd" $name_or_obj] } {
   UI_PB_tpth_BringCmdPage page_obj event_obj evt_elem block_obj "Condition"
   return
  }
  if { [string match "event" $Page::($page_obj,page_type)] } {
   set tpth_page_flag 1
   } else {
   set tpth_page_flag 0
  }
  if { [string match "remove_cmd" $name_or_obj] } {
   set event_element::($evt_elem,exec_condition_obj) 0
   if { $tpth_page_flag } {
    UI_PB_tpth_ReplaceExecAttrSymbols page_obj evt_elem "cond"
    } else {
    UI_PB_evt_ReplaceExecAttrSymbols page_obj evt_elem "cond"
   }
   return
  }
  if { [string match "edit_cmd" $name_or_obj] } {
   set cmd_obj $event_element::($evt_elem,exec_condition_obj)
   if { $cmd_obj <= 0 } {
    tk_messageBox -parent [UI_PB_com_AskActiveWindow] -type ok -icon error \
    -message "The selected command did not exist!"
    set event_element::($evt_elem,exec_condition_obj) 0
    if { $tpth_page_flag } {
     UI_PB_tpth_ReplaceExecAttrSymbols page_obj evt_elem "cond"
     } else {
     UI_PB_evt_ReplaceExecAttrSymbols page_obj evt_elem "cond"
    }
    } else {
    UI_PB_tpth_BringCmdPage page_obj event_obj evt_elem block_obj "Condition_Edit"
   }
   return
  }
  set event_element::($evt_elem,exec_condition_obj) $name_or_obj
  set command::($name_or_obj,condition_flag) 1
  if { $tpth_page_flag } {
   UI_PB_tpth_ReplaceExecAttrSymbols page_obj evt_elem "cond"
   } else {
   UI_PB_evt_ReplaceExecAttrSymbols page_obj evt_elem "cond"
  }
 }

#=======================================================================
proc CB__SuppressSeqNumber { page_obj POPUPVAR evt_elem } {
  upvar $POPUPVAR popupvar
  set event_element::($evt_elem,suppress_flag) $popupvar(0)
  if { [string match "event" $Page::($page_obj,page_type)] } {
   UI_PB_tpth_ReplaceExecAttrSymbols page_obj evt_elem "suppress"
   } else {
   UI_PB_evt_ReplaceExecAttrSymbols page_obj evt_elem "suppress"
  }
 }

#=======================================================================
proc CB__DeleteOneRow { page_obj event_obj evt_elem } {
  global gPB
  set relief 0.002 ;# 4(pix)/2000(pix)
  set bot_canvas $Page::($page_obj,bot_canvas)
  $bot_canvas xview moveto $relief
  $bot_canvas yview moveto $relief
  update
  set evt_name $event::($event_obj,event_name)
  set blk_obj $event_element::($evt_elem,block_obj)
  foreach blk_elem_obj $block::($blk_obj,active_blk_elem_list) {
   if { ![string match "post" $block_element::($blk_elem_obj,owner)] } {
    if { [string match "Cycle Parameters" $evt_name] } {
     UI_PB_blk_DeleteBlockElement $page_obj $blk_elem_obj 0 0
     } elseif { ![string match "Cycle Parameters" \
     $block_element::($blk_elem_obj,owner)] } {
     UI_PB_blk_DeleteBlockElement $page_obj $blk_elem_obj 0 0
    }
   }
  }
  UI_PB_tpth_DeleteExecAttrSymbols page_obj blk_obj
  if [info exists gPB(DisableEnterCB)] { unset gPB(DisableEnterCB) }
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
  $bot_canvas bind whole_block <Enter>           ""
  $bot_canvas bind whole_block <Leave>           ""
  $bot_canvas bind whole_block <1>               ""
  $bot_canvas bind whole_block <ButtonRelease-1> ""
  $bot_canvas bind whole_block <3>               ""
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
proc UI_PB_tpth_BindRightButton { page_obj event_obj x y args } {
  set bot_canvas $Page::($page_obj,bot_canvas)
  UI_PB_tpth_StartDragBlk          $page_obj $event_obj $x $y
  UI_PB_tpth_EndDragBlk            $page_obj $event_obj
  UI_PB_tpth_BlkFocusOn $page_obj $event_obj $x $y
  set act_blk_elem $Page::($page_obj,in_focus_elem)
  if { $act_blk_elem <= 0 } { return }
  set act_evt_elem $Page::($page_obj,in_focus_evt_elem)
  set act_blk_obj $event_element::($act_evt_elem,block_obj)
  UI_PB_blk_SelectElement $page_obj $act_blk_elem
  UI_PB_blk_BlockPopupMenu page_obj event_obj act_blk_obj act_blk_elem $x $y $args
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
  if { $focus_evt_elem } {
   set Page::($page_obj,active_blk_obj) \
   $event_element::($focus_evt_elem,block_obj)
  }
  set c $bot_canvas
  if {$Page::($page_obj,active_blk_elem)} {
   set act_blk_elem_obj $Page::($page_obj,active_blk_elem)
   set icon_id $block_element::($act_blk_elem_obj,icon_id)
   $c raise $icon_id
   set im [$c itemconfigure $icon_id -image]
   set cur_img_tag [lindex [lindex [$c itemconfigure $icon_id -tags] end] 0]
   set ::gPB(cur_mov_img) [lindex $im end]
   if { ![string match "" [lindex $im end]] } {
    [lindex $im end] configure -relief sunken -bg $paOption(sunken_bg)
   }
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
   if [string match "Macro" $block_element::($focus_blk_elem,elem_add_obj)] \
   {
    UI_PB_blk_AdjustMacroText blk_elem_text $focus_blk_elem
   }
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
   set ::gPB(dummy,diff_x) int($diff_x)
   set ::gPB(dummy,diff_y) int($diff_y)
   set rootx [winfo rootx $bot_canvas]
   set rooty [winfo rooty $bot_canvas]
   set X [expr $rootx + int($x) - $::gPB(dummy,diff_x)]
   set Y [expr $rooty + int($y) - $::gPB(dummy,diff_y)]
   append opt_nows_force pb_ $block_element::($focus_blk_elem,elem_opt_nows_var)
   if { [lsearch $event_element::($focus_evt_elem,force_addr_list) \
    $block_element::($focus_blk_elem,elem_add_obj)] >= 0 } {
    append opt_nows_force _f
   }
   if { 0 && [expr {$block_element::($focus_blk_elem,force)==1}] } {
    append opt_nows_force  _f
   }
   UI_PB_mthd_CreateDDBlock $X $Y addressblock_up NULL $image_name $blk_elem_text $opt_nows_force
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
    $block_element::($act_blk_elem_obj,elem_add_obj) == "Comment" || \
   $block_element::($act_blk_elem_obj,elem_add_obj) == "Macro" } \
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
   if { ![string match "" [lindex $im end]] } {
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
  switch $::tix_version {
   8.4 {
    set dx 0
    set dy [expr $panel_hi + 0]
   }
   4.1 {
    set dx 1
    set dy [expr $panel_hi + 2]
   }
  }
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
  if [expr $focus_blk_elem > 0] {
   if { $block_element::($focus_blk_elem,elem_add_obj) == "Command" || \
    $block_element::($focus_blk_elem,elem_add_obj) == "Comment" || \
   $block_element::($focus_blk_elem,elem_add_obj) == "Macro" } \
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
  set canvas_x [winfo rootx $top_canvas]
  set canvas_y [winfo rooty $top_canvas]
  set canvas_height [expr {[winfo height $bot_canvas] + [winfo height $top_canvas]}]
  set canvas_width  [expr {[winfo width  $bot_canvas]}]
  set rootx [winfo rootx $bot_canvas]
  set rooty [winfo rooty $bot_canvas]
  set X [expr $rootx + int($x) - $::gPB(dummy,diff_x)]
  set Y [expr $rooty + int($y) - $::gPB(dummy,diff_y)]
  UI_PB_mthd_MoveDDBlock $X $Y addressblock_up $canvas_x $canvas_y $canvas_height $canvas_width
 }

#=======================================================================
proc UI_PB_tpth_EndDragBlk { page_obj event_obj } {
  global paOption
  set Page::($page_obj,being_dragged) 0
  set bot_canvas $Page::($page_obj,bot_canvas)
  UI_PB_tpth_UnHighLightSep page_obj
  UI_PB_mthd_DestroyDDBlock
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
  set force_addr_obj 0  ;#<10-28-10 wbh> force output address object
  if { $block::($source_blk_obj,blk_type) == "normal" || \
  $block::($source_blk_obj,blk_type) == "comment" } \
  {
   if { [string match "normal" $block::($source_blk_obj,blk_type)] } \
   {
    set force_addr_obj $block_element::($source_blk_elem_obj,elem_add_obj)
   }
   block::readvalue $add_to_blk_obj add_to_blk_obj_attr
   PB_int_CreateBlkElemFromElemObj source_blk_elem_obj new_blk_elem_obj \
   add_to_blk_obj_attr
   unset add_to_blk_obj_attr
   } elseif { $block::($source_blk_obj,blk_type) == "macro" } \
  {
   set func_elem $block_element::($source_blk_elem_obj,elem_mom_variable)
   set func_name $function::($func_elem,id)
   set func_obj  $func_elem
   PB_blk_CreateFuncBlkElem func_name func_obj new_blk_elem_obj
   if { [info exists block_element::($source_blk_elem_obj,func_prefix)] } \
   {
    set block_element::($new_blk_elem_obj,func_prefix) \
    $block_element::($source_blk_elem_obj,func_prefix)
   }
   if { [info exists block_element::($source_blk_elem_obj,func_suppress_flag)] } \
   {
    set block_element::($new_blk_elem_obj,func_suppress_flag) \
    $block_element::($source_blk_elem_obj,func_suppress_flag)
   }
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
  if { $force_addr_obj > 0 } \
  {
   set index [lsearch $event_element::($source_evt_elem_obj,force_addr_list) $force_addr_obj]
   if { $index >= 0 } \
   {
    set event_element::($source_evt_elem_obj,force_addr_list) \
    [lreplace $event_element::($source_evt_elem_obj,force_addr_list) $index $index]
   } else \
   {
    set force_addr_obj 0
   }
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
    if { $force_addr_obj > 0 } \
    {
     lappend event_element::($add_to_evt_elem,force_addr_list) $force_addr_obj
    }
   }
   "top" \
   {
    UI_PB_tpth_AddBlkElemTopOrBottom page_obj event_obj add_to_evt_elem \
    source_blk_elem_obj force_addr_obj
   }
   "bottom" \
   {
    UI_PB_tpth_AddBlkElemTopOrBottom page_obj event_obj add_to_evt_elem \
    source_blk_elem_obj force_addr_obj
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
   if { ![string match "" [lindex $im end]] } {
    if { $icon_tag == "nonmovable" } \
    {
     [lindex $im end] configure -relief flat -bg $paOption(raised_bg)
    } else \
    {
     [lindex $im end] configure -relief raised -bg $paOption(raised_bg)
    }
   }
   set Page::($page_obj,active_blk_elem) 0
  }
  UI_PB_tpth_BlkFocusOff $page_obj
  set source_blk_elem_obj $Page::($page_obj,source_blk_elem_obj)
  set evt_elem_obj $Page::($page_obj,source_evt_elem_obj)
  if [expr $evt_elem_obj > 0] {
   set block_obj $event_element::($evt_elem_obj,block_obj)
   set no_blk_elems [llength $block::($block_obj,active_blk_elem_list)]
   set source_cell_num [lsearch $block::($block_obj,active_blk_elem_list) \
   $source_blk_elem_obj]
   } else {
   set no_blk_elems 0
  }
  if [info exists block_element::($source_blk_elem_obj,elem_add_obj)] {
   set addr_obj $block_element::($source_blk_elem_obj,elem_add_obj)
   address::DeleteFromBlkElemList $addr_obj source_blk_elem_obj
  }
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
   event_name $temp_elem_obj
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
  UI_PB_evt_UpdateEvtElemForceOutputAttr $evt_elem_obj active
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
    event_name $new_evt_elem_obj
    set Page::($page_obj,active_blk_elem) 0
    return
   }
  } else \
  {
   set active_blk_elem_obj 0
  }
  if [llength $block::($block_obj,active_blk_elem_list)] \
  {
   UI_PB_blk_CreateBlockImages page_obj block_obj
   UI_PB_tpth_CreateDividers page_obj block_obj
   UI_PB_blk_CreateBlockCells page_obj block_obj active_blk_elem_obj \
   event_name $evt_elem_obj
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
  if [llength $event::($event_obj,evt_elem_list)] \
  {
   set test_blk_obj [lindex $event::($event_obj,evt_elem_list) 0]
   if [info exists event_element::($test_blk_obj,block_obj)] \
   {
    set blk_obj $event_element::($test_blk_obj,block_obj)
    if { [llength $block::($blk_obj,elem_addr_list)] == 0 } {
     set Page::($page_obj,dummy_blk) 1
    }
    return
   }
  } else \
  {
   set temp_event_name [split $Page::($page_obj,event_name)]
   set event_name [join $temp_event_name _ ]
   set event_name [string tolower $event_name]
   set block_name $event_name
   set block_name [PB_com_GetNextObjName $block_name block]
   set blk_elem_list ""
   set blk_owner $event::($event_obj,event_name)
   set blk_type "normal"
   PB_int_CreateNewBlock block_name blk_elem_list blk_owner \
   blk_obj blk_type
   PB_int_CreateNewEventElement blk_obj evt_elem $event_obj
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
  if { [info exists gPB(VIEW_ADDRESS)] && $gPB(VIEW_ADDRESS)} {
   UI_PB_com_DisableWindow $win
  }
  set box [frame $win.box -relief flat]
  pack $box -side bottom -fill x
  set box1_frm [frame $box.box1]
  pack $box1_frm -side bottom -fill x -padx 3 -pady 3
  if { [PB_is_v3] < 0 } {
   set label_list {"gPB(nav_button,cancel,Label)" \
    "gPB(nav_button,ok,Label)" \
   "gPB(nav_button,restore,Label)"}
   set cb_arr(gPB(nav_button,restore,Label)) \
   "UI_PB_cmd_CommentRestore_CB $block_obj"
   } else {
   set label_list {"gPB(nav_button,cancel,Label)" \
   "gPB(nav_button,ok,Label)"}
  }
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
  if { [string match "Condition" $cmd_mode] } \
  {
   set blk_name $block::($block_obj,block_name)
   set cmd_obj 0
   set cmd_obj_attr(0) "$gPB(condition_cmd_prefix)"
   append cmd_obj_attr(0) "$blk_name"
   set cmd_obj_attr(1) ""
   set word "Command"
   PB_int_RetMOMVarAsscAddress word cmd_name_list
   PB_com_SetDefaultName cmd_name_list cmd_obj_attr
   PB_pps_CreateCommand cmd_obj_attr cmd_obj
   set win_close_cb "UI_PB_cmd_tpthCondCmdBlkCancel_CB $win $page_obj $cmd_obj $cmd_page_obj"
   } elseif { [string match "Condition_Edit" $cmd_mode] } \
  {
   set cmd_obj $event_element::($evt_elem_obj,exec_condition_obj)
   set win_close_cb ""
   } elseif { $cmd_mode == "New" } \
  {
   set cmd_obj $block_element::($blk_elem_obj,elem_mom_variable)
   set win_close_cb "UI_PB_cmd_tpthCmdBlkCancel_CB $win $page_obj $event_obj \
   $evt_elem_obj $blk_elem_obj $cmd_page_obj"
  } else \
  {
   set cmd_obj $block_element::($blk_elem_obj,elem_mom_variable)
   set win_close_cb ""
  }
  set block_name $block::($block_obj,block_name)
  UI_PB_com_CreateTransientWindow $win "$gPB(tool,cus_trans,title,Label)" "" \
  "" "UI_PB_blk_DisableBlkPageWidgets $page_obj" "$win_close_cb" \
  "UI_PB_blk_ActivateBlkPageWidgets $page_obj $win_index"
  set Page::($cmd_page_obj,canvas_frame) $win
  set box [frame $win.bb]
  pack $box -side bottom -padx 3 -pady 3 -fill x
  set cb_arr(gPB(nav_button,default,Label)) \
  "UI_PB_cmd_CmdBlkDefault_CB $cmd_page_obj"
  set cb_arr(gPB(nav_button,restore,Label)) \
  "UI_PB_cmd_CmdBlkRestore_CB $cmd_page_obj"
  if { [string match "Condition*" $cmd_mode] } \
  {
   set cb_arr(gPB(nav_button,cancel,Label)) \
   "UI_PB_cmd_tpthCondCmdBlkCancel_CB $win \
   $page_obj $cmd_obj $cmd_page_obj"
   set cb_arr(gPB(nav_button,ok,Label)) \
   "UI_PB_cmd_tpthCondCmdBlkOk_CB $win $page_obj \
   $evt_elem_obj $cmd_obj $cmd_page_obj"
   } elseif { $cmd_mode == "New" } \
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
  set Page::($cmd_page_obj,cmd_mode) $cmd_mode ;#<10-28-10 wbh>
  UI_PB_cmd_CreateCmdBlkPage cmd_page_obj 1
  UI_PB_cmd_DisplayCmdBlkAttr cmd_page_obj cmd_obj
  if { [info exists gPB(VIEW_ADDRESS)] && $gPB(VIEW_ADDRESS)} {
   UI_PB_com_DisableWindow $win
  }
  if { $cmd_mode == "New" || [string match "Condition" $cmd_mode] } \
  {
   UI_PB_com_CreateActionElems $box cb_arr $win
  } else \
  {
   UI_PB_com_CreateActionElems $box cb_arr
  }
  UI_PB_com_PositionWindow $win
 }

#=======================================================================
proc UI_PB_tpth_BringFuncPage { PAGE_OBJ EVENT_OBJ EVT_ELEM_OBJ BLOCK_OBJ mode } {
  upvar $PAGE_OBJ page_obj
  upvar $EVENT_OBJ event_obj
  upvar $EVT_ELEM_OBJ evt_elem_obj
  upvar $BLOCK_OBJ block_obj
  global gPB paOption
  set canvas_frame $Page::($page_obj,canvas_frame)
  set win [toplevel $canvas_frame.function]
  set toplevel_index [llength $gPB(toplevel_list)]
  set win_index [expr $toplevel_index + 1]
  set gPB(toplevel_disable_$win_index) 1
  set page_name "Function_Page"
  set func_page_obj [new Page $page_name $page_name]
  set blk_elem_obj [lindex $block::($block_obj,active_blk_elem_list) 0]
  set func_obj $block_element::($blk_elem_obj,elem_mom_variable)
  set win_close_cb "UI_PB_func_tpthCancelCallBack $win $func_page_obj $page_obj \
  $event_obj $evt_elem_obj $block_obj $blk_elem_obj $mode"
  UI_PB_com_CreateTransientWindow $win $function::($func_obj,id) "850x750+100+100" \
  "" "UI_PB_blk_DisableBlkPageWidgets $page_obj" "$win_close_cb" \
  "UI_PB_blk_ActivateBlkPageWidgets $page_obj $win_index"
  set Page::($func_page_obj,page_id) $win
  set Page::($func_page_obj,canvas_frame) $win
  set box_frm [frame $win.total_box]
  pack $box_frm -side bottom -fill x -padx 3 ;#<07-16-09 wbh> add -padx 3
  set box1_frm [frame $box_frm.box1]
  set box2_frm [frame $box_frm.box2]
  tixForm $box1_frm -top 0 -left 0 -right %60 -padright 20
  tixForm $box2_frm -top 0 -left $box1_frm -right %100
  set first_list {"gPB(nav_button,default,Label)"  "gPB(nav_button,restore,Label)"  "gPB(nav_button,apply,Label)"}
  set second_list {"gPB(nav_button,cancel,Label)"  "gPB(nav_button,ok,Label)"}
  set cb_arr(gPB(nav_button,default,Label))  "UI_PB_func_DefaultCallBack $func_page_obj"
  set cb_arr(gPB(nav_button,restore,Label))  "UI_PB_func_RestoreCallBack $func_page_obj"
  set cb_arr(gPB(nav_button,apply,Label))    "UI_PB_func_ApplyCallBack $func_page_obj $block_obj"
  if [string match "New" $mode] \
  {
   UI_PB_com_CreateButtonBox $box1_frm first_list cb_arr $win
  } else \
  {
   UI_PB_com_CreateButtonBox $box1_frm first_list cb_arr
  }
  set cb_arr(gPB(nav_button,cancel,Label))  "UI_PB_func_tpthCancelCallBack $win $func_page_obj $page_obj \
  $event_obj $evt_elem_obj $block_obj $blk_elem_obj $mode"
  set cb_arr(gPB(nav_button,ok,Label))  "UI_PB_func_tpthOkCallBack $win $func_page_obj $page_obj \
  $event_obj $evt_elem_obj $block_obj"
  UI_PB_com_CreateButtonBox $box2_frm second_list cb_arr
  set Page::($func_page_obj,func_obj) $func_obj
  UI_PB_func_CreateFuncBlkPage func_page_obj 1
  if { $::env(PB_UDE_ENABLED) == 1 } \
  {
   if { $event_obj == 0 } \
   {
    set evt_name $block::($block_obj,blk_owner)
    set Page::($func_page_obj,ude_obj) [UI_PB_ude_GetUdeEventObjFrmEvtName $evt_name]
   } elseif [info exists event::($event_obj,event_ude_name)] \
   {
    set Page::($func_page_obj,ude_obj) [UI_PB_ude_GetUdeEventObj $event_obj]
   } else \
   {
    set Page::($func_page_obj,ude_obj) NULL
   }
   UI_PB_func__CreateUdePopupLabels $func_page_obj
  }
  UI_PB_func__CreateCommonPopupLabels $func_page_obj
  update
  UI_PB_func_DisplayFuncBlkAttr func_page_obj func_obj
  UI_PB_com_PositionWindow $win
 }

#=======================================================================
proc UI_PB_func_DisplayFunctionText { page_obj } {
  global gf_disp_flag
  if { $gf_disp_flag == 0 } { return }
  set disptext $Page::($page_obj,Func_Name)
  append disptext $Page::($page_obj,Comment_Start)
  set param_text_list [list]
  set last_index 0
  set num 0
  foreach param_obj $Page::($page_obj,param_obj_list) \
  {
   incr num
   if { $function::param_elem::($param_obj,name) == ""} \
   {
    if { ![string match "" $function::param_elem::($param_obj,exp)] && \
    ![string match "*\$*" $function::param_elem::($param_obj,exp)] } \
    {
     lappend param_text_list $function::param_elem::($param_obj,exp)
     set last_index $num
    } else \
    {
     lappend param_text_list ""
    }
   } else \
   {
    UI_PB_func_GetParamDisplayText $page_obj $param_obj dis_text
    lappend param_text_list $dis_text
    if { [string compare $dis_text ""] != 0 } \
    {
     set last_index $num
    }
   }
  }
  if { $last_index < $num } \
  {
   set param_text_list [lreplace $param_text_list $last_index end]
  }
  set word_seq "$Page::($page_obj,Word_Seperator)"
  set param_text [join $param_text_list "$word_seq"]
  append disptext $param_text
  append disptext $Page::($page_obj,Comment_End) " "
  set cntl_text $Page::($page_obj,disp_cntl)
  set frm_width [winfo width $cntl_text]
  set text_width [font measure $::gPB(bold_font_lg) $disptext]
  set start_index 2
  if {$frm_width > $text_width} {
   set align center
   set blk_width [font measure $::gPB(bold_font_lg) " "]
   set dif_width [expr $frm_width - $text_width]
   set start_index [expr [expr $dif_width / $blk_width] / 2]
   if { $start_index < 2 } {
    set start_index 2
   }
  }
  if ![string compare $::tix_version 4.1] \
  {
   set temp_str "                                                            "
   if { [expr $start_index + 1] < [string length $temp_str] } \
   {
    set temp_str [string range $temp_str 0 [expr $start_index + 1]]
   }
  } else \
  {
   set temp_str " "
   set temp_str [string repeat $temp_str [expr $start_index + 1]]
  }
  append temp_str $disptext
  set disptext $temp_str
  $cntl_text configure -state normal
  $cntl_text delete 0.0 end
  $cntl_text insert end "\n"
  $cntl_text insert end $disptext
  $cntl_text tag configure align_tag -spacing1 0.05i -offset 0.05i
  $cntl_text tag add align_tag 2.0 2.end
  $cntl_text tag configure bg_tag -background $::paOption(title_bg)
  $cntl_text tag add bg_tag 2.$start_index 2.end
  $cntl_text configure -state disabled
 }

#=======================================================================
proc UI_PB_func_GetParamDisplayText { page_obj param_obj FTEXT } {
  upvar $FTEXT ftext
  function::param_elem::readvalue $param_obj obj_attr
  set ftext ""
  if { [info exists Page::($page_obj,output_param_name_flag)] && \
  $Page::($page_obj,output_param_name_flag) } \
  {
   append ftext $obj_attr(0) $Page::($page_obj,Link_Char)
  }
  set exp_str $obj_attr(1)
  set dtype $obj_attr(2)
  if { $exp_str == "" } \
  {
   return
  }
  if { [string compare $dtype "Text String"] == 0 } \
  {
   if ![string match "*\$*" $exp_str] \
   {
    append ftext $exp_str
   } else \
   {
    append ftext "TEXT"
   }
   return
  }
  set int $obj_attr(3)
  set decimal $obj_attr(4)
  set frac $obj_attr(5)
  if ![catch { eval expr $exp_str } res] \
  {
   if { $frac } \
   {
    set total_width [expr $int + $frac]
    set val_text [format "%${total_width}.${frac}f" $res]
    set val_text [string trimleft $val_text]
    if { !$decimal } \
    { ;# remove the decimal
     set len [string length $val_text]
     set dec_index [expr $len - $frac -1]
     set val_text [string replace $val_text $dec_index $dec_index]
    }
   } else \
   {
    set int_data [expr { int($res) }]
    set val_text [format "%${int}d" $int_data]
    set val_text [string trimleft $val_text]
    if { $decimal } \
    {
     append val_text "."
    }
   }
   append ftext $val_text
   return
  }
  set dis_list [list 0 1 . 2 3 4 5 6 7 8 9]
  if { $int > 0 } \
  {
   append ftext [lindex $dis_list 1]
  }
  if { $decimal == 1 } \
  {
   append ftext [lindex $dis_list 2]
  }
  set num_frac $frac
  if { $frac > 8 } \
  {
   set num_frac 8
  }
  for { set i 1 } { $i <= $num_frac } { incr i } \
  {
   append ftext [lindex $dis_list [expr $i + 2]]
  }
  set num_more [expr $frac - $num_frac]
  if { $num_more > 0 } \
  {
   for { set i 0 } { $i < $num_more } { incr i } \
   {
    append ftext [lindex $dis_list 0]
   }
  }
 }

#=======================================================================
proc UI_PB_func_SimpleFormat {page_obj w area x1 y1 x2 y2} {
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
    set Page::($page_obj,pos_autoCol) $x2
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
  if { $Page::($page_obj,btn_right) != 0 } \
  {
   set prevRow $Page::($page_obj,pos_prevRow)
   set curRow  $Page::($page_obj,pos_curRow)
   set autoCol $Page::($page_obj,pos_autoCol)
   if [$w info exists 0 $prevRow] \
   {
    $w format border 0 $prevRow $autoCol $prevRow \
    -fill 1 -relief raised -bd 2 -bg $paOption(active_color)
   }
   if [expr $prevRow != $curRow] \
   {
    $w format border 0 $curRow $autoCol $curRow \
    -fill 1 -relief raised -bd 2 -bg $paOption(select_clr)
   }
  }
 }

#=======================================================================
proc UI_PB_func_LeftBtnClickInGrid { page_obj grid x y } {
  if { $Page::($page_obj,btn_right) == 1 } \
  {
   set prevRow $Page::($page_obj,pos_prevRow)
   UI_PB_func_SetCellBkColor $grid $prevRow "normal"
   UI_PB_func_HightLightGridRow $page_obj $grid
   set Page::($page_obj,btn_right) 0
  }
 }

#=======================================================================
proc UI_PB_func_MouseMoveInGrid { page_obj grid x y } {
  set col -1
  set row -1
  if { [UI_PB_func_GetGridCellPos $page_obj $grid "Exact" $x $y col row] } \
  {
   $grid config -cursor arrow
   return
  }
  if { $col == 0 && $row > 0 } \
  {
   $grid config -cursor hand2
  } else \
  {
   $grid config -cursor arrow
  }
 }

#=======================================================================
proc UI_PB_func_RightBtnClickInGrid { page_obj grid x y screenX screenY } {
  global gPB
  if { $Page::($page_obj,btn_right) == 1 } \
  {
   set prevRow $Page::($page_obj,pos_prevRow)
   UI_PB_func_SetCellBkColor $grid $prevRow "normal"
   UI_PB_func_HightLightGridRow $page_obj $grid
   set Page::($page_obj,btn_right) 0
  }
  set col -1
  set row -1
  if { [UI_PB_func_GetGridCellPos $page_obj $grid "Normal" $x $y col row] || \
  $row == 0 || $col != 0 } \
  {
   return
  }
  set maxRow $Page::($page_obj,pos_maxRow)
  if { $row >= $maxRow } \
  {
   set Page::($page_obj,btn_right) 0
   set row $maxRow
  } else \
  {
   set Page::($page_obj,btn_right) 1
   set Page::($page_obj,pos_prevRow) $row
   set Page::($page_obj,pos_curRow) $row
   UI_PB_func_HightLightGridRow $page_obj $grid
   UI_PB_func_SetCellBkColor $grid $row "active"
  }
  set win $Page::($page_obj,page_id)
  set popup $win.blank_pop
  if { ![winfo exists $popup] } \
  {
   set popup [menu $win.blank_pop]
  }
  $popup delete 0 end
  $popup add command -label "$gPB(func,popup,insert,Label)" \
  -state normal \
  -command [list UI_PB_func_InsertNewRow $page_obj "null" $grid $row]
  $popup add separator
  if { $Page::($page_obj,btn_right) } \
  {
   if { $maxRow > $row } \
   {
    set state "normal"
   } else \
   {
    set state "disabled"
   }
   $popup add command -label "$gPB(nav_button,cut,Label)" \
   -state $state \
   -command "UI_PB_func_CutRow $page_obj $grid $row"
   $popup add command -label "$gPB(nav_button,copy,Label)" \
   -state $state \
   -command "UI_PB_func_CopyRow $page_obj $grid $row"
  }
  if { $Page::($page_obj,copy_flag) == 1 } \
  {
   set state "normal"
  } else \
  {
   set state "disabled"
  }
  $popup add command -label "$gPB(nav_button,paste,Label)" \
  -state $state \
  -command "UI_PB_func_PasteRow $page_obj $grid $row"
  if { $Page::($page_obj,btn_right) } \
  {
   $popup add separator
   $popup add command -label "$gPB(block,delete_popup,Label)" \
   -state normal \
   -command "UI_PB_func_DeleteOneRow $page_obj $grid $row"
  }
  tk_popup $popup $screenX $screenY
 }

#=======================================================================
proc UI_PB_func_InsertNewRow { page_obj param_obj grid no_row } {
  if { $Page::($page_obj,btn_right) } \
  {
   set prevRow $Page::($page_obj,pos_prevRow)
   UI_PB_func_SetCellBkColor $grid $prevRow "normal"
   UI_PB_func_HightLightGridRow $page_obj $grid
   set Page::($page_obj,btn_right) 0
  }
  if { [string compare $param_obj "null"] == 0 } \
  {
   set param_obj [new function::param_elem]
  }
  set maxRow $Page::($page_obj,pos_maxRow)
  if { [expr $no_row + 1] >= $maxRow } \
  {
   set no_row $maxRow
   lappend Page::($page_obj,param_obj_list) $param_obj
  } else \
  {
   set Page::($page_obj,param_obj_list) \
   [linsert $Page::($page_obj,param_obj_list) $no_row $param_obj]
   incr no_row
   $grid move row $no_row [expr $maxRow - 1] 1
  }
  UI_PB_func__CreateOneRow $page_obj $param_obj $grid $no_row
  UI_PB_func_DisplayFunctionText $page_obj
  if [info exists Page::($page_obj,new_grid_entry)] \
  {
   UI_PB_func__EnterParamEntry $page_obj $Page::($page_obj,new_grid_entry)
   focus $Page::($page_obj,new_grid_entry)
  }
 }

#=======================================================================
proc UI_PB_func_CutRow { page_obj grid row } {
  if { $Page::($page_obj,btn_right) } \
  {
   set prevRow $Page::($page_obj,pos_prevRow)
   UI_PB_func_SetCellBkColor $grid $prevRow "normal"
   UI_PB_func_HightLightGridRow $page_obj $grid
   set Page::($page_obj,btn_right) 0
  }
  set Page::($page_obj,copy_flag) 1
  set param_obj [lindex $Page::($page_obj,param_obj_list) [expr $row -1]]
  function::param_elem::readvalue $param_obj obj_attr
  set Page::($page_obj,copy_attr_list) [list]
  set Page::($page_obj,copy_attr_list) [array get obj_attr]
  UI_PB_func_DeleteOneRow $page_obj $grid $row
  UI_PB_func_DisplayFunctionText $page_obj
 }

#=======================================================================
proc UI_PB_func_CopyRow { page_obj grid row } {
  if { $Page::($page_obj,btn_right) } \
  {
   set prevRow $Page::($page_obj,pos_prevRow)
   UI_PB_func_SetCellBkColor $grid $prevRow "normal"
   UI_PB_func_HightLightGridRow $page_obj $grid
   set Page::($page_obj,btn_right) 0
  }
  set Page::($page_obj,copy_flag) 1
  set param_obj [lindex $Page::($page_obj,param_obj_list) [expr $row -1]]
  function::param_elem::readvalue $param_obj obj_attr
  set Page::($page_obj,copy_attr_list) [list]
  set Page::($page_obj,copy_attr_list) [array get obj_attr]
  UI_PB_func_DisplayFunctionText $page_obj
 }

#=======================================================================
proc UI_PB_func_PasteRow { page_obj grid row } {
  if { $Page::($page_obj,btn_right) } \
  {
   set prevRow $Page::($page_obj,pos_prevRow)
   UI_PB_func_SetCellBkColor $grid $prevRow "normal"
   UI_PB_func_HightLightGridRow $page_obj $grid
   set Page::($page_obj,btn_right) 0
  }
  if { $Page::($page_obj,copy_flag) == 0 } { return }
  set Page::($page_obj,copy_flag) 0
  set param_obj [new function::param_elem]
  array set obj_attr $Page::($page_obj,copy_attr_list)
  UI_PB_funcl_SetDefaultParamName $page_obj obj_attr
  function::param_elem::setvalue $param_obj obj_attr
  UI_PB_func_InsertNewRow $page_obj $param_obj $grid $row
 }

#=======================================================================
proc UI_PB_func_DeleteOneRow { page_obj grid row } {
  if { $Page::($page_obj,btn_right) } \
  {
   set prevRow $Page::($page_obj,pos_prevRow)
   UI_PB_func_SetCellBkColor $grid $prevRow "normal"
   UI_PB_func_HightLightGridRow $page_obj $grid
   set Page::($page_obj,btn_right) 0
  }
  set index [expr $row -1]
  set param_list $Page::($page_obj,param_obj_list)
  set delete_obj [lindex $param_list $index]
  set Page::($page_obj,param_obj_list) [lreplace $param_list $index $index]
  set maxCol $Page::($page_obj,pos_maxCol)
  set maxRow $Page::($page_obj,pos_maxRow)
  set exp_frm [lindex [$grid entryconfigure 1 $row -window] end]
  global gPB_help_tips
  if [info exists gPB_help_tips($exp_frm.ent)] {
   unset gPB_help_tips($exp_frm.ent)
  }
  $grid delete row $row
  if { [expr $row + 1] < $maxRow } \
  {
   $grid move row [expr $row + 1] [expr $maxRow - 1] -1
  }
  incr Page::($page_obj,pos_maxRow) -1
  PB_com_DeleteObject $delete_obj
  UI_PB_func_DisplayFunctionText $page_obj
 }

#=======================================================================
proc UI_PB_func_ClearAllGridRows { PAGE_OBJ } {
  upvar $PAGE_OBJ page_obj
  set grid $Page::($page_obj,grid)
  if { $Page::($page_obj,btn_right) } \
  {
   set prevRow $Page::($page_obj,pos_prevRow)
   UI_PB_func_SetCellBkColor $grid $prevRow "normal"
   UI_PB_func_HightLightGridRow $page_obj $grid
   set Page::($page_obj,btn_right) 0
  }
  set maxRow $Page::($page_obj,pos_maxRow)
  for { set row [expr $maxRow - 1] } { $row > 0 } { incr row -1 } \
  {
   $grid delete row $row
  }
  foreach param_obj $Page::($page_obj,param_obj_list) \
  {
   PB_com_DeleteObject $param_obj
  }
  set Page::($page_obj,pos_maxRow) 1
  set Page::($page_obj,param_obj_list) [list]
 }

#=======================================================================
proc UI_PB_funcl_SetDefaultParamName { page_obj OBJ_ATTR } {
  upvar $OBJ_ATTR obj_attr
  set param_name_list [list]
  foreach param_obj $Page::($page_obj,param_obj_list) \
  {
   lappend param_name_list $function::param_elem::($param_obj,name)
  }
  PB_com_SetDefaultName param_name_list obj_attr
 }

#=======================================================================
proc UI_PB_func_GetGridCellPos { page_obj grid mode pixelX pixelY COL ROW } {
  upvar $COL col
  upvar $ROW row
  set ret_code 0
  set flag 0
  if { [string compare $mode "Exact"] == 0 } \
  {
   set flag 1
   } elseif { [string compare $mode "Nearest"] == 0 } \
  {
   set flag 2
  }
  set ent [$grid nearest $pixelX $pixelY]
  if { [string compare $ent ""] == 0 } \
  {
   set col -1
   set row -1
   return 1
  }
  set col [lindex $ent 0]
  set row [lindex $ent 1]
  switch -exact -- $flag {
   1 {
    if { ![$grid info exists $col $row] } \
    { ;# cell(col,row) didn't exist, return error code
     set col -1
     set row -1
     set ret_code 2
    } else \
    { ;# Return successful code
     set ret_code 0
    }
   }
   2 {
    if { ![$grid info exists $col $row] } \
    { ;# cell(col,row) didn't exist
     set maxRow $Page::($page_obj,pos_maxRow)
     if { $maxRow > $row } \
     { ;# Return error code
      set col -1
      set row -1
      set ret_code 3
     } else \
     { ;# The nearest row is just the last existed row in the grid.
      set row [expr $maxRow - 1]
      set ret_code 0
     }
    } else \
    { ;# Return successful code
     set ret_code 0
    }
   }
   default {
    set ret_code 0
   }
  }
  return $ret_code
 }

#=======================================================================
proc UI_PB_func_HightLightGridRow { page_obj grid } {
  $grid config -formatcmd "UI_PB_func_SimpleFormat $page_obj $grid"
 }

#=======================================================================
proc UI_PB_func_SetCellBkColor { grid row mode } {
  global paOption
  if { ![$grid info exists 0 $row] || [expr $row == 0] } \
  {
   return
  }
  set color $paOption(table_bg)
  case $mode {
   "active" {
    set color $paOption(active_color)
   }
   "selective" {
    set color $paOption(select_clr)
   }
  }
  set w [lindex [$grid entryconfigure 0 $row -window] end]
  $w configure -bg $color
  set child_w [winfo children $w]
  foreach cw $child_w \
  {
   $cw configure -bg $color
  }
 }

#=======================================================================
proc UI_PB_func__ValidateEntry { page_obj label text args} {
  global gPB
  if [llength $args] \
  {
   set Page::($page_obj,$label) [$text get]
  } else \
  {
   set Page::($page_obj,$label) $text
  }
  UI_PB_func_DisplayFunctionText $page_obj
  return 1
 }

#=======================================================================
proc UI_PB_func__EnterParamEntry { page_obj w } {
  global paOption gParamEntry gf_param_arr
  global gf_leave_flag
  set var_name [lindex [$w configure -textvariable] end]
  set gParamEntry [set $var_name]
  $w configure -bg $paOption(focus) -relief solid -state normal
  set gf_leave_flag 0
 }

#=======================================================================
proc UI_PB_func__LeaveParamEntry { page_obj col w } {
  global gPB paOption gParamEntry gf_param_arr
  global gf_leave_flag
  if {$gf_leave_flag} {return}
  set gf_leave_flag 0
  set var_name [lindex [$w configure -textvariable] end]
  set new_text [set $var_name]
  if { $new_text == "" || \
  [string compare $new_text $gParamEntry] == 0 } \
  {
   $w configure -bg $paOption(table_bg) -relief flat -state disabled
   UI_PB_func_DisplayFunctionText $page_obj
   return
  }
  set org_index [UI_PB_func_GetParamIndexFrmWidget $page_obj $col $w]
  set param_list $Page::($page_obj,param_obj_list)
  set param_list [lreplace $param_list $org_index $org_index]
  foreach param_obj $param_list \
  {
   set param_name $function::param_elem::($param_obj,name)
   if { [string compare $param_name $new_text] == 0 } \
   {
    set gf_leave_flag 1
    tk_messageBox -icon error -message "\"$new_text\" $gPB(msg,name_exists)"
    $w configure -bg $paOption(table_bg) -relief flat -state disabled
    focus [winfo parent $w]
    set $var_name $gParamEntry
    UI_PB_func_DisplayFunctionText $page_obj
    UI_PB_func__EnterParamEntry $page_obj $w
    focus $w
    return
   }
  }
  set param_obj [lindex $Page::($page_obj,param_obj_list) $org_index]
  set function::param_elem::($param_obj,name) $new_text
  $w configure -bg $paOption(table_bg) -relief flat -state disabled
  focus [winfo parent $w]
  UI_PB_func_DisplayFunctionText $page_obj
 }

#=======================================================================
proc UI_PB_func__EditParamEntry { page_obj col w new_text old_text args } {
  global paOption
  if [llength $args] \
  {
   if ![string compare "space" $new_text] \
   {
    $w config -state disabled
   }
   return 0
  }
  if { [string compare $new_text $old_text] == 0 || \
  [string match "* *" $new_text] } \
  {
   return 0
  }
  set index [UI_PB_func_GetParamIndexFrmWidget $page_obj $col $w]
  if { $index == -1 } \
  {
   return 0
  }
  return 1
 }

#=======================================================================
proc UI_PB_func_GetParamIndexFrmWidget { page_obj col w } {
  set maxRow $Page::($page_obj,pos_maxRow)
  set grid $Page::($page_obj,grid)
  set w_parent [winfo parent $w]
  for { set row 1 } { $row < $maxRow } { incr row } \
  {
   set w_cell [lindex [$grid entryconfigure $col $row -window] end]
   if { [string compare $w_cell $w_parent] == 0 } \
   {
    return [expr $row - 1]
   }
  }
  return -1
 }

#=======================================================================
proc UI_PB_func__CreateSpecAttr { page_obj spc_frm label options count DEFAULT} {
  upvar $DEFAULT default
  global gf_name_arr
  global tixOption
  global paOption
  if { [lsearch $options "$default"] < 0 } {
   set default "gPB(other,opt_text,Label)"
  }
  set gf_name_arr($label,label) $default
  set frame [frame $spc_frm.$count]
  pack $frame -side top -fill both -padx 5
  set temp_lab [split $label "_"]
  set disp_lab [join $temp_lab " "]
  global gPB
  switch $label {
   "Word_Seperator" {
    set disp_lab $gPB(func,separator,Label)
   }
   "Comment_Start" {
    set disp_lab $gPB(func,start,Label)
   }
   "Comment_End" {
    set disp_lab $gPB(func,end,Label)
   }
   default {
   }
  }
  set lbl [label $frame.lbl -text $disp_lab -anchor w \
  -font $tixOption(font) -width 13] ;#<04-24-09 gsl> -width 15
  pack $lbl -side left -padx 3 -pady 2
  set ent [entry $frame.ent -textvariable gf_name_arr($label,char) \
  -font $tixOption(bold_font) \
  -selectbackground yellow \
  -relief sunken -width 3 -bd 2]
  if ![string compare $::tix_version 4.1] \
  {
   bind $ent <KeyRelease> "UI_PB_func__ValidateEntry $page_obj $label %W 1"
  } else \
  {
   $ent config -validate key -vcmd "UI_PB_func__ValidateEntry $page_obj $label %P"
  }
  set opt_menu [tixOptionMenu $frame.opt -variable gf_name_arr($label,label) \
  -command "UI_PB_func__SetSpecChar $page_obj $spc_frm $count $label" \
  -options { menubutton.width 14
   menubutton.height 1
  }]
  UI_PB_func__SetSpecChar $page_obj $spc_frm $count $label
  set Page::($page_obj,$label) $gf_name_arr($label,char)
  foreach opt $options \
  {
   $opt_menu add command $opt -label [set $opt]
  }
  pack $opt_menu $ent -side right -fill x -padx 3 -pady 2
  $opt_menu config -value $default
 }

#=======================================================================
proc UI_PB_func__SetSpecChar { page_obj frame count option_lab args } {
  global gf_name_arr
  global mom_sys_arr
  global paOption
  global gPB
  switch $gf_name_arr($option_lab,label) \
  {
   "gPB(other,opt_none,Label)" \
   {
    set gf_name_arr($option_lab,char) ""
   }
   "gPB(other,opt_space,Label)" \
   {
    set gf_name_arr($option_lab,char) " "
   }
   "gPB(other,opt_dec,Label)" \
   {
    set gf_name_arr($option_lab,char) "."
   }
   "gPB(other,opt_comma,Label)" \
   {
    set gf_name_arr($option_lab,char) ","
   }
   "gPB(other,opt_semi,Label)" \
   {
    set gf_name_arr($option_lab,char) ";"
   }
   "gPB(other,opt_colon,Label)" \
   {
    set gf_name_arr($option_lab,char) ":"
   }
   "gPB(other,opt_text,Label)" \
   {
    set gf_name_arr($option_lab,char) $mom_sys_arr($option_lab)
   }
   "gPB(other,opt_left,Label)" \
   {
    set gf_name_arr($option_lab,char) "("
   }
   "gPB(other,opt_right,Label)" \
   {
    set gf_name_arr($option_lab,char) ")"
   }
   "gPB(other,opt_aster,Label)" \
   {
    set gf_name_arr($option_lab,char) "*"
   }
   "gPB(other,opt_slash,Label)"
   {
    set gf_name_arr($option_lab,char) "/"
   }
   "gPB(other,opt_new_line,Label)" \
   {
    set gf_name_arr($option_lab,char) "\\012"
   }
   "gPB(other,opt_equal,Label)" \
   {
    set gf_name_arr($option_lab,char) "="
   }
  }
  if [string match "Link_Char" $option_lab] \
  {
   set opt_ent $frame.ent
  } else \
  {
   set opt_ent $frame.$count.ent
  }
  if { $gf_name_arr($option_lab,label) == "gPB(other,opt_text,Label)" } {
   $opt_ent config -state normal -bg $gPB(entry_color)
   } else {
   $opt_ent config -state disabled -bg $paOption(entry_disabled_bg)
  }
  $opt_ent selection range 0 end
  if ![string compare $::tix_version 4.1] \
  {
   UI_PB_func__ValidateEntry $page_obj $option_lab $opt_ent 1
  }
 }

#=======================================================================
proc UI_PB_func__CreateOneRow { page_obj param_obj grid no_row } {
  global gPB paOption tixOption
  global gf_param_arr gf_count
  set name_frm $grid.name_$gf_count
  if { ![winfo exists $name_frm] } {
   set name_frm [frame $grid.name_$gf_count -bg $paOption(table_bg)]
   set n_ent [entry $name_frm.name \
   -textvariable function::param_elem::($param_obj,name) \
   -font $tixOption(bold_font) \
   -justify center \
   -width 8 -bd 1 \
   -relief flat \
   -background $paOption(table_bg) \
   -foreground blue \
   -highlightbackground $paOption(table_bg)]
   pack $n_ent -anchor c -fill y
   if ![string compare $::tix_version 4.1] \
   {
    bind $n_ent <KeyPress> "UI_PB_func__EditParamEntry $page_obj 0 %W %K %K 1"
    bind $n_ent <KeyRelease> "%W config -state normal"
   } else \
   {
    $n_ent config -disabledforeground blue \
    -disabledbackground $paOption(table_bg) \
    -validate key \
    -vcmd "UI_PB_func__EditParamEntry $page_obj 0 %W %P %s"
   }
   bind $n_ent <Enter> "UI_PB_func__EnterParamEntry $page_obj %W"
   bind $n_ent <Leave> "UI_PB_func__LeaveParamEntry $page_obj 0 %W"
   bind $n_ent <Return> "UI_PB_func__LeaveParamEntry $page_obj 0 %W"
   set Page::($page_obj,new_grid_entry) $n_ent
  }
  $grid set 0 $no_row -itemtype window -window $name_frm -style $Page::($page_obj,col_style)
  set exp_frm $grid.exp_$gf_count
  if { ![winfo exists $exp_frm] } {
   set exp_frm [frame $grid.exp_$gf_count]
   set e_ent [entry $exp_frm.ent \
   -textvariable function::param_elem::($param_obj,exp) \
   -cursor hand2 \
   -width 40 -borderwidth 1]
   bind $e_ent <3> "UI_PB_func_AttachParam $page_obj %W %X %Y"
   bind $e_ent <Double-1> "UI_PB_func_DClickExpEntry $page_obj %W"
   bind $e_ent <Return> "UI_PB_func_ReturnExpEntry $page_obj %W"
   bind $e_ent <FocusOut> "UI_PB_func_DisplayFunctionText $page_obj"
   bind $e_ent <Enter> "set ::gPB(enable_func_exp) 1"
   bind $e_ent <Leave> "set ::gPB(enable_func_exp) 0"
   pack $e_ent -side top -padx 2
   PB_enable_balloon $e_ent
   UI_PB_func__SetBalloonText $e_ent $function::param_elem::($param_obj,exp)
  }
  $grid set 1 $no_row -itemtype window -window $exp_frm
  set dat_frm $grid.dat_$gf_count
  if { ![winfo exists $dat_frm] } \
  {
   set dat_frm [frame $grid.dat_$gf_count]
   radiobutton $dat_frm.num -text "$gPB(addrsum,radio_num,Label)" \
   -variable function::param_elem::($param_obj,dtype) -value Numeral \
   -command "UI_PB_func__RadDataCallBack $dat_frm.num $page_obj $grid 2 Numeral"
   radiobutton $dat_frm.text -text "$gPB(addrsum,radio_text,Label)" \
   -variable function::param_elem::($param_obj,dtype) -value "Text String" \
   -command "UI_PB_func__RadDataCallBack $dat_frm.text $page_obj $grid 2 Text"
   pack $dat_frm.num -side left -anchor ne
   pack $dat_frm.text -side right -anchor nw
   set gPB(c_help,$dat_frm.num)    "format,data,num"
   set gPB(c_help,$dat_frm.text)   "format,data,text"
  }
  $grid set 2 $no_row -itemtype window -window $dat_frm
  set int_frm $grid.int_$gf_count
  if { ![winfo exists $int_frm] } \
  {
   set int_frm [frame $grid.int_$gf_count]
   UI_PB_func__CreateIntControl $page_obj $param_obj $int_frm con
   set gPB(c_help,[$int_frm.con subwidget entry])  \
   "format,data,num,integer"
  }
  $grid set 3 $no_row -itemtype window -window $int_frm
  set dec_frm $grid.dec_$gf_count
  if { ![winfo exists $dec_frm] } \
  {
   set dec_frm [frame $grid.dec_$gf_count]
   set dec_pt [checkbutton $dec_frm.ch \
   -command "UI_PB_func__UpdateAllAddFmt $page_obj" \
   -variable function::param_elem::($param_obj,decimal)]
   pack $dec_pt -side top -anchor c
   set gPB(c_help,$dec_pt) "format,data,num,decimal"
  }
  $grid set 4 $no_row -itemtype window -window $dec_frm
  set fra_frm $grid.fra_$gf_count
  if { ![winfo exists $fra_frm] } \
  {
   set fra_frm [frame $grid.fra_$gf_count]
   UI_PB_func__CreateFracControl $page_obj $param_obj $fra_frm con
   set gPB(c_help,[$fra_frm.con subwidget entry])  \
   "format,data,num,fraction"
  }
  $grid set 5 $no_row -itemtype window -window $fra_frm
  incr gf_count
  incr Page::($page_obj,pos_maxRow)
  if [string match "Text String" $function::param_elem::($param_obj,dtype)] \
  {
   UI_PB_func__RadDataCallBack $dat_frm.text $page_obj $grid 2 Text
  }
 }

#=======================================================================
proc UI_PB_func__SetBalloonText { w tex } {
  global gPB_help_tips
  set gPB_help_tips($w) $tex
 }

#=======================================================================
proc UI_PB_func_AttachParam { page_obj ent x y } {
  global g_func_udeEntry
  set g_func_udeEntry $ent
  set w $Page::($page_obj,canvas_frame)
  tk_popup $w.ude_pop $x $y
 }

#=======================================================================
proc UI_PB_func_DClickExpEntry { page_obj ent } {
  global g_func_udeEntry
  set frm_canvas $Page::($page_obj,canvas_frame)
  if [winfo exists $frm_canvas.txtent] \
  {
   return
  }
  set g_func_udeEntry $ent
  UI_PB_func__EditParamExp $page_obj
 }

#=======================================================================
proc UI_PB_func_ReturnExpEntry { page_obj ent } {
  UI_PB_func__SetBalloonText $ent [$ent get]
  UI_PB_func_DisplayFunctionText $page_obj
 }

#=======================================================================
proc UI_PB_func__CreateUdePopupLabels { page_obj } {
  set Page::($page_obj,ude_label_list) [list]
  set ude_obj $Page::($page_obj,ude_obj)
  if { [string compare $ude_obj "NULL"] == 0 } \
  {
   return
  }
  set ClassName [string trim [classof $ude_obj] ::]
  if { [string compare $ClassName "ude_event"] == 0 } \
  {
   set param_obj_list $ude_event::($ude_obj,param_obj_list)
  } else \
  {
   set param_obj_list $cycle_event::($ude_obj,param_obj_list)
  }
  foreach param_obj $param_obj_list \
  {
   set ClassName [string trim [classof $param_obj] ::]
   switch -exact $ClassName {
    param::integer  {
     set temp_name  $param::integer::($param_obj,name)
     set temp_label $param::integer::($param_obj,ui_label)
    }
    param::double   {
     set temp_name  $param::double::($param_obj,name)
     set temp_label $param::double::($param_obj,ui_label)
    }
    param::option   {
     set temp_name  $param::option::($param_obj,name)
     set temp_label $param::option::($param_obj,ui_label)
    }
    param::boolean  {
     set temp_name  $param::boolean::($param_obj,name)
     set temp_label $param::boolean::($param_obj,ui_label)
    }
    param::string   {
     set temp_name  $param::string::($param_obj,name)
     set temp_label $param::string::($param_obj,ui_label)
    }
    param::point    {
     set temp_name  $param::point::($param_obj,name)
     set temp_label $param::point::($param_obj,ui_label)
    }
    param::bitmap   {
     continue
    }
    param::group    {
     continue
    }
   } ;# end switch
   if { [string compare $temp_label "Cam Status"] == 0 } \
   {
    continue
   }
   set label_attr [list]
   lappend label_attr $temp_label
   set var_name ""
   append var_name "\$mom_" $temp_name
   lappend label_attr $var_name
   lappend Page::($page_obj,ude_label_list) $label_attr
  } ;# end foreach
  set w $Page::($page_obj,canvas_frame)
  if { ![info exists $w.ude_pop] } \
  {
   set popmenu [menu $w.ude_pop -tearoff 0]
   $popmenu add command -label $::gPB(block,edit_popup,Label) \
   -command [list UI_PB_func__EditParamExp $page_obj]
   $popmenu add separator
   if [info exists Page::($page_obj,ude_label_list)] \
   {
    $popmenu add cascade -label "UDE" -menu $popmenu.ude
    catch {destroy $popmenu.ude}
    menu $popmenu.ude
    foreach label_attr $Page::($page_obj,ude_label_list) \
    {
     set desc [lindex $label_attr 0]
     set var  [lindex $label_attr 1]
     set temp_label ""
     append temp_label $desc " ( " $var " )"
     $popmenu.ude add command -label $temp_label \
     -command [list UI_PB_func__AddUdeParameterValue $var]
    } ;# end foreach
    $popmenu add separator
   }
  }
 }

#=======================================================================
proc UI_PB_func__CreateCommonPopupLabels { page_obj } {
  set Page::($page_obj,popup_label_list) [list]
  UI_PB_blk_GetActiveAddresses page_obj
  set word_list $Page::($page_obj,blk_WordNameList)
  set no_opts [llength $word_list]
  PB_int_GetWordVarDesc WordDescArray
  for {set i 0} {$i < $no_opts} {incr i} \
  {
   set word [lindex $word_list $i]
   switch -exact -- $word \
   {
    X -
    Y -
    Z -
    I -
    J -
    K -
    R -
    F -
    S   {
     if { [info exists WordDescArray($word)] } \
     {
      set list_len [llength $WordDescArray($word)]
      PB_int_RetMOMVarAsscAddress word word_mom_var_list
     } else \
     {
      set list_len 0
     }
     if { $list_len == 0 } \
     {
      continue
     }
     set label_attr [list]
     lappend label_attr $word
     if { $list_len } \
     {
      for {set count 0} {$count < $list_len} {incr count} \
      {
       set mom_var [lindex $word_mom_var_list $count]
       set desc [lindex $WordDescArray($word) $count]
       set sublabel [list]
       lappend sublabel $desc
       lappend sublabel $mom_var
       lappend label_attr $sublabel
      }
     }
     lappend Page::($page_obj,popup_label_list) $label_attr
    }
    default {
     continue
    }
   } ;# end switch
  }
  set w $Page::($page_obj,canvas_frame)
  if { ![winfo exists $w.ude_pop] } \
  {
   menu $w.ude_pop -tearoff 0
   $w.ude_pop add command -label $::gPB(block,edit_popup,Label) \
   -command [list UI_PB_func__EditParamExp $page_obj]
   $w.ude_pop add separator
  }
  set popmenu $w.ude_pop
  if [info exists Page::($page_obj,popup_label_list)] \
  {
   set no_index 0
   foreach sublabel $Page::($page_obj,popup_label_list) \
   {
    set no_sub [llength $sublabel]
    set cas [lindex $sublabel 0]
    $popmenu add cascade -label $cas -menu $popmenu.m$no_index
    catch {destroy $popmenu.m$no_index}
    menu $popmenu.m$no_index
    for { set i 1 } { $i < $no_sub } { incr i } \
    {
     set label_attr [lindex $sublabel $i]
     set desc [lindex $label_attr 0]
     set var  [lindex $label_attr 1]
     set temp_label ""
     append temp_label $desc " ( " $var " )"
     $popmenu.m$no_index add command -label $temp_label \
     -command [list UI_PB_func__AddUdeParameterValue $var]
    }
    incr no_index
   } ;# end foreach sublabel
  }
 }

#=======================================================================
proc UI_PB_func__AddUdeParameterValue { insert_text } {
  global g_func_udeEntry
  $g_func_udeEntry insert insert $insert_text
  UI_PB_func__SetBalloonText $g_func_udeEntry [$g_func_udeEntry get]
 }

#=======================================================================
proc UI_PB_func__EditParamExp { page_obj } {
  global gPB
  global g_func_udeEntry
  global g_temp_text_var
  global g_temp_one_flag
  set org_udeEntry $g_func_udeEntry
  set g_temp_text_var [$g_func_udeEntry get]
  set frm_canvas $Page::($page_obj,canvas_frame)
  set g_temp_one_flag 0
  if [winfo exists $frm_canvas.ude_pop] \
  {
   $frm_canvas.ude_pop delete 0 1
   set g_temp_one_flag 1
  }
  set win [toplevel $frm_canvas.txtent]
  set toplevel_index [llength $gPB(toplevel_list)]
  set win_index [expr $toplevel_index + 1]
  set gPB(toplevel_disable_$win_index) 1
  set param_name ""
  set exp_text_name [$org_udeEntry cget -textvariable]
  set st_ind [string last "(" $exp_text_name]
  set end_ind [string last "," $exp_text_name]
  if { $st_ind >= 0 && $end_ind >= 0 } \
  {
   incr st_ind
   incr end_ind -1
   set param_obj [string range $exp_text_name $st_ind $end_ind]
   set param_name $function::param_elem::($param_obj,name)
  }
  UI_PB_com_CreateTransientWindow $win \
  "$gPB(func,col_param,Label): $param_name" "600x120+300+250" \
  "" "" "" \
  "UI_PB_func__CancelParamExp $win $page_obj"
  set text_frm [frame $win.frame]
  pack $text_frm -side top -fill both -expand yes
  label $text_frm.lab -text "$gPB(func,col_exp,Label)" -anchor w
  entry $text_frm.ent -textvariable g_temp_text_var -width 50 -bd 2 -relief sunken
  pack $text_frm.lab -side left -fill both -padx 5 -pady 10
  pack $text_frm.ent -side right -fill x -padx 5 -pady 10 -expand yes
  focus $text_frm.ent
  bind $text_frm.ent <3> "UI_PB_func_AttachParam $page_obj %W %X %Y"
  set label_list {"gPB(nav_button,cancel,Label)" \
  "gPB(nav_button,ok,Label)"}
  set cb_arr(gPB(nav_button,cancel,Label)) \
  "UI_PB_func__CancelParamExp $win $page_obj"
  set cb_arr(gPB(nav_button,ok,Label)) \
  "UI_PB_func__OkParamExp $win $page_obj $org_udeEntry"
  UI_PB_com_CreateButtonBox $win label_list cb_arr
 }

#=======================================================================
proc UI_PB_func__CancelParamExp { win page_obj } {
  global g_temp_text_var
  global g_temp_one_flag
  if [info exists g_temp_text_var] {
   unset g_temp_text_var
  }
  destroy $win
  if [info exists g_temp_one_flag] \
  {
   if $g_temp_one_flag \
   {
    set frm_canvas $Page::($page_obj,canvas_frame)
    $frm_canvas.ude_pop insert 0 command \
    -label $::gPB(block,edit_popup,Label) \
    -command [list UI_PB_func__EditParamExp $page_obj]
    $frm_canvas.ude_pop insert 1 separator
   }
   set g_temp_one_flag 0
   unset g_temp_one_flag
  }
 }

#=======================================================================
proc UI_PB_func__OkParamExp { win page_obj ent } {
  global g_temp_text_var
  global g_temp_one_flag
  set exp_text_name [$ent cget -textvariable]
  set $exp_text_name $g_temp_text_var
  UI_PB_func__SetBalloonText $ent $g_temp_text_var
  unset g_temp_text_var
  destroy $win
  if [info exists g_temp_one_flag] \
  {
   if $g_temp_one_flag \
   {
    set frm_canvas $Page::($page_obj,canvas_frame)
    $frm_canvas.ude_pop insert 0 command \
    -label $::gPB(block,edit_popup,Label) \
    -command [list UI_PB_func__EditParamExp $page_obj]
    $frm_canvas.ude_pop insert 1 separator
   }
   set g_temp_one_flag 0
   unset g_temp_one_flag
  }
  UI_PB_func_DisplayFunctionText $page_obj
 }

#=======================================================================
proc UI_PB_func__RadDataCallBack { w page_obj grid col data_type } {
  set index [UI_PB_func_GetParamIndexFrmWidget $page_obj $col $w]
  if { [expr $index < 0] } { return }
  switch $data_type {
   "Numeral"  {
    set state "normal"
   }
   "Text"   {
    set state "disabled"
   }
   default  {
    return
   }
  }
  set row [expr $index + 1]
  for { set count 1 } { $count < 4 } { incr count } \
  {
   set temp_col [expr $col + $count]
   set parent_w [lindex [$grid entryconfigure $temp_col $row -window] end]
   set child_list [winfo children $parent_w]
   foreach child $child_list \
   {
    $child config -state $state
   }
  }
  UI_PB_func_DisplayFunctionText $page_obj
  update idletasks
 }

#=======================================================================
proc UI_PB_func__CreateIntControl { page_obj param_obj inp_frm ext } {
  global gf_param_arr gf_count
  tixControl $inp_frm.$ext -integer true -min 0 -max 9 \
  -command "UI_PB_func__UpdateFmtDisplay $page_obj" \
  -selectmode immediate \
  -variable function::param_elem::($param_obj,integer) \
  -options {
   entry.width 3
   label.anchor e
  }
  $inp_frm.$ext.frame config -relief sunken -bd 1
  $inp_frm.$ext.frame.entry config -relief flat
  set ent_widget [$inp_frm.$ext subwidget entry]
  bind $ent_widget <KeyPress> "UI_PB_com_ValidateDataOfEntry %W %K i"
  bind $ent_widget <KeyRelease> {%W config -state normal }
  grid $inp_frm.$ext -padx 5
  pack $inp_frm.$ext.frame.entry -side right
  pack $inp_frm.$ext.frame.incr -side top
  pack $inp_frm.$ext.frame.decr -side bottom
 }

#=======================================================================
proc UI_PB_func__UpdateFmtDisplay { page_obj args } {
  UI_PB_func_DisplayFunctionText $page_obj
 }

#=======================================================================
proc UI_PB_func__UpdateAllAddFmt { page_obj args } {
  UI_PB_func_DisplayFunctionText $page_obj
 }

#=======================================================================
proc UI_PB_func__CreateFracControl { page_obj param_obj inp_frm ext } {
  global gf_param_arr gf_count
  tixControl $inp_frm.$ext -integer true -min 0 -max 9 \
  -command "UI_PB_func__UpdateFmtDisplay $page_obj" \
  -selectmode immediate \
  -variable function::param_elem::($param_obj,fraction) \
  -options {
   entry.width 3
   label.anchor e
  }
  $inp_frm.$ext.frame config -relief sunken -bd 1
  $inp_frm.$ext.frame.entry config -relief flat
  set ent_widget [$inp_frm.$ext subwidget entry]
  bind $ent_widget <KeyPress> "UI_PB_com_ValidateDataOfEntry %W %K i"
  bind $ent_widget <KeyRelease> {%W config -state normal }
  grid $inp_frm.$ext -padx 5
 }

#=======================================================================
proc UI_PB_func_tpthCancelCallBack { win page_obj evt_page_obj event_obj evt_elem_obj \
  block_obj blk_elem_obj mode } {
  global gf_disp_flag gf_apply_flag
  global func_w
  if { [info exists func_w] && [winfo exists $func_w] } \
  {
   destroy $func_w
  }
  set gf_disp_flag 0
  if { [string compare $mode "New"] == 0 } \
  {
   set func_obj $Page::($page_obj,func_obj)
   PB_int_DeleteFuncBlk func_obj
   set Page::($evt_page_obj,source_blk_elem_obj) $blk_elem_obj
   set Page::($evt_page_obj,source_evt_elem_obj) $evt_elem_obj
   UI_PB_tpth_PutBlockElemTrash evt_page_obj event_obj
   set Page::($evt_page_obj,source_blk_elem_obj) 0
   set Page::($evt_page_obj,source_evt_elem_obj) 0
  } else \
  {
   if { $gf_apply_flag } \
   {
    set blk_elem [lindex $block::($block_obj,elem_addr_list) 0]
    set base_addr $block_element::($blk_elem,elem_add_obj)
    UI_PB_blk_ReplaceIcon evt_page_obj $base_addr $blk_elem
   }
  }
  UI_PB_func__DeleteAllGridBalloonTips $page_obj
  destroy $win
  PB_com_DeleteObject $page_obj
 }

#=======================================================================
proc UI_PB_func_tpthOkCallBack { win page_obj evt_page_obj event_obj evt_elem_obj \
  block_obj } {
  global func_w
  if { [UI_PB_func_ApplyCallBack $page_obj $block_obj] } \
  {
   return
  }
  if { [info exists func_w] && [winfo exists $func_w] } \
  {
   destroy $func_w
  }
  set blk_elem [lindex $block::($block_obj,elem_addr_list) 0]
  set base_addr $block_element::($blk_elem,elem_add_obj)
  UI_PB_blk_ReplaceIcon evt_page_obj $base_addr $blk_elem
  UI_PB_blk_CreateMenuOptions evt_page_obj event
  UI_PB_func__DeleteAllGridBalloonTips $page_obj
  destroy $win
  PB_com_DeleteObject $page_obj
 }

#=======================================================================
proc UI_PB_func__GetValuesFrmSpecChar { OPTION_LAB OPT_VALUE OPTIONS_LIST } {
  upvar $OPTION_LAB option_lab
  upvar $OPT_VALUE opt_value
  upvar $OPTIONS_LIST options_list
  if {[string compare $option_lab " "] == 0}  {
   set opt_value "gPB(other,opt_space,Label)"
   } elseif {[string compare $option_lab ""] == 0}  {
   set opt_value "gPB(other,opt_none,Label)"
   } else  {
   switch $option_lab  {
    "."     {set opt_value "gPB(other,opt_dec,Label)"}
    ","     {set opt_value "gPB(other,opt_comma,Label)"}
    ";"     {set opt_value "gPB(other,opt_semi,Label)"}
    ":"     {set opt_value "gPB(other,opt_colon,Label)"}
    "("     {set opt_value "gPB(other,opt_left,Label)"}
    ")"     {set opt_value "gPB(other,opt_right,Label)"}
    "*"     {set opt_value "gPB(other,opt_aster,Label)"}
    "/"     {set opt_value "gPB(other,opt_slash,Label)"}
    "\\012" {set opt_value "gPB(other,opt_new_line,Label)"}
    "="     {set opt_value "gPB(other,opt_equal,Label)"}
    default {
     set opt_value "gPB(other,opt_text,Label)"
    }
   }
  }
  if { [lsearch -exact $options_list $opt_value] == -1 } \
  {
   set opt_value "gPB(other,opt_text,Label)"
  }
 }

#=======================================================================
proc UI_PB_func_DefaultCallBack { page_obj } {
  global gf_disp_flag gf_apply_flag
  set gf_disp_flag 0
  set gf_apply_flag 1
  set grid $Page::($page_obj,grid)
  UI_PB_func_ClearAllGridRows page_obj
  set Page::($page_obj,param_obj_list) [list]
  set func_obj $Page::($page_obj,func_obj)
  array set func_attr_arr $function::($func_obj,def_value)
  UI_PB_func_SetFunctionSpecialAttr page_obj func_attr_arr
  set no_row 1
  foreach param_attr_list $function::($func_obj,def_param_attr_list) \
  {
   set new_obj [new function::param_elem]
   array set obj_attr $param_attr_list
   function::param_elem::setvalue $new_obj obj_attr
   lappend Page::($page_obj,param_obj_list) $new_obj
   UI_PB_func__CreateOneRow $page_obj $new_obj $grid $no_row
   incr no_row
  }
  set gf_disp_flag 1
  UI_PB_func_DisplayFunctionText $page_obj
 }

#=======================================================================
proc UI_PB_func_RestoreCallBack { page_obj } {
  global gf_disp_flag gf_apply_flag
  set gf_disp_flag 0
  set grid $Page::($page_obj,grid)
  UI_PB_func_ClearAllGridRows page_obj
  set Page::($page_obj,param_obj_list) [list]
  set func_obj $Page::($page_obj,func_obj)
  array set func_attr_arr $function::($func_obj,rest_value)
  UI_PB_func_SetFunctionSpecialAttr page_obj func_attr_arr
  set no_row 1
  foreach param_attr_list $function::($func_obj,rest_param_attr_list) \
  {
   set new_obj [new function::param_elem]
   array set obj_attr $param_attr_list
   function::param_elem::setvalue $new_obj obj_attr
   lappend Page::($page_obj,param_obj_list) $new_obj
   UI_PB_func__CreateOneRow $page_obj $new_obj $grid $no_row
   incr no_row
  }
  set gf_disp_flag 1
  set gf_apply_flag 1
  UI_PB_func_DisplayFunctionText $page_obj
 }

#=======================================================================
proc UI_PB_func_ApplyCallBack { page_obj block_obj } {
  global gf_disp_flag gf_apply_flag
  global gf_edit_name_flag
  set func_obj $Page::($page_obj,func_obj)
  if $gf_edit_name_flag \
  {
   global gf_edit_name
   if { [UI_PB_func_ValidateFuncName $func_obj $gf_edit_name error_msg] } \
   {
    tk_messageBox -parent [UI_PB_com_AskActiveWindow] \
    -type ok -icon error -message $error_msg
    return 1
   }
   set function::($func_obj,id) $gf_edit_name
  }
  if { [UI_PB_func_CheckFuncFormat $page_obj error_msg] } \
  {
   tk_messageBox -parent [UI_PB_com_AskActiveWindow] \
   -type ok -icon error -message $error_msg
   return 1
  }
  set gf_apply_flag 1
  set old_flag $gf_disp_flag
  set gf_disp_flag 0
  set grid $Page::($page_obj,grid)
  UI_PB_func_SaveFuncInfo $page_obj $func_obj
  set gf_disp_flag $old_flag
  return 0
 }

#=======================================================================
proc UI_PB_func_SaveFuncInfo { page_obj func_obj } {
  global mom_sys_arr
  set function::($func_obj,disp_name) $Page::($page_obj,Func_Name)
  set function::($func_obj,separator) $Page::($page_obj,Word_Seperator)
  set function::($func_obj,func_start) $Page::($page_obj,Comment_Start)
  set function::($func_obj,func_end) $Page::($page_obj,Comment_End)
  if { [info exists mom_sys_arr(Disable_Macro_Output_Attr)] && \
  $mom_sys_arr(Disable_Macro_Output_Attr) } \
  {
  } else \
  {
   set function::($func_obj,output_param_name_flag) $Page::($page_obj,output_param_name_flag)
   set function::($func_obj,output_link_chars) $Page::($page_obj,Link_Char)
  }
  foreach param_obj $function::($func_obj,param_list) \
  {
   PB_com_DeleteObject $param_obj
  }
  set function::($func_obj,param_list) [list]
  foreach param_obj $Page::($page_obj,param_obj_list) \
  {
   function::param_elem::readvalue $param_obj obj_attr
   set new_obj [new function::param_elem]
   function::param_elem::setvalue $new_obj obj_attr
   lappend function::($func_obj,param_list) $new_obj
  }
  function::RestoreValue $func_obj
 }

#=======================================================================
proc UI_PB_func_CheckFuncFormat { page_obj ERROR_MSG } {
  upvar $ERROR_MSG error_msg
  global gPB
  set error_msg ""
  if ![info exists Page::($page_obj,param_obj_list)] \
  {
   return 0
  }
  if { $Page::($page_obj,btn_right) } \
  {
   set prevRow $Page::($page_obj,pos_prevRow)
   set grid $Page::($page_obj,grid)
   UI_PB_func_SetCellBkColor $grid $prevRow "normal"
   UI_PB_func_HightLightGridRow $page_obj $grid
   set Page::($page_obj,btn_right) 0
  }
  set func_name $Page::($page_obj,Func_Name)
  set len [string length $func_name]
  if { $len < 1 } \
  {
   set error_msg $gPB(func,name,blank_err)
   return 1
  }
  foreach param_obj $Page::($page_obj,param_obj_list) \
  {
   if { $function::param_elem::($param_obj,name) == "" } \
   {
    continue
   }
   if { [string compare $function::param_elem::($param_obj,dtype) "Numeral"] == 0 } \
   {
    set exp_str $function::param_elem::($param_obj,exp)
    PB_com_RemoveBlanks exp_str
    if { $exp_str == "" } \
    {
     continue
    }
    if [catch { eval expr $exp_str } res] \
    {
     if { ![string match "*no such variable*" $res] } \
     {
      set error_msg $res
      return 1
     }
    } ;# end if [catch...
    if { [string match "*\"*" $exp_str] } {
     set error_msg "Paramerter $function::param_elem::($param_obj,name): \nExpression could not contain double quote character (\")."
     return 1
    }
   }
  } ;# end foreach
  return 0
 }

#=======================================================================
proc UI_PB_func_GetFuncObjFrmBlkElem { blk_elem } {
  global post_object
  set func_list $Post::($post_object,function_blk_list)
  if { [llength $func_list] == 0 } \
  {
   return 0
  }
  foreach func_obj $func_list \
  {
   foreach temp_elem_obj $function::($func_obj,blk_elem_list) \
   {
    if { $temp_elem_obj == $blk_elem } \
    {
     return $func_obj
    }
   }
  }
  return 0
 }

#=======================================================================
proc UI_PB_func_DisplayFuncBlkAttr { PAGE_OBJ FUNC_OBJ } {
  upvar $PAGE_OBJ page_obj
  upvar $FUNC_OBJ func_obj
  global gf_disp_flag gf_apply_flag
  global func_w
  set gf_disp_flag 0
  set gf_apply_flag 0
  if {[info exists func_w] && [winfo exists $func_w]} \
  {
   destroy $func_w
  }
  if ![info exists Page::($page_obj,param_obj_list)] \
  {
   set Page::($page_obj,param_obj_list) [list]
  }
  UI_PB_func_ClearAllGridRows page_obj
  if { $func_obj == "" || $func_obj == 0 } \
  {
   set gf_disp_flag 1
   UI_PB_func_DisplayFunctionText $page_obj
   return
  }
  set Page::($page_obj,func_obj) $func_obj
  set Page::($page_obj,param_obj_list) [list]
  function::RestoreValue $func_obj
  function::readvalue $func_obj func_attr_arr
  UI_PB_func_SetFunctionSpecialAttr page_obj func_attr_arr
  set grid $Page::($page_obj,grid)
  set no_row 1
  foreach param_obj $func_attr_arr(6) \
  {
   function::param_elem::readvalue $param_obj obj_attr
   set new_obj [new function::param_elem]
   function::param_elem::setvalue $new_obj obj_attr
   lappend Page::($page_obj,param_obj_list) $new_obj
   UI_PB_func__CreateOneRow $page_obj $new_obj $grid $no_row
   incr no_row
  }
  set gf_disp_flag 1
  UI_PB_func_DisplayFunctionText $page_obj
  set Page::($page_obj,resize_flag) 1
 }

#=======================================================================
proc UI_PB_func_SetFunctionSpecialAttr { PAGE_OBJ FUNC_ATTR_ARR } {
  upvar $PAGE_OBJ page_obj
  upvar $FUNC_ATTR_ARR func_attr_arr
  global gf_name_arr
  global mom_sys_arr
  set sep_opts_list $Page::($page_obj,separator_opts_list)
  set cmt_opts_list $Page::($page_obj,comment_opts_list)
  set Page::($page_obj,Func_Name) $func_attr_arr(1)
  set gf_name_arr(Func_Name,char) $func_attr_arr(1)
  UI_PB_func__GetValuesFrmSpecChar func_attr_arr(3) seperator_val sep_opts_list
  set gf_name_arr(Word_Seperator,label) $seperator_val
  set gf_name_arr(Word_Seperator,char) $func_attr_arr(3)
  UI_PB_func__GetValuesFrmSpecChar func_attr_arr(2) start_val cmt_opts_list
  set gf_name_arr(Comment_Start,label) $start_val
  set gf_name_arr(Comment_Start,char) $func_attr_arr(2)
  UI_PB_func__GetValuesFrmSpecChar func_attr_arr(4) end_val cmt_opts_list
  set gf_name_arr(Comment_End,label) $end_val
  set gf_name_arr(Comment_End,char) $func_attr_arr(4)
  if { [info exists mom_sys_arr(Disable_Macro_Output_Attr)] && \
  $mom_sys_arr(Disable_Macro_Output_Attr) } \
  {
  } else \
  {
   set Page::($page_obj,output_param_name_flag) $func_attr_arr(7)
   set lnk_opts_list $Page::($page_obj,output_opts_list)
   UI_PB_func__GetValuesFrmSpecChar func_attr_arr(8) link_val lnk_opts_list
   set gf_name_arr(Link_Char,label) $link_val
   set gf_name_arr(Link_Char,char) $func_attr_arr(8)
  }
 }

#=======================================================================
proc UI_PB_func_CreateFuncBlkPage { PAGE_OBJ func_mode } {
  upvar $PAGE_OBJ page_obj
  global gf_disp_flag
  set Page::($page_obj,page_mode) $func_mode
  set gf_disp_flag 0
  set win $Page::($page_obj,canvas_frame)
  global tcl_platform
  if [string match "windows" $tcl_platform(platform)] \
  {
   $win config -pady 3  ;#<07-15-09 gsl>
  }
  set top_frm [frame $win.top]
  pack $top_frm -side top -fill x
  set pane [tixPanedWindow $win.pane -orient vertical]
  pack $pane -side top -expand yes -fill y
  set f1 [$pane add p1]
  $f1 config -relief flat
  set mid_frm [$pane subwidget p1]
  set f2 [$pane add p2 -expand 1]
  $f2 config -relief flat
  set bot_frm [$pane subwidget p2]
  set Page::($page_obj,pane_frame) $pane;
  UI_PB_func_AddWidgetsToTopFrame $page_obj $top_frm $func_mode
  UI_PB_func_AddWidgetsToMidFrame $page_obj $mid_frm $func_mode
  UI_PB_func_AddWidgetsToBtmFrame $page_obj $bot_frm
  update
  $pane paneconfigure p1 -size [winfo reqheight $mid_frm] -expand 0
  set gf_disp_flag 1
 }

#=======================================================================
proc UI_PB_func_AddWidgetsToTopFrame { page_obj frm mode } {
  global gPB paOption tixOption
  global gf_edit_name_flag
  set gf_edit_name_flag 0
  set xval 0 ;#<07-16-09 wbh>
  if $mode \
  {
   set xval 3 ;#<07-16-09 wbh>
   global gf_edit_name
   set func_obj $Page::($page_obj,func_obj)
   set gf_edit_name $function::($func_obj,id)
   set gf_edit_name_flag 1
   set name_frm [frame $frm.name -bd 0 -relief flat -bg $paOption(name_bg)]
   pack $name_frm -side top -fill x
   tixLabelEntry $name_frm.name -label "$gPB(func,edit,name,Label) :  " \
   -options {
    label.anchor w
    entry.width 64
    entry.anchor w
   }
   [$name_frm.name subwidget label] config -font $tixOption(bold_font)
   [$name_frm.name subwidget label] config -fg $paOption(special_fg) -bg $paOption(name_bg)
   set fch_entry [$name_frm.name subwidget entry]
   $fch_entry config -bd 0 -relief flat
   $fch_entry config -textvariable gf_edit_name
   bind $fch_entry <KeyPress> "UI_PB_com_DisableSpecialChars %W %K"
   bind $fch_entry <KeyPress> "+UI_PB_com_RestrictStringLength %W %K block"
   bind $fch_entry <Control-Key-v> "UI_PB_com_Validate_Control_V %W %K %A block"
   bind $fch_entry <KeyRelease> "UI_PB_com_Validate_Control_V_Release %W"
   pack $name_frm.name -pady 5
   set frm [frame $frm.dsp]
   pack $frm -side top -fill x
  }
  button $frm.but -text    "$gPB(func,help,Label)" -bg $paOption(app_butt_bg) \
  -image   [tix getimage pb_macro_info] \
  -command "UI_PB_func_ShowHelpInfo $page_obj"
  global gPB_help_tips
  PB_enable_balloon $frm.but
  set gPB_help_tips($frm.but) "$gPB(func,help,Label)"
  set gPB(c_help,$frm.but)   "func,help"
  pack $frm.but -side right -padx 5
  set disp_text [tixScrolledText $frm.cntl_ent -height 85 -scrollbar x]
  pack $frm.cntl_ent -fill x -expand yes -padx $xval -pady 3 ;#<06-06-09 gsl> Added -pady
  set ftext [$frm.cntl_ent subwidget text]
  $ftext config -font $gPB(bold_font_lg) -fg white -bg gray85 -wrap none
  set Page::($page_obj,disp_cntl) $ftext
  bind $ftext <Enter> "%W config -bg $paOption(focus)"
  bind $ftext <Leave> "%W config -bg gray85"
  bind $ftext <Configure> "UI_PB_func__ResizeCntlText $page_obj"
 }

#=======================================================================
proc UI_PB_func_ShowHelpInfo { page_obj } {
  global gPB env
  global tixOption paOption
  global func_w
  set func_obj $Page::($page_obj,func_obj)
  if { ![info exists function::($func_obj,description)] || \
  ![llength $function::($func_obj,description)] } \
  {
   tk_messageBox -parent [UI_PB_com_AskActiveWindow] \
   -type ok -icon info -message $gPB(func,help,MSG_NO_INFO)
   return
  }
  set desc_list $function::($func_obj,description)
  set len [llength $desc_list]
  set desc_image ""
  set desc_text ""
  if { $len == 2 } \
  {
   set desc_image [lindex $desc_list 1]
   } elseif { $len >= 3 } \
  {
   set desc_image [lindex $desc_list 1]
   set desc_text  [lindex $desc_list 2]
  }
  set imagefile ""
  if [info exists gPB(controller_family_dir)] \
  {
   set dir "$gPB(controller_family_dir)/info/"
   append imagefile $dir $desc_image.gif
  }
  if [string match {$*} $desc_text] \
  {
   if [catch { eval "set desc_text $desc_text" } err_res] \
   {
    set desc_text ""
   }
  }
  if { ![file exists $imagefile] && [string match "" $desc_text] } \
  {
   tk_messageBox -parent [UI_PB_com_AskActiveWindow] \
   -type ok -icon info -message $gPB(func,help,MSG_NO_INFO)
   return
  }
  set page_w $Page::($page_obj,page_id)
  set func_w $page_w.func_desc
  if [winfo exists $func_w] \
  {
   if {[wm state $func_w] == "iconic"}\
   {
    wm deiconify $func_w
   } else \
   {
    raise $func_w
    focus $func_w
   }
   return
  }
  toplevel $func_w
  if ![string compare $::tix_version 8.4] {
   bind all <MouseWheel> {}
   bind all <Shift-MouseWheel> {}
   wm protocol $func_w WM_DELETE_WINDOW { bind all <MouseWheel> [list UI_PB_mthd_MouseWheel %W %D %X %Y]; \
    bind all <Shift-MouseWheel> [list UI_PB_mthd_MouseWheel %W %D %X %Y x] ; \
   tk_focusFollowsMouse; destroy $func_w}
   bind all <Enter> {}
  }
  wm title $func_w "Description: $function::($func_obj,disp_name)"
  wm geometry $func_w 800x650+200+200
  set pane [tixPanedWindow $func_w.pane -orient vertical]
  pack $pane -expand yes -fill both
  set txtSize 650
  if [file exists $imagefile] \
  {
   set txtSize 300
   set f1 [$pane add p1 -expand 1]
   $f1 config -relief flat
   set p1s [$pane subwidget p1]
   tixCObjView $p1s.c -scrollbar auto
   pack $p1s.c -side top -expand yes -fill both -padx 5 -pady 5
   image create photo macrophoto -file $imagefile
   set img_height [image height macrophoto]
   [$p1s.c subwidget canvas] config -bg white
   [$p1s.c subwidget canvas] create image 10 10 -image macrophoto -anchor nw
   $p1s.c adjustscrollregion
   update
   $pane paneconfigure p1 -size [expr $img_height + 30] -expand 0
  }
  set f2 [$pane add p2 -expand 1]
  $f2 config -relief flat
  set p2s [$pane subwidget p2]
  tixScrolledText $p2s.ent -height $txtSize -scrollbar auto
  pack $p2s.ent -side top -expand yes -fill both -padx 5
  set ftext [$p2s.ent subwidget text]
  $ftext config -font $tixOption(fixed_font) -bg $paOption(table_bg)
  $ftext delete 0.0 end
  $ftext insert end $desc_text
  $ftext configure -state disabled
  UI_PB_com_PositionWindow $func_w
 }

#=======================================================================
proc UI_PB_func__ResizeCntlText { page_obj } {
  if { [info exists Page::($page_obj,resize_flag)] && \
  $Page::($page_obj,resize_flag) } \
  {
   UI_PB_func_DisplayFunctionText $page_obj
  }
 }

#=======================================================================
proc UI_PB_func_AddWidgetsToMidFrame { page_obj pane_frm func_mode } {
  global gPB tixOption
  global mom_sys_arr
  global gf_name_arr
  set frm [frame $pane_frm.w]
  pack $frm -anchor center -fill y  ;#<07-15-09 gsl> Added -fill y
  set output_attr_flag 1
  if { [info exists mom_sys_arr(Disable_Macro_Output_Attr)] && \
  $mom_sys_arr(Disable_Macro_Output_Attr) } \
  {
   set output_attr_flag 0
  }
  tixLabelFrame $frm.name -label $gPB(func,tab,Label) ;#<06-06-09 gsl> was gPB(func,edit,names,Label)
  tixLabelFrame $frm.chr  -label $gPB(func,param_list,Label)
  set sub_frm [$frm.name subwidget frame]
  set flbl [label $sub_frm.lbl -text $gPB(func,disp_name,Label)]
  set fent [entry $sub_frm.ent -textvariable gf_name_arr(Func_Name,char) \
  -font $tixOption(bold_font) \
  -width 18 -bd 2]
  pack $flbl $fent -side left -padx 5 -pady 4 -fill x
  if ![string compare $::tix_version 4.1] \
  {
   bind $fent <KeyRelease> [list UI_PB_func__ValidateEntry $page_obj "Func_Name" %W 1]
  } else \
  {
   $fent config -validate key -vcmd [list UI_PB_func__ValidateEntry $page_obj "Func_Name" %P]
  }
  set spc_frm [$frm.chr subwidget frame]
  set option_1 {"gPB(other,opt_none,Label)"  "gPB(other,opt_space,Label)" \
   "gPB(other,opt_dec,Label)"   "gPB(other,opt_comma,Label)" \
   "gPB(other,opt_semi,Label)"  "gPB(other,opt_colon,Label)" \
  "gPB(other,opt_text,Label)"}
  set option_2 {"gPB(other,opt_none,Label)"  "gPB(other,opt_space,Label)" \
   "gPB(other,opt_left,Label)"  "gPB(other,opt_right,Label)" \
   "gPB(other,opt_aster,Label)" "gPB(other,opt_comma,Label)" \
   "gPB(other,opt_semi,Label)"  "gPB(other,opt_colon,Label)" \
  "gPB(other,opt_slash,Label)" "gPB(other,opt_text,Label)"}
  set Page::($page_obj,separator_opts_list) $option_1
  set Page::($page_obj,comment_opts_list)   $option_2
  set label_list {"Word_Seperator" "Comment_Start"  "Comment_End"}
  set count 0
  foreach label $label_list {
   if {$count < 1}  {
    set options $option_1
    } else  {
    set options $option_2
   }
   UI_PB_func__GetValuesForSpecOptions label default options
   UI_PB_func__CreateSpecAttr $page_obj $spc_frm $label $options $count default
   incr count
   unset options
  }
  if $output_attr_flag \
  {
   tixLabelFrame $frm.out  -label $gPB(func,output,name,Label)
   set out_frm [$frm.out subwidget frame]
   set chk_output [checkbutton $out_frm.ckb -text $gPB(func,output,check,Label) \
   -variable Page::($page_obj,output_param_name_flag) \
   -onvalue 1 -offvalue 0 \
   -command "UI_PB_func_DisplayFunctionText $page_obj"]
   set lbl_link [label $out_frm.lbl -text $gPB(func,output,link,Label) \
   -font $tixOption(font) -anchor w]
   pack $chk_output -side top -anchor w -padx 3 -pady 2
   pack $lbl_link -side left -padx 5 -pady 2
   set label "Link_Char"
   if { ![info exists ::mom_sys_arr($label)] } \
   {
    set ::mom_sys_arr($label) "="
   }
   set ent_link [entry $out_frm.ent -textvariable gf_name_arr($label,char) \
   -font $tixOption(bold_font) \
   -selectbackground yellow \
   -relief sunken -width 3 -bd 2]
   if { ![string compare $::tix_version 4.1] } \
   {
    bind $ent_link <KeyRelease> "UI_PB_func__ValidateEntry $page_obj $label %W 1"
   } else \
   {
    $ent_link config -validate key -vcmd "UI_PB_func__ValidateEntry $page_obj $label %P"
   }
   set output_opts {"gPB(other,opt_none,Label)"  "gPB(other,opt_space,Label)" \
   "gPB(other,opt_equal,Label)" "gPB(other,opt_text,Label)" }
   set Page::($page_obj,output_opts_list) $output_opts
   UI_PB_func__GetValuesForSpecOptions label default output_opts
   set gf_name_arr($label,label) $default
   set optmenu_link [tixOptionMenu $out_frm.opt -variable gf_name_arr($label,label) \
   -command "UI_PB_func__SetSpecChar $page_obj $out_frm $count $label" \
   -options { menubutton.width 8
    menubutton.height 1
   }]
   foreach opt $output_opts \
   {
    $optmenu_link add command $opt -label [set $opt]
   }
   UI_PB_func__SetSpecChar $page_obj $out_frm $count $label
   set Page::($page_obj,Link_Char) $gf_name_arr($label,char)
   pack $optmenu_link $ent_link -side right -fill x -padx 3
  }
  set padx 5
  set pady 3
  if $output_attr_flag \
  {
   tixForm $frm.name                 -left %0         -right %45                    -padx $padx -pady $pady
   tixForm $frm.out  -top $frm.name  -left &$frm.name -right &$frm.name             -padx $padx -pady $pady
   tixForm $frm.chr  -top &$frm.name -left $frm.name  -bottom &$frm.out -right %100 -padx $padx -pady $pady
  } else \
  {
   tixForm $frm.name -top %25 -left %0        -right %45  -padx $padx -pady $pady
   tixForm $frm.chr           -left $frm.name -right %100 -padx $padx -pady $pady
  }
 }

#=======================================================================
proc UI_PB_func__GetValuesForSpecOptions { OPTION_LAB OPT_VALUE OPTIONS_LIST } {
  upvar $OPTION_LAB option_lab
  upvar $OPT_VALUE opt_value
  upvar $OPTIONS_LIST options_list
  global mom_sys_arr
  if {[string compare $mom_sys_arr($option_lab) " "] == 0} \
  {
   set opt_value "gPB(other,opt_space,Label)"
   } elseif {[string compare $mom_sys_arr($option_lab) ""] == 0} \
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
    "*"     {set opt_value "gPB(other,opt_aster,Label)"}
    "/"     {set opt_value "gPB(other,opt_slash,Label)"}
    "\\012" {set opt_value "gPB(other,opt_new_line,Label)"}
    "="     {set opt_value "gPB(other,opt_equal,Label)"}
    default {
     set opt_value "gPB(other,opt_text,Label)"
    }
   }
  }
  if { [lsearch -exact $options_list $opt_value] == -1 } \
  {
   set opt_value "gPB(other,opt_text,Label)"
  }
 }

#=======================================================================
proc UI_PB_func_AddWidgetsToBtmFrame { page_obj frm } {
  global gPB paOption tixOption
  global gf_count
  set gf_count 0
  tixScrolledGrid $frm.scr -bd 0 -scrollbar auto
  [$frm.scr subwidget hsb] config -troughcolor $paOption(trough_bg)  -width $paOption(trough_wd)
  [$frm.scr subwidget vsb] config -troughcolor $paOption(trough_bg)  -width $paOption(trough_wd)
  pack $frm.scr -padx 3 -pady 3 -fill y -expand yes ;#<07-15-09 wbh> 5 was 0 <gsl> changed to 3
  set grid [$frm.scr subwidget grid]
  set Page::($page_obj,grid) $grid
  set Page::($page_obj,btn_right)    0
  set Page::($page_obj,copy_flag)    0
  set Page::($page_obj,pos_prevCol) -1
  set Page::($page_obj,pos_prevRow) -1
  set Page::($page_obj,pos_curCol)  -1
  set Page::($page_obj,pos_curRow)  -1
  set Page::($page_obj,pos_maxCol)   0
  set Page::($page_obj,pos_maxRow)   0
  set Page::($page_obj,pos_autoCol)  0
  switch $::tix_version {
   8.4 {
    $grid config -relief sunken -bd 3 \
    -formatcmd "UI_PB_func_SimpleFormat $page_obj $grid" \
    -state normal -height 8 -width 9
   }
   4.1 {
    $grid config -relief sunken -bd 3 \
    -formatcmd "UI_PB_func_SimpleFormat $page_obj $grid" \
    -state disabled -height 8 -width 9
   }
  }
  bind $grid <Button-1> "UI_PB_func_LeftBtnClickInGrid $page_obj %W %x %y"
  bind $grid <3> "UI_PB_func_RightBtnClickInGrid $page_obj %W %x %y %X %Y"
  bind $grid <Motion> "UI_PB_func_MouseMoveInGrid $page_obj %W %x %y"
  UI_PB_func__GetGridColumnNumberTitleAndWidth no_col title_col wid_col
  set no_col 6
  set Page::($page_obj,pos_maxCol) $no_col
  $grid size row default -size auto -pad0 3 -pad1 3
  $grid configure -selectmode single -selectunit row
  for { set i 0 } { $i < 6 } { incr i } {
   $grid size col $i -size $wid_col($i) -pad0 5 -pad1 1
  }
  if 0 {
   $grid size col 0 -size 10char -pad0 5 -pad1 1
   $grid size col 1 -size 30char -pad0 5 -pad1 1
   $grid size col 2 -size 16char -pad0 5 -pad1 1
   $grid size col 3 -size 7char  -pad0 5 -pad1 1
   $grid size col 4 -size 9char  -pad0 5 -pad1 1
   $grid size col 5 -size 7char  -pad0 5 -pad1 1
  }
  set style [tixDisplayStyle text -refwindow $grid  -fg $paOption(title_fg)  -anchor c -font $tixOption(bold_font)]
  $grid set 0 0 -itemtype text -text $title_col(0)  -style $style
  for { set col 1 } { $col < $no_col } { incr col } \
  {
   $grid set $col 0 -itemtype text -text $title_col($col) -style $style
  }
  set Page::($page_obj,pos_maxRow) 1
  set Page::($page_obj,col_style) [tixDisplayStyle window -refwindow $grid \
  -anchor c -padx 5 -pady 1]
 }

#=======================================================================
proc UI_PB_func__GetGridColumnNumberTitleAndWidth { NUMBER TITLE_ARR WIDTH_ARR } {
  upvar $NUMBER    col_number
  upvar $TITLE_ARR title_arr
  upvar $WIDTH_ARR width_arr
  global gPB
  set col_number 6
  set title_arr(0)  "$gPB(func,col_param,Label)"
  set title_arr(1)  "$gPB(func,col_exp,Label)"
  set title_arr(2)  "$gPB(addrsum,col_data,Label)"
  set title_arr(3)  "$gPB(addrsum,col_int,Label)"
  set title_arr(4)  "$gPB(addrsum,col_dec,Label)"
  set title_arr(5)  "$gPB(addrsum,col_frac,Label)"
  set width_arr(0) 10  ;# Parameter
  set width_arr(1) 30  ;# Expression
  set width_arr(2) 16  ;# Data Type
  set width_arr(3) 7   ;# Integer
  set width_arr(4) 9   ;# Decimal
  set width_arr(5) 7   ;# Fraction
  for { set i 0 } { $i < 6 } { incr i } {
   if { [string length $title_arr($i)] > $width_arr($i) } {
    set width_arr($i) [string length $title_arr($i)]
   }
   if { $i == 2 } {
    set num_len [string length $gPB(addrsum,radio_num,Label)]
    set txt_len [string length $gPB(addrsum,radio_text,Label)]
    set total_len [expr $num_len + $txt_len + 6]
    if { $total_len > $width_arr($i) } {
     set width_arr($i) $total_len
    }
   }
   append width_arr($i) "char"
  }
 }

#=======================================================================
proc UI_PB_func_ReCreateGridWidgets { page_obj } {
  global gPB
  set temp_bind [bind $gPB(main_window) <Destroy>]
  bind $gPB(main_window) <Destroy> ""
  UI_PB_func__DeleteAllGridBalloonTips $page_obj
  set pane $Page::($page_obj,pane_frame)
  set bot_frm [$pane subwidget p2]
  destroy $bot_frm.scr
  bind $gPB(main_window) <Destroy> $temp_bind
  UI_PB_func_AddWidgetsToBtmFrame $page_obj $bot_frm
 }

#=======================================================================
proc UI_PB_func__DeleteAllGridBalloonTips { page_obj } {
  global gPB_help_tips
  set grid $Page::($page_obj,grid)
  set maxRow $Page::($page_obj,pos_maxRow)
  for { set row 1 } { $row < $maxRow } { incr row } \
  {
   set exp_frm [lindex [$grid entryconfigure 1 $row -window] end]
   if [info exists gPB_help_tips($exp_frm.ent)] \
   {
    unset gPB_help_tips($exp_frm.ent)
   }
  }
 }

#=======================================================================
proc UI_PB_ProgTpth_FunctionCall { book_id func_page_obj } {
  global gPB
  global pb_function_id
  set Page::($func_page_obj,page_id) [$book_id subwidget \
  $Page::($func_page_obj,page_name)]
  if [info exists Page::($func_page_obj,active_func_obj)] \
  {
   unset Page::($func_page_obj,active_func_obj)
  }
  Page::CreatePane $func_page_obj
  UI_PB_func_AddComponentsLeftPane func_page_obj
  Page::CreateTree $func_page_obj
  UI_PB_func_CreateTreePopup func_page_obj
  UI_PB_func_CreateTreeElements func_page_obj
  set canvas_frm $Page::($func_page_obj,canvas_frame)
  set box1_frm [frame $canvas_frm.box1]
  pack $box1_frm -side bottom -fill x -padx 3  ;#<07-09-09 wbh> add -padx 3
  set label_list {"gPB(nav_button,default,Label)" \
  "gPB(nav_button,restore,Label)"}
  set cb_arr(gPB(nav_button,default,Label)) \
  "UI_PB_func_DefaultCallBack $func_page_obj"
  set cb_arr(gPB(nav_button,restore,Label)) \
  "UI_PB_func_RestoreCallBack $func_page_obj"
  UI_PB_com_CreateButtonBox $box1_frm label_list cb_arr
  set pb_function_id ""
  UI_PB_func_CreateFuncBlkPage func_page_obj 0
  UI_PB_func__CreateCommonPopupLabels $func_page_obj
 }

#=======================================================================
proc UI_PB_func_AddComponentsLeftPane { PAGE_OBJ } {
  upvar $PAGE_OBJ page_obj
  global gPB
  global paOption
  set left_pane $Page::($page_obj,left_pane_id)
  set but [frame $left_pane.f]
  set new [button $but.new -text "$gPB(tree,create,Label)" \
  -command "UI_PB_func_CreateAFuncBlock $page_obj" \
  -bg $paOption(app_butt_bg) -state normal]
  set del [button $but.del -text "$gPB(tree,cut,Label)" \
  -command "UI_PB_func_CutAFuncBlock $page_obj" \
  -bg $paOption(app_butt_bg) -state normal]
  set pas [button $but.pas -text "$gPB(tree,paste,Label)" \
  -command "UI_PB_func_PasteAFuncBlock $page_obj" \
  -bg $paOption(app_butt_bg) -state disabled]
  pack $new $del $pas -side left -fill x -expand yes
  pack $but -side top -fill x -padx 7
  set gPB(c_help,$new)   "tree,create"
  set gPB(c_help,$del)   "tree,cut"
  set gPB(c_help,$pas)   "tree,paste"
 }

#=======================================================================
proc UI_PB_func_CreateTreePopup { PAGE_OBJ } {
  upvar $PAGE_OBJ page_obj
  set tree $Page::($page_obj,tree)
  set h [$tree subwidget hlist]
  set popup [menu $h.pop -tearoff 0]
  set Page::($page_obj,tree_popup) $popup
  bind $h <3> "UI_PB_func_CreateTreePopupElements $page_obj %X %Y %x %y"
 }

#=======================================================================
proc UI_PB_func_CreateTreePopupElements { page_obj X Y x y } {
  global gPB
  set tree $Page::($page_obj,tree)
  set h [$tree subwidget hlist]
  raise $gPB(main_window)
  set cursor_entry [$h nearest $y]
  set indent [$h cget -indent]
  if { [string compare $cursor_entry "0"] != 0 } \
  {
   if {![info exists Page::($page_obj,selected_index)]} {
    set Page::($page_obj,selected_index) -1
   }
   if [string match $Page::($page_obj,selected_index) $cursor_entry] {
    set Page::($page_obj,selected_index) -1
   }
   UI_PB_func_SelectItem $page_obj $cursor_entry
  }
  set popup $Page::($page_obj,tree_popup)
  set active_index [$h info selection]
  if { $x >= [expr $indent * 2] && \
  $active_index == $cursor_entry } \
  {
   $popup delete 0 end
   set indx_string [$h entrycget $active_index -text]
   $popup add command -label "$gPB(tree,rename,Label)" -state normal \
   -command "UI_PB_func_EditFuncID $page_obj $active_index"
   $popup add sep
   $popup add command -label "$gPB(tree,create,Label)" -state normal \
   -command "UI_PB_func_CreateAFuncBlock $page_obj"
   $popup add command -label "$gPB(tree,cut,Label)" -state normal \
   -command "UI_PB_func_CutAFuncBlock $page_obj"
   if { [info exists Page::($page_obj,buff_func_obj)] } \
   {
    $popup add command -label "$gPB(tree,paste,Label)" -state normal \
    -command "UI_PB_func_PasteAFuncBlock $page_obj"
   } else \
   {
    $popup add command -label "$gPB(tree,paste,Label)" -state disabled \
    -command ""
   }
   tk_popup $popup $X $Y
  }
 }

#=======================================================================
proc UI_PB_func_CreateAFuncBlock { page_obj } {
  if { [info exists Page::($page_obj,rename_index)] } \
  {
   if { [UI_PB_func_UpdateFuncEntry $page_obj \
    $Page::($page_obj,rename_index)] == "UI_PB_ERROR" } {
    return
   }
  }
  if [UI_PB_func_CheckFuncFormat $page_obj error_msg] \
  {
   tk_messageBox -parent [UI_PB_com_AskActiveWindow] \
   -type ok -icon error -message $error_msg
   return
  }
  if { ![info exists Page::($page_obj,active_func_obj)] } \
  {
   set act_func_obj 0
  } else \
  {
   set act_func_obj $Page::($page_obj,active_func_obj)
   UI_PB_func_SaveFuncInfo $page_obj $act_func_obj
   unset Page::($page_obj,active_func_obj)
  }
  PB_int_CreateFuncFrmFuncObj act_func_obj new_func_obj obj_index
  if $act_func_obj \
  {
   set old_desc_list $function::($act_func_obj,description)
   if { [llength $old_desc_list] > 1 } \
   {
    set new_desc_list [lrange $old_desc_list 1 end]
    set desc_type [lindex $function::($new_func_obj,description) 0]
    set function::($new_func_obj,description) \
    [linsert $new_desc_list 0 $desc_type]
   }
  }
  UI_PB_func_DisplayFuncBlocks page_obj obj_index
  UI_PB_func_SelectItem $page_obj
 }

#=======================================================================
proc UI_PB_func_CutAFuncBlock { page_obj } {
  global gPB
  if { ![info exists Page::($page_obj,active_func_obj)] } \
  {
   return
  }
  set active_func_obj $Page::($page_obj,active_func_obj)
  if {$function::($active_func_obj,blk_elem_list) != ""} \
  {
   tk_messageBox -parent [UI_PB_com_AskActiveWindow] -type ok -icon error \
   -message "$gPB(msg,in_use)"
  } else \
  {
   if [info exists Page::($page_obj,buff_func_obj)] \
   {
    PB_com_DeleteObject $Page::($page_obj,buff_func_obj)
    unset Page::($page_obj,buff_func_obj)
   }
   UI_PB_func_SaveFuncInfo $page_obj $active_func_obj
   set tree $Page::($page_obj,tree)
   set HLIST [$tree subwidget hlist]
   set ent [$HLIST info selection]
   set obj_index [string range $ent 2 end]
   set Page::($page_obj,buff_func_obj) $active_func_obj
   global post_object
   set func_blk_list $Post::($post_object,function_blk_list)
   set temp_index [lsearch $func_blk_list $active_func_obj]
   set func_blk_list [lreplace $func_blk_list $temp_index $temp_index]
   set Post::($post_object,function_blk_list) $func_blk_list
   unset Page::($page_obj,active_func_obj)
   unset Page::($page_obj,selected_index)
   UI_PB_func_DisplayFuncBlocks page_obj obj_index
   UI_PB_func_SelectItem $page_obj
   set left_pane_id $Page::($page_obj,left_pane_id)
   $left_pane_id.f.pas config -state normal
  }
 }

#=======================================================================
proc UI_PB_func_PasteAFuncBlock { page_obj } {
  if {![info exists Page::($page_obj,buff_func_obj)]} \
  {
   return
  }
  if { [info exists Page::($page_obj,rename_index)] } \
  {
   if { [UI_PB_func_UpdateFuncEntry $page_obj \
    $Page::($page_obj,rename_index)] == "UI_PB_ERROR" } {
    return
   }
  }
  set tree $Page::($page_obj,tree)
  set HLIST [$tree subwidget hlist]
  set ent [$HLIST info selection]
  set obj_index [string range $ent 2 end]
  if { $obj_index == "" } \
  {
   set obj_index 0
  } else \
  {
   incr obj_index
  }
  global post_object
  set buff_func_obj $Page::($page_obj,buff_func_obj)
  set func_blk_list $Post::($post_object,function_blk_list)
  set func_blk_list [linsert $func_blk_list $obj_index $buff_func_obj]
  set Post::($post_object,function_blk_list) $func_blk_list
  set obj_index [lsearch $func_blk_list $buff_func_obj]
  UI_PB_func_DisplayFuncBlocks page_obj obj_index
  UI_PB_func_SelectItem $page_obj
  set left_pane_id $Page::($page_obj,left_pane_id)
  $left_pane_id.f.pas config -state disabled
  unset Page::($page_obj,buff_func_obj)
 }

#=======================================================================
proc UI_PB_func_CreateTreeElements { PAGE_OBJ } {
  upvar $PAGE_OBJ page_obj
  global paOption
  set tree $Page::($page_obj,tree)
  set h [$tree subwidget hlist]
  $h config -bg $paOption(tree_bg)
  uplevel #0 set TRANSPARENT_GIF_COLOR [$h cget -bg]
  $tree config -command   "UI_PB_func_EditFuncID $page_obj" \
  -browsecmd "UI_PB_func_SelectItem  $page_obj"
 }

#=======================================================================
proc UI_PB_func_EditFuncID { page_obj index } {
  global gPB
  global paOption
  global pb_function_id
  set tree $Page::($page_obj,tree)
  set HLIST [$tree subwidget hlist]
  set indx_string [$HLIST entrycget $index -text]
  set pb_function_id $indx_string
  set next_ent [$HLIST info next $index]
  if [string match "" $next_ent] {
   set prev_ent [$HLIST info prev $index]
  }
  $HLIST delete entry $index
  set col [string range $index 2 end]
  if { [winfo exists $HLIST.func] != 1 } \
  {
   set new_frm [frame $HLIST.func -bg $paOption(tree_bg)]
   label $new_frm.lbl -text "" -bg $paOption(tree_bg)
   set img_id [image create compound -window $new_frm.lbl]
   $img_id add image -image $gPB(pb_func_icon)
   $new_frm.lbl config -image $img_id
   unset img_id
   pack $new_frm.lbl -side left
   entry $new_frm.ent -bd 1 -relief solid -state normal \
   -textvariable pb_function_id -justify left
   pack $new_frm.ent -side left;# -padx 2
  } else \
  {
   set new_frm $HLIST.func
  }
  set wid [string length $pb_function_id]
  if { $wid < $gPB(MOM_obj_name_len) } { set wid $gPB(MOM_obj_name_len) }
  $new_frm.ent config -width $wid
  if [string match "" $next_ent] {
   if { [string compare $prev_ent "0"] == 0 } {
    $HLIST add $index -itemtype window -window $new_frm
    } else {
    $HLIST add $index -itemtype window -window $new_frm -after $prev_ent
   }
   } else {
   $HLIST add $index -itemtype window -window $new_frm -before $next_ent
  }
  $HLIST see $index
  focus $new_frm.ent
  bind $new_frm.ent <Return> "UI_PB_func_UpdateFuncEntry $page_obj $index"
  bind $new_frm.ent <KeyPress> "UI_PB_com_DisableSpecialChars %W %K"
  bind $new_frm.ent <KeyRelease> { %W config -state normal }
  $new_frm.ent selection range 0 end
  $new_frm.ent icursor end
  set Page::($page_obj,rename_index) $index
  $HLIST entryconfig $index -state disabled
  bind $new_frm.lbl <1> "UI_PB_func_UpdateFuncEntry $page_obj $index"
  grab $Page::($page_obj,left_pane_id)
 }

#=======================================================================
proc UI_PB_func_UpdateFuncEntry {  page_obj index } {
  global gPB
  global pb_function_id
  if { ![info exists Page::($page_obj,rename_index)] || \
   ![info exists Page::($page_obj,active_func_obj)] } {
   return
  }
  set active_func $Page::($page_obj,active_func_obj)
  set tree $Page::($page_obj,tree)
  set HLIST [$tree subwidget hlist]
  set style $gPB(font_style_normal)
  set func_icon $gPB(pb_func_icon)
  set cur_func_id $pb_function_id
  set err_msg ""
  set err_flag [UI_PB_func_ValidateFuncName $active_func $cur_func_id err_msg]
  if $err_flag \
  {
   $HLIST selection clear
   $HLIST anchor clear
   if { $index != "" }  {
    $HLIST entryconfig $index -state disabled
   }
   if { [winfo exists $HLIST.func.ent] }  {
    focus $HLIST.func.ent
   }
   tk_messageBox -parent [UI_PB_com_AskActiveWindow] \
   -type ok -icon error \
   -message $err_msg
   return "UI_PB_ERROR"
  }
  set function::($active_func,id) $pb_function_id
  set next_ent [$HLIST info next $index]
  if [string match "" $next_ent] {
   set prev_ent [$HLIST info prev $index]
  }
  $HLIST delete entry $index
  if [string match "" $next_ent] {
   if { [string compare $prev_ent "0"] == 0 } {
    $HLIST add $index -itemtype imagetext -text "$cur_func_id" \
    -image $func_icon -style $style
    } else {
    $HLIST add $index -itemtype imagetext -text "$cur_func_id" \
    -image $func_icon -style $style -after $prev_ent
   }
   } else {
   $HLIST add $index -itemtype imagetext -text "$cur_func_id" \
   -image $func_icon -style $style -before $next_ent
  }
  $HLIST selection set $index
  $HLIST anchor set $index
  grab release [grab current]
  unset Page::($page_obj,rename_index)
  return 0
 }

#=======================================================================
proc UI_PB_func_ValidateFuncName { cur_func_obj cur_func_name ERR_MSG } {
  upvar $ERR_MSG err_msg
  global gPB
  set err_flag 0
  set err_msg ""
  set len [string length $cur_func_name]
  if { $len == 0 } \
  {
   set err_flag 1
   set err_msg "\"$cur_func_name\" $gPB(func,tree_node,contain_err)"
  } else \
  {
   for { set i 0 } { $i < $len } { incr i } \
   {
    set char [string index $cur_func_name $i]
    if { ![string match {[a-zA-Z0-9_]} $char] } \
    {
     set err_flag 1
     set err_msg "\"$cur_func_name\" $gPB(func,tree_node,contain_err)"
     break
    }
   }
  }
  if { $err_flag == 0 } \
  {
   PB_int_RetFunctionBlks func_blk_list
   set pos [lsearch $func_blk_list $cur_func_obj]
   set func_blk_list [lreplace $func_blk_list $pos $pos]
   foreach func_obj $func_blk_list {
    if [string match $cur_func_name $function::($func_obj,id)] \
    {
     set err_flag 1
     set err_msg "\"$cur_func_name\" $gPB(msg,name_exists)"
     break
    }
   }
  }
  return $err_flag
 }

#=======================================================================
proc UI_PB_func_FuncTabDelete { PAGE_OBJ } {
  upvar $PAGE_OBJ page_obj
  if [info exists Page::($page_obj,selected_index)] {
   unset Page::($page_obj,selected_index)
  }
  if [info exists Page::($page_obj,active_func_obj)]  {
   unset Page::($page_obj,active_func_obj)
  }
 }

#=======================================================================
proc UI_PB_func_FuncTabCreate { PAGE_OBJ } {
  upvar $PAGE_OBJ page_obj
  set tree $Page::($page_obj,tree)
  set HLIST [$tree subwidget hlist]
  set ent [$HLIST info selection]
  set index [string range $ent 2 end]
  if {[string compare $index ""] == 0} \
  {
   set index 0
  }
  UI_PB_func_DisplayFuncBlocks page_obj index
  UI_PB_func_SelectItem $page_obj
 }

#=======================================================================
proc UI_PB_func_DisplayFuncBlocks { PAGE_OBJ OBJ_INDEX } {
  upvar $PAGE_OBJ page_obj
  upvar $OBJ_INDEX obj_index
  global gPB paOption post_object
  set style $gPB(font_style_normal)
  set tree $Page::($page_obj,tree)
  set HLIST [$tree subwidget hlist]
  $HLIST delete all
  $HLIST add 0 -itemtype imagetext -text "" -image $paOption(folder) \
  -state disabled
  set func_icon  $gPB(pb_func_icon)
  set func_obj_list $Post::($post_object,function_blk_list)
  set no_blks 0
  foreach func_obj $func_obj_list \
  {
   set func_id $function::($func_obj,id)
   if [string match "just_mcall_sinumerik" $func_id] \
   {
    continue
   }
   $HLIST add 0.$no_blks -itemtype imagetext -text $func_id \
   -image $func_icon -style $style
   incr no_blks
  }
  if { $no_blks } \
  {
   UI_PB_func_SetDisplayPaneState $page_obj 1
   if { $obj_index >= $no_blks } \
   {
    set obj_index [expr $no_blks - 1]
   }
   if [$HLIST info exists 0.$obj_index] {
    $HLIST selection set 0.$obj_index
    } elseif [$HLIST info exists 0.0] {
    $HLIST selection set 0.0
    } else {
    $HLIST selection set 0
   }
  } else \
  {
   $HLIST selection set 0
   UI_PB_func_SetDisplayPaneState $page_obj 0
  }
 }

#=======================================================================
proc UI_PB_func_SetDisplayPaneState { page_obj state } {
  set win $Page::($page_obj,canvas_frame)
  set box1_frm $win.box1
  set top_frm $win.top
  set pane $win.pane
  if { $state } \
  {
   pack $box1_frm -side bottom -fill x -padx 3 ;#<07-09-09 wbh> add -padx 3
   pack $top_frm -side top -fill x -padx 3 -pady 5
   pack $pane -side top -expand yes -fill y ;#<07-15-09 wbh> add -expand & -fill
  } else \
  {
   pack forget $box1_frm $top_frm $pane
  }
 }

#=======================================================================
proc UI_PB_func_SelectItem { page_obj args } {
  global pb_function_id
  set pg_name $Page::($page_obj,page_name)
  if { [info exists Page::($page_obj,rename_index)] } \
  {
   if { [UI_PB_func_UpdateFuncEntry $page_obj \
    $Page::($page_obj,rename_index)] == "UI_PB_ERROR" } {
    return
   }
  }
  set canvas_frame $Page::($page_obj,canvas_frame)
  set tree $Page::($page_obj,tree)
  set HLIST [$tree subwidget hlist]
  if { ![info exists Page::($page_obj,selected_index)] } {
   set Page::($page_obj,selected_index) -1
  }
  set ent [lindex $args 0]
  if { $ent == "" } \
  {
   set ent [$HLIST info selection]
   } elseif { [string match "0" $ent] }  {
   $HLIST selection clear
   $HLIST anchor clear
   $HLIST selection set 0.0
   $HLIST anchor set 0.0
   set ent 0.0
  }
  if [string match "$ent" $Page::($page_obj,selected_index)] \
  {
   return [UI_PB_func_EditFuncID $page_obj $ent]
  }
  set index [string range $ent 2 end]
  set index [string trim $index]
  if { [string match "" $index] } \
  {
   set func_obj ""
  } else \
  {
   set func_name [$HLIST entrycget 0.$index -text]
   PB_int_RetFunctionBlks func_obj_list
   PB_com_RetObjFrmName func_name func_obj_list func_obj
  }
  if [info exists Page::($page_obj,active_func_obj)] \
  {
   set active_func_obj $Page::($page_obj,active_func_obj)
   if [UI_PB_func_CheckFuncFormat $page_obj error_msg] \
   {
    set pre_index $Page::($page_obj,selected_index)
    $HLIST selection clear
    $HLIST anchor clear
    $HLIST selection set $pre_index
    $HLIST anchor set $pre_index
    tk_messageBox -parent [UI_PB_com_AskActiveWindow] \
    -type ok -icon error -message $error_msg
    return
   }
   UI_PB_func_SaveFuncInfo $page_obj $active_func_obj
   unset Page::($page_obj,active_func_obj)
  }
  set Page::($page_obj,selected_index) $ent
  if { $func_obj != "" } \
  {
   UI_PB_func_ReCreateGridWidgets $page_obj
   update
   UI_PB_func_DisplayFuncBlkAttr page_obj func_obj
   set Page::($page_obj,active_func_obj) $func_obj
   set left_pane $Page::($page_obj,left_pane_id)
   set new $left_pane.f.new
   set del $left_pane.f.del
   $new config -state normal
   $del config -state normal
  }
  $HLIST selection clear
  $HLIST anchor clear
  if {![string match "" $ent]} {
   $HLIST selection set $ent
   $HLIST anchor set $ent
  }
 }

#=======================================================================
proc UI_PB_func_SeqNewFuncBlkOk_CB { win page_obj seq_obj elem_obj \
  func_page_obj } {
  global paOption
  global gPB
  set block_obj $event_element::($elem_obj,block_obj)
  if { [UI_PB_func_ApplyCallBack $func_page_obj $block_obj] } \
  {
   return
  }
  set func_blk_elem [lindex $block::($block_obj,elem_addr_list) 0]
  set func_obj $block_element::($func_blk_elem,elem_mom_variable)
  function::GetDisplayText $func_obj blk_nc_code
  set block_element::($func_blk_elem,elem_desc)  "$gPB(seq,combo,macro,Label)"
  UI_PB_com_TrunkNcCode blk_nc_code
  set elem_text $blk_nc_code
  set bot_canvas $Page::($page_obj,bot_canvas)
  set t_shift $Page::($page_obj,glob_text_shift)
  set elem_xc $event_element::($elem_obj,xc)
  set elem_yc $event_element::($elem_obj,yc)
  $bot_canvas delete $event_element::($elem_obj,text_id)
  set index [lsearch $sequence::($seq_obj,texticon_ids)  $event_element::($elem_obj,text_id)]
  set elem_icon_id [lindex $sequence::($seq_obj,texticon_ids)  [expr $index + 1]]
  set sequence::($seq_obj,texticon_ids)  [lreplace $sequence::($seq_obj,texticon_ids) $index  [expr $index + 1]]
  set elem_text_id [$bot_canvas create text [expr $elem_xc + $t_shift]  $elem_yc -text $elem_text -font $gPB(font_sm) -justify left  -tag blk_movable]
  set event_element::($elem_obj,text_id) $elem_text_id
  lappend sequence::($seq_obj,texticon_ids) $elem_text_id $elem_icon_id
  set blk_img_id $event_element::($elem_obj,icon_id)
  set img [lindex [$bot_canvas itemconfigure $blk_img_id -image] end]
  $img config -relief raised -bg $paOption(special_fg)
  UI_PB_evt_CreateMenuOptions page_obj seq_obj
  destroy $win
  PB_com_DeleteObject $func_page_obj
 }

#=======================================================================
proc UI_PB_func_SeqNewFuncBlkCancel_CB { win page_obj seq_obj evt_obj elem_obj \
  func_page_obj } {
  set sequence::($seq_obj,drag_evt_obj) $evt_obj
  set sequence::($seq_obj,drag_blk_obj) $elem_obj
  set block_obj $event_element::($elem_obj,block_obj)
  set func_blk_elem [lindex $block::($block_obj,elem_addr_list) 0]
  set func_obj $block_element::($func_blk_elem,elem_mom_variable)
  UI_PB_evt_PutBlkInTrash page_obj seq_obj
  PB_int_DeleteFuncBlk func_obj
  unset sequence::($seq_obj,drag_blk_obj)
  unset sequence::($seq_obj,drag_evt_obj)
  destroy $win
  PB_com_DeleteObject $func_page_obj
 }

#=======================================================================
proc UI_PB_func_SeqEditFuncBlkOk_CB { win page_obj seq_obj elem_obj \
  func_page_obj } {
  global func_w
  set block_obj $event_element::($elem_obj,block_obj)
  if { [UI_PB_func_ApplyCallBack $func_page_obj $block_obj] } \
  {
   return
  }
  if { [info exists func_w] && [winfo exists $func_w] } \
  {
   destroy $func_w
  }
  UI_PB_evt_DeleteSeqEvents page_obj seq_obj
  UI_PB_evt_CreateSeqAttributes page_obj
  destroy $win
  PB_com_DeleteObject $func_page_obj
 }

#=======================================================================
proc UI_PB_func_SeqEditFuncBlkCancel_CB { win page_obj seq_obj event_obj \
  elem_obj func_page_obj } {
  global paOption gf_apply_flag
  global func_w
  if { [info exists func_w] && [winfo exists $func_w] } \
  {
   destroy $func_w
  }
  set block_obj $event_element::($elem_obj,block_obj)
  set bot_canvas $Page::($page_obj,bot_canvas)
  set blk_img_id $event_element::($elem_obj,icon_id)
  set img [lindex [$bot_canvas itemconfigure $blk_img_id -image] end]
  if { [UI_PB_evt_RetNoEvtElemsOfBlk block_obj] > 1 }  {
   $img config -relief raised -bg $paOption(text)
   } else  {
   $img config -relief raised -bg $paOption(special_fg)
  }
  if { $gf_apply_flag } {
   UI_PB_evt_DeleteSeqEvents page_obj seq_obj
   UI_PB_evt_CreateSeqAttributes page_obj
  }
  destroy $win
  PB_com_DeleteObject $func_page_obj
 }
