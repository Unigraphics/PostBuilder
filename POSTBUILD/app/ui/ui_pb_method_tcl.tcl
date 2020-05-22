#12

#=======================================================================
proc UI_PB_mthd_CreateFrame {inp_frm frm_ext} {
  set frame_id [frame $inp_frm.$frm_ext]
  return $frame_id
 }

#=======================================================================
proc UI_PB_mthd_CreateLabel {inp_frm ext label} {
  label $inp_frm.$ext -text $label -wraplength 170
  global tcl_platform
  if { $tcl_platform(platform) == "unix" } {
   pack $inp_frm.$ext -pady 8
   } else {
   if {$::tcl_version == "8.4"} {
    pack $inp_frm.$ext -pady 6
    } else {
    pack $inp_frm.$ext -pady 10
   }
  }
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
  global mom_sim_arr
  if { [string match "\$mom_kin*" $var] } \
  {
   set gb_arr "mom_kin_var"
   } elseif {[string match "\$mom_sim*" $var]} \
  {
   set gb_arr "mom_sim_arr"
   } else {
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
  if { [string compare $label ""] == 0 } \
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
  global mom_sim_arr
  if { [string match "\$mom_kin*" $var1] } \
  {
   set gb_arr "mom_kin_var"
   } elseif {[string match "\$mom_sim*" $var1]} \
  {
   set gb_arr "mom_sim_arr"
   } else {
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
proc UI_PB_mthd_CreateEntry { var inp_frm ext } {
  global mom_sys_arr
  global mom_kin_var
  global mom_sim_arr
  if { [string match "\$mom_kin*" $var] } \
  {
   set gb_arr "mom_kin_var"
   } elseif {[string match "\$mom_sim*" $var]} \
  {
   set gb_arr "mom_sim_arr"
   } else {
   set gb_arr "mom_sys_arr"
  }
  entry $inp_frm.1_$ext -width 30 -relief sunken -bd 2 \
  -textvariable ${gb_arr}($var) -state disabled
  pack $inp_frm.1_$ext -side left -padx 3 -pady 5 -fill x
 }

#=======================================================================
proc UI_PB_mthd_CreateLblEntry { data_type var inp_frm ext label args } {
  global mom_sys_arr
  global mom_kin_var
  global mom_sim_arr
  global tixOption
  if { [string match "\$mom_kin*" $var] } \
  {
   set gb_arr "mom_kin_var"
   } elseif {[string match "\$mom_sim*" $var]} \
  {
   set gb_arr "mom_sim_arr"
  } else \
  {
   set gb_arr "mom_sys_arr"
  }
  if { [string compare $label ""] == 0} \
  {
   set text $label
  } else  \
  {
   if {[info exists ::gPB(localization)] && $::gPB(localization) == 1} {
    set text [format "%-8s" $label]
    } else {
    set text [format "%-20s" $label]
   }
  }
  label $inp_frm.$ext -text $text -font $tixOption(font) -justify left
  if { [string match "null" $var] || [string match "" $var] } {
   set ent [entry $inp_frm.1_$ext -width 10 -relief sunken -bd 2]
   } else {
   set ent [entry $inp_frm.1_$ext -width 10 -relief sunken -bd 2 \
   -textvariable ${gb_arr}($var)]
  }
  global gPB
  set args [split [join $args] ]
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
   set gPB(c_help,$ent)    "common,entry"
  }
  if {[info exists ::env(INCH_METRIC)] && $::env(INCH_METRIC) == 1} {
   if [string match "*_unit" $ext] {
    set unit_flag 1
    } else {
    set unit_flag 0
   }
   if {$unit_flag == 1} {
    label $inp_frm.unit_lbl -textvariable gPB(unit_flag) -width 2 \
    -font $::tixOption(fixed_font) \
    -fg $::paOption(unit_fg)
    if ![info exists ${gb_arr}(${var}_IN)] {
     if [string match $gPB(unit_flag) in] {
      set ${gb_arr}(${var}_IN) [set ${gb_arr}($var)]
      set ${gb_arr}(${var}_MM) [expr [set ${gb_arr}($var)] * 25.4]
      } else {
      set ${gb_arr}(${var}_IN) [expr [set ${gb_arr}($var)] / 25.4]
      set ${gb_arr}(${var}_MM) [set ${gb_arr}($var)]
     }
    }
    if [string match $gPB(unit_flag) in] {
     $inp_frm.1_$ext config -textvariable ${gb_arr}(${var}_IN)
     } else {
     $inp_frm.1_$ext config -textvariable ${gb_arr}(${var}_MM)
    }
    global UNIT_INFO
    if [string match "*_asso_unit" $ext] {
     $inp_frm.1_$ext config -bg $::paOption(unit_ent_bg)
     set UNIT_INFO($inp_frm.1_$ext) [list 1 $gb_arr $var]
     } else {
     set UNIT_INFO($inp_frm.1_$ext) [list 0 $gb_arr $var]
    }
    pack $inp_frm.$ext -side left -padx 5 -pady 6
    pack $inp_frm.unit_lbl -side right -padx 0 -pady 6
    pack $inp_frm.1_$ext -side right -padx 5 -pady 6
    } else {
    pack $inp_frm.$ext -side left -padx 5 -pady 6
    pack $inp_frm.1_$ext -side right -padx 5 -pady 6
   }
   } else {
   pack $inp_frm.$ext -side left -padx 5 -pady 6
   pack $inp_frm.1_$ext -side right -padx 5 -pady 6
  }
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
  bind $inp_frm.1_$ext <KeyRelease> {%W config -state normal ;set ::gPB(prev_key) ""}
 }

#=======================================================================
proc UI_PB_mthd_GetAddName { sys_var code_type ADD_NAME} {
  upvar $ADD_NAME add_name
  global gpb_addr_var
  global paOption
  if {[string match "G" $code_type]} {
   set g_flag 1
   } elseif {[string match "M" $code_type]} {
   set g_flag 0
   } else {
  }
  if { $g_flag } {
   if { [string match "*_cycle_ret_*" $sys_var] } { ;#<03-20-08 gsl> "*_cycle_ret_*" was "*return*".
    set add_name "G_return"
    } elseif { [string match "*_rapid_*"  $sys_var] ||\
    [string match "*_linear_*" $sys_var] ||\
    [string match "*_cycle_*"  $sys_var] ||\
    [string match "*_circle_*" $sys_var] } {
    set add_name "G_motion"
    } elseif { [string match "*_plane_*" $sys_var] } {
    set add_name "G_plane"
    } elseif { [string match "*_cutcom_*" $sys_var] } {
    set add_name "G_cutcom"
    } elseif { [string match "*_adjust_*" $sys_var] } { ;#<03-20-08 gsl> "*_adjust_*" was "*length*".
    set add_name "G_adjust"
    } elseif { [string match "*_feed_*" $sys_var] } {
    set add_name "G_feed"
    } elseif { [string match "*_spindle_*" $sys_var] } {
    set add_name "G_spin"
    } elseif { [string match "*_output_*" $sys_var] } {
    set add_name "G_mode"
    } else {
    set add_name "G"
   }
   } else {
   if { [string match "*_spindle_range_*" $sys_var] } {
    set add_name "M_range"
    } elseif { [string match "*_spindle_*" $sys_var] } {
    set add_name "M_spindle"
    } elseif { [string match "*_coolant_*" $sys_var] } {
    set add_name "M_coolant"
    } else {
    set add_name "M"
   }
  }
 }

#=======================================================================
proc UI_PB_mthd_CreateLblCodeEntry { data_type var inp_frm ext label args } {
  global mom_sys_arr
  global mom_kin_var
  global mom_sim_arr gPB
  global tixOption paOption
  if { [string match "\$mom_kin*" $var] } \
  {
   set gb_arr "mom_kin_var"
   } elseif {[string match "\$mom_sim*" $var]} \
  {
   set gb_arr "mom_sim_arr"
  } else \
  {
   set gb_arr "mom_sys_arr"
  }
  set text [eval format "%s" $label]
  if { [string compare $text ""] == 0 } \
  {
   set text $text
  } else  \
  {
   set text [format "%-5s" $text]
  }
  label $inp_frm.$ext -text $text -font $tixOption(bold_font) -justify left
  set code_type [lindex $args 0]
  UI_PB_mthd_GetAddName $var $code_type add_name
  global gpb_addr_var
  if { ![info exists gpb_addr_var($add_name,leader_name)] || [string match "" $gpb_addr_var($add_name,leader_name)] } {
   set bgc $paOption(table_bg)
   } else {
   set bgc $paOption(special_bg)
  }
  label $inp_frm.2_$ext -textvariable gpb_addr_var($add_name,leader_name) \
  -font $tixOption(bold_font) -padx 3 -bg $bgc -fg $paOption(special_fg)
  set gPB($var) [set ${gb_arr}($var)]
  if { [string match "null" $var] || [string match "" $var] } {
   set ent [entry $inp_frm.1_$ext -width 10 -relief sunken -bd 2]
   } else {
   if 0 { ;#<01-24-08 gsl> - Error
    -textvariable ${gb_arr}($var)]
   }
   set ent [entry $inp_frm.1_$ext -width 10 -relief sunken -bd 2 \
   -textvariable gPB($var)]
  }
  global gPB
  set args [split [join $args] ]
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
  pack $inp_frm.2_$ext -side right -pady 6
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
  bind $inp_frm.1_$ext <KeyRelease> "UI_PB_com_FormatCode %W $add_name $gb_arr $var"
  UI_PB_com_FormatCode $inp_frm.1_$ext $add_name $gb_arr $var
 }

#=======================================================================
proc UI_PB_mthd_CreateCheckEntry { data_type var1 var2 inp_frm ext label args } {
  global mom_sys_arr
  global mom_kin_var
  global tixOption
  global mom_sim_arr
  UI_PB_mthd_CreateCheckButton $var1 $inp_frm $ext $label
  if { [string match "\$mom_kin*" $var2] } \
  {
   set gb_arr "mom_kin_var"
   } elseif {[string match "\$mom_sim*" $var2]} \
  {
   set gb_arr "mom_sim_arr"
   } else {
   set gb_arr "mom_sys_arr"
  }
  set ent [entry $inp_frm.1_$ext -width 10 -relief sunken -bd 2 \
  -textvariable ${gb_arr}($var2)]
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
   set gPB(c_help,$ent)     "common,entry"
  }
  pack $inp_frm.1_$ext -side right -padx 5 -pady 6
  if { $data_type == "a" } \
  {
   set data_type [UI_PB_com_RetSysVarDataType var2]
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
  bind $inp_frm.1_$ext <KeyRelease> {%W config -state normal;set ::gPB(prev_key) ""}
 }

#=======================================================================
proc UI_PB_mthd_CreateCheckButton {var inp_frm ext label} {
  global mom_sys_arr
  global mom_kin_var
  global mom_sim_arr
  if { [string match "\$mom_kin*" $var] } \
  {
   set gb_arr "mom_kin_var"
   } elseif {[string match "\$mom_sim*" $var]} \
  {
   set gb_arr "mom_sim_arr"
   } else {
   set gb_arr "mom_sys_arr"
  }
  set text $label
  if { $var == "null" || $var == "" } \
  {
   checkbutton $inp_frm.$ext -text "$text" \
   -relief flat -bd 2 -anchor w -highlightt 0
   } else {
   checkbutton $inp_frm.$ext -text "$text" \
   -variable ${gb_arr}($var) \
   -relief flat -bd 2 -anchor w
  }
  pack $inp_frm.$ext -side left -padx 3 -pady 5 -fill x
 }

#=======================================================================
proc UI_PB_mthd_CreateButton { inp_frm ext label} {
  set text [format "%-20s" $label]
  button $inp_frm.$ext -text "$label" -padx 10
  grid $inp_frm.$ext -padx 40 -sticky ew
 }

#=======================================================================
proc UI_PB_mthd_CreateRadioButton { var inp_frm ext label args } {
  global mom_sys_arr
  global mom_kin_var
  global mom_sim_arr
  if { [string match "\$mom_kin*" $var] } \
  {
   set gb_arr "mom_kin_var"
   } elseif {[string match "\$mom_sim*" $var]} \
  {
   set gb_arr "mom_sim_arr"
   } else {
   set gb_arr "mom_sys_arr"
  }
  if [llength $args] {
   set val [lindex $args 0]
   } else {
   set val [string toupper [join [split $label " "] _] ]
  }
  radiobutton $inp_frm.$ext -text $label -variable ${gb_arr}($var) \
  -value $val
  pack $inp_frm.$ext -side left -padx 3 -pady 3 -fill x
 }

#=======================================================================
proc UI_PB_mthd_CreateOptionalMenu { var inp_frm ext option_list \
  label args } {
  global mom_sys_arr
  global mom_kin_var
  global mom_sim_arr
  if { $var == "null" || $var == "" } \
  {
   set gb_arr ""
   set temp_value ""
   } elseif { [string match "\$mom_kin*" $var] } \
  {
   set gb_arr "mom_kin_var"
   set temp_value $mom_kin_var($var)
   } elseif {[string match "\$mom_sim*" $var]} \
  {
   set gb_arr "mom_sim_arr"
   set temp_value $mom_sim_arr($var)
   } else {
   set gb_arr "mom_sys_arr"
   set temp_value $mom_sys_arr($var)
  }
  if { ![string match "" $label] } {
   set label "$label "
  }
  tixOptionMenu $inp_frm.$ext -label $label \
  -labelside left \
  -variable ${gb_arr}($var)
  if 0 {
  }
  set length 0
  foreach option $option_list \
  {
   set opt_length [string length $option]
   if { $opt_length > $length } { set length $opt_length }
   set temp_opt [split $option " "]
   set opt [join $temp_opt _]
   switch -exact -- $option {
    "Other" {
     set lbl $::gPB(optionMenu,item,Other)
    }
    "IPM" {
     set lbl $::gPB(optionMenu,item,IPM)
    }
    "FRN" {
     set lbl $::gPB(optionMenu,item,FRN)
    }
    "DPM" {
     set lbl $::gPB(optionMenu,item,DPM)
    }
    "IPR" {
     set lbl $::gPB(optionMenu,item,IPR)
    }
    "Auto"  {
     set lbl $::gPB(optionMenu,item,Auto)
    }
    "Absolute/Incremental" {
     set lbl $::gPB(optionMenu,item,Abs_Inc)
    }
    "Absolute Only" {
     set lbl $::gPB(optionMenu,item,Abs_Only)
    }
    "Incremental Only" {
     set lbl $::gPB(optionMenu,item,Inc_Only)
    }
    "FRONT" {
     set lbl $::gPB(machine,gen,turret,front,Label)
    }
    "REAR" {
     set lbl $::gPB(machine,gen,turret,rear,Label)
    }
    "RIGHT" {
     set lbl $::gPB(machine,gen,turret,right,Label)
    }
    "LEFT" {
     set lbl $::gPB(machine,gen,turret,left,Label)
    }
    "SIDE" {
     set lbl $::gPB(machine,gen,turret,side,Label)
    }
    "SADDLE" {
     set lbl $::gPB(machine,gen,turret,saddle,Label)
    }
    "Shortest Distance" {
     set lbl $::gPB(optionMenu,item,SD)
    }
    "Always Positive" {
     set lbl $::gPB(optionMenu,item,AP)
    }
    "Always Negative" {
     set lbl $::gPB(optionMenu,item,AN)
    }
    "Z Axis" {
     set lbl $::gPB(optionMenu,item,Z_Axis)
    }
    "+X Axis" {
     set lbl $::gPB(optionMenu,item,+X_Axis)
    }
    "-X Axis" {
     set lbl $::gPB(optionMenu,item,-X_Axis)
    }
    "Y Axis" {
     set lbl $::gPB(optionMenu,item,Y_Axis)
    }
    "Magnitude Determines Direction" {
     set lbl $::gPB(optionMenu,item,MDD)
    }
    "Sign Determines Direction" {
     set lbl $::gPB(optionMenu,item,SDD)
    }
    "None" {
     set lbl $::gPB(optionMenu,item,None)
    }
    "Rapid Traverse & R" {
     set lbl $::gPB(optionMenu,item,RT_R)
    }
    "Rapid" {
     set lbl $::gPB(optionMenu,item,Rapid)
    }
    "Rapid Spindle" {
     set lbl $::gPB(optionMenu,item,RS)
    }
    "Cycle Off then Rapid Spindle" {
     set lbl $::gPB(optionMenu,item,C_off_RS)
    }
    default {
     set lbl $option
    }
   }
   $inp_frm.$ext add command $opt -label $lbl
   unset temp_opt opt
  }
  if [string match "" $temp_value] {
   set temp_value [join [split [lindex $option_list 0] " "] _]
  }
  $inp_frm.$ext config -value $temp_value
  if { $length != 0 && $label != "" } \
  {
   pack forget [$inp_frm.$ext subwidget menubutton]
   pack [$inp_frm.$ext subwidget menubutton] -side right
  }
  pack $inp_frm.$ext -padx 3 -fill x -expand yes
 }

#=======================================================================
proc UI_PB_CreateCombBox { var fmt_frm ext option_list } {
  global mom_sys_arr
  global mom_kin_var
  global mom_sim_arr
  global paOption
  if { [string match "\$mom_kin*" $var] } \
  {
   set gb_arr "mom_kin_var"
   } elseif {[string match "\$mom_sim*" $var] } \
  {
   set gb_arr "mom_sim_arr"
   } elseif {[string match "\$mom_sys*" $var] } \
  {
   set gb_arr "mom_sys_arr"
   } elseif  {[string match "gPB*" $var]} \
  {
   set gb_arr "gPB"
   set var_end [expr [string last ")" $var] - 1]
   set var [string range $var 4 $var_end]
   } else {
   set gb_arr ""
  }
  switch $::tix_version {
   8.4 {
    set fmt_sel [tixComboBox $fmt_frm.$ext \
    -dropdown   yes \
    -editable   yes \
    -variable   ${gb_arr}($var) \
    -command    "" \
    -selectmode browse \
    -grab       local \
    -options {
     listbox.anchor   w
     listbox.height   4
     entry.width      30
    }]
    [$fmt_sel subwidget entry] config -readonlybackground $paOption(entry_disabled_bg) \
    -selectbackground lightblue \
    -selectforeground black \
    -cursor "" -state readonly
   }
   4.1 {
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
    [$fmt_sel subwidget entry] config -bg $paOption(entry_disabled_bg) -cursor ""
   }
  }
  pack $fmt_frm.$ext -side top -padx 3 -pady 3
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
  global paOption gPB
  set var_list [split $var ,]
  set new_var [join $var_list ",1_"]
  PB_int_RetFormatObjList fmt_obj_list
  set fmt_name $mom_sys_arr($var)
  PB_int_RetFmtObjFromName fmt_name fmt_obj
  set mom_sys_arr($new_var) $fmt_obj
  set mom_sys_arr($fmt_name) $fmt_obj
  button $fmt_frm.but_$ext -text " $gPB(nav_button,edit,Label) " -font $tixOption(bold_font)
  pack $fmt_frm.but_$ext -side left -padx 10 -pady 3
  set comb_var [string trimleft $var \$]
  switch $::tix_version {
   8.4 {
    set fmt_sel [tixComboBox $fmt_frm.cb_$ext \
    -dropdown   yes \
    -editable   yes \
    -variable   mom_sys_arr($var) \
    -command    "UI_PB_Combo_CB $fmt_frm.cb_$ext $comb_var" \
    -selectmode browse \
    -grab       local \
    -options {
     listbox.anchor   w
     listbox.height   4
     slistbox.width   15
     entry.width      15
    }]
    [$fmt_sel subwidget entry]  config -readonlybackground $paOption(entry_disabled_bg) \
    -selectbackground lightblue \
    -selectforeground black \
    -cursor "" -state readonly
   }
   4.1 {
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
    [$fmt_sel subwidget entry] config -bg $paOption(entry_disabled_bg) -cursor ""
   }
  }
  pack $fmt_frm.cb_$ext -side right -padx 10 -pady 3
  set lbx [$fmt_sel subwidget listbox]
  $lbx delete 0 end
  set name_arr_size [llength $fmt_obj_list]
  for {set ind 0} {$ind < $name_arr_size} {incr ind}\
  {
   set fmt_obj [lindex $fmt_obj_list $ind]
   set fmt_name $format::($fmt_obj,for_name)
   if {[info exists ::env(INCH_METRIC)] && $::env(INCH_METRIC) == 1} {
    set ex_list [list Coordinate_IN Coordinate_MM AbsCoord_IN \
    AbsCoord_MM Feed]
    if {[lsearch $ex_list $fmt_name] < 0} {
     $fmt_sel insert end $fmt_name
    }
    } else {
    $fmt_sel insert end $fmt_name
   }
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
  switch $::tix_version {
   8.4 {
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
    [$fmt_sel subwidget entry] config -readonlybackground $paOption(entry_disabled_bg) \
    -selectbackground lightblue \
    -selectforeground black \
    -cursor "" -state readonly
   }
   4.1 {
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
    [$fmt_sel subwidget entry] config -bg $paOption(entry_disabled_bg) -cursor ""
   }
  }
  pack $fmt_frm.cb_$ext -side right -padx 10 -pady 3
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
proc UI_PB_mthd_CreateScrollWindow { widget_id ext WINDOW {flags null}} {
   upvar $WINDOW window
   global paOption
   switch $::tix_version {
    8.4 {
     set window [UI_PB_mthd_CreateSFrameWindow $widget_id.$ext $flags]
     pack $widget_id.$ext -side top -expand yes -fill both -padx 3
    }
    4.1 {
     set src_win [tixScrolledWindow $widget_id.$ext -height 100]
     [$src_win subwidget hsb] config -troughcolor $paOption(trough_bg)
     [$src_win subwidget vsb] config -troughcolor $paOption(trough_bg)
     pack $src_win -side top -expand yes -fill both -padx 3
     set window [$src_win subwidget window]
    }
   }
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
  set tree [tixTree $left_pane.slb  \
  -options {
   hlist.indicator   1
   hlist.indent      20
   hlist.drawbranch  1
   hlist.selectMode  single
   hlist.width       40
   hlist.separator   "."
   hlist.wideselect  false
  }]
  if ![string compare $::tix_version 8.4] {
   $tree configure -takefocus 1 -highlightthickness 0
   set hlist_tree [$tree subwidget hlist]
   $hlist_tree  configure -bd 1
   pack $hlist_tree -pady 3
  }
  set Page::($this,tree) $tree
  [$tree subwidget hsb] config -troughcolor $paOption(trough_bg) \
  -width $paOption(trough_wd)
  [$tree subwidget vsb] config -troughcolor $paOption(trough_bg) \
  -width $paOption(trough_wd)
  pack $tree -side top -fill both -expand yes -padx 5
  global gPB
  set gPB(c_help,[$tree subwidget hlist])    "tree,select"
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
  set hlist_tree [$tree subwidget hlist]
  if ![string compare $::tix_version 8.4] {
   $tree config -highlightthickness 0
  }
  set Page::($this,tree) $tree
  [$tree subwidget hsb] config -troughcolor $paOption(trough_bg) \
  -width $paOption(trough_wd)
  [$tree subwidget vsb] config -troughcolor $paOption(trough_bg) \
  -width $paOption(trough_wd)
  pack $tree -side top -fill both -expand yes -padx 5
  global gPB
  set gPB(c_help,[$tree subwidget hlist])    "tree,select"
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
  set aux_f [frame $seq_canvas_id.f -height $top_canvas_dim(0)]
  set pad_f [frame $seq_canvas_id.f.f -width [expr {$paOption(trough_wd) + 2}]]
  switch $::tix_version {
   8.4 {
    set top_canvas [canvas $aux_f.top -takefocus 0 -highlightt 0]
   }
   4.1 {
    set top_canvas [canvas $aux_f.top -takefocus 0 -highlightt 1]
   }
  }
  $top_canvas config -height $top_canvas_dim(0) -width $top_canvas_dim(1)
  pack $pad_f -side right -anchor se -fill y
  pack $top_canvas -side top -fill x -padx 3
  pack $aux_f -side top -fill x
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
  switch $::tix_version {
   8.4 {
    set bot_canvas [canvas $seq_canvas_id.bot -relief sunken \
    -bd 1 -bg $paOption(can_bg) -takefocus 1 -highlightcolor $::SystemButtonFace \
    -xscrollcommand "$seq_canvas_id.hs set"  -highlightt 0 \
    -yscrollcommand "$seq_canvas_id.vs set"]
    $top_canvas configure -scrollregion "0 0 701 80"
   }
   4.1 {
    set bot_canvas [canvas $seq_canvas_id.bot -relief sunken \
    -bd 2 -bg $paOption(can_bg)  \
    -xscrollcommand "$seq_canvas_id.hs set" \
    -yscrollcommand "$seq_canvas_id.vs set"]
   }
  }
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
  update
 }

#=======================================================================
proc UI_PB_mthd_CreateMenu { this args } {
  if {[llength $args] > 0 } {
   set evt_frm [lindex $args 0]
   } else {
   set top_canvas $Page::($this,top_canvas)
   set evt_frm [frame $top_canvas.f]
   $top_canvas create window 350 40 -window $evt_frm
  }
  set cbx [tix getbitmap cbxarrow]
  switch $::tix_version {
   8.4 {
    entry $evt_frm.ent -width 40 -relief sunken -bd 2 -readonlybackground lightblue \
    -textvariable Page::($this,comb_var) -state readonly
    pack $evt_frm.ent -side left
   }
   4.1 {
    entry $evt_frm.ent -width 40 -relief sunken -bd 2 -bg lightblue \
    -textvariable Page::($this,comb_var) -state disabled
    pack $evt_frm.ent -side left
   }
  }
  menubutton $evt_frm.but -bitmap $cbx -width 17 -height 20 \
  -relief raised -menu $evt_frm.but.menu
  pack $evt_frm.but -side left -padx 1
  set comb_widget $evt_frm.but.menu
  menu $comb_widget -tearoff 0 ;#<03-06-02 gsl> was 1.
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
  " " ;# Needed to relieve CSH binding
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

#=======================================================================
proc UI_PB_mthd_CreateSFrameWindow {f {flags y} args} {
  global paOption
  switch -exact -- $flags {
   x {
    frame $f -relief sunken -bd 2
    eval {scrolledframe $f.sf  \
    -xscrollcommand [list $f.xscroll set]} $args
    scrollbar $f.xscroll -orient horizontal -troughcolor $paOption(trough_bg) \
    -command [list $f.sf xview]
    grid $f.sf -row 0 -column 0 -sticky nsew
    grid $f.xscroll -row 1 -column 0 -sticky ew
    grid rowconfigure $f 0 -weight 1
    grid columnconfigure $f 0 -weight 1
    ::autoscroll::autoscroll $f.xscroll
    return $f.sf.scrolled
   }
   y {
    frame $f -relief sunken -bd 2
    eval {scrolledframe $f.sf  \
    -yscrollcommand [list $f.yscroll set]} $args
    scrollbar $f.yscroll -orient vertical -troughcolor $paOption(trough_bg) \
    -command [list $f.sf yview]
    grid $f.sf -row 0 -column 0 -sticky nsew
    grid $f.yscroll -row 0 -column 1 -sticky ns
    grid rowconfigure $f 0 -weight 1
    grid columnconfigure $f 0 -weight 1
    ::autoscroll::autoscroll $f.yscroll
    return $f.sf.scrolled
   }
   xy {
    frame $f -relief sunken -bd 2
    eval {scrolledframe $f.sf  \
     -xscrollcommand [list $f.xscroll set] \
    -yscrollcommand [list $f.yscroll set]} $args
    scrollbar $f.xscroll -orient horizontal -troughcolor $paOption(trough_bg) \
    -command [list $f.sf xview]
    scrollbar $f.yscroll -orient vertical -troughcolor $paOption(trough_bg) \
    -command [list $f.sf yview]
    grid $f.sf -row 0 -column 0 -sticky nsew
    grid $f.yscroll -row 0 -column 1 -sticky ns
    grid $f.xscroll -row 1 -column 0 -sticky ew
    grid rowconfigure $f 0 -weight 1
    grid columnconfigure $f 0 -weight 1
    ::autoscroll::autoscroll $f.xscroll
    ::autoscroll::autoscroll $f.yscroll
    return $f.sf.scrolled
   }
   null {
    frame $f -relief sunken -bd 2
    return $f
   }
  }
 }

#=======================================================================
proc UI_PB_mthd_MouseWheel {wFired D X Y {dir y}} {
   if {[bind [winfo class $wFired] <MouseWheel>] ne ""} { return }
   set w [winfo containing $X $Y]
   if {![winfo exists $w]} { catch {set w [focus]} }
   if {[winfo exists $w]} {
    if {[winfo class $w] eq "Scrollbar"} {
     catch {tk::ScrollByUnits $w \
      [string index [$w cget -orient] 0] \
      [expr {-($D/30)}]}
     } else {
     catch {$w ${dir}view scroll [expr {- ($D / 120) * 1}] units}
    }
   }
  }

#=======================================================================
proc UI_PB_mthd_WheelForFrame_binding {D w} {
  if {$D > 0} {
   $w yview scroll -1 units
   } else {
   $w yview scroll 1 units
  }
 }

#=======================================================================
proc UI_PB_mthd_WheelForFrame {w} {
  set cl [tixDescendants $w]
  set indx [llength $cl]
  set assis_l ""
  for {set i 0} {$i < $indx} {incr i} {
   set cw [lindex $cl $i]
   if {[winfo class $cw] == "Label"} {
    set assis_l $cw
    break
   }
  }
  if {$assis_l != ""} {
   $assis_l config -takefocus 1
   } else {
   set assis_l [label $w.l -takefocus 1]
   pack $w.l
  }
  bind $assis_l <MouseWheel> "UI_PB_mthd_WheelForFrame_binding %D $w"
  bind $w <Button-1> "+ focus $assis_l"
  set tixCBox [list]
  foreach child $cl {
   set type [winfo class $child]
   if [string match $type "TixComboBox"] {
    lappend tixCBox $child
   }
  }
  foreach child $cl {
   set type [winfo class $child]
   if {
    ![string match $type "Entry"] && ![string match $type "Button"] && \
    ![string match $type "Menubutton"]
    } then {
    set to_bind 1
    foreach one $tixCBox {
     if [string match ${one}.* $child] {
      set to_bind 0
      break
     }
    }
    if {$to_bind == 1} {
     bind $child <Button-1> "+ focus $assis_l"
    }
   }
  }
 }

#=======================================================================
proc UI_PB_mthd_CreateDDBlock {x y typeflag t_shift icon_name elem_text {ops_nows_force NULL}} {
   global paOption
   global tixOption
   if [winfo exists .ddBlock] {
    destroy .ddBlock
   }
   switch -exact -- $typeflag {
    eventblock {
     toplevel .ddBlock -bg $paOption(butt_bg) -borderwidth 2 \
     -relief raised -highlightt 0
     wm overrideredirect .ddBlock 1
     wm geom .ddBlock 175x25+[expr {$x - 88}]+[expr {$y - 12}]
     canvas .ddBlock.c -bg $paOption(butt_bg) -relief flat \
     -bd 0 -highlightt 0
     pack .ddBlock.c -fill both -expand yes -side top
     set image_addr [tix getimage $icon_name]
     .ddBlock.c create image 85 10 -image $image_addr
     .ddBlock.c create text [expr {87 + $t_shift}] 10 \
     -text $elem_text -font $tixOption(font_sm)
    }
    addressblock {
     update
     toplevel .ddBlock -bg $paOption(sunken_bg) -borderwidth 0 \
     -relief flat -highlightt 0
     wm overrideredirect .ddBlock 1
     if [info exists ::gPB(cur_mov_img)] {
      set w [expr [image width $::gPB(cur_mov_img)] + 1]
      set ::halfw [expr $w / 2]
      set h [expr [image height $::gPB(cur_mov_img)] + 0]
      set ::halfh [expr $h / 2]
      } else {
      set w 50
      set ::halfw 25
      set h 25
      set ::halfh 12
     }
     wm geom .ddBlock ${w}x${h}+[expr {$x - $::halfw}]+[expr {$y - $::halfh}]
     canvas .ddBlock.c -bg $paOption(sunken_bg) -relief sunken \
     -bd 2 -highlightt 0
     pack .ddBlock.c -fill both -expand yes -side top
     set img [UI_PB_blk_CreateIcon .ddBlock.c $icon_name $elem_text]
     $img add image -image [tix getimage pb_blank]
     $img config -relief flat -bg $paOption(sunken_bg)
     set image_addr [tix getimage $icon_name]
     .ddBlock.c create image $::halfw $::halfh -image $img
    }
    eventblock_up {
     toplevel .ddBlock -bg $paOption(focus) -borderwidth 2 \
     -relief raised -highlightt 0
     wm overrideredirect .ddBlock 1
     wm geom .ddBlock 174x25+[expr {$x - 88}]+[expr {$y - 12}]
     canvas .ddBlock.c -bg $paOption(focus) -relief flat \
     -bd 0 -highlightt 0
     pack .ddBlock.c -fill both -expand yes -side top
     set image_addr [tix getimage $icon_name]
     .ddBlock.c create image 85 10 -image $image_addr
     .ddBlock.c create text [expr {85 + $t_shift}] 10 \
     -text $elem_text -font $tixOption(font_sm)
    }
    addressblock_up {
     toplevel .ddBlock -bg $paOption(sunken_bg) -borderwidth 0 \
     -relief flat -highlightt 0
     wm overrideredirect .ddBlock 1
     if [info exists ::gPB(cur_mov_img)] {
      set w [expr [image width $::gPB(cur_mov_img)] + 0]
      set ::halfw [expr $w / 2]
      set h [expr [image height $::gPB(cur_mov_img)] + 0]
      set ::halfh [expr $h / 2]
      } else {
      set w 50
      set ::halfw 25
      set h 25
      set ::halfh 12
     }
     if {$::tcl_version == "8.0"} {
      set w [expr $w + 1]
     }
     wm geom .ddBlock ${w}x${h}+[expr {$x - $::halfw}]+[expr {$y - $::halfh}]
     canvas .ddBlock.c -bg $paOption(sunken_bg) -relief sunken \
     -bd 2 -highlightt 0
     pack .ddBlock.c -fill both -expand yes -side top
     set img [UI_PB_blk_CreateIcon .ddBlock.c $icon_name $elem_text]
     $img config -relief flat -bg $paOption(sunken_bg)
     $img add image -image [tix getimage $ops_nows_force]
     .ddBlock.c create image  $::halfw $::halfh -image $img
     if {$::tcl_version == "8.0"} {
      set ::halfw [expr $::halfw + 1]
     }
    }
    udeblock   {
     toplevel .ddBlock -borderwidth 2 \
     -relief raised -highlightt 0
     wm overrideredirect .ddBlock 1
    }
    udeitem    {
     toplevel .ddBlock -borderwidth 2 \
     -relief raised -highlightt 0
     wm overrideredirect .ddBlock 1
    }
   }
  }

#=======================================================================
proc UI_PB_mthd_MoveDDBlock {x y typeflag canvas_x canvas_y canvas_height canvas_width} {
  PB_disable_balloon Canvas
  if { ![winfo exists .ddBlock] } {
   return
  }
  switch  -exact -- $typeflag {
   eventblock {
    set rm [expr {$canvas_x + $canvas_width - 88}]
    set lm [expr {$canvas_x + 88}]
    set tm [expr {$canvas_y + 12}]
    set bm [expr {$canvas_y + $canvas_height - 12}]
    if [expr {$x >= $lm}]&&[expr {$x <= $rm}]&&[expr {$y >= $tm}]&&[expr {$y <= $bm}] {
     wm geom .ddBlock +[expr {$x - 88}]+[expr {$y - 12}]
    }
    if [expr {$x >= $lm}]&&[expr {$x <= $rm}]&&[expr {$y <= $tm}] {
     wm geom .ddBlock +[expr {$x - 88}]+[expr {$tm - 12}]
    }
    if [expr {$x >= $lm}]&&[expr {$x <= $rm}]&&[expr {$y >= $bm}] {
     wm geom .ddBlock +[expr {$x - 88}]+[expr {$bm - 12}]
    }
    if [expr {$y >= $tm}]&&[expr {$y <= $bm}]&&[expr {$x <= $lm}] {
     wm geom .ddBlock +[expr {$lm - 88}]+[expr {$y - 12}]
    }
    if [expr {$y >= $tm}]&&[expr {$y <= $bm}]&&[expr {$x >= $rm}] {
     wm geom .ddBlock +[expr {$rm - 88}]+[expr {$y - 12}]
    }
   }
   addressblock {
    set rm [expr {$canvas_x + $canvas_width - $::halfw}]
    set lm [expr {$canvas_x + $::halfw}]
    set tm [expr {$canvas_y + $::halfh}]
    set bm [expr {$canvas_y + $canvas_height - $::halfh}]
    if [expr {$x >= $lm}]&&[expr {$x <= $rm}]&&[expr {$y >= $tm}]&&[expr {$y <= $bm}] {
     wm geom .ddBlock +[expr {$x - $::halfw}]+[expr {$y - $::halfh}]
    }
    if [expr {$x >= $lm}]&&[expr {$x <= $rm}]&&[expr {$y <= $tm}] {
     wm geom .ddBlock +[expr {$x - $::halfw}]+[expr {$tm - $::halfh}]
    }
    if [expr {$x >= $lm}]&&[expr {$x <= $rm}]&&[expr {$y >= $bm}] {
     wm geom .ddBlock +[expr {$x - $::halfw}]+[expr {$bm - $::halfh}]
    }
    if [expr {$y >= $tm}]&&[expr {$y <= $bm}]&&[expr {$x <= $lm}] {
     wm geom .ddBlock +[expr {$lm - $::halfw}]+[expr {$y - $::halfh}]
    }
    if [expr {$y >= $tm}]&&[expr {$y <= $bm}]&&[expr {$x >= $rm}] {
     wm geom .ddBlock +[expr {$rm - $::halfw}]+[expr {$y - $::halfh}]
    }
   }
   eventblock_up {
    set rm [expr {$canvas_x + $canvas_width - 88}]
    set lm [expr {$canvas_x + 88}]
    set tm [expr {$canvas_y + 12}]
    set bm [expr {$canvas_y + $canvas_height - 12}]
    if [expr {$x >= $lm}]&&[expr {$x <= $rm}]&&[expr {$y >= $tm}]&&[expr {$y <= $bm}] {
     wm geom .ddBlock +[expr {$x - 88}]+[expr {$y - 12}]
    }
    if [expr {$x >= $lm}]&&[expr {$x <= $rm}]&&[expr {$y <= $tm}] {
     wm geom .ddBlock +[expr {$x - 88}]+[expr {$tm - 12}]
    }
    if [expr {$x >= $lm}]&&[expr {$x <= $rm}]&&[expr {$y >= $bm}] {
     wm geom .ddBlock +[expr {$x - 88}]+[expr {$bm - 12}]
    }
    if [expr {$y >= $tm}]&&[expr {$y <= $bm}]&&[expr {$x <= $lm}] {
     wm geom .ddBlock +[expr {$lm - 88}]+[expr {$y - 12}]
    }
    if [expr {$y >= $tm}]&&[expr {$y <= $bm}]&&[expr {$x >= $rm}] {
     wm geom .ddBlock +[expr {$rm - 88}]+[expr {$y - 12}]
    }
   }
   addressblock_up {
    set rm [expr {$canvas_x + $canvas_width - $::halfw}]
    set lm [expr {$canvas_x + $::halfw}]
    set tm [expr {$canvas_y + $::halfh}]
    set bm [expr {$canvas_y + $canvas_height - $::halfh}]
    if [expr {$x >= $lm}]&&[expr {$x <= $rm}]&&[expr {$y >= $tm}]&&[expr {$y <= $bm}] {
     wm geom .ddBlock +[expr {$x - $::halfw}]+[expr {$y - $::halfh}]
    }
    if [expr {$x >= $lm}]&&[expr {$x <= $rm}]&&[expr {$y <= $tm}] {
     wm geom .ddBlock +[expr {$x - $::halfw}]+[expr {$tm - $::halfh}]
    }
    if [expr {$x >= $lm}]&&[expr {$x <= $rm}]&&[expr {$y >= $bm}] {
     wm geom .ddBlock +[expr {$x - $::halfw}]+[expr {$bm - $::halfh}]
    }
    if [expr {$y >= $tm}]&&[expr {$y <= $bm}]&&[expr {$x <= $lm}] {
     wm geom .ddBlock +[expr {$lm - $::halfw}]+[expr {$y - $::halfh}]
    }
    if [expr {$y >= $tm}]&&[expr {$y <= $bm}]&&[expr {$x >= $rm}] {
     wm geom .ddBlock +[expr {$rm - $::halfw}]+[expr {$y - $::halfh}]
    }
   }
   udeblock       {
    set ww [winfo width .ddBlock]
    set wh [winfo height .ddBlock]
    set sx [expr {$ww / 2}]
    set sy [expr {$wh / 2}]
    set rm [expr {$canvas_x + $canvas_width - $sx}]
    set lm [expr {$canvas_x + $sx}]
    set tm [expr {$canvas_y + $sy}]
    set bm [expr {$canvas_y + $canvas_height - $sy}]
    if [expr {$x >= $lm}]&&[expr {$x <= $rm}]&&[expr {$y >= $tm}]&&[expr {$y <= $bm}] {
     wm geom .ddBlock +[expr {$x - $sx}]+[expr {$y - $sy}]
    }
    if [expr {$x >= $lm}]&&[expr {$x <= $rm}]&&[expr {$y <= $tm}] {
     wm geom .ddBlock +[expr {$x - $sx}]+[expr {$tm - $sy}]
    }
    if [expr {$x >= $lm}]&&[expr {$x <= $rm}]&&[expr {$y >= $bm}] {
     wm geom .ddBlock +[expr {$x - $sx}]+[expr {$bm - $sy}]
    }
    if [expr {$y >= $tm}]&&[expr {$y <= $bm}]&&[expr {$x <= $lm}] {
     wm geom .ddBlock +[expr {$lm - $sx}]+[expr {$y - $sy}]
    }
    if [expr {$y >= $tm}]&&[expr {$y <= $bm}]&&[expr {$x >= $rm}] {
     wm geom .ddBlock +[expr {$rm - $sx}]+[expr {$y - $sy}]
    }
   }
   udeitem        {
    set rm [expr {$canvas_x + $canvas_width}]
    set lm [expr {$canvas_x}]
    set tm [expr {$canvas_y}]
    set bm [expr {$canvas_y + $canvas_height}]
    if [expr {$x >= $lm}]&&[expr {$x <= $rm}]&&[expr {$y >= $tm}]&&[expr {$y <= $bm}] {
     wm geom .ddBlock +[expr {$x}]+[expr {$y}]
    }
    if [expr {$x >= $lm}]&&[expr {$x <= $rm}]&&[expr {$y <= $tm}] {
     wm geom .ddBlock +[expr {$x}]+[expr {$tm}]
    }
    if [expr {$x >= $lm}]&&[expr {$x <= $rm}]&&[expr {$y >= $bm}] {
     wm geom .ddBlock +[expr {$x}]+[expr {$bm}]
    }
    if [expr {$y >= $tm}]&&[expr {$y <= $bm}]&&[expr {$x <= $lm}] {
     wm geom .ddBlock +[expr {$lm}]+[expr {$y}]
    }
    if [expr {$y >= $tm}]&&[expr {$y <= $bm}]&&[expr {$x >= $rm}] {
     wm geom .ddBlock +[expr {$rm}]+[expr {$y}]
    }
   }
  }
 }

#=======================================================================
proc UI_PB_mthd_DestroyDDBlock { } {
  PB_enable_balloon Canvas
  destroy .ddBlock
  if [info exists ::halfh] {
   unset ::halfh
   unset ::halfw
  }
  if [info exists ::gPB(cur_mov_img)] {
   unset ::gPB(cur_mov_img)
  }
 }

#=======================================================================
proc UI_PB_mthd_SetPopupOptions {PAGE_OBJ MENU OPTIONS_LIST \
  CALLBACK BIND_WIDGET} {
  upvar $PAGE_OBJ page_obj
  upvar $MENU menu1
  upvar $OPTIONS_LIST options_list
  upvar $CALLBACK callback
  upvar $BIND_WIDGET bind_widget
  global gPB
  set count 1
  foreach ELEMENT $options_list \
  {
   if {$ELEMENT == "Help"} \
   {
    $menu1 add command -label $ELEMENT
    } elseif {$ELEMENT == "gPB(address,none_popup,Label)"} \
   {
    $menu1 add command -label [set $ELEMENT] \
    -command "$callback $page_obj $bind_widget \"\""
   } else \
   {
    if {$count == 1} \
    {
     $menu1 add command -label $ELEMENT -columnbreak 1 \
     -command "$callback $page_obj $bind_widget $ELEMENT"
    } else \
    {
     $menu1 add command -label $ELEMENT \
     -command "$callback $page_obj $bind_widget $ELEMENT"
    }
   }
   if {$count == 9} \
   {
    set count 0
   }
   incr count
  }
 }

#=======================================================================
proc UI_PB_mthd_CreateLblPopEntry { page_obj frame var LABEL_VAR OPTIONS_LIST CALLBACK args} {
  upvar $CALLBACK callback
  upvar $LABEL_VAR label_var
  upvar $OPTIONS_LIST options_list
  global mom_sys_arr mom_kin_var mom_sim_arr gPB
  global tixOption paOption gpb_addr_var
  if { [string match "\$mom_kin*" $var] } \
  {
   set gb_arr "mom_kin_var"
   } elseif {[string match "\$mom_sim*" $var]} \
  {
   set gb_arr "mom_sim_arr"
   } elseif {[string match "gPB" $var]} \
  {
   set gb_arr "gPB"
   set ind [expr [string last "\)" $var] - 1]
   set var [string range $var 4 ind]
  } else \
  {
   set gb_arr "mom_sys_arr"
  }
  label $frame.lbl -textvariable $label_var -padx 3 -pady 2\
  -fg $paOption(special_fg) -bg $paOption(special_bg) -font $tixOption(bold_font)
  if { [string match "null" $var] || [string match "" $var] } {
   set ent [entry $frame.ent -width 15 -relief sunken -bd 2 \
   -fg $paOption(special_fg) -bg $paOption(header_bg)]
   } else {
   set ent [entry $frame.ent -width 15 -relief sunken -bd 2 \
   -fg $paOption(special_fg) -bg $paOption(header_bg) -textvariable ${gb_arr}($var)]
  }
  pack $frame.lbl -side left  -padx 5 -pady 6
  pack $frame.ent -side right -padx 5 -pady 6
  set menu [menu $frame.pop -tearoff 0]
  bind $ent "focus %W"
  bind $ent <3> "tk_popup $menu %X %Y"
  set bind_widget $ent
  UI_PB_mthd_SetPopupOptions page_obj menu options_list callback bind_widget
 }
