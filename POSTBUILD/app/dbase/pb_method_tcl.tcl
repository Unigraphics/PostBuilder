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
if { [string match "*FORMATTING*" $line] == 1} \
{
PB_mthd_StoreCommentData bef_com_data key_para file_name
set formatting_flag 1
if [info exists key_para] { unset key_para}
continue
} elseif { [string match "*INCLUDE*" $line] == 1} \
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
if { [llength $include_script] && [string match "*\{*" $include_script] } {}
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
set include_found 0
if { $cdl_found == 0 } {
set line [join $include_script \n]
set save_para 1
}
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
if $save_para { lappend key_para $line }
}
PB_mthd_StoreCommentData aft_com_data key_para file_name
set arr_size($file_name,format) $fmt_index
set arr_size($file_name,address) $add_index
set arr_size($file_name,block) $blk_index
close $FilePointer
}
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
proc PB_mthd_StoreKeyWordData { KEY_PARA TEXT ARR_VAR INDEX FILE_NAME } {
upvar $KEY_PARA key_para
upvar $TEXT text
upvar $ARR_VAR arr_var
upvar $INDEX index
upvar $FILE_NAME file_name
set arr_var($file_name,$index,text) $text
set arr_var($file_name,$index,data) $key_para
}
proc PB_mthd_RetMachineToolAttr { MOM_KIN_VAR_ARR } {
upvar $MOM_KIN_VAR_ARR mom_kin_var_arr
global post_object
set mom_kin_var_list $Post::($post_object,mom_kin_var_list)
array set mom_kin_var_arr $mom_kin_var_list
set Post::($post_object,def_mom_kin_var_list) $mom_kin_var_list
}
proc PB_mthd_RetSimulattionAttr { MOM_SIM_VAR_ARR } {
upvar $MOM_SIM_VAR_ARR mom_sim_var_arr
global post_object
set mom_sim_var_list $Post::($post_object,mom_sim_var_list)
array set mom_sim_var_arr $mom_sim_var_list
set Post::($post_object,def_mom_sim_var_list) $mom_sim_var_list
}
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
