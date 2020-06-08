#24

#=======================================================================
proc UI_PB_prog_DisableWindow { CHAP } {
  upvar  $CHAP chap
  global gPB
  set sect    $Page::($chap,book_obj)
  set sect_id $Book::($sect,book_id)
  set gPB($sect_id,b1_cb) [bind [$sect_id subwidget nbframe] <1>]
  bind [$sect_id subwidget nbframe] <1> UI_PB_com_disabledTabMsg
  $sect_id pageconfig prog -state disabled
  $sect_id pageconfig gcod -state disabled
  $sect_id pageconfig mcod -state disabled
  $sect_id pageconfig asum -state disabled
  $sect_id pageconfig wseq -state disabled
  set sty_n  $gPB(font_style_normal)
  set sty_b  $gPB(font_style_bold)
  set sty_ng $gPB(font_style_normal_gray)
  set sty_bg $gPB(font_style_bold_gray)
  set page_tab $Book::($sect,current_tab)
  set page_obj [lindex $Book::($sect,page_obj_list) $page_tab]
  set page_tab $Book::($sect,current_tab)
  if { $page_tab == 0 } \
  {
   set t $Page::($page_obj,tree)
   set h [$t subwidget hlist]
   UI_PB_com_DisableTree $h [$h info children 0] GRAY
  }
 }

#=======================================================================
proc UI_PB_prog_EnableWindow { CHAP } {
  upvar  $CHAP chap
  global gPB
  set sect    $Page::($chap,book_obj)
  set sect_id $Book::($sect,book_id)
  bind [$sect_id subwidget nbframe] <1> $gPB($sect_id,b1_cb)
  $sect_id pageconfig prog -state normal
  $sect_id pageconfig gcod -state normal
  $sect_id pageconfig mcod -state normal
  $sect_id pageconfig asum -state normal
  $sect_id pageconfig wseq -state normal
  if { $Book::($sect,current_tab) == 0 } \
  {
   set page_obj [lindex $Book::($sect,page_obj_list) 0]
   set t $Page::($page_obj,tree)
   set h [$t subwidget hlist]
   UI_PB_com_EnableTree $h [$h info children 0]
  }
 }

#=======================================================================
proc UI_PB_ProgTpth_Program {book_id prog_page} {
  global paOption
  global tixOption
  global mom_sys_arr
  global gPB
  set Page::($prog_page,page_id) [$book_id subwidget \
  $Page::($prog_page,page_name)]
  set top_canvas_dim(0) 80
  set top_canvas_dim(1) 400
  set bot_canvas_dim(0) 2000
  set bot_canvas_dim(1) 2000
  set index 0
  PB_int_RetSequenceObjs seq_obj_list
  set Page::($prog_page,seq_obj_list) $seq_obj_list
  set Page::($prog_page,event_list) {}
  Page::CreatePane $prog_page
  Page::CreateTree $prog_page
  UI_PB_evt_CreateTree prog_page
  set canvas_frm $Page::($prog_page,canvas_frame)
  set nc_frm [frame $canvas_frm.nc -bg royalBlue]
  pack $nc_frm -side top -fill x
  checkbutton $nc_frm.bnc -text $gPB(prog,seq_comb_nc,Label) \
  -anchor c -padx 5 -pady 3 \
  -relief solid -bd 1 -font $tixOption(bold_font) \
  -variable mom_sys_arr(seq_blk_nc_code) -anchor c \
  -command "UI_PB_evt_ChangeSeqDisplay $prog_page"
  pack $nc_frm.bnc -pady 6
  global gPB
  set gPB(c_help,$nc_frm.bnc)      "prog,seq_comb_nc"
  set Page::($prog_page,disp_nc_frm) $nc_frm
  set Page::($prog_page,disp_nc_flag) 0
  Page::CreateCanvas $prog_page top_canvas_dim bot_canvas_dim
  set box_frame $Page::($prog_page,box)
  set box [tixButtonBox $box_frame.box -orientation horizontal \
  -bd 2 -relief sunken -bg gray]
  $box add seqtmp -width 30 -text "$gPB(prog,oper_temp,Label)" \
  -bg $paOption(app_butt_bg)
  pack $box -side bottom -fill x
  set Page::($prog_page,box_flag) 0
  set canvas_frame $Page::($prog_page,canvas_frame)
  set label_list {"gPB(nav_button,default,Label)" \
  "gPB(nav_button,restore,Label)"}
  set cb_arr(gPB(nav_button,default,Label)) \
  "UI_PB_evt_DefaultCallBack $prog_page"
  set cb_arr(gPB(nav_button,restore,Label)) \
  "UI_PB_evt_RestoreCallBack $prog_page"
  UI_PB_com_CreateButtonBox $canvas_frame label_list cb_arr
  set Page::($prog_page,act_box) $canvas_frame.box
  set Page::($prog_page,act_box_flag) 0
  set Page::($prog_page,add_name) " $gPB(prog,add_block,Label) "
  Page::CreateAddTrashinCanvas $prog_page
  UI_PB_evt_CreateComboBox $prog_page
  UI_PB_evt_AddBindProcs prog_page
  Page::AddComponents $prog_page
  UI_PB_evt_SetASequenceAttr $prog_page 0
  UI_PB_evt_CreatePopupMenu $prog_page
  set Page::($prog_page,buff_blk_obj) ""
  set Page::($prog_page,copy_flag) 0
  update idletasks
 }

#=======================================================================
proc UI_PB_evt_CreateComboBox { page_obj } {
  set top_canvas $Page::($page_obj,top_canvas)
  set evt_frm [frame $top_canvas.f]
  $top_canvas create window 350 40 -window $evt_frm
  set blk_sel [tixComboBox $evt_frm.blk_sel \
  -dropdown   yes \
  -editable   false \
  -variable   CB_Block_Name \
  -command    "" \
  -grab       local \
  -listwidth  335 \
  -options {
   listbox.height   10
   listbox.anchor   c
   entry.width      38
  }]
  pack $evt_frm.blk_sel -side right
  set Page::($page_obj,comb_widget) $blk_sel
 }

#=======================================================================
proc UI_PB_evt_CreatePopupMenu { page_obj } {
  global tixOption
  global paOption
  set bot_canvas $Page::($page_obj,bot_canvas)
  option add *Menu.tearOff   0
  set popup [menu $bot_canvas.pop]
  set Page::($page_obj,popup) $popup
  set Page::($page_obj,popup_flag) 0
  $popup add separator
  bind $bot_canvas <3> "UI_PB_evt_CanvasPopupMenu $page_obj %X %Y"
 }

#=======================================================================
proc UI_PB_evt_CanvasPopupMenu { page_obj x y } {
  global gPB
  set popup $Page::($page_obj,popup)
  if { $Page::($page_obj,popup_flag) == 1} \
  {
   set Page::($page_obj,popup_flag) 0
   tk_popup $popup $x $y
  } else \
  {
   $popup delete 0 end
   $popup add command -label "$gPB(prog,undo_popup,Label)" -state disabled
  }
 }

#=======================================================================
proc UI_PB_evt_ChangeSeqDisplay { page_obj } {
  global mom_sys_arr
  set act_seq_obj $Page::($page_obj,active_seq)
  set bot_canvas $Page::($page_obj,bot_canvas)
  if { $mom_sys_arr(seq_blk_nc_code) } \
  {
   set cur_code 1
   set mom_sys_arr(seq_blk_nc_code) 0
  } else \
  {
   set cur_code 0
   set mom_sys_arr(seq_blk_nc_code) 1
  }
  UI_PB_evt_DeleteSeqEvents page_obj act_seq_obj
  set mom_sys_arr(seq_blk_nc_code) $cur_code
  UI_PB_evt_SetSequenceObjAttr act_seq_obj
  UI_PB_evt_TopCanvasPackUnpack page_obj
  if { $mom_sys_arr(seq_blk_nc_code) == 1 } \
  {
   bind $bot_canvas <3> ""
  } else \
  {
   bind $bot_canvas <3> "UI_PB_evt_CanvasPopupMenu $page_obj %X %Y"
  }
  UI_PB_evt_CreateSeqAttributes page_obj
 }

#=======================================================================
proc UI_PB_evt_DeleteChangeEvtElems { EVENT_OBJ } {
  upvar $EVENT_OBJ event_obj
  array set rest_evt_obj_attr $event::($event_obj,rest_value)
  array set def_evt_obj_attr $event::($event_obj,def_value)
  set evt_elem_list ""
  set no_rows [llength $event::($event_obj,evt_elem_list)]
  for { set count 0 } { $count < $no_rows } { incr count } \
  {
   set new_row_list ""
   set row_elems [lindex $event::($event_obj,evt_elem_list) $count]
   foreach elem_obj $row_elems \
   {
    set def_flag 0
    foreach def_row $def_evt_obj_attr(2) \
    {
     if { [lsearch $def_row $elem_obj] != -1 } \
     {
      set def_flag 1
      break
     }
    }
    set rest_flag 0
    foreach rest_row $rest_evt_obj_attr(2) \
    {
     if { [lsearch $rest_row $elem_obj] != -1 } \
     {
      set rest_flag 1
      break
     }
    }
    if { $rest_flag == 0 && $def_flag == 0 } \
    {
     set block_obj $event_element::($elem_obj,block_obj)
     if { $block::($block_obj,blk_type) == "command" } \
     {
      delete $block_obj
      } elseif { $block::($block_obj,blk_type) == "comment" } \
     {
      PB_int_DeleteCommentBlkFromList block_obj
      delete $block_obj
     }
     delete $elem_obj
    } else \
    {
     lappend new_row_list $elem_obj
    }
   }
   lappend evt_elem_list $new_row_list
  }
  set event::($event_obj,evt_elem_list) $evt_elem_list
 }

#=======================================================================
proc UI_PB_evt_RestoreCallBack { page_obj } {
  UI_PB_evt_GetSequenceIndex page_obj seq_index
  set seq_obj [lindex $Page::($page_obj,seq_obj_list) $seq_index]
  UI_PB_evt_DeleteObjectsPrevSeq page_obj
  UI_PB_evt_SetSequenceObjAttr seq_obj
  foreach event_obj $sequence::($seq_obj,evt_obj_list) \
  {
   foreach act_evt_elem $event::($event_obj,evt_elem_list) \
   {
    foreach evt_elem $act_evt_elem \
    {
     set block_obj $event_element::($evt_elem,block_obj)
     block::DeleteFromEventElemList $block_obj evt_elem
     if { $block::($block_obj,blk_type) == "command" } \
     {
      set cmd_blk_elem [lindex $block::($block_obj,elem_addr_list) 0]
      set cmd_obj $block_element::($cmd_blk_elem,elem_mom_variable)
      if { [string match "*MOM*" $cmd_obj] == 0 } \
      {
       command::DeleteFromBlkElemList $cmd_obj cmd_blk_elem
      }
     }
    }
   }
   UI_PB_evt_DeleteChangeEvtElems event_obj
   array set evt_obj_attr $event::($event_obj,rest_value)
   event::setvalue $event_obj evt_obj_attr
   foreach row_evt_elem $event::($event_obj,evt_elem_list) \
   {
    foreach evt_elem $row_evt_elem \
    {
     array set evt_elem_obj_attr $event_element::($evt_elem,rest_value)
     event_element::setvalue $evt_elem evt_elem_obj_attr
     set block_obj $evt_elem_obj_attr(1)
     block::AddToEventElemList $block_obj evt_elem
     if { $block::($block_obj,blk_type) == "command" } \
     {
      set cmd_blk_elem [lindex $block::($block_obj,elem_addr_list) 0]
      set cmd_obj $block_element::($cmd_blk_elem,elem_mom_variable)
      if { [string match "*MOM*" $cmd_obj] == 0 } \
      {
       command::AddToBlkElemList $cmd_obj cmd_blk_elem
      }
     }
    }
   }
  }
  UI_PB_evt_CreateSeqAttributes page_obj
 }

#=======================================================================
proc UI_PB_evt_DefaultCallBack { page_obj } {
  UI_PB_evt_GetSequenceIndex page_obj seq_index
  set seq_obj [lindex $Page::($page_obj,seq_obj_list) $seq_index]
  UI_PB_evt_DeleteObjectsPrevSeq page_obj
  UI_PB_evt_SetSequenceObjAttr seq_obj
  foreach event_obj $sequence::($seq_obj,evt_obj_list) \
  {
   foreach act_evt_elem $event::($event_obj,evt_elem_list) \
   {
    foreach evt_elem $act_evt_elem \
    {
     set block_obj $event_element::($evt_elem,block_obj)
     block::DeleteFromEventElemList $block_obj evt_elem
     if { $block::($block_obj,blk_type) == "command" } \
     {
      set cmd_blk_elem [lindex $block::($block_obj,elem_addr_list) 0]
      set cmd_obj $block_element::($cmd_blk_elem,elem_mom_variable)
      if { [string match "*MOM*" $cmd_obj] == 0 } \
      {
       command::DeleteFromBlkElemList $cmd_obj cmd_blk_elem
      }
     }
    }
   }
   UI_PB_evt_DeleteChangeEvtElems event_obj
   array set evt_obj_attr $event::($event_obj,def_value)
   event::setvalue $event_obj evt_obj_attr
   foreach row_evt_elem $event::($event_obj,evt_elem_list) \
   {
    foreach evt_elem $row_evt_elem \
    {
     array set evt_elem_obj_attr $event_element::($evt_elem,def_value)
     event_element::setvalue $evt_elem evt_elem_obj_attr
     set block_obj $evt_elem_obj_attr(1)
     block::AddToEventElemList $block_obj evt_elem
     if { $block::($block_obj,blk_type) == "command" } \
     {
      set cmd_blk_elem [lindex $block::($block_obj,elem_addr_list) 0]
      set cmd_obj $block_element::($cmd_blk_elem,elem_mom_variable)
      if { [string match "*MOM*" $cmd_obj] == 0 } \
      {
       command::AddToBlkElemList $cmd_obj cmd_blk_elem
      }
     }
    }
   }
  }
  UI_PB_evt_CreateSeqAttributes page_obj
 }

#=======================================================================
proc UI_PB_evt_prog {PAGE_OBJ} {
  upvar $PAGE_OBJ page_obj
  set Page::($page_obj,glob_evnt_dim) {170 26}
  set Page::($page_obj,glob_blk_dim) {170 25}
  set Page::($page_obj,glob_blk_blkdist_hor) 20
  set Page::($page_obj,glob_blk_blkdist_ver) 25
  set Page::($page_obj,glob_evt_blkdist) 30
  set Page::($page_obj,glob_evt_evtdist) 30
  set Page::($page_obj,glob_text_shift) 10
  set Page::($page_obj,glob_rect_gap) 3
  set Page::($page_obj,prev_seq) -1
  set Page::($page_obj,cen_shift) 4
  set Page::($page_obj,topcanvas_flag) 0
  set Page::($page_obj,drag_sensitivity) 3
  set tree $Page::($page_obj,tree)
  set sec_frm $Page::($page_obj,canvas_frame)
 }

#=======================================================================
proc UI_PB_evt_CreateTree {PAGE_OBJ} {
  upvar $PAGE_OBJ page_obj
  global paOption
  global tixOption
  global gPB
  set tree $Page::($page_obj,tree)
  set sec_frm $Page::($page_obj,canvas_frame)
  $tree config \
  -command "UI_PB_evt_progItemSelection $page_obj" \
  -browsecmd "UI_PB_evt_progItemSelection $page_obj"
  set h [$tree subwidget hlist]
  $h config -bg $paOption(tree_bg)
  uplevel #0 set TRANSPARENT_GIF_COLOR [$h cget -bg]
  set file   $paOption(file)
  set folder $paOption(folder)
  set seq    [tix getimage pb_sequence]
  set subseq [tix getimage pb_sub_seq]
  set style  $gPB(font_style_bold)
  set style1 $gPB(font_style_normal)
  $h add 0     -itemtype imagetext -text "" -image $folder -state disabled
  $h add 0.0   -itemtype imagetext -text "$gPB(prog,tree,prog_strt,Label)" \
  -image $seq    -style $style
  $h add 0.1   -itemtype imagetext -text "$gPB(prog,tree,oper_strt,Label)" \
  -image $seq    -style $style
  $h add 0.2   -itemtype imagetext -text "$gPB(prog,tree,tool_path,Label)" \
  -image $seq    -style $style
  $h add 0.2.0 -itemtype imagetext \
  -text "$gPB(prog,tree,tool_path,mach_cnt,Label)" \
  -image $subseq -style $style1
  $h add 0.2.1 -itemtype imagetext \
  -text "$gPB(prog,tree,tool_path,motion,Label)" \
  -image $subseq -style $style1
  $h add 0.2.2 -itemtype imagetext \
  -text "$gPB(prog,tree,tool_path,cycle,Label)" \
  -image $subseq -style $style1
  $h add 0.3 -itemtype imagetext -text "$gPB(prog,tree,oper_end,Label)" \
  -image $seq -style $style
  $h add 0.4 -itemtype imagetext -text "$gPB(prog,tree,prog_end,Label)" \
  -image $seq  -style $style
  $h selection set 0.0
  $h anchor set 0.0
 }

#=======================================================================
proc UI_PB_evt_GetSequenceIndex { PAGE_OBJ SEQ_INDEX } {
  upvar $PAGE_OBJ page_obj
  upvar $SEQ_INDEX seq_index
  switch $Page::($page_obj,prev_seq) \
  {
   0    { set seq_index 0 }
   1    { set seq_index 1 }
   2    { set seq_index 2 }
   2.1  { set seq_index 3 }
   2.2  { set seq_index 4 }
   3    { set seq_index 5 }
   4    { set seq_index 6 }
  }
 }

#=======================================================================
proc UI_PB_evt_DeleteObjectsPrevSeq { PAGE_OBJ } {
  upvar $PAGE_OBJ page_obj
  UI_PB_evt_GetSequenceIndex page_obj prev_seq_index
  set prev_seq_obj [lindex $Page::($page_obj,seq_obj_list) \
  $prev_seq_index]
  UI_PB_evt_DeleteSeqEvents page_obj prev_seq_obj
  if {[info exists sequence::($prev_seq_obj,comb_text)]}\
  {
   $Page::($page_obj,top_canvas) delete \
   $sequence::($prev_seq_obj,comb_text)
  }
 }

#=======================================================================
proc UI_PB_evt_CreateSeqAttributes { PAGE_OBJ } {
  upvar $PAGE_OBJ page_obj
  grab set $Page::($page_obj,page_id)
  switch $Page::($page_obj,prev_seq) \
  {
   0  {
    set seq_obj [lindex $Page::($page_obj,seq_obj_list) 0]
    UI_PB_evt_SeqComponents page_obj seq_obj
    set Page::($page_obj,active_seq) $seq_obj
   }
   1  {
    set seq_obj [lindex $Page::($page_obj,seq_obj_list) 1]
    UI_PB_evt_SeqComponents page_obj seq_obj
    set Page::($page_obj,active_seq) $seq_obj
   }
   2  {
    set seq_obj [lindex $Page::($page_obj,seq_obj_list) 2]
    UI_PB_evt_ToolPathSeqComponents page_obj seq_obj
    set Page::($page_obj,active_seq) $seq_obj
   }
   2.1 {
    set seq_obj [lindex $Page::($page_obj,seq_obj_list) 3]
    UI_PB_evt_ToolPathSeqComponents page_obj seq_obj
    set Page::($page_obj,active_seq) $seq_obj
   }
   2.2 {
    set seq_obj [lindex $Page::($page_obj,seq_obj_list) 4]
    UI_PB_evt_ToolPathSeqComponents page_obj seq_obj
    set Page::($page_obj,active_seq) $seq_obj
   }
   3  {
    set seq_obj [lindex $Page::($page_obj,seq_obj_list) 5]
    UI_PB_evt_SeqComponents page_obj seq_obj
    set Page::($page_obj,active_seq) $seq_obj
   }
   4  {
    set seq_obj [lindex $Page::($page_obj,seq_obj_list) 6]
    UI_PB_evt_SeqComponents page_obj seq_obj
    set Page::($page_obj,active_seq) $seq_obj
   }
  }
  grab release $Page::($page_obj,page_id)
 }

#=======================================================================
proc UI_PB_evt_RestoreSeqObjData { SEQ_OBJ } {
  upvar $SEQ_OBJ seq_obj
  sequence::RestoreValue $seq_obj
  foreach event_obj $sequence::($seq_obj,evt_obj_list) \
  {
   event::RestoreValue $event_obj
   foreach row_evt_elem $event::($event_obj,evt_elem_list) \
   {
    foreach evt_elem $row_evt_elem \
    {
     event_element::RestoreValue $evt_elem
    }
   }
  }
 }

#=======================================================================
proc UI_PB_evt_TopCanvasPackUnpack { PAGE_OBJ } {
  upvar $PAGE_OBJ page_obj
  global mom_sys_arr
  if { $mom_sys_arr(seq_blk_nc_code) == 1 && \
  $Page::($page_obj,topcanvas_flag) == 0} \
  {
   pack forget $Page::($page_obj,top_canvas)
   set Page::($page_obj,topcanvas_flag) 1
   } elseif { $mom_sys_arr(seq_blk_nc_code) == 0 && \
  $Page::($page_obj,topcanvas_flag) == 1} \
  {
   pack forget $Page::($page_obj,bot_canvas)
   pack forget $Page::($page_obj,ver_scrol)
   pack $Page::($page_obj,top_canvas) -side top -fill x -padx 3
   set Page::($page_obj,topcanvas_flag) 0
   pack $Page::($page_obj,bot_canvas) -side left -expand yes \
   -fill both -padx 3
   pack $Page::($page_obj,ver_scrol) -side right -fill y
  }
 }

#=======================================================================
proc UI_PB_evt_PackDispNcFrame { PAGE_OBJ } {
  upvar $PAGE_OBJ page_obj
  if { $Page::($page_obj,disp_nc_flag) } \
  {
   pack forget $Page::($page_obj,canvas_frame).frame
   pack $Page::($page_obj,disp_nc_frm) -side top -fill x
   pack $Page::($page_obj,canvas_frame).frame \
   -side top -fill both -expand yes
   set Page::($page_obj,disp_nc_flag) 0
  }
 }

#=======================================================================
proc UI_PB_evt_UnpackDispNcFrame { PAGE_OBJ } {
  upvar $PAGE_OBJ page_obj
  if { $Page::($page_obj,disp_nc_flag) == 0 } \
  {
   pack forget $Page::($page_obj,disp_nc_frm)
   set Page::($page_obj,disp_nc_flag) 1
  }
 }

#=======================================================================
proc UI_PB_evt_ProgStartSeq { PAGE_OBJ } {
  upvar $PAGE_OBJ page_obj
  global mom_sys_arr
  if { $Page::($page_obj,prev_seq) == -1 } \
  {
   set seq_obj [lindex $Page::($page_obj,seq_obj_list) 0]
   UI_PB_evt_SetSequenceObjAttr seq_obj
   set Page::($page_obj,prev_seq) 0
   UI_PB_evt_TopCanvasPackUnpack page_obj
   if {$Page::($page_obj,box_flag) == 0} \
   {
    pack forget $Page::($page_obj,box)
    set Page::($page_obj,box_flag) 1
   }
  } else \
  {
   UI_PB_evt_DeleteObjectsPrevSeq page_obj
   UI_PB_evt_PackDispNcFrame page_obj
   if {$Page::($page_obj,act_box_flag) == 1}\
   {
    pack $Page::($page_obj,act_box) -side bottom -fill x \
    -padx 3 -pady 3
    set Page::($page_obj,act_box_flag) 0
   }
   if {$Page::($page_obj,box_flag) == 0} \
   {
    pack forget $Page::($page_obj,box)
    set Page::($page_obj,box_flag) 1
   }
   set Page::($page_obj,prev_seq) 0
   set seq_obj [lindex $Page::($page_obj,seq_obj_list) 0]
   UI_PB_evt_SetSequenceObjAttr seq_obj
   UI_PB_evt_TopCanvasPackUnpack page_obj
   $Page::($page_obj,bot_canvas) yview moveto 0
  }
 }

#=======================================================================
proc UI_PB_evt_OperStartSeq { PAGE_OBJ } {
  upvar $PAGE_OBJ page_obj
  global mom_sys_arr
  UI_PB_evt_DeleteObjectsPrevSeq page_obj
  set seq_obj [lindex $Page::($page_obj,seq_obj_list) 1]
  UI_PB_evt_SetSequenceObjAttr seq_obj
  set Page::($page_obj,prev_seq) 1
  UI_PB_evt_PackDispNcFrame page_obj
  UI_PB_evt_TopCanvasPackUnpack page_obj
  if {$Page::($page_obj,act_box_flag) == 1}\
  {
   pack $Page::($page_obj,act_box) -side bottom -fill x \
   -padx 3 -pady 3
   set Page::($page_obj,act_box_flag) 0
  }
  if {$Page::($page_obj,box_flag) == 1} \
  {
  }
  $Page::($page_obj,bot_canvas) yview moveto 0
  $Page::($page_obj,bot_canvas) xview moveto 0
 }

#=======================================================================
proc UI_PB_evt_MachineControl { PAGE_OBJ } {
  upvar $PAGE_OBJ page_obj
  UI_PB_evt_DeleteObjectsPrevSeq page_obj
  set seq_obj [lindex $Page::($page_obj,seq_obj_list) 2]
  UI_PB_evt_SetSequenceObjAttr seq_obj
  set Page::($page_obj,prev_seq) 2
  UI_PB_evt_UnpackDispNcFrame page_obj
  if {$Page::($page_obj,topcanvas_flag) == 0} \
  {
   pack forget $Page::($page_obj,top_canvas)
   set Page::($page_obj,topcanvas_flag) 1
  }
  set sequence::($seq_obj,ude_flag) 1
  if {$Page::($page_obj,act_box_flag) == 0}\
  {
   pack forget $Page::($page_obj,act_box)
   set Page::($page_obj,act_box_flag) 1
  }
  if {$Page::($page_obj,box_flag) == 0} \
  {
   pack forget $Page::($page_obj,box)
   set Page::($page_obj,box_flag) 1
  }
  $Page::($page_obj,bot_canvas) yview moveto 0
  $Page::($page_obj,bot_canvas) xview moveto 0
 }

#=======================================================================
proc UI_PB_evt_Cycles { PAGE_OBJ } {
  upvar $PAGE_OBJ page_obj
  UI_PB_evt_DeleteObjectsPrevSeq page_obj
  set seq_obj [lindex $Page::($page_obj,seq_obj_list) 3]
  UI_PB_evt_SetSequenceObjAttr seq_obj
  set Page::($page_obj,prev_seq) 2.1
  UI_PB_evt_UnpackDispNcFrame page_obj
  if {$Page::($page_obj,topcanvas_flag) == 0} \
  {
   pack forget $Page::($page_obj,top_canvas)
   set Page::($page_obj,topcanvas_flag) 1
  }
  set sequence::($seq_obj,ude_flag) 0
  if {$Page::($page_obj,act_box_flag) == 0}\
  {
   pack forget $Page::($page_obj,act_box)
   set Page::($page_obj,act_box_flag) 1
  }
  if {$Page::($page_obj,box_flag) == 0} \
  {
   pack forget $Page::($page_obj,box)
   set Page::($page_obj,box_flag) 1
  }
  $Page::($page_obj,bot_canvas) yview moveto 0
  $Page::($page_obj,bot_canvas) xview moveto 0
 }

#=======================================================================
proc UI_PB_evt_Motion { PAGE_OBJ } {
  upvar $PAGE_OBJ page_obj
  UI_PB_evt_DeleteObjectsPrevSeq page_obj
  set seq_obj [lindex $Page::($page_obj,seq_obj_list) 4]
  UI_PB_evt_SetSequenceObjAttr seq_obj
  set Page::($page_obj,prev_seq) 2.2
  UI_PB_evt_UnpackDispNcFrame page_obj
  if {$Page::($page_obj,topcanvas_flag) == 0} \
  {
   pack forget $Page::($page_obj,top_canvas)
   set Page::($page_obj,topcanvas_flag) 1
  }
  set sequence::($seq_obj,ude_flag) 0
  if {$Page::($page_obj,act_box_flag) == 0}\
  {
   pack forget $Page::($page_obj,act_box)
   set Page::($page_obj,act_box_flag) 1
  }
  if {$Page::($page_obj,box_flag) == 0} \
  {
   pack forget $Page::($page_obj,box)
   set Page::($page_obj,box_flag) 1
  }
  $Page::($page_obj,bot_canvas) yview moveto 0
  $Page::($page_obj,bot_canvas) xview moveto 0
 }

#=======================================================================
proc UI_PB_evt_UserDefined { PAGE_OBJ } {
  upvar $PAGE_OBJ page_obj
  UI_PB_evt_DeleteObjectsPrevSeq page_obj
 }

#=======================================================================
proc UI_PB_evt_OperEndSeq { PAGE_OBJ } {
  upvar $PAGE_OBJ page_obj
  global mom_sys_arr
  UI_PB_evt_DeleteObjectsPrevSeq page_obj
  set seq_obj [lindex $Page::($page_obj,seq_obj_list) 5]
  UI_PB_evt_SetSequenceObjAttr seq_obj
  UI_PB_evt_PackDispNcFrame page_obj
  UI_PB_evt_TopCanvasPackUnpack page_obj
  set Page::($page_obj,prev_seq) 3
  if {$Page::($page_obj,act_box_flag) == 1}\
  {
   pack $Page::($page_obj,act_box) -side bottom -fill x \
   -padx 3 -pady 3
   set Page::($page_obj,act_box_flag) 0
  }
  if {$Page::($page_obj,box_flag) == 0} \
  {
   pack forget $Page::($page_obj,box)
   set Page::($page_obj,box_flag) 1
  }
  $Page::($page_obj,bot_canvas) yview moveto 0
  $Page::($page_obj,bot_canvas) xview moveto 0
 }

#=======================================================================
proc UI_PB_evt_ProgEndSeq { PAGE_OBJ } {
  upvar $PAGE_OBJ page_obj
  global mom_sys_arr
  UI_PB_evt_DeleteObjectsPrevSeq page_obj
  set seq_obj [lindex $Page::($page_obj,seq_obj_list) 6]
  UI_PB_evt_SetSequenceObjAttr seq_obj
  UI_PB_evt_PackDispNcFrame page_obj
  UI_PB_evt_TopCanvasPackUnpack page_obj
  set Page::($page_obj,prev_seq) 4
  if {$Page::($page_obj,act_box_flag) == 1}\
  {
   pack $Page::($page_obj,act_box) -side bottom -fill x \
   -padx 3 -pady 3
   set Page::($page_obj,act_box_flag) 0
  }
  if {$Page::($page_obj,box_flag) == 0} \
  {
   pack forget $Page::($page_obj,box)
   set Page::($page_obj,box_flag) 1
  }
  $Page::($page_obj,bot_canvas) yview moveto 0
  $Page::($page_obj,bot_canvas) xview moveto 0
 }

#=======================================================================
proc UI_PB_evt_DeleteApplyEvtElemsOfSeq { PAGE_OBJ } {
  upvar $PAGE_OBJ page_obj
  UI_PB_evt_GetSequenceIndex page_obj seq_index
  set seq_obj [lindex $Page::($page_obj,seq_obj_list) $seq_index]
  foreach evt_obj $sequence::($seq_obj,evt_obj_list) \
  {
   set evt_elem_list $event::($evt_obj,evt_elem_list)
   set rest_evt_attr(2) ""
   if { [info exists event::($evt_obj,rest_value)] }\
   {
    array set rest_evt_attr $event::($evt_obj,rest_value)
   }
   array set def_evt_attr $event::($evt_obj,def_value)
   foreach row_elems $rest_evt_attr(2) \
   {
    foreach elem_obj $row_elems \
    {
     set def_flag 0
     foreach def_row $def_evt_attr(2) \
     {
      if { [lsearch $def_row $elem_obj] != -1 } \
      {
       set def_flag 1
       break
      }
     }
     set elem_flag 0
     foreach act_row $evt_elem_list \
     {
      if { [lsearch $act_row $elem_obj] != -1 } \
      {
       set elem_flag 1
       break
      }
     }
     if { $elem_flag == 0 && $def_flag == 0 } \
     {
      set block_obj $event_element::($elem_obj,block_obj)
      if { $block::($block_obj,blk_type) == "command" } \
      {
       delete $block_obj
       } elseif { $block::($block_obj,blk_type) == "comment" } \
      {
       PB_int_DeleteCommentBlkFromList block_obj
       delete $block_obj
      }
      delete $elem_obj
     }
    }
   }
  }
 }

#=======================================================================
proc UI_PB_evt_progItemSelection {page_obj args} {
  set tree $Page::($page_obj,tree)
  set HLIST [$tree subwidget hlist]
  set ent [$HLIST info anchor]
  set index [string range $ent 2 [string length $ent]]
  if { [string compare $index ""] == 0} \
  {
   set index 0
   $HLIST selection clear
   $HLIST anchor clear
   $HLIST selection set 0.0
   $HLIST anchor set 0.0
   } elseif {$index == 2} \
  {
   $HLIST selection clear
   $HLIST anchor clear
   $HLIST selection set 0.2.0
   $HLIST anchor set 0.2.0
  }
  if {$Page::($page_obj,prev_seq) != $index} \
  {
   set prev_seq $Page::($page_obj,prev_seq)
   UI_PB_evt_DeleteApplyEvtElemsOfSeq page_obj
   UI_PB_evt_SetASequenceAttr $page_obj $index
   UI_PB_evt_GetSequenceIndex page_obj seq_index
   set seq_obj [lindex $Page::($page_obj,seq_obj_list) $seq_index]
   UI_PB_evt_RestoreSeqObjData seq_obj
   UI_PB_evt_CreateSeqAttributes page_obj
   if { $prev_seq >= 2 && $prev_seq < 3 } \
   {
    if { $seq_index < 2 || $seq_index > 4 } \
    {
     UI_PB_evt_CreateMenuOptions page_obj seq_obj
    }
   }
  }
 }

#=======================================================================
proc UI_PB_evt_SetASequenceAttr {page_obj index} {
  set bot_canvas $Page::($page_obj,bot_canvas)
  switch $index \
  {
   0 {
    UI_PB_evt_ProgStartSeq page_obj
    bind $bot_canvas <3> "UI_PB_evt_CanvasPopupMenu $page_obj %X %Y"
   }
   1 {
    UI_PB_evt_OperStartSeq page_obj
    bind $bot_canvas <3> "UI_PB_evt_CanvasPopupMenu $page_obj %X %Y"
   }
   2 {
    UI_PB_evt_MachineControl page_obj
    bind $bot_canvas <3> ""
   }
   2.0 {
    UI_PB_evt_MachineControl page_obj
    bind $bot_canvas <3> ""
   }
   2.1 {
    UI_PB_evt_Cycles page_obj
    bind $bot_canvas <3> ""
   }
   2.2 {
    UI_PB_evt_Motion page_obj
    bind $bot_canvas <3> ""
   }
   2.3 {
    UI_PB_evt_UserDefined page_obj
    bind $bot_canvas <3> ""
   }
   3 {
    UI_PB_evt_OperEndSeq page_obj
    bind $bot_canvas <3> "UI_PB_evt_CanvasPopupMenu $page_obj %X %Y"
   }
   4 {
    UI_PB_evt_ProgEndSeq page_obj
    bind $bot_canvas <3> "UI_PB_evt_CanvasPopupMenu $page_obj %X %Y"
   }
  }
 }

#=======================================================================
proc UI_PB_evt_SetSequenceObjAttr {SEQ_OBJ} {
  upvar $SEQ_OBJ seq_obj
  set sequence::($seq_obj,region) 60
  set sequence::($seq_obj,evt_focus_cell) 0
  set sequence::($seq_obj,blk_focus_cell) 0
  set sequence::($seq_obj,active_evt) 0
  set sequence::($seq_obj,focus_rect) 0
  set sequence::($seq_obj,focus_sep) 0
  set sequence::($seq_obj,icon_top) 0
  set sequence::($seq_obj,icon_top_text) 0
  set sequence::($seq_obj,icon_bot) 0
  set sequence::($seq_obj,icon_bot_text) 0
  set sequence::($seq_obj,add_blk) 0
  set sequence::($seq_obj,blk_temp) 0
  set sequence::($seq_obj,drag_flag) 0
  set sequence::($seq_obj,trash_flag) 0
  set sequence::($seq_obj,icon_bg) 0
 }
