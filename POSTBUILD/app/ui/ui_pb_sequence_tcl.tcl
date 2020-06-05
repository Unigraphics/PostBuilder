#22
if ![info exists gPB(enable_helpdesc_for_udc)] {
 set gPB(enable_helpdesc_for_udc) 0
}
set gPB(icon_label_pix_width) 130

#=======================================================================
proc UI_PB_evt_CreateMenuOptions { PAGE_OBJ SEQ_OBJ } {
  set ::combo_item_index 0

#=======================================================================
proc __Insert_Combo_Item { comb_widget item } {
  $comb_widget insert end $item
  incr ::combo_item_index
 }

#=======================================================================
proc __Insert_Combo_Separater { comb_widget item_index n_char } {
  set sep ""
  for { set i 0 } { $i < $n_char } { incr i } { append sep "-" }
  $comb_widget insert $item_index $sep
  incr ::combo_item_index
 }

#=======================================================================
proc __Verify_Combo_Seletion { comb_widget sel } {
  if { [string match "-----*" $sel] } {
   set lbx [$comb_widget subwidget listbox]
   set idx [lindex [$lbx curselection] end]
   $comb_widget pick [incr idx]
  }
 }
 upvar $PAGE_OBJ page_obj
 upvar $SEQ_OBJ seq_obj
 global tixOption
 global CB_Block_Name
 global paOption
 global mom_sys_arr
 global gPB
 if { ![info exists Page::($page_obj,comb_widget)] } {
  return
 }
 set comb_widget $Page::($page_obj,comb_widget)
 set lbx [$comb_widget subwidget listbox]
 $lbx config -selectmode single
 $comb_widget config -command "__Verify_Combo_Seletion $comb_widget"
 if { [$lbx size] > 0 } {
  $lbx delete 0 end
 }
 __Insert_Combo_Item $comb_widget $::gPB(seq,combo,new,Label)
 __Insert_Combo_Item $comb_widget $::gPB(seq,combo,comment,Label)
 if { $::gPB(ENABLE_TCL_STATEMENT) } {
  __Insert_Combo_Item $comb_widget "$::gPB(event,combo,tcl_line,Label)"
 }
 __Insert_Combo_Item $comb_widget $::gPB(seq,combo,custom,Label)
 __Insert_Combo_Item $comb_widget $::gPB(seq,combo,macro,Label)
 set word "Command"
 PB_int_RetMOMVarAsscAddress word cmd_proc_list
 PB_int_RetMOMVarDescAddress word cmd_proc_desc_list
 set special_cmd_list [list]
 UI_PB_cmd_GetCmdStateList "attach" special_cmd_list
 if 1 {
  if { [info exists ::gPB(ENABLE_IF_CONDITION)] && $::gPB(ENABLE_IF_CONDITION) } {
   __Insert_Combo_Separater $comb_widget $::combo_item_index 72
   __Insert_Combo_Item $comb_widget "IF(New Condition)"
   __Insert_Combo_Item $comb_widget "ELSE"
   __Insert_Combo_Item $comb_widget "END"
   set condition_cmd_added 0
   for { set count 0 } { $count < [llength $cmd_proc_list] } { incr count } \
   {
    set cmd_name [lindex $cmd_proc_list $count]
    if { [string match "$::gPB(condition_cmd_prefix)*" $cmd_name] } {
     if { [lsearch $special_cmd_list $cmd_name] >= 0 } {
      continue
      } else {
      if { $condition_cmd_added == 0 } {
       __Insert_Combo_Separater $comb_widget $::combo_item_index 72
       set condition_cmd_added 1
      }
      __Insert_Combo_Item $comb_widget "IF($cmd_name)"
     }
    }
   }
  }
 } ;# if 0
 __Insert_Combo_Separater $comb_widget $::combo_item_index 72
 set comb_elem_list ""
 for { set count 1 } { $count < [llength $cmd_proc_list] } { incr count } \
 {

#=======================================================================
set cmd_proc [lindex $cmd_proc_list $count]
 if { [string match "PB_CMD_before_motion"          $cmd_proc] || \
  [string match "PB_CMD_vnc*"                   $cmd_proc] || \
  [string match "PB_CMD_kin*"                   $cmd_proc] || \
  [string match "ELSE"                          $cmd_proc] || \
  [string match "END"                           $cmd_proc] || \
  [string match "$gPB(condition_cmd_prefix)*"   $cmd_proc] || \
 [string match "$gPB(check_block_cmd_prefix)*" $cmd_proc] } \
 { continue }
 if { [lsearch $special_cmd_list $cmd_proc] >= 0 } \
 { continue }
 if 0 { ;# What if we don't do this?
  if { ![string match "PB_CMD_*" $cmd_proc]  &&  ![string match "MOM_*" $cmd_proc] } \
  { continue }
 }
 if 0 {

#=======================================================================
set cmd_obj [PB_com_FindObjFrmName $cmd_proc command]
 if { $cmd_obj > 0  &&  $command::($cmd_obj,is_dummy) } \
 { continue }
}
set cmd_proc_desc [lindex $cmd_proc_desc_list $count]
append comb_value "$cmd_proc" " -- ($cmd_proc_desc)"
lappend comb_elem_list $comb_value
__Insert_Combo_Item $comb_widget $comb_value
unset comb_value
}
__Insert_Combo_Separater $comb_widget $::combo_item_index 72
set __macro_added 0
global post_object
foreach func_obj $Post::($post_object,function_blk_list) {
if [string match "just_mcall_sinumerik" $function::($func_obj,id)] \
{ ;#<06-05-09 wbh> not to display this option
 continue
}
function::GetDisplayText $func_obj disp_text
append disp_text " -- ($function::($func_obj,id) -- Custom Macro)"
__Insert_Combo_Item $comb_widget $disp_text
set __macro_added 1
unset disp_text
}
if { $__macro_added } {
__Insert_Combo_Separater $comb_widget $::combo_item_index 72
}
PB_int_RetBlkObjList blk_obj_list
set no_of_elements [llength $blk_obj_list]
for { set jj 0 } { $jj < $no_of_elements } { incr jj } \
{
set blk_obj [lindex $blk_obj_list $jj]
set blk_owner $block::($blk_obj,blk_owner)
set blk_name $block::($blk_obj,block_name)
if { [string match "*Cycle*"    "$blk_owner"] == 0 && \
 [string match "*Drill*"    "$blk_owner"] == 0 && \
 [string match "*Tap*"      "$blk_owner"] == 0 && \
 [string match "*Bore*"     "$blk_owner"] == 0 && \
 [string match "*Auxfun*"   "$blk_owner"] == 0 && \
 [string match "*Prefun*"   "$blk_owner"] == 0 && \
 [string match "*Linear*"   "$blk_owner"] == 0 && \
 [string match "*Circular*" "$blk_owner"] == 0 && \
 [string match "*Rapid*"    "$blk_owner"] == 0 && \
 [string match "start_of_HEAD__*"  "$blk_owner"] == 0 && \
 [string match "end_of_HEAD__*"    "$blk_owner"] == 0 && \
 [string match "*_turbo"    "$blk_name"] == 0 && \
$blk_name != "$mom_sys_arr(seqnum_block)" } \
{
 if 0 {
  set blk_elem_list $block::($blk_obj,elem_addr_list)
  UI_PB_com_ApplyMastSeqBlockElem blk_elem_list
  UI_PB_com_CreateBlkNcCode blk_elem_list blk_nc_code
  append comb_value $blk_nc_code "  - (" $blk_name ")"
  lappend comb_elem_list $comb_value
  $comb_widget insert end $comb_value
  unset comb_value
 }
 set blk_elem_list $block::($blk_obj,elem_addr_list)
 UI_PB_com_ApplyMastSeqBlockElem blk_elem_list
 UI_PB_com_CreateBlkNcCode blk_elem_list blk_nc_code
 lappend blk_code_list $blk_nc_code
 lappend blk_name_list $blk_name
}
}
if 0 { ;# List doesn't look good when displayed with lots of "-"s.
set code_len_max 0
set code_len_min 9999
foreach code $blk_code_list {
 set len [string length $code]
 if { $len > $code_len_max } {
  set code_len_max $len
 }
 if { $len < $code_len_min } {
  set code_len_min $len
 }
}
set dash ""
for {set i 0} {$i < [expr $code_len_max - $code_len_min + 2]} {incr i} {
 append dash "-"
}
}
set nd   20
set nd1  21
set dash ""
for { set i 0 } { $i < $nd } { incr i } {
append dash "-"
}
if [info exists blk_code_list] {
set i 0
foreach code $blk_code_list {
 if { [string length $code] < $nd1 } {
  append code $dash
  set code [string range $code 0 $nd1]
  } else {
  append code "--"
 }
 set blk_name [lindex $blk_name_list $i]
 append comb_value $code " (" $blk_name ")"
 lappend comb_elem_list $comb_value
 __Insert_Combo_Item $comb_widget $comb_value
 unset comb_value
 incr i
}
}
set lmax 0
foreach citem $comb_elem_list {
set clen [string length $citem]
if { $clen > $lmax } {
 set lmax $clen
}
}
if { [info exists sequence::($seq_obj,comb_elem_list)] } \
{
set old_comb_elem_list $sequence::($seq_obj,comb_elem_list)
} else \
{
set old_comb_elem_list ""
}
set sequence::($seq_obj,comb_elem_list) $comb_elem_list
if { $sequence::($seq_obj,comb_var) == "" } \
{
set index [expr [llength $cmd_proc_list] - 1]
set comb_var [lindex $sequence::($seq_obj,comb_elem_list) $index]
} else \
{
set comb_var $sequence::($seq_obj,comb_var)
set index [lsearch $old_comb_elem_list "$comb_var"]
if { $index != -1 } \
{
 if { $index < [llength $comb_elem_list] } \
 {
  set comb_var [lindex $comb_elem_list $index]
 } else \
 {
  set comb_var [lindex $comb_elem_list \
  [expr [llength $comb_elem_list] - 1]]
 }
}
}
set sequence::($seq_obj,comb_var) $comb_var
set CB_Block_Name $comb_var
switch $::tix_version {
8.4 {
 set sta readonly
}
4.1 {
 set sta disabled
}
}
[$comb_widget subwidget entry] config -bg $paOption(entry_disabled_bg) \
-justify left -state $sta  -cursor ""
if [info exists ::gPB__comb_index] {
$comb_widget pick $::gPB__comb_index
} else {
$comb_widget pick 0
}
}

#=======================================================================
proc UI_PB_evt_AddBindProcs { PAGE_OBJ } {
  upvar $PAGE_OBJ page_obj
  set top_canvas $Page::($page_obj,top_canvas)
  $top_canvas bind add_movable <Enter>           "UI_PB_evt_AddFocusOn   $page_obj"
  $top_canvas bind add_movable <Leave>           "UI_PB_evt_AddFocusOff  $page_obj"
  $top_canvas bind add_movable <1>               "UI_PB_evt_AddStartDrag $page_obj %x %y %X %Y"
  $top_canvas bind add_movable <B1-Motion>       "UI_PB_evt_AddDrag      $page_obj %x %y %X %Y"
  $top_canvas bind add_movable <ButtonRelease-1> "UI_PB_evt_AddEndDrag   $page_obj"
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
proc UI_PB_evt_AddFocusOn { page_obj } {
  global paOption
  set top_canvas $Page::($page_obj,top_canvas)
  set im [$top_canvas itemconfigure current -image]
  [lindex $im end] configure -background $paOption(focus)
  global gPB
  if { $gPB(use_info) } { ;# CSH
   $top_canvas config -cursor question_arrow
   } else {
   $top_canvas config -cursor hand2
  }
  set Page::($page_obj,add_button_focus_on) 1
 }

#=======================================================================
proc UI_PB_evt_AddFocusOff { page_obj } {
  global paOption
  set top_canvas $Page::($page_obj,top_canvas)
  if { $Page::($page_obj,add_button_focus_on) } {
   set im [$top_canvas itemconfigure current -image]
   [lindex $im end] configure -background $paOption(app_butt_bg)
   set c $top_canvas
   $c config -cursor ""
   set Page::($page_obj,add_button_focus_on) 0
  }
 }

#=======================================================================
proc UI_PB_evt_AddStartDrag { page_obj x y X Y } {
  global paOption
  global tixOption
  global CB_Block_Name
  set font $::gPB(nc_code_font)  ;# tixOption(font_sm)
  $Page::($page_obj,add) configure -bg $paOption(focus) -relief sunken
  UI_PB_evt_GetSequenceIndex page_obj seq_index
  set seq_obj [lindex $Page::($page_obj,seq_obj_list) $seq_index]
  set sequence::($seq_obj,comb_var) $CB_Block_Name
  if [string match "Virtual NC Controller" $sequence::($seq_obj,seq_name)] {
   global gPB
   switch $gPB(VNC_elem_sel) {
    "Linear Move" {
     set icon_name "pb_vnc_linear"
     set elem_type "vnc_linear"
     set elem_text "VNC Linear Move"
    }
    "Rapid Move" {
     set icon_name "pb_vnc_rapid"
     set elem_type "vnc_rapid"
     set elem_text "VNC Rapid Move"
    }
    "Pause" {
     set icon_name "pb_vnc_pause"
     set elem_type "vnc_pause"
     set elem_text "VNC Pause"
    }
    "Message" {
     set icon_name "pb_text"
     set elem_type "vnc_message"
     set elem_text "VNC Message"
    }
    "Command" {
     set icon_name "pb_finger"
     set elem_type "vnc_command"
     set elem_text "VNC Command"
    }
   }
   } else {
   UI_PB_debug_ForceMsg "\n>>>>>CB_Block_Name: $CB_Block_Name<<<<<\n"
   if { $CB_Block_Name == "$::gPB(seq,combo,new,Label)" } \
   {
    set elem_text $CB_Block_Name
    set elem_type "normal"
    set icon_name "pb_block"
    } elseif { $CB_Block_Name == "$::gPB(seq,combo,comment,Label)" } \
   {
    set elem_text $CB_Block_Name
    set elem_type "comment"
    set icon_name "pb_text"
    } elseif { $CB_Block_Name == "$::gPB(event,combo,tcl_line,Label)" } \
   {
    set elem_text "# $CB_Block_Name"
    set elem_type "comment"
    set icon_name "$::gPB(tcl_line_icon)"
    } elseif { $CB_Block_Name == "$::gPB(seq,combo,custom,Label)" } \
   {
    set elem_text $CB_Block_Name
    set elem_type "command"
    set icon_name "pb_finger"
    } elseif { $CB_Block_Name == "$::gPB(seq,combo,macro,Label)" } \
   {
    set elem_text $CB_Block_Name
    set elem_type "macro"
    set icon_name "pb_function"
    } elseif { [string match "IF(*)" $CB_Block_Name] || \
    [string match "ELSE"  $CB_Block_Name] || \
   [string match "END"   $CB_Block_Name] } \
   {
    set elem_text $CB_Block_Name
    set elem_type "command"
    set icon_name "$::gPB(condition_cmd_icon)"
   } else \
   {
    set brace_indx [string first - $CB_Block_Name]
    set elem_text  [string range $CB_Block_Name 0 [expr $brace_indx - 1]]
    set elem_text  [string trim $elem_text]
    UI_PB_com_TrunkNcCode elem_text
    if { [string match "*Custom Command*" $CB_Block_Name] || \
    [string match "*MOM Command*"    $CB_Block_Name] } \
    {
     set elem_type "command"
     set icon_name "pb_finger"
     } elseif { [string match "*Custom Macro*" $CB_Block_Name] } \
    {
     set elem_type "macro"
     set icon_name "pb_function"
    } else \
    {
     set elem_type "normal"
     set icon_name "pb_block"
    }
   }
  }
  set top_canvas $Page::($page_obj,top_canvas)
  set bot_canvas $Page::($page_obj,bot_canvas)
  set panel_hi $Page::($page_obj,panel_hi)
  set t_shift $Page::($page_obj,glob_text_shift)
  set xt [$top_canvas canvasx $x]
  set yt [$top_canvas canvasy $y]
  set icon1 [UI_PB_blk_CreateIcon $top_canvas $icon_name ""]
  set icon_top [$top_canvas create image $xt $yt -image $icon1]
  UI_PB_com_TrunkNcCode elem_text
  set icon_top_text [$top_canvas create text [expr $xt + $t_shift] \
  $yt -text "$elem_text" -font $font]
  $icon1 config -bg $paOption(butt_bg)
  set sequence::($seq_obj,icon_top) $icon_top
  set sequence::($seq_obj,icon_top_text) $icon_top_text
  set xb [$bot_canvas canvasx $x]
  set yb [$bot_canvas canvasy [expr $y - $panel_hi - 2]]
  set icon2 [UI_PB_blk_CreateIcon $bot_canvas $icon_name ""]
  set icon_bot [$bot_canvas create image $xb $yb -image $icon2]
  set icon_bot_text [$bot_canvas create text [expr $xb + $t_shift] \
  $yb  -text $elem_text -font $font]
  $icon2 config -bg $paOption(butt_bg)
  set sequence::($seq_obj,icon_bot) $icon_bot
  set sequence::($seq_obj,icon_bot_text) $icon_bot_text
  set sequence::($seq_obj,drag_elem_type) $elem_type
  set sequence::($seq_obj,drag_blk_obj) 0
  set sequence::($seq_obj,drag_evt_obj) 0
  set sequence::($seq_obj,drag_row) -1
  UI_PB_com_ChangeCursor $top_canvas
  set Page::($page_obj,add_button_focus_on) 0
  UI_PB_mthd_CreateDDBlock $X $Y eventblock $t_shift $icon_name $elem_text
 }

#=======================================================================
proc UI_PB_evt_AddDrag {page_obj x y X Y} {
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
  switch $::tix_version {
   8.4 {
    set dy [expr $panel_hi + 0]
   }
   4.1 {
    set dy [expr $panel_hi + 2]
   }
  }
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
  set canvas_x [winfo rootx $top_canvas]
  set canvas_y [winfo rooty $top_canvas]
  set canvas_height [expr {[winfo height $bot_canvas] + [winfo height $top_canvas]}]
  set canvas_width  [winfo width  $bot_canvas]
  UI_PB_mthd_MoveDDBlock $X $Y eventblock $canvas_x $canvas_y $canvas_height $canvas_width
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
  if { [string match "command" $sequence::($seq_obj,drag_elem_type)] || \
   [string match "comment" $sequence::($seq_obj,drag_elem_type)] || \
   [string match "vnc_*"   $sequence::($seq_obj,drag_elem_type)] || \
  [string match "macro"   $sequence::($seq_obj,drag_elem_type)] } \
  { ;#<06-03-09 wbh> add "macro" case
   set sequence::($seq_obj,add_blk) 0
   set sequence::($seq_obj,blk_temp) 0
   return 1
   } elseif { $sequence::($seq_obj,drag_elem_type) == "normal"} \
  {
   set evt_elem_row [lindex $event::($active_evt_obj,evt_elem_list) \
   $count]
   set evt_elem_obj [lindex $evt_elem_row 0]
   set block_obj $event_element::($evt_elem_obj,block_obj)
   if { $block::($block_obj,blk_type) == "command" || \
    $block::($block_obj,blk_type) == "comment" || \
   $block::($block_obj,blk_type) == "macro" } \
   { ;#<06-03-09 wbh> add "macro" case
    set sequence::($seq_obj,add_blk) 0
    set sequence::($seq_obj,blk_temp) 0
    return 1
    } elseif { $sequence::($seq_obj,drag_evt_obj) } \
   {
    if {$sequence::($seq_obj,drag_evt_obj) == $active_evt_obj \
    && $sequence::($seq_obj,drag_row) == $count} \
    {
     set sequence::($seq_obj,add_blk) 0
     set sequence::($seq_obj,blk_temp) 0
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
proc UI_PB_evt_HighLightSep { PAGE_OBJ SEQ_OBJ x y } {
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
  if { [info exists sequence::($seq_obj,add_blkto_evt_obj)] } \
  {
   set active_evt_obj $sequence::($seq_obj,add_blkto_evt_obj)
   set no_rows $event::($active_evt_obj,block_nof_rows)
   set event_width $event::($active_evt_obj,event_width)
   set event_xc $event::($active_evt_obj,xc)
   if { $no_rows > 0 } \
   {
    for { set count 0 } { $count < $no_rows } { incr count } \
    {
     set row_elem_objs [lindex $event::($active_evt_obj,evt_elem_list) \
     $count]
     set elem_obj [lindex $row_elem_objs 0]
     set yc $event_element::($elem_obj,yc)
     if { $y > [expr $yc - [expr $blk_dim_height / 2]] && \
      $y < [expr $yc + [expr $blk_dim_height / 2]] && \
      $x > [expr $event_xc - $region] && \
     $x < [expr $event_xc + $event_width + $region] } \
     {
      if { $::gPB(DISABLE_COMP_BLK) } {
       set sequence::($seq_obj,add_blk) 0
       set sequence::($seq_obj,blk_temp) 0
       return
      }
      set high_flag [UI_PB_evt_AvoidHighLightRow seq_obj \
      active_evt_obj count]
      if { $high_flag } { return }
      UI_PB_evt_HighLightRowOfEvent page_obj seq_obj \
      active_evt_obj count
      break
      } elseif { $y > [expr $yc - [expr $blk_dim_height / 2] - \
      [expr 3 * $rect_gap]] && \
      $y < [expr $yc - [expr $blk_dim_height / 2]] && \
      $x > [expr $event_xc - $region] && \
     $x < [expr $event_xc + $event_width + $region] } \
     {
      set high_flag [UI_PB_evt_AvoidHighLightTopOrBottomSep seq_obj \
      active_evt_obj count]
      if { $high_flag } { return }
      UI_PB_evt_HighLightTopSeperator page_obj seq_obj \
      active_evt_obj count
      break
      } elseif { $y > [expr $yc + [expr $blk_dim_height / 2]] && \
      $y < [expr $yc + [expr $blk_dim_height / 2] + \
      [expr 3 * $rect_gap]] && \
      $x > [expr $event_xc - $region] && \
     $x < [expr $event_xc + $event_width + $region] } \
     {
      set high_flag [UI_PB_evt_AvoidHighLightTopOrBottomSep seq_obj \
      active_evt_obj count]
      if {$high_flag} { return }
      UI_PB_evt_HighLightBottomSeperator page_obj seq_obj \
      active_evt_obj count
      break
     }
    }
    } elseif { $no_rows == 0 } \
   {
    set yc $event::($active_evt_obj,yc)
    if { $y > [expr $yc - [expr $blk_dim_height / 2]] && \
     $y < [expr $yc + [expr $blk_dim_height / 2]] && \
     $x > [expr $event_xc - $region] && \
    $x < [expr $event_xc + $event_width + $region] } \
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
proc UI_PB_evt_AddEndDrag { page_obj } {
  global paOption
  UI_PB_mthd_DestroyDDBlock
  set bot_canvas $Page::($page_obj,bot_canvas)
  UI_PB_evt_GetSequenceIndex page_obj seq_index
  set seq_obj [lindex $Page::($page_obj,seq_obj_list) $seq_index]
  UI_PB_evt_DeleteTemporaryIcons page_obj seq_obj
  $Page::($page_obj,top_canvas) config -cursor ""
  $Page::($page_obj,add) configure -relief raised \
  -background $paOption(app_butt_bg)
  if { $sequence::($seq_obj,add_blk) == 0 } \
  {
   return
  }
  UI_PB_evt_UnHighlightSeperators $bot_canvas seq_obj
  set active_evt_obj $sequence::($seq_obj,add_blkto_evt_obj)
  if [string match "Virtual NC Controller" $sequence::($seq_obj,seq_name)] {
   global gPB
   switch $gPB(VNC_elem_sel) {
    "Linear Move" {
     set icon_name "pb_vnc_linear"
     set blk_type "vnc_linear"
    }
    "Rapid Move" {
     set icon_name "pb_vnc_rapid"
     set blk_type "vnc_rapid"
    }
    "Pause" {
     set icon_name "pb_vnc_pause"
     set blk_type "vnc_pause"
    }
    "Message" {
     set icon_name "pb_text"
     set blk_type "vnc_message"
    }
    "Command" {
     set icon_name "pb_finger"
     set blk_type "vnc_command"
    }
   }
   set elem_name [__seq_GetNextVNCBlkName $blk_type]
   set cmd_obj 0
   if [string match "vnc_command" $blk_type] {
    PB_int_CreateNewCmdBlkElem  elem_name cmd_blk_elem
    PB_int_CreateCmdBlock       elem_name cmd_blk_elem new_block_obj
    } else {
    __seq_CreateVNCBlkElem  elem_name cmd_obj blk_elem
    __seq_CreateVNCBlk      elem_name blk_elem new_block_obj
   }
   PB_int_CreateNewEventElement new_block_obj elem_obj
   UI_PB_evt_AddBlockToEvent page_obj seq_obj elem_obj
   set event_element::($elem_obj,event_obj) $active_evt_obj
   __Pause "Need dialog for VNC components"
   switch $blk_type {
    "vnc_linear" {
     __seq_EditVNCLinearParam page_obj seq_obj active_evt_obj \
     elem_obj new_block_obj New
    }
    "vnc_rapid" {
     __seq_EditVNCRapidParam page_obj seq_obj active_evt_obj \
     elem_obj new_block_obj New
    }
    "vnc_pause" {
     __seq_EditVNCPauseParam page_obj seq_obj active_evt_obj \
     elem_obj new_block_obj New
    }
    "vnc_message" {
     __seq_EditVNCMessageParam page_obj seq_obj active_evt_obj \
     elem_obj new_block_obj New
    }
    "vnc_command" {
     __seq_EditVNCCommandParam page_obj seq_obj active_evt_obj \
     elem_obj new_block_obj New
    }
   }
   set sequence::($seq_obj,add_blk) 0
   return
  }
  if { [string compare $event::($active_evt_obj,col_image) "minus"] == 0 } \
  {
   set comb_var $sequence::($seq_obj,comb_var)
   set ::gPB(comment_is_tcl) 0
   set active_evt_name $event::($active_evt_obj,event_name)
   if { [string compare $comb_var "$::gPB(seq,combo,new,Label)"] == 0 } \
   {
    UI_PB_com_ReturnBlockName active_evt_obj new_elem_name
    set new_blk_elem_list ""
    set blk_type "normal"
    PB_int_CreateNewBlock new_elem_name new_blk_elem_list \
    active_evt_name new_block_obj blk_type
    set blk_flag "new_block"
    } elseif { [string compare $comb_var "$::gPB(seq,combo,comment,Label)"] == 0 ||\
   [string compare $comb_var "$::gPB(event,combo,tcl_line,Label)"] == 0 } \
   {
    if 0 {
     set elem_name "comment_blk"
     set cmd_obj 0
     PB_blk_CreateCmdBlkElem elem_name cmd_obj cmd_blk_elem
     PB_int_CreateCmdBlock elem_name cmd_blk_elem new_block_obj
     set blk_type "comment"
     set blk_flag "comment"
    }
    set elem_name "$::gPB(comment_blk)"
    if { [string compare $comb_var "$::gPB(event,combo,tcl_line,Label)"] == 0 } {
     set ::gPB(comment_is_tcl) 1
     set elem_name "$::gPB(tcl_line_blk)"
    }
    PB_int_CreateCommentBlkElem elem_name blk_elem_obj
    PB_int_CreateCommentBlk elem_name blk_elem_obj new_block_obj
    set blk_flag "comment"
    } elseif { [string compare $comb_var "$::gPB(seq,combo,custom,Label)"] == 0 } \
   {
    set new_elem_name "PB_CMD_custom_command"
    PB_int_CreateNewCmdBlkElem new_elem_name cmd_blk_elem
    PB_int_CreateCmdBlock new_elem_name cmd_blk_elem new_block_obj
    set blk_flag "command"
    } elseif { [string compare $comb_var "IF(New Condition)"] == 0 ||\
    [string compare $comb_var "ELSE"             ] == 0 ||\
    [string compare $comb_var "END"              ] == 0 ||\
   [string match "IF(*)" $comb_var] } \
   {
    set blk_flag ""
    if [string match "IF*" $comb_var] {
     if [string match "*New Condition*" $comb_var] {
      set blk_flag "command"
      set new_elem_name "$::gPB(condition_cmd_prefix)command"
      PB_int_CreateNewCmdBlkElem new_elem_name cmd_blk_elem
      } else {
      set new_elem_name [string range $comb_var 3 [expr [string length $comb_var] - 2] ]
      PB_int_CreateCmdBlkElem new_elem_name cmd_blk_elem
     }
     } else {
     set new_elem_name "$comb_var"
     PB_int_RetCmdBlks cmd_blk_list
     PB_com_RetObjFrmName new_elem_name cmd_blk_list cmd_obj
     if { $cmd_obj <= 0 } {
      PB_int_CreateNewCmdBlkElem new_elem_name cmd_blk_elem
      } else {
      PB_int_CreateCmdBlkElem new_elem_name cmd_blk_elem
     }
    }
    PB_int_CreateCmdBlock new_elem_name cmd_blk_elem new_block_obj
    set block::($new_block_obj,blk_owner) $active_evt_name
    } elseif { [string compare $comb_var "$::gPB(seq,combo,macro,Label)"] == 0 } \
   {
    set new_elem_name "New_Macro"
    PB_int_CreateNewFuncBlkElem new_elem_name func_blk_elem
    PB_int_CreateFuncBlk new_elem_name func_blk_elem new_block_obj
    set blk_flag "macro"
   } else \
   {
    if 0 {
     set open_brace_indx [string last ( $comb_var]
     incr open_brace_indx
    }
    set open_brace_indx [string first "-- (" $comb_var]
    incr open_brace_indx 4
    set close_brace_indx [string last ) $comb_var]
    incr close_brace_indx -1
    set blk_type $sequence::($seq_obj,drag_elem_type)
    UI_PB_debug_ForceMsg "\n>>> comb_var: $comb_var  blk_type: $blk_type <<<\n"
    if { $blk_type == "normal" } \
    {
     set new_elem_name [string range $comb_var $open_brace_indx \
     $close_brace_indx]
     set new_elem_name [string trim $new_elem_name " "]
     PB_int_RetBlkObjList blk_obj_list
     PB_com_RetObjFrmName new_elem_name blk_obj_list new_block_obj
     } elseif { $blk_type == "macro" } \
    {
     set start_index [string first "-- (" $comb_var]
     set end_index [string last "--" $comb_var]
     set new_elem_name [string range $comb_var [expr $start_index + 4] [expr $end_index - 1]]
     set new_elem_name [string trim $new_elem_name]
     PB_int_RetFunctionBlks func_blk_list
     set func_obj 0
     PB_com_RetObjFrmName new_elem_name func_blk_list func_obj
     PB_blk_CreateFuncBlkElem new_elem_name func_obj func_blk_elem
     PB_int_CreateFuncBlk new_elem_name func_blk_elem new_block_obj
    } else \
    {
     set brace_indx [string first - $comb_var]
     set new_elem_name [string range $comb_var 0 [expr $brace_indx - 1]]
     set new_elem_name [string trim $new_elem_name]
     PB_int_RetCmdBlks cmd_blk_list
     set cmd_obj 0
     PB_com_RetObjFrmName new_elem_name cmd_blk_list cmd_obj
     PB_blk_CreateCmdBlkElem new_elem_name cmd_obj cmd_blk_elem
     PB_int_CreateCmdBlock new_elem_name cmd_blk_elem new_block_obj
    }
    set blk_flag ""
   }
   PB_int_CreateNewEventElement new_block_obj elem_obj
   UI_PB_evt_AddBlockToEvent page_obj seq_obj elem_obj
   set event_element::($elem_obj,event_obj) $active_evt_obj
   set comb_widget $Page::($page_obj,comb_widget)
   set lbx [$comb_widget subwidget listbox]
   set idx [lindex [$lbx curselection] end]
   set ::gPB__comb_index $idx
   if { [string compare $blk_flag "new_block"] == 0  && \
   $sequence::($seq_obj,add_blk) != 0 } \
   {
    UI_PB_evt_NewBlkPage page_obj seq_obj active_evt_obj elem_obj \
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
    } elseif { [string compare $blk_flag "macro"] == 0 && \
   $sequence::($seq_obj,add_blk) != 0 } \
   {
    UI_PB_evt_BringFuncBlkPage page_obj seq_obj active_evt_obj elem_obj \
    new_block_obj New
   }
  }
  set sequence::($seq_obj,add_blk) 0
 }

#=======================================================================
proc __seq_CreateVNCBlkElem { ELEM_NAME CMD_OBJ CMD_BLK_ELEM } {
  upvar $ELEM_NAME elem_name
  upvar $CMD_OBJ cmd_obj
  upvar $CMD_BLK_ELEM cmd_blk_elem
  if 0 {
   set obj_attr(0) $block_element::($this,elem_add_obj)
   set obj_attr(1) $block_element::($this,elem_mom_variable)
   set obj_attr(2) $block_element::($this,elem_opt_nows_var)
   set obj_attr(3) $block_element::($this,elem_desc)
   set obj_attr(4) $block_element::($this,force)
  }
  set iend [string last _ $elem_name]
  if { $iend > 3 } {
   set elem_type [string range $elem_name 0 [expr $iend - 1]]
   } else {
   set elem_type $elem_name
  }
  UI_PB_debug_ForceMsg "elem_type==$elem_type"
  set blk_elem_obj_attr(0) $elem_name
  set blk_elem_obj_attr(1) $elem_type
  set blk_elem_obj_attr(2) blank
  set blk_elem_obj_attr(3) "VNC_Instruction"
  set blk_elem_obj_attr(4) ""
  set cmd_blk_attr(0) $elem_name
  PB_blk_CreateBlkElemObj blk_elem_obj_attr cmd_blk_elem cmd_blk_attr
  if { $cmd_obj } \
  {
   command::AddToBlkElemList $cmd_obj cmd_blk_elem
   command::AddToBlkElemList $cmd_obj cmd_blk_elem
  }
 }

#=======================================================================
proc __seq_CreateVNCBlk { BLK_NAME BLK_ELEM BLK_OBJ } {
  upvar $BLK_NAME blk_name
  upvar $BLK_ELEM blk_elem
  upvar $BLK_OBJ  blk_obj
  set blk_attr(0) $blk_name
  set blk_attr(1) 1
  set blk_attr(2) $blk_elem
  set iend [string last _ $blk_name]
  if { $iend > 3 } {
   set blk_type [string range $blk_name 0 [expr $iend - 1]]
   } else {
   set blk_type $blk_name
  }
  UI_PB_debug_ForceMsg "blk_type==$blk_type"
  set blk_attr(3) "$blk_type"
  PB_blk_CreateBlkObj blk_attr blk_obj
  __seq_AddVNCBlkToList $blk_obj
 }

#=======================================================================
proc __seq_AddVNCBlkToList { blk_obj } {
  global post_object
  set append_obj 1
  if [info exists Post::($post_object,vnc_blk_obj_list)] {
   set vnc_blk_obj_list $Post::($post_object,vnc_blk_obj_list)
   if { [lsearch $vnc_blk_obj_list $blk_obj] >= 0 } {
    set append_obj 0
   }
  }
  if $append_obj {
   lappend Post::($post_object,vnc_blk_obj_list) $blk_obj
  }
 }

#=======================================================================
proc __seq_GetNextVNCBlkName { blk_type } {
  global post_object
  set blk_name ${blk_type}_1
  if [info exists Post::($post_object,vnc_blk_obj_list)] {
   set vnc_blk_obj_list $Post::($post_object,vnc_blk_obj_list)
   set name_list [list]
   foreach blk_obj $vnc_blk_obj_list {
    set block_name $block::($blk_obj,block_name)
    if [string match "${blk_type}_*" $block_name] {
     lappend name_list $block_name
     set iend [string last _ $block_name]
     incr iend
     set name_arr([string range $block_name $iend end]) $block_name
    }
   }
   set name_list_len [llength $name_list]
   for { set i 1 } { $i <= $name_list_len } { incr i } {
    if { ![info exists name_arr($i)] } {
     break
    }
   }
   set blk_name ${blk_type}_$i
  }
  return $blk_name
 }

#=======================================================================
proc __seq_EditVNCLinearParam { PAGE_OBJ SEQ_OBJ ACTIVE_EVT_OBJ ELEM_OBJ \
  BLOCK_OBJ act_mode } {
 }

#=======================================================================
proc __seq_EditVNCRapidParam { PAGE_OBJ SEQ_OBJ ACTIVE_EVT_OBJ ELEM_OBJ \
  BLOCK_OBJ act_mode } {
 }

#=======================================================================
proc __seq_EditVNCPauseParam { PAGE_OBJ SEQ_OBJ ACTIVE_EVT_OBJ ELEM_OBJ \
  BLOCK_OBJ act_mode } {
 }

#=======================================================================
proc __seq_EditVNCMessageParam { PAGE_OBJ SEQ_OBJ ACTIVE_EVT_OBJ ELEM_OBJ \
  BLOCK_OBJ act_mode } {
  upvar $PAGE_OBJ page_obj
  upvar $SEQ_OBJ seq_obj
  upvar $ACTIVE_EVT_OBJ active_evt_obj
  upvar $ELEM_OBJ elem_obj
  upvar $BLOCK_OBJ block_obj
  global gPB paOption
  set bot_canvas $Page::($page_obj,bot_canvas)
  set blk_img_id $event_element::($elem_obj,icon_id)
  set img [lindex [$bot_canvas itemconfigure $blk_img_id -image] end]
  $img config -relief sunken -bg $paOption(sunken_bg)
  update idletasks
  set canvas_frame $Page::($page_obj,canvas_frame)
  block::readvalue $block_obj blk_obj_attr
  set win [toplevel $canvas_frame.comment]
  set toplevel_index [llength $gPB(toplevel_list)]
  set win_index [expr $toplevel_index + 1]
  set gPB(toplevel_disable_$win_index) 1
  if { $act_mode == "Edit" } {
   set win_close_cb  "UI_PB_cmd_SeqEditCommentCancel_CB $win $page_obj \
   $seq_obj $active_evt_obj $elem_obj" \
   } else {
   set win_close_cb  "UI_PB_cmd_SeqNewCommentCancel_CB $win $page_obj \
   $seq_obj $active_evt_obj $elem_obj"
  }
  UI_PB_com_CreateTransientWindow $win "$gPB(seq,oper_trans,title,Label)" \
  "AT_CURSOR" "" "UI_PB_DisableProgPageWidgets $page_obj $seq_obj" \
  "$win_close_cb" \
  "UI_PB_evt_ActivateProgPageWidgets $page_obj $seq_obj $win_index"
  if { $act_mode == "Edit" } \
  {
   set cb_arr(gPB(nav_button,cancel,Label)) \
   "UI_PB_cmd_SeqEditCommentCancel_CB $win $page_obj \
   $seq_obj $active_evt_obj $elem_obj"
   set cb_arr(gPB(nav_button,ok,Label))  \
   "UI_PB_cmd_SeqNewCommentOk_CB $win $page_obj \
   $seq_obj $elem_obj $act_mode"
   set cb_arr(Return) \
   "UI_PB_cmd_SeqNewCommentOk_CB $win $page_obj \
   $seq_obj $elem_obj $act_mode"
  } else \
  {
   set cb_arr(gPB(nav_button,cancel,Label)) \
   "UI_PB_cmd_SeqNewCommentCancel_CB $win $page_obj \
   $seq_obj $active_evt_obj $elem_obj"
   set cb_arr(gPB(nav_button,ok,Label)) \
   "UI_PB_cmd_SeqNewCommentOk_CB $win $page_obj $seq_obj \
   $elem_obj $act_mode"
   set cb_arr(Return) \
   "UI_PB_cmd_SeqNewCommentOk_CB $win $page_obj $seq_obj \
   $elem_obj $act_mode"
  }
  set blk_elem_obj [lindex $block::($block_obj,elem_addr_list) 0]
  UI_PB_cmd_CreateCommentDlgParam $win $page_obj $block_obj $blk_elem_obj
  bind $win.top.ent <Return> "$cb_arr(Return)"
  set box [frame $win.box -relief flat]
  pack $box -side bottom -fill x
  set box1_frm [frame $box.box1]
  pack $box1_frm -side bottom -fill x -padx 3 -pady 3
  if { [PB_is_v3] < 0 } {
   set label_list {"gPB(nav_button,cancel,Label)" \
    "gPB(nav_button,ok,Label)" \
   "gPB(nav_button,restore,Label)"}
   set cb_arr(gPB(nav_button,restore,Label)) \
   "UI_PB_cmd_CommentRestore_CB $block_obj"
   } else {
   set label_list {"gPB(nav_button,cancel,Label)" \
   "gPB(nav_button,ok,Label)"}
  }
  UI_PB_com_CreateButtonBox $box1_frm label_list cb_arr
  UI_PB_com_PositionWindow $win
 }

#=======================================================================
proc __seq_EditVNCCommandParam { PAGE_OBJ SEQ_OBJ ACTIVE_EVT_OBJ ELEM_OBJ \
  BLOCK_OBJ act_mode } {
  upvar $PAGE_OBJ page_obj
  upvar $SEQ_OBJ seq_obj
  upvar $ACTIVE_EVT_OBJ active_evt_obj
  upvar $ELEM_OBJ elem_obj
  upvar $BLOCK_OBJ block_obj
  global gPB paOption
  set bot_canvas $Page::($page_obj,bot_canvas)
  set blk_img_id $event_element::($elem_obj,icon_id)
  set img [lindex [$bot_canvas itemconfigure $blk_img_id -image] end]
  set img [string trim $img]
  if { ![string match "" $img] } {
   $img config -relief sunken -bg $paOption(sunken_bg)
  }
  update idletasks
  set canvas_frame $Page::($page_obj,canvas_frame)
  block::readvalue $block_obj blk_obj_attr
  set sub_win [string tolower $blk_obj_attr(0)]
  set idx [string first "." $sub_win]
  if { $idx > 0 } {
   set sub_win [string range $sub_win 0 [expr $idx - 1]]
  }
  set win [toplevel $canvas_frame.$sub_win]
  set toplevel_index [llength $gPB(toplevel_list)]
  set win_index [expr $toplevel_index + 1]
  set gPB(toplevel_disable_$win_index) 1
  set cmd_page_obj [new Page "VNC Command" "VNC Command"]
  set Page::($cmd_page_obj,canvas_frame) $win
  set blk_elem_obj [lindex $block::($block_obj,elem_addr_list) 0]
  set cmd_obj $block_element::($blk_elem_obj,elem_mom_variable)
  if { $act_mode == "Edit" } \
  {
   set win_close_cb  "UI_PB_cmd_SeqEditCmdBlkCancel_CB $win $page_obj \
   $seq_obj $active_evt_obj $elem_obj $cmd_page_obj"
  } else \
  {
   set win_close_cb  "UI_PB_cmd_SeqNewCmdBlkCancel_CB $win $page_obj \
   $seq_obj $active_evt_obj $elem_obj $cmd_page_obj"
  }
  UI_PB_com_CreateTransientWindow $win "$gPB(seq,cus_trans,title,Label)" \
  "+200+200" "" "UI_PB_DisableProgPageWidgets $page_obj $seq_obj" \
  "$win_close_cb" \
  "UI_PB_evt_ActivateProgPageWidgets $page_obj $seq_obj $win_index"
  set box [frame $win.bb]
  pack $box -side bottom -padx 3 -pady 3 -fill x
  set cb_arr(gPB(nav_button,default,Label)) \
  "UI_PB_cmd_CmdBlkDefault_CB $cmd_page_obj"
  set cb_arr(gPB(nav_button,restore,Label)) \
  "UI_PB_cmd_CmdBlkRestore_CB $cmd_page_obj"
  if { $act_mode == "Edit" } \
  {
   set cb_arr(gPB(nav_button,cancel,Label)) \
   "UI_PB_cmd_SeqEditCmdBlkCancel_CB $win $page_obj \
   $seq_obj $active_evt_obj $elem_obj $cmd_page_obj"
   set cb_arr(gPB(nav_button,ok,Label)) \
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
  }
  if { $act_mode == "New" } \
  {
   UI_PB_com_CreateActionElems $box cb_arr $win
  } else \
  {
   UI_PB_com_CreateActionElems $box cb_arr
  }
  UI_PB_cmd_CreateCmdBlkPage cmd_page_obj 1
  UI_PB_cmd_DisplayCmdBlkAttr cmd_page_obj cmd_obj
  UI_PB_com_PositionWindow $win
 }

#=======================================================================
proc UI_PB_evt_BringCommentDlg { PAGE_OBJ SEQ_OBJ ACTIVE_EVT_OBJ ELEM_OBJ \
  BLOCK_OBJ act_mode } {
  upvar $PAGE_OBJ page_obj
  upvar $SEQ_OBJ seq_obj
  upvar $ACTIVE_EVT_OBJ active_evt_obj
  upvar $ELEM_OBJ elem_obj
  upvar $BLOCK_OBJ block_obj
  global gPB paOption
  set bot_canvas $Page::($page_obj,bot_canvas)
  set blk_img_id $event_element::($elem_obj,icon_id)
  set img [lindex [$bot_canvas itemconfigure $blk_img_id -image] end]
  $img config -relief sunken -bg $paOption(sunken_bg)
  update idletasks
  set canvas_frame $Page::($page_obj,canvas_frame)
  block::readvalue $block_obj blk_obj_attr
  set win [toplevel $canvas_frame.comment]
  set toplevel_index [llength $gPB(toplevel_list)]
  set win_index [expr $toplevel_index + 1]
  set gPB(toplevel_disable_$win_index) 1
  if { $act_mode == "Edit" } {
   set win_close_cb  "UI_PB_cmd_SeqEditCommentCancel_CB $win $page_obj \
   $seq_obj $active_evt_obj $elem_obj" \
   } else {
   set win_close_cb  "UI_PB_cmd_SeqNewCommentCancel_CB $win $page_obj \
   $seq_obj $active_evt_obj $elem_obj"
  }
  if [string match "$::gPB(tcl_line_blk)*" $block::($block_obj,block_name)] {
   set title "$::gPB(event,combo,tcl_line,Label)"
   } else {
   set title "$gPB(seq,oper_trans,title,Label)"
  }
  UI_PB_com_CreateTransientWindow $win "$title" \
  "AT_CURSOR" "" "UI_PB_DisableProgPageWidgets $page_obj $seq_obj" \
  "$win_close_cb" \
  "UI_PB_evt_ActivateProgPageWidgets $page_obj $seq_obj $win_index"
  if { $act_mode == "Edit" } \
  {
   set cb_arr(gPB(nav_button,cancel,Label)) \
   "UI_PB_cmd_SeqEditCommentCancel_CB $win $page_obj \
   $seq_obj $active_evt_obj $elem_obj"
   set cb_arr(gPB(nav_button,ok,Label))  \
   "UI_PB_cmd_SeqNewCommentOk_CB $win $page_obj \
   $seq_obj $elem_obj $act_mode"
   set cb_arr(Return) \
   "UI_PB_cmd_SeqNewCommentOk_CB $win $page_obj \
   $seq_obj $elem_obj $act_mode"
  } else \
  {
   set cb_arr(gPB(nav_button,cancel,Label)) \
   "UI_PB_cmd_SeqNewCommentCancel_CB $win $page_obj \
   $seq_obj $active_evt_obj $elem_obj"
   set cb_arr(gPB(nav_button,ok,Label)) \
   "UI_PB_cmd_SeqNewCommentOk_CB $win $page_obj $seq_obj \
   $elem_obj $act_mode"
   set cb_arr(Return) \
   "UI_PB_cmd_SeqNewCommentOk_CB $win $page_obj $seq_obj \
   $elem_obj $act_mode"
  }
  set blk_elem_obj [lindex $block::($block_obj,elem_addr_list) 0]
  UI_PB_cmd_CreateCommentDlgParam $win $page_obj $block_obj $blk_elem_obj
  bind $win.top.ent <Return> "$cb_arr(Return)"
  set box [frame $win.box -relief flat]
  pack $box -side bottom -fill x
  set box1_frm [frame $box.box1]
  pack $box1_frm -side bottom -fill x -padx 3 -pady 3
  if { [PB_is_v3] < 0 } {
   set label_list {"gPB(nav_button,cancel,Label)" \
    "gPB(nav_button,ok,Label)" \
   "gPB(nav_button,restore,Label)"}
   set cb_arr(gPB(nav_button,restore,Label)) \
   "UI_PB_cmd_CommentRestore_CB $block_obj"
   } else {
   set label_list {"gPB(nav_button,cancel,Label)" \
   "gPB(nav_button,ok,Label)"}
  }
  UI_PB_com_CreateButtonBox $box1_frm label_list cb_arr
  UI_PB_com_CenterWindow   $win
 }

#=======================================================================
proc UI_PB_evt_BringCmdBlkPage { PAGE_OBJ SEQ_OBJ ACTIVE_EVT_OBJ ELEM_OBJ \
  BLOCK_OBJ act_mode } {
  upvar $PAGE_OBJ page_obj
  upvar $SEQ_OBJ seq_obj
  upvar $ACTIVE_EVT_OBJ active_evt_obj
  upvar $ELEM_OBJ elem_obj
  upvar $BLOCK_OBJ block_obj
  global gPB paOption
  set bot_canvas $Page::($page_obj,bot_canvas)
  set blk_img_id $event_element::($elem_obj,icon_id)
  set img [lindex [$bot_canvas itemconfigure $blk_img_id -image] end]
  set img [string trim $img]
  if { ![string match "" $img] } {
   $img config -relief sunken -bg $paOption(sunken_bg)
  }
  update idletasks
  set canvas_frame $Page::($page_obj,canvas_frame)
  block::readvalue $block_obj blk_obj_attr
  set sub_win [string tolower $blk_obj_attr(0)]
  set idx [string first "." $sub_win]
  if { $idx > 0 } {
   set sub_win [string range $sub_win 0 [expr $idx - 1]]
  }
  set win [toplevel $canvas_frame.$sub_win]
  set toplevel_index [llength $gPB(toplevel_list)]
  set win_index [expr $toplevel_index + 1]
  set gPB(toplevel_disable_$win_index) 1
  set cmd_page_obj [new Page "Command" "Command"]
  set Page::($cmd_page_obj,canvas_frame) $win
  set blk_elem_obj [lindex $block::($block_obj,elem_addr_list) 0]
  set cmd_obj $block_element::($blk_elem_obj,elem_mom_variable)
  set ::gPB_command_edit_mode 0
  if { $act_mode == "Edit" } \
  {
   set ::gPB_command_edit_mode 1
   set win_close_cb  "UI_PB_cmd_SeqEditCmdBlkCancel_CB $win $page_obj \
   $seq_obj $active_evt_obj $elem_obj $cmd_page_obj"
  } else \
  {
   set win_close_cb  "UI_PB_cmd_SeqNewCmdBlkCancel_CB $win $page_obj \
   $seq_obj $active_evt_obj $elem_obj $cmd_page_obj"
  }
  if [string match "$::gPB(condition_cmd_prefix)*" $blk_obj_attr(0)] {
   set dlg_title "Condition Command"
   } else {
   set dlg_title "$gPB(seq,cus_trans,title,Label)"
  }
  UI_PB_com_CreateTransientWindow $win "$dlg_title" \
  "+200+200" "" "UI_PB_DisableProgPageWidgets $page_obj $seq_obj" \
  "$win_close_cb" \
  "UI_PB_evt_ActivateProgPageWidgets $page_obj $seq_obj $win_index"
  set box [frame $win.bb]
  pack $box -side bottom -padx 3 -pady 3 -fill x
  set cb_arr(gPB(nav_button,default,Label)) \
  "UI_PB_cmd_CmdBlkDefault_CB $cmd_page_obj"
  set cb_arr(gPB(nav_button,restore,Label)) \
  "UI_PB_cmd_CmdBlkRestore_CB $cmd_page_obj"
  if { $act_mode == "Edit" } \
  {
   set cb_arr(gPB(nav_button,cancel,Label)) \
   "UI_PB_cmd_SeqEditCmdBlkCancel_CB $win $page_obj \
   $seq_obj $active_evt_obj $elem_obj $cmd_page_obj"
   set cb_arr(gPB(nav_button,ok,Label)) \
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
  }
  if { $act_mode == "New" } \
  {
   UI_PB_com_CreateActionElems $box cb_arr $win
  } else \
  {
   UI_PB_com_CreateActionElems $box cb_arr
  }
  UI_PB_cmd_CreateCmdBlkPage cmd_page_obj 1
  UI_PB_cmd_DisplayCmdBlkAttr cmd_page_obj cmd_obj
  UI_PB_com_PositionWindow $win
 }

#=======================================================================
proc UI_PB_evt_NewBlkPage { PAGE_OBJ SEQ_OBJ ACTIVE_EVT_OBJ ELEM_OBJ \
  NEW_BLOCK_OBJ } {
  upvar $PAGE_OBJ page_obj
  upvar $SEQ_OBJ seq_obj
  upvar $ACTIVE_EVT_OBJ active_evt_obj
  upvar $ELEM_OBJ elem_obj
  upvar $NEW_BLOCK_OBJ new_block_obj
  global gPB_block_name
  global paOption
  set bot_canvas $Page::($page_obj,bot_canvas)
  set blk_img_id $event_element::($elem_obj,icon_id)
  set img [lindex [$bot_canvas itemconfigure $blk_img_id -image] end]
  $img config -relief sunken -bg $paOption(sunken_bg)
  update idletasks
  set win [UI_PB_evt__DisplayBlockPage $page_obj $seq_obj \
  $new_block_obj new_blk_page_obj 1 \
  $active_evt_obj $elem_obj]
  set gPB_block_name $block::($new_block_obj,block_name)
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
  pack $box_frm -fill x -padx 3 -pady 3
  UI_PB_com_CreateActionElems $box_frm cb_arr $win
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
proc __evt_GetEventOrigin { evt_page_obj XC YC } {
  upvar $XC xc
  upvar $YC yc
  set origin(0) 60
  set origin(1) 50
  set evt_dim_width [lindex $Page::($evt_page_obj,glob_evnt_dim) 0]
  set evt_dim_height [lindex $Page::($evt_page_obj,glob_evnt_dim) 1]
  set xc [expr [expr $origin(0) + $evt_dim_width] / 2]
  set yc [expr [expr $origin(1) + $evt_dim_height] / 2]
 }

#=======================================================================
proc UI_PB_evt_CreateSeqEvent {PAGE_OBJ SEQ_OBJ TPTH_EVENT_FLAG} {
  upvar $PAGE_OBJ page_obj
  upvar $SEQ_OBJ seq_obj
  upvar $TPTH_EVENT_FLAG tpth_event_flag
  global tixOption
  global paOption
  if 0 {
   set origin(0) 60
   set origin(1) 50
   set evt_dim_width [lindex $Page::($page_obj,glob_evnt_dim) 0]
   set evt_dim_height [lindex $Page::($page_obj,glob_evnt_dim) 1]
   set evt_xc [expr [expr $origin(0) + $evt_dim_width] / 2]
   set evt_yc [expr [expr $origin(1) + $evt_dim_height] / 2]
  }
  __evt_GetEventOrigin $page_obj evt_xc evt_yc
  set blk_dim_width [lindex $Page::($page_obj,glob_blk_dim) 0]
  set blk_dim_height [lindex $Page::($page_obj,glob_blk_dim) 1]
  set prev_evt_focus_cell $sequence::($seq_obj,evt_focus_cell)
  set prev_blk_focus_cell $sequence::($seq_obj,blk_focus_cell)
  set no_of_events [llength $sequence::($seq_obj,evt_obj_list)]
  set bot_canvas $Page::($page_obj,bot_canvas)
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
   if 0 {
    if [string match "Virtual NC Controller" $sequence::($seq_obj,seq_name)] {
     set event::($evt_obj,xc) 0
     set event::($evt_obj,yc) 40
     set event::($evt_obj,col_image) "minus"
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
  if [info exists Page::($page_obj,comb_widget)] {
   set comb_widget $Page::($page_obj,comb_widget)
   set gPB(c_help,[$comb_widget subwidget arrow])    "prog,select"
  }
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
   if 0 {
    __Pause "\n\
    ($evt_obj,icon_id)      >$event::($evt_obj,icon_id)< \n\
    ($evt_obj,text_id)      >$event::($evt_obj,text_id)< \n\
    ($evt_obj,col_icon_id)  >$event::($evt_obj,col_icon_id)< \n\
    ($evt_obj,evt_rect)     >$event::($evt_obj,evt_rect)< \n\
    ($seq_obj,texticon_ids) >$sequence::($seq_obj,texticon_ids)< \n\
    ($evt_obj,blk_text)     >$event::($evt_obj,blk_text)< \n\
    ($evt_obj,blk_rect)     >$event::($evt_obj,blk_rect)<"
   }
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
  if [string match "Virtual_NC" $Page::($page_obj,prev_seq)] {
   set flag 0
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
  if { $event::($evt_obj,block_nof_rows) > 1 } \
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
  if { $index != -1 } \
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
proc UI_PB_evt_TransformEvtElem { PAGE_OBJ SEQ_OBJ EVNT_INDEX } {
  upvar $PAGE_OBJ page_obj
  upvar $SEQ_OBJ seq_obj
  upvar $EVNT_INDEX evnt_index
  if { $page_obj <= 0 } {
   return
  }
  set evt_evtdist $Page::($page_obj,glob_evt_evtdist)
  set bot_canvas $Page::($page_obj,bot_canvas)
  set evt_dim_height [lindex $Page::($page_obj,glob_evnt_dim) 1]
  set no_of_events [llength $sequence::($seq_obj,evt_obj_list)]
  set tpth_flag [UI_PB_evt_RetBlkTypeFlag page_obj]
  for { set count [expr $evnt_index + 1] } { $count < $no_of_events } { incr count } \
  {
   set evt_obj [lindex $sequence::($seq_obj,evt_obj_list) $count]
   UI_PB_evt_DeleteAEvent $bot_canvas seq_obj evt_obj
   UI_PB_evt_DeleteEventElements page_obj seq_obj evt_obj
  }
  if { $evnt_index < 0 } {
   __evt_GetEventOrigin $page_obj evt_xc evt_yc
   } else {
   set ind_evt_obj [lindex $sequence::($seq_obj,evt_obj_list) $evnt_index]
   set evt_xc $event::($ind_evt_obj,xc)
   set evt_yc $event::($ind_evt_obj,event_height)
  }
  for { set count [expr $evnt_index + 1] } { $count < $no_of_events } { incr count } \
  {
   set evt_obj [lindex $sequence::($seq_obj,evt_obj_list) $count]
   set event_name $event::($evt_obj,event_name)
   if { [string compare $event_name "Circular Move"] == 0 } \
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
   if { [string compare $event::($evt_obj,col_image) "minus"] == 0 } \
   {
    if { $tpth_flag } \
    {
     UI_PB_evt_CreateElemOfTpthEvent page_obj seq_obj evt_obj
    } else \
    {
     UI_PB_evt_CreateElementsOfEvent page_obj seq_obj evt_obj
    }
    set evt_yc $event::($evt_obj,event_height)
   } else \
   {
    if { $tpth_flag } \
    {
     set evt_yc [expr $evt_yc + [expr $evt_dim_height / 2] + \
     $evt_evtdist]
    } else \
    {
     set evt_yc [expr $evt_yc + $evt_dim_height + $evt_evtdist]
    }
   }
  }
 }

#=======================================================================
proc __evt_FitLabelWidth { label } {
  global gPB
  label .dummy_label -text $label
  set width [winfo reqwidth .dummy_label]
  set str $label
  set len [expr [string length $label] - 2]
  while { $width > $gPB(icon_label_pix_width) } {
   set str "[string range $label 0 $len]..."
   .dummy_label config -text $str
   set width [winfo reqwidth .dummy_label]
   incr len -1
  }
  destroy .dummy_label
  return $str
 }

#=======================================================================
proc UI_PB_evt_CreateEvent { PAGE_OBJ SEQ_OBJ EVT_OBJ } {
  upvar $PAGE_OBJ page_obj
  upvar $SEQ_OBJ seq_obj
  upvar $EVT_OBJ evt_obj
  global gPB
  if [string match "Virtual NC Controller" $sequence::($seq_obj,seq_name)] {
   __seq_CreateVNCEvent page_obj seq_obj evt_obj
   return
  }
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
   set text_bg $paOption(special_fg)
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
  if { $::env(PB_UDE_ENABLED) == 1 } {
   if ![string compare $sequence::($seq_obj,seq_name) "Machine Control"] {
    global post_object
    set udeobj $Post::($post_object,ude_obj)
    set seqobj $ude::($udeobj,seq_obj)
    set evt_list $sequence::($seqobj,evt_obj_list)
    if { [lsearch $evt_list $evt_obj] != "-1" } {
     $evt_img_id config -bg $paOption(ude_bg)
     set udeevent [UI_PB_ude_GetUdeEventObj $evt_obj]
     if { $ude_event::($udeevent,is_external) == 1 } {
      $evt_img_id config -bg $::SystemDisabledText
     }
    }
   }
   if ![string compare $sequence::($seq_obj,seq_name) "Cycles"] {
    global machData
    if { $machData(0) == "Mill" } {
     global post_object
     set udeobj $Post::($post_object,ude_obj)
     set seqobj $ude::($udeobj,seq_obj_cycle)
     set evt_list $sequence::($seqobj,evt_obj_list)
     if { [lsearch $evt_list $evt_obj] != "-1" } {
      $evt_img_id config -bg $paOption(udc_bg)
      set udeevent [UI_PB_ude_GetUdeEventObj $evt_obj]
      if { $cycle_event::($udeevent,is_external) == 1 } {
       $evt_img_id config -bg $::SystemDisabledText
      }
     }
    }
   }
   set event::($evt_obj,bg) [lindex [$evt_img_id config -bg] end]
  }
  set evt_xc $event::($evt_obj,xc)
  set evt_yc $event::($evt_obj,yc)
  set icon_id [$bot_canvas create image $evt_xc $evt_yc \
  -image $evt_img_id -tag $tag]
  $evt_img_id config -relief $icon_relief
  if [string match "\$gPB*" $event::($evt_obj,event_label)] \
  {
   set event_label [eval format %s $event::($evt_obj,event_label)]
  } else \
  {
   set event_label $event::($evt_obj,event_label)
  }
  set event_label [__evt_FitLabelWidth $event_label]
  set text_id [$bot_canvas create text [expr $evt_xc + $t_shift] $evt_yc \
  -text $event_label -font $tixOption(bold_font) \
  -fill $text_bg -tag $tag]
  set event::($evt_obj,icon_id) $icon_id
  set event::($evt_obj,text_id) $text_id
  lappend sequence::($seq_obj,texticon_ids) $text_id $icon_id
  set cen_shift $Page::($page_obj,cen_shift)
  set cordx1 [expr $evt_xc + $cen_shift - [expr $evt_dim_width  / 2]]
  set cordy1 [expr $evt_yc + $cen_shift - [expr $evt_dim_height / 2]]
  set cordx2 [expr $evt_xc + $cen_shift + [expr $evt_dim_width  / 2]]
  set cordy2 [expr $evt_yc + $cen_shift + [expr $evt_dim_height / 2]]
  set rect_id [UI_PB_com_CreateRectangle  $page_obj $cordx1 $cordy1 $cordx2 $cordy2 \
  navyblue navyblue "" ""]
  $bot_canvas lower $rect_id
  set event::($evt_obj,evt_rect) $rect_id
 }

#=======================================================================
proc __seq_CreateVNCEvent { PAGE_OBJ SEQ_OBJ EVT_OBJ } {
  upvar $PAGE_OBJ page_obj
  upvar $SEQ_OBJ seq_obj
  upvar $EVT_OBJ evt_obj
  global tixOption
  global paOption
  set icon_bg yellow ;#$paOption(seq_bg)
  set text_bg $paOption(special_fg)
  set icon_img "pb_vnc"
  set icon_relief raised
  set bd_width 2
  set tag evt_movable
  set t_shift $Page::($page_obj,glob_text_shift)
  set bot_canvas $Page::($page_obj,bot_canvas)
  set evt_dim_width [lindex $Page::($page_obj,glob_evnt_dim) 0]
  set evt_dim_height [lindex $Page::($page_obj,glob_evnt_dim) 1]
  UI_PB_evt_CreateCollapseIcon page_obj seq_obj evt_obj
  set evt_img_id [UI_PB_blk_CreateIcon $bot_canvas $icon_img ""]
  $evt_img_id config -bg $icon_bg -borderwidth $bd_width
  set event::($evt_obj,xc) 25
  set event::($evt_obj,yc) 40
  set evt_xc $event::($evt_obj,xc)
  set evt_yc $event::($evt_obj,yc)
  set icon_id [$bot_canvas create image $evt_xc $evt_yc \
  -image $evt_img_id -tag $tag]
  $evt_img_id config -relief $icon_relief
  set event_label ""
  set text_id [$bot_canvas create text [expr $evt_xc + $t_shift] $evt_yc \
  -text $event_label -font $tixOption(bold_font) \
  -fill $text_bg -tag $tag]
  set event::($evt_obj,icon_id) $icon_id
  set event::($evt_obj,text_id) $text_id
  lappend sequence::($seq_obj,texticon_ids) $text_id $icon_id
  set cen_shift $Page::($page_obj,cen_shift)
  set evt_dim_width 35
  set cordx1 [expr $evt_xc + $cen_shift - [expr $evt_dim_width / 2]]
  set cordy1 [expr $evt_yc + $cen_shift - [expr $evt_dim_height / 2]]
  set cordx2 [expr $evt_xc + $cen_shift + [expr $evt_dim_width / 2]]
  set cordy2 [expr $evt_yc + $cen_shift + [expr $evt_dim_height / 2]]
  set rect_id [UI_PB_com_CreateRectangle  $page_obj $cordx1 $cordy1 $cordx2 $cordy2 \
  navyblue navyblue "" ""]
  $bot_canvas lower $rect_id
  set event::($evt_obj,evt_rect) $rect_id
 }

#=======================================================================
proc UI_PB_evt_MarkerBindProcs { PAGE_OBJ SEQ_OBJ } {
  upvar $PAGE_OBJ page_obj
  upvar $SEQ_OBJ seq_obj
  set bot_canvas $Page::($page_obj,bot_canvas)
  $bot_canvas bind seq_movable <Enter> "__evt_MarkerFocusOn $bot_canvas \
  $seq_obj"
  $bot_canvas bind seq_movable <Leave> "__evt_MarkerFocusOff $bot_canvas \
  $seq_obj"
  $bot_canvas bind seq_movable <3>  "__evt_MarkerPopupMenu $page_obj \
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
proc __evt_MarkerFocusOn { bot_canvas seq_obj } {
  global paOption
  set texticon_id $sequence::($seq_obj,texticon_ids)
  set objects [UI_PB_evt_GetCurrentCanvasObject $bot_canvas texticon_id]
  set img [lindex [$bot_canvas itemconfigure [lindex $objects 0] -image] end]
  $img configure -background $paOption(focus)
  set sequence::($seq_obj,evt_focus_cell) $objects
  set event_obj [UI_PB_evt_GetEventObjOfCurPos seq_obj \
  [lindex $objects 0]]
  catch { __event_CreateBalloon $bot_canvas $event::($event_obj,event_label) }
  global gPB
  set c $bot_canvas
  if { $gPB(use_info) } {
   $c config -cursor question_arrow
   } else {
   $c config -cursor hand2
  }
 }

#=======================================================================
proc __evt_MarkerFocusOff { bot_canvas seq_obj } {
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
  catch {__event_CancelBalloon $bot_canvas}
  set c $bot_canvas
  $c config -cursor ""
 }

#=======================================================================
proc __evt_MarkerPopupMenu { page_obj seq_obj } {
  __evt_DeleteBalloon  page_obj
  UI_PB_evt_CreateBlkPopup $page_obj $seq_obj evt
 }

#=======================================================================
proc UI_PB_evt_CreateElemOfTpthEvent { PAGE_OBJ SEQ_OBJ EVT_OBJ } {
  upvar $PAGE_OBJ page_obj
  upvar $SEQ_OBJ seq_obj
  upvar $EVT_OBJ evt_obj
  global paOption
  global tixOption
  set font $::gPB(nc_code_font)  ;# tixOption(font_sm)
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
  if { [UI_PB_com_ReturnEventNcOutAttr evt_obj str_size ver_height evt_nc_output] } {
   set rect_bg $paOption(tree_bg)
   } else {
   set rect_bg orange
  }
  set blk_corner2_x [expr $blk_corner1_x + $str_size + 10]
  set blk_corner2_y [expr $blk_corner1_y + $ver_height + 10]
  if { [info exists evt_nc_output] } \
  {
   set rect_id [UI_PB_com_CreateRectangle  $page_obj \
   $blk_corner1_x $blk_corner1_y $blk_corner2_x $blk_corner2_y \
   $rect_bg black $rect_gap "nc_code"]
   set line_id [UI_PB_evt_CreateLine bot_canvas $evt_xc \
   $evt_yc $blk_corner1_x $evt_yc]
   set xc [expr $blk_corner1_x + [expr $str_size / 2]]
   set yc [expr $blk_corner1_y + [expr $ver_height / 2]]
   set text_id [$bot_canvas create text [expr $xc + 8] [expr $yc + 13] \
   -font $font -text $evt_nc_output \
   -justify left -tag nc_code]
   set event::($evt_obj,blk_rect) $rect_id
   set event::($evt_obj,blk_text) $text_id
   set event::($evt_obj,extra_lines) $line_id
   unset evt_nc_output
  }
  if { $ver_height } \
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
    if [catch {UI_PB_evt_CreateEventElement page_obj seq_obj evt_elem_obj} res] {
     __Pause "$res\n$block::($event_element::($evt_elem_obj,block_obj),blk_type)"
    }
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
   } elseif { $block::($block_obj,blk_type) == "macro" } \
  { ;#<06-03-09 wbh> add "macro" case
   set func_blk_elem [lindex $block::($block_obj,elem_addr_list) 0]
   set func_elem $block_element::($func_blk_elem,elem_mom_variable)
   if [info exists function::($func_elem,blk_elem_list)] {
    set evt_elem_list $function::($func_elem,blk_elem_list)
    set evt_elem_list [lsort -integer $evt_elem_list]
    set no_elems [llength $evt_elem_list]
    } else {
    set no_elems 0
   }
  } else \
  {
   set cmd_blk_elem [lindex $block::($block_obj,elem_addr_list) 0]
   set cmd_elem $block_element::($cmd_blk_elem,elem_mom_variable)
   if { [string match "MOM_*" $cmd_elem] } \
   {
    set no_elems 0
   } else \
   {
    if [info exists command::($cmd_elem,blk_elem_list)] {
     set evt_elem_list $command::($cmd_elem,blk_elem_list)
     set evt_elem_list [lsort -integer $evt_elem_list]
     set no_elems [llength $evt_elem_list]
     } else {
     set no_elems 0
    }
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
proc UI_PB_evt_CreateEventElement { PAGE_OBJ SEQ_OBJ EVT_ELEM_OBJ } {
  upvar $PAGE_OBJ page_obj
  upvar $SEQ_OBJ seq_obj
  upvar $EVT_ELEM_OBJ evt_elem_obj
  global paOption
  global tixOption
  global mom_sys_arr
  set font $::gPB(nc_code_font)  ;# tixOption(font_sm)
  set bot_canvas $Page::($page_obj,bot_canvas)
  set blk_dim_width [lindex $Page::($page_obj,glob_blk_dim) 0]
  set blk_dim_height [lindex $Page::($page_obj,glob_blk_dim) 1]
  set t_shift $Page::($page_obj,glob_text_shift)
  set rect_gap $Page::($page_obj,glob_rect_gap)
  set block_obj $event_element::($evt_elem_obj,block_obj)
  if { [UI_PB_evt_RetNoEvtElemsOfBlk block_obj] > 1 } \
  {
   set icon_bg "$paOption(text)"
   set text_bg "black"
  } else \
  {
   set icon_bg "$paOption(special_fg)"
   set text_bg "black"
  }
  set elem_xc $event_element::($evt_elem_obj,xc)
  set elem_yc $event_element::($evt_elem_obj,yc)
  set cordx1 [expr $elem_xc - [expr $blk_dim_width / 2]]
  set cordy1 [expr $elem_yc - [expr $blk_dim_height / 2]]
  set cordx2 [expr $elem_xc + [expr $blk_dim_width / 2]]
  set cordy2 [expr $elem_yc + [expr $blk_dim_height / 2]]
  set rect_id [UI_PB_com_CreateRectangle  $page_obj \
  $cordx1 $cordy1 $cordx2 $cordy2 \
  lightgray lightgray "" ""]
  set event_element::($evt_elem_obj,rect_id) $rect_id
  set blk_nc_code ""
  switch $block::($block_obj,blk_type) {
   "normal" \
   {
    set icon_name "pb_block"
    set blk_elem_list $block::($block_obj,elem_addr_list)
    UI_PB_com_ApplyMastSeqBlockElem blk_elem_list
    UI_PB_com_CreateBlkNcCode blk_elem_list blk_nc_code
   }
   "comment" \
   {
    set icon_name "pb_text"
    set blk_elem [lindex $block::($block_obj,elem_addr_list) 0]
    if { $mom_sys_arr(Comment_Start) != "" } \
    {
     append blk_nc_code "$mom_sys_arr(Comment_Start)"
    }
    append blk_nc_code "$block_element::($blk_elem,elem_mom_variable)"
    if { $mom_sys_arr(Comment_End) != "" } \
    {
     append blk_nc_code "$mom_sys_arr(Comment_End)"
    }
    if [string match "$::gPB(tcl_line_blk)*" $block::($block_obj,block_name)] {
     set blk_nc_code "# $block_element::($blk_elem,elem_mom_variable)"
     set icon_name "$::gPB(tcl_line_icon)"
    }
   }
   "command" \
   {
    set icon_name "pb_finger"
    set cmd_blk_elem [lindex $block::($block_obj,elem_addr_list) 0]
    set cmd_obj $block_element::($cmd_blk_elem,elem_mom_variable)
    if { [string match "MOM_*" $cmd_obj] } \
    {
     set blk_nc_code $cmd_obj
    } else \
    {
     if $cmd_obj {
      if { [string match "$::gPB(condition_cmd_prefix)*" $command::($cmd_obj,name)] } {
       set blk_nc_code "IF($command::($cmd_obj,name))"
       set icon_name "$::gPB(condition_cmd_icon)"
       } elseif { [string match "ELSE*" $command::($cmd_obj,name)] } {
       set blk_nc_code "ELSE"
       set icon_name "$::gPB(condition_cmd_icon)"
       } elseif { [string match "END*"  $command::($cmd_obj,name)] } {
       set blk_nc_code "END"
       set icon_name "$::gPB(condition_cmd_icon)"
       } else {
       set blk_nc_code $command::($cmd_obj,name)
      }
      } else {
      set blk_nc_code ""
     }
    }
   }
   "macro" \
   {
    set icon_name "pb_function"
    set func_blk_elem [lindex $block::($block_obj,elem_addr_list) 0]
    set func_obj $block_element::($func_blk_elem,elem_mom_variable)
    if $func_obj {
     function::GetDisplayText $func_obj blk_nc_code
     if { [info exists block_element::($func_blk_elem,func_prefix)] && \
     $block_element::($func_blk_elem,func_prefix) != "" } \
     {
      set temp_str $block_element::($func_blk_elem,func_prefix)
      append temp_str " " $blk_nc_code
      set blk_nc_code $temp_str
      unset temp_str
     }
     } else {
     set blk_nc_code ""
    }
   }
   "vnc_linear" \
   {
    set icon_name "pb_vnc_linear"
    set blk_nc_code "VNC Linear Move"
   }
   "vnc_rapid" \
   {
    set icon_name "pb_vnc_rapid"
    set blk_nc_code "VNC Rapid Move"
   }
   "vnc_pause" \
   {
    set icon_name "pb_vnc_pause"
    set blk_nc_code "VNC Pause"
   }
   "vnc_message" \
   {
    set icon_name "pb_text"
    set blk_nc_code "VNC Message"
   }
   "vnc_command" \
   {
    set icon_name "pb_finger"
    set blk_nc_code "VNC Command"
   }
   default \
   {
    set icon_name "pb_block"
   }
  }
  set elem_img_id [UI_PB_blk_CreateIcon $bot_canvas $icon_name ""]
  $elem_img_id config -bg $icon_bg
  set elem_icon_id [$bot_canvas create image $elem_xc $elem_yc \
  -image $elem_img_id -tag blk_movable]
  set event_element::($evt_elem_obj,icon_id) $elem_icon_id
  UI_PB_com_TrunkNcCode blk_nc_code
  set elem_text $blk_nc_code
  set elem_text_id [$bot_canvas create text [expr $elem_xc + $t_shift] \
  $elem_yc -text "$elem_text" -font $font -justify left \
  -fill $text_bg -tag blk_movable]
  set event_element::($evt_elem_obj,text_id) $elem_text_id
  lappend sequence::($seq_obj,texticon_ids) $elem_text_id $elem_icon_id
  UI_PB_evt_CreateExecAttrSymbols page_obj evt_elem_obj
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
  if { $no_rows } \
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
   set rect_id [UI_PB_com_CreateRectangle  $page_obj \
   [expr $x1 - $rect_gap] [expr $y1 - $rect_gap] \
   [expr $x2 + $rect_gap] [expr $y2 + $rect_gap] \
   $paOption(can_bg) $paOption(can_bg) $rect_gap ""]
   $bot_canvas lower $rect_id
   set top_sep [UI_PB_com_CreateRectangle  $page_obj \
   $x1 [expr $y1 - $rect_gap] $x2 [expr $y1 - 1] \
   "" $paOption(can_bg) $rect_gap ""]
   set bot_sep [UI_PB_com_CreateRectangle  $page_obj \
   $x1 [expr $y2 + 1] $x2 [expr $y2 + $rect_gap] \
   "" $paOption(can_bg) $rect_gap ""]
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
   set rect_id [UI_PB_com_CreateRectangle  $page_obj \
   [expr $x1 - $rect_gap] [expr $y1 - $rect_gap] \
   [expr $x2 + $rect_gap] [expr $y2 + $rect_gap] \
   $paOption(can_bg) $paOption(can_bg) $rect_gap ""]
   $bot_canvas lower $rect_id
   lappend template_ids $rect_id
  }
  if { $event_width > $event::($evt_obj,event_width) } \
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
  if { !$tpth_flag } \
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
     if { [info exists event_element::($elem_obj,cond_id)] && \
     $event_element::($elem_obj,cond_id) > 0 } \
     {
      $bot_canvas delete $event_element::($elem_obj,cond_id)
      set event_element::($elem_obj,cond_id) 0
     }
     if { [info exists event_element::($elem_obj,supp_id)] && \
     $event_element::($elem_obj,supp_id) > 0 } \
     {
      $bot_canvas delete $event_element::($elem_obj,supp_id)
      set event_element::($elem_obj,supp_id) 0
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
  if {$::env(PB_UDE_ENABLED) == 1} {
   global machData
   if  {$sequence::($seq_obj,seq_name) == "Machine Control"} {
    $bot_canvas bind evt_movable <3> "UI_PB_ude_EventEditPopupMenu $seq_obj"
    bind $bot_canvas <3> "UI_PB_ude_AddNewUdeEventPopupMenu $bot_canvas %X %Y \
    $page_obj $seq_obj"
    } elseif {$sequence::($seq_obj,seq_name) == "Cycles" && $machData(0) == "Mill"} {
    $bot_canvas bind evt_movable <3> "UI_PB_ude_EventEditPopupMenu $seq_obj"
    bind $bot_canvas <3> "UI_PB_cycle_AddNewUdcEventPopupMenu $bot_canvas %X %Y \
    $page_obj $seq_obj"
    } else {
    $bot_canvas bind evt_movable <3> ""
   }
  }
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
  $bot_canvas bind blk_movable <Enter>           "UI_PB_evt_BlockFocusOn   $page_obj $seq_obj"
  $bot_canvas bind blk_movable <Leave>           "UI_PB_evt_BlockFocusOff  $page_obj $seq_obj"
  $bot_canvas bind blk_movable <1>               "UI_PB_evt_BlockStartDrag $page_obj $seq_obj %x %y"
  $bot_canvas bind blk_movable <B1-Motion>       "UI_PB_evt_BlockDrag      $page_obj $seq_obj %x %y"
  $bot_canvas bind blk_movable <ButtonRelease-1> "UI_PB_evt_BlockEndDrag   $page_obj $seq_obj"
  $bot_canvas bind blk_movable <3>               "UI_PB_evt_CreateBlkPopup $page_obj $seq_obj blk"
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
  set event_obj [UI_PB_evt_GetEventObjOfCurPos seq_obj \
  [lindex $objects 0]]
  catch { __event_CreateBalloon $bot_canvas $event::($event_obj,event_label) }
  global gPB
  set c $bot_canvas
  if { $gPB(use_info) } {
   $c config -cursor question_arrow
   } else {
   $c config -cursor hand2
  }
 }

#=======================================================================
proc UI_PB_evt_GetCurrentImage { canvas TEXTICON_ID } {
  upvar $TEXTICON_ID texticon_ids
  set test [$canvas itemconfigure current]
  set text_flag [lsearch $test "-text*"]
  set image_flag [lsearch $test "-image*"]
  if { $image_flag != -1 } \
  {
   set img [lindex [$canvas itemconfigure current -image] end]
   } elseif { $text_flag != -1 } \
  {
   set text_id [$canvas find withtag current]
   set index [lsearch $texticon_ids $text_id]
   set icon_id [lindex $texticon_ids [expr $index + 1]]
   if { ![string compare "image" [$canvas type $icon_id] ] } {
    set img [lindex [$canvas itemconfigure $icon_id -image] end]
    } else {
    set img ""
   }
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
     $img configure -background $paOption(sunken_bg)
    } else \
    {
     $img configure -background $paOption(event)
    }
    if {$::env(PB_UDE_ENABLED) == 1} {
     if ![string compare $sequence::($seq_obj,seq_name) "Machine Control"] {
      global post_object
      set udeobj $Post::($post_object,ude_obj)
      set seqobj $ude::($udeobj,seq_obj)
      set evt_list $sequence::($seqobj,evt_obj_list)
      if {[lsearch $evt_list $event_obj] != "-1"} {
       $img config -bg $paOption(ude_bg)
       set udeevent [UI_PB_ude_GetUdeEventObj $event_obj]
       if { $ude_event::($udeevent,is_external) == 1 } {
        $img config -bg $::SystemDisabledText
       }
      }
     }
     if ![string compare $sequence::($seq_obj,seq_name) "Cycles"] {
      global post_object machData
      if {$machData(0) == "Mill"} {
       set udeobj $Post::($post_object,ude_obj)
       set seqobj $ude::($udeobj,seq_obj_cycle)
       set evt_list $sequence::($seqobj,evt_obj_list)
       if {[lsearch $evt_list $event_obj] != "-1"} {
        $img config -bg $paOption(udc_bg)
        set udeevent [UI_PB_ude_GetUdeEventObj $event_obj]
        if { $cycle_event::($udeevent,is_external) == 1 } {
         $img config -bg $::SystemDisabledText
        }
       }
      }
     }
    }
    catch {__event_CancelBalloon $bot_canvas}
    $bot_canvas itemconfigure [lindex $prev_evt_focus_cell 1] -fill $paOption(special_fg)
    set sequence::($seq_obj,prev_evt_focus_cell) 0
   }
  }
  set c $bot_canvas
  $c config -cursor ""
 }

#=======================================================================
proc UI_PB_evt_EventStartDrag { page_obj seq_obj } {
  global mom_sys_arr gPB
  set texticon_id $sequence::($seq_obj,texticon_ids)
  set bot_canvas $Page::($page_obj,bot_canvas)
  set objects [UI_PB_evt_GetCurrentCanvasObject $bot_canvas texticon_id]
  set event_obj [UI_PB_evt_GetEventObjOfCurPos seq_obj  [lindex $objects 0]]
  if {$sequence::($seq_obj,seq_name) == "Cycles"} {
   global gPB
   if {[info exists event::($event_obj,cyc_evt_obj)] || \
    $::env(PB_UDE_ENABLED) == 0} {
    if {$event::($event_obj,event_name) == "Drill Csink"} {
     tk_messageBox -message $gPB(udc,drill,csink,INFO) -parent $::gPB(main_window)
     return
     } elseif {$event::($event_obj,event_name) == "Peck Drill" || \
     $event::($event_obj,event_name) == "Break Chip"} {
     tk_messageBox -message $gPB(udc,drill,simulate,INFO) -parent $::gPB(main_window)
     return
    }
   }
  }
  set err_message_list [list]
  foreach evt_itm $event::($event_obj,evt_itm_obj_list) {
   foreach grp_list $item::($evt_itm,grp_obj_list) {
    foreach mem_list $item_group::($grp_list,mem_obj_list) {
     if { ![string compare "a" $group_member::($mem_list,data_type)] && $group_member::($mem_list,widget_type) == 2} {
      set sys_var $group_member::($mem_list,mom_var)
      set add_name ""
      UI_PB_mthd_GetAddNameOnTpthEvenPage $sys_var add_name
      PB_int_RetAddrObjFromName add_name add_obj
      if { $add_obj > 0 } {
       set fmt_obj $address::($add_obj,add_format)
       format::readvalue $fmt_obj fmt_obj_attr
       if { ![ string compare "Numeral" $fmt_obj_attr(1)] } {
        set expr_value [string trim $mom_sys_arr($sys_var)]
        if { [string match -* $expr_value] } {
         set expr_value [string trim $expr_value "-"]
        }
        if { [string match +* $expr_value] } {
         set expr_value [string trim $expr_value "+"]
        }
        if ![catch { expr $expr_value + 1 }] {
         set dec_pt [string first "." $expr_value]
         if { $dec_pt != -1 } {
          set len [expr [string length $expr_value] - 1]
          set fpart [string trimleft [string range $expr_value 0 [expr $dec_pt - 1]] "0"]
          set spart [string trimright [string range $expr_value [expr $dec_pt + 1] $len] "0"]
          } else {
          set fpart [string trimleft $expr_value "0"]
          set spart ""
         }
         if { ![string compare "" $fmt_obj_attr(5)] } {
          set fmt_obj_attr(5) 0
         }
         if { ![string compare "" $fmt_obj_attr(7)] } {
          set fmt_obj_attr(7) 0
         }
         if { [string length $fpart] > $fmt_obj_attr(5) || [string length $spart] > $fmt_obj_attr(7) } {
          UI_PB_fmt_AppendFormatErrorMsg err_message_list $sys_var $add_name fmt_obj_attr
         }
         } else {
         UI_PB_fmt_AppendFormatErrorMsg err_message_list $sys_var $add_name fmt_obj_attr
        }
       }
      }
     }
    }
   }
  }
  if { [llength $err_message_list] > 0 } {
   set err_message ""
   for { set i 0 } { $i < [llength $err_message_list] } { incr i } {
    append err_message "[lindex $err_message_list $i] \n"
   }
   append err_message "\n$gPB(format,check_6,error,msg)"
   UI_PB_mthd_DisplayErrMsg "$err_message"
   return
  }
  set event::($event_obj,event_open) 1
  UI_PB_tpth_ToolPath page_obj seq_obj event_obj
 }

#=======================================================================
proc __event_CreateBalloon { bot_canvas desc } {
  global gPB_help_tips tixOption
  global gPB
  if { $gPB_help_tips(state) } {
   if [string match {$*} $desc] {
    set desc [set [string range $desc 1 end]]
   }
   label .dummy_label_e
   .dummy_label_e config -text $desc ;#-font $tixOption(fixed_font_sm)
   set width_e [winfo reqwidth .dummy_label_e]
   destroy .dummy_label_e
   if { $width_e > $gPB(icon_label_pix_width) } {
    set gPB_help_tips($bot_canvas) "$desc"
   }
  }
 }

#=======================================================================
proc __event_CancelBalloon { bot_canvas } {
  global gPB_help_tips
  if { $gPB_help_tips(state) } {
   if [info exists gPB_help_tips($bot_canvas)] {
    unset gPB_help_tips($bot_canvas)
   }
   PB_cancel_balloon
  }
 }

#=======================================================================
proc __seq_CreateBalloon { PAGE_OBJ SEQ_OBJ } {
  upvar $PAGE_OBJ page_obj
  upvar $SEQ_OBJ seq_obj
  global mom_sys_arr
  global gPB_help_tips
  global gPB
  if { $gPB_help_tips(state) } \
  {
   set c $Page::($page_obj,bot_canvas)
   if { ![info exists gPB(seq_page_blk_item_focus_on)] } \
   {
    set gPB(seq_page_blk_item_focus_on) 0
   }
   if { $gPB(seq_page_blk_item_focus_on) == 0 } \
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
    } elseif [string match "vnc_*" $block::($block_obj,blk_type)] \
    {
     set blk_elem [lindex $block::($block_obj,elem_addr_list) 0]
     set blk_nc_code $block_element::($blk_elem,force)
     append bal_desc "$blk_nc_code" \n "( " \
     $block::($block_obj,block_name) " )"
     } elseif { $block::($block_obj,blk_type) == "comment" } \
    {
     set elem_obj [lindex $block::($block_obj,elem_addr_list) 0]
     if { $mom_sys_arr(Comment_Start) != "" } \
     {
      set tmp_string [PB_output_EscapeSpecialControlChar $mom_sys_arr(Comment_Start)]
      append bal_desc "$tmp_string"
     }
     set desc $block_element::($elem_obj,elem_mom_variable)
     set desc [PB_output_EscapeSpecialControlChar $desc]
     set desc [join [split $desc \$] \\\$]
     append bal_desc $desc
     if { $mom_sys_arr(Comment_End) != "" } \
     {
      set tmp_string [PB_output_EscapeSpecialControlChar $mom_sys_arr(Comment_End)]
      append bal_desc "$tmp_string"
     }
     append bal_desc \n "( $block_element::($elem_obj,elem_desc) ) "
     if [string match "$::gPB(tcl_line_blk)*" $block::($block_obj,block_name)] {
      set bal_desc "# $block_element::($elem_obj,elem_mom_variable)"
      append bal_desc \n "( $::gPB(tcl_label) ) "
     }
     } elseif { $block::($block_obj,blk_type) == "macro" } \
    {
     set func_elem_obj [lindex $block::($block_obj,elem_addr_list) 0]
     set func_obj $block_element::($func_elem_obj,elem_mom_variable)
     function::GetDisplayText $func_obj bal_desc
     if { [info exists block_element::($func_elem_obj,func_prefix)] && \
     $block_element::($func_elem_obj,func_prefix) != "" } \
     {
      set temp_str $block_element::($func_elem_obj,func_prefix)
      append temp_str " " $bal_desc
      set bal_desc $temp_str
      unset temp_str
     }
     append bal_desc \n "( $function::($func_obj,description) ) "
    } else \
    {
     set cmd_elem_obj [lindex $block::($block_obj,elem_addr_list) 0]
     set cmd_obj $block_element::($cmd_elem_obj,elem_mom_variable)
     if { [string match "MOM_*" $cmd_obj] } \
     {
      set elem_name $cmd_obj
     } else \
     {
      set elem_name $command::($cmd_obj,name)
     }
     append bal_desc $elem_name \n \
     "( $block_element::($cmd_elem_obj,elem_desc) ) "
    }
    set gPB_help_tips($c) "$bal_desc"
    set gPB(seq_page_blk_item_focus_on) 1
   }
  }
 }

#=======================================================================
proc __evt_DeleteBalloon { PAGE_OBJ } {
  upvar $PAGE_OBJ page_obj
  global gPB_help_tips
  if { $gPB_help_tips(state) } \
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
  if { $::gPB_help_tips(state) } {
   if { ![info exists ::gPB_help_tips(def_font)] } {
    set ::gPB_help_tips(def_font)  $::gPB_help_tips(font)
   }
   if { ![info exists ::gPB_help_tips(def_width)] } {
    set ::gPB_help_tips(def_width) $::gPB_help_tips(width)
   }
   set ::gPB_help_tips(font)  $::tixOption(fixed_font_sm)
   set ::gPB_help_tips(width) 600
  }
  catch {
   __seq_CreateBalloon page_obj seq_obj
  }
  if { $Page::($page_obj,being_dragged) == 0 } \
  {
   set c $bot_canvas
   if { $::gPB(use_info) } \
   {
    $c config -cursor question_arrow
   } else \
   {
    $c config -cursor hand2
   }
  }
 }

#=======================================================================
proc UI_PB_evt_BlockFocusOff { page_obj seq_obj } {
  global paOption
  set bot_canvas $Page::($page_obj,bot_canvas)
  set prev_blk_focus_cell $sequence::($seq_obj,blk_focus_cell)
  if { $prev_blk_focus_cell != 0 } \
  {
   if { [string compare $sequence::($seq_obj,icon_bg) "lightSkyBlue"] == 0} \
   {
    $prev_blk_focus_cell configure -background lightSkyBlue
   } else \
   {
    $prev_blk_focus_cell configure -background $paOption(special_fg)
   }
   set sequence::($seq_obj,blk_focus_cell) 0
  }
  __evt_DeleteBalloon page_obj
  if [info exists ::gPB_help_tips(def_font)] {
   set ::gPB_help_tips(font)  $::gPB_help_tips(def_font)
  }
  if [info exists ::gPB_help_tips(def_width)] {
   set ::gPB_help_tips(width) $::gPB_help_tips(def_width)
  }
  if { $Page::($page_obj,being_dragged) == 0 } \
  {
   $bot_canvas config -cursor ""
  }
 }

#=======================================================================
proc UI_PB_evt_GetBlkObjFromImageid { PAGE_OBJ SEQ_OBJ focus_img } {
  upvar $PAGE_OBJ page_obj
  upvar $SEQ_OBJ seq_obj
  set bot_canvas $Page::($page_obj,bot_canvas)
  set active_blk_flag 0
  foreach evt_obj $sequence::($seq_obj,evt_obj_list) \
  {
   set no_rows $event::($evt_obj,block_nof_rows)
   for { set count 0 } { $count < $no_rows } { incr count } \
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
      set sequence::($seq_obj,drag_row)     $count
      set active_blk_flag 1
      break
     }
    }
    if { $active_blk_flag } { break }
   }
   if { $active_blk_flag } { break }
  }
 }

#=======================================================================
proc UI_PB_evt_BlockStartDrag { page_obj seq_obj x y } {
  global paOption
  global tixOption
  global mom_sys_arr
  set font $::gPB(nc_code_font)  ;# tixOption(font_sm)
  set Page::($page_obj,being_dragged) 1
  set bot_canvas $Page::($page_obj,bot_canvas)
  set top_canvas $Page::($page_obj,top_canvas)
  set t_shift $Page::($page_obj,glob_text_shift)
  $bot_canvas bind blk_movable <3> ""
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
  UI_PB_debug_ForceMsg "\n>>>>> block::($block_obj,blk_type): $block::($block_obj,blk_type) <<<<<\n"
  switch $block::($block_obj,blk_type) \
  {
   "normal" \
   {
    set blk_elem_list $block::($block_obj,elem_addr_list)
    UI_PB_com_ApplyMastSeqBlockElem blk_elem_list
    UI_PB_com_CreateBlkNcCode blk_elem_list elem_text
    set elem_type "normal"
    set icon_name "pb_block"
   }
   "comment" \
   {
    set blk_elem [lindex $block::($block_obj,elem_addr_list) 0]
    append elem_text $mom_sys_arr(Comment_Start) \
    $block_element::($blk_elem,elem_mom_variable) \
    $mom_sys_arr(Comment_End)
    set elem_type "comment"
    set icon_name "pb_text"
    if [string match "$::gPB(tcl_line_blk)*" $block::($block_obj,block_name)] {
     set elem_text "# $block_element::($blk_elem,elem_mom_variable)"
     set icon_name "$::gPB(tcl_line_icon)"
    }
   }
   "command" \
   {
    set cmd_blk_elem [lindex $block::($block_obj,elem_addr_list) 0]
    set cmd_obj $block_element::($cmd_blk_elem,elem_mom_variable)
    set elem_type "command"
    set icon_name "pb_finger"
    if { [string match "MOM_*" $cmd_obj] } \
    {
     set elem_text $cmd_obj
    } else \
    {
     if [string match "$::gPB(condition_cmd_prefix)*" $command::($cmd_obj,name)] {
      set elem_text "IF($command::($cmd_obj,name))"
      set icon_name "$::gPB(condition_cmd_icon)"
      } elseif { [string match "ELSE*" $command::($cmd_obj,name)] } {
      set elem_text "ELSE"
      set icon_name "$::gPB(condition_cmd_icon)"
      } elseif { [string match "END*"  $command::($cmd_obj,name)] } {
      set elem_text "END"
      set icon_name "$::gPB(condition_cmd_icon)"
      } else {
      set elem_text $command::($cmd_obj,name)
     }
     UI_PB_debug_ForceMsg "\n>>>>> command::($cmd_obj,name) : $command::($cmd_obj,name) => icon_name: $icon_name <<<<<\n"
    }
   }
   "macro" \
   { ;# <06-03-09 wbh> add macro case
    set func_blk_elem [lindex $block::($block_obj,elem_addr_list) 0]
    set func_obj $block_element::($func_blk_elem,elem_mom_variable)
    function::GetDisplayText $func_obj elem_text
    if { [info exists block_element::($func_blk_elem,func_prefix)] && \
    $block_element::($func_blk_elem,func_prefix) != "" } \
    {
     set temp_str $block_element::($func_blk_elem,func_prefix)
     append temp_str " " $elem_text
     set elem_text $temp_str
     unset temp_str
    }
    set elem_type "macro"
    set icon_name "pb_function"
   }
   "vnc_linear"  -
   "vnc_rapid"   -
   "vnc_pause"   -
   "vnc_message" -
   "vnc_command" \
   {
    set cmd_blk_elem [lindex $block::($block_obj,elem_addr_list) 0]
    set cmd_obj $block_element::($cmd_blk_elem,elem_mom_variable)
    set elem_type "$block::($block_obj,blk_type)"
   }
   default \
   {
    set icon_name "pb_block"
   }
  }
  switch $block::($block_obj,blk_type) \
  {
   "vnc_linear" \
   {
    set icon_name "pb_vnc_linear"
    set elem_text "VNC Linear Move"
   }
   "vnc_rapid" \
   {
    set icon_name "pb_vnc_rapid"
    set elem_text "VNC Rapid Move"
   }
   "vnc_pause" \
   {
    set icon_name "pb_vnc_pause"
    set elem_text "VNC Pause"
   }
   "vnc_message" \
   {
    set icon_name "pb_text"
    set elem_text "VNC Message"
   }
   "vnc_command" \
   {
    set icon_name "pb_finger"
    set elem_text "VNC Command"
   }
  }
  UI_PB_com_TrunkNcCode elem_text
  set img_addr [UI_PB_blk_CreateIcon $top_canvas $icon_name ""]
  $img_addr config -bg $paOption(focus)
  set elem_top_img [$top_canvas create image [expr $x - $diff_x] \
  [expr $y + $dy - $diff_y] -image $img_addr -tag new_comp]
  set elem_top_text [$top_canvas create text \
  [expr $x - $diff_x + $t_shift] [expr $y + $dy - $diff_y] \
  -text $elem_text -font $font -tag blk_movable]
  set sequence::($seq_obj,blk_top_img) $elem_top_img
  set sequence::($seq_obj,blk_top_text) $elem_top_text
  set sequence::($seq_obj,prev_top_blk_xc) $x
  set sequence::($seq_obj,prev_top_blk_yc) [expr $y + $panel_hi]
  set sequence::($seq_obj,drag_elem_type) $elem_type
  UI_PB_com_ChangeCursor $bot_canvas
  set ::gPB(dummy,diff_x) int($diff_x)
  set ::gPB(dummy,diff_y) int($diff_y)
  set rootx [winfo rootx $bot_canvas]
  set rooty [winfo rooty $bot_canvas]
  set X [expr $rootx + int($x) - $::gPB(dummy,diff_x) + 1]
  set Y [expr $rooty + int($y) - $::gPB(dummy,diff_y)]
  UI_PB_mthd_CreateDDBlock $X $Y eventblock_up $t_shift $icon_name $elem_text $elem_obj
 }

#=======================================================================
proc UI_PB_evt_BlockDrag {page_obj seq_obj x y} {
  if { $Page::($page_obj,being_dragged) == 0 } { return }
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
  if { [info exists event_element::($elem_obj,cond_id)] && \
   $event_element::($elem_obj,cond_id) > 0 } {
   $bot_canvas lower $event_element::($elem_obj,cond_id)
  }
  if { [info exists event_element::($elem_obj,supp_id)] && \
   $event_element::($elem_obj,supp_id) > 0 } {
   $bot_canvas lower $event_element::($elem_obj,supp_id)
  }
  set xt [$top_canvas canvasx $x]
  switch $::tix_version {
   8.4 {
    set yt [expr [$top_canvas canvasy $y] - 2]
   }
   4.1 {
    set yt [$top_canvas canvasy $y]
   }
  }
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
  set canvas_x [winfo rootx $top_canvas]
  set canvas_y [winfo rooty $top_canvas]
  set canvas_height [expr {[winfo height $bot_canvas] + [winfo height $top_canvas]}]
  set canvas_width  [expr {[winfo width  $bot_canvas] + 1}]
  set rootx [winfo rootx $bot_canvas]
  set rooty [winfo rooty $bot_canvas]
  set X [expr $rootx + int($x) - $::gPB(dummy,diff_x) + 1]
  set Y [expr $rooty + int($y) - $::gPB(dummy,diff_y)]
  UI_PB_mthd_MoveDDBlock $X $Y eventblock_up $canvas_x $canvas_y $canvas_height $canvas_width
 }

#=======================================================================
proc UI_PB_evt_BlockEndDrag {page_obj seq_obj} {
  global paOption
  global tixOption
  UI_PB_mthd_DestroyDDBlock
  set bot_canvas $Page::($page_obj,bot_canvas)
  set elem_obj $sequence::($seq_obj,drag_blk_obj)
  set top_canvas $Page::($page_obj,top_canvas)
  $top_canvas delete $sequence::($seq_obj,blk_top_img)
  $top_canvas delete $sequence::($seq_obj,blk_top_text)
  if { [info exists event_element::($elem_obj,cond_id)] && \
   $event_element::($elem_obj,cond_id) > 0 } {
   $bot_canvas raise $event_element::($elem_obj,cond_id)
  }
  if { [info exists event_element::($elem_obj,supp_id)] && \
   $event_element::($elem_obj,supp_id) > 0 } {
   $bot_canvas raise $event_element::($elem_obj,supp_id)
  }
  UI_PB_evt_UnHighlightSeperators $bot_canvas seq_obj
  if { $Page::($page_obj,being_dragged) && \
   $Page::($page_obj,being_dragged) < \
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
  __evt_DeleteBalloon page_obj
  $bot_canvas bind blk_movable <3> \
  "UI_PB_evt_CreateBlkPopup $page_obj $seq_obj blk"
  $bot_canvas config -cursor ""
  set Page::($page_obj,being_dragged) 0
 }

#=======================================================================
proc UI_PB_evt_CreateBlkPopup { page_obj seq_obj widget_type } {
  global gPB
  __evt_DeleteBalloon  page_obj
  set bot_canvas $Page::($page_obj,bot_canvas)
  set texticon_id $sequence::($seq_obj,texticon_ids)
  set cut_flag 1
  set copy_flag 1
  set refer_flag 1
  if { $widget_type == "blk" } \
  {
   set focus_img [UI_PB_evt_GetCurrentImage $bot_canvas texticon_id]
   UI_PB_evt_GetBlkObjFromImageid page_obj seq_obj $focus_img
   set evt_obj      $sequence::($seq_obj,drag_evt_obj)
   set evt_elem_obj $sequence::($seq_obj,drag_blk_obj)
   set blk_obj      $event_element::($evt_elem_obj,block_obj)
   set blk_type     $block::($blk_obj,blk_type)
   set blk_name     $block::($blk_obj,block_name)
   UI_PB_debug_ForceMsg "\n>>>>> blk_type: $blk_type  blk_name: $blk_name  blk_obj: $blk_obj <<<<<\n"
   if { $blk_type == "comment" } \
   {
    set refer_flag 0
   }
   if { $blk_name == "ELSE" || $blk_name == "END" } \
   {
    set copy_flag 0
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
   if 0 {
    UI_PB_evt_GetBlkObjFromImageid page_obj seq_obj $focus_img
    set event_obj $sequence::($seq_obj,drag_evt_obj)
    set element_obj $sequence::($seq_obj,drag_blk_obj)
    set current_blk_obj $event_element::($element_obj,block_obj)
    set sep_flag 0
    if { [string match "MOM_*" $block::($current_blk_obj,block_name)] == 0 } \
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
     $popup add sep
     UI_PB_tpth_AddPopupForWholeBlk $page_obj $event_obj $element_obj popup seq normal $seq_obj
     } elseif { $block::($current_blk_obj,blk_type) == "macro" } \
    {
     if { $sep_flag } { $popup add sep }
     UI_PB_tpth_AddPopupForWholeBlk $page_obj $event_obj $element_obj popup seq macro $seq_obj
     set sep_flag 1
    }
   } ;# if 0
   UI_PB_evt_GetBlkObjFromImageid page_obj seq_obj $focus_img
   set sep_flag 0
   if { ![string match "MOM_*" $blk_name] && \
    ![string match "ELSE"  $blk_name] &&  \
   ![string match "END"   $blk_name] } \
   {
    $popup add command -label "$gPB(seq,edit_popup,Label)" -state normal \
    -command "UI_PB_evt_EditBlock $page_obj $seq_obj $focus_img"
    set sep_flag 1
   }
   if { $blk_type == "normal" } \
   {
    $popup add command -label "$gPB(seq,force_popup,Label)" -state normal \
    -command "UI_PB_evt_EvtBlockModality $page_obj $seq_obj $focus_img"
    set sep_flag 1
    $popup add sep
    UI_PB_tpth_AddPopupForWholeBlk $page_obj $evt_obj $evt_elem_obj popup seq normal $seq_obj
    } elseif { $blk_type == "macro" } \
   {
    if { $sep_flag } { $popup add sep }
    UI_PB_tpth_AddPopupForWholeBlk $page_obj $evt_obj $evt_elem_obj popup seq macro $seq_obj
    set sep_flag 1
    } elseif { $blk_type == "comment" } \
   {
    if { ![string match "$::gPB(tcl_line_blk)*" $blk_name] } {
     if { $sep_flag } { $popup add sep }
     UI_PB_tpth_AddPopupForWholeBlk $page_obj $evt_obj $evt_elem_obj popup seq comment $seq_obj
     set sep_flag 0
    }
   }
   if { $sep_flag } { $popup add sep }
  }
  if { $::gPB(ENABLE_TCL_INDENTATION) } {
   if { $widget_type == "blk" } {
    if { !( [string match "comment" $blk_type] && [string match "$::gPB(tcl_line_blk)*" $blk_name] ) } {}
    if 1 {
     $popup add command -label "$::gPB(event,elem,indent,popup,Label)..." -state normal \
     -command "CB__SetEvtElemIndentation $page_obj $evt_elem_obj"
     $popup add separator
    }
   }
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
    $widget_type 1"
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
   if { [llength $buff_blk_list] > 1 } \
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
     if { [string match "PB_COMMENT~*" $buff_obj] ||\
     [string match "PB_TCL~*"     $buff_obj] } \
     {
      set in_line_flag 0
      } elseif { [string match "MOM_*" $buff_obj] } \
     {
      set in_line_flag 0
      } elseif { [string match "vnc_*" $buff_obj] } \
     {
      set in_line_flag 0
      } elseif { [string trim [classof $buff_obj] ::] == "command" } \
     {
      set in_line_flag 0
      } elseif { [string trim [classof $buff_obj] ::] == "function" } \
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
   if { [info exists blk_obj]  &&  $blk_type != "normal" } {
    set in_line_flag 0
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
  if { 0 && [info exists current_blk_obj] && \
  [string match "macro" $block::($current_blk_obj,blk_type)] } \
  {
   global popupvar
   $popup add sep
   set popupvar(prefix) 1
   set active_blk_elem [lindex $block::($current_blk_obj,elem_addr_list) 0]
   if { ![info exists block_element::($active_blk_elem,func_prefix)] } \
   {
    set block_element::($active_blk_elem,func_prefix) ""
   }
   if { $block_element::($active_blk_elem,func_prefix) == "" } \
   {
    set popupvar(prefix) 0
   }
   if { ![info exists block_element::($active_blk_elem,func_suppress_flag)] } \
   {
    set block_element::($active_blk_elem,func_suppress_flag) 0
   }
   set func_obj [UI_PB_func_GetFuncObjFrmBlkElem $active_blk_elem]
   $popup add checkbutton -label "$gPB(block,prefix_popup,add,Label)" \
   -variable popupvar(prefix) -state normal \
   -command "UI_PB_blk_EditFuncPrefix $page_obj $func_obj $active_blk_elem Add $seq_obj"
   if { $popupvar(prefix) } \
   {
    $popup add command -label "$gPB(block,prefix_popup,edit,Label)" \
    -command "UI_PB_blk_EditFuncPrefix $page_obj $func_obj $active_blk_elem Edit $seq_obj"
   }
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
   set Page::($page_obj,buff_exec_attr) ""
   if { $block::($block_obj,blk_type) == "normal" } \
   {
    set Page::($page_obj,buff_blk_obj) $block_obj
    event_element::GetExecAttr $evt_elem_obj exec_attr
    set temp_list ""
    lappend temp_list $exec_attr
    lappend Page::($page_obj,buff_exec_attr) $temp_list
    } elseif { $block::($block_obj,blk_type) == "comment" } \
   {
    set blk_elem [lindex $block::($block_obj,elem_addr_list) 0]
    set blk_elem_var $block_element::($blk_elem,elem_mom_variable)
    set blk_elem_var [join [split $blk_elem_var " "] "~"]
    if [string match "$::gPB(tcl_line_blk)*" $block::($block_obj,block_name)] {
     append cmt_blk "PB_TCL~" "$blk_elem_var"
     } else {
     append cmt_blk "PB_COMMENT~" "$blk_elem_var"
    }
    set Page::($page_obj,buff_blk_obj) "$cmt_blk"
    unset cmt_blk
    } elseif { $block::($block_obj,blk_type) == "macro" } \
   { ;#<06-03-09 wbh> add macro case
    set func_blk_elem [lindex $block::($block_obj,elem_addr_list) 0]
    set func_obj $block_element::($func_blk_elem,elem_mom_variable)
    set Page::($page_obj,buff_blk_obj) $func_obj
    if { [info exists block_element::($func_blk_elem,func_prefix)] } \
    {
     set function::($func_obj,temp_perfix) $block_element::($func_blk_elem,func_prefix)
    }
    event_element::GetExecAttr $evt_elem_obj exec_attr
    set temp_list ""
    lappend temp_list $exec_attr
    lappend Page::($page_obj,buff_exec_attr) $temp_list
   } else \
   {
    set cmd_blk_elem [lindex $block::($block_obj,elem_addr_list) 0]
    if [string match "vnc_*" $block::($block_obj,blk_type)] {
     set cmd_obj $block_element::($cmd_blk_elem,elem_add_obj)
     } else {
     set cmd_obj $block_element::($cmd_blk_elem,elem_mom_variable)
    }
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
    set exec_attr_list ""
    foreach elem_row $event::($event_obj,evt_elem_list) \
    {
     set row_blk_list ""
     set row_attr_list ""
     foreach elem_obj $elem_row \
     {
      set block_obj $event_element::($elem_obj,block_obj)
      block::DeleteFromEventElemList $block_obj elem_obj
      if { $block::($block_obj,blk_type) == "normal" } \
      {
       lappend row_blk_list $block_obj
       event_element::GetExecAttr $elem_obj exec_attr
       lappend row_attr_list $exec_attr
       } elseif { $block::($block_obj,blk_type) == "comment" } \
      {
       set blk_elem [lindex $block::($block_obj,elem_addr_list) 0]
       set blk_elem_var $block_element::($blk_elem,elem_mom_variable)
       set blk_elem_var [join [split $blk_elem_var " "] "~"]
       if [string match "$::gPB(tcl_line_blk)*" $block::($block_obj,block_name)] {
        append cmt_blk "PB_TCL~"     "$blk_elem_var"
        } else {
        append cmt_blk "PB_COMMENT~" "$blk_elem_var"
       }
       lappend row_blk_list "$cmt_blk"
       unset cmt_blk
       } elseif { $block::($block_obj,blk_type) == "macro" } \
      { ;#<06-03-09 wbh> add macro case
       set func_blk_elem [lindex $block::($block_obj,elem_addr_list) 0]
       set func_obj $block_element::($func_blk_elem,elem_mom_variable)
       lappend row_blk_list $func_obj
       if { [info exists block_element::($func_blk_elem,func_prefix)] } \
       {
        set function::($func_obj,temp_perfix) $block_element::($func_blk_elem,func_prefix)
       }
       event_element::GetExecAttr $elem_obj exec_attr
       lappend row_attr_list $exec_attr
      } else \
      {
       set cmd_blk_elem [lindex $block::($block_obj,elem_addr_list) 0]
       set cmd_obj $block_element::($cmd_blk_elem,elem_mom_variable)
       lappend row_blk_list $cmd_obj
      }
     }
     lappend evt_blk_list $row_blk_list
     lappend exec_attr_list $row_attr_list
    }
    set Page::($page_obj,buff_blk_obj) $evt_blk_list
    set Page::($page_obj,buff_exec_attr) $exec_attr_list
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
   set Page::($page_obj,buff_exec_attr) ""
   if { $block::($block_obj,blk_type) == "normal" } \
   {
    set Page::($page_obj,buff_blk_obj) $block_obj
    event_element::GetExecAttr $evt_elem_obj exec_attr
    set temp_list ""
    lappend temp_list $exec_attr
    lappend Page::($page_obj,buff_exec_attr) $temp_list
    } elseif { $block::($block_obj,blk_type) == "comment" } \
   {
    set blk_elem [lindex $block::($block_obj,elem_addr_list) 0]
    set mom_var $block_element::($blk_elem,elem_mom_variable)
    set mom_var [join [split $mom_var " "] "~"]
    if [string match "$::gPB(tcl_line_blk)*" $block::($block_obj,block_name)] {
     append cmt_blk "PB_TCL~"     "$mom_var"
     } else {
     append cmt_blk "PB_COMMENT~" "$mom_var"
    }
    set Page::($page_obj,buff_blk_obj) "$cmt_blk"
    unset cmt_blk
    } elseif { $block::($block_obj,blk_type) == "macro" } \
   { ;#<06-03-09 wbh> add macro case
    set func_blk_elem [lindex $block::($block_obj,elem_addr_list) 0]
    set func_obj $block_element::($func_blk_elem,elem_mom_variable)
    set Page::($page_obj,buff_blk_obj) $func_obj
    if { [info exists block_element::($func_blk_elem,func_prefix)] } \
    {
     set function::($func_obj,temp_perfix) $block_element::($func_blk_elem,func_prefix)
    }
    event_element::GetExecAttr $evt_elem_obj exec_attr
    set temp_list ""
    lappend temp_list $exec_attr
    lappend Page::($page_obj,buff_exec_attr) $temp_list
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
    set exec_attr_list ""
    foreach elem_row $event::($event_obj,evt_elem_list) \
    {
     set row_blk_list ""
     set row_attr_list ""
     foreach elem_obj $elem_row \
     {
      set block_obj $event_element::($elem_obj,block_obj)
      if { $block::($block_obj,blk_type) == "normal" } \
      {
       lappend row_blk_list $block_obj
       event_element::GetExecAttr $elem_obj exec_attr
       lappend row_attr_list $exec_attr
       } elseif { $block::($block_obj,blk_type) == "comment" } \
      {
       set blk_elem [lindex $block::($block_obj,elem_addr_list) 0]
       set mom_var $block_element::($blk_elem,elem_mom_variable)
       set mom_var [join [split $mom_var " "] "~"]
       if [string match "$::gPB(tcl_line_blk)*" $block::($block_obj,block_name)] {
        append cmt_blk "PB_TCL~"     "$mom_var"
        } else {
        append cmt_blk "PB_COMMENT~" "$mom_var"
       }
       set row_blk_list "$cmt_blk"
       unset cmt_blk
       } elseif { $block::($block_obj,blk_type) == "macro" } \
      { ;#<06-03-09 wbh> add macro case
       set func_blk_elem [lindex $block::($block_obj,elem_addr_list) 0]
       set func_obj $block_element::($func_blk_elem,elem_mom_variable)
       lappend row_blk_list $func_obj
       if { [info exists block_element::($func_blk_elem,func_prefix)] } \
       {
        set function::($func_obj,temp_perfix) $block_element::($func_blk_elem,func_prefix)
       }
       event_element::GetExecAttr $elem_obj exec_attr
       lappend row_attr_list $exec_attr
      } else \
      {
       set cmd_blk_elem [lindex $block::($block_obj,elem_addr_list) 0]
       set cmd_obj $block_element::($cmd_blk_elem,elem_mom_variable)
       lappend row_blk_list $cmd_obj
      }
     }
     lappend evt_blk_list $row_blk_list
     lappend exec_attr_list $row_attr_list
    }
    set Page::($page_obj,buff_blk_obj) $evt_blk_list
    set Page::($page_obj,buff_exec_attr) $exec_attr_list
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
   set exec_attr_list $Page::($page_obj,buff_exec_attr)
   for { set row_no 0 } { $row_no < [llength $buff_blk_list] } \
   { incr row_no } \
   {
    set blk_row [lindex $buff_blk_list $row_no]
    set attr_row [lindex $exec_attr_list $row_no]
    for { set elem_no 0 } { $elem_no < [llength $blk_row] } { incr elem_no } \
    {
     set new_elem_row ""
     set block_obj [lindex $blk_row $elem_no]
     set exec_attr [lindex $attr_row $elem_no]
     if { $Page::($page_obj,copy_flag) == 2 } \
     {
      if { [string match "PB_COMMENT~*" $block_obj] } \
      {
       set comment [string trimleft $block_obj "PB_COMMENT"]
       set comment [string range $comment 1 end]
       set comment [join [split $comment "~"] " "]
       set elem_name "$::gPB(comment_blk)"
       PB_int_CreateCommentBlkElem elem_name cmt_elem_obj
       set block_element::($cmt_elem_obj,elem_mom_variable) "$comment"
       PB_int_CreateCommentBlk elem_name cmt_elem_obj new_blk_obj
       UI_PB_debug_ForceMsg ">>>>> Paste comment block: $block::($new_blk_obj,block_name) >$comment<>$block_element::($cmt_elem_obj,elem_mom_variable)<<<<\n"
       } elseif { [string match "PB_TCL~*" $block_obj] } \
      {
       set comment [string trimleft $block_obj "PB_TCL"]
       set comment [string range $comment 1 end]
       set comment [join [split $comment "~"] " "]
       set elem_name "$::gPB(tcl_line_blk)"
       PB_int_CreateCommentBlkElem elem_name cmt_elem_obj
       set block_element::($cmt_elem_obj,elem_mom_variable) "$comment"
       PB_int_CreateCommentBlk elem_name cmt_elem_obj new_blk_obj
       UI_PB_debug_ForceMsg ">>>>> Paste Tcl comment block: $block::($new_blk_obj,block_name) >$comment<<<<<\n"
       } elseif { [string match "MOM_*" $block_obj] } \
      {
       PB_int_CreateCmdBlkFromCmd block_obj new_blk_obj
       } elseif { [string match "vnc_*" $block_obj] } \
      {
       set cmd_obj 0
       set elem_name $block_obj
       __seq_CreateVNCBlkElem  elem_name cmd_obj blk_elem
       __seq_CreateVNCBlk      elem_name blk_elem new_blk_obj
       } elseif { [string trim [classof $block_obj] ::] == "block" } \
      {
       PB_int_CreateCopyABlock block_obj new_blk_obj
       } elseif { [string trim [classof $block_obj] ::] == "function" } \
      { ;#<06-03-09 wbh> add macro case
       PB_int_CreateCopyAFuncBlk block_obj new_blk_obj
       if { [info exists function::($block_obj,temp_perfix)] } \
       {
        set temp_blk_elem_obj [lindex $block::($new_blk_obj,elem_addr_list) 0]
        set block_element::($temp_blk_elem_obj,func_prefix) $function::($block_obj,temp_perfix)
        unset function::($block_obj,temp_perfix)
       }
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
       set elem_name "$::gPB(comment_blk)"
       PB_int_CreateCommentBlkElem elem_name cmt_elem_obj
       set block_element::($cmt_elem_obj,elem_mom_variable) $comment
       PB_int_CreateCommentBlk elem_name cmt_elem_obj new_blk_obj
       } elseif { [string match "PB_TCL~*" $block_obj] } \
      {
       set comment [string trimleft $block_obj "PB_TCL"]
       set comment [string trimleft $comment ~]
       set comment [join [split $comment "~"] " "]
       set elem_name "$::gPB(tcl_line_blk)"
       PB_int_CreateCommentBlkElem elem_name cmt_elem_obj
       set block_element::($cmt_elem_obj,elem_mom_variable) $comment
       PB_int_CreateCommentBlk elem_name cmt_elem_obj new_blk_obj
       UI_PB_debug_ForceMsg ">>>>> Paste comment block: $block::($new_blk_obj,block_name) <<<<<\n"
       } elseif { [string match "MOM_*" $block_obj] } \
      {
       PB_int_CreateCmdBlkFromCmd block_obj new_blk_obj
       } elseif { [string match "vnc_*" $block_obj] } \
      {
       set cmd_obj 0
       set elem_name $block_obj
       __seq_CreateVNCBlkElem  elem_name cmd_obj blk_elem
       __seq_CreateVNCBlk      elem_name blk_elem new_blk_obj
       } elseif { [string trim [classof $block_obj] ::] == "command" } \
      {
       PB_int_CreateCmdBlkFromCmd block_obj new_blk_obj
       } elseif { [string trim [classof $block_obj] ::] == "function" } \
      {
       PB_int_CreateFuncBlkFromFunc block_obj new_blk_obj
       if { [info exists function::($block_obj,temp_perfix)] } \
       {
        set temp_blk_elem_obj [lindex $block::($new_blk_obj,elem_addr_list) 0]
        set block_element::($temp_blk_elem_obj,func_prefix) $function::($block_obj,temp_perfix)
        unset function::($block_obj,temp_perfix)
       }
      } else \
      {
       set new_blk_obj $block_obj
      }
     }
     if { $exec_attr != "" } \
     {
      set new_evt_elem_attr(2) [lindex $exec_attr 0]
      set new_evt_elem_attr(3) [lindex $exec_attr 1]
      set new_evt_elem_attr(4) [lindex $exec_attr 2]
      PB_int_CreateNewEventElementByAttr new_blk_obj new_evt_elem new_evt_elem_attr
     } else \
     {
      PB_int_CreateNewEventElement new_blk_obj new_evt_elem
     }
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
  global gPB paOption
  set bot_canvas $Page::($page_obj,bot_canvas)
  UI_PB_evt_GetBlkObjFromImageid page_obj seq_obj $focus_img
  set element_obj $sequence::($seq_obj,drag_blk_obj)
  set current_blk_obj $event_element::($element_obj,block_obj)
  set canvas_frame $Page::($page_obj,canvas_frame)
  set evt_img_id $event_element::($element_obj,icon_id)
  set img [lindex [$bot_canvas itemconfigure $evt_img_id -image] end]
  $img config -relief sunken -bg $paOption(sunken_bg)
  update
  set win [toplevel $canvas_frame.mod]
  set toplevel_index [llength $gPB(toplevel_list)]
  set win_index [expr $toplevel_index + 1]
  set gPB(toplevel_disable_$win_index) 1
  UI_PB_com_CreateTransientWindow $win "$gPB(seq,force_trans,title,Label)" \
  "AT_CURSOR" "" "UI_PB_DisableProgPageWidgets $page_obj $seq_obj" \
  "UI_PB_blk_ModalityCancel_CB $win $page_obj $seq_obj $element_obj" \
  "UI_PB_evt_ActivateProgPageWidgets $page_obj $seq_obj $win_index"
  wm maxsize $win 400 600
  UI_PB_blk_ModalityDialog page_obj seq_obj element_obj win
  UI_PB_com_PositionWindow $win
 }

#=======================================================================
proc UI_PB_evt_EditBlock { page_obj seq_obj args } {
  global paOption
  __evt_DeleteBalloon  page_obj
  set bot_canvas $Page::($page_obj,bot_canvas)
  set focus_img [lindex $args 0]
  if { $focus_img == "" } {
   return
  }
  UI_PB_evt_GetBlkObjFromImageid page_obj seq_obj $focus_img
  set event_obj $sequence::($seq_obj,drag_evt_obj)
  set element_obj $sequence::($seq_obj,drag_blk_obj)
  set current_blk_obj $event_element::($element_obj,block_obj)
  if { $block::($current_blk_obj,blk_type) == "normal" } \
  {
   global gPB_block_name
   set evt_img_id $event_element::($element_obj,icon_id)
   set img [lindex [$bot_canvas itemconfigure $evt_img_id -image] end]
   $img config -relief sunken -bg $paOption(sunken_bg)
   update idletasks
   set gPB_block_name $block::($current_blk_obj,block_name)
   set rename_mode 1
   if { [string match "rapid_spindle*"   $gPB_block_name] || \
    [string match "rapid_traverse*"  $gPB_block_name] } {
    if [string match "Rapid Move" $block::($current_blk_obj,blk_owner)] {
     set rename_mode 0
    }
   }
   if { [string match "start_of_HEAD__*" $gPB_block_name] && \
    [string match "start_of_HEAD__*" $block::($current_blk_obj,blk_owner)] } {
    set rename_mode 0
   }
   if { [string match "end_of_HEAD__*" $gPB_block_name] && \
    [string match "end_of_HEAD__*" $block::($current_blk_obj,blk_owner)] } {
    set rename_mode 0
   }
   UI_PB_evt__DisplayBlockPage $page_obj $seq_obj $current_blk_obj \
   new_blk_page_obj $rename_mode
   set gPB_block_name $block::($current_blk_obj,block_name)
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
   pack $box_frm -fill x -padx 3 -pady 3
   UI_PB_com_CreateActionElems $box_frm cb_arr
   } elseif { $block::($current_blk_obj,blk_type) == "comment" } \
  {
   UI_PB_evt_BringCommentDlg page_obj seq_obj event_obj element_obj \
   current_blk_obj Edit
   } elseif { $block::($current_blk_obj,blk_type) == "macro" } \
  {
   UI_PB_evt_BringFuncBlkPage page_obj seq_obj event_obj element_obj \
   current_blk_obj Edit
  } else \
  {
   set block_obj $event_element::($element_obj,block_obj)
   set cmd_name $block::($block_obj,block_name)
   if [string match "vnc_*" $cmd_name] {
    __Pause "Need a dialog for VNC components"
    } elseif { ![string match "MOM_*" $cmd_name] } {
    UI_PB_evt_BringCmdBlkPage page_obj seq_obj event_obj element_obj \
    current_blk_obj Edit
   }
  }
  set comb_widget $Page::($page_obj,comb_widget)
  set lbx [$comb_widget subwidget listbox]
  set idx [lindex [$lbx curselection] end]
  set ::gPB__comb_index $idx
 }

#=======================================================================
proc UI_PB_DisableProgPageWidgets { page_obj seq_obj } {
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
  NEW_BLK_PAGE_OBJ blk_mode args } {
  upvar $NEW_BLK_PAGE_OBJ new_blk_page_obj
  global gPB
  set canvas_frame $Page::($page_obj,canvas_frame)
  block::readvalue $block_obj blk_obj_attr
  set sub_win [string tolower $blk_obj_attr(0)]
  set win [toplevel $canvas_frame.$sub_win]
  set toplevel_index [llength $gPB(toplevel_list)]
  set win_index [expr $toplevel_index + 1]
  set gPB(toplevel_disable_$win_index) 1
  set element_obj $sequence::($seq_obj,drag_blk_obj)
  UI_PB_com_CreateTransientWindow $win \
  "$gPB(seq,new_trans,title,Label) : $blk_obj_attr(0)" \
  "900x600+300+300" "" "UI_PB_DisableProgPageWidgets $page_obj $seq_obj" \
  "" \
  "UI_PB_evt_ActivateProgPageWidgets $page_obj $seq_obj $win_index"
  if { [llength $args] } {
   set cur_evt_elem_obj [lindex $args 1]
   } else {
   set cur_evt_elem_obj $element_obj
  }
  UI_PB_blk_CreateBlockPage block_obj win new_blk_page_obj $blk_mode $cur_evt_elem_obj
  if [llength $args] {
   set evt_obj [lindex $args 0]
   set elm_obj [lindex $args 1]
   set win_close_cb "UI_PB_blk_NewBlkCancel_CB $new_blk_page_obj \
   $page_obj $seq_obj $evt_obj $elm_obj"
   } else {
   set evt_obj $sequence::($seq_obj,drag_evt_obj)
   set win_close_cb "UI_PB_blk_EditCancel_CB $new_blk_page_obj \
   $page_obj $seq_obj $element_obj"
  }
  wm title $win "$event::($evt_obj,event_name)  -  $gPB(seq,new_trans,title,Label) : $blk_obj_attr(0)"
  set Page::($new_blk_page_obj,force_show_popup_options) 1
  set bot_canvas $Page::($new_blk_page_obj,bot_canvas)
  $bot_canvas bind whole_block <Enter>           "UI_PB_tpth_WholeBlkFocusOn      $new_blk_page_obj $evt_obj %x %y"
  $bot_canvas bind whole_block <Leave>           "UI_PB_tpth_WholeBlkFocusOff     $new_blk_page_obj"
  $bot_canvas bind whole_block <1>               "UI_PB_tpth_WholeBlkStartDrag    $new_blk_page_obj $evt_obj %x %y"
  $bot_canvas bind whole_block <B1-Motion>       "UI_PB_tpth_WholeBlkDrag         $new_blk_page_obj $evt_obj %x %y %X %Y"
  $bot_canvas bind whole_block <ButtonRelease-1> "UI_PB_tpth_WholeBlkEndDrag      $new_blk_page_obj $evt_obj"
  $bot_canvas bind whole_block <3>               "UI_PB_tpth_WholeBlkRightButton  $new_blk_page_obj $evt_obj %x %y %X %Y"
  wm protocol $win WM_DELETE_WINDOW "$win_close_cb"
  UI_PB_com_PositionWindow $win
  return $win
 }

#=======================================================================
proc UI_PB_evt_ActivateProgPageWidgets { page_obj seq_obj win_index } {
  global gPB paOption
  if { $gPB(toplevel_disable_$win_index) } \
  {
   UI_PB_evt_AddBindProcs     page_obj
   UI_PB_evt_BlkBindProcs     page_obj seq_obj
   UI_PB_evt_BindCollapseImg  page_obj seq_obj
   UI_PB_evt_MarkerBindProcs  page_obj seq_obj
   set gPB(toplevel_disable_$win_index) 0
   set bot_canvas $Page::($page_obj,bot_canvas)
   bind $bot_canvas <3> "UI_PB_evt_CanvasPopupMenu $page_obj %X %Y"
   if [info exists Page::($page_obj,comb_widget)] {
    set comb_widget $Page::($page_obj,comb_widget)
    [$comb_widget subwidget entry] config -bg $paOption(entry_disabled_bg) -justify left \
    -state disabled -cursor ""
   }
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
  set new_evt_elem_attr(2) $event_element::($drag_elem_obj,exec_condition_obj)
  set new_evt_elem_attr(3) $event_element::($drag_elem_obj,suppress_flag)
  set new_evt_elem_attr(4) $event_element::($drag_elem_obj,force_addr_list)
  PB_int_CreateNewEventElementByAttr blk_obj new_evt_elem new_evt_elem_attr
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
   if { [string match "MOM_*" $cmd_obj] } \
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
   set elem_name "$::gPB(comment_blk)"
   if [string match "$::gPB(tcl_line_blk)*" $block::($blk_obj,block_name)] {
    set elem_name "$::gPB(tcl_line_blk)"
   }
   PB_int_CreateCommentBlkElem elem_name blk_elem_obj
   set block_element::($blk_elem_obj,elem_mom_variable) \
   $block_element::($prev_cmd_blk_elem,elem_mom_variable)
   PB_int_CreateCommentBlk elem_name blk_elem_obj new_blk_obj
   PB_int_CreateNewEventElement new_blk_obj new_evt_elem
   } elseif { $block::($blk_obj,blk_type) == "macro" } \
  { ;#<06-03-09 wbh> add macro case
   set prev_func_blk_elem  [lindex $block::($blk_obj,elem_addr_list) 0]
   set func_obj $block_element::($prev_func_blk_elem,elem_mom_variable)
   set func_name $function::($func_obj,id)
   PB_int_CreateFuncBlkElem func_name func_blk_elem
   PB_int_CreateFuncBlk func_name func_blk_elem new_blk_obj
   set new_evt_elem_attr(2) $event_element::($drag_elem_obj,exec_condition_obj)
   set new_evt_elem_attr(3) $event_element::($drag_elem_obj,suppress_flag)
   set new_evt_elem_attr(4) $event_element::($drag_elem_obj,force_addr_list)
   PB_int_CreateNewEventElementByAttr new_blk_obj new_evt_elem new_evt_elem_attr
   if [info exists block_element::($prev_func_blk_elem,func_prefix)] \
   {
    set block_element::($func_blk_elem,func_prefix) \
    $block_element::($prev_func_blk_elem,func_prefix)
   }
   if [info exists block_element::($prev_func_blk_elem,func_suppress_flag)] \
   {
    set block_element::($func_blk_elem,func_suppress_flag) \
    $block_element::($prev_func_blk_elem,func_suppress_flag)
   }
  } else \
  {
   set new_evt_elem_attr(2) $event_element::($drag_elem_obj,exec_condition_obj)
   set new_evt_elem_attr(3) $event_element::($drag_elem_obj,suppress_flag)
   set new_evt_elem_attr(4) $event_element::($drag_elem_obj,force_addr_list)
   PB_int_CreateNewEventElementByAttr blk_obj new_evt_elem new_evt_elem_attr
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
  set rest_flag 0
  foreach rest_row $rest_evt_obj_attr(2) \
  {
   if { [lsearch $rest_row $evt_elem_obj] != -1 } \
   {
    set rest_flag 1
    break
   }
  }
  set def_flag 0
  foreach def_row $def_evt_obj_attr(2) \
  {
   if { [lsearch $def_row $evt_elem_obj] != -1 } \
   {
    set def_flag 1
    break
   }
  }
  if { $rest_flag == 0 && $def_flag == 0 } \
  {
   set block_obj $event_element::($evt_elem_obj,block_obj)
   if { $block::($block_obj,blk_type) == "command" } \
   {
    PB_com_DeleteObject $block_obj
    } elseif { $block::($block_obj,blk_type) == "comment" } \
   {
    PB_int_DeleteCommentBlkFromList block_obj
    PB_com_DeleteObject $block_obj
    } elseif { $block::($block_obj,blk_type) == "macro" } \
   {
    PB_com_DeleteObject $block_obj
   }
   PB_com_DeleteObject $evt_elem_obj
  } else \
  {
   set block_obj $event_element::($evt_elem_obj,block_obj)
   block::DeleteFromEventElemList $block_obj evt_elem_obj
   if { $block::($block_obj,blk_type) == "command" } \
   {
    set cmd_blk_elem [lindex $block::($block_obj,elem_addr_list) 0]
    set cmd_obj $block_element::($cmd_blk_elem,elem_mom_variable)
    if { [string match "MOM_*" $cmd_obj] == 0 } \
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
  if { [info exists event_element::($elem_obj,cond_id)] && \
   $event_element::($elem_obj,cond_id) > 0 } {
   __GetOutputAttrIconCoords $elem_obj condition coord_list
   set x0 [lindex $coord_list 0]
   set y0 [lindex $coord_list 1]
   set x1 [lindex $coord_list 2]
   set y1 [lindex $coord_list 3]
   $bot_canvas coords $event_element::($elem_obj,cond_id) \
   $x0 $y0 $x1 $y1
  }
  if { [info exists event_element::($elem_obj,supp_id)] && \
   $event_element::($elem_obj,supp_id) > 0 } {
   __GetOutputAttrIconCoords $elem_obj suppress coord_list
   set x0 [lindex $coord_list 0]
   set y0 [lindex $coord_list 1]
   set x1 [lindex $coord_list 2]
   set y1 [lindex $coord_list 3]
   $bot_canvas coords $event_element::($elem_obj,supp_id) \
   $x0 $y0 $x1 $y1
  }
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
  global paOption
  set seq_evt_list $sequence::($seq_obj,evt_obj_list)
  set bot_canvas $Page::($page_obj,bot_canvas)
  foreach event_name $Page::($page_obj,event_list) \
  {
   PB_com_RetObjFrmName event_name seq_evt_list ret_obj
   if { $ret_obj } \
   {
    set evt_img_id $event::($ret_obj,icon_id)
    set img [lindex [$bot_canvas itemconfigure $evt_img_id -image] end]
    $img config -relief sunken -bg $paOption(sunken_bg)
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

#=======================================================================
proc UI_PB_evt_BringFuncBlkPage { PAGE_OBJ SEQ_OBJ ACTIVE_EVT_OBJ ELEM_OBJ \
  BLOCK_OBJ act_mode } {
  upvar $PAGE_OBJ page_obj
  upvar $SEQ_OBJ seq_obj
  upvar $ACTIVE_EVT_OBJ active_evt_obj
  upvar $ELEM_OBJ elem_obj
  upvar $BLOCK_OBJ block_obj
  global gPB paOption
  set bot_canvas $Page::($page_obj,bot_canvas)
  set blk_img_id $event_element::($elem_obj,icon_id)
  set img [lindex [$bot_canvas itemconfigure $blk_img_id -image] end]
  set img [string trim $img]
  if { ![string match "" $img] } {
   $img config -relief sunken -bg $paOption(sunken_bg)
  }
  update idletasks
  set canvas_frame $Page::($page_obj,canvas_frame)
  block::readvalue $block_obj blk_obj_attr
  set sub_win [string tolower $blk_obj_attr(0)]
  set idx [string first "." $sub_win]
  if { $idx > 0 } {
   set sub_win [string range $sub_win 0 [expr $idx - 1]]
  }
  set win [toplevel $canvas_frame.$sub_win]
  set toplevel_index [llength $gPB(toplevel_list)]
  set win_index [expr $toplevel_index + 1]
  set gPB(toplevel_disable_$win_index) 1
  set func_page_obj [new Page "Macro" "Macro"]
  set Page::($func_page_obj,canvas_frame) $win
  set Page::($func_page_obj,page_id) $win
  set blk_elem_obj [lindex $block::($block_obj,elem_addr_list) 0]
  set func_obj $block_element::($blk_elem_obj,elem_mom_variable)
  if { $act_mode == "Edit" } \
  {
   set win_close_cb  "UI_PB_func_SeqEditFuncBlkCancel_CB $win $page_obj \
   $seq_obj $active_evt_obj $elem_obj $func_page_obj"
  } else \
  {
   set win_close_cb  "UI_PB_func_SeqNewFuncBlkCancel_CB $win $page_obj \
   $seq_obj $active_evt_obj $elem_obj $func_page_obj"
  }
  UI_PB_com_CreateTransientWindow $win "$function::($func_obj,id)" \
  "800x550+200+200" "" "UI_PB_DisableProgPageWidgets $page_obj $seq_obj" \
  "$win_close_cb" \
  "UI_PB_evt_ActivateProgPageWidgets $page_obj $seq_obj $win_index"
  set box_frm [frame $win.total_box]
  pack $box_frm -side bottom -fill x
  set box1_frm [frame $box_frm.box1]
  set box2_frm [frame $box_frm.box2]
  tixForm $box1_frm -top 0 -left 0 -right %60 -padright 20 -padx 4 ;#<07-10-09 wbh> add -padx 4
  tixForm $box2_frm -top 0 -left $box1_frm -right %100 -padx 4 ;#<07-10-09 wbh> add -padx 4
  set first_list {"gPB(nav_button,default,Label)"  \
   "gPB(nav_button,restore,Label)"  \
  "gPB(nav_button,apply,Label)"}
  set second_list {"gPB(nav_button,cancel,Label)"  \
  "gPB(nav_button,ok,Label)"}
  set cb_arr(gPB(nav_button,default,Label))  "UI_PB_func_DefaultCallBack $func_page_obj"
  set cb_arr(gPB(nav_button,restore,Label))  "UI_PB_func_RestoreCallBack $func_page_obj"
  set cb_arr(gPB(nav_button,apply,Label))    "UI_PB_func_ApplyCallBack $func_page_obj $block_obj"
  if { [string match "New" $act_mode] } \
  {
   UI_PB_com_CreateButtonBox $box1_frm first_list cb_arr $win
  } else \
  {
   UI_PB_com_CreateButtonBox $box1_frm first_list cb_arr
  }
  if { [string match "New" $act_mode] } \
  {
   set cb_arr(gPB(nav_button,cancel,Label)) \
   "UI_PB_func_SeqNewFuncBlkCancel_CB $win $page_obj \
   $seq_obj $active_evt_obj $elem_obj $func_page_obj"
   set cb_arr(gPB(nav_button,ok,Label)) \
   "UI_PB_func_SeqNewFuncBlkOk_CB $win $page_obj $seq_obj \
   $elem_obj $func_page_obj"
  } else \
  {
   set cb_arr(gPB(nav_button,cancel,Label)) \
   "UI_PB_func_SeqEditFuncBlkCancel_CB $win $page_obj \
   $seq_obj $active_evt_obj $elem_obj $func_page_obj"
   set cb_arr(gPB(nav_button,ok,Label)) \
   "UI_PB_func_SeqEditFuncBlkOk_CB $win $page_obj $seq_obj \
   $elem_obj $func_page_obj"
  }
  UI_PB_com_CreateButtonBox $box2_frm second_list cb_arr
  set Page::($func_page_obj,func_obj) $func_obj
  UI_PB_func_CreateFuncBlkPage func_page_obj 1
  if { $::env(PB_UDE_ENABLED) == 1 } \
  {
   if { $active_evt_obj == 0 } \
   {
    set evt_name $block::($block_obj,blk_owner)
    set Page::($func_page_obj,ude_obj) [UI_PB_ude_GetUdeEventObjFrmEvtName $evt_name]
   } elseif [info exists event::($active_evt_obj,event_ude_name)] \
   {
    set Page::($func_page_obj,ude_obj) [UI_PB_ude_GetUdeEventObj $active_evt_obj]
   } else \
   {
    set Page::($func_page_obj,ude_obj) NULL
   }
   UI_PB_func__CreateUdePopupLabels $func_page_obj
  }
  UI_PB_func__CreateCommonPopupLabels $func_page_obj
  update
  UI_PB_func_DisplayFuncBlkAttr func_page_obj func_obj
  UI_PB_com_PositionWindow $win
 }

#=======================================================================
proc UI_PB_evt_CreateExecAttrSymbols { PAGE_OBJ EVT_ELEM_OBJ } {
  upvar $PAGE_OBJ page_obj
  upvar $EVT_ELEM_OBJ evt_elem_obj
  global gPB
  if { $event_element::($evt_elem_obj,exec_condition_obj) > 0 } {
   __GetOutputAttrIconCoords $evt_elem_obj condition coord_list
   set x0 [lindex $coord_list 0]
   set y0 [lindex $coord_list 1]
   set x1 [lindex $coord_list 2]
   set y1 [lindex $coord_list 3]
   set cond_color $gPB(elem_condition_color)
   set event_element::($evt_elem_obj,cond_id) [UI_PB_com_CreateRectangle \
   $page_obj $x0 $y0 $x1 $y1 $cond_color $cond_color "" "stationary"]
  }
  if { $event_element::($evt_elem_obj,suppress_flag) } {
   __GetOutputAttrIconCoords $evt_elem_obj suppress coord_list
   set x0 [lindex $coord_list 0]
   set y0 [lindex $coord_list 1]
   set x1 [lindex $coord_list 2]
   set y1 [lindex $coord_list 3]
   set supp_color $gPB(elem_suppress_color)
   set event_element::($evt_elem_obj,supp_id) [UI_PB_com_CreateRectangle \
   $page_obj $x0 $y0 $x1 $y1 $supp_color $supp_color "" "stationary"]
  }
 }

#=======================================================================
proc __GetOutputAttrIconCoords { evt_elem_obj type COORDS } {
  upvar $COORDS coord_list
  set coord_list ""
  set elem_xc $event_element::($evt_elem_obj,xc)
  set elem_yc $event_element::($evt_elem_obj,yc)
  set width 174
  set height 24
  set orgx [expr $elem_xc - $width / 2]
  set orgy [expr $elem_yc - $height / 2 + 1]
  if 0 {
   if { [string match "condition" $type] } {
    lappend coord_list $orgx
    lappend coord_list $orgy
    lappend coord_list [expr $orgx + 2]
    lappend coord_list $elem_yc
    } elseif { [string match "suppress" $type] } {
    lappend coord_list $orgx
    lappend coord_list $elem_yc
    lappend coord_list [expr $orgx + 2]
    lappend coord_list [expr $elem_yc + $height / 2]
   }
  }
  if { [string match "condition" $type] } {
   lappend coord_list [expr $orgx + 2]
   lappend coord_list [expr $orgy + 1]
   lappend coord_list [expr $orgx + 2 + 2] ;# width 2
   lappend coord_list $elem_yc
   } elseif { [string match "suppress" $type] } {
   lappend coord_list [expr $orgx + 2]
   lappend coord_list $elem_yc
   lappend coord_list [expr $orgx + 2 + 2]
   lappend coord_list [expr $elem_yc + $height/2 - 2]
  }
 }

#=======================================================================
proc UI_PB_evt_ReplaceExecAttrSymbols { PAGE_OBJ EVT_ELEM_OBJ type } {
  upvar $PAGE_OBJ page_obj
  upvar $EVT_ELEM_OBJ evt_elem_obj
  global gPB
  if { [string match "cond" $type] } {
   if { $event_element::($evt_elem_obj,exec_condition_obj) > 0 } {
    if { [info exists event_element::($evt_elem_obj,cond_id)] && \
     $event_element::($evt_elem_obj,cond_id) > 0 } {
     return
    }
    __GetOutputAttrIconCoords $evt_elem_obj condition coord_list
    set x0 [lindex $coord_list 0]
    set y0 [lindex $coord_list 1]
    set x1 [lindex $coord_list 2]
    set y1 [lindex $coord_list 3]
    set cond_color $gPB(elem_condition_color)
    set event_element::($evt_elem_obj,cond_id) [UI_PB_com_CreateRectangle \
    $page_obj $x0 $y0 $x1 $y1 $cond_color $cond_color "" "stationary"]
    } else {
    if { [info exists event_element::($evt_elem_obj,cond_id)] && \
     $event_element::($evt_elem_obj,cond_id) > 0 } {
     set bot_canvas $Page::($page_obj,bot_canvas)
     $bot_canvas delete $event_element::($evt_elem_obj,cond_id)
     set event_element::($evt_elem_obj,cond_id) 0
    }
   }
   return
  }
  if { [string match "suppress" $type] } {
   if { $event_element::($evt_elem_obj,suppress_flag) } {
    if { [info exists event_element::($evt_elem_obj,supp_id)] && \
     $event_element::($evt_elem_obj,supp_id) > 0 } {
     return
    }
    __GetOutputAttrIconCoords $evt_elem_obj suppress coord_list
    set x0 [lindex $coord_list 0]
    set y0 [lindex $coord_list 1]
    set x1 [lindex $coord_list 2]
    set y1 [lindex $coord_list 3]
    set supp_color $gPB(elem_suppress_color)
    set event_element::($evt_elem_obj,supp_id) [UI_PB_com_CreateRectangle \
    $page_obj $x0 $y0 $x1 $y1 $supp_color $supp_color "" "stationary"]
    } else {
    if { [info exists event_element::($evt_elem_obj,supp_id)] && \
     $event_element::($evt_elem_obj,supp_id) > 0 } {
     set bot_canvas $Page::($page_obj,bot_canvas)
     $bot_canvas delete $event_element::($evt_elem_obj,supp_id)
     set event_element::($evt_elem_obj,supp_id) 0
    }
   }
   return
  }
 }

#=======================================================================
proc UI_PB_ude_CreateUdeEditor {pw event_obj page_obj seq_obj {isNewer 0}} {
   global gPB
   global paOption
   if ![string compare $event_obj "NULL"] {
    tk_messageBox -message "event_obj is NULL" -parent $gPB(main_window)
    return
   }
   if ![string compare $event::($event_obj,event_ude_name) ""] {
    tk_messageBox -message "$gPB(ude,editor,no_ude)" -parent $gPB(main_window)
    return
   }
   set udeevent [UI_PB_ude_GetUdeEventObj $event_obj]
   if ![string compare $udeevent "NULL"] {
    tk_messageBox -message "some mistakes in PUI" -icon error \
    -title $gPB(msg,error) -parent [UI_PB_com_AskActiveWindow]
    return
   }
   set evt_img_id $event::($event_obj,icon_id)
   set img [lindex [$pw itemconfigure $evt_img_id -image] end]
   $img config -relief sunken -bg $paOption(sunken_bg)
   set evt_text $event::($event_obj,text_id)
   $pw itemconfigure $evt_text -fill black
   set OBJ [new udeEditor $event_obj $udeevent $pw $isNewer]
   set udeEditor::($OBJ,page_obj) $page_obj
   set udeEditor::($OBJ,seq_obj) $seq_obj
   set udeEditor::($OBJ,req_w_h) [UI_PB_ude_CreateDummyTypeWidget]
   set ude_main [toplevel $pw.$OBJ]
   wm protocol $ude_main WM_DELETE_WINDOW "UI_PB_ude_ProtocolDelete $ude_main"
   set rootx [winfo rootx $gPB(main_window)]
   set rooty [winfo rooty $gPB(main_window)]
   set x [expr {$rootx + 100}]
   set y [expr {$rooty + 60}]
   set geom +${x}+${y}
   if {[classof $udeevent] == "::ude_event"} {
    set title $gPB(ude,editor,TITLE)
    } else {
    set title $gPB(udc,editor,TITLE)
   }
   UI_PB_com_CreateTransientWindow $ude_main $title $geom "" "" "" ""
   wm resizable $ude_main 1 1
   bind $ude_main <Destroy>  "UI_PB_ude_DestroyBind $pw %W $event_obj"
   set ude_top [frame ${ude_main}.top]
   set ude_bottom [frame ${ude_main}.bottom]
   pack $ude_bottom -fill x -side bottom -padx 3 -pady 3
   pack $ude_top -fill both -side top -expand yes
   UI_PB_ude_AddApplyDef $ude_bottom
   set ude_left [frame ${ude_top}.leftframe -bg $udeEditor::($OBJ,left_bg) \
   -width 150]
   pack $ude_left -fill y -side left
   if { ![string compare $::tix_version 8.4] } {
    set ude_dlg  [UI_PB_mthd_CreateSFrameWindow ${ude_top}.rightframe xy]
    set ude_right ${ude_top}.rightframe
    set gPB(ude,binding_w) $ude_right
    $ude_dlg config -bg $udeEditor::($OBJ,right_bg)
    ${ude_right}.sf config -bg $udeEditor::($OBJ,right_bg)
    set udeEditor::($OBJ,right_frame) $ude_right
    pack $ude_right -expand yes -fill both
    } else {
    set ude_dlg ""
    UI_PB_mthd_CreateScrollWindow $ude_top rightframe ude_dlg xy
    $ude_dlg config -bg $udeEditor::($OBJ,right_bg)
    set udeEditor::($OBJ,right_frame) ${ude_top}.rightframe
   }
   set dlg_frame [frame ${ude_dlg}.frm -width 200  -height 10\
   -relief raised -bg $udeEditor::($OBJ,dialog_bg) \
   -bd 2 -takefocus 1 -highlightt 0]
   pack $dlg_frame -side top -anchor center -pady 10
   if ![string compare $::tix_version 8.4] {
    bind $ude_main <MouseWheel> {
     $gPB(ude,binding_w).sf yview scroll [expr {- (%D / 120) * 1}] units
    }
   }
   UI_PB_ude_CreateTypeAndTrashItems $ude_left
   UI_PB_ude_CreateUdeDialog $dlg_frame
  }

#=======================================================================
proc UI_PB_ude_DestroyBind {bot_canvas w event_obj} {
  global paOption
  if ![string compare $w [winfo toplevel $w]] {
   set evt_img_id $event::($event_obj,icon_id)
   set img [lindex [$bot_canvas itemconfigure $evt_img_id -image] end]
   $img config -relief raised -bg $event::($event_obj,bg)
   set evt_text $event::($event_obj,text_id)
   $bot_canvas itemconfigure $evt_text -fill $paOption(special_fg)
   delete $udeEditor::(obj)
   UI_PB_com_DismissActiveWindow $w
   UI_PB_com_DeleteFromTopLevelList $w
   __com_RehostNoLicenseMsg
   __com_GrayOutDefaultButton
   UI_PB_com_UnGraySaveOptions
  }
 }

#=======================================================================
proc UI_PB_ude_ProtocolDelete {ude_main} {
  global gPB
  if {[info exists gPB(use_info)] && $gPB(use_info)} {
   return
   } else {
   UI_PB_ude_Cancel
  }
 }

#=======================================================================
proc UI_PB_ude_DeleteWindow {top_win} {
  global gPB
  tk_focusFollowsMouse
  if {[info exists gPB(use_info)] && $gPB(use_info)} {
   return
   } else {
   destroy $top_win
  }
 }

#=======================================================================
proc UI_PB_ude_AddApplyDef {w} {
  global gPB
  set box1_frm [frame $w.box1]
  set box2_frm [frame $w.box2]
  tixForm $box1_frm -top 0 -left 0 -right %60 -padright 20
  tixForm $box2_frm -top 0 -left $box1_frm -right %100
  set first_list {"gPB(nav_button,default,Label)" \
   "gPB(nav_button,restore,Label)" \
  "gPB(nav_button,apply,Label)"}
  set second_list {"gPB(nav_button,cancel,Label)" \
  "gPB(nav_button,ok,Label)"}
  set cb_arr(gPB(nav_button,default,Label)) ""
  set cb_arr(gPB(nav_button,restore,Label)) ""
  set cb_arr(gPB(nav_button,apply,Label)) ""
  UI_PB_com_CreateButtonBox $box1_frm first_list cb_arr
  ${box1_frm}.box.act_0 config -command "UI_PB_ude_Default"
  ${box1_frm}.box.act_1 config -command "UI_PB_ude_Restore"
  ${box1_frm}.box.act_2 config -command "UI_PB_ude_Apply"
  set cb_arr(gPB(nav_button,cancel,Label)) ""
  set cb_arr(gPB(nav_button,ok,Label)) ""
  UI_PB_com_CreateButtonBox $box2_frm second_list cb_arr
  ${box2_frm}.box.act_0 config -command "UI_PB_ude_OK"
  ${box2_frm}.box.act_1 config -command "UI_PB_ude_Cancel"
 }

#=======================================================================
proc UI_PB_ude_Restore {} {
  set OBJ $udeEditor::(obj)
  set childItems [winfo child $udeEditor::($OBJ,midframe)]
  foreach child $childItems {
   destroy $child
  }
  foreach obj $udeEditor::($OBJ,sub_objs) {
   delete $obj
  }
  set udeEditor::($OBJ,sub_objs) [list]
  set udeEditor::($OBJ,numOfItems) 0
  set udeEditor::($OBJ,totalNumOfItems) 0
  foreach one $udeEditor::($OBJ,temp_new_paramobj) {
  }
  set udeEditor::($OBJ,temp_new_paramobj) [list]
  set udeEditor::($OBJ,pst_order) [list]
  set udeEditor::($OBJ,hlWidgets) [list]
  set udeevent $udeEditor::(ude_event_obj)
  if {$udeEditor::($OBJ,TYPE) == "UDE"} {
   set param_obj_list $ude_event::($udeevent,param_obj_list)
   } else {
   set param_obj_list $cycle_event::($udeevent,param_obj_list)
  }
  set num [llength $param_obj_list]
  if {$num != "0"} {
   foreach param_obj $param_obj_list {
    UI_PB_ude_AddItems $param_obj $num
   }
   } else {
   $udeEditor::($OBJ,midframe) config -height 5
  }
  udeEditor::InitPositionList $OBJ
  if {$udeEditor::($OBJ,TYPE) == "UDE"} {
   set udeEditor::($OBJ,ueo_name) $udeEditor::($OBJ,restore_ueo_name)
   set udeEditor::($OBJ,ueo_post_event) \
   $udeEditor::($OBJ,restore_ueo_post_event)
   set udeEditor::($OBJ,ueo_ui_label) \
   $udeEditor::($OBJ,restore_ueo_ui_label)
   set udeEditor::($OBJ,ueo_category) \
   $udeEditor::($OBJ,restore_ueo_category)
   set udeEditor::($OBJ,label_text) \
   $udeEditor::($OBJ,ueo_ui_label)
   set udeEditor::($OBJ,ueo_help_descript) \
   $udeEditor::($OBJ,restore_ueo_help_descript)
   set udeEditor::($OBJ,ueo_help_url) \
   $udeEditor::($OBJ,restore_ueo_help_url)
   UI_PB_ude_DisplayUdeHelpWidgets
   } else {
   set udeEditor::($OBJ,ueo_name) $udeEditor::($OBJ,restore_ueo_name)
   set udeEditor::($OBJ,ueo_ui_label) \
   $udeEditor::($OBJ,restore_ueo_ui_label)
   set udeEditor::($OBJ,label_text) \
   $udeEditor::($OBJ,ueo_ui_label)
   set udeEditor::($OBJ,ueo_is_sys_cycle) \
   $udeEditor::($OBJ,restore_ueo_is_sys_cycle)
   set udeEditor::($OBJ,ueo_type) \
   $udeEditor::($OBJ,restore_ueo_type)
   global gPB
   if $gPB(enable_helpdesc_for_udc) {
    set udeEditor::($OBJ,ueo_help_descript) \
    $udeEditor::($OBJ,restore_ueo_help_descript)
    set udeEditor::($OBJ,ueo_help_url) \
    $udeEditor::($OBJ,restore_ueo_help_url)
    UI_PB_ude_DisplayUdeHelpWidgets
   }
  }
 }

#=======================================================================
proc UI_PB_ude_Default {} {
  set OBJ $udeEditor::(obj)
  set childItems [winfo child $udeEditor::($OBJ,midframe)]
  foreach child $childItems {
   destroy $child
  }
  foreach obj $udeEditor::($OBJ,sub_objs) {
   delete $obj
  }
  set udeEditor::($OBJ,sub_objs) [list]
  set udeEditor::($OBJ,numOfItems) 0
  set udeEditor::($OBJ,totalNumOfItems) 0
  foreach one $udeEditor::($OBJ,temp_new_paramobj) {
   delete $one
  }
  set udeEditor::($OBJ,temp_new_paramobj) [list]
  set udeEditor::($OBJ,pst_order) [list]
  set udeEditor::($OBJ,hlWidgets) [list]
  set udeevent $udeEditor::(ude_event_obj)
  if {$udeEditor::($OBJ,TYPE) == "UDE"} {
   set param_obj_list $ude_event::($udeevent,def_param_obj_list)
   } else {
   set param_obj_list $cycle_event::($udeevent,def_param_obj_list)
  }
  set num [llength $param_obj_list]
  foreach param_obj $param_obj_list {
   set ClassName [string trim [classof $param_obj] ::]
   switch -exact $ClassName {
    param::integer  {
     set temp_name    $param::integer::($param_obj,name)
     set temp_type    $param::integer::($param_obj,type)
     set temp_value   $param::integer::($param_obj,default)
     set temp_toggle  $param::integer::($param_obj,toggle)
     set temp_label   $param::integer::($param_obj,ui_label)
    }
    param::double   {
     set temp_name    $param::double::($param_obj,name)
     set temp_type    $param::double::($param_obj,type)
     set temp_value   $param::double::($param_obj,default)
     set temp_toggle  $param::double::($param_obj,toggle)
     set temp_label   $param::double::($param_obj,ui_label)
    }
    param::option   {
     set temp_name    $param::option::($param_obj,name)
     set temp_type    $param::option::($param_obj,type)
     set temp_value   $param::option::($param_obj,default)
     set temp_options $param::option::($param_obj,options)
     set temp_label   $param::option::($param_obj,ui_label)
     set temp_toggle  $param::option::($param_obj,toggle)
    }
    param::boolean  {
     set temp_name    $param::boolean::($param_obj,name)
     set temp_type    $param::boolean::($param_obj,type)
     set temp_value   $param::boolean::($param_obj,default)
     set temp_label   $param::boolean::($param_obj,ui_label)
    }
    param::string   {
     set temp_name    $param::string::($param_obj,name)
     set temp_type    $param::string::($param_obj,type)
     set temp_toggle  $param::string::($param_obj,toggle)
     set temp_label   $param::string::($param_obj,ui_label)
     set temp_value   $param::string::($param_obj,default)
    }
    param::point    {
     set temp_name    $param::point::($param_obj,name)
     set temp_type    $param::point::($param_obj,type)
     set temp_label   $param::point::($param_obj,ui_label)
     set temp_toggle  $param::point::($param_obj,toggle)
    }
    param::bitmap   {
     set temp_name    $param::bitmap::($param_obj,name)
     set temp_type    $param::bitmap::($param_obj,type)
     set temp_value   $param::bitmap::($param_obj,default)
    }
    param::group    {
     set temp_name    $param::group::($param_obj,name)
     set temp_type    $param::group::($param_obj,type)
     set temp_value   $param::group::($param_obj,default)
     set temp_label   $param::group::($param_obj,ui_label)
    }
    param::vector   {
     set temp_name    $param::vector::($param_obj,name)
     set temp_type    $param::vector::($param_obj,type)
     set temp_label   $param::vector::($param_obj,ui_label)
     set temp_toggle  $param::vector::($param_obj,toggle)
    }
   }
   switch -exact $ClassName {
    param::integer  {
     set  param::integer::($param_obj,name)      \
     $param::integer::($param_obj,def_name)
     set  param::integer::($param_obj,type)      \
     $param::integer::($param_obj,def_type)
     set  param::integer::($param_obj,default) \
     $param::integer::($param_obj,def_default)
     set  param::integer::($param_obj,toggle)    \
     $param::integer::($param_obj,def_toggle)
     set  param::integer::($param_obj,ui_label)  \
     $param::integer::($param_obj,def_ui_label)
    }
    param::double   {
     set  param::double::($param_obj,name)       \
     $param::double::($param_obj,def_name)
     set  param::double::($param_obj,type)       \
     $param::double::($param_obj,def_type)
     set  param::double::($param_obj,default)  \
     $param::double::($param_obj,def_default)
     set  param::double::($param_obj,toggle)     \
     $param::double::($param_obj,def_toggle)
     set  param::double::($param_obj,ui_label)   \
     $param::double::($param_obj,def_ui_label)
    }
    param::option   {
     set  param::option::($param_obj,name)       \
     $param::option::($param_obj,def_name)
     set  param::option::($param_obj,type)       \
     $param::option::($param_obj,def_type)
     set  param::option::($param_obj,default)  \
     $param::option::($param_obj,def_default)
     set  param::option::($param_obj,options)    \
     $param::option::($param_obj,def_options)
     set  param::option::($param_obj,ui_label)   \
     $param::option::($param_obj,def_ui_label)
     set  param::option::($param_obj,toggle)     \
     $param::option::($param_obj,def_toggle)
    }
    param::boolean  {
     set  param::boolean::($param_obj,name)      \
     $param::boolean::($param_obj,def_name)
     set  param::boolean::($param_obj,type)      \
     $param::boolean::($param_obj,def_type)
     set  param::boolean::($param_obj,default) \
     $param::boolean::($param_obj,def_default)
     set  param::boolean::($param_obj,ui_label)  \
     $param::boolean::($param_obj,def_ui_label)
    }
    param::string   {
     set  param::string::($param_obj,name)       \
     $param::string::($param_obj,def_name)
     set  param::string::($param_obj,type)       \
     $param::string::($param_obj,def_type)
     set  param::string::($param_obj,toggle)     \
     $param::string::($param_obj,def_toggle)
     set  param::string::($param_obj,ui_label)   \
     $param::string::($param_obj,def_ui_label)
     set  param::string::($param_obj,default)  \
     $param::string::($param_obj,def_default)
    }
    param::point    {
     set  param::point::($param_obj,name)        \
     $param::point::($param_obj,def_name)
     set  param::point::($param_obj,type)        \
     $param::point::($param_obj,def_type)
     set  param::point::($param_obj,ui_label)    \
     $param::point::($param_obj,def_ui_label)
     set  param::point::($param_obj,toggle)      \
     $param::point::($param_obj,def_toggle)
    }
    param::bitmap   {
     set  param::bitmap::($param_obj,name)       \
     $param::bitmap::($param_obj,def_name)
     set  param::bitmap::($param_obj,type)       \
     $param::bitmap::($param_obj,def_type)
     set  param::bitmap::($param_obj,default)  \
     $param::bitmap::($param_obj,def_default)
    }
    param::group    {
     set  param::group::($param_obj,name)       \
     $param::group::($param_obj,def_name)
     set  param::group::($param_obj,type)       \
     $param::group::($param_obj,def_type)
     set  param::group::($param_obj,default)  \
     $param::group::($param_obj,def_default)
     set  param::group::($param_obj,ui_label)   \
     $param::group::($param_obj,def_ui_label)
    }
    param::vector   {
     set  param::vector::($param_obj,name)        \
     $param::vector::($param_obj,def_name)
     set  param::vector::($param_obj,type)        \
     $param::vector::($param_obj,def_type)
     set  param::vector::($param_obj,ui_label)    \
     $param::vector::($param_obj,def_ui_label)
     set  param::vector::($param_obj,toggle)      \
     $param::vector::($param_obj,def_toggle)
    }
   }
   UI_PB_ude_AddItems $param_obj $num
   switch -exact $ClassName {
    param::integer  {
     set  param::integer::($param_obj,name)      $temp_name
     set  param::integer::($param_obj,type)      $temp_type
     set  param::integer::($param_obj,default)   $temp_value
     set  param::integer::($param_obj,toggle)    $temp_toggle
     set  param::integer::($param_obj,ui_label)  $temp_label
    }
    param::double   {
     set  param::double::($param_obj,name)       $temp_name
     set  param::double::($param_obj,type)       $temp_type
     set  param::double::($param_obj,default)    $temp_value
     set  param::double::($param_obj,toggle)     $temp_toggle
     set  param::double::($param_obj,ui_label)   $temp_label
    }
    param::option   {
     set  param::option::($param_obj,name)       $temp_name
     set  param::option::($param_obj,type)       $temp_type
     set  param::option::($param_obj,default)    $temp_value
     set  param::option::($param_obj,options)    $temp_options
     set  param::option::($param_obj,ui_label)   $temp_label
     set  param::option::($param_obj,toggle)     $temp_toggle
    }
    param::boolean  {
     set  param::boolean::($param_obj,name)      $temp_name
     set  param::boolean::($param_obj,type)      $temp_type
     set  param::boolean::($param_obj,default)   $temp_value
     set  param::boolean::($param_obj,ui_label)  $temp_label
    }
    param::string   {
     set  param::string::($param_obj,name)       $temp_name
     set  param::string::($param_obj,type)       $temp_type
     set  param::string::($param_obj,toggle)     $temp_toggle
     set  param::string::($param_obj,ui_label)   $temp_label
     set  param::string::($param_obj,default)    $temp_value
    }
    param::point    {
     set  param::point::($param_obj,name)        $temp_name
     set  param::point::($param_obj,type)        $temp_type
     set  param::point::($param_obj,ui_label)    $temp_label
     set  param::point::($param_obj,toggle)      $temp_toggle
    }
    param::bitmap   {
     set  param::bitmap::($param_obj,name)       $temp_name
     set  param::bitmap::($param_obj,type)       $temp_type
     set  param::bitmap::($param_obj,default)    $temp_value
    }
    param::group   {
     set  param::group::($param_obj,name)        $temp_name
     set  param::group::($param_obj,type)        $temp_type
     set  param::group::($param_obj,default)     $temp_value
     set  param::group::($param_obj,ui_label)    $temp_label
    }
    param::vector   {
     set  param::vector::($param_obj,name)       $temp_name
     set  param::vector::($param_obj,type)       $temp_type
     set  param::vector::($param_obj,ui_label)   $temp_label
     set  param::vector::($param_obj,toggle)     $temp_toggle
    }
   }
  }
  if {[llength $param_obj_list] == "0"} {
   $udeEditor::($OBJ,midframe) config -height 5
  }
  udeEditor::InitPositionList $OBJ
  set ueo $udeEditor::(ude_event_obj)
  if {$udeEditor::($OBJ,TYPE) == "UDE"} {
   set udeEditor::($OBJ,ueo_name)  $ude_event::($ueo,def_name)
   set udeEditor::($OBJ,ueo_post_event) $ude_event::($ueo,def_post_event)
   set udeEditor::($OBJ,ueo_ui_label)   $ude_event::($ueo,def_ui_label)
   if ![string compare $ude_event::($ueo,def_category) "\{\}"] {
    set udeEditor::($OBJ,ueo_category) ""
    } else {
    set udeEditor::($OBJ,ueo_category)   $ude_event::($ueo,def_category)
   }
   set udeEditor::($OBJ,label_text)        $udeEditor::($OBJ,ueo_ui_label)
   set udeEditor::($OBJ,ueo_help_descript) $ude_event::($ueo,def_help_descript)
   set udeEditor::($OBJ,ueo_help_url)   $ude_event::($ueo,def_help_url)
   UI_PB_ude_DisplayUdeHelpWidgets
   } else {
   set udeEditor::($OBJ,ueo_name) $cycle_event::($ueo,def_name)
   set udeEditor::($OBJ,ueo_ui_label) $cycle_event::($ueo,def_ui_label)
   set udeEditor::($OBJ,ueo_is_sys_cycle) $cycle_event::($ueo,def_is_sys_cycle)
   if {$udeEditor::($OBJ,ueo_is_sys_cycle) ==1} {
    set udeEditor::($OBJ,ueo_type)  "SYSCYC"
    } else {
    set udeEditor::($OBJ,ueo_type)  "UDC"
   }
   set udeEditor::($OBJ,label_text)        $udeEditor::($OBJ,ueo_ui_label)
   global gPB
   if $gPB(enable_helpdesc_for_udc) {
    set udeEditor::($OBJ,ueo_help_descript) $cycle_event::($ueo,def_help_descript)
    set udeEditor::($OBJ,ueo_help_url)   $cycle_event::($ueo,def_help_url)
    UI_PB_ude_DisplayUdeHelpWidgets
   }
  }
 }

#=======================================================================
proc UI_PB_ude_Apply {} {
  global post_object gPB tixOption
  set OBJ $udeEditor::(obj)
  set udeevent $udeEditor::(ude_event_obj)
  if {$udeEditor::($OBJ,numOfItems) <= 0} {
   tk_messageBox -message $gPB(ude,validate) -icon error \
   -title $gPB(msg,error) -parent [UI_PB_com_AskActiveWindow]
   return FALSE
  }
  if {$udeEditor::($OBJ,TYPE) == "UDE"} {
   set ude_event::($udeevent,param_obj_list) [list]
   } else {
   set cycle_event::($udeevent,param_obj_list) [list]
  }
  set udeEditor::($OBJ,temp_new_paramobj) [list]
  array set ObjArray $udeEditor::($OBJ,pst_order)
  set nums [array size ObjArray]
  set temp_param_obj_list [list]
  for {set idx 0} {$idx < $nums} {incr idx} {
   set uiobj $ObjArray($idx)
   set classname [string trim [classof $uiobj] ::]
   switch -exact $classname {
    udeEditor::uiInteger {
     set pobj $udeEditor::uiInteger::($uiobj,param_obj)
     set param::integer::($pobj,name) \
     $udeEditor::uiInteger::($uiobj,name)
     set param::integer::($pobj,type) i
     set param::integer::($pobj,default)   \
     $udeEditor::uiInteger::($uiobj,value)
     set toggle_v $udeEditor::uiInteger::($uiobj,toggle_v)
     if {$toggle_v == 1} {
      set param::integer::($pobj,toggle)   On
      } elseif {$toggle_v == 0} {
      set param::integer::($pobj,toggle)   Off
      } else {
      set param::integer::($pobj,toggle)   ""
     }
     set param::integer::($pobj,ui_label) \
     $udeEditor::uiInteger::($uiobj,ui_label)
    }
    udeEditor::uiReal    {
     set pobj $udeEditor::uiReal::($uiobj,param_obj)
     set param::double::($pobj,name) \
     $udeEditor::uiReal::($uiobj,name)
     set param::double::($pobj,type) d
     set param::double::($pobj,default)   \
     $udeEditor::uiReal::($uiobj,value)
     set toggle_v $udeEditor::uiReal::($uiobj,toggle_v)
     if {$toggle_v == 1} {
      set param::double::($pobj,toggle)   On
      } elseif {$toggle_v == 0} {
      set param::double::($pobj,toggle)   Off
      } else {
      set param::double::($pobj,toggle)   ""
     }
     set param::double::($pobj,ui_label) \
     $udeEditor::uiReal::($uiobj,ui_label)
    }
    udeEditor::uiText    {
     set pobj $udeEditor::uiText::($uiobj,param_obj)
     set param::string::($pobj,name) \
     $udeEditor::uiText::($uiobj,name)
     set param::string::($pobj,type) s
     set param::string::($pobj,default)   \
     $udeEditor::uiText::($uiobj,value)
     set toggle_v $udeEditor::uiText::($uiobj,toggle_v)
     if {$toggle_v == 1} {
      set param::string::($pobj,toggle)   On
      } elseif {$toggle_v == 0} {
      set param::string::($pobj,toggle)   Off
      } else {
      set param::string::($pobj,toggle)   ""
     }
     set param::string::($pobj,ui_label) \
     $udeEditor::uiText::($uiobj,ui_label)
    }
    udeEditor::uiBoolean {
     set pobj $udeEditor::uiBoolean::($uiobj,param_obj)
     set param::boolean::($pobj,name) \
     $udeEditor::uiBoolean::($uiobj,name)
     set param::boolean::($pobj,type) b
     set toggle_v $udeEditor::uiBoolean::($uiobj,toggle_v)
     if {$toggle_v == 1} {
      set param::boolean::($pobj,default)   TRUE
      } else {
      set param::boolean::($pobj,default)   FALSE
     }
     set param::boolean::($pobj,ui_label) \
     $udeEditor::uiBoolean::($uiobj,ui_label)
    }
    udeEditor::uiOption  {
     set pobj $udeEditor::uiOption::($uiobj,param_obj)
     set param::option::($pobj,name) \
     $udeEditor::uiOption::($uiobj,name)
     set param::option::($pobj,type) o
     set param::option::($pobj,default)   \
     $udeEditor::uiOption::($uiobj,cur_opt)
     set opt_string [join $udeEditor::uiOption::($uiobj,opt_list) ,]
     set param::option::($pobj,options) $opt_string
     set toggle_v $udeEditor::uiOption::($uiobj,toggle_v)
     if {$toggle_v == 1} {
      set param::option::($pobj,toggle)   On
      } elseif {$toggle_v == 0} {
      set param::option::($pobj,toggle)   Off
      } else {
      set param::option::($pobj,toggle)   ""
     }
     set param::option::($pobj,ui_label) \
     $udeEditor::uiOption::($uiobj,ui_label)
    }
    udeEditor::uiPoint   {
     set pobj $udeEditor::uiPoint::($uiobj,param_obj)
     set param::point::($pobj,name) \
     $udeEditor::uiPoint::($uiobj,name)
     set param::point::($pobj,type) p
     set toggle_v $udeEditor::uiPoint::($uiobj,toggle_v)
     if {$toggle_v == 1} {
      set param::point::($pobj,toggle)   On
      } elseif {$toggle_v == 0} {
      set param::point::($pobj,toggle)   Off
      } else {
      set param::point::($pobj,toggle)   ""
     }
     set param::point::($pobj,ui_label) \
     $udeEditor::uiPoint::($uiobj,ui_label)
    }
    udeEditor::uiBitmap  {
     set pobj $udeEditor::uiBitmap::($uiobj,param_obj)
     set param::bitmap::($pobj,name) \
     $udeEditor::uiBitmap::($uiobj,name)
     set param::bitmap::($pobj,type) l
     set param::bitmap::($pobj,default)   \
     $udeEditor::uiBitmap::($uiobj,value)
    }
    udeEditor::uiGroup   {
     set pobj $udeEditor::uiGroup::($uiobj,param_obj)
     set param::group::($pobj,name) \
     $udeEditor::uiGroup::($uiobj,name)
     set param::group::($pobj,type) g
     set param::group::($pobj,default)   \
     $udeEditor::uiGroup::($uiobj,value)
     set param::group::($pobj,ui_label) \
     $udeEditor::uiGroup::($uiobj,ui_label)
    }
    udeEditor::uiVector  {
     set pobj $udeEditor::uiVector::($uiobj,param_obj)
     set param::vector::($pobj,name) \
     $udeEditor::uiVector::($uiobj,name)
     set param::vector::($pobj,type) v
     set toggle_v $udeEditor::uiVector::($uiobj,toggle_v)
     if {$toggle_v == 1} {
      set param::vector::($pobj,toggle)   On
      } elseif {$toggle_v == 0} {
      set param::vector::($pobj,toggle)   Off
      } else {
      set param::vector::($pobj,toggle)   ""
     }
     set param::vector::($pobj,ui_label) \
     $udeEditor::uiVector::($uiobj,ui_label)
    }
   }
   lappend temp_param_obj_list $pobj
  }
  if {$udeEditor::($OBJ,TYPE) == "UDE"} {
   set udeobj $Post::($post_object,ude_obj)
   set seqobj $ude::($udeobj,seq_obj)
   set non_mc_evt_obj_list $sequence::($seqobj,evt_obj_list)
   set is_non_mc_evt 1
   set evt_obj $udeEditor::(event_obj)
   if {[lsearch $non_mc_evt_obj_list $evt_obj] < "0"} {
    set is_non_mc_evt 0
   }
   set ude_event::($udeevent,param_obj_list) $temp_param_obj_list
   set ude_event::($udeevent,name) $udeEditor::($OBJ,ueo_name)
   set ude_event::($udeevent,post_event) $udeEditor::($OBJ,ueo_post_event)
   set ude_event::($udeevent,ui_label) $udeEditor::($OBJ,ueo_ui_label)
   set ude_event::($udeevent,category) $udeEditor::($OBJ,ueo_category)
   set ude_event::($udeevent,help_descript) $udeEditor::($OBJ,ueo_help_descript)
   set ude_event::($udeevent,help_url)   $udeEditor::($OBJ,ueo_help_url)
   set bot_canvas [winfo parent $udeEditor::(main_widget)]
   set text_id $event::($evt_obj,text_id)
   if {$ude_event::($udeevent,post_event) == ""} {
    set handler_name MOM_$ude_event::($udeevent,name)
    } else {
    set handler_name MOM_$ude_event::($udeevent,post_event)
   }
   if {[lsearch $gPB(MOM_func,SYS) $handler_name] < 0} {
    lappend gPB(MOM_func,SYS) $handler_name
   }
   if {$ude_event::($udeevent,ui_label) == ""} {
    set event_label $ude_event::($udeevent,name)
    } else {
    set event_label $ude_event::($udeevent,ui_label)
   }
   set event_label [__evt_FitLabelWidth $event_label]
   if { $is_non_mc_evt == 1 } {
    $bot_canvas itemconfig $text_id -text $event_label
   }
   set event::($evt_obj,event_ude_name) $ude_event::($udeevent,name)
   if {$is_non_mc_evt == 1} {
    set event::($evt_obj,event_name) $ude_event::($udeevent,name)
    if {$ude_event::($udeevent,ui_label) == ""} {
     set event::($evt_obj,event_label) $ude_event::($udeevent,name)
     } else {
     set event::($evt_obj,event_label) $ude_event::($udeevent,ui_label)
    }
   }
   } else {
   if {[lsearch $gPB(SYS_CYCLE) $cycle_event::($udeevent,name)] >= 0} {
    set cycle_event::($udeevent,param_obj_list) $temp_param_obj_list
    return TRUE
   }
   set cycle_event::($udeevent,param_obj_list) $temp_param_obj_list
   set cycle_event::($udeevent,name)           $udeEditor::($OBJ,ueo_name)
   set cycle_event::($udeevent,ui_label)       $udeEditor::($OBJ,ueo_ui_label)
   set cycle_event::($udeevent,is_sys_cycle)   $udeEditor::($OBJ,ueo_is_sys_cycle)
   if $gPB(enable_helpdesc_for_udc) {
    set cycle_event::($udeevent,help_descript) $udeEditor::($OBJ,ueo_help_descript)
    set cycle_event::($udeevent,help_url)   $udeEditor::($OBJ,ueo_help_url)
   }
   set bot_canvas [winfo parent $udeEditor::(main_widget)]
   set evt_obj $udeEditor::(event_obj)
   set text_id $event::($evt_obj,text_id)
   if { $cycle_event::($udeevent,ui_label) == "" } {
    set event_label $cycle_event::($udeevent,name)
    } else {
    set event_label $cycle_event::($udeevent,ui_label)
   }
   set event_label [__evt_FitLabelWidth $event_label]
   $bot_canvas itemconfig $text_id -text $event_label
   set event::($evt_obj,event_ude_name) "CYCLE_EVENT"
   set event::($evt_obj,event_name) $cycle_event::($udeevent,name)
   if {$cycle_event::($udeevent,ui_label) == ""} {
    set event::($evt_obj,event_label) $cycle_event::($udeevent,name)
    } else {
    set event::($evt_obj,event_label) $cycle_event::($udeevent,ui_label)
   }
   set event_elem_list $event::($evt_obj,evt_elem_list)
   foreach one $event_elem_list {
    set block_obj $event_element::($one,block_obj)
    set block::($block_obj,blk_owner) $cycle_event::($udeevent,name)
    foreach block_elem_obj $block::($block_obj,elem_addr_list) {
     set block_element::($block_elem_obj,owner) $cycle_event::($udeevent,name)
    }
   }
   if {$udeEditor::($OBJ,restore_ueo_is_sys_cycle) == 1} {
    if {$cycle_event::($udeevent,is_sys_cycle) == 0} {
     set page_obj $udeEditor::($OBJ,page_obj)
     set seq_obj $udeEditor::($OBJ,seq_obj)
     UI_PB_tpth_DeleteTpthBlock page_obj evt_obj
     UI_PB_ude_DeleteBlks $evt_obj
     UI_PB_cycle_MakeCopyFromCommonParam  $evt_obj
     __tpth_UpdateSequenceEvent page_obj seq_obj evt_obj
     update idletasks
    }
    } else {
    if {$cycle_event::($udeevent,is_sys_cycle) == 1} {
     set page_obj $udeEditor::($OBJ,page_obj)
     set seq_obj $udeEditor::($OBJ,seq_obj)
     UI_PB_tpth_DeleteTpthBlock page_obj evt_obj
     UI_PB_ude_DeleteBlks $evt_obj
     set event::($evt_obj,evt_elem_list) [list]
     set event::($evt_obj,rest_value) ""
     __tpth_UpdateSequenceEvent page_obj seq_obj evt_obj
     update idletasks
    }
   }
  }
  if {$udeEditor::($OBJ,isNewer) == 1} {
   set udeEditor::($OBJ,isNewer) 0
  }
  return TRUE
 }

#=======================================================================
proc UI_PB_ude_OK {} {
  set result [UI_PB_ude_Apply]
  if {$result == "TRUE"} {
   destroy $udeEditor::(main_widget)
  }
 }

#=======================================================================
proc UI_PB_ude_Cancel {} {
  set OBJ $udeEditor::(obj)
  set isNewer $udeEditor::($OBJ,isNewer)
  if {$isNewer == 1} {
   set type $udeEditor::($OBJ,TYPE)
   set canvas_id [winfo parent $udeEditor::(main_widget)]
   set page_obj $udeEditor::($OBJ,page_obj)
   set seq_obj $udeEditor::($OBJ,seq_obj)
   set event_obj $udeEditor::(event_obj)
  }
  destroy $udeEditor::(main_widget)
  if {$isNewer == 1} {
   switch -exact $type {
    UDE {
     UI_PB_ude_DeleteEvent $canvas_id $page_obj $seq_obj $event_obj
    }
    UDC {
     UI_PB_cycle_DeleteEvent $canvas_id $page_obj $seq_obj $event_obj
    }
   }
  }
 }

#=======================================================================
proc UI_PB_ude_CreateTypeAndTrashItems {lf} {
  set topframe [frame $lf.f -bg $udeEditor::($udeEditor::(obj),left_bg) \
  -width 150 -height 200]
  set bottomcanvas [canvas $lf.c -width 150 -height 150 \
  -scrollregion [list 0 0 150 150] \
  -bg $udeEditor::($udeEditor::(obj),left_bg) \
  -highlightt 0]
  pack $bottomcanvas  -side bottom -fill x -expand yes -anchor sw
  pack $topframe -side top -fill both -expand yes -pady 20
  set udeEditor::($udeEditor::(obj),trash_canvas) $bottomcanvas
  set w_h $udeEditor::($udeEditor::(obj),req_w_h)
  set udeEditor::($udeEditor::(obj),left_panel_width) [expr [lindex $w_h 0] + 80]
  set type_list [list Integer Real Text Boolean Option Point Vector Bitmap Group]
  foreach type $type_list {
   UI_PB_ude_CreateTypeWidget $topframe $type $w_h
  }
  UI_PB_ude_CreateTrashBox $bottomcanvas
 }

#=======================================================================
proc UI_PB_ude_CreateDummyTypeWidget { } {
  global gPB
  set default_width 40
  set default_height 28
  set typeframe [frame .int -relief raised -bd 3 \
  -highlightt 1]
  set typelabel [label $typeframe.l \
  -anchor center -font $gPB(bold_font) \
  -text $gPB(ude,editor,int,Label)]
  pack $typelabel -side left -padx 20
  pack $typeframe -pady 2 -padx 40
  set typeframe [frame .real -relief raised -bd 3 \
  -highlightt 1]
  set typelabel [label $typeframe.l  \
  -anchor center -font $gPB(bold_font) \
  -text $gPB(ude,editor,real,Label)]
  pack $typelabel -side left -padx 20
  pack $typeframe -pady 2 -padx 40
  set typeframe [frame .txt -relief raised -bd 3 \
  -highlightt 1]
  set typelabel [label $typeframe.l \
  -anchor center -font $gPB(bold_font) \
  -text $gPB(ude,editor,txt,Label)]
  pack $typelabel -side left -padx 20
  pack $typeframe -pady 2 -padx 40
  set typeframe [frame .bln -relief raised -bd 3 \
  -highlightt 1]
  set typelabel [label $typeframe.l \
  -anchor center -font $gPB(bold_font) \
  -text $gPB(ude,editor,bln,Label) ]
  set typesubframe [frame $typeframe.sf -bd 2 -width 13 \
  -height 13 -relief sunken -bg orange]
  pack $typesubframe -side left -padx 2
  pack $typelabel -anchor w -padx 4
  pack $typeframe -pady 2 -padx 40
  set typeframe [frame .opt -relief raised -bd 3 \
  -highlightt 1]
  set typelabel [label $typeframe.l \
  -anchor center -font $gPB(bold_font) \
  -text $gPB(ude,editor,opt,Label) ]
  set typesubframe [frame $typeframe.sf -bd 2 -width 13 \
  -height 8 -relief raised ]
  pack $typesubframe -side left -padx 2
  pack $typelabel -anchor w -padx 4
  pack $typeframe -pady 2 -padx 40
  set typeframe [frame .pnt -relief raised -bd 3 \
  -highlightt 1 ]
  set typelabel [label $typeframe.l \
  -anchor center -font $gPB(bold_font) \
  -text $gPB(ude,editor,pnt,Label) ]
  pack $typelabel -side left -padx 20
  pack $typeframe -pady 2 -padx 40
  update
  set widgets [list .int .pnt .opt .txt .bln .real]
  foreach one $widgets {
   if {[winfo reqwidth $one] > $default_width} {
    set default_width [winfo reqwidth $one]
   }
   if {[winfo reqheight $one] > $default_height} {
    set default_height [winfo reqheight $one]
   }
   destroy $one
  }
  return [list $default_width $default_height]
 }

#=======================================================================
proc UI_PB_ude_CreateTypeWidget {pw type w_h} {
  global gPB
  set OBJ $udeEditor::(obj)
  set w [lindex $w_h 0]
  set h [lindex $w_h 1]
  switch -exact $type {
   Integer {
    set typeframe [frame $pw.int -relief raised -bd 3 \
    -cursor hand2 -highlightt 1 -width $w -height $h \
    -highlightb $udeEditor::($OBJ,type_hl_bg) \
    -bg $udeEditor::($OBJ,type_bg)]
    set typelabel [label $typeframe.l \
    -bg $udeEditor::($OBJ,type_bg) \
    -fg $udeEditor::($OBJ,type_fg) \
    -anchor center -font $gPB(bold_font) \
    -text $gPB(ude,editor,int,Label)]
    if ![string compare $::tix_version 8.4] {
     pack $typelabel -side left -padx 20
     } else {
     pack $typelabel -pady 4 -padx 20 -side left
    }
    pack propagate $typeframe 0
    pack $typeframe -pady 2 -padx 40
    UI_PB_ude_TypeWidgetBinding $typeframe $type
    set gPB(c_help,$typeframe) "ude,editor,int"
   }
   Real    {
    set typeframe [frame $pw.real -relief raised -bd 3 \
    -cursor hand2 -bg $udeEditor::($OBJ,type_bg) \
    -highlightt 1 -width $w -height $h \
    -highlightb $udeEditor::($OBJ,type_hl_bg)]
    set typelabel [label $typeframe.l  \
    -bg $udeEditor::($OBJ,type_bg) \
    -fg $udeEditor::($OBJ,type_fg) \
    -anchor center -font $gPB(bold_font) \
    -text $gPB(ude,editor,real,Label)]
    if ![string compare $::tix_version 8.4] {
     pack $typelabel -side left -padx 20
     } else {
     pack $typelabel -pady 4 -side left -padx 20
    }
    pack propagate $typeframe 0
    pack $typeframe -pady 2 -padx 40
    UI_PB_ude_TypeWidgetBinding $typeframe $type
    set gPB(c_help,$typeframe) "ude,editor,real"
   }
   Text    {
    set typeframe [frame $pw.txt -relief raised -bd 3 \
    -cursor hand2 -bg $udeEditor::($OBJ,type_bg) \
    -highlightt 1 -width $w -height $h \
    -highlightb $udeEditor::($OBJ,type_hl_bg)]
    set typelabel [label $typeframe.l \
    -bg $udeEditor::($OBJ,type_bg) \
    -fg $udeEditor::($OBJ,type_fg) \
    -anchor center -font $gPB(bold_font) \
    -text $gPB(ude,editor,txt,Label)]
    if ![string compare $::tix_version 8.4] {
     pack $typelabel -side left -padx 20
     } else {
     pack $typelabel -pady 4 -padx 20 -side left
    }
    pack propagate $typeframe 0
    pack $typeframe -pady 2 -padx 40
    UI_PB_ude_TypeWidgetBinding $typeframe $type
    set gPB(c_help,$typeframe) "ude,editor,txt"
   }
   Boolean {
    set typeframe [frame $pw.bln -relief raised -bd 3 \
    -cursor hand2 -bg $udeEditor::($OBJ,type_bg) \
    -highlightt 1 -width $w -height $h \
    -highlightb $udeEditor::($OBJ,type_hl_bg)]
    set typelabel [label $typeframe.l \
    -bg $udeEditor::($OBJ,type_bg) \
    -fg $udeEditor::($OBJ,type_fg) \
    -anchor center -font $gPB(bold_font) \
    -text $gPB(ude,editor,bln,Label) ]
    set typesubframe [frame $typeframe.sf -bd 2 -width 12 \
    -height 12 -relief sunken -bg orange]
    if ![string compare $::tix_version 8.4] {
     pack $typesubframe -side left -padx 2
     pack $typelabel -anchor w -padx 4
     } else {
     pack $typesubframe -side left -padx 2
     pack $typelabel -anchor w -padx 4 -pady 4
    }
    pack propagate $typeframe 0
    pack $typeframe -pady 2 -padx 40
    UI_PB_ude_TypeWidgetBinding $typeframe $type
    set gPB(c_help,$typeframe) "ude,editor,bln"
   }
   Option  {
    set typeframe [frame $pw.opt -relief raised -bd 3 \
    -cursor hand2   -bg $udeEditor::($OBJ,type_bg) \
    -highlightt 1 -width $w -height $h \
    -highlightb $udeEditor::($OBJ,type_hl_bg)]
    set typelabel [label $typeframe.l \
    -bg $udeEditor::($OBJ,type_bg) \
    -fg $udeEditor::($OBJ,type_fg) \
    -anchor center -font $gPB(bold_font) \
    -text $gPB(ude,editor,opt,Label) ]
    set typesubframe [frame $typeframe.sf -bd 2 -width 12 \
    -height 8 -relief raised \
    -bg $udeEditor::($OBJ,type_bg)]
    if ![string compare $::tix_version 8.4] {
     pack $typesubframe -side left -padx 2
     pack $typelabel -anchor w -padx 4
     } else {
     pack $typesubframe -side left -padx 2
     pack $typelabel -anchor w -padx 4 -pady 4
    }
    pack propagate $typeframe 0
    pack $typeframe -pady 2 -padx 40
    UI_PB_ude_TypeWidgetBinding $typeframe $type
    set gPB(c_help,$typeframe) "ude,editor,opt"
   }
   Point   {
    set typeframe [frame $pw.pnt -relief raised -bd 3 \
    -cursor hand2 -bg $udeEditor::($OBJ,type_bg) \
    -highlightt 1 -width $w -height $h \
    -highlightb $udeEditor::($OBJ,type_hl_bg)]
    set typelabel [label $typeframe.l \
    -bg $udeEditor::($OBJ,type_bg) \
    -fg $udeEditor::($OBJ,type_fg) \
    -anchor center -font $gPB(bold_font) \
    -text $gPB(ude,editor,pnt,Label)]
    if ![string compare $::tix_version 8.4] {
     pack $typelabel -side left -padx 20
     } else {
     pack $typelabel -side left -padx 20 -pady 4
    }
    pack propagate $typeframe 0
    pack $typeframe -pady 2 -padx 40
    UI_PB_ude_TypeWidgetBinding $typeframe $type
    set gPB(c_help,$typeframe) "ude,editor,pnt"
   }
   Bitmap  {
    set typeframe [frame $pw.bmp -relief raised -bd 3 \
    -cursor hand2 -bg $udeEditor::($OBJ,type_bg) \
    -highlightt 1 -width $w -height $h \
    -highlightb $udeEditor::($OBJ,type_hl_bg)]
    set typelabel [label $typeframe.l \
    -bg $udeEditor::($OBJ,type_bg) \
    -fg $udeEditor::($OBJ,type_fg) \
    -anchor center -font $gPB(bold_font) \
    -text $gPB(ude,editor,bmp,Label)]
    if ![string compare $::tix_version 8.4] {
     pack $typelabel -side left -padx 20
     } else {
     pack $typelabel -side left -padx 20 -pady 4
    }
    pack propagate $typeframe 0
    pack $typeframe -pady 2 -padx 40
    UI_PB_ude_TypeWidgetBinding $typeframe $type
    set udeEditor::($OBJ,bitmap_widget) $typeframe
    set gPB(c_help,$typeframe) "ude,editor,bmp"
   }
   Group   {
    set typeframe [frame $pw.grp -relief raised -bd 3 \
    -cursor hand2   -bg $udeEditor::($OBJ,type_bg) \
    -highlightt 1 -width $w -height $h \
    -highlightb $udeEditor::($OBJ,type_hl_bg)]
    set typelabel [label $typeframe.l \
    -bg $udeEditor::($OBJ,type_bg) \
    -fg $udeEditor::($OBJ,type_fg) \
    -anchor center -font $gPB(bold_font) \
    -text $gPB(ude,editor,group,Label)]
    if ![string compare $::tix_version 8.4] {
     pack $typelabel -side left -padx 20
     } else {
     pack $typelabel -side left -padx 20 -pady 4
    }
    pack propagate $typeframe 0
    pack $typeframe -pady 2 -padx 40
    UI_PB_ude_TypeWidgetBinding $typeframe $type
    set gPB(c_help,$typeframe) "ude,editor,group"
   }
   Vector  {
    set typeframe [frame $pw.vec -relief raised -bd 3 \
    -cursor hand2 -bg $udeEditor::($OBJ,type_bg) \
    -highlightt 1 -width $w -height $h \
    -highlightb $udeEditor::($OBJ,type_hl_bg)]
    set typelabel [label $typeframe.l \
    -bg $udeEditor::($OBJ,type_bg) \
    -fg $udeEditor::($OBJ,type_fg) \
    -anchor center -font $gPB(bold_font) \
    -text $gPB(ude,editor,vector,Label)]
    if ![string compare $::tix_version 8.4] {
     pack $typelabel -side left -padx 20
     } else {
     pack $typelabel -side left -padx 20 -pady 4
    }
    pack propagate $typeframe 0
    pack $typeframe -pady 2 -padx 40
    UI_PB_ude_TypeWidgetBinding $typeframe $type
    set gPB(c_help,$typeframe) "ude,editor,vector"
   }
  }
 }

#=======================================================================
proc UI_PB_ude_CreateUdeDialog {w} {
  global gPB
  set OBJ $udeEditor::(obj)
  set topframe [frame $w.top -bg $udeEditor::($OBJ,dialog_bg) \
  -width 200 -height 10]
  set midframe [frame $w.mid -bg $udeEditor::($OBJ,dock_bg) \
  -width 200 -height 5]
  set botframe [frame $w.bottom -bg $udeEditor::($OBJ,dialog_bg) \
  -bd 2 -width 200 -height 40]
  set udeEditor::($OBJ,midframe) $midframe
  set lbl_txt [list $gPB(nav_button,ok,Label) $gPB(ude,editor,dlg,bck,Label) \
  $gPB(nav_button,cancel,Label)]
  label .dummy_label
  set req_w 0
  set req_h 0
  foreach one $lbl_txt {
   .dummy_label config -text $one -font $gPB(bold_font)
   set width [winfo reqwidth .dummy_label]
   set height [winfo reqheight .dummy_label]
   if {$width > $req_w} {
    set req_w $width
   }
   if {$height > $req_h} {
    set req_h $height
   }
  }
  destroy .dummy_label
  global paOption
  frame $botframe.f1 -width [expr $req_w + 10] -height [expr $req_h + 4]
  set btn_ok [label $botframe.f1.ok -text $gPB(nav_button,ok,Label) -bd 2 \
  -anchor center -relief raised  \
  -takefocus 0 -font $gPB(bold_font) \
  -fg $paOption(disabled_fg)]
  frame $botframe.f2 -width [expr $req_w + 10] -height [expr $req_h + 4]
  set btn_bck [label $botframe.f2.bck -text $gPB(ude,editor,dlg,bck,Label) \
  -bd 2 -anchor center -relief raised \
  -takefocus 0 -font $gPB(bold_font) \
  -fg $paOption(disabled_fg)]
  frame $botframe.f3 -width [expr $req_w + 10] -height [expr $req_h + 4]
  set btn_cnl [label $botframe.f3.cnl -text $gPB(nav_button,cancel,Label) \
  -bd 2 -anchor center -relief raised \
  -takefocus 0 -font $gPB(bold_font) \
  -fg $paOption(disabled_fg)]
  pack propagate $botframe.f1 0
  pack propagate $botframe.f2 0
  pack propagate $botframe.f3 0
  pack $botframe.f3 $botframe.f2 $botframe.f1 -side right \
  -padx 5 -expand no \
  -fill x -pady 3
  pack $btn_ok  -expand yes -fill both
  pack $btn_cnl -expand yes -fill both
  pack $btn_bck -expand yes -fill both
  if { $udeEditor::($OBJ,TYPE) == "UDE" || $gPB(enable_helpdesc_for_udc) } {
   set hlpframe [frame $w.help -bg $udeEditor::($OBJ,dialog_bg) \
   -width 200 -height 10]
   set udeEditor::($OBJ,hlpframe) $hlpframe
  }
  pack $w.top $w.mid $w.bottom -side top -pady 1 -expand yes -fill x
  set flag EDIT  ;# flag is a temp variable
  switch -exact $flag {
   NEW  {
    UI_PB_ude_CreateDlgForNewUde $topframe $midframe
    udeEditor::InitPositionList $OBJ ;#maybe some problems here
   }
   EDIT {
    set udeeventobj $udeEditor::(ude_event_obj)
    UI_PB_ude_CreateDlgForEditUde $topframe $midframe $udeeventobj
    udeEditor::InitPositionList $OBJ
   }
  }
 }

#=======================================================================
proc UI_PB_ude_GetUdeEventObj { event_obj } {
  global post_object
  set ude_obj             $Post::($post_object,ude_obj)
  set ude_event_obj_list  $ude::($ude_obj,event_obj_list)
  set event_name $event::($event_obj,event_ude_name)
  if { $event_name != "CYCLE_EVENT" } {
   foreach ude_event_obj $ude_event_obj_list {
    if ![string compare $ude_event::($ude_event_obj,name) $event_name] {
     return $ude_event_obj
    }
   }
   return NULL
   } else {
   set cyc_event_obj $event::($event_obj,cyc_evt_obj)
   return $cyc_event_obj
  }
 }

#=======================================================================
proc UI_PB_ude_CreateDlgForNewUde {topframe midframe} {
  global udename ;#udename is a temp variable
  set udename "new_ude"
  set udeNameEntry [entry $topframe.ety -textvariable udename \
  -justify center -width 15]
  pack $udeNameEntry -pady 10
  UI_PB_ude_AddItems 5
 }

#=======================================================================
proc UI_PB_ude_AddItems {param_obj {num "NULL"}} {
   set isPtc 0
   set isPtc [UI_PB_ude_IsProtected $param_obj]
   set w [UI_PB_ude_CreateItems $isPtc $num]
   if {$isPtc == 1} {
    $w config -bg $udeEditor::($udeEditor::(obj),bg_for_mce)
   }
   set type [UI_PB_ude_GetParamType $param_obj]
   switch -exact $type {
    Integer {
     UI_PB_ude_CreateIntegerItem $w $param_obj $isPtc
    }
    Real    {
     UI_PB_ude_CreateRealItem $w $param_obj $isPtc
    }
    Text    {
     UI_PB_ude_CreateTextItem $w $param_obj $isPtc
    }
    Boolean {
     UI_PB_ude_CreateBooleanItem $w $param_obj $isPtc
    }
    Option  {
     UI_PB_ude_CreateOptionItem $w $param_obj $isPtc
    }
    Point   {
     UI_PB_ude_CreatePointItem $w $param_obj $isPtc
    }
    Bitmap  {
     UI_PB_ude_CreateBitmapItem $w $param_obj $isPtc
    }
    Group   {
     if {$isPtc == 0} {
      $w config -bg $udeEditor::($udeEditor::(obj),groupitem_bg)
     }
     UI_PB_ude_CreateGroupItem $w $param_obj $isPtc
    }
    Vector  {
     UI_PB_ude_CreateVectorItem $w $param_obj $isPtc
    }
   }
  }

#=======================================================================
proc UI_PB_ude_CreateIntegerItem { w param_obj isPtc } {
  set obj [udeEditor::CreateItemObj $udeEditor::(obj) Integer]
  lappend udeEditor::($udeEditor::(obj),sub_objs) $obj
  set udeEditor::uiInteger::($obj,param_obj) $param_obj
  set udeEditor::uiInteger::($obj,name) $param::integer::($param_obj,name)
  if ![string compare $param::integer::($param_obj,ui_label) ""] {
   set udeEditor::uiInteger::($obj,ui_label) \
   $param::integer::($param_obj,name)
   } else {
   set udeEditor::uiInteger::($obj,ui_label) \
   $param::integer::($param_obj,ui_label)
  }
  set udeEditor::uiInteger::($obj,value)  \
  $param::integer::($param_obj,default)
  if [string match $param::integer::($param_obj,toggle) "On"] {
   set udeEditor::uiInteger::($obj,toggle_v) 1
   } elseif [string match $param::integer::($param_obj,toggle) "Off"] {
   set udeEditor::uiInteger::($obj,toggle_v) 0
   } else {
   set udeEditor::uiInteger::($obj,toggle_v) -1
  }
  set udeEditor::uiInteger::($obj,pathname) $w
  set tfrm [frame $w.top]
  set bfrm [frame $w.btm]
  set OBJ $udeEditor::(obj)
  set ic [checkbutton $tfrm.c -bd $udeEditor::($OBJ,bd_value) -highlightt 0 \
  -variable udeEditor::uiInteger::($obj,toggle_v) \
  -command "UI_PB_ude_ShiftBuddyState $obj" ]
  set il [label $bfrm.l -textvariable udeEditor::uiInteger::($obj,ui_label) \
  -fg $udeEditor::($OBJ,item_fg)]
  set ie [entry $bfrm.e -width 6 -textvariable udeEditor::uiInteger::($obj,value)]
  set is [label $tfrm.s -textvariable udeEditor::uiInteger::($obj,ui_label) \
  -fg $udeEditor::($OBJ,item_fg)]
  set is2 [label $tfrm.s2 -text " Status" \
  -fg $udeEditor::($OBJ,item_fg)]
  if {$isPtc == 1} {
   $ic config -bg $udeEditor::($OBJ,bg_for_mce) \
   -activebackground $udeEditor::($OBJ,bg_for_mce)
   $il config -bg $udeEditor::($OBJ,bg_for_mce)
   $tfrm config -bg $udeEditor::($OBJ,bg_for_mce)
   $bfrm config -bg $udeEditor::($OBJ,bg_for_mce)
   $is   config -bg $udeEditor::($OBJ,bg_for_mce)
   $is2  config -bg $udeEditor::($OBJ,bg_for_mce)
   } else {
   $ic config -bg $udeEditor::($OBJ,bg_for_non_mce) \
   -activebackground $udeEditor::($OBJ,bg_for_non_mce)
   $il config -bg $udeEditor::($OBJ,bg_for_non_mce)
   $tfrm config -bg $udeEditor::($OBJ,bg_for_non_mce)
   $bfrm config -bg $udeEditor::($OBJ,bg_for_non_mce)
   $is   config -bg $udeEditor::($OBJ,bg_for_non_mce)
   $is2  config -bg $udeEditor::($OBJ,bg_for_non_mce)
  }
  bind $ie <KeyPress> "UI_PB_com_ValidateDataOfEntry %W %K i 1"
  bind $ie <KeyRelease> {%W config -state normal ;set ::gPB(prev_key) ""}
  lappend udeEditor::uiInteger::($obj,buddy_path) $ie
  if {$udeEditor::uiInteger::($obj,toggle_v) == 0} {
   if ![string compare $::tix_version 8.4] {
    $ie config -state disabled
    } else {
    $ie config -state disabled -bg lightblue
   }
  }
  if {$udeEditor::($OBJ,TYPE) == "UDC" && \
   $isPtc == 1} {
   if ![string compare $::tix_version 8.4] {
    $ie config -state disabled
    } else {
    $ie config -state disabled -bg lightblue
   }
   $ic config -state disabled
  }
  bind $tfrm <Button-1>  {event generate [winfo parent %W] \
  <Button-1> -rootx %X -rooty %Y}
  bind $tfrm <B1-Motion> {event generate [winfo parent %W] \
  <B1-Motion> -rootx %X -rooty %Y}
  bind $tfrm <ButtonRelease-1> {event generate [winfo parent %W] \
  <ButtonRelease-1>}
  bind $tfrm <Button-3> {event generate [winfo parent %W] \
  <Button-3> -rootx %X -rooty %Y}
  bind $bfrm <Button-1>  {event generate [winfo parent %W] \
  <Button-1> -rootx %X -rooty %Y}
  bind $bfrm <B1-Motion> {event generate [winfo parent %W] \
  <B1-Motion> -rootx %X -rooty %Y}
  bind $bfrm <ButtonRelease-1> {event generate [winfo parent %W] \
  <ButtonRelease-1>}
  bind $bfrm <Button-3> {event generate [winfo parent %W] \
  <Button-3> -rootx %X -rooty %Y}
  bind $il <Button-1>  {event generate [winfo parent [winfo parent %W]] \
  <Button-1> -rootx %X -rooty %Y}
  bind $il <B1-Motion> {event generate [winfo parent [winfo parent %W]] \
  <B1-Motion> -rootx %X -rooty %Y}
  bind $il <ButtonRelease-1> {event generate [winfo parent [winfo parent %W]] \
  <ButtonRelease-1>}
  bind $il <Button-3> {event generate [winfo parent [winfo parent %W]] \
  <Button-3> -rootx %X -rooty %Y}
  bind $is <Button-1>  {event generate [winfo parent [winfo parent %W]] \
  <Button-1> -rootx %X -rooty %Y}
  bind $is <B1-Motion> {event generate [winfo parent [winfo parent %W]] \
  <B1-Motion> -rootx %X -rooty %Y}
  bind $is <ButtonRelease-1> {event generate [winfo parent [winfo parent %W]] \
  <ButtonRelease-1>}
  bind $is <Button-3> {event generate [winfo parent [winfo parent %W]] \
  <Button-3> -rootx %X -rooty %Y}
  bind $is2 <Button-1>  {event generate [winfo parent [winfo parent %W]] \
  <Button-1> -rootx %X -rooty %Y}
  bind $is2 <B1-Motion> {event generate [winfo parent [winfo parent %W]] \
  <B1-Motion> -rootx %X -rooty %Y}
  bind $is2 <ButtonRelease-1> {event generate [winfo parent [winfo parent %W]] \
  <ButtonRelease-1>}
  bind $is2 <Button-3> {event generate [winfo parent [winfo parent %W]] \
  <Button-3> -rootx %X -rooty %Y}
  if {$udeEditor::uiInteger::($obj,toggle_v) != -1} {
   pack $ic $is $is2 -side left
   pack $tfrm -side top -anchor w -padx 2
  }
  pack $bfrm -side top -anchor w -fill x -padx 2
  pack $il -side left -padx 0
  pack $ie -side right -padx 5 -pady 5 -fill x -expand 1
 }

#=======================================================================
proc UI_PB_ude_CreateRealItem { w param_obj isPtc } {
  set obj [udeEditor::CreateItemObj $udeEditor::(obj) Real]
  lappend udeEditor::($udeEditor::(obj),sub_objs) $obj
  set udeEditor::uiReal::($obj,param_obj) $param_obj
  set udeEditor::uiReal::($obj,name) $param::double::($param_obj,name)
  if ![string compare $param::double::($param_obj,ui_label) ""] {
   set udeEditor::uiReal::($obj,ui_label) \
   $param::double::($param_obj,name)
   } else {
   set udeEditor::uiReal::($obj,ui_label) \
   $param::double::($param_obj,ui_label)
  }
  set udeEditor::uiReal::($obj,value)    \
  $param::double::($param_obj,default)
  if [string match $param::double::($param_obj,toggle) "On"] {
   set udeEditor::uiReal::($obj,toggle_v) 1
   } elseif [string match $param::double::($param_obj,toggle) "Off"] {
   set udeEditor::uiReal::($obj,toggle_v) 0
   } else {
   set udeEditor::uiReal::($obj,toggle_v) -1
  }
  set udeEditor::uiReal::($obj,pathname) $w
  set tfrm [frame $w.top]
  set bfrm [frame $w.btm]
  set OBJ $udeEditor::(obj)
  set rc [checkbutton $tfrm.c -bd $udeEditor::($OBJ,bd_value) -highlightt 0 \
  -variable udeEditor::uiReal::($obj,toggle_v) \
  -command "UI_PB_ude_ShiftBuddyState $obj"]
  set rl [label $bfrm.l -textvariable udeEditor::uiReal::($obj,ui_label) \
  -fg $udeEditor::($OBJ,item_fg)]
  set re [entry $bfrm.e -width 6 -textvariable udeEditor::uiReal::($obj,value)]
  set rs [label $tfrm.s -textvariable udeEditor::uiReal::($obj,ui_label) \
  -fg $udeEditor::($OBJ,item_fg)]
  set rs2 [label $tfrm.s2 -text " Status" \
  -fg $udeEditor::($OBJ,item_fg)]
  bind $re <KeyPress> "UI_PB_com_ValidateDataOfEntry %W %K f 1"
  bind $re <KeyRelease> {%W config -state normal ;set ::gPB(prev_key) ""}
  if {$isPtc == 1} {
   $rc config -bg $udeEditor::($OBJ,bg_for_mce) \
   -activebackground $udeEditor::($OBJ,bg_for_mce)
   $rl config -bg $udeEditor::($OBJ,bg_for_mce)
   $tfrm config -bg $udeEditor::($OBJ,bg_for_mce)
   $bfrm config -bg $udeEditor::($OBJ,bg_for_mce)
   $rs   config -bg $udeEditor::($OBJ,bg_for_mce)
   $rs2  config -bg $udeEditor::($OBJ,bg_for_mce)
   } else {
   $rc config -bg $udeEditor::($OBJ,bg_for_non_mce) \
   -activebackground $udeEditor::($OBJ,bg_for_non_mce)
   $rl config -bg $udeEditor::($OBJ,bg_for_non_mce)
   $tfrm config -bg $udeEditor::($OBJ,bg_for_non_mce)
   $bfrm config -bg $udeEditor::($OBJ,bg_for_non_mce)
   $rs   config -bg $udeEditor::($OBJ,bg_for_non_mce)
   $rs2  config -bg $udeEditor::($OBJ,bg_for_non_mce)
  }
  lappend udeEditor::uiReal::($obj,buddy_path) $re
  if {$udeEditor::uiReal::($obj,toggle_v) == 0} {
   if ![string compare $::tix_version 8.4] {
    $re config -state disabled
    } else {
    $re config -state disabled -bg lightblue
   }
  }
  if {$udeEditor::($OBJ,TYPE) == "UDC" && \
   $isPtc == 1} {
   if ![string compare $::tix_version 8.4] {
    $re config -state disabled
    } else {
    $re config -state disabled -bg lightblue
   }
   $rc config -state disabled
  }
  bind $tfrm <Button-1>  {event generate [winfo parent %W] \
  <Button-1> -rootx %X -rooty %Y}
  bind $tfrm <B1-Motion> {event generate [winfo parent %W] \
  <B1-Motion> -rootx %X -rooty %Y}
  bind $tfrm <ButtonRelease-1> {event generate [winfo parent %W] \
  <ButtonRelease-1>}
  bind $tfrm <Button-3> {event generate [winfo parent %W] \
  <Button-3> -rootx %X -rooty %Y}
  bind $bfrm <Button-1>  {event generate [winfo parent %W] \
  <Button-1> -rootx %X -rooty %Y}
  bind $bfrm <B1-Motion> {event generate [winfo parent %W] \
  <B1-Motion> -rootx %X -rooty %Y}
  bind $bfrm <ButtonRelease-1> {event generate [winfo parent %W] \
  <ButtonRelease-1>}
  bind $bfrm <Button-3> {event generate [winfo parent %W] \
  <Button-3> -rootx %X -rooty %Y}
  bind $rl <Button-1>  {event generate [winfo parent [winfo parent %W]] <Button-1> \
  -rootx %X -rooty %Y}
  bind $rl <B1-Motion> {event generate [winfo parent [winfo parent %W]] <B1-Motion> \
  -rootx %X -rooty %Y}
  bind $rl <ButtonRelease-1> {event generate [winfo parent [winfo parent %W]] <ButtonRelease-1>}
  bind $rl <Button-3> {event generate [winfo parent [winfo parent %W]] <Button-3> \
  -rootx %X -rooty %Y}
  bind $rs <Button-1>  {event generate [winfo parent [winfo parent %W]] \
  <Button-1> -rootx %X -rooty %Y}
  bind $rs <B1-Motion> {event generate [winfo parent [winfo parent %W]] \
  <B1-Motion> -rootx %X -rooty %Y}
  bind $rs <ButtonRelease-1> {event generate [winfo parent [winfo parent %W]] \
  <ButtonRelease-1>}
  bind $rs <Button-3> {event generate [winfo parent [winfo parent %W]] \
  <Button-3> -rootx %X -rooty %Y}
  bind $rs2 <Button-1>  {event generate [winfo parent [winfo parent %W]] \
  <Button-1> -rootx %X -rooty %Y}
  bind $rs2 <B1-Motion> {event generate [winfo parent [winfo parent %W]] \
  <B1-Motion> -rootx %X -rooty %Y}
  bind $rs2 <ButtonRelease-1> {event generate [winfo parent [winfo parent %W]] \
  <ButtonRelease-1>}
  bind $rs2 <Button-3> {event generate [winfo parent [winfo parent %W]] \
  <Button-3> -rootx %X -rooty %Y}
  if {$udeEditor::uiReal::($obj,toggle_v) != -1} {
   pack $rc $rs $rs2 -side left
   pack $tfrm -side top -anchor w -padx 2
  }
  pack $bfrm -side top -anchor w -fill x -padx 2
  pack $rl -side left -padx 0
  pack $re -side right -padx 5 -pady 5 -fill x -expand 1
 }

#=======================================================================
proc UI_PB_ude_CreateTextItem { w param_obj isPtc } {
  set obj [udeEditor::CreateItemObj $udeEditor::(obj) Text]
  lappend udeEditor::($udeEditor::(obj),sub_objs) $obj
  set udeEditor::uiText::($obj,param_obj) $param_obj
  set udeEditor::uiText::($obj,name) $param::string::($param_obj,name)
  if ![string compare  $param::string::($param_obj,ui_label) ""] {
   set udeEditor::uiText::($obj,ui_label) \
   $param::string::($param_obj,name)
   } else {
   set udeEditor::uiText::($obj,ui_label) \
   $param::string::($param_obj,ui_label)
  }
  set udeEditor::uiText::($obj,value)    \
  $param::string::($param_obj,default)
  if [string match $param::string::($param_obj,toggle) "On"] {
   set udeEditor::uiText::($obj,toggle_v) 1
   } elseif [string match $param::string::($param_obj,toggle) "Off"] {
   set udeEditor::uiText::($obj,toggle_v) 0
   } else {
   set udeEditor::uiText::($obj,toggle_v) -1
  }
  set udeEditor::uiText::($obj,pathname) $w
  set tfrm [frame $w.top]
  set bfrm [frame $w.btm]
  set OBJ $udeEditor::(obj)
  set tc [checkbutton $tfrm.c -bd $udeEditor::($OBJ,bd_value) -highlightt 0 \
  -variable udeEditor::uiText::($obj,toggle_v) \
  -command "UI_PB_ude_ShiftBuddyState $obj"]
  set tl [label $bfrm.l -textvariable udeEditor::uiText::($obj,ui_label) \
  -fg $udeEditor::($OBJ,item_fg)]
  set te [entry $bfrm.e -width 6 -textvariable udeEditor::uiText::($obj,value)]
  set ts [label $tfrm.s -textvariable udeEditor::uiText::($obj,ui_label) \
  -fg $udeEditor::($OBJ,item_fg)]
  set ts2 [label $tfrm.s2 -text " Status" \
  -fg $udeEditor::($OBJ,item_fg)]
  if {$isPtc == 1} {
   $tc config -bg $udeEditor::($OBJ,bg_for_mce) \
   -activebackground $udeEditor::($OBJ,bg_for_mce)
   $tl config -bg $udeEditor::($OBJ,bg_for_mce)
   $tfrm config -bg $udeEditor::($OBJ,bg_for_mce)
   $bfrm config -bg $udeEditor::($OBJ,bg_for_mce)
   $ts   config -bg $udeEditor::($OBJ,bg_for_mce)
   $ts2  config -bg $udeEditor::($OBJ,bg_for_mce)
   } else {
   $tc config -bg $udeEditor::($OBJ,bg_for_non_mce) \
   -activebackground $udeEditor::($OBJ,bg_for_non_mce)
   $tl config -bg $udeEditor::($OBJ,bg_for_non_mce)
   $tfrm config -bg $udeEditor::($OBJ,bg_for_non_mce)
   $bfrm config -bg $udeEditor::($OBJ,bg_for_non_mce)
   $ts   config -bg $udeEditor::($OBJ,bg_for_non_mce)
   $ts2  config -bg $udeEditor::($OBJ,bg_for_non_mce)
  }
  lappend udeEditor::uiText::($obj,buddy_path) $te
  if {$udeEditor::uiText::($obj,toggle_v) == 0} {
   if ![string compare $::tix_version 8.4] {
    $te config -state disabled
    } else {
    $te config -state disabled -bg lightblue
   }
  }
  if {$udeEditor::($OBJ,TYPE) == "UDC" && \
   $isPtc == 1} {
   if ![string compare $::tix_version 8.4] {
    $te config -state disabled
    } else {
    $te config -state disabled -bg lightblue
   }
   $tc config -state disabled
  }
  bind $tfrm <Button-1>  {event generate [winfo parent %W] \
  <Button-1> -rootx %X -rooty %Y}
  bind $tfrm <B1-Motion> {event generate [winfo parent %W] \
  <B1-Motion> -rootx %X -rooty %Y}
  bind $tfrm <ButtonRelease-1> {event generate [winfo parent %W] \
  <ButtonRelease-1>}
  bind $tfrm <Button-3> {event generate [winfo parent %W] \
  <Button-3> -rootx %X -rooty %Y}
  bind $bfrm <Button-1>  {event generate [winfo parent %W] \
  <Button-1> -rootx %X -rooty %Y}
  bind $bfrm <B1-Motion> {event generate [winfo parent %W] \
  <B1-Motion> -rootx %X -rooty %Y}
  bind $bfrm <ButtonRelease-1> {event generate [winfo parent %W] \
  <ButtonRelease-1>}
  bind $bfrm <Button-3> {event generate [winfo parent %W] \
  <Button-3> -rootx %X -rooty %Y}
  bind $tl <Button-1>  {event generate [winfo parent [winfo parent %W]] \
  <Button-1> -rootx %X -rooty %Y}
  bind $tl <B1-Motion> {event generate [winfo parent [winfo parent %W]] \
  <B1-Motion> -rootx %X -rooty %Y}
  bind $tl <ButtonRelease-1> {event generate [winfo parent [winfo parent %W]] \
  <ButtonRelease-1>}
  bind $tl <Button-3> {event generate [winfo parent [winfo parent %W]] \
  <Button-3> -rootx %X -rooty %Y}
  bind $ts <Button-1>  {event generate [winfo parent [winfo parent %W]] \
  <Button-1> -rootx %X -rooty %Y}
  bind $ts <B1-Motion> {event generate [winfo parent [winfo parent %W]] \
  <B1-Motion> -rootx %X -rooty %Y}
  bind $ts <ButtonRelease-1> {event generate [winfo parent [winfo parent %W]] \
  <ButtonRelease-1>}
  bind $ts <Button-3> {event generate [winfo parent [winfo parent %W]] \
  <Button-3> -rootx %X -rooty %Y}
  bind $ts2 <Button-1>  {event generate [winfo parent [winfo parent %W]] \
  <Button-1> -rootx %X -rooty %Y}
  bind $ts2 <B1-Motion> {event generate [winfo parent [winfo parent %W]] \
  <B1-Motion> -rootx %X -rooty %Y}
  bind $ts2 <ButtonRelease-1> {event generate [winfo parent [winfo parent %W]] \
  <ButtonRelease-1>}
  bind $ts2 <Button-3> {event generate [winfo parent [winfo parent %W]] \
  <Button-3> -rootx %X -rooty %Y}
  if {$udeEditor::uiText::($obj,toggle_v) != -1} {
   pack $tc $ts $ts2 -side left
   pack $tfrm -side top -anchor w -padx 2
  }
  pack $bfrm -side top -anchor w -fill x -padx 2 -expand 1
  pack $tl -side top -anchor w -padx 0
  pack $te -side top -anchor w -padx 5 -pady 5 -fill x -expand 1
 }

#=======================================================================
proc UI_PB_ude_CreatePointItem { w param_obj isPtc } {
  global gPB
  set obj [udeEditor::CreateItemObj $udeEditor::(obj) Point]
  lappend udeEditor::($udeEditor::(obj),sub_objs) $obj
  set udeEditor::uiPoint::($obj,param_obj) $param_obj
  set udeEditor::uiPoint::($obj,name) $param::point::($param_obj,name)
  if ![string compare $param::point::($param_obj,ui_label) ""] {
   set udeEditor::uiPoint::($obj,ui_label) \
   $param::point::($param_obj,name)
   } else {
   set udeEditor::uiPoint::($obj,ui_label) \
   $param::point::($param_obj,ui_label)
  }
  if [string match $param::point::($param_obj,toggle) "On"] {
   set udeEditor::uiPoint::($obj,toggle_v) 1
   } elseif [string match $param::point::($param_obj,toggle) "Off"] {
   set udeEditor::uiPoint::($obj,toggle_v) 0
   } else {
   set udeEditor::uiPoint::($obj,toggle_v) -1
  }
  set udeEditor::uiPoint::($obj,pathname) $w
  set tfrm [frame $w.top]
  set bfrm [frame $w.btm]
  set OBJ $udeEditor::(obj)
  set pc [checkbutton $tfrm.c -bd $udeEditor::($OBJ,bd_value) -highlightt 0 \
  -variable udeEditor::uiPoint::($obj,toggle_v) \
  -command "UI_PB_ude_ShiftBuddyState $obj"]
  set pl [label $bfrm.l -textvariable udeEditor::uiPoint::($obj,ui_label) \
  -fg $udeEditor::($OBJ,item_fg)]
  set bf [frame $bfrm.bf]
  set sb [label $bf.sb -text $gPB(ude,editor,pnt,sel,Label) -takefocus 0 \
  -width 10 -relief raised -font $gPB(bold_font) \
  -bd 2 -anchor center\
  -fg $udeEditor::($OBJ,item_fg)]
  set db [label $bf.db -text $gPB(ude,editor,pnt,dsp,Label) -takefocus 0 \
  -width 10 -relief raised -font $gPB(bold_font) \
  -bd 2 -anchor center\
  -fg $udeEditor::($OBJ,item_fg)]
  set ps [label $tfrm.s -textvariable udeEditor::uiPoint::($obj,ui_label) \
  -fg $udeEditor::($OBJ,item_fg)]
  set ps2 [label $tfrm.s2 -text " Status" \
  -fg $udeEditor::($OBJ,item_fg)]
  if {$isPtc == 1} {
   $pc config -bg $udeEditor::($OBJ,bg_for_mce) \
   -activebackground $udeEditor::($OBJ,bg_for_mce)
   $pl config -bg $udeEditor::($OBJ,bg_for_mce)
   $bf config -bg $udeEditor::($OBJ,bg_for_mce)
   $sb config -bg $udeEditor::($OBJ,bg_for_mce)
   $db config -bg $udeEditor::($OBJ,bg_for_mce)
   $tfrm config -bg $udeEditor::($OBJ,bg_for_mce)
   $bfrm config -bg $udeEditor::($OBJ,bg_for_mce)
   $ps   config -bg $udeEditor::($OBJ,bg_for_mce)
   $ps2  config -bg $udeEditor::($OBJ,bg_for_mce)
   } else {
   $pc config -bg $udeEditor::($OBJ,bg_for_non_mce) \
   -activebackground $udeEditor::($OBJ,bg_for_non_mce)
   $pl config -bg $udeEditor::($OBJ,bg_for_non_mce)
   $bf config -bg $udeEditor::($OBJ,bg_for_non_mce)
   $sb config -bg $udeEditor::($OBJ,bg_for_non_mce)
   $db config -bg $udeEditor::($OBJ,bg_for_non_mce)
   $tfrm config -bg $udeEditor::($OBJ,bg_for_non_mce)
   $bfrm config -bg $udeEditor::($OBJ,bg_for_non_mce)
   $ps   config -bg $udeEditor::($OBJ,bg_for_non_mce)
   $ps2  config -bg $udeEditor::($OBJ,bg_for_non_mce)
  }
  lappend udeEditor::uiPoint::($obj,buddy_path) $sb $db
  if {$udeEditor::uiPoint::($obj,toggle_v) == 0} {
   if ![string compare $::tix_version 8.4] {
    $sb config -state disabled
    $db config -state disabled
    } else {
    $sb config -foreground $::SystemDisabledText
    $db config -foreground $::SystemDisabledText
   }
  }
  if {$udeEditor::($OBJ,TYPE) == "UDC" && \
   $isPtc == 1} {
   $pc config -state disabled
  }
  bind $tfrm <Button-1>  {event generate [winfo parent %W] \
  <Button-1> -rootx %X -rooty %Y}
  bind $tfrm <B1-Motion> {event generate [winfo parent %W] \
  <B1-Motion> -rootx %X -rooty %Y}
  bind $tfrm <ButtonRelease-1> {event generate [winfo parent %W] \
  <ButtonRelease-1>}
  bind $tfrm <Button-3> {event generate [winfo parent %W] \
  <Button-3> -rootx %X -rooty %Y}
  bind $bfrm <Button-1>  {event generate [winfo parent %W] \
  <Button-1> -rootx %X -rooty %Y}
  bind $bfrm <B1-Motion> {event generate [winfo parent %W] \
  <B1-Motion> -rootx %X -rooty %Y}
  bind $bfrm <ButtonRelease-1> {event generate [winfo parent %W] \
  <ButtonRelease-1>}
  bind $bfrm <Button-3> {event generate [winfo parent %W] \
  <Button-3> -rootx %X -rooty %Y}
  bind $pl <Button-1> {event generate [winfo parent [winfo parent %W]] \
  <Button-1> -rootx %X -rooty %Y}
  bind $pl <B1-Motion> {event generate [winfo parent [winfo parent %W]] \
  <B1-Motion> -rootx %X -rooty %Y}
  bind $pl <ButtonRelease-1> {event generate [winfo parent [winfo parent %W]] \
  <ButtonRelease-1>}
  bind $pl <Button-3> {event generate [winfo parent [winfo parent %W]] \
  <Button-3> -rootx %X -rooty %Y}
  bind $bf <Button-1> {event generate [winfo parent [winfo parent %W]] <Button-1> \
  -rootx %X -rooty %Y}
  bind $bf <B1-Motion> {event generate [winfo parent [winfo parent %W]] <B1-Motion> \
  -rootx %X -rooty %Y}
  bind $bf <ButtonRelease-1> {event generate [winfo parent [winfo parent %W]] <ButtonRelease-1>}
  bind $bf <Button-3> {event generate [winfo parent [winfo parent %W]] <Button-3> \
  -rootx %X -rooty %Y}
  bind $ps <Button-1>  {event generate [winfo parent [winfo parent %W]] \
  <Button-1> -rootx %X -rooty %Y}
  bind $ps <B1-Motion> {event generate [winfo parent [winfo parent %W]] \
  <B1-Motion> -rootx %X -rooty %Y}
  bind $ps <ButtonRelease-1> {event generate [winfo parent [winfo parent %W]] \
  <ButtonRelease-1>}
  bind $ps <Button-3> {event generate [winfo parent [winfo parent %W]] \
  <Button-3> -rootx %X -rooty %Y}
  bind $ps2 <Button-1>  {event generate [winfo parent [winfo parent %W]] \
  <Button-1> -rootx %X -rooty %Y}
  bind $ps2 <B1-Motion> {event generate [winfo parent [winfo parent %W]] \
  <B1-Motion> -rootx %X -rooty %Y}
  bind $ps2 <ButtonRelease-1> {event generate [winfo parent [winfo parent %W]] \
  <ButtonRelease-1>}
  bind $ps2 <Button-3> {event generate [winfo parent [winfo parent %W]] \
  <Button-3> -rootx %X -rooty %Y}
  if {$udeEditor::uiPoint::($obj,toggle_v) != -1} {
   pack $pc $ps $ps2 -side left
   pack $tfrm -side top -anchor w -padx 2
  }
  pack $bfrm -side top -anchor w -fill x -padx 2
  pack $pl -side top -anchor w -padx 0
  pack $bf -side top -anchor w -fill x -pady 4
  pack $sb -side left -padx 5
  pack $db -side right -padx 5
 }

#=======================================================================
proc UI_PB_ude_CreateBooleanItem {w param_obj isPtc} {
  set obj [udeEditor::CreateItemObj $udeEditor::(obj) Boolean]
  lappend udeEditor::($udeEditor::(obj),sub_objs) $obj
  set udeEditor::uiBoolean::($obj,param_obj) $param_obj
  set udeEditor::uiBoolean::($obj,name) $param::boolean::($param_obj,name)
  if ![string compare $param::boolean::($param_obj,ui_label) ""] {
   set udeEditor::uiBoolean::($obj,ui_label) \
   $param::boolean::($param_obj,name)
   } else {
   set udeEditor::uiBoolean::($obj,ui_label) \
   $param::boolean::($param_obj,ui_label)
  }
  if ![string compare $param::boolean::($param_obj,default)   TRUE] {
   set udeEditor::uiBoolean::($obj,toggle_v) 1
   } else {
   set udeEditor::uiBoolean::($obj,toggle_v) 0
  }
  set udeEditor::uiBoolean::($obj,pathname) $w
  set OBJ $udeEditor::(obj)
  set bc [checkbutton $w.c -bd $udeEditor::($OBJ,bd_value) -highlightt 0 -height 2 \
  -variable udeEditor::uiBoolean::($obj,toggle_v) \
  -command "UI_PB_ude_ShiftBuddyState $obj"]
  set bl [label $w.l -textvariable udeEditor::uiBoolean::($obj,ui_label) \
  -fg $udeEditor::($OBJ,item_fg)]
  if {$isPtc == 1} {
   $bc config -bg $udeEditor::($OBJ,bg_for_mce) \
   -activebackground $udeEditor::($OBJ,bg_for_mce)
   $bl config -bg $udeEditor::($OBJ,bg_for_mce)
   } else {
   $bc config -bg $udeEditor::($OBJ,bg_for_non_mce) \
   -activebackground $udeEditor::($OBJ,bg_for_non_mce)
   $bl config -bg $udeEditor::($OBJ,bg_for_non_mce)
  }
  set udeEditor::uiBoolean::($obj,buddy_path) [list]
  if {$udeEditor::($OBJ,TYPE) == "UDC" && \
   $isPtc == 1} {
   $bc config -state disabled
  }
  bind $bl <Button-1>  {event generate [winfo parent %W] <Button-1> \
  -rootx %X -rooty %Y}
  bind $bl <B1-Motion> {event generate [winfo parent %W] <B1-Motion> \
  -rootx %X -rooty %Y}
  bind $bl <ButtonRelease-1> {event generate [winfo parent %W] <ButtonRelease-1>}
  bind $bl <Button-3> {event generate [winfo parent %W] <Button-3> \
  -rootx %X -rooty %Y}
  pack $bc -side left -padx 1
  if ![string compare $::tix_version 8.4] {
   pack $bl -side left -padx 0
   } else {
   pack $bl -side left -padx 0 -pady 3
  }
 }

#=======================================================================
proc UI_PB_ude_CreateOptionItem {w param_obj isPtc} {
  set obj [udeEditor::CreateItemObj $udeEditor::(obj) Option]
  lappend udeEditor::($udeEditor::(obj),sub_objs) $obj
  set udeEditor::uiOption::($obj,param_obj) $param_obj
  set udeEditor::uiOption::($obj,name) $param::option::($param_obj,name)
  if ![string compare $param::option::($param_obj,ui_label) ""] {
   set udeEditor::uiOption::($obj,ui_label) $param::option::($param_obj,name)
   } else {
   set udeEditor::uiOption::($obj,ui_label) \
   $param::option::($param_obj,ui_label)
  }
  set udeEditor::uiOption::($obj,opt_list) \
  [split $param::option::($param_obj,options) ,]
  set udeEditor::uiOption::($obj,cur_opt)  \
  $param::option::($param_obj,default)
  set udeEditor::uiOption::($obj,toggle_v) -1
  if 0 {
   if [string match $param::option::($param_obj,toggle) "On"] {
    set udeEditor::uiOption::($obj,toggle_v) 1
    } elseif [string match $param::option::($param_obj,toggle) "Off"] {
    set udeEditor::uiOption::($obj,toggle_v) 0
    } else {
    set udeEditor::uiOption::($obj,toggle_v) -1
   }
  }
  set udeEditor::uiOption::($obj,pathname) $w
  set OBJ $udeEditor::(obj)
  if 0 {
   set oc [checkbutton $w.c -bd $udeEditor::($OBJ,bd_value) -highlightt 0 -height 2 \
   -variable udeEditor::uiOption::($obj,toggle_v) \
   -command "UI_PB_ude_ShiftBuddyState $obj"]
  }
  set ol [label $w.l -textvariable udeEditor::uiOption::($obj,ui_label) \
  -height 2 -fg $udeEditor::($OBJ,item_fg)]
  set om [tk_optionMenu $w.o udeEditor::uiOption::($obj,cur_opt) ""]
  set oo ${w}.o
  $om delete 0 end
  foreach opt $udeEditor::uiOption::($obj,opt_list) {
   set str [string trim $opt \"]
   $om add radiobutton -label $str \
   -variable udeEditor::uiOption::($obj,cur_opt)
  }
  $oo config -direction below -anchor w -highlightt 0
  if {$isPtc == 1} {
   if 0 {
    $oc config -bg $udeEditor::($OBJ,bg_for_mce) \
    -activebackground $udeEditor::($OBJ,bg_for_mce)
   }
   $ol config -bg $udeEditor::($OBJ,bg_for_mce)
   $oo config -bg $udeEditor::($OBJ,bg_for_mce)
   } else {
   if 0 {
    $oc config -bg $udeEditor::($OBJ,bg_for_non_mce) \
    -activebackground $udeEditor::($OBJ,bg_for_non_mce)
   }
   $ol config -bg $udeEditor::($OBJ,bg_for_non_mce)
   $oo config -bg $udeEditor::($OBJ,bg_for_non_mce)
  }
  lappend udeEditor::uiOption::($obj,buddy_path) $oo
  if 0 {
   if {$udeEditor::uiOption::($obj,toggle_v) == 0} {
    $oo config -state disabled
   }
  }
  bind $ol <Button-1>  {event generate [winfo parent %W] <Button-1> \
  -rootx %X -rooty %Y}
  bind $ol <B1-Motion> {event generate [winfo parent %W] <B1-Motion> \
  -rootx %X -rooty %Y}
  bind $ol <ButtonRelease-1> {event generate [winfo parent %W] <ButtonRelease-1>}
  bind $ol <Button-3> {event generate [winfo parent %W] <Button-3> \
  -rootx %X -rooty %Y}
  if {$udeEditor::($udeEditor::(obj),numOfItems) == 1} {
   if {$udeEditor::($udeEditor::(obj),TYPE) == "UDE"} {
    set udeEditor::uiOption::($obj,toggle_v) -1
   }
   if ![string compare $::tix_version 8.4] {
    $ol config -state normal
   }
   $oo config -state normal
   if ![string compare $::tix_version 8.4] {
    pack $ol -side left -padx 0
    } else {
    pack $ol -side left -padx 0 -pady 3
   }
   pack $oo -side right -padx 3 -pady 5
   }  else {
   if 0 {
    if {$udeEditor::uiOption::($obj,toggle_v) != "-1"} {
     pack $oc -side left -padx 3
    }
   }
   if ![string compare $::tix_version 8.4] {
    pack $ol -side left -padx 0
    } else {
    pack $ol -side left -padx 0 -pady 3
   }
   pack $oo -side right -padx 3 -pady 5
  }
  if {$udeEditor::($OBJ,TYPE) == "UDC" && \
   $isPtc == 1} {
   $oo config -state disabled
  }
 }

#=======================================================================
proc UI_PB_ude_CreateBitmapItem {w param_obj isPtc} {
  global env
  global gPB_help_tips
  set obj [udeEditor::CreateItemObj $udeEditor::(obj) Bitmap]
  lappend udeEditor::($udeEditor::(obj),sub_objs) $obj
  set udeEditor::uiBitmap::($obj,param_obj) $param_obj
  set udeEditor::uiBitmap::($obj,name) $param::bitmap::($param_obj,name)
  set udeEditor::uiBitmap::($obj,value)    \
  $param::bitmap::($param_obj,default)
  set udeEditor::uiBitmap::($obj,pathname) $w
  set bmp_img [tix getimage pb_image]
  set bmp_btn [button $w.btn -image $bmp_img -relief flat]
  bind $bmp_btn <Button-1>  {event generate [winfo parent %W] <Button-1> \
  -rootx %X -rooty %Y}
  bind $bmp_btn <B1-Motion> {event generate [winfo parent %W] <B1-Motion> \
  -rootx %X -rooty %Y}
  bind $bmp_btn <ButtonRelease-1> {event generate [winfo parent %W] <ButtonRelease-1>}
  bind $bmp_btn <Button-3> {event generate [winfo parent %W] <Button-3> \
  -rootx %X -rooty %Y}
  PB_enable_balloon $bmp_btn
  set gPB_help_tips($bmp_btn) $udeEditor::uiBitmap::($obj,value)
  pack $bmp_btn -anchor c -padx 5 -pady 2
 }

#=======================================================================
proc UI_PB_ude_CreateGroupItem {w param_obj isPtc} {
  set OBJ $udeEditor::(obj)
  set grp_obj [udeEditor::CreateItemObj $OBJ Group]
  lappend udeEditor::($OBJ,sub_objs) $grp_obj
  set udeEditor::uiGroup::($grp_obj,param_obj) $param_obj
  set udeEditor::uiGroup::($grp_obj,name) $param::group::($param_obj,name)
  if ![string compare $param::group::($param_obj,ui_label) ""] {
   set udeEditor::uiGroup::($grp_obj,ui_label) $param::group::($param_obj,name)
   } else {
   set udeEditor::uiGroup::($grp_obj,ui_label) \
   $param::group::($param_obj,ui_label)
  }
  set udeEditor::uiGroup::($grp_obj,value)  \
  $param::group::($param_obj,default)
  set udeEditor::uiGroup::($grp_obj,pathname) $w
  set cur_opt $udeEditor::uiGroup::($grp_obj,value)
  UI_PB_ude_DrawGroupWidgets $w $cur_opt $grp_obj
 }

#=======================================================================
proc UI_PB_ude_CreateVectorItem {w param_obj isPtc} {
  global gPB
  set obj [udeEditor::CreateItemObj $udeEditor::(obj) Vector]
  lappend udeEditor::($udeEditor::(obj),sub_objs) $obj
  set udeEditor::uiVector::($obj,param_obj) $param_obj
  set udeEditor::uiVector::($obj,name) $param::vector::($param_obj,name)
  if ![string compare $param::vector::($param_obj,ui_label) ""] {
   set udeEditor::uiVector::($obj,ui_label) \
   $param::vector::($param_obj,name)
   } else {
   set udeEditor::uiVector::($obj,ui_label) \
   $param::vector::($param_obj,ui_label)
  }
  if [string match $param::vector::($param_obj,toggle) "On"] {
   set udeEditor::uiVector::($obj,toggle_v) 1
   } elseif [string match $param::vector::($param_obj,toggle) "Off"] {
   set udeEditor::uiVector::($obj,toggle_v) 0
   } else {
   set udeEditor::uiVector::($obj,toggle_v) -1
  }
  set udeEditor::uiVector::($obj,pathname) $w
  set tfrm [frame $w.top]
  set bfrm [frame $w.btm]
  set OBJ $udeEditor::(obj)
  set vc [checkbutton $tfrm.c -bd $udeEditor::($OBJ,bd_value) -highlightt 0 \
  -variable udeEditor::uiVector::($obj,toggle_v) \
  -command "UI_PB_ude_ShiftBuddyState $obj"]
  set vl [label $bfrm.l -textvariable udeEditor::uiVector::($obj,ui_label) \
  -fg $udeEditor::($OBJ,item_fg)]
  set bf [frame $bfrm.bf]
  set sb [label $bf.sb -text $gPB(ude,editor,pnt,sel,Label) -takefocus 0 \
  -width 10 -relief raised -font $gPB(bold_font) \
  -bd 2 -anchor center\
  -fg $udeEditor::($OBJ,item_fg)]
  set db [label $bf.db -text $gPB(ude,editor,pnt,dsp,Label) -takefocus 0 \
  -width 10 -relief raised -font $gPB(bold_font) \
  -bd 2 -anchor center\
  -fg $udeEditor::($OBJ,item_fg)]
  set vs [label $tfrm.s -textvariable udeEditor::uiVector::($obj,ui_label) \
  -fg $udeEditor::($OBJ,item_fg)]
  set vs2 [label $tfrm.s2 -text " Status" \
  -fg $udeEditor::($OBJ,item_fg)]
  if {$isPtc == 1} {
   $vc config -bg $udeEditor::($OBJ,bg_for_mce) \
   -activebackground $udeEditor::($OBJ,bg_for_mce)
   $vl config -bg $udeEditor::($OBJ,bg_for_mce)
   $bf config -bg $udeEditor::($OBJ,bg_for_mce)
   $sb config -bg $udeEditor::($OBJ,bg_for_mce)
   $db config -bg $udeEditor::($OBJ,bg_for_mce)
   $tfrm config -bg $udeEditor::($OBJ,bg_for_mce)
   $bfrm config -bg $udeEditor::($OBJ,bg_for_mce)
   $vs   config -bg $udeEditor::($OBJ,bg_for_mce)
   $vs2  config -bg $udeEditor::($OBJ,bg_for_mce)
   } else {
   $vc config -bg $udeEditor::($OBJ,bg_for_non_mce) \
   -activebackground $udeEditor::($OBJ,bg_for_non_mce)
   $vl config -bg $udeEditor::($OBJ,bg_for_non_mce)
   $bf config -bg $udeEditor::($OBJ,bg_for_non_mce)
   $sb config -bg $udeEditor::($OBJ,bg_for_non_mce)
   $db config -bg $udeEditor::($OBJ,bg_for_non_mce)
   $tfrm config -bg $udeEditor::($OBJ,bg_for_non_mce)
   $bfrm config -bg $udeEditor::($OBJ,bg_for_non_mce)
   $vs   config -bg $udeEditor::($OBJ,bg_for_non_mce)
   $vs2  config -bg $udeEditor::($OBJ,bg_for_non_mce)
  }
  lappend udeEditor::uiVector::($obj,buddy_path) $sb $db
  if {$udeEditor::uiVector::($obj,toggle_v) == 0} {
   if ![string compare $::tix_version 8.4] {
    $sb config -state disabled
    $db config -state disabled
    } else {
    $sb config -foreground $::SystemDisabledText
    $db config -foreground $::SystemDisabledText
   }
  }
  if {$udeEditor::($OBJ,TYPE) == "UDC" && \
   $isPtc == 1} {
   $vc config -state disabled
  }
  bind $tfrm <Button-1>  {event generate [winfo parent %W] \
  <Button-1> -rootx %X -rooty %Y}
  bind $tfrm <B1-Motion> {event generate [winfo parent %W] \
  <B1-Motion> -rootx %X -rooty %Y}
  bind $tfrm <ButtonRelease-1> {event generate [winfo parent %W] \
  <ButtonRelease-1>}
  bind $tfrm <Button-3> {event generate [winfo parent %W] \
  <Button-3> -rootx %X -rooty %Y}
  bind $bfrm <Button-1>  {event generate [winfo parent %W] \
  <Button-1> -rootx %X -rooty %Y}
  bind $bfrm <B1-Motion> {event generate [winfo parent %W] \
  <B1-Motion> -rootx %X -rooty %Y}
  bind $bfrm <ButtonRelease-1> {event generate [winfo parent %W] \
  <ButtonRelease-1>}
  bind $bfrm <Button-3> {event generate [winfo parent %W] \
  <Button-3> -rootx %X -rooty %Y}
  bind $vl <Button-1> {event generate [winfo parent [winfo parent %W]] \
  <Button-1> -rootx %X -rooty %Y}
  bind $vl <B1-Motion> {event generate [winfo parent [winfo parent %W]] \
  <B1-Motion> -rootx %X -rooty %Y}
  bind $vl <ButtonRelease-1> {event generate [winfo parent [winfo parent %W]] \
  <ButtonRelease-1>}
  bind $vl <Button-3> {event generate [winfo parent [winfo parent %W]] \
  <Button-3> -rootx %X -rooty %Y}
  bind $bf <Button-1> {event generate [winfo parent [winfo parent %W]] <Button-1> \
  -rootx %X -rooty %Y}
  bind $bf <B1-Motion> {event generate [winfo parent [winfo parent %W]] <B1-Motion> \
  -rootx %X -rooty %Y}
  bind $bf <ButtonRelease-1> {event generate [winfo parent [winfo parent %W]] <ButtonRelease-1>}
  bind $bf <Button-3> {event generate [winfo parent [winfo parent %W]] <Button-3> \
  -rootx %X -rooty %Y}
  bind $vs <Button-1>  {event generate [winfo parent [winfo parent %W]] \
  <Button-1> -rootx %X -rooty %Y}
  bind $vs <B1-Motion> {event generate [winfo parent [winfo parent %W]] \
  <B1-Motion> -rootx %X -rooty %Y}
  bind $vs <ButtonRelease-1> {event generate [winfo parent [winfo parent %W]] \
  <ButtonRelease-1>}
  bind $vs <Button-3> {event generate [winfo parent [winfo parent %W]] \
  <Button-3> -rootx %X -rooty %Y}
  bind $vs2 <Button-1>  {event generate [winfo parent [winfo parent %W]] \
  <Button-1> -rootx %X -rooty %Y}
  bind $vs2 <B1-Motion> {event generate [winfo parent [winfo parent %W]] \
  <B1-Motion> -rootx %X -rooty %Y}
  bind $vs2 <ButtonRelease-1> {event generate [winfo parent [winfo parent %W]] \
  <ButtonRelease-1>}
  bind $vs2 <Button-3> {event generate [winfo parent [winfo parent %W]] \
  <Button-3> -rootx %X -rooty %Y}
  if {$udeEditor::uiVector::($obj,toggle_v) != -1} {
   pack $vc $vs $vs2 -side left
   pack $tfrm -side top -anchor w -padx 2
  }
  pack $bfrm -side top -anchor w -fill x -padx 2
  pack $vl -side top -anchor w -padx 0
  pack $bf -side top -anchor w -fill x -pady 4
  pack $sb -side left -padx 5
  pack $db -side right -padx 5
 }

#=======================================================================
proc UI_PB_ude_ShiftBuddyState {obj} {
  set classname [string trim [classof $obj] ::]
  set w_list [set [set classname]::($obj,buddy_path)]
  set toggle_v [set [set classname]::($obj,toggle_v)]
  foreach buddy $w_list {
   if $toggle_v {
    if ![string compare $::tix_version 8.4] {
     $buddy config -state normal
     if {[winfo class $buddy] == "Label"} {
      $buddy config -foreground $::SystemButtonText
     }
     } else {
     if {[winfo class $buddy] == "Label"} {
      $buddy config -foreground $::SystemButtonText
      } elseif {[winfo class $buddy] == "Entry"} {
      $buddy config -state normal -bg $::SystemWindow
      } else {
      $buddy config -state normal
     }
    }
    } else {
    if ![string compare $::tix_version 8.4] {
     $buddy config -state disabled
     } else {
     if {[winfo class $buddy] == "Label"} {
      $buddy config -foreground $::SystemDisabledText
      } elseif {[winfo class $buddy] == "Entry"} {
      $buddy config -state disabled -bg lightblue
      } else {
      $buddy config -state disabled
     }
    }
   }
  }
 }

#=======================================================================
proc UI_PB_ude_GetParamType {param_obj} {
  set classname [string trim [classof $param_obj] ::]
  set t ""
  set t [set [set classname]::($param_obj,type)]
  set type ""
  switch -exact $t {
   i {
    set type "Integer"
   }
   d {
    set type "Real"
   }
   s {
    set type "Text"
   }
   o {
    set type "Option"
   }
   b {
    set type "Boolean"
   }
   p {
    set type "Point"
   }
   l {
    set type "Bitmap"
   }
   g {
    set type "Group"
   }
   v {
    set type "Vector"
   }
  }
  return $type
 }

#=======================================================================
proc UI_PB_ude_CreateItems {isPtc tol_num} {
  global gPB
  global last_sys_ude_item ;#<08-17-09 wbh>
  set OBJ $udeEditor::(obj)
  set num $udeEditor::($OBJ,totalNumOfItems)
  set bkgframe [frame $udeEditor::($OBJ,midframe).$num -bg \
  $udeEditor::($OBJ,dock_bg)]
  set topframe [frame $bkgframe.tf -bg $udeEditor::($OBJ,bg_for_non_mce) \
  -highlightt 0 \
  -highlightb $udeEditor::($OBJ,dialog_bg) \
  -bd 2 -relief raised]
  set botframe [frame $bkgframe.bf -width 250 -height 3 \
  -highlightb $udeEditor::($OBJ,dialog_bg) \
  -highlightt 2 \
  -highlightc $udeEditor::($OBJ,bar_highlight)]
  set pre_botframe [frame $bkgframe.pbf -bg $udeEditor::($OBJ,dialog_bg) \
  -height 1 -highlightt 0 -bd 0]
  bind $botframe <Enter> "UI_PB_ude_BotFrameOfItemsEnterBinding %W"
  bind $botframe <Leave> "UI_PB_ude_BotFrameOfItemsLeaveBinding %W"
  if {$udeEditor::($udeEditor::(obj),TYPE) == "UDE"} {
   if 1 {
    $topframe config -cursor hand2
    bind $topframe <Button-1>  "UI_PB_ude_TopFrameOfItemsStartMoving \
    %W %X %Y"
    bind $topframe <B1-Motion> "UI_PB_ude_TopFrameOfItemsMotionBinding \
    %W %X %Y"
    bind $topframe <ButtonRelease-1> "UI_PB_ude_TopFrameOfItemsReleaseBinding \
    %W"
    bind $topframe <Button-3>  "UI_PB_ude_ItemPopupMenu %W %X %Y"
   }
   lappend udeEditor::($OBJ,hlWidgets) $botframe
   } else {
   if {$isPtc == 0} {
    $topframe config -cursor hand2
    bind $topframe <Button-1>  "UI_PB_ude_TopFrameOfItemsStartMoving \
    %W %X %Y"
    bind $topframe <B1-Motion> "UI_PB_ude_TopFrameOfItemsMotionBinding \
    %W %X %Y"
    bind $topframe <ButtonRelease-1> "UI_PB_ude_TopFrameOfItemsReleaseBinding \
    %W"
    lappend udeEditor::($OBJ,hlWidgets) $botframe
    } else {
    bind $topframe <Button-1> ""
    bind $topframe <B1-Motion> ""
    bind $topframe <ButtonRelease-1> ""
    set last_sys_ude_item $botframe
    if {$tol_num != "NULL"} {
     if {[expr $tol_num - 1] == $num} {
      lappend udeEditor::($OBJ,hlWidgets) $botframe
      set last_sys_ude_item ""
     }
    }
   }
   bind $topframe <Button-3>  "UI_PB_ude_ItemPopupMenu %W %X %Y"
  }
  pack $pre_botframe -side bottom -fill x
  pack $botframe -side bottom -fill x
  pack $topframe -expand yes -fill x
  pack $bkgframe -expand yes -fill x
  incr udeEditor::($OBJ,numOfItems)
  incr udeEditor::($OBJ,totalNumOfItems)
  set gPB(c_help,$topframe) "ude,editor,param"
  return $topframe
 }

#=======================================================================
proc UI_PB_ude_RestoreConfig {ui_obj isPtc self_bf self_pbf up_bf up_pbf} {
  set OBJ $udeEditor::(obj)
  set class_type [classof $ui_obj]
  set self_pathname [set [set class_type]::($ui_obj,pathname)]
  $self_pathname config -relief raised
  if {$isPtc == 1} {
   set bg_color $udeEditor::($OBJ,bg_for_mce)
   } else {
   set bg_color $udeEditor::($OBJ,bg_for_non_mce)
   if ![string compare $class_type "::udeEditor::uiGroup"] {
    set bg_color $udeEditor::($OBJ,groupitem_bg)
   }
  }
  __ude_SetItemColor $self_pathname $bg_color
  if ![string compare $class_type "::udeEditor::uiGroup"] {
   set match_grp_obj [UI_PB_ude_GetMatchGroupItemFrom $ui_obj]
   set temp_pathname $udeEditor::uiGroup::($match_grp_obj,pathname)
   $temp_pathname config -relief raised
   __ude_SetItemColor $temp_pathname $bg_color
  }
  if 0 { ;# Replacedd with call above
   set children [tixDescendants $self_pathname]
   foreach one $children {
    set type [winfo class $one]
    if {$type == "Label" || $type == "Checkbutton" || \
     $type == "Frame" || $type == "Menubutton"} {
     $one config -bg $bg_color
     if {$type == "Checkbutton"} {
      $one config -activebackground $bg_color
     }
    }
   }
  }
  if 0 {
   $self_bf config -highlightb $udeEditor::($OBJ,dialog_bg)
   $self_pbf config -bg $udeEditor::($OBJ,dialog_bg)
   $up_bf config -highlightb $udeEditor::($OBJ,dialog_bg)
   $up_pbf config -bg $udeEditor::($OBJ,dialog_bg)
  }
 }

#=======================================================================
proc UI_PB_ude_GetAboveUiObj {ui_obj} {
  set OBJ $udeEditor::(obj)
  array set ord_array $udeEditor::($OBJ,pst_order)
  set pst ""
  set num [array size ord_array]
  for {set idx 0} {$idx < $num} {incr idx} {
   if {$ord_array($idx) == $ui_obj} {
    set pst $idx
   }
  }
  set above_pst [expr $pst - 1]
  if {$above_pst < 0} {
   return NULL
   } else {
   set above_obj $ord_array($above_pst)
   return $above_obj
  }
 }

#=======================================================================
proc UI_PB_ude_ItemPopupMenu {w x y} {
  global gPB
  if {$udeEditor::($udeEditor::(obj),isInDD) == 1} {
   return
  }
  set ui_obj [UI_PB_ude_GetItemObjAccordingToWidget $w]
  set udeEditor::($udeEditor::(obj),cur_edit_obj) $ui_obj
  if [winfo exists $w.m] {
   destroy $w.m
  }
  set pm [menu $w.m -tearoff 0]
  set isPtc [UI_PB_ude_IsProtected $ui_obj]
  set OBJ $udeEditor::(obj)
  set type $udeEditor::($OBJ,TYPE)
  if {$type == "UDC" && $isPtc == 1} {
   set lbl $gPB(ude,editor,param,VIEW)
   } else {
   set lbl $gPB(ude,editor,param,EDIT)
  }
  set is_edit 1
  if { [string compare [classof $ui_obj] "::udeEditor::uiGroup"] == 0 && \
   [string compare "end" $udeEditor::uiGroup::($ui_obj,value)] == 0 } {
   set is_edit 0
  }
  if { $is_edit } {
   $pm add command -label $lbl \
   -command "UI_PB_ude_EditItem $ui_obj $isPtc"
   $pm add command -label $gPB(ude,editor,popup,DELETE) \
   -command "UI_PB_ude_DeleteItem $ui_obj"
  }
  if {$isPtc == 1} {
   $pm entryconfig 1 -state disabled
  }
  tk_popup $pm $x $y
 }

#=======================================================================
proc UI_PB_ude_IsProtected {obj} {
  global McParam gPB
  array set MC $McParam
  set result 0
  set OBJ $udeEditor::(obj)
  if {$udeEditor::($OBJ,TYPE) == "UDE"} {
   set udeobj $udeEditor::(ude_event_obj)
   set ename $ude_event::($udeobj,name)
   if [info exists MC($ename)] {
    set pnamelist $MC($ename)
    set type [classof $obj]
    switch -exact $type {
     ::udeEditor::uiInteger {
      set pobj $udeEditor::uiInteger::($obj,param_obj)
      set pname $param::integer::($pobj,name)
     }
     ::udeEditor::uiReal    {
      set pobj $udeEditor::uiReal::($obj,param_obj)
      set pname $param::double::($pobj,name)
     }
     ::udeEditor::uiText    {
      set pobj $udeEditor::uiText::($obj,param_obj)
      set pname $param::string::($pobj,name)
     }
     ::udeEditor::uiBoolean {
      set pobj $udeEditor::uiBoolean::($obj,param_obj)
      set pname $param::boolean::($pobj,name)
     }
     ::udeEditor::uiPoint   {
      set pobj $udeEditor::uiPoint::($obj,param_obj)
      set pname $param::point::($pobj,name)
     }
     ::udeEditor::uiOption  {
      set pobj $udeEditor::uiOption::($obj,param_obj)
      set pname $param::option::($pobj,name)
     }
     ::udeEditor::uiBitmap  {
      set pobj $udeEditor::uiBitmap::($obj,param_obj)
      set pname $param::bitmap::($pobj,name)
     }
     ::udeEditor::uiGroup   {
      set pobj $udeEditor::uiGroup::($obj,param_obj)
      set pname $param::group::($pobj,name)
     }
     ::udeEditor::uiVector  {
      set pobj $udeEditor::uiVector::($obj,param_obj)
      set pname $param::vector::($pobj,name)
     }
     ::param::option  {
      set pname $param::option::($obj,name)
     }
     ::param::point   {
      set pname $param::point::($obj,name)
     }
     ::param::integer {
      set pname $param::integer::($obj,name)
     }
     ::param::double  {
      set pname $param::double::($obj,name)
     }
     ::param::boolean {
      set pname $param::boolean::($obj,name)
     }
     ::param::string  {
      set pname $param::string::($obj,name)
     }
     ::param::bitmap  {
      set pname $param::bitmap::($obj,name)
     }
     ::param::group   {
      set pname $param::group::($obj,name)
     }
     ::param::vector  {
      set pname $param::vector::($obj,name)
     }
    }
    set ff [lsearch $pnamelist $pname]
    if {$ff >= 0} {
     set result 1
     } else {
     set result 0
    }
    } else  {
    set result 0
   }
   return $result
   } else {
   set type [classof $obj]
   set param_obj ""
   switch -exact $type {
    ::udeEditor::uiInteger -
    ::udeEditor::uiReal  -
    ::udeEditor::uiText   -
    ::udeEditor::uiBoolean -
    ::udeEditor::uiPoint  -
    ::udeEditor::uiOption  -
    ::udeEditor::uiBitmap -
    ::udeEditor::uiGroup  -
    ::udeEditor::uiVector { ;#<05-13-09 wbh> add two new types: uiBitmap, uiGroup, uiVector
     set param_obj [set [set type]::($obj,param_obj)]
    }
    ::param::option  -
    ::param::point   -
    ::param::integer -
    ::param::double  -
    ::param::boolean -
    ::param::string  -
    ::param::bitmap  -
    ::param::group   -
    ::param::vector  { ;#<05-13-09 wbh> add two new types: bitmap, group, vector
     set param_obj $obj
    }
   }
   if {[lsearch $gPB(sys_def_param_obj_list) $param_obj] >= 0} {
    set result 1
    } else {
    set result 0
   }
   return $result
  }
 }

#=======================================================================
proc UI_PB_ude_DeleteItem {ui_obj} {
  set type [UI_PB_ude_GetItemTypeAccordingToObj $ui_obj]
  if {[string compare $type "Group"] == 0} {
   set matchGroupObj [UI_PB_ude_GetMatchGroupItemFrom $ui_obj]
   UI_PB_ude_DoingDeleteAction $type $matchGroupObj
  }
  UI_PB_ude_DoingDeleteAction $type $ui_obj
 }

#=======================================================================
proc UI_PB_ude_GetMatchGroupItemFrom {group_obj} {
  set pathname $udeEditor::uiGroup::($group_obj,pathname)
  set isFindStart 0
  foreach obj $udeEditor::($udeEditor::(obj),sub_objs) {
   set type [classof $obj]
   if { [string compare $type "::udeEditor::uiGroup"] != 0 } { continue }
   if {$isFindStart == 1} {return $obj}
   set each_widget [set [set type]::($obj,pathname)]
   if { ![string compare $each_widget $pathname] } {
    if [string match "end" $udeEditor::uiGroup::($group_obj,value)] \
    {
     return $prevOBJ
    }
    set isFindStart 1
   }
   set prevOBJ $obj
  }
  return NULL
 }

#=======================================================================
proc UI_PB_ude_DoingDeleteAction {type ui_obj} {
  set widget ""
  set param_obj ""
  set widget [set udeEditor::ui[set type]::($ui_obj,pathname)]
  set param_obj [set udeEditor::ui[set type]::($ui_obj,param_obj)]
  set parent [winfo parent $widget]
  set hlwidget ${parent}.bf
  set OBJ $udeEditor::(obj)
  if {$udeEditor::($OBJ,numOfItems) == 1} {
   set midframe $udeEditor::($OBJ,midframe)
   $midframe config -height 5
  }
  destroy $parent
  incr udeEditor::($OBJ,numOfItems) -1
  set idx [lsearch $udeEditor::($OBJ,sub_objs) $ui_obj]
  set new_sub_objs [lreplace $udeEditor::($OBJ,sub_objs) $idx $idx]
  set udeEditor::($OBJ,sub_objs) $new_sub_objs
  set idx [lsearch $udeEditor::($OBJ,temp_new_paramobj) $param_obj]
  if {$idx >= 0} {
   set new_list [lreplace $udeEditor::($OBJ,temp_new_paramobj) $idx $idx]
   set udeEditor::($OBJ,temp_new_paramobj) $new_list
  }
  set idx [lsearch $udeEditor::($OBJ,hlWidgets) $hlwidget]
  set new_list [lreplace $udeEditor::($OBJ,hlWidgets) $idx $idx]
  set udeEditor::($OBJ,hlWidgets) $new_list
  set idx [lsearch $udeEditor::($OBJ,pst_order) $ui_obj]
  set arr_idx [lindex $udeEditor::($OBJ,pst_order) [expr $idx - 1]]
  array set order $udeEditor::($OBJ,pst_order)
  set num [array size order]
  set num_late [expr $num - 1]
  for {set i 0} {$i < $num_late} {incr i} {
   if {$i < $arr_idx} {
    set new_order($i) $order($i)
    } else {
    set index [expr $i + 1]
    set new_order($i) $order($index)
   }
  }
  set udeEditor::($OBJ,pst_order) [array get new_order]
  delete $ui_obj
 }

#=======================================================================
proc UI_PB_ude_EditItem {ui_obj isPtc} {
  set type [UI_PB_ude_GetItemTypeAccordingToObj $ui_obj]
  UI_PB_ude_CreateParamDialog $type $isPtc EDIT
 }

#=======================================================================
proc UI_PB_ude_GetItemTypeAccordingToObj {ui_obj} {
  set type [classof $ui_obj]
  set rtype ""
  set rtype [string trim [lindex [split $type "::"] end] "ui"]
  return $rtype
 }

#=======================================================================
proc UI_PB_ude_GetItemObjAccordingToWidget {w} {
  foreach obj $udeEditor::($udeEditor::(obj),sub_objs) {
   set type [classof $obj]
   set each_widget [set [set type]::($obj,pathname)]
   if ![string compare $each_widget $w] {
    set rOBJ $obj
   }
  }
  return $rOBJ
 }

#=======================================================================
proc UI_PB_ude_AddWidgetsIntoBlock { obj } {
  set w ".ddBlock"
  set type [classof $obj]
  switch -exact $type {
   ::udeEditor::uiInteger {
    UI_PB_ude_AddWidgetsIntoBlockForInteger $w $obj
   }
   ::udeEditor::uiReal    {
    UI_PB_ude_AddWidgetsIntoBlockForReal $w $obj
   }
   ::udeEditor::uiText    {
    UI_PB_ude_AddWidgetsIntoBlockForText $w $obj
   }
   ::udeEditor::uiBoolean {
    UI_PB_ude_AddWidgetsIntoBlockForBoolean $w $obj
   }
   ::udeEditor::uiPoint   {
    UI_PB_ude_AddWidgetsIntoBlockForPoint $w $obj
   }
   ::udeEditor::uiOption  {
    UI_PB_ude_AddWidgetsIntoBlockForOption $w $obj
   }
   ::udeEditor::uiBitmap  {
    UI_PB_ude_AddWidgetsIntoBlockForBitmap $w $obj
   }
   ::udeEditor::uiGroup   {
    $w config -bg $udeEditor::($udeEditor::(obj),groupitem_bg)
    UI_PB_ude_AddWidgetsIntoBlockForGroup $w $obj
   }
   ::udeEditor::uiVector  {
    UI_PB_ude_AddWidgetsIntoBlockForVector $w $obj
   }
  }
 }

#=======================================================================
proc UI_PB_ude_AddWidgetsIntoBlockForInteger { w obj } {
  set OBJ $udeEditor::(obj)
  set tfrm [frame $w.top -bg $udeEditor::($OBJ,ddblock_bg_edit)]
  set bfrm [frame $w.btm -bg $udeEditor::($OBJ,ddblock_bg_edit)]
  set ic [checkbutton $tfrm.c -bd $udeEditor::($OBJ,bd_value) -highlightt 0 \
  -bg $udeEditor::($OBJ,ddblock_bg_edit)\
  -variable udeEditor::uiInteger::($obj,toggle_v)]
  set il [label $bfrm.l -textvariable udeEditor::uiInteger::($obj,ui_label) \
  -bg $udeEditor::($OBJ,ddblock_bg_edit) \
  -fg $udeEditor::($OBJ,item_fg)]
  set ie [entry $bfrm.e -width 6 -textvariable udeEditor::uiInteger::($obj,value)]
  set is [label $tfrm.s -textvariable udeEditor::uiInteger::($obj,ui_label) \
  -bg $udeEditor::($OBJ,ddblock_bg_edit) \
  -fg $udeEditor::($OBJ,item_fg)]
  set is2 [label $tfrm.s2 -text " Status" \
  -bg $udeEditor::($OBJ,ddblock_bg_edit) \
  -fg $udeEditor::($OBJ,item_fg)]
  if {$udeEditor::uiInteger::($obj,toggle_v) == 0} {
   if ![string compare $::tix_version 8.4] {
    $ie config -state disabled
    } else {
    $ie config -state disabled -bg lightblue
   }
  }
  if {$udeEditor::uiInteger::($obj,toggle_v) != -1} {
   pack $ic $is $is2 -side left
   pack $tfrm -side top -anchor w -padx 2
  }
  pack $bfrm -side top -anchor w -fill x -padx 2
  pack $il -side left -padx 0
  pack $ie -side right -padx 5 -pady 5 -fill x -expand 1
 }

#=======================================================================
proc UI_PB_ude_AddWidgetsIntoBlockForReal { w obj } {
  set OBJ $udeEditor::(obj)
  set tfrm [frame $w.top -bg $udeEditor::($OBJ,ddblock_bg_edit)]
  set bfrm [frame $w.btm -bg $udeEditor::($OBJ,ddblock_bg_edit)]
  set rc [checkbutton $tfrm.c -bd $udeEditor::($OBJ,bd_value) -highlightt 0 \
  -bg $udeEditor::($OBJ,ddblock_bg_edit) \
  -variable udeEditor::uiReal::($obj,toggle_v)]
  set rl [label $bfrm.l -textvariable udeEditor::uiReal::($obj,ui_label) \
  -bg $udeEditor::($OBJ,ddblock_bg_edit) \
  -fg $udeEditor::($OBJ,item_fg)]
  set re [entry $bfrm.e -width 6 -textvariable udeEditor::uiReal::($obj,value)]
  set rs [label $tfrm.s -textvariable udeEditor::uiReal::($obj,ui_label) \
  -bg $udeEditor::($OBJ,ddblock_bg_edit) \
  -fg $udeEditor::($OBJ,item_fg)]
  set rs2 [label $tfrm.s2 -text " Status" \
  -bg $udeEditor::($OBJ,ddblock_bg_edit) \
  -fg $udeEditor::($OBJ,item_fg)]
  if {$udeEditor::uiReal::($obj,toggle_v) == 0} {
   if ![string compare $::tix_version 8.4] {
    $re config -state disabled
    } else {
    $re config -state disabled -bg lightblue
   }
  }
  if {$udeEditor::uiReal::($obj,toggle_v) != -1} {
   pack $rc $rs $rs2 -side left
   pack $tfrm -side top -anchor w -padx 2
  }
  pack $bfrm -side top -anchor w -fill x -padx 2
  pack $rl -side left -padx 0
  pack $re -side right -padx 5 -pady 5 -fill x -expand 1
 }

#=======================================================================
proc UI_PB_ude_AddWidgetsIntoBlockForText { w obj } {
  set OBJ $udeEditor::(obj)
  set tfrm [frame $w.top -bg $udeEditor::($OBJ,ddblock_bg_edit)]
  set bfrm [frame $w.btm -bg $udeEditor::($OBJ,ddblock_bg_edit)]
  set tc [checkbutton $tfrm.c -bd $udeEditor::($OBJ,bd_value) -highlightt 0 \
  -bg $udeEditor::($OBJ,ddblock_bg_edit) \
  -variable udeEditor::uiText::($obj,toggle_v)]
  set tl [label $bfrm.l -textvariable udeEditor::uiText::($obj,ui_label) \
  -fg $udeEditor::($OBJ,item_fg) \
  -bg $udeEditor::($OBJ,ddblock_bg_edit)]
  set te [entry $bfrm.e -width 6 -textvariable udeEditor::uiText::($obj,value)]
  set ts [label $tfrm.s -textvariable udeEditor::uiText::($obj,ui_label) \
  -bg $udeEditor::($OBJ,ddblock_bg_edit) \
  -fg $udeEditor::($OBJ,item_fg)]
  set ts2 [label $tfrm.s2 -text " Status" \
  -bg $udeEditor::($OBJ,ddblock_bg_edit) \
  -fg $udeEditor::($OBJ,item_fg)]
  if {$udeEditor::uiText::($obj,toggle_v) == 0} {
   if ![string compare $::tix_version 8.4] {
    $te config -state disabled
    } else {
    $te config -state disabled -bg lightblue
   }
  }
  if {$udeEditor::uiText::($obj,toggle_v) != -1} {
   pack $tc $ts $ts2 -side left
   pack $tfrm -side top -anchor w -padx 2
  }
  pack $bfrm -side top -anchor w -fill x -padx 2
  pack $tl -side top -anchor w -padx 0
  pack $te -side top -anchor w -padx 5 -pady 5 -fill x -expand 1
 }

#=======================================================================
proc UI_PB_ude_AddWidgetsIntoBlockForBoolean {w obj} {
  set OBJ $udeEditor::(obj)
  set bc [checkbutton $w.c -bd $udeEditor::($OBJ,bd_value) -highlightt 0 -height 2 \
  -bg $udeEditor::($OBJ,ddblock_bg_edit) \
  -variable udeEditor::uiBoolean::($obj,toggle_v)]
  set bl [label $w.l -textvariable udeEditor::uiBoolean::($obj,ui_label) \
  -bg $udeEditor::($OBJ,ddblock_bg_edit) \
  -fg $udeEditor::($OBJ,item_fg)]
  pack $bc -side left -padx 1
  pack $bl -side left -padx 0
 }

#=======================================================================
proc UI_PB_ude_AddWidgetsIntoBlockForPoint { w obj } {
  set OBJ $udeEditor::(obj)
  global gPB
  set tfrm [frame $w.top -bg $udeEditor::($OBJ,ddblock_bg_edit)]
  set bfrm [frame $w.btm -bg $udeEditor::($OBJ,ddblock_bg_edit)]
  set pc [checkbutton $tfrm.c -bd $udeEditor::($OBJ,bd_value) -highlightt 0 \
  -bg $udeEditor::($OBJ,ddblock_bg_edit) \
  -variable udeEditor::uiPoint::($obj,toggle_v)]
  set pl [label $bfrm.l -textvariable udeEditor::uiPoint::($obj,ui_label) \
  -bg $udeEditor::($OBJ,ddblock_bg_edit) \
  -fg $udeEditor::($OBJ,item_fg)]
  set bf [frame $bfrm.bf -bg $udeEditor::($OBJ,ddblock_bg_edit)]
  set sb [label $bf.sb -text $gPB(ude,editor,pnt,sel,Label) -takefocus 0 \
  -width 10 -font $gPB(bold_font) \
  -relief raised \
  -bg $udeEditor::($OBJ,ddblock_bg_edit) \
  -fg $udeEditor::($OBJ,item_fg) -bd 2 -anchor center]
  set db [label $bf.db -text $gPB(ude,editor,pnt,dsp,Label) -takefocus 0 \
  -width 10 -font $gPB(bold_font)  -relief raised \
  -bg $udeEditor::($OBJ,ddblock_bg_edit) \
  -fg $udeEditor::($OBJ,item_fg) -bd 2 -anchor center]
  set ps [label $tfrm.s -textvariable udeEditor::uiPoint::($obj,ui_label) \
  -bg $udeEditor::($OBJ,ddblock_bg_edit) \
  -fg $udeEditor::($OBJ,item_fg)]
  set ps2 [label $tfrm.s2 -text " Status" \
  -bg $udeEditor::($OBJ,ddblock_bg_edit) \
  -fg $udeEditor::($OBJ,item_fg)]
  if {$udeEditor::uiPoint::($obj,toggle_v) == 0} {
   if ![string compare $::tix_version 8.4] {
    $sb config -state disabled
    $db config -state disabled
    } else {
    $sb config -foreground $::SystemDisabledText
    $db config -foreground $::SystemDisabledText
   }
  }
  if {$udeEditor::uiPoint::($obj,toggle_v) != -1} {
   pack $pc $ps $ps2 -side left
   pack $tfrm -side top -anchor w -padx 2
  }
  pack $bfrm -side top -anchor w -fill x -padx 2
  pack $pl -side top -anchor w -padx 0
  pack $sb -side left -padx 5
  pack $db -side right -padx 5
  pack $bf -side top -anchor w -fill x -pady 4
 }

#=======================================================================
proc UI_PB_ude_AddWidgetsIntoBlockForOption {w obj} {
  set OBJ $udeEditor::(obj)
  set oc [checkbutton $w.c -bd $udeEditor::($OBJ,bd_value) -highlightt 0 -height 2 \
  -bg $udeEditor::($OBJ,ddblock_bg_edit) \
  -variable udeEditor::uiOption::($obj,toggle_v)]
  set ol [label $w.l -textvariable udeEditor::uiOption::($obj,ui_label) \
  -bg $udeEditor::($OBJ,ddblock_bg_edit) \
  -fg $udeEditor::($OBJ,item_fg)]
  set om [tk_optionMenu $w.o udeEditor::uiOption::($obj,cur_opt) ""]
  set oo ${w}.o
  $om delete 0 end
  foreach opt $udeEditor::uiOption::($obj,opt_list) {
   set str [string trim $opt \"]
   $om add radiobutton -label $str \
   -variable udeEditor::uiOption::($obj,cur_opt)
  }
  $oo config  -direction below -anchor w -highlightt 0 \
  -bg $udeEditor::($OBJ,ddblock_bg_edit)
  if {$udeEditor::uiOption::($obj,toggle_v) == 0} {
   $oo config -state disabled
  }
  if {$udeEditor::uiOption::($obj,toggle_v) != -1} {
   pack $oc -side left -padx 3
  }
  pack $ol -side left -padx 0
  pack $oo -side right -padx 3 -pady 5
 }

#=======================================================================
proc UI_PB_ude_AddWidgetsIntoBlockForVector { w obj } {
  set OBJ $udeEditor::(obj)
  global gPB
  set tfrm [frame $w.top -bg $udeEditor::($OBJ,ddblock_bg_edit)]
  set bfrm [frame $w.btm -bg $udeEditor::($OBJ,ddblock_bg_edit)]
  set pc [checkbutton $tfrm.c -bd $udeEditor::($OBJ,bd_value) -highlightt 0 \
  -bg $udeEditor::($OBJ,ddblock_bg_edit) \
  -variable udeEditor::uiVector::($obj,toggle_v)]
  set pl [label $bfrm.l -textvariable udeEditor::uiVector::($obj,ui_label) \
  -bg $udeEditor::($OBJ,ddblock_bg_edit) \
  -fg $udeEditor::($OBJ,item_fg)]
  set bf [frame $bfrm.bf -bg $udeEditor::($OBJ,ddblock_bg_edit)]
  set sb [label $bf.sb -text $gPB(ude,editor,pnt,sel,Label) -takefocus 0 \
  -width 10 -font $gPB(bold_font) \
  -relief raised \
  -bg $udeEditor::($OBJ,ddblock_bg_edit) \
  -fg $udeEditor::($OBJ,item_fg) -bd 2 -anchor center]
  set db [label $bf.db -text $gPB(ude,editor,pnt,dsp,Label) -takefocus 0 \
  -width 10 -font $gPB(bold_font)  -relief raised \
  -bg $udeEditor::($OBJ,ddblock_bg_edit) \
  -fg $udeEditor::($OBJ,item_fg) -bd 2 -anchor center]
  set ps [label $tfrm.s -textvariable udeEditor::uiVector::($obj,ui_label) \
  -bg $udeEditor::($OBJ,ddblock_bg_edit) \
  -fg $udeEditor::($OBJ,item_fg)]
  set ps2 [label $tfrm.s2 -text " Status" \
  -bg $udeEditor::($OBJ,ddblock_bg_edit) \
  -fg $udeEditor::($OBJ,item_fg)]
  if {$udeEditor::uiVector::($obj,toggle_v) == 0} {
   if ![string compare $::tix_version 8.4] {
    $sb config -state disabled
    $db config -state disabled
    } else {
    $sb config -foreground $::SystemDisabledText
    $db config -foreground $::SystemDisabledText
   }
  }
  if {$udeEditor::uiVector::($obj,toggle_v) != -1} {
   pack $pc $ps $ps2 -side left
   pack $tfrm -side top -anchor w -padx 2
  }
  pack $bfrm -side top -anchor w -fill x -padx 2
  pack $pl -side top -anchor w -padx 0
  pack $sb -side left -padx 5
  pack $db -side right -padx 5
  pack $bf -side top -anchor w -fill x -pady 4
 }

#=======================================================================
proc UI_PB_ude_AddWidgetsIntoBlockForBitmap {w obj} {
  set bmp_img [tix getimage pb_image]
  set bmp_btn [button $w.btn -image $bmp_img -relief flat]
  pack $bmp_btn -anchor c -padx 5 -pady 2
 }

#=======================================================================
proc UI_PB_ude_AddWidgetsIntoBlockForGroup {w obj} {
  set cur_opt $udeEditor::uiGroup::($obj,value)
  UI_PB_ude_DrawGroupWidgets $w $cur_opt $obj
 }

#=======================================================================
proc UI_PB_ude_DrawGroupWidgets { w opt args } {
  global gPB_help_tips
  set OBJ $udeEditor::(obj)
  if [string match "end" $opt] \
  {
   set btn [UI_PB_com_AddSeparator $w.btn]
   pack $btn -pady 2 -fill x
   bind $btn <Button-1>  {event generate [winfo parent %W] <Button-1> \
   -rootx %X -rooty %Y}
   bind $btn <B1-Motion> {event generate [winfo parent %W] <B1-Motion> \
   -rootx %X -rooty %Y}
   bind $btn <ButtonRelease-1> {event generate [winfo parent %W] <ButtonRelease-1>}
   bind $btn <Button-3> {event generate [winfo parent %W] <Button-3> \
   -rootx %X -rooty %Y}
  } else \
  {
   if [string match "start_open" $opt] \
   {
    set img_name "pb_group_open"
    set hlp_url "Group Open"
   } else \
   {
    set img_name "pb_group_close"
    set hlp_url "Group Closed"
   }
   if [winfo exists $w.btn] \
   {
    set btn $w.btn
   } else \
   {
    set btn [button $w.btn -command "UI_PB_ude_ClickGroupIcon $w"]
    PB_enable_balloon $w.btn
    set gPB_help_tips($w.btn) $hlp_url
   }
   set img [tix getimage $img_name]
   $btn configure -image $img
   if { [llength $args] } \
   {
    set grp_obj [lindex $args 0]
    set lbl [label $w.lbl -textvariable udeEditor::uiGroup::($grp_obj,ui_label) \
    -fg $udeEditor::($OBJ,ddblock_fg_new) \
    -bg $udeEditor::($OBJ,groupitem_bg)]
   } else \
   {
    set lbl [label $w.lbl -textvariable udeEditor::($OBJ,g_label) \
    -fg $udeEditor::($OBJ,ddblock_fg_new) \
    -bg $udeEditor::($OBJ,groupitem_bg)]
   }
   pack $lbl -side left -anchor w -padx 1
   pack $btn -side right -anchor e -padx 1
   bind $lbl <Button-1>  {event generate [winfo parent %W] <Button-1> \
   -rootx %X -rooty %Y}
   bind $lbl <B1-Motion> {event generate [winfo parent %W] <B1-Motion> \
   -rootx %X -rooty %Y}
   bind $lbl <ButtonRelease-1> {event generate [winfo parent %W] <ButtonRelease-1>}
   bind $lbl <Button-3> {event generate [winfo parent %W] <Button-3> \
   -rootx %X -rooty %Y}
  }
 }

#=======================================================================
proc UI_PB_ude_ClickGroupIcon { w args } {
  global gPB_help_tips
  set len [llength $args]
  if $len \
  {
   set type [lindex $args 0]
   if [string match "start_open" $type] \
   {
    set cur_var "start_closed"
   } else \
   {
    set cur_var "start_open"
   }
  } else \
  {
   set ui_obj [UI_PB_ude_GetItemObjAccordingToWidget $w]
   set cur_var $udeEditor::uiGroup::($ui_obj,value)
  }
  if [string match "start_open" $cur_var] \
  {
   if !$len \
   {
    set udeEditor::uiGroup::($ui_obj,value) "start_closed"
   }
   set img_name "pb_group_close"
   set hlp_url "Group Closed"
  } elseif [string match "start_closed" $cur_var] \
  {
   if !$len \
   {
    set udeEditor::uiGroup::($ui_obj,value) "start_open"
   }
   set img_name "pb_group_open"
   set hlp_url "Group Open"
  } else \
  {
   return
  }
  set img [tix getimage $img_name]
  $w.btn configure -image $img
  set gPB_help_tips($w.btn) $hlp_url
 }

#=======================================================================
proc __ude_SetItemColor { w args } {
  if [llength $args] {
   set clr [lindex $args 0]
   } else {
   set clr $::SystemDisabledText
  }
  set children [tixDescendants $w]
  foreach one $children {
   set tp [winfo class $one]
   if {$tp == "Label" || $tp == "Checkbutton" || $tp == "Frame" || $tp == "Menubutton"} {
    $one config -bg $clr
    if { $tp == "Checkbutton" } {
     $one config -activebackground $clr
    }
   }
  }
 }

#=======================================================================
proc UI_PB_ude_TopFrameOfItemsStartMoving {w X Y} {
  global gPB
  set OBJ $udeEditor::(obj)
  if {$gPB(use_info)} {
   return
  }
  if {$udeEditor::($OBJ,drag_drop_enabled) != 1} {
   return
  }
  set width  [winfo width $w]
  set height [winfo height $w]
  set rootx  [winfo rootx $w]
  set rooty  [winfo rooty $w]
  set udeEditor::(dx) [expr {$X - $rootx}]
  set udeEditor::(dy) [expr {$Y - $rooty}]
  set obj [UI_PB_ude_GetItemObjAccordingToWidget $w]
  set isPtc [UI_PB_ude_IsProtected $obj]
  set udeEditor::($udeEditor::(obj),isPtc) $isPtc
  set udeEditor::($OBJ,ddblock_bg_edit) burlywood2
  if {$isPtc == 1} {
   set udeEditor::($OBJ,ddblock_bg_edit) $udeEditor::($OBJ,bg_for_mce)
  }
  UI_PB_mthd_CreateDDBlock $X $Y udeitem null null null
  .ddBlock config -bg $udeEditor::($OBJ,ddblock_bg_edit)
  wm geom .ddBlock ${width}x${height}+${rootx}+${rooty}
  UI_PB_ude_AddWidgetsIntoBlock $obj
  if 1 {
   if [string match windows $::tcl_platform(platform)] {
    pack propagate [winfo parent $w] 0
    pack forget $w
    } else {
    pack propagate [winfo parent $w] 0
    $w config -relief flat
    __ude_SetItemColor $w
    update
    if 0 { ;# Experiment - Not quite working yet!
     set wi [expr $width  - 4]
     set hi [expr $height - 6]
     set slave [lindex [pack slaves $w] 0]
     if { ![winfo exists $w.cover] } {
      set c [frame $w.cover -width $wi -height $hi -bg $::SystemDisabledText]
      pack $c -before $slave
      } else {
      $w.cover config -height $hi
      pack $w.cover -before $slave
     }
    }
    global env
    set cur "$env(PB_HOME)/images/pb_hand.xbm"
    set msk "$env(PB_HOME)/images/pb_hand.mask"
    $w config -cursor "@$cur $msk black white"
   }
  } ;# if 1
 }

#=======================================================================
proc UI_PB_ude_TopFrameOfItemsMotionBinding {w X Y} {
  global gPB
  set OBJ $udeEditor::(obj)
  if {$gPB(use_info)} {
   return
  }
  if {$udeEditor::($OBJ,drag_drop_enabled) != 1} {
   return
  }
  if 0 {
   if [string match windows $::tcl_platform(platform)] {
    pack propagate [winfo parent $w] 0
    pack forget $w
    } else {
    pack propagate [winfo parent $w] 0
    $w config -relief flat
   }
  }
  set x [expr {$X - $udeEditor::(dx)}]
  set y [expr {$Y - $udeEditor::(dy)}]
  set ddBlock_width [winfo width .ddBlock]
  set ddBlock_height [winfo height .ddBlock]
  set main_window $udeEditor::(main_widget)
  set rootx [winfo rootx $main_window]
  set rooty [winfo rooty $main_window]
  set width [winfo width $main_window]
  set height [winfo height $main_window]
  set bot_height [expr [winfo height $main_window.bottom] + 7]
  set rx [expr {$rootx}]
  set ry [expr {$rooty}]
  set ww [expr {$height - $ddBlock_height - $bot_height}]
  set hh [expr {$width  - $ddBlock_width}]
  if  $udeEditor::($udeEditor::(obj),isPtc) {
   set udeEditor::($udeEditor::(obj),isInDD_ForDelete) 0
   set rx [expr {$rx + $udeEditor::($udeEditor::(obj),left_panel_width)}]
   set hh [expr {$hh - $udeEditor::($udeEditor::(obj),left_panel_width)}]
   } else {
   set udeEditor::($udeEditor::(obj),isInDD_ForDelete) 1
  }
  UI_PB_mthd_MoveDDBlock $x $y udeitem $rx $ry $ww $hh
  set udeEditor::($udeEditor::(obj),isInDD) 1
  UI_PB_ude_Highlighting $X $Y
  UI_PB_ude_autoscroll $X $Y
 }

#=======================================================================
proc UI_PB_ude_autoscroll {X Y} {
  set OBJ $udeEditor::(obj)
  set right_frame $udeEditor::($OBJ,right_frame)
  if {$::tix_version == 8.4} {
   set sb ${right_frame}.yscroll
   } else {
   set sb ${right_frame}.vsb
  }
  if [winfo ismapped $sb] {
   set rooty [winfo rooty $right_frame]
   set height [winfo height $right_frame]
   if {$::tix_version == 8.4} {
    if {$Y < $rooty} {
     ${right_frame}.sf yview scroll -1 units
     } elseif {$Y > [expr $rooty + $height]} {
     ${right_frame}.sf yview scroll 1 units
    }
   }
  }
 }

#=======================================================================
proc UI_PB_ude_TopFrameOfItemsReleaseBinding {w} {
  global gPB
  set OBJ $udeEditor::(obj)
  if {$gPB(use_info)} {
   return
  }
  if {$udeEditor::($OBJ,drag_drop_enabled) != 1} {
   return
  }
  if [string match windows $::tcl_platform(platform)] {
   pack propagate [winfo parent $w] 1
   pack $w -expand yes -fill x -side top -anchor nw
   } else {
   pack propagate [winfo parent $w] 1
   $w config -relief raised
   if { [winfo exists $w.cover] } {
    pack forget $w.cover
   }
   pack $w -expand yes -fill x -side top -anchor nw
   __ude_SetItemColor $w $udeEditor::($OBJ,ddblock_bg_edit)
   update
   $w config -cursor hand2
  }
  if [info exists udeEditor::(dx)] {
   unset udeEditor::(dx)
   unset udeEditor::(dy)
  }
  UI_PB_mthd_DestroyDDBlock
  if $udeEditor::($udeEditor::(obj),isReady) {
   set new_pst [UI_PB_ude_FindLocationForAddingItem]
   set old_pst [UI_PB_ude_FindLocationForAddingItem $w]
   if {![UI_Pb_ude_IsValidForReorderItem $w $new_pst $old_pst]} {
    tk_messageBox -type ok -icon error \
    -message $gPB(ude,editor,group,MSG_NESTED_GROUP)
    } else {
    UI_PB_ude_AdjustItemDataOrderForPaning $new_pst $old_pst
    UI_PB_ude_AdjustItemUIOrder
   }
  }
  if $udeEditor::($udeEditor::(obj),isReadyForDelete) {
   set ui_obj [UI_PB_ude_GetItemObjAccordingToWidget $w]
   UI_PB_ude_DeleteItem $ui_obj
  }
  UI_PB_ude_UnHighlighting
  set udeEditor::($udeEditor::(obj),isInDD) 0
  set udeEditor::($udeEditor::(obj),isInDD_ForDelete) 0
 }

#=======================================================================
proc UI_Pb_ude_IsValidForReorderItem {w new_pst old_pst} {
  if {$new_pst == $old_pst} {return 1}
  set ui_obj [UI_PB_ude_GetItemObjAccordingToWidget $w]
  set ui_type [UI_PB_ude_GetItemTypeAccordingToObj $ui_obj]
  if {[string compare $ui_type "Group"] != 0} {return 1}
  if {$new_pst < $old_pst} {
   set startIndex [expr $new_pst + 1]
   set endIndex $old_pst
   } else {
   set startIndex [expr $old_pst + 1]
   set endIndex [expr $new_pst + 1]
  }
  array set pst_array $udeEditor::($udeEditor::(obj),pst_order)
  for {set index $startIndex} {$index < $endIndex} {incr index} {
   set class_type [classof $pst_array($index)]
   if ![string compare $class_type "::udeEditor::uiGroup"] {
    return 0
   }
  }
  return 1
 }

#=======================================================================
proc UI_PB_ude_AdjustItemDataOrderForPaning {new_pst old_pst} {
  array set old_array $udeEditor::($udeEditor::(obj),pst_order)
  set num [array size old_array]
  if {$new_pst < $old_pst} {
   incr new_pst
  }
  if {$new_pst == $old_pst} {
   for {set idx 0} {$idx < $num} {incr idx} {
    set new_array($idx) $old_array($idx)
   }
   } elseif {$new_pst < $old_pst} {
   for {set idx 0} {$idx < $num} {incr idx} {
    if {$idx < $new_pst} {
     set new_array($idx) $old_array($idx)
     } else {
     if {$idx < $old_pst} {
      set new_array([expr {$idx + 1}]) $old_array($idx)
      } elseif {$idx == $old_pst} {
      set new_array($new_pst) $old_array($idx)
      } else {
      set new_array($idx) $old_array($idx)
     }
    }
   }
   } else {
   for {set idx 0} {$idx < $num} {incr idx} {
    if {$idx < $old_pst} {
     set new_array($idx) $old_array($idx)
     } elseif {$idx == $old_pst} {
     set new_array($new_pst) $old_array($idx)
     } else {
     if {$idx <= $new_pst} {
      set new_array([expr {$idx - 1}]) $old_array($idx)
      } else {
      set new_array($idx) $old_array($idx)
     }
    }
   }
  }
  set udeEditor::($udeEditor::(obj),pst_order) [array get new_array]
 }

#=======================================================================
proc UI_PB_ude_BotFrameOfItemsEnterBinding {w} {
  if [expr $udeEditor::($udeEditor::(obj),isInDD)] {
   focus $w
   set udeEditor::($udeEditor::(obj),current_hlWidget) $w
   set udeEditor::($udeEditor::(obj),insert_position_w) $w
   set udeEditor::($udeEditor::(obj),isReady) 1
  }
 }

#=======================================================================
proc UI_PB_ude_BotFrameOfItemsLeaveBinding {w} {
  if [expr $udeEditor::($udeEditor::(obj),isInDD)] {
   focus [winfo toplevel $w]
   set udeEditor::($udeEditor::(obj),current_hlWidget) ""
   set udeEditor::($udeEditor::(obj),isReady) 0
  }
 }

#=======================================================================
proc UI_PB_ude_CreateDlgForEditUde {topframe midframe udeevent} {
  global gPB env
  set OBJ $udeEditor::(obj)
  if ![string compare $udeEditor::($OBJ,ueo_ui_label) ""] {
   set udeEditor::($OBJ,label_text) $udeEditor::($OBJ,ueo_name)
   }   else {
   set udeEditor::($OBJ,label_text) $udeEditor::($OBJ,ueo_ui_label)
  }
  set udename [button $topframe.name -textvariable udeEditor::($OBJ,label_text) \
  -state disabled  -cursor hand2 \
  -disabledforeground $udeEditor::($OBJ,title_fg) \
  -font $gPB(bold_font) -relief flat -height 1 \
  -bg $udeEditor::($OBJ,title_bg)]
  bind $udename <Enter> {UI_PB_ude_EditUde_EL %W Enter}
  bind $udename <Leave> {UI_PB_ude_EditUde_EL %W Leave}
  pack $udename -expand yes -fill both -pady 5 -padx 10
  bind $udename <Button-1>  "UI_PB_ude_EventPopupMenu %W %X %Y"
  if { $udeEditor::($OBJ,TYPE) == "UDE" || $gPB(enable_helpdesc_for_udc) } {
   set hlpframe $udeEditor::($OBJ,hlpframe)
   set hlp_lbl  [label $hlpframe.lbl \
   -textvariable udeEditor::($OBJ,ueo_help_descript) \
   -bg $udeEditor::($OBJ,title_bg) \
   -font $gPB(bold_font)]
   set hlp_img [tix getimage pb_event_help]
   set hlp_btn [button $hlpframe.btn -image $hlp_img -command "UI_PB_ude_OpenUrl"]
   pack $hlp_lbl -side left -padx 10 -ipady 7
   pack $hlp_btn -side right -padx 10
   UI_PB_ude_DisplayUdeHelpWidgets
  }
  global last_sys_ude_item
  set last_sys_ude_item ""
  if {$udeEditor::($OBJ,TYPE) == "UDE"} {
   set param_obj_list $ude_event::($udeevent,param_obj_list)
   } else {
   set param_obj_list $cycle_event::($udeevent,param_obj_list)
  }
  set num [llength $param_obj_list]
  foreach param_obj $param_obj_list {
   UI_PB_ude_AddItems $param_obj $num
  }
  if ![string match "" $last_sys_ude_item] \
  {
   lappend udeEditor::($OBJ,hlWidgets) $last_sys_ude_item
   set last_sys_ude_item ""
  }
  set gPB(c_help,$udename) "ude,editor,event"
 }

#=======================================================================
proc UI_PB_ude_DisplayUdeHelpWidgets { args } {
  global gPB_help_tips
  set OBJ $udeEditor::(obj)
  if { ![info exists udeEditor::($OBJ,hlpframe)] } \
  {
   return
  }
  set hlpframe $udeEditor::($OBJ,hlpframe)
  set hlp_btn $hlpframe.btn
  set hlp_lbl $hlpframe.lbl
  set hlp_desc $udeEditor::($OBJ,ueo_help_descript)
  set hlp_url  $udeEditor::($OBJ,ueo_help_url)
  if [llength $args] \
  {
   $hlp_lbl config -textvariable udeEditor::($OBJ,temp_ueo_help_descript)
   if $udeEditor::($OBJ,exist_ueo_help_descript) \
   {
    set hlp_desc "test"
   } else \
   {
    set hlp_desc ""
    PB_disable_balloon $hlp_btn
    pack forget $hlpframe
    update
    return
   }
  } else \
  {
   $hlp_lbl config -textvariable udeEditor::($OBJ,ueo_help_descript)
  }
  if { [string match "" $hlp_desc] && [string match "" $hlp_url] } \
  {
   PB_disable_balloon $hlp_btn
   pack forget $hlpframe
   } elseif { [string match "" $hlp_url] } \
  {
   PB_disable_balloon $hlp_btn
   if ![winfo ismapped $hlpframe] \
   {
    pack $hlpframe -side top -after $udeEditor::($OBJ,midframe) -expand yes -fill both -pady 1
   }
   if [winfo ismapped $hlp_btn] \
   {
    pack forget $hlp_btn
   }
   update
  } else \
  {
   PB_enable_balloon $hlp_btn
   set hlp_url $udeEditor::($OBJ,ueo_help_url)
   set gPB_help_tips($hlp_btn) $hlp_url
   pack $hlp_lbl -side left -padx 10 -ipady 7
   pack $hlp_btn -side right -padx 10
   pack  $hlpframe -side top -after $udeEditor::($OBJ,midframe) -expand yes -fill both -pady 1
   update
  }
 }

#=======================================================================
proc UI_PB_ude_EditUde_EL {w type} {
  global gPB
  set OBJ $udeEditor::(obj)
  if {$udeEditor::($OBJ,drag_drop_enabled) != 1} {
   return
   } else {
   if {$type == "Enter"} {
    if {$gPB(use_info)} {
     $w config -cursor question_arrow
    }
    $w config -bg $udeEditor::($OBJ,title_highlight)
    $w config -relief raised
    } else {
    $w config -cursor hand2
    $w config -bg $udeEditor::($OBJ,title_bg)
    $w config -relief flat
   }
  }
 }

#=======================================================================
proc UI_PB_ude_EventPopupMenu {w x y} {
  global post_object
  global gPB
  set OBJ $udeEditor::(obj)
  if {$gPB(use_info)} {
   return
  }
  if {$udeEditor::($OBJ,drag_drop_enabled) != 1} {
   return
  }
  if {$udeEditor::($OBJ,TYPE) == "UDE"} {
   set udeobj $Post::($post_object,ude_obj)
   set seqobj $ude::($udeobj,seq_obj)
   set non_mc_evt_obj_list $sequence::($seqobj,evt_obj_list)
   set is_non_mc_evt 1
   set cur_evt_obj $udeEditor::(event_obj)
   if {[lsearch $non_mc_evt_obj_list $cur_evt_obj] < "0"} {
    set is_non_mc_evt 0
   }
   UI_PB_ude_EditUdeEvent $is_non_mc_evt $w
   } else {
   UI_PB_cycle_EditCycleEvent $w
  }
 }

#=======================================================================
proc UI_PB_ude_EditUdeEvent {is_non_mc_evt w} {
  global gPB machType
  set type [string tolower $machType]
  if ![string compare $type "wire edm"] {
   set type "wedm"
  }
  set OBJ $udeEditor::(obj)
  set cur_ude_event_obj $udeEditor::(ude_event_obj)
  set udeEditor::($OBJ,temp_ueo_name)       $udeEditor::($OBJ,ueo_name)
  set udeEditor::($OBJ,temp_ueo_post_event) $udeEditor::($OBJ,ueo_post_event)
  set udeEditor::($OBJ,temp_ueo_ui_label)   $udeEditor::($OBJ,ueo_ui_label)
  set udeEditor::($OBJ,temp_ueo_category)   $udeEditor::($OBJ,ueo_category)
  set udeEditor::($OBJ,temp_ueo_help_descript) $udeEditor::($OBJ,ueo_help_descript)
  set udeEditor::($OBJ,temp_ueo_help_url) $udeEditor::($OBJ,ueo_help_url)
  if { [string match "" $udeEditor::($OBJ,ueo_help_descript)] && \
  [string match "" $udeEditor::($OBJ,ueo_help_url)] } \
  {
   set udeEditor::($OBJ,exist_ueo_help_descript) 0
   if [info exists ude_event::($cur_ude_event_obj,prev_exist_ueo_help_descript)] {
    set udeEditor::($OBJ,exist_ueo_help_descript) \
    $ude_event::($cur_ude_event_obj,prev_exist_ueo_help_descript)
    set udeEditor::($OBJ,temp_ueo_help_descript) \
    $ude_event::($cur_ude_event_obj,prev_temp_ueo_help_descript)
    set udeEditor::($OBJ,temp_ueo_help_url) \
    $ude_event::($cur_ude_event_obj,prev_temp_ueo_help_url)
   }
  } else \
  {
   set udeEditor::($OBJ,exist_ueo_help_descript) 1
  }
  if ![string compare $udeEditor::($OBJ,temp_ueo_post_event) ""] {
   set udeEditor::($OBJ,exist_ueo_post_event) 0
   if [info exists ude_event::($cur_ude_event_obj,prev_exist_ueo_post_event)] {
    set udeEditor::($OBJ,exist_ueo_post_event) \
    $ude_event::($cur_ude_event_obj,prev_exist_ueo_post_event)
    set udeEditor::($OBJ,temp_ueo_post_event) \
    $ude_event::($cur_ude_event_obj,prev_temp_ueo_post_event)
   }
   } else {
   set udeEditor::($OBJ,exist_ueo_post_event) 1
  }
  if ![string compare $udeEditor::($OBJ,temp_ueo_ui_label) ""] {
   set udeEditor::($OBJ,exist_ueo_ui_label) 0
   if [info exists ude_event::($cur_ude_event_obj,prev_exist_ueo_ui_label)] {
    set udeEditor::($OBJ,exist_ueo_ui_label) \
    $ude_event::($cur_ude_event_obj,prev_exist_ueo_ui_label)
    set udeEditor::($OBJ,temp_ueo_ui_label) \
    $ude_event::($cur_ude_event_obj,prev_temp_ueo_ui_label)
   }
   } else {
   set udeEditor::($OBJ,exist_ueo_ui_label) 1
  }
  if {![string compare $udeEditor::($OBJ,temp_ueo_category) ""] || \
   ![string compare $udeEditor::($OBJ,temp_ueo_category) {{}}]} {
   set udeEditor::($OBJ,exist_ueo_category) 0
   set udeEditor::($OBJ,exist_ueo_category_mill) 1
   set udeEditor::($OBJ,exist_ueo_category_drill) 1
   set udeEditor::($OBJ,exist_ueo_category_lathe) 1
   set udeEditor::($OBJ,exist_ueo_category_wedm) 1
   } else {
   set udeEditor::($OBJ,exist_ueo_category) 1
   set temp [string toupper $udeEditor::($OBJ,temp_ueo_category)]
   if {[lsearch $temp "MILL"] != "-1"} {
    set udeEditor::($OBJ,exist_ueo_category_mill) 1
    } else {
    set udeEditor::($OBJ,exist_ueo_category_mill) 0
   }
   if {[lsearch $temp "DRILL"] != "-1"} {
    set udeEditor::($OBJ,exist_ueo_category_drill) 1
    } else {
    set udeEditor::($OBJ,exist_ueo_category_drill) 0
   }
   if {[lsearch $temp "LATHE"] != "-1"} {
    set udeEditor::($OBJ,exist_ueo_category_lathe) 1
    } else {
    set udeEditor::($OBJ,exist_ueo_category_lathe) 0
   }
   if {[lsearch $temp "WEDM"] != "-1"} {
    set udeEditor::($OBJ,exist_ueo_category_wedm) 1
    } else {
    set udeEditor::($OBJ,exist_ueo_category_wedm) 0
   }
  }
  set udeevent_main [toplevel $udeEditor::(main_widget).param]
  bind all <Enter> ""
  set udeEditor::($OBJ,drag_drop_enabled) 0
  bind $udeevent_main <Destroy> \
  "+ set udeEditor::($OBJ,drag_drop_enabled) 1;\
  $w config -bg $udeEditor::($OBJ,title_bg);\
  $w config -relief flat"
  set rootx [winfo rootx $udeEditor::(main_widget)]
  set rooty [winfo rooty $udeEditor::(main_widget)]
  set x [expr {$rootx - 10}]
  set y [expr {$rooty + 10}]
  set geom +${x}+${y}
  wm resizable $udeevent_main 1 1
  UI_PB_com_CreateTransientWindow $udeevent_main $gPB(ude,editor,EDIT) \
  $geom "" "" "" ""
  focus $udeevent_main
  wm protocol $udeevent_main WM_DELETE_WINDOW \
  "UI_PB_ude_DeleteWindow $udeevent_main"
  set topframe [frame $udeevent_main.top -bd 1 -relief sunken]
  set bottomframe [frame $udeevent_main.bottom]
  set f1 [frame $topframe.1]
  set f1_f [UI_PB_com_AddSeparator $topframe.1f]
  set f2 [frame $topframe.2]
  set f2_f [UI_PB_com_AddSeparator $topframe.2f]
  set f3 [frame $topframe.3]
  set f3_f [UI_PB_com_AddSeparator $topframe.3f]
  set f4 [frame $topframe.4]
  set f5 [frame $f4.top]
  set f6 [frame $f4.bot]
  set name_l [label $f1.l -text $gPB(ude,editor,eventdlg,EN,Label) -font $gPB(bold_font)]
  set name_e [entry $f1.e -textvariable udeEditor::($OBJ,temp_ueo_name) \
  -width 28]
  set gPB(c_help,$name_e) "ude,editor,eventdlg,EN"
  bind $name_e <KeyPress>      " UI_PB_com_DisableSpecialChars %W %K"
  bind $name_e <KeyPress>      "+UI_PB_com_RestrictStringLength %W %K"
  bind $name_e <Control-Key-v> " UI_PB_com_Validate_Control_V %W %K %A"
  bind $name_e <KeyRelease>    " UI_PB_com_Validate_Control_V_Release %W"
  set pname_tf [frame $f2.tf]
  set pname_l [label $pname_tf.l -text $gPB(ude,editor,eventdlg,PEN,Label) -font $gPB(bold_font)]
  set pname_e [entry $f2.e -width 12 \
  -textvariable udeEditor::($OBJ,temp_ueo_post_event)]
  set pname_c [checkbutton $pname_tf.c \
  -variable udeEditor::($OBJ,exist_ueo_post_event) \
  -command "UI_PB_ude_ShiftState \
  udeEditor::($OBJ,exist_ueo_post_event) $pname_e"]
  bind $pname_e <KeyPress> "UI_PB_com_DisableSpecialChars %W %K 1"
  bind $pname_e <KeyRelease> \
  {if {$udeEditor::($udeEditor::(obj),exist_ueo_post_event)} \
   {%W config -state normal}}
   bind $pname_e <KeyPress>      "+UI_PB_com_RestrictStringLength %W %K"
   bind $pname_e <Control-Key-v> " UI_PB_com_Validate_Control_V %W %K %A"
   bind $pname_e <KeyRelease>    "+UI_PB_com_Validate_Control_V_Release %W"
   set gPB(c_help,$pname_e) "ude,editor,eventdlg,PEN"
   set gPB(c_help,$pname_c) "ude,editor,eventdlg,PEN,C"
   set label_tf [frame $f3.tf]
   set label_l [label $label_tf.l -text $gPB(ude,editor,eventdlg,EL,Label) -font $gPB(bold_font)]
   set label_e [entry $f3.e -textvariable udeEditor::($OBJ,temp_ueo_ui_label) \
   -width 12]
   set label_c [checkbutton $label_tf.c \
   -variable udeEditor::($OBJ,exist_ueo_ui_label) \
   -command "UI_PB_ude_ShiftState \
   udeEditor::($OBJ,exist_ueo_ui_label) $label_e"]
   set gPB(c_help,$label_e) "ude,editor,eventdlg,EL"
   set gPB(c_help,$label_c) "ude,editor,eventdlg,EL,C"
   set ctg_l   [label $f5.l -text $gPB(ude,editor,eventdlg,EC,Label) -font $gPB(bold_font)]
   set ctg_c   [checkbutton $f5.c \
   -variable udeEditor::($OBJ,exist_ueo_category)]
   set gPB(c_help,$ctg_c)   "ude,editor,eventdlg,EC"
   set top_f6 [frame $f6.top]
   set bot_f6 [frame $f6.bot]
   set ctg_mill_c [checkbutton $top_f6.mill \
   -text $gPB(ude,editor,eventdlg,EC_MILL,Label) \
   -variable udeEditor::($OBJ,exist_ueo_category_mill)]
   set ctg_drill_c [checkbutton $top_f6.drill \
   -text $gPB(ude,editor,eventdlg,EC_DRILL,Label) \
   -variable udeEditor::($OBJ,exist_ueo_category_drill)]
   set ctg_lathe_c [checkbutton $bot_f6.lathe \
   -text $gPB(ude,editor,eventdlg,EC_LATHE,Label) \
   -variable udeEditor::($OBJ,exist_ueo_category_lathe)]
   set ctg_wedm_c  [checkbutton $bot_f6.wedm \
   -text $gPB(ude,editor,eventdlg,EC_WEDM,Label) \
   -variable udeEditor::($OBJ,exist_ueo_category_wedm)]
   set gPB(c_help,$ctg_mill_c)  "ude,editor,eventdlg,EC_MILL"
   set gPB(c_help,$ctg_drill_c) "ude,editor,eventdlg,EC_DRILL"
   set gPB(c_help,$ctg_lathe_c) "ude,editor,eventdlg,EC_LATHE"
   set gPB(c_help,$ctg_wedm_c)  "ude,editor,eventdlg,EC_WEDM"
   set cur_ude_name $ude_event::($cur_ude_event_obj,name)
   switch -exact $type {
    "mill" {
     if { [lsearch $gPB(MC_ude,MILL) "$cur_ude_name"] != "-1" } {
      $ctg_mill_c config \
      -command [list UI_PB_ude_Disable_ShiftState $ctg_mill_c]
     }
    }
    "lathe" {
     if { [lsearch $gPB(MC_ude,LATHE) "$cur_ude_name"] != "-1" } {
      $ctg_lathe_c config \
      -command [list UI_PB_ude_Disable_ShiftState $ctg_lathe_c]
     }
    }
    "wedm" {
     $ctg_wedm_c config \
     -command [list UI_PB_ude_Disable_ShiftState $ctg_wedm_c]
    }
   }
   $ctg_c config -command "UI_PB_ude_ShiftState \
   udeEditor::($OBJ,exist_ueo_category) \
   $ctg_mill_c $ctg_drill_c $ctg_lathe_c $ctg_wedm_c"
   set fa1 [frame $topframe.a1]
   set fa1_f [UI_PB_com_AddSeparator $topframe.a1f]
   set discript_state disabled ;#<05-07-09 gsl> was disable
   set url_state disabled ;#<05-07-09 gsl> was disable
   if { $udeEditor::($OBJ,exist_ueo_help_descript) == 1 } {
    set discript_state normal
    set url_state normal
   }
   set help_tf [frame $fa1.tf]
   set help_topl [label $help_tf.l -text $gPB(ude,editor,eventdlg,DESC,Label) -font $gPB(bold_font)]
   set help_tope [entry $fa1.te -textvariable udeEditor::($OBJ,temp_ueo_help_descript) \
   -state $discript_state -width 12]
   set help_bf [frame $fa1.bf]
   set help_btml [label $help_bf.l -text $gPB(ude,editor,eventdlg,URL,Label) -font $gPB(bold_font)]
   set help_btme [entry $fa1.be -textvariable udeEditor::($OBJ,temp_ueo_help_url) \
   -state $url_state -width 12]
   set help_topc [checkbutton $help_tf.c \
   -variable udeEditor::($OBJ,exist_ueo_help_descript) \
   -command "UI_PB_ude_DisplayUdeHelpWidgets 1; UI_PB_ude_ShiftState \
   udeEditor::($OBJ,exist_ueo_help_descript) $help_tope $help_btme"]
   set gPB(c_help,$help_tope) "ude,editor,eventdlg,DESC"
   set gPB(c_help,$help_btme) "ude,editor,eventdlg,URL"
   set name_list {"gPB(nav_button,ok,Label)" "gPB(nav_button,cancel,Label)"}
   set cb_arr(gPB(nav_button,ok,Label)) ""
   set cb_arr(gPB(nav_button,cancel,Label)) ""
   UI_PB_com_CreateButtonBox $bottomframe name_list cb_arr
   ${bottomframe}.box.act_0 config  \
   -command "UI_PB_ude_UdeEventOK $udeevent_main"
   ${bottomframe}.box.act_1 config  \
   -command "UI_PB_ude_UdeEventCNL $udeevent_main"
   if ![string compare $::tix_version 8.4] {
    pack $bottomframe -side bottom -fill x -pady 2 -padx 2
    } else {
    pack $bottomframe -side bottom -fill x -pady 3 -padx 2
   }
   pack $topframe -side top -expand yes -fill both -pady 5 -padx 2
   pack $f1 $f1_f $f2 $f2_f $f3 $f3_f $fa1 $fa1_f -side top -fill x -pady 2 -padx 5
   pack $f4 -side top -expand no -fill x -pady 10 -padx 5
   pack $f5 $f6 -side top -expand yes -fill x -pady 1
   pack $top_f6 $bot_f6 -side left -expand yes -fill x -pady 1
   pack $name_l -side top -anchor w
   pack $name_e -fill x -pady 10 -padx 5
   pack $pname_c $pname_l -side left
   pack $pname_tf -side top -fill x
   pack $pname_e -fill x -pady 10 -padx 5
   pack $label_c $label_l -side left
   pack $label_tf -side top -fill x
   pack $label_e -fill x -pady 10 -padx 5
   pack $help_topc $help_topl -side left
   pack $help_tf -side top -fill x
   pack $help_tope -fill x -pady 10 -padx 5
   pack $help_btml -side left
   pack $help_bf -side top -fill x
   pack $help_btme -fill x -pady 10 -padx 5
   pack $ctg_c $ctg_l -side left
   if ![string compare $::tix_version 8.4] {
    pack $ctg_mill_c -side top -padx 15 -anchor w
    pack $ctg_drill_c -side bottom -padx 15 -anchor w
    pack $ctg_lathe_c -side top -padx 0 -anchor w
    pack $ctg_wedm_c -side bottom -padx 0 -anchor w
    } else {
    pack $ctg_mill_c -side top -padx 25 -anchor w
    pack $ctg_drill_c -side bottom -padx 25 -anchor w
    pack $ctg_lathe_c -side top -padx 0 -anchor w
    pack $ctg_wedm_c -side bottom -padx 0 -anchor w
   }
   if {$udeEditor::($OBJ,exist_ueo_post_event) == 0} {
    if ![string compare $::tix_version 8.4] {
     $pname_e config -state disabled
     } else {
     $pname_e config -state disabled -bg lightblue
    }
   }
   if {$udeEditor::($OBJ,exist_ueo_ui_label) == 0} {
    if ![string compare $::tix_version 8.4] {
     $label_e config -state disabled
     } else {
     $label_e config -state disabled -bg lightblue
    }
   }
   if {$udeEditor::($OBJ,exist_ueo_category) == 0} {
    $ctg_mill_c config -state disabled
    $ctg_drill_c config -state disabled
    $ctg_lathe_c config -state disabled
    $ctg_wedm_c config -state disabled
   }
   if {$udeEditor::($OBJ,exist_ueo_help_descript) == 0} {
    if ![string compare $::tix_version 8.4] {
     $help_tope config -state disabled
     $help_btme config -state disabled
     } else {
     $help_tope config -state disabled -bg lightblue
     $help_btme config -state disabled -bg lightblue
    }
   }
   UI_PB_ude_DisplayUdeHelpWidgets 1
   if {$is_non_mc_evt == 0} {
    if ![string compare $::tix_version 8.4] {
     $name_e config -state disabled
     $pname_c config -state disabled
     $pname_e config -state disabled
     } else {
     $name_e config -state disabled -bg lightblue
     $pname_c config -state disabled
     $pname_e config -state disabled -bg lightblue
    }
   }
  }

#=======================================================================
proc UI_PB_ude_ShiftState {VAR args} {
  upvar $VAR var
  if {$var == 0} {
   if {[llength $args] >= 1} {
    foreach arg $args {
     $arg config -state disabled
     if ![string compare $::tix_version 4.1] {
      if {[winfo class $arg] == "Entry"} {
       $arg config -bg lightblue
      }
     }
    }
   }
   } else {
   if {[llength $args] >= 1} {
    foreach arg $args {
     $arg config -state normal
     if ![string compare $::tix_version 4.1] {
      if {[winfo class $arg] == "Entry"} {
       $arg config -bg $::SystemWindow
      }
     }
    }
   }
  }
 }

#=======================================================================
proc UI_PB_ude_UdeEventOK {w} {
  global gPB post_object
  global machType   ;#<12-08-10 wbh>
  tk_focusFollowsMouse
  set OBJ $udeEditor::(obj)
  set cur_ude_event_obj $udeEditor::(ude_event_obj)
  set udeobj $Post::($post_object,ude_obj)
  set eventname $udeEditor::($OBJ,temp_ueo_name)
  if ![string compare $eventname ""] {
   tk_messageBox -message $gPB(ude,editor,popup,MSG_BLANK) -icon error \
   -title $gPB(msg,error) -parent [UI_PB_com_AskActiveWindow]
   return
  }
  set event_obj_list $ude::($udeobj,event_obj_list)
  foreach obj $event_obj_list {
   if ![string compare $eventname $ude_event::($obj,name)] {
    if {$obj != $cur_ude_event_obj} {
     tk_messageBox -message $gPB(ude,editor,popup,MSG_SAMENAME) -icon error \
     -title $gPB(msg,error) -parent [UI_PB_com_AskActiveWindow]
     return
    }
   }
  }
  if {$udeEditor::($OBJ,exist_ueo_post_event) == 1} {
   set handler_name MOM_$udeEditor::($OBJ,temp_ueo_post_event)
   } else {
   set handler_name MOM_$udeEditor::($OBJ,temp_ueo_name)
  }
  if {$ude_event::($cur_ude_event_obj,post_event) == ""} {
   set cur_handler_name MOM_$ude_event::($cur_ude_event_obj,name)
   } else {
   set cur_handler_name MOM_$ude_event::($cur_ude_event_obj,post_event)
  }
  if {[lsearch $gPB(MOM_func,SYS) $handler_name] >= 0} {
   if ![string match $handler_name $cur_handler_name] {
    tk_messageBox -message "$handler_name : $gPB(ude,editor,popup,MSG_SameHandler)" \
    -icon error \
    -title $gPB(msg,error) -parent [UI_PB_com_AskActiveWindow]
    return
   }
  }
  set is_validate $udeEditor::($OBJ,exist_ueo_help_descript)
  set str_desc $udeEditor::($OBJ,temp_ueo_help_descript)
  set str_url $udeEditor::($OBJ,temp_ueo_help_url)
  if { [UI_PB_ude_ValidateDescAndUrlWidgets $is_validate $str_desc $str_url] } \
  {
   return
  }
  set type [string tolower $machType]
  if { [string match "mill" $type] || [string match "lathe" $type] } {
   if { $udeEditor::($OBJ,exist_ueo_category) == 1 && \
    $udeEditor::($OBJ,exist_ueo_category_wedm) == 1 } {
    set allow_flag 0
    if { $udeEditor::($OBJ,exist_ueo_category_mill) == 1 } {
     set allow_flag 1
     } elseif { $udeEditor::($OBJ,exist_ueo_category_lathe) == 1 } {
     set allow_flag 1
     } elseif { $udeEditor::($OBJ,exist_ueo_category_drill) == 1 } {
     set allow_flag 1
    }
    if { !$allow_flag } {
     tk_messageBox -message $gPB(ude,editor,popup,MSG_CATEGORY) -icon error \
     -title $gPB(msg,error) -parent [UI_PB_com_AskActiveWindow]
     return
    }
   }
  }
  destroy $w
  set ude_event::($cur_ude_event_obj,prev_exist_ueo_post_event) \
  $udeEditor::($OBJ,exist_ueo_post_event)
  set ude_event::($cur_ude_event_obj,prev_temp_ueo_post_event) \
  $udeEditor::($OBJ,temp_ueo_post_event)
  set ude_event::($cur_ude_event_obj,prev_exist_ueo_ui_label) \
  $udeEditor::($OBJ,exist_ueo_ui_label)
  set ude_event::($cur_ude_event_obj,prev_temp_ueo_ui_label) \
  $udeEditor::($OBJ,temp_ueo_ui_label)
  set ude_event::($cur_ude_event_obj,prev_exist_ueo_help_descript) \
  $udeEditor::($OBJ,exist_ueo_help_descript)
  set ude_event::($cur_ude_event_obj,prev_temp_ueo_help_descript) \
  $udeEditor::($OBJ,temp_ueo_help_descript)
  set ude_event::($cur_ude_event_obj,prev_temp_ueo_help_url) \
  $udeEditor::($OBJ,temp_ueo_help_url)
  set udeEditor::($OBJ,ueo_name) $udeEditor::($OBJ,temp_ueo_name)
  if {$udeEditor::($OBJ,exist_ueo_post_event) == 1} {
   set udeEditor::($OBJ,ueo_post_event) \
   $udeEditor::($OBJ,temp_ueo_post_event)
   } else {
   set udeEditor::($OBJ,ueo_post_event) ""
   set udeEditor::($OBJ,temp_ueo_post_event) ""
  }
  if {$udeEditor::($OBJ,exist_ueo_ui_label) == 1} {
   set udeEditor::($OBJ,ueo_ui_label)   \
   $udeEditor::($OBJ,temp_ueo_ui_label)
   } else {
   set udeEditor::($OBJ,ueo_ui_label) ""
   set udeEditor::($OBJ,temp_ueo_ui_label) ""
  }
  if {$udeEditor::($OBJ,exist_ueo_help_descript) == 1} {
   set udeEditor::($OBJ,ueo_help_descript)   \
   $udeEditor::($OBJ,temp_ueo_help_descript)
   set udeEditor::($OBJ,ueo_help_url)   \
   $udeEditor::($OBJ,temp_ueo_help_url)
   } else {
   set udeEditor::($OBJ,ueo_help_descript) ""
   set udeEditor::($OBJ,temp_ueo_help_descript) ""
   set udeEditor::($OBJ,ueo_help_url) ""
   set udeEditor::($OBJ,temp_ueo_help_url) ""
  }
  UI_PB_ude_DisplayUdeHelpWidgets
  if {$udeEditor::($OBJ,ueo_ui_label) == ""} {
   set udeEditor::($OBJ,label_text) $udeEditor::($OBJ,ueo_name)
   } else {
   set udeEditor::($OBJ,label_text) $udeEditor::($OBJ,ueo_ui_label)
  }
  set temp [list]
  if {$udeEditor::($OBJ,exist_ueo_category) == 1} {
   if {$udeEditor::($OBJ,exist_ueo_category_mill) == 1} {
    lappend temp "MILL"
   }
   if {$udeEditor::($OBJ,exist_ueo_category_drill) == 1} {
    lappend temp "DRILL"
   }
   if {$udeEditor::($OBJ,exist_ueo_category_lathe) == 1} {
    lappend temp "LATHE"
   }
   if {$udeEditor::($OBJ,exist_ueo_category_wedm) == 1} {
    lappend temp "WEDM"
   }
  }
  set udeEditor::($OBJ,ueo_category) $temp
  set udeEditor::($OBJ,temp_ueo_category) $temp
 }

#=======================================================================
proc UI_PB_ude_ValidateDescAndUrlWidgets { flag desc url } {
  global gPB
  set ret_code 0
  if !$flag { return $ret_code }
  if { [string match "" $desc] || [string match "" $url] } \
  {
   tk_messageBox -message $gPB(ude,editor,popup,MSG_BLANK_HELP_INFO) \
   -icon error -title $gPB(msg,error) \
   -parent [UI_PB_com_AskActiveWindow]
   set ret_code 1
   return $ret_code
  }
  set temp_url [string tolower $url]
  if { ![string match "http://*" $temp_url] && \
  ![string match "file://*" $temp_url] } \
  {
   tk_messageBox -message $gPB(ude,editor,popup,MSG_URL_FORMAT) \
   -icon error -title $gPB(msg,error) \
   -parent [UI_PB_com_AskActiveWindow]
   set ret_code 1
   } elseif { [string first "\\" $temp_url] >= 0 } \
  {
   tk_messageBox -message $gPB(ude,editor,popup,MSG_URL_FORMAT) \
   -icon error -title $gPB(msg,error) \
   -parent [UI_PB_com_AskActiveWindow]
   set ret_code 1
  }
  return $ret_code
 }

#=======================================================================
proc UI_PB_ude_UdeEventCNL {w} {
  destroy $w
  tk_focusFollowsMouse
  UI_PB_ude_DisplayUdeHelpWidgets
 }

#=======================================================================
proc UI_PB_ude_TypeWidgetBinding {w type} {
  set childlist [winfo child $w]
  foreach child $childlist {
   bind $child <Button-1> {event generate [winfo parent %W] \
   <Button-1> -rootx %X -rooty %Y}
   bind $child <ButtonRelease-1> {event generate [winfo parent %W] \
   <ButtonRelease-1>}
   bind $child <B1-Motion> {event generate [winfo parent %W] \
   <B1-Motion> -rootx %X -rooty %Y}
  }
  bind $w <Enter> {UI_PB_ude_TypeWidget_EL %W Enter}
  bind $w <Leave> {UI_PB_ude_TypeWidget_EL %W Leave}
  bind $w <Button-1> "UI_PB_ude_StartDragItem %W $type %X %Y"
  bind $w <ButtonRelease-1> "UI_PB_ude_EndDragItem %W $type"
  bind $w <B1-Motion> "UI_PB_ude_DragItem %X %Y"
 }

#=======================================================================
proc UI_PB_ude_TypeWidget_EL {w type} {
  set OBJ $udeEditor::(obj)
  if {$udeEditor::($OBJ,drag_drop_enabled) != 1} {
   return
   } else {
   if {$type == "Enter"} {
    $w config -highlightbackground $udeEditor::($OBJ,type_hl_fg)
    } else {
    $w config -highlightbackground $udeEditor::($OBJ,type_hl_bg)
   }
  }
 }

#=======================================================================
proc UI_PB_ude_StartDragItem {w type X Y} {
  global gPB
  set OBJ $udeEditor::(obj)
  if {$gPB(use_info)} {
   return
  }
  if {$udeEditor::($OBJ,drag_drop_enabled) != 1} {
   return
  }
  $w config -relief sunken
  UI_PB_mthd_CreateDDBlock $X $Y udeblock null null null
  .ddBlock config -bg $udeEditor::($OBJ,ddblock_bg_new)
  switch -exact $type {
   Integer -
   Real    {
    if { $::tix_version == 8.4 } {
     wm geom .ddBlock 180x54+[expr {$X - 90}]+[expr {$Y - 20}]
     } else {
     wm geom .ddBlock 180x50+[expr {$X - 90}]+[expr {$Y - 20}]
    }
   }
   Text    {
    if { $::tix_version == 8.4 } {
     wm geom .ddBlock 180x82+[expr {$X - 90}]+[expr {$Y - 20}]
     } else {
     wm geom .ddBlock 180x74+[expr {$X - 90}]+[expr {$Y - 20}]
    }
   }
   Boolean {
    wm geom .ddBlock 180x40+[expr {$X - 90}]+[expr {$Y - 20}]
   }
   Option  {
    wm geom .ddBlock 180x42+[expr {$X - 90}]+[expr {$Y - 20}]
   }
   Point   -
   Vector  {
    if { $::tix_version == 8.4 } {
     wm geom .ddBlock 180x84+[expr {$X - 90}]+[expr {$Y - 28}]
     } else {
     wm geom .ddBlock 180x76+[expr {$X - 90}]+[expr {$Y - 28}]
    }
   }
   Bitmap  {
    wm geom .ddBlock 180x42+[expr {$X - 90}]+[expr {$Y - 20}]
   }
   Group   {
    wm geom .ddBlock 180x42+[expr {$X - 90}]+[expr {$Y - 20}]
   }
   default {}
  }
  switch -exact $type {
   Integer {
    set topFrm [frame .ddBlock.top -bg $udeEditor::($OBJ,ddblock_bg_new)]
    set btmFrm [frame .ddBlock.btm -bg $udeEditor::($OBJ,ddblock_bg_new)]
    pack $topFrm -side top -anchor w
    pack $btmFrm -fill x
    set toggleFrame [frame $topFrm.tf -bd 3 \
    -width 13 -height 13 -relief sunken \
    -bg $udeEditor::($OBJ,ckb_bg)]
    set typelabel [label $btmFrm.l \
    -text $gPB(ude,editor,int,Label) \
    -fg $udeEditor::($OBJ,ddblock_fg_new) \
    -bg $udeEditor::($OBJ,ddblock_bg_new)]
    set entryFrame [frame $btmFrm.ef -bd 2 -width 70 \
    -height 20 -relief sunken \
    -bg $udeEditor::($OBJ,type_widget_bg)]
    set statuslabel [label $topFrm.s \
    -text $gPB(ude,editor,status_label) \
    -fg $udeEditor::($OBJ,ddblock_fg_new) \
    -bg $udeEditor::($OBJ,ddblock_bg_new)]
    pack $toggleFrame $statuslabel -side left -padx 5
    pack $typelabel -side left -padx 5
    pack $entryFrame -side right -padx 5
   }
   Real    {
    set topFrm [frame .ddBlock.top -bg $udeEditor::($OBJ,ddblock_bg_new)]
    set btmFrm [frame .ddBlock.btm -bg $udeEditor::($OBJ,ddblock_bg_new)]
    pack $topFrm -side top -anchor w
    pack $btmFrm -fill x
    set toggleFrame [frame $topFrm.tf -bd 3 -width 13 \
    -height 13 -relief sunken \
    -bg $udeEditor::($OBJ,ckb_bg)]
    set typelabel [label $btmFrm.l \
    -text $gPB(ude,editor,real,Label) \
    -fg $udeEditor::($OBJ,ddblock_fg_new) \
    -bg $udeEditor::($OBJ,ddblock_bg_new)]
    set entryFrame [frame $btmFrm.ef -bd 2 -width 70 \
    -height 20 -relief sunken \
    -bg $udeEditor::($OBJ,type_widget_bg)]
    set statuslabel [label $topFrm.s \
    -text $gPB(ude,editor,status_label) \
    -fg $udeEditor::($OBJ,ddblock_fg_new) \
    -bg $udeEditor::($OBJ,ddblock_bg_new)]
    pack $toggleFrame $statuslabel -side left -padx 5
    pack $typelabel -side left -padx 5
    pack $entryFrame -side right -padx 5
   }
   Text    {
    set topFrm [frame .ddBlock.top -bg $udeEditor::($OBJ,ddblock_bg_new)]
    set btmFrm [frame .ddBlock.btm -bg $udeEditor::($OBJ,ddblock_bg_new)]
    pack $topFrm -side top -anchor w
    pack $btmFrm -fill x
    set toggleFrame [frame $topFrm.tf -bd 3 -width 13 \
    -height 13 -relief sunken \
    -bg $udeEditor::($OBJ,ckb_bg)]
    set typelabel [label $btmFrm.l \
    -text $gPB(ude,editor,txt,Label) \
    -fg $udeEditor::($OBJ,ddblock_fg_new) \
    -bg $udeEditor::($OBJ,ddblock_bg_new)]
    set entryFrame [frame $btmFrm.ef -bd 2 -width 90 \
    -height 20 -relief sunken \
    -bg $udeEditor::($OBJ,type_widget_bg)]
    set statuslabel [label $topFrm.s \
    -text $gPB(ude,editor,status_label) \
    -fg $udeEditor::($OBJ,ddblock_fg_new) \
    -bg $udeEditor::($OBJ,ddblock_bg_new)]
    pack $toggleFrame $statuslabel -side left -padx 5
    pack $typelabel -side top -pady 2 -anchor w
    pack $entryFrame -fill x -expand yes -padx 5 -pady 2
   }
   Boolean {
    set toggleFrame [frame .ddBlock.tf -bd 3 -width 13 \
    -height 13 -relief sunken \
    -bg $udeEditor::($OBJ,ckb_bg)]
    set typelabel [label .ddBlock.l \
    -text $gPB(ude,editor,bln,Label) \
    -fg $udeEditor::($OBJ,ddblock_fg_new) \
    -bg $udeEditor::($OBJ,ddblock_bg_new)]
    pack $toggleFrame $typelabel -side left -padx 5
   }
   Option  {
    if 0 {
     set toggleFrame [frame .ddBlock.tf -bd 3 -width 13 \
     -height 13 -relief sunken \
     -bg $udeEditor::($OBJ,ckb_bg)]
    }
    set typelabel [label .ddBlock.l \
    -text $gPB(ude,editor,opt,Label) \
    -fg $udeEditor::($OBJ,ddblock_fg_new) \
    -bg $udeEditor::($OBJ,ddblock_bg_new)]
    set optionFrame [frame .ddBlock.ef -bd 2 -width 120 \
    -height 20 -relief raised \
    -bg $udeEditor::($OBJ,type_widget_bg)]
    set optionSubFrame [frame $optionFrame.sf -bd 2 -width 13 \
    -height 8 -relief raised \
    -bg $udeEditor::($OBJ,type_widget_bg)]
    set optionSubLabel [label $optionFrame.l -text "      " \
    -bg $udeEditor::($OBJ,type_widget_bg)]
    pack $optionSubFrame $optionSubLabel -side right -padx 5
    pack $typelabel -side left -padx 5
    pack $optionFrame -side right -padx 5
   }
   Point   {
    set topFrm [frame .ddBlock.top -bg $udeEditor::($OBJ,ddblock_bg_new)]
    set btmFrm [frame .ddBlock.btm -bg $udeEditor::($OBJ,ddblock_bg_new)]
    pack $topFrm -side top -anchor w
    pack $btmFrm -fill x
    set statuslabel [label $topFrm.s \
    -text $gPB(ude,editor,status_label) \
    -fg $udeEditor::($OBJ,ddblock_fg_new) \
    -bg $udeEditor::($OBJ,ddblock_bg_new)]
    set toggleFrame [frame $topFrm.tf -bd 3 -width 13 \
    -height 13 -relief sunken \
    -bg $udeEditor::($OBJ,ckb_bg)]
    set typelabel [label $btmFrm.l \
    -text $gPB(ude,editor,pnt,Label) \
    -fg $udeEditor::($OBJ,ddblock_fg_new) \
    -bg $udeEditor::($OBJ,ddblock_bg_new)]
    set botframe [frame $btmFrm.botf \
    -bg $udeEditor::($OBJ,ddblock_bg_new)]
    if 0 {
     set selButton [button $botframe.sb \
     -text $gPB(ude,editor,pnt,sel,Label) -width 8 \
     -bg $udeEditor::($OBJ,type_widget_bg) \
     -fg $udeEditor::($OBJ,item_fg)]
     set dspButton [button $botframe.db \
     -text $gPB(ude,editor,pnt,dsp,Label) -width 8 \
     -bg $udeEditor::($OBJ,type_widget_bg) \
     -fg $udeEditor::($OBJ,item_fg)]
    }
    set selButton [label $botframe.sb -text $gPB(ude,editor,pnt,sel,Label) -takefocus 0 \
    -width 10 -relief raised -font $gPB(bold_font) \
    -bd 2 -anchor center \
    -bg $udeEditor::($OBJ,type_widget_bg) \
    -fg $udeEditor::($OBJ,item_fg)]
    set dspButton [label $botframe.db -text $gPB(ude,editor,pnt,dsp,Label) -takefocus 0 \
    -width 10 -relief raised -font $gPB(bold_font) \
    -bd 2 -anchor center \
    -bg $udeEditor::($OBJ,type_widget_bg) \
    -fg $udeEditor::($OBJ,item_fg)]
    pack $toggleFrame $statuslabel -side left -padx 5
    pack $typelabel -side top -pady 2 -anchor w
    tixForm $selButton -left %0 -right %50 -padx 2 -pady 0
    tixForm $dspButton -left %50 -right %100 -padx 2 -pady 0
    pack $botframe -fill x -expand yes -padx 5 -pady 0
   }
   Bitmap  {
    set bmp_img [tix getimage pb_image]
    set bmp_btn [button .ddBlock.bmp -image $bmp_img -relief flat]
    pack $bmp_btn -side top -anchor c -pady 2
   }
   Group   {
    if 0 {
     .ddBlock config -bg $udeEditor::($OBJ,groupitem_bg)
     set topFrm [frame .ddBlock.top -bg $udeEditor::($OBJ,groupitem_bg)]
     set btmFrm [frame .ddBlock.btm -bg $udeEditor::($OBJ,groupitem_bg)]
     pack $topFrm $btmFrm -side top -fill x -pady 2
     set lbl [label $topFrm.lbl -text $gPB(ude,editor,group,Label) \
     -fg $udeEditor::($OBJ,ddblock_fg_new) \
     -bg $udeEditor::($OBJ,groupitem_bg)]
    }
    set topFrm [frame .ddBlock.top -bg $udeEditor::($OBJ,ddblock_bg_new)]
    set btmFrm [frame .ddBlock.btm -bg $udeEditor::($OBJ,ddblock_bg_new)]
    pack $topFrm $btmFrm -side top -fill x -pady 2
    set lbl [label $topFrm.lbl -text $gPB(ude,editor,group,Label) \
    -fg $udeEditor::($OBJ,ddblock_fg_new) \
    -bg $udeEditor::($OBJ,ddblock_bg_new)]
    set top_img [tix getimage pb_group_open]
    set tb [button $topFrm.tb -image $top_img]
    set ts [UI_PB_com_AddSeparator $topFrm.ts]
    set bb [UI_PB_com_AddSeparator $btmFrm.bb]
    pack $lbl -side left -padx 5
    pack $tb  -side right -padx 5
    pack $bb  -pady 2 -fill x
   }
   Vector  {
    set topFrm [frame .ddBlock.top -bg $udeEditor::($OBJ,ddblock_bg_new)]
    set btmFrm [frame .ddBlock.btm -bg $udeEditor::($OBJ,ddblock_bg_new)]
    pack $topFrm -side top -anchor w
    pack $btmFrm -fill x
    set statuslabel [label $topFrm.s \
    -text $gPB(ude,editor,status_label) \
    -fg $udeEditor::($OBJ,ddblock_fg_new) \
    -bg $udeEditor::($OBJ,ddblock_bg_new)]
    set toggleFrame [frame $topFrm.tf -bd 3 -width 13 \
    -height 13 -relief sunken \
    -bg $udeEditor::($OBJ,ckb_bg)]
    set typelabel [label $btmFrm.l \
    -text $gPB(ude,editor,vector,Label) \
    -fg $udeEditor::($OBJ,ddblock_fg_new) \
    -bg $udeEditor::($OBJ,ddblock_bg_new)]
    set botframe [frame $btmFrm.botf \
    -bg $udeEditor::($OBJ,ddblock_bg_new)]
    if 0 {
     set selButton [button $botframe.sb \
     -text $gPB(ude,editor,pnt,sel,Label) -width 8 \
     -bg $udeEditor::($OBJ,type_widget_bg) \
     -fg $udeEditor::($OBJ,item_fg)]
     set dspButton [button $botframe.db \
     -text $gPB(ude,editor,pnt,dsp,Label) -width 8 \
     -bg $udeEditor::($OBJ,type_widget_bg) \
     -fg $udeEditor::($OBJ,item_fg)]
    }
    set selButton [label $botframe.sb -text $gPB(ude,editor,pnt,sel,Label) -takefocus 0 \
    -width 10 -relief raised -font $gPB(bold_font) \
    -bd 2 -anchor center \
    -bg $udeEditor::($OBJ,type_widget_bg) \
    -fg $udeEditor::($OBJ,item_fg)]
    set dspButton [label $botframe.db -text $gPB(ude,editor,pnt,dsp,Label) -takefocus 0 \
    -width 10 -relief raised -font $gPB(bold_font) \
    -bd 2 -anchor center \
    -bg $udeEditor::($OBJ,type_widget_bg) \
    -fg $udeEditor::($OBJ,item_fg)]
    pack $toggleFrame $statuslabel -side left -padx 5
    pack $typelabel -side top -pady 2 -anchor w
    tixForm $selButton -left %0 -right %50 -padx 2 -pady 0
    tixForm $dspButton -left %50 -right %100 -padx 2 -pady 0
    pack $botframe -fill x -expand yes -padx 5 -pady 0
   }
  }
  global tcl_platform env
  if { ![string match "windows" $tcl_platform(platform)] } {
   set cur "$env(PB_HOME)/images/pb_hand.xbm"
   set msk "$env(PB_HOME)/images/pb_hand.mask"
   $w config -cursor "@$cur $msk black white"
  }
 }

#=======================================================================
proc UI_PB_ude_DragItem {X Y} {
  global gPB
  set OBJ $udeEditor::(obj)
  if {$gPB(use_info)} {
   return
  }
  if {$udeEditor::($OBJ,drag_drop_enabled) != 1} {
   return
  }
  set udeEditor::($udeEditor::(obj),isInDD) 1
  set main_window $udeEditor::(main_widget)
  set rootx [winfo rootx $main_window]
  set rooty [winfo rooty $main_window]
  set width [winfo width $main_window]
  set height [winfo height $main_window]
  UI_PB_mthd_MoveDDBlock $X $Y udeblock $rootx $rooty \
  [expr $height - 60] $width
  UI_PB_ude_Highlighting $X $Y
  UI_PB_ude_autoscroll $X $Y
 }

#=======================================================================
proc UI_PB_ude_Highlighting {X Y} {
  set hlwidgets $udeEditor::($udeEditor::(obj),hlWidgets)
  set trash_canvas $udeEditor::($udeEditor::(obj),trash_canvas)
  set num $udeEditor::($udeEditor::(obj),numOfItems)
  set midframe $udeEditor::($udeEditor::(obj),midframe)
  set i 1
  if {$num == "0"} {
   set area [UI_PB_ude_GetRespondingArea $midframe]
   if [UI_PB_ude_isInRespndArea $X $Y $area] {
    if $udeEditor::($udeEditor::(obj),isInDD) {
     $midframe config \
     -bg $udeEditor::($udeEditor::(obj),bar_highlight)
     set udeEditor::($udeEditor::(obj),current_hlWidget) $midframe
     set udeEditor::($udeEditor::(obj),insert_position_w) $midframe
     set udeEditor::($udeEditor::(obj),isReady) 1
     set i 0
    }
   }
  }
  foreach w $hlwidgets {
   set area [UI_PB_ude_GetRespondingArea $w]
   if [UI_PB_ude_isInRespndArea $X $Y $area] {
    event generate $w <Enter>
    set i 0
   }
  }
  if $i {
   foreach w $hlwidgets {
    event generate $w <Leave>
   }
   set alist [$midframe config -bg]
   set attr [lindex $alist end]
   if {$attr == $udeEditor::($udeEditor::(obj),bar_highlight)} {
    $midframe config -bg $udeEditor::($udeEditor::(obj),dock_bg)
    set udeEditor::($udeEditor::(obj),current_hlWidget) ""
    set udeEditor::($udeEditor::(obj),isReady) 0
   }
  }
  set j 1
  set trash_area [UI_PB_ude_GetRespondingArea $trash_canvas trash]
  if [UI_PB_ude_isInRespndArea $X $Y $trash_area] {
   event generate $trash_canvas <Enter>
   event generate $trash_canvas <B1-Motion> -x $X -y $Y
   set j 0
  }
  if $j {
   event generate $trash_canvas <Leave>
   set id [$trash_canvas find withtag trashline]
   set pos [expr $udeEditor::($udeEditor::(obj),left_panel_width) / 2]
   $trash_canvas coords $id $pos $pos $pos [expr $pos + 5]
  }
 }

#=======================================================================
proc UI_PB_ude_UnHighlighting {} {
  set hlwidgets $udeEditor::($udeEditor::(obj),hlWidgets)
  set trash_canvas $udeEditor::($udeEditor::(obj),trash_canvas)
  set midframe $udeEditor::($udeEditor::(obj),midframe)
  set alist [$midframe config -bg]
  set attr [lindex $alist end]
  if {$attr == $udeEditor::($udeEditor::(obj),bar_highlight)} {
   $midframe config -bg $udeEditor::($udeEditor::(obj),dock_bg)
   set udeEditor::($udeEditor::(obj),current_hlWidget) ""
   set udeEditor::($udeEditor::(obj),isReady) 0
  }
  foreach w $hlwidgets {
   event generate $w <Leave>
  }
  event generate $trash_canvas <Leave>
  set id [$trash_canvas find withtag trashline]
  set pos [expr $udeEditor::($udeEditor::(obj),left_panel_width) / 2]
  $trash_canvas coords $id $pos $pos $pos [expr $pos + 5]
 }

#=======================================================================
proc UI_PB_ude_EndDragItem {w type} {
  global gPB
  set OBJ $udeEditor::(obj)
  if {$gPB(use_info)} {
   return
  }
  if {$udeEditor::($OBJ,drag_drop_enabled) != 1} {
   return
  }
  UI_PB_mthd_DestroyDDBlock
  if $udeEditor::($OBJ,isReady) {
   UI_PB_ude_AddItemIntoMidFrame $type
  }
  UI_PB_ude_UnHighlighting
  $w config -highlightbackground $udeEditor::($OBJ,type_hl_bg)
  set udeEditor::($udeEditor::(obj),isInDD) 0
  $w config -relief raised
  global tcl_platform env
  if { ![string match "windows" $tcl_platform(platform)] } {
   $w config -cursor hand2
  }
 }

#=======================================================================
proc UI_PB_ude_AddItemIntoMidFrame {type} {
  set pst [UI_PB_ude_FindLocationForAddingItem]
  set udeEditor::($udeEditor::(obj),cur_pst) $pst
  if { ![string compare $type "Group"] && ![UI_PB_ude_ValidAddGroup $pst] } {
   global gPB
   tk_messageBox -type ok -icon error \
   -message $gPB(ude,editor,group,MSG_NESTED_GROUP)
   return
  }
  set isPtc 0
  UI_PB_ude_CreateParamDialog $type $isPtc
 }

#=======================================================================
proc UI_PB_ude_ValidAddGroup {pst} {
  if {![string compare $pst "-1"]} {
   return 1
  }
  array set pst_array $udeEditor::($udeEditor::(obj),pst_order)
  set firstGroup 0
  for {set index 0} {$index <= $pst} {incr index} {
   set class_type [string trim [classof $pst_array($index)] ::]
   if {[string compare $class_type "udeEditor::uiGroup"] != 0} { continue }
   if {$firstGroup == 0} {
    set firstGroup 1
    } else {
    set firstGroup 0
   }
  }
  if {$firstGroup == 0} {
   return 1
   } else {
   return 0
  }
 }

#=======================================================================
proc UI_PB_ude_DestroyParamDlg_Binding {w action} {
  set OBJ $udeEditor::(obj)
  if ![string compare $w [winfo toplevel $w]] {
   set udeEditor::($OBJ,drag_drop_enabled) 1
   UI_PB_com_DismissActiveWindow $w
   UI_PB_com_DeleteFromTopLevelList $w
   __com_RehostNoLicenseMsg
   __com_GrayOutDefaultButton
   if ![string compare $action EDIT] {
    set ui_obj $udeEditor::($OBJ,cur_edit_obj)
    set type [string trim [classof $ui_obj] ::]
    switch -exact $type {
     udeEditor::uiInteger {
      $udeEditor::uiInteger::($ui_obj,pathname) config \
      -highlightt 0 \
      -highlightb $udeEditor::($OBJ,dialog_bg)
      if $udeEditor::($OBJ,to_restore_value) {
       udeEditor::uiInteger::restore_value $ui_obj
      }
     }
     udeEditor::uiReal    {
      $udeEditor::uiReal::($ui_obj,pathname) config \
      -highlightt 0 \
      -highlightb $udeEditor::($OBJ,dialog_bg)
      if $udeEditor::($OBJ,to_restore_value) {
       udeEditor::uiReal::restore_value $ui_obj
      }
     }
     udeEditor::uiText    {
      $udeEditor::uiText::($ui_obj,pathname) config \
      -highlightt 0 \
      -highlightb $udeEditor::($OBJ,dialog_bg)
      if $udeEditor::($OBJ,to_restore_value) {
       udeEditor::uiText::restore_value $ui_obj
      }
     }
     udeEditor::uiBoolean {
      $udeEditor::uiBoolean::($ui_obj,pathname) config \
      -highlightt 0 \
      -highlightb $udeEditor::($OBJ,dialog_bg)
      if $udeEditor::($OBJ,to_restore_value) {
       udeEditor::uiBoolean::restore_value $ui_obj
      }
     }
     udeEditor::uiPoint   {
      $udeEditor::uiPoint::($ui_obj,pathname) config \
      -highlightt 0 \
      -highlightb $udeEditor::($OBJ,dialog_bg)
      if $udeEditor::($OBJ,to_restore_value) {
       udeEditor::uiPoint::restore_value $ui_obj
      }
     }
     udeEditor::uiOption  {
      set pathname $udeEditor::uiOption::($ui_obj,pathname)
      $pathname config -highlightt 0 \
      -highlightb $udeEditor::($OBJ,dialog_bg)
      ${pathname}.o config -disabledforeground $::SystemDisabledText
      if $udeEditor::($OBJ,to_restore_value) {
       udeEditor::uiOption::restore_value $ui_obj
      }
     }
     udeEditor::uiBitmap  {
      $udeEditor::uiBitmap::($ui_obj,pathname) config \
      -highlightt 0 \
      -highlightb $udeEditor::($OBJ,dialog_bg)
      if $udeEditor::($OBJ,to_restore_value) {
       udeEditor::uiBitmap::restore_value $ui_obj
      }
     }
     udeEditor::uiGroup   {
      $udeEditor::uiGroup::($ui_obj,pathname) config \
      -highlightt 0 \
      -highlightb $udeEditor::($OBJ,dialog_bg) \
      -bg $udeEditor::($OBJ,groupitem_bg)
      if $udeEditor::($OBJ,to_restore_value) {
       udeEditor::uiGroup::restore_value $ui_obj
      }
     }
     udeEditor::uiVector  {
      $udeEditor::uiVector::($ui_obj,pathname) config \
      -highlightt 0 \
      -highlightb $udeEditor::($OBJ,dialog_bg)
      if $udeEditor::($OBJ,to_restore_value) {
       udeEditor::uiVector::restore_value $ui_obj
      }
     }
    }
    set udeEditor::($OBJ,to_restore_value) 1
    UI_PB_ude_CancelTrace
    } else {
    $udeEditor::($OBJ,insert_position_w) config \
    -highlightb $udeEditor::($OBJ,dialog_bg) \
    -bg $udeEditor::($OBJ,dock_bg)
    UI_PB_ude_DeletePreviewItem
    UI_PB_ude_CancelTrace
   }
  }
 }

#=======================================================================
proc UI_PB_ude_CreateParamDialog {type isPtc {action NEW}} {
   global gPB
   set param_main [toplevel $udeEditor::(main_widget).param]
   bind all <Enter> ""
   set OBJ $udeEditor::(obj)
   set udeEditor::($OBJ,drag_drop_enabled) 0
   set rootx [winfo rootx $udeEditor::(main_widget)]
   set rooty [winfo rooty $udeEditor::(main_widget)]
   set x [expr {$rootx - 10}]
   set y [expr {$rooty + 10}]
   set geom "+${x}+${y}"
   wm resizable $param_main 1 1
   if ![string compare $action "NEW"] {
    $udeEditor::($OBJ,insert_position_w) config \
    -highlightb $udeEditor::($OBJ,dialog_bg)
   }
   UI_PB_com_CreateTransientWindow $param_main \
   "$type" \
   $geom "" "" "" ""
   focus $param_main
   wm protocol $param_main WM_DELETE_WINDOW \
   "UI_PB_ude_DeleteWindow $param_main"
   bind $param_main <Destroy> "UI_PB_ude_DestroyParamDlg_Binding %W $action"
   if {$action == "EDIT"} {
    set ui_obj $udeEditor::($OBJ,cur_edit_obj)
    set class_type [classof $ui_obj]
    set self_pathname [set [set class_type]::($ui_obj,pathname)]
    $self_pathname config -relief sunken
    __ude_SetItemColor $self_pathname $udeEditor::($OBJ,sunken_bg)
    if ![string compare $type "Group"] {
     set match_grp_obj [UI_PB_ude_GetMatchGroupItemFrom $ui_obj]
     set temp_pathname $udeEditor::uiGroup::($match_grp_obj,pathname)
     $temp_pathname config -relief sunken
     __ude_SetItemColor $temp_pathname $udeEditor::($OBJ,sunken_bg)
    }
    if 0 { ;# Replaced with call above
     set children [tixDescendants $self_pathname]
     foreach one $children {
      set tp [winfo class $one]
      if {$tp == "Label" || $tp == "Checkbutton" || \
       $tp == "Frame" || $tp == "Menubutton"} {
       $one config -bg $udeEditor::($OBJ,sunken_bg)
       if {$tp == "Checkbutton"} {
        $one config -activebackground $udeEditor::($OBJ,sunken_bg)
       }
      }
     }
    }
    set self_bf [winfo parent $self_pathname].bf
    set self_pbf [winfo parent $self_pathname].pbf
    set up_obj [UI_PB_ude_GetAboveUiObj $ui_obj]
    if {$up_obj == "NULL"} {
     set up_pathname $self_pathname
     } else {
     set class_type [classof $up_obj]
     set up_pathname [set [set class_type]::($up_obj,pathname)]
    }
    set up_bf [winfo parent $up_pathname].bf
    set up_pbf [winfo parent $up_pathname].pbf
    if 0 {
     $self_bf config -highlightb $udeEditor::($OBJ,bar_highlight)
     $self_pbf config -bg $udeEditor::($OBJ,bar_highlight)
     $up_bf config -highlightb $udeEditor::($OBJ,bar_highlight)
     $up_pbf config -bg $udeEditor::($OBJ,bar_highlight)
    }
    bind $param_main <Destroy> "+ UI_PB_ude_RestoreConfig $ui_obj  $isPtc $self_bf \
    $self_pbf $up_bf $up_pbf"
   }
   switch -exact $type {
    Integer {
     UI_PB_ude_CreateIntegerParamDialog $param_main $action $isPtc
    }
    Real    {
     UI_PB_ude_CreateRealParamDialog $param_main $action $isPtc
    }
    Text    {
     UI_PB_ude_CreateTextParamDialog $param_main $action $isPtc
    }
    Boolean {
     UI_PB_ude_CreateBooleanParamDialog $param_main $action $isPtc
    }
    Point   {
     UI_PB_ude_CreatePointParamDialog $param_main $action $isPtc
    }
    Option  {
     UI_PB_ude_CreateOptionParamDialog $param_main $action $isPtc
    }
    Bitmap  {
     UI_PB_ude_CreateBitmapParamDialog $param_main $action $isPtc
    }
    Group   {
     UI_PB_ude_CreateGroupParamDialog $param_main $action $isPtc
    }
    Vector  {
     UI_PB_ude_CreateVectorParamDialog $param_main $action $isPtc
    }
   }
   set udeEditor::($OBJ,cur_dlg_type) $type
  }

#=======================================================================
proc UI_PB_ude_ParamDlgCNL {w} {
  tk_focusFollowsMouse
  destroy $w
 }

#=======================================================================
proc UI_PB_ude_GetExistParamName {{type NEW}} {
  set OBJ $udeEditor::(obj)
  set sub_obj_list $udeEditor::($OBJ,sub_objs)
  if {$type == "EDIT"} {
   set idx [lsearch $sub_obj_list $udeEditor::($OBJ,cur_edit_obj)]
   if {$idx >= 0} {
    set sub_obj_list [lreplace $sub_obj_list $idx $idx]
   }
  }
  set name_list [list]
  foreach one $sub_obj_list {
   set type [classof $one]
   lappend name_list [set [set type]::($one,name)]
  }
  return $name_list
 }

#=======================================================================
proc UI_PB_ude_ParamDlgOK {w type {arg_w ""}} {
   global gPB
   tk_focusFollowsMouse
   set OBJ $udeEditor::(obj)
   switch -exact $type {
    Integer {
     set v_name $udeEditor::($OBJ,i_vname)
    }
    Real    {
     set v_name $udeEditor::($OBJ,r_vname)
    }
    Text    {
     set v_name $udeEditor::($OBJ,t_vname)
    }
    Option  {
     set v_name $udeEditor::($OBJ,o_vname)
    }
    Boolean {
     set v_name $udeEditor::($OBJ,b_vname)
    }
    Point   {
     set v_name $udeEditor::($OBJ,p_vname)
    }
    Bitmap  {
     set v_name $udeEditor::($OBJ,l_vname)
    }
    Group   {
     set v_name $udeEditor::($OBJ,g_vname)
    }
    Vector  {
     set v_name $udeEditor::($OBJ,v_vname)
    }
   }
   if { [string length $v_name] == 0 } {
    tk_messageBox -message $gPB(ude,editor,param,MSG_NO_VNAME) -icon error \
    -title $gPB(msg,error) \
    -parent [UI_PB_com_AskActiveWindow]
    return
    } else {
    if { [lsearch $gPB(non_ude_param_keywords) $v_name] != -1 } \
    {
     tk_messageBox -message "$gPB(ude,editor,param,MSG_WRONG_KEYWORD) $v_name" \
     -icon error -title $gPB(msg,error) \
     -parent [UI_PB_com_AskActiveWindow]
     return
    }
    if { ![string match {[A-Za-z]*} $v_name] } \
    {
     tk_messageBox -message $gPB(ude,editor,param,MSG_WRONG_VAR_NAME) \
     -icon error -title $gPB(msg,error) \
     -parent [UI_PB_com_AskActiveWindow]
     return
    }
    set name_list [UI_PB_ude_GetExistParamName]
    if { [lsearch $name_list $v_name] >= 0 } {
     tk_messageBox -message $gPB(ude,editor,param,MSG_EXIST_VNAME) \
     -icon error -title $gPB(msg,error) \
     -parent [UI_PB_com_AskActiveWindow]
     return
    }
   }
   if [string match "Bitmap" $type] \
   {
    if ![string match "*.bmp" [string tolower $udeEditor::($OBJ,l_dvalue)]] \
    {
     tk_messageBox -message $gPB(ude,editor,param,MSG_WRONG_IMAGE_FILE) -icon error \
     -title $gPB(msg,error) -parent [UI_PB_com_AskActiveWindow]
     return
    }
    if { [string compare "." [file dirname $udeEditor::($OBJ,l_dvalue)]] != 0 } \
    {
     tk_messageBox -message $gPB(ude,editor,param,MSG_WRONG_IMAGE_FOLDER) -icon error \
     -title $gPB(msg,error) -parent [UI_PB_com_AskActiveWindow]
     return
    }
   }
   switch -exact $type {
    Integer {
     set TYPE i
     set param_obj [param::CreateObject TYPE]
     lappend udeEditor::($OBJ,temp_new_paramobj) $param_obj
     set param::integer::($param_obj,name)     $udeEditor::($OBJ,i_vname)
     set param::integer::($param_obj,type)     i
     set param::integer::($param_obj,default)  $udeEditor::($OBJ,i_dvalue)
     set param::integer::($param_obj,toggle)   $udeEditor::($OBJ,i_toggle)
     if {[string trim $udeEditor::($OBJ,i_label)] != ""} {
      set param::integer::($param_obj,ui_label) $udeEditor::($OBJ,i_label)
      } else {
      set param::integer::($param_obj,ui_label) $udeEditor::($OBJ,i_vname)
     }
    }
    Real    {
     set TYPE d
     set param_obj [param::CreateObject TYPE]
     lappend udeEditor::($OBJ,temp_new_paramobj) $param_obj
     set param::double::($param_obj,name)      $udeEditor::($OBJ,r_vname)
     set param::double::($param_obj,type)      d
     set param::double::($param_obj,default)   $udeEditor::($OBJ,r_dvalue)
     set param::double::($param_obj,toggle)    $udeEditor::($OBJ,r_toggle)
     if {[string trim $udeEditor::($OBJ,r_label)] != ""} {
      set param::double::($param_obj,ui_label) $udeEditor::($OBJ,r_label)
      } else {
      set param::double::($param_obj,ui_label) $udeEditor::($OBJ,r_vname)
     }
    }
    Text    {
     set TYPE s
     set param_obj [param::CreateObject TYPE]
     lappend udeEditor::($OBJ,temp_new_paramobj) $param_obj
     set param::string::($param_obj,name) $udeEditor::($OBJ,t_vname)
     set param::string::($param_obj,type) s
     set param::string::($param_obj,default)   $udeEditor::($OBJ,t_dvalue)
     set param::string::($param_obj,toggle) $udeEditor::($OBJ,t_toggle)
     if {[string trim $udeEditor::($OBJ,t_label)] != ""} {
      set param::string::($param_obj,ui_label) $udeEditor::($OBJ,t_label)
      } else {
      set param::string::($param_obj,ui_label) $udeEditor::($OBJ,t_vname)
     }
    }
    Option  {
     set TYPE o
     set param_obj [param::CreateObject TYPE]
     lappend udeEditor::($OBJ,temp_new_paramobj) $param_obj
     set param::option::($param_obj,name) $udeEditor::($OBJ,o_vname)
     set param::option::($param_obj,type) o
     if {[string trim $udeEditor::($OBJ,o_label)] != ""} {
      set param::option::($param_obj,ui_label) $udeEditor::($OBJ,o_label)
      } else {
      set param::option::($param_obj,ui_label) $udeEditor::($OBJ,o_vname)
     }
     if {$arg_w != ""} {
      global gPB
      set udeEditor::($OBJ,o_optlist) [list]
      set temp_elist [$arg_w window names]
      foreach one $temp_elist {
       set i [$arg_w index $one]
       set ord($i) $one
      }
      set elist [list]
      set start_idx 1.0
      for {set i 1} {$i <= [llength $temp_elist]} {incr i} {
       lappend elist $ord($start_idx)
       set start_idx [expr $start_idx + 1]
      }
      if {[llength $elist] != 0} {
       set o_list [list]
       foreach one $elist {
        lappend o_list [$one get]
       }
       foreach one $o_list {
        if {$::tix_version == 8.4} {
         set idx_list [lsearch -all $o_list $one]
         } else {
         set idx_list [list]
         set temp_list $o_list
         set idx [lsearch $temp_list $one]
         lappend idx_list $idx
         set temp_list [lreplace $temp_list $idx $idx]
         set idx [lsearch $temp_list $one]
         if {$idx >= 0} {
          lappend idx_list $idx
         }
        }
        if {[llength $idx_list] > 1} {
         tk_messageBox -message $gPB(ude,editor,opt,MSG_IDENTICAL) \
         -icon error -title $gPB(msg,error) \
         -parent [UI_PB_com_AskActiveWindow]
         return
        }
       }
       set udeEditor::($OBJ,o_optlist) $o_list
       } else {
       tk_messageBox -message $gPB(ude,editor,opt,NO_OPT) -icon error \
       -title $gPB(msg,error) \
       -parent [UI_PB_com_AskActiveWindow]
       delete $param_obj
       set udeEditor::($OBJ,temp_new_paramobj) \
       [lreplace $udeEditor::($OBJ,temp_new_paramobj) end end]
       return
      }
     }
     if {$udeEditor::($OBJ,select_opt) != ""} {
      set udeEditor::($OBJ,o_dvalue) \
      [$udeEditor::($OBJ,select_opt) get]
     }
     if {[string trim $udeEditor::($OBJ,o_dvalue)] == ""} {
      if {[llength $udeEditor::($OBJ,o_optlist)] != 0} {
       set udeEditor::($OBJ,o_dvalue) \
       [lindex $udeEditor::($OBJ,o_optlist) 0]
      }
      } else {
      if {[lsearch -exact $udeEditor::($OBJ,o_optlist) \
       $udeEditor::($OBJ,o_dvalue)] == "-1"} {
       set udeEditor::($OBJ,o_dvalue) \
       [lindex $udeEditor::($OBJ,o_optlist) 0]
      }
     }
     set param::option::($param_obj,default)   \
     $udeEditor::($OBJ,o_dvalue)
     set param::option::($param_obj,options) \
     [join $udeEditor::($OBJ,o_optlist) ","]
    }
    Boolean {
     set TYPE b
     set param_obj [param::CreateObject TYPE]
     lappend udeEditor::($OBJ,temp_new_paramobj) $param_obj
     set param::boolean::($param_obj,name) $udeEditor::($OBJ,b_vname)
     set param::boolean::($param_obj,type) b
     set param::boolean::($param_obj,default)   $udeEditor::($OBJ,b_dvalue)
     if {[string trim $udeEditor::($OBJ,b_label)] != ""} {
      set param::boolean::($param_obj,ui_label) $udeEditor::($OBJ,b_label)
      } else {
      set param::boolean::($param_obj,ui_label) $udeEditor::($OBJ,b_vname)
     }
    }
    Point   {
     set TYPE p
     set param_obj [param::CreateObject TYPE]
     lappend udeEditor::($OBJ,temp_new_paramobj) $param_obj
     set param::point::($param_obj,name) $udeEditor::($OBJ,p_vname)
     set param::point::($param_obj,type) p
     set param::point::($param_obj,toggle) $udeEditor::($OBJ,p_toggle)
     if {[string trim $udeEditor::($OBJ,p_label)] != ""} {
      set param::point::($param_obj,ui_label) $udeEditor::($OBJ,p_label)
      } else {
      set param::point::($param_obj,ui_label) $udeEditor::($OBJ,p_vname)
     }
    }
    Bitmap  {
     set TYPE l
     set param_obj [param::CreateObject TYPE]
     lappend udeEditor::($OBJ,temp_new_paramobj) $param_obj
     set param::bitmap::($param_obj,name) $udeEditor::($OBJ,l_vname)
     set param::bitmap::($param_obj,type) l
     set param::bitmap::($param_obj,default)   $udeEditor::($OBJ,l_dvalue)
    }
    Group   {
     set TYPE g
     set param_obj [param::CreateObject TYPE]
     lappend udeEditor::($OBJ,temp_new_paramobj) $param_obj
     set param::group::($param_obj,name) $udeEditor::($OBJ,g_vname)
     set param::group::($param_obj,type) g
     if {[string trim $udeEditor::($OBJ,g_label)] != ""} {
      set param::group::($param_obj,ui_label) $udeEditor::($OBJ,g_label)
      } else {
      set param::group::($param_obj,ui_label) $udeEditor::($OBJ,g_vname)
     }
     set param::group::($param_obj,default)   $udeEditor::($OBJ,g_dvalue)
     if {[info exists end_param_obj]} {
      unset end_param_obj
     }
     set end_param_obj [param::CreateObject TYPE]
     set param::group::($end_param_obj,name)      $param::group::($param_obj,name)_end
     set param::group::($end_param_obj,type)      $param::group::($param_obj,type)
     set param::group::($end_param_obj,value)     "end"
     set param::group::($end_param_obj,default)   "end"
     set param::group::($end_param_obj,ui_label)  $param::group::($param_obj,ui_label)_end
    }
    Vector  {
     set TYPE v
     set param_obj [param::CreateObject TYPE]
     lappend udeEditor::($OBJ,temp_new_paramobj) $param_obj
     set param::vector::($param_obj,name) $udeEditor::($OBJ,v_vname)
     set param::vector::($param_obj,type) v
     set param::vector::($param_obj,toggle) $udeEditor::($OBJ,v_toggle)
     if {[string trim $udeEditor::($OBJ,v_label)] != ""} {
      set param::vector::($param_obj,ui_label) $udeEditor::($OBJ,v_label)
      } else {
      set param::vector::($param_obj,ui_label) $udeEditor::($OBJ,v_vname)
     }
    }
   }
   UI_PB_ude_DeletePreviewItem
   UI_PB_ude_AddItems $param_obj
   UI_PB_ude_AdjustItemDataOrderForInserting $udeEditor::($OBJ,cur_pst)
   UI_PB_ude_AdjustItemUIOrder
   if {[info exists end_param_obj]} {
    UI_PB_ude_AddItems $end_param_obj
    UI_PB_ude_AdjustItemDataOrderForInserting [expr {$udeEditor::($OBJ,cur_pst) + 1}]
    UI_PB_ude_AdjustItemUIOrder
    unset end_param_obj
   }
   destroy $w
  }

#=======================================================================
proc UI_PB_ude_ParamDlgOK_ForEdit {w type isPtc {arg_w ""}} {
   global gPB
   set OBJ $udeEditor::(obj)
   set param_obj $udeEditor::($OBJ,cur_edit_obj)
   tk_focusFollowsMouse
   if {$udeEditor::($OBJ,TYPE) == "UDC" && \
    $isPtc == 1} {
    destroy $w
    return
   }
   switch -exact $type {
    Integer {
     set v_name $udeEditor::($OBJ,i_vname)
    }
    Real    {
     set v_name $udeEditor::($OBJ,r_vname)
    }
    Text    {
     set v_name $udeEditor::($OBJ,t_vname)
    }
    Option  {
     set v_name $udeEditor::($OBJ,o_vname)
    }
    Boolean {
     set v_name $udeEditor::($OBJ,b_vname)
    }
    Point   {
     set v_name $udeEditor::($OBJ,p_vname)
    }
    Bitmap  {
     set v_name $udeEditor::($OBJ,l_vname)
    }
    Group   {
     set v_name $udeEditor::($OBJ,g_vname)
    }
    Vector  {
     set v_name $udeEditor::($OBJ,v_vname)
    }
   }
   if {$v_name == ""} {
    tk_messageBox -message $gPB(ude,editor,param,MSG_NO_VNAME) -icon error \
    -title $gPB(msg,error) -parent [UI_PB_com_AskActiveWindow]
    return
    } else {
    if { [lsearch $gPB(non_ude_param_keywords) $v_name] != -1 } \
    {
     tk_messageBox -message "$gPB(ude,editor,param,MSG_WRONG_KEYWORD) $v_name" \
     -icon error -title $gPB(msg,error) \
     -parent [UI_PB_com_AskActiveWindow]
     return
    }
    if { ![string match {[A-Za-z]*} $v_name] } \
    {
     tk_messageBox -message $gPB(ude,editor,param,MSG_WRONG_VAR_NAME) \
     -icon error -title $gPB(msg,error) \
     -parent [UI_PB_com_AskActiveWindow]
     return
    }
    set name_list [UI_PB_ude_GetExistParamName EDIT]
    if {[lsearch $name_list $v_name] >= 0} {
     tk_messageBox -message $gPB(ude,editor,param,MSG_EXIST_VNAME) \
     -icon error -title $gPB(msg,error) \
     -parent [UI_PB_com_AskActiveWindow]
     return
    }
   }
   if [string match "Bitmap" $type] \
   {
    if ![string match "*.bmp" [string tolower $udeEditor::($OBJ,l_dvalue)]] \
    {
     tk_messageBox -message $gPB(ude,editor,param,MSG_WRONG_IMAGE_FILE) -icon error \
     -title $gPB(msg,error) -parent [UI_PB_com_AskActiveWindow]
     return
    }
    if { [string compare "." [file dirname $udeEditor::($OBJ,l_dvalue)]] != 0 } \
    {
     tk_messageBox -message $gPB(ude,editor,param,MSG_WRONG_IMAGE_FOLDER) -icon error \
     -title $gPB(msg,error) -parent [UI_PB_com_AskActiveWindow]
     return
    }
   }
   set udeEditor::($OBJ,to_restore_value) 0
   switch -exact $type {
    Integer {
     set udeEditor::uiInteger::($param_obj,name) \
     $udeEditor::($OBJ,i_vname)
     set udeEditor::uiInteger::($param_obj,value) \
     $udeEditor::($OBJ,i_dvalue)
     if {[string trim $udeEditor::($OBJ,i_label)] != ""} {
      set udeEditor::uiInteger::($param_obj,ui_label) \
      $udeEditor::($OBJ,i_label)
      } else {
      set udeEditor::uiInteger::($param_obj,ui_label) \
      $udeEditor::($OBJ,i_vname)
     }
     if ![string compare $udeEditor::($OBJ,i_toggle) On] {
      set udeEditor::uiInteger::($param_obj,toggle_v) 1
      } elseif ![string compare $udeEditor::($OBJ,i_toggle) Off] {
      set udeEditor::uiInteger::($param_obj,toggle_v) 0
      } else {
      set udeEditor::uiInteger::($param_obj,toggle_v) -1
     }
     destroy $w
     UI_PB_ude_AdjustUI_ForToggle $param_obj Integer
    }
    Real    {
     set udeEditor::uiReal::($param_obj,name) \
     $udeEditor::($OBJ,r_vname)
     set udeEditor::uiReal::($param_obj,value) \
     $udeEditor::($OBJ,r_dvalue)
     if {[string trim $udeEditor::($OBJ,r_label)] != ""} {
      set udeEditor::uiReal::($param_obj,ui_label) \
      $udeEditor::($OBJ,r_label)
      } else {
      set udeEditor::uiReal::($param_obj,ui_label) \
      $udeEditor::($OBJ,r_vname)
     }
     if ![string compare $udeEditor::($OBJ,r_toggle) On] {
      set udeEditor::uiReal::($param_obj,toggle_v) 1
      } elseif ![string compare $udeEditor::($OBJ,r_toggle) Off] {
      set udeEditor::uiReal::($param_obj,toggle_v) 0
      } else {
      set udeEditor::uiReal::($param_obj,toggle_v) -1
     }
     destroy $w
     UI_PB_ude_AdjustUI_ForToggle $param_obj Real
    }
    Text    {
     set udeEditor::uiText::($param_obj,name) \
     $udeEditor::($OBJ,t_vname)
     set udeEditor::uiText::($param_obj,value) \
     $udeEditor::($OBJ,t_dvalue)
     if {[string trim $udeEditor::($OBJ,t_label)] != ""} {
      set udeEditor::uiText::($param_obj,ui_label) \
      $udeEditor::($OBJ,t_label)
      } else {
      set udeEditor::uiText::($param_obj,ui_label) \
      $udeEditor::($OBJ,t_vname)
     }
     if ![string compare $udeEditor::($OBJ,t_toggle) On] {
      set udeEditor::uiText::($param_obj,toggle_v) 1
      } elseif ![string compare $udeEditor::($OBJ,t_toggle) Off] {
      set udeEditor::uiText::($param_obj,toggle_v) 0
      } else {
      set udeEditor::uiText::($param_obj,toggle_v) -1
     }
     destroy $w
     UI_PB_ude_AdjustUI_ForToggle $param_obj Text
    }
    Option  {
     set udeEditor::uiOption::($param_obj,name) \
     $udeEditor::($OBJ,o_vname)
     if {[string trim $udeEditor::($OBJ,o_label)] != ""} {
      set udeEditor::uiOption::($param_obj,ui_label) \
      $udeEditor::($OBJ,o_label)
      } else {
      set udeEditor::uiOption::($param_obj,ui_label) \
      $udeEditor::($OBJ,o_vname)
     }
     if {$arg_w != ""} {
      global gPB
      set udeEditor::($OBJ,o_optlist) [list]
      set temp_elist [$arg_w window names]
      foreach one $temp_elist {
       set i [$arg_w index $one]
       set ord($i) $one
      }
      set elist [list]
      set start_idx 1.0
      for {set i 1} {$i <= [llength $temp_elist]} {incr i} {
       lappend elist $ord($start_idx)
       set start_idx [expr $start_idx + 1]
      }
      if {[llength $elist] != 0} {
       set o_list [list]
       foreach one $elist {
        lappend o_list [$one get]
       }
       foreach one $o_list {
        if {$::tix_version == 8.4} {
         set idx_list [lsearch -all $o_list $one]
         } else {
         set idx_list [list]
         set temp_list $o_list
         set idx [lsearch $temp_list $one]
         lappend idx_list $idx
         set temp_list [lreplace $temp_list $idx $idx]
         set idx [lsearch $temp_list $one]
         if {$idx >= 0} {
          lappend idx_list $idx
         }
        }
        if {[llength $idx_list] > 1} {
         tk_messageBox -message $gPB(ude,editor,opt,MSG_IDENTICAL) \
         -icon error -title $gPB(msg,error) \
         -parent [UI_PB_com_AskActiveWindow]
         return
        }
       }
       set udeEditor::($OBJ,o_optlist) $o_list
       } else {
       tk_messageBox -message $gPB(ude,editor,opt,NO_OPT) -icon error \
       -title $gPB(msg,error) \
       -parent [UI_PB_com_AskActiveWindow]
       return
      }
     }
     if {$udeEditor::($OBJ,select_opt) != ""} {
      set udeEditor::($OBJ,o_dvalue) \
      [$udeEditor::($OBJ,select_opt) get]
     }
     if {[string trim $udeEditor::($OBJ,o_dvalue)] == ""} {
      if {[llength $udeEditor::($OBJ,o_optlist)] != 0} {
       set udeEditor::($OBJ,o_dvalue) \
       [lindex $udeEditor::($OBJ,o_optlist) 0]
      }
      } else {
      if {[lsearch -exact $udeEditor::($OBJ,o_optlist) \
       $udeEditor::($OBJ,o_dvalue)] == "-1"} {
       set udeEditor::($OBJ,o_dvalue) \
       [lindex $udeEditor::($OBJ,o_optlist) 0]
      }
     }
     set udeEditor::uiOption::($param_obj,cur_opt) \
     $udeEditor::($OBJ,o_dvalue)
     set udeEditor::uiOption::($param_obj,opt_list) \
     $udeEditor::($OBJ,o_optlist)
     set udeEditor::uiOption::($param_obj,toggle_v) -1
     if 0 {
      if ![string compare $udeEditor::($OBJ,o_toggle) On] {
       set udeEditor::uiOption::($param_obj,toggle_v) 1
       } elseif ![string compare $udeEditor::($OBJ,o_toggle) Off] {
       set udeEditor::uiOption::($param_obj,toggle_v) 0
       } else {
       set udeEditor::uiOption::($param_obj,toggle_v) -1
      }
     }
     destroy $w
     UI_PB_ude_AdjustUI_ForToggle $param_obj Option
    }
    Boolean {
     set udeEditor::uiBoolean::($param_obj,name) \
     $udeEditor::($OBJ,b_vname)
     if {[string trim $udeEditor::($OBJ,b_label)] != ""} {
      set udeEditor::uiBoolean::($param_obj,ui_label) \
      $udeEditor::($OBJ,b_label)
      } else {
      set udeEditor::uiBoolean::($param_obj,ui_label) \
      $udeEditor::($OBJ,b_vname)
     }
     if ![string compare $udeEditor::($OBJ,b_dvalue) TRUE] {
      set udeEditor::uiBoolean::($param_obj,toggle_v) 1
      } else {
      set udeEditor::uiBoolean::($param_obj,toggle_v) 0
     }
     destroy $w
     UI_PB_ude_AdjustUI_ForToggle $param_obj Boolean
    }
    Point   {
     set udeEditor::uiPoint::($param_obj,name) \
     $udeEditor::($OBJ,p_vname)
     if {[string trim $udeEditor::($OBJ,p_label)] != ""} {
      set udeEditor::uiPoint::($param_obj,ui_label) \
      $udeEditor::($OBJ,p_label)
      } else {
      set udeEditor::uiPoint::($param_obj,ui_label) \
      $udeEditor::($OBJ,p_vname)
     }
     if ![string compare $udeEditor::($OBJ,p_toggle) On] {
      set udeEditor::uiPoint::($param_obj,toggle_v) 1
      } elseif ![string compare $udeEditor::($OBJ,p_toggle) Off] {
      set udeEditor::uiPoint::($param_obj,toggle_v) 0
      } else {
      set udeEditor::uiPoint::($param_obj,toggle_v) -1
     }
     destroy $w
     UI_PB_ude_AdjustUI_ForToggle $param_obj Point
    }
    Bitmap  {
     set udeEditor::uiBitmap::($param_obj,name) \
     $udeEditor::($OBJ,l_vname)
     set udeEditor::uiBitmap::($param_obj,value) \
     $udeEditor::($OBJ,l_dvalue)
     global gPB_help_tips
     set temp_w $udeEditor::uiBitmap::($param_obj,pathname)
     set gPB_help_tips($temp_w.btn) $udeEditor::($OBJ,l_dvalue)
     destroy $w
    }
    Group   {
     set udeEditor::uiGroup::($param_obj,name) \
     $udeEditor::($OBJ,g_vname)
     if {[string trim $udeEditor::($OBJ,g_label)] != ""} {
      set udeEditor::uiGroup::($param_obj,ui_label) \
      $udeEditor::($OBJ,g_label)
      } else {
      set udeEditor::uiGroup::($param_obj,ui_label) \
      $udeEditor::($OBJ,g_vname)
     }
     set matchGroupObj [UI_PB_ude_GetMatchGroupItemFrom $param_obj]
     set udeEditor::uiGroup::($matchGroupObj,name) $udeEditor::($OBJ,g_vname)
     append udeEditor::uiGroup::($matchGroupObj,name) "_end"
     set udeEditor::uiGroup::($param_obj,value) \
     $udeEditor::($OBJ,g_dvalue)
     set temp_w $udeEditor::uiGroup::($param_obj,pathname)
     UI_PB_ude_ClickGroupIcon $temp_w $udeEditor::($OBJ,g_dvalue)
     destroy $w
    }
    Vector  {
     set udeEditor::uiVector::($param_obj,name) \
     $udeEditor::($OBJ,v_vname)
     if {[string trim $udeEditor::($OBJ,v_label)] != ""} {
      set udeEditor::uiVector::($param_obj,ui_label) \
      $udeEditor::($OBJ,v_label)
      } else {
      set udeEditor::uiVector::($param_obj,ui_label) \
      $udeEditor::($OBJ,v_vname)
     }
     if ![string compare $udeEditor::($OBJ,v_toggle) On] {
      set udeEditor::uiVector::($param_obj,toggle_v) 1
      } elseif ![string compare $udeEditor::($OBJ,v_toggle) Off] {
      set udeEditor::uiVector::($param_obj,toggle_v) 0
      } else {
      set udeEditor::uiVector::($param_obj,toggle_v) -1
     }
     destroy $w
     UI_PB_ude_AdjustUI_ForToggle $param_obj Vector
    }
   }
  }

#=======================================================================
proc UI_PB_ude_AdjustUI_ForToggle {param_obj type} {
  switch -exact $type {
   Integer {
    set w $udeEditor::uiInteger::($param_obj,pathname)
    if [winfo exists $w.m] {
     destroy $w.m
    }
    set tfrm $w.top
    set bfrm $w.btm
    set ic $tfrm.c
    set il $bfrm.l
    set ie $bfrm.e
    pack forget $tfrm $bfrm
    if ![string compare $::tix_version 8.4] {
     $il config -state normal
     $ie config -state normal
     if {$udeEditor::uiInteger::($param_obj,toggle_v) == 0} {
      $ie config -state disabled
     }
     } else {
     $ie config -state normal -bg $::SystemWindow
     if {$udeEditor::uiInteger::($param_obj,toggle_v) == 0} {
      $ie config -state disabled -bg lightblue
     }
    }
    if {$udeEditor::uiInteger::($param_obj,toggle_v) != -1} {
     pack $tfrm -side top -anchor w -padx 2
    }
    pack $bfrm -side top -anchor w -fill x -padx 2
   }
   Real    {
    set w $udeEditor::uiReal::($param_obj,pathname)
    if [winfo exists $w.m] {
     destroy $w.m
    }
    set tfrm $w.top
    set bfrm $w.btm
    set rc $tfrm.c
    set rl $bfrm.l
    set re $bfrm.e
    pack forget $tfrm $bfrm
    if ![string compare $::tix_version 8.4] {
     $rl config -state normal
     $re config -state normal
     if {$udeEditor::uiReal::($param_obj,toggle_v) == 0} {
      $re config -state disabled
     }
     } else {
     $re config -state normal -bg $::SystemWindow
     if {$udeEditor::uiReal::($param_obj,toggle_v) == 0} {
      $re config -state disabled -bg lightblue
     }
    }
    if {$udeEditor::uiReal::($param_obj,toggle_v) != -1} {
     pack $tfrm -side top -anchor w -padx 2
    }
    pack $bfrm -side top -anchor w -fill x -padx 2
   }
   Text    {
    set w $udeEditor::uiText::($param_obj,pathname)
    if [winfo exists $w.m] {
     destroy $w.m
    }
    set tfrm $w.top
    set bfrm $w.btm
    set tc $tfrm.c
    set tl $bfrm.l
    set te $bfrm.e
    pack forget $tfrm $bfrm
    if ![string compare $::tix_version 8.4] {
     $tl config -state normal
     $te config -state normal
     if {$udeEditor::uiText::($param_obj,toggle_v) == 0} {
      $te config -state disabled
     }
     } else {
     $te config -state normal -bg $::SystemWindow
     if {$udeEditor::uiText::($param_obj,toggle_v) == 0} {
      $te config -state disabled -bg lightblue
     }
    }
    if {$udeEditor::uiText::($param_obj,toggle_v) != -1} {
     pack $tfrm -side top -anchor w -padx 2
    }
    pack $bfrm -side top -anchor w -fill x -padx 2
   }
   Boolean {
    set w $udeEditor::uiBoolean::($param_obj,pathname)
    if [winfo exists $w.m] {
     destroy $w.m
    }
    set bc $w.c
    set bl $w.l
    pack forget $bc $bl
    $bc config -state normal
    if ![string compare $::tix_version 8.4] {
     $bl config -state normal
    }
    pack $bc -side left -padx 1
    if ![string compare $::tix_version 8.4] {
     pack $bl -side left -padx 0
     } else {
     pack $bl -side left -padx 0 -pady 3
    }
   }
   Point   {
    set w $udeEditor::uiPoint::($param_obj,pathname)
    if [winfo exists $w.m] {
     destroy $w.m
    }
    set tfrm $w.top
    set bfrm $w.btm
    set pc $tfrm.c
    set pl $bfrm.l
    set bf $bfrm.bf
    set sb $bf.sb
    set db $bf.db
    pack forget $tfrm $bfrm
    if ![string compare $::tix_version 8.4] {
     $pl config -state normal
     $sb config -state normal
     $db config -state normal
     if {$udeEditor::uiPoint::($param_obj,toggle_v) == 0} {
      $sb config -state disabled
      $db config -state disabled
     }
     } else {
     $sb config -foreground $::SystemButtonText
     $db config -foreground $::SystemButtonText
     if {$udeEditor::uiPoint::($param_obj,toggle_v) == 0} {
      $sb config -foreground $::SystemDisabledText
      $db config -foreground $::SystemDisabledText
     }
    }
    if {$udeEditor::uiPoint::($param_obj,toggle_v) != -1} {
     pack $tfrm -side top -anchor w -padx 2
    }
    pack $bfrm -side top -anchor w -fill x -padx 2
   }
   Option  {
    set w $udeEditor::uiOption::($param_obj,pathname)
    if [winfo exists $w.m] {
     destroy $w.m
    }
    set oc $w.c
    set ol $w.l
    set om $w.o.menu
    set oo $w.o
    $om delete 0 end
    foreach opt $udeEditor::uiOption::($param_obj,opt_list) {
     set str [string trim $opt \"]
     $om add radiobutton -label $str -variable \
     udeEditor::uiOption::($param_obj,cur_opt)
    }
    pack forget $oc $ol $oo
    if ![string compare $::tix_version 8.4] {
     $ol config -state normal
    }
    $oo config -state normal
    if {$udeEditor::uiOption::($param_obj,toggle_v) == 0} {
     $oo config -state disabled
    }
    if {$udeEditor::uiOption::($param_obj,toggle_v) != -1} {
     pack $oc -side left -padx 3
    }
    if ![string compare $::tix_version 8.4] {
     pack $ol -side left -padx 0
     } else {
     pack $ol -side left -padx 0 -pady 3
    }
    pack $oo -side right -padx 3 -pady 5
   }
   Vector  {
    set w $udeEditor::uiVector::($param_obj,pathname)
    if [winfo exists $w.m] {
     destroy $w.m
    }
    set tfrm $w.top
    set bfrm $w.btm
    set pc $tfrm.c
    set pl $bfrm.l
    set bf $bfrm.bf
    set sb $bf.sb
    set db $bf.db
    pack forget $tfrm $bfrm
    if ![string compare $::tix_version 8.4] {
     $pl config -state normal
     $sb config -state normal
     $db config -state normal
     if {$udeEditor::uiVector::($param_obj,toggle_v) == 0} {
      $sb config -state disabled
      $db config -state disabled
     }
     } else {
     $sb config -foreground $::SystemButtonText
     $db config -foreground $::SystemButtonText
     if {$udeEditor::uiVector::($param_obj,toggle_v) == 0} {
      $sb config -foreground $::SystemDisabledText
      $db config -foreground $::SystemDisabledText
     }
    }
    if {$udeEditor::uiVector::($param_obj,toggle_v) != -1} {
     pack $tfrm -side top -anchor w -padx 2
    }
    pack $bfrm -side top -anchor w -fill x -padx 2
   }
  }
 }

#=======================================================================
proc UI_PB_ude_CreateIntegerParamDialog {w action isPtc} {
  global gPB
  set OBJ $udeEditor::(obj)
  if ![string compare $action NEW] {
   set udeEditor::($OBJ,i_label) "Your Label"
   set udeEditor::($OBJ,i_vname) "your_name"
   set udeEditor::($OBJ,i_dvalue) "0"
   set udeEditor::($OBJ,i_toggle) "On"
   } else {
   set ui_obj $udeEditor::($OBJ,cur_edit_obj)
   $udeEditor::uiInteger::($ui_obj,pathname) config \
   -highlightt 0 \
   -highlightb $udeEditor::($OBJ,indicator_for_edit_param)
   set udeEditor::($OBJ,i_label) $udeEditor::uiInteger::($ui_obj,ui_label)
   set udeEditor::($OBJ,i_vname) $udeEditor::uiInteger::($ui_obj,name)
   set udeEditor::($OBJ,i_dvalue) $udeEditor::uiInteger::($ui_obj,value)
   if {$udeEditor::uiInteger::($ui_obj,toggle_v) == 1} {
    set udeEditor::($OBJ,i_toggle) "On"
    } elseif {$udeEditor::uiInteger::($ui_obj,toggle_v) == 0} {
    set udeEditor::($OBJ,i_toggle) "Off"
    } else {
    set udeEditor::($OBJ,i_toggle) "None"
   }
  }
  set mid_frame [frame $w.mf -bd 1 -relief sunken]
  set sub1 [frame $mid_frame.1]
  set sub1_f [UI_PB_com_AddSeparator $mid_frame.1f]
  set sub2 [frame $mid_frame.2]
  set sub2_f [UI_PB_com_AddSeparator $mid_frame.2f]
  set sub3 [frame $mid_frame.3]
  set sub3_f [UI_PB_com_AddSeparator $mid_frame.3f]
  set sub4 [frame $mid_frame.4]
  set pl [label $sub1.l -text $gPB(ude,editor,paramdlg,PL,Label) -font $gPB(bold_font)]
  set pe [entry $sub1.e -width 28 -textvariable udeEditor::($OBJ,i_label)]
  set vn [label $sub2.l -text $gPB(ude,editor,paramdlg,VN,Label) -font $gPB(bold_font)]
  set ve [entry $sub2.e -width 10 -textvariable udeEditor::($OBJ,i_vname)]
  bind $ve <KeyPress> "UI_PB_com_DisableSpecialChars %W %K"
  bind $ve <KeyRelease> {%W config -state normal}
  set df [label $sub3.l -text $gPB(ude,editor,paramdlg,DF,Label) -font $gPB(bold_font)]
  set de [entry $sub3.e -width 10 -textvariable udeEditor::($OBJ,i_dvalue)]
  set tg [label $sub4.l -text $gPB(ude,editor,paramdlg,TG) -font $gPB(bold_font)]
  set te [tk_optionMenu $sub4.m udeEditor::($OBJ,i_toggle) None On Off]
  $sub4.m config -width 4 -direction below
  set gPB(c_help,$pe) "ude,editor,paramdlg,PL"
  set gPB(c_help,$ve) "ude,editor,paramdlg,VN"
  set gPB(c_help,$de) "ude,editor,paramdlg,DF"
  set gPB(c_help,$sub4.m) "ude,editor,paramdlg,TG,B"
  bind $de <KeyPress> "UI_PB_com_ValidateDataOfEntry %W %K i 0"
  bind $de <KeyRelease> {%W config -state normal ;set ::gPB(prev_key) ""}
  pack $pl -side top -anchor w
  pack $pe -fill x -pady 10 -padx 5
  pack $vn -side top -anchor w
  pack $ve -fill x -pady 10 -padx 5
  pack $df -side top -anchor w
  pack $de -fill x -pady 10 -padx 5
  pack $tg -side left -pady 14
  pack $sub4.m -side right -padx 3
  pack $sub1 $sub1_f $sub2 $sub2_f $sub3 $sub3_f $sub4 -pady 2 -padx 5 -fill x
  set bot_frame [frame $w.bf]
  set name_list {"gPB(nav_button,ok,Label)" "gPB(nav_button,cancel,Label)"}
  set cb_arr(gPB(nav_button,ok,Label)) ""
  set cb_arr(gPB(nav_button,cancel,Label)) ""
  UI_PB_com_CreateButtonBox $bot_frame name_list cb_arr
  if ![string compare $action NEW] {
   ${bot_frame}.box.act_0 config \
   -command "UI_PB_ude_ParamDlgOK $w Integer"
   ${bot_frame}.box.act_1 config \
   -command "UI_PB_ude_ParamDlgCNL $w"
   } else {
   ${bot_frame}.box.act_0 config \
   -command "UI_PB_ude_ParamDlgOK_ForEdit $w Integer $isPtc"
   ${bot_frame}.box.act_1 config \
   -command "UI_PB_ude_ParamDlgCNL $w"
  }
  pack $bot_frame -side bottom -fill x -pady 2 -padx 2
  pack $mid_frame -fill both -padx 2 -side top -pady 5 -expand yes
  if {$isPtc == 1} {
   if ![string compare $::tix_version 8.4] {
    $ve config -state disabled
    } else {
    $ve config -state disabled -bg lightblue
   }
  }
  if ![string compare $action "NEW"] {
   UI_PB_ude_CreatePreviewItem \
   [winfo parent $udeEditor::($OBJ,insert_position_w)] Integer
   } else {
   if {$udeEditor::($OBJ,TYPE) == "UDC" && \
    $isPtc == 1} {
    if ![string compare $::tix_version 8.4] {
     $pe config -state disabled
     $de config -state disabled
     $sub4.m config -state disabled
     } else {
     $pe config -state disabled -bg lightblue
     $de config -state disabled -bg lightblue
     $sub4.m config -state disabled
    }
    set udeEditor::($OBJ,to_restore_value) 0
    } else {
    UI_PB_ude_CreatePreviewBehavior_ForEdit Integer
   }
  }
 }

#=======================================================================
proc UI_PB_ude_CreateRealParamDialog {w action isPtc} {
  global gPB
  set OBJ $udeEditor::(obj)
  if ![string compare $action NEW] {
   set udeEditor::($OBJ,r_label) "Your Label"
   set udeEditor::($OBJ,r_vname) "your_name"
   set udeEditor::($OBJ,r_dvalue) "0.0"
   set udeEditor::($OBJ,r_toggle) "On"
   } else {
   set ui_obj $udeEditor::($OBJ,cur_edit_obj)
   $udeEditor::uiReal::($ui_obj,pathname) config \
   -highlightt 0 \
   -highlightb $udeEditor::($OBJ,indicator_for_edit_param)
   set udeEditor::($OBJ,r_label) $udeEditor::uiReal::($ui_obj,ui_label)
   set udeEditor::($OBJ,r_vname) $udeEditor::uiReal::($ui_obj,name)
   set udeEditor::($OBJ,r_dvalue) $udeEditor::uiReal::($ui_obj,value)
   if {$udeEditor::uiReal::($ui_obj,toggle_v) == 1} {
    set udeEditor::($OBJ,r_toggle) "On"
    } elseif {$udeEditor::uiReal::($ui_obj,toggle_v) == 0} {
    set udeEditor::($OBJ,r_toggle) "Off"
    } else {
    set udeEditor::($OBJ,r_toggle) "None"
   }
  }
  set mid_frame [frame $w.mf -bd 1 -relief sunken]
  set sub1 [frame $mid_frame.1]
  set sub1_f [UI_PB_com_AddSeparator $mid_frame.1f]
  set sub2 [frame $mid_frame.2]
  set sub2_f [UI_PB_com_AddSeparator $mid_frame.2f]
  set sub3 [frame $mid_frame.3]
  set sub3_f [UI_PB_com_AddSeparator $mid_frame.3f]
  set sub4 [frame $mid_frame.4]
  set pl [label $sub1.l -text $gPB(ude,editor,paramdlg,PL,Label) -font $gPB(bold_font)]
  set pe [entry $sub1.e -width 28 -textvariable udeEditor::($OBJ,r_label)]
  set vn [label $sub2.l -text $gPB(ude,editor,paramdlg,VN,Label) -font $gPB(bold_font)]
  set ve [entry $sub2.e -width 10 -textvariable udeEditor::($OBJ,r_vname)]
  bind $ve <KeyPress> "UI_PB_com_DisableSpecialChars %W %K"
  bind $ve <KeyRelease> {%W config -state normal}
  set df [label $sub3.l -text $gPB(ude,editor,paramdlg,DF,Label) -font $gPB(bold_font)]
  set de [entry $sub3.e -width 10 -textvariable udeEditor::($OBJ,r_dvalue)]
  set tg [label $sub4.l -text $gPB(ude,editor,paramdlg,TG) -font $gPB(bold_font)]
  set te [tk_optionMenu $sub4.m udeEditor::($OBJ,r_toggle) None On Off]
  $sub4.m config -width 4 -direction below
  set gPB(c_help,$pe) "ude,editor,paramdlg,PL"
  set gPB(c_help,$ve) "ude,editor,paramdlg,VN"
  set gPB(c_help,$de) "ude,editor,paramdlg,DF"
  set gPB(c_help,$sub4.m) "ude,editor,paramdlg,TG,B"
  bind $de <KeyPress> "UI_PB_com_ValidateDataOfEntry %W %K f 0"
  bind $de <KeyRelease> {%W config -state normal ;set ::gPB(prev_key) ""}
  pack $pl -side top -anchor w
  pack $pe -fill x -pady 10 -padx 5
  pack $vn -side top -anchor w
  pack $ve -fill x -pady 10 -padx 5
  pack $df -side top -anchor w
  pack $de -fill x -pady 10 -padx 5
  pack $tg -side left -pady 14
  pack $sub4.m -side right -padx 3
  pack $sub1 $sub1_f $sub2 $sub2_f $sub3 $sub3_f $sub4 -pady 2 -padx 5 -fill x
  set bot_frame [frame $w.bf]
  set name_list {"gPB(nav_button,ok,Label)" "gPB(nav_button,cancel,Label)"}
  set cb_arr(gPB(nav_button,ok,Label)) ""
  set cb_arr(gPB(nav_button,cancel,Label)) ""
  UI_PB_com_CreateButtonBox $bot_frame name_list cb_arr
  if ![string compare $action NEW] {
   ${bot_frame}.box.act_0 config  \
   -command "UI_PB_ude_ParamDlgOK $w Real"
   ${bot_frame}.box.act_1 config  \
   -command "UI_PB_ude_ParamDlgCNL $w"
   } else {
   ${bot_frame}.box.act_0 config  \
   -command "UI_PB_ude_ParamDlgOK_ForEdit $w Real $isPtc"
   ${bot_frame}.box.act_1 config  \
   -command "UI_PB_ude_ParamDlgCNL $w"
  }
  pack $bot_frame -side bottom -fill x -pady 2 -padx 2
  pack $mid_frame -fill both -expand yes -padx 2 -pady 5 -side top
  if {$isPtc == 1} {
   if ![string compare $::tix_version 8.4] {
    $ve config -state disabled
    } else {
    $ve config -state disabled -bg lightblue
   }
  }
  if ![string compare $action "NEW"] {
   UI_PB_ude_CreatePreviewItem \
   [winfo parent $udeEditor::($OBJ,insert_position_w)] Real
   } else {
   if {$udeEditor::($OBJ,TYPE) == "UDC" && \
    $isPtc == 1} {
    if ![string compare $::tix_version 8.4] {
     $pe config -state disabled
     $de config -state disabled
     $sub4.m config -state disabled
     } else {
     $pe config -state disabled -bg lightblue
     $de config -state disabled -bg lightblue
     $sub4.m config -state disabled
    }
    set udeEditor::($OBJ,to_restore_value) 0
    } else {
    UI_PB_ude_CreatePreviewBehavior_ForEdit Real
   }
  }
 }

#=======================================================================
proc UI_PB_ude_CreateOptionParamDialog { w action isPtc } {
  global gPB
  global paOption
  set OBJ $udeEditor::(obj)
  bind $w <Destroy> {+ UI_PB_ude_CreateOptParamDlg_Destroy_binding %W}
  if { ![string compare $action NEW] } {
   set udeEditor::($OBJ,o_label) "Your Label"
   set udeEditor::($OBJ,o_vname) "your_name"
   set udeEditor::($OBJ,o_dvalue) ""
   set udeEditor::($OBJ,o_toggle) "None"
   set udeEditor::($OBJ,o_optlist) [list]
   set udeEditor::($OBJ,o_tempvalue) "Your Option"
   set udeEditor::($OBJ,o_cutpaste) ""
   set udeEditor::($OBJ,o_curselect) ""
   } else {
   set ui_obj $udeEditor::($OBJ,cur_edit_obj)
   $udeEditor::uiOption::($ui_obj,pathname) config \
   -highlightt 0 \
   -highlightb $udeEditor::($OBJ,indicator_for_edit_param)
   set udeEditor::($OBJ,o_label) $udeEditor::uiOption::($ui_obj,ui_label)
   set udeEditor::($OBJ,o_vname) $udeEditor::uiOption::($ui_obj,name)
   set udeEditor::($OBJ,o_dvalue) $udeEditor::uiOption::($ui_obj,cur_opt)
   set udeEditor::($OBJ,o_toggle) "None"
   set udeEditor::($OBJ,o_optlist) [list]
   foreach opt $udeEditor::uiOption::($ui_obj,opt_list) {
    lappend udeEditor::($OBJ,o_optlist) [string trim $opt \"]
   }
   set udeEditor::($OBJ,o_tempvalue) "Your Option"
   set udeEditor::($OBJ,o_cutpaste) ""
   set udeEditor::($OBJ,o_curselect) ""
  }
  set mid_frame [frame $w.mf -bd 1 -relief sunken]
  set sub1 [frame $mid_frame.1]
  set sub1_f [UI_PB_com_AddSeparator $mid_frame.1f]
  set sub2 [frame $mid_frame.2]
  set sub2_f [UI_PB_com_AddSeparator $mid_frame.2f]
  set sub3 [frame $mid_frame.3]
  set sub3_f [UI_PB_com_AddSeparator $mid_frame.3f]
  set sub5 [frame $mid_frame.5]
  set pl [label $sub1.l -text $gPB(ude,editor,paramdlg,PL,Label) -font $gPB(bold_font)]
  set pe [entry $sub1.e -width 28 -textvariable udeEditor::($OBJ,o_label)]
  set vn [label $sub2.l -text $gPB(ude,editor,paramdlg,VN,Label) -font $gPB(bold_font)]
  set ve [entry $sub2.e -width 10 -textvariable udeEditor::($OBJ,o_vname)]
  bind $ve <KeyPress> "UI_PB_com_DisableSpecialChars %W %K"
  bind $ve <KeyRelease> {%W config -state normal}
  set df [label $sub3.l -text $gPB(ude,editor,paramdlg,DF,Label) -font $gPB(bold_font)]
  set de [entry $sub3.e -width 10 -textvariable udeEditor::($OBJ,o_dvalue) \
  -state disabled]
  if { ![string compare $::tix_version 4.1] } {
   $de config -bg lightblue
  }
  set gPB(c_help,$pe) "ude,editor,paramdlg,PL"
  set gPB(c_help,$ve) "ude,editor,paramdlg,VN"
  set gPB(c_help,$de) "ude,editor,paramdlg,DF"
  if { ![string compare $::tix_version 8.4] } {
   set lf [labelframe $sub5.lf -text $gPB(ude,editor,paramdlg,OL)]
   } else {
   set lf_f [UI_PB_mthd_CreateLblFrame $sub5 lf $gPB(ude,editor,paramdlg,OL)]
   set lf [$lf_f subwidget frame]
  }
  set btns_frame [frame $lf.bf -height 20]
  set lf_e [entry $lf.e -textvariable udeEditor::($OBJ,o_tempvalue)]
  set lf_listframe [frame $lf.listframe]
  if { ![PB_com_is_true gPB(DISABLE_MIN_MAX_BUTTONS)] } {
   set ::gMapFlag($w) 0
   set map_cb   [bind $w <Map>]
   set ::gMapFlag($w) 1
   set unmap_cb [bind $w <Unmap>]
   bind $lf_listframe <Enter> "bind $w <Map> {}; bind $w <Unmap> {}"
   bind $lf_listframe <Leave> "bind $w <Map> [list $map_cb]; bind $w <Unmap> [list $unmap_cb]"
  }
  set lb [text $lf_listframe.text -yscrollcommand "$lf_listframe.yscroll set" \
  -height 5\
  -state disabled -cursor arrow -wrap none\
  -selectbackground white -width 5]
  set scl  [scrollbar $lf_listframe.yscroll -orient vertical \
  -command [list $lb yview] ]
  set btn_add [button $btns_frame.add -text $gPB(ude,editor,paramdlg,ADD,Label) \
  -command "UI_PB_ude_AddOption $lb" -takefocus 0 -bg $paOption(app_butt_bg)]
  set btn_pst [button $btns_frame.pst -text $gPB(ude,editor,paramdlg,PASTE,Label) \
  -takefocus 0 -state disabled -bg $paOption(app_butt_bg)]
  set btn_cut [button $btns_frame.cut -text $gPB(ude,editor,paramdlg,CUT,Label) \
  -takefocus 0 -state disabled -bg $paOption(app_butt_bg)]
  set udeEditor::($OBJ,cut_btn_opt) $btn_cut
  set udeEditor::($OBJ,pst_btn_opt) $btn_pst
  set gPB(c_help,$btn_add) "ude,editor,paramdlg,ADD"
  set gPB(c_help,$btn_pst) "ude,editor,paramdlg,PASTE"
  set gPB(c_help,$btn_cut) "ude,editor,paramdlg,CUT"
  set gPB(c_help,$lf_e)    "ude,editor,paramdlg,ENTRY"
  $btn_pst config -command "UI_PB_ude_PasteOption $lb $btn_pst"
  $btn_cut config -command "UI_PB_ude_CutOption $lb $btn_cut $btn_pst"
  bind $lf_e <Key-Return> "+ UI_PB_ude_AddOption $lb"
  bind $lf_e <FocusIn> "+ UI_PB_ude_OptFocusIn"
  bind $pe <FocusIn>  "+ UI_PB_ude_OptFocusIn"
  bind $ve <FocusIn>  "+ UI_PB_ude_OptFocusIn"
  bind $de <FocusIn>  "+ UI_PB_ude_OptFocusIn"
  bind $lb <Button-1> "+ UI_PB_ude_OptFocusIn"
  pack $pl -side top -anchor w
  pack $pe -fill x -pady 10 -padx 5
  pack $vn -side top -anchor w
  pack $ve -fill x -pady 10 -padx 5
  pack $df -side top -anchor w
  pack $de -fill x -pady 10 -padx 5
  pack $btns_frame $lf_e -pady 3 -fill x -padx 3 -side top
  pack $scl -side right -fill y
  pack $lb -expand yes -fill both -side left
  pack $lf_listframe -expand yes -fill both -pady 3 -padx 3
  if { ![string compare $::tix_version 8.4] } {
   pack $lf -expand yes -fill both -pady 5 -side top
   pack $btn_add $btn_cut $btn_pst -padx 6 -side left -fill x -expand yes
   } else {
   pack $lf_f -expand yes -fill both -pady 5 -side top
   pack $btn_add $btn_cut $btn_pst -padx 3 -side left -fill x -expand yes
  }
  pack $sub1 $sub1_f $sub2 $sub2_f $sub3 $sub3_f -pady 2 -padx 5 -fill x -side top
  pack $sub5 -pady 2 -padx 5 -expand yes -fill both
  set bot_frame [frame $w.bf]
  set name_list {"gPB(nav_button,ok,Label)" "gPB(nav_button,cancel,Label)"}
  set cb_arr(gPB(nav_button,ok,Label)) ""
  set cb_arr(gPB(nav_button,cancel,Label)) ""
  UI_PB_com_CreateButtonBox $bot_frame name_list cb_arr
  if { ![string compare $action NEW] } {
   ${bot_frame}.box.act_0 config  \
   -command "UI_PB_ude_ParamDlgOK $w Option $lb"
   ${bot_frame}.box.act_1 config  \
   -command "UI_PB_ude_ParamDlgCNL $w"
   } else {
   ${bot_frame}.box.act_0 config  \
   -command "UI_PB_ude_ParamDlgOK_ForEdit $w Option $isPtc $lb"
   ${bot_frame}.box.act_1 config  \
   -command "UI_PB_ude_ParamDlgCNL $w"
  }
  pack $bot_frame -side bottom -fill x -pady 2 -padx 2
  pack $mid_frame -fill both -expand yes -padx 2 -pady 5 -side top
  if { $isPtc == 1 } {
   if ![string compare $::tix_version 8.4] {
    $ve config -state disabled
    } else {
    $ve config -state disabled -bg lightblue
   }
  }
  update
  foreach opt $udeEditor::($OBJ,o_optlist) {
   UI_PB_ude_CreateOption $lb $opt
  }
  set gPB(c_help,$lb) "ude,editor,param,edit"
  if { ![string compare $action "NEW"] } {
   UI_PB_ude_CreatePreviewItem \
   [winfo parent $udeEditor::($OBJ,insert_position_w)] Option
   } else {
   if { $udeEditor::($OBJ,TYPE) == "UDC" && \
    $isPtc == 1 } {
    if { ![string compare $::tix_version 8.4] } {
     $pe      config -state disabled
     $lf_e    config -state disabled
     $btn_add config -state disabled
     } else {
     $pe      config -state disabled -bg lightblue
     $lf_e    config -state disabled -bg lightblue
     $btn_add config -state disabled
    }
    set elist [$lb window names]
    foreach one $elist {
     $one config -state disabled
     bind $one <Enter> ""
     bind $one <Leave> ""
     bind $one <Button-1> ""
     bind $one <Double-Button-1> ""
    }
    set udeEditor::($OBJ,to_restore_value) 0
    } else {
    UI_PB_ude_CreatePreviewBehavior_ForEdit Option
   }
  }
 }

#=======================================================================
proc UI_PB_ude_CreateOptionParamDialog-X {w action isPtc} {
  global gPB
  global paOption
  set OBJ $udeEditor::(obj)
  bind $w <Destroy> {+ UI_PB_ude_CreateOptParamDlg_Destroy_binding %W}
  if ![string compare $action NEW] {
   set udeEditor::($OBJ,o_label) "Your Label"
   set udeEditor::($OBJ,o_vname) "your_name"
   set udeEditor::($OBJ,o_dvalue) ""
   set udeEditor::($OBJ,o_toggle) "None"
   set udeEditor::($OBJ,o_optlist) [list]
   set udeEditor::($OBJ,o_tempvalue) "Your Option"
   set udeEditor::($OBJ,o_cutpaste) ""
   set udeEditor::($OBJ,o_curselect) ""
   } else {
   set ui_obj $udeEditor::($OBJ,cur_edit_obj)
   $udeEditor::uiOption::($ui_obj,pathname) config \
   -highlightt 0 \
   -highlightb $udeEditor::($OBJ,indicator_for_edit_param)
   set udeEditor::($OBJ,o_label) $udeEditor::uiOption::($ui_obj,ui_label)
   set udeEditor::($OBJ,o_vname) $udeEditor::uiOption::($ui_obj,name)
   set udeEditor::($OBJ,o_dvalue) $udeEditor::uiOption::($ui_obj,cur_opt)
   set udeEditor::($OBJ,o_toggle) "None"
   if 0 {
    if {$udeEditor::uiOption::($ui_obj,toggle_v) == 1} {
     set udeEditor::($OBJ,o_toggle) "On"
     } elseif {$udeEditor::uiOption::($ui_obj,toggle_v) == 0} {
     set udeEditor::($OBJ,o_toggle) "Off"
     } else {
     set udeEditor::($OBJ,o_toggle) "None"
    }
   }
   set udeEditor::($OBJ,o_optlist) [list]
   foreach opt $udeEditor::uiOption::($ui_obj,opt_list) {
    lappend udeEditor::($OBJ,o_optlist) [string trim $opt \"]
   }
   set udeEditor::($OBJ,o_tempvalue) "Your Option"
   set udeEditor::($OBJ,o_cutpaste) ""
   set udeEditor::($OBJ,o_curselect) ""
  }
  set mid_frame [frame $w.mf -bd 1 -relief sunken]
  set sub1 [frame $mid_frame.1]
  set sub1_f [UI_PB_com_AddSeparator $mid_frame.1f]
  set sub2 [frame $mid_frame.2]
  set sub2_f [UI_PB_com_AddSeparator $mid_frame.2f]
  set sub3 [frame $mid_frame.3]
  set sub3_f [UI_PB_com_AddSeparator $mid_frame.3f]
  if 0 {
   set sub4 [frame $mid_frame.4]
   set sub4_f [UI_PB_com_AddSeparator $mid_frame.4f]
  }
  set sub5 [frame $mid_frame.5]
  set pl [label $sub1.l -text $gPB(ude,editor,paramdlg,PL,Label) -font $gPB(bold_font)]
  set pe [entry $sub1.e -width 28 -textvariable udeEditor::($OBJ,o_label)]
  set vn [label $sub2.l -text $gPB(ude,editor,paramdlg,VN,Label) -font $gPB(bold_font)]
  set ve [entry $sub2.e -width 10 -textvariable udeEditor::($OBJ,o_vname)]
  bind $ve <KeyPress> "UI_PB_com_DisableSpecialChars %W %K"
  bind $ve <KeyRelease> {%W config -state normal}
  set df [label $sub3.l -text $gPB(ude,editor,paramdlg,DF,Label) -font $gPB(bold_font)]
  set de [entry $sub3.e -width 10 -textvariable udeEditor::($OBJ,o_dvalue) \
  -state disabled]
  if ![string compare $::tix_version 4.1] {
   $de config -bg lightblue
  }
  if 0 {
   set tg [label $sub4.l -text $gPB(ude,editor,paramdlg,TG) -font $gPB(bold_font)]
   set te [tk_optionMenu $sub4.m udeEditor::($OBJ,o_toggle) None On Off]
   $sub4.m config -width 4 -direction below
  }
  set gPB(c_help,$pe) "ude,editor,paramdlg,PL"
  set gPB(c_help,$ve) "ude,editor,paramdlg,VN"
  set gPB(c_help,$de) "ude,editor,paramdlg,DF"
  if ![string compare $::tix_version 8.4] {
   set lf [labelframe $sub5.lf -text $gPB(ude,editor,paramdlg,OL)]
   } else {
   set lf_f [UI_PB_mthd_CreateLblFrame $sub5 lf $gPB(ude,editor,paramdlg,OL)]
   set lf [$lf_f subwidget frame]
  }
  set btns_frame [frame $lf.bf -height 20]
  set lf_e [entry $lf.e -textvariable udeEditor::($OBJ,o_tempvalue)]
  set lf_listframe [frame $lf.listframe]
  set lb [text $lf_listframe.text -yscrollcommand "$lf_listframe.yscroll set" \
  -height 5\
  -state disabled -cursor arrow -wrap none\
  -selectbackground white -width 5]
  set scl  [scrollbar $lf_listframe.yscroll -orient vertical \
  -command [list $lb yview] ]
  set btn_add [button $btns_frame.add -text $gPB(ude,editor,paramdlg,ADD,Label) \
  -command "UI_PB_ude_AddOption $lb" -takefocus 0 -bg $paOption(app_butt_bg)]
  set btn_pst [button $btns_frame.pst -text $gPB(ude,editor,paramdlg,PASTE,Label) \
  -takefocus 0 -state disabled -bg $paOption(app_butt_bg)]
  set btn_cut [button $btns_frame.cut -text $gPB(ude,editor,paramdlg,CUT,Label) \
  -takefocus 0 -state disabled -bg $paOption(app_butt_bg)]
  set udeEditor::($OBJ,cut_btn_opt) $btn_cut
  set udeEditor::($OBJ,pst_btn_opt) $btn_pst
  set gPB(c_help,$btn_add) "ude,editor,paramdlg,ADD"
  set gPB(c_help,$btn_pst) "ude,editor,paramdlg,PASTE"
  set gPB(c_help,$btn_cut) "ude,editor,paramdlg,CUT"
  set gPB(c_help,$lf_e)    "ude,editor,paramdlg,ENTRY"
  $btn_pst config -command "UI_PB_ude_PasteOption $lb $btn_pst"
  $btn_cut config -command "UI_PB_ude_CutOption $lb $btn_cut $btn_pst"
  bind $lf_e <Key-Return> "+ UI_PB_ude_AddOption $lb"
  bind $lf_e <FocusIn> "+ UI_PB_ude_OptFocusIn"
  bind $pe <FocusIn>  "+ UI_PB_ude_OptFocusIn"
  bind $ve <FocusIn>  "+ UI_PB_ude_OptFocusIn"
  bind $de <FocusIn>  "+ UI_PB_ude_OptFocusIn"
  bind $lb <Button-1> "+ UI_PB_ude_OptFocusIn"
  pack $pl -side top -anchor w
  pack $pe -fill x -pady 10 -padx 5
  pack $vn -side top -anchor w
  pack $ve -fill x -pady 10 -padx 5
  pack $df -side top -anchor w
  pack $de -fill x -pady 10 -padx 5
  if 0 {
   pack $tg -side left -pady 14
   pack $sub4.m -side right -padx 5
  }
  pack $btns_frame $lf_e -pady 3 -fill x -padx 3 -side top
  pack $scl -side right -fill y
  pack $lb -expand yes -fill both -side left
  pack $lf_listframe -expand yes -fill both -pady 3 -padx 3
  if ![string compare $::tix_version 8.4] {
   pack $lf -expand yes -fill both -pady 5 -side top
   pack $btn_add $btn_cut $btn_pst -padx 6 -side left -fill x -expand yes
   } else {
   pack $lf_f -expand yes -fill both -pady 5 -side top
   pack $btn_add $btn_cut $btn_pst -padx 3 -side left -fill x -expand yes
  }
  if 0 {
   pack $sub1 $sub1_f $sub2 $sub2_f $sub3 $sub3_f $sub4 $sub4_f -pady 2 -padx 5 -fill x -side top
   pack $sub4_f -pady 2 -padx 5 -fill x
  }
  pack $sub1 $sub1_f $sub2 $sub2_f $sub3 $sub3_f -pady 2 -padx 5 -fill x -side top
  pack $sub5 -pady 2 -padx 5 -expand yes -fill both
  set bot_frame [frame $w.bf]
  set name_list {"gPB(nav_button,ok,Label)" "gPB(nav_button,cancel,Label)"}
  set cb_arr(gPB(nav_button,ok,Label)) ""
  set cb_arr(gPB(nav_button,cancel,Label)) ""
  UI_PB_com_CreateButtonBox $bot_frame name_list cb_arr
  if ![string compare $action NEW] {
   ${bot_frame}.box.act_0 config  \
   -command "UI_PB_ude_ParamDlgOK $w Option $lb"
   ${bot_frame}.box.act_1 config  \
   -command "UI_PB_ude_ParamDlgCNL $w"
   } else {
   ${bot_frame}.box.act_0 config  \
   -command "UI_PB_ude_ParamDlgOK_ForEdit $w Option $isPtc $lb"
   ${bot_frame}.box.act_1 config  \
   -command "UI_PB_ude_ParamDlgCNL $w"
  }
  pack $bot_frame -side bottom -fill x -pady 2 -padx 2
  pack $mid_frame -fill both -expand yes -padx 2 -pady 5 -side top
  if {$isPtc == 1} {
   if ![string compare $::tix_version 8.4] {
    $ve config -state disabled
    } else {
    $ve config -state disabled -bg lightblue
   }
  }
  update
  foreach opt $udeEditor::($OBJ,o_optlist) {
   UI_PB_ude_CreateOption $lb $opt
  }
  set gPB(c_help,$lb) "ude,editor,param,edit"
  if ![string compare $action "NEW"] {
   UI_PB_ude_CreatePreviewItem \
   [winfo parent $udeEditor::($OBJ,insert_position_w)] Option
   } else {
   if {$udeEditor::($OBJ,TYPE) == "UDC" && \
    $isPtc == 1} {
    if ![string compare $::tix_version 8.4] {
     $pe config -state disabled
     $lf_e config -state disabled
     $btn_add config -state disabled
     } else {
     $pe config -state disabled -bg lightblue
     $lf_e config -state disabled -bg lightblue
     $btn_add config -state disabled
    }
    set elist [$lb window names]
    foreach one $elist {
     $one config -state disabled
     bind $one <Enter> ""
     bind $one <Leave> ""
     bind $one <Button-1> ""
     bind $one <Double-Button-1> ""
    }
    set udeEditor::($OBJ,to_restore_value) 0
    } else {
    UI_PB_ude_CreatePreviewBehavior_ForEdit Option
   }
  }
 }

#=======================================================================
proc UI_PB_ude_CreateOptParamDlg_Destroy_binding {w} {
  set OBJ $udeEditor::(obj)
  if ![string compare $w [winfo toplevel $w]] {
   set udeEditor::($OBJ,pre_sunken_opt) ""
   set udeEditor::($OBJ,select_opt) ""
   set udeEditor::($OBJ,cut_btn_opt) ""
   set udeEditor::($OBJ,string_for_paste) ""
  }
 }

#=======================================================================
proc UI_PB_ude_CreateOption {wtext optv {index end}} {
   global gPB
   set OBJ $udeEditor::(obj)
   set elist [$wtext window names]
   if {[llength $elist] == 0} {
    set idx 0
    } else {
    set idxlist [list]
    foreach one $elist {
     set lastpoint [string last . $one]
     incr lastpoint
     lappend idxlist [string range $one $lastpoint end]
    }
    set idx [lindex [lsort -integer $idxlist] end]
    incr idx
   }
   if ![string compare $::tix_version 8.4] {
    set new_e [entry $wtext.$idx -width 0 -relief flat -cursor hand2 \
    -highlightt 1 \
    -highlightc $udeEditor::($OBJ,opt_selectcolor) \
    -highlightb white]
    $new_e config -disabledb white
    } else {
    set new_e [entry $wtext.$idx -width 0 -relief flat -cursor hand2 \
    -highlightt 1 \
    -highlightc $udeEditor::($OBJ,opt_selectcolor) \
    -highlightb white]
    $new_e config -bg white
   }
   $new_e insert end $optv
   $new_e config -state disabled
   UI_PB_ude_OptEntryBinding $new_e
   $wtext config -state normal
   if {[llength $elist] != 0} {
    $wtext insert $index "\n"
   }
   $wtext window create $index -window $new_e
   $wtext window config $new_e -pady 0
   $wtext config -state disabled
   set gPB(c_help,$new_e) "ude,editor,param,edit"
  }

#=======================================================================
proc UI_PB_ude_AddOption {w} {
  global gPB
  set OBJ $udeEditor::(obj)
  set opt $udeEditor::($OBJ,o_tempvalue)
  set opt_trimed [string trim $opt]
  if ![string compare $opt_trimed ""] {
   tk_messageBox -message $gPB(ude,editor,opt,MSG_BLANK) -icon error \
   -title $gPB(msg,error) -parent [UI_PB_com_AskActiveWindow]
   return
  }
  set elist [$w window names]
  if {[llength $elist] != 0} {
   foreach one $elist {
    set exist_opt [$one get]
    if ![string compare $opt $exist_opt] {
     tk_messageBox -message $gPB(ude,editor,opt,MSG_SAME) -icon error \
     -title $gPB(msg,error) -parent [UI_PB_com_AskActiveWindow]
     return
    }
   }
  }
  UI_PB_ude_OptFocusIn
  set sel_opt $udeEditor::($OBJ,select_opt)
  if {$sel_opt == ""} {
   set idx end
   } else {
   set idx [$w index $sel_opt]
  }
  UI_PB_ude_CreateOption $w $udeEditor::($OBJ,o_tempvalue) $idx
 }

#=======================================================================
proc UI_PB_ude_OptEntryBinding {w} {
  bind $w <Enter> "UI_PB_ude_OptEntryBinding_Enter %W"
  bind $w <Leave> "UI_PB_ude_OptEntryBinding_Leave %W"
  bind $w <Button-1> "UI_PB_ude_OptEntryBinding_B1 %W"
  bind $w <Double-Button-1> "UI_PB_ude_OptEntryBinding_DB1 %W"
  bind $w <Return> "UI_PB_ude_OptEntryBinding_Rtn %W"
 }

#=======================================================================
proc UI_PB_ude_OptEntryBinding_Rtn {w} {
  global gPB
  set OBJ $udeEditor::(obj)
  if {$gPB(use_info)} {
   return
  }
  if { [UI_PB_ude_OptValidation $w] != 0 } {
   tk_messageBox -message $gPB(ude,editor,opt,MSG_SAME) -icon error \
   -title $gPB(msg,error) -parent [UI_PB_com_AskActiveWindow]
   focus $w
   $w icursor end
   return
  }
  global g_opt_db_flag
  set g_opt_db_flag 0
  set udeEditor::($OBJ,o_dvalue) [$w get]
  $w config -state disabled -relief flat
  set udeEditor::($OBJ,pre_sunken_opt) ""
 }

#=======================================================================
proc UI_PB_ude_OptValidation {w} {
  global gPB
  set wtext [winfo parent $w]
  set result 0
  set opt [$w get]
  set opt_trimed [string trim $opt]
  if ![string compare $opt_trimed ""] {
   set result 1
  }
  set elist [$wtext window names]
  set idx [lsearch $elist $w]
  set elist [lreplace $elist $idx $idx]
  if {[llength $elist] != 0} {
   foreach one $elist {
    set exist_opt [$one get]
    if ![string compare $opt $exist_opt] {
     set result 2
    }
   }
  }
  return $result
 }

#=======================================================================
proc UI_PB_ude_OptEntryBinding_Enter {w} {
  global gPB
  set OBJ $udeEditor::(obj)
  if {$gPB(use_info)} {
   return
  }
  if ![string compare $::tix_version 8.4] {
   $w config -disabledb $udeEditor::($OBJ,opt_highlight)
   } else {
   if {$udeEditor::($OBJ,pre_sunken_opt) != $w} {
    $w config -bg $udeEditor::($OBJ,opt_highlight)
   }
  }
  if {$udeEditor::($OBJ,pre_sunken_opt) == ""} {
   focus [winfo parent $w]
  }
 }

#=======================================================================
proc UI_PB_ude_OptEntryBinding_Leave {w} {
  global gPB
  if {$gPB(use_info)} {
   return
  }
  if ![string compare $::tix_version 8.4] {
   $w config -disabledb white
   } else {
   $w config -bg white
  }
 }

#=======================================================================
proc UI_PB_ude_OptEntryBinding_B1 {w} {
  global gPB
  if {$gPB(use_info)} {
   return
  }
  set OBJ $udeEditor::(obj)
  global g_opt_db_flag
  if { [info exists g_opt_db_flag] && $g_opt_db_flag && \
   $udeEditor::($OBJ,pre_sunken_opt) != "" } {
   if { [string compare $w $udeEditor::($OBJ,pre_sunken_opt)] == 0 } {
    return
   }
   if { [UI_PB_ude_OptValidation $udeEditor::($OBJ,pre_sunken_opt)] } {
    tk_messageBox -message $gPB(ude,editor,opt,MSG_SAME) -icon error \
    -title $gPB(msg,error) -parent [UI_PB_com_AskActiveWindow]
    focus $udeEditor::($OBJ,pre_sunken_opt)
    $udeEditor::($OBJ,pre_sunken_opt) icursor end
    return
   }
  }
  set g_opt_db_flag 0
  set udeEditor::($OBJ,o_dvalue) [$w get]
  $w config -highlightb $udeEditor::($OBJ,opt_selectcolor)
  focus [winfo parent $w]
  if {$udeEditor::($OBJ,pre_sunken_opt) == $w} {
   return
   } else {
   if {$udeEditor::($OBJ,pre_sunken_opt) != ""} {
    $udeEditor::($OBJ,pre_sunken_opt) xview 0
    $udeEditor::($OBJ,pre_sunken_opt) config -highlightb white \
    -highlightc white
    $udeEditor::($OBJ,pre_sunken_opt) config -relief flat \
    -state disabled
    set udeEditor::($OBJ,pre_sunken_opt) ""
   }
  }
  if {$udeEditor::($OBJ,select_opt) == $w} {
   set udeEditor::($OBJ,select_opt) $w
   set gPB(after_id) [after 300 [list $udeEditor::($OBJ,cut_btn_opt) \
   config -state normal]]
   if {$udeEditor::($OBJ,string_for_paste) != ""} {
    $udeEditor::($OBJ,pst_btn_opt) config -state normal
   }
   } else {
   if {$udeEditor::($OBJ,select_opt) != ""} {
    $udeEditor::($OBJ,select_opt) config -highlightc white \
    -highlightb white
   }
   set udeEditor::($OBJ,select_opt) $w
   set gPB(after_id) [after 300 [list $udeEditor::($OBJ,cut_btn_opt) \
   config -state normal]]
   if {$udeEditor::($OBJ,string_for_paste) != ""} {
    $udeEditor::($OBJ,pst_btn_opt) config -state normal
   }
  }
 }

#=======================================================================
proc UI_PB_ude_OptEntryBinding_DB1 {w} {
  global gPB
  set OBJ $udeEditor::(obj)
  global g_opt_db_flag
  set g_opt_db_flag 1
  if {$udeEditor::($OBJ,pre_sunken_opt) == $w} {
   return
   } else {
   if {$udeEditor::($OBJ,pre_sunken_opt) != ""} {
    $udeEditor::($OBJ,pre_sunken_opt) xview 0
    $udeEditor::($OBJ,pre_sunken_opt) config -highlightb white \
    -highlightc white
    $udeEditor::($OBJ,pre_sunken_opt) config -relief flat -state disabled
   }
  }
  if [info exists gPB(after_id)] {
   after cancel $gPB(after_id)
   unset gPB(after_id)
  }
  $w config -relief sunken -state normal
  if ![string compare $::tix_version 4.1] {
   $w config -bg white
  }
  focus $w
  $w icursor end
  $w config -highlightc $udeEditor::($OBJ,opt_selectcolor)
  set udeEditor::($OBJ,pre_sunken_opt) $w
  $udeEditor::($OBJ,cut_btn_opt) config -state disabled
  $udeEditor::($OBJ,pst_btn_opt) config -state disabled
 }

#=======================================================================
proc UI_PB_ude_OptFocusIn {} {
  set OBJ $udeEditor::(obj)
  if {$udeEditor::($OBJ,pre_sunken_opt) != ""} {
   global g_opt_db_flag
   if { [info exists g_opt_db_flag] && $g_opt_db_flag && \
    [UI_PB_ude_OptValidation $udeEditor::($OBJ,pre_sunken_opt)] != 0 } {
    focus $udeEditor::($OBJ,pre_sunken_opt)
    $udeEditor::($OBJ,pre_sunken_opt) icursor end
    global gPB
    tk_messageBox -message $gPB(ude,editor,opt,MSG_SAME) -icon error \
    -title $gPB(msg,error) -parent [UI_PB_com_AskActiveWindow]
    return
   }
   set g_opt_db_flag 0
   $udeEditor::($OBJ,pre_sunken_opt) xview 0
   $udeEditor::($OBJ,pre_sunken_opt) config -relief flat -state disabled
   set udeEditor::($OBJ,o_dvalue) [$udeEditor::($OBJ,pre_sunken_opt) get]
   set udeEditor::($OBJ,pre_sunken_opt) ""
   $udeEditor::($OBJ,cut_btn_opt) config -state normal
   if {$udeEditor::($OBJ,string_for_paste) != ""} {
    $udeEditor::($OBJ,pst_btn_opt) config -state normal
   }
  }
 }

#=======================================================================
proc UI_PB_ude_PasteOption {tw pw} {
  global gPB
  set OBJ $udeEditor::(obj)
  set elist [$tw window names]
  if {[llength $elist] != 0} {
   foreach one $elist {
    set exist_opt [$one get]
    if ![string compare $udeEditor::($OBJ,string_for_paste) $exist_opt] {
     tk_messageBox -message $gPB(ude,editor,opt,MSG_PST_SAME) -icon error \
     -title $gPB(msg,error) -parent [UI_PB_com_AskActiveWindow]
     $pw config -state disabled
     return
    }
   }
  }
  UI_PB_ude_OptFocusIn
  set sel_opt $udeEditor::($OBJ,select_opt)
  if {$sel_opt == ""} {
   set idx end
   } else {
   set idx [$tw index $sel_opt]
  }
  UI_PB_ude_CreateOption $tw $udeEditor::($OBJ,string_for_paste) $idx
  $pw config -state disabled
  set udeEditor::($OBJ,string_for_paste) "" ;#<10-16-09 wbh> Empty the string.
 }

#=======================================================================
proc UI_PB_ude_CutOption {tw cw pw} {
  set OBJ $udeEditor::(obj)
  if {$udeEditor::($OBJ,pre_sunken_opt) == ""} {
   set select_opt $udeEditor::($OBJ,select_opt)
   set udeEditor::($OBJ,string_for_paste) [$select_opt get]
   $tw config -state normal
   $tw delete "$select_opt linestart" "$select_opt lineend +1 char"
   $tw config -state disabled
   set udeEditor::($OBJ,select_opt) ""
   set elist [$tw window names]
   if {[llength $elist] == 0} {
    $cw config -state disabled
   }
   $cw config -state disabled
   if {$udeEditor::($OBJ,string_for_paste) != ""} {
    $pw config -state normal
   }
  }
 }

#=======================================================================
proc UI_PB_ude_CreateTextParamDialog {w action isPtc} {
  global gPB
  set OBJ $udeEditor::(obj)
  if ![string compare $action NEW] {
   set udeEditor::($OBJ,t_label) "Your Label"
   set udeEditor::($OBJ,t_vname) "your_name"
   set udeEditor::($OBJ,t_dvalue) "Your Text"
   set udeEditor::($OBJ,t_toggle) "On"
   } else {
   set ui_obj $udeEditor::($OBJ,cur_edit_obj)
   $udeEditor::uiText::($ui_obj,pathname) config \
   -highlightt 0 \
   -highlightb $udeEditor::($OBJ,indicator_for_edit_param)
   set udeEditor::($OBJ,t_label) $udeEditor::uiText::($ui_obj,ui_label)
   set udeEditor::($OBJ,t_vname) $udeEditor::uiText::($ui_obj,name)
   set udeEditor::($OBJ,t_dvalue) $udeEditor::uiText::($ui_obj,value)
   if {$udeEditor::uiText::($ui_obj,toggle_v) == 1} {
    set udeEditor::($OBJ,t_toggle) "On"
    } elseif {$udeEditor::uiText::($ui_obj,toggle_v) == 0} {
    set udeEditor::($OBJ,t_toggle) "Off"
    } else {
    set udeEditor::($OBJ,t_toggle) "None"
   }
  }
  set mid_frame [frame $w.mf -bd 1 -relief sunken]
  set sub1 [frame $mid_frame.1]
  set sub1_f [UI_PB_com_AddSeparator $mid_frame.1f]
  set sub2 [frame $mid_frame.2]
  set sub2_f [UI_PB_com_AddSeparator $mid_frame.2f]
  set sub3 [frame $mid_frame.3]
  set sub3_f [UI_PB_com_AddSeparator $mid_frame.3f]
  set sub4 [frame $mid_frame.4]
  set pl [label $sub1.l -text $gPB(ude,editor,paramdlg,PL,Label) -font $gPB(bold_font)]
  set pe [entry $sub1.e -width 28 -textvariable udeEditor::($OBJ,t_label)]
  set vn [label $sub2.l -text $gPB(ude,editor,paramdlg,VN,Label) -font $gPB(bold_font)]
  set ve [entry $sub2.e -width 10 -textvariable udeEditor::($OBJ,t_vname)]
  bind $ve <KeyPress> "UI_PB_com_DisableSpecialChars %W %K"
  bind $ve <KeyRelease> {%W config -state normal}
  set df [label $sub3.l -text $gPB(ude,editor,paramdlg,DF,Label) -font $gPB(bold_font)]
  set de [entry $sub3.e -width 10 -textvariable udeEditor::($OBJ,t_dvalue)]
  set tg [label $sub4.l -text $gPB(ude,editor,paramdlg,TG) -font $gPB(bold_font)]
  set te [tk_optionMenu $sub4.m udeEditor::($OBJ,t_toggle) None On Off]
  $sub4.m config -width 4 -direction below
  set gPB(c_help,$pe) "ude,editor,paramdlg,PL"
  set gPB(c_help,$ve) "ude,editor,paramdlg,VN"
  set gPB(c_help,$de) "ude,editor,paramdlg,DF"
  set gPB(c_help,$sub4.m) "ude,editor,paramdlg,TG,B"
  pack $pl -side top -anchor w
  pack $pe -padx 5 -fill x -pady 10
  pack $vn -side top -anchor w
  pack $ve -padx 5 -fill x -pady 10
  pack $df -side top -anchor w
  pack $de -padx 5 -fill x -pady 10
  pack $tg -side left  -anchor w -pady 14
  pack $sub4.m -side right -padx 3
  pack $sub1 $sub1_f $sub2 $sub2_f $sub3 $sub3_f $sub4 -pady 2 -padx 5 -fill x
  set bot_frame [frame $w.bf]
  set name_list {"gPB(nav_button,ok,Label)" "gPB(nav_button,cancel,Label)"}
  set cb_arr(gPB(nav_button,ok,Label)) ""
  set cb_arr(gPB(nav_button,cancel,Label)) ""
  UI_PB_com_CreateButtonBox $bot_frame name_list cb_arr
  if ![string compare $action NEW] {
   ${bot_frame}.box.act_0 config  \
   -command "UI_PB_ude_ParamDlgOK $w Text"
   ${bot_frame}.box.act_1 config  \
   -command "UI_PB_ude_ParamDlgCNL $w"
   } else {
   ${bot_frame}.box.act_0 config  \
   -command "UI_PB_ude_ParamDlgOK_ForEdit $w Text $isPtc"
   ${bot_frame}.box.act_1 config  \
   -command "UI_PB_ude_ParamDlgCNL $w"
  }
  pack $bot_frame -side bottom -fill x -pady 2 -padx 2
  pack $mid_frame  -fill both -expand yes -padx 2 -pady 5 -side top
  if {$isPtc == 1} {
   if ![string compare $::tix_version 8.4] {
    $ve config -state disabled
    } else {
    $ve config -state disabled -bg lightblue
   }
  }
  if ![string compare $action "NEW"] {
   UI_PB_ude_CreatePreviewItem \
   [winfo parent $udeEditor::($OBJ,insert_position_w)] Text
   } else {
   if { $udeEditor::($OBJ,TYPE) == "UDC" && \
    $isPtc == 1 } {
    if { ![string compare $::tix_version 8.4] } {
     $pe config -state disabled
     $de config -state disabled
     $sub4.m config -state disabled
     } else {
     $pe config -state disabled -bg lightblue
     $de config -state disabled -bg lightblue
     $sub4.m config -state disabled
    }
    set udeEditor::($OBJ,to_restore_value) 0
    } else {
    UI_PB_ude_CreatePreviewBehavior_ForEdit Text
   }
  }
 }

#=======================================================================
proc UI_PB_ude_CreatePointParamDialog {w action isPtc} {
  global gPB
  set OBJ $udeEditor::(obj)
  if ![string compare $action NEW] {
   set udeEditor::($OBJ,p_label) "Your Label"
   set udeEditor::($OBJ,p_vname) "your_name"
   set udeEditor::($OBJ,p_toggle) "On"
   } else {
   set ui_obj $udeEditor::($OBJ,cur_edit_obj)
   $udeEditor::uiPoint::($ui_obj,pathname) config \
   -highlightt 0 \
   -highlightb $udeEditor::($OBJ,indicator_for_edit_param)
   set udeEditor::($OBJ,p_label) $udeEditor::uiPoint::($ui_obj,ui_label)
   set udeEditor::($OBJ,p_vname) $udeEditor::uiPoint::($ui_obj,name)
   if {$udeEditor::uiPoint::($ui_obj,toggle_v) == 1} {
    set udeEditor::($OBJ,p_toggle) "On"
    } elseif {$udeEditor::uiPoint::($ui_obj,toggle_v) == 0} {
    set udeEditor::($OBJ,p_toggle) "Off"
    } else {
    set udeEditor::($OBJ,p_toggle) "None"
   }
  }
  set mid_frame [frame $w.mf -bd 1 -relief sunken]
  set sub1 [frame $mid_frame.1]
  set sub1_f [UI_PB_com_AddSeparator $mid_frame.1f]
  set sub2 [frame $mid_frame.2]
  set sub2_f [UI_PB_com_AddSeparator $mid_frame.2f]
  set sub4 [frame $mid_frame.4]
  set pl [label $sub1.l -text $gPB(ude,editor,paramdlg,PL,Label) -font $gPB(bold_font)]
  set pe [entry $sub1.e -width 28 -textvariable udeEditor::($OBJ,p_label)]
  set vn [label $sub2.l -text $gPB(ude,editor,paramdlg,VN,Label) -font $gPB(bold_font)]
  set ve [entry $sub2.e -width 10 -textvariable udeEditor::($OBJ,p_vname)]
  bind $ve <KeyPress> "UI_PB_com_DisableSpecialChars %W %K"
  bind $ve <KeyRelease> {%W config -state normal}
  set tg [label $sub4.l -text $gPB(ude,editor,paramdlg,TG) -font $gPB(bold_font)]
  set te [tk_optionMenu $sub4.m udeEditor::($OBJ,p_toggle) None On Off]
  $sub4.m config -width 4 -direction  below
  set gPB(c_help,$pe) "ude,editor,paramdlg,PL"
  set gPB(c_help,$ve) "ude,editor,paramdlg,VN"
  set gPB(c_help,$sub4.m) "ude,editor,paramdlg,TG,B"
  pack $pl -side top -anchor w
  pack $pe -padx 5 -fill x -pady 10
  pack $vn -side top  -anchor w
  pack $ve  -padx 5 -fill x -pady 10
  pack $tg -side left -anchor w -pady 14
  pack $sub4.m -side right -padx 3
  pack $sub1 $sub1_f $sub2 $sub2_f $sub4 -pady 2 -padx 5 -fill x
  set bot_frame [frame $w.bf]
  set name_list {"gPB(nav_button,ok,Label)" "gPB(nav_button,cancel,Label)"}
  set cb_arr(gPB(nav_button,ok,Label)) ""
  set cb_arr(gPB(nav_button,cancel,Label)) ""
  UI_PB_com_CreateButtonBox $bot_frame name_list cb_arr
  if ![string compare $action NEW] {
   ${bot_frame}.box.act_0 config  \
   -command "UI_PB_ude_ParamDlgOK $w Point"
   ${bot_frame}.box.act_1 config  \
   -command "UI_PB_ude_ParamDlgCNL $w"
   } else {
   ${bot_frame}.box.act_0 config  \
   -command "UI_PB_ude_ParamDlgOK_ForEdit $w Point $isPtc"
   ${bot_frame}.box.act_1 config  \
   -command "UI_PB_ude_ParamDlgCNL $w"
  }
  pack $bot_frame -side bottom -fill x -pady 2 -padx 2
  pack $mid_frame -fill both -expand yes -padx 2 -pady 5 -side top
  if {$isPtc == 1} {
   if ![string compare $::tix_version 8.4] {
    $ve config -state disabled
    } else {
    $ve config -state disabled -bg lightblue
   }
  }
  if ![string compare $action "NEW"] {
   UI_PB_ude_CreatePreviewItem \
   [winfo parent $udeEditor::($OBJ,insert_position_w)] Point
   } else {
   if {$udeEditor::($OBJ,TYPE) == "UDC" && \
    $isPtc == 1} {
    if ![string compare $::tix_version 8.4] {
     $pe config -state disabled
     $sub4.m config -state disabled
     } else {
     $pe config -state disabled -bg lightblue
     $sub4.m config -state disabled
    }
    set udeEditor::($OBJ,to_restore_value) 0
    } else {
    UI_PB_ude_CreatePreviewBehavior_ForEdit Point
   }
  }
 }

#=======================================================================
proc UI_PB_ude_CreateBooleanParamDialog {w action isPtc} {
  global gPB
  set OBJ $udeEditor::(obj)
  if ![string compare $action NEW] {
   set udeEditor::($OBJ,b_label) "Your Label"
   set udeEditor::($OBJ,b_vname) "your_name"
   set udeEditor::($OBJ,b_dvalue) "TRUE"
   } else {
   set ui_obj $udeEditor::($OBJ,cur_edit_obj)
   $udeEditor::uiBoolean::($ui_obj,pathname) config \
   -highlightt 0 \
   -highlightb $udeEditor::($OBJ,indicator_for_edit_param)
   set udeEditor::($OBJ,b_label) $udeEditor::uiBoolean::($ui_obj,ui_label)
   set udeEditor::($OBJ,b_vname) $udeEditor::uiBoolean::($ui_obj,name)
   if {$udeEditor::uiBoolean::($ui_obj,toggle_v) == 1} {
    set udeEditor::($OBJ,b_dvalue) "TRUE"
    } else {
    set udeEditor::($OBJ,b_dvalue) "FALSE"
   }
  }
  set mid_frame [frame $w.mf -bd 1 -relief sunken]
  set sub1 [frame $mid_frame.1]
  set sub1_f [UI_PB_com_AddSeparator $mid_frame.1f]
  set sub2 [frame $mid_frame.2]
  set sub2_f [UI_PB_com_AddSeparator $mid_frame.2f]
  set sub3 [frame $mid_frame.3]
  set pl [label $sub1.l -text $gPB(ude,editor,paramdlg,PL,Label) -font $gPB(bold_font)]
  set pe [entry $sub1.e -width 28 -textvariable udeEditor::($OBJ,b_label)]
  set vn [label $sub2.l -text $gPB(ude,editor,paramdlg,VN,Label) -font $gPB(bold_font)]
  set ve [entry $sub2.e -width 10 -textvariable udeEditor::($OBJ,b_vname)]
  bind $ve <KeyPress> "UI_PB_com_DisableSpecialChars %W %K"
  bind $ve <KeyRelease> {%W config -state normal}
  if ![string compare $::tix_version 8.4] {
   set lf [labelframe $sub3.lf -text $gPB(ude,editor,paramdlg,DF,Label)]
   } else {
   set lf_f [UI_PB_mthd_CreateLblFrame $sub3 lf $gPB(ude,editor,paramdlg,DF,Label)]
   set lf [$lf_f subwidget frame]
  }
  set rbON  [radiobutton $lf.on -variable udeEditor::($OBJ,b_dvalue) \
  -value TRUE -text $gPB(ude,editor,paramdlg,ON,Label)]
  set rbOFF [radiobutton $lf.off -variable udeEditor::($OBJ,b_dvalue) \
  -value FALSE  -text $gPB(ude,editor,paramdlg,OFF,Label)]
  set gPB(c_help,$pe) "ude,editor,paramdlg,PL"
  set gPB(c_help,$ve) "ude,editor,paramdlg,VN"
  set gPB(c_help,$rbON)  "ude,editor,paramdlg,ON"
  set gPB(c_help,$rbOFF) "ude,editor,paramdlg,OFF"
  pack $pl -side top -anchor w
  pack $pe -fill x -pady 10  -padx 5
  pack $vn -side top -anchor w
  pack $ve -fill x -pady 10  -padx 5
  if ![string compare $::tix_version 8.4] {
   pack $lf -expand yes -fill x -padx 3 -pady 10
   } else {
   pack $lf_f -expand yes -fill x -padx 1 -pady 10
  }
  pack $rbON -side left -padx 20 -pady 10
  pack $rbOFF -side right -padx 20 -pady 10
  pack $sub1 $sub1_f $sub2 $sub2_f $sub3 -pady 2 -padx 5 -fill x
  set bot_frame [frame $w.bf]
  set name_list {"gPB(nav_button,ok,Label)" "gPB(nav_button,cancel,Label)"}
  set cb_arr(gPB(nav_button,ok,Label)) ""
  set cb_arr(gPB(nav_button,cancel,Label)) ""
  UI_PB_com_CreateButtonBox $bot_frame name_list cb_arr
  if ![string compare $action NEW] {
   ${bot_frame}.box.act_0 config  \
   -command "UI_PB_ude_ParamDlgOK $w Boolean"
   ${bot_frame}.box.act_1 config  \
   -command "UI_PB_ude_ParamDlgCNL $w"
   } else {
   ${bot_frame}.box.act_0 config  \
   -command "UI_PB_ude_ParamDlgOK_ForEdit $w Boolean $isPtc"
   ${bot_frame}.box.act_1 config  \
   -command "UI_PB_ude_ParamDlgCNL $w"
  }
  pack $bot_frame -side bottom -fill x -pady 2 -padx 2
  pack $mid_frame -fill both -expand yes -padx 2 -side top -pady 5
  if {$isPtc == 1} {
   if ![string compare $::tix_version 8.4] {
    $ve config -state disabled
    } else {
    $ve config -state disabled -bg lightblue
   }
  }
  if ![string compare $action "NEW"] {
   UI_PB_ude_CreatePreviewItem \
   [winfo parent $udeEditor::($OBJ,insert_position_w)] Boolean
   } else {
   if {$udeEditor::($OBJ,TYPE) == "UDC" && \
    $isPtc == 1} {
    if ![string compare $::tix_version 8.4] {
     $pe config -state disabled
     $rbON config -state disabled
     $rbOFF config -state disabled
     } else {
     $pe config -state disabled -bg lightblue
     $rbON config -state disabled
     $rbOFF config -state disabled
    }
    set udeEditor::($OBJ,to_restore_value) 0
    } else {
    UI_PB_ude_CreatePreviewBehavior_ForEdit Boolean
   }
  }
 }

#=======================================================================
proc UI_PB_ude_CreateBitmapParamDialog {w action isPtc} {
  global gPB
  set OBJ $udeEditor::(obj)
  if ![string compare $action NEW] {
   set udeEditor::($OBJ,l_vname) "your_name"
   set udeEditor::($OBJ,l_dvalue) "Your_Bitmap.bmp"
   } else {
   set ui_obj $udeEditor::($OBJ,cur_edit_obj)
   $udeEditor::uiBitmap::($ui_obj,pathname) config \
   -highlightt 0 \
   -highlightb $udeEditor::($OBJ,indicator_for_edit_param)
   set udeEditor::($OBJ,l_vname) $udeEditor::uiBitmap::($ui_obj,name)
   set udeEditor::($OBJ,l_dvalue) $udeEditor::uiBitmap::($ui_obj,value)
  }
  set mid_frame [frame $w.mf -bd 1 -relief sunken]
  set sub2 [frame $mid_frame.2]
  set sub2_f [UI_PB_com_AddSeparator $mid_frame.2f]
  set sub3 [frame $mid_frame.3]
  set vn [label $sub2.l -text $gPB(ude,editor,paramdlg,VN,Label) -font $gPB(bold_font)]
  set ve [entry $sub2.e -width 10 -textvariable udeEditor::($OBJ,l_vname)]
  bind $ve <KeyPress> "UI_PB_com_DisableSpecialChars %W %K"
  bind $ve <KeyRelease> {%W config -state normal}
  set df [label $sub3.l -text $gPB(ude,editor,paramdlg,DF,Label) -font $gPB(bold_font)]
  set de [entry $sub3.e -width 10 -textvariable udeEditor::($OBJ,l_dvalue)]
  set gPB(c_help,$ve) "ude,editor,paramdlg,VN"
  set gPB(c_help,$de) "ude,editor,paramdlg,DF"
  pack $vn -side top -anchor w
  pack $ve -padx 5 -fill x -pady 10
  pack $df -side top -anchor w
  pack $de -padx 5 -fill x -pady 10
  pack $sub2 $sub2_f $sub3 -pady 2 -padx 5 -fill x
  set bot_frame [frame $w.bf]
  set name_list {"gPB(nav_button,ok,Label)" "gPB(nav_button,cancel,Label)"}
  set cb_arr(gPB(nav_button,ok,Label)) ""
  set cb_arr(gPB(nav_button,cancel,Label)) ""
  UI_PB_com_CreateButtonBox $bot_frame name_list cb_arr
  if ![string compare $action NEW] {
   ${bot_frame}.box.act_0 config  \
   -command "UI_PB_ude_ParamDlgOK $w Bitmap"
   ${bot_frame}.box.act_1 config  \
   -command "UI_PB_ude_ParamDlgCNL $w"
   } else {
   ${bot_frame}.box.act_0 config  \
   -command "UI_PB_ude_ParamDlgOK_ForEdit $w Bitmap $isPtc"
   ${bot_frame}.box.act_1 config  \
   -command "UI_PB_ude_ParamDlgCNL $w"
  }
  pack $bot_frame -side bottom -fill x -pady 2 -padx 2
  pack $mid_frame  -fill both -expand yes -padx 2 -pady 5 -side top
  if {$isPtc == 1} {
   if ![string compare $::tix_version 8.4] {
    $ve config -state disabled
    } else {
    $ve config -state disabled -bg lightblue
   }
  }
  if ![string compare $action "NEW"] {
   UI_PB_ude_CreatePreviewItem \
   [winfo parent $udeEditor::($OBJ,insert_position_w)] Bitmap
   } else {
   if {$udeEditor::($OBJ,TYPE) == "UDC" && \
    $isPtc == 1} {
    if ![string compare $::tix_version 8.4] {
     $de config -state disabled
     } else {
     $de config -state disabled -bg lightblue
    }
    set udeEditor::($OBJ,to_restore_value) 0
    } else {
    UI_PB_ude_CreatePreviewBehavior_ForEdit Bitmap
   }
  }
 }

#=======================================================================
proc UI_PB_ude_CreateGroupParamDialog {w action isPtc} {
  global gPB
  set OBJ $udeEditor::(obj)
  bind $w <Destroy> {+ UI_PB_ude_CreateGroupParamDlg_Destroy_binding %W}
  if ![string compare $action NEW] {
   set udeEditor::($OBJ,g_label) "Your Label"
   set udeEditor::($OBJ,g_vname) "your_name"
   set udeEditor::($OBJ,g_dvalue) "start_open"
   } else {
   set ui_obj $udeEditor::($OBJ,cur_edit_obj)
   $udeEditor::uiGroup::($ui_obj,pathname) config \
   -highlightt 0 \
   -highlightb $udeEditor::($OBJ,indicator_for_edit_param)
   set udeEditor::($OBJ,g_label) $udeEditor::uiGroup::($ui_obj,ui_label)
   set udeEditor::($OBJ,g_vname) $udeEditor::uiGroup::($ui_obj,name)
   set udeEditor::($OBJ,g_dvalue) $udeEditor::uiGroup::($ui_obj,value)
  }
  set mid_frame [frame $w.mf -bd 1 -relief sunken]
  set sub1 [frame $mid_frame.1]
  set sub1_f [UI_PB_com_AddSeparator $mid_frame.1f]
  set sub2 [frame $mid_frame.2]
  set sub2_f [UI_PB_com_AddSeparator $mid_frame.2f]
  set sub3 [frame $mid_frame.3]
  set pl [label $sub1.l -text $gPB(ude,editor,paramdlg,PL,Label) -font $gPB(bold_font)]
  set pe [entry $sub1.e -width 28 -textvariable udeEditor::($OBJ,g_label)]
  set vn [label $sub2.l -text $gPB(ude,editor,paramdlg,VN,Label) -font $gPB(bold_font)]
  set ve [entry $sub2.e -width 10 -textvariable udeEditor::($OBJ,g_vname)]
  bind $ve <KeyPress> "UI_PB_com_DisableSpecialChars %W %K"
  bind $ve <KeyRelease> {%W config -state normal}
  set df [label $sub3.l -text $gPB(ude,editor,paramdlg,DF,Label) -font $gPB(bold_font)]
  set rd_frm [frame $sub3.f]
  set rd1 [radiobutton $rd_frm.open -text "start_open" -variable udeEditor::($OBJ,g_dvalue) \
  -value "start_open" -anchor w]
  set rd2 [radiobutton $rd_frm.closed -text "start_closed" -variable udeEditor::($OBJ,g_dvalue) \
  -value "start_closed" -anchor w]
  pack $pl -side top -anchor w
  pack $pe -fill x -pady 10 -padx 5
  pack $vn -side top -anchor w
  pack $ve -fill x -pady 10 -padx 5
  pack $df $rd_frm -side top -anchor w
  pack $rd1 $rd2 -side left -fill x -pady 10 -padx 5
  pack $sub1 $sub1_f $sub2 $sub2_f $sub3 -pady 2 -padx 5 -fill x -side top
  set bot_frame [frame $w.bf]
  set name_list {"gPB(nav_button,ok,Label)" "gPB(nav_button,cancel,Label)"}
  set cb_arr(gPB(nav_button,ok,Label)) ""
  set cb_arr(gPB(nav_button,cancel,Label)) ""
  UI_PB_com_CreateButtonBox $bot_frame name_list cb_arr
  if ![string compare $action NEW] {
   ${bot_frame}.box.act_0 config  \
   -command "UI_PB_ude_ParamDlgOK $w Group"
   ${bot_frame}.box.act_1 config  \
   -command "UI_PB_ude_ParamDlgCNL $w"
   } else {
   ${bot_frame}.box.act_0 config  \
   -command "UI_PB_ude_ParamDlgOK_ForEdit $w Group $isPtc"
   ${bot_frame}.box.act_1 config  \
   -command "UI_PB_ude_ParamDlgCNL $w"
  }
  pack $bot_frame -side bottom -fill x -pady 2 -padx 2
  pack $mid_frame -fill both -expand yes -padx 2 -pady 5 -side top
  if {$isPtc == 1} {
   if ![string compare $::tix_version 8.4] {
    $ve config -state disabled
    } else {
    $ve config -state disabled -bg lightblue
   }
  }
  update
  set gPB(ude,group,radio1) $rd1
  set gPB(ude,group,radio2) $rd2
  if ![string compare $action "NEW"] {
   UI_PB_ude_CreatePreviewItem \
   [winfo parent $udeEditor::($OBJ,insert_position_w)] Group
   } else {
   set temp_w $udeEditor::uiGroup::($ui_obj,pathname)
   $rd1 configure -command "UI_PB_ude_ClickGroupIcon $temp_w start_open"
   $rd2 configure -command "UI_PB_ude_ClickGroupIcon $temp_w start_closed"
   if {$udeEditor::($OBJ,TYPE) == "UDC" && \
    $isPtc == 1} {
    if ![string compare $::tix_version 8.4] {
     $pe config -state disabled
     } else {
     $pe config -state disabled -bg lightblue
    }
    set udeEditor::($OBJ,to_restore_value) 0
    } else {
    UI_PB_ude_CreatePreviewBehavior_ForEdit Group
   }
  }
 }

#=======================================================================
proc UI_PB_ude_CreateGroupParamDlg_Destroy_binding {w} {
  set OBJ $udeEditor::(obj)
  if ![string compare $w [winfo toplevel $w]] {
   set udeEditor::($OBJ,pre_sunken_opt) ""
   set udeEditor::($OBJ,select_opt) ""
   set udeEditor::($OBJ,cut_btn_opt) ""
   set udeEditor::($OBJ,string_for_paste) ""
  }
 }

#=======================================================================
proc UI_PB_ude_CreateVectorParamDialog {w action isPtc} {
  global gPB
  set OBJ $udeEditor::(obj)
  if ![string compare $action NEW] {
   set udeEditor::($OBJ,v_label) "Your Label"
   set udeEditor::($OBJ,v_vname) "your_name"
   set udeEditor::($OBJ,v_toggle) "On"
   } else {
   set ui_obj $udeEditor::($OBJ,cur_edit_obj)
   $udeEditor::uiVector::($ui_obj,pathname) config \
   -highlightt 0 \
   -highlightb $udeEditor::($OBJ,indicator_for_edit_param)
   set udeEditor::($OBJ,v_label) $udeEditor::uiVector::($ui_obj,ui_label)
   set udeEditor::($OBJ,v_vname) $udeEditor::uiVector::($ui_obj,name)
   if {$udeEditor::uiVector::($ui_obj,toggle_v) == 1} {
    set udeEditor::($OBJ,v_toggle) "On"
    } elseif {$udeEditor::uiVector::($ui_obj,toggle_v) == 0} {
    set udeEditor::($OBJ,v_toggle) "Off"
    } else {
    set udeEditor::($OBJ,v_toggle) "None"
   }
  }
  set mid_frame [frame $w.mf -bd 1 -relief sunken]
  set sub1 [frame $mid_frame.1]
  set sub1_f [UI_PB_com_AddSeparator $mid_frame.1f]
  set sub2 [frame $mid_frame.2]
  set sub2_f [UI_PB_com_AddSeparator $mid_frame.2f]
  set sub4 [frame $mid_frame.4]
  set pl [label $sub1.l -text $gPB(ude,editor,paramdlg,PL,Label) -font $gPB(bold_font)]
  set pe [entry $sub1.e -width 28 -textvariable udeEditor::($OBJ,v_label)]
  set vn [label $sub2.l -text $gPB(ude,editor,paramdlg,VN,Label) -font $gPB(bold_font)]
  set ve [entry $sub2.e -width 10 -textvariable udeEditor::($OBJ,v_vname)]
  bind $ve <KeyPress> "UI_PB_com_DisableSpecialChars %W %K"
  bind $ve <KeyRelease> {%W config -state normal}
  set tg [label $sub4.l -text $gPB(ude,editor,paramdlg,TG) -font $gPB(bold_font)]
  set te [tk_optionMenu $sub4.m udeEditor::($OBJ,v_toggle) None On Off]
  $sub4.m config -width 4 -direction  below
  set gPB(c_help,$pe) "ude,editor,paramdlg,PL"
  set gPB(c_help,$ve) "ude,editor,paramdlg,VN"
  set gPB(c_help,$sub4.m) "ude,editor,paramdlg,TG,B"
  pack $pl -side top -anchor w
  pack $pe -padx 5 -fill x -pady 10
  pack $vn -side top  -anchor w
  pack $ve  -padx 5 -fill x -pady 10
  pack $tg -side left -anchor w -pady 14
  pack $sub4.m -side right -padx 3
  pack $sub1 $sub1_f $sub2 $sub2_f $sub4 -pady 2 -padx 5 -fill x
  set bot_frame [frame $w.bf]
  set name_list {"gPB(nav_button,ok,Label)" "gPB(nav_button,cancel,Label)"}
  set cb_arr(gPB(nav_button,ok,Label)) ""
  set cb_arr(gPB(nav_button,cancel,Label)) ""
  UI_PB_com_CreateButtonBox $bot_frame name_list cb_arr
  if ![string compare $action NEW] {
   ${bot_frame}.box.act_0 config  \
   -command "UI_PB_ude_ParamDlgOK $w Vector"
   ${bot_frame}.box.act_1 config  \
   -command "UI_PB_ude_ParamDlgCNL $w"
   } else {
   ${bot_frame}.box.act_0 config  \
   -command "UI_PB_ude_ParamDlgOK_ForEdit $w Vector $isPtc"
   ${bot_frame}.box.act_1 config  \
   -command "UI_PB_ude_ParamDlgCNL $w"
  }
  pack $bot_frame -side bottom -fill x -pady 2 -padx 2
  pack $mid_frame -fill both -expand yes -padx 2 -pady 5 -side top
  if {$isPtc == 1} {
   if ![string compare $::tix_version 8.4] {
    $ve config -state disabled
    } else {
    $ve config -state disabled -bg lightblue
   }
  }
  if ![string compare $action "NEW"] {
   UI_PB_ude_CreatePreviewItem \
   [winfo parent $udeEditor::($OBJ,insert_position_w)] Vector
   } else {
   if {$udeEditor::($OBJ,TYPE) == "UDC" && \
    $isPtc == 1} {
    if ![string compare $::tix_version 8.4] {
     $pe config -state disabled
     $sub4.m config -state disabled
     } else {
     $pe config -state disabled -bg lightblue
     $sub4.m config -state disabled
    }
    set udeEditor::($OBJ,to_restore_value) 0
    } else {
    UI_PB_ude_CreatePreviewBehavior_ForEdit Vector
   }
  }
 }

#=======================================================================
proc UI_PB_ude_TempKeyRlsBinding_ForEntry {w ui_obj rep_var} {
  set class_type [classof $ui_obj]
  if {$class_type != "::udeEditor::uiText"} {
   $w config -state normal
   set ::gPB(prev_key) ""
  }
  set value [set [set class_type]::($ui_obj,value)]
  set $rep_var $value
 }

#=======================================================================
proc UI_PB_ude_TempCmdBinding_ForCheckButton {ui_obj rep_var} {
  set class_type [classof $ui_obj]
  set value [set [set class_type]::($ui_obj,toggle_v)]
  if {$class_type != "::udeEditor::uiBoolean"} {
   if {$value == "1"} {
    set $rep_var On
    } else {
    set $rep_var Off
   }
   } else {
   if {$value == "1"} {
    set $rep_var TRUE
    } else {
    set $rep_var FALSE
   }
  }
 }

#=======================================================================
proc UI_PB_ude_CreatePreviewBehavior_ForEdit { type } {
  set OBJ $udeEditor::(obj)
  set ui_obj $udeEditor::($OBJ,cur_edit_obj)
  set udeEditor::($OBJ,test_flag) 0
  switch -exact $type {
   Integer {
    udeEditor::uiInteger::set_restore_value $ui_obj
    UI_PB_ude_TraceVariable udeEditor::($OBJ,i_dvalue) w \
    "UI_PB_ude_PreviewForEdit_Dvalue \
    udeEditor::uiInteger::($ui_obj,value)"
    UI_PB_ude_TraceVariable udeEditor::($OBJ,i_vname) w \
    "UI_PB_ude_PreviewForEdit_Vname \
    udeEditor::($OBJ,i_label) \
    udeEditor::uiInteger::($ui_obj,ui_label)"
    UI_PB_ude_TraceVariable udeEditor::($OBJ,i_label) w \
    "UI_PB_ude_PreviewForEdit_Label \
    udeEditor::($OBJ,i_vname) \
    udeEditor::uiInteger::($ui_obj,ui_label)"
    set path_name $udeEditor::uiInteger::($ui_obj,pathname)
    set udeEditor::($OBJ,test_flag) 1
    set tfrm ${path_name}.top
    set bfrm ${path_name}.btm
    set cw $tfrm.c
    set lw $bfrm.l
    set ew $bfrm.e
    UI_PB_ude_TraceVariable udeEditor::($OBJ,i_toggle) w \
    "UI_PB_ude_PreviewForEdit_Toggle $cw $lw $ew \
    udeEditor::uiInteger::($ui_obj,toggle_v)"
    set toggle $udeEditor::($OBJ,i_toggle)
    if {$toggle == "Off"} {
     $cw config -state normal
     } elseif {$toggle == "On"} {
     $cw config -state normal
     $ew config -state normal
     } else {
     $ew config -state normal
    }
    $cw config -command "UI_PB_ude_TempCmdBinding_ForCheckButton \
    $ui_obj udeEditor::($OBJ,i_toggle)"
    bind $ew <KeyPress> "UI_PB_com_ValidateDataOfEntry %W %K i 1"
    bind $ew <KeyRelease> "UI_PB_ude_TempKeyRlsBinding_ForEntry %W \
    $ui_obj udeEditor::($OBJ,i_dvalue)"
   }
   Real    {
    udeEditor::uiReal::set_restore_value $ui_obj
    UI_PB_ude_TraceVariable udeEditor::($OBJ,r_dvalue) w \
    "UI_PB_ude_PreviewForEdit_Dvalue \
    udeEditor::uiReal::($ui_obj,value)"
    UI_PB_ude_TraceVariable udeEditor::($OBJ,r_vname) w \
    "UI_PB_ude_PreviewForEdit_Vname \
    udeEditor::($OBJ,r_label) \
    udeEditor::uiReal::($ui_obj,ui_label)"
    UI_PB_ude_TraceVariable udeEditor::($OBJ,r_label) w \
    "UI_PB_ude_PreviewForEdit_Label \
    udeEditor::($OBJ,r_vname) \
    udeEditor::uiReal::($ui_obj,ui_label)"
    set path_name $udeEditor::uiReal::($ui_obj,pathname)
    set udeEditor::($OBJ,test_flag) 1
    set tfrm ${path_name}.top
    set bfrm ${path_name}.btm
    set cw ${tfrm}.c
    set lw ${bfrm}.l
    set ew ${bfrm}.e
    UI_PB_ude_TraceVariable udeEditor::($OBJ,r_toggle) w \
    "UI_PB_ude_PreviewForEdit_Toggle $cw $lw $ew \
    udeEditor::uiReal::($ui_obj,toggle_v)"
    set toggle $udeEditor::($OBJ,r_toggle)
    if {$toggle == "Off"} {
     $cw config -state normal
     } elseif {$toggle == "On"} {
     $cw config -state normal
     $ew config -state normal
     } else {
     $ew config -state normal
    }
    $cw config -command "UI_PB_ude_TempCmdBinding_ForCheckButton \
    $ui_obj udeEditor::($OBJ,r_toggle)"
    bind $ew <KeyPress> "UI_PB_com_ValidateDataOfEntry %W %K i 1"
    bind $ew <KeyRelease> "UI_PB_ude_TempKeyRlsBinding_ForEntry %W \
    $ui_obj udeEditor::($OBJ,r_dvalue)"
   }
   Text    {
    udeEditor::uiText::set_restore_value $ui_obj
    UI_PB_ude_TraceVariable udeEditor::($OBJ,t_dvalue) w \
    "UI_PB_ude_PreviewForEdit_Dvalue \
    udeEditor::uiText::($ui_obj,value)"
    UI_PB_ude_TraceVariable udeEditor::($OBJ,t_vname) w \
    "UI_PB_ude_PreviewForEdit_Vname \
    udeEditor::($OBJ,t_label) \
    udeEditor::uiText::($ui_obj,ui_label)"
    UI_PB_ude_TraceVariable udeEditor::($OBJ,t_label) w \
    "UI_PB_ude_PreviewForEdit_Label \
    udeEditor::($OBJ,t_vname) \
    udeEditor::uiText::($ui_obj,ui_label)"
    set path_name $udeEditor::uiText::($ui_obj,pathname)
    set udeEditor::($OBJ,test_flag) 1
    set tfrm ${path_name}.top
    set bfrm ${path_name}.btm
    set cw ${tfrm}.c
    set lw ${bfrm}.l
    set ew ${bfrm}.e
    UI_PB_ude_TraceVariable udeEditor::($OBJ,t_toggle) w \
    "UI_PB_ude_PreviewForEdit_Toggle $cw $lw $ew \
    udeEditor::uiText::($ui_obj,toggle_v)"
    set toggle $udeEditor::($OBJ,t_toggle)
    if {$toggle == "Off"} {
     $cw config -state normal
     } elseif {$toggle == "On"} {
     $cw config -state normal
     $ew config -state normal
     } else {
     $ew config -state normal
    }
    $cw config -command "UI_PB_ude_TempCmdBinding_ForCheckButton \
    $ui_obj udeEditor::($OBJ,t_toggle)"
    bind $ew <KeyRelease> "UI_PB_ude_TempKeyRlsBinding_ForEntry %W \
    $ui_obj udeEditor::($OBJ,t_dvalue)"
   }
   Boolean {
    udeEditor::uiBoolean::set_restore_value $ui_obj
    UI_PB_ude_TraceVariable udeEditor::($OBJ,b_dvalue) w \
    "UI_PB_ude_PreviewForEdit_Dvalue_ForBoolean \
    udeEditor::uiBoolean::($ui_obj,toggle_v)"
    UI_PB_ude_TraceVariable udeEditor::($OBJ,b_vname) w \
    "UI_PB_ude_PreviewForEdit_Vname \
    udeEditor::($OBJ,b_label) \
    udeEditor::uiBoolean::($ui_obj,ui_label)"
    UI_PB_ude_TraceVariable udeEditor::($OBJ,b_label) w \
    "UI_PB_ude_PreviewForEdit_Label \
    udeEditor::($OBJ,b_vname) \
    udeEditor::uiBoolean::($ui_obj,ui_label)"
    set path_name $udeEditor::uiBoolean::($ui_obj,pathname)
    set cw ${path_name}.c
    $cw config -state normal
    $cw config -command "UI_PB_ude_TempCmdBinding_ForCheckButton \
    $ui_obj udeEditor::($OBJ,b_dvalue)"
   }
   Option  {
    udeEditor::uiOption::set_restore_value $ui_obj
    UI_PB_ude_TraceVariable udeEditor::($OBJ,o_dvalue) w \
    "UI_PB_ude_PreviewForEdit_Dvalue \
    udeEditor::uiOption::($ui_obj,cur_opt)"
    UI_PB_ude_TraceVariable udeEditor::($OBJ,o_vname) w \
    "UI_PB_ude_PreviewForEdit_Vname \
    udeEditor::($OBJ,o_label) \
    udeEditor::uiOption::($ui_obj,ui_label)"
    UI_PB_ude_TraceVariable udeEditor::($OBJ,o_label) w \
    "UI_PB_ude_PreviewForEdit_Label \
    udeEditor::($OBJ,o_vname) \
    udeEditor::uiOption::($ui_obj,ui_label)"
    set path_name $udeEditor::uiOption::($ui_obj,pathname)
    set cw ${path_name}.c
    set lw ${path_name}.l
    if 0 {
     set ow ${path_name}.o
     $ow config -state disabled
     UI_PB_ude_TraceVariable udeEditor::($OBJ,o_toggle) w \
     "UI_PB_ude_PreviewForEdit_Toggle $cw $lw $ow\
     udeEditor::uiOption::($ui_obj,toggle_v)"
     set toggle $udeEditor::($OBJ,o_toggle)
     if {$toggle == "Off"} {
      $cw config -state normal
      } elseif {$toggle == "On"} {
      $cw config -state normal
      $ow config -disabledforeground $udeEditor::($OBJ,item_fg)
      } else {
      $ow config -disabledforeground $udeEditor::($OBJ,item_fg)
     }
     $cw config -command "UI_PB_ude_TempCmdBinding_ForCheckButton \
     $ui_obj udeEditor::($OBJ,o_toggle)"
    }
   }
   Point   {
    udeEditor::uiPoint::set_restore_value $ui_obj
    UI_PB_ude_TraceVariable udeEditor::($OBJ,p_vname) w \
    "UI_PB_ude_PreviewForEdit_Vname \
    udeEditor::($OBJ,p_label) \
    udeEditor::uiPoint::($ui_obj,ui_label)"
    UI_PB_ude_TraceVariable udeEditor::($OBJ,p_label) w \
    "UI_PB_ude_PreviewForEdit_Label \
    udeEditor::($OBJ,p_vname) \
    udeEditor::uiPoint::($ui_obj,ui_label)"
    set path_name $udeEditor::uiPoint::($ui_obj,pathname)
    set udeEditor::($OBJ,test_flag) 1
    set tfrm ${path_name}.top
    set bfrm ${path_name}.btm
    set cw ${tfrm}.c
    set lw ${bfrm}.l
    set dw ${bfrm}.bf.db
    set sw ${bfrm}.bf.sb
    UI_PB_ude_TraceVariable udeEditor::($OBJ,p_toggle) w \
    "UI_PB_ude_PreviewForEdit_Toggle $cw $lw [list [list $dw $sw]] \
    udeEditor::uiPoint::($ui_obj,toggle_v)"
    if ![string compare $::tix_version 8.4] {
     $dw config -state normal
     $sw config -state normal
    }
    set toggle $udeEditor::($OBJ,p_toggle)
    if {$toggle == "Off"} {
     $cw config -state normal
     } elseif {$toggle == "On"} {
     $cw config -state normal
     $dw config -fg $udeEditor::($OBJ,item_fg)
     $sw config -fg $udeEditor::($OBJ,item_fg)
     } else {
     $dw config -fg $udeEditor::($OBJ,item_fg)
     $sw config -fg $udeEditor::($OBJ,item_fg)
    }
    $cw config -command "UI_PB_ude_TempCmdBinding_ForCheckButton \
    $ui_obj udeEditor::($OBJ,p_toggle)"
   }
   Bitmap  {
    udeEditor::uiBitmap::set_restore_value $ui_obj
    UI_PB_ude_TraceVariable udeEditor::($OBJ,l_dvalue) w \
    "UI_PB_ude_PreviewForEdit_Dvalue \
    udeEditor::uiBitmap::($ui_obj,value)"
    UI_PB_ude_TraceVariable udeEditor::($OBJ,l_vname) w \
    "UI_PB_ude_PreviewForEdit_Vname \
    udeEditor::($OBJ,l_label) \
    udeEditor::uiBitmap::($ui_obj,ui_label)"
   }
   Group   {
    udeEditor::uiGroup::set_restore_value $ui_obj
    set path_name $udeEditor::uiGroup::($ui_obj,pathname)
    ${path_name}.btn configure -state normal
    UI_PB_ude_TraceVariable udeEditor::($OBJ,g_dvalue) w \
    "UI_PB_ude_PreviewForEdit_Dvalue \
    udeEditor::uiGroup::($ui_obj,cur_opt)"
    UI_PB_ude_TraceVariable udeEditor::($OBJ,g_vname) w \
    "UI_PB_ude_PreviewForEdit_Vname \
    udeEditor::($OBJ,g_label) \
    udeEditor::uiGroup::($ui_obj,ui_label)"
    UI_PB_ude_TraceVariable udeEditor::($OBJ,g_label) w \
    "UI_PB_ude_PreviewForEdit_Label \
    udeEditor::($OBJ,g_vname) \
    udeEditor::uiGroup::($ui_obj,ui_label)"
   }
   Vector  {
    udeEditor::uiVector::set_restore_value $ui_obj
    UI_PB_ude_TraceVariable udeEditor::($OBJ,v_vname) w \
    "UI_PB_ude_PreviewForEdit_Vname \
    udeEditor::($OBJ,v_label) \
    udeEditor::uiVector::($ui_obj,ui_label)"
    UI_PB_ude_TraceVariable udeEditor::($OBJ,v_label) w \
    "UI_PB_ude_PreviewForEdit_Label \
    udeEditor::($OBJ,v_vname) \
    udeEditor::uiVector::($ui_obj,ui_label)"
    set path_name $udeEditor::uiVector::($ui_obj,pathname)
    set udeEditor::($OBJ,test_flag) 1
    set tfrm ${path_name}.top
    set bfrm ${path_name}.btm
    set cw ${tfrm}.c
    set lw ${bfrm}.l
    set dw ${bfrm}.bf.db
    set sw ${bfrm}.bf.sb
    UI_PB_ude_TraceVariable udeEditor::($OBJ,v_toggle) w \
    "UI_PB_ude_PreviewForEdit_Toggle $cw $lw [list [list $dw $sw]] \
    udeEditor::uiVector::($ui_obj,toggle_v)"
    if ![string compare $::tix_version 8.4] {
     $dw config -state normal
     $sw config -state normal
    }
    set toggle $udeEditor::($OBJ,v_toggle)
    if {$toggle == "Off"} {
     $cw config -state normal
     } elseif {$toggle == "On"} {
     $cw config -state normal
     $dw config -fg $udeEditor::($OBJ,item_fg)
     $sw config -fg $udeEditor::($OBJ,item_fg)
     } else {
     $dw config -fg $udeEditor::($OBJ,item_fg)
     $sw config -fg $udeEditor::($OBJ,item_fg)
    }
    $cw config -command "UI_PB_ude_TempCmdBinding_ForCheckButton \
    $ui_obj udeEditor::($OBJ,v_toggle)"
   }
  }
 }

#=======================================================================
proc UI_PB_ude_CreatePreviewItem { pw type } {
  global gPB
  set OBJ $udeEditor::(obj)
  set num $udeEditor::($OBJ,numOfItems)
  if {$num != "0"} {
   set pre_f ${pw}.pbf
   } else {
   set pre_f $udeEditor::($OBJ,midframe)
  }
  set udeEditor::($OBJ,cur_pre_botframe) $pre_f
  set top_f [frame $pre_f.top -bd 2 -relief sunken -highlightt 0 \
  -height 20 -bg $udeEditor::($OBJ,sunken_bg)]
  set bot_f [frame $pre_f.bot -height 4 -width 200 -highlightt 2 \
  -highlightb $udeEditor::($OBJ,dialog_bg)]
  if 0 {
   $bot_f config -highlightb $udeEditor::($OBJ,bar_highlight)
  }
  pack $bot_f -side bottom -fill x -anchor s
  pack $top_f -expand yes -fill x
  set udeEditor::($OBJ,test_flag) 0
  switch -exact $type {
   Integer {
    set tfrm [frame $top_f.top -bg $udeEditor::($OBJ,sunken_bg)]
    set bfrm [frame $top_f.btm -bg $udeEditor::($OBJ,sunken_bg)]
    set is [label $tfrm.s -textvariable udeEditor::($OBJ,i_label) \
    -fg $udeEditor::($OBJ,item_fg) \
    -bg $udeEditor::($OBJ,sunken_bg)]
    set is2 [label $tfrm.s2 -text " Status" \
    -fg $udeEditor::($OBJ,item_fg) \
    -bg $udeEditor::($OBJ,sunken_bg)]
    set ic [checkbutton $tfrm.c -bd $udeEditor::($OBJ,bd_value) -highlightt 0 \
    -variable udeEditor::($OBJ,i_toggle) \
    -bg $udeEditor::($OBJ,sunken_bg) \
    -activebackground $udeEditor::($OBJ,sunken_bg) \
    -offvalue "Off" -onvalue "On"]
    set il [label $bfrm.l -textvariable udeEditor::($OBJ,i_label) \
    -fg $udeEditor::($OBJ,item_fg) \
    -bg $udeEditor::($OBJ,sunken_bg)]
    set ie [entry $bfrm.e -textvariable udeEditor::($OBJ,i_dvalue) \
    -width 6]
    set udeEditor::($OBJ,test_flag) 1
    UI_PB_ude_TraceVariable udeEditor::($OBJ,i_label) w \
    "UI_PB_ude_ChangeTextForPreview $is \
    udeEditor::($OBJ,i_vname)"
    UI_PB_ude_TraceVariable udeEditor::($OBJ,i_toggle) w \
    "UI_PB_ude_ChangeStateForPreview $ic $il $ie"
    UI_PB_ude_TraceVariable udeEditor::($OBJ,i_label) w \
    "UI_PB_ude_ChangeTextForPreview $il \
    udeEditor::($OBJ,i_vname)"
    bind $ie <KeyPress> "UI_PB_com_ValidateDataOfEntry %W %K i 1"
    bind $ie <KeyRelease> {%W config -state normal ;set ::gPB(prev_key) ""}
    pack $tfrm -side top -anchor w
    pack $bfrm -side top -anchor w -fill x  -expand 1
    pack $ic $is $is2 -side left
    pack $il -side left -padx 0
    pack $ie -side right -padx 5 -pady 5 -fill x  -expand 1
   }
   Real    {
    set tfrm [frame $top_f.top -bg $udeEditor::($OBJ,sunken_bg)]
    set bfrm [frame $top_f.btm -bg $udeEditor::($OBJ,sunken_bg)]
    set rs [label $tfrm.s -textvariable udeEditor::($OBJ,r_label) \
    -fg $udeEditor::($OBJ,item_fg) \
    -bg $udeEditor::($OBJ,sunken_bg)]
    set rs2 [label $tfrm.s2 -text " Status" \
    -fg $udeEditor::($OBJ,item_fg) \
    -bg $udeEditor::($OBJ,sunken_bg)]
    set rc [checkbutton $tfrm.c -bd $udeEditor::($OBJ,bd_value) -highlightt 0 \
    -variable udeEditor::($OBJ,r_toggle) \
    -bg $udeEditor::($OBJ,sunken_bg) \
    -activebackground $udeEditor::($OBJ,sunken_bg) \
    -offvalue "Off" -onvalue "On"]
    set rl [label $bfrm.l -textvariable udeEditor::($OBJ,r_label) \
    -fg $udeEditor::($OBJ,item_fg) \
    -bg $udeEditor::($OBJ,sunken_bg)]
    set re [entry $bfrm.e -textvariable udeEditor::($OBJ,r_dvalue) \
    -width 6]
    set udeEditor::($OBJ,test_flag) 1
    UI_PB_ude_TraceVariable udeEditor::($OBJ,r_label) w \
    "UI_PB_ude_ChangeTextForPreview $rs \
    udeEditor::($OBJ,r_vname)"
    UI_PB_ude_TraceVariable udeEditor::($OBJ,r_toggle) w \
    "UI_PB_ude_ChangeStateForPreview $rc $rl $re"
    UI_PB_ude_TraceVariable udeEditor::($OBJ,r_label) w \
    "UI_PB_ude_ChangeTextForPreview $rl \
    udeEditor::($OBJ,r_vname)"
    bind $re <KeyPress> "UI_PB_com_ValidateDataOfEntry %W %K i 1"
    bind $re <KeyRelease> {%W config -state normal ;set ::gPB(prev_key) ""}
    pack $tfrm -side top -anchor w
    pack $bfrm -side top -anchor w -fill x -expand 1
    pack $rc $rs $rs2 -side left
    pack $rl -side left -padx 0
    pack $re -side right -padx 5 -pady 5 -fill x -expand 1
   }
   Text    {
    set tfrm [frame $top_f.top -bg $udeEditor::($OBJ,sunken_bg)]
    set bfrm [frame $top_f.btm -bg $udeEditor::($OBJ,sunken_bg)]
    set ts [label $tfrm.s -textvariable udeEditor::($OBJ,t_label) \
    -fg $udeEditor::($OBJ,item_fg) \
    -bg $udeEditor::($OBJ,sunken_bg)]
    set ts2 [label $tfrm.s2 -text " Status" \
    -fg $udeEditor::($OBJ,item_fg) \
    -bg $udeEditor::($OBJ,sunken_bg)]
    set tc [checkbutton $tfrm.c -bd $udeEditor::($OBJ,bd_value) -highlightt 0 \
    -variable udeEditor::($OBJ,t_toggle) \
    -bg $udeEditor::($OBJ,sunken_bg) \
    -activebackground $udeEditor::($OBJ,sunken_bg) \
    -offvalue "Off" -onvalue "On"]
    set tl [label $bfrm.l -textvariable udeEditor::($OBJ,t_label) \
    -fg $udeEditor::($OBJ,item_fg) \
    -bg $udeEditor::($OBJ,sunken_bg)]
    set te [entry $bfrm.e -textvariable udeEditor::($OBJ,t_dvalue) \
    -width 6]
    set udeEditor::($OBJ,test_flag) 1
    UI_PB_ude_TraceVariable udeEditor::($OBJ,t_label) w \
    "UI_PB_ude_ChangeTextForPreview $ts \
    udeEditor::($OBJ,t_vname)"
    UI_PB_ude_TraceVariable udeEditor::($OBJ,t_toggle) w \
    "UI_PB_ude_ChangeStateForPreview $tc $tl $te"
    UI_PB_ude_TraceVariable udeEditor::($OBJ,t_label) w \
    "UI_PB_ude_ChangeTextForPreview $tl \
    udeEditor::($OBJ,t_vname)"
    bind $te <KeyPress> "UI_PB_com_ValidateDataOfEntry %W %K i 1"
    bind $te <KeyRelease> {%W config -state normal ;set ::gPB(prev_key) ""}
    pack $tfrm -side top -anchor w
    pack $bfrm -side top -anchor w -fill x -expand 1
    pack $tc $ts $ts2 -side left
    pack $tl -side top -anchor w -padx 0
    pack $te -side top -anchor w -padx 5 -pady 5 -fill x -expand 1
   }
   Boolean {
    set bc [checkbutton $top_f.c -bd $udeEditor::($OBJ,bd_value) -highlightt 0 -height 2 \
    -variable udeEditor::($OBJ,b_dvalue) \
    -bg $udeEditor::($OBJ,sunken_bg) \
    -activebackground $udeEditor::($OBJ,sunken_bg) \
    -offvalue "FALSE" -onvalue "TRUE"]
    set bl [label $top_f.l -textvariable udeEditor::($OBJ,b_label) \
    -height 2 -fg $udeEditor::($OBJ,item_fg) \
    -bg $udeEditor::($OBJ,sunken_bg)]
    UI_PB_ude_TraceVariable udeEditor::($OBJ,b_label) w \
    "UI_PB_ude_ChangeTextForPreview $bl \
    udeEditor::($OBJ,b_vname)"
    pack $bc -side left -padx 1
    if ![string compare $::tix_version 8.4] {
     pack $bl -side left -padx 0
     } else {
     pack $bl -side left -padx 0 -pady 3
    }
   }
   Point   {
    set tfrm [frame $top_f.top -bg $udeEditor::($OBJ,sunken_bg)]
    set bfrm [frame $top_f.btm -bg $udeEditor::($OBJ,sunken_bg)]
    set ps [label $tfrm.s -textvariable udeEditor::($OBJ,p_label) \
    -fg $udeEditor::($OBJ,item_fg) \
    -bg $udeEditor::($OBJ,sunken_bg)]
    set ps2 [label $tfrm.s2 -text " Status" \
    -fg $udeEditor::($OBJ,item_fg) \
    -bg $udeEditor::($OBJ,sunken_bg)]
    set bf [frame $bfrm.bf -bg $udeEditor::($OBJ,sunken_bg)]
    set pc [checkbutton $tfrm.c -bd $udeEditor::($OBJ,bd_value) -highlightt 0 \
    -variable udeEditor::($OBJ,p_toggle) \
    -bg $udeEditor::($OBJ,sunken_bg) \
    -activebackground $udeEditor::($OBJ,sunken_bg) \
    -offvalue "Off" -onvalue "On"]
    set pl [label $bfrm.l -textvariable udeEditor::($OBJ,p_label) \
    -fg $udeEditor::($OBJ,item_fg) \
    -bg $udeEditor::($OBJ,sunken_bg)]
    set sb [label $bf.sb -text $gPB(ude,editor,pnt,sel,Label) -takefocus 0 \
    -width 10 -relief raised -height 1 \
    -font $gPB(bold_font) \
    -bd 2 -anchor center \
    -fg $udeEditor::($OBJ,item_fg) \
    -bg $udeEditor::($OBJ,sunken_bg)]
    set db [label $bf.db -text $gPB(ude,editor,pnt,dsp,Label) -takefocus 0 \
    -width 10 -relief raised -height 1 \
    -font $gPB(bold_font) \
    -bd 2 -anchor center \
    -fg $udeEditor::($OBJ,item_fg) \
    -bg $udeEditor::($OBJ,sunken_bg)]
    set udeEditor::($OBJ,test_flag) 1
    UI_PB_ude_TraceVariable udeEditor::($OBJ,p_label) w \
    "UI_PB_ude_ChangeTextForPreview $ps \
    udeEditor::($OBJ,p_vname)"
    UI_PB_ude_TraceVariable udeEditor::($OBJ,p_toggle) w \
    "UI_PB_ude_ChangeStateForPreview $pc $pl \
    [list [list $sb $db]]"
    UI_PB_ude_TraceVariable udeEditor::($OBJ,p_label) w \
    "UI_PB_ude_ChangeTextForPreview $pl \
    udeEditor::($OBJ,p_vname)"
    pack $tfrm -side top -anchor w
    pack $bfrm -side top -anchor w -fill x  -expand 1
    pack $pc $ps $ps2 -side left
    pack $pl -side top -anchor w -padx 0
    pack $bf -side top -anchor w -fill x -pady 4
    pack $sb -side left -padx 5
    pack $db -side right -padx 5
   }
   Option  {
    if 0 {
     set oc [checkbutton $top_f.c -bd $udeEditor::($OBJ,bd_value) -highlightt 0 -height 2 \
     -variable udeEditor::($OBJ,o_toggle) \
     -bg $udeEditor::($OBJ,sunken_bg) \
     -activebackground $udeEditor::($OBJ,sunken_bg) \
     -offvalue "Off" -onvalue "On"]
    }
    set ol [label $top_f.l -textvariable udeEditor::($OBJ,o_label) \
    -height 2 -fg $udeEditor::($OBJ,item_fg) \
    -bg $udeEditor::($OBJ,sunken_bg)]
    set om [tk_optionMenu $top_f.o udeEditor::($OBJ,o_dvalue) ""]
    set oo ${top_f}.o
    $oo config -direction below -anchor w -highlightt 0 \
    -bg $udeEditor::($OBJ,sunken_bg) \
    -state disabled \
    -disabledforeground $udeEditor::($OBJ,item_fg)
    if 0 {
     UI_PB_ude_TraceVariable udeEditor::($OBJ,o_toggle) w \
     "UI_PB_ude_ChangeStateForPreview $oc $ol $oo"
    }
    UI_PB_ude_TraceVariable udeEditor::($OBJ,o_label) w \
    "UI_PB_ude_ChangeTextForPreview $ol \
    udeEditor::($OBJ,o_vname)"
    if ![string compare $::tix_version 8.4] {
     pack $ol -side left -padx 0
     } else {
     pack $ol -side left -padx 0 -pady 3
    }
    pack $oo -side right -padx 3 -pady 5
   }
   Bitmap  {
    set bmp_img [tix getimage pb_image]
    set bmp_btn [button $top_f.bmp -image $bmp_img -relief flat]
    pack $bmp_btn -anchor c -pady 2
   }
   Group   {
    set opt_text "start_open"
    UI_PB_ude_DrawGroupWidgets $top_f $opt_text
    UI_PB_ude_TraceVariable udeEditor::($OBJ,g_label) w \
    "UI_PB_ude_ChangeTextForPreview $top_f.lbl \
    udeEditor::($OBJ,g_vname)"
    set rd1 $gPB(ude,group,radio1)
    set rd2 $gPB(ude,group,radio2)
    $rd1 configure -command "UI_PB_ude_ClickGroupIcon $top_f start_open"
    $rd2 configure -command "UI_PB_ude_ClickGroupIcon $top_f start_closed"
    $top_f.lbl configure -fg $udeEditor::($OBJ,item_fg) \
    -bg $udeEditor::($OBJ,sunken_bg)
   }
   Vector  {
    set tfrm [frame $top_f.top -bg $udeEditor::($OBJ,sunken_bg)]
    set bfrm [frame $top_f.btm -bg $udeEditor::($OBJ,sunken_bg)]
    set vs [label $tfrm.s -textvariable udeEditor::($OBJ,v_label) \
    -fg $udeEditor::($OBJ,item_fg) \
    -bg $udeEditor::($OBJ,sunken_bg)]
    set vs2 [label $tfrm.s2 -text " Status" \
    -fg $udeEditor::($OBJ,item_fg) \
    -bg $udeEditor::($OBJ,sunken_bg)]
    set bf [frame $bfrm.bf -bg $udeEditor::($OBJ,sunken_bg)]
    set vc [checkbutton $tfrm.c -bd $udeEditor::($OBJ,bd_value) -highlightt 0 \
    -variable udeEditor::($OBJ,v_toggle) \
    -bg $udeEditor::($OBJ,sunken_bg) \
    -activebackground $udeEditor::($OBJ,sunken_bg) \
    -offvalue "Off" -onvalue "On"]
    set vl [label $bfrm.l -textvariable udeEditor::($OBJ,v_label) \
    -fg $udeEditor::($OBJ,item_fg) \
    -bg $udeEditor::($OBJ,sunken_bg)]
    set sb [label $bf.sb -text $gPB(ude,editor,pnt,sel,Label) -takefocus 0 \
    -width 10 -relief raised -height 1 \
    -font $gPB(bold_font) \
    -bd 2 -anchor center \
    -fg $udeEditor::($OBJ,item_fg) \
    -bg $udeEditor::($OBJ,sunken_bg)]
    set db [label $bf.db -text $gPB(ude,editor,pnt,dsp,Label) -takefocus 0 \
    -width 10 -relief raised -height 1 \
    -font $gPB(bold_font) \
    -bd 2 -anchor center \
    -fg $udeEditor::($OBJ,item_fg) \
    -bg $udeEditor::($OBJ,sunken_bg)]
    set udeEditor::($OBJ,test_flag) 1
    UI_PB_ude_TraceVariable udeEditor::($OBJ,v_label) w \
    "UI_PB_ude_ChangeTextForPreview $vs \
    udeEditor::($OBJ,v_vname)"
    UI_PB_ude_TraceVariable udeEditor::($OBJ,v_toggle) w \
    "UI_PB_ude_ChangeStateForPreview $vc $vl \
    [list [list $sb $db]]"
    UI_PB_ude_TraceVariable udeEditor::($OBJ,v_label) w \
    "UI_PB_ude_ChangeTextForPreview $vl \
    udeEditor::($OBJ,v_vname)"
    pack $tfrm -side top -anchor w
    pack $bfrm -side top -anchor w -fill x  -expand 1
    pack $vc $vs $vs2 -side left
    pack $vl -side top -anchor w -padx 0
    pack $bf -side top -anchor w -fill x -pady 4
    pack $sb -side left -padx 5
    pack $db -side right -padx 5
   }
  }
 }

#=======================================================================
proc UI_PB_ude_TraceExecution {exe_cmd opt cmd_str} {
  set OBJ $udeEditor::(obj)
  trace add execution $exe_cmd $opt $cmd_str
  set trace_info [list "$exe_cmd" "$opt" "$cmd_str"]
  lappend udeEditor::($OBJ,trace_exe_cmd_list) $trace_info
 }

#=======================================================================
proc UI_PB_ude_TraceVariable {var opt cmd_str} {
  set OBJ $udeEditor::(obj)
  trace variable $var $opt $cmd_str
  set trace_info [list "$var" "$opt" "$cmd_str"]
  lappend udeEditor::($OBJ,trace_var_cmd_list) $trace_info
 }

#=======================================================================
proc UI_PB_ude_CancelTrace {} {
  set OBJ $udeEditor::(obj)
  set trace_info_list $udeEditor::($OBJ,trace_var_cmd_list)
  foreach one $trace_info_list {
   trace vdelete [lindex $one 0] [lindex $one 1] [lindex $one 2]
  }
  set udeEditor::($OBJ,trace_var_cmd_list) [list]
  if ![string compare $::tix_version 8.4] {
   set trace_info_list $udeEditor::($OBJ,trace_exe_cmd_list)
   foreach one $trace_info_list {
    trace remove execution [lindex $one 0] [lindex $one 1] [lindex $one 2]
   }
   set udeEditor::($OBJ,trace_exe_cmd_list) [list]
  }
 }

#=======================================================================
proc UI_PB_ude_PreviewForEdit_Label {name_var rep_var varName index opt} {
  set vname ${varName}\(${index}\)
  set v "\$${varName}($index)"
  set cmd  "{set} {value} $v"
  eval $cmd
  set cmd "{set} {name_value} \$${name_var}"
  eval $cmd
  if {[string trim $value] == ""} {
   set $rep_var $name_value
   } else {
   set $rep_var $value
  }
 }

#=======================================================================
proc UI_PB_ude_PreviewForEdit_Dvalue {rep_var varName index opt} {
  set vname ${varName}\(${index}\)
  set v "\$${varName}($index)"
  set cmd  "{set} {value} $v"
  eval $cmd
  set $rep_var $value
 }

#=======================================================================
proc UI_PB_ude_PreviewForEdit_Dvalue_ForBoolean {rep_var varName index opt} {
  set vname ${varName}\(${index}\)
  set v "\$${varName}($index)"
  set cmd  "{set} {value} $v"
  eval $cmd
  if {$value == "TRUE"} {
   set $rep_var 1
   } else {
   set $rep_var 0
  }
 }

#=======================================================================
proc UI_PB_ude_PreviewForEdit_Vname {label_var rep_var varName index opt} {
  set vname ${varName}\(${index}\)
  set v "\$${varName}($index)"
  set cmd  "{set} {value} $v"
  eval $cmd
  set cmd "{set} {label_value} \$${label_var}"
  eval $cmd
  if {$label_value == ""} {
   set $rep_var $value
  }
 }

#=======================================================================
proc UI_PB_ude_PreviewForEdit_Toggle {cw lw ew_list rep_var varName index opt} {
  set OBJ $udeEditor::(obj)
  set vname ${varName}\(${index}\)
  set v "\$${varName}($index)"
  set cmd  "{set} {value} $v"
  eval $cmd
  if {$value == "None"} {
   if [winfo ismapped $cw] {
    if $udeEditor::($OBJ,test_flag) \
    {
     set len [string length $cw]
     set p_w [string range $cw 0 [expr $len - 3]]
     pack forget $p_w
    } else \
    {
     pack forget $cw
    }
    set $rep_var -1
   }
   foreach ew $ew_list {
    if {[winfo class $ew] == "Label"} {
     $ew config -fg $udeEditor::($OBJ,item_fg)
     } elseif {[winfo class $ew] == "Menubutton"} {
     $ew config -state disabled -disabledforeground $udeEditor::($OBJ,item_fg)
     } else {
     $ew config -state normal
     if ![string compare $::tix_version 4.1] {
      $ew config -bg $::SystemWindow
     }
    }
   }
   } else {
   if ![winfo ismapped $cw] {
    $cw config -state normal
    if $udeEditor::($OBJ,test_flag) \
    {
     set len [string length $cw]
     set p_w [string range $cw 0 [expr $len - 7]]
     pack $p_w.top -side top -anchor w -before $p_w.btm
     pack $p_w.top.c $p_w.top.s $p_w.top.s2 -side left
    } else \
    {
     pack $cw -side left -padx 3 -before $lw
    }
   }
   if {$value == "On"} {
    set $rep_var 1
    foreach ew $ew_list {
     if {[winfo class $ew] == "Label"} {
      $ew config -fg $udeEditor::($OBJ,item_fg)
      } elseif {[winfo class $ew] == "Menubutton"} {
      $ew config -state disabled -disabledforeground $udeEditor::($OBJ,item_fg)
      } else {
      $ew config -state normal
      if ![string compare $::tix_version 4.1] {
       $ew config -bg $::SystemWindow
      }
     }
    }
    } else {
    set $rep_var 0
    foreach ew $ew_list {
     if {[winfo class $ew] == "Label"} {
      $ew config -fg $::SystemDisabledText
      } elseif {[winfo class $ew] == "Menubutton"} {
      $ew config -state disabled -disabledforeground $::SystemDisabledText
      } else {
      $ew config -state disabled
      if ![string compare $::tix_version 4.1] {
       $ew config -bg lightblue
      }
     }
    }
   }
  }
 }

#=======================================================================
proc UI_PB_ude_ChangeTextForPreview {lw replace_var varName index opt} {
  set vname ${varName}\(${index}\)
  set v "\$${varName}($index)"
  set cmd  "{set} {value} $v"
  eval $cmd
  if {[string trim $value] == ""} {
   $lw config -textvariable $replace_var
   } else {
   $lw config -textvariable "${varName}($index)"
  }
 }

#=======================================================================
proc UI_PB_ude_ChangeStateForPreview {cw lw ew_list varName index opt} {
  set OBJ $udeEditor::(obj)
  set vname ${varName}\(${index}\)
  set v "\$${varName}($index)"
  set cmd  "{set} {value} $v"
  eval $cmd
  if {$value == "None"} {
   if [winfo ismapped $cw] {
    if $udeEditor::($OBJ,test_flag) \
    {
     set len [string length $cw]
     set p_w [string range $cw 0 [expr $len - 3]]
     pack forget $p_w
    } else \
    {
     pack forget $cw
    }
   }
   foreach ew $ew_list {
    if {[winfo class $ew] == "Label"} {
     $ew config -fg $udeEditor::($OBJ,item_fg)
     } elseif {[winfo class $ew] == "Menubutton"} {
     $ew config -state disabled -disabledforeground $udeEditor::($OBJ,item_fg)
     } else {
     $ew config -state normal
     if ![string compare $::tix_version 4.1] {
      $ew config -bg $::SystemWindow
     }
    }
   }
   } else {
   if ![winfo ismapped $cw] {
    if $udeEditor::($OBJ,test_flag) \
    {
     set len [string length $cw]
     set p_w [string range $cw 0 [expr $len - 7]]
     pack $p_w.top -side top -anchor w -before $p_w.btm
    } else \
    {
     pack $cw -side left -padx 3 -before $lw
    }
   }
   if {$value == "On"} {
    foreach ew $ew_list {
     if {[winfo class $ew] == "Label"} {
      $ew config -fg $udeEditor::($OBJ,item_fg)
      } elseif {[winfo class $ew] == "Menubutton"} {
      $ew config -state disabled -disabledforeground $udeEditor::($OBJ,item_fg)
      } else {
      $ew config -state normal
      if ![string compare $::tix_version 4.1] {
       $ew config -bg $::SystemWindow
      }
     }
    }
    } else {
    foreach ew $ew_list {
     if {[winfo class $ew] == "Label"} {
      $ew config -fg $::SystemDisabledText
      } elseif {[winfo class $ew] == "Menubutton"} {
      $ew config -state disabled -disabledforeground $::SystemDisabledText
      } else {
      $ew config -state disabled
      if ![string compare $::tix_version 4.1] {
       $ew config -bg lightblue
      }
     }
    }
   }
  }
 }

#=======================================================================
proc UI_PB_ude_DeletePreviewItem {} {
  set OBJ $udeEditor::(obj)
  set pre_f $udeEditor::($OBJ,cur_pre_botframe)
  if {$pre_f != ""} {
   foreach cw [winfo child $pre_f] {
    destroy $cw
   }
   if {$pre_f != $udeEditor::($OBJ,midframe)} {
    $pre_f config -height 1
   }
   set udeEditor::($OBJ,cur_pre_botframe) ""
  }
 }

#=======================================================================
proc UI_PB_ude_AdjustItemDataOrderForInserting {pst} {
  set newItem_obj [lindex $udeEditor::($udeEditor::(obj),sub_objs) end]
  array set old_order $udeEditor::($udeEditor::(obj),pst_order)
  set cur_size [array size old_order]
  set insert_index [expr {$pst + 1}]
  set new_order($insert_index) $newItem_obj
  for {set index 0} {$index < $cur_size} {incr index} {
   if [expr {$index <= $pst}] {
    set new_order($index) $old_order($index)
    } else {
    set new_index [expr {$index + 1}]
    set new_order($new_index) $old_order($index)
   }
  }
  set udeEditor::($udeEditor::(obj),pst_order) [array get new_order]
 }

#=======================================================================
proc UI_PB_ude_AdjustItemUIOrder {} {
  array set pst_array $udeEditor::($udeEditor::(obj),pst_order)
  set cur_size [array size pst_array]
  for {set index 0} {$index < $cur_size} {incr index} {
   set class_type [classof $pst_array($index)]
   pack forget [winfo parent \
   [set [set class_type]::($pst_array($index),pathname)]]
  }
  for {set index 0} {$index < $cur_size} {incr index} {
   set class_type [classof $pst_array($index)]
   pack [winfo parent \
   [set [set class_type]::($pst_array($index),pathname)]] \
   -expand yes -fill x
  }
 }

#=======================================================================
proc UI_PB_ude_FindLocationForAddingItem {{w NULL}} {
  if ![string compare $w NULL] {
   set cur_widget [winfo parent \
   $udeEditor::($udeEditor::(obj),current_hlWidget)]
   } else {
   set cur_widget [winfo parent $w]
  }
  array set pst_array $udeEditor::($udeEditor::(obj),pst_order)
  set cur_size [array size pst_array]
  set position  "-1"
  for {set index 0} {$index < $cur_size} {incr index} {
   set class_type [classof $pst_array($index)]
   set each_widget [winfo parent \
   [set [set class_type]::($pst_array($index),pathname)]]
   if ![string compare $each_widget $cur_widget] {
    set position $index
   }
  }
  return $position
 }

#=======================================================================
proc UI_PB_ude_CreateTrashBox {w} {
  global paOption gPB
  set OBJ $udeEditor::(obj)
  set pos [expr $udeEditor::($OBJ,left_panel_width) / 2]
  $w create line $pos $pos $pos [expr $pos + 5] -tag trashline \
  -fill $udeEditor::($OBJ,bar_highlight) -width 2
  set trashIcon [UI_PB_blk_CreateIcon $w pb_trash ""]
  $w create image $pos $pos -image $trashIcon -tag ude_trash
  $trashIcon config -bg $paOption(app_butt_bg)
  $w bind ude_trash <Enter> "__TrashBox_EL $w $trashIcon Enter"
  $w bind ude_trash <Leave> "__TrashBox_EL $w $trashIcon Leave"
  $w bind ude_trash <ButtonRelease-1> " "
  bind $w <Enter> "UI_PB_ude_EnterTrashBox %W $trashIcon"
  bind $w <Leave> "UI_PB_ude_LeaveTrashBox %W $trashIcon"
  bind $w <B1-Motion> "UI_PB_ude_MotionInTrashBox %W %x %y"
  set gPB(c_help,$w,ude_trash) "ude,editor,trash"
 }

#=======================================================================
proc __TrashBox_EL {cw w type} {
  global gPB
  global paOption
  if {$type == "Enter"} {
   if {$gPB(use_info)} {
    $cw config -cursor question_arrow
    $w config -bg $paOption(focus)
   }
   } else {
   $cw config -cursor ""
   $w config -bg $paOption(app_butt_bg)
  }
 }

#=======================================================================
proc UI_PB_ude_MotionInTrashBox {w x y} {
  if $udeEditor::($udeEditor::(obj),isReadyForDelete) {
   set rootx [winfo rootx $w]
   set rooty [winfo rooty $w]
   set cx [$w canvasx $x]
   set cy [$w canvasy $y]
   set fx [expr {$cx - $rootx}]
   set fy [expr {$cy - $rooty}]
   set id [$w find withtag trashline]
   set pos [expr $udeEditor::($udeEditor::(obj),left_panel_width) / 2]
   $w coords $id  $pos $pos $fx $fy
  }
 }

#=======================================================================
proc UI_PB_ude_EnterTrashBox {w icon} {
  global paOption
  if $udeEditor::($udeEditor::(obj),isInDD_ForDelete) {
   $icon config -bg $paOption(focus)
   set udeEditor::($udeEditor::(obj),isReadyForDelete) 1
  }
 }

#=======================================================================
proc UI_PB_ude_LeaveTrashBox {w icon} {
  global paOption
  $icon config -bg $paOption(app_butt_bg)
  set udeEditor::($udeEditor::(obj),isReadyForDelete) 0
 }

#=======================================================================
proc UI_PB_ude_GetRespondingArea {w {type item}} {
   set area [list]
   set rx [winfo rootx $w]
   set ry [winfo rooty $w]
   set width [winfo width $w]
   set height [winfo height $w]
   if {$type == "item"} {
    lappend area [expr {$rx - 50}] ;#left
    lappend area [expr {$rx + 250}] ;#right
    lappend area [expr {$ry - 10}] ;#top
    lappend area [expr {$ry + 15}] ;#bottom
    } else {
    lappend area [expr {$rx + 5}] ;#left
    lappend area [expr {$rx + $width - 5}] ;#right
    lappend area [expr {$ry + 5}] ;#top
    lappend area [expr {$ry + $height - 5}] ;#bottom
   }
   return $area
  }

#=======================================================================
proc UI_PB_ude_isInRespndArea {X Y area} {
  set left [lindex $area 0]
  set right [lindex $area 1]
  set top [lindex $area 2]
  set bot [lindex $area 3]
  if [expr {$X >= $left}]&&[expr {$X <= $right}]&&[expr {$Y >= $top}]&&[expr {$Y <= $bot}] {
   return 1
   } else {
   return 0
  }
 }

#=======================================================================
proc UI_PB_ude_EventEditPopupMenu {seq_obj} {
  set sequence::($seq_obj,popup_flag) 1
 }

#=======================================================================
proc UI_PB_ude_AddNewUdeEventPopupMenu {w x y page_obj seq_obj} {
  global gPB post_object
  catch {__event_CancelBalloon $w}
  if [winfo exists $w.m] {
   destroy $w.m
  }
  set pm [menu $w.m -tearoff 0]
  if {![info exists sequence::($seq_obj,popup_flag)]} {
   set sequence::($seq_obj,popup_flag) 0
  }
  if {$sequence::($seq_obj,popup_flag) == 1} {
   set texticon_id $sequence::($seq_obj,texticon_ids)
   set objects [UI_PB_evt_GetCurrentCanvasObject $w texticon_id]
   set event_obj [UI_PB_evt_GetEventObjOfCurPos seq_obj \
   [lindex $objects 0]]
   $pm add command -label $gPB(ude,editor,popup,EDIT) \
   -command "UI_PB_ude_PreCreateUdeEditor $w $event_obj \
   $page_obj $seq_obj;destroy $pm"
   $pm add command -label $gPB(ude,editor,popup,DELETE) \
   -command "UI_PB_ude_DeleteEvent $w $page_obj $seq_obj \
   $event_obj;destroy $pm"
   set udeobj $Post::($post_object,ude_obj)
   set seqobj $ude::($udeobj,seq_obj)
   set evt_list $sequence::($seqobj,evt_obj_list)
   if {[lsearch $evt_list $event_obj] < "0"} {
    $pm entryconfigure 2 -state disabled
   }
   } else {
   $pm add command -label $gPB(ude,editor,popup,CREATE) \
   -command "destroy $pm;\
   UI_PB_ude_CreateNewUdeEvent $w $page_obj $seq_obj"
   if 0 {
    $pm add separator
    $pm add command -label $gPB(nav_button,default,Label) \
    -command "destroy $pm;\
    UI_PB_ude_import_UDE_and_UDC"
    $pm add command -label $gPB(nav_button,restore,Label) \
    -command "destroy $pm;\
    UI_PB_ude_import_UDE_and_UDC"
   }
  }
  set sequence::($seq_obj,popup_flag)  0
  tk_popup $pm $x $y
 }

#=======================================================================
proc UI_PB_ude_import_UDE_and_UDC {} {
  tk_messageBox -message "asdfd"
 }

#=======================================================================
proc UI_PB_ude_PreCreateUdeEditor {w evt_obj page_obj seq_obj} {
  global gPB
  set evt_name $event::($evt_obj,event_name)
  if [string match $evt_name "Spindle CSS"] {
   set evt_name [lreplace $evt_name end end]
   tk_messageBox -message $gPB(ude,editor,spindle_css,INFO) \
   -parent $::gPB(main_window)
   return
  }
  UI_PB_ude_CreateUdeEditor $w $evt_obj $page_obj $seq_obj
 }

#=======================================================================
proc UI_PB_ude_DeleteEvent { w page_obj seq_obj event_obj } {
  global gPB post_object
  set ude_evt_obj $event::($event_obj,ude_event_obj)
  if { [tk_messageBox -type okcancel -icon question -default cancel -parent [UI_PB_com_AskActiveWindow] \
   -message "$gPB(msg,event,delete_confirm) \"$ude_event::($ude_evt_obj,name)\" ?"] == "cancel" } {
   return
  }
  $w delete $event::($event_obj,rect_id)
  $w delete $event::($event_obj,icon_id)
  $w delete $event::($event_obj,sep_id)
  $w delete $event::($event_obj,text_id)
  $w delete $event::($event_obj,col_icon_id)
  $w delete $event::($event_obj,evt_rect)
  $w delete $event::($event_obj,blk_rect)
  $w delete $event::($event_obj,blk_text)
  $w delete $event::($event_obj,extra_lines)
  set index [lsearch $sequence::($seq_obj,evt_obj_list) $event_obj]
  if {$index != "-1"} {
   set temp_list [lreplace $sequence::($seq_obj,evt_obj_list) \
   $index $index]
   set sequence::($seq_obj,evt_obj_list) $temp_list
  }
  __tpth_UpdateSequenceEvent page_obj seq_obj event_obj
  set udeobj $Post::($post_object,ude_obj)
  set seq_obj_in_ude $ude::($udeobj,seq_obj)
  set ude_evt_obj $event::($event_obj,ude_event_obj)
  set index1 [lsearch $sequence::($seq_obj_in_ude,non_mc_ude_obj_list) \
  $ude_evt_obj]
  if {$index1 != "-1"} {
   set temp_list [lreplace $sequence::($seq_obj_in_ude,non_mc_ude_obj_list) \
   $index1 $index1]
   set sequence::($seq_obj_in_ude,non_mc_ude_obj_list) $temp_list
  }
  set index2 [lsearch $sequence::($seq_obj_in_ude,evt_obj_list) $event_obj]
  if {$index2 != "-1"} {
   set temp_list [lreplace $sequence::($seq_obj_in_ude,evt_obj_list) \
   $index2 $index2]
   set sequence::($seq_obj_in_ude,evt_obj_list)  $temp_list
  }
  set index3 [lsearch $ude::($udeobj,event_obj_list) $ude_evt_obj]
  if {$index3 != "-1"} {
   set temp_list [lreplace $ude::($udeobj,event_obj_list) \
   $index3 $index3]
   set ude::($udeobj,event_obj_list) $temp_list
  }
  UI_PB_ude_DeleteBlks $event_obj
  delete $event_obj
  foreach param_obj $ude_event::($ude_evt_obj,param_obj_list) {
   delete $param_obj
  }
  if {$ude_event::($ude_evt_obj,post_event) == ""} {
   set handler_name MOM_$ude_event::($ude_evt_obj,name)
   } else {
   set handler_name MOM_$ude_event::($ude_evt_obj,post_event)
  }
  set index [lsearch $gPB(MOM_func,SYS) $handler_name]
  if {$index >= 0} {
   set gPB(MOM_func,SYS) [lreplace $gPB(MOM_func,SYS) $index $index]
  }
  delete $ude_evt_obj
 }

#=======================================================================
proc UI_PB_ude_DeleteBlks {evt_obj} {
  global post_object
  set evt_elem_list $event::($evt_obj,evt_elem_list)
  foreach evt_elem_obj $evt_elem_list {
   set blk_obj $event_element::($evt_elem_obj,block_obj)
   set indx [lsearch $Post::($post_object,blk_obj_list) $blk_obj]
   set temp_list [lreplace $Post::($post_object,blk_obj_list) $indx $indx]
   set Post::($post_object,blk_obj_list) $temp_list
   set elem_addr_list $block::($blk_obj,elem_addr_list)
   switch $block::($blk_obj,blk_type) {
    "command" {
     set blk_elem [lindex $elem_addr_list 0]
     set cmd_obj $block_element::($blk_elem,elem_mom_variable)
     set cmd_obj_owner_list $command::($cmd_obj,blk_elem_list)
     set indx [lsearch $cmd_obj_owner_list $blk_elem]
     set command::($cmd_obj,blk_elem_list) \
     [lreplace $cmd_obj_owner_list $indx $indx]
     delete $blk_elem
    }
    "comment" {
     set blk_elem [lindex $elem_addr_list 0]
     delete $blk_elem
    }
    default   {
     foreach blk_elem $elem_addr_list {
      set add_obj $block_element::($blk_elem,elem_add_obj)
      set add_obj_owner_list $address::($add_obj,blk_elem_list)
      set indx [lsearch $add_obj_owner_list $blk_elem]
      set address::($add_obj,blk_elem_list) \
      [lreplace $add_obj_owner_list $indx $indx]
      delete $blk_elem
     }
    }
   }
   delete $blk_obj
   delete $evt_elem_obj
  }
 }

#=======================================================================
proc UI_PB_ude_CreateNewUdeEvent {w page_obj seq_obj} {
  global gPB post_object machType
  set udeobj $Post::($post_object,ude_obj)
  set ude::($udeobj,new_event_name_var) "new_event"
  set ude::($udeobj,new_post_name_var)  "new_event"
  set ude::($udeobj,new_post_name_var_exist) 1
  set ude::($udeobj,new_ui_label_var)   "New Event"
  set ude::($udeobj,new_ui_label_var_exist)  1
  set ude::($udeobj,new_category_var_exist)  1
  set ude::($udeobj,new_category_mill)   0
  set ude::($udeobj,new_category_lathe)  0
  set ude::($udeobj,new_category_drill)  0
  set ude::($udeobj,new_category_wedm)   0
  set ude::($udeobj,new_help_descript_var) ""
  set ude::($udeobj,new_help_descript_var_exist) 0
  set ude::($udeobj,new_help_url_var) ""
  set type [string tolower $machType]
  if ![string compare $type "wire edm"] {
   set type "wedm"
  }
  set ude::($udeobj,new_category_$type) 1
  set main [toplevel $w.event]
  bind all <Enter> ""
  set rootx [winfo rootx $w]
  set rooty [winfo rooty $w]
  set x [expr {$rootx + 350}]
  set y [expr {$rooty + 50}]
  set geom +${x}+${y}
  wm resizable $main 1 1
  UI_PB_com_CreateTransientWindow $main $gPB(ude,editor,CREATE) \
  $geom "" "" "" ""
  focus $main
  set topframe [frame $main.top -bd 1 -relief sunken]
  set bottomframe [frame $main.bottom]
  set f1 [frame $topframe.1]
  set f1_f [UI_PB_com_AddSeparator $topframe.1f]
  set f2 [frame $topframe.2]
  set f2_f [UI_PB_com_AddSeparator $topframe.2f]
  set f3 [frame $topframe.3]
  set f3_f [UI_PB_com_AddSeparator $topframe.3f]
  set f4 [frame $topframe.4]
  set f5 [frame $f4.top]
  set f6 [frame $f4.bot]
  set name_l [label $f1.l -text $gPB(ude,editor,eventdlg,EN,Label) -font $gPB(bold_font)]
  set name_e [entry $f1.e -textvariable ude::($udeobj,new_event_name_var) \
  -width 28]
  bind $name_e <KeyPress> "UI_PB_com_DisableSpecialChars %W %K"
  bind $name_e <KeyPress>      "+UI_PB_com_RestrictStringLength %W %K"
  bind $name_e <Control-Key-v> " UI_PB_com_Validate_Control_V %W %K %A"
  bind $name_e <KeyRelease>    " UI_PB_com_Validate_Control_V_Release %W"
  set gPB(c_help,$name_e) "ude,editor,eventdlg,EN"
  set pname_tf [frame $f2.tf]
  set pname_l [label $pname_tf.l -text $gPB(ude,editor,eventdlg,PEN,Label) -font $gPB(bold_font)]
  set pname_e [entry $f2.e -textvariable ude::($udeobj,new_post_name_var) \
  -width 12]
  set pname_c [checkbutton $pname_tf.c \
  -variable ude::($udeobj,new_post_name_var_exist) \
  -command "UI_PB_ude_ShiftState \
  ude::($udeobj,new_post_name_var_exist) $pname_e"]
  bind $pname_e <KeyPress>      " UI_PB_com_DisableSpecialChars %W %K 1"
  bind $pname_e <KeyRelease>    " UI_PB_ude_RestoreState $udeobj %W"
  bind $pname_e <KeyPress>      "+UI_PB_com_RestrictStringLength %W %K"
  bind $pname_e <Control-Key-v> " UI_PB_com_Validate_Control_V %W %K %A"
  bind $pname_e <KeyRelease>    "+UI_PB_com_Validate_Control_V_Release %W"
  set gPB(c_help,$pname_e) "ude,editor,eventdlg,PEN"
  set gPB(c_help,$pname_c) "ude,editor,eventdlg,PEN,C"
  set label_tf [frame $f3.tf]
  set label_l [label $label_tf.l -text $gPB(ude,editor,eventdlg,EL,Label) -font $gPB(bold_font)]
  set label_e [entry $f3.e -textvariable ude::($udeobj,new_ui_label_var) \
  -width 12]
  set label_c [checkbutton $label_tf.c \
  -variable ude::($udeobj,new_ui_label_var_exist) \
  -command "UI_PB_ude_ShiftState \
  ude::($udeobj,new_ui_label_var_exist) $label_e"]
  set gPB(c_help,$label_e) "ude,editor,eventdlg,EL"
  set gPB(c_help,$label_c) "ude,editor,eventdlg,EL,C"
  set ctg_l   [label $f5.l -text $gPB(ude,editor,eventdlg,EC,Label) -font $gPB(bold_font)]
  set ctg_c   [checkbutton $f5.c -variable ude::($udeobj,new_category_var_exist)]
  set top_f6 [frame $f6.top]
  set bot_f6 [frame $f6.bot]
  set gPB(c_help,$ctg_c) "ude,editor,eventdlg,EC"
  set ctg_mill_c [checkbutton $top_f6.mill \
  -text $gPB(ude,editor,eventdlg,EC_MILL,Label) \
  -variable ude::($udeobj,new_category_mill)]
  set ctg_drill_c [checkbutton $top_f6.drill \
  -text $gPB(ude,editor,eventdlg,EC_DRILL,Label) \
  -variable ude::($udeobj,new_category_drill)]
  set ctg_lathe_c [checkbutton $bot_f6.lathe \
  -text $gPB(ude,editor,eventdlg,EC_LATHE,Label) \
  -variable ude::($udeobj,new_category_lathe)]
  set ctg_wedm_c [checkbutton $bot_f6.wedm \
  -text $gPB(ude,editor,eventdlg,EC_WEDM,Label) \
  -variable ude::($udeobj,new_category_wedm)]
  set gPB(c_help,$ctg_mill_c)  "ude,editor,eventdlg,EC_MILL"
  set gPB(c_help,$ctg_drill_c) "ude,editor,eventdlg,EC_DRILL"
  set gPB(c_help,$ctg_lathe_c) "ude,editor,eventdlg,EC_LATHE"
  set gPB(c_help,$ctg_wedm_c)  "ude,editor,eventdlg,EC_WEDM"
  if 0 {
   switch -exact $type {
    "mill" {
     $ctg_mill_c config \
     -command [list UI_PB_ude_Disable_ShiftState $ctg_mill_c]
    }
    "lathe" {
     $ctg_lathe_c config \
     -command [list UI_PB_ude_Disable_ShiftState $ctg_lathe_c]
    }
    "wedm" {
     $ctg_wedm_c config \
     -command [list UI_PB_ude_Disable_ShiftState $ctg_wedm_c]
    }
   }
  }
  switch -exact $type {
   "wedm" {
    $ctg_wedm_c config \
    -command [list UI_PB_ude_Disable_ShiftState $ctg_wedm_c]
   }
  }
  $ctg_c config -command "UI_PB_ude_ShiftState \
  ude::($udeobj,new_category_var_exist) \
  $ctg_mill_c $ctg_drill_c \
  $ctg_lathe_c $ctg_wedm_c"
  set fa1 [frame $topframe.a1]
  set fa1_f [UI_PB_com_AddSeparator $topframe.a1f]
  set help_tf [frame $fa1.tf]
  set help_topl [label $help_tf.l -text $gPB(ude,editor,eventdlg,DESC,Label) -font $gPB(bold_font)]
  set help_tope [entry $fa1.te -textvariable ude::($udeobj,new_help_descript_var) \
  -state disabled -width 12] ;#<05-07-09 gsl> was "disable" (no d)
  set help_bf [frame $fa1.bf]
  set help_btml [label $help_bf.l -text $gPB(ude,editor,eventdlg,URL,Label) -font $gPB(bold_font)]
  set help_btme [entry $fa1.be -textvariable ude::($udeobj,new_help_url_var) \
  -state disabled -width 12] ;#<05-07-09 gsl> was "disable" (no d)
  set help_topc [checkbutton $help_tf.c \
  -variable ude::($udeobj,new_help_descript_var_exist) \
  -command "UI_PB_ude_ShiftState \
  ude::($udeobj,new_help_descript_var_exist) $help_tope $help_btme"]
  UI_PB_ude_ShiftState ude::($udeobj,new_help_descript_var_exist) $help_tope $help_btme
  set gPB(c_help,$help_tope) "ude,editor,eventdlg,DESC"
  set gPB(c_help,$help_btme) "ude,editor,eventdlg,URL"
  set name_list {"gPB(nav_button,ok,Label)" "gPB(nav_button,cancel,Label)"}
  set cb_arr(gPB(nav_button,ok,Label)) ""
  set cb_arr(gPB(nav_button,cancel,Label)) ""
  UI_PB_com_CreateButtonBox $bottomframe name_list cb_arr
  ${bottomframe}.box.act_0 config  \
  -command "UI_PB_ude_CreateNewUdeEvent_OK $main $page_obj $seq_obj"
  ${bottomframe}.box.act_1 config  \
  -command "UI_PB_ude_CreateNewUdeEvent_CNL $main $udeobj"
  wm protocol $main WM_DELETE_WINDOW \
  "UI_PB_ude_CreateNewUdeEvent_CNL $main $udeobj"
  if ![string compare $::tix_version 8.4] {
   pack $bottomframe -side bottom  -fill x -pady 2 -padx 2
   } else {
   pack $bottomframe -side bottom  -fill x -pady 3 -padx 2
  }
  pack $topframe -side top -expand yes -fill both -pady 5 -padx 2
  pack $f1 $f1_f $f2 $f2_f $f3 $f3_f $fa1 $fa1_f -side top -fill x -pady 2 -padx 5
  pack $f4 -side top -expand no -fill x -pady 10 -padx 5
  pack $f5 $f6 -side top -expand yes -fill x -pady 1
  pack $top_f6 $bot_f6 -side left -expand yes -fill x -pady 1
  pack $name_l -side top -anchor w
  pack $name_e -fill x -padx 5 -pady 10
  pack $pname_c $pname_l -side left
  pack $pname_tf -side top -fill x
  pack $pname_e -fill x -pady 10 -padx 5
  pack $label_c $label_l -side left
  pack $label_tf -side top -fill x
  pack $label_e -fill x -pady 10 -padx 5
  pack $help_topc $help_topl -side left
  pack $help_tf -side top -fill x
  pack $help_tope -fill x -pady 10 -padx 5
  pack $help_btml -side left
  pack $help_bf -side top -fill x
  pack $help_btme -fill x -pady 10 -padx 5
  pack $ctg_c $ctg_l -side left
  if ![string compare $::tix_version 8.4] {
   pack $ctg_mill_c -side top -padx 15 -anchor w
   pack $ctg_drill_c -side bottom -padx 15 -anchor w
   pack $ctg_lathe_c -side top -padx 0 -anchor w
   pack $ctg_wedm_c -side bottom -padx 0 -anchor w
   } else {
   pack $ctg_mill_c -side top -padx 25 -anchor w
   pack $ctg_drill_c -side bottom -padx 25 -anchor w
   pack $ctg_lathe_c -side top -padx 0 -anchor w
   pack $ctg_wedm_c -side bottom -padx 0 -anchor w
  }
 }

#=======================================================================
proc UI_PB_ude_Disable_ShiftState {chk} {
  $chk select
 }

#=======================================================================
proc UI_PB_ude_RestoreState {udeobj w} {
  if $ude::($udeobj,new_post_name_var_exist) {
   $w config -state normal
  }
 }

#=======================================================================
proc UI_PB_ude_CreateNewUdeEvent_OK {w page_obj seq_obj} {
  global post_object
  global gPB
  global machType ;#<12-08-10 wbh>
  tk_focusFollowsMouse
  set udeobj $Post::($post_object,ude_obj)
  set eventname $ude::($udeobj,new_event_name_var)
  set name_trimed [string trim $eventname]
  if ![string compare $name_trimed ""] {
   tk_messageBox -message $gPB(ude,editor,popup,MSG_BLANK) -icon error \
   -title $gPB(msg,error) -parent [UI_PB_com_AskActiveWindow]
   return
  }
  set event_obj_list $ude::($udeobj,event_obj_list)
  foreach obj $event_obj_list {
   if ![string compare $eventname $ude_event::($obj,name)] {
    tk_messageBox -message $gPB(ude,editor,popup,MSG_SAMENAME) -icon error \
    -title $gPB(msg,error) -parent [UI_PB_com_AskActiveWindow]
    return
   }
  }
  if $ude::($udeobj,new_post_name_var_exist) {
   set handler_name MOM_$ude::($udeobj,new_post_name_var)
   } else {
   set handler_name MOM_${name_trimed}
  }
  if {[lsearch $gPB(MOM_func,SYS) $handler_name] >= 0} {
   tk_messageBox -message "$handler_name : $gPB(ude,editor,popup,MSG_SameHandler)" \
   -icon error \
   -title $gPB(msg,error) -parent [UI_PB_com_AskActiveWindow]
   return
  }
  set is_validate $ude::($udeobj,new_help_descript_var_exist)
  set str_desc $ude::($udeobj,new_help_descript_var)
  set str_url $ude::($udeobj,new_help_url_var)
  if { [UI_PB_ude_ValidateDescAndUrlWidgets $is_validate $str_desc $str_url] } \
  {
   return
  }
  set type [string tolower $machType]
  if { [string match "mill" $type] || [string match "lathe" $type] } {
   if { $ude::($udeobj,new_category_var_exist) == 1 && \
    $ude::($udeobj,new_category_wedm) == 1 } {
    set allow_flag 0
    if { $ude::($udeobj,new_category_mill) == 1 } {
     set allow_flag 1
     } elseif { $ude::($udeobj,new_category_lathe) == 1 } {
     set allow_flag 1
     } elseif { $ude::($udeobj,new_category_drill) == 1 } {
     set allow_flag 1
    }
    if { !$allow_flag } {
     tk_messageBox -message $gPB(ude,editor,popup,MSG_CATEGORY) -icon error \
     -title $gPB(msg,error) -parent [UI_PB_com_AskActiveWindow]
     return
    }
   }
  }
  set canvas_id [winfo parent $w]
  wm withdraw $w
  destroy $w
  set ueo [UI_PB_ude_GetNewUdeEventObj]
  set seq_obj_in_ude $ude::($udeobj,seq_obj)
  lappend sequence::($seq_obj_in_ude,non_mc_ude_obj_list) $ueo
  lappend ude::($udeobj,event_obj_list) $ueo
  set evt_obj [new event]
  set event::($evt_obj,event_name) $ude_event::($ueo,name)
  set event::($evt_obj,event_ude_name) $ude_event::($ueo,name)
  set event::($evt_obj,block_nof_rows) "0"
  set event::($evt_obj,evt_elem_list)  ""
  set event::($evt_obj,evt_itm_obj_list) ""
  if ![string compare $ude_event::($ueo,ui_label) ""] {
   set event::($evt_obj,event_label) $ude_event::($ueo,name)
   } else {
   set event::($evt_obj,event_label) $ude_event::($ueo,ui_label)
  }
  set event::($evt_obj,ude_event_obj) $ueo
  event::DefaultValue $evt_obj
  event::RestoreValue $evt_obj
  __evt_GetEventOrigin $page_obj evt_xc evt_yc
  set last_evt_obj [lindex $sequence::($seq_obj,evt_obj_list) end]
  set evt_yc $event::($last_evt_obj,event_height)
  set event::($evt_obj,xc) $evt_xc
  set event::($evt_obj,yc) $evt_yc
  set event::($evt_obj,col_image) "minus"
  lappend sequence::($seq_obj_in_ude,evt_obj_list) $evt_obj
  lappend sequence::($seq_obj,evt_obj_list) $evt_obj
  UI_PB_evt_CreateEvent page_obj seq_obj evt_obj
  UI_PB_evt_CreateElemOfTpthEvent page_obj seq_obj evt_obj
  unset ude::($udeobj,new_event_name_var)
  unset ude::($udeobj,new_post_name_var)
  unset ude::($udeobj,new_post_name_var_exist)
  unset ude::($udeobj,new_ui_label_var)
  unset ude::($udeobj,new_ui_label_var_exist)
  unset ude::($udeobj,new_category_var_exist)
  unset ude::($udeobj,new_category_mill)
  unset ude::($udeobj,new_category_lathe)
  unset ude::($udeobj,new_category_drill)
  unset ude::($udeobj,new_category_wedm)
  unset ude::($udeobj,new_help_descript_var)
  unset ude::($udeobj,new_help_descript_var_exist)
  unset ude::($udeobj,new_help_url_var)
  UI_PB_ude_CreateUdeEditor $canvas_id $evt_obj $page_obj $seq_obj 1
  UI_PB_ude_DisplayUdeHelpWidgets
 }

#=======================================================================
proc UI_PB_ude_GetNewUdeEventObj { } {
  global post_object
  set udeobj $Post::($post_object,ude_obj)
  set ueo [new ude_event]
  set obj_attr(0) $ude::($udeobj,new_event_name_var)
  if {$ude::($udeobj,new_post_name_var_exist) == 1} {
   set obj_attr(1) $ude::($udeobj,new_post_name_var)
   }  else {
   set obj_attr(1) ""
  }
  if {$ude::($udeobj,new_ui_label_var_exist) == 1} {
   set obj_attr(2) $ude::($udeobj,new_ui_label_var)
   }  else {
   set obj_attr(2) ""
  }
  if {$ude::($udeobj,new_category_var_exist) == 1} {
   set temp [list]
   if {$ude::($udeobj,new_category_mill) == 1} {
    lappend temp "MILL"
   }
   if {$ude::($udeobj,new_category_drill) == 1} {
    lappend temp "DRILL"
   }
   if {$ude::($udeobj,new_category_lathe) == 1} {
    lappend temp "LATHE"
   }
   if {$ude::($udeobj,new_category_wedm) == 1} {
    lappend temp "WEDM"
   }
   if {[llength $temp] == 0} {
    set obj_attr(3) "\{\}"
    } else {
    set obj_attr(3) $temp
   }
   } else {
   set obj_attr(3) "\{\}"
  }
  set type "o"
  set param_obj [param::CreateObject type]
  set param_attr(0) "command_status"
  set param_attr(1) "o"
  set param_attr(2) "Active"
  set param_attr(3) "\"Active\",\"Inactive\",\"User Defined\""
  set param_attr(4) "Status"
  set param_attr(5) ""
  param::ObjectSetValue $param_obj param_attr
  param::ObjectSetDefaultValue $param_obj param_attr
  set obj_attr(4) [list $param_obj]
  if {$ude::($udeobj,new_help_descript_var_exist) ==1} {
   set obj_attr(5) $ude::($udeobj,new_help_descript_var)
   set obj_attr(6) $ude::($udeobj,new_help_url_var)
   } else {
   set obj_attr(5) ""
   set obj_attr(6) ""
  }
  ude_event::setvalue $ueo obj_attr
  ude_event::setdefvalue $ueo obj_attr
  return $ueo
 }

#=======================================================================
proc UI_PB_ude_CreateNewUdeEvent_CNL {w udeobj} {
  global gPB
  tk_focusFollowsMouse
  if {[info exists gPB(use_info)] && $gPB(use_info)} {
   return
   } else {
   wm withdraw $w
   destroy $w
   unset ude::($udeobj,new_event_name_var)
   unset ude::($udeobj,new_post_name_var)
   unset ude::($udeobj,new_post_name_var_exist)
   unset ude::($udeobj,new_ui_label_var)
   unset ude::($udeobj,new_ui_label_var_exist)
   unset ude::($udeobj,new_category_var_exist)
   unset ude::($udeobj,new_category_mill)
   unset ude::($udeobj,new_category_lathe)
   unset ude::($udeobj,new_category_drill)
   unset ude::($udeobj,new_category_wedm)
   unset ude::($udeobj,new_help_descript_var)
   unset ude::($udeobj,new_help_descript_var_exist)
   unset ude::($udeobj,new_help_url_var)
  }
 }

#=======================================================================
proc UI_PB_cycle_AddNewUdcEventPopupMenu {w x y page_obj seq_obj} {
  global gPB post_object
  catch {__event_CancelBalloon $w}
  if [winfo exists $w.m] {
   destroy $w.m
  }
  set pm [menu $w.m -tearoff 0]
  if {![info exists sequence::($seq_obj,popup_flag)]} {
   set sequence::($seq_obj,popup_flag) 0
  }
  if {$sequence::($seq_obj,popup_flag) == 1} {
   set texticon_id $sequence::($seq_obj,texticon_ids)
   set objects [UI_PB_evt_GetCurrentCanvasObject $w texticon_id]
   set event_obj [UI_PB_evt_GetEventObjOfCurPos seq_obj \
   [lindex $objects 0]]
   $pm add command -label $gPB(udc,editor,popup,EDIT) \
   -command "UI_PB_cycle_PreCreateUdeEditor $w \
   $event_obj $page_obj $seq_obj;destroy $pm"
   $pm add command -label $gPB(ude,editor,popup,DELETE) \
   -command "UI_PB_cycle_DeleteEvent $w $page_obj \
   $seq_obj $event_obj;destroy $pm"
   set udeobj $Post::($post_object,ude_obj)
   set seqobj_cycle $ude::($udeobj,seq_obj_cycle)
   set evt_list $sequence::($seqobj_cycle,evt_obj_list)
   if {[lsearch $evt_list $event_obj] < "0"} {
    $pm entryconfigure 1 -state disabled
   }
   set evt_name $event::($event_obj,event_name)
   if {$evt_name == "Cycle Parameters" || \
    $evt_name == "Cycle Off" || \
    $evt_name == "Cycle Plane Change"} {
    $pm entryconfigure 0 -state disabled
   }
   } else {
   $pm add command -label $gPB(udc,editor,popup,CREATE) \
   -command "UI_PB_cycle_CreateNewUdcEvent $w \
   $page_obj $seq_obj; destroy $pm"
   if 0 {
    $pm add separator
    $pm add command -label $gPB(nav_button,default,Label)
    $pm add command -label $gPB(nav_button,restore,Label)
   }
  }
  set sequence::($seq_obj,popup_flag)  0
  tk_popup $pm $x $y
 }

#=======================================================================
proc UI_PB_cycle_PreCreateUdeEditor {w evt_obj page_obj seq_obj} {
  global gPB
  set evt_name $event::($evt_obj,event_name)
  if {$evt_name == "Drill Dwell" || \
   $evt_name == "Bore Dwell" || \
   $evt_name == "Bore Manual Dwell"} {
   set evt_name [lreplace $evt_name end end]
   set msg "$gPB(udc,drill,dwell,INFO)${evt_name}!"
   tk_messageBox -message $msg -parent $::gPB(main_window)
   return
  }
  UI_PB_ude_CreateUdeEditor $w $evt_obj $page_obj $seq_obj
 }

#=======================================================================
proc UI_PB_cycle_CreateNewUdcEvent {w page_obj seq_obj} {
  global gPB post_object
  set udeobj $Post::($post_object,ude_obj)
  bind all <Enter> ""
  set ude::($udeobj,new_cyc_type_var)         "UDC"
  set ude::($udeobj,new_cyc_label_var)        "New Cycle"
  set ude::($udeobj,new_cyc_label_var_exist)  1
  set ude::($udeobj,new_cyc_name_var)         "new_cycle"
  set ude::($udeobj,new_syscyc_name_var)      "Drill"
  if $gPB(enable_helpdesc_for_udc) {
   set ude::($udeobj,new_help_descript_var)       ""
   set ude::($udeobj,new_help_descript_var_exist) 0
   set ude::($udeobj,new_help_url_var)            ""
  }
  set main [toplevel $w.event]
  set rootx [winfo rootx $w]
  set rooty [winfo rooty $w]
  set x [expr {$rootx + 350}]
  set y [expr {$rooty + 50}]
  set geom +${x}+${y}
  wm resizable $main 1 1
  UI_PB_com_CreateTransientWindow $main $gPB(udc,editor,CREATE) \
  $geom "" "" "" ""
  focus $main
  set topframe [frame $main.top -bd 1 -relief sunken]
  set bottomframe [frame $main.bottom]
  set f1 [frame $topframe.1]
  set f1_f [UI_PB_com_AddSeparator $topframe.1f]
  set f2 [frame $topframe.2]
  set name_l [label $f1.l -text $gPB(udc,editor,CYCNAME,Label) -font $gPB(bold_font)]
  set name_e [entry $f1.e -width 28 \
  -textvariable ude::($udeobj,new_cyc_name_var)]
  bind $name_e <KeyPress>      " UI_PB_com_DisableSpecialChars %W %K"
  bind $name_e <KeyPress>      "+UI_PB_com_RestrictStringLength %W %K"
  bind $name_e <Control-Key-v> " UI_PB_com_Validate_Control_V %W %K %A"
  bind $name_e <KeyRelease>    "+UI_PB_com_Validate_Control_V_Release %W"
  set lbl_tf [frame $f2.tf]
  set lbl_l [label $lbl_tf.l -text $gPB(udc,editor,CYCLBL,Label) -font $gPB(bold_font)]
  set lbl_e [entry $f2.e -width 12 \
  -textvariable ude::($udeobj,new_cyc_label_var)]
  set lbl_c [checkbutton $lbl_tf.c \
  -variable ude::($udeobj,new_cyc_label_var_exist) \
  -command "UI_PB_ude_ShiftState \
  ude::($udeobj,new_cyc_label_var_exist) $lbl_e"]
  set gPB(c_help,$name_e) "udc,editor,CYCNAME"
  set gPB(c_help,$lbl_e)  "udc,editor,CYCLBL"
  set gPB(c_help,$lbl_c)  "udc,editor,CYCLBL,C"
  if $gPB(enable_helpdesc_for_udc) {
   set fa1 [frame $topframe.a1]
   set fa1_f [UI_PB_com_AddSeparator $topframe.a1f]
   set help_tf [frame $fa1.tf]
   set help_topl [label $help_tf.l -text $gPB(ude,editor,eventdlg,DESC,Label) -font $gPB(bold_font)]
   set help_tope [entry $fa1.te -textvariable ude::($udeobj,new_help_descript_var) \
   -state disabled -width 12]
   set help_bf [frame $fa1.bf]
   set help_btml [label $help_bf.l -text $gPB(ude,editor,eventdlg,URL,Label) -font $gPB(bold_font)]
   set help_btme [entry $fa1.be -textvariable ude::($udeobj,new_help_url_var) \
   -state disabled -width 12]
   set help_topc [checkbutton $help_tf.c \
   -variable ude::($udeobj,new_help_descript_var_exist) \
   -command "UI_PB_ude_ShiftState \
   ude::($udeobj,new_help_descript_var_exist) $help_tope $help_btme"]
   UI_PB_ude_ShiftState ude::($udeobj,new_help_descript_var_exist) $help_tope $help_btme
   set gPB(c_help,$help_tope) "ude,editor,eventdlg,DESC"
   set gPB(c_help,$help_btme) "ude,editor,eventdlg,URL"
  }
  set name_list {"gPB(nav_button,ok,Label)" "gPB(nav_button,cancel,Label)"}
  set cb_arr(gPB(nav_button,ok,Label)) ""
  set cb_arr(gPB(nav_button,cancel,Label)) ""
  UI_PB_com_CreateButtonBox $bottomframe name_list cb_arr
  ${bottomframe}.box.act_0 config  \
  -command "UI_PB_cycle_CreateNewCycleEvent_OK \
  $main $page_obj $seq_obj"
  ${bottomframe}.box.act_1 config  \
  -command "UI_PB_cycle_CreateNewCycleEvent_CNL $main $udeobj"
  wm protocol $main WM_DELETE_WINDOW \
  "UI_PB_cycle_CreateNewCycleEvent_CNL $main $udeobj"
  if ![string compare $::tix_version 8.4] {
   pack $bottomframe -side bottom  -fill x -pady 2 -padx 2
   if $gPB(enable_helpdesc_for_udc) {
    pack $f1 $f1_f $f2 $fa1_f $fa1 -side top  -fill x -padx 5
    } else {
    pack $f1 $f1_f $f2 -side top  -fill x -padx 5
   }
   } else {
   pack $bottomframe -side bottom  -fill x -pady 3 -padx 2
   if $gPB(enable_helpdesc_for_udc) {
    pack $f1 $f1_f $f2 $fa1_f $fa1 -side top  -fill x -padx 2
    } else {
    pack $f1 $f1_f $f2 -side top  -fill x -padx 2
   }
  }
  pack $topframe -side top  -fill both -expand yes -pady 5 -padx 2
  pack $lbl_c $lbl_l -side left
  pack $lbl_tf -side top -fill x
  pack $lbl_e -fill x -pady 10 -padx 5
  pack $name_l -side top -anchor w -pady 5
  pack $name_e -fill x -pady 10 -padx 5
  if $gPB(enable_helpdesc_for_udc) \
  {
   pack $help_topc $help_topl -side left
   pack $help_tf -side top -fill x
   pack $help_tope -fill x -pady 10 -padx 5
   pack $help_btml -side left
   pack $help_bf -side top -fill x
   pack $help_btme -fill x -pady 10 -padx 5
  }
 }

#=======================================================================
proc UI_PB_cycle_CreateNewCycleEvent_CNL {w udeobj} {
  global gPB
  tk_focusFollowsMouse
  if {[info exists gPB(use_info)] && $gPB(use_info)} {
   return
   } else {
   wm withdraw $w
   destroy $w
   unset ude::($udeobj,new_cyc_type_var)
   unset ude::($udeobj,new_cyc_label_var)
   unset ude::($udeobj,new_cyc_label_var_exist)
   unset ude::($udeobj,new_cyc_name_var)
   unset ude::($udeobj,new_syscyc_name_var)
  }
 }

#=======================================================================
proc UI_PB_cycle_CreateNewCycleEvent_OK { w page_obj seq_obj } {
  global post_object
  global gPB
  tk_focusFollowsMouse
  set udeobj $Post::($post_object,ude_obj)
  if { $ude::($udeobj,new_cyc_type_var) == "UDC" } {
   set cycle_name $ude::($udeobj,new_cyc_name_var)
   set name_trimed [string trim $cycle_name]
   if ![string compare $name_trimed ""] {
    tk_messageBox -message $gPB(udc,editor,popup,MSG_BLANK) -icon error \
    -title $gPB(msg,error) -parent [UI_PB_com_AskActiveWindow]
    return
   }
   set cyc_evt_obj_list $ude::($udeobj,cyc_evt_obj_list)
   foreach cyc_evt $cyc_evt_obj_list {
    if ![string compare $cycle_name $cycle_event::($cyc_evt,name)] {
     if {[lsearch $gPB(SYS_CYCLE) $cycle_name] == "-1"} {
      tk_messageBox -message $gPB(udc,editor,popup,MSG_SAMENAME) -icon error \
      -title $gPB(msg,error) -parent [UI_PB_com_AskActiveWindow]
      return
      } else {
      tk_messageBox -message $gPB(udc,editor,popup,MSG_ISSYSCYC) -icon error \
      -title $gPB(msg,error) -parent [UI_PB_com_AskActiveWindow]
      return
     }
    }
   }
   if { [lsearch $gPB(SYS_CYCLE) $cycle_name] != -1 } {
    tk_messageBox -message $gPB(udc,editor,popup,MSG_ISSYSCYC) -icon error \
    -title $gPB(msg,error) -parent [UI_PB_com_AskActiveWindow]
    return
   }
   set handler_name MOM_${name_trimed}
   if { [lsearch $gPB(MOM_func,SYS) $handler_name] >= 0 || \
    [lsearch $gPB(MOM_func,SYS) ${handler_name}_move] >= 0 } {
    tk_messageBox -message "$handler_name : $gPB(udc,editor,popup,MSG_SameHandler)" \
    -icon error \
    -title $gPB(msg,error) -parent [UI_PB_com_AskActiveWindow]
    return
   }
   } else {
   set cyc_evt_obj_list $ude::($udeobj,cyc_evt_obj_list)
   foreach cyc_evt $cyc_evt_obj_list {
    if {$cycle_event::($cyc_evt,is_sys_cycle) == 1} {
     if ![string compare $cycle_event::($cyc_evt,name) \
     $ude::($udeobj,new_syscyc_name_var)] {
      tk_messageBox -message $gPB(udc,editor,popup,MSG_SYSCYC_EXIST) -icon error \
      -title $gPB(msg,error) -parent [UI_PB_com_AskActiveWindow]
      return
     }
    }
   }
  }
  if $gPB(enable_helpdesc_for_udc) \
  {
   set is_validate $ude::($udeobj,new_help_descript_var_exist)
   set str_desc $ude::($udeobj,new_help_descript_var)
   set str_url $ude::($udeobj,new_help_url_var)
   if { [UI_PB_ude_ValidateDescAndUrlWidgets $is_validate $str_desc $str_url] } \
   {
    return
   }
  }
  set canvas_id [winfo parent $w]
  wm withdraw $w
  destroy $w
  set cyc_evt_obj [UI_PB_cycle_GetNewCycEvtObj]
  set seq_obj_in_ude $ude::($udeobj,seq_obj_cycle)
  lappend ude::($udeobj,cyc_evt_obj_list) $cyc_evt_obj
  set evt_obj [new event]
  set event::($evt_obj,event_name) $cycle_event::($cyc_evt_obj,name)
  set event::($evt_obj,event_ude_name) "CYCLE_EVENT"
  set event::($evt_obj,block_nof_rows) "0"
  set event::($evt_obj,evt_elem_list)  ""
  set event::($evt_obj,evt_itm_obj_list) ""
  if ![string compare $cycle_event::($cyc_evt_obj,ui_label) ""] {
   set event::($evt_obj,event_label) $cycle_event::($cyc_evt_obj,name)
   } else {
   set event::($evt_obj,event_label) $cycle_event::($cyc_evt_obj,ui_label)
  }
  set event::($evt_obj,cyc_evt_obj)      $cyc_evt_obj
  if { $cycle_event::($cyc_evt_obj,is_sys_cycle) == 0 } {
   UI_PB_cycle_MakeCopyFromCommonParam  $evt_obj
  }
  event::DefaultValue $evt_obj
  event::RestoreValue $evt_obj
  __evt_GetEventOrigin $page_obj evt_xc evt_yc
  set last_evt_obj [lindex $sequence::($seq_obj,evt_obj_list) end]
  set evt_yc $event::($last_evt_obj,event_height)
  set event::($evt_obj,xc) $evt_xc
  set event::($evt_obj,yc) $evt_yc
  set event::($evt_obj,col_image) "minus"
  lappend sequence::($seq_obj_in_ude,evt_obj_list) $evt_obj
  lappend sequence::($seq_obj,evt_obj_list) $evt_obj
  UI_PB_evt_CreateEvent page_obj seq_obj evt_obj
  UI_PB_evt_CreateElemOfTpthEvent page_obj seq_obj evt_obj
  unset ude::($udeobj,new_cyc_type_var)
  unset ude::($udeobj,new_cyc_label_var)
  unset ude::($udeobj,new_cyc_label_var_exist)
  unset ude::($udeobj,new_cyc_name_var)
  unset ude::($udeobj,new_syscyc_name_var)
  if $gPB(enable_helpdesc_for_udc) \
  {
   unset ude::($udeobj,new_help_descript_var)
   unset ude::($udeobj,new_help_descript_var_exist)
   unset ude::($udeobj,new_help_url_var)
  }
  UI_PB_ude_CreateUdeEditor $canvas_id $evt_obj $page_obj $seq_obj 1
  if $gPB(enable_helpdesc_for_udc) \
  {
   UI_PB_ude_DisplayUdeHelpWidgets
  }
 }

#=======================================================================
proc UI_PB_cycle_GetNewCycEvtObj {} {
  global post_object
  set udeobj $Post::($post_object,ude_obj)
  set cyc_evt [new cycle_event]
  if {$ude::($udeobj,new_cyc_type_var) == "UDC"} {
   set obj_attr(0) $ude::($udeobj,new_cyc_name_var)
   set obj_attr(1) 0
   } else {
   set obj_attr(0) $ude::($udeobj,new_syscyc_name_var)
   set obj_attr(1) 1
  }
  if {$ude::($udeobj,new_cyc_label_var_exist) == 1} {
   set obj_attr(2) $ude::($udeobj,new_cyc_label_var)
   } else {
   set obj_attr(2) ""
  }
  set obj_attr(4) [list]
  global gPB
  if $gPB(enable_helpdesc_for_udc) \
  {
   if { $ude::($udeobj,new_help_descript_var_exist) == 1 } {
    set obj_attr(5) $ude::($udeobj,new_help_descript_var)
    set obj_attr(6) $ude::($udeobj,new_help_url_var)
    } else {
    set obj_attr(5) ""
    set obj_attr(6) ""
   }
  }
  cycle_event::setvalue $cyc_evt obj_attr
  cycle_event::setdefvalue $cyc_evt obj_attr
  return $cyc_evt
 }

#=======================================================================
proc UI_PB_cycle_DeleteEvent {w page_obj seq_obj event_obj}  {
  global gPB post_object
  set cyc_evt_obj $event::($event_obj,cyc_evt_obj)
  if { [tk_messageBox -type okcancel -icon question -default cancel -parent [UI_PB_com_AskActiveWindow] \
   -message "$gPB(msg,event,delete_confirm) \"$cycle_event::($cyc_evt_obj,name)\" ?"] == "cancel" } {
   return
  }
  $w delete $event::($event_obj,rect_id)
  $w delete $event::($event_obj,icon_id)
  $w delete $event::($event_obj,sep_id)
  $w delete $event::($event_obj,text_id)
  $w delete $event::($event_obj,col_icon_id)
  $w delete $event::($event_obj,evt_rect)
  $w delete $event::($event_obj,blk_rect)
  $w delete $event::($event_obj,blk_text)
  $w delete $event::($event_obj,extra_lines)
  set index [lsearch $sequence::($seq_obj,evt_obj_list) $event_obj]
  if {$index != "-1"} {
   set temp_list [lreplace $sequence::($seq_obj,evt_obj_list) \
   $index $index]
   set sequence::($seq_obj,evt_obj_list) $temp_list
  }
  __tpth_UpdateSequenceEvent page_obj seq_obj event_obj
  set udeobj $Post::($post_object,ude_obj)
  set seq_obj_in_ude $ude::($udeobj,seq_obj_cycle)
  set cyc_evt_obj $event::($event_obj,cyc_evt_obj)
  set index1 [lsearch $sequence::($seq_obj_in_ude,evt_obj_list) $event_obj]
  if {$index1 != "-1"} {
   set temp_list [lreplace $sequence::($seq_obj_in_ude,evt_obj_list) \
   $index1 $index1]
   set sequence::($seq_obj_in_ude,evt_obj_list) $temp_list
  }
  set index2 [lsearch $ude::($udeobj,cyc_evt_obj_list) $cyc_evt_obj]
  if {$index2 != "-1"} {
   set temp_list [lreplace $ude::($udeobj,cyc_evt_obj_list) \
   $index2 $index2]
   set ude::($udeobj,cyc_evt_obj_list) $temp_list
  }
  UI_PB_ude_DeleteBlks $event_obj
  delete $event_obj
  foreach param_obj $cycle_event::($cyc_evt_obj,param_obj_list) {
   delete $param_obj
  }
  delete $cyc_evt_obj
 }

#=======================================================================
proc UI_PB_cycle_EditCycleEvent {w} {
  global gPB
  set OBJ $udeEditor::(obj)
  set udeEditor::($OBJ,temp_ueo_name) $udeEditor::($OBJ,ueo_name)
  set udeEditor::($OBJ,temp_ueo_ui_label) $udeEditor::($OBJ,ueo_ui_label)
  set udeEditor::($OBJ,temp_ueo_is_sys_cycle) \
  $udeEditor::($OBJ,ueo_is_sys_cycle)
  if ![string compare $udeEditor::($OBJ,temp_ueo_ui_label) ""] {
   set udeEditor::($OBJ,exist_ueo_ui_label) 0
   set cur_cycle_evt $udeEditor::(ude_event_obj)
   if [info exists cycle_event::($cur_cycle_evt,prev_exist_ueo_ui_label)] {
    set udeEditor::($OBJ,exist_ueo_ui_label) \
    $cycle_event::($cur_cycle_evt,prev_exist_ueo_ui_label)
    set udeEditor::($OBJ,temp_ueo_ui_label) \
    $cycle_event::($cur_cycle_evt,prev_temp_ueo_ui_label)
   }
   } else {
   set udeEditor::($OBJ,exist_ueo_ui_label) 1
  }
  if {$udeEditor::($OBJ,temp_ueo_is_sys_cycle) == 1} {
   set udeEditor::($OBJ,temp_ueo_type) "SYSCYC"
   } else {
   set udeEditor::($OBJ,temp_ueo_type) "UDC"
  }
  if $gPB(enable_helpdesc_for_udc) \
  {
   set udeEditor::($OBJ,temp_ueo_help_descript) $udeEditor::($OBJ,ueo_help_descript)
   set udeEditor::($OBJ,temp_ueo_help_url) $udeEditor::($OBJ,ueo_help_url)
   if { [string match "" $udeEditor::($OBJ,ueo_help_descript)] && \
   [string match "" $udeEditor::($OBJ,ueo_help_url)] } \
   {
    set udeEditor::($OBJ,exist_ueo_help_descript) 0
   } else \
   {
    set udeEditor::($OBJ,exist_ueo_help_descript) 1
   }
  }
  set main [toplevel $udeEditor::(main_widget).param]
  bind all <Enter> ""
  set udeEditor::($OBJ,drag_drop_enabled)  0
  bind $main <Destroy> \
  "+ set udeEditor::($OBJ,drag_drop_enabled) 1;\
  $w config -bg $udeEditor::($OBJ,title_bg);\
  $w config -relief flat"
  set rootx [winfo rootx $udeEditor::(main_widget)]
  set rooty [winfo rooty $udeEditor::(main_widget)]
  set x [expr {$rootx - 10 }]
  set y [expr {$rooty + 10}]
  set geom +${x}+${y}
  wm resizable $main 1 1
  UI_PB_com_CreateTransientWindow $main $gPB(udc,editor,EDIT) \
  $geom "" "" "" ""
  focus $main
  wm protocol $main WM_DELETE_WINDOW \
  "UI_PB_ude_DeleteWindow $main"
  set topframe [frame $main.top -bd 1 -relief sunken]
  set bottomframe [frame $main.bottom]
  set f_type [frame $topframe.type]
  if 0 {
   set f_type_f [UI_PB_com_AddSeparator $topframe.typef]
  }
  set f1 [frame $topframe.1]
  set f1_f [UI_PB_com_AddSeparator $topframe.1f]
  set f2 [frame $topframe.2]
  if 0 {
   set type_l [label $f_type.l -text "$gPB(udc,editor,TYPE) :" -font $gPB(bold_font)]
   set type_v [label $f_type.v -fg blue4]
   if {$udeEditor::($OBJ,temp_ueo_type) == "UDC"} {
    $type_v config -text $gPB(udc,editor,type,UDC)
    } else {
    $type_v config -text $gPB(udc,editor,type,SYSUDC)
   }
  }
  set name_l [label $f1.l -text $gPB(udc,editor,CYCNAME,Label) -font $gPB(bold_font)]
  set name_e [entry $f1.e -width 28 \
  -textvariable udeEditor::($OBJ,temp_ueo_name)]
  bind $name_e <KeyPress>      " UI_PB_com_DisableSpecialChars %W %K"
  bind $name_e <KeyPress>      "+UI_PB_com_RestrictStringLength %W %K"
  bind $name_e <Control-Key-v> " UI_PB_com_Validate_Control_V %W %K %A"
  bind $name_e <KeyRelease>    "+UI_PB_com_Validate_Control_V_Release %W"
  set lbl_tf [frame $f2.tf]
  set lbl_l [label $lbl_tf.l -text $gPB(udc,editor,CYCLBL,Label) -font $gPB(bold_font)]
  set lbl_e [entry $f2.e -width 12 \
  -textvariable udeEditor::($OBJ,temp_ueo_ui_label)]
  set lbl_c [checkbutton $lbl_tf.c \
  -variable udeEditor::($OBJ,exist_ueo_ui_label) \
  -command "UI_PB_ude_ShiftState \
  udeEditor::($OBJ,exist_ueo_ui_label) $lbl_e"]
  set gPB(c_help,$name_e) "udc,editor,CYCNAME"
  set gPB(c_help,$lbl_e)  "udc,editor,CYCLBL"
  set gPB(c_help,$lbl_c)  "udc,editor,CYCLBL,C"
  if { $gPB(enable_helpdesc_for_udc) && \
   [string match "UDC" $udeEditor::($OBJ,temp_ueo_type)] } {
   set fa1 [frame $topframe.a1]
   set fa1_f [UI_PB_com_AddSeparator $topframe.a1f]
   set discript_state disabled
   set url_state disabled
   if { $udeEditor::($OBJ,exist_ueo_help_descript) == 1 } {
    set discript_state normal
    set url_state normal
   }
   set help_tf [frame $fa1.tf]
   set help_topl [label $help_tf.l -text $gPB(ude,editor,eventdlg,DESC,Label) -font $gPB(bold_font)]
   set help_tope [entry $fa1.te -textvariable udeEditor::($OBJ,temp_ueo_help_descript) \
   -state $discript_state -width 12]
   set help_bf [frame $fa1.bf]
   set help_btml [label $help_bf.l -text $gPB(ude,editor,eventdlg,URL,Label) -font $gPB(bold_font)]
   set help_btme [entry $fa1.be -textvariable udeEditor::($OBJ,temp_ueo_help_url) \
   -state $url_state -width 12]
   set help_topc [checkbutton $help_tf.c \
   -variable udeEditor::($OBJ,exist_ueo_help_descript) \
   -command "UI_PB_ude_DisplayUdeHelpWidgets 1; UI_PB_ude_ShiftState \
   udeEditor::($OBJ,exist_ueo_help_descript) $help_tope $help_btme"]
   set gPB(c_help,$help_tope) "ude,editor,eventdlg,DESC"
   set gPB(c_help,$help_btme) "ude,editor,eventdlg,URL"
  }
  set name_list {"gPB(nav_button,ok,Label)" "gPB(nav_button,cancel,Label)"}
  set cb_arr(gPB(nav_button,ok,Label)) ""
  set cb_arr(gPB(nav_button,cancel,Label)) ""
  UI_PB_com_CreateButtonBox $bottomframe name_list cb_arr
  ${bottomframe}.box.act_0 config  \
  -command "UI_PB_cycle_EditCycleEvent_OK $main"
  ${bottomframe}.box.act_1 config  \
  -command "UI_PB_cycle_EditCycleEvent_CNL $main"
  if 0 {
   if ![string compare $::tix_version 8.4] {
    pack $bottomframe -side bottom  -fill x -pady 2 -padx 2
    pack $f_type -side top  -fill x -expand no \
    -padx 5 -pady 10
    pack $f_type $f_type_f $f1 $f1_f $f2 -fill x -expand no \
    -padx 5
    } else {
    pack $bottomframe -side bottom  -fill x -pady 3 -padx 2
    pack $f_type -side top  -fill x -expand no \
    -padx 2 -pady 10
    pack $f_type $f_type_f $f1 $f1_f $f2 -fill x -expand no \
    -padx 2
   }
  }
  if ![string compare $::tix_version 8.4] {
   pack $bottomframe -side bottom  -fill x -pady 2 -padx 2
   if { $gPB(enable_helpdesc_for_udc) && \
    [string match "UDC" $udeEditor::($OBJ,temp_ueo_type)] } {
    pack $f1 $f1_f $f2 $fa1_f $fa1 -fill x -expand no -padx 5
    } else {
    pack $f1 $f1_f $f2 -fill x -expand no -padx 5
   }
   } else {
   pack $bottomframe -side bottom  -fill x -pady 3 -padx 2
   if { $gPB(enable_helpdesc_for_udc) && \
    [string match "UDC" $udeEditor::($OBJ,temp_ueo_type)] } {
    pack $f1 $f1_f $f2 $fa1_f $fa1 -fill x -expand no -padx 2
    } else {
    pack $f1 $f1_f $f2 -fill x -expand no -padx 2
   }
  }
  pack $topframe -side top  -fill both -expand yes -pady 5 -padx 2
  if 0 {
   pack $type_l -side left -padx 0
   pack $type_v -side right -padx 5
  }
  pack $lbl_c $lbl_l -side left
  pack $lbl_tf -side top -fill both
  pack $lbl_e -fill x -padx 5 -pady 10
  pack $name_l -side top -anchor w -pady 5
  pack $name_e -fill x -pady 10 -padx 5
  if {$udeEditor::($OBJ,temp_ueo_type) == "UDC"} {
   if $gPB(enable_helpdesc_for_udc) \
   {
    pack $help_topc $help_topl -side left
    pack $help_tf -side top -fill x
    pack $help_tope -fill x -pady 10 -padx 5
    pack $help_btml -side left
    pack $help_bf -side top -fill x
    pack $help_btme -fill x -pady 10 -padx 5
    UI_PB_ude_DisplayUdeHelpWidgets 1
   }
   $lbl_c config -state normal
   $name_e config -state normal
   if {$udeEditor::($OBJ,exist_ueo_ui_label) == 0} {
    if ![string compare $::tix_version 8.4] {
     $lbl_e config -state disabled
     } else {
     $lbl_e config -state disabled -bg lightblue
    }
   }
   } else {
   $lbl_c config -state disabled
   $name_e config -state disabled
   set udeEditor::($OBJ,exist_ueo_ui_label) 0
   if ![string compare $::tix_version 8.4] {
    $lbl_e config -state disabled
    } else {
    $lbl_e config -state disabled -bg lightblue
   }
  }
 }

#=======================================================================
proc UI_PB_cycle_EditCycleEvent_OK {w} {
  global gPB post_object
  tk_focusFollowsMouse
  set OBJ $udeEditor::(obj)
  set cur_ude_event_obj $udeEditor::(ude_event_obj)
  set udeobj $Post::($post_object,ude_obj)
  if {$udeEditor::($OBJ,temp_ueo_type) == "UDC"} {
   set cycle_name $udeEditor::($OBJ,temp_ueo_name)
   set name_trimed [string trim $cycle_name]
   if ![string compare $name_trimed ""] {
    tk_messageBox -message $gPB(udc,editor,popup,MSG_BLANK) -icon error \
    -title $gPB(msg,error) -parent [UI_PB_com_AskActiveWindow]
    return
   }
   set cyc_evt_obj_list $ude::($udeobj,cyc_evt_obj_list)
   foreach cyc_evt $cyc_evt_obj_list {
    if {$cyc_evt != $cur_ude_event_obj} {
     if ![string compare $cycle_name $cycle_event::($cyc_evt,name)] {
      if {[lsearch $gPB(SYS_CYCLE) $cycle_name] == "-1"} {
       tk_messageBox -message $gPB(udc,editor,popup,MSG_SAMENAME) -icon error \
       -title $gPB(msg,error) -parent [UI_PB_com_AskActiveWindow]
       return
       } else {
       tk_messageBox -message $gPB(udc,editor,popup,MSG_ISSYSCYC) -icon error \
       -title $gPB(msg,error) -parent [UI_PB_com_AskActiveWindow]
       return
      }
     }
    }
   }
   if {[lsearch $gPB(SYS_CYCLE) $cycle_name] != "-1"} {
    tk_messageBox -message $gPB(udc,editor,popup,MSG_ISSYSCYC) -icon error \
    -title $gPB(msg,error) -parent [UI_PB_com_AskActiveWindow]
    return
   }
   set handler_name MOM_${name_trimed}
   if {[lsearch $gPB(MOM_func,SYS) $handler_name] >= 0 || \
    [lsearch $gPB(MOM_func,SYS) ${handler_name}_move] >= 0} {
    tk_messageBox -message "$handler_name : $gPB(udc,editor,popup,MSG_SameHandler)" \
    -icon error \
    -title $gPB(msg,error) -parent [UI_PB_com_AskActiveWindow]
    return
   }
  }
  if $gPB(enable_helpdesc_for_udc) \
  {
   set is_validate $udeEditor::($OBJ,exist_ueo_help_descript)
   set str_desc $udeEditor::($OBJ,temp_ueo_help_descript)
   set str_url $udeEditor::($OBJ,temp_ueo_help_url)
   if { [UI_PB_ude_ValidateDescAndUrlWidgets $is_validate $str_desc $str_url] } \
   {
    return
   }
  }
  destroy $w
  if {$udeEditor::($OBJ,temp_ueo_type) == "SYSCYC"} {
   return
   } else {
   set udeEditor::($OBJ,ueo_name) $udeEditor::($OBJ,temp_ueo_name)
   set udeEditor::($OBJ,ueo_is_sys_cycle) 0
   set udeEditor::($OBJ,ueo_type) "UDC"
   set cycle_event::($cur_ude_event_obj,prev_exist_ueo_ui_label) \
   $udeEditor::($OBJ,exist_ueo_ui_label)
   set cycle_event::($cur_ude_event_obj,prev_temp_ueo_ui_label) \
   $udeEditor::($OBJ,temp_ueo_ui_label)
   if {$udeEditor::($OBJ,exist_ueo_ui_label) == 1} {
    set udeEditor::($OBJ,ueo_ui_label) $udeEditor::($OBJ,temp_ueo_ui_label)
    } else {
    set udeEditor::($OBJ,ueo_ui_label) ""
    set udeEditor::($OBJ,temp_ueo_ui_label) ""
   }
   if {$udeEditor::($OBJ,ueo_ui_label) == ""} {
    set udeEditor::($OBJ,label_text) $udeEditor::($OBJ,ueo_name)
    } else {
    set udeEditor::($OBJ,label_text) $udeEditor::($OBJ,ueo_ui_label)
   }
   if $gPB(enable_helpdesc_for_udc) \
   {
    if {$udeEditor::($OBJ,exist_ueo_help_descript) == 1} {
     set udeEditor::($OBJ,ueo_help_descript)   \
     $udeEditor::($OBJ,temp_ueo_help_descript)
     set udeEditor::($OBJ,ueo_help_url)   \
     $udeEditor::($OBJ,temp_ueo_help_url)
     } else {
     set udeEditor::($OBJ,ueo_help_descript) ""
     set udeEditor::($OBJ,temp_ueo_help_descript) ""
     set udeEditor::($OBJ,ueo_help_url) ""
     set udeEditor::($OBJ,temp_ueo_help_url) ""
    }
    UI_PB_ude_DisplayUdeHelpWidgets
   }
  }
 }

#=======================================================================
proc UI_PB_cycle_EditCycleEvent_CNL {w} {
  destroy $w
  tk_focusFollowsMouse
  UI_PB_ude_DisplayUdeHelpWidgets
 }

#=======================================================================
proc UI_PB_cycle_MakeCopyFromCommonParam { obj } {
  global post_object
  set cyc_seq_obj ""
  foreach seq $Post::($post_object,seq_obj_list) {
   if { $sequence::($seq,seq_name) == "Cycles" } {
    set cyc_seq_obj $seq
   }
  }
  if { $cyc_seq_obj == "" } {
   return
  }
  set com_evt_obj [lindex $sequence::($cyc_seq_obj,evt_obj_list) 0]
  set evt_elem_list $event::($com_evt_obj,evt_elem_list)
  set cyc_evt_obj $event::($obj,cyc_evt_obj)
  set new_evt_elem_obj_list [list]
  set blk_name [join [split [string tolower $cycle_event::($cyc_evt_obj,name)]] "_"]
  foreach evt_elem_obj $evt_elem_list {
   set blk_obj $event_element::($evt_elem_obj,block_obj)
   set block_type $block::($blk_obj,blk_type)
   switch $block_type {
    "command" {
     set cmd_blk_elem [lindex $block::($blk_obj,elem_addr_list) 0]
     set cmd_obj $block_element::($cmd_blk_elem,elem_mom_variable)
     if { [string match "MOM_*" $cmd_obj] } {
      set cmd_name $cmd_obj
      } else {
      set cmd_name $command::($cmd_obj,name)
     }
     if { [info exists ::mom_sys_arr(post_startblk)] &&\
      [string match "$::mom_sys_arr(post_startblk)" $cmd_name] } {
      continue
     }
     PB_int_CreateCmdBlkElem cmd_name cmd_blk_elem
     PB_int_CreateCmdBlock   cmd_name cmd_blk_elem new_blk_obj
     set block::($new_blk_obj,blk_type) "command"
    }
    "comment" {
     set cmd_blk_elem [lindex $block::($blk_obj,elem_addr_list) 0]
     set elem_name "$::gPB(comment_blk)"
     if [string match "$::gPB(tcl_line_blk)*" $block::($blk_obj,block_name)] {
      set elem_name "$::gPB(tcl_line_blk)"
     }
     PB_int_CreateCommentBlkElem elem_name blk_elem_obj
     set block_element::($blk_elem_obj,elem_mom_variable) \
     $block_element::($cmd_blk_elem,elem_mom_variable)
     PB_int_CreateCommentBlk elem_name blk_elem_obj new_blk_obj
     set block::($new_blk_obj,blk_type) "comment"
    }
    "macro"   {
     if [string match "just_mcall_sinumerik" $block::($blk_obj,block_name)] \
     {
      continue
     }
     set func_blk_elem  [lindex $block::($blk_obj,elem_addr_list) 0]
     set func_obj $block_element::($func_blk_elem,elem_mom_variable)
     set func_name $function::($func_obj,id)
     PB_int_CreateFuncBlkElem func_name new_blk_elem
     PB_int_CreateFuncBlk func_name new_blk_elem new_blk_obj
     if [info exists block_element::($func_blk_elem,func_prefix)] \
     {
      set block_element::($new_blk_elem,func_prefix) \
      $block_element::($func_blk_elem,func_prefix)
     }
     if [info exists block_element::($func_blk_elem,func_suppress_flag)] \
     {
      set block_element::($new_blk_elem,func_suppress_flag) \
      $block_element::($func_blk_elem,func_suppress_flag)
     }
     set block::($new_blk_obj,blk_type) "macro"
    }
    default   {
     PB_int_CreateCopyABlock blk_obj new_blk_obj
     set blk_obj_list $Post::($post_object,blk_obj_list)
     if [string match "$blk_name*" $block::($blk_obj,block_name)] {
      set new_blk_name $block::($blk_obj,block_name)
      } else {
      set new_blk_name [PB_com_GetNextObjName $blk_name block]
     }
     set block::($new_blk_obj,block_name) $new_blk_name
     set block::($new_blk_obj,blk_type) "normal"
    }
   }
   set block::($new_blk_obj,blk_owner) "$cycle_event::($cyc_evt_obj,name)"
   set blk_elem_obj_list $block::($new_blk_obj,elem_addr_list)
   foreach blk_elem_obj $blk_elem_obj_list {
    set block_element::($blk_elem_obj,owner) "$cycle_event::($cyc_evt_obj,name)"
    set block_element::($blk_elem_obj,parent_name) "$block::($new_blk_obj,block_name)"
   }
   PB_int_CreateNewEventElement new_blk_obj new_evt_elem_obj
   event_element::readvalue $new_evt_elem_obj obj_attr
   event_element::DefaultValue $new_evt_elem_obj obj_attr
   lappend new_evt_elem_obj_list $new_evt_elem_obj
   set block::($new_blk_obj,active_blk_elem_list) $blk_elem_obj_list
   block::RestoreValue $new_blk_obj
   block::readvalue $new_blk_obj obj_attr
   block::DefaultValue $new_blk_obj obj_attr
  }
  set event::($obj,evt_elem_list) $new_evt_elem_obj_list
 }

#=======================================================================
proc UI_PB_ude_DefaultCallBack_For_Seq {PAGE_OBJ SEQ_INDEX} {
  upvar $PAGE_OBJ page_obj
  upvar $SEQ_INDEX seq_index
  set seq_obj [lindex $Page::($page_obj,seq_obj_list) $seq_index]
  if {$seq_index == 2} {
   set index 2
   } elseif {$seq_index == 4} {
   set index 2.2
  }
  UI_PB_evt_DeleteObjectsPrevSeq page_obj
  UI_PB_evt_SetSequenceObjAttr seq_obj
  set Page::($page_obj,prev_seq) $index
  array set default_attr $sequence::($seq_obj,def_value)
  sequence::setvalue $seq_obj default_attr
  UI_PB_evt_CreateSeqAttributes page_obj
  $Page::($page_obj,bot_canvas) yview moveto 0
  $Page::($page_obj,bot_canvas) xview moveto 0
 }

#=======================================================================
proc UI_PB_ude_RestoreCallBack_For_Seq {PAGE_OBJ SEQ_INDEX} {
  upvar $PAGE_OBJ page_obj
  upvar $SEQ_INDEX seq_index
  set seq_obj [lindex $Page::($page_obj,seq_obj_list) $seq_index]
  if {$seq_index == 2} {
   set index 2
   } elseif {$seq_index == 4} {
   set index 2.2
  }
  UI_PB_evt_DeleteObjectsPrevSeq page_obj
  UI_PB_evt_SetSequenceObjAttr seq_obj
  set Page::($page_obj,prev_seq) $index
  array set rest_attr $sequence::($seq_obj,rest_value)
  sequence::setvalue $seq_obj rest_attr
  UI_PB_evt_CreateSeqAttributes page_obj
  $Page::($page_obj,bot_canvas) yview moveto 0
  $Page::($page_obj,bot_canvas) xview moveto 0
 }

#=======================================================================
proc UI_PB_ude_GetUdeEventObjFrmEvtName {evt_name} {
  global post_object
  set seq_name_list {"Machine Control" "Cycles"}
  foreach seq_name $seq_name_list \
  {
   set seq_obj [PB_com_FindObjFrmName $seq_name sequence]
   if { $seq_obj <= 0 } \
   {
    continue
   }
   foreach evt_obj $sequence::($seq_obj,evt_obj_list) \
   {
    if { [string compare $event::($evt_obj,event_name) $evt_name] == 0 } \
    {
     if [info exists event::($evt_obj,event_ude_name)] \
     {
      return [UI_PB_ude_GetUdeEventObj $evt_obj]
     } else \
     {
      return NULL
     }
    }
   } ;# end foreach evt_obj
  } ;# end foreach seq_name
  return NULL
 }

#=======================================================================
proc UI_PB_ude_OpenUrl { } {
  return
  global gPB env tcl_platform
  set OBJ $udeEditor::(obj)
  set doc_file $udeEditor::($OBJ,ueo_help_url)
  if { [llength [info commands "UI_PB_execute"]] == 0 } \
  {
   return
  }
  if { [string match "unix" $tcl_platform(platform)] } \
  {
   if { [string match "Darwin" $tcl_platform(os)] } {
    catch { UI_PB_execute "open $doc_file" }
    return
   }
   if { ![info exists gPB(unix_netscape)] } {
    set gPB(unix_netscape) "netscape"
   }
   set browser $gPB(unix_netscape)
   if [info exists result] { unset result }
   set nav_win_found -1 ;# -1 Browser not open
   ;#  0 Browser open with no navigator
   ;#  1 Browser open with navigator
   ;#  2 Browser already displayed manual
   if { $gPB(help_win_id) == 0 } \
   {
    if [catch { set result [exec xwininfo -root -tree | grep -i $browser | grep -i navigator | grep -i "post builder"] }] {
     catch { set result [exec xlswins | grep -i $browser | grep -i navigator | grep -i "post builder"] }
    }
    if [info exists result] \
    {
     set nav_win_found 2
    }
   }
   if { $gPB(help_win_id) == 0 } \
   {
    if [catch { set result [exec xwininfo -root -tree | grep -i $browser | grep -i navigator] }] {
     catch { set result [exec xlswins | grep -i $browser | grep -i navigator] }
    }
    if [info exists result] \
    {
     set nav_win_found 1
    }
   }
   if [info exists result] \
   {
    set result [join [split $result "\""] ""]
    set gPB(help_win_id) [lindex $result 0]
    set win(ID) $gPB(help_win_id)
    } elseif { $gPB(help_win_id) != 0 } \
   {
    if [catch { exec xwininfo -id $gPB(help_win_id) }] \
    {
     set gPB(help_win_id) 0
    } else \
    {
     set win(ID) $gPB(help_win_id)
     set nav_win_found 2
    }
   }
   set html_doc_file_1 ""
   switch -- $nav_win_found \
   {
    2  -
    1  {
     if [string match "*mozilla*" $browser] {
      set html_doc_file   "$browser $win(ID) -remote 'openFile($doc_file)'"
      set html_doc_file_1 "$browser $win(ID) -remote 'openURL(javascript:window.focus())'"
      } else {
      set html_doc_file "$browser $win(ID) -raise \
      -remote 'openFile($doc_file)'"
     }
    }
    0  {
     set html_doc_file "$browser -raise \
     -remote 'openFile($doc_file)'"
    }
    -1 {
     set html_doc_file "$browser $doc_file &"
    }
   }
   if { [UI_PB_execute $html_doc_file] == 0 } \
   {
    return ;# Hunky-Dori
   } else \
   {
    if { $browser != "netscape" } \
    {
     set html_doc_file_1 ""
     set browser "netscape"
     set gPB(unix_netscape) $browser
     set html_doc_file "$browser $doc_file &"
     if { [UI_PB_execute $html_doc_file] == 0 } \
     {
      return ;# ok
     } else \
     {
      return [tk_messageBox -parent [UI_PB_com_AskActiveWindow] -type ok \
      -icon error -message "$gPB(msg,invalid_browser_cmd) $html_doc_file"]
     }
    } else \
    {
     return [tk_messageBox -parent [UI_PB_com_AskActiveWindow] -type ok \
     -icon error -message "$gPB(msg,invalid_browser_cmd) $browser"]
    }
   }
   if { [string length $html_doc_file_1] > 0 } {
    catch { UI_PB_execute $html_doc_file_1 }
   }
   } elseif { $tcl_platform(platform) == "windows" } \
  {
   regsub -all {/} $doc_file {\\\\} html_doc_file
   if [catch { UI_PB_execute $html_doc_file } res] {
    tk_messageBox -parent [UI_PB_com_AskActiveWindow] -type ok \
    -icon error -message "$res"
   }
  } else \
  {
   return
  }
 }
