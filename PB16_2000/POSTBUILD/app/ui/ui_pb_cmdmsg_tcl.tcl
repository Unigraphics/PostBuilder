#9

#=======================================================================
proc UI_PB_ProgTpth_CustomCmd { book_id cmd_page_obj } {
  global pb_cmd_procname
  set Page::($cmd_page_obj,page_id) [$book_id subwidget \
  $Page::($cmd_page_obj,page_name)]
  Page::CreatePane $cmd_page_obj
  UI_PB_cmd_AddComponentsLeftPan cmd_page_obj
  Page::CreateTree $cmd_page_obj
  UI_PB_cmd_CreateTreeElements cmd_page_obj
  set pb_cmd_procname ""
  UI_PB_cmd_CreateCmdBlkPage cmd_page_obj
  UI_PB_cmd_CmdActionButtons cmd_page_obj
 }

#=======================================================================
proc UI_PB_cmd_CmdActionButtons { PAGE_OBJ } {
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
  $text_frm delete 1.0 end
 }

#=======================================================================
proc UI_PB_cmd_SaveCmdProc { page_obj } {
  global pb_cmd_procname
  if { ![info exists Page::($page_obj,active_cmd_obj)] } { return 0}
  set active_cmd_obj $Page::($page_obj,active_cmd_obj)
  UI_PB_cmd_GetProcFromTextWin $page_obj proc_text
  set cur_cmd_name "PB_CMD_${pb_cmd_procname}"
  set ret_code [PB_int_CheckForCmdBlk active_cmd_obj cur_cmd_name]
  if { $ret_code == 0 } \
  {
   if { $cur_cmd_name != $command::($active_cmd_obj,name) } \
   {
    PB_int_RemoveCmdProcFromlist active_cmd_obj
    set command::($active_cmd_obj,name) $cur_cmd_name
    PB_int_UpdateCommandAdd active_cmd_obj
   }
   set command::($active_cmd_obj,proc) $proc_text
   return 0
  } else \
  {
   return 1
  }
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
  -command   "UI_PB_cmd_CmdBlkItemSelection $page_obj" \
  -browsecmd "UI_PB_cmd_CmdBlkItemSelection $page_obj"
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
  set file  [tix getimage pb_block_s]
  PB_int_RetCmdBlks cmd_obj_list
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
  set canvas_frame $Page::($page_obj,canvas_frame)
  set tree $Page::($page_obj,tree)
  set HLIST [$tree subwidget hlist]
  set ent [$HLIST info selection]
  set index [string range $ent 2 [string length $ent]]
  PB_int_RetCmdBlks cmd_obj_list
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
   $canvas_frame.top.ent config -state normal
   $Page::($page_obj,text_widget) config -state normal
  } else \
  {
   $HLIST selection set 0
   $HLIST anchor set 0
   set index 0
   set pb_cmd_procname ""
   $canvas_frame.top.ent config -state disabled
   $Page::($page_obj,text_widget) config -state disabled
  }
  set cmd_obj [lindex $cmd_obj_list $index]
  if {[info exists Page::($page_obj,active_cmd_obj)]} \
  {
   if {$cmd_obj == $Page::($page_obj,active_cmd_obj)} \
   {
    return
   }
  }
  if { [info exists Page::($page_obj,active_cmd_obj)] } \
  {
   set active_cmd_obj $Page::($page_obj,active_cmd_obj)
   set act_index [lsearch $cmd_obj_list $active_cmd_obj]
   set ret_code [UI_PB_cmd_SaveCmdProc $page_obj]
   set cur_cmd_name "PB_CMD_${pb_cmd_procname}"
   if { $ret_code } \
   {
    $HLIST selection clear
    $HLIST anchor clear
    $HLIST selection set 0.$act_index
    $HLIST anchor set 0.$act_index
    tk_messageBox -parent [UI_PB_com_AskActiveWindow] -type ok \
    -icon error -message "Command \"$cur_cmd_name\" \
    exists, Use another name."
    return
   } else \
   {
    $HLIST entryconfigure 0.$act_index -text "$cur_cmd_name"
   }
   UI_PB_cmd_DeleteCmdProc $page_obj
   unset Page::($page_obj,active_cmd_obj)
  }
  if { $cmd_obj != "" } \
  {
   UI_PB_cmd_DisplayCmdBlkAttr page_obj cmd_obj
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
proc UI_PB_cmd_AddComponentsLeftPan { PAGE_OBJ } {
  upvar $PAGE_OBJ page_obj
  global gPB
  global paOption
  set left_pane $Page::($page_obj,left_pane_id)
  set but [frame $left_pane.f]
  set new [button $but.new -text "$gPB(tree,create,Label)" \
  -command "UI_PB_cmd_CreateACmdBlock $page_obj" \
  -bg $paOption(app_butt_bg)]
  set del [button $but.del -text "$gPB(tree,cut,Label)" \
  -command "UI_PB_cmd_CutACmdBlock $page_obj" \
  -bg $paOption(app_butt_bg)]
  set pas [button $but.pas -text "$gPB(tree,paste,Label)" \
  -command "UI_PB_cmd_PasteACmdBlock $page_obj" \
  -bg $paOption(app_butt_bg)]
  pack $new $del $pas -side left -fill x -expand yes
  pack $but -side top -fill x -padx 7
  set gPB(c_help,$new)   "tree,create"
  set gPB(c_help,$del)   "tree,cut"
  set gPB(c_help,$pas)   "tree,paste"
 }

#=======================================================================
proc UI_PB_cmd_CreateACmdBlock { page_obj } {
  if { ![info exists Page::($page_obj,active_cmd_obj)] } \
  {
   set act_cmd_obj 0
   set obj_index ""
  } else \
  {
   set ret_code [UI_PB_cmd_SaveCmdProc $page_obj]
   set act_cmd_obj $Page::($page_obj,active_cmd_obj)
   unset Page::($page_obj,active_cmd_obj)
   UI_PB_cmd_DeleteCmdProc $page_obj
  }
  PB_int_CreateCmdObj act_cmd_obj obj_index
  UI_PB_cmd_DisplayCmdBlocks page_obj obj_index
  UI_PB_cmd_CmdBlkItemSelection $page_obj
 }

#=======================================================================
proc UI_PB_cmd_CutACmdBlock { page_obj } {
  set tree $Page::($page_obj,tree)
  set HLIST [$tree subwidget hlist]
  set ent [$HLIST info selection]
  set obj_index [string range $ent 2 [string length $ent]]
  if { ![info exists Page::($page_obj,active_cmd_obj)] } \
  {
   return
  }
  set active_cmd_obj $Page::($page_obj,active_cmd_obj)
  if { $command::($active_cmd_obj,name) == "PB_CMD_before_motion" } \
  {
   set cmd_name $command::($active_cmd_obj,name)
   tk_messageBox  -parent [UI_PB_com_AskActiveWindow] -type ok \
   -icon warning \
   -message "Command \"$cmd_name\" is used by MOM_before_motion \
   Event. Command cannot be deleted."
   } elseif {$command::($active_cmd_obj,blk_elem_list) != ""} \
  {
   set cmd_name $command::($active_cmd_obj,name)
   tk_messageBox  -parent [UI_PB_com_AskActiveWindow] -type ok -icon error\
   -message "Command \"$cmd_name\" is used by an Event. \
   Command cannot be deleted"
  } else \
  {
   if { [info exists Page::($page_obj,buff_cmd_obj)] } \
   {
    delete $Page::($page_obj,buff_cmd_obj)
    unset Page::($page_obj,buff_cmd_obj)
   }
   set ret_code [UI_PB_cmd_SaveCmdProc $page_obj]
   UI_PB_cmd_DeleteCmdProc $page_obj
   set Page::($page_obj,buff_cmd_obj) $active_cmd_obj
   PB_int_CommandCutObject active_cmd_obj obj_index
   unset Page::($page_obj,active_cmd_obj)
   UI_PB_cmd_DisplayCmdBlocks page_obj obj_index
   UI_PB_cmd_CmdBlkItemSelection $page_obj
  }
 }

#=======================================================================
proc UI_PB_cmd_PasteACmdBlock { page_obj } {
  set tree $Page::($page_obj,tree)
  set HLIST [$tree subwidget hlist]
  set ent [$HLIST info selection]
  set obj_index [string range $ent 2 [string length $ent]]
  if {![info exists Page::($page_obj,buff_cmd_obj)]} \
  {
   return
  }
  set buff_cmd_obj $Page::($page_obj,buff_cmd_obj)
  set temp_index $obj_index
  PB_int_CmdBlockPasteObject buff_cmd_obj obj_index
  if { $temp_index != $obj_index } \
  {
   UI_PB_cmd_DisplayCmdBlocks page_obj obj_index
   UI_PB_cmd_CmdBlkItemSelection $page_obj
  }
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
  set ret_code [UI_PB_cmd_SaveCmdProc $page_obj]
  UI_PB_cmd_DeleteCmdProc $page_obj
  if { [info exists Page::($page_obj,active_cmd_obj)] } \
  {
   unset Page::($page_obj,active_cmd_obj)
  }
 }

#=======================================================================
proc UI_PB_cmd_CreateCmdBlkPage { PAGE_OBJ } {
  upvar $PAGE_OBJ page_obj
  global tixOption paOption
  global pb_cmd_procname
  set bg darkSeaGreen3
  set fg white
  set ft $tixOption(bold_font)
  set win $Page::($page_obj,canvas_frame)
  set top_frm [frame $win.top -relief flat -bg $bg]
  set mid_frm [frame $win.mid]
  set bot_frm [frame $win.bot -relief flat -bg $bg]
  pack $top_frm -side top -fill x
  pack $mid_frm -side top -fill both -expand yes
  pack $bot_frm -side top -fill x

#=======================================================================
label $top_frm.prc -text " proc    PB_CMD_" -fg $fg -bg $bg -font $ft
 entry $top_frm.ent -textvariable pb_cmd_procname -width 40
 bind $top_frm.ent <KeyPress> "UI_PB_com_DisableSpaceKey %W %K"
 bind $top_frm.ent <KeyRelease> { %W config -state normal }
 if { $pb_cmd_procname == "before_motion" } \
 {
  $top_frm.ent config -state disabled
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
  set Page::($page_obj,text_widget) $text_widget
  set Page::($page_obj,cmd_entry) $top_frm.ent
 label $bot_frm.brc -text "   \}" -fg $fg -bg $bg -font $ft
 pack $bot_frm.brc -side left -pady 10 -fill x
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
   set ret_code 0
   set cur_cmd_name PB_CMD_${pb_cmd_procname}
   set ret_code [PB_int_CheckForCmdBlk cmd_obj cur_cmd_name]
   if { $ret_code } \
   {
    tk_messageBox -parent [UI_PB_com_AskActiveWindow] -type ok \
    -icon error -message "Command \"$cur_cmd_name\" \
    exists, Use another name."
    return
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
  set ent_widget $Page::($page_obj,cmd_entry)
  if { $pb_cmd_procname == "before_motion" } \
  {
   bind $ent_widget <Return> ""
   $ent_widget config -state disabled
  } else \
  {
   bind $ent_widget <Return> "UI_PB_cmd_UpdateCmdName $page_obj"
   $ent_widget config -state normal
  }
 }

#=======================================================================
proc UI_PB_cmd_SeqEditCmdBlkCancel_CB { win page_obj seq_obj event_obj \
  elem_obj cmd_page_obj } {
  set block_obj $event_element::($elem_obj,block_obj)
  set bot_canvas $Page::($page_obj,bot_canvas)
  set blk_img_id $event_element::($elem_obj,icon_id)
  set img [lindex [$bot_canvas itemconfigure $blk_img_id -image] end]
  if { [UI_PB_evt_RetNoEvtElemsOfBlk block_obj] > 1 } \
  {
   $img config -relief raised -bg lightSkyBlue
  } else \
  {
   $img config -relief raised -bg white
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
  set ret_code [PB_int_CheckForCmdBlk cmd_obj cur_cmd_name]
  if { $ret_code } \
  {
   tk_messageBox -parent [UI_PB_com_AskActiveWindow] -type ok -icon error \
   -message "Command \"$cur_cmd_name\" exists, \
   Use another name."
   return
  }
  UI_PB_cmd_GetProcFromTextWin $cmd_page_obj proc_text
  if { $cur_cmd_name != "$command::($cmd_obj,name)" } \
  {
   PB_int_RemoveCmdProcFromlist cmd_obj
   set block::($block_obj,block_name) $cur_cmd_name
   set command::($cmd_obj,name) $cur_cmd_name
   PB_int_UpdateCommandAdd cmd_obj
   UI_PB_evt_CreateMenuOptions page_obj seq_obj
  }
  set command::($cmd_obj,proc) $proc_text
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
proc UI_PB_cmd_SeqNewCmdBlkOk_CB { win page_obj seq_obj elem_obj \
  cmd_page_obj } {
  global tixOption
  global pb_cmd_procname
  global gPB
  set block_obj $event_element::($elem_obj,block_obj)
  set cmd_blk_elem [lindex $block::($block_obj,elem_addr_list) 0]
  set cmd_obj $block_element::($cmd_blk_elem,elem_mom_variable)
  set cur_cmd_name PB_CMD_$pb_cmd_procname
  set ret_code [PB_int_CheckForCmdBlk cmd_obj cur_cmd_name]
  if { $ret_code } \
  {
   tk_messageBox -parent [UI_PB_com_AskActiveWindow] -type ok -icon error \
   -message "Command \"$cur_cmd_name\" exists, \
   Use another name."
   return
  }
  UI_PB_cmd_GetProcFromTextWin $cmd_page_obj proc_text
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
  $img config -relief raised -bg white
  PB_int_UpdateCommandAdd cmd_obj
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
  set ret_code [PB_int_CheckForCmdBlk cmd_obj cur_cmd_name]
  if { $ret_code } \
  {
   tk_messageBox -parent [UI_PB_com_AskActiveWindow] -type ok -icon error \
   -message "Command \"$cur_cmd_name\" exists, \
   Use another name."
   return
  }
  UI_PB_cmd_GetProcFromTextWin $cmd_page_obj proc_text
  if { $cur_cmd_name != "$command::($cmd_obj,name)" } \
  {
   PB_int_RemoveCmdProcFromlist cmd_obj
   set block::($cmd_blk_obj,block_name) $cur_cmd_name
   set command::($cmd_obj,name) $cur_cmd_name
   PB_int_UpdateCommandAdd cmd_obj
   UI_PB_blk_CreateMenuOptions page_obj event
  }
  set command::($cmd_obj,proc) $proc_text
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
proc UI_PB_cmd_tpthCmdBlkOk_CB { win page_obj event_obj evt_elem_obj \
  blk_elem_obj cmd_page_obj } {
  global tixOption
  global pb_cmd_procname
  global gPB
  set block_obj $event_element::($evt_elem_obj,block_obj)
  set cmd_obj $block_element::($blk_elem_obj,elem_mom_variable)
  set cur_cmd_name PB_CMD_$pb_cmd_procname
  set ret_code [PB_int_CheckForCmdBlk cmd_obj cur_cmd_name]
  if { $ret_code } \
  {
   tk_messageBox -parent [UI_PB_com_AskActiveWindow] -type ok -icon error \
   -message "Command \"$cur_cmd_name\" exits, \
   Use another name."
   return
  }
  UI_PB_cmd_GetProcFromTextWin $cmd_page_obj proc_text
  set block::($block_obj,block_name) $cur_cmd_name
  set command::($cmd_obj,name) $cur_cmd_name
  set command::($cmd_obj,proc) $proc_text
  command::readvalue $cmd_obj cmd_obj_attr
  command::DefaultValue $cmd_obj cmd_obj_attr
  set block_element::($blk_elem_obj,elem_desc) \
  "$gPB(block,cmd,word_desc,Label)"
  PB_int_UpdateCommandAdd cmd_obj
  set base_addr $block_element::($blk_elem_obj,elem_mom_variable)
  UI_PB_blk_ReplaceIcon page_obj $base_addr $blk_elem_obj
  UI_PB_blk_CreateMenuOptions page_obj event
  destroy $win
  delete $cmd_page_obj
 }

#=======================================================================
proc UI_PB_cmd_CreateCommentDlgParam { win page_obj blk_elem_obj } {
  global mom_sys_arr
  global pb_comment
  set pb_comment $block_element::($blk_elem_obj,elem_mom_variable)
  set bg darkSeaGreen3
  set fg white
  set top_frm [frame $win.top -relief flat -bg $bg]
  pack $top_frm -side top -fill both -expand yes
  label $top_frm.strt -text "$mom_sys_arr(Comment_Start)" -bg $bg -fg $fg
  grid $top_frm.strt -row 1 -column 1 -padx 5 -pady 10
  entry $top_frm.ent -textvariable pb_comment -width 40
  grid $top_frm.ent -row 1 -column 2
  label $top_frm.end -text "$mom_sys_arr(Comment_End)" -bg $bg -fg $fg
  grid $top_frm.end -row 1 -column 3 -padx 5 -pady 10
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
proc UI_PB_cmd_SeqNewCommentOk_CB { win page_obj seq_obj elem_obj } {
  global tixOption
  global pb_comment
  global mom_sys_arr
  global gPB
  if { $pb_comment == "" } \
  {
   tk_messageBox -parent [UI_PB_com_AskActiveWindow] -type ok -icon error \
   -message "$gPB(opr_msg,empty_operator)"
   return
  }
  set block_obj $event_element::($elem_obj,block_obj)
  set blk_elem [lindex $block::($block_obj,elem_addr_list) 0]
  set block_element::($blk_elem,elem_mom_variable) $pb_comment
  set block_element::($blk_elem,elem_desc) "$gPB(block,oper,word_desc,Label)"
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
  $img config -relief raised -bg white
  destroy $win
 }

#=======================================================================
proc UI_PB_cmd_SeqEditCommentCancel_CB { win page_obj seq_obj event_obj \
  elem_obj } {
  set block_obj $event_element::($elem_obj,block_obj)
  set bot_canvas $Page::($page_obj,bot_canvas)
  set blk_img_id $event_element::($elem_obj,icon_id)
  set img [lindex [$bot_canvas itemconfigure $blk_img_id -image] end]
  $img config -relief raised -bg white
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
