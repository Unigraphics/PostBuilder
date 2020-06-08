#11

#=======================================================================
proc UI_PB_OpenPost { } {
  global tixOption
  global paOption
  global gPB
  if { $gPB(use_info) } \
  {
   UI_PB_chelp_DisplayMenuItemCsh $gPB(file_menu)
   return
  }
  set win $gPB(top_window).open
  if { [winfo exists $win] } \
  {
   $win popup
   UI_PB_com_ClaimActiveWindow $win
   UI_PB_OpenDlgFilter $win
  } else \
  {
   tixFileSelectDialog $win -command "PB_UI_EditPost $win"
   UI_PB_com_CreateTransientWindow $win "$gPB(open,title,Label)" \
   "500x400+200+200" "" "" "UI_PB_OpenDestroy $win"
   set file_box [$win subwidget fsbox]
   $file_box config -pattern "*.pui"
   set top_filter_ent [[$file_box subwidget filter] subwidget entry]
   bind $top_filter_ent <Return> "UI_PB_OpenDlgFilter $win"
   set but_box [$win subwidget btns]
   $but_box config -bg $paOption(butt_bg) -relief sunken
   tixDestroy [$but_box subwidget help]
   UI_PB_com_ClaimActiveWindow $win
   UI_PB_OpenDlgFilter $win
   $win popup
   [$but_box subwidget cancel] config -width 10 -bg $paOption(app_butt_bg) \
   -command "UI_PB_OpenCancel_CB $win"
   [$but_box subwidget apply] config -width 10 -bg $paOption(app_butt_bg) \
   -command "UI_PB_OpenDlgFilter $win"
   [$but_box subwidget ok] config -bg $paOption(app_butt_bg) -width 10
  }
  UI_PB_com_SetStatusbar "$gPB(open,Status)"
  UI_PB_GreyOutAllFileOpts
 }

#=======================================================================
proc UI_PB_OpenDestroy { win } {
  UI_PB_EnableFileOptions
 }

#=======================================================================
proc UI_PB_OpenCancel_CB { dialog_id } {
  global gPB
  $dialog_id popdown
  UI_PB_EnableFileOptions
  UI_PB_com_SetStatusbar "$gPB(main,default,Status)"
 }

#=======================================================================
proc UI_PB_OpenDlgFilter { dlg_id } {
  UI_PB_UpdateFileListBox $dlg_id
  set file_box [$dlg_id subwidget fsbox]
  $file_box config -pattern "*.pui"
 }

#=======================================================================
proc PB_UI_GetPostVersion { FILE_NAME VERSION STD_PUI_FILE } {
  upvar $FILE_NAME file_name
  upvar $VERSION version
  upvar $STD_PUI_FILE std_pui_file
  set file_id [open $file_name r]
  set kin_flag 0
  set units ""
  set machine ""
  set std_pui_file ""
  set version 0
  if { [gets $file_id line] >= 0 } \
  {
   if { [string match "*POSTBUILDER_VERSION*" $line] } \
   {
    set line_list [split $line =]
    set version [lindex $line_list 1]
   } else \
   {
    set version 0
   }
   while { [gets $file_id line] >= 0 } \
   {
    switch $line \
    {
     "## KINEMATIC VARIABLES START" { set kin_flag 1 }
     "## KINEMATIC VARIABLES END"   { set kin_flag 2 }
    }
    if { $kin_flag == 1 } \
    {
     set first_word [string trim [lindex $line 0]]
     set sec_word [string trim [lindex $line 1]]
     switch $first_word \
     {
      "mom_kin_output_unit" { set units $sec_word }
      "mom_kin_machine_type" { set machine $sec_word }
     }
     } elseif { $kin_flag == 2 } \
    {
     break
    }
   }
   set kin_arr(mom_kin_machine_type) $machine
   PB_com_GetMachAxisType kin_arr act_mach_type axis
   append temp_name "pb_" $act_mach_type _ $axis _ Generic _ $units .pui
   set std_pui_file $temp_name
   unset temp_name kin_arr
  }
  close $file_id
 }

#=======================================================================
proc PB_UI_EditPost { dlg_id file_name } {
  global gPB
  set top_win $gPB(top_window)
  set ret_code 0
  if { ![file exists $file_name] } \
  {
   tk_messageBox -parent $top_win -type ok -icon question \
   -message "$gPB(msg,invalid_file)."
   $dlg_id popup
   return
  } else \
  {
   set extension [file extension $file_name]
   if { [string compare $extension ".pui"] != 0 } \
   {
    tk_messageBox -parent $top_win -type ok -icon warning \
    -message "$gPB(msg,invalid_file)"
    $dlg_id popup
    return
   }
  }
  PB_UI_GetPostVersion file_name version std_pui_file
  set ver_check [string compare $gPB(Postbuilder_Version) $version]
  if { $ver_check > 0 } \
  {
   set ret_code [PB_OpenOldVersion $file_name $std_pui_file]
   } elseif { $ver_check < 0 } \
  {
   tk_messageBox -parent $top_win -type ok -icon warning \
   -message "$gPB(msg,version_check)"
   set ret_code 1
  } else \
  {
   set ret_code [PB_Start $file_name]
  }
  if { $ret_code } \
  {
   UI_PB_com_DismissActiveWindow $dlg_id
   $dlg_id popdown
   UI_PB_OpenCancel_CB $dlg_id
   return
  }
  set pui_file [file tail $file_name]
  PB_int_ReadPostFiles dir def_file tcl_file
  PB_int_SetPostOutputFiles dir pui_file def_file tcl_file
  set gPB(output_dir) $dir
  UI_PB_com_DismissActiveWindow $dlg_id
  $dlg_id popdown
  if [catch { UI_PB_main_window } result] \
  {
   return tk_messageBox -parent $gPB(top_window) -type ok -icon error \
   -message "$gPB(msg,file_corruption)"
  }
  update
  UI_PB_ActivateOpenFileOpts
  AcceptMachineToolSelection
  set gPB(session) EDIT
  UI_PB_com_SetStatusbar "$gPB(machine,Status)"
 }

#=======================================================================
proc UI_PB_SavePost { args } {
  global gPB
  if { $gPB(use_info) } \
  {
   UI_PB_chelp_DisplayMenuItemCsh $gPB(file_menu)
   return
  }
  if { $gPB(session) == "NEW" } \
  {
   UI_PB_SavePostAs
   tkwait variable gPB(session)
  } else \
  {
   UI_PB_save_a_post
  }
 }

#=======================================================================
proc UI_PB_SavePostAs { args } {
  global tixOption
  global paOption
  global gPB
  global gpb_file_ext
  global gpb_pui_file
  global gpb_def_file
  global gpb_tcl_file
  global gpb_prev_status
  if { $gPB(use_info) } \
  {
   UI_PB_chelp_DisplayMenuItemCsh $gPB(file_menu)
   return
  }
  PB_int_ReadPostOutputFiles cur_dir gpb_pui_file gpb_def_file \
  gpb_tcl_file
  set win $gPB(main_window).save_as
  if { [winfo exists $win] } \
  {
   $win popup
   UI_PB_com_ClaimActiveWindow $win
   set file_box [$win subwidget fsbox]
   $file_box config -directory $cur_dir
   UI_PB_SaveAsDlgFilter $win
  } else \
  {
   set gpb_file_ext "pui"
   tixFileSelectDialog $win -command "UI_PB_SavePbFiles $win"
   UI_PB_com_CreateTransientWindow $win "$gPB(save_as,title,Label)" \
   "540x450+150+230" "" "" ""
   set file_box [$win subwidget fsbox]
   set sel_ent [$file_box subwidget selection]
   $sel_ent config -selection $gpb_pui_file
   bind [$sel_ent subwidget entry] <KeyPress> "UI_PB_com_DisableSpaceKey %W %K"
   bind [$sel_ent subwidget entry] <KeyRelease> { %W config -state normal }
   $file_box config -directory $cur_dir
   $file_box config -pattern "*.pui"
   set top_filter_ent [[$file_box subwidget filter] subwidget entry]
   bind $top_filter_ent <Return> "UI_PB_SaveAsSetPattern $win"
   set but_box [$win subwidget btns]
   $but_box config -bg $paOption(butt_bg) -relief sunken
   tixDestroy [$but_box subwidget help]
   UI_PB_com_ClaimActiveWindow $win
   UI_PB_SaveAsDlgFilter $win
   $win popup
   [$but_box subwidget cancel] config -width 10 -bg $paOption(app_butt_bg) \
   -command "UI_PB_SaveAsCancel_CB $win"
   [$but_box subwidget apply]  config -width 10 -bg $paOption(app_butt_bg) \
   -command "UI_PB_SaveAsDlgFilter $win"
   [$but_box subwidget ok]     config -bg $paOption(app_butt_bg) -width 10
  }
  set gpb_prev_status "$gPB(menu_bar_status)"
  UI_PB_com_SetStatusbar "$gPB(save_as,Status)"
 }

#=======================================================================
proc UI_PB_SaveAsCancel_CB { dialog_id } {
  global gpb_prev_status
  $dialog_id popdown
  UI_PB_com_DismissActiveWindow $dialog_id
  UI_PB_com_SetStatusbar "$gpb_prev_status"
 }

#=======================================================================
proc UI_PB_SaveAsDlgFilter { win } {
  UI_PB_SaveAsSetPattern $win
  UI_PB_UpdateFileListBox $win
 }

#=======================================================================
proc UI_PB_UpdateFileListBox { win } {
  global gPB
  set file_box [$win subwidget fsbox]
  set pattern [$file_box cget -pattern]
  set top_filter_ent [[$file_box subwidget filter] subwidget entry]
  set entry_text [$top_filter_ent get]
  set dir [file dirname $entry_text]
  global tcl_platform
  if {$tcl_platform(platform) != "unix"} \
  {
   set dir [string trimright $dir "*"]
   set dir [string trimright $dir "\\"]
  }
  $file_box config -directory $dir
  set file_listbox [[$file_box subwidget filelist] subwidget listbox]
  $file_listbox delete 0 end
  set cur_dir [pwd]
  if { [file isdirectory $dir] } \
  {
   cd $dir
   foreach match [glob -nocomplain -- $pattern] \
   {
    $file_listbox insert end $match
   }
   cd $cur_dir
  } else \
  {
   set main_win $win
   tk_messageBox -parent $main_win -type ok -icon warning \
   -message "$gPB(msg,invalid_dir)"
  }
 }

#=======================================================================
proc UI_PB_SaveAsSetPattern { win } {
  global gpb_file_ext
  UI_PB_UpdateFileListBox $win
  set file_box [$win subwidget fsbox]
  $file_box config -pattern "*.$gpb_file_ext"
 }

#=======================================================================
proc UI_PB_AssignFileName { win } {
  global gpb_file_ext
  global gpb_pui_file
  global gpb_def_file
  global gpb_tcl_file
  set file_box [$win subwidget fsbox]
  set file_listbox [[$file_box subwidget filelist] subwidget listbox]
  set sel_ent [$file_box subwidget selection]
  $sel_ent config -value $gpb_pui_file
  set sel_index [$file_listbox curselection]
  set sel_file_name [$file_listbox get $sel_index $sel_index]
  switch $gpb_file_ext \
  {
   "pui"  { set gpb_pui_file $sel_file_name }
   "def"  { set gpb_def_file $sel_file_name }
   "tcl"  { set gpb_tcl_file $sel_file_name }
  }
  $win popup
 }

#=======================================================================
proc UI_PB_SavePbFiles { win select_file_name } {
  global gPB
  global gpb_pui_file
  global gpb_def_file
  global gpb_tcl_file
  global gpb_prev_status
  set file_box [$win subwidget fsbox]
  set top_filter_ent [[$file_box subwidget filter] subwidget entry]
  set entry_text [$top_filter_ent get]
  set cur_dir [file dirname $entry_text]
  set main_win $gPB(main_window)
  set new_dir [file dirname $select_file_name]
  if { $new_dir != "." } \
  {
   set cur_dir $new_dir
  }
  if { [file isdirectory $new_dir] == 0 } \
  {
   tk_messageBox -parent $main_win -type ok -icon warning \
   -message "$gPB(msg,invalid_dir)"
   $win popup
   return
   } elseif { [llength [split $select_file_name " "]] > 1 } \
  {
   tk_messageBox -parent $main_win -type ok -icon warning \
   -message "$gPB(msg,invalid_file)"
   $win popup
   return
   } elseif { [file writable $new_dir] == 0 } \
  {
   tk_messageBox -parent $main_win -type ok -icon warning \
   -message "$gPB(msg,dir_perm)"
   $win popup
   return
  }
  set file_tail [file tail $select_file_name]
  set dot_index [string last . $file_tail]
  if { $dot_index != -1 } \
  {
   set file_tail [string range $file_tail 0 [expr $dot_index - 1]]
  }
  set pui_file $file_tail.pui
  set def_file $file_tail.def
  set tcl_file $file_tail.tcl
  PB_int_SetPostOutputFiles cur_dir pui_file def_file tcl_file
  set gPB(output_dir) $cur_dir
  UI_PB_save_a_post
  UI_PB_com_DismissActiveWindow $win
  UI_PB_com_SetStatusbar "$gpb_prev_status"
  UI_PB_com_SetWindowTitle
 }

#=======================================================================
proc UI_PB_AttachExtToFile { FILE_NAME ext } {
  upvar $FILE_NAME file_name
  if { [string match *.$ext $file_name] == 0 } \
  {
   set file_name $file_name.$ext
  }
 }

#=======================================================================
proc UI_PB_GreyOutAllFileOpts { } {
  global gPB
  set pb_topwin $gPB(top_window)
  set mb $gPB(main_menu_bar).file.m
  $mb entryconfigure 1 -state disabled
  $mb entryconfigure 2 -state disabled
  if [catch { $mb entryconfigure 3 -state disabled } result] { }
  $mb entryconfigure 4 -state disabled
  $mb entryconfigure 5 -state disabled
  $mb entryconfigure 6 -state disabled
  set mm $gPB(main_menu).tool
  [$mm subwidget new]  config -state disabled
  [$mm subwidget open] config -state disabled
  [$mm subwidget save] config -state disabled
 }

#=======================================================================
proc UI_PB_ActivateOpenFileOpts { } {
  global gPB
  set pb_topwin $gPB(top_window)
  set mb $gPB(main_menu_bar).file.m
  $mb entryconfigure 1 -state disabled
  $mb entryconfigure 2 -state disabled
  if [catch { $mb entryconfigure 3 -state disabled } result] { }
  $mb entryconfigure 4 -state normal
  $mb entryconfigure 5 -state normal
  $mb entryconfigure 6 -state normal
  set mm $gPB(main_menu).tool
  [$mm subwidget new] config -state disabled
  [$mm subwidget open] config -state disabled
  [$mm subwidget save] config -state normal
 }

#=======================================================================
proc UI_PB_NewPost { } {
  global tixOption paOption
  global gPB
  if { $gPB(use_info) } \
  {
   UI_PB_chelp_DisplayMenuItemCsh $gPB(file_menu)
   return
  }
  UI_PB_com_SetStatusbar "$gPB(new,Status)"
  set win $gPB(top_window).new
  if [winfo exists $win] \
  {
   wm deiconify $win
   tixEnableAll $win
   UI_PB_com_ClaimActiveWindow $win
   UI_PB_GreyOutAllFileOpts
   return
  }
  toplevel $win
  UI_PB_com_CreateTransientWindow $win "$gPB(new,title,Label)" "+300+250" \
  "" "destroy $win" "UI_PB_NewDestroy"
  global output_unit
  global mach_type
  global mach_axis
  global mach_controller
  global pb_output_file
  set output_unit "Inches"
  set mach_type "Mill"
  set mach_axis "3"
  set pb_output_file "my_post"
  frame $win.top -relief raised -bd 1
  pack $win.top -side top -fill both -expand yes
  frame $win.top.level1
  frame $win.top.level2
  frame $win.top.level3
  frame $win.top.level5
  frame $win.top.level5.left
  frame $win.top.level5.right
  set name_lbl [label $win.top.level1.name \
  -text [format "%-30s" "$gPB(new,name,Label)"]]
  set name_ent [entry $win.top.level1.ent -width 49 -relief sunken \
  -textvariable pb_output_file]
  $name_ent config -bg $paOption(tree_bg)
  bind $name_ent <KeyPress> "UI_PB_com_DisableSpaceKey %W %K"
  bind $name_ent <KeyRelease> { %W config -state normal }
  pack $name_lbl -side left -padx 5 -pady 5 -anchor w
  pack $name_ent -side right -padx 30 -pady 5 -anchor w
  pack $win.top.level1 -side top -fill x -expand yes
  pack $win.top.level2 -side top -fill x -expand yes
  pack $win.top.level3 -side top -fill both -expand yes
  pack $win.top.level5 -side top -fill both -expand yes
  pack $win.top.level5.left -side left -fill both -expand yes
  pack $win.top.level5.right -side right -fill both -expand yes
  set desc_lab [label $win.top.level2.lab \
  -text [format "%-30s" "$gPB(new,desc,Label)"]]
  set desc_txt [tixScrolledText $win.top.level2.desc \
  -height 50 -width 400 -scrollbar y]
  [$desc_txt subwidget text] config -bg $paOption(tree_bg)
  [$desc_txt subwidget vsb]  config -width $paOption(trough_wd) \
  -troughcolor $paOption(trough_bg)
  pack $desc_lab -side left -padx 5 -pady 5 -anchor w
  pack $desc_txt -side right -padx 30 -pady 5 -anchor w
  tixLabelFrame $win.top.level3.lbf -label "$gPB(new,post_unit,Label)"
  set out_frame [$win.top.level3.lbf subwidget frame]
  pack $win.top.level3.lbf -side left -pady 10
  radiobutton $out_frame.inch -text "$gPB(new,inch,Label)" \
  -variable output_unit -anchor w  -value "Inches"
  radiobutton $out_frame.mm -text "$gPB(new,millimeter,Label)" \
  -variable output_unit -anchor w -value "Millimeters"
  pack $out_frame.inch $out_frame.mm -side left -padx 10 -pady 5
  tixLabelFrame $win.top.level5.left.bottom -label "$gPB(new,control,Label)"
  set fb [$win.top.level5.left.bottom subwidget frame]
  grid $win.top.level5.left.bottom -row 2 -pady 10 -sticky news
  tixOptionMenu $fb.contr      \
  -variable mach_controller \
  -options {
   entry.anchor e
   menubutton.width       30
  }
  [$fb.contr subwidget menubutton] config -font $tixOption(bold_font) \
  -bg  royalBlue -fg white
  pack $fb.contr -padx 5 -pady 2
  canvas $win.top.level5.right.can -width 300 -height 300
  $win.top.level5.right.can config -bg black -relief sunken
  pack $win.top.level5.right.can -fill both -expand yes -padx 5 \
  -pady 5
  global env
  image create photo myphoto -file $env(PB_HOME)/images/pb_hg500.gif
  $win.top.level5.right.can create image 150 150 -image myphoto
  tixLabelFrame $win.top.level5.left.top -label "$gPB(new,machine,Label)"
  set fa [$win.top.level5.left.top subwidget frame]
  grid $win.top.level5.left.top -row 1 -sticky news
  radiobutton $fa.mill -text "$gPB(new,mill,Label)" \
  -variable mach_type -anchor w \
  -value "Mill" -command "CB_MachType $win Mill $fa $fb"
  radiobutton $fa.lathe -text "$gPB(new,lathe,Label)" \
  -variable mach_type -anchor w \
  -value "Lathe" -command "CB_MachType $win Lathe $fa $fb"
  radiobutton $fa.wedm -text "$gPB(new,wire,Label)" \
  -variable mach_type -anchor w \
  -value "Wedm" -command "CB_MachType $win Wedm $fa $fb"
  radiobutton $fa.punch -text "$gPB(new,punch,Label)" \
  -variable mach_type -anchor w \
  -value "Punch" -command "CB_MachType $win Punch $fa $fb"
  tixOptionMenu $fa.axis      \
  -variable mach_axis     \
  -command  "CB_MachineAxisType $win" \
  -options {
   entry.anchor e
   menubutton.width       30
  }
  [$fa.axis subwidget menubutton] config -font $tixOption(bold_font) \
  -bg royalBlue -fg white
  grid $fa.mill -sticky w -padx 5 -pady 2
  grid $fa.lathe -sticky w -padx 5 -pady 2
  grid $fa.axis -sticky w -padx 5 -pady 2
  global paOption
  set label_list {"gPB(nav_button,cancel,Label)" \
  "gPB(nav_button,ok,Label)"}
  set cb_arr(gPB(nav_button,cancel,Label)) "UI_PB_NewCancel_CB $win"
  set cb_arr(gPB(nav_button,ok,Label)) "OpenNewFile $win"
  UI_PB_com_CreateButtonBox $win label_list cb_arr
  CB_MachType $win $mach_type $fa $fb
  UI_PB_GreyOutAllFileOpts
 }

#=======================================================================
proc UI_PB_NewCancel_CB { win } {
  global gPB
  UI_PB_EnableFileOptions
  wm withdraw $win
  UI_PB_com_SetStatusbar "$gPB(main,default,Status)"
 }

#=======================================================================
proc UI_PB_NewDestroy { args } {
  UI_PB_EnableFileOptions
 }

#=======================================================================
proc UI_PB_EnableFileOptions  { } {
  global gPB
  set mb $gPB(main_menu_bar).file.m
  $mb entryconfigure 1 -state normal
  $mb entryconfigure 2 -state normal
  if [catch { $mb entryconfigure 3 -state normal } result] { }
  $mb entryconfigure 4 -state disabled
  $mb entryconfigure 5 -state disabled
  $mb entryconfigure 6 -state disabled
  set mm $gPB(main_menu).tool
  [$mm subwidget new]  config -state normal
  [$mm subwidget open] config -state normal
  [$mm subwidget save] config -state disabled
  UI_PB_com_DismissActiveWindow [UI_PB_com_AskActiveWindow]
 }

#=======================================================================
proc CreateMachineTypeOptMenu { widget mach_type } {
  global mach_axis
  global gPB
  set opt_labels(Lathe,2)    "$gPB(new,lathe_2,Label)"
  set opt_labels(Lathe,4)    "$gPB(new,lathe_4,Label)"
  set opt_labels(Mill,3)     "$gPB(new,mill_3,Label)"
  set opt_labels(Mill,4T)    "$gPB(new,mill_4T,Label)"
  set opt_labels(Mill,4H)    "$gPB(new,mill_4H,Label)"
  set opt_labels(Mill,5HH)   "$gPB(new,mill_5HH,Label)"
  set opt_labels(Mill,5TT)   "$gPB(new,mill_5TT,Label)"
  set opt_labels(Mill,5HT)   "$gPB(new,mill_5HT,Label)"
  set opt_labels(Wedm,2)     "$gPB(new,wedm_2,Label)"
  set opt_labels(Wedm,4)     "$gPB(new,wedm_4,Label)"
  set opt_labels(Punch,P)    "$gPB(new,punch,Label)"
  set cur_opt_names [$widget.axis entries]
  foreach name $cur_opt_names \
  {
   $widget.axis delete $name
  }
  switch $mach_type \
  {
   "Mill"   {
    set opts { 3 4T 4H 5HH 5TT 5HT }
    $widget.axis config -state normal
   }
   "Lathe"  {
    set opts { 2 }
    $widget.axis config -state normal
   }
   "Wedm"   {
    set opts { 2 4 }
    $widget.axis config -state normal
   }
   "Punch"  {
    set opts { P }
    $widget.axis config -state disabled
   }
   default  {
    set opts ""
    set mach_axis ""
    $widget.axis config -state disabled
   }
  }
  foreach opt $opts \
  {
   $widget.axis add command $opt -label $opt_labels($mach_type,$opt)
  }
 }

#=======================================================================
proc CreateControllerOptMenu { widget mach_type } {
  global gPB
  set opts_cont { Generic Cincin Fanuc GE}
  set opt_labels_c(Generic)      "$gPB(new,generic,Label)"
  set opt_labels_c(AllnBrdy)     "$gPB(new,allen,Label)"
  set opt_labels_c(BrdgPrt)      "$gPB(new,bridge,Label)"
  set opt_labels_c(BrwnShrp)     "$gPB(new,brown,Label)"
  set opt_labels_c(Cincin)       "$gPB(new,cincin,Label)"
  set opt_labels_c(KrnyTrckr)    "$gPB(new,kearny,Label)"
  set opt_labels_c(Fanuc)        "$gPB(new,fanuc,Label)"
  set opt_labels_c(GE)           "$gPB(new,ge,Label)"
  set opt_labels_c(GN)           "$gPB(new,gn,Label)"
  set opt_labels_c(GddngLws)     "$gPB(new,gidding,Label)"
  set opt_labels_c(Heiden)       "$gPB(new,heiden,Label)"
  set opt_labels_c(Mazak)        "$gPB(new,mazak,Label)"
  set opt_labels_c(Seimens)      "$gPB(new,seimens,Label)"
  set cur_opt_names [$widget.contr entries]
  foreach name $cur_opt_names \
  {
   $widget.contr delete $name
  }
  foreach opt $opts_cont \
  {
   $widget.contr add command $opt -label $opt_labels_c($opt)
  }
 }

#=======================================================================
proc OpenNewFile {w} {
  global env
  global gPB
  global mach_type
  global mach_axis
  global mach_controller
  global pb_output_file
  global output_unit
  global axisoption
  global controller
  set controller $mach_controller
  set axisoption $mach_axis
  if { $mach_type != "Mill" && $mach_type != "Lathe" || \
  $controller != "Generic" } \
  {
   tk_messageBox -parent $w -type ok -icon question \
   -message "$gPB(msg,generic)"
   return
  }
  tixDisableAll $w
  set file_format { machine axis controller units }
  append stand_file_name pb
  foreach label $file_format \
  {
   switch $label \
   {
    "controller" {
     append stand_file_name _
     append stand_file_name $controller
    }
    "machine"    {
     append stand_file_name _
     append stand_file_name $mach_type
    }
    "axis"       {
     if { $axisoption != "" } \
     {
      append stand_file_name _
      append stand_file_name $axisoption
     }
    }
    "units"      {
     append stand_file_name _
     switch $output_unit \
     {
      "Inches"       { append stand_file_name "IN" }
      "Millimeters"  { append stand_file_name "MM" }
     }
    }
   }
  }
  set dot_index [string last . $pb_output_file]
  if { $dot_index != -1 } \
  {
   set pb_output_file [string range $pb_output_file 0 [expr $dot_index - 1]]
  }
  set pb_std_file $env(PB_HOME)/pblib/$stand_file_name.pui
  set ret_code [PB_Start $pb_std_file]
  if { $gPB(output_dir) == "" } \
  {
   set dir [file dirname $pb_output_file]
   if { $dir == "." } \
   {
    set dir [pwd]
   }
   set gPB(output_dir) $dir
  } else \
  {
   set dir $gPB(output_dir)
  }
  set file_name [file tail $pb_output_file]
  set pui_file $file_name.pui
  set def_file $file_name.def
  set tcl_file $file_name.tcl
  PB_int_SetPostOutputFiles dir pui_file def_file tcl_file
  UI_PB_com_DismissActiveWindow $w
  wm withdraw $w
  UI_PB_main_window
  update
  UI_PB_ActivateOpenFileOpts
  AcceptMachineToolSelection
  set gPB(session) NEW
  UI_PB_com_SetStatusbar "$gPB(machine,Status)"
 }

#=======================================================================
proc CB_MachType { win mach_type fa fb } {
  global gPB
  switch -- $mach_type \
  {
   "Lathe"    {
    set desc "$gPB(new,lathe,desc,Label)"
   }
   "Wedm"     {
    set desc "$gPB(new,wedm,desc,Label)"
   }
   "Punch"    {
    set desc "$gPB(new,punch,desc,Label)."
   }
   "Mill"     {
    set desc "$gPB(new,mill,desc,Label)"
   }
  }
  [$win.top.level2.desc subwidget text] delete 1.0 end
  [$win.top.level2.desc subwidget text] insert 1.0 $desc
  CreateMachineTypeOptMenu $fa $mach_type
  CreateControllerOptMenu $fb $mach_type
 }

#=======================================================================
proc CB_MachineAxisType { win args } {
  global gPB
  global mach_axis
  global mach_type
  set desc ""
  switch -- $mach_type \
  {
   "Wedm" {
    switch -- $mach_axis \
    {
     "2"  {
      set desc "$gPB(new,wedm_2,desc,Label)"
     }
     "4"  {
      set desc "$gPB(new,wedm_4,desc,Label)"
     }
    }
   }
   "Lathe" {
    switch -- $mach_axis \
    {
     "2" {
      set desc "$gPB(new,lathe_2,desc,Label)"
     }
     "4" {
      set desc "$gPB(new,lathe_4,desc,Label)"
     }
    }
   }
   "Mill"  {
    switch -- $mach_axis \
    {
     "3"  {
      set desc "$gPB(new,mill_3,desc,Label)"
     }
     "4H" {
      set desc "$gPB(new,mill_4H,desc,Label)"
     }
     "4T" {
      set desc "$gPB(new,mill_4T,desc,Label)"
     }
     "5TT" {
      set desc "$gPB(new,mill_5TT,desc,Label)"
     }
     "5HH" {
      set desc "$gPB(new,mill_5HH,desc,Label)"
     }
     "5HT" {
      set desc "$gPB(new,mill_5HT,desc,Label)"
     }
    }
   }
   "Punch" {
    switch -- $mach_axis \
    {
     "P"   {
      set desc "$gPB(new,punch,desc,Label)"
     }
    }
   }
  }
  [$win.top.level2.desc subwidget text] delete 1.0 end
  [$win.top.level2.desc subwidget text] insert 1.0 $desc
 }

#=======================================================================
proc AcceptMachineToolSelection { } {
  global axisoption gPB
  global mach_type
  global machData machTree
  if { [info exists machData] } \
  {
   set pb_book $gPB(book)
   set mctl_page_obj [lindex $Book::($pb_book,page_obj_list) 0]
   UI_PB_mach_MachDisplayParams $mctl_page_obj machData
  }
 }
