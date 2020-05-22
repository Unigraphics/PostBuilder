proc PB_lfl_AttrFromDef { BLK_OBJ POST_OBJ} {
upvar $BLK_OBJ blk_obj
upvar $POST_OBJ post_obj
set list_file_obj $Post::($post_obj,list_obj_list)
set blk_elem_obj_list $block::($blk_obj,elem_addr_list)
foreach object $blk_elem_obj_list\
{
set add_obj $block_element::($object,elem_add_obj)
set add_obj_name $address::($add_obj,add_name)
switch $add_obj_name\
{
LF_XABS      {set ListingFile::($list_file_obj,x)     1}
LF_YABS      {set ListingFile::($list_file_obj,y)     1}
LF_ZABS      {set ListingFile::($list_file_obj,z)     1}
LF_AAXIS     {set ListingFile::($list_file_obj,4axis) 1}
LF_BAXIS     {set ListingFile::($list_file_obj,5axis) 1}
LF_FEED      {set ListingFile::($list_file_obj,feed)  1}
LF_SPEED     {set ListingFile::($list_file_obj,speed) 1}
}
}
ListingFile::readvalue $list_file_obj obj_attr
ListingFile::DefaultValue $list_file_obj obj_attr
ListingFile::SetLfileBlockObj $list_file_obj blk_obj
}
proc PB_lfl_CreateLfileObj { OBJ_ATTR OBJ_LIST } {
upvar $OBJ_ATTR obj_attr
upvar $OBJ_LIST obj_list
set object [new ListingFile]
lappend obj_list $object
ListingFile::setvalue $object obj_attr
ListingFile::readvalue $object obj_attr
ListingFile::DefaultValue $object obj_attr
}
proc PB_lfl_DefLfileParams { OBJECT OBJ_ATTR } {
upvar $OBJECT   object
upvar $OBJ_ATTR obj_attr
array set obj_attr $ListingFile::($object,def_value)
}
proc PB_lfl_ResLfileParams { OBJECT OBJ_ATTR } {
upvar $OBJECT   object
upvar $OBJ_ATTR obj_attr
array set obj_attr $ListingFile::($object,restore_value)
}
proc PB_lfl_RetDisVars { OBJECT OBJ_ATTR } {
upvar $OBJECT   object
upvar $OBJ_ATTR obj_attr
ListingFile::readvalue $object obj_attr
}
proc PB_lfl_RetLfileBlock { LIST_FILE_OBJ BLK_VALUE } {
upvar $LIST_FILE_OBJ list_file_obj
upvar $BLK_VALUE blk_value
set blk_value ""
set name_list { x y z 4axis 5axis feed speed }
foreach name $name_list \
{
switch $name \
{
"x"     {
if { $ListingFile::($list_file_obj,x) } \
{
append temp_cmp_var LF_XABS \[ \$mom_pos(0) \]
}
}
"y"     {
if { $ListingFile::($list_file_obj,y) } \
{
append temp_cmp_var LF_YABS \[ \$mom_pos(1) \]
}
}
"z"     {
if { $ListingFile::($list_file_obj,z) } \
{
append temp_cmp_var LF_ZABS \[ \$mom_pos(2) \]
}
}
"4axis" {
if { $ListingFile::($list_file_obj,4axis) } \
{
append temp_cmp_var LF_AAXIS \[ \$mom_pos(3) \]
}
}
"5axis" {
if { $ListingFile::($list_file_obj,5axis) } \
{
append temp_cmp_var LF_BAXIS \[ \$mom_pos(4) \]
}
}
"feed"  {
if { $ListingFile::($list_file_obj,feed) } \
{
append temp_cmp_var LF_FEED \[ \$mom_feed_rate \]
}
}
"speed" {
if { $ListingFile::($list_file_obj,speed) } \
{
append temp_cmp_var LF_SPEED \[ \$mom_spindle_speed \]
}
}
}
if { [info exists temp_cmp_var] } \
{
lappend blk_value $temp_cmp_var
unset temp_cmp_var
}
}
}
