#15
UI_PB_AddPatchMsg "2001.0.1" "<08-02-02>  Fixed problem with a custom cycle containing no element."
UI_PB_AddPatchMsg "2001.0.1" "<10-08-02>  Fixed problem with cycles using G79 causing\
extra blocks to be created."

#=======================================================================
proc PB_evt_CreateSeqEvents { POST_OBJ EVT_OBJ_LIST EVT_LIST_NAME EVT_LIST_LABEL \
  EVT_BLK_LIST_NAME SEQ_NAME {evt_ude_list_name NULL} } {
  upvar $POST_OBJ post_obj
  upvar $EVT_OBJ_LIST evt_obj_list
  upvar $EVT_LIST_NAME evt_list_name
  upvar $EVT_LIST_LABEL evt_list_label
  upvar $EVT_BLK_LIST_NAME evt_blk_list_name
  upvar $SEQ_NAME sequence_name
  array set evt_name_arr $Post::($post_obj,$evt_list_name)
  if { ![info exists Post::($post_obj,$evt_list_label)] } {
   set Post::($post_obj,$evt_list_label) [list]
  }
  if { ![info exists Post::($post_obj,$evt_blk_list_name)] } {
   set Post::($post_obj,$evt_blk_list_name) [list]
  }
  array set evt_label_arr $Post::($post_obj,$evt_list_label)
  array set evt_blk_arr $Post::($post_obj,$evt_blk_list_name)
  if [string match $sequence_name "tpth_ctrl"] {
   array set evt_ude_arr $Post::($post_obj,$evt_ude_list_name)
  }
  set arr_sz [array size evt_name_arr]
  set cycle_com_evt [lindex $Post::($post_obj,cyl_com_evt) 0]
  set cycle_shared_evts [lindex $Post::($post_obj,cyl_evt_sh_com_evt) 0]
  for {set sz 0} {$sz < $arr_sz} {incr sz}\
  {
   set evt_blk_list $evt_blk_arr($sz)
   if { [lsearch $cycle_shared_evts $evt_name_arr($sz)] != -1 } \
   {
    PB_evt_RetCycleEventElements evt_blk_list post_obj evt_name_arr($sz) \
    evt_list_name evt_blk_list_name
   } else \
   {
    PB_evt_RetEventElements evt_blk_list post_obj evt_name_arr($sz) \
    sequence_name
   }
   set evt_obj_attr(0) $evt_name_arr($sz)
   set evt_obj_attr(1) [llength $evt_blk_list]
   set evt_obj_attr(2) $evt_blk_list
   if {[string compare $sequence_name "tpth_ctrl"] == 0 || \
    [string compare $sequence_name "tpth_mot"] == 0 || \
    [string compare $sequence_name "tpth_cycle"] == 0 || \
   [string compare $sequence_name "tpth_misc"] == 0 } \
   {
    PB_evt_RetUIItemObjList item_obj_list evt_name_arr($sz) post_obj
   } else \
   {
    set item_obj_list ""
   }
   set evt_obj_attr(3) $item_obj_list
   set evt_obj_attr(4) $evt_label_arr($sz)
   if [string match $sequence_name "tpth_ctrl"] {
    set evt_obj_attr(5) $evt_ude_arr($sz)
   }
   PB_evt_RetUdeEvtObj post_obj ude_evt_obj_list
   PB_evt_CreateEvtObj evt_obj_attr evt_obj_list
   set event_obj [lindex $evt_obj_list $sz]
   foreach row_elem $evt_blk_list \
   {
    foreach evt_elem $row_elem \
    {
     set event_element::($evt_elem,event_obj) $event_obj
    }
   }
   PB_evt_SetCanvasFlag event_obj
  }
 }

#=======================================================================
proc PB_evt_SetCanvasFlag { EVENT_OBJ } {
  upvar $EVENT_OBJ event_obj
  global gPB
  if { [lsearch $gPB(no_output_events_list) "$event::($event_obj,event_name)"] != -1 } {
   set event::($event_obj,canvas_flag) 0
  }
 }

#=======================================================================
proc PB_evt_RetNcOutputAttr { EVT_ELEM_LIST EVT_NC_OUTPUT EVT_NC_WIDTH \
  EVT_NC_HEIGHT } {
  upvar $EVT_ELEM_LIST evt_elem_list
  upvar $EVT_NC_OUTPUT evt_nc_output
  upvar $EVT_NC_WIDTH evt_nc_width
  upvar $EVT_NC_HEIGHT evt_nc_height
  set evt_nc_width 0
  set evt_nc_height 0
  foreach row_elem_list $evt_elem_list \
  {
   set blk_nc_width 0
   set evt_nc_height [expr $evt_nc_height + \
   [font metrics {Helvetica 10} -linespace]]
   foreach elem_obj $row_elem_list \
   {
    set block_obj $event_element::($elem_obj,block_obj)
    foreach blk_elem_obj $block::($block_obj,elem_addr_list) \
    {
     lappend row_blk_elem_list $blk_elem_obj
    }
   }
   UI_PB_com_ApplyMastSeqBlockElem row_blk_elem_list
   PB_com_CreateBlkNcCode row_blk_elem_list blk_nc_output
   unset row_blk_elem_list
   set blk_nc_width [expr $blk_nc_width + \
   [font measure {Helvetica 10} $blk_nc_output)]]
   append evt_nc_output $blk_nc_output "\n"
   unset blk_nc_output
   if {$blk_nc_width > $evt_nc_width} \
   {
    set evt_nc_width $blk_nc_width
   }
  }
 }

#=======================================================================
proc PB_evt_CreateEvtObj {OBJ_ATTR OBJ_LIST} {
  upvar $OBJ_ATTR obj_attr
  upvar $OBJ_LIST obj_list
  set object [new event]
  lappend obj_list $object
  event::setvalue $object obj_attr
  event::DefaultValue $object obj_attr
  if [info exists obj_attr(5)] {
   set event::($object,event_ude_name) $obj_attr(5)
  }
  UI_PB_debug_DisplayMsg "EVENT Object is created : $object"
 }

#=======================================================================
proc PB_evt_RetUdeEvtObj {POST_OBJ UDE_EVT_OBJ_LIST} {
  upvar $POST_OBJ post_obj
  upvar $UDE_EVT_OBJ_LIST ude_evt_obj_list
 }

#=======================================================================
proc PB_evt_RetUIItemObjList {ITEM_OBJ_LIST EVENT_NAME POST_OBJ} {
  upvar $ITEM_OBJ_LIST item_obj_list
  upvar $EVENT_NAME event_name
  upvar $POST_OBJ post_obj
  array set ui_evt_name_arr $Post::($post_obj,ui_evt_name_lis)
  array set ui_evt_itm_grp_mem_arr $Post::($post_obj,ui_evt_itm_grp_mem_lis)
  for { set ix 0 } { $ix < [array size ui_evt_name_arr] } { incr ix } \
  {
   if { [string compare $ui_evt_name_arr($ix) $event_name] == 0 }\
   {
    if [info exists ui_evt_itm_grp_mem_arr($ix)] {
     PB_evt_CreateEvtUIItemGrpMemObj item_obj_list ui_evt_itm_grp_mem_arr($ix)
     } else {
     set item_obj_list ""
    }
    break
   } else\
   {
    set item_obj_list ""
   }
  }
 }

#=======================================================================
proc PB_evt_CreateEvtUIItemGrpMemObj {ITEM_OBJ_LIST UI_EVT_ITM_GRP_MEM_ATTR} {
  upvar $ITEM_OBJ_LIST item_obj_list
  upvar $UI_EVT_ITM_GRP_MEM_ATTR ui_evt_itm_grp_mem_attr
  foreach item $ui_evt_itm_grp_mem_attr\
  {
   set item_attr_list [lindex $item 0]
   set item_grp_list [lrange $item 1 end]
   set grp_obj_list ""
   set itm_ind 0
   foreach group $item_grp_list\
   {
    set grp_attr_list [lindex $group  0]
    set grp_mem_list [lrange $group 1 end]
    set mem_obj_list ""
    set grp_ind 0
    foreach member $grp_mem_list\
    {
     set mem_attr_list $member
     set mem_ind 0
     foreach mem_attr $mem_attr_list\
     {
      set mem_obj_attr($mem_ind) $mem_attr
      incr mem_ind
     }
     PB_evt_CreateUIMember mem_obj_attr mem_obj_list
     unset mem_obj_attr
    }
    foreach grp_attr $grp_attr_list\
    {
     set grp_obj_attr($grp_ind) $grp_attr
     incr grp_ind
    }
    set grp_obj_attr($grp_ind) $mem_obj_list
    PB_evt_CreateUIGroup grp_obj_attr grp_obj_list
   }
   foreach item_attr $item_attr_list\
   {
    set item_obj_attr($itm_ind) $item_attr
    incr itm_ind
   }
   set item_obj_attr($itm_ind) $grp_obj_list
   PB_evt_CreateUIItem item_obj_attr item_obj_list
  }
 }

#=======================================================================
proc PB_evt_CreateUIItem {OBJ_ATTR OBJ_LIST} {
  upvar $OBJ_ATTR obj_attr
  upvar $OBJ_LIST obj_list
  set object [new item]
  lappend obj_list $object
  item::setvalue $object obj_attr
  item::DefaultValue $object obj_attr
  UI_PB_debug_DisplayMsg "ITEM Object is created : $object"
 }

#=======================================================================
proc PB_evt_CreateUIGroup {OBJ_ATTR OBJ_LIST} {
  upvar $OBJ_ATTR obj_attr
  upvar $OBJ_LIST obj_list
  set object [new item_group]
  lappend obj_list $object
  item_group::setvalue $object obj_attr
  item_group::DefaultValue $object obj_attr
  UI_PB_debug_DisplayMsg "GROUP Object is created : $object"
 }

#=======================================================================
proc PB_evt_CreateUIMember {OBJ_ATTR OBJ_LIST} {
  upvar $OBJ_ATTR obj_attr
  upvar $OBJ_LIST obj_list
  set object [new group_member]
  lappend obj_list $object
  group_member::setvalue $object obj_attr
  group_member::DefaultValue $object obj_attr
  UI_PB_debug_DisplayMsg "GROUP MEMBER Object is created : $object"
 }

#=======================================================================
proc PB_evt_CreateEventElement { EVT_ELEM_OBJ EVT_ELEM_OBJ_ATTR } {
  upvar $EVT_ELEM_OBJ evt_elem_obj
  upvar $EVT_ELEM_OBJ_ATTR evt_elem_obj_attr
  set evt_elem_obj [new event_element]
  event_element::setvalue $evt_elem_obj evt_elem_obj_attr
  event_element::DefaultValue $evt_elem_obj evt_elem_obj_attr
  block::AddToEventElemList $evt_elem_obj_attr(1) evt_elem_obj
  block::AddToEventElemList $evt_elem_obj_attr(1) evt_elem_obj
 }

#=======================================================================
proc PB_evt_CheckCycleRefWord { BLOCK_OBJ check_flag args } {
  upvar $BLOCK_OBJ block_obj
  global mom_sys_arr ;#<06-08-09 wbh>
  if { [llength $args] == 0 } \
  {
   if { [info exists mom_sys_arr(Disable_Ref_Word)] && $mom_sys_arr(Disable_Ref_Word) } {
    return 0
   }
  }
  if { ![info exists block::($block_obj,blk_owner)] } {
   return 0
  }
  if { $check_flag == 1 } \
  {
   if { [string compare $block::($block_obj,blk_owner) "post"] == 0 } \
   {
    return 0
   }
  } else \
  {
   if { $mom_sys_arr(\$cycle_start_blk) == 0 } \
   {
    return 0
   }
  }
  foreach blk_elem_obj $block::($block_obj,elem_addr_list) \
  {
   if { $block_element::($blk_elem_obj,owner) == "post" || \
    $block_element::($blk_elem_obj,owner) == "Cycle Parameters" || \
   $block_element::($blk_elem_obj,owner) == "" } \
   {
    set blk_elem_mom_var $block_element::($blk_elem_obj,elem_mom_variable)
    if { $check_flag == 1} \
    {
     if { [string match "\$mom_sys_cycle_reps_code" $blk_elem_mom_var] || \
      [string match "\$mom_sys_cycle_bore*"     $blk_elem_mom_var] || \
      [string match "\$mom_sys_cycle_drill*"    $blk_elem_mom_var] || \
     [string match "\$mom_sys_cycle_tap*"      $blk_elem_mom_var] } \
     {
      return 1
     }
     if { [PB_com_IsSiemensController $::gPB(post_controller_type) 1] || \
     [PB_com_IsHeidenhainController $::gPB(post_controller_type)] } \
     {
      if { [llength $args] && \
      [string match "just_mcall_sinumerik" $block::($block_obj,block_name)] } \
      {
       return 1
      }
     }
     } else {
     if [string match "\$mom_sys_cycle_start_code" $blk_elem_mom_var] \
     {
      return 1
     }
     if { [llength $args] } \
     {
      if { [PB_com_IsSiemensController $::gPB(post_controller_type) 1] || \
      [PB_com_IsHeidenhainController $::gPB(post_controller_type)] } \
      {
       if { [string match "just_mcall_sinumerik" $block::($block_obj,block_name)] || \
       [string match "post_startblk" $block::($block_obj,block_name)] } \
       {
        return 1
       }
       if { [info exists mom_sys_arr(post_startblk)] && \
       [string match $mom_sys_arr(post_startblk) $block::($block_obj,block_name)] } \
       {
        return 1
       }
      }
     } ;# end if [length $args]
    }
   }
  }
  return 0
  if 0 {
   if { $check_flag == 1} \
   {
    if {[string compare $block::($block_obj,blk_owner) "post"] == 0} \
    {
     return 0
    }
    set ref_var "\$mom_sys_cycle*"
   } else \
   {
    set ref_var "\$mom_sys_cycle_start*"
   }
   foreach blk_elem_obj $block::($block_obj,elem_addr_list) \
   {
    if { $block_element::($blk_elem_obj,owner) == "post" || \
     $block_element::($blk_elem_obj,owner) == "Cycle Parameters" || \
     $block_element::($blk_elem_obj,owner) == "" } {
     set blk_elem_mom_var $block_element::($blk_elem_obj,elem_mom_variable)
     if [string match $ref_var $blk_elem_mom_var] \
     {
      return 1
     }
    }
   }
   return 0
  }
 }

#=======================================================================
proc PB_evt_RetCycleEventElements { EVT_BLK_LIST POST_OBJ EVENT_NAME \
  EVT_LIST_NAME EVT_BLK_LIST_NAME } {
  upvar $EVT_BLK_LIST evt_blk_list
  upvar $POST_OBJ post_obj
  upvar $EVENT_NAME event_name
  upvar $EVT_LIST_NAME evt_list_name
  upvar $EVT_BLK_LIST_NAME evt_blk_list_name
  global mom_sys_arr ;#<06-08-09 wbh>
  UI_PB_debug_ForceMsg " +++++ 0 Event name: $event_name"
  set blk_obj_list $Post::($post_obj,blk_obj_list)
  set cmd_blk_list $Post::($post_obj,cmd_blk_list)
  set comment_blk_list $Post::($post_obj,comment_blk_list)
  array set word_mom_var_list $Post::($post_obj,word_mom_var)
  set command_list $word_mom_var_list(Command)
  set comment_list $word_mom_var_list(Operator_Message)
  set function_blk_list $Post::($post_obj,function_blk_list)
  PB_int_RetFunctionNames function_list
  set old_version_flag [PB_is_old_v 8.0.0]
  set func_suppress_flag 0
  set anc_blk_name [join [split [string tolower $event_name]] "_"]
  set anc_blk_name cycle_$anc_blk_name
  set anc_blk_found 0
  foreach blk_name $evt_blk_list \
  {
   set blk_obj 0
   PB_com_RetObjFrmName blk_name blk_obj_list blk_obj
   if { $blk_obj == 0 } { continue }
   set null_owner 0
   if { ![UI_PB_tpth_IsCycleCustom $event_name] && \
   [string match "$anc_blk_name" $blk_name] } \
   {
    set null_owner 1
    } elseif { [string match "post*" $blk_name] } \
   {
    set null_owner 1
   }
   if $null_owner \
   {
    set anc_blk_found 1
    foreach blk_elem $block::($blk_obj,elem_addr_list) \
    {
     set block_element::($blk_elem,owner) ""
    }
   }
  }
  if { !$anc_blk_found && \
  ![UI_PB_tpth_IsCycleCustom $event_name] } \
  {
   foreach blk_name $evt_blk_list \
   {
    set blk_obj 0
    PB_com_RetObjFrmName blk_name blk_obj_list blk_obj
    if { $blk_obj == 0 } { continue }
    foreach blk_elem $block::($blk_obj,elem_addr_list) \
    {
     set blk_elem_mom_var $block_element::($blk_elem,elem_mom_variable)
     if { [string match "\$mom_sys_cycle*" $blk_elem_mom_var] } \
     {
      set block_element::($blk_elem,owner) ""
     }
    }
   }
  }
  set com_blank_flag 0
  set temp_com_evt [lindex $Post::($post_obj,cyl_com_evt) 0]
  set temp_evt_name_arr_list $Post::($post_obj,$evt_list_name)
  array set temp_evt_blk_arr $Post::($post_obj,$evt_blk_list_name)
  set temp_com_evt_indx [lsearch $temp_evt_name_arr_list $temp_com_evt]
  set temp_com_evt_indx [lindex $temp_evt_name_arr_list [expr $temp_com_evt_indx - 1]]
  if { [llength $temp_evt_blk_arr($temp_com_evt_indx)] == 0 } \
  {
   set com_blank_flag 1
  }
  if { $com_blank_flag || [UI_PB_tpth_IsCycleCustom $event_name] } {
   set elem_index 0
   foreach blk_name $evt_blk_list \
   {
    PB_evt_ReparserBlockName blk_name
    set blk_obj 0
    if { [lsearch $comment_list $blk_name] != -1 } \
    {
     PB_com_RetObjFrmName blk_name comment_blk_list blk_obj
     } elseif { [lsearch $command_list $blk_name] != -1 } \
    {
     set cmd_obj 0
     PB_com_RetObjFrmName blk_name cmd_blk_list cmd_obj
     PB_blk_CreateCmdBlkElem blk_name cmd_obj cmd_blk_elem
     PB_blk_CreateCmdBlkObj blk_name cmd_blk_elem blk_obj
     } elseif { [lsearch $function_list $blk_name] != -1 } \
    {
     set func_obj 0
     PB_com_RetObjFrmName blk_name function_blk_list func_obj
     PB_blk_CreateFuncBlkElem blk_name func_obj func_blk_elem
     PB_blk_CreateFuncBlkObj blk_name func_blk_elem blk_obj
     global g_func_prefix g_func_suppress_flag
     set block_element::($func_blk_elem,func_prefix) $g_func_prefix
     set block_element::($func_blk_elem,func_suppress_flag) $g_func_suppress_flag
     if { !$old_version_flag } \
     {
      set func_suppress_flag $g_func_suppress_flag
     }
    } else \
    {
     PB_com_RetObjFrmName blk_name blk_obj_list blk_obj
    }
    if { $blk_obj == 0 } {
     incr elem_index
     continue
    }
    PB_evt_SetOwnerShipForBlkElem blk_obj event_name
    set evt_obj_attr(0) $blk_name
    set evt_obj_attr(1) $blk_obj
    UI_PB_debug_ForceMsg " +++++ 1 Event name: $event_name"
    PB_evt_SetEvtElemExecutionAttr event_name evt_obj_attr $elem_index
    if { $func_suppress_flag } \
    {
     set evt_obj_attr(3) 1
     set func_suppress_flag 0
    }
    incr elem_index
    PB_evt_CreateEventElement evt_elem_obj evt_obj_attr
    lappend evt_elem_obj_list $evt_elem_obj
    unset evt_obj_attr
   }
   if [info exists evt_elem_obj_list] \
   {
    set evt_blk_list $evt_elem_obj_list
   } else \
   {
    set evt_blk_list ""
   }
   UI_PB_debug_ForceMsg " +++++ 1.1 Custom cycle : $event_name  com_blank_flag : $com_blank_flag"
   return
  }
  set cycle_com_evt [lindex $Post::($post_obj,cyl_com_evt) 0]
  set evt_name_arr_list $Post::($post_obj,$evt_list_name)
  array set evt_blk_arr $Post::($post_obj,$evt_blk_list_name)
  set com_evt_indx [lsearch $evt_name_arr_list $cycle_com_evt]
  set com_evt_indx [lindex $evt_name_arr_list [expr $com_evt_indx - 1]]
  set com_evt_blk_list $evt_blk_arr($com_evt_indx)
  set added_own_blks_flag 0
  set elem_index 0
  foreach com_blk $com_evt_blk_list \
  {
   PB_evt_ReparserBlockName com_blk
   set com_blk_obj 0
   if { [lsearch $comment_list $com_blk] != -1 } \
   {
    PB_com_RetObjFrmName com_blk comment_blk_list com_blk_obj
    } elseif { [lsearch $command_list $com_blk] != -1 } \
   {
    set cmd_obj 0
    PB_com_RetObjFrmName com_blk cmd_blk_list cmd_obj
    PB_blk_CreateCmdBlkElem com_blk cmd_obj cmd_blk_elem
    PB_blk_CreateCmdBlkObj com_blk cmd_blk_elem com_blk_obj
    if { [info exists mom_sys_arr(post_startblk)] && \
    [string match $mom_sys_arr(post_startblk) $block::($com_blk_obj,block_name)] } \
    {
     set block::($com_blk_obj,blk_owner)      "post" ;#<07-28-09 wbh> "post" was "Cycle Parameters"
     set block_element::($cmd_blk_elem,owner) "post"
    } else \
    {
     set block_element::($cmd_blk_elem,owner) "Cycle Parameters"
    }
    } elseif { [lsearch $function_list $com_blk] != -1 } \
   {
    set func_obj 0
    PB_com_RetObjFrmName com_blk function_blk_list func_obj
    PB_blk_CreateFuncBlkElem com_blk func_obj func_blk_elem
    PB_blk_CreateFuncBlkObj com_blk func_blk_elem com_blk_obj
    if [string match "just_mcall_sinumerik" $block::($com_blk_obj,block_name)] \
    {
     set block::($com_blk_obj,blk_owner) "Cycle Parameters"
     set block_element::($func_blk_elem,owner) "post"
    }
    global g_func_prefix g_func_suppress_flag
    set block_element::($func_blk_elem,func_prefix) $g_func_prefix
    set block_element::($func_blk_elem,func_suppress_flag) $g_func_suppress_flag
    if { !$old_version_flag } \
    {
     set func_suppress_flag $g_func_suppress_flag
    }
    } elseif { [string match "post_*" $com_blk] } \
   {
    set post_blk_list $Post::($post_obj,post_blk_list)
    PB_com_RetObjFrmName com_blk post_blk_list com_blk_obj
   } else \
   {
    PB_com_RetObjFrmName com_blk blk_obj_list com_blk_obj
   }
   if { !$com_blk_obj } {
    incr elem_index
    continue
   }
   block::readvalue $com_blk_obj com_blk_obj_attr
   set com_ret [PB_evt_CheckCycleRefWord com_blk_obj 1 MCALL]
   if { $com_ret == 0 } \
   {
    set evt_obj_attr(0) $com_blk
    set evt_obj_attr(1) $com_blk_obj
    UI_PB_debug_ForceMsg " +++++ 2 Event name: $event_name"
    PB_evt_SetEvtElemExecutionAttr cycle_com_evt evt_obj_attr $elem_index
    if { $func_suppress_flag } \
    {
     set evt_obj_attr(3) 1
     set func_suppress_flag 0
    }
    PB_evt_CreateEventElement evt_elem_obj evt_obj_attr
    lappend evt_elem_obj_list $evt_elem_obj
    unset evt_obj_attr
   } else \
   {
    set cycle_own_index -1
    foreach blk_name $evt_blk_list \
    {
     incr cycle_own_index
     PB_evt_ReparserBlockName blk_name
     set blk_obj 0
     if { [lsearch $comment_list $blk_name] != -1 } \
     {
      PB_com_RetObjFrmName blk_name comment_blk_list blk_obj
      } elseif { [lsearch $command_list $blk_name] != -1 } \
     {
      set cmd_obj 0
      PB_com_RetObjFrmName blk_name cmd_blk_list cmd_obj
      PB_blk_CreateCmdBlkElem blk_name cmd_obj cmd_blk_elem
      PB_blk_CreateCmdBlkObj blk_name cmd_blk_elem blk_obj
      } elseif { [lsearch $function_list $blk_name] != -1 } \
     {
      set func_obj 0
      PB_com_RetObjFrmName blk_name function_blk_list func_obj
      PB_blk_CreateFuncBlkElem blk_name func_obj func_blk_elem
      PB_blk_CreateFuncBlkObj blk_name func_blk_elem blk_obj
      global g_func_prefix g_func_suppress_flag
      set block_element::($func_blk_elem,func_prefix) $g_func_prefix
      set block_element::($func_blk_elem,func_suppress_flag) $g_func_suppress_flag
      if { !$old_version_flag } \
      {
       set func_suppress_flag $g_func_suppress_flag
      }
     } else \
     {
      PB_com_RetObjFrmName blk_name blk_obj_list blk_obj
     }
     if { $blk_obj == 0 } { continue }
     set ret_val [PB_evt_CheckCycleRefWord blk_obj 1]
     if { $ret_val } \
     {
      set ref_blk_elem_list ""
      foreach blk_elem $block::($blk_obj,elem_addr_list) \
      {
       set blk_add_obj $block_element::($blk_elem,elem_add_obj)
       set blk_mom_var $block_element::($blk_elem,elem_mom_variable)
       set blk_add_name $address::($blk_add_obj,add_name)
       if { $blk_add_name == "G_motion" } \
       {
        lappend ref_blk_elem_list $blk_elem
        set block_element::($blk_elem,owner) "post"
        if 0 {
         if [string match $blk_name "post_cycle_set"] {
          set block_element::($blk_elem,owner) "Cycle Parameters"
          } else {
          set block_element::($blk_elem,owner) "post"
         }
        }
        continue
       } else \
       {
        set elem_found_flag 0
        foreach com_blk_elem $block::($com_blk_obj,elem_addr_list) \
        {
         set com_add_obj $block_element::($com_blk_elem,elem_add_obj)
         set com_mom_var $block_element::($com_blk_elem,elem_mom_variable)
         set com_add_name $address::($com_add_obj,add_name)
         if { $blk_add_name == "$com_add_name" && \
         $blk_mom_var == "$com_mom_var" } \
         {
          set elem_found_flag 1
          break
         }
        }
        if { $elem_found_flag } \
        {
         lappend ref_blk_elem_list $com_blk_elem
        } else \
        {
         lappend ref_blk_elem_list $blk_elem
         set block_element::($blk_elem,owner) $event_name
        }
       }
      }
      set block::($blk_obj,elem_addr_list) $ref_blk_elem_list
      set block::($blk_obj,blk_owner) "$event_name"
      block::readvalue $blk_obj blk_obj_attr
      block::DefaultValue $blk_obj blk_obj_attr
      unset blk_obj_attr
     } else \
     {
      PB_evt_SetOwnerShipForBlkElem blk_obj event_name
     }
     set evt_obj_attr(0) $blk_name
     set evt_obj_attr(1) $blk_obj
     if { $ret_val } \
     {
      set temp_evt_name $cycle_com_evt
      set temp_elem_index $elem_index
     } else \
     {
      set temp_evt_name $event_name
      if 0 {
       set vlist [split $::gPB(Postbuilder_PUI_Version) "."]
       set v0 [lindex $vlist 0]
       set v1 [lindex $vlist 1]
       set v2 [lindex $vlist 2]
       set v3 [lindex $vlist 3]
       set __old_pui 1
       if { $v0 > 2008 } {
        set __old_pui 0
        } elseif { $v0 == 2008 } {
        if { $v1 > 0 } {
         set __old_pui 0
         } elseif { $v1 == 0 } {
         if { $v2 > 4 } {
          set __old_pui 0
          } elseif { $v2 == 4 } {
          if { $v3 > 0 } {
           set __old_pui 0
          }
         }
        }
       }
      }
      if 0 {
       set __old_pui 0
       set ver_check 1
       if { [PB_pui_CompareVersion $::gPB(this_PUI_version) "2007.0.3.1"] >= 0 } {
        set ver_check [PB_pui_CompareVersion $::gPB(this_PUI_version) $::gPB(Postbuilder_PUI_Version)]
       }
       if { $ver_check < 0 } { set __old_pui 1 }
       UI_PB_debug_ForceMsg " +++++ Event name: $event_name  __old_pui : $__old_pui  ver_check : $ver_check"
       if { $__old_pui } {
        set temp_elem_index $cycle_own_index
        } else {
        set temp_elem_index [expr $cycle_own_index + $elem_index]
       }
       } else {
       set temp_elem_index [expr $cycle_own_index + $elem_index]
      }
     }
     UI_PB_debug_ForceMsg "\n +++++ 3 Event name:  $event_name -> $temp_evt_name | $temp_elem_index -> $elem_index \n"
     PB_evt_SetEvtElemExecutionAttr temp_evt_name evt_obj_attr $temp_elem_index
     UI_PB_debug_ForceMsg "\n +++++ temp_evt_name $temp_evt_name: [array get evt_obj_attr]\n"
     if { $ret_val } { ;# Merge attrs for an inherited cycle block
      set addr_objs ""
      foreach blk_elem $block::($com_blk_obj,elem_addr_list) {
       lappend addr_objs $block_element::($blk_elem,elem_add_obj)
      }
      set force_attrs $evt_obj_attr(4)
      PB_evt_SetEvtElemExecutionAttr event_name evt_obj_attr $temp_elem_index
      UI_PB_debug_ForceMsg "\n +++++ event_name $event_name: [array get evt_obj_attr]\n"
      set idx 0
      foreach addr $evt_obj_attr(4) {
       if { [lsearch $addr_objs $addr] >= 0 } {
        set evt_obj_attr(4) [lreplace $evt_obj_attr(4) $idx $idx]
        } else {
        incr idx
       }
      }
      set evt_obj_attr(4) [lmerge $force_attrs $evt_obj_attr(4)]
      UI_PB_debug_ForceMsg "\n +++++ event_name $event_name: merged = [array get evt_obj_attr]\n"
     }
     if { $func_suppress_flag } \
     {
      set evt_obj_attr(3) 1
      set func_suppress_flag 0
     }
     PB_evt_CreateEventElement evt_elem_obj evt_obj_attr
     lappend evt_elem_obj_list $evt_elem_obj
     unset evt_obj_attr
     set added_own_blks_flag 1
    }
   } ;# Anchor block
   unset com_blk_obj_attr
   incr elem_index
  }
  if { $added_own_blks_flag == 0 } \
  {
   set elem_index 0
   foreach blk_name $evt_blk_list \
   {
    PB_evt_ReparserBlockName blk_name
    set blk_obj 0
    if { [lsearch $comment_list $blk_name] != -1 } \
    {
     PB_com_RetObjFrmName blk_name comment_blk_list blk_obj
     } elseif { [lsearch $command_list $blk_name] != -1 } \
    {
     set cmd_obj 0
     PB_com_RetObjFrmName blk_name cmd_blk_list cmd_obj
     PB_blk_CreateCmdBlkElem blk_name cmd_obj cmd_blk_elem
     PB_blk_CreateCmdBlkObj blk_name cmd_blk_elem blk_obj
     } elseif { [lsearch $function_list $blk_name] != -1 } \
    {
     set func_obj 0
     PB_com_RetObjFrmName blk_name function_blk_list func_obj
     PB_blk_CreateFuncBlkElem blk_name func_obj func_blk_elem
     PB_blk_CreateFuncBlkObj blk_name func_blk_elem blk_obj
     global g_func_prefix g_func_suppress_flag
     set block_element::($func_blk_elem,func_prefix) $g_func_prefix
     set block_element::($func_blk_elem,func_suppress_flag) $g_func_suppress_flag
     if { !$old_version_flag } \
     {
      set func_suppress_flag $g_func_suppress_flag
     }
    } else \
    {
     PB_com_RetObjFrmName blk_name blk_obj_list blk_obj
    }
    if { $blk_obj == 0 } {
     incr elem_index
     continue
    }
    PB_evt_SetOwnerShipForBlkElem blk_obj event_name
    set evt_obj_attr(0) $blk_name
    set evt_obj_attr(1) $blk_obj
    UI_PB_debug_ForceMsg " +++++ 4 Event name: $event_name"
    PB_evt_SetEvtElemExecutionAttr event_name evt_obj_attr $elem_index
    if { $func_suppress_flag } \
    {
     set evt_obj_attr(3) 1
     set func_suppress_flag 0
    }
    PB_evt_CreateEventElement evt_elem_obj evt_obj_attr
    lappend evt_elem_obj_list $evt_elem_obj
    unset evt_obj_attr
    incr elem_index
   }
  }
  if [info exists evt_elem_obj_list] \
  {
   set evt_blk_list $evt_elem_obj_list
  } else \
  {
   set evt_blk_list ""
  }
 }

#=======================================================================
proc PB_evt_RetEventElements { EVT_BLK_LIST POST_OBJ EVENT_NAME SEQUENCE_NAME } {
  upvar $EVT_BLK_LIST evt_blk_list
  upvar $POST_OBJ post_obj
  upvar $EVENT_NAME event_name
  upvar $SEQUENCE_NAME sequence_name
  Post::GetObjList $post_obj block blk_obj_list
  set cmd_blk_list $Post::($post_obj,cmd_blk_list)
  set comment_blk_list $Post::($post_obj,comment_blk_list)
  array set word_mom_var_list $Post::($post_obj,word_mom_var)
  set command_list $word_mom_var_list(Command)
  set comment_list $word_mom_var_list(Operator_Message)
  set func_blk_list $Post::($post_obj,function_blk_list)
  PB_int_RetFunctionNames function_list
  if { ![info exists Post::($post_obj,vnc_blk_list)] } {
   set Post::($post_obj,vnc_blk_list) [list]
  }
  set vnc_blk_list $Post::($post_obj,vnc_blk_list)
  if { ![info exists word_mom_var_list(VNC_Instruction)] } {
   set word_mom_var_list(VNC_Instruction) [list]
  }
  set vnc_list $word_mom_var_list(VNC_Instruction)
  array set mom_sys_var $Post::($post_obj,mom_sys_var_list)
  set elem_index 0
  set old_version_flag [PB_is_old_v 8.0.0]
  set func_suppress_flag 0
  foreach blk_row $evt_blk_list \
  {
   foreach row_elem $blk_row \
   {
    UI_PB_debug_ForceMsg "Block Name >$row_elem<"
    set blk_obj 0
    PB_com_RetObjFrmName row_elem blk_obj_list blk_obj
    if 0 { ;# Doesn't seem to work
     if { [string match "ELSE" $row_elem] ||\
      [string match "END"  $row_elem] } {
      PB_blk_CreateCmdBlkElem row_elem cmd_obj cmd_blk_elem
      PB_blk_CreateCmdBlkObj  row_elem cmd_blk_elem blk_obj
     }
    }
    if { $blk_obj == 0 && [lsearch $comment_list $row_elem] != -1 } \
    {
     PB_com_RetObjFrmName row_elem comment_blk_list blk_obj
     } elseif { $blk_obj == 0 && [lsearch $command_list $row_elem] != -1 } \
    {
     set cmd_obj 0
     PB_com_RetObjFrmName row_elem cmd_blk_list cmd_obj
     PB_blk_CreateCmdBlkElem row_elem cmd_obj cmd_blk_elem
     PB_blk_CreateCmdBlkObj row_elem cmd_blk_elem blk_obj
     } elseif { $blk_obj == 0 && [lsearch $function_list $row_elem] != -1 } \
    {
     UI_PB_debug_ForceMsg "Function Macro >$row_elem<"
     set func_break_flag 1
     set func_obj 0
     PB_com_RetObjFrmName row_elem func_blk_list func_obj
     PB_blk_CreateFuncBlkElem row_elem func_obj func_blk_elem
     PB_blk_CreateFuncBlkObj row_elem func_blk_elem blk_obj
     set temp_index [lsearch $blk_row $row_elem]
     if { [llength $blk_row] > [expr $temp_index + 2] } \
     {
      set block_element::($func_blk_elem,func_prefix) \
      [lindex $blk_row [expr $temp_index + 1]]
      set block_element::($func_blk_elem,func_suppress_flag) \
      [lindex $blk_row [expr $temp_index + 2]]
      if { !$old_version_flag } \
      {
       set func_suppress_flag $block_element::($func_blk_elem,func_suppress_flag)
      }
     }
     } elseif { $blk_obj == 0 && [lsearch $vnc_list $row_elem] != -1 } \
    {
     set cmd_obj 0
     __seq_CreateVNCBlkElem  row_elem cmd_obj blk_elem
     set block_element::($blk_elem,force) $mom_sys_var($row_elem)
     __seq_CreateVNCBlk      row_elem blk_elem blk_obj
     UI_PB_debug_ForceMsg "$row_elem  >$mom_sys_var($row_elem)< >$blk_obj<"
    }
    if { $blk_obj == 0 } \
    {
     UI_PB_debug_ForceMsg "+++ $row_elem  NOT FOUND +++"
     continue
    }
    if { [string compare $sequence_name "tpth_ctrl"]  == 0 || \
     [string compare $sequence_name "tpth_mot"]   == 0 || \
     [string compare $sequence_name "tpth_cycle"] == 0 || \
    [string compare $sequence_name "tpth_misc"]  == 0 } \
    {
     PB_evt_SetOwnerShipForBlkElem blk_obj event_name
    }
    set evt_elem_obj_attr(0) $row_elem
    set evt_elem_obj_attr(1) $blk_obj
    UI_PB_debug_ForceMsg " +++++ 5 Event name: $event_name"
    PB_evt_SetEvtElemExecutionAttr event_name evt_elem_obj_attr $elem_index
    incr elem_index
    if { $func_suppress_flag } \
    {
     set evt_elem_obj_attr(3) 1
     set func_suppress_flag 0
    }
    PB_evt_CreateEventElement evt_elem_obj evt_elem_obj_attr
    unset evt_elem_obj_attr
    lappend row_elem_list $evt_elem_obj
    if { [info exists func_break_flag] && $func_break_flag } \
    {
     set func_break_flag 0
     unset func_break_flag
     break
    }
   }
   if { [info exists row_elem_list] }\
   {
    lappend row_list $row_elem_list
    unset row_elem_list
   }
  }
  if { [info exists row_list] } \
  {
   set evt_blk_list $row_list
   unset row_list
  } else\
  {
   set evt_blk_list ""
  }
  if { [string compare $event_name "Cycle Parameters"] == 0 } \
  {
   foreach blk_row $evt_blk_list\
   {
    foreach row_elem $blk_row\
    {
     set block_obj $event_element::($row_elem,block_obj)
     set block_name $block::($block_obj,block_name)
     PB_evt_ChangeBlkToPostBlk post_obj event_name block_obj
    }
   }
   PB_evt_StorePostBlocks evt_blk_list post_obj
   } elseif { [string compare $event_name "Rapid Move"] == 0 } \
  {
   __evt_RapidWrkPlaneChange evt_blk_list post_obj
   set elem_index 0
   foreach blk_row $evt_blk_list\
   {
    foreach row_elem $blk_row\
    {
     set blk_obj $event_element::($row_elem,block_obj)
     set evt_elem_obj_attr(0) $row_elem
     set evt_elem_obj_attr(1) $blk_obj
     UI_PB_debug_ForceMsg " +++++ 6 Event name: $event_name"
     PB_evt_SetEvtElemExecutionAttr event_name evt_elem_obj_attr $elem_index
     event_element::setvalue $row_elem evt_elem_obj_attr
     event_element::DefaultValue $row_elem evt_elem_obj_attr
    }
    incr elem_index
   }
  }
 }

#=======================================================================
proc PB_evt_ChangeBlkElemOwner { POST_OBJ EVENT_NAME BLOCK_OBJ } {
  upvar $POST_OBJ post_obj
  upvar $EVENT_NAME event_name
  upvar $BLOCK_OBJ block_obj
  set blk_obj_list $Post::($post_obj,blk_obj_list)
  array set mom_sys_var $Post::($post_obj,mom_sys_var_list)
  foreach blk_elem_obj $block::($block_obj,elem_addr_list) \
  {
   set add_obj $block_element::($blk_elem_obj,elem_add_obj)
   switch $address::($add_obj,add_name) \
   {
    "G_motion" { set block_element::($blk_elem_obj,owner) "post" }
    "G_motion_123" {
     if [string match $event_name "Cycle Parameters"] {
      set block_element::($blk_elem_obj,owner) "Cycle Parameters"
      } else {
      set block_element::($blk_elem_obj,owner) "post"
     }
    }
    "R"       {
     if { $mom_sys_var(\$cycle_rapto_opt) == "Rapid_Traverse_&_R" ||
     $mom_sys_var(\$cycle_rapto_opt) == "R" } \
     {
      set block_element::($blk_elem_obj,owner) "post"
     }
    }
    "K_cycle" {
     if { $mom_sys_var(\$cycle_recto_opt) == "K" } \
     {
      set block_element::($blk_elem_obj,owner) "post"
     }
    }
    "G_plane" {
     if { $mom_sys_var(\$cycle_plane_control_opt) == \
     "G17/G18/G19" } \
     {
      set block_element::($blk_elem_obj,owner) "post"
     }
    }
    "G_return" {
     if { $mom_sys_var(\$cycle_recto_opt) == \
     "G98/G99" } \
     {
      set block_element::($blk_elem_obj,owner) "post"
     }
    }
    default  {
     set block_element::($blk_elem_obj,owner) $event_name
    }
   }
  }
 }

#=======================================================================
proc __evt_AddRapidTravElems { POST_OBJ BLK_OBJ } {
  upvar $POST_OBJ post_obj
  upvar $BLK_OBJ blk_obj
  set rap_add_list $Post::($post_obj,rap_add_list)
  block::readvalue $blk_obj blk_obj_attr
  set new_blk_elem_list ""
  array set mom_sys_var $Post::($post_obj,mom_sys_var_list)
  if { $mom_sys_var(\$rap_wrk_pln_chg) } {
   set add_list {rapid1 rapid2}
   } else {
   set add_list {rapid1 rapid2 rapid3}
  }
  foreach blk_elem_obj $block::($blk_obj,elem_addr_list) \
  {
   set add_obj $block_element::($blk_elem_obj,elem_add_obj)
   switch $address::($add_obj,add_name) \
   {
    "X" {
     set add_name "rapid1"
     PB_com_RetObjFrmName add_name rap_add_list rap_add_obj
     block_element::readvalue $blk_elem_obj blk_elem_attr
     set blk_elem_attr(0) $rap_add_obj
     set blk_elem_attr(3) $address::($rap_add_obj,word_desc)
     PB_blk_CreateBlkElemObj blk_elem_attr new_blk_elem blk_obj_attr
     set block_element::($new_blk_elem,owner) "post"
     lappend new_blk_elem_list $new_blk_elem
     PB_com_DeleteObject $blk_elem_obj
     set idx [lsearch $add_list $add_name]
     if { $idx >= 0 } {
      set add_list [lreplace $add_list $idx $idx]
     }
    }
    "Y" {
     set add_name "rapid2"
     PB_com_RetObjFrmName add_name rap_add_list rap_add_obj
     block_element::readvalue $blk_elem_obj blk_elem_attr
     set blk_elem_attr(0) $rap_add_obj
     set blk_elem_attr(3) $address::($rap_add_obj,word_desc)
     PB_blk_CreateBlkElemObj blk_elem_attr new_blk_elem blk_obj_attr
     set block_element::($new_blk_elem,owner) "post"
     lappend new_blk_elem_list $new_blk_elem
     PB_com_DeleteObject $blk_elem_obj
     set idx [lsearch $add_list $add_name]
     if { $idx >= 0 } {
      set add_list [lreplace $add_list $idx $idx]
     }
    }
    "Z" {
     array set mom_sys_var $Post::($post_obj,mom_sys_var_list)
     if { !$mom_sys_var(\$rap_wrk_pln_chg) } {
      set add_name "rapid3"
      PB_com_RetObjFrmName add_name rap_add_list rap_add_obj
      block_element::readvalue $blk_elem_obj blk_elem_attr
      set blk_elem_attr(0) $rap_add_obj
      set blk_elem_attr(3) $address::($rap_add_obj,word_desc)
      PB_blk_CreateBlkElemObj blk_elem_attr new_blk_elem blk_obj_attr
      set block_element::($new_blk_elem,owner) "post"
      lappend new_blk_elem_list $new_blk_elem
      set idx [lsearch $add_list $add_name]
      if { $idx >= 0 } {
       set add_list [lreplace $add_list $idx $idx]
      }
     }
     PB_com_DeleteObject $blk_elem_obj
    }
    default {
     lappend new_blk_elem_list $blk_elem_obj
    }
   }
  }
  foreach add_name $add_list {
   PB_com_RetObjFrmName add_name rap_add_list rap_add_obj
   set blk_elem_attr(0) $rap_add_obj
   switch $add_name {
    "rapid1" {
     set blk_elem_attr(1) "\$mom_pos(0)"
    }
    "rapid2" {
     set blk_elem_attr(1) "\$mom_pos(1)"
    }
    "rapid3" {
     set blk_elem_attr(1) "\$mom_pos(2)"
    }
   }
   set blk_elem_attr(2) ""
   set blk_elem_attr(3) $address::($rap_add_obj,word_desc)
   set blk_elem_attr(4) 0
   PB_blk_CreateBlkElemObj blk_elem_attr new_blk_elem blk_obj_attr
   set block_element::($new_blk_elem,owner) "post"
   lappend new_blk_elem_list $new_blk_elem
  }
  set blk_obj_attr(1) [llength $new_blk_elem_list]
  set blk_obj_attr(2) $new_blk_elem_list
  set blk_obj_attr(3) "normal"
  block::setvalue $blk_obj blk_obj_attr
  block::DefaultValue $blk_obj blk_obj_attr
 }

#=======================================================================
proc __evt_AddRapidSpindleElems { POST_OBJ BLK_OBJ } {
  upvar $POST_OBJ post_obj
  upvar $BLK_OBJ blk_obj
  set rap_add_list $Post::($post_obj,rap_add_list)
  block::readvalue $blk_obj blk_obj_attr
  set new_blk_elem_list ""
  set z_is_added 0
  foreach blk_elem_obj $block::($blk_obj,elem_addr_list) \
  {
   set add_obj $block_element::($blk_elem_obj,elem_add_obj)
   switch $address::($add_obj,add_name) \
   {
    "X" -
    "Y" {
     PB_com_DeleteObject $blk_elem_obj
    }
    "Z" {
     set add_name "rapid3"
     PB_com_RetObjFrmName add_name rap_add_list rap_add_obj
     block_element::readvalue $blk_elem_obj blk_elem_attr
     set blk_elem_attr(0) $rap_add_obj
     set blk_elem_attr(3) $address::($rap_add_obj,word_desc)
     PB_blk_CreateBlkElemObj blk_elem_attr new_blk_elem blk_obj_attr
     set block_element::($new_blk_elem,owner) "post"
     lappend new_blk_elem_list $new_blk_elem
     PB_com_DeleteObject $blk_elem_obj
     set z_is_added 1
    }
    default {
     lappend new_blk_elem_list $blk_elem_obj
    }
   }
  }
  if { !$z_is_added } {
   set add_name "rapid3"
   PB_com_RetObjFrmName add_name rap_add_list rap_add_obj
   set blk_elem_attr(0) $rap_add_obj
   set blk_elem_attr(1) "\$mom_pos(2)"
   set blk_elem_attr(2) "blank"
   set blk_elem_attr(3) $address::($rap_add_obj,word_desc)
   set blk_elem_attr(4) 0
   PB_blk_CreateBlkElemObj blk_elem_attr new_blk_elem blk_obj_attr
   set block_element::($new_blk_elem,owner) "post"
   lappend new_blk_elem_list $new_blk_elem
  }
  set blk_obj_attr(1) [llength $new_blk_elem_list]
  set blk_obj_attr(2) $new_blk_elem_list
  set blk_obj_attr(3) "normal"
  block::setvalue $blk_obj blk_obj_attr
  block::DefaultValue $blk_obj blk_obj_attr
  if 0 {
   Post::GetObjList $post_object sequence seq_obj_list
   set seq_name "tpth_mot"
   PB_com_RetObjFrmName seq_name seq_obj_list seq_obj
   set evt_obj_list $sequence::($seq_obj,evt_obj_list)
   set evt_name "Rapid Move"
   PB_com_RetObjFrmName evt_name evt_obj_list evt_obj
   set evt_elem_list $event::($evt_obj,evt_elem_list)
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
    set block::($trav_blk,active_blk_elem_list) $tra_blk_elem
    PB_int_CreateNewBlock blk_obj_attr(0) spin_blk_elem event_name \
    new_blk_obj blk_type
    set block::($new_blk_obj,active_blk_elem_list) $spin_blk_elem
    PB_int_CreateNewEventElement new_blk_obj new_evt_elem_obj
   }
  }
 }

#=======================================================================
proc PB_evt_ChangeBlkToPostBlk { POST_OBJ EVENT_NAME BLOCK_OBJ } {
  upvar $POST_OBJ post_obj
  upvar $EVENT_NAME event_name
  upvar $BLOCK_OBJ block_obj
  global mom_sys_arr ;#<06-08-09 wbh>
  set blk_obj_list $Post::($post_obj,blk_obj_list)
  set block_name $block::($block_obj,block_name)
  if [string match "post_cycle_set" $block_name] \
  {
   PB_evt_ChangeBlkElemOwner post_obj event_name block_obj
   set block::($block_obj,blk_owner) $event_name
   if { [string match "post_*" $block_name]} \
   {
    set index [lsearch $blk_obj_list $block_obj]
    set blk_obj_list [lreplace $blk_obj_list $index $index]
    set Post::($post_obj,blk_obj_list) $blk_obj_list
   }
   } elseif { [string match "post_*" $block_name] } \
  {
   set block::($block_obj,blk_owner) "post"
   foreach blk_elem_obj $block::($block_obj,elem_addr_list) \
   {
    set block_element::($blk_elem_obj,owner) "post"
   }
   set index [lsearch $blk_obj_list $block_obj]
   set blk_obj_list [lreplace $blk_obj_list $index $index]
   set Post::($post_obj,blk_obj_list) $blk_obj_list
   if [string match "post_startblk" $block_name] \
   {
    set Post::($post_obj,rst_post_startblk) $block_obj
   }
   } elseif { [info exists mom_sys_arr(post_startblk)] && \
  [string match $block_name $mom_sys_arr(post_startblk)] } \
  {
   set block::($block_obj,blk_owner) "post"
   foreach blk_elem_obj $block::($block_obj,elem_addr_list) \
   {
    set block_element::($blk_elem_obj,owner) "post"
   }
   set index [lsearch $blk_obj_list $block_obj]
   set blk_obj_list [lreplace $blk_obj_list $index $index]
   set Post::($post_obj,blk_obj_list) $blk_obj_list
   set Post::($post_obj,rst_post_startblk) $block_obj
   } elseif { [string match "just_mcall_sinumerik" $block_name] } \
  { ;#<06-08-09 wbh> add one case
   foreach blk_elem_obj $block::($block_obj,elem_addr_list) \
   {
    set block_element::($blk_elem_obj,owner) "post"
   }
  }
 }

#=======================================================================
proc __evt_RapidWrkPlaneChange { EVT_BLK_LIST POST_OBJ } {
  upvar $EVT_BLK_LIST evt_blk_list
  upvar $POST_OBJ post_obj
  array set mom_sys_var $Post::($post_obj,mom_sys_var_list)
  set rapid_1 $mom_sys_var(\$pb_rapid_1)
  set rapid_2 $mom_sys_var(\$pb_rapid_2)
  set rapid_name_1 ""
  set rapid_name_2 ""
  if { $rapid_1 != "" } \
  {
   if [info exists block::($rapid_1,block_name)] {
    set rapid_name_1 $block::($rapid_1,block_name)
   }
  }
  if { $rapid_2 != "" } \
  {
   if [info exists block::($rapid_2,block_name)] {
    set rapid_name_2 $block::($rapid_2,block_name)
   }
  }
  foreach event_row $evt_blk_list \
  {
   foreach evt_elem_obj $event_row \
   {
    set blk_obj $event_element::($evt_elem_obj,block_obj)
    set block_name $block::($blk_obj,block_name)
    if { [string compare $block_name "$rapid_name_1"] == 0 } \
    {
     __evt_AddRapidTravElems post_obj blk_obj
     } elseif { $rapid_name_2 != "" && \
    [string compare $block_name "$rapid_name_2"] == 0 } \
    {
     __evt_AddRapidSpindleElems post_obj blk_obj
    }
   }
  }
 }

#=======================================================================
proc PB_evt_StorePostBlocks { EVT_ELEM_LIST POST_OBJ } {
  upvar $EVT_ELEM_LIST evt_elem_list
  upvar $POST_OBJ post_obj
  set Post::($post_obj,post_blk_list) ""
  set post_blk_list ""
  foreach evt_elem_obj $evt_elem_list \
  {
   set block_obj $event_element::($evt_elem_obj,block_obj)
   set block_name $block::($block_obj,block_name)
   if { [string match "post_*" $block_name] || \
   ![string compare $block::($block_obj,blk_owner) "post"]} \
   {
    lappend post_blk_list $block_obj
   }
  }
  set Post::($post_obj,post_blk_list) $post_blk_list
 }

#=======================================================================
proc __evt_GetCycleRepVar { add_name ADD_REP_BLK_VAR } {
  upvar $ADD_REP_BLK_VAR add_rep_blk_var
  global post_object
  Post::GetObjList $post_object address add_obj_list
  PB_com_RetObjFrmName add_name add_obj_list add_obj
  set blk_elem_obj_list $address::($add_obj,blk_elem_list)
  foreach blk_elem_obj $blk_elem_obj_list \
  {
   set blk_name       $block_element::($blk_elem_obj,parent_name)
   if [string match "post_cycle_set" $blk_name] \
   {
    block_element::readvalue $blk_elem_obj blk_elem_obj_attr
    set elem_mom_var   $blk_elem_obj_attr(1)
    set add_rep_blk_var [list $elem_mom_var]
   }
  }
 }

#=======================================================================
proc PB_evt_CreateRapidToBlock { EVENT_OBJ EVT_ELEM_LIST MOM_SYS_VAR } {
  upvar $EVENT_OBJ event_obj
  upvar $EVT_ELEM_LIST evt_elem_list
  upvar $MOM_SYS_VAR mom_sys_var
  global post_object
  switch $mom_sys_var(\$cycle_rapto_opt) \
  {
   "None"  {
    set elem_address ""
    set elem_mom_var ""
    set add_rep_blk_addr ""
   }
   "R"  {
    set elem_address ""
    set elem_mom_var ""
    set add_rep_blk_addr {"R"}
   }
   "Rapid_Traverse_&_R"  {
    set elem_address {{"G_motion" "X" "Y"}}
    set elem_mom_var {{"$mom_sys_rapid_code" "$mom_cycle_rapid_to_pos(0)" \
    "$mom_cycle_rapid_to_pos(1)"}}
    set add_rep_blk_addr {"R"}
   }
   "Rapid"  {
    set elem_address {{"G_motion" "X" "Y"} \
    {"G_motion" "Z"}}
    set elem_mom_var {{"$mom_sys_rapid_code" "$mom_cycle_rapid_to_pos(0)" \
     "$mom_cycle_rapid_to_pos(1)"} {"$mom_sys_rapid_code" \
    "$mom_cycle_rapid_to_pos(2)"}}
    set add_rep_blk_addr ""
   }
   default  {
    set elem_address ""
    set elem_mom_var ""
    set add_rep_blk_addr ""
   }
  }
  if [string match "$mom_sys_var(\$cycle_rapto_opt)" $event::($event_obj,cycle_rapid_to)] {
   __evt_GetCycleRepVar R add_rep_blk_var
   UI_PB_debug_ForceMsg "+++++ Cycle Rapid To block retrieved. +++++"
   } else {
   switch $mom_sys_var(\$cycle_rapto_opt) \
   {
    "None" {
     set elem_mom_var ""
     set add_rep_blk_var ""
    }
    "R" {
     set elem_mom_var ""
     if { $mom_sys_var(\$cycle_start_blk) } \
     {
      set add_rep_blk_var {"$mom_cycle_rapid_to"}
     } else \
     {
      set add_rep_blk_var {"$mom_cycle_rapid_to_pos($mom_cycle_spindle_axis)"}
     }
    }
    "Rapid_Traverse_&_R" {
     set elem_mom_var {{"$mom_sys_rapid_code" "$mom_cycle_rapid_to_pos(0)" \
     "$mom_cycle_rapid_to_pos(1)"}}
     if { $mom_sys_var(\$cycle_start_blk) } \
     {
      set add_rep_blk_var {"$mom_cycle_rapid_to"}
     } else \
     {
      set add_rep_blk_var {"$mom_cycle_rapid_to_pos($mom_cycle_spindle_axis)"}
     }
    }
    "Rapid" {
     set elem_mom_var {{"$mom_sys_rapid_code" "$mom_cycle_rapid_to_pos(0)" \
      "$mom_cycle_rapid_to_pos(1)"} {"$mom_sys_rapid_code" \
     "$mom_cycle_rapid_to_pos(2)"}}
     set add_rep_blk_var ""
    }
    default {
     set elem_mom_var ""
     set add_rep_blk_var ""
    }
   }
   UI_PB_debug_ForceMsg "+++++ Cycle Rapid To block constructed. +++++"
  }
  set event_name $event::($event_obj,event_name)
  set post_blk_name "rapidto"
  switch $mom_sys_var(\$cycle_rapto_opt) \
  {
   "None"  {
    set elem_owner ""
    set blk_owner ""
    set add_rep_owner ""
   }
   "R"  {
    set elem_owner ""
    set blk_owner ""
    set add_rep_owner {"post"}
   }
   "Rapid_Traverse_&_R"  {
    set elem_owner [list [list "post" "post" "post"]]
    set blk_owner [list $event_name]
    set add_rep_owner {"post"}
   }
   "Rapid"  {
    set elem_owner [list [list "post" "post" "post"] \
    [list "post" "post"]]
    set blk_owner [list $event_name $event_name]
    set add_rep_owner ""
   }
   default  {
    set elem_owner ""
    set blk_owner ""
    set add_rep_owner ""
   }
  }
  set new_elem_list ""
  PB_evt_CreatePostBlock blk_owner post_blk_name elem_address \
  elem_mom_var elem_owner new_elem_list
  if { $mom_sys_var(\$cycle_start_blk) } \
  {
   set act_evt_elem_list ""
   foreach evt_elem_obj $evt_elem_list \
   {
    set block_obj $event_element::($evt_elem_obj,block_obj)
    set ret [PB_evt_CheckCycleRefWord block_obj 2]
    if { $ret } \
    {
     foreach new_elem $new_elem_list \
     {
      lappend act_evt_elem_list $new_elem
     }
    }
    lappend act_evt_elem_list $evt_elem_obj
   }
   set evt_elem_list $act_evt_elem_list
  } else \
  {
   foreach evt_elem_obj $evt_elem_list \
   {
    lappend new_elem_list $evt_elem_obj
   }
   set evt_elem_list $new_elem_list
  }
  PB_evt_AddPostElementToBlock evt_elem_list add_rep_blk_addr \
  add_rep_owner add_rep_blk_var
  if { [string match "*R" $event::($event_obj,cycle_rapid_to)]  && \
   [string match "*R" $mom_sys_var(\$cycle_rapto_opt)] } {
   set blk_elem $event::($event_obj,blk_elem_R)
   unset event::($event_obj,blk_elem_R)
   block_element::readvalue $blk_elem blk_elem_obj_attr
   set elem_add_obj   $blk_elem_obj_attr(0)
   set elem_mom_var   $blk_elem_obj_attr(1)
   set elem_opt_nows  $blk_elem_obj_attr(2)
   set elem_desc      $blk_elem_obj_attr(3)
   set elem_force     $blk_elem_obj_attr(4)
   UI_PB_debug_ForceMsg "*** Cycle RapidTo R Word ***\n\
   Address : $address::($elem_add_obj,add_name)\n\
   MOM var : $elem_mom_var\n\
   Options : $elem_opt_nows\n\
   Desc    : $elem_desc\n\
   Force   : $elem_force"
   PB_int_RetPostBlocks post_blk_list
   set blk_name "post_cycle_set"
   PB_com_RetObjFrmName blk_name post_blk_list blk_obj
   foreach blk_elem $block::($blk_obj,elem_addr_list) {
    block_element::readvalue $blk_elem blk_elem_obj_attr
    set elem_add_obj   $blk_elem_obj_attr(0)
    if [string match "R" $address::($elem_add_obj,add_name)] {
     set blk_elem_obj_attr(1) $elem_mom_var
     set blk_elem_obj_attr(2) $elem_opt_nows
     set blk_elem_obj_attr(3) $elem_desc
     set blk_elem_obj_attr(4) $elem_force
     block_element::setvalue $blk_elem blk_elem_obj_attr
     block_element::RestoreValue $blk_elem
     break
    }
   }
  }
  set event::($event_obj,cycle_rapid_to)  $mom_sys_var(\$cycle_rapto_opt)
 }

#=======================================================================
proc PB_evt_CreatePostBlock { BLK_OWNER BLOCK_NAME ELEM_ADDRESS \
  ELEM_MOM_VAR ELEM_OWNER EVT_ELEM_LIST } {
  upvar $BLK_OWNER blk_owner
  upvar $BLOCK_NAME block_name
  upvar $ELEM_ADDRESS elem_address
  upvar $ELEM_MOM_VAR elem_mom_var
  upvar $ELEM_OWNER elem_owner
  upvar $EVT_ELEM_LIST evt_elem_list
  global g_no_change_post_blk_name ;#<06-08-09 wbh>
  if {$elem_address != ""} \
  {
   set no_blks [llength $elem_address]
   for {set ii 0} {$ii < $no_blks} {incr ii} \
   {
    set blk_obj [new block]
    set blk_elem_adds [lindex $elem_address $ii]
    set blk_elem_vars [lindex $elem_mom_var $ii]
    set blk_elem_owner [lindex $elem_owner $ii]
    set no_of_elems [llength $blk_elem_adds]
    if {$ii != 0} \
    {
     append blk_obj_attr(0) "post_" $block_name _ $ii
    } else \
    {
     set blk_obj_attr(0) "post_$block_name"
    }
    if { [info exists g_no_change_post_blk_name] && \
    $g_no_change_post_blk_name } \
    {
     set blk_obj_attr(0) [string range $blk_obj_attr(0) 5 end]
    }
    for {set jj 0} {$jj < $no_of_elems} {incr jj} \
    {
     set add_name [lindex $blk_elem_adds $jj]
     set mom_var [lindex $blk_elem_vars $jj]
     PB_blk_AddNewBlkElemObj add_name mom_var blk_obj_attr \
     new_elem_obj
     lappend blk_elem_obj_list $new_elem_obj
     set block_element::($new_elem_obj,owner) \
     [lindex $blk_elem_owner $jj]
     if { [string match "startblk" $block_name]  && \
      [string match "G_motion" $add_name] } {
      set block_element::($new_elem_obj,force) 1
     }
    }
    set blk_obj_attr(1) [llength $blk_elem_obj_list]
    set blk_obj_attr(2) $blk_elem_obj_list
    set blk_obj_attr(3) "normal"
    block::setvalue $blk_obj blk_obj_attr
    block::DefaultValue $blk_obj blk_obj_attr
    set block::($blk_obj,blk_owner) [lindex $blk_owner $ii]
    set evt_elem_obj_attr(0) $blk_obj_attr(0)
    set evt_elem_obj_attr(1) $blk_obj
    set evt_elem_obj [new event_element]
    event_element::setvalue $evt_elem_obj evt_elem_obj_attr
    event_element::DefaultValue $evt_elem_obj evt_elem_obj_attr
    unset evt_elem_obj_attr
    unset blk_obj_attr
    unset blk_elem_obj_list
    lappend evt_elem_list $evt_elem_obj
   }
   } elseif { ![string match "" $elem_mom_var] } \
  { ;#<06-08-09 wbh> add custom command block
   set blk_elem_var [lindex $elem_mom_var 0]
   PB_int_CreateCmdBlkElem blk_elem_var new_elem_obj
   set block_element::($new_elem_obj,owner) [lindex $elem_owner 0]
   set blk_obj [new block]
   set blk_obj_attr(0) $block_name
   set blk_obj_attr(1) 1
   set blk_obj_attr(2) [list $new_elem_obj]
   set blk_obj_attr(3) "command"
   block::setvalue $blk_obj blk_obj_attr
   block::DefaultValue $blk_obj blk_obj_attr
   set block::($blk_obj,blk_owner) [lindex $blk_owner 0]
   set evt_elem_obj_attr(0) $blk_obj_attr(0)
   set evt_elem_obj_attr(1) $blk_obj
   set evt_elem_obj [new event_element]
   event_element::setvalue $evt_elem_obj evt_elem_obj_attr
   event_element::DefaultValue $evt_elem_obj evt_elem_obj_attr
   unset evt_elem_obj_attr
   unset blk_obj_attr
   lappend evt_elem_list $evt_elem_obj
  }
  if [info exists g_no_change_post_blk_name] \
  {
   unset g_no_change_post_blk_name
  }
 }

#=======================================================================
proc PB_evt_GetPostBlock { BLK_OWNER BLOCK_NAME ELEM_ADDRESS \
  ELEM_MOM_VAR ELEM_OWNER EVT_ELEM_LIST } {
  upvar $BLK_OWNER blk_owner
  upvar $BLOCK_NAME block_name
  upvar $ELEM_ADDRESS elem_address
  upvar $ELEM_MOM_VAR elem_mom_var
  upvar $ELEM_OWNER elem_owner
  upvar $EVT_ELEM_LIST evt_elem_list
  foreach evt_elem_obj $evt_elem_list \
  {
   event_element::readvalue $evt_elem_obj evt_elem_obj_attr
   set blk_obj  $evt_elem_obj_attr(1)
   block::readvalue $blk_obj blk_obj_attr
   set blk_elem_obj_list $blk_obj_attr(2)
   foreach blk_elem_obj $blk_elem_obj_list \
   {
    block_element::readvalue $blk_elem_obj blk_elem_obj_attr
    set elem_add_obj   $blk_elem_obj_attr(0)
    set elem_mom_var   $blk_elem_obj_attr(1)
    set elem_opt_nows  $blk_elem_obj_attr(2)
    set elem_desc      $blk_elem_obj_attr(3)
    set elem_force     $blk_elem_obj_attr(4)
   }
  }
  if {$elem_address != ""} \
  {
   set no_blks [llength $elem_address]
   for {set ii 0} {$ii < $no_blks} {incr ii} \
   {
    set blk_obj [new block]
    set blk_elem_adds [lindex $elem_address $ii]
    set blk_elem_vars [lindex $elem_mom_var $ii]
    set blk_elem_owner [lindex $elem_owner $ii]
    set no_of_elems [llength $blk_elem_adds]
    if {$ii != 0} \
    {
     append blk_obj_attr(0) "post_" $block_name _ $ii
    } else \
    {
     set blk_obj_attr(0) "post_$block_name"
    }
    for {set jj 0} {$jj < $no_of_elems} {incr jj} \
    {
     set add_name [lindex $blk_elem_adds $jj]
     set mom_var [lindex $blk_elem_vars $jj]
     PB_blk_AddNewBlkElemObj add_name mom_var blk_obj_attr \
     new_elem_obj
     lappend blk_elem_obj_list $new_elem_obj
     set block_element::($new_elem_obj,owner) \
     [lindex $blk_elem_owner $jj]
     if { [string match "startblk" $block_name]  && \
      [string match "G_motion" $add_name] } {
      set block_element::($new_elem_obj,force) 1
     }
    }
    set blk_obj_attr(1) [llength $blk_elem_obj_list]
    set blk_obj_attr(2) $blk_elem_obj_list
    set blk_obj_attr(3) "normal"
    block::setvalue $blk_obj blk_obj_attr
    block::DefaultValue $blk_obj blk_obj_attr
    set block::($blk_obj,blk_owner) [lindex $blk_owner $ii]
    set evt_elem_obj_attr(0) $blk_obj_attr(0)
    set evt_elem_obj_attr(1) $blk_obj
    set evt_elem_obj [new event_element]
    event_element::setvalue $evt_elem_obj evt_elem_obj_attr
    event_element::DefaultValue $evt_elem_obj evt_elem_obj_attr
    unset evt_elem_obj_attr
    unset blk_obj_attr
    unset blk_elem_obj_list
    lappend evt_elem_list $evt_elem_obj
   }
  }
 }

#=======================================================================
proc PB_evt_AddPostElementToBlock { EVT_ELEM_LIST ADD_REP_BLK_ADDR \
  ADD_REP_OWNER ADD_REP_BLK_VAR } {
  upvar $EVT_ELEM_LIST evt_elem_list
  upvar $ADD_REP_BLK_ADDR add_rep_blk_addr
  upvar $ADD_REP_OWNER add_rep_owner
  upvar $ADD_REP_BLK_VAR add_rep_blk_var
  if {$add_rep_blk_addr != ""} \
  {
   foreach evt_elem_obj $evt_elem_list \
   {
    set cyc_block_obj $event_element::($evt_elem_obj,block_obj)
    set ret [PB_evt_CheckCycleRefWord cyc_block_obj 1]
    if { $ret == 1 } { break }
   }
   block::readvalue $cyc_block_obj cyc_blk_obj_attr
   set no_of_elems [llength $add_rep_blk_addr]
   for {set jj 0} {$jj < $no_of_elems} {incr jj} \
   {
    set blk_elem_add [lindex $add_rep_blk_addr $jj]
    set blk_elem_var [lindex $add_rep_blk_var $jj]
    set blk_elem_owner [lindex $add_rep_owner $jj]
    PB_blk_AddNewBlkElemObj blk_elem_add blk_elem_var cyc_blk_obj_attr \
    new_elem_obj
    set block_element::($new_elem_obj,owner) $blk_elem_owner
    lappend block::($cyc_block_obj,elem_addr_list) $new_elem_obj
   }
   unset cyc_blk_obj_attr
  }
 }

#=======================================================================
proc PB_evt_CreateRetractToBlock { EVENT_OBJ EVT_ELEM_LIST MOM_SYS_VAR } {
  upvar $EVENT_OBJ event_obj
  upvar $EVT_ELEM_LIST evt_elem_list
  upvar $MOM_SYS_VAR mom_sys_var
  if [string match "$mom_sys_var(\$cycle_recto_opt)" $event::($event_obj,cycle_retract_to)] {
   __evt_GetCycleRepVar K_cycle add_rep_blk_var
   UI_PB_debug_ForceMsg "+++++ Cycle Retract To block retrieved. +++++"
   } else {
   set event::($event_obj,cycle_retract_to) $mom_sys_var(\$cycle_recto_opt)
   switch $mom_sys_var(\$cycle_recto_opt) \
   {
    "K" \
    {
     if { $mom_sys_var(\$cycle_start_blk) } \
     {
      set add_rep_blk_var {"$mom_cycle_retract_to"}
     } else \
     {
      set add_rep_blk_var {"$mom_cycle_retract_to_pos($mom_cycle_spindle_axis)"}
     }
    }
    "G98/G99" \
    {
     set add_rep_blk_var {"$mom_sys_cycle_ret_code($mom_cycle_retract_mode)"}
    }
    "Rapid_Spindle" \
    {
     set add_rep_blk_var ""
    }
    "Cycle_Off_then_Rapid_Spindle" \
    {
     set add_rep_blk_var ""
    }
    default \
    {
     set add_rep_blk_var ""
    }
   }
   UI_PB_debug_ForceMsg "+++++ Cycle Retract To block constructed. +++++"
  }
  set event_name $event::($event_obj,event_name)
  set post_blk_name "retracto"
  switch $mom_sys_var(\$cycle_recto_opt) \
  {
   "K" \
   {
    set elem_address ""
    set elem_mom_var ""
    set elem_owner  ""
    set blk_owner ""
    set add_rep_blk_addr {"K_cycle"}
    set add_rep_owner {"post"}
   }
   "G98/G99" \
   {
    set elem_address ""
    set elem_mom_var ""
    set elem_owner   ""
    set blk_owner    ""
    set add_rep_blk_addr {"G_return"}
    set add_rep_owner {"post"}
   }
   "Rapid_Spindle" \
   {
    set elem_address {{"G_motion" "Z"}}
    set elem_mom_var {{"$mom_sys_rapid_code" "$mom_cycle_retract_to_pos(2)"}}
    set elem_owner  [list [list "post" "post"]]
    set blk_owner [list $event_name]
    set add_rep_blk_addr ""
    set add_rep_owner ""
   }
   "Cycle_Off_then_Rapid_Spindle" \
   {
    set elem_address {{"G_motion"} {"G_motion" "Z"}}
    set elem_mom_var {{"$mom_sys_cycle_off"} \
    {"$mom_sys_rapid_code" "$mom_cycle_retract_to_pos(2)"}}
    set elem_owner  [list [list "post"] [list "post" "post"]]
    set blk_owner [list "post" $event_name]
    set add_rep_blk_addr ""
    set add_rep_owner ""
   }
   default \
   {
    set elem_address ""
    set elem_mom_var ""
    set elem_owner ""
    set blk_owner ""
    set add_rep_blk_addr ""
    set add_rep_owner ""
   }
  }
  set new_elem_list ""
  PB_evt_CreatePostBlock blk_owner post_blk_name elem_address elem_mom_var \
  elem_owner new_elem_list
  set act_evt_elem_list ""
  if { $mom_sys_var(\$cycle_start_blk) == 0 } \
  {
   foreach evt_elem_obj $evt_elem_list \
   {
    lappend act_evt_elem_list $evt_elem_obj
   }
   foreach evt_elem_obj $new_elem_list \
   {
    lappend act_evt_elem_list $evt_elem_obj
   }
  } else \
  {
   foreach evt_elem_obj $evt_elem_list \
   {
    set block_obj $event_element::($evt_elem_obj,block_obj)
    set block_name $block::($block_obj,block_name)
    lappend act_evt_elem_list $evt_elem_obj
    if { [string compare $block_name "post_startblk"] == 0 } \
    {
     foreach new_evt_elem_obj $new_elem_list \
     {
      lappend act_evt_elem_list $new_evt_elem_obj
     }
    }
   }
  }
  set evt_elem_list $act_evt_elem_list
  PB_evt_AddPostElementToBlock evt_elem_list add_rep_blk_addr \
  add_rep_owner add_rep_blk_var
 }

#=======================================================================
proc PB_evt_CreateCycleStartBlock { EVENT_OBJ EVT_ELEM_LIST MOM_SYS_VAR \
  STRT_BLK_INDX } {
  upvar $EVENT_OBJ event_obj
  upvar $EVT_ELEM_LIST evt_elem_list
  upvar $MOM_SYS_VAR mom_sys_var
  upvar $STRT_BLK_INDX strt_blk_indx
  set post_blk_name "startblk"
  switch $mom_sys_var(\$cycle_start_blk) \
  {
   0   {
    set elem_address ""
    set elem_mom_var ""
    set elem_owner ""
    set blk_owner ""
    set z_var  "\$mom_cycle_feed_to_pos(2)"
    set z_desc "Cycle Feed Z"
    set r_var  "\$mom_cycle_rapid_to_pos(\$mom_cycle_spindle_axis)"
    set r_desc "Rapid Z Position in Cycle"
    set k_var  "\$mom_cycle_retract_to_pos(\$mom_cycle_spindle_axis)"
    set k_desc "Retract Z Position in Cycle"
   }
   1   {
    if 0 {
     set elem_address {{"G_motion" "X" "Y" "Z"}}
     set elem_mom_var {{"$mom_sys_cycle_start_code" \
      "$mom_pos(0)" \
      "$mom_pos(1)" \
     "$mom_pos(2)"}}
     set elem_owner {{"post" "post" "post" "post"}}
    }
    global gPB
    if [PB_com_IsSiemensController $gPB(post_controller_type) 1] \
    {
     set elem_address {{"X" "Y" "Z" "fourth_axis" "fifth_axis"}}
     set elem_mom_var {{"$mom_pos(0)" \
      "$mom_pos(1)" \
      "$mom_pos(2)" \
      "$mom_out_angle_pos(0)" \
     "$mom_out_angle_pos(1)"}}
     set elem_owner {{"post" "post" "post" "post" "post"}}
    } else \
    {
     set elem_address {{"G_motion" "X" "Y" "Z" "fourth_axis" "fifth_axis"}}
     set elem_mom_var {{"$mom_sys_cycle_start_code" \
      "$mom_pos(0)" \
      "$mom_pos(1)" \
      "$mom_pos(2)" \
      "$mom_out_angle_pos(0)" \
     "$mom_out_angle_pos(1)"}}
     set elem_owner {{"post" "post" "post" "post" "post" "post"}}
    }
    if { [info exists Post::($::post_object,rst_post_startblk)] && \
    $Post::($::post_object,rst_post_startblk) != "" } \
    {
     set rst_blk $Post::($::post_object,rst_post_startblk)
     set rst_blk_name $block::($rst_blk,block_name)
     set temp_flag 0
     if [llength $block::($rst_blk,elem_addr_list)] \
     {
      if [string match "post_startblk" $rst_blk_name] \
      {
       set temp_flag 1
       } elseif  { [info exists mom_sys_var(post_startblk)] && \
       ![string match "" $mom_sys_var(post_startblk)] && \
      [string match $rst_blk_name $mom_sys_var(post_startblk)] } \
      {
       set temp_flag 2
      }
     }
     if $temp_flag \
     {
      if [string match "normal" $block::($rst_blk,blk_type)] \
      {
       set elem_address ""
       set elem_mom_var ""
       set elem_owner ""
       foreach blk_elem $block::($rst_blk,elem_addr_list) \
       {
        set add_obj $block_element::($blk_elem,elem_add_obj)
        lappend temp_elem_address $address::($add_obj,add_name)
        lappend temp_elem_mom_var $block_element::($blk_elem,elem_mom_variable)
        lappend temp_elem_owner "post"
       }
       lappend elem_address $temp_elem_address
       lappend elem_mom_var $temp_elem_mom_var
       lappend elem_owner   $temp_elem_owner
       if { $temp_flag == 2 } \
       {
        global g_no_change_post_blk_name
        set g_no_change_post_blk_name 1
        set post_blk_name $block::($rst_blk,block_name)
       }
      } elseif [string match "command" $block::($rst_blk,blk_type)] \
      {
       set elem_address ""
       set elem_mom_var ""
       lappend elem_mom_var $block::($rst_blk,block_name)
       set elem_owner {"post"}
       set post_blk_name $block::($rst_blk,block_name)
      }
     }
    }
    set blk_owner [list "post"]
    set z_var "\$mom_cycle_feed_to"
    set z_desc "Cycle Feed To Distance"
    set r_var "\$mom_cycle_rapid_to"
    set r_desc "Cycle Rapid To Distance"
    set k_var "\$mom_cycle_retract_to"
    set k_desc "Cycle Retract To Distance"
   }
  }
  set event_name "post"
  PB_evt_CreatePostBlock blk_owner post_blk_name elem_address \
  elem_mom_var elem_owner new_elem_list
  foreach cyc_set_elem $evt_elem_list \
  {
   set block_obj $event_element::($cyc_set_elem,block_obj)
   set com_ret [PB_evt_CheckCycleRefWord block_obj 1]
   if { $com_ret } {
    break
   }
  }
  if { [info exists com_ret] && $com_ret } \
  {
   set set_indx [lsearch $evt_elem_list $cyc_set_elem]
   set evt_elem_list [lreplace $evt_elem_list $set_indx $set_indx]
  } else \
  {
   if !$mom_sys_var(\$cycle_start_blk) \
   {
    set evt_elem_list [lreplace $evt_elem_list end end]
   }
   set set_indx [llength $evt_elem_list]
   if { $mom_sys_var(\$cycle_start_blk) && $strt_blk_indx && \
   [PB_com_IsSiemensController $::gPB(post_controller_type) 1] } \
   {
    set set_indx $strt_blk_indx
   }
  }
  if { $mom_sys_var(\$cycle_start_blk) } \
  {
   set evt_elem_list [linsert $evt_elem_list $set_indx $new_elem_list]
   if { [info exists com_ret] && $com_ret } \
   {
    set evt_elem_list [linsert $evt_elem_list $strt_blk_indx $cyc_set_elem]
   }
  } else \
  {
   if { $strt_blk_indx != 0} \
   {
    incr strt_blk_indx -1
   }
   set evt_elem_list [linsert $evt_elem_list $strt_blk_indx $cyc_set_elem]
  }
  foreach evt_elem $evt_elem_list \
  {
   set block_obj $event_element::($evt_elem,block_obj)
   set com_ret [PB_evt_CheckCycleRefWord block_obj 1]
   if { $com_ret } \
   {
    foreach blk_elem_obj $block::($block_obj,active_blk_elem_list) \
    {
     set add_obj $block_element::($blk_elem_obj,elem_add_obj)
     switch $address::($add_obj,add_name) \
     {
      "Z" {
       set block_element::($blk_elem_obj,elem_mom_variable) $z_var
       set block_element::($blk_elem_obj,elem_desc) $z_desc
      }
      "R" {
       set block_element::($blk_elem_obj,elem_mom_variable) $r_var
       set block_element::($blk_elem_obj,elem_desc) $r_desc
      }
      "K_cycle" {
       set block_element::($blk_elem_obj,elem_mom_variable) $k_var
       set block_element::($blk_elem_obj,elem_desc) $k_desc
      }
     }
    }
   }
  }
 }

#=======================================================================
proc PB_evt_CreateCyclePlaneBlock { EVENT_OBJ EVT_ELEM_LIST MOM_SYS_VAR } {
  upvar $EVENT_OBJ event_obj
  upvar $EVT_ELEM_LIST evt_elem_list
  upvar $MOM_SYS_VAR mom_sys_var
  set event_name $event::($event_obj,event_name)
  switch $mom_sys_var(\$cycle_plane_control_opt) \
  {
   "None"               {
    set add_rep_blk_addr ""
    set add_rep_blk_var ""
    set add_rep_owner ""
   }
   "G17/G18/G19"        {
    set add_rep_blk_addr {"G_plane"}
    set add_rep_blk_var \
    {"$mom_sys_cutcom_plane_code($mom_cutcom_plane)"}
    set add_rep_owner {"post"}
   }
   default             {
    set add_rep_blk_addr ""
    set add_rep_blk_var ""
    set add_rep_owner ""
   }
  }
  PB_evt_AddPostElementToBlock evt_elem_list add_rep_blk_addr \
  add_rep_owner add_rep_blk_var
 }

#=======================================================================
proc PB_evt_SetOwnerShipForBlkElem { BLK_OBJ EVENT_NAME } {
  upvar $BLK_OBJ blk_obj
  upvar $EVENT_NAME event_name
  global post_object
  set common_evt [lindex $Post::($post_object,cyl_com_evt) 0]
  set shared_evt_list [lindex $Post::($post_object,cyl_evt_sh_com_evt) 0]
  set cmd_blk_list $Post::($post_object,cmd_blk_list)
  set comment_blk_list $Post::($post_object,comment_blk_list)
  array set word_mom_var_list $Post::($post_object,word_mom_var)
  set command_list $word_mom_var_list(Command)
  set comment_list $word_mom_var_list(Operator_Message)
  set func_blk_list $Post::($post_object,function_blk_list)
  PB_int_RetFunctionNames function_list
  set blk_elem_obj_list $block::($blk_obj,elem_addr_list)
  set block::($blk_obj,blk_owner) $event_name
  if { [lsearch $shared_evt_list $event_name] != -1 } \
  {
   set cycle_evt_list $Post::($post_object,tpth_cycle_evt_list)
   array set cycle_evt_blks $Post::($post_object,tpth_cycle_evt_blk_list)
   set indx [lindex $cycle_evt_list [expr [lsearch $cycle_evt_list \
   $common_evt] - 1]]
   set com_evt_blk_list $cycle_evt_blks($indx)
   set blk_obj_list $Post::($post_object,blk_obj_list)
   foreach com_evt_blk $com_evt_blk_list \
   {
    set com_blk_obj 0
    if { [lsearch $comment_list $com_evt_blk] != -1 } \
    {
     continue
     } elseif { [lsearch $command_list $com_evt_blk] != -1 } \
    {
     continue
     } elseif { [lsearch $function_list $com_evt_blk] != -1 } \
    {
     continue
     } elseif { [string match "post_*" $com_evt_blk] } \
    {
     set post_blk_list $Post::($post_object,post_blk_list)
     PB_com_RetObjFrmName com_evt_blk post_blk_list com_blk_obj
    } else \
    {
     PB_com_RetObjFrmName com_evt_blk blk_obj_list com_blk_obj
    }
    set com_ret [PB_evt_CheckCycleRefWord com_blk_obj 1]
    if { $com_ret == 1 } { break }
   }
   set blk_ret [PB_evt_CheckCycleRefWord blk_obj 1]
   if { $blk_ret == 1 && [info exists com_blk_obj] && $com_blk_obj != 0 } \
   {
    foreach blk_elem $blk_elem_obj_list\
    {
     set ret [PB_evt_CheckElemInBlock com_blk_obj blk_elem]
     if { $ret == 1 } \
     {
      set block_element::($blk_elem,owner) $common_evt
     } else \
     {
      if { [string match "\$mom_sys_cycle_reps_code" \
      $block_element::($blk_elem,elem_mom_variable)] } \
      {
       set block_element::($blk_elem,owner) "post"
       } elseif { [string match "\$mom_sys_cycle*" \
      $block_element::($blk_elem,elem_mom_variable)] } \
      {
       set block_element::($blk_elem,owner) $common_evt
      } else \
      {
       set block_element::($blk_elem,owner) $event_name
      }
     }
    }
   } else \
   {
    foreach blk_elem $blk_elem_obj_list\
    {
     set block_element::($blk_elem,owner) $event_name
    }
   }
  } else \
  {
   foreach blk_elem $blk_elem_obj_list\
   {
    if { [string compare $block_element::($blk_elem,elem_mom_variable) "\$mom_sys_cycle_reps_code"] == 0 } \
    {
     set block_element::($blk_elem,owner) "post"
    } else \
    {
     set block_element::($blk_elem,owner) $event_name
    }
   }
  }
 }

#=======================================================================
proc PB_evt_CheckElemInBlock {BLK_OBJ ELEM_OBJ} {
  upvar $BLK_OBJ blk_obj
  upvar $ELEM_OBJ elem_obj
  set elem_addr_obj $block_element::($elem_obj,elem_add_obj)
  set elem_mom_var $block_element::($elem_obj,elem_mom_variable)
  foreach blk_elem_obj $block::($blk_obj,elem_addr_list)\
  {
   set blk_elem_add_obj $block_element::($blk_elem_obj,elem_add_obj)
   set blk_elem_mom_var $block_element::($blk_elem_obj,elem_mom_variable)
   if {$blk_elem_add_obj == $elem_addr_obj && \
   [string compare $elem_mom_var $blk_elem_mom_var] == 0}\
   {
    return 1
   }
  }
  return 0
 }

#=======================================================================
proc PB_evt_RetEventVars { EVENT_OBJ EVT_VARS } {
  upvar $EVENT_OBJ event_obj
  upvar $EVT_VARS evt_vars
  event::readvalue $event_obj evt_obj_attr
  set evt_vars ""
  foreach item_obj $evt_obj_attr(3) \
  {
   item::readvalue $item_obj item_obj_attr
   foreach grp_obj $item_obj_attr(3) \
   {
    item_group::readvalue $grp_obj grp_obj_attr
    foreach mem_obj $grp_obj_attr(3) \
    {
     group_member::readvalue $mem_obj mem_obj_attr
     if { $mem_obj_attr(3) != "null" && \
     [string match "*mom_kin*" $mem_obj_attr(3)] == 0 } \
     {
      lappend evt_vars $mem_obj_attr(3)
     }
     unset mem_obj_attr
    }
    unset grp_obj_attr
   }
   unset item_obj_attr
  }
  unset evt_obj_attr
 }

#=======================================================================
proc PB_evt_ReparserBlockName { BLOCK_NAME } {
  global g_func_prefix g_func_suppress_flag
  upvar $BLOCK_NAME block_name
  set g_func_prefix ""
  set g_func_suppress_flag 0
  set len [llength $block_name]
  if {$len < 2} {return}
  set g_func_prefix [lindex $block_name 1]
  set g_func_suppress_flag [lindex $block_name 2]
  set block_name [lindex $block_name 0]
 }

#=======================================================================
proc PB_evt_SetEvtElemExecutionAttr { EVENT_NAME ELEM_ATTR elem_index } {
  upvar $EVENT_NAME event_name
  upvar $ELEM_ATTR  elem_obj_attr
  global post_object
  global gPB
  set blk_obj $elem_obj_attr(1) ;#<12-29-10 wbh> The block object
  if { $blk_obj <= 0 } {
   return
  }
  set elem_obj_attr(2) 0
  set elem_obj_attr(3) 0
  set elem_obj_attr(4) ""
  set elem_obj_attr(5) 0
  if { $Post::($post_object,blk_mod_list) != "" } {
   set blk_name $block::($blk_obj,block_name)
   array set blk_mod_arr $Post::($post_object,blk_mod_list)
   if { [info exists blk_mod_arr($blk_name)] } {
    set mod_add_list $blk_mod_arr($blk_name)
    set addr_obj_list ""
    __GetForceAddrListFromBlock $blk_obj mod_add_list addr_obj_list
    set elem_obj_attr(4) $addr_obj_list
   }
  }
  if { ! [info exists Post::($post_object,evt_elem_exec_name_list)] } { return }
  UI_PB_debug_ForceMsg "\n +++++ Execution events: $Post::($post_object,evt_elem_exec_name_list)\n"
  UI_PB_debug_ForceMsg "\n +++++ Execution words:  $Post::($post_object,evt_elem_exec_list)\n"
  set index [lsearch $Post::($post_object,evt_elem_exec_name_list) "$event_name"]
  if { $index == -1 } { return }
  array set evt_elem_exec_arr $Post::($post_object,evt_elem_exec_list)
  set elem_attr_list $evt_elem_exec_arr($index)
  foreach elem_attr $elem_attr_list {
   set id [lindex $elem_attr 0]
   if { $id == $elem_index } {
    set cond_name [lindex $elem_attr 1]
    if { [string match "$gPB(check_block_cmd_prefix)*" $cond_name] } {
     set cmd_obj [PB_com_FindObjFrmName $cond_name "command"]
     if { $cmd_obj > 0 } {
      set command::($cmd_obj,condition_flag) 1
      set elem_obj_attr(2) $cmd_obj
      } else {
      UI_PB_debug_DisplayMsg "**** Something wrong in PB_evt_SetEvtElemExecutionAttr"
     }
    }
    set elem_obj_attr(3) [lindex $elem_attr 2] ;# seq num suppress?
    if { [llength $elem_attr] >= 4 } {
     set addr_obj_list ""
     set addr_name_list [lindex $elem_attr 3]
     __GetForceAddrListFromBlock $blk_obj addr_name_list addr_obj_list
     UI_PB_debug_ForceMsg "\n +++++ Event: $event_name  Block: $block::($blk_obj,block_name) \
     Forced words: $addr_name_list { $addr_obj_list } \n"
     set elem_obj_attr(4) $addr_obj_list
     UI_PB_debug_ForceMsg "\n +++++ Event: $event_name  Block: $block::($blk_obj,block_name) \
     elem_attr: >$elem_attr<  total: [llength $elem_attr] \n"
     if { [llength $elem_attr] > 4 } {
      set elem_obj_attr(5) [lindex $elem_attr 4]
     }
    }
    return
   }
  }
 }

#=======================================================================
proc __GetForceAddrListFromBlock { blk_obj ADDR_NAME_LIST FORCE_ADDR_LIST } {
  upvar $ADDR_NAME_LIST addr_name_list
  upvar $FORCE_ADDR_LIST force_addr_list
  set force_addr_list ""
  if { [llength $addr_name_list] == 0 } {
   return
  }
  set addr_list ""
  foreach blk_elem $block::($blk_obj,elem_addr_list) {
   lappend addr_list $block_element::($blk_elem,elem_add_obj)
  }
  foreach addr_name $addr_name_list {
   set addr_obj -1
   switch $addr_name {
    rapid1 -
    rapid2 -
    rapid3 {
     set rap_add_list $Post::($::post_object,rap_add_list)
     PB_com_RetObjFrmName addr_name rap_add_list addr_obj
    }
    default {
     set addr_obj [PB_com_FindObjFrmName $addr_name "address"]
    }
   }
   if { $addr_obj > 0 && [lsearch $addr_list $addr_obj] != -1 } {
    lappend force_addr_list $addr_obj
   }
  }
 }
