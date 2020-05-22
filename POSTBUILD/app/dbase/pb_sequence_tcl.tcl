#17
proc PB_seq_CreateSequences {POST_OBJ} {
upvar $POST_OBJ post_obj
set seq_obj_list ""
set evt_list_ext "_evt_list"
set evt_blk_list_ext "_evt_blk_list"
set evt_label_ext "_label_list"
set ind 0
set seq_name_list {prog_start oper_start tpth_ctrl \
tpth_mot tpth_cycle oper_end prog_end \
linked_posts virtual_nc}
set seq_names {"Program Start Sequence" "Operation Start Sequence" \
"Machine Control" "Motions" "Cycles" \
"Operation End Sequence" "Program End Sequence" \
"Linked Posts Sequence" "Virtual NC Controller"}
if 0 {
global gPB
if { [PB_is_v3] >= 0 } {
global mach_type
if { [string match "Wedm" $mach_type] } {
set seq_name_list {prog_start oper_start tpth_ctrl \
tpth_mot oper_end prog_end}
set seq_names {"Program Start Sequence" "Operation Start Sequence" \
"Machine Control" "Motions" \
"Operation End Sequence" "Program End Sequence"}
}
}
}
foreach sequence $seq_name_list \
{
set evt_obj_list ""
set evt_list_name $sequence$evt_list_ext
set evt_blk_list_name $sequence$evt_blk_list_ext
set evt_list_label $sequence$evt_label_ext
PB_evt_CreateSeqEvents post_obj evt_obj_list evt_list_name evt_list_label \
evt_blk_list_name sequence
PB_seq_RetSeqCombElems comb_elem_list
set seq_obj_attr(0) [lindex $seq_names $ind]
set seq_obj_attr(1) $evt_obj_list
set seq_obj_attr(2) $comb_elem_list
PB_seq_CreateSeqObj seq_obj_attr seq_obj_list
incr ind
if [string match "virtual_nc" $sequence] {
set Post::($post_obj,vnc_evt_obj_list) $evt_obj_list
}
}
Post::SetSeqObj $post_obj seq_obj_list
}
proc PB_seq_CreateSeqObj {OBJ_ATTR OBJ_LIST} {
upvar $OBJ_ATTR obj_attr
upvar $OBJ_LIST obj_list
set object [new sequence]
lappend obj_list $object
sequence::setvalue $object obj_attr
sequence::DefaultValue $object obj_attr
}
proc PB_seq_RetSeqEvtBlkObj { SEQ_OBJ EVT_OBJ_LIST } {
upvar $SEQ_OBJ seq_obj
upvar $EVT_OBJ_LIST evt_obj_list
set evt_obj_list $sequence::($seq_obj,evt_obj_list)
}
proc PB_seq_RetSeqCombElems { COMB_ELEM_LIST } {
upvar $COMB_ELEM_LIST comb_elem_list
global post_object
if {[info exists comb_elem_list]}\
{
unset comb_elem_list
}
set blk_obj_list $Post::($post_object,blk_obj_list)
foreach blk_obj $blk_obj_list\
{
set blk_name $block::($blk_obj,block_name)
PB_com_GetModEvtBlkName blk_name
lappend comb_elem_list $blk_name
}
}


