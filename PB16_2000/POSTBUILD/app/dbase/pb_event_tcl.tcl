#4

#=======================================================================
proc PB_evt_CreateSeqEvents {POST_OBJ EVT_OBJ_LIST EVT_LIST_NAME \
  EVT_BLK_LIST_NAME SEQ_NAME } {
  upvar $POST_OBJ post_obj
  upvar $EVT_OBJ_LIST evt_obj_list
  upvar $EVT_LIST_NAME evt_list_name
  upvar $EVT_BLK_LIST_NAME evt_blk_list_name
  upvar $SEQ_NAME sequence_name
  array set evt_name_arr $Post::($post_obj,$evt_list_name)
  array set evt_blk_arr $Post::($post_obj,$evt_blk_list_name)
  set arr_sz [array size evt_name_arr]
  set cycle_com_evt [lindex $Post::($post_obj,cyl_com_evt) 0]
  set cycle_shared_evts [lindex $Post::($post_obj,cyl_evt_sh_com_evt) 0]
  for {set sz 0} {$sz < $arr_sz} {incr sz}\
  {
   set evt_blk_list $evt_blk_arr($sz)
   if {[lsearch $cycle_shared_evts $evt_name_arr($sz)] != -1 } \
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
   [string compare $sequence_name "tpth_cycle"] == 0 } \
   {
    PB_evt_RetUIItemObjList item_obj_list evt_name_arr($sz) post_obj
   } else \
   {
    set item_obj_list ""
   }
   set evt_obj_attr(3) $item_obj_list
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
  switch $event::($event_obj,event_name) \
  {
   "Inch Metric Mode" -
   "Feedrates"        -
   "Opskip"        { set event::($event_obj,canvas_flag) 0 }
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
  for {set ix 0} {$ix < [array size ui_evt_name_arr]} {incr ix}\
  {
   if {[string compare $ui_evt_name_arr($ix) $event_name] == 0}\
   {
    PB_evt_CreateEvtUIItemGrpMemObj item_obj_list ui_evt_itm_grp_mem_arr($ix)
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
 }

#=======================================================================
proc PB_evt_CreateUIGroup {OBJ_ATTR OBJ_LIST} {
  upvar $OBJ_ATTR obj_attr
  upvar $OBJ_LIST obj_list
  set object [new item_group]
  lappend obj_list $object
  item_group::setvalue $object obj_attr
  item_group::DefaultValue $object obj_attr
 }

#=======================================================================
proc PB_evt_CreateUIMember {OBJ_ATTR OBJ_LIST} {
  upvar $OBJ_ATTR obj_attr
  upvar $OBJ_LIST obj_list
  set object [new group_member]
  lappend obj_list $object
  group_member::setvalue $object obj_attr
  group_member::DefaultValue $object obj_attr
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
proc PB_evt_CheckCycleRefWord { BLOCK_OBJ check_flag } {
  upvar $BLOCK_OBJ block_obj
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
   set blk_elem_mom_var $block_element::($blk_elem_obj,elem_mom_variable)
   if {[string match $ref_var $blk_elem_mom_var]} \
   {
    return 1
   }
  }
  return 0
 }

#=======================================================================
proc PB_evt_RetCycleEventElements { EVT_BLK_LIST POST_OBJ EVENT_NAME \
  EVT_LIST_NAME EVT_BLK_LIST_NAME } {
  upvar $EVT_BLK_LIST evt_blk_list
  upvar $POST_OBJ post_obj
  upvar $EVENT_NAME event_name
  upvar $EVT_LIST_NAME evt_list_name
  upvar $EVT_BLK_LIST_NAME evt_blk_list_name
  set blk_obj_list $Post::($post_obj,blk_obj_list)
  set cmd_blk_list $Post::($post_obj,cmd_blk_list)
  set comment_blk_list $Post::($post_obj,comment_blk_list)
  array set word_mom_var_list $Post::($post_obj,word_mom_var)
  set command_list $word_mom_var_list(Command)
  set comment_list $word_mom_var_list(Operator Message)
  set cycle_com_evt [lindex $Post::($post_obj,cyl_com_evt) 0]
  set evt_name_arr $Post::($post_obj,$evt_list_name)
  array set evt_blk_arr $Post::($post_obj,$evt_blk_list_name)
  set com_evt_indx [expr [lsearch $evt_name_arr $cycle_com_evt] - 1]
  set com_evt_blk_list $evt_blk_arr($com_evt_indx)
  foreach com_blk $com_evt_blk_list \
  {
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
    } elseif { [string match "post_*" $com_blk] } \
   {
    set post_blk_list $Post::($post_obj,post_blk_list)
    PB_com_RetObjFrmName com_blk post_blk_list com_blk_obj
   } else \
   {
    PB_com_RetObjFrmName com_blk blk_obj_list com_blk_obj
   }
   if { !$com_blk_obj } { continue }
   block::readvalue $com_blk_obj com_blk_obj_attr
   set com_ret [PB_evt_CheckCycleRefWord com_blk_obj 1]
   if {$com_ret == 0} \
   {
    set new_blk_elem_list ""
    foreach com_blk_elem_obj $com_blk_obj_attr(2) \
    {
     block_element::readvalue $com_blk_elem_obj com_blk_elem_attr
     PB_blk_CreateBlkElemObj com_blk_elem_attr new_elem_obj \
     com_blk_obj_attr
     lappend new_blk_elem_list $new_elem_obj
     set block_element::($new_elem_obj,owner) $cycle_com_evt
     unset com_blk_elem_attr
    }
    set com_blk_obj_attr(2) $new_blk_elem_list
    PB_blk_CreateBlkObj com_blk_obj_attr new_blk_obj
    set block::($new_blk_obj,blk_owner) $cycle_com_evt
    set evt_obj_attr(0) $com_blk
    set evt_obj_attr(1) $new_blk_obj
    PB_evt_CreateEventElement evt_elem_obj evt_obj_attr
    lappend evt_elem_obj_list $evt_elem_obj
    unset evt_obj_attr
   } else \
   {
    foreach blk_name $evt_blk_list\
    {
     set blk_obj 0
     PB_com_RetObjFrmName blk_name blk_obj_list blk_obj
     if { $blk_obj == 0 && [lsearch $comment_list $com_blk] != -1 } \
     {
      PB_com_RetObjFrmName blk_name comment_blk_list blk_obj
      } elseif {$blk_obj == 0 && [lsearch $command_list $com_blk] != -1} \
     {
      set cmd_obj 0
      PB_com_RetObjFrmName blk_name cmd_blk_list cmd_obj
      PB_blk_CreateCmdBlkElem blk_name cmd_obj cmd_blk_elem
      PB_blk_CreateCmdBlkObj blk_name cmd_blk_elem blk_obj
      } elseif { $blk_obj == 0 } \
     {
      continue
     }
     set com_ret [PB_evt_CheckCycleRefWord blk_obj 1]
     PB_evt_SetOwnerShipForBlkElem blk_obj event_name
     set evt_obj_attr(0) $blk_name
     set evt_obj_attr(1) $blk_obj
     PB_evt_CreateEventElement evt_elem_obj evt_obj_attr
     lappend evt_elem_obj_list $evt_elem_obj
     unset evt_obj_attr
    }
   }
   unset com_blk_obj_attr
  }
  if {[info exists evt_elem_obj_list]} \
  {
   set evt_blk_list $evt_elem_obj_list
   unset evt_elem_obj_list
  } else \
  {
   set evt_blk_list ""
  }
 }

#=======================================================================
proc PB_evt_RetEventElements {EVT_BLK_LIST POST_OBJ EVENT_NAME SEQUENCE_NAME} {
  upvar $EVT_BLK_LIST evt_blk_list
  upvar $POST_OBJ post_obj
  upvar $EVENT_NAME event_name
  upvar $SEQUENCE_NAME sequence_name
  set blk_obj_list $Post::($post_obj,blk_obj_list)
  set cmd_blk_list $Post::($post_obj,cmd_blk_list)
  set comment_blk_list $Post::($post_obj,comment_blk_list)
  array set word_mom_var_list $Post::($post_obj,word_mom_var)
  set command_list $word_mom_var_list(Command)
  set comment_list $word_mom_var_list(Operator Message)
  foreach blk_row $evt_blk_list\
  {
   foreach row_elem $blk_row\
   {
    set blk_obj 0
    PB_com_RetObjFrmName row_elem blk_obj_list blk_obj
    if { $blk_obj == 0 && [lsearch $comment_list $row_elem] != -1 } \
    {
     PB_com_RetObjFrmName row_elem comment_blk_list blk_obj
     } elseif {$blk_obj == 0 && [lsearch $command_list $row_elem] != -1} \
    {
     set cmd_obj 0
     PB_com_RetObjFrmName row_elem cmd_blk_list cmd_obj
     PB_blk_CreateCmdBlkElem row_elem cmd_obj cmd_blk_elem
     PB_blk_CreateCmdBlkObj row_elem cmd_blk_elem blk_obj
     } elseif { $blk_obj == 0 } \
    {
     continue
    }
    if {[string compare $sequence_name "tpth_ctrl"] == 0 || \
     [string compare $sequence_name "tpth_mot"] == 0 || \
    [string compare $sequence_name "tpth_cycle"] == 0 } \
    {
     PB_evt_SetOwnerShipForBlkElem blk_obj event_name
    }
    set evt_elem_obj_attr(0) $row_elem
    set evt_elem_obj_attr(1) $blk_obj
    PB_evt_CreateEventElement evt_elem_obj evt_elem_obj_attr
    unset evt_elem_obj_attr
    lappend row_elem_list $evt_elem_obj
   }
   if {[info exists row_elem_list]}\
   {
    lappend row_list $row_elem_list
    unset row_elem_list
   }
  }
  if {[info exists row_list]}\
  {
   set evt_blk_list $row_list
   unset row_list
  } else\
  {
   set evt_blk_list ""
  }
  if {[string compare $event_name "Cycle Parameters"] == 0} \
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
   } elseif { [string compare $event_name "Rapid Move"] == 0} \
  {
   PB_evt_RapidWrkPlaneChange evt_blk_list post_obj
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
    "R"       {
     if { $mom_sys_var(\$cycle_rapto_opt) == "G00_X_Y_&_R" ||
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
     "G17_/_G18_/_G19" } \
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
proc PB_evt_AddRapidTravElems { POST_OBJ BLK_OBJ } {
  upvar $POST_OBJ post_obj
  upvar $BLK_OBJ blk_obj
  set rap_add_list $Post::($post_obj,rap_add_list)
  block::readvalue $blk_obj blk_obj_attr
  set new_blk_elem_list ""
  foreach blk_elem_obj $block::($blk_obj,elem_addr_list) \
  {
   set add_obj $block_element::($blk_elem_obj,elem_add_obj)
   switch $address::($add_obj,add_name) \
   {
    "G_motion" {
     set block_element::($blk_elem_obj,owner) "None"
     lappend new_blk_elem_list $blk_elem_obj
    }
    "X" {
     set add_name "rapid1"
     PB_com_RetObjFrmName add_name rap_add_list rap_add_obj
     block_element::readvalue $blk_elem_obj blk_elem_attr
     set blk_elem_attr(0) $rap_add_obj
     set blk_elem_attr(3) $address::($rap_add_obj,word_desc)
     PB_blk_CreateBlkElemObj blk_elem_attr new_blk_elem blk_obj_attr
     set block_element::($new_blk_elem,owner) "post"
     lappend new_blk_elem_list $new_blk_elem
     delete $blk_elem_obj
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
     delete $blk_elem_obj
    }
    "Z" {
     delete $blk_elem_obj
    }
    default {
     lappend new_blk_elem_list $blk_elem_obj
    }
   }
  }
  set blk_obj_attr(2) $new_blk_elem_list
  set blk_obj_attr(3) "normal"
  block::setvalue $blk_obj blk_obj_attr
  block::DefaultValue $blk_obj blk_obj_attr
 }

#=======================================================================
proc PB_evt_AddRapidSpindleElems { POST_OBJ BLK_OBJ } {
  upvar $POST_OBJ post_obj
  upvar $BLK_OBJ blk_obj
  set rap_add_list $Post::($post_obj,rap_add_list)
  block::readvalue $blk_obj blk_obj_attr
  set new_blk_elem_list ""
  foreach blk_elem_obj $block::($blk_obj,elem_addr_list) \
  {
   set add_obj $block_element::($blk_elem_obj,elem_add_obj)
   switch $address::($add_obj,add_name) \
   {
    "G_motion" {
     set block_element::($blk_elem_obj,owner) "None"
     lappend new_blk_elem_list $blk_elem_obj
    }
    "X" -
    "Y" {
     delete $blk_elem_obj
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
     delete $blk_elem_obj
    }
    default {
     lappend new_blk_elem_list $blk_elem_obj
    }
   }
  }
  set blk_obj_attr(2) $new_blk_elem_list
  set blk_obj_attr(3) "normal"
  block::setvalue $blk_obj blk_obj_attr
  block::DefaultValue $blk_obj blk_obj_attr
 }

#=======================================================================
proc PB_evt_ChangeBlkToPostBlk { POST_OBJ EVENT_NAME BLOCK_OBJ } {
  upvar $POST_OBJ post_obj
  upvar $EVENT_NAME event_name
  upvar $BLOCK_OBJ block_obj
  set blk_obj_list $Post::($post_obj,blk_obj_list)
  set block_name $block::($block_obj,block_name)
  set com_ret [PB_evt_CheckCycleRefWord block_obj 1]
  if { $com_ret } \
  {
   PB_evt_ChangeBlkElemOwner post_obj event_name block_obj
   set block::($block_obj,blk_owner) $event_name
   if { [string match "post_*" $block_name]} \
   {
    set index [lsearch $blk_obj_list $block_obj]
    set blk_obj_list [lreplace $blk_obj_list $index $index]
    set Post::($post_obj,blk_obj_list) $blk_obj_list
   }
   } elseif { [string match "post_*" $block_name]} \
  {
   set block::($block_obj,blk_owner) "post"
   foreach blk_elem_obj $block::($block_obj,elem_addr_list) \
   {
    set block_element::($blk_elem_obj,owner) "post"
   }
   set index [lsearch $blk_obj_list $block_obj]
   set blk_obj_list [lreplace $blk_obj_list $index $index]
   set Post::($post_obj,blk_obj_list) $blk_obj_list
  }
 }

#=======================================================================
proc PB_evt_RapidWrkPlaneChange { EVT_BLK_LIST POST_OBJ } {
  upvar $EVT_BLK_LIST evt_blk_list
  upvar $POST_OBJ post_obj
  array set mom_sys_var $Post::($post_obj,mom_sys_var_list)
  if { !$mom_sys_var(\$rap_wrk_pln_chg) } { return }
  foreach event_row $evt_blk_list \
  {
   foreach evt_elem_obj $event_row \
   {
    set blk_obj $event_element::($evt_elem_obj,block_obj)
    set block_name $block::($blk_obj,block_name)
    if {[string compare $block_name "rapid_traverse"] == 0} \
    {
     PB_evt_AddRapidTravElems post_obj blk_obj
     } elseif { [string compare $block_name "rapid_spindle"] == 0} \
    {
     PB_evt_AddRapidSpindleElems post_obj blk_obj
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
proc PB_evt_CreateRapidToBlock { EVENT_OBJ EVT_ELEM_LIST MOM_SYS_VAR } {
  upvar $EVENT_OBJ event_obj
  upvar $EVT_ELEM_LIST evt_elem_list
  upvar $MOM_SYS_VAR mom_sys_var
  global post_object
  set event_name $event::($event_obj,event_name)
  set post_blk_name "rapidto"
  switch $mom_sys_var(\$cycle_rapto_opt) \
  {
   "None"        {
    set elem_address ""
    set elem_mom_var ""
    set elem_owner ""
    set blk_owner ""
    set add_rep_blk_addr ""
    set add_rep_blk_var ""
    set add_rep_owner ""
   }
   "R"           {
    set elem_address ""
    set elem_mom_var ""
    set elem_owner ""
    set blk_owner ""
    set add_rep_blk_addr [list "R"]
    if { $mom_sys_var(\$cycle_start_blk) } \
    {
     set add_rep_blk_var {"$mom_cycle_rapid_to"}
    } else \
    {
     set add_rep_blk_var {"$mom_cycle_rapid_to_pos($mom_cycle_spindle_axis)"}
    }
    set add_rep_owner {"post"}
   }
   "Rapid_Traverse_&_R" {
    set elem_address {{"G_motion" "X" "Y"}}
    set elem_mom_var {{"$mom_sys_rapid_code" "$mom_cycle_rapid_to_pos(0)" \
    "$mom_cycle_rapid_to_pos(1)"}}
    set elem_owner [list [list "post" "post" "post"]]
    set blk_owner [list $event_name]
    set add_rep_blk_addr {"R"}
    if { $mom_sys_var(\$cycle_start_blk) } \
    {
     set add_rep_blk_var {"$mom_cycle_rapid_to"}
    } else \
    {
     set add_rep_blk_var {"$mom_cycle_rapid_to_pos($mom_cycle_spindle_axis)"}
    }
    set add_rep_owner {"post"}
   }
   "Rapid"   {
    set elem_address {{"G_motion" "X" "Y"} \
    {"G_motion" "Z"}}
    set elem_mom_var {{"$mom_sys_rapid_code" "$mom_cycle_rapid_to_pos(0)" \
     "$mom_cycle_rapid_to_pos(1)"} {"$mom_sys_rapid_code" \
    "$mom_cycle_rapid_to_pos(2)"}}
    set elem_owner [list [list "post" "post" "post"] \
    [list "post" "post"]]
    set blk_owner [list $event_name $event_name]
    set add_rep_blk_addr ""
    set add_rep_blk_var ""
    set add_rep_owner ""
   }
   default       {
    set elem_address ""
    set elem_mom_var ""
    set elem_owner ""
    set blk_owner ""
    set add_rep_blk_addr ""
    set add_rep_blk_var ""
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
    if {$ret == 1} { break }
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
  global post_object
  set event_name $event::($event_obj,event_name)
  set post_blk_name "retracto"
  switch $mom_sys_var(\$cycle_recto_opt) \
  {
   "None"       {
    set elem_address ""
    set elem_mom_var ""
    set elem_owner  ""
    set blk_owner ""
    set add_rep_blk_addr ""
    set add_rep_blk_var ""
    set add_rep_owner ""
   }
   "K"          {
    set elem_address ""
    set elem_mom_var ""
    set elem_owner  ""
    set blk_owner ""
    set add_rep_blk_addr {"K_cycle"}
    if { $mom_sys_var(\$cycle_start_blk) } \
    {
     set add_rep_blk_var {"$mom_cycle_retract_to"}
    } else \
    {
     set add_rep_blk_var {"$mom_cycle_retract_to_pos($mom_cycle_spindle_axis)"}
    }
    set add_rep_owner {"post"}
   }
   "G98/G99"    {
    set elem_address ""
    set elem_mom_var ""
    set elem_owner   ""
    set blk_owner    ""
    set add_rep_blk_addr {"G_return"}
    set add_rep_blk_var {"$mom_sys_cycle_ret_code($mom_cycle_retract_mode)"}
    set add_rep_owner {"post"}
   }
   "Rapid_Spindle"     {
    set elem_address {{"G_motion" "Z"}}
    set elem_mom_var {{"$mom_sys_rapid_code" "$mom_cycle_retract_to_pos(2)"}}
    set elem_owner  [list [list "post" "post"]]
    set blk_owner [list $event_name]
    set add_rep_blk_addr ""
    set add_rep_blk_var ""
    set add_rep_owner ""
   }
   "Cycle_Off_then_Rapid_Spindle"  {
    set elem_address {{"G_motion"} \
    {"G_motion" "Z"}}
    set elem_mom_var {{"$mom_sys_cycle_off"} \
    {"$mom_sys_rapid_code" "$mom_cycle_retract_to_pos(2)"}}
    set elem_owner  [list [list "post"] \
    [list "post" "post"]]
    set blk_owner [list "post" $event_name]
    set add_rep_blk_addr ""
    set add_rep_blk_var ""
    set add_rep_owner ""
   }
   default              {
    set elem_address ""
    set elem_mom_var ""
    set elem_owner ""
    set blk_owner ""
    set add_rep_blk_addr ""
    set add_rep_blk_var ""
    set add_rep_owner ""
   }
  }
  set new_elem_list ""
  PB_evt_CreatePostBlock blk_owner post_blk_name elem_address elem_mom_var \
  elem_owner new_elem_list
  set act_evt_elem_list ""
  if { $mom_sys_var(\$cycle_start_blk) == 0} \
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
    if { [string compare $block_name "post_startblk"] == 0} \
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
  global post_object
  set post_blk_name "startblk"
  switch $mom_sys_var(\$cycle_start_blk) \
  {
   0   {
    set elem_address ""
    set elem_mom_var ""
    set elem_owner ""
    set blk_owner ""
    set z_var "\$mom_cycle_feed_to_pos(2)"
    set r_var "\$mom_cycle_rapid_to_pos(\$mom_cycle_spindle_axis)"
    set k_var "\$mom_cycle_retract_to_pos(\$mom_cycle_spindle_axis)"
   }
   1   {
    set elem_address {{"G_motion" "X" "Y" "Z"}}
    set elem_mom_var {{"$mom_sys_cycle_start_code" \
     "$mom_pos(0)" \
     "$mom_pos(1)" \
    "$mom_pos(2)"}}
    set elem_owner {{"post" "post" "post" "post"}}
    set blk_owner [list "post"]
    set z_var "\$mom_cycle_feed_to"
    set r_var "\$mom_cycle_rapid_to"
    set k_var "\$mom_cycle_retract_to"
   }
  }
  set event_name "post"
  PB_evt_CreatePostBlock blk_owner post_blk_name elem_address \
  elem_mom_var elem_owner new_elem_list
  foreach cyc_set_elem $evt_elem_list \
  {
   set block_obj $event_element::($cyc_set_elem,block_obj)
   set com_ret [PB_evt_CheckCycleRefWord block_obj 1]
   if { $com_ret } {break}
  }
  set set_indx [lsearch $evt_elem_list $cyc_set_elem]
  set evt_elem_list [lreplace $evt_elem_list $set_indx $set_indx]
  if { $mom_sys_var(\$cycle_start_blk) } \
  {
   set evt_elem_list [linsert $evt_elem_list $set_indx $new_elem_list]
   set evt_elem_list [linsert $evt_elem_list $strt_blk_indx $cyc_set_elem]
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
      }
      "R" {
       set block_element::($blk_elem_obj,elem_mom_variable) $r_var
      }
      "K_cycle" {
       set block_element::($blk_elem_obj,elem_mom_variable) $k_var
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
  global post_object
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
proc PB_evt_SetOwnerShipForBlkElem {BLK_OBJ EVENT_NAME} {
  upvar $BLK_OBJ blk_obj
  upvar $EVENT_NAME event_name
  global post_object
  set common_evt [lindex $Post::($post_object,cyl_com_evt) 0]
  set shared_evt_list [lindex $Post::($post_object,cyl_evt_sh_com_evt) 0]
  set cmd_blk_list $Post::($post_object,cmd_blk_list)
  set comment_blk_list $Post::($post_object,comment_blk_list)
  array set word_mom_var_list $Post::($post_object,word_mom_var)
  set command_list $word_mom_var_list(Command)
  set comment_list $word_mom_var_list(Operator Message)
  set blk_elem_obj_list $block::($blk_obj,elem_addr_list)
  set block::($blk_obj,blk_owner) $event_name
  if {[lsearch $shared_evt_list $event_name] != -1} \
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
     } elseif { [string match "post_*" $com_evt_blk] } \
    {
     set post_blk_list $Post::($post_object,post_blk_list)
     PB_com_RetObjFrmName com_evt_blk post_blk_list com_blk_obj
    } else \
    {
     PB_com_RetObjFrmName com_evt_blk blk_obj_list com_blk_obj
    }
    set com_ret [PB_evt_CheckCycleRefWord com_blk_obj 1]
    if {$com_ret == 1} {break}
   }
   set blk_ret [PB_evt_CheckCycleRefWord blk_obj 1]
   if {$blk_ret == 1 && $com_blk_obj != 0} \
   {
    foreach blk_elem $blk_elem_obj_list\
    {
     set ret [PB_evt_CheckElemInBlock com_blk_obj blk_elem]
     if {$ret == 1} \
     {
      set block_element::($blk_elem,owner) $common_evt
     } else \
     {
      if {[string match "\$mom_sys_cycle*" \
      $block_element::($blk_elem,elem_mom_variable)]}\
      {
       set block_element::($blk_elem,owner) "post"
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
    if {[string compare $block_element::($blk_elem,elem_mom_variable) \
    "\$mom_sys_cycle_reps_code"] == 0} \
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
