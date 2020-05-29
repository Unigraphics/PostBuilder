if 1 {
} ;# End of Comments
UI_PB_AddPatchMsg "2007.0.0" "<04-11-12>  Fix error with MOM_first_tool handler"
UI_PB_AddPatchMsg "2006.5.0" "<05-04-10>  Call PB_VNC_pass_tool_data in MOM_machine_mode only when VNC is active."
UI_PB_AddPatchMsg "2002.5.1" "<09-25-06>  Prevent unmounting stationary tool in PB_CMD_vnc__tool_change"
UI_PB_AddPatchMsg "2002.5.1" "<08-28-06>  Revised VNC_ask_shared_library_suffix to support MacOS."
UI_PB_AddPatchMsg "2002.5.1" "<08-24-06>  Comment out rewind-stop-code definition for new VNC."
UI_PB_AddPatchMsg "2002.0.0" "<03-18-03>  Corrected PB_ROTARY_SIGN_SET for xzc/mill-turn posts."
UI_PB_AddPatchMsg "2002.0.0" "<03-20-03>  Excluded RETRACT for WEDM in MOM_before_motion."
set gPB(vnc_base_version) "7.5.0"
set gPB(val_fmt) "s" ;# to replace "-5s"

#=======================================================================
proc PB_output_CallDebugMsg { flag OUTPUT args } {
  if { [info exist ::gPB(PB_POST_DEBUG)] &&\
   [string length [string trim $::gPB(PB_POST_DEBUG)]] > 0 } {
   upvar $OUTPUT output
   if { [llength $args] == 0 } {
    set __trailer ""
    } else {
    set __trailer " [join $args]"
   }
   if [info exists output] {
    switch $flag {
     S { lappend output " $::gPB(PB_POST_DEBUG_command) START$__trailer" }
     E { lappend output " $::gPB(PB_POST_DEBUG_command) END$__trailer" }
     R { lappend output " $::gPB(PB_POST_DEBUG_command) RETURN$__trailer" }
     default {
      lappend output " $::gPB(PB_POST_DEBUG_command)$__trailer"
     }
    }
    } else {
    switch $flag {
     S { puts $OUTPUT   " $::gPB(PB_POST_DEBUG_command) START$__trailer" }
     E { puts $OUTPUT   " $::gPB(PB_POST_DEBUG_command) END$__trailer" }
     R { puts $OUTPUT   " $::gPB(PB_POST_DEBUG_command) RETURN$__trailer" }
     default {
      puts $OUTPUT   " $::gPB(PB_POST_DEBUG_command)$__trailer"
     }
    }
   }
  }
 }

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
   if { [string compare $address::($adr_obj,leader_var) ""] } \
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
  foreach block_obj $blk_obj_list \
  {
   set blk_name_arr($indx) $block::($block_obj,block_name)
   block::readvalue $block_obj blk_obj_attr
   UI_PB_debug_ForceMsg "*** block name == $blk_name_arr($indx)"
   set act_blk_elem_list ""
   set rap_flag 0
   foreach blk_elem $blk_obj_attr(2) \
   {
    set add_obj $block_element::($blk_elem,elem_add_obj)
    if { ![string compare $add_obj "Command"] || \
     ![string compare $add_obj "Comment"] || \
    ![string compare $add_obj "Macro"] } \
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
  [lindex $seq_obj_list 6] [lindex $seq_obj_list 7]
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
   default {}
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
   if { ![string compare $var "\$mom_sys_gcodes_per_block"] && \
   $mom_sys_var_arr(\$gcode_status) == 0 } \
   {
    continue
    } elseif { ![string compare $var "\$mom_sys_mcodes_per_block"] && \
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
   if { ![string compare $c "\""]  || \
    ![string compare $c "\\"]  || \
    ![string compare $c "\$"]  || \
    ![string compare $c "\#"]  || \
    ![string compare $c "\("]  || \
    ![string compare $c "\)"]  || \
    ![string compare $c "\["]  || \
    ![string compare $c "\]"]  || \
    ![string compare $c "\{"]  || \
     ![string compare $c "\}"] } {
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
   if { ![string compare $c "\""]  || \
    ![string compare $c "\\"]  || \
    ![string compare $c "\$"]  || \
    ![string compare $c "\#"]  || \
    ![string compare $c "\["]  || \
    ![string compare $c "\]"]  || \
    ![string compare $c "\{"]  || \
     ![string compare $c "\}"] } {
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
   if { ![string compare $c "\""]  || \
    ![string compare $c "\\"]  || \
    ![string compare $c "\#"]  || \
    ![string compare $c "\["]  || \
    ![string compare $c "\]"]  || \
    ![string compare $c "\{"]  || \
     ![string compare $c "\}"] } {
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
  set idx 0
  set list_name_arr($idx) "mom_sys_list_output"
  if { $ListingFile::($listfile_obj,listfile) } \
  {
   set list_val_arr($idx)  "ON"
   incr idx
   set list_name_arr($idx) "mom_sys_header_output"
   if { [string compare $list_blk_value ""] } {
    set list_val_arr($idx) "ON"
    } else {
    set list_val_arr($idx) "OFF"
   }
  } else \
  {
   set list_val_arr($idx)  "OFF"
   incr idx
   set list_name_arr($idx) "mom_sys_header_output"
   set list_val_arr($idx)  "OFF"
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
  incr idx
  set list_name_arr($idx) "mom_sys_list_file_rows"
  set list_val_arr($idx) $ListingFile::($listfile_obj,lines)
  incr idx
  set list_name_arr($idx) "mom_sys_list_file_columns"
  set list_val_arr($idx) $ListingFile::($listfile_obj,column)
  incr idx
  set list_name_arr($idx) "mom_sys_warning_output"
  if  { $ListingFile::($listfile_obj,warn) } \
  {
   set list_val_arr($idx)  "ON"
  } else \
  {
   set list_val_arr($idx)  "OFF"
  }
  incr idx
  set list_name_arr($idx) "mom_sys_warning_output_option"
  set list_val_arr($idx)  "$ListingFile::($listfile_obj,warn_opt)"
  incr idx
  set list_name_arr($idx) "mom_sys_group_output"
  if  { $ListingFile::($listfile_obj,group) } \
  {
   set list_val_arr($idx)  "ON"
  } else \
  {
   set list_val_arr($idx)  "OFF"
  }
  incr idx
  set list_name_arr($idx) "mom_sys_list_file_suffix"
  set list_val_arr($idx)  "$ListingFile::($listfile_obj,lpt_ext)"
  incr idx
  set list_name_arr($idx) "mom_sys_output_file_suffix"
  set list_val_arr($idx)  "$ListingFile::($listfile_obj,ncfile_ext)"
  PB_lfl_RetLfileBlock listfile_obj list_blk_value
  incr idx
  set list_name_arr($idx) "mom_sys_commentary_output"
  if { ![string compare $list_blk_value ""] } \
  {
   set list_val_arr($idx)  "OFF"
  } else \
  {
   set list_val_arr($idx)  "ON"
  }
  set elem_list { x y z 4axis 5axis feed speed }
  set active_elem_list ""
  foreach elem $elem_list \
  {
   if { $ListingFile::($listfile_obj,$elem) } \
   {
    lappend active_elem_list $elem
   }
  }
  incr idx
  set list_name_arr($idx) "mom_sys_commentary_list"
  set list_val_arr($idx)  "$active_elem_list"
  incr idx
  set list_name_arr($idx) "mom_sys_pb_link_var_mode"
  if { $ListingFile::($listfile_obj,link_var) } \
  {
   set list_val_arr($idx)  "ON"
  } else \
  {
   set list_val_arr($idx)  "OFF"
  }
  if 0 {
   if { $ListingFile::($listfile_obj,use_default_unit_fragment) } \
   {
    set list_name_arr(11) "mom_sys_use_default_unit_fragment"
    set list_val_arr(11)  "ON"
   } else \
   {
    set list_name_arr(11) "mom_sys_use_default_unit_fragment"
    set list_val_arr(11)  "OFF"
   }
   set list_name_arr(12) "mom_sys_alt_unit_post_name"
   set list_val_arr(12)  "$ListingFile::($listfile_obj,alt_unit_post_name)"
  }
  UI_PB_debug_ForceMsg "\nListing File options: [array get list_val_arr]\n"
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
  [lindex $seq_obj_list 4] [lindex $seq_obj_list 5]
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
proc PB_output_GetEvtObjAttr { EVT_NAME_ARR EVT_BLK_ARR UDC_NAME_LIST \
  EVT_OBJ_ARR } {
  upvar $EVT_NAME_ARR evt_name_list
  upvar $EVT_BLK_ARR evt_blk_arr
  upvar $UDC_NAME_LIST udc_name_list
  upvar $EVT_OBJ_ARR evt_obj_arr
  global post_object gPB machType
  set seq_obj_list $Post::($post_object,seq_obj_list)
  lappend in_sequence [lindex $seq_obj_list 0] [lindex $seq_obj_list 1] \
  [lindex $seq_obj_list 6]
  lappend out_sequence [lindex $seq_obj_list 2] [lindex $seq_obj_list 3] \
  [lindex $seq_obj_list 4] [lindex $seq_obj_list 5]
  unset seq_obj_list
  lappend seq_obj_list $in_sequence $out_sequence
  if { $::env(PB_UDE_ENABLED) == 1 } {
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
     if { [lsearch $udc_event_list $evt_obj] >= 0 } {
      if { [lsearch $gPB(SYS_CYCLE) $event::($evt_obj,event_name)] >= 0 } {
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
      if { ![string compare $sequence::($seq_obj,seq_name) "Machine Control"] } {
       if [info exists event::($evt_obj,ude_event_obj)] {
        set ueo $event::($evt_obj,ude_event_obj)
        set post_name $ude_event::($ueo,post_event)
        if {![string compare $post_name ""]} {
         set post_name $ude_event::($ueo,name)
        }
        set post_name ${prefix}_${post_name}
        if { [string compare $post_name $event_name] } {
         set event_name $post_name
        }
       }
      }
     }
     if { [lsearch $evt_name_list $event_name] == -1 } \
     {
      if { [lsearch $udc_event_list $evt_obj] >= 0 } {
       if { [lsearch $gPB(SYS_CYCLE) $event::($evt_obj,event_name)] < 0 } {
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
         if { [string compare [lindex $evt_blk_name_list 0] ""] } {
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
         if { [string compare [lindex $evt_blk_name_list 0] ""] } {
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
         if { [string compare [lindex $evt_blk_name_list 0] ""] } {
          set temp_list [concat $evt_blk_arr(MOM_drill) $evt_blk_name_list]
          set evt_blk_arr(MOM_drill) $temp_list
         }
         } else {
         set evt_blk_arr(MOM_drill) $evt_blk_name_list
        }
        if [info exists evt_blk_arr(MOM_drill_dwell)] {
         if { [string compare [lindex $evt_blk_name_list 0] ""] } {
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
         if { [string compare [lindex $evt_blk_name_list 0] ""] } {
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
         if { [string compare [lindex $evt_blk_name_list 0] ""] } {
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
         if { [string compare [lindex $evt_blk_name_list 0] ""] } {
          set temp_list [concat $evt_blk_arr(MOM_bore) $evt_blk_name_list]
          set evt_blk_arr(MOM_bore) $temp_list
         }
         } else {
         set evt_blk_arr(MOM_bore) $evt_blk_name_list
        }
        if [info exists evt_blk_arr(MOM_bore_dwell)] {
         if { [string compare [lindex $evt_blk_name_list 0] ""] } {
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
         if { [string compare [lindex $evt_blk_name_list 0] ""] } {
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
         if { [string compare [lindex $evt_blk_name_list 0] ""] } {
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
         if { [string compare [lindex $evt_blk_name_list 0] ""] } {
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
         if { [string compare [lindex $evt_blk_name_list 0] ""] } {
          set temp_list [concat $evt_blk_arr(MOM_bore_manual) $evt_blk_name_list]
          set evt_blk_arr(MOM_bore_manual) $temp_list
         }
         } else {
         set evt_blk_arr(MOM_bore_manual) $evt_blk_name_list
        }
        if [info exists evt_blk_arr(MOM_bore_manual_dwell)] {
         if { [string compare [lindex $evt_blk_name_list 0] ""] } {
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
         if { [string compare [lindex $evt_blk_name_list 0] ""] } {
          set evt_blk_arr($event_name) $evt_blk_name_list
          } else {
          set evt_blk_arr($event_name) ""
         }
        }
       }
      }
     } ;# disabled
     switch $event_name \
     {
      "MOM_drill"             -
      "MOM_drill_dwell"       -
      "MOM_drill_deep"        -
      "MOM_drill_break_chip"  -
      "MOM_tap"               -
      "MOM_bore"              -
      "MOM_bore_drag"         -
      "MOM_bore_no_drag"      -
      "MOM_bore_manual"       -
      "MOM_bore_dwell"        -
      "MOM_bore_back"         -
      "MOM_bore_manual_dwell" -
      "MOM_tap_deep"          -
      "MOM_tap_break_chip"    -
      "MOM_tap_float"         -
      "MOM_thread" {
       PB_output_RetCycleEvtBlkList evt_obj evt_blk_name_list
       set evt_blk_arr($event_name) $evt_blk_name_list
       set evt_obj_arr($event_name) $evt_obj
      }
      default {
       PB_output_RetEvtBlkList evt_obj evt_blk_name_list
       set evt_blk_arr($event_name) [list $evt_blk_name_list]
       set evt_obj_arr($event_name) $evt_obj
      }
     }
     unset event_name
    }
   }
  }
  set evt_blk_arr(MOM_tool_change) [list ""]
  set evt_obj_arr(MOM_tool_change) 0
  PB_output_EliminatePbEvents evt_name_list evt_blk_arr evt_obj_arr
  if { [lsearch $evt_name_list "MOM_sequence_number"] < 0 } {
   lappend evt_name_list "MOM_sequence_number"
   set evt_blk_arr(MOM_sequence_number) [list ""]
   set evt_obj_arr(MOM_sequence_number) 0
  }
 }

#=======================================================================
proc PB_output_GetEvtObjAttr2 { EVT_NAME_ARR EVT_BLK_ARR EVT_OBJ_ARR } {
  upvar $EVT_NAME_ARR evt_name_list
  upvar $EVT_BLK_ARR evt_blk_arr
  upvar $EVT_OBJ_ARR evt_obj_arr
  global post_object
  set seq_obj_list $Post::($post_object,seq_obj_list)
  global mom_sys_arr
  if { $mom_sys_arr(\$is_linked_post) == 1 } {
   lappend in_sequence [lindex $seq_obj_list 7] [lindex $seq_obj_list 8]
   } else {
   lappend in_sequence [lindex $seq_obj_list 7]
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
     set evt_obj_arr($event_name) $evt_obj
     unset event_name
    }
   }
  }
 }

#=======================================================================
proc PB_output_GetBlkName { BLOCK_OBJ OUTPUT_NAME } {
  upvar $BLOCK_OBJ block_obj
  upvar $OUTPUT_NAME output_name
  if { ![string compare $block::($block_obj,blk_type) "normal"]  || \
   ![string compare $block::($block_obj,blk_type) "comment"] || \
  [string match "vnc_*" $block::($block_obj,blk_type)] } \
  {
   set output_name $block::($block_obj,block_name)
   } elseif { ![string compare $block::($block_obj,blk_type) "macro"] } \
  {
   set blk_elem_obj [lindex $block::($block_obj,elem_addr_list) 0]
   set func_elem $block_element::($blk_elem_obj,elem_mom_variable)
   set output_name $function::($func_elem,id)
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
      if { [string match "macro" $block::($block_obj,blk_type)] } \
      {
       set blk_elem_obj [lindex $block::($block_obj,elem_addr_list) 0]
       if { [info exists block_element::($blk_elem_obj,func_prefix)] } \
       {
        lappend output_name $block_element::($blk_elem_obj,func_prefix)
       } else \
       {
        lappend output_name ""
       }
       if { [info exists block_element::($blk_elem_obj,func_suppress_flag)] } \
       {
        lappend output_name $block_element::($blk_elem_obj,func_suppress_flag)
       } else \
       {
        lappend output_name 0
       }
      }
      lappend blk_list $output_name
     }
    }
   }
  }
  set evt_blk_name_list $blk_list
 }

#=======================================================================
proc PB_output_RetCycleEvtBlkList { EVENT_OBJ EVT_BLK_NAME_LIST args } {
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
       set ret_code [PB_evt_CheckCycleRefWord block_obj $check_type args]
      }
      if { $ret_code == 1 } \
      {
       lappend cycle_output_list $blk_name_list
       set blk_name_list ""
       set ret_code 2
      }
      PB_output_GetBlkName block_obj output_name
      if { [string match "macro" $block::($block_obj,blk_type)] } \
      {
       set blk_elem_obj [lindex $block::($block_obj,elem_addr_list) 0]
       if { [info exists block_element::($blk_elem_obj,func_prefix)] } \
       {
        lappend output_name $block_element::($blk_elem_obj,func_prefix)
       } else \
       {
        lappend output_name ""
       }
       if { [info exists block_element::($blk_elem_obj,func_suppress_flag)] } \
       {
        lappend output_name $block_element::($blk_elem_obj,func_suppress_flag)
       } else \
       {
        lappend output_name 0
       }
      }
      lappend blk_name_list $output_name
     }
    }
   }
  }
  lappend cycle_output_list $blk_name_list
  set evt_blk_name_list $cycle_output_list
 }

#=======================================================================
proc PB_output_EliminatePbEvents { EVT_NAME_LIST EVT_BLK_ARR EVT_OBJ_ARR } {
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
    set evt_obj_arr($event_name) 0
    unset evt_obj_arr($event_name)
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
   puts $file_id "  ADDRESS $adr_name_arr($count)"
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
   puts $file_id "  BLOCK_TEMPLATE $blk_name_arr($count)"
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
     for { set jj 0 } { $jj < $no_lines } { incr jj } \
     {
      puts $file_id "       [lindex $blk_val_arr($count) $jj]"
     }
    }
   puts $file_id "  \}\n"
   if $rapid_work_plane_change {
    if [string match "rapid_traverse" $blk_name_arr($count)] {
     set elem_list [list]
     for { set jj 0 } { $jj < $no_lines } { incr jj } \
     {
      set elem [lindex $blk_val_arr($count) $jj]
      if { ![string match "Z*" $elem] } {
       lappend elem_list $elem
      }
     }
     if [llength $elem_list] {
      puts $file_id "  BLOCK_TEMPLATE $blk_name_arr($count)_xy "
      puts $file_id "  \{"
       for { set jj 0 } { $jj < $no_lines } { incr jj } \
       {
        set elem [lindex $blk_val_arr($count) $jj]
        if { ![string match "Z*" $elem] } {
         puts $file_id "       $elem"
        }
       }
      puts $file_id "  \}\n"
     }
     set elem_list [list]
     for { set jj 0 } { $jj < $no_lines } { incr jj } \
     {
      set elem [lindex $blk_val_arr($count) $jj]
      if { ![string match "X*" $elem] } {
       lappend elem_list $elem
      }
     }
     if [llength $elem_list] {
      puts $file_id "  BLOCK_TEMPLATE $blk_name_arr($count)_yz "
      puts $file_id "  \{"
       for { set jj 0 } { $jj < $no_lines } { incr jj } \
       {
        set elem [lindex $blk_val_arr($count) $jj]
        if { ![string match "X*" $elem] } {
         puts $file_id "       $elem"
        }
       }
      puts $file_id "  \}\n"
     }
     set elem_list [list]
     for { set jj 0 } { $jj < $no_lines } { incr jj } \
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
       for { set jj 0 } { $jj < $no_lines } { incr jj } \
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
     for { set jj 0 } { $jj < $no_lines } { incr jj } \
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
       for { set jj 0 } { $jj < $no_lines } { incr jj } \
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
     for { set jj 0 } { $jj < $no_lines } { incr jj } \
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
       for { set jj 0 } { $jj < $no_lines } { incr jj } \
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
proc PB_output_FindIncludeString { post_object def_file } {
  global ads_cdl_arr
  array set mom_sys_var $Post::($post_object,mom_sys_var_list)
  set include_str ""
  if { [info exists mom_sys_var(Include_UDE)] && $mom_sys_var(Include_UDE) == 1 } {
   foreach oth_cdl $ads_cdl_arr($ads_cdl_arr(type_other),cdl_list) {
    UI_PB_debug_ForceMsg_no_trace "%%%%% included oth_cdl: >$oth_cdl<\n"
    set include_str "$include_str $oth_cdl"
   }
  }
  if { [info exists mom_sys_var(Inherit_UDE)] && $mom_sys_var(Inherit_UDE) == 1 } {
   foreach inh_cdl $ads_cdl_arr($ads_cdl_arr(type_inherit),cdl_list) {
    UI_PB_debug_ForceMsg_no_trace "%%%%% included inh_cdl: >$inh_cdl<\n"
    __ads_cdl_GetNativeCDLFileFrmListElem $inh_cdl $ads_cdl_arr(type_inherit) temp_cdl_file
    set folder $temp_cdl_file(0)
    set cdl_fn $temp_cdl_file(1).cdl
    set def_fn $temp_cdl_file(1).def
    if [string match $folder ""] {
     set include_str "$include_str $cdl_fn $def_fn"
     } else {
     if ![string match "*/" $folder] {
      append folder "/"
     }
     set include_str "$include_str $folder$cdl_fn\
     $folder$def_fn"
    }
   }
  }
  if { [info exists mom_sys_var(Own_UDE)] && $mom_sys_var(Own_UDE) == 1 } {
   set cdl_fn [lindex [split [file tail $def_file] .] 0].cdl
   UI_PB_debug_ForceMsg_no_trace "%%%%% included cdl_fn: >$cdl_fn<\n"
   if [string match $mom_sys_var(OWN_CDL_File_Folder) ""] {
    set include_str "$include_str $cdl_fn"
    } else {
    set folder $mom_sys_var(OWN_CDL_File_Folder)
    if ![string match "*/" $folder] {
     set folder "${folder}/"
    }
    if [regexp {UGII[A-Za-z0-9_]+} $folder ugii_var] {
     regsub {UGII[A-Za-z0-9_]+} $folder [string toupper $ugii_var] folder
    }
    set include_str "$include_str $folder$cdl_fn"
   }
  }
  return $include_str
 }

#=======================================================================
proc PB_PB2DEF_main { PARSER_OBJ OUTPUT_DEF_FILE } {
  upvar $PARSER_OBJ parser_obj
  upvar $OUTPUT_DEF_FILE def_file
  global post_object
  set fmt_obj_list $Post::($post_object,fmt_obj_list)
  set add_obj_list $Post::($post_object,add_obj_list)
  set blk_obj_list $Post::($post_object,blk_obj_list)
  if 0 {
   set _class_elm_list { format      ext_fmt_list \
    address     ext_add_list \
    block       ext_blk_list \
    command     ext_cmd_list \
    function    ext_fun_list \
    ude_event   ext_ude_list \
   cycle_event ext_cyc_list }
  }
  PB_file_ExcludeExtPostObjects fmt_obj_list "format"
  PB_file_ExcludeExtPostObjects add_obj_list "address"
  PB_file_ExcludeExtPostObjects blk_obj_list "block"
  array set mom_sys_var $Post::($post_object,mom_sys_var_list)
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
  set file_name_list $ParseFile::($parser_obj,file_list)
  set nf [expr [llength $file_name_list] - 1]
  for { set i $nf } { $i >= 0 } { incr i -1 } {
   lappend file_list [lindex $file_name_list $i]
  }
  set file_name [lindex $file_list 0]
  set before_formatting $bef_com_data($file_name)
  set after_formatting $aft_com_data($file_name)
  set deff_id [PB_file_configure_output_file "$def_file"]
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
   array set mom_kin_var_arr $Post::($post_object,mom_kin_var_list)
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
  if 0 {
   global mom_sys_arr
   global ads_cdl_arr
   set include_str ""
   if { [info exists mom_sys_arr(Include_UDE)] && $mom_sys_arr(Include_UDE) == 1 } {
    foreach oth_cdl $ads_cdl_arr($ads_cdl_arr(type_other),cdl_list) {
     set include_str "$include_str $oth_cdl"
    }
   }
   if { [info exists mom_sys_arr(Inherit_UDE)] && $mom_sys_arr(Inherit_UDE) == 1 } {
    foreach inh_cdl $ads_cdl_arr($ads_cdl_arr(type_inherit),cdl_list) {
     __ads_cdl_GetNativeCDLFileFrmListElem $inh_cdl $ads_cdl_arr(type_inherit) temp_cdl_file
     set folder $temp_cdl_file(0)
     set cdl_fn $temp_cdl_file(1).cdl
     set def_fn $temp_cdl_file(1).def
     if [string match $folder ""] {
      set include_str "$include_str $cdl_fn $def_fn"
      } else {
      if ![string match "*/" $folder] {
       append folder "/"
      }
      set include_str "$include_str $folder$cdl_fn\
      $folder$def_fn"
     }
    }
   }
   if { [info exists mom_sys_arr(Own_UDE)] && $mom_sys_arr(Own_UDE) == 1 } {
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
  } ;# if 0
  set include_str [PB_output_FindIncludeString $post_object $def_file]
  if { ![string match "" $include_str] } {
   puts $deff_id ""
   puts $deff_id "INCLUDE {"
    foreach ln $include_str {
     puts $deff_id "         $ln"
    }
   puts $deff_id "        }"
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
   if { [string compare $mom_sys_var(seqnum_max) ""] } {
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
   if { [info exists adr_name_arr] } \
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
      PB_output_GetBlkObjAttr post_blk_list add_obj_list blk_name_arr \
      blk_val_arr
      PB_PB2DEF_write_block_templates deff_id blk_name_arr blk_val_arr
      unset blk_name_arr blk_val_arr
     }
    }
   }
   if { [string compare $comment_blk_list ""] } \
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
   if { [string compare $list_blk_value ""] } \
   {
    PB_PB2DEF_write_block_templates deff_id blk_name_arr blk_val_arr
   }
   if { [info exists blk_name_arr] } \
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
  if { [string compare $add_max ""]  &&  $add_max < $max } {
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
    puts $tclf_id "  set [format "%-40s  %$::gPB(val_fmt)" $sys_name_arr($idx) \
    \"$sys_val_arr($idx)\"]"
    if [string match "mom_sys_cutcom_plane_code(ZX)" $sys_name_arr($idx)] {
     puts $tclf_id "  set [format "%-40s  %$::gPB(val_fmt)" mom_sys_cutcom_plane_code(XZ) \
     \"$sys_val_arr($idx)\"]"
    }
    if [string match "mom_sys_cutcom_plane_code(YZ)" $sys_name_arr($idx)] {
     puts $tclf_id "  set [format "%-40s  %$::gPB(val_fmt)" mom_sys_cutcom_plane_code(ZY) \
     \"$sys_val_arr($idx)\"]"
    }
   }
  }
  global mom_sys_arr
  if { [info exists mom_sys_arr(\$linearization_method)] } {
   puts $tclf_id "  set [format %-40s mom_sys_linearization_method] \
   \"$mom_sys_arr(\$linearization_method)\""
  }
  if { [info exists mom_sys_arr(\$tl_num_max)] } {
   puts $tclf_id "  set [format %-40s mom_sys_tool_number_max] \
   \"$mom_sys_arr(\$tl_num_max)\""
  }
  if { [info exists mom_sys_arr(\$tl_num_min)] } {
   puts $tclf_id "  set [format %-40s mom_sys_tool_number_min] \
   \"$mom_sys_arr(\$tl_num_min)\""
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
   puts $tclf_id "  set [format "%-40s  %$::gPB(val_fmt)" $kin_name_arr($count) \
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
    puts $tclf_id "  set [format "%-40s  %$::gPB(val_fmt)" $sim_name_arr($count)\
    \"$item_head\\]"
    set ind [expr $len - 1]
    for {set i 1} { $i < $ind} { incr i} {
     set item [lindex $sim_val_arr($count) $i]
     puts $tclf_id "      [format "%-40s  %$::gPB(val_fmt)"  "" $item\\]"
    }
    puts $tclf_id "      [format "%-40s  %$::gPB(val_fmt)"  "" $item_end\"]"
    } else {
    puts $tclf_id "  set [format "%-40s  %$::gPB(val_fmt)" $sim_name_arr($count)\
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
  if { [string compare $rapid_1 ""] } \
  {
   set val(13) $block::($rapid_1,block_name)
  } else \
  {
   set val(13) ""
  }
  set name(14)  "mom_fly_rapid_spindle_blk"
  set rapid_2 $mom_sys_var_arr(\$pb_rapid_2)
  if { [string compare $rapid_2 ""] } \
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
   if { ![string compare $fly_name_arr($idx) "$fly_name"] } \
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
  set cur_machine         [PB2TCL_read_fly_var mom_fly_machine_type]
  set fourth_dirn         [PB2TCL_read_fly_var mom_fly_4th_axis_direction]
  set fifth_dirn          [PB2TCL_read_fly_var mom_fly_5th_axis_direction]
  set ind_head            [PB2TCL_read_fly_var mom_fly_independent_head]
  set dep_head            [PB2TCL_read_fly_var mom_fly_dependent_head]
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
if { [info exists mom_sys_arr(Output_VNC)] && $mom_sys_arr(Output_VNC) == 1 } {
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
if 0 {
 puts $tclf_id ""
 puts $tclf_id ""
 puts $tclf_id "# Do not process further when post is sourced for information purpose."
 puts $tclf_id "if { \[info exists mom_post_collect_information_only\] && \$mom_post_collect_information_only } {"
  puts $tclf_id "return"
 puts $tclf_id "}"
 puts $tclf_id ""
 puts $tclf_id ""
}
puts $tclf_id "\n"
puts $tclf_id "#============================================================="

#=======================================================================
puts $tclf_id "proc MOM_start_of_program { } {"
  puts $tclf_id "#============================================================="
  if { [info exist ::gPB(PB_POST_DEBUG)] &&\
   [string length [string trim $::gPB(PB_POST_DEBUG)]] > 0 } {
   puts $tclf_id ""
   puts $tclf_id "  if { !\[info exists ::PB_POST_program_start_clock\] } {"
    puts $tclf_id "     set ::PB_POST_program_start_clock \[clock clicks\]"
   puts $tclf_id "  }"
   puts $tclf_id ""
  }
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
  puts $tclf_id "    catch { OPEN_files } ;# Open warning and listing files"
  puts $tclf_id "    LIST_FILE_HEADER     ;# List header in commentary listing"
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
  if { [info exist ::gPB(PB_POST_DEBUG)] &&\
   [string length [string trim $::gPB(PB_POST_DEBUG)]] > 0 } {
   puts $tclf_id "   # Define debug command"
   puts $tclf_id "    if \[llength \[info commands $::gPB(PB_POST_DEBUG_define)\] \] {"
    puts $tclf_id "       $::gPB(PB_POST_DEBUG_define)"
   puts $tclf_id "    }"
   puts $tclf_id ""
   puts $tclf_id ""
  }
  puts $tclf_id "   # Load parameters for alternate output units"
  puts $tclf_id "    PB_load_alternate_unit_settings"
  puts $tclf_id "    rename PB_load_alternate_unit_settings \"\""
  puts $tclf_id ""
  puts $tclf_id ""
  puts $tclf_id "#************"
  puts $tclf_id "uplevel #0 {"
   puts $tclf_id "\n"
   puts $tclf_id "#============================================================="

#=======================================================================
puts $tclf_id "proc MOM_sync { } {"
  puts $tclf_id "#============================================================="
  PB_output_CallDebugMsg S $tclf_id
  puts $tclf_id "  if \[llength \[info commands PB_CMD_kin_handle_sync_event\] \] {"
   if 0 {
    puts $tclf_id "    if \[llength \[info commands PB_CMD_buffer_sync_event\] \] {"
     puts $tclf_id "      global mom_sys_buffer_sync_flag"
     puts $tclf_id "      PB_CMD_buffer_sync_event"
     puts $tclf_id "      if { \[info exists mom_sys_buffer_sync_flag\] && \$mom_sys_buffer_sync_flag } {"
      puts $tclf_id "        return"
     puts $tclf_id "      }"
    puts $tclf_id "    }"
   }
   puts $tclf_id "    PB_CMD_kin_handle_sync_event"
  puts $tclf_id "  }"
  if { [info exists mom_sys_arr(Output_VNC)] && $mom_sys_arr(Output_VNC) == 1 } {
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
  PB_output_CallDebugMsg E $tclf_id
 puts $tclf_id "}"
 puts $tclf_id "\n"
 puts $tclf_id "#============================================================="

#=======================================================================
puts $tclf_id "proc MOM_set_csys { } {"
  puts $tclf_id "#============================================================="
  PB_output_CallDebugMsg S $tclf_id
  puts $tclf_id "  if \[llength \[info commands PB_CMD_kin_set_csys\] \] {"
   puts $tclf_id "    PB_CMD_kin_set_csys"
  puts $tclf_id "  }"
  if { [info exists mom_sys_arr(Output_VNC)] && $mom_sys_arr(Output_VNC) == 1 } {
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
  PB_output_CallDebugMsg E $tclf_id
 puts $tclf_id "}"
 puts $tclf_id "\n"
 puts $tclf_id "#============================================================="

#=======================================================================
puts $tclf_id "proc MOM_msys { } {"
  puts $tclf_id "#============================================================="
  PB_output_CallDebugMsg S $tclf_id
  if { [info exists mom_sys_arr(Output_VNC)] && $mom_sys_arr(Output_VNC) == 1 } {
   puts $tclf_id "# Pass the CSYS information, if a CSYS is not set, that will be"
   puts $tclf_id "# used to set the ZCS coordinate system for simulation."
   puts $tclf_id "  global sim_mtd_initialized"
   puts $tclf_id "  if \$sim_mtd_initialized {"
    puts $tclf_id "    if \[llength \[info commands PB_VNC_pass_msys_data\] \] {"
     puts $tclf_id "      PB_VNC_pass_msys_data"
    puts $tclf_id "    }"
   puts $tclf_id "  }"
  }
  PB_output_CallDebugMsg E $tclf_id
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
    puts $tclf_id " set [format "%-40s  %$::gPB(val_fmt)" mom_sys_master_head \"$head\"]"
    puts $tclf_id ""
    set post \$mom_sys_master_post
   }
   puts $tclf_id " set [format "%-40s  %$::gPB(val_fmt)" mom_sys_postname($head) \"$post\"]"
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
if { [info exists mom_sys_arr(Output_VNC)] && $mom_sys_arr(Output_VNC) == 1 } {
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
PB_output_CallDebugMsg E $tclf_id
puts $tclf_id "}" ;# MOM_start_of_program
if [string match "*dual_head*" $cur_machine] {
puts $tclf_id "\n"
puts $tclf_id "#============================================================="

#=======================================================================
puts $tclf_id "proc PB_swap_dual_head_elements { } {"
  puts $tclf_id "#============================================================="
  PB_output_CallDebugMsg S $tclf_id
  puts $tclf_id "  global mom_output_file_directory mom_logname"
  puts $tclf_id ""
  puts $tclf_id "   set def_file_name  \"\${mom_output_file_directory}__\${mom_logname}_tmp_def_file_\[clock clicks\].def\""
  puts $tclf_id "   if { \[catch { set tmp_file \[open \"\$def_file_name\" w\] } res\] } {"
   puts $tclf_id "      if { \[llength \[info commands PAUSE\] \] } {"
    puts $tclf_id "         PAUSE \"Error in PB_swap_dual_head_elements\" \$res"
   puts $tclf_id "      }"
   puts $tclf_id ""
   puts $tclf_id "      CATCH_WARNING \$res"
   PB_output_CallDebugMsg R $tclf_id 1
   puts $tclf_id "return"
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
  PB_output_CallDebugMsg E $tclf_id
 puts $tclf_id "}"  ;# PB_swap_dual_head_elements
}
set need_rotary_sign_flag 0
if { ![string match "3_axis_mill_turn" $cur_machine] && \
 ![string match "*lathe*" $cur_machine] && \
 ![string match "*_wedm" $cur_machine] } {
 if { ![string compare $fourth_dirn "SIGN_DETERMINES_DIRECTION"] || \
  ![string compare $fifth_dirn "SIGN_DETERMINES_DIRECTION"] } {
  set need_rotary_sign_flag 1
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
  if { ![string compare $fourth_dirn "SIGN_DETERMINES_DIRECTION"] } {
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
  if { ![string compare $fifth_dirn "SIGN_DETERMINES_DIRECTION"] } {
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
  PB_output_CallDebugMsg S $tclf_id
  puts $tclf_id "  global mom_sys_leader"
  puts $tclf_id "  global mom_out_angle_pos"
  puts $tclf_id "  global mom_rotary_direction_4th"
  puts $tclf_id "  global mom_rotary_direction_5th"
  puts $tclf_id "  global mom_kin_4th_axis_direction"
  puts $tclf_id "  global mom_kin_5th_axis_direction"
  if { ![string compare $fourth_dirn "SIGN_DETERMINES_DIRECTION"] } {
   puts $tclf_id ""
   puts $tclf_id "  if { \[info exists mom_kin_4th_axis_direction\] && \\"
    puts $tclf_id "       \[string match \"SIGN_DETERMINES_DIRECTION\" \$mom_kin_4th_axis_direction\] } {"
    puts $tclf_id "     set mom_sys_leader(fourth_axis) \[string trimright \$mom_sys_leader(fourth_axis) \"-\"\]"
    puts $tclf_id "     if { \$mom_rotary_direction_4th < 0 } {"
     puts $tclf_id "        set mom_out_angle_pos(0) \[expr abs(\$mom_out_angle_pos(0))\]"
     puts $tclf_id "        if \[EQ_is_zero \$mom_out_angle_pos(0)\] {"
      puts $tclf_id "           append mom_sys_leader(fourth_axis) \"-\""
      puts $tclf_id "        } else {"
      puts $tclf_id "           set mom_out_angle_pos(0) \[expr -1 * \$mom_out_angle_pos(0)\]"
     puts $tclf_id "        }"
    puts $tclf_id "     }"
   puts $tclf_id "  }"
  }
  if { ![string compare $fifth_dirn "SIGN_DETERMINES_DIRECTION"] } {
   puts $tclf_id ""
   puts $tclf_id "  if { \[info exists mom_kin_5th_axis_direction\] && \\"
    puts $tclf_id "       \[string match \"SIGN_DETERMINES_DIRECTION\" \$mom_kin_5th_axis_direction\] } {"
    puts $tclf_id "     set mom_sys_leader(fifth_axis) \[string trimright \$mom_sys_leader(fifth_axis) \"-\"\]"
    puts $tclf_id "     if { \$mom_rotary_direction_5th < 0 } {"
     puts $tclf_id "        set mom_out_angle_pos(1) \[expr abs(\$mom_out_angle_pos(1))\]"
     puts $tclf_id "        if \[EQ_is_zero \$mom_out_angle_pos(1)\] {"
      puts $tclf_id "           append mom_sys_leader(fifth_axis) \"-\""
      puts $tclf_id "        } else {"
      puts $tclf_id "           set mom_out_angle_pos(1) \[expr -1 * \$mom_out_angle_pos(1)\]"
     puts $tclf_id "        }"
    puts $tclf_id "     }"
   puts $tclf_id "  }"
  }
  PB_output_CallDebugMsg E $tclf_id
 puts $tclf_id "}" ;# PB_ROTARY_SIGN_SET
}
}
}
if { [string compare $ind_head ""] } {
puts $tclf_id "\n"
puts $tclf_id "#============================================================="

#=======================================================================
puts $tclf_id "proc PB_TURRET_HEAD_SET { } {"
  puts $tclf_id "#============================================================="
  PB_output_CallDebugMsg S $tclf_id
  puts $tclf_id "  global mom_kin_independent_head mom_tool_head"
  puts $tclf_id "  global turret_current"
  puts $tclf_id ""
  puts $tclf_id "   set turret_current INDEPENDENT"
  puts $tclf_id "   set ind_head $ind_head"
  puts $tclf_id "   set dep_head $dep_head"
  puts $tclf_id ""
  puts $tclf_id "   if { \[string compare \$mom_tool_head \$mom_kin_independent_head\] } {"
   puts $tclf_id "      set turret_current DEPENDENT"
  puts $tclf_id "   }"
  puts $tclf_id ""
  puts $tclf_id "   if { \[string compare \$mom_tool_head \"\$ind_head\"\] && \\"
   puts $tclf_id "        \[string compare \$mom_tool_head \"\$dep_head\"\] } {"
   puts $tclf_id "      CATCH_WARNING \"mom_tool_head = \$mom_tool_head IS INVALID, USING $dep_head\""
  puts $tclf_id "   }"
  PB_output_CallDebugMsg E $tclf_id
 puts $tclf_id "}"
}
if { ![string compare $cur_machine "lathe"] } {
 puts $tclf_id "\n"
 puts $tclf_id "#============================================================="

#=======================================================================
puts $tclf_id "proc PB_LATHE_THREAD_SET \{ \} \{"
  puts $tclf_id "#============================================================="
  PB_output_CallDebugMsg S $tclf_id
  puts $tclf_id "  global mom_lathe_thread_type mom_lathe_thread_advance_type"
  puts $tclf_id "  global mom_lathe_thread_lead_i mom_lathe_thread_lead_k"
  puts $tclf_id "  global mom_motion_distance"
  puts $tclf_id "  global mom_lathe_thread_increment mom_lathe_thread_value"
  puts $tclf_id "  global thread_type thread_increment feed_rate_mode"
  puts $tclf_id ""
  puts $tclf_id "    switch \$mom_lathe_thread_advance_type \{"
   puts $tclf_id "      1 \{ set thread_type CONSTANT ; MOM_suppress once E \}"
   puts $tclf_id "      2 \{ set thread_type INCREASING ; MOM_force once E \}"
   puts $tclf_id "      default \{ set thread_type DECREASING ; MOM_force once E \}"
  puts $tclf_id "    \}"
  puts $tclf_id ""
  puts $tclf_id "    if \{ \!\[string compare \$thread_type \"INCREASING\"\] || \!\[string compare \$thread_type \"DECREASING\"\] \} \{"
   puts $tclf_id "      if \{ \$mom_lathe_thread_type != 1 \} \{"
    puts $tclf_id "        set LENGTH \$mom_motion_distance"
    puts $tclf_id "        set LEAD \$mom_lathe_thread_value"
    puts $tclf_id "        set INCR \$mom_lathe_thread_increment"
    puts $tclf_id "        set E \[expr abs(pow((\$LEAD + (\$INCR \* \$LENGTH)) , 2) - pow(\$LEAD , 2)) \/ 2 \* \$LENGTH\]"
    puts $tclf_id "        set thread_increment \$E"
   puts $tclf_id "      \}"
  puts $tclf_id "    \}"
  puts $tclf_id ""
  puts $tclf_id "    if \{ \[EQ_is_zero \$mom_lathe_thread_lead_i\] \} \{"
   puts $tclf_id "      MOM_suppress once I ; MOM_force once K"
   puts $tclf_id "    \} elseif \{ \[EQ_is_zero \$mom_lathe_thread_lead_k\] \} \{"
   puts $tclf_id "      MOM_suppress once K ; MOM_force once I"
   puts $tclf_id "    \} else \{"
   puts $tclf_id "      MOM_force once I ; MOM_force once K"
  puts $tclf_id "    \}"
  PB_output_CallDebugMsg E $tclf_id
 puts $tclf_id "\}"
}
if { ![string match "*lathe*" $cur_machine] && ![string match "*_wedm" $cur_machine] } {
 global mom_kin_var
 puts $tclf_id "\n"
 puts $tclf_id "#============================================================="

#=======================================================================
puts $tclf_id "proc PB_init_new_iks \{ \} \{"
  puts $tclf_id "#============================================================="
  PB_output_CallDebugMsg S $tclf_id
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
  PB_output_CallDebugMsg E $tclf_id
 puts $tclf_id "\}"
}
puts $tclf_id "\n"
puts $tclf_id "#============================================================="

#=======================================================================
puts $tclf_id "proc PB_DELAY_TIME_SET \{ \} \{"
  puts $tclf_id "#============================================================="
  PB_output_CallDebugMsg S $tclf_id
  puts $tclf_id "  global mom_sys_delay_param mom_delay_value"
  puts $tclf_id "  global mom_delay_revs mom_delay_mode delay_time"
  puts $tclf_id ""
  puts $tclf_id "  # Post Builder provided format for the current mode:"
  puts $tclf_id "   if \{ \[info exists mom_sys_delay_param(\$\{mom_delay_mode\},format)\] != 0 \} \{"
   puts $tclf_id "      MOM_set_address_format dwell \$mom_sys_delay_param(\$\{mom_delay_mode\},format)"
  puts $tclf_id "   \}"
  puts $tclf_id ""
  puts $tclf_id "   switch \$mom_delay_mode \{"
   puts $tclf_id "      SECONDS \{ set delay_time \$mom_delay_value \}"
   puts $tclf_id "      default \{ set delay_time \$mom_delay_revs  \}"
  puts $tclf_id "   \}"
  PB_output_CallDebugMsg E $tclf_id
 puts $tclf_id "\}"
 puts $tclf_id "\n"
 puts $tclf_id "#============================================================="

#=======================================================================
puts $tclf_id "proc MOM_before_motion \{ \} \{"
  puts $tclf_id "#============================================================="
  PB_output_CallDebugMsg S $tclf_id
  puts $tclf_id "  global mom_motion_event mom_motion_type"
  puts $tclf_id ""
  puts $tclf_id "   FEEDRATE_SET"
  puts $tclf_id ""
  if { ![string compare $lathe_output_method "TURRET_REF"] } {
   puts $tclf_id "   global mom_pos mom_ref_pos"
   puts $tclf_id "   set mom_pos(0) \$mom_ref_pos(0)"
   puts $tclf_id "   set mom_pos(1) \$mom_ref_pos(1)"
   puts $tclf_id "   set mom_pos(2) \$mom_ref_pos(2)"
   puts $tclf_id ""
   puts $tclf_id "   switch \$mom_motion_event \{"
    puts $tclf_id "      circular_move \{"
     puts $tclf_id "         global mom_ref_pos_arc_center mom_pos_arc_center"
     puts $tclf_id "         if \{\[hiset mom_ref_pos_arc_center(0)\]\} \{set mom_pos_arc_center(0) \$mom_ref_pos_arc_center(0)\}"
     puts $tclf_id "         if \{\[hiset mom_ref_pos_arc_center(1)\]\} \{set mom_pos_arc_center(1) \$mom_ref_pos_arc_center(1)\}"
     puts $tclf_id "         if \{\[hiset mom_ref_pos_arc_center(2)\]\} \{set mom_pos_arc_center(2) \$mom_ref_pos_arc_center(2)\}"
    puts $tclf_id "      \}"
    puts $tclf_id "      from_move \{"
     puts $tclf_id "         global mom_from_ref_pos mom_from_pos"
     puts $tclf_id "         if \{\[hiset mom_from_ref_pos(0)\]\} \{set mom_from_pos(0) \$mom_from_ref_pos(0)\}"
     puts $tclf_id "         if \{\[hiset mom_from_ref_pos(1)\]\} \{set mom_from_pos(1) \$mom_from_ref_pos(1)\}"
     puts $tclf_id "         if \{\[hiset mom_from_ref_pos(2)\]\} \{set mom_from_pos(2) \$mom_from_ref_pos(2)\}"
    puts $tclf_id "      \}"
    puts $tclf_id "      gohome_move \{"
     puts $tclf_id "         global mom_gohome_ref_pos mom_gohome_pos"
     puts $tclf_id "         if \{\[hiset mom_gohome_ref_pos(0)\]\} \{set mom_gohome_pos(0) \$mom_gohome_ref_pos(0)\}"
     puts $tclf_id "         if \{\[hiset mom_gohome_ref_pos(1)\]\} \{set mom_gohome_pos(1) \$mom_gohome_ref_pos(1)\}"
     puts $tclf_id "         if \{\[hiset mom_gohome_ref_pos(2)\]\} \{set mom_gohome_pos(2) \$mom_gohome_ref_pos(2)\}"
    puts $tclf_id "      \}"
   puts $tclf_id "   \}"
  }
  puts $tclf_id ""
  puts $tclf_id "   switch \$mom_motion_type {"
   if [string match "*_wedm" $cur_machine] {
    puts $tclf_id "      ENGAGE   { PB_CMD_kin_wedm_engage_move }"
    } else {
    puts $tclf_id "      ENGAGE   { PB_engage_move }"
   }
   puts $tclf_id "      APPROACH { PB_approach_move }"
   puts $tclf_id "      FIRSTCUT { catch {PB_first_cut} }"
   if { ![string match "*_wedm" $cur_machine] } {
    puts $tclf_id "      RETRACT  { PB_retract_move }"
   }
   puts $tclf_id "      RETURN   { catch {PB_return_move} }"
   puts $tclf_id "      default  {}"
  puts $tclf_id "   }"
  puts $tclf_id ""
  puts $tclf_id "   if { \[llength \[info commands PB_CMD_kin_before_motion\] \] } \{ PB_CMD_kin_before_motion \}"
  puts $tclf_id "   if { \[llength \[info commands PB_CMD_before_motion\] \] }     \{ PB_CMD_before_motion \}"
  if { $need_rotary_sign_flag } {
   puts $tclf_id ""
   puts $tclf_id "   PB_ROTARY_SIGN_SET"
  }
  PB_output_CallDebugMsg E $tclf_id
 puts $tclf_id "\}"
 puts $tclf_id "\n"
 puts $tclf_id "#============================================================="

#=======================================================================
puts $tclf_id "proc MOM_start_of_group \{ \} \{"
  puts $tclf_id "#============================================================="
  PB_output_CallDebugMsg S $tclf_id
  puts $tclf_id "  global mom_sys_group_output mom_group_name group_level ptp_file_name"
  puts $tclf_id "  global mom_sequence_number mom_sequence_increment mom_sequence_frequency"
  puts $tclf_id "  global mom_sys_ptp_output pb_start_of_program_flag"
  puts $tclf_id ""
  puts $tclf_id "   if \{ !\[hiset group_level\] \} \{"
   puts $tclf_id "      set group_level 0"
   PB_output_CallDebugMsg R $tclf_id 1
   puts $tclf_id "      return"
  puts $tclf_id "   \}"
  puts $tclf_id ""
  puts $tclf_id "   if \{ \[hiset mom_sys_group_output\] \} \{"
   puts $tclf_id "      if \{ \!\[string compare \$mom_sys_group_output \"OFF\"\] \} \{"
    puts $tclf_id "         set group_level 0"
    PB_output_CallDebugMsg R $tclf_id 2
    puts $tclf_id "         return"
   puts $tclf_id "      \}"
  puts $tclf_id "   \}"
  puts $tclf_id ""
  puts $tclf_id "   if \{ \[hiset group_level\] \} \{"
   puts $tclf_id "      incr group_level"
   puts $tclf_id "   \} else \{"
   puts $tclf_id "      set group_level 1"
  puts $tclf_id "   \}"
  puts $tclf_id ""
  puts $tclf_id "   if \{ \$group_level > 1 \} \{"
   PB_output_CallDebugMsg R $tclf_id 3
   puts $tclf_id "      return"
  puts $tclf_id "   \}"
  puts $tclf_id ""
  puts $tclf_id "   SEQNO_RESET ; #<4133654>"
  puts $tclf_id "   MOM_reset_sequence \$mom_sequence_number \$mom_sequence_increment \$mom_sequence_frequency"
  puts $tclf_id ""
  puts $tclf_id "   if \{ \[info exists ptp_file_name\] \} \{"
   puts $tclf_id "      MOM_close_output_file \$ptp_file_name"
   puts $tclf_id "      MOM_start_of_program"
   puts $tclf_id "      if \{ \!\[string compare \$mom_sys_ptp_output \"ON\"\] \} \{"
    puts $tclf_id "         MOM_open_output_file \$ptp_file_name"
   puts $tclf_id "      \}"
   puts $tclf_id "   \} else \{"
   puts $tclf_id "      MOM_start_of_program"
  puts $tclf_id "   \}"
  puts $tclf_id ""
  puts $tclf_id "   PB_start_of_program"
  puts $tclf_id "   set pb_start_of_program_flag 1"
  PB_output_CallDebugMsg E $tclf_id
 puts $tclf_id "\}"
 puts $tclf_id "\n"
 puts $tclf_id "#============================================================="

#=======================================================================
puts $tclf_id "proc MOM_machine_mode { } {"
  puts $tclf_id "#============================================================="
  PB_output_CallDebugMsg S $tclf_id
  puts $tclf_id "  global pb_start_of_program_flag"
  puts $tclf_id "  global mom_operation_name mom_sys_change_mach_operation_name"
  puts $tclf_id ""
  puts $tclf_id "   set mom_sys_change_mach_operation_name \$mom_operation_name"
  puts $tclf_id ""
  puts $tclf_id "   if { \$pb_start_of_program_flag == 0 } {"
   puts $tclf_id "      PB_start_of_program"
   puts $tclf_id "      set pb_start_of_program_flag 1"
  puts $tclf_id "   }"
  puts $tclf_id ""
  puts $tclf_id "  # For simple mill-turn"
  puts $tclf_id "   if { \[llength \[info commands PB_machine_mode\] \] } {"
   puts $tclf_id "      if { \[catch \{PB_machine_mode\} res\] } {"
    puts $tclf_id "         CATCH_WARNING \"\$res\""
   puts $tclf_id "      }"
  puts $tclf_id "   }"
  if { [info exists mom_sys_arr(Output_VNC)] && $mom_sys_arr(Output_VNC) == 1 } {
   puts $tclf_id ""
   puts $tclf_id "  # Pass tool name to VNC for simulation."
   puts $tclf_id "   global sim_mtd_initialized"
   puts $tclf_id "   if { \$sim_mtd_initialized } {"
    puts $tclf_id "      if { \[llength \[info commands PB_VNC_pass_tool_data\] \] } {"
     puts $tclf_id "         PB_VNC_pass_tool_data"
    puts $tclf_id "      }"
   puts $tclf_id "   }"
  }
  PB_output_CallDebugMsg E $tclf_id
 puts $tclf_id "}"
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
  PB_output_CallDebugMsg S $tclf_id
  puts $tclf_id "   global mom_sys_mill_turn_mode  mom_sys_mill_turn_type"
  puts $tclf_id ""
  puts $tclf_id "   if { !\[info exists mom_sys_mill_turn_mode\] } {"
   puts $tclf_id "     # This variable is set in PB_CMD_kin_init_mill_turn"
   puts $tclf_id "     # to indicate the mill-turn mode has been initialized."
   PB_output_CallDebugMsg R $tclf_id 1
   puts $tclf_id "return"
  puts $tclf_id "   }"
  puts $tclf_id ""
  puts $tclf_id "   if { \[info exists mom_sys_mill_turn_type\] && \\"
   puts $tclf_id "       !\[string match \"SIMPLE_MILL_TURN\" \$mom_sys_mill_turn_type\] } {"
   PB_output_CallDebugMsg R $tclf_id 2
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
  puts $tclf_id "   if { \!\[string compare \$mom_machine_mode \"LATHE\"\] } { set mom_machine_mode \"TURN\" }"
  puts $tclf_id ""
  puts $tclf_id "   if { \!\[string compare \$mom_machine_mode \"MILL\"\] } {"
   puts $tclf_id ""
   puts $tclf_id "      if { \!\[string compare \$mom_sys_current_head \"TURN\"\] } {"
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
   puts $tclf_id "   } elseif { \!\[string compare \$mom_machine_mode \"TURN\"\] } {"
   puts $tclf_id ""
   puts $tclf_id "      if { \!\[string compare \$mom_sys_current_head \"MILL\"\] } {"
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
    puts $tclf_id "         set mom_sys_head_change_init_program 1"
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
     puts $tclf_id "            set mom_sys_head_change_init_program 1"
     puts $tclf_id ""
     puts $tclf_id "         } else {"
     puts $tclf_id "            CATCH_WARNING \"Lathe post \$mom_sys_lathe_postname not found\""
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
  PB_output_CallDebugMsg E $tclf_id
 puts $tclf_id "}"
}
puts $tclf_id "\n"
puts $tclf_id "#============================================================="

#=======================================================================
puts $tclf_id "proc PB_FORCE \{ option args \} \{"
  puts $tclf_id "#============================================================="
  PB_output_CallDebugMsg S $tclf_id
  puts $tclf_id "   set adds \[join \$args\]"
  puts $tclf_id "   if \{ \[info exists option\] && \[llength \$adds\] \} \{"
   puts $tclf_id "      lappend cmd MOM_force"
   puts $tclf_id "      lappend cmd \$option"
   puts $tclf_id "      lappend cmd \[join \$adds\]"
   puts $tclf_id "      eval \[join \$cmd\]"
  puts $tclf_id "   \}"
  PB_output_CallDebugMsg E $tclf_id
 puts $tclf_id "\}"
 puts $tclf_id "\n"
 puts $tclf_id "#============================================================="

#=======================================================================
puts $tclf_id "proc PB_SET_RAPID_MOD \{ mod_list blk_list ADDR NEW_MOD_LIST \} \{"
  puts $tclf_id "#============================================================="
  PB_output_CallDebugMsg S $tclf_id
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
  PB_output_CallDebugMsg E $tclf_id
 puts $tclf_id "\}"
 puts $tclf_id "\n"
 puts $tclf_id "########################"
 puts $tclf_id "# Redefine FEEDRATE_SET"
 puts $tclf_id "########################"
 puts $tclf_id "if { \[llength \[info commands ugpost_FEEDRATE_SET\] \] } {"
  puts $tclf_id "   rename ugpost_FEEDRATE_SET \"\""
 puts $tclf_id "}"
 puts $tclf_id ""
 puts $tclf_id "if { \[llength \[info commands FEEDRATE_SET\] \] } {"
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
  PB_output_CallDebugMsg S $tclf_id
  puts $tclf_id "   if { \[llength \[info commands PB_CMD_kin_feedrate_set\] \] } {"
   puts $tclf_id "      PB_CMD_kin_feedrate_set"
   puts $tclf_id "   } else {"
   puts $tclf_id "      ugpost_FEEDRATE_SET"
  puts $tclf_id "   }"
  PB_output_CallDebugMsg E $tclf_id
 puts $tclf_id "}"
 puts $tclf_id "\n"
 if [string match "*_wedm" $cur_machine] {
  puts $tclf_id "#============================================================="

#=======================================================================
puts $tclf_id "proc MOM_wire_cutcom { } {"
  puts $tclf_id "#============================================================="
  PB_output_CallDebugMsg S $tclf_id
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
  PB_output_CallDebugMsg E $tclf_id
 puts $tclf_id "}"
 puts $tclf_id "\n"
}
if { $::env(PB_UDE_ENABLED) != 1 } {
 if { [info exists mom_sys_arr(\$mom_sys_mill_turn_type)] && \
  [string match "SIMPLE_MILL_TURN" $mom_sys_arr(\$mom_sys_mill_turn_type)] } {
  } elseif { $mom_sys_arr(\$is_linked_post) == 1 } {
  puts $tclf_id "#============================================================="

#=======================================================================
puts $tclf_id "proc MOM_head { } {"
  puts $tclf_id "#============================================================="
  PB_output_CallDebugMsg S $tclf_id
  list event_output
  __output_MOM_head_body event_output
  PB_PB2TCL_write_event_procs tclf_id event_output
  unset event_output
  PB_output_CallDebugMsg E $tclf_id
 puts $tclf_id "}" ;# MOM_head
 list event_output
 __output_MOM_head_end event_output
 PB_PB2TCL_write_event_procs tclf_id event_output
 unset event_output
 puts $tclf_id "\n"
}
} ;#<07-27-06 peter>for ude
}

#=======================================================================
proc __output_MOM_head_body { EVENT_OUTPUT } {
  upvar $EVENT_OUTPUT event_output
  lappend event_output "   global mom_warning_info"
  lappend event_output ""
  lappend event_output "   global mom_sys_in_operation"
  lappend event_output "   if { \[info exists mom_sys_in_operation\] && \$mom_sys_in_operation == 1 } {"
   lappend event_output "      global mom_operation_name"
   lappend event_output "      CATCH_WARNING \"HEAD event should not be assigned to an operation (\$mom_operation_name).\""
   PB_output_CallDebugMsg R event_output 1
   lappend event_output "return"
  lappend event_output "   }"
  lappend event_output ""
  lappend event_output ""
  lappend event_output "   global mom_head_name mom_sys_postname"
  lappend event_output "   global mom_load_event_handler"
  lappend event_output "   global CURRENT_HEAD NEXT_HEAD"
  lappend event_output "   global mom_sys_prev_mach_head mom_sys_curr_mach_head"
  lappend event_output "   global mom_sys_head_change_init_program"
  lappend event_output ""
  lappend event_output ""
  lappend event_output "   if { \[info exists mom_head_name\] } {"
   lappend event_output "      set NEXT_HEAD \$mom_head_name"
   lappend event_output "   } else {"
   lappend event_output "      CATCH_WARNING \"No HEAD event has been assigned.\""
   PB_output_CallDebugMsg R event_output 2
   lappend event_output "return"
  lappend event_output "   }"
  lappend event_output ""
  lappend event_output "   set head_list \[array names mom_sys_postname\]"
  lappend event_output "   foreach h \$head_list {"
   lappend event_output "      if { \[regexp -nocase ^\$mom_head_name\$ \$h\] == 1 } {"
    lappend event_output "         set NEXT_HEAD \$h"
    lappend event_output "         break"
   lappend event_output "      }"
  lappend event_output "   }"
  lappend event_output ""
  lappend event_output "   if { \[string length \$NEXT_HEAD\] == 0 } {"
   lappend event_output "      CATCH_WARNING \"Next HEAD is not defined.\""
   PB_output_CallDebugMsg R event_output 3
   lappend event_output "return"
  lappend event_output "   }"
  lappend event_output ""
  lappend event_output ""
  lappend event_output "  # Initialize current head to the master"
  lappend event_output "   global mom_sys_master_head"
  lappend event_output "   if { !\[info exists CURRENT_HEAD\] } {"
   lappend event_output "      set CURRENT_HEAD \"\$mom_sys_master_head\""
  lappend event_output "   }"
  lappend event_output ""
  lappend event_output ""
  lappend event_output "   set tcl_file \"\""
  lappend event_output ""
  lappend event_output "   if { !\[info exists mom_sys_postname(\$NEXT_HEAD)\] } {"
   lappend event_output ""
   lappend event_output "      CATCH_WARNING \"Post is not specified with Head (\$NEXT_HEAD).\""
   lappend event_output ""
   lappend event_output "   } elseif { !\[string match \"\$NEXT_HEAD\" \$CURRENT_HEAD\] } {"
   lappend event_output ""
   lappend event_output "     # Execute the closing handler for current post"
   lappend event_output "      if { \[CMD_EXIST PB_end_of_HEAD__\$CURRENT_HEAD\] } {"
    lappend event_output "         PB_end_of_HEAD__\$CURRENT_HEAD"
   lappend event_output "      }"
   lappend event_output ""
   lappend event_output "      set mom_sys_prev_mach_head \$CURRENT_HEAD"
   lappend event_output "      set mom_sys_curr_mach_head \$NEXT_HEAD"
   lappend event_output ""
   lappend event_output "      set CURRENT_HEAD \$NEXT_HEAD"
   lappend event_output ""
   lappend event_output ""
   lappend event_output "      global mom_sys_post_visited"
   lappend event_output "      global mom_sys_master_post cam_post_dir"
   lappend event_output ""
   lappend event_output "      if { \[string match \"\$CURRENT_HEAD\" \$mom_sys_master_head\] } {"
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
     lappend event_output ""
     lappend event_output "            if { !\[info exists mom_sys_post_visited(\$CURRENT_HEAD)\] } {"
      lappend event_output "               set mom_load_event_handler \"\$tcl_file\""
      lappend event_output "               set mom_sys_post_visited(\$CURRENT_HEAD) 1"
      lappend event_output "            } else {"
      lappend event_output "               set mom_load_event_handler \"\\\"\$tcl_file\\\"\""
     lappend event_output "            }"
     lappend event_output ""
     lappend event_output "            set mom_load_event_handler \"{\$tcl_file}\""
     lappend event_output "            MOM_load_definition_file   \"\${def_file}\""
     lappend event_output ""
     lappend event_output "         } else {"
     lappend event_output ""
     lappend event_output "            set tcl_file \"\${cam_post_dir}\$mom_sys_postname(\$CURRENT_HEAD).tcl\""
     lappend event_output "            set def_file \"\${cam_post_dir}\$mom_sys_postname(\$CURRENT_HEAD).def\""
     lappend event_output ""
     lappend event_output "            if \[file exists \"\$tcl_file\"\] {"
      lappend event_output ""
      lappend event_output "               regsub -all {\\\\} \$tcl_file {/} tcl_file"
      lappend event_output "               regsub -all {\\\\} \$def_file {/} def_file"
      lappend event_output ""
      lappend event_output "               if { !\[info exists mom_sys_post_visited(\$CURRENT_HEAD)\] } {"
       lappend event_output "                  set mom_load_event_handler \"\$tcl_file\""
       lappend event_output "                  set mom_sys_post_visited(\$CURRENT_HEAD) 1"
       lappend event_output "               } else {"
       lappend event_output "                  set mom_load_event_handler \"\\\"\$tcl_file\\\"\""
      lappend event_output "               }"
      lappend event_output ""
      lappend event_output "               set mom_load_event_handler \"{\$tcl_file}\""
      lappend event_output "               MOM_load_definition_file   \"\${def_file}\""
      lappend event_output ""
      lappend event_output "            } else {"
      lappend event_output ""
      lappend event_output "               CATCH_WARNING \"Post (\$mom_sys_postname(\$CURRENT_HEAD)) for HEAD (\$CURRENT_HEAD) not found.\""
     lappend event_output "            }"
    lappend event_output "         }"
   lappend event_output "      }"
   lappend event_output ""
   lappend event_output ""
   global mom_sys_arr
   if { [info exists mom_sys_arr(Output_VNC)] && $mom_sys_arr(Output_VNC) == 1 } {
    lappend event_output "      global sim_mtd_initialized"
    lappend event_output "      if \$sim_mtd_initialized {"
     lappend event_output "         if \[CMD_EXIST PB_VNC_pass_head_data\] {"
      lappend event_output "            global mom_sys_sim_post_name"
      lappend event_output "            set mom_sys_sim_post_name \[file rootname \"\$tcl_file\"\]"
      lappend event_output "            PB_VNC_pass_head_data"
     lappend event_output "         }"
    lappend event_output "      }"
    lappend event_output "\n"
   }
   lappend event_output "      set mom_sys_head_change_init_program 1"
   lappend event_output ""
   lappend event_output "      if \[CMD_EXIST MOM_start_of_program_save\] {"
    lappend event_output "         rename MOM_start_of_program_save \"\""
   lappend event_output "      }"
   lappend event_output "      rename MOM_start_of_program MOM_start_of_program_save"
   lappend event_output ""
   lappend event_output "      if \[CMD_EXIST MOM_end_of_program\] {"
    lappend event_output "         if \[CMD_EXIST MOM_end_of_program_save\] {"
     lappend event_output "            rename MOM_end_of_program_save \"\""
    lappend event_output "         }"
    lappend event_output "         rename MOM_end_of_program MOM_end_of_program_save"
   lappend event_output "      }"
   lappend event_output ""
   lappend event_output "      if \[CMD_EXIST MOM_head_save\] {"
    lappend event_output "         rename MOM_head_save \"\""
   lappend event_output "      }"
   lappend event_output "      rename MOM_head MOM_head_save"
  lappend event_output "   }"
 }

#=======================================================================
proc __output_MOM_head_body__02-14-2011_bck { EVENT_OUTPUT } {
  upvar $EVENT_OUTPUT event_output
  lappend event_output "   global mom_warning_info"
  lappend event_output ""
  lappend event_output "   global mom_sys_in_operation"
  lappend event_output "   if { \[info exists mom_sys_in_operation\] && \$mom_sys_in_operation == 1 } {"
   lappend event_output "      global mom_operation_name"
   lappend event_output "      CATCH_WARNING \"HEAD event should not be assigned to an operation (\$mom_operation_name).\""
   lappend event_output "return"
  lappend event_output "   }"
  lappend event_output ""
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
   lappend event_output "      CATCH_WARNING \"No HEAD event has been assigned.\""
   lappend event_output "return"
  lappend event_output "   }"
  lappend event_output ""
  lappend event_output "   set head_list \[array names mom_sys_postname\]"
  lappend event_output "   foreach h \$head_list {"
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
   lappend event_output "      CATCH_WARNING \"Post is not specified with Head (\$NEXT_HEAD).\""
   lappend event_output ""
   lappend event_output "   } elseif { !\[string match \"\$NEXT_HEAD\" \$CURRENT_HEAD\] } {"
   lappend event_output ""
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
      lappend event_output ""
      lappend event_output "               set mom_load_event_handler \"\\\"\$tcl_file\\\"\""
      lappend event_output "               MOM_load_definition_file   \"\$def_file\""
      lappend event_output ""
      lappend event_output "            } else {"
      lappend event_output "               CATCH_WARNING\
      \"Post (\$mom_sys_postname(\$CURRENT_HEAD)) for HEAD (\$CURRENT_HEAD) not found.\""
     lappend event_output "            }"
    lappend event_output "         }"
   lappend event_output "      }"
   lappend event_output "\n"
   if 0 {
    puts $tclf_id "      if { \[llength \[info commands PB_start_of_HEAD__\$CURRENT_HEAD\]\] } {"
     puts $tclf_id "         PB_start_of_HEAD__\$CURRENT_HEAD"
    puts $tclf_id "      }"
    puts $tclf_id ""
   }
   global mom_sys_arr
   if { [info exists mom_sys_arr(Output_VNC)] && $mom_sys_arr(Output_VNC) == 1 } {
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
   lappend event_output "      if \[llength \[info commands MOM_start_of_program_save\]\] {"
    lappend event_output "         rename MOM_start_of_program_save \"\""
   lappend event_output "      }"
   lappend event_output "      rename MOM_start_of_program MOM_start_of_program_save"
   lappend event_output ""
   lappend event_output "      if \[llength \[info commands MOM_end_of_program\]\] {"
    lappend event_output "         if \[llength \[info commands MOM_end_of_program_save\]\] {"
     lappend event_output "            rename MOM_end_of_program_save \"\""
    lappend event_output "         }"
    lappend event_output "         rename MOM_end_of_program MOM_end_of_program_save"
   lappend event_output "      }"
   lappend event_output ""
   lappend event_output "      if \[llength \[info commands MOM_head_save\]\] {"
    lappend event_output "         rename MOM_head_save \"\""
   lappend event_output "      }"
   lappend event_output "      rename MOM_head MOM_head_save"
  lappend event_output "   }"
 }

#=======================================================================
proc __output_MOM_head_end { EVENT_OUTPUT } {
  upvar $EVENT_OUTPUT event_output
  lappend event_output "\n"
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
}

#=======================================================================
proc PB_PB2TCL_write_tcl_procs2 { TCLF_ID } {
  upvar $TCLF_ID tclf_id
  PB_output_GetEvtObjAttr2 evt_name_list evt_blk_arr evt_obj_arr
  PB_output_RetBlksModality blk_mod_arr
  set evt_name_list [lsort $evt_name_list]
  foreach event_name $evt_name_list \
  {
   set evt_obj $evt_obj_arr($event_name)
   PB_output_GetEventProcData evt_obj event_name evt_blk_arr($event_name) \
   blk_mod_arr event_output
   PB_PB2TCL_write_event_procs tclf_id event_output
   unset event_output
  }
 }

#=======================================================================
proc PB_PB2TCL_write_tcl_procs { TCLF_ID } {
  upvar $TCLF_ID tclf_id
  puts $tclf_id "############## EVENT HANDLING SECTION ################"
  PB_output_GetEvtObjAttr evt_name_list evt_blk_arr udc_name_list evt_obj_arr
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
   set evt_obj $evt_obj_arr($event_name)
   PB_output_GetEventProcData evt_obj event_name evt_blk_arr($event_name) \
   blk_mod_arr event_output $udc_name_list
   PB_output_special_case_end event_name event_output
   PB_PB2TCL_write_event_procs tclf_id event_output
   unset event_output
  }
  global post_object
  if { [info exists Post::($post_object,user_def_axis_limit_flag)] && \
  $Post::($post_object,user_def_axis_limit_flag) } \
  {
   set event_output ""
   lappend event_output "\n"
   lappend event_output "#============================================================="

#=======================================================================
lappend event_output "proc PB_user_def_axis_limit_action \{ args \} \{"
  lappend event_output "#============================================================="
  PB_output_CallDebugMsg S event_output
  global post_object
  if [info exists Post::($post_object,axis_limit_evt_obj)] \
  {
   set evt_obj $Post::($post_object,axis_limit_evt_obj)
   set evt_name $event::($evt_obj,event_name)
   PB_output_RetEvtBlkList evt_obj evt_blocks
   set evt_blocks [list $evt_blocks]
   set no_of_lists [llength $evt_blocks]
   if { $no_of_lists } \
   {
    PB_output_BlockOfAEvent evt_name evt_blocks blk_mod_arr no_of_lists event_output evt_obj
   }
  }
  PB_output_CallDebugMsg E event_output
 lappend event_output "\}"
 PB_PB2TCL_write_event_procs tclf_id event_output
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
proc __output_mom_do_template { OUTPUT_BUFFER n_blank block_name BLK_MOD_ARR \
  COND_CMD SUPPRESS_FLAG FORCE_NAME_LIST args } {
  upvar $OUTPUT_BUFFER output_buffer
  upvar $BLK_MOD_ARR blk_mod_arr
  upvar $COND_CMD cond_cmd
  upvar $SUPPRESS_FLAG suppress_flag
  upvar $FORCE_NAME_LIST force_name_list
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
    set line_text "MOM_output_literal \"$comment_start$elem_var$comment_end\""
    __outputExecAttr line_text blank_string cond_cmd suppress_flag force_name_list output_buffer
    } else {
    set line_text "MOM_do_template $block_name$template_string"
    __outputExecAttr line_text blank_string cond_cmd suppress_flag force_name_list output_buffer
   }
   } else {
   set line_text "MOM_do_template $block_name$template_string"
   __outputExecAttr line_text blank_string cond_cmd suppress_flag force_name_list output_buffer
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
  PB_output_CallDebugMsg E event_output
 lappend event_output "\}"
 lappend event_output "\n"
 lappend event_output "#============================================================="

#=======================================================================
lappend event_output "proc $event_move \{ \} \{"
  lappend event_output "#============================================================="
  PB_output_CallDebugMsg S event_output
  lappend event_output "  global cycle_init_flag"
  lappend event_output ""
  lappend event_output ""
  lappend event_output "   global mom_sys_abort_next_event"
  lappend event_output "   if { \[info exists mom_sys_abort_next_event\] } {"
   lappend event_output "      if { \[llength \[info commands PB_CMD_kin_abort_event\]\] } {"
    lappend event_output "         PB_CMD_kin_abort_event"
   lappend event_output "      }"
  lappend event_output "   }"
  lappend event_output ""
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
    lappend event_output "  global cycle_name"
    lappend event_output "  global cycle_init_flag"
    lappend event_output ""
    append event_move $evt_name _move
    set cycle_name [string toupper [string trimleft $evt_name MOM_]]
    set cycle_init_flag TRUE
    lappend event_output "   set cycle_init_flag $cycle_init_flag"
    lappend event_output "   set cycle_name $cycle_name"
    if { [string compare $evt_name "MOM_thread"] && [string compare $evt_name "MOM_lathe_thread"] } {
     lappend event_output "   CYCLE_SET"
    }
    PB_output_CallDebugMsg E event_output
   lappend event_output "\}"
   lappend event_output "\n"
   lappend event_output "#============================================================="

#=======================================================================
lappend event_output "proc ${evt_name}_move \{ \} \{"
  lappend event_output "#============================================================="
  PB_output_CallDebugMsg S event_output
  lappend event_output "   global cycle_init_flag"
  lappend event_output ""
  lappend event_output ""
  lappend event_output "   global mom_sys_abort_next_event"
  lappend event_output "   if { \[info exists mom_sys_abort_next_event\] } {"
   lappend event_output "      if { \[llength \[info commands PB_CMD_kin_abort_event\]\] } {"
    lappend event_output "         PB_CMD_kin_abort_event"
   lappend event_output "      }"
  lappend event_output "   }"
  lappend event_output ""
  lappend event_output ""
  if { $::env(PB_UDE_ENABLED) == 1 } {
   set sys_cyc [list]
   PB_ude_RetUdeUdcObjList sys_mce non_sys_mce sys_cyc non_sys_cyc
   if { [llength $sys_cyc] > 0 } {
    foreach obj $sys_cyc {
     set name [PB_ude_GetEventName $obj]
     set name [string tolower $name]
     set name [join [split $name " "] _]
     set name "MOM_$name"
     if { ![string compare $name $evt_name] } {
      foreach one $cycle_event::($obj,param_obj_list) {
       if { [lsearch $gPB(sys_def_param_obj_list) $one] < 0 } {
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
  set seq_name "Cycles"
  set seq_obj [PB_com_FindObjFrmName $seq_name sequence]
  foreach evt_obj $sequence::($seq_obj,evt_obj_list) \
  {
   if [string match "Drill Text" $event::($evt_obj,event_name)] \
   {
    if [string match "" $event::($evt_obj,evt_elem_list)] \
    {
     lappend event_output "   set cycle_init_flag FALSE"
    }
    break
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
 MOM_bore_manual_dwell   -
 MOM_tap_deep            -
 MOM_tap_break_chip      -
 MOM_tap_float          \
 {
  lappend event_output "  global cycle_name"
  lappend event_output "  global cycle_init_flag"
  lappend event_output ""
  append event_move $evt_name _move
  set cycle_name [string toupper [string trimleft $evt_name MOM_]]
  set cycle_init_flag TRUE
  lappend event_output "   set cycle_init_flag $cycle_init_flag"
  lappend event_output "   set cycle_name $cycle_name"
  if { [string compare $evt_name "MOM_thread"] && [string compare $evt_name "MOM_lathe_thread"] } {
   lappend event_output "   CYCLE_SET"
  }
  PB_output_CallDebugMsg E event_output
 lappend event_output "\}"
 lappend event_output "\n"
 lappend event_output "#============================================================="

#=======================================================================
lappend event_output "proc $event_move \{ \} \{"
  lappend event_output "#============================================================="
  PB_output_CallDebugMsg S event_output
  lappend event_output "   global cycle_init_flag"
  lappend event_output ""
  lappend event_output ""
  lappend event_output "   global mom_sys_abort_next_event"
  lappend event_output "   if { \[info exists mom_sys_abort_next_event\] } {"
   lappend event_output "      if { \[llength \[info commands PB_CMD_kin_abort_event\]\] } {"
    lappend event_output "         PB_CMD_kin_abort_event"
   lappend event_output "      }"
  lappend event_output "   }"
  lappend event_output ""
  lappend event_output ""
  if { $::env(PB_UDE_ENABLED) == 1 } {
   set sys_cyc [list]
   PB_ude_RetUdeUdcObjList sys_mce non_sys_mce sys_cyc non_sys_cyc
   if { [llength $sys_cyc] > 0 } {
    foreach obj $sys_cyc {
     set name [PB_ude_GetEventName $obj]
     set name [string tolower $name]
     set name [join [split $name " "] _]
     set name "MOM_$name"
     if { ![string compare $name $evt_name] } {
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
   if { [info exists mom_sys_arr(Output_VNC)] && $mom_sys_arr(Output_VNC) == 1 } {
    lappend event_output "   global sim_mtd_initialized"
    lappend event_output "   if \$sim_mtd_initialized {"
     lappend event_output "      if \[llength \[info commands PB_VNC_pass_cycle_spindle_axis\]\] {"
      lappend event_output "         PB_VNC_pass_cycle_spindle_axis"
     lappend event_output "      }"
    lappend event_output "   }"
    lappend event_output ""
   }
  }
  if { ![string compare $evt_name "MOM_lathe_thread"] } {
   lappend event_output "   PB_LATHE_THREAD_SET"
  }
  unset event_move
 }
 MOM_cycle_plane_change \
 {
  lappend event_output "  global cycle_init_flag"
  lappend event_output "  global mom_cycle_tool_axis_change"
  lappend event_output "  global mom_cycle_clearance_plane_change"
  lappend event_output ""
  set cycle_init_flag TRUE
  lappend event_output "   set cycle_init_flag $cycle_init_flag"
 }
 MOM_thread_move         -
 MOM_lathe_thread_move   \
 {
  lappend event_output ""
  lappend event_output "   global mom_sys_abort_next_event"
  lappend event_output "   if { \[info exists mom_sys_abort_next_event\] } {"
   lappend event_output "      if { \[llength \[info commands PB_CMD_kin_abort_event\]\] } {"
    lappend event_output "         PB_CMD_kin_abort_event"
   lappend event_output "      }"
  lappend event_output "   }"
  lappend event_output ""
  lappend event_output ""
  lappend event_output "   PB_LATHE_THREAD_SET"
 }
 MOM_circular_move \
 {
  lappend event_output ""
  lappend event_output "   global mom_sys_abort_next_event"
  lappend event_output "   if { \[info exists mom_sys_abort_next_event\] } {"
   lappend event_output "      if { \[llength \[info commands PB_CMD_kin_abort_event\]\] } {"
    lappend event_output "         PB_CMD_kin_abort_event"
   lappend event_output "      }"
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
  if { [string match "*_wedm" $cur_machine] } {
   lappend event_output "  global mom_motion_event mom_motion_type"
   } else {
   lappend event_output "  global mom_feed_rate mom_feed_rate_per_rev mom_motion_type"
   lappend event_output "  global mom_kin_max_fpm mom_motion_event"  ; #4202839
   lappend event_output "   COOLANT_SET ; CUTCOM_SET ; SPINDLE_SET ; RAPID_SET"
  }
 }
 MOM_linear_move_30Apr2001_4263669 \
 {
  lappend event_output "  global mom_feed_rate mom_feed_rate_per_rev mom_kin_max_fpm first_linear_move"
  if { ![string compare [PB2TCL_read_fly_var mom_fly_use_rapid_at_max_fpm] "TRUE"] } \
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
  if { ![string compare [PB2TCL_read_fly_var mom_fly_use_rapid_at_max_fpm] "TRUE"] } \
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
  if { ![string compare [PB2TCL_read_fly_var mom_fly_use_rapid_at_max_fpm] "TRUE"] } \
  {
   lappend event_output "  global feed_mode mom_feed_rate mom_kin_rapid_feed_rate"
   lappend event_output ""
   lappend event_output "   if \{ \!\[string compare \$feed_mode \"IPM\"\] \|\| \!\[string compare \$feed_mode \"MMPM\"\] \} \{"
    lappend event_output "      if \{ \[EQ_is_ge \$mom_feed_rate \$mom_kin_rapid_feed_rate\] \} \{"
     lappend event_output "         MOM_rapid_move"
     PB_output_CallDebugMsg R event_output 1
     lappend event_output "         return"
    lappend event_output "      \}"
   lappend event_output "   \}"
   lappend event_output ""
  }
  lappend event_output ""
  lappend event_output "   global mom_sys_abort_next_event"
  lappend event_output "   if { \[info exists mom_sys_abort_next_event\] } {"
   lappend event_output "      if { \[llength \[info commands PB_CMD_kin_abort_event\]\] } {"
    lappend event_output "         PB_CMD_kin_abort_event"
   lappend event_output "      }"
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
  if { ![string compare [PB2TCL_read_fly_var mom_fly_cutcom_off_before_change] "TRUE"] } \
  {
   lappend event_output "  global mom_cutcom_status"
   lappend event_output ""
   lappend event_output "   if \{ \[string compare \$mom_cutcom_status \"SAME\"\] \} \{ MOM_cutcom_off \}"
  }
  lappend event_output "   CUTCOM_SET"
  lappend event_output ""
  lappend event_output "   global mom_cutcom_adjust_register"
  lappend event_output "   set cutcom_register_min $mom_sys_arr(\$rad_offset_min)"
  lappend event_output "   set cutcom_register_max $mom_sys_arr(\$rad_offset_max)"
  lappend event_output "   if { \[info exists mom_cutcom_adjust_register\] } {"
   lappend event_output "      if { \$mom_cutcom_adjust_register < \$cutcom_register_min ||\\"
    lappend event_output "           \$mom_cutcom_adjust_register > \$cutcom_register_max } {"
    lappend event_output "         CATCH_WARNING \"CUTCOM register \$mom_cutcom_adjust_register\
    must be within the range between\
    $mom_sys_arr(\$rad_offset_min) and\
    $mom_sys_arr(\$rad_offset_max)\""
   lappend event_output "      }"
  lappend event_output "   }"
 }
 MOM_spindle_rpm   -
 MOM_spindle_css   { lappend event_output "   SPINDLE_SET" }
 MOM_tool_preselect \
 {
  lappend event_output "   global mom_tool_preselect_number mom_tool_number mom_next_tool_number"
  lappend event_output "   global mom_sys_tool_number_max mom_sys_tool_number_min"
  lappend event_output ""
  lappend event_output "   if { \[info exists mom_tool_preselect_number\] } {"
   lappend event_output "      if { \$mom_tool_preselect_number < \$mom_sys_tool_number_min || \\"
    lappend event_output "           \$mom_tool_preselect_number > \$mom_sys_tool_number_max } {"
    lappend event_output ""
    lappend event_output "         global mom_warning_info"
    lappend event_output "         set mom_warning_info \"Preselected Tool number (\$mom_tool_preselect_number) exceeds limits of\\"
    lappend event_output "                               (\$mom_sys_tool_number_min/\$mom_sys_tool_number_max)\""
    lappend event_output "         MOM_catch_warning"
   lappend event_output "      }"
   lappend event_output ""
   lappend event_output "      set mom_next_tool_number \$mom_tool_preselect_number"
  lappend event_output "   }"
  lappend event_output ""
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
  lappend event_output "   global mom_sys_abort_next_event"
  lappend event_output "   if { \[info exists mom_sys_abort_next_event\] } {"
   lappend event_output "      if { \[llength \[info commands PB_CMD_kin_abort_event\]\] } {"
    lappend event_output "         PB_CMD_kin_abort_event"
   lappend event_output "      }"
  lappend event_output "   }"
  lappend event_output ""
  lappend event_output ""
  lappend event_output "   set spindle_first NONE"
  lappend event_output ""
  lappend event_output "   set aa(0) X ; set aa(1) Y ; set aa(2) Z"
  lappend event_output "   RAPID_SET"
 }
 MOM_sequence_number   { lappend event_output "   SEQNO_SET" }
 MOM_set_modes         { lappend event_output "   MODES_SET" }
 MOM_length_compensation { lappend event_output "   TOOL_SET $evt_name" }
 MOM_start_of_path     \
 {
  lappend event_output "  global mom_sys_in_operation"
  lappend event_output "   set mom_sys_in_operation 1"
  lappend event_output ""
  lappend event_output "  global first_linear_move ; set first_linear_move 0"
  lappend event_output "   TOOL_SET $evt_name"
  lappend event_output ""
 }
 MOM_first_tool        \
 {
  lappend event_output "  global mom_sys_first_tool_handled"
  lappend event_output ""
  lappend event_output "  # First tool only gets handled once"
  lappend event_output "   if { \[info exists mom_sys_first_tool_handled\] } {"
   lappend event_output "      MOM_tool_change" ;# <== Is this necessary, since 1st tool has been handled once already?
   PB_output_CallDebugMsg R event_output 1
   lappend event_output "      return"
  lappend event_output "   }"
  lappend event_output ""
  lappend event_output "   set mom_sys_first_tool_handled 1"
  lappend event_output ""
  if 0 {
   lappend event_output "   global mom_tool_number"
   lappend event_output "   global mom_sys_tool_number_max mom_sys_tool_number_min"
   lappend event_output ""
   lappend event_output "   if { \$mom_tool_number < \$mom_sys_tool_number_min || \\"
    lappend event_output "        \$mom_tool_number > \$mom_sys_tool_number_max } {"
    lappend event_output ""
    lappend event_output "      global mom_warning_info"
    lappend event_output "      set mom_warning_info \"Tool number to be output (\$mom_tool_number) exceeds limits of\\"
    lappend event_output "                            (\$mom_sys_tool_number_min/\$mom_sys_tool_number_max)\""
    lappend event_output "      MOM_catch_warning"
   lappend event_output "   }"
   lappend event_output ""
  }
  if { [string compare $ind_head ""] } {
   lappend event_output "   PB_TURRET_HEAD_SET"
  }
 }
 MOM_load_tool         -
 MOM_tool_change       \
 {
  lappend event_output "   global mom_tool_change_type mom_manual_tool_change"
  lappend event_output "   global mom_tool_number mom_next_tool_number"
  lappend event_output "   global mom_sys_tool_number_max mom_sys_tool_number_min"
  lappend event_output ""
  lappend event_output "   if { \$mom_tool_number < \$mom_sys_tool_number_min || \\"
   lappend event_output "        \$mom_tool_number > \$mom_sys_tool_number_max } {"
   lappend event_output ""
   lappend event_output "      global mom_warning_info"
   lappend event_output "      set mom_warning_info \"Tool number to be output (\$mom_tool_number) exceeds limits of\\"
   lappend event_output "                            (\$mom_sys_tool_number_min/\$mom_sys_tool_number_max)\""
   lappend event_output "      MOM_catch_warning"
  lappend event_output "   }"
  lappend event_output ""
  if { [string compare $ind_head ""] } {
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
 default {}
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
  lappend event_output "   if \{ \!\[string compare \$spindle_first \"TRUE\"\] \} \{"
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
   lappend event_output "      if \{ \!\[string compare \$rapid_traverse_inhibit \"FALSE\"\] \} \{"
    __output_ForceRapidAddr event_output $rapid_traverse blk_mod_arr
    __out_ForceAddr event_output $rapid_traverse $lead_blanks $wpc_flag
    lappend event_output "         MOM_suppress once \$aa(\$mom_cycle_spindle_axis)"
    lappend event_output "         MOM_do_template \$traverse_block \$is_from"
    lappend event_output "         MOM_suppress off \$aa(\$mom_cycle_spindle_axis)"
   lappend event_output "      \}"
   lappend event_output "   \} elseif \{ \!\[string compare \$spindle_first \"FALSE\"\] \} \{"
   lappend event_output "      if \{ \!\[string compare \$rapid_traverse_inhibit \"FALSE\"\] \} \{"
    __output_ForceRapidAddr event_output $rapid_traverse blk_mod_arr
    __out_ForceAddr event_output $rapid_traverse $lead_blanks $wpc_flag
    lappend event_output "         MOM_suppress once \$aa(\$mom_cycle_spindle_axis)"
    lappend event_output "         MOM_do_template \$traverse_block \$is_from"
    lappend event_output "         MOM_suppress off \$aa(\$mom_cycle_spindle_axis)"
   lappend event_output "      \}"
   lappend event_output "      if \{ \!\[string compare \$rapid_spindle_inhibit \"FALSE\"\] \} \{"
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
proc PB_output_RapidEventData { EVENT_OUTPUT BLK_MOD_ARR OUTPUT_ATTR_ARR } {
  upvar $EVENT_OUTPUT event_output
  upvar $BLK_MOD_ARR blk_mod_arr
  upvar $OUTPUT_ATTR_ARR output_attr_arr
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
  lappend event_output "   if \{ \!\[string compare \$spindle_first \"TRUE\"\] \} \{"
   lappend event_output "      if \{ \!\[string compare \$rapid_spindle_inhibit \"FALSE\"\] \} \{"
    lappend event_output "         if \{ \[string compare \$spindle_block \"\"\] \} \{"
     __output_RapidBlkWithAttr event_output output_attr_arr 12 spindle
     lappend event_output "         \} else \{"
     lappend event_output "            MOM_output_literal \"\$co Rapid Spindle Block is empty! \$ci\""
    lappend event_output "         \}"
   lappend event_output "      \}"
   lappend event_output "      if \{ \!\[string compare \$rapid_traverse_inhibit \"FALSE\"\] \} \{"
    lappend event_output "         if \{ \[string compare \$traverse_block \"\"\] \} \{"
     __output_RapidBlkWithAttr event_output output_attr_arr 12 traverse
     lappend event_output "         \} else \{"
     lappend event_output "            MOM_output_literal \"\$co Rapid Traverse Block is empty! \$ci\""
    lappend event_output "         \}"
   lappend event_output "      \}"
   lappend event_output "   \} elseif \{ \!\[string compare \$spindle_first \"FALSE\"\] \} \{"
   lappend event_output "      if \{ \!\[string compare \$rapid_traverse_inhibit \"FALSE\"\] \} \{"
    lappend event_output "         if \{ \[string compare \$traverse_block \"\"\] \} \{"
     __output_RapidBlkWithAttr event_output output_attr_arr 12 traverse
     lappend event_output "         \} else \{"
     lappend event_output "            MOM_output_literal \"\$co Rapid Traverse Block is empty! \$ci\""
    lappend event_output "         \}"
   lappend event_output "      \}"
   lappend event_output "      if \{ \!\[string compare \$rapid_spindle_inhibit \"FALSE\"\] \} \{"
    lappend event_output "         if \{ \[string compare \$spindle_block \"\"\] \} \{"
     __output_RapidBlkWithAttr event_output output_attr_arr 12 spindle
     lappend event_output "         \} else \{"
     lappend event_output "            MOM_output_literal \"\$co Rapid Spindle Block is empty! \$ci\""
    lappend event_output "         \}"
   lappend event_output "      \}"
   lappend event_output "   \} else \{"
   __output_RapidBlkWithAttr event_output output_attr_arr 6 traverse $rapid_traverse
  lappend event_output "   \}"
 }

#=======================================================================
proc __output_RapidBlkWithAttr { EVENT_OUTPUT OUTPUT_ATTR_ARR n_blank \
  blk_type args } {
  upvar $EVENT_OUTPUT event_output
  upvar $OUTPUT_ATTR_ARR output_attr_arr
  set direct_blk_name_flag 0
  set direct_blk_name ""
  if { [string match "traverse" $blk_type] } {
   set force_name "mod_traverse"
   set block_name "traverse_block"
   if { [llength $args] } {
    set direct_blk_name [lindex $args 0]
    if { $direct_blk_name != "" } {
     set direct_blk_name_flag 1
    }
   }
   } elseif { [string match "spindle" $blk_type] } {
   set force_name "mod_spindle"
   set block_name "spindle_block"
   } else {
   UI_PB_debug_ForceMsg "+++++> Error arguments when calling __output_RapidBlkWithAttr <+++++"
   return
  }
  set blank_string ""
  if { $n_blank > 0 } {
   for { set i 0 } { $i < $n_blank } { incr i } {
    set blank_string "$blank_string "
   }
  }
  if { [info exists output_attr_arr($blk_type,cond_cmd)] } {
   set cond_cmd $output_attr_arr($blk_type,cond_cmd)
   set supp_flag $output_attr_arr($blk_type,supp_flag)
   if { $cond_cmd != "" } {
    lappend event_output "${blank_string}if \{ \[$cond_cmd\] \} \{"
     if { $supp_flag } {
      lappend event_output "${blank_string}   MOM_suppress once N"
     }
     lappend event_output "${blank_string}   PB_FORCE Once \$${force_name}"
     if { $direct_blk_name_flag } {
      lappend event_output "${blank_string}   MOM_do_template $direct_blk_name"
      } else {
      lappend event_output "${blank_string}   MOM_do_template \$${block_name}"
     }
     lappend event_output "${blank_string}\}"
    } else {
    if { $supp_flag } {
     lappend event_output "${blank_string}MOM_suppress once N"
    }
    lappend event_output "${blank_string}PB_FORCE Once \$${force_name}"
    if { $direct_blk_name_flag } {
     lappend event_output "${blank_string}MOM_do_template $direct_blk_name"
     } else {
     lappend event_output "${blank_string}MOM_do_template \$${block_name}"
    }
   }
   } else {
   lappend event_output "${blank_string}PB_FORCE Once \$${force_name}"
   if { $direct_blk_name_flag } {
    lappend event_output "${blank_string}MOM_do_template $direct_blk_name"
    } else {
    lappend event_output "${blank_string}MOM_do_template \$${block_name}"
   }
  }
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
proc __output_RapidAddrForce { EVENT_OUTPUT n_blank block_name FORCE_NAME_LIST } {
  upvar $EVENT_OUTPUT event_output
  upvar $FORCE_NAME_LIST force_name_list
  set new_mod_list ""
  UI_PB_debug_ForceMsg "+++++> Rapid block: $block_name  Addr forced: $force_name_list"
  global post_object
  Post::GetObjList $post_object address add_obj_list
  foreach add_name $force_name_list \
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
  if { [string compare $new_mod_list ""] } \
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
     default {}
    }
    if [string match "*mill*" $machine_type] { set machine_type mill }
    if { ![string compare $machine_type "mill"] } {
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
    if { [string compare $mod_list ""] } {
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
  EVENT_OUTPUT EVT_OBJ } {
  upvar $EVT_NAME evt_name
  upvar $EVT_BLOCKS evt_blocks   ;# array of list of blocks for the event
  upvar $BLK_MOD_ARR blk_mod_arr ;# blk_mod_arr($block_name)
  upvar $NO_OF_LISTS no_of_lists
  upvar $EVENT_OUTPUT event_output
  upvar $EVT_OBJ evt_obj
  global cycle_init_flag
  global mom_sys_arr      ;#<06-08-09 wbh>
  set cur_machine [PB2TCL_read_fly_var mom_fly_machine_type]
  set fourth_dirn [PB2TCL_read_fly_var mom_fly_4th_axis_direction]
  set fifth_dirn  [PB2TCL_read_fly_var mom_fly_5th_axis_direction]
  set is_done2 0
  if 0 {
   set move_event [string last "move" $evt_name]
   if { $move_event != -1 } \
   {
    if { ![string match "3_axis_mill_turn" $cur_machine] } {
     if { ![string compare $fourth_dirn "SIGN_DETERMINES_DIRECTION"] || \
     ![string compare $fifth_dirn "SIGN_DETERMINES_DIRECTION"] } \
     {
      lappend event_output "   PB_ROTARY_SIGN_SET"
     }
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
   default {}
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
    if { [info exists mom_sys_arr(post_startblk)] && \
    [string match $mom_sys_arr(post_startblk) $blk] } \
    {
     set has_cycle_start 1
     break
    }
   }
  }
  set need_close_brace 0
  set need_right_brace 0
  set elem_index 0
  set evt_elem_len 0
  if { $evt_obj > 0 } \
  {
   set evt_elem_len [llength $event::($evt_obj,evt_elem_list)]
  }
  global post_object
  set blk_item_list $Post::($post_object,blk_obj_list)
  set func_blk_list $Post::($post_object,function_blk_list)
  for { set jj 0 } { $jj <= $last_list } { incr jj } \
  {
   set sublist [lindex $evt_blocks $jj]
   set ii [llength $sublist]
   if { $ii <= 0 } { continue } ; #sublist is empty
   for { set kk 0 } { $kk < $ii } { incr kk } \
   {
    set block_name [lindex $sublist $kk]
    set cond_cmd ""
    set suppress_flag 0
    set force_name_list ""
    if { $elem_index < $evt_elem_len } \
    {
     set sub_evt_elem_list [lindex $event::($evt_obj,evt_elem_list) $elem_index]
     if { $sub_evt_elem_list != "" } \
     {
      set evt_elem_obj [lindex $sub_evt_elem_list 0]
      set cond_cmd_obj $event_element::($evt_elem_obj,exec_condition_obj)
      if { $cond_cmd_obj > 0 } \
      {
       set cond_cmd $command::($cond_cmd_obj,name)
      }
      set suppress_flag $event_element::($evt_elem_obj,suppress_flag)
      set temp_addr_list ""
      foreach temp_evt_elem $sub_evt_elem_list {
       if { $temp_addr_list == "" } {
        set temp_addr_list $event_element::($temp_evt_elem,force_addr_list)
        continue
       }
       foreach temp_addr_obj $event_element::($temp_evt_elem,force_addr_list) {
        if { [lsearch $temp_addr_list $temp_addr_obj] == -1 } {
         lappend temp_addr_list $temp_addr_obj
        }
       }
      }
      foreach temp_addr_obj $temp_addr_list {
       if { $address::($temp_addr_obj,word_status) == 0 } {
        lappend force_name_list $address::($temp_addr_obj,add_name)
       }
      }
     }
     incr elem_index
    }
    if { $need_close_brace  &&  ![string match "*post_retracto*" $block_name] } {
    lappend event_output "   \}"
    lappend event_output ""
    set need_close_brace 0
   }
   UI_PB_debug_ForceMsg "+++++> 1234 Block Name list : $block_name <+++++"
   set blk_name [lindex $block_name 0]
   set isupper [regexp {^[A-Z]+} $blk_name]
   if { [llength $block_name] == 1 } {
    set block_name [lindex $block_name 0]
   }
   set blk_obj 0
   if { [llength $block_name] == 1 } {
    PB_com_RetObjFrmName block_name blk_item_list blk_obj
   }
   set isMacro 0
   if { $blk_obj == 0 } \
   {
    if { [llength $block_name] > 1 } \
    {
     PB_evt_ReparserBlockName block_name
     PB_com_RetObjFrmName block_name func_blk_list blk_obj
     UI_PB_debug_ForceMsg "+++++> 1234 Block Name is Macro : $block_name  $blk_obj <+++++"
     if { $blk_obj != 0 } \
     {
      set isMacro 1
      set isupper 1
      if { [info exists block::($blk_obj,block_name)] } \
      {
       unset block::($blk_obj,block_name)
      }
     }
    }
   }
   set block_name $blk_name
   if { $isupper && ![info exists block::($blk_obj,block_name)] } \
   {
    if { !$is_done2 } {
     if { ![string compare $evt_name "MOM_tool_change"] } {
      set is_done2 1
      UI_PB_debug_ForceMsg "+++++> $evt_name is_done2=$is_done2 <+++++"
     }
    }
    if { $kk == 0 && ![string compare $cycle_init_flag "TRUE"] && $has_cycle_start } \
    {
     if { [string compare $pre_list $last_list] } \
     {
      set add_if_flag 1
      if { [info exists mom_sys_arr(post_startblk)] && \
      [string match $mom_sys_arr(post_startblk) $block_name] } \
      {
       set add_if_flag 0
      }
      if $add_if_flag \
      {
       lappend event_output "   if \{ \!\[string compare \$cycle_init_flag \"TRUE\"\] \} \{"
        set need_right_brace 1
       }
      }
     }
     if { $isMacro } \
     {
      PB_output_FunctionProc $blk_obj event_output cond_cmd suppress_flag $need_right_brace
     } else \
     {
      set temp_blank_prefix "   "
      if $need_right_brace {
       append temp_blank_prefix "   "
      }
      if { [info exists mom_sys_arr(post_startblk)] && \
      [string match $mom_sys_arr(post_startblk) $block_name] } \
      {
       lappend event_output "${temp_blank_prefix}if \{ \[llength \[info commands $block_name\]\] \} \{"
        set line_text "$block_name"
        set double_prefix "$temp_blank_prefix   "
        __outputExecAttr line_text double_prefix cond_cmd suppress_flag force_name_list event_output
        lappend event_output "${temp_blank_prefix}\}"
      } else \
      {
       if [string match "MOM_first_tool" $evt_name] {
        if { [info exists mom_sys_arr(Output_VNC)] && $mom_sys_arr(Output_VNC) == 1 } {
         if { ![info exists __vnc_data_4_1st_tool] } {
          lappend event_output ""
          lappend event_output "  # Pass tool name to VNC for simulation."
          lappend event_output "   global sim_mtd_initialized"
          lappend event_output "   if \$sim_mtd_initialized {"
           lappend event_output "      if \[llength \[info commands PB_VNC_pass_tool_data\] \] {"
            lappend event_output "         PB_VNC_pass_tool_data"
           lappend event_output "      }"
          lappend event_output "   }"
          lappend event_output ""
          set __vnc_data_4_1st_tool 1
         }
        }
       }
       set line_text "$block_name"
       __outputExecAttr line_text temp_blank_prefix cond_cmd suppress_flag force_name_list event_output
      }
     }
    } else \
    {
     if { ![string compare "MOM_rapid_move" $evt_name] } \
     {
      set rapid_traverse [PB2TCL_read_fly_var mom_fly_rapid_traverse_blk]
      if { ![string compare $rapid_traverse "$block_name"] } \
      {
       UI_PB_debug_ForceMsg "+++++> rapid_traverse: $rapid_traverse  original forced addr: $force_name_list"
       foreach temp_evt_elem $event::($evt_obj,evt_elem_list) {
        if { [string match "rapid_traverse" $event_element::($temp_evt_elem,evt_elem_name)] } \
        {
         if 0 {
          foreach temp_addr $event_element::($temp_evt_elem,force_addr_list) \
          {
           lappend force_name_list $address::($temp_addr,add_name)
          }
         }
         set temp_cmd_obj $event_element::($temp_evt_elem,exec_condition_obj)
         if { $temp_cmd_obj > 0 } \
         {
          set rapid_output_attr_arr(traverse,cond_cmd) $command::($temp_cmd_obj,name)
         } else \
         {
          set rapid_output_attr_arr(traverse,cond_cmd) ""
         }
         set rapid_output_attr_arr(traverse,supp_flag) $event_element::($temp_evt_elem,suppress_flag)
         break
        }
       }
       __output_RapidBlkElems event_output
       __output_RapidAddrForce event_output 3 "rapid_traverse" force_name_list
      }
      if { ![string compare $cur_machine "mill"] && \
      ![string compare [PB2TCL_read_fly_var mom_fly_work_plane_change] "TRUE"] } \
      {
       set rapid_spindle [PB2TCL_read_fly_var mom_fly_rapid_spindle_blk]
       if { ![string compare $rapid_spindle "$block_name"] } \
       {
        UI_PB_debug_ForceMsg "+++++> rapid_spindle: $rapid_spindle  original forced addr: $force_name_list"
        foreach temp_evt_elem $event::($evt_obj,evt_elem_list) {
         if { [string match "rapid_spindle" $event_element::($temp_evt_elem,evt_elem_name)] } \
         {
          if 0 {
           foreach temp_addr $event_element::($temp_evt_elem,force_addr_list) \
           {
            lappend force_name_list $address::($temp_addr,add_name)
           }
          }
          set temp_cmd_obj $event_element::($temp_evt_elem,exec_condition_obj)
          if { $temp_cmd_obj > 0 } \
          {
           set rapid_output_attr_arr(spindle,cond_cmd) $command::($temp_cmd_obj,name)
          } else \
          {
           set rapid_output_attr_arr(spindle,cond_cmd) ""
          }
          set rapid_output_attr_arr(spindle,supp_flag) $event_element::($temp_evt_elem,suppress_flag)
          break
         }
        }
        __output_RapidAddrForce event_output 3 "rapid_spindle" force_name_list
        PB_output_RapidEventData event_output blk_mod_arr rapid_output_attr_arr
        continue
        } elseif { ![string compare $rapid_traverse "$block_name"] } \
       {
        continue
       }
       set is_done2 1
       UI_PB_debug_ForceMsg "+++++> $evt_name is_done2=$is_done2 <+++++"
      }
     }
     switch $evt_name \
     {
      MOM_start_of_program \
      {
       __output_mom_do_template event_output 3 $block_name blk_mod_arr cond_cmd suppress_flag force_name_list
       set is_done2 1
       UI_PB_debug_ForceMsg "+++++> $evt_name is_done2=$is_done2 <+++++"
      }
      MOM_start_of_path    -
      MOM_return_motion    -
      MOM_end_of_path      -
      MOM_end_of_program   \
      {
       __output_mom_do_template event_output 3 $block_name blk_mod_arr cond_cmd suppress_flag force_name_list
       set is_done2 1
       UI_PB_debug_ForceMsg "+++++> $evt_name is_done2=$is_done2 <+++++"
      }
      default \
      {
       if { $jj <= $pre_list && [llength [lindex $evt_blocks $jj]] > 0 } \
       {
        if { $kk == 0 && ![string compare $cycle_init_flag "TRUE"] && $has_cycle_start } \
        {
         if { [string compare $pre_list $last_list] } \
         {
          lappend event_output "   if \{ \!\[string compare \$cycle_init_flag \"TRUE\"\] \} \{"
           set need_right_brace 1
          }
         }
         if { $need_right_brace } {
          __output_mom_do_template event_output 6 $block_name blk_mod_arr cond_cmd suppress_flag force_name_list
          } else {
          if 0 {
           if [string match "MOM_first_tool" $evt_name] {
            global mom_sys_arr
            if { [info exists mom_sys_arr(Output_VNC)] && $mom_sys_arr(Output_VNC) == 1 } {
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
          }
          __output_mom_do_template event_output 3 $block_name blk_mod_arr cond_cmd suppress_flag force_name_list
         }
         set is_done2 1
         UI_PB_debug_ForceMsg "+++++> $evt_name is_done2=$is_done2 <+++++"
         } elseif { ![string compare $jj $last_list] && [llength [lindex $evt_blocks $jj]] > 0 } \
        {
         if { ![string compare $cycle_init_flag "TRUE"]  &&  \
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
           __output_mom_do_template event_output 6 $block_name blk_mod_arr cond_cmd suppress_flag force_name_list
           } else {
           __output_mom_do_template event_output 3 $block_name blk_mod_arr cond_cmd suppress_flag force_name_list
          }
          if { $need_close_brace  &&  $kk == [expr $ii - 1] } {
          lappend event_output "   \}"
          lappend event_output ""
          set need_close_brace 0
         }
         set is_done2 1
         UI_PB_debug_ForceMsg "+++++> $evt_name is_done2=$is_done2 <+++++"
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
   if { ![string compare $jj $last_list]  &&  ![string compare $cycle_init_flag "TRUE"] } \
   {
    lappend event_output "   set cycle_init_flag FALSE"
    set cycle_init_flag FALSE
   }
  } ;# jj
  if 0 {
   if [string match MOM_first_tool $evt_name] {
    lappend event_output ""
    lappend event_output "   MOM_tool_change"
   }
  }
  if { $is_done2 == 0 } \
  {
   UI_PB_debug_ForceMsg "-----> $evt_name  is_done2=$is_done2  last_list=$last_list<-----"
   switch $evt_name \
   {
    MOM_first_tool {
     lappend event_output "   MOM_tool_change"
    }
    MOM_tool_change {
     lappend event_output "   if \{ \[info exists mom_tool_change_type\] \} \{"
      lappend event_output "      switch \$mom_tool_change_type \{"
       lappend event_output "         MANUAL \{ PB_manual_tool_change \}"
       lappend event_output "         AUTO   \{ PB_auto_tool_change \}"
      lappend event_output "      \}"
      lappend event_output "   \} elseif \{ \[info exists mom_manual_tool_change\] \} \{"
      lappend event_output "      if \{ \!\[string compare \$mom_manual_tool_change \"TRUE\"\] \} \{"
       lappend event_output "         PB_manual_tool_change"
      lappend event_output "      \}"
     lappend event_output "   \}"
    }
    MOM_gohome_move {
     lappend event_output "   MOM_rapid_move"
    }
    default {}
   }
  }
  switch $evt_name \
  {
   MOM_initial_move_old \
   {
    if { ![string compare [PB2TCL_read_fly_var mom_fly_use_rapid_at_max_fpm] "TRUE"] } \
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
    "   if \{ \!\[string compare \$mom_motion_type \"RAPID\"\] \} \{MOM_rapid_move\} else \{MOM_linear_move\}"
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
    if { [string match "*_wedm" $cur_machine] } {
     lappend event_output "   catch \{ MOM_\$mom_motion_event \}"
     } else {
     lappend event_output ""
     lappend event_output "  global mom_programmed_feed_rate"
     lappend event_output "   if \{ \[EQ_is_equal \$mom_programmed_feed_rate 0\] \} \{"
      lappend event_output "      MOM_rapid_move"
      lappend event_output "   \} else \{"
      lappend event_output "      MOM_linear_move"
     lappend event_output "   \}"
    }
   }
   MOM_first_move \
   {
    lappend event_output "   catch \{ MOM_\$mom_motion_event \}" ; #4202839
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
   default {}
  }
 }

#=======================================================================
proc __out_ForceAddr { EVENT_OUTPUT block_name lead_blanks flag } {
  upvar $EVENT_OUTPUT event_output
  set rapid_traverse [PB2TCL_read_fly_var mom_fly_rapid_traverse_blk]
  set rapid_spindle  [PB2TCL_read_fly_var mom_fly_rapid_spindle_blk]
  lappend event_output ""
  lappend event_output "${lead_blanks}if \{ \!\[string compare \$mom_motion_event \"initial_move\"\] ||\
   \!\[string compare \$mom_motion_event \"first_move\"\] \} \{"
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
proc PB_output_special_case_end { EVT_NAME EVENT_OUTPUT } {
  upvar $EVT_NAME evt_name
  upvar $EVENT_OUTPUT event_output
  if {$::env(PB_UDE_ENABLED) != 1} {
   return
  }
  if { ![string compare $evt_name "MOM_head"] } {
   __output_MOM_head_end event_output
  }
 }

#=======================================================================
proc PB_output_special_case_start { EVT_NAME EVENT_OUTPUT } {
  upvar $EVT_NAME evt_name
  upvar $EVENT_OUTPUT event_output
  if { $::env(PB_UDE_ENABLED) != 1 } {
   return
  }
  if { ![string compare $evt_name "MOM_head"] } {
   global mom_sys_arr
   if { [info exists mom_sys_arr(\$mom_sys_mill_turn_type)] && \
    [string match "SIMPLE_MILL_TURN" $mom_sys_arr(\$mom_sys_mill_turn_type)] } {
    } elseif { $mom_sys_arr(\$is_linked_post) == 1 } {
    __output_MOM_head_body event_output
    lappend event_output ""
   } ;# is_linked_post
  } ;# MOM_head
 }

#=======================================================================
proc PB_output_GetEventProcData { EVT_OBJ EVT_NAME EVT_BLOCKS BLK_MOD_ARR \
  EVENT_OUTPUT {udc_name_list ""} } {
  upvar $EVT_OBJ evt_obj
  upvar $EVT_NAME evt_name
  upvar $EVT_BLOCKS evt_blocks   ; #array of list of blocks for the event
  upvar $BLK_MOD_ARR blk_mod_arr ; #blk_mod_arr($block_name)
  upvar $EVENT_OUTPUT event_output
  global mom_sys_arr
  if { $::env(PB_UDE_ENABLED) == 1 } {
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
  PB_output_CallDebugMsg S event_output
  if {$::env(PB_UDE_ENABLED) == 1} {
   if [string match $evt_name "MOM_spindle_css"] {
    set evt_name "MOM_spindle"
    set changed_flag 1
   }
  }
  PB_output_special_case_start evt_name event_output
  if { $::env(PB_UDE_ENABLED) == 1 } {
   global post_object
   set udeobj $Post::($post_object,ude_obj)
   set event_obj_list $ude::($udeobj,event_obj_list)
   set csp_obj ""
   foreach event $event_obj_list {
    if 0 {
     set evt_class [string trim [classof $event] :]
     if { [string comp "ude_event" $evt_class] } {
      ${evt_class}::readvalue $event obj_attr
      UI_PB_debug_ForceMsg "*** Event: $event is $evt_class => [array get obj_attr]\n"
      continue
     }
    }
    set post_name $ude_event::($event,post_event)
    if { ![string compare $post_name ""] } {
     set post_name $ude_event::($event,name)
    }
    if { ![string compare $evt_name "MOM_cutcom_on"] || ![string compare $evt_name "MOM_cutcom_off"] } {
     set temp_evt_name "MOM_cutcom"
     } elseif { ![string compare $evt_name "MOM_spindle_rpm"] } {
     set temp_evt_name "MOM_spindle"
     } else {
     set temp_evt_name $evt_name
    }
    set post_name "MOM_${post_name}"
    if { ![string compare $post_name $temp_evt_name] } {
     set csp_obj $event
     break
    }
   }
   if { [string compare $csp_obj ""] } {
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
      if { [string compare $param_name "mom_command_status"] } {
       lappend event_output "   global $param_name"
      }
     }
    }
   }
  }
  if { [lsearch $udc_name_list $evt_name] >= 0 && $::env(PB_UDE_ENABLED) == 1 } {
   PB_output_DefaultDataForUDC evt_name event_output
   set cyc_evt_obj_list $ude::($udeobj,cyc_evt_obj_list)
   set csp_obj ""
   foreach cyc_evt $cyc_evt_obj_list {
    set post_name [string tolower $cycle_event::($cyc_evt,name)]
    set post_name MOM_${post_name}
    if { ![string compare $post_name $evt_name] } {
     set csp_obj $cyc_evt
     break
    }
   }
   if { [string compare $csp_obj ""] } {
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
    lappend event_output ""
    lappend event_output "   if \[llength \[info commands PB_CMD_kin_start_of_program\] \] \{"
     lappend event_output "      PB_CMD_kin_start_of_program"
    lappend event_output "   \}"
    lappend event_output ""
   }
   "PB_auto_tool_change" \
   {
    if { [info exists mom_sys_arr(Output_VNC)] && $mom_sys_arr(Output_VNC) == 1 } {
     lappend event_output ""
     lappend event_output "  # Pass tool name to VNC for simulation."
     lappend event_output "   global sim_mtd_initialized"
     lappend event_output "   if { \$sim_mtd_initialized } {"
      lappend event_output "      if { \[llength \[info commands PB_VNC_pass_tool_data\] \] } {"
       lappend event_output "         PB_VNC_pass_tool_data"
      lappend event_output "      }"
     lappend event_output "   }"
     lappend event_output ""
    }
    lappend event_output "   global mom_tool_number mom_next_tool_number"
    lappend event_output "   if { !\[info exists mom_next_tool_number\] } {"
     lappend event_output "      set mom_next_tool_number \$mom_tool_number"
    lappend event_output "   }"
    lappend event_output ""
   }
   "MOM_start_of_path" \
   {
    lappend event_output ""
    lappend event_output "  global mom_sys_add_cutting_time mom_sys_add_non_cutting_time"
    lappend event_output "  global mom_sys_machine_time mom_machine_time"
    lappend event_output "   set mom_sys_add_cutting_time 0.0"
    lappend event_output "   set mom_sys_add_non_cutting_time 0.0"
    lappend event_output "   set mom_sys_machine_time \$mom_machine_time"
    lappend event_output ""
    lappend event_output "   if \[llength \[info commands PB_CMD_kin_start_of_path\] \] \{"
     lappend event_output "      PB_CMD_kin_start_of_path"
    lappend event_output "   \}"
    lappend event_output ""
   }
   "PB_first_linear_move" \
   {
    lappend event_output "  global mom_sys_first_linear_move"
    lappend event_output ""
    lappend event_output "  # Set this variable to signal 1st linear move has been handled."
    lappend event_output "   set mom_sys_first_linear_move 1"
    lappend event_output ""
   }
   "MOM_end_of_path" \
   {
    lappend event_output "  global mom_sys_add_cutting_time mom_sys_add_non_cutting_time"
    lappend event_output "  global mom_cutting_time mom_machine_time"
    lappend event_output ""
    lappend event_output "  # Accumulated time should be in minutes."
    lappend event_output "   set mom_cutting_time \[expr \$mom_cutting_time + \$mom_sys_add_cutting_time\]"
    lappend event_output "   set mom_machine_time \[expr \$mom_machine_time + \$mom_sys_add_cutting_time +\
    \$mom_sys_add_non_cutting_time\]"
    lappend event_output "   MOM_reload_variable mom_cutting_time"
    lappend event_output "   MOM_reload_variable mom_machine_time"
    lappend event_output ""
    lappend event_output "   if \[llength \[info commands PB_CMD_kin_end_of_path\] \] \{"
     lappend event_output "      PB_CMD_kin_end_of_path"
    lappend event_output "   \}"
    lappend event_output ""
   }
   default {}
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
  if { $no_of_lists > 0 } \
  {
   PB_output_BlockOfAEvent evt_name evt_blocks blk_mod_arr \
   no_of_lists event_output evt_obj
  }
  if {[lsearch $udc_name_list $evt_name] >= 0} {
   if {$no_of_lists == 0} {
    lappend event_output "   set cycle_init_flag FALSE"
   }
  }
  switch $evt_name \
  {
   "PB_start_of_program" \
   {
    lappend event_output ""
    lappend event_output "   if \[llength \[info commands PB_CMD_kin_start_of_program_2\] \] {"
     lappend event_output "      PB_CMD_kin_start_of_program_2"
    lappend event_output "   }"
   }
   "MOM_start_of_path" \
   {
    if { [info exists mom_sys_arr(Output_VNC)] && $mom_sys_arr(Output_VNC) == 1 } {
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
    if { [info exists mom_sys_arr(Output_VNC)] && $mom_sys_arr(Output_VNC) == 1 } {
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
    lappend event_output ""
    lappend event_output "   if \[llength \[info commands PB_CMD_kin_end_of_program\] \] {"
     lappend event_output "      PB_CMD_kin_end_of_program"
    lappend event_output "   }"
    if { [info exists mom_sys_arr(Output_VNC)] && $mom_sys_arr(Output_VNC) == 1 } {
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
   default {}
  }
  PB_output_CallDebugMsg E event_output
 lappend event_output "\}" ;# end of proc
 if [info exists changed_flag] {
  set evt_name "MOM_spindle_css"
 }
}

#=======================================================================
proc PB_PB2TCL_write___log_revisions { TCLF_ID } {
  upvar $TCLF_ID tclf_id
  global post_object  gPB
  global mom_sim_arr mom_sys_arr
  PB_output_GetCmdBlkProcs cmd_blk_list cmd_proc_arr
  set cmd_blk "PB_CMD___log_revisions"
  if [info exists cmd_proc_arr($cmd_blk)] {
   puts $tclf_id "\n"
   puts $tclf_id "#============================================================="

#=======================================================================
puts $tclf_id "proc $cmd_blk \{ \} \{"
  puts $tclf_id "#============================================================="
  foreach line $cmd_proc_arr($cmd_blk) {
   puts $tclf_id "$line"
  }
 puts $tclf_id "\}"
 puts $tclf_id "\n"
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
  if { ![info exists ::gPB(PB_POST_DEBUG_exclude)] } {
   set ::gPB(PB_POST_DEBUG_exclude) [list]
  }
  foreach cmd_blk $cmd_blk_list \
  {
   switch $file_type {
    "POST" {
     if { ![string match "*PB_CMD_vnc_*" $cmd_blk] } {
      if [string match "PB_CMD___log_revisions" $cmd_blk] { continue }
      puts $tclf_id "\n"
      puts $tclf_id "#============================================================="

#=======================================================================
puts $tclf_id "proc $cmd_blk \{ \} \{"
  puts $tclf_id "#============================================================="
  if { ![info exists ::gPB(PB_POST_DEBUG)] || \
   [string length [string trim $::gPB(PB_POST_DEBUG)]] == 0 } {
   set __add_debug_call 0
   } else {
   set __add_debug_call 1
  }
  if { [string first "$::gPB(PB_POST_DEBUG_command)" $cmd_proc_arr($cmd_blk)] >= 0 } {
   if { $__add_debug_call == 0 } {
    set __add_debug_call -1
    } else {
    set __add_debug_call 0
   }
  }
  if { $__add_debug_call == 1 } {
   set __add_debug_call_start 1
   } else {
   set __add_debug_call_start 0
  }
  if { $__add_debug_call_start != 0  ||  $__add_debug_call != 0 } {
   if { [lsearch $::gPB(PB_POST_DEBUG_exclude) $cmd_blk] >= 0 || \
    [string match "*_log_revisions"        $cmd_blk]      || \
    [string match "*_before_output"        $cmd_blk] } {
    set __add_debug_call_start 0
    set __add_debug_call 0
   }
  }
  if { $__add_debug_call_start == 1 } {
   PB_output_CallDebugMsg S $tclf_id
   set __add_debug_call_start 0
  }
  set __last_return 0
  set ret_idx 0
  foreach line $cmd_proc_arr($cmd_blk) \
  {
   set __last_return 0
   if { [string first "\#" [string trim $line]] < 0 } {  ;# Not a comment line
    if { $__add_debug_call == -1 } {
     if { [string first "$::gPB(PB_POST_DEBUG_command) RETURN" $line] >= 0 } {
      set line [string map [list "$::gPB(PB_POST_DEBUG_command) RETURN [incr ret_idx]\; return" "return"] $line]
      } elseif { [string first "$::gPB(PB_POST_DEBUG_command)" $line] >= 0 } {
      continue
     }
     } elseif { $__add_debug_call == 1 } {
     set irs [string first "return" $line]
     if { $irs >= 0 } {
      set ire [expr $irs + 6]
      if { $irs != [string wordstart $line $irs] || \
       $ire != [string wordend   $line $irs] } {
       set irs -1
      }
     }
     if { $irs >= 0 } {
      set line [string map [list "return" "$::gPB(PB_POST_DEBUG_command) RETURN [incr ret_idx]\; return"] $line]
      set __last_return 1
     }
    }
   }
   puts $tclf_id "$line"
  }
  if { $__add_debug_call == 1 } {
   if { $__last_return == 0 } {
    PB_output_CallDebugMsg E $tclf_id
   }
  }
 puts $tclf_id "\}"
}
}
"VNC" {
if { [string match "*PB_CMD_vnc_*" $cmd_blk] } {
 if { ( [string match "Standalone" $mom_sys_arr(VNC_Mode)] &&  \
  [lsearch $mom_sim_arr(\$mom_sim_vnc_com_list) $cmd_blk] >= 0 ) || \
  ( [string match "Subordinate" $mom_sys_arr(VNC_Mode)] &&  \
  [lsearch $mom_sim_arr(\$mom_sim_sub_vnc_list) $cmd_blk] >= 0 ) } {
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
default {}
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
   if { ![info exists ::gPB(PB_POST_DEBUG_exclude)] } {
    set ::gPB(PB_POST_DEBUG_exclude) [list]
   }
   foreach proc_name $proc_list \
   {
    if { [string match "USER_DEF_AXIS_LIMIT_ACTION" $proc_name] || \
     [string match "PB_user_def_axis_limit_action" $proc_name] } {
     continue
    }
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
puts $tclf_id "proc $proc_name \{ [join $proc_data($proc_name,args)] \} \{"
  if { ![info exists ::gPB(PB_POST_DEBUG)] || \
   [string length [string trim $::gPB(PB_POST_DEBUG)]] == 0 } {
   set __add_debug_call 0
   } else {
   set __add_debug_call 1
  }
  if { [string first "$::gPB(PB_POST_DEBUG_command)" $proc_data($proc_name,proc)] > 0 } {
   if { $__add_debug_call == 0 } {
    set __add_debug_call -1
    } else {
    set __add_debug_call 0
   }
  }
  if { $__add_debug_call == 1 } {
   set __add_debug_call_start 1
   } else {
   set __add_debug_call_start 0
  }
  if { $__add_debug_call_start != 0  ||  $__add_debug_call != 0 } {
   if { [lsearch $::gPB(PB_POST_DEBUG_exclude) $proc_name] >= 0 } {
    set __add_debug_call_start 0
    set __add_debug_call 0
   }
  }
  set __last_return 0
  set ret_idx 0
  foreach line $proc_data($proc_name,proc) \
  {
   set __last_return 0
   if 0 {
    if { $__add_debug_call == -1 } {
     if { [string first "$::gPB(PB_POST_DEBUG_command)" $line] > 0 } {
      continue
     }
    }
   }
   if { [string first "\#" [string trim $line]] < 0 } {  ;# Not a comment line
    if { $__add_debug_call == -1 } {
     if { [string first "$::gPB(PB_POST_DEBUG_command) RETURN" $line] >= 0 } {
      set line [string map [list "$::gPB(PB_POST_DEBUG_command) RETURN [incr ret_idx]\; return" "return"] $line]
      } elseif { [string first "$::gPB(PB_POST_DEBUG_command)" $line] >= 0 } {
      continue
     }
     } elseif { $__add_debug_call == 1 } {
     set irs [string first "return" $line]
     if { $irs >= 0 } {
      set ire [expr $irs + 6]
      if { $irs != [string wordstart $line $irs] || \
       $ire != [string wordend   $line $irs] } {
       set irs -1
      }
     }
     if { $irs >= 0 } {
      set line [string map [list "return" "$::gPB(PB_POST_DEBUG_command) RETURN [incr ret_idx]\; return"] $line]
      set __last_return 1
     }
    }
   }
   puts $tclf_id "$line"
   if { $__add_debug_call_start == 1 } {
    if [string match "#============*" $line] {
     PB_output_CallDebugMsg S $tclf_id
     set __add_debug_call_start 0
    }
   }
  }
  if { $__add_debug_call == 1 } {
   if { $__last_return == 0 } {
    PB_output_CallDebugMsg E $tclf_id
   }
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
  PB_output_CallDebugMsg S $tclf_id
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
  PB_output_CallDebugMsg E $tclf_id
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
    puts $tclf_id  "     set [format "%-40s  %$::gPB(val_fmt)" $list_name_arr($count) \
    \"$list_val_arr($count)\"]"
   }
  }
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
  puts $tclf_id "      if { \[llength \[info commands PB_CMD_kin_before_output\]\] &&\\"
   puts $tclf_id "           \[llength \[info commands PB_CMD_before_output\]\] } {"
   puts $tclf_id ""
   puts $tclf_id "         PB_CMD_kin_before_output"
  puts $tclf_id "      }"
  puts $tclf_id ""
  puts $tclf_id "   ######### The following procedure invokes the listing file with warnings."
  puts $tclf_id ""
  puts $tclf_id "      global mom_sys_list_output"
  puts $tclf_id "      if { \[string match \"ON\" \$mom_sys_list_output\] } {"
   puts $tclf_id "         LIST_FILE"
   puts $tclf_id "      } else {"
   puts $tclf_id "         global tape_bytes mom_o_buffer"
   puts $tclf_id "         if { !\[info exists tape_bytes\] } {"
    puts $tclf_id "            set tape_bytes \[string length \$mom_o_buffer\]"
    puts $tclf_id "         } else {"
    puts $tclf_id "            incr tape_bytes \[string length \$mom_o_buffer\]"
   puts $tclf_id "         }"
  puts $tclf_id "      }"
 puts $tclf_id "   }"
 puts $tclf_id "\n"
 puts $tclf_id "     if { \[string match \"OFF\" \[MOM_ask_env_var UGII_CAM_POST_LINK_VAR_MODE\]\] } {"
  puts $tclf_id "        set [format %-40s mom_sys_link_var_mode]  \"OFF\""
  puts $tclf_id "     } else {"
  puts $tclf_id "        set [format %-40s mom_sys_link_var_mode]  \"\$mom_sys_pb_link_var_mode\""
 puts $tclf_id "     }"
 puts $tclf_id ""
}

#=======================================================================
proc PB_PB2TCL_SourceUserTclFile__01-04-10 { TCLF_ID } {
  upvar $TCLF_ID tclf_id
  global post_object
  global ListObjectAttr
  set list_file_obj $Post::($post_object,list_obj_list)
  if { $ListingFile::($list_file_obj,usertcl_check) == 1 } {
   set user_tcl [string trim $ListingFile::($list_file_obj,usertcl_name)]
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

#=======================================================================
proc PB_PB2TCL_SourceUserTclFile { TCLF_ID } {
  upvar $TCLF_ID tclf_id
  global post_object
  global ListObjectAttr
  set list_file_obj $Post::($post_object,list_obj_list)
  if { $ListingFile::($list_file_obj,usertcl_check) } {
   set user_tcl [string trim $ListingFile::($list_file_obj,usertcl_name)]
   regsub -all {\\} $user_tcl {/} user_tcl
   puts $tclf_id "set cam_post_user_tcl \"$user_tcl\""
   puts $tclf_id "\n"
   puts $tclf_id "\n"
   puts $tclf_id "#***************************"
   puts $tclf_id "# Source in user's tcl file."
   puts $tclf_id "#***************************"
   puts $tclf_id "set cam_post_dir \[MOM_ask_env_var UGII_CAM_POST_DIR\]"
   puts $tclf_id "set ugii_version \[string trimleft \[MOM_ask_env_var UGII_VERSION\] v\]"
   puts $tclf_id ""
   puts $tclf_id "if { \[catch {"
     puts $tclf_id "   if { \$ugii_version >= 5 } {"
      puts $tclf_id "      if { \[file exists \"\[file dirname \[info script\]\]/\$cam_post_user_tcl\"\] } {"
       puts $tclf_id "        # From directory relative to that of current post"
       puts $tclf_id "         source \"\[file dirname \[info script\]\]/\$cam_post_user_tcl\""
       puts $tclf_id "      } elseif { \[file exists \"\${cam_post_dir}\$cam_post_user_tcl\"\] } {"
       puts $tclf_id "        # From directory relative to UGII_CAM_POST_DIR"
       puts $tclf_id "         source \"\${cam_post_dir}\$cam_post_user_tcl\""
       puts $tclf_id "      } elseif { \[file exists \"\$cam_post_user_tcl\"\] } {"
       puts $tclf_id "        # From the specified directory"
       puts $tclf_id "         source \"\$cam_post_user_tcl\""
       puts $tclf_id "      } else {"
       puts $tclf_id "         MOM_output_to_listing_device \"User's Tcl: \$cam_post_user_tcl not found!\""
      puts $tclf_id "      }"
      puts $tclf_id "   } else {"
      puts $tclf_id "      if { \[file exists \"\${cam_post_dir}\$cam_post_user_tcl\"\] } {"
       puts $tclf_id "         source \"\${cam_post_dir}\$cam_post_user_tcl\""
       puts $tclf_id "      } else {"
       puts $tclf_id "         MOM_output_to_listing_device \"User's Tcl: \${cam_post_dir}\$cam_post_user_tcl not found!\""
      puts $tclf_id "      }"
     puts $tclf_id "   }"
     puts $tclf_id "} err\] } {"
    puts $tclf_id "   MOM_output_to_listing_device \"User's Tcl: An error occured while sourcing \$cam_post_user_tcl!\\n\$err\""
    puts $tclf_id "   MOM_abort \"User's Tcl: An error occured while sourcing \$cam_post_user_tcl!\\n\$err\""
   puts $tclf_id "}"
   puts $tclf_id "\n"
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
  if 0 {
   puts $tclf_id "    # Pass control from UI to activate review tool (NX8)"
   puts $tclf_id "     if { \[info exists mom_activate_review_tool\] } {"
    puts $tclf_id "        if { \$mom_activate_review_tool } {"
     puts $tclf_id "           set mom_sys_debug_mode ON"
     puts $tclf_id "        } else {"
     puts $tclf_id "           set mom_sys_debug_mode OFF"
    puts $tclf_id "        }"
   puts $tclf_id "     }"
   puts $tclf_id " "
   puts $tclf_id " "
  }
  puts $tclf_id "     if { !\[info exists env(PB_SUPPRESS_UGPOST_DEBUG)\] } {"
   puts $tclf_id "        set env(PB_SUPPRESS_UGPOST_DEBUG) 0"
  puts $tclf_id "     }"
  puts $tclf_id " "
  puts $tclf_id "     if { \$env(PB_SUPPRESS_UGPOST_DEBUG) } {"
   puts $tclf_id "        set mom_sys_debug_mode OFF"
  puts $tclf_id "     }"
  puts $tclf_id " "
  puts $tclf_id "     if { \!\[string compare \$mom_sys_debug_mode \"OFF\"\] } {"
   puts $tclf_id " "

#=======================================================================
puts $tclf_id "        proc MOM_before_each_add_var {} {}"

#=======================================================================
puts $tclf_id "        proc MOM_before_each_event   {} {}"

#=======================================================================
puts $tclf_id "        proc MOM_before_load_address {} {}"

#=======================================================================
puts $tclf_id "        proc MOM_end_debug {} {}"
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
proc PB_lappend { LIST str } {
  global gPB
  upvar #$gPB(level) $LIST lst
  if { ![string compare $str "\n"] } {
   lappend lst {}
   lappend lst {}
   } else {
   lappend lst $str
  }
 }

#=======================================================================
proc PB_PB2TCL_write_post_header { tclf_id } {
  global gPB
  if { [info exist ::env(SUB_POST_MODE)] && $::env(SUB_POST_MODE) == 1 } \
  {
   if { [info exists ::env(UNIT_SUB_POST_MODE)] && $::env(UNIT_SUB_POST_MODE) == 1 } {
    PB_PB2TCL_write_sub_post_tcl tclf_id
    puts $tclf_id ""
    return
   }
  }
  PB_PB2TCL_write___log_revisions tclf_id
  puts $tclf_id ""
  puts $tclf_id "  set cam_post_dir \[MOM_ask_env_var UGII_CAM_POST_DIR\]"
  puts $tclf_id "  set this_post_dir \"\[file dirname \[info script\]\]\""
  puts $tclf_id ""
  puts $tclf_id ""
  puts $tclf_id "  if { !\[info exists mom_sys_post_initialized\] } {"
   puts $tclf_id ""
   puts $tclf_id "     if { !\[info exists mom_sys_ugpost_base_initialized\] } {"
    puts $tclf_id "        source \${cam_post_dir}ugpost_base.tcl"
    puts $tclf_id "        set mom_sys_ugpost_base_initialized 1"
   puts $tclf_id "     }"
   global mom_sys_arr
   if { [info exists mom_sys_arr(Inherit_UDE)] && $mom_sys_arr(Inherit_UDE) == 1 } {
    global ads_cdl_arr
    puts $tclf_id ""
    foreach ihr_cdl $ads_cdl_arr($ads_cdl_arr(type_inherit),cdl_list) {
     __ads_cdl_GetNativeCDLFileFrmListElem $ihr_cdl $ads_cdl_arr(type_inherit) temp_cdl_file
     set mom_sys_arr(PST_File_Folder) $temp_cdl_file(0)
     set mom_sys_arr(PST_File_Name)   $temp_cdl_file(1)
     set tcl_fn $mom_sys_arr(PST_File_Name).tcl
     puts $tclf_id ""
     puts $tclf_id ""
     puts $tclf_id "   ####  Include handler file for UDE of $tcl_fn"
     if { [string match $mom_sys_arr(PST_File_Folder) ""] } {
      puts $tclf_id "     if { \[file exists $tcl_fn\] } {"
       puts $tclf_id "        catch { source $tcl_fn }"
      puts $tclf_id "     }"
      } else {
      set folder $mom_sys_arr(PST_File_Folder)
      if { ![string match "*/" $folder] } {
       set folder "${folder}/"
      }
      if { [regexp {UGII[A-Za-z0-9_]+} $folder ugii_var] } {
       set ugii_var [string toupper $ugii_var]
       if { [regexp {^UGII_CAM_POST_DIR$} $ugii_var] } {
        regsub {(\$?)UGII[A-Za-z0-9_]+(/?)} $folder "\$\{cam_post_dir\}" folder
        puts $tclf_id "     if { \[file exists ${folder}$tcl_fn\] } {"
         puts $tclf_id "        catch { source ${folder}$tcl_fn }"
        puts $tclf_id "     }"
        } else {
        puts $tclf_id "     set [string tolower $ugii_var] \[MOM_ask_env_var $ugii_var\]"
        regsub {(\$?)UGII[A-Za-z0-9_]+(/?)} $folder "\$\{[string tolower $ugii_var]\}" folder
        puts $tclf_id "     if { \[file exists ${folder}$tcl_fn\] } {"
         puts $tclf_id "        catch { source ${folder}$tcl_fn }"
        puts $tclf_id "     }"
       }
       } else {
       puts $tclf_id "     if { \[file exists ${folder}$tcl_fn\] } {"
        puts $tclf_id "        catch { source ${folder}$tcl_fn }"
       puts $tclf_id "     }"
      }
     }
    }
    if { [llength $ads_cdl_arr($ads_cdl_arr(type_inherit),cdl_list)] > 0 } {
     puts $tclf_id ""
     puts $tclf_id "     if { \[info exists mom_sys_start_of_program_flag\] } {"
      puts $tclf_id "        unset mom_sys_start_of_program_flag"
     puts $tclf_id "     }"
     puts $tclf_id ""
     puts $tclf_id "     if { \[info exists mom_sys_head_change_init_program\] } {"
      puts $tclf_id "        unset mom_sys_head_change_init_program"
     puts $tclf_id "     }"
    }
   }
   PB_PB2TCL_write_reviewtool tclf_id
   puts $tclf_id ""
   puts $tclf_id ""
   PB_PB2TCL_write_list_file_var tclf_id
   puts $tclf_id ""
   global mom_sys_arr
   puts $tclf_id "     set [format "%-40s  %$::gPB(val_fmt)" "mom_sys_control_out" \
   \"[PB_output_EscapeSpecialControlChar $mom_sys_arr(Comment_Start)]\"]"
   puts $tclf_id "     set [format "%-40s  %$::gPB(val_fmt)" "mom_sys_control_in" \
   \"[PB_output_EscapeSpecialControlChar $mom_sys_arr(Comment_End)]\"]"
   puts $tclf_id ""
   if { [info exists ::env(PB_UDE_ENABLED)] && $::env(PB_UDE_ENABLED) == 1 } {
    puts $tclf_id ""
    puts $tclf_id "    # Retain UDE handlers of ugpost_base"
    puts $tclf_id "     foreach ude_handler { MOM_insert \\"
     puts $tclf_id "                           MOM_operator_message \\"
     puts $tclf_id "                           MOM_opskip_off \\"
     puts $tclf_id "                           MOM_opskip_on \\"
     puts $tclf_id "                           MOM_pprint \\"
     puts $tclf_id "                           MOM_text \\"
    puts $tclf_id "                         } \\"
    puts $tclf_id "     {"
     puts $tclf_id "        if { \[llength \[info commands \$ude_handler\]\] &&\\"
      puts $tclf_id "            !\[llength \[info commands ugpost_\${ude_handler}\]\] } {"
      puts $tclf_id "           rename \$ude_handler ugpost_\${ude_handler}"
     puts $tclf_id "        }"
    puts $tclf_id "     }"
    puts $tclf_id ""
   }
   if { [info exists ::gPB(PB_POST_DEBUG)] &&\
    [string length [string trim $::gPB(PB_POST_DEBUG)]] > 0 } {
    puts $tclf_id ""
    puts $tclf_id "     #----------------------------------"

#=======================================================================
puts $tclf_id "     proc $::gPB(PB_POST_DEBUG_command) { args } {"
  puts $tclf_id "     #----------------------------------"
  if 0 {
   puts $tclf_id "        OPERATOR_MSG \">>>>> Generic $::gPB(PB_POST_DEBUG_command) is in use.\
   You may import configurable command from \\\"pb_cmd_debug_utils.tcl\\\". <<<<<\""
  }
  puts $tclf_id "        set n_level \[expr 2*(\[info level\] - 1)\]"
  puts $tclf_id "        if { \$n_level < 0 } { set n_level 0 }"
  puts $tclf_id "        set indent \[format %\${n_level}c 32\]"
  puts $tclf_id ""
  puts $tclf_id "        OPERATOR_MSG \">>> \$indent \[info level -1\] - \[join \$args\]\""
 puts $tclf_id "     }"
 puts $tclf_id ""
}
puts $tclf_id ""
puts $tclf_id "     set mom_sys_post_initialized 1"
puts $tclf_id "  }"
puts $tclf_id ""
puts $tclf_id ""
set listfile_obj $Post::($::post_object,list_obj_list)
if { $ListingFile::($listfile_obj,use_default_unit_fragment) } {
set _switch  "ON"
} else {
set _switch  "OFF"
}
puts $tclf_id "  set [format "%-40s  %$::gPB(val_fmt)" mom_sys_use_default_unit_fragment \"$_switch\"]"
puts $tclf_id "  set [format "%-40s  %$::gPB(val_fmt)" mom_sys_alt_unit_post_name \
\"$ListingFile::($listfile_obj,alt_unit_post_name)\"]"
puts $tclf_id ""
puts $tclf_id ""
PB_PB2TCL_write_sys_var_arr tclf_id
puts $tclf_id ""
PB_PB2TCL_write_kin_var_arr tclf_id
puts $tclf_id ""
puts $tclf_id ""
}

#=======================================================================
proc PB_PB2TCL_write_license_tcl { tcl_file } {
  set tclf_id [PB_file_configure_output_file "$tcl_file"]
  global env gPB
  set time_string [clock format [clock seconds] -format "%c %Z"]
  puts $tclf_id "########################## TCL Event Handlers ##########################"
  puts $tclf_id "#"
  puts $tclf_id "#  [file tail $tcl_file] - $::mom_kin_var(\$mom_kin_machine_type)"
  puts $tclf_id "#"
  if [info exists gPB(post_description)] {
   foreach s $gPB(post_description) {
    puts $tclf_id "#    $s"
   }
   puts $tclf_id "#"
  }
  puts $tclf_id "#  Created by $env(USERNAME) @ $time_string"
  puts $tclf_id "#  with Post Builder version $gPB(Postbuilder_Release_Version)."
  puts $tclf_id "#"
  puts $tclf_id "########################################################################"
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
  PB_PB2TCL_write_post_header $tclf_id
  if 0 {
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
    puts $tclf_id "     set [format "%-40s  %$::gPB(val_fmt)" "mom_sys_control_out" \
    \"[PB_output_EscapeSpecialControlChar $mom_sys_arr(Comment_Start)]\"]"
    puts $tclf_id "     set [format "%-40s  %$::gPB(val_fmt)" "mom_sys_control_in" \
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
 }
 puts $tclf_id "catch {"
  puts $tclf_id "   MOM_run_user_function \${cam_aux_dir}mom_source.\$suff ufusr"
  puts $tclf_id "   MOM_decrypt_source \[file nativename \$encrypted_post_file\]"
 puts $tclf_id "}"
 puts $tclf_id ""
 close $tclf_id
}

#=======================================================================
proc PB_output_adjust_var_value { case {loc PST} } {
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
    if { ![string compare $gPB(session) "NEW"] } {
     if { $gPB(license_authorize) == 1 && [string compare $gPB(license_to_use) ""] } {
      set LicInfo(site_id) $gPB(PB_SITE_ID)
      set LicInfo(license) $gPB(license_to_use)
      set case 1
      set to_encrypt 1
      } else {
      set case 2
      set to_encrypt 0
     }
     } else {
     if { [info exists LicInfo(is_encrypted_file)] && $LicInfo(is_encrypted_file) == 1 } {
      if { ![string compare $gPB(PB_SITE_ID) $LicInfo(post_site_id)] } {
       if { [lsearch $gPB(lic_list) $LicInfo(post_license)] >= 0 } {
        if { $gPB(license_authorize) == 1 && [string compare $gPB(license_to_use) ""] } {
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
      if { $gPB(license_authorize) == 1 && [string compare $gPB(license_to_use) ""] } {
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
    if { ![string compare $gPB(session) "NEW"] } {
     set case 9
     set to_encrypt 0
     } else {
     if { [info exists LicInfo(is_encrypted_file)] && $LicInfo(is_encrypted_file) == 1 } {
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
   if { [info exists mom_sys_arr(Output_VNC)] != 1 || $mom_sys_arr(Output_VNC) == 0 }  {
    PB_output_adjust_var_value $case
   }
   } else {
   set to_encrypt 0
  }
  set alter_unit_sub_post 0
  if { [info exist ::env(SUB_POST_MODE)] && $::env(SUB_POST_MODE) == 1 } \
  {
   if { [info exists ::env(UNIT_SUB_POST_MODE)] && $::env(UNIT_SUB_POST_MODE) == 1 } {
    set to_encrypt 0
    set alter_unit_sub_post 1
   }
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
   set tclf_id [PB_file_configure_output_file "$tcl_file"]
  }
  set LicInfo(to_encrypt) $to_encrypt
  if { $to_encrypt == 1 } {
   set LicInfo(license_title)  $LicInfo(license)
  }
  set time_string [clock format [clock seconds] -format "%c %Z"]
  puts $tclf_id "########################## TCL Event Handlers ##########################"
  puts $tclf_id "#"
  puts $tclf_id "#  [file tail $tcl_file] - $::mom_kin_var(\$mom_kin_machine_type)"
  puts $tclf_id "#"
  if [info exists gPB(post_description)] {
   foreach s $gPB(post_description) {
    puts $tclf_id "#    $s"
   }
   puts $tclf_id "#"
  }
  puts $tclf_id "#  Created by $env(USERNAME) @ $time_string"
  puts $tclf_id "#  with Post Builder version $gPB(Postbuilder_Release_Version)."
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
   PB_PB2TCL_write_post_header $tclf_id
  } ;# if $to_encrypt != 1
  if { !$alter_unit_sub_post } {
   PB_PB2TCL_insert_axis_mult tclf_id $to_encrypt
   if { ![PB_file_is_JE_POST_DEV] } {
    PB_PB2TCL_write_local_procs tclf_id
   }
   if { ![PB_file_is_JE_POST_DEV] } {
    PB_PB2TCL_write_tcl_procs tclf_id
   }
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
  if { $to_encrypt == 1 } {
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
  set tclf_id [PB_file_configure_output_file "$vnc_file"]
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
  if { [info exists mom_sys_arr(Output_VNC)] && $mom_sys_arr(Output_VNC) == 1 } {
   if { $::disable_license == 0 } {
    set case ""
    if [string match "UG_POST_AUTHOR" $gPB(PB_LICENSE)] {
     if { ![string compare $gPB(session) "NEW"] } {
      if { $gPB(license_authorize) == 1 && [string compare $gPB(license_to_use_vnc) ""] } {
       set LicInfo(site_id) $gPB(PB_SITE_ID)
       set LicInfo(license) $gPB(license_to_use_vnc)
       set case 1
       set to_encrypt 1
       } else {
       set case 2
       set to_encrypt 0
      }
      } else {
      if { [info exists LicInfo(is_encrypted_file)] && $LicInfo(is_encrypted_file) == 1 } {
       if { ![string compare $gPB(PB_SITE_ID) $LicInfo(post_site_id)] } {
        if { [lsearch $gPB(lic_list) $LicInfo(post_license)] >= 0 } {
         if { $gPB(license_authorize) == 1 && [string compare $gPB(license_to_use_vnc) ""] } {
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
         if { [info exists LicInfo(post_license_vnc)] && [string compare $LicInfo(post_license_vnc) ""] } {
          set LicInfo(license) $LicInfo(post_license_vnc)
          set to_encrypt 1
          } else {
          set to_encrypt 0
         }
         set case 5
        }
        } else {
        set LicInfo(site_id) $LicInfo(post_site_id)
        if { [info exists LicInfo(post_license_vnc)] && [string compare $LicInfo(post_license_vnc) ""] } {
         set LicInfo(license) $LicInfo(post_license_vnc)
         set to_encrypt 1
         } else {
         set to_encrypt 0
        }
        set case 6
       }
       } else {
       if { $gPB(license_authorize) == 1 && [string compare $gPB(license_to_use_vnc) ""] } {
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
     if { ![string compare $gPB(session) "NEW"] } {
      set case 9
      set to_encrypt 0
      } else {
      if { [info exists LicInfo(is_encrypted_file)] && $LicInfo(is_encrypted_file) == 1 } {
       set LicInfo(site_id) $LicInfo(post_site_id)
       if { [info exists LicInfo(post_license_vnc)] && [string compare $LicInfo(post_license_vnc) ""] } {
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
    } else { ;# $::disable_license == 0
    set to_encrypt 0
   }
   if { $to_encrypt == 1 } {
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
    set tclf_id [PB_file_configure_output_file "$vnc_file"]
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
    if { $to_encrypt != 1 } {
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
    puts $tclf_id "# Clean up sub-VNC handlers"
    puts $tclf_id "#"
    puts $tclf_id "if { \[llength \[info commands \"PB_CMD_vnc____config_machine_tool_axes\"\]\] } {"
     puts $tclf_id "   rename PB_CMD_vnc____config_machine_tool_axes \"\""
    puts $tclf_id "}"
    puts $tclf_id "if { \[llength \[info commands \"PB_CMD_vnc__config_nc_definitions\"\]\] } {"
     puts $tclf_id "   rename PB_CMD_vnc__config_nc_definitions \"\""
    puts $tclf_id "}"
    puts $tclf_id ""
    puts $tclf_id ""
    puts $tclf_id ""
   }
   if { $to_encrypt != 1 } {
    PB_PB2VNC_write_nc_defs       tclf_id
   }
   PB_PB2TCL_write_command_procs tclf_id VNC
   if { $to_encrypt == 1 } {
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
  set vnc_base_ver [join [split $gPB(vnc_base_version) .] ""]
  set vnc_base     vnc_base_v${vnc_base_ver}
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
     puts $file_id "if { \[file exists \${cam_post_dir}${vnc_base}.tcl\] } {"
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
 puts $file_id "if { \[info exists mom_sim_vnc_base_version\] } {"
  puts $file_id "   set __vnc_base_version  \[join \[split \$mom_sim_vnc_base_version .\] \"\"\]"
  puts $file_id "} else {"
  puts $file_id "   set __vnc_base_version  0"
 puts $file_id "}"
 puts $file_id ""
 puts $file_id "if { \$__vnc_base_version < $vnc_base_ver } {"
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
puts $file_id "   proc MOM_SIM_execute_nc_command { } {"
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
puts $file_id "# Clean up sub-VNC handlers"
puts $file_id "#"
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
puts $file_id "# Clean up main-VNC handlers"
puts $file_id "#"
puts $file_id "if { \[llength \[info commands \"PB_CMD_vnc____config_machine_tool_axes\"\]\] } {"
puts $file_id "   rename PB_CMD_vnc____config_machine_tool_axes \"\""
puts $file_id "}"
puts $file_id "if { \[llength \[info commands \"PB_CMD_vnc____config_nc_definitions\"\]\] } {"
puts $file_id "   rename PB_CMD_vnc____config_nc_definitions \"\""
puts $file_id "}"
puts $file_id ""
puts $file_id ""
puts $file_id ""
}

#=======================================================================
proc PB_PB2VNC_set_other_code { cmd_blk } {
  global mom_sim_arr mom_sys_arr
  global post_object
  array set mom_sim_arr $Post::($post_object,mom_sim_var_list)
  set cmd_attr(0) $cmd_blk
  set cmd_attr(1) [list]
  lappend cmd_attr(1) "  global mom_sim_o_buffer"
  set oth_cod $mom_sim_arr(\$mom_sim_pre_com_list)
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
   lappend cmd_attr(1) "      set mom_sim_o_buffer \[PB_SIM_call $cmd_name\]"
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
  if { [llength $args] } {
   set re_flag 1
   } else {
   set re_flag 0
  }
  foreach sim_var $sim_var_list {
   set var [string trimleft $sim_var "\$"]
   if { [info exists mom_sim_arr($sim_var)] } {
    set val [set mom_sim_arr($sim_var)]
    } else {
    set val ""
   }
   if { [string match "" $val] } {
    continue
   }
   if { [llength $val] > 1 } {
    lappend cmd_attr(1) [format "%-52s  %s" "   set $var" "\[list $val\]"]
    } elseif { $re_flag == 1 } {
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
  if 0 {
   lappend cmd_attr(1) ""
   lappend cmd_attr(1) "  # Process legacy configuration, if any"
   lappend cmd_attr(1) "  #"
   lappend cmd_attr(1) "   PB_SIM_call PB_CMD_vnc____old_map_machine_tool_axes"
  }
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
    if { [info exists mom_sim_arr(\$mom_sim_mt_axis(4))] } {
     __PB2VNC_WriteMomSIMVar isv_mac_4thvar cmd_attr 1
     } else {
     lappend cmd_attr(1) [format "%-52s  %s" "         set mom_sim_mt_axis(4)" \"A\"]
     lappend cmd_attr(1) [format "%-52s  %s" "         set mom_sim_reverse_4th_table" 0]
     lappend cmd_attr(1) [format "%-52s  %s" "         set mom_sim_4th_axis_has_limits" 1]
    }
   lappend cmd_attr(1) "      \}"
   lappend cmd_attr(1) "      \"5\" \{"
    if { [info exists mom_sim_arr(\$mom_sim_mt_axis(5))] } {
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
  if 0 {
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
  }
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
  lappend cmd_attr(1) ""
  lappend cmd_attr(1) ""
  lappend cmd_attr(1) "  # Process custom configuration"
  lappend cmd_attr(1) "  #"
  lappend cmd_attr(1) "   PB_SIM_call PB_CMD_vnc____config_machine_tool_axes"
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
   lappend cmd_attr(1) "   if \{ \[llength \[info commands PB_CMD_vnc__config_nc_definitions\]\] \} \{"
    lappend cmd_attr(1) "     # Process custom configuration"
    lappend cmd_attr(1) "      PB_SIM_call PB_CMD_vnc__config_nc_definitions"
    lappend cmd_attr(1) "   \} else \{"
    lappend cmd_attr(1) "     # Inherit definitions from main VNC"
    lappend cmd_attr(1) "      PB_SIM_call PB_CMD_vnc____set_nc_definitions"
   lappend cmd_attr(1) "   \}"
   lappend cmd_attr(1) ""
   PB_pps_CreateCommand cmd_attr cmd_obj
   PB_int_UpdateCommandAdd cmd_obj
   return
  }
  set glob_var_list {"\$mom_sim_prog_rewind_stop_code" \
   "\$mom_sim_control_var_leader" \
   "\$mom_sim_control_equal_sign" \
   "\$mom_sim_incr_linear_addrs" \
   "\$mom_sim_rapid_dogleg" \
   "\$mom_sim_output_vnc_msg" \
   "\$mom_sim_pre_com_list" \
   "\$mom_sim_machine_zero_offsets" \
   "\$mom_sim_wcs_offsets" \
  "\$mom_sim_tool_data"}
  foreach glob $glob_var_list {
   set var [string trimleft $glob "\$"]
   lappend cmd_attr(1) "   global $var"
  }
  if [string match "XYZ" $mom_sim_arr(\$mom_sim_mode_leader)] {
   set mom_sim_arr(\$mom_sim_incr_linear_addrs) ""
  }
  if 0 {
   lappend cmd_attr(1) ""
   lappend cmd_attr(1) ""
   lappend cmd_attr(1) "   if \{ \[llength \[info commands PB_CMD_vnc____config_nc_definitions\]\] \} \{"
    lappend cmd_attr(1) "      PB_SIM_call PB_CMD_vnc____config_nc_definitions"
   lappend cmd_attr(1) "   \}"
  }
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
  lappend cmd_attr(1) ""
  lappend cmd_attr(1) ""
  lappend cmd_attr(1) "  # Process custom configuration"
  lappend cmd_attr(1) "  #"
  lappend cmd_attr(1) "   PB_SIM_call PB_CMD_vnc____config_nc_definitions"
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
  puts $file_id "  global mom_sim_tool_change_time"
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
    default {}
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
  __PB2VNC_WriteMomVar mom_kin_var "\$mom_kin_tool_change_time" r $file_id
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
  if { $blk_obj > 0 } {
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
  if { ![string compare $sim_var ""] } {
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
   if { ![string compare $type "s"] } {
    set val " "
   }
  }
  switch $type {
   i {
    if { ![string compare [string trim $val] ""] } {
     set val 0
    }
    set val [expr int($val)]
   }
   r {
    if { ![string compare [string trim $val] ""] } {
     set val 0.0
    }
    set val [expr double($val)]
   }
   default {}
  }
  return $val
 }

#=======================================================================
proc __output_CompactFile { src tgt } {
  set prev_end_char ""
  while { [eof $src] == 0 } {
   set line [string trim [gets $src]]
   if { ![string compare $line ""] } {
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
   if { ![string compare $end_char "\\"] } {
    set strend [expr [string length $line] - 1]
    set line [string range $line 0 [expr $strend - 1]]
    } elseif { [string compare $end_char "\{"]  &&  [string compare $end_char "\}"] } {
    set line "${line}\; "
   }
   set start_char [string index $line 0]
   if { [string compare $start_char "\{"]  &&  [string compare $start_char "\}"] } {
    if [string match "\}" $prev_end_char] {
    set line "\; ${line}"
   }
  }
  set line "${line} "
  set prev_end_char $end_char
  puts -nonewline $tgt $line
 }
}

#=======================================================================
proc PB_output_FunctionProc { func_obj EVENT_OUTPUT COND_CMD SUPPRESS_FLAG \
  right_brace } {
  global g_func_prefix
  upvar $EVENT_OUTPUT event_output
  upvar $COND_CMD cond_cmd
  upvar $SUPPRESS_FLAG suppress_flag
  if $right_brace {
   set leader "      "
   } else {
   set leader "   "
  }
  set row_disp ""
  if { $g_func_prefix == "" } \
  {
   append row_disp "[list PB_call_macro $function::($func_obj,id)]"
  } else \
  {
   append row_disp "[list PB_call_macro $function::($func_obj,id) $g_func_prefix]"
  }
  set force_name_list ""
  __outputExecAttr row_disp leader cond_cmd suppress_flag force_name_list event_output
 }

#=======================================================================
proc PB_PB2TCL_write_function_procs { TCLF_ID } {
  upvar $TCLF_ID tclf_id
  global post_object
  set func_obj_list $Post::($post_object,function_blk_list)
  if { [llength $func_obj_list] == 0 } { return }
  puts $tclf_id "\n"
  puts $tclf_id "#============================================================="

#=======================================================================
puts $tclf_id "proc PB_DEFINE_MACROS \{ \} \{"
  puts $tclf_id "#============================================================="
  PB_output_CallDebugMsg S $tclf_id
  puts $tclf_id "   global mom_pb_macro_arr"
  foreach func_obj $func_obj_list \
  {
   set func_name $function::($func_obj,id)
   if [string match "just_mcall_sinumerik" $func_name] \
   {
    continue
   }
   function::GetParamAttrList $func_obj param_attr_list
   set com_attr_list [list]
   lappend com_attr_list $function::($func_obj,disp_name) \
   $function::($func_obj,func_start) \
   $function::($func_obj,separator) \
   $function::($func_obj,func_end) \
   $function::($func_obj,output_param_name_flag) \
   $function::($func_obj,output_link_chars)
   puts $tclf_id ""
   puts $tclf_id "   set mom_pb_macro_arr($func_name) \\"
   puts $tclf_id "       \[list \{$com_attr_list\} \\"
   set len [llength $param_attr_list]
   if { $len == 0 } \
   {
    puts $tclf_id "        \{\}\]"
   } else \
   {
    set i 0
    foreach param_attr $param_attr_list \
    {
     if { $i == 0 } \
     {
      set temp_line "        \{\{$param_attr\}"
      } else \
      {
       set temp_line "         \{$param_attr\}"
      }
      incr i
      if { $i == $len } \
      {
      append temp_line "\}\]"
     } else \
     {
      append temp_line " \\"
     }
     puts $tclf_id $temp_line
    }
   }
  }
  PB_output_CallDebugMsg E $tclf_id
 puts $tclf_id "\}"
 puts $tclf_id "\n"
 puts $tclf_id "#============================================================="

#=======================================================================
puts $tclf_id "proc PB_call_macro \{ macro_name \{ prefix \"\" \} \{ suppress_seqno 0 \} args \} \{"
  puts $tclf_id "#============================================================="
  PB_output_CallDebugMsg S $tclf_id
  puts $tclf_id "   global mom_pb_macro_arr mom_warning_info"
  puts $tclf_id "   if \{ !\[info exists mom_pb_macro_arr(\$macro_name)\] \} \{"
   puts $tclf_id "      CATCH_WARNING \"Macro \$macro_name is not defined.\""
   PB_output_CallDebugMsg R $tclf_id 1
   puts $tclf_id "      return"
  puts $tclf_id "   \}"
  puts $tclf_id ""
  puts $tclf_id "   set macro_attr_list \$mom_pb_macro_arr(\$macro_name)"
  puts $tclf_id ""
  puts $tclf_id "   set com_attr_list  \[lindex \$macro_attr_list 0\]"
  puts $tclf_id "   set disp_name      \[lindex \$com_attr_list 0\]"
  puts $tclf_id "   set start_char     \[lindex \$com_attr_list 1\]"
  puts $tclf_id "   set separator_char \[lindex \$com_attr_list 2\]"
  puts $tclf_id "   set end_char       \[lindex \$com_attr_list 3\]"
  puts $tclf_id "   set link_flag      \[lindex \$com_attr_list 4\]"
  puts $tclf_id "   set link_char      \[lindex \$com_attr_list 5\]"
  puts $tclf_id ""
  puts $tclf_id "   set param_list     \[lindex \$macro_attr_list 1\]"
  puts $tclf_id ""
  puts $tclf_id "   set text_string \"\""
  puts $tclf_id "   if \{ \[string compare \$prefix \"\"\] != 0 \} \{"
   puts $tclf_id "       append text_string \$prefix \" \""
  puts $tclf_id "   \}"
  puts $tclf_id ""
  puts $tclf_id "   append text_string \$disp_name \$start_char"
  puts $tclf_id ""
  puts $tclf_id "   set g_vars_list \[list\]"
  puts $tclf_id "   set param_text_list \[list\]"
  puts $tclf_id "   set last_index 0"
  puts $tclf_id "   set count 0"
  puts $tclf_id "   foreach param_attr \$param_list \{"
   puts $tclf_id "      incr count"
   puts $tclf_id "      if \{ \[llength \$param_attr\] \> 0 \} \{"
    puts $tclf_id "         set exp \[lindex \$param_attr 0\]"
    puts $tclf_id "         if \{ \$exp == \"\" \} \{"
     puts $tclf_id "            lappend param_text_list \"\""
     puts $tclf_id "            continue"
    puts $tclf_id "         \}"
    puts $tclf_id ""
    puts $tclf_id "         set dtype \[lindex \$param_attr 1\]"
    puts $tclf_id "         if \{ \$dtype \} \{"
     puts $tclf_id "            set temp_cmd \"set data_val \\\[expr \\\$exp\\\]\""
     puts $tclf_id "         \} else \{"
     puts $tclf_id "            set temp_cmd \"set data_string \$exp\""
    puts $tclf_id "         \}"
    puts $tclf_id ""
    puts $tclf_id "         set break_flag 0"
    puts $tclf_id "         while \{ 1 \} \{"
     puts $tclf_id "            if \{ \[catch \{eval \$temp_cmd\} res_val\] \} \{"
      puts $tclf_id "               if \[string match \"*no such variable*\" \$res_val\] \{"
       puts $tclf_id "                  set __idx \[string first \":\" \$res_val\]"
       puts $tclf_id "                  if \{ \$__idx >= 0 \} \{"
        puts $tclf_id "                     set temp_res \[string range \$res_val 0 \[expr int(\$__idx - 1)\]\]"
        puts $tclf_id "                     set temp_var \[lindex \$temp_res end\]"
        puts $tclf_id "                     set temp_var \[string trim \$temp_var \"\\\"\"\]"
        puts $tclf_id "                     if \{ \[string index \$temp_var \[expr \[string length \$temp_var\] - 1\]\] == \")\" \} \{"
         puts $tclf_id "                        set __idx \[string first \"(\" \$temp_var\]"
         puts $tclf_id "                        set temp_var \[string range \$temp_var 0 \[expr int(\$__idx - 1)\]\]"
        puts $tclf_id "                     \}"
        puts $tclf_id ""
        puts $tclf_id "                     foreach one \$g_vars_list \{"
         puts $tclf_id "                        if \{ \[string compare \$temp_var \$one\] == 0 \} \{"
          puts $tclf_id "                           set break_flag 1"
         puts $tclf_id "                        \}"
        puts $tclf_id "                     \}"
        puts $tclf_id "                     lappend g_vars_list \$temp_var"
        puts $tclf_id "                     global \$temp_var"
        puts $tclf_id "                  \} else \{"
        puts $tclf_id "                     set break_flag 1"
       puts $tclf_id "                  \}"
       puts $tclf_id "               \} elseif \[string match \"*no such element*\" \$res_val\] \{"
       puts $tclf_id "                  set break_flag 1"
       puts $tclf_id "               \} else \{"
       puts $tclf_id "                  CATCH_WARNING \"Error to evaluate expression \$exp in \$macro_name: \$res_val\""
       PB_output_CallDebugMsg R $tclf_id 2
       puts $tclf_id "                  return"
      puts $tclf_id "               \}"
      puts $tclf_id "            \} else \{"
      puts $tclf_id "               break"
     puts $tclf_id "            \}"
     puts $tclf_id ""
     puts $tclf_id "            if \$break_flag \{"
      puts $tclf_id "               CATCH_WARNING \"Error to evaluate expression \$exp in \$macro_name: \$res_val\""
      puts $tclf_id "               set data_string \"\""
      puts $tclf_id "               break"
     puts $tclf_id "            \}"
    puts $tclf_id "         \}"
    puts $tclf_id ""
    puts $tclf_id "         if \{ !\$break_flag && \$dtype \} \{"
     puts $tclf_id "            set is_double \[lindex \$param_attr 2\]"
     puts $tclf_id "            set int_width \[lindex \$param_attr 3\]"
     puts $tclf_id "            set is_decimal \[lindex \$param_attr 4\]"
     puts $tclf_id ""
     puts $tclf_id "            set max_val \"1\""
     puts $tclf_id "            set min_val \"-1\""
     puts $tclf_id "            set zero_char \[string range \"000000000\" 0 \[expr \$int_width - 1\]\]"
     puts $tclf_id "            append max_val \$zero_char"
     puts $tclf_id "            append min_val \$zero_char"
     puts $tclf_id ""
     puts $tclf_id "            if \{ \[catch \{ expr \$data_val >= \$max_val \} comp_res\] \} \{"
      puts $tclf_id "               set data_string \"\""
      puts $tclf_id "               CATCH_WARNING \"Wrong data type to evaluate expression \$exp in \$macro_name: \$comp_res\""
      puts $tclf_id "            \} elseif \{ \$comp_res \} \{"
      puts $tclf_id "               set data_string \[expr \$max_val - 1\]"
      puts $tclf_id "               CATCH_WARNING \"MAX/MIN WARNING to evaluate expression \$exp in \$macro_name: MAX: \$data_string\""
      puts $tclf_id "            \} elseif \{ \[expr \$data_val <= \$min_val\] \} \{"
      puts $tclf_id "               set data_string \[expr \$min_val + 1\]"
      puts $tclf_id "               CATCH_WARNING \"MAX/MIN WARNING to evaluate expression \$exp in \$macro_name: MIN: \$data_string\""
      puts $tclf_id "            \} else \{"
      puts $tclf_id "               if \{ \$is_double \} \{"
       puts $tclf_id "                  set total_width \[expr \$int_width + \$is_double]"
       puts $tclf_id "                  catch \{ set data_string \[format \"\%\$\{total_width\}.\$\{is_double\}f\" \$data_val\] \}"
       puts $tclf_id "                  set data_string \[string trimleft \$data_string\]"
       puts $tclf_id "                  set data_string \[string trimright \$data_string\ 0]"
       puts $tclf_id "                  if \{ !\$is_decimal \} \{"
        puts $tclf_id "                     set dec_index \[string first . \$data_string\]"
        puts $tclf_id "                     set dec_str \[string range \$data_string 0 \[expr \$dec_index - 1\]\]"
        puts $tclf_id "                     append dec_str \[string range \$data_string \[expr \$dec_index + 1\] end\]"
        puts $tclf_id "                     set data_string \$dec_str"
       puts $tclf_id "                  \}"
       puts $tclf_id "               \} else \{"
       puts $tclf_id "                  set int_data \[expr \{ int(\$data_val) \}\]"
       puts $tclf_id "                  catch \{ set data_string \[format \"\%\$\{int_width\}d\" \$int_data\] \}"
       puts $tclf_id "                  set data_string \[string trimleft \$data_string\]"
       puts $tclf_id "                  if \{ \$is_decimal \} \{"
        puts $tclf_id "                     append data_string \".\""
       puts $tclf_id "                  \}"
      puts $tclf_id "               \}"
     puts $tclf_id "            \}"
    puts $tclf_id "         \}"
    puts $tclf_id ""
    puts $tclf_id "         if \{ \$link_flag \} \{"
     puts $tclf_id "            set temp_str \"\""
     puts $tclf_id "            append temp_str \[lindex \$param_attr end\] \$link_char \$data_string"
     puts $tclf_id "            set data_string \$temp_str"
    puts $tclf_id "         \}"
    puts $tclf_id "         lappend param_text_list \$data_string"
    puts $tclf_id ""
    puts $tclf_id "         if !\[string match \"\" \$data_string\] \{"
     puts $tclf_id "            set last_index \$count"
    puts $tclf_id "         \}"
    puts $tclf_id "      \} else \{"
    puts $tclf_id "         lappend param_text_list \"\""
   puts $tclf_id "      \}"
  puts $tclf_id "   \}"
  puts $tclf_id ""
  puts $tclf_id "   if \{ \$last_index \> 0 \} \{"
   puts $tclf_id "      if \{ \$last_index \< \$count \} \{"
    puts $tclf_id "         set param_text_list \[lreplace \$param_text_list \$last_index end\]"
   puts $tclf_id "      \}"
   puts $tclf_id "      append text_string \[join \$param_text_list \$separator_char\]"
  puts $tclf_id "   \}"
  puts $tclf_id ""
  puts $tclf_id "   append text_string \$end_char"
  puts $tclf_id ""
  puts $tclf_id "   if \{ \$suppress_seqno \} \{"
   puts $tclf_id "      MOM_suppress once N"
   puts $tclf_id "      MOM_output_literal \$text_string"
   puts $tclf_id "   \} else \{"
   puts $tclf_id "      MOM_output_literal \$text_string"
  puts $tclf_id "   \}"
  PB_output_CallDebugMsg E $tclf_id
 puts $tclf_id "\}"
}

#=======================================================================
proc __outputExecAttr { TEXT PREFIX COND_CMD SUPPRESS_FLAG FORCE_NAME_LIST \
  EVENT_OUTPUT } {
  upvar $TEXT   line_text
  upvar $PREFIX line_prefix
  upvar $COND_CMD cond_cmd
  upvar $SUPPRESS_FLAG flag
  upvar $FORCE_NAME_LIST force_name_list
  upvar $EVENT_OUTPUT event_output
  if { $cond_cmd != "" } {
   lappend event_output "${line_prefix}if \{ \[$cond_cmd\] \} \{"
    if { $flag } {
     lappend event_output "$line_prefix   MOM_suppress once N"
    }
    if { $force_name_list != "" } {
     lappend event_output "$line_prefix   MOM_force Once $force_name_list"
    }
    lappend event_output "$line_prefix   $line_text"
    lappend event_output "${line_prefix}\}"
   } else {
   if { $flag } {
    lappend event_output "${line_prefix}MOM_suppress once N"
   }
   if { $force_name_list != "" } {
    lappend event_output "${line_prefix}MOM_force Once $force_name_list"
   }
   lappend event_output "${line_prefix}$line_text"
  }
 }

#=======================================================================
proc PB_PB2TCL_write_switchunit_function { TCLF_ID } {
  global mom_kin_var
  upvar $TCLF_ID tclf_id
  puts $tclf_id ""
  puts $tclf_id ""
  puts $tclf_id "#============================================================="

#=======================================================================
puts $tclf_id "proc PB_load_alternate_unit_settings \{ \} \{"
  puts $tclf_id "#============================================================="
  PB_output_CallDebugMsg S $tclf_id
  puts $tclf_id "   global mom_output_unit mom_kin_output_unit"
  puts $tclf_id ""
  puts $tclf_id "  # Skip this function when output unit agrees with post unit."
  puts $tclf_id "   if { !\[info exists mom_output_unit\] } {"
   puts $tclf_id "      set mom_output_unit \$mom_kin_output_unit"
   PB_output_CallDebugMsg R $tclf_id 1
   puts $tclf_id "return"
   puts $tclf_id "   } elseif { !\[string compare \$mom_output_unit \$mom_kin_output_unit\] } {"
   PB_output_CallDebugMsg R $tclf_id 2
   puts $tclf_id "return"
  puts $tclf_id "   }"
  puts $tclf_id ""
  puts $tclf_id ""
  puts $tclf_id "   global mom_event_handler_file_name"
  puts $tclf_id ""
  puts $tclf_id "  # Set unit conversion factor"
  puts $tclf_id "   if \{ !\[string compare \$mom_output_unit \"MM\"\] \} \{"
   puts $tclf_id "      set factor 25.4"
   puts $tclf_id "   \} else \{"
   puts $tclf_id "      set factor \[expr 1\/25.4\]"
  puts $tclf_id "   \}"
  puts $tclf_id ""
  puts $tclf_id "  # Define unit dependent variables list"
  if { ![string compare "lathe" $mom_kin_var(\$mom_kin_machine_type)] } {
   puts $tclf_id "   set unit_depen_var_list \[list mom_kin_x_axis_limit mom_kin_y_axis_limit mom_kin_z_axis_limit \\"
   puts $tclf_id "                                 mom_kin_ind_to_dependent_head_x \\"
   puts $tclf_id "                                 mom_kin_ind_to_dependent_head_z\]"
   puts $tclf_id ""
   puts $tclf_id "   set unit_depen_arr_list \[list mom_sys_home_pos\]"
   } else {
   puts $tclf_id "   set unit_depen_var_list \[list mom_kin_x_axis_limit mom_kin_y_axis_limit mom_kin_z_axis_limit \\"
   puts $tclf_id "                                 mom_kin_pivot_gauge_offset mom_kin_ind_to_dependent_head_x \\"
   puts $tclf_id "                                 mom_kin_ind_to_dependent_head_z\]"
   puts $tclf_id ""
   puts $tclf_id "   set unit_depen_arr_list \[list mom_kin_4th_axis_center_offset \\"
   puts $tclf_id "                                 mom_kin_5th_axis_center_offset \\"
   puts $tclf_id "                                 mom_kin_machine_zero_offset \\"
   puts $tclf_id "                                 mom_kin_4th_axis_point \\"
   puts $tclf_id "                                 mom_kin_5th_axis_point \\"
   puts $tclf_id "                                 mom_sys_home_pos\]"
  }
  puts $tclf_id ""
  puts $tclf_id "  # Load unit dependent variables"
  puts $tclf_id "   foreach var \$unit_depen_var_list \{"
   puts $tclf_id "      if \{ !\[info exists \$var\] \} \{"
    puts $tclf_id "         global \$var"
   puts $tclf_id "      \}"
   puts $tclf_id "      if \{ \[info exists \$var\] \} \{"
    puts $tclf_id "         set \$var \[expr \[set \$var\] \* \$factor\]"
    puts $tclf_id "         MOM_reload_variable \$var"
   puts $tclf_id "      \}"
  puts $tclf_id "   \}"
  puts $tclf_id ""
  puts $tclf_id "   foreach var \$unit_depen_arr_list \{"
   puts $tclf_id "      if \{ !\[info exists \$var\] \} \{"
    puts $tclf_id "         global \$var"
   puts $tclf_id "      \}"
   puts $tclf_id "      foreach item \[array names \$var\] \{"
    puts $tclf_id "         if \{ \[info exists \$\{var\}(\$item)\] \} \{"
     puts $tclf_id "            set \$\{var\}\(\$item\) \[expr \[set \$\{var\}\(\$item\)\] \* \$factor\]"
    puts $tclf_id "         \}"
   puts $tclf_id "      \}"
   puts $tclf_id ""
   puts $tclf_id "      MOM_reload_variable -a \$var"
  puts $tclf_id "   \}"
  puts $tclf_id ""
  puts $tclf_id ""
  puts $tclf_id "  # Source alternate unit post fragment"
  puts $tclf_id "   uplevel #0 \{"
   puts $tclf_id "      global mom_sys_alt_unit_post_name"
   puts $tclf_id "      set alter_unit_post_name \\"
   puts $tclf_id "          \"\[file join \[file dirname \$mom_event_handler_file_name\] \[file rootname \$mom_sys_alt_unit_post_name\]\].tcl\""
   puts $tclf_id ""
   puts $tclf_id "      if \{ \[file exists \$alter_unit_post_name\] \} \{"
    puts $tclf_id "         source \"\$alter_unit_post_name\""
   puts $tclf_id "      \}"
   puts $tclf_id "      unset alter_unit_post_name"
  puts $tclf_id "   \}"
  puts $tclf_id ""
  puts $tclf_id "   if \{ \[llength \[info commands PB_load_address_redefinition\]\] > 0 \} \{"
   puts $tclf_id "      PB_load_address_redefinition"
  puts $tclf_id "   \}"
  puts $tclf_id ""
  puts $tclf_id "   MOM_reload_kinematics"
  PB_output_CallDebugMsg E $tclf_id
 puts $tclf_id "\}"
}

#=======================================================================
proc PB_PB2TCL_write_sub_post_tcl { TCLF_ID } {
  upvar $TCLF_ID tclf_id
  global post_object
  global gPB
  global mom_kin_var
  if { ![string compare $gPB(main_post_unit) "Inches"] } {
   set tmp_factor 25.4
   } else {
   set tmp_factor [expr 1/25.4]
  }
  array set kin_var_arr $Post::($post_object,main_kin_var)
  array set sys_var_arr $Post::($post_object,main_sys_var)
  puts $tclf_id "#======================================================================="
  puts $tclf_id "#  This is a post fragment for alternate output unit created based on"
  puts $tclf_id "#  Main Post: [file tail $gPB(main_post)]"
  puts $tclf_id "#======================================================================="
  puts $tclf_id ""
  puts $tclf_id "################ SYSTEM VARIABLE DEFINITIONS #################"
  foreach var [lsort -dictionary [array names sys_var_arr]] {
   set value "$sys_var_arr($var)"
   set pos [expr [string length $value] - 1]
   switch $value \
   {
    "IPM" -
    "IPR" -
    "MMPM" -
    "MMPR" \
    {
     if { ![string compare "Inches" $gPB(main_post_unit)] } {
      set value "MMP[string range $value $pos $pos]"
      } else {
      set value "IP[string range $value $pos $pos]"
     }
     puts $tclf_id "  set [format "%-40s  %$::gPB(val_fmt)" [string trim $var \$] \"$value\"]"
    }
    default \
    {
     if { [string match "\$mom_sys_feed_param(*,format)" $var] } {
      if { ![string compare "MM" $mom_kin_var(\$mom_kin_output_unit) ] } {
       if { [regsub "IPM" $var "MMPM" var] } {
        set value "Feed_MMPM"
        } elseif { [regsub "IPR" $var "MMPR" var] } {
        set value "Feed_MMPR"
       }
       } else {
       if { [regsub "MMPM" $var "IPM" var] } {
        set value "Feed_IPM"
        } elseif { [regsub "MMPR" $var "IPR" var] } {
        set value "Feed_IPR"
       }
      }
      puts $tclf_id "  set [format "%-40s  %$::gPB(val_fmt)" [string trim $var \$] \"$value\"]"
     }
    }
   }
  }
  puts $tclf_id ""
  puts $tclf_id ""
  puts $tclf_id "################ KINEMATIC VARIABLE DEFINITIONS ##############"
  foreach var [lsort -dictionary [array names kin_var_arr]] {
   puts $tclf_id "  set [format "%-40s  %$::gPB(val_fmt)" [string trim $var \$] \"$mom_kin_var($var)\"]"
  }
  puts $tclf_id "  set [format "%-40s  %$::gPB(val_fmt)" "mom_kin_output_unit" \"$mom_kin_var(\$mom_kin_output_unit)\"]"
  puts $tclf_id ""
  puts $tclf_id ""
  puts $tclf_id "#============================================================="

#=======================================================================
puts $tclf_id "proc PB_load_address_redefinition \{ \} \{"
  puts $tclf_id "#============================================================="
  PB_output_CallDebugMsg S $tclf_id
  puts $tclf_id "################ FORMAT REDEFINITIONS ########################"
  PB_int_RetFormatObjList fmt_obj_list
  foreach fmt_obj $fmt_obj_list\
  {
   set fmt_name $format::($fmt_obj,for_name)
   format::readvalue $fmt_obj fmt_obj_attr
   PB_fmt_RetFmtFrmAttr fmt_obj_attr for_value
   set fmt_val $for_value
   puts $tclf_id "  MOM_set_format \"$fmt_name\" $fmt_val"
  }
  puts $tclf_id ""
  puts $tclf_id ""
  puts $tclf_id "################ ADDRESS REDEFINITION ########################"
  PB_int_RetAddressObjList add_obj_list
  PB_output_GetAdrObjAttr add_obj_list adr_name_arr adr_val_arr
  set no_adds [array size adr_name_arr]
  puts $tclf_id "  global mom_logname"
  puts $tclf_id ""
  puts $tclf_id "  set ugii_tmp_dir \[MOM_ask_env_var UGII_TMP_DIR\]"
  puts $tclf_id "  set def_file_name  \[file join \$ugii_tmp_dir __\$\{mom_logname\}_unit_segment_\[clock clicks\].def\]"
  puts $tclf_id ""
  puts $tclf_id "  if \{ \[catch \{ set tmp_file \[open \"\$def_file_name\" w\] \} res\] \} \{"
   puts $tclf_id ""
   puts $tclf_id "     if \{ !\[info exists res\] \} \{"
    puts $tclf_id "        set res \"\$def_file_name\\nFile open error!\""
   puts $tclf_id "     \}"
   puts $tclf_id ""
   puts $tclf_id "     if \{ \[llength \[info commands PAUSE\] \] \} \{"
    puts $tclf_id "        PAUSE \"Alternate Unit Definition Segment Error\" \"\$res\""
   puts $tclf_id "     \}"
   puts $tclf_id ""
   puts $tclf_id "     CATCH_WARNING \"\$res\""
  puts $tclf_id "  \}"
  puts $tclf_id ""
  puts $tclf_id "  fconfigure \$tmp_file -translation lf"
  puts $tclf_id ""
  for { set count 0 } { $count < $no_adds } { incr count } \
  {
   puts $tclf_id "  puts \$tmp_file \"  ADDRESS $adr_name_arr($count)\""
   puts $tclf_id "  puts \$tmp_file \"  \{\""
    set no_lines [llength $adr_val_arr($count)]
    for {set jj 0} {$jj < $no_lines} {incr jj} \
    {
     set tmp_line "[lindex $adr_val_arr($count) $jj]"
     regsub -all {\[} $tmp_line {\\[} tmp_line
     regsub -all {\]} $tmp_line {\\]} tmp_line
     regsub -all {\$} $tmp_line {\\$} tmp_line
     regsub -all {\"} $tmp_line {\\"} tmp_line
     puts $tclf_id "  puts \$tmp_file \"      $tmp_line\""
    }
   puts $tclf_id "  puts \$tmp_file \"  \}\""
   puts $tclf_id "  puts \$tmp_file \"\""
  }
  puts $tclf_id ""
  puts $tclf_id ""
  puts $tclf_id "  close \$tmp_file"
  puts $tclf_id ""
  puts $tclf_id "  global tcl_platform"
  puts $tclf_id ""
  puts $tclf_id "  if \{ \[string match \"\*windows\*\" \$tcl_platform(platform)\] \} \{"
   puts $tclf_id "     regsub -all \{\/\} \$def_file_name \{\\\\\} def_file_name"
  puts $tclf_id "  \}"
  puts $tclf_id ""
  puts $tclf_id "  if \{ \[catch \{ MOM_load_definition_file  \"\$def_file_name\" \} res\] \} \{"
   puts $tclf_id "     CATCH_WARNING \$res"
  puts $tclf_id "  \}"
  puts $tclf_id ""
  puts $tclf_id "  MOM_remove_file  \$def_file_name"
  puts $tclf_id ""
  PB_output_CallDebugMsg E $tclf_id
 puts $tclf_id "\}"
 if { [info exists Post::($post_object,main_post_Output_VNC)] && $Post::($post_object,main_post_Output_VNC) } {
  puts $tclf_id "#============================================================="

#=======================================================================
puts $tclf_id "proc VNC_load_alternate_unit_settings \{ \} \{"
  puts $tclf_id "#============================================================="
  set sim_kin_var_list [list mom_sim_output_unit mom_sim_rapid_feed_rate mom_sim_max_fpm mom_sim_min_fpm mom_sim_max_fpr mom_sim_min_fpr]
  foreach tmp_sim_var $sim_kin_var_list {
   puts $tclf_id "   global $tmp_sim_var"
  }
  puts $tclf_id "   global mom_sim_max_fpm mom_sim_min_fpm"
  puts $tclf_id "   global mom_sim_max_fpr mom_sim_min_fpr"
  puts $tclf_id "   global mom_sim_cycle_feed_mode"
  puts $tclf_id "   global mom_sim_contour_feed_mode"
  puts $tclf_id "   global mom_sim_rapid_feed_mode"
  puts $tclf_id "   global mom_sim_feed_param"
  puts $tclf_id "   global mom_sim_nc_register"
  puts $tclf_id "   global mom_sim_wcs_offsets"
  puts $tclf_id "   global mom_sim_tool_data"
  puts $tclf_id "   global mom_sim_machine_zero_offsets"
  puts $tclf_id ""
  puts $tclf_id ""
  puts $tclf_id "   if \{ !\[string compare \$mom_sim_output_unit \"IN\"\] \} \{"
   puts $tclf_id "      set factor 25.4"
   puts $tclf_id "   \} else \{"
   puts $tclf_id "      set factor \[expr 1\/25.4\]"
  puts $tclf_id "   \}"
  puts $tclf_id ""
  puts $tclf_id "   set unit_depen_var_list \[list mom_sim_pivot_distance mom_sim_home_pos\(0\) mom_sim_home_pos\(1\) mom_sim_home_pos\(2\)\]"
  puts $tclf_id ""
  puts $tclf_id "  # Load unit dependent variables"
  puts $tclf_id "   foreach var \$unit_depen_var_list \{"
   puts $tclf_id "      if \{ \!\[info exists \$var\] \} \{"
    puts $tclf_id "         global \$var"
   puts $tclf_id "      \}"
   puts $tclf_id "      if \{ \[info exists \$var\] \} \{"
    puts $tclf_id "         set \$var \[expr \[set \$var\] \* \$factor\]"
   puts $tclf_id "      \}"
  puts $tclf_id "   \}"
  puts $tclf_id ""
  puts $tclf_id "  # Load unit independent variables"
  foreach var [lsort -dictionary [array names sys_var_arr]] {
   set value "$sys_var_arr($var)"
   set pos [expr [string length $value] - 1]
   switch $value \
   {
    "IPM" -
    "IPR" -
    "MMPM" -
    "MMPR" \
    {
     if { ![string compare "Inches" $gPB(main_post_unit)] } {
      set value "MMP[string range $value $pos $pos]"
      } else {
      set value "IP[string range $value $pos $pos]"
     }
     regsub "mom_sys" $var "mom_sim" var
     puts $tclf_id "   set [format "%-40s  %$::gPB(val_fmt)" [string trim $var \$] \"$value\"]"
    }
    default \
    {
     if { [string match "\$mom_sys_feed_param(*,format)" $var] } {
      if { ![string compare "MM" $mom_kin_var(\$mom_kin_output_unit) ] } {
       if { [regsub "IPM" $var "MMPM" var] } {
        set value "Feed_MMPM"
        } elseif { [regsub "IPR" $var "MMPR" var] } {
        set value "Feed_MMPR"
       }
       } else {
       if { [regsub "MMPM" $var "IPM" var] } {
        set value "Feed_IPM"
        } elseif { [regsub "MMPR" $var "IPR" var] } {
        set value "Feed_IPR"
       }
      }
      regsub "mom_sys" $var "mom_sim" var
      puts $tclf_id "   set [format "%-40s  %$::gPB(val_fmt)" [string trim $var \$] \"$value\"]"
     }
    }
   }
  }
  foreach tmp_sim_var $sim_kin_var_list {
   regsub "mom_sim" $tmp_sim_var "mom_kin" tmp_sim_var_t
   if { [info exists mom_kin_var(\$$tmp_sim_var_t)] } {
    puts $tclf_id "   set [format "%-40s  %$::gPB(val_fmt)" $tmp_sim_var \"$mom_kin_var(\$$tmp_sim_var_t)\"]"
   }
  }
  puts $tclf_id ""
  puts $tclf_id "   switch \$mom_sim_nc_register(SPINDLE_MODE) \\"
  puts $tclf_id "   \{"
   puts $tclf_id "      \"SFM\" \\"
   puts $tclf_id "      \{"
    puts $tclf_id "         set mom_sim_nc_register(SPINDLE_MODE) \"SMM\""
   puts $tclf_id "      \}"
   puts $tclf_id ""
   puts $tclf_id "      \"SMM\" \\"
   puts $tclf_id "      \{"
    puts $tclf_id "         set mom_sim_nc_register(SPINDLE_MODE) \"SFM\""
   puts $tclf_id "      \}"
  puts $tclf_id "   \}"
  puts $tclf_id ""
  puts $tclf_id "   switch \$mom_sim_nc_register(FEED_MODE) \\"
  puts $tclf_id "   \{"
   puts $tclf_id "      \"MM_PER_MIN\" \\"
   puts $tclf_id "      \{"
    puts $tclf_id "         set mom_sim_nc_register(FEED_MODE) \"INCH_PER_MIN\""
   puts $tclf_id "      \}"
   puts $tclf_id ""
   puts $tclf_id "      \"MM_PER_REV\" \\"
   puts $tclf_id "      \{"
    puts $tclf_id "         set mom_sim_nc_register(FEED_MODE) \"IN_PER_REV\""
   puts $tclf_id "      \}"
   puts $tclf_id ""
   puts $tclf_id "      \"MM_PER_100REV\" \\"
   puts $tclf_id "      \{"
    puts $tclf_id "         set mom_sim_nc_register(FEED_MODE) \"IN_PER_REV\""
   puts $tclf_id "      \}"
   puts $tclf_id ""
   puts $tclf_id "      \"INCH_PER_MIN\" \\"
   puts $tclf_id "      \{"
    puts $tclf_id "         set mom_sim_nc_register(FEED_MODE) \"MM_PER_MIN\""
   puts $tclf_id "      \}"
   puts $tclf_id ""
   puts $tclf_id "      \"IN_PER_REV\" \\"
   puts $tclf_id "      \{"
    puts $tclf_id "         set mom_sim_nc_register(FEED_MODE) \"MM_PER_REV\""
   puts $tclf_id "      \}"
  puts $tclf_id "   \}"
  puts $tclf_id ""
  puts $tclf_id "   if \{ \[info exists mom_sim_machine_zero_offsets\] \} \{"
   puts $tclf_id "      set tmp_machine_zero_offsets \[list\]"
   puts $tclf_id "      for \{ set jj 0 \} \{ \$jj < 3 \} \{ incr jj \} \{"
    puts $tclf_id "         lappend tmp_machine_zero_offsets \[expr \[lindex \$mom_sim_machine_zero_offsets \$jj\] * \$factor\]"
   puts $tclf_id "      \}"
   puts $tclf_id "      set mom_sim_machine_zero_offsets \$tmp_machine_zero_offsets"
  puts $tclf_id "   \}"
  puts $tclf_id ""
  puts $tclf_id "   if \{ \[info exists mom_sim_wcs_offsets\] \} \{"
   puts $tclf_id "      foreach item \[array names mom_sim_wcs_offsets\] \\"
   puts $tclf_id "      \{"
    puts $tclf_id "         set tmp_sim_wcs_offsets \[list\]"
    puts $tclf_id "         for \{ set jj 0 \} \{ \$jj < 3 \} \{ incr jj \} \{"
     puts $tclf_id "            lappend tmp_sim_wcs_offsets \[expr \[lindex \$mom_sim_wcs_offsets(\$item) \$jj\] * \$factor\]"
    puts $tclf_id "         \}"
    puts $tclf_id "         for \{ set jj 3 \} \{ \$jj < 6 \} \{ incr jj \} \{"
     puts $tclf_id "            lappend tmp_sim_wcs_offsets \[lindex \$mom_sim_wcs_offsets(\$item) \$jj\]"
    puts $tclf_id "         \}"
    puts $tclf_id "         set mom_sim_wcs_offsets\(\$item\) \$tmp_sim_wcs_offsets\(\$item\)"
   puts $tclf_id "      \}"
  puts $tclf_id "   \}"
  puts $tclf_id ""
  puts $tclf_id "   if \{ \[info exists mom_sim_tool_data\] \} \{"
   puts $tclf_id "      foreach ind \[list diameter x_off y_off z_off\] \\"
   puts $tclf_id "      \{"
    puts $tclf_id "         foreach item \[array names mom_sim_tool_data \"*,\$ind\"\] \\"
    puts $tclf_id "         \{"
     puts $tclf_id "            set mom_sim_tool_data\(\$item\) \[expr \$mom_sim_tool_data\(\$item\) \* \$factor\]"
    puts $tclf_id "         \}"
   puts $tclf_id "      \}"
  puts $tclf_id "   \}"
 puts $tclf_id "\}"
}
}
