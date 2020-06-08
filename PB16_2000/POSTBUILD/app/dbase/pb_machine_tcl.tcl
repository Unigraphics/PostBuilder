#11

#=======================================================================
proc PB_mach_RetMachineToolAttr { MOM_KIN_VAR_ARR } {
  upvar $MOM_KIN_VAR_ARR mom_kin_var_arr
  global post_object
  set mom_kin_var_list $Post::($post_object,mom_kin_var_list)
  array set mom_kin_var_arr $mom_kin_var_list
  set Post::($post_object,def_mom_kin_var_list) $mom_kin_var_list
 }

#=======================================================================
proc PB_mach_GetWordSep { file_obj } {
  global post_object
  array set wordsep_arr $ParseFile::($file_obj,word_sep_list)
  set file_name_list $ParseFile::($file_obj,file_list)
  set file_name [lindex $file_name_list 0]
  set line [lindex $wordsep_arr($file_name,0,data) 0]
  set temp_list [split $line \"]
  set word_sep [lindex $temp_list 1]
  set Post::($post_object,word_sep) $word_sep
  set Post::($post_object,def_word_sep) $word_sep
 }

#=======================================================================
proc PB_mach_GetEndOfLine { file_obj } {
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
proc PB_mach_GetSequenceParams { file_obj } {
  global post_object
  array set seqparam_arr $ParseFile::($file_obj,sequence_list)
  set file_name_list $ParseFile::($file_obj,file_list)
  set file_name [lindex $file_name_list 0]
  set line [lindex $seqparam_arr($file_name,0,data) 0]
  PB_com_RemoveBlanks line
  set seq_param(block)     [lindex $line 1]
  set seq_param(start)     [lindex $line 2]
  set seq_param(increment) [lindex $line 3]
  set seq_param(frequency) [lindex $line 4]
  set Post::($post_object,sequence_param) [array get seq_param]
  set Post::($post_object,def_sequence_param) [array get seq_param]
 }
