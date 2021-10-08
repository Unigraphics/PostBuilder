#21

#=======================================================================
proc PB_fmt_FmtInitParse { this OBJ_LIST } {
  upvar $OBJ_LIST obj_list
  global post_object gPB
  array set format_arr $ParseFile::($this,format_list)
  array set arr_size $ParseFile::($this,arr_size_list)
  set file_name_list $ParseFile::($this,file_list)
  UI_PB_debug_ForceMsg " %%%%%%% FORMAT parse obj: $this ==> $file_name_list"
  UI_PB_debug_ForceMsg " %%%%%%% FORMAT list: $ParseFile::($this,format_list)"
  if 0 {
   set nf [expr [llength $file_name_list] - 1]
   for { set i $nf } { $i >= 0 } { incr i -1 } {
    lappend file_list [lindex $file_name_list $i]
   }
  }
  set mdef [lindex $file_name_list 0]
  set file_list [lreplace $file_name_list 0 0]
  lappend file_list $mdef
  UI_PB_debug_ForceMsg "\n ++++++ Parsing Format from files: $file_list\n"
  foreach f_name $file_list \
  {
   if { ![string match $f_name $Post::($post_object,def_file)] } {
    set ::gPB(CR8_EXT_OBJ) 1
   }
   set no_of_formats $arr_size($f_name,format)
   for { set count 0 } { $count < $no_of_formats } { incr count } \
   {
    set format_data [lindex $format_arr($f_name,$count,data) 0]
    PB_com_RemoveBlanks format_data
    set format_text $format_arr($f_name,$count,text)
    UI_PB_debug_ForceMsg " %%%%%%% FORMAT: $f_name => $format_data\n$obj_list"
    PB_fmt_FmtSecParse format_data obj_list
   }
   set ::gPB(CR8_EXT_OBJ) 0
  }
  if { [info exists ::env(UNIT_SUB_POST_MODE)] && $::env(UNIT_SUB_POST_MODE) == 1 && \
  [info exist gPB(unit_sub_post_last_def)] && $gPB(unit_sub_post_last_def) == 1 } \
  {
   array set Indep_format_arr $Post::($post_object,Indep_fmt_arr)
   set Indep_format_list $Post::($post_object,Indep_fmt_list)
   set f_name_t [file tail $gPB(main_post)]
   for {set count 0} {$count < [llength $Indep_format_list]} { incr count } {
    set format_data [lindex $Indep_format_arr($f_name_t,$count,data) 0]
    PB_com_RemoveBlanks format_data
    set format_text $Indep_format_arr($f_name_t,$count,text)
    set format_name [lindex $Indep_format_list $count]
    PB_com_RetObjFrmName format_name obj_list ret_code
    if { ![string compare $gPB(main_post_unit) "Inches"] } {
     append format_name "_IN"
     } else {
     append format_name "_MM"
    }
    set format_data_unit [lreplace $format_data 1 1 $format_name]
    PB_fmt_FmtSecParse format_data_unit obj_list
    if { !$ret_code } {
     PB_fmt_FmtSecParse format_data obj_list
    }
   }
  }
 }

#=======================================================================
proc PB_fmt_FmtSecParse { FMT_LINE OBJ_LIST } {
  upvar $FMT_LINE fmt_line
  upvar $OBJ_LIST obj_list
  set ret_code 0
  set obj_attr(0) [lindex $fmt_line 1]
  set obj_attr(1) [lindex $fmt_line 2]
  PB_com_RetObjFrmName obj_attr(0) obj_list ret_code
  if { [string first % $obj_attr(1)] != -1 } \
  {
   PB_fmt_SplitPercFormat obj_attr
   } elseif { [string first & $obj_attr(1)] != -1 } \
  {
   PB_fmt_SplitAmperSignFormat obj_attr
  }
  PB_mthd_SetObjExtAttr obj_attr "format"
  if { $ret_code != 0 } \
  {
   format::setvalue $ret_code obj_attr
   format::DefaultValue $ret_code obj_attr
  } else \
  {
   PB_fmt_CreateFmtObj obj_attr obj_list
  }
  PB_mthd_CatalogPostExtObj obj_attr "format"
 }

#=======================================================================
proc __PB_fmt_FmtSecParse {FMT_LINE OBJ_LIST} {
  upvar $FMT_LINE fmt_line
  upvar $OBJ_LIST obj_list
  set ret_code 0
  set obj_attr(0) [lindex $fmt_line 1]
  set obj_attr(1) [lindex $fmt_line 2]
  PB_com_RetObjFrmName obj_attr(0) obj_list ret_code
  if {$ret_code != 0 }\
  {
   set add_list $format::($ret_code,fmt_addr_list)
   set index [lsearch $obj_list $ret_code]
   set obj_list [lreplace $obj_list $index $index]
   PB_com_DeleteObject $ret_code
  }
  if { [string first % $obj_attr(1)] != -1 } \
  {
   PB_fmt_SplitPercFormat obj_attr
   } elseif { [string first & $obj_attr(1)] != -1 } \
  {
   PB_fmt_SplitAmperSignFormat obj_attr
  }
  PB_fmt_CreateFmtObj obj_attr obj_list
  if { [info exists add_list] && [llength $add_list] > 0 } {
   set fmt_obj [lindex $obj_list end]
   foreach add_obj $add_list {
    set address::($add_obj,add_format) $fmt_obj
   }
  }
 }

#=======================================================================
proc PB_fmt_GetPostZeroFormats { POST_OBJ FMT_OBJ_LIST } {
  upvar $POST_OBJ post_obj
  upvar $FMT_OBJ_LIST fmt_obj_list
  global mom_sys_arr
  array set mom_sys_arr $Post::($post_obj,mom_sys_var_list)
  if [info exists mom_sys_arr(\$zero_int_fmt)] \
  {
   if { $mom_sys_arr(\$zero_int_fmt) == "" } \
   {
    __fmt_CreateZeroFormat fmt_obj_list zero_fmt int
    set mom_sys_arr(\$zero_int_fmt) $zero_fmt
   }
  }
  if { [info exists mom_sys_arr(\$zero_real_fmt)] } \
  {
   if { $mom_sys_arr(\$zero_real_fmt) == "" } \
   {
    __fmt_CreateZeroFormat fmt_obj_list zero_fmt real
    set mom_sys_arr(\$zero_real_fmt) $zero_fmt
   }
  }
  if { [info exists mom_sys_arr(\$zero_int_fmt)]  && \
   [info exists mom_sys_arr(\$zero_real_fmt)] } {
   set add_obj_list $Post::($post_obj,add_obj_list)
   set fmt_obj_list $Post::($post_obj,fmt_obj_list)
   foreach add_obj $add_obj_list {
    address::readvalue $add_obj add_obj_attr
    if { $add_obj_attr(13) != "" } {
     set zero_fmt $add_obj_attr(13)
     if { $zero_fmt != "$mom_sys_arr(\$zero_int_fmt)"  && \
      $zero_fmt != "$mom_sys_arr(\$zero_real_fmt)" } {
      set fmt_obj $add_obj_attr(12)
      set idx [lsearch $fmt_obj_list $fmt_obj]
      if { $idx >= 0 } {
       set fmt_obj_list [lreplace $fmt_obj_list $idx $idx]
       Post::SetObjListasAttr $post_obj fmt_obj_list
       PB_com_DeleteObject $fmt_obj
      }
     }
    }
   }
   if 0 {{
    set mom_sys_arr(\$zero_int_fmt_obj) -1
    set mom_sys_arr(\$zero_real_fmt_obj) -1
    if { $mom_sys_arr(\$zero_int_fmt) != "" } {
     set fmt_name $mom_sys_arr(\$zero_int_fmt)
     PB_com_RetObjFrmName fmt_name fmt_obj_list ret_code
     if { $ret_code >= 0 } {
      set mom_sys_arr(\$zero_int_fmt_obj) $ret_code
     }
    }
    if { $mom_sys_arr(\$zero_real_fmt) != "" } {
     set fmt_name $mom_sys_arr(\$zero_real_fmt)
     PB_com_RetObjFrmName fmt_name fmt_obj_list ret_code
     if { $ret_code >= 0 } {
      set mom_sys_arr(\$zero_real_fmt_obj) $ret_code
     }
    }
   }}
  }
  set Post::($post_obj,mom_sys_var_list) [array get mom_sys_arr]
 }

#=======================================================================
proc __PB_fmt_GetPostZeroFormats { POST_OBJ FMT_OBJ_LIST } {
  upvar $POST_OBJ post_obj
  upvar $FMT_OBJ_LIST fmt_obj_list
  array set mom_sys_arr $Post::($post_obj,mom_sys_var_list)
  if { [info exists mom_sys_arr(\$zero_int_fmt)] } \
  {
   if { $mom_sys_arr(\$zero_int_fmt) != "" } \
   {
    set fmt_name $mom_sys_arr(\$zero_int_fmt)
    PB_com_RetObjFrmName fmt_name fmt_obj_list ret_code
    if { $ret_code } \
    {
     set mom_sys_arr(\$zero_int_fmt) $ret_code
    } else \
    {
     PB_fmt_CreateZeroFormat fmt_obj_list zero_int_fmt int
     set mom_sys_arr(\$zero_int_fmt) $zero_int_fmt
    }
   } else \
   {
    PB_fmt_CreateZeroFormat fmt_obj_list zero_int_fmt int
    set mom_sys_arr(\$zero_int_fmt) $zero_int_fmt
   }
  }
  if { [info exists mom_sys_arr(\$zero_real_fmt)] } \
  {
   if { $mom_sys_arr(\$zero_real_fmt) != "" } \
   {
    set fmt_name $mom_sys_arr(\$zero_real_fmt)
    PB_com_RetObjFrmName fmt_name fmt_obj_list ret_code
    if { $ret_code } \
    {
     set mom_sys_arr(\$zero_real_fmt) $ret_code
    } else \
    {
     PB_fmt_CreateZeroFormat fmt_obj_list zero_real_fmt real
     set mom_sys_arr(\$zero_real_fmt) $zero_real_fmt
    }
   } else \
   {
    PB_fmt_CreateZeroFormat fmt_obj_list zero_real_fmt real
    set mom_sys_arr(\$zero_real_fmt) $zero_real_fmt
   }
  }
  set Post::($post_obj,mom_sys_var_list) [array get mom_sys_arr]
 }

#=======================================================================
proc PB_fmt_CreateZeroFormat { FMT_OBJ_LIST ZERO_FORMAT fmt_type } {
 }

#=======================================================================
proc __fmt_CreateZeroFormat { FMT_OBJ_LIST ZERO_FORMAT fmt_type } {
  upvar $FMT_OBJ_LIST fmt_obj_list
  upvar $ZERO_FORMAT zero_format
  if { $fmt_type == "int" } \
  {
   set obj_attr(0) "Zero_int"
   set obj_attr(1) "Numeral"
   set obj_attr(2) 0
   set obj_attr(3) 1
   set obj_attr(4) 1
   set obj_attr(5) 1
   set obj_attr(6) 0
   set obj_attr(7) 0
  } else \
  {
   set obj_attr(0) "Zero_real"
   set obj_attr(1) "Numeral"
   set obj_attr(2) 0
   set obj_attr(3) 1
   set obj_attr(4) 1
   set obj_attr(5) 1
   set obj_attr(6) 1
   set obj_attr(7) 1
  }
  PB_fmt_GetFmtNameList fmt_obj_list fmt_name_list
  PB_com_SetDefaultName fmt_name_list obj_attr
  PB_fmt_CreateFmtObj obj_attr fmt_obj_list
  set zero_format $obj_attr(0)
 }

#=======================================================================
proc PB_fmt_CreateFmtObj { OBJ_ATTR OBJ_LIST } {
  upvar $OBJ_ATTR obj_attr
  upvar $OBJ_LIST obj_list
  set object [new format]
  lappend obj_list $object
  format::setvalue $object obj_attr
  format::DefaultValue $object obj_attr
  global post_object
  Post::SetObjListasAttr $post_object obj_list
 }

#=======================================================================
proc PB_fmt_SplitAmperSignFormat { OBJ_ATTR } {
  upvar $OBJ_ATTR obj_attr
  set attr_list [split $obj_attr(1) {}]
  set obj_attr(2) 0
  set obj_attr(3) 0
  set obj_attr(4) 0
  set obj_attr(5) ""
  set obj_attr(6) 0
  set obj_attr(7) ""
  set count 1
  foreach elem $attr_list \
  {
   if { [string compare $elem " "] == 0 || \
    [string compare $elem &]   == 0 || \
   [string compare $elem \"]  == 0 } \
   {
    continue
   }
   switch -- $count \
   {
    1  {
     switch -- $elem \
     {
      _   {  set obj_attr(2) 0 }
      +   {  set obj_attr(2) 1 }
      -   {  set obj_attr(2) 3 }
     }
    }
    2  {
     switch -- $elem \
     {
      _   {  set obj_attr(3) 0 }
      0   {  set obj_attr(3) 1 }
     }
    }
    3  {
     switch -- $elem \
     {
      _         {  set obj_attr(5) 0 }
      default   {  set obj_attr(5) $elem }
     }
    }
    4  {
     switch -- $elem \
     {
      _   {  set obj_attr(6) 0 }
      .   {  set obj_attr(6) 1 }
     }
    }
    5  {
     switch -- $elem \
     {
      _         {  set obj_attr(7) 0 }
      default   {  set obj_attr(7) $elem }
     }
    }
    6  {
     switch -- $elem \
     {
      _   {  set obj_attr(4) 0 }
      0   {  set obj_attr(4) 1 }
     }
    }
   }
   incr count
  }
  if { $obj_attr(6) == 1 } \
  {
   set obj_attr(1) "Numeral"
   } elseif { $obj_attr(7) > 0 } \
  {
   set obj_attr(1) "Numeral"
   } elseif { $obj_attr(6) == 0 && $obj_attr(7) == 0 && \
  $obj_attr(5) > 0 } \
  {
   set obj_attr(1) "Numeral"
  } else \
  {
   set obj_attr(1) "Text String"
  }
 }

#=======================================================================
proc PB_fmt_SplitPercFormat { OBJ_ATTR } {
  upvar $OBJ_ATTR obj_attr
  set count 1
  set attr_list [split $obj_attr(1) {}]
  set obj_attr(2) 0
  set obj_attr(3) 0
  set obj_attr(4) 0
  set obj_attr(5) ""
  set obj_attr(6) 0
  set obj_attr(7) ""
  foreach attr $attr_list\
  {
   switch -- $attr \
   {
    .       { set obj_attr(6) 1 }
    f       { set obj_attr(1) "Numeral" }
    d       { set obj_attr(1) "Numeral" }
    s       { set obj_attr(1) "Text String" }
    +       { set obj_attr(2) 1 }
    -       { set obj_attr(2) 3 }
    0       { if {!$obj_attr(6) && ![string compare $obj_attr(5) ""]}\
     {
      set obj_attr(3) 1
      } elseif {!$obj_attr(6)}\
     {
      append obj_attr(5) $attr
      } elseif {$obj_attr(6)}\
     {
      set obj_attr(7) $attr
     }
    }
    \"      {}
    %       {}
    default { if {$count == 1 && !$obj_attr(6)}\
     {
      append obj_attr(5) $attr
      incr count
      } elseif {!$obj_attr(6)}\
     {
      append obj_attr(5) $attr
     } else\
     {
      set obj_attr(7) $attr
      if {$obj_attr(5) == ""}\
      {
       set obj_attr(5) [expr 8 - $obj_attr(7)]
      } else\
      {
       set obj_attr(5) [expr $obj_attr(5) - $obj_attr(7)]
      }
     }
    }
   }
  }
 }

#=======================================================================
proc PB_fmt_CreateNewFmtObj { OBJ_LIST OBJ_ATTR OBJ_INDEX} {
  upvar $OBJ_LIST obj_list
  upvar $OBJ_ATTR obj_attr
  upvar $OBJ_INDEX obj_index
  PB_fmt_CreateFmtObj obj_attr obj_list
  if {$obj_index == ""}\
  {
   set obj_index 0
  } else\
  {
   incr obj_index
  }
  set length [llength $obj_list]
  set RearrObj [lindex $obj_list [expr $length -1]]
  set obj_list [lreplace $obj_list [expr $length - 1] [expr $length -1]]
  set obj_list [linsert $obj_list $obj_index $RearrObj]
 }

#=======================================================================
proc PB_fmt_PasteFmtBuffObj { OBJ_LIST BUFF_OBJ_ATTR OBJ_INDEX } {
  upvar $OBJ_LIST fmt_obj_list
  upvar $BUFF_OBJ_ATTR buff_obj_attr
  upvar $OBJ_INDEX obj_index
  PB_fmt_CreateFmtObj buff_obj_attr fmt_obj_list
  set count [llength $fmt_obj_list]
  if { $obj_index == "" } \
  {
   set obj_index 0
   } elseif { $count > 1 } \
  {
   incr obj_index
   set Rearrange_I  [expr [llength $fmt_obj_list] - 1]
   set LastElement  [lindex $fmt_obj_list $Rearrange_I]
   set fmt_obj_list [lreplace $fmt_obj_list $Rearrange_I $Rearrange_I]
   set fmt_obj_list [linsert $fmt_obj_list $obj_index $LastElement]
  }
 }

#=======================================================================
proc PB_fmt_RetFmtFrmAttr {OBJ_ATTR VALUE} {
  upvar $OBJ_ATTR obj_attr
  upvar $VALUE nvar
  set nvar "\"&"
  for {set i 0} {$i < 9} {incr i} \
  {
   switch $i \
   {
    0   {}
    1   {
     if {$obj_attr($i) == "Text String"}\
     {
      set nvar \"%s\"
      return
     }
    }
    2   {
     if {$obj_attr($i)}\
     {
      if {$obj_attr($i) == 3}\
      {
       append nvar -
      } else\
      {
       append nvar +
      }
     } else \
     {
      append nvar _
     }
    }
    3   {
     if {$obj_attr($i)}\
     {
      append nvar 0
     } else \
     {
      append nvar _
     }
    }
    4   {}
    5   {
     append nvar $obj_attr($i)
    }
    6   {
     if {$obj_attr($i)}\
     {
      append nvar "."
     } else \
     {
      append nvar _
     }
    }
    7   {
     append nvar $obj_attr($i)
    }
    8   {
     if {$obj_attr(4)}\
     {
      append nvar 0
     } else \
     {
      append nvar _
     }
     append nvar \"
    }
    default   {}
   }
  }
 }

#=======================================================================
proc PB_fmt_RetValFrmFmt { OBJ_ATTR FMT_VALUE REAL_VALUE } {
  upvar $OBJ_ATTR obj_attr
  upvar $FMT_VALUE fmt_value
  upvar $REAL_VALUE real_value
  if {[string match "Text String" $obj_attr(1)]} {
   set real_value $fmt_value
   return
  }
  set real_value ""
  set tmp_value [string trim $fmt_value "+"]
  set neg_sign ""
  if { [string first "-" $tmp_value] != -1 } {
   set tmp_value [string trim $tmp_value "-"]
   set neg_sign "-"
  }
  set dec_pt [string first "." $tmp_value]
  if { $dec_pt != -1 } {
   set fpart [string range $tmp_value 0 [expr $dec_pt - 1]]
   set spart [string range $tmp_value [expr $dec_pt + 1] end]
   } else {
   if { ![string match "" $obj_attr(5)] } {
    if { $obj_attr(3) == 1 } {
     set fpart [string range $tmp_value 0 [expr $obj_attr(5) - 1]]
     set spart [string range $tmp_value $obj_attr(5) end]
     } elseif { $obj_attr(4) == 1 } {
     if { ![string match "" $obj_attr(7)] } {
      set len [string length $tmp_value]
      set fpart [string range $tmp_value 0 [expr $len - $obj_attr(7) -1 ]]
      set spart [string range $tmp_value [expr $len - $obj_attr(7)] end]
     }
     } else {
     set fpart $tmp_value
    }
   }
  }
  if {![info exists fpart]} {
   set fpart ""
  }
  if {![info exists spart]} {
   set spart ""
  }
  set fpart [string trimleft $fpart "0"]
  set spart [string trimright $spart "0"]
  if { ![string compare "" $fpart] && [string compare "" $spart] } {
   set fpart 0
  }
  if {[string length $spart] > 0 } {
   set real_value "$neg_sign$fpart.$spart"
   } else {
   set real_value "$neg_sign$fpart"
  }
  if { ![string compare "" $real_value] || \
   ![string compare "-" $real_value] || \
  ![string compare "+" $real_value] } \
  {
   set real_value 0
  }
 }

#=======================================================================
proc PB_fmt_RetFmtOptVal { OBJ_ATTR INP_VALUE DIS_VALUE {format_flag 0} } {
  upvar $OBJ_ATTR obj_attr
  upvar $INP_VALUE inp_value
  upvar $DIS_VALUE dis_value
  if { [string match "Text String" $obj_attr(1)] } {
   set dis_value $inp_value
   return
  }
  set dis_value ""
  set neg_flag 0
  if { ![string compare "" $obj_attr(5)] } {
   set obj_attr(5) 0
  }
  if { ![string compare "" $obj_attr(7)] } {
   set obj_attr(7) 0
  }
  set value_sign ""
  if { [string match -* $inp_value] } {
   set value_sign "-"
  }
  if { [string match +* $inp_value] } {
   set value_sign "+"
  }
  if { [string first "." $inp_value] == -1 && \
  $obj_attr(6) == 0 && $format_flag == 0 } \
  {
   if { $obj_attr(3) == 1 } {
    set slen [string length $inp_value]
    if { [string compare "" $value_sign] } {
     set f_part [string range $inp_value 1 $obj_attr(5)]
     set s_part [string range $inp_value [expr $obj_attr(5) + 1] [expr $slen - 1]]
     } else {
     set f_part [string range $inp_value 0 [expr $obj_attr(5) - 1]]
     set s_part [string range $inp_value $obj_attr(5) [expr $slen - 1]]
    }
    set inp_value "$value_sign$f_part"
    append inp_value .
    append inp_value $s_part
    } elseif { $obj_attr(4) == 1 } {
    set slen [string length $inp_value]
    if { [string compare "" $value_sign] } {
     set f_part [string range $inp_value 1 [expr $slen - $obj_attr(7) - 1]]
     } else {
     set f_part [string range $inp_value 0 [expr $slen - $obj_attr(7) - 1]]
    }
    set s_part [string range $inp_value [expr $slen - $obj_attr(7)] [expr $slen - 1]]
    set inp_value "$value_sign$f_part"
    append inp_value .
    append inp_value $s_part
   }
  }
  set dec_pt [string first "." $inp_value]
  if { $dec_pt != -1 }\
  {
   set fpart [string range $inp_value 0 [expr $dec_pt - 1]]
   set spart [string range $inp_value [expr $dec_pt + 1] end]
  } else\
  {
   set fpart $inp_value
   set spart ""
  }
  if { [string match -* $fpart] }\
  {
   set len [string length $fpart]
   set fpart [string range $fpart 1 $len]
   set neg_flag 1
   } else {
   if { [string match +* $fpart] } {
    set len [string length $fpart]
    set fpart [string range $fpart 1 $len]
   }
  }
  for { set i 1 } { $i < 8 } { incr i }\
  {
   switch $i {
    1       {
     switch $obj_attr($i) \
     {
      "Text String" { set dis_value $inp_value
       break
      }
     }
    }
    2       {
     switch $obj_attr($i) \
     {
      1       {
       if { $format_flag } {
        if {[string compare "" $value_sign]} {
         append dis_value $value_sign
        }
        } else {
        if { $neg_flag } {
         append dis_value -
         } else {
         append dis_value +
        }
       }
      }
      default {
       if { $format_flag } {
        if {[string compare "" $value_sign]} {
         append dis_value $value_sign
        }
        } else {
        if { $neg_flag }\
        {
         append dis_value -
        }
       }
      }
     }
    }
    3       {
     switch $obj_attr($i) \
     {
      1       {
       if { $format_flag } {
        set lz 1
        } else {
        set lz 0
       }
      }
      0       { set lz 1 }
     }
    }
    4       {
     switch $obj_attr($i) \
     {
      1       {
       if { $format_flag } {
        set tz 1
        } else {
        set tz 0
       }
      }
      0       { set tz 1 }
     }
    }
    5       {
     switch $obj_attr($i) \
     {
      ""      {}
      default {
       set length [string length $fpart]
       if { $length > $obj_attr($i) } \
       {
        set fpart [string range $fpart 0 [expr $obj_attr($i) - 1]]
       }
       if { !$format_flag } {
        if { $fpart != 0 } {
         set fpart [string trimleft $fpart 0]
         } else {
         set fpart 0
        }
       }
       if { $lz == 0 }\
       {
        set length [string length $fpart]
        set num_zero \
        [expr $obj_attr($i) - $length]
        if { $num_zero > 0}\
        {
         for { set j 0 } { $j < $num_zero } \
         { incr j }\
         {
          append dis_value 0
         }
        }
        append dis_value $fpart
       } else\
       {
        if { ![string match "" $fpart] } {
         append dis_value $fpart
         } else {
        }
       }
      }
     }
    }
    6       {
     switch $obj_attr($i) \
     {
      1      {
       if { $format_flag } {
        if { $dec_pt != -1 } {
         append dis_value .
        }
        } else {
        append dis_value .
       }
      }
      0      {
       if { $dec_pt != -1 && $format_flag } {
        append dis_value .
       }
      }
     }
    }
    7       {
     switch $obj_attr($i) \
     {
      ""      {
       if { ![string compare $obj_attr(5) ""] }\
       {
        set dis_value $fpart
       }
      }
      default {
       set length [string length $spart]
       if { $length > $obj_attr($i) } \
       {
        set end_no [expr $obj_attr($i) - 1]
        set spart [string range $spart 0 $end_no]
       }
       if { !$format_flag } {
        set spart [string trimright $spart 0]
        if { ![string compare "" $spart] && $obj_attr(5) == 0 } {
         set spart 0
        }
       }
       if { $obj_attr(5) == 0 && ![string compare "" $spart] } {
        set spart 0
       }
       if { $tz == 0 }\
       {
        append dis_value $spart
        set length [string length $spart]
        set num_zero \
        [expr $obj_attr($i) - $length]
        if { $num_zero >= 0}\
        {
         for {set k 0} {$k < $num_zero} \
         {incr k}\
         {
          append dis_value 0
         }
        }
        } elseif { $tz == 1 } \
       {
        if { ![string match "" $spart] } {
         append dis_value $spart
         } else {
        }
       }
      }
     }
    }
    default {}
   }
  }
 }

#=======================================================================
proc PB_fmt_RetFormatObjs { FMT_OBJ_LIST } {
  upvar $FMT_OBJ_LIST fmt_obj_list
  global post_object
  set fmt_obj_list $Post::($post_object,fmt_obj_list)
 }

#=======================================================================
proc PB_fmt_GetFmtNameList { FMT_OBJ_LIST FMT_NAME_LIST } {
  upvar $FMT_OBJ_LIST fmt_obj_list
  upvar $FMT_NAME_LIST fmt_name_list
  foreach fmt_obj $fmt_obj_list \
  {
   lappend fmt_name_list $format::($fmt_obj,for_name)
  }
  if {![info exists fmt_name_list]} \
  {
   set fmt_name_list ""
  }
 }
