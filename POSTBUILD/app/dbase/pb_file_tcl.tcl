
#=======================================================================
proc PB_int_CreateNewFormat { FMT_NAME FMT_OBJ } {
  upvar $FMT_NAME fmt_name
  upvar $FMT_OBJ fmt_obj
  global post_object
  set obj_attr(0) $fmt_name
  set obj_attr(1) "Text String"
  set obj_attr(2) 0
  set obj_attr(3) 0
  set obj_attr(4) 0
  set obj_attr(5) 0
  set obj_attr(6) 0
  set obj_attr(7) 0
  PB_fmt_RetFormatObjs fmt_obj_list
  set obj_index [expr [llength $fmt_obj_list] - 1]
  PB_fmt_GetFmtNameList fmt_obj_list fmt_name_list
  PB_com_SetDefaultName fmt_name_list obj_attr
  PB_fmt_CreateNewFmtObj fmt_obj_list obj_attr obj_index
  set Post::($post_object,fmt_obj_list) $fmt_obj_list
  set fmt_obj [lindex $fmt_obj_list $obj_index]
  set fmt_name $obj_attr(0)
 }

#=======================================================================
proc PB_int_FormatCreateObject { ACT_FMT_OBJ FormatObjAttr OBJ_INDEX} {
  upvar $ACT_FMT_OBJ act_fmt_obj
  upvar $FormatObjAttr obj_attr
  upvar $OBJ_INDEX obj_index
  global post_object
  PB_fmt_RetFormatObjs fmt_obj_list
  set obj_index [lsearch $fmt_obj_list $act_fmt_obj]
  PB_fmt_GetFmtNameList fmt_obj_list fmt_name_list
  PB_com_SetDefaultName fmt_name_list obj_attr
  PB_fmt_CreateNewFmtObj fmt_obj_list obj_attr obj_index
  set Post::($post_object,fmt_obj_list) $fmt_obj_list
 }

#=======================================================================
proc PB_int_BlockCreateObject { ACT_BLK_OBJ } {
  upvar $ACT_BLK_OBJ act_blk_obj
  global post_object
  set blk_obj_list $Post::($post_object,blk_obj_list)
  set obj_index [lsearch $blk_obj_list $act_blk_obj]
  if {$obj_index == -1}\
  {
   set obj_index 0
  } else\
  {
   incr obj_index
  }
  PB_blk_CreateBlkFromBlkObj blk_obj_list act_blk_obj obj_index
  set Post::($post_object,blk_obj_list) $blk_obj_list
 }

#=======================================================================
proc PB_int_CreateCmdObj { ACT_CMD_OBJ OBJ_INDEX } {
  upvar $ACT_CMD_OBJ act_cmd_obj
  upvar $OBJ_INDEX obj_index
  global post_object
  set cmd_blk_list $Post::($post_object,cmd_blk_list)
  if { $act_cmd_obj } \
  {
   set obj_index [lsearch $cmd_blk_list $act_cmd_obj]
   if {$obj_index == ""}\
   {
    set obj_index 0
   } else\
   {
    incr obj_index
   }
   PB_pps_CreateCmdFromCmdObj cmd_blk_list act_cmd_obj obj_index
   set cmd_obj [lindex $cmd_blk_list $obj_index]
   PB_int_UpdateCommandAdd cmd_obj
  } else \
  {
   set cmd_obj_attr(0) "PB_CMD_custom_command"
   set cmd_obj_attr(1) ""
   PB_pps_CreateCommand cmd_obj_attr cmd_obj
   if 0 {{
    lappend cmd_blk_list $cmd_obj
    set Post::($post_object,cmd_blk_list) $cmd_blk_list
   }}
   PB_int_UpdateCommandAdd cmd_obj
   set obj_index 0
  }
 }

#=======================================================================
proc PB_int_CreateCopyABlock { BLOCK_OBJ NEW_BLK_OBJ } {
  upvar $BLOCK_OBJ block_obj
  upvar $NEW_BLK_OBJ new_blk_obj
  global post_object
  set blk_obj_list $Post::($post_object,blk_obj_list)
  set obj_index [lsearch $blk_obj_list $block_obj]
  incr obj_index
  PB_blk_CreateBlkFromBlkObj blk_obj_list block_obj obj_index
  set new_blk_obj [lindex $blk_obj_list $obj_index]
  set Post::($post_object,blk_obj_list) $blk_obj_list
 }

#=======================================================================
proc PB_int_CreateCopyACmdBlk { CMD_OBJ NEW_BLK_OBJ } {
  upvar $CMD_OBJ cmd_obj
  upvar $NEW_BLK_OBJ new_blk_obj
  global post_object
  set cmd_blk_list $Post::($post_object,cmd_blk_list)
  set obj_index [lsearch $cmd_blk_list $cmd_obj]
  if {$obj_index == ""}\
  {
   set obj_index 0
  } else\
  {
   incr obj_index
  }
  PB_pps_CreateCmdFromCmdObj cmd_blk_list cmd_obj obj_index
  set new_cmd_obj [lindex $cmd_blk_list $obj_index]
  PB_int_CreateCmdBlkFromCmd new_cmd_obj new_blk_obj
  PB_int_UpdateCommandAdd new_cmd_obj
 }

#=======================================================================
proc PB_int_CreateCmdBlkFromCmd { CMD_OBJ NEW_BLK_OBJ } {
  upvar $CMD_OBJ cmd_obj
  upvar $NEW_BLK_OBJ new_blk_obj
  if { [string match "*MOM_*" $cmd_obj] } \
  {
   set cmd_elem_name $cmd_obj
   set act_cmd_obj 0
  } else \
  {
   set cmd_elem_name $command::($cmd_obj,name)
   set act_cmd_obj $cmd_obj
  }
  PB_blk_CreateCmdBlkElem cmd_elem_name act_cmd_obj cmd_blk_elem
  PB_blk_CreateCmdBlkObj cmd_elem_name cmd_blk_elem new_blk_obj
 }

#=======================================================================
proc PB_int_CreateNewEventElement { BLOCK_OBJ EVT_ELEM_OBJ } {
  upvar $BLOCK_OBJ block_obj
  upvar $EVT_ELEM_OBJ evt_elem_obj
  set elem_obj_attr(0) $block::($block_obj,block_name)
  set elem_obj_attr(1) $block_obj
  PB_evt_CreateEventElement evt_elem_obj elem_obj_attr
  unset elem_obj_attr
 }

#=======================================================================
proc PB_int_CreateNewBlock { BLOCK_NAME BLK_ELEM_LIST BLK_OWNER \
  BLK_OBJ BLK_TYPE } {
  upvar $BLOCK_NAME block_name
  upvar $BLK_ELEM_LIST blk_elem_list
  upvar $BLK_OWNER blk_owner
  upvar $BLK_OBJ blk_obj
  upvar $BLK_TYPE blk_type
  global post_object
  set blk_obj_attr(0) $block_name
  set blk_obj_attr(1) [llength $blk_elem_list]
  set blk_obj_attr(2) $blk_elem_list
  set blk_obj_attr(3) $blk_type
  PB_blk_CreateBlkObj blk_obj_attr blk_obj
  unset blk_obj_attr
  set block::($blk_obj,blk_owner) $blk_owner
  lappend Post::($post_object,blk_obj_list) $blk_obj
 }

#=======================================================================
proc PB_int_CreateCmdBlock { CMD_BLK_NAME CMD_BLK_ELEM CMD_BLK_OBJ } {
  upvar $CMD_BLK_NAME cmd_blk_name
  upvar $CMD_BLK_ELEM cmd_blk_elem
  upvar $CMD_BLK_OBJ cmd_blk_obj
  PB_blk_CreateCmdBlkObj cmd_blk_name cmd_blk_elem cmd_blk_obj
 }

#=======================================================================
proc PB_int_RetCmdBlks { CMD_BLK_LIST } {
  upvar $CMD_BLK_LIST cmd_blk_list
  global post_object
  set cmd_blk_list $Post::($post_object,cmd_blk_list)
 }

#=======================================================================
proc PB_int_CheckForCmdBlk { CMD_BLK_OBJ CMD_BLK_NAME } {
  upvar $CMD_BLK_OBJ cmd_blk_obj
  upvar $CMD_BLK_NAME cmd_blk_name
  global post_object
  set temp_list [split $cmd_blk_name _]
  set temp_name [join [lrange $temp_list 2 [llength $temp_list]] _]
  set temp_name [string trim $temp_name " "]
  if { $temp_name == "" } \
  {
   return 2
  }
  set cmd_blk_list $Post::($post_object,cmd_blk_list)
  if { $cmd_blk_obj } \
  {
   set index [lsearch $cmd_blk_list $cmd_blk_obj]
   set cmd_blk_list [lreplace $cmd_blk_list $index $index]
  }
  set ret_code 0
  PB_com_RetObjFrmName cmd_blk_name cmd_blk_list ret_code
  if { $ret_code == 0 } { 
   return 0
   } else { 
   return 1
  }
 }

#=======================================================================
proc PB_int_AddBlkObjToList { BLOCK_OBJ } {
  upvar $BLOCK_OBJ block_obj
  global post_object
  set index [lsearch $Post::($post_object,blk_obj_list) $block_obj]
  if {$index == -1} \
  {
   set blk_obj_list $Post::($post_object,blk_obj_list)
   lappend blk_obj_list $block_obj
   set Post::($post_object,blk_obj_list) $blk_obj_list
  }
 }

#=======================================================================
proc PB_int_RemoveBlkObjFrmList { BLOCK_OBJ } {
  upvar $BLOCK_OBJ block_obj
  global post_object
  set index [lsearch $Post::($post_object,blk_obj_list) $block_obj]
  if {$index != -1} \
  {
   set Post::($post_object,blk_obj_list) \
   [lreplace $Post::($post_object,blk_obj_list) $index $index]
  } else \
  {
   set index [lsearch $Post::($post_object,post_blk_list) $block_obj]
   if {$index != -1} \
   {
    set Post::($post_object,post_blk_list) \
    [lreplace $Post::($post_object,post_blk_list) $index $index]
   }
  }
 }

#=======================================================================
proc PB_int_GetAllBlockNames { BLK_OBJ_LIST BLOCK_NAME_LIST } {
  upvar $BLK_OBJ_LIST blk_obj_list
  upvar $BLOCK_NAME_LIST block_name_list
  global post_object
  PB_blk_GetBlockNames blk_obj_list block_name_list
 }

#=======================================================================
proc PB_int_DisplayFormatValue {FMT_NAME ADD_NAME INP_VALUE DIS_VALUE} {
  upvar $FMT_NAME fmt_name
  upvar $ADD_NAME add_name
  upvar $INP_VALUE inp_value
  upvar $DIS_VALUE dis_value
  global post_object
  array set mom_sys_var_arr $Post::($post_object,mom_sys_var_list)
  set add_obj_list $Post::($post_object,add_obj_list)
  PB_com_RetObjFrmName add_name add_obj_list add_obj
  set add_rep_mom_var $address::($add_obj,rep_mom_var)
  PB_com_MapMOMVariable mom_sys_var_arr add_obj add_rep_mom_var app_text
  set fmt_obj_list $Post::($post_object,fmt_obj_list)
  PB_com_RetObjFrmName fmt_name fmt_obj_list fmt_obj
  format::readvalue $fmt_obj for_obj_attr
  PB_int_ReturnInputValue app_text for_obj_attr(1) inp_value
  PB_fmt_RetFmtOptVal for_obj_attr inp_value dis_value
 }

#=======================================================================
proc PB_int_ApplyFormatAppText { ADD_OBJ APP_TEXT } {
  upvar $ADD_OBJ add_obj
  upvar $APP_TEXT app_text
  global post_object
  if {[string length $app_text] > 0 && \
  [tixGetInt -nocomplain $app_text] != 0 || $app_text == 0} \
  {
   set fmt_obj $address::($add_obj,add_format)
   format::readvalue $fmt_obj fmt_obj_attr
   PB_fmt_RetFmtOptVal fmt_obj_attr app_text dis_value
   set app_text $dis_value
  }
 }

#=======================================================================
proc PB_int_FormatCutObject { ACTIVE_FMT_OBJ OBJ_INDEX } {
  upvar $ACTIVE_FMT_OBJ active_fmt_obj
  upvar $OBJ_INDEX obj_index
  global post_object
  set fmt_obj_list $Post::($post_object,fmt_obj_list)
  set fmt_obj [lindex $fmt_obj_list $obj_index]
  delete $fmt_obj
  set fmt_obj_list [lreplace $fmt_obj_list $obj_index $obj_index]
  set Post::($post_object,fmt_obj_list) $fmt_obj_list
  if { $obj_index == [llength $fmt_obj_list]} \
  {
   incr obj_index -1
  }
 }

#=======================================================================
proc PB_int_BlockCutObject { ACTIVE_BLK_OBJ } {
  upvar $ACTIVE_BLK_OBJ active_blk_obj
  global post_object
  set blk_obj_list $Post::($post_object,blk_obj_list)
  set obj_index [lsearch $blk_obj_list $active_blk_obj]
  foreach blk_elem_obj $block::($active_blk_obj,elem_addr_list) \
  {
   set add_obj $block_element::($blk_elem_obj,elem_add_obj)
   address::DeleteFromBlkElemList $add_obj blk_elem_obj
  }
  set blk_obj_list [lreplace $blk_obj_list $obj_index $obj_index]
  set Post::($post_object,blk_obj_list) $blk_obj_list
 }

#=======================================================================
proc PB_int_CommandCutObject { ACTIVE_CMD_OBJ OBJ_INDEX } {
  upvar $ACTIVE_CMD_OBJ active_cmd_obj
  upvar $OBJ_INDEX obj_index
  global post_object
  PB_int_RemoveCmdProcFromlist active_cmd_obj
  set cmd_blk_list $Post::($post_object,cmd_blk_list)
  set cmd_blk_list [lreplace $cmd_blk_list $obj_index $obj_index]
  set Post::($post_object,cmd_blk_list) $cmd_blk_list
  if { $obj_index == [llength $cmd_blk_list]} \
  {
   incr obj_index -1
  }
 }

#=======================================================================
proc PB_int_RemoveCmdProcFromlist { CMD_OBJ } {
  upvar $CMD_OBJ cmd_obj
  global post_object
  set cmd_blk_list $Post::($post_object,cmd_blk_list)
  set obj_index [lsearch $cmd_blk_list $cmd_obj]
  set cmd_name $command::($cmd_obj,name)
  set word "Command"
  PB_int_RetMOMVarAsscAddress word cmd_proc_list
  PB_int_RetMOMVarDescAddress word cmd_proc_desc_list
  set act_index [lsearch $cmd_proc_list $cmd_name]
  if { $act_index != -1 } \
  {
   set cmd_proc_list [lreplace $cmd_proc_list $act_index $act_index]
   set cmd_proc_desc_list [lreplace $cmd_proc_desc_list $act_index $act_index]
  }
  PB_int_UpdateMOMVarDescAddress word cmd_proc_desc_list
  PB_int_UpdateMOMVarOfAddress word cmd_proc_list
 }

#=======================================================================
proc PB_int_CmdBlockPasteObject { BUFF_CMD_OBJ OBJ_INDEX } {
  upvar $BUFF_CMD_OBJ buff_cmd_obj
  upvar $OBJ_INDEX obj_index
  global post_object
  set cmd_blk_list $Post::($post_object,cmd_blk_list)
  set count [llength $cmd_blk_list]
  if { $count } \
  {
   set cmd_name $command::($buff_cmd_obj,name)
   PB_com_RetObjFrmName cmd_name cmd_blk_list ret_code
   if {$ret_code}\
   {
    return [tk_messageBox -type ok -icon error\
    -message "Object Name Exists...Paste Invalid"]
   }
  }
  if {$obj_index == ""}\
  {
   set obj_index 0
  } else\
  {
   incr obj_index
  }
  PB_pps_CreateCmdFromCmdObj cmd_blk_list buff_cmd_obj obj_index
  set new_cmd_blk [lindex $cmd_blk_list $obj_index]
  PB_int_UpdateCommandAdd new_cmd_blk
  delete $buff_cmd_obj
  set buff_cmd_obj $new_cmd_blk
 }

#=======================================================================
proc PB_int_UpdateCommandAdd { CMD_OBJ } {
  upvar $CMD_OBJ cmd_obj
  global post_object
  set cmd_blk_list $Post::($post_object,cmd_blk_list)
  set obj_index [lsearch $cmd_blk_list $cmd_obj]
  set word "Command"
  set act_index [expr $obj_index + 3]
  PB_int_RetMOMVarAsscAddress word cmd_proc_list
  set proc_name $command::($cmd_obj,name)
  if { [lsearch $cmd_proc_list "$proc_name"] < 0 } {
   set cmd_proc_list [linsert $cmd_proc_list $act_index $proc_name]
   PB_int_RetMOMVarDescAddress word cmd_proc_desc_list
   set cmd_proc_desc_list [linsert $cmd_proc_desc_list $act_index \
   "Custom Command"]
   PB_int_UpdateMOMVarDescAddress word cmd_proc_desc_list
   PB_int_UpdateMOMVarOfAddress word cmd_proc_list
  }
 }

#=======================================================================
proc PB_int_BlockPasteObject { BUFF_BLK_OBJ ACTIVE_BLK_OBJ } {
  upvar $BUFF_BLK_OBJ buff_blk_obj
  upvar $ACTIVE_BLK_OBJ active_blk_obj
  global post_object
  set blk_obj_list $Post::($post_object,blk_obj_list)
  set count [llength $blk_obj_list]
  if { $count } \
  {
   set block_name $block::($buff_blk_obj,block_name)
   PB_com_RetObjFrmName block_name blk_obj_list ret_code
   if {$ret_code}\
   {
    return [tk_messageBox -type ok -icon error\
    -message "Object Name Exists...Paste Invalid"]
   }
  }
  set obj_index [lsearch $blk_obj_list $active_blk_obj]
  if {$obj_index == -1}\
  {
   set obj_index 0
  } else\
  {
   incr obj_index
  }
  PB_blk_CreateBlkFromBlkObj blk_obj_list buff_blk_obj obj_index
  set Post::($post_object,blk_obj_list) $blk_obj_list
  delete $buff_blk_obj
 }

#=======================================================================
proc PB_int_FormatPasteObject { BUFF_OBJ_ATTR OBJ_INDEX } {
  upvar $BUFF_OBJ_ATTR buff_obj_attr
  upvar $OBJ_INDEX obj_index
  global paOption
  global post_object
  set fmt_obj_list $Post::($post_object,fmt_obj_list)
  set count [llength $fmt_obj_list]
  if { $count }\
  {
   PB_com_RetObjFrmName buff_obj_attr(0) fmt_obj_list ret_code
   if {$ret_code}\
   {
    return [tk_messageBox -type ok -icon error\
    -message "Object Name Exists...Paste Invalid"]
   }
  }
  PB_fmt_PasteFmtBuffObj fmt_obj_list buff_obj_attr obj_index
  set Post::($post_object,fmt_obj_list) $fmt_obj_list
 }

#=======================================================================
proc PB_int_AddrSummaryAttr { ADD_NAME_LIST ADD_APP_TEXT ADD_DESC_ARR } {
  upvar $ADD_NAME_LIST add_name_list
  upvar $ADD_APP_TEXT add_app_text
  upvar $ADD_DESC_ARR add_desc_arr
  global post_object
  array set mom_sys_var_arr $Post::($post_object,mom_sys_var_list)
  set add_obj_list $Post::($post_object,add_obj_list)
  set index 0
  set add_name_list ""
  foreach add_obj $add_obj_list \
  {
   address::readvalue $add_obj add_obj_attr
   set add_name $add_obj_attr(0)
   lappend add_name_list $add_name
   set add_rep_mom_var $address::($add_obj,rep_mom_var)
   PB_com_MapMOMVariable mom_sys_var_arr add_obj add_rep_mom_var app_text
   PB_int_GetElemDisplayAttr add_name app_text dis_attr
   set add_app_text($add_name) $dis_attr(1)
   set add_desc_arr($index) $address::($add_obj,word_desc)
   incr index
  }
 }

#=======================================================================
proc PB_int_RetDefKinVars { DEF_MOM_KIN_VAR } {
  upvar $DEF_MOM_KIN_VAR def_mom_kin_var
  global post_object
  array set def_mom_kin_var $Post::($post_object,def_mom_kin_var_list)
 }

#=======================================================================
proc PB_int_RetDefAddrFmtArrys { DEF_GPB_FMT_VAR DEF_GPB_ADDR_VAR } {
  upvar $DEF_GPB_FMT_VAR def_gpb_fmt_var
  upvar $DEF_GPB_ADDR_VAR def_gpb_addr_var
  global post_object
  array set def_gpb_fmt_var $Post::($post_object,def_gpb_fmt_var)
  array set def_gpb_addr_var $Post::($post_object,def_gpb_addr_var)
 }

#=======================================================================
proc PB_int_DefineUIGlobVar { } {
  global post_object
  global gpb_fmt_var
  global gpb_addr_var
  global mom_sys_arr
  global mom_kin_var
  global machType 
  global axisoption
  set add_obj_list $Post::($post_object,add_obj_list)
  foreach add_obj $add_obj_list \
  {
   address::readvalue $add_obj add_obj_attr
   set add_name $add_obj_attr(0)
   UI_PB_debug_DisplayMsg "Address : $add_name"
   set addr_fmt_obj $add_obj_attr(1)
   set addr_fmt_name $format::($addr_fmt_obj,for_name)
   UI_PB_debug_DisplayMsg "Format  : $addr_fmt_name"
   set gpb_addr_var($add_name,name) $add_obj_attr(0)
   set gpb_addr_var($add_name,fmt_name) $addr_fmt_name
   set gpb_addr_var($add_name,modal) $add_obj_attr(2)
   set gpb_addr_var($add_name,modl_status) $add_obj_attr(3)
   set gpb_addr_var($add_name,add_max) $add_obj_attr(4)
   set gpb_addr_var($add_name,max_status) $add_obj_attr(5)
   set gpb_addr_var($add_name,add_min)   $add_obj_attr(6)
   set gpb_addr_var($add_name,min_status) $add_obj_attr(7)
   set gpb_addr_var($add_name,leader_name) $add_obj_attr(8)
   set gpb_addr_var($add_name,trailer) $add_obj_attr(9)
   set gpb_addr_var($add_name,trail_status) $add_obj_attr(10)
   set gpb_addr_var($add_name,incremental) $add_obj_attr(11)
   set gpb_addr_var($add_name,zero_format) $add_obj_attr(12)
   unset add_obj_attr
  }
  set fmt_obj_list $Post::($post_object,fmt_obj_list)
  foreach fmt_obj $fmt_obj_list \
  {
   format::readvalue $fmt_obj fmt_obj_attr
   set fmt_name $fmt_obj_attr(0)
   set gpb_fmt_var($fmt_name,name) $fmt_obj_attr(0)
   set gpb_fmt_var($fmt_name,dtype) $fmt_obj_attr(1)
   set gpb_fmt_var($fmt_name,plus_status) $fmt_obj_attr(2)
   set gpb_fmt_var($fmt_name,lead_zero) $fmt_obj_attr(3)
   set gpb_fmt_var($fmt_name,trailzero) $fmt_obj_attr(4)
   set gpb_fmt_var($fmt_name,integer)  $fmt_obj_attr(5)
   set gpb_fmt_var($fmt_name,decimal) $fmt_obj_attr(6)
   set gpb_fmt_var($fmt_name,fraction) $fmt_obj_attr(7)
   unset fmt_obj_attr
  }
  set Post::($post_object,def_gpb_fmt_var) [array get gpb_fmt_var]
  set Post::($post_object,def_gpb_addr_var) [array get gpb_addr_var]
  array set mom_sys_arr $Post::($post_object,mom_sys_var_list)
  array set seq_params $Post::($post_object,sequence_param)
  set mom_sys_arr(seqnum_block) $seq_params(block)
  set mom_sys_arr(seqnum_start) $seq_params(start)
  set mom_sys_arr(seqnum_incr)  $seq_params(increment)
  set mom_sys_arr(seqnum_freq)  $seq_params(frequency)
  set mom_sys_arr(Word_Seperator) $Post::($post_object,word_sep)
  set mom_sys_arr(End_of_Block) $Post::($post_object,end_of_line)
  set Post::($post_object,mom_sys_var_list)     [array get mom_sys_arr]
  set Post::($post_object,def_mom_sys_var_list) [array get mom_sys_arr]
  PB_mthd_RetMachineToolAttr mom_kin_var
  PB_com_GetMachAxisType mom_kin_var machType axisoption
 }

#=======================================================================
proc PB_int_GCodePageAttributes { G_CODES_DESC G_CODES_VAR } {
  upvar $G_CODES_DESC g_codes_desc
  upvar $G_CODES_VAR g_codes_var
  global post_object
  array set g_codes_mom_var $Post::($post_object,g_codes)
  array set g_codes_desc $Post::($post_object,g_codes_desc)
  array set mom_sys_var_arr $Post::($post_object,mom_sys_var_list)
  set arr_size [array size g_codes_mom_var]
  for {set count 0} {$count < $arr_size} {incr count}\
  {
   set g_codes_var($count) $g_codes_mom_var($count)
  }
 }

#=======================================================================
proc PB_int_MCodePageAttributes { M_CODES_DESC M_CODES_VAR } {
  upvar $M_CODES_DESC m_codes_desc
  upvar $M_CODES_VAR m_codes_var
  global post_object
  array set m_codes_mom_var $Post::($post_object,m_codes)
  array set m_codes_desc $Post::($post_object,m_codes_desc)
  set arr_size [array size m_codes_mom_var]
  for {set count 0} {$count < $arr_size} {incr count}\
  {
   set m_codes_var($count) $m_codes_mom_var($count)
  }
 }

#=======================================================================
proc PB_int_AddApplyObject { ADDR_OBJ ADDR_OBJ_ATTR } {
  upvar $ADDR_OBJ addr_obj
  upvar $ADDR_OBJ_ATTR addr_obj_attr
  global post_object
  set add_obj_list $Post::($post_object,add_obj_list)
  set fmt_obj_list $Post::($post_object,fmt_obj_list)
  PB_adr_ApplyAdrObj add_obj_list fmt_obj_list addr_obj_attr addr_obj
 }

#=======================================================================
proc PB_int_AddCreateObject { ACT_ADDR_OBJ OBJ_ATTR OBJ_INDEX } {
  upvar $ACT_ADDR_OBJ act_addr_obj
  upvar $OBJ_ATTR obj_attr
  upvar $OBJ_INDEX obj_index
  global post_object
  array set word_mom_var_arr $Post::($post_object,word_mom_var)
  array set word_desc_arr $Post::($post_object,word_desc_array)
  PB_adr_RetAddressObjList add_obj_list
  set obj_index [lsearch $add_obj_list $act_addr_obj]
  PB_adr_GetAddressNameList add_obj_list add_name_list
  set prev_add_name $obj_attr(0)
  PB_com_SetDefaultName add_name_list obj_attr
  PB_adr_CreateNewAdrObj add_obj_list obj_attr obj_index
  set word_mom_var_arr($obj_attr(0)) $word_mom_var_arr($prev_add_name)
  set word_desc_arr($obj_attr(0)) $word_desc_arr($prev_add_name)
  set Post::($post_object,add_obj_list) $add_obj_list
  set Post::($post_object,word_mom_var) [array get word_mom_var_arr]
  set Post::($post_object,word_desc_array) [array get word_desc_arr]
 }

#=======================================================================
proc PB_int_ChangeAddrNameOfParam { ADD_OBJ WORD_NEW_NAME } {
  upvar $ADD_OBJ add_obj
  upvar $WORD_NEW_NAME word_new_name
  global post_object
  array set word_mom_var_arr $Post::($post_object,word_mom_var)
  array set word_desc_arr $Post::($post_object,word_desc_array)
  set prev_add_name $address::($add_obj,add_name)
  set word_mom_var_arr($word_new_name) $word_mom_var_arr($prev_add_name)
  set word_desc_arr($word_new_name) $word_desc_arr($prev_add_name)
  unset word_mom_var_arr($prev_add_name)
  unset word_desc_arr($prev_add_name)
  set Post::($post_object,word_mom_var) [array get word_mom_var_arr]
  set Post::($post_object,word_desc_array) [array get word_desc_arr]
 }

#=======================================================================
proc PB_int_CreateMseqAddObj { ADD_OBJ } {
  upvar $ADD_OBJ add_obj
  PB_adr_InitAdrObj add_obj_attr
  set add_obj_attr(0) "mseq_dummy"
  set add_obj [new address]
  address::setvalue $add_obj add_obj_attr
  address::DefaultValue $add_obj add_obj_attr
 }

#=======================================================================
proc PB_int_CreateNewAddress { ADD_NAME ADD_OBJ ADD_INDEX } {
  upvar $ADD_NAME add_name
  upvar $ADD_OBJ add_obj
  upvar $ADD_INDEX add_index
  global post_object
  PB_adr_InitAdrObj add_obj_attr
  set add_obj_attr(0) $add_name
  PB_adr_RetAddressObjList add_obj_list
  PB_adr_GetAddressNameList add_obj_list add_name_list
  PB_com_SetDefaultName add_name_list add_obj_attr
  PB_fmt_RetFormatObjs fmt_obj_list
  set fmt_obj [lindex $fmt_obj_list 0]
  set add_obj_attr(1) $fmt_obj
  PB_adr_CreateAdrObj add_obj_attr add_obj
  set mseq_attr(0) "\$mom_usd_add_var"
  set mseq_attr(1) 0
  global gPB
  set mseq_attr(2) "$gPB(block,new,word_desc,Label)"
  set mseq_attr(3) $add_index
  set mseq_attr(4) 1
  address::SetMseqAttr $add_obj mseq_attr
  address::DefaultMseqAttr $add_obj mseq_attr
  set add_obj_list [linsert $add_obj_list $add_index $add_obj]
  set length [llength $add_obj_list]
  for { set count [expr $add_index + 1] } { $count < $length } \
  { incr count } \
  {
   set elem_obj [lindex $add_obj_list $count]
   set address::($elem_obj,seq_no) $count
  }
  set Post::($post_object,add_obj_list) $add_obj_list
  set add_name $add_obj_attr(0)
 }

#=======================================================================
proc PB_int_UpdateAddVariablesAttr { WORD_DESC_ARR BASE_ADDR } {
  upvar $WORD_DESC_ARR word_desc_arr
  upvar $BASE_ADDR base_addr
  global post_object
  array set word_mom_var_list $Post::($post_object,word_mom_var)
  set word_mom_var_list($base_addr) ""
  set Post::($post_object,word_mom_var) [array get word_mom_var_list]
  set Post::($post_object,word_desc_array) [array get word_desc_arr]
 }

#=======================================================================
proc PB_int_AddCutObject { ACTIVE_ADD_OBJ OBJ_INDEX ADD_MOM_VAR \
  ADD_VAR_DESC ADD_MSEQ_ATTR } {
  upvar $ACTIVE_ADD_OBJ active_add_obj
  upvar $OBJ_INDEX obj_index
  upvar $ADD_MOM_VAR add_mom_var
  upvar $ADD_VAR_DESC add_var_desc
  upvar $ADD_MSEQ_ATTR add_mseq_attr
  global post_object
  array set word_mom_var_arr $Post::($post_object,word_mom_var)
  array set word_desc_arr $Post::($post_object,word_desc_array)
  set add_name $address::($active_add_obj,add_name)
  address::readMseqAttr $active_add_obj add_mseq_attr
  PB_int_RemoveAddObjFromList active_add_obj
  set add_mom_var $word_mom_var_arr($add_name)
  set add_var_desc $word_desc_arr($add_name)
  unset word_mom_var_arr($add_name)
  unset word_desc_arr($add_name)
  set Post::($post_object,word_mom_var) [array get word_mom_var_arr]
  set Post::($post_object,word_desc_array) [array get word_desc_arr]
  PB_adr_RetAddressObjList add_obj_list
  if { $obj_index == [llength $add_obj_list]} \
  {
   incr obj_index -1
  }
 }

#=======================================================================
proc PB_int_AddPasteObject { BUFF_OBJ_ATTR OBJ_INDEX ADD_MOM_VAR \
  ADD_VAR_DESC ADD_MSEQ_ATTR } {
  upvar $BUFF_OBJ_ATTR buff_obj_attr
  upvar $OBJ_INDEX obj_index
  upvar $ADD_MOM_VAR add_mom_var
  upvar $ADD_VAR_DESC add_var_desc
  upvar $ADD_MSEQ_ATTR add_mseq_attr
  global post_object
  set add_obj_list $Post::($post_object,add_obj_list)
  set count [llength $add_obj_list]
  if { $count }\
  {
   PB_com_RetObjFrmName buff_obj_attr(0) add_obj_list ret_code
   if {$ret_code}\
   {
    return [tk_messageBox -type ok -icon error\
    -message "Object Name Exists...Paste Invalid"]
   }
  }
  PB_adr_PasteAdrBuffObj add_obj_list buff_obj_attr add_mseq_attr \
  obj_index
  array set word_mom_var_arr $Post::($post_object,word_mom_var)
  array set word_desc_arr $Post::($post_object,word_desc_array)
  set word_mom_var_arr($buff_obj_attr(0)) $add_mom_var
  set word_desc_arr($buff_obj_attr(0)) $add_var_desc
  set Post::($post_object,add_obj_list) $add_obj_list
  set Post::($post_object,word_mom_var) [array get word_mom_var_arr]
  set Post::($post_object,word_desc_array) [array get word_desc_arr]
 }

#=======================================================================
proc PB_int_GetWordVarDesc { WORD_DESC_ARRAY } {
  upvar $WORD_DESC_ARRAY word_desc_array
  global post_object
  array set word_desc_array $Post::($post_object,word_desc_array)
 }

#=======================================================================
proc PB_int_ApplyListObjAttr { ListObjectAttr } {
  upvar $ListObjectAttr obj_attr
  global post_object
  set list_file_obj $Post::($post_object,list_obj_list)
  set object [lindex $list_file_obj 0]
  ListingFile::RestoreValue $object obj_attr
  ListingFile::setvalue $object obj_attr
 }

#=======================================================================
proc PB_int_DefListObjAttr { ListObjectAttr } {
  upvar $ListObjectAttr obj_attr
  global post_object
  set list_file_obj $Post::($post_object,list_obj_list)
  set object [lindex $list_file_obj 0]
  PB_lfl_DefLfileParams object obj_attr
 }

#=======================================================================
proc PB_int_RestoreListObjAttr { ListObjectAttr } {
  upvar $ListObjectAttr obj_attr
  global post_object
  set list_file_obj $Post::($post_object,list_obj_list)
  set object [lindex $list_file_obj 0]
  PB_lfl_ResLfileParams object obj_attr
 }

#=======================================================================
proc PB_int_CreateBlkElemFromElemObj { BLK_ELEM_OBJ NEW_ELEM_OBJ \
  BLK_OBJ_ATTR } {
  upvar $BLK_ELEM_OBJ blk_elem_obj
  upvar $NEW_ELEM_OBJ new_elem_obj
  upvar $BLK_OBJ_ATTR blk_obj_attr
  block_element::readvalue $blk_elem_obj blk_elem_obj_attr
  PB_blk_CreateBlkElemObj blk_elem_obj_attr new_elem_obj blk_obj_attr
 }

#=======================================================================
proc PB_int_AddNewBlockElemObj {BLK_ELEM_ADR_NAME BLK_ELEM_MOM_VAR \
  BLOCK_OBJ NEW_BLK_ELEM_OBJ } {
  upvar $BLK_ELEM_ADR_NAME blk_elem_adr_name
  upvar $BLK_ELEM_MOM_VAR blk_elem_mom_var
  upvar $BLOCK_OBJ block_obj
  upvar $NEW_BLK_ELEM_OBJ new_blk_elem_obj
  set blk_obj_attr(0) $block::($block_obj,block_name)
  PB_blk_AddNewBlkElemObj blk_elem_adr_name blk_elem_mom_var\
  blk_obj_attr new_blk_elem_obj
 }

#=======================================================================
proc PB_int_AddCommentBlkToList { COMMENT_BLK } {
  upvar $COMMENT_BLK comment_blk
  global post_object
  set comment_name $block::($comment_blk,block_name)
  set word "Operator Message"
  set comm_blk_namelist ""
  PB_int_RetMOMVarAsscAddress word comm_blk_namelist
  lappend comm_blk_namelist $comment_name
  PB_int_UpdateMOMVarOfAddress word comm_blk_namelist
  set comm_blk_desclist ""
  PB_int_RetMOMVarDescAddress word comm_blk_desclist
  lappend comm_blk_desclist "Operator Message"
  PB_int_UpdateMOMVarDescAddress word comm_blk_desclist
 }

#=======================================================================
proc PB_int_RetCommentBlks { COMMENT_BLK_LIST } {
  upvar $COMMENT_BLK_LIST comment_blk_list
  global post_object
  set comment_blk_list $Post::($post_object,comment_blk_list)
 }

#=======================================================================
proc PB_int_DeleteCommentBlkFromList { COMMENT_BLK } {
  upvar $COMMENT_BLK comment_blk
  global post_object
  set comment_blk_list $Post::($post_object,comment_blk_list)
  set index [lsearch $comment_blk_list $comment_blk]
  if { $index != -1 } \
  {
   set comment_blk_list [lreplace $comment_blk_list $index $index]
   set Post::($post_object,comment_blk_list) $comment_blk_list
   set word "Operator Message"
   PB_int_RetMOMVarAsscAddress word comm_blk_namelist
   set comm_blk_namelist [lreplace $comm_blk_namelist $index $index]
   PB_int_RetMOMVarDescAddress word comm_blk_desclist
   set comm_blk_desclist [lreplace $comm_blk_desclist $index $index]
   PB_int_UpdateMOMVarDescAddress word comm_blk_desclist
   PB_int_UpdateMOMVarOfAddress word comm_blk_namelist
  }
 }

#=======================================================================
proc PB_int_RetCommentBlkName { COMMENT_BLK_NAME } {
  upvar $COMMENT_BLK_NAME comment_blk_name
  global post_object
  set act_blk_obj_attr(0) "comment_blk"
  set comment_blk_list $Post::($post_object,comment_blk_list)
  PB_blk_GetBlockNames comment_blk_list comment_blk_names
  PB_com_SetDefaultName comment_blk_names act_blk_obj_attr
  set comment_blk_name $act_blk_obj_attr(0)
 }

#=======================================================================
proc PB_int_CreateCommentBlk { ELEM_NAME BLK_ELEM_OBJ BLK_OBJ } {
  upvar $ELEM_NAME elem_name
  upvar $BLK_ELEM_OBJ blk_elem_obj
  upvar $BLK_OBJ blk_obj
  global post_object
  set act_blk_obj_attr(0) $elem_name
  set comment_blk_list $Post::($post_object,comment_blk_list)
  PB_blk_GetBlockNames comment_blk_list comment_blk_names
  PB_com_SetDefaultName comment_blk_names act_blk_obj_attr
  set elem_name $act_blk_obj_attr(0)
  PB_blk_CreateCommentBlk elem_name blk_elem_obj blk_obj post_object
  PB_int_AddCommentBlkToList blk_obj
 }

#=======================================================================
proc PB_int_AddCommentBlkToPost { BLK_OBJ } {
  upvar $BLK_OBJ blk_obj
  global post_object
  set comment_blk_list $Post::($post_object,comment_blk_list)
  lappend comment_blk_list $blk_obj
  set Post::($post_object,comment_blk_list) $comment_blk_list
  PB_int_AddCommentBlkToList blk_obj
 }

#=======================================================================
proc PB_int_CreateCommentBlkElem { ELEM_NAME BLK_ELEM_OBJ } {
  upvar $ELEM_NAME elem_name
  upvar $BLK_ELEM_OBJ blk_elem_obj
  global post_object
  set elem_name "comment_blk"
  PB_blk_CreateCommentBlkElem elem_name blk_elem_obj
 }

#=======================================================================
proc PB_int_CreateCmdBlkElem { CMD_ELEM_NAME CMD_BLK_ELEM } {
  upvar $CMD_ELEM_NAME cmd_elem_name
  upvar $CMD_BLK_ELEM cmd_blk_elem
  global post_object
  set cmd_blk_list $Post::($post_object,cmd_blk_list)
  set cmd_obj 0
  PB_com_RetObjFrmName cmd_elem_name cmd_blk_list cmd_obj
  PB_blk_CreateCmdBlkElem cmd_elem_name cmd_obj cmd_blk_elem
 }

#=======================================================================
proc PB_int_CreateNewCmdBlkElem { CMD_ELEM_NAME CMD_BLK_ELEM } {
  upvar $CMD_ELEM_NAME cmd_elem_name
  upvar $CMD_BLK_ELEM cmd_blk_elem
  global post_object
  set cmd_blk_list $Post::($post_object,cmd_blk_list)
  set cmd_obj_attr(0) $cmd_elem_name
  set cmd_obj_attr(1) ""
  set cmd_obj_attr(2) [list]
  PB_blk_GetCmdNamelist cmd_blk_list cmd_name_list
  PB_com_SetDefaultName cmd_name_list cmd_obj_attr
  PB_pps_CreateCommand cmd_obj_attr cmd_obj
  if 0 {{
   lappend cmd_blk_list $cmd_obj
   set Post::($post_object,cmd_blk_list) $cmd_blk_list
  }}
  PB_blk_CreateCmdBlkElem cmd_elem_name cmd_obj cmd_blk_elem
 }

#=======================================================================
proc PB_int_AddCmdBlkToList { CMD_BLK_OBJ } {
  upvar $CMD_BLK_OBJ cmd_blk_obj
  global post_object
  set cmd_blk_list $Post::($post_object,cmd_blk_list)
  lappend cmd_blk_list $cmd_blk_obj
  set Post::($post_object,cmd_blk_list) $cmd_blk_list
 }

#=======================================================================
proc PB_int_DeleteCmdBlk { CMD_OBJ } {
  upvar $CMD_OBJ cmd_obj
  global post_object
  set cmd_blk_list $Post::($post_object,cmd_blk_list)
  set index [lsearch $cmd_blk_list $cmd_obj]
  if { $index != -1 } \
  {
   set cmd_blk_list [lreplace $cmd_blk_list $index $index]
   set Post::($post_object,cmd_blk_list) $cmd_blk_list
  }
  delete $cmd_obj
 }

#=======================================================================
proc PB_int_GetAddrListFormat { FMT_NAME ADDR_LIST } {
  upvar $FMT_NAME fmt_name
  upvar $ADDR_LIST addr_list
  global post_object
  set fmt_obj_list $Post::($post_object,fmt_obj_list)
  PB_com_RetObjFrmName fmt_name fmt_obj_list fmt_obj
  set addr_obj_list $format::($fmt_obj,fmt_addr_list)
  foreach add_obj $addr_obj_list \
  {
   lappend addr_list $address::($add_obj,add_name)
  }
 }

#=======================================================================
proc PB_int_GetAdsFmtValue {ADD_NAME ADS_FMT_ATTR DIS_ATTR} {
  upvar $ADD_NAME add_name
  upvar $ADS_FMT_ATTR ads_fmt_attr
  upvar $DIS_ATTR dis_attr
  global post_object
  if {[info exists dis_attr]}\
  {
   unset dis_attr
  }
  array set mom_sys_var_arr $Post::($post_object,mom_sys_var_list)
  set add_obj_list $Post::($post_object,add_obj_list)
  PB_com_RetObjFrmName add_name add_obj_list add_obj
  set add_rep_mom_var $address::($add_obj,rep_mom_var)
  PB_com_MapMOMVariable mom_sys_var_arr add_obj add_rep_mom_var app_text
  PB_int_ReturnInputValue app_text ads_fmt_attr(1) inp_value
  PB_fmt_RetFmtOptVal ads_fmt_attr inp_value value
  set dis_attr $value
 }

#=======================================================================
proc PB_int_GetElemDisplayAttr {ADD_NAME APP_TEXT DIS_ATTR} {
  upvar $ADD_NAME add_name
  upvar $APP_TEXT app_text
  upvar $DIS_ATTR dis_attr
  global post_object
  if {[info exists dis_attr]}\
  {
   unset dis_attr
  }
  if { [string compare $add_name "rapid1"] == 0 ||
   [string compare $add_name "rapid2"] == 0 ||
  [string compare $add_name "rapid3"] == 0 } \
  {
   set rap_add_list $Post::($post_object,rap_add_list)
   PB_com_RetObjFrmName add_name rap_add_list add_obj
  } else \
  {
   set add_obj_list $Post::($post_object,add_obj_list)
   PB_com_RetObjFrmName add_name add_obj_list add_obj
  }
  set dis_attr(0) $address::($add_obj,add_leader)
  set trailer_status $address::($add_obj,add_trailer_status)
  if {$trailer_status}\
  {
   set dis_attr(2) $address::($add_obj,add_trailer)
  } else\
  {
   set dis_attr(2) ""
  }
  set format_obj $address::($add_obj,add_format)
  if { $format_obj } \
  {
   format::readvalue $format_obj for_obj_attr
   PB_int_ReturnInputValue app_text for_obj_attr(1) inp_value
   PB_fmt_RetFmtOptVal for_obj_attr inp_value value
   set dis_attr(1) $value
  } else \
  {
   set dis_attr(1) ""
  }
 }

#=======================================================================
proc PB_int_GetFormat { FMT_OBJ_ATTR FMT_VALUE } {
  upvar $FMT_OBJ_ATTR fmt_obj_attr
  upvar $FMT_VALUE fmt_value
  if {[string compare $fmt_obj_attr(1) "Numeral"] == 0} \
  {
   set inp_value 1.234
  } else \
  {
   set inp_value ""
  }
  PB_fmt_RetFmtOptVal fmt_obj_attr inp_value fmt_value
 }

#=======================================================================
proc PB_int_ReturnInputValue {APP_TEXT FMT_DTYPE INP_VALUE} {
  upvar $APP_TEXT app_text
  upvar $FMT_DTYPE fmt_dtype
  upvar $INP_VALUE inp_value
  set inp_value ""
  if {[string compare $app_text ""] == 0} \
  {
   switch $fmt_dtype \
   {
    "Numeral" \
    {
     set inp_value 1.234
    }
    "Text String" \
    {
     set inp_value ""
    }
   }
  } else \
  {
   set is_number [tixGetInt -nocomplain $app_text]
   if {$is_number} \
   {
    set inp_value $app_text
   } else \
   {
    switch $fmt_dtype \
    {
     "Numeral" \
     {
      set inp_value 1.234
     }
     "Text String" \
     {
      set inp_value $app_text
     }
    }
   }
  }
 }

#=======================================================================
proc PB_int_GetGroupWordAddress {IMAGE_NAME IMAGE_TEXT} {
  global post_object
  set word_image_name_list $Post::($post_object,word_img_name)
  set word_app_text_list $Post::($post_object,word_app_text)
  array set word_image_array $word_image_name_list
  array set word_app_text_array $word_app_text_list
  set add_list [array names word_image_array]
  foreach address $add_list\
  {
   set img_sub_list $word_image_array($address)
   set elem_check [lsearch $img_sub_list $IMAGE_NAME]
   if {$elem_check != -1}\
   {
    set app_text_sub_list $word_app_text_array($address)
    set text_elem_check [lsearch $app_text_sub_list $IMAGE_TEXT)]
    if {$text_elem_check != -1}\
    {
     set IMAGE_TEXT [lindex $word_app_text_array($address) 0]
    }
   }
  }
  append temp_app_img_name $IMAGE_NAME $IMAGE_TEXT
  return $temp_app_img_name
 }

#=======================================================================
proc PB_int_GetNewBlockElement {BASE_ELEMENT INDEX WORD_MOM_VAR} {
  upvar $BASE_ELEMENT base_element
  upvar $INDEX index
  upvar $WORD_MOM_VAR word_mom_var
  PB_blk_AddNewBlkElem base_element index word_mom_var
 }

#=======================================================================
proc PB_int_GetBlockElementAddr {ELEM_ADDRESS BASE_ELEMENT_LIST } {
  upvar $ELEM_ADDRESS elem_address
  upvar $BASE_ELEMENT_LIST base_element_list
  PB_blk_RetValidCboxBlkElemAddr elem_address base_element_list
 }

#=======================================================================
proc PB_int_RetSequenceObjs { SEQ_OBJ_LIST } {
  upvar $SEQ_OBJ_LIST seq_obj_list
  global post_object
  set seq_obj_list $Post::($post_object,seq_obj_list)
 }

#=======================================================================
proc PB_int_RetEvtCombElems { COMB_BOX_ELEMS } {
  upvar $COMB_BOX_ELEMS comb_box_elems
  global post_object
  set comb_box_elems $Post::($post_object,word_name_list)
 }

#=======================================================================
proc PB_int_DbaseRetSeqEvtBlkObj {EVT_OBJ_LIST INDEX} {
  upvar $EVT_OBJ_LIST evt_obj_list
  upvar $INDEX index
  global post_object
  set seq_obj [lindex $Post::($post_object,seq_obj_list) $index]
  PB_seq_RetSeqEvtBlkObj seq_obj evt_obj_list
 }

#=======================================================================
proc PB_int_RetBlkObjList { BLK_OBJ_LIST } {
  upvar $BLK_OBJ_LIST blk_obj_list
  global post_object
  set blk_obj_list $Post::($post_object,blk_obj_list)
 }

#=======================================================================
proc PB_int_RetMOMVarAsscAddress { ADDRESS_NAME ADD_MOM_VAR_LIST } {
  upvar $ADDRESS_NAME address_name
  upvar $ADD_MOM_VAR_LIST add_mom_var_list
  global post_object
  array set word_mom_var_list $Post::($post_object,word_mom_var)
  if { [info exists word_mom_var_list($address_name)] } \
  {
   set add_mom_var_list $word_mom_var_list($address_name)
  } else \
  {
   set add_mom_var_list ""
  }
 }

#=======================================================================
proc PB_int_RetMOMVarDescAddress { ADDRESS_NAME ADD_MOM_DESC_LIST } {
  upvar $ADDRESS_NAME address_name
  upvar $ADD_MOM_DESC_LIST add_mom_desc_list
  global post_object
  array set word_desc_arr $Post::($post_object,word_desc_array)
  if { [info exists word_desc_arr($address_name)] } \
  {
   set add_mom_desc_list $word_desc_arr($address_name)
  } else \
  {
   set add_mom_desc_list ""
  }
 }

#=======================================================================
proc PB_int_UpdateMOMVarDescAddress { ADDRESS_NAME ADD_MOM_DESC_LIST } {
  upvar $ADDRESS_NAME address_name
  upvar $ADD_MOM_DESC_LIST add_mom_desc_list
  global post_object
  array set word_desc_arr $Post::($post_object,word_desc_array)
  set word_desc_arr($address_name) $add_mom_desc_list
  set Post::($post_object,word_desc_array) [array get word_desc_arr]
 }

#=======================================================================
proc PB_int_UpdateMOMVarOfAddress { ADDRESS_NAME ADD_MOM_VAR_LIST } {
  upvar $ADDRESS_NAME address_name
  upvar $ADD_MOM_VAR_LIST add_mom_var_list
  global post_object
  array set word_mom_var_list $Post::($post_object,word_mom_var)
  set word_mom_var_list($address_name) $add_mom_var_list
  set Post::($post_object,word_mom_var) [array get word_mom_var_list]
 }

#=======================================================================
proc PB_int_RetAddressObjList { ADDR_OBJ_LIST } {
  upvar $ADDR_OBJ_LIST addr_obj_list
  PB_adr_RetAddressObjList addr_obj_list
 }

#=======================================================================
proc PB_int_RetAddrObjFromName { ADDR_NAME ADDR_OBJ } {
  upvar $ADDR_NAME addr_name
  upvar $ADDR_OBJ addr_obj
  PB_adr_RetAddressObjList addr_obj_list
  PB_com_RetObjFrmName addr_name addr_obj_list addr_obj
 }

#=======================================================================
proc PB_int_RetAddrNameList { ADDR_NAME_LIST } {
  upvar $ADDR_NAME_LIST addr_name_list
  PB_adr_RetAddressObjList addr_obj_list
  PB_adr_RetAddressNameList addr_obj_list addr_name_list
 }

#=======================================================================
proc PB_int_RemoveAddObjFromList { ADD_OBJ } {
  upvar $ADD_OBJ add_obj
  global post_object
  PB_adr_RetAddressObjList addr_obj_list
  set add_index [lsearch $addr_obj_list $add_obj]
  if { $add_index != -1 } \
  {
   set add_fmt_obj $address::($add_obj,add_format)
   format::DeleteFromAddressList $add_fmt_obj add_obj
   set addr_obj_list [lreplace $addr_obj_list $add_index $add_index]
   delete $add_obj
   set Post::($post_object,add_obj_list) $addr_obj_list
   set length [llength $addr_obj_list]
   for { set count $add_index } { $count < $length } { incr count } \
   {
    set elem_obj [lindex $addr_obj_list $count]
    set address::($elem_obj,seq_no) $count
   }
  }
 }

#=======================================================================
proc PB_int_RetFormatObjList { FMT_OBJ_LIST } {
  upvar $FMT_OBJ_LIST fmt_obj_list
  PB_fmt_RetFormatObjs fmt_obj_list
 }

#=======================================================================
proc PB_int_RetFmtNameList { FMT_NAME_LIST } {
  upvar $FMT_NAME_LIST fmt_name_list
  PB_fmt_RetFormatObjs fmt_obj_list
  PB_fmt_GetFmtNameList fmt_obj_list fmt_name_list
 }

#=======================================================================
proc PB_int_RetFmtObjFromName { FMT_NAME FMT_OBJ } {
  upvar $FMT_NAME fmt_name
  upvar $FMT_OBJ fmt_obj
  PB_fmt_RetFormatObjs fmt_obj_list
  PB_com_RetObjFrmName fmt_name fmt_obj_list fmt_obj
 }

#=======================================================================
proc PB_int_RetDefKinVarValues { KIN_VAR_LIST KIN_VAR_VALUE } {
  upvar $KIN_VAR_LIST kin_var_list
  upvar $KIN_VAR_VALUE kin_var_value
  global post_object
  array set def_kin_var $Post::($post_object,def_mom_kin_var_list)
  array set def_mom_var $Post::($post_object,def_mom_sys_var_list)
  foreach kin_var $kin_var_list \
  {
   if { [string match "\$mom_kin*" $kin_var] } \
   {
    set kin_var_value($kin_var) $def_kin_var($kin_var)
   } else \
   {
    set kin_var_value($kin_var) $def_mom_var($kin_var)
   }
  }
 }

#=======================================================================
proc PB_int_RetDefMOMVarValues { MOM_VAR_ARR MOM_VAR_VALUE } {
  upvar $MOM_VAR_ARR mom_var_arr
  upvar $MOM_VAR_VALUE mom_var_value
  global post_object
  array set def_mom_var $Post::($post_object,def_mom_sys_var_list)
  array set def_kin_var $Post::($post_object,def_mom_kin_var_list)
  set no_mom_var [array size mom_var_arr]
  for {set count 0} { $count < $no_mom_var } { incr count } \
  {
   set mom_var $mom_var_arr($count)
   if { [string match "\$mom_kin*" $mom_var] } \
   {
    set mom_var_value($mom_var) $def_kin_var($mom_var)
   } else \
   {
    set mom_var_value($mom_var) $def_mom_var($mom_var)
   }
  }
 }

#=======================================================================
proc PB_int_UpdateMOMVar { MOM_SYS_VAR } {
  upvar $MOM_SYS_VAR mom_sys_var
  global post_object
  set Post::($post_object,mom_sys_var_list) \
  [array get mom_sys_var]
 }

#=======================================================================
proc PB_int_UpdateKinVar { MOM_KIN_VAR } {
  upvar $MOM_KIN_VAR mom_kin_var
  global post_object
  set Post::($post_object,mom_kin_var_list) \
  [array get mom_kin_var]
 }

#=======================================================================
proc PB_int_RetCycleComAndSharedEvts { CYCLE_COM_EVT CYCLE_SHARED_EVTS } {
  upvar $CYCLE_COM_EVT cycle_com_evt
  upvar $CYCLE_SHARED_EVTS cycle_shared_evts
  global post_object
  set cycle_com_evt [lindex $Post::($post_object,cyl_com_evt) 0]
  set cycle_shared_evts [lindex $Post::($post_object,cyl_evt_sh_com_evt) 0]
 }

#=======================================================================
proc PB_int_RetPostBlocks { POST_BLK_LIST } {
  upvar $POST_BLK_LIST post_blk_list
  global post_object
  if [info exists Post::($post_object,post_blk_list)] {
   set post_blk_list $Post::($post_object,post_blk_list)
  }
 }

#=======================================================================
proc PB_int_CreateCycleRaptoBlks { EVENT_OBJ MOM_SYS_ARR } {
  upvar $EVENT_OBJ event_obj
  upvar $MOM_SYS_ARR mom_sys_arr
  global post_object
  set evt_elem_list $event::($event_obj,evt_elem_list)
  PB_evt_CreateRapidToBlock event_obj evt_elem_list mom_sys_arr
  PB_evt_StorePostBlocks evt_elem_list post_object
  set event::($event_obj,evt_elem_list) $evt_elem_list
 }

#=======================================================================
proc PB_int_CreateCycleRetractoBlks { EVENT_OBJ MOM_SYS_ARR } {
  upvar $EVENT_OBJ event_obj
  upvar $MOM_SYS_ARR mom_sys_arr
  global post_object
  set evt_elem_list $event::($event_obj,evt_elem_list)
  PB_evt_CreateRetractToBlock event_obj evt_elem_list mom_sys_arr
  PB_evt_StorePostBlocks evt_elem_list post_object
  set event::($event_obj,evt_elem_list) $evt_elem_list
 }

#=======================================================================
proc PB_int_CreateCyclePlaneElems { EVENT_OBJ MOM_SYS_ARR } {
  upvar $EVENT_OBJ event_obj
  upvar $MOM_SYS_ARR mom_sys_arr
  set evt_elem_list $event::($event_obj,evt_elem_list)
  PB_evt_CreateCyclePlaneBlock event_obj evt_elem_list mom_sys_arr
 }

#=======================================================================
proc PB_int_CreateCycleStartBlks { EVENT_OBJ MOM_SYS_ARR STRT_BLK_INDX } {
  upvar $EVENT_OBJ event_obj
  upvar $MOM_SYS_ARR mom_sys_arr
  upvar $STRT_BLK_INDX strt_blk_indx
  global post_object
  set evt_elem_list $event::($event_obj,evt_elem_list)
  PB_evt_CreateCycleStartBlock event_obj evt_elem_list mom_sys_arr \
  strt_blk_indx
  PB_evt_StorePostBlocks evt_elem_list post_object
  set event::($event_obj,evt_elem_list) $evt_elem_list
 }

#=======================================================================
proc PB_int_CheckIsFmtZeroFmt { FMT_OBJ RET_CODE } {
  upvar $FMT_OBJ fmt_obj
  upvar $RET_CODE ret_code
  global mom_sys_arr
  if { $mom_sys_arr(\$zero_int_fmt) == "$format::($fmt_obj,for_name)" } \
  {
   set ret_code 1
   } elseif { $mom_sys_arr(\$zero_real_fmt) == "$format::($fmt_obj,for_name)" } \
  {
   set ret_code 1
  } else \
  {
   set ret_code 0
  }
 }

#=======================================================================
proc PB_int_ReadPostFiles { DIR DEF_FILE TCL_FILE } {
  upvar $DIR dir
  upvar $DEF_FILE def_file
  upvar $TCL_FILE tcl_file
  global post_object
  Post::ReadPostFiles $post_object dir def_file tcl_file
 }

#=======================================================================
proc PB_int_SetPostOutputFiles { DIR PUI_FILE DEF_FILE TCL_FILE } {
  upvar $DIR dir
  upvar $PUI_FILE pui_file
  upvar $DEF_FILE def_file
  upvar $TCL_FILE tcl_file
  global post_object
  Post::SetPostOutputFiles $post_object dir pui_file def_file \
  tcl_file
 }

#=======================================================================
proc PB_int_RetListingFileParams { LIST_OBJ_ATTR } {
  upvar $LIST_OBJ_ATTR list_obj_attr
  global post_object
  set list_object $Post::($post_object,list_obj_list)
  PB_lfl_RetDisVars list_object list_obj_attr
 }

#=======================================================================
proc PB_int_SetUserTclFileName { POST_NAME } {
  upvar $POST_NAME post_name
  global post_object
  set usertcl_name ${post_name}_user.tcl
  set listfile_obj $Post::($post_object,list_obj_list)
  ListingFile::readvalue $listfile_obj list_obj_attr
  set list_obj_attr(usertcl_name) $usertcl_name
  ListingFile::setvalue $listfile_obj list_obj_attr
  ListingFile::DefaultValue $listfile_obj list_obj_attr
 }

#=======================================================================
proc PB_int_ReadPostOutputFiles { DIR PUI_FILE DEF_FILE TCL_FILE } {
  upvar $DIR dir
  upvar $PUI_FILE pui_file
  upvar $DEF_FILE def_file
  upvar $TCL_FILE tcl_file
  global post_object
  Post::ReadPostOutputFiles $post_object dir pui_file def_file \
  tcl_file
 }

#=======================================================================
proc PB_int_GetEventProcsData { EVENT_PROC_DATA } {
  upvar $EVENT_PROC_DATA event_proc_data
  global post_object
  array set event_proc_data $Post::($post_object,event_procs)
 }

#=======================================================================
proc PB_OpenOldVersion { pui_file_name temp_pui_file args } {
  global post_object
  global env
  global gPB
  set ret_code 0
  set std_pui_id FP1
  set pui_file_id FP2
  PB_file_GetPostAttr $pui_file_name machine_type axis_option output_unit
  UI_PB_file_GetPostFragList pui_file_list $machine_type "Generic" $axis_option $output_unit
  if { [lsearch $pui_file_list $pui_file_name] < 0 } {
   lappend pui_file_list $pui_file_name
  }
  switch $machine_type {
   "Mill" {
    set file_conv [file nativename $env(PB_HOME)/pblib/mill_base.pb]
   }
   "Lathe" {
    set file_conv [file nativename $env(PB_HOME)/pblib/lathe_base.pb]
   }
  }
  if [info exists file_conv] {
   lappend pui_file_list $file_conv
  }
  set sw_list [list]
  foreach f $pui_file_list \
  {
   lappend sw_list 1
  }
  set idx [lsearch $pui_file_list $pui_file_name]
  set sw_list [lreplace $sw_list $idx $idx 0]
  if 0 {{
   set std_pui_file $env(PB_HOME)/pblib/$temp_pui_file
   if { $std_pui_file == "$pui_file_name" } \
   {
    set pui_file_list [list $pui_file_name]
    } else {
    set pui_file_list [list $std_pui_file $pui_file_name]
   }
  }}
  if [catch { PB_file_Create $pui_file_list $sw_list } result] \
  {
   return [ error "$result" ]
  }
  if { $ret_code == 0} \
  {
   set add_obj_list $Post::($post_object,add_obj_list)
   set add_list {"N" "fourth_axis" "fifth_axis"}
   foreach add_name $add_list \
   {
    set add_obj 0
    PB_com_RetObjFrmName add_name add_obj_list add_obj
    if { $add_obj != 0 } \
    {
     set address::($add_obj,leader_var) \
     "\$mom_sys_leader($add_name)"
    }
   }
   set add_name "M_range"
   PB_com_RetObjFrmName add_name add_obj_list add_obj
   if { $add_obj == 0 } \
   {
    set spin_add "M_spindle"
    PB_com_RetObjFrmName spin_add add_obj_list spin_add_obj
    address::readvalue $spin_add_obj add_obj_attr
    set add_obj_attr(0) "$add_name"
    PB_adr_CreateAdrObj add_obj_attr add_obj_list
    set Post::($post_object,add_obj_list) $add_obj_list
    global gpb_addr_var
    set gpb_addr_var($add_name,name) $add_obj_attr(0)
    set fmt_name $format::($add_obj_attr(1),for_name)
    set gpb_addr_var($add_name,fmt_name) $fmt_name
    set gpb_addr_var($add_name,modal) $add_obj_attr(2)
    set gpb_addr_var($add_name,modl_status) $add_obj_attr(3)
    set gpb_addr_var($add_name,add_max) $add_obj_attr(4)
    set gpb_addr_var($add_name,max_status) $add_obj_attr(5)
    set gpb_addr_var($add_name,add_min) $add_obj_attr(6)
    set gpb_addr_var($add_name,min_status) $add_obj_attr(7)
    set gpb_addr_var($add_name,leader_name) $add_obj_attr(8)
    set gpb_addr_var($add_name,trailer) $add_obj_attr(9)
    set gpb_addr_var($add_name,trail_status) $add_obj_attr(10)
    set gpb_addr_var($add_name,incremental) $add_obj_attr(11)
    set gpb_addr_var($add_name,zero_format) $add_obj_attr(12)
    set Post::($post_object,def_gpb_addr_var) [array get gpb_addr_var]
    PB_int_GetWordVarDesc WordDescArray
    set WordDescArray($add_name) ""
    PB_int_UpdateAddVariablesAttr WordDescArray add_name
   }
   if 0 {
    PB_int_AddCustomCmds
    global mom_sys_arr
    foreach add_obj $add_obj_list \
    {
     address::readvalue $add_obj add_obj_attr
     if { $add_obj_attr(12) != "" } \
     {
      format::readvalue $add_obj_attr(1) fmt_obj_attr
      if { $fmt_obj_attr(1) == "Numeral" && $fmt_obj_attr(6)} \
      {
       if { $mom_sys_arr(\$zero_real_fmt) != $add_obj_attr(12) } \
       {
        if { $mom_sys_arr(\$zero_real_fmt) } \
        {
         set fmt_obj_list $Post::($post_object,fmt_obj_list)
         set index [lsearch $fmt_obj_list \
         $mom_sys_arr(\$zero_real_fmt)]
         set fmt_obj_list [lreplace $fmt_obj_list $index $index]
         set Post::($post_object,fmt_obj_list) $fmt_obj_list
         delete $mom_sys_arr(\$zero_real_fmt)
        }
        set mom_sys_arr(\$zero_real_fmt) $add_obj_attr(12)
        break
       } else \
       {
        break
       }
      }
     }
    }
    set Post::($post_object,mom_sys_var_list) [array get mom_sys_arr]
   }
  }
  return $ret_code
 }

#=======================================================================
proc PB_int_AddCustomCmds { } {
  global post_object
  set cmd_elem_name "PB_CMD_before_motion"
  set cmd_blk_list $Post::($post_object,cmd_blk_list)
  set cmd_obj 0
  PB_com_RetObjFrmName cmd_elem_name cmd_blk_list cmd_obj
  if { $cmd_obj == 0 } \
  {
   set cmd_obj_attr(0) $cmd_elem_name
   set cmd_obj_attr(1) ""
   set cmd_obj_attr(2) [list]
   PB_pps_CreateCommand cmd_obj_attr cmd_obj
   set word "Command"
   PB_int_RetMOMVarAsscAddress word cmd_proc_list
   set proc_name $command::($cmd_obj,name)
   lappend cmd_proc_list $proc_name
   PB_int_RetMOMVarDescAddress word cmd_proc_desc_list
   lappend cmd_proc_desc_list "Custom Command"
   PB_int_UpdateMOMVarDescAddress word cmd_proc_desc_list
   PB_int_UpdateMOMVarOfAddress word cmd_proc_list
  }
 }

#=======================================================================
proc PB_file_Open { pui_file_name args } {
  global post_object
  global env
  global gPB
  set ret_code 0
  set post_object [new Post $pui_file_name]
  set pui_file_id FP2
  if [ catch { PB_com_ReadPuiFile pui_file_name pui_file_id post_object } result ] {
   return [ error "$result" ]
  }
  if [ catch { PB_file_ParsePostFiles $post_object } result ] {
   return [ error "$result" ]
  }
  if { $Post::($post_object,tcl_file_read) != "TRUE"  || \
  $Post::($post_object,def_file_read) != "TRUE" } \
  {
   return [ error "$gPB(msg,invalid_post)" ]
  }
  if [PB_file_CreatePostObjects $post_object] {
   return 1
  }
  return $ret_code
 }

#=======================================================================
proc PB_file_Create { pui_file_list args } {
  global post_object
  global env
  global gPB
  set ret_code 0
  set pui_file_id FP2
  set post_object [new Post new_post]
  if [llength $args] \
  {
   set ui_overwrite_sw_list [lindex $args 0]
  }
  UI_PB_debug_ForceMsg "Post Fragments :\n[join $pui_file_list \n]"
  if [info exists ui_overwrite_sw_list] \
  {
   UI_PB_debug_ForceMsg "UI Overwrite   : $ui_overwrite_sw_list "
  }
  set idx 0
  foreach pui_file $pui_file_list \
  {
   if { $gPB(DEBUG) } \
   { tk_messageBox -type ok -icon info -message "Parsing PUI : $pui_file" }
   if [info exists ui_overwrite_sw_list] \
   {
    set gPB(pui_ui_overwrite) [lindex $ui_overwrite_sw_list $idx]
   }
   if [ catch { PB_com_ReadPuiFile pui_file pui_file_id post_object } result ] {
    UI_PB_debug_ForceMsg "$result"
    return [ error "$result" ]
   }
   if [ catch { PB_file_ParsePostFiles $post_object } result ] {
    return [ error "$result" ]
   }
   incr idx
  }
  if { $Post::($post_object,tcl_file_read) != "TRUE"  || \
   $Post::($post_object,def_file_read) != "TRUE" } {
   UI_PB_debug_ForceMsg "$gPB(msg,invalid_post)"
   return [ error "$gPB(msg,invalid_post)" ]
  }
  set ret_code [PB_file_CreatePostObjects $post_object]
  return $ret_code
 }

#=======================================================================
proc PB_file_ParsePostFiles { post_object } {
  global gPB
  set def_file_id FP1
  Post::ReadPostFiles $post_object dir def_file_name tcl_file_name
  set def_file_name [string trim $def_file_name \"]
  set def_file_name [string trim $def_file_name]
  if { $def_file_name != "" } \
  {
   set def_file [file join $dir "$def_file_name"]
   if { ![file exists "$def_file"] } {
    return [ error "$def_file : $gPB(msg,invalid_file)" ]
   }
   if [ catch { PB_com_ReadDfltDefFile def_file def_file_id post_object } res ] {
    return [ error "$gPB(msg,bad_def_file) : \n\n$res" ]
    } else {
    set Post::($post_object,def_file_read) TRUE
   }
  }
  set tcl_file_name [string trim $tcl_file_name \"]
  set tcl_file_name [string trim $tcl_file_name]
  if { $tcl_file_name != "" } \
  {
   set tcl_file [file join $dir "$tcl_file_name"]
   if { ![file exists "$tcl_file"] } {
    return [ error "$tcl_file : $gPB(msg,invalid_file)" ]
   }
   if [ catch { PB_pps_CreateTclFileObjs post_object $tcl_file 1 } res ] {
    return [ error "$gPB(msg,bad_tcl_file) : \n\n$res" ]
    } else {
    set Post::($post_object,tcl_file_read) TRUE
   }
  }
  return 0
 }

#=======================================================================
proc PB_file_DeleteEmptyBlock { } {
  global post_object
  Post::GetObjList $post_object block blk_obj_list
  foreach block_obj $blk_obj_list \
  {
   if { $block::($block_obj,blk_type) != "command" && \
   $block::($block_obj,blk_type) != "comment" } \
   {
    foreach blk_elem $block::($block_obj,elem_addr_list) \
    {
     lappend blk_elem_list $blk_elem
    }
   }
   if [info exists blk_elem_list] \
   {
    UI_PB_com_ApplyMastSeqBlockElem blk_elem_list
   }
   if { ![info exists blk_elem_list] || [llength $blk_elem_list] == 0 } \
   {
    UI_PB_debug_ForceMsg "Delete empty block $block_obj $block::($block_obj,block_name)"
    set blk_evt_elem_list $block::($block_obj,evt_elem_list)
    foreach e $blk_evt_elem_list { 
     if [info exists event_element::($e,event_obj)] {
      set evt $event_element::($e,event_obj)
      set evt_elem_list $event::($evt,evt_elem_list)
      set idx [lsearch $evt_elem_list $e]
      if { $idx >= 0 } {
       set evt_elem_list [lreplace $evt_elem_list $idx $idx]
       event::readvalue $evt evt_attr
       set evt_attr(2) $evt_elem_list
       event::setvalue $evt evt_attr
       event::DefaultValue $evt
      }
     }
    }
    set idx [lsearch $blk_obj_list $block_obj]
    if { $idx >= 0 } {
     set blk_obj_list [lreplace $blk_obj_list $idx $idx]
    }
    delete $block_obj
   }
   if [info exists blk_elem_list] \
   {
    unset blk_elem_list
   }
  }
  Post::SetObjListasAttr $post_object blk_obj_list
 }

#=======================================================================
proc PB_file_CreatePostObjects { post_object } {
  __file_TidyPostObjects
  PB_seq_CreateSequences post_object
  PB_int_DefineUIGlobVar
  Post::GetObjList $post_object address add_obj_list
  foreach addr $add_obj_list {
   PB_adr_SetMseqAttr $addr
  }
  PB_file_DeleteEmptyBlock
  global gPB
  if { $gPB(DEBUG) } \
  {
   set lis $Post::($post_object,fmt_obj_list)
   set n   [llength $lis]
   UI_PB_debug_DisplayMsg "- Number of Formats : $n -"
   for { set i 0 } { $i < $n } { incr i } \
   {
    set this [lindex $lis $i]
    UI_PB_debug_DisplayMsg "  - Format $i ($this) -"
    UI_PB_debug_DisplayMsg "      name       : $format::($this,for_name)"
    UI_PB_debug_DisplayMsg "      data type  : $format::($this,for_dtype)"
    UI_PB_debug_DisplayMsg "      plus sign  : $format::($this,for_leadplus)"
    UI_PB_debug_DisplayMsg "      lead zero  : $format::($this,for_leadzero)"
    UI_PB_debug_DisplayMsg "      trail zero : $format::($this,for_trailzero)"
    UI_PB_debug_DisplayMsg "      integer    : $format::($this,for_valfpart)"
    UI_PB_debug_DisplayMsg "      decimal    : $format::($this,for_outdecimal)"
    UI_PB_debug_DisplayMsg "      fraction   : $format::($this,for_valspart)"
    set m [llength $format::($this,fmt_addr_list)]
    if $m \
    {
     UI_PB_debug_DisplayMsg "      Address list : $m"
     for { set j 0 } { $j < $m } { incr j } \
     {
      set obj [lindex $format::($this,fmt_addr_list) $j]
      UI_PB_debug_DisplayMsg "      $j : $address::($obj,add_name) ($obj)"
     }
    }
   }
   set lis $Post::($post_object,add_obj_list)
   set n   [llength $lis]
   UI_PB_debug_DisplayMsg "- Number of Addresses : $n -"
   for { set i 0 } { $i < $n } { incr i } \
   {
    set this [lindex $lis $i]
    UI_PB_debug_DisplayMsg "  - Address $i ($this) -"
    UI_PB_debug_DisplayMsg "      name         : $address::($this,add_name)"
    set fmt $address::($this,add_format)
    UI_PB_debug_DisplayMsg "      format       : $format::($fmt,for_name) ($fmt)"
    UI_PB_debug_DisplayMsg "      force        : $address::($this,add_force)"
    UI_PB_debug_DisplayMsg "      force type   : $address::($this,add_force_status)"
    UI_PB_debug_DisplayMsg "      max          : $address::($this,add_max)"
    UI_PB_debug_DisplayMsg "      max status   : $address::($this,add_max_status)"
    UI_PB_debug_DisplayMsg "      min          : $address::($this,add_min)"
    UI_PB_debug_DisplayMsg "      min type     : $address::($this,add_min_status)"
    UI_PB_debug_DisplayMsg "      leader       : $address::($this,add_leader)"
    UI_PB_debug_DisplayMsg "      trailer      : $address::($this,add_trailer)"
    UI_PB_debug_DisplayMsg "      trailer type : $address::($this,add_trailer_status)"
    UI_PB_debug_DisplayMsg "      incremental  : $address::($this,add_incremental)"
    UI_PB_debug_DisplayMsg "      zero format  : $address::($this,add_zerofmt)"
   }
   set lis $Post::($post_object,blk_obj_list)
   set n   [llength $lis]
   UI_PB_debug_DisplayMsg "- Number of Blocks : $n -"
   for { set i 0 } { $i < $n } { incr i } \
   {
    set this [lindex $lis $i]
    UI_PB_debug_DisplayMsg "  - Block $i ($this) -"
    UI_PB_debug_DisplayMsg "      name : $block::($this,block_name)"
    UI_PB_debug_DisplayMsg "      type : $block::($this,blk_type)"
    set m $block::($this,block_nof_elements)
    if $m \
    {
     UI_PB_debug_DisplayMsg "      Element list : $m"
     for { set j 0 } { $j < $m } { incr j } \
     {
      set obj [lindex $block::($this,elem_addr_list) $j]
      if { $obj != "" } \
      {
       set addr $block_element::($obj,elem_add_obj)
       UI_PB_debug_DisplayMsg "      $j : $address::($addr,add_name) ($addr)"
      }
     }
    }
   }
  }
  set gPB(backup_one_done) 0
  return 0
 }

#=======================================================================
proc  __file_TidyPostObjects { args } {
  global post_object
  array set mom_sys_arr $Post::($post_object,mom_sys_var_list)
  array set mom_kin_arr $Post::($post_object,mom_kin_var_list)
  set update_mom_sys 0
  if [info exists mom_kin_arr(\$mom_kin_4th_axis_leader)] {
   set var "\$mom_sys_leader(fourth_axis)"
   set mom_sys_arr($var) $mom_kin_arr(\$mom_kin_4th_axis_leader)
   set update_mom_sys 1
  }
  if [info exists mom_kin_arr(\$mom_kin_5th_axis_leader)] {
   set var "\$mom_sys_leader(fifth_axis)"
   set mom_sys_arr($var) $mom_kin_arr(\$mom_kin_5th_axis_leader)
   set update_mom_sys 1
  }
  if { $update_mom_sys } {
   set Post::($post_object,mom_sys_var_list)     [array get mom_sys_arr]
   set Post::($post_object,def_mom_sys_var_list) [array get mom_sys_arr]
  }
  Post::GetObjList $post_object address add_obj_list
  foreach add_obj $add_obj_list \
  {
   set add_leader_var $address::($add_obj,leader_var)
   if { $add_leader_var != "" } \
   {
    address::readvalue $add_obj add_attr
    set add_attr(8) $mom_sys_arr($add_leader_var)
    address::setvalue $add_obj add_attr
    address::DefaultValue $add_obj add_attr
   }
  }
  Post::GetObjList $post_object command cmd_obj_list
  set cc_idx [lsearch $Post::($post_object,add_name_list) "Command"]
  if { $cc_idx >= 0 } {
   set cmd_list [lindex $Post::($post_object,add_mom_var_list) $cc_idx]
   set cc_list $cmd_list
   set j 0
   set jj [expr [llength $cmd_list] - 1]
   for {set j $jj} {$j >= 0} {incr j -1} {
    set c [lindex $cc_list $j]
    if [string match "*PB_CMD*" $c] {
     set cmd_list [lreplace $cmd_list $j $j]
    }
   }
   unset cc_list
   foreach c $cmd_obj_list {
    set cc "\"$command::($c,name)\" \"\" \"Custom Command\""
    lappend cmd_list $cc
   }
   set Post::($post_object,add_mom_var_list) \
   [lreplace $Post::($post_object,add_mom_var_list) $cc_idx $cc_idx "$cmd_list"]
   array set word_mom_var_list $Post::($post_object,word_mom_var)
   if { [info exists word_mom_var_list(Command)] } \
   {
    foreach c $cmd_list {
     lappend cc_list [lindex $c 0]
     lappend cn_list [lindex $c 2]
    }
    set word "Command"
    PB_int_UpdateMOMVarOfAddress word cc_list
    PB_int_UpdateMOMVarDescAddress word cn_list
   }
  }
  set err_msg ""
  if [info exists cmd_obj_list] {
   foreach c $cmd_obj_list {
    set msg [ PB_file_ValidateDefElemsInCommand $c ]
    if { $msg != "" } {
     append err_msg $msg
    }
   }
  }
  if { $err_msg != "" } {
   UI_PB_debug_DisplayMsg $err_msg no_debug
  }
  __file_ValidateBlocksInEvent
 }

#=======================================================================
proc PB_file_AssumeUnknownCommandsInProc { } {
  global post_object
  if [llength $Post::($post_object,unk_cmd_list)] {
   if { ![info exists Post::($post_object,ass_cmd_list)] } {
    set Post::($post_object,ass_cmd_list) $Post::($post_object,unk_cmd_list)
    } else {
    set Post::($post_object,ass_cmd_list) \
    [lmerge $Post::($post_object,ass_cmd_list) $Post::($post_object,unk_cmd_list)]
   }
  }
 }

#=======================================================================
proc PB_file_AssumeUnknownDefElemsInProc { } {
  global post_object
  if [llength $Post::($post_object,unk_blk_list)] {
   if { ![info exists Post::($post_object,ass_blk_list)] } {
    set Post::($post_object,ass_blk_list) $Post::($post_object,unk_blk_list)
    } else {
    set Post::($post_object,ass_blk_list) \
    [lmerge $Post::($post_object,ass_blk_list) $Post::($post_object,unk_blk_list)]
   }
  }
  if [llength $Post::($post_object,unk_add_list)] {
   if { ![info exists Post::($post_object,ass_add_list)] } {
    set Post::($post_object,ass_add_list) $Post::($post_object,unk_add_list)
    } else {
    set Post::($post_object,ass_add_list) \
    [lmerge $Post::($post_object,ass_add_list) $Post::($post_object,unk_add_list)]
   }
  }
  if [llength $($post_object,unk_fmt_list)] {
   if { ![info exists Post::($post_object,ass_fmt_list)] } {
    set Post::($post_object,ass_fmt_list) $Post::($post_object,unk_fmt_list)
    } else {
    set Post::($post_object,ass_fmt_list) \
    [lmerge $Post::($post_object,ass_fmt_list) $Post::($post_object,unk_fmt_list)]
   }
  }
 }

#=======================================================================
proc PB_file_ValidateDefElemsInCommand { obj } {
  global gPB
  global post_object
  set err_msg ""
  if $gPB(check_cc_unknown_block) {
   __file_ValidateBlockInCommand $obj
   if [llength $Post::($post_object,unk_blk_list)] {
    set err_msg "$gPB(cust_cmd,blk,msg) $Post::($post_object,unk_blk_list)"
   }
  }
  if $gPB(check_cc_unknown_address) {
   __file_ValidateAddressInCommand $obj
   if [llength $Post::($post_object,unk_add_list)] {
    if { $err_msg != "" } {
     set err_msg "$err_msg\n\n"
    }
    set err_msg "$err_msg$gPB(cust_cmd,add,msg) $Post::($post_object,unk_add_list)"
   }
  }
  if $gPB(check_cc_unknown_format) {
   __file_ValidateFormatInCommand $obj
   if [llength $Post::($post_object,unk_fmt_list)] {
    if { $err_msg != "" } {
     set err_msg "$err_msg\n\n"
    }
    set err_msg "$err_msg$gPB(cust_cmd,fmt,msg) $Post::($post_object,unk_fmt_list)"
   }
  }
  if { $err_msg != "" } {
   set err_msg "$err_msg\n\n\
   $gPB(cust_cmd,referenced,msg) \"$command::($obj,name)\"\n\
   $gPB(cust_cmd,not_defined,msg)"
  }
  return $err_msg
 }

#=======================================================================
proc __file_ValidateBlockInCommand { obj } {
  global post_object
  Post::GetObjList  $post_object  block  obj_list
  set Post::($post_object,unk_blk_list) ""
  if { ![info exists Post::($post_object,ass_blk_list)] } {
   set Post::($post_object,ass_blk_list) ""
  }
  foreach e $command::($obj,blk_list) {
   PB_com_RetObjFrmName e obj_list e_obj
   set ass_idx [lsearch $Post::($post_object,ass_blk_list) $e]
   if { $e_obj > 0  &&  $ass_idx >= 0 } {
    set Post::($post_object,ass_blk_list) \
    [lreplace $Post::($post_object,ass_blk_list) $ass_idx $ass_idx]
   }
   if { $e_obj <= 0  &&  $ass_idx < 0 } {
    if { [lsearch $Post::($post_object,unk_blk_list) $e] < 0 } {
     lappend Post::($post_object,unk_blk_list) $e
    }
   }
  }
 }

#=======================================================================
proc __file_ValidateAddressInCommand { obj } {
  global post_object
  Post::GetObjList  $post_object  address  obj_list
  set Post::($post_object,unk_add_list) ""
  if { ![info exists Post::($post_object,ass_add_list)] } {
   set Post::($post_object,ass_add_list) ""
  }
  foreach e $command::($obj,add_list) {
   PB_com_RetObjFrmName e obj_list e_obj
   set ass_idx [lsearch $Post::($post_object,ass_add_list) $e]
   if { $e_obj > 0  &&  $ass_idx >= 0 } {
    set Post::($post_object,ass_add_list) \
    [lreplace $Post::($post_object,ass_add_list) $ass_idx $ass_idx]
   }
   if { $e_obj <= 0  &&  $ass_idx < 0 } {
    if { [lsearch $Post::($post_object,unk_add_list) $e] < 0 } {
     lappend Post::($post_object,unk_add_list) $e
    }
   }
  }
 }

#=======================================================================
proc __file_ValidateFormatInCommand { obj } {
  global post_object
  Post::GetObjList  $post_object  format  obj_list
  set Post::($post_object,unk_fmt_list) ""
  if { ![info exists Post::($post_object,ass_fmt_list)] } {
   set Post::($post_object,ass_fmt_list) ""
  }
  foreach e $command::($obj,fmt_list) {
   PB_com_RetObjFrmName e obj_list e_obj
   set ass_idx [lsearch $Post::($post_object,ass_fmt_list) $e]
   if { $e_obj > 0  &&  $ass_idx >= 0 } {
    set Post::($post_object,ass_fmt_list) \
    [lreplace $Post::($post_object,ass_fmt_list) $ass_idx $ass_idx]
   }
   if { $e_obj <= 0  &&  $ass_idx < 0 } {
    if { [lsearch $Post::($post_object,unk_fmt_list) $e] < 0 } {
     lappend Post::($post_object,unk_fmt_list) $e
    }
   }
  }
 }

#=======================================================================
proc __file_ValidateBlocksInEvent { } {
  global post_object
  set seq_list {prog_start oper_start tpth_ctrl tpth_mot tpth_cycle oper_end prog_end}
  Post::GetObjList $post_object block   blk_obj_list
  Post::GetObjList $post_object comment cmt_blk_list
  set word "Command"
  PB_int_RetMOMVarAsscAddress word cmd_proc_list
  foreach seq $seq_list \
  {
   switch $seq \
   {
    "prog_start" \
    {
     set evt_list     "prog_start_evt_list"
     set evt_blk_list "prog_start_evt_blk_list"
     set seq_name     "Program Start"
    }
    "oper_start" \
    {
     set evt_list     "oper_start_evt_list"
     set evt_blk_list "oper_start_evt_blk_list"
     set seq_name     "Operation Start"
    }
    "tpth_ctrl" \
    {
     set evt_list     "tpth_ctrl_evt_list"
     set evt_blk_list "tpth_ctrl_evt_blk_list"
     set seq_name     "Machine Control"
    }
    "tpth_mot" \
    {
     set evt_list     "tpth_mot_evt_list"
     set evt_blk_list "tpth_mot_evt_blk_list"
     set seq_name     "Motion"
    }
    "tpth_cycle" \
    {
     set evt_list     "tpth_cycle_evt_list"
     set evt_blk_list "tpth_cycle_evt_blk_list"
     set seq_name     "Cycle"
    }
    "oper_end" \
    {
     set evt_list     "oper_end_evt_list"
     set evt_blk_list "oper_end_evt_blk_list"
     set seq_name     "Operation End"
    }
    "prog_end" \
    {
     set evt_list     "prog_end_evt_list"
     set evt_blk_list "prog_end_evt_blk_list"
     set seq_name     "Program End"
    }
   }
   array set evt_name_arr      $Post::($post_object,$evt_list)
   array set evt_blk_list_arr  $Post::($post_object,$evt_blk_list)
   set arr_size [array size evt_name_arr]
   for {set i 0} {$i < $arr_size} {incr i} {
    foreach blk $evt_blk_list_arr($i) {
     set blk_not_found 0
     PB_com_RetObjFrmName blk blk_obj_list blk_obj
     if { $blk_obj <= 0 } {
      set blk_not_found 1
      if [info exists cmd_proc_list] {
       set idx [lsearch $cmd_proc_list $blk]
       if { $idx >= 0 } {
        set blk_not_found 0
       }
      }
      if $blk_not_found {
       set msg "Block template \"$blk\" referenced in\
       \"$evt_name_arr($i)\" Event\
       at \"$seq_name\" sequence is not defined."
       UI_PB_debug_DisplayMsg $msg no_debug
      }
      } else {
      set rename_block 0
      switch $blk {
       "cycle_breakchip" {
        set blk_x "cycle_drill_break_chip"
        set mom_var_x "mom_sys_cycle_breakchip_code"
        set mom_var   "mom_sys_cycle_drill_break_chip_code"
        set rename_block 1
       }
       "cycle_bore_m_dwell" {
        set blk_x "cycle_bore_manual_dwell"
        set mom_var_x "mom_sys_cycle_bore_manual_code"
        set mom_var   "mom_sys_cycle_bore_manual_dwell_code"
        set rename_block 1
       }
       "cycle_drill_break_chip" {
        set mom_var_x "mom_sys_cycle_breakchip_code"
        set mom_var   "mom_sys_cycle_drill_break_chip_code"
       }
       "cycle_bore_manual_dwell" {
        set mom_var_x "mom_sys_cycle_bore_manual_code"
        set mom_var   "mom_sys_cycle_bore_manual_dwell_code"
       }
      }
      if $rename_block {
       PB_com_RetObjFrmName blk_x blk_obj_list blk_x_obj
       if { $blk_x_obj > 0 } {
        if { [llength $block::($blk_x_obj,evt_elem_list)] == 0 } {
         foreach blk_elem $block::($blk_x_obj,elem_addr_list) {
          delete $blk_elem
         }
         set block::($blk_x_obj,elem_addr_list) [list]
         block::readvalue $blk_obj blk_attr
         set blk_attr(0) $blk_x
         block::setvalue $blk_obj blk_attr
         block::DefaultValue $blk_obj blk_attr
         set idx [lsearch $evt_blk_list_arr($i) $blk]
         set evt_blk_list_arr($i) [lreplace $evt_blk_list_arr($i) $idx $idx $blk_x]
         set Post::($post_object,$evt_blk_list) [array get evt_blk_list_arr]
        }
       }
      }
      if { [info exists mom_var_x] && [info exists mom_var] } {
       foreach blk_elem $block::($blk_obj,elem_addr_list) {
        block_element::readvalue $blk_elem blk_elem_attr
        if [string match "*$mom_var_x*" $blk_elem_attr(1)] {
         set idx_start [string first "$mom_var_x" $blk_elem_attr(1)]
         set idx_end   [string wordend $blk_elem_attr(1) $idx_start]
         set s1 [string range $blk_elem_attr(1) 0 [expr $idx_start - 1]]
         set s2 [string range $blk_elem_attr(1) $idx_end end]
         set blk_elem_attr(1) ${s1}${mom_var}${s2}
         block_element::setvalue $blk_elem blk_elem_attr
         block_element::DefaultValue $blk_elem blk_elem_attr
        }
       }
       unset mom_var_x
       unset mom_var
      }
     }
    }
   }
  }
 }

#=======================================================================
proc PB_CreateCopyOfPui { OLD_PUI_FILE NEW_PUI_FILE NEW_DEF_FILE NEW_TCL_FILE } {
  upvar $OLD_PUI_FILE old_pui_file
  upvar $NEW_PUI_FILE new_pui_file
  upvar $NEW_DEF_FILE new_def_file
  upvar $NEW_TCL_FILE new_tcl_file
  set old_id [open "$old_pui_file" r]
  set new_id [open "$new_pui_file" w]
  fconfigure $new_id -translation lf
  set event_handler 0
  while { [gets $old_id line] >= 0 } \
  {
   switch $line \
   {
    "## POST EVENT HANDLER START" \
    {
     set event_handler 1
    }
    "## POST EVENT HANDLER END" \
    {
     set event_handler 0
     puts $new_id $line
    }
    default \
    {
     if { !$event_handler } \
     {
      puts $new_id $line
     }
    }
   }
   if { $event_handler == 1} \
   {
    puts $new_id $line
    set file_name $new_def_file
    set file_name [file tail $file_name]
    puts $new_id "def_file  $file_name"
    set file_name $new_tcl_file
    set file_name [file tail $file_name]
    puts $new_id "tcl_file  $file_name"
    set event_handler 2
   }
  }
  close $old_id
  close $new_id
 }

#=======================================================================
proc PB_file_FindTclDefOfPui { pui_file TCL_FILE DEF_FILE } {
  upvar $DEF_FILE def_file
  upvar $TCL_FILE tcl_file
  set fid [open "$pui_file" r]
  set dir [file dirname $pui_file]
  set tcl_file ""
  set def_file ""
  set event_handler 0
  while { [gets $fid line] >= 0 } \
  {
   switch $line \
   {
    "## POST EVENT HANDLER START" \
    {
     set event_handler 1
    }
    "## POST EVENT HANDLER END" \
    {
     break
    }
    default \
    {
     if { $event_handler } \
     {
      if [string match "def_file *" $line] {
       set def_file [lindex [split $line] end]
      }
      if [string match "tcl_file *" $line] {
       set tcl_file [lindex [split $line] end]
      }
     }
    }
   }
  }
  if { $tcl_file != "" } { set tcl_file [file join $dir $tcl_file] }
  if { $def_file != "" } { set def_file [file join $dir $def_file] }
  close $fid
 }

#=======================================================================
proc PB_file_GetPostAttr { pui_file MACHINE_TYPE AXIS_OPTION OUTPUT_UNIT } {
  upvar $MACHINE_TYPE machine_type
  upvar $AXIS_OPTION axis_option
  upvar $OUTPUT_UNIT output_unit
  if { [catch {set file_id [open "$pui_file" r]} res ] } {
   return [tk_messageBox -type ok -icon error -message "$res"]
  }
  set machine_type ""
  set output_unit  ""
  set all_attr_found 0
  set mom_kin_start 0
  while { [gets $file_id line] >= 0 } \
  {
   if { $mom_kin_start == 0 } \
   {
    switch $line \
    {
     "## KINEMATIC VARIABLES START" \
     {
      set mom_kin_start 1
     }
     "## KINEMATIC VARIABLES END" \
     {
      break 
     }
     default \
     {
      if { $all_attr_found } \
      {
       break 
      }
     }
    }
   }
   if $mom_kin_start \
   {
    if [string match "*mom_kin_machine_type*" [lindex $line 0]] \
    {
     set machine_type [lindex $line 1]
    }
    if [string match "*mom_kin_output_unit*"  [lindex $line 0]] \
    {
     set output_unit [lindex $line 1]
    }
    if { $machine_type != ""  && \
    $output_unit  != "" } \
    {
     set all_attr_found 1
     break 
    }
   }
  }
  close $file_id
  if { $machine_type == "" } \
  {
   set machine_type "3_axis_mill"
  }
  if { $output_unit == "" } \
  {
   set output_unit  "IN"
  }
  switch $machine_type {
   "3_axis_mill" \
   {
    set machine_type Mill
    set axis_option  3
   }
   "4_axis_head" \
   {
    set machine_type Mill
    set axis_option  4H
   }
   "4_axis_table" \
   {
    set machine_type Mill
    set axis_option  4T
   }
   "5_axis_dual_head" \
   {
    set machine_type Mill
    set axis_option  5HH
   }
   "5_axis_head_table" \
   {
    set machine_type Mill
    set axis_option  5HT
   }
   "5_axis_dual_table" \
   {
    set machine_type Mill
    set axis_option  5TT
   }
   "lathe" \
   {
    set machine_type Lathe
    set axis_option  2
   }
   "wedm" \
   {
    set machine_type Wedme
    set axis_option  2
   }
  }
  switch $output_unit {
   IN {
    set output_unit Inches
   }
   MM {
    set output_unit Millimeters
   }
  }
 }

#=======================================================================
proc PB_CreateDefTclFiles { args } {
  global post_object
  global gPB
  global mom_sys_arr
  if {![info exists post_object]} { return }
  set def_parse_obj $Post::($post_object,def_parse_obj)
  Post::ReadPostOutputFiles $post_object dir pui_file def_file tcl_file
  set pui_file [file join $dir $pui_file]
  set def_file [file join $dir $def_file]
  set tcl_file [file join $dir $tcl_file]
  if { ![info exists gPB(backup_method)]} {
   set gPB(backup_method) "BACKUP_ONE"
  }
  set pui_file_root [file rootname $pui_file]
  set def_file_root [file rootname $def_file]
  set tcl_file_root [file rootname $tcl_file]
  set pui_bck_file $pui_file
  set def_bck_file $def_file
  set tcl_bck_file $tcl_file
  switch $gPB(backup_method) {
   "BACKUP_ONE" {
    if { !$gPB(backup_one_done) } {
     set pui_bck_file [__file_GetNextFileName $pui_file _org]
     set def_bck_file [__file_GetNextFileName $def_file _org]
     set tcl_bck_file [__file_GetNextFileName $tcl_file _org]
     set gPB(backup_one_done) 1
    }
   }
   "BACKUP_ALL" {
    set pui_bck_file [__file_GetNextFileName $pui_file _bck]
    set def_bck_file [__file_GetNextFileName $def_file _bck]
    set tcl_bck_file [__file_GetNextFileName $tcl_file _bck]
   }
  }
  if { $pui_bck_file != "$pui_file" } {
   PB_CreateCopyOfPui pui_file pui_bck_file def_bck_file tcl_bck_file
  }
  if { $def_bck_file != "$def_file" } {
   file copy -force -- $def_file $def_bck_file
  }
  if { $tcl_bck_file != "$tcl_file" } {
   file copy -force -- $tcl_file $tcl_bck_file
  }
  set add_obj_list $Post::($post_object,add_obj_list)
  foreach add_obj $add_obj_list \
  {
   set add_leader_var $address::($add_obj,leader_var)
   if { $add_leader_var != "" } \
   {
    set mom_sys_arr($add_leader_var) $address::($add_obj,add_leader)
   }
  }
  set mom_sys_arr(\$mom_sys_seqnum_start) $mom_sys_arr(seqnum_start)
  set mom_sys_arr(\$mom_sys_seqnum_incr)  $mom_sys_arr(seqnum_incr)
  set mom_sys_arr(\$mom_sys_seqnum_freq)  $mom_sys_arr(seqnum_freq)
  set Post::($post_object,mom_sys_var_list) [array get mom_sys_arr]
  PB_PB2DEF_main def_parse_obj def_file
  PB_PB2TCL_main tcl_file
  PB_pui_WritePuiFile pui_file
 }

#=======================================================================
proc __file_GetNextFileName { file_name bck_ext } {
  set file_root [file rootname $file_name]
  set file_type [file extension $file_name]
  if [file exists $file_name] {
   set bck_file ${file_root}${bck_ext}
   set i 0
   while [file exists ${bck_file}${file_type}] {
    incr i
    set bck_file ${file_root}${bck_ext}$i
   }
   set bck_file ${bck_file}${file_type}
   return $bck_file
   } else {
   return $file_name
  }
 }
