#3
if 1 {
}
UI_PB_AddPatchMsg "2002.5.1" "<09-25-06>  Prevent unmounting stationary tool in PB_CMD_vnc__tool_change"
UI_PB_AddPatchMsg "2002.5.1" "<08-28-06>  Revised VNC_ask_shared_library_suffix to support MacOS."
UI_PB_AddPatchMsg "2002.5.1" "<08-24-06>  Comment out rewind-stop-code definition for new VNC."
UI_PB_AddPatchMsg "2002.0.0" "<03-18-03>  Corrected PB_ROTARY_SIGN_SET for xzc/mill-turn posts."
UI_PB_AddPatchMsg "2002.0.0" "<03-20-03>  Excluded RETRACT for WEDM in MOM_before_motion."

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
  $seq_param(2) $seq_param(3) $seq_param(4)"
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
   PB_adr_SetZeroFmt adr_obj_attr
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
   UI_PB_debug_ForceMsg "*** block name == $blk_name_arr($indx)"
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
     UI_PB_debug_ForceMsg "  *** add name == $add_obj  $add_name"
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
  PB_com_DeleteObject $x_blkelem
  PB_com_DeleteObject $y_blkelem
  PB_com_DeleteObject $z_blkelem
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
     UI_PB_debug_ForceMsg "*** $sequence::($seq_obj,seq_name) $event::($evt_obj,event_name) $no_of_rowelem"
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
      PB_int_GetAllBlockNames comp_blk_list comp_blk_name_list
      lappend $blk_name_list $comp_blk_name_list.
      PB_com_SetDefaultName blk_name_list blk_obj_attr
      UI_PB_debug_ForceMsg "**** $blk_name_list >$blk_obj_attr(0)<"
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
      lappend blk_obj_list $comp_blk_obj
      set first_elem_obj [lindex $evt_elem_row 0]
      set event_element::($first_elem_obj,evt_elem_name) $blk_obj_attr(0)
      UI_PB_debug_ForceMsg "***** composite blk name : $blk_obj_attr(0)"
     }
    }
   }
  }
 }

#=======================================================================
proc PB_output_GetMomSysVars { MOM_SYS_NAME_ARR MOM_SYS_VAL_ARR } {
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
  set add_name "PB_Spindle"
  if [info exists mom_sys_var_arr(\$mom_sys_spindle_ranges)] {
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
  }
  set add_name "PB_Tcl_Var"
  set word_mom_var_list($add_name) [ltidy $word_mom_var_list($add_name)]
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
   if { [string match "\$mom_sys_feed_param*format*" $var] || \
   [string match "\$mom_sys_delay_param*format*" $var] } \
   {
    set temp_list [split $var ,]
    set new_var [join $temp_list ",1_"]
    set mom_sys_name_arr($ind) [string trimleft $var \$]
    if [info exists mom_sys_var_arr($new_var)] \
    {
     set fmt_obj $mom_sys_var_arr($new_var)
    } else \
    {
     if [info exists mom_sys_var_arr($var)] \
     {
      set fmt_name $mom_sys_var_arr($var)
      PB_int_RetFmtObjFromName fmt_name fmt_obj
      set mom_sys_var_arr($new_var) $fmt_obj
     } else \
     {
      set fmt_obj 0
     }
    }
    if 0 {
     if { $fmt_obj } {
      set mom_sys_val_arr($ind) $format::($fmt_obj,for_name)
     }
    }
    if { $fmt_obj && [info exists format::($fmt_obj,for_name)] } {
     set mom_sys_val_arr($ind) $format::($fmt_obj,for_name)
    }
   } else \
   {
    if [string match "\$mom_sys_radius_output_mode*" $var] {
     set mom_sys_var_arr($var) [string toupper $mom_sys_var_arr($var)]
    }
    set mom_sys_name_arr($ind) [string trimleft $var \$]
    set mom_sys_val_arr($ind) $mom_sys_var_arr($var)
   }
   if [info exists mom_sys_val_arr($ind)] {
    if 0 {
     if { [string first $mom_sys_val_arr($ind) \\] != -1} \
     {
      set var_split [split $mom_sys_val_arr($ind) \\]
      set mom_sys_val_arr($ind) [join $var_split "\\\\"]
     }
    }
    set tmp_var [PB_output_EscapeSpecialControlChar $mom_sys_val_arr($ind)]
    if { [string first $tmp_var \\] != -1} \
    {
     set var_split [split $tmp_var \\]
     set tmp_var [join $var_split "\\\\"]
    }
    set mom_sys_val_arr($ind) $tmp_var
    incr ind
   }
  }
  set mom_sys_name_arr($ind) "mom_sys_control_out"
  set tmp_var [PB_output_EscapeSpecialControlChar $mom_sys_var_arr(Comment_Start)]
  set mom_sys_val_arr($ind) $tmp_var
  incr ind
  set mom_sys_name_arr($ind) "mom_sys_control_in"
  set tmp_var [PB_output_EscapeSpecialControlChar $mom_sys_var_arr(Comment_End)]
  set mom_sys_val_arr($ind) $tmp_var
  set Post::($post_object,mom_sys_var_list) [array get mom_sys_var_arr]
 }

#=======================================================================
proc PB_output_DoubleEscapeSpecialControlChar { s1 } {
  set s2 ""
  set len [string length $s1]
  for { set i 0 } { $i < $len } { incr i } {
   set c [string index $s1 $i]
   scan "$c" "%c" cv
   if { $i == 0 || $i == [expr $len - 1] } {
    if { $cv == 042 } {
     set s2 "$s2$c"
     continue
    }
   }
   if { $cv == 042  || \
    $cv == 044  || \
    $cv == 046  || \
    $cv == 050  || \
    $cv == 051  || \
    $cv == 073  || \
    $cv == 0133 || \
    $cv == 0134 || \
    $cv == 0135 || \
    $cv == 0173 || \
    $cv == 0174 || \
    $cv == 0175 } {
    set s2 "$s2\\\\\\"
   }
   set s2 "$s2$c"
  }
  return $s2
 }

#=======================================================================
proc PB_output_EscapeSpecialChars_for_VNC { s1 } {
  set s2 ""
  for { set i 0 } { $i < [string length $s1] } { incr i } {
   set c [string index $s1 $i]
   if { $c == "\""  || \
    $c == "\\"  || \
    $c == "\$"  || \
    $c == "\#"  || \
    $c == "\("  || \
    $c == "\)"  || \
    $c == "\["  || \
    $c == "\]"  || \
    $c == "\{"  || \
     $c == "\}" } {
    set s2 "$s2\\"
   }
   set s2 "$s2$c"
  }
  return $s2
 }

#=======================================================================
proc PB_output_EscapeSpecialControlChar { s1 } {
  set s2 ""
  for { set i 0 } { $i < [string length $s1] } { incr i } {
   set c [string index $s1 $i]
   if { $c == "\""  || \
    $c == "\\"  || \
    $c == "\$"  || \
    $c == "\#"  || \
    $c == "\["  || \
    $c == "\]"  || \
    $c == "\{"  || \
     $c == "\}" } {
    set s2 "$s2\\"
   }
   set s2 "$s2$c"
  }
  return $s2
 }

#=======================================================================
proc PB_output_EscapeSpecialControlChar_no_dollar { s1 } {
  set s2 ""
  for { set i 0 } { $i < [string length $s1] } { incr i } {
   set c [string index $s1 $i]
   if { $c == "\""  || \
    $c == "\\"  || \
    $c == "\#"  || \
    $c == "\["  || \
    $c == "\]"  || \
    $c == "\{"  || \
     $c == "\}" } {
    set s2 "$s2\\"
   }
   set s2 "$s2$c"
  }
  return $s2
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
   set list_name_arr(1) "mom_sys_header_output"
   set list_val_arr(1) "ON"
  } else \
  {
   set list_name_arr(0) "mom_sys_list_output"
   set list_val_arr(0) "OFF"
   set list_name_arr(1) "mom_sys_header_output"
   set list_val_arr(1) "OFF"
  }
  if 0 {
   if { $ListingFile::($listfile_obj,head) } \
   {
    set list_name_arr(1) "mom_sys_header_output"
    set list_val_arr(1) "ON"
   } else \
   {
    set list_name_arr(1) "mom_sys_header_output"
    set list_val_arr(1) "OFF"
   }
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
  PB_lfl_RetLfileBlock listfile_obj list_blk_value
  if { $list_blk_value == "" } \
  {
   set list_name_arr(8) "mom_sys_commentary_output"
   set list_val_arr(8)  "OFF"
  } else \
  {
   set list_name_arr(8) "mom_sys_commentary_output"
   set list_val_arr(8)  "ON"
  }
  set elem_list {x y z 4axis 5axis feed speed}
  set active_elem_list ""
  foreach elem $elem_list \
  {
   if { $ListingFile::($listfile_obj,$elem) } \
   {
    lappend active_elem_list $elem
   }
  }
  set list_name_arr(9) "mom_sys_commentary_list"
  set list_val_arr(9)  "$active_elem_list"
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
   set mom_kin_var_arr($mom_kin_var) \
   [PB_output_EscapeSpecialControlChar $mom_kin_var_arr($mom_kin_var)]
   set kin_val_arr($ind) $mom_kin_var_arr($mom_kin_var)
   incr ind
  }
 }

#=======================================================================
proc PB_output_GetMomSimVars { SIM_NAME_ARR SIM_VAL_ARR} {
  upvar $SIM_NAME_ARR sim_name_arr
  upvar $SIM_VAL_ARR sim_val_arr
  global post_object
  set ind 0
  array set mom_sim_var_arr $Post::($post_object,mom_sim_var_list)
  set mom_sim_name_list [array names mom_sim_var_arr]
  set mom_sim_name_list [lsort -dictionary $mom_sim_name_list]
  foreach mom_sim_var $mom_sim_name_list\
  {
   set sim_name_arr($ind) [string trimleft $mom_sim_var \$]
   set mom_sim_var_arr($mom_sim_var) \
   [PB_output_EscapeSpecialControlChar $mom_sim_var_arr($mom_sim_var)]
   set sim_val_arr($ind) $mom_sim_var_arr($mom_sim_var)
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
  if [info exists Post::($post_object,post_blk_list)] {
   set post_blk_list $Post::($post_object,post_blk_list)
   foreach post_blk $post_blk_list \
   {
    PB_blk_BlockModality post_blk blk_mod_adds
    set block_name $block::($post_blk,block_name)
    set blk_mod_arr($block_name) $blk_mod_adds
    UI_PB_debug_ForceMsg "Post Block : $block_name $blk_mod_adds"
   }
  }
  set comp_blk_list ""
  PB_output_GetCompositeBlks comp_blk_list
  foreach comp_blk $comp_blk_list \
  {
   PB_blk_BlockModality comp_blk blk_mod_adds
   set block_name $block::($comp_blk,block_name)
   set blk_mod_arr($block_name) $blk_mod_adds
   UI_PB_debug_DisplayMsg "Composit Block : $block_name"
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
  UI_PB_cmd_ImportVNCCmds
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
proc PB_output_GetEvtObjAttr { EVT_NAME_ARR EVT_BLK_ARR UDC_NAME_LIST} {
  upvar $EVT_NAME_ARR evt_name_list
  upvar $EVT_BLK_ARR evt_blk_arr
  upvar $UDC_NAME_LIST udc_name_list
  global post_object gPB machType
  set seq_obj_list $Post::($post_object,seq_obj_list)
  lappend in_sequence [lindex $seq_obj_list 0] [lindex $seq_obj_list 1] \
  [lindex $seq_obj_list 5]
  lappend out_sequence [lindex $seq_obj_list 2] [lindex $seq_obj_list 3] \
  [lindex $seq_obj_list 4]
  unset seq_obj_list
  lappend seq_obj_list $in_sequence $out_sequence
  if {$::env(PB_UDE_ENABLED) == 1} {
   set udeobj $Post::($post_object,ude_obj)
   set seqobj_cycle $ude::($udeobj,seq_obj_cycle)
   if [string match $machType "Mill"] {
    set udc_event_list $sequence::($seqobj_cycle,evt_obj_list)
    } else {
    set udc_event_list [list]
   }
   set udc_name_list [list]
   } else {
   set udc_event_list [list]
   set udc_name_list [list]
  }
  set evt_name_list ""
  foreach seq_list $seq_obj_list \
  {
   foreach seq_obj $seq_list \
   {
    set evt_obj_list $sequence::($seq_obj,evt_obj_list)
    foreach evt_obj $evt_obj_list \
    {
     if {[lsearch $udc_event_list $evt_obj] >= 0} {
      if {[lsearch $gPB(SYS_CYCLE) $event::($evt_obj,event_name)] >= 0} {
       continue
      }
     }
     set evt_blk_name_list ""
     set temp_event_name $event::($evt_obj,event_name)
     PB_com_GetPrefixOfEvent temp_event_name prefix
     set temp_event_name [string tolower $temp_event_name]
     set temp_evt_name [join [split $temp_event_name " "] _ ]
     append event_name $prefix _ $temp_evt_name
     if { $::env(PB_UDE_ENABLED) == 1 } {
      if {$sequence::($seq_obj,seq_name) == "Machine Control"} {
       if [info exists event::($evt_obj,ude_event_obj)] {
        set ueo $event::($evt_obj,ude_event_obj)
        set post_name $ude_event::($ueo,post_event)
        if {$post_name == ""} {
         set post_name $ude_event::($ueo,name)
        }
        set post_name ${prefix}_${post_name}
        if {$post_name != $event_name} {
         set event_name $post_name
        }
       }
      }
     }
     if { [lsearch $evt_name_list $event_name] == -1 } \
     {
      if {[lsearch $udc_event_list $evt_obj] >= 0} {
       if {[lsearch $gPB(SYS_CYCLE) $event::($evt_obj,event_name)] < 0} {
        lappend udc_name_list $event_name
        lappend evt_name_list $event_name
       }
       } else {
       lappend evt_name_list $event_name
      }
     }
     if 0 {
      switch $event_name \
      {
       "MOM_drill" {
        PB_output_RetCycleEvtBlkList evt_obj evt_blk_name_list
        if [info exists evt_blk_arr(MOM_drill)] {
         if {[lindex $evt_blk_name_list 0] != ""} {
          set temp_list [concat $evt_blk_arr(MOM_drill) $evt_blk_name_list]
          set evt_blk_arr(MOM_drill) $temp_list
          set temp_list [concat $evt_blk_arr(MOM_drill_dwell) $evt_blk_name_list]
          set evt_blk_arr(MOM_drill_dwell) $temp_list
         }
         } else {
         set evt_blk_arr(MOM_drill) $evt_blk_name_list
        }
       }
       "MOM_drill_deep" {
        PB_output_RetCycleEvtBlkList evt_obj evt_blk_name_list
        if [info exists evt_blk_arr(MOM_drill_deep)] {
         if {[lindex $evt_blk_name_list 0] != ""} {
          set temp_list [concat $evt_blk_arr(MOM_drill_deep) $evt_blk_name_list]
          set evt_blk_arr(MOM_drill_deep) $temp_list
         }
         } else {
         set evt_blk_arr(MOM_drill_deep) $evt_blk_name_list
        }
       }
       "MOM_drill_dwell" -
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
       "MOM_drill_csink" {
        PB_output_RetCycleEvtBlkList evt_obj evt_blk_name_list
        if [info exists evt_blk_arr(MOM_drill)] {
         if {[lindex $evt_blk_name_list 0] != ""} {
          set temp_list [concat $evt_blk_arr(MOM_drill) $evt_blk_name_list]
          set evt_blk_arr(MOM_drill) $temp_list
         }
         } else {
         set evt_blk_arr(MOM_drill) $evt_blk_name_list
        }
        if [info exists evt_blk_arr(MOM_drill_dwell)] {
         if {[lindex $evt_blk_name_list 0] != ""} {
          set temp_list [concat $evt_blk_arr(MOM_drill_dwell) $evt_blk_name_list]
          set evt_blk_arr(MOM_drill_dwell) $temp_list
         }
         } else {
         set evt_blk_arr(MOM_drill_dwell) $evt_blk_name_list
        }
       }
       "MOM_drill_deep_breakchip" {
        PB_output_RetCycleEvtBlkList evt_obj evt_blk_name_list
        if [info exists evt_blk_arr(MOM_drill_break_chip)] {
         if {[lindex $evt_blk_name_list 0] != ""} {
          set temp_list [concat $evt_blk_arr(MOM_drill_break_chip) $evt_blk_name_list]
          set evt_blk_arr(MOM_drill_break_chip) $temp_list
         }
         } else {
         set evt_blk_arr(MOM_drill_break_chip) $evt_blk_name_list
        }
       }
       "MOM_drill_tap" {
        PB_output_RetCycleEvtBlkList evt_obj evt_blk_name_list
        if [info exists evt_blk_arr(MOM_tap)] {
         if {[lindex $evt_blk_name_list 0] != ""} {
          set temp_list [concat $evt_blk_arr(MOM_tap) $evt_blk_name_list]
          set evt_blk_arr(MOM_tap) $temp_list
         }
         } else {
         set evt_blk_arr(MOM_tap) $evt_blk_name_list
        }
       }
       "MOM_drill_bore" {
        PB_output_RetCycleEvtBlkList evt_obj evt_blk_name_list
        if [info exists evt_blk_arr(MOM_bore)] {
         if {[lindex $evt_blk_name_list 0] != ""} {
          set temp_list [concat $evt_blk_arr(MOM_bore) $evt_blk_name_list]
          set evt_blk_arr(MOM_bore) $temp_list
         }
         } else {
         set evt_blk_arr(MOM_bore) $evt_blk_name_list
        }
        if [info exists evt_blk_arr(MOM_bore_dwell)] {
         if {[lindex $evt_blk_name_list 0] != ""} {
          set temp_list [concat $evt_blk_arr(MOM_bore_dwell) $evt_blk_name_list]
          set evt_blk_arr(MOM_bore_dwell) $temp_list
         }
         } else {
         set evt_blk_arr(MOM_bore_dwell) $evt_blk_name_list
        }
       }
       "MOM_drill_bore_drag" {
        PB_output_RetCycleEvtBlkList evt_obj evt_blk_name_list
        if [info exists evt_blk_arr(MOM_bore_drag)] {
         if {[lindex $evt_blk_name_list 0] != ""} {
          set temp_list [concat $evt_blk_arr(MOM_bore_drag) $evt_blk_name_list]
          set evt_blk_arr(MOM_bore_drag) $temp_list
         }
         } else {
         set evt_blk_arr(MOM_bore_drag) $evt_blk_name_list
        }
       }
       "MOM_drill_bore_nodrag" {
        PB_output_RetCycleEvtBlkList evt_obj evt_blk_name_list
        if [info exists evt_blk_arr(MOM_bore_no_drag)] {
         if {[lindex $evt_blk_name_list 0] != ""} {
          set temp_list [concat $evt_blk_arr(MOM_bore_no_drag) $evt_blk_name_list]
          set evt_blk_arr(MOM_bore_no_drag) $temp_list
         }
         } else {
         set evt_blk_arr(MOM_bore_no_drag) $evt_blk_name_list
        }
       }
       "MOM_drill_bore_back" {
        PB_output_RetCycleEvtBlkList evt_obj evt_blk_name_list
        if [info exists evt_blk_arr(MOM_bore_back)] {
         if {[lindex $evt_blk_name_list 0] != ""} {
          set temp_list [concat $evt_blk_arr(MOM_bore_back) $evt_blk_name_list]
          set evt_blk_arr(MOM_bore_back) $temp_list
         }
         } else {
         set evt_blk_arr(MOM_bore_back) $evt_blk_name_list
        }
       }
       "MOM_drill_bore_manual" {
        PB_output_RetCycleEvtBlkList evt_obj evt_blk_name_list
        if [info exists evt_blk_arr(MOM_bore_manual)] {
         if {[lindex $evt_blk_name_list 0] != ""} {
          set temp_list [concat $evt_blk_arr(MOM_bore_manual) $evt_blk_name_list]
          set evt_blk_arr(MOM_bore_manual) $temp_list
         }
         } else {
         set evt_blk_arr(MOM_bore_manual) $evt_blk_name_list
        }
        if [info exists evt_blk_arr(MOM_bore_manual_dwell)] {
         if {[lindex $evt_blk_name_list 0] != ""} {
          set temp_list [concat $evt_blk_arr(MOM_bore_manual_dwell) $evt_blk_name_list]
          set evt_blk_arr(MOM_bore_manual_dwell) $temp_list
         }
         } else {
         set evt_blk_arr(MOM_bore_manual_dwell) $evt_blk_name_list
        }
       }
       "MOM_peck_drill" -
       "MOM_break_chip" -
       default {
        if {[lsearch $udc_name_list $event_name] < 0} {
         PB_output_RetEvtBlkList evt_obj evt_blk_name_list
         set evt_blk_arr($event_name) [list $evt_blk_name_list]
         } else {
         PB_output_RetCycleEvtBlkList evt_obj evt_blk_name_list
         if {[lindex $evt_blk_name_list 0] != ""} {
          set evt_blk_arr($event_name) $evt_blk_name_list
          } else {
          set evt_blk_arr($event_name) ""
         }
        }
       }
      }
     } ;#disabled
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
  if {[lsearch $evt_name_list "MOM_sequence_number"] < 0} {
   lappend evt_name_list "MOM_sequence_number"
   set evt_blk_arr(MOM_sequence_number) [list ""]
  }
 }

#=======================================================================
proc PB_output_GetEvtObjAttr2 { EVT_NAME_ARR EVT_BLK_ARR } {
  upvar $EVT_NAME_ARR evt_name_list
  upvar $EVT_BLK_ARR evt_blk_arr
  global post_object
  set seq_obj_list $Post::($post_object,seq_obj_list)
  global mom_sys_arr
  if { $mom_sys_arr(\$is_linked_post) == 1 } {
   lappend in_sequence [lindex $seq_obj_list 6] [lindex $seq_obj_list 7]
   } else {
   lappend in_sequence [lindex $seq_obj_list 6]
  }
  unset seq_obj_list
  lappend seq_obj_list $in_sequence
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
     if { [regexp -nocase "end of program" $temp_event_name] == 1 } {
      set temp_event_name [string tolower $temp_event_name]
     }
     set temp_evt_name [join [split $temp_event_name " "] _ ]
     append event_name $prefix _ $temp_evt_name
     if { [lsearch $evt_name_list $event_name] == -1 } \
     {
      lappend evt_name_list $event_name
     }
     PB_output_RetEvtBlkList evt_obj evt_blk_name_list
     set evt_blk_arr($event_name) [list $evt_blk_name_list]
     unset event_name
    }
   }
  }
 }

#=======================================================================
proc PB_output_GetBlkName { BLOCK_OBJ OUTPUT_NAME } {
  upvar $BLOCK_OBJ block_obj
  upvar $OUTPUT_NAME output_name
  if { $block::($block_obj,blk_type) == "normal"  || \
   $block::($block_obj,blk_type) == "comment" || \
  [string match "vnc_*" $block::($block_obj,blk_type)] } \
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
     if { $block_obj > 0 } {
      PB_output_GetBlkName block_obj output_name
      lappend blk_list $output_name
     }
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
    if [info exists event_element::($evt_elem_obj,block_obj)] {
     set block_obj $event_element::($evt_elem_obj,block_obj)
     if { $block_obj > 0 } {
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
  global post_object
  array set mom_sys_var_arr $Post::($post_object,mom_sys_var_list)
  set rapid_work_plane_change $mom_sys_var_arr(\$rap_wrk_pln_chg)
  set no_blks [array size blk_name_arr]
  for { set count 0 } { $count < $no_blks } { incr count } \
  {
   puts $file_id "  BLOCK_TEMPLATE $blk_name_arr($count) "
   puts $file_id "  \{"
    if [string match "comment_blk*" $blk_name_arr($count)] {
     if 0 {
      global post_object
      array set mom_sys_var_arr $Post::($post_object,mom_sys_var_list)
      set comment_start $mom_sys_var_arr(Comment_Start)
      set comment_end   $mom_sys_var_arr(Comment_End)
      set blk_string [lindex $blk_val_arr($count) 0]
      set blk_string [string range $blk_string 1 [expr [string length $blk_string] - 2]]
      set len [string length $comment_start]
      set blk_string [string range $blk_string $len end]
      set len [string length $comment_end]
      set end_idx [expr [string length $blk_string] - $len - 1]
      set blk_string [string range $blk_string 0 $end_idx]
      puts $file_id "       \"$blk_string\""
     }
     puts $file_id "       \" \""
     } else {
     set no_lines [llength $blk_val_arr($count)]
     for {set jj 0} {$jj < $no_lines} {incr jj} \
     {
      puts $file_id "       [lindex $blk_val_arr($count) $jj]"
     }
    }
   puts $file_id "  \}\n"
   if $rapid_work_plane_change {
    if [string match "rapid_traverse" $blk_name_arr($count)] {
     set elem_list [list]
     for {set jj 0} {$jj < $no_lines} {incr jj} \
     {
      set elem [lindex $blk_val_arr($count) $jj]
      if { ![string match "Z*" $elem] } {
       lappend elem_list $elem
      }
     }
     if [llength $elem_list] {
      puts $file_id "  BLOCK_TEMPLATE $blk_name_arr($count)_xy "
      puts $file_id "  \{"
       for {set jj 0} {$jj < $no_lines} {incr jj} \
       {
        set elem [lindex $blk_val_arr($count) $jj]
        if { ![string match "Z*" $elem] } {
         puts $file_id "       $elem"
        }
       }
      puts $file_id "  \}\n"
     }
     set elem_list [list]
     for {set jj 0} {$jj < $no_lines} {incr jj} \
     {
      set elem [lindex $blk_val_arr($count) $jj]
      if { ![string match "X*" $elem] } {
       lappend elem_list $elem
      }
     }
     if [llength $elem_list] {
      puts $file_id "  BLOCK_TEMPLATE $blk_name_arr($count)_yz "
      puts $file_id "  \{"
       for {set jj 0} {$jj < $no_lines} {incr jj} \
       {
        set elem [lindex $blk_val_arr($count) $jj]
        if { ![string match "X*" $elem] } {
         puts $file_id "       $elem"
        }
       }
      puts $file_id "  \}\n"
     }
     set elem_list [list]
     for {set jj 0} {$jj < $no_lines} {incr jj} \
     {
      set elem [lindex $blk_val_arr($count) $jj]
      if { ![string match "Y*" $elem] } {
       lappend elem_list $elem
      }
     }
     if [llength $elem_list] {
      puts $file_id "  BLOCK_TEMPLATE $blk_name_arr($count)_xz "
      puts $file_id "  \{"
       for {set jj 0} {$jj < $no_lines} {incr jj} \
       {
        set elem [lindex $blk_val_arr($count) $jj]
        if { ![string match "Y*" $elem] } {
         puts $file_id "       $elem"
        }
       }
      puts $file_id "  \}\n"
     }
    }
    if [string match "rapid_spindle" $blk_name_arr($count)] {
     set elem_list [list]
     for {set jj 0} {$jj < $no_lines} {incr jj} \
     {
      set elem [lindex $blk_val_arr($count) $jj]
      if { ![string match "Y*" $elem] && \
       ![string match "Z*" $elem] } {
       lappend elem_list $elem
      }
     }
     if [llength $elem_list] {
      puts $file_id "  BLOCK_TEMPLATE $blk_name_arr($count)_x "
      puts $file_id "  \{"
       for {set jj 0} {$jj < $no_lines} {incr jj} \
       {
        set elem [lindex $blk_val_arr($count) $jj]
        if { ![string match "Y*" $elem] && \
         ![string match "Z*" $elem] } {
         puts $file_id "       $elem"
        }
       }
      puts $file_id "  \}\n"
     }
     set elem_list [list]
     for {set jj 0} {$jj < $no_lines} {incr jj} \
     {
      set elem [lindex $blk_val_arr($count) $jj]
      if { ![string match "X*" $elem] && \
       ![string match "Z*" $elem] } {
       lappend elem_list $elem
      }
     }
     if [llength $elem_list] {
      puts $file_id "  BLOCK_TEMPLATE $blk_name_arr($count)_y "
      puts $file_id "  \{"
       for {set jj 0} {$jj < $no_lines} {incr jj} \
       {
        set elem [lindex $blk_val_arr($count) $jj]
        if { ![string match "X*" $elem] && \
         ![string match "Z*" $elem] } {
         puts $file_id "       $elem"
        }
       }
      puts $file_id "  \}\n"
     }
     set elem_list [list]
     for {set jj 0} {$jj < $no_lines} {incr jj} \
     {
      set elem [lindex $blk_val_arr($count) $jj]
      if { ![string match "Y*" $elem] && \
       ![string match "X*" $elem] } {
       lappend elem_list $elem
      }
     }
     if [llength $elem_list] {
      puts $file_id "  BLOCK_TEMPLATE $blk_name_arr($count)_z "
      puts $file_id "  \{"
       for {set jj 0} {$jj < $no_lines} {incr jj} \
       {
        set elem [lindex $blk_val_arr($count) $jj]
        if { ![string match "Y*" $elem] && \
         ![string match "X*" $elem] } {
         puts $file_id "       $elem"
        }
       }
      puts $file_id "  \}\n"
     }
    }
   } ;# rapid_work_plane_change
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
  set file_list $ParseFile::($parser_obj,file_list)
  array set bef_com_data $ParseFile::($parser_obj,bef_com_data_list)
  array set aft_com_data $ParseFile::($parser_obj,aft_com_data_list)
  set file_name [lindex $file_list 0]
  set before_formatting $bef_com_data($file_name)
  set after_formatting $aft_com_data($file_name)
  set deff_id [open "$def_file" w]
  fconfigure $deff_id -translation lf
  set machine_statement_output 0
  foreach line $before_formatting \
  {
   if [string match "*MACHINE*" $line] {
    set tmp_line [string trim $line]
    if [string match "MACHINE *" $tmp_line] {
     set machine_statement_output 1
    }
   }
   if ![regexp {^$} $line] {
    puts $deff_id $line
   }
  }
  if { $machine_statement_output == 0 } \
  {
   set var $mom_kin_var_arr(\$mom_kin_machine_type)
   if [string match "*wedm*" $var] \
   {
    puts $deff_id "MACHINE  wedm"
   } elseif [string match "*_axis_*" $var] \
   {
    puts $deff_id "MACHINE  mill"
   } elseif [string match "*lathe*" $var] \
   {
    puts $deff_id "MACHINE  lathe"
   }
   set machine_statement_output 1
  }
  global mom_sys_arr
  set include_str ""
  if {[info exists mom_sys_arr(Include_UDE)] && $mom_sys_arr(Include_UDE) == 1} {
   set include_str "$include_str $mom_sys_arr(UDE_File_Name)"
  }
  if {[info exists mom_sys_arr(Inherit_UDE)] && $mom_sys_arr(Inherit_UDE) == 1} {
   set cdl_fn $mom_sys_arr(PST_File_Name).cdl
   set def_fn $mom_sys_arr(PST_File_Name).def
   if [string match $mom_sys_arr(PST_File_Folder) ""] {
    set include_str "$include_str $cdl_fn $def_fn"
    } else {
    set folder $mom_sys_arr(PST_File_Folder)
    if ![string match "*/" $folder] {
     set folder "${folder}/"
    }
    if [regexp {UGII[A-Za-z0-9_]+} $folder ugii_var] {
     regsub {UGII[A-Za-z0-9_]+} $folder [string toupper $ugii_var] folder
    }
    set include_str "$include_str $folder$cdl_fn\
    $folder$def_fn"
   }
  }
  if {[info exists mom_sys_arr(Own_UDE)] && $mom_sys_arr(Own_UDE) == 1} {
   set cdl_fn [lindex [split [file tail $def_file] .] 0].cdl
   if [string match $mom_sys_arr(OWN_CDL_File_Folder) ""] {
    set include_str "$include_str $cdl_fn"
    } else {
    set folder $mom_sys_arr(OWN_CDL_File_Folder)
    if ![string match "*/" $folder] {
     set folder "${folder}/"
    }
    if [regexp {UGII[A-Za-z0-9_]+} $folder ugii_var] {
     regsub {UGII[A-Za-z0-9_]+} $folder [string toupper $ugii_var] folder
    }
    set include_str "$include_str $folder$cdl_fn"
   }
  }
  if ![string match "" $include_str] {
   puts $deff_id ""
   puts $deff_id "INCLUDE \{$include_str \}"
  }
  puts $deff_id ""
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
   if { $mom_sys_var(seqnum_max) != "" } {
    set seq_param_arr(4) $mom_sys_var(seqnum_max)
    } else {
    set seq_param_arr(4) [PB_output_GetSeqNumMax]
   }
   PB_output_GetSequenceNumber seq_param_arr sequence_num
   puts $deff_id "  $sequence_num"
   puts $deff_id ""
   set add N
   PB_com_RetObjFrmName add add_obj_list add_obj
   address::readvalue $add_obj add_obj_attr
   set add_obj_attr(4) $mom_sys_var(seqnum_max)
   address::setvalue $add_obj add_obj_attr
   address::DefaultValue $add_obj add_obj_attr
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
   puts $deff_id "############ BLOCK TEMPLATE DECLARATIONS #############"
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
   if [info exists Post::($post_object,post_blk_list)] {
    if { $Post::($post_object,post_blk_list) != "" } \
    {
     set post_blk_list $Post::($post_object,post_blk_list)
     PB_output_GetBlkObjAttr post_blk_list add_obj_list blk_name_arr \
     blk_val_arr
     PB_PB2DEF_write_block_templates deff_id blk_name_arr blk_val_arr
     unset blk_name_arr blk_val_arr
    }
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
proc PB_output_GetSeqNumMax { } {
  global post_object
  Post::GetObjList $post_object address obj_list
  set name N
  PB_com_RetObjFrmName name obj_list obj
  address::readvalue $obj obj_attr
  set obj $obj_attr(1)
  set max [PB_com_GetFmtMaxVal $obj]
  set add_max $obj_attr(4)
  if { $add_max != ""  &&  $add_max < $max } {
   set max $add_max
  }
  return $max
 }

#=======================================================================
proc PB_PB2TCL_write_sys_var_arr { TCLF_ID } {
  upvar $TCLF_ID tclf_id
  PB_output_GetMomSysVars sys_name_arr sys_val_arr
  puts $tclf_id "########## SYSTEM VARIABLE DECLARATIONS ##############"
  set no_of_vars [array size sys_name_arr]
  for { set idx 0 } { $idx < $no_of_vars } { incr idx } \
  {
   if { ![string match "mom_sys_control_out" $sys_name_arr($idx)]  && \
    ![string match "mom_sys_control_in"  $sys_name_arr($idx)] } {
    puts $tclf_id "  set [format "%-40s  %-5s" $sys_name_arr($idx) \
    \"$sys_val_arr($idx)\"]"
    if [string match "mom_sys_cutcom_plane_code(ZX)" $sys_name_arr($idx)] {
     puts $tclf_id "  set [format "%-40s  %-5s" mom_sys_cutcom_plane_code(XZ) \
     \"$sys_val_arr($idx)\"]"
    }
    if [string match "mom_sys_cutcom_plane_code(YZ)" $sys_name_arr($idx)] {
     puts $tclf_id "  set [format "%-40s  %-5s" mom_sys_cutcom_plane_code(ZY) \
     \"$sys_val_arr($idx)\"]"
    }
   }
  }
  global gPB
  if [info exists gPB(post_description)] {
   set i 0
   set len [llength $gPB(post_description)]
   foreach s $gPB(post_description) {
    incr i
    if { $i == 1 } {
     set str "  set [format "%-40s" mom_sys_post_description]  \""
     } else {
     set str "      [format "%-40s" ""]   "
    }
    if { $i < $len } {
     puts $tclf_id "$str$s\\n\\"
     } else {
     puts $tclf_id "$str$s\""
    }
   }
  }
  puts $tclf_id "  set [format %-40s mom_sys_ugpadvkins_used]  \"0\""
  puts $tclf_id "  set [format %-40s mom_sys_post_builder_version]  \"$gPB(Postbuilder_Release_Version)\""
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
proc PB_PB2TCL_write_sim_var_arr { TCLF_ID } {
  upvar $TCLF_ID tclf_id
  PB_output_GetMomSimVars sim_name_arr sim_val_arr
  set no_simvars [array size sim_name_arr]
  puts $tclf_id "####### MOM SIM VARIABLE DECLARATIONS ##############"
  for { set count 0 } { $count < $no_simvars } { incr count } \
  {
   set len [llength $sim_val_arr($count)]
   if {[string match "*mom_sim_vnc_com_list*" $sim_name_arr($count)]} {
    set item_head [lindex $sim_val_arr($count) 0]
    set item_end  [lindex $sim_val_arr($count) end]
    puts $tclf_id "  set [format "%-40s  %-5s" $sim_name_arr($count)\
    \"$item_head\\]"
    set ind [expr $len - 1]
    for {set i 1} { $i < $ind} { incr i} {
     set item [lindex $sim_val_arr($count) $i]
     puts $tclf_id "      [format "%-40s  %-5s"  "" $item\\]"
    }
    puts $tclf_id "      [format "%-40s  %-5s"  "" $item_end\"]"
    } else {
    puts $tclf_id "  set [format "%-40s  %-5s" $sim_name_arr($count)\
    \"$sim_val_arr($count)\"]"
   }
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
   set val(2) TRUE
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
  set val(6) $mom_kin_var_arr(\$mom_kin_machine_type)
  if {[info exists mom_kin_var_arr(\$mom_kin_4th_axis_direction)]} {
   set name(7) "mom_fly_4th_axis_direction"
   set val(7)  $mom_kin_var_arr(\$mom_kin_4th_axis_direction)
  }
  if {[info exists mom_kin_var_arr(\$mom_kin_5th_axis_direction)]} {
   set name(8) "mom_fly_5th_axis_direction"
   set val(8)  $mom_kin_var_arr(\$mom_kin_5th_axis_direction)
  }
  if {[info exists mom_kin_var_arr(\$mom_kin_independent_head)]} {
   set name(9) "mom_fly_independent_head"
   set val(9) $mom_kin_var_arr(\$mom_kin_independent_head) ;#FRONT/REAR/LEFT/RIGHT
  }
  if {[info exists mom_kin_var_arr(\$mom_kin_dependent_head)]} {
   set name(10) "mom_fly_dependent_head"
   set val(10) $mom_kin_var_arr(\$mom_kin_dependent_head) ;#FRONT/REAR/LEFT/RIGHT
  }
  if {[info exists mom_sys_var_arr(\$lathe_output_method)]} {
   set name(11) "mom_fly_lathe_output_method"
   set val(11) $mom_sys_var_arr(\$lathe_output_method) ;#TOOL_TIP/TURRET_REF
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
  set name(13)  "mom_fly_rapid_traverse_blk"
  set rapid_1 $mom_sys_var_arr(\$pb_rapid_1)
  if { $rapid_1 != "" } \
  {
   set val(13) $block::($rapid_1,block_name)
  } else \
  {
   set val(13) ""
  }
  set name(14)  "mom_fly_rapid_spindle_blk"
  set rapid_2 $mom_sys_var_arr(\$pb_rapid_2)
  if { $rapid_2 != "" } \
  {
   if [info exist block::($rapid_2,block_name)] {
    set val(14) $block::($rapid_2,block_name)
    } else {
    set val(14) ""
   }
  } else \
  {
   set val(14) ""
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
    set fly_val "$fly_val_arr($idx)"
    break
   }
  }
  return $fly_val
 }

#=======================================================================
proc PB_PB2TCL_insert_axis_mult { FILE_ID to_encrypt } {
  upvar $FILE_ID file_id
  global mom_sys_arr
  global env
  puts $file_id ""
  puts $file_id ""
  puts $file_id "if \[llength \[info commands MOM_SYS_do_template\] \] {"
   puts $file_id "   if \[llength \[info commands MOM_do_template\] \] {"
    puts $file_id "      rename MOM_do_template \"\""
   puts $file_id "   }"
   puts $file_id "   rename MOM_SYS_do_template MOM_do_template"
  puts $file_id "}"
  puts $file_id ""
  puts $file_id ""
  if [info exists mom_sys_arr(\$mom_sys_lathe_x_double)] {
   set x_double $mom_sys_arr(\$mom_sys_lathe_x_double)
   } else {
   set x_double 1
  }
  if [info exists mom_sys_arr(\$mom_sys_lathe_i_double)] {
   set i_double $mom_sys_arr(\$mom_sys_lathe_i_double)
   } else {
   set i_double 1
  }
  if [info exists mom_sys_arr(\$mom_sys_lathe_y_double)] {
   set y_double $mom_sys_arr(\$mom_sys_lathe_y_double)
   } else {
   set y_double 1
  }
  if [info exists mom_sys_arr(\$mom_sys_lathe_j_double)] {
   set j_double $mom_sys_arr(\$mom_sys_lathe_j_double)
   } else {
   set j_double 1
  }
  if [info exists mom_sys_arr(\$mom_sys_lathe_x_factor)] {
   set x_factor $mom_sys_arr(\$mom_sys_lathe_x_factor)
   } else {
   set x_factor 1
  }
  if [info exists mom_sys_arr(\$mom_sys_lathe_y_factor)] {
   set y_factor $mom_sys_arr(\$mom_sys_lathe_y_factor)
   } else {
   set y_factor 1
  }
  if [info exists mom_sys_arr(\$mom_sys_lathe_z_factor)] {
   set z_factor $mom_sys_arr(\$mom_sys_lathe_z_factor)
   } else {
   set z_factor 1
  }
  if [info exists mom_sys_arr(\$mom_sys_lathe_i_factor)] {
   set i_factor $mom_sys_arr(\$mom_sys_lathe_i_factor)
   } else {
   set i_factor 1
  }
  if [info exists mom_sys_arr(\$mom_sys_lathe_j_factor)] {
   set j_factor $mom_sys_arr(\$mom_sys_lathe_j_factor)
   } else {
   set j_factor 1
  }
  if [info exists mom_sys_arr(\$mom_sys_lathe_k_factor)] {
   set k_factor $mom_sys_arr(\$mom_sys_lathe_k_factor)
   } else {
   set k_factor 1
  }
  if { $x_double != 1 || \
   $i_double != 1 || \
   $y_double != 1 || \
   $j_double != 1 || \
   $x_factor != 1 || \
   $y_factor != 1 || \
   $z_factor != 1 || \
   $i_factor != 1 || \
   $j_factor != 1 || \
   $k_factor != 1 } {
   set axis_mult $env(PB_HOME)/pblib/pb_axis_multipliers.tcl
   if [file exists $axis_mult] {
    set fid [open [subst -nobackslashes ${axis_mult}] "r"]
    set contents [read $fid]
    if { [info exists to_encrypt] && $to_encrypt } {
     foreach str [split $contents \n] {
      puts $file_id $str
     }
     } else {
     puts -nonewline $file_id $contents
    }
    close $fid
   }
  }
 }

#=======================================================================
proc PB_PB2TCL_write_local_procs { TCLF_ID } {
  upvar $TCLF_ID tclf_id
  global mom_sys_arr
  global post_object
  set cur_machine [PB2TCL_read_fly_var mom_fly_machine_type]
  set fourth_dirn [PB2TCL_read_fly_var mom_fly_4th_axis_direction]
  set fifth_dirn [PB2TCL_read_fly_var mom_fly_5th_axis_direction]
  set ind_head [PB2TCL_read_fly_var mom_fly_independent_head]
  set dep_head [PB2TCL_read_fly_var mom_fly_dependent_head]
  set lathe_output_method [PB2TCL_read_fly_var mom_fly_lathe_output_method] ; #TOOL_TIP/TURRET_REF
  if 0 {
   puts $tclf_id "\n"
   puts $tclf_id "if { \[info exists mom_sys_post_initialized\] && \$mom_sys_post_initialized == 1 } {"
    puts $tclf_id "  #============================================================="

#=======================================================================
puts $tclf_id "  proc MOM_before_output { } {"
  puts $tclf_id "  #============================================================="
  puts $tclf_id "  # This command is executed just before every NC block is"
  puts $tclf_id "  # to be output to a file."
  puts $tclf_id "  #"
  puts $tclf_id "  # - Never overload this command!"
  puts $tclf_id "  # - Any customization should be done in PB_CMD_before_output!"
  puts $tclf_id "  #"
  puts $tclf_id ""
  puts $tclf_id "     if { \[llength \[info commands PB_CMD_kin_before_output\]\] } {"
   puts $tclf_id "        PB_CMD_kin_before_output"
  puts $tclf_id "     }"
  puts $tclf_id ""
  puts $tclf_id "  ######### The following procedure invokes the listing file with warnings."
  puts $tclf_id ""
  puts $tclf_id "     LIST_FILE"
 puts $tclf_id "  }"
puts $tclf_id "}"
puts $tclf_id "\n"
puts $tclf_id "\n"
}
if { [info exists mom_sys_arr(Output_VNC)] && \
$mom_sys_arr(Output_VNC) == 1 } {
puts $tclf_id "###################"
puts $tclf_id "# IS&V Enhancement"
puts $tclf_id "###################"
puts $tclf_id ""
puts $tclf_id ""
puts $tclf_id "if { !\[info exists sim_mtd_initialized\] } {"
 puts $tclf_id "   set sim_mtd_initialized 0"
puts $tclf_id "}"
puts $tclf_id ""
PB_output_GetCmdBlkProcs cmd_blk_list cmd_proc_arr
set cmd_blk PB_CMD_vnc____ASSIGN_TURRET_POCKETS
if [info exists cmd_proc_arr($cmd_blk)] {
 puts $tclf_id ""
 puts $tclf_id ""
 puts $tclf_id "##VNC____ASSIGN_TURRET_POCKETS START"
 puts $tclf_id ""
 puts $tclf_id ""
 foreach line $cmd_proc_arr($cmd_blk) \
 {
  puts $tclf_id "$line"
 }
 puts $tclf_id ""
 puts $tclf_id ""
 puts $tclf_id "##VNC____ASSIGN_TURRET_POCKETS END"
 puts $tclf_id ""
 puts $tclf_id ""
 puts $tclf_id ""
}
unset cmd_blk_list
unset cmd_proc_arr
puts $tclf_id "set mom_sim_vnc_handler \[file rootname \[info script\]\]_vnc.tcl"
puts $tclf_id ""
puts $tclf_id "set mom_sim_post_builder_vnc 1"
puts $tclf_id ""
puts $tclf_id ""
puts $tclf_id "#============================================================="

#=======================================================================
puts $tclf_id "proc MOM_SIM_initialize_mtd { } {"
  puts $tclf_id "#============================================================="
  puts $tclf_id "  global sim_mtd_initialized"
  puts $tclf_id "  global mom_sim_vnc_msg_only"
  puts $tclf_id ""
  puts $tclf_id ""
  puts $tclf_id "   if { !\[info exists mom_sim_vnc_msg_only\] || !\$mom_sim_vnc_msg_only } {"
   puts $tclf_id "     # Initialized to plugin mode to facilitate machine code simulation"
   puts $tclf_id "      SIM_mtd_init NC_CONTROLLER_PLUGIN"
  puts $tclf_id "   }"
  puts $tclf_id ""
  puts $tclf_id "   uplevel #0 {"
   puts $tclf_id "      source \"\$mom_sim_vnc_handler\""
  puts $tclf_id "   }"
  puts $tclf_id ""
  puts $tclf_id "   set sim_mtd_initialized 1"
 puts $tclf_id "}"
 puts $tclf_id ""
 puts $tclf_id ""
 puts $tclf_id "#++++++++++++++++++++++++++++++++++++++++++"
 puts $tclf_id "# Source & initialize VNC for a child post"
 puts $tclf_id "#++++++++++++++++++++++++++++++++++++++++++"
 puts $tclf_id "if { \$sim_mtd_initialized == 1 } {"
  puts $tclf_id "  source \"\$mom_sim_vnc_handler\""
  puts $tclf_id "  if \[llength \[info commands PB_VNC_init_sim_vars\] \] {"
   puts $tclf_id "    PB_VNC_init_sim_vars"
  puts $tclf_id "  }"
 puts $tclf_id "}"
 puts $tclf_id ""
 puts $tclf_id ""
}
puts $tclf_id "\n"
puts $tclf_id "#============================================================="

#=======================================================================
puts $tclf_id "proc MOM_start_of_program { } {"
  puts $tclf_id "#============================================================="
  puts $tclf_id "  global mom_logname mom_date is_from"
  puts $tclf_id "  global mom_coolant_status mom_cutcom_status"
  puts $tclf_id "  global mom_clamp_status mom_cycle_status"
  puts $tclf_id "  global mom_spindle_status mom_cutcom_plane pb_start_of_program_flag"
  puts $tclf_id "  global mom_cutcom_adjust_register mom_tool_adjust_register"
  puts $tclf_id "  global mom_tool_length_adjust_register mom_length_comp_register"
  puts $tclf_id "  global mom_flush_register mom_wire_cutcom_adjust_register"
  puts $tclf_id "  global mom_wire_cutcom_status"
  puts $tclf_id ""
  puts $tclf_id "    set pb_start_of_program_flag 0"
  puts $tclf_id "    set mom_coolant_status UNDEFINED"
  puts $tclf_id "    set mom_cutcom_status  UNDEFINED"
  puts $tclf_id "    set mom_clamp_status   UNDEFINED"
  puts $tclf_id "    set mom_cycle_status   UNDEFINED"
  puts $tclf_id "    set mom_spindle_status UNDEFINED"
  puts $tclf_id "    set mom_cutcom_plane   UNDEFINED"
  puts $tclf_id "    set mom_wire_cutcom_status  UNDEFINED"
  puts $tclf_id ""
  puts $tclf_id "    catch {unset mom_cutcom_adjust_register}"
  puts $tclf_id "    catch {unset mom_tool_adjust_register}"
  puts $tclf_id "    catch {unset mom_tool_length_adjust_register}"
  puts $tclf_id "    catch {unset mom_length_comp_register}"
  puts $tclf_id "    catch {unset mom_flush_register}"
  puts $tclf_id "    catch {unset mom_wire_cutcom_adjust_register}"
  puts $tclf_id ""
  puts $tclf_id "    set is_from \"\""
  puts $tclf_id ""
  puts $tclf_id "    catch { OPEN_files } ; #open warning and listing files"
  puts $tclf_id "    LIST_FILE_HEADER ; #list header in commentary listing"
  if { [info exists mom_sys_arr(Output_VNC)] && $mom_sys_arr(Output_VNC) == 1 } {
   puts $tclf_id ""
   puts $tclf_id ""
   puts $tclf_id "   # If this handler is executed, revPost is not runnning!"
   puts $tclf_id "    global mom_sim_post_builder_rev_post"
   puts $tclf_id "    set mom_sim_post_builder_rev_post 0"
   puts $tclf_id ""
   puts $tclf_id ""
   puts $tclf_id "   # Assign primary channel"
   puts $tclf_id "    global sim_mtd_initialized"
   puts $tclf_id "    if { \$sim_mtd_initialized == 1 } {"
    puts $tclf_id "      global mom_sim_primary_channel mom_carrier_name"
    puts $tclf_id "      if \[info exists mom_carrier_name\] {"
     puts $tclf_id "        set mom_sim_primary_channel \$mom_carrier_name"
    puts $tclf_id "      }"
    puts $tclf_id ""
    puts $tclf_id "      catch { SIM_mtd_init NC_CONTROLLER_MTD_EVENT_HANDLER }"
   puts $tclf_id "    }"
  }
  puts $tclf_id ""
  puts $tclf_id ""
  puts $tclf_id ""
  puts $tclf_id "  global mom_sys_post_initialized"
  puts $tclf_id "  if { \$mom_sys_post_initialized > 1 } { return }"
  puts $tclf_id ""
  puts $tclf_id ""
  puts $tclf_id "#************"
  puts $tclf_id "uplevel #0 {"
   puts $tclf_id "\n"
   puts $tclf_id "#============================================================="

#=======================================================================
puts $tclf_id "proc MOM_sync { } {"
  puts $tclf_id "#============================================================="
  puts $tclf_id "  if \[llength \[info commands PB_CMD_kin_handle_sync_event\] \] {"
   puts $tclf_id "    PB_CMD_kin_handle_sync_event"
  puts $tclf_id "  }"
  if { [info exists mom_sys_arr(Output_VNC)] && \
   $mom_sys_arr(Output_VNC) == 1 } {
   puts $tclf_id ""
   puts $tclf_id "  global sim_mtd_initialized"
   puts $tclf_id "  if { \$sim_mtd_initialized == 1 } {"
    puts $tclf_id "    global mom_sim_vnc_msg_only"
    puts $tclf_id "    if { !\[info exists mom_sim_vnc_msg_only\] || !\$mom_sim_vnc_msg_only } {"
     puts $tclf_id "      global mom_sync_number"
     puts $tclf_id "      if \[info exists mom_sync_number\] {"
      puts $tclf_id "        if \[llength \[info commands PB_VNC_sync\] \] {"
       puts $tclf_id "          PB_VNC_sync"
      puts $tclf_id "        }"
      puts $tclf_id "        unset mom_sync_number"
     puts $tclf_id "      }"
    puts $tclf_id "    }"
   puts $tclf_id "  }"
  }
 puts $tclf_id "}"
 puts $tclf_id "\n"
 puts $tclf_id "#============================================================="

#=======================================================================
puts $tclf_id "proc MOM_set_csys { } {"
  puts $tclf_id "#============================================================="
  puts $tclf_id "  if \[llength \[info commands PB_CMD_kin_set_csys\] \] {"
   puts $tclf_id "    PB_CMD_kin_set_csys"
  puts $tclf_id "  }"
  if { [info exists mom_sys_arr(Output_VNC)] && \
   $mom_sys_arr(Output_VNC) == 1 } {
   puts $tclf_id ""
   puts $tclf_id "# Pass the CSYS information that will be used to"
   puts $tclf_id "# set the ZCS coordinate system for simulation."
   puts $tclf_id "  global sim_mtd_initialized"
   puts $tclf_id "  if \$sim_mtd_initialized {"
    puts $tclf_id "    if \[llength \[info commands PB_VNC_pass_csys_data\] \] {"
     puts $tclf_id "      global mom_sim_csys_set"
     puts $tclf_id "      set mom_sim_csys_set 0"
     puts $tclf_id ""
     puts $tclf_id "      PB_VNC_pass_csys_data"
     puts $tclf_id ""
     puts $tclf_id "      set mom_sim_csys_set 1"
    puts $tclf_id "    }"
   puts $tclf_id "  }"
  }
 puts $tclf_id "}"
 puts $tclf_id "\n"
 puts $tclf_id "#============================================================="

#=======================================================================
puts $tclf_id "proc MOM_msys { } {"
  puts $tclf_id "#============================================================="
  if { [info exists mom_sys_arr(Output_VNC)] && \
   $mom_sys_arr(Output_VNC) == 1 } {
   puts $tclf_id "# Pass the CSYS information, if a CSYS is not set, that will be"
   puts $tclf_id "# used to set the ZCS coordinate system for simulation."
   puts $tclf_id "  global sim_mtd_initialized"
   puts $tclf_id "  if \$sim_mtd_initialized {"
    puts $tclf_id "    if \[llength \[info commands PB_VNC_pass_msys_data\] \] {"
     puts $tclf_id "      PB_VNC_pass_msys_data"
    puts $tclf_id "    }"
   puts $tclf_id "  }"
  }
 puts $tclf_id "}"
 if { [info exists mom_sys_arr(\$mom_sys_mill_turn_type)] && \
  [string match "SIMPLE_MILL_TURN" $mom_sys_arr(\$mom_sys_mill_turn_type)] } {
  } elseif { $mom_sys_arr(\$is_linked_post) == 1 } {
  puts $tclf_id ""
  puts $tclf_id ""
  puts $tclf_id "#========================="
  puts $tclf_id "# Linked posts definition"
  puts $tclf_id "#========================="
  puts $tclf_id " set mom_sys_master_post   \"\[file rootname \$mom_event_handler_file_name\]\""
  set linked_posts [ UI_PB_lnk_SetLinkedPostsForHList ]
  foreach link $linked_posts {
   set head [lindex $link 1]
   set post [lindex $link 2]
   if [string match "this_post" $post] {
    puts $tclf_id " set [format "%-40s  %-5s" mom_sys_master_head \"$head\"]"
    puts $tclf_id ""
    set post \$mom_sys_master_post
   }
   puts $tclf_id " set [format "%-40s  %-5s" mom_sys_postname($head) \"$post\"]"
  }
 }
 PB_PB2TCL_write_tcl_procs2 tclf_id
 puts $tclf_id ""
 puts $tclf_id ""
 puts $tclf_id "  incr mom_sys_post_initialized"
 puts $tclf_id ""
 puts $tclf_id ""
puts $tclf_id "} ;# uplevel"
puts $tclf_id "#***********"
puts $tclf_id ""
puts $tclf_id ""
if { [info exists mom_sys_arr(Output_VNC)] && \
 $mom_sys_arr(Output_VNC) == 1 } {
 global env
 if { [info exists env(UGII_CAM_POST_OUTPUT_EXTENDED_NC)] && $env(UGII_CAM_POST_OUTPUT_EXTENDED_NC) } {}
 if { [info exists env(UGII_CAM_POST_OUTPUT_EXTENDED_NC)] } {
  puts $tclf_id "  global mom_sim_output_extended_nc"
  puts $tclf_id "  if { \[info exists mom_sim_output_extended_nc\] && \$mom_sim_output_extended_nc == 1 } {"
   puts $tclf_id ""
   puts $tclf_id "   # Only do this in non-simulation mode"
   puts $tclf_id "    if { \$sim_mtd_initialized == 0 } {"
    puts $tclf_id ""
    puts $tclf_id "      global mom_sim_vnc_msg_only"
    puts $tclf_id "      set mom_sim_vnc_msg_only  1"
    puts $tclf_id ""
    puts $tclf_id "      global mom_sim_vnc_handler"
    puts $tclf_id "      uplevel #0 {"
     puts $tclf_id "        source \"\$mom_sim_vnc_handler\""
    puts $tclf_id "      }"
    puts $tclf_id ""
    puts $tclf_id "      PB_VNC_start_of_program"
    puts $tclf_id ""
    puts $tclf_id "      set sim_mtd_initialized  2"
   puts $tclf_id "    }"
  puts $tclf_id "  }"
  } else {
  puts $tclf_id " # Initialize simulation"
  puts $tclf_id "  global sim_mtd_initialized"
  puts $tclf_id "  if \$sim_mtd_initialized {"
   puts $tclf_id "    global mom_sim_program_has_started"
   puts $tclf_id "    if { !\[info exists mom_sim_program_has_started\] } {"
    puts $tclf_id ""
    puts $tclf_id "      set mom_sim_program_has_started 1"
    puts $tclf_id ""
    puts $tclf_id "      if \[llength \[info commands PB_VNC_start_of_program\] \] {"
     puts $tclf_id "        PB_VNC_start_of_program"
    puts $tclf_id "      }"
   puts $tclf_id "    }"
  puts $tclf_id "  }"
 }
}
puts $tclf_id "}" ;# MOM_start_of_program
if [string match "*dual_head*" $cur_machine] {
puts $tclf_id "\n"
puts $tclf_id "#============================================================="

#=======================================================================
puts $tclf_id "proc PB_swap_dual_head_elements { } {"
  puts $tclf_id "#============================================================="
  puts $tclf_id "  global mom_output_file_directory mom_logname"
  puts $tclf_id ""
  puts $tclf_id "   set def_file_name  \"\${mom_output_file_directory}__\${mom_logname}_tmp_def_file_\[clock clicks\].def\""
  puts $tclf_id "   if { \[catch { set tmp_file \[open \"\$def_file_name\" w\] } res\] } {"
   puts $tclf_id "return \[tk_messageBox -type ok -icon error -message \"\$res\"\]"
  puts $tclf_id "   }"
  puts $tclf_id ""
  puts $tclf_id "   puts \$tmp_file \"MACHINE mill\""
  puts $tclf_id "   puts \$tmp_file \"\""
  puts $tclf_id "   puts \$tmp_file \"FORMATTING\""
  puts $tclf_id "   puts \$tmp_file \"\\\{\""
   Post::GetObjList $post_object address add_obj_list
   set add_name fourth_axis
   PB_com_RetObjFrmName add_name add_obj_list add4_obj
   set add_name fifth_axis
   PB_com_RetObjFrmName add_name add_obj_list add5_obj
   set obj_list [list $add4_obj $add5_obj]
   PB_output_GetAdrObjAttr obj_list adr_name_arr adr_val_arr
   foreach line $adr_val_arr(0) {
    if [string match "*LEADER *" $line] {
     set add4_leader $line
     break
    }
   }
   puts $tclf_id "   puts \$tmp_file \"  ADDRESS $adr_name_arr(0)\""
   puts $tclf_id "   puts \$tmp_file \"  \\\{\""
    foreach line $adr_val_arr(1) {
     if [string match "*LEADER *" $line] {
      puts $tclf_id "   puts \$tmp_file \"      [PB_output_EscapeSpecialControlChar $add4_leader]\""
      set add5_leader $line
      } else {
      puts $tclf_id "   puts \$tmp_file \"      [PB_output_EscapeSpecialControlChar $line]\""
     }
    }
   puts $tclf_id "   puts \$tmp_file \"  \\\}\""
   puts $tclf_id "   puts \$tmp_file \"\""
   puts $tclf_id "   puts \$tmp_file \"  ADDRESS $adr_name_arr(1)\""
   puts $tclf_id "   puts \$tmp_file \"  \\\{\""
    foreach line $adr_val_arr(0) {
     if [string match "*LEADER *" $line] {
      puts $tclf_id "   puts \$tmp_file \"      [PB_output_EscapeSpecialControlChar $add5_leader]\""
      } else {
      puts $tclf_id "   puts \$tmp_file \"      [PB_output_EscapeSpecialControlChar $line]\""
     }
    }
   puts $tclf_id "   puts \$tmp_file \"  \\\}\""
   puts $tclf_id "   puts \$tmp_file \"\""
   unset adr_name_arr adr_val_arr
   set blk_elem4_list $address::($add4_obj,blk_elem_list)
   set blk_elem5_list $address::($add5_obj,blk_elem_list)
   set common_blk_list ""
   foreach blk_elem4 $blk_elem4_list {
    foreach blk_elem5 $blk_elem5_list {
     if [string match $block_element::($blk_elem4,parent_name) $block_element::($blk_elem5,parent_name)] {
      if { [lsearch $common_blk_list $block_element::($blk_elem4,parent_name)] < 0 } {
       lappend common_blk_list $block_element::($blk_elem4,parent_name)
      }
     }
    }
   }
   set rapid_work_plane_change $mom_sys_arr(\$rap_wrk_pln_chg)
   Post::GetObjList $post_object block blk_obj_list
   PB_output_GetBlkObjAttr blk_obj_list add_obj_list blk_name_arr blk_val_arr
   set blk_name_list [array get blk_name_arr]
   PB_com_unset_var blk_elem_arr
   foreach blk $common_blk_list {
    set idx [expr [lsearch $blk_name_list $blk] - 1]
    set blk_idx [lindex $blk_name_list $idx]
    if [info exists blk_val_arr($blk_idx)] {
     set blk_value_list $blk_val_arr($blk_idx)
     set idx_4th [lsearch $blk_value_list "*fourth_axis*"]
     set elm_4th [lindex $blk_value_list $idx_4th]
     set idx_5th [lsearch $blk_value_list "*fifth_axis*"]
     set elm_5th [lindex $blk_value_list $idx_5th]
     set blk_value_list [lreplace $blk_value_list $idx_4th $idx_4th $elm_5th]
     set blk_value_list [lreplace $blk_value_list $idx_5th $idx_5th $elm_4th]
     set blk_elem_arr($blk) $blk_value_list
     if $rapid_work_plane_change {
      set blk_name "rapid_traverse"
      if [string match $blk_name $blk] {
       set elem_list [list]
       foreach line $blk_value_list {
        if { ![string match "Z*" $line] } {
         lappend elem_list $line
        }
       }
       if [llength $elem_list] {
        set blk_elem_arr(${blk_name}_xy) $elem_list
       }
       set elem_list [list]
       foreach line $blk_value_list {
        if { ![string match "X*" $line] } {
         lappend elem_list $line
        }
       }
       if [llength $elem_list] {
        set blk_elem_arr(${blk_name}_yz) $elem_list
       }
       set elem_list [list]
       foreach line $blk_value_list {
        if { ![string match "Y*" $line] } {
         lappend elem_list $line
        }
       }
       if [llength $elem_list] {
        set blk_elem_arr(${blk_name}_zx) $elem_list
       }
      }
      set blk_name "rapid_spindle"
      if [string match $blk_name $blk] {
       set elem_list [list]
       foreach line $blk_value_list {
        if { ![string match "Y*" $line] && \
         ![string match "Z*" $line] } {
         lappend elem_list $line
        }
       }
       if [llength $elem_list] {
        set blk_elem_arr(${blk_name}_x) $elem_list
       }
       set elem_list [list]
       foreach line $blk_value_list {
        if { ![string match "Z*" $line] && \
         ![string match "X*" $line] } {
         lappend elem_list $line
        }
       }
       if [llength $elem_list] {
        set blk_elem_arr(${blk_name}_y) $elem_list
       }
       set elem_list [list]
       foreach line $blk_value_list {
        if { ![string match "X*" $line] && \
         ![string match "Y*" $line] } {
         lappend elem_list $line
        }
       }
       if [llength $elem_list] {
        set blk_elem_arr(${blk_name}_z) $elem_list
       }
      }
     } ;# work plane change
    } ;# block exists
   } ;# common_blk_list
   if [info exists blk_elem_arr] {
    foreach blk [array names blk_elem_arr] {
     puts $tclf_id "   puts \$tmp_file \"  BLOCK_TEMPLATE $blk\""
     puts $tclf_id "   puts \$tmp_file \"  \\\{\""
      foreach elem $blk_elem_arr($blk) {
       puts $tclf_id "   puts \$tmp_file \"      [PB_output_EscapeSpecialControlChar $elem]\""
      }
     puts $tclf_id "   puts \$tmp_file \"  \\\}\""
     puts $tclf_id "   puts \$tmp_file \"\""
    }
   }
  puts $tclf_id "   puts \$tmp_file \"\\\}\""
  puts $tclf_id ""
  puts $tclf_id "   close \$tmp_file"
  puts $tclf_id ""
  puts $tclf_id "   MOM_load_definition_file  \$def_file_name"
  puts $tclf_id "   MOM_remove_file           \$def_file_name"
 puts $tclf_id "}"  ;# PB_swap_dual_head_elements
}
if { ![string match "3_axis_mill_turn" $cur_machine] } {
 if {$fourth_dirn == "SIGN_DETERMINES_DIRECTION" || $fifth_dirn == "SIGN_DETERMINES_DIRECTION"} {
  puts $tclf_id "\n"
  if 0 {
   puts $tclf_id "#============================================================="

#=======================================================================
puts $tclf_id "proc PB_ROTARY_SIGN_SET \{ \} \{"
  puts $tclf_id "#============================================================="
  puts $tclf_id "  global mom_sys_leader"
  puts $tclf_id "  global mom_out_angle_pos"
  puts $tclf_id "  global mom_rotary_direction_4th"
  puts $tclf_id "  global mom_rotary_direction_5th"
  if {$fourth_dirn == "SIGN_DETERMINES_DIRECTION"} {
   puts $tclf_id ""
   puts $tclf_id "    set mom_out_angle_pos(0) \[expr abs(\$mom_out_angle_pos(0))\]"
   puts $tclf_id "    set mom_sys_leader(fourth_axis) \[string trimright \$mom_sys_leader(fourth_axis) \"-\"\]"
   puts $tclf_id ""
   puts $tclf_id "    if \{\$mom_rotary_direction_4th < 0\} \{"
    puts $tclf_id "      if \{\[EQ_is_zero \$mom_out_angle_pos(0)\]\} \{"
     puts $tclf_id "        append mom_sys_leader(fourth_axis) \"-\""
     puts $tclf_id "      \} else \{"
     puts $tclf_id "        set mom_out_angle_pos(0) \[expr -\$mom_out_angle_pos(0)\]"
    puts $tclf_id "      \}"
   puts $tclf_id "    \}"
  }
  if {$fifth_dirn == "SIGN_DETERMINES_DIRECTION"} {
   puts $tclf_id ""
   puts $tclf_id "    set mom_out_angle_pos(1) \[expr abs(\$mom_out_angle_pos(1))\]"
   puts $tclf_id "    set mom_sys_leader(fifth_axis) \[string trimright \$mom_sys_leader(fifth_axis) \"-\"\]"
   puts $tclf_id ""
   puts $tclf_id "    if \{\$mom_rotary_direction_5th < 0\} \{"
    puts $tclf_id "      if \{\[EQ_is_zero \$mom_out_angle_pos(1)\]\} \{"
     puts $tclf_id "        append mom_sys_leader(fifth_axis) \"-\""
     puts $tclf_id "      \} else \{"
     puts $tclf_id "        set mom_out_angle_pos(1) \[expr -\$mom_out_angle_pos(1)\]"
    puts $tclf_id "      \}"
   puts $tclf_id "    \}"
  }
 puts $tclf_id "\}"
 } else {
 puts $tclf_id "#============================================================="

#=======================================================================
puts $tclf_id "proc PB_ROTARY_SIGN_SET { } {"
  puts $tclf_id "#============================================================="
  puts $tclf_id "  global mom_sys_leader"
  puts $tclf_id "  global mom_out_angle_pos"
  puts $tclf_id "  global mom_rotary_direction_4th"
  puts $tclf_id "  global mom_rotary_direction_5th"
  if {$fourth_dirn == "SIGN_DETERMINES_DIRECTION"} {
   puts $tclf_id ""
   puts $tclf_id "    set mom_sys_leader(fourth_axis) \[string trimright \$mom_sys_leader(fourth_axis) \"-\"\]"
   puts $tclf_id "    if { \$mom_rotary_direction_4th < 0 } {"
    puts $tclf_id "      set mom_out_angle_pos(0) \[expr abs(\$mom_out_angle_pos(0))\]"
    puts $tclf_id "      if \[EQ_is_zero \$mom_out_angle_pos(0)\] {"
     puts $tclf_id "        append mom_sys_leader(fourth_axis) \"-\""
     puts $tclf_id "      } else {"
     puts $tclf_id "        set mom_out_angle_pos(0) \[expr -1 * \$mom_out_angle_pos(0)\]"
    puts $tclf_id "      }"
   puts $tclf_id "    }"
  }
  if {$fifth_dirn == "SIGN_DETERMINES_DIRECTION"} {
   puts $tclf_id ""
   puts $tclf_id "    set mom_sys_leader(fifth_axis) \[string trimright \$mom_sys_leader(fifth_axis) \"-\"\]"
   puts $tclf_id "    if { \$mom_rotary_direction_5th < 0 } {"
    puts $tclf_id "      set mom_out_angle_pos(1) \[expr abs(\$mom_out_angle_pos(1))\]"
    puts $tclf_id "      if \[EQ_is_zero \$mom_out_angle_pos(1)\] {"
     puts $tclf_id "        append mom_sys_leader(fifth_axis) \"-\""
     puts $tclf_id "      } else {"
     puts $tclf_id "        set mom_out_angle_pos(1) \[expr -1 * \$mom_out_angle_pos(1)\]"
    puts $tclf_id "      }"
   puts $tclf_id "    }"
  }
 puts $tclf_id "}"
}
}
}
if { $ind_head != "" } {
puts $tclf_id "\n"
puts $tclf_id "#============================================================="

#=======================================================================
puts $tclf_id "proc PB_TURRET_HEAD_SET \{ \} \{"
  puts $tclf_id "#============================================================="
  puts $tclf_id "  global mom_kin_independent_head mom_tool_head"
  puts $tclf_id "  global turret_current mom_warning_info"
  puts $tclf_id ""
  puts $tclf_id "    set turret_current INDEPENDENT"
  puts $tclf_id "    set ind_head $ind_head"
  puts $tclf_id "    set dep_head $dep_head"
  puts $tclf_id ""
  puts $tclf_id "    if \{\$mom_tool_head != \$mom_kin_independent_head\} \{"
   puts $tclf_id "       set turret_current DEPENDENT"
  puts $tclf_id "    \}"
  puts $tclf_id ""
  puts $tclf_id "    if \{\$mom_tool_head != \"\$ind_head\" && \\"
   puts $tclf_id "         \$mom_tool_head != \"\$dep_head\"\} \{"
   puts $tclf_id "       set mom_warning_info \"mom_tool_head = \$mom_tool_head IS INVALID,\
   USING $dep_head\""
   puts $tclf_id "       MOM_catch_warning"
  puts $tclf_id "    \}"
 puts $tclf_id "\}"
}
if {$cur_machine == "lathe"} {
 puts $tclf_id "\n"
 puts $tclf_id "#============================================================="

#=======================================================================
puts $tclf_id "proc PB_LATHE_THREAD_SET \{ \} \{"
  puts $tclf_id "#============================================================="
  puts $tclf_id "  global mom_lathe_thread_type mom_lathe_thread_advance_type"
  puts $tclf_id "  global mom_lathe_thread_lead_i mom_lathe_thread_lead_k"
  puts $tclf_id "  global mom_motion_distance"
  puts $tclf_id "  global mom_lathe_thread_increment mom_lathe_thread_value"
  puts $tclf_id "  global thread_type thread_increment feed_rate_mode"
  puts $tclf_id ""
  puts $tclf_id "    switch \$mom_lathe_thread_advance_type \{"
   puts $tclf_id "      1 \{set thread_type CONSTANT ; MOM_suppress once E\}"
   puts $tclf_id "      2 \{set thread_type INCREASING ; MOM_force once E\}"
   puts $tclf_id "      default \{set thread_type DECREASING ; MOM_force once E\}"
  puts $tclf_id "    \}"
  puts $tclf_id ""
  puts $tclf_id "    if \{\$thread_type == \"INCREASING\" || \$thread_type == \"DECREASING\"\} \{"
   puts $tclf_id "      if \{\$mom_lathe_thread_type != 1\} \{"
    puts $tclf_id "        set LENGTH \$mom_motion_distance"
    puts $tclf_id "        set LEAD \$mom_lathe_thread_value"
    puts $tclf_id "        set INCR \$mom_lathe_thread_increment"
    puts $tclf_id "        set E \[expr abs(pow((\$LEAD + (\$INCR \* \$LENGTH)) , 2) - pow(\$LEAD , 2)) \/ 2 \* \$LENGTH\]"
    puts $tclf_id "        set thread_increment \$E"
   puts $tclf_id "      \}"
  puts $tclf_id "    \}"
  puts $tclf_id ""
  puts $tclf_id "    if \{\$mom_lathe_thread_lead_i == 0\} \{"
   puts $tclf_id "      MOM_suppress once I ; MOM_force once K"
   puts $tclf_id "    \} elseif \{\$mom_lathe_thread_lead_k == 0\} \{"
   puts $tclf_id "      MOM_suppress once K ; MOM_force once I"
   puts $tclf_id "    \} else \{"
   puts $tclf_id "      MOM_force once I ; MOM_force once K"
  puts $tclf_id "    \}"
 puts $tclf_id "\}"
}
if { ![string match "*lathe*" $cur_machine] && ![string match "*_wedm" $cur_machine] } {
 global mom_kin_var
 puts $tclf_id "\n"
 puts $tclf_id "#============================================================="

#=======================================================================
puts $tclf_id "proc PB_init_new_iks \{ \} \{"
  puts $tclf_id "#============================================================="
  puts $tclf_id "  global mom_kin_iks_usage mom_kin_spindle_axis"
  puts $tclf_id "  global mom_kin_4th_axis_vector mom_kin_5th_axis_vector"
  puts $tclf_id "\n"
  puts $tclf_id "   set mom_kin_iks_usage 1"
  puts $tclf_id ""
  puts $tclf_id "  \# Override spindle axis vector defined in PB_CMD_init_rotary"
  puts $tclf_id "   set mom_kin_spindle_axis(0)  $mom_kin_var(\$mom_kin_spindle_axis\(0\))"
  puts $tclf_id "   set mom_kin_spindle_axis(1)  $mom_kin_var(\$mom_kin_spindle_axis\(1\))"
  puts $tclf_id "   set mom_kin_spindle_axis(2)  $mom_kin_var(\$mom_kin_spindle_axis\(2\))"
  puts $tclf_id ""
  puts $tclf_id "  \# Unitize vectors"
  puts $tclf_id "   foreach i { 0 1 2 } {"
   puts $tclf_id "      set vec(\$i) \$mom_kin_spindle_axis(\$i)"
  puts $tclf_id "   }"
  puts $tclf_id "   VEC3_unitize vec mom_kin_spindle_axis"
  puts $tclf_id ""
  puts $tclf_id "   foreach i { 0 1 2 } {"
   puts $tclf_id "      set vec(\$i) \$mom_kin_4th_axis_vector(\$i)"
  puts $tclf_id "   }"
  puts $tclf_id "   VEC3_unitize vec mom_kin_4th_axis_vector"
  puts $tclf_id ""
  puts $tclf_id "   foreach i { 0 1 2 } {"
   puts $tclf_id "      set vec(\$i) \$mom_kin_5th_axis_vector(\$i)"
  puts $tclf_id "   }"
  puts $tclf_id "   VEC3_unitize vec mom_kin_5th_axis_vector"
  puts $tclf_id ""
  puts $tclf_id "  \# Reload kinematics"
  puts $tclf_id "   MOM_reload_kinematics"
 puts $tclf_id "\}"
}
puts $tclf_id "\n"
puts $tclf_id "#============================================================="

#=======================================================================
puts $tclf_id "proc PB_DELAY_TIME_SET \{ \} \{"
  puts $tclf_id "#============================================================="
  puts $tclf_id "  global mom_sys_delay_param mom_delay_value"
  puts $tclf_id "  global mom_delay_revs mom_delay_mode delay_time"
  puts $tclf_id ""
  puts $tclf_id "   # post builder provided format for the current mode:"
  puts $tclf_id "    if \{\[info exists mom_sys_delay_param(\$\{mom_delay_mode\},format)\] != 0\} \{"
   puts $tclf_id "      MOM_set_address_format dwell \$mom_sys_delay_param(\$\{mom_delay_mode\},format)"
  puts $tclf_id "    \}"
  puts $tclf_id ""
  puts $tclf_id "    switch \$mom_delay_mode \{"
   puts $tclf_id "      SECONDS \{set delay_time \$mom_delay_value\}"
   puts $tclf_id "      default \{set delay_time \$mom_delay_revs\}"
  puts $tclf_id "    \}"
 puts $tclf_id "\}"
 puts $tclf_id "\n"
 puts $tclf_id "#============================================================="

#=======================================================================
puts $tclf_id "proc MOM_before_motion \{ \} \{"
  puts $tclf_id "#============================================================="
  puts $tclf_id "  global mom_motion_event mom_motion_type"
  puts $tclf_id ""
  puts $tclf_id "    FEEDRATE_SET"
  puts $tclf_id ""
  if {$lathe_output_method == "TURRET_REF"} {
   puts $tclf_id "    global mom_pos mom_ref_pos"
   puts $tclf_id "    set mom_pos(0) \$mom_ref_pos(0)"
   puts $tclf_id "    set mom_pos(1) \$mom_ref_pos(1)"
   puts $tclf_id "    set mom_pos(2) \$mom_ref_pos(2)"
   puts $tclf_id ""
   puts $tclf_id "    switch \$mom_motion_event \{"
    puts $tclf_id "      circular_move \{"
     puts $tclf_id "        global mom_ref_pos_arc_center mom_pos_arc_center"
     puts $tclf_id "        if \{\[hiset mom_ref_pos_arc_center(0)\]\} \{set mom_pos_arc_center(0) \$mom_ref_pos_arc_center(0)\}"
     puts $tclf_id "        if \{\[hiset mom_ref_pos_arc_center(1)\]\} \{set mom_pos_arc_center(1) \$mom_ref_pos_arc_center(1)\}"
     puts $tclf_id "        if \{\[hiset mom_ref_pos_arc_center(2)\]\} \{set mom_pos_arc_center(2) \$mom_ref_pos_arc_center(2)\}"
    puts $tclf_id "      \}"
    puts $tclf_id "      from_move \{"
     puts $tclf_id "        global mom_from_ref_pos mom_from_pos"
     puts $tclf_id "        if \{\[hiset mom_from_ref_pos(0)\]\} \{set mom_from_pos(0) \$mom_from_ref_pos(0)\}"
     puts $tclf_id "        if \{\[hiset mom_from_ref_pos(1)\]\} \{set mom_from_pos(1) \$mom_from_ref_pos(1)\}"
     puts $tclf_id "        if \{\[hiset mom_from_ref_pos(2)\]\} \{set mom_from_pos(2) \$mom_from_ref_pos(2)\}"
    puts $tclf_id "      \}"
    puts $tclf_id "      gohome_move \{"
     puts $tclf_id "        global mom_gohome_ref_pos mom_gohome_pos"
     puts $tclf_id "        if \{\[hiset mom_gohome_ref_pos(0)\]\} \{set mom_gohome_pos(0) \$mom_gohome_ref_pos(0)\}"
     puts $tclf_id "        if \{\[hiset mom_gohome_ref_pos(1)\]\} \{set mom_gohome_pos(1) \$mom_gohome_ref_pos(1)\}"
     puts $tclf_id "        if \{\[hiset mom_gohome_ref_pos(2)\]\} \{set mom_gohome_pos(2) \$mom_gohome_ref_pos(2)\}"
    puts $tclf_id "      \}"
   puts $tclf_id "    \}"
  }
  puts $tclf_id ""
  puts $tclf_id "    switch \$mom_motion_type {"
   if [string match "*_wedm" $cur_machine] {
    puts $tclf_id "      ENGAGE   {PB_CMD_kin_wedm_engage_move}"
    } else {
    puts $tclf_id "      ENGAGE   {PB_engage_move}"
   }
   puts $tclf_id "      APPROACH {PB_approach_move}"
   puts $tclf_id "      FIRSTCUT {PB_first_cut}"
   if { ![string match "*_wedm" $cur_machine] } {
    puts $tclf_id "      RETRACT  {PB_retract_move}"
   }
   puts $tclf_id "      RETURN   {PB_return_move}"
  puts $tclf_id "    }"
  puts $tclf_id ""
  puts $tclf_id "    if \[llength \[info commands PB_CMD_kin_before_motion\] \] \{ PB_CMD_kin_before_motion \}"
  puts $tclf_id "    if \[llength \[info commands PB_CMD_before_motion\] \]     \{ PB_CMD_before_motion \}"
 puts $tclf_id "\}"
 puts $tclf_id "\n"
 puts $tclf_id "#============================================================="

#=======================================================================
puts $tclf_id "proc MOM_start_of_group \{\} \{"
  puts $tclf_id "#============================================================="
  puts $tclf_id "  global mom_sys_group_output mom_group_name group_level ptp_file_name"
  puts $tclf_id "  global mom_sequence_number mom_sequence_increment mom_sequence_frequency"
  puts $tclf_id "  global mom_sys_ptp_output pb_start_of_program_flag"
  puts $tclf_id ""
  puts $tclf_id "    if \{!\[hiset group_level\]\} \{set group_level 0 ; return\}"
  puts $tclf_id ""
  puts $tclf_id "    if \{\[hiset mom_sys_group_output\]\} \{if \{\$mom_sys_group_output == \"OFF\"\} \{set group_level 0 ; return\}\}"
  puts $tclf_id ""
  puts $tclf_id "    if \{\[hiset group_level\]\} \{incr group_level\} else \{set group_level 1\}"
  puts $tclf_id "    if \{\$group_level > 1\} \{return\}"
  puts $tclf_id ""
  puts $tclf_id "    SEQNO_RESET ; #<4133654>"
  puts $tclf_id "    MOM_reset_sequence \$mom_sequence_number \$mom_sequence_increment \$mom_sequence_frequency"
  puts $tclf_id ""
  puts $tclf_id "    if \{\[info exists ptp_file_name\]\} \{"
   puts $tclf_id "      MOM_close_output_file \$ptp_file_name ; MOM_start_of_program"
   puts $tclf_id "      if \{\$mom_sys_ptp_output == \"ON\"\} \{MOM_open_output_file \$ptp_file_name \}"
   puts $tclf_id "    \} else \{"
   puts $tclf_id "      MOM_start_of_program"
  puts $tclf_id "    \}"
  puts $tclf_id ""
  puts $tclf_id "    PB_start_of_program ; set pb_start_of_program_flag 1"
 puts $tclf_id "\}"
 puts $tclf_id "\n"
 puts $tclf_id "#============================================================="

#=======================================================================
puts $tclf_id "proc MOM_machine_mode \{\} \{"
  puts $tclf_id "#============================================================="
  puts $tclf_id "  global pb_start_of_program_flag"
  puts $tclf_id "  global mom_operation_name mom_sys_change_mach_operation_name"
  puts $tclf_id ""
  puts $tclf_id "   set mom_sys_change_mach_operation_name \$mom_operation_name"
  puts $tclf_id ""
  puts $tclf_id "    if \{\$pb_start_of_program_flag == 0\} \{PB_start_of_program ; set pb_start_of_program_flag 1\}"
  puts $tclf_id ""
  puts $tclf_id "    if \[llength \[info commands PB_machine_mode\] \] {"
   puts $tclf_id "       if \[catch \{PB_machine_mode\} res\] {"
    puts $tclf_id "          global mom_warning_info"
    puts $tclf_id "          set mom_warning_info \"\$res\""
    puts $tclf_id "          MOM_catch_warning"
   puts $tclf_id "       }"
  puts $tclf_id "    }"
 puts $tclf_id "\}"
 if { [info exists mom_sys_arr(\$mom_sys_mill_turn_type)] && \
  [string match "SIMPLE_MILL_TURN" $mom_sys_arr(\$mom_sys_mill_turn_type)] } {
  puts $tclf_id ""
  puts $tclf_id ""
  puts $tclf_id "#============================================================="

#=======================================================================
puts $tclf_id "proc PB_machine_mode { } {"
  puts $tclf_id "#============================================================="
  puts $tclf_id "#"
  puts $tclf_id "# This procedure is used by a simple mill/turn post."
  puts $tclf_id "# DO NOT change any code in this procedure unless you know"
  puts $tclf_id "# what you are doing."
  puts $tclf_id "#"
  puts $tclf_id ""
  puts $tclf_id "   global mom_sys_mill_turn_mode  mom_sys_mill_turn_type"
  puts $tclf_id ""
  puts $tclf_id "   if { !\[info exists mom_sys_mill_turn_mode\] } {"
   puts $tclf_id "return"
  puts $tclf_id "   }"
  puts $tclf_id ""
  puts $tclf_id "   if { \[info exists mom_sys_mill_turn_type\] && \\"
   puts $tclf_id "       !\[string match \"SIMPLE_MILL_TURN\" \$mom_sys_mill_turn_type\] } {"
   puts $tclf_id "return"
  puts $tclf_id "   }"
  puts $tclf_id ""
  puts $tclf_id "   global mom_machine_mode"
  puts $tclf_id "   global mom_sys_mill_postname"
  puts $tclf_id "   global mom_sys_lathe_postname"
  puts $tclf_id "   global mom_load_event_handler"
  puts $tclf_id "   global mom_sys_current_head"
  puts $tclf_id "   global mom_sys_head_change_init_program"
  puts $tclf_id "   global mom_warning_info"
  puts $tclf_id ""
  puts $tclf_id "   if { \$mom_machine_mode == \"LATHE\" } { set mom_machine_mode \"TURN\" }"
  puts $tclf_id ""
  puts $tclf_id "   if { \$mom_machine_mode == \"MILL\" } {"
   puts $tclf_id ""
   puts $tclf_id "      if { \$mom_sys_current_head == \"TURN\" } {"
    puts $tclf_id "          if \[llength \[info commands PB_end_of_HEAD__TURN\]\] {"
     puts $tclf_id "             PB_end_of_HEAD__TURN"
    puts $tclf_id "          }"
   puts $tclf_id "      }"
   puts $tclf_id ""
   puts $tclf_id "      set mom_sys_current_head MILL"
   puts $tclf_id ""
   if 0 {
    puts $tclf_id "       set mom_warning_info \"Load mill post : \$mom_sys_mill_postname\""
    puts $tclf_id "       MOM_catch_warning"
    puts $tclf_id ""
   }
   puts $tclf_id "      set mom_load_event_handler  \"\$mom_sys_mill_postname.tcl\""
   puts $tclf_id "      MOM_load_definition_file    \"\$mom_sys_mill_postname.def\""
   puts $tclf_id ""
   puts $tclf_id "      if \[llength \[info commands PB_start_of_HEAD__MILL\]\] {"
    puts $tclf_id "         PB_start_of_HEAD__MILL"
   puts $tclf_id "      }"
   puts $tclf_id ""
   puts $tclf_id "      set mom_sys_head_change_init_program 1"
   puts $tclf_id ""
   puts $tclf_id "   } elseif { \$mom_machine_mode == \"TURN\" } {"
   puts $tclf_id ""
   puts $tclf_id "      if { \$mom_sys_current_head == \"MILL\" } {"
    puts $tclf_id "         if \[llength \[info commands PB_end_of_HEAD__MILL\]\] {"
     puts $tclf_id "            PB_end_of_HEAD__MILL"
    puts $tclf_id "         }"
   puts $tclf_id "      }"
   puts $tclf_id ""
   puts $tclf_id "      set mom_sys_current_head \"TURN\""
   puts $tclf_id "      set mom_sys_lathe_postname   \"\[file rootname \[file tail \$mom_sys_lathe_postname\]\]\""
   puts $tclf_id ""
   puts $tclf_id "      global cam_post_dir"
   puts $tclf_id "      if \[file exists \"\${cam_post_dir}\$mom_sys_lathe_postname.tcl\"\] {"
    puts $tclf_id ""
    if 0 {
     puts $tclf_id "          set mom_warning_info \"Load lathe post : \$cam_post_dir\$mom_sys_lathe_postname\""
     puts $tclf_id "          MOM_catch_warning"
     puts $tclf_id ""
    }
    puts $tclf_id "         set mom_load_event_handler   \"\${cam_post_dir}\$mom_sys_lathe_postname.tcl\""
    puts $tclf_id "         MOM_load_definition_file     \"\${cam_post_dir}\$mom_sys_lathe_postname.def\""
    puts $tclf_id ""
    puts $tclf_id "      } else {"
    puts $tclf_id ""
    puts $tclf_id "         set tcl_file \"\[file dirname \$mom_sys_mill_postname\]/\$mom_sys_lathe_postname.tcl\""
    puts $tclf_id "         set def_file \"\[file dirname \$mom_sys_mill_postname\]/\$mom_sys_lathe_postname.def\""
    puts $tclf_id ""
    puts $tclf_id "         if \[file exists \"\$tcl_file\"\] {"
     puts $tclf_id ""
     if 0 {
      puts $tclf_id "             set mom_warning_info \"Load lathe post : \$tcl_file\""
      puts $tclf_id "             MOM_catch_warning"
      puts $tclf_id ""
     }
     puts $tclf_id "            global tcl_platform"
     puts $tclf_id ""
     puts $tclf_id "            if \[string match \"*windows*\" \$tcl_platform(platform)\] {"
      puts $tclf_id "               regsub -all {/} \$tcl_file {\\\\} tcl_file"
      puts $tclf_id "               regsub -all {/} \$def_file {\\\\} def_file"
     puts $tclf_id "            }"
     puts $tclf_id ""
     puts $tclf_id "            set mom_load_event_handler   \"\$tcl_file\""
     puts $tclf_id "            MOM_load_definition_file     \"\$def_file\""
     puts $tclf_id ""
     puts $tclf_id "         } else {"
     puts $tclf_id "            set mom_warning_info \
     \"Lathe post \$mom_sys_lathe_postname not found\""
     puts $tclf_id "            MOM_catch_warning"
    puts $tclf_id "         }"
   puts $tclf_id "      }"
   puts $tclf_id ""
   puts $tclf_id "      if \[llength \[info commands PB_CMD_kin_before_motion\]\] {"
    puts $tclf_id "         rename PB_CMD_kin_before_motion \"\""
   puts $tclf_id "      }"
   puts $tclf_id ""
   puts $tclf_id "      if \[llength \[info commands PB_start_of_HEAD__TURN\]\] {"
    puts $tclf_id "         PB_start_of_HEAD__TURN"
   puts $tclf_id "      }"
  puts $tclf_id "   }"
  puts $tclf_id ""
  puts $tclf_id "   rename MOM_start_of_program MOM_start_of_program_save"
  puts $tclf_id "   rename MOM_end_of_program   MOM_end_of_program_save"
 puts $tclf_id "}"
}
puts $tclf_id "\n"
puts $tclf_id "#============================================================="

#=======================================================================
puts $tclf_id "proc PB_FORCE \{ option args \} \{"
  puts $tclf_id "#============================================================="
  puts $tclf_id "   set adds \[join \$args\]"
  puts $tclf_id "   if \{ \[info exists option\] && \[llength \$adds\] \} \{"
   puts $tclf_id "      lappend cmd MOM_force"
   puts $tclf_id "      lappend cmd \$option"
   puts $tclf_id "      lappend cmd \[join \$adds\]"
   puts $tclf_id "      eval \[join \$cmd\]"
  puts $tclf_id "   \}"
 puts $tclf_id "\}"
 puts $tclf_id "\n"
 puts $tclf_id "#============================================================="

#=======================================================================
puts $tclf_id "proc PB_SET_RAPID_MOD \{ mod_list blk_list ADDR NEW_MOD_LIST \} \{"
  puts $tclf_id "#============================================================="
  puts $tclf_id "  upvar \$ADDR addr"
  puts $tclf_id "  upvar \$NEW_MOD_LIST new_mod_list"
  puts $tclf_id "  global mom_cycle_spindle_axis traverse_axis1 traverse_axis2"
  puts $tclf_id ""
  puts $tclf_id ""
  puts $tclf_id "   set new_mod_list \[list\]"
  puts $tclf_id ""
  puts $tclf_id "   foreach mod \$mod_list \{"
   puts $tclf_id "      switch \$mod \{"
    puts $tclf_id "         \"rapid1\" \{"
     puts $tclf_id "            set elem \$addr(\$traverse_axis1)"
     puts $tclf_id "            if \{ \[lsearch \$blk_list \$elem\] >= 0 \} \{"
      puts $tclf_id "               lappend new_mod_list \$elem"
     puts $tclf_id "            \}"
    puts $tclf_id "         \}"
    puts $tclf_id "         \"rapid2\" \{"
     puts $tclf_id "            set elem \$addr(\$traverse_axis2)"
     puts $tclf_id "            if \{ \[lsearch \$blk_list \$elem\] >= 0 \} \{"
      puts $tclf_id "               lappend new_mod_list \$elem"
     puts $tclf_id "            \}"
    puts $tclf_id "         \}"
    puts $tclf_id "         \"rapid3\" \{"
     puts $tclf_id "            set elem \$addr(\$mom_cycle_spindle_axis)"
     puts $tclf_id "            if \{ \[lsearch \$blk_list \$elem\] >= 0 \} \{"
      puts $tclf_id "               lappend new_mod_list \$elem"
     puts $tclf_id "            \}"
    puts $tclf_id "         \}"
    puts $tclf_id "         default \{"
     puts $tclf_id "            set elem \$mod"
     puts $tclf_id "            if \{ \[lsearch \$blk_list \$elem\] >= 0 \} \{"
      puts $tclf_id "               lappend new_mod_list \$elem"
     puts $tclf_id "            \}"
    puts $tclf_id "         \}"
   puts $tclf_id "      \}"
  puts $tclf_id "   \}"
 puts $tclf_id "\}"
 puts $tclf_id "\n"
 puts $tclf_id "########################"
 puts $tclf_id "# Redefine FEEDRATE_SET"
 puts $tclf_id "########################"
 puts $tclf_id "if \[llength \[info commands ugpost_FEEDRATE_SET\] \] {"
  puts $tclf_id "   rename ugpost_FEEDRATE_SET \"\""
 puts $tclf_id "}"
 puts $tclf_id ""
 puts $tclf_id "if \[llength \[info commands FEEDRATE_SET\] \] {"
  puts $tclf_id "   rename FEEDRATE_SET ugpost_FEEDRATE_SET"
  puts $tclf_id "} else {"

#=======================================================================
puts $tclf_id "   proc ugpost_FEEDRATE_SET {} {}"
puts $tclf_id "}"
puts $tclf_id "\n"
puts $tclf_id "#============================================================="

#=======================================================================
puts $tclf_id "proc FEEDRATE_SET { } {"
  puts $tclf_id "#============================================================="
  puts $tclf_id "   if \[llength \[info commands PB_CMD_kin_feedrate_set\] \] {"
   puts $tclf_id "      PB_CMD_kin_feedrate_set"
   puts $tclf_id "   } else {"
   puts $tclf_id "      ugpost_FEEDRATE_SET"
  puts $tclf_id "   }"
 puts $tclf_id "}"
 puts $tclf_id "\n"
 if 0 {
  puts $tclf_id "#============================================================="

#=======================================================================
puts $tclf_id "proc MODES_SET { } {"
  puts $tclf_id "#============================================================="
  puts $tclf_id "   global mom_output_mode"
  puts $tclf_id "   switch \$mom_output_mode {"
   puts $tclf_id "      ABSOLUTE { set isincr OFF }"
   puts $tclf_id "      default  { set isincr ON }"
  puts $tclf_id "   }"
  puts $tclf_id ""
  puts $tclf_id "   MOM_incremental \$isincr X Y Z"
  puts $tclf_id ""
  puts $tclf_id "   global mom_kin_4th_axis_incr_switch mom_kin_5th_axis_incr_switch"
  puts $tclf_id "   if \[string match \"ON\" \$mom_kin_4th_axis_incr_switch\] {"
   puts $tclf_id "      MOM_incremental \$isincr fourth_axis"
  puts $tclf_id "   }"
  puts $tclf_id "   if \[string match \"ON\" \$mom_kin_5th_axis_incr_switch\] {"
   puts $tclf_id "      MOM_incremental \$isincr fifth_axis"
  puts $tclf_id "   }"
 puts $tclf_id "}"
 puts $tclf_id "\n"
}
if [string match "*_wedm" $cur_machine] {
 puts $tclf_id "#============================================================="

#=======================================================================
puts $tclf_id "proc MOM_wire_cutcom { } {"
  puts $tclf_id "#============================================================="
  puts $tclf_id "  global mom_wire_cutcom_status mom_wire_cutcom_mode"
  puts $tclf_id "  global mom_cutcom_status mom_cutcom_mode"
  puts $tclf_id ""
  puts $tclf_id "    set mom_cutcom_status \$mom_wire_cutcom_status"
  puts $tclf_id "    set mom_cutcom_mode \$mom_wire_cutcom_mode"
  puts $tclf_id ""
  puts $tclf_id "    switch \$mom_wire_cutcom_status {"
   puts $tclf_id "       ON  { MOM_cutcom_on }"
   puts $tclf_id "       OFF { MOM_cutcom_off }"
  puts $tclf_id "    }"
 puts $tclf_id "}"
 puts $tclf_id "\n"
}
if {$::env(PB_UDE_ENABLED) != 1} {
 if { [info exists mom_sys_arr(\$mom_sys_mill_turn_type)] && \
  [string match "SIMPLE_MILL_TURN" $mom_sys_arr(\$mom_sys_mill_turn_type)] } {
  } elseif { $mom_sys_arr(\$is_linked_post) == 1 } {
  puts $tclf_id "#============================================================="

#=======================================================================
puts $tclf_id "proc MOM_head { } {"
  puts $tclf_id "#============================================================="
  puts $tclf_id "   global mom_warning_info"
  puts $tclf_id ""
  puts $tclf_id "   global mom_sys_in_operation"
  puts $tclf_id "   if { \[info exists mom_sys_in_operation\] && \$mom_sys_in_operation == 1 } {"
   puts $tclf_id "      global mom_operation_name"
   puts $tclf_id "      set mom_warning_info \"HEAD event should not be assigned to an operatrion (\$mom_operation_name).\""
   puts $tclf_id "      MOM_catch_warning"
   puts $tclf_id "return"
  puts $tclf_id "   }"
  puts $tclf_id ""
  if 0 {
   puts $tclf_id ""
   puts $tclf_id "   global mom_sys_in_operation"
   puts $tclf_id "   if { !\[info exists mom_sys_in_operation\] || !\$mom_sys_in_operation } {"
    puts $tclf_id "      set mom_warning_info \"HEAD event should not be assigned to an operatrion.\""
    puts $tclf_id "      MOM_catch_warning"
    puts $tclf_id "return"
   puts $tclf_id "   }"
   puts $tclf_id ""
  }
  puts $tclf_id "   global mom_head_name mom_sys_postname"
  puts $tclf_id "   global mom_load_event_handler"
  puts $tclf_id "   global CURRENT_HEAD NEXT_HEAD"
  puts $tclf_id "   global mom_sys_prev_mach_head mom_sys_curr_mach_head"
  puts $tclf_id "   global mom_sys_head_change_init_program"
  puts $tclf_id ""
  puts $tclf_id "   if { !\[info exists CURRENT_HEAD\] } {"
   puts $tclf_id "      set CURRENT_HEAD \"\""
  puts $tclf_id "   }"
  puts $tclf_id ""
  puts $tclf_id "   if { \[info exists mom_head_name\] } {"
   puts $tclf_id "      set NEXT_HEAD \$mom_head_name"
   puts $tclf_id "   } else {"
   puts $tclf_id "      set mom_warning_info \"No HEAD event has been assigned.\""
   puts $tclf_id "      MOM_catch_warning"
   puts $tclf_id "return"
  puts $tclf_id "   }"
  puts $tclf_id ""
  puts $tclf_id "   set head_list \[array names mom_sys_postname\]"
  puts $tclf_id "   foreach h \$head_list {"
   if 0 {
    puts $tclf_id "      if { \[regexp -nocase \"\$mom_head_name\" \$h\] == 1 } {"
     puts $tclf_id "         set NEXT_HEAD \$h"
     puts $tclf_id "         break"
    puts $tclf_id "      }"
   }
   puts $tclf_id "      if { \[regexp -nocase ^\$mom_head_name\$ \$h\] == 1 } {"
    puts $tclf_id "         set NEXT_HEAD \$h"
    puts $tclf_id "         break"
   puts $tclf_id "      }"
  puts $tclf_id "   }"
  puts $tclf_id ""
  puts $tclf_id ""
  puts $tclf_id "   set tcl_file \"\""
  puts $tclf_id ""
  puts $tclf_id "   if { !\[info exists mom_sys_postname(\$NEXT_HEAD)\] } {"
   puts $tclf_id ""
   puts $tclf_id "      set mom_warning_info \"Post is not specified with Head (\$NEXT_HEAD).\""
   puts $tclf_id "      MOM_catch_warning"
   puts $tclf_id ""
   puts $tclf_id "   } elseif { !\[string match \"\$NEXT_HEAD\" \$CURRENT_HEAD\] } {"
   puts $tclf_id ""
   puts $tclf_id "      if { \[llength \[info commands PB_end_of_HEAD__\$CURRENT_HEAD\]\] } {"
    puts $tclf_id "         PB_end_of_HEAD__\$CURRENT_HEAD"
   puts $tclf_id "      }"
   puts $tclf_id ""
   puts $tclf_id "      set mom_sys_prev_mach_head \$CURRENT_HEAD"
   puts $tclf_id "      set mom_sys_curr_mach_head \$NEXT_HEAD"
   puts $tclf_id ""
   puts $tclf_id "      set CURRENT_HEAD \$NEXT_HEAD"
   puts $tclf_id "\n"
   puts $tclf_id "      global mom_sys_master_head mom_sys_master_post cam_post_dir"
   puts $tclf_id ""
   puts $tclf_id "      if \[string match \"\$CURRENT_HEAD\" \$mom_sys_master_head\] {"
    if 0 {
     puts $tclf_id ""
     puts $tclf_id "          set mom_warning_info \"Load post : \$mom_sys_master_post\""
     puts $tclf_id "          MOM_catch_warning"
    }
    puts $tclf_id ""
    puts $tclf_id "         set mom_load_event_handler \"\\\"\$mom_sys_master_post.tcl\\\"\""
    puts $tclf_id "         MOM_load_definition_file   \"\$mom_sys_master_post.def\""
    puts $tclf_id ""
    puts $tclf_id "         set tcl_file \"\$mom_sys_master_post.tcl\""
    puts $tclf_id ""
    puts $tclf_id "      } else {"
    puts $tclf_id ""
    puts $tclf_id "         set tcl_file \"\[file dirname \$mom_sys_master_post\]/\$mom_sys_postname(\$CURRENT_HEAD).tcl\""
    puts $tclf_id "         set def_file \"\[file dirname \$mom_sys_master_post\]/\$mom_sys_postname(\$CURRENT_HEAD).def\""
    puts $tclf_id ""
    puts $tclf_id "         if \[file exists \"\$tcl_file\"\] {"
     if 0 {
      puts $tclf_id ""
      puts $tclf_id "             set mom_warning_info \"Load post : \$tcl_file\""
      puts $tclf_id "             MOM_catch_warning"
     }
     puts $tclf_id ""
     puts $tclf_id "            global tcl_platform"
     puts $tclf_id ""
     puts $tclf_id "            if \[string match \"*windows*\" \$tcl_platform(platform)\] {"
      puts $tclf_id "               regsub -all {/} \$tcl_file {\\\\} tcl_file"
      puts $tclf_id "               regsub -all {/} \$def_file {\\\\} def_file"
     puts $tclf_id "            }"
     puts $tclf_id ""
     puts $tclf_id "            set mom_load_event_handler \"\\\"\$tcl_file\\\"\""
     puts $tclf_id "            MOM_load_definition_file   \"\$def_file\""
     puts $tclf_id ""
     puts $tclf_id "         } else {"
     puts $tclf_id ""
     puts $tclf_id "            set tcl_file \"\${cam_post_dir}\$mom_sys_postname(\$CURRENT_HEAD).tcl\""
     puts $tclf_id "            set def_file \"\${cam_post_dir}\$mom_sys_postname(\$CURRENT_HEAD).def\""
     puts $tclf_id ""
     puts $tclf_id "            if \[file exists \"\$tcl_file\"\] {"
      if 0 {
       puts $tclf_id ""
       puts $tclf_id "                set mom_warning_info \"Load post : \$tcl_file\""
       puts $tclf_id "                MOM_catch_warning"
      }
      puts $tclf_id ""
      puts $tclf_id "               set mom_load_event_handler \"\\\"\$tcl_file\\\"\""
      puts $tclf_id "               MOM_load_definition_file   \"\$def_file\""
      puts $tclf_id ""
      puts $tclf_id "            } else {"
      puts $tclf_id "               set mom_warning_info \
      \"Post (\$mom_sys_postname(\$CURRENT_HEAD)) for HEAD (\$CURRENT_HEAD) not found.\""
      puts $tclf_id "               MOM_catch_warning"
     puts $tclf_id "            }"
     if 0 {
      puts $tclf_id "            set mom_load_event_handler \\"
      puts $tclf_id "            \"\\\"\${cam_post_dir}\$mom_sys_postname(\$CURRENT_HEAD).tcl\\\"\""
      puts $tclf_id ""
      puts $tclf_id "            MOM_load_definition_file \\"
      puts $tclf_id "            \"\${cam_post_dir}\$mom_sys_postname(\$CURRENT_HEAD).def\""
     }
    puts $tclf_id "         }"
   puts $tclf_id "      }"
   puts $tclf_id "\n"
   if 0 {
    puts $tclf_id "      if { \[llength \[info commands PB_start_of_HEAD__\$CURRENT_HEAD\]\] } {"
     puts $tclf_id "         PB_start_of_HEAD__\$CURRENT_HEAD"
    puts $tclf_id "      }"
    puts $tclf_id ""
   }
   if { [info exists mom_sys_arr(Output_VNC)] && \
    $mom_sys_arr(Output_VNC) == 1 } {
    puts $tclf_id "      global sim_mtd_initialized"
    puts $tclf_id "      if \$sim_mtd_initialized {"
     puts $tclf_id "         if \[llength \[info commands PB_VNC_pass_head_data\]\] {"
      puts $tclf_id "            global mom_sys_sim_post_name"
      puts $tclf_id "            set mom_sys_sim_post_name \[file rootname \"\$tcl_file\"\]"
      puts $tclf_id "            PB_VNC_pass_head_data"
     puts $tclf_id "         }"
    puts $tclf_id "      }"
    puts $tclf_id "\n"
   }
   puts $tclf_id "      set mom_sys_head_change_init_program 1"
   puts $tclf_id ""
   if 0 {
    puts $tclf_id "      rename MOM_start_of_program MOM_start_of_program_save"
    puts $tclf_id "      rename MOM_end_of_program MOM_end_of_program_save"
    puts $tclf_id "      rename MOM_head MOM_head_save"
    } else {
    puts $tclf_id "      if \[llength \[info commands MOM_start_of_program_save\]\] {"
     puts $tclf_id "         rename MOM_start_of_program_save \"\""
    puts $tclf_id "      }"
    puts $tclf_id "      rename MOM_start_of_program MOM_start_of_program_save"
    puts $tclf_id ""
    puts $tclf_id "      if \[llength \[info commands MOM_end_of_program\]\] {"
     puts $tclf_id "         if \[llength \[info commands MOM_end_of_program_save\]\] {"
      puts $tclf_id "            rename MOM_end_of_program_save \"\""
     puts $tclf_id "         }"
     puts $tclf_id "         rename MOM_end_of_program MOM_end_of_program_save"
    puts $tclf_id "      }"
    puts $tclf_id ""
    puts $tclf_id "      if \[llength \[info commands MOM_head_save\]\] {"
     puts $tclf_id "         rename MOM_head_save \"\""
    puts $tclf_id "      }"
    puts $tclf_id "      rename MOM_head MOM_head_save"
   }
  puts $tclf_id "   }"
 puts $tclf_id "}"
 puts $tclf_id "\n"
 puts $tclf_id "#============================================================="

#=======================================================================
puts $tclf_id "proc MOM_Head { } {"
  puts $tclf_id "#============================================================="
  puts $tclf_id "   MOM_head"
 puts $tclf_id "}"
 puts $tclf_id "\n"
 puts $tclf_id "#============================================================="

#=======================================================================
puts $tclf_id "proc MOM_HEAD { } {"
  puts $tclf_id "#============================================================="
  puts $tclf_id "   MOM_head"
 puts $tclf_id "}"
 puts $tclf_id "\n"
}
} ;#<07-27-06 peter>for ude
}

#=======================================================================
proc PB_PB2TCL_write_tcl_procs2 { TCLF_ID } {
  upvar $TCLF_ID tclf_id
  PB_output_GetEvtObjAttr2 evt_name_list evt_blk_arr
  PB_output_RetBlksModality blk_mod_arr
  set evt_name_list [lsort $evt_name_list]
  foreach event_name $evt_name_list \
  {
   PB_output_GetEventProcData event_name evt_blk_arr($event_name) \
   blk_mod_arr event_output
   PB_PB2TCL_write_event_procs tclf_id event_output
   unset event_output
  }
 }

#=======================================================================
proc PB_PB2TCL_write_tcl_procs { TCLF_ID } {
  upvar $TCLF_ID tclf_id
  puts $tclf_id "############## EVENT HANDLING SECTION ################"
  PB_output_GetEvtObjAttr evt_name_list evt_blk_arr udc_name_list
  PB_output_RetBlksModality blk_mod_arr
  set evt_name_list [lsort $evt_name_list]
  set useless_handler_list [list MOM_peck_drill MOM_drill_csink MOM_break_chip]
  foreach one $useless_handler_list {
   set idx [lsearch $evt_name_list $one]
   if {$idx >= 0} {
    set evt_name_list [lreplace $evt_name_list $idx $idx]
   }
  }
  foreach event_name $evt_name_list \
  {
   PB_output_GetEventProcData event_name evt_blk_arr($event_name) \
   blk_mod_arr event_output $udc_name_list
   PB_output_special_case_end event_name event_output
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
proc __output_mom_do_template { OUTPUT_BUFFER n_blank block_name BLK_MOD_ARR args } {
  upvar $OUTPUT_BUFFER output_buffer
  upvar $BLK_MOD_ARR blk_mod_arr
  set blank_string ""
  if { $n_blank > 0 } {
   for { set i 0 } { $i < $n_blank } { incr i } {
    set blank_string "$blank_string "
   }
  }
  set template_string ""
  if [llength $args] {
   set template_string " [lindex $args 0]"
  }
  if [string match "comment_blk*" $block_name] {
   global post_object
   Post::GetObjList $post_object comment cmt_blk_obj_list
   PB_com_RetObjFrmName block_name cmt_blk_obj_list cmt_blk_obj
   if { $cmt_blk_obj > 0 } {
    block::readvalue $cmt_blk_obj cmt_blk_obj_attr
    set blk_elem [lindex $cmt_blk_obj_attr(2) 0]
    set elem_var $block_element::($blk_elem,elem_mom_variable)
    global gPB
    set cc_state $gPB(check_cc_unknown_command)
    set gPB(check_cc_unknown_command) 0
    if 0 {
     if { ![UI_PB_cmd_ValidateExpOK "Operator Message" $elem_var] } {
      set gPB(check_cc_unknown_command) $cc_state
      return
      } else {
      set block::($cmt_blk_obj,var_list) $gPB(CMD_VAR_LIST)
      set gPB(check_cc_unknown_command) $cc_state
     }
    }
    UI_PB_cmd_ValidateExpOK "Operator Message" $elem_var
    set block::($cmt_blk_obj,var_list) $gPB(CMD_VAR_LIST)
    set gPB(check_cc_unknown_command) $cc_state
    if { [info exists block::($cmt_blk_obj,var_list)] && \
     [llength $block::($cmt_blk_obj,var_list)] } {
     lappend output_buffer "${blank_string}global [join $block::($cmt_blk_obj,var_list)]"
    }
    array set mom_sys_var_arr $Post::($post_object,mom_sys_var_list)
    set comment_start [PB_output_EscapeSpecialControlChar $mom_sys_var_arr(Comment_Start)]
    set comment_end   [PB_output_EscapeSpecialControlChar $mom_sys_var_arr(Comment_End)]
    lappend output_buffer \
    "${blank_string}MOM_output_literal \"$comment_start$elem_var$comment_end\""
    } else {
    PB_output_OutputBlkModality $n_blank block_name blk_mod_arr output_buffer
    lappend output_buffer "${blank_string}MOM_do_template $block_name$template_string"
   }
   } else {
   PB_output_OutputBlkModality $n_blank block_name blk_mod_arr output_buffer
   lappend output_buffer "${blank_string}MOM_do_template $block_name$template_string"
  }
 }

#=======================================================================
proc PB_output_DefaultDataForUDC {EVT_NAME EVENT_OUTPUT} {
  upvar $EVT_NAME evt_name
  upvar $EVENT_OUTPUT event_output
  global cycle_init_flag
  set cycle_init_flag FALSE
  lappend event_output "  global cycle_name"
  lappend event_output "  global cycle_init_flag"
  lappend event_output ""
  append event_move $evt_name _move
  set cycle_name [string toupper [string trimleft $evt_name MOM_]]
  set cycle_init_flag TRUE
  lappend event_output "   set cycle_init_flag $cycle_init_flag"
  lappend event_output "   set cycle_name $cycle_name"
  lappend event_output "   CYCLE_SET"
 lappend event_output "\}"
 lappend event_output "\n"
 lappend event_output "#============================================================="

#=======================================================================
lappend event_output "proc $event_move \{ \} \{"
  lappend event_output "#============================================================="
  lappend event_output "  global cycle_init_flag"
  lappend event_output ""
 }

#=======================================================================
proc PB_output_DefaultDataAEvent { EVT_NAME EVENT_OUTPUT } {
  upvar $EVENT_OUTPUT event_output
  upvar $EVT_NAME evt_name
  global cycle_init_flag
  global mom_sys_arr gPB
  set cur_machine [PB2TCL_read_fly_var mom_fly_machine_type]
  set ind_head [PB2TCL_read_fly_var mom_fly_independent_head]
  set cycle_init_flag FALSE
  switch $evt_name \
  {
   MOM_drill_text \
   {
   lappend event_output "\}"
   lappend event_output "\n"
   lappend event_output "#============================================================="

#=======================================================================
lappend event_output "proc ${evt_name}_move \{ \} \{"
  lappend event_output "#============================================================="
  lappend event_output ""
  lappend event_output "   if { \[llength \[info commands PB_CMD_kin_abort_event\]\] } {"
   lappend event_output "      PB_CMD_kin_abort_event"
  lappend event_output "   }"
  lappend event_output ""
  lappend event_output ""
  if {$::env(PB_UDE_ENABLED) == 1} {
   set sys_cyc [list]
   PB_ude_RetUdeUdcObjList sys_mce non_sys_mce sys_cyc non_sys_cyc
   if {[llength $sys_cyc] > 0} {
    foreach obj $sys_cyc {
     set name [PB_ude_GetEventName $obj]
     set name [string tolower $name]
     set name [join [split $name " "] _]
     set name "MOM_$name"
     if {$name == $evt_name} {
      foreach one $cycle_event::($obj,param_obj_list) {
       if {[lsearch $gPB(sys_def_param_obj_list) $one] < 0} {
        set type [classof $one]
        set pname [set [set type]::($one,name)]
        lappend event_output "  global mom_${pname}"
       }
      }
      lappend event_output ""
     }
    }
   }
  }
 }
 MOM_thread              -
 MOM_lathe_thread        -
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
  lappend event_output ""
  append event_move $evt_name _move
  set cycle_name [string toupper [string trimleft $evt_name MOM_]]
  set cycle_init_flag TRUE
  lappend event_output "   set cycle_init_flag $cycle_init_flag"
  lappend event_output "   set cycle_name $cycle_name"
  if {$evt_name != "MOM_thread" && $evt_name != "MOM_lathe_thread"} {
   lappend event_output "   CYCLE_SET"
  }
 lappend event_output "\}"
 lappend event_output "\n"
 lappend event_output "#============================================================="

#=======================================================================
lappend event_output "proc $event_move \{ \} \{"
  lappend event_output "#============================================================="
  lappend event_output "  global cycle_init_flag"
  lappend event_output ""
  lappend event_output ""
  lappend event_output "   if { \[llength \[info commands PB_CMD_kin_abort_event\]\] } {"
   lappend event_output "      PB_CMD_kin_abort_event"
  lappend event_output "   }"
  lappend event_output ""
  lappend event_output ""
  if {$::env(PB_UDE_ENABLED) == 1} {
   set sys_cyc [list]
   PB_ude_RetUdeUdcObjList sys_mce non_sys_mce sys_cyc non_sys_cyc
   if { [llength $sys_cyc] > 0 } {
    foreach obj $sys_cyc {
     set name [PB_ude_GetEventName $obj]
     set name [string tolower $name]
     set name [join [split $name " "] _]
     set name "MOM_$name"
     if {$name == $evt_name} {
      foreach one $cycle_event::($obj,param_obj_list) {
       if {[lsearch $gPB(sys_def_param_obj_list) $one] < 0} {
        set type [classof $one]
        set pname [set [set type]::($one,name)]
        lappend event_output "  global mom_${pname}"
       }
      }
      lappend event_output ""
     }
    }
   }
  }
  if 0 {
   if { ![string match "*lathe*" $cur_machine] && ![string match "*_wedm*" $cur_machine] } {
    lappend event_output "   if \[llength \[info commands PB_CMD_set_cycle_plane\]\] {"
     lappend event_output "      PB_CMD_set_cycle_plane"
    lappend event_output "   }"
    lappend event_output ""
   }
  }
  if 0 {
   if { [info exists mom_sys_arr(Output_VNC)] && \
    $mom_sys_arr(Output_VNC) == 1 } {
    lappend event_output "   global sim_mtd_initialized"
    lappend event_output "   if \$sim_mtd_initialized {"
     lappend event_output "      if \[llength \[info commands PB_VNC_pass_cycle_spindle_axis\]\] {"
      lappend event_output "         PB_VNC_pass_cycle_spindle_axis"
     lappend event_output "      }"
    lappend event_output "   }"
    lappend event_output ""
   }
  }
  if {$evt_name == "MOM_thread" || $evt_name == "MOM_lathe_thread"} {
   lappend event_output "   PB_LATHE_THREAD_SET"
  }
  unset event_move
 }
 MOM_cycle_plane_change \
 {
  lappend event_output "  global cycle_init_flag"
  lappend event_output ""
  set cycle_init_flag TRUE
  lappend event_output "   set cycle_init_flag $cycle_init_flag"
 }
 MOM_thread_move         -
 MOM_lathe_thread_move   \
 {
  lappend event_output ""
  lappend event_output "   if { \[llength \[info commands PB_CMD_kin_abort_event\]\] } {"
   lappend event_output "      PB_CMD_kin_abort_event"
  lappend event_output "   }"
  lappend event_output ""
  lappend event_output ""
  lappend event_output "   PB_LATHE_THREAD_SET"
 }
 MOM_circular_move \
 {
  lappend event_output ""
  lappend event_output "   if { \[llength \[info commands PB_CMD_kin_abort_event\]\] } {"
   lappend event_output "      PB_CMD_kin_abort_event"
  lappend event_output "   }"
  lappend event_output ""
  lappend event_output ""
  if { ![string match "lathe" $cur_machine] && ![string match "*_wedm" $cur_machine] } {
   lappend event_output "   CIRCLE_SET"
  }
 }
 MOM_from_move \
 {
  lappend event_output "  global mom_feed_rate mom_feed_rate_per_rev \
  mom_motion_type mom_kin_max_fpm"
  lappend event_output "   COOLANT_SET ; CUTCOM_SET ; SPINDLE_SET ; RAPID_SET"
 }
 MOM_initial_move -
 MOM_first_move \
 {
  lappend event_output "  global mom_feed_rate mom_feed_rate_per_rev mom_motion_type"
  lappend event_output "  global mom_kin_max_fpm mom_motion_event"  ; #4202839
  lappend event_output "   COOLANT_SET ; CUTCOM_SET ; SPINDLE_SET ; RAPID_SET"
 }
 MOM_linear_move_30Apr2001_4263669 \
 {
  lappend event_output "  global mom_feed_rate mom_feed_rate_per_rev mom_kin_max_fpm first_linear_move"
  if {[PB2TCL_read_fly_var mom_fly_use_rapid_at_max_fpm] == "TRUE"} \
  {
   lappend event_output "   if \{\[info exists mom_kin_max_fpm\] != 0\} \{"
    lappend event_output "      if \{\$mom_feed_rate >= \$mom_kin_max_fpm\} \
    \{ MOM_rapid_move ; return \}"
   lappend event_output "   \}"
  }
  lappend event_output "   if \{!\$first_linear_move\} \{ PB_first_linear_move ; incr first_linear_move \}"
 }
 MOM_linear_move_05SEP01_4325407 \
 {
  lappend event_output "  global mom_feed_rate mom_feed_rate_per_rev mom_kin_max_fpm first_linear_move"
  lappend event_output "   if \{!\$first_linear_move\} \{ PB_first_linear_move ; incr first_linear_move \}"
  if {[PB2TCL_read_fly_var mom_fly_use_rapid_at_max_fpm] == "TRUE"} \
  {
   lappend event_output ""
   lappend event_output "  global mom_programmed_feed_rate"
   lappend event_output "   if \{ \[EQ_is_ge \$mom_programmed_feed_rate \$mom_kin_max_fpm\] \} \{"
    lappend event_output "      MOM_rapid_move ; return"
   lappend event_output "   \}"
   lappend event_output ""
  }
 }
 MOM_linear_move \
 {
  if {[PB2TCL_read_fly_var mom_fly_use_rapid_at_max_fpm] == "TRUE"} \
  {
   lappend event_output "  global feed_mode mom_feed_rate mom_kin_rapid_feed_rate"
   lappend event_output ""
   lappend event_output "   if \{ \$feed_mode == \"IPM\" \|\| \$feed_mode == \"MMPM\" \} \{"
    lappend event_output "      if \{ \[EQ_is_ge \$mom_feed_rate \$mom_kin_rapid_feed_rate\] \} \{"
     lappend event_output "         MOM_rapid_move"
     lappend event_output "         return"
    lappend event_output "      \}"
   lappend event_output "   \}"
   lappend event_output ""
  }
  lappend event_output ""
  lappend event_output "   if { \[llength \[info commands PB_CMD_kin_abort_event\]\] } {"
   lappend event_output "      PB_CMD_kin_abort_event"
  lappend event_output "   }"
  lappend event_output ""
  lappend event_output ""
  if { ![string match "*_wedm" $cur_machine] } {
   lappend event_output "   global first_linear_move"
   lappend event_output ""
   lappend event_output "   if { !\$first_linear_move } {"
    lappend event_output "      PB_first_linear_move"
    lappend event_output "      incr first_linear_move"
   lappend event_output "   }"
   lappend event_output ""
  }
  set machine_type [PB2TCL_read_fly_var mom_fly_machine_type]
  if [string match "3_axis_mill_turn" $machine_type] {
   lappend event_output "   if \[llength \[info commands PB_CMD_kin_linearize_motion\]\] {"
    lappend event_output "      PB_CMD_kin_linearize_motion"
   lappend event_output "   }"
   lappend event_output ""
  }
 }
 MOM_coolant_on  { lappend event_output "   COOLANT_SET" }
 MOM_coolant_off { lappend event_output "   COOLANT_SET" }
 MOM_cutcom_off  { lappend event_output "   CUTCOM_SET" }
 MOM_cutcom_on  \
 {
  if {[PB2TCL_read_fly_var mom_fly_cutcom_off_before_change] == "TRUE"} \
  {
   lappend event_output "  global mom_cutcom_status"
   lappend event_output ""
   lappend event_output "   if \{\$mom_cutcom_status != \"SAME\"\} \{ MOM_cutcom_off \}"
  }
  lappend event_output "   CUTCOM_SET"
  lappend event_output ""
  lappend event_output "   global mom_cutcom_adjust_register"
  lappend event_output "   set cutcom_register_min $mom_sys_arr(\$rad_offset_min)"
  lappend event_output "   set cutcom_register_max $mom_sys_arr(\$rad_offset_max)"
  lappend event_output "   if { \[info exists mom_cutcom_adjust_register\] } {"
   lappend event_output "      if { \$mom_cutcom_adjust_register < \$cutcom_register_min ||\\"
    lappend event_output "           \$mom_cutcom_adjust_register > \$cutcom_register_max } {"
    lappend event_output "         global mom_warning_info"
    lappend event_output "         set mom_warning_info \"CUTCOM register \$mom_cutcom_adjust_register\
    must be within the range between\
    $mom_sys_arr(\$rad_offset_min) and\
    $mom_sys_arr(\$rad_offset_max)\""
    lappend event_output "         MOM_catch_warning"
   lappend event_output "      }"
  lappend event_output "   }"
 }
 MOM_spindle_rpm   -
 MOM_spindle_css   { lappend event_output "   SPINDLE_SET" }
 MOM_tool_preselect \
 {
  lappend event_output "  global mom_tool_preselect_number mom_tool_number mom_next_tool_number"
  lappend event_output "   if \{\[info exists mom_tool_preselect_number\]\} \{"
   lappend event_output "      set mom_next_tool_number \$mom_tool_preselect_number"
  lappend event_output "   \}"
 }
 MOM_opskip  { lappend event_output "   OPSKIP_SET" }
 MOM_rapid_move \
 {
  lappend event_output "  global rapid_spindle_inhibit rapid_traverse_inhibit"
  lappend event_output "  global spindle_first is_from"
  lappend event_output "  global mom_cycle_spindle_axis traverse_axis1 traverse_axis2"
  lappend event_output "  global mom_motion_event"
  lappend event_output ""
  lappend event_output ""
  lappend event_output "   if { \[llength \[info commands PB_CMD_kin_abort_event\]\] } {"
   lappend event_output "      PB_CMD_kin_abort_event"
  lappend event_output "   }"
  lappend event_output ""
  lappend event_output ""
  lappend event_output "   set aa(0) X ; set aa(1) Y ; set aa(2) Z"
  lappend event_output "   RAPID_SET"
 }
 MOM_sequence_number   { lappend event_output "   SEQNO_SET" }
 MOM_set_modes         { lappend event_output "   MODES_SET" }
 MOM_length_compensation {lappend event_output "   TOOL_SET $evt_name"}
 MOM_start_of_path     \
 {
  lappend event_output "  global mom_sys_in_operation"
  lappend event_output "   set mom_sys_in_operation 1"
  lappend event_output ""
  lappend event_output "  global first_linear_move ; set first_linear_move 0"
  lappend event_output "   TOOL_SET $evt_name"
 }
 MOM_load_tool         -
 MOM_first_tool        -
 MOM_tool_change       \
 {
  lappend event_output "  global mom_tool_change_type mom_manual_tool_change"
  if { $ind_head != "" } {
   lappend event_output "   PB_TURRET_HEAD_SET"
  }
 }
 MOM_delay \
 {
  lappend event_output "   PB_DELAY_TIME_SET"
 }
 MOM_start_of_pass \
 {
  lappend event_output "  global mom_sys_start_of_pass"
  lappend event_output "  set mom_sys_start_of_pass 1"
 }
 MOM_end_of_pass \
 {
  lappend event_output "  PB_lead_out_move"
 }
}
}

#=======================================================================
proc __PB_output_RapidEventData { EVENT_OUTPUT BLK_MOD_ARR } {
  upvar $EVENT_OUTPUT event_output
  upvar $BLK_MOD_ARR blk_mod_arr
  set rapid_traverse [PB2TCL_read_fly_var mom_fly_rapid_traverse_blk]
  set rapid_spindle  [PB2TCL_read_fly_var mom_fly_rapid_spindle_blk]
  lappend event_output "   set spindle_block $rapid_spindle"
  lappend event_output "   set traverse_block $rapid_traverse"
  lappend event_output "   if \{\$spindle_first == \"TRUE\"\} \{"
   lappend event_output "      if \{\$rapid_spindle_inhibit == \"FALSE\"\} \{"
    __output_ForceRapidAddr event_output $rapid_spindle blk_mod_arr
    set lead_blanks "         "
    set wpc_flag  "wpc"
    __out_ForceAddr event_output $rapid_spindle $lead_blanks $wpc_flag
    lappend event_output \
    "         MOM_suppress once \$aa(\$traverse_axis1) \$aa(\$traverse_axis2)"
    lappend event_output "         MOM_do_template \$spindle_block \$is_from"
    lappend event_output \
    "         MOM_suppress off \$aa(\$traverse_axis1) \$aa(\$traverse_axis2)"
   lappend event_output "      \}"
   lappend event_output "      if \{\$rapid_traverse_inhibit == \"FALSE\"\} \{"
    __output_ForceRapidAddr event_output $rapid_traverse blk_mod_arr
    __out_ForceAddr event_output $rapid_traverse $lead_blanks $wpc_flag
    lappend event_output "         MOM_suppress once \$aa(\$mom_cycle_spindle_axis)"
    lappend event_output "         MOM_do_template \$traverse_block \$is_from"
    lappend event_output "         MOM_suppress off \$aa(\$mom_cycle_spindle_axis)"
   lappend event_output "      \}"
   lappend event_output "   \} elseif \{\$spindle_first == \"FALSE\"\} \{"
   lappend event_output "      if \{\$rapid_traverse_inhibit == \"FALSE\"\} \{"
    __output_ForceRapidAddr event_output $rapid_traverse blk_mod_arr
    __out_ForceAddr event_output $rapid_traverse $lead_blanks $wpc_flag
    lappend event_output "         MOM_suppress once \$aa(\$mom_cycle_spindle_axis)"
    lappend event_output "         MOM_do_template \$traverse_block \$is_from"
    lappend event_output "         MOM_suppress off \$aa(\$mom_cycle_spindle_axis)"
   lappend event_output "      \}"
   lappend event_output "      if \{\$rapid_spindle_inhibit == \"FALSE\"\} \{"
    __output_ForceRapidAddr event_output $rapid_spindle blk_mod_arr
    __out_ForceAddr event_output $rapid_spindle $lead_blanks $wpc_flag
    lappend event_output \
    "         MOM_suppress once \$aa(\$traverse_axis1) \$aa(\$traverse_axis2)"
    lappend event_output "         MOM_do_template \$spindle_block \$is_from"
    lappend event_output \
    "         MOM_suppress off \$aa(\$traverse_axis1) \$aa(\$traverse_axis2)"
   lappend event_output "      \}"
   lappend event_output "   \} else \{"
   __output_ForceRapidAddr event_output $rapid_traverse blk_mod_arr
   set lead_blanks "      "
   set wpc_flag  "no_wpc"
   __out_ForceAddr event_output $rapid_traverse $lead_blanks $wpc_flag
   lappend event_output "      MOM_do_template \$traverse_block \$is_from"
  lappend event_output "   \}"
 }

#=======================================================================
proc PB_output_RapidEventData { EVENT_OUTPUT BLK_MOD_ARR } {
  upvar $EVENT_OUTPUT event_output
  upvar $BLK_MOD_ARR blk_mod_arr
  set rapid_traverse [PB2TCL_read_fly_var mom_fly_rapid_traverse_blk]
  set rapid_spindle  [PB2TCL_read_fly_var mom_fly_rapid_spindle_blk]
  lappend event_output ""
  lappend event_output "   global mom_sys_control_out mom_sys_control_in"
  lappend event_output "   set co \"\$mom_sys_control_out\""
  lappend event_output "   set ci \"\$mom_sys_control_in\""
  lappend event_output ""
  lappend event_output ""
  lappend event_output "   if { !\[info exists mom_cycle_spindle_axis\] } {"
   lappend event_output "      set mom_cycle_spindle_axis 2"
  lappend event_output "   }"
  lappend event_output "   if { !\[info exists spindle_first\] } {"
   lappend event_output "      set spindle_first NONE"
  lappend event_output "   }"
  lappend event_output "   if { !\[info exists rapid_spindle_inhibit\] } {"
   lappend event_output "      set rapid_spindle_inhibit FALSE"
  lappend event_output "   }"
  lappend event_output "   if { !\[info exists rapid_traverse_inhibit\] } {"
   lappend event_output "      set rapid_traverse_inhibit FALSE"
  lappend event_output "   }"
  lappend event_output ""
  lappend event_output "   switch \$mom_cycle_spindle_axis \{"
   lappend event_output "      0 \{"
    lappend event_output "         if \[llength \$rapid_spindle_x_blk\] \{"
     lappend event_output "            set spindle_block  ${rapid_spindle}_x"
     lappend event_output "            PB_SET_RAPID_MOD \$rapid_spindle_mod \$rapid_spindle_x_blk aa mod_spindle"
     lappend event_output "         \} else \{"
     lappend event_output "            set spindle_block  \"\""
    lappend event_output "         \}"
    lappend event_output "         if \[llength \$rapid_traverse_yz_blk\] \{"
     lappend event_output "            set traverse_block ${rapid_traverse}_yz"
     lappend event_output "            PB_SET_RAPID_MOD \$rapid_traverse_mod \$rapid_traverse_yz_blk aa mod_traverse"
     lappend event_output "         \} else \{"
     lappend event_output "            set traverse_block  \"\""
    lappend event_output "         \}"
   lappend event_output "      \}"
   lappend event_output ""
   lappend event_output "      1 \{"
    lappend event_output "         if \[llength \$rapid_spindle_y_blk\] \{"
     lappend event_output "            set spindle_block  ${rapid_spindle}_y"
     lappend event_output "            PB_SET_RAPID_MOD \$rapid_spindle_mod \$rapid_spindle_y_blk aa mod_spindle"
     lappend event_output "         \} else \{"
     lappend event_output "            set spindle_block  \"\""
    lappend event_output "         \}"
    lappend event_output "         if \[llength \$rapid_traverse_xz_blk\] \{"
     lappend event_output "            set traverse_block ${rapid_traverse}_xz"
     lappend event_output "            PB_SET_RAPID_MOD \$rapid_traverse_mod \$rapid_traverse_xz_blk aa mod_traverse"
     lappend event_output "         \} else \{"
     lappend event_output "            set traverse_block  \"\""
    lappend event_output "         \}"
   lappend event_output "      \}"
   lappend event_output ""
   lappend event_output "      2 \{"
    lappend event_output "         if \[llength \$rapid_spindle_z_blk\] \{"
     lappend event_output "            set spindle_block  ${rapid_spindle}_z"
     lappend event_output "            PB_SET_RAPID_MOD \$rapid_spindle_mod \$rapid_spindle_z_blk aa mod_spindle"
     lappend event_output "         \} else \{"
     lappend event_output "            set spindle_block  \"\""
    lappend event_output "         \}"
    lappend event_output "         if \[llength \$rapid_traverse_xy_blk\] \{"
     lappend event_output "            set traverse_block ${rapid_traverse}_xy"
     lappend event_output "            PB_SET_RAPID_MOD \$rapid_traverse_mod \$rapid_traverse_xy_blk aa mod_traverse"
     lappend event_output "         \} else \{"
     lappend event_output "            set traverse_block  \"\""
    lappend event_output "         \}"
   lappend event_output "      \}"
   lappend event_output ""
   lappend event_output "      default \{"
    lappend event_output "         set spindle_block  $rapid_spindle"
    lappend event_output "         set traverse_block $rapid_traverse"
    lappend event_output "         PB_SET_RAPID_MOD \$rapid_spindle_mod \$rapid_spindle_blk aa mod_spindle"
    lappend event_output "         PB_SET_RAPID_MOD \$rapid_traverse_mod \$rapid_traverse_blk aa mod_traverse"
   lappend event_output "      \}"
  lappend event_output "   \}"
  lappend event_output ""
  lappend event_output "   if \{\$spindle_first == \"TRUE\"\} \{"
   lappend event_output "      if \{\$rapid_spindle_inhibit == \"FALSE\"\} \{"
    lappend event_output "         if \{ \$spindle_block != \"\" \} \{"
     lappend event_output "            PB_FORCE Once \$mod_spindle"
     lappend event_output "            MOM_do_template \$spindle_block"
     lappend event_output "         \} else \{"
     lappend event_output "            MOM_output_literal \"\$co Rapid Spindle Block is empty! \$ci\""
    lappend event_output "         \}"
   lappend event_output "      \}"
   lappend event_output "      if \{\$rapid_traverse_inhibit == \"FALSE\"\} \{"
    lappend event_output "         if \{ \$traverse_block != \"\" \} \{"
     lappend event_output "            PB_FORCE Once \$mod_traverse"
     lappend event_output "            MOM_do_template \$traverse_block"
     lappend event_output "         \} else \{"
     lappend event_output "            MOM_output_literal \"\$co Rapid Traverse Block is empty! \$ci\""
    lappend event_output "         \}"
   lappend event_output "      \}"
   lappend event_output "   \} elseif \{\$spindle_first == \"FALSE\"\} \{"
   lappend event_output "      if \{\$rapid_traverse_inhibit == \"FALSE\"\} \{"
    lappend event_output "         if \{ \$traverse_block != \"\" \} \{"
     lappend event_output "            PB_FORCE Once \$mod_traverse"
     lappend event_output "            MOM_do_template \$traverse_block"
     lappend event_output "         \} else \{"
     lappend event_output "            MOM_output_literal \"\$co Rapid Traverse Block is empty! \$ci\""
    lappend event_output "         \}"
   lappend event_output "      \}"
   lappend event_output "      if \{\$rapid_spindle_inhibit == \"FALSE\"\} \{"
    lappend event_output "         if \{ \$spindle_block != \"\" \} \{"
     lappend event_output "            PB_FORCE Once \$mod_spindle"
     lappend event_output "            MOM_do_template \$spindle_block"
     lappend event_output "         \} else \{"
     lappend event_output "            MOM_output_literal \"\$co Rapid Spindle Block is empty! \$ci\""
    lappend event_output "         \}"
   lappend event_output "      \}"
   lappend event_output "   \} else \{"
   lappend event_output "      PB_FORCE Once \$mod_traverse"
   lappend event_output "      MOM_do_template $rapid_traverse"
  lappend event_output "   \}"
 }

#=======================================================================
proc __output_RapidBlkElems { FILE_ID } {
  upvar $FILE_ID file_id
  global post_object gPB
  set blk_obj_list $Post::($post_object,blk_obj_list)
  set add_obj_list $Post::($post_object,add_obj_list)
  PB_output_GetBlkObjAttr blk_obj_list add_obj_list blk_name_arr blk_val_arr
  array set mom_sys_var_arr $Post::($post_object,mom_sys_var_list)
  set rapid_work_plane_change $mom_sys_var_arr(\$rap_wrk_pln_chg)
  set no_blks [array size blk_name_arr]
  for { set count 0 } { $count < $no_blks } { incr count } \
  {
   if [string match "rapid_traverse" $blk_name_arr($count)] {
    set val_list $blk_val_arr($count)
    set no_lines [llength $val_list]
    set gPB(rapid_traverse_blk) [list]
    for {set jj 0} {$jj < $no_lines} {incr jj} \
    {
     set elem [lindex $val_list $jj]
     set idx [string first \[ $elem]
     set elem [string range $elem 0 [expr $idx - 1]]
     lappend gPB(rapid_traverse_blk) $elem
    }
    lappend file_id "   set rapid_traverse_blk \{[join $gPB(rapid_traverse_blk)]\}"
    if $rapid_work_plane_change {
     set gPB(rapid_traverse_xy_blk) [list]
     for {set jj 0} {$jj < $no_lines} {incr jj} \
     {
      set elem [lindex $val_list $jj]
      if { ![string match "Z*" $elem] } {
       set idx [string first \[ $elem]
       set elem [string range $elem 0 [expr $idx - 1]]
       lappend gPB(rapid_traverse_xy_blk) $elem
      }
     }
     lappend file_id "   set rapid_traverse_xy_blk \{[join $gPB(rapid_traverse_xy_blk)]\}"
     set gPB(rapid_traverse_yz_blk) [list]
     for {set jj 0} {$jj < $no_lines} {incr jj} \
     {
      set elem [lindex $val_list $jj]
      if { ![string match "X*" $elem] } {
       set idx [string first \[ $elem]
       set elem [string range $elem 0 [expr $idx - 1]]
       lappend gPB(rapid_traverse_yz_blk) $elem
      }
     }
     lappend file_id "   set rapid_traverse_yz_blk \{[join $gPB(rapid_traverse_yz_blk)]\}"
     set gPB(rapid_traverse_xz_blk) [list]
     for {set jj 0} {$jj < $no_lines} {incr jj} \
     {
      set elem [lindex $val_list $jj]
      if { ![string match "Y*" $elem] } {
       set idx [string first \[ $elem]
       set elem [string range $elem 0 [expr $idx - 1]]
       lappend gPB(rapid_traverse_xz_blk) $elem
      }
     }
     lappend file_id "   set rapid_traverse_xz_blk \{[join $gPB(rapid_traverse_xz_blk)]\}"
    }
   } ;# rapid_traverse
   if $rapid_work_plane_change {
    if [string match "rapid_spindle" $blk_name_arr($count)] {
     set val_list $blk_val_arr($count)
     set no_lines [llength $val_list]
     set gPB(rapid_spindle_blk) [list]
     for {set jj 0} {$jj < $no_lines} {incr jj} \
     {
      set elem [lindex $val_list $jj]
      set idx [string first \[ $elem]
      set elem [string range $elem 0 [expr $idx - 1]]
      lappend gPB(rapid_spindle_blk) $elem
     }
     lappend file_id "   set rapid_spindle_blk \{[join $gPB(rapid_spindle_blk)]\}"
     set gPB(rapid_spindle_x_blk) [list]
     for {set jj 0} {$jj < $no_lines} {incr jj} \
     {
      set elem [lindex $val_list $jj]
      if { ![string match "Y*" $elem] && \
       ![string match "Z*" $elem] } {
       set idx [string first \[ $elem]
       set elem [string range $elem 0 [expr $idx - 1]]
       lappend gPB(rapid_spindle_x_blk) $elem
      }
     }
     lappend file_id "   set rapid_spindle_x_blk \{[join $gPB(rapid_spindle_x_blk)]\}"
     set gPB(rapid_spindle_y_blk) [list]
     for {set jj 0} {$jj < $no_lines} {incr jj} \
     {
      set elem [lindex $val_list $jj]
      if { ![string match "X*" $elem] && \
       ![string match "Z*" $elem] } {
       set idx [string first \[ $elem]
       set elem [string range $elem 0 [expr $idx - 1]]
       lappend gPB(rapid_spindle_y_blk) $elem
      }
     }
     lappend file_id "   set rapid_spindle_y_blk \{[join $gPB(rapid_spindle_y_blk)]\}"
     set gPB(rapid_spindle_z_blk) [list]
     for {set jj 0} {$jj < $no_lines} {incr jj} \
     {
      set elem [lindex $val_list $jj]
      if { ![string match "Y*" $elem] && \
       ![string match "X*" $elem] } {
       set idx [string first \[ $elem]
       set elem [string range $elem 0 [expr $idx - 1]]
       lappend gPB(rapid_spindle_z_blk) $elem
      }
     }
     lappend file_id "   set rapid_spindle_z_blk \{[join $gPB(rapid_spindle_z_blk)]\}"
    } ;# rapid_spindle
   } ;# rapid_work_plane_change
  }
 }

#=======================================================================
proc PB_output_OutputRapidBlkModality { n_blank BLOCK_NAME BLK_MOD_ARR EVENT_OUTPUT } {
  upvar $BLOCK_NAME block_name
  upvar $BLK_MOD_ARR blk_mod_arr
  upvar $EVENT_OUTPUT event_output
  if [info exists blk_mod_arr($block_name)] \
  {
   if [string match "rapid_*" $block_name] {
    __output_ForceRapidAddr event_output $n_blank $block_name blk_mod_arr
    } else {
    UI_PB_debug_Pause "This call is for Rapid Blocks only!"
   }
  }
 }

#=======================================================================
proc __output_RapidAddrForce { EVENT_OUTPUT n_blank block_name BLK_MOD_ARR } {
  upvar $EVENT_OUTPUT event_output
  upvar $BLK_MOD_ARR blk_mod_arr
  set new_mod_list ""
  set blk_mod_addr $blk_mod_arr($block_name)
  global post_object
  Post::GetObjList $post_object address add_obj_list
  foreach add_name $blk_mod_addr \
  {
   switch $add_name \
   {
    "rapid1" -
    "rapid2" -
    "rapid3" { lappend new_mod_list $add_name }
    default  {
     PB_com_RetObjFrmName add_name add_obj_list add_obj
     if { $add_obj > 0 } {
      if { $address::($add_obj,word_status) == 0 } {
       lappend new_mod_list $add_name
      }
     }
    }
   }
  }
  set blank_string ""
  if { $n_blank > 0 } {
   for { set i 0 } { $i < $n_blank } { incr i } {
    set blank_string "$blank_string "
   }
  }
  lappend event_output "${blank_string}set ${block_name}_mod \{$new_mod_list\}"
 }

#=======================================================================
proc __output_ForceRapidAddr { EVENT_OUTPUT n_blank block_name BLK_MOD_ARR } {
  upvar $EVENT_OUTPUT event_output
  upvar $BLK_MOD_ARR blk_mod_arr
  set new_mod_list ""
  set blk_mod_addr $blk_mod_arr($block_name)
  global post_object
  Post::GetObjList $post_object address add_obj_list
  foreach add_name $blk_mod_addr \
  {
   switch $add_name \
   {
    "rapid1" { lappend new_mod_list "\$aa(\$traverse_axis1)" }
    "rapid2" { lappend new_mod_list "\$aa(\$traverse_axis2)" }
    "rapid3" { lappend new_mod_list "\$aa(\$mom_cycle_spindle_axis)" }
    default  {
     PB_com_RetObjFrmName add_name add_obj_list add_obj
     if { $add_obj > 0 } {
      if { $address::($add_obj,word_status) == 0 } {
       lappend new_mod_list $add_name
      }
     }
    }
   }
  }
  if { $new_mod_list != "" } \
  {
   set blank_string ""
   if { $n_blank > 0 } {
    for { set i 0 } { $i < $n_blank } { incr i } {
     set blank_string "$blank_string "
    }
   }
   set new_mod_list [join $new_mod_list]
   lappend event_output "${blank_string}MOM_force Once $new_mod_list"
  }
 }

#=======================================================================
proc PB_output_OutputBlkModality { n_blank BLOCK_NAME BLK_MOD_ARR EVENT_OUTPUT } {
  upvar $BLOCK_NAME block_name
  upvar $BLK_MOD_ARR blk_mod_arr
  upvar $EVENT_OUTPUT event_output
  if [info exists blk_mod_arr($block_name)] \
  {
   if { [string match "rapid_traverse" $block_name] || \
    [string match "rapid_spindle" $block_name] } {
    set machine_type [PB2TCL_read_fly_var mom_fly_machine_type]
    switch $machine_type {
     3_axis_mill -
     3_axis_mill_turn -
     4_axis_head -
     4_axis_table -
     5_axis_dual_table -
     5_axis_dual_head -
     5_axis_head_table {
      set machine_type mill
     }
    }
    if [string match "*mill*" $machine_type] { set machine_type mill }
    if { $machine_type == "mill" } {
     set blanks ""
     if { $n_blank > 0 } {
      for { set i 0 } { $i < $n_blank } { incr i } {
       set blanks "$blanks "
      }
     }
     lappend event_output "${blanks}PB_SET_RAPID_MOD \$rapid_traverse_mod\
     \$rapid_traverse_blk\
     aa mod_traverse"
     lappend event_output "${blanks}PB_FORCE Once \$mod_traverse"
     } else {
     __output_ForceRapidAddr event_output $n_blank $block_name blk_mod_arr
    }
    } else {
    global post_object
    Post::GetObjList $post_object address add_obj_list
    set mod_list ""
    foreach add $blk_mod_arr($block_name) {
     PB_com_RetObjFrmName add add_obj_list add_obj
     if { $add_obj > 0 } {
      if { $address::($add_obj,word_status) == 0 } {
       lappend mod_list $add
      }
     }
    }
    if { $mod_list != "" } {
     set blank_string ""
     if { $n_blank > 0 } {
      for { set i 0 } { $i < $n_blank } { incr i } {
       set blank_string "$blank_string "
      }
     }
     set mod_list [join $mod_list]
     lappend event_output "${blank_string}MOM_force Once $mod_list"
    }
   }
  }
 }

#=======================================================================
proc PB_output_BlockOfAEvent { EVT_NAME EVT_BLOCKS BLK_MOD_ARR NO_OF_LISTS \
  EVENT_OUTPUT } {
  upvar $EVT_NAME evt_name
  upvar $EVT_BLOCKS evt_blocks   ;# array of list of blocks for the event
  upvar $BLK_MOD_ARR blk_mod_arr ;# blk_mod_arr($block_name)
  upvar $NO_OF_LISTS no_of_lists
  upvar $EVENT_OUTPUT event_output
  global cycle_init_flag
  set cur_machine [PB2TCL_read_fly_var mom_fly_machine_type]
  set fourth_dirn [PB2TCL_read_fly_var mom_fly_4th_axis_direction]
  set fifth_dirn [PB2TCL_read_fly_var mom_fly_5th_axis_direction]
  set is_done2 0
  set move_event [string last "move" $evt_name]
  if {$move_event != -1} \
  {
   if { ![string match "3_axis_mill_turn" $cur_machine] } {
    if { $fourth_dirn == "SIGN_DETERMINES_DIRECTION" || \
    $fifth_dirn == "SIGN_DETERMINES_DIRECTION"} \
    {
     lappend event_output "   PB_ROTARY_SIGN_SET"
    }
   }
  }
  switch [PB2TCL_read_fly_var mom_fly_machine_type] \
  {
   3_axis_mill -
   3_axis_mill_turn -
   4_axis_head -
   4_axis_table -
   5_axis_dual_table -
   5_axis_dual_head -
   5_axis_head_table {
    set cur_machine mill
   }
  }
  set last_list [expr $no_of_lists - 1]
  if $last_list \
  {
   set pre_list [expr $last_list - 1]
  } else \
  {
   set pre_list $last_list
  }
  set has_cycle_start 0
  foreach blk_lis $evt_blocks {
   foreach blk $blk_lis {
    if [string match "post_startblk" $blk] {
     set has_cycle_start 1
     break
    }
   }
  }
  set need_close_brace 0
  set need_right_brace 0
  for { set jj 0 } { $jj <= $last_list } { incr jj } \
  {
   set sublist [lindex $evt_blocks $jj]
   set ii [llength $sublist]
   if {$ii <= 0} {continue} ; #sublist is empty
   for {set kk 0} {$kk < $ii} {incr kk} \
   {
    set block_name [lindex $sublist $kk]
    if { $need_close_brace  &&  ![string match "*post_retracto*" $block_name] } {
    lappend event_output "   \}"
    lappend event_output ""
    set need_close_brace 0
   }
   set isupper [regexp {^[A-Z]+} $block_name] ;
   global post_object
   set blk_item_list $Post::($post_object,blk_obj_list)
   PB_com_RetObjFrmName block_name blk_item_list blk_obj
   if $isupper \
   {
    if { $kk == 0 && $cycle_init_flag == "TRUE" && $has_cycle_start } \
    {
     if { $pre_list != $last_list } \
     {
      lappend event_output "   if \{ \$cycle_init_flag == \"TRUE\" \} \{"
       set need_right_brace 1
      }
     }
     if $need_right_brace {
      lappend event_output "      $block_name"
      } else {
      lappend event_output "   $block_name"
     }
    } else \
    {
     switch $evt_name \
     {
      MOM_rapid_move \
      {
       set rapid_traverse [PB2TCL_read_fly_var mom_fly_rapid_traverse_blk]
       if { $rapid_traverse == "$block_name" } \
       {
        __output_RapidBlkElems event_output
        __output_RapidAddrForce event_output 3 "rapid_traverse" blk_mod_arr
       }
       if { $cur_machine == "mill" && \
       [PB2TCL_read_fly_var mom_fly_work_plane_change] == "TRUE"} \
       {
        set rapid_spindle [PB2TCL_read_fly_var mom_fly_rapid_spindle_blk]
        if { $rapid_traverse == "$block_name" } \
        {
         __output_RapidAddrForce event_output 3 "rapid_spindle" blk_mod_arr
         PB_output_RapidEventData event_output blk_mod_arr
         continue
         } elseif { $rapid_spindle == "$block_name" } \
        {
         continue
        }
        set is_done2 1
       }
      }
     }
     switch $evt_name \
     {
      MOM_start_of_program \
      {
       __output_mom_do_template event_output 3 $block_name blk_mod_arr
       set is_done2 1
      }
      MOM_start_of_path    -
      MOM_return_motion    -
      MOM_end_of_path      -
      MOM_end_of_program   \
      {
       __output_mom_do_template event_output 3 $block_name blk_mod_arr
       set is_done2 1
      }
      default \
      {
       if {$jj <= $pre_list && [llength [lindex $evt_blocks $jj]] > 0} \
       {
        if { $kk == 0 && $cycle_init_flag == "TRUE" && $has_cycle_start } \
        {
         if { $pre_list != $last_list } \
         {
          lappend event_output "   if \{ \$cycle_init_flag == \"TRUE\" \} \{"
           set need_right_brace 1
          }
         }
         if $need_right_brace {
          __output_mom_do_template event_output 6 $block_name blk_mod_arr
          } else {
          if [string match "MOM_first_tool" $evt_name] {
           global mom_sys_arr
           if { [info exists mom_sys_arr(Output_VNC)] && \
            $mom_sys_arr(Output_VNC) == 1 } {
            lappend event_output ""
            lappend event_output "  # Pass tool name to VNC for simulation."
            lappend event_output "   global sim_mtd_initialized"
            lappend event_output "   if \$sim_mtd_initialized {"
             lappend event_output "      if \[llength \[info commands PB_VNC_pass_tool_data\] \] {"
              lappend event_output "         PB_VNC_pass_tool_data"
             lappend event_output "      }"
            lappend event_output "   }"
            lappend event_output ""
           }
          }
          __output_mom_do_template event_output 3 $block_name blk_mod_arr
         }
         if 0 {
          if { $kk == [expr $ii - 1]  &&  $pre_list != $last_list } \
          {
           if { $need_right_brace } {
           lappend event_output "   \}"
           lappend event_output ""
           set need_right_brace 0
          }
         }
        }
        set is_done2 1
        } elseif { $jj == $last_list && [llength [lindex $evt_blocks $jj]] > 0} \
       {
        if { $cycle_init_flag == "TRUE"  &&  \
         [string match "*post_retracto*" $block_name]  && \
        !$need_close_brace } \
        {
         lappend event_output ""
         lappend event_output \
         "  global mom_cycle_rapid_to mom_cycle_retract_to"
         lappend event_output ""
         lappend event_output \
         "   if \{ \[EQ_is_lt \$mom_cycle_rapid_to \$mom_cycle_retract_to\] \} \{"
          set need_close_brace 1
         }
         if { $need_close_brace } {
          __output_mom_do_template event_output 6 $block_name blk_mod_arr
          } else {
          __output_mom_do_template event_output 3 $block_name blk_mod_arr
         }
         if { $need_close_brace  &&  $kk == [expr $ii - 1] } {
         lappend event_output "   \}"
         lappend event_output ""
         set need_close_brace 0
        }
        set is_done2 1
       }
      }
     } ;# switch
    } ;# !$isupper
   } ;# kk
   if { $need_right_brace } {
   lappend event_output "   \}"
   lappend event_output ""
   set need_right_brace 0
  }
  if { $jj == $last_list  &&  $cycle_init_flag == "TRUE" } \
  {
   lappend event_output "   set cycle_init_flag FALSE"
   set cycle_init_flag FALSE
  }
 } ;# jj
 if {$is_done2 == 0} \
 {
  switch $evt_name \
  {
   MOM_first_tool    -
   MOM_tool_change   \
   {
    lappend event_output "   if \{\[info exists mom_tool_change_type\]\} \{"
     lappend event_output "      switch \$mom_tool_change_type \{"
      lappend event_output "         MANUAL \{ PB_manual_tool_change \}"
      lappend event_output "         AUTO   \{ PB_auto_tool_change \}"
     lappend event_output "      \}"
     lappend event_output "   \} elseif \{\[info exists mom_manual_tool_change\]\} \{"
     lappend event_output "      if \{\$mom_manual_tool_change == \"TRUE\"\} \{"
      lappend event_output "         PB_manual_tool_change"
     lappend event_output "      \}"
    lappend event_output "   \}"
   }
   MOM_gohome_move { lappend event_output "   MOM_rapid_move" }
  }
 }
 switch $evt_name \
 {
  MOM_initial_move_old \
  {
   if {[PB2TCL_read_fly_var mom_fly_use_rapid_at_max_fpm] == "TRUE"} \
   {
    lappend event_output "   if \{\[info exists mom_kin_max_fpm\] != 0\} \{"
     lappend event_output "      if \{\$mom_feed_rate >= \$mom_kin_max_fpm\} \
     \{MOM_rapid_move ; return\}\}"
   }
   lappend event_output \
   "   if \{\$mom_motion_type == \"RAPID\"\} \{MOM_rapid_move\} else \{MOM_linear_move\}"
  }
  MOM_initial_move_30Apr2001_4263669 \
  {
   lappend event_output \
   "   if \{\$mom_motion_type == \"RAPID\"\} \{MOM_rapid_move\} else \{MOM_linear_move\}"
  }
  MOM_initial_move_05SEP01_4325407 \
  {
   lappend event_output ""
   lappend event_output "  global mom_programmed_feed_rate"
   lappend event_output "   if \{ \[EQ_is_ge \$mom_feed_rate \$mom_kin_max_fpm\] \&\&  \\"
    lappend event_output "        \[EQ_is_equal \$mom_programmed_feed_rate 0\] \} \{"
    lappend event_output "      MOM_rapid_move"
    lappend event_output "   \} else \{"
    lappend event_output "      MOM_linear_move"
   lappend event_output "   \}"
  }
  MOM_initial_move \
  {
   lappend event_output ""
   lappend event_output "  global mom_programmed_feed_rate"
   lappend event_output "   if \{ \[EQ_is_equal \$mom_programmed_feed_rate 0\] \} \{"
    lappend event_output "      MOM_rapid_move"
    lappend event_output "   \} else \{"
    lappend event_output "      MOM_linear_move"
   lappend event_output "   \}"
  }
  MOM_first_move \
  {
   lappend event_output "   catch \{MOM_\$mom_motion_event\}" ; #4202839
  }
  MOM_end_of_program \
  {
   lappend event_output ""
   lappend event_output "#**** The following procedure lists the tool list\
   with time in commentary data"
   lappend event_output "   LIST_FILE_TRAILER"
   lappend event_output ""
   lappend event_output "#**** The following procedure closes the warning and listing files"
   lappend event_output "   CLOSE_files"
  }
  MOM_thread              -
  MOM_lathe_thread        -
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
  }
 }
}

#=======================================================================
proc __out_ForceAddr { EVENT_OUTPUT block_name lead_blanks flag } {
  upvar $EVENT_OUTPUT event_output
  set rapid_traverse [PB2TCL_read_fly_var mom_fly_rapid_traverse_blk]
  set rapid_spindle  [PB2TCL_read_fly_var mom_fly_rapid_spindle_blk]
  lappend event_output ""
  lappend event_output "${lead_blanks}if \{ \$mom_motion_event == \"initial_move\" ||\
   \$mom_motion_event == \"first_move\" \} \{"
   if [string match "$rapid_traverse" $block_name] {
    if { $flag == "no_wpc" } { ;# No work plane change
     lappend event_output "${lead_blanks}   MOM_force once \$aa(\$traverse_axis1) \$aa(\$traverse_axis2) \
     \$aa(\$mom_cycle_spindle_axis)"
     } else {
     lappend event_output "${lead_blanks}   MOM_force once \$aa(\$traverse_axis1) \$aa(\$traverse_axis2)"
    }
    } elseif [string match "$rapid_spindle" $block_name] {
    lappend event_output "${lead_blanks}   MOM_force once \$aa(\$mom_cycle_spindle_axis)"
   }
   lappend event_output "${lead_blanks}\}"
  lappend event_output ""
 }

#=======================================================================
proc PB_output_special_case_end {EVT_NAME EVENT_OUTPUT} {
  upvar $EVT_NAME evt_name
  upvar $EVENT_OUTPUT event_output
  if {$::env(PB_UDE_ENABLED) != 1} {
   return
  }
  if {$evt_name == "MOM_head"} {
   lappend event_output "#============================================================="

#=======================================================================
lappend event_output "proc MOM_Head { } {"
  lappend event_output "#============================================================="
  lappend event_output "   MOM_head"
 lappend event_output "}"
 lappend event_output "\n"
 lappend event_output "#============================================================="

#=======================================================================
lappend event_output "proc MOM_HEAD { } {"
  lappend event_output "#============================================================="
  lappend event_output "   MOM_head"
 lappend event_output "}"
 lappend event_output "\n"
}
}

#=======================================================================
proc PB_output_special_case_start {EVT_NAME EVENT_OUTPUT} {
  upvar $EVT_NAME evt_name
  upvar $EVENT_OUTPUT event_output
  if {$::env(PB_UDE_ENABLED) != 1} {
   return
  }
  if {$evt_name == "MOM_head"} {
   global mom_sys_arr
   if { [info exists mom_sys_arr(\$mom_sys_mill_turn_type)] && \
    [string match "SIMPLE_MILL_TURN" $mom_sys_arr(\$mom_sys_mill_turn_type)] } {
    } elseif { $mom_sys_arr(\$is_linked_post) == 1 } {
    lappend event_output "   global mom_warning_info"
    lappend event_output ""
    lappend event_output "   global mom_sys_in_operation"
    lappend event_output "   if { \[info exists mom_sys_in_operation\] && \$mom_sys_in_operation == 1 } {"
     lappend event_output "      global mom_operation_name"
     lappend event_output "      set mom_warning_info \"HEAD event should not be assigned to an operatrion (\$mom_operation_name).\""
     lappend event_output "      MOM_catch_warning"
     lappend event_output "return"
    lappend event_output "   }"
    lappend event_output ""
    if 0 {
     lappend event_output ""
     lappend event_output "   global mom_sys_in_operation"
     lappend event_output "   if { !\[info exists mom_sys_in_operation\] || !\$mom_sys_in_operation } {"
      lappend event_output "      set mom_warning_info \"HEAD event should not be assigned to an operatrion.\""
      lappend event_output "      MOM_catch_warning"
      lappend event_output "return"
     lappend event_output "   }"
     lappend event_output ""
    }
    lappend event_output "   global mom_head_name mom_sys_postname"
    lappend event_output "   global mom_load_event_handler"
    lappend event_output "   global CURRENT_HEAD NEXT_HEAD"
    lappend event_output "   global mom_sys_prev_mach_head mom_sys_curr_mach_head"
    lappend event_output "   global mom_sys_head_change_init_program"
    lappend event_output ""
    lappend event_output "   if { !\[info exists CURRENT_HEAD\] } {"
     lappend event_output "      set CURRENT_HEAD \"\""
    lappend event_output "   }"
    lappend event_output ""
    lappend event_output "   if { \[info exists mom_head_name\] } {"
     lappend event_output "      set NEXT_HEAD \$mom_head_name"
     lappend event_output "   } else {"
     lappend event_output "      set mom_warning_info \"No HEAD event has been assigned.\""
     lappend event_output "      MOM_catch_warning"
     lappend event_output "return"
    lappend event_output "   }"
    lappend event_output ""
    lappend event_output "   set head_list \[array names mom_sys_postname\]"
    lappend event_output "   foreach h \$head_list {"
     if 0 {
      lappend event_output "      if { \[regexp -nocase \"\$mom_head_name\" \$h\] == 1 } {"
       lappend event_output "         set NEXT_HEAD \$h"
       lappend event_output "         break"
      lappend event_output "      }"
     }
     lappend event_output "      if { \[regexp -nocase ^\$mom_head_name\$ \$h\] == 1 } {"
      lappend event_output "         set NEXT_HEAD \$h"
      lappend event_output "         break"
     lappend event_output "      }"
    lappend event_output "   }"
    lappend event_output ""
    lappend event_output ""
    lappend event_output "   set tcl_file \"\""
    lappend event_output ""
    lappend event_output "   if { !\[info exists mom_sys_postname(\$NEXT_HEAD)\] } {"
     lappend event_output ""
     lappend event_output "      set mom_warning_info \"Post is not specified with Head (\$NEXT_HEAD).\""
     lappend event_output "      MOM_catch_warning"
     lappend event_output ""
     lappend event_output "   } elseif { !\[string match \"\$NEXT_HEAD\" \$CURRENT_HEAD\] } {"
     lappend event_output ""
     lappend event_output "      if { \[llength \[info commands PB_end_of_HEAD__\$CURRENT_HEAD\]\] } {"
      lappend event_output "         PB_end_of_HEAD__\$CURRENT_HEAD"
     lappend event_output "      }"
     lappend event_output ""
     lappend event_output "      set mom_sys_prev_mach_head \$CURRENT_HEAD"
     lappend event_output "      set mom_sys_curr_mach_head \$NEXT_HEAD"
     lappend event_output ""
     lappend event_output "      set CURRENT_HEAD \$NEXT_HEAD"
     lappend event_output "\n"
     lappend event_output "      global mom_sys_master_head mom_sys_master_post cam_post_dir"
     lappend event_output ""
     lappend event_output "      if \[string match \"\$CURRENT_HEAD\" \$mom_sys_master_head\] {"
      if 0 {
       lappend event_output ""
       lappend event_output "          set mom_warning_info \"Load post : \$mom_sys_master_post\""
       lappend event_output "          MOM_catch_warning"
      }
      lappend event_output ""
      lappend event_output "         set mom_load_event_handler \"\\\"\$mom_sys_master_post.tcl\\\"\""
      lappend event_output "         MOM_load_definition_file   \"\$mom_sys_master_post.def\""
      lappend event_output ""
      lappend event_output "         set tcl_file \"\$mom_sys_master_post.tcl\""
      lappend event_output ""
      lappend event_output "      } else {"
      lappend event_output ""
      lappend event_output "         set tcl_file \"\[file dirname \$mom_sys_master_post\]/\$mom_sys_postname(\$CURRENT_HEAD).tcl\""
      lappend event_output "         set def_file \"\[file dirname \$mom_sys_master_post\]/\$mom_sys_postname(\$CURRENT_HEAD).def\""
      lappend event_output ""
      lappend event_output "         if \[file exists \"\$tcl_file\"\] {"
       if 0 {
        lappend event_output ""
        lappend event_output "             set mom_warning_info \"Load post : \$tcl_file\""
        lappend event_output "             MOM_catch_warning"
       }
       lappend event_output ""
       lappend event_output "            global tcl_platform"
       lappend event_output ""
       lappend event_output "            if \[string match \"*windows*\" \$tcl_platform(platform)\] {"
        lappend event_output "               regsub -all {/} \$tcl_file {\\\\} tcl_file"
        lappend event_output "               regsub -all {/} \$def_file {\\\\} def_file"
       lappend event_output "            }"
       lappend event_output ""
       lappend event_output "            set mom_load_event_handler \"\\\"\$tcl_file\\\"\""
       lappend event_output "            MOM_load_definition_file   \"\$def_file\""
       lappend event_output ""
       lappend event_output "         } else {"
       lappend event_output ""
       lappend event_output "            set tcl_file \"\${cam_post_dir}\$mom_sys_postname(\$CURRENT_HEAD).tcl\""
       lappend event_output "            set def_file \"\${cam_post_dir}\$mom_sys_postname(\$CURRENT_HEAD).def\""
       lappend event_output ""
       lappend event_output "            if \[file exists \"\$tcl_file\"\] {"
        if 0 {
         lappend event_output ""
         lappend event_output "                set mom_warning_info \"Load post : \$tcl_file\""
         lappend event_output "                MOM_catch_warning"
        }
        lappend event_output ""
        lappend event_output "               set mom_load_event_handler \"\\\"\$tcl_file\\\"\""
        lappend event_output "               MOM_load_definition_file   \"\$def_file\""
        lappend event_output ""
        lappend event_output "            } else {"
        lappend event_output "               set mom_warning_info \
        \"Post (\$mom_sys_postname(\$CURRENT_HEAD)) for HEAD (\$CURRENT_HEAD) not found.\""
        lappend event_output "               MOM_catch_warning"
       lappend event_output "            }"
       if 0 {
        lappend event_output "            set mom_load_event_handler \\"
        lappend event_output "            \"\\\"\${cam_post_dir}\$mom_sys_postname(\$CURRENT_HEAD).tcl\\\"\""
        lappend event_output ""
        lappend event_output "            MOM_load_definition_file \\"
        lappend event_output "            \"\${cam_post_dir}\$mom_sys_postname(\$CURRENT_HEAD).def\""
       }
      lappend event_output "         }"
     lappend event_output "      }"
     lappend event_output "\n"
     if 0 {
      lappend event_output "      if { \[llength \[info commands PB_start_of_HEAD__\$CURRENT_HEAD\]\] } {"
       lappend event_output "         PB_start_of_HEAD__\$CURRENT_HEAD"
      lappend event_output "      }"
      lappend event_output ""
     }
     if { [info exists mom_sys_arr(Output_VNC)] && \
      $mom_sys_arr(Output_VNC) == 1 } {
      lappend event_output "      global sim_mtd_initialized"
      lappend event_output "      if \$sim_mtd_initialized {"
       lappend event_output "         if \[llength \[info commands PB_VNC_pass_head_data\]\] {"
        lappend event_output "            global mom_sys_sim_post_name"
        lappend event_output "            set mom_sys_sim_post_name \[file rootname \"\$tcl_file\"\]"
        lappend event_output "            PB_VNC_pass_head_data"
       lappend event_output "         }"
      lappend event_output "      }"
      lappend event_output "\n"
     }
     lappend event_output "      set mom_sys_head_change_init_program 1"
     lappend event_output ""
     lappend event_output "      rename MOM_start_of_program MOM_start_of_program_save"
     lappend event_output "      rename MOM_end_of_program MOM_end_of_program_save"
     lappend event_output "      rename MOM_head MOM_head_save"
    lappend event_output "   }"
    lappend event_output "\n"
   }
  }
 }

#=======================================================================
proc PB_output_GetEventProcData { EVT_NAME EVT_BLOCKS BLK_MOD_ARR \
  EVENT_OUTPUT {udc_name_list ""}} {
   upvar $EVT_NAME evt_name
   upvar $EVT_BLOCKS evt_blocks   ; #array of list of blocks for the event
   upvar $BLK_MOD_ARR blk_mod_arr ; #blk_mod_arr($block_name)
   upvar $EVENT_OUTPUT event_output
   global mom_sys_arr
   if {$::env(PB_UDE_ENABLED) == 1} {
    if [string match $evt_name "MOM_spindle"] {
     set changed_evt_name MOM_spindle_rpm
     } elseif [string match $evt_name "MOM_cutcom"] {
     set changed_evt_name MOM_cutcom_on
     } elseif [string match $evt_name "MOM_wire_cutcom"] {
     set changed_evt_name MOM_cutcom_on
     } else {
     set changed_evt_name $evt_name
    }
    } else {
    set changed_evt_name $evt_name
   }
   lappend event_output "\n"
   lappend event_output "#============================================================="

#=======================================================================
lappend event_output "proc $changed_evt_name \{ \} \{"
  lappend event_output "#============================================================="
  if {$::env(PB_UDE_ENABLED) == 1} {
   if [string match $evt_name "MOM_spindle_css"] {
    set evt_name "MOM_spindle"
    set changed_flag 1
   }
  }
  PB_output_special_case_start evt_name event_output
  if {$::env(PB_UDE_ENABLED) == 1} {
   global post_object
   set udeobj $Post::($post_object,ude_obj)
   set event_obj_list $ude::($udeobj,event_obj_list)
   set csp_obj ""
   foreach event $event_obj_list {
    set post_name $ude_event::($event,post_event)
    if {$post_name == ""} {
     set post_name $ude_event::($event,name)
    }
    if {$evt_name == "MOM_cutcom_on" || $evt_name == "MOM_cutcom_off"} {
     set temp_evt_name "MOM_cutcom"
     } elseif {$evt_name == "MOM_spindle_rpm"} {
     set temp_evt_name "MOM_spindle"
     } else {
     set temp_evt_name $evt_name
    }
    set post_name "MOM_${post_name}"
    if {$post_name == $temp_evt_name} {
     set csp_obj $event
     break
    }
   }
   if {$csp_obj != ""} {
    global McParam
    array set MC $McParam
    set ename $ude_event::($csp_obj,name)
    if [info exists MC($ename)] {
     set pnamelist $MC($ename)
     set param_list $ude_event::($csp_obj,param_obj_list)
     foreach param $param_list {
      set type [classof $param]
      set pname [set [set type]::($param,name)]
      if {[lsearch $pnamelist $pname] < 0} {
       lappend event_output "   global mom_${pname}"
      }
     }
     } else {
     set param_list $ude_event::($csp_obj,param_obj_list)
     foreach param $param_list {
      set type [classof $param]
      set param_name "mom_[set [set type]::($param,name)]"
      if {$param_name != "mom_command_status"} {
       lappend event_output "   global $param_name"
      }
     }
    }
   }
  }
  if {[lsearch $udc_name_list $evt_name] >= 0 && $::env(PB_UDE_ENABLED) == 1} {
   PB_output_DefaultDataForUDC evt_name event_output
   set cyc_evt_obj_list $ude::($udeobj,cyc_evt_obj_list)
   set csp_obj ""
   foreach cyc_evt $cyc_evt_obj_list {
    set post_name [string tolower $cycle_event::($cyc_evt,name)]
    set post_name MOM_${post_name}
    if {$post_name == $evt_name} {
     set csp_obj $cyc_evt
     break
    }
   }
   if {$csp_obj != ""} {
    set param_list $cycle_event::($csp_obj,param_obj_list)
    foreach param $param_list {
     set type [classof $param]
     set param_name "mom_[set [set type]::($param,name)]"
     lappend event_output "   global $param_name"
    }
   }
   lappend event_output "\n"
   } else {
   PB_output_DefaultDataAEvent changed_evt_name event_output
  }
  switch $evt_name \
  {
   "PB_start_of_program" \
   {
    if 0 {
     if { [info exists mom_sys_arr(Output_VNC)] && \
      $mom_sys_arr(Output_VNC) == 1 } {
      lappend event_output ""
      lappend event_output "  # Initialize for sim"
      lappend event_output "   global sim_mtd_initialized"
      lappend event_output "   if \$sim_mtd_initialized {"
       lappend event_output "      if \[llength \[info commands PB_VNC_init_sim_vars\] \] {"
        lappend event_output "         PB_VNC_init_sim_vars"
       lappend event_output "      }"
      lappend event_output "   }"
     }
    }
    lappend event_output ""
    lappend event_output "   if \[llength \[info commands PB_CMD_kin_start_of_program\] \] \{"
     lappend event_output "      PB_CMD_kin_start_of_program"
    lappend event_output "   \}"
    lappend event_output ""
   }
   "PB_auto_tool_change" \
   {
    if { [info exists mom_sys_arr(Output_VNC)] && \
     $mom_sys_arr(Output_VNC) == 1 } {
     lappend event_output ""
     lappend event_output "  # Pass tool name to VNC for simulation."
     lappend event_output "   global sim_mtd_initialized"
     lappend event_output "   if \$sim_mtd_initialized {"
      lappend event_output "      if \[llength \[info commands PB_VNC_pass_tool_data\] \] {"
       lappend event_output "         PB_VNC_pass_tool_data"
      lappend event_output "      }"
     lappend event_output "   }"
     lappend event_output ""
    }
   }
   "MOM_start_of_path" \
   {
    lappend event_output ""
    lappend event_output "   if \[llength \[info commands PB_CMD_kin_start_of_path\] \] \{"
     lappend event_output "      PB_CMD_kin_start_of_path"
    lappend event_output "   \}"
    lappend event_output ""
   }
   "MOM_end_of_path" \
   {
    lappend event_output ""
    lappend event_output "   if \[llength \[info commands PB_CMD_kin_end_of_path\] \] \{"
     lappend event_output "      PB_CMD_kin_end_of_path"
    lappend event_output "   \}"
    lappend event_output ""
   }
  }
  if 0 {
   if { [info exists mom_sys_arr(\$mom_sys_postname_list)]  && \
    [llength $mom_sys_arr(\$mom_sys_postname_list)] > 0 } {
    if [string match "PB_start_of_HEAD__*" $evt_name] {
     set head_name [string range $evt_name 18 end]
     lappend event_output  "   if \[llength \[info commands PB_CMD_start_of_$head_name\]\] {"
      lappend event_output  "      PB_CMD_start_of_$head_name"
     lappend event_output  "   }"
     } elseif [string match "PB_end_of_HEAD__*" $evt_name] {
     set head_name [string range $evt_name 16 end]
     lappend event_output  "   if \[llength \[info commands PB_CMD_end_of_$head_name\]\] {"
      lappend event_output  "      PB_CMD_end_of_$head_name"
     lappend event_output  "   }"
    }
   }
  }
  set no_of_lists [llength $evt_blocks]
  if {$no_of_lists > 0} \
  {
   PB_output_BlockOfAEvent evt_name evt_blocks blk_mod_arr \
   no_of_lists event_output
  }
  if {[lsearch $udc_name_list $evt_name] >= 0} {
   if {$no_of_lists == 0} {
    lappend event_output "   set cycle_init_flag FALSE"
   }
  }
  switch $evt_name \
  {
   "MOM_start_of_path" \
   {
    if { [info exists mom_sys_arr(Output_VNC)] && \
     $mom_sys_arr(Output_VNC) == 1 } {
     lappend event_output ""
     lappend event_output "   global sim_mtd_initialized"
     lappend event_output "   if { \$sim_mtd_initialized == 1 } {"
      lappend event_output "      if \[llength \[info commands PB_VNC_pass_spindle_data\] \] {"
       lappend event_output "         PB_VNC_pass_spindle_data"
      lappend event_output "      }"
      lappend event_output "      if \[llength \[info commands PB_VNC_start_of_path\] \] {"
       lappend event_output "         PB_VNC_start_of_path"
      lappend event_output "      }"
     lappend event_output "   }"
    }
   }
   "MOM_end_of_path" \
   {
    lappend event_output "   global mom_sys_in_operation"
    lappend event_output "   set mom_sys_in_operation 0"
    if { [info exists mom_sys_arr(Output_VNC)] && \
     $mom_sys_arr(Output_VNC) == 1 } {
     lappend event_output ""
     lappend event_output "   global sim_mtd_initialized"
     lappend event_output "   if { \$sim_mtd_initialized == 1 } {"
      lappend event_output "      if \[llength \[info commands PB_VNC_end_of_path\] \] {"
       lappend event_output "         PB_VNC_end_of_path"
      lappend event_output "      }"
     lappend event_output "   }"
    }
   }
   "MOM_end_of_program" \
   {
    if { [info exists mom_sys_arr(Output_VNC)] && \
     $mom_sys_arr(Output_VNC) == 1 } {
     lappend event_output ""
     lappend event_output "  # End of simulation"
     lappend event_output "   global sim_mtd_initialized"
     lappend event_output "   if { \$sim_mtd_initialized == 1 } {"
      lappend event_output "      if \[llength \[info commands PB_VNC_end_of_program\] \] {"
       lappend event_output "         PB_VNC_end_of_program"
      lappend event_output "      }"
     lappend event_output "   }"
    }
   }
  }
 lappend event_output "\}" ;# end of proc
 if [info exists changed_flag] {
  set evt_name "MOM_spindle_css"
 }
}

#=======================================================================
proc PB_PB2TCL_write_command_procs { TCLF_ID file_type } {
  upvar $TCLF_ID tclf_id
  global post_object  gPB
  global mom_sim_arr mom_sys_arr
  PB_output_GetCmdBlkProcs cmd_blk_list cmd_proc_arr
  Post::GetObjList $post_object command cmd_obj_list
  set cmd_blk_list [lsort $cmd_blk_list]
  foreach cmd_blk $cmd_blk_list \
  {
   switch $file_type {
    "POST" {
     if { ![string match "*PB_CMD_vnc_*" $cmd_blk] } {
      puts $tclf_id "\n"
      puts $tclf_id "#============================================================="

#=======================================================================
puts $tclf_id "proc $cmd_blk \{ \} \{"
  puts $tclf_id "#============================================================="
  foreach line $cmd_proc_arr($cmd_blk) \
  {
   puts $tclf_id "$line"
  }
 puts $tclf_id "\}"
}
}
"VNC" {
if {[string match "*PB_CMD_vnc_*" $cmd_blk]} {
 if {([string match "Standalone" $mom_sys_arr(VNC_Mode)] &&  \
  [lsearch $mom_sim_arr(\$mom_sim_vnc_com_list) $cmd_blk] >= 0) || \
  ([string match "Subordinate" $mom_sys_arr(VNC_Mode)] &&  \
  [lsearch $mom_sim_arr(\$mom_sim_sub_vnc_list) $cmd_blk] >= 0)} {
  puts $tclf_id "\n"
  puts $tclf_id "#============================================================="

#=======================================================================
puts $tclf_id "proc $cmd_blk \{ \} \{"
  puts $tclf_id "#============================================================="
  foreach line $cmd_proc_arr($cmd_blk) \
  {
   puts $tclf_id "$line"
  }
 puts $tclf_id "\}"
}
} ;# if match "PB_CMD_vnc__" pattern
}
} ;#switch
} ;#foreach
if { [string match "VNC" $file_type] } {
set Post::($post_object,mom_sim_var_list)     [array get mom_sim_arr]
set Post::($post_object,def_mom_sim_var_list) [array get mom_sim_arr]
puts $tclf_id ""
puts $tclf_id ""
puts $tclf_id ""
puts $tclf_id ""
puts $tclf_id "global mom_sim_program_has_started"
puts $tclf_id ""
puts $tclf_id "if { \!\[info exists mom_sim_program_has_started\] } {"
puts $tclf_id "   if { \[info exists mom_sim_post_builder_rev_post\] \&\& \$mom_sim_post_builder_rev_post } {"
puts $tclf_id ""
puts $tclf_id "      set mom_sim_program_has_started 1"
puts $tclf_id ""
puts $tclf_id "      if { \!\[info exists mom_part_unit\] } {"
puts $tclf_id "         set mom_part_unit IN"
puts $tclf_id "      }"
puts $tclf_id ""
puts $tclf_id "      # In case initialization fails..."
puts $tclf_id "      if { \[PB_VNC_start_of_program\] \=\= \"EXIT\" } {"
puts $tclf_id "           global mom_sim_delay_one_block"
puts $tclf_id "           set mom_sim_delay_one_block 0"
puts $tclf_id ""
puts $tclf_id "           PB_VNC_end_of_program"
puts $tclf_id ""
puts $tclf_id "           set sim_mtd_initialized 0"
puts $tclf_id ""
puts $tclf_id "           MOM_abort \"ISV aborted!\""
puts $tclf_id "      }"
puts $tclf_id "   }"
puts $tclf_id "}"
puts $tclf_id ""
puts $tclf_id ""
puts $tclf_id ""
puts $tclf_id ""
}
}

#=======================================================================
proc PB_PB2TCL_write_other_procs { TCLF_ID } {
  upvar $TCLF_ID tclf_id
  global post_object
  global env
  if [info exists Post::($post_object,other_proc_list)] \
  {
   array set proc_data $Post::($post_object,other_proc_data)
   set workplane_set 0
   set proc_list [lsort $Post::($post_object,other_proc_list)]
   foreach proc_name $proc_list \
   {
    puts $tclf_id "\n"
    if { [info exists env(PB_TESTING)] && $env(PB_TESTING) && \
     [string match "ARCTAN" $proc_name] } {
     __write_ARCTAN tclf_id
     } else {
     switch $proc_name \
     {
      "__WORKPLANE_SET" \
      {
       __write_WORKPLANE_SET tclf_id
       set workplane_set 1
      }
      "FEEDRATE_SET" -
      "ugpost_FEEDRATE_SET" {}
      default \
      {
       if { ![string match "VNC_*" $proc_name] } {
        if [info exists proc_data($proc_name,comment)] \
        {
         foreach line $proc_data($proc_name,comment) {
          puts $tclf_id "$line"
         }
        } else \
        {
         puts $tclf_id "#============================================================="
        }

#=======================================================================
puts $tclf_id "proc $proc_name \{ $proc_data($proc_name,args) \} \{"
  foreach line $proc_data($proc_name,proc) \
  {
   puts $tclf_id "$line"
  }
 puts $tclf_id "\}"
}
}
}
}
}
}
}

#=======================================================================
proc __write_ARCTAN { TCLF_ID } {
  upvar $TCLF_ID tclf_id
  puts $tclf_id "#============================================================="

#=======================================================================
puts $tclf_id "proc ARCTAN { y x } {"
  puts $tclf_id "#============================================================="
  puts $tclf_id "   global PI"
  puts $tclf_id ""
  puts $tclf_id "   if \[EQ_is_zero \$y\] { set y 0 }"
  puts $tclf_id "   if \[EQ_is_zero \$x\] { set x 0 }"
  puts $tclf_id ""
  puts $tclf_id "   if { \[expr \$y\ == 0] && \[expr \$x\ == 0] } {"
   puts $tclf_id "      return 0"
  puts $tclf_id "   }"
  puts $tclf_id ""
  puts $tclf_id "   set ang \[expr atan2(\$y,\$x)\]"
  puts $tclf_id ""
  puts $tclf_id "   if { \$ang < 0 } {"
   puts $tclf_id "      return \[expr \$ang + \$PI*2\]"
   puts $tclf_id "   } else {"
   puts $tclf_id "      return \$ang"
  puts $tclf_id "   }"
 puts $tclf_id "}"
}

#=======================================================================
proc __write_WORKPLANE_SET { TCLF_ID } {
  upvar $TCLF_ID tclf_id
  puts $tclf_id "#============================================================="

#=======================================================================
puts $tclf_id "proc WORKPLANE_SET { } {"
  puts $tclf_id "#============================================================="
  puts $tclf_id "   global mom_cycle_spindle_axis"
  puts $tclf_id "   global mom_sys_spindle_axis"
  puts $tclf_id "   global traverse_axis1 traverse_axis2"
  puts $tclf_id ""
  puts $tclf_id "   if { !\[info exists mom_sys_spindle_axis\] } {"
   puts $tclf_id "      set mom_sys_spindle_axis(0) 0.0"
   puts $tclf_id "      set mom_sys_spindle_axis(1) 0.0"
   puts $tclf_id "      set mom_sys_spindle_axis(2) 1.0"
  puts $tclf_id "   }"
  puts $tclf_id ""
  puts $tclf_id "   if { !\[info exists mom_cycle_spindle_axis\] } {"
   puts $tclf_id "      set x \$mom_sys_spindle_axis(0)"
   puts $tclf_id "      set y \$mom_sys_spindle_axis(1)"
   puts $tclf_id "      set z \$mom_sys_spindle_axis(2)"
   puts $tclf_id ""
   puts $tclf_id "      if { \[EQ_is_zero \$y\] && \[EQ_is_zero \$z\] } {"
    puts $tclf_id "         set mom_cycle_spindle_axis 0"
    puts $tclf_id "      } elseif { \[EQ_is_zero \$x\] && \[EQ_is_zero \$z\] } {"
    puts $tclf_id "         set mom_cycle_spindle_axis 1"
    puts $tclf_id "      } else {"
    puts $tclf_id "         set mom_cycle_spindle_axis 2"
   puts $tclf_id "      }"
  puts $tclf_id "   }"
  puts $tclf_id ""
  puts $tclf_id "   if { \$mom_cycle_spindle_axis == 2 } {"
   puts $tclf_id "      set traverse_axis1 0 ; set traverse_axis2 1"
   puts $tclf_id "   } elseif { \$mom_cycle_spindle_axis == 0 } {"
   puts $tclf_id "      set traverse_axis1 1 ; set traverse_axis2 2"
   puts $tclf_id "   } elseif { \$mom_cycle_spindle_axis == 1 } {"
   puts $tclf_id "      set traverse_axis1 0 ; set traverse_axis2 2"
  puts $tclf_id "   }"
 puts $tclf_id "}"
}

#=======================================================================
proc PB_PB2TCL_write_list_file_var { TCLF_ID } {
  upvar $TCLF_ID tclf_id
  puts $tclf_id "   ####  Listing File variables "
  PB_output_GetListFileVars list_name_arr list_val_arr
  if { [info exists list_name_arr] } \
  {
   set arr_size 0
   set arr_size [array size list_name_arr]
   for { set count 0 } { $count < $arr_size } { incr count } \
   {
    puts $tclf_id  "     set [format "%-40s  %-5s" $list_name_arr($count) \
    \"$list_val_arr($count)\"]"
   }
  }
  if 1 {
   puts $tclf_id "\n"
   puts $tclf_id "   #============================================================="

#=======================================================================
puts $tclf_id "   proc MOM_before_output { } {"
  puts $tclf_id "   #============================================================="
  puts $tclf_id "   # This command is executed just before every NC block is"
  puts $tclf_id "   # to be output to a file."
  puts $tclf_id "   #"
  puts $tclf_id "   # - Never overload this command!"
  puts $tclf_id "   # - Any customization should be done in PB_CMD_before_output!"
  puts $tclf_id "   #"
  puts $tclf_id ""
  puts $tclf_id "      if { \[llength \[info commands PB_CMD_kin_before_output\]\] } {"
   puts $tclf_id "         PB_CMD_kin_before_output"
  puts $tclf_id "      }"
  puts $tclf_id ""
  puts $tclf_id "   ######### The following procedure invokes the listing file with warnings."
  puts $tclf_id ""
  puts $tclf_id "      LIST_FILE"
 puts $tclf_id "   }"
 puts $tclf_id "\n"
}
}

#=======================================================================
proc PB_PB2TCL_SourceUserTclFile_x { TCLF_ID } {
  upvar $TCLF_ID tclf_id
  global post_object
  set list_file $Post::($post_object,list_obj_list)
  if { $ListingFile::($list_file,usertcl_check) } \
  {
   puts $tclf_id "\n"
   puts $tclf_id "\n"
   puts $tclf_id "#***************************"
   puts $tclf_id "# Source in user's tcl file."
   puts $tclf_id "#***************************"
   puts $tclf_id " set user_tcl_file \${cam_post_dir}$ListingFile::($list_file,usertcl_name)"
   puts $tclf_id " if \{ \[file exists \$user_tcl_file\] \} \{"
    puts $tclf_id "    source \$user_tcl_file"
   puts $tclf_id " \}"
   puts $tclf_id "\n"
  }
 }

#=======================================================================
proc PB_PB2TCL_SourceUserTclFile { TCLF_ID } {
  upvar $TCLF_ID tclf_id
  global post_object
  global ListObjectAttr
  if { [info exists ListObjectAttr(usertcl_name)] && [info exists ListObjectAttr(usertcl_check)] } {
   set user_tcl $ListObjectAttr(usertcl_name)
   if { [info exists ListObjectAttr(usertcl_check)] && $ListObjectAttr(usertcl_check) } \
   {
    puts $tclf_id "\n"
    puts $tclf_id "\n"
    puts $tclf_id "#***************************"
    puts $tclf_id "# Source in user's tcl file."
    puts $tclf_id "#***************************"
    puts $tclf_id "set cam_post_dir \[MOM_ask_env_var UGII_CAM_POST_DIR\]"
    puts $tclf_id "set ugii_version \[string trimleft \[MOM_ask_env_var UGII_VERSION\] v\]"
    puts $tclf_id ""
    puts $tclf_id "if { \$ugii_version >= 5 } {"
     puts $tclf_id "   if { \[file exists \[file dirname \[info script\]\]/$user_tcl\] } {"
      puts $tclf_id "      source \[file dirname \[info script\]\]/$user_tcl"
      puts $tclf_id "   } elseif { \[file exists \${cam_post_dir}$user_tcl\] } {"
      puts $tclf_id "      source \${cam_post_dir}$user_tcl"
     puts $tclf_id "   }"
     puts $tclf_id "} else {"
     puts $tclf_id "   if { \[file exists \${cam_post_dir}$user_tcl\] } {"
      puts $tclf_id "      source \${cam_post_dir}$user_tcl"
     puts $tclf_id "   }"
    puts $tclf_id "}"
    puts $tclf_id "\n"
   }
  }
 }

#=======================================================================
proc PB_PB2TCL_write_reviewtool { TCLF_ID } {
  upvar $TCLF_ID tclf_id
  global post_object
  set list_file $Post::($post_object,list_obj_list)
  puts $tclf_id " "
  puts $tclf_id " "
  if { $ListingFile::($list_file,review) } \
  {
   puts $tclf_id "     set mom_sys_debug_mode ON"
  } else \
  {
   puts $tclf_id "     set mom_sys_debug_mode OFF"
  }
  puts $tclf_id " "
  puts $tclf_id " "
  puts $tclf_id "     if { !\[info exists env(PB_SUPPRESS_UGPOST_DEBUG)\] } {"
   puts $tclf_id "        set env(PB_SUPPRESS_UGPOST_DEBUG) 0"
  puts $tclf_id "     }"
  puts $tclf_id " "
  puts $tclf_id "     if \$env(PB_SUPPRESS_UGPOST_DEBUG) {"
   puts $tclf_id "        set mom_sys_debug_mode OFF"
  puts $tclf_id "     }"
  puts $tclf_id " "
  puts $tclf_id "     if { \$mom_sys_debug_mode == \"OFF\" } {"
   puts $tclf_id " "

#=======================================================================
puts $tclf_id "        proc MOM_before_each_add_var {} {}"

#=======================================================================
puts $tclf_id "        proc MOM_before_each_event {} {}"
 puts $tclf_id " "
 puts $tclf_id "     } else {"
 puts $tclf_id " "
 puts $tclf_id "        set cam_debug_dir \[MOM_ask_env_var UGII_CAM_DEBUG_DIR\]"
 puts $tclf_id "        source \${cam_debug_dir}mom_review.tcl"
puts $tclf_id "     }"
puts $tclf_id " "
if $ListingFile::($list_file,verbose) \
{
 puts $tclf_id "     MOM_set_debug_mode ON"
 } else {
 puts $tclf_id "     MOM_set_debug_mode \$mom_sys_debug_mode"
}
}

#=======================================================================
proc PB_lappend {LIST str} {
  global gPB
  upvar #$gPB(level) $LIST lst
  if {$str == "\n"} {
   lappend lst {}
   lappend lst {}
   } else {
   lappend lst $str
  }
 }

#=======================================================================
proc PB_PB2TCL_write_license_tcl { tcl_file } {
  set tclf_id [open "$tcl_file" w]
  fconfigure $tclf_id -translation lf
  global env gPB
  set time_string [clock format [clock seconds] -format "%c %Z"]
  puts $tclf_id "####################### Post Processor ##############################"
  puts $tclf_id "#"
  puts $tclf_id "#  [file tail $tcl_file] -"
  puts $tclf_id "#"
  puts $tclf_id "#  Created by $env(USERNAME) @ $time_string"
  puts $tclf_id "#  with Post Builder version $gPB(Postbuilder_Release_Version)."
  puts $tclf_id "#"
  puts $tclf_id "#####################################################################"
  puts $tclf_id ""
  puts $tclf_id ""
  puts $tclf_id "set encrypted_post_file \"\[file rootname \[info script\]\]_tcl.txt\""
  puts $tclf_id ""
  puts $tclf_id ""
  puts $tclf_id "if { !\[file exists \$encrypted_post_file\] } {"
   puts $tclf_id "   set __msg \"ERROR in \[info script\] :\\n\\"
   puts $tclf_id "              \\n\\\"\$encrypted_post_file\\\" is not found.\""
   puts $tclf_id "   MOM_abort \$__msg"
  puts $tclf_id "}"
  puts $tclf_id ""
  puts $tclf_id ""
  puts $tclf_id "#============================================================="

#=======================================================================
puts $tclf_id "proc VNC_ask_shared_library_suffix { } {"
  puts $tclf_id "#============================================================="
  puts $tclf_id "   global tcl_platform"
  puts $tclf_id ""
  puts $tclf_id "   set suffix \"\""
  puts $tclf_id "   set suffix \[string trimleft \[info sharedlibextension\] .\]"
  puts $tclf_id ""
  puts $tclf_id "   if { \[string match \"\" \$suffix\] } {"
   puts $tclf_id ""
   puts $tclf_id "      if { \[string match \"*windows*\" \$tcl_platform(platform)\] } {"
    puts $tclf_id ""
    puts $tclf_id "         set suffix dll"
    puts $tclf_id ""
    puts $tclf_id "      } else {"
    puts $tclf_id ""
    puts $tclf_id "         if { \[string match \"*HP-UX*\" \$tcl_platform(os)\] } {"
     puts $tclf_id "            set suffix sl"
     puts $tclf_id "         } elseif { \[string match \"*AIX*\" \$tcl_platform(os)\] } {"
     puts $tclf_id "            set suffix a"
     puts $tclf_id "         } else {"
     puts $tclf_id "            set suffix so"
    puts $tclf_id "         }"
   puts $tclf_id "      }"
  puts $tclf_id "   }"
  puts $tclf_id ""
  puts $tclf_id "return \$suffix"
 puts $tclf_id "}"
 puts $tclf_id ""
 puts $tclf_id ""
 puts $tclf_id "set suff  \[VNC_ask_shared_library_suffix\]"
 if 0 {
  puts $tclf_id "#===================================================================="

#=======================================================================
puts $tclf_id "proc PB_ask_shared_library_suffix { } {"
  puts $tclf_id "#===================================================================="
  puts $tclf_id "  global tcl_platform env"
  puts $tclf_id ""
  puts $tclf_id "  if { \[string match \"*windows*\" \$tcl_platform(platform)\] } {"
   puts $tclf_id ""
   puts $tclf_id "     set suffix dll"
   puts $tclf_id ""
   puts $tclf_id "  } else {"
   puts $tclf_id ""
   puts $tclf_id "     if { \[string match \"*HP-UX*\" \$tcl_platform(os)\] } {"
    puts $tclf_id "         set suffix sl"
    puts $tclf_id "     } elseif { \[string match \"*AIX*\" \$tcl_platform(os)\] } {"
    puts $tclf_id "         set suffix a"
    puts $tclf_id "     } else {"
    puts $tclf_id "         set suffix so"
   puts $tclf_id "     }"
  puts $tclf_id "  }"
  puts $tclf_id ""
  puts $tclf_id "  if { \[info exists env(PLAT)\] && \[string match \"macos\" \$env(PLAT)\] } {"
   puts $tclf_id "     set suffix dylib"
  puts $tclf_id "  }"
  puts $tclf_id ""
  puts $tclf_id "  return \$suffix"
 puts $tclf_id "}"
 puts $tclf_id ""
 puts $tclf_id ""
 puts $tclf_id "set suff  \[PB_ask_shared_library_suffix\]"
}
puts $tclf_id ""
puts $tclf_id "set cam_aux_dir  \[MOM_ask_env_var UGII_CAM_AUXILIARY_DIR\]"
puts $tclf_id ""
puts $tclf_id ""
puts $tclf_id "if { !\[file exists \${cam_aux_dir}mom_source.\$suff\] } {"
 puts $tclf_id "   set suff so"
puts $tclf_id "}"
puts $tclf_id ""
puts $tclf_id "if { !\[file exists \${cam_aux_dir}mom_source.\$suff\] } {"
 puts $tclf_id "   set __msg \"ERROR in \[info script\] :\\n\\"
 puts $tclf_id "             \\nShared library \\\"mom_source\\\" is not found in \${cam_aux_dir}.\""
 puts $tclf_id ""
 puts $tclf_id "   MOM_abort \$__msg"
puts $tclf_id "}"
puts $tclf_id ""
if 1 {
 global mom_sys_arr
 if { [info exists mom_sys_arr(Output_VNC)] && $mom_sys_arr(Output_VNC) == 1 } {
  if { [info exists env(UGII_CAM_POST_OUTPUT_EXTENDED_NC)] } {
   puts $tclf_id "if { !\[info exists mom_sim_output_extended_nc\] } {"
    puts $tclf_id "  set mom_sim_output_extended_nc  $env(UGII_CAM_POST_OUTPUT_EXTENDED_NC)"
   puts $tclf_id "}"
   puts $tclf_id ""
   puts $tclf_id ""
   puts $tclf_id "# Debug mode enables ISV QC messages output."
   puts $tclf_id "set mom_sim_post_builder_debug  0"
   puts $tclf_id ""
   puts $tclf_id ""
  }
 }
 puts $tclf_id "\n"
 puts $tclf_id "  set cam_post_dir \[MOM_ask_env_var UGII_CAM_POST_DIR\]"
 puts $tclf_id ""
 puts $tclf_id ""
 puts $tclf_id "  if { !\[info exists mom_sys_post_initialized\] } {"
  puts $tclf_id ""
  puts $tclf_id "     source \${cam_post_dir}ugpost_base.tcl"
  PB_PB2TCL_write_reviewtool tclf_id
  puts $tclf_id ""
  puts $tclf_id ""
  PB_PB2TCL_write_list_file_var tclf_id
  puts $tclf_id ""
  global mom_sys_arr
  puts $tclf_id "     set [format "%-40s  %-5s" "mom_sys_control_out" \
  \"[PB_output_EscapeSpecialControlChar $mom_sys_arr(Comment_Start)]\"]"
  puts $tclf_id "     set [format "%-40s  %-5s" "mom_sys_control_in" \
  \"[PB_output_EscapeSpecialControlChar $mom_sys_arr(Comment_End)]\"]"
  puts $tclf_id ""
  puts $tclf_id "     set mom_sys_post_initialized 1"
 puts $tclf_id "  }"
 puts $tclf_id ""
 puts $tclf_id ""
 PB_PB2TCL_write_sys_var_arr tclf_id
 puts $tclf_id ""
 PB_PB2TCL_write_kin_var_arr tclf_id
 puts $tclf_id ""
 puts $tclf_id ""
 puts $tclf_id ""
}
puts $tclf_id "catch {"
 puts $tclf_id "   MOM_run_user_function \${cam_aux_dir}mom_source.\$suff ufusr"
 puts $tclf_id "   MOM_decrypt_source \[file nativename \$encrypted_post_file\]"
puts $tclf_id "}"
puts $tclf_id ""
close $tclf_id
}

#=======================================================================
proc PB_output_adjust_var_value {case {loc PST}} {
   global LicInfo gPB
   set caseInfo ""
   switch $case {
    1 {
     set LicInfo(post_site_id) $gPB(PB_SITE_ID)
     set LicInfo(post_license) $gPB(license_to_use)
     set LicInfo(post_license_vnc) $gPB(license_to_use_vnc)
     set LicInfo(is_encrypted_file) 1
     set caseInfo "caseInfo ==>\n\
     Author user;\n\
     New session;\n\
     Encrypted: YES\n"
    }
    2 {
     set LicInfo(is_encrypted_file) 0
     set caseInfo "caseInfo ==>\n\
     Author user;\n\
     New session;\n\
     Encrypted: NO\n"
    }
    3 {
     set LicInfo(post_site_id) $gPB(PB_SITE_ID)
     set LicInfo(post_license) $gPB(license_to_use)
     set LicInfo(post_license_vnc) $gPB(license_to_use_vnc)
     set LicInfo(is_encrypted_file) 1
     set caseInfo "caseInfo ==>\n\
     Author user;\n\
     Edit session;\n\
     Is_encrypted_file: YES\n\
     Is_owner: YES\n\
     Is_to_encrypt: YES\n"
    }
    4 {
     unset LicInfo(is_encrypted_file)
     unset LicInfo(post_site_id)
     unset LicInfo(post_license)
     if [info exists LicInfo(post_license_vnc)] {
      unset LicInfo(post_license_vnc)
     }
     set caseInfo "caseInfo ==>\n\
     Author user;\n\
     Edit session;\n\
     Is_encrypted_file: YES\n\
     Is_owner: YES\n\
     Is_to_encrypt: NO\n"
    }
    5 {
     set LicInfo(is_encrypted_file) 1
     set caseInfo "caseInfo ==>\n\
     Author user;\n\
     Edit session;\n\
     Is_encrypted_file: YES\n\
     Is_owner: NO\n\
     Encrypted: YES\n"
    }
    6 {
     set LicInfo(is_encrypted_file) 1
     set caseInfo "caseInfo ==>\n\
     Author user;\n\
     Edit session;\n\
     Is_encrypted_file: YES\n\
     Is_owner: NO\n\
     Encrypted: YES\n"
    }
    7 {
     set LicInfo(post_site_id) $gPB(PB_SITE_ID)
     set LicInfo(post_license) $gPB(license_to_use)
     set LicInfo(post_license_vnc) $gPB(license_to_use_vnc)
     set LicInfo(is_encrypted_file) 1
     set caseInfo "caseInfo ==>\n\
     Author user;\n\
     Edit session;\n\
     Is_encrypted_file: NO\n\
     Encrypted: YES\n"
    }
    8 {
     set caseInfo "caseInfo ==>\n\
     Author user;\n\
     Edit session;\n\
     Is_encrypted_file: NO\n\
     Encrypted: NO\n"
    }
    9 {
     set caseInfo "caseInfo ==>\n\
     General user;\n\
     New session;\n\
     Encrypted: NO\n"
    }
    10 {
     set LicInfo(is_encrypted_file) 1
     set caseInfo "caseInfo ==>\n\
     General user;\n\
     Edit session;\n\
     Is_encrypted_file: YES\n\
     Encrypted: YES\n"
    }
    11 {
     set caseInfo "caseInfo ==>\n\
     General user;\n\
     Edit session;\n\
     Is_encrypted_file: NO\n\
     Encrypted: NO\n"
    }
    default {
     set caseInfo "Default case\n"
    }
   }
  }

#=======================================================================
proc PB_PB2TCL_main { OUTPUT_TCL_FILE } {
  upvar $OUTPUT_TCL_FILE tcl_file
  global env gPB
  global LicInfo
  if { $::disable_license == 0 } {
   set case ""
   if [string match "UG_POST_AUTHOR" $gPB(PB_LICENSE)] {
    if {$gPB(session) == "NEW"} {
     if {$gPB(license_authorize) == 1 && $gPB(license_to_use) != ""} {
      set LicInfo(site_id) $gPB(PB_SITE_ID)
      set LicInfo(license) $gPB(license_to_use)
      set case 1
      set to_encrypt 1
      } else {
      set case 2
      set to_encrypt 0
     }
     } else {
     if {[info exists LicInfo(is_encrypted_file)] && $LicInfo(is_encrypted_file) == 1} {
      if {$gPB(PB_SITE_ID) == $LicInfo(post_site_id)} {
       if {[lsearch $gPB(lic_list) $LicInfo(post_license)] >= 0} {
        if {$gPB(license_authorize) == 1 && $gPB(license_to_use) != ""} {
         set LicInfo(site_id) $gPB(PB_SITE_ID)
         set LicInfo(license) $gPB(license_to_use)
         set case 3
         set to_encrypt 1
         } else {
         set case 4
         set to_encrypt 0
        }
        } else {
        set LicInfo(site_id) $LicInfo(post_site_id)
        set LicInfo(license) $LicInfo(post_license)
        set case 5
        set to_encrypt 1
       }
       } else {
       set LicInfo(site_id) $LicInfo(post_site_id)
       set LicInfo(license) $LicInfo(post_license)
       set case 6
       set to_encrypt 1
      }
      } else {
      if {$gPB(license_authorize) == 1 && $gPB(license_to_use) != ""} {
       set LicInfo(site_id) $gPB(PB_SITE_ID)
       set LicInfo(license) $gPB(license_to_use)
       set case 7
       set to_encrypt 1
       } else {
       set case 8
       set to_encrypt 0
      }
     }
    }
    } else {
    if {$gPB(session) == "NEW"} {
     set case 9
     set to_encrypt 0
     } else {
     if {[info exists LicInfo(is_encrypted_file)] && $LicInfo(is_encrypted_file) == 1} {
      set LicInfo(site_id) $LicInfo(post_site_id)
      set LicInfo(license) $LicInfo(post_license)
      set case 10
      set to_encrypt 1
      } else {
      set case 11
      set to_encrypt 0
     }
    }
   }
   global mom_sys_arr
   if {[info exists mom_sys_arr(Output_VNC)] != 1 || $mom_sys_arr(Output_VNC) == 0 }  {
    PB_output_adjust_var_value $case
   }
   } else {
   set to_encrypt 0
  }
  if { $to_encrypt == 1 } {
   set encrypted_post_file "[file rootname $tcl_file]_tcl.txt"
   PB_PB2TCL_write_license_tcl $tcl_file
   set source_code_list [list]
   set tclf_id source_code_list
   set gPB(level) [info level]
   rename puts myputs
   rename PB_lappend puts
   } else {
   if [file exists [file rootname $tcl_file]_tcl.txt] {
    file delete -force [file rootname $tcl_file]_tcl.txt
   }
   set tclf_id [open "$tcl_file" w]
   fconfigure $tclf_id -translation lf
  }
  set LicInfo(to_encrypt) $to_encrypt
  if { $to_encrypt == 1 } {
   set LicInfo(license_title)  $LicInfo(license)
  }
  if 0 {
   if {$to_encrypt == 1} {
    set org [wm title .widget]
    set org [string trim [lindex [split $org -] 0]]
    wm title .widget "${org} - License : [lindex $LicInfo(license) 0]"
    } else {
    set org [wm title .widget]
    set org [string trim [lindex [split $org -] 0]]
    if [string match "UG_POST_AUTHOR" $gPB(PB_LICENSE)] {
     wm title .widget "${org} - License Control"
     } else {
     wm title .widget "${org}"
    }
   }
  }
  set time_string [clock format [clock seconds] -format "%c %Z"]
  puts $tclf_id "########################## TCL Event Handlers ##########################"
  puts $tclf_id "#"
  puts $tclf_id "#  [file tail $tcl_file] -"
  puts $tclf_id "#"
  puts $tclf_id "#  Created by $env(USERNAME)  @  $time_string"
  puts $tclf_id "#  with Post Builder version  $gPB(Postbuilder_Release_Version)."
  puts $tclf_id "#"
  puts $tclf_id "########################################################################"
  puts $tclf_id ""
  if { $to_encrypt != 1 } {
   global mom_sys_arr
   if { [info exists mom_sys_arr(Output_VNC)] && $mom_sys_arr(Output_VNC) == 1 } {
    if [info exists env(UGII_CAM_POST_OUTPUT_EXTENDED_NC)] {
     puts $tclf_id "if !\[info exists mom_sim_output_extended_nc\] {"
      puts $tclf_id "  set mom_sim_output_extended_nc  $env(UGII_CAM_POST_OUTPUT_EXTENDED_NC)"
     puts $tclf_id "}"
     puts $tclf_id ""
     puts $tclf_id "# Debug mode enables ISV QC messages output."
     puts $tclf_id "set mom_sim_post_builder_debug  0"
     puts $tclf_id ""
     puts $tclf_id ""
    }
   }
   puts $tclf_id ""
   puts $tclf_id "  set cam_post_dir \[MOM_ask_env_var UGII_CAM_POST_DIR\]"
   puts $tclf_id ""
   puts $tclf_id ""
   puts $tclf_id "  if { !\[info exists mom_sys_post_initialized\] } {"
    puts $tclf_id ""
    puts $tclf_id "     source \${cam_post_dir}ugpost_base.tcl"
    global mom_sys_arr
    if {[info exists mom_sys_arr(Inherit_UDE)] && $mom_sys_arr(Inherit_UDE) == 1} {
     puts $tclf_id ""
     puts $tclf_id "   ####  Include Handler File for UDE "
     puts $tclf_id ""
     set tcl_fn $mom_sys_arr(PST_File_Name).tcl
     if [string match $mom_sys_arr(PST_File_Folder) ""] {
      puts $tclf_id "     catch { source $tcl_fn }"
      } else {
      set folder $mom_sys_arr(PST_File_Folder)
      if ![string match "*/" $folder] {
       set folder "${folder}/"
      }
      if [regexp {UGII[A-Za-z0-9_]+} $folder ugii_var] {
       set ugii_var [string toupper $ugii_var]
       if [regexp {^UGII_CAM_POST_DIR$} $ugii_var] {
        regsub {(\$?)UGII[A-Za-z0-9_]+(/?)} $folder "\$\{cam_post_dir\}" folder
        puts $tclf_id "     catch { source ${folder}$tcl_fn }"
        } else {
        puts $tclf_id "     set [string tolower $ugii_var] \[MOM_ask_env_var $ugii_var\]"
        regsub {(\$?)UGII[A-Za-z0-9_]+(/?)} $folder "\$\{[string tolower $ugii_var]\}" folder
        puts $tclf_id "     catch { source ${folder}$tcl_fn }"
       }
       } else {
       puts $tclf_id "     catch { source ${folder}$tcl_fn }"
      }
     }
     puts $tclf_id "     if { \[info exists mom_sys_start_of_program_flag\] } {"
      puts $tclf_id "        unset mom_sys_start_of_program_flag"
     puts $tclf_id "     }"
     puts $tclf_id "     if { \[info exists mom_sys_head_change_init_program\] } {"
      puts $tclf_id "        unset mom_sys_head_change_init_program"
     puts $tclf_id "     }"
    }
    PB_PB2TCL_write_reviewtool tclf_id
    puts $tclf_id ""
    puts $tclf_id ""
    PB_PB2TCL_write_list_file_var tclf_id
    puts $tclf_id ""
    global mom_sys_arr
    if 0 {
     puts $tclf_id "     set [format "%-40s  %-5s" "mom_sys_control_out" \
     \"$mom_sys_arr(\$mom_sys_control_out)\"]"
     puts $tclf_id "     set [format "%-40s  %-5s" "mom_sys_control_in" \
     \"$mom_sys_arr(\$mom_sys_control_in)\"]"
    }
    puts $tclf_id "     set [format "%-40s  %-5s" "mom_sys_control_out" \
    \"[PB_output_EscapeSpecialControlChar $mom_sys_arr(Comment_Start)]\"]"
    puts $tclf_id "     set [format "%-40s  %-5s" "mom_sys_control_in" \
    \"[PB_output_EscapeSpecialControlChar $mom_sys_arr(Comment_End)]\"]"
    puts $tclf_id ""
    puts $tclf_id "     set mom_sys_post_initialized 1"
   puts $tclf_id "  }"
   puts $tclf_id ""
   puts $tclf_id ""
   PB_PB2TCL_write_sys_var_arr tclf_id
   puts $tclf_id ""
   PB_PB2TCL_write_kin_var_arr tclf_id
   puts $tclf_id ""
   puts $tclf_id ""
  }
  PB_PB2TCL_insert_axis_mult tclf_id $to_encrypt
  PB_PB2TCL_write_local_procs tclf_id
  PB_PB2TCL_write_tcl_procs tclf_id
  PB_PB2TCL_write_command_procs tclf_id POST
  PB_PB2TCL_write_other_procs tclf_id
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
  if {$to_encrypt == 1} {
   rename puts PB_lappend
   rename myputs puts
   unset gPB(level)
   UI_PB_encrypt_post $encrypted_post_file $source_code_list NO
   } else {
   close $tclf_id
  }
 }

#=======================================================================
proc PB_PB2VNC_write_lincese_tcl_X { vnc_file } {
  set tclf_id [open "$vnc_file" w]
  fconfigure $tclf_id -translation lf
  global env gPB mom_sys_arr
  set time_string [clock format [clock seconds] -format "%c %Z"]
  puts $tclf_id "####################### Virtual NC Controller ##########################"
  puts $tclf_id "#"
  puts $tclf_id "#  [file tail $vnc_file] -"
  puts $tclf_id "#"
  puts $tclf_id "#  Created by $env(USERNAME) @ $time_string"
  puts $tclf_id "#  with Post Builder version $gPB(Postbuilder_Release_Version)."
  puts $tclf_id "#"
  puts $tclf_id "#####################################################################"
  puts $tclf_id ""
  puts $tclf_id ""
  puts $tclf_id "set mom_sim_vnc_handler_loaded \"\[join \[split \[info script\] \\\\\] \\\\\]\""
  if [string match "Standalone" $mom_sys_arr(VNC_Mode)] {
   puts $tclf_id "set mom_sim_master_vnc_loaded \[file tail \$mom_sim_vnc_handler_loaded\]"
  }
  puts $tclf_id "set encrypted_vnc_file \"\[file rootname \$mom_sim_vnc_handler_loaded\]_tcl.txt\""
  puts $tclf_id ""
  puts $tclf_id ""
  puts $tclf_id "if { !\[file exists \$encrypted_vnc_file\] } {"
   puts $tclf_id "   set __msg \"ERROR in \[info script\] :\\n\\"
   puts $tclf_id "              \\n\\\"\$encrypted_vnc_file\\\" is not found.\""
   puts $tclf_id "   MOM_abort \$__msg"
  puts $tclf_id "}"
  puts $tclf_id ""
  puts $tclf_id ""
  if [string match "Standalone" $mom_sys_arr(VNC_Mode)] {
   PB_PB2VNC_write_vnc_base tclf_id
   PB_PB2VNC_write_nc_defs tclf_id
  }
  puts $tclf_id ""
  puts $tclf_id ""
  puts $tclf_id ""
  puts $tclf_id "catch {"
   puts $tclf_id "   MOM_run_user_function \${cam_aux_dir}mom_source.\$suff ufusr"
   puts $tclf_id "   MOM_decrypt_source \[file nativename \$encrypted_vnc_file\]"
  puts $tclf_id "}"
  puts $tclf_id ""
  if [string match "Subordinate" $mom_sys_arr(VNC_Mode)] {
   PB_PB2VNC_write_nc_defs tclf_id
  }
  close $tclf_id
 }

#=======================================================================
proc PB_PB2VNC_write_license_tcl { vnc_file } {
  set tclf_id [open "$vnc_file" w]
  fconfigure $tclf_id -translation lf
  global env gPB mom_sys_arr
  set time_string [clock format [clock seconds] -format "%c %Z"]
  puts $tclf_id "####################### Virtual NC Controller ##########################"
  puts $tclf_id "#"
  puts $tclf_id "#  [file tail $vnc_file] -"
  puts $tclf_id "#"
  puts $tclf_id "#  Created by $env(USERNAME) @ $time_string"
  puts $tclf_id "#  with Post Builder version $gPB(Postbuilder_Release_Version)."
  puts $tclf_id "#"
  puts $tclf_id "########################################################################"
  puts $tclf_id ""
  puts $tclf_id ""
  puts $tclf_id "set mom_sim_vnc_handler_loaded \"\[join \[split \[info script\] \\\\\] /\]\""
  if [string match "Standalone" $mom_sys_arr(VNC_Mode)] {
   puts $tclf_id "set mom_sim_master_vnc_loaded \[file tail \$mom_sim_vnc_handler_loaded\]"
  }
  puts $tclf_id "set encrypted_vnc_file \"\[file rootname \$mom_sim_vnc_handler_loaded\]_tcl.txt\""
  puts $tclf_id ""
  puts $tclf_id ""
  puts $tclf_id "if { !\[file exists \$encrypted_vnc_file\] } {"
   puts $tclf_id "   set __msg \"ERROR in \[info script\] :\\n\\"
   puts $tclf_id "              \\n\\\"\$encrypted_vnc_file\\\" is not found.\""
   puts $tclf_id "   MOM_abort \$__msg"
  puts $tclf_id "}"
  puts $tclf_id ""
  puts $tclf_id ""
  if [string match "Standalone" $mom_sys_arr(VNC_Mode)] {
   PB_PB2VNC_write_vnc_base tclf_id
   PB_PB2VNC_write_nc_defs tclf_id
  }
  puts $tclf_id ""
  puts $tclf_id "catch {"
   puts $tclf_id "   MOM_run_user_function \${cam_aux_dir}mom_source.\$suff ufusr"
   puts $tclf_id "   MOM_decrypt_source \[file nativename \$encrypted_vnc_file\]"
  puts $tclf_id "}"
  puts $tclf_id ""
  if [string match "Subordinate" $mom_sys_arr(VNC_Mode)] {
   PB_PB2VNC_write_nc_defs tclf_id
  }
  close $tclf_id
 }

#=======================================================================
proc PB_PB2VNC_main { VNC_FILE } {
  upvar $VNC_FILE vnc_file
  global env gPB
  global mom_sys_arr
  global LicInfo
  if { [info exists mom_sys_arr(Output_VNC)] && \
   $mom_sys_arr(Output_VNC) == 1 } {
   if {$::disable_license == 0} {
    set case ""
    if [string match "UG_POST_AUTHOR" $gPB(PB_LICENSE)] {
     if {$gPB(session) == "NEW"} {
      if {$gPB(license_authorize) == 1 && $gPB(license_to_use_vnc) != ""} {
       set LicInfo(site_id) $gPB(PB_SITE_ID)
       set LicInfo(license) $gPB(license_to_use_vnc)
       set case 1
       set to_encrypt 1
       } else {
       set case 2
       set to_encrypt 0
      }
      } else {
      if {[info exists LicInfo(is_encrypted_file)] && $LicInfo(is_encrypted_file) == 1} {
       if {$gPB(PB_SITE_ID) == $LicInfo(post_site_id)} {
        if {[lsearch $gPB(lic_list) $LicInfo(post_license)] >= 0} {
         if {$gPB(license_authorize) == 1 && $gPB(license_to_use_vnc) != ""} {
          set LicInfo(site_id) $gPB(PB_SITE_ID)
          set LicInfo(license) $gPB(license_to_use_vnc)
          set case 3
          set to_encrypt 1
          } else {
          set case 4
          set to_encrypt 0
         }
         } else {
         set LicInfo(site_id) $LicInfo(post_site_id)
         if {[info exists LicInfo(post_license_vnc)] && $LicInfo(post_license_vnc) != ""} {
          set LicInfo(license) $LicInfo(post_license_vnc)
          set to_encrypt 1
          } else {
          set to_encrypt 0
         }
         set case 5
        }
        } else {
        set LicInfo(site_id) $LicInfo(post_site_id)
        if {[info exists LicInfo(post_license_vnc)] && $LicInfo(post_license_vnc) != ""} {
         set LicInfo(license) $LicInfo(post_license_vnc)
         set to_encrypt 1
         } else {
         set to_encrypt 0
        }
        set case 6
       }
       } else {
       if {$gPB(license_authorize) == 1 && $gPB(license_to_use_vnc) != ""} {
        set LicInfo(site_id) $gPB(PB_SITE_ID)
        set LicInfo(license) $gPB(license_to_use_vnc)
        set case 7
        set to_encrypt 1
        } else {
        set case 8
        set to_encrypt 0
       }
      }
     }
     } else {
     if {$gPB(session) == "NEW"} {
      set case 9
      set to_encrypt 0
      } else {
      if {[info exists LicInfo(is_encrypted_file)] && $LicInfo(is_encrypted_file) == 1} {
       set LicInfo(site_id) $LicInfo(post_site_id)
       if {[info exists LicInfo(post_license_vnc)] && $LicInfo(post_license_vnc) != ""} {
        set LicInfo(license) $LicInfo(post_license_vnc)
        set to_encrypt 1
        } else {
        set to_encrypt 0
       }
       set case 10
       } else {
       set case 11
       set to_encrypt 0
      }
     }
    }
    PB_output_adjust_var_value $case VNC
    } else {
    set to_encrypt 0
   }
   if {$to_encrypt == 1} {
    set encrypted_vnc_file "[file rootname $vnc_file]_tcl.txt"
    PB_PB2VNC_write_license_tcl $vnc_file
    set source_code_list [list]
    set tclf_id source_code_list
    set gPB(level) [info level]
    rename puts myputs
    rename PB_lappend puts
    } else {
    if [file exists [file rootname $vnc_file]_tcl.txt] {
     file delete -force [file rootname $vnc_file]_tcl.txt
    }
    set tclf_id [open "$vnc_file" w]
    fconfigure $tclf_id -translation lf
   }
   set time_string [clock format [clock seconds] -format "%c %Z"]
   puts $tclf_id "######################## Virtual NC Controller #########################"
   puts $tclf_id "#"
   puts $tclf_id "#  [file tail $vnc_file] -"
   puts $tclf_id "#"
   puts $tclf_id "#  Created by $env(USERNAME)  @  $time_string"
   puts $tclf_id "#  with Post Builder version  $gPB(Postbuilder_Release_Version)."
   puts $tclf_id "#"
   puts $tclf_id "########################################################################"
   puts $tclf_id ""
   puts $tclf_id ""
   if [string match "Standalone" $mom_sys_arr(VNC_Mode)] {
    if {$to_encrypt != 1} {
     puts $tclf_id "set mom_sim_vnc_handler_loaded \"\[join \[split \[info script\] \\\\\] /\]\""
     puts $tclf_id "set mom_sim_master_vnc_loaded \[file tail \$mom_sim_vnc_handler_loaded\]"
     puts $tclf_id ""
     puts $tclf_id ""
     PB_PB2VNC_write_vnc_base      tclf_id
    }
    } else {
    puts $tclf_id "set cam_post_dir \[MOM_ask_env_var UGII_CAM_POST_DIR\]"
    if ![string match "*.tcl" $mom_sys_arr(Main_VNC)] {
     set mom_sys_arr(Main_VNC) $mom_sys_arr(Main_VNC).tcl
    }
    puts $tclf_id "set master_vnc \"$mom_sys_arr(Main_VNC)\""
    puts $tclf_id ""
    puts $tclf_id ""
    puts $tclf_id "if { !\[info exists mom_sim_vnc_handler_loaded\] ||\\"
     puts $tclf_id "     !\[info exists mom_sim_master_vnc_loaded\]  ||\\"
     puts $tclf_id "      \[string compare \$mom_sim_master_vnc_loaded \$master_vnc\] } {"
     puts $tclf_id ""
     puts $tclf_id "   if { \[file exists \[file dirname \[info script\]\]/\$master_vnc\] } {"
      puts $tclf_id "      catch { source \[file dirname \[info script\]\]/\$master_vnc }"
      puts $tclf_id "   } elseif { \[file exists \${cam_post_dir}\$master_vnc\] } {"
      puts $tclf_id "      catch { source \${cam_post_dir}\$master_vnc }"
     puts $tclf_id "   }"
    puts $tclf_id "}"
    puts $tclf_id ""
    puts $tclf_id ""
    puts $tclf_id "set mom_sim_vnc_handler_loaded \"\[join \[split \[info script\] \\\\\] /\]\""
    puts $tclf_id ""
    puts $tclf_id ""
   }
   if {$to_encrypt != 1} {
    PB_PB2VNC_write_nc_defs       tclf_id
   }
   PB_PB2TCL_write_command_procs tclf_id VNC
   if {$to_encrypt == 1} {
    rename puts PB_lappend
    rename myputs puts
    unset gPB(level)
    UI_PB_encrypt_post $encrypted_vnc_file $source_code_list NO
    } else {
    close $tclf_id
   }
  }
 }

#=======================================================================
proc PB_PB2VNC_write_vnc_base { FILE_ID } {
  upvar $FILE_ID file_id
  global gPB
  global env
  set vnc_version  "6.0.0"
  set vnc_base     vnc_base_v[join [split $vnc_version .] ""]
  if 0 {
   set vnc_base $env(PB_HOME)/pblib/vnc_base.tcl
   if [file exists $vnc_base] {
    set fid [open [subst -nobackslashes ${vnc_base}] "r"]
    if 1 {
     set contents [read $fid]
     puts -nonewline $file_id $contents
     } else {
     __output_CompactFile $fid $file_id
     puts $file_id "\n\n"
    }
    close $fid
   }
  }
  puts $file_id "set mom_sim_post_builder_version $gPB(Postbuilder_Release_Version)"
  puts $file_id ""
  puts $file_id ""
  puts $file_id "if { !\[info exists sim_mtd_initialized\] } {"
   puts $file_id "   set sim_mtd_initialized 0"
  puts $file_id "}"
  puts $file_id ""
  puts $file_id ""
  puts $file_id "#++++++++++++++++++++++++++++++++++++"
  puts $file_id "# Define the base elements only once!"
  puts $file_id "#++++++++++++++++++++++++++++++++++++"
  puts $file_id "if { \$sim_mtd_initialized == 0 } {"
   puts $file_id ""
   puts $file_id ""
   puts $file_id ""
   puts $file_id "set cam_aux_dir   \[MOM_ask_env_var UGII_CAM_AUXILIARY_DIR\]"
   puts $file_id "set cam_post_dir  \[MOM_ask_env_var UGII_CAM_POST_DIR\]"
   puts $file_id ""
   puts $file_id ""
   puts $file_id "set vnc_base_sourced 0"
   puts $file_id ""
   puts $file_id ""
   if { [info exists env(PB_DEVELOPMENT)] && $env(PB_DEVELOPMENT) } {
    puts $file_id "# Codes for Post Builder Development"
    puts $file_id "if 1 {"
     puts $file_id "if \[file exists \${cam_post_dir}${vnc_base}.tcl\] {"
      puts $file_id ""
      puts $file_id "   if { !\[catch { source \"\${cam_post_dir}${vnc_base}.tcl\" }\] } {"
       puts $file_id "      set vnc_base_sourced 1"
      puts $file_id "   }"
     puts $file_id "}"
    puts $file_id "}"
    puts $file_id ""
    puts $file_id ""
   }
   puts $file_id "if { !\$vnc_base_sourced } {"
    puts $file_id ""
    puts $file_id ""
    puts $file_id "#============================================================="

#=======================================================================
puts $file_id "proc VNC_ask_shared_library_suffix { } {"
  puts $file_id "#============================================================="
  puts $file_id "   global tcl_platform"
  puts $file_id ""
  puts $file_id "   set suffix \"\""
  puts $file_id "   set suffix \[string trimleft \[info sharedlibextension\] .\]"
  puts $file_id ""
  puts $file_id "   if { \[string match \"\" \$suffix\] } {"
   puts $file_id ""
   puts $file_id "      if { \[string match \"*windows*\" \$tcl_platform(platform)\] } {"
    puts $file_id ""
    puts $file_id "         set suffix dll"
    puts $file_id ""
    puts $file_id "      } else {"
    puts $file_id ""
    puts $file_id "         if { \[string match \"*HP-UX*\" \$tcl_platform(os)\] } {"
     puts $file_id "            set suffix sl"
     puts $file_id "         } elseif { \[string match \"*AIX*\" \$tcl_platform(os)\] } {"
     puts $file_id "            set suffix a"
     puts $file_id "         } else {"
     puts $file_id "            set suffix so"
    puts $file_id "         }"
   puts $file_id "      }"
  puts $file_id "   }"
  puts $file_id ""
  puts $file_id "return \$suffix"
 puts $file_id "}"
 puts $file_id ""
 puts $file_id ""
 puts $file_id "set suff  \[VNC_ask_shared_library_suffix\]"
 puts $file_id ""
 puts $file_id ""
 puts $file_id "if { !\[file exists \${cam_aux_dir}mom_source.\$suff\] } {"
  puts $file_id "   set suff so"
 puts $file_id "}"
 puts $file_id ""
 puts $file_id "if { !\[file exists \${cam_aux_dir}mom_source.\$suff\] } {"
  puts $file_id ""
  puts $file_id "   set __msg \"ERROR in \[info script\] :\\n\\"
  puts $file_id "             \\nShared library \\\"mom_source\\\" is not found in \${cam_aux_dir}.\""
  puts $file_id ""
  puts $file_id "   catch { SIM_mtd_reset }"
  puts $file_id "   MOM_abort \$__msg"
 puts $file_id "}"
 puts $file_id ""
 puts $file_id "if { !\[file exists \${cam_post_dir}${vnc_base}_tcl.txt\] } {"
  puts $file_id ""
  puts $file_id "   set __msg \"ERROR in \[info script\] :\\n\\"
  puts $file_id "             \\n\\\"${vnc_base}_tcl.txt\\\" is not found in \${cam_post_dir}.\""
  puts $file_id ""
  puts $file_id "   catch { SIM_mtd_reset }"
  puts $file_id "   MOM_abort \$__msg"
 puts $file_id "}"
 puts $file_id ""
 puts $file_id ""
 puts $file_id "catch {"
  puts $file_id "   MOM_run_user_function \${cam_aux_dir}mom_source.\$suff ufusr"
  puts $file_id "   MOM_decrypt_source \${cam_post_dir}${vnc_base}_tcl.txt"
 puts $file_id "}"
 puts $file_id ""
 puts $file_id ""
 puts $file_id "#----------------------------------------------"
 puts $file_id "# Validate correct version of vnc_base sourced."
 puts $file_id "#----------------------------------------------"
 puts $file_id "if { !\[info exists mom_sim_vnc_base_version\] || \\"
  puts $file_id "      \[string compare \"$vnc_version\" \$mom_sim_vnc_base_version\] > 0 } {"
  puts $file_id ""
  puts $file_id "   set __msg \"ERROR :\\n\\"
  puts $file_id "             \\nWrong version of \\\"${vnc_base}_tcl.txt\\\" has been detected.\\"
  puts $file_id "             \\nCorrect version can be found in POSTBUILD directory.\\"
  puts $file_id "             \\nPlease copy it to your \${cam_post_dir} directory.\""
  puts $file_id ""
  puts $file_id "   catch { SIM_mtd_reset }"
  puts $file_id "   MOM_abort \$__msg"
 puts $file_id "}"
 puts $file_id ""
 puts $file_id ""
puts $file_id "} ;# vnc_base sourced"
puts $file_id ""
puts $file_id ""
puts $file_id ""
puts $file_id "#**************************************"
puts $file_id "# Activate PB built revPost as default"
puts $file_id "#**************************************"
puts $file_id "if { !\[info exists mom_sim_post_builder_rev_post\] } {"
 puts $file_id "   set mom_sim_post_builder_rev_post 1"
puts $file_id "}"
puts $file_id ""
puts $file_id "if { \$mom_sim_post_builder_rev_post } {"
 puts $file_id ""

#=======================================================================
puts $file_id "   proc MOM__util_print { line } {}"
 puts $file_id ""
 puts $file_id "   #============================================================="

#=======================================================================
puts $file_id "   proc  MOM_SIM_execute_nc_command { } {"
  puts $file_id "   #============================================================="
  puts $file_id "      PB_SIM_call PB_CMD_vnc__execute_nc_command"
 puts $file_id "   }"
puts $file_id "}"
puts $file_id ""
puts $file_id ""
puts $file_id "set sim_mtd_initialized 1"
puts $file_id ""
puts $file_id "} ;# if { \$sim_mtd_initialized == 0 }"
puts $file_id ""
puts $file_id ""
puts $file_id ""
puts $file_id "if { \[llength \[info commands \"PB_CMD_vnc__set_nc_definitions\"\]\] } {"
puts $file_id "   rename PB_CMD_vnc__set_nc_definitions \"\""
puts $file_id "}"
puts $file_id "if { \[llength \[info commands \"PB_CMD_vnc__sim_other_devices\"\]\] } {"
puts $file_id "   rename PB_CMD_vnc__sim_other_devices \"\""
puts $file_id "}"
puts $file_id "if { \[llength \[info commands \"PB_CMD_vnc__process_nc_block\"\]\] } {"
puts $file_id "   rename PB_CMD_vnc__process_nc_block \"\""
puts $file_id "}"
puts $file_id ""
puts $file_id ""
puts $file_id ""
}

#=======================================================================
proc PB_PB2VNC_set_other_code { cmd_blk} {
  global mom_sim_arr mom_sys_arr
  global post_object
  array set mom_sim_arr $Post::($post_object,mom_sim_var_list)
  set cmd_attr(0) $cmd_blk
  set cmd_attr(1) [list]
  lappend cmd_attr(1) "  global mom_sim_o_buffer"
  set oth_cod $mom_sim_arr(\$mom_sim_pre_com_list)
  lappend cmd_attr(1) ""
  lappend cmd_attr(1) "   set o_buff \$mom_sim_o_buffer"
  lappend cmd_attr(1) ""
  if { [string match "PB_CMD_vnc____process_nc_block" $cmd_blk] } {
   lappend cmd_attr(1) "  # Process legacy handlers"
   lappend cmd_attr(1) "  #"
   set cmd_name "PB_CMD_vnc__preprocess_nc_block"
   } else {
   lappend cmd_attr(1) "  # Inherit handlers from main VNC"
   lappend cmd_attr(1) "  #"
   set cmd_name "PB_CMD_vnc____process_nc_block"
  }
  lappend cmd_attr(1) "   if \{ \[llength \[info commands $cmd_name\]\] \} \{"
   lappend cmd_attr(1) "      set o_buff \[PB_SIM_call $cmd_name\]"
  lappend cmd_attr(1) "   \}"
  lappend cmd_attr(1) ""
  foreach item $oth_cod {
   if {[string first " " $item] >= 0} {
    set cmd_item [join [split $item] "_"]
    } else {
    set cmd_item $item
   }
   if 0 {
    lappend cmd_attr(1) "   if \{ \[string match \"\*$item\*\" \$o_buff\] \} \{"
     lappend cmd_attr(1) "      PB_SIM_call PB_CMD_vnc__$cmd_item"
    lappend cmd_attr(1) "   \}"
   }
   lappend cmd_attr(1) "   if { \[string length \[PB_SIM_call PB_CMD_vnc__$cmd_item\]\] == 0 } {"
    lappend cmd_attr(1) "return \"\""
   lappend cmd_attr(1) "   }"
   lappend cmd_attr(1) ""
  }
  lappend cmd_attr(1) "   set o_buff \$mom_sim_o_buffer"
  lappend cmd_attr(1) ""
  lappend cmd_attr(1) ""
  lappend cmd_attr(1) "return \$o_buff"
  PB_pps_CreateCommand cmd_attr cmd_obj
 }

#=======================================================================
proc __PB2VNC_WriteMomSIMVar { SIM_VAR_LIST CMD_ATTR args } {
  upvar $SIM_VAR_LIST sim_var_list
  upvar $CMD_ATTR     cmd_attr
  global mom_sim_arr
  if {[llength $args]} {
   set re_flag 1
   } else {
   set re_flag 0
  }
  foreach sim_var $sim_var_list {
   set var [string trimleft $sim_var "\$"]
   if {[info exists mom_sim_arr($sim_var)]} {
    set val [set mom_sim_arr($sim_var)]
    } else {
    set val ""
   }
   if {[string match "" $val]} {
    continue
   }
   if {[llength $val] > 1} {
    lappend cmd_attr(1) [format "%-52s  %s" "   set $var" "\[list $val\]"]
    } elseif {$re_flag == 1} {
    lappend cmd_attr(1) [format "%-52s  %s" "         set $var" \"$val\"]
    } else {
    lappend cmd_attr(1) [format "%-52s  %s" "   set $var" \"$val\"]
   }
  }
 }

#=======================================================================
proc PB_PB2VNC_set_map_def { cmd_blk } {
  global mom_sim_arr mom_sys_arr
  global post_object machType axisoption
  array set mom_sim_arr $Post::($post_object,mom_sim_var_list)
  set sim_array [array names mom_sim_arr]
  set cmd_attr(0) $cmd_blk
  set cmd_attr(1) [list]
  lappend cmd_attr(1) "   global mom_sim_num_machine_axes"
  lappend cmd_attr(1) "   global mom_sim_spindle_comp mom_sim_spindle_jct"
  lappend cmd_attr(1) "   global mom_sim_zcs_base mom_sim_mt_axis"
  lappend cmd_attr(1) "   global mom_sim_result mom_sim_result1"
  lappend cmd_attr(1) "   global mom_sim_reverse_4th_table mom_sim_4th_axis_has_limits"
  lappend cmd_attr(1) "   global mom_sim_reverse_5th_table mom_sim_5th_axis_has_limits"
  lappend cmd_attr(1) ""
  set isv_mac_common {"\$mom_sim_spindle_comp" "\$mom_sim_spindle_jct" "\$mom_sim_zcs_base"}
  if { [string match "Lathe" $machType] || [string match "3MT" $axisoption] } {
   set isv_mac_3thvar {"\$mom_sim_mt_axis(X)" "\$mom_sim_mt_axis(Z)"}
   } else {
   set isv_mac_3thvar {"\$mom_sim_mt_axis(X)" "\$mom_sim_mt_axis(Y)" "\$mom_sim_mt_axis(Z)"}
  }
  set isv_mac_4thvar {"\$mom_sim_mt_axis(4)" "\$mom_sim_reverse_4th_table" "\$mom_sim_4th_axis_has_limits"}
  set isv_mac_5thvar {"\$mom_sim_mt_axis(5)" "\$mom_sim_reverse_5th_table" "\$mom_sim_5th_axis_has_limits"}
  lappend cmd_attr(1) ""
  lappend cmd_attr(1) "  # Process legacy configuration, if any"
  lappend cmd_attr(1) "  #"
  lappend cmd_attr(1) "   PB_SIM_call PB_CMD_vnc____old_map_machine_tool_axes"
  lappend cmd_attr(1) ""
  lappend cmd_attr(1) ""
  lappend cmd_attr(1) "  #+++++++++++++++++++++++++++++++++++++++++++++++++++++++++++"
  lappend cmd_attr(1) "  #   Specify tool mounting Junction & its parent component."
  lappend cmd_attr(1) "  #"
  lappend cmd_attr(1) "  #   Mill : Tool mounting Junction & Spindle component"
  lappend cmd_attr(1) "  #   Turn : Tool mounting Junction & Turret component"
  lappend cmd_attr(1) "  #+++++++++++++++++++++++++++++++++++++++++++++++++++++++++++"
  lappend cmd_attr(1) ""
  __PB2VNC_WriteMomSIMVar isv_mac_common cmd_attr
  lappend cmd_attr(1) ""
  __PB2VNC_WriteMomSIMVar isv_mac_3thvar cmd_attr
  lappend cmd_attr(1) ""
  lappend cmd_attr(1) "   switch \$mom_sim_num_machine_axes \{"
   lappend cmd_attr(1) "      \"4\" \{"
    if {[info exists mom_sim_arr(\$mom_sim_mt_axis(4))]} {
     __PB2VNC_WriteMomSIMVar isv_mac_4thvar cmd_attr 1
     } else {
     lappend cmd_attr(1) [format "%-52s  %s" "         set mom_sim_mt_axis(4)" \"A\"]
     lappend cmd_attr(1) [format "%-52s  %s" "         set mom_sim_reverse_4th_table" 0]
     lappend cmd_attr(1) [format "%-52s  %s" "         set mom_sim_4th_axis_has_limits" 1]
    }
   lappend cmd_attr(1) "      \}"
   lappend cmd_attr(1) "      \"5\" \{"
    if {[info exists mom_sim_arr(\$mom_sim_mt_axis(5))]} {
     __PB2VNC_WriteMomSIMVar isv_mac_4thvar cmd_attr 1
     __PB2VNC_WriteMomSIMVar isv_mac_5thvar cmd_attr 1
     } else {
     lappend cmd_attr(1) [format "%-52s  %s" "         set mom_sim_mt_axis(4)" \"B\"]
     lappend cmd_attr(1) [format "%-52s  %s" "         set mom_sim_reverse_4th_table" 0]
     lappend cmd_attr(1) [format "%-52s  %s" "         set mom_sim_4th_axis_has_limits" 1]
     lappend cmd_attr(1) [format "%-52s  %s" "         set mom_sim_mt_axis(5)" \"C\"]
     lappend cmd_attr(1) [format "%-52s  %s" "         set mom_sim_reverse_5th_table" 0]
     lappend cmd_attr(1) [format "%-52s  %s" "         set mom_sim_5th_axis_has_limits" 1]
    }
   lappend cmd_attr(1) "      \}"
  lappend cmd_attr(1) "   \}"
  lappend cmd_attr(1) ""
  lappend cmd_attr(1) ""
  if { [string match "Standalone" $mom_sys_arr(VNC_Mode)] } {
   set init_cmd_name "PB_CMD_vnc____init_machine_tool_axes"
   } else {
   set init_cmd_name "PB_CMD_vnc__init_machine_tool_axes"
  }
  lappend cmd_attr(1) "  # User can provide additional parameters for the machine tool."
  lappend cmd_attr(1) "  #"
  lappend cmd_attr(1) "   PB_SIM_call $init_cmd_name"
  lappend cmd_attr(1) ""
  lappend cmd_attr(1) ""
  lappend cmd_attr(1) "  # For this machine that all physical axes participate in executing a motion."
  lappend cmd_attr(1) "  # Include all logical names for axes."
  lappend cmd_attr(1) "  #"
  lappend cmd_attr(1) "   set axes_config_list \[list\]"
  lappend cmd_attr(1) "   set rotary_axes_list \[list\]"
  lappend cmd_attr(1) ""
  lappend cmd_attr(1) "   PB_SIM_call SIM_ask_nc_axes_of_mtool"
  lappend cmd_attr(1) ""
  set linear_axis_list [list X Y Z]
  foreach axis { X Y Z 4 5 } {
   lappend cmd_attr(1) "   if \{ \[info exists mom_sim_mt_axis($axis)\] \} \{ "
    lappend cmd_attr(1) "      if \{ \[lsearch \$mom_sim_result1 \"\$mom_sim_mt_axis\($axis\)\"\] >= 0 \} \{"
     if {[lsearch $linear_axis_list $axis] >= 0} {
      lappend cmd_attr(1) "         lappend axes_config_list \$mom_sim_mt_axis($axis)"
      } else {
      lappend cmd_attr(1) "         lappend rotary_axes_list \$mom_sim_mt_axis($axis)"
     }
    lappend cmd_attr(1) "      \}"
   lappend cmd_attr(1) "   \}"
  }
  lappend cmd_attr(1) ""
  lappend cmd_attr(1) "   PB_SIM_call SIM_set_linear_axes_config \[concat \$axes_config_list\]"
  lappend cmd_attr(1) ""
  lappend cmd_attr(1) "   if \{ \[llength \$rotary_axes_list\] > 0 \} \{"
   lappend cmd_attr(1) "      PB_SIM_call SIM_set_rotary_axes_config \[concat \$rotary_axes_list\]"
  lappend cmd_attr(1) "   \}"
  PB_pps_CreateCommand cmd_attr cmd_obj
  PB_int_UpdateCommandAdd cmd_obj
 }

#=======================================================================
proc PB_PB2VNC_set_vnc_def { cmd_blk } {
  global mom_sim_arr mom_sys_arr
  global post_object gPB
  set value_set_list [list]
  set var_arr_list [list]
  set single_var_list [list]
  set cmd_attr(0) $cmd_blk
  set cmd_attr(1) [list]
  array set mom_sim_arr $Post::($post_object,mom_sim_var_list)
  if { [string match "PB_CMD_vnc__set_nc_definitions" $cmd_blk] } {
   lappend cmd_attr(1) ""
   lappend cmd_attr(1) "   if \{ \[llength \[info commands PB_CMD_vnc__old_set_nc_definitions\]\] \} \{"
    lappend cmd_attr(1) "     # Process legacy definitions"
    lappend cmd_attr(1) "      PB_SIM_call PB_CMD_vnc__old_set_nc_definitions"
    lappend cmd_attr(1) "   \} else \{"
    lappend cmd_attr(1) "     # Inherit definitions from main VNC"
    lappend cmd_attr(1) "      PB_SIM_call PB_CMD_vnc____set_nc_definitions"
   lappend cmd_attr(1) "   \}"
   lappend cmd_attr(1) ""
   PB_pps_CreateCommand cmd_attr cmd_obj
   PB_int_UpdateCommandAdd cmd_obj
   return
  }
  set glob_var_list {"\$mom_sim_prog_rewind_stop_code" "\$mom_sim_control_var_leader"  \
   "\$mom_sim_control_equal_sign" "\$mom_sim_incr_linear_addrs"  \
   "\$mom_sim_rapid_dogleg" "\$mom_sim_output_vnc_msg"  \
   "\$mom_sim_pre_com_list" \
   "\$mom_sim_machine_zero_offsets" "\$mom_sim_wcs_offsets"  \
  "\$mom_sim_tool_data"}
  foreach glob $glob_var_list {
   set var [string trimleft $glob "\$"]
   lappend cmd_attr(1) "   global $var"
  }
  lappend cmd_attr(1) ""
  lappend cmd_attr(1) ""
  lappend cmd_attr(1) "   if \{ \[llength \[info commands PB_CMD_vnc____old_set_nc_definitions\]\] \} \{"
   lappend cmd_attr(1) "      PB_SIM_call PB_CMD_vnc____old_set_nc_definitions"
  lappend cmd_attr(1) "   \}"
  lappend cmd_attr(1) ""
  lappend cmd_attr(1) "   PB_SIM_call PB_CMD_vnc____init_nc_definitions"
  lappend cmd_attr(1) ""
  lappend cmd_attr(1) ""
  set non_arr_list $glob_var_list
  set ind [lsearch $non_arr_list "\$mom_sim_wcs_offsets"]
  set non_arr_list [lreplace $non_arr_list $ind $ind]
  set ind [lsearch $non_arr_list "\$mom_sim_tool_data"]
  set non_arr_list [lreplace $non_arr_list $ind $ind]
  __PB2VNC_WriteMomSIMVar non_arr_list cmd_attr
  lappend cmd_attr(1) ""
  set wcs_var_list [list]
  if { [info exists mom_sim_arr(\$mom_sim_wcsnum_list)] } {
   set mom_sim_arr(\$mom_sim_wcsnum_list) [lsort -dictionary $mom_sim_arr(\$mom_sim_wcsnum_list)]
   foreach wcs $mom_sim_arr(\$mom_sim_wcsnum_list) {
    lappend wcs_var_list "\$mom_sim_wcs_offsets($wcs)"
   }
  }
  __PB2VNC_WriteMomSIMVar wcs_var_list cmd_attr
  lappend cmd_attr(1) ""
  set tool_var_list [list]
  set tool_arr_names [array names mom_sim_arr]
  foreach var $tool_arr_names {
   if {[string match "\$mom_sim_tool_data*" $var]} {
    lappend tool_var_list "$var"
   }
  }
  set tool_var_list [lsort -dictionary $tool_var_list]
  __PB2VNC_WriteMomSIMVar tool_var_list cmd_attr
  lappend cmd_attr(1) ""
  lappend cmd_attr(1) "   global mom_sim_nc_register"
  lappend cmd_attr(1) ""
  if { [info exists mom_sim_arr(\$mom_sim_spindle_mode)] } {
   lappend cmd_attr(1) "[format "%-52s  %s" "   set mom_sim_nc_register\(SPINDLE_MODE\)"  \"$mom_sim_arr(\$mom_sim_spindle_mode)\"]"
  }
  if {[info exists mom_sim_arr(\$mom_sim_feed_mode)]} {
   lappend cmd_attr(1) "[format "%-52s  %s" "   set mom_sim_nc_register\(FEED_MODE\)"  \"$mom_sim_arr(\$mom_sim_feed_mode)\"]"
  }
  lappend cmd_attr(1) "[format "%-52s  %s" "   set mom_sim_nc_register\(MOTION\)"  \"$mom_sim_arr(\$mom_sim_initial_motion)\"]"
  lappend cmd_attr(1) "[format "%-52s  %s" "   set mom_sim_nc_register\(INPUT\)"  \"$mom_sim_arr(\$mom_sim_input_mode)\"]"
  lappend cmd_attr(1) "[format "%-52s  %s" "   set mom_sim_nc_register\(DEF_INPUT\)"  \"$mom_sim_arr(\$mom_sim_input_mode)\"]"
  lappend cmd_attr(1) "[format "%-52s  %s" "   set mom_sim_nc_register\(SPINDLE_DIRECTION\)"  \"$mom_sim_arr(\$mom_sim_spindle_direction)\"]"
  global gpb_addr_var
  set add_name "G"
  set leader $gpb_addr_var($add_name,leader_name)
  lappend cmd_attr(1) ""
  lappend cmd_attr(1) "   global mom_sim_nc_func"
  lappend cmd_attr(1) ""
  lappend cmd_attr(1) "[format "%-52s  %s" "   set mom_sim_nc_func\(RETURN_HOME_P\)"  \"$leader$mom_sim_arr(\$mom_sim_return_home)\"]"
  lappend cmd_attr(1) "[format "%-52s  %s" "   set mom_sim_nc_func\(FROM_HOME\)"  \"$leader$mom_sim_arr(\$mom_sim_from_home)\"]"
  lappend cmd_attr(1) "[format "%-52s  %s" "   set mom_sim_nc_func\(LOCAL_CS_SET\)"  \"$leader$mom_sim_arr(\$mom_sim_local_wcs)\"]"
  lappend cmd_attr(1) "[format "%-52s  %s" "   set mom_sim_nc_func\(MACH_CS_MOVE\)"  \"$leader$mom_sim_arr(\$mom_sim_mach_cs)\"]"
  if {[info exists mom_sim_arr(\$mom_sim_wcsnum_list)]} {
   set mom_sim_arr(\$mom_sim_wcsnum_list) [lsort -dictionary $mom_sim_arr(\$mom_sim_wcsnum_list)]
   foreach num $mom_sim_arr(\$mom_sim_wcsnum_list) {
    if { [info exists mom_sim_arr(\$mom_sim_wcs_$num)] && $num > 0 } {
     lappend cmd_attr(1) "[format "%-52s  %s" "   set mom_sim_nc_func\(WORK_CS_$num\)"  \"$leader$mom_sim_arr(\$mom_sim_wcs_$num)\"]"
    }
   }
  }
  PB_pps_CreateCommand cmd_attr cmd_obj
  PB_int_UpdateCommandAdd cmd_obj
 }

#=======================================================================
proc PB_PB2VNC_write_nc_defs { FILE_ID } {
  upvar $FILE_ID file_id
  puts $file_id "#============================================================="

#=======================================================================
puts $file_id "proc VNC_load_post_definitions { } {"
  puts $file_id "#============================================================="
  puts $file_id "  global mom_sim_control_out mom_sim_control_in"
  puts $file_id "  global mom_sim_word_separator mom_sim_word_separator_len"
  puts $file_id "  global mom_sim_end_of_block mom_sim_end_of_block_len"
  puts $file_id "  global mom_sim_opskip_block_leader"
  puts $file_id "  global mom_sim_home_pos"
  puts $file_id "  global mom_sim_address"
  puts $file_id "  global mom_sim_format"
  puts $file_id "  global mom_sim_wcs_offsets"
  puts $file_id "  global mom_sim_nc_register"
  puts $file_id "  global mom_sim_nc_func"
  puts $file_id "  global mom_sim_circular_vector"
  puts $file_id "  global mom_sim_arc_output_mode"
  puts $file_id "  global mom_sim_machine_type"
  puts $file_id "  global mom_sim_num_machine_axes"
  puts $file_id "  global mom_sim_advanced_kinematic_jct"
  puts $file_id "  global mom_sim_4th_axis_plane mom_sim_5th_axis_plane"
  puts $file_id "  global mom_sim_reverse_4th_table mom_sim_reverse_5th_table"
  puts $file_id "  global mom_sim_cycle_mode"
  puts $file_id "  global mom_sim_x_double mom_sim_i_double"
  puts $file_id "  global mom_sim_y_double mom_sim_j_double"
  puts $file_id "  global mom_sim_x_factor mom_sim_y_factor mom_sim_z_factor"
  puts $file_id "  global mom_sim_i_factor mom_sim_j_factor mom_sim_k_factor"
  puts $file_id "  global mom_sim_output_unit"
  puts $file_id "  global mom_sim_cycle_feed_to_addr"
  puts $file_id "  global mom_sim_pivot_distance"
  puts $file_id "  global mom_sim_4th_axis_angle_offset mom_sim_5th_axis_angle_offset"
  puts $file_id "  global mom_sim_4th_axis_direction mom_sim_5th_axis_direction"
  puts $file_id "  global mom_sim_4th_axis_max_limit mom_sim_5th_axis_max_limit"
  puts $file_id "  global mom_sim_4th_axis_min_limit mom_sim_5th_axis_min_limit"
  puts $file_id "  global mom_sim_output_reference_method"
  puts $file_id "  global mom_sim_rapid_feed_rate"
  puts $file_id "  global mom_sim_4th_axis_has_limits mom_sim_5th_axis_has_limits"
  puts $file_id "  global mom_sim_max_dpm mom_sim_min_dpm"
  puts $file_id "  global mom_sim_max_fpm mom_sim_min_fpm"
  puts $file_id "  global mom_sim_max_fpr mom_sim_min_fpr"
  puts $file_id "  global mom_sim_max_frn mom_sim_min_frn"
  puts $file_id "  global mom_sim_cycle_feed_mode"
  puts $file_id "  global mom_sim_contour_feed_mode"
  puts $file_id "  global mom_sim_rapid_feed_mode"
  puts $file_id "  global mom_sim_feed_param"
  puts $file_id ""
  puts $file_id "  global mom_sim_PI mom_sim_csys_set"
  puts $file_id "  global mom_sim_vnc_msg_prefix"
  puts $file_id ""
  puts $file_id ""
  puts $file_id "   set mom_sim_vnc_msg_prefix                         \"VNC_MSG::\""
  puts $file_id ""
  puts $file_id "   set mom_sim_PI                                     \[expr acos(-1.0)\]"
  puts $file_id ""
  puts $file_id "   if { !\[info exists mom_sim_csys_set\] } {"
   puts $file_id "      set mom_sim_csys_set                            0"
  puts $file_id "   }"
  puts $file_id ""
  puts $file_id ""
  PB_PB2VNC_write_misc      file_id
  PB_PB2VNC_write_addresses file_id
  PB_PB2VNC_write_formats   file_id
 puts $file_id "}"
}

#=======================================================================
proc PB_PB2VNC_write_addresses { FILE_ID } {
  upvar $FILE_ID file_id
  global post_object
  array set mom_sys_var $Post::($post_object,mom_sys_var_list)
  array set mom_sim_var $Post::($post_object,mom_sim_var_list)
  set add_obj_list $Post::($post_object,add_obj_list)
  foreach add_obj $add_obj_list {
   set name $address::($add_obj,add_name)
   set val $address::($add_obj,add_leader)
   set len [string length $val]
   set val [PB_output_DoubleEscapeSpecialControlChar $val]
   puts $file_id "   set [format "%-45s  %s" \
   "mom_sim_address($name,leader)" \"$val\"]"
   puts $file_id "   set [format "%-45s  %s" \
   "mom_sim_address($name,leader_len)" \"$len\"]"
   set val $address::($add_obj,add_trailer)
   set len [string length $val]
   set val [PB_output_EscapeSpecialChars_for_VNC $val]
   puts $file_id "   set [format "%-45s  %s" \
   "mom_sim_address($name,trailer)" \"$val\"]"
   puts $file_id "   set [format "%-45s  %s" \
   "mom_sim_address($name,trailer_len)" \"$len\"]"
   set val $address::($add_obj,add_force_status)
   puts $file_id "   set [format "%-45s  %s" \
   "mom_sim_address($name,modal)" \"$val\"]"
   set fmt $address::($add_obj,add_format)
   set val $format::($fmt,for_name)
   puts $file_id "   set [format "%-45s  %s" \
   "mom_sim_address($name,format)" \"$val\"]"
   puts $file_id ""
   switch $name {
    "G_motion" {
     set mom_var_list {\$mom_sys_rapid_code         \
      \$mom_sys_linear_code        \
      \$mom_sys_circle_code(CLW\)  \
      \$mom_sys_circle_code(CCLW\) \
      \$mom_sys_cycle_drill_code   \
      \$mom_sys_cycle_drill_dwell_code \
      \$mom_sys_cycle_drill_deep_code \
      \$mom_sys_cycle_drill_break_chip_code \
      \$mom_sys_cycle_tap_code \
      \$mom_sys_cycle_bore_code \
      \$mom_sys_cycle_bore_drag_code \
      \$mom_sys_cycle_bore_no_drag_code \
      \$mom_sys_cycle_bore_back_code \
      \$mom_sys_cycle_bore_manual_code \
      \$mom_sys_cycle_bore_dwell_code \
      \$mom_sys_cycle_bore_manual_dwell_code \
      \$mom_sys_cycle_start_code \
      \$mom_sys_cycle_off \
     }
     set mom_lbl_list {MOTION_RAPID \
      MOTION_LINEAR \
      MOTION_CIRCULAR_CLW \
      MOTION_CIRCULAR_CCLW \
      CYCLE_DRILL \
      CYCLE_DRILL_DWELL \
      CYCLE_DRILL_DEEP \
      CYCLE_DRILL_BREAK_CHIP \
      CYCLE_TAP \
      CYCLE_BORE \
      CYCLE_BORE_DRAG \
      CYCLE_BORE_NO_DRAG \
      CYCLE_BORE_BACK \
      CYCLE_BORE_MANUAL \
      CYCLE_BORE_DWELL \
      CYCLE_BORE_MANUAL_DWELL \
      CYCLE_START \
      CYCLE_OFF \
     }
     __PB2VNC_nc_func file_id $add_obj $mom_var_list $mom_lbl_list mom_sys_var
    }
    "G_cutcom" {
     set mom_var_list {\$mom_sys_cutcom_code(LEFT\) \
      \$mom_sys_cutcom_code(RIGHT\) \
      \$mom_sys_cutcom_code(OFF\) \
     }
     set mom_lbl_list {CUTCOM_LEFT \
      CUTCOM_RIGHT \
      CUTCOM_OFF \
     }
     __PB2VNC_nc_func file_id $add_obj $mom_var_list $mom_lbl_list mom_sys_var
    }
    "G_adjust" {
     set mom_var_list {\$mom_sys_adjust_code \
      \$mom_sys_adjust_code_minus \
      \$mom_sys_adjust_cancel_code \
     }
     set mom_lbl_list {TL_ADJUST_PLUS \
      TL_ADJUST_MINUS \
      TL_ADJUST_CANCEL \
     }
     __PB2VNC_nc_func file_id $add_obj $mom_var_list $mom_lbl_list mom_sys_var
    }
    "G_plane" {
     set mom_var_list {\$mom_sys_cutcom_plane_code(XY\) \
      \$mom_sys_cutcom_plane_code(ZX\) \
      \$mom_sys_cutcom_plane_code(YZ\) \
     }
     set mom_lbl_list {PLANE_XY \
      PLANE_ZX \
      PLANE_YZ \
     }
     __PB2VNC_nc_func file_id $add_obj $mom_var_list $mom_lbl_list mom_sys_var
    }
    "G_mode" {
     set mom_var_list {\$mom_sys_output_code(ABSOLUTE\) \
      \$mom_sys_output_code(INCREMENTAL\) \
     }
     set mom_lbl_list {INPUT_ABS \
      INPUT_INC \
     }
     __PB2VNC_nc_func file_id $add_obj $mom_var_list $mom_lbl_list mom_sys_var
    }
    "G_return" {
     set mom_var_list {\$mom_sys_cycle_ret_code(AUTO\) \
      \$mom_sys_cycle_ret_code(MANUAL\) \
     }
     set mom_lbl_list {CYCLE_RETURN_AUTO \
      CYCLE_RETURN_MANUAL \
     }
     __PB2VNC_nc_func file_id $add_obj $mom_var_list $mom_lbl_list mom_sys_var
    }
    "G_feed" {
     set mom_var_list {\$mom_sys_feed_rate_mode_code(IPM\) \
      \$mom_sys_feed_rate_mode_code(IPR\) \
      \$mom_sys_feed_rate_mode_code(MMPM\) \
      \$mom_sys_feed_rate_mode_code(MMPR\) \
      \$mom_sys_feed_rate_mode_code(FRN\) \
     }
     set mom_lbl_list {FEED_IPM \
      FEED_IPR \
      FEED_MMPM \
      FEED_MMPR \
      FEED_FRN \
     }
     if { ![info exists mom_sys_var(\$mom_sys_feed_rate_mode_code(IPM))] } {
      if [info exists mom_sys_var(\$mom_sys_feed_rate_mode_code(MMPM))] {
       set mom_sys_var(\$mom_sys_feed_rate_mode_code(IPM)) \
       $mom_sys_var(\$mom_sys_feed_rate_mode_code(MMPM\))
       } else {
       set mom_sys_var(\$mom_sys_feed_rate_mode_code(IPM)) 98
      }
     }
     if { ![info exists mom_sys_var(\$mom_sys_feed_rate_mode_code(IPR))] } {
      if [info exists mom_sys_var(\$mom_sys_feed_rate_mode_code(MMPR))] {
       set mom_sys_var(\$mom_sys_feed_rate_mode_code(IPR)) \
       $mom_sys_var(\$mom_sys_feed_rate_mode_code(MMPR\))
       } else {
       set mom_sys_var(\$mom_sys_feed_rate_mode_code(IPR)) 99
      }
     }
     if { ![info exists mom_sys_var(\$mom_sys_feed_rate_mode_code(MMPM))] } {
      if [info exists mom_sys_var(\$mom_sys_feed_rate_mode_code(IPM))] {
       set mom_sys_var(\$mom_sys_feed_rate_mode_code(MMPM)) \
       $mom_sys_var(\$mom_sys_feed_rate_mode_code(IPM\))
       } else {
       set mom_sys_var(\$mom_sys_feed_rate_mode_code(MMPM)) 98
      }
     }
     if { ![info exists mom_sys_var(\$mom_sys_feed_rate_mode_code(MMPR))] } {
      if [info exists mom_sys_var(\$mom_sys_feed_rate_mode_code(IPR))] {
       set mom_sys_var(\$mom_sys_feed_rate_mode_code(MMPR)) \
       $mom_sys_var(\$mom_sys_feed_rate_mode_code(IPR\))
       } else {
       set mom_sys_var(\$mom_sys_feed_rate_mode_code(MMPR)) 99
      }
     }
     __PB2VNC_nc_func file_id $add_obj $mom_var_list $mom_lbl_list mom_sys_var
    }
    "G_spin" {
     set mom_var_list {\$mom_sys_spindle_mode_code(SFM\) \
      \$mom_sys_spindle_mode_code(SMM\) \
      \$mom_sys_spindle_mode_code(RPM\) \
     }
     set mom_lbl_list {SPEED_SFM \
      SPEED_SMM \
      SPEED_RPM \
     }
     if { ![info exists mom_sys_var(\$mom_sys_spindle_mode_code(SFM))] } {
      if [info exists mom_sys_var(\$mom_sys_spindle_mode_code(SMM))] {
       set mom_sys_var(\$mom_sys_spindle_mode_code(SFM)) \
       $mom_sys_var(\$mom_sys_spindle_mode_code(SMM\))
       } else {
       set mom_sys_var(\$mom_sys_spindle_mode_code(SFM)) 96
      }
     }
     if { ![info exists mom_sys_var(\$mom_sys_spindle_mode_code(SMM))] } {
      if [info exists mom_sys_var(\$mom_sys_spindle_mode_code(SFM))] {
       set mom_sys_var(\$mom_sys_spindle_mode_code(SMM)) \
       $mom_sys_var(\$mom_sys_spindle_mode_code(SFM\))
       } else {
       set mom_sys_var(\$mom_sys_spindle_mode_code(SMM)) 96
      }
     }
     __PB2VNC_nc_func file_id $add_obj $mom_var_list $mom_lbl_list mom_sys_var
    }
    "G" {
     set mom_var_list {\$mom_sys_delay_code(SECONDS\) \
      \$mom_sys_delay_code(REVOLUTIONS\) \
      \$mom_sys_reset_code \
      \$mom_sys_return_code \
      \$mom_sys_unit_code(IN\) \
      \$mom_sys_unit_code(MM\) \
     }
     set mom_lbl_list {DELAY_SEC \
      DELAY_REV \
      WORK_CS_RESET \
      RETURN_HOME \
      UNIT_IN \
      UNIT_MM \
     }
     __PB2VNC_nc_func file_id $add_obj $mom_var_list $mom_lbl_list mom_sys_var
    }
    "M_spindle" {
     set mom_var_list {\$mom_sys_spindle_direction_code(CLW\) \
      \$mom_sys_spindle_direction_code(CCLW\) \
      \$mom_sys_spindle_direction_code(OFF\) \
     }
     set mom_lbl_list {SPINDLE_CLW \
      SPINDLE_CCLW \
      SPINDLE_OFF \
     }
     __PB2VNC_nc_func file_id $add_obj $mom_var_list $mom_lbl_list mom_sys_var
    }
    "M_coolant" {
     set mom_var_list {\$mom_sys_coolant_code(ON\)    \
      \$mom_sys_coolant_code(FLOOD\) \
      \$mom_sys_coolant_code(MIST\)  \
      \$mom_sys_coolant_code(THRU\)  \
      \$mom_sys_coolant_code(TAP\)   \
      \$mom_sys_coolant_code(OFF\)   \
     }
     set mom_lbl_list {COOLANT_ON    \
      COOLANT_FLOOD \
      COOLANT_MIST  \
      COOLANT_THRU  \
      COOLANT_TAP   \
      COOLANT_OFF   \
     }
     __PB2VNC_nc_func file_id $add_obj $mom_var_list $mom_lbl_list mom_sys_var
    }
    "M" {
     set mom_var_list {\$mom_sys_program_stop_code \
      \$mom_sys_optional_stop_code \
      \$mom_sys_end_of_program_code \
      \$mom_sys_tool_change_code \
      \$mom_sys_rewind_code \
     }
     set mom_lbl_list {PROG_STOP \
      PROG_OPSTOP \
      PROG_END \
      TOOL_CHANGE \
      PROG_STOP_REWIND \
     }
     __PB2VNC_nc_func file_id $add_obj $mom_var_list $mom_lbl_list mom_sys_var
    }
   }
  }
 }

#=======================================================================
proc __PB2VNC_nc_func { FILE_ID add_obj mom_var_list mom_lbl_list MOM_SYS_VAR } {
  upvar $FILE_ID file_id
  upvar $MOM_SYS_VAR mom_sys_var
  global post_object
  set leader  [PB_output_EscapeSpecialChars_for_VNC $address::($add_obj,add_leader)]
  set trailer [PB_output_EscapeSpecialChars_for_VNC $address::($add_obj,add_trailer)]
  set var [lindex $mom_var_list 0]
  foreach mom_var $mom_var_list mom_lbl $mom_lbl_list {
   if [info exists mom_sys_var($mom_var)] {
    set elem_text $mom_sys_var($mom_var)
    PB_int_ApplyFormatAppText add_obj elem_text
    puts $file_id [format "%-52s  %s" \
    "   set mom_sim_nc_func($mom_lbl)" \"$leader$elem_text$trailer\"]
   }
  }
  puts $file_id ""
 }

#=======================================================================
proc PB_PB2VNC_write_formats { FILE_ID } {
  upvar $FILE_ID file_id
  global post_object
  set fmt_obj_list $Post::($post_object,fmt_obj_list)
  foreach fmt_obj $fmt_obj_list {
   set name $format::($fmt_obj,for_name)
   set val $format::($fmt_obj,for_dtype)
   puts $file_id "   set [format "%-45s  %s" \
   "mom_sim_format($name,type)" \"$val\"]"
   set val $format::($fmt_obj,for_leadplus)
   puts $file_id "   set [format "%-45s  %s" \
   "mom_sim_format($name,plus)" \"$val\"]"
   set val $format::($fmt_obj,for_leadzero)
   puts $file_id "   set [format "%-45s  %s" \
   "mom_sim_format($name,lead_zero)" \"$val\"]"
   set val $format::($fmt_obj,for_valfpart)
   puts $file_id "   set [format "%-45s  %s" \
   "mom_sim_format($name,integer)" \"$val\"]"
   set val $format::($fmt_obj,for_outdecimal)
   puts $file_id "   set [format "%-45s  %s" \
   "mom_sim_format($name,decimal)" \"$val\"]"
   set val $format::($fmt_obj,for_valspart)
   puts $file_id "   set [format "%-45s  %s" \
   "mom_sim_format($name,fraction)" \"$val\"]"
   set val $format::($fmt_obj,for_trailzero)
   puts $file_id "   set [format "%-45s  %s" \
   "mom_sim_format($name,trail_zero)" \"$val\"]"
   puts $file_id ""
  }
 }

#=======================================================================
proc PB_PB2VNC_write_misc { FILE_ID } {
  upvar $FILE_ID file_id
  global post_object
  array set mom_sys_var $Post::($post_object,mom_sys_var_list)
  array set mom_kin_var $Post::($post_object,mom_kin_var_list)
  puts $file_id "   set [format "%-45s  %s" "mom_sim_control_out" \
  \"[PB_output_EscapeSpecialChars_for_VNC $mom_sys_var(Comment_Start)]\"]"
  puts $file_id "   set [format "%-45s  %s" "mom_sim_control_in" \
  \"[PB_output_EscapeSpecialChars_for_VNC $mom_sys_var(Comment_End)]\"]"
  puts $file_id ""
  set val $mom_sys_var(Word_Seperator)
  puts $file_id [format "%-52s  %s" "   set mom_sim_word_separator" \"$val\"]
  puts $file_id [format "%-52s  %s" "   set mom_sim_word_separator_len" \"[string length $val]\"]
  puts $file_id ""
  set val $mom_sys_var(End_of_Block)
  puts $file_id [format "%-52s  %s" "   set mom_sim_end_of_block" \"$val\"]
  puts $file_id [format "%-52s  %s" "   set mom_sim_end_of_block_len" \"[string length $val]\"]
  puts $file_id ""
  __PB2VNC_WriteMomVar mom_sys_var "\$mom_sys_opskip_block_leader"  s  $file_id
  if { $mom_sys_var(\$is_linked_post) == 1 } {
   puts $file_id ""
   puts $file_id "  #========================="
   puts $file_id "  # Linked posts definition"
   puts $file_id "  #========================="
   puts $file_id "   global mom_sim_linked_post_name"
   set linked_posts [ UI_PB_lnk_SetLinkedPostsForHList ]
   puts $file_id ""
   set max_len 52
   foreach link $linked_posts {
    set head [lindex $link 1]
    set len [expr 32 + [string length $head] + 1]
    if { $len > $max_len } { set max_len $len }
   }
   foreach link $linked_posts {
    set head [lindex $link 1]
    set post [lindex $link 2]
    if [string match "this_post" $post] {
     PB_int_ReadPostOutputFiles dir pui_file def_file tcl_file
     set post [file rootname $tcl_file]
    }
    puts $file_id [format "%-${max_len}s  %s" "   set mom_sim_linked_post_name($head)" \"$post\"]
   }
  }
  puts $file_id ""
  __PB2VNC_WriteMomVar mom_sys_var "\$mom_sys_home_pos(0\)"         r  $file_id
  __PB2VNC_WriteMomVar mom_sys_var "\$mom_sys_home_pos(1\)"         r  $file_id
  __PB2VNC_WriteMomVar mom_sys_var "\$mom_sys_home_pos(2\)"         r  $file_id
  puts $file_id ""
  __PB2VNC_WriteMomVar mom_sys_var "\$mom_sys_cir_vector"           s  $file_id  mom_sim_circular_vector
  __PB2VNC_WriteMomVar mom_kin_var "\$mom_kin_arc_output_mode"      s  $file_id
  __PB2VNC_WriteMomVar mom_kin_var "\$mom_kin_output_unit"          s  $file_id
  __PB2VNC_WriteMomVar mom_kin_var "\$mom_kin_rapid_feed_rate"      r  $file_id
  __PB2VNC_WriteMomVar mom_kin_var "\$mom_kin_machine_type"         s  $file_id
  set val $mom_kin_var(\$mom_kin_machine_type)
  if [string match "5*" $val] {
   set num_axes 5
   } elseif [string match "4*" $val] {
   set num_axes 4
   } elseif [string match "3_axis_mill_turn" $val] {
   set num_axes 4
   } else {
   set num_axes 3
  }
  puts $file_id [format "%-52s  %s" "   set mom_sim_num_machine_axes" \"$num_axes\"]
  puts $file_id ""
  puts $file_id "   if { \[info exists mom_sim_advanced_kinematic_jct\] } {"
   puts $file_id "      unset mom_sim_advanced_kinematic_jct"
  puts $file_id "   }"
  puts $file_id ""
  puts $file_id [format "%-52s  %s" "   set mom_sim_reverse_4th_table" \"0\"]
  puts $file_id [format "%-52s  %s" "   set mom_sim_reverse_5th_table" \"0\"]
  __PB2VNC_WriteMomVar mom_kin_var "\$mom_kin_4th_axis_plane"       s  $file_id
  __PB2VNC_WriteMomVar mom_kin_var "\$mom_kin_5th_axis_plane"       s  $file_id
  __PB2VNC_WriteMomVar mom_kin_var "\$mom_kin_pivot_gauge_offset"   r  $file_id  mom_sim_pivot_distance
  __PB2VNC_WriteMomVar mom_kin_var "\$mom_kin_4th_axis_zero"        r  $file_id  mom_sim_4th_axis_angle_offset
  __PB2VNC_WriteMomVar mom_kin_var "\$mom_kin_5th_axis_zero"        r  $file_id  mom_sim_5th_axis_angle_offset
  __PB2VNC_WriteMomVar mom_kin_var "\$mom_kin_4th_axis_direction" s $file_id
  __PB2VNC_WriteMomVar mom_kin_var "\$mom_kin_5th_axis_direction" s $file_id
  __PB2VNC_WriteMomVar mom_kin_var "\$mom_kin_4th_axis_min_limit" r $file_id
  __PB2VNC_WriteMomVar mom_kin_var "\$mom_kin_4th_axis_max_limit" r $file_id
  __PB2VNC_WriteMomVar mom_kin_var "\$mom_kin_5th_axis_min_limit" r $file_id
  __PB2VNC_WriteMomVar mom_kin_var "\$mom_kin_5th_axis_max_limit" r $file_id
  __PB2VNC_WriteMomVar mom_sys_var "\$mom_sys_4th_axis_has_limits" i $file_id
  __PB2VNC_WriteMomVar mom_sys_var "\$mom_sys_5th_axis_has_limits" i $file_id
  puts $file_id ""
  __PB2VNC_WriteMomVar mom_kin_var "\$mom_kin_max_dpm" r $file_id
  __PB2VNC_WriteMomVar mom_kin_var "\$mom_kin_max_fpm" r $file_id
  __PB2VNC_WriteMomVar mom_kin_var "\$mom_kin_max_fpr" r $file_id
  __PB2VNC_WriteMomVar mom_kin_var "\$mom_kin_max_frn" r $file_id
  __PB2VNC_WriteMomVar mom_kin_var "\$mom_kin_min_dpm" r $file_id
  __PB2VNC_WriteMomVar mom_kin_var "\$mom_kin_min_fpm" r $file_id
  __PB2VNC_WriteMomVar mom_kin_var "\$mom_kin_min_fpr" r $file_id
  __PB2VNC_WriteMomVar mom_kin_var "\$mom_kin_min_frn" r $file_id
  __PB2VNC_WriteMomVar mom_sys_var "\$mom_sys_cycle_feed_mode"                   s $file_id
  __PB2VNC_WriteMomVar mom_sys_var "\$mom_sys_contour_feed_mode(LINEAR\)"        s $file_id
  __PB2VNC_WriteMomVar mom_sys_var "\$mom_sys_contour_feed_mode(ROTARY\)"        s $file_id
  __PB2VNC_WriteMomVar mom_sys_var "\$mom_sys_contour_feed_mode(LINEAR_ROTARY\)" s $file_id
  __PB2VNC_WriteMomVar mom_sys_var "\$mom_sys_rapid_feed_mode(LINEAR\)"          s $file_id
  __PB2VNC_WriteMomVar mom_sys_var "\$mom_sys_rapid_feed_mode(ROTARY\)"          s $file_id
  __PB2VNC_WriteMomVar mom_sys_var "\$mom_sys_rapid_feed_mode(LINEAR_ROTARY\)"   s $file_id
  __PB2VNC_WriteMomVar mom_sys_var "\$mom_sys_feed_param(IPM,format\)"           s $file_id
  __PB2VNC_WriteMomVar mom_sys_var "\$mom_sys_feed_param(IPR,format\)"           s $file_id
  __PB2VNC_WriteMomVar mom_sys_var "\$mom_sys_feed_param(FRN,format\)"           s $file_id
  __PB2VNC_WriteMomVar mom_sys_var "\$mom_sys_feed_param(DPM,format\)"           s $file_id
  __PB2VNC_WriteMomVar mom_sys_var "\$mom_sys_feed_param(MMPM,format\)"          s $file_id
  __PB2VNC_WriteMomVar mom_sys_var "\$mom_sys_feed_param(MMPR,format\)"          s $file_id
  puts $file_id ""
  set val $mom_sys_var(\$cycle_rapto_opt)
  set cycle_rapto_opt $val
  set val $mom_sys_var(\$cycle_recto_opt)
  set cycle_recto_opt $val
  set cycle_fedto_addr " "
  set blk_obj_list $Post::($post_object,post_blk_list)
  set blk_name "post_cycle_set"
  set blk_obj -1
  PB_com_RetObjFrmName blk_name blk_obj_list blk_obj
  if { $blk_obj >= 0 } {
   block::readvalue $blk_obj blk_obj_attr
   foreach blk_elem $blk_obj_attr(2) {
    set add_obj $block_element::($blk_elem,elem_add_obj)
    set add_name $address::($add_obj,add_name)
    if [string match "Z" $add_name] {
     set elem_var $block_element::($blk_elem,elem_mom_variable)
     if [string match "*mom_cycle_feed_to_pos*" $elem_var] {
      set cycle_fedto_opt "Position"
      set cycle_fedto_addr "Z"
      } elseif [string match "*mom_cycle_feed_to*" $elem_var] {
      set cycle_fedto_opt "Distance"
      set cycle_fedto_addr "Z"
     }
    }
    if [string match "R" $add_name] {
     set elem_var $block_element::($blk_elem,elem_mom_variable)
     if [string match "*mom_cycle_rapid_to_pos*" $elem_var] {
      set cycle_rapto_opt "$cycle_rapto_opt - Position"
      } else {
      set cycle_rapto_opt "$cycle_rapto_opt - Distance"
     }
    }
    if [string match "K_cycle" $add_name] {
     set elem_var $block_element::($blk_elem,elem_mom_variable)
     if [string match "*mom_cycle_retract_to_pos*" $elem_var] {
      set cycle_recto_opt "$cycle_recto_opt - Position"
      } else {
      set cycle_recto_opt "$cycle_recto_opt - Distance"
     }
    }
   }
   if { ![info exists cycle_fedto_opt] } {
    foreach blk_elem $blk_obj_attr(2) {
     set add_obj $block_element::($blk_elem,elem_add_obj)
     set add_name $address::($add_obj,add_name)
     set elem_var $block_element::($blk_elem,elem_mom_variable)
     if [string match "*mom_cycle_feed_to_pos*" $elem_var] {
      set cycle_fedto_opt "Position"
      set cycle_fedto_addr "$add_name"
      } elseif [string match "*mom_cycle_feed_to*" $elem_var] {
      set cycle_fedto_opt "Distance"
      set cycle_fedto_addr "$add_name"
     }
    }
   }
  }
  if { ![info exists cycle_fedto_opt] } {
   set cycle_fedto_opt "Position"
   set cycle_fedto_addr "Z"
  }
  puts $file_id [format "%-52s  %s" "   set mom_sim_cycle_feed_to_addr"     \"$cycle_fedto_addr\"]
  puts $file_id [format "%-52s  %s" "   set mom_sim_cycle_mode(feed_to)"    \"$cycle_fedto_opt\"]
  puts $file_id [format "%-52s  %s" "   set mom_sim_cycle_mode(rapid_to)"   \"$cycle_rapto_opt\"]
  puts $file_id [format "%-52s  %s" "   set mom_sim_cycle_mode(retract_to)" \"$cycle_recto_opt\"]
  set val $mom_sys_var(\$cycle_start_blk)
  puts $file_id [format "%-52s  %s" "   set mom_sim_cycle_mode(start_block)" \"$val\"]
  puts $file_id ""
  if ![info exists mom_sys_var(\$mom_sys_lathe_x_double)] {
   set mom_sys_var(\$mom_sys_lathe_x_double) 1
  }
  __PB2VNC_WriteMomVar mom_sys_var "\$mom_sys_lathe_x_double"  i  $file_id  mom_sim_x_double
  if ![info exists mom_sys_var(\$mom_sys_lathe_i_double)] {
   set mom_sys_var(\$mom_sys_lathe_i_double) 1
  }
  __PB2VNC_WriteMomVar mom_sys_var "\$mom_sys_lathe_i_double"  i  $file_id  mom_sim_i_double
  if ![info exists mom_sys_var(\$mom_sys_lathe_y_double)] {
   set mom_sys_var(\$mom_sys_lathe_y_double) 1
  }
  __PB2VNC_WriteMomVar mom_sys_var "\$mom_sys_lathe_y_double"  i  $file_id  mom_sim_y_double
  if ![info exists mom_sys_var(\$mom_sys_lathe_j_double)] {
   set mom_sys_var(\$mom_sys_lathe_j_double) 1
  }
  __PB2VNC_WriteMomVar mom_sys_var "\$mom_sys_lathe_j_double"  i  $file_id  mom_sim_j_double
  if ![info exists mom_sys_var(\$mom_sys_lathe_x_factor)] {
   set mom_sys_var(\$mom_sys_lathe_x_factor) 1
  }
  __PB2VNC_WriteMomVar mom_sys_var "\$mom_sys_lathe_x_factor"  i  $file_id  mom_sim_x_factor
  if ![info exists mom_sys_var(\$mom_sys_lathe_y_factor)] {
   set mom_sys_var(\$mom_sys_lathe_y_factor) 1
  }
  __PB2VNC_WriteMomVar mom_sys_var "\$mom_sys_lathe_y_factor"  i  $file_id  mom_sim_y_factor
  if ![info exists mom_sys_var(\$mom_sys_lathe_z_factor)] {
   set mom_sys_var(\$mom_sys_lathe_z_factor) 1
  }
  __PB2VNC_WriteMomVar mom_sys_var "\$mom_sys_lathe_z_factor"  i  $file_id  mom_sim_z_factor
  if ![info exists mom_sys_var(\$mom_sys_lathe_i_factor)] {
   set mom_sys_var(\$mom_sys_lathe_i_factor) 1
  }
  __PB2VNC_WriteMomVar mom_sys_var "\$mom_sys_lathe_i_factor"  i  $file_id  mom_sim_i_factor
  if ![info exists mom_sys_var(\$mom_sys_lathe_j_factor)] {
   set mom_sys_var(\$mom_sys_lathe_j_factor) 1
  }
  __PB2VNC_WriteMomVar mom_sys_var "\$mom_sys_lathe_j_factor"  i  $file_id  mom_sim_j_factor
  if ![info exists mom_sys_var(\$mom_sys_lathe_k_factor)] {
   set mom_sys_var(\$mom_sys_lathe_k_factor) 1
  }
  __PB2VNC_WriteMomVar mom_sys_var "\$mom_sys_lathe_k_factor"  i  $file_id  mom_sim_k_factor
  puts $file_id ""
  if [info exists mom_sys_var(\$lathe_output_method)] {
   set val $mom_sys_var(\$lathe_output_method)
   } else {
   set val TOOL_TIP
  }
  puts $file_id [format "%-52s  %s" "   set mom_sim_output_reference_method" \"$val\"]
  puts $file_id ""
 }

#=======================================================================
proc __PB2VNC_WriteMomVar { MOM_VAR_ARR var type file_id args } {
  upvar $MOM_VAR_ARR mom_var_arr
  set val [__output_GetMomVal mom_var_arr "$var" $type]
  set sim_var ""
  if { [llength $args] > 0 } {
   set sim_var [string trim [lindex $args 0]]
  }
  if { $sim_var == "" } {
   set sim_var mom_sim_[string range $var 9 end]
  }
  puts $file_id [format "%-52s  %s" "   set $sim_var" \"$val\"]
 }

#=======================================================================
proc __output_GetMomVal { MOM_VAR_ARR var type args } {
  upvar $MOM_VAR_ARR mom_var_arr
  set val ""
  if [info exists mom_var_arr($var)] {
   set val $mom_var_arr($var)
   } else {
   if { $type == "s" } {
    set val " "
   }
  }
  switch $type {
   i {
    if { [string trim $val] == "" } {
     set val 0
    }
    set val [expr int($val)]
   }
   r {
    if { [string trim $val] == "" } {
     set val 0.0
    }
    set val [expr double($val)]
   }
  }
  return $val
 }

#=======================================================================
proc __output_CompactFile { src tgt } {
  set prev_end_char ""
  while {[eof $src] == 0} {
   set line [string trim [gets $src]]
   if {$line == ""} {
    continue
   }
   if {[string index $line 0] == "#"} {
    continue
   }
   if {[string match "*;#*" $line]} { ;# This is a trailing comment.
    set idx [string last "#" $line]
    if {$idx > -1} {
     set line [string range $line 0 [expr $idx - 2]]
    }
   }
   set end_idx [expr [string length $line] - 1]
   set end_char [string index $line $end_idx]
   if { $end_char == "\\" } {
    set strend [expr [string length $line] - 1]
    set line [string range $line 0 [expr $strend - 1]]
    } elseif { $end_char != "\{"  &&  $end_char != "\}" } {
    set line "${line}\; "
   }
   set start_char [string index $line 0]
   if { $start_char != "\{"  &&  $start_char != "\}" } {
    if [string match "\}" $prev_end_char] {
    set line "\; ${line}"
   }
  }
  set line "${line} "
  set prev_end_char $end_char
  puts -nonewline $tgt $line
 }
}
