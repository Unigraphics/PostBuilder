class Book {

#=======================================================================
proc Book {this BOOK_ID} {
  UI_PB_debug_DebugMsg "Book $this constructed"
  upvar $BOOK_ID book_id
  set Book::($this,book_id) $book_id
 }

#=======================================================================
proc ~Book {this} {
  UI_PB_debug_DebugMsg "Book $this destructed"
 }

#=======================================================================
proc CreatePage {this page_name plabel pg_image \
 first_cb second_cb} \
 {
  global paOption
  set book_id $Book::($this,book_id)
  set new_page [new Page $page_name $plabel]
  set img_id [image create compound -window \
  [$book_id subwidget nbframe] -pady 0 \
  -background $paOption(focus) -showbackground 0]
  if { [string compare $pg_image ""] != 0} \
  {
   set pg_img_id [tix getimage $pg_image]
   $img_id add image -image $pg_img_id
   $img_id add space -width 5
  }
  $img_id add text -text $plabel -foreground blue
  $book_id add $page_name -createcmd "$first_cb $book_id $new_page" \
  -wraplength 200 -image $img_id -raisecmd "$second_cb $book_id \
  $img_id $this"
  global gPB
  set gPB(c_help,[$book_id subwidget nbframe])            "nbook,tab"
  lappend Book::($this,page_obj_list) $new_page
 }

#=======================================================================
proc CreateTopLvlPage {this page_name} {
  set new_page [new Page $page_name "npage"]
  set Book::($this,top_lvl_evt_page) $new_page
  set book_id $Book::($this,book_id)
  set page_id [frame $book_id.frm -width 900 -height 700]
  set Page::($new_page,page_id) $page_id
 }

#=======================================================================
proc RetPageObj {this page_name} {
  set page_obj_list $Book::($this,page_obj_list)
  foreach object $page_obj_list\
  {
   set pname $Page::($object,page_name)
   if {[string compare $pname $page_name] == 0}\
   {
    return $object
   }
  }
 }
}
class Page {

#=======================================================================
proc Page {this pname plabel} {
  UI_PB_debug_DebugMsg "Page $this constructed"
  set Page::($this,page_name) $pname
  set Page::($this,page_label) $plabel
  set Page::($this,comb_var) ""
  if [info exists Page::($this,selected_index)] { unset Page::($this,selected_index) }
  if [info exists Page::($this,rename_index)]   { unset Page::($this,rename_index) }
 }

#=======================================================================
proc ~Page {this} {
  UI_PB_debug_DebugMsg "Page $this destructed"
 }

#=======================================================================
proc CreateFrame {inp_frm frm_ext} {
  set frame_id [UI_PB_mthd_CreateFrame $inp_frm $frm_ext]
  return $frame_id
 }

#=======================================================================
proc CreateLabel {inp_frm ext label} {
  UI_PB_mthd_CreateLabel $inp_frm $ext $label
 }

#=======================================================================
proc CreateLblFrame {inp_frm ext label} {
  UI_PB_mthd_CreateLblFrame $inp_frm $ext $label
 }

#=======================================================================
proc CreateIntControl {var inp_frm ext label} {
  UI_PB_mthd_CreateIntControl $var $inp_frm $ext $label
 }

#=======================================================================
proc CreateFloatControl {val1 val2 inp_frm ext label} {
  UI_PB_mthd_CreateFloatControl $val1 $val2 $inp_frm $ext $label
 }

#=======================================================================
proc CreateLblEntry {data_type var inp_frm ext label args} {
  UI_PB_mthd_CreateLblEntry $data_type $var $inp_frm $ext $label $args
 }

#=======================================================================
proc CreateCheckButton {var inp_frm ext label} {
  UI_PB_mthd_CreateCheckButton $var $inp_frm $ext $label
 }

#=======================================================================
proc CreateButton { inp_frm ext label} {
  UI_PB_mthd_CreateButton $inp_frm $ext $label
 }

#=======================================================================
proc CreateRadioButton { var inp_frm ext label} {
  UI_PB_mthd_CreateRadioButton $var $inp_frm $ext $label
 }

#=======================================================================
proc CreateEntry { var inp_frm ext } {
  UI_PB_mthd_CreateEntry $var $inp_frm $ext
 }

#=======================================================================
proc CreateOptionalMenu { var inp_frm ext optional_list label} {
  UI_PB_mthd_CreateOptionalMenu $var $inp_frm $ext $optional_list \
  $label
 }

#=======================================================================
proc CreateFmtComboBox { var inp_frm ext } {
  UI_PB_mthd_CreateFmtCombBox $var $inp_frm $ext
 }

#=======================================================================
proc CreateCombBox { var inp_frm ext optional_list } {
  UI_PB_CreateCombBox $var $inp_frm $ext $optional_list
 }

#=======================================================================
proc CreatePane {this} {
  UI_PB_mthd_CreatePane $this
 }

#=======================================================================
proc CreateCheckList {this} {
  UI_PB_mthd_CreateCheckList $this
 }

#=======================================================================
proc CreateTree {this} {
  UI_PB_mthd_CreateTree $this
 }

#=======================================================================
proc CreateCanvas {this TOP_CANVAS_DIM BOT_CANVAS_DIM} {
  upvar $TOP_CANVAS_DIM top_canvas_dim
  upvar $BOT_CANVAS_DIM bot_canvas_dim
  UI_PB_mthd_CreateCanvas $this top_canvas_dim bot_canvas_dim
 }

#=======================================================================
proc CreateAddTrashinCanvas {this} \
 {
  UI_PB_mthd_CreateAddTrashinCanvas $this
 }

#=======================================================================
proc CreateMenu { this } \
 {
  UI_PB_mthd_CreateMenu $this
 }

#=======================================================================
proc AddComponents {this} {
  set page_name $Page::($this,page_name)
  UI_PB_evt_$page_name this
 }
}
