#23

#=======================================================================
proc infoObj_ForceMsg { obj } {
  if { [llength [info commands "[classof $obj]::infoObj"]] > 0 } {
   set debug_state $::gPB(DEBUG)
   set ::gPB(DEBUG) 1
   [classof $obj]::infoObj $obj
   set ::gPB(DEBUG) $debug_state
  }
 }
 class format {

#=======================================================================
proc format { this } {
  UI_PB_debug_DebugMsg "format $this constructed"
  set format::($this,for_name)       "DEFAULT"
  set format::($this,for_dtype)      ""
  set format::($this,for_leadplus)   0
  set format::($this,for_leadzero)   0
  set format::($this,for_trailzero)  0
  set format::($this,for_valfpart)   0
  set format::($this,for_outdecimal) 0
  set format::(this,for_valspart)    0
  set format::($this,is_dummy)       0
  set format::($this,is_external)    0
  set format::($this,fmt_addr_list)  [list]
 }

#=======================================================================
proc ~format { this } {
  UI_PB_debug_DebugMsg "~format $this destroyed"
 }

#=======================================================================
proc setvalue { this OBJ_ATTR } {
  upvar $OBJ_ATTR obj_attr
  set format::($this,for_name)       $obj_attr(0)
  set format::($this,for_dtype)      $obj_attr(1)
  set format::($this,for_leadplus)   $obj_attr(2)
  set format::($this,for_leadzero)   $obj_attr(3)
  set format::($this,for_trailzero)  $obj_attr(4)
  set format::($this,for_valfpart)   $obj_attr(5)
  set format::($this,for_outdecimal) $obj_attr(6)
  set format::($this,for_valspart)   $obj_attr(7)
  if { ![info exists obj_attr(8)] } { set obj_attr(8) 0 }
  set format::($this,is_dummy)       $obj_attr(8)
  if { ![info exists obj_attr(9)] } { set obj_attr(9) 0 }
  set format::($this,is_external)    $obj_attr(9)
 }

#=======================================================================
proc readvalue { this OBJ_ATTR } {
  upvar $OBJ_ATTR obj_attr
  set obj_attr(0) $format::($this,for_name)
  set obj_attr(1) $format::($this,for_dtype)
  set obj_attr(2) $format::($this,for_leadplus)
  set obj_attr(3) $format::($this,for_leadzero)
  set obj_attr(4) $format::($this,for_trailzero)
  set obj_attr(5) $format::($this,for_valfpart)
  set obj_attr(6) $format::($this,for_outdecimal)
  set obj_attr(7) $format::($this,for_valspart)
  if { ![info exists format::($this,is_dummy)] } {
   set format::($this,is_dummy) 0
  }
  set obj_attr(8) $format::($this,is_dummy)
  if { ![info exists format::($this,is_external)] } {
   set format::($this,is_external) 0
  }
  set obj_attr(9) $format::($this,is_external)
 }

#=======================================================================
proc DefaultValue { this OBJ_ATTR } {
  upvar $OBJ_ATTR obj_attr
  set format::($this,def_value) [array get obj_attr]
 }

#=======================================================================
proc AddToAddressList { this ADDR_OBJ } {
  upvar $ADDR_OBJ addr_obj
  if { $addr_obj != "" } \
  {
   if { [lsearch $format::($this,fmt_addr_list) $addr_obj] == -1 } {
    lappend format::($this,fmt_addr_list) $addr_obj
   }
  }
 }

#=======================================================================
proc DeleteFromAddressList { this ADDR_OBJ } {
  upvar $ADDR_OBJ addr_obj
  if { [info exists format::($this,fmt_addr_list)] } \
  {
   set index [lsearch $format::($this,fmt_addr_list) $addr_obj]
   if { $index != -1 } \
   {
    set format::($this,fmt_addr_list) \
    [lreplace $format::($this,fmt_addr_list) $index $index]
   }
  }
 }

#=======================================================================
proc infoObj { this } {
  if $::gPB(DEBUG) {
   UI_PB_debug_ForceMsg_no_trace "\n% % % % %  *** [classof $this] : $this *** "
   UI_PB_debug_ForceMsg_no_trace "  0  for_name       : $format::($this,for_name)"
   UI_PB_debug_ForceMsg_no_trace "  1  for_dtype      : $format::($this,for_dtype)"
   UI_PB_debug_ForceMsg_no_trace "  2  for_leadplus   : $format::($this,for_leadplus)"
   UI_PB_debug_ForceMsg_no_trace "  3  for_leadzero   : $format::($this,for_leadzero)"
   UI_PB_debug_ForceMsg_no_trace "  4  for_trailzero  : $format::($this,for_trailzero)"
   UI_PB_debug_ForceMsg_no_trace "  5  for_valfpart   : $format::($this,for_valfpart)"
   UI_PB_debug_ForceMsg_no_trace "  6  for_outdecimal : $format::($this,for_outdecimal)"
   UI_PB_debug_ForceMsg_no_trace "  7  for_valspart   : $format::($this,for_valspart)"
   UI_PB_debug_ForceMsg_no_trace "  8  is_dummy       : $format::($this,is_dummy)"
   UI_PB_debug_ForceMsg_no_trace "  9  is_external    : $format::($this,is_external)"
  }
 }

#=======================================================================
proc diffObj { this {_external 0} } {
  return [PB_mthd_DiffObjWithDefault $this $_external]
 }
}
class address {

#=======================================================================
proc address { this } {
  UI_PB_debug_DebugMsg "address $this constructed"
  set address::($this,add_name)           "DEFAULT"
  set address::($this,add_format)         ""
  set address::($this,add_force)          ""
  set address::($this,add_force_status)   ""
  set address::($this,add_max)            ""
  set address::($this,add_max_status)     ""
  set address::($this,add_min)            ""
  set address::($this,add_min_status)     ""
  set address::($this,add_leader)         ""
  set address::($this,add_trailer)        ""
  set address::($this,add_trailer_status) ""
  set address::($this,add_incremental)    ""
  set address::($this,add_zerofmt)        ""
  set address::($this,add_zerofmt_name)   ""
  set address::($this,is_dummy)           0
  set address::($this,is_external)        0
  set address::($this,obj_attr_cnt)       16
  set address::($this,rep_mom_var)        ""
  set address::($this,word_status)        ""
  set address::($this,word_desc)          ""
  set address::($this,seq_no)             0
  set address::($this,blk_elem_list)      [list]
  set address::($this,leader_var)         ""
  set address::($this,rename_flag)        1
  set address::($this,rest_mseq_attr)     [list]
  set address::($this,undo_mseq_attr)     [list]
  set address::($this,divi_dim)          ""
  set address::($this,divi_id)           ""
  set address::($this,rect_dim)          ""
  set address::($this,rect_id)           ""
  set address::($this,image_id)          ""
  set address::($this,icon_id)           ""
  set address::($this,xc)                ""
  set address::($this,yc)                ""
 }

#=======================================================================
proc ~address { this } {
  UI_PB_debug_DebugMsg "~address $this destroyed"
  set fmt_obj $address::($this,add_format)
  if { $fmt_obj != "" } \
  {
   format::DeleteFromAddressList $fmt_obj this
  }
  array set def_obj_attr $address::($this,def_value)
  set def_fmt $def_obj_attr(1)
  if { $def_fmt != "" } \
  {
   format::DeleteFromAddressList $def_fmt this
  }
 }

#=======================================================================
proc setvalue { this OBJ_ATTR } {
  upvar $OBJ_ATTR obj_attr
  set address::($this,add_name)            $obj_attr(0)
  set address::($this,add_format)          $obj_attr(1)
  set address::($this,add_force)           $obj_attr(2)
  set address::($this,add_force_status)    $obj_attr(3)
  set address::($this,add_max)             $obj_attr(4)
  set address::($this,add_max_status)      $obj_attr(5)
  set address::($this,add_min)             $obj_attr(6)
  set address::($this,add_min_status)      $obj_attr(7)
  set address::($this,add_leader)          $obj_attr(8)
  set address::($this,add_trailer)         $obj_attr(9)
  set address::($this,add_trailer_status)  $obj_attr(10)
  set address::($this,add_incremental)     $obj_attr(11)
  set address::($this,add_zerofmt)         $obj_attr(12)
  if { ![info exists obj_attr(13)] } { set obj_attr(13) "" }
  set address::($this,add_zerofmt_name)    $obj_attr(13)
  if { ![info exists obj_attr(14)] } { set obj_attr(14) 0 }
  set address::($this,is_dummy)            $obj_attr(14)
  if { ![info exists obj_attr(15)] } { set obj_attr(15) 0 }
  set address::($this,is_external)         $obj_attr(15)
 }

#=======================================================================
proc readvalue { this OBJ_ATTR } {
  upvar $OBJ_ATTR obj_attr
  set obj_attr(0)  $address::($this,add_name)
  set obj_attr(1)  $address::($this,add_format)
  set obj_attr(2)  $address::($this,add_force)
  set obj_attr(3)  $address::($this,add_force_status)
  set obj_attr(4)  $address::($this,add_max)
  set obj_attr(5)  $address::($this,add_max_status)
  set obj_attr(6)  $address::($this,add_min)
  set obj_attr(7)  $address::($this,add_min_status)
  set obj_attr(8)  $address::($this,add_leader)
  set obj_attr(9)  $address::($this,add_trailer)
  set obj_attr(10) $address::($this,add_trailer_status)
  set obj_attr(11) $address::($this,add_incremental)
  set obj_attr(12) $address::($this,add_zerofmt)
  if [info exists address::($this,add_zerofmt_name)] {
   set obj_attr(13) $address::($this,add_zerofmt_name)
   } else {
   set obj_attr(13) ""
  }
  if { ![info exists address::($this,is_dummy)] } {
   set address::($this,is_dummy) 0
  }
  set obj_attr(14) $address::($this,is_dummy)
  if { ![info exists address::($this,is_external)] } {
   set address::($this,is_external) 0
  }
  set obj_attr(15) $address::($this,is_external)
 }

#=======================================================================
proc DefaultValue { this OBJ_ATTR } {
  upvar $OBJ_ATTR obj_attr
  set address::($this,def_value) [array get obj_attr]
 }

#=======================================================================
proc SetMseqAttr { this MSEQ_ATTR } {
  upvar $MSEQ_ATTR mseq_attr
  set address::($this,rep_mom_var) $mseq_attr(0)
  set address::($this,word_status) $mseq_attr(1)
  set address::($this,word_desc)   $mseq_attr(2)
  set address::($this,seq_no)      $mseq_attr(3)
  set address::($this,rename_flag) $mseq_attr(4)
 }

#=======================================================================
proc readMseqAttr { this MSEQ_ATTR } {
  upvar $MSEQ_ATTR mseq_attr
  set mseq_attr(0) $address::($this,rep_mom_var)
  set mseq_attr(1) $address::($this,word_status)
  set mseq_attr(2) $address::($this,word_desc)
  set mseq_attr(3) $address::($this,seq_no)
  set mseq_attr(4) $address::($this,rename_flag)
 }

#=======================================================================
proc DefaultMseqAttr { this MSEQ_ATTR } {
  upvar $MSEQ_ATTR mseq_attr
  set address::($this,def_mseq_attr) [array get mseq_attr]
 }

#=======================================================================
proc RestoreMseqAttr { this } {
  address::readMseqAttr $this mseq_attr
  set address::($this,rest_mseq_attr) [array get mseq_attr]
 }

#=======================================================================
proc SetUndoMseqAttr { this OBJ_ATTR } {
  upvar $OBJ_ATTR obj_attr
  set address::($this,undo_mseq_attr) [array get obj_attr]
 }

#=======================================================================
proc ReadUndoMseqAttr { this OBJ_ATTR } {
  upvar $OBJ_ATTR obj_attr
  array set obj_attr $address::($this,undo_mseq_attr)
 }

#=======================================================================
proc AddToBlkElemList { this BLK_ELEM_OBJ } {
  upvar $BLK_ELEM_OBJ blk_elem_obj
  lappend address::($this,blk_elem_list) $blk_elem_obj
 }

#=======================================================================
proc DeleteFromBlkElemList { this BLK_ELEM_OBJ } {
  upvar $BLK_ELEM_OBJ blk_elem_obj
  if { [info exists address::($this,blk_elem_list)] } \
  {
   set index [lsearch $address::($this,blk_elem_list) $blk_elem_obj]
   if { $index != -1 } \
   {
    set address::($this,blk_elem_list) \
    [lreplace $address::($this,blk_elem_list) $index $index]
   }
  }
 }

#=======================================================================
proc infoObj { this } {
  if $::gPB(DEBUG) {
   UI_PB_debug_ForceMsg_no_trace "\n% % % % %  *** [classof $this] : $this *** "
   UI_PB_debug_ForceMsg_no_trace "  0  add_name           : $address::($this,add_name)"
   UI_PB_debug_ForceMsg_no_trace "  1  add_formate ID     : $address::($this,add_format)"
   UI_PB_debug_ForceMsg_no_trace "  2  add_force          : $address::($this,add_force)"
   UI_PB_debug_ForceMsg_no_trace "  3  add_force_status   : $address::($this,add_force_status)"
   UI_PB_debug_ForceMsg_no_trace "  4  add_max            : $address::($this,add_max)"
   UI_PB_debug_ForceMsg_no_trace "  5  add_max_status     : $address::($this,add_max_status)"
   UI_PB_debug_ForceMsg_no_trace "  6  add_min            : $address::($this,add_min)"
   UI_PB_debug_ForceMsg_no_trace "  7  add_min_status     : $address::($this,add_min_status)"
   UI_PB_debug_ForceMsg_no_trace "  8  add_leader         : $address::($this,add_leader)"
   UI_PB_debug_ForceMsg_no_trace "  9  add_trailer        : $address::($this,add_trailer)"
   UI_PB_debug_ForceMsg_no_trace "  10 add_trailer_status : $address::($this,add_trailer_status)"
   UI_PB_debug_ForceMsg_no_trace "  11 add_incremental    : $address::($this,add_incremental)"
   UI_PB_debug_ForceMsg_no_trace "  12 add_zerofmt ID     : $address::($this,add_zerofmt)"
   UI_PB_debug_ForceMsg_no_trace "  13 add_zerofmt_name   : $address::($this,add_zerofmt_name)"
   UI_PB_debug_ForceMsg_no_trace "  14 is_dummy           : $address::($this,is_dummy)"
   UI_PB_debug_ForceMsg_no_trace "  15 is_external        : $address::($this,is_external)"
  }
 }

#=======================================================================
proc diffObj { this {_external 0} } {
  set _excluded_list { 1 } ;# Exclude Format obj ID from comparison
  set status [PB_mthd_DiffObjWithDefault $this $_external $_excluded_list]
  if { $status == 0 } {
   set fmt_obj $address::($this,add_format)
   array set def_attr $address::($this,def_value)
   if { ![string match $format::($fmt_obj,for_name) $format::($def_attr(1),for_name)] } {
    set status 1
   }
  }
  return $status
 }
}
class Post {

#=======================================================================
proc Post { this post_name } {
  UI_PB_debug_DebugMsg "Post $this constructed"
  set Post::($this,post_name) $post_name
  set Post::($this,tcl_file_read)     FALSE
  set Post::($this,def_file_read)     FALSE
  set Post::($this,pui_dir)           ""
  set Post::($this,def_file)          ""
  set Post::($this,tcl_file)          ""
  set Post::($this,output_dir)        ""
  set Post::($this,out_pui_file)      ""
  set Post::($this,out_def_file)      ""
  set Post::($this,out_tcl_file)      ""
  set Post::($this,comment_blk_list)  [list]
  set Post::($this,cmd_blk_list)      [list]
  set Post::($this,UDE_File_Name)      ""
  set Post::($this,word_sep)           ""
  set Post::($this,def_word_sep)       ""
  set Post::($this,end_of_line)        ""
  set Post::($this,def_end_of_line)    ""
  set Post::($this,sequence_param)     [list]
  set Post::($this,def_sequence_param) [list]
  set Post::($this,def_parse_obj)      ""
  set Post::($this,post_blk_list)      [list]
  set Post::($this,rst_post_startblk)  ""
  set Post::($this,vnc_evt_obj_list)  [list]
  set Post::($this,mom_vnc_desc_list) [list]
  set Post::($this,fmt_obj_list)      [list]
  set Post::($this,add_obj_list)      [list]
  set Post::($this,blk_obj_list)      [list]
  set Post::($this,Indep_fmt_list)    [list]
  set Post::($this,Indep_fmt_arr)     [list]
  set Post::($this,Indep_add_list)    [list]
  set Post::($this,Indep_add_arr)     [list]
  set Post::($this,g_codes)           [list]
  set Post::($this,g_codes_desc)      [list]
  set Post::($this,m_codes)           [list]
  set Post::($this,m_codes_desc)      [list]
  set Post::($this,msq_word_param)    [list]
  set Post::($this,msq_add_name)      [list]
  set Post::($this,def_mast_seq)      [list]
  set Post::($this,machine_tool)      [list]
  set Post::($this,list_obj_list)     [list]
  set Post::($this,rap_add_list)      [list]
  set Post::($this,seq_obj_list)      [list]
  set Post::($this,event_procs)       [list]
  set Post::($this,word_desc_array)   [list]
  set Post::($this,word_mom_var)      [list]
  set Post::($this,mom_sys_var_list)     [list]
  set Post::($this,def_mom_sys_var_list) [list]
  set Post::($this,mom_kin_var_list)     [list]
  set Post::($this,def_mom_kin_var_list) [list]
  set Post::($this,add_mom_var_list)     [list]
  set Post::($this,comp_blk_list)        [list]
  set Post::($this,blk_mod_list)         [list]
  set Post::($this,old_pui_blk_mod_list) [list]
  set Post::($this,cyl_com_evt)          [list]
  set Post::($this,cyl_evt_sh_com_evt)   [list]
  set Post::($this,def_gpb_fmt_var)      [list]
  set Post::($this,def_gpb_addr_var)     [list]
  set Post::($this,word_img_name)        [list]
  set Post::($this,word_app_text)        [list]
  set Post::($this,word_name_list)       [list]
  set Post::($this,main_kin_var)         [list]
  set Post::($this,main_sys_var)         [list]
  set Post::($this,other_proc_list)      [list]
  set Post::($this,other_proc_data)      [list]
  set Post::($this,ude_obj)              ""
  set Post::($this,user_def_axis_limit_flag) 0
  set Post::($this,mom_sim_var_list)     [list]
  set Post::($this,def_mom_sim_var_list) [list]
  set Post::($this,add_name_list)        [list]
  set Post::($this,function_blk_list)    [list]
  set Post::($this,has_external)      0
  set Post::($this,ext_fmt_list)      [list]  ;# format names
  set Post::($this,ext_add_list)      [list]  ;# address names
  set Post::($this,ext_blk_list)      [list]  ;# block names
  set Post::($this,ext_cmd_list)      [list]  ;# command names
  set Post::($this,ext_fun_list)      [list]  ;# function names
  set Post::($this,ext_ude_list)      [list]  ;# ude_event names
  set Post::($this,ext_cyc_list)      [list]  ;# cycle_event names
 }

#=======================================================================
proc ~Post { this } {
  UI_PB_debug_DebugMsg "~Post $this destroyed"
  foreach element $Post::($this,comment_blk_list) \
  {
   PB_com_DeleteObject $element
  }
  unset Post::($this,comment_blk_list)
  foreach element $Post::($this,cmd_blk_list) \
  {
   PB_com_DeleteObject $element
  }
  unset Post::($this,cmd_blk_list)
  foreach element $Post::($this,machine_tool) \
  {
   PB_com_DeleteObject $element
  }
  unset Post::($this,machine_tool)
  foreach element $Post::($this,list_obj_list) \
  {
   PB_com_DeleteObject $element
  }
  unset Post::($this,list_obj_list)
  PB_com_DeleteObject $Post::($this,def_parse_obj)
  foreach element $Post::($this,seq_obj_list) \
  {
   PB_com_DeleteObject $element
  }
  unset Post::($this,seq_obj_list)
  foreach element $Post::($this,blk_obj_list) \
  {
   PB_com_DeleteObject $element
  }
  unset Post::($this,blk_obj_list)
  foreach element $Post::($this,add_obj_list) \
  {
   PB_com_DeleteObject $element
  }
  unset Post::($this,add_obj_list)
  foreach element $Post::($this,fmt_obj_list) \
  {
   PB_com_DeleteObject $element
  }
  unset Post::($this,fmt_obj_list)
  if { $Post::($this,ude_obj) != "" } {
   set ude_obj $Post::($this,ude_obj)
   foreach element $ude::($ude_obj,event_obj_list) \
   {
    PB_com_DeleteObject $element
   }
   unset ude::($ude_obj,event_obj_list)
   foreach element $ude::($ude_obj,cyc_evt_obj_list) \
   {
    PB_com_DeleteObject $element
   }
   unset ude::($ude_obj,cyc_evt_obj_list)
   PB_com_DeleteObject $ude_obj
   unset Post::($this,ude_obj)
  }
 }

#=======================================================================
proc SetPostFiles { this PUI_DIR POST_FILES } {
  upvar $PUI_DIR pui_dir
  upvar $POST_FILES post_files
  if { ![string match "." [file dirname $post_files(def_file)]] || \
   ![string match "." [file dirname $post_files(tcl_file)]] } {
   UI_PB_debug_Pause "Inputs to this method should not contain directory name.\n\
   def file : $post_files(def_file)\n\
   tcl file : $post_files(tcl_file)"
   return TCL_ERROR
  }
  set Post::($this,pui_dir)  $pui_dir
  set Post::($this,def_file) $post_files(def_file)
  set Post::($this,tcl_file) $post_files(tcl_file)
 }

#=======================================================================
proc ReadPostFiles { this PUI_DIR DEF_FILE TCL_FILE } {
  upvar $PUI_DIR pui_dir
  upvar $DEF_FILE def_file
  upvar $TCL_FILE tcl_file
  set pui_dir  $Post::($this,pui_dir)
  set def_file $Post::($this,def_file)
  set tcl_file $Post::($this,tcl_file)
 }

#=======================================================================
proc SetPostOutputFiles { this DIR PUI_FILE DEF_FILE TCL_FILE } {
  upvar $DIR dir
  upvar $PUI_FILE pui_file
  upvar $DEF_FILE def_file
  upvar $TCL_FILE tcl_file
  set Post::($this,output_dir)   $dir
  set Post::($this,out_pui_file) $pui_file
  set Post::($this,out_def_file) $def_file
  set Post::($this,out_tcl_file) $tcl_file
 }

#=======================================================================
proc ReadPostOutputFiles { this DIR PUI_FILE DEF_FILE TCL_FILE } {
  upvar $DIR dir
  upvar $PUI_FILE pui_file
  upvar $DEF_FILE def_file
  upvar $TCL_FILE tcl_file
  set dir      $Post::($this,output_dir)
  set pui_file $Post::($this,out_pui_file)
  set def_file $Post::($this,out_def_file)
  set tcl_file $Post::($this,out_tcl_file)
 }

#=======================================================================
proc InitG-Codes { this G_CODES G_CODES_DESC } {
  upvar $G_CODES g_codes
  upvar $G_CODES_DESC g_codes_desc
  set Post::($this,g_codes)      [array get g_codes]
  set Post::($this,g_codes_desc) [array get g_codes_desc]
 }

#=======================================================================
proc InitM-Codes { this M_CODES M_CODES_DESC } {
  upvar $M_CODES m_codes
  upvar $M_CODES_DESC m_codes_desc
  set Post::($this,m_codes)      [array get m_codes]
  set Post::($this,m_codes_desc) [array get m_codes_desc]
 }

#=======================================================================
proc InitMasterSequence { this MSQ_ADD_NAME MSQ_WORD_PARAM } {
  upvar $MSQ_ADD_NAME msq_add_name
  upvar $MSQ_WORD_PARAM msq_word_param
  set Post::($this,msq_word_param)  [array get msq_word_param]
  set Post::($this,msq_add_name)    $msq_add_name
 }

#=======================================================================
proc SetDefMasterSequence { this ADD_OBJ_LIST } {
  upvar $ADD_OBJ_LIST add_obj_list
  set Post::($this,def_mast_seq) $add_obj_list
 }

#=======================================================================
proc MachineTool { this MACHINE_TOOL } {
  upvar $MACHINE_TOOL mtool
  set Post::($this,machine_tool) $mtool
 }

#=======================================================================
proc ListFileObject { this LIST_OBJ_LIST } {
  upvar $LIST_OBJ_LIST obj_list
  set Post::($this,list_obj_list) $obj_list
 }

#=======================================================================
proc SetObjListasAttr { this OBJ_LIST } {
  upvar $OBJ_LIST obj_list
  if { [llength $obj_list] == 0 } {
   return 0
  }
  set object [lindex $obj_list 0]
  set ClassName [string trim [classof $object] ::]
  if { ![string compare "ude_event"   $ClassName] || \
   ![string compare "cycle_event" $ClassName] } {
   if [info exists Post::($this,ude_obj)] {
    set ude_obj $Post::($this,ude_obj)
    } else {
    return 0
   }
  }
  switch $ClassName \
  {
   format      { set Post::($this,fmt_obj_list)        $obj_list }
   address     { set Post::($this,add_obj_list)        $obj_list }
   block       { set Post::($this,blk_obj_list)        $obj_list }
   command     { set Post::($this,cmd_blk_list)        $obj_list }
   comment     { set Post::($this,comment_blk_list)    $obj_list }
   event       { set Post::($this,event_procs)         $obj_list }
   sequence    { set Post::($this,seq_obj_list)        $obj_list }
   function    { set Post::($this,function_blk_list)   $obj_list }
   ude_event   { set  ude::($ude_obj,event_obj_list)   $obj_list }
   cycle_event { set  ude::($ude_obj,cyc_evt_obj_list) $obj_list }
  }
  return [llength $obj_list]
 }

#=======================================================================
proc GetObjList { this class OBJ_LIST } {
  upvar $OBJ_LIST obj_list
  if { ![string compare "ude_event" $class] || ![string compare "cycle_event" $class] } {
   if [info exists Post::($this,ude_obj)] {
    set ude_obj $Post::($this,ude_obj)
    } else {
    set obj_list ""
    return 0
   }
  }
  if [string match "event" $class] {
   UI_PB_debug_Pause "Post::GetObjList does not handle \"event\" class!"
   set obj_list ""
   return 0
  }
  switch $class \
  {
   format      { set class_obj_list  fmt_obj_list       }
   address     { set class_obj_list  add_obj_list       }
   block       { set class_obj_list  blk_obj_list       }
   command     { set class_obj_list  cmd_blk_list       }
   comment     { set class_obj_list  comment_blk_list   }
   event       { set class_obj_list  event_procs        }
   sequence    { set class_obj_list  seq_obj_list       }
   function    { set class_obj_list  function_blk_list  }
   default     { set class_obj_list  "unknown"          }
  }
  if { [info exists Post::($this,$class_obj_list)] } {
   set obj_list $Post::($this,$class_obj_list)
   } else {
   set obj_list ""
  }
  switch $class \
  {
   ude_event   { set obj_list  $ude::($ude_obj,event_obj_list)   }
   cycle_event { set obj_list  $ude::($ude_obj,cyc_evt_obj_list) }
  }
  return [llength $obj_list]
 }

#=======================================================================
proc SetRapAdd { this OBJ_LIST } {
  upvar $OBJ_LIST obj_list
  set Post::($this,rap_add_list) $obj_list
 }

#=======================================================================
proc SetSeqObj { this OBJ_LIST} {
  upvar $OBJ_LIST obj_list
  set Post::($this,seq_obj_list) $obj_list
 }

#=======================================================================
proc SetEventProcs { this EVENT_PROC_ARR } {
  upvar $EVENT_PROC_ARR event_proc_arr
  set Post::($this,event_procs) [array get event_proc_arr]
 }

#=======================================================================
proc GetEventProcs { this EVENT_PROC_ARR } {
  upvar $EVENT_PROC_ARR event_proc_arr
  if [info exists Post::($this,event_procs)] {
   array set event_proc_arr $Post::($this,event_procs)
  }
 }

#=======================================================================
proc SetOthProcList { this OTH_PROC_LIST } {
  upvar $OTH_PROC_LIST oth_proc_list
  set Post::($this,other_proc_list) $oth_proc_list
 }

#=======================================================================
proc GetOthProcList { this OTH_PROC_LIST } {
  upvar $OTH_PROC_LIST oth_proc_list
  if [info exists Post::($this,other_proc_list)] {
   set oth_proc_list $Post::($this,other_proc_list)
  }
 }

#=======================================================================
proc SetOthProcData { this OTH_PROC_DATA } {
  upvar $OTH_PROC_DATA oth_proc_data
  set Post::($this,other_proc_data) [array get oth_proc_data]
 }

#=======================================================================
proc GetOthProcData { this OTH_PROC_DATA } {
  upvar $OTH_PROC_DATA oth_proc_data
  if [info exists Post::($this,other_proc_data)] {
   array set oth_proc_data $Post::($this,other_proc_data)
  }
 }

#=======================================================================
proc SetCommentBlkList { this COMMENT_BLK_LIST } {
  upvar $COMMENT_BLK_LIST comment_blk_list
  set Post::($this,comment_blk_list) $comment_blk_list
 }

#=======================================================================
proc WordAddNamesSubNamesDesc { this } {
  set msq_add_name $Post::($this,msq_add_name)
  set Post::($this,word_name_list) $msq_add_name
  PB_com_WordSubNamesDesc this word_subnames_desc_array word_mom_var mom_sys_arr
  set Post::($this,word_desc_array)  [array get word_subnames_desc_array]
  set Post::($this,word_mom_var)     [array get word_mom_var]
  set Post::($this,mom_sys_var_list) [array get mom_sys_arr]
 }

#=======================================================================
proc infoMiscAttr { this } {
  if $::gPB(DEBUG) {
   set attr_list { word_sep         \
    end_of_line      \
    sequence_param   \
    msq_add_name     \
    mom_sys_var_list \
    mom_kin_var_list \
   mom_sim_var_list }
   UI_PB_debug_ForceMsg_no_trace "\n% % % % %  Post misc attr"
   foreach obj_attr $attr_list {
    UI_PB_debug_ForceMsg_no_trace "  $obj_attr \t\t $Post::($this,$obj_attr)"
   }
  }
 }

#=======================================================================
proc diffMiscAttr { this } {
  set status 0
  if 0 {
   set attr_list { word_sep          def_word_sep         \
    end_of_line       def_end_of_line      \
    sequence_param    def_sequence_param   \
   mom_sim_var_list  def_mom_sim_var_list }
   foreach { obj_attr def_attr } $attr_list {
    if [string compare $Post::($this,$def_attr) $Post::($this,$obj_attr)] {
     UI_PB_debug_ForceMsg_no_trace " % % % % %  Post attr $obj_attr __different $Post::($this,$def_attr)\n\
     \t $Post::($this,$obj_attr)"
     if { !$status } {
      if $::gPB(DEBUG) {
       set status 1
       } else {
       return 1
      }
     }
     } else {
     UI_PB_debug_ForceMsg_no_trace " % % % % %  Post attr $obj_attr identical $Post::($this,$def_attr)\n\
     \t $Post::($this,$obj_attr)"
    }
   }
  }
  global mom_kin_var
  global mom_sys_arr
  array set sys_var_arr     [array get mom_sys_arr]
  array set kin_var_arr     [array get mom_kin_var]
  array set def_sys_var_arr $Post::($this,def_mom_sys_var_list)
  array set def_kin_var_arr $Post::($this,def_mom_kin_var_list)
  foreach var [array names sys_var_arr] {
   if { [info exists sys_var_arr($var)] && [info exists def_sys_var_arr($var)] } {
    if [string compare $sys_var_arr($var) $def_sys_var_arr($var)] {
     UI_PB_debug_ForceMsg_no_trace " % % % % %  Post attr mom_sys_var_list $var __different :\
     $def_sys_var_arr($var) => $sys_var_arr($var)"
     if $::gPB(DEBUG) {
      set status 1
      } else {
      return 1
     }
     } else {
     UI_PB_debug_ForceMsg_no_trace " % % % % %  Post attr mom_sys_var_list $var identical : \
     $def_sys_var_arr($var) == $sys_var_arr($var)"
    }
   }
  }
  foreach var [array names kin_var_arr] {
   if { [info exists kin_var_arr($var)] && [info exists def_kin_var_arr($var)] } {
    if [string compare $kin_var_arr($var) $def_kin_var_arr($var)] {
     UI_PB_debug_ForceMsg_no_trace " % % % % %  Post attr mom_kin_var_list $var __different : \
     $def_kin_var_arr($var) => $kin_var_arr($var)"
     if $::gPB(DEBUG) {
      set status 1
      } else {
      return 1
     }
     } else {
     UI_PB_debug_ForceMsg_no_trace " % % % % %  Post attr mom_kin_var_list $var identical : \
     $def_kin_var_arr($var) == $kin_var_arr($var)"
    }
   }
  }
  return $status
 }
}
class block_element {

#=======================================================================
proc block_element { this block_name } {
  UI_PB_debug_DebugMsg "block_element $this constructed"
  set block_element::($this,parent_name)       $block_name
  set block_element::($this,elem_add_obj)      ""
  set block_element::($this,elem_mom_variable) ""
  set block_element::($this,elem_opt_nows_var) ""
  set block_element::($this,elem_desc)         ""
  set block_element::($this,force)             0
  set block_element::($this,owner)             "NONE"
  set block_element::($this,rest_value)        [list]
  set block_element::($this,undo_value)        [list]
  set block_element::($this,div_corn_x0)        ""
  set block_element::($this,div_corn_y0)        ""
  set block_element::($this,div_corn_x1)        ""
  set block_element::($this,div_corn_y1)        ""
  set block_element::($this,div_id)             ""
  set block_element::($this,rect_corn_x0)       ""
  set block_element::($this,rect_corn_y0)       ""
  set block_element::($this,rect_corn_x1)       ""
  set block_element::($this,rect_corn_y1)       ""
  set block_element::($this,rect)               ""
  set block_element::($this,blk_img)            ""
  set block_element::($this,icon_id)            ""
  set block_element::($this,xc)                 ""
  set block_element::($this,yc)                 ""
 }

#=======================================================================
proc ~block_element { this } {
  UI_PB_debug_DebugMsg "~block_element $this destroyed"
  if { $block_element::($this,elem_add_obj) == "Command" } \
  {
   set cmd_obj $block_element::($this,elem_mom_variable)
   if { [string match "*MOM_*" $cmd_obj] == 0 } \
   {
    command::DeleteFromBlkElemList $cmd_obj this
    command::DeleteFromBlkElemList $cmd_obj this
   }
   } elseif { $block_element::($this,elem_add_obj) == "Macro" } \
  {
   set func_obj $block_element::($this,elem_mom_variable)
   function::DeleteFromBlkElemList $func_obj this
   function::DeleteFromBlkElemList $func_obj this
  } else \
  {
   set add_obj $block_element::($this,elem_add_obj)
   address::DeleteFromBlkElemList $add_obj this
   array set def_obj_attr $block_element::($this,def_value)
   address::DeleteFromBlkElemList $def_obj_attr(0) this
  }
 }

#=======================================================================
proc setvalue { this OBJ_ATTR } {
  upvar $OBJ_ATTR obj_attr
  set block_element::($this,elem_add_obj)      $obj_attr(0)
  set block_element::($this,elem_mom_variable) $obj_attr(1)
  set block_element::($this,elem_opt_nows_var) $obj_attr(2)
  set block_element::($this,elem_desc)         $obj_attr(3)
  set block_element::($this,force)             $obj_attr(4)
 }

#=======================================================================
proc readvalue { this OBJ_ATTR } {
  upvar $OBJ_ATTR obj_attr
  set obj_attr(0) $block_element::($this,elem_add_obj)
  set obj_attr(1) $block_element::($this,elem_mom_variable)
  set obj_attr(2) $block_element::($this,elem_opt_nows_var)
  set obj_attr(3) $block_element::($this,elem_desc)
  set obj_attr(4) $block_element::($this,force)
 }

#=======================================================================
proc DefaultValue { this OBJ_ATTR } {
  upvar $OBJ_ATTR obj_attr
  set block_element::($this,def_value) [array get obj_attr]
 }

#=======================================================================
proc RestoreValue { this } {
  block_element::readvalue $this obj_attr
  set block_element::($this,rest_value) [array get obj_attr]
 }

#=======================================================================
proc SetUndoValue { this OBJ_ATTR } {
  upvar $OBJ_ATTR obj_attr
  set block_element::($this,undo_value) [array get obj_attr]
 }

#=======================================================================
proc ReadUndoValue { this OBJ_ATTR } {
  upvar $OBJ_ATTR obj_attr
  array set obj_attr $block_element::($this,undo_value)
 }

#=======================================================================
proc infoObj { this } {
  if $::gPB(DEBUG) {
   UI_PB_debug_ForceMsg_no_trace "\n% % % % %  *** [classof $this] : $this *** "
   UI_PB_debug_ForceMsg_no_trace "  0  elem_add_obj       : $block_element::($this,elem_add_obj)"
   UI_PB_debug_ForceMsg_no_trace "  1  elem_mom_variable  : $block_element::($this,elem_mom_variable)"
   UI_PB_debug_ForceMsg_no_trace "  2  elem_opt_nows_var  : $block_element::($this,elem_opt_nows_var)"
   UI_PB_debug_ForceMsg_no_trace "  3  elem_desc          : $block_element::($this,elem_desc)"
   UI_PB_debug_ForceMsg_no_trace "  4  force              : $block_element::($this,force)"
   UI_PB_debug_ForceMsg_no_trace "  Parent Object Name    : $block_element::($this,parent_name)"
   UI_PB_debug_ForceMsg_no_trace "  Owner Event Name      : $block_element::($this,owner)"
  }
 }

#=======================================================================
proc diffObj { this {_external 0} } {
  set _excluded_list { 0 } ;# Exclude Address obj ID from comparison
  return [PB_mthd_DiffObjWithDefault $this $_external $_excluded_list]
 }
}
class command {

#=======================================================================
proc command { this } {
  UI_PB_debug_DebugMsg "command $this constructed"
  set command::($this,name)          "Default"
  set command::($this,proc)          ""
  set command::($this,blk_list)      [list]
  set command::($this,add_list)      [list]
  set command::($this,fmt_list)      [list]
  set command::($this,description)   ""
  set command::($this,is_dummy)      0
  set command::($this,is_external)   0
  set command::($this,blk_elem_list) [list]
 }

#=======================================================================
proc ~command { this } {
  UI_PB_debug_DebugMsg "~command $this destroyed"
 }

#=======================================================================
proc setvalue { this OBJ_ATTR } {
  upvar $OBJ_ATTR obj_attr
  set command::($this,name)        $obj_attr(0)
  if { ![info exists obj_attr(1)] } {
   set obj_attr(1) ""
  }
  set command::($this,proc)        $obj_attr(1)
  if { ![info exists obj_attr(2)] } {
   set obj_attr(2) [list]
  }
  set command::($this,blk_list)    $obj_attr(2)
  if { ![info exists obj_attr(3)] } {
   set obj_attr(3) [list]
  }
  set command::($this,add_list)    $obj_attr(3)
  if { ![info exists obj_attr(4)] } {
   set obj_attr(4) [list]
  }
  set command::($this,fmt_list)    $obj_attr(4)
  if { ![info exists obj_attr(5)] } {
   set obj_attr(5) ""
  }
  set command::($this,description) $obj_attr(5)
  if { ![info exists obj_attr(6)] } {
   set obj_attr(6) 0
  }
  set command::($this,is_dummy)    $obj_attr(6)
  if { ![info exists obj_attr(7)] } {
   set obj_attr(7) 0
  }
  set command::($this,is_external) $obj_attr(7)
 }

#=======================================================================
proc readvalue { this OBJ_ATTR } {
  upvar $OBJ_ATTR obj_attr
  set obj_attr(0) $command::($this,name)
  set obj_attr(1) $command::($this,proc)
  set obj_attr(2) $command::($this,blk_list)
  set obj_attr(3) $command::($this,add_list)
  set obj_attr(4) $command::($this,fmt_list)
  set obj_attr(5) $command::($this,description)
  set obj_attr(6) $command::($this,is_dummy)
  set obj_attr(7) $command::($this,is_external)
 }

#=======================================================================
proc DefaultValue { this OBJ_ATTR } {
  upvar $OBJ_ATTR obj_attr
  set command::($this,def_value) [array get obj_attr]
 }

#=======================================================================
proc RestoreValue { this } {
  command::readvalue $this obj_attr
  set command::($this,rest_value) [array get obj_attr]
 }

#=======================================================================
proc AddToBlkElemList { this BLK_ELEM_OBJ } {
  upvar $BLK_ELEM_OBJ blk_elem_obj
  lappend command::($this,blk_elem_list) $blk_elem_obj
 }

#=======================================================================
proc DeleteFromBlkElemList { this BLK_ELEM_OBJ } {
  upvar $BLK_ELEM_OBJ blk_elem_obj
  if { [info exists command::($this,blk_elem_list)] } \
  {
   if 0 {
    set command::($this,blk_elem_list) [ltidy $command::($this,blk_elem_list)]
   }
   set index [lsearch $command::($this,blk_elem_list) $blk_elem_obj]
   if { $index != -1 } \
   {
    set command::($this,blk_elem_list) \
    [lreplace $command::($this,blk_elem_list) $index $index]
   }
  }
 }

#=======================================================================
proc infoObj { this } {
  if $::gPB(DEBUG) {
   UI_PB_debug_ForceMsg_no_trace "\n% % % % %  *** [classof $this] : $this *** "
   UI_PB_debug_ForceMsg_no_trace "  0  name         : $command::($this,name)"

#=======================================================================
UI_PB_debug_ForceMsg_no_trace "  1  proc         :\n[join $command::($this,proc) \n]"
 UI_PB_debug_ForceMsg_no_trace "  2  blk_list     : $command::($this,blk_list)"
 UI_PB_debug_ForceMsg_no_trace "  3  add_list     : $command::($this,add_list)"
 UI_PB_debug_ForceMsg_no_trace "  4  fmt_list     : $command::($this,fmt_list)"
 UI_PB_debug_ForceMsg_no_trace "  5  description  : $command::($this,description)"
 UI_PB_debug_ForceMsg_no_trace "  6  is_dummy     : $command::($this,is_dummy)"
 UI_PB_debug_ForceMsg_no_trace "  7  is_external  : $command::($this,is_external)"
}
}

#=======================================================================
proc diffObj { this {_external 0} } {
  set _excluded_list { 2 3 4 }
  return [PB_mthd_DiffObjWithDefault $this $_external $_excluded_list]
 }
} ;# command
class block {

#=======================================================================
proc block { this } {
  UI_PB_debug_DebugMsg "block $this constructed"
  set block::($this,block_name)            "DEFAULT"
  set block::($this,block_nof_elements)    0
  set block::($this,elem_addr_list)        [list]
  set block::($this,blk_type)              ""
  set block::($this,is_dummy)              0
  set block::($this,is_external)           0
  set block::($this,blk_owner)             "NONE"
  set block::($this,evt_elem_list)         [list]
  set block::($this,rest_value)            [list]
  set block::($this,undo_value)            [list]
  set block::($this,rect)                  ""
  set block::($this,rect_x0)               ""
  set block::($this,rect_y0)               ""
  set block::($this,rect_x1)               ""
  set block::($this,rect_y1)               ""
  set block::($this,blk_h)                 ""
  set block::($this,blk_w)                 ""
  set block::($this,div_id)                ""
  set block::($this,div_corn_x0)           ""
  set block::($this,div_corn_y0)           ""
  set block::($this,div_corn_x1)           ""
  set block::($this,div_corn_y1)           ""
  set block::($this,active_blk_elem_list)  ""
  set block::($this,sep_id)                ""
 }

#=======================================================================
proc ~block { this } {
  UI_PB_debug_DebugMsg "~block $this destroyed"
  foreach element $block::($this,elem_addr_list)\
  {
   PB_com_DeleteObject $element
  }
  array set obj_attr $block::($this,def_value)
  foreach def_elem $obj_attr(2) \
  {
   if { [lsearch $block::($this,elem_addr_list) $def_elem] == -1 }\
   {
    PB_com_DeleteObject $def_elem
   }
  }
  if { $block::($this,active_blk_elem_list) != "" } \
  {
   foreach act_elem $block::($this,active_blk_elem_list) \
   {
    if { [lsearch $block::($this,elem_addr_list) $act_elem] == -1 && \
    [lsearch $obj_attr(2) $act_elem] == -1 } \
    {
     PB_com_DeleteObject $act_elem
    }
   }
  }
  if 0 {
   foreach e $block::($this,evt_elem_list) {
    delete $e
   }
   Post::GetObjList $::post_object block blk_obj_list
   set idx [lsearch $blk_obj_list $this]
   if { $idx >= 0 } {
    set blk_obj_list [lreplace $blk_obj_list $idx $idx]
    Post::SetObjListasAttr $::post_object blk_obj_list
   }
  }
 }

#=======================================================================
proc setvalue { this OBJ_ATTR } {
  upvar $OBJ_ATTR obj_attr
  set block::($this,block_name)         $obj_attr(0)
  set block::($this,block_nof_elements) $obj_attr(1)
  set block::($this,elem_addr_list)     $obj_attr(2)
  set block::($this,blk_type)           $obj_attr(3)
  if { ![info exists obj_attr(4)] } { set obj_attr(4) 0 }
  set block::($this,is_dummy)           $obj_attr(4)
  if { ![info exists obj_attr(5)] } { set obj_attr(5) 0 }
  set block::($this,is_external)        $obj_attr(5)
 }

#=======================================================================
proc readvalue { this OBJ_ATTR } {
  upvar $OBJ_ATTR obj_attr
  set obj_attr(0) $block::($this,block_name)
  set obj_attr(1) $block::($this,block_nof_elements)
  set obj_attr(2) $block::($this,elem_addr_list)
  set obj_attr(3) $block::($this,blk_type)
  set obj_attr(4) $block::($this,is_dummy)
  set obj_attr(5) $block::($this,is_external)
 }

#=======================================================================
proc DefaultValue { this OBJ_ATTR } {
  upvar $OBJ_ATTR obj_attr
  set block::($this,def_value) [array get obj_attr]
 }

#=======================================================================
proc RestoreValue { this } {
  block::readvalue $this obj_attr
  set block::($this,rest_value) [array get obj_attr]
 }

#=======================================================================
proc SetUndoValue { this OBJ_ATTR } {
  upvar $OBJ_ATTR obj_attr
  set block::($this,undo_value) [array get obj_attr]
 }

#=======================================================================
proc ReadUndoValue { this OBJ_ATTR } {
  upvar $OBJ_ATTR obj_attr
  arry set obj_attr $block::($this,undo_value)
 }

#=======================================================================
proc AddToEventElemList { this EVENT_ELEM_OBJ } {
  upvar $EVENT_ELEM_OBJ event_elem_obj
  lappend block::($this,evt_elem_list) $event_elem_obj
 }

#=======================================================================
proc DeleteFromEventElemList { this EVENT_ELEM_OBJ } {
  upvar $EVENT_ELEM_OBJ event_elem_obj
  if { [info exists block::($this,evt_elem_list)] } \
  {
   set index [lsearch $block::($this,evt_elem_list) $event_elem_obj]
   if { $index != -1 } \
   {
    set block::($this,evt_elem_list) \
    [lreplace $block::($this,evt_elem_list) $index $index]
   }
  }
 }

#=======================================================================
proc infoObj { this } {
  if $::gPB(DEBUG) {
   UI_PB_debug_ForceMsg_no_trace "\n% % % % %  *** [classof $this] : $this *** "
   UI_PB_debug_ForceMsg_no_trace "  0  block_name         : $block::($this,block_name)"
   UI_PB_debug_ForceMsg_no_trace "  1  block_nof_elements : $block::($this,block_nof_elements)"
   UI_PB_debug_ForceMsg_no_trace "  2  elem_addr_list     : $block::($this,elem_addr_list)"
   UI_PB_debug_ForceMsg_no_trace "  3  blk_type           : $block::($this,blk_type)"
   UI_PB_debug_ForceMsg_no_trace "  4  is_dummy           : $block::($this,is_dummy)"
   UI_PB_debug_ForceMsg_no_trace "  5  is_external        : $block::($this,is_external)"
   UI_PB_debug_ForceMsg_no_trace "  blk_owner             : $block::($this,blk_owner)"
   UI_PB_debug_ForceMsg_no_trace "  evt_elem_list         : $block::($this,evt_elem_list)"
  }
 }

#=======================================================================
proc diffObj { this {_external 0} } {
  set _excluded_list { 2 } ;# Exclude block element ID
  set status [PB_mthd_DiffObjWithDefault $this $_external $_excluded_list 1]
  if { $status == 0 } {
   foreach blk_elem $block::($this,elem_addr_list) {
    block_element::infoObj $blk_elem
    if [block_element::diffObj $blk_elem $_external] {
     if { $::gPB(DEBUG) } {
      set status 1
      } else {
      return 1
     }
    }
   }
  }
  return $status
 }
}
class event_element {

#=======================================================================
proc event_element { this } {
  UI_PB_debug_DebugMsg "event_element $this constructed"
  set event_element::($this,evt_elem_name)      "DEFAULT"
  set event_element::($this,block_obj)          ""
  set event_element::($this,event_obj)          ""
  set event_element::($this,exec_condition_obj) 0
  set event_element::($this,suppress_flag)      0
  set event_element::($this,force_addr_list)    ""
  set event_element::($this,indent)             0
  set event_element::($this,xc)                 ""
  set event_element::($this,yc)                 ""
  set event_element::($this,line_id)            ""
  set event_element::($this,rect_id)            ""
  set event_element::($this,icon_id)            ""
  set event_element::($this,text_id)            ""
 }

#=======================================================================
proc ~event_element { this } {
  UI_PB_debug_DebugMsg "~event_element $this destroyed"
  set block_obj $event_element::($this,block_obj)
  block::DeleteFromEventElemList $block_obj this
  array set def_elem_obj_attr $event_element::($this,def_value)
  block::DeleteFromEventElemList $def_elem_obj_attr(1) this
  if 0 {
   set evt $event_element::($this,event_obj)
   set evt_elem_list $event::($evt,evt_elem_list)
   set idx [lsearch $evt_elem_list $this]
   if { $idx >= 0 } {
    set evt_elem_list [lreplace $evt_elem_list $idx $idx]
    set event::($evt,evt_elem_list) $evt_elem_list
   }
  }
 }

#=======================================================================
proc setvalue { this OBJ_ATTR } {
  upvar $OBJ_ATTR obj_attr
  set event_element::($this,evt_elem_name) $obj_attr(0)
  set event_element::($this,block_obj)     $obj_attr(1)
  if { [info exists obj_attr(2)] } {
   set event_element::($this,exec_condition_obj) $obj_attr(2)
   } else {
   set event_element::($this,exec_condition_obj) 0
  }
  if { [info exists obj_attr(3)] } {
   set event_element::($this,suppress_flag) $obj_attr(3)
   } else {
   set event_element::($this,suppress_flag) 0
  }
  if { [info exists obj_attr(4)] } {
   set event_element::($this,force_addr_list) $obj_attr(4)
   } else {
   set event_element::($this,force_addr_list) ""
  }
  if { [info exists obj_attr(5)] } {
   set event_element::($this,indent) $obj_attr(5)
   } else {
   set event_element::($this,indent) 0
  }
 }

#=======================================================================
proc readvalue { this OBJ_ATTR } {
  upvar $OBJ_ATTR obj_attr
  set obj_attr(0) $event_element::($this,evt_elem_name)
  set obj_attr(1) $event_element::($this,block_obj)
  set obj_attr(2) $event_element::($this,exec_condition_obj)
  set obj_attr(3) $event_element::($this,suppress_flag)
  set obj_attr(4) $event_element::($this,force_addr_list)
  if { [info exists event_element::($this,indent)] } {
   set obj_attr(5) $event_element::($this,indent)
   } else {
   set obj_attr(5) 0
  }
 }

#=======================================================================
proc DefaultValue { this OBJ_ATTR } {
  upvar $OBJ_ATTR obj_attr
  if { ![info exists obj_attr(2)] } {
   set obj_attr(2) 0
   set obj_attr(3) 0
   set obj_attr(4) ""
  }
  if { ![info exists obj_attr(5)] } {
   set obj_attr(5) 0
  }
  set event_element::($this,def_value) [array get obj_attr]
 }

#=======================================================================
proc RestoreValue { this } {
  event_element::readvalue $this obj_attr
  set event_element::($this,rest_value) [array get obj_attr]
 }

#=======================================================================
proc GetExecAttr { this ATTR_LIST } {
  upvar $ATTR_LIST attr_list
  set attr_list ""
  lappend attr_list $event_element::($this,exec_condition_obj)
  lappend attr_list $event_element::($this,suppress_flag)
  lappend attr_list $event_element::($this,force_addr_list)
  if { [info exists event_element::($this,indent)] } {
   lappend attr_list $event_element::($this,indent)
  }
 }

#=======================================================================
proc infoObj { this } {
  if $::gPB(DEBUG) {
   if 0 {
    UI_PB_debug_ForceMsg_no_trace "\n% % % % %  *** [classof $this] : $this *** "
    UI_PB_debug_ForceMsg_no_trace "  0  evt_elem_name      : $event_element::($this,evt_elem_name)"
    UI_PB_debug_ForceMsg_no_trace "  1  block_obj          : $event_element::($this,block_obj)"
    UI_PB_debug_ForceMsg_no_trace "  2  exec_condition_obj : $event_element::($this,exec_condition_obj)"
    UI_PB_debug_ForceMsg_no_trace "  3  suppress_flag      : $event_element::($this,suppress_flag)"
    UI_PB_debug_ForceMsg_no_trace "  4  force_addr_list    : $event_element::($this,force_addr_list)"
    if { [info exists event_element::($this,indent)] } {
     UI_PB_debug_ForceMsg_no_trace "  5  indent             : $event_element::($this,indent)"
    }
    UI_PB_debug_ForceMsg_no_trace "     event_obj          : $event_element::($this,event_obj)"
   }
   if { ![PB_com_HasObjectExisted $this] } {
    UI_PB_debug_ForceMsg_no_trace "\n% % % % %  *** ::event_element object $this does not exist! *** \n"
    } else {
    UI_PB_debug_ForceMsg_no_trace "\n% % % % %  *** [classof $this] : $this *** "
    set attrs_list { evt_elem_name block_obj exec_condition_obj suppress_flag force_addr_list indent event_obj }
    set i 0
    foreach attr $attrs_list {
     if { [info exists event_element::($this,${attr})] } {
      UI_PB_debug_ForceMsg_no_trace [format "%-30s : %s" "  $i  ${attr}" $event_element::($this,${attr})]
      } else {
      UI_PB_debug_ForceMsg_no_trace [format "%-30s : %s" "  $i  ${attr}" "attr does not exist!"]
     }
     incr i
    }
   }
  }
 }

#=======================================================================
proc diffObj { this {_external 0} } {
  set _excluded_list { 1 2 } ;# Exclude block_obj & exec_condition_obj
  set status [PB_mthd_DiffObjWithDefault $this $_external $_excluded_list]
  if { $status == 0 || $_external } {
   block::infoObj $event_element::($this,block_obj)
   set status [block::diffObj $event_element::($this,block_obj) $_external]
  }
  if { $status == 0 || $_external } {
   if { $event_element::($this,exec_condition_obj) } {
    set ClassName [string trim [classof $event_element::($this,exec_condition_obj)] :]
    ${ClassName}::infoObj $event_element::($this,exec_condition_obj)
    set status [${ClassName}::diffObj $event_element::($this,exec_condition_obj) $_external]
   }
  }
  return $status
 }
}
class event {

#=======================================================================
proc event { this } {
  UI_PB_debug_DebugMsg "event $this constructed"
  set event::($this,event_name)          "DEFAULT"
  set event::($this,block_nof_rows)      ""
  set event::($this,evt_elem_list)       ""
  set event::($this,cycle_rapid_to)      ""
  set event::($this,cycle_retract_to)    ""
  set event::($this,cycle_start_blk)     ""
  set event::($this,cycle_plane_control) ""
  set event::($this,evt_itm_obj_list)    ""
  set event::($this,rest_value)          [list]
  set event::($this,undo_value)          [list]
  set event::($this,event_open)          0
  set event::($this,event_height)        ""
  set event::($this,event_width)         ""
  set event::($this,xc)                  ""
  set event::($this,yc)                  ""
  set event::($this,sep_id)              ""
  set event::($this,col_image)           ""
  set event::($this,col_icon_id)         ""
  set event::($this,blk_text)            ""
  set event::($this,blk_rect)            ""
  set event::($this,evt_rect)            ""
  set event::($this,icon_id)             ""
  set event::($this,text_id)             ""
  set event::($this,rect_id)             ""
  set event::($this,extra_lines)         ""
  set event::($this,canvas_flag)         1
 }

#=======================================================================
proc ~event { this } {
  UI_PB_debug_DebugMsg "~event $this destroyed"
  set evt_elem_list $event::($this,evt_elem_list)
  foreach row_elem $evt_elem_list \
  {
   foreach evt_elem $row_elem \
   {
    PB_com_DeleteObject $evt_elem
   }
  }
  array set def_evt_obj_attr $event::($this,def_value)
  foreach row_elem $def_evt_obj_attr(2) \
  {
   foreach evt_elem $row_elem \
   {
    set delete_flag 0
    foreach act_row_list $event::($this,evt_elem_list) \
    {
     if { [lsearch $act_row_list $evt_elem] != -1 } \
     {
      set delete_flag 1
      break
     }
    }
    if { $delete_flag == 0 } \
    {
     PB_com_DeleteObject $evt_elem
    }
   }
  }
  set evt_item_list $event::($this,evt_itm_obj_list)
  foreach item $evt_item_list \
  {
   PB_com_DeleteObject $item
  }
  if { [info exists event::($this,event_ude_name)] } {
   unset event::($this,event_ude_name)
  }
 }

#=======================================================================
proc setvalue { this OBJ_ATTR } {
  upvar $OBJ_ATTR obj_attr
  set event::($this,event_name)          $obj_attr(0)
  set event::($this,block_nof_rows)      [llength $obj_attr(2)]
  set event::($this,evt_elem_list)       $obj_attr(2)
  set event::($this,evt_itm_obj_list)    $obj_attr(3)
  set event::($this,event_label)         $obj_attr(4)
  if { [info exists obj_attr(5)] } {
   set event::($this,event_ude_name)   $obj_attr(5)
   } else {
   set event::($this,event_ude_name)   ""
  }
 }

#=======================================================================
proc readvalue { this OBJ_ATTR } {
  upvar $OBJ_ATTR obj_attr
  set obj_attr(0) $event::($this,event_name)
  set obj_attr(1) [llength $event::($this,evt_elem_list)]
  set obj_attr(2) $event::($this,evt_elem_list)
  set obj_attr(3) $event::($this,evt_itm_obj_list)
  set obj_attr(4) $event::($this,event_label)
  if { [info exists event::($this,event_ude_name)] } {
   set obj_attr(5) $event::($this,event_ude_name)
   } else {
   set obj_attr(5) ""
  }
 }
 if 0 {

#=======================================================================
proc DefaultValue { this OBJ_ATTR } {
  upvar $OBJ_ATTR obj_attr
  set def_value [array get obj_attr]
  set event::($this,def_value) $def_value
 }
}

#=======================================================================
proc DefaultValue { this args } {
  if [llength $args] {
   upvar [lindex $args 0] obj_attr
   } else {
   readvalue $this obj_attr
  }
  set event::($this,def_value) [array get obj_attr]
 }

#=======================================================================
proc RestoreValue { this } {
  readvalue $this obj_attr
  set event::($this,rest_value) [array get obj_attr]
 }

#=======================================================================
proc infoObj { this } {
  if $::gPB(DEBUG) {
   UI_PB_debug_ForceMsg_no_trace "\n% % % % %  *** [classof $this] : $this *** "
   UI_PB_debug_ForceMsg_no_trace "  0  event_name            : $event::($this,event_name)"
   UI_PB_debug_ForceMsg_no_trace "  1  block_nof_rows        : $event::($this,block_nof_rows)"
   UI_PB_debug_ForceMsg_no_trace "  2  evt_elem_list         : $event::($this,evt_elem_list)"
   UI_PB_debug_ForceMsg_no_trace "  3  evt_itm_obj_list (UI) : $event::($this,evt_itm_obj_list)"
   UI_PB_debug_ForceMsg_no_trace "  4  event_label           : $event::($this,event_label)"
   UI_PB_debug_ForceMsg_no_trace "  5  event_ude_name        : $event::($this,event_ude_name)"
  }
 }

#=======================================================================
proc diffObj { this {_external 0} } {
  set _excluded_list { 2 3 }
  set status [PB_mthd_DiffObjWithDefault $this $_external $_excluded_list 1]
  if { $status == 0 || $_external } {
   foreach evt_elem $event::($this,evt_elem_list) {
    foreach etlm $evt_elem {
     event_element::infoObj $etlm
     if [event_element::diffObj $etlm $_external] {
      if { $::gPB(DEBUG) } {
       set status 1
       } else {
       return 1
      }
     }
    }
   }
  }
  return $status
 }
}
class sequence {

#=======================================================================
proc sequence { this } {
  UI_PB_debug_DebugMsg "sequence $this constructed"
  set sequence::($this,seq_name)   "DEFAULT"
  set sequence::($this,comb_var)   ""
  set sequence::($this,rest_value) [list]
  set sequence::($this,undo_value) [list]
 }

#=======================================================================
proc ~sequence { this } {
  UI_PB_debug_DebugMsg "~sequence $this destroyed"
  set evt_obj_list $sequence::($this,evt_obj_list)
  foreach evt_obj $evt_obj_list \
  {
   PB_com_DeleteObject $evt_obj
  }
 }

#=======================================================================
proc setvalue { this OBJ_ATTR } {
  upvar $OBJ_ATTR obj_attr
  set sequence::($this,seq_name)         $obj_attr(0)
  set sequence::($this,evt_obj_list)     $obj_attr(1)
  set sequence::($this,comb_elem_list)   $obj_attr(2)
 }

#=======================================================================
proc readvalue { this OBJ_ATTR } {
  upvar $OBJ_ATTR obj_attr
  set obj_attr(0) $sequence::($this,seq_name)
  set obj_attr(1) $sequence::($this,evt_obj_list)
  set obj_attr(2) $sequence::($this,comb_elem_list)
 }

#=======================================================================
proc DefaultValue { this OBJ_ATTR } {
  upvar $OBJ_ATTR obj_attr
  set sequence::($this,def_value) [array get obj_attr]
 }

#=======================================================================
proc RestoreValue { this } {
  sequence::readvalue $this obj_attr
  set sequence::($this,rest_value) [array get obj_attr]
 }

#=======================================================================
proc infoObj { this } {
  if $::gPB(DEBUG) {
   UI_PB_debug_ForceMsg_no_trace "\n% % % % %  *** [classof $this] : $this *** "
   UI_PB_debug_ForceMsg_no_trace "  0  seq_name            : $sequence::($this,seq_name)"
   UI_PB_debug_ForceMsg_no_trace "  1  evt_obj_list        : $sequence::($this,evt_obj_list)"
   UI_PB_debug_ForceMsg_no_trace "  2  comb_elem_list      : <sequence::($this,comb_elem_list) too long>"
  }
 }

#=======================================================================
proc diffObj { this {_external 0} } {
  set status 0
  foreach evt_obj $sequence::($this,evt_obj_list) {
   event::infoObj $evt_obj
   set status [event::diffObj $evt_obj $_external]
   if { $status && !$_external } {
    if { !$::gPB(DEBUG) } {
     return $status
    }
   }
  }
  return $status
 }
}
class item {

#=======================================================================
proc item { this } {
  UI_PB_debug_DebugMsg "item $this constructed"
  set item::($this,item_name) "DEFAULT"
 }

#=======================================================================
proc ~item { this } {
  UI_PB_debug_DebugMsg "~item $this destroyed"
  foreach grp_obj $item::($this,grp_obj_list) \
  {
   PB_com_DeleteObject $grp_obj
  }
 }

#=======================================================================
proc setvalue { this OBJ_ATTR } {
  upvar $OBJ_ATTR obj_attr
  set item::($this,label)         $obj_attr(0)
  set item::($this,nof_grps)      $obj_attr(1)
  set item::($this,grp_align)     $obj_attr(2)
  set item::($this,grp_obj_list)  $obj_attr(3)
 }

#=======================================================================
proc readvalue { this OBJ_ATTR } {
  upvar $OBJ_ATTR obj_attr
  set obj_attr(0) $item::($this,label)
  set obj_attr(1) $item::($this,nof_grps)
  set obj_attr(2) $item::($this,grp_align)
  set obj_attr(3) $item::($this,grp_obj_list)
 }

#=======================================================================
proc DefaultValue { this OBJ_ATTR } {
  upvar $OBJ_ATTR obj_attr
  set item::($this,def_value) [array get obj_attr]
 }

#=======================================================================
proc RestoreValue { this } {
  item::readvalue $this obj_attr
  set item::($this,rest_value) [array get obj_attr]
 }
}
class item_group {

#=======================================================================
proc item_group { this } {
  UI_PB_debug_DebugMsg "item_group $this constructed"
  set item_group::($this,elem_name) "DEFAULT"
 }

#=======================================================================
proc ~item_group { this } {
  UI_PB_debug_DebugMsg "~item_group $this destroyed"
  foreach mem_obj $item_group::($this,mem_obj_list) \
  {
   PB_com_DeleteObject $mem_obj
  }
 }

#=======================================================================
proc setvalue { this OBJ_ATTR } {
  upvar $OBJ_ATTR obj_attr
  set item_group::($this,name)            $obj_attr(0)
  set item_group::($this,nof_elems)       $obj_attr(1)
  set item_group::($this,elem_align)      $obj_attr(2)
  set item_group::($this,mem_obj_list)    $obj_attr(3)
 }

#=======================================================================
proc readvalue { this OBJ_ATTR } {
  upvar $OBJ_ATTR obj_attr
  set obj_attr(0) $item_group::($this,name)
  set obj_attr(1) $item_group::($this,nof_elems)
  set obj_attr(2) $item_group::($this,elem_align)
  set obj_attr(3) $item_group::($this,mem_obj_list)
 }

#=======================================================================
proc DefaultValue { this OBJ_ATTR } {
  upvar $OBJ_ATTR obj_attr
  set item_group::($this,def_value) [array get obj_attr]
 }

#=======================================================================
proc RestoreValue { this } {
  item_group::readvalue $this obj_attr
  set item_group::($this,rest_value) [array get obj_attr]
 }
}
class group_member {

#=======================================================================
proc group_member { this } {
  UI_PB_debug_DebugMsg "group_member $this constructed"
  set group_member::($this,elem_name) "DEFAULT"
  set group_member::($this,label)        ""
  set group_member::($this,widget_type)  -1
  set group_member::($this,data_type)    ""
  set group_member::($this,mom_var)      ""
  set group_member::($this,callback)     ""
  set group_member::($this,opt_list)     ""
  set group_member::($this,context_help) ""
 }

#=======================================================================
proc ~group_member { this } {
  UI_PB_debug_DebugMsg "~group_member $this destroyed"
 }

#=======================================================================
proc setvalue { this OBJ_ATTR } {
  upvar $OBJ_ATTR obj_attr
  set group_member::($this,label)       $obj_attr(0)
  set group_member::($this,widget_type) $obj_attr(1)
  set group_member::($this,data_type)   $obj_attr(2)
  set group_member::($this,mom_var)     $obj_attr(3)
  set group_member::($this,callback)    $obj_attr(4)
  set group_member::($this,opt_list)    $obj_attr(5)
  if [info exists obj_attr(6)] {
   set group_member::($this,context_help) $obj_attr(6)
  }
 }

#=======================================================================
proc readvalue { this OBJ_ATTR } {
  upvar $OBJ_ATTR obj_attr
  set obj_attr(0) $group_member::($this,label)
  set obj_attr(1) $group_member::($this,widget_type)
  set obj_attr(2) $group_member::($this,data_type)
  set obj_attr(3) $group_member::($this,mom_var)
  set obj_attr(4) $group_member::($this,callback)
  set obj_attr(5) $group_member::($this,opt_list)
  if [info exists group_member::($this,context_help)] {
   set obj_attr(6) $group_member::($this,context_help)
  }
 }

#=======================================================================
proc DefaultValue { this OBJ_ATTR } {
  upvar $OBJ_ATTR obj_attr
  set group_member::($this,def_value) [array get obj_attr]
 }

#=======================================================================
proc RestoreValue { this } {
  group_member::readvalue $this obj_attr
  set group_member::($this,rest_value) [array get obj_attr]
 }
}
class ListingFile {

#=======================================================================
proc ListingFile { this } {
  UI_PB_debug_DebugMsg "ListingFile $this constructed"
  if 0 {
   set def_values {0 listfile.lpt 0 0 0 0 0 0 0 0 40 \
   30 0 0 0 0 0 0 0 0 lpt 0 0 ptp 0 pb_user.tcl}
   set arr_names {listfile fname x y z 4axis 5axis feed \
    speed head lines column warn oper tool start_path \
    tool_chng end_path oper_time setup_time lpt_ext \
   review group ncfile_ext usertcl_check usertcl_name}
  }
  set var_list { {listfile 0} {fname listfile.lpt}\
   {x 0} {y 0} {z 0} {4axis 0} {5axis 0} {feed 0} {speed 0}\
   {head 0} {lines 40} {column 30}\
   {warn 0} {warn_opt FILE}\
   {oper 0} {tool 0} {start_path 0} {tool_chng 0} {end_path 0} {oper_time 0} {setup_time 0}\
   {lpt_ext lpt} {verbose 0} {review 0} {group 0} {ncfile_ext ptp}\
   {usertcl_check 0} {usertcl_name pb_user.tcl} {tran_path 0} {subprog_out 0} {link_var 0}\
   {use_default_unit_fragment 1} {alt_unit_post_name ""} }
  foreach var $var_list \
  {
   set name [lindex $var 0]
   set ListingFile::($this,$name) [lindex $var 1]
   lappend ListingFile::($this,arr_names) $name
  }
 }

#=======================================================================
proc ~ListingFile { this } {
  UI_PB_debug_DebugMsg "~ListingFile $this destroyed"
 }

#=======================================================================
proc setvalue { this OBJ_ATTR } {
  upvar $OBJ_ATTR obj_attr
  foreach name [array names obj_attr] \
  {
   set ListingFile::($this,$name) $obj_attr($name)
  }
 }

#=======================================================================
proc readvalue { this OBJ_ATTR } {
  upvar $OBJ_ATTR obj_attr
  if 0 {
   if { $this != "" } {
    foreach name $ListingFile::($this,arr_names) \
    {
     if [info exists ListingFile::($this,$name)] {
      set obj_attr($name) $ListingFile::($this,$name)
      } else {
      set obj_attr($name) ""
     }
    }
    } else {
    set this [new ListingFile]
    DefaultValue $this obj_attr
   }
  }
  foreach name $ListingFile::($this,arr_names) \
  {
   if [info exists ListingFile::($this,$name)] {
    set obj_attr($name) $ListingFile::($this,$name)
    } else {
    set obj_attr($name) ""
   }
  }
 }

#=======================================================================
proc SetLfileAddObjList { post_obj LF_ADD_OBJ_LIST } {
  upvar $LF_ADD_OBJ_LIST lf_add_obj_list
  set lfile_obj $Post::($post_obj,list_obj_list)
  set ListingFile::($lfile_obj,add_obj_list) $lf_add_obj_list
 }

#=======================================================================
proc SetLfileBlockObj { lfile_obj LF_BLK_OBJ } {
  upvar $LF_BLK_OBJ lf_blk_obj
  set ListingFile::($lfile_obj,block_obj) $lf_blk_obj
 }

#=======================================================================
proc DefaultValue { this OBJ_ATTR } {
  upvar $OBJ_ATTR obj_attr
  set ListingFile::($this,def_value)     [array get obj_attr]
  set ListingFile::($this,restore_value) [array get obj_attr]
 }

#=======================================================================
proc RestoreValue { this OBJ_ATTR } {
  upvar $OBJ_ATTR obj_attr
  set ListingFile::($this,restore_value) [array get obj_attr]
 }

#=======================================================================
proc infoObj { this } {
 }

#=======================================================================
proc diffObj { this {_external 0} } {
  global ListObjectAttr
  array set obj_attr [array get ListObjectAttr]
  array set def_attr $ListingFile::($this,def_value)
  set status 0
  foreach var [array names obj_attr] {
   if { [info exists def_attr($var)] && [info exists obj_attr($var)] } {
    if { ![string compare ON  $def_attr($var)] } { set def_attr($var) 1 }
    if { ![string compare OFF $def_attr($var)] } { set def_attr($var) 0 }
    if { ![string compare ON  $obj_attr($var)] } { set obj_attr($var) 1 }
    if { ![string compare OFF $obj_attr($var)] } { set obj_attr($var) 0 }
    if [string compare $def_attr($var) $obj_attr($var)] {
     UI_PB_debug_ForceMsg_no_trace " % % % % %  Listing file attr $var __different : $def_attr($var) => $obj_attr($var)"
     if $::gPB(DEBUG) {
      set status 1
      } else {
      return 1
     }
     } else {
     UI_PB_debug_ForceMsg_no_trace " % % % % %  Listing file attr $var identical : $def_attr($var) == $obj_attr($var)"
    }
   }
  }
  return $status
 }
}
class MachineToolElement {

#=======================================================================
proc MachineToolElement { this } {
  UI_PB_debug_DebugMsg "MachineToolElement $this constructed"
 }

#=======================================================================
proc ~MachineToolElement { this } {
  UI_PB_debug_DebugMsg "~MachineToolElement $this destroyed"
 }

#=======================================================================
proc GeneralParameters { this OBJ_ATTR } {
  upvar $OBJ_ATTR obj_attr
  foreach name [array names obj_attr] \
  {
   set MachineToolElement::($this,$name) $obj_attr($name)
  }
 }

#=======================================================================
proc 4AxisParameters { this OBJ_ATTR } {
  upvar $OBJ_ATTR obj_attr
  foreach name [array names obj_attr] \
  {
   set MachineToolElement::($this,$name\_4) $obj_attr($name)
  }
 }

#=======================================================================
proc 5AxisParameters { this OBJ_ATTR } {
  upvar $OBJ_ATTR obj_attr
  foreach name [array names obj_attr] \
  {
   set MachineToolElement::($this,$name\_5) $obj_attr($name)
  }
 }

#=======================================================================
proc DefaultValue { this OBJ_ATTR IDENTIFIER } {
  upvar $OBJ_ATTR obj_attr
  upvar $IDENTIFIER identifier
  switch $identifier \
  {
   3-Axis {
    set MachineToolElement::($this,3axis_def_value) [array get obj_attr]
   }
   4-Axis {
    set MachineToolElement::($this,4axis_def_value) [array get obj_attr]
   }
   5-Axis {
    set MachineToolElement::($this,5axis_def_value) [array get obj_attr]
   }
  }
 }
}
class param {

#=======================================================================
proc param { this } {
  UI_PB_debug_DebugMsg "param $this constructed"
  set param::($this,param_name) "DEFAULT"
 }

#=======================================================================
proc ~param { this } {
  UI_PB_debug_DebugMsg "~param $this destroyed"
 }

#=======================================================================
proc CreateObject { TYPE } {
  upvar $TYPE type
  switch $type \
  {
   i   {
    set object [new integer]
   }
   d   {
    set object [new double]
   }
   o   {
    set object [new option]
   }
   b   {
    set object [new boolean]
   }
   s   {
    set object [new string]
   }
   p   {
    set object [new point]
   }
   l   {
    set object [new bitmap]
   }
   g   {
    set object [new group]
   }
   v   {
    set object [new vector]
   }
  }
  return $object
 }

#=======================================================================
proc ObjectSetValue { this OBJ_ATTR } {
  upvar $OBJ_ATTR obj_attr
  set ClassName [string trim [classof $this] ::]
  switch $ClassName \
  {
   param::integer  {
    param::integer::setvalue $this obj_attr
   }
   param::double   {
    param::double::setvalue  $this obj_attr
   }
   param::option   {
    param::option::setvalue  $this obj_attr
   }
   param::boolean  {
    param::boolean::setvalue $this obj_attr
   }
   param::string   {
    param::string::setvalue  $this obj_attr
   }
   param::point    {
    param::point::setvalue   $this obj_attr
   }
   param::bitmap   {
    param::bitmap::setvalue  $this obj_attr
   }
   param::group    {
    param::group::setvalue   $this obj_attr
   }
   param::vector   {
    param::vector::setvalue  $this obj_attr
   }
  }
 }

#=======================================================================
proc ObjectSetDefaultValue { this OBJ_ATTR } {
  upvar $OBJ_ATTR obj_attr
  set ClassName [string trim [classof $this] ::]
  switch $ClassName \
  {
   param::integer  {
    param::integer::setdefvalue $this obj_attr
   }
   param::double   {
    param::double::setdefvalue  $this obj_attr
   }
   param::option   {
    param::option::setdefvalue  $this obj_attr
   }
   param::boolean  {
    param::boolean::setdefvalue $this obj_attr
   }
   param::string   {
    param::string::setdefvalue  $this obj_attr
   }
   param::point    {
    param::point::setdefvalue   $this obj_attr
   }
   param::bitmap   {
    param::bitmap::setdefvalue  $this obj_attr
   }
   param::group    {
    param::group::setdefvalue   $this obj_attr
   }
   param::vector   {
    param::vector::setdefvalue  $this obj_attr
   }
  }
 }

#=======================================================================
proc infoObj { this } {
  if $::gPB(DEBUG) {
   set ClassName [string trim [classof $this] ::]
   set param_class [string range $ClassName 7 end]
   UI_PB_debug_ForceMsg_no_trace "\n% % % % %  *** [classof $this] : $this *** "
   ${ClassName}::infoObj $this
  }
 }

#=======================================================================
proc diffObj { this {_external 0} } {
  set ClassName [string trim [classof $this] ::]
  set param_class [string range $ClassName 7 end]
  return [${ClassName}::diffObj $this $_external]
 }
 class integer {

#=======================================================================
proc integer { this } {
  UI_PB_debug_DebugMsg "integer $this constructed"
  set param::integer::($this,name) "INTEGER"
 }

#=======================================================================
proc ~integer { this } {
  UI_PB_debug_DebugMsg "~integer $this destroyed"
 }

#=======================================================================
proc setvalue { this OBJ_ATTR } {
  upvar $OBJ_ATTR obj_attr
  set param::integer::($this,name)      $obj_attr(0)
  set param::integer::($this,type)      $obj_attr(1)
  if { [string length [string trim $obj_attr(2)]] == 0 } {
   set obj_attr(2) "0"
  }
  set param::integer::($this,default)   $obj_attr(2)
  set param::integer::($this,toggle)    $obj_attr(3)
  set param::integer::($this,ui_label)  $obj_attr(4)
 }

#=======================================================================
proc readvalue { this OBJ_ATTR } {
  upvar $OBJ_ATTR obj_attr
  set obj_attr(0)  $param::integer::($this,name)
  set obj_attr(1)  $param::integer::($this,type)
  set obj_attr(2)  $param::integer::($this,default)
  set obj_attr(3)  $param::integer::($this,toggle)
  set obj_attr(4)  $param::integer::($this,ui_label)
 }

#=======================================================================
proc setdefvalue { this OBJ_ATTR } {
  upvar $OBJ_ATTR obj_attr
  set param::integer::($this,def_name)      $obj_attr(0)
  set param::integer::($this,def_type)      $obj_attr(1)
  set param::integer::($this,def_default)   $obj_attr(2)
  set param::integer::($this,def_toggle)    $obj_attr(3)
  set param::integer::($this,def_ui_label)  $obj_attr(4)
  set param::integer::($this,def_value)     [array get obj_attr]
 }

#=======================================================================
proc infoObj { this } {
  UI_PB_debug_ForceMsg_no_trace "\n% % % % %  *** [classof $this] : $this *** "
  UI_PB_debug_ForceMsg_no_trace "  0  name               : $param::integer::($this,name)"
  UI_PB_debug_ForceMsg_no_trace "  1  type               : $param::integer::($this,type)"
  UI_PB_debug_ForceMsg_no_trace "  2  default            : $param::integer::($this,default)"
  UI_PB_debug_ForceMsg_no_trace "  3  toggle             : $param::integer::($this,toggle)"
  UI_PB_debug_ForceMsg_no_trace "  4  ui_label           : $param::integer::($this,ui_label)"
 }

#=======================================================================
proc diffObj { this {_external 0} } {
  return [PB_mthd_DiffObjWithDefault $this $_external]
 }
}
class double {

#=======================================================================
proc double { this } {
  UI_PB_debug_DebugMsg "double $this constructed"
  set param::double::($this,name) "DOUBLE"
 }

#=======================================================================
proc ~double { this } {
  UI_PB_debug_DebugMsg "~double $this destroyed"
 }

#=======================================================================
proc setvalue { this OBJ_ATTR } {
  upvar $OBJ_ATTR obj_attr
  set param::double::($this,name)      $obj_attr(0)
  set param::double::($this,type)      $obj_attr(1)
  if { [string length [string trim $obj_attr(2)]] == 0 } {
   set obj_attr(2) "0.0"
  }
  set param::double::($this,default)   $obj_attr(2)
  set param::double::($this,toggle)    $obj_attr(3)
  set param::double::($this,ui_label)  $obj_attr(4)
 }

#=======================================================================
proc readvalue { this OBJ_ATTR } {
  upvar $OBJ_ATTR obj_attr
  set obj_attr(0)  $param::double::($this,name)
  set obj_attr(1)  $param::double::($this,type)
  set obj_attr(2)  $param::double::($this,default)
  set obj_attr(3)  $param::double::($this,toggle)
  set obj_attr(4)  $param::double::($this,ui_label)
 }

#=======================================================================
proc setdefvalue { this OBJ_ATTR } {
  upvar $OBJ_ATTR obj_attr
  set param::double::($this,def_name)      $obj_attr(0)
  set param::double::($this,def_type)      $obj_attr(1)
  set param::double::($this,def_default)   $obj_attr(2)
  set param::double::($this,def_toggle)    $obj_attr(3)
  set param::double::($this,def_ui_label)  $obj_attr(4)
  set param::double::($this,def_value)     [array get obj_attr]
 }

#=======================================================================
proc infoObj { this } {
  UI_PB_debug_ForceMsg_no_trace "\n% % % % %  *** [classof $this] : $this *** "
  UI_PB_debug_ForceMsg_no_trace "  0  name               : $param::double::($this,name)"
  UI_PB_debug_ForceMsg_no_trace "  1  type               : $param::double::($this,type)"
  UI_PB_debug_ForceMsg_no_trace "  2  default            : $param::double::($this,default)"
  UI_PB_debug_ForceMsg_no_trace "  3  toggle             : $param::double::($this,toggle)"
  UI_PB_debug_ForceMsg_no_trace "  4  ui_label           : $param::double::($this,ui_label)"
 }

#=======================================================================
proc diffObj { this {_external 0} } {
  return [PB_mthd_DiffObjWithDefault $this $_external]
 }
}
class option {

#=======================================================================
proc option { this } {
  UI_PB_debug_DebugMsg "option $this constructed"
  set param::option::($this,name) "OPTION"
 }

#=======================================================================
proc ~option { this } {
  UI_PB_debug_DebugMsg "~option $this destroyed"
 }

#=======================================================================
proc setvalue { this OBJ_ATTR } {
  upvar $OBJ_ATTR obj_attr
  set param::option::($this,name)      $obj_attr(0)
  set param::option::($this,type)      $obj_attr(1)
  if { [string length [string trim $obj_attr(2)]] == 0 } {
   set obj_attr(2) [string trim [lindex [split $obj_attr(3) ","] 0] \"]  ;# 1st option
  }
  set param::option::($this,default)   $obj_attr(2)
  set param::option::($this,options)   $obj_attr(3)
  set param::option::($this,ui_label)  $obj_attr(4)
  if [string match $obj_attr(5) ""] {
   set param::option::($this,toggle)    None
   } else {
   set param::option::($this,toggle)    $obj_attr(5) ;#<10-21-05 peter>defined temporarily for ude
  }
 }

#=======================================================================
proc readvalue { this OBJ_ATTR } {
  upvar $OBJ_ATTR obj_attr
  set obj_attr(0)  $param::option::($this,name)
  set obj_attr(1)  $param::option::($this,type)
  set obj_attr(2)  $param::option::($this,default)
  set obj_attr(3)  $param::option::($this,options)
  set obj_attr(4)  $param::option::($this,ui_label)
  if [string match "None" $param::option::($this,toggle)] {
   set obj_attr(5)  ""
   } else {
   set obj_attr(5)  $param::option::($this,toggle)
  }
 }

#=======================================================================
proc setdefvalue { this OBJ_ATTR } {
  upvar $OBJ_ATTR obj_attr
  set param::option::($this,def_name)      $obj_attr(0)
  set param::option::($this,def_type)      $obj_attr(1)
  set param::option::($this,def_default)   $obj_attr(2)
  set param::option::($this,def_options)   $obj_attr(3)
  set param::option::($this,def_ui_label)  $obj_attr(4)
  if [string match $obj_attr(5) ""] {
   set param::option::($this,def_toggle) None
   } else {
   set param::option::($this,def_toggle) $obj_attr(5)
  }
  set param::option::($this,def_value)     [array get obj_attr]
 }

#=======================================================================
proc infoObj { this } {
  UI_PB_debug_ForceMsg_no_trace "\n% % % % %  *** [classof $this] : $this *** "
  UI_PB_debug_ForceMsg_no_trace "  0  name               : $param::option::($this,name)"
  UI_PB_debug_ForceMsg_no_trace "  1  type               : $param::option::($this,type)"
  UI_PB_debug_ForceMsg_no_trace "  2  default            : $param::option::($this,default)"
  UI_PB_debug_ForceMsg_no_trace "  3  options            : $param::option::($this,options)"
  UI_PB_debug_ForceMsg_no_trace "  4  ui_label           : $param::option::($this,ui_label)"
  UI_PB_debug_ForceMsg_no_trace "  5  toggle             : $param::option::($this,toggle)"
 }

#=======================================================================
proc diffObj { this {_external 0} } {
  return [PB_mthd_DiffObjWithDefault $this $_external]
 }
}
class boolean {

#=======================================================================
proc boolean { this } {
  UI_PB_debug_DebugMsg "boolean $this constructed"
  set param::boolean::($this,name) "BOOLEAN"
 }

#=======================================================================
proc ~boolean { this } {
  UI_PB_debug_DebugMsg "~boolean $this destroyed"
 }

#=======================================================================
proc setvalue { this OBJ_ATTR } {
  upvar $OBJ_ATTR obj_attr
  set param::boolean::($this,name)      $obj_attr(0)
  set param::boolean::($this,type)      $obj_attr(1)
  if { [string length [string trim $obj_attr(2)]] == 0 } {
   set obj_attr(2) "FALSE"
  }
  set param::boolean::($this,default)   $obj_attr(2)
  set param::boolean::($this,ui_label)  $obj_attr(3)
 }

#=======================================================================
proc readvalue { this OBJ_ATTR } {
  upvar $OBJ_ATTR obj_attr
  set obj_attr(0)  $param::boolean::($this,name)
  set obj_attr(1)  $param::boolean::($this,type)
  set obj_attr(2)  $param::boolean::($this,default)
  set obj_attr(3)  $param::boolean::($this,ui_label)
 }

#=======================================================================
proc setdefvalue { this OBJ_ATTR } {
  upvar $OBJ_ATTR obj_attr
  set param::boolean::($this,def_name)      $obj_attr(0)
  set param::boolean::($this,def_type)      $obj_attr(1)
  set param::boolean::($this,def_default)   $obj_attr(2)
  set param::boolean::($this,def_ui_label)  $obj_attr(3)
  set param::boolean::($this,def_value)     [array get obj_attr]
 }

#=======================================================================
proc infoObj { this } {
  UI_PB_debug_ForceMsg_no_trace "\n% % % % %  *** [classof $this] : $this *** "
  UI_PB_debug_ForceMsg_no_trace "  0  name               : $param::boolean::($this,name)"
  UI_PB_debug_ForceMsg_no_trace "  1  type               : $param::boolean::($this,type)"
  UI_PB_debug_ForceMsg_no_trace "  2  default            : $param::boolean::($this,default)"
  UI_PB_debug_ForceMsg_no_trace "  3  ui_label           : $param::boolean::($this,ui_label)"
 }

#=======================================================================
proc diffObj { this {_external 0} } {
  return [PB_mthd_DiffObjWithDefault $this $_external]
 }
}
class string {

#=======================================================================
proc string { this } {
  UI_PB_debug_DebugMsg "string $this constructed"
  set param::string::($this,name) "STRING"
 }

#=======================================================================
proc ~string { this } {
  UI_PB_debug_DebugMsg "~string $this destroyed"
 }

#=======================================================================
proc setvalue { this OBJ_ATTR } {
  upvar $OBJ_ATTR obj_attr
  set param::string::($this,name)      $obj_attr(0)
  set param::string::($this,type)      $obj_attr(1)
  set param::string::($this,toggle)    $obj_attr(2)
  set param::string::($this,ui_label)  $obj_attr(3)
  set param::string::($this,default)   $obj_attr(4) ;# <11-01-05 peter>was defined for UDE
 }

#=======================================================================
proc readvalue { this OBJ_ATTR } {
  upvar $OBJ_ATTR obj_attr
  set obj_attr(0)  $param::string::($this,name)
  set obj_attr(1)  $param::string::($this,type)
  set obj_attr(2)  $param::string::($this,toggle)
  set obj_attr(3)  $param::string::($this,ui_label)
  set obj_attr(4)  $param::string::($this,default)
 }

#=======================================================================
proc setdefvalue { this OBJ_ATTR } {
  upvar $OBJ_ATTR obj_attr
  set param::string::($this,def_name)      $obj_attr(0)
  set param::string::($this,def_type)      $obj_attr(1)
  set param::string::($this,def_toggle)    $obj_attr(2)
  set param::string::($this,def_ui_label)  $obj_attr(3)
  set param::string::($this,def_default)   $obj_attr(4)
  set param::string::($this,def_value)     [array get obj_attr]
 }

#=======================================================================
proc infoObj { this } {
  UI_PB_debug_ForceMsg_no_trace "\n% % % % %  *** [classof $this] : $this *** "
  UI_PB_debug_ForceMsg_no_trace "  0  name               : $param::string::($this,name)"
  UI_PB_debug_ForceMsg_no_trace "  1  type               : $param::string::($this,type)"
  UI_PB_debug_ForceMsg_no_trace "  2  toggle             : $param::string::($this,toggle)"
  UI_PB_debug_ForceMsg_no_trace "  3  ui_label           : $param::string::($this,ui_label)"
  UI_PB_debug_ForceMsg_no_trace "  4  default            : $param::string::($this,default)"
 }

#=======================================================================
proc diffObj { this {_external 0} } {
  return [PB_mthd_DiffObjWithDefault $this $_external]
 }
}
class point {

#=======================================================================
proc point { this } {
  UI_PB_debug_DebugMsg "point $this constructed"
  set param::point::($this,name) "POINT"  ;#<07-21-2015 gsl> was "STRING"
 }

#=======================================================================
proc ~point  { this } {
  UI_PB_debug_DebugMsg "~point $this destroyed"
 }

#=======================================================================
proc setvalue { this OBJ_ATTR } {
  upvar $OBJ_ATTR obj_attr
  set param::point::($this,name)      $obj_attr(0)
  set param::point::($this,type)      $obj_attr(1)
  set param::point::($this,ui_label)  $obj_attr(2)
  set param::point::($this,toggle)    $obj_attr(3) ;#<10-21-05 peter>defined temporarily for ude
 }

#=======================================================================
proc readvalue { this OBJ_ATTR } {
  upvar $OBJ_ATTR obj_attr
  set obj_attr(0)  $param::point::($this,name)
  set obj_attr(1)  $param::point::($this,type)
  set obj_attr(2)  $param::point::($this,ui_label)
  set obj_attr(3)  $param::point::($this,toggle)
 }

#=======================================================================
proc setdefvalue { this OBJ_ATTR } {
  upvar $OBJ_ATTR obj_attr
  set param::point::($this,def_name)      $obj_attr(0)
  set param::point::($this,def_type)      $obj_attr(1)
  set param::point::($this,def_ui_label)  $obj_attr(2)
  set param::point::($this,def_toggle)    $obj_attr(3)
  set param::point::($this,def_value)     [array get obj_attr]
 }

#=======================================================================
proc infoObj { this } {
  UI_PB_debug_ForceMsg_no_trace "\n% % % % %  *** [classof $this] : $this *** "
  UI_PB_debug_ForceMsg_no_trace "  0  name               : $param::point::($this,name)"
  UI_PB_debug_ForceMsg_no_trace "  1  type               : $param::point::($this,type)"
  UI_PB_debug_ForceMsg_no_trace "  2  ui_label           : $param::point::($this,ui_label)"
  UI_PB_debug_ForceMsg_no_trace "  3  toggle             : $param::point::($this,toggle)"
 }

#=======================================================================
proc diffObj { this {_external 0} } {
  return [PB_mthd_DiffObjWithDefault $this $_external]
 }
}
class bitmap {

#=======================================================================
proc bitmap { this } {
  UI_PB_debug_DebugMsg "bitmap $this constructed"
  set param::bitmap::($this,name) "BITMAP"
 }

#=======================================================================
proc ~bitmap { this } {
  UI_PB_debug_DebugMsg "~bitmap $this destroyed"
 }

#=======================================================================
proc setvalue { this OBJ_ATTR } {
  upvar $OBJ_ATTR obj_attr
  set param::bitmap::($this,name)      $obj_attr(0)
  set param::bitmap::($this,type)      $obj_attr(1)
  set param::bitmap::($this,default)   $obj_attr(2)
 }

#=======================================================================
proc readvalue { this OBJ_ATTR } {
  upvar $OBJ_ATTR obj_attr
  set obj_attr(0)  $param::bitmap::($this,name)
  set obj_attr(1)  $param::bitmap::($this,type)
  set obj_attr(2)  $param::bitmap::($this,default)
 }

#=======================================================================
proc setdefvalue { this OBJ_ATTR } {
  upvar $OBJ_ATTR obj_attr
  set param::bitmap::($this,def_name)      $obj_attr(0)
  set param::bitmap::($this,def_type)      $obj_attr(1)
  set param::bitmap::($this,def_default)   $obj_attr(2)
  set param::bitmap::($this,def_value)     [array get obj_attr]
 }

#=======================================================================
proc infoObj { this } {
  UI_PB_debug_ForceMsg_no_trace "\n% % % % %  *** [classof $this] : $this *** "
  UI_PB_debug_ForceMsg_no_trace "  0  name               : $param::bitmap::($this,name)"
  UI_PB_debug_ForceMsg_no_trace "  1  type               : $param::bitmap::($this,type)"
  UI_PB_debug_ForceMsg_no_trace "  2  default            : $param::bitmap::($this,default)"
 }

#=======================================================================
proc diffObj { this {_external 0} } {
  return [PB_mthd_DiffObjWithDefault $this $_external]
 }
}
class group {

#=======================================================================
proc group { this } {
  UI_PB_debug_DebugMsg "group $this constructed"
  set param::group::($this,name) "GROUP"
 }

#=======================================================================
proc ~group  { this } {
  UI_PB_debug_DebugMsg "~group $this destroyed"
 }

#=======================================================================
proc setvalue { this OBJ_ATTR } {
  upvar $OBJ_ATTR obj_attr
  set param::group::($this,name)      $obj_attr(0)
  set param::group::($this,type)      $obj_attr(1)
  set param::group::($this,default)   $obj_attr(2)
  set param::group::($this,ui_label)  $obj_attr(3)
 }

#=======================================================================
proc readvalue { this OBJ_ATTR } {
  upvar $OBJ_ATTR obj_attr
  set obj_attr(0)  $param::group::($this,name)
  set obj_attr(1)  $param::group::($this,type)
  set obj_attr(2)  $param::group::($this,default)
  set obj_attr(3)  $param::group::($this,ui_label)
 }

#=======================================================================
proc setdefvalue { this OBJ_ATTR } {
  upvar $OBJ_ATTR obj_attr
  set param::group::($this,def_name)      $obj_attr(0)
  set param::group::($this,def_type)      $obj_attr(1)
  set param::group::($this,def_default)   $obj_attr(2)
  set param::group::($this,def_ui_label)  $obj_attr(3)
  set param::group::($this,def_value)     [array get obj_attr]
 }

#=======================================================================
proc infoObj { this } {
  UI_PB_debug_ForceMsg_no_trace "\n% % % % %  *** [classof $this] : $this *** "
  UI_PB_debug_ForceMsg_no_trace "  0  name               : $param::group::($this,name)"
  UI_PB_debug_ForceMsg_no_trace "  1  type               : $param::group::($this,type)"
  UI_PB_debug_ForceMsg_no_trace "  2  default            : $param::group::($this,default)"
  UI_PB_debug_ForceMsg_no_trace "  3  ui_label           : $param::group::($this,ui_label)"
 }

#=======================================================================
proc diffObj { this {_external 0} } {
  return [PB_mthd_DiffObjWithDefault $this $_external]
 }
}
class vector {

#=======================================================================
proc vector { this } {
  UI_PB_debug_DebugMsg "vector $this constructed"
  set param::vector::($this,name) "VECTOR"
 }

#=======================================================================
proc ~vector { this } {
  UI_PB_debug_DebugMsg "~point $this destroyed"
 }

#=======================================================================
proc setvalue { this OBJ_ATTR } {
  upvar $OBJ_ATTR obj_attr
  set param::vector::($this,name)      $obj_attr(0)
  set param::vector::($this,type)      $obj_attr(1)
  set param::vector::($this,ui_label)  $obj_attr(2)
  set param::vector::($this,toggle)    $obj_attr(3)
 }

#=======================================================================
proc readvalue { this OBJ_ATTR } {
  upvar $OBJ_ATTR obj_attr
  set obj_attr(0)  $param::vector::($this,name)
  set obj_attr(1)  $param::vector::($this,type)
  set obj_attr(2)  $param::vector::($this,ui_label)
  set obj_attr(3)  $param::vector::($this,toggle)
 }

#=======================================================================
proc setdefvalue { this OBJ_ATTR } {
  upvar $OBJ_ATTR obj_attr
  set param::vector::($this,def_name)      $obj_attr(0)
  set param::vector::($this,def_type)      $obj_attr(1)
  set param::vector::($this,def_ui_label)  $obj_attr(2)
  set param::vector::($this,def_toggle)    $obj_attr(3)
  set param::vector::($this,def_value)     [array get obj_attr]
 }

#=======================================================================
proc infoObj { this } {
  UI_PB_debug_ForceMsg_no_trace "\n% % % % %  *** [classof $this] : $this *** "
  UI_PB_debug_ForceMsg_no_trace "  0  name               : $param::vector::($this,name)"
  UI_PB_debug_ForceMsg_no_trace "  1  type               : $param::vector::($this,type)"
  UI_PB_debug_ForceMsg_no_trace "  2  ui_label           : $param::vector::($this,ui_label)"
  UI_PB_debug_ForceMsg_no_trace "  3  toggle             : $param::vector::($this,toggle)"
 }

#=======================================================================
proc diffObj { this {_external 0} } {
  return [PB_mthd_DiffObjWithDefault $this $_external]
 }
} ;# vector
} ;# param
class ude_event {

#=======================================================================
proc ude_event { this } {
  UI_PB_debug_DebugMsg "ude_event $this constructed"
  set ude_event::($this,name)           "DEFAULT"
  set ude_event::($this,post_event)     ""
  set ude_event::($this,ui_label)       ""
  set ude_event::($this,category)       ""
  set ude_event::($this,param_obj_list) [list]
  set ude_event::($this,help_descript)  ""
  set ude_event::($this,help_url)       ""
  set ude_event::($this,is_dummy)       0
  set ude_event::($this,is_external)    0
 }

#=======================================================================
proc ~ude_event { this } {
  UI_PB_debug_DebugMsg "~ude_event $this destroyed"
 }

#=======================================================================
proc setvalue { this OBJ_ATTR } {
  upvar $OBJ_ATTR obj_attr
  set ude_event::($this,name)           $obj_attr(0)
  set ude_event::($this,post_event)     $obj_attr(1)
  set ude_event::($this,ui_label)       $obj_attr(2)
  set ude_event::($this,category)       $obj_attr(3)
  set ude_event::($this,param_obj_list) $obj_attr(4)
  set ude_event::($this,help_descript)  $obj_attr(5)
  set ude_event::($this,help_url)       $obj_attr(6)
  if { ![info exists obj_attr(7)] } { set obj_attr(7) 0 }
  set ude_event::($this,is_dummy)       $obj_attr(7)
  if { ![info exists obj_attr(8)] } { set obj_attr(8) 0 }
  set ude_event::($this,is_external)    $obj_attr(8)
 }

#=======================================================================
proc readvalue { this OBJ_ATTR } {
  upvar $OBJ_ATTR obj_attr
  set obj_attr(0)  $ude_event::($this,name)
  set obj_attr(1)  $ude_event::($this,post_event)
  set obj_attr(2)  $ude_event::($this,ui_label)
  set obj_attr(3)  $ude_event::($this,category)
  set obj_attr(4)  $ude_event::($this,param_obj_list)
  set obj_attr(5)  $ude_event::($this,help_descript)
  set obj_attr(6)  $ude_event::($this,help_url)
  set obj_attr(7)  $ude_event::($this,is_dummy)
  set obj_attr(8)  $ude_event::($this,is_external)
 }

#=======================================================================
proc setdefvalue { this OBJ_ATTR } {
  upvar $OBJ_ATTR obj_attr
  set ude_event::($this,def_name)           $obj_attr(0)
  set ude_event::($this,def_post_event)     $obj_attr(1)
  set ude_event::($this,def_ui_label)       $obj_attr(2)
  set ude_event::($this,def_category)       $obj_attr(3)
  set ude_event::($this,def_param_obj_list) $obj_attr(4)
  set ude_event::($this,def_help_descript)  $obj_attr(5)
  set ude_event::($this,def_help_url)       $obj_attr(6)
  set ude_event::($this,def_value)          [array get obj_attr]
 }

#=======================================================================
proc askdefvalue { this OBJ_ATTR } {
  upvar $OBJ_ATTR obj_attr
  set obj_attr(0) $ude_event::($this,def_name)
  set obj_attr(1) $ude_event::($this,def_post_event)
  set obj_attr(2) $ude_event::($this,def_ui_label)
  set obj_attr(3) $ude_event::($this,def_category)
  set obj_attr(4) $ude_event::($this,def_param_obj_list)
  set obj_attr(5) $ude_event::($this,def_help_descript)
  set obj_attr(6) $ude_event::($this,def_help_url)
 }

#=======================================================================
proc infoObj { this } {
  if $::gPB(DEBUG) {
   set attr_list { name          \
    post_event    \
    ui_label      \
    category      \
    param_obj_list\
    help_descript \
    help_url      \
    is_dummy      \
   is_external   }
   UI_PB_debug_ForceMsg_no_trace "\n% % % % %  MCE Event $this"
   set i -1
   foreach attr $attr_list {
    UI_PB_debug_ForceMsg_no_trace "  [incr i]  $attr \t\t : $ude_event::($this,$attr)"
   }
  }
 }

#=======================================================================
proc diffObj { this {_external 0} } {
  set _excluded_list { 4 } ;# Exclude param_obj_list
  set status [PB_mthd_DiffObjWithDefault $this $_external $_excluded_list 1]
  if { $status == 0 } {
   foreach param_obj $ude_event::($this,param_obj_list) {
    param::infoObj $param_obj
    if [param::diffObj $param_obj $_external] {
     if { $::gPB(DEBUG) } {
      set status 1
      } else {
      return 1
     }
    }
   }
  }
  return $status
 }
}
class cycle_event {

#=======================================================================
proc cycle_event { this } {
  UI_PB_debug_DebugMsg "cycle_event $this constructed"
  set cycle_event::($this,name)         "DEFAULT"
  set cycle_event::($this,is_dummy)     0
  set cycle_event::($this,is_external)  0
 }

#=======================================================================
proc ~cycle_event  { this } {
  UI_PB_debug_DebugMsg "~cycle_event $this destroyed"
 }

#=======================================================================
proc setvalue { this OBJ_ATTR } {
  upvar $OBJ_ATTR obj_attr
  set cycle_event::($this,name)           $obj_attr(0)
  set cycle_event::($this,is_sys_cycle)   $obj_attr(1)
  set cycle_event::($this,ui_label)       $obj_attr(2)
  set cycle_event::($this,param_obj_list) $obj_attr(4)
  if $::gPB(enable_helpdesc_for_udc) {
   set cycle_event::($this,help_descript)  $obj_attr(5)
   set cycle_event::($this,help_url)       $obj_attr(6)
  }
  set cycle_event::($this,category)       ""
  if ![info exists obj_attr(7)] { set obj_attr(7) 0 }
  set cycle_event::($this,is_dummy)     $obj_attr(7)
  if ![info exists obj_attr(8)] { set obj_attr(8) 0 }
  set cycle_event::($this,is_external)  $obj_attr(8)
 }

#=======================================================================
proc readvalue { this OBJ_ATTR } {
  upvar $OBJ_ATTR obj_attr
  set obj_attr(0)  $cycle_event::($this,name)
  set obj_attr(1)  $cycle_event::($this,is_sys_cycle)
  set obj_attr(2)  $cycle_event::($this,ui_label)
  set obj_attr(3)  $cycle_event::($this,category)
  set obj_attr(4)  $cycle_event::($this,param_obj_list)
  if $::gPB(enable_helpdesc_for_udc) {
   set obj_attr(5)  $cycle_event::($this,help_descript)
   set obj_attr(6)  $cycle_event::($this,help_url)
  }
  set obj_attr(7)  $cycle_event::($this,is_dummy)
  set obj_attr(8)  $cycle_event::($this,is_external)
 }

#=======================================================================
proc setdefvalue { this OBJ_ATTR } {
  upvar $OBJ_ATTR obj_attr
  set cycle_event::($this,def_name)           $obj_attr(0)
  set cycle_event::($this,def_is_sys_cycle)   $obj_attr(1)
  set cycle_event::($this,def_ui_label)       $obj_attr(2)
  set cycle_event::($this,def_param_obj_list) $obj_attr(4)
  if $::gPB(enable_helpdesc_for_udc) {
   set cycle_event::($this,def_help_descript)  $obj_attr(5)
   set cycle_event::($this,def_help_url)       $obj_attr(6)
  }
  if ![info exists obj_attr(3)] { set obj_attr(3) "" }
  set cycle_event::($this,def_value)     [array get obj_attr]
 }

#=======================================================================
proc askdefvalue { this OBJ_ATTR } {
  upvar $OBJ_ATTR obj_attr
  set obj_attr(0) $cycle_event::($this,def_name)
  set obj_attr(1) $cycle_event::($this,def_is_sys_cycle)
  set obj_attr(2) $cycle_event::($this,def_ui_label)
  set obj_attr(3) "" ;# category of MCE
  set obj_attr(4) $cycle_event::($this,def_param_obj_list)
  if { $::gPB(enable_helpdesc_for_udc) } {
   set obj_attr(5) $cycle_event::($this,def_help_descript)
   set obj_attr(6) $cycle_event::($this,def_help_url)
   } else {
   set obj_attr(5) ""
   set obj_attr(6) ""
  }
 }

#=======================================================================
proc infoObj { this } {
  if $::gPB(DEBUG) {
   set attr_list { name          \
    is_sys_cycle  \
    ui_label      \
    category      \
    param_obj_list\
    is_dummy      \
   is_external   }
   UI_PB_debug_ForceMsg_no_trace "\n% % % % %  UDC Event $this"
   set i -1
   foreach attr $attr_list {
    UI_PB_debug_ForceMsg_no_trace "  [incr i]  $attr \t\t : $cycle_event::($this,$attr)"
   }
  }
 }

#=======================================================================
proc diffObj { this {_external 0} } {
  askdefvalue $this obj_attr
  setdefvalue $this obj_attr
  set _excluded_list { 4 } ;# Exclude param_obj_list
  set status [PB_mthd_DiffObjWithDefault $this $_external $_excluded_list 1]
  if { $status == 0 } {
   set param_obj_list [list]
   foreach obj $cycle_event::($this,param_obj_list) {
    if { [lsearch $::gPB(sys_def_param_obj_list) $obj] < 0 } {
     lappend param_obj_list $obj
    }
   }
   foreach param_obj $param_obj_list {
    param::infoObj $param_obj
    if [param::diffObj $param_obj $_external] {
     if { $::gPB(DEBUG) } {
      set status 1
      } else {
      return 1
     }
    }
   }
  }
  return $status
 }
}
class ude {

#=======================================================================
proc ude { this } {
  UI_PB_debug_DebugMsg "ude $this constructed"
  set ude::($this,name)          "DEFAULT"
  set ude::($this,seq_obj)       ""
  set ude::($this,seq_obj_cycle) ""
 }

#=======================================================================
proc ~ude { this } {
  UI_PB_debug_DebugMsg "~ude $this destroyed"
 }

#=======================================================================
proc setvalue { this OBJ_ATTR } {
  upvar $OBJ_ATTR obj_attr
  set ude::($this,name)             $obj_attr(0)
  set ude::($this,event_obj_list)   $obj_attr(1)
  set ude::($this,cyc_evt_obj_list) $obj_attr(2)
 }
}
class File {

#=======================================================================
proc File { this FPointer } {
  UI_PB_debug_DebugMsg "File $this constructed"
  set File::($this,FilePointer) $FPointer
 }

#=======================================================================
proc ~File { this } {
  UI_PB_debug_DebugMsg "~file $this destroyed"
 }

#=======================================================================
proc OpenFileRead { this FName } {
  set File::($this,FileName) $FName
  set FPointer $File::($this,FilePointer)
  if [catch { open "$FName" r } $FPointer] \
  {
   return [tk_messageBox -type ok -icon error -message "$$FPointer"]
  }
  set evalvar "set evelinvar $$FPointer"
  set FpointerAddress [eval $evalvar]
  set File::($this,FilePointer) $FpointerAddress
 }

#=======================================================================
proc OpenFileWrite { this FName } {
  set File::($this,FileName) $FName
  set FPointer $File::($this,FilePointer)
  if [catch {open "$FName" w} $FPointer] \
  {
   return [tk_messageBox -type ok -icon error -message "$$FPointer"]
  }
  set evalvar "set evelinvar $$FPointer"
  set FpointerAddress [eval $evalvar]
  set File::($this,FilePointer) $FpointerAddress
 }

#=======================================================================
proc ResetFilePointer { this } {
  seek $File::($this,FilePointer) 0
 }

#=======================================================================
proc CloseFile { this } {
  close $File::($this,FilePointer)
 }
}
class ParseFile {

#=======================================================================
proc ParseFile { this FPointer } File { $FPointer } {
  UI_PB_debug_DebugMsg "ParseFile $this constructed"
 }

#=======================================================================
proc ~ParseFile { this } {
  UI_PB_debug_DebugMsg "~ParseFile $this destroyed"
 }

#=======================================================================
proc ParsePuiFile { this POST_OBJ } {
  upvar $POST_OBJ post_obj
  if [catch { PB_pui_ReadPuiCreateObjs this post_obj } result] {
   UI_PB_debug_Pause $result
   return TCL_ERROR
  }
 }

#=======================================================================
proc ParseUdeFile { this POST_OBJ } {
  upvar $POST_OBJ post_obj
  PB_ude_UdeInitParse $this post_obj
 }

#=======================================================================
proc ParseDefFile { this file_name } {
  if [catch { PB_mthd_DefFileInitParse $this $file_name } result] {
   UI_PB_debug_ForceMsg $result
   return TCL_ERROR
  }
 }

#=======================================================================
proc ParseWordSep { this } {
  PB_mthd_GetWordSep $this
 }

#=======================================================================
proc ParseEndOfLine { this } {
  PB_mthd_GetEndOfLine $this
 }

#=======================================================================
proc ParseSequence { this } {
  PB_mthd_GetSequenceParams $this
 }

#=======================================================================
proc ParseFormat { this OBJ_LIST } {
  upvar $OBJ_LIST obj_list
  set obj_list $Post::($::post_object,fmt_obj_list)
  PB_fmt_FmtInitParse $this obj_list
 }

#=======================================================================
proc ParseAddress { this POST_OBJ OBJ_LIST LF_OBJ_LIST FOBJ_LIST \
  RAP_ADD_LIST } {
  upvar $POST_OBJ post_obj
  upvar $OBJ_LIST obj_list
  upvar $FOBJ_LIST fobj_list
  upvar $LF_OBJ_LIST lf_obj_list
  upvar $RAP_ADD_LIST rap_add_list
  set obj_list $Post::($post_obj,add_obj_list)
  PB_adr_AdrInitParse $this post_obj obj_list fobj_list
  PB_adr_SepBlkAndLFileAddLists obj_list lf_obj_list
  PB_adr_CreateTextAddObj obj_list fobj_list
  PB_adr_CreateRapidAddresses obj_list rap_add_list
 }

#=======================================================================
proc ParseBlockTemp { this OBJ_LIST ADDOBJ_LIST POST_OBJ } {
  upvar $OBJ_LIST obj_list
  upvar $ADDOBJ_LIST addobj_list
  upvar $POST_OBJ post_obj
  set obj_list $Post::($post_obj,blk_obj_list)
  PB_blk_BlkInitParse $this obj_list addobj_list post_obj
 }
}
class function {

#=======================================================================
proc function { this } {
  UI_PB_debug_DebugMsg "function $this constructed"
  set function::($this,id)                     "Default"
  set function::($this,disp_name)              "Default"
  set function::($this,func_start)             "("
  set function::($this,separator)              ","
  set function::($this,func_end)               ")"
  set function::($this,description)            [list]
  lappend function::($this,description)        "Macro"
  set function::($this,param_list)             [list]
  set function::($this,output_param_name_flag) 0
  set function::($this,output_link_chars) ""
  set function::($this,is_dummy)               0
  set function::($this,is_external)            0
  set function::($this,blk_elem_list)          [list]
 }

#=======================================================================
proc ~function { this } {
  UI_PB_debug_DebugMsg "~function $this destroyed"
  foreach param_obj $function::($this,param_list) \
  {
   PB_com_DeleteObject $param_obj
  }
 }

#=======================================================================
proc setvalue { this OBJ_ATTR } {
  upvar $OBJ_ATTR obj_attr
  if { ![info exists obj_attr(1)] } {
   set obj_attr(1) "New_Macro"
  }
  if { ![info exists obj_attr(2)] } {
   set obj_attr(2) "("
  }
  if { ![info exists obj_attr(3)] } {
   set obj_attr(3) ","
  }
  if { ![info exists obj_attr(4)] } {
   set obj_attr(4) ")"
  }
  if { ![info exists obj_attr(5)] } {
   set obj_attr(5) [list]
   lappend obj_attr(5) "Macro"
  }
  if { ![info exists obj_attr(6)] } {
   set obj_attr(6) [list]
  }
  if { ![info exists obj_attr(7)] } {
   set obj_attr(7) 0
  }
  if { ![info exists obj_attr(8)] } {
   set obj_attr(8) ""
  }
  if { ![info exists obj_attr(9)] } {
   set obj_attr(9) 0
  }
  if { ![info exists obj_attr(10)] } {
   set obj_attr(10) 0
  }
  set function::($this,id)                     $obj_attr(0)
  set function::($this,disp_name)              $obj_attr(1)
  set function::($this,func_start)             $obj_attr(2)
  set function::($this,separator)              $obj_attr(3)
  set function::($this,func_end)               $obj_attr(4)
  set function::($this,description)            $obj_attr(5)
  set function::($this,param_list)             $obj_attr(6)
  set function::($this,output_param_name_flag) $obj_attr(7)
  set function::($this,output_link_chars)      $obj_attr(8)
  set function::($this,is_dummy)               $obj_attr(9)
  set function::($this,is_external)            $obj_attr(10)
 }

#=======================================================================
proc readvalue { this OBJ_ATTR } {
  upvar $OBJ_ATTR obj_attr
  set obj_attr(0)  $function::($this,id)
  set obj_attr(1)  $function::($this,disp_name)
  set obj_attr(2)  $function::($this,func_start)
  set obj_attr(3)  $function::($this,separator)
  set obj_attr(4)  $function::($this,func_end)
  set obj_attr(5)  $function::($this,description)
  set obj_attr(6)  $function::($this,param_list)
  set obj_attr(7)  $function::($this,output_param_name_flag)
  set obj_attr(8)  $function::($this,output_link_chars)
  set obj_attr(9)  $function::($this,is_dummy)
  set obj_attr(10) $function::($this,is_external)
 }

#=======================================================================
proc DefaultValue { this OBJ_ATTR } {
  upvar $OBJ_ATTR obj_attr
  set function::($this,def_value) [array get obj_attr]
  set function::($this,def_param_attr_list) [list]
  foreach param_obj $obj_attr(6) \
  {
   lappend function::($this,def_param_attr_list) \
   $function::param_elem::($param_obj,def_value)
  }
 }

#=======================================================================
proc RestoreValue { this } {
  function::readvalue $this obj_attr
  set function::($this,rest_value) [array get obj_attr]
  set function::($this,rest_param_attr_list) [list]
  foreach param_obj $function::($this,param_list) \
  {
   function::param_elem::RestoreValue $param_obj
   function::param_elem::readvalue    $param_obj param_attr
   lappend function::($this,rest_param_attr_list) [array get param_attr]
  }
 }

#=======================================================================
proc AddToBlkElemList { this BLK_ELEM_OBJ } {
  upvar $BLK_ELEM_OBJ blk_elem_obj
  lappend function::($this,blk_elem_list) $blk_elem_obj
 }

#=======================================================================
proc DeleteFromBlkElemList { this BLK_ELEM_OBJ } {
  upvar $BLK_ELEM_OBJ blk_elem_obj
  if { [info exists function::($this,blk_elem_list)] } \
  {
   set index [lsearch $function::($this,blk_elem_list) $blk_elem_obj]
   if { $index != -1 } \
   {
    set function::($this,blk_elem_list) \
    [lreplace $function::($this,blk_elem_list) $index $index]
   }
  }
 }

#=======================================================================
proc GetParamAttrList { this ATTR_LIST } {
  upvar $ATTR_LIST attr_list
  set attr_list [list]
  set len [llength $function::($this,param_list)]
  if { $len == 0 } \
  {
   return
  }
  set last_index 0
  set num 0
  foreach param_obj $function::($this,param_list) \
  {
   incr num
   set sub_list [list]
   set exp_str $function::param_elem::($param_obj,exp)
   PB_com_RemoveBlanks exp_str
   if { $function::param_elem::($param_obj,name) != "" } \
   {
    if { $exp_str == "" } \
    {
     lappend attr_list $sub_list
     continue
    }
    if { [string compare $function::param_elem::($param_obj,dtype) "Numeral"] == 0 } \
    {
     lappend sub_list $function::param_elem::($param_obj,exp)
     lappend sub_list 1
     lappend sub_list $function::param_elem::($param_obj,fraction)
     lappend sub_list $function::param_elem::($param_obj,integer)
     lappend sub_list $function::param_elem::($param_obj,decimal)
     if { $function::param_elem::($param_obj,decimal) } \
     {
      lappend sub_list 1 ;# doulbe type data
      set total_width [expr $function::param_elem::($param_obj,integer) + \
      $function::param_elem::($param_obj,fraction)]
      lappend sub_list $total_width
      lappend sub_list $function::param_elem::($param_obj,fraction)
     } else \
     {
      lappend sub_list 0 ;# int type data
      lappend sub_list $function::param_elem::($param_obj,integer)
     }
    } else \
    {
     set txt_exp $function::param_elem::($param_obj,exp)
     set txt_exp [PB_output_EscapeSpecialControlChar_no_dollar $txt_exp]
     lappend sub_list $txt_exp
     lappend sub_list 0
    }
    if $function::($this,output_param_name_flag) \
    {
     lappend sub_list $function::param_elem::($param_obj,name)
    }
    set last_index $num
    } elseif { ![string match "" $exp_str] && ![string match "*\$*" $exp_str] } \
   {
    lappend sub_list $function::param_elem::($param_obj,exp)
    lappend sub_list 0
    if $function::($this,output_param_name_flag) \
    {
     lappend sub_list ""
    }
    set last_index $num
   }
   lappend attr_list $sub_list
  }
  if { $last_index < $len } \
  {
   set attr_list [lreplace $attr_list $last_index end]
  }
 }

#=======================================================================
proc GetDisplayText { this DIS_TEXT } {
  upvar $DIS_TEXT dis_text
  set dis_text ""
  append dis_text $function::($this,disp_name) $function::($this,func_start)
  set param_list $function::($this,param_list)
  set len [llength $param_list]
  if { $len > 0 } \
  {
   set param_text_list [list]
   set separator_char $function::($this,separator)
   set last_index 0
   set num 0
   foreach param_obj $param_list \
   {
    incr num
    set param_name $function::param_elem::($param_obj,name)
    set exp_str $function::param_elem::($param_obj,exp)
    PB_com_RemoveBlanks exp_str
    if { $param_name != "" } \
    {
     if { $exp_str == "" } \
     {
      set param_name ""
     } else \
     {
      if { $function::($this,output_param_name_flag) } \
      {
       append param_name $function::($this,output_link_chars)
      }
      set last_index $num
     }
     } elseif { ![string match "" $exp_str] && \
    ![string match "*\$*" $exp_str] } \
    {
     set param_name $exp_str
     set last_index $num
    }
    lappend param_text_list $param_name
   }
   if { $last_index < $len } \
   {
    set param_text_list [lreplace $param_text_list $last_index end]
   }
   append dis_text [join $param_text_list $separator_char]
  }
  append dis_text $function::($this,func_end)
 }

#=======================================================================
proc infoObj { this } {
  if $::gPB(DEBUG) {
   UI_PB_debug_ForceMsg_no_trace "\n% % % % %  *** [classof $this] : $this *** "
   UI_PB_debug_ForceMsg_no_trace "  0  id                      : $function::($this,id)"
   UI_PB_debug_ForceMsg_no_trace "  1  disp_name               : $function::($this,disp_name)"
   UI_PB_debug_ForceMsg_no_trace "  2  func_start              : $function::($this,func_start)"
   UI_PB_debug_ForceMsg_no_trace "  3  separator               : $function::($this,separator)"
   UI_PB_debug_ForceMsg_no_trace "  4  func_end                : $function::($this,func_end)"
   UI_PB_debug_ForceMsg_no_trace "  5  description             : $function::($this,description)"
   UI_PB_debug_ForceMsg_no_trace "  6  param_list              : $function::($this,param_list)"
   UI_PB_debug_ForceMsg_no_trace "  7  output_param_name_flag  : $function::($this,output_param_name_flag)"
   UI_PB_debug_ForceMsg_no_trace "  8  output_link_chars       : $function::($this,output_link_chars)"
   UI_PB_debug_ForceMsg_no_trace "  9  is_dummy                : $function::($this,is_dummy)"
   UI_PB_debug_ForceMsg_no_trace "  10 is_external             : $function::($this,is_external)"
   UI_PB_debug_ForceMsg_no_trace "  def_param_attr_list        : $function::($this,def_param_attr_list)"
  }
 }

#=======================================================================
proc diffObj { this {_external 0} } {
  set _excluded_list { 6 } ;# Exclude param elems
  set status [PB_mthd_DiffObjWithDefault $this $_external $_excluded_list 1]
  if { $status == 0 } {
   foreach param_elem_obj $function::($this,param_list) {
    function::param_elem::infoObj $param_elem_obj
    if [function::param_elem::diffObj $param_elem_obj $_external] {
     if { $::gPB(DEBUG) } {
      set status 1
      } else {
      return 1
     }
    }
   }
  }
  return $status
 }
 class param_elem {

#=======================================================================
proc param_elem { this } {
  UI_PB_debug_DebugMsg "param_elem $this constructed"
  set function::param_elem::($this,name)     ""
  set function::param_elem::($this,exp)      ""
  set function::param_elem::($this,dtype)    "Numeral"
  set function::param_elem::($this,integer)  2
  set function::param_elem::($this,decimal)  1
  set function::param_elem::($this,fraction) 4
 }

#=======================================================================
proc ~param_elem { this } {
  UI_PB_debug_DebugMsg "param_elem $this destroyed"
 }

#=======================================================================
proc setvalue { this OBJ_ATTR } {
  upvar $OBJ_ATTR obj_attr
  set function::param_elem::($this,name)     $obj_attr(0)
  set function::param_elem::($this,exp)      $obj_attr(1)
  set function::param_elem::($this,dtype)    $obj_attr(2)
  set function::param_elem::($this,integer)  $obj_attr(3)
  set function::param_elem::($this,decimal)  $obj_attr(4)
  set function::param_elem::($this,fraction) $obj_attr(5)
 }

#=======================================================================
proc readvalue { this OBJ_ATTR } {
  upvar $OBJ_ATTR obj_attr
  set obj_attr(0) $function::param_elem::($this,name)
  set obj_attr(1) $function::param_elem::($this,exp)
  set obj_attr(2) $function::param_elem::($this,dtype)
  set obj_attr(3) $function::param_elem::($this,integer)
  set obj_attr(4) $function::param_elem::($this,decimal)
  set obj_attr(5) $function::param_elem::($this,fraction)
 }

#=======================================================================
proc DefaultValue { this OBJ_ATTR } {
  upvar $OBJ_ATTR obj_attr
  set function::param_elem::($this,def_value) [array get obj_attr]
 }

#=======================================================================
proc RestoreValue { this } {
  function::param_elem::readvalue $this obj_attr
  set function::param_elem::($this,rest_value) [array get obj_attr]
 }

#=======================================================================
proc infoObj { this } {
  if $::gPB(DEBUG) {
   UI_PB_debug_ForceMsg_no_trace "\n% % % % %  *** [classof $this] : $this *** "
   UI_PB_debug_ForceMsg_no_trace "  0  name       : $function::param_elem::($this,name)"
   UI_PB_debug_ForceMsg_no_trace "  1  exp        : $function::param_elem::($this,exp)"
   UI_PB_debug_ForceMsg_no_trace "  2  dtype      : $function::param_elem::($this,dtype)"
   UI_PB_debug_ForceMsg_no_trace "  3  integer    : $function::param_elem::($this,integer)"
   UI_PB_debug_ForceMsg_no_trace "  4  decimal    : $function::param_elem::($this,decimal)"
   UI_PB_debug_ForceMsg_no_trace "  5  fraction   : $function::param_elem::($this,fraction)"
  }
 }

#=======================================================================
proc diffObj { this {_external 0} } {
  return [PB_mthd_DiffObjWithDefault $this $_external]
 }
}
}
