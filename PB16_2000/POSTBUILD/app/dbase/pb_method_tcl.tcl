#25

#=======================================================================
proc PB_mthd_ParseADefFile { SOURCE_FILE BEF_COM_DATA WORD_SEP_ARR \
  END_LINE_ARR SEQUENCE_ARR FORMAT_ARR \
  ADDRESS_ARR BLOCK_ARR AFT_COM_DATA ARR_SIZE} {
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
  while { [gets $FilePointer line] >= 0 } \
  {
   if { [string match "*FORMATTING*" $line] == 1} \
   {
    PB_mthd_StoreCommentData bef_com_data key_para file_name
    set formatting_flag 1
    unset key_para
    continue
    } elseif { [string match "*INCLUDE*" $line] == 1} \
   {
    set temp_line $line
    PB_com_RemoveBlanks temp_line
    foreach inc_file_name [lindex $temp_line 1] \
    {
     PB_mthd_ParseADefFile inc_file_name bef_com_data word_sep_arr \
     end_line_arr sequence_arr format_arr \
     address_arr block_arr aft_com_data \
     arr_size
     foreach inc_f_name $inc_file_name \
     {
      lappend source_file "$inc_f_name"
     }
    }
   }
   if {$formatting_flag} \
   {
    if {!$keyword_status} \
    {
     PB_mthd_CheckFormattingKeyWord line keyword_status
     if {$keyword_status} \
     {
      if {[info exists key_para]} \
      {
       set text $key_para
       unset key_para
      } else \
      {
       set text ""
      }
     }
    }
    if {$keyword_status} \
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
       PB_mthd_CheckOpenBracesInLine line open_flag
       PB_mthd_CheckCloseBracesInLine line close_flag
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
       PB_mthd_CheckOpenBracesInLine line open_flag
       PB_mthd_CheckCloseBracesInLine line close_flag
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
     } elseif {[string match "*\{*" $line]} \
     {
      set format_open_brace 1
      continue
      } elseif { [string match "*\}*" $line]} \
    {
     set format_open_brace 0
     set formatting_flag 0
     if {[info exists key_para]} \
     {
      unset key_para
     }
     continue
    }
    continue
   }
   lappend key_para $line
  }
  PB_mthd_StoreCommentData aft_com_data key_para file_name
  set arr_size($file_name,format) $fmt_index
  set arr_size($file_name,address) $add_index
  set arr_size($file_name,block) $blk_index
  close $FilePointer
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
proc PB_mthd_CheckFormattingKeyWord { LINE KEYWORD_STATUS } {
  upvar $LINE line
  upvar $KEYWORD_STATUS keyword_status
  if { [string match "*#*" $line] == 1 } { return }
  if { [string match "*WORD_SEPARATOR*" $line] == 1} \
  {
   set keyword_status 1
   } elseif { [string match "*END_OF_LINE*" $line] == 1 } \
  {
   set keyword_status 2
   } elseif { [string match "*SEQUENCE*" $line] == 1} \
  {
   set keyword_status 3
   } elseif { [string match "*FORMAT*" $line] == 1 }\
  {
   set keyword_status 4
   } elseif { [string match "*ADDRESS*" $line] } \
  {
   set keyword_status 5
   } elseif { [string match "*BLOCK_TEMPLATE*" $line]} \
  {
   set keyword_status 6
  }
 }

#=======================================================================
proc PB_mthd_CheckOpenBracesInLine { LINE OPEN_FLAG } {
  upvar $LINE line
  upvar $OPEN_FLAG open_flag
  set open_flag 0
  if {[string match "*\{*" $line] == 1} \
   {
    set open_flag 1
   }
  }

#=======================================================================
proc PB_mthd_CheckCloseBracesInLine { LINE CLOSE_FLAG } {
  upvar $LINE line
  upvar $CLOSE_FLAG close_flag
  set close_flag 0
  if {[string match "*\}*" $line] == 1} \
 {
  set close_flag 1
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
proc PB_mthd_DefFileInitParse { parse_obj file_name } {
  lappend def_file_list "$file_name"
  PB_mthd_ParseADefFile def_file_list bef_com_data word_sep_arr end_line_arr \
  sequence_arr format_arr address_arr block_arr \
  aft_com_data arr_size
  foreach name $def_file_list \
  {
   set file_list [split $name //]
   set f_name [lindex $file_list [expr [llength $file_list] -1]]
   lappend trunc_file_name $f_name
  }
  set ParseFile::($parse_obj,bef_com_data_list) [array get bef_com_data]
  set ParseFile::($parse_obj,word_sep_list) [array get word_sep_arr]
  set ParseFile::($parse_obj,end_line_list) [array get end_line_arr]
  set ParseFile::($parse_obj,sequence_list) [array get sequence_arr]
  set ParseFile::($parse_obj,format_list) [array get format_arr]
  set ParseFile::($parse_obj,address_list) [array get address_arr]
  set ParseFile::($parse_obj,block_temp_list) [array get block_arr]
  set ParseFile::($parse_obj,aft_com_data_list) [array get aft_com_data]
  set ParseFile::($parse_obj,arr_size_list) [array get arr_size]
  set ParseFile::($parse_obj,file_list) $trunc_file_name
 }
