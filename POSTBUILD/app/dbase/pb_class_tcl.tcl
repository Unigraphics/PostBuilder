#9
class format {

#=======================================================================
proc format {this} {
  UI_PB_debug_DebugMsg "format $this constructed"
  set format::($this,for_name) "DEFAULT"
  set format::($this,for_dtype) ""
  set format::($this,for_leadplus) 0
  set format::($this,for_leadzero) 0
  set format::($this,for_trailzero) 0
  set format::($this,for_valfpart) 0
  set format::($this,for_outdecimal) 0
  set format::($this,for_valspart) 0
  set format::($this,fmt_addr_list) [list]
 }

#=======================================================================
proc ~format {this} {
  UI_PB_debug_DebugMsg "~format $this destroyed"
 }

#=======================================================================
proc setvalue {this OBJ_ATTR} {
  upvar $OBJ_ATTR obj_attr
  set format::($this,for_name)       $obj_attr(0)
  set format::($this,for_dtype)      $obj_attr(1)
  set format::($this,for_leadplus)   $obj_attr(2)
  set format::($this,for_leadzero)   $obj_attr(3)
  set format::($this,for_trailzero)  $obj_attr(4)
  set format::($this,for_valfpart)   $obj_attr(5)
  set format::($this,for_outdecimal) $obj_attr(6)
  set format::($this,for_valspart)   $obj_attr(7)
 }

#=======================================================================
proc readvalue {this OBJ_ATTR} {
  upvar $OBJ_ATTR obj_attr
  set obj_attr(0) $format::($this,for_name)
  set obj_attr(1) $format::($this,for_dtype)
  set obj_attr(2) $format::($this,for_leadplus)
  set obj_attr(3) $format::($this,for_leadzero)
  set obj_attr(4) $format::($this,for_trailzero)
  set obj_attr(5) $format::($this,for_valfpart)
  set obj_attr(6) $format::($this,for_outdecimal)
  set obj_attr(7) $format::($this,for_valspart)
 }

#=======================================================================
proc DefaultValue {this OBJ_ATTR} {
  upvar $OBJ_ATTR obj_attr
  set def_value [array get obj_attr]
  set format::($this,def_value) $def_value
 }

#=======================================================================
proc AddToAddressList {this ADDR_OBJ} {
  upvar $ADDR_OBJ addr_obj
  if { $addr_obj != "" } \
  {
   lappend format::($this,fmt_addr_list) $addr_obj
  }
 }

#=======================================================================
proc DeleteFromAddressList {this ADDR_OBJ} {
  upvar $ADDR_OBJ addr_obj
  if { [info exists format::($this,fmt_addr_list)] } \
  {
   set index [lsearch $format::($this,fmt_addr_list) \
   $addr_obj]
   if {$index != -1} \
   {
    set format::($this,fmt_addr_list) \
    [lreplace $format::($this,fmt_addr_list) $index $index]
   }
  }
 }
}
class address {

#=======================================================================
proc address {this} {
  UI_PB_debug_DebugMsg "address $this constructed"
  set address::($this,add_name) "DEFAULT"
  set address::($this,add_format) ""
  set address::($this,add_force) ""
  set address::($this,add_force_status) ""
  set address::($this,add_max) ""
  set address::($this,add_max_status) ""
  set address::($this,add_min) ""
  set address::($this,add_min_status) ""
  set address::($this,add_leader) ""
  set address::($this,add_trailer) ""
  set address::($this,add_trailer_status) ""
  set address::($this,add_incremental) ""
  set address::($this,add_zerofmt) ""
  set address::($this,add_zerofmt_name) ""
  set address::($this,obj_attr_cnt) 14
  set address::($this,rep_mom_var) ""
  set address::($this,word_status) ""
  set address::($this,word_desc) ""
  set address::($this,seq_no) 0
  set address::($this,blk_elem_list) [list]
  set address::($this,leader_var) ""
  set address::($this,rename_flag) 1
  set address::($this,rest_mseq_attr) [list]
  set address::($this,undo_mseq_attr) [list]
  set address::($this,divi_dim) ""
  set address::($this,divi_id) ""
  set address::($this,rect_dim) ""
  set address::($this,rect_id) ""
  set address::($this,image_id) ""
  set address::($this,icon_id) ""
  set address::($this,xc) ""
  set address::($this,yc) ""
 }

#=======================================================================
proc ~address {this} {
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
proc setvalue {this OBJ_ATTR} {
  upvar $OBJ_ATTR obj_attr
  set address::($this,add_name)           $obj_attr(0)
  set address::($this,add_format)         $obj_attr(1)
  set address::($this,add_force)          $obj_attr(2)
  set address::($this,add_force_status)   $obj_attr(3)
  set address::($this,add_max)            $obj_attr(4)
  set address::($this,add_max_status)     $obj_attr(5)
  set address::($this,add_min)            $obj_attr(6)
  set address::($this,add_min_status)     $obj_attr(7)
  set address::($this,add_leader)         $obj_attr(8)
  set address::($this,add_trailer)        $obj_attr(9)
  set address::($this,add_trailer_status) $obj_attr(10)
  set address::($this,add_incremental)    $obj_attr(11)
  set address::($this,add_zerofmt)        $obj_attr(12)
  if [info exists obj_attr(13)] {
   set address::($this,add_zerofmt_name) $obj_attr(13)
   } else {
   set address::($this,add_zerofmt_name) ""
  }
 }

#=======================================================================
proc readvalue {this OBJ_ATTR} {
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
 }

#=======================================================================
proc DefaultValue {this OBJ_ATTR} {
  upvar $OBJ_ATTR obj_attr
  set def_value [array get obj_attr]
  set address::($this,def_value) $def_value
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
proc DefaultMseqAttr {this MSEQ_ATTR} {
  upvar $MSEQ_ATTR mseq_attr
  set def_value [array get mseq_attr]
  set address::($this,def_mseq_attr) $def_value
 }

#=======================================================================
proc RestoreMseqAttr {this} {
  address::readMseqAttr $this mseq_attr
  set rest_value [array get mseq_attr]
  set address::($this,rest_mseq_attr) $rest_value
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
proc AddToBlkElemList {this BLK_ELEM_OBJ} {
  upvar $BLK_ELEM_OBJ blk_elem_obj
  lappend address::($this,blk_elem_list) $blk_elem_obj
 }

#=======================================================================
proc DeleteFromBlkElemList {this BLK_ELEM_OBJ} {
  upvar $BLK_ELEM_OBJ blk_elem_obj
  if { [info exists address::($this,blk_elem_list)] } \
  {
   set index [lsearch $address::($this,blk_elem_list) \
   $blk_elem_obj]
   if {$index != -1} \
   {
    set address::($this,blk_elem_list) \
    [lreplace $address::($this,blk_elem_list) $index $index]
   }
  }
 }
}
class Post {

#=======================================================================
proc Post {this post_name} {
  UI_PB_debug_DebugMsg "Post $this constructed"
  set Post::($this,post_name) $post_name
  set Post::($this,tcl_file_read) FALSE
  set Post::($this,def_file_read) FALSE
  set Post::($this,pui_dir)       ""
  set Post::($this,def_file)      ""
  set Post::($this,tcl_file)      ""
  set Post::($this,output_dir)    ""
  set Post::($this,out_pui_file)  ""
  set Post::($this,out_def_file)  ""
  set Post::($this,out_tcl_file)  ""
  set Post::($this,comment_blk_list) [list]
  set Post::($this,cmd_blk_list)     [list]
  set Post::($this,fmt_obj_list)     [list]
  set Post::($this,add_obj_list)     [list]
  set Post::($this,blk_obj_list)     [list]
  set Post::($this,g_codes)          [list]
  set Post::($this,g_codes_desc)     [list]
  set Post::($this,m_codes)          [list]
  set Post::($this,m_codes_desc)     [list]
  set Post::($this,msq_word_param)   [list]
  set Post::($this,msq_add_name)     [list]
  set Post::($this,def_mast_seq)     [list]
  set Post::($this,machine_tool)     [list]
  set Post::($this,list_obj_list)    [list]
  set Post::($this,rap_add_list)     [list]
  set Post::($this,seq_obj_list)     [list]
  set Post::($this,event_procs)      [list]
  set Post::($this,word_desc_array)  [list]
  set Post::($this,word_mom_var)     [list]
  set Post::($this,mom_sys_var_list) [list]
  set Post::($this,mom_sim_var_list) [list]
  set Post::($this,add_name_list)    [list]
 }

#=======================================================================
proc ~Post {this} {
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
  set pui_dir $Post::($this,pui_dir)
  set def_file $Post::($this,def_file)
  set tcl_file $Post::($this,tcl_file)
 }

#=======================================================================
proc SetPostOutputFiles { this DIR PUI_FILE DEF_FILE TCL_FILE } {
  upvar $DIR dir
  upvar $PUI_FILE pui_file
  upvar $DEF_FILE def_file
  upvar $TCL_FILE tcl_file
  set Post::($this,output_dir) $dir
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
  set dir $Post::($this,output_dir)
  set pui_file $Post::($this,out_pui_file)
  set def_file $Post::($this,out_def_file)
  set tcl_file $Post::($this,out_tcl_file)
 }

#=======================================================================
proc InitG-Codes {this G_CODES G_CODES_DESC} {
  upvar $G_CODES g_codes
  upvar $G_CODES_DESC g_codes_desc
  set temp_g_codes [array get g_codes]
  set temp_g_codes_desc [array get g_codes_desc]
  set Post::($this,g_codes) $temp_g_codes
  set Post::($this,g_codes_desc) $temp_g_codes_desc
 }

#=======================================================================
proc InitM-Codes {this M_CODES M_CODES_DESC} {
  upvar $M_CODES m_codes
  upvar $M_CODES_DESC m_codes_desc
  set temp_m_codes [array get m_codes]
  set temp_m_codes_desc [array get m_codes_desc]
  set Post::($this,m_codes) $temp_m_codes
  set Post::($this,m_codes_desc) $temp_m_codes_desc
 }

#=======================================================================
proc InitMasterSequence { this MSQ_ADD_NAME MSQ_WORD_PARAM } {
  upvar $MSQ_ADD_NAME msq_add_name
  upvar $MSQ_WORD_PARAM msq_word_param
  set temp_msq_word_param  [array get msq_word_param]
  set Post::($this,msq_word_param)  $temp_msq_word_param
  set Post::($this,msq_add_name) $msq_add_name
 }

#=======================================================================
proc SetDefMasterSequence {this ADD_OBJ_LIST} {
  upvar $ADD_OBJ_LIST add_obj_list
  set Post::($this,def_mast_seq) $add_obj_list
 }

#=======================================================================
proc MachineTool {this machine_tool} {
  upvar $machine_tool mtool
  set Post::($this,machine_tool) $mtool
 }

#=======================================================================
proc ListFileObject {this LIST_OBJ_LIST} {
  upvar $LIST_OBJ_LIST obj_list
  set Post::($this,list_obj_list) $obj_list
 }

#=======================================================================
proc SetObjListasAttr {this OBJ_LIST} {
  upvar $OBJ_LIST obj_list
  set object [lindex $obj_list 0]
  set ClassName [string trim [classof $object] ::]
  switch $ClassName\
  {
   format    {set Post::($this,fmt_obj_list)     $obj_list}
   address   {set Post::($this,add_obj_list)     $obj_list}
   block     {set Post::($this,blk_obj_list)     $obj_list}
   command   {set Post::($this,cmd_blk_list)     $obj_list}
   comment   {set Post::($this,comment_blk_list) $obj_list}
   event     {set Post::($this,event_procs)      $obj_list}
   sequence  {set Post::($this,seq_obj_list)     $obj_list}
  }
 }

#=======================================================================
proc GetObjList {this class OBJ_LIST} {
  upvar $OBJ_LIST obj_list
  switch $class\
  {
   format    {set obj_list $Post::($this,fmt_obj_list)}
   address   {set obj_list $Post::($this,add_obj_list)}
   block     {set obj_list $Post::($this,blk_obj_list)}
   command   {set obj_list $Post::($this,cmd_blk_list)}
   comment   {set obj_list $Post::($this,comment_blk_list)}
   event     {set obj_list $Post::($this,event_procs)}
   sequence  {set obj_list $Post::($this,seq_obj_list)}
  }
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
 if 0 {

#=======================================================================
proc SetCmdBlkObj { this CMD_BLK_LIST } {
  upvar $CMD_BLK_LIST cmd_blk_list
  set Post::($this,cmd_blk_list) $cmd_blk_list
 }

#=======================================================================
proc GetCmdBlkObj { this CMD_BLK_LIST } {
  upvar $CMD_BLK_LIST cmd_blk_list
  if [info exists Post::($this,cmd_blk_list)] {
   set cmd_blk_list $Post::($this,cmd_blk_list)
  }
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
proc WordAddNamesSubNamesDesc {this} {
  set msq_add_name $Post::($this,msq_add_name)
  set Post::($this,word_name_list) $msq_add_name
  PB_com_WordSubNamesDesc this word_subnames_desc_array word_mom_var \
  mom_sys_arr
  set word_subnames_desc_list [array get word_subnames_desc_array]
  set word_mom_var_list [array get word_mom_var]
  set mom_sys_var_list [array get mom_sys_arr]
  set Post::($this,word_desc_array) $word_subnames_desc_list
  set Post::($this,word_mom_var) $word_mom_var_list
  set Post::($this,mom_sys_var_list) $mom_sys_var_list
 }
}
class block_element {

#=======================================================================
proc block_element {this block_name} {
  UI_PB_debug_DebugMsg "block_element $this constructed"
  set block_element::($this,parent_name) $block_name
  set block_element::($this,elem_add_obj) ""
  set block_element::($this,elem_mom_variable) ""
  set block_element::($this,elem_opt_nows_var) ""
  set block_element::($this,elem_desc) ""
  set block_element::($this,force) 0
  set block_element::($this,owner) "NONE"
  set block_element::($this,rest_value) [list]
  set block_element::($this,undo_value) [list]
  set block_element::($this,div_corn_x0) ""
  set block_element::($this,div_corn_y0) ""
  set block_element::($this,div_corn_x1) ""
  set block_element::($this,div_corn_y1) ""
  set block_element::($this,div_id) ""
  set block_element::($this,rect_corn_x0) ""
  set block_element::($this,rect_corn_y0) ""
  set block_element::($this,rect_corn_x1) ""
  set block_element::($this,rect_corn_y1) ""
  set block_element::($this,rect) ""
  set block_element::($this,blk_img) ""
  set block_element::($this,icon_id) ""
  set block_element::($this,xc) ""
  set block_element::($this,yc) ""
 }

#=======================================================================
proc ~block_element {this} {
  UI_PB_debug_DebugMsg "~block_element $this destroyed"
  if { $block_element::($this,elem_add_obj) == "Command" } \
  {
   set cmd_obj $block_element::($this,elem_mom_variable)
   if { [string match "*MOM_*" $cmd_obj] == 0} \
   {
    command::DeleteFromBlkElemList $cmd_obj this
    command::DeleteFromBlkElemList $cmd_obj this
   }
  } else \
  {
   set add_obj $block_element::($this,elem_add_obj)
   address::DeleteFromBlkElemList $add_obj this
   array set def_obj_attr $block_element::($this,def_value)
   address::DeleteFromBlkElemList $def_obj_attr(0) this
  }
 }

#=======================================================================
proc setvalue {this OBJ_ATTR} {
  upvar $OBJ_ATTR obj_attr
  set block_element::($this,elem_add_obj)      $obj_attr(0)
  set block_element::($this,elem_mom_variable) $obj_attr(1)
  set block_element::($this,elem_opt_nows_var) $obj_attr(2)
  set block_element::($this,elem_desc)         $obj_attr(3)
  set block_element::($this,force)             $obj_attr(4)
 }

#=======================================================================
proc readvalue {this OBJ_ATTR} {
  upvar $OBJ_ATTR obj_attr
  set obj_attr(0) $block_element::($this,elem_add_obj)
  set obj_attr(1) $block_element::($this,elem_mom_variable)
  set obj_attr(2) $block_element::($this,elem_opt_nows_var)
  set obj_attr(3) $block_element::($this,elem_desc)
  set obj_attr(4) $block_element::($this,force)
 }

#=======================================================================
proc DefaultValue {this OBJ_ATTR} {
  upvar $OBJ_ATTR obj_attr
  set def_value [array get obj_attr]
  set block_element::($this,def_value) $def_value
 }

#=======================================================================
proc RestoreValue {this} {
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
}
class command {

#=======================================================================
proc command {this} {
  UI_PB_debug_DebugMsg "command $this constructed"
  set command::($this,name) "Default"
  set command::($this,proc) ""
  set command::($this,description) ""
  set command::($this,blk_list) [list]
  set command::($this,add_list) [list]
  set command::($this,fmt_list) [list]
  set command::($this,blk_elem_list) [list]
 }

#=======================================================================
proc ~command {this} {
  UI_PB_debug_DebugMsg "~command $this destroyed"
 }

#=======================================================================
proc setvalue {this OBJ_ATTR} {
  upvar $OBJ_ATTR obj_attr
  set command::($this,name) $obj_attr(0)
  set command::($this,proc) $obj_attr(1)
  if { ![info exists obj_attr(2)] } {
   set obj_attr(2) [list]
  }
  set command::($this,blk_list) $obj_attr(2)
  if { ![info exists obj_attr(3)] } {
   set obj_attr(3) [list]
  }
  set command::($this,add_list) $obj_attr(3)
  if { ![info exists obj_attr(4)] } {
   set obj_attr(4) [list]
  }
  set command::($this,fmt_list) $obj_attr(4)
  if {![info exists obj_attr(5)]} {
   set obj_attr(5) ""
  }
  set command::($this,description) $obj_attr(5)
 }

#=======================================================================
proc readvalue {this OBJ_ATTR} {
  upvar $OBJ_ATTR obj_attr
  set obj_attr(0) $command::($this,name)
  set obj_attr(1) $command::($this,proc)
  set obj_attr(2) $command::($this,blk_list)
  set obj_attr(3) $command::($this,add_list)
  set obj_attr(4) $command::($this,fmt_list)
  set obj_attr(5) $command::($this,description)
 }

#=======================================================================
proc DefaultValue {this OBJ_ATTR} {
  upvar $OBJ_ATTR obj_attr
  set command::($this,def_value) [array get obj_attr]
 }

#=======================================================================
proc RestoreValue {this} {
  command::readvalue $this obj_attr
  set command::($this,rest_value) [array get obj_attr]
 }

#=======================================================================
proc AddToBlkElemList {this BLK_ELEM_OBJ} {
  upvar $BLK_ELEM_OBJ blk_elem_obj
  lappend command::($this,blk_elem_list) $blk_elem_obj
 }

#=======================================================================
proc DeleteFromBlkElemList {this BLK_ELEM_OBJ} {
  upvar $BLK_ELEM_OBJ blk_elem_obj
  if { [info exists command::($this,blk_elem_list)] } \
  {
   if 0 {
    set command::($this,blk_elem_list) [ltidy $command::($this,blk_elem_list)]
   }
   set index [lsearch $command::($this,blk_elem_list) \
   $blk_elem_obj]
   if {$index != -1} \
   {
    set command::($this,blk_elem_list) \
    [lreplace $command::($this,blk_elem_list) $index $index]
   }
  }
 }
}
class block {

#=======================================================================
proc block {this} {
  UI_PB_debug_DebugMsg "block $this constructed"
  set block::($this,block_name) "DEFAULT"
  set block::($this,block_nof_elements) 0
  set block::($this,elem_addr_list) [list]
  set block::($this,blk_type) ""
  set block::($this,blk_owner) "NONE"
  set block::($this,evt_elem_list) [list]
  set block::($this,rest_value) [list]
  set block::($this,undo_value) [list]
  set block::($this,rect) ""
  set block::($this,rect_x0) ""
  set block::($this,rect_y0) ""
  set block::($this,rect_x1) ""
  set block::($this,rect_y1) ""
  set block::($this,blk_h) ""
  set block::($this,blk_w) ""
  set block::($this,div_id) ""
  set block::($this,div_corn_x0) ""
  set block::($this,div_corn_y0) ""
  set block::($this,div_corn_x1) ""
  set block::($this,div_corn_y1) ""
  set block::($this,active_blk_elem_list) ""
  set block::($this,sep_id) ""
 }

#=======================================================================
proc ~block {this} {
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
    if { [lsearch $block::($this,elem_addr_list) $act_elem] == -1 \
    && [lsearch $obj_attr(2) $act_elem] == -1 } \
    {
     PB_com_DeleteObject $act_elem
    }
   }
  }
  if 0 {
   foreach e $block::($this,evt_elem_list) {
    delete $e
   }
   global post_object
   Post::GetObjList $post_object block blk_obj_list
   set idx [lsearch $blk_obj_list $this]
   if { $idx >= 0 } {
    set blk_obj_list [lreplace $blk_obj_list $idx $idx]
    Post::SetObjListasAttr $post_object blk_obj_list
   }
  }
 }

#=======================================================================
proc setvalue {this OBJ_ATTR} {
  upvar $OBJ_ATTR obj_attr
  set block::($this,block_name)         $obj_attr(0)
  set block::($this,block_nof_elements) $obj_attr(1)
  set block::($this,elem_addr_list)     $obj_attr(2)
  set block::($this,blk_type)           $obj_attr(3)
 }

#=======================================================================
proc readvalue {this OBJ_ATTR} {
  upvar $OBJ_ATTR obj_attr
  set obj_attr(0) $block::($this,block_name)
  set obj_attr(1) $block::($this,block_nof_elements)
  set obj_attr(2) $block::($this,elem_addr_list)
  set obj_attr(3) $block::($this,blk_type)
 }

#=======================================================================
proc DefaultValue {this OBJ_ATTR} {
  upvar $OBJ_ATTR obj_attr
  set def_value [array get obj_attr]
  set block::($this,def_value) $def_value
 }

#=======================================================================
proc RestoreValue {this} {
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
proc AddToEventElemList {this EVENT_ELEM_OBJ} {
  upvar $EVENT_ELEM_OBJ event_elem_obj
  lappend block::($this,evt_elem_list) $event_elem_obj
 }

#=======================================================================
proc DeleteFromEventElemList {this EVENT_ELEM_OBJ} {
  upvar $EVENT_ELEM_OBJ event_elem_obj
  if { [info exists block::($this,evt_elem_list)] } \
  {
   set index [lsearch $block::($this,evt_elem_list) \
   $event_elem_obj]
   if {$index != -1} \
   {
    set block::($this,evt_elem_list) \
    [lreplace $block::($this,evt_elem_list) $index $index]
   }
  }
 }
}
class event_element {

#=======================================================================
proc event_element {this} {
  UI_PB_debug_DebugMsg "event_element $this constructed"
  set event_element::($this,evt_elem_name) "DEFAULT"
  set event_element::($this,block_obj) ""
  set event_element::($this,event_obj) ""
  set event_element::($this,xc) ""
  set event_element::($this,yc) ""
  set event_element::($this,line_id) ""
  set event_element::($this,rect_id) ""
  set event_element::($this,icon_id) ""
  set event_element::($this,text_id) ""
 }

#=======================================================================
proc ~event_element {this} {
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
proc setvalue {this OBJ_ATTR} {
  upvar $OBJ_ATTR obj_attr
  set event_element::($this,evt_elem_name) $obj_attr(0)
  set event_element::($this,block_obj) $obj_attr(1)
 }

#=======================================================================
proc readvalue {this OBJ_ATTR} {
  upvar $OBJ_ATTR obj_attr
  set obj_attr(0) $event_element::($this,evt_elem_name)
  set obj_attr(1) $event_element::($this,block_obj)
 }

#=======================================================================
proc DefaultValue {this OBJ_ATTR} {
  upvar $OBJ_ATTR obj_attr
  set def_value [array get obj_attr]
  set event_element::($this,def_value) $def_value
 }

#=======================================================================
proc RestoreValue {this} {
  event_element::readvalue $this obj_attr
  set event_element::($this,rest_value) [array get obj_attr]
 }
}
class event {

#=======================================================================
proc event {this} {
  UI_PB_debug_DebugMsg "event $this constructed"
  set event::($this,event_name) "DEFAULT"
  set event::($this,block_nof_rows) ""
  set event::($this,evt_elem_list) ""
  set event::($this,cycle_rapid_to)   ""
  set event::($this,cycle_retract_to) ""
  set event::($this,cycle_start_blk) ""
  set event::($this,cycle_plane_control) ""
  set event::($this,evt_itm_obj_list) ""
  set event::($this,rest_value) [list]
  set event::($this,undo_value) [list]
  set event::($this,event_open) 0
  set event::($this,event_height) ""
  set event::($this,event_width) ""
  set event::($this,xc) ""
  set event::($this,yc) ""
  set event::($this,sep_id) ""
  set event::($this,col_image) ""
  set event::($this,col_icon_id) ""
  set event::($this,blk_text) ""
  set event::($this,blk_rect) ""
  set event::($this,evt_rect) ""
  set event::($this,icon_id) ""
  set event::($this,text_id) ""
  set event::($this,rect_id) ""
  set event::($this,extra_lines) ""
  set event::($this,canvas_flag) 1
 }

#=======================================================================
proc ~event {this} {
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
     if { [lsearch $act_row_list $evt_elem] != -1} \
     {
      set delete_flag 1
      break
     }
    }
    if { $delete_flag == 0} \
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
 }

#=======================================================================
proc setvalue {this OBJ_ATTR} {
  upvar $OBJ_ATTR obj_attr
  set event::($this,event_name)          $obj_attr(0)
  set event::($this,block_nof_rows)      [llength $obj_attr(2)]
  set event::($this,evt_elem_list)       $obj_attr(2)
  set event::($this,evt_itm_obj_list)    $obj_attr(3)
  set event::($this,event_label)         $obj_attr(4)
 }

#=======================================================================
proc readvalue {this OBJ_ATTR} {
  upvar $OBJ_ATTR obj_attr
  set obj_attr(0) $event::($this,event_name)
  set obj_attr(1) [llength $event::($this,evt_elem_list)]
  set obj_attr(2) $event::($this,evt_elem_list)
  set obj_attr(3) $event::($this,evt_itm_obj_list)
  set obj_attr(4) $event::($this,event_label)
 }
 if 0 {

#=======================================================================
proc DefaultValue {this OBJ_ATTR} {
  upvar $OBJ_ATTR obj_attr
  set def_value [array get obj_attr]
  set event::($this,def_value) $def_value
 }
}

#=======================================================================
proc DefaultValue {this args} {
  if [llength $args] {
   upvar [lindex $args 0] obj_attr
   } else {
   readvalue $this obj_attr
  }
  set def_value [array get obj_attr]
  set event::($this,def_value) $def_value
 }

#=======================================================================
proc RestoreValue {this} {
  event::readvalue $this obj_attr
  set event::($this,rest_value) [array get obj_attr]
 }
}
class sequence {

#=======================================================================
proc sequence {this} {
  UI_PB_debug_DebugMsg "sequence $this constructed"
  set sequence::($this,seq_name) "DEFAULT"
  set sequence::($this,comb_var) ""
  set sequence::($this,rest_value) [list]
  set sequence::($this,undo_value) [list]
 }

#=======================================================================
proc ~sequence {this} {
  UI_PB_debug_DebugMsg "~sequence $this destroyed"
  set evt_obj_list $sequence::($this,evt_obj_list)
  foreach evt_obj $evt_obj_list \
  {
   PB_com_DeleteObject $evt_obj
  }
 }

#=======================================================================
proc setvalue {this OBJ_ATTR} {
  upvar $OBJ_ATTR obj_attr
  set sequence::($this,seq_name)         $obj_attr(0)
  set sequence::($this,evt_obj_list)     $obj_attr(1)
  set sequence::($this,comb_elem_list)   $obj_attr(2)
 }

#=======================================================================
proc readvalue {this OBJ_ATTR} {
  upvar $OBJ_ATTR obj_attr
  set obj_attr(0) $sequence::($this,seq_name)
  set obj_attr(1) $sequence::($this,evt_obj_list)
  set obj_attr(2) $sequence::($this,comb_elem_list)
 }

#=======================================================================
proc DefaultValue {this OBJ_ATTR} {
  upvar $OBJ_ATTR obj_attr
  set def_value [array get obj_attr]
  set sequence::($this,def_value) $def_value
 }

#=======================================================================
proc RestoreValue {this} {
  sequence::readvalue $this obj_attr
  set sequence::($this,rest_value) [array get obj_attr]
 }
}
class item {

#=======================================================================
proc item {this} {
  UI_PB_debug_DebugMsg "item $this constructed"
  set item::($this,item_name) "DEFAULT"
 }

#=======================================================================
proc ~item {this} {
  UI_PB_debug_DebugMsg "~item $this destroyed"
  set grp_obj_list $item::($this,grp_obj_list)
  foreach grp_obj $grp_obj_list \
  {
   PB_com_DeleteObject $grp_obj
  }
 }

#=======================================================================
proc setvalue {this OBJ_ATTR} {
  upvar $OBJ_ATTR obj_attr
  set item::($this,label)         $obj_attr(0)
  set item::($this,nof_grps)      $obj_attr(1)
  set item::($this,grp_align)     $obj_attr(2)
  set item::($this,grp_obj_list)  $obj_attr(3)
 }

#=======================================================================
proc readvalue {this OBJ_ATTR} {
  upvar $OBJ_ATTR obj_attr
  set obj_attr(0) $item::($this,label)
  set obj_attr(1) $item::($this,nof_grps)
  set obj_attr(2) $item::($this,grp_align)
  set obj_attr(3) $item::($this,grp_obj_list)
 }

#=======================================================================
proc DefaultValue {this OBJ_ATTR} {
  upvar $OBJ_ATTR obj_attr
  set def_value [array get obj_attr]
  set item::($this,def_value) $def_value
 }

#=======================================================================
proc RestoreValue {this} {
  item::readvalue $this obj_attr
  set item::($this,rest_value) [array get obj_attr]
 }
}
class item_group {

#=======================================================================
proc item_group {this} {
  UI_PB_debug_DebugMsg "item_group $this constructed"
  set item_group::($this,elem_name) "DEFAULT"
 }

#=======================================================================
proc ~item_group {this} {
  UI_PB_debug_DebugMsg "~item_group $this destroyed"
  set mem_obj_list $item_group::($this,mem_obj_list)
  foreach mem_obj $mem_obj_list \
  {
   PB_com_DeleteObject $mem_obj
  }
 }

#=======================================================================
proc setvalue {this OBJ_ATTR} {
  upvar $OBJ_ATTR obj_attr
  set item_group::($this,name)            $obj_attr(0)
  set item_group::($this,nof_elems)       $obj_attr(1)
  set item_group::($this,elem_align)      $obj_attr(2)
  set item_group::($this,mem_obj_list)    $obj_attr(3)
 }

#=======================================================================
proc readvalue {this OBJ_ATTR} {
  upvar $OBJ_ATTR obj_attr
  set obj_attr(0) $item_group::($this,name)
  set obj_attr(1) $item_group::($this,nof_elems)
  set obj_attr(2) $item_group::($this,elem_align)
  set obj_attr(3) $item_group::($this,mem_obj_list)
 }

#=======================================================================
proc DefaultValue {this OBJ_ATTR} {
  upvar $OBJ_ATTR obj_attr
  set def_value [array get obj_attr]
  set item_group::($this,def_value) $def_value
 }

#=======================================================================
proc RestoreValue {this} {
  item_group::readvalue $this obj_attr
  set item_group::($this,rest_value) [array get obj_attr]
 }
}
class group_member {

#=======================================================================
proc group_member {this} {
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
proc ~group_member {this} {
  UI_PB_debug_DebugMsg "~group_member $this destroyed"
 }

#=======================================================================
proc setvalue {this OBJ_ATTR} {
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
proc readvalue {this OBJ_ATTR} {
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
proc DefaultValue {this OBJ_ATTR} {
  upvar $OBJ_ATTR obj_attr
  set def_value [array get obj_attr]
  set group_member::($this,def_value) $def_value
 }

#=======================================================================
proc RestoreValue {this} {
  group_member::readvalue $this obj_attr
  set group_member::($this,rest_value) [array get obj_attr]
 }
}
class ListingFile {

#=======================================================================
proc ListingFile {this} {
  UI_PB_debug_DebugMsg "ListingFile $this constructed"
  if 0 {
   set def_values {0 listfile.lpt 0 0 0 0 0 0 0 0 40 \
   30 0 0 0 0 0 0 0 0 lpt 0 0 ptp 0 pb_user.tcl}
   set arr_names {listfile fname x y z 4axis 5axis feed \
    speed head lines column warn oper tool start_path \
    tool_chng end_path oper_time setup_time lpt_ext \
   review group ncfile_ext usertcl_check usertcl_name}
  }
  set def_values {0 listfile.lpt 0 0 0 0 0 0 0 0 40 \
  30 0 0 0 0 0 0 0 0 lpt 0 0 0 ptp 0 pb_user.tcl}
  set arr_names {listfile fname x y z 4axis 5axis feed \
   speed head lines column warn oper tool start_path \
   tool_chng end_path oper_time setup_time lpt_ext \
  verbose review group ncfile_ext usertcl_check usertcl_name}
  set ind 0
  foreach name $arr_names\
  {
   set ListingFile::($this,$name) [lindex $def_values $ind]
   incr ind
  }
  set ListingFile::($this,arr_names) $arr_names
 }

#=======================================================================
proc ~ListingFile {this} {
  UI_PB_debug_DebugMsg "~ListingFile $this destroyed"
 }

#=======================================================================
proc setvalue {this OBJ_ATTR} {
  upvar $OBJ_ATTR obj_attr
  set arr_names [array names obj_attr]
  foreach name $arr_names\
  {
   set ListingFile::($this,$name) $obj_attr($name)
  }
 }

#=======================================================================
proc readvalue {this OBJ_ATTR} {
  upvar $OBJ_ATTR obj_attr
  set arr_names $ListingFile::($this,arr_names)
  foreach name $arr_names\
  {
   set obj_attr($name) $ListingFile::($this,$name)
  }
 }

#=======================================================================
proc SetLfileAddObjList {post_obj LF_ADD_OBJ_LIST} {
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
proc DefaultValue {this OBJ_ATTR} {
  upvar $OBJ_ATTR obj_attr
  set def_value [array get obj_attr]
  set ListingFile::($this,def_value) $def_value
  set ListingFile::($this,restore_value) $def_value
 }

#=======================================================================
proc RestoreValue {this OBJ_ATTR} {
  upvar $OBJ_ATTR obj_attr
  set restore_value [array get obj_attr]
  set ListingFile::($this,restore_value) $restore_value
 }
}
class MachineToolElement {

#=======================================================================
proc MachineToolElement {this} {
  UI_PB_debug_DebugMsg "MachineToolElement $this constructed"
 }

#=======================================================================
proc ~MachineToolElement {this} {
  UI_PB_debug_DebugMsg "~MachineToolElement $this destroyed"
 }

#=======================================================================
proc GeneralParameters {this OBJ_ATTR} {
  upvar $OBJ_ATTR obj_attr
  set arr_names [array names obj_attr]
  foreach name $arr_names\
  {
   set MachineToolElement::($this,$name) $obj_attr($name)
  }
 }

#=======================================================================
proc 4AxisParameters {this OBJ_ATTR} {
  upvar $OBJ_ATTR obj_attr
  set arr_names [array names obj_attr]
  foreach name $arr_names\
  {
   set MachineToolElement::($this,$name\_4) $obj_attr($name)
  }
 }

#=======================================================================
proc 5AxisParameters {this OBJ_ATTR} {
  upvar $OBJ_ATTR obj_attr
  set arr_names [array names obj_attr]
  foreach name $arr_names\
  {
   set MachineToolElement::($this,$name\_5) $obj_attr($name)
  }
 }

#=======================================================================
proc DefaultValue {this OBJ_ATTR IDENTIFIER} {
  upvar $OBJ_ATTR obj_attr
  upvar $IDENTIFIER identifier
  switch $identifier\
  {
   3-Axis             {
    set def_value [array get obj_attr]
    set MachineToolElement::($this,3axis_def_value) \
    $def_value
   }
   4-Axis             {
    set def_value [array get obj_attr]
    set MachineToolElement::($this,4axis_def_value) \
    $def_value
   }
   5-Axis             {
    set def_value [array get obj_attr]
    set MachineToolElement::($this,5axis_def_value) \
    $def_value
   }
  }
 }
}
class param {

#=======================================================================
proc param {this} {
  UI_PB_debug_DebugMsg "param $this constructed"
  set param::($this,param_name) "DEFAULT"
 }

#=======================================================================
proc ~param {this} {
  UI_PB_debug_DebugMsg "~param $this destroyed"
 }

#=======================================================================
proc CreateObject {TYPE} {
  upvar $TYPE type
  switch $type\
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
  }
  return $object
 }

#=======================================================================
proc ObjectSetValue {this OBJ_ATTR} {
  upvar $OBJ_ATTR obj_attr
  set ClassName [string trim [classof $this] ::]
  switch $ClassName\
  {
   param::integer  {
    param::integer::setvalue $this obj_attr
   }
   param::double   {
    param::double::setvalue $this obj_attr
   }
   param::option   {
    param::option::setvalue $this obj_attr
   }
   param::boolean  {
    param::boolean::setvalue $this obj_attr
   }
   param::string   {
    param::string::setvalue $this obj_attr
   }
   param::point    {
    param::point::setvalue $this obj_attr
   }
  }
 }

#=======================================================================
proc ObjectSetDefaultValue {this OBJ_ATTR} {
  upvar $OBJ_ATTR obj_attr
  set ClassName [string trim [classof $this] ::]
  switch $ClassName\
  {
   param::integer  {
    param::integer::setdefvalue $this obj_attr
   }
   param::double   {
    param::double::setdefvalue $this obj_attr
   }
   param::option   {
    param::option::setdefvalue $this obj_attr
   }
   param::boolean  {
    param::boolean::setdefvalue $this obj_attr
   }
   param::string   {
    param::string::setdefvalue $this obj_attr
   }
   param::point    {
    param::point::setdefvalue $this obj_attr
   }
  }
 }
 class integer {

#=======================================================================
proc integer {this} {
  UI_PB_debug_DebugMsg "integer $this constructed"
  set param::integer::($this,name) "INTEGER"
 }

#=======================================================================
proc ~integer {this} {
  UI_PB_debug_DebugMsg "~integer $this destroyed"
 }

#=======================================================================
proc setvalue {this OBJ_ATTR} {
  upvar $OBJ_ATTR obj_attr
  set param::integer::($this,name)      $obj_attr(0)
  set param::integer::($this,type)      $obj_attr(1)
  set param::integer::($this,def_value) $obj_attr(2)
  set param::integer::($this,toggle)    $obj_attr(3)
  set param::integer::($this,ui_label)  $obj_attr(4)
 }

#=======================================================================
proc setdefvalue {this OBJ_ATTR} {
  upvar $OBJ_ATTR obj_attr
  set param::integer::($this,def_name)      $obj_attr(0)
  set param::integer::($this,def_type)      $obj_attr(1)
  set param::integer::($this,def_def_value) $obj_attr(2)
  set param::integer::($this,def_toggle)    $obj_attr(3)
  set param::integer::($this,def_ui_label)  $obj_attr(4)
 }
}
class double {

#=======================================================================
proc double {this} {
  UI_PB_debug_DebugMsg "double $this constructed"
  set param::double::($this,name) "DOUBLE"
 }

#=======================================================================
proc ~double  {this} {
  UI_PB_debug_DebugMsg "~double $this destroyed"
 }

#=======================================================================
proc setvalue {this OBJ_ATTR} {
  upvar $OBJ_ATTR obj_attr
  set param::double::($this,name)      $obj_attr(0)
  set param::double::($this,type)      $obj_attr(1)
  set param::double::($this,def_value) $obj_attr(2)
  set param::double::($this,toggle)    $obj_attr(3)
  set param::double::($this,ui_label)  $obj_attr(4)
 }

#=======================================================================
proc setdefvalue {this OBJ_ATTR} {
  upvar $OBJ_ATTR obj_attr
  set param::double::($this,def_name)      $obj_attr(0)
  set param::double::($this,def_type)      $obj_attr(1)
  set param::double::($this,def_def_value) $obj_attr(2)
  set param::double::($this,def_toggle)    $obj_attr(3)
  set param::double::($this,def_ui_label)  $obj_attr(4)
 }
}
class option {

#=======================================================================
proc option {this} {
  UI_PB_debug_DebugMsg "option $this constructed"
  set param::option::($this,name) "OPTION"
 }

#=======================================================================
proc ~option  {this} {
  UI_PB_debug_DebugMsg "~option $this destroyed"
 }

#=======================================================================
proc setvalue {this OBJ_ATTR} {
  upvar $OBJ_ATTR obj_attr
  set param::option::($this,name)      $obj_attr(0)
  set param::option::($this,type)      $obj_attr(1)
  set param::option::($this,def_value) $obj_attr(2)
  set param::option::($this,options)   $obj_attr(3)
  set param::option::($this,ui_label)  $obj_attr(4)
  if [string match $obj_attr(5) ""] {
   set param::option::($this,toggle)    None
   } else {
   set param::option::($this,toggle)    $obj_attr(5);#<10-21-05 peter>defined temporarily for ude
  }
 }

#=======================================================================
proc setdefvalue {this OBJ_ATTR} {
  upvar $OBJ_ATTR obj_attr
  set param::option::($this,def_name)      $obj_attr(0)
  set param::option::($this,def_type)      $obj_attr(1)
  set param::option::($this,def_def_value) $obj_attr(2)
  set param::option::($this,def_options)   $obj_attr(3)
  set param::option::($this,def_ui_label)  $obj_attr(4)
  if [string match $obj_attr(5) ""] {
   set param::option::($this,def_toggle)   None
   } else {
   set param::option::($this,def_toggle)    $obj_attr(5)
  }
 }
}
class boolean {

#=======================================================================
proc boolean {this} {
  UI_PB_debug_DebugMsg "boolean $this constructed"
  set param::boolean::($this,name) "BOOLEAN"
 }

#=======================================================================
proc ~boolean  {this} {
  UI_PB_debug_DebugMsg "~boolean $this destroyed"
 }

#=======================================================================
proc setvalue {this OBJ_ATTR} {
  upvar $OBJ_ATTR obj_attr
  set param::boolean::($this,name)      $obj_attr(0)
  set param::boolean::($this,type)      $obj_attr(1)
  set param::boolean::($this,def_value) $obj_attr(2)
  set param::boolean::($this,ui_label)  $obj_attr(3)
 }

#=======================================================================
proc setdefvalue {this OBJ_ATTR} {
  upvar $OBJ_ATTR obj_attr
  set param::boolean::($this,def_name)      $obj_attr(0)
  set param::boolean::($this,def_type)      $obj_attr(1)
  set param::boolean::($this,def_def_value) $obj_attr(2)
  set param::boolean::($this,def_ui_label)  $obj_attr(3)
 }
}
class string {

#=======================================================================
proc string {this} {
  UI_PB_debug_DebugMsg "string $this constructed"
  set param::string::($this,name) "STRING"
 }

#=======================================================================
proc ~string  {this} {
  UI_PB_debug_DebugMsg "~string $this destroyed"
 }

#=======================================================================
proc setvalue {this OBJ_ATTR} {
  upvar $OBJ_ATTR obj_attr
  set param::string::($this,name)      $obj_attr(0)
  set param::string::($this,type)      $obj_attr(1)
  set param::string::($this,toggle)    $obj_attr(2)
  set param::string::($this,ui_label)  $obj_attr(3)
  set param::string::($this,def_value) $obj_attr(4);# <11-01-05 peter>was defined for UDE
 }

#=======================================================================
proc setdefvalue {this OBJ_ATTR} {
  upvar $OBJ_ATTR obj_attr
  set param::string::($this,def_name)      $obj_attr(0)
  set param::string::($this,def_type)      $obj_attr(1)
  set param::string::($this,def_toggle)    $obj_attr(2)
  set param::string::($this,def_ui_label)  $obj_attr(3)
  set param::string::($this,def_def_value) $obj_attr(4)
 }
}
class point {

#=======================================================================
proc point {this} {
  UI_PB_debug_DebugMsg "point $this constructed"
  set param::point::($this,name) "STRING"
 }

#=======================================================================
proc ~point  {this} {
  UI_PB_debug_DebugMsg "~point $this destroyed"
 }

#=======================================================================
proc setvalue {this OBJ_ATTR} {
  upvar $OBJ_ATTR obj_attr
  set param::point::($this,name)      $obj_attr(0)
  set param::point::($this,type)      $obj_attr(1)
  set param::point::($this,ui_label)  $obj_attr(2)
  set param::point::($this,toggle)    $obj_attr(3);#<10-21-05 peter>defined temporarily for ude
 }

#=======================================================================
proc setdefvalue {this OBJ_ATTR} {
  upvar $OBJ_ATTR obj_attr
  set param::point::($this,def_name)      $obj_attr(0)
  set param::point::($this,def_type)      $obj_attr(1)
  set param::point::($this,def_ui_label)  $obj_attr(2)
  set param::point::($this,def_toggle)    $obj_attr(3)
 }
}
}
class ude_event {

#=======================================================================
proc ude_event {this} {
  UI_PB_debug_DebugMsg "ude_event $this constructed"
  set ude_event::($this,name) "DEFAULT"
 }

#=======================================================================
proc ~ude_event  {this} {
  UI_PB_debug_DebugMsg "~ude_event $this destroyed"
 }

#=======================================================================
proc setvalue {this OBJ_ATTR} {
  upvar $OBJ_ATTR obj_attr
  set ude_event::($this,name)           $obj_attr(0)
  set ude_event::($this,post_event)     $obj_attr(1)
  set ude_event::($this,ui_label)       $obj_attr(2)
  set ude_event::($this,category)       $obj_attr(3)
  set ude_event::($this,param_obj_list) $obj_attr(4)
 }

#=======================================================================
proc setdefvalue {this OBJ_ATTR} {
  upvar $OBJ_ATTR obj_attr
  set ude_event::($this,def_name)           $obj_attr(0)
  set ude_event::($this,def_post_event)     $obj_attr(1)
  set ude_event::($this,def_ui_label)       $obj_attr(2)
  set ude_event::($this,def_category)       $obj_attr(3)
  set ude_event::($this,def_param_obj_list) $obj_attr(4)
 }
}
class cycle_event {

#=======================================================================
proc cycle_event {this} {
  UI_PB_debug_DebugMsg "cycle_event $this constructed"
  set cycle_event::($this,name) "DEFAULT"
 }

#=======================================================================
proc ~cycle_event  {this} {
  UI_PB_debug_DebugMsg "~cycle_event $this destroyed"
 }

#=======================================================================
proc setvalue {this OBJ_ATTR} {
  upvar $OBJ_ATTR obj_attr
  set cycle_event::($this,name)           $obj_attr(0)
  set cycle_event::($this,is_sys_cycle)   $obj_attr(1)
  set cycle_event::($this,ui_label)       $obj_attr(2)
  set cycle_event::($this,param_obj_list) $obj_attr(4)
 }

#=======================================================================
proc setdefvalue {this OBJ_ATTR} {
  upvar $OBJ_ATTR obj_attr
  set cycle_event::($this,def_name)           $obj_attr(0)
  set cycle_event::($this,def_is_sys_cycle)   $obj_attr(1)
  set cycle_event::($this,def_ui_label)       $obj_attr(2)
  set cycle_event::($this,def_param_obj_list) $obj_attr(4)
 }
}
class ude {

#=======================================================================
proc ude {this} {
  UI_PB_debug_DebugMsg "ude $this constructed"
  set ude::($this,name) "DEFAULT"
  set ude::($this,seq_obj) ""
  set ude::($this,seq_obj_cycle) ""
 }

#=======================================================================
proc ~ude {this} {
  UI_PB_debug_DebugMsg "~ude $this destroyed"
 }

#=======================================================================
proc setvalue {this OBJ_ATTR} {
  upvar $OBJ_ATTR obj_attr
  set ude::($this,name)           $obj_attr(0)
  set ude::($this,event_obj_list) $obj_attr(1)
  set ude::($this,cyc_evt_obj_list) $obj_attr(2)
 }
}
class File {

#=======================================================================
proc File {this FPointer} {
  UI_PB_debug_DebugMsg "File $this constructed"
  set File::($this,FilePointer) $FPointer
 }

#=======================================================================
proc ~File {this} {
  UI_PB_debug_DebugMsg "~file $this destroyed"
 }

#=======================================================================
proc OpenFileRead {this FName} {
  set File::($this,FileName) $FName
  set FPointer $File::($this,FilePointer)
  if [catch {open "$FName" r} $FPointer] \
  {
   return [tk_messageBox -type ok -icon error -message "$$FPointer"]
  }
  set evalvar "set evelinvar $$FPointer"
  set FpointerAddress [eval $evalvar]
  set File::($this,FilePointer) $FpointerAddress
 }

#=======================================================================
proc OpenFileWrite {this FName} {
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
proc ResetFilePointer {this} {
  seek $File::($this,FilePointer) 0
 }

#=======================================================================
proc CloseFile {this} {
  close $File::($this,FilePointer)
 }
}
class ParseFile {

#=======================================================================
proc ParseFile {this FPointer} File {$FPointer} {
  UI_PB_debug_DebugMsg "ParseFile $this constructed"
 }

#=======================================================================
proc ~ParseFile {this} {
  UI_PB_debug_DebugMsg "~ParseFile $this destroyed"
 }

#=======================================================================
proc ParsePuiFile {this POST_OBJ} {
  upvar $POST_OBJ post_obj
  if [catch {PB_pui_ReadPuiCreateObjs this post_obj} result] {
   UI_PB_debug_Pause $result
   return TCL_ERROR
  }
 }

#=======================================================================
proc ParseUdeFile {this POST_OBJ} {
  upvar $POST_OBJ post_obj
  PB_ude_UdeInitParse $this post_obj
 }

#=======================================================================
proc ParseDefFile {this file_name} {
  if [catch {PB_mthd_DefFileInitParse $this $file_name} result] {
   UI_PB_debug_ForceMsg $result
   return TCL_ERROR
  }
 }

#=======================================================================
proc ParseWordSep {this} {
  PB_mthd_GetWordSep $this
 }

#=======================================================================
proc ParseEndOfLine {this} {
  PB_mthd_GetEndOfLine $this
 }

#=======================================================================
proc ParseSequence {this} {
  PB_mthd_GetSequenceParams $this
 }

#=======================================================================
proc ParseFormat {this OBJ_LIST } {
  upvar $OBJ_LIST obj_list
  global post_object
  set obj_list $Post::($post_object,fmt_obj_list)
  PB_fmt_FmtInitParse $this obj_list
 }

#=======================================================================
proc ParseAddress {this POST_OBJ OBJ_LIST LF_OBJ_LIST FOBJ_LIST \
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
proc ParseBlockTemp {this OBJ_LIST ADDOBJ_LIST POST_OBJ} {
  upvar $OBJ_LIST obj_list
  upvar $ADDOBJ_LIST addobj_list
  upvar $POST_OBJ post_obj
  set obj_list $Post::($post_obj,blk_obj_list)
  PB_blk_BlkInitParse $this obj_list addobj_list post_obj
 }
}
