UI_PB_AddPatchMsg "2002.5.1" "<10-01-06>  Initialize flags for VNC parsing to fix VNC re-save problem"

#=======================================================================
proc PB_file_exists { file_name } {
  set ext [file extension $file_name]
  set file_list [glob -directory [file dirname $file_name] -nocomplain *${ext}]
  UI_PB_debug_ForceMsg "@@@@@ PB_file_exists: $file_name  $ext  $file_list ==> [file exists $file_name] -> [lsearch $file_list $file_name]"
  if { [lsearch $file_list $file_name] >= 0  &&  [file exists $file_name] } {
   return 1
   } else {
   return 0
  }
 }

#=======================================================================
proc PB_file_name { file_string } {
  return [file rootname [file tail $file_string]]
 }

#=======================================================================
proc PB_file_fconfigure { fid } {
  global tcl_version
  if { $tcl_version != "8.0" } {
   fconfigure $fid -translation lf;# -encoding "utf-8"
   } else {
   fconfigure $fid -translation lf
  }
 }

#=======================================================================
proc PB_file_configure_output_file { file_name } {
  set fid [open "$file_name" w]
  PB_file_fconfigure $fid
  return $fid
 }

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
proc PB_int_FormatCreateObject { ACT_FMT_OBJ FormatObjAttr OBJ_INDEX } {
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
proc PB_int_CreateNewEventElement { BLOCK_OBJ EVT_ELEM_OBJ { event_obj NULL } } {
  upvar $BLOCK_OBJ block_obj
  upvar $EVT_ELEM_OBJ evt_elem_obj
  set elem_obj_attr(0) $block::($block_obj,block_name)
  set elem_obj_attr(1) $block_obj
  PB_evt_CreateEventElement evt_elem_obj elem_obj_attr
  if {$event_obj != "NULL"} {
   set ::event_element::($evt_elem_obj,event_obj) $event_obj
  }
  unset elem_obj_attr
 }

#=======================================================================
proc PB_int_CreateNewEventElementByAttr { BLOCK_OBJ EVT_ELEM_OBJ \
  OBJ_ATTR { event_obj NULL } } {
  upvar $BLOCK_OBJ block_obj
  upvar $EVT_ELEM_OBJ evt_elem_obj
  upvar $OBJ_ATTR  elem_obj_attr
  set elem_obj_attr(0) $block::($block_obj,block_name)
  set elem_obj_attr(1) $block_obj
  PB_evt_CreateEventElement evt_elem_obj elem_obj_attr
  if {$event_obj != "NULL"} {
   set ::event_element::($evt_elem_obj,event_obj) $event_obj
  }
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
  if { $ret_code == 0 } { ;# No obj created
   if { $cmd_blk_obj > 0 && \
    [info exists command::($cmd_blk_obj,condition_flag)] && \
   $command::($cmd_blk_obj,condition_flag) == 1 } \
   {
    global gPB
    if { ! [string match "$gPB(condition_cmd_prefix)*" $cmd_blk_name] } \
    {
     return 4
    }
   }
   return 0
   } else { ;# New obj created
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
proc PB_int_DisplayFormatValue { FMT_NAME ADD_NAME INP_VALUE DIS_VALUE } {
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
  PB_com_DeleteObject $fmt_obj
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
  PB_int_RemoveCmdProcFromList active_cmd_obj
  set cmd_blk_list $Post::($post_object,cmd_blk_list)
  set cmd_blk_list [lreplace $cmd_blk_list $obj_index $obj_index]
  set Post::($post_object,cmd_blk_list) $cmd_blk_list
  if { $obj_index == [llength $cmd_blk_list]} \
  {
   incr obj_index -1
  }
 }

#=======================================================================
proc PB_int_RemoveCmdProcFromList { CMD_OBJ } {
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
  global post_object gPB
  set cmd_blk_list $Post::($post_object,cmd_blk_list)
  set count [llength $cmd_blk_list]
  if { $count } \
  {
   set cmd_name $command::($buff_cmd_obj,name)
   PB_com_RetObjFrmName cmd_name cmd_blk_list ret_code
   if {$ret_code}\
   {
    return [tk_messageBox -type ok -icon error\
    -message "$gPB(msg,block_format_command,paste_err)"]
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
  PB_com_DeleteObject $buff_cmd_obj
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
  global post_object gPB
  set blk_obj_list $Post::($post_object,blk_obj_list)
  set count [llength $blk_obj_list]
  if { $count } \
  {
   set block_name $block::($buff_blk_obj,block_name)
   PB_com_RetObjFrmName block_name blk_obj_list ret_code
   if {$ret_code}\
   {
    return [tk_messageBox -type ok -icon error\
    -message "$gPB(msg,block_format_command,paste_err)"]
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
  PB_com_DeleteObject $buff_blk_obj
 }

#=======================================================================
proc PB_int_FormatPasteObject { BUFF_OBJ_ATTR OBJ_INDEX } {
  upvar $BUFF_OBJ_ATTR buff_obj_attr
  upvar $OBJ_INDEX obj_index
  global paOption
  global post_object gPB
  set fmt_obj_list $Post::($post_object,fmt_obj_list)
  set count [llength $fmt_obj_list]
  if { $count }\
  {
   PB_com_RetObjFrmName buff_obj_attr(0) fmt_obj_list ret_code
   if {$ret_code}\
   {
    return [tk_messageBox -type ok -icon error\
    -message "$gPB(msg,block_format_command,paste_err)"]
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
proc PB_int_RetDefSimVars { DEF_MOM_SIM_VAR } {
  upvar $DEF_MOM_SIM_VAR def_mom_sim_var
  global post_object
  array set def_mom_sim_var $Post::($post_object,def_mom_sim_var_list)
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
  global mom_sim_arr
  global machType ;#<12-13-01 gsl> was mach_type that conflicts with parm used on "New" dialog.
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
   set gpb_addr_var($add_name,name)         $add_obj_attr(0)
   set gpb_addr_var($add_name,fmt_name)     $addr_fmt_name
   set gpb_addr_var($add_name,modal)        $add_obj_attr(2)
   set gpb_addr_var($add_name,modl_status)  $add_obj_attr(3)
   set gpb_addr_var($add_name,add_max)      $add_obj_attr(4)
   set gpb_addr_var($add_name,max_status)   $add_obj_attr(5)
   set gpb_addr_var($add_name,add_min)      $add_obj_attr(6)
   set gpb_addr_var($add_name,min_status)   $add_obj_attr(7)
   set gpb_addr_var($add_name,leader_name)  $add_obj_attr(8)
   set gpb_addr_var($add_name,trailer)      $add_obj_attr(9)
   set gpb_addr_var($add_name,trail_status) $add_obj_attr(10)
   set gpb_addr_var($add_name,incremental)  $add_obj_attr(11)
   set gpb_addr_var($add_name,zero_format) $add_obj_attr(12)
   set gpb_addr_var($add_name,zero_format_name) $add_obj_attr(13)
   set gpb_addr_var($add_name,is_dummy)         $add_obj_attr(14)
   set gpb_addr_var($add_name,is_external)      $add_obj_attr(15)
   unset add_obj_attr
  }
  set fmt_obj_list $Post::($post_object,fmt_obj_list)
  foreach fmt_obj $fmt_obj_list \
  {
   format::readvalue $fmt_obj fmt_obj_attr
   set fmt_name $fmt_obj_attr(0)
   set gpb_fmt_var($fmt_name,name)        $fmt_obj_attr(0)
   set gpb_fmt_var($fmt_name,dtype)       $fmt_obj_attr(1)
   set gpb_fmt_var($fmt_name,plus_status) $fmt_obj_attr(2)
   set gpb_fmt_var($fmt_name,lead_zero)   $fmt_obj_attr(3)
   set gpb_fmt_var($fmt_name,trailzero)   $fmt_obj_attr(4)
   set gpb_fmt_var($fmt_name,integer)     $fmt_obj_attr(5)
   set gpb_fmt_var($fmt_name,decimal)     $fmt_obj_attr(6)
   set gpb_fmt_var($fmt_name,fraction)    $fmt_obj_attr(7)
   set gpb_fmt_var($fmt_name,is_dummy)    $fmt_obj_attr(8)
   set gpb_fmt_var($fmt_name,is_external) $fmt_obj_attr(9)
   unset fmt_obj_attr
  }
  set Post::($post_object,def_gpb_fmt_var)  [array get gpb_fmt_var]
  set Post::($post_object,def_gpb_addr_var) [array get gpb_addr_var]
  array set mom_sys_arr $Post::($post_object,mom_sys_var_list)
  array set seq_params $Post::($post_object,sequence_param)
  set mom_sys_arr(seqnum_block) $seq_params(block)
  set mom_sys_arr(seqnum_start) $seq_params(start)
  set mom_sys_arr(seqnum_incr)  $seq_params(increment)
  set mom_sys_arr(seqnum_freq)  $seq_params(frequency)
  set mom_sys_arr(seqnum_max)   $seq_params(maximum)
  set mom_sys_arr(Word_Seperator) $Post::($post_object,word_sep)
  set mom_sys_arr(End_of_Block) $Post::($post_object,end_of_line)
  global ads_cdl_arr
  PB_com_unset_var ads_cdl_arr
  set ads_cdl_arr(type_other)     1
  set ads_cdl_arr(type_inherit)   2
  set ads_cdl_arr($ads_cdl_arr(type_other),cdl_list)   [list]
  set ads_cdl_arr($ads_cdl_arr(type_inherit),cdl_list) [list]
  if { [info exists Post::($post_object,UDE_File_Name)] } {
   set ude $Post::($post_object,UDE_File_Name)
   if { ![string match $ude ""] } {
    set ude_list [list]
    foreach one $ude {
     lappend ude_list [file tail $one]
    }
    set pst_name [file tail $Post::($post_object,post_name)]
    set cdl_name [lindex [split $pst_name .] 0].cdl
    UI_PB_debug_ForceMsg "@@@@@ Own CDL search: $cdl_name =>$ude_list<"
    if 0 {
     if { [lsearch $ude_list $cdl_name] >= 0 && \
      [string match [lindex $ude_list end] $cdl_name] } {
      set indx end
      set ude_list [lreplace $ude_list $indx $indx]
      set mom_sys_arr(Own_UDE) 1
      regsub $cdl_name [lindex $ude $indx] "" mom_sys_arr(OWN_CDL_File_Folder)
      set ude [lreplace $ude $indx $indx]
      } else {
      set mom_sys_arr(Own_UDE) 0
      set mom_sys_arr(OWN_CDL_File_Folder) "\$UGII_CAM_USER_DEF_EVENT_DIR/"
     }
     } else {
     if { ![info exists mom_sys_arr(Own_UDE)] || !$mom_sys_arr(Own_UDE) } {
      set mom_sys_arr(Own_UDE) 0
      set mom_sys_arr(OWN_CDL_File_Folder) "\$UGII_CAM_USER_DEF_EVENT_DIR/"
     }
    }
    set mom_sys_arr(Inherit_UDE) 0
    set mom_sys_arr(PST_File_Name) ""
    set mom_sys_arr(PST_File_Folder) "\$UGII_CAM_POST_DIR/"
    while { [string match "*.def*" $ude_list] } {
     set indx [lsearch -glob $ude_list "*.def"]
     set cdl_file [file rootname [lindex $ude_list $indx]].cdl
     if { [lsearch $ude_list $cdl_file] != -1 } {
      set mom_sys_arr(PST_File_Name) [file rootname [lindex $ude_list $indx]]
      regsub [lindex $ude_list $indx] [lindex $ude $indx] "" mom_sys_arr(PST_File_Folder)
      UI_PB_debug_ForceMsg "@@@@@ Inherited CDL: =>$mom_sys_arr(PST_File_Name)<  dir: =>$mom_sys_arr(PST_File_Folder)<"
      UI_PB_debug_ForceMsg "      ude_list: =>$ude_list<"
      UI_PB_debug_ForceMsg "           ude: =>$ude<"
      if 0 {
       set ude_list [lreplace $ude_list [expr $indx - 1] $indx]
       set ude [lreplace $ude [expr $indx - 1] $indx]
      }
      set ude_list [lreplace $ude_list $indx $indx]
      set ude      [lreplace $ude $indx $indx]
      set idx [lsearch $ude_list $cdl_file]
      set ude_list [lreplace $ude_list $idx $idx]
      set ude      [lreplace $ude $idx $idx]
      set mom_sys_arr(Inherit_UDE) 1
      if { ![string match "*/" $mom_sys_arr(PST_File_Folder)] } {
       set mom_sys_arr(PST_File_Folder) [string trim $mom_sys_arr(PST_File_Folder)]
       if { [string length $mom_sys_arr(PST_File_Folder)] > 0 } {
        append mom_sys_arr(PST_File_Folder) "/"
       }
      }
      lappend ads_cdl_arr($ads_cdl_arr(type_inherit),cdl_list) \
      "$mom_sys_arr(PST_File_Folder)$mom_sys_arr(PST_File_Name)"
      } else {
      set deff [lindex $ude $indx]
      if { [lsearch $ads_cdl_arr($ads_cdl_arr(type_other),cdl_list) $deff] < 0 } {
       set mom_sys_arr(UDE_File_Name) $deff
       set mom_sys_arr(Include_UDE) 1
       lappend ads_cdl_arr($ads_cdl_arr(type_other),cdl_list) $deff
      }
      set ude_list [lreplace $ude_list $indx $indx]
      set ude      [lreplace $ude $indx $indx] ;#<03-24-2014 gsl> Added this statement
     }
    }
    if { $mom_sys_arr(Inherit_UDE) } {
     set mom_sys_arr(inherit_cdl_list) $ads_cdl_arr($ads_cdl_arr(type_inherit),cdl_list)
    }
    if { ![info exists mom_sys_arr(Include_UDE)]  ||  $mom_sys_arr(Include_UDE) == 0 } {
     set mom_sys_arr(UDE_File_Name) "\$UGII_CAM_USER_DEF_EVENT_DIR/ude.cdl"
    }
    foreach other_cdl $ude {
     if { [lsearch $ads_cdl_arr($ads_cdl_arr(type_other),cdl_list) $other_cdl] < 0 } {
      set mom_sys_arr(UDE_File_Name) $other_cdl
      set mom_sys_arr(Include_UDE) 1
      lappend ads_cdl_arr($ads_cdl_arr(type_other),cdl_list) $other_cdl
     }
    }
    foreach fo $ads_cdl_arr($ads_cdl_arr(type_other),cdl_list) {
     set idx [lsearch $Post::($post_object,UDE_File_Name) $fo]
     if { $idx >= 0 } {
      set tarr($idx) $fo
     }
    }
    if [info exists tarr] {
     set ads_cdl_arr($ads_cdl_arr(type_other),cdl_list) [list]
     foreach { idx fo } [array get tarr] {
      lappend ads_cdl_arr($ads_cdl_arr(type_other),cdl_list) $fo
     }
    }
    if { $mom_sys_arr(Include_UDE) } {
     set mom_sys_arr(other_cdl_list) $ads_cdl_arr($ads_cdl_arr(type_other),cdl_list)
    }
   }
   } else {
   set mom_sys_arr(Inherit_UDE) 0
   set mom_sys_arr(PST_File_Name) ""
   set mom_sys_arr(PST_File_Folder) ""
   if { ![info exists mom_sys_arr(Own_UDE)] || !$mom_sys_arr(Own_UDE) } {
    set mom_sys_arr(Own_UDE) 0
    set mom_sys_arr(OWN_CDL_File_Folder) ""
    set mom_sys_arr(UDE_File_Name) \
    "\$UGII_CAM_USER_DEF_EVENT_DIR/ude.cdl"
   }
   set mom_sys_arr(Include_UDE)   0
  }
  if { ![info exists mom_sys_arr(Own_UDE)] || !$mom_sys_arr(Own_UDE) } {
   set mom_sys_arr(Own_UDE) 0
   set mom_sys_arr(UDE_File_Name) \
   "\$UGII_CAM_USER_DEF_EVENT_DIR/ude.cdl"
   if { $mom_sys_arr(Include_UDE) && [llength $ads_cdl_arr($ads_cdl_arr(type_other),cdl_list)] == 0 } {
    lappend ads_cdl_arr($ads_cdl_arr(type_other),cdl_list) $mom_sys_arr(UDE_File_Name)
   }
  }
  UI_PB_debug_ForceMsg "@@@@@ Other CDL: $ads_cdl_arr($ads_cdl_arr(type_other),cdl_list) <"
  UI_PB_debug_ForceMsg "@@@@@ Own CDL: $mom_sys_arr(Own_UDE) =>$Post::($post_object,UDE_File_Name)"
  PB_mthd_RetMachineToolAttr mom_kin_var
  set kin_machine_type $mom_kin_var(\$mom_kin_machine_type)
  PB_com_GetMachAxisType $kin_machine_type machType axisoption
  if { ! [info exists mom_sys_arr(\$linearization_method)] && \
   ! [string match "*_wedm" $kin_machine_type] && \
   ! [string match "3_axis_*" $kin_machine_type] } {
   set mom_sys_arr(\$linearization_method) "angle"
  }
  set Post::($post_object,mom_sys_var_list)     [array get mom_sys_arr]
  set Post::($post_object,def_mom_sys_var_list) [array get mom_sys_arr]
  PB_mthd_RetSimulationAttr mom_sim_var
 }

#=======================================================================
proc PB_int_GCodePageAttributes { G_CODES_DESC G_CODES_VAR } {
  upvar $G_CODES_DESC g_codes_desc
  upvar $G_CODES_VAR g_codes_var
  global post_object
  array set g_codes_var  $Post::($post_object,g_codes)
  array set g_codes_desc $Post::($post_object,g_codes_desc)
  if 0 {
   array set g_codes_mom_var $Post::($post_object,g_codes)
   array set g_codes_desc $Post::($post_object,g_codes_desc)
   array set mom_sys_var_arr $Post::($post_object,mom_sys_var_list)
   set arr_size [array size g_codes_mom_var]
   for {set count 0} {$count < $arr_size} {incr count}\
   {
    set g_codes_var($count) $g_codes_mom_var($count)
   }
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
  global post_object gPB
  set add_obj_list $Post::($post_object,add_obj_list)
  set count [llength $add_obj_list]
  if { $count }\
  {
   PB_com_RetObjFrmName buff_obj_attr(0) add_obj_list ret_code
   if {$ret_code}\
   {
    return [tk_messageBox -type ok -icon error\
    -message "$gPB(msg,block_format_command,paste_err)"]
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
proc PB_int_AddNewBlockElemObj { BLK_ELEM_ADR_NAME BLK_ELEM_MOM_VAR \
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
  set word "Operator_Message"
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
   set blk_name [PB_com_GetObjName $comment_blk]
   if { [string length $blk_name] > 0 } \
   {
    set word "Operator_Message"
    PB_int_RetMOMVarAsscAddress word comm_blk_namelist
    PB_int_RetMOMVarDescAddress word comm_blk_desclist
    set index [lsearch $comm_blk_namelist $blk_name]
    set comm_blk_namelist [lreplace $comm_blk_namelist $index $index]
    set comm_blk_desclist [lreplace $comm_blk_desclist $index $index]
    PB_int_UpdateMOMVarDescAddress word comm_blk_desclist
    PB_int_UpdateMOMVarOfAddress word comm_blk_namelist
   }
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
proc PB_int_CreateFuncBlkElem { FUNC_ELEM_NAME FUNC_BLK_ELEM } {
  upvar $FUNC_ELEM_NAME func_elem_name
  upvar $FUNC_BLK_ELEM func_blk_elem
  global post_object
  set func_blk_list $Post::($post_object,function_blk_list)
  set func_obj 0
  PB_com_RetObjFrmName func_elem_name func_blk_list func_obj
  PB_blk_CreateFuncBlkElem func_elem_name func_obj func_blk_elem
 }

#=======================================================================
proc PB_int_CreateNewFuncBlkElem { FUNC_ELEM_NAME FUNC_BLK_ELEM } {
  upvar $FUNC_ELEM_NAME func_elem_name
  upvar $FUNC_BLK_ELEM func_blk_elem
  global post_object
  set func_obj_attr(0) $func_elem_name
  PB_int_RetFunctionNames func_name_list
  PB_com_SetDefaultName func_name_list func_obj_attr
  PB_int_CreateFunctionObj func_obj_attr func_obj
  PB_blk_CreateFuncBlkElem func_elem_name func_obj func_blk_elem
 }

#=======================================================================
proc PB_int_CreateFunctionObj { FUNC_OBJ_ATTR FUNC_OBJ } {
  upvar $FUNC_OBJ_ATTR func_obj_attr
  upvar $FUNC_OBJ func_obj
  global post_object
  Post::GetObjList $post_object function func_blk_list
  if [info exists func_obj] { unset func_obj }
  foreach cc $func_blk_list {
   function::readvalue $cc attr
   if { [string compare $attr(0) $func_obj_attr(0)] == 0 } \
   {
    set func_obj $cc
    break
   }
  }
  if { ![info exists func_obj] } \
  {
   set func_obj [new function]
   lappend func_blk_list $func_obj
   Post::SetObjListasAttr $post_object func_blk_list
  }
  function::setvalue $func_obj func_obj_attr
  function::DefaultValue $func_obj func_obj_attr
 }

#=======================================================================
proc PB_int_CreateCopyAFuncBlk { FUNC_OBJ NEW_BLK_OBJ } {
  upvar $FUNC_OBJ func_obj
  upvar $NEW_BLK_OBJ new_blk_obj
  global post_object
  PB_int_CreateFuncFrmFuncObj func_obj new_func_obj obj_index
  PB_int_CreateFuncBlkFromFunc new_func_obj new_blk_obj
 }

#=======================================================================
proc PB_int_CreateFuncBlkFromFunc { FUNC_OBJ NEW_BLK_OBJ } {
  upvar $FUNC_OBJ func_obj
  upvar $NEW_BLK_OBJ new_blk_obj
  set func_elem_name $function::($func_obj,id)
  PB_blk_CreateFuncBlkElem func_elem_name func_obj func_blk_elem
  PB_blk_CreateFuncBlkObj func_elem_name func_blk_elem new_blk_obj
 }

#=======================================================================
proc PB_int_CreateFuncFrmFuncObj { SRC_FUNC_OBJ NEW_FUNC_OBJ OBJ_INDEX } {
  upvar $SRC_FUNC_OBJ src_func_obj
  upvar $NEW_FUNC_OBJ new_func_obj
  upvar $OBJ_INDEX obj_index
  PB_int_RetFunctionBlks func_blk_list
  PB_int_RetFunctionNames func_name_list
  if { $src_func_obj == 0 || $src_func_obj == "" } \
  {
   set func_obj_attr(0) "New_Macro"
   PB_com_SetDefaultName func_name_list func_obj_attr
   set obj_index 0
  } else \
  {
   set func_obj_attr(0) $function::($src_func_obj,id)
   PB_int_RetFunctionNames func_name_list
   PB_com_SetDefaultName func_name_list func_obj_attr
   set func_obj_attr(1) $function::($src_func_obj,disp_name)
   set func_obj_attr(2) $function::($src_func_obj,func_start)
   set func_obj_attr(3) $function::($src_func_obj,separator)
   set func_obj_attr(4) $function::($src_func_obj,func_end)
   set func_obj_attr(7) $function::($src_func_obj,output_param_name_flag)
   set func_obj_attr(8) $function::($src_func_obj,output_link_chars)
   set func_obj_attr(6) [list]
   foreach param_obj $function::($src_func_obj,param_list) \
   {
    function::param_elem::readvalue $param_obj param_attr
    set new_param [new function::param_elem]
    function::param_elem::setvalue $new_param param_attr
    function::param_elem::DefaultValue $new_param param_attr
    function::param_elem::RestoreValue $new_param
    lappend func_obj_attr(6) $new_param
   }
   set obj_index [lsearch $func_blk_list $src_func_obj]
   incr obj_index
  }
  set new_func_obj [new function]
  function::setvalue     $new_func_obj func_obj_attr
  function::DefaultValue $new_func_obj func_obj_attr
  set func_blk_list [linsert $func_blk_list $obj_index $new_func_obj]
  global post_object
  Post::SetObjListasAttr $post_object func_blk_list
 }

#=======================================================================
proc PB_int_CreateFuncBlk { ELEM_NAME BLK_ELEM_OBJ BLK_OBJ } {
  upvar $ELEM_NAME elem_name
  upvar $BLK_ELEM_OBJ blk_elem_obj
  upvar $BLK_OBJ blk_obj
  PB_blk_CreateFuncBlkObj elem_name blk_elem_obj blk_obj
 }

#=======================================================================
proc PB_int_RetFunctionBlks { FUNC_BLK_LIST } {
  upvar $FUNC_BLK_LIST func_blk_list
  global post_object
  set func_blk_list $Post::($post_object,function_blk_list)
 }

#=======================================================================
proc PB_int_RetFunctionNames { FUNC_NAME_LIST } {
  upvar $FUNC_NAME_LIST func_name_list
  global post_object
  set func_name_list [list]
  foreach func_obj $Post::($post_object,function_blk_list) \
  {
   lappend func_name_list $function::($func_obj,id)
  }
 }

#=======================================================================
proc PB_int_DeleteFuncBlk { FUNC_OBJ } {
  upvar $FUNC_OBJ func_obj
  global post_object
  set func_blk_list $Post::($post_object,function_blk_list)
  set index [lsearch $func_blk_list $func_obj]
  if { $index != -1 } {
   set func_blk_list [lreplace $func_blk_list $index $index]
   set Post::($post_object,function_blk_list) $func_blk_list
  }
  PB_com_DeleteObject $func_obj
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
  PB_com_DeleteObject $cmd_obj
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
proc PB_int_GetAdsFmtValue { ADD_NAME ADS_FMT_ATTR DIS_ATTR } {
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
proc PB_int_GetElemDisplayAttr { ADD_NAME APP_TEXT DIS_ATTR } {
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
  } else \
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
proc PB_int_ReturnInputValue { APP_TEXT FMT_DTYPE INP_VALUE } {
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
proc PB_int_GetGroupWordAddress { IMAGE_NAME IMAGE_TEXT } {
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
proc PB_int_GetNewBlockElement { BASE_ELEMENT INDEX WORD_MOM_VAR } {
  upvar $BASE_ELEMENT base_element
  upvar $INDEX index
  upvar $WORD_MOM_VAR word_mom_var
  PB_blk_AddNewBlkElem base_element index word_mom_var
 }

#=======================================================================
proc PB_int_GetBlockElementAddr { ELEM_ADDRESS BASE_ELEMENT_LIST } {
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
proc PB_int_DbaseRetSeqEvtBlkObj { EVT_OBJ_LIST INDEX } {
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
  global gPB
  if { [info exist ::env(SUB_POST_MODE)] && $::env(SUB_POST_MODE) == 1 } {
   if { [info exists ::env(UNIT_SUB_POST_MODE)] && $::env(UNIT_SUB_POST_MODE) == 1 } {
    global post_object
    set addr_name_list $Post::($post_object,Indep_add_list)
    set tmp_obj_list [list]
    foreach item $addr_name_list {
     PB_int_RetAddrObjFromName item a_obj
     if { $a_obj > 0 } {
      lappend tmp_obj_list $a_obj
     }
    }
    set addr_obj_list $tmp_obj_list
   }
  }
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
   PB_com_DeleteObject $add_obj
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
  global post_object gPB
  if { [info exist ::env(SUB_POST_MODE)] && $::env(SUB_POST_MODE) == 1 } \
  {
   if { [info exists ::env(UNIT_SUB_POST_MODE)] && $::env(UNIT_SUB_POST_MODE) == 1 } {
    set tmp_name_list $Post::($post_object,Indep_fmt_list)
    set fmt_name_list [list]
    set tmp_obj_list [list]
    if { ![string compare "Inches" $gPB(main_post_unit)] } {
     set tmp_lb "MM"
     } else {
     set tmp_lb "I"
    }
    foreach fmt_name $tmp_name_list {
     array set tmp_sys_arr $Post::($post_object,main_sys_var)
     set FPR_fmt_inx [lindex [array names tmp_sys_arr "\$mom_sys_feed_param(*PR,format)"] 0]
     set FPM_fmt_inx [lindex [array names tmp_sys_arr "\$mom_sys_feed_param(*PM,format)"] 0]
     if { ![string compare $fmt_name $tmp_sys_arr($FPR_fmt_inx)] } {
      set fmt_name "Feed_${tmp_lb}PR"
      } elseif { ![string compare $fmt_name $tmp_sys_arr($FPM_fmt_inx)] } {
      set fmt_name "Feed_${tmp_lb}PM"
     }
     unset tmp_sys_arr FPR_fmt_inx FPM_fmt_inx
     lappend fmt_name_list $fmt_name
    }
    foreach item [lsort -dictionary $fmt_name_list] {
     PB_int_RetFmtObjFromName item f_obj
     if { $f_obj > 0 } {
      lappend tmp_obj_list $f_obj
     }
    }
    set fmt_obj_list $tmp_obj_list
   }
  }
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
  array set def_sim_var $Post::($post_object,def_mom_sim_var_list)
  array set def_mom_var $Post::($post_object,def_mom_sys_var_list)
  foreach kin_var $kin_var_list \
  {
   if { [string match "\$mom_kin*" $kin_var] } \
   {
    set kin_var_value($kin_var) $def_kin_var($kin_var)
    } elseif {[string match "\$mom_sim*" $kin_var]} \
   {
    set kin_var_value($kin_var) $def_sim_var($kin_var)
    } else {
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
  array set def_sim_var $Post::($post_object,def_mom_sim_var_list)
  array set def_kin_var $Post::($post_object,def_mom_kin_var_list)
  set no_mom_var [array size mom_var_arr]
  for {set count 0} { $count < $no_mom_var } { incr count } \
  {
   set mom_var $mom_var_arr($count)
   if { [string match "\$mom_kin*" $mom_var] } \
   {
    set mom_var_value($mom_var) $def_kin_var($mom_var)
    } elseif {[string match "\$mom_sim*" $mom_var]} \
   {
    set mom_var_value($mom_var) $def_sim_var($mom_var)
   } else \
   {
    set mom_var_value($mom_var) $def_mom_var($mom_var)
   }
  }
 }

#=======================================================================
proc PB_int_RetDefSIMVarValues { SIM_VAR_LIST SIM_VAR_VALUE } {
  upvar $SIM_VAR_LIST sim_var_list
  upvar $SIM_VAR_VALUE sim_var_value
  global post_object
  array set def_mom_var $Post::($post_object,def_mom_sys_var_list)
  array set def_sim_var $Post::($post_object,def_mom_sim_var_list)
  array set def_kin_var $Post::($post_object,def_mom_kin_var_list)
  foreach sim_var $sim_var_list \
  {
   if { [string match "\$mom_kin*" $sim_var] } \
   {
    set sim_var_value($sim_var) $def_kin_var($sim_var)
    } elseif {[string match "\$mom_sim*" $sim_var]} \
   {
    set sim_var_value($sim_var) $def_sim_var($sim_var)
   } else \
   {
    set sim_var_value($sim_var) $def_mom_var($sim_var)
   }
  }
 }

#=======================================================================
proc PB_int_UpdateMOMVar { MOM_SYS_VAR } {
  upvar $MOM_SYS_VAR mom_sys_var
  global post_object
  set Post::($post_object,mom_sys_var_list) [array get mom_sys_var]
 }

#=======================================================================
proc PB_int_RecreateVNCCommand { args } {
  global gPB mom_sim_arr mom_sys_arr
  global post_object
  PB_output_GetCmdBlkProcs cmd_blk_list cmd_proc_arr
  if { [string match "Standalone" $mom_sys_arr(VNC_Mode)] } {
   set rewrite_cmdlist   [list PB_CMD_vnc____set_nc_definitions \
   PB_CMD_vnc____map_machine_tool_axes \
   PB_CMD_vnc____process_nc_block]
   set old_write_cmdlist [list PB_CMD_vnc____config_nc_definitions \
   PB_CMD_vnc____config_machine_tool_axes \
   PB_CMD_vnc____process_nc_block]
   } else {
   set rewrite_cmdlist   [list PB_CMD_vnc__set_nc_definitions \
   PB_CMD_vnc____map_machine_tool_axes \
   PB_CMD_vnc__process_nc_block]
   set old_write_cmdlist [list PB_CMD_vnc__config_nc_definitions \
   PB_CMD_vnc____config_machine_tool_axes \
   PB_CMD_vnc__process_nc_block]
  }
  Post::GetObjList $post_object command cmd_obj_list
  set gPB(cmd_obj_list) $cmd_obj_list
  if { [info exists gPB(Old_PUI_Version)] && ![PB_is_old_v 6.0.2] } {
   set legacy_reg 1
   } else {
   set legacy_reg 0
  }
  if { [string match "Subordinate" $mom_sys_arr(VNC_Mode)] } {
   set cmd_list [list "PB_CMD_vnc__process_nc_block"]
   } else {
   set cmd_list [list "PB_CMD_vnc____process_nc_block"]
  }
  foreach cmd $cmd_list {
   set gPB(cmd) $cmd
   uplevel #0 {
    if { [llength [info commands $gPB(cmd)]] == 0 } {
     set cmd_attr(0) $gPB(cmd)
     set cmd_attr(1) [list]
     if { [string match "*process_nc_block" $gPB(cmd)] } {
      lappend cmd_attr(1) ""
      lappend cmd_attr(1) "   global mom_sim_o_buffer"
      lappend cmd_attr(1) "   global mom_sim_pre_com_list"
      lappend cmd_attr(1) "   global mom_sim_o_buffer"
      lappend cmd_attr(1) ""
      lappend cmd_attr(1) "   set o_buff \$mom_sim_o_buffer"
      if {[string match "PB_CMD_vnc____process_nc_block" $gPB(cmd)]} {
       set temp_cmd "PB_CMD_vnc__preprocess_nc_block"
       } else {
       set temp_cmd "PB_CMD_vnc____process_nc_block"
      }
      lappend cmd_attr(1) "   if \{\[llength \[info commands $temp_cmd\]\]\} \{"
       lappend cmd_attr(1) "      set o_buff \[PB_SIM_call $temp_cmd\]"
      lappend cmd_attr(1) "  \}"
      lappend cmd_attr(1) ""
      lappend cmd_attr(1) "return \$o_buff"
     }
     PB_pps_CreateCommand cmd_attr cmd_obj
     PB_int_UpdateCommandAdd cmd_obj
    }
   } ;# uplevel
  }
  foreach cmd $rewrite_cmdlist old_cmd $old_write_cmdlist {
   set gPB(old_cmd) $old_cmd
   set gPB(temp_cmd) $cmd
   set gPB(change_cmd) 0
   if { $legacy_reg == 1 } {
    uplevel #0 {
     if { [llength [info commands $gPB(old_cmd)]] == 0 } {
      if { ![string match "*process_nc_block" $gPB(old_cmd)] } {
       if { [info exists ::gPB(old_own_vnc_tag)] && $::gPB(old_own_vnc_tag) } {
        set continue_tag 1
        if { [info exists ::gPB(main_vnc_tag)] && $::gPB(main_vnc_tag) } {
         if { [string match "PB_CMD_vnc__set_nc_definitions" $gPB(temp_cmd)] } {
          set continue_tag 0
         }
         } else {
         if { [string match "PB_CMD_vnc____set_nc_definitions" $gPB(temp_cmd)] } {
          set continue_tag 0
         }
        }
        if { $continue_tag } {
         PB_com_RetObjFrmName gPB(temp_cmd) gPB(cmd_obj_list) cmd_obj
         rename $gPB(temp_cmd) $gPB(old_cmd)
         set command::($cmd_obj,name) $gPB(old_cmd)
         PB_com_RetObjFrmName gPB(old_cmd) gPB(cmd_obj_list) cmd_obj
         set gPB(change_cmd) 1
        }
       }
      }
     }
    } ;# uplevel
    if $gPB(change_cmd) {
     set cmd_proc_arr($old_cmd) $cmd_proc_arr($cmd)
    }
   }
   PB_com_RetObjFrmName gPB(temp_cmd) gPB(cmd_obj_list) cmd_obj
   PB_com_DeleteObject cmd_obj
   if { [string match "*set_nc_definitions" $cmd] } {
    PB_PB2VNC_set_vnc_def $cmd
    } elseif { [string match "*map_machine_tool_axes" $cmd] } {
    PB_PB2VNC_set_map_def $cmd
    } else {
    PB_PB2VNC_set_other_code $cmd
   }
  }
 }

#=======================================================================
proc PB_int_UpdateSIMVar { MOM_SIM_VAR } {
  upvar $MOM_SIM_VAR mom_sim_var
  global post_object gPB
  global mom_sim_arr
  set Post::($post_object,mom_sim_var_list) [array get mom_sim_var]
  PB_int_RecreateVNCCommand
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
  Post::SetPostOutputFiles $post_object dir pui_file def_file tcl_file
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
  if ![info exists list_obj_attr(usertcl_name)] {
   set list_obj_attr(usertcl_name) $usertcl_name
  }
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
  Post::ReadPostOutputFiles $post_object dir pui_file def_file tcl_file
 }

#=======================================================================
proc PB_int_GetEventProcsData { EVENT_PROC_DATA } {
  upvar $EVENT_PROC_DATA event_proc_data
  global post_object
  array set event_proc_data $Post::($post_object,event_procs)
 }

#=======================================================================
proc __isv_Set_Machine_Vars { } {
  global machType axisoption
  global mom_sim_arr
  set mom_sim_arr(\$mom_sim_num_machine_axes) 3
  switch $machType {
   "Mill" {
    switch $axisoption {
     "4H" -
     "4T" {
      set mom_sim_arr(\$mom_sim_mt_axis\(4\))           "B"
      set mom_sim_arr(\$mom_sim_num_machine_axes)        4
      if { [string match "4T" $axisoption] } {
       set mom_sim_arr(\$mom_sim_reverse_4th_table)   "0"
       set mom_sim_arr(\$mom_sim_4th_axis_has_limits) "1"
      }
     }
     "5HH" -
     "5HT" -
     "5TT" {
      set mom_sim_arr(\$mom_sim_mt_axis\(4\))           "B"
      set mom_sim_arr(\$mom_sim_mt_axis\(5\))           "C"
      set mom_sim_arr(\$mom_sim_num_machine_axes)       "5"
      if { [string match "5TT" $axisoption] } {
       set mom_sim_arr(\$mom_sim_reverse_4th_table)   "0"
       set mom_sim_arr(\$mom_sim_4th_axis_has_limits) "1"
      }
      if { [string match "*T" $axisoption] } {
       set mom_sim_arr(\$mom_sim_reverse_5th_table)   "0"
       set mom_sim_arr(\$mom_sim_5th_axis_has_limits) "1"
      }
     }
    }
   }
   "Lathe" {
   }
  }
 }

#=======================================================================
proc PB_file_ParseMacroInfoFile { dir } {
  set ret_code 0
  set info_dir "${dir}/info"
  set tcl_file_list [list]
  __GetPuiFileNameFrmFolder info_dir tcl_file_list "tcl"
  if { [llength $tcl_file_list] } \
  {
   global gPB
   set file_name [lindex $tcl_file_list 0]
   catch { source "${info_dir}/$file_name.tcl" }
   set ret_code 1
  }
  return $ret_code
 }

#=======================================================================
proc PB_OpenOldVersion { pui_file_name { flag 0 } } {
  global post_object
  global env
  global gPB
  global errorInfo
  global mom_sys_arr
  set ret_code 0
  set std_pui_id FP1
  set pui_file_id FP2
  set gPB(new_IKS_in_use) 0
  PB_file_FindTclDefOfPui $pui_file_name tcl_file def_file
  if { [info exist ::env(SUB_POST)] && $::env(SUB_POST) == 1 } \
  {
   PB_file_InitDefEnvforSubPostMode $pui_file_name def_file
  }
  set tcl_file [file tail $tcl_file]
  set def_file [file tail $def_file]
  PB_file_GetPostAttr $pui_file_name machine_type axis_option output_unit
  set gPB(new_machine_type) $machine_type
  set gPB(mach_axis_remove_proc) $axis_option
  global mach_type controller
  set mach_type $machine_type
  set controller "$pui_file_name"
  set family_flag 0
  if { $flag == 1 } {
   set pui_file_list [list $pui_file_name]
   set sw_list       [list 0]
   } else {
   if { [string compare $gPB(post_controller_type) ""] != 0 } \
   {
    set cntl_full_name ""
    __file_GetCurrentSysControllerFullName $gPB(mach_sys_controller) cntl_full_name $machine_type
    UI_PB_file_GetPostFragList pui_file_list $machine_type $cntl_full_name $axis_option $output_unit
    set family_flag 1
   } else \
   {
    UI_PB_file_GetPostFragList pui_file_list $machine_type "Generic" $axis_option $output_unit
    if { [info exists gPB(legacy_controller_type_no_exist)] && \
    $gPB(legacy_controller_type_no_exist) == 1 } \
    {
     set base_pui_file [lindex $pui_file_list 0]
     if { [string match "*mill_base.pui"  $base_pui_file] || \
      [string match "*lathe_base.pui" $base_pui_file] || \
     [string match "*wedm_base.pui"  $base_pui_file] } \
     {
      set temp_ind [lsearch $pui_file_list $pui_file_name]
      if { $temp_ind >= 0 } \
      {
       set pui_file_list [lreplace $pui_file_list $temp_ind $temp_ind]
      }
      set pui_file_list [lreplace $pui_file_list 0 0 $pui_file_name]
     }
    }
   }
   if { [lsearch $pui_file_list $pui_file_name] < 0 } {
    lappend pui_file_list $pui_file_name
   }
   if [info exists file_conv] {
    unset file_conv
   }
   switch $machine_type {
    "Mill" {
     if $family_flag {
      if [file exists [file rootname $cntl_full_name].pb] {
       set file_conv [file nativename [file rootname $cntl_full_name].pb]
      }
      } elseif { ![info exists gPB(legacy_controller_type_no_exist)] || \
      !$gPB(legacy_controller_type_no_exist) } {
      set file_conv [file nativename $env(PB_HOME)/pblib/mill_base.pb]
     }
    }
    "Lathe" {
     if $family_flag {
      if [file exists [file rootname $cntl_full_name].pb] {
       set file_conv [file nativename [file rootname $cntl_full_name].pb]
      }
      } elseif { ![info exists gPB(legacy_controller_type_no_exist)] || \
      !$gPB(legacy_controller_type_no_exist) } {
      set file_conv [file nativename $env(PB_HOME)/pblib/lathe_base.pb]
     }
    }
    "Wire EDM" -
    "Wedm" {
     if $family_flag {
      if [file exists [file rootname $cntl_full_name].pb] {
       set file_conv [file nativename [file rootname $cntl_full_name].pb]
      }
      } elseif { ![info exists gPB(legacy_controller_type_no_exist)] || \
      !$gPB(legacy_controller_type_no_exist) } {
      set file_conv [file nativename $env(PB_HOME)/pblib/wedm_base.pb]
     }
    }
    default {
     __Pause "Invalid machine type \"$machine_type\""
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
   if { ![info exists gPB(legacy_controller_type_no_exist)] || \
    !$gPB(legacy_controller_type_no_exist) } {
    set idx [lsearch $pui_file_list $pui_file_name]
    set sw_list [lreplace $sw_list $idx $idx 0]
   }
  } ;# flag = 1
  if [file exists [file rootname $pui_file_name].cdl] {
   set ::gPB(old_own_cdl_file) [file rootname $pui_file_name].cdl
  }
  if [file exists [file rootname $pui_file_name]_vnc.tcl] {
   set ::gPB(old_own_vnc_tag) 1
   } else {
   set ::gPB(old_own_vnc_tag) 0
  }
  set gPB(old_version_pui_idx) [lsearch $pui_file_list $pui_file_name]
  if [catch { PB_file_Create $pui_file_list $sw_list } result] \
  {
   if [info exists gPB(legacy_controller_type_no_exist)] \
   {
    unset gPB(legacy_controller_type_no_exist)
   }
   if [info exists gPB(mill_common_family_dir_prefix)] \
   {
    unset gPB(mill_common_family_dir_prefix)
   }
   unset gPB(old_version_pui_idx)
   return [ error "$errorInfo" ]
  }
  if [info exists gPB(legacy_controller_type_no_exist)] \
  {
   unset gPB(legacy_controller_type_no_exist)
  }
  if [info exists gPB(mill_common_family_dir_prefix)] \
  {
   unset gPB(mill_common_family_dir_prefix)
  }
  unset gPB(old_version_pui_idx)
  set post_files(def_file) $def_file
  set post_files(tcl_file) $tcl_file
  set pui_dir [file dirname $pui_file_name]
  Post::SetPostFiles $post_object pui_dir post_files
  if $family_flag \
  {
   set templete_dir [file dirname $cntl_full_name]
   if [PB_file_ParseMacroInfoFile $templete_dir] \
   {
    set gPB(controller_family_dir) $templete_dir
   }
  }
  if { $ret_code == 0 } \
  {
   set add_obj_list $Post::($post_object,add_obj_list)
   set add_list {"N" "X" "Y" "Z" "fourth_axis" "fifth_axis"}
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
   array set mom_sys_var_arr $Post::($post_object,mom_sys_var_list)
   if { ![string match "Wire EDM" $machine_type] } {
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
     set gpb_addr_var($add_name,name)         $add_obj_attr(0)
     set fmt_name $format::($add_obj_attr(1),for_name)
     set gpb_addr_var($add_name,fmt_name)     $fmt_name
     set gpb_addr_var($add_name,modal)        $add_obj_attr(2)
     set gpb_addr_var($add_name,modl_status)  $add_obj_attr(3)
     set gpb_addr_var($add_name,add_max)      $add_obj_attr(4)
     set gpb_addr_var($add_name,max_status)   $add_obj_attr(5)
     set gpb_addr_var($add_name,add_min)      $add_obj_attr(6)
     set gpb_addr_var($add_name,min_status)   $add_obj_attr(7)
     set gpb_addr_var($add_name,leader_name)  $add_obj_attr(8)
     set gpb_addr_var($add_name,trailer)      $add_obj_attr(9)
     set gpb_addr_var($add_name,trail_status) $add_obj_attr(10)
     set gpb_addr_var($add_name,incremental)  $add_obj_attr(11)
     set gpb_addr_var($add_name,zero_format)  $add_obj_attr(12)
     set gpb_addr_var($add_name,zero_format_name) $add_obj_attr(13)
     set gpb_addr_var($add_name,is_dummy)         $add_obj_attr(14)
     set gpb_addr_var($add_name,is_external)      $add_obj_attr(15)
     set Post::($post_object,def_gpb_addr_var) [array get gpb_addr_var]
     PB_int_GetWordVarDesc WordDescArray
     set WordDescArray($add_name) ""
     PB_int_UpdateAddVariablesAttr WordDescArray add_name
    }
    if { ![PB_is_old_v 2.0.2] } {
     set var98 "\$mom_sys_cycle_ret_code(AUTO)"
     set G98 $mom_sys_var_arr($var98)
     set var99 "\$mom_sys_cycle_ret_code(MANUAL)"
     set G99 $mom_sys_var_arr($var99)
     if { $G98 == "99" } {
      set mom_sys_var_arr($var98) "98"
      set mom_sys_arr($var98)     "98"
     }
     if { $G99 == "98" } {
      set mom_sys_var_arr($var99) "99"
      set mom_sys_arr($var99)     "99"
     }
    }
   } ;# !Wire EDM
   set comment_start [PB_output_EscapeSpecialControlChar $mom_sys_var_arr(Comment_Start)]
   set comment_end   [PB_output_EscapeSpecialControlChar $mom_sys_var_arr(Comment_End)]
   set len1 [string length $comment_start]
   set len2 [string length $comment_end]
   Post::GetObjList $post_object comment cmt_blk_obj_list
   foreach cmt_blk_obj $cmt_blk_obj_list {
    block::readvalue $cmt_blk_obj cmt_blk_obj_attr
    set blk_elem [lindex $cmt_blk_obj_attr(2) 0]
    set elem_var $block_element::($blk_elem,elem_mom_variable)
    UI_PB_debug_ForceMsg "Oper Msg before ==>$elem_var $len1 $len2 $comment_start $comment_end"
    set lead [string range $elem_var 0 [expr $len1 - 1]]
    set trim_start 0
    if [string match "$comment_start" $lead] {
     set trim_start 1
    }
    set end_idx [expr [string length $elem_var] - $len2 - 1]
    set trail [string range $elem_var [expr $end_idx + 1] end]
    set trim_end 0
    if [string match "$comment_end" $trail] {
     set trim_end 1
    }
    if { $trim_start && $trim_end } {
     set elem_var [string range $elem_var $len1 end]
     set elem_var [string range $elem_var 0 [expr $end_idx - $len1]]
    }
    UI_PB_debug_ForceMsg "Oper Msg after  ==>$elem_var"
    set block_element::($blk_elem,elem_mom_variable) $elem_var
    set cmt_blk_name $cmt_blk_obj_attr(0)
    set mom_sys_var_arr($cmt_blk_name) $elem_var
   }
   if [info exists mom_sys_var_arr(\$cir_vector)] {
    UI_PB_GetPostVersion pui_file_name version
    if { [string compare $version "2001.0.0.0"] < 0 } {
     switch $mom_sys_var_arr(\$cir_vector) {
      "Vector - Arc Start to Center" -
      "Vector - Arc Center to Start" -
      "Unsigned Vector - Arc Start to Center" -
      "Vector - Absolute Arc Center" {}
      default {
       set mom_sys_var_arr(\$cir_vector) "Vector - Arc Center to Start"
      }
     }
     if { ![info exists mom_sys_var_arr(\$mom_sys_cir_vector)] } {
      set mom_sys_var_arr(\$mom_sys_cir_vector) $mom_sys_var_arr(\$cir_vector)
     }
     Post::GetObjList $post_object sequence seq_obj_list
     set seq_name "Motions"
     PB_com_RetObjFrmName seq_name seq_obj_list seq_obj
     if { $seq_obj > 0 } {
      set evt_obj_list $sequence::($seq_obj,evt_obj_list)
      set evt_name "Circular Move"
      PB_com_RetObjFrmName evt_name evt_obj_list evt_obj
      if { $evt_obj > 0 } {
       UI_PB_tpth_SetIJKOptions $evt_obj $machine_type \
       $mom_sys_var_arr(\$cir_vector) \
       $mom_sys_var_arr(\$mom_sys_cir_vector) \
       1
      }
     }
     set mom_sys_var_arr(\$mom_sys_cir_vector) $mom_sys_var_arr(\$cir_vector)
    }
    unset mom_sys_var_arr(\$cir_vector)
    if [info exists mom_sys_arr(\$cir_vector)] {
     unset mom_sys_arr(\$cir_vector)
    }
   }
   set mom_sys_arr(\$mom_sys_cir_vector) $mom_sys_var_arr(\$mom_sys_cir_vector)
   if [info exists mom_sys_var_arr(\$mom_sys_postname_list)] {
    set post_names_list $mom_sys_var_arr(\$mom_sys_postname_list)
    set this_post [file rootname [file tail $pui_file_name]]
    set linked_posts [list]
    for { set i 0 } { $i < [llength $post_names_list] } { incr i 2 } {
     set head_name [lindex $post_names_list $i]
     set post_name [lindex $post_names_list [expr $i + 1]]
     if [string match "$this_post" $post_name] {
      lappend linked_posts "\{$head_name\} \{this_post\}"
      set post_names_list [lreplace $post_names_list $i [expr $i + 1]]
      __int_AddEvtsToLinkedPostsSeq $head_name
      break
     }
    }
    if { [llength $linked_posts] == 0 } {
     set head_name [lindex $post_names_list 0]
     lappend linked_posts "\{$head_name\} \{this_post\}"
     set post_names_list [lreplace $post_names_list 0 1]
     __int_AddEvtsToLinkedPostsSeq $head_name
    }
    for { set i 0 } { $i < [llength $post_names_list] } { incr i 2 } {
     set head_name [lindex $post_names_list $i]
     set post_name [lindex $post_names_list [expr $i + 1]]
     lappend linked_posts "\{$head_name\} \{$post_name\}"
     __int_AddEvtsToLinkedPostsSeq $head_name
    }
    set mom_sys_var_arr(\$is_linked_post) 1
    set mom_sys_var_arr(\$linked_posts_list) $linked_posts
    set mom_sys_arr(\$is_linked_post) 1
    set mom_sys_arr(\$linked_posts_list) $linked_posts
   }
   set Post::($post_object,mom_sys_var_list)     [array get mom_sys_var_arr]
   set Post::($post_object,def_mom_sys_var_list) [array get mom_sys_var_arr]
   if 0 {
    global mom_kin_var
    if [info exists mom_sys_arr(\$tl_change_sec)] {
     set mom_kin_var(\$mom_kin_tool_change_time)     $mom_sys_arr(\$tl_change_sec)
     array set mom_kin_var_arr $Post::($post_object,mom_kin_var_list)
     set mom_kin_var_arr(\$mom_kin_tool_change_time) $mom_sys_arr(\$tl_change_sec)
     unset mom_sys_arr(\$tl_change_sec)
     unset mom_sys_var_arr(\$tl_change_sec)
     set Post::($post_object,mom_sys_var_list)     [array get mom_sys_arr]
     set Post::($post_object,def_mom_sys_var_list) [array get mom_sys_arr]
     set Post::($post_object,mom_kin_var_list)     [array get mom_kin_var_arr]
     set Post::($post_object,def_mom_kin_var_list) [array get mom_kin_var_arr]
    }
   }
   __swap_RotaryAxes
   global mom_sim_arr
   array set mom_sim_arr $Post::($post_object,mom_sim_var_list)
   set Post::($post_object,mom_sim_var_list)     [array get mom_sim_arr]
   set Post::($post_object,def_mom_sim_var_list) [array get mom_sim_arr]
  }
  return $ret_code
 }

#=======================================================================
proc __swap_RotaryAxes { args } {
  global post_object mom_kin_var
  if [string match "*5*" $mom_kin_var(\$mom_kin_machine_type)] {
   PB_com_GetMachAxisType $mom_kin_var(\$mom_kin_machine_type) machine_type axis_option
   if { [string match "5HH" $axis_option] } {
    global gPB
    if { [info exists gPB(new_IKS_in_use)] && $gPB(new_IKS_in_use) == 1 } {
     return
    }
    set var_list { ang_offset       \
     center_offset(0) \
     center_offset(1) \
     center_offset(2) \
     direction        \
     incr_switch      \
     leader           \
     max_limit        \
     min_incr         \
     min_limit        \
     plane            \
     rotation         \
    zero }
    foreach var $var_list {
     set val $mom_kin_var(\$mom_kin_4th_axis_[set var])
     set mom_kin_var(\$mom_kin_4th_axis_[set var]) $mom_kin_var(\$mom_kin_5th_axis_[set var])
     set mom_kin_var(\$mom_kin_5th_axis_[set var]) $val
    }
    set Post::($post_object,mom_kin_var_list)     [array get mom_kin_var_arr]
    set Post::($post_object,def_mom_kin_var_list) [array get mom_kin_var_arr]
    global mom_sys_arr
    set val $mom_sys_arr(\$mom_sys_leader\(fourth_axis\))
    set mom_sys_arr(\$mom_sys_leader(fourth_axis)) $mom_sys_arr(\$mom_sys_leader\(fifth_axis\))
    set mom_sys_arr(\$mom_sys_leader(fifth_axis)) $val
    set Post::($post_object,mom_sys_var_list)     [array get mom_sys_arr]
    set Post::($post_object,def_mom_sys_var_list) [array get mom_sys_arr]
    set add_obj_list $Post::($post_object,add_obj_list)
    set add fourth_axis
    set add4_obj 0
    PB_com_RetObjFrmName add add_obj_list add4_obj
    if { $add4_obj > 0 } {
     address::readvalue $add4_obj add4_attr
    }
    set add fifth_axis
    set add5_obj 0
    PB_com_RetObjFrmName add add_obj_list add5_obj
    if { $add5_obj > 0 } {
     address::readvalue    $add5_obj add5_attr
     set add5_attr(0)      fourth_axis
     set add4_attr(0)      fifth_axis
     address::setvalue     $add4_obj add5_attr
     address::DefaultValue $add4_obj add5_attr
     address::setvalue     $add5_obj add4_attr
     address::DefaultValue $add5_obj add4_attr
    }
    set idx4 [lsearch $add_obj_list $add4_obj]
    set idx5 [lsearch $add_obj_list $add5_obj]
    set add_obj_list [lreplace $add_obj_list $idx4 $idx4 $add5_obj]
    set add_obj_list [lreplace $add_obj_list $idx5 $idx5 $add4_obj]
    set Post::($post_object,add_obj_list) $add_obj_list
    array set mseq_word_param $Post::($post_object,msq_word_param)
    if [info exists mseq_word_param(fourth_axis)] {
     set addr_mseq_param $mseq_word_param(fourth_axis)
     set mseq_attr(0) [lindex $addr_mseq_param 0]
     set mseq_attr(1) [lindex $addr_mseq_param 1]
     set mseq_attr(2) [lindex $addr_mseq_param 2]
     set seq_no [lsearch $Post::($post_object,msq_add_name) fifth_axis]
     set mseq_attr(3) $seq_no
     set mseq_attr(4) [lindex $addr_mseq_param 3]
    }
    address::SetMseqAttr $add4_obj mseq_attr
    address::DefaultMseqAttr $add4_obj mseq_attr
    if [info exists mseq_word_param(fifth_axis)] {
     set addr_mseq_param $mseq_word_param(fifth_axis)
     set mseq_attr(0) [lindex $addr_mseq_param 0]
     set mseq_attr(1) [lindex $addr_mseq_param 1]
     set mseq_attr(2) [lindex $addr_mseq_param 2]
     set seq_no [lsearch $Post::($post_object,msq_add_name) fourth_axis]
     set mseq_attr(3) $seq_no
     set mseq_attr(4) [lindex $addr_mseq_param 3]
    }
    address::SetMseqAttr $add5_obj mseq_attr
    address::DefaultMseqAttr $add5_obj mseq_attr
    global gpb_addr_var
    set gpb_addr_var(fourth_axis,fmt_name)     $format::($add5_attr(1),for_name)
    set gpb_addr_var(fourth_axis,modal)        $add5_attr(2)
    set gpb_addr_var(fourth_axis,modl_status)  $add5_attr(3)
    set gpb_addr_var(fourth_axis,add_max)      $add5_attr(4)
    set gpb_addr_var(fourth_axis,max_status)   $add5_attr(5)
    set gpb_addr_var(fourth_axis,add_min)      $add5_attr(6)
    set gpb_addr_var(fourth_axis,min_status)   $add5_attr(7)
    set gpb_addr_var(fourth_axis,leader_name)  $add5_attr(8)
    set gpb_addr_var(fourth_axis,trailer)      $add5_attr(9)
    set gpb_addr_var(fourth_axis,trail_status) $add5_attr(10)
    set gpb_addr_var(fourth_axis,incremental)  $add5_attr(11)
    set gpb_addr_var(fourth_axis,zero_format)  $add5_attr(12)
    set gpb_addr_var(fifth_axis,fmt_name)      $format::($add4_attr(1),for_name)
    set gpb_addr_var(fifth_axis,modal)         $add4_attr(2)
    set gpb_addr_var(fifth_axis,modl_status)   $add4_attr(3)
    set gpb_addr_var(fifth_axis,add_max)       $add4_attr(4)
    set gpb_addr_var(fifth_axis,max_status)    $add4_attr(5)
    set gpb_addr_var(fifth_axis,add_min)       $add4_attr(6)
    set gpb_addr_var(fifth_axis,min_status)    $add4_attr(7)
    set gpb_addr_var(fifth_axis,leader_name)   $add4_attr(8)
    set gpb_addr_var(fifth_axis,trailer)       $add4_attr(9)
    set gpb_addr_var(fifth_axis,trail_status)  $add4_attr(10)
    set gpb_addr_var(fifth_axis,incremental)   $add4_attr(11)
    set gpb_addr_var(fifth_axis,zero_format)   $add4_attr(12)
    set Post::($post_object,gpb_addr_var)     [array get gpb_addr_var]
    set Post::($post_object,def_gpb_addr_var) [array get gpb_addr_var]
    set blk_elem_list $address::($add4_obj,blk_elem_list)
    Post::GetObjList $post_object block blk_obj_list
    set blk_processed 0
    foreach blk_elem $blk_elem_list {
     set blk $block_element::($blk_elem,parent_name)
     PB_com_RetObjFrmName blk blk_obj_list blk_obj
     if { $blk_obj > 0 } {
      block::readvalue $blk_obj blk_attr
      set elem_list $blk_attr(2)
      set idx4 0
      set idx5 0
      set elem4_idx 0
      set elem5_idx 0
      foreach elem $elem_list {
       if [string match $add4_obj $block_element::($elem,elem_add_obj)] {
        set elem4_idx $idx4
        set elem4 $elem
        continue
       }
       incr idx4
      }
      foreach elem $elem_list {
       if [string match $add5_obj $block_element::($elem,elem_add_obj)] {
        set elem5_idx $idx5
        set elem5 $elem
        continue
       }
       incr idx5
      }
      if { $elem4_idx  &&  $elem5_idx  &&  ![string match $blk $blk_processed] } {
       set elem_list [lreplace $elem_list $elem4_idx $elem4_idx $elem5]
       set elem_list [lreplace $elem_list $elem5_idx $elem5_idx $elem4]
       set blk_attr(2) $elem_list
       block::setvalue $blk_obj blk_attr
       set blk_processed $blk
      }
     }
    }
   }
  }
 }

#=======================================================================
proc __int_AddEvtsToLinkedPostsSeq { head_name } {
  global post_object
  Post::GetObjList $post_object sequence seq_obj_list
  set seq_name "Linked Posts Sequence"
  PB_com_RetObjFrmName seq_name seq_obj_list seq_obj
  PB_int_RetCmdBlks cmd_obj_list
  if { $seq_obj > 0 } {
   sequence::readvalue $seq_obj seq_obj_attr
   set evt_obj_list $seq_obj_attr(1)
   if { ![string match "" $head_name] } {
    set cmd_obj -1
    set cmd_name "PB_CMD_start_of_$head_name"
    PB_com_RetObjFrmName cmd_name cmd_obj_list cmd_obj
    if { $cmd_obj <= 0 } {
     set cmd_name "PB_CMD_start_of_[string tolower $head_name]"
     PB_com_RetObjFrmName cmd_name cmd_obj_list cmd_obj
    }
    if { $cmd_obj > 0 } {
     set evt_name "start_of_HEAD__$head_name"
     set evt_obj -1
     PB_com_RetObjFrmName evt_name evt_obj_list evt_obj
     if { $evt_obj <= 0 } {
      set evt_obj_attr(0) "$evt_name"
      set evt_obj_attr(1) 0
      set evt_obj_attr(2) {}
      set evt_obj_attr(3) {}
      set evt_obj_attr(4) $evt_obj_attr(0)
      PB_evt_CreateEvtObj evt_obj_attr evt_obj_list
      PB_com_RetObjFrmName evt_name evt_obj_list evt_obj
      PB_int_CreateCmdBlkFromCmd cmd_obj blk_obj
      PB_int_CreateNewEventElement blk_obj evt_elem_obj
      set event_element::($evt_elem_obj,event_obj) $evt_obj
      lappend evt_obj_attr(2) $evt_elem_obj
      event::setvalue $evt_obj evt_obj_attr
      event::DefaultValue $evt_obj
     }
    }
    set cmd_obj -1
    set cmd_name "PB_CMD_end_of_$head_name"
    PB_com_RetObjFrmName cmd_name cmd_obj_list cmd_obj
    if { $cmd_obj <= 0 } {
     set cmd_name "PB_CMD_start_of_[string tolower $head_name]"
     PB_com_RetObjFrmName cmd_name cmd_obj_list cmd_obj
    }
    if { $cmd_obj > 0 } {
     set evt_name "end_of_HEAD__$head_name"
     set evt_obj -1
     PB_com_RetObjFrmName evt_name evt_obj_list evt_obj
     if { $evt_obj <= 0 } {
      set evt_obj_attr(0) "$evt_name"
      set evt_obj_attr(1) 0
      set evt_obj_attr(2) {}
      set evt_obj_attr(3) {}
      set evt_obj_attr(4) $evt_obj_attr(0)
      PB_evt_CreateEvtObj evt_obj_attr evt_obj_list
      PB_com_RetObjFrmName evt_name evt_obj_list evt_obj
      PB_int_CreateCmdBlkFromCmd cmd_obj blk_obj
      PB_int_CreateNewEventElement blk_obj evt_elem_obj
      set event_element::($evt_elem_obj,event_obj) $evt_obj
      lappend evt_obj_attr(2) $evt_elem_obj
      event::setvalue $evt_obj evt_obj_attr
      event::DefaultValue $evt_obj
     }
    }
   }
   set seq_obj_attr(1)    $evt_obj_list
   sequence::setvalue     $seq_obj seq_obj_attr
   sequence::DefaultValue $seq_obj seq_obj_attr
  }
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
proc PB_file_Open_AlterUnitSubPost { pui_file_name args } {
  global post_object
  global env
  global gPB
  global errorInfo
  global mom_sys_arr
  set ret_code 0
  set pui_file_id FP2
  set gPB(new_IKS_in_use) 0
  PB_file_FindTclDefOfPui $pui_file_name tcl_file def_file
  PB_file_InitDefEnvforSubPostMode $pui_file_name def_file
  set tcl_file [file tail $tcl_file]
  set def_file [file tail $def_file]
  PB_file_GetPostAttr $pui_file_name machine_type axis_option output_unit
  set gPB(new_machine_type) $machine_type
  set gPB(mach_axis_remove_proc) $axis_option
  set gPB(main_post_machine_type) $machine_type
  set gPB(main_post_axis_option) $axis_option
  if { ![string compare "Inches" $output_unit] } {
   set gPB(main_post_unit) "Millimeters"
   } else {
   set gPB(main_post_unit) "Inches"
  }
  UI_PB_file_GetPostControllerType pui_file_name gPB(post_controller_type)
  UI_PB_file_GetPostFragList pui_file_list $machine_type "Generic" $axis_option $output_unit
  if { [lsearch $pui_file_list $pui_file_name] < 0 } {
   lappend pui_file_list $pui_file_name
  }
  set sw_list [list]
  foreach f $pui_file_list \
  {
   lappend sw_list 1
  }
  set le [expr [llength $sw_list] - 1]
  set sw_list [lreplace $sw_list $le $le 0]
  if [catch { PB_file_CreateAlterUnitSubPost $pui_file_list $sw_list } result] \
  {
   if [info exists gPB(legacy_controller_type_no_exist)] \
   {
    unset gPB(legacy_controller_type_no_exist)
   }
   if [info exists gPB(mill_common_family_dir_prefix)] \
   {
    unset gPB(mill_common_family_dir_prefix)
   }
   return [ error "$errorInfo" ]
  }
  set post_files(def_file) $def_file
  set post_files(tcl_file) $tcl_file
  set pui_dir [file dirname $pui_file_name]
  Post::SetPostFiles $post_object pui_dir post_files
  if { $ret_code == 0 } \
  {
   set add_obj_list $Post::($post_object,add_obj_list)
   set add_list {"N" "X" "Y" "Z" "fourth_axis" "fifth_axis"}
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
   array set mom_sys_var_arr $Post::($post_object,mom_sys_var_list)
   if { ![string match "Wire EDM" $machine_type] } {
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
     set gpb_addr_var($add_name,name)         $add_obj_attr(0)
     set fmt_name $format::($add_obj_attr(1),for_name)
     set gpb_addr_var($add_name,fmt_name)     $fmt_name
     set gpb_addr_var($add_name,modal)        $add_obj_attr(2)
     set gpb_addr_var($add_name,modl_status)  $add_obj_attr(3)
     set gpb_addr_var($add_name,add_max)      $add_obj_attr(4)
     set gpb_addr_var($add_name,max_status)   $add_obj_attr(5)
     set gpb_addr_var($add_name,add_min)      $add_obj_attr(6)
     set gpb_addr_var($add_name,min_status)   $add_obj_attr(7)
     set gpb_addr_var($add_name,leader_name)  $add_obj_attr(8)
     set gpb_addr_var($add_name,trailer)      $add_obj_attr(9)
     set gpb_addr_var($add_name,trail_status) $add_obj_attr(10)
     set gpb_addr_var($add_name,incremental)  $add_obj_attr(11)
     set gpb_addr_var($add_name,zero_format)  $add_obj_attr(12)
     set gpb_addr_var($add_name,zero_format_name) $add_obj_attr(13)
     set gpb_addr_var($add_name,is_dummy)         $add_obj_attr(14)
     set gpb_addr_var($add_name,is_external)      $add_obj_attr(15)
     set Post::($post_object,def_gpb_addr_var) [array get gpb_addr_var]
     PB_int_GetWordVarDesc WordDescArray
     set WordDescArray($add_name) ""
     PB_int_UpdateAddVariablesAttr WordDescArray add_name
    }
    if { ![PB_is_old_v 2.0.2] } {
     set var98 "\$mom_sys_cycle_ret_code(AUTO)"
     set G98 $mom_sys_var_arr($var98)
     set var99 "\$mom_sys_cycle_ret_code(MANUAL)"
     set G99 $mom_sys_var_arr($var99)
     if { $G98 == "99" } {
      set mom_sys_var_arr($var98) "98"
      set mom_sys_arr($var98)     "98"
     }
     if { $G99 == "98" } {
      set mom_sys_var_arr($var99) "99"
      set mom_sys_arr($var99)     "99"
     }
    }
   } ;# !Wire EDM
   set comment_start [PB_output_EscapeSpecialControlChar $mom_sys_var_arr(Comment_Start)]
   set comment_end   [PB_output_EscapeSpecialControlChar $mom_sys_var_arr(Comment_End)]
   set len1 [string length $comment_start]
   set len2 [string length $comment_end]
   Post::GetObjList $post_object comment cmt_blk_obj_list
   foreach cmt_blk_obj $cmt_blk_obj_list {
    block::readvalue $cmt_blk_obj cmt_blk_obj_attr
    set blk_elem [lindex $cmt_blk_obj_attr(2) 0]
    set elem_var $block_element::($blk_elem,elem_mom_variable)
    UI_PB_debug_ForceMsg "Oper Msg before ==>$elem_var $len1 $len2 $comment_start $comment_end"
    set lead [string range $elem_var 0 [expr $len1 - 1]]
    set trim_start 0
    if [string match "$comment_start" $lead] {
     set trim_start 1
    }
    set end_idx [expr [string length $elem_var] - $len2 - 1]
    set trail [string range $elem_var [expr $end_idx + 1] end]
    set trim_end 0
    if [string match "$comment_end" $trail] {
     set trim_end 1
    }
    if { $trim_start && $trim_end } {
     set elem_var [string range $elem_var $len1 end]
     set elem_var [string range $elem_var 0 [expr $end_idx - $len1]]
    }
    UI_PB_debug_ForceMsg "Oper Msg after  ==>$elem_var"
    set block_element::($blk_elem,elem_mom_variable) $elem_var
    set cmt_blk_name $cmt_blk_obj_attr(0)
    set mom_sys_var_arr($cmt_blk_name) $elem_var
   }
   if [info exists mom_sys_var_arr(\$cir_vector)] {
    UI_PB_GetPostVersion pui_file_name version
    if { [string compare $version "2001.0.0.0"] < 0 } {
     switch $mom_sys_var_arr(\$cir_vector) {
      "Vector - Arc Start to Center" -
      "Vector - Arc Center to Start" -
      "Unsigned Vector - Arc Start to Center" -
      "Vector - Absolute Arc Center" {}
      default {
       set mom_sys_var_arr(\$cir_vector) "Vector - Arc Center to Start"
      }
     }
     if { ![info exists mom_sys_var_arr(\$mom_sys_cir_vector)] } {
      set mom_sys_var_arr(\$mom_sys_cir_vector) $mom_sys_var_arr(\$cir_vector)
     }
     Post::GetObjList $post_object sequence seq_obj_list
     set seq_name "Motions"
     PB_com_RetObjFrmName seq_name seq_obj_list seq_obj
     if { $seq_obj > 0 } {
      set evt_obj_list $sequence::($seq_obj,evt_obj_list)
      set evt_name "Circular Move"
      PB_com_RetObjFrmName evt_name evt_obj_list evt_obj
      if { $evt_obj > 0 } {
       UI_PB_tpth_SetIJKOptions $evt_obj $machine_type \
       $mom_sys_var_arr(\$cir_vector) \
       $mom_sys_var_arr(\$mom_sys_cir_vector) \
       1
      }
     }
     set mom_sys_var_arr(\$mom_sys_cir_vector) $mom_sys_var_arr(\$cir_vector)
    }
    unset mom_sys_var_arr(\$cir_vector)
    if [info exists mom_sys_arr(\$cir_vector)] {
     unset mom_sys_arr(\$cir_vector)
    }
   }
   set mom_sys_arr(\$mom_sys_cir_vector) $mom_sys_var_arr(\$mom_sys_cir_vector)
   if [info exists mom_sys_var_arr(\$mom_sys_postname_list)] {
    set post_names_list $mom_sys_var_arr(\$mom_sys_postname_list)
    set this_post [file rootname [file tail $pui_file_name]]
    set linked_posts [list]
    for { set i 0 } { $i < [llength $post_names_list] } { incr i 2 } {
     set head_name [lindex $post_names_list $i]
     set post_name [lindex $post_names_list [expr $i + 1]]
     if [string match "$this_post" $post_name] {
      lappend linked_posts "\{$head_name\} \{this_post\}"
      set post_names_list [lreplace $post_names_list $i [expr $i + 1]]
      __int_AddEvtsToLinkedPostsSeq $head_name
      break
     }
    }
    if { [llength $linked_posts] == 0 } {
     set head_name [lindex $post_names_list 0]
     lappend linked_posts "\{$head_name\} \{this_post\}"
     set post_names_list [lreplace $post_names_list 0 1]
     __int_AddEvtsToLinkedPostsSeq $head_name
    }
    for { set i 0 } { $i < [llength $post_names_list] } { incr i 2 } {
     set head_name [lindex $post_names_list $i]
     set post_name [lindex $post_names_list [expr $i + 1]]
     lappend linked_posts "\{$head_name\} \{$post_name\}"
     __int_AddEvtsToLinkedPostsSeq $head_name
    }
    set mom_sys_var_arr(\$is_linked_post) 1
    set mom_sys_var_arr(\$linked_posts_list) $linked_posts
    set mom_sys_arr(\$is_linked_post) 1
    set mom_sys_arr(\$linked_posts_list) $linked_posts
   }
   set Post::($post_object,mom_sys_var_list)     [array get mom_sys_var_arr]
   set Post::($post_object,def_mom_sys_var_list) [array get mom_sys_var_arr]
   __swap_RotaryAxes
   global mom_sim_arr
   array set mom_sim_arr $Post::($post_object,mom_sim_var_list)
   set Post::($post_object,mom_sim_var_list)     [array get mom_sim_arr]
   set Post::($post_object,def_mom_sim_var_list) [array get mom_sim_arr]
  }
  return $ret_code
 }

#=======================================================================
proc PB_file_is_JE_POST_DEV {} {
  if { [info exists ::gPB(JE_POST_DEV)] && $::gPB(JE_POST_DEV) } {
   return 1
   } else {
   return 0
  }
 }

#=======================================================================
proc PB_file_Open { pui_file_name args } {
  global post_object
  global env
  global gPB
  global errorInfo
  if ![info exists gPB(JE_POST_DEV)] {
   set gPB(JE_POST_DEV) 0
  }
  set ret_code 0
  set post_object [new Post $pui_file_name]
  set pui_file_id FP2
  if [info exists gPB(pui_ui_overwrite)] {
   unset gPB(pui_ui_overwrite)
  }
  if [ catch { PB_com_ReadPuiFile pui_file_name pui_file_id post_object } result ] {
   return [ error "$errorInfo" ]
  }
  if 0 {
   if { $env(PB_UDE_ENABLED) == 1 } {
    set cdl_file "[file rootname $pui_file_name].cdl"
    if [file exists $cdl_file] {
     set cdl_file_name $cdl_file
     } else {
     set cdl_file_name "$env(PB_HOME)/pblib/ude.cdl"
    }
    set cdl_file_id FP3
    PB_com_ReadUdeFile cdl_file_name cdl_file_id post_object
   }
  }
  if { $env(PB_UDE_ENABLED) == 1 } {
   set cdl_file "[file rootname $pui_file_name].cdl"
   if ![file exists $cdl_file] {
    set cdl_file_name "$env(PB_HOME)/pblib/ude.cdl"
    set cdl_file_id FP3
    PB_com_ReadUdeFile cdl_file_name cdl_file_id post_object
   }
  }
  global mach_type controller
  PB_file_GetPostAttr $pui_file_name machine_type axis_option output_unit
  set mach_type $machine_type
  set controller "$pui_file_name"
  set gPB(new_machine_type) $machine_type
  set gPB(mach_axis_remove_proc) $axis_option
  if [ catch { PB_file_ParsePostFiles $post_object } result ] {
   return [ error "$errorInfo" ]
  }
  if { $Post::($post_object,tcl_file_read) != "TRUE"  || \
  $Post::($post_object,def_file_read) != "TRUE" } \
  {
   return [ error "$gPB(msg,invalid_post)" ]
  }
  if { $env(PB_UDE_ENABLED) == 1 } {
   set cdl_file "[file rootname $pui_file_name].cdl"
   if [file exists $cdl_file] {
    set cdl_file_name $cdl_file
    set cdl_file_id FP3
    PB_com_ReadUdeFile cdl_file_name cdl_file_id post_object
   }
  }
  array set mom_sys_arr $Post::($post_object,mom_sys_var_list)
  if { [PB_is_v $gPB(VNC_release)] == 0 } {
   array set mom_sys_arr $Post::($post_object,mom_sys_var_list)
   set mom_sys_arr(Output_VNC) 0
   set mom_sys_arr(Main_VNC) ""
   PB_int_UpdateMOMVar mom_sys_arr
  }
  PB_com_unset_var gPB(vnc_common_sourced)
  PB_com_unset_var gPB(vnc_subordinate_sourced)
  global mach_type controller
  PB_file_GetPostAttr $pui_file_name machine_type axis_option output_unit
  set mach_type $machine_type
  set controller "$pui_file_name"
  set vnc  [file rootname $controller]_vnc.tcl
  if { ![file exists $vnc] } {
   set controller_save $controller
   set controller "Generic"
   PB_file_ParseVNCTclFile $post_object
   set controller $controller_save
   } else {
   PB_file_ParseVNCTclFile $post_object
   if [string match "Standalone" $mom_sys_arr(VNC_Mode)] {
    set gPB(vnc_common_sourced) 1
    } else {
    set gPB(vnc_subordinate_sourced) 1
   }
  }
  if [catch { PB_file_CreatePostObjects $post_object } result] {
   return [ error "$errorInfo" ]
  }
  if { $gPB(post_controller_type) != "" && \
  ![UI_PB_file_SetCntlFamilyInfoForOldFile $pui_file_name] } \
  {
   __file_GetCurrentSysControllerFullName $gPB(mach_sys_controller) templete_file $machine_type
   set templete_dir [file dirname $templete_file]
   if [PB_file_ParseMacroInfoFile $templete_dir] \
   {
    set gPB(controller_family_dir) $templete_dir
   }
  }
  if { [info exists mom_sys_arr(Output_VNC)] && ($mom_sys_arr(Output_VNC) == 1) } {
   PB_int_RecreateVNCCommand
   __isv_GetCommandDisplayList display_com_list
  }
  return $ret_code
 }

#=======================================================================
proc PB_file_Create { pui_file_list args } {
  global post_object
  global controller
  global gPB
  global errorInfo
  if ![info exists gPB(JE_POST_DEV)] {
   set gPB(JE_POST_DEV) 0
  }
  PB_com_unset_var gPB(diff_post_flag)
  PB_com_unset_var gPB(vnc_common_sourced)
  PB_com_unset_var gPB(vnc_subordinate_sourced)
  PB_com_unset_var gPB(vnc_controller_sourced)
  global mach_type
  if { ![info exists mach_type] && [info exists gPB(new_machine_type)] } {
   set mach_type $gPB(new_machine_type)
  }
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
   if { $gPB(DEBUG) } { tk_messageBox -type ok -icon info -message "Parsing PUI : $pui_file" }
   UI_PB_GetPostVersion pui_file gPB(PUI_Version)
   if [info exists ui_overwrite_sw_list] \
   {
    set gPB(pui_ui_overwrite) [lindex $ui_overwrite_sw_list $idx]
   }
   if { [info exists gPB(old_version_pui_idx)] } \
   {
    if { $idx == $gPB(old_version_pui_idx) } {
     set gPB(parse_old_version_flag) 1
     } else {
     set gPB(parse_old_version_flag) 0
    }
   }
   if [ catch { PB_com_ReadPuiFile pui_file pui_file_id post_object } result ] {
    UI_PB_debug_ForceMsg "$result"
    return [ error "$errorInfo" ]
   }
   if { [PB_is_v $gPB(VNC_release)] == 0 } {
    array set mom_sys_arr $Post::($post_object,mom_sys_var_list)
    set mom_sys_arr(Output_VNC) 0
    set mom_sys_arr(Main_VNC) ""
    PB_int_UpdateMOMVar mom_sys_arr
   }
   if [ catch { PB_file_ParsePostFiles $post_object } result ] {
    return [ error "$errorInfo" ]
   }
   set controller_save $controller
   if { [string match "*mill_base.pb"  $pui_file] || \
    [string match "*lathe_base.pb" $pui_file] || \
    [string match "*wedm_base.pb"  $pui_file] } {
    set controller "Upgrade_VNC_Common"
   }
   if { ![string match "" $gPB(post_controller_type)] && \
    [string match "*$gPB(post_controller_type).pb" $pui_file] } {
    set controller "Upgrade_VNC_Common"
   }
   if { ![string match "" $gPB(post_controller_type)] && \
    [info exists gPB(old_version_pui_idx)] } {
    if { $gPB(parse_old_version_flag) } {
     PB_file_ParseVNCTclFile $post_object
    }
    } else {
    PB_file_ParseVNCTclFile $post_object
   }
   set controller $controller_save
   incr idx
  }
  PB_file_ParsePostUtilityFile $post_object
  global env
  global mach_cntl_type
  if { $env(PB_UDE_ENABLED) == 1 } {
   if { [info exists ::mach_cntl_type] && ![info exists ::gPB(old_own_cdl_file)] } {
    if { $mach_cntl_type == "User" } {
     set cdl_file "[file rootname $gPB(mach_user_controller)].cdl"
     if [file exists $cdl_file] {
      set cdl_file_name $cdl_file
      } else {
      set cdl_file_name "$env(PB_HOME)/pblib/ude.cdl"
     }
     } elseif { $mach_cntl_type == "System" } {
     set cdl_file [file rootname $controller].cdl
     if [file exists $cdl_file] {
      set cdl_file_name $cdl_file
      } else {
      set cdl_file_name "$env(PB_HOME)/pblib/ude.cdl"
     }
     } else {
     set cdl_file_name "$env(PB_HOME)/pblib/ude.cdl"
    }
    } else {
    if [info exists ::gPB(old_own_cdl_file)] {
     set cdl_file_name $::gPB(old_own_cdl_file)
     unset ::gPB(old_own_cdl_file)
     } else {
     set cdl_file_name "$env(PB_HOME)/pblib/ude.cdl"
    }
   }
   set cdl_file_id FP3
   PB_com_ReadUdeFile cdl_file_name cdl_file_id post_object
  }
  if { $Post::($post_object,tcl_file_read) != "TRUE"  || \
   $Post::($post_object,def_file_read) != "TRUE" } {
   UI_PB_debug_ForceMsg "$gPB(msg,invalid_post)"
   return [ error "$gPB(msg,invalid_post)" ]
  }
  if 0 {
   PB_file_ParseVNCTclFile $post_object
  }
  set ret_code [PB_file_CreatePostObjects $post_object]
  if [string match "mom_sys_arr" [info locals mom_sys_arr]] {
   unset mom_sys_arr
  }
  global mom_sys_arr mom_sim_arr
  if { [info exists mom_sys_arr(Output_VNC)] && \
  $gPB(new_enable_choose_vnc) && !$gPB(new_vnc_flag) } \
  {
   set mom_sys_arr(Output_VNC) 0
  }
  if {[info exists mom_sys_arr(Output_VNC)] && ($mom_sys_arr(Output_VNC) == 1)} {
   if {[info exists ::gPB(old_own_vnc_tag)] && $::gPB(old_own_vnc_tag)} {
    if {[info exists mom_sys_arr(VNC_Mode)]} {
     if {[string match "Standalone" $mom_sys_arr(VNC_Mode)]} {
      set ::gPB(main_vnc_tag) 1
      } else {
      set ::gPB(main_vnc_tag) 0
     }
    }
   }
   PB_int_RecreateVNCCommand
   __isv_GetCommandDisplayList display_com_list
  }
  return $ret_code
 }

#=======================================================================
proc PB_file_ParseMainPost { main_post } {
  global post_object
  global gPB
  if { ![file exists $main_post] } {
   return
  }
  set def_file "[file rootname $main_post].def"
  set vnc_file "[file rootname $main_post]_vnc.tcl"
  UI_PB_file_GetPostControllerType main_post gPB(main_post_controller_type)
  set file_id [open "$main_post" r]
  set mom_sys_start 0
  set mom_kin_start 0
  set mom_sim_start 0
  set mom_sys_var_list [list \$mom_sys_rapid_feed_mode(LINEAR) \$mom_sys_contour_feed_mode(LINEAR) \
  \$mom_sys_rapid_feed_mode(ROTARY) \$mom_sys_contour_feed_mode(ROTARY) \
  \$mom_sys_rapid_feed_mode(LINEAR_ROTARY) \$mom_sys_contour_feed_mode(LINEAR_ROTARY) \
  \$mom_sys_cycle_feed_mode]
  if { ![string compare "Inches" $gPB(main_post_unit)] } {
   lappend mom_sys_var_list "\$mom_sys_feed_param(IPM,format)" "\$mom_sys_feed_param(IPR,format)"
   } else {
   lappend mom_sys_var_list "\$mom_sys_feed_param(MMPM,format)" "\$mom_sys_feed_param(MMPR,format)"
  }
  set mom_kin_var_list [list \$mom_kin_linearization_tol \$mom_kin_machine_resolution \
  \$mom_kin_max_arc_radius \$mom_kin_max_fpm \$mom_kin_max_fpr \$mom_kin_min_arc_length \
  \$mom_kin_min_arc_radius \$mom_kin_min_fpm \$mom_kin_min_fpr \$mom_kin_rapid_feed_rate]
  set mom_sim_var_list [list \$mom_sim_feed_mode \$mom_sim_spindle_mode]
  set FORMAT_list [list]
  while { [gets $file_id line] >= 0 } \
  {
   set line [string trim $line]
   set line_length [string length $line]
   if { [string length [string trim $line]] == 0 } { continue }
   set last_char_test [string index $line [expr $line_length - 1]]
   if {[string compare $last_char_test \\] == 0} \
   {
    set line_with_space [string range $line 0 [expr $line_length - 2]]
    append temp_line [string trimleft $line_with_space " "]
    continue
    } elseif { [info exists temp_line] } \
   {
    append temp_line [string trimleft $line " "]
    set line $temp_line
    unset temp_line
   }
   switch -glob -- "$line" \
   {
    "## MOM SYS VARIABLES START" \
    {
     set mom_sys_start 1
    }
    "## MOM SYS VARIABLES END" \
    {
     set mom_sys_start 0
    }
    "## KINEMATIC VARIABLES START" \
    {
     set mom_kin_start 1
    }
    "## KINEMATIC VARIABLES END" \
    {
     set mom_kin_start 0
    }
    "## MOM SIM VARIABLES START" \
    {
     set mom_sim_start 1
    }
    "## MOM SIM VARIABLES END" \
    {
     set mom_sim_start 0
    }
    default \
    {
    }
   }
   if { $mom_kin_start } \
   {
    set var [lindex $line 0]
    if { [string index $var 0] != "\$" } {
     set var [format %s%s "\$" $var]
    }
    if { [lsearch $mom_kin_var_list $var] != -1 } {
     set main_kin_var_arr($var) [lindex $line 1]
    }
   }
   if { $mom_sys_start } \
   {
    set mvar [lindex $line 0]
    if { [string compare $mvar "PB_Tcl_Var"] } {
     if { ![string compare $mvar "PB_Dummy"] } {
      for { set jj 1 } { $jj < [llength $line] } { incr jj } \
      {
       set tmp_sys_var_list [lindex $line $jj]
       set tmp_sys_var [lindex $tmp_sys_var_list 0]
       if { ![string compare $tmp_sys_var "Output_VNC"] && [file exists $vnc_file]} {
        set Post::($post_object,main_post_Output_VNC) [lindex $tmp_sys_var_list 1]
        break
       }
      }
     }
     continue
    }
    for { set jj 1 } { $jj < [llength $line] } { incr jj } \
    {
     set tmp_sys_var_list [lindex $line $jj]
     set tmp_sys_var [lindex $tmp_sys_var_list 0]
     if { [lsearch $mom_sys_var_list $tmp_sys_var] != -1 } {
      set main_sys_var_arr($tmp_sys_var) [lindex $tmp_sys_var_list 1]
      if { [string match "*,format\)" $tmp_sys_var]} {
       lappend FORMAT_list [lindex $tmp_sys_var_list 1]
      }
     }
    }
   }
   if { $mom_sim_start } \
   {
    set var [lindex $line 0]
    if { [string index $var 0] != "\$" } {
     set var [format %s%s "\$" $var]
    }
    if { [lsearch $mom_sim_var_list $var] != -1 } {
     set main_sim_var_arr($var) [lindex $line 1]
    }
   }
  }
  set Post::($post_object,main_sys_var) [array get main_sys_var_arr]
  set Post::($post_object,main_kin_var) [array get main_kin_var_arr]
  if { [file exists $vnc_file] } {
   set Post::($post_object,main_sim_var) [array get main_sim_var_arr]
  }
  close $file_id
  set file_id [open "$def_file" r]
  set file_name [file tail $main_post]
  set ADDRESS_list [list X Y Z I J K R K_cycle cycle_step cycle_step1 cycle_orient E]
  set ADDRESS_list_tmp [list]
  set formatting_flag 0
  set keyword_status 0
  set fmt_index 0
  set add_index 0
  set exec_once 1
  set open_flag 0
  set close_flag 0
  while { [gets $file_id line] >= 0 } \
  {
   if { [string match "*FORMATTING*" $line] == 1}  {
    set formatting_flag 1
    continue
   }
   if { $formatting_flag }  {
    if {!$keyword_status}  {
     PB_mthd_CheckFormattingKeyWord line keyword_status
     if {$keyword_status}  {
      set text ""
     }
    }
    if {$keyword_status}  {
     switch $keyword_status  {
      4 \
      {
       lappend key_para $line
       PB_mthd_StoreKeyWordData key_para text format_arr fmt_index file_name
       incr fmt_index
       set keyword_status 0
       unset key_para
       unset text
      }
      5 \
      {
       if { !$open_flag && $exec_once } {
        set tmp_add_name [lindex $line 1]
        if { [lsearch $ADDRESS_list $tmp_add_name] != -1 } {
         set needed_add 1
         lappend ADDRESS_list_tmp $tmp_add_name
         } else {
         set needed_add 0
        }
        set exec_once 0
       }
       if { [info exists needed_add] && $needed_add } {
        set tmp_status 0
        set tmp_line [string trim $line]
        if { [string match "FORMAT*" $tmp_line] } {
         set tmp_fmt_name [lindex $line 1]
         if { [lsearch $FORMAT_list $tmp_fmt_name] == -1 } {
          lappend FORMAT_list $tmp_fmt_name
         }
        }
       }
       PB_com_CheckOpenBracesInLine line open_flag
       PB_com_CheckCloseBracesInLine line close_flag
       lappend key_para $line
       if {$close_flag}  {
        if { $needed_add } {
         PB_mthd_StoreKeyWordData key_para text address_arr add_index file_name
         incr add_index
        }
        set keyword_status 0
        unset key_para
        unset text
        set open_flag 0
        set close_flag 0
        set exec_once 1
        unset needed_add
       }
      }
      6 \
      {
       set formatting_flag 0
      }
      default \
      {
       set keyword_status 0
       unset text
      }
     }
    }
   }
  }
  close $file_id
  if { [lsearch $FORMAT_list "AbsCoord"] == -1 } {
   lappend FORMAT_list "AbsCoord"
  }
  if { [lsearch $FORMAT_list "Coordinate"] == -1 } {
   lappend FORMAT_list "Coordinate"
  }
  foreach item [array names format_arr "*,data"] {
   set format_name [lindex [lindex $format_arr($item) 0] 1]
   if { [lsearch $FORMAT_list $format_name] == -1 } {
    set len [string length $item]
    set a_item "[string range $item 0 [expr $len - 5]]text"
    unset format_arr($item)
    unset format_arr($a_item)
   }
  }
  array set format_arr_new [list]
  set ind 0
  set FORMAT_list_tmp [list]
  foreach {d_item t_item} [lsort -dictionary [array names format_arr]] {
   set f_com [string first "," $d_item]
   set d_item_tmp "[string range $d_item 0 $f_com]$ind,data"
   set t_item_tmp "[string range $t_item 0 $f_com]$ind,text"
   set format_arr_new($d_item_tmp) $format_arr($d_item)
   set format_arr_new($t_item_tmp) $format_arr($t_item)
   incr ind
   lappend FORMAT_list_tmp [lindex [lindex $format_arr($d_item) 0] 1]
  }
  set Post::($post_object,Indep_fmt_arr) [array get format_arr_new]
  set Post::($post_object,Indep_add_arr) [array get address_arr]
  set Post::($post_object,Indep_fmt_list) $FORMAT_list_tmp
  set Post::($post_object,Indep_add_list) $ADDRESS_list_tmp
 }

#=======================================================================
proc PB_file_CreateAlterUnitSubPost { pui_file_list args } {
  global post_object
  global gPB
  global errorInfo
  PB_com_unset_var gPB(vnc_common_sourced)
  PB_com_unset_var gPB(vnc_subordinate_sourced)
  PB_com_unset_var gPB(vnc_controller_sourced)
  global mach_type
  if { ![info exists mach_type] && [info exists gPB(new_machine_type)] } {
   set mach_type $gPB(new_machine_type)
  }
  set ret_code 0
  set pui_file_id FP2
  set post_object [new Post new_post]
  if [ catch { PB_file_ParseMainPost "$gPB(main_post)" } result ] {
   UI_PB_debug_ForceMsg "$result"
   return [ error "$errorInfo" ]
  }
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
   if { $gPB(DEBUG) } { tk_messageBox -type ok -icon info -message "Parsing PUI : $pui_file" }
   UI_PB_GetPostVersion pui_file gPB(PUI_Version)
   if [info exists ui_overwrite_sw_list] \
   {
    set gPB(pui_ui_overwrite) [lindex $ui_overwrite_sw_list $idx]
   }
   if [ catch { PB_com_ReadPuiFile pui_file pui_file_id post_object } result ] {
    UI_PB_debug_ForceMsg "$result"
    return [ error "$errorInfo" ]
   }
   if { [PB_is_v $gPB(VNC_release)] == 0 } {
    array set mom_sys_arr $Post::($post_object,mom_sys_var_list)
    set mom_sys_arr(Output_VNC) 0
    set mom_sys_arr(Main_VNC) ""
    PB_int_UpdateMOMVar mom_sys_arr
   }
   if { ![string compare $pui_file [lindex $pui_file_list end]] } {
    set gPB(unit_sub_post_last_def) 1
    if { [info exists gPB(alter_unit_sub_def_file)] } {
     set Post::($post_object,def_file) $gPB(alter_unit_sub_def_file)
    }
   }
   if [ catch { PB_file_ParsePostFiles $post_object } result ] {
    return [ error "$errorInfo" ]
   }
   incr idx
  }
  if { [info exists gPB(alter_unit_sub_def_file)] } {
   file delete -force $gPB(alter_unit_sub_def_file)
   unset gPB(alter_unit_sub_def_file)
  }
  if { [info exists gPB(unit_sub_post_last_def)] } {
   unset gPB(unit_sub_post_last_def)
  }
  if { $Post::($post_object,tcl_file_read) != "TRUE"  || \
  $Post::($post_object,def_file_read) != "TRUE" } \
  {
   UI_PB_debug_ForceMsg "$gPB(msg,invalid_post)"
   return [ error "$gPB(msg,invalid_post)" ]
  }
  set ret_code [PB_file_CreatePostObjects $post_object]
  if { [info exists gPB(main_post_controller_type)] } {
   set gPB(post_controller_type) $gPB(main_post_controller_type)
  }
  if { [info exists gPB(main_post_controller_type)] } {
   set gPB(post_controller) $gPB(main_post_controller)
  }
  return $ret_code
 }

#=======================================================================
proc PB_GetVncCommandFrmPostObj { } {
  global gPB post_object
  global mom_sim_arr mom_sys_arr
  UI_PB_cmd_ImportVNCCmds vnc
 }

#=======================================================================
proc PB_InitialVNC_Seqlist { } {
  global post_object
  global mom_sys_arr
  global mom_sim_arr rest_mom_sim_arr
  if {![info exists mom_sim_arr(\$mom_sim_vnc_com_list)]} {
   set mom_sim_arr(\$mom_sim_vnc_com_list) [list]
  }
  if {![info exists mom_sim_arr(\$mom_sim_sub_vnc_list)]} {
   set mom_sim_arr(\$mom_sim_sub_vnc_list) [list]
  }
  if {![info exists mom_sim_arr(\$mom_sim_user_com_list)]} {
   set mom_sim_arr(\$mom_sim_user_com_list) [list]
  }
 }

#=======================================================================
proc PB_file_ParseVNCTclFile { post_object } {
  global gPB
  global env
  global mach_type controller
  if [PB_is_v $gPB(VNC_release)] {
   array set mom_sys_arr $Post::($post_object,mom_sys_var_list)
   array set mom_sim_arr $Post::($post_object,mom_sim_var_list)
   if { ![info exists mom_sys_arr(Output_VNC)] } {
    return
    } else {
    if { $mom_sys_arr(Output_VNC) == 0 } {
     return
    }
   }
   if 0 {
    if { [string match "Standalone" $mom_sys_arr(VNC_Mode)] && [info exists gPB(vnc_common_sourced)] } {
     return
    }
   }
   if { [info exists gPB(vnc_common_sourced)] } {
    return
   }
   set vnc_tcl_file ""
   switch $mach_type {
    "Mill" {
     set vnc_tcl_file "$env(PB_HOME)/pblib/mill_base_vnc.tcl"
    }
    "Lathe" {
     set vnc_tcl_file "$env(PB_HOME)/pblib/lathe_base_vnc.tcl"
    }
    "Wedm" {
     set vnc_tcl_file "$env(PB_HOME)/pblib/wedm_base_vnc.tcl"
    }
    "Punch" {
    }
   }
   UI_PB_debug_ForceMsg "\n=====> controller : $controller\n"
   if { ![string match "Generic" $controller] && \
    ![string match "" $controller] } {
    set vnc  [file rootname $controller]_vnc.tcl
    if [file exists $vnc] {
     set vnc_tcl_file $vnc
     if { [info exists gPB(vnc_controller_sourced)] && $gPB(vnc_controller_sourced) } {
      return
     }
     set gPB(vnc_controller_sourced) 1
    }
   }
   if [string match "Standalone" $mom_sys_arr(VNC_Mode)] {
    if [string match "Generic" $controller] {
     set vnc_common "$env(PB_HOME)/pblib/vnc_common.tcl"
     if { $gPB(new_enable_choose_vnc) && !$gPB(new_vnc_flag) } \
     {
      lappend gPB(post_vnc_list) $vnc_common
     } else \
     {
      PB_pps_CreateTclFileObjs post_object $vnc_common 0
     }
     set gPB(vnc_common_sourced) 1
     } elseif [string match "Upgrade_VNC_Common" $controller] {
     if { ![info exists gPB(Old_PUI_Version)] } {
      set gPB(Old_PUI_Version) $gPB(Postbuilder_PUI_Version)
      set vnc_tcl_file "$env(PB_HOME)/pblib/vnc_common.tcl"
      if { $gPB(new_enable_choose_vnc) && !$gPB(new_vnc_flag) } \
      {
       lappend gPB(post_vnc_list) $vnc_tcl_file
      } else \
      {
       PB_pps_CreateTclFileObjs post_object $vnc_tcl_file 0
      }
      set gPB(vnc_common_sourced) 1
     }
     set old_version $gPB(Old_PUI_Version)
     UI_PB_debug_ForceMsg "\n=====> old_version before : $old_version\n"
     if { [string compare $old_version "2007.5.0.0"] >= 0  && \
      [string compare $old_version "2008.0.4.1"] < 0 } {
      set old_version "2007.0.2.0"
      UI_PB_debug_ForceMsg "\n=====> old_version after  : $old_version\n"
     }
     set ver_list [list "2002.2.1.3"\
     "2002.3.0.3"\
     "2002.4.0.0"\
     "2002.4.1.1"\
     "2002.5.0.1"\
     "2002.5.1.2"\
     "2002.5.2.0"\
     "2004.0.0.0"\
     "2004.0.1.0"\
     "2004.0.2.2"\
     "2005.0.0.2"\
     "2005.0.1.0"\
     "2005.0.2.1"\
     "2005.0.3.2"\
     "2006.0.0.1"\
     "2006.5.0.1"\
     "2006.5.1.0"\
     "2006.5.2.0"\
     "2007.0.0.4"\
     "2007.0.1.0"\
     "2007.0.2.0"\
     "2007.5.0.0"\
     "$gPB(Postbuilder_PUI_Version)"]
     foreach version $ver_list {
      if { [string compare $old_version $version] < 0 } {
       set v_lis [split $version .]
       set v_lis [lreplace $v_lis end end]
       set v_lis [lreplace $v_lis 0 0 [expr [lindex $v_lis 0] - 1999] ]
       set ver [join $v_lis ""]
       set vnc_tcl_file "$env(PB_HOME)/pblib/vnc_common_v$ver.tcl"
       if [file exists $vnc_tcl_file] {
        if { $gPB(new_enable_choose_vnc) && !$gPB(new_vnc_flag) } \
        {
         lappend gPB(post_vnc_list) $vnc_tcl_file
        } else \
        {
         PB_pps_CreateTclFileObjs post_object $vnc_tcl_file 0
        }
       }
      }
     }
     set vnc_tcl_file ""
     set gPB(vnc_common_sourced) 1
    }
    } else {
    if { [info exists gPB(vnc_subordinate_sourced)] } {
     return
    }
    if { ![info exists gPB(Old_PUI_Version)] } {
     set gPB(Old_PUI_Version) $gPB(Postbuilder_PUI_Version)
     set vnc_common "$env(PB_HOME)/pblib/vnc_subordinate.tcl"
     if { $gPB(new_enable_choose_vnc) && !$gPB(new_vnc_flag) } {
      lappend gPB(post_vnc_list) $vnc_common
      } else {
      PB_pps_CreateTclFileObjs post_object $vnc_common 0
     }
     set gPB(vnc_subordinate_sourced) 1
    }
   }
   if { ![string match "Upgrade_VNC_Common" $controller] } {
    if { ![string match "" $vnc_tcl_file] && [file exists $vnc_tcl_file] } {
     if { ![info exists gPB(Old_PUI_Version)] } {
      set gPB(Old_PUI_Version) $gPB(PUI_Version)
     }
     if { $gPB(new_enable_choose_vnc) && !$gPB(new_vnc_flag) } {
      lappend gPB(post_vnc_list) $vnc_tcl_file
      } else {
      PB_pps_CreateTclFileObjs post_object $vnc_tcl_file 0
     }
     if { [string compare $gPB(Old_PUI_Version) "2007.5.0.0"] >= 0  && \
      [string compare $gPB(Old_PUI_Version) "2008.0.4.1"] < 0 } {
      set vnc_tcl_file "$env(PB_HOME)/pblib/vnc_common_v850.tcl"
      PB_pps_CreateTclFileObjs post_object $vnc_tcl_file 0
     }
    }
   }
   Post::GetObjList $post_object command cmd_obj_list
   PB_com_SortObjectsByNames cmd_obj_list
   Post::SetObjListasAttr $post_object cmd_obj_list
   update
  } ;# gPB(VNC_release)
 }

#=======================================================================
proc PB_file_ParsePostFiles { post_object } {
  global gPB
  global errorInfo
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
   if [ catch { PB_com_ReadDfltDefFile def_file def_file_id post_object } ] {
    return [ error "$gPB(msg,bad_def_file) : \n\n$errorInfo" ]
    } else {
    set Post::($post_object,def_file_read) TRUE
   }
  }
  if { [info exists ::env(UNIT_SUB_POST_MODE)] && $::env(UNIT_SUB_POST_MODE) == 1 } {
   if { [info exists gPB(unit_sub_post_last_def)] && $gPB(unit_sub_post_last_def) == 1 } {
    set tcl_file_name ""
   }
  }
  set tcl_file_name [string trim $tcl_file_name \"]
  set tcl_file_name [string trim $tcl_file_name]
  if { $tcl_file_name != "" } \
  {
   global env
   set change_overwrite_flag 0
   if { ![info exists gPB(ALREADY_LOAD_BASE_TCL)] } {
    set gPB(ALREADY_LOAD_BASE_TCL) 0
   }
   if { [info exists gPB(unit_sub_post_mode)] && $gPB(unit_sub_post_mode) == 1 } {
    set gPB(ALREADY_LOAD_BASE_TCL) 1
   }
   if { !$gPB(ALREADY_LOAD_BASE_TCL) && \
    [string match "PB_file_Open" [lindex [info level -1] 0]] } {
    set gPB(ALREADY_LOAD_BASE_TCL) 1
   }
   if { !$gPB(ALREADY_LOAD_BASE_TCL) } {
    set base_file "$env(PB_HOME)/pblib/pb_post_base.tcl"
    if { [file exists "$base_file"] && \
     [catch { PB_pps_CreateTclFileObjs post_object $base_file 1 }] } {
     return [ error "$gPB(msg,bad_tcl_file) : \n\n$errorInfo" ]
    }
    set gPB(ALREADY_LOAD_BASE_TCL) 1
    if { [info exists gPB(pui_ui_overwrite)] && !$gPB(pui_ui_overwrite) } {
     set change_overwrite_flag 1
    }
    set gPB(NEED_LOAD_POST_UTIL) 1
   }
   if { ![info exists gPB(ALREADY_LOAD_BASE_UDE)] } {
    set gPB(ALREADY_LOAD_BASE_UDE) 0
   }
   if { [info exists env(PB_UDE_ENABLED)] && $env(PB_UDE_ENABLED) == 1 && \
    $gPB(ALREADY_LOAD_BASE_UDE) == 0 } {
    if { ![file exists [file join $dir [file rootname $tcl_file_name].cdl]] } {
     set base_file "$env(PB_HOME)/pblib/pb_ude_base.tcl"
     if { [file exists "$base_file"] && \
      [catch { PB_pps_CreateTclFileObjs post_object $base_file 1 }] } {
      return [ error "$gPB(msg,bad_tcl_file) : \n\n$errorInfo" ]
     }
     set gPB(ALREADY_LOAD_BASE_UDE) 1
    }
   }
   set tcl_file [file join $dir "$tcl_file_name"]
   if { [info exists gPB(mill_common_family_dir_prefix)] && \
    ([string match "mill_3.tcl" $tcl_file_name] || \
    [string match "mill_5.tcl" $tcl_file_name] || \
   [string match "mill_kin_xzc.tcl" $tcl_file_name]) } \
   {
    if [file exists "$gPB(mill_common_family_dir_prefix)_$tcl_file_name"] \
    {
     set tcl_file "$gPB(mill_common_family_dir_prefix)_$tcl_file_name"
    }
   }
   if { ![file exists "$tcl_file"] } {
    return [ error "$tcl_file : $gPB(msg,invalid_file)" ]
   }
   if { $change_overwrite_flag } {
    set gPB(pui_ui_overwrite) 1
   }
   if { [string match "mill_5.tcl"       $tcl_file_name] || \
    [string match "mill_kin_xzc.tcl" $tcl_file_name] } {
    set base_file "$env(PB_HOME)/pblib/mill_5_common.tcl"
    if { [file exists "$base_file"] && \
     [catch { PB_pps_CreateTclFileObjs post_object $base_file 1 }] } {
     if { $change_overwrite_flag } {
      set gPB(pui_ui_overwrite) 0
     }
     return [ error "$gPB(msg,bad_tcl_file) : \n\n$errorInfo" ]
    }
   }
   if [ catch { PB_pps_CreateTclFileObjs post_object $tcl_file 1 } ] {
    if { $change_overwrite_flag } {
     set gPB(pui_ui_overwrite) 0
    }
    return [ error "$gPB(msg,bad_tcl_file) : \n\n$errorInfo" ]
    } else {
    set Post::($post_object,tcl_file_read) TRUE
    if { $change_overwrite_flag } {
     set gPB(pui_ui_overwrite) 0
    }
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
    $block::($block_obj,blk_type) != "comment" && \
   $block::($block_obj,blk_type) != "macro" } \
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
   if 0 {
    if { $block::($block_obj,block_name) == "rapid_spindle" } {
     if [info exists blk_elem_list] \
     {
      unset blk_elem_list
     }
     continue
    }
   }
   if { ![info exists blk_elem_list] || [llength $blk_elem_list] == 0 } \
   {
    UI_PB_debug_ForceMsg "Delete empty block $block_obj $block::($block_obj,block_name)"
    set blk_evt_elem_list $block::($block_obj,evt_elem_list)
    foreach e $blk_evt_elem_list { ;#<12-20-01 gsl> There was a ")" after "list" that
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
    PB_com_DeleteObject $block_obj
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
  PB_file_CreateSpecialEvents post_object
  global gPB
  set gPB(update_v300_cycles) 0
  if $gPB(update_v300_cycles) {
   Post::GetObjList $post_object sequence seq_obj_list
   set seq_name "Cycles"
   PB_com_RetObjFrmName seq_name seq_obj_list seq_obj
   if { $seq_obj > 0 } {
    set evt_obj_list $sequence::($seq_obj,evt_obj_list)
    array set mom_sys_arr $Post::($post_object,mom_sys_var_list)
    foreach evt_obj $evt_obj_list {
     set cycle_recon 0
     switch $event::($evt_obj,event_name) {
      "Cycle Parameters" {
       set cycle_recon 1
      }
      "Drill" {
       if { [info exists mom_sys_arr(\$mom_sys_sim_cycle_drill)] && \
        $mom_sys_arr(\$mom_sys_sim_cycle_drill) == 0 } {
        set cycle_recon 1
       }
      }
      "Drill Dwell" {
       if { [info exists mom_sys_arr(\$mom_sys_sim_cycle_drill_dwell)] && \
        $mom_sys_arr(\$mom_sys_sim_cycle_drill_dwell) == 0 } {
        set cycle_recon 1
       }
      }
      "Drill Deep" {
       if { [info exists mom_sys_arr(\$mom_sys_sim_cycle_drill_deep)] && \
        $mom_sys_arr(\$mom_sys_sim_cycle_drill_deep) == 0 } {
        set cycle_recon 1
       }
      }
      "Drill Break Chip" {
       if { [info exists mom_sys_arr(\$mom_sys_sim_cycle_drill_break_chip)] && \
        $mom_sys_arr(\$mom_sys_sim_cycle_drill_break_chip) == 0 } {
        set cycle_recon 1
       }
      }
      "Tap" {
       if { [info exists mom_sys_arr(\$mom_sys_sim_cycle_tap)] && \
        $mom_sys_arr(\$mom_sys_sim_cycle_tap) == 0 } {
        set cycle_recon 1
       }
      }
      "Tap Deep" {
       if { [info exists mom_sys_arr(\$mom_sys_sim_cycle_tap_deep)] && \
        $mom_sys_arr(\$mom_sys_sim_cycle_tap_deep) == 0 } {
        set cycle_recon 1
       }
      }
      "Tap Float" {
       if { [info exists mom_sys_arr(\$mom_sys_sim_cycle_tap_float)] && \
        $mom_sys_arr(\$mom_sys_sim_cycle_tap_float) == 0 } {
        set cycle_recon 1
       }
      }
      "Tap Break Chip" {
       if { [info exists mom_sys_arr(\$mom_sys_sim_cycle_tap_break_chip)] && \
        $mom_sys_arr(\$mom_sys_sim_cycle_tap_break_chip) == 0 } {
        set cycle_recon 1
       }
      }
      "Bore" {
       if { [info exists mom_sys_arr(\$mom_sys_sim_cycle_bore)] && \
        $mom_sys_arr(\$mom_sys_sim_cycle_bore) == 0 } {
        set cycle_recon 1
       }
      }
      "Bore Drag" {
       if { [info exists mom_sys_arr(\$mom_sys_sim_cycle_bore_drag)] && \
        $mom_sys_arr(\$mom_sys_sim_cycle_bore_drag) == 0 } {
        set cycle_recon 1
       }
      }
      "Bore No Drag" {
       if { [info exists mom_sys_arr(\$mom_sys_sim_cycle_bore_nodrag)] && \
        $mom_sys_arr(\$mom_sys_sim_cycle_bore_nodrag) == 0 } {
        set cycle_recon 1
       }
      }
      "Bore Manual" {
       if { [info exists mom_sys_arr(\$mom_sys_sim_cycle_bore_manual)] && \
        $mom_sys_arr(\$mom_sys_sim_cycle_bore_manual) == 0 } {
        set cycle_recon 1
       }
      }
      "Bore Dwell" {
       if { [info exists mom_sys_arr(\$mom_sys_sim_cycle_bore_dwell)] && \
        $mom_sys_arr(\$mom_sys_sim_cycle_bore_dwell) == 0 } {
        set cycle_recon 1
       }
      }
      "Bore Manual Dwell" {
       if { [info exists mom_sys_arr(\$mom_sys_sim_cycle_bore_manual_dwell)] && \
        $mom_sys_arr(\$mom_sys_sim_cycle_bore_manual_dwell) == 0 } {
        set cycle_recon 1
       }
      }
      "Bore Back" {
       if { [info exists mom_sys_arr(\$mom_sys_sim_cycle_bore_back)] && \
        $mom_sys_arr(\$mom_sys_sim_cycle_bore_back) == 0 } {
        set cycle_recon 1
       }
      }
     }
     if $cycle_recon {
      PB_int_CreateCycleRaptoBlks     evt_obj mom_sys_arr
      PB_int_CreateCycleRetractoBlks  evt_obj mom_sys_arr
     }
    }
   }
  }
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
       UI_PB_debug_DisplayMsg "      $j ($obj) : $address::($addr,add_name) ($addr)"
      }
     }
    }
   }
  }
  if { [llength $Post::($::post_object,ext_fmt_list)] || \
   [llength $Post::($::post_object,ext_add_list)] || \
   [llength $Post::($::post_object,ext_blk_list)] || \
   [llength $Post::($::post_object,ext_cmd_list)] || \
   [llength $Post::($::post_object,ext_fun_list)] || \
   [llength $Post::($::post_object,ext_ude_list)] || \
   [llength $Post::($::post_object,ext_cyc_list)] } {
   set Post::($::post_object,has_external) 1
  }
  UI_PB_debug_ForceMsg_no_trace "has_external : $Post::($::post_object,has_external)<"
  UI_PB_debug_ForceMsg_no_trace "ext_fmt_list : $Post::($::post_object,ext_fmt_list)<"
  UI_PB_debug_ForceMsg_no_trace "ext_add_list : $Post::($::post_object,ext_add_list)<"
  UI_PB_debug_ForceMsg_no_trace "ext_blk_list : $Post::($::post_object,ext_blk_list)<"
  UI_PB_debug_ForceMsg_no_trace "ext_cmd_list : $Post::($::post_object,ext_cmd_list)<"
  UI_PB_debug_ForceMsg_no_trace "ext_fun_list : $Post::($::post_object,ext_fun_list)<"
  UI_PB_debug_ForceMsg_no_trace "ext_ude_list : $Post::($::post_object,ext_ude_list)<"
  UI_PB_debug_ForceMsg_no_trace "ext_cyc_list : $Post::($::post_object,ext_cyc_list)<"
  set gPB(backup_one_done) 0
  __file_GetAddVarOnTpthEvenPage
  return 0
 }

#=======================================================================
proc PB_file_CreateSpecialEvents { POST_OBJ } {
  upvar $POST_OBJ post_obj
  global mom_sys_arr
  if ![info exists mom_sys_arr(User_Def_Axis_Limit_Act)] \
  {
   set evt_blk_list ""
  } else \
  {
   set evt_blk_list [lindex $mom_sys_arr(User_Def_Axis_Limit_Act) 0]
  }
  set event_name "User_Def_Axis_Limit_Act"
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
  foreach row_elem $evt_blk_list \
  {
   PB_evt_ReparserBlockName row_elem
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
    } elseif {$blk_obj == 0 && [lsearch $function_list $row_elem] != -1} \
   {
    set func_obj 0
    PB_com_RetObjFrmName row_elem func_blk_list func_obj
    PB_blk_CreateFuncBlkElem row_elem func_obj func_blk_elem
    PB_blk_CreateFuncBlkObj row_elem func_blk_elem blk_obj
    set block_element::($func_blk_elem,func_prefix) $::g_func_prefix
    set block_element::($func_blk_elem,func_suppress_flag) $::g_func_suppress_flag
    } elseif {$blk_obj == 0 && [lsearch $vnc_list $row_elem] != -1} \
   {
    set cmd_obj 0
    __seq_CreateVNCBlkElem  row_elem cmd_obj blk_elem
    set block_element::($blk_elem,force) $mom_sys_var($row_elem)
    __seq_CreateVNCBlk      row_elem blk_elem blk_obj
    UI_PB_debug_ForceMsg "$row_elem  >$mom_sys_var($row_elem)< >$blk_obj<"
    } elseif { $blk_obj == 0 } \
   {
    continue
   }
   PB_evt_SetOwnerShipForBlkElem blk_obj event_name
   set evt_elem_obj_attr(0) $row_elem
   set evt_elem_obj_attr(1) $blk_obj
   PB_evt_CreateEventElement evt_elem_obj evt_elem_obj_attr
   unset evt_elem_obj_attr
   lappend row_elem_list $evt_elem_obj
  }
  if {[info exists row_elem_list]}\
  {
   set evt_blk_list $row_elem_list
   unset row_elem_list
  } else\
  {
   set evt_blk_list ""
  }
  global gPB
  set evt_obj_attr(0) $event_name
  set evt_obj_attr(1) [llength $evt_blk_list]
  set evt_obj_attr(2) $evt_blk_list
  set evt_obj_attr(3) ""
  set evt_obj_attr(4) "$gPB(machine,axis,violation,user,evt_title)"
  set evt_obj [new event]
  event::setvalue $evt_obj evt_obj_attr
  event::DefaultValue $evt_obj evt_obj_attr
  event::RestoreValue $evt_obj
  set Post::($post_obj,axis_limit_evt_obj) $evt_obj
 }

#=======================================================================
proc xPB_file_MapNewIKSParams_07-11-08 { args } {
  global post_object
  global mom_kin_var
  if { [string match "*wedm" $mom_kin_var(\$mom_kin_machine_type)]  ||\
   [string match "*lathe" $mom_kin_var(\$mom_kin_machine_type)] ||\
   [string match "*punch" $mom_kin_var(\$mom_kin_machine_type)] ||\
   [string match "*3*" $mom_kin_var(\$mom_kin_machine_type)] } {
   foreach i { 0 1 2 } {
    set mom_kin_var(\$mom_kin_machine_zero_offset($i)) 0.0
   }
   foreach axis { 4th 5th } {
    foreach i { 0 1 2 } {
     set mom_kin_var(\$mom_kin_${axis}_axis_center_offset($i)) 0.0
     set mom_kin_var(\$mom_kin_${axis}_axis_point($i)) 0.0
    }
   }
   } else {
   set pg_vec(0) 0.0
   set pg_vec(1) 0.0
   set pg_vec(2) $mom_kin_var(\$mom_kin_pivot_gauge_offset)
   if [string match "*4*" $mom_kin_var(\$mom_kin_machine_type)] {
    foreach i { 0 1 2 } {
     set mom_kin_var(\$mom_kin_machine_zero_offset($i)) \
     [expr $pg_vec($i) + $mom_kin_var(\$mom_kin_4th_axis_center_offset\($i\))]
    }
    if [string match "Table" $mom_kin_var(\$mom_kin_4th_axis_type)] {
     foreach i { 0 1 2 } {
      set mom_kin_var(\$mom_kin_4th_axis_point($i)) $mom_kin_var(\$mom_kin_machine_zero_offset\($i\))
     }
     } else {
     foreach i { 0 1 2 } {
      set mom_kin_var(\$mom_kin_4th_axis_point($i)) $pg_vec($i)
     }
    }
    foreach i { 0 1 2 } {
     set mom_kin_var(\$mom_kin_5th_axis_point($i)) 0.0
    }
    UI_PB_mach_SetPlaneNormalVector 4TH_AXIS
    } elseif [string match "*5*" $mom_kin_var(\$mom_kin_machine_type)] {
    set machine_kin "HH"
    switch $mom_kin_var(\$mom_kin_4th_axis_type) {
     Head  {
      switch $mom_kin_var(\$mom_kin_5th_axis_type) {
       Head  {
       }
       Table {
        set machine_kin "HT"
       }
      }
     }
     Table {
      switch $mom_kin_var(\$mom_kin_5th_axis_type) {
       Head  {
        set machine_kin "TH"
       }
       Table {
        set machine_kin "TT"
       }
      }
     }
    }
    foreach i { 0 1 2 } {
     set mom_kin_var(\$mom_kin_machine_zero_offset($i)) \
     [expr $pg_vec($i) + $mom_kin_var(\$mom_kin_4th_axis_center_offset\($i\)) +\
     $mom_kin_var(\$mom_kin_5th_axis_center_offset\($i\))]
    }
    switch $machine_kin {
     "HH" {
      foreach i { 0 1 2 } {
       set mom_kin_var(\$mom_kin_4th_axis_point($i)) \
       [expr $pg_vec($i) + $mom_kin_var(\$mom_kin_4th_axis_center_offset\($i\))]
       set mom_kin_var(\$mom_kin_5th_axis_point($i)) $pg_vec($i)
      }
     }
     "HT" {
      foreach i { 0 1 2 } {
       set mom_kin_var(\$mom_kin_4th_axis_point($i)) $pg_vec($i)
       set mom_kin_var(\$mom_kin_5th_axis_point($i)) $mom_kin_var(\$mom_kin_machine_zero_offset\($i\))
      }
     }
     "TH" {
      foreach i { 0 1 2 } {
       set mom_kin_var(\$mom_kin_5th_axis_point($i)) $pg_vec($i)
       set mom_kin_var(\$mom_kin_4th_axis_point($i)) $mom_kin_var(\$mom_kin_machine_zero_offset\($i\))
      }
     }
     "TT" {
      foreach i { 0 1 2 } {
       set mom_kin_var(\$mom_kin_4th_axis_point($i)) \
       [expr $pg_vec($i) + $mom_kin_var(\$mom_kin_4th_axis_center_offset\($i\))]
       set mom_kin_var(\$mom_kin_5th_axis_point($i)) $mom_kin_var(\$mom_kin_machine_zero_offset\($i\))
      }
     }
    }
    UI_PB_mach_SetPlaneNormalVector 4TH_AXIS
    UI_PB_mach_SetPlaneNormalVector 5TH_AXIS
    } else {
    if 0 {
     foreach axis { 4th 5th } {
      foreach i { 0 1 2 } {
       set mom_kin_var(\$mom_kin_${axis}_axis_point($i)) 0.0
      }
     }
    }
   }
  }
  set Post::($post_object,mom_kin_var_list)     [array get mom_kin_var]
  set Post::($post_object,def_mom_kin_var_list) [array get mom_kin_var]
 }

#=======================================================================
proc PB_file_MapNewIKSParams { args } {
  global post_object
  global mom_kin_var
  if { [string match "*wedm" $mom_kin_var(\$mom_kin_machine_type)]  ||\
   [string match "*lathe" $mom_kin_var(\$mom_kin_machine_type)] ||\
   [string match "*punch" $mom_kin_var(\$mom_kin_machine_type)] ||\
   [string match "*3*" $mom_kin_var(\$mom_kin_machine_type)] } {
   foreach i { 0 1 2 } {
    set mom_kin_var(\$mom_kin_machine_zero_offset($i)) 0.0
   }
   foreach axis { 4th 5th } {
    foreach i { 0 1 2 } {
     set mom_kin_var(\$mom_kin_${axis}_axis_center_offset($i)) 0.0
     set mom_kin_var(\$mom_kin_${axis}_axis_point($i)) 0.0
    }
   }
   } else {
   if ![string length [string trim $mom_kin_var(\$mom_kin_spindle_axis\(0\))]] {
    set mom_kin_var(\$mom_kin_spindle_axis(0)) 0.0
   }
   if ![string length [string trim $mom_kin_var(\$mom_kin_spindle_axis\(1\))]] {
    set mom_kin_var(\$mom_kin_spindle_axis(1)) 0.0
   }
   if ![string length [string trim $mom_kin_var(\$mom_kin_spindle_axis\(2\))]] {
    set mom_kin_var(\$mom_kin_spindle_axis(2)) 1.0
   }
   foreach i { 0 1 2 } {
    set pg_vec($i) [expr $mom_kin_var(\$mom_kin_spindle_axis\($i\))*$mom_kin_var(\$mom_kin_pivot_gauge_offset)]
   }
   if [string match "*4*" $mom_kin_var(\$mom_kin_machine_type)] {
    foreach i { 0 1 2 } {
     set mom_kin_var(\$mom_kin_machine_zero_offset($i)) \
     [expr $pg_vec($i) + $mom_kin_var(\$mom_kin_4th_axis_center_offset\($i\))]
    }
    if [string match "Table" $mom_kin_var(\$mom_kin_4th_axis_type)] {
     foreach i { 0 1 2 } {
      set mom_kin_var(\$mom_kin_4th_axis_point($i)) $mom_kin_var(\$mom_kin_machine_zero_offset\($i\))
     }
     } else {
     foreach i { 0 1 2 } {
      set mom_kin_var(\$mom_kin_4th_axis_point($i)) $pg_vec($i)
     }
    }
    foreach i { 0 1 2 } {
     set mom_kin_var(\$mom_kin_5th_axis_point($i)) 0.0
    }
    UI_PB_mach_SetPlaneNormalVector 4TH_AXIS
    } elseif [string match "*5*" $mom_kin_var(\$mom_kin_machine_type)] {
    set machine_kin "HH"
    switch $mom_kin_var(\$mom_kin_4th_axis_type) {
     Head  {
      switch $mom_kin_var(\$mom_kin_5th_axis_type) {
       Head  {
       }
       Table {
        set machine_kin "HT"
       }
      }
     }
     Table {
      switch $mom_kin_var(\$mom_kin_5th_axis_type) {
       Head  {
        set machine_kin "TH"
       }
       Table {
        set machine_kin "TT"
       }
      }
     }
    }
    foreach i { 0 1 2 } {
     set mom_kin_var(\$mom_kin_machine_zero_offset($i)) \
     [expr $pg_vec($i) + $mom_kin_var(\$mom_kin_4th_axis_center_offset\($i\)) +\
     $mom_kin_var(\$mom_kin_5th_axis_center_offset\($i\))]
    }
    switch $machine_kin {
     "HH" {
      foreach i { 0 1 2 } {
       set mom_kin_var(\$mom_kin_4th_axis_point($i)) \
       [expr $pg_vec($i) + $mom_kin_var(\$mom_kin_4th_axis_center_offset\($i\))]
       set mom_kin_var(\$mom_kin_5th_axis_point($i)) $pg_vec($i)
      }
     }
     "HT" {
      foreach i { 0 1 2 } {
       set mom_kin_var(\$mom_kin_4th_axis_point($i)) $pg_vec($i)
       set mom_kin_var(\$mom_kin_5th_axis_point($i)) $mom_kin_var(\$mom_kin_machine_zero_offset\($i\))
      }
     }
     "TH" {
      foreach i { 0 1 2 } {
       set mom_kin_var(\$mom_kin_5th_axis_point($i)) $pg_vec($i)
       set mom_kin_var(\$mom_kin_4th_axis_point($i)) $mom_kin_var(\$mom_kin_machine_zero_offset\($i\))
      }
     }
     "TT" {
      foreach i { 0 1 2 } {
       set mom_kin_var(\$mom_kin_4th_axis_point($i)) \
       [expr $pg_vec($i) + $mom_kin_var(\$mom_kin_4th_axis_center_offset\($i\))]
       set mom_kin_var(\$mom_kin_5th_axis_point($i)) $mom_kin_var(\$mom_kin_machine_zero_offset\($i\))
      }
     }
    }
    UI_PB_mach_SetPlaneNormalVector 4TH_AXIS
    UI_PB_mach_SetPlaneNormalVector 5TH_AXIS
   }
  }
  set Post::($post_object,mom_kin_var_list)     [array get mom_kin_var]
 }

#=======================================================================
proc PB_file_FitOldIKSParams { args } {
  global post_object
  global mom_kin_var
  if { ![string match "*wedm" $mom_kin_var(\$mom_kin_machine_type)]  &&\
   ![string match "*lathe" $mom_kin_var(\$mom_kin_machine_type)] &&\
   ![string match "*punch" $mom_kin_var(\$mom_kin_machine_type)] &&\
   ![string match "*3*" $mom_kin_var(\$mom_kin_machine_type)] } {
   set update_kin_vars 0
   if [string match "*4*" $mom_kin_var(\$mom_kin_machine_type)] {
    if [info exists mom_kin_var(\$mom_kin_4th_axis_point(2))] {
     if [string match "Head" $mom_kin_var(\$mom_kin_4th_axis_type)] {
      set mom_kin_var(\$mom_kin_pivot_gauge_offset) $mom_kin_var(\$mom_kin_4th_axis_point\(2\))
      set update_kin_vars 1
     }
    }
    } elseif [string match "*5*" $mom_kin_var(\$mom_kin_machine_type)] {
    set machine_kin "HH"
    switch $mom_kin_var(\$mom_kin_4th_axis_type) {
     Head  {
      switch $mom_kin_var(\$mom_kin_5th_axis_type) {
       Head  {
       }
       Table {
        set machine_kin "HT"
       }
      }
     }
     Table {
      switch $mom_kin_var(\$mom_kin_5th_axis_type) {
       Head  {
        set machine_kin "TH"
       }
       Table {
        set machine_kin "TT"
       }
      }
     }
    }
    switch $machine_kin {
     "HH" -
     "TH" {
      if [info exists mom_kin_var(\$mom_kin_5th_axis_point(2))] {
       set mom_kin_var(\$mom_kin_pivot_gauge_offset) $mom_kin_var(\$mom_kin_5th_axis_point\(2\))
       set update_kin_vars 1
      }
     }
     "HT" {
      if [info exists mom_kin_var(\$mom_kin_4th_axis_point(2))] {
       set mom_kin_var(\$mom_kin_pivot_gauge_offset) $mom_kin_var(\$mom_kin_4th_axis_point\(2\))
       set update_kin_vars 1
      }
     }
    }
   }
   if { [string trim $mom_kin_var(\$mom_kin_pivot_gauge_offset)] == "" } {
    set mom_kin_var(\$mom_kin_pivot_gauge_offset) 0.0
   }
   foreach i { 0 1 2 } {
    set pg_vec($i) [expr $mom_kin_var(\$mom_kin_spindle_axis\($i\))*$mom_kin_var(\$mom_kin_pivot_gauge_offset)]
   }
   if [string match "*4*" $mom_kin_var(\$mom_kin_machine_type)] {
    if [info exists mom_kin_var(\$mom_kin_machine_zero_offset(0))] {
     foreach i { 0 1 2 } {
      set mom_kin_var(\$mom_kin_4th_axis_center_offset($i)) \
      [expr $mom_kin_var(\$mom_kin_machine_zero_offset\($i\)) - $pg_vec($i)]
     }
     set update_kin_vars 1
    }
    } elseif [string match "*5*" $mom_kin_var(\$mom_kin_machine_type)] {
    if [info exists mom_kin_var(\$mom_kin_4th_axis_point(0))] {
     switch $machine_kin {
      "HH" -
      "TT" {
       foreach i { 0 1 2 } {
        set mom_kin_var(\$mom_kin_4th_axis_center_offset($i)) \
        [expr $mom_kin_var(\$mom_kin_4th_axis_point\($i\)) - $pg_vec($i)]
       }
       set update_kin_vars 1
      }
     }
    }
   }
   if { $update_kin_vars } {
    if [info exists mom_kin_var(\$mom_kin_machine_zero_offset(0))] {
     foreach i { 0 1 2 } {
      set mom_kin_var(\$mom_kin_5th_axis_center_offset($i)) \
      [expr $mom_kin_var(\$mom_kin_machine_zero_offset\($i\)) - $pg_vec($i) -\
      $mom_kin_var(\$mom_kin_4th_axis_center_offset\($i\))]
     }
    }
    set Post::($post_object,mom_kin_var_list)     [array get mom_kin_var]
    set Post::($post_object,def_mom_kin_var_list) [array get mom_kin_var]
   }
  }
 }

#=======================================================================
proc __file_TidyPostObjects { args } {
  global post_object
  global gPB
  global mom_sys_arr
  global mom_kin_var
  global mom_sim_arr
  global pb_output_file
  if { [info exists gPB(from_edit_module)] && $gPB(from_edit_module) && [info exists gPB(edit_post_name)] } {
   set Post::($post_object,post_name) $gPB(edit_post_name)
   unset gPB(from_edit_module)
   unset gPB(edit_post_name)
   } elseif { [info exists pb_output_file] } {
   set Post::($post_object,post_name) $pb_output_file
  }
  array set mom_sys_arr $Post::($post_object,mom_sys_var_list)
  array set mom_kin_var $Post::($post_object,mom_kin_var_list)
  array set mom_sim_arr $Post::($post_object,mom_sim_var_list)
  set update_mom_sys 0
  set update_mom_kin 0
  set update_mom_sim 0
  if [info exists mom_kin_var(\$mom_kin_4th_axis_leader)] {
   set var "\$mom_sys_leader(fourth_axis)"
   set mom_sys_arr($var) $mom_kin_var(\$mom_kin_4th_axis_leader)
   set update_mom_sys 1
  }
  if [info exists mom_kin_var(\$mom_kin_5th_axis_leader)] {
   set var "\$mom_sys_leader(fifth_axis)"
   set mom_sys_arr($var) $mom_kin_var(\$mom_kin_5th_axis_leader)
   set update_mom_sys 1
  }
  Post::GetObjList $post_object address add_obj_list
  set add_list {X Y Z}
  foreach add $add_list {
   set var "\$mom_sys_leader($add)"
   PB_com_RetObjFrmName add add_obj_list ret_code
   if { $ret_code > 0 } {
    address::readvalue $ret_code add_attr
    if { ![string match "*mom_sys_leader($add)*" $address::($ret_code,leader_var)] } {
     set mom_sys_arr($var) $add_attr(8)
     set address::($ret_code,leader_var) "$var"
     set update_mom_sys 1
    }
   }
  }
  foreach add_obj $add_obj_list \
  {
   if { [string length $address::($add_obj,leader_var)] > 0 } \
   {
    set add_leader_var $address::($add_obj,leader_var)
    address::readvalue $add_obj add_attr
    if { [info exists mom_sys_arr($add_leader_var)] } {
     set add_attr(8) $mom_sys_arr($add_leader_var)
    }
    address::setvalue $add_obj add_attr
    address::DefaultValue $add_obj add_attr
   }
  }
  if [info exists mom_kin_var(\$mom_kin_arc_valid_planes)] {
   set mom_kin_var(\$mom_kin_arc_valid_plane) $mom_kin_var(\$mom_kin_arc_valid_planes)
   unset mom_kin_var(\$mom_kin_arc_valid_planes)
   set update_mom_kin 1
  }
  if { ![info exists mom_kin_var(\$mom_kin_pivot_gauge_offset)] ||\
   [string trim $mom_kin_var(\$mom_kin_pivot_gauge_offset)] == "" } {
   set mom_kin_var(\$mom_kin_pivot_gauge_offset) 0.0
   set update_mom_kin 1
  }
  set validate_kin_var {"\$mom_kin_4th_axis_center_offset\(0\)" "\$mom_kin_4th_axis_center_offset\(1\)" \
   "\$mom_kin_4th_axis_center_offset\(2\)" "\$mom_kin_5th_axis_center_offset\(0\)" \
   "\$mom_kin_5th_axis_center_offset\(1\)" "\$mom_kin_5th_axis_center_offset\(2\)" \
   "\$mom_kin_4th_axis_max_limit" "\$mom_kin_4th_axis_min_limit" \
   "\$mom_kin_4th_axis_min_incr" "\$mom_kin_4th_axis_zero" \
   "\$mom_kin_5th_axis_max_limit" "\$mom_kin_5th_axis_min_limit" \
   "\$mom_kin_5th_axis_min_incr" "\$mom_kin_5th_axis_zero" \
   "\$mom_kin_max_arc_radius" "\$mom_kin_min_arc_radius" \
   "\$mom_kin_min_arc_length" "\$mom_kin_tool_change_time" \
   "\$mom_kin_max_dpm" "\$mom_kin_min_dpm" \
   "\$mom_kin_max_fpm" "\$mom_kin_min_fpm" \
   "\$mom_kin_max_fpr" "\$mom_kin_min_fpr" \
   "\$mom_kin_max_frn" "\$mom_kin_min_frn"
  "\$mom_kin_linearization_tol"}
  if { [string match "*lathe" $mom_kin_var(\$mom_kin_machine_type)] } {
   append validate_kin_var { "\$mom_kin_ind_to_dependent_head_x" "\$mom_kin_ind_to_dependent_head_z"}
  }
  foreach var $validate_kin_var {
   if { ![info exists mom_kin_var($var)] || \
   ![string compare [string trim [set mom_kin_var($var)]] ""] } \
   {
    set mom_kin_var($var) 0.0
    set update_mom_kin 1
   }
  }
  unset validate_kin_var
  if { ![info exists mom_sys_arr(\$mom_sys_cutcom_plane_code\(XY\))] || \
  ![string compare [string trim $mom_sys_arr(\$mom_sys_cutcom_plane_code\(XY\))] ""] } \
  {
   set mom_sys_arr(\$mom_sys_cutcom_plane_code\(XY\)) "17"
   set update_mom_sys 1
  }
  if { ![info exists mom_sys_arr(\$mom_sys_cutcom_plane_code\(ZX\))] || \
  ![string compare [string trim $mom_sys_arr(\$mom_sys_cutcom_plane_code\(ZX\))] ""] } \
  {
   set mom_sys_arr(\$mom_sys_cutcom_plane_code\(ZX\)) "18"
   set update_mom_sys 1
  }
  if { ![info exists mom_sys_arr(\$mom_sys_cutcom_plane_code\(YZ\))] || \
  ![string compare [string trim $mom_sys_arr(\$mom_sys_cutcom_plane_code\(YZ\))] ""] } \
  {
   set mom_sys_arr(\$mom_sys_cutcom_plane_code\(YZ\)) "19"
   set update_mom_sys 1
  }
  if { ![info exists mom_sim_arr(\$mom_sim_spindle_jct)] || \
  ![string compare [string trim $mom_sim_arr(\$mom_sim_spindle_jct)] ""] } \
  {
   set mom_sim_arr(\$mom_sim_spindle_jct) "TOOL_MOUNT_JCT"
   set update_mom_sim 1
  }
  if { ![info exists mom_sim_arr(\$mom_sim_spindle_comp)] || \
  ![string compare [string trim $mom_sim_arr(\$mom_sim_spindle_comp)] ""] } \
  {
   set mom_sim_arr(\$mom_sim_spindle_comp) "SPINDLE"
   set update_mom_sim 1
  }
  if { ![info exists mom_sim_arr(\$mom_sim_zcs_base)] || \
  ![string compare [string trim $mom_sim_arr(\$mom_sim_zcs_base)] ""] } \
  {
   set mom_sim_arr(\$mom_sim_zcs_base) "X_SLIDE"
   set update_mom_sim 1
  }
  if 0 {
   if { [info exists mom_kin_var(\$mom_kin_output_unit)] && [info exists mom_sim_arr(\$mom_sim_feed_mode)] } {
    if { ![string compare $mom_kin_var(\$mom_kin_output_unit) "IN"] } {
     set mom_sim_arr(\$mom_sim_feed_mode) "INCH_PER_MIN"
     set update_mom_sim 1
     } else {
     set mom_sim_arr(\$mom_sim_feed_mode) "MM_PER_MIN"
     set update_mom_sim 1
    }
   }
  }
  global gPB
  if { ![info exists gPB(new_IKS_in_use)] || !$gPB(new_IKS_in_use) } {
   if { ![string match "*_wedm" $mom_kin_var(\$mom_kin_machine_type)] &&\
    ![string match "*lathe" $mom_kin_var(\$mom_kin_machine_type)] &&\
    ![string match "*punch" $mom_kin_var(\$mom_kin_machine_type)] } {
    set update_mom_kin 1
    if ![info exists mom_kin_var(\$mom_kin_spindle_axis(0))] {
     set mom_kin_var(\$mom_kin_spindle_axis(0)) 0.0
    }
    if ![info exists mom_kin_var(\$mom_kin_spindle_axis(1))] {
     set mom_kin_var(\$mom_kin_spindle_axis(1)) 0.0
    }
    if ![info exists mom_kin_var(\$mom_kin_spindle_axis(2))] {
     set mom_kin_var(\$mom_kin_spindle_axis(2)) 1.0
    }
    if ![info exists mom_kin_var(\$mom_kin_4th_axis_vector(0))] {
     set mom_kin_var(\$mom_kin_4th_axis_vector(0)) 1.0
     set mom_kin_var(\$mom_kin_4th_axis_vector(1)) 0.0
     set mom_kin_var(\$mom_kin_4th_axis_vector(2)) 0.0
     if [info exists mom_kin_var(\$mom_kin_4th_axis_plane)] {
      switch $mom_kin_var(\$mom_kin_4th_axis_plane) {
       "XY" {
        set mom_kin_var(\$mom_kin_4th_axis_vector(0)) 0.0
        set mom_kin_var(\$mom_kin_4th_axis_vector(1)) 0.0
        set mom_kin_var(\$mom_kin_4th_axis_vector(2)) 1.0
       }
       "ZX" {
        set mom_kin_var(\$mom_kin_4th_axis_vector(0)) 0.0
        set mom_kin_var(\$mom_kin_4th_axis_vector(1)) 1.0
        set mom_kin_var(\$mom_kin_4th_axis_vector(2)) 0.0
       }
      }
     }
    }
    if ![info exists mom_kin_var(\$mom_kin_5th_axis_vector(0))] {
     set mom_kin_var(\$mom_kin_5th_axis_vector(0)) 0.0
     set mom_kin_var(\$mom_kin_5th_axis_vector(1)) 1.0
     set mom_kin_var(\$mom_kin_5th_axis_vector(2)) 0.0
     if [info exists mom_kin_var(\$mom_kin_5th_axis_plane)] {
      switch $mom_kin_var(\$mom_kin_5th_axis_plane) {
       "XY" {
        set mom_kin_var(\$mom_kin_5th_axis_vector(0)) 0.0
        set mom_kin_var(\$mom_kin_5th_axis_vector(1)) 0.0
        set mom_kin_var(\$mom_kin_5th_axis_vector(2)) 1.0
       }
       "YZ" {
        set mom_kin_var(\$mom_kin_5th_axis_vector(0)) 1.0
        set mom_kin_var(\$mom_kin_5th_axis_vector(1)) 0.0
        set mom_kin_var(\$mom_kin_5th_axis_vector(2)) 0.0
       }
      }
     }
    }
    if ![info exists mom_kin_var(\$mom_kin_rotary_axis_method)] {
     set mom_kin_var(\$mom_kin_rotary_axis_method) PREVIOUS
    }
    PB_file_FitOldIKSParams
   }
  } ;# IKS conversion
  if 0 {
   if { [info exists mom_kin_var(\$mom_kin_arc_output_mode)] } {
    if { ![string match "QUADRANT" $mom_kin_var(\$mom_kin_arc_output_mode)] } {
     set mom_kin_var(\$mom_kin_arc_output_mode) "FULL_CIRCLE"
     set update_mom_kin 1
    }
   }
   } else {
   if { [info exists mom_kin_var(\$mom_kin_arc_output_mode)] } {
    if { [info exists mom_sys_arr(\$cir_record_output)] } {
     if { ![string compare "NO" $mom_sys_arr(\$cir_record_output)] } {
      set mom_kin_var(\$mom_kin_arc_output_mode) "LINEAR"
      } else {
      if { ![string match "QUADRANT" $mom_kin_var(\$mom_kin_arc_output_mode)] } {
       set mom_kin_var(\$mom_kin_arc_output_mode) "FULL_CIRCLE"
      }
      set gPB(arc_output_mode_saved) $mom_kin_var(\$mom_kin_arc_output_mode)
     }
    }
    if { [info exists mom_kin_var(\$mom_kin_arc_output_mode_saved)] } {
     unset mom_kin_var(\$mom_kin_arc_output_mode_saved)
    }
    set update_mom_kin 1
   }
  }
  if { ![info exists mom_kin_var(\$mom_kin_cycle_plane_change_per_axis)] ||\
   [string trim $mom_kin_var(\$mom_kin_cycle_plane_change_per_axis)] == "" } {
   if { ![string match "*_wedm" $mom_kin_var(\$mom_kin_machine_type)] &&\
    ![string match "*lathe" $mom_kin_var(\$mom_kin_machine_type)] &&\
    ![string match "*punch" $mom_kin_var(\$mom_kin_machine_type)] } {
    set mom_kin_var(\$mom_kin_cycle_plane_change_per_axis) 0
    set update_mom_kin 1
   }
  }
  if { ![string match "*3_axis_mill_turn*" $mom_kin_var(\$mom_kin_machine_type)] } {
   if [info exists mom_sys_arr(\$mom_sys_mill_turn_type)] {
    if [string match "SIMPLE_MILL_TURN" $mom_sys_arr(\$mom_sys_mill_turn_type)] {
     set mom_sys_arr(\$is_linked_post) 1
     set post [list]
     lappend post 0  "MILL"  "this_post"
     lappend linked_posts $post
     set post [list]
     lappend post 1  "TURN"  "$mom_sys_arr(\$mom_sys_lathe_postname)"
     lappend linked_posts $post
     set mom_sys_arr(\$linked_posts_list) [list]
     lappend mom_sys_arr(\$linked_posts_list)  "\{MILL\} \{this_post\}"
     lappend mom_sys_arr(\$linked_posts_list)  \
     "\{TURN\} \{$mom_sys_arr(\$mom_sys_lathe_postname)\}"
    }
    unset mom_sys_arr(\$mom_sys_mill_turn_type)
    unset mom_sys_arr(\$mom_sys_lathe_postname)
    array set word_mom_var_list $Post::($post_object,word_mom_var)
    foreach var { "\$mom_sys_mill_turn_type" "\$mom_sys_lathe_postname" } {
     set search_on 1
     while { $search_on } {
      set idx -1
      set idx [lsearch $word_mom_var_list(PB_Tcl_Var) "$var"]
      if { $idx >= 0 } {
       set word_mom_var_list(PB_Tcl_Var) \
       [lreplace $word_mom_var_list(PB_Tcl_Var) $idx $idx]
       } else {
       set search_on 0
      }
     }
    }
    set Post::($post_object,word_mom_var) [array get word_mom_var_list]
    set update_mom_sys 1
   }
  }
  if [info exists mom_sys_arr(\$mom_sys_radius_output_mode)] {
   switch $mom_sys_arr(\$mom_sys_radius_output_mode) {
    "ALWAYS_POSITIVE" {
     set mom_sys_arr(\$mom_sys_radius_output_mode)     "Always_Positive"
    }
    "ALWAYS_NEGATIVE" {
     set mom_sys_arr(\$mom_sys_radius_output_mode)     "Always_Negative"
    }
    "SHORTEST_DISTANCE" {
     set mom_sys_arr(\$mom_sys_radius_output_mode)     "Shortest_Distance"
    }
   }
   set update_mom_sys 1
  }
  if [info exists mom_sys_arr(\$mill_turn_spindle_axis)] {
   switch "\"$mom_sys_arr(\$mill_turn_spindle_axis)\"" {
    "\"+X_AXIS\"" {
     set mom_sys_arr(\$mill_turn_spindle_axis)     "+X_Axis"
    }
    "\"-X_AXIS\"" {
     set mom_sys_arr(\$mill_turn_spindle_axis)     "-X_Axis"
    }
    "\"Y_AXIS\"" {
     set mom_sys_arr(\$mill_turn_spindle_axis)     "Y_Axis"
    }
    "\"Z_AXIS\"" {
     set mom_sys_arr(\$mill_turn_spindle_axis)     "Z_Axis"
    }
   }
   set update_mom_sys 1
  }
  if [info exists mom_kin_var(\$mom_kin_4th_axis_direction)] {
   set mom_sys_arr(\$4th_axis_direction) $mom_kin_var(\$mom_kin_4th_axis_direction)
  }
  if [info exists mom_kin_var(\$mom_kin_5th_axis_direction)] {
   set mom_sys_arr(\$5th_axis_direction) $mom_kin_var(\$mom_kin_5th_axis_direction)
  }
  if [info exists mom_sys_arr(\$4th_axis_direction)] {
   switch $mom_sys_arr(\$4th_axis_direction) {
    "SIGN_DETERMINES_DIRECTION" {
     set mom_sys_arr(\$4th_axis_direction)     "Sign_Determines_Direction"
     set update_mom_sys 1
    }
    "MAGNITUDE_DETERMINES_DIRECTION" {
     set mom_sys_arr(\$4th_axis_direction)     "Magnitude_Determines_Direction"
     set update_mom_sys 1
    }
   }
  }
  if [info exists mom_sys_arr(\$5th_axis_direction)] {
   switch $mom_sys_arr(\$5th_axis_direction) {
    "SIGN_DETERMINES_DIRECTION" {
     set mom_sys_arr(\$5th_axis_direction)     "Sign_Determines_Direction"
     set update_mom_sys 1
    }
    "MAGNITUDE_DETERMINES_DIRECTION" {
     set mom_sys_arr(\$5th_axis_direction)     "Magnitude_Determines_Direction"
     set update_mom_sys 1
    }
   }
  }
  if [info exists mom_sys_arr(\$output_mode_opt)] {
   switch $mom_sys_arr(\$output_mode_opt) {
    "ABSOLUTE_ONLY" {
     set mom_sys_arr(\$output_mode_opt)  "Absolute_Only"
     set update_mom_sys 1
    }
    "INCREMENTAL_ONLY" {
     set mom_sys_arr(\$output_mode_opt)  "Incremental_Only"
     set update_mom_sys 1
    }
    "ABSOLUTE/INCREMENTAL" {
     set mom_sys_arr(\$output_mode_opt)  "Absolute/Incremental"
     set update_mom_sys 1
    }
   }
  }
  global gPB
  set gPB(update_v300_cycles) 0
  if [info exists mom_sys_arr(\$cycle_rapto_opt)] {
   switch $mom_sys_arr(\$cycle_rapto_opt) {
    "NONE" {
     set mom_sys_arr(\$cycle_rapto_opt)  "None"
     set update_mom_sys 1
    }
    "RAPID_TRAVERSE_&_R" {
     set mom_sys_arr(\$cycle_rapto_opt)  "Rapid_Traverse_&_R"
     set update_mom_sys 1
     set gPB(update_v300_cycles) 1
    }
    "RAPID" {
     set mom_sys_arr(\$cycle_rapto_opt)  "Rapid"
     set update_mom_sys 1
     set gPB(update_v300_cycles) 1
    }
   }
  }
  if [info exists mom_sys_arr(\$cycle_recto_opt)] {
   switch $mom_sys_arr(\$cycle_recto_opt) {
    "NONE" {
     set mom_sys_arr(\$cycle_recto_opt)  "None"
     set update_mom_sys 1
    }
    "RAPID_SPINDLE" {
     set mom_sys_arr(\$cycle_recto_opt)  "Rapid_Spindle"
     set update_mom_sys 1
     set gPB(update_v300_cycles) 1
    }
    "CYCLE_OFF_THEN_RAPID_SPINDLE" {
     set mom_sys_arr(\$cycle_recto_opt)  "Cycle_Off_then_Rapid_Spindle"
     set update_mom_sys 1
     set gPB(update_v300_cycles) 1
    }
   }
  }
  if [info exists mom_sys_arr(\$cycle_plane_control_opt)] {
   switch $mom_sys_arr(\$cycle_plane_control_opt) {
    "NONE" {
     set mom_sys_arr(\$cycle_plane_control_opt)  "None"
     set update_mom_sys 1
    }
   }
  }
  if { $update_mom_sys } {
   set Post::($post_object,mom_sys_var_list)     [array get mom_sys_arr]
   set Post::($post_object,def_mom_sys_var_list) [array get mom_sys_arr]
  }
  if { $update_mom_kin } {
   set Post::($post_object,mom_kin_var_list)     [array get mom_kin_var]
   set Post::($post_object,def_mom_kin_var_list) [array get mom_kin_var]
  }
  if { $update_mom_sim } {
   set Post::($post_object,mom_sim_var_list)     [array get mom_sim_arr]
   set Post::($post_object,def_mom_sim_var_list) [array get mom_sim_arr]
  }
  __isv_UpdateNCCommandList
  set update_mom_sim 1
  if { $update_mom_sim } {
   set Post::($post_object,mom_sim_var_list)     [array get mom_sim_arr]
   set Post::($post_object,def_mom_sim_var_list) [array get mom_sim_arr]
  }
  Post::GetObjList $post_object command cmd_obj_list
  set cc_idx [lsearch $Post::($post_object,add_name_list) "Command"]
  if { $cc_idx >= 0 } {
   set f [lindex $Post::($post_object,add_name_list) [expr {$cc_idx - 1}]]
   set idx [lsearch $Post::($post_object,add_mom_var_list) $f]
   set cc_idx [expr {$idx + 1}]
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
  Post::GetObjList $post_object comment cmt_blk_obj_list
  foreach cmt_blk_obj $cmt_blk_obj_list {
   block::readvalue $cmt_blk_obj cmt_blk_obj_attr
   set cmt_blk_name $cmt_blk_obj_attr(0)
   set elem_var $mom_sys_arr($cmt_blk_name)
   if { $elem_var != "" } {
    set blk_elem [lindex $cmt_blk_obj_attr(2) 0]
    block_element::readvalue $blk_elem blk_elem_attr
    set blk_elem_attr(1) $elem_var
    block_element::setvalue $blk_elem blk_elem_attr
    block_element::DefaultValue $blk_elem blk_elem_attr
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
  if { ![string match "*_wedm" $mom_kin_var(\$mom_kin_machine_type)] } {
   set evt_name_list  $Post::($post_object,oper_end_evt_list)
   set evt_label_list $Post::($post_object,oper_end_label_list)
   set evt_blk_list   $Post::($post_object,oper_end_evt_blk_list)
   set list_len [llength $evt_name_list]
   if { [lsearch $evt_name_list "Retract Move"] == -1 } {
    set evt_name_arr(0)  "Retract Move"
    set evt_label_arr(0) "Retract Move"
    set evt_blk_arr(0)   [list]
    for { set ii 0 } { $ii < $list_len } { incr ii 2 } {
     set idx [lindex $evt_name_list $ii]
     set idx2 [incr idx]
     set ii2 [expr $ii + 1]
     set evt_name_arr($idx2)  [lindex $evt_name_list $ii2]
     set evt_label_arr($idx2) [lindex $evt_label_list $ii2]
     set evt_blk_arr($idx2)   [lindex $evt_blk_list $ii2]
    }
    set Post::($post_object,oper_end_evt_list)   [array get evt_name_arr]
    set Post::($post_object,oper_end_label_list) [array get evt_label_arr]
    set Post::($post_object,oper_end_evt_blk_list) [array get evt_blk_arr]
   }
  }
  __file_ValidateBlocksInEvent
 }

#=======================================================================
proc __file_GetAddVarOnTpthEvenPage { } {
  global gPB
  foreach group_item [array names group_member:: "*,widget_type"] {
   if { $group_member::($group_item) == 2 } {
    set first_comma [string first "," $group_item]
    set group_obj [string range $group_item 0 [expr $first_comma - 1]]
    if { ![string compare "a" $group_member::($group_obj,data_type)] } {
     set sys_var $group_member::($group_obj,mom_var)
     set add_name ""
     UI_PB_mthd_GetAddNameOnTpthEvenPage $sys_var add_name
     if { [string compare "" $add_name] } {
      if { [info exists gPB(addr_expr,$add_name)] } {
       if { [lsearch -exact $gPB(addr_expr,$add_name) $sys_var] == -1 } {
        lappend gPB(addr_expr,$add_name) $sys_var
       }
       } else {
       set gPB(addr_expr,$add_name) [list]
       lappend gPB(addr_expr,$add_name) $sys_var
      }
     }
    }
   }
  }
 }

#=======================================================================
proc PB_file_AssumeUnknownCommandsInProc { } {
  global post_object
  if { [info exists Post::($post_object,unk_cmd_list)] && \
   [llength $Post::($post_object,unk_cmd_list)] } {
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
  if { [info exists Post::($post_object,unk_blk_list)] && \
   [llength $Post::($post_object,unk_blk_list)] } {
   if { ![info exists Post::($post_object,ass_blk_list)] } {
    set Post::($post_object,ass_blk_list) $Post::($post_object,unk_blk_list)
    } else {
    set Post::($post_object,ass_blk_list) \
    [lmerge $Post::($post_object,ass_blk_list) $Post::($post_object,unk_blk_list)]
   }
  }
  if { [info exists Post::($post_object,unk_add_list)] && \
   [llength $Post::($post_object,unk_add_list)] } {
   if { ![info exists Post::($post_object,ass_add_list)] } {
    set Post::($post_object,ass_add_list) $Post::($post_object,unk_add_list)
    } else {
    set Post::($post_object,ass_add_list) \
    [lmerge $Post::($post_object,ass_add_list) $Post::($post_object,unk_add_list)]
   }
  }
  if { [info exists Post::($post_object,unk_fmt_list)] && \
   [llength $Post::($post_object,unk_fmt_list)] } {
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
  set seq_list {prog_start oper_start tpth_ctrl tpth_mot tpth_cycle tpth_misc oper_end prog_end}
  Post::GetObjList $post_object block   blk_obj_list
  Post::GetObjList $post_object comment cmt_blk_list
  Post::GetObjList $post_object function func_obj_list
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
    "tpth_misc" \
    {
     set evt_list     "tpth_misc_evt_list"
     set evt_blk_list "tpth_misc_evt_blk_list"
     set seq_name     "Miscellaneous"
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
   for { set i 0 } { $i < $arr_size } { incr i } {
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
       set cmt_blk 0
       PB_com_RetObjFrmName blk cmt_blk_list cmt_blk
       if { $cmt_blk > 0 } {  ;# Condition had no comparison
        set blk_not_found 0
       }
      }
      if $blk_not_found {
       set func_obj 0
       set func_name $blk
       PB_evt_ReparserBlockName func_name
       PB_com_RetObjFrmName func_name func_obj_list func_obj
       if { $func_obj > 0 } {
        set blk_not_found 0
       }
      }
      if $blk_not_found {
       if [PB_file_is_JE_POST_DEV] {
        set blk_name [lindex $blk 0]  ;# In case name contains multiple tokens,
        UI_PB_debug_ForceMsg "%%%%% Missing Event Element: <$blk> has [llength $blk] fields."
        if { [llength $blk] > 1 } {
         set func_attr_list [list $blk_name]
         set param_attr_list [list]
         PB_pui_CreateFunctionObj post_object blk_name func_attr_list param_attr_list
         Post::GetObjList $post_object function func_obj_list
         PB_com_RetObjFrmName blk_name func_obj_list func_obj
         function::readvalue    $func_obj func_attr
         set func_attr(9)      1 ;# is_dummy
         function::setvalue     $func_obj func_attr
         function::DefaultValue $func_obj func_attr
         } else {
         set cmd_obj_attr(0)     $blk_name
         set cmd_obj_attr(1)     [list] ;# body
         if { [string match "comment_blk*" $blk_name] } {  ;# Ref changes in ui_pb_block
          lappend cmd_obj_attr(1) "# Dummy command created for non-existing Operator Message: <$blk>."
          PB_blk_CreateCommentBlkElem blk_name cmt_elem_obj
          set cmt_obj -1
          set block_element::($cmt_elem_obj,elem_mom_variable) $blk_name
          PB_int_CreateCommentBlk blk_name cmt_elem_obj cmt_obj
          block::readvalue $cmt_obj cmt_obj_attr
          set cmt_obj_attr(4) 1  ;# is_dummy
          block::setvalue $cmt_obj cmt_obj_attr
          } elseif { [string match "PB_CMD_*" $blk_name] } {
          lappend cmd_obj_attr(1) "# Dummy command created for non-existing command: <$blk>."
          } else {
          lappend cmd_obj_attr(1) "# Dummy command created for non-existing Block: <$blk>."
          set blk_obj -1
          set blk_elem_list [list]
          set blk_type "normal"
          PB_int_CreateNewBlock blk_name blk_elem_list evt_name_arr($i) blk_obj blk_type
          set add_name "Text"
          set var_string $blk_name
          PB_int_AddNewBlockElemObj add_name var_string blk_obj blk_elem_obj
          block::readvalue $blk_obj blk_obj_attr
          set blk_obj_attr(2) [list $blk_elem_obj]
          set blk_obj_attr(4) 1  ;# is_dummy
          block::setvalue $blk_obj blk_obj_attr
         }
         if { [string match "PB_CMD_*" $blk_name] } {
          set cmd_obj -1
          set cmd_obj_attr(5)     "Dummy command for $blk"
          set cmd_obj_attr(6)     1      ;# is_dummy
          PB_pps_CreateCommand cmd_obj_attr cmd_obj
          PB_int_UpdateCommandAdd cmd_obj
          if 0 { ;#<01-29-13 gsl> Doesn't seem to be needed.
           set idx [lsearch $evt_blk_list_arr($i) $blk]
           if { $idx > 0 } {
            set evt_blk_list_arr($i) [lreplace $evt_blk_list_arr($i) $idx $idx $blk_name]
            set Post::($post_object,$evt_blk_list) [array get evt_blk_list_arr]
           }
          }
         }
        }
        UI_PB_debug_DisplayMsg "Dummy event element: $blk_name was created." no_debug
        } else {
        set msg "Event Element \"$blk\" referenced in\
        \"$evt_name_arr($i)\" Event\
        at \"$seq_name\" sequence is not defined."
        UI_PB_debug_DisplayMsg $msg no_debug
       }
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
          PB_com_DeleteObject $blk_elem
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
  set new_id [PB_file_configure_output_file "$new_pui_file"]
  set event_handler 0
  while { [gets $old_id line] >= 0 } \
  {
   switch -glob -- "$line" \
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
  set post_type_start 0
  set event_handler 0
  while { [gets $fid line] >= 0 } \
  {
   switch -glob -- "$line" \
   {
    "## POST EVENT HANDLER START" \
    {
     set event_handler 1
    }
    "## POST EVENT HANDLER END" \
    {
     continue
    }
    "#  POST TYPE START" \
    {
     set post_type_start 1
     continue
    }
    "#  POST TYPE END" \
    {
     set post_type_start 0
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
     if { $post_type_start } \
     {
      if { [info exist ::env(SUB_POST)] && $::env(SUB_POST) == 1 } {
       if { ![string compare "Alternate Unit Subordinate" [string trim $line]] } {
        set def_file [file tail $pui_file]
       }
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
proc PB_file_InitDefEnvforSubPostMode { pui_file DEF_FILE } {
  upvar $DEF_FILE def_file
  global gPB
  set fid [open "$pui_file" r]
  set dir [file dirname $pui_file]
  if { ![info exists def_file] || ![file exists $def_file] || [string match "*.pui" $def_file] } {
   set def_file ""
  }
  set post_type_start 0
  set main_post_start 0
  set sub_post_def_info_start 0
  while { [gets $fid line] >= 0 } \
  {
   switch -glob -- "$line" \
   {
    "#  MAIN POST START" \
    {
     set main_post_start 1
     continue
    }
    "#  MAIN POST END" \
    {
     set main_post_start 0
     continue
    }
    "#  POST TYPE START" \
    {
     set post_type_start 1
     continue
    }
    "#  POST TYPE END" \
    {
     set post_type_start 0
     continue
    }
    "## ALTER UNIT SUB POST DEF INFO START" \
    {
     if { ![info exists gPB(alter_unit_sub_def_file)] } {
      set sub_post_def_info_start 1
      set tmp_file_name $::env(TEMP)\\tmp_def[clock clicks].def
      global tcl_platform
      if { ![string match "windows" $tcl_platform(platform)] } {
       regsub -all {\\} $tmp_file_name {/}  tmp_file_name
      }
      set tmp_fid [open $tmp_file_name w]
      continue
      } else {
      set tmp_file_name $gPB(alter_unit_sub_def_file)
      break
     }
    }
    "## ALTER UNIT SUB POST DEF INFO END" \
    {
     if { ![info exists gPB(alter_unit_sub_def_file)] } {
      set sub_post_def_info_start 0
      close $tmp_fid
      set gPB(alter_unit_sub_def_file) $tmp_file_name
     }
     break
    }
    default \
    {
     if { $main_post_start } \
     {
      set gPB(main_post) [file join $dir $line]
     }
     if { $post_type_start } \
     {
      set gPB(post_type) $line
      if { [info exist ::env(SUB_POST)] && $::env(SUB_POST) == 1 } {
       if { ![string compare "Subordinate" [string trim $line]] } {
        set ::env(SUB_POST_MODE) 1
        } elseif { ![string compare "Alternate Unit Subordinate" [string trim $line]] } {
        set ::env(SUB_POST_MODE) 1
        set ::env(UNIT_SUB_POST_MODE) 1
       }
      }
     }
     if { $sub_post_def_info_start } \
     {
      puts $tmp_fid $line
     }
    }
   }
  }
  if { [info exists tmp_file_name] && [file exists $tmp_file_name] } {
   set def_file $tmp_file_name
   unset tmp_file_name
  }
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
  set all_attr_found  0
  set mom_kin_start   0
  set post_type_start 0
  while { [gets $file_id line] >= 0 } \
  {
   if { $mom_kin_start == 0 || $post_type_start == 0 } \
   {
    switch -glob -- "$line" \
    {
     "#  POST TYPE START" \
     {
      set post_type_start 1
      continue
     }
     "#  POST TYPE END" \
     {
      set post_type_start 0
      continue
     }
     "## KINEMATIC VARIABLES START" \
     {
      set mom_kin_start 1
     }
     "## KINEMATIC VARIABLES END" \
     {
      break ;# out of while loop
     }
     default \
     {
      if { $all_attr_found } \
      {
       break ;# out of while loop
      }
     }
    }
   }
   if { $post_type_start } \
   {
    if { ![string compare $line "Alternate Unit Subordinate"] || \
    ![string compare $line "Subordinate"] }  \
    {
     global gPB
     set gPB(is_sub_post) 1
     if { ![string compare $line "Alternate Unit Subordinate"] } {
      set gPB(is_alt_unit_sub_post) 1
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
     break ;# out of while loop
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
  PB_com_GetMachAxisType $machine_type machine_type axis_option
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
proc PB_CreatePostFiles { args } {
  global post_object
  global gPB
  global mom_sys_arr
  if { ![info exists post_object] } { return }
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
  if [PB_is_v $gPB(VNC_release)] {
   set vnc_file ${tcl_file_root}_vnc.tcl
   set vnc_bck_file $vnc_file
  }
  set cdl_file ${tcl_file_root}.cdl
  if { ![string compare "NO_BACKUP" $gPB(backup_method)] } {
   set gPB(backup_method)  "BACKUP_SAVE"
  }
  if { [info exists gPB(start_session)] == 0 } {
   set gPB(start_session) $gPB(session)
  }
  switch $gPB(backup_method) {
   "BACKUP_SAVE" {
    if { $gPB(backup_one_done) == 0 } {
     set bck_folder [__file_GetNextFileName $pui_file _org]
     file mkdir $bck_folder
     set gPB(backup_one_done) 1
    }
   }
   "BACKUP_ONE" {
    if { $gPB(backup_one_done) == 0 } {
     set bck_folder [__file_GetNextFileName $pui_file _org]
     if { ![string compare "EDIT" $gPB(start_session)] } {
      if { [info level] != 5 } {  ;# <== This is a funny of knowing where you are; may not be reliable.
       file mkdir $bck_folder
      }
     }
     set gPB(backup_one_done) 1
    }
   }
   "BACKUP_ALL" {
    set bck_folder [__file_GetNextFileName $pui_file _bck]
    if { ![string compare "EDIT" $gPB(start_session)] } {
     if { [info level] != 5 } {
      file mkdir $bck_folder
     }
    }
   }
  }
  if 0 {
   if { $pui_bck_file != "$pui_file" } {
    PB_CreateCopyOfPui pui_file pui_bck_file def_bck_file tcl_bck_file
   }
   if { $def_bck_file != "$def_file" } {
    file copy -force -- $def_file $def_bck_file
   }
   if { $tcl_bck_file != "$tcl_file" } {
    file copy -force -- $tcl_file $tcl_bck_file
   }
   if [PB_is_v $gPB(VNC_release)] {
    if { ![string match "$vnc_file" $vnc_bck_file] && [file exists $vnc_file] } {
     file copy -force -- $vnc_file $vnc_bck_file
    }
   }
  }
  if { [info exists bck_folder] && [file exists $bck_folder] } {
   if { [file exists $def_file] } {
    file copy -force $def_file $bck_folder
   }
   if { [file exists $cdl_file] } {
    file copy -force $cdl_file $bck_folder
   }
   if { [file exists $tcl_file] } {
    file copy -force $tcl_file $bck_folder
    if { [file exists [file rootname $tcl_file]_tcl.txt] } {
     file copy -force [file rootname $tcl_file]_tcl.txt $bck_folder
    }
   }
   if { [file exists $vnc_file] } {
    if { [PB_is_v $gPB(VNC_release)] } {
     file copy -force $vnc_file $bck_folder
     if { [file exists [file rootname $vnc_file]_tcl.txt] } {
      file copy -force [file rootname $vnc_file]_tcl.txt $bck_folder
     }
    }
   }
   if { [info exist ::env(SUB_POST_MODE)] && $::env(SUB_POST_MODE) == 1 } \
   {
    if { [info exists ::env(UNIT_SUB_POST_MODE)] && $::env(UNIT_SUB_POST_MODE) == 1 } {
     if { [file exists $pui_file] && [file exists $tcl_bck_file] } {
      file copy -force $pui_file $bck_folder
      } else {
      if { ![string match "BACKUP_SAVE" $gPB(backup_method)] } {
       __Pause "Backup Sub-Post ($gPB(backup_method)) $pui_bck_file\n\
       can not be created, due to missing file elements :\n\
       $pui_file,\n $tcl_file."
      }
     }
    }
    } else {
    if { [file exists $pui_file] && [file exists $def_bck_file] && [file exists $tcl_bck_file] } {
     file copy -force $pui_file $bck_folder
     } else {
     if { ![string match "BACKUP_SAVE" $gPB(backup_method)] } {
      __Pause "Backup Post ($gPB(backup_method)) $pui_bck_file\n\
      can not be created, due to missing file elements :\n\
      $pui_file,\n $def_file or\n $tcl_file."
     }
    }
   }
  }
  set listfile_obj $Post::($post_object,list_obj_list)
  if { $ListingFile::($listfile_obj,use_default_unit_fragment) } {
   global mom_kin_var
   global ListObjectAttr
   set tmp_post_name [file rootname $Post::($post_object,out_pui_file)]
   if { ![string compare "IN" $mom_kin_var(\$mom_kin_output_unit)] } {
    append tmp_post_name "__MM.pui"
    } else {
    append tmp_post_name "__IN.pui"
   }
   set ListObjectAttr(alt_unit_post_name) $tmp_post_name
   set ListingFile::($listfile_obj,alt_unit_post_name) $tmp_post_name
  }
  set add_obj_list $Post::($post_object,add_obj_list)
  foreach add_obj $add_obj_list \
  {
   if { [string length $address::($add_obj,leader_var)] > 0 } \
   {
    set add_leader_var $address::($add_obj,leader_var)
    set mom_sys_arr($add_leader_var) $address::($add_obj,add_leader)
   }
  }
  set mom_sys_arr(\$mom_sys_seqnum_start) $mom_sys_arr(seqnum_start)
  set mom_sys_arr(\$mom_sys_seqnum_incr)  $mom_sys_arr(seqnum_incr)
  set mom_sys_arr(\$mom_sys_seqnum_freq)  $mom_sys_arr(seqnum_freq)
  set mom_sys_arr(\$mom_sys_seqnum_max)   $mom_sys_arr(seqnum_max)
  set Post::($post_object,mom_sys_var_list) [array get mom_sys_arr]
  PB_file_MapNewIKSParams
  if { [info exist ::env(SUB_POST_MODE)] && $::env(SUB_POST_MODE) == 1 } \
  {
   if { [info exists ::env(UNIT_SUB_POST_MODE)] && $::env(UNIT_SUB_POST_MODE) == 1 } {
    PB_PB2TCL_main tcl_file
    PB_pui_WritePuiFile pui_file
   }
   } else {
   if { $Post::($::post_object,has_external) } {
    PB_file_DiffPostObjects 1
   }
   PB_PB2DEF_main def_parse_obj def_file
   PB_PB2TCL_main tcl_file
   if [PB_is_v $gPB(VNC_release)] {
    PB_PB2VNC_main vnc_file
   }
   PB_pui_WritePuiFile pui_file
   if { $::env(PB_UDE_ENABLED) == 1 } {
    set dir [file rootname $pui_file]
    set cdlname $dir.cdl
    PB_ude_OutputCdlFile cdlname
    } else {
    if [file exists [file rootname $pui_file].cdl] {
     file delete -force [file rootname $pui_file].cdl
    }
   }
  }
  if { ![string compare "BACKUP_SAVE" $gPB(backup_method)] } {
   set gPB(backup_method) "NO_BACKUP"
   global LicInfo
   if { $gPB(PB_LICENSE) == "UG_POST_AUTHOR" &&\
    [info exists LicInfo(SITE_ID_IS_OK_FOR_PT)] && $LicInfo(SITE_ID_IS_OK_FOR_PT) == 0 &&\
    [lsearch $gPB(lic_list) $LicInfo(post_license)] >= 0 } {
    return
   }
   set gPB(backup_one_done) 0
   if { [info exists bck_folder] && [file exists $bck_folder] } {
    file delete -force $bck_folder
   }
  }
 }

#=======================================================================
proc PB_file_SetDefaultPostObjects { args } {
  set _class_elm_list { format      ext_fmt_list \
   address     ext_add_list \
   block       ext_blk_list \
   command     ext_cmd_list \
   function    ext_fun_list \
   ude_event   ext_ude_list \
  cycle_event ext_cyc_list }
  Post::infoMiscAttr $::post_object
  set status [Post::diffMiscAttr $::post_object]
  if { $status && !$external } {
   return $status
  }
  set ClassName [string trim [classof $Post::($::post_object,list_obj_list)] :]
  set obj [lindex $Post::($::post_object,list_obj_list) 0]
  set status [${ClassName}::diffObj $obj]
  if { $status && !$external } {
   return $status
  }
  set _class_obj_list { format   fmt_obj_list \
   address  add_obj_list \
   block    blk_obj_list \
   command  cmd_blk_list \
  function function_blk_list }
  foreach { _class _obj_list } $_class_obj_list {
   foreach obj $Post::($::post_object,$_obj_list) {
    ${_class}::infoObj $obj
    set status [${_class}::diffObj $obj $external]
    if { $status && !$external } {
     return $status
    }
   }
  }
  Post::GetObjList $::post_object ude_event ude_obj_list
  foreach eventobj $ude_obj_list {
   set class_type [classof $eventobj]
   if { $class_type == "::ude_event" } {
    ude_event::infoObj $eventobj
    set status [ude_event::diffObj $eventobj $external]
    if { $status && !$external } {
     return $status
    }
    } else {
    cycle_event::infoObj $eventobj
    set status [cycle_event::diffObj $eventobj $external]
    if { $status && !$external } {
     return $status
    }
   }
  }
  foreach obj $Post::($::post_object,seq_obj_list) {
   sequence::infoObj $obj
   set status [sequence::diffObj $obj $external]
   if { $status && !$external } {
    return $status
   }
  }
  if 0 { ;# Later
   foreach obj $Post::($::post_object,event_procs) {
   }
  }
 }

#=======================================================================
proc PB_file_DiffPostObjects { args } {
  set status 0
  set external 0
  if [llength $args] {
   set external [lindex $args 0]
  }
  if { $external == 0 } {
   return 1
  }
  set ::gPB(diff_post_flag) 1
  UI_PB_debug_ForceMsg " ########################  In PB_file_DiffPostObjects  external=$external"
  catch { UI_PB_UpdateCurrentBookPageAttr ::gPB(book) }
  catch { UI_PB_oth_ApplyOtherAttr }  ;# Needed to bring other elements up-to-date. However,
  set ude_obj $Post::($::post_object,ude_obj)
  set mce_seq $ude::($ude_obj,seq_obj)
  set cyc_seq $ude::($ude_obj,seq_obj_cycle)
  if [string match $::machType "Mill"] {
   set event_obj_list [concat $sequence::($mce_seq,mc_ude_obj_list) \
   $sequence::($mce_seq,non_mc_ude_obj_list)]
   set event_obj_list [UI_PB_ude_SortEventObj_ByName $event_obj_list]
   set cycle_obj_list [UI_PB_ude_SortEventObj_ByName $ude::($ude_obj,cyc_evt_obj_list)]
   } else {
   set event_obj_list [concat $sequence::($mce_seq,mc_ude_obj_list) \
   $sequence::($mce_seq,non_mc_ude_obj_list)]
   set event_obj_list [UI_PB_ude_SortEventObj_ByName $event_obj_list]
   set cycle_obj_list [list]
  }
  Post::SetObjListasAttr $::post_object event_obj_list
  Post::SetObjListasAttr $::post_object cycle_obj_list
  if { $external } {
   return [_file_DiffExtPostObjects 1]
   } else {
   if [_file_DiffExtPostObjects 0] {
    return 1
   }
  }
  Post::infoMiscAttr $::post_object
  set status [Post::diffMiscAttr $::post_object]
  if { $status && !$external } {
   return $status
  }
  set ClassName [string trim [classof $Post::($::post_object,list_obj_list)] :]
  set obj [lindex $Post::($::post_object,list_obj_list) 0]
  set status [${ClassName}::diffObj $obj]
  if { $status && !$external } {
   return $status
  }
  set _class_obj_list { format   fmt_obj_list \
   address  add_obj_list \
   block    blk_obj_list \
   command  cmd_blk_list \
  function function_blk_list }
  foreach { _class _obj_list } $_class_obj_list {
   foreach obj $Post::($::post_object,$_obj_list) {
    ${_class}::infoObj $obj
    set status [${_class}::diffObj $obj $external]
    if { $status && !$external } {
     return $status
    }
   }
  }
  Post::GetObjList $::post_object ude_event ude_obj_list
  foreach eventobj $ude_obj_list {
   set class_type [classof $eventobj]
   if { $class_type == "::ude_event" } {
    ude_event::infoObj $eventobj
    set status [ude_event::diffObj $eventobj $external]
    if { $status && !$external } {
     return $status
    }
    } else {
    cycle_event::infoObj $eventobj
    set status [cycle_event::diffObj $eventobj $external]
    if { $status && !$external } {
     return $status
    }
   }
  }
  foreach obj $Post::($::post_object,seq_obj_list) {
   sequence::infoObj $obj
   set status [sequence::diffObj $obj $external]
   if { $status && !$external } {
    return $status
   }
  }
  if { ![PB_file_is_JE_POST_DEV] } {
   Post::GetEventProcs $::post_object event_proc_arr
   PB_output_GetEvtObjAttr evt_name_list evt_blk_arr udc_name_list evt_obj_arr
   PB_output_RetBlksModality blk_mod_arr
   set evt_name_list [lsort $evt_name_list]
   set useless_handler_list [list MOM_peck_drill MOM_drill_csink MOM_break_chip]
   foreach one $useless_handler_list {
    set idx [lsearch $evt_name_list $one]
    if { $idx >= 0 } {
     set evt_name_list [lreplace $evt_name_list $idx $idx]
    }
   }
   UI_PB_debug_ForceMsg_no_trace " % % % % %  Event name list : $evt_name_list"
   foreach event_name $evt_name_list \
   {
    set status 0
    set changed_event_name $event_name
    if { $::env(PB_UDE_ENABLED) == 1 } {
     if [string match $event_name "MOM_spindle"] {
      set changed_event_name MOM_spindle_rpm
      } elseif [string match $event_name "MOM_cutcom"] {
      set changed_event_name MOM_cutcom_on
      } elseif [string match $event_name "MOM_wire_cutcom"] {
      set changed_event_name MOM_cutcom_on
     }
     if { [string match "*lathe*" $::mom_kin_var(\$mom_kin_machine_type)] } {
      if [string match $event_name "MOM_cutcom"] {
       set changed_event_name MOM_cutcom_css
      }
     }
    }
    if { ![info exists event_proc_arr($changed_event_name)] } {
     UI_PB_debug_ForceMsg_no_trace " % % % % %  Event handler of $changed_event_name not found!"
     set status 1
     } else {
     set evt_obj $evt_obj_arr($event_name)
     PB_output_GetEventProcData evt_obj event_name evt_blk_arr($event_name) \
     blk_mod_arr event_output $udc_name_list
     if { [string trim [lindex $event_output 0]] == "" } {
      set event_output [lreplace $event_output 0 0]
     }
     switch $event_name \
     {
      "MOM_drill" -
      "MOM_drill_dwell" -
      "MOM_drill_text" -
      "MOM_drill_deep" -
      "MOM_drill_break_chip" -
      "MOM_tap" -
      "MOM_tap_float" -
      "MOM_tap_deep" -
      "MOM_tap_break_chip" -
      "MOM_bore" -
      "MOM_bore_drag" -
      "MOM_bore_no_drag" -
      "MOM_bore_manual" -
      "MOM_bore_dwell" -
      "MOM_bore_back" -
      "MOM_bore_manual_dwell" -
      "MOM_thread" {
       set event_proc_arr($changed_event_name) "$event_proc_arr($changed_event_name) {\n} $event_proc_arr(${changed_event_name}_move)"
      }
      default {}
     }
     if { [string comp $event_proc_arr($changed_event_name) $event_output] } {
      UI_PB_debug_ForceMsg_no_trace " % % % % %  Event handler of $changed_event_name __different \n\
      \t old: $event_proc_arr($changed_event_name)\n\
      \t new: $event_output"
      set status 1
      } else {
      UI_PB_debug_ForceMsg_no_trace " % % % % %  Event handler of $changed_event_name identical \n\
      \t $event_output"
     }
     unset event_output
    }
    if { $status && !$external } {
     return $status
    }
   }
  }
  return $status
 }

#=======================================================================
proc _file_DiffExtPostObjects { {_external 1} } {
  set status 0
  if { $Post::($::post_object,has_external) } {
   set _class_elm_list { format      ext_fmt_list \
    address     ext_add_list \
    block       ext_blk_list \
    command     ext_cmd_list \
    function    ext_fun_list \
    ude_event   ext_ude_list \
   cycle_event ext_cyc_list }
   foreach { _class _elm_list } $_class_elm_list {
    foreach elm $Post::($::post_object,${_elm_list}) {
     set obj [PB_com_FindObjFrmName $elm $_class]
     if { $obj != -1 } {
      ${_class}::infoObj $obj
      set status [${_class}::diffObj $obj $_external]
      UI_PB_debug_ForceMsg_no_trace " % % % % %  External object $elm ($obj) of $_class status = $status"
      if { $status && !$_external } {
       return $status
      }
      if { $status } {
       set ${_class}::($obj,is_external) 0
       UI_PB_debug_ForceMsg_no_trace " % % % % %  External object $elm of $_class has changed \
       and will be saved with the post."
       } else {
       set ${_class}::($obj,is_external) 1
      }
      } else {
      UI_PB_debug_ForceMsg_no_trace " % % % % %  External object $elm of $_class not found"
     }
    }
   }
  }
  return $status
 }

#=======================================================================
proc PB_file_ExcludeExtPostObjects { OBJ_LIST class } {
  upvar $OBJ_LIST obj_list
  set status 0
  if { $Post::($::post_object,has_external) } {
   set EXT_ELM_LIST(format)      ext_fmt_list
   set EXT_ELM_LIST(address)     ext_add_list
   set EXT_ELM_LIST(block)       ext_blk_list
   set EXT_ELM_LIST(command)     ext_cmd_list
   set EXT_ELM_LIST(function)    ext_fun_list
   set EXT_ELM_LIST(ude_event)   ext_ude_list
   set EXT_ELM_LIST(cycle_event) ext_cyc_list
   foreach elm $Post::($::post_object,$EXT_ELM_LIST($class)) {
    PB_com_RetObjFrmName elm obj_list obj
    if { $obj != 0 } { ;# Object found
     if { [set ${class}::($obj,is_external)] } {
      set idx [lsearch $obj_list $obj]
      set obj_list [lreplace $obj_list $idx $idx]
      set status 1
      UI_PB_debug_ForceMsg_no_trace " % % % % %  External $class object: $elm excluded from output\n"
     }
    }
   }
  }
  return $status
 }

#=======================================================================
proc PB_file_DiffDefObjects { PARSER_OBJ OUTPUT_DEF_FILE } {
  upvar $PARSER_OBJ parser_obj
  upvar $OUTPUT_DEF_FILE def_file
  global post_object
  set fmt_obj_list $Post::($post_object,fmt_obj_list)
  set add_obj_list $Post::($post_object,add_obj_list)
  set blk_obj_list $Post::($post_object,blk_obj_list)
  array set mom_sys_var $Post::($post_object,mom_sys_var_list)
  array set mom_kin_var_arr $Post::($post_object,mom_kin_var_list)
  set listfile_obj        $Post::($post_object,list_obj_list)
  set list_addr_obj_list  $ListingFile::($listfile_obj,add_obj_list)
  if { [info exists ListingFile::($listfile_obj,block_obj)] } \
  {
   set list_blk_obj $ListingFile::($listfile_obj,block_obj)
  } else \
  {
   set list_blk_obj 0
  }
  set comment_blk_list $Post::($post_object,comment_blk_list)
  set i 0
  foreach cmt_blk $comment_blk_list {
   if { ![info exists block::($cmt_blk,evt_elem_list)]  || \
    [llength $block::($cmt_blk,evt_elem_list)] == 0 } {
    set comment_blk_list [lreplace $comment_blk_list $i $i]
    UI_PB_debug_ForceMsg "unused comment block == $block::($cmt_blk,block_name)"
    } else {
    incr i
   }
  }
  global mom_sys_arr
  global ads_cdl_arr
  set include_str [PB_output_FindIncludeString $post_object $def_file]
  PB_output_GetWordSeperator $mom_sys_var(Word_Seperator) word_sep
  PB_output_GetEndOfLine $mom_sys_var(End_of_Block) endof_line
  set seq_param_arr(0) $mom_sys_var(seqnum_block)
  set seq_param_arr(1) $mom_sys_var(seqnum_start)
  set seq_param_arr(2) $mom_sys_var(seqnum_incr)
  set seq_param_arr(3) $mom_sys_var(seqnum_freq)
  if { [string compare $mom_sys_var(seqnum_max) ""] } {
   set seq_param_arr(4) $mom_sys_var(seqnum_max)
   } else {
   set seq_param_arr(4) [PB_output_GetSeqNumMax]
  }
  PB_output_GetSequenceNumber seq_param_arr sequence_num
  set add N
  PB_com_RetObjFrmName add add_obj_list add_obj
  address::readvalue $add_obj add_obj_attr
  set add_obj_attr(4) $mom_sys_var(seqnum_max)
  address::setvalue $add_obj add_obj_attr
  address::DefaultValue $add_obj add_obj_attr
  PB_output_GetFmtObjAttr fmt_obj_list fmt_name_arr fmt_val_arr
  PB_PB2DEF_write_formats deff_id fmt_name_arr fmt_val_arr
  unset fmt_name_arr fmt_val_arr
  PB_output_GetAdrObjAttr add_obj_list adr_name_arr adr_val_arr
  PB_PB2DEF_write_addresses deff_id adr_name_arr adr_val_arr
  unset adr_name_arr adr_val_arr
  PB_output_GetAdrObjAttr list_addr_obj_list adr_name_arr adr_val_arr
  PB_PB2DEF_write_addresses deff_id adr_name_arr adr_val_arr
  unset adr_name_arr adr_val_arr
  PB_output_GetBlkObjAttr blk_obj_list add_obj_list blk_name_arr \
  blk_val_arr
  PB_PB2DEF_write_block_templates deff_id blk_name_arr blk_val_arr
  unset blk_name_arr blk_val_arr
  PB_output_GetCompositeBlks comp_blk_list
  if { [string compare $comp_blk_list ""] } \
  {
   PB_output_GetBlkObjAttr comp_blk_list add_obj_list blk_name_arr \
   blk_val_arr
   PB_PB2DEF_write_block_templates deff_id blk_name_arr blk_val_arr
   unset blk_name_arr blk_val_arr
  }
  if [info exists Post::($post_object,post_blk_list)] {
   if { [string compare $Post::($post_object,post_blk_list) ""] } \
   {
    set post_blk_list ""
    foreach post_blk $Post::($post_object,post_blk_list) \
    {
     if [string match "normal" $block::($post_blk,blk_type)] \
     {
      lappend post_blk_list $post_blk
     }
    }
    if { [string compare $post_blk_list ""] } \
    {
     PB_output_GetBlkObjAttr post_blk_list add_obj_list blk_name_arr blk_val_arr
     PB_PB2DEF_write_block_templates deff_id blk_name_arr blk_val_arr
     unset blk_name_arr blk_val_arr
    }
   }
  }
  if { [string compare $comment_blk_list ""] } \
  {
   PB_output_GetBlkObjAttr comment_blk_list add_obj_list blk_name_arr blk_val_arr
   PB_PB2DEF_write_block_templates deff_id blk_name_arr blk_val_arr
   unset blk_name_arr blk_val_arr
  }
  PB_lfl_RetLfileBlock listfile_obj list_blk_value
  if { $list_blk_obj != 0 } \
  {
   set blk_name_arr(0) $block::($list_blk_obj,block_name)
  } else \
  {
   set blk_name_arr(0) "comment_data"
  }
  set blk_val_arr(0) $list_blk_value
  if { [string compare $list_blk_value ""] } \
  {
   PB_PB2DEF_write_block_templates deff_id blk_name_arr blk_val_arr
  }
  if { [info exists blk_name_arr] } \
  {
   unset blk_name_arr blk_val_arr
  }
 }

#=======================================================================
proc PB_file_DiffEventObjects { PARSER_OBJ OUTPUT_TCL_FILE } {
  upvar $OUTPUT_TCL_FILE tcl_file
  global post_object
  set alter_unit_sub_post 0
  if { [info exist ::env(SUB_POST_MODE)] && $::env(SUB_POST_MODE) == 1 } \
  {
   if { [info exists ::env(UNIT_SUB_POST_MODE)] && $::env(UNIT_SUB_POST_MODE) == 1 } {
    set alter_unit_sub_post 1
   }
  }
  if { !$alter_unit_sub_post } {
   PB_PB2TCL_write_tcl_procs tclf_id
   PB_PB2TCL_write_command_procs tclf_id POST
   PB_PB2TCL_write_other_procs tclf_id
   PB_PB2TCL_write_function_procs tclf_id
   PB_PB2TCL_write_switchunit_function tclf_id
   puts $tclf_id ""
   puts $tclf_id ""
   puts $tclf_id "if \[info exists mom_sys_start_of_program_flag\] {"
    puts $tclf_id "   if \[llength \[info commands PB_CMD_kin_start_of_program\] \] {"
     puts $tclf_id "      PB_CMD_kin_start_of_program"
    puts $tclf_id "   }"
    puts $tclf_id "} else {"
    puts $tclf_id "   set mom_sys_head_change_init_program 1"
    puts $tclf_id "   set mom_sys_start_of_program_flag 1"
   puts $tclf_id "}"
   puts $tclf_id ""
   puts $tclf_id ""
   PB_PB2TCL_SourceUserTclFile tclf_id
  }
 }

#=======================================================================
proc __file_GetNextFileName { file_name bck_ext } {
  set file_root [file rootname $file_name]
  set bck_file ${file_root}${bck_ext}
  set i 0
  while { [file exists ${bck_file}] } {
   incr i
   set bck_file ${file_root}${bck_ext}$i
  }
  return $bck_file
 }

#=======================================================================
proc __isv_initialSIMVars { } {
  global mom_sim_arr mom_sys_arr
  global gPB axisoption machType
  global mom_kin_var gpb_addr_var
  if { [info exists gPB(Old_PUI_Version)] && [string compare $gPB(Postbuilder_Version) $gPB(Old_PUI_Version)] <= 0 } {
   return
  }
  if { [string match "IN" $mom_kin_var(\$mom_kin_output_unit)] } {
   set mom_sim_arr(\$mom_sim_feed_mode) "INCH_PER_MIN"
   set mom_sim_arr(\$mom_sim_spindle_mode) "SFM"
   } else {
   set mom_sim_arr(\$mom_sim_feed_mode) "MM_PER_MIN"
   set mom_sim_arr(\$mom_sim_spindle_mode) "SMM"
  }
  set sim_var_list { mom_sim_initial_motion \
   mom_sim_control_var_leader \
   mom_sim_input_mode \
   mom_sim_power_on_wcs \
   mom_sim_prog_rewind_stop_code \
   mom_sim_control_var_leader \
   mom_sim_control_equal_sign \
   mom_sim_rapid_dogleg \
   mom_sim_mode_leader \
   mom_sim_incr_linear_addrs \
   mom_sim_output_vnc_msg \
   mom_sim_spindle_direction \
   mom_sim_from_home  \
   mom_sim_return_home \
   mom_sim_wcs_offsets \
   mom_sim_tool_data \
   mom_sim_local_wcs \
   mom_sim_mach_cs \
   mom_sim_zcs_base \
   mom_sim_spindle_comp \
   mom_sim_spindle_jct \
   mom_sim_num_machine_axes \
   mom_sim_mt_axis \
   mom_sim_reverse_4th_table \
   mom_sim_4th_axis_has_limits \
   mom_sim_reverse_5th_table \
  mom_sim_5th_axis_has_limits }
  foreach sim_var $sim_var_list {
   if {![info exists mom_sim_arr(\$$sim_var)] ||  \
    [string match "" [set mom_sim_arr(\$$sim_var)]] } {
    switch $sim_var {
     mom_sim_control_var_leader \
     { set mom_sim_arr(\$mom_sim_control_var_leader)                "\#" }
     mom_sim_initial_motion \
     { set mom_sim_arr(\$mom_sim_initial_motion)                 "RAPID" }
     mom_sim_input_mode \
     { set mom_sim_arr(\$mom_sim_input_mode)                       "ABS" }
     mom_sim_power_on_wcs \
     { set mom_sim_arr(\$mom_sim_power_on_wcs)                       "0" }
     mom_sim_prog_rewind_stop_code \
     { set mom_sim_arr(\$mom_sim_prog_rewind_stop_code)              "%" }
     mom_sim_control_var_leader \
     { set mom_sim_arr(\$mom_sim_control_var_leader)                 "#" }
     mom_sim_control_equal_sign \
     { set mom_sim_arr(\$mom_sim_control_equal_sign)                 "=" }
     mom_sim_rapid_dogleg \
     { set mom_sim_arr(\$mom_sim_rapid_dogleg)                       "1" }
     mom_sim_mode_leader \
     { set mom_sim_arr(\$mom_sim_mode_leader)                      "XYZ" }
     mom_sim_incr_linear_addrs \
     { set mom_sim_arr(\$mom_sim_incr_linear_addrs)               [list] }
     mom_sim_output_vnc_msg \
     { set mom_sim_arr(\$mom_sim_output_vnc_msg)                     "0" }
     mom_sim_spindle_direction \
     { set mom_sim_arr(\$mom_sim_spindle_direction)                "CLW" }
     mom_sim_from_home \
     { set mom_sim_arr(\$mom_sim_from_home)                         "29" }
     mom_sim_return_home \
     { set mom_sim_arr(\$mom_sim_return_home)                       "30" }
     mom_sim_local_wcs \
     { set mom_sim_arr(\$mom_sim_local_wcs)                         "52" }
     mom_sim_mach_cs \
     { set mom_sim_arr(\$mom_sim_mach_cs)                           "53" }
     mom_sim_zcs_base \
     { set mom_sim_arr(\$mom_sim_zcs_base)                     "X_SLIDE" }
     mom_sim_spindle_comp \
     { set mom_sim_arr(\$mom_sim_spindle_comp)                 "SPINDLE" }
     mom_sim_spindle_jct \
     { set mom_sim_arr(\$mom_sim_spindle_jct)           "TOOL_MOUNT_JCT" }
     mom_sim_mt_axis \
     {
      set mom_sim_arr(\$mom_sim_mt_axis\(X\)) "X"
      set mom_sim_arr(\$mom_sim_mt_axis\(Y\)) "Y"
      set mom_sim_arr(\$mom_sim_mt_axis\(Z\)) "Z"
     }
    }; #switch
    if { [info exists axisoption] } {
     if { [string match "4*" $axisoption] || [string match "5*" $axisoption] } {
      switch $sim_var {
       mom_sim_reverse_4th_table \
       {
        set mom_sim_arr(\$mom_sim_reverse_4th_table) "0"
       }
       mom_sim_4th_axis_has_limits \
       {
        set mom_sim_arr(\$mom_sim_4th_axis_has_limits) "1"
       }
       mom_sim_mt_axis \
       {
        if { [string match "4*" $axisoption] } {
         set mom_sim_arr(\$mom_sim_mt_axis\(4\)) "$gpb_addr_var(fourth_axis,leader_name)"
         } else {
         set mom_sim_arr(\$mom_sim_mt_axis\(4\)) "$gpb_addr_var(fourth_axis,leader_name)"
         set mom_sim_arr(\$mom_sim_mt_axis\(5\)) "$gpb_addr_var(fifth_axis,leader_name)"
        }
       }
      }
      if { [string match "5*" $axisoption] } {
       switch $sim_var {
        mom_sim_reverse_5th_table \
        {
         set mom_sim_arr(\$mom_sim_reverse_5th_table) "0"
        }
        mom_sim_5th_axis_has_limits \
        {
         set mom_sim_arr(\$mom_sim_5th_axis_has_limits) "1"
        }
       }
      }
     }
    }
   }
  }
 }

#=======================================================================
proc PB_file_ParsePostUtilityFile { post_object } {
  global gPB env
  if { ![info exists gPB(NEED_LOAD_POST_UTIL)] || !$gPB(NEED_LOAD_POST_UTIL) } {
   return
  }
  set gPB(NEED_LOAD_POST_UTIL) 0
  set base_file "$env(PB_HOME)/pblib/pb_base.tcl"
  if { ![file exists "$base_file"] } {
   return
  }
  if { [info exists gPB(pui_ui_overwrite)] && !$gPB(pui_ui_overwrite) } {
   set change_overwrite_flag 1
   } else {
   set change_overwrite_flag 0
  }
  if { $change_overwrite_flag } {
   set gPB(pui_ui_overwrite) 1
  }
  if { [catch { PB_pps_CreateTclFileObjs post_object $base_file 1 }] } {
   if { $change_overwrite_flag } {
    set gPB(pui_ui_overwrite) 0
   }
   return [ error "$gPB(msg,bad_tcl_file) : \n\n$errorInfo" ]
  }
  if { $change_overwrite_flag } {
   set gPB(pui_ui_overwrite) 0
  }
 }
