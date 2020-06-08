#26

#=======================================================================
proc UI_PB_mach_DisableWindow { PAGE_OBJ args } {
  upvar $PAGE_OBJ page_obj
  global machData
  global gPB
  set tree $Page::($page_obj,tree)
  set h [$tree subwidget hlist]
  set sty_n  $gPB(font_style_normal)
  set sty_ng $gPB(font_style_normal_gray)
  $h entryconfig 0.0 -state disabled -style $sty_ng
  switch $machData(1) \
  {
   "4-Axis" \
   {
    $h entryconfig 0.1 -state disabled -style $sty_ng
   }
   "5-Axis" \
   {
    $h entryconfig 0.1 -state disabled -style $sty_ng
    $h entryconfig 0.2 -state disabled -style $sty_ng
   }
  }
  set anc [$h info anchor]
  $h entryconfig $anc -state normal -style $sty_n
 }

#=======================================================================
proc UI_PB_mach_EnableWindow { PAGE_OBJ args } {
  upvar $PAGE_OBJ page_obj
  global machData
  global gPB
  set tree $Page::($page_obj,tree)
  set h [$tree subwidget hlist]
  set sty_n  $gPB(font_style_normal)
  set sty_ng $gPB(font_style_normal_gray)
  $h entryconfig 0.0 -state normal -style $sty_n
  switch $machData(1) \
  {
   "4-Axis" \
   {
    $h entryconfig 0.1 -state normal -style $sty_n
   }
   "5-Axis" \
   {
    $h entryconfig 0.1 -state normal -style $sty_n
    $h entryconfig 0.2 -state normal -style $sty_n
   }
  }
 }

#=======================================================================
proc UI_PB_MachineTool { book_id mctl_page_obj } {
  global paOption
  global machData
  set Page::($mctl_page_obj,page_id) \
  [$book_id subwidget $Page::($mctl_page_obj,page_name)]
  set machData(0) "Mill"
  set machData(1) 3-Axis
  set machData(2) Vertical
  set machData(3) "pb_mill_3axis.gif"
  set machData(4) "Milimeter(mm)"
  set machData(5) empty
  set machData(6) empty
  set machData(7) "gPB(machine,gen,Label)"
  set machData(8) "gPB(machine,axis,fourth,Label)"
  set machData(9) "gPB(machine,axis,fifth,Label)"
  UI_PB_mach_AddMachParam mctl_page_obj
 }

#=======================================================================
proc UI_PB_mach_SetMachKinvars { MACH_PAGE_OBJ } {
  upvar $MACH_PAGE_OBJ mach_page_obj
  global machData
  set mill_general_param {"mom_kin_post_data_unit" "mom_kin_output_unit" \
   "mom_kin_x_axis_limit" "mom_kin_y_axis_limit" \
   "mom_kin_z_axis_limit" "\$mom_sys_home_pos(0)" \
   "\$mom_sys_home_pos(1)" "\$mom_sys_home_pos(2)" \
   "mom_kin_machine_resolution" "mom_kin_rapid_feed_rate" \
  "\$cir_record_output"}
  set lathe_general_param {"mom_kin_post_data_unit" "mom_kin_output_unit" \
   "mom_kin_x_axis_limit" "mom_kin_z_axis_limit"
   "\$mom_sys_home_pos(0)" "\$mom_sys_home_pos(2)" \
   "mom_kin_machine_resolution" "mom_kin_rapid_feed_rate" \
   "\$cir_record_output" "\$xaxis_dia_prog" "\$xaxis_mirror" \
  "\$zaxis_mirror" "\$lathe_output_method"}
  set mill_4th_param {"mom_kin_4th_axis_min_incr" \
   "mom_kin_4th_axis_max_limit" \
   "mom_kin_4th_axis_min_limit" \
   "mom_kin_4th_axis_rotation" \
   "mom_kin_4th_axis_center_offset(0)" \
   "mom_kin_4th_axis_center_offset(1)" \
   "mom_kin_4th_axis_center_offset(2)" \
   "mom_kin_4th_axis_ang_offset" \
   "mom_kin_4th_axis_plane" \
   "mom_kin_4th_axis_direction" \
   "mom_kin_pivot_guage_offset" \
   "mom_kin_4th_axis_leader" \
   "mom_kin_max_dpm" \
   "mom_kin_linearization_flag" \
   "mom_kin_linearization_tol" \
  "mom_kin_4th_axis_limit_action"}
  set lathe_4th_param {"mom_kin_4th_axis_min_incr" \
   "mom_kin_4th_axis_max_limit" \
   "mom_kin_4th_axis_min_limit" \
   "mom_kin_4th_axis_rotation" \
   "mom_kin_4th_axis_center_offset(0)" \
   "mom_kin_4th_axis_center_offset(1)" \
   "mom_kin_4th_axis_center_offset(2)" \
   "mom_kin_4th_axis_ang_offset" \
   "mom_kin_4th_axis_direction" \
   "mom_kin_4th_axis_plane" \
   "mom_kin_pivot_guage_offset" \
   "mom_kin_4th_axis_leader" \
   "mom_kin_max_dpm" \
   "mom_kin_linearization_flag" \
   "mom_kin_linearization_tol" \
  "mom_kin_4th_axis_limit_action"}
  set mill_5th_param {"mom_kin_5th_axis_min_incr" \
   "mom_kin_5th_axis_max_limit" \
   "mom_kin_5th_axis_min_limit" \
   "mom_kin_5th_axis_rotation" \
   "mom_kin_5th_axis_center_offset(0)" \
   "mom_kin_5th_axis_center_offset(1)" \
   "mom_kin_5th_axis_center_offset(2)" \
   "mom_kin_5th_axis_ang_offset" \
   "mom_kin_5th_axis_direction" \
   "mom_kin_pivot_guage_offset" \
   "mom_kin_max_dpm" "mom_kin_linearization_flag" \
   "mom_kin_linearization_tol" \
  "mom_kin_5th_axis_limit_action"}
  switch $machData(0) \
  {
   "Mill" \
   {
    switch $machData(1) \
    {
     "3-Axis" {
      set Page::($mach_page_obj,general_param) $mill_general_param
     }
     "4-Axis" {
      set Page::($mach_page_obj,general_param) $mill_general_param
      set Page::($mach_page_obj,axis_4th_param) $mill_4th_param
     }
     "5-Axis" {
      set Page::($mach_page_obj,general_param)  $mill_general_param
      set Page::($mach_page_obj,axis_4th_param) $mill_4th_param
      set Page::($mach_page_obj,axis_5th_param) $mill_5th_param
     }
    }
   }
   "Lathe" \
   {
    switch $machData(1) \
    {
     "2-Axis" {
      set Page::($mach_page_obj,general_param) $lathe_general_param
     }
     "4-Axis" {
      set Page::($mach_page_obj,general_param) $lathe_general_param
      set Page::($mach_page_obj,axis_4th_param) $lathe_4_param
     }
    }
   }
  }
 }

#=======================================================================
proc UI_PB_mach_AddMachParam { PAGE_OBJ } {
  upvar $PAGE_OBJ page_obj
  global tixOption
  global paOption
  global machData
  global axisoption
  global gPB
  Page::CreatePane $page_obj
  set left_pane_id $Page::($page_obj,left_pane_id)
  set but [frame $left_pane_id.f]
  set disp [button $but.disp -text "$gPB(machine,display,Label)" \
  -bg $paOption(app_butt_bg) -command "UI_PB_mach_AddMachImage"]
  pack $disp -expand yes
  pack $but -side top -fill x -padx 7
  Page::CreateTree $page_obj
  UI_PB_mach_BuildMachTreeList page_obj
  UI_PB_mach_SetMachKinvars page_obj
  set right_pane $Page::($page_obj,canvas_frame)
  switch $machData(0) \
  {
   "Mill" \
   {
    set machData(gen) [frame $right_pane.gen -relief flat -bd 0]
    UI_PB_mach_MillGeneralParams page_obj $machData(gen) \
    "general_param"
    switch $machData(1) \
    {
     "4-Axis" \
     {
      set machData(4th) [frame $right_pane.4th -relief flat -bd 0]
      UI_PB_mach_AddRotaryAxisParams page_obj $machData(4th) \
      "axis_4th_param" 4
     }
     "5-Axis" \
     {
      set machData(4th) [frame $right_pane.4th -relief flat -bd 0]
      set machData(5th) [frame $right_pane.5th -relief flat -bd 0]
      UI_PB_mach_AddRotaryAxisParams page_obj $machData(4th) \
      "axis_4th_param" 4
      UI_PB_mach_AddRotaryAxisParams page_obj $machData(5th) \
      "axis_5th_param" 5
     }
    }
   }
   "Lathe" \
   {
    set machData(gen) [frame $right_pane.gen -relief flat -bd 0]
    UI_PB_mach_LatheGeneralParams page_obj $machData(gen) "general_param"
    switch $machData(1) \
    {
     "4-Axis" \
     {
      set machData(4th) [frame $right_pane.4th -relief flat -bd 0]
      UI_PB_mach_AddRotaryAxisParams page_obj $machData(4th) \
      "axis_4th_param" 4
     }
    }
   }
  }
 }

#=======================================================================
proc UI_PB_mach_BuildMachTreeList { PAGE_OBJ } {
  upvar $PAGE_OBJ page_obj
  global machData
  global paOption tixOption
  set tree $Page::($page_obj,tree)
  set h [$tree subwidget hlist]
  $h config -bg $paOption(tree_bg)
  uplevel #0 set TRANSPARENT_GIF_COLOR [$h cget -bg]
  set mach_comp [tix getimage pb_mach_kin]
  UI_PB_mach_SetMachTreeTitle
  global gPB
  set style  $gPB(font_style_bold)
  set style1 $gPB(font_style_normal)
  $h add 0 -itemtype imagetext -text "$machData(1) $machData(0)" \
  -image $paOption(folder) -style $style -state disabled
  $h add 0.0  -itemtype imagetext -text [set $machData(7)] -image $mach_comp \
  -style $style1
  switch $machData(1) \
  {
   "4-Axis" \
   {
    $h add 0.1 -itemtype imagetext -text [set $machData(8)] \
    -image $mach_comp -style $style1
   }
   "5-Axis" \
   {
    $h add 0.1 -itemtype imagetext -text [set $machData(8)] \
    -image $mach_comp -style $style1
    $h add 0.2 -itemtype imagetext -text [set $machData(9)] \
    -image $mach_comp -style $style1
   }
   default {}
  }
  $h anchor set 0.0
  $h selection set 0.0
  $tree config \
  -browsecmd "UI_PB_mach_MachDisplayParams $page_obj machData"
 }

#=======================================================================
proc UI_PB_mach_SetMachTreeTitle {} {
  global mach_type axisoption machData
  set machData(0) $mach_type
  switch -- $mach_type \
  {
   "Mill" {
    switch -- $axisoption \
    {
     "3"  {
      set machData(1) "3-Axis"
     }
     "4T" -
     "4H" {
      set machData(1) "4-Axis"
     }
     "5HH" -
     "5TT" -
     "5HT" {
      set machData(1) "5-Axis"
     }
    }
   }
   "Lathe" {
    switch -- $axisoption \
    {
     "2" {
      set machData(1) "2-Axis"
     }
     "4" {
      set machData(1) "2-Axis"
     }
    }
   }
  }
 }

#=======================================================================
proc UI_PB_mach_MachDisplayParams { page_obj MACHDATA args} {
  upvar $MACHDATA machData
  set tree $Page::($page_obj,tree)
  set HLIST [$tree subwidget hlist]
  set ent   [$HLIST info anchor]
  set indx  [string range $ent 2 [string length $ent]]
  if { [info exists machData(5th)] && \
  [winfo exists $machData(5th)]} \
  {
   pack forget $machData(5th)
  }
  if { [info exists machData(4th)] && \
  [winfo exists $machData(4th)]} \
  {
   pack forget $machData(4th)
  }
  pack forget $machData(gen)
  switch $machData([expr $indx + 7])\
  {
   "gPB(machine,gen,Label)" \
   {
    pack $machData(gen) -expand yes -fill both
   }
   "gPB(machine,axis,fourth,Label)" \
   {
    pack $machData(4th) -expand yes -fill both
   }
   "gPB(machine,axis,fifth,Label)" \
   {
    pack $machData(5th) -expand yes -fill both
   }
  }
 }

#=======================================================================
proc UI_PB_mach_MillGeneralParams { PAGE_OBJ gen_frm axis_param } {
  upvar $PAGE_OBJ page_obj
  global tixOption
  global mom_kin_var
  global mom_sys_arr
  global gPB
  UI_PB_mthd_CreateScrollWindow $gen_frm millgen top_win
  set top_frm [frame $top_win.f]
  pack $top_frm -side top -pady 40 -fill both
  switch $mom_kin_var(mom_kin_output_unit) \
  {
   "IN"    { set output_unit "Inch" }
   "MM"    { set output_unit "Metric" }
   default { set output_unit $mom_kin_var(mom_kin_output_unit) }
  }
  Page::CreateLblFrame $top_frm limit  "$gPB(machine,gen,travel_limit,Label)"
  Page::CreateLblFrame $top_frm home   "$gPB(machine,gen,home_pos,Label)"
  Page::CreateLblFrame $top_frm res    "$gPB(machine,gen,step_size,Label)"
  Page::CreateLblFrame $top_frm trav   "$gPB(machine,gen,traverse_feed,Label)"
  Page::CreateLblFrame $top_frm circ   "$gPB(machine,gen,circle_record,Label)"
  set fl [$top_frm.limit subwidget frame]
  set fh [$top_frm.home subwidget frame]
  set fr [$top_frm.res subwidget frame]
  set ft [$top_frm.trav subwidget frame]
  set fc [$top_frm.circ subwidget frame]
  set pf [frame $top_frm.pf -bg royalBlue -relief solid -bd 1]
  label $pf.postunit -text "$gPB(machine,gen,out_unit,Label) $output_unit" \
  -font $tixOption(bold_font) -fg white -bg royalBlue
  pack $pf.postunit -pady 10
  set x_frm [frame $fl.xfrm]
  Page::CreateLblEntry f mom_kin_x_axis_limit $x_frm x \
  "$gPB(machine,gen,travel_limit,x,Label)"
  pack $x_frm -fill x
  set y_frm [frame $fl.yfrm]
  Page::CreateLblEntry f mom_kin_y_axis_limit $y_frm y \
  "$gPB(machine,gen,travel_limit,y,Label)"
  pack $y_frm -fill x
  set z_frm [frame $fl.zfrm]
  Page::CreateLblEntry f mom_kin_z_axis_limit $z_frm z \
  "$gPB(machine,gen,travel_limit,z,Label)"
  pack $z_frm -fill x
  set x_frm [frame $fh.xhom]
  Page::CreateLblEntry f \$mom_sys_home_pos(0) $x_frm x \
  "$gPB(machine,gen,home_pos,x,Label)"
  pack $x_frm -fill x
  set y_frm [frame $fh.yhom]
  Page::CreateLblEntry f \$mom_sys_home_pos(1) $y_frm y \
  "$gPB(machine,gen,home_pos,y,Label)"
  pack $y_frm -fill x
  set z_frm [frame $fh.zhom]
  Page::CreateLblEntry f \$mom_sys_home_pos(2) $z_frm z \
  "$gPB(machine,gen,home_pos,z,Label)"
  pack $z_frm -fill x
  set res [frame $fr.res]
  Page::CreateLblEntry f mom_kin_machine_resolution $res min \
  "$gPB(machine,gen,step_size,min,Label)"
  pack $res -fill x
  set max_f [frame $ft.res]
  Page::CreateLblEntry f mom_kin_rapid_feed_rate $max_f max \
  "$gPB(machine,gen,traverse_feed,max,Label)"
  pack $max_f -fill x
  radiobutton $fc.yes -text "$gPB(machine,gen,circle_record,yes,Label)" \
  -variable mom_sys_arr(\$cir_record_output)\
  -value YES -command "UI_PB_mach_SetCirKinVar"
  radiobutton $fc.no  -text "$gPB(machine,gen,circle_record,no,Label)" \
  -variable mom_sys_arr(\$cir_record_output)\
  -value NO -command "UI_PB_mach_SetCirKinVar"
  pack $fc.yes -side left  -padx 15 -pady 5
  pack $fc.no -side right -padx 15 -pady 5
  grid $pf -row 0 -column 0 -padx 10 -pady 20 -sticky ew
  grid $top_frm.circ -row 0 -column 1 -padx 5 -pady 10 -sticky we
  grid $top_frm.limit $top_frm.home -padx 5  -pady 15 -sticky we
  grid $top_frm.res $top_frm.trav -padx 5  -pady 15 -sticky we
  set bot_frm [frame $gen_frm.ff]
  pack $bot_frm -side bottom -fill x
  UI_PB_mach_AddActionButtons page_obj $bot_frm $axis_param
 }

#=======================================================================
proc UI_PB_mach_LatheGeneralParams { PAGE_OBJ gen_frm axis_param } {
  upvar $PAGE_OBJ page_obj
  global tixOption
  global mom_sys_arr
  global mom_kin_var
  global gPB
  switch $mom_kin_var(mom_kin_output_unit) \
  {
   "IN"    { set output_unit "Inch" }
   "MM"    { set output_unit "Metric" }
   default { set output_unit $mom_kin_var(mom_kin_output_unit) }
  }
  UI_PB_mthd_CreateScrollWindow $gen_frm lathegen top_win
  set top_frm [frame $top_win.f]
  pack $top_frm -side top -pady 20 -fill both -expand yes
  Page::CreateLblFrame $top_frm limit  "$gPB(machine,gen,travel_limit,Label)"
  Page::CreateLblFrame $top_frm home   "$gPB(machine,gen,home_pos,Label)"
  Page::CreateLblFrame $top_frm res    "$gPB(machine,gen,step_size,Label)"
  Page::CreateLblFrame $top_frm trav   "$gPB(machine,gen,traverse_feed,Label)"
  Page::CreateLblFrame $top_frm circ   "$gPB(machine,gen,circle_record,Label)"
  Page::CreateLblFrame $top_frm turret "$gPB(machine,gen,turret,Label)"
  Page::CreateLblFrame $top_frm multi  "$gPB(machine,gen,axis_multi,Label)"
  Page::CreateLblFrame $top_frm output "$gPB(machine,gen,output,Label)"
  set fl [$top_frm.limit subwidget frame]
  set fh [$top_frm.home subwidget frame]
  set fr [$top_frm.res subwidget frame]
  set ft [$top_frm.trav subwidget frame]
  set fc [$top_frm.circ subwidget frame]
  set fmult [$top_frm.multi subwidget frame]
  set ftur [$top_frm.turret subwidget frame]
  set fout [$top_frm.output subwidget frame]
  set pf [frame $top_frm.pf -bg royalBlue -relief solid -bd 1]
  label $pf.postunit -text "$gPB(machine,gen,out_unit,Label) $output_unit" \
  -font $tixOption(bold_font) -fg white -bg royalBlue
  pack $pf.postunit -pady 10
  set x_frm [frame $fl.xfrm]
  Page::CreateLblEntry f mom_kin_x_axis_limit $x_frm x \
  "$gPB(machine,gen,travel_limit,x,Label)"
  pack $x_frm -fill x
  set z_frm [frame $fl.zfrm]
  Page::CreateLblEntry f mom_kin_z_axis_limit $z_frm z \
  "$gPB(machine,gen,travel_limit,z,Label)"
  pack $z_frm -fill x
  set x_frm [frame $fh.xhom]
  Page::CreateLblEntry f \$mom_sys_home_pos(0) $x_frm x \
  "$gPB(machine,gen,home_pos,x,Label)"
  pack $x_frm -fill x
  set z_frm [frame $fh.zhom]
  Page::CreateLblEntry f \$mom_sys_home_pos(2) $z_frm z \
  "$gPB(machine,gen,home_pos,z,Label)"
  pack $z_frm -fill x
  set res [frame $fr.res]
  Page::CreateLblEntry f mom_kin_machine_resolution $res min \
  "$gPB(machine,gen,step_size,min,Label)"
  pack $res -fill x
  set max_f [frame $ft.res]
  Page::CreateLblEntry f mom_kin_rapid_feed_rate $max_f max \
  "$gPB(machine,gen,traverse_feed,max,Label)"
  pack $max_f -fill x
  radiobutton $fc.yes -text "$gPB(machine,gen,circle_record,yes,Label)" \
  -variable mom_sys_arr(\$cir_record_output)\
  -value YES -command "UI_PB_mach_SetCirKinVar"
  radiobutton $fc.no  -text "$gPB(machine,gen,circle_record,no,Label)" \
  -variable mom_sys_arr(\$cir_record_output)\
  -value NO -command "UI_PB_mach_SetCirKinVar"
  pack $fc.yes -side left  -padx 15 -pady 5
  pack $fc.no -side right -padx 15 -pady 5
  checkbutton $fmult.dpg -text "$gPB(machine,gen,axis_multi,dia,Label)" \
  -variable mom_sys_arr(\$xaxis_dia_prog) \
  -relief flat -bd 2 -anchor w
  checkbutton $fmult.xmirr -text "$gPB(machine,gen,axis_multi,x,Label)" \
  -variable mom_sys_arr(\$xaxis_mirror) \
  -relief flat -bd 2 -anchor w
  checkbutton $fmult.zmirr -text "$gPB(machine,gen,axis_multi,z,Label)" \
  -variable mom_sys_arr(\$zaxis_mirror) \
  -relief flat -bd 2 -anchor w
  pack $fmult.dpg $fmult.xmirr $fmult.zmirr -padx 3 -pady 5 -fill both
  set tur_no [frame $ftur.no]
  radiobutton $tur_no.one -text "$gPB(machine,gen,turret,one,Label)" \
  -font $tixOption(bold_font) \
  -variable mom_sys_arr(\$no_of_turrets) -value 1 \
  -command "UI_PB_mach_SecHeadParam $ftur"
  radiobutton $tur_no.two  -text "$gPB(machine,gen,turret,two,Label)" \
  -font $tixOption(bold_font) \
  -variable mom_sys_arr(\$no_of_turrets) -value 2 \
  -command "UI_PB_mach_SecHeadParam $ftur"
  pack $tur_no.one -side left  -padx 15 -pady 5
  pack $tur_no.two -side right -padx 15 -pady 5
  grid $tur_no -row 0 -column 0
  set bb [tixButtonBox $ftur.bb -orientation horizontal]
  $bb config -relief sunken -bd 1 -bg royalBlue -pady 5
  $bb add spec -text "$gPB(machine,gen,turret,conf,Label)" -width 20
  grid $bb -row 1 -column 0
  set b [$bb subwidget spec]
  $b config -command "UI_PB_mach_LatheTurretConfig $page_obj"
  radiobutton $fout.tip -text "$gPB(machine,gen,output,tool_tip,Label)" \
  -font $tixOption(bold_font) \
  -variable mom_sys_arr(\$lathe_output_method) -value "TOOL_TIP"  \
  -command "UI_PB_mach_LatheOutputMethod"
  radiobutton $fout.turret -text "$gPB(machine,gen,output,turret_ref,Label)" \
  -font $tixOption(bold_font) \
  -variable mom_sys_arr(\$lathe_output_method) \
  -value "TURRET_REF" -command "UI_PB_mach_LatheOutputMethod"
  pack $fout.tip -side left  -padx 15 -pady 5
  pack $fout.turret -side right -padx 15 -pady 5
  grid $pf -row 0 -column 0 -padx 10 -pady 20 -sticky ew
  grid $top_frm.circ -row 0 -column 1 -padx 5 -pady 10 -sticky we
  grid $top_frm.limit $top_frm.home -padx 5  -pady 15 -sticky news
  grid $top_frm.res $top_frm.trav -padx 5  -pady 15 -sticky news
  grid $top_frm.multi $top_frm.turret -padx 5  -pady 15 -sticky news
  grid $top_frm.output -padx 5 -pady 15 -sticky news
  set bot_frm [frame $gen_frm.ff]
  pack $bot_frm -side bottom -fill x
  UI_PB_mach_AddActionButtons page_obj $bot_frm $axis_param
  UI_PB_mach_SecHeadParam $ftur
 }

#=======================================================================
proc UI_PB_mach_LatheTurretConfig { page_obj } {
  global gPB
  set canvas_frame $Page::($page_obj,canvas_frame)
  set w $canvas_frame.turconf
  toplevel $w
  set toplevel_index [llength $gPB(toplevel_list)]
  set win_index [expr $toplevel_index + 1]
  set gPB(toplevel_disable_$win_index) 1
  UI_PB_com_CreateTransientWindow $w \
  "$gPB(machine,gen,turret,conf_trans,Label)" "+500+300" \
  "UI_PB_mach_DisableMachPageWidgets $page_obj" "" \
  "UI_PB_mach_ActivateMachPageWidgets $page_obj $win_index"
  set page_frm [frame $w.f1 -relief sunken -bd 1]
  pack $page_frm -fill both -expand yes -padx 6 -pady 5
  set head_opt_list {"FRONT" "REAR" "RIGHT" "LEFT" "SIDE" "SADDLE"}
  Page::CreateLblFrame $page_frm prim "$gPB(machine,gen,turret,prim,Label)"
  set prim_head [$page_frm.prim subwidget frame]
  Page::CreateOptionalMenu \$primary_head $prim_head phed \
  $head_opt_list "$gPB(machine,gen,turret,designation,Label)"
  Page::CreateLblFrame $page_frm sechead "$gPB(machine,gen,turret,sec,Label)"
  set tur_head [$page_frm.sechead subwidget frame]
  set sec_head [frame $tur_head.secd]
  Page::CreateOptionalMenu \$secondary_head $sec_head shed \
  $head_opt_list "$gPB(machine,gen,turret,designation,Label)"
  pack $sec_head -fill x
  set xof_frm [frame $tur_head.xof]
  Page::CreateLblEntry f mom_kin_ind_to_dependent_head_x $xof_frm \
  x "$gPB(machine,gen,turret,xoff,Label)"
  pack $xof_frm -fill x
  set zof_frm [frame $tur_head.zof]
  Page::CreateLblEntry f mom_kin_ind_to_dependent_head_z $zof_frm \
  z "$gPB(machine,gen,turret,zoff,Label)"
  pack $zof_frm -fill x
  grid $page_frm.prim  -padx 15 -pady 15 -sticky news
  grid $page_frm.sechead  -padx 15 -pady 15 -sticky news
  set frame [frame $w.f2]
  pack $frame -side bottom -fill x -padx 3 -pady 4
  UI_PB_mach_LatheTurretActionButt $w $frame
 }

#=======================================================================
proc UI_PB_mach_LatheTurretActionButt { win frame } {
  set box1_frm [frame $frame.box1]
  set box2_frm [frame $frame.box2]
  tixForm $box1_frm -top 0 -left 3 -right %60 -padright 20
  tixForm $box2_frm -top 0 -left $box1_frm -padx 3 -right %100
  set first_list {"gPB(nav_button,default,Label)" \
  "gPB(nav_button,restore,Label)"}
  set second_list {"gPB(nav_button,cancel,Label)" \
  "gPB(nav_button,ok,Label)"}
  set cb_arr(gPB(nav_button,default,Label)) "UI_PB_mach_TurretConfDef_CB"
  set cb_arr(gPB(nav_button,restore,Label)) "UI_PB_mach_TurretConfRes_CB"
  set cb_arr(gPB(nav_button,cancel,Label)) \
  "UI_PB_mach_TurretConfCanc_CB $win"
  set cb_arr(gPB(nav_button,ok,Label))  \
  "UI_PB_mach_TurretConfOk_CB $win"
  UI_PB_com_CreateButtonBox $box1_frm first_list cb_arr
  UI_PB_com_CreateButtonBox $box2_frm second_list cb_arr
 }

#=======================================================================
proc UI_PB_mach_TurretConfOk_CB { win } {
  global mom_sys_arr
  global mom_kin_var
  global gPB
  if { $mom_sys_arr(\$primary_head) == $mom_sys_arr(\$secondary_head) } \
  {
   tk_messageBox -parent [UI_PB_com_AskActiveWindow] -type ok \
   -icon warning \
   -message "$gPB(machine,gen,lathe_turret,msg)"
   return
  }
  set mom_kin_var(mom_kin_independent_head) \
  $mom_sys_arr(\$primary_head)
  set mom_kin_var(mom_kin_dependent_head) \
  $mom_sys_arr(\$secondary_head)
  destroy $win
 }

#=======================================================================
proc UI_PB_mach_TurretConfCanc_CB { win } {
  UI_PB_mach_TurretConfRes_CB
  destroy $win
 }

#=======================================================================
proc UI_PB_mach_TurretConfDef_CB { } {
  global mom_kin_var
  global mom_sys_arr
  PB_int_RetDefKinVars def_mom_kin_var
  set mom_var(0) "\$primary_head"
  set mom_var(1) "\$secondary_head"
  PB_int_RetDefMOMVarValues mom_var mom_var_value
  set mom_sys_arr(\$primary_head) \
  $mom_var_value(\$primary_head)
  set mom_sys_arr(\$secondary_head) \
  $mom_var_value(\$secondary_head)
  set mom_kin_var(mom_kin_ind_to_dependent_head_x) \
  $def_mom_kin_var(mom_kin_ind_to_dependent_head_x)
  set mom_kin_var(mom_kin_ind_to_dependent_head_z) \
  $def_mom_kin_var(mom_kin_ind_to_dependent_head_z)
 }

#=======================================================================
proc UI_PB_mach_TurretConfRes_CB { } {
  global mom_kin_var
  global mom_sys_arr
  global rest_mom_kin_var
  global rest_mom_sys_arr
  set mom_sys_arr(\$primary_head) \
  $rest_mom_sys_arr(\$primary_head)
  set mom_sys_arr(\$secondary_head) \
  $rest_mom_sys_arr(\$secondary_head)
  set mom_kin_var(mom_kin_ind_to_dependent_head_x) \
  $rest_mom_kin_var(mom_kin_ind_to_dependent_head_x)
  set mom_kin_var(mom_kin_ind_to_dependent_head_z) \
  $rest_mom_kin_var(mom_kin_ind_to_dependent_head_z)
 }

#=======================================================================
proc UI_PB_mach_LatheOutputMethod { } {
  global gPB
  tk_messageBox -parent [UI_PB_com_AskActiveWindow] -type ok \
  -icon warning \
  -message "$gPB(machine,gen,turret_chg,msg)"
 }

#=======================================================================
proc UI_PB_mach_SecHeadParam { ftur } {
  global mom_sys_arr
  global mom_kin_var
  global gPB
  set config_but [$ftur.bb subwidget spec]
  switch $mom_sys_arr(\$no_of_turrets) \
  {
   1 {
    set mom_kin_var(mom_kin_independent_head) "NONE"
    set mom_kin_var(mom_kin_dependent_head) "NONE"
    $config_but config -state disabled
   }
   2 {
    $config_but config -state normal
   }
  }
 }

#=======================================================================
proc UI_PB_mach_SetCirKinVar { } {
  global mom_sys_arr
  global mom_kin_var
  switch $mom_sys_arr(\$cir_record_output) \
  {
   "YES" {
    set mom_kin_var(mom_kin_arc_output_mode) "FULL_CIRCLE"
   }
   "NO"  {
    set mom_kin_var(mom_kin_arc_output_mode) "LINEAR"
   }
  }
 }

#=======================================================================
proc UI_PB_mach_AddRotaryAxisParams { PAGE_OBJ frame_id axis_param n_axis} {
  upvar $PAGE_OBJ page_obj
  global tixOption
  global paOption
  global machData
  global mom_kin_var
  global gPB
  switch $n_axis \
  {
   4 {
    set axis_rotation       mom_kin_4th_axis_rotation
    set axis_max_limit      mom_kin_4th_axis_max_limit
    set axis_min_limit      mom_kin_4th_axis_min_limit
    set axis_min_incr       mom_kin_4th_axis_min_incr
    set axis_center_offset0 mom_kin_4th_axis_center_offset(0)
    set axis_center_offset1 mom_kin_4th_axis_center_offset(1)
    set axis_center_offset2 mom_kin_4th_axis_center_offset(2)
    set axis_ang_offset     mom_kin_4th_axis_ang_offset
    set axis_limit_action   mom_kin_4th_axis_limit_action
    set axis_pivot_offset   mom_kin_pivot_guage_offset
    set axis_max_dpm        mom_kin_max_dpm
    set axis_linear_tol     mom_kin_linearization_tol
    set axis_direction      mom_kin_4th_axis_direction
    set local_var_dir       \$4th_axis_direction
   }
   5 {
    set axis_min_incr       mom_kin_5th_axis_min_incr
    set axis_max_limit      mom_kin_5th_axis_max_limit
    set axis_min_limit      mom_kin_5th_axis_min_limit
    set axis_rotation       mom_kin_5th_axis_rotation
    set axis_center_offset0 mom_kin_5th_axis_center_offset(0)
    set axis_center_offset1 mom_kin_5th_axis_center_offset(1)
    set axis_center_offset2 mom_kin_5th_axis_center_offset(2)
    set axis_ang_offset     mom_kin_5th_axis_ang_offset
    set axis_limit_action   mom_kin_5th_axis_limit_action
    set axis_pivot_offset   mom_kin_pivot_guage_offset
    set axis_max_dpm        mom_kin_max_dpm
    set axis_linear_tol     mom_kin_linearization_tol
    set axis_direction      mom_kin_5th_axis_direction
    set local_var_dir       \$5th_axis_direction
   }
   default {}
  }
  UI_PB_mthd_CreateScrollWindow $frame_id axis top_win
  set f [frame $top_win.f]
  pack $f -side top -pady 40 -fill both
  tixLabelFrame $f.mach      -label "$gPB(machine,axis,rotary,Label)"
  tixLabelFrame $f.loffset   -label "$gPB(machine,axis,offset,Label)"
  tixLabelFrame $f.rotation  -label "$gPB(machine,axis,rotation,Label)"
  tixLabelFrame $f.direction -label "$gPB(machine,axis,direction,Label)"
  tixLabelFrame $f.combine   -label "$gPB(machine,axis,con_motion,Label)"
  tixLabelFrame $f.action    -label "$gPB(machine,axis,violation,Label)"
  tixLabelFrame $f.limits    -label "$gPB(machine,axis,limits,Label)"
  set fm [$f.mach subwidget frame]
  set fo [$f.loffset subwidget frame]
  set fr [$f.rotation subwidget frame]
  set fd [$f.direction subwidget frame]
  set fc [$f.combine subwidget frame]
  set fa [$f.action  subwidget frame]
  set fl [$f.limits subwidget frame]
  if {$n_axis == 4} \
  {
   switch $machData(1) \
   {
    "4-Axis" { UI_PB_mach_ConfigParms $fm 4TH_AXIS }
    "5-Axis" { UI_PB_mach_CreateRotaryAxisConfig $page_obj $fm }
   }
  } else \
  {
   UI_PB_mach_CreateRotaryAxisConfig $page_obj $fm
  }
  set min_frm [frame $f.resolution]
  Page::CreateLblEntry f $axis_min_incr $min_frm par \
  "$gPB(machine,axis,rotary_res,Label)"
  pack $min_frm -fill x
  set minlimit_frm [frame $fl.minlmt]
  Page::CreateLblEntry f $axis_min_limit $minlimit_frm par \
  "$gPB(machine,axis,limits,min,Label))"
  pack $minlimit_frm -fill x
  set maxlimit_frm [frame $fl.maxlmt]
  Page::CreateLblEntry f $axis_max_limit $maxlimit_frm par \
  "$gPB(machine,axis,limits,max,Label)"
  pack $maxlimit_frm -fill x
  radiobutton $fr.normal -text "$gPB(machine,axis,rotation,norm,Label)" \
  -width 13 -anchor w \
  -variable mom_kin_var($axis_rotation) -value standard
  radiobutton $fr.reverse -text "$gPB(machine,axis,rotation,rev,Label)" \
  -width 14 -anchor w \
  -variable mom_kin_var($axis_rotation) -value Reverse
  grid $fr.normal $fr.reverse -padx 5 -pady 16
  set dir_label ""
  set dir_opt_list [list "Magnitude Determines Direction" \
  "Sign Determines Direction"]
  Page::CreateOptionalMenu $local_var_dir $fd opt $dir_opt_list $dir_label
  $fd.opt config -command "UI_PB_mach_MapAxisDirection $axis_direction"
  set xoff_frm [frame $fo.xoff]
  Page::CreateLblEntry f $axis_center_offset0 $xoff_frm x \
  "$gPB(machine,axis,offset,x,Label)"
  pack $xoff_frm -fill x
  set yoff_frm [frame $fo.yoff]
  Page::CreateLblEntry f $axis_center_offset1 $yoff_frm y \
  "$gPB(machine,axis,offset,y,Label)"
  pack $yoff_frm -fill x
  set zoff_frm [frame $fo.zoff]
  Page::CreateLblEntry f $axis_center_offset2 $zoff_frm z \
  "$gPB(machine,axis,offset,z,Label)"
  pack $zoff_frm -fill x
  set ang_frm [frame $f.aoffset]
  Page::CreateLblEntry f $axis_ang_offset $ang_frm par \
  "$gPB(machine,axis,ang_offset,Label)"
  set dist_frm [frame $f.dist]
  Page::CreateLblEntry f $axis_pivot_offset $dist_frm par \
  "$gPB(machine,axis,pivot,Label)"
  set dpm_frm [frame $f.dpm]
  Page::CreateLblEntry f $axis_max_dpm $dpm_frm par \
  "$gPB(machine,axis,max_feed,Label)"
  checkbutton $fc.rotary_motion \
  -text "$gPB(machine,axis,con_motion,combine,Label)" \
  -variable mom_kin_var(mom_kin_linearization_flag) \
  -command "UI_PB_mach_SetTolState $fc"
  pack $fc.rotary_motion -anchor w
  set tol_frm [frame $fc.tol]
  Page::CreateLblEntry f mom_kin_linearization_tol $tol_frm par \
  "$gPB(machine,axis,con_motion,tol,Label)"
  pack $tol_frm -fill x
  radiobutton $fa.warning -text "$gPB(machine,axis,violation,warn,Label)" \
  -width 27 -anchor w \
  -variable mom_kin_var($axis_limit_action) \
  -value Warning
  radiobutton $fa.ret -text "$gPB(machine,axis,violation,ret,Label)" \
  -width 27 -anchor w \
  -variable mom_kin_var($axis_limit_action) \
  -value "Retract / Re-Engage"
  grid $fa.warning       -sticky w -padx 5 -pady 2
  grid $fa.ret           -sticky w -padx 5 -pady 2
  grid $f.mach       $f.loffset  -padx 5  -pady 5  -sticky news
  grid $f.resolution $f.dist     -padx 5 -pady 5  -sticky ew
  grid $f.dpm        $f.aoffset  -padx 5 -pady 5  -sticky ew
  grid $f.rotation   $f.direction -padx 5  -pady 5 -sticky news
  grid $f.limits     $f.action   -padx 5  -pady 5  -sticky news
  grid $f.combine -padx 5 -pady 5 -sticky news
  set ff [frame $frame_id.ff]
  pack $ff -side bottom -fill x
  UI_PB_mach_AddActionButtons page_obj $ff $axis_param
 }

#=======================================================================
proc UI_PB_mach_MapAxisDirection { axis_direction sel_value } {
  global mom_kin_var
  set mom_kin_var($axis_direction) \
  [string toupper $sel_value]
 }

#=======================================================================
proc UI_PB_mach_SetTolState { fc } {
  global mom_kin_var
  global gPB
  set e $fc.tol.1_par
  if { $mom_kin_var(mom_kin_linearization_flag) } \
  {
   $e config -state normal
   bind $e <KeyPress> "UI_PB_com_ValidateDataOfEntry %W %K f"
   bind $e <KeyRelease> { %W config -state normal }
  } else \
  {
   $e config -state disabled
   bind $e <KeyPress> ""
   bind $e <KeyRelease> ""
  }
 }

#=======================================================================
proc UI_PB_mach_AddActionButtons { PAGE_OBJ frame_id axis_param } {
  upvar $PAGE_OBJ page_obj
  global paOption
  set label_list {"gPB(nav_button,default,Label)" \
  "gPB(nav_button,restore,Label)"}
  set cb_arr(gPB(nav_button,default,Label)) \
  "UI_PB_mach_DefaultCallBack $page_obj $axis_param"
  set cb_arr(gPB(nav_button,restore,Label)) \
  "UI_PB_mach_RestoreCallBack $page_obj $axis_param"
  UI_PB_com_CreateButtonBox $frame_id label_list cb_arr
 }

#=======================================================================
proc UI_PB_mach_CreateRotaryAxisConfig { page_obj frame_id } {
  global gPB
  set bb [tixButtonBox $frame_id.bb -orientation horizontal]
  $bb config -relief sunken -bd 1 -bg royalBlue -pady 5
  $bb add spec -text "$gPB(machine,axis,config,Label)" -width 20
  grid $bb
  set b [$bb subwidget spec]
  $b config -command "UI_PB_mach_ConfigRotaryAxisWin $page_obj $b"
 }

#=======================================================================
proc UI_PB_mach_ConfigRotaryAxisWin { page_obj frame_id } {
  global gPB
  set canvas_frame $Page::($page_obj,canvas_frame)
  set w $canvas_frame.axis_config
  toplevel $w
  set toplevel_index [llength $gPB(toplevel_list)]
  set win_index [expr $toplevel_index + 1]
  set gPB(toplevel_disable_$win_index) 1
  UI_PB_com_CreateTransientWindow $w \
  "$gPB(machine,axis,r_axis_conf_trans,Label)" "+500+300" \
  "UI_PB_mach_DisableMachPageWidgets $page_obj" "" \
  "UI_PB_mach_ActivateMachPageWidgets $page_obj $win_index"
  set page_frm [frame $w.f1 -relief sunken -bd 1]
  pack $page_frm -fill both -expand yes -padx 6 -pady 5
  UI_PB_mach_ConfigRotaryAxisParms $page_frm
  set frame [frame $w.f2]
  pack $frame -side bottom -fill x -padx 3 -pady 4
  UI_PB_mach_ConfigRotaryAxisNavButtons $w $frame
 }

#=======================================================================
proc UI_PB_mach_ConfigRotaryAxisParms { widget_id } {
  global tixOption
  global paOption
  global machData
  global mom_kin_var
  global gPB
  tixLabelFrame $widget_id.4th      -label "$gPB(machine,axis,4th_axis,Label)"
  tixLabelFrame $widget_id.5th      -label "$gPB(machine,axis,5th_axis,Label)"
  grid $widget_id.4th $widget_id.5th -padx 10 -pady 30
  set f4 [$widget_id.4th subwidget frame]
  set f5 [$widget_id.5th subwidget frame]
  UI_PB_mach_ConfigParms $f4 4TH_AXIS
  UI_PB_mach_ConfigParms $f5 5TH_AXIS
 }

#=======================================================================
proc UI_PB_mach_ConfigParms { frame_id axis_type } {
  global mom_kin_var
  global gPB
  if { $axis_type == "4TH_AXIS" } \
  {
   set AXIS mom_kin_4th_axis
  } else \
  {
   set AXIS mom_kin_5th_axis
  }
  set temp_name $mom_kin_var($AXIS\_plane)
  append head_var $AXIS _type
  global tixOption
  label $frame_id.type -text " $mom_kin_var($head_var) " \
  -font $tixOption(bold_font) -fg white -bg royalBlue
  set plane_axis_list {XY YZ ZX}
  append plane_type $AXIS _plane
  set plane_frm [frame $frame_id.plane]
  Page::CreateOptionalMenu $plane_type $plane_frm opt $plane_axis_list \
  "$gPB(machine,axis,plane,Label)"
  set mom_kin_var($plane_type) $temp_name
  set leader_frm [frame $frame_id.address]
  append rotary_leader $AXIS _leader
  Page::CreateLblEntry s $rotary_leader $leader_frm par \
  "$gPB(machine,axis,leader,Label)"
  grid $frame_id.type -sticky w  -padx 5
  grid $frame_id.plane      -         -sticky w  -padx 5
  grid $frame_id.address    -         -sticky nw -padx 5
 }

#=======================================================================
proc UI_PB_mach_ConfigRotaryAxisNavButtons { win frame } {
  global paOption
  set box1_frm [frame $frame.box1]
  set box2_frm [frame $frame.box2]
  tixForm $box1_frm -top 0 -left 3 -right %60 -padright 20
  tixForm $box2_frm -top 0 -left $box1_frm -padx 3 -right %100
  set first_list {"gPB(nav_button,default,Label)" \
   "gPB(nav_button,restore,Label)" \
  "gPB(nav_button,apply,Label)"}
  set second_list {"gPB(nav_button,cancel,Label)" \
  "gPB(nav_button,ok,Label)"}
  set cb_arr(gPB(nav_button,default,Label)) "UI_PB_mach_RotaryDefCallBack"
  set cb_arr(gPB(nav_button,restore,Label)) "UI_PB_mach_RotaryResCallBack"
  set cb_arr(gPB(nav_button,apply,Label))   "UI_PB_mach_RotaryAppCallBack"
  set cb_arr(gPB(nav_button,cancel,Label)) \
  "UI_PB_mach_RotaryCancCallBack $win"
  set cb_arr(gPB(nav_button,ok,Label))  \
  "UI_PB_mach_RotaryOkCallBack $win"
  UI_PB_com_CreateButtonBox $box1_frm first_list cb_arr
  UI_PB_com_CreateButtonBox $box2_frm second_list cb_arr
 }

#=======================================================================
proc UI_PB_mach_RotaryCancCallBack { frame } {
  UI_PB_mach_RotaryResCallBack
  destroy $frame
 }

#=======================================================================
proc UI_PB_mach_RotaryResCallBack { } {
  global mom_kin_var
  global rest_mom_kin_var
  set mom_kin_var(mom_kin_4th_axis_type) \
  $rest_mom_kin_var(mom_kin_4th_axis_type)
  set mom_kin_var(mom_kin_4th_axis_plane) \
  $rest_mom_kin_var(mom_kin_4th_axis_plane)
  set mom_kin_var(mom_kin_4th_axis_leader) \
  $rest_mom_kin_var(mom_kin_4th_axis_leader)
  set mom_kin_var(mom_kin_5th_axis_type) \
  $rest_mom_kin_var(mom_kin_5th_axis_type)
  set mom_kin_var(mom_kin_5th_axis_plane) \
  $rest_mom_kin_var(mom_kin_5th_axis_plane)
  set mom_kin_var(mom_kin_5th_axis_leader) \
  $rest_mom_kin_var(mom_kin_5th_axis_leader)
 }

#=======================================================================
proc UI_PB_mach_RotaryAppCallBack { } {
  global mom_kin_var
  global rest_mom_kin_var
  set ret_code [ValidateMachObjAttr 5]
  if { $ret_code == "TCL_ERROR" } { return TCL_ERROR }
  set rest_mom_kin_var(mom_kin_4th_axis_type) \
  $mom_kin_var(mom_kin_4th_axis_type)
  set rest_mom_kin_var(mom_kin_4th_axis_plane) \
  $mom_kin_var(mom_kin_4th_axis_plane)
  set rest_mom_kin_var(mom_kin_4th_axis_leader) \
  $mom_kin_var(mom_kin_4th_axis_leader)
  set add_name "fourth_axis"
  PB_int_RetAddrObjFromName add_name fourth_add_obj
  set address::($fourth_add_obj,add_leader) \
  $mom_kin_var(mom_kin_4th_axis_leader)
  set rest_mom_kin_var(mom_kin_5th_axis_type) \
  $mom_kin_var(mom_kin_5th_axis_type)
  set rest_mom_kin_var(mom_kin_5th_axis_plane) \
  $mom_kin_var(mom_kin_5th_axis_plane)
  set rest_mom_kin_var(mom_kin_5th_axis_leader) \
  $mom_kin_var(mom_kin_5th_axis_leader)
  set add_name "fifth_axis"
  PB_int_RetAddrObjFromName add_name fifth_add_obj
  set address::($fifth_add_obj,add_leader) \
  $mom_kin_var(mom_kin_5th_axis_leader)
  return TCL_OK
 }

#=======================================================================
proc UI_PB_mach_RotaryDefCallBack { } {
  PB_int_RetDefKinVars def_mom_kin_var
  global mom_kin_var
  set mom_kin_var(mom_kin_4th_axis_type) \
  $def_mom_kin_var(mom_kin_4th_axis_type)
  set mom_kin_var(mom_kin_4th_axis_plane) \
  $def_mom_kin_var(mom_kin_4th_axis_plane)
  set mom_kin_var(mom_kin_4th_axis_leader) \
  $def_mom_kin_var(mom_kin_4th_axis_leader)
  set mom_kin_var(mom_kin_5th_axis_type) \
  $def_mom_kin_var(mom_kin_5th_axis_type)
  set mom_kin_var(mom_kin_5th_axis_plane) \
  $def_mom_kin_var(mom_kin_5th_axis_plane)
  set mom_kin_var(mom_kin_5th_axis_leader) \
  $def_mom_kin_var(mom_kin_5th_axis_leader)
 }

#=======================================================================
proc UI_PB_mach_RotaryOkCallBack { win } {
  set ret_code [UI_PB_mach_RotaryAppCallBack]
  if { $ret_code == "TCL_OK" } \
  {
   destroy $win
  }
 }

#=======================================================================
proc UI_PB_mach_DefaultCallBack { page_obj axis_param } {
  global mom_kin_var
  global mom_sys_arr
  if {[string compare $axis_param "general_param"] == 0} \
  {
   set mom_var_list $Page::($page_obj,general_param)
   } elseif { [string compare $axis_param "axis_4th_param"] == 0 } \
  {
   set mom_var_list $Page::($page_obj,axis_4th_param)
  } else \
  {
   set mom_var_list $Page::($page_obj,axis_5th_param)
  }
  PB_int_RetDefKinVarValues mom_var_list def_mom_kin_var
  foreach kin_var $mom_var_list \
  {
   if { [string match "mom_kin*" $kin_var] } \
   {
    set mom_kin_var($kin_var) $def_mom_kin_var($kin_var)
   } else \
   {
    set mom_sys_arr($kin_var) $def_mom_kin_var($kin_var)
   }
  }
 }

#=======================================================================
proc UI_PB_mach_RestoreCallBack { page_obj axis_param } {
  global mom_kin_var
  global mom_sys_arr
  global rest_mom_kin_var
  global rest_mom_sys_arr
  if {[string compare $axis_param "general_param"] == 0} \
  {
   set mom_var_list $Page::($page_obj,general_param)
   } elseif { [string compare $axis_param "axis_4th_param"] == 0 } \
  {
   set mom_var_list $Page::($page_obj,axis_4th_param)
  } else \
  {
   set mom_var_list $Page::($page_obj,axis_5th_param)
  }
  foreach kin_var $mom_var_list \
  {
   if { [string match "mom_kin*" $kin_var] } \
   {
    set mom_kin_var($kin_var) $rest_mom_kin_var($kin_var)
   } else \
   {
    set mom_sys_arr($kin_var) $rest_mom_sys_arr($kin_var)
   }
  }
 }
 set w 0

#=======================================================================
proc DisplayMachImage {} {
  global w
  if {[winfo exists $w]} \
  {
   if {[wm state $w] == "iconic"}\
   {
    wm deiconify $w
   } else\
   {
    raise $w
    focus $w
   }
  } else \
  {
   UI_PB_mach_AddMachImage
  }
 }

#=======================================================================
proc UI_PB_mach_AddMachImage {} {
  global machData
  global w
  global mach_type axisoption
  global mom_kin_var
  global imagefile ImageWindowText
  global 4x1 4y1 4x2 4y2 4ax1 4ay1 4ax2 4ay2 4sx 4sy
  global 5x1 5y1 5x2 5y2 5ax1 5ay1 5ax2 5ay2 5sx 5sy
  global 5ox 5oy
  if {[info exists w]} {
   destroy $w
  }
  set imagefile ""
  ConstructMachDisplayParameters
  if { $imagefile == "" } { return }
  global gPB
  set w $gPB(active_window).mach_image
  toplevel $w
  wm title $w "Machine Tool"
  wm geometry $w 800x700+300+200
  label $w.lab  -justify left -text $ImageWindowText
  pack $w.lab -anchor c -padx 10 -pady 6
  tixCObjView $w.c
  pack $w.c -expand yes -fill both -padx 4 -pady 2
  image create photo machphoto -file $imagefile
  [$w.c subwidget canvas] create image 390 340 -image machphoto \
  -anchor c
  if { $mach_type == "Mill" && $axisoption != "3" } {
   set 4xmin $mom_kin_var(mom_kin_4th_axis_min_limit)
   set 4xmax $mom_kin_var(mom_kin_4th_axis_max_limit)
   set 4dire $mom_kin_var(mom_kin_4th_axis_rotation)
   set 4address $mom_kin_var(mom_kin_4th_axis_leader)
   if { $4dire == "standard" } {
    set 4sign +$4address
    } else {
    set 4sign -$4address
   }
   if { $4dire == "standard" } {
    [$w.c subwidget canvas] create text $4x1 $4y1 -text $4xmin \
    -fill white -font {helvetica 18 bold}
    [$w.c subwidget canvas] create text $4x2 $4y2 -text $4xmax \
    -fill white -font {helvetica 18 bold}
    } else {
    [$w.c subwidget canvas] create text $4x2 $4y2 -text $4xmin \
    -fill white -font {helvetica 18 bold}
    [$w.c subwidget canvas] create text $4x1 $4y1 -text $4xmax \
    -fill white -font {helvetica 18 bold}
   }
   eval {[$w.c subwidget canvas] create line} {$4ax1 $4ay1 $4ax2 $4ay2} \
   {-tag arrow -arrow last -arrowshape [list 20 25 8] -fill yellow}
   [$w.c subwidget canvas] create text $4sx $4sy -text $4sign \
   -fill white -font {helvetica 22 bold}
   if { $axisoption == "5HH" || \
    $axisoption == "5TT" || \
    $axisoption == "5HT" } {
    set 5xmin $mom_kin_var(mom_kin_5th_axis_min_limit)
    set 5xmax $mom_kin_var(mom_kin_5th_axis_max_limit)
    set 5dire $mom_kin_var(mom_kin_5th_axis_rotation)
    set 5address $mom_kin_var(mom_kin_5th_axis_leader)
    if { $5dire == "standard" } {
     set 5sign +$5address
     } else {
     set 5sign -$5address
    }
    if { $5dire == "standard" } {
     [$w.c subwidget canvas] create text $5x1 $5y1 -text $5xmin \
     -fill white -font {helvetica 18 bold}
     [$w.c subwidget canvas] create text $5x2 $5y2 -text $5xmax \
     -fill white -font {helvetica 18 bold}
     } else {
     [$w.c subwidget canvas] create text $5x2 $5y2 -text $5xmin \
     -fill white -font {helvetica 18 bold}
     [$w.c subwidget canvas] create text $5x1 $5y1 -text $5xmax \
     -fill white -font {helvetica 18 bold}
    }
    eval {[$w.c subwidget canvas] create line} \
    {$5ax1 $5ay1 $5ax2 $5ay2} \
    {-tag arrow -arrow last -arrowshape [list 20 25 8] -fill yellow}
    [$w.c subwidget canvas] create text $5sx $5sy -text $5sign \
    -fill white -font {helvetica 22 bold}
    if { $axisoption == "5TT" } {
     if { $mom_kin_var(mom_kin_5th_axis_plane) == "ZX" } {
      set offset $mom_kin_var(mom_kin_5th_axis_center_offset\(1\))
      } elseif { $mom_kin_var(mom_kin_5th_axis_plane) == "XY" } {
      set offset $mom_kin_var(mom_kin_5th_axis_center_offset\(2\))
      } elseif {  $mom_kin_var(mom_kin_5th_axis_plane) == "YZ" } {
      set offset $mom_kin_var(mom_kin_5th_axis_center_offset\(0\))
     }
     [$w.c subwidget canvas] create text $5ox $5oy -text $offset \
     -fill white -font {helvetica 18 bold}
    }
   }
  }
  $w.c adjustscrollregion
 }

#=======================================================================
proc ConstructMachDisplayParameters {} {
  global mach_type axisoption
  global imagefile directory
  global ImageWindowText
  global env
  set directory "$env(PB_HOME)/images/mach_tool/"
  switch $mach_type \
  {
   "Mill" \
   {
    switch -- $axisoption \
    {
     "3" {
      set ImageWindowText [list 3-Axis $mach_type]
      append imagefile $directory pb_m3x_v.gif
     }
     "4T" -
     "4H" {
      if { [ValidateMachObjAttr 4] == "TCL_ERROR" } { return }
      set ImageWindowText [list 4-Axis $mach_type]
      Construct4thAxisDisplayParameter
     }
     "5HH" -
     "5TT" -
     "5HT" {
      if { [ValidateMachObjAttr 5] == "TCL_ERROR" } { return }
      set ImageWindowText [list 5-Axis $mach_type]
      Construct5thAxisDisplayParameter
     }
    }
   }
   "Lathe" \
   {
    switch $axisoption \
    {
     "2" {
      set ImageWindowText [list 2-Axis $mach_type]
      append imagefile $directory pb_l2x.gif
     }
     "4" {
      set ImageWindowText [list 4-Axis $mach_type]
      append imagefile $directory pb_l2x.gif
     }
    }
   }
  }
 }

#=======================================================================
proc Construct4thAxisDisplayParameter {} {
  global mom_kin_var
  global imagefile directory
  global gPB
  set 4address $mom_kin_var(mom_kin_4th_axis_leader)
  switch $mom_kin_var(mom_kin_4th_axis_plane) \
  {
   "YZ" \
   {
    switch $mom_kin_var(mom_kin_4th_axis_type) \
    {
     "Table" {
      Set4thDispParams 200 380 320 390 258 374 \
      313 421 308 407 \
      220 411 223 383
      append imagefile $directory pb_m4x_TA_h.gif
     }
     "Head" {
      Set4thDispParams 550 450 550 380 458 440 \
      507 367 525 374 \
      517 442 536 425
      append imagefile $directory pb_m4x_HA_h.gif
     }
    }
   }
   "ZX" \
   {
    switch $mom_kin_var(mom_kin_4th_axis_type) \
    {
     "Table" {
      Set4thDispParams 550 430 330 430 434 515 \
      359 482 333 478 \
      520 463 545 452
      append imagefile $directory pb_m4x_TB_h.gif
     }
     "Head" {
      Set4thDispParams 585 319 490 325 538 309 \
      514 348 526 362 \
      581 349 574 363
      append imagefile $directory pb_m4x_HB_h.gif
     }
    }
   }
   default {
    tk_messageBox -parent [UI_PB_com_AskActiveWindow] -type ok \
    -icon question \
    -message "$gPB(msg,no_display)"
    return
   }
  }
 }

#=======================================================================
proc Set4thDispParams { x1 y1 x2 y2 sx sy ax1_1 ay1_1 ax2_1 ay2_1 \
  ax1_2 ay1_2 ax2_2 ay2_2 } {
  global mom_kin_var
  global 4x1 4y1 4x2 4y2 4ax1 4ay1 4ax2 4ay2 4sx 4sy
  set 4dire $mom_kin_var(mom_kin_4th_axis_rotation)
  set 4x1 $x1; set 4y1 $y1
  set 4x2 $x2; set 4y2 $y2
  set 4sx $sx; set 4sy $sy
  if { $4dire == "standard" } {
   set 4ax1 $ax1_1; set 4ay1 $ay1_1
   set 4ax2 $ax2_1; set 4ay2 $ay2_1
   } else {
   set 4ax1 $ax1_2; set 4ay1 $ay1_2
   set 4ax2 $ax2_2; set 4ay2 $ay2_2
  }
 }

#=======================================================================
proc Set5thDispParams { x1 y1 x2 y2 sx sy ax1_1 ay1_1 ax2_1 ay2_1 \
  ax1_2 ay1_2 ax2_2 ay2_2 ox oy } {
  global mom_kin_var
  global 5x1 5y1 5x2 5y2 5ax1 5ay1 5ax2 5ay2 5sx 5sy
  global 5ox 5oy
  set 5dire $mom_kin_var(mom_kin_5th_axis_rotation)
  set 5x1 $x1; set 5y1 $y1
  set 5x2 $x2; set 5y2 $y2
  set 5sx $sx; set 5sy $sy
  if { $5dire == "standard" } {
   set 5ax1 $ax1_1; set 5ay1 $ay1_1
   set 5ax2 $ax2_1; set 5ay2 $ay2_1
   } else {
   set 5ax1 $ax1_2; set 5ay1 $ay1_2
   set 5ax2 $ax2_2; set 5ay2 $ay2_2
  }
  set 5ox $ox
  set 5oy $oy
 }

#=======================================================================
proc Construct5thAxisDisplayParameter {} {
  global imagefile directory
  global axisoption
  global mom_kin_var
  global gPB
  set 4plane $mom_kin_var(mom_kin_4th_axis_plane)
  set 4address $mom_kin_var(mom_kin_4th_axis_leader)
  set 5plane $mom_kin_var(mom_kin_5th_axis_plane)
  set 5address $mom_kin_var(mom_kin_5th_axis_leader)
  switch $mom_kin_var(mom_kin_4th_axis_plane) \
  {
   "YZ" \
   {
    switch $mom_kin_var(mom_kin_5th_axis_plane) \
    {
     "ZX" \
     {
      switch $axisoption \
      {
       "5HH" {
        Set4thDispParams 470 270 450 220 381 281 \
        424 253 444 237 \
        451 304 467 293
        Set5thDispParams 540 270 500 300 580 347 \
        497 346 494 316 \
        545 290 530 285 \
        0 0
        append imagefile $directory pb_m5x_HA_HB_v.gif
       }
       "5TT" {
        Set4thDispParams 250 420 370 450 307 439 \
        361 491 354 471 \
        267 470 271 443
        Set5thDispParams 470 550 480 440 531 477 \
        506 413 492 422 \
        509 535 485 531 \
        240 536
        append imagefile $directory pb_m5x_TA_TB_v.gif
       }
       "5HT" {
        Set4thDispParams 470 240 390 280 393 253 \
        420 283 419 256 \
        462 269 452 255
        Set5thDispParams 540 500 680 440 607 469 \
        678 474 670 461 \
        564 530 570 502 \
        0 0
        append imagefile $directory pb_m5x_HA_TB_v.gif
       }
      }
     }
     "XY" \
     {
      switch $axisoption \
      {
       "5HH" \
       {
        tk_messageBox -parent [UI_PB_com_AskActiveWindow] -type ok \
        -icon question -message "$gPB(msg,no_display)"
        return
       }
       "5TT" \
       {
        Set4thDispParams 230 480 340 480 286 460 \
        342 512 337 496 \
        255 495 259 470
        Set5thDispParams 410 390 460 470 478 393 \
        495 446 474 448 \
        420 413 399 423 \
        240 530
        append imagefile $directory pb_m5x_TA_TC_v.gif
       }
       "5HT" \
       {
        Set4thDispParams 430 220 355 250 355 223 \
        386 255 385 228 \
        426 241 417 228
        Set5thDispParams 610 450 380 460 479 476 \
        393 507 373 505 \
        589 484 607 477 \
        0 0
        append imagefile $directory  pb_m5x_HA_TC_v.gif
       }
      }
     }
     default {
      tk_messageBox -parent [UI_PB_com_AskActiveWindow] -type ok \
      -icon question -message "$gPB(msg,no_display)"
      return
     }
    }
   }
   "ZX" \
   {
    switch $mom_kin_var(mom_kin_5th_axis_plane) \
    {
     "YZ" \
     {
      switch $axisoption \
      {
       "5HH" {
        Set4thDispParams 580 240 520 250 610 280 \
        539 288 529 272 \
        581 275 578 257
        Set5thDispParams 480 280 440 290 396 327 \
        442 328 440 309 \
        486 305 476 293 \
        0 0
        append imagefile $directory pb_m5x_HB_HA_v.gif
       }
       "5TT" {
        Set4thDispParams 550 400 650 410 560 556 \
        647 447 646 427 \
        555 432 568 411
        Set5thDispParams 410 475 455 350 439 412 \
        462 369 448 365 \
        433 460 413 440 \
        690 500
        append imagefile $directory pb_m5x_TB_TA_v.gif
       }
       "5HT" {
        Set4thDispParams 520 230 450 280 553 314 \
        483 306 481 279 \
        532 252 517 248
        Set5thDispParams 310 410 400 500 347 465 \
        385 535 385 520 \
        294 451 309 434 \
        0 0
        append imagefile $directory pb_m5x_HB_TA_v.gif
       }
      }
     }
     "XY" \
     {
      switch $axisoption \
      {
       "5HH" {
        tk_messageBox -parent [UI_PB_com_AskActiveWindow] -type ok \
        -icon question -message "$gPB(msg,no_display)"
        return
       }
       "5TT" {
        Set4thDispParams 460 460 560 420 534 577 \
        565 450 557 438 \
        467 496 471 474
        Set5thDispParams 380 425 470 360 393 355 \
        443 376 457 383 \
        373 403 393 408 \
        590 510
        append imagefile $directory pb_m5x_TB_TC_v.gif
       }
       "5HT" {
        Set4thDispParams 465 190 401 235 488 271 \
        431 254 430 232 \
        474 218 462 209
        Set5thDispParams 570 465 376 477 459 548 \
        396 509 380 506 \
        556 490 571 484 \
        0 0
        append imagefile $directory pb_m5x_HB_TC_v.gif
       }
      }
     }
     default {
      tk_messageBox -parent [UI_PB_com_AskActiveWindow] -type ok \
      -icon question \
      -message "$gPB(msg,no_display)"
      return
     }
    }
   }
   "XY" \
   {
    switch $mom_kin_var(mom_kin_5th_axis_plane) \
    {
     "YZ" \
     {
      switch $axisoption \
      {
       "5HH" {
        Set4thDispParams 410 190 590 220 603 262 \
        562 252 584 246 \
        419 219 429 204
        Set5thDispParams 490 290 410 330 410 304 \
        442 331 441 303 \
        485 313 476 301 \
        0 0
        append imagefile $directory pb_m5x_HC_HA_v.gif
       }
       default {
        tk_messageBox -parent [UI_PB_com_AskActiveWindow] -type ok \
        -icon question -message "$gPB(msg,no_display)"
        return
       }
      }
     }
     "ZX" \
     {
      switch $axisoption \
      {
       "5HH" {
        Set4thDispParams 370 200 540 230 560 265 \
        510 254 529 249 \
        374 220 385 211
        Set5thDispParams 530 330 460 290 504 299 \
        482 314 500 304 \
        519 356 522 343 \
        0 0
        append imagefile $directory pb_m5x_HC_HB_v.gif
       }
       default {
        tk_messageBox -parent [UI_PB_com_AskActiveWindow] -type ok \
        -icon question -message "$gPB(msg,no_display)"
        return
       }
      }
     }
     default {
      tk_messageBox -parent [UI_PB_com_AskActiveWindow] -type ok \
      -icon question \
      -message "$gPB(msg,no_display)"
      return
     }
    }
   }
   default {
    tk_messageBox -parent [UI_PB_com_AskActiveWindow] -type ok \
    -icon question \
    -message "$gPB(msg,no_display)"
    return
   }
  }
 }

#=======================================================================
proc ValidateMachObjAttr { axis_type } {
  global mom_kin_var
  global gPB
  switch -- $axis_type \
  {
   3 {
    return TCL_OK
   }
   4 {
    if { $mom_kin_var(mom_kin_4th_axis_plane) == "XY" && \
     $mom_kin_var(mom_kin_4th_axis_leader) == "C" && \
    $mom_kin_var(mom_kin_4th_axis_type) == "Table" } \
    {
     tk_messageBox -parent [UI_PB_com_AskActiveWindow] -type ok \
     -icon error -message "$gPB(msg,no_4th_ctable)"
     return TCL_ERROR
    }
    set 4xmin $mom_kin_var(mom_kin_4th_axis_min_limit)
    set 4xmax $mom_kin_var(mom_kin_4th_axis_max_limit)
    set 4range [expr $4xmax - $4xmin]
    if { $4range == 0 } \
    {
     tk_messageBox -parent [UI_PB_com_AskActiveWindow] -type ok \
     -icon error -message "$gPB(msg,no_5th_max_min)"
     return TCL_ERROR
     } elseif { $4xmax < 0 && $4xmin < 0 } {
     tk_messageBox -parent [UI_PB_com_AskActiveWindow] -type ok \
     -icon error -message "$gPB(msg,no_5th_both_neg)"
     return TCL_ERROR
    }
   }
   5 {
    if { $mom_kin_var(mom_kin_4th_axis_plane) == \
    $mom_kin_var(mom_kin_5th_axis_plane) } \
    {
     tk_messageBox -parent [UI_PB_com_AskActiveWindow] -type ok \
     -icon error -message "$gPB(msg,no_4th_5th_plane)"
     return TCL_ERROR
    }
    if { $mom_kin_var(mom_kin_4th_axis_plane) == "XY" && \
     $mom_kin_var(mom_kin_4th_axis_leader) == "C" && \
    $mom_kin_var(mom_kin_4th_axis_type) == "Table" } \
    {
     tk_messageBox -parent [UI_PB_com_AskActiveWindow] -type ok \
     -icon error -message "$gPB(msg,no_4th_ctable)"
     return TCL_ERROR
    }
    if { $mom_kin_var(mom_kin_4th_axis_type) == "Table" && \
    $mom_kin_var(mom_kin_5th_axis_type) == "Head" } \
    {
     tk_messageBox -parent [UI_PB_com_AskActiveWindow] -type ok \
     -icon error -message "$gPB(msg,no_4thT_5thH)"
     return TCL_ERROR
    }
    set 4xmin $mom_kin_var(mom_kin_4th_axis_min_limit)
    set 4xmax $mom_kin_var(mom_kin_4th_axis_max_limit)
    set 4range [expr $4xmax - $4xmin]
    if { $4range == 0 } \
    {
     tk_messageBox -parent [UI_PB_com_AskActiveWindow] -type ok \
     -icon error -message "$gPB(msg,no_4th_max_min)"
     return TCL_ERROR
     } elseif { $4xmax < 0 && $4xmin < 0 } {
     tk_messageBox -parent [UI_PB_com_AskActiveWindow] -type ok \
     -icon error -message "$gPB(msg,no_4th_both_neg)"
     return TCL_ERROR
    }
    set 5xmin $mom_kin_var(mom_kin_5th_axis_min_limit)
    set 5xmax $mom_kin_var(mom_kin_5th_axis_max_limit)
    set 5range [expr $5xmax - $5xmin]
    if { $5range == 0 } \
    {
     tk_messageBox -parent [UI_PB_com_AskActiveWindow] -type ok \
     -icon error -message "$gPB(msg,no_4th_max_min)"
     return TCL_ERROR
     } elseif { $5xmax < 0 && $5xmin < 0 } {
     tk_messageBox -parent [UI_PB_com_AskActiveWindow] -type ok \
     -icon error -message "$gPB(msg,no_5th_both_neg)"
     return TCL_ERROR
    }
   }
  }
  return TCL_OK
 }

#=======================================================================
proc UI_PB_mach_UpdateMachinePageParams { MACH_PAGE_OBJ } {
  upvar $MACH_PAGE_OBJ mach_page_obj
  global mom_kin_var
  global mom_sys_arr
  PB_int_UpdateKinVar mom_kin_var
  if { $mom_kin_var(mom_kin_machine_type) == "lathe" } \
  {
   if { $mom_sys_arr(\$xaxis_dia_prog) == 1 && \
   $mom_sys_arr(\$xaxis_mirror) == 1 } \
   {
    set mom_sys_arr(\$mom_sys_lathe_x_factor) -2
    } elseif { $mom_sys_arr(\$xaxis_dia_prog) == 1 && \
   $mom_sys_arr(\$xaxis_mirror) == 0 } \
   {
    set mom_sys_arr(\$mom_sys_lathe_x_factor) 2
    } elseif { $mom_sys_arr(\$xaxis_dia_prog) == 0 && \
   $mom_sys_arr(\$xaxis_mirror) == 1 } \
   {
    set mom_sys_arr(\$mom_sys_lathe_x_factor) -1
   } else \
   {
    set mom_sys_arr(\$mom_sys_lathe_x_factor) 1
   }
   if { $mom_sys_arr(\$zaxis_mirror) == 1 } \
   {
    set mom_sys_arr(\$mom_sys_lathe_z_factor) -1
   } else \
   {
    set mom_sys_arr(\$mom_sys_lathe_z_factor) 1
   }
  }
  PB_int_UpdateMOMVar mom_sys_arr
 }

#=======================================================================
proc UI_PB_mach_CreateTabAttr { mach_page_obj } {
  global mom_kin_var
  global mom_sys_arr
  global rest_mom_kin_var
  global rest_mom_sys_arr
  if { [info exists mom_kin_var(mom_kin_4th_axis_leader)] } \
  {
   set add_name "fourth_axis"
   PB_int_RetAddrObjFromName add_name fourth_add_obj
   set mom_kin_var(mom_kin_4th_axis_leader) \
   $address::($fourth_add_obj,add_leader)
  }
  if { [info exists mom_kin_var(mom_kin_5th_axis_leader)] } \
  {
   set add_name "fifth_axis"
   PB_int_RetAddrObjFromName add_name fifth_add_obj
   set mom_kin_var(mom_kin_5th_axis_leader) \
   $address::($fifth_add_obj,add_leader)
  }
  array set rest_mom_kin_var [array get mom_kin_var]
  array set rest_mom_sys_arr [array get mom_sys_arr]
 }

#=======================================================================
proc UI_PB_mach_ActivateMachPageWidgets { page_obj win_index } {
  global gPB
  if { $gPB(toplevel_disable_$win_index) } \
  {
   tixEnableAll $Page::($page_obj,canvas_frame)
   set gPB(toplevel_disable_$win_index) 0
  }
 }

#=======================================================================
proc UI_PB_mach_DisableMachPageWidgets { page_obj } {
  tixDisableAll $Page::($page_obj,canvas_frame)
 }
