#2
global env

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
proc PB_int_BlockCreateObject { ACT_BLK_OBJ OBJ_INDEX } {
  upvar $ACT_BLK_OBJ act_blk_obj
  upvar $OBJ_INDEX obj_index
  global post_object
  set blk_obj_list $Post::($post_object,blk_obj_list)
  set obj_index [lsearch $blk_obj_list $act_blk_obj]
  if {$obj_index == ""}\
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
   set Post::($post_object,cmd_blk_list) $cmd_blk_list
   set cmd_obj [lindex $cmd_blk_list $obj_index]
   PB_int_UpdateCommandAdd cmd_obj
  } else \
  {
   set cmd_obj_attr(0) "PB_CMD_custom_command"
   set cmd_obj_attr(1) ""
   PB_pps_CreateCommand cmd_obj_attr cmd_obj
   lappend cmd_blk_list $cmd_obj
   set Post::($post_object,cmd_blk_list) $cmd_blk_list
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
  set Post::($post_object,cmd_blk_list) $cmd_blk_list
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
  set cmd_blk_list $Post::($post_object,cmd_blk_list)
  if { $cmd_blk_obj } \
  {
   set index [lsearch $cmd_blk_list $cmd_blk_obj]
   set cmd_blk_list [lreplace $cmd_blk_list $index $index]
  }
  set ret_code 0
  PB_com_RetObjFrmName cmd_blk_name cmd_blk_list ret_code
  return $ret_code
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
proc PB_int_BlockCutObject { ACTIVE_BLK_OBJ OBJ_INDEX } {
  upvar $ACTIVE_BLK_OBJ active_blk_obj
  upvar $OBJ_INDEX obj_index
  global post_object
  set blk_obj_list $Post::($post_object,blk_obj_list)
  foreach blk_elem_obj $block::($active_blk_obj,elem_addr_list) \
  {
   set add_obj $block_element::($blk_elem_obj,elem_add_obj)
   address::DeleteFromBlkElemList $add_obj blk_elem_obj
  }
  set blk_obj_list [lreplace $blk_obj_list $obj_index $obj_index]
  set Post::($post_object,blk_obj_list) $blk_obj_list
  if { $obj_index == [llength $blk_obj_list]} \
  {
   incr obj_index -1
  }
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
  set word "Command"
  PB_int_RetMOMVarAsscAddress word cmd_proc_list
  set act_index [expr $obj_index + 3]
  set cmd_proc_list [lreplace $cmd_proc_list $act_index $act_index]
  PB_int_RetMOMVarDescAddress word cmd_proc_desc_list
  set cmd_proc_desc_list [lreplace $cmd_proc_desc_list $act_index $act_index]
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
    tk_messageBox -type ok -icon error\
    -message "Object Name Exists...Paste Invalid"
    return
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
  set Post::($post_object,cmd_blk_list) $cmd_blk_list
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
  set cmd_proc_list [linsert $cmd_proc_list $act_index $proc_name]
  PB_int_RetMOMVarDescAddress word cmd_proc_desc_list
  set cmd_proc_desc_list [linsert $cmd_proc_desc_list $act_index \
  "Custom Command"]
  PB_int_UpdateMOMVarDescAddress word cmd_proc_desc_list
  PB_int_UpdateMOMVarOfAddress word cmd_proc_list
 }

#=======================================================================
proc PB_int_BlockPasteObject { BUFF_BLK_OBJ OBJ_INDEX } {
  upvar $BUFF_BLK_OBJ buff_blk_obj
  upvar $OBJ_INDEX obj_index
  global post_object
  set blk_obj_list $Post::($post_object,blk_obj_list)
  set count [llength $blk_obj_list]
  if { $count } \
  {
   set block_name $block::($buff_blk_obj,block_name)
   PB_com_RetObjFrmName block_name blk_obj_list ret_code
   if {$ret_code}\
   {
    tk_messageBox -type ok -icon error\
    -message "Object Name Exists...Paste Invalid"
    return
   }
  }
  if {$obj_index == ""}\
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
    tk_messageBox -type ok -icon error\
    -message "Object Name Exists...Paste Invalid"
    return
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
  global mach_type
  global axisoption
  set add_obj_list $Post::($post_object,add_obj_list)
  foreach add_obj $add_obj_list \
  {
   address::readvalue $add_obj add_obj_attr
   set add_name $add_obj_attr(0)
   set addr_fmt_obj $add_obj_attr(1)
   set addr_fmt_name $format::($addr_fmt_obj,for_name)
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
   set gpb_addr_var($add_name,zero_format) $add_obj_attr(11)
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
  set mom_sys_arr(seqnum_incr) $seq_params(increment)
  set mom_sys_arr(seqnum_freq) $seq_params(frequency)
  set mom_sys_arr(Word_Seperator) $Post::($post_object,word_sep)
  set mom_sys_arr(End_of_Block) $Post::($post_object,end_of_line)
  set Post::($post_object,mom_sys_var_list) [array get mom_sys_arr]
  set Post::($post_object,def_mom_sys_var_list) [array get mom_sys_arr]
  PB_mach_RetMachineToolAttr mom_kin_var
  PB_com_GetMachAxisType mom_kin_var mach_type axisoption
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
proc PB_int_CreateMseqAddObj { ADD_OBJ } {
  upvar $ADD_OBJ add_obj
  PB_adr_InitAdrObj add_obj_attr
  set add_obj_attr(0) "mseq_dummy"
  set add_obj [new address]
  address::setvalue $add_obj add_obj_attr
  address::DefaultValue $add_obj add_obj_attr
 }

#=======================================================================
proc PB_int_CreateNewAddress { ADD_NAME FORMAT_NAME ADD_OBJ ADD_INDEX } {
  upvar $ADD_NAME add_name
  upvar $FORMAT_NAME format_name
  upvar $ADD_OBJ add_obj
  upvar $ADD_INDEX add_index
  global post_object
  PB_adr_InitAdrObj add_obj_attr
  set add_obj_attr(0) $add_name
  PB_adr_RetAddressObjList add_obj_list
  PB_adr_GetAddressNameList add_obj_list add_name_list
  PB_com_SetDefaultName add_name_list add_obj_attr
  PB_fmt_RetFormatObjs fmt_obj_list
  PB_com_RetObjFrmName format_name fmt_obj_list fmt_obj
  set add_obj_attr(1) $fmt_obj
  PB_adr_CreateAdrObj add_obj_attr add_obj
  set mseq_attr(0) "\$mom_usd_add_var"
  set mseq_attr(1) 0
  set mseq_attr(2) "User Defined Address"
  set mseq_attr(3) $add_index
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
    tk_messageBox -type ok -icon error\
    -message "Object Name Exists...Paste Invalid"
    return
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
  ListingFile::setvalue_from_pui $object obj_attr
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
  PB_blk_GetCmdNamelist cmd_blk_list cmd_name_list
  PB_com_SetDefaultName cmd_name_list cmd_obj_attr
  PB_pps_CreateCommand cmd_obj_attr cmd_obj
  lappend cmd_blk_list $cmd_obj
  set Post::($post_object,cmd_blk_list) $cmd_blk_list
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
  format::readvalue $format_obj for_obj_attr
  PB_int_ReturnInputValue app_text for_obj_attr(1) inp_value
  PB_fmt_RetFmtOptVal for_obj_attr inp_value value
  set dis_attr(1) $value
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
    "Numeral" {
     set inp_value 1.234
    }
    "Text String" {
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
     "Numeral" {
      set inp_value 1.234
     }
     "Text String" {
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
   if { [string match "mom_kin*" $kin_var] } \
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
   if { [string match "mom_kin*" $mom_var] } \
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
  set post_blk_list $Post::($post_object,post_blk_list)
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
  global post_object
  set zero_format $Post::($post_object,zero_format)
  if { $zero_format == $fmt_obj } \
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
  set ret_code 0
  set std_pui_id FP1
  set pui_file_id FP2
  set std_pui_file $env(PB_HOME)/pblib/$temp_pui_file
  PB_com_ReadPuiFile std_pui_file std_pui_id post_object
  PB_com_ReadPuiFile pui_file_name pui_file_id old_post_object
  PB_pui_PartConversion post_object old_post_object
  set ret_code [PB_PostObjects $post_object]
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
  }
  PB_int_AddCustomCmds
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
   PB_pps_CreateCommand cmd_obj_attr cmd_obj
   lappend cmd_blk_list $cmd_obj
   set Post::($post_object,cmd_blk_list) $cmd_blk_list
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
proc PB_Start { pui_file_name args } {
  global post_object
  global env
  set ret_code 0
  set pui_file_id FP2
  set cdl_file_id FP3
  PB_com_ReadPuiFile pui_file_name pui_file_id post_object
  set ret_code [PB_PostObjects $post_object]
  return $ret_code
 }

#=======================================================================
proc PB_PostObjects { post_object } {
  set def_file_id FP1
  Post::ReadPostFiles $post_object dir def_file tcl_file
  set def_file [file join $dir "$def_file"]
  if { [file exists "$def_file"] == 0} \
  {
   tk_messageBox -type ok -icon error -message "Cannot Open $def_file"
   return 1
  }
  set tcl_file [file join $dir "$tcl_file"]
  if { [file exists "$tcl_file"] == 0} \
  {
   tk_messageBox -type ok -icon error\
   -message "Cannot Open $tcl_file"
   return 1
  }
  PB_com_ReadDfltDefFile def_file def_file_id post_object
  PB_pps_CreateTclFileObjs post_object
  PB_seq_CreateSequences post_object
  PB_int_DefineUIGlobVar
  return 0
 }

#=======================================================================
proc PB_CreateDefTclFiles { args } {
  global post_object
  global mom_sys_arr
  if {![info exists post_object]} { return }
  set def_parse_obj $Post::($post_object,def_parse_obj)
  Post::ReadPostOutputFiles $post_object dir pui_file def_file tcl_file
  set pui_file [file join $dir $pui_file]
  set def_file [file join $dir $def_file]
  set tcl_file [file join $dir $tcl_file]
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
  set mom_sys_arr(\$mom_sys_seqnum_incr) $mom_sys_arr(seqnum_incr)
  set mom_sys_arr(\$mom_sys_seqnum_freq) $mom_sys_arr(seqnum_freq)
  set Post::($post_object,mom_sys_var_list) [array get mom_sys_arr]
  PB_PB2DEF_main def_parse_obj def_file
  PB_PB2TCL_main tcl_file
  PB_pui_WritePuiFile pui_file
 }
