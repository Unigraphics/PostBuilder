

#=======================================================================
proc PB_mdfa_ImportMdfa { } {
  global gPB
  global env
  global tcl_platform
  if { $gPB(use_info) } \
  {
   UI_PB_chelp_DisplayMenuItemCsh $gPB(file_menu)
   return
  }
  UI_PB_com_SetStatusbar "$gPB(open,Status)"
  UI_PB_file_GetWorkFileDir
  set file_name [file join $gPB(work_dir) $gPB(work_file)]
  if { ![file exists $file_name] } {
   set gPB(work_file) ""
  }
  if {$tcl_platform(platform) == "unix"} \
  {
    ;
   } elseif {$tcl_platform(platform) == "windows"} \
  {
   UI_PB_file_OpenMDFA_win
  }
  
  
  
  #set pui [file rootname $post].pui
  #set def [file rootname $post].def
  #set tcl [file rootname $post].tcl
  
  tk_messageBox -parent $gPB(top_window) -type ok -icon error \
  -title $gPB(msg,dialog,title) \
  -message "$gPB(msg,file_missing)."
  
 }
 

#=======================================================================
proc UI_PB_file_OpenMDFA_win {} {
  global tixOption
  global paOption
  global gPB
  global env
  set types {
   { {MDFA files} {.mdfa} }
   { {MDF files} {.mdf} }
   { {All files} {*.*} }
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
   if {$::tcl_platform(platform) == "windows" && $::tcl_version == "8.4"} {
    if {[info exists env(MULTI_INTERP)] && $env(MULTI_INTERP) == 1} {
     after 100 [list focus -force .widget]
    }
   }
   set filename [tk_getOpenFile -filetypes $types \
   -title "$gPB(open,title,Label)" \
   -parent $acwin \
   -defaultextension "mdfa" \
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
