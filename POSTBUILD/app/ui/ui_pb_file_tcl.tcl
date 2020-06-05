#12
UI_PB_AddPatchMsg "2007.0.0" "<02-13-12>  Fix \"Post Properties\" option being grayed out"
if { ![info exists gPB(force_choose_cntl_type)] } {
 set gPB(force_choose_cntl_type) 0
}
if { ![info exists gPB(default_controller_type)] } {
 set gPB(default_controller_type) ""
}

#=======================================================================
proc UI_PB_OpenPost {} {
  global gPB
  global env
  global tcl_platform
  if { $gPB(use_info) } \
  {
   UI_PB_chelp_DisplayMenuItemCsh $gPB(file_menu)
   return
  }
  if { [lsearch -exact [package names] "stooop"] < 0 } {
   source $env(PB_HOME)/tcl/exe/stooop.tcl
   namespace import stooop::*
  }
  UI_PB_com_SetStatusbar "$gPB(open,Status)"
  UI_PB_file_GetWorkFileDir
  set file_name [file join $gPB(work_dir) $gPB(work_file)]
  if { ![file exists $file_name] } {
   set gPB(work_file) ""
  }
  if { $tcl_platform(platform) == "unix" } \
  {
   UI_PB_file_OpenPost_unx
   } elseif {$tcl_platform(platform) == "windows"} \
  {
   UI_PB_file_OpenPost_win
  }
 }

#=======================================================================
proc UI_PB_OpenVisitedPost { post } {
  global gPB
  global env
  if { $gPB(use_info) } \
  {
   UI_PB_chelp_DisplayMenuItemCsh $gPB(file_menu)
   return
  }
  set pui [file rootname $post].pui
  set def [file rootname $post].def
  set tcl [file rootname $post].tcl
  if { [info exist ::env(SUB_POST)] && $::env(SUB_POST) == 1 } \
  {
   if { ![file exists $def] } {
    PB_file_InitDefEnvforSubPostMode $pui def
   }
  }
  if { ![file exists $pui] || \
   ![file exists $def] || \
  ![file exists $tcl] } \
  {
   tk_messageBox -parent $gPB(top_window) -type ok -icon error \
   -title $gPB(msg,dialog,title) \
   -message "$gPB(msg,file_missing)."
   set i [lsearch $gPB(open_files_list) $post]
   set gPB(open_files_list) [lreplace $gPB(open_files_list) $i $i]
   UI_PB_AddVisitedPosts
   if [info exists gPB(master_pid)] {
    if [string match windows $::tcl_platform(platform)] {
     exec taskkill /f /pid [pid]
     } else {
     exec kill [pid]
    }
   }
   return TCL_ERROR
  }
  if { [lsearch -exact [package names] "stooop"] < 0 } {
   source $env(PB_HOME)/tcl/exe/stooop.tcl
   namespace import stooop::*
  }
  return [UI_PB_file_EditPost 0 $post 1]
 }

#=======================================================================
proc UI_PB_file_GetWorkFileDir { args } {
  global gPB env
  if { ![info exists gPB(open_files_list)] } {
   set gPB(open_files_list) [list]
  }
  if { ![info exists gPB(work_dir)] ||\
   ![file isdirectory [file nativename $gPB(work_dir)]] } {
   set gPB(work_dir) ""
  }
  if { $gPB(work_dir) == "" } {
   if { [llength $gPB(open_files_list)] == 0 } {
    set gPB(work_file) ""
    if [info exists env(HOME)] {
     if [catch {file exists "$env(HOME)"}] {
      set gPB(work_dir) "$env(PB_HOME)"
      } else {
      if [file exists "$env(HOME)"] {
       set gPB(work_dir) "$env(HOME)"
       } else {
       set gPB(work_dir) "$env(PB_HOME)"
      }
     }
     } else {
     set gPB(work_dir) "$env(PB_HOME)"
    }
    } else {
    set work_file [lindex $gPB(open_files_list) 0]
    set gPB(work_file) [file tail $work_file]
    set gPB(work_dir) [file dirname $work_file]
   }
  }
  if { ![info exists gPB(work_file)] } {
   set gPB(work_file) ""
  }
  set gPB(work_dir)  [file nativename $gPB(work_dir)]
  set gPB(work_file) [file nativename $gPB(work_file)]
 }

#=======================================================================
proc UI_PB_file_OpenPost_unx { } {
  global tixOption
  global paOption
  global gPB
  global env
  set win $gPB(top_window).open
  if { [winfo exists $win] } \
  {
   $win popup
   UI_PB_com_ClaimActiveWindow $win
   set fbox [$win subwidget fsbox]
   catch {
    $fbox config -directory $gPB(work_dir) \
    -value $gPB(work_file)
   }
   $fbox filter
   [$fbox subwidget types] pick 0
   if { $gPB(work_file) != "" } {
    [$fbox subwidget file] addhistory $gPB(work_file)
    [$fbox subwidget file] pick 0
   }
  } else \
  {
   tixExFileSelectDialog $win -command "UI_PB_file_EditPost $win"
   UI_PB_com_CreateTransientWindow $win "$gPB(open,title,Label)" \
   "600x400+200+100" "" "" "" "UI_PB_OpenCancel_CB $win"
   $win popup
   UI_PB_com_PositionWindow $win
   set fbox [$win subwidget fsbox]
   set ftypes [list \{*.pui\}\ \{$gPB(open,file_type_pui)\}]
   $fbox config -filetypes $ftypes
   catch {
    $fbox config -pattern "*.pui" \
    -directory $gPB(work_dir) \
    -value $gPB(work_file)
   }
   set fdir [[$fbox subwidget dir] subwidget entry]
   set file [[$fbox subwidget file] subwidget entry]
   if 0 {
    bind $fdir <KeyPress> "UI_PB_com_DisableSpaceKey %W %K"
    bind $fdir <KeyRelease> { %W config -state normal }
    bind $file <KeyPress> "UI_PB_com_DisableSpaceKey %W %K"
    bind $file <KeyRelease> { %W config -state normal }
   }
   bind $fdir <KeyPress> "UI_PB_com_DisableSpecialChars %W %K 1 1"
   bind $fdir <KeyRelease> { %W config -state normal }
   bind $file <KeyPress> "UI_PB_com_DisableSpecialChars %W %K 1 1"
   bind $file <KeyRelease> { %W config -state normal }
   [$fbox subwidget cancel] config -width 10 -bg $paOption(app_butt_bg) \
   -command "UI_PB_OpenCancel_CB $win"
   [$fbox subwidget ok]     config -bg $paOption(app_butt_bg) -width 10 \
   -text $gPB(nav_button,open,Label)
   [$fbox subwidget file] config -history yes -prunehistory yes
   [$fbox subwidget dir]  config -history yes -prunehistory yes
   $fbox filter
   [$fbox subwidget types] pick 0
   if { $gPB(work_file) != "" } {
    [$fbox subwidget file] addhistory $gPB(work_file)
    [$fbox subwidget file] pick 0
   }
  }
  if 0 {
   if { $gPB(work_file) != "" } {
    set file_list_box [[$fbox subwidget filelist] subwidget listbox]
    set selected_file_index [lsearch [$file_list_box get 0 end] $gPB(work_file)]
    if { $selected_file_index < 0 } { set selected_file_index 0 }
    $file_list_box selection set $selected_file_index
    $file_list_box activate $selected_file_index
    $file_list_box see $selected_file_index
   }
  }
  UI_PB_GrayOutAllFileOptions
 }

#=======================================================================
proc UI_PB_file_OpenPost_win {} {
  global tixOption
  global paOption
  global gPB
  global env
  set types {
   { {Post Builder Session} {.pui} }
  }
  UI_PB_com_ChangeCHelpState disabled
  if {[info exists env(MULTI_INTERP)] && $env(MULTI_INTERP) == 1} {
   UI_PB_GrayAndUnGrayWindowMenu gray
  }
  UI_PB_GrayOutAllFileOptions
  set acwin [UI_PB_com_AskActiveWindow]
  set status TCL_ERROR
  while { $status != "TCL_OK" } \
  {
   if { $::tcl_platform(platform) == "windows" && $::tcl_version >= 8.4 } {
    if {[info exists env(MULTI_INTERP)] && $env(MULTI_INTERP) == 1} {
     after 100 [list focus -force .widget]
    }
   }
   set filename [tk_getOpenFile -filetypes $types \
   -title "$gPB(open,title,Label)" \
   -parent $acwin \
   -defaultextension "pui" \
   -initialdir $gPB(work_dir) \
   -initialfile $gPB(work_file)]
   set win $acwin.__tk_filedialog
   set gPB(top_window).open $win
   UI_PB_com_ChangeCHelpState normal
   if {$filename == ""} { ;# File selection dialog exited abnormally... (X'ed).
    UI_PB_EnableFileOptions
    UI_PB_com_EnableProcess
    set status TCL_OK
    } else {               ;# File selected.
    set gPB(work_dir) [file dirname $filename]
    set status [UI_PB_file_EditPost $win $filename]
   }
   if { $status != "TCL_OK" } {
    UI_PB_DeleteDataBaseObjs
    global mom_sys_arr mom_kin_var mom_sim_arr
    PB_com_unset_var mom_sys_arr
    PB_com_unset_var mom_kin_var
    if [info exists mom_sim_arr] {PB_com_unset_var mom_sim_arr}
   }
  }
  if {[info exists env(MULTI_INTERP)] && $env(MULTI_INTERP) == 1} {
   UI_PB_GrayAndUnGrayWindowMenu ungray
  }
 }

#=======================================================================
proc UI_PB_OpenDestroy { win } {
  UI_PB_EnableFileOptions
 }

#=======================================================================
proc UI_PB_OpenCancel_CB { args } {
  global gPB
  if [llength $args] {
   set dialog_id [lindex $args 0]
   if [winfo exists $dialog_id] {
    $dialog_id popdown
   }
  }
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
proc UI_PB_GetPostVersion { FILE_NAME VERSION args } {
  global gPB
  upvar $FILE_NAME file_name
  upvar $VERSION version
  set file_id [open $file_name r]
  set kin_flag 0
  set units ""
  set machine ""
  set version "0.0.0.0"
  if { ![info exists gPB(JE_POST_DEV)] } {
   set gPB(JE_POST_DEV) 0
  }
  if { [string match "*.pui" $file_name] } {
   set gPB(JE_POST_DEV) 0
  }
  if { [gets $file_id line] >= 0 } \
  {
   if { [string match "*POSTBUILDER_VERSION*" $line] } \
   {
    set line_list [split $line =]
    set version [lindex $line_list 1]
   }
   while { [gets $file_id line] >= 0 } \
   {
    if [llength $args] {
     if [string match "#  Created by *" $line] {
      set gPB(post_created_by) [string range $line 11 end]
     }
     if [string match "#  with Post Builder *" $line] {
      set end_idx [expr [string length $line] - 2]
      set gPB(post_created_with) [string range $line 3 $end_idx]
     }
    }
    if { [string match "*.pui" $file_name] && \
     [string match "## JE_POST_DEV TRUE ##" [string trim $line]] } {
     set gPB(JE_POST_DEV) 1
    }
    switch -glob -- $line \
    {
     "## KINEMATIC VARIABLES START" { set kin_flag 1 }
     "## KINEMATIC VARIABLES END"   { set kin_flag 2 }
    }
    if { $kin_flag == 1 } \
    {
     set first_word [string trim [lindex $line 0]]
     set sec_word [string trim [lindex $line 1]]
     if { [string match "*mom_kin_output_unit*" $first_word] } \
     {
      set units $sec_word
      } elseif { [string match "*mom_kin_machine_type*" $first_word] } \
     {
      set machine $sec_word
     }
     } elseif { $kin_flag == 2 } \
    {
     break
    }
   }
   PB_com_GetMachAxisType $machine act_mach_type axis
  }
  close $file_id
  UI_PB_debug_ForceMsg "\n %%%%% gPB(JE_POST_DEV): $gPB(JE_POST_DEV)  $file_name  version: $version\n"
 }

#=======================================================================
proc UI_PB_file_IsOpened { pui_file } {
  global PID
  set idx [lsearch $PID(posts_name_list) $pui_file]
  if {$idx >= 0} {
   return [lindex $PID(posts_list) $idx]
   } else {
   return no
  }
 }

#=======================================================================
proc UI_PB_file_EditPost { dlg_id file_name args } {
  global gPB env
  if { [info exists gPB(auto_qc)] && $gPB(auto_qc) == 1} {
   set env(PB_UDE_ENABLED) 2
  }
  if { $env(PB_UDE_ENABLED) == 2 } {
   if [file exists [file rootname $file_name].cdl] {
    set env(PB_UDE_ENABLED) 1
    } else {
    set env(PB_UDE_ENABLED) 0
   }
  }
  set result 0
  if { [info exists env(MULTI_INTERP)] && $env(MULTI_INTERP) == 1 } {
   if { $dlg_id == 0 } {
    set gPB(action) "open_recent_post"
    } elseif { $dlg_id == 1 } {
    set gPB(action) "cmd_line_pui"
    } else {
    set gPB(action) "open"
   }
   set gPB(o_dlg_id) $dlg_id
   set gPB(o_file_name) $file_name
   set gPB(o_args) $args
   exec build_post.exe [comm::comm self] &
   set ::ret_cod ""
   vwait ::ret_cod
   return $::ret_cod
   } else {
   set gPB(edit_post_name) [file tail [file rootname $file_name]]
   set gPB(from_edit_module) 1
   set gPB(action) open
   set result [UI_PB_file_EditPost_mod $dlg_id $file_name $args]
  }
  set ::gPB(session) "EDIT"
  UI_PB_main_ViewPostFiles
  return $result
 }

#=======================================================================
proc UI_PB_file_EditPost_mod { dlg_id file_name args } {
  global gPB env
  UI_PB_SnapShotRuntimeObjs
  set top_win $gPB(top_window)
  set ret_code 0
  if { [info exists ::env(SUB_POST)] && $::env(SUB_POST) == 1 } {
   set ::env(SUB_POST_MODE) 0
   set ::env(UNIT_SUB_POST_MODE) 0
  }
  if { $file_name != "" } \
  {
   set dir [file dirname $file_name]
   if [file exists $dir] \
   {
    set gPB(work_dir) [file nativename $dir]
   }
  }
  set extension [file extension $file_name]
  if { [string compare $extension ".pui"] != 0 } \
  {
   if { ![info exists gPB(auto_qc)] || $gPB(auto_qc) != 1 } {
    tk_messageBox -parent $top_win -type ok -icon error \
    -title $gPB(msg,dialog,title) \
    -message "$gPB(msg,invalid_file)"
   }
   if [winfo exists $dlg_id] { $dlg_id popup }
   return TCL_ERROR
  }
  set pui [file rootname $file_name].pui
  if { ![file exists $pui] } \
  {
   if { ![info exists gPB(auto_qc)] || $gPB(auto_qc) != 1} {
    tk_messageBox -parent $top_win -type ok -icon error \
    -title $gPB(msg,dialog,title) \
    -message "$gPB(msg,file_missing)."
   }
   if [winfo exists $dlg_id] { $dlg_id popup }
   return TCL_ERROR
  }
  if [info exists gPB(master_pid)] {
   set is_opened [comm::comm send $gPB(master_pid) [list UI_PB_file_IsOpened $pui]]
   if ![string match $is_opened "no"] {
    UI_PB_EnableFileOptions
    comm::comm send $gPB(master_pid) [list UI_PB_GrayAndUnGrayWindowMenu ungray]
    comm::comm send $gPB(master_pid) [list UI_PB_com_EnableProcess]
    comm::comm send -async $gPB(master_pid) [list __main_SwitchPosts $is_opened]
    if [string match windows $::tcl_platform(platform)] {
     exec taskkill /f /pid [pid]
     } else {
     exec kill [pid]
    }
   }
  }
  PB_file_FindTclDefOfPui $pui tcl def
  if { [info exist ::env(SUB_POST)] && $::env(SUB_POST) == 1 } {
   PB_file_InitDefEnvforSubPostMode $pui def
  }
  set alter_unit_sub_post 0
  if { [info exist ::env(SUB_POST_MODE)] && $::env(SUB_POST_MODE) == 1 } \
  {
   if { [info exists ::env(UNIT_SUB_POST_MODE)] && $::env(UNIT_SUB_POST_MODE) == 1 } {
    set alter_unit_sub_post 1
   }
  }
  if { ![file exists $pui] || \
   ![file exists $def] || \
  ![file exists $tcl] } \
  {
   if { ![info exists gPB(auto_qc)] || $gPB(auto_qc) != 1} {
    tk_messageBox -parent $top_win -type ok -icon error \
    -title $gPB(msg,dialog,title) \
    -message "$gPB(msg,file_missing)."
   }
   if [winfo exists $dlg_id] { $dlg_id popup }
   return TCL_ERROR
  }
  set gPB(work_file) [file tail $file_name]
  global LicInfo
  if { $::disable_license == 0 } {
   if [file exists [file rootname $tcl]_tcl.txt] {
    set LicInfo(is_encrypted_file) 1
   }
  }
  UI_PB_DisplayProgress open
  set gPB(post_in_progress) 1
  after 100 "UI_PB_DestroyProgress"
  UI_PB_GetPostVersion file_name version get_history
  set gPB(post_controller_type) ""
  set gPB(new_enable_choose_vnc) 0
  set gPB(Old_PUI_Version) $version
  set block_address_flag 0
  set long_block_list [list]
  set long_address_list [list]
  if 0 {
   set ver_check [string compare $gPB(Postbuilder_PUI_Version) $version]
   UI_PB_debug_ForceMsg "%%% PUI versions: $gPB(Postbuilder_PUI_Version)  $version  $ver_check"
   if { $ver_check < 0 } \
   {
    set v1 [lindex [split $gPB(Postbuilder_PUI_Version) "."] 0].[lindex [split $gPB(Postbuilder_PUI_Version) "."] 1]
    set v2 [lindex [split $version "."] 0].[lindex [split $version "."] 1]
    set ver_check [string compare $v1 $v2]
   }
  }
  set ver_check [PB_pui_CompareVersion $gPB(Postbuilder_PUI_Version) $version]
  if { $ver_check < 0 } {
   set V2 [split $version "."]
   set M2 [lindex $V2 0]; set m2 [lindex $V2 1]
   set ver_check [PB_pui_CompareVersion $gPB(Postbuilder_PUI_Version) "$M2.$m2"]
  }
  if 0 {
   set v1 [split $gPB(Postbuilder_PUI_Version) "."]
   set v2 [split $version "."]
   set M1 [lindex $v1 0]; set m1 [lindex $v1 1]
   set M2 [lindex $v2 0]; set m2 [lindex $v2 1]
   set ver_check -1
   if { $M1 > $M2 } {
    set ver_check 1
    } elseif { $M1 == $M2 } {
    set ver_check 0
    if { $m1 > $m2 } {
     set ver_check 1
     } elseif { $m1 < $m2 } {
     set ver_check -1
    }
   }
  }
  UI_PB_debug_ForceMsg "%%% PUI versions: New = $gPB(Postbuilder_PUI_Version)  Old = $version  Version check = $ver_check"
  if [PB_file_is_JE_POST_DEV] {
   UI_PB_debug_ForceMsg "%%% Opening JE post ==> No conversion"
  }
  if { $ver_check > 0 } \
  {
   if { $alter_unit_sub_post } { ;# Units sub-post
    if [catch { PB_file_Open_AlterUnitSubPost $file_name } result] \
    {
     global errorInfo
     if [info exists gPB(err_msg)] {
      set errorInfo $gPB(err_msg)
      unset gPB(err_msg)
     }
     if { ![info exists gPB(auto_qc)] || $gPB(auto_qc) != 1 } {
      UI_PB_debug_ForceMsg "$errorInfo"
      tk_messageBox -parent $top_win -type ok -icon error \
      -title $gPB(msg,dialog,title) \
      -message "$errorInfo"
     }
     set ret_code 1
    }
    } else {
    UI_PB_file_GetPostControllerType pui legacy_controller_type
    set gPB(post_controller_type) $legacy_controller_type
    if { $gPB(force_choose_cntl_type) } \
    {
     if { $gPB(post_controller_type) == "" } \
     {
      if { ![info exists gPB(auto_qc)] || $gPB(auto_qc) != 1 } \
      {
       unset gPB(post_in_progress)
       UI_PB_DestroyProgress
       if [info exists gPB(new_machine_type_widget)] \
       {
        unset gPB(new_machine_type_widget)
       }
       PB_file_GetPostAttr $pui temp_mach_type temp_axis temp_unit
       if { [string compare $temp_mach_type "Wire EDM"] == 0 } \
       {
        set temp_mach_type "Wedm"
       }
       if [__ExistControllerTemplatesByMachType $temp_mach_type] \
       {
        set tempWm [toplevel $gPB(top_window).tempwm]
        UI_PB_com_CreateTransientWindow $tempWm \
        "$gPB(main,file,open,choose_cntl_type)" "+500+300" \
        "[list UI_PB_file_ChooseCntlFamily_CB $tempWm $pui]" \
        "" "CB_ChooseCtnlCancel $tempWm" ""
        UI_PB_com_PositionWindow $tempWm
        tkwait window $tempWm
       }
       UI_PB_DisplayProgress open
       set gPB(post_in_progress) 1
       after 100 "UI_PB_DestroyProgress"
       } elseif { [info exists gPB(auto_qc)] && $gPB(auto_qc) } \
      {
       set gPB(post_controller_type) $gPB(default_controller_type)
      }
     }
     } elseif { $gPB(post_controller_type) == "" } \
    {
     set gPB(post_controller_type) $gPB(default_controller_type)
    }
    if [UI_PB_file_SetCntlFamilyInfoForOldFile $file_name] \
    {
     if { $legacy_controller_type != "" } \
     {
      set gPB(legacy_controller_type_no_exist) 1
     }
    }
    if [catch { PB_OpenOldVersion $file_name } result] \
    {
     if [info exists gPB(err_msg)] {
      set result $gPB(err_msg)
      unset gPB(err_msg)
     }
     if { ![info exists gPB(auto_qc)] || $gPB(auto_qc) != 1 } {
      UI_PB_debug_ForceMsg "$result"
      tk_messageBox -parent $top_win -type ok -icon error \
      -title $gPB(msg,dialog,title) \
      -message "$result"
     }
     set ret_code 1
     } else {
     if { ![info exists gPB(post_history)] ||\
      [llength $gPB(post_history)] == 0 } {
      if { [info exists gPB(post_created_with)] && \
       [info exists gPB(post_created_by)] } {
       set gPB(post_history) ""
       lappend gPB(post_history) "Created $gPB(post_created_with)\
       $gPB(post_created_by)."
       unset gPB(post_created_with)
       unset gPB(post_created_by)
       } else {
       set ver [split $gPB(Old_PUI_Version) .]
       set ver [lreplace $ver end end]
       set v   [expr [lindex $ver 0] - 1999]
       set ver [lreplace $ver 0 0 $v]
       set ver [join $ver .]
       set gPB(post_history) ""
       lappend gPB(post_history) "Created with NX/Post Builder Version $ver."
      }
     }
     if { ![info exists gPB(post_controller)] } {
      set gPB(post_controller) "Unknown"
     }
     set block_address_flag [UI_PB_file_CheckNameForOldVersion "address" long_address_list]
     if $block_address_flag {
      set gPB(address_long_name_flag) 1
     }
     if [UI_PB_file_CheckNameForOldVersion "block" long_block_list] {
      set block_address_flag 1
      set gPB(block_long_name_flag) 1
     }
    }
   }
   } elseif { $ver_check < 0 } \
  {
   if { ![info exists gPB(auto_qc)] || $gPB(auto_qc) != 1 } {
    set ver [split $version .]
    set v   [expr [lindex $ver 0] - 1999]
    set ver [lreplace $ver 0 0 $v]
    set v1  [join $ver .]
    set ver [split $gPB(Postbuilder_PUI_Version) .]
    set v   [expr [lindex $ver 0] - 1999]
    set ver [lreplace $ver 0 0 $v]
    set v2  [join $ver .]
    tk_messageBox -parent $top_win -type ok -icon error \
    -title $gPB(msg,dialog,title) \
    -message "$gPB(msg,version_check) \
    ( PB $v1  =>  PB $v2 )"
   }
   set ret_code 1
  } else \
  {
   UI_PB_file_GetPostControllerType pui legacy_controller_type
   set gPB(post_controller_type) $legacy_controller_type
   if [UI_PB_file_SetCntlFamilyInfoForOldFile $file_name] \
   {
    if { $legacy_controller_type != "" } \
    {
     set gPB(legacy_controller_type_no_exist) 1
    }
   }
   if { $alter_unit_sub_post } {
    if [catch { PB_file_Open_AlterUnitSubPost $file_name } result] \
    {
     global errorInfo
     if [info exists gPB(err_msg)] {
      set errorInfo $gPB(err_msg)
      unset gPB(err_msg)
     }
     if { ![info exists gPB(auto_qc)] || $gPB(auto_qc) != 1} {
      UI_PB_debug_ForceMsg "$errorInfo"
      tk_messageBox -parent $top_win -type ok -icon error \
      -title $gPB(msg,dialog,title) \
      -message "$errorInfo"
     }
     set ret_code 1
    }
    } else {
    if { [info exists gPB(legacy_controller_type_no_exist)] && $gPB(legacy_controller_type_no_exist) } {
     if [catch { PB_OpenOldVersion $file_name 1 } result] \
     {
      set ret_code 1
     }
     } else {
     if [catch { PB_file_Open $file_name } result] \
     {
      set ret_code 1
     }
    }
    if { $ret_code } \
    {
     global errorInfo
     if [info exists gPB(err_msg)] {
      set errorInfo $gPB(err_msg)
      unset gPB(err_msg)
     }
     if { ![info exists gPB(auto_qc)] || $gPB(auto_qc) != 1 } {
      UI_PB_debug_ForceMsg "$errorInfo"
      tk_messageBox -parent $top_win -type ok -icon error \
      -title $gPB(msg,dialog,title) \
      -message "$errorInfo"
     }
    }
   }
  }
  if { $ret_code } \
  {
   if [winfo exists $dlg_id] {
    UI_PB_com_DismissActiveWindow $dlg_id
    UI_PB_OpenCancel_CB $dlg_id
   }
   if { [llength $args] == 0 } { ;# Not editing a visited Post... redisplay file open dialog.
    global tcl_platform
    if { $tcl_platform(platform) == "unix" } {
     UI_PB_file_OpenPost_unx
    }
   }
   PB_com_unset_var gPB(post_in_progress)
   return TCL_ERROR
  }
  UI_PB_file_CheckMachResolution
  set pui_file [file tail $file_name]
  PB_int_ReadPostFiles dir def_file tcl_file
  PB_int_SetPostOutputFiles dir pui_file def_file tcl_file
  set gPB(Output_Dir) $dir
  update
  if { [info exists LicInfo(post_license)] } {
   if { [info exists ::__ADD_NULL_LICENSE] && $::__ADD_NULL_LICENSE } {
    if { [string match "UG_POST_EXE" [lindex $LicInfo(post_license) 0]] } {
     set LicInfo(post_license) "NULL_LICENSE 000"
    }
   }
  }
  if { $::disable_license == 0 } {
   if { [info exists LicInfo(is_encrypted_file)] && $LicInfo(is_encrypted_file) == 1 } {
    if { $gPB(PB_LICENSE) == "UG_POST_AUTHOR" && $LicInfo(SITE_ID_IS_OK_FOR_PT) == 1 } {
     if { [string length $gPB(lic_list)] == 0 } {
      set LicInfo(user_right_limit) YES
      __Pause "1. set LicInfo(user_right_limit) YES"
      } else {
      if { [info exists gPB(lic_list)] && $gPB(lic_list) != "" } {
       if { [info exists LicInfo(post_license)] && \
        [lsearch $gPB(lic_list) $LicInfo(post_license)] >= 0 } {
        set LicInfo(user_right_limit) NO
        } else {
        if { ![string match "*UG_POST_EXE*" $LicInfo(post_license)] } {
         set LicInfo(user_right_limit) YES
         } else {
         set LicInfo(user_right_limit) NO
        }
        __Pause "2. set LicInfo(user_right_limit) $LicInfo(user_right_limit) LicInfo(post_license) = $LicInfo(post_license)"
       }
       } else {
       set LicInfo(user_right_limit) YES
       __Pause "3. set LicInfo(user_right_limit) YES"
      }
     }
     if { [info exists ::__ADD_NULL_LICENSE] && $::__ADD_NULL_LICENSE } {
      if { [info exists LicInfo(post_license)] && \
       [string match "NULL_LICENSE" [lindex $LicInfo(post_license) 0]] } {
       set LicInfo(user_right_limit) NO
      }
     }
     } else {  ;# !UG_POST_AUTHOR || !LicInfo(SITE_ID_IS_OK_FOR_PT)
     if { $gPB(PB_LICENSE) == "UG_POST_AUTHOR" && $LicInfo(SITE_ID_IS_OK_FOR_PT) == 0 } {
      if { [string length $gPB(lic_list)] == 0 } {
       set LicInfo(user_right_limit) YES
       __Pause "4. set LicInfo(user_right_limit) YES"
       } else {
       if { [lsearch $gPB(lic_list) $LicInfo(post_license)] >= 0 } {
        set LicInfo(user_right_limit) NO
        } else {
        set LicInfo(user_right_limit) YES
       }
       __Pause "5. set LicInfo(user_right_limit) $LicInfo(user_right_limit)"
      }
      } else {
      set LicInfo(user_right_limit) YES
      __Pause "6. set LicInfo(user_right_limit) YES $gPB(PB_LICENSE) $LicInfo(SITE_ID_IS_OK_FOR_PT)"
     }
    }
    } else {
    set LicInfo(user_right_limit)  NO
   }
  }
  if { $alter_unit_sub_post } {
   set cmd "UI_PB_main_window_unit_sub"
   } else {
   set cmd "UI_PB_main_window"
  }
  if [catch { eval $cmd } result] \
  {
   if { ![info exists gPB(auto_qc)] || $gPB(auto_qc) != 1 } {
    tk_messageBox -parent $top_win -type ok -icon error \
    -title $gPB(msg,dialog,title) \
    -message "$gPB(msg,file_corruption) : \n$result"
   }
   PB_com_unset_var gPB(post_in_progress)
   return TCL_ERROR
  } else \
  {
   if [winfo exists $dlg_id] \
   {
    UI_PB_com_DismissActiveWindow $dlg_id
   }
  }
  if { [info exists LicInfo(is_encrypted_file)] && $LicInfo(is_encrypted_file) == 1 } {
   if { [info exists LicInfo(post_license)] } {
    set license [lindex $LicInfo(post_license) 0]
    if { [string match "UG_POST_EXE" $license] } { set license "NULL_LICENSE" }
    set title "$gPB(Postbuilder_Release) - $gPB(encrypt,license,Label) $license"
    UI_PB_ChangeTopWinTitle $title
   }
   } else {
   if [info exists gPB(def_title)] {
    UI_PB_ChangeTopWinTitle $gPB(def_title)
   }
  }
  update
  UI_PB_ActivateOpenFileOpts
  if { !$alter_unit_sub_post && ![PB_is_probe_post] } {
   AcceptMachineToolSelection
  }
  set gPB(session) EDIT
  set file_name [join [split $file_name "\\"] "/"]
  if { ![info exists gPB(auto_qc)] || !$gPB(auto_qc) } {
   if [info exists gPB(open_files_list)] {
    set gPB(open_files_list) [ladd $gPB(open_files_list) 0 $file_name "no_dup"]
    } else {
    lappend gPB(open_files_list) $file_name
   }
  }
  if { $file_name != "" } {
   set gPB(work_dir) [file dirname $file_name]
  }
  UI_PB_com_SetStatusbar "$gPB(machine,Status)"
  PB_com_unset_var gPB(post_in_progress)
  UI_PB_DestroyProgress
  if { ![info exists gPB(auto_qc)] || $gPB(auto_qc) != 1 } {
   if { [info exists ::disable_license] && $::disable_license == 0 } {
    if { [info exists ::LicInfo(user_right_limit)] } {
     if { $::LicInfo(user_right_limit) != "NO" } {
      $gPB(file_menu) entryconfigure $gPB(menu_index,file,save_as) -state disabled
      tk_messageBox -message $gPB(msg,limit_msg) -icon info -parent $gPB(main_window)
      } else {
      if { [info exists ::LicInfo(is_encrypted_file)] && $::LicInfo(is_encrypted_file) == 1 } {
       if 1 {
        global LicInfo
        set is_user_internal [__file_is_SiteID_UG_internal $gPB(PB_SITE_ID)]
        set is_post_internal [__file_is_SiteID_UG_internal $LicInfo(post_site_id)]
        if { $is_user_internal && $is_post_internal } {
         set gPB(PB_SITE_ID)  $LicInfo(post_site_id)
         set LicInfo(SITE_ID_IS_OK_FOR_PT) 1
         set is_author 1
        }
       }
       if { $gPB(PB_LICENSE) == "UG_POST_AUTHOR" && $::LicInfo(SITE_ID_IS_OK_FOR_PT) == 0 } {
        if { [lsearch $gPB(lic_list) $::LicInfo(post_license)] >= 0 } {
         $gPB(file_menu) entryconfigure $gPB(menu_index,file,save_as) -state disabled
         set msg "$gPB(msg,limit_to_change_license)\n$gPB(PB_LICENSE) is $::LicInfo(SITE_ID_IS_OK_FOR_PT)."
         tk_messageBox -message $msg -icon info -parent $gPB(main_window)
        }
       }
      }
     }
    }
   }
   if $block_address_flag {
    UI_PB_file_ShowLongNameWarning long_block_list long_address_list
   }
  }
  return TCL_OK
 }

#=======================================================================
proc UI_PB_file_ChooseCntlFamily_CB { w file_name } {
  global gPB
  global paOption
  set cbx [tix getbitmap cbxarrow]
  tixLabelFrame $w.cntltype -label $gPB(machine,info,controller_type,Label)
  pack $w.cntltype -side top -pady 5
  set family_frame [$w.cntltype subwidget frame]
  entry $family_frame.ent -width 31 -relief sunken -bd 2 \
  -textvariable gPB(mach_sys_controller)
  if ![string compare $::tix_version 4.1] \
  {
   $family_frame.ent config -state disabled
  } else \
  {
   $family_frame.ent config -readonlybackground lightblue -state readonly
  }
  menubutton $family_frame.but -bitmap $cbx -width 17 -height 20 -relief raised
  if [winfo exists gPB(open_family_opt_menu)] \
  {
   destroy $gPB(open_family_opt_menu)
  }
  set gPB(open_family_opt_menu) [menu $family_frame.but.family_menu -tearoff 0]
  $family_frame.but configure -menu $gPB(open_family_opt_menu)
  pack $family_frame.ent $family_frame.but -side left -padx 5 -pady 5
  set btnFrm [frame $w.btn -width 40 -height 20]
  set okBtn     [button $btnFrm.ok -text $gPB(nav_button,ok,Label) \
  -width 8 -bg $paOption(app_butt_bg) \
  -command "CB_ChooseCtnlOK $w"]
  set cancelBtn [button $btnFrm.cancel -text $gPB(nav_button,cancel,Label) \
  -width 8 -bg $paOption(app_butt_bg) \
  -command "CB_ChooseCtnlCancel $w"]
  pack $btnFrm -pady 8
  pack $okBtn $cancelBtn -side left -padx 20
  set mach_type ""
  set axis ""
  set unit ""
  PB_file_GetPostAttr $file_name mach_type axis unit
  if { [string compare $mach_type "Wire EDM"] == 0 } \
  {
   set mach_type "Wedm"
  }
  set gPB(new_machine_type) $mach_type
  global g_family_item_count
  set g_family_item_count [CreateCntlFamilyOptMenu $gPB(open_family_opt_menu) $mach_type]
  __InvokeFamilySelection $gPB(open_family_opt_menu) $gPB(default_controller_type)
 }

#=======================================================================
proc CB_ChooseCtnlOK {w} {
  global gPB
  if [string match "Generic" gPB(post_controller_type)] \
  {
   CB_ChooseCtnlCancel $w
  } else \
  {
   destroy $w
  }
 }

#=======================================================================
proc CB_ChooseCtnlCancel {w} {
  global gPB
  set gPB(post_controller_type) ""
  set gPB(mach_sys_controller) ""
  set gPB(cntl_sub_folder) ""
  set gPB(cntl_sub_type) 0
  if { ![string match "windows*" $::tcl_platform(platform)] } \
  {
   set gPB(cntl_sub_sub_folder) ""
  }
  destroy $w
 }

#=======================================================================
proc __file_ContinueAutoQC { args } {
  set wlist [tixDescendants .]
  foreach witem $wlist {
   if [string match "Toplevel" [winfo class $witem]] {
    UI_PB_debug_ForceMsg "toplevel==$witem"
   }
  }
  if 0 {
   set err_msg_win [UI_PB_com_AskActiveWindow].__tk__messagebox
   if [winfo exists $err_msg_win] {
    destroy $err_msg_win
    } else {
    global gPB
    set err_msg_win $gPB(top_window).__tk__messagebox
    if [winfo exists $err_msg_win] {
     destroy $err_msg_win
    }
   }
  }
 }

#=======================================================================
proc __ValidateCurrentTab { args } {
  global gPB
  if { [info exist ::env(SUB_POST_MODE)] && $::env(SUB_POST_MODE) == 1 } \
  {
   if { [info exists ::env(UNIT_SUB_POST_MODE)] && $::env(UNIT_SUB_POST_MODE) == 1 } {
    global mom_kin_var
    set top_page_list $Book::($gPB(book),page_obj_list)
    set page_obj [lindex $top_page_list 0]
    set empty_enty 0
    foreach var $gPB(mach_mom_kin_var_list) {
     if { [info exists mom_kin_var($var)] && ![string compare [string trim $mom_kin_var($var)] ""] } {
      set empty_enty 1
      break
     }
    }
    if { $empty_enty } {
     tk_messageBox -parent [UI_PB_com_AskActiveWindow] \
     -message "$gPB(machine,empty_entry_err,msg)" \
     -icon error
     return 0
     } else {
     return 1
    }
   }
  }
  set top_page_list $Book::($gPB(book),page_obj_list)
  switch $Book::($gPB(book),current_tab) {
   "0" { ;#<01-19-09 lxy> Validate empty entries on Machine Tool page.
    set page_obj [lindex $top_page_list 0]
    if { [UI_PB_mach_SignalEmptyEntry $page_obj] } {
     return 0
    }
   }
   "1" { ;#<03-31-09 wbh> Validate Macro page on Program & Tool Path page.
    set book_obj $Page::([lindex $top_page_list 1],book_obj)
    switch $Book::($book_obj,current_tab) {
     "3" { ;#<03-22-10 lxy> Validate the consistency between value and Format.
      set fmt_err [UI_PB_ads_ValidateAllFormats]
      if { $fmt_err } {
       UI_PB_fmt_DisplayErrorMessage $fmt_err
       return 0
      }
     }
     "7" {
      set pass 0
      set err_msg ""
      set func_page [lindex $Book::($book_obj,page_obj_list) 7]
      set pass [UI_PB_func_CheckFuncFormat $func_page err_msg]
      if {$pass == 1} {
       tk_messageBox -parent [UI_PB_com_AskActiveWindow] \
       -type ok -icon error -message $err_msg
       return 0
      }
      if [info exists Page::($func_page,active_func_obj)] {
       set func_obj $Page::($func_page,active_func_obj)
       UI_PB_func_SaveFuncInfo $func_page $func_obj
      }
     }
    }
   }
   "2" {
    set book_obj $Page::([lindex $top_page_list 2],book_obj)
    switch $Book::($book_obj,current_tab) {
     "0" {
      if [UI_PB_file_CheckNameForOldVersion "block" first_long_name 0] {
       tk_messageBox -parent [UI_PB_com_AskActiveWindow] \
       -type ok -icon error \
       -message "$first_long_name : $gPB(address,maximum_name_msg)"
       return 0
      }
     }
     "1" {
      set page_obj [lindex $Book::($book_obj,page_obj_list) 1]
      set err_msg ""
      if { [UI_PB_add_ValidateFormat $page_obj err_msg] } {
       UI_PB_mthd_DisplayErrMsg "$err_msg"
       return 0
      }
      if [UI_PB_file_CheckNameForOldVersion "address" first_long_name 0] {
       tk_messageBox -parent [UI_PB_com_AskActiveWindow] \
       -type ok -icon error \
       -message "$first_long_name : $gPB(address,maximum_name_msg)"
       return 0
      }
     }
     "2" {
      set fmt_page_flag_detail [UI_PB_fmt_Validate]
      if { $fmt_page_flag_detail } {
       UI_PB_fmt_DisplayErrorMessage $fmt_page_flag_detail
       return 0
      }
     }
     "3" {
      set pass 0
      set error_code 0
      set check_display 2
      UI_PB_ads_ValidateIncludeItems pass error_code $check_display
      if {$pass == 1} {
       return 0
      }
     }
    }
   }
   "3" { ;#<02-19-09 lxy> Output Settings
    set book_obj $Page::([lindex $top_page_list 3],book_obj)
    set ret_flag [UI_PB_list_ValidatePrevPageParam book_obj]
    if $ret_flag {
     UI_PB_list_ErrorPrevPage book_obj
     return 0
     } else {
     UI_PB_list_ApplyListObjAttr book_obj
    }
   }
   "4" { ;# Virtual N/C Controller
    set book_obj $Page::([lindex $top_page_list 4],book_obj)
    switch $Book::($book_obj,current_tab) {
     "0" { ;# ISV definition Page
      set bottom_page_obj [lindex $Book::($book_obj,page_obj_list) $Book::($book_obj,current_tab)]
      set tree $Page::($bottom_page_obj,tree)
      set h [$tree subwidget hlist]
      set def_item [$h selection get]
      if { ![string compare $def_item 0.2.1] && [UI_PB_isv_setup_ValidateToolname 0] } {
       UI_PB_isv_setup_ValidateToolname 1
       return 0
       } elseif {[UI_PB_isv_setup_ValidateEmptyEntry $def_item]} {
       tk_messageBox -parent [UI_PB_com_AskActiveWindow] \
       -message $gPB(machine,empty_entry_err,msg) \
       -icon error
       return 0
      }
     }
    }
   }
  }
 }

#=======================================================================
proc __ValidateMaxSeqNum { args } {
  global gPB
  if { [info exist ::env(SUB_POST_MODE)] && $::env(SUB_POST_MODE) == 1 } \
  {
   if { [info exists ::env(UNIT_SUB_POST_MODE)] && $::env(UNIT_SUB_POST_MODE) == 1 } {
    return 1
   }
  }
  set pb_book_id        $Book::($gPB(book),book_id)
  set pb_book_page_list $Book::($gPB(book),page_obj_list)
  set current_book_tab  $Book::($gPB(book),current_tab)
  set chap    [lindex $pb_book_page_list $current_book_tab]
  if { $current_book_tab == 1 } {
   set sect    $Page::($chap,book_obj)
   set sect_id $Book::($sect,book_id)
   set page_tab $Book::($sect,current_tab)
   set page_obj [lindex $Book::($sect,page_obj_list) $page_tab]
   if { $page_tab == 3 } {
    set max [UI_PB_ads_ValidateMaxN]
    if { $max } {
     tk_messageBox -parent [UI_PB_com_AskActiveWindow] \
     -type ok -icon error \
     -message "$gPB(msg,add_max1) N $gPB(msg,add_max2) $max."
     return 0
    }
   }
  }
  if { $current_book_tab == 2 } {
   set sect    $Page::($chap,book_obj)
   set sect_id $Book::($sect,book_id)
   set page_tab $Book::($sect,current_tab)
   set page_obj [lindex $Book::($sect,page_obj_list) $page_tab]
   if { $page_tab == 1 } {
    global ADDRESSOBJATTR
    global mom_sys_arr
    set tmp $mom_sys_arr(seqnum_max)
    set mom_sys_arr(seqnum_max) $ADDRESSOBJATTR(4)
    set max [UI_PB_ads_ExceedMaxSeqNum $ADDRESSOBJATTR(1)]
    set mom_sys_arr(seqnum_max) $tmp
    if $max {
     tk_messageBox -parent [UI_PB_com_AskActiveWindow] \
     -type ok -icon error \
     -message "$gPB(msg,add_max1) N $gPB(msg,add_max2) $max."
     return 0
    }
   }
   if { $page_tab == 3 } {
    set max [UI_PB_ads_ExceedMaxSeqNum]
    if $max {
     tk_messageBox -parent [UI_PB_com_AskActiveWindow] \
     -type ok -icon error -message "$gPB(msg,seq_num_max) $max."
     return 0
    }
   }
  }
  return 1
 }

#=======================================================================
proc UI_PB_SavePost { args } {
  global env
  if { [info exists env(MULTI_INTERP)] && $env(MULTI_INTERP) == 1 } {
   global gPB
   if [info exists gPB(master_pid)] {
    UI_PB_SavePost_mod $args
    } else {
    global PID
    comm::comm send $PID(activated) [list UI_PB_SavePost_mod $args]
   }
   } else {
   UI_PB_SavePost_mod $args
  }
  UI_PB_main_ViewPostFiles
 }

#=======================================================================
proc UI_PB_SavePost_mod { args } {
  global gPB
  if { $gPB(use_info) } \
  {
   UI_PB_chelp_DisplayMenuItemCsh $gPB(file_menu)
   return
  }
  if { [__ValidateCurrentTab] == 0 } {
   if {[info exists ::do_close] && $::do_close == 1} {
    set ::validation_result fail
   }
   return
  }
  if { [__ValidateMaxSeqNum] == 0 } {
   return
  }
  if { [__ValidateLongName] == 0 } {
   return
  }
  if { $gPB(session) == "NEW" } \
  {
   UI_PB_SavePostAs
   global tcl_platform
   if { $tcl_platform(platform) == "unix" } \
   {
    tkwait variable gPB(session)
   }
  } else \
  {
   if { [UI_PB_file_CheckMachResolution "Pend"] == 0 } \
   {
    return
   }
   if { ![info exist ::gPB(diff_post_flag)] } {
    set __save_post [PB_file_DiffPostObjects]
    } else {
    set __save_post 1
   }
   if { $__save_post } {
    UI_PB_save_a_post
   }
   PB_com_unset_var ::gPB(diff_post_flag)
  }
 }

#=======================================================================
proc UI_PB_SavePostAs { args } {
  global env gPB
  set l [info level]
  if { $l == 1 } {
   if { [info exists env(MULTI_INTERP)] && $env(MULTI_INTERP) == 1 } {
    global PID
    comm::comm send $PID(activated) [list set gPB(backup_method) "NO_BACKUP"]
    comm::comm send $PID(activated) [list UI_PB_SavePostAs_mod $args]
    comm::comm send $PID(activated) [list set gPB(backup_method) $gPB(backup_method)]
    } else {
    set gPB(backup_method_org) $gPB(backup_method)
    set gPB(backup_method) "NO_BACKUP"
    UI_PB_SavePostAs_mod $args
   }
   } else {
   UI_PB_SavePostAs_mod $args
  }
  UI_PB_main_ViewPostFiles
 }

#=======================================================================
proc UI_PB_SavePostAs_mod { args } {
  global gPB
  global tcl_platform
  global gpb_prev_status
  global env
  if { $gPB(use_info) } \
  {
   UI_PB_chelp_DisplayMenuItemCsh $gPB(file_menu)
   return
  }
  if { [__ValidateMaxSeqNum] == 0 } {
   return
  }
  if { [__ValidateCurrentTab] == 0 } {
   return
  }
  if { [__ValidateLongName] == 0 } {
   return
  }
  if { [UI_PB_file_CheckMachResolution "Pend"] == 0 } {
   return
  }
  if [info exists gPB(master_pid)] {
   set gpb_prev_status [comm::comm send $gPB(master_pid) [list set gPB(menu_bar_status)]]
   } else {
   set gpb_prev_status $gPB(menu_bar_status)
  }
  UI_PB_com_SetStatusbar "$gPB(save_as,Status)"
  if { [string match "EDIT" $gPB(session)] } {
   set gPB(post_saved_from) $Post::($::post_object,post_name)
  }
  UI_PB_select_license_for_post [set select_lic 1]
  UI_PB_file_GetWorkFileDir
  global pb_output_file
  if { $gPB(session) == "NEW" } {
   if { [info exists pb_output_file] } {
    set gPB(work_file) [file tail $pb_output_file.pui]
   }
  }
  if { $tcl_platform(platform) == "unix" } \
  {
   UI_PB_file_SavePostAs_unx
   } elseif { $tcl_platform(platform) == "windows" } \
  {
   UI_PB_file_SavePostAs_win
  }
  set pb_output_file [file rootname [file join $gPB(work_dir) $gPB(work_file)]]
 }

#=======================================================================
proc UI_PB_file_SavePostAs_unx { args } {
  global tixOption
  global paOption
  global gPB
  global gpb_file_ext
  global gpb_pui_file
  global gpb_def_file
  global gpb_tcl_file
  PB_int_ReadPostOutputFiles cur_dir gpb_pui_file gpb_def_file gpb_tcl_file
  set gpb_file_ext "pui"
  set win $gPB(main_window).save_as
  set act_win [UI_PB_com_AskActiveWindow]
  if { [winfo exists $win] } \
  {
   $win popup
   wm transient $win $act_win
   UI_PB_com_ClaimActiveWindow $win
   set fbox [$win subwidget fsbox]
   $fbox config -directory $gPB(work_dir) \
   -value $gPB(work_file)
   $fbox filter
   [$fbox subwidget types] pick 0
   if { $gPB(work_file) != "" } {
    [$fbox subwidget file] addhistory $gPB(work_file)
    [$fbox subwidget file] pick 0
    [[$fbox subwidget file] subwidget entry] selection range 0 end
   }
   UI_PB_com_DisableMain
  } else \
  {
   tixExFileSelectDialog $win -command "UI_PB_SavePbFiles_unx $win"
   UI_PB_com_CreateTransientWindow $win "$gPB(save_as,title,Label)" \
   "600x400+200+100" "" "" "" "UI_PB_SaveAsCancel_CB $win"
   set fbox [$win subwidget fsbox]
   UI_PB_com_PositionWindow $win
   set ftypes [list \{*.pui\}\ \{$gPB(save_as,file_type_pui)\}]
   $fbox config -filetypes $ftypes
   [$fbox subwidget cancel] config -width 10 -bg $paOption(app_butt_bg) \
   -command "UI_PB_SaveAsCancel_CB $win"
   [$fbox subwidget ok]     config -width 10 -bg $paOption(app_butt_bg) \
   -text $gPB(nav_button,save,Label)
   $win popup
   wm transient $win $act_win
   set fdir [[$fbox subwidget dir] subwidget entry]
   set file [[$fbox subwidget file] subwidget entry]
   if 0 {
    bind $fdir <KeyPress> "UI_PB_com_DisableSpaceKey %W %K"
    bind $fdir <KeyRelease> { %W config -state normal }
    bind $file <KeyPress> "UI_PB_com_DisableSpaceKey %W %K"
    bind $file <KeyRelease> { %W config -state normal }
   }
   set allow_minus 1; set allow_1st_underscore 1
   bind $fdir <KeyPress> "UI_PB_com_DisableSpecialChars %W %K $allow_minus $allow_1st_underscore"
   bind $fdir <KeyRelease> { %W config -state normal }
   bind $file <KeyPress> "UI_PB_com_DisableSpecialChars %W %K $allow_minus $allow_1st_underscore"
   bind $file <KeyRelease> { %W config -state normal }
   $fbox config -pattern "*.pui" \
   -directory $gPB(work_dir) \
   -value $gPB(work_file)
   [$fbox subwidget file] config -history yes -prunehistory yes
   [$fbox subwidget dir]  config -history yes -prunehistory yes
   [$fbox subwidget dirlist] config -browsecmd "__file_SaveAsDirCmd_unx $fbox"
   $fbox filter
   [$fbox subwidget types] pick 0
   if { $gPB(work_file) != "" } {
    [$fbox subwidget file] addhistory $gPB(work_file)
    [$fbox subwidget file] pick 0
    [[$fbox subwidget file] subwidget entry] selection range 0 end
   }
   UI_PB_com_DisableMain
  }
  UI_PB_GrayOutAllFileOptions
  set gPB(save_as_now) 1
  if [info exists gPB(master_pid)] {
   comm::comm send -async $gPB(master_pid) [list set gPB(save_as_now) 1]
  }
  $gPB(main_menu_bar).file.m entryconfigure $gPB(menu_index,file,exit) -state disabled
 }

#=======================================================================
proc __file_SaveAsDirCmd_unx { fbox dir } {
  $fbox config -directory $dir
  $fbox filter
  [$fbox subwidget file] pick 0
 }

#=======================================================================
proc UI_PB_file_SavePostAs_win { args } {
  global gPB
  global gpb_file_ext
  global gpb_pui_file
  global gpb_def_file
  global gpb_tcl_file
  global gpb_prev_status
  PB_int_ReadPostOutputFiles cur_dir gpb_pui_file gpb_def_file \
  gpb_tcl_file
  set gpb_file_ext "pui"
  set types {
   { {Post Builder Session} {.pui} }
  }
  UI_PB_com_ChangeCHelpState disabled
  set acwin [UI_PB_com_AskActiveWindow]
  set win $acwin.__tk_filedialog
  set gPB(main_window).save_as $win
  UI_PB_com_ClaimActiveWindow $win
  UI_PB_com_DisableMain
  UI_PB_GrayOutAllFileOptions
  if [info exists gPB(master_pid)] {
   comm::comm send -async $gPB(master_pid) [list UI_PB_GrayAndUnGrayWindowMenu gray 0]
  }
  set gPB(save_as_now) 1
  if [info exists gPB(master_pid)] {
   comm::comm send -async $gPB(master_pid) \
   {$gPB(main_menu_bar).file.m entryconfigure $gPB(menu_index,file,exit) -state disabled}
   comm::comm send -async $gPB(master_pid) [list set gPB(save_as_now) 1]
   } else {
   $gPB(main_menu_bar).file.m entryconfigure $gPB(menu_index,file,exit) -state disabled
  }
  while { 1 } {
   set filename [tk_getSaveFile -filetypes $types \
   -title "$gPB(save_as,title,Label)" \
   -defaultextension "pui" \
   -initialfile $gPB(work_file) \
   -initialdir $gPB(work_dir) \
   -parent $acwin]
   if { 0 && [UI_PB_com_hasSpecialChars [file tail $filename]] } {
    tk_messageBox -parent $acwin -type ok -icon error \
    -title $gPB(msg,dialog,title) \
    -message "[file tail $filename]\n$gPB(msg,filename_with_spec_char)\n \\\/\:\*\?\"\<\>\|"
    } else {
    if [info exists gPB(master_pid)] {
     set res [comm::comm send $gPB(master_pid) [list UI_PB_com_CanBeOverwrited [comm::comm self] $filename]]
     if { $res == 1 } {
      break
      } else {
      tk_messageBox -parent $acwin -type ok -icon error \
      -title $gPB(msg,dialog,title) \
      -message $gPB(msg,filename_protection)
     }
     } else {
     if { $filename != "" && [info exists gPB(new_sub_post)] && $gPB(new_sub_post) == 1 } {
      global pb_output_file
      if { [string compare [file tail $pb_output_file.pui] [file tail $filename]] } {
       tk_messageBox -parent $acwin -type ok -icon error \
       -title $gPB(msg,dialog,title) \
       -message $gPB(new,unit_post,filename,msg)
       set filename "[file dirname $filename]/[file tail $pb_output_file.pui]"
       } else {
       unset gPB(new_sub_post)
       break
      }
      } else {
      break
     }
    }
   }
  }
  UI_PB_com_DelistActiveWindow $win
  UI_PB_com_ClaimActiveWindow $acwin
  UI_PB_com_EnableMain
  if { 0 } { ;# Sensitivity problem since pb600!
   if { ![info exists ::mom_sys_arr(Output_VNC)] || $::mom_sys_arr(Output_VNC) == 0 } {
    if { $Book::($gPB(book),current_tab) == 4 } {
     set book_page [lindex $Book::($gPB(book),page_obj_list) 4]
     set isv_book $Page::($book_page,book_obj)
     __lst__SetVNCOutputOptionSens $isv_book
    }
   }
  }
  UI_PB_com_ChangeCHelpState normal
  if { $filename != "" } {
   set gPB(work_dir) [file dirname $filename]
   set gPB(work_file) $filename
   UI_PB_SavePbFiles_win $win $filename
   global post_object
   set Post::($post_object,post_name) [file tail [file rootname $filename]]
  }
  UI_PB_ActivateOpenFileOpts
  if [info exists gPB(master_pid)] {
   comm::comm send -async $gPB(master_pid) [list UI_PB_GrayAndUnGrayWindowMenu ungray 0]
  }
 }

#=======================================================================
proc UI_PB_SaveAsCancel_CB { dialog_id } {
  global gPB
  global gpb_prev_status
  if [winfo exists $dialog_id] {
   $dialog_id popdown
   UI_PB_com_DismissActiveWindow $dialog_id
  }
  UI_PB_ActivateOpenFileOpts
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
  if { $tcl_platform(platform) != "unix" } \
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
   foreach match [lsort -dictionary [glob -nocomplain -- $pattern]] \
   {
    $file_listbox insert end $match
   }
   cd $cur_dir
  } else \
  {
   set main_win $win
   tk_messageBox -parent $main_win -type ok -icon error \
   -title $gPB(msg,dialog,title) \
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
  wm deiconify $win
 }

#=======================================================================
proc __RestoreBackupMethod { } {
  if { [info exists ::gPB(backup_method_org)] } {
   set ::gPB(backup_method) $::gPB(backup_method_org)
   unset ::gPB(backup_method_org)
  }
 }

#=======================================================================
proc UI_PB_SavePbFiles_unx { win select_file_name } {
  global gPB
  global gpb_pui_file
  global gpb_def_file
  global gpb_tcl_file
  global gpb_prev_status
  set win [UI_PB_com_AskActiveWindow]
  set select_file_name "[file rootname $select_file_name].pui"
  set new_dir [file dirname $select_file_name]
  if { $new_dir != "." } \
  {
   set cur_dir $new_dir
  }
  if { [file isdirectory $new_dir] == 0 } \
  {
   tk_messageBox -parent $win -type ok -icon error \
   -title $gPB(msg,dialog,title) \
   -message "$gPB(msg,invalid_dir)"
   wm deiconify $win
   __RestoreBackupMethod
   return
   } elseif { [llength [split $select_file_name " "]] > 1 } \
  {
   tk_messageBox -parent $win -type ok -icon error \
   -title $gPB(msg,dialog,title) \
   -message "$gPB(msg,invalid_file)"
   wm deiconify $win
   __RestoreBackupMethod
   return
   } elseif { [file writable $new_dir] == 0 } \
  {
   tk_messageBox -parent $win -type ok -icon error \
   -title $gPB(msg,dialog,title) \
   -message "$gPB(msg,dir_perm)"
   set file [[$win subwidget fsbox] subwidget file]
   [$file subwidget listbox] delete 0
   $file addhistory $gPB(work_file)
   wm deiconify $win
   __RestoreBackupMethod
   return
  }
  if { [info exists gPB(new_sub_post)] && $gPB(new_sub_post) == 1 } {
   global pb_output_file
   if { [string compare "[file tail $pb_output_file].pui" [file tail $select_file_name]] } {
    tk_messageBox -parent $win -type ok -icon error \
    -title $gPB(msg,dialog,title) \
    -message $gPB(new,unit_post,filename,msg)
    set s_file [[$win subwidget fsbox] subwidget file]
    [$s_file subwidget listbox] delete 0
    $s_file addhistory "[file tail $pb_output_file].pui"
    $s_file pick 0
    wm deiconify $win
    __RestoreBackupMethod
    return
    } else {
    unset gPB(new_sub_post)
   }
  }
  set file_name [file rootname $select_file_name]
  set file_string ""
  if [file exists $file_name.def] { set file_string "$file_name.def" }
  if [file exists $file_name.tcl] { set file_string "$file_name.tcl\n$file_string" }
  if [file exists $file_name.pui] { set file_string "$file_name.pui\n$file_string" }
  if { $file_string != "" } \
  {
   set ans [tk_messageBox -parent $win -type yesno -icon question \
   -title $gPB(msg,dialog,title) \
   -message "$file_string $gPB(msg,file_exist)"]
   if { $ans == "no" } \
   {
    wm deiconify $win
    __RestoreBackupMethod
    return
   }
   __RestoreBackupMethod
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
  set gPB(Output_Dir) $cur_dir
  UI_PB_save_a_post yes
  set select_file_name [join [split $select_file_name "\\"] "/"]
  set gPB(open_files_list) [ladd $gPB(open_files_list) 0 $select_file_name "no_dup"]
  set gPB(work_file) [file tail $select_file_name]
  if { $select_file_name != "" } {
   set gPB(work_dir) [file dirname $select_file_name]
   global post_object
   set Post::($post_object,post_name) [file tail [file rootname $select_file_name]]
  }
  __RestoreBackupMethod
  UI_PB_SaveAsCancel_CB $win
 }

#=======================================================================
proc UI_PB_SavePbFiles_win { win select_file_name } {
  global gPB
  set cur_dir [file dirname $select_file_name]
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
  set gPB(Output_Dir) $cur_dir
  UI_PB_save_a_post yes
  set select_file_name [join [split $select_file_name "\\"] "/"]
  set gPB(open_files_list) [ladd $gPB(open_files_list) 0 $select_file_name "no_dup"]
  set gPB(work_file) [file tail $select_file_name]
  if { $select_file_name != "" } {
   set gPB(work_dir) [file dirname $select_file_name]
  }
  UI_PB_SaveAsCancel_CB $win
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
proc UI_PB_GrayOutAllFileOptions { } {
  global gPB
  if [info exists gPB(master_pid)] {
   comm::comm send $gPB(master_pid) [list UI_PB_GrayOutAllFileOptions_mod]
   } else {
   UI_PB_GrayOutAllFileOptions_mod
  }
 }

#=======================================================================
proc UI_PB_GrayOutAllFileOptions_mod { } {
  global gPB
  set pb_topwin $gPB(top_window)
  set mb $gPB(main_menu_bar).file.m
  $mb entryconfigure $gPB(menu_index,file,new)     -state disabled
  $mb entryconfigure $gPB(menu_index,file,open)    -state disabled
  if [catch { $mb entryconfigure $gPB(menu_index,file,mdfa) -state disabled } result] { }
  $mb entryconfigure $gPB(menu_index,file,save)    -state disabled
  $mb entryconfigure $gPB(menu_index,file,save_as) -state disabled
  $mb entryconfigure $gPB(menu_index,file,close)   -state disabled
  $mb entryconfigure $gPB(menu_index,file,property) -state disabled
  if { [$mb index $gPB(menu_index,file,history)] == $gPB(menu_index,file,history) } {
   catch { $mb entryconfigure $gPB(menu_index,file,history) -state disabled }
  }
  set mm $gPB(main_menu).tool
  [$mm subwidget new]  config -state disabled
  [$mm subwidget open] config -state disabled
  [$mm subwidget save] config -state disabled
  if 0 {
   bind all <Control-n> "UI_PB_NewPost"
   bind all <Control-o> "UI_PB_OpenPost"
   bind all <Control-s> "UI_PB_SavePost"
   bind all <Control-a> "UI_PB_SavePostAs"
  }
  bind all <Control-n> ""
  bind all <Control-o> ""
  bind all <Control-s> ""
  bind all <Control-a> ""
 }

#=======================================================================
proc UI_PB_ActivateOpenFileOpts { } {
  global gPB
  if [info exists gPB(master_pid)] {
   comm::comm send $gPB(master_pid) [list UI_PB_ActivateOpenFileOpts_mod]
   } else {
   UI_PB_ActivateOpenFileOpts_mod
  }
 }

#=======================================================================
proc UI_PB_ActivateOpenFileOpts_mod { } {
  global gPB
  set pb_topwin $gPB(top_window)
  set mb $gPB(file_menu)
  if {[info exists ::env(MULTI_INTERP)] && $::env(MULTI_INTERP) == 1} {
   if {[info exists ::env(LIMIT_NUM)] && $::env(LIMIT_NUM) == 1} {
    $mb entryconfigure $gPB(menu_index,file,new)     -state disabled ;# New
    $mb entryconfigure $gPB(menu_index,file,open)    -state disabled ;# Open
    } else {
    $mb entryconfigure $gPB(menu_index,file,new)     -state normal ;# New
    $mb entryconfigure $gPB(menu_index,file,open)    -state normal ;# Open
   }
   } else {
   $mb entryconfigure $gPB(menu_index,file,new)     -state disabled ;# New
   $mb entryconfigure $gPB(menu_index,file,open)    -state disabled ;# Open
  }
  if [catch { $mb entryconfigure $gPB(menu_index,file,mdfa) -state disabled } result] { }
  $mb entryconfigure $gPB(menu_index,file,save)    -state normal   ;# Save
  $mb entryconfigure $gPB(menu_index,file,save_as) -state normal   ;# Save As
  $mb entryconfigure $gPB(menu_index,file,close)   -state normal   ;# Close
  $mb entryconfigure $gPB(menu_index,file,exit)    -state normal   ;# Exit
  $mb entryconfigure $gPB(menu_index,file,property) -state normal  ;# Post Property
  if {[info exists ::env(MULTI_INTERP)] && $::env(MULTI_INTERP) == 1} {
   if {[info exists ::env(LIMIT_NUM)] && $::env(LIMIT_NUM) == 1} {
    catch { $mb entryconfigure $gPB(menu_index,file,history) -state disabled } ;# Visited Posts
    } else {
    catch { $mb entryconfigure $gPB(menu_index,file,history) -state normal } ;# Visited Posts
   }
   } else {
   if { [$mb index $gPB(menu_index,file,history)] == $gPB(menu_index,file,history) } {
    catch { $mb entryconfigure $gPB(menu_index,file,history) -state disabled } ;# Visited Posts
   }
  }
  PB_com_unset_var gPB(save_as_now)
  if {[info exists ::env(MULTI_INTERP)] && $::env(MULTI_INTERP) == 1} {
   if {[info exists ::PID(activated)] && $::PID(activated) != ""} {
    comm::comm send -async $::PID(activated) [list PB_com_unset_var gPB(save_as_now)]
   }
  }
  set mm $gPB(main_menu).tool
  if {[info exists ::env(MULTI_INTERP)] && $::env(MULTI_INTERP) == 1} {
   if {[info exists ::env(LIMIT_NUM)] && $::env(LIMIT_NUM) == 1} {
    [$mm subwidget new]  config -state disabled
    [$mm subwidget open] config -state disabled
    [$mm subwidget save] config -state normal
    } else {
    [$mm subwidget new]  config -state normal
    [$mm subwidget open] config -state normal
    [$mm subwidget save] config -state normal
   }
   } else {
   [$mm subwidget new]  config -state disabled
   [$mm subwidget open] config -state disabled
   [$mm subwidget save] config -state normal
  }
  $mb entryconfigure $gPB(menu_index,file,exit) -state normal ;# Exit
  bind all <Control-n> ""
  bind all <Control-o> ""
  bind all <Control-s> "UI_PB_SavePost"
  bind all <Control-a> "UI_PB_SavePostAs"
 }

#=======================================================================
proc UI_PB_GrayAndUnGrayWindowMenu { type {action_to_sub 1}} {
   global gPB
   if {[info exists ::env(LIMIT_NUM)] && $::env(LIMIT_NUM) == 1} {
    return
   }
   if {$type == "gray"} {
    if [winfo exists $gPB(window_menu)] {
     [winfo parent $gPB(window_menu)] config -state disabled
    }
    if {$action_to_sub == 1} {
     if {[info exists ::PID(activated)] && $::PID(activated) != ""} {
      comm::comm send -async $::PID(activated) [list UI_PB_com_DisableProcess]
     }
    }
    } else {
    if [winfo exists $gPB(window_menu)] {
     if {[llength $::PID(posts_list)] != 0 } {
      [winfo parent $gPB(window_menu)] config -state normal
     }
    }
    if {$action_to_sub == 1} {
     if {[info exists ::PID(activated)] && $::PID(activated) != ""} {
      comm::comm send -async $::PID(activated) [list UI_PB_com_EnableProcess]
     }
    }
   }
  }

#=======================================================================
proc __SetMachineWidgetsbyMainPost { main_post } {
  global gPB
  global output_unit
  global mach_axis
  set win $gPB(active_window)
  if { ![info exists ::env(SUB_POST)] || $::env(SUB_POST) == 0 } {
   return 0
  }
  if { ![file exists $main_post] } {
   set ::ude_enable 0
   set gPB(new_vnc_flag) 0
   set fa [$win.top.level5.left.top subwidget frame]
   $fa.mill configure -state disabled
   $fa.lathe configure -state disabled
   $fa.wedm configure -state disabled
   $fa.axis configure -state disabled
   [$win.top.level22.usp.lf subwidget frame].ckb configure -command "CB_ActivateUnitSubPostMode $win 1"
   $win.top.level1.ent configure -state normal
   return 1
  }
  if [file exists [file rootname $main_post].cdl] {
   set ::ude_enable 1
   } else {
   set ::ude_enable 0
  }
  if [file exists [file rootname $main_post]_vnc.tcl] {
   set gPB(new_vnc_flag) 1
   } else {
   set gPB(new_vnc_flag) 0
  }
  if { ![info exists gPB(main_post_machine_type)] || ![info exists gPB(main_post_axis_option)] } {
   set gPB(main_post_machine_type) $gPB(new_machine_type)
   set gPB(main_post_axis_option) $mach_axis
  }
  CB_ActivateUnitSubPostMode $win 1 $main_post
  [$win.top.level22.usp.lf subwidget frame].ckb configure -command "CB_ActivateUnitSubPostMode $win 1 \"$main_post\""
  if { $gPB(unit_sub_post_mode) == 0 && ![file exists $main_post] } {
   set fa [$win.top.level5.left.top subwidget frame]
   $fa.mill  configure -state normal
   $fa.lathe configure -state normal
   $fa.wedm  configure -state normal
  }
  return 1
 }

#=======================================================================
proc __file_is_SiteID_UG_internal { site_id } {
  if { [string match "__UGPB_ISV_internal_use"        $site_id] ||\
   [string match "For Internal Siemens PLM Use*"  $site_id] ||\
   [string match "For Internal UGS PLM Use Only"  $site_id] ||\
   [string match "CLIENTDEMO - Siemens PLM*"      $site_id] } {
   return 1
  }
  return 0
 }

#=======================================================================
proc __file_SelectMainPost { args } {
  global gPB
  global env
  global tcl_platform
  if { ![info exists ::env(SUB_POST)] || $::env(SUB_POST) == 0 } {
   return
  }
  if { $gPB(use_info) } \
  {
   UI_PB_chelp_DisplayMenuItemCsh $gPB(file_menu)
   return
  }
  UI_PB_com_SetStatusbar "Select a Post Builder session file."
  UI_PB_file_GetWorkFileDir
  set file_name [file join $gPB(work_dir) $gPB(work_file)]
  if { ![file exists $file_name] } {
   set gPB(work_file) ""
  }
  __file_DisableWidgets
  if { ![info exists gPB(mach_main_post)] } {
   set gPB(mach_main_post) ""
  }
  set old_file_name $gPB(mach_main_post)
  if { $tcl_platform(platform) == "unix" } \
  {
   UI_PB_file_SelectFile_unx PUI gPB(mach_main_post) open
   } elseif {$tcl_platform(platform) == "windows"} \
  {
   UI_PB_file_SelectFile_win PUI gPB(mach_main_post) open
   __file_EnableWidgets
  }
  if { [string compare $old_file_name $gPB(mach_main_post)] == 0 } {
   PB_com_unset_var gPB(is_sub_post)
   return
  }
  if { $gPB(mach_main_post) != "" } {
   set gPB(is_sub_post) 0
   set gPB(mach_main_post) [string trim $gPB(mach_main_post) \"]
   PB_file_GetPostAttr $gPB(mach_main_post) gPB(main_post_machine_type) gPB(main_post_axis_option) gPB(main_post_unit)
   if { [string compare $gPB(main_post_machine_type) "Wire EDM"] == 0 } \
   {
    set gPB(main_post_machine_type) "Wedm"
   }
   UI_PB_GetPostVersion gPB(mach_main_post) version
   if { $gPB(is_sub_post) == 1 } {
    set gPB(mach_main_post) "$old_file_name"
    tk_messageBox -parent [UI_PB_com_AskActiveWindow] -icon warning \
    -message "$gPB(new,main_post,warning_1,msg)"
    unset gPB(is_sub_post)
    __file_SelectMainPost
    } elseif { [string compare "2007.0.0.0" $version] > 0 } {
    set gPB(mach_main_post) "$old_file_name"
    tk_messageBox -parent [UI_PB_com_AskActiveWindow] -icon warning \
    -message "$gPB(new,main_post,warning_2,msg)"
    unset version
    __file_SelectMainPost
    } else {
    unset gPB(is_sub_post)
    namespace eval CHECK {
     set is_author 1
     set gPB(mach_main_post) [string trim $gPB(mach_main_post) \"]
     set root_name [file rootname $gPB(mach_main_post)]
     catch [source ${root_name}.tcl]
     if { [info exists encrypted_post_file] } {
      if { [file exists $encrypted_post_file] } {
       if { ![string compare $gPB(PB_LICENSE) "UG_POST_AUTHOR"] } {
        if { [llength [info commands UI_PB_decrypt_post] ] } {
         set is_author [UI_PB_decrypt_post $encrypted_post_file TRUE NO YES]
         if 1 {
          global LicInfo
          if [info exists LicInfo(post_site_id)] {
           set post_site_id $LicInfo(post_site_id)
           } else {
           set post_site_id ""
          }
          UI_PB_decrypt_post $encrypted_post_file TRUE NO NO
          set is_user_internal [__file_is_SiteID_UG_internal $gPB(PB_SITE_ID)]
          set is_post_internal [__file_is_SiteID_UG_internal $LicInfo(post_site_id)]
          if { [string length $post_site_id] > 0 } {
           set LicInfo(post_site_id) $post_site_id
           } else {
           unset LicInfo(post_site_id)
          }
          if { $is_user_internal && $is_post_internal } {
           set LicInfo(SITE_ID_IS_OK_FOR_PT) 1
           set is_author 1
          }
         }
         } else {
         set is_author 0
        }
        } else {
        set is_author 0
       }
       } else {
       set is_author "-1"
      }
     }
    } ;# namespace
    if { $::CHECK::is_author == 0 } {
     namespace delete CHECK
     set gPB(mach_main_post) "$old_file_name"
     tk_messageBox -parent [UI_PB_com_AskActiveWindow] -icon warning \
     -message "A licensed post can not be used as main post\nfor creating a new post if you are not the author!"
     __file_SelectMainPost
     } elseif {$::CHECK::is_author == 1} {
     namespace delete CHECK
     __SetMachineWidgetsbyMainPost $gPB(mach_main_post)
     } else {
     namespace delete CHECK
     set gPB(mach_main_post) "$old_file_name"
     tk_messageBox -parent [UI_PB_com_AskActiveWindow] -icon warning \
     -message "Encrypted file is missing for this licensed post!"
    }
   }
  }
 }

#=======================================================================
proc CB_ActivateSubPostMode { win } {
  global output_unit
  global gPB
  global mach_axis
  global pb_output_file
  if { ![info exists ::env(SUB_POST)] || $::env(SUB_POST) == 0 } {
   return
  }
  if { [winfo manager $win.top.level22.mpf]  == "pack" } { pack forget $win.top.level22.mpf }
  if { [winfo manager $win.top.level22.usp]  == "pack" } { pack forget $win.top.level22.usp }
  if { [info exists gPB(sub_post_mode)] && $gPB(sub_post_mode) == 1 } {
   pack forget $win.top.level3
   pack forget $win.top.level5
   pack forget $win.top.level5.left
   pack forget $win.top.level5.right
   if 1 {
    set gPB(unit_sub_post_mode) 1
    } else {
    pack $win.top.level22.usp -side right -fill x -expand yes -anchor se
   }
   pack $win.top.level22.mpf -side right -fill x -expand yes -anchor se
   pack $win.top.level3 -side top -fill both -expand yes
   pack $win.top.level5 -side top -fill both -expand yes
   pack $win.top.level5.left -side left -fill both -expand yes
   pack $win.top.level5.right -side right -fill both -expand yes
   if { ![string compare $output_unit "Inches"] } {
    [$win.top.level3.lbf subwidget frame].inch configure -state normal
    [$win.top.level3.lbf subwidget frame].mm configure -state disabled
    } elseif { ![string compare $output_unit "Millimeters"] } {
    [$win.top.level3.lbf subwidget frame].inch configure -state disabled
    [$win.top.level3.lbf subwidget frame].mm configure -state normal
   }
   [$win.top.level3.ude.lf subwidget frame].ckb configure -state disabled
   [$win.top.level3.vnc.lf subwidget frame].ckb configure -state disabled
   pack forget $win.top.level5.left.bottom
   if { ![info exists gPB(new_machine_type_saved)] || \
    ![info exists gPB(mach_axis_saved)] || \
    ![info exists gPB(output_unit_saved)] || \
    ![info exists gPB(pb_output_file_saved)]} {
    set gPB(new_machine_type_saved) $gPB(new_machine_type)
    set gPB(mach_axis_saved) $mach_axis
    set gPB(output_unit_saved) $output_unit
    set gPB(pb_output_file_saved) $pb_output_file
   }
   if { ![info exists gPB(main_post_machine_type)] || \
    ![info exists gPB(main_post_axis_option)] || \
    ![info exists gPB(main_post_axis_option)] } {
    set gPB(main_post_machine_type) $gPB(new_machine_type)
    set gPB(main_post_axis_option) $mach_axis
    set gPB(main_post_unit) $output_unit
   }
   __ResetMachineWidgets
   CB_ActivateUnitSubPostMode $win 1 $gPB(mach_main_post)
   __SetMachineWidgetsbyMainPost $gPB(mach_main_post)
   } else {
   if 1 {
    set gPB(unit_sub_post_mode) 0
   }
   set fa [$win.top.level5.left.top subwidget frame]
   set fb [$win.top.level5.left.bottom subwidget frame]
   [$win.top.level3.lbf subwidget frame].inch configure -state normal
   [$win.top.level3.lbf subwidget frame].mm configure -state normal
   [$win.top.level3.ude.lf subwidget frame].ckb configure -state normal
   [$win.top.level3.vnc.lf subwidget frame].ckb configure -state normal
   if { [info exists gPB(new_machine_type_saved)] && [info exists gPB(mach_axis_saved)] } {
    set gPB(new_machine_type) $gPB(new_machine_type_saved)
    CreateMachineTypeOptMenu $fa $gPB(new_machine_type)
    set mach_axis $gPB(mach_axis_saved)
    CB_MachineAxisType $win $gPB(new_machine_type)
    unset gPB(new_machine_type_saved)
    unset gPB(mach_axis_saved)
   }
   if { [info exists gPB(output_unit_saved)] } {
    set output_unit $gPB(output_unit_saved)
    unset gPB(output_unit_saved)
   }
   if { [info exists gPB(pb_output_file_saved)] } {
    set pb_output_file $gPB(pb_output_file_saved)
    unset gPB(pb_output_file_saved)
   }
   pack $win.top.level5.left.bottom -side top -pady 10 -fill both
   CB_ActivateUnitSubPostMode $win 0 $gPB(mach_main_post)
   global mach_cntl_type
   CB_CntlType $fb $mach_cntl_type
   if { ![file exists $gPB(mach_main_post)] } {
    PB_com_unset_var gPB(main_post_axis_option)
    PB_com_unset_var gPB(main_post_machine_type)
    PB_com_unset_var gPB(main_post_unit)
   }
  }
 }

#=======================================================================
proc CB_ActivateUnitSubPostMode { win mode {main_post ""} } {
  global gPB
  global output_unit
  global mach_axis
  if { ![info exists ::env(SUB_POST)] || $::env(SUB_POST) == 0 } {
   return
  }
  set fa [$win.top.level5.left.top subwidget frame]
  $win.top.level1.ent configure -state normal
  if { [info exists gPB(unit_sub_post_mode)] && $gPB(unit_sub_post_mode) == 1 && \
  [file exists $main_post] } \
  {
   global pb_output_file
   set pb_output_file "[file rootname [file tail $main_post]]"
   if { ![string compare $gPB(main_post_unit) "Inches"] } {
    append pb_output_file "__MM"
    } else {
    append pb_output_file "__IN"
   }
   $win.top.level1.ent configure -state disabled
  }
  if { [info exists gPB(unit_sub_post_mode)] && $gPB(unit_sub_post_mode) == 1 && $mode == 1 } {
   set gPB(unit_sub_post_on) 1
   if { $gPB(sub_post_mode) == 1 && ![string compare $gPB(main_post_unit) $output_unit]} {
    if { ![string compare $output_unit "Inches"] } {
     [$win.top.level3.lbf subwidget frame].inch configure -state disabled
     [$win.top.level3.lbf subwidget frame].mm configure -state normal
     set output_unit "Millimeters"
     } elseif { ![string compare $output_unit "Millimeters"] } {
     [$win.top.level3.lbf subwidget frame].inch configure -state normal
     [$win.top.level3.lbf subwidget frame].mm configure -state disabled
     set output_unit "Inches"
    }
   }
   if { [string compare $gPB(main_post_machine_type) $gPB(new_machine_type)] || \
   [string compare $gPB(main_post_axis_option) $mach_axis] } \
   {
    set gPB(new_machine_type) $gPB(main_post_machine_type)
    CreateMachineTypeOptMenu $fa $gPB(new_machine_type)
    set mach_axis $gPB(main_post_axis_option)
    CB_MachineAxisType $win $gPB(new_machine_type)
   }
   $fa.mill configure -state disabled
   $fa.lathe configure -state disabled
   $fa.wedm configure -state disabled
   $fa.axis configure -state disabled
   } else {
   $fa.mill configure -state normal
   $fa.lathe configure -state normal
   $fa.wedm configure -state normal
   $fa.axis configure -state normal
   if { $gPB(sub_post_mode) == 1 } {
    if { [file exists $main_post] } {
     switch $gPB(main_post_machine_type) \
     {
      "Mill" \
      {
       $fa.wedm configure -state disabled
      }
      "Lathe" \
      {
       $fa.mill configure -state disabled
       $fa.wedm configure -state disabled
      }
      "Wire EDM" \
      {
       $fa.mill configure -state disabled
       $fa.lathe configure -state disabled
      }
     }
    }
    if { [info exists gPB(unit_sub_post_on)] && $gPB(unit_sub_post_on) == 1 } {
     if { ![string compare $output_unit "Inches"] } {
      [$win.top.level3.lbf subwidget frame].inch configure -state disabled
      [$win.top.level3.lbf subwidget frame].mm configure -state normal
      set output_unit "Millimeters"
      } elseif { ![string compare $output_unit "Millimeters"] } {
      [$win.top.level3.lbf subwidget frame].inch configure -state normal
      [$win.top.level3.lbf subwidget frame].mm configure -state disabled
      set output_unit "Inches"
     }
     unset gPB(unit_sub_post_on)
     } else {
     if { [string compare $gPB(main_post_unit) $output_unit] } {
      if { ![string compare $output_unit "Inches"] } {
       [$win.top.level3.lbf subwidget frame].inch configure -state disabled
       [$win.top.level3.lbf subwidget frame].mm configure -state normal
       set output_unit "Millimeters"
       } elseif { ![string compare $output_unit "Millimeters"] } {
       [$win.top.level3.lbf subwidget frame].inch configure -state normal
       [$win.top.level3.lbf subwidget frame].mm configure -state disabled
       set output_unit "Inches"
      }
     }
    }
    if { [string compare $gPB(main_post_machine_type) $gPB(new_machine_type)] || \
    [string compare $gPB(main_post_axis_option) $mach_axis] } \
    {
     set fa [$win.top.level5.left.top subwidget frame]
     set gPB(new_machine_type) $gPB(main_post_machine_type)
     CreateMachineTypeOptMenu $fa $gPB(new_machine_type)
     set mach_axis $gPB(main_post_axis_option)
     CB_MachineAxisType $win $gPB(new_machine_type)
     if { $gPB(unit_sub_post_mode) == 1 } {
      $fa.axis configure -state disabled
     }
    }
   }
  }
 }

#=======================================================================
proc UI_PB_NewPost { } {
  global tixOption paOption
  global gPB
  global env
  if { $gPB(use_info) } \
  {
   UI_PB_chelp_DisplayMenuItemCsh $gPB(file_menu)
   return
  }
  UI_PB_com_SetStatusbar "$gPB(new,Status)"
  if { [lsearch -exact [package names] "stooop"] < 0 } {
   source $env(PB_HOME)/tcl/exe/stooop.tcl
   namespace import stooop::*
  }
  set win $gPB(top_window).new
  if { [info exists env(MULTI_INTERP)] && $env(MULTI_INTERP) == 1 } {
   UI_PB_GrayAndUnGrayWindowMenu gray
  }
  if { [winfo exists $win] } \
  {
   wm deiconify $win
   UI_PB_com_ClaimActiveWindow $win
   UI_PB_GrayOutAllFileOptions
   set temp_ude_state $::ude_enable
   set gPB(new_enable_choose_vnc) 1
   set gPB(post_vnc_list) [list] ;#<08-12-09 wbh>
   set gPB(new_machine_type_widget) [$win.top.level5.left.top subwidget frame]
   set temp_cntl_w [$win.top.level5.left.bottom subwidget frame]
   set str_family [$temp_cntl_w.contr.ent get]
   if [string match "* - *" $str_family] \
   {
    set pre_index [string first " - " $str_family]
    incr pre_index 3
    set str_family [string range $str_family $pre_index end]
   }
   set gPB(sys_first_choose_flag) 1
   global mach_cntl_type
   if { ![info exists gPB(mach_sys_controller)] || $gPB(mach_sys_controller) == "" } {
    __InvokeFamilySelection $gPB(family_opt_menu) $str_family
    CB_CntlType [$win.top.level5.left.bottom subwidget frame] $mach_cntl_type
   }
   if [string match "Generic" $mach_cntl_type] \
   {
    set ::ude_enable $temp_ude_state
   }
   if [info exists gPB(sys_first_choose_flag)] \
   {
    unset gPB(sys_first_choose_flag)
   }
   if { [info exists ::env(SUB_POST)] && $::env(SUB_POST) == 1 } {
    if { [info exists gPB(sub_post_mode)] && $gPB(sub_post_mode) == 1 } {
     __SetMachineWidgetsbyMainPost $gPB(mach_main_post)
    }
   }
   return
  }
  if [winfo exists $gPB(top_window).new.user_cntl_frag] {
   destroy $gPB(top_window).new.user_cntl_frag
  }
  PB_com_unset_var gPB(widgets_disabled)
  toplevel $win
  UI_PB_com_CreateTransientWindow $win "$gPB(new,title,Label)" "+200+100" \
  "" "" "wm withdraw $win;destroy $win" "UI_PB_NewDestroy"
  global output_unit
  wm withdraw $win
  global mach_axis
  global pb_output_file
  if {[info exists ::env(INCH_METRIC)] && $::env(INCH_METRIC) == 1} {
   set output_unit "Dual"
   } else {
   set output_unit "Inches"
  }
  set gPB(new_machine_type) "Mill"
  set mach_axis "3"
  if { [info exists env(MULTI_INTERP)] && $env(MULTI_INTERP) == 1 } {
   global std_file_name
   if ![info exists std_file_name] {
    set std_file_name "new_post1"
   }
   set pb_output_file $std_file_name
   } else {
   set pb_output_file "new_post"
  }
  set label_list {"gPB(nav_button,cancel,Label)" \
  "gPB(nav_button,ok,Label)"}
  set cb_arr(gPB(nav_button,cancel,Label)) "UI_PB_NewCancel_CB $win"
  set cb_arr(gPB(nav_button,ok,Label)) "__NewPost $win"
  UI_PB_com_CreateButtonBox $win label_list cb_arr
  pack $win.box -padx 3 -pady 3
  frame $win.top -relief raised -bd 1
  pack $win.top -side top -fill both -expand yes
  frame $win.top.level1
  frame $win.top.level2
  frame $win.top.level3
  frame $win.top.level5
  frame $win.top.level5.left
  frame $win.top.level5.right
  if { [info exists ::env(SUB_POST)] && $::env(SUB_POST) == 1 } {
   set bgc gray92 ;#$paOption(event)
   frame $win.top.level22 ;#-bg $bgc
   tixLabelFrame $win.top.level22.lbf -labelside none
   set sbp [$win.top.level22.lbf subwidget frame]
   $sbp config -bg $bgc
   pack $win.top.level22.lbf -side left -pady 0
   set sbpf $sbp
   if { 0 } {
    set sbpf_ckb [checkbutton $sbpf.ckb -text "$gPB(new,sub_post,toggle,tmp_label)" \
    -variable gPB(sub_post_mode) -onvalue 1 -offvalue 0 \
    -highlightthickness 0 \
    -bg $bgc -font $tixOption(bold_font) \
    -command "CB_ActivateSubPostMode $win"]
    pack $sbpf_ckb -side left -padx 10 -pady 5 -fill both -expand yes
    } else {
    set gPB(sub_post_mode) 0
    radiobutton $sbpf.main -text "$gPB(new,main_post,label)" -bg $bgc \
    -font $tixOption(bold_font) -anchor w \
    -variable gPB(sub_post_mode) -value 0 \
    -command "CB_ActivateSubPostMode $win"
    radiobutton $sbpf.sub -text "$gPB(new,sub_post,toggle,tmp_label)" -bg $bgc \
    -font $tixOption(bold_font) -anchor w \
    -variable gPB(sub_post_mode) -value 1 \
    -command "CB_ActivateSubPostMode $win"
    if 0 {
     pack $sbpf.main -side top -padx 10 -pady 5 -fill x -expand yes
     pack $sbpf.sub  -side top -padx 10 -pady 5 -fill x -expand yes
     } else {
     tixForm $sbpf.main -top %6 -bottom %47 -left %5 -right %95
     tixForm $sbpf.sub  -top %53 -bottom %94 -left %5 -right %95
    }
   }
   set gPB(mach_main_post) ""
   set mpf [frame $win.top.level22.mpf]
   tixLabelFrame $mpf.lbf -label "$gPB(new,main_post,label)"
   set mplf [$mpf.lbf subwidget frame]
   set mp [frame $mplf.mp]
   pack $mp -padx 10 -pady 2
   entry $mp.ent -width 32 -relief sunken -textvariable gPB(mach_main_post) -state disabled
   button $mp.but -text "$gPB(new,user,browse,Label)" -command "__file_SelectMainPost"
   grid $mpf.lbf -column 0 -row 0 -pady 0 -sticky news
   pack $mp.but -side right
   pack $mp.ent -side left -padx 3 -pady 5 -fill x
   if { 0 } { ;# Never used!
    if ![string compare $::tix_version 4.1] \
    {
     bind $mp.ent <KeyPress> "__SetMachineWidgetsbyMainPost %P"
    } else \
    {
     $mp.ent config -validate key -vcmd "__SetMachineWidgetsbyMainPost %P"
    }
   }
   set usp [frame $win.top.level22.usp]
   tixLabelFrame $usp.lf -labelside none
   set uspf [$usp.lf subwidget frame]
   set uspf_ckb [checkbutton $uspf.ckb -text "$gPB(new,alter_unit,toggle,label)" \
   -variable gPB(unit_sub_post_mode) -onvalue 1 -offvalue 0 \
   -command "CB_ActivateUnitSubPostMode $win 1"]
   grid $usp.lf -column 0 -row 0 -pady 0 -sticky news
   pack $uspf_ckb -side left -padx 6 -pady 10
   pack $usp -side right -fill x -expand yes -anchor se
   pack $mpf -side right -fill x -expand yes -anchor se
  }
  set name_lbl [label $win.top.level1.name -font $tixOption(bold_font) \
  -text [format "%-10s" "$gPB(new,name,Label)"]] ;#<04-18-07 peter>10 was 30
  set name_ent [entry $win.top.level1.ent -width 56 -relief sunken \
  -textvariable pb_output_file] ;#<09-14-05 peter> width was 49
  $name_ent config -bg $paOption(tree_bg)
  bind $name_ent <KeyPress> "UI_PB_com_DisableSpecialChars %W %K 1 1"
  bind $name_ent <KeyRelease> { %W config -state normal }
  tixForm $name_lbl -left %0  -padx 10 -pady 10
  tixForm $name_ent -left %25 -right %100 -padx 10 -pady 10
  pack $win.top.level1 -side top -fill x -expand yes
  pack $win.top.level2 -side top -fill x -expand yes
  if { [info exists ::env(SUB_POST)] && $::env(SUB_POST) == 1 } {
   pack $win.top.level22 -side top -fill x -expand yes -pady 10
  }
  pack $win.top.level3 -side top -fill both -expand yes
  pack $win.top.level5 -side top -fill both -expand yes
  pack $win.top.level5.left -side left -fill both -expand yes
  pack $win.top.level5.right -side right -fill both -expand yes
  set desc_lab [label $win.top.level2.lab -font $tixOption(bold_font)\
  -text [format "%-10s" "$gPB(new,desc,Label)"]];#<04-18-07 peter>10 was 30
  set desc_txt [tixScrolledText $win.top.level2.desc \
  -height 50 -width 398 -scrollbar y];#<09-14-05 peter>width was 400
  set gPB(post_desc_win) [$desc_txt subwidget text]
  [$desc_txt subwidget text] config -bg $paOption(tree_bg) -takefocus 0  ;#<02-11-11 gsl> Do not take focus...
  [$desc_txt subwidget vsb]  config -width $paOption(trough_wd) \
  -troughcolor $paOption(trough_bg)
  tixForm $desc_lab -left %0  -padx 10 -pady 5
  tixForm $desc_txt -left %25 -right %100 -padx 10 -pady 5
  if {![info exists ::env(INCH_METRIC)] || $::env(INCH_METRIC) == 0} {
   tixLabelFrame $win.top.level3.lbf -label "$gPB(new,post_unit,Label)"
   set out_frame [$win.top.level3.lbf subwidget frame]
   pack $win.top.level3.lbf -side left -pady 10
   radiobutton $out_frame.inch -text "$gPB(new,inch,Label)" \
   -variable output_unit -anchor w  -value "Inches"
   radiobutton $out_frame.mm -text "$gPB(new,millimeter,Label)" \
   -variable output_unit -anchor w -value "Millimeters"
   pack $out_frame.inch $out_frame.mm -side left -padx 10 -pady 5 -fill x
  }
  set ::ude_enable $env(PB_UDE_ENABLED)
  if { $::ude_enable == 2 } {
   set ::ude_enable 0
  }
  set ude_f [frame $win.top.level3.ude]
  if 0 {
   set ude_ckb [checkbutton $ude_f.ckb -text "$gPB(ude,editor,enable,Label)" \
   -variable ::ude_enable -onvalue 1 \
   -offvalue 0]
   pack $ude_f -fill both -expand yes
   if {![info exists ::env(INCH_METRIC)] || $::env(INCH_METRIC) == 0} {
    grid $ude_ckb -column 0 -row 0 -sticky news
    } else {
    pack $ude_ckb -side left -padx 10 -pady 10
   }
  }
  tixLabelFrame $ude_f.lf -labelside none
  set ude_fr [$ude_f.lf subwidget frame]
  set ude_ckb [checkbutton $ude_fr.ckb -text "$gPB(ude,editor,enable,Label)" \
  -variable ::ude_enable -onvalue 1 \
  -offvalue 0]
  if { ![info exists ::env(INCH_METRIC)] || $::env(INCH_METRIC) == 0 } {
   grid $ude_f.lf -column 0 -row 0 -pady 11 -sticky news
   pack $ude_ckb -side left -padx 10 -pady 10
   } else {
   pack $ude_f.lf -side left -pady 10
   pack $ude_ckb -side left -padx 10 -pady 10
  }
  set gPB(new_enable_choose_vnc) 1
  set gPB(post_vnc_list) [list] ;#<08-12-09 wbh>
  set gPB(new_vnc_flag) 0
  set vnc_f [frame $win.top.level3.vnc]
  tixLabelFrame $vnc_f.lf -labelside none
  set vnc_fr [$vnc_f.lf subwidget frame]
  set vnc_ckb [checkbutton $vnc_fr.ckb -text    "$gPB(new,include_vnc,Label)"\
  -variable gPB(new_vnc_flag)\
  -onvalue  1\
  -offvalue 0]
  pack $vnc_f -side right -fill x -expand yes -anchor se
  pack $ude_f -side right -fill x -expand yes -anchor se -padx 20
  pack $vnc_f.lf -side left -pady 10
  pack $vnc_ckb -side left -padx 10 -pady 10
  set gPB(new_vnc_ckb) $vnc_ckb
  tixLabelFrame $win.top.level5.left.top -label "$gPB(new,machine,Label)"
  set fa [$win.top.level5.left.top subwidget frame]
  pack $win.top.level5.left.top -side top -fill both
  tixLabelFrame $win.top.level5.left.bottom -label "$gPB(new,control,Label)"
  set fb [$win.top.level5.left.bottom subwidget frame]
  pack $win.top.level5.left.bottom -side top -pady 10 -fill both
  set gPB(new_machine_type_widget) $fa
  radiobutton $fa.mill -text "$gPB(new,mill,Label)" \
  -variable gPB(new_machine_type) -anchor w \
  -value "Mill" -command "CB_MachType $win Mill $fa $fb"
  radiobutton $fa.lathe -text "$gPB(new,lathe,Label)" \
  -variable gPB(new_machine_type) -anchor w \
  -value "Lathe" -command "CB_MachType $win Lathe $fa $fb"
  radiobutton $fa.wedm -text "$gPB(new,wire,Label)" \
  -variable gPB(new_machine_type) -anchor w \
  -value "Wedm" -command "CB_MachType $win Wedm $fa $fb"
  radiobutton $fa.punch -text "$gPB(new,punch,Label)" \
  -variable gPB(new_machine_type) -anchor w \
  -value "Punch" -command "CB_MachType $win Punch $fa $fb"
  grid $fa.mill  -sticky w -padx 5 -pady 2
  grid $fa.lathe -sticky w -padx 5 -pady 2
  if { [PB_is_v3] >= 0 } {
   grid $fa.wedm  -sticky w -padx 5 -pady 2
  }
  tixOptionMenu $fa.axis                  \
  -variable mach_axis                 \
  -command  "CB_MachineAxisType $win $gPB(new_machine_type)" \
  -options {
   entry.anchor e
   menubutton.width       30
  }
  [$fa.axis subwidget menubutton] config -font $tixOption(bold_font) \
  -bg $paOption(header_bg) -fg yellow ;#<01-13-03 gsl> $paOption(special_fg)
  grid $fa.axis -sticky w -padx 5 -pady 2
  global mach_cntl_type
  set fbt [frame $fb.type]
  pack $fbt
  radiobutton $fbt.g -text "$gPB(new,generic,Label)" \
  -variable mach_cntl_type -anchor w  -value "Generic" \
  -command "CB_CntlType $fb Generic"
  radiobutton $fbt.s -text "$gPB(new,library,Label)" \
  -variable mach_cntl_type -anchor w  -value "System" \
  -command "CB_CntlType $fb System"
  radiobutton $fbt.u -text "$gPB(new,user,Label)" \
  -variable mach_cntl_type -anchor w  -value "User" \
  -command "CB_CntlType $fb User"
  pack $fbt.g $fbt.s $fbt.u -side left -padx 10 -pady 5 -fill x
  frame $fb.contr
  pack $fb.contr -padx 5 -pady 7 -fill x -expand yes
  entry $fb.contr.ent -width 31 -relief sunken -bd 2 \
  -textvariable gPB(mach_sys_controller)
  if ![string compare $::tix_version 4.1] \
  {
   $fb.contr.ent config -bg lightblue -state disabled
  } else \
  {
   $fb.contr.ent config -readonlybackground lightblue -state readonly
  }
  set cbx [tix getbitmap cbxarrow]
  menubutton $fb.contr.but -bitmap $cbx -width 15 -height 18 -bd 1 -relief raised
  if ![winfo exists gPB(family_opt_menu)] \
  {
   set gPB(family_opt_menu) [menu $fb.contr.but.family_menu -tearoff 0]
  }
  $fb.contr.but configure -menu $gPB(family_opt_menu)
  pack $fb.contr.ent $fb.contr.but -side left -padx 1
  bind $fb.contr.ent <Enter> "__file_ShowBalloon %W 1"
  PB_enable_balloon $fb.contr.ent
  global gPB_help_tips
  set gPB_help_tips($fb.contr.ent) ""
  if 0 {
   if { [PB_is_v3] >= 0 } {
    switch $::tix_version {
     8.4 {
      tixComboBox $fb.contr \
      -dropdown   yes \
      -editable   yes \
      -variable   gPB(mach_sys_controller) \
      -command    "" \
      -selectmode immediate \
      -grab       local \
      -options {
       listbox.anchor   w
       listbox.height   2
       listbox.width    31
       entry.width      31
      }
      [$fb.contr subwidget entry] config -readonlybackground $paOption(entry_disabled_bg) \
      -selectbackground lightblue \
      -selectforeground black \
      -cursor "" -state readonly
      set gPB(LB_widget) [$fb.contr subwidget slistbox]
      $gPB(LB_widget) config -width 100
      pack $fb.contr -padx 5 -pady 7 -fill x -expand yes
     }
    }
   }
  }
  set fbu [frame $fb.user]
  pack $fbu -padx 5 -pady 2
  entry $fbu.ent -width 25 -relief sunken -textvariable gPB(mach_user_controller)
  if ![string compare $::tix_version 4.1] \
  {
   bind $fbu.ent <KeyPress> "CB_UserComboBox $fb %P"
  } else \
  {
   $fbu.ent config -validate key -vcmd "CB_UserComboBox $fb %P"
  }
  set gPB(widgets_disabled) [list $fb $win.box]
  bind $fbu.ent <Enter> "__file_ShowBalloon %W"
  PB_enable_balloon $fbu.ent
  global gPB_help_tips
  set gPB_help_tips($fbu.ent) ""
  button $fbu.but -text "$gPB(new,user,browse,Label)" -command "__file_SelectPost"
  pack $fbu.ent -side left -padx 3
  pack $fbu.but -side right
  set mach_cntl_type "Generic"
  canvas $win.top.level5.right.can -width 300 -height 300 -scrollregion "0 0 300 300";#peter Add the last option
  $win.top.level5.right.can config -bg black -relief sunken
  $win.top.level5.right.can config -bg white -bd 3 -relief solid
  pack $win.top.level5.right.can -fill both -expand yes -padx 5 \
  -pady 13 ;#<01-15-08 peter> was 5
  image create photo myphoto -file $env(PB_HOME)/images/pb_hg500.gif
  set center_mach_image 1
  if { !$center_mach_image } {
   $win.top.level5.right.can create image 150 150 -image myphoto
  }
  CB_MachType $win $gPB(new_machine_type) $fa $fb
  if { [info exists ::env(SUB_POST)] && $::env(SUB_POST) == 1 } {
   CB_ActivateSubPostMode $win
  }
  UI_PB_GrayOutAllFileOptions
  set gPB(c_help,$win.top.level1.ent)                     "new,name"
  set gPB(c_help,[$win.top.level2.desc subwidget text])   "new,desc"
  if {![info exists ::env(INCH_METRIC)] || $::env(INCH_METRIC) == 0} {
   set gPB(c_help,$out_frame.inch)                         "new,inch"
   set gPB(c_help,$out_frame.mm)                           "new,millimeter"
  }
  set gPB(c_help,$fb.contr.but)                           "new,control"
  set gPB(c_help,$fa.mill)                                "new,mill"
  set gPB(c_help,$fa.lathe)                               "new,lathe"
  set gPB(c_help,$fa.wedm)                                "new,wire"
  set gPB(c_help,[$fa.axis subwidget menubutton])         "new,mach_axis"
  wm deiconify $win
  if { $center_mach_image } {
   update
   set wd [winfo width  $win.top.level5.right.can]
   set ht [winfo height $win.top.level5.right.can]
   $win.top.level5.right.can create image [expr $wd/2] [expr $ht/2] -image myphoto
  }
  UI_PB_com_PositionWindow $win
  wm resizable $win 0 0
  CB_CntlType $fb Generic
 }

#=======================================================================
proc __file_ShowBalloon { ent args } {
  global gPB
  global gPB_help_tips
  set file_name [string trimleft [$ent get]]
  if { $file_name == "" } \
  {
   set gPB_help_tips($ent) ""
   return
  }
  if { [llength $args] > 0 && [lindex $args 0] } \
  {
   UI_PB_file_GetCurrentSysControllerFullName $file_name full_name
   set file_name $full_name
  }
  if { ![file exists $file_name] } \
  {
   set gPB_help_tips($ent) $gPB(new,user,file,NOT_EXIST)
   return
  }
  set mach_type ""
  set axis ""
  set unit ""
  set cntl_family ""
  PB_file_GetPostAttr $file_name mach_type axis unit
  UI_PB_file_GetPostControllerType file_name cntl_family
  switch $axis \
  {
   "3" \
   {
    set axis "3-Axis"
   }
   "3MT" \
   {
    set axis "3-Axis Mill-Turn(XZC)"
   }
   "4H" \
   {
    set axis "4-Axis Head"
   }
   "4T" \
   {
    set axis "4-Axis Table"
   }
   "5TT" \
   {
    set axis "5-Axis Dual Tables"
   }
   "5HH" \
   {
    set axis "5-Axis Dual Heads"
   }
   "5HT" \
   {
    set axis "5-Axis Head Table"
    set axisoption "5HT"
   }
   "2" \
   {
    set axis "2-Axis"
    set axisoption "2"
   }
   "4" \
   {
    set axis "4-Axis"
   }
   "3axis" \
   {
    set axis "Mill/Turn"
   }
  }
  set balloon_text "$gPB(machine,info,type,Label): $mach_type"
  append balloon_text "\n$gPB(machine,info,kinematics,Label): $axis" \
  "\n$gPB(machine,info,unit,Label): $unit"
  if { $cntl_family != "" } \
  {
   append balloon_text "\n$gPB(machine,info,controller_type,Label): $cntl_family"
  }
  set gPB_help_tips($ent) $balloon_text
 }

#=======================================================================
proc UI_PB_file_GetCurrentSysControllerFullName { file_name FULL_NAME args } {
  upvar $FULL_NAME full_name
  global gPB env
  if [llength $args] \
  {
   set machine_type [lindex $args 0]
  } else \
  {
   set machine_type $gPB(new_machine_type)
  }
  switch $machine_type \
  {
   "Mill"   {
    set sys_dir [file dirname $env(PB_HOME)/pblib/controller/.]/mill
   }
   "Lathe"  {
    set sys_dir [file dirname $env(PB_HOME)/pblib/controller/.]/lathe
   }
   "Wire EDM" -
   "Wedm"   {
    set sys_dir [file dirname $env(PB_HOME)/pblib/controller/.]/wedm
   }
  }
  if [string match "* - *" $file_name] \
  {
   set pre_len [string length $gPB(cntl_sub_folder)]
   incr pre_len 3
   set temp_name [string range $file_name $pre_len end]
   if $gPB(cntl_sub_type) \
   {
    if [string match windows $::tcl_platform(platform)] \
    {
     set sys_dir "$sys_dir/$gPB(cntl_sub_folder)/$temp_name"
    } else \
    {
     set sys_dir "$sys_dir/$gPB(cntl_sub_folder)/$gPB(cntl_sub_sub_folder)"
    }
   } else \
   {
    set sys_dir "$sys_dir/$gPB(cntl_sub_folder)"
   }
   set full_name [file join $sys_dir [string tolower [string index $temp_name 0]][string range $temp_name 1 end].pui]
  } else \
  {
   set full_name [file join $sys_dir $file_name.pui]
  }
 }

#=======================================================================
proc CB_UserComboBox { w file_name } {
  global gPB
  set file_name [string trimleft $file_name]
  if [file isfile $file_name] \
  {
   set temp_name [file rootname $file_name]
   if [file exists $temp_name.cdl] \
   {
    set ::ude_enable 1
   } else \
   {
    set ::ude_enable 0
   }
  } else \
  {
   set ::ude_enable 0
  }
  if $gPB(new_enable_choose_vnc) \
  {
   if [file exists [file rootname $file_name]_vnc.tcl] \
   {
    $gPB(new_vnc_ckb) config -state normal
    set gPB(new_vnc_flag) 0 ;#<09-16-09 wbh> 0 was 1.
   } else \
   {
    $gPB(new_vnc_ckb) config -state disabled
    set gPB(new_vnc_flag) 0
   }
  }
  __ResetMachineWidgets
  __SetMachineWidgetsByFile $file_name 1
  return 1
 }

#=======================================================================
proc __file_CreateComboList { w OPTS } {
  upvar $OPTS opts
  global gPB
  set lbx [$w subwidget listbox]
  $lbx delete 0 end
  set gPB(mach_sys_controller) ""
  if { [info exists opts] && [llength $opts] > 0 } {
   foreach opt $opts {
    set opt [file rootname $opt]
    $w insert end $opt
   }
   set opt [file rootname [lindex $opts 0]]
   set gPB(mach_sys_controller) $opt
   tixSetSilent $w $opt
   set h [expr [llength $opts] - 1]
   if { $h > 10 } { set h 10 }
   [$w subwidget listbox] config -height $h
  }
  tixSetSilent $w $gPB(mach_sys_controller)
 }

#=======================================================================
proc __file_SelectPost { args } {
  global gPB
  global env
  global tcl_platform
  if { $gPB(use_info) } \
  {
   UI_PB_chelp_DisplayMenuItemCsh $gPB(file_menu)
   return
  }
  UI_PB_com_SetStatusbar "Select a Post Builder session file."
  UI_PB_file_GetWorkFileDir
  set file_name [file join $gPB(work_dir) $gPB(work_file)]
  if { ![file exists $file_name] } {
   set gPB(work_file) ""
  }
  __file_DisableWidgets
  if { ![info exists gPB(mach_user_controller)] } {
   set gPB(mach_user_controller) ""
  }
  set old_file_name $gPB(mach_user_controller)
  if { $tcl_platform(platform) == "unix" } \
  {
   UI_PB_file_SelectFile_unx PUI gPB(mach_user_controller) open
   } elseif {$tcl_platform(platform) == "windows"} \
  {
   UI_PB_file_SelectFile_win PUI gPB(mach_user_controller) open
   __file_EnableWidgets
  }
  if { [string compare $old_file_name $gPB(mach_user_controller)] != 0 } \
  {
   __SetMachineWidgetsByFile $gPB(mach_user_controller) 1
  } else \
  {
   return
  }
  if { $gPB(mach_user_controller) != "" } {
   namespace eval CHECK {
    set is_author 1
    set gPB(mach_user_controller) [string trim $gPB(mach_user_controller) \"]
    set root_name [file rootname $gPB(mach_user_controller)]
    catch [source ${root_name}.tcl]
    if { [info exists encrypted_post_file] } {
     if { [file exists $encrypted_post_file] } {
      if {$::gPB(PB_LICENSE) == "UG_POST_AUTHOR"} {
       if { [llength [info commands UI_PB_decrypt_post] ] } {
        set is_author [UI_PB_decrypt_post $encrypted_post_file TRUE NO YES]
        if 1 {
         global LicInfo
         if [info exists LicInfo(post_site_id)] {
          set post_site_id $LicInfo(post_site_id)
          } else {
          set post_site_id ""
         }
         UI_PB_decrypt_post $encrypted_post_file TRUE NO NO
         set is_user_internal [__file_is_SiteID_UG_internal $gPB(PB_SITE_ID)]
         set is_post_internal [__file_is_SiteID_UG_internal $LicInfo(post_site_id)]
         if { [string length $post_site_id] > 0 } {
          set LicInfo(post_site_id) $post_site_id
          } else {
          unset LicInfo(post_site_id)
         }
         if { $is_user_internal && $is_post_internal } {
          set LicInfo(SITE_ID_IS_OK_FOR_PT) 1
          set is_author 1
         }
        }
        } else {
        set is_author 0
       }
       } else {
       set is_author 0
      }
      } else {
      set is_author "-1"
     }
    }
   } ;# namespace
   if { $::CHECK::is_author == 0 } {
    namespace delete CHECK
    set gPB(mach_user_controller) "$old_file_name"
    tk_messageBox -parent [UI_PB_com_AskActiveWindow] -icon warning \
    -message $gPB(msg,user_ctrl_limit)
    __file_SelectPost
    } elseif {$::CHECK::is_author == 1} {
    namespace delete CHECK
    } else {
    namespace delete CHECK
    set gPB(mach_user_controller) "$old_file_name"
    tk_messageBox -parent [UI_PB_com_AskActiveWindow] -icon warning \
    -message $gPB(msg,no_file)
   }
  }
 }

#=======================================================================
proc UI_PB_file_GetPostControllerType { FILE_NAME TYPE args } {
  global gPB
  upvar $FILE_NAME file_name
  upvar $TYPE type
  set type ""
  set post_ctrl_start 0
  set fname [string trimleft $file_name]
  if { ![string compare $fname ""] || ![file exists $fname] } { return }
  set file_id [open $fname r]
  set type_start 0
  while { [gets $file_id line] >= 0 } \
  {
   switch -glob -- $line \
   {
    "#  CONTROLLER START"             {
     set post_ctrl_start 1
     set type_info ""
     continue
    }
    "#  CONTROLLER END"               {
     set post_ctrl_start 0
     if { [info exists ::env(UNIT_SUB_POST_MODE)] && $::env(UNIT_SUB_POST_MODE) == 1 } {
      if { ![string compare $file_name $gPB(main_post)] } {
       set gPB(main_post_controller) [join $type_info]
      }
     }
     unset type_info
     continue
    }
    "#  CONTROLLER TYPE START"        {
     set type_start 1
     set type_info ""
     continue
    }
    "#  CONTROLLER TYPE END"          {
     set type_start 0
     set type [join $type_info]
     unset type_info
     break
    }
    "#  HISTORY START"                {
     break
    }
    "## LISTING FILE START"           {
     break
    }
   }
   if { $type_start || $post_ctrl_start } {
    lappend type_info $line
   }
  }
  close $file_id
 }

#=======================================================================
proc UI_PB_file_SelectFile_unx { file_type FILE_VAR flag args } {
  upvar $FILE_VAR file_var
  global tixOption
  global paOption
  global gPB
  global env
  set awin [UI_PB_com_AskActiveWindow]
  set ext [string tolower $file_type]
  UI_PB_file_GetWorkFileDir
  set file_name [file join $gPB(work_dir) $gPB(work_file)]
  if { ![file exists $file_name] || \
   ![string match ".$ext" [file extension $file_name]] } {
   set gPB(work_file) ""
  }
  set work_dir  $gPB(work_dir)
  set work_file $gPB(work_file)
  switch $ext {
   "pui" {
    set win $awin.user_cntl_frag
    set open_file_type $gPB(open,file_type_pui)
   }
   "tcl" {
    set win $awin.user_cust_cmd
    set open_file_type $gPB(open,file_type_tcl)
   }
   "def" {
    set win $awin.def_file
    set open_file_type $gPB(open,file_type_def)
   }
   "cdl" {
    set win $awin.ude_cdl
    set open_file_type $gPB(open,file_type_cdl)
   }
   default {
    tk_messageBox -parent $awin -type ok -icon error \
    -title $gPB(msg,dialog,title) \
    -message "File type \"$file_type\" is not accepted by\
    procedure \"[lindex [info level 0] 0]\"."
    return TCL_ERROR
   }
  }
  if { $file_var != "" } {
   set work_dir  [file dirname $file_var]
   set work_file [file tail    $file_var]
  }
  set work_dir [file nativename $work_dir]
  if { [string tolower [file extension $work_file]] != ".$ext" } {
   set work_file ""
  }
  tixExFileSelectDialog $win -command "__file_SelectFileName $win $FILE_VAR $flag"
  UI_PB_com_CreateTransientWindow $win "Select a file" \
  "600x400+200+100" "" "" \
  "destroy $win" \
  "UI_PB_com_EnableMain; __file_EnableWidgets"
  set fbox [$win subwidget fsbox]
  $win popup
  set ftypes [list \{*.$ext\}\ \{$open_file_type\}]
  $fbox config -filetypes $ftypes
  catch {
   $fbox config -pattern "*.$ext" \
   -directory $work_dir \
   -value $work_file
  }
  set fdir [[$fbox subwidget dir] subwidget entry]
  set file [[$fbox subwidget file] subwidget entry]
  if 0 {
   bind $fdir <KeyPress> "UI_PB_com_DisableSpaceKey %W %K"
   bind $fdir <KeyRelease> { %W config -state normal }
   bind $file <KeyPress> "UI_PB_com_DisableSpaceKey %W %K"
   bind $file <KeyRelease> { %W config -state normal }
  }
  bind $fdir <KeyPress> "UI_PB_com_DisableSpecialChars %W %K 1 1"
  bind $fdir <KeyRelease> { %W config -state normal }
  bind $file <KeyPress> "UI_PB_com_DisableSpecialChars %W %K 1 1"
  bind $file <KeyRelease> { %W config -state normal }
  [$fbox subwidget cancel] config -width 10 -bg $paOption(app_butt_bg) \
  -command "destroy $win"
  if { [string tolower $flag] == "save" } {
   set ok_label $gPB(nav_button,save,Label)
   } else {
   set ok_label $gPB(nav_button,open,Label)
  }
  [$fbox subwidget ok]     config -bg $paOption(app_butt_bg) -width 10 \
  -text $ok_label
  [$fbox subwidget file]   config -history yes -prunehistory yes
  [$fbox subwidget dir]    config -history yes -prunehistory yes
  $fbox filter
  [$fbox subwidget types] pick 0
  if { $work_file != "" } {
   [$fbox subwidget file] addhistory $work_file
   [$fbox subwidget file] pick 0
  }
  UI_PB_com_PositionWindow $win
  vwait $FILE_VAR
 }

#=======================================================================
proc UI_PB_file_SelectFile_win { file_type FILE_VAR flag args } {
  upvar $FILE_VAR file_var
  global tixOption
  global paOption
  global gPB
  global env
  set awin [UI_PB_com_AskActiveWindow]
  set ext [string tolower $file_type]
  UI_PB_file_GetWorkFileDir
  set file_name [file join $gPB(work_dir) $gPB(work_file)]
  if { ![file exists $file_name] || \
   ![string match ".$ext" [file extension $file_name]] } {
   set gPB(work_file) ""
  }
  set work_dir  $gPB(work_dir)
  set work_file $gPB(work_file)
  switch $ext {
   "pui" {
    set win $awin.user_cntl_frag
    set open_file_type $gPB(open,file_type_pui)
   }
   "tcl" {
    set win $awin.user_cust_cmd
    set open_file_type $gPB(open,file_type_tcl)
   }
   "def" {
    set win $awin.def_file
    set open_file_type $gPB(open,file_type_def)
   }
   "cdl_def" -
   "cdl" {
    set win $awin.ude_cdl
    set open_file_type $gPB(open,file_type_cdl)
   }
   default {
    tk_messageBox -parent $awin -type ok -icon error \
    -title $gPB(msg,dialog,title) \
    -message "File type \"$file_type\" is not accepted by\
    procedure \"[lindex [info level 0] 0]\"."
    return TCL_ERROR
   }
  }
  if { $file_var != "" } {
   set work_dir  [file dirname $file_var]
   set work_file [file tail    $file_var]
  }
  set work_dir [file nativename $work_dir]
  if { [string tolower [file extension $work_file]] != ".$ext" } {
   set work_file ""
  }
  UI_PB_com_ChangeCHelpState disabled
  set ftypes [list \{$open_file_type\}\ \{*.$ext\}]
  if [string match "cdl_def" $ext] {
   set ftypes [list \{$gPB(open,file_type_cdl)\}\ \{*.cdl\} \
   \{$gPB(open,file_type_def)\}\ \{*.def\}]
  }
  set status TCL_ERROR
  while { $status != "TCL_OK" } \
  {
   set flag [string tolower $flag]
   if { $flag == "open" } {
    set file_name [tk_getOpenFile -filetypes $ftypes \
    -title "$gPB(open_save,dlg,title,Label)" \
    -parent $awin \
    -defaultextension "$ext" \
    -initialdir $work_dir \
    -initialfile $work_file]
    } else {
    set file_name [tk_getSaveFile -filetypes $ftypes \
    -title "$gPB(open_save,dlg,title,Label)" \
    -parent $awin\
    -defaultextension "$ext" \
    -initialdir $work_dir \
    -initialfile $work_file]
   }
   set win $awin.__tk_filedialog
   set gPB(top_window).new.user_cntl_frag $win
   if { $file_name == "" } { ;# File selection dialog closed... (Cancelled or X'ed).
    if { ![info exists file_var] } {
     set file_var ""
    }
    if [string match 1 $args] {
     if [info exists file_var] {
      lappend file_var CANCEL
     }
    }
    set status TCL_OK
    } else {                  ;# File selected.
    set status [__file_SelectFileName $win $FILE_VAR $flag $file_name]
   }
   if { $status != "TCL_OK" } {
    UI_PB_DeleteDataBaseObjs
    global mom_sys_arr mom_kin_var mom_sim_arr
    PB_com_unset_var mom_sys_arr
    PB_com_unset_var mom_kin_var
    if [info exists mom_sim_arr] { PB_com_unset_var mom_sim_arr}
   }
  }
  UI_PB_com_ChangeCHelpState normal
 }

#=======================================================================
proc __file_SelectFileName { win FILE_VAR flag file_name args } {
  upvar $FILE_VAR file_var
  global gPB
  set awin [UI_PB_com_AskActiveWindow]
  if { $flag == "open" } {
   set ext [string tolower [file extension $file_name]]
   if { $ext == ".pui" } {
    set pui $file_name
    PB_file_FindTclDefOfPui $pui tcl def
    if { ![file exists $pui] || \
     ![file exists $def] || \
     ![file exists $tcl] } {
     tk_messageBox -parent $awin -type ok -icon error \
     -title $gPB(msg,dialog,title) \
     -message "$gPB(msg,file_missing)."
     if [winfo exists $win] { $win popup }
     return TCL_ERROR
    }
   }
   } else {
   global tcl_platform
   if { $tcl_platform(platform) == "unix" } {
    if { [llength [split $file_name " "]] > 1 } {
     tk_messageBox -parent $awin -type ok -icon error \
     -title $gPB(msg,dialog,title) \
     -message "$gPB(msg,invalid_file)"
     if [winfo exists $win] { $win popup }
     return TCL_ERROR
    }
    set file [[$win subwidget fsbox] subwidget file]
    [$file subwidget listbox] delete 0
    if [file exists $file_name] {
     set ans [tk_messageBox -parent $awin -type yesno -icon question \
     -title $gPB(msg,dialog,title) \
     -message "$file_name $gPB(msg,file_exist)"]
     if { $ans == "no" } {
      if [winfo exists $win] { $win popup }
      return TCL_ERROR
     }
    }
   }
   if [file exists $file_name] {
    if { ![file writable $file_name] } {
     tk_messageBox -parent $awin -type ok -icon error \
     -title $gPB(msg,dialog,title) \
     -message "$gPB(msg,file_perm) $file_name"
     if [winfo exists $win] { $win popup }
     return TCL_ERROR
    }
    } else {
    set dir [file dirname $file_name]
    if { ![file exists $dir] } {
     file mkdir $dir
    }
    if { ![file writable $dir] } {
     tk_messageBox -parent $awin -type ok -icon error \
     -title $gPB(msg,dialog,title) \
     -message "$gPB(msg,dir_perm) $dir"
     if [winfo exists $win] { $win popup }
     return TCL_ERROR
    }
   }
  }
  set file_var "\"$file_name\""
  if [winfo exists $win] { destroy $win }
  return TCL_OK
 }

#=======================================================================
proc __file_DisableWidgets { args } {
  if 0 {
   set args [join [concat $args]]
   foreach w $args {
    tixDisableAll $w
   }
  }
  global gPB
  if [info exists gPB(widgets_disabled)] {
   foreach w $gPB(widgets_disabled) {
    tixDisableAll $w
   }
  }
 }

#=======================================================================
proc __file_EnableWidgets { args } {
  if 0 {
   set args [join [concat $args]]
   foreach w $args {
    tixEnableAll $w
   }
  }
  global gPB
  if [info exists gPB(widgets_disabled)] {
   foreach w $gPB(widgets_disabled) {
    tixEnableAll $w
   }
  }
 }

#=======================================================================
proc UI_PB_NewCancel_CB { win } {
  global gPB env
  UI_PB_EnableFileOptions
  if {[info exists env(MULTI_INTERP)] && $env(MULTI_INTERP) == 1} {
   UI_PB_GrayAndUnGrayWindowMenu ungray
  }
  wm withdraw $win
  UI_PB_com_SetStatusbar "$gPB(main,default,Status)"
 }

#=======================================================================
proc UI_PB_NewDestroy { args } {
  global env
  UI_PB_EnableFileOptions
  if {[info exists env(MULTI_INTERP)] && $env(MULTI_INTERP) == 1} {
   UI_PB_GrayAndUnGrayWindowMenu ungray
  }
 }

#=======================================================================
proc UI_PB_EnableFileOptions { } {
  global gPB
  if [info exists gPB(master_pid)] {
   comm::comm send -async $gPB(master_pid) [list UI_PB_EnableFileOptions_mod]
   } else {
   UI_PB_EnableFileOptions_mod
  }
 }

#=======================================================================
proc UI_PB_EnableFileOptions_mod  { } {
  global gPB env
  set mb $gPB(main_menu_bar).file.m
  $mb entryconfigure $gPB(menu_index,file,new)     -state normal
  $mb entryconfigure $gPB(menu_index,file,open)    -state normal
  if [catch { $mb entryconfigure $gPB(menu_index,file,mdfa) -state normal } result] { }
  if {[info exists env(MULTI_INTERP)] && $env(MULTI_INTERP) == 1} {
   global PID
   if {[llength $PID(posts_list)] > 0} {
    $mb entryconfigure $gPB(menu_index,file,save)    -state normal
    $mb entryconfigure $gPB(menu_index,file,save_as) -state normal
    $mb entryconfigure $gPB(menu_index,file,close)   -state normal
    } else {
    $mb entryconfigure $gPB(menu_index,file,save)    -state disabled
    $mb entryconfigure $gPB(menu_index,file,save_as) -state disabled
    $mb entryconfigure $gPB(menu_index,file,close)   -state disabled
   }
   } else {
   $mb entryconfigure $gPB(menu_index,file,save)     -state disabled
   $mb entryconfigure $gPB(menu_index,file,save_as)  -state disabled
   $mb entryconfigure $gPB(menu_index,file,close)    -state disabled
   $mb entryconfigure $gPB(menu_index,file,property) -state disabled
  }
  if { [$mb index $gPB(menu_index,file,history)] == $gPB(menu_index,file,history) } {
   catch { $mb entryconfigure $gPB(menu_index,file,history) -state normal }
  }
  set mm $gPB(main_menu).tool
  [$mm subwidget new]  config -state normal
  [$mm subwidget open] config -state normal
  if {[info exists env(MULTI_INTERP)] && $env(MULTI_INTERP) == 1} {
   global PID
   if {[llength $PID(posts_list)] > 0} {
    [$mm subwidget save] config -state normal
    } else {
    [$mm subwidget save] config -state disabled
   }
   } else {
   [$mm subwidget save] config -state disabled
  }
  UI_PB_com_DismissActiveWindow [UI_PB_com_AskActiveWindow]
  bind all <Control-n> "UI_PB_NewPost"
  bind all <Control-o> "UI_PB_OpenPost"
  bind all <Control-s> ""
  bind all <Control-a> ""
 }

#=======================================================================
proc CreateMachineTypeOptMenu { widget mach_type } {
  global mach_axis
  global gPB
  set opt_labels(Lathe,2)    "$gPB(new,lathe_2,Label)"
  set opt_labels(Lathe,4)    "$gPB(new,lathe_4,Label)"
  set opt_labels(Mill,3)     "$gPB(new,mill_3,Label)"
  set opt_labels(Mill,3MT)   "$gPB(new,mill_3MT,Label)"
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
    set opts { 3 3MT 4T 4H 5HH 5TT 5HT }
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
  set change_flag [__SetLockAxisStates $mach_type opts states cur_opt]
  foreach opt $opts state $states\
  {
   $widget.axis add command $opt -label $opt_labels($mach_type,$opt) -state $state
  }
  if $change_flag \
  {
   set mach_axis $cur_opt
  }
 }

#=======================================================================
proc __SetLockAxisStates { mach_type OPTION_LIST STATE_LIST CUR_OPT} {
  upvar $OPTION_LIST option_list
  upvar $STATE_LIST  state_list
  upvar $CUR_OPT     cur_opt
  global gPB
  global mach_axis
  set state_list ""
  set cur_opt ""
  foreach opt $option_list \
  {
   lappend state_list normal
  }
  if { ![info exists gPB(lock_machine_type_list)] || \
  ![info exists gPB(lock_axis_opt_list)] } \
  {
   return 0
  }
  if { [lsearch $gPB(lock_machine_type_list) $mach_type] == -1 } \
  {
   return 0
  }
  set change_flag 1
  set first_usable_opt ""
  foreach opt $option_list \
  {
   if { [lsearch $gPB(lock_axis_opt_list) $opt] == -1 } \
   {
    lappend temp_list "disabled"
   } else \
   {
    if [string match "" $first_usable_opt] \
    {
     set first_usable_opt $opt
    }
    if [string match $opt $mach_axis] \
    {
     set change_flag 0
    }
    lappend temp_list "normal"
   }
  }
  set state_list $temp_list
  if $change_flag \
  {
   set cur_opt $first_usable_opt
   return 1
  }
  return 0
 }

#=======================================================================
proc CreateControllerOptMenu { widget mach_type } {
  global gPB
  set opts_cont { Generic }
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
  global env
  switch $mach_type \
  {
   "Mill"   {
    set dir [file dirname $env(PB_HOME)/pblib/controller/.]/mill
   }
   "Lathe"  {
    set dir [file dirname $env(PB_HOME)/pblib/controller/.]/lathe
   }
   "Wedm"   {
    set dir [file dirname $env(PB_HOME)/pblib/controller/.]/wedm
   }
  }
  set dir [join [split $dir \$] \\\$]
  global sys_controller_dir
  set sys_controller_dir $dir
  set old_dir [pwd]
  set file_list_found 0
  eval cd [join [split $dir] "\\ "]
  if [catch {set opts [lsort [eval glob -nocomplain -- "*.pui"]] } res] {
   UI_PB_debug_Pause "glob : $res"
   } else {
   if [llength $opts] {
    set file_list_found 1
   }
  }
  eval cd [join [split $old_dir] "\\ "]
  if 0 {
   if { [string index $dir 0] != "/"} {
    global tcl_platform
    if [string match "unix" $tcl_platform(platform)] {
     if { ![catch {set opts [exec ls $dir] } res] } {
      if [llength $opts] {
       set file_list_found 1
      }
      } else {
      UI_PB_debug_Pause "unix : $res"
     }
     } else {
     if { ![catch {set opts [eval exec dir $dir] } res] } {
      if [llength $opts] {
       set file_list_found 1
      }
      } else {
      UI_PB_debug_Pause "win : $res"
     }
    }
    } else {
    if { ![catch {set opts [eval tixListDir $dir 0 1 0 0] } res] } {
     if [llength $opts] {
      set file_list_found 1
     }
     } else {
     UI_PB_debug_Pause "tixListDir : $res"
    }
   }
  }
  if $file_list_found {
   foreach f $opts {
    if { [file extension $f] == ".pui" } {
     lappend file_opts $f
    }
   }
  }
  if { [PB_is_v3] >= 0 } {
   __file_CreateComboList $widget.contr file_opts
   } else {
   set cur_opt_names [$widget.contr entries]
   foreach name $cur_opt_names \
   {
    $widget.contr delete $name
   }
   if { [info exists file_opts] && [llength $file_opts] } {
    foreach opt $file_opts {
     set opt [file rootname $opt]
     $widget.contr add command $opt -label $opt
    }
   }
  }
  if 0 {{
   foreach opt $opts_cont \
   {
    $widget.contr add command $opt -label $opt_labels_c($opt)
   }
  }}
 }

#=======================================================================
proc __NewUnitSubPost { w } {
  global gPB env
  if { ![file exists $gPB(mach_main_post)] } {
   tk_messageBox -message "$gPB(new,main_post,specify_err,msg)" \
   -parent $w -icon error
   return
  }
  __NewUnitSubPost_mod $w
 }

#=======================================================================
proc __NewSubPost { w } {
  global gPB env
  if { [info exists gPB(unit_sub_post_mode)] && $gPB(unit_sub_post_mode) == 1 } {
   set env(UNIT_SUB_POST_MODE) $gPB(unit_sub_post_mode)
   __NewUnitSubPost $w
   return
  }
  if { ![file exists $gPB(mach_main_post)] } {
   tk_messageBox -message "$gPB(new,main_post,specify_err,msg)" \
   -parent $w -icon error
   return
  }
  __NewSubPost_mod $w
 }

#=======================================================================
proc __NewPost { w } {
  global gPB env
  if { [info exists ::env(SUB_POST)] && $::env(SUB_POST) == 1 } {
   set env(SUB_POST_MODE) 0
   set env(UNIT_SUB_POST_MODE) 0
  }
  if { [info exists ::env(SUB_POST)] && $::env(SUB_POST) == 1 } {
   if { [info exists gPB(sub_post_mode)] && $gPB(sub_post_mode) == 1 } {
    set env(SUB_POST_MODE) $gPB(sub_post_mode)
    __NewSubPost $w
    return
   }
  }
  if { ![info exists gPB(post_controller_type)] } {
   set gPB(post_controller_type) $gPB(default_controller_type)
  }
  if { [info exists env(MULTI_INTERP)] && $env(MULTI_INTERP) == 1 } {
   global PID
   if { [lsearch $PID(posts_name_list) $::pb_output_file.pui] >= 0 } {
    tk_messageBox -message "File already exists!" -icon error \
    -parent $w
    return
   }
   UI_PB_GrayAndUnGrayWindowMenu ungray
   set gPB(action) new
   exec build_post.exe [comm::comm self] &
   } else {
   set gPB(action) new
   __NewPost_mod $w
  }
 }

#=======================================================================
proc __IncrNewPostNameNum { } {
  global std_file_name
  global pb_output_file
  if [string match $std_file_name $pb_output_file] {
   set idx [string range $std_file_name 8 end]
   set idx [expr $idx + 1]
   set std_file_name "new_post$idx"
  }
  set pb_output_file $std_file_name
 }

#=======================================================================
proc __NewPost_mod { w } {
  global env
  global gPB
  global mach_axis
  global pb_output_file
  global output_unit
  global axisoption
  global controller
  global mach_axis
  if [string match "" $mach_axis] \
  {
   tk_messageBox -parent $w -type ok -icon error -title $gPB(msg,dialog,title) \
   -message $gPB(new,MSG_NO_AXIS)
   return
  }
  set env(PB_UDE_ENABLED) $::ude_enable
  PB_com_unset_var gPB(Old_PUI_Version)
  UI_PB_DisplayProgress new
  set gPB(post_in_progress) 1
  if ![info exists gPB(master_pid)] {
   after 100 "UI_PB_DestroyProgress"
  }
  set controller $gPB(mach_sys_controller)
  set mach [string tolower $gPB(new_machine_type)]
  global mach_cntl_type
  switch $mach_cntl_type {
   "Generic" {
    set controller "Generic"
   }
   "User" {
    set controller [file nativename $gPB(mach_user_controller)]
   }
   "System" {
    if { $gPB(mach_sys_controller) == "" } {
     set controller ""
     } else {
     UI_PB_file_GetCurrentSysControllerFullName $gPB(mach_sys_controller) controller
    }
   }
  }
  set axisoption $mach_axis
  if 0 { ;# There may need "Reselect". "Continue Anyway" & "Ignore It!" options.
   if { $controller != "Generic" } {
    PB_file_GetPostAttr $controller MACHINE_TYPE AXIS_OPTION OUTPUT_UNIT
    if { $MACHINE_TYPE != $gPB(new_machine_type) } {
     tk_messageBox -parent $w -type ok -icon error \
     -title $gPB(msg,dialog,title) \
     -message "The selected controller fragment is of different type\
     as the Post to be created."
     return
    }
   }
  }
  if 0 {
   set env(PB_TESTING) 1
   if { [info exists env(PB_TESTING)]  &&  $env(PB_TESTING) } \
   {
    UI_PB_file_GetPostFragList pb_std_file $gPB(new_machine_type) $controller $axisoption $output_unit
   }
  }
  UI_PB_file_GetPostFragList pb_std_file $gPB(new_machine_type) $controller $axisoption $output_unit
  set gPB(pui_marker_merge) 0
  set sw_list [list]
  foreach f $pb_std_file {
   lappend sw_list 1
  }
  if { $controller != "Generic"  &&  $controller != "" } {
   set controller [join [split $controller "\\"] "\\\\"]
   set idx [lsearch $pb_std_file "$controller"]
   if { $idx >= 0 } { set sw_list [lreplace $sw_list $idx $idx 0] }
  }
  UI_PB_SnapShotRuntimeObjs
  if [catch { PB_file_Create $pb_std_file $sw_list } res] {
   __Pause "Caught in PB_file_Create :: $res"
   PB_com_unset_var gPB(pui_ui_overwrite)
   PB_com_unset_var gPB(pui_marker_merge)
   global post_object
   PB_com_DeleteObject $post_object
   UI_PB_debug_ForceMsg "PB_file_Create\n$res"
   tk_messageBox -parent [UI_PB_com_AskActiveWindow] -type ok -icon error \
   -title $gPB(msg,dialog,title) \
   -message "$res"
   PB_com_unset_var gPB(post_in_progress)
   if [info exists gPB(mill_common_family_dir_prefix)] \
   {
    unset gPB(mill_common_family_dir_prefix)
   }
   return
  }
  PB_com_unset_var gPB(pui_ui_overwrite)
  PB_com_unset_var gPB(pui_marker_merge)
  if [info exists gPB(mill_common_family_dir_prefix)] \
  {
   unset gPB(mill_common_family_dir_prefix)
  }
  if { ![string match "Generic" $controller] && \
  ![string match "" $gPB(post_controller_type)] } \
  {
   UI_PB_file_GetCurrentSysControllerFullName $gPB(mach_sys_controller) templete_file
   set templete_dir [file dirname $templete_file]
   if [PB_file_ParseMacroInfoFile $templete_dir] \
   {
    set gPB(controller_family_dir) $templete_dir
   }
  }
  if { $gPB(Output_Dir) == "" } \
  {
   set dir [file dirname $pb_output_file]
   if { $dir == "." } \
   {
    set dir [pwd]
   }
   set gPB(Output_Dir) $dir
  } else \
  {
   set dir $gPB(Output_Dir)
  }
  set file_name [file tail $pb_output_file]
  set pui_file $file_name.pui
  set def_file $file_name.def
  set tcl_file $file_name.tcl
  PB_int_SetPostOutputFiles dir pui_file def_file tcl_file
  PB_int_SetUserTclFileName file_name
  if [info exists gPB(master_pid)] {
   set gPB(post_description) [comm::comm send $gPB(master_pid) [list __GetDescription]]
   } else {
   set gPB(post_description) [__GetDescription]
   set gPB(post_description_default) $gPB(post_description)
  }
  if [string match "Generic" $mach_cntl_type] {
   set cont_str $mach_cntl_type
   } else {
   regsub -all "\\\\\\\\" $controller "/" cntl
   set cont_str "$mach_cntl_type  ($cntl)"
  }
  set gPB(post_controller) "[join [split $cont_str \\\\] /]"
  set gPB(post_history) ""
  if ![info exists gPB(master_pid)] {
   UI_PB_com_DismissActiveWindow $w
   wm deiconify $w
   wm withdraw $w
   } else {
   comm::comm send -async $gPB(master_pid) [list UI_PB_com_DismissActiveWindow $w]
   comm::comm send -async $gPB(master_pid) [list wm withdraw $w]
   set cmd_str {if {$PID(activated) != ""} {comm::comm send $PID(activated) update}}
    comm::comm send  $gPB(master_pid) [list eval $cmd_str]
   }
   update
   if [catch { UI_PB_main_window } result] \
   {
    PB_com_unset_var gPB(post_in_progress)
    return [tk_messageBox -parent $gPB(top_window) -type ok -icon error \
    -title $gPB(msg,dialog,title) \
    -message "$gPB(msg,file_corruption) \n $result"]
   }
   update
   UI_PB_ActivateOpenFileOpts
   AcceptMachineToolSelection
   set gPB(session) NEW
   UI_PB_com_SetStatusbar "$gPB(machine,Status)"
   PB_com_unset_var gPB(post_in_progress)
   UI_PB_DestroyProgress
   if [info exists gPB(master_pid)] {
    comm::comm send -async $gPB(master_pid) [list __IncrNewPostNameNum]
   }
  }

#=======================================================================
proc __NewSubPost_mod { w } {
 }

#=======================================================================
proc __NewUnitSubPost_mod { w } {
  global env
  global gPB
  global mach_axis
  global pb_output_file
  global output_unit
  global axisoption
  global controller
  global mach_cntl_type
  global mach_axis
  if [string match "" $mach_axis] \
  {
   tk_messageBox -parent $w -type ok -icon error -title $gPB(msg,dialog,title) \
   -message $gPB(new,MSG_NO_AXIS)
   return
  }
  set env(PB_UDE_ENABLED) 0
  PB_com_unset_var gPB(Old_PUI_Version)
  UI_PB_DisplayProgress new
  set gPB(post_in_progress) 1
  if ![info exists gPB(master_pid)] {
   after 100 "UI_PB_DestroyProgress"
  }
  set controller "Generic"
  set axisoption $mach_axis
  set gPB(main_post) $gPB(mach_main_post)
  UI_PB_file_GetPostFragList pb_std_file $gPB(new_machine_type) $controller $axisoption $output_unit
  set gPB(pui_marker_merge) 0
  set sw_list [list]
  foreach f $pb_std_file {
   lappend sw_list 1
  }
  if 0 {
   if { $controller != "Generic"  &&  $controller != "" } {
    set controller [join [split $controller "\\"] "\\\\"]
    set idx [lsearch $pb_std_file "$controller"]
    if { $idx >= 0 } { set sw_list [lreplace $sw_list $idx $idx 0] }
   }
  }
  UI_PB_SnapShotRuntimeObjs
  if [catch { PB_file_CreateAlterUnitSubPost $pb_std_file $sw_list } res] {
   __Pause "Caught in PB_file_CreateAlterUnitSubPost :: $res"
   PB_com_unset_var gPB(pui_ui_overwrite)
   PB_com_unset_var gPB(pui_marker_merge)
   global post_object
   PB_com_DeleteObject $post_object
   tk_messageBox -parent [UI_PB_com_AskActiveWindow] -type ok -icon error \
   -title $gPB(msg,dialog,title) \
   -message "$res"
   PB_com_unset_var gPB(post_in_progress)
   if [info exists gPB(mill_common_family_dir_prefix)] \
   {
    unset gPB(mill_common_family_dir_prefix)
   }
   return
  }
  PB_com_unset_var gPB(pui_ui_overwrite)
  PB_com_unset_var gPB(pui_marker_merge)
  if [info exists gPB(mill_common_family_dir_prefix)] \
  {
   unset gPB(mill_common_family_dir_prefix)
  }
  if { $gPB(Output_Dir) == "" } \
  {
   set dir [file dirname $pb_output_file]
   if { $dir == "." } \
   {
    set dir [pwd]
   }
   set gPB(Output_Dir) $dir
  } else \
  {
   set dir $gPB(Output_Dir)
  }
  set file_name [file tail $pb_output_file]
  set pui_file $file_name.pui
  set def_file $file_name.def
  set tcl_file $file_name.tcl
  PB_int_SetPostOutputFiles dir pui_file def_file tcl_file
  PB_int_SetUserTclFileName file_name
  set gPB(new_sub_post) 1
  if [info exists gPB(master_pid)] {
   set gPB(post_description) [comm::comm send $gPB(master_pid) [list __GetDescription]]
   } else {
   set gPB(post_description) [__GetDescription]
   set gPB(post_description_default) $gPB(post_description)
  }
  if 0 {
   if [string match "Generic" $mach_cntl_type] {
    set cont_str $mach_cntl_type
    } else {
    regsub -all "\\\\\\\\" $controller "/" cntl
    set cont_str "$mach_cntl_type  ($cntl)"
   }
   set gPB(post_controller) "[join [split $cont_str \\\\] /]"
  }
  set gPB(post_history) ""
  if ![info exists gPB(master_pid)] {
   UI_PB_com_DismissActiveWindow $w
   wm deiconify $w
   wm withdraw $w
   } else {
   comm::comm send -async $gPB(master_pid) [list UI_PB_com_DismissActiveWindow $w]
   comm::comm send -async $gPB(master_pid) [list wm withdraw $w]
   set cmd_str {if {$PID(activated) != ""} {comm::comm send $PID(activated) update}}
    comm::comm send  $gPB(master_pid) [list eval $cmd_str]
   }
   update
   if [catch { UI_PB_main_window_unit_sub } result] \
   {
    PB_com_unset_var gPB(post_in_progress)
    return [tk_messageBox -parent $gPB(top_window) -type ok -icon error \
    -title $gPB(msg,dialog,title) \
    -message "$gPB(msg,file_corruption)"]
   }
   update
   UI_PB_ActivateOpenFileOpts
   set gPB(session) NEW
   UI_PB_com_SetStatusbar "$gPB(machine,Status)"
   PB_com_unset_var gPB(post_in_progress)
   UI_PB_DestroyProgress
   if [info exists gPB(master_pid)] {
    comm::comm send -async $gPB(master_pid) [list __IncrNewPostNameNum]
   }
  }

#=======================================================================
proc __GetDescription {} {
  global gPB
  scan [$gPB(post_desc_win) index end] %d numlines
  set desc ""
  for { set i 1 } { $i < $numlines } { incr i } \
  {
   $gPB(post_desc_win) mark set last $i.0
   set line_text [$gPB(post_desc_win) get last "last lineend"]
   lappend desc $line_text
  }
  return $desc
 }

#=======================================================================
proc UI_PB_file_GetPostFragList { PUI_FILE_LIST \
  mach_type controller axisoption output_unit } {
  upvar $PUI_FILE_LIST pui_file_list
  global env
  global gPB ;#<06-11-09 wbh>
  set family_flag 0
  set new_flag 0
  if { $controller != "Generic"  &&  $controller != "" } {
   set family_flag 1
   set user_flag 0
   set prefix_file_name [file rootname $controller]
   if [string match "__NewPost_mod *" [info level -1]] \
   {
    global mach_cntl_type
    if [string match "User" $mach_cntl_type] \
    {
     set controller [string trimleft $controller]
     UI_PB_file_GetPostControllerType controller cntl_family
     set gPB(post_controller_type) $cntl_family
     UI_PB_file_SetCntlFamilyInfoForOldFile $controller
     if { [string compare $gPB(post_controller_type) ""] != 0 } \
     {
      UI_PB_file_GetCurrentSysControllerFullName $gPB(mach_sys_controller) templete_file $mach_type
      set prefix_file_name [file rootname $templete_file]
     }
     set user_flag 1
    }
    if [string match "" $::gPB(post_controller_type)] \
    {
     set family_flag 0
    } else \
    {
     if [string match "Wire EDM" $mach_type] \
     {
      set type_folder "wedm"
     } else \
     {
      set type_folder [string tolower $mach_type]
     }
     set family_com_dir "$env(PB_HOME)/pblib/controller/$type_folder/$gPB(cntl_sub_folder)"
     set family_com_name [string tolower $gPB(cntl_sub_folder)]
    }
    set new_flag 1
   } else \
   {
    lappend pui_file_list $controller
    if [string match "Wire EDM" $mach_type] \
    {
     set type_folder "wedm"
    } else \
    {
     set type_folder [string tolower $mach_type]
    }
    set family_com_dir "$env(PB_HOME)/pblib/controller/$type_folder/$gPB(cntl_sub_folder)"
    set family_com_name [string tolower $gPB(cntl_sub_folder)]
   }
  }
  switch $mach_type \
  {
   "Mill" \
   {
    if !$family_flag \
    {
     set file [file nativename $env(PB_HOME)/pblib/mill_base.pui]
     lappend pui_file_list $file
     set file ""
     if { $controller != "Generic"  &&  $controller != "" } \
     {
      lappend pui_file_list $controller
      set file [file nativename $env(PB_HOME)/pblib/mill_base.pb]
      lappend pui_file_list $file
      set file ""
     }
    } elseif $new_flag \
    {
     if $user_flag \
     {
      lappend pui_file_list $templete_file
     }
     lappend pui_file_list $controller
     if $user_flag \
     {
      set file [file nativename ${prefix_file_name}.pb]
      if [file exists $file] \
      {
       lappend pui_file_list $file
      }
      set file ""
     }
    }
    switch $axisoption \
    {
     "3"  \
     {
      set file [file nativename $env(PB_HOME)/pblib/mill_kin_3axis.pb]
     }
     "3MT"  \
     {
      set file [file nativename $env(PB_HOME)/pblib/mill_kin_xzc.pb]
     }
     "4H"  \
     {
      set file [file nativename $env(PB_HOME)/pblib/mill_kin_4axis_head.pb]
     }
     "4T"  \
     {
      set file [file nativename $env(PB_HOME)/pblib/mill_kin_4axis_table.pb]
     }
     "5HH" \
     {
      set file [file nativename $env(PB_HOME)/pblib/mill_kin_5axis_dual_head.pb]
     }
     "5HT" \
     {
      set file [file nativename $env(PB_HOME)/pblib/mill_kin_5axis_head_table.pb]
     }
     "5TT" \
     {
      set file [file nativename $env(PB_HOME)/pblib/mill_kin_5axis_dual_table.pb]
     }
    }
    if { $file != "" } \
    {
     if $family_flag \
     {
      set tail_name [file tail $file]
      if [file exists ${prefix_file_name}_$tail_name] \
      {
       set file [file nativename ${prefix_file_name}_$tail_name]
       } elseif [file exists $family_com_dir/${family_com_name}_$tail_name] \
      {
       set file [file nativename $family_com_dir/${family_com_name}_$tail_name]
      } else \
      {
       set gPB(mill_common_family_dir_prefix) "$family_com_dir/${family_com_name}"
      }
     }
     lappend pui_file_list $file
     set file ""
    }
    switch $output_unit \
    {
     "Inches" \
     {
      if [string match "3" $axisoption] \
      {
       set file [file nativename $env(PB_HOME)/pblib/mill_3_in.pb]
      } else \
      {
       set file [file nativename $env(PB_HOME)/pblib/mill_5_in.pb]
      }
     }
     "Millimeters" \
     {
      if [string match "3" $axisoption] \
      {
       set file [file nativename $env(PB_HOME)/pblib/mill_3_mm.pb]
      } else \
      {
       set file [file nativename $env(PB_HOME)/pblib/mill_5_mm.pb]
      }
     }
     "Dual" \
     {
      if [string match "3" $axisoption] \
      {
       set file [file nativename $env(PB_HOME)/pblib/mill_3_unit.pb]
      } else \
      {
       set file [file nativename $env(PB_HOME)/pblib/mill_5_unit.pb]
      }
     }
    }
    if { $file != "" } \
    {
     if $family_flag \
     {
      set tail_name [file tail $file]
      set tail_name [string range $tail_name 4 end]
      if [file exists ${prefix_file_name}${tail_name}] \
      {
       set file [file nativename ${prefix_file_name}${tail_name}]
       } elseif [file exists $family_com_dir/${family_com_name}${tail_name}] \
      {
       set file [file nativename $family_com_dir/${family_com_name}${tail_name}]
      }
     }
     lappend pui_file_list $file
     set file ""
    }
   }
   "Lathe" \
   {
    if !$family_flag \
    {
     set file [file nativename $env(PB_HOME)/pblib/lathe_base.pui]
     lappend pui_file_list $file
     set file ""
     if { $controller != "Generic"  &&  $controller != "" } \
     {
      lappend pui_file_list $controller
      set file [file nativename $env(PB_HOME)/pblib/lathe_base.pb]
      lappend pui_file_list $file
      set file ""
     }
    } elseif $new_flag \
    {
     if $user_flag \
     {
      lappend pui_file_list $templete_file
     }
     lappend pui_file_list $controller
     if $user_flag \
     {
      set file [file nativename ${prefix_file_name}.pb]
      if [file exists $file] \
      {
       lappend pui_file_list $file
      }
      set file ""
     }
    }
    switch $output_unit \
    {
     "Inches" \
     {
      set file [file nativename $env(PB_HOME)/pblib/lathe_in.pb]
     }
     "Millimeters" \
     {
      set file [file nativename $env(PB_HOME)/pblib/lathe_mm.pb]
     }
     "Dual" \
     {
      set file [file nativename $env(PB_HOME)/pblib/lathe_unit.pb]
     }
    }
    if { $file != "" } \
    {
     if $family_flag \
     {
      set tail_name [file tail $file]
      set tail_name [string range $tail_name 5 end]
      if [file exists ${prefix_file_name}${tail_name}] \
      {
       set file [file nativename ${prefix_file_name}${tail_name}]
       } elseif [file exists $family_com_dir/${family_com_name}${tail_name}] \
      {
       set file [file nativename $family_com_dir/${family_com_name}${tail_name}]
      }
     }
     lappend pui_file_list $file
     set file ""
    }
   }
   "Wire EDM" -
   "Wedm" \
   {
    if !$family_flag \
    {
     set file [file nativename $env(PB_HOME)/pblib/wedm_base.pui]
     lappend pui_file_list $file
     set file ""
     if { $controller != "Generic"  &&  $controller != "" } \
     {
      lappend pui_file_list $controller
      set file [file nativename $env(PB_HOME)/pblib/wedm_base.pb]
      lappend pui_file_list $file
      set file ""
     }
    } elseif $new_flag \
    {
     if $user_flag \
     {
      lappend pui_file_list $templete_file
     }
     lappend pui_file_list $controller
     if $user_flag \
     {
      set file [file nativename ${prefix_file_name}.pb]
      if [file exists $file] \
      {
       lappend pui_file_list $file
      }
      set file ""
     }
    }
    switch $axisoption \
    {
     "2"  \
     {
      set file [file nativename $env(PB_HOME)/pblib/wedm_kin_2axis.pb]
     }
     "4"  \
     {
      set file [file nativename $env(PB_HOME)/pblib/wedm_kin_4axis.pb]
     }
    }
    if { $file != "" } \
    {
     if $family_flag \
     {
      set tail_name [file tail $file]
      if [file exists ${prefix_file_name}_$tail_name] \
      {
       set file [file nativename ${prefix_file_name}_$tail_name]
       } elseif [file exists $family_com_dir/${family_com_name}_$tail_name] \
      {
       set file [file nativename $family_com_dir/${family_com_name}_$tail_name]
      }
     }
     lappend pui_file_list $file
     set file ""
    }
    switch $output_unit \
    {
     "Inches" \
     {
      set file [file nativename $env(PB_HOME)/pblib/wedm_in.pb]
     }
     "Millimeters" \
     {
      set file [file nativename $env(PB_HOME)/pblib/wedm_mm.pb]
     }
     "Dual" \
     {
      set file [file nativename $env(PB_HOME)/pblib/wedm_unit.pb]
     }
    }
    if { $file != "" } \
    {
     if $family_flag \
     {
      set tail_name [file tail $file]
      set tail_name [string range $tail_name 4 end]
      if [file exists ${prefix_file_name}${tail_name}] \
      {
       set file [file nativename ${prefix_file_name}${tail_name}]
       } elseif [file exists $family_com_dir/${family_com_name}${tail_name}] \
      {
       set file [file nativename $family_com_dir/${family_com_name}${tail_name}]
      }
     }
     lappend pui_file_list $file
     set file ""
    }
   }
  }
 }

#=======================================================================
proc CB_CntlType { w cntl_type } {
  global gPB
  if { [winfo manager $w.contr] == "pack" } { pack forget $w.contr }
  if { [winfo manager $w.user]  == "pack" } { pack forget $w.user }
  __ResetMachineWidgets
  switch -- $cntl_type \
  {
   "System"   {
    if { [PB_is_v3] >= 0 } {
     pack $w.contr -padx 5 -pady 7
     } else {
     pack $w.contr -padx 5 -pady 2
    }
    if [info exists gPB(previous_cntl_type)] {
     set gPB(post_controller_type) $gPB(previous_cntl_type)
     unset gPB(previous_cntl_type)
     set gPB(sys_first_choose_flag) 1 ;#<10-15-09 wbh>
    }
    if { $gPB(post_controller_type) != "" } \
    {
     __InvokeFamilySelection $gPB(family_opt_menu) $gPB(post_controller_type)
    } else \
    {
     if { [info exists gPB(mach_sys_controller)] && \
      ![string match "* - *" $gPB(mach_sys_controller)] } {
      __InvokeFamilySelection $gPB(family_opt_menu) $gPB(mach_sys_controller)
      } else {
      __InvokeFamilySelection $gPB(family_opt_menu) $gPB(default_controller_type)
     }
    }
    if [info exists gPB(sys_first_choose_flag)] {
     unset gPB(sys_first_choose_flag)
    }
    $w.contr.ent config -state disabled
   }
   "User"     {
    pack $w.user -padx 5 -pady 2
    if { ![info exists gPB(previous_cntl_type)] } \
    {
     if ![info exists gPB(post_controller_type)] \
     {
      set gPB(post_controller_type) ""
     }
     set gPB(previous_cntl_type) $gPB(post_controller_type)
    }
    if [info exists gPB(mach_user_controller)] \
    {
     CB_UserComboBox $w $gPB(mach_user_controller)
    }
    __SetMachineWidgetsByFile $gPB(mach_user_controller) 1
   }
   "Generic"  {
    if { ![info exists gPB(previous_cntl_type)] } \
    {
     if ![info exists gPB(post_controller_type)] \
     {
      set gPB(post_controller_type) ""
     }
     set gPB(previous_cntl_type) $gPB(post_controller_type)
    }
    set gPB(post_controller_type) ""
    set gPB(new_vnc_flag) 0
    $gPB(new_vnc_ckb) config -state disabled
   }
  }
 }

#=======================================================================
proc CB_MachType { win mach_type fa fb } {
  global gPB
  if 0 {
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
  }
  CreateMachineTypeOptMenu $fa $mach_type
  if { ![info exists gPB(sub_post_mode)] || $gPB(sub_post_mode) == 0 } {
   CreateCntlFamilyOptMenu $gPB(family_opt_menu) $mach_type 1
   if [string match "System" $::mach_cntl_type] \
   {
    __InvokeFamilySelection $gPB(family_opt_menu) $gPB(default_controller_type)
   }
  }
  CB_MachineAxisType $win $mach_type
  $fa.axis configure -command "CB_MachineAxisType $win $mach_type"
 }

#=======================================================================
proc CB_MachineAxisType { win mach_type args } {
  global gPB
  global mach_axis
  set gPB(mach_axis_remove_proc) $mach_axis
  set desc ""
  switch -- $mach_type \
  {
   "Wedm"  {
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
     "2"  {
      set desc "$gPB(new,lathe_2,desc,Label)"
     }
     "4"  {
      set desc "$gPB(new,lathe_4,desc,Label)"
     }
    }
   }
   "Mill"  {
    switch -- $mach_axis \
    {
     "3"   {
      set desc "$gPB(new,mill_3,desc,Label)"
     }
     "3MT" {
      set desc "3-Axis Mill-Turn (XZC)"
     }
     "4H"  {
      set desc "$gPB(new,mill_4H,desc,Label)"
     }
     "4T"  {
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
     "P" {
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
  global gPB env
  global machData
  if { [info exists machData] } \
  {
   set pb_book $gPB(book)
   set mctl_page_obj [lindex $Book::($pb_book,page_obj_list) 0]
   UI_PB_mach_MachDisplayParams $mctl_page_obj machData
  }
  PB_pps_ConvertOldUdeDefinitionStyle
 }

#=======================================================================
proc CreateCntlFamilyOptMenu { main_menu mach_type args } {
  global gPB
  global env
  set item_count 0
  set comb_menu $main_menu
  $comb_menu delete 0 end
  switch $mach_type \
  {
   "Mill"   {
    set dir [file dirname $env(PB_HOME)/pblib/controller/.]/mill
   }
   "Lathe"  {
    set dir [file dirname $env(PB_HOME)/pblib/controller/.]/lathe
   }
   "Wedm"   {
    set dir [file dirname $env(PB_HOME)/pblib/controller/.]/wedm
   }
  }
  global sys_controller_dir
  set sys_controller_dir $dir
  set dir [join [split $dir \$] \\\$]
  set gPB(cntl_sub_folder) ""
  set gPB(cntl_sub_type) 0
  set win_flag 1
  if ![string match windows $::tcl_platform(platform)] \
  {
   set gPB(cntl_sub_sub_folder) ""
   set win_flag 0
  }
  if { [llength $args] == 0 || [lindex $args 0] == 0 } \
  {
   $comb_menu add command -label "$gPB(new,generic,Label)" \
   -command [list __CntlFamilySelection "Generic"]
   $comb_menu add separator
  }
  __GetSubFoldersFrmFolder dir sub_folder_list
  if { [info exists gPB(priority_controller_family_list)] && \
  ![string match "" $gPB(priority_controller_family_list)] } \
  {
   set lower_folder_list [list]
   foreach sub_folder $sub_folder_list \
   {
    lappend lower_folder_list [string tolower $sub_folder]
   }
   set prioprity_list [list]
   foreach priority_family $gPB(priority_controller_family_list) \
   {
    set ind [lsearch $lower_folder_list [string tolower $priority_family]]
    if { $ind != -1 } \
    {
     lappend prioprity_list [lindex $sub_folder_list $ind]
     set sub_folder_list [lreplace $sub_folder_list $ind $ind]
    }
   }
   set ind 0
   foreach priority_family $prioprity_list \
   {
    set sub_folder_list [linsert $sub_folder_list $ind $priority_family]
    incr ind
   }
  }
  foreach sub_folder $sub_folder_list \
  {
   set ext_name [string tolower $sub_folder]
   set ext_name [join [split $ext_name] "_"]
   catch { destroy $comb_menu.$ext_name }
   set sub_dir "$dir/$sub_folder"
   set img_file [__GetFamilyImageByFolder sub_dir sub_folder]
   if { [string compare $img_file ""] != 0 } \
   {
    $comb_menu add cascade -image $img_file -menu $comb_menu.$ext_name
   } else \
   {
    $comb_menu add cascade -label $sub_folder -menu $comb_menu.$ext_name
   }
   menu $comb_menu.$ext_name -tearoff 0
   set delete_flag 1
   __GetSubFoldersFrmFolder sub_dir down_folder_list
   foreach down_folder $down_folder_list \
   {
    if $win_flag \
    {
     set temp_ctl_file "$sub_dir/$down_folder/$down_folder.pui"
     set temp_ctl_file [join [split $temp_ctl_file \\] ""]
     if [file exists $temp_ctl_file] \
     {
      set delete_flag 0
      $comb_menu.$ext_name add command -label $down_folder \
      -command [list __CntlFamilySelection $down_folder $sub_folder 1]
     }
    } else \
    {
     if [__GetExactPuiFileNameForCntlFamily sub_dir down_folder family_name] \
     {
      set delete_flag 0
      $comb_menu.$ext_name add command -label $family_name \
      -command [list __CntlFamilySelection $family_name $sub_folder 1 $down_folder]
     }
    }
   }
   if $delete_flag \
   {
    catch { destroy $comb_menu.$ext_name }
    catch { $comb_menu delete end }
   } else \
   {
    incr item_count
   }
  }
  if { [llength args] && [lindex $args 0] == 1 } \
  {
   __GetPuiFileNameFrmFolder dir pui_file_list
   if { $item_count && ![string match "" $pui_file_list] } \
   {
    $comb_menu add separator
   }
   foreach pui_file $pui_file_list \
   {
    $comb_menu add command -label $pui_file -command [list __CntlFamilySelection $pui_file]
    incr item_count
   }
  }
  return $item_count
 }

#=======================================================================
proc __GetFamilyImageByFolder { DIR IMAGE_NAME } {
  upvar $DIR dir
  upvar $IMAGE_NAME image_name
  set family_image ""
  set file_name [string tolower $image_name]_logo
  set temp_dir [join [split $dir \\] ""]
  set imagefile "$temp_dir/$file_name.xpm"
  if [file exists $imagefile] \
  {
   tix addbitmapdir $temp_dir
   set family_image [tix getimage $file_name]
  }
  return $family_image
 }

#=======================================================================
proc __GetSubFoldersFrmFolder { DIR FOLDER_LIST } {
  upvar $DIR dir
  upvar $FOLDER_LIST folder_list
  set folder_list [list]
  set old_dir [pwd]
  eval cd [join [split $dir] "\\ "]
  if ![string compare $::tix_version 4.1] \
  {
   if [catch {set opts [lsort [eval glob -nocomplain -- *]] } res] \
   {
    UI_PB_debug_Pause "glob : $res"
   } else \
   {
    foreach sub_opt $opts \
    {
     if [file isdirectory ${dir}/$sub_opt] \
     {
      lappend folder_list $sub_opt
     }
    }
   }
  } else \
  {
   if [catch {set opts [lsort [eval glob -nocomplain -type d -- *]] } res] \
   {
    UI_PB_debug_Pause "glob : $res"
   } else \
   {
    foreach sub_folder $opts \
    {
     lappend folder_list $sub_folder
    }
   }
  }
  eval cd [join [split $old_dir] "\\ "]
 }

#=======================================================================
proc __GetPuiFileNameFrmFolder { DIR PUI_LIST args } {
  upvar $DIR dir
  upvar $PUI_LIST pui_list
  set pui_list [list]
  set file_ext ".pui"
  if { [llength $args] } {
   set file_ext "."
   append file_ext [lindex $args 0]
  }
  set old_dir [pwd]
  if { ![catch { eval cd [join [split $dir] "\\ "] }] } {
   if { [catch { set opts [lsort [eval glob -nocomplain -- "*$file_ext"]] } res] } {
    UI_PB_debug_Pause "glob : $res"
    } else {
    foreach f $opts {
     lappend pui_list [file rootname $f]
    }
   }
  }
  eval cd [join [split $old_dir] "\\ "]
 }

#=======================================================================
proc __GetExactPuiFileNameForCntlFamily { MAIN_DIR SUB_FOLDER PUI_FILE args } {
  upvar $MAIN_DIR main_dir
  upvar $SUB_FOLDER sub_folder
  upvar $PUI_FILE pui_file
  set arg_len [llength $args]
  set ret_code 0
  set dir "$main_dir/$sub_folder"
  if { $arg_len == 0 } \
  {
   set pui_list [list]
  }
  set old_dir [pwd]
  eval cd [join [split $dir] "\\ "]
  set lower_sub_folder [string tolower $sub_folder]
  if [catch {set opts [lsort [eval glob -nocomplain -- "*.pui"]] } res] {
   UI_PB_debug_Pause "glob : $res"
   } else {
   foreach f $opts {
    if { [file extension $f] == ".pui" } {
     set file_name [file rootname $f]
     if $arg_len \
     {
      if [string match $pui_file $file_name] \
      {
       set ret_code 1 ;#<09-07-09 wbh> set value 1 for ret_code.
       break
      }
      continue
     }
     if [string match $sub_folder $file_name] \
     {
      set pui_file $file_name
      set ret_code 1
      break
     }
     set lower_file_name [string tolower $file_name]
     if { [string match $lower_sub_folder $lower_file_name] && \
      [file exists "$dir/$file_name.def"] && \
     [file exists "$dir/$file_name.tcl"] } \
     {
      set pui_file $file_name
      set ret_code 1
      break
     }
    }
   } ;# end foreach
  }
  eval cd [join [split $old_dir] "\\ "]
  return $ret_code
 }

#=======================================================================
proc __CntlFamilySelection { file_name args } {
  global gPB env
  UI_PB_debug_ForceMsg "\n %%%%%  gPB(post_controller_type) = $gPB(post_controller_type)  gPB(mach_sys_controller) = $gPB(mach_sys_controller) \n"
  UI_PB_debug_ForceMsg "\n %%%%%  file_name = >$file_name< args = >$args< \n"
  set gPB(post_controller_type) $file_name
  set gPB(mach_sys_controller) $file_name
  set gPB(cntl_sub_folder) ""
  set gPB(cntl_sub_type) 0
  set len [llength $args]
  if { $len == 0 } \
  {
   set gPB(post_controller_type) ""
   } elseif { $len == 2 } \
  {
   set gPB(cntl_sub_folder) [lindex $args 0]
   set gPB(cntl_sub_type)   [lindex $args 1]
   set gPB(mach_sys_controller) "$gPB(cntl_sub_folder) - $file_name"
   } elseif { $len == 3 } \
  {
   set gPB(cntl_sub_folder) [lindex $args 0]
   set gPB(cntl_sub_type)   [lindex $args 1]
   set gPB(cntl_sub_sub_folder) [lindex $args 2]
   set gPB(mach_sys_controller) "$gPB(cntl_sub_folder) - $file_name"
  }
  UI_PB_file_GetCurrentSysControllerFullName $gPB(mach_sys_controller) full_name
  if [file exists [file rootname $full_name].cdl] \
  {
   set ::ude_enable 1
  } else \
  {
   set ::ude_enable 0
  }
  if { [info exists gPB(new_enable_choose_vnc)] && $gPB(new_enable_choose_vnc) }\
  {
   if [file exists [file rootname $full_name]_vnc.tcl] \
   {
    $gPB(new_vnc_ckb) config -state normal
    set gPB(new_vnc_flag) 0 ;#<09-16-09 wbh> 0 was 1.
   } else \
   {
    $gPB(new_vnc_ckb) config -state disabled
    set gPB(new_vnc_flag) 0
   }
  }
  if { [info exists gPB(sys_first_choose_flag)] && \
   $gPB(sys_first_choose_flag) && \
  ![info exists gPB(previous_mach_axis)] } \
  {
   global mach_axis
   set gPB(previous_mach_axis) $mach_axis
  }
  __ResetMachineWidgets
  __SetMachineWidgetsByFile $full_name
 }

#=======================================================================
proc __InvokeFamilySelection { main_menu family_type args } {
  set last_index [$main_menu index end]
  if { [string match "none" $last_index] } \
  {
   return 0
  }
  set win_flag 1
  if { ![string match windows $::tcl_platform(platform)] } \
  {
   set win_flag 0
  }
  set ret_code 0
  set invoke_menu ""
  set invoke_index 0
  for { set i 0 } { $i <= $last_index } { incr i } \
  {
   set type [$main_menu type $i]
   if { [string match "command" $type] } \
   {
    set menu_label [$main_menu entrycget $i -label]
    if $win_flag \
    {
     if { [string compare [string tolower $menu_label] \
     [string tolower $family_type]] == 0 } \
     {
      set invoke_menu $main_menu
      set invoke_index $i
      set ret_code 1
      break
     }
    } else \
    {
     if { [string compare $menu_label $family_type ] == 0 } \
     {
      set invoke_menu $main_menu
      set invoke_index $i
      set ret_code 1
      break
     }
    }
    } elseif { [string match "cascade" $type] } \
   {
    $main_menu invoke $i
    set sub_menu [$main_menu entrycget $i -menu]
    if [__InvokeFamilySelection $sub_menu $family_type 1] \
    {
     return 1
    }
   }
  }
  if { [llength $args] == 0 || [lindex $args 0] != 1 } \
  {
   set type [$main_menu type 0]
   if { [string match "command" $type] } \
   {
    set invoke_menu $main_menu
    set invoke_index 0
   } elseif [string match "cascade" $type] \
   {
    $main_menu invoke 0
    set sub_menu [$main_menu entrycget 0 -menu]
    set invoke_menu $sub_menu
    set invoke_index 0
   }
  }
  if { $invoke_menu != "" } \
  {
   $invoke_menu invoke $invoke_index
   global gPB
   set choose_flag 0
   if { [info exists gPB(sys_first_choose_flag)] && $gPB(sys_first_choose_flag) } \
   {
    set choose_flag 1
   }
   if { $choose_flag && ![__IsAxisMatchedCntlFamily] } \
   {
    for { set i 0 } { $i <= $last_index } { incr i } \
    {
     if { $i != $invoke_index } \
     {
      $invoke_menu invoke $i
      if { [__IsAxisMatchedCntlFamily] } \
      {
       global mach_axis
       set mach_axis $gPB(previous_mach_axis)
       unset gPB(previous_mach_axis)
       return $ret_code
      }
     }
    }
    $invoke_menu invoke $invoke_index
   }
  }
  if { [info exists gPB(previous_mach_axis)] } \
  {
   unset gPB(previous_mach_axis)
  }
  return $ret_code
 }

#=======================================================================
proc __IsAxisMatchedCntlFamily { } {
  global gPB
  if { ![info exists gPB(new_machine_type_widget)] && \
  ![info exists gPB(previous_mach_axis)] } \
  {
   return 1
  }
  set ret_code 1
  set w_axis $gPB(new_machine_type_widget).axis
  set ent_list [$w_axis entries]
  if { [lsearch $ent_list $gPB(previous_mach_axis)] != -1 } \
  {
   if [string match "disabled" [$w_axis entrycget $gPB(previous_mach_axis) -state]] \
   {
    set ret_code 0
   }
  }
  return $ret_code
 }

#=======================================================================
proc UI_PB_file_SetCntlFamilyInfoForOldFile { file_name args } {
  global gPB env
  set family_type $gPB(post_controller_type)
  if { [string compare $family_type ""] == 0 } \
  {
   return 1
  }
  set get_flag 0
  if { [llength $args] > 0 && [string match "Get" [lindex $args 0]] } \
  {
   set get_flag 1
  }
  PB_file_GetPostAttr $file_name machine_type axis_option output_unit
  switch $machine_type \
  {
   "Mill"   {
    set dir [file dirname $env(PB_HOME)/pblib/controller/.]/mill
   }
   "Lathe"  {
    set dir [file dirname $env(PB_HOME)/pblib/controller/.]/lathe
   }
   "Wire EDM" -
   "Wedm"   {
    set dir [file dirname $env(PB_HOME)/pblib/controller/.]/wedm
   }
  }
  set win_flag 1
  if ![string match windows $::tcl_platform(platform)] \
  {
   set win_flag 0
  }
  set dir [join [split $dir \$] \\\$]
  __GetSubFoldersFrmFolder dir sub_folder_list
  foreach sub_folder $sub_folder_list \
  {
   set sub_dir "$dir/$sub_folder"
   __GetSubFoldersFrmFolder sub_dir down_folder_list
   if $win_flag \
   {
    if { [regexp -nocase -- $family_type $down_folder_list] && \
    [file exists "$sub_dir/$family_type/$family_type.pui"] } \
    {
     if $get_flag \
     {
      return [file nativename "$sub_dir/$family_type/$family_type.pui"]
     } else \
     {
      set gPB(mach_sys_controller) "$sub_folder - $family_type"
      set gPB(cntl_sub_folder) $sub_folder
      set gPB(cntl_sub_type) 1
      return 0
     }
    }
    } elseif { [regexp -nocase -- $family_type $down_folder_list] } \
   {
    foreach down_folder $down_folder_list \
    {
     if [__GetExactPuiFileNameForCntlFamily sub_dir down_folder family_type "Compare"] \
     {
      if $get_flag \
      {
       return [file nativename "$sub_dir/$down_folder/$family_type.pui"]
      } else \
      {
       set gPB(mach_sys_controller) "$sub_folder - $family_type"
       set gPB(cntl_sub_folder) $sub_folder
       set gPB(cntl_sub_type) 1
       set gPB(cntl_sub_sub_folder) $down_folder
       return 0
      }
     }
    }
   }
  }
  set gPB(post_controller_type) ""
  return 1
 }

#=======================================================================
proc __SetMachineWidgetsByFile { file_name args } {
  global gPB
  if { ![info exists gPB(new_machine_type_widget)] || \
  ![file exists $file_name] } \
  {
   return
  }
  set user_flag 0
  if { [llength $args] && [lindex $args 0] == 1 } \
  {
   set user_flag 1
   UI_PB_file_GetPostControllerType file_name family_type
   set gPB(post_controller_type) $family_type
   set file_name [UI_PB_file_SetCntlFamilyInfoForOldFile $file_name Get]
   if [string match "" $gPB(post_controller_type)] \
   {
    return
   }
  }
  set file_id [open $file_name r]
  set machine_type_start 0
  set axis_start 0
  set machine_type_list ""
  set axis_list ""
  while { [gets $file_id line] >= 0 } \
  {
   switch -glob -- $line \
   {
    "#  MACHINE TYPE START" {
     set machine_type_start 1
     continue
    }
    "#  MACHINE TYPE END"   {
     set machine_type_start 0
     continue
    }
    "#  MACHINE AXIS START"         {
     set axis_start 1
     continue
    }
    "#  MACHINE AXIS END"           {
     set axis_start 0
     continue
    }
    "#  HISTORY START"           {
     break
    }
    "## LISTING FILE START"      {
     break
    }
   }
   if { $machine_type_start } {
    set machine_type_list $line
   }
   if { $axis_start } {
    set axis_list $line
   }
  }
  close $file_id
  if [info exists gPB(lock_machine_type_list)] \
  {
   unset gPB(lock_machine_type_list)
  }
  if [info exists gPB(lock_axis_opt_list)] \
  {
   unset gPB(lock_axis_opt_list)
  }
  global mach_axis
  set w $gPB(new_machine_type_widget)
  if { $user_flag } \
  {
   set default_type_list [list Mill Lathe Wedm]
   set usable_type_list ""
   if { ![string match "" $machine_type_list] } \
   {
    foreach type $default_type_list \
    {
     set lbl [string tolower $type]
     $w.$lbl config -state disabled
    }
    foreach type $machine_type_list \
    {
     if { [lsearch $default_type_list $type] != -1 } \
     {
      lappend usable_type_list $type
      set lbl [string tolower $type]
      $w.$lbl config -state normal
     }
    }
    if [string match "" $usable_type_list] \
    {
     set gPB(new_machine_type) ""
     $w.axis config -state disabled
     set mach_axis ""
    } else \
    {
     if { [lsearch $usable_type_list $gPB(new_machine_type)] == -1 } \
     {
      set gPB(new_machine_type) [lindex $usable_type_list 0]
      set lbl [string tolower $gPB(new_machine_type)]
      $w.$lbl invoke
     }
     set gPB(lock_machine_type_list) $usable_type_list
    }
   } else \
   {
    set usable_type_list $default_type_list
   }
  } else \
  {
   set usable_type_list [list $gPB(new_machine_type)]
  }
  if [__GetAxisOptionList $usable_type_list $axis_list opt_list] \
  {
   set gPB(lock_axis_opt_list) $opt_list
   set change_flag 0
   set none_opt_flag 1
   set ent_list [$w.axis entries]
   foreach ent $ent_list \
   {
    if { [lsearch $opt_list $ent] != -1 } \
    {
     if $none_opt_flag \
     {
      set cur_opt $ent
     }
     set none_opt_flag 0
     $w.axis entryconfigure $ent -state normal
    } else \
    {
     if { !$change_flag && [string match $ent $mach_axis] } \
     {
      set change_flag 1
     }
     $w.axis entryconfigure $ent -state disabled
    }
   }
   set need_change_desc_flag 0
   if $none_opt_flag \
   {
    $w.axis config -state disabled
    set mach_axis ""
    set need_change_desc_flag 1
   } elseif $change_flag \
   {
    set mach_axis $cur_opt
    set need_change_desc_flag 1
   }
   if { $need_change_desc_flag && \
    [info exists gPB(top_window)] && \
   [winfo exists $gPB(top_window).new] } \
   {
    CB_MachineAxisType $gPB(top_window).new $gPB(new_machine_type)
   }
  }
 }

#=======================================================================
proc __GetAxisOptionList { machine_type_list axis_list OPT_LIST } {
  upvar $OPT_LIST opt_list
  set opt_list ""
  if { [string match "" $machine_type_list] || \
  [string match "" $axis_list] } \
  {
   return 0
  }
  foreach type $machine_type_list \
  {
   switch $type \
   {
    "Mill"  {
     if { [lsearch $axis_list "5"] != -1 } \
     {
      lappend opt_list 3 3MT 4T 4H 5HH 5TT 5HT
      continue
      } elseif { [lsearch $axis_list "4"] != -1 } \
     {
      lappend opt_list 3 3MT 4T 4H
      set temp_list [list 5HH 5TT 5HT]
      foreach temp_opt $temp_list \
      {
       if { [lsearch $axis_list $temp_opt] != -1 } \
       {
        lappend opt_list $temp_opt
       }
      }
      continue
     }
     foreach axis_opt $axis_list \
     {
      lappend opt_list $axis_opt
     }
    }
    "Lathe" {
     if { [lsearch $axis_list "2"] != -1 } \
     {
      lappend opt_list 2
     }
    }
    "Wedm"  {
     if { [lsearch $axis_list "4"] != -1 } \
     {
      lappend opt_list 2 4
      } elseif { [lsearch $axis_list "2"] != -1 } \
     {
      lappend opt_list 2
     }
    }
   }
  }
  return 1
 }

#=======================================================================
proc __ResetMachineWidgets { } {
  global gPB
  if [info exists gPB(lock_machine_type_list)] \
  {
   unset gPB(lock_machine_type_list)
  }
  if [info exists gPB(lock_axis_opt_list)] \
  {
   unset gPB(lock_axis_opt_list)
  }
  if { ![info exists gPB(new_machine_type_widget)] } \
  {
   return
  }
  set w $gPB(new_machine_type_widget)
  $w.mill  config -state normal
  $w.lathe config -state normal
  $w.wedm  config -state normal
  if [string match "" $gPB(new_machine_type)] \
  {
   set gPB(new_machine_type) Mill
  }
  $w.axis config -state normal
  set ent_list [$w.axis entries]
  foreach ent $ent_list \
  {
   $w.axis entryconfigure $ent -state normal
  }
  global mach_axis
  if { [string match "" $mach_axis] && [llength $ent_list] } \
  {
   set mach_axis [lindex $ent_list 0]
  }
 }

#=======================================================================
proc __ExistControllerTemplatesByMachType { mach_type } {
  global gPB env
  switch $mach_type \
  {
   "Mill"   {
    set dir [file dirname $env(PB_HOME)/pblib/controller/.]/mill
   }
   "Lathe"  {
    set dir [file dirname $env(PB_HOME)/pblib/controller/.]/lathe
   }
   "Wedm"   {
    set dir [file dirname $env(PB_HOME)/pblib/controller/.]/wedm
   }
  }
  set dir [join [split $dir \$] \\\$]
  set win_flag 1
  if ![string match windows $::tcl_platform(platform)] \
  {
   set win_flag 0
  }
  __GetSubFoldersFrmFolder dir sub_folder_list
  foreach sub_folder $sub_folder_list \
  {
   set sub_dir "$dir/$sub_folder"
   __GetSubFoldersFrmFolder sub_dir down_folder_list
   foreach down_folder $down_folder_list \
   {
    if $win_flag \
    {
     if [file exists "$sub_dir/$down_folder/$down_folder.pui"] \
     {
      return 1
     }
    } else \
    {
     if [__GetExactPuiFileNameForCntlFamily sub_dir down_folder family_name] \
     {
      return 1
     }
    }
   }
  }
  return 0
 }

#=======================================================================
proc UI_PB_file_CheckNameForOldVersion { type NAME_LIST {check_all 1} } {
  upvar $NAME_LIST name_list
  global post_object
  global gPB
  set name_list [list]
  set ret_code 0
  if [string match "block" $type] {
   set max_len  64
   foreach blk_obj $Post::($post_object,blk_obj_list) {
    if { [string length "$block::($blk_obj,block_name)"] > $max_len } {
     set ret_code 1
     lappend name_list "$block::($blk_obj,block_name)"
     if { !$check_all } {
      break
     }
    }
   }
   if { $ret_code == 0 && [info exists gPB(block_long_name_flag)] } {
    unset gPB(block_long_name_flag)
   }
   } elseif [string match "address" $type] {
   set max_len  32
   foreach add_obj $Post::($post_object,add_obj_list) {
    if { [string length "$address::($add_obj,add_name)"] > $max_len } {
     set ret_code 1
     lappend name_list "$address::($add_obj,add_name)"
     if { !$check_all } {
      break
     }
    }
   }
   if { $ret_code == 0 && [info exists gPB(address_long_name_flag)] } {
    unset gPB(address_long_name_flag)
   }
  }
  return $ret_code
 }

#=======================================================================
proc UI_PB_file_ShowLongNameWarning { BLOCK_LIST ADDRESS_LIST } {
  upvar $BLOCK_LIST blk_list
  upvar $ADDRESS_LIST add_list
  global gPB
  global longname_w
  if [info exists longname_w] { destroy $longname_w }
  set longname_w $gPB(active_window).longname_warning
  set w $longname_w
  toplevel $w
  wm title $w "$gPB(msg,block_address,check,title)"
  wm geometry $w 600x500+300+200
  set blk_len [llength $blk_list]
  set add_len [llength $add_list]
  if { $blk_len > 0 && $add_len > 0 } {
   frame $w.top
   frame $w.btm
   pack $w.top $w.btm -side top -expand yes -fill both -pady 10
   __CreateNameList $w.top "$gPB(msg,old_block,maximum_length)" $blk_list
   __CreateNameList $w.btm "$gPB(msg,old_address,maximum_length)" $add_list
   } elseif { $blk_len > 0 } {
   __CreateNameList $w "$gPB(msg,old_block,maximum_length)" $blk_list
   } else {
   __CreateNameList $w "$gPB(msg,old_address,maximum_length)" $add_list
  }
  UI_PB_com_PositionWindow $w
 }

#=======================================================================
proc __CreateNameList { w lbl_text name_list } {
  global paOption
  if { ![string match "" $lbl_text] } {
   label $w.lbl -text "$lbl_text" -anchor w
   pack $w.lbl -side top -anchor w -padx 10 -pady 10
  }
  tixScrolledText $w.ent -scrollbar auto -height 200
  pack $w.ent -side top -expand yes -fill both -padx 10 -pady 5
  set msg ""
  foreach name $name_list {
   append msg "$name\n"
  }
  set ftext [$w.ent subwidget text]
  $ftext config -bg $paOption(table_bg)
  $ftext insert end $msg
  $ftext configure -state disabled
 }

#=======================================================================
proc __ValidateLongName { } {
  global gPB
  if { [info exists gPB(auto_qc)] && $gPB(auto_qc) == 1} {
   return 1
  }
  if { [info exist ::env(SUB_POST_MODE)] && $::env(SUB_POST_MODE) == 1 } \
  {
   if { [info exists ::env(UNIT_SUB_POST_MODE)] && $::env(UNIT_SUB_POST_MODE) == 1 } {
    return 1
    } else {
   }
  }
  set ret_code 1
  set long_blk_list [list]
  set long_add_list [list]
  if { [info exists gPB(block_long_name_flag)] && \
   $gPB(block_long_name_flag) } {
   if [UI_PB_file_CheckNameForOldVersion "block" long_blk_list] {
    set ret_code 0
   }
  }
  if { [info exists gPB(address_long_name_flag)] && \
   $gPB(address_long_name_flag) } {
   if [UI_PB_file_CheckNameForOldVersion "address" long_add_list] {
    set ret_code 0
   }
  }
  if { $ret_code == 0 } {
   tk_messageBox -parent [UI_PB_com_AskActiveWindow] \
   -icon error -type ok \
   -message $gPB(msg,block_address,maximum_length)
   UI_PB_file_ShowLongNameWarning long_blk_list long_add_list
  }
  return $ret_code
 }

#=======================================================================
proc UI_PB_file_CheckMachResolution { { action "Continue" } } {
  global gPB mom_kin_var
  global dismatch_w
  UI_PB_file_DeleteMachResolutionCheckWindow
  if { [info exists gPB(suppress_check_resolution)] && $gPB(suppress_check_resolution) } {
   return 1
  }
  if { [info exists gPB(auto_qc)] && $gPB(auto_qc) == 1} {
   return 1
  }
  set add_x [PB_com_FindObjFrmName "X" "address"]
  set add_y [PB_com_FindObjFrmName "Y" "address"]
  set add_z [PB_com_FindObjFrmName "Z" "address"]
  if { $add_x >= 0 && $address::($add_x,word_status) == 1 } {
   set add_x -1
  }
  if { $add_y >= 0 && $address::($add_y,word_status) == 1 } {
   set add_y -1
  }
  if { $add_z >= 0 && $address::($add_z,word_status) == 1 } {
   set add_z -1
  }
  set msg ""
  set dismatch_flag 0
  set linear_prec [__GetDecimalCount $mom_kin_var(\$mom_kin_machine_resolution)]
  if { $add_x >= 0 && [__CheckAddressFormat $add_x $linear_prec] } {
   set dismatch_flag 1
   append msg "$gPB(address,tab,Label) X "
  }
  if { $add_y >= 0 && [__CheckAddressFormat $add_y $linear_prec] } {
   if $dismatch_flag {
    append msg "& Y "
    } else {
    append msg "$gPB(address,tab,Label) Y "
   }
   set dismatch_flag 1
  }
  if { $add_z >= 0 && [__CheckAddressFormat $add_z $linear_prec] } {
   if $dismatch_flag {
    append msg "& Z "
    } else {
    append msg "$gPB(address,tab,Label) Z "
   }
   set dismatch_flag 1
  }
  if { $dismatch_flag } {
   append msg ": " "$gPB(msg,check_resolution,linear) \n\n"
  }
  set add_4 [PB_com_FindObjFrmName "fourth_axis" "address"]
  set add_5 [PB_com_FindObjFrmName "fifth_axis" "address"]
  if { $add_4 >= 0 && $address::($add_4,word_status) == 1 } {
   set add_4 -1
  }
  if { $add_5 >= 0 && $address::($add_5,word_status) == 1 } {
   set add_5 -1
  }
  if { $add_4 >= 0 && [info exists mom_kin_var(\$mom_kin_4th_axis_min_incr)] } {
   set axis_4th_prec [__GetDecimalCount $mom_kin_var(\$mom_kin_4th_axis_min_incr)]
   if { [__CheckAddressFormat $add_4 $axis_4th_prec] } {
    set dismatch_flag 1
    append msg "$gPB(address,tab,Label) fourth_axis : $gPB(msg,check_resolution,rotary) \n\n"
   }
  }
  if { $add_5 >= 0 && [info exists mom_kin_var(\$mom_kin_5th_axis_min_incr)] } {
   set axis_5th_prec [__GetDecimalCount $mom_kin_var(\$mom_kin_5th_axis_min_incr)]
   if { [__CheckAddressFormat $add_5 $axis_5th_prec] } {
    set dismatch_flag 1
    append msg "$gPB(address,tab,Label) fifth_axis : $gPB(msg,check_resolution,rotary) \n"
   }
  }
  if { $dismatch_flag } {
   set dismatch_w  [UI_PB_com_AskActiveWindow].dismatch_format_warning
   set w $dismatch_w
   toplevel $w
   if [string match "Pend" $action] {
    global resolution_check_flag
    if [info exists resolution_check_flag] { unset resolution_check_flag }
    UI_PB_com_CreateTransientWindow $w "$gPB(msg,check_resolution,title)" "500x330+400+400" "" "" "" ""
    set label_list {"gPB(machine,resolution,continue,Label)" "gPB(machine,resolution,abort,Label)"}
    set cb_arr(gPB(machine,resolution,continue,Label)) "__ContinueCheck $w"
    set cb_arr(gPB(machine,resolution,abort,Label))    "__AbortCheck $w"
    wm protocol $w WM_DELETE_WINDOW "__AbortCheck $w" ;#<03-31-2015 gsl> {set a 1}
    UI_PB_com_CreateButtonBox $w label_list cb_arr
    __CreateNameList $w "" "\{$msg\}"
    set gPB(suppress_check_resolution) 0
    checkbutton $w.chk -text "$gPB(machine,resolution,check,Label)" \
    -variable gPB(suppress_check_resolution) \
    -relief flat -anchor w
    pack $w.chk -side top -fill both -padx 10 -pady 7
    grab $w
    tkwait window $w
    return $resolution_check_flag
    } else {
    wm title $w "$gPB(msg,check_resolution,title)"
    wm geometry $w 500x300+400+400
    __CreateNameList $w "" "\{$msg\}"
    UI_PB_com_PositionWindow $w
    if { $::tcl_platform(platform) == "windows" && $::tcl_version >= 8.4 } {
     wm attributes $w -topmost 1
    }
   }
  }
  if { $dismatch_flag } {
   return 0
   } else {
   return 1
  }
 }

#=======================================================================
proc __GetDecimalCount { var } {
  set first_idx [string first "." $var]
  if { $first_idx == -1 } { return 0 }
  set len [string length $var]
  set last_idx [expr $first_idx + 1]
  if { $last_idx == $len } { return 0 }
  for { set i $last_idx } { $i < $len } { incr i } {
   if { [string compare [string index $var $i] "0"] != 0 } {
    break
   }
   incr last_idx
  }
  return [expr $last_idx - $first_idx]
 }

#=======================================================================
proc __CheckAddressFormat { var_addr var_deci } {
  if { $var_addr <= 0 } { return 0 }
  set var_format $address::($var_addr,add_format)
  if { ![string match "Numeral" $format::($var_format,for_dtype)] } {
   return 0
  }
  if { $var_deci > $format::($var_format,for_valspart) } {
   return 1
   } else {
   return 0
  }
 }

#=======================================================================
proc UI_PB_file_DeleteMachResolutionCheckWindow { } {
  global dismatch_w
  if { [info exists dismatch_w] && [winfo exists $dismatch_w] } \
  {
   destroy $dismatch_w
  }
 }

#=======================================================================
proc __ContinueCheck { w } {
  global resolution_check_flag
  set resolution_check_flag 1
  destroy $w
 }

#=======================================================================
proc __AbortCheck { w } {
  global resolution_check_flag
  set ::gPB(suppress_check_resolution) 0
  set resolution_check_flag 0
  destroy $w
 }
