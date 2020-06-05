#18

#=======================================================================
proc __RaiseCmd { cb_cmd book_id img_id book page_name } {
  if { $cb_cmd != "" } {
   eval $cb_cmd $book_id $img_id $book
  }
  set page [Book::RetPageObj $book $page_name]
  if { ![Page::AskPageVisited $page] } {
   UI_PB_debug_ForceMsg "+++ Save Visited Page : >$page_name< cb_cmd : >$cb_cmd< +++\n"
   UI_PB_com_DisableMain
   UI_PB_com_EnableMain
   Page::SetPageVisited $page
  }
 }
 class Book {

#=======================================================================
proc Book { this BOOK_ID } {
  UI_PB_debug_DebugMsg "Book $this constructed"
  upvar $BOOK_ID book_id
  set Book::($this,book_id) $book_id
 }

#=======================================================================
proc ~Book { this } {
  UI_PB_debug_DebugMsg "Book $this destructed"
 }

#=======================================================================
proc CreatePage { this page_name plabel pg_image \
  first_cb second_cb } {
  global paOption
  set book_id $Book::($this,book_id)
  set new_page [new Page $page_name $plabel]
  set img_id [image create compound -window \
  [$book_id subwidget nbframe] -pady 0 \
  -background $paOption(focus) -showbackground 0]
  if { [string compare $pg_image ""] != 0 } \
  {
   set pg_img_id [tix getimage $pg_image]
   $img_id add image -image $pg_img_id
   $img_id add space -width 5
  }
  $img_id add text -text $plabel -foreground blue
  if { $first_cb != "" } {
   $book_id add $page_name -createcmd "$first_cb $book_id $new_page" \
   -wraplength 200 -image $img_id \
   -raisecmd "__RaiseCmd $second_cb $book_id $img_id $this $page_name"
   } else {
   $book_id add $page_name -createcmd "" \
   -wraplength 200 -image $img_id \
   -raisecmd "__RaiseCmd $second_cb $book_id $img_id $this $page_name"
  }
  global gPB
  set gPB(c_help,[$book_id subwidget nbframe])            "nbook,tab"
  [$book_id subwidget nbframe] config -inactivebackground lightGray
  [$book_id subwidget nbframe] config -tabpadx 3
  lappend Book::($this,page_obj_list) $new_page
 }

#=======================================================================
proc CreateTopLvlPage { this page_name } {
  set new_page [new Page $page_name "npage"]
  set Book::($this,top_lvl_evt_page) $new_page
  set book_id $Book::($this,book_id)
  set page_id [frame $book_id.frm -width 900 -height 700]
  set Page::($new_page,page_id) $page_id
 }

#=======================================================================
proc RetPageObj { this page_name } {
  set page_obj_list $Book::($this,page_obj_list)
  foreach object $page_obj_list\
  {
   set pname $Page::($object,page_name)
   if { [string compare $pname $page_name] == 0 }\
   {
    return $object
   }
  }
 }
}
class Page {

#=======================================================================
proc Page { this pname plabel } {
  UI_PB_debug_DebugMsg "Page $this constructed"
  set Page::($this,page_name) $pname
  set Page::($this,page_label) $plabel
  set Page::($this,comb_var) ""
  if { [info exists Page::($this,selected_index)] } { unset Page::($this,selected_index) }
  if { [info exists Page::($this,rename_index)] }   { unset Page::($this,rename_index) }
 }

#=======================================================================
proc ~Page { this } {
  UI_PB_debug_DebugMsg "Page $this destructed"
 }

#=======================================================================
proc SetPageVisited { this } {
  set Page::($this,visited) 1
 }

#=======================================================================
proc AskPageVisited { this } {
  if { [info exists Page::($this,visited)] } {
   return 1
   } else {
   return 0
  }
 }

#=======================================================================
proc CreateFrame { inp_frm frm_ext } {
  set frame_id [UI_PB_mthd_CreateFrame $inp_frm $frm_ext]
  return $frame_id
 }

#=======================================================================
proc CreateLabel { inp_frm ext label } {
  UI_PB_mthd_CreateLabel $inp_frm $ext $label
 }

#=======================================================================
proc CreateLblFrame { inp_frm ext label } {
  UI_PB_mthd_CreateLblFrame $inp_frm $ext $label
 }

#=======================================================================
proc CreateIntControl { var inp_frm ext label } {
  UI_PB_mthd_CreateIntControl $var $inp_frm $ext $label
 }

#=======================================================================
proc CreateFloatControl { val1 val2 inp_frm ext label } {
  UI_PB_mthd_CreateFloatControl $val1 $val2 $inp_frm $ext $label
 }

#=======================================================================
proc CreateLblEntry { data_type var inp_frm ext label args } {
  UI_PB_mthd_CreateLblEntry $data_type $var $inp_frm $ext $label $args
 }

#=======================================================================
proc CreateCheckButton { var inp_frm ext label } {
  UI_PB_mthd_CreateCheckButton $var $inp_frm $ext $label
 }

#=======================================================================
proc CreateButton { inp_frm ext label } {
  UI_PB_mthd_CreateButton $inp_frm $ext $label
 }

#=======================================================================
proc CreateRadioButton { var inp_frm ext label args } {
  if { [llength $args] } {
   set val [lindex $args 0]
   } else {
   set val [string toupper [join [split $label " "] _] ]
  }
  UI_PB_mthd_CreateRadioButton $var $inp_frm $ext $label $val
 }

#=======================================================================
proc CreateEntry { var inp_frm ext } {
  UI_PB_mthd_CreateEntry $var $inp_frm $ext
 }

#=======================================================================
proc CreateOptionalMenu { var inp_frm ext optional_list label args } {
  UI_PB_mthd_CreateOptionalMenu $var $inp_frm $ext $optional_list $label $args
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
proc CreatePane { this } {
  UI_PB_mthd_CreatePane $this
 }

#=======================================================================
proc CreateCheckList { this } {
  UI_PB_mthd_CreateCheckList $this
 }

#=======================================================================
proc CreateTree { this } {
  UI_PB_mthd_CreateTree $this
 }

#=======================================================================
proc CreateCanvas { this TOP_CANVAS_DIM BOT_CANVAS_DIM } {
  upvar $TOP_CANVAS_DIM top_canvas_dim
  upvar $BOT_CANVAS_DIM bot_canvas_dim
  UI_PB_mthd_CreateCanvas $this top_canvas_dim bot_canvas_dim
 }

#=======================================================================
proc CreateAddTrashinCanvas { this } {
  UI_PB_mthd_CreateAddTrashinCanvas $this
 }

#=======================================================================
proc CreateMenu { this } {
  UI_PB_mthd_CreateMenu $this
 }

#=======================================================================
proc AddComponents { this } {
  set page_name $Page::($this,page_name)
  UI_PB_evt_$page_name this
 }
}
class udeEditor {

#=======================================================================
proc udeEditor { this event_obj ude_event_obj parent_widget isNewer } {
  global paOption gPB
  set udeEditor::(obj) $this
  set udeEditor::(event_obj) $event_obj
  set udeEditor::(main_widget) $parent_widget.$this
  set udeEditor::(ude_event_obj) $ude_event_obj
  set udeEditor::($this,isNewer) $isNewer
  set udeEditor::($this,right_frame) ""
  set udeEditor::($this,page_obj) ""
  set udeEditor::($this,seq_obj) ""
  set udeEditor::($this,midframe) ""
  if { [classof $ude_event_obj] == "::ude_event" } {
   set udeEditor::($this,TYPE) "UDE"
   } else {
   set udeEditor::($this,TYPE) "UDC"
  }
  set udeEditor::($this,numOfItems) 0
  set udeEditor::($this,totalNumOfItems) 0
  set udeEditor::($this,trash_canvas) ""
  set udeEditor::($this,hlWidgets) [list]
  set udeEditor::($this,isInDD) 0
  set udeEditor::($this,isInDD_ForDelete) 0
  set udeEditor::($this,isPtc) 0
  set udeEditor::($this,isReady) 0
  set udeEditor::($this,isReadyForDelete) 0
  set udeEditor::($this,temp_new_paramobj) [list]
  set udeEditor::($this,drag_drop_enabled) 1
  set udeEditor::($this,pre_sunken_opt) ""
  set udeEditor::($this,select_opt) ""
  set udeEditor::($this,cut_btn_opt) ""
  set udeEditor::($this,string_for_paste) ""
  set udeEditor::($this,sub_objs) [list]
  set udeEditor::($this,pst_order) [list]
  set udeEditor::($this,current_hlWidget) ""
  set udeEditor::($this,insert_position_w) ""
  set udeEditor::($this,cur_pre_botframe) ""
  set udeEditor::($this,trace_var_cmd_list) [list]
  set udeEditor::($this,trace_exe_cmd_list) [list]
  set udeEditor::($this,cur_pst) ""
  set udeEditor::($this,cur_edit_obj) ""
  set udeEditor::($this,to_restore_value) 1
  if { [string match $::tcl_platform(platform) "windows"] } {
   set udeEditor::($this,bd_value) 0
   } else {
   set udeEditor::($this,bd_value) 2
  }
  set udeEditor::($this,left_bg)                  $::SystemButtonFace
  set udeEditor::($this,right_bg)                 $paOption(can_bg)
  set udeEditor::($this,type_bg)                  $paOption(app_butt_bg)
  set udeEditor::($this,type_fg)                  black
  set udeEditor::($this,type_hl_fg)               orange
  set udeEditor::($this,type_hl_bg)               $::SystemButtonFace
  set udeEditor::($this,type_widget_bg)           tan
  set udeEditor::($this,ckb_bg)                   orange
  set udeEditor::($this,ddblock_bg_new)           lightGoldenRod1
  set udeEditor::($this,ddblock_bg_edit)          burlywood2
  set udeEditor::($this,ddblock_fg_new)           black
  set udeEditor::($this,item_fg)                  black
  set udeEditor::($this,title_bg)                 cornsilk3
  set udeEditor::($this,title_fg)                 blue
  set udeEditor::($this,title_highlight)          lightYellow
  set udeEditor::($this,opt_highlight)            lightblue
  set udeEditor::($this,opt_selectcolor)          blue
  set udeEditor::($this,dialog_bg)                cornsilk3
  set udeEditor::($this,dock_bg)                  grey
  set udeEditor::($this,bar_highlight)            yellow
  set udeEditor::($this,bg_for_mce)               lightblue
  set udeEditor::($this,bg_for_non_mce)           burlywood2
  set udeEditor::($this,indicator_for_edit_param) yellow
  set udeEditor::($this,sunken_bg)                pink
  set udeEditor::($this,groupitem_bg)             gray
  set udeEditor::($this,label_text)      ""
  if { $udeEditor::($this,TYPE) == "UDE" } {
   set udeEditor::($this,ueo_name)        \
   $ude_event::($ude_event_obj,name)
   set udeEditor::($this,ueo_post_event)  \
   $ude_event::($ude_event_obj,post_event)
   set udeEditor::($this,ueo_ui_label)    \
   $ude_event::($ude_event_obj,ui_label)
   set udeEditor::($this,ueo_category)    \
   $ude_event::($ude_event_obj,category)
   set udeEditor::($this,ueo_help_descript)    \
   $ude_event::($ude_event_obj,help_descript)
   set udeEditor::($this,ueo_help_url)    \
   $ude_event::($ude_event_obj,help_url)
   } else {
   set udeEditor::($this,ueo_name)        \
   $cycle_event::($ude_event_obj,name)
   set udeEditor::($this,ueo_post_event)  ""
   set udeEditor::($this,ueo_ui_label)    \
   $cycle_event::($ude_event_obj,ui_label)
   set udeEditor::($this,ueo_category)    ""
   set udeEditor::($this,ueo_is_sys_cycle) \
   $cycle_event::($ude_event_obj,is_sys_cycle)
   if { $udeEditor::($this,ueo_is_sys_cycle) == 1 } {
    set udeEditor::($this,ueo_type) "SYSCYC"
    } else {
    set udeEditor::($this,ueo_type) "UDC"
   }
   if { $gPB(enable_helpdesc_for_udc) } {
    set udeEditor::($this,ueo_help_descript)    \
    $cycle_event::($ude_event_obj,help_descript)
    set udeEditor::($this,ueo_help_url)    \
    $cycle_event::($ude_event_obj,help_url)
   }
  }
  set udeEditor::($this,temp_ueo_name) $udeEditor::($this,ueo_name)
  if { ![string compare $udeEditor::($this,ueo_post_event) ""] } {
   set udeEditor::($this,temp_ueo_post_event) ""
   } else {
   set udeEditor::($this,temp_ueo_post_event) \
   $udeEditor::($this,ueo_post_event)
  }
  if { ![string compare $udeEditor::($this,ueo_ui_label) ""] } {
   set udeEditor::($this,temp_ueo_ui_label) ""
   } else {
   set udeEditor::($this,temp_ueo_ui_label) \
   $udeEditor::($this,ueo_ui_label)
  }
  if { ![string compare $udeEditor::($this,ueo_category) "\{\}"] } {
   set udeEditor::($this,temp_ueo_category) ""
   } else {
   set udeEditor::($this,temp_ueo_category) \
   $udeEditor::($this,ueo_category)
  }
  if { $udeEditor::($this,TYPE) == "UDC" } {
   set udeEditor::($this,temp_ueo_is_sys_cycle) \
   $udeEditor::($this,ueo_is_sys_cycle)
   set udeEditor::($this,temp_ueo_type) $udeEditor::($this,ueo_type)
  }
  if { $udeEditor::($this,TYPE) == "UDE" || $gPB(enable_helpdesc_for_udc) } {
   if { ![string compare $udeEditor::($this,ueo_help_descript) ""] } {
    set udeEditor::($this,temp_ueo_help_descript) ""
    } else {
    set udeEditor::($this,temp_ueo_help_descript) \
    $udeEditor::($this,ueo_help_descript)
   }
   if { ![string compare $udeEditor::($this,ueo_help_url) ""] } {
    set udeEditor::($this,temp_ueo_help_url) ""
    } else {
    set udeEditor::($this,temp_ueo_help_url) \
    $udeEditor::($this,ueo_help_url)
   }
   set udeEditor::($this,exist_ueo_help_descript) 0
   set udeEditor::($this,restore_ueo_help_descript) \
   $udeEditor::($this,temp_ueo_help_descript)
   set udeEditor::($this,restore_ueo_help_url) \
   $udeEditor::($this,temp_ueo_help_url)
  }
  set udeEditor::($this,exist_ueo_post_event) 0
  set udeEditor::($this,exist_ueo_ui_label) 0
  set udeEditor::($this,exist_ueo_category) 0
  set udeEditor::($this,exist_ueo_category_mill) 0
  set udeEditor::($this,exist_ueo_category_drill) 0
  set udeEditor::($this,exist_ueo_category_lathe) 0
  set udeEditor::($this,exist_ueo_category_wedm) 0
  set udeEditor::($this,restore_ueo_name)       \
  $udeEditor::($this,temp_ueo_name)
  set udeEditor::($this,restore_ueo_post_event) \
  $udeEditor::($this,temp_ueo_post_event)
  set udeEditor::($this,restore_ueo_ui_label)   \
  $udeEditor::($this,temp_ueo_ui_label)
  set udeEditor::($this,restore_ueo_category)   \
  $udeEditor::($this,temp_ueo_category)
  if { $udeEditor::($this,TYPE) == "UDC" } {
   set udeEditor::($this,restore_ueo_is_sys_cycle) \
   $udeEditor::($this,temp_ueo_is_sys_cycle)
   set udeEditor::($this,restore_ueo_type) \
   $udeEditor::($this,temp_ueo_type)
   if { $udeEditor::($this,temp_ueo_is_sys_cycle) == 1 } {
    set udeEditor::($this,restore_ueo_ui_label) \
    $udeEditor::($this,restore_ueo_name)
   }
  }
  set udeEditor::($this,i_label) ""
  set udeEditor::($this,i_vname) ""
  set udeEditor::($this,i_dvalue) ""
  set udeEditor::($this,i_toggle) ""
  set udeEditor::($this,r_label) ""
  set udeEditor::($this,r_vname) ""
  set udeEditor::($this,r_dvalue) ""
  set udeEditor::($this,r_toggle) ""
  set udeEditor::($this,t_label) ""
  set udeEditor::($this,t_vname) ""
  set udeEditor::($this,t_dvalue) ""
  set udeEditor::($this,t_toggle) ""
  set udeEditor::($this,b_label) ""
  set udeEditor::($this,b_vname) ""
  set udeEditor::($this,b_dvalue) ""
  set udeEditor::($this,p_label) ""
  set udeEditor::($this,p_vname) ""
  set udeEditor::($this,p_toggle) ""
  set udeEditor::($this,o_label) ""
  set udeEditor::($this,o_vname) ""
  set udeEditor::($this,o_dvalue) ""
  set udeEditor::($this,o_toggle) ""
  set udeEditor::($this,o_optlist) [list]
  set udeEditor::($this,o_tempvalue) ""
  set udeEditor::($this,o_cutpaste) ""
  set udeEditor::($this,o_curselect) ""
  set udeEditor::($this,l_vname) ""
  set udeEditor::($this,l_dvalue) ""
  set udeEditor::($this,g_label) ""
  set udeEditor::($this,g_vname) ""
  set udeEditor::($this,g_dvalue) ""
  set udeEditor::($this,v_label) ""
  set udeEditor::($this,v_vname) ""
  set udeEditor::($this,v_toggle) ""
  set udeEditor::($this,req_w_h) [list]
 } ;# Constructor

#=======================================================================
proc ~udeEditor {this} {
  unset udeEditor::(obj)
  unset udeEditor::(event_obj)
  unset udeEditor::(ude_event_obj)
  unset udeEditor::(main_widget)
  foreach sub_obj $udeEditor::($this,sub_objs) {
   delete $sub_obj
  }
  PB_com_unset_var udeEditor::
 }

#=======================================================================
proc CreateItemObj {this type} {
  switch -exact $type {
   Integer  {
    set obj [new uiInteger]
   }
   Real     {
    set obj [new uiReal]
   }
   Text     {
    set obj [new uiText]
   }
   Boolean  {
    set obj [new uiBoolean]
   }
   Option   {
    set obj [new uiOption]
   }
   Point    {
    set obj [new uiPoint]
   }
   Bitmap   {
    set obj [new uiBitmap]
   }
   Group    {
    set obj [new uiGroup]
   }
   Vector   {
    set obj [new uiVector]
   }
  }
  return $obj
 }

#=======================================================================
proc InitPositionList {this} {
  set num [llength $udeEditor::($this,sub_objs)]
  for {set index 0} {$index < $num} {incr index} {
   set postionList($index) [lindex $udeEditor::($this,sub_objs) $index]
  }
  set udeEditor::($this,pst_order) [array get postionList]
 }
 class uiInteger {

#=======================================================================
proc uiInteger {this} {
  set udeEditor::uiInteger::($this,name) ""
  set udeEditor::uiInteger::($this,ui_label) ""
  set udeEditor::uiInteger::($this,type) Integer
  set udeEditor::uiInteger::($this,toggle_v) 1
  set udeEditor::uiInteger::($this,value) 0
  set udeEditor::uiInteger::($this,pathname) ""
  set udeEditor::uiInteger::($this,buddy_path) [list]
  set udeEditor::uiInteger::($this,param_obj) ""
 }

#=======================================================================
proc ~uiInteger {this} {
 }

#=======================================================================
proc set_restore_value {this} {
  set udeEditor::uiInteger::($this,rst_name) \
  $udeEditor::uiInteger::($this,name)
  set udeEditor::uiInteger::($this,rst_ui_label) \
  $udeEditor::uiInteger::($this,ui_label)
  set udeEditor::uiInteger::($this,rst_toggle_v) \
  $udeEditor::uiInteger::($this,toggle_v)
  set udeEditor::uiInteger::($this,rst_value) \
  $udeEditor::uiInteger::($this,value)
 }

#=======================================================================
proc restore_value {this} {
  set pathname $udeEditor::uiInteger::($this,pathname)
  set udeEditor::uiInteger::($this,name) \
  $udeEditor::uiInteger::($this,rst_name)
  set udeEditor::uiInteger::($this,ui_label) \
  $udeEditor::uiInteger::($this,rst_ui_label)
  if { $udeEditor::uiInteger::($this,toggle_v) == "-1" } {
   if { $udeEditor::uiInteger::($this,rst_toggle_v) != "-1" } {
    pack ${pathname}.top -side top -anchor w -padx 2 \
    -before ${pathname}.btm
   }
   } else {
   if { $udeEditor::uiInteger::($this,rst_toggle_v) == "-1" } {
    pack forget ${pathname}.top
   }
  }
  set udeEditor::uiInteger::($this,toggle_v) \
  $udeEditor::uiInteger::($this,rst_toggle_v)
  set udeEditor::uiInteger::($this,value) \
  $udeEditor::uiInteger::($this,rst_value)
 }
}
class uiReal {

#=======================================================================
proc uiReal {this} {
  set udeEditor::uiReal::($this,name) ""
  set udeEditor::uiReal::($this,ui_label) ""
  set udeEditor::uiReal::($this,type) Real
  set udeEditor::uiReal::($this,toggle_v) 1
  set udeEditor::uiReal::($this,value) 0.0
  set udeEditor::uiReal::($this,pathname) ""
  set udeEditor::uiReal::($this,buddy_path) [list]
  set udeEditor::uiReal::($this,param_obj) ""
 }

#=======================================================================
proc ~uiReal {this} {
 }

#=======================================================================
proc set_restore_value {this} {
  set udeEditor::uiReal::($this,rst_name) \
  $udeEditor::uiReal::($this,name)
  set udeEditor::uiReal::($this,rst_ui_label) \
  $udeEditor::uiReal::($this,ui_label)
  set udeEditor::uiReal::($this,rst_toggle_v) \
  $udeEditor::uiReal::($this,toggle_v)
  set udeEditor::uiReal::($this,rst_value) \
  $udeEditor::uiReal::($this,value)
 }

#=======================================================================
proc restore_value {this} {
  set pathname $udeEditor::uiReal::($this,pathname)
  set udeEditor::uiReal::($this,name) \
  $udeEditor::uiReal::($this,rst_name)
  set udeEditor::uiReal::($this,ui_label) \
  $udeEditor::uiReal::($this,rst_ui_label)
  if { $udeEditor::uiReal::($this,toggle_v) == "-1" } {
   if { $udeEditor::uiReal::($this,rst_toggle_v) != "-1" } {
    pack ${pathname}.top -side top -anchor w -padx 2 \
    -before ${pathname}.btm
   }
   } else {
   if { $udeEditor::uiReal::($this,rst_toggle_v) == "-1" } {
    pack forget ${pathname}.top
   }
  }
  set udeEditor::uiReal::($this,toggle_v) \
  $udeEditor::uiReal::($this,rst_toggle_v)
  set udeEditor::uiReal::($this,value) \
  $udeEditor::uiReal::($this,rst_value)
 }
}
class uiText {

#=======================================================================
proc uiText {this} {
  set udeEditor::uiText::($this,name) ""
  set udeEditor::uiText::($this,ui_label) "Text"
  set udeEditor::uiText::($this,type) Text
  set udeEditor::uiText::($this,toggle_v) 1
  set udeEditor::uiText::($this,value) ""
  set udeEditor::uiText::($this,pathname) ""
  set udeEditor::uiText::($this,buddy_path) [list]
  set udeEditor::uiText::($this,param_obj) ""
 }

#=======================================================================
proc ~uiText {this} {
 }

#=======================================================================
proc set_restore_value {this} {
  set udeEditor::uiText::($this,rst_name) \
  $udeEditor::uiText::($this,name)
  set udeEditor::uiText::($this,rst_ui_label) \
  $udeEditor::uiText::($this,ui_label)
  set udeEditor::uiText::($this,rst_toggle_v) \
  $udeEditor::uiText::($this,toggle_v)
  set udeEditor::uiText::($this,rst_value) \
  $udeEditor::uiText::($this,value)
 }

#=======================================================================
proc restore_value {this} {
  set pathname $udeEditor::uiText::($this,pathname)
  set udeEditor::uiText::($this,name) \
  $udeEditor::uiText::($this,rst_name)
  set udeEditor::uiText::($this,ui_label) \
  $udeEditor::uiText::($this,rst_ui_label)
  if { $udeEditor::uiText::($this,toggle_v) == "-1" } {
   if { $udeEditor::uiText::($this,rst_toggle_v) != "-1" } {
    pack ${pathname}.top -side top -anchor w -padx 2 \
    -before ${pathname}.btm
   }
   } else {
   if { $udeEditor::uiText::($this,rst_toggle_v) == "-1" } {
    pack forget ${pathname}.top
   }
  }
  set udeEditor::uiText::($this,toggle_v) \
  $udeEditor::uiText::($this,rst_toggle_v)
  set udeEditor::uiText::($this,value) \
  $udeEditor::uiText::($this,rst_value)
 }
}
class uiBoolean {

#=======================================================================
proc uiBoolean {this} {
  set udeEditor::uiBoolean::($this,name) ""
  set udeEditor::uiBoolean::($this,ui_label) ""
  set udeEditor::uiBoolean::($this,type) Boolean
  set udeEditor::uiBoolean::($this,toggle_v) 1
  set udeEditor::uiBoolean::($this,pathname) ""
  set udeEditor::uiBoolean::($this,buddy_path) [list]
  set udeEditor::uiBoolean::($this,param_obj) ""
 }

#=======================================================================
proc ~uiBoolean {this} {
 }

#=======================================================================
proc set_restore_value {this} {
  set udeEditor::uiBoolean::($this,rst_name) \
  $udeEditor::uiBoolean::($this,name)
  set udeEditor::uiBoolean::($this,rst_ui_label) \
  $udeEditor::uiBoolean::($this,ui_label)
  set udeEditor::uiBoolean::($this,rst_toggle_v) \
  $udeEditor::uiBoolean::($this,toggle_v)
 }

#=======================================================================
proc restore_value {this} {
  set udeEditor::uiBoolean::($this,name) \
  $udeEditor::uiBoolean::($this,rst_name)
  set udeEditor::uiBoolean::($this,ui_label) \
  $udeEditor::uiBoolean::($this,rst_ui_label)
  set udeEditor::uiBoolean::($this,toggle_v) \
  $udeEditor::uiBoolean::($this,rst_toggle_v)
 }
}
class uiOption {

#=======================================================================
proc uiOption {this} {
  set udeEditor::uiOption::($this,name) ""
  set udeEditor::uiOption::($this,ui_label) ""
  set udeEditor::uiOption::($this,type) Option
  set udeEditor::uiOption::($this,opt_list) [list]
  set udeEditor::uiOption::($this,toggle_v) -1
  set udeEditor::uiOption::($this,cur_opt) ""
  set udeEditor::uiOption::($this,pathname) ""
  set udeEditor::uiOption::($this,buddy_path) [list]
  set udeEditor::uiOption::($this,param_obj) ""
 }

#=======================================================================
proc ~uiOption {this} {
 }

#=======================================================================
proc set_restore_value {this} {
  set udeEditor::uiOption::($this,rst_name) \
  $udeEditor::uiOption::($this,name)
  set udeEditor::uiOption::($this,rst_ui_label) \
  $udeEditor::uiOption::($this,ui_label)
  set udeEditor::uiOption::($this,rst_toggle_v) \
  $udeEditor::uiOption::($this,toggle_v)
  set udeEditor::uiOption::($this,rst_cur_opt) \
  $udeEditor::uiOption::($this,cur_opt)
  set udeEditor::uiOption::($this,rst_opt_list) \
  $udeEditor::uiOption::($this,opt_list)
 }

#=======================================================================
proc restore_value {this} {
  set pathname $udeEditor::uiOption::($this,pathname)
  set udeEditor::uiOption::($this,name) \
  $udeEditor::uiOption::($this,rst_name)
  set udeEditor::uiOption::($this,ui_label) \
  $udeEditor::uiOption::($this,rst_ui_label)
  if { $udeEditor::uiOption::($this,toggle_v) == "-1" } {
   if { $udeEditor::uiOption:::($this,rst_toggle_v) != "-1" } {
    pack ${pathname}.c -side left -padx 3 \
    -before ${pathname}.l
   }
   } else {
   if { $udeEditor::uiOption:::($this,rst_toggle_v) == "-1" } {
    pack forget ${pathname}.c
   }
  }
  set udeEditor::uiOption::($this,toggle_v) \
  $udeEditor::uiOption::($this,rst_toggle_v)
  set udeEditor::uiOption::($this,cur_opt) \
  $udeEditor::uiOption::($this,rst_cur_opt)
  set udeEditor::uiOption::($this,opt_list) \
  $udeEditor::uiOption::($this,rst_opt_list)
 }
}
class uiPoint {

#=======================================================================
proc uiPoint {this} {
  set udeEditor::uiPoint::($this,name) ""
  set udeEditor::uiPoint::($this,ui_label) ""
  set udeEditor::uiPoint::($this,toggle_v) 1
  set udeEditor::uiPoint::($this,pathname) ""
  set udeEditor::uiPoint::($this,buddy_path) [list]
  set udeEditor::uiPoint::($this,param_obj) ""
 }

#=======================================================================
proc ~uiPoint {this} {
 }

#=======================================================================
proc set_restore_value {this} {
  set udeEditor::uiPoint::($this,rst_name) \
  $udeEditor::uiPoint::($this,name)
  set udeEditor::uiPoint::($this,rst_ui_label) \
  $udeEditor::uiPoint::($this,ui_label)
  set udeEditor::uiPoint::($this,rst_toggle_v) \
  $udeEditor::uiPoint::($this,toggle_v)
 }

#=======================================================================
proc restore_value {this} {
  set pathname $udeEditor::uiPoint::($this,pathname)
  set udeEditor::uiPoint::($this,name) \
  $udeEditor::uiPoint::($this,rst_name)
  set udeEditor::uiPoint::($this,ui_label) \
  $udeEditor::uiPoint::($this,rst_ui_label)
  if { $udeEditor::uiPoint::($this,toggle_v) == "-1" } {
   if { $udeEditor::uiPoint::($this,rst_toggle_v) != "-1" } {
    pack ${pathname}.top -side top -anchor w -padx 2 \
    -before ${pathname}.btm
   }
   } else {
   if { $udeEditor::uiPoint::($this,rst_toggle_v) == "-1" } {
    pack forget ${pathname}.top
   }
  }
  set udeEditor::uiPoint::($this,toggle_v) \
  $udeEditor::uiPoint::($this,rst_toggle_v)
 }
}
class uiBitmap {

#=======================================================================
proc uiBitmap {this} {
  set udeEditor::uiBitmap::($this,name) ""
  set udeEditor::uiBitmap::($this,type) Bitmap
  set udeEditor::uiBitmap::($this,value) ""
  set udeEditor::uiBitmap::($this,pathname) ""
  set udeEditor::uiBitmap::($this,buddy_path) [list]
  set udeEditor::uiBitmap::($this,param_obj) ""
 }

#=======================================================================
proc ~uiBitmap {this} {
 }

#=======================================================================
proc set_restore_value {this} {
  set udeEditor::uiBitmap::($this,rst_name) \
  $udeEditor::uiBitmap::($this,name)
  set udeEditor::uiBitmap::($this,rst_value) \
  $udeEditor::uiBitmap::($this,value)
 }

#=======================================================================
proc restore_value {this} {
  set pathname $udeEditor::uiBitmap::($this,pathname)
  set udeEditor::uiBitmap::($this,name) \
  $udeEditor::uiBitmap::($this,rst_name)
  set udeEditor::uiBitmap::($this,value) \
  $udeEditor::uiBitmap::($this,rst_value)
 }
}
class uiGroup {

#=======================================================================
proc uiGroup {this} {
  set udeEditor::uiGroup::($this,name) ""
  set udeEditor::uiGroup::($this,ui_label) ""
  set udeEditor::uiGroup::($this,type) Group
  set udeEditor::uiGroup::($this,value) ""
  set udeEditor::uiGroup::($this,pathname) ""
  set udeEditor::uiGroup::($this,buddy_path) [list]
  set udeEditor::uiGroup::($this,param_obj) ""
 }

#=======================================================================
proc ~uiGroup {this} {
 }

#=======================================================================
proc set_restore_value {this} {
  set udeEditor::uiGroup::($this,rst_name) \
  $udeEditor::uiGroup::($this,name)
  set udeEditor::uiGroup::($this,rst_ui_label) \
  $udeEditor::uiGroup::($this,ui_label)
  set udeEditor::uiGroup::($this,rst_value) \
  $udeEditor::uiGroup::($this,value)
 }

#=======================================================================
proc restore_value {this} {
  set pathname $udeEditor::uiGroup::($this,pathname)
  set udeEditor::uiGroup::($this,name) \
  $udeEditor::uiGroup::($this,rst_name)
  set udeEditor::uiGroup::($this,ui_label) \
  $udeEditor::uiGroup::($this,rst_ui_label)
  set udeEditor::uiGroup::($this,value) \
  $udeEditor::uiGroup::($this,rst_value)
 }
}
class uiVector {

#=======================================================================
proc uiVector {this} {
  set udeEditor::uiVector::($this,name) ""
  set udeEditor::uiVector::($this,ui_label) ""
  set udeEditor::uiVector::($this,toggle_v) 1
  set udeEditor::uiVector::($this,pathname) ""
  set udeEditor::uiVector::($this,buddy_path) [list]
  set udeEditor::uiVector::($this,param_obj) ""
 }

#=======================================================================
proc ~uiVector {this} {
 }

#=======================================================================
proc set_restore_value {this} {
  set udeEditor::uiVector::($this,rst_name) \
  $udeEditor::uiVector::($this,name)
  set udeEditor::uiVector::($this,rst_ui_label) \
  $udeEditor::uiVector::($this,ui_label)
  set udeEditor::uiVector::($this,rst_toggle_v) \
  $udeEditor::uiVector::($this,toggle_v)
 }

#=======================================================================
proc restore_value {this} {
  set pathname $udeEditor::uiVector::($this,pathname)
  set udeEditor::uiVector::($this,name) \
  $udeEditor::uiVector::($this,rst_name)
  set udeEditor::uiVector::($this,ui_label) \
  $udeEditor::uiVector::($this,rst_ui_label)
  if { $udeEditor::uiVector::($this,toggle_v) == "-1" } {
   if { $udeEditor::uiVector::($this,rst_toggle_v) != "-1" } {
    pack ${pathname}.top -side top -anchor w -padx 2 \
    -before ${pathname}.btm
   }
   } else {
   if { $udeEditor::uiVector::($this,rst_toggle_v) == "-1" } {
    pack forget ${pathname}.top
   }
  }
  set udeEditor::uiVector::($this,toggle_v) \
  $udeEditor::uiVector::($this,rst_toggle_v)
 }
}
}
