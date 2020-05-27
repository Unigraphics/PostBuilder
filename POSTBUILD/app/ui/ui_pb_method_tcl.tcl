
#=======================================================================
proc UI_PB_mthd_CreateFrame {inp_frm frm_ext} {
  set frame_id [frame $inp_frm.$frm_ext]
  return $frame_id
 }

#=======================================================================
proc UI_PB_mthd_CreateLabel {inp_frm ext label} {
  label $inp_frm.$ext -text $label -wraplength 170
  pack $inp_frm.$ext -pady 10
 }

#=======================================================================
proc UI_PB_mthd_CreateLblFrame {inp_frm ext args} {
  if [llength $args] {
   set label [lindex $args 0]
   } else {
   set label ""
  }
  if { [string trim $label] == "" } {
   tixLabelFrame $inp_frm.$ext -labelside none
   } else {
   tixLabelFrame $inp_frm.$ext -label $label
  }
  return $inp_frm.$ext
 }

#=======================================================================
proc UI_PB_mthd_CreateIntControl {var inp_frm ext label} {
  global mom_sys_arr
  global mom_kin_var
  global tixOption
  if { [string match "\$mom_kin*" $var] } \
  {
   set gb_arr "mom_kin_var"
  } else \
  {
   set gb_arr "mom_sys_arr"
  }
  tixControl $inp_frm.$ext -integer true -min 0 \
  -variable   ${gb_arr}($var) \
  -selectmode immediate \
  -options {
   entry.width 3
   label.anchor e
  }
  $inp_frm.$ext.frame config -relief sunken -bd 1
  $inp_frm.$ext.frame.entry config -relief flat
  if {[string compare $label ""] == 0} \
  {
   set text $label
  } else \
  {
   set text [UI_PB_com_FormatString $label]
   label $inp_frm.1_$ext -text $text -font $tixOption(font)
   pack $inp_frm.1_$ext -side left -padx 3 -pady 3
  }
  pack $inp_frm.$ext -side right -padx 3 -pady 3 -fill x
 }

#=======================================================================
proc UI_PB_mthd_CreateFloatControl {val1 val2 inp_frm ext label} {
  global mom_sys_arr
  global mom_kin_var
  global tixOption
  if { [string match "\$mom_kin*" $var] } \
  {
   set gb_arr "mom_kin_var"
  } else \
  {
   set gb_arr "mom_sys_arr"
  }
  tixControl $inp_frm.1_$ext -integer true \
  -variable   ${gb_arr}($val1) \
  -selectmode immediate \
  -options {
   entry.width 2
   label.anchor e
  }
  label $inp_frm.2_$ext -text "."
  tixControl $inp_frm.3_$ext -integer true \
  -variable   ${gb_arr}($val2) \
  -selectmode immediate \
  -options {
   entry.width 2
   label.anchor e
  }
  $inp_frm.1_$ext.frame config -relief sunken -bd 1
  $inp_frm.1_$ext.frame.entry config -relief flat
  $inp_frm.3_$ext.frame config -relief sunken -bd 1
  $inp_frm.3_$ext.frame.entry config -relief flat
  if { [string compare $lable ""] == 0} \
  {
   set text $label
  } else  \
  {
   set text [format "%-20s" $label]
  }
  label $inp_frm.4_$ext -text $text -font $tixOption(font)
  pack $inp_frm.4_$ext -side left -padx 3 -pady 3
  pack $inp_frm.3_$ext $inp_frm.2_$ext $inp_frm.1_$ext -side right -padx 3 -pady 3
 }

#=======================================================================
proc UI_PB_mthd_CreateLblEntry { data_type var inp_frm ext label args } {
  global mom_sys_arr
  global mom_kin_var
  global tixOption
  if { [string match "\$mom_kin*" $var] } \
  {
   set gb_arr "mom_kin_var"
  } else \
  {
   set gb_arr "mom_sys_arr"
  }
  if { [string compare $label ""] == 0} \
  {
   set text $label
  } else  \
  {
   set text [format "%-20s" $label]
  }
  label $inp_frm.$ext -text $text -font $tixOption(font) -justify left
  set ent [entry $inp_frm.1_$ext -width 10 -relief sunken -bd 2 \
  -textvariable ${gb_arr}($var)]
  global gPB
  set positive 0
  if { [llength $args] } {
   set positive [lindex $args 0]
  }
  set has_chelp 0
  if { [llength $args] > 1 &&  [lindex $args 1] != "" } {
   set has_chelp 1
   set csh [lindex $args 1]
  }
  if { $has_chelp } {
   set gPB(c_help,$ent)     "$csh"
   } else {
   set gPB(c_help,$ent) "common,entry"
  }
  pack $inp_frm.$ext -side left -padx 5 -pady 6
  pack $inp_frm.1_$ext -side right -padx 5 -pady 6
  if { $data_type == "a" } \
  {
   set data_type [UI_PB_com_RetSysVarDataType var]
  }
  if { $data_type != "i"  && \
   $data_type != "f"  && \
  $data_type != "s" } \
  {
   UI_PB_debug_ForceMsg "Data type for a Labeled Entry ($label) should be i, f or s."
  } else \
  {
   bind $inp_frm.1_$ext <KeyPress> "UI_PB_com_ValidateDataOfEntry %W %K $data_type $positive"
  }
  bind $inp_frm.1_$ext <KeyRelease> {%W config -state normal }
 }

#=======================================================================
proc UI_PB_mthd_CreateCheckButton {var inp_frm ext label} {
  global mom_sys_arr
  global mom_kin_var
  if { [string match "\$mom_kin*" $var] } \
  {
   set gb_arr "mom_kin_var"
  } else \
  {
   set gb_arr "mom_sys_arr"
  }
  set text $label
  checkbutton $inp_frm.$ext -text "$text" \
  -variable ${gb_arr}($var) \
  -relief flat -bd 2 -anchor w
  pack $inp_frm.$ext -side left -padx 3 -pady 5 -fill x
 }

#=======================================================================
proc UI_PB_mthd_CreateButton { inp_frm ext label} {
  set text [format "%-20s" $label]
  button $inp_frm.$ext -text "$label" -padx 10
  grid $inp_frm.$ext -padx 40 -sticky ew
 }

#=======================================================================
proc UI_PB_mthd_CreateRadioButton { var inp_frm ext label } {
  global mom_sys_arr
  global mom_kin_var
  if { [string match "\$mom_kin*" $var] } \
  {
   set gb_arr "mom_kin_var"
  } else \
  {
   set gb_arr "mom_sys_arr"
  }
  set text [join [split $label " "] _]
  set text [string toupper $text]
  radiobutton $inp_frm.$ext -text $label -variable ${gb_arr}($var) \
  -value $text
  pack $inp_frm.$ext -side left -padx 3 -pady 3 -fill x
 }

#=======================================================================
proc UI_PB_mthd_CreateEntry { var inp_frm ext } {
  global mom_sys_arr
  global mom_kin_var
  if { [string match "\$mom_kin*" $var] } \
  {
   set gb_arr "mom_kin_var"
  } else \
  {
   set gb_arr "mom_sys_arr"
  }
  entry $inp_frm.1_$ext -width 30 -relief sunken -bd 2 \
  -textvariable ${gb_arr}($var) -state disabled
  pack $inp_frm.1_$ext -side left -padx 3 -pady 5 -fill x
 }

#=======================================================================
proc UI_PB_mthd_CreateOptionalMenu { var inp_frm ext option_list \
  label } {
  global mom_sys_arr
  global mom_kin_var
  if { $var == "null" } \
  {
   set gb_arr ""
   set temp_value ""
   } elseif { [string match "\$mom_kin*" $var] } \
  {
   set gb_arr "mom_kin_var"
   set temp_value $mom_kin_var($var)
  } else \
  {
   set gb_arr "mom_sys_arr"
   set temp_value $mom_sys_arr($var)
  }
  tixOptionMenu $inp_frm.$ext -label $label \
  -labelside left \
  -variable ${gb_arr}($var) \
  -options {
   menubutton.width 25
  }
  set length 0
  foreach option $option_list \
  {
   set opt_length [string length $option]
   if { $opt_length > $length } { set length $opt_length }
   set temp_opt [split $option " "]
   set opt [join $temp_opt _]
   $inp_frm.$ext add command $opt -label $option
   unset temp_opt opt
  }
  $inp_frm.$ext config -value $temp_value
  if { $length != 0 && $label != "" } \
  {
   pack forget [$inp_frm.$ext subwidget menubutton]
   pack [$inp_frm.$ext subwidget menubutton] -side right
   [$inp_frm.$ext subwidget menubutton] config -width [expr $length + 3]
  }
  pack $inp_frm.$ext -padx 3 -fill x
 }

#=======================================================================
proc UI_PB_CreateCombBox { var fmt_frm ext option_list } {
  global mom_sys_arr
  global mom_kin_var
  global paOption
  if { [string match "\$mom_kin*" $var] } \
  {
   set gb_arr "mom_kin_var"
  } else \
  {
   set gb_arr "mom_sys_arr"
  }
  set fmt_sel [tixComboBox $fmt_frm.$ext \
  -dropdown   yes \
  -editable   false \
  -variable   ${gb_arr}($var) \
  -command    "" \
  -selectmode browse \
  -grab       local \
  -options {
   listbox.anchor   w
   listbox.height   4
   entry.width      30
  }]
  pack $fmt_frm.$ext -side top -padx 3 -pady 3
  [$fmt_sel subwidget entry] config -bg $paOption(entry_disabled_bg) -cursor ""
  set lbx [$fmt_sel subwidget listbox]
  $lbx delete 0 end
  foreach elem $option_list \
  {
   $fmt_sel insert end $elem
  }
 }

#=======================================================================
proc UI_PB_mthd_CreateFmtCombBox { var fmt_frm ext } {
  global mom_sys_arr
  global tixOption
  global paOption
  set var_list [split $var ,]
  set new_var [join $var_list ",1_"]
  PB_int_RetFormatObjList fmt_obj_list
  set fmt_name $mom_sys_arr($var)
  PB_int_RetFmtObjFromName fmt_name fmt_obj
  set mom_sys_arr($new_var) $fmt_obj
  set mom_sys_arr($fmt_name) $fmt_obj
  button $fmt_frm.but_$ext -text " Edit " -font $tixOption(bold_font)
  pack $fmt_frm.but_$ext -side left -padx 10 -pady 3
  set comb_var [string trimleft $var \$]
  set fmt_sel [tixComboBox $fmt_frm.cb_$ext \
  -dropdown   yes \
  -editable   false \
  -variable   mom_sys_arr($var) \
  -command    "UI_PB_Combo_CB $fmt_frm.cb_$ext $comb_var" \
  -selectmode browse \
  -grab       local \
  -options {
   listbox.anchor   w
   listbox.height   4
   listbox.width    15
   entry.width      15
  }]
  pack $fmt_frm.cb_$ext -side right -padx 10 -pady 3
  [$fmt_sel subwidget entry] config -bg $paOption(entry_disabled_bg) -cursor ""
  set lbx [$fmt_sel subwidget listbox]
  $lbx delete 0 end
  set name_arr_size [llength $fmt_obj_list]
  for {set ind 0} {$ind < $name_arr_size} {incr ind}\
  {
   set fmt_obj [lindex $fmt_obj_list $ind]
   set fmt_name $format::($fmt_obj,for_name)
   $fmt_sel insert end $fmt_name
  }
 }

#=======================================================================
proc __UI_PB_mthd_CreateFmtCombBox { var fmt_frm ext } {
  global mom_sys_arr
  global tixOption
  global paOption
  set var_list [split $var ,]
  set new_var [join $var_list ",1_"]
  PB_int_RetFormatObjList fmt_obj_list
  set fmt_obj $mom_sys_arr($new_var)
  if [info exists format::($fmt_obj,for_name)] \
  {
   set mom_sys_arr($var) $format::($fmt_obj,for_name)
  } else \
  {
   set fmt_obj [lindex $fmt_obj_list 0]
   set mom_sys_arr($var) $format::($fmt_obj,for_name)
  }
  button $fmt_frm.but_$ext -text " Edit " -font $tixOption(bold_font)
  pack $fmt_frm.but_$ext -side left -padx 10 -pady 3
  set comb_var [string trimleft $var \$]
  set fmt_sel [tixComboBox $fmt_frm.cb_$ext \
  -dropdown   yes \
  -editable   false \
  -variable   mom_sys_arr($var) \
  -command    "UI_PB_Combo_CB $fmt_frm.cb_$ext $comb_var" \
  -selectmode browse \
  -grab       local \
  -options {
   listbox.anchor   w
   listbox.height   4
   listbox.width    15
   entry.width      15
  }]
  pack $fmt_frm.cb_$ext -side right -padx 10 -pady 3
  [$fmt_sel subwidget entry] config -bg $paOption(entry_disabled_bg) -cursor ""
  set lbx [$fmt_sel subwidget listbox]
  $lbx delete 0 end
  set name_arr_size [llength $fmt_obj_list]
  for {set ind 0} {$ind < $name_arr_size} {incr ind}\
  {
   set fmt_obj [lindex $fmt_obj_list $ind]
   set fmt_name $format::($fmt_obj,for_name)
   $fmt_sel insert end $fmt_name
  }
 }

#=======================================================================
proc UI_PB_Combo_CB { widget var fmt_name } {
  global mom_sys_arr
  global post_object
  set var_list [split $var ,]
  set new_var [join $var_list ",1_"]
  set fmt_obj_list $Post::($post_object,fmt_obj_list)
  set ret_code 0
  PB_com_RetObjFrmName fmt_name fmt_obj_list ret_code
  if { $ret_code } \
  {
   set mom_sys_arr(\$$new_var) $ret_code
  } else \
  {
   set fmt_obj $mom_sys_arr(\$$new_var)
   set mom_sys_arr(\$$var) $format::($fmt_obj,for_name)
   $widget config -value $mom_sys_arr(\$$var)
  }
 }

#=======================================================================
proc UI_PB_mthd_CreateScrollWindow { widget_id ext WINDOW } {
  upvar $WINDOW window
  global paOption
  set src_win [tixScrolledWindow $widget_id.$ext -height 100]
  [$src_win subwidget hsb] config -troughcolor $paOption(trough_bg) \
  -width $paOption(trough_wd)
  [$src_win subwidget vsb] config -troughcolor $paOption(trough_bg) \
  -width $paOption(trough_wd)
  pack $src_win -side top -expand yes -fill both -padx 3
  set window [$src_win subwidget window]
 }

#=======================================================================
proc UI_PB_mthd_CreatePane {this} {
  global paOption
  set page_id $Page::($this,page_id)
  set pane [tixPanedWindow $page_id.pane -orient horizontal]
  pack $pane -expand yes -fill both
  set f1 [$pane add p1 -expand 1 -size 225]
  set f2 [$pane add p2 -expand 1 -size 675]
  set Page::($this,left_pane_id) $f1
  $f1 config -relief flat
  $f2 config -relief flat
  set p2s [$pane subwidget p2]
  set p2p [frame $p2s.pp]
  pack $p2p -side top -expand yes -fill both
  set Page::($this,canvas_frame) $p2p
 }

#=======================================================================
proc UI_PB_mthd_CreateTree {this} {
  global paOption
  global tixOption
  set left_pane $Page::($this,left_pane_id)
  set tree [tixTree $left_pane.slb \
  -options {
   hlist.indicator   1
   hlist.indent      20
   hlist.drawbranch  1
   hlist.selectMode  single
   hlist.width       40
   hlist.separator   "."
   hlist.wideselect  false
  }]
  set Page::($this,tree) $tree
  [$tree subwidget hsb] config -troughcolor $paOption(trough_bg) \
  -width $paOption(trough_wd)
  [$tree subwidget vsb] config -troughcolor $paOption(trough_bg) \
  -width $paOption(trough_wd)
  pack $tree -side top -fill both -expand yes -padx 5
  global gPB
  set gPB(c_help,[$tree subwidget hlist]) "tree,select"
 }

#=======================================================================
proc UI_PB_mthd_CreateCheckList {this} {
  global paOption
  global tixOption
  set left_pane $Page::($this,left_pane_id)
  set tree [tixCheckList $left_pane.slb \
  -options {
   relief            sunken
   hlist.indicator   1
   hlist.indent      20
   hlist.drawbranch  1
   hlist.selectMode  single
   hlist.width       40
   hlist.separator   "."
   hlist.wideselect  false
  }]
  set Page::($this,tree) $tree
  [$tree subwidget hsb] config -troughcolor $paOption(trough_bg) \
  -width $paOption(trough_wd)
  [$tree subwidget vsb] config -troughcolor $paOption(trough_bg) \
  -width $paOption(trough_wd)
  pack $tree -side top -fill both -expand yes -padx 5
 }

#=======================================================================
proc UI_PB_mthd_CreateCanvas {this TOP_CANVAS_DIM BOT_CANVAS_DIM} {
  upvar $TOP_CANVAS_DIM top_canvas_dim
  upvar $BOT_CANVAS_DIM bot_canvas_dim
  global paOption
  set WIDGET $Page::($this,canvas_frame)
  set seq_canvas_id [frame $WIDGET.frame]
  set box [frame $WIDGET.box_frm]
  pack $box -side bottom -fill x -padx 3 -pady 3
  pack $seq_canvas_id -side top -fill both -expand yes
  set top_canvas [canvas $seq_canvas_id.top]
  $top_canvas config -height $top_canvas_dim(0) -width $top_canvas_dim(1)
  pack $top_canvas -side top -fill x -padx 3
  set bc [$top_canvas config -background]
  $top_canvas config -highlightcolor [lindex $bc end]
  set hs [scrollbar $seq_canvas_id.hs -orient horizontal \
  -troughcolor $paOption(can_trough_bg) \
  -width       $paOption(trough_wd) \
  -command     "$seq_canvas_id.bot xview"]
  set vs [scrollbar $seq_canvas_id.vs -orient vertical \
  -troughcolor $paOption(can_trough_bg) \
  -width       $paOption(trough_wd) \
  -command     "$seq_canvas_id.bot yview"]
  set bot_canvas [canvas $seq_canvas_id.bot -relief sunken \
  -bd 2 -bg $paOption(can_bg) \
  -xscrollcommand "$seq_canvas_id.hs set" \
  -yscrollcommand "$seq_canvas_id.vs set"]
  pack $hs -side bottom -fill x
  pack $bot_canvas -side left -expand yes -fill both -padx 3
  pack $vs -side right -fill y
  $bot_canvas config -scrollregion "0 0 $bot_canvas_dim(0) $bot_canvas_dim(1)"
  set Page::($this,act_can_frame) $seq_canvas_id
  set Page::($this,top_canvas)    $top_canvas
  set Page::($this,bot_canvas)    $bot_canvas
  set Page::($this,panel_hi)      $top_canvas_dim(0)
  set Page::($this,panel_width)   $top_canvas_dim(1)
  set Page::($this,hor_scrol)     $hs
  set Page::($this,ver_scrol)     $vs
  set Page::($this,bot_height)    $bot_canvas_dim(0)
  set Page::($this,bot_width)     $bot_canvas_dim(1)
  set Page::($this,box)           $box
 }

#=======================================================================
proc UI_PB_mthd_CreateMenu { this } {
  set top_canvas $Page::($this,top_canvas)
  set evt_frm [frame $top_canvas.f]
  $top_canvas create window 350 40 -window $evt_frm
  set cbx [tix getbitmap cbxarrow]
  entry $evt_frm.ent -width 40 -relief sunken -bd 2 -bg lightblue \
  -textvariable Page::($this,comb_var) -state disabled
  pack $evt_frm.ent -side left
  menubutton $evt_frm.but -bitmap $cbx -width 17 -height 20 \
  -relief raised -menu $evt_frm.but.menu
  pack $evt_frm.but -side left -padx 1
  set comb_widget $evt_frm.but.menu
  menu $comb_widget -tearoff 1
  set Page::($this,comb_widget) $comb_widget
 }

#=======================================================================
proc UI_PB_mthd_CreateAddTrashinCanvas {this} {
  global paOption
  global tixOption
  set top_canvas $Page::($this,top_canvas)
  set panel_hi $Page::($this,panel_hi)
  set evt_cell1(trash)  [UI_PB_blk_CreateIcon $top_canvas pb_trash ""]
  set add_comp [image create compound -window $top_canvas \
  -bd 1 \
  -background #c0c0ff \
  -borderwidth 2 \
  -relief raised \
  -showbackground 1]
  $add_comp add text -text $Page::($this,add_name) \
  -font $tixOption(bold_font) -anchor w
  set dy [expr [expr $panel_hi / 2] + 2]
  $top_canvas create image 80 $dy -image $add_comp \
  -tag add_movable
  $add_comp config -bg $paOption(app_butt_bg)
  set Page::($this,add) $add_comp
  $top_canvas create image 610 $dy -image $evt_cell1(trash) \
  -tag evt_trash
  $top_canvas bind evt_trash <Enter> \
  "__mthd_FocusTrashBin $this ENTER"
  $top_canvas bind evt_trash <Leave> \
  "__mthd_FocusTrashBin $this LEAVE"
  $top_canvas bind evt_trash <ButtonRelease-1> \
  " " 
  $evt_cell1(trash) config -bg $paOption(app_butt_bg)
  lappend trash_cell $evt_cell1(trash) [expr 610 - 80] \
  [expr 610 + 80] -$panel_hi 0
  set Page::($this,trash) $trash_cell
 }

#=======================================================================
proc __mthd_FocusTrashBin { page sw } {
  global paOption
  global gPB
  set top_canvas $Page::($page,top_canvas)
  set trash_cell $Page::($page,trash)
  set trash_bin [lindex $trash_cell 0]
  if { $sw == "ENTER" } {
   if { $gPB(use_info) } {
    $top_canvas config -cursor question_arrow
   }
   $trash_bin config -bg $paOption(focus)
   } else {
   $top_canvas config -cursor ""
   $trash_bin config -bg $paOption(app_butt_bg)
  }
 }
