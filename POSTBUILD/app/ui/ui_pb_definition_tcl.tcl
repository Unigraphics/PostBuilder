#11
proc UI_PB_def_DisableWindow { CHAP } {
upvar  $CHAP chap
global gPB
set sect    $Page::($chap,book_obj)
set sect_id $Book::($sect,book_id)
set gPB($sect_id,b1_cb) [bind [$sect_id subwidget nbframe] <1>]
bind [$sect_id subwidget nbframe] <1> UI_PB_com_InactiveTabMsg
set page_tab $Book::($sect,current_tab)
set page_obj [lindex $Book::($sect,page_obj_list) $page_tab]
$sect_id pageconfig blk -state disabled
$sect_id pageconfig adr -state disabled
$sect_id pageconfig fmt -state disabled
$sect_id pageconfig ele -state disabled
switch $page_tab \
{
0 {  ;# BLOCK
set t $Page::($page_obj,tree)
set h [$t subwidget hlist]
}
1 {  ;# ADDRESS
set t $Page::($page_obj,tree)
set h [$t subwidget hlist]
}
2 {  ;# FORMAT
set t $Page::($page_obj,tree)
set h [$t subwidget hlist]
}
}
}
proc UI_PB_def_EnableWindow { CHAP } {
upvar  $CHAP chap
global gPB
set sect    $Page::($chap,book_obj)
set sect_id $Book::($sect,book_id)
bind [$sect_id subwidget nbframe] <1> $gPB($sect_id,b1_cb)
set page_tab $Book::($sect,current_tab)
set page_obj [lindex $Book::($sect,page_obj_list) $page_tab]
$sect_id pageconfig blk -state normal
$sect_id pageconfig adr -state normal
$sect_id pageconfig fmt -state normal
$sect_id pageconfig ele -state normal
}
proc UI_PB_Def {book_id def_page_obj} {
global paOption
global gPB
set f [$book_id subwidget $Page::($def_page_obj,page_name)]
set w [tixNoteBook $f.nb -ipadx 5 -ipady 5]
[$w subwidget nbframe] config -tabpady 0
set def_book [new Book w]
set Page::($def_page_obj,book_obj) $def_book
Book::CreatePage $def_book blk "$gPB(block,tab,Label)" "" \
UI_PB_Def_Block UI_PB_Def_BlockTab
Book::CreatePage $def_book adr "$gPB(address,tab,Label)" "" \
UI_PB_Def_Address UI_PB_Def_AddressTab
Book::CreatePage $def_book fmt "$gPB(format,tab,Label)" "" \
UI_PB_Def_Format UI_PB_Def_FormatTab
Book::CreatePage $def_book ele "$gPB(other,tab,Label)" "" \
UI_PB_Def_OtherElements UI_PB_Def_OthElemTab
pack $f.nb -expand yes -fill both
set Book::($def_book,x_def_tab_img) 0
set Book::($def_book,current_tab) -1
}
proc UI_PB_Def_BlockTab { book_id page_img book_obj} {
CB_nb_def $book_id $page_img $book_obj
if { [UI_PB_Def_ValidatePrevPageData book_obj] } \
{
return
}
UI_PB_Def_UpdatePrevTabElems book_obj
set Book::($book_obj,current_tab) 0
UI_PB_Def_CreateTabAttr book_obj
}
proc UI_PB_Def_AddressTab { book_id page_img book_obj} {
CB_nb_def $book_id $page_img $book_obj
if { [UI_PB_Def_ValidatePrevPageData book_obj] } \
{
return
}
UI_PB_Def_UpdatePrevTabElems book_obj
set Book::($book_obj,current_tab) 1
UI_PB_Def_CreateTabAttr book_obj
}
proc UI_PB_Def_FormatTab { book_id page_img book_obj} {
CB_nb_def $book_id $page_img $book_obj
if { [UI_PB_Def_ValidatePrevPageData book_obj] } \
{
return
}
UI_PB_Def_UpdatePrevTabElems book_obj
set Book::($book_obj,current_tab) 2
UI_PB_Def_CreateTabAttr book_obj
}
proc UI_PB_Def_OthElemTab { book_id page_img book_obj} {
CB_nb_def $book_id $page_img $book_obj
if { [UI_PB_Def_ValidatePrevPageData book_obj] } \
{
return
}
UI_PB_Def_UpdatePrevTabElems book_obj
set Book::($book_obj,current_tab) 3
UI_PB_Def_CreateTabAttr book_obj
}
proc UI_PB_Def_CreateTabAttr { BOOK_OBJ } {
upvar $BOOK_OBJ book_obj
global gPB
switch -exact -- $Book::($book_obj,current_tab) \
{
0 {
set page_obj [lindex $Book::($book_obj,page_obj_list) 0]
UI_PB_blk_TabBlockCreate $page_obj
UI_PB_com_SetStatusbar "$gPB(block,Status)"
}
1 {
set page_obj [lindex $Book::($book_obj,page_obj_list) 1]
UI_PB_addr_TabAddressCreate $page_obj
UI_PB_com_SetStatusbar "$gPB(address,Status)"
}
2 {
set page_obj [lindex $Book::($book_obj,page_obj_list) 2]
UI_PB_fmt_TabFormatCreate $page_obj
UI_PB_com_SetStatusbar "$gPB(format,Status)"
}
3 {
set page_obj [lindex $Book::($book_obj,page_obj_list) 3]
UI_PB_oth_UpdateOtherPage page_obj
UI_PB_com_SetStatusbar "$gPB(other,Status)"
}
}
}
proc UI_PB_Def_ValidatePrevPageData { BOOK_OBJ } {
upvar $BOOK_OBJ book_obj
global gPB
set raise_page 0
set fmt_page_flag 0
set blk_page_flag 0
set add_page_flag 0
set current_tab $Book::($book_obj,current_tab)
switch -exact -- $Book::($book_obj,current_tab) \
{
0 {
set page_obj [lindex $Book::($book_obj,page_obj_list) 0]
if { [info exists Page::($page_obj,active_blk_obj)] } \
{
global gPB_block_name
set block_obj $Page::($page_obj,active_blk_obj)
if { $block::($block_obj,active_blk_elem_list) == "" } \
{
set raise_page 1
set blk_page_flag 3
}
}
}
1 {
set page_obj [lindex $Book::($book_obj,page_obj_list) 1]
if { [info exists Page::($page_obj,act_addr_obj)] } \
{
global gPB_address_name
set add_obj $Page::($page_obj,act_addr_obj)
set add_page_flag [UI_PB_addr_CheckAddressName gPB_address_name add_obj]
if [string match "N" $gPB_address_name] {
global ADDRESSOBJATTR
global mom_sys_arr
set tmp $mom_sys_arr(seqnum_max)
set mom_sys_arr(seqnum_max) $ADDRESSOBJATTR(4)
set fmt $ADDRESSOBJATTR(1)
set max [UI_PB_ads_ExceedMaxSeqNum $fmt]
if $max {
set add_page_flag 4
}
set mom_sys_arr(seqnum_max) $tmp
}
if { $add_page_flag } \
{
set raise_page 1
}
}
}
2 {
set page_obj [lindex $Book::($book_obj,page_obj_list) 2]
if { [info exists Page::($page_obj,act_fmt_obj)] } \
{
global gPB_format_name
global FORMATOBJATTR
set fmt_obj $Page::($page_obj,act_fmt_obj)
set ret_code [UI_PB_fmt_CheckFormatName gPB_format_name fmt_obj]
if { $ret_code } \
{
set raise_page 1
set fmt_page_flag $ret_code
} elseif { $FORMATOBJATTR(1) == "Numeral" && \
$FORMATOBJATTR(6) == 0 && $FORMATOBJATTR(3) == 0 && \
$FORMATOBJATTR(4) == 0 } \
{
set raise_page 1
set fmt_page_flag 3
}
}
}
3 {
set page_obj [lindex $Book::($book_obj,page_obj_list) 3]
set max [UI_PB_ads_ExceedMaxSeqNum]
if $max {
set raise_page 1
}
}
}
if { $raise_page } \
{
set book_id $Book::($book_obj,book_id)
set cur_page_name [$book_id raised]
set cur_page_img [$book_id pagecget $cur_page_name -image]
set prev_page_name $Page::($page_obj,page_name)
set cmd_proc [$book_id pagecget $prev_page_name -raisecmd]
set prev_page_img [$book_id pagecget $prev_page_name -image]
set Book::($book_obj,x_def_tab_img) $cur_page_img
$book_id pageconfigure $prev_page_name \
-raisecmd "CB_nb_def $book_id $prev_page_img $book_obj"
$book_id raise $prev_page_name
switch -exact -- $Book::($book_obj,current_tab) \
{
0 {
switch $blk_page_flag \
{
1 -
2 {
UI_PB_blk_DenyBlockRename $blk_page_flag
}
3 {
tk_messageBox -parent [UI_PB_com_AskActiveWindow] \
-type ok -icon error \
-message "$gPB(block,msg,min_word)"
}
}
}
1 {
if { $add_page_flag < 4 } {
UI_PB_addr_DenyAddrRename $add_page_flag
} else {
tk_messageBox -parent [UI_PB_com_AskActiveWindow] \
-type ok -icon error \
-message "$gPB(msg,add_max1) N $gPB(msg,add_max2) $max."
}
}
2 {
switch $fmt_page_flag \
{
1 -
2 {
UI_PB_fmt_DenyFmtRename $fmt_page_flag
}
3 {
tk_messageBox  -parent [UI_PB_com_AskActiveWindow] \
-type ok -icon error \
-message " $gPB(format,data,dec_zero,msg)"
}
}
}
3 {
tk_messageBox -parent [UI_PB_com_AskActiveWindow] \
-type ok -icon error \
-message "$gPB(msg,seq_num_max) $max."
}
}
$book_id raise $prev_page_name
$book_id pageconfigure $prev_page_name -raisecmd "$cmd_proc"
switch $cur_page_name \
{
"blk"   { set new_tab 0 }
"adr"   { set new_tab 1 }
"fmt"   { set new_tab 2 }
"ele"   { set new_tab 3 }
default { set new_tab 0 }
}
set Book::($book_obj,current_tab) $new_tab
UI_PB_DeleteBookAttr book_obj
set Book::($book_obj,current_tab) $current_tab
}
return $raise_page
}
proc UI_PB_Def_UpdatePrevTabElems { BOOK_OBJ } {
upvar $BOOK_OBJ book_obj
switch -exact -- $Book::($book_obj,current_tab) \
{
0 {
set page_obj [lindex $Book::($book_obj,page_obj_list) 0]
UI_PB_blk_TabBlockDelete $page_obj
}
1 {
set page_obj [lindex $Book::($book_obj,page_obj_list) 1]
UI_PB_addr_AddressApply page_obj
}
2 {
set page_obj [lindex $Book::($book_obj,page_obj_list) 2]
UI_PB_fmt_ApplyFormat page_obj
}
3 {
set page_obj [lindex $Book::($book_obj,page_obj_list) 3]
UI_PB_oth_ApplyOtherAttr
}
}
}


