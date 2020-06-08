#21

#=======================================================================
proc UI_PB_com_SetStatusbar { message } {
  global gPB
  set gPB(menu_bar_status) "$message"
 }

#=======================================================================
proc UI_PB_com_SetWindowTitle { } {
  global gPB
  PB_int_ReadPostOutputFiles cur_dir pui_file def_file tcl_file
  set file_name [file tail $pui_file]
  set dot_index [string last . $file_name]
  if { $dot_index != -1 } \
  {
   set file_name [string range $file_name 0 [expr $dot_index - 1]]
  }
  set display_text [file join $cur_dir $file_name]
  wm title $gPB(main_window) "$display_text"
 }

#=======================================================================
proc UI_PB_com_CreateActionElems { win CB_ARR } {
  upvar $CB_ARR cb_arr
  set box1_frm [frame $win.box1]
  set box2_frm [frame $win.box2]
  tixForm $box1_frm -top 0 -left 1 -right %50 -padright 20
  tixForm $box2_frm -top 0 -left $box1_frm -padx 1 -right %100
  set label_list1 { "gPB(nav_button,default,Label)" \
  "gPB(nav_button,restore,Label)" }
  UI_PB_com_CreateButtonBox $box1_frm label_list1 cb_arr
  set label_list2 { "gPB(nav_button,cancel,Label)" \
  "gPB(nav_button,ok,Label)" }
  UI_PB_com_CreateButtonBox $box2_frm label_list2 cb_arr
 }

#=======================================================================
proc UI_PB_com_SortLabelList { LABEL_LIST } {
  upvar $LABEL_LIST label_list
  global gPB
  set master_order $gPB(nav_button,order)
  set no_elements [llength $label_list]
  for {set ii 0} {$ii < [expr $no_elements - 1]} {incr ii} \
  {
   for {set jj [expr $ii + 1]} {$jj < $no_elements} {incr jj} \
   {
    set label_ii [lindex $label_list $ii]
    set label_ii_index [lsearch $master_order $label_ii]
    set label_jj [lindex $label_list $jj]
    set label_jj_index [lsearch $master_order $label_jj]
    if {$label_jj_index < $label_ii_index} \
    {
     set label_list [lreplace $label_list $ii $ii $label_jj]
     set label_list [lreplace $label_list $jj $jj $label_ii]
    }
   }
  }
 }

#=======================================================================
proc UI_PB_com_CreateButtonBox { win LABLE_LIST CB_ARR } {
  upvar $LABLE_LIST lable_list
  upvar $CB_ARR cb_arr
  global paOption
  global gPB
  set box [tixButtonBox $win.box -orientation horizontal \
  -bd 2 -relief sunken -bg $paOption(butt_bg)]
  UI_PB_com_SortLabelList lable_list
  for { set count 0 } { $count < [llength $lable_list] } { incr count } \
  {
   set label [lindex $lable_list $count]
   set call_back $cb_arr($label)
   set text_label [string trim $label "gPB"]
   set text_label [string range $text_label 1 \
   [expr [string length $text_label] - 2]]
   $box add act_$count -text $gPB($text_label) -width 10 \
   -bg $paOption(app_butt_bg)  -command "$call_back"
   set context_but [$box subwidget act_$count]
   set context_label [lindex [split $text_label ,] 1]
   set gPB(c_help,$context_but)     "nav_button,$context_label"
  }
  pack $box -side bottom -fill x
 }

#=======================================================================
proc UI_PB_com_DisableTree { h b flag } {
  global paOption
  for {set t 0} {$t < [llength $b]} {incr t} \
  {
   set c [lindex $b $t]
   $h entryconfig $c -state disabled
   if { $flag == "GRAY" && \
   $c != [lindex [$h info selection] 0] } \
   {
    set sty [lindex [$h entryconfig $c -style] end]
    $sty config -fg $paOption(tree_disabled_fg)
    $h entryconfig $c -style $sty
   }
   set blist [$h info children $c]
   if { [llength $blist] != 0 } \
   {
    UI_PB_com_DisableTree $h $blist $flag
   }
  }
 }

#=======================================================================
proc UI_PB_com_EnableTree { h b } {
  global paOption
  for {set t 0} {$t < [llength $b]} {incr t} \
  {
   set c [lindex $b $t]
   $h entryconfig $c -state normal
   set sty [lindex [$h entryconfig $c -style] end]
   $sty config -fg black
   $h entryconfig $c -style $sty
   set blist [$h info children $c]
   if { [llength $blist] != 0 } \
   {
    UI_PB_com_EnableTree $h $blist
   }
  }
 }

#=======================================================================
proc UI_PB_com_CreateTransientWindow { w title geom construct_cb \
  win_close_cb pre_destroy_cb args } {
  global gPB
  set geom                   [string trim $geom           " "]
  set construct_cb  [string trim $construct_cb " "]
  set win_close_cb           [string trim $win_close_cb   " "]
  set pre_destroy_cb         [string trim $pre_destroy_cb " "]
  set pw [winfo parent $w]
  if { $pw == "" } \
  {
   return [tk_messageBox -parent [UI_PB_com_AskActiveWindow] \
   -type ok -icon error \
   -message "$gPB(msg,parent_win)"]
  } else \
  {
   wm transient $w $pw
  }
  wm withdraw $w
  wm title $w $title
  if { $win_close_cb != "" } {
   wm protocol $w WM_DELETE_WINDOW "$win_close_cb"
  }
  if { $pre_destroy_cb != "" } {
   bind $w <Destroy> "$pre_destroy_cb"
  }
  bind $w <Destroy> "+UI_PB_com_DismissActiveWindow $w"
  bind $w <Destroy> "+UI_PB_com_DeleteFromTopLevelList $w"
  set gPB(prev_window_grab) [grab current]
  if { $geom != "" } {
   wm geometry $w $geom
   } else {
   set aw [UI_PB_com_AskActiveWindow]
   set xc [expr [winfo rootx $aw] + 20]
   set yc [expr [winfo rooty $aw] - 60]
   wm geometry $w +$xc+$yc
  }
  wm deiconify $w
  focus $w
  UI_PB_com_ClaimActiveWindow $w
  if {[llength $args] == 0} {
   UI_PB_com_DisableMainWindow
   } else {
   if { [lindex $args 0] != 0 } {
    UI_PB_com_DisableMainWindow
   }
  }
  if { $construct_cb != "" } \
  {
   eval $construct_cb
  }
  UI_PB_com_AddToTopLevelList $w
 }

#=======================================================================
proc UI_PB_com_AddToTopLevelList { w args } {
  global gPB
  if { $w != "$gPB(top_window).new"  && \
   $w != "$gPB(top_window).open" && \
   [lsearch $gPB(toplevel_list) $w] < 0 } {
   set gPB(toplevel_list) [linsert $gPB(toplevel_list) end $w]
  }
 }

#=======================================================================
proc UI_PB_com_DeleteFromTopLevelList { w args } {
  global gPB
  set wi [lsearch $gPB(toplevel_list) $w]
  if { $wi >= 0 } {
   set gPB(toplevel_list) [lreplace $gPB(toplevel_list) $wi $wi]
  }
 }

#=======================================================================
proc UI_PB_com_DeleteTopLevelWindows { args } {
  global gPB
  set w [lindex $gPB(toplevel_list) end]
  while { $w != "" } {
   wm withdraw    $w
   destroy     $w
   set w [lindex $gPB(toplevel_list) end]
  }
  set gPB(toplevel_list) {}
  set gPB(main_window) ""
  unset gPB(book)
 }

#=======================================================================
proc UI_PB_com_ClaimActiveWindow { win args } {
  global gPB
  set wi [lsearch -exact $gPB(active_window_list) $win]
  if { $wi < 0 } {
   set gPB(active_window_list) [linsert $gPB(active_window_list) end $win]
   } elseif { $wi == [expr [llength $gPB(active_window_list)] - 1] } {
   } else {
   set gPB(active_window_list) [lreplace $gPB(active_window_list) $wi $wi]
   set gPB(active_window_list) [linsert  $gPB(active_window_list) end $win]
  }
  set gPB(active_window) $win
 }

#=======================================================================
proc UI_PB_com_AskActiveWindow { args } {
  global gPB
  if { $gPB(active_window) == 0 || $gPB(active_window) == "" } {
   return $gPB(top_window)
   } else {
   return $gPB(active_window)
  }
 }

#=======================================================================
proc UI_PB_com_DisableMainWindow { args } {
  global gPB
  global paOption tixOption
  global machTree machData
  if { ![info exists gPB(book)] } {
   return
  }
  if { $gPB(main_window_disabled) == 0 && \
   $gPB(active_window) != $gPB(main_window) && \
  $gPB(active_window) != $gPB(top_window) } \
  {
   set gPB(main_window_disabled) 1
   set pb_book_id $Book::($gPB(book),book_id)
   set gPB(pb_book_b1_cb) [bind [$pb_book_id subwidget nbframe] <1>]
   bind [$pb_book_id subwidget nbframe] <1>  UI_PB_com_disabledTabMsg
   set page_list [$pb_book_id pages]
   foreach p $page_list {
    $pb_book_id pageconfig $p -state disabled
   }
   set pb_book_page_list $Book::($gPB(book),page_obj_list)
   set current_book_tab $Book::($gPB(book),current_tab)
   set chap    [lindex $pb_book_page_list $current_book_tab]
   if { $current_book_tab == 1 || \
    $current_book_tab == 2 || \
    $current_book_tab == 4 } {
    set sect    $Page::($chap,book_obj)
    set sect_id $Book::($sect,book_id)
    set page_tab $Book::($sect,current_tab)
    set page_obj [lindex $Book::($sect,page_obj_list) $page_tab]
   }
   switch $current_book_tab \
   {
    0 { 
     UI_PB_mach_DisableWindow chap
    }
    1 { 
     UI_PB_prog_DisableWindow chap
    }
    2 { 
     UI_PB_def_DisableWindow chap
    }
    3 { 
    }
    4 { 
     set gPB($sect_id,b1_cb) [bind [$sect_id subwidget nbframe] <1>]
     bind [$sect_id subwidget nbframe] <1>  UI_PB_com_disabledTabMsg
     $sect_id pageconfig eve -state disabled
     $sect_id pageconfig def -state disabled
     set t $Page::($page_obj,tree)
     set h [$t subwidget hlist]
     switch $page_tab \
     {
      0 {  
      }
      1 {  
      }
     }
    }
    5 { 
    }
   }
  }
 }

#=======================================================================
proc UI_PB_com_disabledTabMsg {  } {
  global gPB
  if { !$gPB(use_info) } \
  {
   tk_messageBox -parent [UI_PB_com_AskActiveWindow] -type ok -icon error \
   -message "$gPB(msg,close_subwin)"
  }
 }

#=======================================================================
proc UI_PB_com_EnableMainWindow { args } {
  global gPB
  if { [llength $gPB(toplevel_list)] > 1 } {
   return
  }
  if { $gPB(main_window_disabled) } \
  {
   set pb_book_id $Book::($gPB(book),book_id)
   bind [$pb_book_id subwidget nbframe] <1> $gPB(pb_book_b1_cb)
   set page_list [$pb_book_id pages]
   foreach p $page_list {
    $pb_book_id pageconfig $p -state normal
   }
   set pb_book_page_list $Book::($gPB(book),page_obj_list)
   set current_book_tab $Book::($gPB(book),current_tab)
   set chap    [lindex $pb_book_page_list $current_book_tab]
   set gPB(main_window_disabled) 0
   if { $current_book_tab == 1 || \
    $current_book_tab == 2 || \
    $current_book_tab == 4 } {
    set sect    $Page::($chap,book_obj)
    set sect_id $Book::($sect,book_id)
    bind [$sect_id subwidget nbframe] <1> $gPB($sect_id,b1_cb)
   }
   switch $current_book_tab \
   {
    0 { 
     UI_PB_mach_EnableWindow chap
    }
    1 { 
     UI_PB_prog_EnableWindow chap
    }
    2 { 
     UI_PB_def_EnableWindow chap
    }
    3 { 
    }
    4 { 
     $sect_id pageconfig eve -state normal
     $sect_id pageconfig def -state normal
    }
    5 { 
    }
   }
  }
 }

#=======================================================================
proc UI_PB_com_DismissActiveWindow { win args } {
  global gPB
  if { $win != $gPB(top_window) } {
   set wi [lsearch $gPB(active_window_list) $win]
   if { $wi > -1 } {
    set gPB(active_window_list) [lreplace $gPB(active_window_list) $wi $wi]
    set gPB(active_window) [lindex $gPB(active_window_list) end]
   }
   set cwg [grab current]
   if { $cwg != $win } {
    grab release $cwg
    if { $gPB(prev_window_grab) != "" && \
     [winfo exists $gPB(prev_window_grab)] } {
     grab $gPB(prev_window_grab)
    }
   }
  }
  UI_PB_com_EnableMainWindow
  focus [UI_PB_com_AskActiveWindow]
 }

#=======================================================================
proc UI_PB_com_RetImageAppdText { ADDR_OBJ ELEM_MOM_VAR IMG_NAME \
  WORD_APP_TEXT} {
  upvar $ADDR_OBJ addr_obj
  upvar $ELEM_MOM_VAR elem_mom_var
  upvar $IMG_NAME image_name
  upvar $WORD_APP_TEXT word_app_text
  global mom_sys_arr
  if { $addr_obj == "Command" } \
  {
   if { [string match "*MOM_*" $elem_mom_var] } \
   {
    set WORD_LEADER $elem_mom_var
   } else \
   {
    set WORD_LEADER $command::($elem_mom_var,name)
   }
   set word_app_text ""
   } elseif { $addr_obj == "Comment" } \
  {
   set WORD_LEADER ""
   if { $mom_sys_arr(Comment_Start) != "" } \
   {
    append temp_text "$mom_sys_arr(Comment_Start)"
   }
   append temp_text "$elem_mom_var"
   if { $mom_sys_arr(Comment_End) != "" } \
   {
    append temp_text "$mom_sys_arr(Comment_End)"
   }
   set word_app_text $temp_text
   unset temp_text
  } else \
  {
   set WORD_LEADER $address::($addr_obj,add_leader)
   set WORD_LEADER [string trim $WORD_LEADER]
   PB_com_MapMOMVariable mom_sys_arr addr_obj elem_mom_var word_app_text
   PB_int_ApplyFormatAppText addr_obj word_app_text
  }
  set leader_len [string length $WORD_LEADER]
  if { $leader_len > 1} \
  {
   set no_chars 5
   set image_name "blank"
   append temp_app_text $WORD_LEADER $word_app_text
   UI_PB_com_TrimOrFillAppText temp_app_text no_chars
   set word_app_text $temp_app_text
   unset temp_app_text
   } elseif { $leader_len == 0} \
  {
   set no_chars 5
   set image_name "blank"
   UI_PB_com_TrimOrFillAppText word_app_text no_chars
  } else \
  {
   set no_chars 3
   set image_name $WORD_LEADER
   UI_PB_com_TrimOrFillAppText word_app_text no_chars
  }
  append temp_image_name "pb_" $image_name "_addr"
  set image_name $temp_image_name
  unset temp_image_name
 }

#=======================================================================
proc UI_PB_blk_CreateIcon { canvas bitmap label } {
  global tixOption
  set comp [image create compound -window $canvas \
  -bd 1 \
  -background #c0c0ff \
  -borderwidth 2 \
  -relief raised \
  -showbackground 1]
  set image_addr [tix getimage $bitmap]
  $comp add image -image $image_addr
  $comp add text -text $label -font $tixOption(fixed_font_sm) -anchor w
  return $comp
 }

#=======================================================================
proc UI_PB_com_TrimOrFillAppText { APP_TEXT NO_CHARS } {
  upvar $APP_TEXT app_text
  upvar $NO_CHARS no_chars
  set app_text_len [string length $app_text]
  if {$app_text_len < $no_chars}\
  {
   append temp_var $app_text
   for {set x $app_text_len} {$x < $no_chars} {incr x}\
   {
    append temp_var " "
   }
   set app_text $temp_var
   unset temp_var
   } elseif {$app_text_len > $no_chars}\
  {
   set app_text [string range $app_text 0 [expr $no_chars - 1]]
  }
 }

#=======================================================================
proc UI_PB_com_ChangeCursor { canvas_id } {
  global tcl_platform
  if {$tcl_platform(platform) == "unix"} \
  {
   global env
   set cur "$env(PB_HOME)/images/pb_hand.xbm"
   set msk "$env(PB_HOME)/images/pb_hand.mask"
   $canvas_id config -cursor "@$cur $msk black white"
  }
 }

#=======================================================================
proc UI_PB_com_FormatString { string } {
  global tixOption
  set actual_width [font measure $tixOption(font) $string]
  set blank_width [font measure $tixOption(font) " "]
  set font_width 100
  if {$font_width > $actual_width} \
  {
   set diff_width [expr $font_width - $actual_width]
   set no_of_blanks [expr $diff_width / $blank_width]
   for {set count 0} {$count < $no_of_blanks} {incr count} \
   {
    append string " "
   }
  }
  return $string
 }

#=======================================================================
proc UI_PB_com_ReturnBlockName { EVENT_OBJ BLOCK_NAME } {
  upvar $EVENT_OBJ event_obj
  upvar $BLOCK_NAME block_name
  set event_name $event::($event_obj,event_name)
  set temp_event_name [split $event_name]
  set event_name [join $temp_event_name _ ]
  set event_name [string tolower $event_name]
  set obj_attr(0) $event_name
  PB_int_RetBlkObjList blk_obj_list
  PB_int_GetAllBlockNames blk_obj_list blk_name_list
  PB_com_SetDefaultName blk_name_list obj_attr
  set block_name $obj_attr(0)
 }

#=======================================================================
proc UI_PB_com_TrunkNcCode { BLK_NC_CODE } {
  upvar $BLK_NC_CODE blk_nc_code
  global tixOption
  set font $tixOption(font_sm)
  set nc_width [font measure $font $blk_nc_code]
  set blank_width [font measure $font " "]
  set act_width 145
  set new_nc_code $blk_nc_code
  if {$act_width >= $nc_width} \
  {
   set diff_width [expr $act_width - $nc_width]
   set no_of_blanks [expr $diff_width / $blank_width]
   for {set count 0} {$count < $no_of_blanks} {incr count} \
   {
    append new_nc_code " "
   }
  } else \
  {
   set no_of_chars [string length $new_nc_code]
   set ii [expr $no_of_chars - 2]
   while { $nc_width >= 136 } \
   {
    set new_nc_code [string range $blk_nc_code 0 $ii]
    set nc_width [font measure $font $new_nc_code]
    incr ii -1
   }
   append new_nc_code ...
  }
  set blk_nc_code $new_nc_code
 }

#=======================================================================
proc UI_PB_com_CreateBlkNcCode { BLK_ELEM_OBJ_LIST BLK_NC_CODE} {
  upvar $BLK_ELEM_OBJ_LIST blk_elem_obj_list
  upvar $BLK_NC_CODE blk_nc_code
  global mom_sys_arr
  set blk_nc_code ""
  foreach blk_elem $blk_elem_obj_list\
  {
   set add_obj $block_element::($blk_elem,elem_add_obj)
   set add_leader $address::($add_obj,add_leader)
   set blk_elem_mom_var $block_element::($blk_elem,elem_mom_variable)
   PB_com_MapMOMVariable mom_sys_arr add_obj blk_elem_mom_var app_text
   PB_int_ApplyFormatAppText add_obj app_text
   append app_image_name "$add_leader"
   append app_image_name "$app_text"
   append blk_nc_code "$app_image_name"
   append blk_nc_code "$mom_sys_arr(Word_Seperator)"
   unset app_image_name
  }
 }

#=======================================================================
proc UI_PB_com_RetActiveBlkElems { BLK_ELEM_OBJ_LIST } {
  upvar $BLK_ELEM_OBJ_LIST blk_elem_obj_list
  foreach blk_elem_obj $blk_elem_obj_list \
  {
   set add_obj $block_element::($blk_elem_obj,elem_add_obj)
   if { $address::($add_obj,word_status) == 0} \
   {
    lappend temp_blk_elem_list $blk_elem_obj
   }
  }
  if {[info exists temp_blk_elem_list]}\
  {
   set blk_elem_obj_list $temp_blk_elem_list
   unset temp_blk_elem_list
  } else \
  {
   set blk_elem_obj_list ""
  }
 }

#=======================================================================
proc UI_PB_com_RetTextPosAttr {BLK_ELEM_OBJ_LIST TEXT_LDTR_ARR} {
  upvar $BLK_ELEM_OBJ_LIST blk_elem_obj_list
  upvar $TEXT_LDTR_ARR text_ldtr_arr
  set index 0
  foreach blk_elem_obj $blk_elem_obj_list \
  {
   set add_obj $block_element::($blk_elem_obj,elem_add_obj)
   if {[string compare $address::($add_obj,add_name) "Text"] == 0} \
   {
    if { $index == 0} \
    {
     set text_ldtr_arr($blk_elem_obj,leading) ""
    } else \
    {
     set text_ldtr_arr($blk_elem_obj,leading) \
     [lindex $blk_elem_obj_list [expr $index - 1]]
    }
    if { [llength $blk_elem_obj_list] == [expr $index + 1] } \
    {
     set text_ldtr_arr($blk_elem_obj,trailing) ""
    } else \
    {
     set text_ldtr_arr($blk_elem_obj,trailing) \
     [lindex $blk_elem_obj_list [expr $index + 1]]
    }
   }
   incr index
  }
 }

#=======================================================================
proc UI_PB_com_SeperateTextElements {BLK_ELEM_OBJ_LIST TEXT_ELEM_LIST} {
  upvar $BLK_ELEM_OBJ_LIST blk_elem_obj_list
  upvar $TEXT_ELEM_LIST text_elem_list
  set no_elems [llength $blk_elem_obj_list]
  for {set count 0} {$count < $no_elems} {incr count} \
  {
   set blk_elem_obj [lindex $blk_elem_obj_list $count]
   set add_obj $block_element::($blk_elem_obj,elem_add_obj)
   if {[string compare $address::($add_obj,add_name) "Text"] != 0} \
   {
    lappend temp_blk_elem_list $blk_elem_obj
   } else \
   {
    lappend text_elem_list $blk_elem_obj
   }
  }
  if {[info exists temp_blk_elem_list]} \
  {
   set blk_elem_obj_list $temp_blk_elem_list
  } else \
  {
   set blk_elem_obj_list ""
  }
 }

#=======================================================================
proc UI_PB_com_AddTextElements { BLK_ELEM_OBJ_LIST TEXT_ELEM_LIST  \
  TEXT_LDTR_ARR } {
  upvar $BLK_ELEM_OBJ_LIST blk_elem_obj_list
  upvar $TEXT_ELEM_LIST text_elem_list
  upvar $TEXT_LDTR_ARR text_ldtr_arr
  if {[info exists text_ldtr_arr]} \
  {
   foreach text_obj $text_elem_list \
   {
    set leading_obj $text_ldtr_arr($text_obj,leading)
    set trailing_obj $text_ldtr_arr($text_obj,trailing)
    if {$leading_obj != ""} \
    {
     set lead_res [lsearch $blk_elem_obj_list $leading_obj]
     if {$lead_res != -1} \
     {
      set blk_elem_obj_list [linsert $blk_elem_obj_list \
      [expr $lead_res + 1] $text_obj]
     }
    } else \
    {
     if {$trailing_obj != ""} \
     {
      set trail_res [lsearch $blk_elem_obj_list $trailing_obj]
      if {$trail_res != -1} \
      {
       set blk_elem_obj_list [linsert $blk_elem_obj_list \
       $trail_res $text_obj]
      } else \
      {
       set blk_elem_obj_list [linsert $blk_elem_obj_list 0 $text_obj]
      }
     } else \
     {
      set blk_elem_obj_list [linsert $blk_elem_obj_list 0 $text_obj]
     }
    }
   }
  }
 }

#=======================================================================
proc UI_PB_com_SortBlockElements {BLK_ELEM_OBJ_LIST} {
  upvar $BLK_ELEM_OBJ_LIST blk_elem_obj_list
  UI_PB_com_RetTextPosAttr blk_elem_obj_list text_ldtr_arr
  UI_PB_com_SeperateTextElements blk_elem_obj_list text_elem_list
  set no_elements [llength $blk_elem_obj_list]
  for {set ii 0} {$ii < [expr $no_elements - 1]} {incr ii} \
  {
   for {set jj [expr $ii + 1]} {$jj < $no_elements} {incr jj} \
   {
    set blk_ii_obj [lindex $blk_elem_obj_list $ii]
    set add_ii_obj $block_element::($blk_ii_obj,elem_add_obj)
    set add_ii_index $address::($add_ii_obj,seq_no)
    set blk_jj_obj [lindex $blk_elem_obj_list $jj]
    set add_jj_obj $block_element::($blk_jj_obj,elem_add_obj)
    set add_jj_index $address::($add_jj_obj,seq_no)
    if {$add_jj_index < $add_ii_index} \
    {
     set blk_elem_obj_list [lreplace $blk_elem_obj_list $ii $ii \
     $blk_jj_obj]
     set blk_elem_obj_list [lreplace $blk_elem_obj_list $jj $jj \
     $blk_ii_obj]
    }
   }
  }
  UI_PB_com_AddTextElements blk_elem_obj_list text_elem_list \
  text_ldtr_arr
 }

#=======================================================================
proc UI_PB_com_ApplyMastSeqBlockElem { BLK_ELEM_OBJ_LIST } {
  upvar $BLK_ELEM_OBJ_LIST blk_elem_obj_list
  UI_PB_com_RetActiveBlkElems blk_elem_obj_list
  UI_PB_com_SortBlockElements blk_elem_obj_list
 }

#=======================================================================
proc UI_PB_com_ReturnEventNcOutAttr { EVENT_OBJ EVT_NC_WIDTH \
  EVT_NC_HEIGHT EVT_NC_OUTPUT} {
  upvar $EVENT_OBJ event_obj
  upvar $EVT_NC_WIDTH evt_nc_width
  upvar $EVT_NC_HEIGHT evt_nc_height
  upvar $EVT_NC_OUTPUT evt_nc_output
  global tixOption
  global mom_sys_arr
  set evt_nc_width 0
  set evt_nc_height 0
  set font $tixOption(font_sm)
  foreach row_elem_obj $event::($event_obj,evt_elem_list) \
  {
   foreach elem_obj $row_elem_obj \
   {
    set block_obj $event_element::($elem_obj,block_obj)
    if { $block::($block_obj,blk_type) == "command" } \
    {
     set cmd_blk_elem [lindex $block::($block_obj,elem_addr_list) 0]
     set cmd_obj $block_element::($cmd_blk_elem,elem_mom_variable)
     if { [string match "*MOM_*" $cmd_obj] } \
     {
      set cmd_name $cmd_obj
     } else \
     {
      set cmd_name $command::($cmd_obj,name)
     }
     set blk_nc_width [font measure $font \
     $cmd_name]
     set evt_nc_height [expr $evt_nc_height + \
     [font metrics $font -linespace]]
     append temp_evt_nc_output $cmd_name "\n"
     if {$blk_nc_width > $evt_nc_width} \
     {
      set evt_nc_width $blk_nc_width
     }
     } elseif { $block::($block_obj,blk_type) == "comment" } \
    {
     set blk_elem [lindex $block::($block_obj,elem_addr_list) 0]
     append comm_data "$mom_sys_arr(Comment_Start)"
     append comm_data $block_element::($blk_elem,elem_mom_variable)
     append comm_data "$mom_sys_arr(Comment_End)"
     set blk_nc_width [font measure $font \
     $comm_data]
     set evt_nc_height [expr $evt_nc_height + \
     [font metrics $font -linespace]]
     append temp_evt_nc_output $comm_data "\n"
     unset comm_data
     if {$blk_nc_width > $evt_nc_width} \
     {
      set evt_nc_width $blk_nc_width
     }
    } else \
    {
     foreach blk_elem $block::($block_obj,elem_addr_list) \
     {
      lappend row_blk_elem_list $blk_elem
     }
    }
   }
   if {[info exists row_blk_elem_list]} \
   {
    UI_PB_com_ApplyMastSeqBlockElem row_blk_elem_list
    if {[info exist row_blk_nc_output]} \
    {
     unset row_blk_nc_output
    }
    UI_PB_com_CreateBlkNcCode row_blk_elem_list row_blk_nc_output
    if {[info exists row_blk_elem_list]} \
    {
     unset row_blk_elem_list
    }
    if {[info exists row_blk_nc_output]} \
    {
     set blk_nc_width [font measure $font \
     $row_blk_nc_output]
     set evt_nc_height [expr $evt_nc_height + \
     [font metrics $font -linespace]]
     if {$blk_nc_width > $evt_nc_width} \
     {
      set evt_nc_width $blk_nc_width
     }
     append temp_evt_nc_output $row_blk_nc_output "\n"
     unset row_blk_nc_output
    }
   }
  }
  if {[info exists temp_evt_nc_output]} \
  {
   set evt_nc_output $temp_evt_nc_output
   unset temp_evt_nc_output
  }
 }

#=======================================================================
proc UI_PB_com_CreateRectangle  { canvas x1 y1 x2 y2 \
  fill_color outline_color} {
  set cell_box_width 0
  set rect_id [$canvas create rect \
  $x1 $y1 $x2 $y2 -outline $outline_color \
  -width $cell_box_width -fill $fill_color -tag stationary]
  return $rect_id
 }

#=======================================================================
proc CB_nb_def {w tab_img book_obj} {
  if {$Book::($book_obj,x_def_tab_img) != 0} \
  {
   $Book::($book_obj,x_def_tab_img) config -showbackground 0
  }
  $tab_img config -showbackground 1
  set Book::($book_obj,x_def_tab_img) $tab_img
 }

#=======================================================================
proc UI_PB_com_CreateRowAttr { column_frm row_no label mom_var data_type } {
  global tixOption
  global mom_sys_arr
  set row_frm [frame $column_frm.$row_no]
  set bgc lightSkyBlue
  $row_frm config -relief solid -bd 1 -bg $bgc
  pack $row_frm -side top -fill x -expand yes
  Page::CreateLblEntry $data_type $mom_var $row_frm int $label
  $row_frm.int config -bg $bgc -font $tixOption(bold_font)
 }

#=======================================================================
proc UI_PB_com_CheckElemBlkTemplate { BLOCK_OBJ NEW_BLK_ELEM_OBJ } {
  upvar $BLOCK_OBJ block_obj
  upvar $NEW_BLK_ELEM_OBJ new_blk_elem_obj
  if { $block_element::($new_blk_elem_obj,elem_add_obj) == "Command" } \
  {
   set new_blk_elem_addr $block_element::($new_blk_elem_obj,elem_add_obj)
   set new_elem_add_leader ""
  } else \
  {
   set blk_elem_add_obj $block_element::($new_blk_elem_obj,elem_add_obj)
   set new_blk_elem_addr $address::($blk_elem_add_obj,add_name)
   set new_elem_add_leader $address::($blk_elem_add_obj,add_leader)
  }
  if { [string compare $new_blk_elem_addr "Text"] == 0 || \
  [string compare $new_blk_elem_addr "Command"] == 0 } \
  {
   return 0
  }
  set blk_elem_flag 0
  set add_flag [UI_PB_com_CheckAddressInBlk block_obj new_blk_elem_addr]
  if { $add_flag } { return 1 }
  if { $new_elem_add_leader == "G" } \
  {
  }
  if { $new_elem_add_leader == "M" } \
  {
  }
  return 0
 }

#=======================================================================
proc UI_PB_com_CheckAddressInBlk { BLOCK_OBJ NEW_BLK_ELEM_ADDR } {
  upvar $BLOCK_OBJ block_obj
  upvar $NEW_BLK_ELEM_ADDR new_blk_elem_addr
  global gPB
  if { $block::($block_obj,active_blk_elem_list) != ""} \
  {
   PB_int_GetBlockElementAddr new_blk_elem_addr base_addr_list
   foreach blk_elem_obj $block::($block_obj,active_blk_elem_list) \
   {
    set blk_elem_addr_obj $block_element::($blk_elem_obj,elem_add_obj)
    set blk_elem_addr $address::($blk_elem_addr_obj,add_name)
    foreach address_name $base_addr_list \
    {
     if {[string compare $address_name $blk_elem_addr] == 0} \
     {
      set blk_elem_flag 1
      tk_messageBox -parent [UI_PB_com_AskActiveWindow] \
      -type ok -icon error -message "$gPB(msg,block_exist)"
      return 1
     }
    }
   }
  }
  return 0
 }

#=======================================================================
proc UI_PB_com_CheckNumOfGcodes { BLOCK_OBJ } {
  upvar $BLOCK_OBJ block_obj
  set no_gc_blk 0
  if { $block::($block_obj,active_blk_elem_list) != "" } \
  {
   foreach blk_elem_obj $block::($block_obj,active_blk_elem_list) \
   {
    set blk_elem_addr_obj $block_element::($blk_elem_obj,elem_add_obj)
    address::readvalue $blk_elem_addr_obj add_obj_attr
    if { $add_obj_attr(8) == "G" } \
    {
     incr no_gc_blk
    }
    unset add_obj_attr
   }
  }
  global mom_sys_arr
  if { $no_gc_blk >= $mom_sys_arr(\$mom_sys_gcodes_per_block) } \
  {
   tk_messageBox -parent [UI_PB_com_AskActiveWindow] -type ok -icon error \
   -message " No of G - Codes are restricted to \
   $mom_sys_arr(\$mom_sys_gcodes_per_block) per block"
   return 1
  } else \
  {
   return 0
  }
 }

#=======================================================================
proc UI_PB_com_CheckNumOfMCodes { BLOCK_OBJ } {
  upvar $BLOCK_OBJ block_obj
  set no_gc_blk 0
  if { $block::($block_obj,active_blk_elem_list) != "" } \
  {
   foreach blk_elem_obj $block::($block_obj,active_blk_elem_list) \
   {
    set blk_elem_addr_obj $block_element::($blk_elem_obj,elem_add_obj)
    address::readvalue $blk_elem_addr_obj add_obj_attr
    if { $add_obj_attr(8) == "M" } \
    {
     incr no_gc_blk
    }
    unset add_obj_attr
   }
  }
  global mom_sys_arr
  if { $no_gc_blk >= $mom_sys_arr(\$mom_sys_mcodes_per_block) } \
  {
   tk_messageBox -parent [UI_PB_com_AskActiveWindow] -type ok -icon error \
   -message " No of M - Codes are restricted to \
   $mom_sys_arr(\$mom_sys_mcodes_per_block) per block"
   return 1
  } else \
  {
   return 0
  }
 }

#=======================================================================
proc UI_PB_com_CreateTextEntry { PAGE_OBJ NEW_ELEM_OBJ label_name} {
  upvar $PAGE_OBJ page_obj
  upvar $NEW_ELEM_OBJ new_elem_obj
  global paOption
  global elem_text_var
  global text_dial_respose
  global gPB
  set text_dial_respose 0
  set bot_canvas $Page::($page_obj,bot_canvas)
  set elem_text_var $block_element::($new_elem_obj,elem_mom_variable)
  set win [toplevel $bot_canvas.txtent]
  set toplevel_index [llength $gPB(toplevel_list)]
  set win_index [expr $toplevel_index + 1]
  set gPB(toplevel_disable_$win_index) 1
  UI_PB_com_CreateTransientWindow $win \
  "$label_name $gPB(com,text_entry_trans,title,Label)" "" \
  "UI_PB_blk_DisableBlkPageWidgets $page_obj" "" \
  "UI_PB_blk_ActivateBlkPageWidgets $page_obj $win_index"
  set text_frm [frame $win.frame]
  pack $text_frm -side top -fill both -expand yes
  set label_list {"gPB(nav_button,cancel,Label)" \
  "gPB(nav_button,ok,Label)"}
  set cb_arr(gPB(nav_button,cancel,Label)) \
  "UI_PB_com_CancelTextElem $win $page_obj $new_elem_obj"
  set cb_arr(gPB(nav_button,ok,Label)) \
  "UI_PB_com_UpdateTextElem $win $page_obj $new_elem_obj"
  UI_PB_com_CreateButtonBox $win label_list cb_arr
  label $text_frm.lab -text $label_name -anchor w
  entry $text_frm.ent -textvariable elem_text_var -width 40 -relief sunken
  pack $text_frm.lab -side left -fill both -padx 10 -pady 10
  pack $text_frm.ent -side right -fill both -padx 10 -pady 10
  focus $text_frm.ent
  $text_frm.ent select range 0 end
  bind $text_frm.ent <Return> "UI_PB_com_UpdateTextElem $win $page_obj \
  $new_elem_obj"
 }

#=======================================================================
proc UI_PB_com_CancelTextElem { win page_obj elem_obj } {
  global text_dial_respose
  if { $text_dial_respose == 0 } \
  {
   set block_element::($elem_obj,elem_mom_variable) "000"
   set text_dial_respose "cancel"
  }
  destroy $win
 }

#=======================================================================
proc UI_PB_com_UpdateTextElem { win page_obj elem_obj } {
  global elem_text_var
  global text_dial_respose
  global gPB
  set elem_text_var [string trim $elem_text_var]
  if { $elem_text_var == "" } \
  {
   tk_messageBox -parent [UI_PB_com_AskActiveWindow] -type ok -icon error \
   -message "$gPB(msg,empty_entry)"
   return
  }
  set block_element::($elem_obj,elem_mom_variable) $elem_text_var
  set text_dial_respose "ok"
  destroy $win
 }

#=======================================================================
proc UI_PB_com_RetIntFromVal { value } {
  set int_val [tixGetInt -nocomplain $value]
  if { $int_val } \
  {
   return $int_val
  } else \
  {
   return 0
  }
 }

#=======================================================================
proc UI_PB_com_RetFloatFromVal { value } {
  set int_val [tixGetInt -nocomplain $value]
  if { $int_val } \
  {
   if { [string first "." $value] } \
   {
    return $value
   } else \
   {
    return $int_val
   }
  } else \
  {
   return 0.0
  }
 }

#=======================================================================
proc UI_PB_com_RetValByDataType { value data_type } {
  switch $data_type \
  {
   "i"  {
    set int_val [UI_PB_com_RetIntFromVal $value]
    return $int_val
   }
   "f"  {
    set float_val [UI_PB_com_RetFloatFromVal $value]
    return $float_val
   }
   "s"  {
    return $value
   }
  }
 }

#=======================================================================
proc UI_PB_com_RetAddrOfMOMSysVar { MOM_VAR } {
  upvar $MOM_VAR mom_var
  PB_adr_RetAddressObjList add_obj_list
  set mom_var_add 0
  foreach add_obj $add_obj_list \
  {
   address::readvalue $add_obj add_obj_attr
   PB_int_RetMOMVarAsscAddress add_obj_attr(0) add_mom_var_list
   if { [lsearch $add_mom_var_list $mom_var] != -1 } \
   {
    set mom_var_add $add_obj
    break
   }
  }
  return $mom_var_add
 }

#=======================================================================
proc UI_PB_com_RetSysVarDataType { MOM_VAR } {
  upvar $MOM_VAR mom_var
  set add_obj [UI_PB_com_RetAddrOfMOMSysVar mom_var]
  if { $add_obj } \
  {
   address::readvalue $add_obj add_obj_attr
   format::readvalue $add_obj_attr(1) fmt_obj_attr
   switch $fmt_obj_attr(1) \
   {
    "Numeral"     {
     if { $fmt_obj_attr(6) } \
     {
      set data_type f
     } else \
     {
      set data_type i
     }
    }
    "Text String" {
     set data_type s
    }
   }
  } else \
  {
   set data_type s
  }
  return $data_type
 }

#=======================================================================
proc UI_PB_com_CheckDuplicatChar { widget key_type } {
  set entry_val [$widget get]
  switch $key_type \
  {
   "plus"   {
    if { [$widget select present] } \
    {
     set sel_f [$widget index sel.first]
     set sel_s [$widget index sel.last]
     if { $sel_f == 0 || $sel_s == 0} \
     {
      return 1
     }
     } elseif { [$widget index insert] == 0 && \
     [string first "+" $entry_val] == -1 &&
    [string first "-" $entry_val] == -1} \
    {
     return 1
    } else \
    {
     return 0
    }
   }
   "minus"  {
    if { [$widget select present] } \
    {
     set sel_f [$widget index sel.first]
     set sel_s [$widget index sel.last]
     if { $sel_f == 0 || $sel_s == 0} \
     {
      return 1
     }
     } elseif { [$widget index insert] == 0 && \
     [string first "+" $entry_val] == -1 &&
    [string first "-" $entry_val] == -1} \
    {
     return 1
    } else \
    {
     return 0
    }
   }
   "period" {
    set flag [string first "." $entry_val]
    if {$flag != -1} \
    {
     return 0
    } else \
    {
     return 1
    }
   }
   default {
    return 1
   }
  }
 }

#=======================================================================
proc UI_PB_com_DisableSpaceKey { widget key } {
  if { $key == "space" } \
  {
   $widget config -state disabled
  }
 }

#=======================================================================
proc UI_PB_com_ValidateDataOfEntry { widget key data_type } {
  set disable_flag 0
  switch $data_type \
  {
   "i" {
    if { $key >= 0 && $key <= 9 || $key == "plus" || \
     $key  == "minus" || $key == "BackSpace" || \
    $key == "Tab" || $key == "Shift_R"} \
    {
     set disable_flag [UI_PB_com_CheckDuplicatChar $widget $key]
    }
   }
   "f" {
    if { $key >= 0 && $key <= 9 || $key == "period" || \
     $key == "plus" || $key  == "minus" || \
    $key == "BackSpace" || $key == "Tab" || $key == "Shift_R"} \
    {
     set disable_flag [UI_PB_com_CheckDuplicatChar $widget $key]
    }
   }
   "s" {
    set disable_flag 1
   }
  }
  if { !$disable_flag } \
  {
   $widget config -state disabled
  }
 }
