#4

#=======================================================================
proc UI_PB_evt_CreateMenuOptions {PAGE_OBJ SEQ_OBJ} {
  upvar $PAGE_OBJ page_obj
  upvar $SEQ_OBJ seq_obj
  global tixOption
  global CB_Block_Name
  set comb_widget $Page::($page_obj,comb_widget)
  set lbx [$comb_widget subwidget listbox]
  $lbx delete 0 end
  PB_int_RetBlkObjList blk_obj_list
  set no_of_elements [llength $blk_obj_list]
  $comb_widget insert end "New Block"
  $comb_widget insert end "Operator Message"
  $comb_widget insert end "Custom Command"
  set word "Command"
  PB_int_RetMOMVarAsscAddress word cmd_proc_list
  PB_int_RetMOMVarDescAddress word cmd_proc_desc_list
  for {set count 1} {$count < [llength $cmd_proc_list]} {incr count} \
  {

#=======================================================================
set cmd_proc [lindex $cmd_proc_list $count]
 set cmd_proc_desc [lindex $cmd_proc_desc_list $count]
 append comb_value "$cmd_proc" " - ( $cmd_proc_desc )"
 $comb_widget insert end $comb_value
 unset comb_value
}
for {set jj 0} {$jj < $no_of_elements} {incr jj} \
{
 set blk_obj [lindex $blk_obj_list $jj]
 if { [string match "*cycle*" $block::($blk_obj,block_name)] == 0 } \
 {
  set blk_elem_list $block::($blk_obj,elem_addr_list)
  set blk_name $block::($blk_obj,block_name)
  UI_PB_com_ApplyMastSeqBlockElem blk_elem_list
  UI_PB_com_CreateBlkNcCode blk_elem_list blk_nc_code
  append comb_value $blk_nc_code "  - (" $blk_name ")"
  lappend comb_elem_list $comb_value
  $comb_widget insert end $comb_value
  unset comb_value
 }
}
set sequence::($seq_obj,comb_elem_list) $comb_elem_list
if { $sequence::($seq_obj,comb_var) == "" } \
{
 set comb_var [lindex $sequence::($seq_obj,comb_elem_list) 0]
} else \
{
 set comb_var $sequence::($seq_obj,comb_var)
}
set sequence::($seq_obj,comb_var) $comb_var
set CB_Block_Name $comb_var
[$comb_widget subwidget entry] config -bg lightBlue -justify left \
-state disabled  -cursor ""
}

#=======================================================================
proc UI_PB_evt_AddBindProcs { PAGE_OBJ } {
  upvar $PAGE_OBJ page_obj
  set top_canvas $Page::($page_obj,top_canvas)
  $top_canvas bind add_movable <Enter> "UI_PB_evt_AddFocusOn $top_canvas"
  $top_canvas bind add_movable <Leave> "UI_PB_evt_AddFocusOff $top_canvas"
  $top_canvas bind add_movable <1> "UI_PB_evt_AddStartDrag $page_obj \
  %x %y"
  $top_canvas bind add_movable <B1-Motion> "UI_PB_evt_AddDrag $page_obj \
  %x %y"
  $top_canvas bind add_movable <ButtonRelease-1> "UI_PB_evt_AddEndDrag \
  $page_obj"
 }

#=======================================================================
proc UI_PB_evt_AddUnBindProcs { PAGE_OBJ } {
  upvar $PAGE_OBJ page_obj
  set top_canvas $Page::($page_obj,top_canvas)
  $top_canvas bind add_movable <Enter> ""
  $top_canvas bind add_movable <Leave> ""
  $top_canvas bind add_movable <1> ""
  $top_canvas bind add_movable <B1-Motion> ""
  $top_canvas bind add_movable <ButtonRelease-1> ""
 }

#=======================================================================
proc UI_PB_evt_AddFocusOn {top_canvas} {
  global paOption
  set im [$top_canvas itemconfigure current -image]
  [lindex $im end] configure -background $paOption(focus)
  global gPB
  set c $top_canvas
  if { $gPB(use_info) } { 
   $c config -cursor question_arrow
   } else {
   $c config -cursor hand2
  }
 }

#=======================================================================
proc UI_PB_evt_AddFocusOff {top_canvas} {
  global paOption
  set im [$top_canvas itemconfigure current -image]
  [lindex $im end] configure -background $paOption(app_butt_bg)
  set c $top_canvas
  $c config -cursor ""
 }

#=======================================================================
proc UI_PB_evt_AddStartDrag {page_obj x y} {
  global paOption
  global tixOption
  global CB_Block_Name
  set font $tixOption(font_sm)
  UI_PB_evt_GetSequenceIndex page_obj seq_index
  set seq_obj [lindex $Page::($page_obj,seq_obj_list) $seq_index]
  set sequence::($seq_obj,comb_var) $CB_Block_Name
  if { $CB_Block_Name == "New Block" } \
  {
   set elem_text $CB_Block_Name
   set elem_type "normal"
   set icon_name "pb_block"
   } elseif { $CB_Block_Name == "Operator Message" } \
  {
   set elem_text $CB_Block_Name
   set elem_type "comment"
   set icon_name "pb_text"
   } elseif { $CB_Block_Name == "Custom Command" } \
  {
   set elem_text $CB_Block_Name
   set elem_type "command"
   set icon_name "pb_finger"
  } else \
  {
   set brace_indx [string first - $CB_Block_Name]
   set elem_text [string range $CB_Block_Name 0 [expr $brace_indx - 1]]
   set elem_text [string trim $elem_text]
   UI_PB_com_TrunkNcCode elem_text
   if { [string match "*Custom Command*" $CB_Block_Name] || \
   [string match "*MOM Command*" $CB_Block_Name] } \
   {
    set elem_type "command"
    set icon_name "pb_finger"
   } else \
   {
    set elem_type "normal"
    set icon_name "pb_block"
   }
  }
  set top_canvas $Page::($page_obj,top_canvas)
  set bot_canvas $Page::($page_obj,bot_canvas)
  set panel_hi $Page::($page_obj,panel_hi)
  set t_shift $Page::($page_obj,glob_text_shift)
  set xt [$top_canvas canvasx $x]
  set yt [$top_canvas canvasy $y]
  set icon1 [UI_PB_blk_CreateIcon $top_canvas $icon_name ""]
  set icon_top [$top_canvas create image $xt $yt \
  -image $icon1]
  set icon_top_text [$top_canvas create text [expr $xt + $t_shift] \
  $yt -text "$elem_text" -font $font]
  $icon1 config -bg $paOption(butt_bg)
  set sequence::($seq_obj,icon_top) $icon_top
  set sequence::($seq_obj,icon_top_text) $icon_top_text
  set xb [$bot_canvas canvasx $x]
  set yb [$bot_canvas canvasy [expr $y - $panel_hi - 2]]
  set icon2 [UI_PB_blk_CreateIcon $bot_canvas $icon_name ""]
  set icon_bot [$bot_canvas create image $xb $yb \
  -image $icon2]
  set icon_bot_text [$bot_canvas create text [expr $xb + $t_shift] \
  $yb  -text $elem_text -font $font]
  $icon2 config -bg $paOption(butt_bg)
  set sequence::($seq_obj,icon_bot) $icon_bot
  set sequence::($seq_obj,icon_bot_text) $icon_bot_text
  set sequence::($seq_obj,drag_elem_type) $elem_type
  set sequence::($seq_obj,drag_blk_obj) 0
  set sequence::($seq_obj,drag_evt_obj) 0
  set sequence::($seq_obj,drag_row) -1
 }

#=======================================================================
proc UI_PB_evt_AddDrag {page_obj x y} {
  set t_shift $Page::($page_obj,glob_text_shift)
  set top_canvas $Page::($page_obj,top_canvas)
  set bot_canvas $Page::($page_obj,bot_canvas)
  UI_PB_evt_GetSequenceIndex page_obj seq_index
  set seq_obj [lindex $Page::($page_obj,seq_obj_list) $seq_index]
  set xx [$top_canvas canvasx $x]
  set yy [$top_canvas canvasy $y]
  $top_canvas coords $sequence::($seq_obj,icon_top) $xx $yy
  $top_canvas coords $sequence::($seq_obj,icon_top_text) \
  [expr $xx + $t_shift] $yy
  set panel_hi $Page::($page_obj,panel_hi)
  set dy [expr $panel_hi + 2]
  set xx [$bot_canvas canvasx $x]
  set yy [$bot_canvas canvasy [expr $y - $dy]]
  UI_PB_ScrollCanvasWin $page_obj $xx $yy
  set xx [$bot_canvas canvasx $x]
  set yy [$bot_canvas canvasy [expr $y - $dy]]
  $bot_canvas coords $sequence::($seq_obj,icon_bot) $xx $yy
  $bot_canvas coords $sequence::($seq_obj,icon_bot_text) \
  [expr $xx + $t_shift] $yy
  UI_PB_evt_GetEventObjFromCurPos page_obj seq_obj $xx $yy
  UI_PB_evt_HighLightSep page_obj seq_obj $xx $yy
 }

#=======================================================================
proc UI_PB_ScrollCanvasWin { page_obj x y } {
  set hor_scrol $Page::($page_obj,hor_scrol)
  set ver_scrol $Page::($page_obj,ver_scrol)
  set bot_canvas $Page::($page_obj,bot_canvas)
  set bot_height $Page::($page_obj,bot_height)
  set bot_width $Page::($page_obj,bot_width)
  set hor_sets [$hor_scrol get]
  set ver_sets [$ver_scrol get]
  set verstrt_frac [lindex $ver_sets 0]
  set verend_frac  [lindex $ver_sets 1]
  set ver_strt [expr $verstrt_frac * $bot_height]
  set ver_end  [expr $verend_frac * $bot_height]
  if { $y < $ver_strt } \
  {
   if { $ver_strt > 0 } \
   {
    $bot_canvas yview moveto [expr $verstrt_frac - .005]
   }
   } elseif { $y > $ver_end } \
  {
   $bot_canvas yview moveto [expr $verstrt_frac + .005]
  }
  set horstrt_frac [lindex $hor_sets 0]
  set horend_frac  [lindex $hor_sets 1]
  set hor_strt [expr $horstrt_frac * $bot_width]
  set hor_end  [expr $horend_frac * $bot_width]
  if { $x < $hor_strt} \
  {
   if { $hor_strt > 0 } \
   {
    $bot_canvas xview moveto [expr $horstrt_frac - .005]
   }
   } elseif { $x > $hor_end} \
  {
   $bot_canvas xview moveto [expr $horstrt_frac + .005]
  }
 }

#=======================================================================
proc UI_PB_evt_GetEventObjFromCurPos {PAGE_OBJ SEQ_OBJ x y} {
  upvar $PAGE_OBJ page_obj
  upvar $SEQ_OBJ seq_obj
  set evt_dim_height [lindex $Page::($page_obj,glob_evnt_dim) 1]
  set evt_evtdist $Page::($page_obj,glob_evt_evtdist)
  set flag 0
  foreach evt_obj $sequence::($seq_obj,evt_obj_list) \
  {
   if {$y > [expr $event::($evt_obj,yc) - [expr $evt_dim_height / 2] \
    - [expr $evt_evtdist / 2]] && $y < \
    [expr $event::($evt_obj,event_height) - [expr $evt_dim_height / 2] \
   - [expr $evt_evtdist / 2]] } \
   {
    set sequence::($seq_obj,add_blkto_evt_obj) $evt_obj
    set flag 1
    break
   }
  }
  if {$flag == 0} \
  {
   if {[info exists sequence::($seq_obj,add_blkto_evt_obj)]} \
   {
    unset sequence::($seq_obj,add_blkto_evt_obj)
   }
  }
 }

#=======================================================================
proc UI_PB_evt_HighLightRowOfEvent { PAGE_OBJ SEQ_OBJ EVT_OBJ COUNT } {
  upvar $PAGE_OBJ page_obj
  upvar $SEQ_OBJ seq_obj
  upvar $EVT_OBJ evt_obj
  upvar $COUNT count
  global paOption
  set bot_canvas $Page::($page_obj,bot_canvas)
  set rect_id [lindex $event::($evt_obj,rect_id) $count]
  $bot_canvas itemconfigure $rect_id -outline $paOption(focus) \
  -fill $paOption(focus)
  set temp_sep [lindex $event::($evt_obj,sep_id) $count]
  set sep_id1 [lindex $temp_sep 0]
  set sep_id2 [lindex $temp_sep 1]
  $bot_canvas itemconfigure $sep_id1 -outline $paOption(focus)
  $bot_canvas itemconfigure $sep_id2 -outline $paOption(focus)
  lappend list_ids $rect_id $sep_id1 $sep_id2
  set sequence::($seq_obj,focus_rect) $list_ids
  set sequence::($seq_obj,add_blk) "row"
  set sequence::($seq_obj,blk_temp) $count
 }

#=======================================================================
proc UI_PB_evt_AvoidHighLightRow { SEQ_OBJ ACTIVE_EVT_OBJ COUNT } {
  upvar $SEQ_OBJ seq_obj
  upvar $ACTIVE_EVT_OBJ active_evt_obj
  upvar $COUNT count
  if { $sequence::($seq_obj,drag_elem_type) == "command" || \
  $sequence::($seq_obj,drag_elem_type) == "comment" } \
  {
   set sequence::($seq_obj,add_blk) 0
   set sequence::($seq_obj,blk_temp) 0
   return 1
   } elseif {$sequence::($seq_obj,drag_evt_obj)} \
  {
   if {$sequence::($seq_obj,drag_evt_obj) == $active_evt_obj \
   && $sequence::($seq_obj,drag_row) == $count} \
   {
    set sequence::($seq_obj,add_blk) 0
    set sequence::($seq_obj,blk_temp) 0
    return 1
    } elseif { [llength [lindex $event::($active_evt_obj,evt_elem_list) \
   $count]] == 1 } \
   {
    set evt_elem_row [lindex $event::($active_evt_obj,evt_elem_list) \
    $count]
    set evt_elem_obj [lindex $evt_elem_row 0]
    set block_obj $event_element::($evt_elem_obj,block_obj)
    if { $block::($block_obj,blk_type) == "command" || \
    $block::($block_obj,blk_type) == "comment" } \
    {
     return 1
    } else \
    {
     return 0
    }
   } else \
   {
    return 0
   }
  } else \
  {
   return 0
  }
 }

#=======================================================================
proc UI_PB_evt_AvoidHighLightTopOrBottomSep { SEQ_OBJ ACTIVE_EVT_OBJ COUNT } {
  upvar $SEQ_OBJ seq_obj
  upvar $ACTIVE_EVT_OBJ active_evt_obj
  upvar $COUNT count
  if {$sequence::($seq_obj,drag_evt_obj)} \
  {
   set drag_evt_obj $sequence::($seq_obj,drag_evt_obj)
   set drag_row $sequence::($seq_obj,drag_row)
   set temp_length \
   [llength [lindex $event::($drag_evt_obj,evt_elem_list) $drag_row]]
   if {$drag_evt_obj == $active_evt_obj && \
   $drag_row == $count && $temp_length == 1} \
   {
    return 1
   } else \
   {
    return 0
   }
  } else \
  {
   return 0
  }
 }

#=======================================================================
proc UI_PB_evt_HighLightTopSeperator { PAGE_OBJ SEQ_OBJ EVT_OBJ COUNT } {
  upvar $PAGE_OBJ page_obj
  upvar $SEQ_OBJ seq_obj
  upvar $EVT_OBJ evt_obj
  upvar $COUNT count
  global paOption
  set bot_canvas $Page::($page_obj,bot_canvas)
  set temp_sep [lindex $event::($evt_obj,sep_id) $count]
  set sep_id [lindex $temp_sep 0]
  set sequence::($seq_obj,focus_sep) $sep_id
  $bot_canvas itemconfigure $sep_id -outline $paOption(focus)
  set sequence::($seq_obj,add_blk) "top"
  set sequence::($seq_obj,blk_temp) $count
 }

#=======================================================================
proc UI_PB_evt_HighLightBottomSeperator { PAGE_OBJ SEQ_OBJ EVT_OBJ COUNT } {
  upvar $PAGE_OBJ page_obj
  upvar $SEQ_OBJ seq_obj
  upvar $EVT_OBJ evt_obj
  upvar $COUNT count
  global paOption
  set bot_canvas $Page::($page_obj,bot_canvas)
  set temp_sep [lindex $event::($evt_obj,sep_id) $count]
  set sep_id [lindex $temp_sep 1]
  set sequence::($seq_obj,focus_sep) $sep_id
  $bot_canvas itemconfigure $sep_id -outline $paOption(focus)
  set sequence::($seq_obj,add_blk) "bottom"
  set sequence::($seq_obj,blk_temp) $count
 }

#=======================================================================
proc UI_PB_evt_HighLightSep {PAGE_OBJ SEQ_OBJ x y} {
  upvar $PAGE_OBJ page_obj
  upvar $SEQ_OBJ seq_obj
  global paOption
  set region $sequence::($seq_obj,region)
  set blk_dim_height [lindex $Page::($page_obj,glob_blk_dim) 1]
  set bot_canvas $Page::($page_obj,bot_canvas)
  set rect_gap $Page::($page_obj,glob_rect_gap)
  set sequence::($seq_obj,add_blk) 0
  set sequence::($seq_obj,blk_temp) 0
  UI_PB_evt_UnHighlightSeperators $bot_canvas seq_obj
  if {[info exists sequence::($seq_obj,add_blkto_evt_obj)]} \
  {
   set active_evt_obj $sequence::($seq_obj,add_blkto_evt_obj)
   set no_rows $event::($active_evt_obj,block_nof_rows)
   set event_width $event::($active_evt_obj,event_width)
   set event_xc $event::($active_evt_obj,xc)
   if {$no_rows > 0} \
   {
    for {set count 0} {$count < $no_rows} {incr count} \
    {
     set row_elem_objs [lindex $event::($active_evt_obj,evt_elem_list) \
     $count]
     set elem_obj [lindex $row_elem_objs 0]
     set yc $event_element::($elem_obj,yc)
     if {$y > [expr $yc - [expr $blk_dim_height / 2]] && \
      $y < [expr $yc + [expr $blk_dim_height / 2]] && \
      $x > [expr $event_xc - $region] && \
     $x < [expr $event_xc + $event_width + $region]} \
     {
      set high_flag [UI_PB_evt_AvoidHighLightRow seq_obj \
      active_evt_obj count]
      if {$high_flag} { return }
      UI_PB_evt_HighLightRowOfEvent page_obj seq_obj \
      active_evt_obj count
      break
      } elseif {$y > [expr $yc - [expr $blk_dim_height / 2] - \
      [expr 3 * $rect_gap]] && \
      $y < [expr $yc - [expr $blk_dim_height / 2]] && \
      $x > [expr $event_xc - $region] && \
     $x < [expr $event_xc + $event_width + $region]} \
     {
      set high_flag [UI_PB_evt_AvoidHighLightTopOrBottomSep seq_obj \
      active_evt_obj count]
      if {$high_flag} { return }
      UI_PB_evt_HighLightTopSeperator page_obj seq_obj \
      active_evt_obj count
      break
      } elseif {$y > [expr $yc + [expr $blk_dim_height / 2]] && \
      $y < [expr $yc + [expr $blk_dim_height / 2] + \
      [expr 3 * $rect_gap]] && \
      $x > [expr $event_xc - $region] && \
     $x < [expr $event_xc + $event_width + $region]} \
     {
      set high_flag [UI_PB_evt_AvoidHighLightTopOrBottomSep seq_obj \
      active_evt_obj count]
      if {$high_flag} { return }
      UI_PB_evt_HighLightBottomSeperator page_obj seq_obj \
      active_evt_obj count
      break
     }
    }
    } elseif {$no_rows == 0} \
   {
    set yc $event::($active_evt_obj,yc)
    if {$y > [expr $yc - [expr $blk_dim_height / 2]] && \
     $y < [expr $yc + [expr $blk_dim_height / 2]] && \
     $x > [expr $event_xc - $region] && \
    $x < [expr $event_xc + $event_width + $region]} \
    {
     set rect_id [lindex $event::($active_evt_obj,rect_id) 0]
     $bot_canvas itemconfigure $rect_id -outline $paOption(focus) \
     -fill $paOption(focus)
     lappend list_ids $rect_id
     set sequence::($seq_obj,focus_rect) $list_ids
     set sequence::($seq_obj,add_blk) "top"
    }
   }
  }
 }

#=======================================================================
proc UI_PB_evt_DeleteTemporaryIcons { PAGE_OBJ SEQ_OBJ } {
  upvar $PAGE_OBJ page_obj
  upvar $SEQ_OBJ seq_obj
  set top_canvas $Page::($page_obj,top_canvas)
  set bot_canvas $Page::($page_obj,bot_canvas)
  if {$sequence::($seq_obj,icon_top) != 0} \
  {
   $top_canvas delete $sequence::($seq_obj,icon_top)
   set sequence::($seq_obj,icon_top) 0
   $top_canvas delete $sequence::($seq_obj,icon_top_text)
   set sequence::($seq_obj,icon_top_text) 0
  }
  if {$sequence::($seq_obj,icon_bot) != 0} \
  {
   $bot_canvas delete $sequence::($seq_obj,icon_bot)
   set sequence::($seq_obj,icon_bot) 0
   $bot_canvas delete $sequence::($seq_obj,icon_bot_text)
   set sequence::($seq_obj,icon_bot_text) 0
  }
 }

#=======================================================================
proc UI_PB_evt_AddEndDrag {page_obj} {
  global paOption
  set bot_canvas $Page::($page_obj,bot_canvas)
  UI_PB_evt_GetSequenceIndex page_obj seq_index
  set seq_obj [lindex $Page::($page_obj,seq_obj_list) $seq_index]
  UI_PB_evt_DeleteTemporaryIcons page_obj seq_obj
  if { $sequence::($seq_obj,add_blk) == 0 } \
  {
   return
  }
  UI_PB_evt_UnHighlightSeperators $bot_canvas seq_obj
  set active_evt_obj $sequence::($seq_obj,add_blkto_evt_obj)
  if {[string compare $event::($active_evt_obj,col_image) "minus"] == 0} \
  {
   set comb_var $sequence::($seq_obj,comb_var)
   if { [string compare $comb_var "New Block"] == 0 } \
   {
    set active_evt_name $event::($active_evt_obj,event_name)
    set new_elem_name "new_block"
    set new_blk_elem_list ""
    set blk_type "normal"
    PB_int_CreateNewBlock new_elem_name new_blk_elem_list \
    active_evt_name new_block_obj blk_type
    set blk_flag "new_block"
    } elseif { [string compare $comb_var "Operator Message"] == 0 } \
   {
    set elem_name "comment_blk"
    set blk_type "comment"
    PB_int_CreateCommentBlkElem elem_name blk_elem_obj
    PB_int_CreateCommentBlk elem_name blk_elem_obj new_block_obj
    set blk_flag "comment"
    } elseif { [string compare $comb_var "Custom Command"] == 0 } \
   {
    set active_evt_name $event::($active_evt_obj,event_name)
    set new_elem_name "PB_CMD_custom_command"
    set blk_type "command"
    PB_int_CreateNewCmdBlkElem new_elem_name cmd_blk_elem
    PB_int_CreateCmdBlock new_elem_name cmd_blk_elem new_block_obj
    set blk_flag "command"
   } else \
   {
    set open_brace_indx [string first ( $comb_var]
    incr open_brace_indx
    set close_brace_indx [string first ) $comb_var]
    incr close_brace_indx -1
    set blk_type $sequence::($seq_obj,drag_elem_type)
    if { $blk_type == "normal" } \
    {
     set new_elem_name [string range $comb_var $open_brace_indx \
     $close_brace_indx]
     set new_elem_name [string trim $new_elem_name " "]
     PB_int_RetBlkObjList blk_obj_list
     PB_com_RetObjFrmName new_elem_name blk_obj_list new_block_obj
    } else \
    {
     set brace_indx [string first - $comb_var]
     set new_elem_name [string range $comb_var 0 [expr $brace_indx - 1]]
     set new_elem_name [string trim $new_elem_name]
     PB_int_RetCmdBlks cmd_blk_list
     set cmd_obj 0
     PB_com_RetObjFrmName new_elem_name cmd_blk_list cmd_obj
     if { !$cmd_obj } { set cmd_obj 0}
     PB_blk_CreateCmdBlkElem new_elem_name cmd_obj cmd_blk_elem
     PB_int_CreateCmdBlock new_elem_name cmd_blk_elem new_block_obj
    }
    set blk_flag ""
   }
   PB_int_CreateNewEventElement new_block_obj elem_obj
   UI_PB_evt_AddBlockToEvent page_obj seq_obj elem_obj
   if { [string compare $blk_flag "new_block"] == 0  && \
   $sequence::($seq_obj,add_blk) != 0 } \
   {
    UI_PB_evt_BringBlkpage page_obj seq_obj active_evt_obj elem_obj \
    new_block_obj
    } elseif { [string compare $blk_flag "comment"] == 0 && \
   $sequence::($seq_obj,add_blk) != 0 } \
   {
    UI_PB_evt_BringCommentDlg page_obj seq_obj active_evt_obj elem_obj \
    new_block_obj New
    } elseif { [string compare $blk_flag "command"] == 0 && \
   $sequence::($seq_obj,add_blk) != 0 } \
   {
    UI_PB_evt_BringCmdBlkPage page_obj seq_obj active_evt_obj elem_obj \
    new_block_obj New
   }
  }
  set sequence::($seq_obj,add_blk) 0
 }

#=======================================================================
proc UI_PB_evt_BringCommentDlg { PAGE_OBJ SEQ_OBJ ACTIVE_EVT_OBJ ELEM_OBJ \
  BLOCK_OBJ act_mode } {
  upvar $PAGE_OBJ page_obj
  upvar $SEQ_OBJ seq_obj
  upvar $ACTIVE_EVT_OBJ active_evt_obj
  upvar $ELEM_OBJ elem_obj
  upvar $BLOCK_OBJ block_obj
  global gPB
  set bot_canvas $Page::($page_obj,bot_canvas)
  set blk_img_id $event_element::($elem_obj,icon_id)
  set img [lindex [$bot_canvas itemconfigure $blk_img_id -image] end]
  $img config -relief sunken -bg pink
  update idletasks
  set canvas_frame $Page::($page_obj,canvas_frame)
  block::readvalue $block_obj blk_obj_attr
  set sub_win [string tolower $blk_obj_attr(0)]
  set win [toplevel $canvas_frame.comment]
  set toplevel_index [llength $gPB(toplevel_list)]
  set win_index [expr $toplevel_index + 1]
  set gPB(toplevel_disable_$win_index) 1
  UI_PB_com_CreateTransientWindow $win "$gPB(seq,oper_trans,title,Label)" \
  "" "UI_PB_DisableProgPageWidgets $page_obj $seq_obj" \
  "" "UI_PB_evt_ActivateProgPageWidgets $page_obj $seq_obj $win_index"
  set blk_elem_obj [lindex $block::($block_obj,elem_addr_list) 0]
  UI_PB_cmd_CreateCommentDlgParam $win $page_obj $blk_elem_obj
  set box1_frm [frame $win.box1]
  pack $box1_frm -side bottom -fill x
  if { $act_mode == "Edit" } \
  {
   set cb_arr(gPB(nav_button,cancel,Label)) \
   "UI_PB_cmd_SeqEditCommentCancel_CB $win $page_obj \
   $seq_obj $active_evt_obj $elem_obj"
   set cb_arr(gPB(nav_button,ok,Label))  \
   "UI_PB_cmd_SeqNewCommentOk_CB $win $page_obj \
   $seq_obj $elem_obj"
   bind $win.top.ent <Return> \
   "UI_PB_cmd_SeqNewCommentOk_CB $win $page_obj \
   $seq_obj $elem_obj"
  } else \
  {
   set cb_arr(gPB(nav_button,cancel,Label)) \
   "UI_PB_cmd_SeqNewCommentCancel_CB $win $page_obj \
   $seq_obj $active_evt_obj $elem_obj"
   set cb_arr(gPB(nav_button,ok,Label)) \
   "UI_PB_cmd_SeqNewCommentOk_CB $win $page_obj $seq_obj \
   $elem_obj"
   bind $win.top.ent <Return> \
   "UI_PB_cmd_SeqNewCommentOk_CB $win $page_obj $seq_obj \
   $elem_obj"
  }
  set label_list {"gPB(nav_button,cancel,Label)" \
  "gPB(nav_button,ok,Label)"}
  UI_PB_com_CreateButtonBox $box1_frm label_list cb_arr
 }

#=======================================================================
proc UI_PB_evt_BringCmdBlkPage { PAGE_OBJ SEQ_OBJ ACTIVE_EVT_OBJ ELEM_OBJ \
  BLOCK_OBJ act_mode } {
  upvar $PAGE_OBJ page_obj
  upvar $SEQ_OBJ seq_obj
  upvar $ACTIVE_EVT_OBJ active_evt_obj
  upvar $ELEM_OBJ elem_obj
  upvar $BLOCK_OBJ block_obj
  global gPB
  set bot_canvas $Page::($page_obj,bot_canvas)
  set blk_img_id $event_element::($elem_obj,icon_id)
  set img [lindex [$bot_canvas itemconfigure $blk_img_id -image] end]
  $img config -relief sunken -bg pink
  update idletasks
  set canvas_frame $Page::($page_obj,canvas_frame)
  block::readvalue $block_obj blk_obj_attr
  set sub_win [string tolower $blk_obj_attr(0)]
  set win [toplevel $canvas_frame.$sub_win]
  set toplevel_index [llength $gPB(toplevel_list)]
  set win_index [expr $toplevel_index + 1]
  set gPB(toplevel_disable_$win_index) 1
  UI_PB_com_CreateTransientWindow $win "$gPB(seq,cus_trans,title,Label)" \
  "" "UI_PB_DisableProgPageWidgets $page_obj $seq_obj" \
  "" "UI_PB_evt_ActivateProgPageWidgets $page_obj $seq_obj $win_index"
  set cmd_page_obj [new Page "Command" "Command"]
  set Page::($cmd_page_obj,canvas_frame) $win
  set blk_elem_obj [lindex $block::($block_obj,elem_addr_list) 0]
  set cmd_obj $block_element::($blk_elem_obj,elem_mom_variable)
  UI_PB_cmd_CreateCmdBlkPage cmd_page_obj
  UI_PB_cmd_DisplayCmdProc cmd_obj cmd_page_obj
  set box1_frm [frame $win.box1]
  pack $box1_frm -side bottom -fill x
  if { $act_mode == "Edit" } \
  {
   set cb_arr(gPB(nav_button,cancel,Label)) \
   "UI_PB_cmd_SeqEditCmdBlkCancel_CB $win $page_obj \
   $seq_obj $active_evt_obj $elem_obj $cmd_page_obj"
   set cb_arr(gPB(nav_button,ok,Label)) \
   "UI_PB_cmd_SeqEditCmdBlkOk_CB $win $page_obj $seq_obj \
   $elem_obj $cmd_page_obj"
   bind $win.top.ent <Return> \
   "UI_PB_cmd_SeqEditCmdBlkOk_CB $win $page_obj $seq_obj \
   $elem_obj $cmd_page_obj"
  } else \
  {
   set cb_arr(gPB(nav_button,cancel,Label)) \
   "UI_PB_cmd_SeqNewCmdBlkCancel_CB $win $page_obj \
   $seq_obj $active_evt_obj $elem_obj $cmd_page_obj"
   set cb_arr(gPB(nav_button,ok,Label)) \
   "UI_PB_cmd_SeqNewCmdBlkOk_CB $win $page_obj $seq_obj \
   $elem_obj $cmd_page_obj"
   bind $win.top.ent <Return> \
   "UI_PB_cmd_SeqNewCmdBlkOk_CB $win $page_obj $seq_obj \
   $elem_obj $cmd_page_obj"
  }
  set label_list {"gPB(nav_button,cancel,Label)" \
  "gPB(nav_button,ok,Label)"}
  UI_PB_com_CreateButtonBox $box1_frm label_list cb_arr
 }

#=======================================================================
proc UI_PB_evt_BringBlkpage { PAGE_OBJ SEQ_OBJ ACTIVE_EVT_OBJ ELEM_OBJ \
  NEW_BLOCK_OBJ } {
  upvar $PAGE_OBJ page_obj
  upvar $SEQ_OBJ seq_obj
  upvar $ACTIVE_EVT_OBJ active_evt_obj
  upvar $ELEM_OBJ elem_obj
  upvar $NEW_BLOCK_OBJ new_block_obj
  set bot_canvas $Page::($page_obj,bot_canvas)
  set blk_img_id $event_element::($elem_obj,icon_id)
  set img [lindex [$bot_canvas itemconfigure $blk_img_id -image] end]
  $img config -relief sunken -bg pink
  update
  UI_PB_com_ReturnBlockName active_evt_obj new_block_name
  set block::($new_block_obj,block_name) $new_block_name
  UI_PB_evt__DisplayBlockPage $page_obj $seq_obj $new_block_obj \
  new_blk_page_obj
  set box_frm $Page::($new_blk_page_obj,box)
  set cb_arr(gPB(nav_button,default,Label)) \
  "UI_PB_blk_DefaultCallBack $new_blk_page_obj"
  set cb_arr(gPB(nav_button,restore,Label)) \
  "UI_PB_blk_RestoreCallBack $new_blk_page_obj"
  set cb_arr(gPB(nav_button,cancel,Label)) \
  "UI_PB_blk_NewBlkCancel_CB $new_blk_page_obj \
  $page_obj $seq_obj $active_evt_obj $elem_obj"
  set cb_arr(gPB(nav_button,ok,Label)) \
  "UI_PB_blk_NewBlkOk_CB $new_blk_page_obj $page_obj \
  $seq_obj $active_evt_obj $elem_obj"
  UI_PB_com_CreateActionElems $box_frm cb_arr
 }

#=======================================================================
proc UI_PB_evt_AddBlockToEvent { PAGE_OBJ SEQ_OBJ ELEM_OBJ } {
  upvar $PAGE_OBJ page_obj
  upvar $SEQ_OBJ seq_obj
  upvar $ELEM_OBJ elem_obj
  switch $sequence::($seq_obj,add_blk) \
  {
   "row" \
   {
    set blk_exists_flag [UI_PB_evt_CheckBlkInTemplate seq_obj elem_obj]
    if {$blk_exists_flag} \
    {
     set block_obj $event_element::($elem_obj,block_obj)
     set block_name $block::($block_obj,block_name)
     tk_messageBox  -parent [UI_PB_com_AskActiveWindow] \
     -type ok -icon error \
     -message "Block $block_name exists in the Block Template"
     return
    }
    UI_PB_evt_AddBlkToARow page_obj seq_obj elem_obj
   }
   "top" \
   {
    UI_PB_evt_AddBlkAboveOrBelow page_obj seq_obj elem_obj
   }
   "bottom" \
   {
    UI_PB_evt_AddBlkAboveOrBelow page_obj seq_obj elem_obj
   }
  }
 }

#=======================================================================
proc UI_PB_evt_CheckBlkInTemplate {SEQ_OBJ NEW_ELEM_OBJ} {
  upvar $SEQ_OBJ seq_obj
  upvar $NEW_ELEM_OBJ new_elem_obj
  set block_obj $event_element::($new_elem_obj,block_obj)
  set new_block_name $block::($block_obj,block_name)
  set active_evt_obj $sequence::($seq_obj,add_blkto_evt_obj)
  set blk_temp_no $sequence::($seq_obj,blk_temp)
  set row_elements [lindex $event::($active_evt_obj,evt_elem_list) \
  $blk_temp_no]
  set blk_exists 0
  foreach elem_obj $row_elements \
  {
   set block_obj $event_element::($elem_obj,block_obj)
   set temp_blk_name $block::($block_obj,block_name)
   if {[string compare $temp_blk_name $new_block_name] == 0} \
   {
    set blk_exists 1
    break
   }
  }
  if {$blk_exists} \
  {
   return 1
  } else \
  {
   return 0
  }
 }

#=======================================================================
proc UI_PB_evt_UnHighlightSeperators {bot_canvas SEQ_OBJ} {
  upvar $SEQ_OBJ seq_obj
  global paOption
  if {$sequence::($seq_obj,focus_sep) != 0} \
  {
   $bot_canvas itemconfigure $sequence::($seq_obj,focus_sep) \
   -outline $paOption(can_bg)
   set sequence::($seq_obj,focus_sep) 0
  }
  if {$sequence::($seq_obj,focus_rect) != 0} \
  {
   set length [llength $sequence::($seq_obj,focus_rect)]
   set rect_id [lindex $sequence::($seq_obj,focus_rect) 0]
   $bot_canvas itemconfigure $rect_id -outline $paOption(can_bg) \
   -fill $paOption(can_bg)
   if {$length > 1} \
   {
    set sep_id1 [lindex $sequence::($seq_obj,focus_rect) 1]
    $bot_canvas itemconfigure $sep_id1 -outline $paOption(can_bg)
    set sep_id2 [lindex $sequence::($seq_obj,focus_rect) 2]
    $bot_canvas itemconfigure $sep_id2 -outline $paOption(can_bg)
   }
  }
 }

#=======================================================================
proc UI_PB_evt_AddBlkToARow {PAGE_OBJ SEQ_OBJ ELEM_OBJ} {
  upvar $PAGE_OBJ page_obj
  upvar $SEQ_OBJ seq_obj
  upvar $ELEM_OBJ elem_obj
  UI_PB_evt_DeleteSeqEvents page_obj seq_obj
  set bot_canvas $Page::($page_obj,bot_canvas)
  set active_evt_obj $sequence::($seq_obj,add_blkto_evt_obj)
  set blk_temp_no $sequence::($seq_obj,blk_temp)
  set row_elem_list [lindex $event::($active_evt_obj,evt_elem_list) \
  $blk_temp_no]
  lappend row_elem_list $elem_obj
  set event::($active_evt_obj,evt_elem_list) [lreplace \
  $event::($active_evt_obj,evt_elem_list) $blk_temp_no \
  $blk_temp_no $row_elem_list]
  UI_PB_evt_CreateSeqAttributes page_obj
 }

#=======================================================================
proc UI_PB_evt_AddBlkAboveOrBelow {PAGE_OBJ SEQ_OBJ NEW_ELEM_LIST} {
  upvar $PAGE_OBJ page_obj
  upvar $SEQ_OBJ seq_obj
  upvar $NEW_ELEM_LIST new_elem_list
  UI_PB_evt_DeleteSeqEvents page_obj seq_obj
  set active_evt_obj $sequence::($seq_obj,add_blkto_evt_obj)
  set blk_tempno $sequence::($seq_obj,blk_temp)
  set no_of_templates $event::($active_evt_obj,block_nof_rows)
  switch $sequence::($seq_obj,add_blk) \
  {
   "bottom" \
   {
    incr blk_tempno
   }
  }
  for {set count 0} {$count < $blk_tempno} {incr count} \
  {
   set temp_list [lindex $event::($active_evt_obj,evt_elem_list) $count]
   lappend elem_obj_list $temp_list
  }
  foreach new_elem_row $new_elem_list \
  {
   lappend elem_obj_list $new_elem_row
  }
  for {set count $blk_tempno} {$count < $no_of_templates} \
  {incr count} \
  {
   set temp_list [lindex $event::($active_evt_obj,evt_elem_list) $count]
   lappend elem_obj_list $temp_list
  }
  set event::($active_evt_obj,evt_elem_list) $elem_obj_list
  unset elem_obj_list
  set event::($active_evt_obj,block_nof_rows) [expr $no_of_templates + \
  [llength $new_elem_list]]
  UI_PB_evt_CreateSeqAttributes page_obj
 }

#=======================================================================
proc UI_PB_evt_CreateSeqEvent {PAGE_OBJ SEQ_OBJ TPTH_EVENT_FLAG} {
  upvar $PAGE_OBJ page_obj
  upvar $SEQ_OBJ seq_obj
  upvar $TPTH_EVENT_FLAG tpth_event_flag
  global tixOption
  global paOption
  set origin(0) 60
  set origin(1) 50
  set evt_dim_width [lindex $Page::($page_obj,glob_evnt_dim) 0]
  set evt_dim_height [lindex $Page::($page_obj,glob_evnt_dim) 1]
  set blk_dim_width [lindex $Page::($page_obj,glob_blk_dim) 0]
  set blk_dim_height [lindex $Page::($page_obj,glob_blk_dim) 1]
  set prev_evt_focus_cell $sequence::($seq_obj,evt_focus_cell)
  set prev_blk_focus_cell $sequence::($seq_obj,blk_focus_cell)
  set no_of_events [llength $sequence::($seq_obj,evt_obj_list)]
  set bot_canvas $Page::($page_obj,bot_canvas)
  set evt_xc [expr [expr $origin(0) + $evt_dim_width] / 2]
  set evt_yc [expr [expr $origin(1) + $evt_dim_height] / 2]
  UI_PB_evt_UnBindEvtProcs page_obj
  for {set evt_count 0} {$evt_count < $no_of_events} {incr evt_count} \
  {
   set evt_obj [lindex $sequence::($seq_obj,evt_obj_list) $evt_count]
   set event_name $event::($evt_obj,event_name)
   if { [string compare $event_name "Circular Move"] == 0} \
   {
    global mom_sys_arr
    if { $mom_sys_arr(\$cir_record_output) == "NO" } \
    {
     continue
    }
   }
   set event::($evt_obj,xc) $evt_xc
   set event::($evt_obj,yc) $evt_yc
   set event::($evt_obj,col_image) "minus"
   UI_PB_evt_CreateEvent page_obj seq_obj evt_obj
   if {$tpth_event_flag == 0} \
   {
    UI_PB_evt_CreateElementsOfEvent page_obj seq_obj evt_obj
   } else \
   {
    UI_PB_evt_CreateElemOfTpthEvent page_obj seq_obj evt_obj
   }
   set evt_yc $event::($evt_obj,event_height)
  }
  UI_PB_evt_BindCollapseImg  page_obj seq_obj
  global gPB
  set top_canvas $Page::($page_obj,top_canvas)
  set bot_canvas $Page::($page_obj,bot_canvas)
  set gPB(c_help,$top_canvas,add_movable)              "prog,add"
  set comb_widget $Page::($page_obj,comb_widget)
  set gPB(c_help,[$comb_widget subwidget arrow])       "prog,select"
  set gPB(c_help,$top_canvas,evt_trash)                "prog,trash"
  set gPB(c_help,$bot_canvas,blk_movable)              "prog,block"
  $bot_canvas bind seq_movable <ButtonRelease-1> " "
  set gPB(c_help,$bot_canvas,seq_movable)              "prog,marker"
  $bot_canvas bind evt_movable <ButtonRelease-1> " "
  set gPB(c_help,$bot_canvas,evt_movable)              "prog,event"
  set hlist [$Page::($page_obj,tree) subwidget hlist]
  set gPB(c_help,$hlist)                               "prog,tree"
  set gPB(c_help,$bot_canvas,nc_code)                  "prog,nc_code"
  set gPB(c_help,$bot_canvas,col_movable)              "prog,plus"
 }

#=======================================================================
proc UI_PB_evt_BindCollapseImg { PAGE_OBJ SEQ_OBJ } {
  upvar $PAGE_OBJ page_obj
  upvar $SEQ_OBJ seq_obj
  set bot_canvas $Page::($page_obj,bot_canvas)
  $bot_canvas bind col_movable <1> "UI_PB_evt_CollapseAEvent $page_obj \
  $seq_obj %x %y"
 }

#=======================================================================
proc UI_PB_evt_UnBindCollapseImg { PAGE_OBJ SEQ_OBJ } {
  upvar $PAGE_OBJ page_obj
  upvar $SEQ_OBJ seq_obj
  set bot_canvas $Page::($page_obj,bot_canvas)
  $bot_canvas bind col_movable <1> ""
 }

#=======================================================================
proc UI_PB_evt_DeleteSeqEvents  {PAGE_OBJ SEQ_OBJ} {
  upvar $PAGE_OBJ page_obj
  upvar $SEQ_OBJ seq_obj
  set bot_canvas $Page::($page_obj,bot_canvas)
  foreach evt_obj $sequence::($seq_obj,evt_obj_list) \
  {
   UI_PB_evt_DeleteAEvent $bot_canvas seq_obj evt_obj
   UI_PB_evt_DeleteEventElements page_obj seq_obj evt_obj
  }
 }

#=======================================================================
proc UI_PB_evt_CreateCollapseIcon {PAGE_OBJ SEQ_OBJ EVT_OBJ} {
  upvar $PAGE_OBJ page_obj
  upvar $SEQ_OBJ seq_obj
  upvar $EVT_OBJ evt_obj
  set image_name $event::($evt_obj,col_image)
  set icon_xc $event::($evt_obj,xc)
  set icon_yc $event::($evt_obj,yc)
  set evt_dim_width [lindex $Page::($page_obj,glob_evnt_dim) 0]
  set bot_canvas $Page::($page_obj,bot_canvas)
  set col_img_id [UI_PB_blk_CreateIcon $bot_canvas $image_name ""]
  set xc [expr [expr $icon_xc - [expr $evt_dim_width / 2]] - 15]
  set yc $icon_yc
  set icon_id [$bot_canvas create image $xc $yc \
  -image $col_img_id -tag col_movable]
  set event::($evt_obj,col_icon_id) $icon_id
 }

#=======================================================================
proc UI_PB_evt_RetBlkTypeFlag { PAGE_OBJ } {
  upvar $PAGE_OBJ page_obj
  global mom_sys_arr
  if {$Page::($page_obj,prev_seq) == 0 || $Page::($page_obj,prev_seq) == 1 || \
  $Page::($page_obj,prev_seq) == 3 || $Page::($page_obj,prev_seq) == 4} \
  {
   set flag $mom_sys_arr(seq_blk_nc_code)
  } else \
  {
   set flag 1
  }
  return $flag
 }

#=======================================================================
proc UI_PB_evt_CollapseAEvent {page_obj seq_obj x y} {
  global paOption
  set bot_canvas $Page::($page_obj,bot_canvas)
  set yy [$bot_canvas canvasy $y]
  set no_of_events [llength $sequence::($seq_obj,evt_obj_list)]
  for {set count 0} {$count < $no_of_events} {incr count} \
  {
   set evt_obj [lindex $sequence::($seq_obj,evt_obj_list) $count]
   if {$yy > [expr $event::($evt_obj,yc) - 10] && \
   $yy < [expr $event::($evt_obj,yc) + 10]} \
   {
    set evnt_index $count
   }
  }
  set evt_obj [lindex $sequence::($seq_obj,evt_obj_list) $evnt_index]
  set xc $event::($evt_obj,xc)
  set yc $event::($evt_obj,yc)
  set evt_evtdist $Page::($page_obj,glob_evt_evtdist)
  set evt_dim_height [lindex $Page::($page_obj,glob_evnt_dim) 1]
  set tpth_flag [UI_PB_evt_RetBlkTypeFlag page_obj]
  if {[string compare $event::($evt_obj,col_image) "minus"] == 0} \
  {
   if {$event::($evt_obj,block_nof_rows) == 0} \
   {
    return
   }
   if {$tpth_flag} \
   {
    set event::($evt_obj,event_height) [expr $yc + $evt_evtdist + \
    [expr $evt_dim_height / 2]]
    $bot_canvas delete $event::($evt_obj,blk_text)
    $bot_canvas delete $event::($evt_obj,blk_rect)
   } else \
   {
    set event::($evt_obj,event_height) [expr $yc + $evt_evtdist + \
    $evt_dim_height]
   }
   UI_PB_evt_DeleteEventElements page_obj seq_obj evt_obj
   $bot_canvas delete $event::($evt_obj,col_icon_id)
   set event::($evt_obj,col_image) "plus"
   } elseif {[string compare $event::($evt_obj,col_image) "plus"] == 0} {
   if {$tpth_flag} \
   {
    UI_PB_evt_CreateElemOfTpthEvent page_obj seq_obj evt_obj
   } else \
   {
    UI_PB_evt_CreateElementsOfEvent page_obj seq_obj evt_obj
   }
   $bot_canvas delete $event::($evt_obj,col_icon_id)
   set event::($evt_obj,col_image) "minus"
  }
  UI_PB_evt_CreateCollapseIcon page_obj seq_obj evt_obj
  if {$event::($evt_obj,block_nof_rows) > 1} \
  {
   UI_PB_evt_TransformEvtElem page_obj seq_obj evnt_index
  }
 }

#=======================================================================
proc UI_PB_evt_DeleteAEvent {bot_canvas SEQ_OBJ EVT_OBJ} {
  upvar $SEQ_OBJ seq_obj
  upvar $EVT_OBJ evt_obj
  if { $event::($evt_obj,icon_id) != "" } \
  {
   $bot_canvas delete $event::($evt_obj,icon_id)
  }
  if { $event::($evt_obj,text_id) != "" } \
  {
   $bot_canvas delete $event::($evt_obj,text_id)
  }
  if { $event::($evt_obj,col_icon_id) != "" } \
  {
   $bot_canvas delete $event::($evt_obj,col_icon_id)
  }
  if { $event::($evt_obj,evt_rect) != "" } \
  {
   $bot_canvas delete $event::($evt_obj,evt_rect)
  }
  set index [lsearch $sequence::($seq_obj,texticon_ids) \
  $event::($evt_obj,text_id)]
  if {$index != -1} \
  {
   set sequence::($seq_obj,texticon_ids) \
   [lreplace $sequence::($seq_obj,texticon_ids) $index [expr $index + 1]]
  }
  if { $event::($evt_obj,blk_text) != "" } \
  {
   $bot_canvas delete $event::($evt_obj,blk_text)
   set event::($evt_obj,blk_text) ""
  }
  if { $event::($evt_obj,blk_rect) != "" } \
  {
   $bot_canvas delete $event::($evt_obj,blk_rect)
   set event::($evt_obj,blk_rect) ""
  }
 }

#=======================================================================
proc UI_PB_evt_TransformEvtElem {PAGE_OBJ SEQ_OBJ EVNT_INDEX} {
  upvar $PAGE_OBJ page_obj
  upvar $SEQ_OBJ seq_obj
  upvar $EVNT_INDEX evnt_index
  set evt_evtdist $Page::($page_obj,glob_evt_evtdist)
  set bot_canvas $Page::($page_obj,bot_canvas)
  set evt_dim_height [lindex $Page::($page_obj,glob_evnt_dim) 1]
  set evt_evtdis $Page::($page_obj,glob_evt_evtdist)
  set no_of_events [llength $sequence::($seq_obj,evt_obj_list)]
  set tpth_flag [UI_PB_evt_RetBlkTypeFlag page_obj]
  for {set count [expr $evnt_index + 1]} {$count < $no_of_events} \
  {incr count} \
  {
   set evt_obj [lindex $sequence::($seq_obj,evt_obj_list) $count]
   UI_PB_evt_DeleteAEvent $bot_canvas seq_obj evt_obj
   UI_PB_evt_DeleteEventElements page_obj seq_obj evt_obj
  }
  set ind_evt_obj [lindex $sequence::($seq_obj,evt_obj_list) $evnt_index]
  set evt_xc $event::($ind_evt_obj,xc)
  set evt_yc $event::($ind_evt_obj,event_height)
  for {set count [expr $evnt_index + 1]} {$count < $no_of_events} \
  {incr count} \
  {
   set evt_obj [lindex $sequence::($seq_obj,evt_obj_list) $count]
   set event_name $event::($evt_obj,event_name)
   if { [string compare $event_name "Circular Move"] == 0} \
   {
    global mom_sys_arr
    if { $mom_sys_arr(\$cir_record_output) == "NO" } \
    {
     continue
    }
   }
   set event::($evt_obj,xc) $evt_xc
   set event::($evt_obj,yc) $evt_yc
   UI_PB_evt_CreateEvent page_obj seq_obj evt_obj
   if {[string compare $event::($evt_obj,col_image) "minus"] == 0} \
   {
    if {$tpth_flag} \
    {
     UI_PB_evt_CreateElemOfTpthEvent page_obj seq_obj evt_obj
    } else \
    {
     UI_PB_evt_CreateElementsOfEvent page_obj seq_obj evt_obj
    }
    set evt_yc $event::($evt_obj,event_height)
   } else \
   {
    if {$tpth_flag} \
    {
     set evt_yc [expr $evt_yc + [expr $evt_dim_height / 2] + \
     $evt_evtdis]
    } else \
    {
     set evt_yc [expr $evt_yc + $evt_dim_height + $evt_evtdis]
    }
   }
  }
 }

#=======================================================================
proc UI_PB_evt_CreateEvent { PAGE_OBJ SEQ_OBJ EVT_OBJ } {
  upvar $PAGE_OBJ page_obj
  upvar $SEQ_OBJ seq_obj
  upvar $EVT_OBJ evt_obj
  global tixOption
  global paOption
  if {$Page::($page_obj,prev_seq) == 0 || $Page::($page_obj,prev_seq) == 1 || \
  $Page::($page_obj,prev_seq) == 3 || $Page::($page_obj,prev_seq) == 4} \
  {
   set icon_bg $paOption(seq_bg)
   set text_bg $paOption(seq_fg)
   set icon_img "pb_marker"
   set icon_relief flat
   set bd_width 1
   set tag seq_movable
  } else \
  {
   set icon_bg $paOption(event)
   set text_bg white
   set icon_img "pb_event"
   set icon_relief raised
   set bd_width 2
   set tag evt_movable
  }
  set t_shift $Page::($page_obj,glob_text_shift)
  set bot_canvas $Page::($page_obj,bot_canvas)
  set evt_dim_width [lindex $Page::($page_obj,glob_evnt_dim) 0]
  set evt_dim_height [lindex $Page::($page_obj,glob_evnt_dim) 1]
  UI_PB_evt_CreateCollapseIcon page_obj seq_obj evt_obj
  set evt_img_id [UI_PB_blk_CreateIcon $bot_canvas $icon_img ""]
  $evt_img_id config -bg $icon_bg -borderwidth $bd_width
  set evt_xc $event::($evt_obj,xc)
  set evt_yc $event::($evt_obj,yc)
  set icon_id [$bot_canvas create image $evt_xc $evt_yc \
  -image $evt_img_id -tag $tag]
  $evt_img_id config -relief $icon_relief
  set event_name $event::($evt_obj,event_name)
  set text_id [$bot_canvas create text [expr $evt_xc + $t_shift] $evt_yc \
  -text $event_name -font $tixOption(bold_font) \
  -fill $text_bg -tag $tag]
  set event::($evt_obj,icon_id) $icon_id
  set event::($evt_obj,text_id) $text_id
  lappend sequence::($seq_obj,texticon_ids) $text_id $icon_id
  set cen_shift $Page::($page_obj,cen_shift)
  set cordx1 [expr $evt_xc + $cen_shift - [expr $evt_dim_width / 2]]
  set cordy1 [expr $evt_yc + $cen_shift - [expr $evt_dim_height / 2]]
  set cordx2 [expr $evt_xc + $cen_shift + [expr $evt_dim_width / 2]]
  set cordy2 [expr $evt_yc + $cen_shift + [expr $evt_dim_height / 2]]
  set rect_id [$bot_canvas create rect $cordx1 $cordy1 $cordx2 $cordy2 \
  -outline navyblue -fill navyblue]
  $bot_canvas lower $rect_id
  set event::($evt_obj,evt_rect) $rect_id
 }

#=======================================================================
proc UI_PB_evt_MarkerBindProcs { PAGE_OBJ SEQ_OBJ } {
  upvar $PAGE_OBJ page_obj
  upvar $SEQ_OBJ seq_obj
  set bot_canvas $Page::($page_obj,bot_canvas)
  $bot_canvas bind seq_movable <Enter> "_evt_MarkerFocusOn $bot_canvas \
  $seq_obj"
  $bot_canvas bind seq_movable <Leave> "_evt_MarkerFocusOff $bot_canvas \
  $seq_obj"
  $bot_canvas bind seq_movable <3>  "_evt_MarkerPopupMenu $page_obj \
  $seq_obj"
 }

#=======================================================================
proc UI_PB_evt_UnBindMarkerProcs { PAGE_OBJ } {
  upvar $PAGE_OBJ page_obj
  set bot_canvas $Page::($page_obj,bot_canvas)
  $bot_canvas bind seq_movable <Enter> ""
  $bot_canvas bind seq_movable <Leave> ""
  $bot_canvas bind seq_movable <3>  ""
 }

#=======================================================================
proc _evt_MarkerFocusOn { bot_canvas seq_obj } {
  global paOption
  set texticon_id $sequence::($seq_obj,texticon_ids)
  set objects [UI_PB_evt_GetCurrentCanvasObject $bot_canvas texticon_id]
  set img [lindex [$bot_canvas itemconfigure [lindex $objects 0] -image] end]
  $img configure -background $paOption(focus)
  set sequence::($seq_obj,evt_focus_cell) $objects
  global gPB
  set c $bot_canvas
  if { $gPB(use_info) } {
   $c config -cursor question_arrow
  }
 }

#=======================================================================
proc _evt_MarkerFocusOff { bot_canvas seq_obj } {
  global paOption
  set prev_evt_focus_cell $sequence::($seq_obj,evt_focus_cell)
  set texticon_id $sequence::($seq_obj,texticon_ids)
  set objects [UI_PB_evt_GetCurrentCanvasObject $bot_canvas texticon_id]
  set event_obj [UI_PB_evt_GetEventObjOfCurPos seq_obj [lindex $objects 0]]
  if {$prev_evt_focus_cell != 0} \
  {
   set img [lindex [$bot_canvas itemconfigure \
   [lindex $prev_evt_focus_cell 0] -image] end]
   if {[string compare $img ""] != 0 } \
   {
    $img configure -background $paOption(seq_bg)
    set sequence::($seq_obj,prev_evt_focus_cell) 0
   }
  }
  set c $bot_canvas
  $c config -cursor ""
 }

#=======================================================================
proc _evt_MarkerPopupMenu { page_obj seq_obj } {
  UI_PB_evt_CreateBlkPopup $page_obj $seq_obj evt
 }

#=======================================================================
proc UI_PB_evt_CreateElemOfTpthEvent {PAGE_OBJ SEQ_OBJ EVT_OBJ} {
  upvar $PAGE_OBJ page_obj
  upvar $SEQ_OBJ seq_obj
  upvar $EVT_OBJ evt_obj
  global paOption
  global tixOption
  set bot_canvas $Page::($page_obj,bot_canvas)
  set evt_blkdist $Page::($page_obj,glob_evt_blkdist)
  set evt_evtdist $Page::($page_obj,glob_evt_evtdist)
  set evt_dim_width [lindex $Page::($page_obj,glob_evnt_dim) 0]
  set evt_dim_height [lindex $Page::($page_obj,glob_evnt_dim) 1]
  set rect_gap $Page::($page_obj,glob_rect_gap)
  set evt_xc $event::($evt_obj,xc)
  set evt_yc $event::($evt_obj,yc)
  set blk_corner1_x [expr $evt_xc + [expr $evt_dim_width / 2] + \
  $evt_blkdist]
  set blk_corner1_y [expr $evt_yc - [expr $evt_dim_height / 2]]
  set rows $event::($evt_obj,block_nof_rows)
  set event::($evt_obj,event_width) 0
  UI_PB_com_ReturnEventNcOutAttr evt_obj str_size ver_height \
  evt_nc_output
  set blk_corner2_x [expr $blk_corner1_x + $str_size + 10]
  set blk_corner2_y [expr $blk_corner1_y + $ver_height + 10]
  if {[info exists evt_nc_output]} \
  {
   set rect_id [$bot_canvas create rect $blk_corner1_x $blk_corner1_y \
   $blk_corner2_x $blk_corner2_y -outline black \
   -width $rect_gap -fill $paOption(tree_bg) -tag nc_code]
   set line_id [UI_PB_evt_CreateLine bot_canvas $evt_xc \
   $evt_yc $blk_corner1_x $evt_yc]
   set xc [expr $blk_corner1_x + [expr $str_size / 2]]
   set yc [expr $blk_corner1_y + [expr $ver_height / 2]]
   set text_id [$bot_canvas create text [expr $xc + 8] [expr $yc + 13] \
   -font $tixOption(font_sm) -text $evt_nc_output \
   -justify left -tag nc_code]
   set event::($evt_obj,blk_rect) $rect_id
   set event::($evt_obj,blk_text) $text_id
   set event::($evt_obj,extra_lines) $line_id
   unset evt_nc_output
  }
  if {$ver_height} \
  {
   set event::($evt_obj,event_height) [expr $blk_corner1_y + \
   $ver_height + $evt_evtdist + $evt_dim_height]
  } else \
  {
   set event::($evt_obj,event_height) [expr $blk_corner1_y + \
   [expr 1.5 * $evt_dim_height] + $evt_evtdist]
  }
  if { $Page::($page_obj,prev_seq) != 0 && \
  $Page::($page_obj,prev_seq) != 6 } \
  {
   update idletasks
  }
 }

#=======================================================================
proc UI_PB_evt_CreateElementsOfEvent { PAGE_OBJ SEQ_OBJ EVT_OBJ } {
  upvar $PAGE_OBJ page_obj
  upvar $SEQ_OBJ seq_obj
  upvar $EVT_OBJ evt_obj
  global paOption
  global tixOption
  set bot_canvas $Page::($page_obj,bot_canvas)
  set blk_blkdist_hor $Page::($page_obj,glob_blk_blkdist_hor)
  set blk_blkdist_ver $Page::($page_obj,glob_blk_blkdist_ver)
  set evt_blkdist $Page::($page_obj,glob_evt_blkdist)
  set evt_evtdist $Page::($page_obj,glob_evt_evtdist)
  set t_shift $Page::($page_obj,glob_text_shift)
  set blk_dim_width [lindex $Page::($page_obj,glob_blk_dim) 0]
  set blk_dim_height [lindex $Page::($page_obj,glob_blk_dim) 1]
  set evt_dim_width [lindex $Page::($page_obj,glob_evnt_dim) 0]
  set evt_dim_height [lindex $Page::($page_obj,glob_evnt_dim) 1]
  set evt_xc $event::($evt_obj,xc)
  set evt_yc $event::($evt_obj,yc)
  set x1 $evt_xc
  set elem_xc [expr $evt_dim_width + $evt_xc + $evt_blkdist]
  set elem_yc $evt_yc
  set rows $event::($evt_obj,block_nof_rows)
  set event::($evt_obj,event_width) 0
  for {set count 0} {$count < $rows} {incr count} \
  {
   set evt_row_elem_list [lindex $event::($evt_obj,evt_elem_list) $count]
   foreach evt_elem_obj $evt_row_elem_list \
   {
    set event_element::($evt_elem_obj,xc) $elem_xc
    set event_element::($evt_elem_obj,yc) $elem_yc
    UI_PB_evt_CreateEventElement page_obj seq_obj evt_elem_obj
    set line_id [UI_PB_evt_CreateLine bot_canvas $x1 $elem_yc \
    $elem_xc $elem_yc]
    set event_element::($evt_elem_obj,line_id) $line_id
    set x1 $elem_xc
    set elem_xc [expr $elem_xc + $blk_dim_width + $blk_blkdist_hor]
   }
   set temp_ids [UI_PB_evt_CreateARowTempRect page_obj evt_obj count]
   lappend temp_rect [lindex $temp_ids 0]
   lappend sep_ids [lrange $temp_ids 1 end]
   if { $count < [expr $rows - 1]} \
   {
    set x1 [expr $evt_xc + [expr $evt_dim_width / 2] + \
    [expr $evt_blkdist / 2]]
    set y2 [expr $elem_yc + $blk_dim_height + $blk_blkdist_ver]
    set line_id [UI_PB_evt_CreateLine bot_canvas $x1 \
    $elem_yc $x1 $y2]
    lappend extra_lines $line_id
    set elem_yc $y2
    set elem_xc [expr $evt_dim_width + $evt_xc + $evt_blkdist]
    set y1 $y2
   }
  }
  if {$rows == 0} \
  {
   set temp_ids [UI_PB_evt_CreateARowTempRect page_obj evt_obj count]
   lappend temp_rect [lindex $temp_ids 0]
  }
  if {[info exists extra_lines]}\
  {
   set event::($evt_obj,extra_lines) $extra_lines
  }
  if {[info exists temp_rect]}\
  {
   set event::($evt_obj,rect_id) $temp_rect
  }
  if {[info exists sep_ids]} \
  {
   set event::($evt_obj,sep_id) $sep_ids
  }
  set event::($evt_obj,event_height) [expr $elem_yc + $evt_dim_height \
  + $evt_evtdist]
 }

#=======================================================================
proc UI_PB_evt_RetNoEvtElemsOfBlk { BLOCK_OBJ } {
  upvar $BLOCK_OBJ block_obj
  if { $block::($block_obj,blk_type) == "normal" || \
  $block::($block_obj,blk_type) == "comment" } \
  {
   if { $block::($block_obj,evt_elem_list) != "" } \
   {
    set evt_elem_list $block::($block_obj,evt_elem_list)
    set evt_elem_list [lsort -integer $evt_elem_list]
    set no_elems [llength $block::($block_obj,evt_elem_list)]
   } else \
   {
    set no_elems 0
   }
  } else \
  {
   set cmd_blk_elem [lindex $block::($block_obj,elem_addr_list) 0]
   set cmd_elem $block_element::($cmd_blk_elem,elem_mom_variable)
   if { [string match "*MOM_*" $cmd_elem] } \
   {
    set no_elems 0
   } else \
   {
    set evt_elem_list $command::($cmd_elem,blk_elem_list)
    set evt_elem_list [lsort -integer $evt_elem_list]
    set no_elems [llength $evt_elem_list]
   }
  }
  set count 0
  set no_blk_evts 0
  while { $count < $no_elems } \
  {
   set first_obj [lindex $evt_elem_list $count]
   set sec_obj [lindex $evt_elem_list [expr $count + 1]]
   if { $first_obj == $sec_obj } \
   {
    incr no_blk_evts 1
    incr count 2
   } else \
   {
    incr count 1
   }
  }
  return $no_blk_evts
 }

#=======================================================================
proc UI_PB_evt_CreateEventElement {PAGE_OBJ SEQ_OBJ EVT_ELEM_OBJ } {
  upvar $PAGE_OBJ page_obj
  upvar $SEQ_OBJ seq_obj
  upvar $EVT_ELEM_OBJ evt_elem_obj
  global paOption
  global tixOption
  global mom_sys_arr
  set bot_canvas $Page::($page_obj,bot_canvas)
  set blk_dim_width [lindex $Page::($page_obj,glob_blk_dim) 0]
  set blk_dim_height [lindex $Page::($page_obj,glob_blk_dim) 1]
  set t_shift $Page::($page_obj,glob_text_shift)
  set rect_gap $Page::($page_obj,glob_rect_gap)
  set block_obj $event_element::($evt_elem_obj,block_obj)
  if { [UI_PB_evt_RetNoEvtElemsOfBlk block_obj] > 1 } \
  {
   set icon_bg "lightSkyBlue"
   set text_bg "black"
  } else \
  {
   set icon_bg "white"
   set text_bg "black"
  }
  set elem_xc $event_element::($evt_elem_obj,xc)
  set elem_yc $event_element::($evt_elem_obj,yc)
  set cordx1 [expr $elem_xc - [expr $blk_dim_width / 2]]
  set cordy1 [expr $elem_yc - [expr $blk_dim_height / 2]]
  set cordx2 [expr $elem_xc + [expr $blk_dim_width / 2]]
  set cordy2 [expr $elem_yc + [expr $blk_dim_height / 2]]
  set rect_id [$bot_canvas create rect $cordx1 $cordy1 $cordx2 $cordy2 \
  -outline lightgray -fill lightgray]
  set event_element::($evt_elem_obj,rect_id) $rect_id
  if { $block::($block_obj,blk_type) == "normal" } \
  {
   set icon_name "pb_block"
   set blk_elem_list $block::($block_obj,elem_addr_list)
   UI_PB_com_ApplyMastSeqBlockElem blk_elem_list
   UI_PB_com_CreateBlkNcCode blk_elem_list blk_nc_code
   } elseif { $block::($block_obj,blk_type) == "comment" } \
  {
   set icon_name "pb_text"
   set blk_elem [lindex $block::($block_obj,elem_addr_list) 0]
   if { $mom_sys_arr(Comment_Start) != "" } \
   {
    append temp_nc_code "$mom_sys_arr(Comment_Start)"
   }
   append temp_nc_code "$block_element::($blk_elem,elem_mom_variable)"
   if { $mom_sys_arr(Comment_End) != "" } \
   {
    append temp_nc_code "$mom_sys_arr(Comment_End)"
   }
   set blk_nc_code $temp_nc_code
   unset temp_nc_code
   } elseif { $block::($block_obj,blk_type) == "command" } \
  {
   set icon_name "pb_finger"
   set cmd_blk_elem [lindex $block::($block_obj,elem_addr_list) 0]
   set cmd_obj $block_element::($cmd_blk_elem,elem_mom_variable)
   if { [string match "*MOM_*" $cmd_obj] } \
   {
    set blk_nc_code $cmd_obj
   } else \
   {
    set blk_nc_code $command::($cmd_obj,name)
   }
  } else \
  {
   set icon_name "pb_block"
  }
  set elem_img_id [UI_PB_blk_CreateIcon $bot_canvas $icon_name ""]
  $elem_img_id config -bg $icon_bg
  set elem_icon_id [$bot_canvas create image $elem_xc $elem_yc  \
  -image $elem_img_id -tag blk_movable]
  set event_element::($evt_elem_obj,icon_id) $elem_icon_id
  UI_PB_com_TrunkNcCode blk_nc_code
  set elem_text $blk_nc_code
  set elem_text_id [$bot_canvas create text [expr $elem_xc + $t_shift] \
  $elem_yc -text "$elem_text" -font $tixOption(font_sm) -justify left\
  -fill $text_bg -tag blk_movable]
  set event_element::($evt_elem_obj,text_id) $elem_text_id
  lappend sequence::($seq_obj,texticon_ids) $elem_text_id $elem_icon_id
 }

#=======================================================================
proc UI_PB_evt_CreateARowTempRect {PAGE_OBJ EVT_OBJ COUNT} {
  upvar $PAGE_OBJ page_obj
  upvar $EVT_OBJ evt_obj
  upvar $COUNT count
  global paOption
  set bot_canvas $Page::($page_obj,bot_canvas)
  set rect_gap $Page::($page_obj,glob_rect_gap)
  set evt_dim_width [lindex $Page::($page_obj,glob_evnt_dim) 0]
  set blk_dim_width [lindex $Page::($page_obj,glob_blk_dim) 0]
  set blk_dim_height [lindex $Page::($page_obj,glob_blk_dim) 1]
  set blk_blkdist_hor $Page::($page_obj,glob_blk_blkdist_hor)
  set blk_blkdist_ver $Page::($page_obj,glob_blk_blkdist_ver)
  set evt_blkdist $Page::($page_obj,glob_evt_blkdist)
  set no_rows $event::($evt_obj,block_nof_rows)
  if {$no_rows} \
  {
   set elem_obj_list [lindex $event::($evt_obj,evt_elem_list) $count]
   set no_elems [llength $elem_obj_list]
   if { $no_elems } \
   {
    set first_blk_obj [lindex $elem_obj_list 0]
    set xc $event_element::($first_blk_obj,xc)
    set yc $event_element::($first_blk_obj,yc)
   } else \
   {
    set xc $event::($evt_obj,xc)
    set yc $event::($evt_obj,yc)
   }
   set x1 [expr $xc - [expr $blk_dim_width / 2]]
   set y1 [expr $yc - [expr $blk_dim_height / 2]]
   set x2 [expr $x1 + [expr $blk_dim_width * $no_elems] + \
   [expr $blk_blkdist_hor * [expr $no_elems - 1]]]
   set y2 [expr $y1 + $blk_dim_height]
   set event_width $x2
   set rect_id [$bot_canvas create rect [expr $x1 - $rect_gap] \
   [expr $y1 - $rect_gap] [expr $x2 + $rect_gap] \
   [expr $y2 + $rect_gap] -outline $paOption(can_bg) \
   -width $rect_gap -fill $paOption(can_bg)]
   $bot_canvas lower $rect_id
   set top_sep [$bot_canvas create rect $x1 [expr $y1 - $rect_gap] \
   $x2 [expr $y1 - 1]\
   -outline $paOption(can_bg) -width $rect_gap]
   set bot_sep [$bot_canvas create rect $x1 [expr $y2 + 1] \
   $x2 [expr $y2 + $rect_gap] \
   -outline $paOption(can_bg)  -width $rect_gap]
   lappend template_ids $rect_id $top_sep $bot_sep
  } else \
  {
   set xc [expr $event::($evt_obj,xc) + $evt_dim_width + \
   $evt_blkdist]
   set yc $event::($evt_obj,yc)
   set no_elems 1
   set x1 [expr $xc - [expr $blk_dim_width / 2]]
   set y1 [expr $yc - [expr $blk_dim_height / 2]]
   set x2 [expr $x1 + [expr $blk_dim_width * $no_elems] + \
   [expr $blk_blkdist_hor * [expr $no_elems - 1]]]
   set y2 [expr $y1 + $blk_dim_height]
   set event_width $x2
   set rect_id [$bot_canvas create rect [expr $x1 - $rect_gap] \
   [expr $y1 - $rect_gap] [expr $x2 + $rect_gap] \
   [expr $y2 + $rect_gap] -outline $paOption(can_bg) \
   -width $rect_gap -fill $paOption(can_bg)]
   $bot_canvas lower $rect_id
   lappend template_ids $rect_id
  }
  if {$event_width > $event::($evt_obj,event_width)} \
  {
   set event::($evt_obj,event_width) $event_width
  }
  return $template_ids
 }

#=======================================================================
proc UI_PB_evt_DeleteEventElements {PAGE_OBJ SEQ_OBJ EVT_OBJ } {
  upvar $PAGE_OBJ page_obj
  upvar $SEQ_OBJ seq_obj
  upvar $EVT_OBJ evt_obj
  set bot_canvas $Page::($page_obj,bot_canvas)
  set no_of_rows $event::($evt_obj,block_nof_rows)
  set tpth_flag [UI_PB_evt_RetBlkTypeFlag page_obj]
  if {!$tpth_flag} \
  {
   for {set count 0} {$count < $no_of_rows} {incr count} \
   {
    set row_elem_objs [lindex $event::($evt_obj,evt_elem_list) $count]
    foreach elem_obj $row_elem_objs \
    {
     $bot_canvas delete $event_element::($elem_obj,icon_id)
     $bot_canvas delete $event_element::($elem_obj,rect_id)
     $bot_canvas delete $event_element::($elem_obj,text_id)
     $bot_canvas delete $event_element::($elem_obj,line_id)
     set index [lsearch $sequence::($seq_obj,texticon_ids) \
     $event_element::($elem_obj,text_id)]
     if {$index != -1} \
     {
      set sequence::($seq_obj,texticon_ids) \
      [lreplace $sequence::($seq_obj,texticon_ids) \
      $index [expr $index + 1]]
     }
    }
   }
   if { $event::($evt_obj,rect_id) != "" } \
   {
    foreach rect_id $event::($evt_obj,rect_id) \
    {
     $bot_canvas delete $rect_id
    }
    set event::($evt_obj,rect_id) ""
   }
   if { $event::($evt_obj,sep_id) != "" } \
   {
    foreach sep_list $event::($evt_obj,sep_id) \
    {
     foreach sep_id $sep_list \
     {
      $bot_canvas delete $sep_id
     }
    }
    set event::($evt_obj,sep_id) ""
   }
  }
  if { $event::($evt_obj,extra_lines) != "" } \
  {
   foreach line $event::($evt_obj,extra_lines) \
   {
    $bot_canvas delete $line
   }
   set event::($evt_obj,extra_lines) ""
  }
 }

#=======================================================================
proc UI_PB_evt_EvtBindProcs { PAGE_OBJ SEQ_OBJ } {
  upvar $PAGE_OBJ page_obj
  upvar $SEQ_OBJ seq_obj
  set bot_canvas $Page::($page_obj,bot_canvas)
  $bot_canvas bind evt_movable <Enter> "UI_PB_evt_EventFocusOn $bot_canvas \
  $seq_obj"
  $bot_canvas bind evt_movable <Leave> "UI_PB_evt_EventFocusOff $bot_canvas \
  $seq_obj"
  $bot_canvas bind evt_movable <1> "UI_PB_evt_EventStartDrag $page_obj \
  $seq_obj"
 }

#=======================================================================
proc UI_PB_evt_UnBindEvtProcs { PAGE_OBJ } {
  upvar $PAGE_OBJ page_obj
  set bot_canvas $Page::($page_obj,bot_canvas)
  $bot_canvas bind evt_movable <Enter> ""
  $bot_canvas bind evt_movable <Leave> ""
  $bot_canvas bind evt_movable <1>     ""
 }

#=======================================================================
proc UI_PB_evt_BlkBindProcs { PAGE_OBJ SEQ_OBJ } {
  upvar $PAGE_OBJ page_obj
  upvar $SEQ_OBJ seq_obj
  set bot_canvas $Page::($page_obj,bot_canvas)
  $bot_canvas bind blk_movable <Enter> "UI_PB_evt_BlockFocusOn $page_obj \
  $seq_obj"
  $bot_canvas bind blk_movable <Leave> "UI_PB_evt_BlockFocusOff $page_obj \
  $seq_obj"
  $bot_canvas bind blk_movable <1> "UI_PB_evt_BlockStartDrag $page_obj \
  $seq_obj %x %y"
  $bot_canvas bind blk_movable <B1-Motion> "UI_PB_evt_BlockDrag $page_obj \
  $seq_obj %x %y"
  $bot_canvas bind blk_movable <ButtonRelease-1> "UI_PB_evt_BlockEndDrag \
  $page_obj $seq_obj"
  $bot_canvas bind blk_movable <3> "UI_PB_evt_CreateBlkPopup $page_obj \
  $seq_obj blk"
 }

#=======================================================================
proc UI_PB_evt_BlkUnBindProcs { PAGE_OBJ SEQ_OBJ } {
  upvar $PAGE_OBJ page_obj
  upvar $SEQ_OBJ seq_obj
  set bot_canvas $Page::($page_obj,bot_canvas)
  $bot_canvas bind blk_movable <Enter> ""
  $bot_canvas bind blk_movable <Leave> ""
  $bot_canvas bind blk_movable <1> ""
  $bot_canvas bind blk_movable <B1-Motion> ""
  $bot_canvas bind blk_movable <ButtonRelease-1> ""
  $bot_canvas bind blk_movable <3> ""
 }

#=======================================================================
proc UI_PB_evt_UnBindBlkProcs { PAGE_OBJ } {
  upvar $PAGE_OBJ page_obj
  set bot_canvas $Page::($page_obj,bot_canvas)
  $bot_canvas bind blk_movable <Enter> " "
  $bot_canvas bind blk_movable <Leave> " "
  $bot_canvas bind blk_movable <1> " "
  $bot_canvas bind blk_movable <B1-Motion> " "
  $bot_canvas bind blk_movable <ButtonRelease-1> " "
 }

#=======================================================================
proc UI_PB_evt_EventFocusOn { bot_canvas seq_obj} {
  global paOption
  set texticon_id $sequence::($seq_obj,texticon_ids)
  set objects [UI_PB_evt_GetCurrentCanvasObject $bot_canvas texticon_id]
  set img [lindex [$bot_canvas itemconfigure [lindex $objects 0] -image] end]
  $img configure -background $paOption(focus)
  $bot_canvas itemconfigure [lindex $objects 1] -fill black
  set sequence::($seq_obj,evt_focus_cell) $objects
  global gPB
  set c $bot_canvas
  if { $gPB(use_info) } {
   $c config -cursor question_arrow
   } else {
   $c config -cursor hand2
  }
 }

#=======================================================================
proc UI_PB_evt_GetCurrentImage {canvas TEXTICON_ID } {
  upvar $TEXTICON_ID texticon_ids
  set test [$canvas itemconfigure current]
  set text_flag [lsearch $test "-text*"]
  set image_flag [lsearch $test "-image*"]
  if {$image_flag != -1} \
  {
   set img [lindex [$canvas itemconfigure current -image] end]
   } elseif {$text_flag != -1} \
  {
   set text_id [$canvas find withtag current]
   set index [lsearch $texticon_ids $text_id]
   set icon_id [lindex $texticon_ids [expr $index + 1]]
   set img [lindex [$canvas itemconfigure $icon_id -image] end]
  }
  return $img
 }

#=======================================================================
proc UI_PB_evt_GetCurrentCanvasObject {bot_canvas TEXTICON_ID} {
  upvar $TEXTICON_ID texticon_ids
  set test [$bot_canvas itemconfigure current]
  set text_flag [lsearch $test "-text*"]
  set image_flag [lsearch $test "-image*"]
  if {$image_flag != -1} \
  {
   set img [$bot_canvas find withtag current]
   set index [lsearch $texticon_ids $img]
   set text_id [lindex $texticon_ids [expr $index - 1]]
   lappend objects $img $text_id
   } elseif {$text_flag != -1} \
  {
   set text_id [$bot_canvas find withtag current]
   set index [lsearch $texticon_ids $text_id]
   set icon_id [lindex $texticon_ids [expr $index + 1]]
   lappend objects $icon_id $text_id
  }
  return $objects
 }

#=======================================================================
proc UI_PB_evt_EventFocusOff { bot_canvas seq_obj } {
  global paOption
  set prev_evt_focus_cell $sequence::($seq_obj,evt_focus_cell)
  set texticon_id $sequence::($seq_obj,texticon_ids)
  set objects [UI_PB_evt_GetCurrentCanvasObject $bot_canvas texticon_id]
  set event_obj [UI_PB_evt_GetEventObjOfCurPos seq_obj [lindex $objects 0]]
  if {$prev_evt_focus_cell != 0} \
  {
   set img [lindex [$bot_canvas itemconfigure \
   [lindex $prev_evt_focus_cell 0] -image] end]
   if {[string compare $img ""] != 0 } \
   {
    if {$event::($event_obj,event_open)} \
    {
     $img configure -background pink
    } else \
    {
     $img configure -background $paOption(event)
    }
    $bot_canvas itemconfigure [lindex $prev_evt_focus_cell 1] -fill white
    set sequence::($seq_obj,prev_evt_focus_cell) 0
   }
  }
  set c $bot_canvas
  $c config -cursor ""
 }

#=======================================================================
proc UI_PB_evt_EventStartDrag { page_obj seq_obj } {
  set texticon_id $sequence::($seq_obj,texticon_ids)
  set bot_canvas $Page::($page_obj,bot_canvas)
  set objects [UI_PB_evt_GetCurrentCanvasObject $bot_canvas texticon_id]
  set event_obj [UI_PB_evt_GetEventObjOfCurPos seq_obj  [lindex $objects 0]]
  set event::($event_obj,event_open) 1
  UI_PB_evt_ToolPath page_obj seq_obj event_obj
 }

#=======================================================================
proc UI_PB_eve_CreateBalloon { PAGE_OBJ SEQ_OBJ } {
  upvar $PAGE_OBJ page_obj
  upvar $SEQ_OBJ seq_obj
  global mom_sys_arr
  global gPB_help_tips
  global gPB
  if {$gPB_help_tips(state)} \
  {
   set c $Page::($page_obj,bot_canvas)
   if {![info exists gPB(seq_page_blk_item_focus_on)]} \
   {
    set gPB(seq_page_blk_item_focus_on) 0
   }
   if {$gPB(seq_page_blk_item_focus_on) == 0} \
   {
    set focus_img $sequence::($seq_obj,blk_focus_cell)
    UI_PB_evt_GetBlkObjFromImageid page_obj seq_obj $focus_img
    set evt_elem_obj $sequence::($seq_obj,drag_blk_obj)
    set block_obj $event_element::($evt_elem_obj,block_obj)
    if { $block::($block_obj,blk_type) == "normal" } \
    {
     set blk_elem_list $block::($block_obj,elem_addr_list)
     UI_PB_com_ApplyMastSeqBlockElem blk_elem_list
     UI_PB_com_CreateBlkNcCode blk_elem_list blk_nc_code
     append bal_desc "$blk_nc_code" \n "( " \
     $block::($block_obj,block_name) " )"
     } elseif { $block::($block_obj,blk_type) == "comment" } \
    {
     set elem_obj [lindex $block::($block_obj,elem_addr_list) 0]
     if { $mom_sys_arr(Comment_Start) != "" } \
     {
      append bal_desc "$mom_sys_arr(Comment_Start)"
     }
     append bal_desc $block_element::($elem_obj,elem_mom_variable)
     if { $mom_sys_arr(Comment_End) != "" } \
     {
      append bal_desc "$mom_sys_arr(Comment_End)"
     }
     append bal_desc \n "( $block_element::($elem_obj,elem_desc) ) "
    } else \
    {
     set cmd_elem_obj [lindex $block::($block_obj,elem_addr_list) 0]
     append bal_desc $block::($block_obj,block_name) \n \
     "( $block_element::($cmd_elem_obj,elem_desc) ) "
    }
    set bal_desc [join [split $bal_desc \$] \\\$]
    set gPB_help_tips($c) "$bal_desc"
    set gPB(seq_page_blk_item_focus_on) 1
   }
  }
 }

#=======================================================================
proc UI_PB_eve_DeleteBalloon { PAGE_OBJ } {
  upvar $PAGE_OBJ page_obj
  global gPB_help_tips
  if {$gPB_help_tips(state)} \
  {
   set c $Page::($page_obj,bot_canvas)
   if [info exists gPB_help_tips($c)] {
    unset gPB_help_tips($c)
   }
   PB_cancel_balloon
   global gPB
   set gPB(seq_page_blk_item_focus_on) 0
  }
 }

#=======================================================================
proc UI_PB_evt_BlockFocusOn { page_obj seq_obj } {
  global paOption
  set bot_canvas $Page::($page_obj,bot_canvas)
  set texticon_id $sequence::($seq_obj,texticon_ids)
  set img [UI_PB_evt_GetCurrentImage $bot_canvas texticon_id]
  set sequence::($seq_obj,blk_focus_cell) $img
  set icon_bg [lindex [$img config -bg] end]
  set sequence::($seq_obj,icon_bg)  $icon_bg
  $img configure -background $paOption(focus)
  UI_PB_eve_CreateBalloon page_obj seq_obj
  global gPB
  set c $bot_canvas
  if { $gPB(use_info) } {
   $c config -cursor question_arrow
   } else {
   $c config -cursor hand2
  }
 }

#=======================================================================
proc UI_PB_evt_BlockFocusOff { page_obj seq_obj } {
  global paOption
  set bot_canvas $Page::($page_obj,bot_canvas)
  set prev_blk_focus_cell $sequence::($seq_obj,blk_focus_cell)
  if {$prev_blk_focus_cell != 0} \
  {
   if { [string compare $sequence::($seq_obj,icon_bg) "lightSkyBlue"] == 0} \
   {
    $prev_blk_focus_cell configure -background lightSkyBlue
   } else \
   {
    $prev_blk_focus_cell configure -background white
   }
   set sequence::($seq_obj,blk_focus_cell) 0
  }
  UI_PB_eve_DeleteBalloon page_obj
  set c $bot_canvas
  $c config -cursor ""
 }

#=======================================================================
proc UI_PB_evt_GetBlkObjFromImageid {PAGE_OBJ SEQ_OBJ focus_img} {
  upvar $PAGE_OBJ page_obj
  upvar $SEQ_OBJ seq_obj
  set bot_canvas $Page::($page_obj,bot_canvas)
  set active_blk_flag 0
  foreach evt_obj $sequence::($seq_obj,evt_obj_list) \
  {
   set no_rows $event::($evt_obj,block_nof_rows)
   for {set count 0} {$count < $no_rows} {incr count} \
   {
    set row_elem_objs [lindex $event::($evt_obj,evt_elem_list) $count]
    foreach elem_obj $row_elem_objs \
    {
     set elem_img $event_element::($elem_obj,icon_id)
     set img_name [lindex [$bot_canvas itemconfigure $elem_img -image] end]
     if {[string compare $img_name $focus_img] == 0} \
     {
      set sequence::($seq_obj,drag_blk_obj) $elem_obj
      set sequence::($seq_obj,drag_evt_obj) $evt_obj
      set sequence::($seq_obj,drag_row) $count
      set active_blk_flag 1
      break
     }
    }
    if {$active_blk_flag} {break}
   }
   if {$active_blk_flag} {break}
  }
 }

#=======================================================================
proc UI_PB_evt_BlockStartDrag {page_obj seq_obj x y} {
  global paOption
  global tixOption
  global mom_sys_arr
  set Page::($page_obj,being_dragged) 0
  set bot_canvas $Page::($page_obj,bot_canvas)
  set top_canvas $Page::($page_obj,top_canvas)
  set t_shift $Page::($page_obj,glob_text_shift)
  set xx [$bot_canvas canvasx $x]
  set yy [$bot_canvas canvasy $y]
  set texticon_id $sequence::($seq_obj,texticon_ids)
  set img [UI_PB_evt_GetCurrentImage $bot_canvas texticon_id]
  set sequence::($seq_obj,prev_bot_blk_xc) $xx
  set sequence::($seq_obj,prev_bot_blk_yc) $yy
  UI_PB_evt_GetBlkObjFromImageid page_obj seq_obj $img
  set elem_obj $sequence::($seq_obj,drag_blk_obj)
  set elem_xc $event_element::($elem_obj,xc)
  set elem_yc $event_element::($elem_obj,yc)
  set diff_x [expr $xx - $elem_xc]
  set diff_y [expr $yy - $elem_yc]
  set panel_hi $Page::($page_obj,panel_hi)
  set dy [expr $panel_hi + 2]
  set block_obj $event_element::($elem_obj,block_obj)
  if {[string compare $block::($block_obj,blk_type) "normal"] == 0} \
  {
   set blk_elem_list $block::($block_obj,elem_addr_list)
   UI_PB_com_ApplyMastSeqBlockElem blk_elem_list
   UI_PB_com_CreateBlkNcCode blk_elem_list elem_text
   set elem_type "normal"
   set icon_name "pb_block"
   } elseif { [string compare $block::($block_obj,blk_type) "comment"] == 0 } \
  {
   set blk_elem [lindex $block::($block_obj,elem_addr_list) 0]
   append temp_text $mom_sys_arr(Comment_Start) \
   $block_element::($blk_elem,elem_mom_variable) \
   $mom_sys_arr(Comment_End)
   set elem_text $temp_text
   set elem_type "comment"
   set icon_name "pb_text"
   unset temp_text
   } elseif { [string compare $block::($block_obj,blk_type) "command"] == 0 } \
  {
   set cmd_blk_elem [lindex $block::($block_obj,elem_addr_list) 0]
   set cmd_obj $block_element::($cmd_blk_elem,elem_mom_variable)
   if { [string match "*MOM_*" $cmd_obj] } \
   {
    set elem_text $cmd_obj
   } else \
   {
    set elem_text $command::($cmd_obj,name)
   }
   set elem_type "command"
   set icon_name "pb_finger"
  } else \
  {
   set icon_name "pb_block"
  }
  UI_PB_com_TrunkNcCode elem_text
  set img_addr [UI_PB_blk_CreateIcon $top_canvas $icon_name ""]
  $img_addr config -bg $paOption(focus)
  set elem_top_img [$top_canvas create image [expr $x - $diff_x] \
  [expr $y + $dy - $diff_y] -image $img_addr -tag new_comp]
  set elem_top_text [$top_canvas create text \
  [expr $x - $diff_x + $t_shift] [expr $y + $dy - $diff_y] \
  -text $elem_text -font $tixOption(font_sm) -tag blk_movable]
  set sequence::($seq_obj,blk_top_img) $elem_top_img
  set sequence::($seq_obj,blk_top_text) $elem_top_text
  set sequence::($seq_obj,prev_top_blk_xc) $x
  set sequence::($seq_obj,prev_top_blk_yc) [expr $y + $panel_hi]
  set sequence::($seq_obj,drag_elem_type) $elem_type
 }

#=======================================================================
proc UI_PB_evt_BlockDrag {page_obj seq_obj x y} {
  if {$Page::($page_obj,being_dragged) < $Page::($page_obj,drag_sensitivity)} \
  {
   incr Page::($page_obj,being_dragged)
  }
  set top_canvas $Page::($page_obj,top_canvas)
  set bot_canvas $Page::($page_obj,bot_canvas)
  set panel_hi $Page::($page_obj,panel_hi)
  set xb [$bot_canvas canvasx $x]
  set yb [$bot_canvas canvasy $y]
  UI_PB_ScrollCanvasWin $page_obj $xb $yb
  set texticon_id $sequence::($seq_obj,texticon_ids)
  set objects [UI_PB_evt_GetCurrentCanvasObject $bot_canvas texticon_id]
  set xb [$bot_canvas canvasx $x]
  set yb [$bot_canvas canvasy $y]
  $bot_canvas move [lindex $objects 0] \
  [expr $xb - $sequence::($seq_obj,prev_bot_blk_xc)] \
  [expr $yb - $sequence::($seq_obj,prev_bot_blk_yc)]
  $bot_canvas move [lindex $objects 1] \
  [expr $xb - $sequence::($seq_obj,prev_bot_blk_xc)] \
  [expr $yb - $sequence::($seq_obj,prev_bot_blk_yc)]
  set sequence::($seq_obj,prev_bot_blk_xc) $xb
  set sequence::($seq_obj,prev_bot_blk_yc) $yb
  $bot_canvas raise [lindex $objects 0]
  $bot_canvas raise [lindex $objects 1]
  set elem_obj $sequence::($seq_obj,drag_blk_obj)
  set xt [$top_canvas canvasx $x]
  set yt [$top_canvas canvasy $y]
  $top_canvas move $sequence::($seq_obj,blk_top_img) \
  [expr $xt - $sequence::($seq_obj,prev_top_blk_xc)] \
  [expr $yt - $sequence::($seq_obj,prev_top_blk_yc) + $panel_hi]
  $top_canvas move $sequence::($seq_obj,blk_top_text) \
  [expr $xt - $sequence::($seq_obj,prev_top_blk_xc)] \
  [expr $yt - $sequence::($seq_obj,prev_top_blk_yc) + $panel_hi]
  set sequence::($seq_obj,prev_top_blk_xc) $xt
  set sequence::($seq_obj,prev_top_blk_yc) [expr $yt + $panel_hi]
  UI_PB_evt_TrashFocusOn page_obj seq_obj $x $y
  UI_PB_evt_GetEventObjFromCurPos page_obj seq_obj $xb $yb
  UI_PB_evt_HighLightSep page_obj seq_obj $xb $yb
 }

#=======================================================================
proc UI_PB_evt_BlockEndDrag {page_obj seq_obj} {
  global paOption
  global tixOption
  set bot_canvas $Page::($page_obj,bot_canvas)
  set elem_obj $sequence::($seq_obj,drag_blk_obj)
  set top_canvas $Page::($page_obj,top_canvas)
  $top_canvas delete $sequence::($seq_obj,blk_top_img)
  $top_canvas delete $sequence::($seq_obj,blk_top_text)
  UI_PB_evt_UnHighlightSeperators $bot_canvas seq_obj
  if {$Page::($page_obj,being_dragged) < \
  $Page::($page_obj,drag_sensitivity)} \
  {
   set focus_img $event_element::($elem_obj,icon_id)
   UI_PB_evt_EditBlock $page_obj $seq_obj $focus_img
  }
  if {$sequence::($seq_obj,trash_flag)} \
  {
   UI_PB_evt_PutBlkInTrash page_obj seq_obj
   } elseif {$sequence::($seq_obj,add_blk) != 0} \
  {
   UI_PB_evt_SwapBlocks page_obj seq_obj
  } else \
  {
   UI_PB_evt_ReturnBlock page_obj seq_obj
  }
  set sequence::($seq_obj,prev_top_blk_xc) 0
  set sequence::($seq_obj,prev_top_blk_yc) 0
  set sequence::($seq_obj,drag_flag) 0
  set sequence::($seq_obj,trash_flag) 0
  set sequence::($seq_obj,add_blk) 0
  set sequence::($seq_obj,drag_blk_obj) 0
  set sequence::($seq_obj,drag_evt_obj) 0
  set trash_cell $Page::($page_obj,trash)
  [lindex $trash_cell 0] config -bg $paOption(app_butt_bg)
  $Page::($page_obj,top_canvas) delete connect_line
  UI_PB_eve_DeleteBalloon page_obj
 }

#=======================================================================
proc UI_PB_evt_CreateBlkPopup { page_obj seq_obj widget_type } {
  global gPB
  set bot_canvas $Page::($page_obj,bot_canvas)
  set texticon_id $sequence::($seq_obj,texticon_ids)
  set cut_flag 1
  set copy_flag 1
  set refer_flag 1
  if { $widget_type == "blk" } \
  {
   set focus_img [UI_PB_evt_GetCurrentImage $bot_canvas texticon_id]
   UI_PB_evt_GetBlkObjFromImageid page_obj seq_obj $focus_img
   set evt_elem_obj $sequence::($seq_obj,drag_blk_obj)
   set block_obj $event_element::($evt_elem_obj,block_obj)
   if { $block::($block_obj,blk_type) == "comment" } \
   {
    set refer_flag 0
   }
  } else \
  {
   set objects [UI_PB_evt_GetCurrentCanvasObject $bot_canvas texticon_id]
   set focus_img [lindex $objects 0]
   set event_obj [UI_PB_evt_GetEventObjOfCurPos seq_obj $focus_img]
   if { $event::($event_obj,evt_elem_list) == "" } \
   {
    set copy_flag 0
    set cut_flag 0
   }
  }
  set popup $Page::($page_obj,popup)
  $popup delete 0 end
  if { $widget_type == "blk" } \
  {
   UI_PB_evt_GetBlkObjFromImageid page_obj seq_obj $focus_img
   set event_obj $sequence::($seq_obj,drag_evt_obj)
   set element_obj $sequence::($seq_obj,drag_blk_obj)
   set current_blk_obj $event_element::($element_obj,block_obj)
   set sep_flag 0
   if { [string match "*MOM_*" $block::($current_blk_obj,block_name)] == 0} \
   {
    $popup add command -label "$gPB(seq,edit_popup,Label)" -state normal \
    -command "UI_PB_evt_EditBlock $page_obj $seq_obj $focus_img"
    set sep_flag 1
   }
   if { $block::($current_blk_obj,blk_type) == "normal" } \
   {
    $popup add command -label "$gPB(seq,force_popup,Label)" -state normal \
    -command "UI_PB_evt_EvtBlockModality $page_obj $seq_obj $focus_img"
    set sep_flag 1
   }
   if { $sep_flag } { $popup add sep }
  }
  if { $cut_flag } \
  {
   $popup add command -label "$gPB(seq,cut_popup,Label)" -state normal \
   -command "UI_PB_evt_CutEventBlock $page_obj $seq_obj $focus_img \
   $widget_type 1"
  } else \
  {
   $popup add command -label "$gPB(seq,cut_popup,Label)" -state disabled
  }
  if { $copy_flag } \
  {
   $popup add cascade -label "$gPB(seq,copy_popup,Label)" \
   -menu $popup.copy -state normal
   catch {destroy $popup.copy}
   menu $popup.copy
   if { $refer_flag } \
   {
    $popup.copy add command -label "$gPB(seq,copy_popup,ref,Label)" \
    -state normal \
    -command "UI_PB_evt_CopyEventBlock $page_obj $seq_obj $focus_img \
    $widget_type  1"
   } else \
   {
    $popup.copy add command -label "$gPB(seq,copy_popup,ref,Label)" \
    -state disabled
   }
   $popup.copy add command -label "$gPB(seq,copy_popup,new,Label)" \
   -command "UI_PB_evt_CopyEventBlock $page_obj $seq_obj $focus_img \
   $widget_type 2"
  } else \
  {
   $popup add cascade -label "$gPB(seq,copy_popup,Label)" -state disabled
  }
  if { $Page::($page_obj,copy_flag) } \
  {
   set buff_blk_list $Page::($page_obj,buff_blk_obj)
   if { [llength $buff_blk_list] > 1} \
   {
    set in_line_flag 0
    } elseif { $buff_blk_list != "" } \
   {
    if { [llength [lindex $buff_blk_list 0]] > 1 } \
    {
     set in_line_flag 0
    } else \
    {
     set buff_obj [lindex [lindex $buff_blk_list 0] 0]
     if { [string match "PB_COMMENT~*" $buff_obj] } \
     {
      set in_line_flag 0
      } elseif { [string match "*MOM_*" $buff_obj] } \
     {
      set in_line_flag 0
      } elseif { [string trim [classof $buff_obj] ::] == "command" } \
     {
      set in_line_flag 0
     } else \
     {
      set in_line_flag 1
     }
    }
   } else \
   {
    set in_line_flag 1
   }
   $popup add cascade -label "$gPB(seq,paste_popup,Label)" \
   -state normal -menu $popup.paste
   catch {destroy $popup.paste}
   menu $popup.paste
   $popup.paste add command -label "$gPB(seq,paste_popup,before,Label)" \
   -command "UI_PB_evt_PasteEventBlock $page_obj $seq_obj $focus_img \
   $widget_type 1"
   if { $in_line_flag && $widget_type == "blk" } \
   {
    $popup.paste add command -label "$gPB(seq,paste_popup,inline,Label)" \
    -command "UI_PB_evt_PasteEventBlock $page_obj $seq_obj $focus_img \
    $widget_type 2"
   } else \
   {
    $popup.paste add command -label "$gPB(seq,paste_popup,inline,Label)" \
    -state disabled
   }
   $popup.paste add command -label "$gPB(seq,paste_popup,after,Label)" \
   -command "UI_PB_evt_PasteEventBlock $page_obj $seq_obj $focus_img \
   $widget_type 3"
  } else \
  {
   $popup add command -label "$gPB(seq,paste_popup,Label)" -state disabled \
   -command ""
  }
  if { $widget_type == "blk" } \
  {
   $popup add sep
   $popup add command -label "$gPB(seq,del_popup,Label)" -state normal \
   -command "UI_PB_evt_DeleteBlock $page_obj $seq_obj $focus_img"
  }
  set Page::($page_obj,popup_flag) 1
 }

#=======================================================================
proc UI_PB_evt_CutEventBlock { page_obj seq_obj focus_img widget_type \
  blk_flag } {
  if { $widget_type == "blk" } \
  {
   UI_PB_evt_GetBlkObjFromImageid page_obj seq_obj $focus_img
   set evt_elem_obj $sequence::($seq_obj,drag_blk_obj)
   set block_obj $event_element::($evt_elem_obj,block_obj)
   if { $block::($block_obj,blk_type) == "normal" } \
   {
    set Page::($page_obj,buff_blk_obj) $block_obj
    } elseif { $block::($block_obj,blk_type) == "comment" } \
   {
    set blk_elem [lindex $block::($block_obj,elem_addr_list) 0]
    set blk_elem_var $block_element::($blk_elem,elem_mom_variable)
    set blk_elem_var [join [split $blk_elem_var " "] "~"]
    append cmt_blk "PB_COMMENT~" "$blk_elem_var"
    set Page::($page_obj,buff_blk_obj) "$cmt_blk"
    unset cmt_blk
   } else \
   {
    set cmd_blk_elem [lindex $block::($block_obj,elem_addr_list) 0]
    set cmd_obj $block_element::($cmd_blk_elem,elem_mom_variable)
    set Page::($page_obj,buff_blk_obj) $cmd_obj
   }
   UI_PB_evt_PutBlkInTrash page_obj seq_obj
   set sequence::($seq_obj,drag_blk_obj) 0
   set sequence::($seq_obj,drag_evt_obj) 0
  } else \
  {
   set event_obj [UI_PB_evt_GetEventObjOfCurPos seq_obj $focus_img]
   if { $event_obj } \
   {
    UI_PB_evt_DeleteSeqEvents page_obj seq_obj
    set evt_blk_list ""
    foreach elem_row $event::($event_obj,evt_elem_list) \
    {
     set row_blk_list ""
     foreach elem_obj $elem_row \
     {
      set block_obj $event_element::($elem_obj,block_obj)
      block::DeleteFromEventElemList $block_obj elem_obj
      if { $block::($block_obj,blk_type) == "normal" } \
      {
       lappend row_blk_list $block_obj
       } elseif { $block::($block_obj,blk_type) == "comment" } \
      {
       set blk_elem [lindex $block::($block_obj,elem_addr_list) 0]
       set blk_elem_var $block_element::($blk_elem,elem_mom_variable)
       set blk_elem_var [join [split $blk_elem_var " "] "~"]
       append cmt_blk "PB_COMMENT~" "$blk_elem_var"
       lappend row_blk_list "$cmt_blk"
       unset cmt_blk
      } else \
      {
       set cmd_blk_elem [lindex $block::($block_obj,elem_addr_list) 0]
       set cmd_obj $block_element::($cmd_blk_elem,elem_mom_variable)
       lappend row_blk_list $cmd_obj
      }
     }
     lappend evt_blk_list $row_blk_list
    }
    set Page::($page_obj,buff_blk_obj) $evt_blk_list
    UI_PB_evt_DeleteChangeEvtElems event_obj
    set event::($event_obj,evt_elem_list) ""
    set event::($event_obj,block_nof_rows) 0
    UI_PB_evt_CreateSeqAttributes page_obj
   }
  }
  set Page::($page_obj,copy_flag) $blk_flag
 }

#=======================================================================
proc UI_PB_evt_GetEventObjOfCurPos { SEQ_OBJ focus_img } {
  upvar $SEQ_OBJ seq_obj
  set event_obj 0
  foreach event_obj $sequence::($seq_obj,evt_obj_list) \
  {
   if { [info exists event::($event_obj,icon_id)] } \
   {
    if { $event::($event_obj,icon_id) == $focus_img } { break }
   }
  }
  return $event_obj
 }

#=======================================================================
proc UI_PB_evt_RemBlkFromBuffList { PAGE_OBJ BLK_OBJ } {
  upvar $PAGE_OBJ page_obj
  upvar $BLK_OBJ blk_obj
  set buff_blk_list $Page::($page_obj,buff_blk_obj)
  set row_no 0
  foreach blk_row $buff_blk_list \
  {
   set elem_index [lsearch $blk_row $blk_obj]
   if { $elem_index != -1 } \
   {
    set blk_row [lreplace $blk_row $elem_index $elem_index]
    if { $blk_row != "" } \
    {
     set buff_blk_list [lreplace $buff_blk_list $row_no $row_no \
     $blk_row]
    } else \
    {
     set buff_blk_list [lreplace $buff_blk_list $row_no $row_no]
    }
   }
   incr row_no
  }
  set Page::($page_obj,buff_blk_obj) $buff_blk_list
 }

#=======================================================================
proc UI_PB_evt_CopyEventBlock { page_obj seq_obj focus_img widget_type \
  blk_flag } {
  if { $widget_type == "blk" } \
  {
   UI_PB_evt_GetBlkObjFromImageid page_obj seq_obj $focus_img
   set evt_elem_obj $sequence::($seq_obj,drag_blk_obj)
   set block_obj $event_element::($evt_elem_obj,block_obj)
   if { $block::($block_obj,blk_type) == "normal" } \
   {
    set Page::($page_obj,buff_blk_obj) $block_obj
    } elseif { $block::($block_obj,blk_type) == "comment" } \
   {
    set blk_elem [lindex $block::($block_obj,elem_addr_list) 0]
    set mom_var $block_element::($blk_elem,elem_mom_variable)
    set mom_var [join [split $mom_var " "] "~"]
    append cmt_blk "PB_COMMENT~" "$mom_var"
    set Page::($page_obj,buff_blk_obj) "$cmt_blk"
    unset cmt_blk
   } else \
   {
    set cmd_blk_elem [lindex $block::($block_obj,elem_addr_list) 0]
    set cmd_obj $block_element::($cmd_blk_elem,elem_mom_variable)
    set Page::($page_obj,buff_blk_obj) $cmd_obj
   }
   set sequence::($seq_obj,drag_blk_obj) 0
   set sequence::($seq_obj,drag_evt_obj) 0
  } else \
  {
   set event_obj [UI_PB_evt_GetEventObjOfCurPos seq_obj $focus_img]
   if { $event_obj } \
   {
    set evt_blk_list ""
    foreach elem_row $event::($event_obj,evt_elem_list) \
    {
     set row_blk_list ""
     foreach elem_obj $elem_row \
     {
      set block_obj $event_element::($elem_obj,block_obj)
      if { $block::($block_obj,blk_type) == "normal" } \
      {
       lappend row_blk_list $block_obj
       } elseif { $block::($block_obj,blk_type) == "comment" } \
      {
       set blk_elem [lindex $block::($block_obj,elem_addr_list) 0]
       set mom_var $block_element::($blk_elem,elem_mom_variable)
       set mom_var [join [split $mom_var " "] "~"]
       append cmt_blk "PB_COMMENT~" "$mom_var"
       set row_blk_list "$cmt_blk"
       unset cmt_blk
      } else \
      {
       set cmd_blk_elem [lindex $block::($block_obj,elem_addr_list) 0]
       set cmd_obj $block_element::($cmd_blk_elem,elem_mom_variable)
       lappend row_blk_list $cmd_obj
      }
     }
     lappend evt_blk_list $row_blk_list
    }
    set Page::($page_obj,buff_blk_obj) $evt_blk_list
   }
  }
  set Page::($page_obj,copy_flag) $blk_flag
 }

#=======================================================================
proc UI_PB_evt_PasteEventBlock { page_obj seq_obj focus_img widget_type \
  add_flag } {
  if { $Page::($page_obj,buff_blk_obj) != "" } \
  {
   set new_evt_elem_list ""
   set buff_blk_list $Page::($page_obj,buff_blk_obj)
   for { set row_no 0 } { $row_no < [llength $buff_blk_list] } \
   { incr row_no } \
   {
    set blk_row [lindex $buff_blk_list $row_no]
    for { set elem_no 0 } { $elem_no < [llength $blk_row] } \
    { incr elem_no } \
    {
     set new_elem_row ""
     set block_obj [lindex $blk_row $elem_no]
     if { $Page::($page_obj,copy_flag) == 2 } \
     {
      if { [string match "PB_COMMENT~*" $block_obj] } \
      {
       set comment [string trimleft $block_obj "PB_COMMENT"]
       set comment [string trimleft $comment ~]
       set comment [join [split $comment "~"] " "]
       set elem_name "comment_blk"
       PB_int_CreateCommentBlkElem elem_name cmt_elem_obj
       set block_element::($cmt_elem_obj,elem_mom_variable) $comment
       PB_int_CreateCommentBlk elem_name cmt_elem_obj new_blk_obj
       } elseif { [string match "*MOM_*" $block_obj] } \
      {
       PB_int_CreateCmdBlkFromCmd block_obj new_blk_obj
       } elseif { [string trim [classof $block_obj] ::] == "block" } \
      {
       PB_int_CreateCopyABlock block_obj new_blk_obj
      } else \
      {
       PB_int_CreateCopyACmdBlk block_obj new_blk_obj
      }
     } else \
     {
      if { [string match "PB_COMMENT~*" $block_obj] } \
      {
       set comment [string trimleft $block_obj "PB_COMMENT"]
       set comment [string trimleft $comment ~]
       set comment [join [split $comment "~"] " "]
       set elem_name "comment_blk"
       PB_int_CreateCommentBlkElem elem_name cmt_elem_obj
       set block_element::($cmt_elem_obj,elem_mom_variable) $comment
       PB_int_CreateCommentBlk elem_name cmt_elem_obj new_blk_obj
       } elseif { [string match "*MOM_*" $block_obj] } \
      {
       PB_int_CreateCmdBlkFromCmd block_obj new_blk_obj
       } elseif { [string trim [classof $block_obj] ::] == "command" } \
      {
       PB_int_CreateCmdBlkFromCmd block_obj new_blk_obj
      } else \
      {
       set new_blk_obj $block_obj
      }
     }
     PB_int_CreateNewEventElement new_blk_obj new_evt_elem
     lappend new_elem_row $new_evt_elem
    }
    lappend new_evt_elem_list $new_elem_row
   }
   if { $widget_type == "blk" } \
   {
    UI_PB_evt_GetBlkObjFromImageid page_obj seq_obj $focus_img
    set add_to_elem_obj $sequence::($seq_obj,drag_blk_obj)
    set sequence::($seq_obj,add_blkto_evt_obj) \
    $sequence::($seq_obj,drag_evt_obj)
    set sequence::($seq_obj,blk_temp) $sequence::($seq_obj,drag_row)
   } else \
   {
    set event_obj [UI_PB_evt_GetEventObjOfCurPos seq_obj $focus_img]
    set no_rows [llength $event::($event_obj,evt_elem_list)]
    set sequence::($seq_obj,add_blkto_evt_obj) $event_obj
    switch $add_flag \
    {
     1 { set sequence::($seq_obj,blk_temp) 0 }
     3 { set sequence::($seq_obj,blk_temp) [expr $no_rows - 1] }
    }
   }
   switch $add_flag \
   {
    1 { set sequence::($seq_obj,add_blk) "top" }
    2 { set sequence::($seq_obj,add_blk) "row" }
    3 { set sequence::($seq_obj,add_blk) "bottom" }
   }
   UI_PB_evt_AddBlockToEvent page_obj seq_obj new_evt_elem_list
   if { $Page::($page_obj,copy_flag) == 2 } \
   {
    UI_PB_evt_CreateMenuOptions page_obj seq_obj
   }
   set sequence::($seq_obj,drag_evt_obj) 0
   set sequence::($seq_obj,add_blk) 0
   set sequence::($seq_obj,blk_temp) 0
  }
 }

#=======================================================================
proc UI_PB_evt_DeleteBlock { page_obj seq_obj focus_img } {
  UI_PB_evt_GetBlkObjFromImageid page_obj seq_obj $focus_img
  UI_PB_evt_PutBlkInTrash page_obj seq_obj
 }

#=======================================================================
proc UI_PB_evt_EvtBlockModality { page_obj seq_obj focus_img } {
  global gPB
  set bot_canvas $Page::($page_obj,bot_canvas)
  UI_PB_evt_GetBlkObjFromImageid page_obj seq_obj $focus_img
  set element_obj $sequence::($seq_obj,drag_blk_obj)
  set current_blk_obj $event_element::($element_obj,block_obj)
  set canvas_frame $Page::($page_obj,canvas_frame)
  set evt_img_id $event_element::($element_obj,icon_id)
  set img [lindex [$bot_canvas itemconfigure $evt_img_id -image] end]
  $img config -relief sunken -bg pink
  update
  set win [toplevel $canvas_frame.mod]
  set toplevel_index [llength $gPB(toplevel_list)]
  set win_index [expr $toplevel_index + 1]
  set gPB(toplevel_disable_$win_index) 1
  UI_PB_com_CreateTransientWindow $win "$gPB(seq,force_trans,title,Label)" \
  "" "UI_PB_DisableProgPageWidgets $page_obj $seq_obj" \
  "" "UI_PB_evt_ActivateProgPageWidgets $page_obj $seq_obj $win_index"
  UI_PB_blk_ModalityDialog page_obj seq_obj element_obj win
 }

#=======================================================================
proc UI_PB_evt_EditBlock { page_obj seq_obj focus_img } {
  set bot_canvas $Page::($page_obj,bot_canvas)
  UI_PB_evt_GetBlkObjFromImageid page_obj seq_obj $focus_img
  set event_obj $sequence::($seq_obj,drag_evt_obj)
  set element_obj $sequence::($seq_obj,drag_blk_obj)
  set current_blk_obj $event_element::($element_obj,block_obj)
  UI_PB_evt_BlockFocusOff $page_obj $seq_obj
  if { $block::($current_blk_obj,blk_type) == "normal" } \
  {
   set evt_img_id $event_element::($element_obj,icon_id)
   set img [lindex [$bot_canvas itemconfigure $evt_img_id -image] end]
   $img config -relief sunken -bg pink
   update idletasks
   UI_PB_evt__DisplayBlockPage $page_obj $seq_obj $current_blk_obj \
   new_blk_page_obj
   set box_frm $Page::($new_blk_page_obj,box)
   set cb_arr(gPB(nav_button,default,Label)) \
   "UI_PB_blk_DefaultCallBack $new_blk_page_obj"
   set cb_arr(gPB(nav_button,restore,Label)) \
   "UI_PB_blk_RestoreCallBack $new_blk_page_obj"
   set cb_arr(gPB(nav_button,cancel,Label)) \
   "UI_PB_blk_EditCancel_CB $new_blk_page_obj \
   $page_obj $seq_obj $element_obj"
   set cb_arr(gPB(nav_button,ok,Label)) \
   "UI_PB_blk_EditOk_CB $new_blk_page_obj $page_obj \
   $seq_obj $element_obj"
   UI_PB_com_CreateActionElems $box_frm cb_arr
   } elseif { $block::($current_blk_obj,blk_type) == "comment" } \
  {
   UI_PB_evt_BringCommentDlg page_obj seq_obj event_obj element_obj \
   current_blk_obj Edit
  } else \
  {
   set block_obj $event_element::($element_obj,block_obj)
   set cmd_name $block::($block_obj,block_name)
   if { [string match "*MOM_*" $cmd_name] == 0 } \
   {
    UI_PB_evt_BringCmdBlkPage page_obj seq_obj event_obj element_obj \
    current_blk_obj Edit
   }
  }
 }

#=======================================================================
proc UI_PB_DisableProgPageWidgets { page_obj seq_obj } {
  tixDisableAll $Page::($page_obj,page_id)
  UI_PB_evt_AddUnBindProcs     page_obj
  UI_PB_evt_BlkUnBindProcs     page_obj seq_obj
  UI_PB_evt_UnBindCollapseImg  page_obj seq_obj
  UI_PB_evt_UnBindMarkerProcs page_obj
  set bot_canvas $Page::($page_obj,bot_canvas)
  $bot_canvas config -cursor ""
  bind $bot_canvas <3> ""
 }

#=======================================================================
proc UI_PB_evt__DisplayBlockPage { page_obj seq_obj block_obj \
  NEW_BLK_PAGE_OBJ } {
  upvar $NEW_BLK_PAGE_OBJ new_blk_page_obj
  global gPB
  set canvas_frame $Page::($page_obj,canvas_frame)
  block::readvalue $block_obj blk_obj_attr
  set win [toplevel $canvas_frame.$blk_obj_attr(0)]
  set toplevel_index [llength $gPB(toplevel_list)]
  set win_index [expr $toplevel_index + 1]
  set gPB(toplevel_disable_$win_index) 1
  UI_PB_com_CreateTransientWindow $win \
  "$gPB(seq,new_trans,title,Label) : $blk_obj_attr(0)" \
  "700x600+200+200" "UI_PB_DisableProgPageWidgets $page_obj $seq_obj" \
  "" "UI_PB_evt_ActivateProgPageWidgets $page_obj $seq_obj $win_index"
  UI_PB_blk_CreateBlockPage block_obj win new_blk_page_obj
 }

#=======================================================================
proc UI_PB_evt_ActivateProgPageWidgets { page_obj seq_obj win_index } {
  global gPB
  if { $gPB(toplevel_disable_$win_index) } \
  {
   tixEnableAll $Page::($page_obj,page_id)
   UI_PB_evt_AddBindProcs     page_obj
   UI_PB_evt_BlkBindProcs     page_obj seq_obj
   UI_PB_evt_BindCollapseImg  page_obj seq_obj
   UI_PB_evt_MarkerBindProcs  page_obj seq_obj
   set gPB(toplevel_disable_$win_index) 0
   set bot_canvas $Page::($page_obj,bot_canvas)
   bind $bot_canvas <3> "UI_PB_evt_CanvasPopupMenu $page_obj %X %Y"
   set comb_widget $Page::($page_obj,comb_widget)
   [$comb_widget subwidget entry] config -bg lightBlue -justify left \
   -state disabled  -cursor ""
  }
 }

#=======================================================================
proc UI_PB_evt_SwapBlocks {PAGE_OBJ SEQ_OBJ} {
  upvar $PAGE_OBJ page_obj
  upvar $SEQ_OBJ seq_obj
  if {![info exists sequence::($seq_obj,add_blkto_evt_obj)]} \
  {
   return
  }
  set drag_elem_obj $sequence::($seq_obj,drag_blk_obj)
  if {[string compare $sequence::($seq_obj,add_blk) "row"] == 0} \
  {
   set blk_exists_flag [UI_PB_evt_CheckBlkInTemplate seq_obj drag_elem_obj]
   if {$blk_exists_flag} \
   {
    set bot_canvas $Page::($page_obj,bot_canvas)
    UI_PB_evt_BlockFocusOff $page_obj $seq_obj
    set block_obj $event_element::($drag_elem_obj,block_obj)
    set block_name $block::($block_obj,block_name)
    tk_messageBox  -parent [UI_PB_com_AskActiveWindow] \
    -type ok -icon error \
    -message "Block $block_name exists in the Block Template"
    UI_PB_evt_ReturnBlock page_obj seq_obj
    return
   }
  }
  set drag_evt_obj $sequence::($seq_obj,drag_evt_obj)
  set no_rows $event::($drag_evt_obj,block_nof_rows)
  for {set count 0} {$count < $no_rows} {incr count} \
  {
   set elem_index [lsearch [lindex $event::($drag_evt_obj,evt_elem_list) \
   $count] $sequence::($seq_obj,drag_blk_obj)]
   if {$elem_index != -1} { break }
  }
  set add_evt_obj $sequence::($seq_obj,add_blkto_evt_obj)
  if {[string compare $event::($add_evt_obj,col_image) "minus"] == 0} \
  {
   if {[llength [lindex $event::($drag_evt_obj,evt_elem_list) \
   $count]] > 1} \
   {
    UI_PB_evt_AddDragBlockToRow page_obj seq_obj count elem_index
   } else \
   {
    UI_PB_evt_AddDragBlockAboveOrBelow page_obj seq_obj count
   }
  } else \
  {
   UI_PB_evt_ReturnBlock page_obj seq_obj
  }
 }

#=======================================================================
proc UI_PB_evt_AddDragBlockToRow { PAGE_OBJ SEQ_OBJ COUNT ELEM_INDEX} {
  upvar $PAGE_OBJ page_obj
  upvar $SEQ_OBJ seq_obj
  upvar $COUNT count
  upvar $ELEM_INDEX elem_index
  set drag_evt_obj $sequence::($seq_obj,drag_evt_obj)
  set drag_elem_obj $sequence::($seq_obj,drag_blk_obj)
  UI_PB_evt_DeleteEventElements page_obj seq_obj drag_evt_obj
  set row_elem_list [lindex $event::($drag_evt_obj,evt_elem_list) $count]
  set row_elem_list [lreplace $row_elem_list $elem_index $elem_index]
  set event::($drag_evt_obj,evt_elem_list) \
  [lreplace $event::($drag_evt_obj,evt_elem_list) $count $count \
  $row_elem_list]
  UI_PB_evt_CreateElementsOfEvent page_obj seq_obj drag_evt_obj
  set blk_obj $event_element::($drag_elem_obj,block_obj)
  PB_int_CreateNewEventElement blk_obj new_evt_elem
  UI_PB_evt_DeleteEvtElem drag_evt_obj drag_elem_obj
  UI_PB_evt_AddBlockToEvent page_obj seq_obj new_evt_elem
 }

#=======================================================================
proc UI_PB_evt_AddDragBlockAboveOrBelow { PAGE_OBJ SEQ_OBJ COUNT} {
  upvar $PAGE_OBJ page_obj
  upvar $SEQ_OBJ seq_obj
  upvar $COUNT count
  set drag_evt_obj $sequence::($seq_obj,drag_evt_obj)
  set drag_elem_obj $sequence::($seq_obj,drag_blk_obj)
  UI_PB_evt_DeleteEventElements page_obj seq_obj drag_evt_obj
  set add_evt_obj $sequence::($seq_obj,add_blkto_evt_obj)
  set event::($drag_evt_obj,evt_elem_list) \
  [lreplace $event::($drag_evt_obj,evt_elem_list) $count $count]
  set event::($drag_evt_obj,block_nof_rows) \
  [expr $event::($drag_evt_obj,block_nof_rows) - 1]
  if {$drag_evt_obj == $add_evt_obj} \
  {
   if {$sequence::($seq_obj,blk_temp) > $count} \
   {
    incr sequence::($seq_obj,blk_temp) -1
   }
  }
  UI_PB_evt_CreateElementsOfEvent page_obj seq_obj drag_evt_obj
  set active_evt_index [lsearch $sequence::($seq_obj,evt_obj_list) \
  $drag_evt_obj]
  UI_PB_evt_TransformEvtElem page_obj seq_obj active_evt_index
  set blk_obj $event_element::($drag_elem_obj,block_obj)
  if { $block::($blk_obj,blk_type) == "command" } \
  {
   set prev_cmd_blk_elem  [lindex $block::($blk_obj,elem_addr_list) 0]
   set cmd_obj $block_element::($prev_cmd_blk_elem,elem_mom_variable)
   if { [string match "*MOM_*" $cmd_obj] } \
   {
    set cmd_name $cmd_obj
   } else \
   {
    set cmd_name $command::($cmd_obj,name)
   }
   PB_int_CreateCmdBlkElem cmd_name cmd_blk_elem
   PB_int_CreateCmdBlock cmd_name cmd_blk_elem new_blk_obj
   PB_int_CreateNewEventElement new_blk_obj new_evt_elem
   } elseif { $block::($blk_obj,blk_type) == "comment" } \
  {
   set prev_cmd_blk_elem  [lindex $block::($blk_obj,elem_addr_list) 0]
   set elem_name "comment_blk"
   PB_int_CreateCommentBlkElem elem_name blk_elem_obj
   set block_element::($blk_elem_obj,elem_mom_variable) \
   $block_element::($prev_cmd_blk_elem,elem_mom_variable)
   PB_int_CreateCommentBlk elem_name blk_elem_obj new_blk_obj
   PB_int_CreateNewEventElement new_blk_obj new_evt_elem
  } else \
  {
   PB_int_CreateNewEventElement blk_obj new_evt_elem
  }
  UI_PB_evt_DeleteEvtElem drag_evt_obj drag_elem_obj
  UI_PB_evt_AddBlockToEvent page_obj seq_obj new_evt_elem
 }

#=======================================================================
proc UI_PB_evt_DeleteEvtElem { EVENT_OBJ EVT_ELEM_OBJ } {
  upvar $EVENT_OBJ event_obj
  upvar $EVT_ELEM_OBJ evt_elem_obj
  array set rest_evt_obj_attr $event::($event_obj,rest_value)
  array set def_evt_obj_attr $event::($event_obj,def_value)
  set def_flag 0
  foreach def_row $def_evt_obj_attr(2) \
  {
   if { [lsearch $def_row $evt_elem_obj] != -1 } \
   {
    set def_flag 1
    break
   }
  }
  set rest_flag 0
  foreach rest_row $rest_evt_obj_attr(2) \
  {
   if { [lsearch $rest_row $evt_elem_obj] != -1 } \
   {
    set rest_flag 1
    break
   }
  }
  if { $rest_flag == 0 && $def_flag == 0 } \
  {
   set block_obj $event_element::($evt_elem_obj,block_obj)
   if { $block::($block_obj,blk_type) == "command" } \
   {
    delete $block_obj
    } elseif { $block::($block_obj,blk_type) == "comment" } \
   {
    PB_int_DeleteCommentBlkFromList block_obj
    delete $block_obj
   }
   delete $evt_elem_obj
  } else \
  {
   set block_obj $event_element::($evt_elem_obj,block_obj)
   block::DeleteFromEventElemList $block_obj evt_elem_obj
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

#=======================================================================
proc UI_PB_evt_PutBlkInTrash {PAGE_OBJ SEQ_OBJ } {
  upvar $PAGE_OBJ page_obj
  upvar $SEQ_OBJ seq_obj
  UI_PB_evt_DeleteSeqEvents page_obj seq_obj
  set active_evt_obj $sequence::($seq_obj,drag_evt_obj)
  set evt_elem_obj $sequence::($seq_obj,drag_blk_obj)
  set no_rows $event::($active_evt_obj,block_nof_rows)
  for {set count 0} {$count < $no_rows} {incr count} \
  {
   set elem_index [lsearch [lindex $event::($active_evt_obj,evt_elem_list) \
   $count] $sequence::($seq_obj,drag_blk_obj)]
   if {$elem_index != -1} { break }
  }
  if {[llength [lindex $event::($active_evt_obj,evt_elem_list) \
  $count]] > 1} \
  {
   set row_elem_list [lindex $event::($active_evt_obj,evt_elem_list) \
   $count]
   set row_elem_list [lreplace $row_elem_list $elem_index $elem_index]
   set event::($active_evt_obj,evt_elem_list) \
   [lreplace $event::($active_evt_obj,evt_elem_list) $count \
   $count $row_elem_list]
   UI_PB_evt_DeleteEvtElem active_evt_obj evt_elem_obj
  } else \
  {
   set event::($active_evt_obj,evt_elem_list) \
   [lreplace $event::($active_evt_obj,evt_elem_list) $count $count]
   set event::($active_evt_obj,block_nof_rows) [expr $no_rows - 1]
   UI_PB_evt_DeleteEvtElem active_evt_obj evt_elem_obj
  }
  UI_PB_evt_CreateSeqAttributes page_obj
 }

#=======================================================================
proc UI_PB_evt_TrashFocusOn {PAGE_OBJ SEQ_OBJ x y} {
  upvar $PAGE_OBJ page_obj
  upvar $SEQ_OBJ seq_obj
  global paOption
  set top_canvas $Page::($page_obj,top_canvas)
  set trash_cell $Page::($page_obj,trash)
  if {$x > [lindex $trash_cell 1] && $x < [lindex $trash_cell 2] && \
  $y > [lindex $trash_cell 3] && $y < [lindex $trash_cell 4]} \
  {
   [lindex $trash_cell 0] config -bg $paOption(focus)
   UI_PB_blk_TrashConnectLine page_obj
   set sequence::($seq_obj,trash_flag) 1
  } else \
  {
   [lindex $trash_cell 0] config -bg $paOption(app_butt_bg)
   set sequence::($seq_obj,trash_flag) 0
   $top_canvas delete connect_line
  }
 }

#=======================================================================
proc UI_PB_evt_ReturnBlock {PAGE_OBJ SEQ_OBJ} {
  upvar $PAGE_OBJ page_obj
  upvar $SEQ_OBJ seq_obj
  set bot_canvas $Page::($page_obj,bot_canvas)
  set text_shift $Page::($page_obj,glob_text_shift)
  set elem_obj $sequence::($seq_obj,drag_blk_obj)
  $bot_canvas coords $event_element::($elem_obj,icon_id) \
  $event_element::($elem_obj,xc) $event_element::($elem_obj,yc)
  $bot_canvas coords $event_element::($elem_obj,text_id) \
  [expr $event_element::($elem_obj,xc) + $text_shift] \
  $event_element::($elem_obj,yc)
 }

#=======================================================================
proc UI_PB_evt_CreateLine {CANVAS_ID x1 y1 x2 y2} {
  upvar $CANVAS_ID canvas_id
  set line_id [$canvas_id create line $x1 $y1 $x2 $y2]
  $canvas_id lower $line_id
  return $line_id
 }

#=======================================================================
proc UI_PB_evt_SeqComponents {PAGE_OBJ SEQ_OBJ} {
  upvar $PAGE_OBJ page_obj
  upvar $SEQ_OBJ seq_obj
  global mom_sys_arr
  if { $mom_sys_arr(seq_blk_nc_code) } \
  {
   set tpth_event_flag 1
  } else \
  {
   set tpth_event_flag 0
  }
  UI_PB_evt_CreateSeqEvent page_obj seq_obj tpth_event_flag
  if { $mom_sys_arr(seq_blk_nc_code) } \
  {
   UI_PB_evt_UnBindBlkProcs page_obj
  } else \
  {
   UI_PB_evt_BlkBindProcs page_obj seq_obj
  }
  UI_PB_evt_MarkerBindProcs page_obj seq_obj
 }

#=======================================================================
proc UI_PB_evt_ActivateEvent { PAGE_OBJ SEQ_OBJ } {
  upvar $PAGE_OBJ page_obj
  upvar $SEQ_OBJ seq_obj
  set seq_evt_list $sequence::($seq_obj,evt_obj_list)
  set bot_canvas $Page::($page_obj,bot_canvas)
  foreach event_name $Page::($page_obj,event_list) \
  {
   PB_com_RetObjFrmName event_name seq_evt_list ret_obj
   if { $ret_obj } \
   {
    set evt_img_id $event::($ret_obj,icon_id)
    set img [lindex [$bot_canvas itemconfigure $evt_img_id -image] end]
    $img config -relief sunken -bg pink
   }
  }
 }

#=======================================================================
proc UI_PB_evt_ToolPathSeqComponents {PAGE_OBJ SEQ_OBJ } {
  upvar $PAGE_OBJ page_obj
  upvar $SEQ_OBJ seq_obj
  set tpth_event_flag 1
  UI_PB_evt_CreateSeqEvent page_obj seq_obj tpth_event_flag
  UI_PB_evt_EvtBindProcs page_obj seq_obj
  UI_PB_evt_UnBindBlkProcs page_obj
  UI_PB_evt_UnBindMarkerProcs page_obj
  UI_PB_evt_ActivateEvent page_obj seq_obj
 }
