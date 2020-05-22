proc PB_adr_AdrInitParse { this POST_OBJ OBJ_LIST FOBJ_LIST } {
upvar $POST_OBJ post_obj
upvar $OBJ_LIST obj_list
upvar $FOBJ_LIST fobj_list
set add_start 0
set ret_code 0
array set address_arr $ParseFile::($this,address_list)
array set arr_size $ParseFile::($this,arr_size_list)
set file_name_list $ParseFile::($this,file_list)
foreach f_name $file_name_list \
{
set no_of_address $arr_size($f_name,address)
for {set count 0} {$count < $no_of_address} {incr count} \
{
set open_flag 0
set close_flag 0
set add_start 0
foreach line $address_arr($f_name,$count,data) \
{
if {[string match "*ADDRESS*" $line]}\
{
set temp_line $line
PB_com_RemoveBlanks temp_line
set add_start 1
set add_leader_var ""
PB_adr_InitAdrObj obj_attr
set obj_attr(0) [lindex $temp_line 1] ;# name
if [info exists obj_attr(8)] {
unset obj_attr(8)
}
}
if { $add_start } \
{
if { $open_flag == 0} \
{
PB_com_CheckOpenBracesInLine line open_flag
}
if { $close_flag == 0} \
{
PB_com_CheckCloseBracesInLine line close_flag
}
if { $open_flag } \
{
PB_com_RemoveBlanks line
switch -glob $line \
{
*ZERO_FORMAT* \
{
set zero_fmt [lindex $line 1]
PB_com_RetObjFrmName zero_fmt fobj_list \
ret_code
if { $ret_code } \
{
set obj_attr(12) $ret_code
set obj_attr(13) $zero_fmt
}
}
*FORMAT* {
set obj_name [lindex $line 1]
PB_com_RetObjFrmName obj_name fobj_list \
ret_code
set obj_attr(1) $ret_code
}
*FORCE*  {
set obj_attr(2) [lindex $line 1]
set obj_attr(3) 1
}
*MAX*    {
set obj_attr(4) [lindex $line 1]
if { [lindex $line 2] == "" } \
{
set obj_attr(5) "Truncate"
} else \
{
set obj_attr(5) [lindex $line 2]
}
}
*MIN*    {
set obj_attr(6) [lindex $line 1]
if { [lindex $line 2] == "" } \
{
set obj_attr(7) "Truncate"
} else \
{
set obj_attr(7) [lindex $line 2]
}
}
*LEADER* {
PB_adr_ExtractLeader $post_obj line leader add_leader_var
set obj_attr(8) $leader
}
*TRAILER* \
{
PB_adr_ExtractLeader $post_obj line trailer add_trailer_var
set obj_attr(9) $trailer
set obj_attr(10) 1
}
*INCREMENTAL* \
{
set obj_attr(11) [lindex $line 1]
}
}
}
if { $close_flag } \
{
PB_adr_CreateValidAdrObj obj_attr obj_list
set new_add_obj [lindex $obj_list end]
set address::($new_add_obj,leader_var) $add_leader_var
set add_start 0
set close_flag 0
}
}
}
}
}
}
proc PB_adr_ExtractLeader { post_obj LINE LEADER LEADER_VAR } {
upvar $LINE line
upvar $LEADER leader
upvar $LEADER_VAR leader_var
set leader_part [join [lrange $line 1 end]]
set st_fst_test [string first \" $leader_part]
set st_start [expr $st_fst_test + 1]
set leader_var ""
if {$st_fst_test != -1}\
{
set st_lst_test [string last \" $leader_part]
set st_end [expr $st_lst_test - 1]
if {$st_lst_test != -1}\
{
set leader [string range $leader_part $st_start $st_end]
} else\
{
set leader [string range $leader_part $st_start end]
}
} else\
{
set st_fst_test [string first \[ $leader_part]
if { $st_fst_test != -1} \
{
set st_lst_test [string last \] $leader_part]
set st_end [expr $st_lst_test - 1]
set leader_var [string range $leader_part [expr $st_start + 1] $st_end]
set leader "$leader_var"
set add_name_arr $Post::($post_obj,add_name_list)
array set add_mom_var_arr $Post::($post_obj,add_mom_var_list)
set add_name "PB_Tcl_Var"
set add_index [lsearch $add_name_arr $add_name]
if { $add_index != -1 } \
{
set add_index [lindex $add_name_arr [expr $add_index - 1]]
set add_mom_list $add_mom_var_arr($add_index)
foreach line $add_mom_list \
{
set var [lindex $line 0]
set value [lindex $line 1]
if { $var == $leader_var } \
{
set leader $value
break
}
}
} else \
{
set leader ""
}
} else \
{
set leader  $leader_part
}
}
}
proc PB_adr_InitAdrObj {OBJ_ATTR} {
upvar $OBJ_ATTR obj_attr
set obj_attr(0) ""          ;# add_name
set obj_attr(1) ""          ;# add_format
set obj_attr(2) ""          ;# add_force
set obj_attr(3) 1           ;# add_force_status
set obj_attr(4) ""          ;# add_max
set obj_attr(5) "Truncate"  ;# add_max_status
set obj_attr(6) ""          ;# add_min
set obj_attr(7) "Truncate"  ;# add_min_status
set obj_attr(8) ""          ;# add_leader
set obj_attr(9) ""          ;# add_trailer
set obj_attr(10) 1          ;# add_trailer_status
set obj_attr(11) ""         ;# add_incremental
set obj_attr(12) ""         ;# add_zerofmt
set obj_attr(13) ""         ;# add_zerofmt_name
}
proc PB_adr_CreateTextAddObj {ADD_OBJ_LIST FMT_OBJ_LIST} {
upvar $ADD_OBJ_LIST add_obj_list
upvar $FMT_OBJ_LIST fmt_obj_list
set add_name "Text"
PB_com_RetObjFrmName add_name add_obj_list ret_code
if {$ret_code} { return }
set fmt_name "String"
PB_com_RetObjFrmName fmt_name fmt_obj_list ret_code
if { $ret_code == 0 } \
{
set fmt_str_obj_attr(0) "String"
set fmt_str_obj_attr(1) "Text String"
set fmt_str_obj_attr(2) 0
set fmt_str_obj_attr(3) 0
set fmt_str_obj_attr(4) 0
set fmt_str_obj_attr(5) 0
set fmt_str_obj_attr(6) 0
set fmt_str_obj_attr(7) 0
PB_fmt_CreateFmtObj fmt_str_obj_attr fmt_obj_list
set ret_code [lindex $fmt_obj_list end]
}
PB_adr_InitAdrObj obj_attr
set obj_attr(0) "Text"
set obj_attr(1) $ret_code
PB_adr_CreateAdrObj obj_attr add_obj_list
set no_adds [llength $add_obj_list]
set object [lindex $add_obj_list [expr $no_adds - 1]]
set mseq_attr(0) ""
set mseq_attr(1) 0
set mseq_attr(2) "Text String"
set mseq_attr(3) $no_adds
set mseq_attr(4) 0
address::SetMseqAttr $object mseq_attr
address::DefaultMseqAttr $object mseq_attr
}
proc PB_adr_CreateRapidAddresses { ADD_OBJ_LIST RAP_ADD_LIST } {
upvar $ADD_OBJ_LIST add_obj_list
upvar $RAP_ADD_LIST rap_add_list
global gPB
set rap_add_list ""
set add_name "X"
PB_com_RetObjFrmName add_name add_obj_list add_obj
if { $add_obj } \
{
address::readvalue $add_obj add_obj_attr
address::readMseqAttr $add_obj add_mseq_attr
set add_obj_attr(0) rapid1
set add_obj_attr(8) rap1
PB_adr_CreateAdrObj add_obj_attr rap_add_list
set new_add_obj [lindex $rap_add_list \
[expr [llength $rap_add_list] - 1]]
set add_mseq_attr(2) $gPB(address,rapid1,desc)
address::SetMseqAttr $new_add_obj add_mseq_attr
}
set add_name "Y"
PB_com_RetObjFrmName add_name add_obj_list add_obj
if { $add_obj } \
{
address::readvalue $add_obj add_obj_attr
address::readMseqAttr $add_obj add_mseq_attr
set add_obj_attr(0) rapid2
set add_obj_attr(8) rap2
PB_adr_CreateAdrObj add_obj_attr rap_add_list
set new_add_obj [lindex $rap_add_list \
[expr [llength $rap_add_list] - 1]]
set add_mseq_attr(2) $gPB(address,rapid2,desc)
address::SetMseqAttr $new_add_obj add_mseq_attr
}
set add_name "Z"
PB_com_RetObjFrmName add_name add_obj_list add_obj
if { $add_obj } \
{
address::readvalue $add_obj add_obj_attr
address::readMseqAttr $add_obj add_mseq_attr
set add_obj_attr(0) rapid3
set add_obj_attr(8) rap3
PB_adr_CreateAdrObj add_obj_attr rap_add_list
set new_add_obj [lindex $rap_add_list \
[expr [llength $rap_add_list] - 1]]
set add_mseq_attr(2) $gPB(address,rapid3,desc)
address::SetMseqAttr $new_add_obj add_mseq_attr
}
}
proc PB_adr_SepBlkAndLFileAddLists {OBJ_LIST LF_OBJ_LIST} {
upvar $OBJ_LIST obj_list
upvar $LF_OBJ_LIST lf_obj_list
foreach object $obj_list\
{
set add_name $address::($object,add_name)
switch $add_name\
{
LF_ENUM  - LF_XABS  -
LF_YABS  - LF_ZABS  -
LF_AAXIS - LF_BAXIS -
LF_FEED  -
LF_TIME  -
LF_SPEED    {
lappend lf_obj_list $object
set obj_ind [lsearch $obj_list $object]
set obj_list [lreplace $obj_list $obj_ind $obj_ind]
}
}
}
}
proc PB_adr_CreateValidAdrObj {OBJ_ATTR OBJ_LIST} {
upvar $OBJ_ATTR obj_attr
upvar $OBJ_LIST obj_list
set ret_code 0
PB_com_RetObjFrmName obj_attr(0) obj_list ret_code
if {$ret_code > 0} {  ;# was "!= 0"
set blk_elm_list $address::($ret_code,blk_elem_list)
global gPB
if { [info exists gPB(pui_ui_overwrite)]  &&  $gPB(pui_ui_overwrite) == 1 } {
address::readvalue $ret_code add_attr
set arr_names [array names add_attr]
set arr_len [llength $arr_names]
for { set j 0 } { $j < $arr_len } { incr j } {
if { ![info exists obj_attr($j)]  ||  [string match "" $obj_attr($j)] } {
set obj_attr($j) $add_attr($j)
}
}
}
set index [lsearch $obj_list $ret_code]
set obj_list [lreplace $obj_list $index $index]
PB_com_DeleteObject $ret_code
}
if ![info exists obj_attr(8)] {
if { [string length $obj_attr(0)] == 1 } {
set obj_attr(8) $obj_attr(0)
}
}
PB_adr_CreateAdrObj obj_attr obj_list
if { [info exists blk_elm_list] && [llength $blk_elm_list] > 0 } {
set add_obj [lindex $obj_list end]
foreach blk_elm $blk_elm_list {
set block_element::($blk_elm,elem_add_obj) $add_obj
if { ![info exists block_element::($blk_elm,owner)] } {
set block_element::($blk_elm,owner) "NONE"
}
block_element::readvalue    $blk_elm blk_elm_obj_attr
block_element::DefaultValue $blk_elm blk_elm_obj_attr
}
set address::($add_obj,blk_elem_list) $blk_elm_list
address::readvalue    $add_obj add_obj_attr
address::DefaultValue $add_obj add_obj_attr
}
}
proc PB_adr_CreateAdrObj {OBJ_ATTR OBJ_LIST} {
upvar $OBJ_ATTR obj_attr
upvar $OBJ_LIST obj_list
global post_object
set object [new address]
lappend obj_list $object
if { [string tolower $obj_attr(2)] == "once" } {
set obj_attr(2) "off"
}
for { set i 0 } { $i < 13 } { incr i } {
if ![info exists obj_attr($i)] {
set obj_attr($i) ""
}
}
address::setvalue $object obj_attr
address::readvalue $object obj_attr
address::DefaultValue $object obj_attr
set fmt_obj $obj_attr(1)
format::AddToAddressList $fmt_obj object
format::AddToAddressList $fmt_obj object
PB_adr_SetMseqAttr $object
}
proc PB_adr_SetMseqAttr { addr_obj } {
global post_object
set addr_name $address::($addr_obj,add_name)
array set mseq_word_param $Post::($post_object,msq_word_param)
if {[info exists mseq_word_param($addr_name)]} \
{
set addr_mseq_param $mseq_word_param($addr_name)
set mseq_attr(0) [lindex $addr_mseq_param 0]
set mseq_attr(1) [lindex $addr_mseq_param 1]
set mseq_attr(2) [lindex $addr_mseq_param 2]
set seq_no [lsearch $Post::($post_object,msq_add_name) $addr_name]
set mseq_attr(3) $seq_no
set mseq_attr(4) [lindex $addr_mseq_param 3]
} elseif {[string compare $addr_name "N"] == 0} \
{
set mseq_attr(0) ""
set mseq_attr(1) 0
set mseq_attr(2) "Sequence Number"
set seq_no [llength $Post::($post_object,msq_add_name)]
set mseq_attr(3) $seq_no
set mseq_attr(4) 0
} else \
{
set mseq_attr(0) ""
set mseq_attr(1) 0
set mseq_attr(2) ""
set seq_no [llength $Post::($post_object,msq_add_name)]
set mseq_attr(3) $seq_no
set mseq_attr(4) 1
}
address::SetMseqAttr $addr_obj mseq_attr
address::DefaultMseqAttr $addr_obj mseq_attr
}
proc PB_adr_GetAddressNameList { ADD_OBJ_LIST ADD_NAME_LIST} {
upvar $ADD_OBJ_LIST add_obj_list
upvar $ADD_NAME_LIST add_name_list
foreach add_obj $add_obj_list \
{
lappend add_name_list $address::($add_obj,add_name)
}
if {![info exists add_name_list]} \
{
set add_name_list ""
}
}
proc PB_adr_SortAddresses { ADD_OBJ_LIST } {
upvar $ADD_OBJ_LIST add_obj_list
set no_elements [llength $add_obj_list]
for {set ii 0} {$ii < [expr $no_elements - 1]} {incr ii} \
{
for {set jj [expr $ii + 1]} {$jj < $no_elements} {incr jj} \
{
set addr_ii_obj [lindex $add_obj_list $ii]
set addr_ii_indx $address::($addr_ii_obj,seq_no)
set addr_jj_obj [lindex $add_obj_list $jj]
set addr_jj_indx $address::($addr_jj_obj,seq_no)
if {$addr_jj_indx < $addr_ii_indx} \
{
set add_obj_list [lreplace $add_obj_list $ii $ii $addr_jj_obj]
set add_obj_list [lreplace $add_obj_list $jj $jj $addr_ii_obj]
}
}
}
}
proc PB_adr_SetAddressObjList { addr_obj_list } {
global post_object
set Post::($post_object,add_obj_list) $addr_obj_list
}
proc PB_adr_RetAddressObjList { ADDR_OBJ_LIST } {
upvar $ADDR_OBJ_LIST addr_obj_list
global post_object
set addr_obj_list $Post::($post_object,add_obj_list)
}
proc PB_adr_SyncAddrObjListWithMseq {} {
PB_adr_RetAddressObjList add_obj_list
foreach add_obj $add_obj_list \
{
set seq_no $address::($add_obj,seq_no)
if { $address::($add_obj,add_name) == "N" } \
{
set addn_obj $add_obj
} elseif { $address::($add_obj,add_name) == "Text" } \
{
set addt_obj $add_obj
} else \
{
set addr_arr($seq_no) $add_obj
}
}
set n [llength $add_obj_list]
for {set i 0} {$i < [expr $n - 2]} {incr i} \
{
if [info exists addr_arr($i)] \
{
lappend new_add_obj_list $addr_arr($i)
}
}
lappend new_add_obj_list $addn_obj
lappend new_add_obj_list $addt_obj
PB_adr_SetAddressObjList $new_add_obj_list
}
proc PB_adr_RetAddressNameList { ADDR_OBJ_LIST ADDR_NAME_LIST } {
upvar $ADDR_OBJ_LIST addr_obj_list
upvar $ADDR_NAME_LIST addr_name_list
set addr_name_list ""
foreach add_obj $addr_obj_list \
{
lappend addr_name_list $address::($add_obj,add_name)
}
}
proc PB_adr_ApplyAdrObj {OBJ_LIST FOBJ_LIST OBJ_ATTR ADDR_OBJ} {
upvar $OBJ_LIST obj_list
upvar $FOBJ_LIST fobj_list
upvar $OBJ_ATTR obj_attr
upvar $ADDR_OBJ addr_obj
PB_com_RetObjFrmName obj_attr(1) fobj_list ret_code
set attr_list [array get obj_attr]
array set temp_attr $attr_list
set temp_attr(1) $ret_code
address::readvalue $addr_obj pres_obj_attr
address::setvalue $addr_obj temp_attr
if {$temp_attr(1) != $pres_obj_attr(1)} \
{
format::DeleteFromAddressList $pres_obj_attr(1) addr_obj
format::AddToAddressList $temp_attr(1) addr_obj
}
}
proc PB_adr_DefAdrObjAttr {OBJ_LIST OBJ_ATTR OBJ_INDEX} {
upvar $OBJ_LIST obj_list
upvar $OBJ_ATTR obj_attr
upvar $OBJ_INDEX   obj_index
set object [lindex $obj_list $obj_index]
set default_value $address::($object,def_value)
array set obj_attr $default_value
set obj_attr(1) $format::($obj_attr(1),for_name)
}
proc PB_adr_RetAddFrmAddAttr { OBJ_ATTR ADD_VALUE } {
upvar $OBJ_ATTR obj_attr
upvar $ADD_VALUE add_value
for {set jj 1} {$jj < 13} {incr jj} \
{
switch $jj\
{
1  {
if {$obj_attr($jj) != ""} \
{
set for_name $format::($obj_attr($jj),for_name)
lappend add_value "FORMAT      $for_name"
}
}
2  {
if {$obj_attr($jj) != ""} \
{
lappend add_value "FORCE       $obj_attr($jj)"
}
}
4  {
if {$obj_attr($jj) != ""} \
{
lappend add_value "MAX         $obj_attr($jj) $obj_attr(5)"
}
}
6  {
if {$obj_attr($jj) != ""} \
{
lappend add_value "MIN         $obj_attr($jj) $obj_attr(7)"
}
}
8  {
if 0 {
if {[string compare $obj_attr(0) $obj_attr($jj)]} \
{
if { [string first \$ $obj_attr($jj)] == -1 } \
{
lappend add_value "LEADER      \"$obj_attr($jj)\""
} else \
{
lappend add_value "LEADER      \[$obj_attr($jj)\]"
}
}
}
if { [string first \$ $obj_attr($jj)] == -1 } \
{
lappend add_value "LEADER      \"$obj_attr($jj)\""
} else \
{
lappend add_value "LEADER      \[$obj_attr($jj)\]"
}
}
9  {
if {$obj_attr($jj) != ""} \
{
if { [string first \$ $obj_attr($jj)] == -1 } \
{
lappend add_value "TRAILER     \"$obj_attr($jj)\""
} else \
{
lappend add_value "TRAILER     \[$obj_attr($jj)\]"
}
}
}
12 {
PB_adr_GetZeroFmtName obj_attr zero_fmt_name
if {$zero_fmt_name != ""} \
{
lappend add_value "ZERO_FORMAT $zero_fmt_name"
}
}
}
}
}
proc PB_adr_GetZeroFmtName { ADDR_OBJ_ATTR ZERO_FMT_NAME } {
upvar $ADDR_OBJ_ATTR addr_obj_attr
upvar $ZERO_FMT_NAME zero_fmt_name
set zero_fmt_name ""
if { $addr_obj_attr(12) != "" } \
{
if 0 {
global post_object
Post::GetObjList $post_object format fmt_obj_list
PB_com_RetObjFrmName addr_obj_attr(12) fmt_obj_list ret_code
if { $ret_code > 0 } {
set zero_fmt_name $format::($ret_code,for_name)
}
}
if [info exists format::($addr_obj_attr(12),for_name)] {
set zero_fmt_name $format::($addr_obj_attr(12),for_name)
set addr_obj_attr(13) $zero_fmt_name
} else {
set zero_fmt_name $addr_obj_attr(13)
}
}
}
proc PB_adr_SetZeroFmt { ADDR_OBJ_ATTR } {
upvar $ADDR_OBJ_ATTR addr_obj_attr
set addr_fmt_obj $addr_obj_attr(1)
format::readvalue $addr_fmt_obj fmt_obj_attr
if { $fmt_obj_attr(1) == "Numeral" } \
{
global post_object
array set mom_sys_arr $Post::($post_object,mom_sys_var_list)
set zero_fmt ""
if { $fmt_obj_attr(6) } \
{
if { $fmt_obj_attr(3) == 0  &&  $fmt_obj_attr(4) == 0 } \
{
set zero_fmt $mom_sys_arr(\$zero_real_fmt)
}
} elseif { $fmt_obj_attr(3) == 0 } \
{
set zero_fmt $mom_sys_arr(\$zero_int_fmt)
}
set zero_fmt_obj -1
if { $zero_fmt != "" } \
{
Post::GetObjList $post_object format fmt_obj_list
PB_com_RetObjFrmName zero_fmt fmt_obj_list zero_fmt_obj
}
set addr_obj_attr(12) $zero_fmt_obj
set addr_obj_attr(13) $zero_fmt
}
}
proc PB_adr_CreateNewAdrObj { OBJ_LIST OBJ_ATTR OBJ_INDEX} {
upvar $OBJ_LIST obj_list
upvar $OBJ_ATTR obj_attr
upvar $OBJ_INDEX obj_index
PB_adr_CreateAdrObj obj_attr obj_list
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
set mseq_attr(0) "\$mom_usd_add_var"
set mseq_attr(1) 0
global gPB
set mseq_attr(2) "$gPB(block,new,word_desc,Label)"
set mseq_attr(3) $obj_index
set mseq_attr(4) 1
address::SetMseqAttr $RearrObj mseq_attr
address::DefaultMseqAttr $RearrObj mseq_attr
for { set count [expr $obj_index + 1] } { $count < $length } \
{ incr count } \
{
set add_obj [lindex $obj_list $count]
set address::($add_obj,seq_no) $count
}
}
proc PB_adr_PasteAdrBuffObj { ADD_OBJ_LIST BUFF_OBJ_ATTR ADD_MSEQ_ATTR \
OBJ_INDEX } {
upvar $ADD_OBJ_LIST add_obj_list
upvar $BUFF_OBJ_ATTR buff_obj_attr
upvar $ADD_MSEQ_ATTR add_mseq_attr
upvar $OBJ_INDEX obj_index
global post_object
set fmt_obj_list $Post::($post_object,fmt_obj_list)
PB_com_RetObjFrmName buff_obj_attr(1) fmt_obj_list ret_code
set buff_obj_attr(1) $ret_code
PB_adr_CreateAdrObj buff_obj_attr add_obj_list
set length [llength $add_obj_list]
set Rearrange_I [expr $length - 1]
set LastElement [lindex $add_obj_list $Rearrange_I]
if { $obj_index == ""} \
{
set obj_index 0
} elseif { $length > 1} \
{
incr obj_index
set add_obj_list [lreplace $add_obj_list $Rearrange_I $Rearrange_I]
set add_obj_list [linsert $add_obj_list $obj_index $LastElement]
}
set add_mseq_attr(3) $obj_index
address::SetMseqAttr $LastElement add_mseq_attr
address::DefaultMseqAttr $LastElement add_mseq_attr
for { set count [expr $obj_index + 1] } { $count < $length } \
{ incr count } \
{
set add_obj [lindex $add_obj_list $count]
set address::($add_obj,seq_no) $count
}
}
