set gPB(pb_cmd_icon) [tix getimage pb_cmd]

#=======================================================================
proc UI_PB_ProgTpth_CustomCmd { book_id cmd_page_obj } {
  global pb_cmd_procname
  set Page::($cmd_page_obj,page_id) [$book_id subwidget \
  $Page::($cmd_page_obj,page_name)]
  if { [info exists Page::($cmd_page_obj,active_cmd_obj)] } \
  {
   unset Page::($cmd_page_obj,active_cmd_obj)
  }
  Page::CreatePane $cmd_page_obj
  UI_PB_cmd_AddComponentsLeftPane cmd_page_obj
  Page::CreateTree $cmd_page_obj
  UI_PB_cmd_CreateTreePopup cmd_page_obj
  UI_PB_cmd_CreateTreeElements cmd_page_obj
  pack config $Page::($cmd_page_obj,canvas_frame) -padx 3
  UI_PB_cmd_AddActionButtons cmd_page_obj
  set pb_cmd_procname ""
  UI_PB_cmd_CreateCmdBlkPage cmd_page_obj 0
  set Page::($cmd_page_obj,double_click_flag) 0
 }

#=======================================================================
proc UI_PB_cmd_AddActionButtons { PAGE_OBJ } {
  upvar $PAGE_OBJ page_obj
  global paOption
  set canvas_frm $Page::($page_obj,canvas_frame)
  set box1_frm [frame $canvas_frm.box1]
  pack $box1_frm -side bottom -fill x
  set label_list {"gPB(nav_button,default,Label)" \
  "gPB(nav_button,restore,Label)"}
  set cb_arr(gPB(nav_button,default,Label)) \
  "UI_PB_cmd_CmdBlkDefault_CB $page_obj"
  set cb_arr(gPB(nav_button,restore,Label)) \
  "UI_PB_cmd_CmdBlkRestore_CB $page_obj"
  UI_PB_com_CreateButtonBox $box1_frm label_list cb_arr
 }

#=======================================================================
proc UI_PB_cmd_CmdBlkRestore_CB { page_obj } {
  global pb_cmd_procname
  if { ![info exists Page::($page_obj,active_cmd_obj)] } \
  {
   return
  }
  UI_PB_cmd_DeleteCmdProc $page_obj
  set cmd_obj $Page::($page_obj,active_cmd_obj)
  array set rest_cmd_attr $command::($cmd_obj,rest_value)
  command::setvalue $cmd_obj rest_cmd_attr
  UI_PB_cmd_DisplayCmdProc cmd_obj page_obj
 }

#=======================================================================
proc UI_PB_cmd_CmdBlkDefault_CB { page_obj } {
  global pb_cmd_procname
  if { ![info exists Page::($page_obj,active_cmd_obj)] } \
  {
   return
  }
  UI_PB_cmd_DeleteCmdProc $page_obj
  set cmd_obj $Page::($page_obj,active_cmd_obj)
  array set def_cmd_attr $command::($cmd_obj,def_value)
  command::setvalue $cmd_obj def_cmd_attr
  UI_PB_cmd_DisplayCmdProc cmd_obj page_obj
 }

#=======================================================================
proc UI_PB_cmd_DeleteCmdProc { page_obj } {
  set text_frm $Page::($page_obj,text_widget)
  set sta [lindex [$text_frm config -state] end]
  $text_frm config -state normal
  $text_frm delete 1.0 end
  $text_frm config -state $sta
 }

#=======================================================================
proc UI_PB_cmd_SaveCmdProc { page_obj args } {
  if { ![info exists Page::($page_obj,active_cmd_obj)] } {
   return 0
  }
  set cmd_obj $Page::($page_obj,active_cmd_obj)
  UI_PB_cmd_GetProcFromTextWin $page_obj proc_text
  if { [llength $args] == 0 } {
   if { ![_cmd_ValidateCmdLineOK $cmd_obj $proc_text] } {
    return 0
   }
   } elseif { [lindex $args 0] != "not_verify" } {
   if { ![_cmd_ValidateCmdLineOK $cmd_obj $proc_text] } {
    return 0
   }
  }
  set command::($cmd_obj,proc) $proc_text
  return 1
 }

#=======================================================================
proc UI_PB_cmd_CreateTreeElements { PAGE_OBJ } {
  upvar $PAGE_OBJ page_obj
  global paOption
  set tree $Page::($page_obj,tree)
  set h [$tree subwidget hlist]
  $h config -bg $paOption(tree_bg)
  uplevel #0 set TRANSPARENT_GIF_COLOR [$h cget -bg]
  $tree config \
  -command   "UI_PB_cmd_EditCmdName $page_obj" \
  -browsecmd "UI_PB_cmd_SelectItem  $page_obj"
 }

#=======================================================================
proc UI_PB_cmd_CreateTreePopup { PAGE_OBJ } {
  upvar $PAGE_OBJ page_obj
  set tree $Page::($page_obj,tree)
  set h [$tree subwidget hlist]
  set popup [menu $h.pop -tearoff 0]
  set Page::($page_obj,tree_popup) $popup
  bind $h <3> "UI_PB_cmd_CreateTreePopupElements $page_obj %X %Y %x %y"
 }

#=======================================================================
proc UI_PB_cmd_CreateTreePopupElements { page_obj X Y x y } {
  global gPB
  set tree $Page::($page_obj,tree)
  set h [$tree subwidget hlist]
  raise $gPB(main_window)
  set cursor_entry [$h nearest $y]
  set indent [$h cget -indent]
  UI_PB_debug_ForceMsg "\n+++ selected_index : >$Page::($page_obj,selected_index)<  cursor_entry : >$cursor_entry<<<\n"
  if { [string compare $cursor_entry "0"] != 0 } \
  {
   if { ![info exists Page::($page_obj,selected_index)] } {
    set Page::($page_obj,selected_index) -1
   }
   if { [string match $Page::($page_obj,selected_index) $cursor_entry] } {
    set Page::($page_obj,selected_index) -1
   }
   UI_PB_cmd_SelectItem $page_obj $cursor_entry
  }
  set popup $Page::($page_obj,tree_popup)
  set active_index [$h info selection]
  if { $x >= [expr $indent * 2] && \
   $Page::($page_obj,double_click_flag) == 0 && \
  $active_index == $cursor_entry } \
  {
   $popup delete 0 end
   set indx_string [$h entrycget $active_index -text]
   set disabled_rename_flag 0
   set disabled_delete_flag 0
   set disabled_create_flag 0
   if { [UI_PB_cmd_CheckCmdState $indx_string "rename"] == 0 } \
   {
    set disabled_rename_flag 1
   }
   if { [UI_PB_cmd_CheckCmdState $indx_string "delete"] == 0 } \
   {
    set disabled_delete_flag 1
   }
   if { [string match "PB_CMD_before_motion" $indx_string] || \
   [string match "PB_CMD_kin_*" $indx_string] } \
   {
    set disabled_rename_flag 1
   }
   if { [string match "PB_CMD_before_motion" $indx_string] || \
    [string match "PB_CMD_kin_*" $indx_string] || \
   [string match "PB_CMD_vnc__*" $indx_string] } \
   {
    set disabled_delete_flag 1
   }
   if { [string match "PB_CMD_before_motion" $indx_string] || \
   [string match "PB_CMD_kin_*" $indx_string] } \
   {
    set disabled_create_flag 1
   }
   set cmd_obj [PB_com_FindObjFrmName $indx_string command]
   if { $cmd_obj >= 0 } {
    if { $command::($cmd_obj,is_dummy) } {
     set disabled_rename_flag 1
     set disabled_delete_flag 1
     set disabled_create_flag 1
    }
   }
   if { $disabled_rename_flag } \
   {
    $popup add command -label "$gPB(tree,rename,Label)" -state disabled \
    -command ""
   } else \
   {
    $popup add command -label "$gPB(tree,rename,Label)" -state normal \
    -command "UI_PB_cmd_EditCmdName $page_obj $active_index"
   }
   $popup add sep
   if { $disabled_create_flag } \
   {
    $popup add command -label "$gPB(tree,create,Label)" -state disabled -command ""
    } else {
    global LicInfo
    if { [info exists LicInfo(user_right_limit)] && $LicInfo(user_right_limit) == "YES" } {
     if { [string match "PB_CMD_vnc__*" $indx_string] } {
      if { [string match "PB_CMD_vnc____*" $indx_string] } {
       $popup add command -label "$gPB(tree,create,Label)" -state normal \
       -command "UI_PB_cmd_CreateACmdBlock $page_obj"
       } else {
       $popup add command -label "$gPB(tree,create,Label)" -state disabled \
       -command ""
      }
      } else {
      $popup add command -label "$gPB(tree,create,Label)" -state normal \
      -command ""
     }
     } else {
     $popup add command -label "$gPB(tree,create,Label)" -state normal \
     -command "UI_PB_cmd_CreateACmdBlock $page_obj"
    }
   }
   if { $disabled_delete_flag } \
   {
    $popup add command -label "$gPB(tree,cut,Label)" -state disabled \
    -command ""
   } else \
   {
    $popup add command -label "$gPB(tree,cut,Label)" -state normal \
    -command "UI_PB_cmd_CutACmdBlock $page_obj"
   }
   if { [info exists Page::($page_obj,buff_cmd_obj)] } \
   {
    $popup add command -label "$gPB(tree,paste,Label)" -state normal \
    -command "UI_PB_cmd_PasteACmdBlock $page_obj"
   } else \
   {
    $popup add command -label "$gPB(tree,paste,Label)" -state disabled \
    -command ""
   }
   tk_popup $popup $X $Y
  }
 }

#=======================================================================
proc UI_PB_cmd_EditCmdName { page_obj index } {
  global gPB
  global paOption
  global pb_cmd_procname
  set tree $Page::($page_obj,tree)
  set page_name $Page::($page_obj,page_name)
  if { [string match "cod" $page_name] } {
   set tag 1
   } else {
   set tag 0
  }
  set HLIST [$tree subwidget hlist]
  set indx_string [$HLIST entrycget $index -text]
  if { [string match "PB_CMD_before_motion" $indx_string] || \
  [string match "PB_CMD_kin_*" $indx_string]} \
  {
   return
  }
  if { [UI_PB_cmd_CheckCmdState $indx_string "rename"] == 0 } \
  {
   return
  }
  if 0 {
   global mom_sys_arr
   if { [info exists mom_sys_arr(post_startblk)] && \
   [string match $mom_sys_arr(post_startblk) $indx_string] } \
   {
    return
   }
  }
  if { $tag } {
   global mom_sim_arr
   if { [string match "Standalone" $::mom_sys_arr(VNC_Mode)] } {
    if { [info exists mom_sim_arr(\$mom_sim_user_com_list)] } {
     if { [lsearch $mom_sim_arr(\$mom_sim_user_com_list) $indx_string] < 0 } {
      UI_PB_debug_ForceMsg "\n+++ indx_string : >$indx_string< cannot be renamed.\n"
      return
     }
    }
    } else {
    if { [info exists mom_sim_arr(\$mom_sim_sub_user_list)] } {
     if { [lsearch $mom_sim_arr(\$mom_sim_sub_user_list) $indx_string] < 0 } {
      UI_PB_debug_ForceMsg "\n+++ indx_string : >$indx_string< cannot be renamed.\n"
      return
     }
    }
   }
   if { [info exists mom_sim_arr(\$mom_sim_pre_com_list)] } {
    set token_list $mom_sim_arr(\$mom_sim_pre_com_list)
    set token_cmd_list [list]
    foreach token $token_list {
     set item [join [split $token] "_"]
     set item "PB_CMD_vnc__$item"
     lappend token_cmd_list $item
    }
    if { [lsearch $token_cmd_list $indx_string] >= 0 } {
     UI_PB_debug_ForceMsg "\n+++ token_cmd_list : >$token_cmd_list<\n"
     UI_PB_debug_ForceMsg "\n+++ indx_string : >$indx_string< cannot be renamed.\n"
     return
    }
   }
   set file2 [tix getimage pb_cmd]
  }
  set next_ent [$HLIST info next $index]
  if { [string match "" $next_ent] } {
   set prev_ent [$HLIST info prev $index]
  }
  $HLIST delete entry $index
  set col [string range $index 2 end]
  if { [winfo exists $HLIST.cmd] != 1 } \
  {
   set new_frm [frame $HLIST.cmd -bg $paOption(tree_bg)]
   label $new_frm.lbl -text "" -bg $paOption(tree_bg)
   set img_id [image create compound -window $new_frm.lbl]
   if { $tag } {
    $img_id add image -image $file2
    } else {
    $img_id add image -image $gPB(pb_cmd_icon)
   }
   $new_frm.lbl config -image $img_id
   unset img_id
   pack $new_frm.lbl -side left
   if { $tag } {
    label $new_frm.pb -text " PB_CMD_vnc__" -bg $paOption(tree_bg) -anchor e
    } else {
    label $new_frm.pb -text " PB_CMD_" -bg $paOption(tree_bg) -anchor e
   }
   entry $new_frm.ent -bd 1 -relief solid -state normal \
   -textvariable pb_cmd_procname -justify left
   pack $new_frm.pb -side left
   pack $new_frm.ent -side left;# -padx 2
  } else \
  {
   set new_frm $HLIST.cmd
  }
  set wid [string length $pb_cmd_procname]
  if { $wid < $gPB(MOM_block_name_len) } { set wid $gPB(MOM_block_name_len) }
  $new_frm.ent config -width $wid
  if { [string match "$::gPB(condition_cmd_prefix)*" $indx_string] } {
   $new_frm.pb config -text "$::gPB(condition_cmd_prefix)"
   } elseif { [string match "$::gPB(check_block_cmd_prefix)*" $indx_string] } {
   $new_frm.pb config -text "$::gPB(check_block_cmd_prefix)"
   } elseif { [string match "PB_CMD_vnc__**" $indx_string] } {
   $new_frm.pb config -text "PB_CMD_vnc__"
   } else {
   $new_frm.pb config -text "PB_CMD_"
  }
  if { [string match "" $next_ent] } {
   $HLIST add $index -itemtype window -window $new_frm -after $prev_ent
   } else {
   $HLIST add $index -itemtype window -window $new_frm -before $next_ent
  }
  $HLIST see $index
  focus $new_frm.ent
  bind $new_frm.ent <Return> "UI_PB_cmd_UpdateCmdEntry $page_obj $index"
  bind $new_frm.ent <KeyPress> "UI_PB_com_DisableKeysForProc %W %K"
  bind $new_frm.ent <KeyRelease> { %W config -state normal }
  __cmd_RestoreNamePopup $new_frm.ent $page_obj
  $new_frm.ent selection range 0 end
  $new_frm.ent icursor end
  set Page::($page_obj,double_click_flag) 1
  set Page::($page_obj,rename_index) $index
  $HLIST entryconfig $index -state disabled
  bind $new_frm.lbl <1> "UI_PB_cmd_UpdateCmdEntry $page_obj $index; __cmd_ConfigActionButtons $page_obj"
  bind $new_frm.pb  <1> "UI_PB_cmd_UpdateCmdEntry $page_obj $index; __cmd_ConfigActionButtons $page_obj"
  grab $Page::($page_obj,tree)
 }

#=======================================================================
proc __cmd_RestoreNamePopup { w page_obj } {
  global gPB
  global pb_cmd_procname
  set page_name $Page::($page_obj,page_name)
  if { [string match "cod" $page_name] } {
   set tag 1
   } else {
   set tag 0
  }
  if { ![winfo exists $w.pop] } {
   menu $w.pop -tearoff 0
   $w.pop add command -label "$gPB(nav_button,restore,Label)"
  }
  set active_cmd $Page::($page_obj,active_cmd_obj)
  if { $tag } {
   set str [string range $command::($active_cmd,name) 12 end]
   } else {
   if { [string match "$::gPB(condition_cmd_prefix)*" $command::($active_cmd,name)] } {
    set len [string length $::gPB(condition_cmd_prefix)]
    set str [string range $command::($active_cmd,name) $len end]
    } elseif { [string match "$::gPB(check_block_cmd_prefix)*" $command::($active_cmd,name)] } {
    set len [string length $::gPB(check_block_cmd_prefix)]
    set str [string range $command::($active_cmd,name) $len end]
    } else {
    set str [string range $command::($active_cmd,name) 7 end]
   }
  }
  $w.pop entryconfig 0 -command "set pb_cmd_procname $str;\
  $w icursor end"
  bind $w <3> "tk_popup $w.pop %X %Y"
 }

#=======================================================================
proc __cmd_DenyCmdName  { name args } {
  if { [string match "PB_CMD_kin_*" $name] } {
   global gPB
   tk_messageBox -parent [UI_PB_com_AskActiveWindow] -type ok -icon error \
   -message "\"PB_CMD_kin_*\" $gPB(cust_cmd,name_msg_1)"
   set argc [llength $args]
   if { $argc > 0 } \
   {
    set page_obj [lindex $args 0]
    if { $page_obj } \
    {
     set tree $Page::($page_obj,tree)
     set HLIST [$tree subwidget hlist]
     $HLIST selection clear
     $HLIST anchor clear
     if { $argc > 1 } \
     {
      set index [lindex $args 1]
     } else \
     {
      set index [$HLIST info selection]
     }
     if { $index != "" } \
     {
      $HLIST entryconfig $index -state disabled
     }
     if { [winfo exists $HLIST.cmd.ent] } \
     {
      focus $HLIST.cmd.ent
     }
    }
   }
   return 1
  }
  return 0
 }

#=======================================================================
proc UI_PB_cmd_UpdateCmdEntry { page_obj index } {
  global gPB
  global pb_cmd_procname
  if { ![info exists Page::($page_obj,rename_index)] } {
   return
  }
  if { ![info exists Page::($page_obj,active_cmd_obj)] } {
   return
  }
  set active_cmd $Page::($page_obj,active_cmd_obj)
  set tree $Page::($page_obj,tree)
  set page_name $Page::($page_obj,page_name)
  if { [string match "cod" $page_name] } {
   set tag 1
   } else {
   set tag 0
  }
  set HLIST [$tree subwidget hlist]
  set style $gPB(font_style_normal)
  if { $tag } {
   set file [tix getimage pb_cmd]
   set cur_cmd_name PB_CMD_vnc__
   append cur_cmd_name $pb_cmd_procname
   } else {
   set file   $gPB(pb_cmd_icon)
   if { [string match "$::gPB(condition_cmd_prefix)*" $command::($active_cmd,name)] } then {
    UI_PB_debug_ForceMsg "\n+++ UI_PB_cmd_UpdateCmdEntry : condition command::($active_cmd,name) =>$command::($active_cmd,name)<\n"
    set cur_cmd_name $::gPB(condition_cmd_prefix)
    append cur_cmd_name $pb_cmd_procname
    } elseif { [string match "$::gPB(check_block_cmd_prefix)*" $command::($active_cmd,name)] } then {
    UI_PB_debug_ForceMsg "\n+++ UI_PB_cmd_UpdateCmdEntry : check_block command::($active_cmd,name) =>$command::($active_cmd,name)<\n"
    set cur_cmd_name $::gPB(check_block_cmd_prefix)
    append cur_cmd_name $pb_cmd_procname
    } else {
    UI_PB_debug_ForceMsg "\n+++ UI_PB_cmd_UpdateCmdEntry : custom command::($active_cmd,name) =>$command::($active_cmd,name)<\n"
    set cur_cmd_name PB_CMD_
    append cur_cmd_name $pb_cmd_procname
   }
  }
  if { [__cmd_DenyCmdName $cur_cmd_name $page_obj $index] } {
   return UI_PB_ERROR
  }
  set ret_code [PB_int_CheckForCmdBlk active_cmd cur_cmd_name]
  global LicInfo
  if { [info exists LicInfo(user_right_limit)] && $LicInfo(user_right_limit) == "YES" } {
   if { $ret_code == 0 } {
    if { [string match "PB_CMD_vnc_*" $cur_cmd_name] } {
     if { [string match "PB_CMD_vnc____*" $cur_cmd_name] } {
      set ret_code 0
      } else {
      set ret_code 3
     }
    }
   }
  }
  if { $ret_code == 0 } \
  {
   set next_ent [$HLIST info next $index]
   if { [string match "" $next_ent] } {
    set prev_ent [$HLIST info prev $index]
   }
   $HLIST delete entry $index
   if { [string match "" $next_ent] } {
    $HLIST add $index -itemtype imagetext -text "$cur_cmd_name" \
    -image $file -style $style -after $prev_ent
    } else {
    $HLIST add $index -itemtype imagetext -text "$cur_cmd_name" \
    -image $file -style $style -before $next_ent
   }
   if 0 {
    $HLIST delete entry $index
    $HLIST add $index -itemtype imagetext -text "$cur_cmd_name" \
    -image $file -style $style -at $col
   }
   $HLIST selection set $index
   $HLIST anchor set $index
   set Page::($page_obj,double_click_flag) 0
   $Page::($page_obj,cmd_entry) config -text "$pb_cmd_procname"
  } else \
  {
   return [ UI_PB_cmd_DenyCmdRename $ret_code $page_obj $index ]
  }
  UI_PB_cmd_UpdateCmdNameData page_obj
  grab release [grab current]
  unset Page::($page_obj,rename_index)
  set left_pane $Page::($page_obj,left_pane_id)
  set del $left_pane.f.del
  if { $tag } {
   $del config -state disabled
   } else {
   $del config -state normal
  }
 }

#=======================================================================
proc UI_PB_cmd_DenyCmdRename { error_no args } {
  global gPB
  set argc [llength $args]
  set tag 0
  if { $argc > 0 } \
  {
   set page_obj [lindex $args 0]
   if { $page_obj } \
   {
    set tree $Page::($page_obj,tree)
    set page_name $Page::($page_obj,page_name)
    if { [string match "cod" $page_name] } {
     set tag 1
    }
    set HLIST [$tree subwidget hlist]
    $HLIST selection clear
    $HLIST anchor clear
    if { $argc > 1 } \
    {
     set index [lindex $args 1]
    } else \
    {
     set index [$HLIST info selection]
    }
    if { $index != "" } \
    {
     $HLIST entryconfig $index -state disabled
    }
    if { [winfo exists $HLIST.cmd.ent] } \
    {
     focus $HLIST.cmd.ent
    }
   }
  }
  global pb_cmd_procname
  if { $tag } {
   set cur_cmd_name "PB_CMD_vnc__${pb_cmd_procname}"
   } else {
   set cur_cmd_name "PB_CMD_${pb_cmd_procname}"
  }
  switch $error_no {
   1 {
    tk_messageBox -parent [UI_PB_com_AskActiveWindow] -type ok -icon error \
    -message "\"$cur_cmd_name\" $gPB(msg,name_exists)"
   }
   2 {
    tk_messageBox -parent [UI_PB_com_AskActiveWindow] -type ok -icon error \
    -message "$gPB(cust_cmd,name_msg)"
   }
   3 {
    tk_messageBox -parent [UI_PB_com_AskActiveWindow] -type ok -icon error \
    -message "$gPB(cust_cmd,name_msg_2)"
   }
   4 {
    tk_messageBox -parent [UI_PB_com_AskActiveWindow] -type ok -icon error \
    -message "$gPB(cust_cmd,name_msg_for_cond) \n$gPB(check_block_cmd_prefix)."
   }
  }
  return UI_PB_ERROR
 }

#=======================================================================
proc UI_PB_cmd_UpdateCmdNameData { PAGE_OBJ } {
  upvar $PAGE_OBJ page_obj
  global pb_cmd_procname
  set active_cmd $Page::($page_obj,active_cmd_obj)
  set prev_cmd_name $command::($active_cmd,name)
  set tag 0
  if { [string match "PB_CMD_vnc_*" $prev_cmd_name] } {
   set tag 1
  }
  if { $tag } {
   set cur_cmd_name "PB_CMD_vnc__"
   append cur_cmd_name $pb_cmd_procname
   } else {
   set cur_cmd_name "PB_CMD_"
   append cur_cmd_name $pb_cmd_procname
  }
  if { [string match "$::gPB(condition_cmd_prefix)*" $prev_cmd_name] } {
   set cur_cmd_name $::gPB(condition_cmd_prefix)
   append cur_cmd_name $pb_cmd_procname
  }
  if { [string match "$::gPB(check_block_cmd_prefix)*" $prev_cmd_name] } {
   set cur_cmd_name $::gPB(check_block_cmd_prefix)
   append cur_cmd_name $pb_cmd_procname
  }
  if { [string compare $cur_cmd_name $prev_cmd_name] != 0 } \
  {
   PB_int_RemoveCmdProcFromList active_cmd
   if { $tag } {
    __isv_RemoveCmdProcFromList $prev_cmd_name
   }
   set command::($active_cmd,name) $cur_cmd_name
   PB_int_UpdateCommandAdd active_cmd
   if { $tag } {
    __isv_UpdateCommandAdd $cur_cmd_name
   }
   command::readvalue $active_cmd cmd_obj_attr
   set cmd_obj_attr(0) $cur_cmd_name
   if 0 {
    if { $tag } {
     set cmd_obj_attr(0) PB_CMD_vnc__${pb_cmd_procname}
     } else {
     set cmd_obj_attr(0) PB_CMD_${pb_cmd_procname}
    }
   }
   command::setvalue $active_cmd cmd_obj_attr
   array set def_cmd_attr $command::($active_cmd,def_value)
   set def_cmd_attr(0) $cur_cmd_name
   if 0 {
    if { $tag } {
     set def_cmd_attr(0) PB_CMD_vnc__${pb_cmd_procname}
     } else {
     set def_cmd_attr(0) PB_CMD_${pb_cmd_procname}
    }
   }
   command::DefaultValue $active_cmd def_cmd_attr
   command::RestoreValue $active_cmd
   if { $tag } {
    global mom_sim_arr rest_mom_sim_arr
    global post_object
    array set rest_mom_sim_arr [array get mom_sim_arr]
    set Post::($post_object,mom_sim_var_list) [array get mom_sim_arr]
    set Post::($post_object,rest_mom_sim_var_list) [array get mom_sim_arr]
    array set def_mom_sim_arr [array get mom_sim_arr]
    set Post::($post_object,def_mom_sim_var_list) [array get mom_sim_arr]
   }
  }
 }

#=======================================================================
proc UI_PB_cmd_DisplayCmdBlocks { PAGE_OBJ OBJ_INDEX } {
  upvar $PAGE_OBJ page_obj
  upvar $OBJ_INDEX obj_index
  global paOption
  global gPB
  global post_object
  global mom_sys_arr
  set style $gPB(font_style_normal)
  set tree $Page::($page_obj,tree)
  set HLIST [$tree subwidget hlist]
  $HLIST delete all
  $HLIST add 0 -itemtype imagetext -text "" -image $paOption(folder) \
  -state disabled
  set file  $gPB(pb_cmd_icon)
  PB_int_RetCmdBlks cmd_obj_list
  if 0 {{ ;# not working yet
   foreach cc $cmd_obj_list {
    set cn $command::($cc,name)
    set cc_arr($cn) $cc
    lappend name_list $cn
   }
   set name_list [lsort -dictionary $name_list]
   set no_blks [llength $name_list]
   for {set count 0} {$count < $no_blks} {incr count}\
   {
    set cmd_name [lindex $name_list $count]
    set cmd_obj $cc_arr($cmd_name)
    $HLIST add 0.$count -itemtype imagetext -text $cmd_name -image $file \
    -style $style
    lappend obj_list $cmd_obj
   }
   global post_object
   Post::SetObjListasAttr $post_object obj_list
  }}
  set no_blks [llength $cmd_obj_list]
  for { set count 0 } { $count < $no_blks } { incr count } {
   set cmd_obj [lindex $cmd_obj_list $count]
   set cmd_name $command::($cmd_obj,name)
   set list_cmd 1
   if { ![string match "PB_CMD_*" $cmd_name] } {
    set list_cmd 0
   }
   if { [string match "PB_CMD_kin*" $cmd_name] } {
    if { [info exists gPB(LIST_PB_CMD_KIN)]  &&  $gPB(LIST_PB_CMD_KIN) == 0 } {
     set list_cmd 0
    }
   }
   if { [string match "PB_CMD_vnc*" $cmd_name] } {
    set list_cmd 0
   }
   if { $list_cmd } {
    $HLIST add 0.$count -itemtype imagetext -text $cmd_name \
    -image $file -style $style
   }
  }
  if { $no_blks } \
  {
   if 0 {
    if { $obj_index >= $no_blks } \
    {
     set obj_index [expr $no_blks - 1]
     $HLIST selection set 0.$obj_index
     } elseif { $obj_index >= 0 }\
    {
     $HLIST selection set 0.$obj_index
    } else\
    {
     $HLIST selection set 0
    }
   }
   if { $obj_index >= $no_blks } \
   {
    set obj_index [expr $no_blks - 1]
   }
   if { [$HLIST info exists 0.$obj_index] } {
    $HLIST selection set 0.$obj_index
    } elseif { [$HLIST info exists 0.0] } {
    $HLIST selection set 0.0
    } else {
    $HLIST selection set 0
   }
  } else \
  {
   $HLIST selection set 0
  }
 }

#=======================================================================
proc UI_PB_cmd_ImportVNCCmds { args } {
  global mom_sys_arr mom_sim_arr
  global gPB env
  PB_int_RetCmdBlks cmd_obj_list
  if { [llength $args] } {
   set flag [lindex $args 0]
   } else {
   set flag "any"
  }
  if { ![info exists mom_sys_arr(VNC_Mode)] } {
   set mom_sys_arr(VNC_Mode) "Standalone"
  }
  if { $mom_sys_arr(Output_VNC) == 1 } {
   global post_object
   if { [string match "Standalone" $mom_sys_arr(VNC_Mode)] } {
    if { [PB_com_FindObjFrmName "PB_CMD_vnc____set_nc_definitions" command] < 0 } {
     set mom_sim_arr(\$mom_sim_vnc_com_list) [list]
     if { $gPB(new_enable_choose_vnc) && !$gPB(new_vnc_flag) } {
      foreach tcl_file $gPB(post_vnc_list) {
       __cmd_ImportVNCCmds $tcl_file $flag
      }
      set gPB(new_vnc_flag) 1
      } else {
      set tcl_file "$env(PB_HOME)/pblib/vnc_common.tcl"
      __cmd_ImportVNCCmds $tcl_file $flag
     }
     set gPB(vnc_common_sourced) 1
     if { [info exists gPB(vnc_subordinate_sourced)] } {
      PB_com_unset_var gPB(vnc_subordinate_sourced)
     }
     PB_int_RetCmdBlks cmd_obj_list
     set gPB(def_cmd_obj_list) $cmd_obj_list
     foreach com_obj $cmd_obj_list {
      set com $command::($com_obj,name)
      if { [string match "PB_CMD_vnc__*" $com] } {
       lappend mom_sim_arr(\$mom_sim_vnc_com_list) $com
      }
     }
    }
    } else {
    if { [PB_com_FindObjFrmName "PB_CMD_vnc__set_nc_definitions" command] < 0 } {
     set mom_sim_arr(\$mom_sim_sub_vnc_list) [list]
     if { $gPB(new_enable_choose_vnc) && !$gPB(new_vnc_flag) } {
      foreach tcl_file $gPB(post_vnc_list) {
       __cmd_ImportVNCCmds $tcl_file $flag
      }
      set gPB(new_vnc_flag) 1
      } else {
      set tcl_file "$env(PB_HOME)/pblib/vnc_subordinate.tcl"
      __cmd_ImportVNCCmds $tcl_file $flag
     }
     set gPB(vnc_subordinate_sourced) 1
     if { [info exists gPB(vnc_common_sourced)] } {
      PB_com_unset_var gPB(vnc_common_sourced)
     }
     PB_int_RetCmdBlks cmd_obj_list
     set gPB(def_cmd_obj_list) $cmd_obj_list
     foreach com_obj $cmd_obj_list {
      set com $command::($com_obj,name)
      if { [string match "PB_CMD_vnc____map_machine_tool_axes" $com] || \
       [string match "PB_CMD_vnc__set_nc_definitions"      $com] || \
       [string match "PB_CMD_vnc__sim_other_devices"       $com] || \
       [string match "PB_CMD_vnc__process_nc_block"        $com] } {
       lappend mom_sim_arr(\$mom_sim_sub_vnc_list) $com
      }
     }
    }
   }
  }
 }

#=======================================================================
proc __cmd_ImportVNCCmds { tcl_file flag } {
  global post_object
  global gPB
  if { [string match "command_page" $flag] || [string match "vnc" $flag] } {
  }
  if { [catch { set sta [PB_pps_ParseTclFile $tcl_file event_proc_data 0] } ] } {
   global errorInfo
   if { [string match "command_page" $flag] || [string match "vnc" $flag] } {
    PB_com_unset_var gPB(post_in_progress)
    UI_PB_DestroyProgress
   }
   return [ error "$errorInfo" ]
  }
  set evt_proc_list [array get event_proc_data]
  set cmd_proc_list ""
  set llen [llength $evt_proc_list]
  for {set i 0} {$i < $llen} {incr i 2} \
  {
   set event_item [lindex $evt_proc_list $i]
   if { ![string match "MOM*" $event_item] && [string match "*\,name" $event_item] } \
   {
    if { [string match "PB_CMD_vnc*" $event_item] } \
    {
     set event_name [lindex [split $event_item ,] 0]
     set cmd_proc_list [ladd $cmd_proc_list end $event_name "no_dup"]
     set cmd_proc_data($event_name,proc) $event_proc_data($event_name,proc)
     set cmd_proc_data($event_name,blk_list) $event_proc_data($event_name,blk_list)
     set cmd_proc_data($event_name,add_list) $event_proc_data($event_name,add_list)
     set cmd_proc_data($event_name,fmt_list) $event_proc_data($event_name,fmt_list)
    }
   }
  }
  foreach cmd $cmd_proc_list {
   set cmd_obj_attr(0) $cmd
   set cmd_obj_attr(1) $cmd_proc_data($cmd,proc)
   set cmd_obj_attr(2) $cmd_proc_data($cmd,blk_list)
   set cmd_obj_attr(3) $cmd_proc_data($cmd,add_list)
   set cmd_obj_attr(4) $cmd_proc_data($cmd,fmt_list)
   __cmd_CreateCommand cmd_obj_attr cmd
  }
  Post::GetObjList $post_object command cmd_obj_list
  PB_com_SortObjectsByNames cmd_obj_list
  Post::SetObjListasAttr $post_object cmd_obj_list
  if { [string match "command_page" $flag] || [string match "vnc" $flag] } {
  }
 }

#=======================================================================
proc __cmd_ConfigActionButtons { page_obj } {
  set ent $Page::($page_obj,selected_index)
  if { $ent < 0 } {
   return
  }
  set tree $Page::($page_obj,tree)
  set HLIST [$tree subwidget hlist]
  PB_int_RetCmdBlks cmd_obj_list
  set proc_name [$HLIST entrycget $ent -text]
  PB_com_RetObjFrmName proc_name cmd_obj_list cmd_obj
  UI_PB_debug_ForceMsg "\n+++ __cmd_ConfigActionButtons cmd_obj: >$cmd_obj< proc_name: >$proc_name< ent: >$ent< \n"
  if { $cmd_obj != ""  &&  [info exists command::($cmd_obj,name)] } \
  {
   if { [string match "cod" $Page::($page_obj,page_name)] } {
    set tag 1
    } else {
    set tag 0
   }
   set left_pane $Page::($page_obj,left_pane_id)
   set new $left_pane.f.new
   set del $left_pane.f.del
   if { !$tag } {
    if { [string match "PB_CMD_before_motion" $proc_name] || \
     [string match "PB_CMD_kin*"          $proc_name] || \
     ( $command::($cmd_obj,is_dummy) == 1 ) } {
     $new config -state disabled
     $del config -state disabled
     } else {
     set disabled_delete_flag 0
     if { [UI_PB_cmd_CheckCmdState $proc_name "delete"] == 0 } \
     {
      set disabled_delete_flag 1
     }
     $new config -state normal
     if { $disabled_delete_flag } {
      $del config -state disabled
      } else {
      $del config -state normal
     }
    }
   }
   if { $tag } { ;# VNC commands
    global mom_sim_arr
    set token_list $mom_sim_arr(\$mom_sim_pre_com_list)
    set token_cmd_list [list]
    foreach token $token_list {
     set item [join [split $token] "_"]
     set item "PB_CMD_vnc__$item"
     lappend token_cmd_list $item
    }
    if { [string match "Standalone" $::mom_sys_arr(VNC_Mode)] } {
     set user_com_list $mom_sim_arr(\$mom_sim_user_com_list)
     } else {
     set user_com_list $mom_sim_arr(\$mom_sim_sub_user_list)
    }
    if { ([lsearch $user_com_list  $proc_name] >= 0) &&  \
     ([lsearch $token_cmd_list $proc_name] < 0) } {
     $new config -state normal
     $del config -state normal
     } else {
     if { [string match "*map_machine_tool_axes" $proc_name] || \
      [string match "*set_nc_definitions"    $proc_name] || \
      [string match "*sim_other_devices"     $proc_name] || \
      [string match "*process_nc_block"      $proc_name] } {
      $new config -state disabled
      } else {
      $new config -state normal
     }
     $del config -state disabled
    }
   }
   UI_PB_debug_ForceMsg "\n page_obj : $page_obj \n"
   if { ![info exists Page::($page_obj,buff_cmd_obj)] } {
    $left_pane.f.pas config -state disabled
    } else {
    $left_pane.f.pas config -state normal
    set buff_cmd_obj $Page::($page_obj,buff_cmd_obj)
    if { [info exists command::($buff_cmd_obj,name)] && [info exists command::($cmd_obj,name)] } {
     if { [string compare $command::($buff_cmd_obj,name) $command::($cmd_obj,name)] == 0 } {
      $left_pane.f.pas config -state disabled
      unset Page::($page_obj,buff_cmd_obj)
     }
    }
   }
   if { [string match "$::gPB(ATP_cmd_prefix)*" $proc_name] } {
    if { [UI_PB_cmd_CheckCmdState $proc_name delete] == 0 } {
     $del config -state disabled
    }
   }
  }
  if { [info exists Page::($page_obj,rename_index)] } {
   unset Page::($page_obj,rename_index)
  }
 }

#=======================================================================
proc __cmd_FindPrevItemSelected { HLIST ent } {
  UI_PB_debug_ForceMsg "\n+++ info level: >[info level]<  info level 0 >[info level 0]< \n"
  set prev_cmd_name_selected ""
  if { [info level] == 2 } {
   if { [info exists ::prev_post_cus_cmd_selected] } {
    set prev_cmd_name_selected $::prev_post_cus_cmd_selected
    UI_PB_debug_ForceMsg "\n+++ ::prev_post_cus_cmd_selected >$::prev_post_cus_cmd_selected< \n"
   }
   } else {
   if { [string match "__isv_CodeItemSelection*" [info level -2]] } {
    if { [string match "Standalone" $::mom_sys_arr(VNC_Mode)] } {
     if { [info exists ::prev_main_vnc_cmd_selected] } {
      set prev_cmd_name_selected $::prev_main_vnc_cmd_selected
      UI_PB_debug_ForceMsg "\n+++ ::prev_main_vnc_cmd_selected >$::prev_main_vnc_cmd_selected< \n"
     }
     } else {
     if { [info exists ::prev_sub_vnc_cmd_selected] } {
      set prev_cmd_name_selected $::prev_sub_vnc_cmd_selected
      UI_PB_debug_ForceMsg "\n+++ ::prev_sub_vnc_cmd_selected >$::prev_sub_vnc_cmd_selected< \n"
     }
    }
    } else {
    if { [info exists ::prev_post_cus_cmd_selected] } {
     set prev_cmd_name_selected $::prev_post_cus_cmd_selected
     UI_PB_debug_ForceMsg "\n+++ ::prev_post_cus_cmd_selected >$::prev_post_cus_cmd_selected< \n"
    }
   }
  }
  if { $prev_cmd_name_selected != "" } {
   foreach idx [$HLIST info children 0] {
    if { [$HLIST info exists $idx] } {
     if { [string match $prev_cmd_name_selected [$HLIST entrycget $idx -text]] } {
      set ent $idx
      UI_PB_debug_ForceMsg "\n+++ prev_cmd_name_selected: >$prev_cmd_name_selected<  ent: >$ent< \n"
      break
     }
    }
   }
  }
  return $ent
 }

#=======================================================================
proc UI_PB_cmd_SelectItem { page_obj args } {
  global pb_cmd_procname
  global mom_sys_arr
  if { [string match "cod" $Page::($page_obj,page_name)] } {
   set tag 1
   } else {
   set tag 0
  }
  if { [info exists Page::($page_obj,rename_index)] } \
  {
   if { [UI_PB_cmd_UpdateCmdEntry $page_obj \
    $Page::($page_obj,rename_index)] == "UI_PB_ERROR" } {
    return
   }
  }
  set canvas_frame $Page::($page_obj,canvas_frame)
  set tree $Page::($page_obj,tree)
  set HLIST [$tree subwidget hlist]
  if { ![info exists Page::($page_obj,selected_index)] } {
   set Page::($page_obj,selected_index) -1
  }
  set ent [lindex $args 0]
  UI_PB_debug_ForceMsg "\n+++ UI_PB_cmd_SelectItem : passed in ent : >$ent< \n"
  if { [string match "*.*" $ent] } {
   set index [string range $ent 2 end]
   if { [expr $index < 0] } {
    set ent 0.0
   }
  }
  UI_PB_debug_ForceMsg "\n+++ UI_PB_cmd_SelectItem : fudged ent : >$ent< \n"
  if { $ent == "" } \
  {
   set ent [$HLIST info selection]
   set ent [__cmd_FindPrevItemSelected $HLIST $ent]
   if 0 {
    UI_PB_debug_ForceMsg "\n+++ info level: >[info level]<  info level 0 >[info level 0]< \n"
    set prev_cmd_name_selected ""
    if { [info level] == 1 } {
     if { [info exists ::prev_post_cus_cmd_selected] } {
      set prev_cmd_name_selected $::prev_post_cus_cmd_selected
      UI_PB_debug_ForceMsg "\n+++ ::prev_post_cus_cmd_selected >$::prev_post_cus_cmd_selected< \n"
     }
     } else {
     if { [string match "__isv_CodeItemSelection*" [info level -1]] } {
      if { [string match "Standalone" $::mom_sys_arr(VNC_Mode)] } {
       if { [info exists ::prev_main_vnc_cmd_selected] } {
        set prev_cmd_name_selected $::prev_main_vnc_cmd_selected
        UI_PB_debug_ForceMsg "\n+++ ::prev_main_vnc_cmd_selected >$::prev_main_vnc_cmd_selected< \n"
       }
       } else {
       if { [info exists ::prev_sub_vnc_cmd_selected] } {
        set prev_cmd_name_selected $::prev_sub_vnc_cmd_selected
        UI_PB_debug_ForceMsg "\n+++ ::prev_sub_vnc_cmd_selected >$::prev_sub_vnc_cmd_selected< \n"
       }
      }
      } else {
      if { [info exists ::prev_post_cus_cmd_selected] } {
       set prev_cmd_name_selected $::prev_post_cus_cmd_selected
       UI_PB_debug_ForceMsg "\n+++ ::prev_post_cus_cmd_selected >$::prev_post_cus_cmd_selected< \n"
      }
     }
    }
    if { $prev_cmd_name_selected != "" } {
     foreach idx [$HLIST info children 0] {
      if { [$HLIST info exists $idx] } {
       if { [string match $prev_cmd_name_selected [$HLIST entrycget $idx -text]] } {
        set ent $idx
        UI_PB_debug_ForceMsg "\n+++ prev_cmd_name_selected: >$prev_cmd_name_selected<  ent: >$ent< \n"
        break
       }
      }
     }
    }
   } ;# if 0
  }
  if { [string match "0" $ent] }  {
   if { [$HLIST info exists 0.0] } {
    $HLIST selection clear
    $HLIST anchor clear
    $HLIST selection set 0.0
    $HLIST anchor set 0.0
    set ent 0.0
   }
  }
  PB_int_RetCmdBlks cmd_obj_list
  if { [info exists Page::($page_obj,selected_index)] } \
  {
   if { [string match "$ent" $Page::($page_obj,selected_index)] } \
   {
    UI_PB_debug_ForceMsg "\n+++ UI_PB_cmd_SelectItem : selected_index : $Page::($page_obj,selected_index) \n"
    return [UI_PB_cmd_EditCmdName $page_obj $ent]
   }
  }
  UI_PB_debug_ForceMsg "\n+++ UI_PB_cmd_SelectItem : ent-2 : >$ent< \n"
  set index $ent
  if { [string match "*.*" $ent] } {
   set index [string range $ent 2 end]
  }
  set index [string trim $index]
  UI_PB_debug_ForceMsg "\n+++ UI_PB_cmd_SelectItem : index : $index  => ent : $ent\n"
  if { ![string match "" $index] && ![$HLIST info exists 0.$index] } {
   UI_PB_debug_ForceMsg "\n+++ UI_PB_cmd_SelectItem HLIST pretreat index : >$index<  => ent : >$ent< \n"
   $HLIST selection clear
   $HLIST anchor clear
   if { [$HLIST info exists 0] } {
    set index ""
    set ent 0
    UI_PB_debug_ForceMsg "\n+++ UI_PB_cmd_SelectItem HLIST ent 0 found \n"
   }
   foreach idx [$HLIST info children 0] {
    if { [$HLIST info exists $idx] } {
     set ent $idx
     set index [string range $idx 2 end]
     UI_PB_debug_ForceMsg "\n+++ UI_PB_cmd_SelectItem HLIST ent found : >0.$index< \n"
     break
    }
   }
  }
  if { [string match "" $index] } {
   set cmd_obj ""
   } else {
   $HLIST selection set $ent
   set proc_name [$HLIST entrycget $ent -text]
   PB_com_RetObjFrmName proc_name cmd_obj_list cmd_obj
   if { [info exists Page::($page_obj,active_cmd_obj)] } \
   {
    if { $cmd_obj == $Page::($page_obj,active_cmd_obj) } \
    {
     UI_PB_debug_ForceMsg "\n+++ UI_PB_cmd_SelectItem : active_cmd_obj : $Page::($page_obj,active_cmd_obj) $proc_name \n"
     return
    }
   }
  }
  global post_object
  global mom_sim_arr
  if { $tag } {
   set vnc_command_list [list]
   set sub_command_list [list]
   foreach cmd_name $mom_sim_arr(\$mom_sim_vnc_com_list) {
    PB_com_RetObjFrmName cmd_name cmd_obj_list cmd
    lappend vnc_command_list $cmd
   }
   foreach cmd_name $mom_sim_arr(\$mom_sim_sub_vnc_list) {
    PB_com_RetObjFrmName cmd_name cmd_obj_list cmd
    lappend sub_command_list $cmd
   }
   if { [string match "Standalone" $mom_sys_arr(VNC_Mode)] } {
    set current_com_list $vnc_command_list
    } else {
    set current_com_list $sub_command_list
   }
   } else {
   set current_com_list $cmd_obj_list
  }
  if { [llength $current_com_list] > 0 } {
   set command_ret_code 1
   } else {
   set command_ret_code 0
  }
  if { $command_ret_code == 1  } \
  {
   if { [string compare $index ""] == 0 } \
   {
    $HLIST selection clear
    $HLIST anchor clear
    $HLIST selection set 0.0
    $HLIST anchor set 0.0
   }
   if { [info exists Page::($page_obj,text_widget)] && \
    [winfo exists $Page::($page_obj,text_widget)] } {
    $Page::($page_obj,text_widget) config -state normal
   }
  } else \
  {
   $HLIST selection set 0
   $HLIST anchor set 0
   set pb_cmd_procname ""
   if { [info exists Page::($page_obj,text_widget)] && \
    [winfo exists $Page::($page_obj,text_widget)] } {
    $Page::($page_obj,text_widget) config -state disabled
   }
  }
  if { [info exists Page::($page_obj,active_cmd_obj)] } \
  {
   set active_cmd_obj $Page::($page_obj,active_cmd_obj)
   set act_index [lsearch $current_com_list $active_cmd_obj]
   if { $act_index < 0 } {
    set act_index 0
    set active_cmd_obj [lindex $current_com_list 0]
    set Page::($page_obj,active_cmd_obj) $active_cmd_obj
    set cname $command::($active_cmd_obj,name)
    if { $tag } {
     set pb_cmd_procname [string range $cname 12 end]
     } else {
     set pb_cmd_procname [string range $cname 7 end]
    }
   }
   if { $tag } {
    set cur_cmd_name "PB_CMD_vnc__${pb_cmd_procname}"
    } else {
    set cur_cmd_name "PB_CMD_${pb_cmd_procname}"
   }
   UI_PB_debug_ForceMsg "\n+++ UI_PB_cmd_SelectItem : cur_cmd_name =>$cur_cmd_name< $command::($active_cmd_obj,name) \n"
   if { [string match "$::gPB(condition_cmd_prefix)*" $command::($active_cmd_obj,name)] } {
    set len [string length $::gPB(condition_cmd_prefix)]
    set pb_cmd_procname [string range $command::($active_cmd_obj,name) $len end]
    set cur_cmd_name $command::($active_cmd_obj,name)
   }
   if { [string match "$::gPB(check_block_cmd_prefix)*" $command::($active_cmd_obj,name)] } {
    set len [string length $::gPB(check_block_cmd_prefix)]
    set pb_cmd_procname [string range $command::($active_cmd_obj,name) $len end]
    set cur_cmd_name $command::($active_cmd_obj,name)
   }
   if { [info exists Page::($page_obj,rename_index)] } {
    set rename_index $Page::($page_obj,rename_index)
    if { [__cmd_DenyCmdName $cur_cmd_name $page_obj $rename_index] } {
     return UI_PB_ERROR
    }
   }
   UI_PB_debug_ForceMsg "\n+++ UI_PB_cmd_SelectItem : cur_cmd_name =>$cur_cmd_name< \n"
   set ret_code [PB_int_CheckForCmdBlk active_cmd_obj cur_cmd_name]
   if { $ret_code } \
   {
    if { [info exists Page::($page_obj,rename_index)] } {
     UI_PB_cmd_DenyCmdRename $ret_code $page_obj $Page::($page_obj,rename_index)
    }
    return
   } else \
   {
    $HLIST selection clear $ent $ent
    $HLIST anchor clear
    set len [llength $current_com_list]
    set ind 0.[expr $len - 1]
    if { $Page::($page_obj,selected_index) >= 0 } {
     set selected_index $Page::($page_obj,selected_index)
     if { $selected_index > $ind } {
      set Page::($page_obj,selected_index) 0.0
      set selected_index 0.0
     }
     } elseif { [info exists Page::($page_obj,rename_index)] } {
     set selected_index $Page::($page_obj,rename_index)
     if { $selected_index > $ind } {
      set Page::($page_obj,rename_index) 0.0
      set selected_index 0.0
     }
     } elseif { [info exists Page::($page_obj,active_cmd_obj)] } {
     set act_cmd_obj $Page::($page_obj,active_cmd_obj)
     if { $tag } {
      } else {
      set selected_index [lsearch $cmd_obj_list $act_cmd_obj]
     }
    } ;# elseif exists active command obj
    if { [info exists selected_index] } {
     unset selected_index
    }
    if { $tag } {
     if { [info exists act_cmd_obj] } {
      set cmd_name $command::($act_cmd_obj,name)
      if 0 {
       if { [string match "*set_nc_definitions" $cmd_name] ||  \
        [string match "*sim_other_devices"  $cmd_name] ||  \
        [string match "*map_machine_tool_axes" $cmd_name] } {
        set check "not_verify"
        } else {
        set check ""
       }
       } else {
       set check ""
      }
     }
     set check ""
     } else {
     set check ""
    }
    if { ![UI_PB_cmd_SaveCmdProc $page_obj $check] } {
     $HLIST selection set [__cmd_FindPrevItemSelected $HLIST $ent]
     if 0 {
      if { [info exists Page::($page_obj,selected_index)] } {
       $HLIST selection set $Page::($page_obj,selected_index)
       } elseif { [$HLIST info exists 0.0] } {
       $HLIST selection set 0.0
       } else {
       $HLIST selection set 0
      }
     }
     return
    }
    if { $Page::($page_obj,double_click_flag) } \
    {
     global gPB
     set style $gPB(font_style_normal)
     set file  $gPB(pb_cmd_icon)
     set next_ent [$HLIST info next 0.$act_index]
     if { [string match "" $next_ent] } {
      set prev_ent [$HLIST info prev 0.$act_index]
     }
     $HLIST delete entry 0.$act_index
     if { [string match "" $next_ent] } {
      $HLIST add 0.$act_index -itemtype imagetext -text $cur_cmd_name \
      -image $file -style $style -after $prev_ent
      } else {
      $HLIST add 0.$act_index -itemtype imagetext -text $cur_cmd_name \
      -image $file -style $style -before $next_ent
     }
     if 0 {
      $HLIST delete entry 0.$act_index
      $HLIST add 0.$act_index -itemtype imagetext \
      -text $cur_cmd_name -image $file -style $style \
      -at $act_index
     }
     UI_PB_cmd_UpdateCmdNameData page_obj
     set Page::($page_obj,double_click_flag) 0
     unset Page::($page_obj,rename_index)
    }
   }
   UI_PB_cmd_DeleteCmdProc $page_obj
   unset Page::($page_obj,active_cmd_obj)
  }
  if { [$HLIST info exists $ent] } {
   set Page::($page_obj,selected_index) $ent
   } else {
   set Page::($page_obj,selected_index) [$HLIST info selection]
  }
  if { $cmd_obj != "" } \
  {
   UI_PB_cmd_DisplayCmdBlkAttr page_obj cmd_obj
   UI_PB_debug_ForceMsg "\n+++ UI_PB_cmd_SelectItem : cmd_obj: >$cmd_obj<  active_cmd_obj: >$Page::($page_obj,active_cmd_obj)< \n"
   __cmd_ConfigActionButtons $page_obj
  }
  if 0 {  ;#<Aug-19-2016 gsl> Replaced with a function call above
   global paOption
   if 0 { ;# Leave them active for now
    if { [string match "PB_CMD_kin_start_of_program" $command::($cmd_obj,name)] || \
    [string match "PB_CMD_kin_start_of_path" $command::($cmd_obj,name)] } \
    {
     $Page::($page_obj,text_widget) config -bg $paOption(entry_disabled_bg) -state disabled
    } else \
    {
     $Page::($page_obj,text_widget) config -bg $Page::($page_obj,text_widget_bg)
    }
   }
   set left_pane $Page::($page_obj,left_pane_id)
   set new $left_pane.f.new
   set del $left_pane.f.del
   if { !$tag } {
    if { [string match "PB_CMD_before_motion" $command::($cmd_obj,name)] || \
     [string match "PB_CMD_kin*"          $command::($cmd_obj,name)] || \
     ( $command::($cmd_obj,is_dummy) == 1 ) } {
     $new config -state disabled
     $del config -state disabled
     } else {
     $new config -state normal
     $del config -state normal
    }
   }
   if { $tag } {
    set token_list $mom_sim_arr(\$mom_sim_pre_com_list)
    set token_cmd_list [list]
    foreach token $token_list {
     set item [join [split $token] "_"]
     set item "PB_CMD_vnc__$item"
     lappend token_cmd_list $item
    }
   }
   if { $tag } { ;# VNC commands
    if { [string match "Standalone" $mom_sys_arr(VNC_Mode)] } {
     set user_com_list $mom_sim_arr(\$mom_sim_user_com_list)
     } else {
     set user_com_list $mom_sim_arr(\$mom_sim_sub_user_list)
    }
    if { ([lsearch $user_com_list  $command::($cmd_obj,name)] >= 0) &&  \
     ([lsearch $token_cmd_list $command::($cmd_obj,name)] < 0) } {
     $new config -state normal
     $del config -state normal
     } else {
     if { [string match "*map_machine_tool_axes" $command::($cmd_obj,name)] || \
      [string match "*set_nc_definitions"    $command::($cmd_obj,name)] || \
      [string match "*sim_other_devices"     $command::($cmd_obj,name)] || \
      [string match "*process_nc_block"      $command::($cmd_obj,name)]} {
      $new config -state disabled
      } else {
      $new config -state normal
     }
     $del config -state disabled
    }
   }
  } ;# if 0
  $HLIST selection clear
  $HLIST anchor clear
  if { ![string match "" $ent] } {
   $HLIST selection set $ent
   $HLIST anchor set $ent
   $HLIST see $ent
   UI_PB_debug_ForceMsg "\n+++ info level: >[info level]<  info level 0 >[info level 0]< \n"
   set cmd_name [$HLIST entrycget $ent -text]
   if { [info level] == 1 } {
    set ::prev_post_cus_cmd_selected  $cmd_name
    } else {
    if { [string match "__isv_CodeItemSelection*" [info level -1]] } {
     if { [string match "Standalone" $::mom_sys_arr(VNC_Mode)] } {
      set ::prev_main_vnc_cmd_selected $cmd_name
      } else {
      set ::prev_sub_vnc_cmd_selected  $cmd_name
     }
     } else {
     set ::prev_post_cus_cmd_selected  $cmd_name
    }
   }
  }
 }

#=======================================================================
proc UI_PB_cmd_DisplayCmdBlkAttr { PAGE_OBJ CMD_OBJ } {
  upvar $PAGE_OBJ page_obj
  upvar $CMD_OBJ cmd_obj
  command::RestoreValue $cmd_obj
  set Page::($page_obj,active_cmd_obj) $cmd_obj
  UI_PB_cmd_DisplayCmdProc cmd_obj page_obj
 }

#=======================================================================
proc UI_PB_cmd_AddComponentsLeftPane { PAGE_OBJ } {
  upvar $PAGE_OBJ page_obj
  global gPB
  global paOption
  set lpane $Page::($page_obj,left_pane_id)
  set frm_bg $paOption(name_bg)
  set top_frm [frame $lpane.top -bg $frm_bg -relief sunken -bd 1]
  set left_pane [frame $lpane.bot]
  set Page::($page_obj,left_pane_id) $left_pane
  pack $top_frm -side top -fill x -padx 7 -pady 2
  pack $left_pane -side bottom -fill both -expand yes
  set frm [frame $top_frm.frm -bg $frm_bg]
  pack $frm -fill x -padx 1
  set imp [button $frm.imp -text "$gPB(cust_cmd,import,Label)" \
  -command "_cmd_ImportCustCmdFile $page_obj" \
  -bg $paOption(app_butt_bg) -state normal]
  set exp [button $frm.exp -text "$gPB(cust_cmd,export,Label)" \
  -command "_cmd_ExportCustCmdFile $page_obj" \
  -bg $paOption(app_butt_bg) -state normal]
  global LicInfo
  if { [info exists LicInfo(user_right_limit)] && $LicInfo(user_right_limit) == "YES" } {
   $exp config -state disabled
  }
  pack $imp $exp -side left -fill x -expand yes -padx 1 -pady 2
  set but [frame $left_pane.f]
  set new [button $but.new -text "$gPB(tree,create,Label)" \
  -command "UI_PB_cmd_CreateACmdBlock $page_obj" \
  -bg $paOption(app_butt_bg) -state normal]
  set del [button $but.del -text "$gPB(tree,cut,Label)" \
  -command "UI_PB_cmd_CutACmdBlock $page_obj" \
  -bg $paOption(app_butt_bg) -state normal]
  set pas [button $but.pas -text "$gPB(tree,paste,Label)" \
  -command "UI_PB_cmd_PasteACmdBlock $page_obj" \
  -bg $paOption(app_butt_bg) -state disabled]
  pack $new $del $pas -side left -fill x -expand yes
  pack $but -side top -fill x -padx 7
  set gPB(c_help,$new)   "tree,create"
  set gPB(c_help,$del)   "tree,cut"
  set gPB(c_help,$pas)   "tree,paste"
  set gPB(c_help,$imp)   "cust_cmd,import"
  set gPB(c_help,$exp)   "cust_cmd,export"
 }

#=======================================================================
proc _cmd_ImportCustCmdFile { page_obj args } {
  global gPB
  global tcl_platform
  if { ![UI_PB_cmd_SaveCmdProc $page_obj] } {
   return
  }
  UI_PB_com_SetStatusbar "Select a Tcl file."
  if { ![info exists gPB(custom_command_file_import)] } {
   set gPB(custom_command_file_import) ""
  }
  if { $gPB(custom_command_file_import) == "" } {
   global env
   set gPB(custom_command_file_import) [file dirname $env(PB_HOME)/pblib/custom_command/.]/.
  }
  set action OK
  if { [llength $args] > 0 } {
   set file_type [lindex $args 0]
   } else {
   set file_type ""
  }
  if { $tcl_platform(platform) == "unix" } \
  {
   set res "right"
   UI_PB_file_SelectFile_unx TCL gPB(custom_command_file_import) open
   } elseif { $tcl_platform(platform) == "windows" } \
  {
   UI_PB_com_GrayOutSaveOptions
   UI_PB_com_DisableMain
   set res "right"
   UI_PB_file_SelectFile_win TCL gPB(custom_command_file_import) open 1
   set lng [llength $gPB(custom_command_file_import)]
   if { $lng == 2 } {
    set action [lindex $gPB(custom_command_file_import) end]
    set gPB(custom_command_file_import) [lindex $gPB(custom_command_file_import) 0]
   }
   UI_PB_com_EnableMain
   UI_PB_com_UnGraySaveOptions
  }
  set gPB(custom_command_file_import) [string trim $gPB(custom_command_file_import) \"]
  if { [string match "right" $res] && \
   [file exists $gPB(custom_command_file_import)] && \
   [file isfile $gPB(custom_command_file_import)] && \
   [string match OK $action] } {
   global post_object
   namespace eval CHECK {
    global gPB LicInfo
    set is_author 1
    catch { source $gPB(custom_command_file_import) }
    if { [info exists encrypted_vnc_file] } {
     set encrypted_file $encrypted_vnc_file
    }
    if { [info exists encrypted_post_file] } {
     set encrypted_file $encrypted_post_file
    }
    if { [info exists encrypted_file] } {
     if { [file exists $encrypted_file] } {
      if { ![string compare $gPB(PB_LICENSE) "UG_POST_AUTHOR"] } {
       if { [llength [info commands UI_PB_decrypt_post]] } {
        set is_author [UI_PB_decrypt_post $encrypted_file TRUE NO YES]
        if { [info exists LicInfo(post_site_id)] } {
         set post_site_id $LicInfo(post_site_id)
         } else {
         set post_site_id ""
        }
        UI_PB_decrypt_post $encrypted_file TRUE NO NO
        set is_user_internal [__file_is_SiteID_UG_internal $gPB(PB_SITE_ID)]
        set is_post_internal [__file_is_SiteID_UG_internal $LicInfo(post_site_id)]
        if { [string length $post_site_id] > 0 } {
         set LicInfo(post_site_id) $post_site_id
         } else {
         unset LicInfo(post_site_id)
        }
        if { $is_user_internal && $is_post_internal } {
         set is_author 1
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
   }
   if { $::CHECK::is_author == 0 } {
    namespace delete CHECK
    tk_messageBox -message $gPB(msg,import_limit) -icon warning\
    -parent [UI_PB_com_AskActiveWindow]
    set gPB(custom_command_file_import) [list]
    _cmd_ImportCustCmdFile $page_obj
    return
    } elseif { $::CHECK::is_author == 1 } {
    namespace delete CHECK
    } else {
    namespace delete CHECK
    tk_messageBox -message $gPB(msg,no_file) -icon warning \
    -parent [UI_PB_com_AskActiveWindow]
    return
   }
   set awin [UI_PB_com_AskActiveWindow]
   set win $awin.custom_command
   if { ![winfo exists $win] } {
    toplevel $win
   }
   UI_PB_com_CreateTransientWindow $win "Import Custom Commands from \
   $gPB(custom_command_file_import)" \
   "+200+100" "" "" "destroy $win ;CB_cmd_DeleteDescInfoWnd NULL" ""
   if { [catch { _cmd_ViewTclProcs $win $gPB(custom_command_file_import) $page_obj $file_type } res] } {
    tk_messageBox -parent [UI_PB_com_AskActiveWindow] -type ok \
    -icon error -title "$gPB(cust_cmd,error,title)" \
    -message "$res"
    destroy $win
    UI_PB_com_EnableMain
    } else {
    UI_PB_com_PositionWindow $win
    UI_PB_com_ClaimActiveWindow $win
    set p $gPB(custom_command_import_page)
    set tree $Page::($p,tree)
    set HLIST [$tree subwidget hlist]
    if { [llength [$HLIST info children]] == 0 } {
     if { [string match "vnc" $file_type] } {
      set msg "$gPB(cust_cmd,import,no_vnc_cmd,msg)"
      } else {
      set msg "$gPB(cust_cmd,import,no_cmd,msg)"
     }
     tk_messageBox -parent $win -type ok \
     -icon warning -title "$gPB(cust_cmd,error,title)" \
     -message $msg
     destroy $win
     set gPB(custom_command_file_import) [list]
     _cmd_ImportCustCmdFile $page_obj $file_type
    }
   }
  }
 }

#=======================================================================
proc _cmd_ExportCustCmdFile { page_obj args } {
  global gPB
  global env
  global post_object
  if { ![UI_PB_cmd_SaveCmdProc $page_obj] } {
   return
  }
  if { ![info exists gPB(custom_command_file_export)] } {
   set gPB(custom_command_file_export) ""
  }
  set awin [UI_PB_com_AskActiveWindow]
  set win $awin.custom_command
  if { ![winfo exists $win]} {
   toplevel $win
  }
  UI_PB_com_CreateTransientWindow $win "$gPB(exp_cc,dlg,title,Label)" \
  "+200+100" "" "" "destroy $win ;CB_cmd_DeleteDescInfoWnd NULL" ""
  if { [llength $args] } {
   set type [lindex $args 0]
   } else {
   set type ""
  }
  _cmd_ViewTclProcsEx $win $gPB(custom_command_file_export) $type
  UI_PB_com_PositionWindow $win
 }

#=======================================================================
proc _cmd_ViewTclProcs { win tcl_file cur_main_page args } {
  global paOption
  global gPB
  set w $win
  set b [frame $w.b]
  set f [frame $w.f]
  pack $b -side bottom -fill x
  pack $f -side top    -fill both -expand yes
  if { [llength $args] > 0 } {
   set page_type [lindex $args 0]
   } else {
   set page_type ""
  }
  if { ![info exists gPB(custom_command_import_page)] } {
   set page_obj [new Page "Import Custom Commands" "Import Custom Commands"]
   set gPB(custom_command_import_page) $page_obj
   } elseif { ![PB_com_HasObjectExisted $gPB(custom_command_import_page)] } {
   set page_obj [new Page "Import Custom Commands" "Import Custom Commands"]
   set gPB(custom_command_import_page) $page_obj
   } else {
   set page_obj $gPB(custom_command_import_page)
  }
  set Page::($page_obj,page_id) $f
  if { [catch { set sta [PB_pps_ParseTclFile $tcl_file event_proc_data 0] } ] } {
   global errorInfo
   return [ error "$errorInfo" ]
  }
  set Page::($page_obj,evt_proc_list) [array get event_proc_data]
  Page::CreatePane $page_obj
  _cmd_AddButtons $page_obj "import"
  Page::CreateCheckList $page_obj
  _cmd_CreateProcList $page_obj $page_type
  set tree $Page::($page_obj,tree)
  set HLIST [$tree subwidget hlist]
  set ok_sens 1
  if { [llength [$HLIST info children]] == 0 } {
   set ok_sens 0
  }
  UI_PB_prv_CreateSecPaneElems page_obj
  set label_list {"gPB(nav_button,ok,Label)" "gPB(nav_button,cancel,Label)"}
  set page_name $Page::($cur_main_page,page_name)
  if { [string match "cod" $page_name] } {
   set cb_arr(gPB(nav_button,ok,Label))     "__isv_ImportCmdOk_CB     $win $page_obj"
   } else {
   set cb_arr(gPB(nav_button,ok,Label))     "_cmd_ImportCmdOk_CB     $win $page_obj"
  }
  set cb_arr(gPB(nav_button,cancel,Label)) "_cmd_ImportCmdCancel_CB $win $page_obj"
  if { $ok_sens } {
   set gPB(VIEW_ADDRESS) 0
   } else {
   set gPB(VIEW_ADDRESS) 1
  }
  UI_PB_com_CreateButtonBox $b label_list cb_arr
  if { $ok_sens } {
   _cmd_TclTreeSelection $page_obj "import"
   } else {
   set ltext $Page::($page_obj,ltext)
   set rtext $Page::($page_obj,rtext)
   $ltext config -state disabled
   $rtext config -state disabled
   set lpane [winfo parent $Page::($page_obj,left_pane_id)]
   $lpane.top.sel config -state disabled
   $lpane.top.des config -state disabled
  }
  unset gPB(VIEW_ADDRESS)
 }

#=======================================================================
proc _cmd_AddButtons { page_obj action } {
  global paOption
  global gPB
  global gPB_help_tips
  set lpane $Page::($page_obj,left_pane_id)
  set frm [frame $lpane.top]
  set left_pane [frame $lpane.bot]
  set Page::($page_obj,left_pane_id) $left_pane
  pack $frm -side top -fill x -padx 7 -pady 2
  pack $left_pane -side bottom -fill both -expand yes
  set sel [button $frm.sel -text "$gPB(cust_cmd,select_all,Label)" \
  -command "_cmd_SelectAll $page_obj" \
  -bg $paOption(app_butt_bg) -state normal]
  set des [button $frm.des -text "$gPB(cust_cmd,deselect_all,Label)" \
  -command "_cmd_DeselectAll $page_obj" \
  -bg $paOption(app_butt_bg) -state normal]
  set inf [button $frm.inf -image [tix getimage pb_macro_info] \
  -command "_cmd_ShowDescriptionInfo $page_obj $action" \
  -bg $paOption(app_butt_bg) ]
  set gPB(custcmd_desc_info) ""
  set gPB(custcmd_desc_txt_widget) ""
  pack $inf -side right -padx 3 -pady 1
  pack $sel $des -side left -fill x -expand yes -padx 1 -pady 2
  PB_enable_balloon $inf
  set gPB_help_tips($inf) "$gPB(func,help,Label)"
  set gPB(c_help,$sel)     "cust_cmd,select_all"
  set gPB(c_help,$des)     "cust_cmd,deselect_all"
  set gPB(c_help,$inf)     "func,help"
 }

#=======================================================================
proc _cmd_SelectAll { page_obj } {
  set tree $Page::($page_obj,tree)
  set HLIST [$tree subwidget hlist]
  foreach ent [$HLIST info children] {
   $tree setstatus $ent on
  }
 }

#=======================================================================
proc _cmd_DeselectAll { page_obj } {
  set tree $Page::($page_obj,tree)
  set HLIST [$tree subwidget hlist]
  foreach ent [$HLIST info children] {
   $tree setstatus $ent off
  }
 }

#=======================================================================
proc _cmd_ShowDescriptionInfo { page_obj action } {
  global gPB env
  global tixOption paOption
  set page_w $Page::($page_obj,page_id)
  set gPB(custcmd_desc_dlg) $page_w.custcmd_desc
  if { [winfo exists $gPB(custcmd_desc_dlg)] } \
  {
   if { [wm state $gPB(custcmd_desc_dlg)] == "iconic" } \
   {
    wm deiconify $gPB(custcmd_desc_dlg)
   } else \
   {
    raise $gPB(custcmd_desc_dlg)
    focus $gPB(custcmd_desc_dlg)
   }
   return
  }
  _cmd_GetDescriptionInfo $action
  toplevel $gPB(custcmd_desc_dlg)
  if { ![string compare $::tix_version 8.4] } {
   bind all <MouseWheel> {}
   bind all <Shift-MouseWheel> {}
   bind all <Enter> {}
  }
  wm protocol $gPB(custcmd_desc_dlg) WM_DELETE_WINDOW "CB_cmd_DeleteDescInfoWnd NULL"
  wm geometry $gPB(custcmd_desc_dlg) 800x650+200+200
  set txt_bg $paOption(entry_disabled_bg)
  if { [string match "export" $action] } {
   set txt_bg $gPB(entry_color)
   set b [frame $gPB(custcmd_desc_dlg).b]
   pack $b -side bottom -fill x
   set label_list {"gPB(nav_button,ok,Label)" "gPB(nav_button,cancel,Label)"}
   set cb_arr(gPB(nav_button,ok,Label)) "CB_cmd_DeleteDescInfoWnd export"
   set cb_arr(gPB(nav_button,cancel,Label)) "CB_cmd_DeleteDescInfoWnd NULL"
   UI_PB_com_CreateButtonBox $b label_list cb_arr
  }
  set txt_state normal
  set wnd_title "$gPB(cmd,desc_dlg,title) : "
  if { [string compare $action "import"] == 0 } {
   set txt_state disabled
   append wnd_title "[file tail $gPB(custom_command_file_import)]"
   } else {
   set lbl_frm [frame $gPB(custcmd_desc_dlg).lbl_frm]
   pack $lbl_frm -side top -pady 5 -fill x
   label $lbl_frm.lbl -text "$gPB(cmd,export,desc,label)"
   pack $lbl_frm.lbl -side left -padx 5 -pady 5
  }
  wm title $gPB(custcmd_desc_dlg) "$wnd_title"
  set pane [tixPanedWindow $gPB(custcmd_desc_dlg).pane -orient vertical]
  pack $pane -expand yes -fill both
  set f2 [$pane add p2 -expand 1]
  $f2 config -relief flat
  set p2s [$pane subwidget p2]
  tixScrolledText $p2s.ent -scrollbar auto
  pack $p2s.ent -side top -expand yes -fill both -padx 5
  set ftext [$p2s.ent subwidget text]
  $ftext config -font $tixOption(fixed_font) -bg $txt_bg
  $ftext delete 0.0 end
  set num_line 1
  foreach line $gPB(custcmd_desc_info) {
   if { $num_line > 1 } {
    $ftext insert $num_line.0 "\n$line"
    } else {
    $ftext insert $num_line.0 "$line"
   }
   incr num_line
  }
  $ftext configure -state $txt_state
  set gPB(custcmd_desc_txt_widget) $ftext
  UI_PB_com_PositionWindow $gPB(custcmd_desc_dlg)
 }

#=======================================================================
proc CB_cmd_DeleteDescInfoWnd { action } {
  global gPB
  if { ![string compare $::tix_version 8.4] } {
   bind all <MouseWheel> [list UI_PB_mthd_MouseWheel %W %D %X %Y]
   bind all <Shift-MouseWheel> [list UI_PB_mthd_MouseWheel %W %D %X %Y x]
   tk_focusFollowsMouse
  }
  if { [info exists gPB(custcmd_desc_dlg)] && \
   [winfo exists $gPB(custcmd_desc_dlg)] } {
   if { [string compare "export" $action] == 0 } {
    _cmd_SetDescriptionInfo
   }
   destroy $gPB(custcmd_desc_dlg)
  }
 }

#=======================================================================
proc _cmd_GetDescriptionInfo { action } {
  global gPB
  if { [string compare "import" $action] != 0 } {
   return
  }
  set tcl_fid [open "$gPB(custom_command_file_import)" r]
  set found_begin 0
  set gPB(custcmd_desc_info) ""
  while { [gets $tcl_fid line] >= 0 } {
   set line [string trimleft $line " "]
   if { !$found_begin } {
    if { $line == "" } continue
    if { [string index $line 0] != "#" } {
     return
    }
    if { [string match "## HEADER BLOCK START ##*" $line] } {
     set found_begin 1
     continue
     } else {
     continue
    }
   }
   if { [string match "## HEADER BLOCK END ##*" $line] } {
    return
   }
   lappend gPB(custcmd_desc_info) "$line"
  }
  if { $found_begin } {
   set gPB(custcmd_desc_info) ""
  }
 }

#=======================================================================
proc _cmd_SetDescriptionInfo { } {
  global gPB
  set gPB(custcmd_desc_info) ""
  set ftext $gPB(custcmd_desc_txt_widget)
  if { $ftext == "" } return
  set endindex [$ftext index end]
  if { $endindex == "" } return
  set temp_list [split "$endindex" "."]
  set count [lindex $temp_list 0]
  if { $count < 1 } return
  set num_line 1
  while { $num_line < $count } {
   set line [$ftext get "$num_line.0 linestart" "$num_line.0 lineend"]
   if { $count == 2 } {
    set temp_line [string trimleft $line " "]
    if { $temp_line == "" } {
     return
    }
   }
   if { [string index $line 0] != "#" } {
    set temp_line "# "
    append temp_line "$line"
    lappend gPB(custcmd_desc_info) "$temp_line"
    } else {
    lappend gPB(custcmd_desc_info) "$line"
   }
   incr num_line
  }
 }

#=======================================================================
proc _cmd_ViewTclProcsEx { win tcl_file args} {
  global paOption
  global gPB
  set w $win
  set b [frame $w.b]
  set f [frame $w.f]
  pack $b -side bottom -fill x
  pack $f -side top    -fill both -expand yes
  if { ![info exists gPB(custom_command_export_page)] } {
   set page_obj [new Page "Export Custom Commands" "Export Custom Commands"]
   set gPB(custom_command_export_page) $page_obj
   } elseif { ![PB_com_HasObjectExisted $gPB(custom_command_export_page)] } {
   set page_obj [new Page "Export Custom Commands" "Export Custom Commands"]
   set gPB(custom_command_export_page) $page_obj
   } else {
   set page_obj $gPB(custom_command_export_page)
  }
  set Page::($page_obj,page_id) $f
  Page::CreatePane $page_obj
  _cmd_AddButtons $page_obj "export"
  if { [llength $args] } {
   set type [lindex $args 0]
   } else {
   set type ""
  }
  Page::CreateCheckList $page_obj
  _cmd_CreateProcListEx $page_obj $type
  set tree $Page::($page_obj,tree)
  set HLIST [$tree subwidget hlist]
  set ok_sens 1
  if { [llength [$HLIST info children]] == 0 } {
   set ok_sens 0
  }
  UI_PB_prv_CreateSecPaneElems page_obj
  set label_list {"gPB(nav_button,ok,Label)" "gPB(nav_button,cancel,Label)"}
  set cb_arr(gPB(nav_button,ok,Label))     "_cmd_ExportCmdOk_CB $win $page_obj $type"
  set cb_arr(gPB(nav_button,cancel,Label)) "CB_cmd_DeleteDescInfoWnd NULL; destroy $win; PB_com_DeleteObject $page_obj"
  if { $ok_sens } {
   set gPB(VIEW_ADDRESS) 0
   } else {
   set gPB(VIEW_ADDRESS) 1
  }
  UI_PB_com_CreateButtonBox $b label_list cb_arr
  if { $ok_sens } {
   _cmd_TclTreeSelection $page_obj "export"
   } else {
   set ltext $Page::($page_obj,ltext)
   set rtext $Page::($page_obj,rtext)
   $ltext config -state disabled
   $rtext config -state disabled
   set lpane [winfo parent $Page::($page_obj,left_pane_id)]
   $lpane.top.sel config -state disabled
   $lpane.top.des config -state disabled
  }
  unset gPB(VIEW_ADDRESS)
 }

#=======================================================================
proc _cmd_CreateProcList { page_obj args } {
  global paOption
  global gPB
  global post_object
  set bgclr $paOption(tree_bg)
  set style $gPB(font_style_bold)
  set style $gPB(font_style_normal)
  set style2  [tixDisplayStyle imagetext \
  -bg $bgclr -font $gPB(font) \
  -padx 4 -pady 3 \
  -selectforeground blue]
  set style2a [tixDisplayStyle imagetext \
  -bg $bgclr -font $gPB(italic_font_normal) -fg $paOption(name_bg) \
  -padx 4 -pady 3 \
  -selectforeground blue]
  set style3  [tixDisplayStyle imagetext \
  -bg $paOption(butt_bg) \
  -padx 7 -pady 1]
  set evt_proc_list $Page::($page_obj,evt_proc_list)
  array set event_proc_data $evt_proc_list
  set cmd_proc_list ""
  set oth_proc_list ""
  if { [llength $args] > 0 } {
   set page_type [lindex $args 0]
   } else {
   set page_type ""
  }
  set llen [llength $evt_proc_list]
  for { set i 0 } { $i < $llen } { incr i 2 } \
  {
   set event_item [lindex $evt_proc_list $i]
   if { ![string match "MOM*" $event_item] && [string match "*\,name" $event_item] } \
   {
    if { [string match "vnc" $page_type] } {
     if { [string match "PB_CMD_vnc*" $event_item] } {
      set event_name [lindex [split $event_item ,] 0]
      set cmd_proc_list [ladd $cmd_proc_list end $event_name "no_dup"]
      set cmd_proc_data($event_name,proc) $event_proc_data($event_name,proc)
      set cmd_proc_data($event_name,blk_list) $event_proc_data($event_name,blk_list)
      set cmd_proc_data($event_name,add_list) $event_proc_data($event_name,add_list)
      set cmd_proc_data($event_name,fmt_list) $event_proc_data($event_name,fmt_list)
     }
     } else {
     if { [string match "PB_CMD*" $event_item] && ![string match "PB_CMD_vnc*" $event_item] } {
      set event_name [lindex [split $event_item ,] 0]
      set cmd_proc_list [ladd $cmd_proc_list end $event_name "no_dup"]
      set cmd_proc_data($event_name,proc) $event_proc_data($event_name,proc)
      set cmd_proc_data($event_name,blk_list) $event_proc_data($event_name,blk_list)
      set cmd_proc_data($event_name,add_list) $event_proc_data($event_name,add_list)
      set cmd_proc_data($event_name,fmt_list) $event_proc_data($event_name,fmt_list)
      } elseif { ![string match "PB_*" $event_item] && ![string match "VNC_*" $event_item] } {
      set event_name [lindex [split $event_item ,] 0]
      set oth_proc_list [ladd $oth_proc_list end $event_name "no_dup"]
      set oth_proc_data($event_name,comment) $event_proc_data($event_name,comment)
      set oth_proc_data($event_name,args)    $event_proc_data($event_name,args)
      set oth_proc_data($event_name,proc)    $event_proc_data($event_name,proc)
     }
    }
   }
  }
  set post_oth_proc_list ""
  Post::GetOthProcList $post_object post_oth_proc_list
  Post::GetOthProcData $post_object post_oth_proc_data
  set post_cmd_obj_list ""
  set post_cmd_proc_list ""
  PB_int_RetCmdBlks post_cmd_obj_list
  set no_blks [llength $post_cmd_obj_list]
  for {set count 0} {$count < $no_blks} {incr count}\
  {
   set cmd_obj [lindex $post_cmd_obj_list $count]
   lappend post_cmd_proc_list $command::($cmd_obj,name)
  }
  set Page::($page_obj,cmd_proc_data) [array get cmd_proc_data]
  set Page::($page_obj,oth_proc_data) [array get oth_proc_data]
  set cmd_exists 0
  foreach event_name $cmd_proc_list \
  {
   if { [lsearch $post_cmd_proc_list $event_name] >= 0 } {
    set cmd_exists 1
    break
   }
  }
  if { $cmd_exists == 0 } {
   foreach event_name $oth_proc_list \
   {
    if { [lsearch $post_oth_proc_list $event_name] >= 0 } {
     set cmd_exists 1
     break
    }
   }
  }
  set tree $Page::($page_obj,tree)
  set HLIST [$tree subwidget hlist]
  uplevel #0 set TRANSPARENT_GIF_COLOR [$HLIST cget -bg]
  set page_id $Page::($page_obj,page_id)
  set ind_x 10
  if { $cmd_exists } {
   $HLIST add 0 -itemtype imagetext -text "" -image $paOption(folder) -state disabled
   $HLIST indicator create 0 -itemtype imagetext -text "exists" -image $gPB(pb_cmd_icon)
   set ind_x [expr $ind_x + [lindex [$HLIST indicator size 0] 0]]
   $HLIST indicator delete 0
   $HLIST hide entry 0
   $page_id.pane paneconfigure p1 -size 300
   $page_id.pane paneconfigure p2 -size 600
   } else {
   $page_id.pane paneconfigure p1 -size 250
   $page_id.pane paneconfigure p2 -size 650
  }
  $HLIST config -drawbranch 0 -indent $ind_x \
  -bg $bgclr -padx 5 -pady 5
  set t 1
  set cmd_proc_list [lsort -dictionary $cmd_proc_list]
  foreach event_name $cmd_proc_list \
  {
   if 0 {
    set icon [tix getimage pb_bird_in_house]
    set new_frm [frame $HLIST.cmd$t -bg $bgclr -relief flat -bd 0]
    label $new_frm.lbl -text "   " -bg $bgclr
    set img_id [image create compound -window $new_frm.lbl]
    $img_id add image -image $icon
    $new_frm.lbl config -image $img_id
    unset img_id
    pack $new_frm.lbl -side left -fill both
    checkbutton $new_frm.pb -text " $event_name" -bg $bgclr \
    -relief flat -bd 0 -activebackground $paOption(butt_bg) \
    -highlightbackground $paOption(butt_bg) \
    -takefocus 1 -anchor sw
    pack $new_frm.pb -side left
    $HLIST add 0.$t -itemtype window -window $new_frm -state normal -at $t
   }
   $HLIST add $t -itemtype imagetext -text $event_name -style $style2 -state normal
   if { [lsearch $post_cmd_proc_list $event_name] >= 0 } {
    $HLIST indicator create $t -itemtype imagetext -text "exists" -image $gPB(pb_cmd_icon) \
    -style $style3
   }
   $tree setstatus $t on
   incr t
  }
  set oth_proc_list [lsort -dictionary $oth_proc_list]
  foreach event_name $oth_proc_list \
  {
   $HLIST add $t -itemtype imagetext -text $event_name -style $style2a -state normal
   if { [lsearch $post_oth_proc_list $event_name] >= 0 } {
    $HLIST indicator create $t -itemtype imagetext -text "exists" -image $gPB(pb_cmd_icon) \
    -style $style3
   }
   $tree setstatus $t on
   incr t
  }
  set Page::($page_obj,prev_index) 0
  if { [expr [llength $cmd_proc_list] + [llength $oth_proc_list]] > 0 } {
   $HLIST config -browsecmd "_cmd_TclTreeSelection $page_obj import"
   $HLIST config -indicatorcmd "_cmd_TclTreeSelection $page_obj import"
   $HLIST selection set 1
   $HLIST anchor set 1
  }
  set gPB(custom_command_import_page) $page_obj
  set gPB(c_help,$tree)    "cust_cmd,import,tree"
  set gPB(c_help,$HLIST)   "cust_cmd,import,tree"
 }

#=======================================================================
proc UI_PB_cmd_DisableSelection { h args } {
  global gPB
  if { [info exists gPB(custom_command_import_page)] } {
   set page_obj $gPB(custom_command_import_page)
   $h selection clear
   $h selection set $Page::($page_obj,prev_index)
   $h anchor set $Page::($page_obj,prev_index)
  }
 }

#=======================================================================
proc _cmd_CreateProcListEx { page_obj args} {
  global paOption
  global gPB
  global post_object
  global mom_sys_arr
  set bgclr $paOption(tree_bg)
  set style $gPB(font_style_bold)
  set style $gPB(font_style_normal)
  if { [llength $args] } {
   set type [lindex $args 0]
   } else {
   set type ""
  }
  set style2  [tixDisplayStyle imagetext \
  -bg $bgclr -font $gPB(font) \
  -padx 4 -pady 3 \
  -selectforeground blue]
  set style2a [tixDisplayStyle imagetext \
  -bg $bgclr -font $gPB(italic_font_normal) -fg $paOption(name_bg) \
  -padx 4 -pady 3 \
  -selectforeground blue]
  set style3  [tixDisplayStyle imagetext \
  -bg $paOption(butt_bg) \
  -padx 7 -pady 1]
  set post_oth_proc_list ""
  Post::GetOthProcList $post_object post_oth_proc_list
  Post::GetOthProcData $post_object post_oth_proc_data
  set post_cmd_obj_list ""
  set post_cmd_proc_list ""
  PB_int_RetCmdBlks post_cmd_obj_list
  set no_blks [llength $post_cmd_obj_list]
  for { set count 0 } { $count < $no_blks } { incr count } \
  {
   set cmd_obj [lindex $post_cmd_obj_list $count]
   if { [string match "ELSE" $command::($cmd_obj,name)] || \
    [string match "END"  $command::($cmd_obj,name)] } {
    continue
   }
   if { [string match "PB_CMD_vnc*" $command::($cmd_obj,name)] } {
    if { [string match "vnc" $type] } {
     if { [info exists mom_sys_arr(Output_VNC)] && $mom_sys_arr(Output_VNC) == 1 } {
      global mom_sim_arr
      if { [string match "Standalone" $mom_sys_arr(VNC_Mode)] } {
       if { [info exists mom_sim_arr(\$mom_sim_vnc_com_list)] &&  \
        ([lsearch $mom_sim_arr(\$mom_sim_vnc_com_list) $command::($cmd_obj,name)] >= 0) } {
        lappend post_cmd_proc_list $command::($cmd_obj,name)
       }
       } else {
       if { [info exists mom_sim_arr(\$mom_sim_sub_vnc_list)] &&  \
        ([lsearch $mom_sim_arr(\$mom_sim_sub_vnc_list) $command::($cmd_obj,name)] >= 0) } {
        lappend post_cmd_proc_list $command::($cmd_obj,name)
       }
      }
     }
    }
    } else {
    if { ![string match "vnc" $type] } {
     lappend post_cmd_proc_list $command::($cmd_obj,name)
    }
   }
  }
  set Page::($page_obj,post_cmd_proc_data) [array get post_cmd_proc_data]
  set Page::($page_obj,post_oth_proc_data) [array get post_oth_proc_data]
  set tree $Page::($page_obj,tree)
  set HLIST [$tree subwidget hlist]
  uplevel #0 set TRANSPARENT_GIF_COLOR [$HLIST cget -bg]
  set page_id $Page::($page_obj,page_id)
  $page_id.pane paneconfigure p1 -size 250
  $page_id.pane paneconfigure p2 -size 650
  set ind_x 10
  $HLIST config -drawbranch 0 -indent $ind_x \
  -bg $bgclr -padx 5 -pady 5
  set t 1
  set post_cmd_proc_list [lsort -dictionary $post_cmd_proc_list]
  foreach event_name $post_cmd_proc_list \
  {
   $HLIST add $t -itemtype imagetext -text $event_name -style $style2 -state normal
   $tree setstatus $t on
   incr t
  }
  set post_oth_proc_list [lsort -dictionary $post_oth_proc_list]
  if { ![string match "vnc" $type] } {
   foreach event_name $post_oth_proc_list \
   {
    $HLIST add $t -itemtype imagetext -text $event_name -style $style2a -state normal
    $tree setstatus $t on
    incr t
   }
  }
  set Page::($page_obj,prev_index) 0
  if { ![string match "vnc" $type] } {
   if { [expr [llength $post_cmd_proc_list] + [llength $post_oth_proc_list]] > 0 } {
    $HLIST config -browsecmd "_cmd_TclTreeSelection $page_obj export"
    $HLIST selection set 1
    $HLIST anchor set 1
   }
   } else {
   if { [expr [llength $post_cmd_proc_list]] > 0 } {
    $HLIST config -browsecmd "_cmd_TclTreeSelection $page_obj export"
    $HLIST selection set 1
    $HLIST anchor set 1
   }
  }
  set gPB(custom_command_export_page) $page_obj
  set gPB(c_help,$tree)    "cust_cmd,export,tree"
  set gPB(c_help,$HLIST)   "cust_cmd,export,tree"
 }

#=======================================================================
proc _cmd_TclTreeSelection { page_obj args } {
  set tree $Page::($page_obj,tree)
  set HLIST [$tree subwidget hlist]
  set ent [$HLIST info selection]
  set index $ent
  if { [string compare $index ""] == 0 } \
  {
   $HLIST selection clear
   $HLIST anchor clear
   $HLIST selection set 1
   $HLIST anchor set 1
   set index 1
  }
  if { $index != $Page::($page_obj,prev_index) } {
   set proc_name [lindex [$HLIST entryconfigure $index -text] end]
   if { [llength $args] && [lindex $args 0] == "import" } {
    _cmd_DisplayTclProc $page_obj $proc_name
    } else {
    _cmd_DisplayTclProcEx $page_obj $proc_name
   }
  }
  set Page::($page_obj,prev_index) $index
  focus $HLIST
  return
  set sta [string tolower [$tree getstatus $ent]]
  if { [string match "on" $sta] } {
   $tree setstatus $ent "off"
   } elseif { [string match "off" $sta] } {
   $tree setstatus $ent "on"
  }
 }

#=======================================================================
proc _cmd_DisplayTclProc { page_obj proc_name } {
  global post_object
  set ltext $Page::($page_obj,ltext)
  set rtext $Page::($page_obj,rtext)
  $ltext config -state normal
  $rtext config -state normal
  $ltext delete 1.0 end
  $rtext delete 1.0 end
  set post_oth_proc_list ""
  Post::GetOthProcList $post_object post_oth_proc_list
  Post::GetOthProcData $post_object post_oth_proc_data
  set post_cmd_obj_list ""
  PB_int_RetCmdBlks post_cmd_obj_list
  set cmd_obj_found 0
  set no_blks [llength $post_cmd_obj_list]
  for {set count 0} {$count < $no_blks} {incr count}\
  {
   set cmd_obj [lindex $post_cmd_obj_list $count]
   if { [string match "$proc_name" $command::($cmd_obj,name)] } {
    set cmd_obj_found $cmd_obj
   }
  }
  array set oth_proc_data $Page::($page_obj,oth_proc_data)
  array set cmd_proc_data $Page::($page_obj,cmd_proc_data)
  set text_pane $Page::($page_obj,canvas_frame).pane
  if { $cmd_obj_found || [info exists post_oth_proc_data($proc_name,proc)] } {
   if { ![catch {$text_pane manage p2}] } {
    $text_pane paneconfigure p1 -size 250
   }
   } else {
   set top_win [winfo toplevel $text_pane]
   set bck_cmds [bind $top_win <Destroy>]
   bind $top_win <Destroy> [list]
   if { ![catch {$text_pane forget p2}] } {
    $text_pane paneconfigure p1 -size 500
   }
   bind $top_win <Destroy> $bck_cmds
  }
  if { [info exists cmd_proc_data($proc_name,proc)] } {
   $ltext insert end "    #=============================================================\n"

#=======================================================================
$ltext insert end "    proc $proc_name \{ \} \{\n"
  $ltext insert end "    #=============================================================\n"
  foreach line $cmd_proc_data($proc_name,proc) {
   $ltext insert end "    $line\n"
  }
 $ltext insert end "    \}\n"
 if { $cmd_obj_found } {
  $rtext insert end "    #=============================================================\n"

#=======================================================================
$rtext insert end "    proc $proc_name \{ \} \{\n"
  $rtext insert end "    #=============================================================\n"
  foreach line $command::($cmd_obj_found,proc) \
  {
   $rtext insert end "    $line\n"
  }
 $rtext insert end "    \}\n"
}
} elseif { [info exists oth_proc_data($proc_name,proc)] } {
foreach line $oth_proc_data($proc_name,comment) {
 $ltext insert end "    $line\n"
}
if { [llength $oth_proc_data($proc_name,args)] } {

#=======================================================================
$ltext insert end "    proc $proc_name \{ [join $oth_proc_data($proc_name,args)] \} \{\n"
  } else {

#=======================================================================
$ltext insert end "    proc $proc_name \{ \} \{\n"
 }
 foreach line $oth_proc_data($proc_name,proc) {
  $ltext insert end "    $line\n"
 }
$ltext insert end "    \}\n"
if { [info exists post_oth_proc_data($proc_name,proc)] } {
 foreach line $post_oth_proc_data($proc_name,comment) {
  $rtext insert end "    $line\n"
 }
 if { [llength $post_oth_proc_data($proc_name,args)] } {

#=======================================================================
$rtext insert end "    proc $proc_name \{ [join $post_oth_proc_data($proc_name,args)] \} \{\n"
  } else {

#=======================================================================
$rtext insert end "    proc $proc_name \{ \} \{\n"
 }
 foreach line $post_oth_proc_data($proc_name,proc) {
  $rtext insert end "    $line\n"
 }
$rtext insert end "    \}\n"
}
}
$ltext config -state disabled
$rtext config -state disabled
if { ![string compare $::tix_version 8.4] } {
UI_PB_com_HighlightTclKeywords $ltext
UI_PB_com_HighlightTclKeywords $rtext
}
}

#=======================================================================
proc _cmd_DisplayTclProcEx { page_obj proc_name } {
  global post_object
  set ltext $Page::($page_obj,ltext)
  set rtext $Page::($page_obj,rtext)
  $ltext config -state normal
  $rtext config -state normal
  $ltext delete 1.0 end
  $rtext delete 1.0 end
  array set oth_proc_data $Page::($page_obj,post_oth_proc_data)
  set text_pane $Page::($page_obj,canvas_frame).pane
  set top_win [winfo toplevel $text_pane]
  set bck_cmds [bind $top_win <Destroy>]
  bind $top_win <Destroy> [list]
  if { ![catch {$text_pane forget p1}] } {
   $text_pane paneconfigure p2 -size 500
  }
  bind $top_win <Destroy> $bck_cmds
  set post_cmd_obj_list ""
  PB_int_RetCmdBlks post_cmd_obj_list
  set cmd_obj_found 0
  set no_blks [llength $post_cmd_obj_list]
  for {set count 0} {$count < $no_blks} {incr count}\
  {
   set cmd_obj [lindex $post_cmd_obj_list $count]
   if { [string match "$proc_name" $command::($cmd_obj,name)] } {
    set cmd_obj_found $cmd_obj
   }
  }
  if { $cmd_obj_found } {
   $rtext insert end "    #=============================================================\n"

#=======================================================================
$rtext insert end "    proc $proc_name \{ \} \{\n"
  $rtext insert end "    #=============================================================\n"
  foreach line $command::($cmd_obj_found,proc) \
  {
   $rtext insert end "    $line\n"
  }
 $rtext insert end "    \}\n"
 } elseif { [info exists oth_proc_data($proc_name,proc)] } {
 foreach line $oth_proc_data($proc_name,comment) {
  $rtext insert end "    $line\n"
 }
 if { [llength $oth_proc_data($proc_name,args)] } {

#=======================================================================
$rtext insert end "    proc $proc_name \{ [join $oth_proc_data($proc_name,args)] \} \{\n"
  } else {

#=======================================================================
$rtext insert end "    proc $proc_name \{ \} \{\n"
 }
 foreach line $oth_proc_data($proc_name,proc) {
  $rtext insert end "    $line\n"
 }
$rtext insert end "    \}\n"
}
$ltext config -state disabled
$rtext config -state disabled
if { ![string compare $::tix_version 8.4] } {
UI_PB_com_HighlightTclKeywords $ltext
UI_PB_com_HighlightTclKeywords $rtext
}
}

#=======================================================================
proc _cmd_ImportCmdOk_CB { win page_obj } {
  global post_object
  global gPB
  set tree $Page::($page_obj,tree)
  set HLIST [$tree subwidget hlist]
  set out_cmd_proc_list ""
  set out_oth_proc_list ""
  set item_selected 0
  foreach ent [$HLIST info children] {
   set sta [string tolower [$tree getstatus $ent]]
   if { [string match "on" $sta] } {
    incr item_selected
    set proc_name [lindex [$HLIST entryconfigure $ent -text] end]
    if { $proc_name == "" } {
     $tree setstatus $ent off
     } else {
     if { [string match "PB_CMD*" $proc_name] } {
      lappend out_cmd_proc_list $proc_name
      } else {
      lappend out_oth_proc_list $proc_name
     }
    }
   }
  }
  if { $item_selected == 0 } {
   tk_messageBox -parent [UI_PB_com_AskActiveWindow] -type ok \
   -icon warning -title "$gPB(cust_cmd,import,warning,title)" \
   -message "$gPB(cust_cmd,import,warning,msg)"
   return
  }
  array set cmd_proc_data $Page::($page_obj,cmd_proc_data)
  foreach cmd $out_cmd_proc_list {
   set cmd_obj_attr(0) $cmd
   set cmd_obj_attr(1) $cmd_proc_data($cmd,proc)
   set cmd_obj_attr(2) $cmd_proc_data($cmd,blk_list)
   set cmd_obj_attr(3) $cmd_proc_data($cmd,add_list)
   set cmd_obj_attr(4) $cmd_proc_data($cmd,fmt_list)
   __cmd_CreateCommand cmd_obj_attr cmd
  }
  Post::GetObjList $post_object command cmd_obj_list
  PB_com_SortObjectsByNames cmd_obj_list
  Post::SetObjListasAttr $post_object cmd_obj_list
  foreach cmd_obj $cmd_obj_list {
   PB_int_UpdateCommandAdd cmd_obj
  }
  array set oth_proc_data $Page::($page_obj,oth_proc_data)
  set post_oth_proc_list ""
  Post::GetOthProcList $post_object post_oth_proc_list
  Post::GetOthProcData $post_object post_oth_proc_data
  foreach oth $out_oth_proc_list {
   set post_oth_proc_list [ladd $post_oth_proc_list end $oth "no_dup"]
   set post_oth_proc_data($oth,comment) $oth_proc_data($oth,comment)
   set post_oth_proc_data($oth,args)    $oth_proc_data($oth,args)
   set post_oth_proc_data($oth,proc)    $oth_proc_data($oth,proc)
  }
  if { [llength $out_oth_proc_list] } {
   Post::SetOthProcList $post_object post_oth_proc_list
   Post::SetOthProcData $post_object post_oth_proc_data
  }
  set prog_page_obj [lindex $Book::($gPB(book),page_obj_list) 1]
  set book_obj $Page::($prog_page_obj,book_obj)
  set cmd_page_obj [lindex $Book::($book_obj,page_obj_list) 5]
  set cmd_obj $Page::($cmd_page_obj,active_cmd_obj)
  command::readvalue $cmd_obj cmd_obj_attr
  UI_PB_cmd_DeleteCmdProc $cmd_page_obj
  set Page::($cmd_page_obj,selected_index) -1
  if { [info exists Page::($cmd_page_obj,active_cmd_obj)] } {
   unset Page::($cmd_page_obj,active_cmd_obj)
  }
  UI_PB_UpdateProgTpthBook book_obj
  UI_PB_progtpth_DeleteTabAtt book_obj
  set Book::($book_obj,current_tab) 5
  UI_PB_progtpth_CreateTabAttr book_obj
  CB_cmd_DeleteDescInfoWnd import
  unset gPB(custom_command_import_page)
  PB_com_DeleteObject $page_obj
  destroy $win
 }

#=======================================================================
proc __cmd_CreateCommand { CMD_OBJ_ATTR CMD_OBJ } {
  upvar $CMD_OBJ_ATTR cmd_obj_attr
  upvar $CMD_OBJ cmd_obj
  global post_object
  Post::GetObjList $post_object command cmd_blk_list
  if { [info exists cmd_obj] } { unset cmd_obj }
  foreach cc $cmd_blk_list {
   command::readvalue $cc attr
   if { $attr(0) == "$cmd_obj_attr(0)" } {
    set cmd_obj $cc
    break
   }
  }
  if { ![info exists cmd_obj] } {
   set cmd_obj [new command]
   lappend cmd_blk_list $cmd_obj
   Post::SetObjListasAttr $post_object cmd_blk_list
   command::DefaultValue $cmd_obj cmd_obj_attr
  }
  command::setvalue $cmd_obj cmd_obj_attr
 }

#=======================================================================
proc _cmd_ImportCmdCancel_CB { win page_obj } {
  global gPB
  unset gPB(custom_command_import_page)
  CB_cmd_DeleteDescInfoWnd import
  PB_com_DeleteObject $page_obj
  destroy $win
 }

#=======================================================================
proc _cmd_ExportCmdOk_CB { win page_obj args} {
  global post_object
  global gPB
  if { [info exists gPB(PB_LICENSE)] && \
   $gPB(PB_LICENSE) == "UG_POST_NO_LICENSE" } {
   return [tk_messageBox -parent [UI_PB_com_AskActiveWindow] \
   -icon error -message "$gPB(msg,no_license)"]
  }
  if { [llength $args] } {
   set type [lindex $args 0]
   } else {
   set type ""
  }
  set tree $Page::($page_obj,tree)
  set HLIST [$tree subwidget hlist]
  set out_cmd_proc_list ""
  set out_oth_proc_list ""
  set item_selected 0
  foreach ent [$HLIST info children] {
   set sta [string tolower [$tree getstatus $ent]]
   if { [string match "on" $sta] } {
    incr item_selected
    set proc_name [lindex [$HLIST entryconfigure $ent -text] end]
    if { [string match "PB_CMD*" $proc_name] } {
     lappend out_cmd_proc_list $proc_name
     } else {
     lappend out_oth_proc_list $proc_name
    }
   }
  }
  if { $item_selected == 0 } {
   tk_messageBox -parent [UI_PB_com_AskActiveWindow] -type ok \
   -icon warning -title "$gPB(cust_cmd,import,warning,title)" \
   -message "$gPB(cust_cmd,import,warning,msg)"
   return
  }
  CB_cmd_DeleteDescInfoWnd export
  destroy $win
  PB_com_DeleteObject $page_obj
  UI_PB_com_SetStatusbar "Select a Tcl file."
  global tcl_platform
  if { $tcl_platform(platform) == "unix" } \
  {
   UI_PB_file_SelectFile_unx TCL gPB(custom_command_file_export) save
   } elseif { $tcl_platform(platform) == "windows" } \
  {
   UI_PB_com_GrayOutSaveOptions
   UI_PB_com_DisableMain
   UI_PB_file_SelectFile_win TCL gPB(custom_command_file_export) save
   UI_PB_com_EnableMain
   UI_PB_com_UnGraySaveOptions
  }
  if { $gPB(custom_command_file_export) != "" } {
   set gPB(custom_command_file_export) [string trim $gPB(custom_command_file_export) \"]
   set dir_name [file dirname $gPB(custom_command_file_export)]
   if { [file writable $dir_name] == 0 } {
    tk_messageBox -parent [UI_PB_com_AskActiveWindow] -type ok \
    -icon warning -title "$gPB(cust_cmd,error,title)" \
    -message "You do not have permission to write to \"$dir_name!\""
    return
   }
   set fid [open $gPB(custom_command_file_export) {RDWR CREAT TRUNC}]
   PB_file_fconfigure $fid
   global env
   set time_string [clock format [clock seconds] -format "%c %Z"]
   puts $fid "\#==============================================================================="
   puts $fid "\# Exported Custom Commands created by $env(USERNAME)"
   puts $fid "\# on $time_string"
   puts $fid "\#==============================================================================="
   if { $gPB(custcmd_desc_info) != "" } {
    puts $fid ""
    puts $fid "## HEADER BLOCK START ##"
    puts $fid "\#==============================================================================="
    puts $fid "\#"
    foreach desc_line $gPB(custcmd_desc_info) {
     puts $fid "$desc_line"
    }
    puts $fid "\#"
    puts $fid "\#==============================================================================="
    puts $fid "## HEADER BLOCK END ##"
   }
   puts $fid ""
   puts $fid ""
   puts $fid ""
   set post_cmd_obj_list ""
   PB_int_RetCmdBlks post_cmd_obj_list
   foreach cmd_obj $post_cmd_obj_list {
    set proc_name $command::($cmd_obj,name)
    if { [lsearch $out_cmd_proc_list "$proc_name"] >= 0 } {
     puts $fid "#============================================================="

#=======================================================================
puts $fid "proc $command::($cmd_obj,name) \{ \} \{"
  puts $fid "#============================================================="
  foreach line $command::($cmd_obj,proc) \
  {
   puts $fid "$line"
  }
 puts $fid "\}"
 puts $fid ""
 puts $fid ""
 puts $fid ""
}
}
set post_oth_proc_list ""
Post::GetOthProcList $post_object post_oth_proc_list
Post::GetOthProcData $post_object post_oth_proc_data
foreach proc_name $post_oth_proc_list {
if { [lsearch $out_oth_proc_list "$proc_name"] >= 0 } {
 foreach line $post_oth_proc_data($proc_name,comment) {
  puts $fid "$line"
 }
 if { [llength $post_oth_proc_data($proc_name,args)] } {

#=======================================================================
puts $fid "proc $proc_name \{ [join $post_oth_proc_data($proc_name,args)] \} \{"
  } else {

#=======================================================================
puts $fid "proc $proc_name \{ \} \{"
 }
 foreach line $post_oth_proc_data($proc_name,proc) {
  puts $fid "$line"
 }
puts $fid "\}"
puts $fid ""
puts $fid ""
puts $fid ""
}
}
close $fid
}
}

#=======================================================================
proc UI_PB_cmd_CreateACmdBlock { page_obj } {
  if { [info exists Page::($page_obj,rename_index)] } \
  {
   if { [UI_PB_cmd_UpdateCmdEntry $page_obj \
    $Page::($page_obj,rename_index)] == "UI_PB_ERROR" } {
    return
   }
  }
  if { ![info exists Page::($page_obj,active_cmd_obj)] } \
  {
   set act_cmd_obj 0
   set obj_index ""
  } else \
  {
   if { ![UI_PB_cmd_SaveCmdProc $page_obj] } {
    return
   }
   set act_cmd_obj $Page::($page_obj,active_cmd_obj)
   unset Page::($page_obj,active_cmd_obj)
   UI_PB_cmd_DeleteCmdProc $page_obj
  }
  if { $Page::($page_obj,double_click_flag) } \
  {
   set Page::($page_obj,double_click_flag) 0
   unset Page::($page_obj,rename_index)
  }
  PB_int_CreateCmdObj act_cmd_obj obj_index
  set index 0
  if { [info exists Page::($page_obj,selected_index)] } {
   set index [expr [string range $Page::($page_obj,selected_index) 2 end] + 1]
   unset Page::($page_obj,selected_index)
  }
  UI_PB_cmd_DisplayCmdBlocks page_obj obj_index
  UI_PB_cmd_SelectItem $page_obj 0.$obj_index
 }

#=======================================================================
proc UI_PB_cmd_CutACmdBlock { page_obj } {
  global gPB
  if { ![info exists Page::($page_obj,active_cmd_obj)] } \
  {
   return
  }
  set active_cmd_obj $Page::($page_obj,active_cmd_obj)
  if { [string match "PB_CMD_before_motion" $command::($active_cmd_obj,name)] || \
  [string match "PB_CMD_kin_*" $command::($active_cmd_obj,name)] } \
  {
   set cmd_name $command::($active_cmd_obj,name)
   tk_messageBox -parent [UI_PB_com_AskActiveWindow] -type ok \
   -icon warning  -message "$gPB(msg,in_use)"
   } elseif { $command::($active_cmd_obj,blk_elem_list) != "" } \
  {
   set cmd_name $command::($active_cmd_obj,name)
   tk_messageBox -parent [UI_PB_com_AskActiveWindow] -type ok -icon error \
   -message "$gPB(msg,in_use)"
   } elseif { [string match "$gPB(check_block_cmd_prefix)*" $command::($active_cmd_obj,name)] && \
   [info exists command::($active_cmd_obj,condition_flag)] && \
  $command::($active_cmd_obj,condition_flag) == 1 } \
  {
   set cmd_name $command::($active_cmd_obj,name)
   tk_messageBox -parent [UI_PB_com_AskActiveWindow] -type ok \
   -icon warning  -message "$gPB(msg,in_use)"
  } else \
  {
   if 0 {
    if { [info exists Page::($page_obj,buff_cmd_obj)] } \
    {
     if 1 {
      if { [expr $active_cmd_obj != $Page::($page_obj,buff_cmd_obj)] } {
       PB_com_DeleteObject $Page::($page_obj,buff_cmd_obj)
      }
      } else {
      PB_com_DeleteObject $Page::($page_obj,buff_cmd_obj)
     }
     unset Page::($page_obj,buff_cmd_obj)
    }
   }
   if { ![UI_PB_cmd_SaveCmdProc $page_obj not_verify] } {
    return
   }
   UI_PB_cmd_DeleteCmdProc $page_obj
   if { $Page::($page_obj,double_click_flag) } \
   {
    set ent $Page::($page_obj,rename_index)
    set obj_index [string range $ent 2 end]
    set Page::($page_obj,double_click_flag) 0
    unset Page::($page_obj,rename_index)
    grab release [grab current]
   } else \
   {
    set tree $Page::($page_obj,tree)
    set HLIST [$tree subwidget hlist]
    set ent [$HLIST info selection]
    set obj_index [string range $ent 2 end]
   }
   set Page::($page_obj,buff_cmd_obj) $active_cmd_obj
   PB_int_CommandCutObject active_cmd_obj obj_index
   unset Page::($page_obj,active_cmd_obj)
   set index 0
   if { [info exists Page::($page_obj,selected_index)] } {
    set index [expr [string range $Page::($page_obj,selected_index) 2 end] - 1]
    unset Page::($page_obj,selected_index)
   }
   UI_PB_cmd_DisplayCmdBlocks page_obj obj_index
   UI_PB_cmd_SelectItem $page_obj 0.[incr obj_index -1]
   set left_pane_id $Page::($page_obj,left_pane_id)
   $left_pane_id.f.pas config -state normal
  }
 }

#=======================================================================
proc UI_PB_cmd_PasteACmdBlock { page_obj } {
  if { ![info exists Page::($page_obj,buff_cmd_obj)] } \
  {
   return
  }
  if { [info exists Page::($page_obj,rename_index)] } \
  {
   if { [UI_PB_cmd_UpdateCmdEntry $page_obj \
    $Page::($page_obj,rename_index)] == "UI_PB_ERROR" } {
    return
   }
  }
  if { $Page::($page_obj,double_click_flag) } \
  {
   set ent $Page::($page_obj,rename_index)
   set obj_index [string range $ent 2 end]
   set Page::($page_obj,double_click_flag) 0
   unset Page::($page_obj,rename_index)
  } else \
  {
   set tree $Page::($page_obj,tree)
   set HLIST [$tree subwidget hlist]
   set ent [$HLIST info selection]
   set obj_index [string range $ent 2 end]
  }
  set buff_cmd_obj $Page::($page_obj,buff_cmd_obj)
  set temp_index $obj_index
  PB_int_CmdBlockPasteObject buff_cmd_obj obj_index
  set index 0
  if { [info exists Page::($page_obj,selected_index)] } {
   set index [expr [string range $Page::($page_obj,selected_index) 2 end] + 1]
   unset Page::($page_obj,selected_index)
  }
  if { $temp_index != $obj_index } \
  {
   UI_PB_cmd_DisplayCmdBlocks page_obj obj_index
   UI_PB_cmd_SelectItem $page_obj 0.$obj_index
  }
  set left_pane_id $Page::($page_obj,left_pane_id)
  $left_pane_id.f.pas config -state disabled
  unset Page::($page_obj,buff_cmd_obj)
 }

#=======================================================================
proc UI_PB_cmd_CmdTabCreate { PAGE_OBJ } {
  upvar $PAGE_OBJ page_obj
  set tree $Page::($page_obj,tree)
  set HLIST [$tree subwidget hlist]
  set ent [$HLIST info selection]
  set index [string range $ent 2 end]
  if { [string compare $index ""] == 0 } \
  {
   set index 0
  }
  UI_PB_cmd_DisplayCmdBlocks page_obj index
  update
  UI_PB_cmd_SelectItem $page_obj
 }

#=======================================================================
proc UI_PB_cmd_CmdTabDelete { PAGE_OBJ } {
  upvar $PAGE_OBJ page_obj
  UI_PB_cmd_DeleteCmdProc $page_obj
  if { [info exists Page::($page_obj,active_cmd_obj)] } \
  {
   unset Page::($page_obj,active_cmd_obj)
  }
 }

#=======================================================================
proc UI_PB_cmd_CreateCmdBlkPage { PAGE_OBJ cmd_mode } {
  upvar $PAGE_OBJ page_obj
  global gPB paOption
  global pb_cmd_procname
  set bg $paOption(title_bg)
  set fg $paOption(special_fg)
  set ft $gPB(bold_font)
  set win $Page::($page_obj,canvas_frame)
  set top_frm [frame $win.top -relief flat -bg $bg]
  set mid_frm [frame $win.mid]
  set bot_frm [frame $win.bot -relief flat -bg $bg]
  pack $top_frm -side top -fill x
  pack $bot_frm -side bottom -fill x
  pack $mid_frm -side top -fill both -expand yes
  if { [string match "VNC*" $Page::($page_obj,page_name)] } {

#=======================================================================
label $top_frm.prc -text " proc    VNC_CMD_" -fg $fg -bg $bg -font $ft -anchor e
 } elseif { [info exists Page::($page_obj,cmd_mode)] && \
 [string match "Condition*" $Page::($page_obj,cmd_mode)] } {  ;# <- Check block condition

#=======================================================================
label $top_frm.prc -text " proc    $gPB(check_block_cmd_prefix)" -fg $fg -bg $bg -font $ft -anchor e
 } else {

#=======================================================================
label $top_frm.prc -text " proc    PB_CMD_"                      -fg $fg -bg $bg -font $ft -anchor e
}
if { $cmd_mode } \
{
 entry $top_frm.ent -textvariable pb_cmd_procname -width $gPB(MOM_block_name_len)\
 -relief flat -bd 0 -justify left
 bind $top_frm.ent <KeyPress> "UI_PB_com_DisableKeysForProc %W %K"
 bind $top_frm.ent <KeyRelease> { %W config -state normal }
 if { [string match "before_motion" $pb_cmd_procname] || \
 [string match "kin*" $pb_cmd_procname] } \
 {
  $top_frm.ent config -state disabled
 }
} else \
{
 label $top_frm.ent -text "" -fg $fg -bg $bg -font $ft
}
label $top_frm.brc -text "   \{ \}   \{" -fg $fg -bg $bg -font $ft
 pack $top_frm.prc $top_frm.ent $top_frm.brc -side left -pady 10 -fill x
 tixScrolledText $mid_frm.scr
 [$mid_frm.scr subwidget hsb] config -troughcolor $paOption(trough_bg) \
 -width $paOption(trough_wd)
 [$mid_frm.scr subwidget vsb] config -troughcolor $paOption(trough_bg) \
 -width $paOption(trough_wd)
 pack $mid_frm.scr -expand yes -fill both
 set text_widget [$mid_frm.scr subwidget text]
 $text_widget config -font $gPB(fixed_font) -wrap none -bd 5 -relief flat
 set Page::($page_obj,text_widget) $text_widget
 set Page::($page_obj,cmd_entry) $top_frm.ent
 set Page::($page_obj,entry_flag) $cmd_mode
 set tbg [lindex [$text_widget config -bg] end]
 set Page::($page_obj,text_widget_bg) $tbg
label $bot_frm.brc -text "\}" -fg $fg -bg $bg -font $ft
pack $bot_frm.brc -side left -pady 10 -fill x
global gPB
set gPB(custom_command_paste_buffer) ""
set t  $Page::($page_obj,text_widget)
if { [winfo exists $t.pop] } {
 set menu $t.pop
 } else {
 set menu [menu $t.pop -tearoff 0 -cursor ""]
}
bind $t <3> "_cmd_AddPopUpMenu $t $menu %X %Y"
bind $t <KeyPress> "_cmd_ChangeTabKey $t %K"
if { [info exists Page::($page_obj,cmd_mode)] && \
 [string match "Condition" $Page::($page_obj,cmd_mode)] } {
 if { [info exists gPB(condition_cmd_description)] } {
  foreach line_text $gPB(condition_cmd_description) {
   $t insert insert "$line_text\n"
  }
 }
}
focus $text_widget
}

#=======================================================================
proc _cmd_ChangeTabKey { w key } {
  if { ![string match "Tab" $key] } { return }
  $w insert insert "    "
  return -code break
 }

#=======================================================================
proc _cmd_ExternalEditor { t } {
  global env gPB
  if { ![info exists env(EDITOR)] || [string match "" [string trim $env(EDITOR)]] } {
   UI_PB_chelp__display_msg "$gPB(msg,external_editor)" "$gPB(msg,set_ext_editor)"
   return
  }
  if { [__cmd_IsSystemVNCCmd] } {
   set msg $gPB(isv,ex_editor,warning,Msg)
   tk_messageBox -message $msg -type ok -parent $::gPB(main_window) -icon warning
  }
  set temp_file "$env(LOGNAME)_pb_temp_[clock clicks].tcl"
  set curr_text [$t get 0.1 end]
  set fid [open $env(TEMP)\\$temp_file w]
  set curr_text [string range $curr_text 0 [expr [string length $curr_text] - 2]]
  puts $fid $curr_text
  close $fid
  set edit_ok 1
  if { [catch {exec $env(EDITOR) $env(TEMP)\\$temp_file} result] } {
   tk_messageBox -message "$gPB(msg,error): $result" \
   -parent $::gPB(main_window) \
   -icon error
   set edit_ok 0
  }
  update
  if { [__cmd_IsSystemVNCCmd] } {
   file delete -force $env(TEMP)\\$temp_file
   return
  }
  if { $edit_ok } {
   set fid [open $env(TEMP)\\$temp_file r]
   set temp_text ""
   while { [gets $fid line] >= 0 } {
    if { ![eof $fid] } {
     set temp_text "$temp_text$line\n"
    }
   }
   close $fid
   set temp_text [string range $temp_text 0 [expr [string length $temp_text] - 2]]
   if { [string compare $temp_text $curr_text] } {
    set answer [tk_messageBox -message "$gPB(msg,save_change)" -type okcancel\
    -parent $::gPB(main_window) -icon question]
    if { [string match "ok" $answer] } {
     $t delete 0.1 end
     $t insert end $temp_text
     UI_PB_com_HighlightTclKeywords $t
    }
   }
  }
  file delete -force $env(TEMP)\\$temp_file
 }

#=======================================================================
proc _cmd_AddPopUpMenu { t menu x y } {
  global gPB
  set sel_buffer ""
  catch { set sel_buffer [$t get sel.first sel.last] }
  set gPB(custom_command_selection_buffer) $sel_buffer
  if { [$menu index end] == "none" } {
   $menu add command -label "$gPB(nav_button,cut,Label)"   -command "_cmd_CutText $t"
   $menu add command -label "$gPB(nav_button,copy,Label)"  -command "_cmd_CopyText"
   $menu add command -label "$gPB(nav_button,paste,Label)" -command "_cmd_PasteText $t"
   if 0 {
    if { [string match $::tcl_platform(platform) "windows"] } {
     if { [info exists ::env(PB_EDITOR)] } {
      $menu add separator
      $menu add command -label "External Editor" -command "_cmd_ExternalEditor $t"
     }
    }
    } else {
    global tcl_platform env
    if { [string match "windows" $tcl_platform(platform)] } {
     $menu add separator
     $menu add command -label "$gPB(nav_button,ex_editor,Label)" \
     -command "_cmd_ExternalEditor $t"
    }
   }
  }
  if { ![catch {set sel [selection get -selection CLIPBOARD -type STRING]} ] } {
   set gPB(custom_command_paste_buffer) $sel
  }
  if { $gPB(custom_command_paste_buffer) != "" } {
   $menu entryconfig 2 -state normal
   } else {
   $menu entryconfig 2 -state disabled
  }
  if { $sel_buffer != "" } {
   $menu entryconfig 0 -state normal
   $menu entryconfig 1 -state normal
   } else {
   $menu entryconfig 0 -state disabled
   $menu entryconfig 1 -state disabled
  }
  if { [__cmd_IsSystemVNCCmd] } {
   $menu entryconfig 0 -state disabled
   $menu entryconfig 2 -state disabled
  }
  tk_popup $menu $x $y
 }

#=======================================================================
proc _cmd_CutText { t args } {
  $t delete sel.first sel.last
  _cmd_CopyText
 }

#=======================================================================
proc _cmd_CopyText { args } {
  global gPB
  clipboard clear
  clipboard append -type STRING -- $gPB(custom_command_selection_buffer)
 }

#=======================================================================
proc _cmd_PasteText { t args } {
  global gPB
  set sel_buffer ""
  catch { set sel_buffer [$t get sel.first sel.last] }
  if { $sel_buffer != "" } {
   $t delete sel.first sel.last
  }
  $t insert insert "$gPB(custom_command_paste_buffer)"
 }

#=======================================================================
proc UI_PB_cmd_UpdateCmdName { page_obj } {
  global pb_cmd_procname
  set page_name $Page::($page_obj,page_name)
  if { [string match "cod" $page_name ] } {
   set tag 1
   } else {
   set tag 0
  }
  if { [info exists Page::($page_obj,active_cmd_obj)] } \
  {
   set cmd_obj $Page::($page_obj,active_cmd_obj)
   set tree $Page::($page_obj,tree)
   set HLIST [$tree subwidget hlist]
   set ent [$HLIST info selection]
   if { $ent == "" } { return }
   if { $tag } {
    set cur_cmd_name PB_CMD_vnc__${pb_cmd_procname}
    } else {
    set cur_cmd_name PB_CMD_${pb_cmd_procname}
   }
   if { [__cmd_DenyCmdName $cur_cmd_name $page_obj $ent] } { return UI_PB_ERROR }
   set ret_code [PB_int_CheckForCmdBlk cmd_obj cur_cmd_name]
   if { $ret_code  == 1 } \
   {
    return [ UI_PB_cmd_DenyCmdRename $ret_code $page_obj $ent ]
    } elseif { $cur_cmd_name != $command::($cmd_obj,name) } \
   {
    PB_int_RemoveCmdProcFromList cmd_obj
    set command::($cmd_obj,name) $cur_cmd_name
    PB_int_UpdateCommandAdd cmd_obj
    $HLIST entryconfigure $ent -text "$cur_cmd_name"
   }
  }
 }

#=======================================================================
proc __cmd_IsSystemVNCCmd { } {
  global pb_cmd_procname
  set vnc_syscmd_list [list "PB_CMD_vnc____map_machine_tool_axes" \
  "PB_CMD_vnc____set_nc_definitions" \
  "PB_CMD_vnc__set_nc_definitions" \
  "PB_CMD_vnc__init_isv_qc" \
  "PB_CMD_vnc____process_nc_block" \
  "PB_CMD_vnc__process_nc_block"]
  if { [lsearch $vnc_syscmd_list PB_CMD_vnc__$pb_cmd_procname] >= 0 } {
   return 1
   } else {
   return 0
  }
 }

#=======================================================================
proc UI_PB_cmd_DisplayCmdProc { CMD_OBJ PAGE_OBJ } {
  upvar $CMD_OBJ cmd_obj
  upvar $PAGE_OBJ page_obj
  global pb_cmd_procname
  global gPB
  set page_name $Page::($page_obj,page_name)
  if { [string match "cod" $page_name] } {
   set tag 1
   } else {
   set tag 0
  }
  set text_wdg $Page::($page_obj,text_widget)
  UI_PB_cmd_DeleteCmdProc $page_obj
  if { $tag } {
   set len [string length "PB_CMD_vnc__"]
   } else {
   if { [string match "PB_CMD_vnc__*" $command::($cmd_obj,name)] } {
    set len [string length "PB_CMD_vnc__"]
    } else {
    set len [string length "PB_CMD_"]

#=======================================================================
$Page::($page_obj,canvas_frame).top.prc config -text " proc    PB_CMD_"
 if { [string match "$::gPB(condition_cmd_prefix)*" $command::($cmd_obj,name)] } {
  set len [string length "$::gPB(condition_cmd_prefix)"]

#=======================================================================
$Page::($page_obj,canvas_frame).top.prc config -text " proc    $::gPB(condition_cmd_prefix)"
 } elseif { [string match "$::gPB(check_block_cmd_prefix)*" $command::($cmd_obj,name)] } {
 set len [string length "$::gPB(check_block_cmd_prefix)"]

#=======================================================================
$Page::($page_obj,canvas_frame).top.prc config -text " proc    $::gPB(check_block_cmd_prefix)"
}
}
}
set pb_cmd_procname [string range $command::($cmd_obj,name) $len end]
set fill_default_body 0
if { [string match "$::gPB(condition_cmd_prefix)*" $command::($cmd_obj,name)] } {
if { [llength $command::($cmd_obj,proc)] == 0 } {  ;# Fill in default content when body is empty,
set fill_default_body 1
}
UI_PB_debug_ForceMsg "\n+++ condition command : $command::($cmd_obj,name)  => pb_cmd_procname : $pb_cmd_procname \n"
} elseif { [string match "$::gPB(check_block_cmd_prefix)*" $command::($cmd_obj,name)] } {
if { [llength $command::($cmd_obj,proc)] == 0 } {  ;# Fill in default content when body is empty,
set fill_default_body 1
}
UI_PB_debug_ForceMsg "\n+++ check_block command : $command::($cmd_obj,name)  => pb_cmd_procname : $pb_cmd_procname \n"
}
if { $fill_default_body } {
if { [info exists gPB(condition_cmd_description)] } {
foreach line_text $gPB(condition_cmd_description) {
 $text_wdg insert insert "$line_text\n"
}
}
}
set sens [lindex [$text_wdg config -state] end]
$text_wdg config -state normal
set count 1
set no_lines [llength $command::($cmd_obj,proc)]
foreach line $command::($cmd_obj,proc) \
{
$text_wdg insert end $line
if { $count < $no_lines } \
{
$text_wdg insert end \n
}
incr count
}
if { [__cmd_IsSystemVNCCmd] } {
$text_wdg config -state disabled -bg lightGoldenRod1
} else {
if { [info exists Page::($page_obj,text_widget_bg)] } {
set bg_color $Page::($page_obj,text_widget_bg)
} else {
set bg_color $::SystemWindow ;#<03-26-08 gsl> was SystemWindow
}
$text_wdg config -state $sens -bg $bg_color
}
if { [PB_file_is_JE_POST_DEV] } {
set gPB(VIEW_ADDRESS) 0
if { $command::($cmd_obj,is_dummy) } {
$text_wdg config -state disabled -bg lightGoldenRod1
set gPB(VIEW_ADDRESS) 1
}
}
if { [info exists Page::($page_obj,cmd_entry)] } {
set ent_wdg  $Page::($page_obj,cmd_entry)
set ent_flag $Page::($page_obj,entry_flag)
if { $ent_flag } \
{
if { !$tag } {
 global mom_sys_arr ;#<06-10-09 wbh>
 if { [string match "before_motion" $pb_cmd_procname] || \
 [string match "kin*" $pb_cmd_procname] } \
 {
  bind $ent_wdg <Return> ""
  $ent_wdg config -state disabled
  } elseif { [info exists mom_sys_arr(post_startblk)] && \
  [string match "PB_CMD_*" $mom_sys_arr(post_startblk)] && \
 [string match $pb_cmd_procname [string range $mom_sys_arr(post_startblk) 7 end]] } \
 {
  bind $ent_wdg <Return> ""
  $ent_wdg config -state disabled
 } else \
 {
  bind $ent_wdg <Return> ""
  $ent_wdg config -state normal
 }
 } else {
 bind $ent_wdg <Return> ""
 $ent_wdg config -state normal
}
if { [PB_file_is_JE_POST_DEV] } {
 if { $command::($cmd_obj,is_dummy) } {
  if { ![string match "PB_CMD_*" $command::($cmd_obj,name)] } {

#=======================================================================
[winfo parent $ent_wdg].prc config -text " proc    "
 set pb_cmd_procname $command::($cmd_obj,name)
}
bind $ent_wdg <Return> ""
$ent_wdg config -state disabled
}
}
} else \
{
$ent_wdg config -text "$pb_cmd_procname"
}
}
if { ![string compare $::tix_version 8.4] } {
UI_PB_com_HighlightTclKeywords $text_wdg
}
}

#=======================================================================
proc UI_PB_cmd_DisplayCmdProc-X { CMD_OBJ PAGE_OBJ } {
  upvar $CMD_OBJ cmd_obj
  upvar $PAGE_OBJ page_obj
  global pb_cmd_procname
  global gPB
  if 0 {
   if { [string match "0.0" $Page::($page_obj,selected_index)] } {
    UI_PB_cmd_GetProcFromTextWin $page_obj proc_text
    catch { PB_proc_ValidateCustCmd $command::($cmd_obj,name) $proc_body err_msg }
   }
  }
  set page_name $Page::($page_obj,page_name)
  if { [string match "cod" $page_name] } {
   set tag 1
   } else {
   set tag 0
  }
  set text_wdg $Page::($page_obj,text_widget)
  UI_PB_cmd_DeleteCmdProc $page_obj
  if { $tag } {
   set len [string length "PB_CMD_vnc__"]
   set pb_cmd_procname [string range $command::($cmd_obj,name) $len end]
   } elseif { 0 && [info exists Page::($page_obj,cmd_mode)] && \
   [string match "Condition*" $Page::($page_obj,cmd_mode)] } {
   set len [string length "$gPB(check_block_cmd_prefix)"]
   set pb_cmd_procname [string range $command::($cmd_obj,name) $len end]
   UI_PB_debug_ForceMsg "\n+++ Conditional command : pb_cmd_procname : $pb_cmd_procname  $Page::($page_obj,cmd_mode)\n"
   } else {
   set proc_list [split $command::($cmd_obj,name) "_"]
   set proc_list [lrange $proc_list 2 end]
   set pb_cmd_procname [join $proc_list _]
   UI_PB_debug_ForceMsg "\n+++ PB_CMD command : $command::($cmd_obj,name) => pb_cmd_procname : $pb_cmd_procname\n"
  }
  if { $tag == 0 } {
   if { [string match "$::gPB(condition_cmd_prefix)*" $command::($cmd_obj,name)] } {
    set prefix [string range $::gPB(condition_cmd_prefix) 7 end]  ;# Sub-string after "PB_CMD_"
    if { [string match "${prefix}*" $pb_cmd_procname] } {
     set pb_cmd_procname [string range $pb_cmd_procname [string length $prefix] end]
    }
    } elseif { [string match "$::gPB(check_cmd_prefix)*" $command::($cmd_obj,name)] } {
    set prefix [string range $::gPB(check_cmd_prefix) 7 end]  ;# Sub-string after "PB_CMD_"
    if { [string match "${prefix}*" $pb_cmd_procname] } {
     set pb_cmd_procname [string range $pb_cmd_procname [string length $prefix] end]
    }
    } else {
   }
  }

#=======================================================================
$Page::($page_obj,canvas_frame).top.prc config -text " proc    PB_CMD_"
 if { ![info exists Page::($page_obj,cmd_mode)] } {
  if { [string match "$::gPB(condition_cmd_prefix)*" $command::($cmd_obj,name)] } {
   set prefix [string range $::gPB(condition_cmd_prefix) 7 end]  ;# Sub-string after "PB_CMD_"
   if { [string match "${prefix}*" $pb_cmd_procname] } {
    set pb_cmd_procname [string range $pb_cmd_procname [string length $prefix] end]
   }
   } elseif { [string match "$::gPB(check_cmd_prefix)*" $command::($cmd_obj,name)] } {
   set prefix [string range $::gPB(check_cmd_prefix) 7 end]  ;# Sub-string after "PB_CMD_"
   if { [string match "${prefix}*" $pb_cmd_procname] } {
    set pb_cmd_procname [string range $pb_cmd_procname [string length $prefix] end]
   }
  }
  } elseif { ![string match "Condition*" $Page::($page_obj,cmd_mode)] &&\
  [string match "$::gPB(condition_cmd_prefix)*" $command::($cmd_obj,name)] } {
  set prefix [string range $::gPB(condition_cmd_prefix) 7 end]  ;# Sub-string after "PB_CMD_"
  if { [string match "${prefix}*" $pb_cmd_procname] } {
   set pb_cmd_procname [string range $pb_cmd_procname [string length $prefix] end]
  }
 }
 set fill_default_body 0
 if { [string match "$::gPB(condition_cmd_prefix)*" $command::($cmd_obj,name)] } {

#=======================================================================
$Page::($page_obj,canvas_frame).top.prc config -text " proc    $::gPB(condition_cmd_prefix)"
 if { [llength $command::($cmd_obj,proc)] == 0 } {  ;# Fill in default content when body is empty,
  set fill_default_body 1
 }
 UI_PB_debug_ForceMsg "\n+++ condition command : $command::($cmd_obj,name)  => pb_cmd_procname : $pb_cmd_procname \n"
 } elseif { [string match "$::gPB(check_block_cmd_prefix)*" $command::($cmd_obj,name)] } {

#=======================================================================
$Page::($page_obj,canvas_frame).top.prc config -text " proc    $::gPB(check_block_cmd_prefix)"
 if { [llength $command::($cmd_obj,proc)] == 0 } {  ;# Fill in default content when body is empty,
  set fill_default_body 1
 }
 UI_PB_debug_ForceMsg "\n+++ check_block command : $command::($cmd_obj,name)  => pb_cmd_procname : $pb_cmd_procname \n"
}
if { $fill_default_body } {
 if { [info exists gPB(condition_cmd_description)] } {
  foreach line_text $gPB(condition_cmd_description) {
   $text_wdg insert insert "$line_text\n"
  }
 }
}
set sens [lindex [$text_wdg config -state] end]
$text_wdg config -state normal
set count 1
set no_lines [llength $command::($cmd_obj,proc)]
foreach line $command::($cmd_obj,proc) \
{
 $text_wdg insert end $line
 if { $count < $no_lines } \
 {
  $text_wdg insert end \n
 }
 incr count
}
if 0 {
 set vnc_syscmd_list [list "PB_CMD_vnc____map_machine_tool_axes" \
 "PB_CMD_vnc____set_nc_definitions" \
 "PB_CMD_vnc__set_nc_definitions" \
 "PB_CMD_vnc____process_nc_block" \
 "PB_CMD_vnc__process_nc_block"]
 if { [lsearch $vnc_syscmd_list $command::($cmd_obj,name)] >= 0 } {}
}
if { [__cmd_IsSystemVNCCmd] } {
 $text_wdg config -state disabled -bg lightGoldenRod1
 } else {
 if { [info exists Page::($page_obj,text_widget_bg)] } {
  set bg_color $Page::($page_obj,text_widget_bg)
  } else {
  set bg_color $::SystemWindow ;#<03-26-08 gsl> was SystemWindow
 }
 $text_wdg config -state $sens -bg $bg_color
}
if { [PB_file_is_JE_POST_DEV] } {
 set gPB(VIEW_ADDRESS) 0
 if { $command::($cmd_obj,is_dummy) } {
  $text_wdg config -state disabled -bg lightGoldenRod1
  set gPB(VIEW_ADDRESS) 1
 }
}
if { [info exists Page::($page_obj,cmd_entry)] } {
 set ent_wdg  $Page::($page_obj,cmd_entry)
 set ent_flag $Page::($page_obj,entry_flag)
 if { $ent_flag } \
 {
  if { !$tag } {
   global mom_sys_arr ;#<06-10-09 wbh>
   if { [string match "before_motion" $pb_cmd_procname] || \
   [string match "kin*" $pb_cmd_procname] } \
   {
    bind $ent_wdg <Return> ""
    $ent_wdg config -state disabled
    } elseif { [info exists mom_sys_arr(post_startblk)] && \
    [string match "PB_CMD_*" $mom_sys_arr(post_startblk)] && \
   [string match $pb_cmd_procname [string range $mom_sys_arr(post_startblk) 7 end]] } \
   {
    bind $ent_wdg <Return> ""
    $ent_wdg config -state disabled
   } else \
   {
    bind $ent_wdg <Return> ""
    $ent_wdg config -state normal
   }
   } else {
   bind $ent_wdg <Return> ""
   $ent_wdg config -state normal
  }
  if { [PB_file_is_JE_POST_DEV] } {
   if { $command::($cmd_obj,is_dummy) } {
    if { ![string match "PB_CMD_*" $command::($cmd_obj,name)] } {

#=======================================================================
[winfo parent $ent_wdg].prc config -text " proc    "
 set pb_cmd_procname $command::($cmd_obj,name)
}
bind $ent_wdg <Return> ""
$ent_wdg config -state disabled
}
}
} else \
{
$ent_wdg config -text "$pb_cmd_procname"
}
}
if { ![string compare $::tix_version 8.4] } {
UI_PB_com_HighlightTclKeywords $text_wdg
}
}

#=======================================================================
proc UI_PB_cmd_SeqEditCmdBlkCancel_CB { win page_obj seq_obj event_obj \
  elem_obj cmd_page_obj } {
  global paOption
  set block_obj $event_element::($elem_obj,block_obj)
  set bot_canvas $Page::($page_obj,bot_canvas)
  set blk_img_id $event_element::($elem_obj,icon_id)
  set img [lindex [$bot_canvas itemconfigure $blk_img_id -image] end]
  if { [UI_PB_evt_RetNoEvtElemsOfBlk block_obj] > 1 } \
  {
   $img config -relief raised -bg $paOption(text)
  } else \
  {
   $img config -relief raised -bg $paOption(special_fg)
  }
  destroy $win
  PB_com_DeleteObject $cmd_page_obj
 }

#=======================================================================
proc UI_PB_cmd_SeqEditCmdBlkOk_CB { win page_obj seq_obj elem_obj \
  cmd_page_obj } {
  global pb_cmd_procname
  set block_obj $event_element::($elem_obj,block_obj)
  set cmd_blk_elem [lindex $block::($block_obj,elem_addr_list) 0]
  set cmd_obj $block_element::($cmd_blk_elem,elem_mom_variable)
  if { [string match "$::gPB(condition_cmd_prefix)*" $command::($cmd_obj,name)] } {
   set cur_cmd_name "$::gPB(condition_cmd_prefix)$pb_cmd_procname"
   } elseif { [string match "$::gPB(check_block_cmd_prefix)*" $command::($cmd_obj,name)] } {
   set cur_cmd_name "$::gPB(check_block_cmd_prefix)$pb_cmd_procname"
   } else {
   set cur_cmd_name PB_CMD_$pb_cmd_procname
  }
  if { [__cmd_DenyCmdName $cur_cmd_name] } { return UI_PB_ERROR }
  set ret_code [PB_int_CheckForCmdBlk cmd_obj cur_cmd_name]
  if { $ret_code } \
  {
   return [UI_PB_cmd_DenyCmdRename $ret_code]
  }
  UI_PB_cmd_GetProcFromTextWin $cmd_page_obj proc_text
  if { ![_cmd_ValidateCmdLineOK $cmd_obj $proc_text] } {
   return
  }
  set prev_cmd_name $command::($cmd_obj,name)
  set command::($cmd_obj,proc) $proc_text
  UI_PB_cmd_UpdateCmdNameData cmd_page_obj
  if { $pb_cmd_procname != "$prev_cmd_name"} \
  {
   UI_PB_evt_CreateMenuOptions page_obj seq_obj
  }
  if 0 {
   if { [info exists ::gPB__comb_index] } {
    $Page::($page_obj,comb_widget) pick $::gPB__comb_index
   }
  }
  UI_PB_evt_DeleteSeqEvents page_obj seq_obj
  UI_PB_evt_CreateSeqAttributes page_obj
  destroy $win
  PB_com_DeleteObject $cmd_page_obj
 }

#=======================================================================
proc UI_PB_cmd_GetProcFromTextWin { page_obj CMD_PROC } {
  upvar $CMD_PROC cmd_proc
  set text_widget $Page::($page_obj,text_widget)
  scan [$text_widget index end] %d numlines

#=======================================================================
set cmd_proc ""
 for {set i 1} {$i < $numlines} {incr i} \
 {
  $text_widget mark set last $i.0
  set line_text [$text_widget get last "last lineend"]
  set line_trim_right [string trimright $line_text]
  UI_PB_com_RemoveTab "$line_trim_right" line_text

#=======================================================================
lappend cmd_proc $line_text
}
}

#=======================================================================
proc _cmd_ValidateCmdLineOK { cmd_obj proc_body } {
  global gPB
  set cmd_name $command::($cmd_obj,name)
  set proc_state [PB_proc_ValidateCustCmd $cmd_name $proc_body err_msg]
  if { $proc_state != 1 } {
   tk_messageBox -parent [ UI_PB_com_AskActiveWindow ] -type ok -icon error \
   -message "$err_msg" -title "$gPB(cust_cmd,error,title)"
   return 0
  }
  command::readvalue $cmd_obj cmd_attr
  set old_blk_list $cmd_attr(2)
  set old_add_list $cmd_attr(3)
  set old_fmt_list $cmd_attr(4)
  set cmd_attr(2) $gPB(CMD_BLK_LIST)
  set cmd_attr(3) $gPB(CMD_ADD_LIST)
  set cmd_attr(4) $gPB(CMD_FMT_LIST)
  command::setvalue $cmd_obj cmd_attr
  set err_msg ""
  set err_msg [ PB_file_ValidateDefElemsInCommand $cmd_obj ]
  if 0 {
   if { $err_msg != "" } {
    set res [tk_messageBox -parent [ UI_PB_com_AskActiveWindow ] \
    -type okcancel -icon question \
    -message "$err_msg\n\n\
    $gPB(msg,do_you_want_to_proceed)"]
    if { $res == "cancel" } {
     set cmd_attr(2) $old_blk_list
     set cmd_attr(3) $old_add_list
     set cmd_attr(4) $old_fmt_list
     command::setvalue $cmd_obj cmd_attr
     return 0
     } else {
     PB_file_AssumeUnknownDefElemsInProc
    }
   }
   if { $gPB(check_cc_unknown_command) } {
    global post_object
    if { [llength $Post::($post_object,unk_cmd_list)] } {
     set res [tk_messageBox -parent [ UI_PB_com_AskActiveWindow ] \
     -type okcancel -icon question \
     -message "$gPB(cust_cmd,cmd,msg) $Post::($post_object,unk_cmd_list)\n\n\
     $gPB(cust_cmd,referenced,msg) \"$command::($cmd_obj,name)\"\n\
     $gPB(cust_cmd,not_defined,msg)\n\n\
     $gPB(msg,do_you_want_to_proceed)"]
     if { $res == "cancel" } {
      return 0
      } else {
      PB_file_AssumeUnknownCommandsInProc
     }
    }
   }
  }
  set msg ""
  if { $gPB(check_cc_unknown_command) } {
   global post_object
   if { [llength $Post::($post_object,unk_cmd_list)] } {
    set msg "$gPB(cust_cmd,cmd,msg) $Post::($post_object,unk_cmd_list)\n\n\
    $gPB(cust_cmd,referenced,msg) \"$command::($cmd_obj,name)\"\n\
    $gPB(cust_cmd,not_defined,msg)"
   }
  }
  if { $err_msg != "" } {
   if { $msg != "" } {
    append err_msg "\n\n\n$msg"
   }
   } else {
   if { $msg != "" } {
    set err_msg "$msg"
   }
  }
  if { $err_msg != "" } {
   set res [tk_messageBox -parent [ UI_PB_com_AskActiveWindow ] \
   -type okcancel -icon question \
   -message "$err_msg \n\n\n\
   $gPB(msg,do_you_want_to_proceed)"]
   if { $res == "cancel" } {
    set cmd_attr(2) $old_blk_list
    set cmd_attr(3) $old_add_list
    set cmd_attr(4) $old_fmt_list
    command::setvalue $cmd_obj cmd_attr
    return 0
    } else {
    PB_file_AssumeUnknownDefElemsInProc
    PB_file_AssumeUnknownCommandsInProc
   }
  }
  return 1
 }

#=======================================================================
proc UI_PB_cmd_SaveCmdProc_ret_msg { page_obj ERR_MSG } {
  upvar $ERR_MSG err_msg
  if { ![info exists Page::($page_obj,active_cmd_obj)] } {
   return 0
  }
  set cmd_obj $Page::($page_obj,active_cmd_obj)
  UI_PB_cmd_GetProcFromTextWin $page_obj proc_text
  set res [UI_PB_cmd_ValidateCmdLineOK_ret_msg $cmd_obj $proc_text err_msg]
  if { $res == 0  ||  $res == -1 } {
   return $res
  }
  set command::($cmd_obj,proc) $proc_text
  return 1
 }

#=======================================================================
proc UI_PB_cmd_ValidateCmdLineOK_ret_msg { cmd_obj proc_body ERR_MSG args } {
  upvar $ERR_MSG err_msg
  global gPB
  set cmd_name $command::($cmd_obj,name)
  set proc_state [PB_proc_ValidateCustCmd $cmd_name $proc_body err_msg $args]
  if { $proc_state != 1 } {
   return $proc_state
  }
  if 0 {
   if { [info exists gPB(CMD_BLK_LIST)] } {
    set command::($cmd_obj,blk_list) $gPB(CMD_BLK_LIST)
    set err_msg [PB_file_ValidateDefElemsInCommand $cmd_obj]
    if { $err_msg != "" } {
     append err_msg "\n$gPB(msg,do_you_want_to_proceed)"
     return -1 ;# Warning
    }
   }
  }
  if { [info exists gPB(CMD_BLK_LIST)] } {
   set command::($cmd_obj,blk_list) $gPB(CMD_BLK_LIST)
  }
  command::readvalue $cmd_obj cmd_attr
  set old_blk_list $cmd_attr(2)
  set old_add_list $cmd_attr(3)
  set old_fmt_list $cmd_attr(4)
  set cmd_attr(2) $gPB(CMD_BLK_LIST)
  set cmd_attr(3) $gPB(CMD_ADD_LIST)
  set cmd_attr(4) $gPB(CMD_FMT_LIST)
  command::setvalue $cmd_obj cmd_attr
  set err_msg [PB_file_ValidateDefElemsInCommand $cmd_obj]
  if { $err_msg != "" } {
   set cmd_attr(2) $old_blk_list
   set cmd_attr(3) $old_add_list
   set cmd_attr(4) $old_fmt_list
   command::setvalue $cmd_obj cmd_attr
   set proc_state -1 ;# Warning
  }
  set msg ""
  if { $gPB(check_cc_unknown_command) } {
   global post_object
   if { [llength $Post::($post_object,unk_cmd_list)] } {
    set msg "$gPB(cust_cmd,cmd,msg) $Post::($post_object,unk_cmd_list)\n\n\
    $gPB(cust_cmd,referenced,msg) \"$command::($cmd_obj,name)\"\n\
    $gPB(cust_cmd,not_defined,msg)"
    set proc_state -1 ;# Warning
   }
  }
  if { $err_msg == "" } {
   if { $msg != "" } {
    append err_msg "$msg"
   }
   } else {
   if { $msg != "" } {
    append err_msg "\n\n\n$msg"
   }
  }
  if { $proc_state == -1 } {
   if { [llength $args] && [lindex $args 0] == "saving_post" } {
    } else {
    append err_msg "\n\n\n$gPB(msg,do_you_want_to_proceed)"
   }
   return $proc_state
  }
  return 1 ;# OK
 }

#=======================================================================
proc UI_PB_cmd_SeqNewCmdBlkOk_CB { win page_obj seq_obj elem_obj \
  cmd_page_obj } {
  global paOption
  global pb_cmd_procname
  global gPB
  set font $::gPB(nc_code_font)  ;# gPB(font_sm)
  set block_obj $event_element::($elem_obj,block_obj)
  set cmd_blk_elem [lindex $block::($block_obj,elem_addr_list) 0]
  set cmd_obj $block_element::($cmd_blk_elem,elem_mom_variable)
  if { [string match "$gPB(condition_cmd_prefix)*" $command::($cmd_obj,name)] } {
   set cur_cmd_name $gPB(condition_cmd_prefix)
   append cur_cmd_name $pb_cmd_procname
   } elseif { [string match "$gPB(check_block_cmd_prefix)*" $command::($cmd_obj,name)] } {
   set cur_cmd_name $gPB(check_block_cmd_prefix)
   append cur_cmd_name $pb_cmd_procname
   } else {
   set cur_cmd_name PB_CMD_$pb_cmd_procname
  }
  if { [__cmd_DenyCmdName $cur_cmd_name] } { return UI_PB_ERROR }
  set ret_code [PB_int_CheckForCmdBlk cmd_obj cur_cmd_name]
  if { $ret_code } \
  {
   return [UI_PB_cmd_DenyCmdRename $ret_code]
  }
  UI_PB_cmd_GetProcFromTextWin $cmd_page_obj proc_text
  if { ![_cmd_ValidateCmdLineOK $cmd_obj $proc_text] } {
   return
  }
  set block::($block_obj,block_name) $cur_cmd_name
  set command::($cmd_obj,name) $cur_cmd_name
  set command::($cmd_obj,proc) $proc_text
  command::readvalue $cmd_obj cmd_obj_attr
  command::DefaultValue $cmd_obj cmd_obj_attr
  set block_element::($cmd_blk_elem,elem_desc) \
  "$gPB(block,cmd,word_desc,Label)"
  if { [string match "$gPB(condition_cmd_prefix)*" $command::($cmd_obj,name)] } {
   set blk_nc_code "IF($command::($cmd_obj,name))"
   } else {
   set blk_nc_code $command::($cmd_obj,name)
  }
  UI_PB_com_TrunkNcCode blk_nc_code
  set elem_text $blk_nc_code
  set bot_canvas $Page::($page_obj,bot_canvas)
  set t_shift $Page::($page_obj,glob_text_shift)
  set elem_xc $event_element::($elem_obj,xc)
  set elem_yc $event_element::($elem_obj,yc)
  $bot_canvas delete $event_element::($elem_obj,text_id)
  set index [lsearch $sequence::($seq_obj,texticon_ids) \
  $event_element::($elem_obj,text_id)]
  set elem_icon_id [lindex $sequence::($seq_obj,texticon_ids) \
  [expr $index + 1]]
  set sequence::($seq_obj,texticon_ids) \
  [lreplace $sequence::($seq_obj,texticon_ids) $index \
  [expr $index + 1]]
  set elem_text_id [$bot_canvas create text [expr $elem_xc + $t_shift] \
  $elem_yc -text $elem_text -font $font -justify left \
  -tag blk_movable]
  set event_element::($elem_obj,text_id) $elem_text_id
  lappend sequence::($seq_obj,texticon_ids) $elem_text_id $elem_icon_id
  set blk_img_id $event_element::($elem_obj,icon_id)
  set img [lindex [$bot_canvas itemconfigure $blk_img_id -image] end]
  $img config -relief raised -bg $paOption(special_fg)
  PB_int_UpdateCommandAdd cmd_obj
  UI_PB_cmd_UpdateCmdNameData cmd_page_obj
  UI_PB_evt_CreateMenuOptions page_obj seq_obj
  if 0 {
   if { [info exists ::gPB__comb_index] } {
    $Page::($page_obj,comb_widget) pick $::gPB__comb_index
   }
  }
  destroy $win
  PB_com_DeleteObject $cmd_page_obj
 }

#=======================================================================
proc UI_PB_cmd_SeqNewCmdBlkCancel_CB { win page_obj seq_obj evt_obj elem_obj \
  cmd_page_obj } {
  set sequence::($seq_obj,drag_evt_obj) $evt_obj
  set sequence::($seq_obj,drag_blk_obj) $elem_obj
  set block_obj $event_element::($elem_obj,block_obj)
  set cmd_blk_elem [lindex $block::($block_obj,elem_addr_list) 0]
  set cmd_obj $block_element::($cmd_blk_elem,elem_mom_variable)
  UI_PB_evt_PutBlkInTrash page_obj seq_obj
  PB_int_DeleteCmdBlk cmd_obj
  unset sequence::($seq_obj,drag_blk_obj)
  unset sequence::($seq_obj,drag_evt_obj)
  destroy $win
  PB_com_DeleteObject $cmd_page_obj
 }

#=======================================================================
proc UI_PB_cmd_tpthEditCmdBlkCancel_CB { win page_obj blk_elem_obj \
  cmd_page_obj } {
  destroy $win
  PB_com_DeleteObject $cmd_page_obj
 }

#=======================================================================
proc UI_PB_cmd_tpthEditCmdBlkOk_CB { win page_obj cmd_blk_obj blk_elem_obj \
  cmd_page_obj } {
  global pb_cmd_procname
  set cmd_obj $block_element::($blk_elem_obj,elem_mom_variable)
  if { [string match "$::gPB(condition_cmd_prefix)*" $command::($cmd_obj,name)] } {
   set cur_cmd_name "$::gPB(condition_cmd_prefix)$pb_cmd_procname"
   } elseif { [string match "$::gPB(check_block_cmd_prefix)*" $command::($cmd_obj,name)] } {
   set cur_cmd_name "$::gPB(check_block_cmd_prefix)$pb_cmd_procname"
   } else {
   set cur_cmd_name PB_CMD_$pb_cmd_procname
  }
  if { [__cmd_DenyCmdName $cur_cmd_name] } { return UI_PB_ERROR }
  set ret_code [PB_int_CheckForCmdBlk cmd_obj cur_cmd_name]
  if { $ret_code } \
  {
   return [UI_PB_cmd_DenyCmdRename $ret_code]
  }
  UI_PB_cmd_GetProcFromTextWin $cmd_page_obj proc_text
  if { ![_cmd_ValidateCmdLineOK $cmd_obj $proc_text] } {
   return
  }
  set prev_cmd_name $command::($cmd_obj,name)
  set command::($cmd_obj,proc) $proc_text
  UI_PB_cmd_UpdateCmdNameData cmd_page_obj
  if { $prev_cmd_name != "$pb_cmd_procname" } \
  {
   UI_PB_blk_CreateMenuOptions page_obj event
   } else {
   if 1 {
    if { [info exists ::gPB__new_elem_mom_var] } {
     set Page::($page_obj,new_elem_mom_var) $::gPB__new_elem_mom_var
     set Page::($page_obj,comb_var)         $::gPB__comb_var
     set Page::($page_obj,sel_base_addr)    $::gPB__base_addr
    }
   }
  }
  set base_addr $block_element::($blk_elem_obj,elem_add_obj)
  UI_PB_blk_ReplaceIcon page_obj $base_addr $blk_elem_obj
  destroy $win
  PB_com_DeleteObject $cmd_page_obj
 }

#=======================================================================
proc UI_PB_cmd_tpthCmdBlkCancel_CB { win page_obj event_obj evt_elem_obj \
  blk_elem_obj cmd_page_obj } {
  set Page::($page_obj,source_blk_elem_obj) $blk_elem_obj
  set Page::($page_obj,source_evt_elem_obj) $evt_elem_obj
  destroy $win
  PB_com_DeleteObject $cmd_page_obj
  set cmd_obj $block_element::($blk_elem_obj,elem_mom_variable)
  UI_PB_tpth_PutBlockElemTrash page_obj event_obj
  PB_int_DeleteCmdBlk cmd_obj
  set Page::($page_obj,source_blk_elem_obj) 0
  set Page::($page_obj,source_evt_elem_obj) 0
 }

#=======================================================================
proc UI_PB_cmd_tpthCmdBlkOk_CB { win page_obj block_obj blk_elem_obj \
  cmd_page_obj } {
  global pb_cmd_procname
  global gPB
  set cmd_obj $block_element::($blk_elem_obj,elem_mom_variable)
  if { [string match "$gPB(condition_cmd_prefix)*" $command::($cmd_obj,name)] } {
   set cur_cmd_name $gPB(condition_cmd_prefix)
   append cur_cmd_name $pb_cmd_procname
   } elseif { [string match "$gPB(check_block_cmd_prefix)*" $command::($cmd_obj,name)] } {
   set cur_cmd_name $gPB(check_block_cmd_prefix)
   append cur_cmd_name $pb_cmd_procname
   } else {
   set cur_cmd_name PB_CMD_$pb_cmd_procname
  }
  if { [__cmd_DenyCmdName $cur_cmd_name] } { return UI_PB_ERROR }
  set ret_code [PB_int_CheckForCmdBlk cmd_obj cur_cmd_name]
  if { $ret_code } \
  {
   return [UI_PB_cmd_DenyCmdRename $ret_code]
  }
  UI_PB_cmd_GetProcFromTextWin $cmd_page_obj proc_text
  if { ![_cmd_ValidateCmdLineOK $cmd_obj $proc_text] } {
   return
  }
  set block::($block_obj,block_name) $cur_cmd_name
  set command::($cmd_obj,name) $cur_cmd_name
  set command::($cmd_obj,proc) $proc_text
  command::readvalue $cmd_obj cmd_obj_attr
  command::DefaultValue $cmd_obj cmd_obj_attr
  set block_element::($blk_elem_obj,elem_desc) \
  "$gPB(block,cmd,word_desc,Label)"
  PB_int_UpdateCommandAdd cmd_obj
  UI_PB_cmd_UpdateCmdNameData cmd_page_obj
  set base_addr $block_element::($blk_elem_obj,elem_mom_variable)
  UI_PB_blk_ReplaceIcon page_obj $base_addr $blk_elem_obj
  UI_PB_blk_CreateMenuOptions page_obj event
  if 0 {
   if { [info exists ::gPB__new_elem_mom_var] } {
    set Page::($page_obj,new_elem_mom_var) $::gPB__new_elem_mom_var
    set Page::($page_obj,comb_var)         $::gPB__comb_var
   }
  }
  destroy $win
  PB_com_DeleteObject $cmd_page_obj
 }

#=======================================================================
proc UI_PB_cmd_CreateCommentDlgParam { win page_obj block_obj blk_elem_obj } {
  global gPB
  global mom_sys_arr
  global pb_comment
  global paOption
  set bg $paOption(title_bg)
  set fg $paOption(special_fg)
  set pb_comment $block_element::($blk_elem_obj,elem_mom_variable)
  $win config -bg $bg
  set top_frm [frame $win.top -relief flat -bg $bg]
  pack $top_frm -side top -fill both -expand yes -padx 20
  label $top_frm.strt -text "$mom_sys_arr(Comment_Start)" -bg $bg -fg $fg
  entry $top_frm.ent -textvariable pb_comment -width 40 -relief flat -bd 0
  label $top_frm.end -text "$mom_sys_arr(Comment_End)" -bg $bg -fg $fg
  if { [string match "$::gPB(tcl_line_blk)*" $block::($block_obj,block_name)] } {
   $top_frm.strt config -text "# " ;#<Aug-10-2016 gsl> " "
   $top_frm.end  config -text " "
   $top_frm.ent  config -width 80
  }
  pack $top_frm.strt -padx 5 -pady 20 -anchor center -side left
  pack $top_frm.end -padx 5 -anchor center -side right
  pack $top_frm.ent -anchor center -expand yes -fill x
  block::RestoreValue $block_obj
  block_element::RestoreValue $blk_elem_obj
  focus $top_frm.ent
  set t $top_frm.ent
  set restore_cb "UI_PB_cmd_CommentRestore_CB $block_obj"
  bind $t <3> "UI_PB_blk_AddrExpPopup $t \"$restore_cb\" %X %Y"
 }

#=======================================================================
proc UI_PB_cmd_CommentRestore_CB { block_obj } {
  global pb_comment
  set blk_elem [lindex $block::($block_obj,elem_addr_list) 0]
  array set blk_elem_attr $block_element::($blk_elem,rest_value)
  set pb_comment $blk_elem_attr(1)
 }

#=======================================================================
proc UI_PB_cmd_SeqNewCommentCancel_CB { win page_obj seq_obj evt_obj \
  elem_obj } {
  set sequence::($seq_obj,drag_evt_obj) $evt_obj
  set sequence::($seq_obj,drag_blk_obj) $elem_obj
  set block_obj $event_element::($elem_obj,block_obj)
  UI_PB_evt_PutBlkInTrash page_obj seq_obj
  unset sequence::($seq_obj,drag_blk_obj)
  unset sequence::($seq_obj,drag_evt_obj)
  destroy $win
 }

#=======================================================================
proc UI_PB_cmd_SeqNewCommentOk_CB { win page_obj seq_obj elem_obj act_mode } {
  global paOption
  global pb_comment
  global mom_sys_arr
  global gPB
  set block_obj $event_element::($elem_obj,block_obj)
  set blk_elem [lindex $block::($block_obj,elem_addr_list) 0]
  if { 0 && $pb_comment == "" } \
  {
   tk_messageBox -parent [UI_PB_com_AskActiveWindow] -type ok -icon error \
   -message "$gPB(opr_msg,empty_operator)"
   return
  }
  if { ![UI_PB_cmd_ValidateExpOK "Operator Message" $pb_comment] } {
   return
   } else {
   set block::($block_obj,var_list) $gPB(CMD_VAR_LIST)
  }
  set font $::gPB(nc_code_font)  ;# gPB(font_sm)
  set block_element::($blk_elem,elem_mom_variable) $pb_comment
  set block_element::($blk_elem,elem_desc) "$gPB(block,oper,word_desc,Label)"
  if { $act_mode == "New" } \
  {
   block_element::readvalue $blk_elem blk_elem_attr
   block_element::DefaultValue $blk_elem blk_elem_attr
   unset blk_elem_attr
  }
  set blk_nc_code $pb_comment
  if { $mom_sys_arr(Comment_Start) != "" } \
  {
   append temp_text "$mom_sys_arr(Comment_Start)"
  }
  append temp_text "$blk_nc_code"
  if { $mom_sys_arr(Comment_End) != "" } \
  {
   append temp_text "$mom_sys_arr(Comment_End)"
  }
  if { $::gPB(comment_is_tcl) || [string match "$::gPB(tcl_line_blk)*" $block::($block_obj,block_name)] } {
   set temp_text "# $blk_nc_code" ;#<Aug-10-2016 gsl> "$blk_nc_code"
  }
  set blk_nc_code $temp_text
  unset temp_text
  UI_PB_com_TrunkNcCode blk_nc_code
  set elem_text $blk_nc_code
  set bot_canvas $Page::($page_obj,bot_canvas)
  set t_shift $Page::($page_obj,glob_text_shift)
  set elem_xc $event_element::($elem_obj,xc)
  set elem_yc $event_element::($elem_obj,yc)
  $bot_canvas delete $event_element::($elem_obj,text_id)
  set index [lsearch $sequence::($seq_obj,texticon_ids) \
  $event_element::($elem_obj,text_id)]
  set elem_icon_id [lindex $sequence::($seq_obj,texticon_ids) [expr $index + 1]]
  set sequence::($seq_obj,texticon_ids) \
  [lreplace $sequence::($seq_obj,texticon_ids) $index [expr $index + 1]]
  set elem_text_id [$bot_canvas create text [expr $elem_xc + $t_shift] \
  $elem_yc -text $elem_text -font $font -justify left -tag blk_movable]
  set event_element::($elem_obj,text_id) $elem_text_id
  lappend sequence::($seq_obj,texticon_ids) $elem_text_id $elem_icon_id
  set blk_img_id $event_element::($elem_obj,icon_id)
  set img [lindex [$bot_canvas itemconfigure $blk_img_id -image] end]
  $img config -relief raised -bg $paOption(special_fg)
  destroy $win
 }

#=======================================================================
proc UI_PB_cmd_ValidateExpOK { obj_name exp } {
  global gPB

#=======================================================================
proc Evaluating... { args } {}
 set iend [expr [string length $exp] - 1]
 if { [scan [string index $exp 0] %c n1] == 1  &&  [scan [string index $exp $iend] %c n2] == 1 } {
  if { $n1 == 34  &&  $n2 == 34 } {
   set exp [string range $exp 1 [expr [string length $exp] - 1]]
  }
 }
 lappend proc_data "Evaluating... \"$exp\""
 if { [PB_proc_ValidateCustCmd "$obj_name" $proc_data err_msg exp] != 1 } {
  if 0 {
   set i [string first "__UI_PB_Evaluating" $err_msg]
   if { $i > 0 } {
    set j [string wordend $err_msg $i]
    set s1 [string range $err_msg 0 [expr $i - 1]]
    set s2 [string range $err_msg [expr $j + 1] end]
    set err_msg "$s1$s2"
   }
  }
  tk_messageBox -parent [UI_PB_com_AskActiveWindow] -type ok -icon error \
  -message "$err_msg"
  return 0
 }
 set err_msg ""
 if { $gPB(check_cc_unknown_command) } {
  global post_object
  if { [llength $Post::($post_object,unk_cmd_list)] } {
   set err_msg "$gPB(cust_cmd,cmd,msg) $Post::($post_object,unk_cmd_list) \n\
   $gPB(cust_cmd,not_defined,msg)"
  }
 }
 if { $err_msg != "" } {
  set res [tk_messageBox -parent [ UI_PB_com_AskActiveWindow ] \
  -type okcancel -icon question \
  -message "$err_msg \n\n\
  $gPB(msg,do_you_want_to_proceed)"]
  if { $res == "cancel" } {
   return 0
   } else {
   PB_file_AssumeUnknownCommandsInProc
  }
 }
 return 1
}

#=======================================================================
proc UI_PB_cmd_SeqEditCommentCancel_CB { win page_obj seq_obj event_obj \
  elem_obj } {
  global paOption
  set block_obj $event_element::($elem_obj,block_obj)
  set bot_canvas $Page::($page_obj,bot_canvas)
  set blk_img_id $event_element::($elem_obj,icon_id)
  set img [lindex [$bot_canvas itemconfigure $blk_img_id -image] end]
  $img config -relief raised -bg $paOption(special_fg)
  destroy $win
 }

#=======================================================================
proc UI_PB_cmd_tpthCommentCancel_CB { win page_obj event_obj evt_elem_obj \
  blk_elem_obj } {
  set Page::($page_obj,source_blk_elem_obj) $blk_elem_obj
  set Page::($page_obj,source_evt_elem_obj) $evt_elem_obj
  destroy $win
  UI_PB_tpth_PutBlockElemTrash page_obj event_obj
  set Page::($page_obj,source_blk_elem_obj) 0
  set Page::($page_obj,source_evt_elem_obj) 0
 }

#=======================================================================
proc UI_PB_cmd_tpthNewCommentOk_CB { win page_obj evt_elem_obj blk_elem_obj } {
  global pb_comment
  if { 0 && $pb_comment == "" } \
  {
   tk_messageBox -parent [UI_PB_com_AskActiveWindow] -type ok -icon error \
   -message "$::gPB(opr_msg,empty_operator)"
   return
  }
  set block_element::($blk_elem_obj,elem_mom_variable) "$pb_comment"
  set block_obj $event_element::($evt_elem_obj,block_obj)
  if { [string match "$::gPB(tcl_line_blk)*" $block::($block_obj,block_name)] } {
   set desc $::gPB(event,combo,tcl_line,Label)
   } else {
   set desc $::gPB(block,oper,word_desc,Label)
  }
  set block_element::($blk_elem_obj,elem_desc) "$desc"
  block_element::readvalue $blk_elem_obj blk_elem_attr
  block_element::DefaultValue $blk_elem_obj blk_elem_attr
  unset blk_elem_attr
  set base_addr $block_element::($blk_elem_obj,elem_add_obj)
  UI_PB_blk_ReplaceIcon page_obj $base_addr $blk_elem_obj
  destroy $win
 }

#=======================================================================
proc UI_PB_cmd_tpthEditCommentOk_CB { win page_obj block_obj blk_elem_obj } {
  global pb_comment
  global gPB
  if { 0 && $pb_comment == "" } \
  {
   tk_messageBox -parent [UI_PB_com_AskActiveWindow] -type ok -icon error \
   -message "$gPB(opr_msg,empty_operator)"
   return
  }
  set block_element::($blk_elem_obj,elem_mom_variable) "$pb_comment"
  set base_addr $block_element::($blk_elem_obj,elem_add_obj)
  UI_PB_blk_ReplaceIcon page_obj $base_addr $blk_elem_obj
  destroy $win
 }

#=======================================================================
proc UI_PB_cmd_GetCmdStateList { state_type CMD_LIST } {
  upvar $CMD_LIST cmd_list
  global gPB mom_sys_arr
  set cmd_list [list]
  set opt_index 0
  switch $state_type \
  {
   "name"   { set opt_index 0 }
   "attach" { set opt_index 1 }
   "rename" { set opt_index 2 }
   "delete" { set opt_index 3 }
   default  { set opt_index -1 }
  }
  if { $opt_index < 0 } { return }
  if { ![info exists gPB(special_cmd_state_list)] } \
  {
   set gPB(special_cmd_state_list) [list]
  }
  foreach cmd_state $gPB(special_cmd_state_list) \
  {
   set cmd_name [lindex $cmd_state 0]
   if { $opt_index > 0 } \
   {
    if 0 { ;# Not quite working
     set sta [lindex $cmd_state $opt_index]
     if { $sta != 0 && $sta != 1 } {
      set sta $mom_sys_arr(\$${sta})
      if { $sta } { set sta 1 } else { set sta 0 }
     }
    }
    if { [lindex $cmd_state $opt_index] == 0 } {
     lappend cmd_list $cmd_name
    }
   } else \
   {
    lappend cmd_list [lindex $cmd_state $opt_index]
   }
  }
  if { [info exists mom_sys_arr(post_startblk)] } \
  {
   lappend cmd_list $mom_sys_arr(post_startblk)
  }
 }

#=======================================================================
proc UI_PB_cmd_CheckCmdState { cmd_name state_type } {
  global gPB mom_sys_arr
  set opt_index 0
  switch $state_type \
  {
   "attach" { set opt_index 1 }
   "rename" { set opt_index 2 }
   "delete" { set opt_index 3 }
  }
  if { $opt_index == 0 } { return 1 }
  if { [info exists mom_sys_arr(post_startblk)] && \
  [string match $cmd_name $mom_sys_arr(post_startblk)] } \
  {
   return 0
  }
  if { ![info exists gPB(special_cmd_state_list)] } {
   return 1
  }
  if { ![string match "*$cmd_name*" $gPB(special_cmd_state_list)] } { return 1 }
  if { $state_type == "delete" } {
   if { [__cmd_IsActiveTurboPostCommand $cmd_name] } {
    return 0
   }
  }
  foreach cmd_state $gPB(special_cmd_state_list) \
  {
   set temp_name [lindex $cmd_state 0]
   if 1 {
    if { [string match $cmd_name $temp_name] } \
    {
     return [lindex $cmd_state $opt_index]
    }
    } else {
    if { [string match "$temp_name*" $cmd_name] } \
    {
     return [lindex $cmd_state $opt_index]
     if 0 { ;# Not quite working
      set sta [lindex $cmd_state $opt_index]
      if { $sta != 0 && $sta != 1 } {
       set sta $mom_sys_arr(\$${sta})
       if { $sta } { set sta 1 } else { set sta 0 }
      }
      return $sta
     }
    }
   }
  }
  return 1
 }

#=======================================================================
proc __cmd_IsActiveTurboPostCommand { cmd } {
  if { ![string match "$::gPB(ATP_cmd_prefix)*" $cmd] } {
   return 0
  }
  if { [info exists ::mom_sys_arr(\$mom_sys_advanced_turbo_output)] &&\
   $::mom_sys_arr(\$mom_sys_advanced_turbo_output) } {
   set elem_list [array names ::gPB "ATP,*"]
   foreach elem $elem_list {
    if { [string match $::gPB($elem) $cmd] } {
     return 1
    }
   }
  }
  return 0
 }

#=======================================================================
proc UI_PB_cmd_tpthCondCmdBlkOk_CB { win page_obj evt_elem_obj \
  cmd_obj cmd_page_obj } {
  global pb_cmd_procname
  global gPB
  set cur_cmd_name $gPB(check_block_cmd_prefix)
  append cur_cmd_name "$pb_cmd_procname"
  if { $pb_cmd_procname == "" } {
   tk_messageBox -parent [UI_PB_com_AskActiveWindow] -type ok -icon error \
   -message "$gPB(cust_cmd,name_msg)"
   return
  }
  if { [string compare $cur_cmd_name $command::($cmd_obj,name)] != 0 } {
   set new_obj [PB_com_FindObjFrmName $cur_cmd_name "command"]
   if { $new_obj > 0 } {
    tk_messageBox -parent [UI_PB_com_AskActiveWindow] -type ok -icon error \
    -message "\"$cur_cmd_name\" $gPB(msg,name_exists)"
    return
   }
  }
  UI_PB_cmd_GetProcFromTextWin $cmd_page_obj proc_text
  if { ![_cmd_ValidateCmdLineOK $cmd_obj $proc_text] } {
   return
  }
  set command::($cmd_obj,name) $cur_cmd_name
  set command::($cmd_obj,proc) $proc_text
  command::readvalue $cmd_obj cmd_obj_attr
  command::DefaultValue $cmd_obj cmd_obj_attr
  PB_int_UpdateCommandAdd cmd_obj
  UI_PB_cmd_UpdateCmdNameData cmd_page_obj
  set event_element::($evt_elem_obj,exec_condition_obj) $cmd_obj
  destroy $win
  PB_com_DeleteObject $cmd_page_obj
  if { ![info exists Page::($page_obj,page_type)] } {
   set pb_cmd_procname $cur_cmd_name
   } else {
   if { [string match "seq" $Page::($page_obj,page_type)] } {
    set command::($cmd_obj,condition_flag) 1
    UI_PB_evt_ReplaceExecAttrSymbols page_obj evt_elem_obj "cond"
    } elseif { [string match "event" $Page::($page_obj,page_type)] } {
    UI_PB_tpth_ReplaceExecAttrSymbols page_obj evt_elem_obj "cond"
   }
   unset Page::($page_obj,page_type)
  }
 }

#=======================================================================
proc UI_PB_cmd_tpthCondCmdBlkCancel_CB { win page_obj cmd_obj cmd_page_obj } {
  if { [string match "Condition" $Page::($cmd_page_obj,cmd_mode)] } {
   PB_int_DeleteCmdBlk cmd_obj
  }
  destroy $win
  PB_com_DeleteObject $cmd_page_obj
  if { [info exists Page::($page_obj,page_type)] } {
   unset Page::($page_obj,page_type)
  }
 }