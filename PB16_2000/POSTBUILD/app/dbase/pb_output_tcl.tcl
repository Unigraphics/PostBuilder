#13

#=======================================================================
proc PB_output_GetWordSeperator { word_sep WSP_OUTPUT } {
  upvar $WSP_OUTPUT wsp_output
  set wsp_output "WORD_SEPARATOR \"$word_sep\""
 }

#=======================================================================
proc PB_output_GetEndOfLine { end_of_line ENDLINE_OUTPUT } {
  upvar $ENDLINE_OUTPUT endline_output
  set endline_output "END_OF_LINE \"$end_of_line\""
 }

#=======================================================================
proc PB_output_GetSequenceNumber { SEQ_PARAM SEQUENCE_OUTPUT } {
  upvar $SEQ_PARAM seq_param
  upvar $SEQUENCE_OUTPUT sequence_output
  set sequence_output "SEQUENCE $seq_param(0) $seq_param(1) \
  $seq_param(2) $seq_param(3)"
 }

#=======================================================================
proc PB_output_GetFmtObjAttr {FMT_OBJ_LIST FMT_NAME_ARR FMT_VAL_ARR} {
  upvar $FMT_OBJ_LIST fmt_obj_list
  upvar $FMT_NAME_ARR fmt_name_arr
  upvar $FMT_VAL_ARR fmt_val_arr
  set ind 0
  foreach fmt_obj $fmt_obj_list\
  {
   set fmt_name_arr($ind) $format::($fmt_obj,for_name)
   format::readvalue $fmt_obj fmt_obj_attr
   PB_fmt_RetFmtFrmAttr fmt_obj_attr for_value
   set fmt_val_arr($ind) $for_value
   incr ind
  }
 }

#=======================================================================
proc PB_output_GetAdrObjAttr {ADD_OBJ_LIST ADR_NAME_ARR ADR_VAL_ARR} {
  upvar $ADD_OBJ_LIST add_obj_list
  upvar $ADR_NAME_ARR adr_name_arr
  upvar $ADR_VAL_ARR adr_val_arr
  set ind 0
  foreach adr_obj $add_obj_list\
  {
   set adr_name_arr($ind) $address::($adr_obj,add_name)
   address::readvalue $adr_obj adr_obj_attr
   if { $address::($adr_obj,leader_var) != "" } \
   {
    set adr_obj_attr(8) $address::($adr_obj,leader_var)
   }
   PB_adr_RetAddFrmAddAttr adr_obj_attr val_list
   set adr_val_arr($ind) $val_list
   unset val_list
   incr ind
  }
 }

#=======================================================================
proc PB_output_GetBlkObjAttr { BLK_OBJ_LIST ADD_OBJ_LIST BLK_NAME_ARR \
  BLK_VALUE_ARR} {
  upvar $BLK_OBJ_LIST blk_obj_list
  upvar $ADD_OBJ_LIST add_obj_list
  upvar $BLK_NAME_ARR blk_name_arr
  upvar $BLK_VALUE_ARR blk_value_arr
  set dummy_blk(0) "dummy"
  set add_name "X"
  PB_com_RetObjFrmName add_name add_obj_list x_addr
  set blk_elem_obj_attr(0) $x_addr
  set blk_elem_obj_attr(1) "\$mom_pos(0)"
  set blk_elem_obj_attr(2) "blank"
  set blk_elem_obj_attr(3) ""
  set blk_elem_obj_attr(4) 0
  PB_blk_CreateBlkElemObj blk_elem_obj_attr x_blkelem dummy_blk
  set add_name "Y"
  PB_com_RetObjFrmName add_name add_obj_list y_addr
  set blk_elem_obj_attr(0) $y_addr
  set blk_elem_obj_attr(1) "\$mom_pos(1)"
  set blk_elem_obj_attr(2) "blank"
  set blk_elem_obj_attr(3) ""
  set blk_elem_obj_attr(4) 0
  PB_blk_CreateBlkElemObj blk_elem_obj_attr y_blkelem dummy_blk
  set add_name "Z"
  PB_com_RetObjFrmName add_name add_obj_list z_addr
  set blk_elem_obj_attr(0) $z_addr
  set blk_elem_obj_attr(1) "\$mom_pos(2)"
  set blk_elem_obj_attr(2) "blank"
  set blk_elem_obj_attr(3) ""
  set blk_elem_obj_attr(4) 0
  PB_blk_CreateBlkElemObj blk_elem_obj_attr z_blkelem dummy_blk
  unset blk_elem_obj_attr
  set indx 0
  foreach block_obj $blk_obj_list\
  {
   set blk_name_arr($indx) $block::($block_obj,block_name)
   block::readvalue $block_obj blk_obj_attr
   set act_blk_elem_list ""
   set rap_flag 0
   foreach blk_elem $blk_obj_attr(2) \
   {
    set add_obj $block_element::($blk_elem,elem_add_obj)
    if { $add_obj == "Command" || $add_obj == "Comment" } \
    {
     set add_name $add_obj
    } else \
    {
     set add_name $address::($add_obj,add_name)
    }
    if { [string compare $add_name "rapid1"] == 0 || \
     [string compare $add_name "rapid2"] == 0 || \
    [string compare $add_name "rapid3"] == 0 } \
    {
     set elem_var $block_element::($blk_elem,elem_mom_variable)
     set var_list [split $elem_var \(]
     set rap_var [lindex $var_list 0]
     set rap_flag 1
    } else \
    {
     lappend act_blk_elem_list $blk_elem
    }
   }
   if { $rap_flag } \
   {
    set block_element::($x_blkelem,elem_mom_variable) ${rap_var}(0)
    lappend act_blk_elem_list $x_blkelem
    set block_element::($y_blkelem,elem_mom_variable) ${rap_var}(1)
    lappend act_blk_elem_list $y_blkelem
    set block_element::($z_blkelem,elem_mom_variable) ${rap_var}(2)
    lappend act_blk_elem_list $z_blkelem
    set blk_obj_attr(2) $act_blk_elem_list
   }
   PB_blk_RetBlkFrmBlkAttr blk_obj_attr blk_value_list
   set blk_value_arr($indx) $blk_value_list
   unset blk_value_list
   incr indx
  }
  delete $x_blkelem
  delete $y_blkelem
  delete $z_blkelem
 }

#=======================================================================
proc PB_output_GetCompositeBlks { COMP_BLK_LIST } {
  upvar $COMP_BLK_LIST comp_blk_list
  global post_object
  set comp_blk_list ""
  set seq_obj_list $Post::($post_object,seq_obj_list)
  set blk_obj_list $Post::($post_object,blk_obj_list)
  lappend in_sequence [lindex $seq_obj_list 0] [lindex $seq_obj_list 1] \
  [lindex $seq_obj_list 5] [lindex $seq_obj_list 6]
  foreach seq_obj $in_sequence \
  {
   set evt_obj_list $sequence::($seq_obj,evt_obj_list)
   foreach evt_obj $evt_obj_list \
   {
    set evt_elem_list $event::($evt_obj,evt_elem_list)
    set evt_comp_no 0
    foreach evt_elem_row $evt_elem_list \
    {
     set no_of_rowelem [llength $evt_elem_row]
     if {$no_of_rowelem > 1} \
     {
      set temp_event_name $event::($evt_obj,event_name)
      set temp_event_name [string tolower $temp_event_name]
      set temp_evt_name [join [split $temp_event_name " "] _ ]
      if { $evt_comp_no } \
      {
      }
      set blk_obj_attr(0)  $temp_evt_name
      PB_int_GetAllBlockNames blk_obj_list blk_name_list
      PB_int_GetAllBlockNames comp_blk_list blk_name_list
      PB_com_SetDefaultName blk_name_list blk_obj_attr
      set comp_blk_elem ""
      foreach evt_elem_obj $evt_elem_row \
      {
       set block_obj $event_element::($evt_elem_obj,block_obj)
       foreach blk_elem_obj $block::($block_obj,elem_addr_list) \
       {
        lappend comp_blk_elem $blk_elem_obj
       }
      }
      UI_PB_com_ApplyMastSeqBlockElem comp_blk_elem
      set blk_obj_attr(1) [llength $comp_blk_elem]
      set blk_obj_attr(2) $comp_blk_elem
      set blk_obj_attr(3) "normal"
      PB_blk_CreateBlkObj blk_obj_attr comp_blk_obj
      lappend comp_blk_list $comp_blk_obj
      set first_elem_obj [lindex $evt_elem_row 0]
      set event_element::($first_elem_obj,evt_elem_name) \
      $blk_obj_attr(0)
     }
    }
   }
  }
 }

#=======================================================================
proc PB_output_GetMomSysVars {MOM_SYS_NAME_ARR MOM_SYS_VAL_ARR} {
  upvar $MOM_SYS_NAME_ARR mom_sys_name_arr
  upvar $MOM_SYS_VAL_ARR mom_sys_val_arr
  global post_object
  array set mom_sys_var_arr $Post::($post_object,mom_sys_var_list)
  array set mom_sys_g_codes $Post::($post_object,g_codes)
  array set mom_sys_m_codes $Post::($post_object,m_codes)
  array set word_mom_var_list $Post::($post_object,word_mom_var)
  set no_of_g_codes [array size mom_sys_g_codes]
  set ind 0
  for {set count 0} { $count < $no_of_g_codes } {incr count} \
  {
   set mom_sys_var $mom_sys_g_codes($count)
   set mom_sys_name_arr($ind) [string trimleft $mom_sys_var \$]
   set mom_sys_val_arr($ind) $mom_sys_var_arr($mom_sys_var)
   incr ind
  }
  set no_of_m_codes [array size mom_sys_m_codes]
  for {set count 0} { $count < $no_of_m_codes } {incr count} \
  {
   set mom_sys_var $mom_sys_m_codes($count)
   set mom_sys_name_arr($ind) [string trimleft $mom_sys_var \$]
   set mom_sys_val_arr($ind) $mom_sys_var_arr($mom_sys_var)
   incr ind
  }
  set code_edit 0
  switch $mom_sys_var_arr(\$spin_fmt_type) \
  {
   "None" { set code_edit 0 }
   "Separate_M_Code(41)" { set code_edit 1 }
   "Range_Code_with_M_Code" { set code_edit 2 }
   "High_or_Low_Range_S_Code" { set code_edit 3 }
   "Odd_or_Even_Range_S_Code" { set code_edit 4 }
  }
  set add_name "PB_spindle"
  set no_of_ranges $mom_sys_var_arr(\$mom_sys_spindle_ranges)
  for {set count 1 } { $count <= $no_of_ranges } { incr count } \
  {
   if { [info exists mom_sys_var_arr(\$spindle_range($code_edit,$count,code))] } \
   {
    set mom_sys_name_arr($ind) "mom_sys_spindle_range_code($count)"
    set mom_var "\$spindle_range($code_edit,$count,code)"
    set mom_sys_val_arr($ind) $mom_sys_var_arr($mom_var)
    incr ind
    set mom_sys_name_arr($ind) "mom_sys_spindle_param($count,max)"
    set mom_var "\$spindle_range($code_edit,$count,max)"
    set mom_sys_val_arr($ind) $mom_sys_var_arr($mom_var)
    incr ind
    set mom_sys_name_arr($ind) "mom_sys_spindle_param($count,min)"
    set mom_var "\$spindle_range($code_edit,$count,min)"
    set mom_sys_val_arr($ind) $mom_sys_var_arr($mom_var)
    incr ind
   }
  }
  set add_name "PB_Tcl_Var"
  foreach var $word_mom_var_list($add_name) \
  {
   if { $var == "\$mom_sys_gcodes_per_block" && \
   $mom_sys_var_arr(\$gcode_status) == 0 } \
   {
    continue
    } elseif { $var == "\$mom_sys_mcodes_per_block" && \
   $mom_sys_var_arr(\$mcode_status) == 0} \
   {
    continue
   }
   set mom_sys_name_arr($ind) [string trimleft $var \$]
   set mom_sys_val_arr($ind) $mom_sys_var_arr($var)
   if { [string first $mom_sys_val_arr($ind) \\] != -1} \
   {
    set var_split [split $mom_sys_val_arr($ind) \\]
    set mom_sys_val_arr($ind) [join $var_split "\\\\"]
   }
   incr ind
  }
 }

#=======================================================================
proc PB_output_GetListFileVars { LIST_NAME_ARR LIST_VAL_ARR } {
  upvar $LIST_NAME_ARR list_name_arr
  upvar $LIST_VAL_ARR list_val_arr
  global post_object
  set listfile_obj $Post::($post_object,list_obj_list)
  PB_lfl_RetLfileBlock listfile_obj list_blk_value
  if { $ListingFile::($listfile_obj,listfile) && \
  $list_blk_value != "" } \
  {
   set list_name_arr(0) "mom_sys_list_output"
   set list_val_arr(0) "ON"
  } else \
  {
   set list_name_arr(0) "mom_sys_list_output"
   set list_val_arr(0) "OFF"
  }
  if { $ListingFile::($listfile_obj,head) } \
  {
   set list_name_arr(1) "mom_sys_header_output"
   set list_val_arr(1) "ON"
  } else \
  {
   set list_name_arr(1) "mom_sys_header_output"
   set list_val_arr(1) "OFF"
  }
  set list_name_arr(2) "mom_sys_list_file_rows"
  set list_val_arr(2) $ListingFile::($listfile_obj,lines)
  set list_name_arr(3) "mom_sys_list_file_columns"
  set list_val_arr(3) $ListingFile::($listfile_obj,column)
  if  { $ListingFile::($listfile_obj,warn) } \
  {
   set list_name_arr(4) "mom_sys_warning_output"
   set list_val_arr(4)  "ON"
  } else \
  {
   set list_name_arr(4) "mom_sys_warning_output"
   set list_val_arr(4)  "OFF"
  }
  if  { $ListingFile::($listfile_obj,group) } \
  {
   set list_name_arr(5) "mom_sys_group_output"
   set list_val_arr(5)  "ON"
  } else \
  {
   set list_name_arr(5) "mom_sys_group_output"
   set list_val_arr(5)  "OFF"
  }
  set list_name_arr(6) "mom_sys_list_file_suffix"
  set list_val_arr(6)  "$ListingFile::($listfile_obj,lpt_ext)"
  set list_name_arr(7) "mom_sys_output_file_suffix"
  set list_val_arr(7)  "$ListingFile::($listfile_obj,ncfile_ext)"
 }

#=======================================================================
proc PB_output_GetMomKinVars { KIN_NAME_ARR KIN_VAL_ARR } {
  upvar $KIN_NAME_ARR kin_name_arr
  upvar $KIN_VAL_ARR kin_val_arr
  global post_object
  set ind 0
  array set mom_kin_var_arr $Post::($post_object,mom_kin_var_list)
  set mom_kin_name_list [array names mom_kin_var_arr]
  set mom_kin_name_list [lsort -dictionary $mom_kin_name_list]
  foreach mom_kin_var $mom_kin_name_list\
  {
   set kin_name_arr($ind) [string trimleft $mom_kin_var \$]
   set kin_val_arr($ind) $mom_kin_var_arr($mom_kin_var)
   incr ind
  }
 }

#=======================================================================
proc PB_output_RetBlksModality { BLK_MOD_ARR } {
  upvar $BLK_MOD_ARR blk_mod_arr
  global post_object
  set blk_obj_list $Post::($post_object,blk_obj_list)
  foreach blk_obj $blk_obj_list \
  {
   PB_blk_BlockModality blk_obj blk_mod_adds
   set block_name $block::($blk_obj,block_name)
   set blk_mod_arr($block_name) $blk_mod_adds
  }
 }

#=======================================================================
proc PB_output_GetEventsVariables {EVENT_VAR_ARR EVENT_VALUE_ARR } {
  upvar $EVENT_VAR_ARR event_var_arr
  upvar $EVENT_VALUE_ARR event_value_arr
  global post_object
  array set mom_sys_arr $Post::($post_object,mom_sys_var_list)
  set seq_obj_list $Post::($post_object,seq_obj_list)
  lappend out_sequence [lindex $seq_obj_list 2] [lindex $seq_obj_list 3] \
  [lindex $seq_obj_list 4]
  unset seq_obj_list
  foreach seq_list $out_sequence \
  {
   foreach seq_obj $seq_list \
   {
    set evt_obj_list $sequence::($seq_obj,evt_obj_list)
    foreach evt_obj $evt_obj_list \
    {
     PB_evt_RetEventVars evt_obj evt_vars
     set event_name $event::($evt_obj,event_name)
     set event_var_arr($event_name) $evt_vars
     foreach var $evt_vars \
     {
      set event_value_arr($var) $mom_sys_arr($var)
     }
    }
   }
  }
 }

#=======================================================================
proc PB_output_GetCmdBlkProcs { CMD_NAME_LIST CMD_PROC_ARR } {
  upvar $CMD_NAME_LIST cmd_name_list
  upvar $CMD_PROC_ARR cmd_proc_arr
  global post_object
  set cmd_blk_list $Post::($post_object,cmd_blk_list)
  set cmd_name_list ""
  foreach cmd_obj $cmd_blk_list \
  {
   set cmd_name $command::($cmd_obj,name)
   lappend cmd_name_list $cmd_name
   set cmd_proc_arr($cmd_name) $command::($cmd_obj,proc)
  }
 }

#=======================================================================
proc PB_output_GetEvtObjAttr { EVT_NAME_ARR EVT_BLK_ARR } {
  upvar $EVT_NAME_ARR evt_name_list
  upvar $EVT_BLK_ARR evt_blk_arr
  global post_object
  set seq_obj_list $Post::($post_object,seq_obj_list)
  lappend in_sequence [lindex $seq_obj_list 0] [lindex $seq_obj_list 1] \
  [lindex $seq_obj_list 5] [lindex $seq_obj_list 6]
  lappend out_sequence [lindex $seq_obj_list 2] [lindex $seq_obj_list 3] \
  [lindex $seq_obj_list 4]
  unset seq_obj_list
  lappend seq_obj_list $in_sequence $out_sequence
  set evt_name_list ""
  foreach seq_list $seq_obj_list \
  {
   foreach seq_obj $seq_list \
   {
    set evt_obj_list $sequence::($seq_obj,evt_obj_list)
    foreach evt_obj $evt_obj_list \
    {
     set evt_blk_name_list ""
     set temp_event_name $event::($evt_obj,event_name)
     PB_com_GetPrefixOfEvent temp_event_name prefix
     set temp_event_name [string tolower $temp_event_name]
     set temp_evt_name [join [split $temp_event_name " "] _ ]
     append event_name $prefix _ $temp_evt_name
     if { [lsearch $evt_name_list $event_name] == -1 } \
     {
      lappend evt_name_list $event_name
     }
     switch $event_name \
     {
      "MOM_drill" -
      "MOM_drill_dwell" -
      "MOM_drill_deep" -
      "MOM_drill_break_chip" -
      "MOM_tap" -
      "MOM_bore" -
      "MOM_bore_drag" -
      "MOM_bore_no_drag" -
      "MOM_bore_manual" -
      "MOM_bore_dwell" -
      "MOM_bore_back" -
      "MOM_bore_manual_dwell" {
       PB_output_RetCycleEvtBlkList evt_obj evt_blk_name_list
       set evt_blk_arr($event_name) $evt_blk_name_list
      }
      default {
       PB_output_RetEvtBlkList evt_obj evt_blk_name_list
       set evt_blk_arr($event_name) [list $evt_blk_name_list]
      }
     }
     unset event_name
    }
   }
  }
  set evt_blk_arr(MOM_tool_change) [list ""]
  PB_output_EliminatePbEvents evt_name_list evt_blk_arr
  lappend evt_name_list "MOM_sequence_number"
  set evt_blk_arr(MOM_sequence_number) [list ""]
 }

#=======================================================================
proc PB_output_GetBlkName { BLOCK_OBJ OUTPUT_NAME } {
  upvar $BLOCK_OBJ block_obj
  upvar $OUTPUT_NAME output_name
  if { $block::($block_obj,blk_type) == "normal" || \
  $block::($block_obj,blk_type) == "comment" } \
  {
   set output_name $block::($block_obj,block_name)
  } else \
  {
   set blk_elem_obj [lindex $block::($block_obj,elem_addr_list) 0]
   set cmd_elem $block_element::($blk_elem_obj,elem_mom_variable)
   if { [string match "*MOM_*" $cmd_elem] } \
   {
    set output_name $cmd_elem
   } else \
   {
    set output_name $command::($cmd_elem,name)
   }
  }
 }

#=======================================================================
proc PB_output_RetEvtBlkList { EVENT_OBJ EVT_BLK_NAME_LIST } {
  upvar $EVENT_OBJ event_obj
  upvar $EVT_BLK_NAME_LIST evt_blk_name_list
  set evt_elem_list $event::($event_obj,evt_elem_list)
  set blk_list ""
  foreach evt_elem_row $evt_elem_list \
  {
   if { [llength $evt_elem_row] > 1} \
   {
    set first_elem_obj [lindex $evt_elem_row 0]
    lappend blk_list \
    $event_element::($first_elem_obj,evt_elem_name)
   } else \
   {
    foreach evt_elem_obj $evt_elem_row \
    {
     set block_obj $event_element::($evt_elem_obj,block_obj)
     PB_output_GetBlkName block_obj output_name
     lappend blk_list $output_name
    }
   }
  }
  set evt_blk_name_list $blk_list
 }

#=======================================================================
proc PB_output_RetCycleEvtBlkList { EVENT_OBJ EVT_BLK_NAME_LIST } {
  upvar $EVENT_OBJ event_obj
  upvar $EVT_BLK_NAME_LIST evt_blk_name_list
  global mom_sys_arr
  if { $mom_sys_arr(\$cycle_start_blk) } \
  {
   set check_type 2
  } else \
  {
   set check_type 1
  }
  set evt_elem_list $event::($event_obj,evt_elem_list)
  set blk_name_list ""
  set cycle_output_list ""
  set ret_code 0
  foreach evt_elem_row $evt_elem_list \
  {
   foreach evt_elem_obj $evt_elem_row \
   {
    set block_obj $event_element::($evt_elem_obj,block_obj)
    if { $ret_code == 0} \
    {
     set ret_code [PB_evt_CheckCycleRefWord block_obj $check_type]
    }
    if { $ret_code == 1 } \
    {
     lappend cycle_output_list $blk_name_list
     set blk_name_list ""
     set ret_code 2
    }
    PB_output_GetBlkName block_obj output_name
    lappend blk_name_list $output_name
   }
  }
  lappend cycle_output_list $blk_name_list
  set evt_blk_name_list $cycle_output_list
 }

#=======================================================================
proc PB_output_EliminatePbEvents { EVT_NAME_LIST EVT_BLK_ARR } {
  upvar $EVT_NAME_LIST evt_name_list
  upvar $EVT_BLK_ARR evt_blk_arr
  set pb_events { "PB_inch_metric_mode" "PB_feedrate" \
  "PB_cycle_parameters" }
  foreach event_name $pb_events \
  {
   set evt_flag [lsearch $evt_name_list $event_name]
   if { $evt_flag != -1 } \
   {
    set evt_name_list [lreplace $evt_name_list $evt_flag \
    $evt_flag]
    unset evt_blk_arr($event_name)
   }
  }
 }

#=======================================================================
proc PB_PB2DEF_write_formats { FILE_ID FMT_NAME_ARR FMT_VAL_ARR } {
  upvar $FILE_ID file_id
  upvar $FMT_NAME_ARR fmt_name_arr
  upvar $FMT_VAL_ARR fmt_val_arr
  puts $file_id "################ FORMAT DECLARATIONS #################"
  set no_fmts [array size fmt_name_arr]
  for { set count 0 } { $count < $no_fmts } { incr count } \
  {
   puts $file_id "  FORMAT $fmt_name_arr($count) $fmt_val_arr($count)"
  }
 }

#=======================================================================
proc PB_PB2DEF_write_addresses { FILE_ID ADR_NAME_ARR ADR_VAL_ARR } {
  upvar $FILE_ID file_id
  upvar $ADR_NAME_ARR adr_name_arr
  upvar $ADR_VAL_ARR adr_val_arr
  puts $file_id "################ ADDRESS DECLARATIONS ################"
  set no_adds [array size adr_name_arr]
  for { set count 0 } { $count < $no_adds } { incr count } \
  {
   puts $file_id "  ADDRESS $adr_name_arr($count) "
   puts $file_id "  \{"
    set no_lines [llength $adr_val_arr($count)]
    for {set jj 0} {$jj < $no_lines} {incr jj} \
    {
     puts $file_id "      [lindex $adr_val_arr($count) $jj]"
    }
   puts $file_id "  \}\n"
  }
 }

#=======================================================================
proc PB_PB2DEF_write_block_templates { FILE_ID BLK_NAME_ARR BLK_VAL_ARR } {
  upvar $FILE_ID file_id
  upvar $BLK_NAME_ARR blk_name_arr
  upvar $BLK_VAL_ARR blk_val_arr
  puts $file_id "############ BLOCK TEMPLATE DECLARATIONS #############"
  set no_blks [array size blk_name_arr]
  for { set count 0 } { $count < $no_blks } { incr count } \
  {
   puts $file_id "  BLOCK_TEMPLATE $blk_name_arr($count) "
   puts $file_id "  \{"
    set no_lines [llength $blk_val_arr($count)]
    for {set jj 0} {$jj < $no_lines} {incr jj} \
    {
     puts $file_id "       [lindex $blk_val_arr($count) $jj]"
    }
   puts $file_id "  \}\n"
  }
 }

#=======================================================================
proc PB_PB2DEF_main { PARSER_OBJ OUTPUT_DEF_FILE } {
  upvar $PARSER_OBJ parser_obj
  upvar $OUTPUT_DEF_FILE def_file
  global post_object
  set fmt_obj_list $Post::($post_object,fmt_obj_list)
  set add_obj_list $Post::($post_object,add_obj_list)
  set blk_obj_list $Post::($post_object,blk_obj_list)
  array set mom_sys_var $Post::($post_object,mom_sys_var_list)
  array set mom_kin_var_arr $Post::($post_object,mom_kin_var_list)
  set listfile_obj $Post::($post_object,list_obj_list)
  set list_addr_obj_list $ListingFile::($listfile_obj,add_obj_list)
  if { [info exists ListingFile::($listfile_obj,block_obj)] } \
  {
   set list_blk_obj $ListingFile::($listfile_obj,block_obj)
  } else \
  {
   set list_blk_obj 0
  }
  set comment_blk_list $Post::($post_object,comment_blk_list)
  set file_list $ParseFile::($parser_obj,file_list)
  array set bef_com_data $ParseFile::($parser_obj,bef_com_data_list)
  array set aft_com_data $ParseFile::($parser_obj,aft_com_data_list)
  set file_name [lindex $file_list 0]
  set before_formatting $bef_com_data($file_name)
  set after_formatting $aft_com_data($file_name)
  set deff_id [open "$def_file" w+]
  foreach line $before_formatting \
  {
   puts $deff_id $line
  }
  if { [llength $before_formatting] == 0 } \
  {
   puts $deff_id "MACHINE  $mom_kin_var_arr(mom_kin_machine_type)"
  }
  puts $deff_id "FORMATTING"
  puts $deff_id "\{"
   PB_output_GetWordSeperator $mom_sys_var(Word_Seperator) word_sep
   puts $deff_id "  $word_sep"
   PB_output_GetEndOfLine $mom_sys_var(End_of_Block) endof_line
   puts $deff_id "  $endof_line"
   set seq_param_arr(0) $mom_sys_var(seqnum_block)
   set seq_param_arr(1) $mom_sys_var(seqnum_start)
   set seq_param_arr(2) $mom_sys_var(seqnum_incr)
   set seq_param_arr(3) $mom_sys_var(seqnum_freq)
   PB_output_GetSequenceNumber seq_param_arr sequence_num
   puts $deff_id "  $sequence_num"
   puts $deff_id ""
   PB_output_GetFmtObjAttr fmt_obj_list fmt_name_arr fmt_val_arr
   PB_PB2DEF_write_formats deff_id fmt_name_arr fmt_val_arr
   unset fmt_name_arr fmt_val_arr
   puts $deff_id ""
   PB_output_GetAdrObjAttr add_obj_list adr_name_arr adr_val_arr
   PB_PB2DEF_write_addresses deff_id adr_name_arr adr_val_arr
   unset adr_name_arr adr_val_arr
   puts $deff_id ""
   PB_output_GetAdrObjAttr list_addr_obj_list adr_name_arr adr_val_arr
   PB_PB2DEF_write_addresses deff_id adr_name_arr adr_val_arr
   if {[info exists adr_name_arr]} \
   {
    unset adr_name_arr adr_val_arr
   }
   puts $deff_id ""
   PB_output_GetBlkObjAttr blk_obj_list add_obj_list blk_name_arr \
   blk_val_arr
   PB_PB2DEF_write_block_templates deff_id blk_name_arr blk_val_arr
   unset blk_name_arr blk_val_arr
   PB_output_GetCompositeBlks comp_blk_list
   if { $comp_blk_list != "" } \
   {
    PB_output_GetBlkObjAttr comp_blk_list add_obj_list blk_name_arr \
    blk_val_arr
    PB_PB2DEF_write_block_templates deff_id blk_name_arr blk_val_arr
    unset blk_name_arr blk_val_arr
   }
   if { $Post::($post_object,post_blk_list) != "" } \
   {
    set post_blk_list $Post::($post_object,post_blk_list)
    PB_output_GetBlkObjAttr post_blk_list add_obj_list blk_name_arr \
    blk_val_arr
    PB_PB2DEF_write_block_templates deff_id blk_name_arr blk_val_arr
    unset blk_name_arr blk_val_arr
   }
   if { $comment_blk_list != "" } \
   {
    PB_output_GetBlkObjAttr comment_blk_list add_obj_list blk_name_arr \
    blk_val_arr
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
   if { $list_blk_value != "" } \
   {
    PB_PB2DEF_write_block_templates deff_id blk_name_arr blk_val_arr
   }
   if {[info exists blk_name_arr]} \
   {
    unset blk_name_arr blk_val_arr
   }
  puts $deff_id "\}"
  foreach line $after_formatting \
  {
   puts $deff_id $line
  }
  close $deff_id
 }

#=======================================================================
proc PB_PB2TCL_write_sys_var_arr { TCLF_ID } {
  upvar $TCLF_ID tclf_id
  PB_output_GetMomSysVars sys_name_arr sys_val_arr
  puts $tclf_id "########## SYSTEM VARIABLE DECLARATIONS ##############"
  set idxlist [array names sys_name_arr]
  foreach idx $idxlist \
  {
   puts $tclf_id "  set [format "%-40s  %-5s" $sys_name_arr($idx) \
   \"$sys_val_arr($idx)\"]"
  }
 }

#=======================================================================
proc PB_PB2TCL_write_kin_var_arr { TCLF_ID } {
  upvar $TCLF_ID tclf_id
  PB_output_GetMomKinVars kin_name_arr kin_val_arr
  puts $tclf_id "####### KINEMATIC VARIABLE DECLARATIONS ##############"
  set no_kinvars [array size kin_name_arr]
  for { set count 0 } { $count < $no_kinvars } { incr count } \
  {
   puts $tclf_id "  set [format "%-40s  %-5s" $kin_name_arr($count) \
   \"$kin_val_arr($count)\"]"
  }
 }

#=======================================================================
proc MY_PB_output_GetMomFlyVars {fly_name_arr fly_val_arr} {
  upvar $fly_name_arr name $fly_val_arr val
  global post_object
  array set mom_sys_var_arr $Post::($post_object,mom_sys_var_list)
  array set mom_kin_var_arr $Post::($post_object,mom_kin_var_list)
  set name(0)  "mom_fly_G_codes_per_block"
  set val(0) $mom_sys_var_arr(\$mom_sys_gcodes_per_block)
  set name(1)  "mom_fly_M_codes_per_block"
  set val(1)  $mom_sys_var_arr(\$mom_sys_mcodes_per_block)
  set name(2)  "mom_fly_use_rapid_at_max_fpm"
  if { $mom_sys_var_arr(\$rap_mode_trav_rate) } \
  {
   set val(2)  TRUE
  } else \
  {
   set val(2) FLASE
  }
  if { [info exists mom_sys_var_arr(\$cutcom_off_before_change)] } \
  {
   set name(5)  "mom_fly_cutcom_off_before_change"
   if { $mom_sys_var_arr(\$cutcom_off_before_change) } \
   {
    set val(5) TRUE
   } else \
   {
    set val(5) FALSE
   }
  }
  set name(6)  "mom_fly_machine_type"
  set val(6) $mom_kin_var_arr(mom_kin_machine_type)
  if {[info exists mom_kin_var_arr(mom_kin_4th_axis_direction)]} {
   set name(7) "mom_fly_4th_axis_direction"
   set val(7)  $mom_kin_var_arr(mom_kin_4th_axis_direction)
  }
  if {[info exists mom_kin_var_arr(mom_kin_5th_axis_direction)]} {
   set name(8) "mom_fly_5th_axis_direction"
   set val(8)  $mom_kin_var_arr(mom_kin_5th_axis_direction)
  }
  if {[info exists mom_kin_var_arr(mom_kin_independent_head)]} {
   set name(9) "mom_fly_independent_head"
   set val(9) $mom_kin_var_arr(mom_kin_independent_head) 
  }
  if {[info exists mom_kin_var_arr(mom_kin_dependent_head)]} {
   set name(10) "mom_fly_dependent_head"
   set val(10) $mom_kin_var_arr(mom_kin_dependent_head) 
  }
  if {[info exists mom_sys_var_arr(\$lathe_output_method)]} {
   set name(11) "mom_fly_lathe_output_method"
   set val(11) $mom_sys_var_arr(\$lathe_output_method) 
  }
  if {[info exists mom_sys_var_arr(\$rap_wrk_pln_chg)]} {
   set name(12) "mom_fly_work_plane_change"
   if { $mom_sys_var_arr(\$rap_wrk_pln_chg) } \
   {
    set val(12) TRUE
   } else \
   {
    set val(12) FALSE
   }
  }
 }

#=======================================================================
proc PB2TCL_read_fly_var {fly_name} {
  set fly_val ""
  MY_PB_output_GetMomFlyVars fly_name_arr fly_val_arr
  set idxlist [array names fly_name_arr]
  foreach idx $idxlist \
  {
   if {$fly_name_arr($idx) == "$fly_name"} \
   {
   set fly_val "$fly_val_arr($idx)" ; break}
  }
  return $fly_val
 }

#=======================================================================
proc PB_PB2TCL_write_local_procs { TCLF_ID } {
  upvar $TCLF_ID tclf_id
  set cur_machine [PB2TCL_read_fly_var mom_fly_machine_type]
  set fourth_dirn [PB2TCL_read_fly_var mom_fly_4th_axis_direction]
  set fifth_dirn [PB2TCL_read_fly_var mom_fly_5th_axis_direction]
  set ind_head [PB2TCL_read_fly_var mom_fly_independent_head]
  set dep_head [PB2TCL_read_fly_var mom_fly_dependent_head]
  set lathe_output_method [PB2TCL_read_fly_var mom_fly_lathe_output_method] ; #TOOL_TIP/TURRET_REF
  puts $tclf_id "\n"
  puts $tclf_id "#============================================================="

#=======================================================================
puts $tclf_id "proc MOM_start_of_program \{ \} \{"
  puts $tclf_id "#============================================================="
  puts $tclf_id "  global mom_logname mom_date is_from"
  puts $tclf_id "  global mom_coolant_status mom_cutcom_status"
  puts $tclf_id "  global mom_clamp_status mom_cycle_status"
  puts $tclf_id "  global mom_spindle_status mom_cutcom_plane"
  puts $tclf_id "  global mom_cutcom_adjust_register mom_tool_adjust_register"
  puts $tclf_id "  global mom_tool_length_adjust_register mom_length_comp_register"
  puts $tclf_id "  global mom_flush_register mom_wire_cutcom_adjust_register"
  puts $tclf_id "  set mom_coolant_status UNDEFINED"
  puts $tclf_id "  set mom_cutcom_status  UNDEFINED"
  puts $tclf_id "  set mom_clamp_status   UNDEFINED"
  puts $tclf_id "  set mom_cycle_status   UNDEFINED"
  puts $tclf_id "  set mom_spindle_status UNDEFINED"
  puts $tclf_id "  set mom_cutcom_plane   UNDEFINED"
  puts $tclf_id "  catch \{unset mom_cutcom_adjust_register\}"
  puts $tclf_id "  catch \{unset mom_tool_adjust_register\}"
  puts $tclf_id "  catch \{unset mom_tool_length_adjust_register\}"
  puts $tclf_id "  catch \{unset mom_length_comp_register\}"
  puts $tclf_id "  catch \{unset mom_flush_register\}"
  puts $tclf_id "  catch \{unset mom_wire_cutcom_adjust_register\}"
  puts $tclf_id "  set is_from \"\""
  puts $tclf_id "  OPEN_files ; #open warning and listing files"
  puts $tclf_id "  LIST_FILE_HEADER ; #list header in commentary listing"
 puts $tclf_id "\}"
 if {$fourth_dirn == "SIGN_DETERMINES_DIRECTION" || $fifth_dirn == "SIGN_DETERMINES_DIRECTION"} {
  puts $tclf_id "\n"
  puts $tclf_id "#============================================================="

#=======================================================================
puts $tclf_id "proc  ROTARY_SIGN_SET \{ \} \{"
  puts $tclf_id "#============================================================="
  puts $tclf_id "  global mom_sys_leader"
  puts $tclf_id "  global mom_out_angle_pos"
  puts $tclf_id "  global mom_rotary_direction_4th"
  puts $tclf_id "  global mom_rotary_direction_5th"
  if {$fourth_dirn == "SIGN_DETERMINES_DIRECTION"} {
   puts $tclf_id " "
   puts $tclf_id "  set mom_out_angle_pos(0) \[expr abs(\$mom_out_angle_pos(0))\]"
   puts $tclf_id "  set mom_sys_leader(fourth_axis) \[string trimright \$mom_sys_leader(fourth_axis) \"-\"\]"
   puts $tclf_id " "
   puts $tclf_id "  if \{\$mom_rotary_direction_4th < 0\} \{"
    puts $tclf_id "    if \{\[EQ_is_zero \$mom_out_angle_pos(0)\]\} \{"
     puts $tclf_id "      append mom_sys_leader(fourth_axis) \"-\""
     puts $tclf_id "    \} else \{"
     puts $tclf_id "      set mom_out_angle_pos(0) \[expr -\$mom_out_angle_pos(0)\]"
    puts $tclf_id "    \}"
   puts $tclf_id "  \}"
  }
  if {$fifth_dirn == "SIGN_DETERMINES_DIRECTION"} {
   puts $tclf_id " "
   puts $tclf_id "  set mom_out_angle_pos(1) \[expr abs(\$mom_out_angle_pos(1))\]"
   puts $tclf_id "  set mom_sys_leader(fifth_axis) \[string trimright \$mom_sys_leader(fifth_axis) \"-\"\]"
   puts $tclf_id " "
   puts $tclf_id "  if \{\$mom_rotary_direction_5th < 0\} \{"
    puts $tclf_id "    if \{\[EQ_is_zero \$mom_out_angle_pos(1)\]\} \{"
     puts $tclf_id "      append mom_sys_leader(fifth_axis) \"-\""
     puts $tclf_id "    \} else \{"
     puts $tclf_id "      set mom_out_angle_pos(1) \[expr -\$mom_out_angle_pos(1)\]"
    puts $tclf_id "    \}"
   puts $tclf_id "  \}"
  }
 puts $tclf_id "\}"
}
if {$ind_head != "NONE" && $ind_head != ""} {
 puts $tclf_id "\n"
 puts $tclf_id "#============================================================="

#=======================================================================
puts $tclf_id "proc  TURRET_HEAD_SET \{ \} \{"
  puts $tclf_id "#============================================================="
  puts $tclf_id "  global mom_kin_independent_head mom_tool_head"
  puts $tclf_id "  global turret_current mom_warning_info"
  puts $tclf_id "  set turret_current INDEPENDENT"
  puts $tclf_id "  if \{\$mom_tool_head != \$mom_kin_independent_head\} \{"
   puts $tclf_id "    set turret_current DEPENDENT"
  puts $tclf_id "  \}"
  puts $tclf_id "  if \{\$mom_tool_head != \"$ind_head\" && \\"
   puts $tclf_id "       \$mom_tool_head != \"$dep_head\"\} \{"
   puts $tclf_id "    set mom_warning_info \"\$mom_tool_head IS INVALID, USING $dep_head\""
   puts $tclf_id "    MOM_catch_warning"
  puts $tclf_id "  \}"
 puts $tclf_id "\}"
}
if {$cur_machine == "lathe"} {
 puts $tclf_id "\n"
 puts $tclf_id "#============================================================="

#=======================================================================
puts $tclf_id "proc  LATHE_THREAD_SET \{ \} \{"
  puts $tclf_id "#============================================================="
  puts $tclf_id "  global mom_lathe_thread_type mom_lathe_thread_advance_type"
  puts $tclf_id "  global mom_lathe_thread_lead_i mom_lathe_thread_lead_k"
  puts $tclf_id "  global mom_motion_distance"
  puts $tclf_id "  global mom_lathe_thread_increment mom_lathe_thread_value"
  puts $tclf_id "  global thread_type thread_increment feed_rate_mode"
  puts $tclf_id "  switch \$mom_lathe_thread_advance_type \{"
   puts $tclf_id "    1 \{set thread_type CONSTANT ; MOM_suppress once E\}"
   puts $tclf_id "    2 \{set thread_type INCREASING ; MOM_force once E\}"
   puts $tclf_id "    default \{set thread_type DECREASING ; MOM_force once E\}"
  puts $tclf_id "  \}"
  puts $tclf_id "  if \{\$thread_type == \"INCREASING\" || \$thread_type == \"DECREASING\"\} \{"
   puts $tclf_id "    if \{\$mom_lathe_thread_type != 1\} \{"
    puts $tclf_id "      set LENGTH \$mom_motion_distance"
    puts $tclf_id "      set LEAD \$mom_lathe_thread_value"
    puts $tclf_id "      set INCR \$mom_lathe_thread_increment"
    puts $tclf_id "      set E \[expr abs(pow((\$LEAD + (\$INCR \* \$LENGTH)) , 2) - pow(\$LEAD , 2)) \/ 2 \* \$LENGTH\]"
    puts $tclf_id "      set thread_increment \$E"
   puts $tclf_id "    \}"
  puts $tclf_id "  \}"
  puts $tclf_id "  if \{\$mom_lathe_thread_lead_i == 0\} \{"
   puts $tclf_id "    MOM_suppress once I ; MOM_force once K"
   puts $tclf_id "  \} elseif \{\$mom_lathe_thread_lead_k == 0\} \{"
   puts $tclf_id "    MOM_suppress once K ; MOM_force once I"
   puts $tclf_id "  \} else \{"
   puts $tclf_id "    MOM_force once I ; MOM_force once K"
  puts $tclf_id "  \}"
 puts $tclf_id "\}"
}
puts $tclf_id "\n"
puts $tclf_id "#============================================================="

#=======================================================================
puts $tclf_id "proc  DELAY_TIME_SET \{ \} \{"
  puts $tclf_id "#============================================================="
  puts $tclf_id "  global mom_sys_delay_param mom_delay_value"
  puts $tclf_id "  global mom_delay_revs mom_delay_mode delay_time"
  puts $tclf_id "  #post builder provided format for the current mode:"
  puts $tclf_id "  if \{\[info exists mom_sys_delay_param(\$\{mom_delay_mode\},FORMAT)\] != 0\} \{"
   puts $tclf_id "    MOM_set_address_format dwell \$mom_sys_delay_param(\$\{mom_delay_mode\},FORMAT)"
  puts $tclf_id "  \}"
  puts $tclf_id "  switch \$mom_delay_mode \{"
   puts $tclf_id "    SECONDS \{set delay_time \$mom_delay_value\}"
   puts $tclf_id "    default \{set delay_time \$mom_delay_revs\}"
  puts $tclf_id "  \}"
 puts $tclf_id "\}"
 puts $tclf_id "\n"
 puts $tclf_id "#============================================================="

#=======================================================================
puts $tclf_id "proc  MOM_before_motion \{ \} \{"
  puts $tclf_id "#============================================================="
  puts $tclf_id "  global mom_motion_event mom_motion_type"
  puts $tclf_id "  FEEDRATE_SET"
  if {$lathe_output_method == "TURRET_REF"} {
   puts $tclf_id "  set mom_pos(0) \$mom_ref_pos(0)"
   puts $tclf_id "  set mom_pos(1) \$mom_ref_pos(1)"
   puts $tclf_id "  set mom_pos(2) \$mom_ref_pos(2)"
   puts $tclf_id "  switch \$mom_motion_event \{"
    puts $tclf_id "    circular_move \{"
     puts $tclf_id "      if \{\[hiset mom_ref_pos_arc_center(0)\]\} \{set mom_pos_arc_center(0) \$mom_ref_pos_arc_center(0)\}"
     puts $tclf_id "      if \{\[hiset mom_ref_pos_arc_center(1)\]\} \{set mom_pos_arc_center(1) \$mom_ref_pos_arc_center(1)\}"
     puts $tclf_id "      if \{\[hiset mom_ref_pos_arc_center(2)\]\} \{set mom_pos_arc_center(2) \$mom_ref_pos_arc_center(2)\}"
    puts $tclf_id "    \}"
    puts $tclf_id "    from_move \{"
     puts $tclf_id "      if \{\[hiset mom_from_ref_pos(0)\]\} \{set mom_from_pos(0) \$mom_from_ref_pos(0)\}"
     puts $tclf_id "      if \{\[hiset mom_from_ref_pos(1)\]\} \{set mom_from_pos(1) \$mom_from_ref_pos(1)\}"
     puts $tclf_id "      if \{\[hiset mom_from_ref_pos(2)\]\} \{set mom_from_pos(2) \$mom_from_ref_pos(2)\}"
    puts $tclf_id "    \}"
    puts $tclf_id "    gohome_move \{"
     puts $tclf_id "      if \{\[hiset mom_gohome_ref_pos(0)\]\} \{set mom_gohome_pos(0) \$mom_gohome_ref_pos(0)\}"
     puts $tclf_id "      if \{\[hiset mom_gohome_ref_pos(1)\]\} \{set mom_gohome_pos(1) \$mom_gohome_ref_pos(1)\}"
     puts $tclf_id "      if \{\[hiset mom_gohome_ref_pos(2)\]\} \{set mom_gohome_pos(2) \$mom_gohome_ref_pos(2)\}"
    puts $tclf_id "    \}"
   puts $tclf_id "  \}"
  }
  puts $tclf_id "  switch \$mom_motion_type \{"
   puts $tclf_id "    ENGAGE \{PB_engage_move\}"
   puts $tclf_id "    APPROACH \{PB_approach_move\}"
   puts $tclf_id "    FIRSTCUT \{PB_first_cut\}"
  puts $tclf_id "  \}"
  puts $tclf_id "  if \{\[llength \[info commands PB_CMD_before_motion\]\]\} \{PB_CMD_before_motion\}"
 puts $tclf_id "\}"
 puts $tclf_id " set pb_start_of_program_flag 0"
 puts $tclf_id "\n"
 puts $tclf_id "#============================================================="
 puts $tclf_id "proc MOM_start_of_group \{\} \{"
  puts $tclf_id "#============================================================="
  puts $tclf_id "  global mom_sys_group_output mom_group_name group_level ptp_file_name"
  puts $tclf_id "  global mom_sys_seqnum_start mom_sys_seqnum_freq mom_sys_seqnum_incr"
  puts $tclf_id "  global pb_start_of_program_flag"
  puts $tclf_id "  if \{\[regexp NC_PROGRAM \$mom_group_name\] == 1\} \{set group_level 0 ; return\}"
  puts $tclf_id "  set mom_group_name \[string tolower \$mom_group_name\]"
  puts $tclf_id "  if \{\[hiset mom_sys_group_output\]\} \{ if \{\$mom_sys_group_output == \"OFF\"\} \{set group_level 0 ; return\}\}"
  puts $tclf_id "  if \{\[hiset group_level\]\} \{incr group_level\} else \{set group_level 1\}"
  puts $tclf_id "  if \{\$group_level > 1\} \{return\}"
  puts $tclf_id "  # reset sequence number; what do we reset the sequence number to?"
  puts $tclf_id "  if \{\[hiset mom_sys_seqnum_start\] && \[hiset mom_sys_seqnum_freq\] && \[hiset mom_sys_seqnum_incr\]\} \{"
   puts $tclf_id "    MOM_reset_sequence \$mom_sys_seqnum_start \$mom_sys_seqnum_incr \$mom_sys_seqnum_freq"
  puts $tclf_id "  \}"
  puts $tclf_id "  MOM_start_of_program ; PB_start_of_program ; set pb_start_of_program_flag 1"
 puts $tclf_id "\}"
 puts $tclf_id "\n"
 puts $tclf_id "#============================================================="

#=======================================================================
puts $tclf_id "proc MOM_machine_mode \{\} \{"
  puts $tclf_id "#============================================================="
  puts $tclf_id "  global pb_start_of_program_flag"
  puts $tclf_id "  if \{\$pb_start_of_program_flag == 0\} \{PB_start_of_program ; set pb_start_of_program_flag 1\}"
 puts $tclf_id "\}"
}

#=======================================================================
proc PB_PB2TCL_write_tcl_procs { TCLF_ID } {
  upvar $TCLF_ID tclf_id
  puts $tclf_id "############## EVENT HANDLING SECTION ################"
  PB_output_GetEvtObjAttr evt_name_list evt_blk_arr
  PB_output_RetBlksModality blk_mod_arr
  foreach event_name $evt_name_list \
  {
   PB_output_GetEventProcData event_name evt_blk_arr($event_name) \
   blk_mod_arr event_output
   PB_PB2TCL_write_event_procs tclf_id event_output
   unset event_output
  }
 }

#=======================================================================
proc PB_PB2TCL_write_event_procs { TCLF_ID EVENT_OUTPUT } {
  upvar $TCLF_ID tclf_id
  upvar $EVENT_OUTPUT event_output
  foreach line $event_output \
  {
   puts $tclf_id "$line"
  }
 }

#=======================================================================
proc PB_output_DefaultDataAEvent { EVT_NAME EVENT_OUTPUT } {
  upvar $EVENT_OUTPUT event_output
  upvar $EVT_NAME evt_name
  global cycle_init_flag
  set cur_machine [PB2TCL_read_fly_var mom_fly_machine_type]
  set ind_head [PB2TCL_read_fly_var mom_fly_independent_head]
  set cycle_init_flag FALSE
  switch $evt_name \
  {
   MOM_thread              -
   MOM_lathe_thread        -
   MOM_drill_text          -
   MOM_drill               -
   MOM_drill_dwell         -
   MOM_drill_counter_sink  -
   MOM_drill_csink_dwell   -
   MOM_drill_deep          -
   MOM_drill_break_chip    -
   MOM_tap                 -
   MOM_bore                -
   MOM_bore_dwell          -
   MOM_bore_drag           -
   MOM_bore_no_drag        -
   MOM_bore_back           -
   MOM_bore_manual         -
   MOM_bore_manual_dwell  \
   {
    lappend event_output "  global cycle_name"
    lappend event_output "  global cycle_init_flag"
    append event_move $evt_name _move
    set cycle_name [string toupper [string trimleft $evt_name MOM_]]
    set cycle_init_flag TRUE
    lappend event_output "  set cycle_init_flag $cycle_init_flag"
    lappend event_output "  set cycle_name $cycle_name"
    if {$evt_name != "MOM_thread" && $evt_name != "MOM_lathe_thread"} {
     lappend event_output "  CYCLE_SET"
    }
   lappend event_output "\}"
   lappend event_output "\n"
   lappend event_output "#============================================================="

#=======================================================================
lappend event_output "proc  $event_move \{ \} \{"
  lappend event_output "#============================================================="
  lappend event_output "  global cycle_init_flag "
  if {$evt_name == "MOM_thread" || $evt_name == "MOM_lathe_thread"} {
   lappend event_output "  LATHE_THREAD_SET"
  }
  unset event_move
 }
 MOM_thread_move         -
 MOM_lathe_thread_move   \
 {
  lappend event_output "  LATHE_THREAD_SET"
 }
 MOM_circular_move \
 {
  if {$cur_machine != "lathe"} {
   lappend event_output "  CIRCLE_SET"
  }
 }
 MOM_from_move \
 {
  lappend event_output "  global mom_feed_rate mom_feed_rate_per_rev \
  mom_motion_type mom_kin_max_fpm"
  lappend event_output "  COOLANT_SET ; CUTCOM_SET ; SPINDLE_SET ; RAPID_SET ; \
  MODES_SET"
 }
 MOM_first_move -
 MOM_initial_move \
 {
  lappend event_output "  global mom_feed_rate mom_feed_rate_per_rev mom_motion_type \
  mom_kin_max_fpm"
  lappend event_output "  global is_from"
  lappend event_output "  COOLANT_SET ; CUTCOM_SET ; SPINDLE_SET ; RAPID_SET ; \
  MODES_SET"
 }
 MOM_linear_move \
 {
  lappend event_output "  global mom_feed_rate mom_feed_rate_per_rev mom_kin_max_fpm first_linear_move"
  if {[PB2TCL_read_fly_var mom_fly_use_rapid_at_max_fpm] == "TRUE"} \
  {
   lappend event_output "  if \{\[info exists mom_kin_max_fpm\] != 0\} \{"
    lappend event_output "    if \{\$mom_feed_rate >= \$mom_kin_max_fpm\} \
    \{MOM_rapid_move ; return\}"
   lappend event_output "  \}"
  }
  lappend event_output "  if \{!\$first_linear_move\} \{PB_first_linear_move ; incr first_linear_move\}"
 }
 MOM_coolant_on  { lappend event_output "  COOLANT_SET" }
 MOM_coolant_off { lappend event_output "  COOLANT_SET" }
 MOM_cutcom_off  { lappend event_output "  CUTCOM_SET" }
 MOM_cutcom_on  \
 {
  if {[PB2TCL_read_fly_var mom_fly_cutcom_off_before_change] == "TRUE"} \
  {
   lappend event_output "  global mom_cutcom_status"
   lappend event_output "  if \{ \$mom_cutcom_status != \"SAME\"\} \{MOM_cutcom_off\}"
  }
  lappend event_output "  CUTCOM_SET"
 }
 MOM_spindle_rpm   -
 MOM_spindle_css   { lappend event_output "  SPINDLE_SET" }
 MOM_tool_preselect \
 {
  lappend event_output "  global mom_tool_preselect_number mom_tool_number mom_next_tool_number"
  lappend event_output "  if \{\[info exists mom_tool_preselect_number\]\} \{"
   lappend event_output "    set mom_next_tool_number \$mom_tool_preselect_number"
  lappend event_output "  \}"
 }
 MOM_opskip  { lappend event_output "  OPSKIP_SET" }
 MOM_rapid_move \
 {
  lappend event_output "  global rapid_spindle_inhibit rapid_traverse_inhibit"
  lappend event_output "  global spindle_first is_from"
  lappend event_output "  global mom_cycle_spindle_axis traverse_axis1 traverse_axis2"
  lappend event_output "  set aa(0) X ; set aa(1) Y ; set aa(2) Z"
  lappend event_output "  RAPID_SET"
 }
 MOM_sequence_number   { lappend event_output "  SEQNO_SET" }
 MOM_set_modes         { lappend event_output "  MODES_SET" }
 MOM_length_compensation {lappend event_output "  TOOL_SET $evt_name"}
 MOM_start_of_path     \
 {
  lappend event_output "  global first_linear_move ; set first_linear_move 0"
  lappend event_output "  TOOL_SET $evt_name"
 }
 MOM_load_tool         -
 MOM_first_tool        -
 MOM_tool_change       \
 {
  lappend event_output "  global mom_tool_change_type mom_manual_tool_change"
  if {$ind_head != "NONE" && $ind_head != ""} {
   lappend event_output "  TURRET_HEAD_SET"
  }
 }
 MOM_delay \
 {
  lappend event_output "  DELAY_TIME_SET"
 }
 MOM_cycle_plane_change \
 {
  lappend event_output "  global cycle_init_flag"
  set cycle_init_flag TRUE
  lappend event_output "  set cycle_init_flag $cycle_init_flag"
 }
}
}

#=======================================================================
proc PB_output_BlockOfAEvent { EVT_NAME EVT_BLOCKS BLK_MOD_ARR NO_OF_LISTS \
  EVENT_OUTPUT } {
  upvar $EVT_NAME evt_name
  upvar $EVT_BLOCKS evt_blocks   ; #array of list of blocks for the event
  upvar $BLK_MOD_ARR blk_mod_arr ; #blk_mod_arr($block_name)
  upvar $NO_OF_LISTS no_of_lists
  upvar $EVENT_OUTPUT event_output
  global cycle_init_flag
  set cur_machine [PB2TCL_read_fly_var mom_fly_machine_type]
  set fourth_dirn [PB2TCL_read_fly_var mom_fly_4th_axis_direction]
  set fifth_dirn [PB2TCL_read_fly_var mom_fly_5th_axis_direction]
  set is_done1 0 ; set is_done2 0
  set move_event [string last "move" $evt_name]
  if {$move_event != -1} {
   if {$fourth_dirn == "SIGN_DETERMINES_DIRECTION" || $fifth_dirn == "SIGN_DETERMINES_DIRECTION"} {
    lappend event_output "  ROTARY_SIGN_SET"
   }
  }
  switch [PB2TCL_read_fly_var mom_fly_machine_type] {
   3_axis_mill -
   4_axis_head -
   4_axis_table -
   5_axis_dual_table -
   5_axis_dual_head -
   5_axis_head_table {
    set cur_machine mill
   }
  }
  set last_list [expr $no_of_lists - 1]
  if {$last_list} \
  {
   set pre_list [expr $last_list - 1]
  } else \
  {
   set pre_list $last_list
  }
  for { set jj 0 } { $jj <= $last_list } { incr jj } \
  {
   set sublist [lindex $evt_blocks $jj]
   set ii [llength $sublist]
   if {$ii <= 0} {continue} ; #sublist is empty
   for {set kk 0} {$kk < $ii} {incr kk} \
   {
    set block_name [lindex $sublist $kk]
    set isupper [regexp {^[A-Z]+} $block_name] ;
    switch $isupper \
    {
     1  { lappend event_output "  $block_name" }
     default \
     {
      switch $evt_name \
      {
       MOM_rapid_move \
       {
        if {[info exists blk_mod_arr($block_name)]} \
        {
         if {[llength $blk_mod_arr($block_name)] > 0} \
         {
          lappend event_output "  MOM_force Once $blk_mod_arr($block_name)"
         }
        }
        if {$cur_machine == "mill" && [PB2TCL_read_fly_var mom_fly_work_plane_change] == "TRUE"} \
        {
         lappend event_output "  set spindle_block rapid_spindle"
         lappend event_output "  set traverse_block rapid_traverse"
         lappend event_output "  if \{\$spindle_first == \"TRUE\"\} \{"
          lappend event_output "  if \{\$rapid_spindle_inhibit == \"FALSE\"\} \{"
           lappend event_output \
           "          MOM_suppress once \$aa(\$traverse_axis1) \$aa(\$traverse_axis2)"
           lappend event_output "       MOM_do_template \$spindle_block \$is_from"
           lappend event_output \
           "          MOM_suppress off \$aa(\$traverse_axis1) \$aa(\$traverse_axis2)"
          lappend event_output "    \}"
          lappend event_output "    if \{\$rapid_traverse_inhibit == \"FALSE\"\} \{"
           lappend event_output "       MOM_suppress once \$aa(\$mom_cycle_spindle_axis)"
           lappend event_output "       MOM_do_template \$traverse_block \$is_from"
           lappend event_output "       MOM_suppress off \$aa(\$mom_cycle_spindle_axis)"
          lappend event_output "    \}"
          lappend event_output "  \} elseif \{\$spindle_first == \"FALSE\"\} \{"
          lappend event_output "    if \{\$rapid_traverse_inhibit == \"FALSE\"\} \{"
           lappend event_output "       MOM_suppress once \$aa(\$mom_cycle_spindle_axis)"
           lappend event_output "       MOM_do_template \$traverse_block \$is_from"
           lappend event_output "       MOM_suppress off \$aa(\$mom_cycle_spindle_axis)"
          lappend event_output "    \}"
          lappend event_output "    if \{\$rapid_spindle_inhibit == \"FALSE\"\} \{"
           lappend event_output \
           "       MOM_suppress once \$aa(\$traverse_axis1) \$aa(\$traverse_axis2)"
           lappend event_output "       MOM_do_template \$spindle_block \$is_from"
           lappend event_output \
           "       MOM_suppress off \$aa(\$traverse_axis1) \$aa(\$traverse_axis2)"
          lappend event_output "    \}"
          lappend event_output "  \} else \{"
          lappend event_output "       MOM_do_template \$traverse_block \$is_from"
         lappend event_output "  \}"
         set is_done1 1
        }
       }
      }
      if {!$is_done1} \
      {
       switch $evt_name \
       {
        MOM_start_of_program \
        {
         if {[info exists blk_mod_arr($block_name)]} \
         {
          if {[llength $blk_mod_arr($block_name)] > 0} \
          {
           lappend event_output "  MOM_force Once $blk_mod_arr($block_name)"
          }
         }
         lappend event_output "  MOM_do_template $block_name"
         set is_done2 1
        }
        MOM_start_of_path    -
        MOM_return_motion    -
        MOM_end_of_path      -
        MOM_end_of_program   \
        {
         if {[info exists blk_mod_arr($block_name)]} \
         {
          if {[llength $blk_mod_arr($block_name)] > 0} \
          {
           lappend event_output "  MOM_force Once $blk_mod_arr($block_name)"
          }
         }
         lappend event_output "  MOM_do_template $block_name"
         set is_done2 1
        }
        default \
        {
         if {$jj <= $pre_list && [llength [lindex $evt_blocks $jj]] > 0} \
         {
          if {$kk == 0 && $cycle_init_flag == "TRUE"} \
          {
           if {$pre_list != $last_list} \
           {
            lappend event_output "  if \{ \$cycle_init_flag == \"TRUE\" \} \{"
             lappend event_output "    set cycle_init_flag FALSE"
            }
           }
           if {[info exists blk_mod_arr($block_name)]} \
           {
            if {[llength $blk_mod_arr($block_name)] > 0} \
            {
             lappend event_output "   MOM_force Once $blk_mod_arr($block_name)"
            }
           }
           lappend event_output "    MOM_do_template $block_name"
           if {$kk == [expr $ii - 1] && $pre_list != $last_list} \
           {
           lappend event_output "  \}"
          }
          set is_done2 1
         } \
         elseif {$jj == $last_list && [llength [lindex $evt_blocks $jj]] > 0} \
         {
          if {[info exists blk_mod_arr($block_name)]} \
          {
           if {[llength $blk_mod_arr($block_name)] > 0} \
           {
            lappend event_output "  MOM_force Once $blk_mod_arr($block_name)"
           }
          }
          lappend event_output "  MOM_do_template $block_name"
          set is_done2 1
         }
        }
       }
      }
     }
    }
    if {$is_done1} {break}
   }
  }
  if {!$is_done1 && !$is_done2} \
  {
   switch $evt_name \
   {
    MOM_first_tool    -
    MOM_tool_change   \
    {
     lappend event_output "  if \{\[info exists mom_tool_change_type\]\} \{"
      lappend event_output "    switch \$mom_tool_change_type \{"
       lappend event_output "         MANUAL \{ PB_manual_tool_change \}"
       lappend event_output "         AUTO   \{ PB_auto_tool_change \}"
      lappend event_output "    \}"
      lappend event_output "  \} elseif \{\[info exists mom_manual_tool_change\]\} \{"
      lappend event_output "    if \{\$mom_manual_tool_change == \"TRUE\"\} \{"
       lappend event_output "        PB_manual_tool_change"
      lappend event_output "    \}"
     lappend event_output "  \}"
    }
    MOM_gohome_move {lappend event_output "  MOM_rapid_move"}
   }
  }
  switch $evt_name \
  {
   MOM_first_move   -
   MOM_initial_move \
   {
    if {[PB2TCL_read_fly_var mom_fly_use_rapid_at_max_fpm] == "TRUE"} \
    {
     lappend event_output "  if \{\[info exists mom_kin_max_fpm\] != 0\} \{"
      lappend event_output "    if \{\$mom_feed_rate >= \$mom_kin_max_fpm\} \
      \{MOM_rapid_move ; return\}\}"
    }
    lappend event_output \
    "  if \{\$mom_motion_type == \"RAPID\"\} \{MOM_rapid_move\} else \{MOM_linear_move\}"
   }
   MOM_end_of_program \
   {
    lappend event_output "#**** The following procedure lists the tool \
    list with time in commentary data"
    lappend event_output "  LIST_FILE_TRAILER"
    lappend event_output "#**** The following procedure closes the warning and listing files"
    lappend event_output "  CLOSE_files"
   }
  }
 }

#=======================================================================
proc PB_output_GetEventProcData { EVT_NAME EVT_BLOCKS BLK_MOD_ARR EVENT_OUTPUT } {
  upvar $EVT_NAME evt_name
  upvar $EVT_BLOCKS evt_blocks   ; #array of list of blocks for the event
  upvar $BLK_MOD_ARR blk_mod_arr ; #blk_mod_arr($block_name)
  upvar $EVENT_OUTPUT event_output
  lappend event_output "\n"
  lappend event_output "#============================================================="

#=======================================================================
lappend event_output "proc $evt_name \{ \} \{"
  lappend event_output "#============================================================="
  PB_output_DefaultDataAEvent evt_name event_output
  set no_of_lists [llength $evt_blocks]
  if {$no_of_lists > 0} \
  {
   PB_output_BlockOfAEvent evt_name evt_blocks blk_mod_arr \
   no_of_lists event_output
  }
 lappend event_output "\}"
}

#=======================================================================
proc PB_PB2TCL_write_Command_procs { TCLF_ID } {
  upvar $TCLF_ID tclf_id
  PB_output_GetCmdBlkProcs cmd_blk_list cmd_proc_arr
  foreach cmd_blk $cmd_blk_list \
  {
   set evt_name $cmd_blk
   puts $tclf_id "\n"
   puts $tclf_id "#============================================================="

#=======================================================================
puts $tclf_id "proc $evt_name \{ \} \{"
  puts $tclf_id "#============================================================="
  foreach line $cmd_proc_arr($cmd_blk) \
  {
   puts $tclf_id "   $line"
  }
 puts $tclf_id "\}"
}
}

#=======================================================================
proc PB_PB2TCL_write_list_file_var { TCLF_ID } {
  upvar $TCLF_ID tclf_id
  puts $tclf_id "####  Listing File variables "
  PB_output_GetListFileVars list_name_arr list_val_arr
  if { [info exists list_name_arr] } \
  {
   set arr_size 0
   set arr_size [array size list_name_arr]
   for { set count 0 } { $count < $arr_size } { incr count } \
   {
    puts $tclf_id  "  set [format "%-40s  %-5s" $list_name_arr($count) \
    $list_val_arr($count)]"
   }
  }
 }

#=======================================================================
proc PB_PB2TCL_write_reviewtool { TCLF_ID } {
  upvar $TCLF_ID tclf_id
  global post_object
  set list_file $Post::($post_object,list_obj_list)
  if { $ListingFile::($list_file,review) } \
  {
   puts $tclf_id " source \${cam_debug_dir}mom_review.tcl"
   puts $tclf_id " MOM_set_debug_mode ON"
  } else \
  {
   puts $tclf_id "# source \${cam_debug_dir}mom_review.tcl"
   puts $tclf_id "  MOM_set_debug_mode OFF"
  }
 }

#=======================================================================
proc PB_PB2TCL_main { OUTPUT_TCL_FILE } {
  upvar $OUTPUT_TCL_FILE tcl_file
  global log_data
  global env
  set tclf_id [open "$tcl_file" w]
  puts $tclf_id "############ TCL FILE ######################################"
  puts $tclf_id "# USER AND DATE STAMP"
  puts $tclf_id "############################################################"
  puts $tclf_id ""
  puts $tclf_id "  set cam_post_dir \[MOM_ask_env_var UGII_CAM_POST_DIR\]"
  puts $tclf_id "  set cam_debug_dir \[MOM_ask_env_var UGII_CAM_DEBUG_DIR\]"
  puts $tclf_id "  source \${cam_post_dir}/ugpost_base.tcl"
  PB_PB2TCL_write_reviewtool tclf_id
  puts $tclf_id ""
  PB_PB2TCL_write_sys_var_arr tclf_id
  puts $tclf_id ""
  PB_PB2TCL_write_kin_var_arr tclf_id
  puts $tclf_id ""
  PB_PB2TCL_write_list_file_var tclf_id
  puts $tclf_id ""
  puts $tclf_id ""
  PB_PB2TCL_write_local_procs tclf_id
  PB_PB2TCL_write_tcl_procs tclf_id
  PB_PB2TCL_write_Command_procs tclf_id
  close $tclf_id
 }
