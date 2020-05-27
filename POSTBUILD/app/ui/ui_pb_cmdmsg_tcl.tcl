set gPB(pb_cmd_icon) [tix getimage pb_cmd]

#=======================================================================
proc UI_PB_ProgTpth_CustomCmd { book_id cmd_page_obj } {
  global pb_cmd_procname
  set Page::($cmd_page_obj,page_id) [$book_id subwidget \
  $Page::($cmd_page_obj,page_name)]
  if [info exists Page::($cmd_page_obj,active_cmd_obj)] \
  { unset Page::($cmd_page_obj,active_cmd_obj) }
  Page::CreatePane $cmd_page_obj
  UI_PB_cmd_AddComponentsLeftPan cmd_page_obj
  Page::CreateTree $cmd_page_obj
  UI_PB_cmd_CreateTreePopup cmd_page_obj
  UI_PB_cmd_CreateTreeElements cmd_page_obj
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
  set proc_list [split $rest_cmd_attr(0) "_"]
  set proc_list [lrange $proc_list 2 end]
  set pb_cmd_procname [join $proc_list _]
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
  set proc_list [split $def_cmd_attr(0) "_"]
  set proc_list [lrange $proc_list 2 end]
  set pb_cmd_procname [join $proc_list _]
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
  if { ![info exists Page::($page_obj,active_cmd_obj)] } { return 0}
  set cmd_obj $Page::($page_obj,active_cmd_obj)
  UI_PB_cmd_GetProcFromTextWin $page_obj proc_text
  if { [llength $args] == 0 } {
   if { ![__cmd_ValidateCmdLineOK $cmd_obj $proc_text] } {
    return 0
   }
   } elseif { [lindex $args 0] != "not_verify" } {
   if { ![__cmd_ValidateCmdLineOK $cmd_obj $proc_text] } {
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
  -browsecmd "UI_PB_cmd_CmdBlkItemSelection $page_obj"
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
  if { [string compare $cursor_entry "0"] != 0 } \
  {
   UI_PB_cmd_CmdBlkItemSelection $page_obj $cursor_entry
  }
  set popup $Page::($page_obj,tree_popup)
  set active_index [$h info selection]
  if { $x >= [expr $indent * 2] && \
   $Page::($page_obj,double_click_flag) == 0 && \
  $active_index == $cursor_entry } \
  {
   $popup delete 0 end
   set indx_string [$h entrycget $active_index -text]
   if { [string match "PB_CMD_before_motion" $indx_string] || \
   [string match "PB_CMD_kin_*" $indx_string] } \
   {
    $popup add command -label "$gPB(tree,rename,Label)" -state disabled \
    -command ""
   } else \
   {
    $popup add command -label "$gPB(tree,rename,Label)" -state normal \
    -command "UI_PB_cmd_EditCmdName $page_obj $active_index"
   }
   $popup add sep
   if { [string match "PB_CMD_before_motion" $indx_string] || \
   [string match "PB_CMD_kin_*" $indx_string] } \
   {
    $popup add command -label "$gPB(tree,create,Label)" -state disabled -command ""
    } else {
    $popup add command -label "$gPB(tree,create,Label)" -state normal \
    -command "UI_PB_cmd_CreateACmdBlock $page_obj"
   }
   if { [string match "PB_CMD_before_motion" $indx_string] || \
   [string match "PB_CMD_kin_*" $indx_string] } \
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
  set HLIST [$tree subwidget hlist]
  set active_index [$HLIST info selection]
  set indx_string [$HLIST entrycget $active_index -text]
  if { [string match "PB_CMD_before_motion" $indx_string] || \
  [string match "PB_CMD_kin_*" $indx_string] } \
  {
   return
  }
  $HLIST delete entry $index
  set col [string range $index 2 [string length $index]]
  if { [winfo exists $HLIST.cmd] != 1 } \
  {
   set new_frm [frame $HLIST.cmd -bg $paOption(tree_bg)]
   label $new_frm.lbl -text " " -bg $paOption(tree_bg)
   set img_id [image create compound -window $new_frm.lbl]
   $img_id add image -image $gPB(pb_cmd_icon)
   $new_frm.lbl config -image $img_id
   unset img_id
   pack $new_frm.lbl -side left
   label $new_frm.pb -text " PB_CMD_" -bg $paOption(tree_bg)
   pack $new_frm.pb -side left
   entry $new_frm.ent -bd 1 -relief solid -state normal \
   -textvariable pb_cmd_procname
   pack $new_frm.ent -side left -padx 2
  } else \
  {
   set new_frm $HLIST.cmd
  }
  set wid [string length $pb_cmd_procname]
  if { $wid < $gPB(MOM_obj_name_len) } { set wid $gPB(MOM_obj_name_len) }
  $new_frm.ent config -width $wid
  focus $new_frm.ent
  $HLIST add $index -itemtype window -window $new_frm -at $col
  bind $new_frm.ent <Return> "UI_PB_cmd_UpdateCmdEntry $page_obj $index"
  bind $new_frm.ent <KeyPress> "UI_PB_com_DisableKeysForProc %W %K"
  bind $new_frm.ent <KeyRelease> { %W config -state normal }
  __cmd_RestoreNamePopup $new_frm.ent $page_obj
  $new_frm.ent selection range 0 end
  $new_frm.ent icursor end
  set Page::($page_obj,double_click_flag) 1
  set Page::($page_obj,rename_index) $index
  $HLIST entryconfig $index -state disabled
  grab $Page::($page_obj,page_id)
 }

#=======================================================================
proc __cmd_RestoreNamePopup { w page_obj } {
  global gPB
  global pb_cmd_procname
  if { ![winfo exists $w.pop] } {
   menu $w.pop -tearoff 0
   $w.pop add command -label "$gPB(nav_button,restore,Label)"
  }
  set active_cmd $Page::($page_obj,active_cmd_obj)
  set str [string range $command::($active_cmd,name) 7 end]
  $w.pop entryconfig 0 -command "set pb_cmd_procname $str;\
  $w icursor end"
  bind $w <3> "tk_popup $w.pop %X %Y"
 }

#=======================================================================
proc __cmd_DenyCmdName  { name args } {
  if [string match "PB_CMD_kin_*" $name] {
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
  if { ![info exists Page::($page_obj,rename_index)] } { return }
  if { ![info exists Page::($page_obj,active_cmd_obj)] } { return }
  set tree $Page::($page_obj,tree)
  set HLIST [$tree subwidget hlist]
  set style $gPB(font_style_normal)
  set file   $gPB(pb_cmd_icon)
  set active_cmd $Page::($page_obj,active_cmd_obj)
  set cur_cmd_name PB_CMD_${pb_cmd_procname}
  if [__cmd_DenyCmdName $cur_cmd_name $page_obj $index] {return UI_PB_ERROR}
  set ret_code [PB_int_CheckForCmdBlk active_cmd cur_cmd_name]
  if {$ret_code == 0} \
  {
   set col [string range $index 2 [string length $index]]
   $HLIST delete entry $index
   $HLIST add $index -itemtype imagetext -text "$cur_cmd_name" \
   -image $file -style $style -at $col
   $HLIST selection set $index
   $HLIST anchor set $index
   set Page::($page_obj,double_click_flag) 0
   $Page::($page_obj,cmd_entry) config -text "$pb_cmd_procname"
  } else \
  {
   return [ UI_PB_cmd_DenyCmdRename $ret_code $page_obj $index ]
  }
  UI_PB_cmd_UpdateCmdNameData page_obj
  grab release $Page::($page_obj,page_id)
  unset Page::($page_obj,rename_index)
 }

#=======================================================================
proc UI_PB_cmd_DenyCmdRename { error_no args } {
  global gPB
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
  global pb_cmd_procname
  set cur_cmd_name "PB_CMD_${pb_cmd_procname}"
  switch $error_no {
   1 {
    tk_messageBox -parent [UI_PB_com_AskActiveWindow] -type ok -icon error \
    -message "\"$cur_cmd_name\" $gPB(msg,name_exists)"
   }
   2 {
    tk_messageBox -parent [UI_PB_com_AskActiveWindow] -type ok -icon error \
    -message "$gPB(cust_cmd,name_msg)"
   }
  }
  return UI_PB_ERROR
 }

#=======================================================================
proc UI_PB_cmd_UpdateCmdNameData { PAGE_OBJ } {
  upvar $PAGE_OBJ page_obj
  global pb_cmd_procname
  set active_cmd $Page::($page_obj,active_cmd_obj)
  set cur_cmd_name "PB_CMD_${pb_cmd_procname}"
  set prev_cmd_name $command::($active_cmd,name)
  if { [string compare $cur_cmd_name $prev_cmd_name] != 0 } \
  {
   PB_int_RemoveCmdProcFromlist active_cmd
   set command::($active_cmd,name) $cur_cmd_name
   PB_int_UpdateCommandAdd active_cmd
   command::readvalue $active_cmd cmd_obj_attr
   set cmd_obj_attr(0) PB_CMD_${pb_cmd_procname}
   command::setvalue $active_cmd cmd_obj_attr
   array set def_cmd_attr $command::($active_cmd,def_value)
   set def_cmd_attr(0) PB_CMD_${pb_cmd_procname}
   command::DefaultValue $active_cmd def_cmd_attr
   command::RestoreValue $active_cmd
  }
 }

#=======================================================================
proc UI_PB_cmd_DisplayCmdBlocks { PAGE_OBJ OBJ_INDEX } {
  upvar $PAGE_OBJ page_obj
  upvar $OBJ_INDEX obj_index
  global paOption
  global gPB
  set style $gPB(font_style_normal)
  set tree $Page::($page_obj,tree)
  set HLIST [$tree subwidget hlist]
  $HLIST delete all
  $HLIST add 0 -itemtype imagetext -text "" -image $paOption(folder) \
  -state disabled
  set file  $gPB(pb_cmd_icon)
  PB_int_RetCmdBlks cmd_obj_list
  if 0 {{ 
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
  for {set count 0} {$count < $no_blks} {incr count}\
  {
   set cmd_obj [lindex $cmd_obj_list $count]
   set cmd_name $command::($cmd_obj,name)
   $HLIST add 0.$count -itemtype imagetext -text $cmd_name -image $file \
   -style $style
  }
  if { $no_blks } \
  {
   if { $obj_index >= $no_blks } \
   {
    set obj_index [expr $no_blks - 1]
    $HLIST selection set 0.$obj_index
    } elseif {$obj_index >= 0}\
   {
    $HLIST selection set 0.$obj_index
   } else\
   {
    $HLIST selection set 0
   }
  } else \
  {
   $HLIST selection set 0
  }
  $tree autosetmode
 }

#=======================================================================
proc UI_PB_cmd_CmdBlkItemSelection { page_obj args } {
  global pb_cmd_procname
  if { [info exists Page::($page_obj,rename_index)] } \
  {
   if { [UI_PB_cmd_UpdateCmdEntry $page_obj \
    $Page::($page_obj,rename_index)] == "UI_PB_ERROR" } {
    return
   }
  }
  set canvas_frame $Page::($page_obj,canvas_frame)
  set cmd_entry $Page::($page_obj,cmd_entry)
  set tree $Page::($page_obj,tree)
  set HLIST [$tree subwidget hlist]
  if { ![info exists Page::($page_obj,selected_index)] } {
   set Page::($page_obj,selected_index) -1
  }
  set ent [lindex $args 0]
  if { $ent == "" } \
  {
   set ent [$HLIST info selection]
   } elseif { $ent == "0" } \
  {
   $HLIST selection clear
   $HLIST anchor clear
   $HLIST selection set 0.0
   $HLIST anchor set 0.0
   set ent 0.0
  }
  PB_int_RetCmdBlks cmd_obj_list
  if {[info exists Page::($page_obj,selected_index)]} \
  {
   if { $Page::($page_obj,selected_index) == "$ent" } \
   {
    return [UI_PB_cmd_EditCmdName $page_obj $ent]
   }
  }
  set index [string range $ent 2 [string length $ent]]
  set cmd_obj [lindex $cmd_obj_list $index]
  if {[info exists Page::($page_obj,active_cmd_obj)]} \
  {
   if {$cmd_obj == $Page::($page_obj,active_cmd_obj)} \
   {
    return
   }
  }
  if { [llength $cmd_obj_list] > 0 } \
  {
   if {[string compare $index ""] == 0} \
   {
    set index 0
    $HLIST selection clear
    $HLIST anchor clear
    $HLIST selection set 0.0
    $HLIST anchor set 0.0
   }
   $Page::($page_obj,text_widget) config -state normal
  } else \
  {
   $HLIST selection set 0
   $HLIST anchor set 0
   set index 0
   set pb_cmd_procname ""
   $Page::($page_obj,text_widget) config -state disabled
  }
  if { [info exists Page::($page_obj,active_cmd_obj)] } \
  {
   set active_cmd_obj $Page::($page_obj,active_cmd_obj)
   set act_index [lsearch $cmd_obj_list $active_cmd_obj]
   set cur_cmd_name "PB_CMD_${pb_cmd_procname}"
   if [info exists Page::($page_obj,rename_index)] {
    set rename_index $Page::($page_obj,rename_index)
    if [__cmd_DenyCmdName $cur_cmd_name $page_obj $rename_index] {
     return UI_PB_ERROR
    }
   }
   set ret_code [PB_int_CheckForCmdBlk active_cmd_obj cur_cmd_name]
   if { $ret_code } \
   {
    if { [info exists Page::($page_obj,rename_index)] } {
     return [ UI_PB_cmd_DenyCmdRename $ret_code $page_obj \
     $Page::($page_obj,rename_index) ]
     } else { return }
   } else \
   {
    $HLIST selection clear $ent $ent
    $HLIST anchor clear
    if { $Page::($page_obj,selected_index) >= 0 } {
     set selected_index $Page::($page_obj,selected_index)
     } elseif { [info exists Page::($page_obj,rename_index)] } {
     set selected_index $Page::($page_obj,rename_index)
     } elseif [info exists Page::($page_obj,active_cmd_obj)] {
     set cmd_obj $Page::($page_obj,active_cmd_obj)
     set selected_index [lsearch $cmd_obj_list $cmd_obj]
     set selected_index "0.$selected_index"
    }
    if [info exists selected_index] {
     $HLIST selection set $selected_index
     $HLIST anchor set $selected_index
     set Page::($page_obj,selected_index) $selected_index
     unset selected_index
    }
    if { ![UI_PB_cmd_SaveCmdProc $page_obj] } {
     return
    }
    if { $Page::($page_obj,double_click_flag) } \
    {
     global gPB
     set style $gPB(font_style_normal)
     set file  $gPB(pb_cmd_icon)
     $HLIST delete entry 0.$act_index
     $HLIST add 0.$act_index -itemtype imagetext \
     -text $cur_cmd_name -image $file -style $style \
     -at $act_index
     UI_PB_cmd_UpdateCmdNameData page_obj
     set Page::($page_obj,double_click_flag) 0
     unset Page::($page_obj,rename_index)
    }
   }
   UI_PB_cmd_DeleteCmdProc $page_obj
   unset Page::($page_obj,active_cmd_obj)
  }
  set Page::($page_obj,selected_index) $ent
  if { $cmd_obj != "" } \
  {
   UI_PB_cmd_DisplayCmdBlkAttr page_obj cmd_obj
   global paOption
   if 0 { 
    if { [string match "PB_CMD_kin_start_of_program" $command::($cmd_obj,name)] || \
    [string match "PB_CMD_kin_start_of_path" $command::($cmd_obj,name)] } \
    {
     $Page::($page_obj,text_widget) config -bg $paOption(entry_disabled_bg) -state disabled
    } else \
    {
     $Page::($page_obj,text_widget) config -bg $Page::($page_obj,text_widget_bg)
    }
   }
  }
  $HLIST selection clear
  $HLIST anchor clear
  $HLIST selection set $ent
  $HLIST anchor set $ent
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
proc UI_PB_cmd_AddComponentsLeftPan { PAGE_OBJ } {
  upvar $PAGE_OBJ page_obj
  global gPB
  global paOption
  set lpane $Page::($page_obj,left_pane_id)
  set frm_bg $paOption(butt_bg)
  set top_frm [frame $lpane.top -bg $frm_bg -relief sunken -bd 1]
  set left_pane [frame $lpane.bot]
  set Page::($page_obj,left_pane_id) $left_pane
  pack $top_frm -side top -fill x -padx 7 -pady 2
  pack $left_pane -side bottom -fill both -expand yes
  set frm [frame $top_frm.frm -bg $frm_bg]
  pack $frm -fill x -padx 1
  set imp [button $frm.imp -text "$gPB(cust_cmd,import,Label)" \
  -command "_cmd_ImportCustCmdFile" \
  -bg $paOption(app_butt_bg) -state normal]
  set exp [button $frm.exp -text "$gPB(cust_cmd,export,Label)" \
  -command "_cmd_ExportCustCmdFile $page_obj" \
  -bg $paOption(app_butt_bg) -state normal]
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
proc _cmd_ImportCustCmdFile { args } {
  global gPB
  global tcl_platform
  UI_PB_com_SetStatusbar "Select a Tcl file."
  if { ![info exists gPB(custom_command_file_import)] } {
   set gPB(custom_command_file_import) ""
  }
  if { $gPB(custom_command_file_import) == "" } {
   global env
   set gPB(custom_command_file_import) [file dirname $env(PB_HOME)/pblib/custom_command/.]/.
  }
  if {$tcl_platform(platform) == "unix"} \
  {
   UI_PB_file_SelectFile_unx TCL gPB(custom_command_file_import) open
   } elseif {$tcl_platform(platform) == "windows"} \
  {
   UI_PB_com_GrayOutSaveOptions
   UI_PB_com_DisableMain
   UI_PB_file_SelectFile_win TCL gPB(custom_command_file_import) open
   UI_PB_com_EnableMain
   UI_PB_com_UnGraySaveOptions
  }
  if [file exists $gPB(custom_command_file_import)] {
   global post_object
   set awin [UI_PB_com_AskActiveWindow]
   set win $awin.custom_command
   if { ![winfo exists $win]} {
    toplevel $win
   }
   UI_PB_com_CreateTransientWindow $win "Import Custom Commands" \
   "+200+100" "" "" "destroy $win" "UI_PB_com_EnableMain"
   if [ catch { _cmd_ViewTclProcs $win $gPB(custom_command_file_import) } res ] {
    tk_messageBox -parent [UI_PB_com_AskActiveWindow] -type ok \
    -icon error -title "$gPB(cust_cmd,error,title)" \
    -message "$res"
    destroy $win
    UI_PB_com_EnableMain
    } else {
    UI_PB_com_PositionWindow $win
    UI_PB_com_ClaimActiveWindow $win
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
  UI_PB_com_CreateTransientWindow $win "Export Custom Commands" \
  "+200+100" "" "" "destroy $win" "UI_PB_com_EnableMain"
  _cmd_ViewTclProcsEx $win $gPB(custom_command_file_export)
  UI_PB_com_PositionWindow $win
  UI_PB_com_ClaimActiveWindow $win
 }

#=======================================================================
proc _cmd_ViewTclProcs { win tcl_file } {
  global tixOption
  global paOption
  global gPB
  set w $win
  set b [frame $w.b]
  set f [frame $w.f]
  pack $b -side bottom -fill x
  pack $f -side top    -fill both -expand yes
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
  _cmd_AddButtons $page_obj
  Page::CreateCheckList $page_obj
  _cmd_CreateProcList $page_obj
  UI_PB_prv_CreateSecPaneElems page_obj
  set label_list {"gPB(nav_button,ok,Label)" "gPB(nav_button,cancel,Label)"}
  set cb_arr(gPB(nav_button,ok,Label))     "_cmd_ImportCmdOk_CB     $win $page_obj"
  set cb_arr(gPB(nav_button,cancel,Label)) "_cmd_ImportCmdCancel_CB $win $page_obj"
  UI_PB_com_CreateButtonBox $b label_list cb_arr
  _cmd_TclTreeSelection $page_obj "import"
 }

#=======================================================================
proc _cmd_AddButtons { page_obj } {
  global paOption
  global gPB
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
  pack $sel $des -side left -fill x -expand yes -padx 1 -pady 2
  set gPB(c_help,$sel)     "cust_cmd,select_all"
  set gPB(c_help,$des)     "cust_cmd,deselect_all"
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
proc _cmd_ViewTclProcsEx { win tcl_file } {
  global tixOption
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
  _cmd_AddButtons $page_obj
  Page::CreateCheckList $page_obj
  _cmd_CreateProcListEx $page_obj
  UI_PB_prv_CreateSecPaneElems page_obj
  set label_list {"gPB(nav_button,ok,Label)" "gPB(nav_button,cancel,Label)"}
  set cb_arr(gPB(nav_button,ok,Label))     "_cmd_ExportCmdOk_CB $win $page_obj"
  set cb_arr(gPB(nav_button,cancel,Label)) "destroy $win; delete $page_obj"
  UI_PB_com_CreateButtonBox $b label_list cb_arr
  _cmd_TclTreeSelection $page_obj "export"
 }

#=======================================================================
proc _cmd_CreateProcList { page_obj } {
  global paOption
  global tixOption
  global gPB
  global post_object
  set bgclr  $paOption(tree_bg)
  set style  $gPB(font_style_bold)
  set style2  [tixDisplayStyle imagetext \
  -bg $bgclr -font $tixOption(font) \
  -padx 4 -pady 3 \
  -selectforeground blue]
  set style3  [tixDisplayStyle imagetext \
  -bg $paOption(butt_bg) \
  -padx 7 -pady 1]
  set evt_proc_list $Page::($page_obj,evt_proc_list)
  array set event_proc_data $evt_proc_list
  set cmd_proc_list ""
  set oth_proc_list ""
  set llen [llength $evt_proc_list]
  for {set i 0} {$i < $llen} {incr i 2} \
  {
   set event_item [lindex $evt_proc_list $i]
   if { ![string match "MOM*" $event_item] && [string match "*\,name" $event_item] } \
   {
    if { [string match "PB_CMD*" $event_item] } \
    {
     set event_name [lindex [split $event_item ,] 0]
     set cmd_proc_list [ladd $cmd_proc_list end $event_name "no_dup"]
     set cmd_proc_data($event_name,proc) $event_proc_data($event_name,proc)
     set cmd_proc_data($event_name,blk_list) $event_proc_data($event_name,blk_list)
     set cmd_proc_data($event_name,add_list) $event_proc_data($event_name,add_list)
     set cmd_proc_data($event_name,fmt_list) $event_proc_data($event_name,fmt_list)
     } elseif { ![string match "PB*" $event_item] } \
    {
     set event_name [lindex [split $event_item ,] 0]
     set oth_proc_list [ladd $oth_proc_list end $event_name "no_dup"]
     set oth_proc_data($event_name,comment) $event_proc_data($event_name,comment)
     set oth_proc_data($event_name,args)    $event_proc_data($event_name,args)
     set oth_proc_data($event_name,proc)    $event_proc_data($event_name,proc)
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
  if $cmd_exists {
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
  foreach event_name $oth_proc_list \
  {
   $HLIST add $t -itemtype imagetext -text $event_name -style $style2 -state normal
   if { [lsearch $post_oth_proc_list $event_name] >= 0 } {
    $HLIST indicator create $t -itemtype imagetext -text "exists" -image $gPB(pb_cmd_icon) \
    -style $style3
   }
   $tree setstatus $t on
   incr t
  }
  set Page::($page_obj,prev_index) 0
  $HLIST config -browsecmd "_cmd_TclTreeSelection $page_obj import"
  $HLIST config -indicatorcmd "_cmd_TclTreeSelection $page_obj import"
  $HLIST selection set 1
  $HLIST anchor set 1
  set gPB(custom_command_import_page) $page_obj
  set gPB(c_help,$tree)    "cust_cmd,import,tree"
  set gPB(c_help,$HLIST)   "cust_cmd,import,tree"
 }

#=======================================================================
proc UI_PB_cmd_DisableSelection { h args } {
  global gPB
  if [info exists gPB(custom_command_import_page)] {
   set page_obj $gPB(custom_command_import_page)
   $h selection clear
   $h selection set $Page::($page_obj,prev_index)
   $h anchor set $Page::($page_obj,prev_index)
  }
 }

#=======================================================================
proc _cmd_CreateProcListEx { page_obj } {
  global paOption
  global tixOption
  global gPB
  global post_object
  set bgclr  $paOption(tree_bg)
  set style  $gPB(font_style_bold)
  set style2  [tixDisplayStyle imagetext \
  -bg $bgclr -font $tixOption(font) \
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
  for {set count 0} {$count < $no_blks} {incr count}\
  {
   set cmd_obj [lindex $post_cmd_obj_list $count]
   lappend post_cmd_proc_list $command::($cmd_obj,name)
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
  foreach event_name $post_cmd_proc_list \
  {
   $HLIST add $t -itemtype imagetext -text $event_name -style $style2 -state normal
   $tree setstatus $t on
   incr t
  }
  foreach event_name $post_oth_proc_list \
  {
   $HLIST add $t -itemtype imagetext -text $event_name -style $style2 -state normal
   $tree setstatus $t on
   incr t
  }
  set Page::($page_obj,prev_index) 0
  $HLIST config -browsecmd "_cmd_TclTreeSelection $page_obj export"
  $HLIST selection set 1
  $HLIST anchor set 1
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
  if {[string compare $index ""] == 0} \
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
  if [string match "on" $sta] {
   $tree setstatus $ent "off"
   } elseif [string match "off" $sta] {
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
   if [string match "$proc_name" $command::($cmd_obj,name)] {
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
   if { ![catch {$text_pane forget p2}] } {
    $text_pane paneconfigure p1 -size 500
   }
   UI_PB_com_GrayOutSaveOptions
   UI_PB_com_DisableMain
  }
  if [info exists cmd_proc_data($proc_name,proc)] {
   $ltext insert end "    #=============================================================\n"

#=======================================================================
$ltext insert end "    proc $proc_name \{ \} \{\n"
  $ltext insert end "    #=============================================================\n"
  foreach line $cmd_proc_data($proc_name,proc) {
   $ltext insert end "    $line\n"
  }
 $ltext insert end "    \}\n"
 if $cmd_obj_found {
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
} elseif [info exists oth_proc_data($proc_name,proc)] {
foreach line $oth_proc_data($proc_name,comment) {
 $ltext insert end "    $line\n"
}
if [llength $oth_proc_data($proc_name,args)] {

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
if [info exists post_oth_proc_data($proc_name,proc)] {
 foreach line $post_oth_proc_data($proc_name,comment) {
  $rtext insert end "    $line\n"
 }
 if [llength $post_oth_proc_data($proc_name,args)] {

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
  if { ![catch {$text_pane forget p1}] } {
   $text_pane paneconfigure p2 -size 500
  }
  UI_PB_com_GrayOutSaveOptions
  UI_PB_com_DisableMain
  set post_cmd_obj_list ""
  PB_int_RetCmdBlks post_cmd_obj_list
  set cmd_obj_found 0
  set no_blks [llength $post_cmd_obj_list]
  for {set count 0} {$count < $no_blks} {incr count}\
  {
   set cmd_obj [lindex $post_cmd_obj_list $count]
   if [string match "$proc_name" $command::($cmd_obj,name)] {
    set cmd_obj_found $cmd_obj
   }
  }
  if $cmd_obj_found {
   $rtext insert end "    #=============================================================\n"

#=======================================================================
$rtext insert end "    proc $proc_name \{ \} \{\n"
  $rtext insert end "    #=============================================================\n"
  foreach line $command::($cmd_obj_found,proc) \
  {
   $rtext insert end "    $line\n"
  }
 $rtext insert end "    \}\n"
 } elseif [info exists oth_proc_data($proc_name,proc)] {
 foreach line $oth_proc_data($proc_name,comment) {
  $rtext insert end "    $line\n"
 }
 if [llength $oth_proc_data($proc_name,args)] {

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
   if [string match "on" $sta] {
    incr item_selected
    set proc_name [lindex [$HLIST entryconfigure $ent -text] end]
    if [string match "PB_CMD*" $proc_name] {
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
  set word "Command"
  set cmd_proc_list ""
  set cmd_proc_desc_list ""
  PB_int_UpdateMOMVarDescAddress word cmd_proc_desc_list
  PB_int_UpdateMOMVarOfAddress   word cmd_proc_list
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
  if [llength $out_oth_proc_list] {
   Post::SetOthProcList $post_object post_oth_proc_list
   Post::SetOthProcData $post_object post_oth_proc_data
  }
  set prog_page_obj [lindex $Book::($gPB(book),page_obj_list) 1]
  set book_obj $Page::($prog_page_obj,book_obj)
  set cmd_page_obj [lindex $Book::($book_obj,page_obj_list) 5]
  UI_PB_cmd_DeleteCmdProc $cmd_page_obj
  set Page::($cmd_page_obj,selected_index) -1
  if [info exists Page::($cmd_page_obj,active_cmd_obj)] {
   unset Page::($cmd_page_obj,active_cmd_obj)
  }
  UI_PB_UpdateProgTpthBook book_obj
  UI_PB_progtpth_DeleteTabAtt book_obj
  set Book::($book_obj,current_tab) 5
  UI_PB_progtpth_CreateTabAttr book_obj
  unset gPB(custom_command_import_page)
  delete $page_obj
  destroy $win
 }

#=======================================================================
proc __cmd_CreateCommand { CMD_OBJ_ATTR CMD_OBJ } {
  upvar $CMD_OBJ_ATTR cmd_obj_attr
  upvar $CMD_OBJ cmd_obj
  global post_object
  Post::GetObjList $post_object command cmd_blk_list
  if [info exists cmd_obj] { unset cmd_obj }
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
  delete $page_obj
  destroy $win
 }

#=======================================================================
proc _cmd_ExportCmdOk_CB { win page_obj } {
  global post_object
  global gPB
  set tree $Page::($page_obj,tree)
  set HLIST [$tree subwidget hlist]
  set out_cmd_proc_list ""
  set out_oth_proc_list ""
  set item_selected 0
  foreach ent [$HLIST info children] {
   set sta [string tolower [$tree getstatus $ent]]
   if [string match "on" $sta] {
    incr item_selected
    set proc_name [lindex [$HLIST entryconfigure $ent -text] end]
    if [string match "PB_CMD*" $proc_name] {
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
  destroy $win
  delete $page_obj
  UI_PB_com_SetStatusbar "Select a Tcl file."
  global tcl_platform
  if {$tcl_platform(platform) == "unix"} \
  {
   UI_PB_file_SelectFile_unx TCL gPB(custom_command_file_export) save
   } elseif {$tcl_platform(platform) == "windows"} \
  {
   UI_PB_com_GrayOutSaveOptions
   UI_PB_com_DisableMain
   UI_PB_file_SelectFile_win TCL gPB(custom_command_file_export) save
   UI_PB_com_EnableMain
   UI_PB_com_UnGraySaveOptions
  }
  if { $gPB(custom_command_file_export) != "" } {
   set fid [open $gPB(custom_command_file_export) {RDWR CREAT TRUNC}]
   fconfigure $fid -translation lf
   global env
   set time_string [clock format [clock seconds] -format "%c %Z"]
   puts $fid "\#==============================================================================="
   puts $fid "\# Exported Custom Commands created by $env(USERNAME)"
   puts $fid "\# on $time_string"
   puts $fid "\#==============================================================================="
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
 if [llength $post_oth_proc_data($proc_name,args)] {

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
proc __UI_PB_cmd_AddComponentsLeftPan { PAGE_OBJ } {
  upvar $PAGE_OBJ page_obj
  global gPB
  global paOption
  set left_pane $Page::($page_obj,left_pane_id)
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
  UI_PB_cmd_DisplayCmdBlocks page_obj obj_index
  UI_PB_cmd_CmdBlkItemSelection $page_obj
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
   } elseif {$command::($active_cmd_obj,blk_elem_list) != ""} \
  {
   set cmd_name $command::($active_cmd_obj,name)
   tk_messageBox -parent [UI_PB_com_AskActiveWindow] -type ok -icon error \
   -message "$gPB(msg,in_use)"
  } else \
  {
   if { [info exists Page::($page_obj,buff_cmd_obj)] } \
   {
    delete $Page::($page_obj,buff_cmd_obj)
    unset Page::($page_obj,buff_cmd_obj)
   }
   if { ![UI_PB_cmd_SaveCmdProc $page_obj not_verify] } {
    return
   }
   UI_PB_cmd_DeleteCmdProc $page_obj
   if { $Page::($page_obj,double_click_flag) } \
   {
    set ent $Page::($page_obj,rename_index)
    set obj_index [string range $ent 2 [string length $ent]]
    set Page::($page_obj,double_click_flag) 0
    unset Page::($page_obj,rename_index)
    grab release $Page::($page_obj,page_id)
   } else \
   {
    set tree $Page::($page_obj,tree)
    set HLIST [$tree subwidget hlist]
    set ent [$HLIST info selection]
    set obj_index [string range $ent 2 [string length $ent]]
   }
   set Page::($page_obj,buff_cmd_obj) $active_cmd_obj
   PB_int_CommandCutObject active_cmd_obj obj_index
   unset Page::($page_obj,active_cmd_obj)
   unset Page::($page_obj,selected_index)
   UI_PB_cmd_DisplayCmdBlocks page_obj obj_index
   UI_PB_cmd_CmdBlkItemSelection $page_obj
   set left_pane_id $Page::($page_obj,left_pane_id)
   $left_pane_id.f.pas config -state normal
  }
 }

#=======================================================================
proc UI_PB_cmd_PasteACmdBlock { page_obj } {
  if {![info exists Page::($page_obj,buff_cmd_obj)]} \
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
   set obj_index [string range $ent 2 [string length $ent]]
   set Page::($page_obj,double_click_flag) 0
   unset Page::($page_obj,rename_index)
  } else \
  {
   set tree $Page::($page_obj,tree)
   set HLIST [$tree subwidget hlist]
   set ent [$HLIST info selection]
   set obj_index [string range $ent 2 [string length $ent]]
  }
  set buff_cmd_obj $Page::($page_obj,buff_cmd_obj)
  set temp_index $obj_index
  PB_int_CmdBlockPasteObject buff_cmd_obj obj_index
  if { $temp_index != $obj_index } \
  {
   UI_PB_cmd_DisplayCmdBlocks page_obj obj_index
   UI_PB_cmd_CmdBlkItemSelection $page_obj
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
  set index [string range $ent 2 [string length $ent]]
  if {[string compare $index ""] == 0} \
  {
   set index 0
  }
  UI_PB_cmd_DisplayCmdBlocks page_obj index
  UI_PB_cmd_CmdBlkItemSelection $page_obj
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
  global tixOption paOption
  global pb_cmd_procname
  set bg $paOption(title_bg)
  set fg $paOption(special_fg)
  set ft $tixOption(bold_font)
  set win $Page::($page_obj,canvas_frame)
  set top_frm [frame $win.top -relief flat -bg $bg]
  set mid_frm [frame $win.mid]
  set bot_frm [frame $win.bot -relief flat -bg $bg]
  pack $top_frm -side top -fill x
  pack $bot_frm -side bottom -fill x
  pack $mid_frm -side top -fill both -expand yes

#=======================================================================
label $top_frm.prc -text " proc    PB_CMD_" -fg $fg -bg $bg -font $ft
 if { $cmd_mode } \
 {
  entry $top_frm.ent -textvariable pb_cmd_procname -width 40 -relief flat -bd 0
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
  $text_widget config -font $tixOption(fixed_font) -wrap none -bd 5 -relief flat
  set Page::($page_obj,text_widget) $text_widget
  set Page::($page_obj,cmd_entry) $top_frm.ent
  set Page::($page_obj,entry_flag) $cmd_mode
  set tbg [lindex [$text_widget config -bg] end]
  set Page::($page_obj,text_widget_bg) $tbg
 label $bot_frm.brc -text "   \}" -fg $fg -bg $bg -font $ft
 pack $bot_frm.brc -side left -pady 10 -fill x
 global gPB
 set gPB(custom_command_paste_buffer) ""
 set t  $Page::($page_obj,text_widget)
 if [winfo exists $t.pop] {
  set menu $t.pop
  } else {
  set menu [menu $t.pop -tearoff 0 -cursor ""]
 }
 bind $t <3> "_cmd_AddPopUpMenu $t $menu %X %Y"
 focus $text_widget
}

#=======================================================================
proc _cmd_AddPopUpMenu { t menu x y } {
  global gPB
  set sel_buffer ""
  catch {
   set sel_buffer [$t get sel.first sel.last]
  }
  set gPB(custom_command_selection_buffer) $sel_buffer
  if { [$menu index end] == "none" } {
   $menu add command -label "$gPB(nav_button,cut,Label)"   -command "_cmd_CutText $t"
   $menu add command -label "$gPB(nav_button,copy,Label)"  -command "_cmd_CopyText"
   $menu add command -label "$gPB(nav_button,paste,Label)" -command "_cmd_PasteText $t"
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
   $menu entryconfig 2 -state disabled
   } else {
   $menu entryconfig 0 -state disabled
   $menu entryconfig 1 -state disabled
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
  $t insert insert "$gPB(custom_command_paste_buffer)"
 }

#=======================================================================
proc UI_PB_cmd_UpdateCmdName { page_obj } {
  global pb_cmd_procname
  if { [info exists Page::($page_obj,active_cmd_obj)] } \
  {
   set cmd_obj $Page::($page_obj,active_cmd_obj)
   set tree $Page::($page_obj,tree)
   set HLIST [$tree subwidget hlist]
   set ent [$HLIST info selection]
   if { $ent == "" } { return }
   set cur_cmd_name PB_CMD_${pb_cmd_procname}
   if [__cmd_DenyCmdName $cur_cmd_name $page_obj $ent] {return UI_PB_ERROR}
   set ret_code [PB_int_CheckForCmdBlk cmd_obj cur_cmd_name]
   if { $ret_code  == 1} \
   {
    return [ UI_PB_cmd_DenyCmdRename $ret_code $page_obj $ent ]
    } elseif { $cur_cmd_name != $command::($cmd_obj,name) } \
   {
    PB_int_RemoveCmdProcFromlist cmd_obj
    set command::($cmd_obj,name) $cur_cmd_name
    PB_int_UpdateCommandAdd cmd_obj
    $HLIST entryconfigure $ent -text "$cur_cmd_name"
   }
  }
 }

#=======================================================================
proc UI_PB_cmd_DisplayCmdProc { CMD_OBJ PAGE_OBJ } {
  upvar $CMD_OBJ cmd_obj
  upvar $PAGE_OBJ page_obj
  global pb_cmd_procname
  set text_wdg $Page::($page_obj,text_widget)
  set proc_list [split $command::($cmd_obj,name) "_"]
  set proc_list [lrange $proc_list 2 end]
  set pb_cmd_procname [join $proc_list _]
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
  $text_wdg config -state $sens
  set ent_widget $Page::($page_obj,cmd_entry)
  set ent_flag $Page::($page_obj,entry_flag)
  if { $ent_flag } \
  {
   if { [string match "before_motion" $pb_cmd_procname] || \
   [string match "kin*" $pb_cmd_procname] } \
   {
    bind $ent_widget <Return> ""
    $ent_widget config -state disabled
   } else \
   {
    bind $ent_widget <Return> ""
    $ent_widget config -state normal
   }
  } else \
  {
   $ent_widget config -text "$pb_cmd_procname"
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
  delete $cmd_page_obj
 }

#=======================================================================
proc UI_PB_cmd_SeqEditCmdBlkOk_CB { win page_obj seq_obj elem_obj \
  cmd_page_obj } {
  global pb_cmd_procname
  set block_obj $event_element::($elem_obj,block_obj)
  set cmd_blk_elem [lindex $block::($block_obj,elem_addr_list) 0]
  set cmd_obj $block_element::($cmd_blk_elem,elem_mom_variable)
  set cur_cmd_name PB_CMD_$pb_cmd_procname
  if [__cmd_DenyCmdName $cur_cmd_name] {return UI_PB_ERROR}
  set ret_code [PB_int_CheckForCmdBlk cmd_obj cur_cmd_name]
  if { $ret_code } \
  {
   return [UI_PB_cmd_DenyCmdRename $ret_code]
  }
  UI_PB_cmd_GetProcFromTextWin $cmd_page_obj proc_text
  if { ![__cmd_ValidateCmdLineOK $cmd_obj $proc_text] } {
   return
  }
  set prev_cmd_name $command::($cmd_obj,name)
  set command::($cmd_obj,proc) $proc_text
  UI_PB_cmd_UpdateCmdNameData cmd_page_obj
  if { $pb_cmd_procname != "$prev_cmd_name"} \
  {
   UI_PB_evt_CreateMenuOptions page_obj seq_obj
  }
  UI_PB_evt_DeleteSeqEvents page_obj seq_obj
  UI_PB_evt_CreateSeqAttributes page_obj
  destroy $win
  delete $cmd_page_obj
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

#=======================================================================
lappend cmd_proc $line_text
}
}

#=======================================================================
proc __cmd_ValidateCmdLineOK { cmd_obj proc_body } {
  global gPB
  set proc_state [PB_proc_ValidateCustCmd $proc_body err_msg]
  if { !$proc_state } {
   tk_messageBox -parent [ UI_PB_com_AskActiveWindow ] -type ok -icon error \
   -message "$err_msg" -title "$gPB(cust_cmd,error,title)"
   return 0
  }
  if $gPB(check_cc_unknown_command) {
   global post_object
   if [llength $Post::($post_object,unk_cmd_list)] {
    set res [tk_messageBox -parent [ UI_PB_com_AskActiveWindow ] \
    -type yesno -icon question \
    -message "$gPB(cust_cmd,cmd,msg) $Post::($post_object,unk_cmd_list)\n\n\
    $gPB(cust_cmd,referenced,msg) \"$command::($cmd_obj,name)\"\n\
    $gPB(cust_cmd,not_defined,msg)\n\n\
    $gPB(msg,do_you_want_to_proceed)"]
    if { $res == "no" } {
     return 0
     } else {
     PB_file_AssumeUnknownCommandsInProc
    }
   }
  }
  command::readvalue $cmd_obj cmd_attr
  set old_blk_list $cmd_attr(2)
  set old_add_list $cmd_attr(3)
  set old_fmt_list $cmd_attr(4)
  set cmd_attr(2) $gPB(CMD_BLK_LIST)
  set cmd_attr(3) $gPB(CMD_ADD_LIST)
  set cmd_attr(4) $gPB(CMD_FMT_LIST)
  command::setvalue $cmd_obj cmd_attr
  set err_msg [ PB_file_ValidateDefElemsInCommand $cmd_obj ]
  if { $err_msg != "" } {
   set res [tk_messageBox -parent [ UI_PB_com_AskActiveWindow ] \
   -type yesno -icon question \
   -message "$err_msg\n\n\
   $gPB(msg,do_you_want_to_proceed)"]
   if { $res == "no" } {
    set cmd_attr(2) $old_blk_list
    set cmd_attr(3) $old_add_list
    set cmd_attr(4) $old_fmt_list
    command::setvalue $cmd_obj cmd_attr
    return 0
    } else {
    PB_file_AssumeUnknownDefElemsInProc
   }
  }
  return 1
 }

#=======================================================================
proc UI_PB_cmd_SaveCmdProc_ret_msg { page_obj ERR_MSG } {
  upvar $ERR_MSG err_msg
  if { ![info exists Page::($page_obj,active_cmd_obj)] } { return 0}
  set cmd_obj $Page::($page_obj,active_cmd_obj)
  UI_PB_cmd_GetProcFromTextWin $page_obj proc_text
  set res [__cmd_ValidateCmdLineOK_ret_msg $cmd_obj $proc_text err_msg]
  if { $res == 0  ||  $res == -1 } {
   return $res
  }
  set command::($cmd_obj,proc) $proc_text
  return 1
 }

#=======================================================================
proc __cmd_ValidateCmdLineOK_ret_msg { cmd_obj proc_body ERR_MSG } {
  upvar $ERR_MSG err_msg
  global gPB
  set proc_state [PB_proc_ValidateCustCmd $proc_body err_msg]
  if { !$proc_state } {
   return 0 
  }
  if 0 {
   if [info exists gPB(CMD_BLK_LIST)] {
    set command::($cmd_obj,blk_list) $gPB(CMD_BLK_LIST)
    set err_msg [PB_file_ValidateDefElemsInCommand $cmd_obj]
    if { $err_msg != "" } {
     append err_msg "\n$gPB(msg,do_you_want_to_proceed)"
     return -1 
    }
   }
  }
  if [info exists gPB(CMD_BLK_LIST)] {
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
   append err_msg "\n\n\
   $gPB(msg,do_you_want_to_proceed)"
   return -1 
  }
  if $gPB(check_cc_unknown_command) {
   global post_object
   if [llength $Post::($post_object,unk_cmd_list)] {
    set err_msg "$gPB(cust_cmd,cmd,msg) $Post::($post_object,unk_cmd_list)\n\n\
    $gPB(cust_cmd,referenced,msg) \"$command::($cmd_obj,name)\"\n\
    $gPB(cust_cmd,not_defined,msg)\n\n\
    $gPB(msg,do_you_want_to_proceed)"
    return -1
   }
  }
  return 1
 }

#=======================================================================
proc UI_PB_cmd_SeqNewCmdBlkOk_CB { win page_obj seq_obj elem_obj \
  cmd_page_obj } {
  global paOption
  global tixOption
  global pb_cmd_procname
  global gPB
  set block_obj $event_element::($elem_obj,block_obj)
  set cmd_blk_elem [lindex $block::($block_obj,elem_addr_list) 0]
  set cmd_obj $block_element::($cmd_blk_elem,elem_mom_variable)
  set cur_cmd_name PB_CMD_$pb_cmd_procname
  if [__cmd_DenyCmdName $cur_cmd_name] {return UI_PB_ERROR}
  set ret_code [PB_int_CheckForCmdBlk cmd_obj cur_cmd_name]
  if { $ret_code } \
  {
   return [UI_PB_cmd_DenyCmdRename $ret_code]
  }
  UI_PB_cmd_GetProcFromTextWin $cmd_page_obj proc_text
  if { ![__cmd_ValidateCmdLineOK $cmd_obj $proc_text] } {
   return
  }
  set block::($block_obj,block_name) $cur_cmd_name
  set command::($cmd_obj,name) $cur_cmd_name
  set command::($cmd_obj,proc) $proc_text
  command::readvalue $cmd_obj cmd_obj_attr
  command::DefaultValue $cmd_obj cmd_obj_attr
  set block_element::($cmd_blk_elem,elem_desc) \
  "$gPB(block,cmd,word_desc,Label)"
  set blk_nc_code $command::($cmd_obj,name)
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
  $elem_yc -text $elem_text -font $tixOption(font_sm) -justify left \
  -tag blk_movable]
  set event_element::($elem_obj,text_id) $elem_text_id
  lappend sequence::($seq_obj,texticon_ids) $elem_text_id $elem_icon_id
  set blk_img_id $event_element::($elem_obj,icon_id)
  set img [lindex [$bot_canvas itemconfigure $blk_img_id -image] end]
  $img config -relief raised -bg $paOption(special_fg)
  PB_int_UpdateCommandAdd cmd_obj
  UI_PB_cmd_UpdateCmdNameData cmd_page_obj
  UI_PB_evt_CreateMenuOptions page_obj seq_obj
  destroy $win
  delete $cmd_page_obj
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
  delete $cmd_page_obj
 }

#=======================================================================
proc UI_PB_cmd_tpthEditCmdBlkCancel_CB { win page_obj blk_elem_obj \
  cmd_page_obj } {
  destroy $win
  delete $cmd_page_obj
 }

#=======================================================================
proc UI_PB_cmd_tpthEditCmdBlkOk_CB { win page_obj cmd_blk_obj blk_elem_obj \
  cmd_page_obj } {
  global pb_cmd_procname
  set cmd_obj $block_element::($blk_elem_obj,elem_mom_variable)
  set cur_cmd_name PB_CMD_$pb_cmd_procname
  if [__cmd_DenyCmdName $cur_cmd_name] {return UI_PB_ERROR}
  set ret_code [PB_int_CheckForCmdBlk cmd_obj cur_cmd_name]
  if { $ret_code } \
  {
   return [UI_PB_cmd_DenyCmdRename $ret_code]
  }
  UI_PB_cmd_GetProcFromTextWin $cmd_page_obj proc_text
  if { ![__cmd_ValidateCmdLineOK $cmd_obj $proc_text] } {
   return
  }
  set prev_cmd_name $command::($cmd_obj,name)
  set command::($cmd_obj,proc) $proc_text
  UI_PB_cmd_UpdateCmdNameData cmd_page_obj
  if { $prev_cmd_name != "$pb_cmd_procname" } \
  {
   UI_PB_blk_CreateMenuOptions page_obj event
  }
  set base_addr $block_element::($blk_elem_obj,elem_add_obj)
  UI_PB_blk_ReplaceIcon page_obj $base_addr $blk_elem_obj
  destroy $win
  delete $cmd_page_obj
 }

#=======================================================================
proc UI_PB_cmd_tpthCmdBlkCancel_CB { win page_obj event_obj evt_elem_obj \
  blk_elem_obj cmd_page_obj } {
  set Page::($page_obj,source_blk_elem_obj) $blk_elem_obj
  set Page::($page_obj,source_evt_elem_obj) $evt_elem_obj
  destroy $win
  delete $cmd_page_obj
  set cmd_obj $block_element::($blk_elem_obj,elem_mom_variable)
  UI_PB_tpth_PutBlockElemTrash page_obj event_obj
  PB_int_DeleteCmdBlk cmd_obj
  set Page::($page_obj,source_blk_elem_obj) 0
  set Page::($page_obj,source_evt_elem_obj) 0
 }

#=======================================================================
proc UI_PB_cmd_tpthCmdBlkOk_CB { win page_obj block_obj blk_elem_obj \
  cmd_page_obj } {
  global tixOption
  global pb_cmd_procname
  global gPB
  set cmd_obj $block_element::($blk_elem_obj,elem_mom_variable)
  set cur_cmd_name PB_CMD_$pb_cmd_procname
  if [__cmd_DenyCmdName $cur_cmd_name] {return UI_PB_ERROR}
  set ret_code [PB_int_CheckForCmdBlk cmd_obj cur_cmd_name]
  if { $ret_code } \
  {
   return [UI_PB_cmd_DenyCmdRename $ret_code]
  }
  UI_PB_cmd_GetProcFromTextWin $cmd_page_obj proc_text
  if { ![__cmd_ValidateCmdLineOK $cmd_obj $proc_text] } {
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
  destroy $win
  delete $cmd_page_obj
 }

#=======================================================================
proc UI_PB_cmd_CreateCommentDlgParam { win page_obj block_obj blk_elem_obj } {
  global gPB
  global tixOption
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
  grid $top_frm.strt -row 1 -column 1 -padx 5 -pady 20
  entry $top_frm.ent -textvariable pb_comment -width 40 -relief flat -bd 0
  grid $top_frm.ent -row 1 -column 2
  label $top_frm.end -text "$mom_sys_arr(Comment_End)" -bg $bg -fg $fg
  grid $top_frm.end -row 1 -column 3 -padx 5
  block::RestoreValue $block_obj
  block_element::RestoreValue $blk_elem_obj
  focus $top_frm.ent
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
  global tixOption
  global pb_comment
  global mom_sys_arr
  global gPB
  set block_obj $event_element::($elem_obj,block_obj)
  set blk_elem [lindex $block::($block_obj,elem_addr_list) 0]
  if { $pb_comment == "" } \
  {
   tk_messageBox -parent [UI_PB_com_AskActiveWindow] -type ok -icon error \
   -message "$gPB(opr_msg,empty_operator)"
   return
  }
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
  set elem_icon_id [lindex $sequence::($seq_obj,texticon_ids) \
  [expr $index + 1]]
  set sequence::($seq_obj,texticon_ids) \
  [lreplace $sequence::($seq_obj,texticon_ids) $index \
  [expr $index + 1]]
  set elem_text_id [$bot_canvas create text [expr $elem_xc + $t_shift] \
  $elem_yc -text $elem_text -font $tixOption(font_sm) -justify left \
  -tag blk_movable]
  set event_element::($elem_obj,text_id) $elem_text_id
  lappend sequence::($seq_obj,texticon_ids) $elem_text_id $elem_icon_id
  set blk_img_id $event_element::($elem_obj,icon_id)
  set img [lindex [$bot_canvas itemconfigure $blk_img_id -image] end]
  $img config -relief raised -bg $paOption(special_fg)
  destroy $win
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
proc UI_PB_cmd_tpthCommentOk_CB { win page_obj evt_elem_obj blk_elem_obj } {
  global tixOption
  global pb_comment
  global gPB
  set block_obj $event_element::($evt_elem_obj,block_obj)
  if { $pb_comment == "" } \
  {
   tk_messageBox -parent [UI_PB_com_AskActiveWindow] -type ok -icon error \
   -message "$gPB(opr_msg,empty_operator)"
   return
  }
  set block_element::($blk_elem_obj,elem_mom_variable) "$pb_comment"
  set block_element::($blk_elem_obj,elem_desc) \
  "$gPB(block,oper,word_desc,Label)"
  block_element::readvalue $blk_elem_obj blk_elem_attr
  block_element::DefaultValue $blk_elem_obj blk_elem_attr
  unset blk_elem_attr
  set base_addr $block_element::($blk_elem_obj,elem_add_obj)
  UI_PB_blk_ReplaceIcon page_obj $base_addr $blk_elem_obj
  destroy $win
 }

#=======================================================================
proc UI_PB_cmd_tpthEditCommentOk_CB { win page_obj block_obj blk_elem_obj } {
  global tixOption
  global pb_comment
  global gPB
  if { $pb_comment == "" } \
  {
   tk_messageBox -parent [UI_PB_com_AskActiveWindow] -type ok -icon error \
   -message "$gPB(opr_msg,empty_operator)"
   return
  }
  set block_element::($blk_elem_obj,elem_mom_variable) "$pb_comment"
  set block_element::($blk_elem_obj,elem_desc) \
  "$gPB(block,oper,word_desc,Label)"
  set base_addr $block_element::($blk_elem_obj,elem_add_obj)
  UI_PB_blk_ReplaceIcon page_obj $base_addr $blk_elem_obj
  destroy $win
 }
