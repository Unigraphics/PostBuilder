
#=======================================================================
proc PB_mthd_CatalogPostExtObj { OBJ_ATTR class } {
  if { [info exists ::gPB(CR8_EXT_OBJ)] && $::gPB(CR8_EXT_OBJ) } {
   set _is_external 1
   } else {
   set _is_external 0
  }
  upvar $OBJ_ATTR obj_attr
  set class_list { format address block command function ude_event cycle_event }
  if { [lsearch $class_list $class] >= 0 } {
   switch $class \
   {
    format      { set idx 9  ; set name_list "ext_fmt_list" }
    address     { set idx 15 ; set name_list "ext_add_list" }
    block       { set idx 5  ; set name_list "ext_blk_list" }
    command     { set idx 7  ; set name_list "ext_cmd_list" }
    function    { set idx 10 ; set name_list "ext_fun_list" }
    ude_event   { set idx 8  ; set name_list "ext_ude_list" }
    cycle_event { set idx 8  ; set name_list "ext_cyc_list" }
   }
   set ii [lsearch $Post::($::post_object,${name_list}) $obj_attr(0)]
   if { $_is_external } {
    if { $ii < 0 } {
     if { [info exists obj_attr($idx)] && $obj_attr($idx) } {
      lappend Post::($::post_object,${name_list}) $obj_attr(0)
     }
    }
    } else {
    if { $ii >= 0 } {
     UI_PB_debug_ForceMsg_no_trace " % % % % %  External object: $class $obj_attr(0) to be delisted"
     set Post::($::post_object,${name_list}) \
     [lreplace $Post::($::post_object,${name_list}) $ii $ii]
    }
   }
  }
 }

#=======================================================================
proc PB_mthd_SetObjExtAttr { OBJ_ATTR class } {
  if { [info exists ::gPB(CR8_EXT_OBJ)] && $::gPB(CR8_EXT_OBJ) } {
   set _is_external 1
   } else {
   set _is_external 0
  }
  upvar $OBJ_ATTR obj_attr
  set class_list { format address block command function ude_event cycle_event }
  if { [lsearch $class_list $class] >= 0 } {
   switch $class \
   {
    format      { set idx 9  }
    address     { set idx 15 }
    block       { set idx 5  }
    command     { set idx 7  }
    function    { set idx 10 }
    ude_event   -
    cycle_event { set idx 8  }
   }
   set obj_attr($idx)  $_is_external
   if { $_is_external } {
    UI_PB_debug_ForceMsg_no_trace " % % % % %  External object: $class $obj_attr(0)"
   }
  }
 }

#=======================================================================
proc PB_mthd_DiffObjWithDefault { this {_external_only 0} {_excluded_list ""} {_check_llen 0} } {
  set ClassName [string trim [classof $this] ::]
  set compare_external 0
  if { $_external_only } {
   set compare_external -1
   if { [info exists ${ClassName}::($this,is_external)] } {
    if { [set ${ClassName}::($this,is_external)] } {
     set compare_external 1
    }
   }
  }
  ${ClassName}::readvalue $this obj_attr
  UI_PB_debug_ForceMsg_no_trace " % % % % %  $ClassName $this is external = $compare_external  >[array get obj_attr]<"
  unset obj_attr
  if { $compare_external == -1 } {
   return 0
  }
  ${ClassName}::readvalue $this obj_attr
  array set def_attr [set ${ClassName}::($this,def_value)]
  set n_attr [expr [eval llength $${ClassName}::($this,def_value)]/2]
  set status 0
  for { set i 0 } { $i < $n_attr } { incr i } {
   if { ![info exists def_attr($i)] || ![info exists obj_attr($i)] } {
    UI_PB_debug_ForceMsg_no_trace " % % % % %  $ClassName $this attr $i does not exist!"
    continue
   }
   if { [lsearch $_excluded_list $i] != -1 } {
    UI_PB_debug_ForceMsg_no_trace " % % % % %  $ClassName $this attr $i excluded $def_attr($i) && $obj_attr($i)"
    if { $_check_llen  &&  ([llength $def_attr($i)] != [llength $obj_attr($i)]) } {
     UI_PB_debug_ForceMsg_no_trace " % % % % %  $ClassName $this attr $i excluded lists have __different length"
     if { !$status } {
      if { $compare_external == 1 } {
       set ${ClassName}::($this,is_external) 0
      }
      if $::gPB(DEBUG) {
       set status 1
       } else {
       return 1
      }
     }
    }
    continue
   }
   if { [string length $def_attr($i)] == 2  &&  [string match "{}" $def_attr($i)] } { set def_attr($i) "" }
   if { [string length $obj_attr($i)] == 2  &&  [string match "{}" $obj_attr($i)] } { set obj_attr($i) "" }
   if { [string compare $def_attr($i) $obj_attr($i)] } {
    UI_PB_debug_ForceMsg_no_trace " % % % % %  $ClassName $this attr $i __different $def_attr($i) != $obj_attr($i)"
    if { !$status } {
     if { $compare_external == 1 } {
      set ${ClassName}::($this,is_external) 0
     }
     if $::gPB(DEBUG) {
      set status 1
      } else {
      return 1
     }
    }
    } else {
    UI_PB_debug_ForceMsg_no_trace " % % % % %  $ClassName $this attr $i identical $def_attr($i) == $obj_attr($i)"
   }
  }
  return $status
 }

#=======================================================================
proc PB_mthd_DefFileInitParse { parse_obj file_name } {
  global gPB
  lappend def_file_list "$file_name"
  set gPB(def_file_list) $def_file_list
  PB_mthd_ParseADefFile def_file_list bef_com_data word_sep_arr end_line_arr \
  sequence_arr format_arr address_arr block_arr \
  aft_com_data arr_size
  set def_file_list $gPB(def_file_list)
  foreach name $def_file_list \
  {
   set file_list [split $name //]
   set f_name [lindex $file_list [expr [llength $file_list] -1]]
   lappend trunc_file_name $f_name
  }
  if [info exists bef_com_data] \
  {
   set ParseFile::($parse_obj,bef_com_data_list) [array get bef_com_data]
  }
  if [info exists word_sep_arr] \
  {
   set ParseFile::($parse_obj,word_sep_list)     [array get word_sep_arr]
  }
  if [info exists end_line_arr] \
  {
   set ParseFile::($parse_obj,end_line_list)     [array get end_line_arr]
  }
  if [info exists sequence_arr] \
  {
   set ParseFile::($parse_obj,sequence_list)     [array get sequence_arr]
  }
  if [info exists format_arr] \
  {
   set ParseFile::($parse_obj,format_list)       [array get format_arr]
  }
  if [info exists address_arr] \
  {
   set ParseFile::($parse_obj,address_list)      [array get address_arr]
  }
  if [info exists block_arr] \
  {
   set ParseFile::($parse_obj,block_temp_list)   [array get block_arr]
  }
  if [info exists aft_com_data] \
  {
   set ParseFile::($parse_obj,aft_com_data_list) [array get aft_com_data]
  }
  if [info exists arr_size] \
  {
   set ParseFile::($parse_obj,arr_size_list)     [array get arr_size]
  }
  if [info exists trunc_file_name] \
  {
   UI_PB_debug_ForceMsg "\n@@@@@ >Def files processed: $trunc_file_name\n"
   set ParseFile::($parse_obj,file_list)         $trunc_file_name
  }
 }
 if 1 { ;#<02-19-2014 gsl> Exp new version

#=======================================================================
proc PB_mthd_ParseADefFile__06-09-2015 { SOURCE_FILE BEF_COM_DATA WORD_SEP_ARR \
  END_LINE_ARR SEQUENCE_ARR FORMAT_ARR \
  ADDRESS_ARR BLOCK_ARR AFT_COM_DATA ARR_SIZE } {
  upvar $SOURCE_FILE   source_file
  upvar $BEF_COM_DATA  bef_com_data
  upvar $WORD_SEP_ARR  word_sep_arr
  upvar $END_LINE_ARR  end_line_arr
  upvar $SEQUENCE_ARR  sequence_arr
  upvar $FORMAT_ARR    format_arr
  upvar $ADDRESS_ARR   address_arr
  upvar $BLOCK_ARR     block_arr
  upvar $AFT_COM_DATA  aft_com_data
  upvar $ARR_SIZE      arr_size
  UI_PB_debug_ForceMsg "@@@@@ >source file: $source_file"
  set FilePointer [open "[lindex $source_file 0]" r]
  set file_list   [split "[lindex $source_file 0]" //]
  set file_name   [lindex $file_list [expr [llength $file_list] -1]]
  global post_object
  PB_int_ReadPostFiles pui_dir def_file tcl_file
  set keyword_status 0
  set format_open_brace 0
  set word_sep_index 0
  set end_line_index 0
  set seq_index 0
  set fmt_index 0
  set add_index 0
  set blk_index 0
  set formatting_flag 0
  set include_found 0
  set cdl_found 0
  set own_cdl_file [file rootname [file tail $tcl_file]].cdl
  UI_PB_debug_ForceMsg "@@@@@ >Parsing $file_name  of $::gpb_pui_file"
  set pui_file [file rootname [file tail $::gpb_pui_file]]
  set def_file [file rootname [file tail $file_name]]
  array set mom_sys_arr $Post::($post_object,mom_sys_var_list)
  set __update_mom_sys 0
  while { [gets $FilePointer line] >= 0 } \
  {
   UI_PB_debug_DisplayMsg $line
   set save_para 1
   if { [string match "*FORMATTING*" $line] == 1 } \
   {
    PB_mthd_StoreCommentData bef_com_data key_para file_name
    set formatting_flag 1
    if [info exists key_para] { unset key_para }
    continue
    } elseif { [string match "*INCLUDE*" $line] == 1 } \
   {
    UI_PB_debug_ForceMsg "@@@@@ >$line<"
    set include_found 1
    set include_brace_count 0
    set include_script [list]
   }
   if { ($include_found || $cdl_found)  &&  ![string length [string trim $line]] } {
    continue
   }
   if $include_found {
    set save_para 0
    lappend include_script [string trim $line]
    set left_brace_count  [llength [split $include_script \{]]
    set right_brace_count [llength [split $include_script \}]]
    if [expr $left_brace_count > $right_brace_count] {
     incr include_brace_count
    }
    if [expr $left_brace_count < $right_brace_count] {
     incr include_brace_count -1
    }
    UI_PB_debug_ForceMsg "@@@@@ INCLUDE statement: >$include_script< left { = $left_brace_count right } = $right_brace_count\n"
    if { $left_brace_count == $right_brace_count } {
     if { [llength $include_script] && [string match "*\}" $include_script] } {
     if { [string match "*.cdl*" $include_script] ||\
      [string match "*.def*" $include_script] } {
      set cdl_found 1
      regsub -all {\\} $include_script {} word_list
      regsub -all {\{} $word_list      {} word_list
       regsub -all {\}} $word_list      {} word_list
       set idx [lsearch -glob $word_list "*.cdl*"]
       if { $idx >= 0 } {
        set ude [lindex $word_list $idx]
        regsub -all {\\} $ude {} ude
        set ude [string trim $ude]
        set ude [string trim [string trimleft $word_list INCLUDE]]
        if 0 {
         if { ![info exists Post::($post_object,UDE_File_Name)] || \
          ![string length $Post::($post_object,UDE_File_Name)] } {
          set Post::($post_object,UDE_File_Name) $ude
         }
         } else {
         if { ![string compare $def_file $pui_file] } {
          set Post::($post_object,UDE_File_Name) $ude
          if 1 {
           set indx 0
           foreach f $ude {
            UI_PB_debug_ForceMsg "@@@@@ Comparing own CDL: [file tail $f]  $indx  pui_file: $pui_file.cdl"
            if { ![string compare "$pui_file.cdl" [file tail $f]] } {
             set mom_sys_arr(Own_UDE) 1
             set mom_sys_arr(OWN_CDL_File_Folder) "[file dirname $f]"
             set __update_mom_sys 1
             UI_PB_debug_ForceMsg "@@@@@ Found own CDL: $f $indx"
             set Post::($post_object,UDE_File_Name_save) $ude
             set Post::($post_object,UDE_File_Name) [lreplace $ude $indx $indx]
             break
            }
            incr indx
           }
          } ;# if
         }
        }
        set Post::($post_object,UDE_File_Name) [join $Post::($post_object,UDE_File_Name)]
        UI_PB_debug_ForceMsg "@@@@@ Own CDL: $Post::($post_object,UDE_File_Name)"
       } ;# idx
      } ;# cdl_found
      if [PB_file_is_JE_POST_DEV] {
       regsub -all {\\} $include_script {} tmp_string
       regsub -all {\{} $tmp_string     {} tmp_string
        regsub -all {\}} $tmp_string     {} tmp_string
        regsub -all {\$}  $tmp_string     {\\$} tmp_string
        set tmp_string [string trim [string trimleft $tmp_string INCLUDE]]
        set fields [split $tmp_string]
        UI_PB_debug_ForceMsg "@@@@@ INCLUDE fields: >$fields<\n"
        foreach one $fields {
         if { [string length $one] > 0 } {
          if [string match "*.cdl" $one] {
           if { [string compare $own_cdl_file [file tail $one]] &&\
            [string compare "\$UGII_CAM_USER_DEF_EVENT_DIR/ude.cdl" $one] } {
            set one [string trim [PB_mthd_find_included_file $pui_dir $one]]
            if { [string length $one] == 0 } { continue }
            UI_PB_debug_ForceMsg "@@@@@ INCLUDE CDL:$one<"
            set ::gPB(CR8_EXT_OBJ) 1
            set cdl_file_id FP3
            PB_com_ReadUdeFile one cdl_file_id post_object
            set ::gPB(CR8_EXT_OBJ) 0
           }
           } elseif [string match "*.def" $one] {
           set one [string trim [PB_mthd_find_included_file $pui_dir $one]]
           if { [string length $one] == 0 } { continue }
           UI_PB_debug_ForceMsg "@@@@@ INCLUDE DEF:$one<"
           PB_mthd_ParseADefFile one bef_com_data word_sep_arr \
           end_line_arr sequence_arr format_arr \
           address_arr block_arr aft_com_data arr_size
           lappend ::gPB(def_file_list) $one
          }
         }
        }
       } ;# JE_POST_DEV
       set include_found 0
       if { $cdl_found == 0 } {
        set line [join $include_script \n]
        set save_para 1
       }
      } ;# PB_file_is_JE_POST_DEV
     } ;# complete INCLUDE statement
    } ;# include_found
    if { $formatting_flag } \
    {
     if { !$keyword_status } \
     {
      PB_mthd_CheckFormattingKeyWord line keyword_status
      if { $keyword_status } \
      {
       if { [info exists key_para] } \
       {
        set text $key_para
        unset key_para
       } else \
       {
        set text ""
       }
      }
     }
     if { $keyword_status } \
     {
      switch $keyword_status \
      {
       1  {
        lappend key_para $line
        PB_mthd_StoreKeyWordData key_para text word_sep_arr \
        word_sep_index file_name
        unset key_para
        unset text
        set keyword_status 0
       }
       2  {
        lappend key_para $line
        PB_mthd_StoreKeyWordData key_para text end_line_arr \
        end_line_index file_name
        set keyword_status 0
        unset key_para
        unset text
       }
       3  {
        lappend key_para $line
        PB_mthd_StoreKeyWordData key_para text sequence_arr \
        seq_index file_name
        set keyword_status 0
        unset key_para
        unset text
       }
       4  {
        lappend key_para $line
        PB_mthd_StoreKeyWordData key_para text format_arr \
        fmt_index file_name
        incr fmt_index
        set keyword_status 0
        unset key_para
        unset text
       }
       5  {
        PB_com_CheckOpenBracesInLine line open_flag
        PB_com_CheckCloseBracesInLine line close_flag
        lappend key_para $line
        if {$close_flag} \
        {
         PB_mthd_StoreKeyWordData key_para text address_arr \
         add_index file_name
         incr add_index
         set keyword_status 0
         unset key_para
         unset text
        }
       }
       6  {
        PB_com_CheckOpenBracesInLine line open_flag
        PB_com_CheckCloseBracesInLine line close_flag
        lappend key_para $line
        if {$close_flag} \
        {
         PB_mthd_StoreKeyWordData key_para text block_arr \
         blk_index file_name
         incr blk_index
         set keyword_status 0
         unset key_para
         unset text
        }
       }
      }
      } elseif { [string match "*\{*" $line] } \
      {
       set format_open_brace 1
       continue
       } elseif { [string match "*\}*" $line] } \
     {
      set format_open_brace 0
      set formatting_flag 0
      if { [info exists key_para] } \
      {
       unset key_para
      }
      continue
     }
     continue
    }
    if $save_para { lappend key_para $line }
   }
   if { $__update_mom_sys } {
    set Post::($post_object,mom_sys_var_list) [array get mom_sys_arr]
   }
   PB_mthd_StoreCommentData aft_com_data key_para file_name
   set arr_size($file_name,format)  $fmt_index
   set arr_size($file_name,address) $add_index
   set arr_size($file_name,block)   $blk_index
   UI_PB_debug_ForceMsg "@@@@@ >bef_com_data: [array get bef_com_data]"
   UI_PB_debug_ForceMsg "@@@@@ >word_sep_arr: [array get word_sep_arr]"
   UI_PB_debug_ForceMsg "@@@@@ >end_line_arr: [array get end_line_arr]"
   UI_PB_debug_ForceMsg "@@@@@ >sequence_arr: [array get sequence_arr]"
   UI_PB_debug_ForceMsg "@@@@@ >format_arr  : [array get format_arr]"
   UI_PB_debug_ForceMsg "@@@@@ >address_arr : [array get address_arr]"
   UI_PB_debug_ForceMsg "@@@@@ >block_arr   : [array get block_arr]"
   UI_PB_debug_ForceMsg "@@@@@ >aft_com_data: [array get aft_com_data]"
   close $FilePointer
  }

#=======================================================================
proc PB_mthd_ParseADefFile { SOURCE_FILE BEF_COM_DATA WORD_SEP_ARR \
  END_LINE_ARR SEQUENCE_ARR FORMAT_ARR \
  ADDRESS_ARR BLOCK_ARR AFT_COM_DATA ARR_SIZE } {
  upvar $SOURCE_FILE   source_file
  upvar $BEF_COM_DATA  bef_com_data
  upvar $WORD_SEP_ARR  word_sep_arr
  upvar $END_LINE_ARR  end_line_arr
  upvar $SEQUENCE_ARR  sequence_arr
  upvar $FORMAT_ARR    format_arr
  upvar $ADDRESS_ARR   address_arr
  upvar $BLOCK_ARR     block_arr
  upvar $AFT_COM_DATA  aft_com_data
  upvar $ARR_SIZE      arr_size
  UI_PB_debug_ForceMsg "@@@@@ >source file: $source_file"
  set FilePointer [open "[lindex $source_file 0]" r]
  set file_list   [split "[lindex $source_file 0]" //]
  set file_name   [lindex $file_list [expr [llength $file_list] -1]]
  global post_object
  PB_int_ReadPostFiles pui_dir def_file tcl_file
  UI_PB_debug_ForceMsg "\n@@@@@ Post's Tcl: >$tcl_file<  Def: >$def_file<\n"
  set keyword_status 0
  set format_open_brace 0
  set word_sep_index 0
  set end_line_index 0
  set seq_index 0
  set fmt_index 0
  set add_index 0
  set blk_index 0
  set formatting_flag 0
  set include_found 0
  set cdl_found 0
  set own_cdl_file [file rootname [file tail $tcl_file]].cdl
  UI_PB_debug_ForceMsg "@@@@@ >Parsing $file_name  of $::gpb_pui_file"
  set pui_file [file rootname [file tail $::gpb_pui_file]]
  set def_file [file rootname [file tail $file_name]]
  array set mom_sys_arr $Post::($post_object,mom_sys_var_list)
  set __update_mom_sys 0
  while { [gets $FilePointer line] >= 0 } \
  {
   UI_PB_debug_DisplayMsg $line
   set save_para 1
   if { !$formatting_flag && [string match "#*" [string trim $line]] } {
    continue
   }
   if { [string match "*FORMATTING*" $line] == 1 } \
   {
    PB_mthd_StoreCommentData bef_com_data key_para file_name
    set formatting_flag 1
    if [info exists key_para] { unset key_para }
    continue
    } elseif { [string match "*INCLUDE*" $line] == 1 } \
   {
    UI_PB_debug_ForceMsg "@@@@@ >$line<"
    set include_found 1
    set include_brace_count 0
    set include_script [list]
   }
   if { ($include_found || $cdl_found)  &&  ![string length [string trim $line]] } {
    continue
   }
   if $include_found {
    set save_para 0
    if 0 { ;# See changes below
     if { [string compare $def_file $::gPB(edit_post_name)] != 0 } {
      set line ""
     }
    }
    lappend include_script [string trim $line]
    set left_brace_count  [llength [split $include_script \{]]
    set right_brace_count [llength [split $include_script \}]]
    if [expr $left_brace_count > $right_brace_count] {
     incr include_brace_count
    }
    if [expr $left_brace_count < $right_brace_count] {
     incr include_brace_count -1
    }
    UI_PB_debug_ForceMsg "@@@@@ INCLUDE statement: >$include_script< \n"
    if { $left_brace_count == $right_brace_count } {
     if { [info exists ::gPB(edit_post_name)] } {
      UI_PB_debug_ForceMsg "\n@@@@@ gPB(edit_post_name): >$::gPB(edit_post_name)<\n"
      if { [string compare $def_file $::gPB(edit_post_name)] != 0 } {
       UI_PB_debug_ForceMsg "\n@@@@@ Do not add INCLUDE from other post fragment: >$def_file< \n"
       set include_script {}
       set include_found 0 ;# This line is critical!
      }
     }
     if { [llength $include_script] && [string match "*\}" $include_script] } {
     if { [string match "*.cdl*" $include_script] || \
      [string match "*.def*" $include_script] } {
      set cdl_found 1
      regsub -all {\\} $include_script {} word_list
      regsub -all {\{} $word_list      {} word_list
       regsub -all {\}} $word_list      {} word_list
       if { [lsearch -glob $word_list "*.cdl*"] >= 0 } {
        UI_PB_debug_ForceMsg "@@@@@ INCLUDE'd CDL: $word_list"
        set ude [string trim [string trimleft $word_list INCLUDE]]
        if 0 {
         if { ![info exists Post::($post_object,UDE_File_Name)] || \
          ![string length $Post::($post_object,UDE_File_Name)] } {
          set Post::($post_object,UDE_File_Name) $ude
         }
         } else {
         UI_PB_debug_ForceMsg "@@@@@ def_file: $def_file  pui_file: $pui_file"
         set file_match 0
         if { [string match "windows" $::tcl_platform(platform)] && [expr $::tcl_version > 8.0] } {
          if { ![string compare -nocase $def_file $pui_file] } { set file_match 1 }
          } else {
          if { ![string compare $def_file $pui_file] } { set file_match 1 }
         }
         if { $file_match } {
          set Post::($post_object,UDE_File_Name) $ude
          if 1 {
           set indx 0
           foreach f $ude {
            UI_PB_debug_ForceMsg "@@@@@ Comparing own CDL: [file tail $f]  $indx  pui_file: $pui_file.cdl"
            set file_match 0
            if { [string match "windows" $::tcl_platform(platform)] && [expr $::tcl_version > 8.0] } {
             if { ![string compare -nocase "$pui_file.cdl" [file tail $f]] } { set file_match 1 }
             } else {
             if { ![string compare "$pui_file.cdl" [file tail $f]] } { set file_match 1 }
            }
            if { $file_match } {
             set mom_sys_arr(Own_UDE) 1
             set mom_sys_arr(OWN_CDL_File_Folder) "[file dirname $f]"
             set __update_mom_sys 1
             UI_PB_debug_ForceMsg "@@@@@ Found own CDL: $f $indx"
             set Post::($post_object,UDE_File_Name_save) $ude
             set Post::($post_object,UDE_File_Name) [lreplace $ude $indx $indx]
             break
            }
            incr indx
           }
          } ;# if 1
         } ;# file_match
        } ;# if 1
        set Post::($post_object,UDE_File_Name) [join $Post::($post_object,UDE_File_Name)]
        UI_PB_debug_ForceMsg "@@@@@ Other CDL: $Post::($post_object,UDE_File_Name)"
       }
      } ;# cdl_found in INCLUDE
      if [PB_file_is_JE_POST_DEV] {
       regsub -all {\\} $include_script {} tmp_string
       regsub -all {\{} $tmp_string     {} tmp_string
        regsub -all {\}} $tmp_string     {} tmp_string
        regsub -all {\$}  $tmp_string     {\\$} tmp_string
        set tmp_string [string trim [string trimleft $tmp_string INCLUDE]]
        set fields [split $tmp_string]
        UI_PB_debug_ForceMsg "@@@@@ INCLUDE fields: >$fields<\n"
        foreach one $fields {
         if { [string length $one] > 0 } {
          if [string match "*.cdl" $one] {
           if { [string compare $own_cdl_file [file tail $one]] &&\
            [string compare "\$UGII_CAM_USER_DEF_EVENT_DIR/ude.cdl" $one] } {
            set one [string trim [PB_mthd_find_included_file $pui_dir $one]]
            if { [string length $one] == 0 } { continue }
            UI_PB_debug_ForceMsg "@@@@@ INCLUDE CDL:$one<"
            set ::gPB(CR8_EXT_OBJ) 1
            set cdl_file_id FP3
            PB_com_ReadUdeFile one cdl_file_id post_object
            set ::gPB(CR8_EXT_OBJ) 0
           }
           } elseif [string match "*.def" $one] {
           set one [string trim [PB_mthd_find_included_file $pui_dir $one]]
           if { [string length $one] == 0 } { continue }
           UI_PB_debug_ForceMsg "@@@@@ INCLUDE DEF:$one<"
           PB_mthd_ParseADefFile one bef_com_data word_sep_arr \
           end_line_arr sequence_arr format_arr \
           address_arr block_arr aft_com_data arr_size
           lappend ::gPB(def_file_list) $one
          }
         }
        }
       } ;# PB_file_is_JE_POST_DEV
       set include_found 0
       if { $cdl_found == 0 } {
        set line [join $include_script \n]
        set save_para 1
       }
      } ;# include_script
     } ;# complete INCLUDE statement
    } ;# include_found
    if { $formatting_flag } \
    {
     if { !$keyword_status } \
     {
      PB_mthd_CheckFormattingKeyWord line keyword_status
      if { $keyword_status } \
      {
       if { [info exists key_para] } \
       {
        set text $key_para
        unset key_para
       } else \
       {
        set text ""
       }
      }
     }
     if { $keyword_status } \
     {
      switch $keyword_status \
      {
       1  {
        lappend key_para $line
        PB_mthd_StoreKeyWordData key_para text word_sep_arr \
        word_sep_index file_name
        unset key_para
        unset text
        set keyword_status 0
       }
       2  {
        lappend key_para $line
        PB_mthd_StoreKeyWordData key_para text end_line_arr \
        end_line_index file_name
        set keyword_status 0
        unset key_para
        unset text
       }
       3  {
        lappend key_para $line
        PB_mthd_StoreKeyWordData key_para text sequence_arr \
        seq_index file_name
        set keyword_status 0
        unset key_para
        unset text
       }
       4  {
        lappend key_para $line
        PB_mthd_StoreKeyWordData key_para text format_arr \
        fmt_index file_name
        incr fmt_index
        set keyword_status 0
        unset key_para
        unset text
       }
       5  {
        PB_com_CheckOpenBracesInLine line open_flag
        PB_com_CheckCloseBracesInLine line close_flag
        lappend key_para $line
        if {$close_flag} \
        {
         PB_mthd_StoreKeyWordData key_para text address_arr \
         add_index file_name
         incr add_index
         set keyword_status 0
         unset key_para
         unset text
        }
       }
       6  {
        PB_com_CheckOpenBracesInLine line open_flag
        PB_com_CheckCloseBracesInLine line close_flag
        lappend key_para $line
        if {$close_flag} \
        {
         PB_mthd_StoreKeyWordData key_para text block_arr \
         blk_index file_name
         incr blk_index
         set keyword_status 0
         unset key_para
         unset text
        }
       }
      }
      } elseif { [string match "*\{*" $line] } \
      {
       set format_open_brace 1
       continue
       } elseif { [string match "*\}*" $line] } \
     {
      set format_open_brace 0
      set formatting_flag 0
      if { [info exists key_para] } \
      {
       unset key_para
      }
      continue
     }
     continue
    }
    if $save_para { lappend key_para $line }
   }
   if { $__update_mom_sys } {
    set Post::($post_object,mom_sys_var_list) [array get mom_sys_arr]
   }
   PB_mthd_StoreCommentData aft_com_data key_para file_name
   set arr_size($file_name,format)  $fmt_index
   set arr_size($file_name,address) $add_index
   set arr_size($file_name,block)   $blk_index
   UI_PB_debug_ForceMsg "@@@@@ >bef_com_data: [array get bef_com_data]"
   UI_PB_debug_ForceMsg "@@@@@ >word_sep_arr: [array get word_sep_arr]"
   UI_PB_debug_ForceMsg "@@@@@ >end_line_arr: [array get end_line_arr]"
   UI_PB_debug_ForceMsg "@@@@@ >sequence_arr: [array get sequence_arr]"
   UI_PB_debug_ForceMsg "@@@@@ >format_arr  : [array get format_arr]"
   UI_PB_debug_ForceMsg "@@@@@ >address_arr : [array get address_arr]"
   UI_PB_debug_ForceMsg "@@@@@ >block_arr   : [array get block_arr]"
   UI_PB_debug_ForceMsg "@@@@@ >aft_com_data: [array get aft_com_data]"
   close $FilePointer
  }
  } else {

#=======================================================================
proc PB_mthd_DefFileInitParse { parse_obj file_name } {
  global gPB
  if [info exists gPB(def_file_list)] {
   set def_file_list $gPB(def_file_list)
  }
  lappend def_file_list "$file_name"
  set gPB(def_file_list) $def_file_list
  PB_mthd_ParseADefFile def_file_list bef_com_data word_sep_arr end_line_arr \
  sequence_arr format_arr address_arr block_arr \
  aft_com_data arr_size
  set def_file_list $gPB(def_file_list)
  foreach name $def_file_list \
  {
   set file_list [split $name //]
   set f_name [lindex $file_list [expr [llength $file_list] -1]]
   lappend trunc_file_name $f_name
  }
  if [info exists bef_com_data] \
  {
   set ParseFile::($parse_obj,bef_com_data_list) [array get bef_com_data]
  }
  if [info exists word_sep_arr] \
  {
   set ParseFile::($parse_obj,word_sep_list)     [array get word_sep_arr]
  }
  if [info exists end_line_arr] \
  {
   set ParseFile::($parse_obj,end_line_list)     [array get end_line_arr]
  }
  if [info exists sequence_arr] \
  {
   set ParseFile::($parse_obj,sequence_list)     [array get sequence_arr]
  }
  if [info exists format_arr] \
  {
   set ParseFile::($parse_obj,format_list)       [array get format_arr]
  }
  if [info exists address_arr] \
  {
   set ParseFile::($parse_obj,address_list)      [array get address_arr]
  }
  if [info exists block_arr] \
  {
   set ParseFile::($parse_obj,block_temp_list)   [array get block_arr]
  }
  if [info exists aft_com_data] \
  {
   set ParseFile::($parse_obj,aft_com_data_list) [array get aft_com_data]
  }
  if [info exists arr_size] \
  {
   set ParseFile::($parse_obj,arr_size_list)     [array get arr_size]
  }
  if [info exists trunc_file_name] \
  {
   set ParseFile::($parse_obj,file_list)         $trunc_file_name
  }
 }

#=======================================================================
proc PB_mthd_ParseADefFile { SOURCE_FILE BEF_COM_DATA WORD_SEP_ARR \
  END_LINE_ARR SEQUENCE_ARR FORMAT_ARR \
  ADDRESS_ARR BLOCK_ARR AFT_COM_DATA ARR_SIZE } {
  upvar $SOURCE_FILE   source_file
  upvar $BEF_COM_DATA  bef_com_data
  upvar $WORD_SEP_ARR  word_sep_arr
  upvar $END_LINE_ARR  end_line_arr
  upvar $SEQUENCE_ARR  sequence_arr
  upvar $FORMAT_ARR    format_arr
  upvar $ADDRESS_ARR   address_arr
  upvar $BLOCK_ARR     block_arr
  upvar $AFT_COM_DATA  aft_com_data
  upvar $ARR_SIZE      arr_size
  UI_PB_debug_ForceMsg "@@@@@ >source file: $source_file"
  set FilePointer [open "[lindex $source_file 0]" r]
  set file_list   [split "[lindex $source_file 0]" //]
  set file_name   [lindex $file_list [expr [llength $file_list] -1]]
  __mthd_ParseADefFile  $FilePointer $file_name \
  bef_com_data word_sep_arr end_line_arr \
  sequence_arr format_arr address_arr block_arr \
  aft_com_data arr_size
  UI_PB_debug_ForceMsg "@@@@@ >bef_com_data: [array get bef_com_data]"
  UI_PB_debug_ForceMsg "@@@@@ >word_sep_arr: [array get word_sep_arr]"
  UI_PB_debug_ForceMsg "@@@@@ >end_line_arr: [array get end_line_arr]"
  UI_PB_debug_ForceMsg "@@@@@ >sequence_arr: [array get sequence_arr]"
  UI_PB_debug_ForceMsg "@@@@@ >format_arr  : [array get format_arr]"
  UI_PB_debug_ForceMsg "@@@@@ >address_arr : [array get address_arr]"
  UI_PB_debug_ForceMsg "@@@@@ >block_arr   : [array get block_arr]"
  UI_PB_debug_ForceMsg "@@@@@ >aft_com_data: [array get aft_com_data]"
  close $FilePointer
 }

#=======================================================================
proc __mthd_ParseADefFile { FilePointer file_name \
  BEF_COM_DATA WORD_SEP_ARR \
  END_LINE_ARR SEQUENCE_ARR FORMAT_ARR \
  ADDRESS_ARR BLOCK_ARR AFT_COM_DATA ARR_SIZE {_is_external 0} } {
  upvar $BEF_COM_DATA bef_com_data
  upvar $WORD_SEP_ARR word_sep_arr
  upvar $END_LINE_ARR end_line_arr
  upvar $SEQUENCE_ARR sequence_arr
  upvar $FORMAT_ARR   format_arr
  upvar $ADDRESS_ARR  address_arr
  upvar $BLOCK_ARR    block_arr
  upvar $AFT_COM_DATA aft_com_data
  upvar $ARR_SIZE     arr_size
  global post_object
  PB_int_ReadPostFiles pui_dir def_file tcl_file
  set keyword_status 0
  set format_open_brace 0
  set word_sep_index 0
  set end_line_index 0
  set seq_index 0
  set fmt_index 0
  set add_index 0
  set blk_index 0
  set formatting_flag 0
  set include_found 0
  set cdl_found 0
  set own_cdl_file [file rootname [file tail $tcl_file]].cdl
  UI_PB_debug_ForceMsg "@@@@@ >Parsing $file_name"
  while { [gets $FilePointer line] >= 0 } \
  {
   UI_PB_debug_DisplayMsg $line
   set save_para 1
   if { [string match "*FORMATTING*" $line] == 1 } \
   {
    PB_mthd_StoreCommentData bef_com_data key_para file_name
    set formatting_flag 1
    if [info exists key_para] { unset key_para }
    continue
    } elseif { [string match "*INCLUDE*" $line] == 1 } \
   {
    UI_PB_debug_ForceMsg "@@@@@ >$line<"
    set include_found 1
    set include_brace_count 0
    set include_script [list]
   }
   if { $cdl_found  &&  ![string length [string trim $line]] } {
    continue
   }
   if $include_found {
    set save_para 0
    set left_brace_count  [llength [split $line \{]]
    set right_brace_count [llength [split $line \}]]
    if [expr $left_brace_count > $right_brace_count] {
     incr include_brace_count
    }
    if [expr $left_brace_count < $right_brace_count] {
     incr include_brace_count -1
    }
    lappend include_script [string trim $line]
    if { $include_brace_count == 0 } {
     if { [llength $include_script] && [string match "*\}" $include_script] } {
     if [string match "*.cdl*" $include_script] {
      set cdl_found 1
      set word_list [split $include_script \{]
      set word_list [split $word_list \}]
      set idx [lsearch -glob $word_list "*.cdl*"]
      if { $idx >= 0 } {
       set ude [lindex $word_list $idx]
       regsub -all {\\} $ude {} ude
       set ude [string trim $ude]
       set Post::($post_object,UDE_File_Name) $ude
      }
     }
     if 1 {
      if [PB_file_is_JE_POST_DEV] {
       set tmp_string [string trim [string trimleft  $include_script \{]]
        set tmp_string [string trim [string trimleft  $tmp_string INCLUDE]]
        set tmp_string [string trim [string trimleft  $tmp_string \{]]
        set tmp_string [string trim [string trimright $tmp_string \}]]
        set fields [split $tmp_string]
        foreach one $fields {
         UI_PB_debug_ForceMsg "@@@@@ INCLUDE:  >own CDL:$own_cdl_file<  >[file tail $one]<"
         set one [string trim [PB_mthd_find_included_file $pui_dir $one]]
         if { [string length $one] > 0 } {
          if [string match "*.cdl" $one] {
           if { [string compare $own_cdl_file [file tail $one]] &&\
            [string compare "\$UGII_CAM_USER_DEF_EVENT_DIR/ude.cdl" $one] } {
            UI_PB_debug_ForceMsg "@@@@@ INCLUDE CDL:$one<"
            set cdl_file_id FP3
            PB_com_ReadUdeFile one cdl_file_id post_object
           }
           } elseif [string match "*.def" $one] {
           UI_PB_debug_ForceMsg "@@@@@ INCLUDE DEF:$one<"
           set file_id [open "$one" r]
           __mthd_ParseADefFile  $file_id [file tail $one] \
           bef_com_data__dummy word_sep_arr end_line_arr \
           sequence_arr format_arr address_arr block_arr \
           aft_com_data__dummy arr_size 1
           global gPB
           lappend gPB(def_file_list) $one
          }
         }
        }
       } ;# JE_POST_DEV
       set include_found 0
       if { $cdl_found == 0 } {
        set line [join $include_script \n]
        set save_para 1
       }
      }
     } ;# Disabled
    }
   }
   if { $formatting_flag } \
   {
    if { !$keyword_status } \
    {
     PB_mthd_CheckFormattingKeyWord line keyword_status
     if { $keyword_status } \
     {
      if { [info exists key_para] } \
      {
       set text $key_para
       unset key_para
      } else \
      {
       set text ""
      }
     }
    }
    if { $keyword_status } \
    {
     switch $keyword_status \
     {
      1  {
       lappend key_para $line
       PB_mthd_StoreKeyWordData key_para text word_sep_arr \
       word_sep_index file_name
       unset key_para
       unset text
       set keyword_status 0
      }
      2  {
       lappend key_para $line
       PB_mthd_StoreKeyWordData key_para text end_line_arr \
       end_line_index file_name
       set keyword_status 0
       unset key_para
       unset text
      }
      3  {
       lappend key_para $line
       PB_mthd_StoreKeyWordData key_para text sequence_arr \
       seq_index file_name
       set keyword_status 0
       unset key_para
       unset text
      }
      4  {
       lappend key_para $line
       PB_mthd_StoreKeyWordData key_para text format_arr \
       fmt_index file_name
       incr fmt_index
       set keyword_status 0
       unset key_para
       unset text
      }
      5  {
       PB_com_CheckOpenBracesInLine line open_flag
       PB_com_CheckCloseBracesInLine line close_flag
       lappend key_para $line
       if {$close_flag} \
       {
        PB_mthd_StoreKeyWordData key_para text address_arr \
        add_index file_name
        incr add_index
        set keyword_status 0
        unset key_para
        unset text
       }
      }
      6  {
       PB_com_CheckOpenBracesInLine line open_flag
       PB_com_CheckCloseBracesInLine line close_flag
       lappend key_para $line
       if {$close_flag} \
       {
        PB_mthd_StoreKeyWordData key_para text block_arr \
        blk_index file_name
        incr blk_index
        set keyword_status 0
        unset key_para
        unset text
       }
      }
     }
     } elseif { [string match "*\{*" $line] } \
     {
      set format_open_brace 1
      continue
      } elseif { [string match "*\}*" $line] } \
    {
     set format_open_brace 0
     set formatting_flag 0
     if { [info exists key_para] } \
     {
      unset key_para
     }
     continue
    }
    continue
   }
   if $save_para { lappend key_para $line }
  }
  PB_mthd_StoreCommentData aft_com_data key_para file_name
  set arr_size($file_name,format)  $fmt_index
  set arr_size($file_name,address) $add_index
  set arr_size($file_name,block)   $blk_index
 }
} ;# if 0

#=======================================================================
proc PB_mthd_find_included_file { def_file_dir file_spec } {
  if [file exists $file_spec] {
   return $file_spec
  }
  set file_tail "[file tail $file_spec]"
  set file_name "$def_file_dir/$file_tail"
  if [file exists $file_name] {
   return $file_name
  }
  if [info exists ::gPB(DEF_INCLUDE_SUB_FOLDER)] {
   set file_name "$def_file_dir/$::gPB(DEF_INCLUDE_SUB_FOLDER)/$file_tail"
   if [file exists $file_name] {
    return $file_name
   }
  }
  UI_PB_debug_ForceMsg "@@@@@ > Include file: $file_name not found"
  return ""
 }
 if 0 {

#=======================================================================
proc PB_mthd_ParseADefFile__X { SOURCE_FILE BEF_COM_DATA WORD_SEP_ARR \
  END_LINE_ARR SEQUENCE_ARR FORMAT_ARR \
  ADDRESS_ARR BLOCK_ARR AFT_COM_DATA ARR_SIZE } {
  upvar $SOURCE_FILE source_file
  upvar $BEF_COM_DATA bef_com_data
  upvar $WORD_SEP_ARR word_sep_arr
  upvar $END_LINE_ARR end_line_arr
  upvar $SEQUENCE_ARR sequence_arr
  upvar $FORMAT_ARR format_arr
  upvar $ADDRESS_ARR address_arr
  upvar $BLOCK_ARR block_arr
  upvar $AFT_COM_DATA aft_com_data
  upvar $ARR_SIZE arr_size
  global post_object
  if [info exists ude_file] { unset ude_file }
  set keyword_status 0
  set format_open_brace 0
  set word_sep_index 0
  set end_line_index 0
  set seq_index 0
  set fmt_index 0
  set add_index 0
  set blk_index 0
  set formatting_flag 0
  set FilePointer [open "[lindex $source_file 0]" r]
  set file_list [split "[lindex $source_file 0]" //]
  set file_name [lindex $file_list [expr [llength $file_list] -1]]
  set include_found 0
  set cdl_found 0
  while { [gets $FilePointer line] >= 0 } \
  {
   UI_PB_debug_DisplayMsg $line
   set save_para 1
   if { [string match "*FORMATTING*" $line] == 1 } \
   {
    PB_mthd_StoreCommentData bef_com_data key_para file_name
    set formatting_flag 1
    if [info exists key_para] { unset key_para}
    continue
    } elseif { [string match "*INCLUDE*" $line] == 1 } \
   {
    set include_found 1
    set include_brace_count 0
    set include_script [list]
   }
   if { $cdl_found  &&  ![string length [string trim $line]] } {
    continue
   }
   if $include_found {
    set save_para 0
    set left_brace_count  [llength [split $line \{]]
    set right_brace_count [llength [split $line \}]]
    if [expr $left_brace_count > $right_brace_count] {
     incr include_brace_count
    }
    if [expr $left_brace_count < $right_brace_count] {
     incr include_brace_count -1
    }
    lappend include_script [string trim $line]
    if { $include_brace_count == 0 } {
     if { [llength $include_script] && [string match "*\}" $include_script] } {
     if [string match "*.cdl*" $include_script] {
      set cdl_found 1
      set word_list [split $include_script \{]
      set word_list [split $word_list \}]
      set idx [lsearch -glob $word_list "*.cdl*"]
      if { $idx >= 0 } {
       set ude [lindex $word_list $idx]
       regsub -all {\\} $ude {} ude
       set ude [string trim $ude]
       set Post::($post_object,UDE_File_Name) $ude
      }
     }
     if [PB_file_is_JE_POST_DEV] {
      set tmp_string [string trim [string trimleft  $include_script \{]]
       set tmp_string [string trim [string trimleft  $tmp_string INCLUDE]]
       set tmp_string [string trim [string trimleft  $tmp_string \{]]
       set tmp_string [string trim [string trimright $tmp_string \}]]
       set fields [split $tmp_string]
       foreach one $fields {
        set one [string trim [PB_mthd_sub_ugii_env_vars $one]]
        if [string match "*.cdl" $one] {
         } elseif [string match "*.def" $one] {
         lappend def_file_list "$one"
         PB_mthd_ParseADefFile def_file_list bef_com_data__dummy word_sep_arr end_line_arr \
         sequence_arr format_arr address_arr block_arr \
         aft_com_data__dummy arr_size
        }
       }
      } ;# JE_POST_DEV
      set include_found 0
      if { $cdl_found == 0 } {
       set line [join $include_script \n]
       set save_para 1
      }
     }
    }
   }
   if { $formatting_flag } \
   {
    if { !$keyword_status } \
    {
     PB_mthd_CheckFormattingKeyWord line keyword_status
     if { $keyword_status } \
     {
      if { [info exists key_para] } \
      {
       set text $key_para
       unset key_para
      } else \
      {
       set text ""
      }
     }
    }
    if { $keyword_status } \
    {
     switch $keyword_status \
     {
      1  {
       lappend key_para $line
       PB_mthd_StoreKeyWordData key_para text word_sep_arr \
       word_sep_index file_name
       unset key_para
       unset text
       set keyword_status 0
      }
      2  {
       lappend key_para $line
       PB_mthd_StoreKeyWordData key_para text end_line_arr \
       end_line_index file_name
       set keyword_status 0
       unset key_para
       unset text
      }
      3  {
       lappend key_para $line
       PB_mthd_StoreKeyWordData key_para text sequence_arr \
       seq_index file_name
       set keyword_status 0
       unset key_para
       unset text
      }
      4  {
       lappend key_para $line
       PB_mthd_StoreKeyWordData key_para text format_arr \
       fmt_index file_name
       incr fmt_index
       set keyword_status 0
       unset key_para
       unset text
      }
      5  {
       PB_com_CheckOpenBracesInLine line open_flag
       PB_com_CheckCloseBracesInLine line close_flag
       lappend key_para $line
       if {$close_flag} \
       {
        PB_mthd_StoreKeyWordData key_para text address_arr \
        add_index file_name
        incr add_index
        set keyword_status 0
        unset key_para
        unset text
       }
      }
      6  {
       PB_com_CheckOpenBracesInLine line open_flag
       PB_com_CheckCloseBracesInLine line close_flag
       lappend key_para $line
       if {$close_flag} \
       {
        PB_mthd_StoreKeyWordData key_para text block_arr \
        blk_index file_name
        incr blk_index
        set keyword_status 0
        unset key_para
        unset text
       }
      }
     }
     } elseif { [string match "*\{*" $line] } \
     {
      set format_open_brace 1
      continue
      } elseif { [string match "*\}*" $line] } \
    {
     set format_open_brace 0
     set formatting_flag 0
     if { [info exists key_para] } \
     {
      unset key_para
     }
     continue
    }
    continue
   }
   if $save_para { lappend key_para $line }
  }
  PB_mthd_StoreCommentData aft_com_data key_para file_name
  set arr_size($file_name,format)  $fmt_index
  set arr_size($file_name,address) $add_index
  set arr_size($file_name,block)   $blk_index
  close $FilePointer
 }
} ;# if 0

#=======================================================================
proc PB_mthd_CheckFormattingKeyWord { LINE KEYWORD_STATUS } {
  upvar $LINE line
  upvar $KEYWORD_STATUS keyword_status
  if { [string match "*#*" $line] == 1 } { return }
  if {       [string match "*WORD_SEPARATOR*" $line] } \
  {
   set keyword_status 1
   } elseif { [string match "*END_OF_LINE*"    $line] } \
  {
   set keyword_status 2
   } elseif { [string match "*SEQUENCE*"       $line] } \
  {
   set keyword_status 3
   } elseif { [string match "*FORMAT*"         $line] } \
  {
   set keyword_status 4
   } elseif { [string match "*ADDRESS*"        $line] } \
  {
   set keyword_status 5
   } elseif { [string match "*BLOCK_TEMPLATE*" $line] } \
  {
   set keyword_status 6
  }
 }

#=======================================================================
proc PB_mthd_StoreCommentData { ARR_VAR KEY_PARA FILE_NAME } {
  upvar $ARR_VAR arr_var
  upvar $KEY_PARA key_para
  upvar $FILE_NAME file_name
  if {[info exists key_para]} \
  {
   set arr_var($file_name) $key_para
  } else \
  {
   set arr_var($file_name) ""
  }
 }

#=======================================================================
proc PB_mthd_StoreKeyWordData { KEY_PARA TEXT ARR_VAR INDEX FILE_NAME } {
  upvar $KEY_PARA key_para
  upvar $TEXT text
  upvar $ARR_VAR arr_var
  upvar $INDEX index
  upvar $FILE_NAME file_name
  set arr_var($file_name,$index,text) $text
  set arr_var($file_name,$index,data) $key_para
 }

#=======================================================================
proc PB_mthd_RetMachineToolAttr { MOM_KIN_VAR_ARR } {
  upvar $MOM_KIN_VAR_ARR mom_kin_var_arr
  global post_object
  set mom_kin_var_list $Post::($post_object,mom_kin_var_list)
  array set mom_kin_var_arr $mom_kin_var_list
  set Post::($post_object,def_mom_kin_var_list) $mom_kin_var_list
 }

#=======================================================================
proc PB_mthd_RetSimulationAttr { MOM_SIM_VAR_ARR } {
  upvar $MOM_SIM_VAR_ARR mom_sim_var_arr
  global post_object
  set mom_sim_var_list $Post::($post_object,mom_sim_var_list)
  array set mom_sim_var_arr $mom_sim_var_list
  set Post::($post_object,def_mom_sim_var_list) $mom_sim_var_list
 }

#=======================================================================
proc PB_mthd_GetWordSep { file_obj } {
  global post_object
  array set wordsep_arr $ParseFile::($file_obj,word_sep_list)
  set file_name_list $ParseFile::($file_obj,file_list)
  set file_name [lindex $file_name_list 0]
  if [info exists wordsep_arr($file_name,0,data)] {
   set line [lindex $wordsep_arr($file_name,0,data) 0]
   set temp_list [split $line \"]
   set word_sep [lindex $temp_list 1]
   set Post::($post_object,word_sep) $word_sep
   set Post::($post_object,def_word_sep) $word_sep
  }
 }

#=======================================================================
proc PB_mthd_GetEndOfLine { file_obj } {
  global post_object
  array set endline_arr $ParseFile::($file_obj,end_line_list)
  set file_name_list $ParseFile::($file_obj,file_list)
  set file_name [lindex $file_name_list 0]
  if [info exists endline_arr($file_name,0,data)] {
   set line [lindex $endline_arr($file_name,0,data) 0]
   set temp_list [split $line \"]
   set end_of_line [lindex $temp_list 1]
   set Post::($post_object,end_of_line) $end_of_line
   set Post::($post_object,def_end_of_line) $end_of_line
  }
 }

#=======================================================================
proc __PB_mthd_GetEndOfLine { file_obj } {
  global post_object
  array set endline_arr $ParseFile::($file_obj,end_line_list)
  set file_name_list $ParseFile::($file_obj,file_list)
  set file_name [lindex $file_name_list 0]
  set line [lindex $endline_arr($file_name,0,data) 0]
  set temp_list [split $line \"]
  set end_of_line [lindex $temp_list 1]
  set Post::($post_object,end_of_line) $end_of_line
  set Post::($post_object,def_end_of_line) $end_of_line
 }

#=======================================================================
proc PB_mthd_GetSequenceParams { file_obj } {
  global post_object
  array set seqparam_arr $ParseFile::($file_obj,sequence_list)
  set file_name_list $ParseFile::($file_obj,file_list)
  set file_name [lindex $file_name_list 0]
  if [info exists seqparam_arr($file_name,0,data)] {
   set line [lindex $seqparam_arr($file_name,0,data) 0]
   PB_com_RemoveBlanks line
   set seq_param(block)     [lindex $line 1]
   set seq_param(start)     [lindex $line 2]
   set seq_param(increment) [lindex $line 3]
   set seq_param(frequency) [lindex $line 4]
   if { [llength $line] > 5 } {
    set seq_param(maximum) [lindex $line 5]
    } else {
    set seq_param(maximum) ""
   }
   set Post::($post_object,sequence_param) [array get seq_param]
   set Post::($post_object,def_sequence_param) [array get seq_param]
  }
 }
