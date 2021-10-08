#12

#=======================================================================
proc UI_PB_com_GetDisplayStyle { obj } {
  if [PB_com_object_is_external $obj] {
   set style $::gPB(font_style_normal_external)
   } else {
   set style $::gPB(font_style_normal)
  }
  return $style
 }

#=======================================================================
proc UI_PB_com_AddSeparator { w } {
  if { [string match "windows" $::tcl_platform(platform)] } {
   set rlf groove
   } else {
   set rlf sunken
  }
  return [frame $w -bd 1 -height 2 -relief $rlf]
 }

#=======================================================================
proc UI_PB_com_DisableMain { args } {
  global gPB
  global paOption tixOption
  global machTree machData
  if { ![info exists gPB(book)] } {
   return 0
  }
  if { $gPB(active_window) != $gPB(top_window) } \
  {
   set top_win $gPB(top_window)
   set act_win $gPB(active_window)
   set cur_win ""
   set this_idx [expr [llength $gPB(active_window_list)] - 2]
   if { $this_idx >= 0 } \
   {
    set this_win [lindex $gPB(active_window_list) $this_idx]
   } else \
   {
    return 0
   }
   if {$this_win == "$top_win"} { set this_win $act_win}
   if { [info exists gPB(disabled_window_list)]  && \
   [llength $gPB(disabled_window_list)] } \
   {
    set last_win [lindex $gPB(disabled_window_list) end]
    if { $this_win == "$last_win" } \
    {
     return 1
    }
   }
   if [info exists gPB(disabled_window_list)] \
   {
    set index [lsearch $gPB(disabled_window_list) $this_win]
    if { $index > -1 } \
    {
     return 1
    }
   } else \
   {
    set gPB(disabled_window_list) [list]
   }
   if { ![winfo exists $this_win] } {
    return 1
   }
   lappend gPB(disabled_window_list) $this_win
   UI_PB_com_DisableWindow $this_win
  }
  return 1
 }

#=======================================================================
proc UI_PB_com_GetCurrentPageId { } {
  global gPB
  set current_tab $Book::($gPB(book),current_tab)
  set page_obj [lindex $Book::($gPB(book),page_obj_list) $current_tab]
  if { [info exist ::env(SUB_POST_MODE)] && $::env(SUB_POST_MODE) == 1 } \
  {
   if { [info exists ::env(UNIT_SUB_POST_MODE)] && $::env(UNIT_SUB_POST_MODE) == 1 } {
    set page_id $Page::($page_obj,page_id)
    return $page_id
   }
  }
  if { $current_tab != 0 } {
   set book_obj $Page::($page_obj,book_obj)
   set sub_page_obj [lindex $Book::($book_obj,page_obj_list) $Book::($book_obj,current_tab)]
   if { $sub_page_obj == "" } { return }
  }
  switch -exact $current_tab {
   0 {
    set page_id $Page::($page_obj,page_id)
   }
   1 {
    set book_obj $Page::($page_obj,book_obj)
    set sub_page_obj [lindex $Book::($book_obj,page_obj_list) $Book::($book_obj,current_tab)]
    set page_id $Page::($sub_page_obj,page_id)
   }
   2 {
    set book_obj $Page::($page_obj,book_obj)
    set sub_page_obj [lindex $Book::($book_obj,page_obj_list) $Book::($book_obj,current_tab)]
    set page_id $Page::($sub_page_obj,page_id)
   }
   3 {
    set book_obj $Page::($page_obj,book_obj)
    set sub_cur_tab $Book::($book_obj,current_tab)
    set sub_page_obj $Book::($book_obj,page_obj_list)
    set p_obj [lindex $sub_page_obj $sub_cur_tab]
    if { $p_obj == "" } { return }
    switch -exact $sub_cur_tab {
     0 {
      set p_obj [lindex $sub_page_obj $sub_cur_tab]
      set page_id $Page::($p_obj,page_id)
     }
     1 {
      set p_obj [lindex $sub_page_obj $sub_cur_tab]
      set page_id $Page::($p_obj,page_id)
     }
     2 {
      set p_obj [lindex $sub_page_obj $sub_cur_tab]
      set book_obj $Page::($p_obj,book_obj)
      set sub_sub_page_obj [lindex $Book::($book_obj,page_obj_list) $Book::($book_obj,current_tab)]
      if { $sub_sub_page_obj == "" } { return }
      set page_id $Page::($sub_sub_page_obj,page_id)
     }
    }
   }
   4 {
    set book_obj $Page::($page_obj,book_obj)
    set nlvl [expr [info level] - 1]
    for { set lvl $nlvl } { $lvl > 0 } { incr lvl -1 } { ;# Search from top to bottom for efficiency ;-).
     UI_PB_debug_DisplayMsg "\n++ Call stack -$lvl : >[info level -$lvl]\n" no_debug
     set caller_found 0
     foreach caller { UI_PB_chelp_SetContextHelp \
      UI_PB_com_CreateTransientWindow \
      UI_PB_com_DismissActiveWindow \
      _cmd_ImportCustCmdFile \
      _cmd_ExportCustCmdFile } {
      if { [string match "$caller" [lindex [info level -$lvl] 0]] } {
       UI_PB_debug_DisplayMsg "\n++ Caller -$lvl : >[info level -$lvl]\n" no_debug
       set sub_page_obj [lindex $Book::($book_obj,page_obj_list) $Book::($book_obj,current_tab)]
       set page_id $Page::($sub_page_obj,page_id)
       set caller_found 1
       break
      }
     }
     if { $caller_found } {
      break
     }
    }
    if 0 {
     if { [string match "__turn_on_CSH" $caller] || [string match "__turn_off_CSH" $caller] } {
      set sub_page_obj [lindex $Book::($book_obj,page_obj_list) $Book::($book_obj,current_tab)]
      set page_id $Page::($sub_page_obj,page_id)
     }
    }
    lappend page_id [winfo parent $Book::($book_obj,book_id)].top
   }
  }
  return $page_id
 }

#=======================================================================
proc UI_PB_com_GetWidgetsToSwitchState { } {
  set p_wins [UI_PB_com_GetCurrentPageId]
  set w_list [list]
  foreach one $p_wins {
   set w_list [concat $w_list [tixDescendants $one]]
  }
  return $w_list
 }

#=======================================================================
proc UI_PB_com_DisableWindow { this_win args } {
  global gPB
  if { [info exists gPB(main_window)] && [winfo exists $gPB(main_window)] } {
   if { [string match $this_win $gPB(main_window)] } {
    set wlist [UI_PB_com_GetWidgetsToSwitchState]
    if { $wlist == "" } {
     return
    }
    set this_win [lindex $wlist 0]
    set book_ids [array names Book:: *book_id]
    foreach one $book_ids {
     lappend wlist $Book::($one)
    }
    } else {
    set wlist [tixDescendants $this_win]
   }
   } else {
   set wlist [tixDescendants $this_win]
  }
  if { ![string match "Toplevel" [winfo class $this_win]] } {
   set this_win [winfo toplevel $this_win]
  }
  for { set j 0 } { $j < [llength $wlist] } { incr j } \
  {
   set witem [lindex $wlist $j]
   if { $witem == "$gPB(help_tool)" } \
   { continue }
   set wclass [winfo class $witem]
   if 0 {
    if { [string match "Toplevel" [winfo class $this_win]] } {
     if { $wclass == "Toplevel" } {
      set cur_win $witem
     }
     if { [info exists cur_win] && $cur_win != "$this_win" } { unset cur_win; continue }
     set tlw [winfo toplevel $witem]
     if { $tlw != "$this_win" } { continue }
    }
   }
   set tlw [winfo toplevel $witem]
   if { [string compare $tlw $this_win] } { continue }
   switch -exact -- $wclass \
   {
    Label {
     continue
    }
    Scrollbar {
     continue
    }
    Entry {
     set gPB(sens,<Key>,$witem)        [bind $witem <Key>]
     set gPB(sens,<KeyRelease>,$witem) [bind $witem <KeyRelease>]
     bind $witem <Key> " "
     bind $witem <KeyRelease> " "
    }
    TixHList {
     if 0 {
      catch {
       if [$witem info exists .] {
        } elseif [$witem info exists 0] {
        UI_PB_com_DisableTree $witem [$witem info children 0] GRAY
       }
       if [llength [$witem info children]] {
        UI_PB_com_DisableTree $witem [$witem info children] GRAY
       }
      }
     }
     UI_PB_com_DisableTree $witem [$witem info children] GRAY
     set gPB(sens,browse_cmd,$witem) [lindex [$witem config -browsecmd] end]
     $witem config -browsecmd ""
    }
    TixNoteBook {
     set plist [$witem pages]
     foreach p $plist \
     {
      set sta [$witem pageconfig $p -state]
      set gPB(sens,state,$witem._$p) [lindex $sta end]
      $witem pageconfig $p -state disabled
     }
     continue
    }
    TixNoteBookFrame {
    }
    TixButtonBox {
     continue
    }
    TixControl {
     continue
    }
    TixOptionMenu {
     continue
    }
    TixComboBox {
     if { [llength $args]  &&  [string match "ADDRESS" [lindex $args 0]] } {
      } else {
      continue
     }
     [$witem subwidget arrow] config -state disabled
    }
    TixFileSelectDialog {
     continue
    }
    TixFileSelectBox {
     continue
    }
    TixStdButtonBox {
     continue
    }
    TixScrolledListBox {
     continue
    }
    TixScrolledHList {
     continue
    }
    TixScrolledText {
     continue
    }
    TixLabelEntry {
     continue
    }
    Ctext {
     continue
    }
    Menubutton {
    }
    TixPanedWindow { ;#<03-06-06 pheobe> add case of TixPanedWindow and TixTree
     continue
    }
    TixTree {
     continue
    }
    Canvas {
     set tl {}
     set tlist [$witem find withtag all]
     for {set t 0} {$t < [llength $tlist]} {incr t} \
     {
      set tg [$witem gettags [lindex $tlist $t]]
      if { [lsearch -exact $tl $tg] < 0 && $tg != {} } {
       set tl [linsert $tl end $tg]
      }
     }
     set gPB(sens,tags,$witem) $tl
     for {set t 0} {$t < [llength $tl]} {incr t} \
     {
      set bi [lindex $tl $t]
      set bl [$witem bind $bi]
      for {set b 0} {$b < [llength $bl]} {incr b} \
      {
       set seq [lindex $bl $b]
       set cb  [$witem bind $bi $seq]
       set gPB(sens,$seq,$witem,$bi) "$cb"
       $witem bind $bi $seq " "
      }
     }
    } ;# Canvas
   } ;# switch of widget classes
   if { ![catch {set sta [$witem config -state]} result] } \
   {
    set st [lindex $sta end]
    set gPB(sens,state,$witem) $st
    $witem config -state disabled
   }
   if { ![catch {set cmd [$witem config -command]} result] } \
   {
    set gPB(sens,cmd,$witem) [lindex $cmd end]
    $witem config -command ""
   }
   if { ![catch {set fg [$witem config -fg]} result] } \
   {
    set fgclr [lindex $fg end]
    set gPB(sens,fg,$witem) $fgclr
   }
   set gPB(sens,<Button-1>,$witem)        [bind $witem <Button-1>]
   set gPB(sens,<ButtonRelease-1>,$witem) [bind $witem <ButtonRelease-1>]
   set gPB(sens,<Button-3>,$witem)        [bind $witem <Button-3>]
   set gPB(sens,<ButtonRelease-3>,$witem) [bind $witem <ButtonRelease-3>]
   bind $witem <Button-1>        ""
   bind $witem <ButtonRelease-1> ""
   bind $witem <Button-3>        ""
   bind $witem <ButtonRelease-3> ""
  } ;# for each widget item
 }

#=======================================================================
proc UI_PB_com_EnableMain { args } {
  global gPB
  if { ![info exists gPB(disabled_window_list)]  ||  ![llength $gPB(disabled_window_list)] } \
  {
   return 0
  }
  set top_win $gPB(top_window)
  set act_win $gPB(active_window)
  set cur_win ""
  set this_win $act_win
  if { $this_win == "$top_win" } { set this_win $act_win}
  if { $this_win != "$top_win" } \
  {
   if { ![winfo exists $this_win] } {
    return 1
   }
   set last_win [lindex $gPB(disabled_window_list) end]
   if { $this_win != "$last_win" } \
   {
    return 0
   } else \
   {
    set gPB(disabled_window_list) [lreplace $gPB(disabled_window_list) end end]
   }
   UI_PB_com_EnableWindow $this_win
   if 0 {
    set wlist [tixDescendants $this_win]
    for {set j 0} {$j < [llength $wlist]} {incr j} \
    {
     set witem [lindex $wlist $j]
     set wclass [winfo class $witem]
     if { $wclass == "Toplevel" } {
      set cur_win $witem
     }
     if { $cur_win != "$this_win" } { continue }
     set tlw [winfo toplevel $witem]
     if { $tlw != "$this_win" } { continue }
     switch -exact -- $wclass \
     {
      Entry {
       if [info exists gPB(sens,<Key>,$witem)] {
        bind $witem <Key>        $gPB(sens,<Key>,$witem)
       }
       if [info exists gPB(sens,<KeyRelease>,$witem)] {
        bind $witem <KeyRelease> $gPB(sens,<KeyRelease>,$witem)
       }
      }
      TixHList {
       catch {
        if [$witem info exists 0] {
         UI_PB_com_EnableTree $witem [$witem info children 0]
         } elseif [$witem info exists .] {
         UI_PB_com_EnableTree $witem [$witem info children .]
        }
       }
       if [info exists gPB(sens,browse_cmd,$witem)] \
       {
        $witem config -browsecmd $gPB(sens,browse_cmd,$witem)
       }
      }
      TixNoteBook {
       set plist [$witem pages]
       foreach p $plist \
       {
        if [info exists gPB(sens,state,$witem._$p)] \
        {
         $witem pageconfig $p -state $gPB(sens,state,$witem._$p)
        }
       }
      }
      TixControl {
       continue
      }
      TixButtonBox {
       continue
      }
      TixOptionMenu {
       continue
      }
      TixComboBox {
       continue
      }
      TixLabelEntry {
       continue
      }
      Menubutton {
      }
      Canvas {
       if { [info exists gPB(sens,tags,$witem)]  &&  $gPB(sens,tags,$witem) != {} } \
       {
        set tl $gPB(sens,tags,$witem)
        for {set t 0} {$t < [llength $tl]} {incr t} \
        {
         set bi [lindex $tl $t]
         set bl [$witem bind $bi]
         for {set b 0} {$b < [llength $bl]} {incr b} \
         {
          set seq [lindex $bl $b]
          if [info exists gPB(sens,$seq,$witem,$bi)] \
          {
           set cb  $gPB(sens,$seq,$witem,$bi)
           $witem bind $bi $seq "$cb"
          }
         }
        }
       }
      } ;# Canvas
     } ;# switch of widget classes
     if [info exists gPB(sens,state,$witem)] {
      $witem config -state "$gPB(sens,state,$witem)"
     }
     if [info exists gPB(sens,fg,$witem)] {
      $witem config -fg "$gPB(sens,fg,$witem)"
     }
     if [info exists gPB(sens,<Button-1>,$witem)] {
      bind $witem <Button-1> "$gPB(sens,<Button-1>,$witem)"
     }
     if [info exists gPB(sens,<ButtonRelease-1>,$witem)] {
      bind $witem <ButtonRelease-1> "$gPB(sens,<ButtonRelease-1>,$witem)"
     }
     if [info exists gPB(sens,<Button-3>,$witem)] {
      bind $witem <Button-3> "$gPB(sens,<Button-3>,$witem)"
     }
     if [info exists gPB(sens,<ButtonRelease-3>,$witem)] {
      bind $witem <ButtonRelease-3> "$gPB(sens,<ButtonRelease-3>,$witem)"
     }
     if [info exists gPB(sens,cmd,$witem)] {
      $witem config -command "$gPB(sens,cmd,$witem)"
     }
    } ;# for each widget
   }
  }
  return 1
 }

#=======================================================================
proc UI_PB_com_EnableWindow { this_win args } {
  global gPB
  if { [info exists gPB(main_window)] && [winfo exists $gPB(main_window)] } {
   if { [string match $this_win $gPB(main_window)] } {
    set wlist [UI_PB_com_GetWidgetsToSwitchState]
    if { $wlist == "" } {
     return
    }
    set this_win [lindex $wlist 0]
    set book_ids [array names Book:: *book_id]
    foreach one $book_ids {
     lappend wlist $Book::($one)
    }
    } else {
    set wlist [tixDescendants $this_win]
   }
   } else {
   set wlist [tixDescendants $this_win]
  }
  if { ![string match "Toplevel" [winfo class $this_win]] } {
   set this_win [winfo toplevel $this_win]
  }
  for { set j 0 } { $j < [llength $wlist] } { incr j } \
  {
   set witem [lindex $wlist $j]
   set wclass [winfo class $witem]
   if 0 {
    if { [string match "Toplevel" [winfo class $this_win]] } {
     if { $wclass == "Toplevel" } {
      set cur_win $witem
     }
     if { [info exists cur_win] && $cur_win != "$this_win" } { unset cur_win; continue }
     set tlw [winfo toplevel $witem]
     if { $tlw != "$this_win" } { continue }
    }
   }
   set tlw [winfo toplevel $witem]
   if { [string compare $tlw $this_win] } { continue }
   switch -exact -- $wclass \
   {
    Entry {
     if [info exists gPB(sens,<Key>,$witem)] {
      bind $witem <Key>        $gPB(sens,<Key>,$witem)
     }
     if [info exists gPB(sens,<KeyRelease>,$witem)] {
      bind $witem <KeyRelease> $gPB(sens,<KeyRelease>,$witem)
     }
    }
    TixHList {
     if 0 {
      catch {
       if [$witem info exists 0] {
        UI_PB_com_EnableTree $witem [$witem info children 0]
        } elseif [$witem info exists .] {
        UI_PB_com_EnableTree $witem [$witem info children .]
       }
       if [llength [$witem info children]] {
        UI_PB_com_EnableTree $witem [$witem info children]
       }
      }
     }
     UI_PB_com_EnableTree $witem [$witem info children]
     if [info exists gPB(sens,browse_cmd,$witem)] \
     {
      $witem config -browsecmd $gPB(sens,browse_cmd,$witem)
     }
    }
    TixNoteBook {
     set plist [$witem pages]
     foreach p $plist \
     {
      if [info exists gPB(sens,state,$witem._$p)] \
      {
       $witem pageconfig $p -state $gPB(sens,state,$witem._$p)
      }
     }
    }
    TixControl {
     continue
    }
    TixButtonBox {
     continue
    }
    TixOptionMenu {
     continue
    }
    TixComboBox {
     continue
    }
    TixLabelEntry {
     continue
    }
    Ctext {
    }
    TixPanedWindow { ;#<03-06-06 pheobe> add case of TixPanedWindow and TixTree
     continue
    }
    TixScrolledHList {
     continue
    }
    TixScrolledText {
     continue
    }
    TixTree {
     continue
    }
    Menubutton {
    }
    Canvas {
     if { [info exists gPB(sens,tags,$witem)]  &&  $gPB(sens,tags,$witem) != {} } \
     {
      set tl $gPB(sens,tags,$witem)
      for {set t 0} {$t < [llength $tl]} {incr t} \
      {
       set bi [lindex $tl $t]
       set bl [$witem bind $bi]
       for {set b 0} {$b < [llength $bl]} {incr b} \
       {
        set seq [lindex $bl $b]
        if [info exists gPB(sens,$seq,$witem,$bi)] \
        {
         set cb  $gPB(sens,$seq,$witem,$bi)
         $witem bind $bi $seq "$cb"
        }
       }
      }
     }
    } ;# Canvas
   } ;# switch of widget classes
   if [info exists gPB(sens,state,$witem)] {
    $witem config -state "$gPB(sens,state,$witem)"
   }
   if [info exists gPB(sens,fg,$witem)] {
    $witem config -fg "$gPB(sens,fg,$witem)"
   }
   if [info exists gPB(sens,<Button-1>,$witem)] {
    bind $witem <Button-1> "$gPB(sens,<Button-1>,$witem)"
   }
   if [info exists gPB(sens,<ButtonRelease-1>,$witem)] {
    bind $witem <ButtonRelease-1> "$gPB(sens,<ButtonRelease-1>,$witem)"
   }
   if [info exists gPB(sens,<Button-3>,$witem)] {
    bind $witem <Button-3> "$gPB(sens,<Button-3>,$witem)"
   }
   if [info exists gPB(sens,<ButtonRelease-3>,$witem)] {
    bind $witem <ButtonRelease-3> "$gPB(sens,<ButtonRelease-3>,$witem)"
   }
   if [info exists gPB(sens,cmd,$witem)] {
    $witem config -command "$gPB(sens,cmd,$witem)"
   }
  } ;# for each widget
 }

#=======================================================================
proc UI_PB_com_CreateTreePopupElements { page_obj X Y x y \
  cb_select \
  cb_create \
  cb_cut \
  cb_paste \
  cb_rename \
  args \
  } {
  set protected_elms [lindex $args 0]
  global gPB
  set tree $Page::($page_obj,tree)
  set h [$tree subwidget hlist]
  raise $gPB(main_window)
  set cursor_entry [$h nearest $y]
  set indent [$h cget -indent]
  if { [string compare $cursor_entry "0"] != 0 } \
  {
   set Page::($page_obj,selected_index) -1
   $cb_select $page_obj $cursor_entry
  }
  set popup $Page::($page_obj,tree_popup)
  set active_index [$h info selection]
  if { $x > [expr $indent * 2]  && \
   $Page::($page_obj,double_click_flag) == 0  && \
  $active_index == $cursor_entry } \
  {
   $popup delete 0 end
   set indx_string [$h entrycget $active_index -text]
   set sens normal
   set rename_cb "$cb_rename $page_obj $active_index"
   set cut_cb    "$cb_cut $page_obj"
   if { [lsearch $protected_elms $indx_string] >= 0 } {
    set sens disabled
    set rename_cb ""
    set cut_cb    ""
   }
   if { [string compare $cb_rename "UI_PB_blk_EditBlockName"] == 0 } {
    if { [info exists ::gPB_block_name] } {
     if { [PB_com_object_name_of_class_is_external $::gPB_block_name block] } {
      set sens disabled
      set rename_cb ""
      set cut_cb    ""
     }
    }
   }
   if { [string compare $cb_rename "UI_PB_fmt_EditFormatName"] == 0 } {
    if { [info exists ::gPB_format_name] } {
     if { [PB_com_object_name_of_class_is_external $::gPB_format_name format] } {
      set sens disabled
      set rename_cb ""
      set cut_cb    ""
     }
    }
   }
   $popup add command -label "$gPB(tree,rename,Label)" -state $sens \
   -command "$rename_cb"
   $popup add sep
   $popup add command -label "$gPB(tree,create,Label)" -state normal \
   -command "$cb_create $page_obj"
   $popup add command -label "$gPB(tree,cut,Label)" -state $sens \
   -command "$cut_cb"
   if { [info exists Page::($page_obj,buff_obj_attr)] } \
   {
    $popup add command -label "$gPB(tree,paste,Label)" -state normal \
    -command "$cb_paste $page_obj"
   } else \
   {
    $popup add command -label "$gPB(tree,paste,Label)" -state disabled \
    -command ""
   }
   update
   tk_popup $popup $X $Y
  }
 }

#=======================================================================
proc UI_PB_com_CreateNameEntry { page_obj obj_type } {
  global paOption
  global tixOption
  global gPB
  set fch $Page::($page_obj,name_frame)
  switch "$obj_type" {
   block {
    tixLabelEntry $fch.name -label "$gPB($obj_type,name,Label)  :   " \
    -options {
     label.anchor w
     entry.width 64
     entry.anchor w
    }
   }
   default {
    tixLabelEntry $fch.name -label "$gPB($obj_type,name,Label)  :   " \
    -options {
     label.anchor w
     entry.width 32
     entry.anchor w
    }
   }
  }
  [$fch.name subwidget label] config -font $tixOption(bold_font)
  [$fch.name subwidget label] config -fg $paOption(special_fg) -bg $paOption(name_bg)
  set fch_entry [$fch.name subwidget entry]
  $fch_entry config -bd 0 -relief flat
  set fch_entry [$fch.name subwidget entry]
  bind $fch_entry <KeyPress> "UI_PB_com_DisableSpecialChars %W %K"
  bind $fch_entry <KeyPress> "+UI_PB_com_RestrictStringLength %W %K $obj_type"
  bind $fch_entry <Control-Key-v> "UI_PB_com_Validate_Control_V %W %K %A $obj_type"
  bind $fch_entry <KeyRelease> "UI_PB_com_Validate_Control_V_Release %W"
  global gPB_${obj_type}_name
  $fch_entry config -textvariable gPB_${obj_type}_name
  set Page::($page_obj,name_widget) $fch.name
  pack $fch.name -pady 5
  focus $fch_entry
  set gPB(c_help,$fch_entry)                  "$obj_type,name"
 }

#=======================================================================
proc UI_PB_com_SetStatusbar { message } {
  global gPB
  if [info exists gPB(master_pid)] {
   comm::comm send -async $gPB(master_pid) [list set gPB(menu_bar_status) $message]
   } else {
   set gPB(menu_bar_status) "$message"
  }
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
  wm title $gPB(main_window) [file nativename "$display_text"]
 }

#=======================================================================
proc UI_PB_com_CreateActionElems { win CB_ARR args} {
  upvar $CB_ARR cb_arr
  set box1_frm [frame $win.box1]
  set box2_frm [frame $win.box2]
  tixForm $box1_frm -top 0 -left 0 -right %50 -padright 20
  tixForm $box2_frm -top 0 -left $box1_frm -right %100
  set label_list1 { "gPB(nav_button,default,Label)" \
  "gPB(nav_button,restore,Label)" }
  UI_PB_com_CreateButtonBox $box1_frm label_list1 cb_arr $args
  set label_list2 { "gPB(nav_button,cancel,Label)" \
  "gPB(nav_button,ok,Label)" }
  UI_PB_com_CreateButtonBox $box2_frm label_list2 cb_arr
  PB_com_unset_var ::gPB(VIEW_ADDRESS)
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
proc UI_PB_com_CreateButtonBox { win LABLE_LIST CB_ARR args } {
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
   set button_state normal
   if { [info exists gPB(VIEW_ADDRESS)] && $gPB(VIEW_ADDRESS) } {
    if { ![string match "gPB(nav_button,cancel,Label)" $label] } {
     set call_back ""
     set button_state disabled
    }
   }
   if { [string length $gPB($text_label)] > 10 } {
    $box add act_$count -text $gPB($text_label) \
    -bg $paOption(app_butt_bg)  -command "$call_back" \
    -state $button_state
    } else {
    $box add act_$count -text $gPB($text_label) -width 10 \
    -bg $paOption(app_butt_bg)  -command "$call_back" \
    -state $button_state
   }
   if { [llength $args] } {    ;# Only New component will pass in its dialog id.
    if { $label == "gPB(nav_button,default,Label)" } {
     set def [$box subwidget act_$count]
     if { ![info exists gPB(Default_Button,win)] } {
      set gPB(Default_Button,win) {}
     }
     set dlg [lindex $args 0]
     if { [winfo exists $dlg] } {
      if { [lsearch -exact $gPB(Default_Button,win) "$dlg"] < 0 } {
       set gPB(Default_Button,win)  [linsert $gPB(Default_Button,win) end $dlg]
       set gPB(Default_Button,$dlg) $def
      }
      $def config -state disabled
     }
    }
   }
   set context_but [$box subwidget act_$count]
   set context_label [lindex [split $text_label ,] 1]
   set gPB(c_help,$context_but)     "nav_button,$context_label"
  }
  pack $box -side bottom -fill x
 }

#=======================================================================
proc UI_PB_com_DisableTree { h b flag } {
  global paOption gPB
  set b_len [llength $b]
  for {set t 0} {$t < $b_len} {incr t} {
   set c [lindex $b $t]
   set state [lindex [$h entryconfig $c -state] end]
   if { ![string match "disabled" $state] } {
    $h entryconfig $c -state disabled
    set sty [lindex [$h entryconfig $c -style] end]
    if { [string match "tixStyle*" $sty] && \
     [string match "GRAY" $flag] && \
     ![string match $c [$h info selection]] } {
     if { [lsearch $gPB(sys_font_style) $sty] > -1 } {
      set font [$sty cget -font]
      if 0 {
       if [string match "*bold*" $font] {
        $h entryconfig $c -style $gPB(font_style_bold_gray)
        } else {
        $h entryconfig $c -style $gPB(font_style_normal_gray)
       }
      }
      if { [string match "*$gPB(font_style_bold)*"      $font] ||\
       [string match "*$gPB(font_style_bold_gray)*" $font] } {
       $h entryconfig $c -style $gPB(font_style_bold_gray)
       } else {
       $h entryconfig $c -style $gPB(font_style_normal_gray)
      }
      } else {
      $sty config -fg $paOption(tree_disabled_fg)
     }
    }
   }
   set blist [$h info children $c]
   if { [llength $blist] != 0 } {
    UI_PB_com_DisableTree $h $blist $flag
   }
  }
 }

#=======================================================================
proc UI_PB_com_DisableTree_x { h b flag } {
  global paOption gPB
  for {set t 0} {$t < [llength $b]} {incr t} \
  {
   set c [lindex $b $t]
   set state [lindex [$h entryconfig $c -state] end]
   if { ![string match "disabled" $state] } {
    $h entryconfig $c -state disabled
    if { $flag == "GRAY" && \
    $c != [lindex [$h info selection] 0] } \
    {
     set sty [lindex [$h entryconfig $c -style] end]
     set font [$sty cget -font]
     if {[string match "*bold*" $font]} {
      $h entryconfig $c -style $gPB(font_style_bold_gray)
      } else {
      $h entryconfig $c -style $gPB(font_style_normal_gray)
     }
    }
    set blist [$h info children $c]
    if { [llength $blist] != 0 } \
    {
     UI_PB_com_DisableTree $h $blist $flag
    }
   }
  }
 }

#=======================================================================
proc UI_PB_com_EnableTree { h b } {
  global paOption gPB
  set b_len [llength $b]
  for {set t 0} {$t < $b_len} {incr t} {
   set c [lindex $b $t]
   set sty [lindex [$h entryconfig $c -style] end]
   if [string match "tixStyle*" $sty] {
    $h entryconfig $c -state normal
    if { [lsearch $gPB(sys_font_style) $sty] > -1 } {
     set font [$sty cget -font]
     if 0 {
      if [string match "*bold*" $font] {
       $h entryconfig $c -style $gPB(font_style_bold)
       } else {
       $h entryconfig $c -style $gPB(font_style_normal)
      }
     }
     if { [string match "*$gPB(font_style_bold)*"      $font] ||\
      [string match "*$gPB(font_style_bold_gray)*" $font] } {
      $h entryconfig $c -style $gPB(font_style_bold)
      } else {
      $h entryconfig $c -style $gPB(font_style_normal)
     }
     } else {
     $sty config -fg $paOption(tree_fg)
    }
   }
   set blist [$h info children $c]
   if { [llength $blist] != 0 } \
   {
    UI_PB_com_EnableTree $h $blist
   }
  }
 }

#=======================================================================
proc UI_PB_com_EnableTree_x { h b } {
  global paOption gPB
  for {set t 0} {$t < [llength $b]} {incr t} \
  {
   set c [lindex $b $t]
   $h entryconfig $c -state normal
   set sty [lindex [$h entryconfig $c -style] end]
   set global_style [list $gPB(font_style_bold) $gPB(font_style_normal) \
   $gPB(font_style_bold_gray) \
   $gPB(font_style_normal_gray)]
   if {[lsearch $global_style $sty] > -1} {
    set font [$sty cget -font]
    if {[string match "*bold*" $font]} {
     $h entryconfig $c -style $gPB(font_style_bold)
     } else {
     $h entryconfig $c -style $gPB(font_style_normal)
    }
    } else {
    $h entryconfig $c -style $sty
   }
   set blist [$h info children $c]
   if { [llength $blist] != 0 } \
   {
    UI_PB_com_EnableTree $h $blist
   }
  }
 }

#=======================================================================
proc __SetMapFlag { flag } {
  foreach w $::gPB(toplevel_list) {
   set ::gMapFlag($w) $flag
  }
 }

#=======================================================================
proc __map_transient { w pw } {
  global gMapFlag
  if { ![info exists gMapFlag($w)] || !$gMapFlag($w) } {
   return
  }
  wm transient $w ""
  set gMapFlag($w) 0
  set map_cb [bind $w <Map>]
  set gMapFlag($w) 1
  set unmap_cb [bind $w <Unmap>]
  set __is_top 0
  if { [winfo ismapped $w] } {
   UI_PB_debug_ForceMsg "\n #####  1. __map_transient $w is mapped. \n map_cb : >$map_cb< \n unmap_cb >$unmap_cb< ##### \n"
   } else {
   UI_PB_debug_ForceMsg "\n #####  1.a __map_transient $w is NOT mapped. \n map_cb : >$map_cb< \n unmap_cb >$unmap_cb< ##### \n"
  }
  if [info exists ::gPB(toplevel_list)] {
   set cw [lindex $::gPB(toplevel_list) end]
   UI_PB_debug_ForceMsg_no_trace "\n #####  2. __map_transient cw >$cw< ##### \n"
   UI_PB_debug_ForceMsg_no_trace "\n #####  3. __map_transient w  >$w< ##### \n"
   if { [lsearch -exact $::gPB(toplevel_list) $w] >= 0 } {
    if { [string compare $w $cw] == 0 } {
     set __is_top 1
    }
   }
  }
  UI_PB_debug_ForceMsg_no_trace "\n #####  4. __map_transient toplevel_list >$::gPB(toplevel_list)< ##### \n"
  if { $__is_top && [winfo ismapped $w] } {
   UI_PB_debug_ForceMsg_no_trace "\n #####  5. __map_transient $w mapped. ##### \n"
   if { $map_cb != "" } {
    set gMapFlag($w) 0
    bind $w <Map> ""
    set map_cb ""
   }
   if { $unmap_cb == "" } {
    set gMapFlag($w) 1
    bind $w <Unmap> "__unmap_transient $w $pw"
   }
  }
  set tw [winfo toplevel $pw]
  if { $map_cb == "" } {
   if 0 {
    if { [winfo exists $tw] } {
     raise $tw; raise $w $tw
     } else {
     raise $w
    }
   }
   if { [winfo ismapped $w] } {
    set gMapFlag($w) 0
    } else {
    set gMapFlag($w) 1
   }
   wm transient $w $pw
   wm deiconify $w
   UI_PB_debug_ForceMsg_no_trace "\n #####  6. __map_transient return ##### \n"
   return
  }
  UI_PB_debug_ForceMsg_no_trace "\n #####  7. __map_transient $w $pw ##### \n"
  set cw [lindex $::gPB(toplevel_list) end]
  if { 0 && [string compare $w $cw] == 0 } {
   set ic [expr [llength $::gPB(toplevel_list)] -1]
   for { set iw 0 } { $iw < $ic } { incr iw } {
    set wp [lindex $::gPB(toplevel_list) $iw]
    set wc [lindex $::gPB(toplevel_list) [expr $iw +1]]
    wm transient $wc $wp
    UI_PB_debug_ForceMsg_no_trace "\n #####  7.$iw __map_transient reparent $wc $wp ##### \n"
   }
  }
  if 0 {
   if { [winfo exists $tw] } {
    raise $tw; raise $w $tw
    } else {
    raise $w
   }
  }
  if { $map_cb != "" } {
   set gMapFlag($w) 0
   bind $w <Map> ""
  }
  if { $unmap_cb == "" } {
   set gMapFlag($w) 1
   bind $w <Unmap> "__unmap_transient $w $pw"
  }
  wm transient $w $pw
  wm deiconify $w
  set gMapFlag($w) 0
 }

#=======================================================================
proc __unmap_transient { w pw } {
  global gMapFlag
  if { [info exists gMapFlag($w)] && $gMapFlag($w) } {
   return
  }
  set gMapFlag($w) 0
  set map_cb [bind $w <Map>]
  set gMapFlag($w) 1
  set unmap_cb [bind $w <Unmap>]
  if { ![winfo ismapped $w] } {
   UI_PB_debug_ForceMsg "\n #####  1. __unmap_transient $w is unmapped. ##### \n"
  }
  if { $unmap_cb == "" } {
   return
  }
  UI_PB_debug_ForceMsg "\n #####  2. __unmap_transient toplevel_list >$::gPB(toplevel_list)< ##### \n"
  UI_PB_debug_ForceMsg_no_trace "\n #####  3. __unmap_transient $w => $pw ##### \n"
  if { $map_cb == "" } {
   set gMapFlag($w) 0
   bind $w <Map> "__map_transient $w $pw"
  }
  if { $unmap_cb != "" } {
   set gMapFlag($w) 1
   bind $w <Unmap> ""
  }
  set gMapFlag($w) 1
  wm transient $w .widget.main
  update idletasks
 }
 if 1 {

#=======================================================================
proc __map_transient { w pw } {
  global gMapFlag
  if { [info exists gMapFlag($w)] && $gMapFlag($w) } {
   set ::gMapFlag($w) 0
   bind $w <Map> ""
   set ::gMapFlag($w) 1
   bind $w <Unmap> "__unmap_transient $w $pw"
   set ::gMapFlag($w) 0
   wm transient $w $pw
   set ws [wm state $w]
   UI_PB_debug_ForceMsg "\n #####  >$w< state : >$ws< => is_mapped [winfo ismapped $w] ##### \n"
   if 1 {
    if { ![info exists ::gMapState($w)] || $::gMapState($w) == 0 } {
     if { ![winfo ismapped $w] || ![wm stackorder $w isabove $pw] } {
      UI_PB_debug_ForceMsg_no_trace "\n #####  raise >$w< ##### \n"
      raise $w $pw
     }
     set ::gMapState($w) 1
    }
   }
   set cw [lindex $::gPB(toplevel_list) end]
   if { [string compare $w $cw] == 0 } {
    update idletasks
   }
  }
 }

#=======================================================================
proc __unmap_transient { w pw } {
  global gMapFlag
  if { ![info exists gMapFlag($w)] || !$gMapFlag($w) } {
   set ::gMapState($w) 0
   set ::gMapFlag($w) 0
   bind $w <Map> "__map_transient $w $pw"
   set ::gMapFlag($w) 1
   bind $w <Unmap> ""
   set ::gMapFlag($w) 1
   wm transient $w .widget.main
  }
 }
}
if 0 {

#=======================================================================
proc __map_transient { w pw } {
  global gMapFlag
  if { ![info exists gMapFlag($w)] || !$gMapFlag($w) } {
   return
  }
  set cw [lindex $::gPB(toplevel_list) end]
  if { [string compare $w $cw] } {
   set ::gMapFlag($w) 0
   bind $w <Map> ""
   bind $w <Unmap> "__unmap_transient $w $pw"
   wm transient $w $pw
   return
  }
  set ic [expr [llength $::gPB(toplevel_list)] -1]
  for { set iw 0 } { $iw < $ic } { incr iw } {
   set wp [lindex $::gPB(toplevel_list) $iw]
   set wc [lindex $::gPB(toplevel_list) [expr $iw +1]]
   wm transient $wc $wp
   UI_PB_debug_ForceMsg_no_trace "\n #####  7.$iw __map_transient reparent $wc $wp ##### \n"
  }
  set ::gMapFlag($w) 0
  bind $w <Map> ""
  bind $w <Unmap> "__unmap_transient $w $pw"
  wm transient $w $pw
  wm deiconify $w
  update idletasks
 }

#=======================================================================
proc __unmap_transient { w pw } {
  global gMapFlag
  if { ![info exists gMapFlag($w)] || !$gMapFlag($w) } {
   set gMapFlag($w) 1
   bind $w <Map> "__map_transient $w $pw"
   bind $w <Unmap> ""
   wm transient $w .widget.main
   update idletasks
  }
 }
}
if 0 {

#=======================================================================
proc __map_transient { w pw } {
  global gMapFlag
  if { [info exists gMapFlag($w)] && $gMapFlag($w) } {
   set gMapFlag($w) 0
   focus $w
   bind $w <Map> ""
   bind $w <Unmap> "__unmap_transient $w $pw"
   wm transient $w $pw
   update idletasks
  }
 }

#=======================================================================
proc __unmap_transient { w pw } {
  global gMapFlag
  if { ![info exists gMapFlag($w)] || !$gMapFlag($w) } {
   set gMapFlag($w) 1
   bind $w <Map> "__map_transient $w $pw"
   bind $w <Unmap> ""
   wm transient $w .widget.main
   update idletasks
  }
 }
}

#=======================================================================
proc UI_PB_com_CreateTransientWindow { w title geom construct_cb post_construct_cb \
  win_close_cb pre_destroy_cb args } {
  global gPB
  PB_cancel_balloon
  set geom                   [string trim $geom                " "]
  set construct_cb           [string trim $construct_cb        " "]
  set post_construct_cb      [string trim $post_construct_cb   " "]
  set win_close_cb           [string trim $win_close_cb        " "]
  set pre_destroy_cb         [string trim $pre_destroy_cb      " "]
  set pw [winfo parent $w]
  if { $pw == "" } \
  {
   return [tk_messageBox -parent [UI_PB_com_AskActiveWindow] \
   -type ok -icon error \
   -message "$gPB(msg,parent_win)"]
   } else {
   set pw [winfo toplevel $pw]
   if { [info exists gPB(master_pid)] && [string match $pw ".widget"] } {
    } else {
    wm transient $w $pw
   }
  }
  if 0 {
   if { ![info exists gPB(master_pid)] || ![string match $pw ".widget"] } {
    if { ![PB_com_is_true gPB(DISABLE_MIN_MAX_BUTTONS)] } {
     if { [string match ".widget.main.*" $w] && \
      [llength $gPB(toplevel_list)] > 1 } {
      bind $w <Map>   "__map_transient   $w $pw"
      bind $w <Unmap> "__unmap_transient $w $pw"
     }
    }
   }
  }
  wm withdraw $w
  wm title $w $title
  if { $win_close_cb != "" } {
   wm protocol $w WM_DELETE_WINDOW "$win_close_cb"
  }
  if 1 {
   if { ![PB_com_is_true ::gPB(DISABLE_MIN_MAX_BUTTONS)] } {
    set pw_Leave_CB [bind $pw <Leave>]
    if { $win_close_cb != "" } {
     wm protocol $w WM_DELETE_WINDOW "$win_close_cb; bind $pw <Leave> [list $pw_Leave_CB]"
    }
   }
  }

#=======================================================================
proc __com_SaveWindowGeometry { w } {
  if { [string compare [winfo toplevel $w] $w] == 0 } {
   if [PB_com_is_true ::gPB(Disable_SaveWindowGeometry)] {
    return
   }
   if { [string compare "$::gPB(main_window)" "$w"] == 0 } {

#=======================================================================
proc __com_SaveWindowGeometry { w } {}
 return
}
set ::gPB_GEOM($w) [winfo geometry $w] ;#[wm geometry $w]
if { ![string match "*.pause" $w] } {
 UI_PB_debug_ForceMsg "\n #####  Save window geometry of >$w< >$::gPB_GEOM($w)< ##### \n"
}

#=======================================================================
proc __com_SaveWindowGeometry { w } {}
}
}
bind $w <Destroy> "+ __com_SaveWindowGeometry $w"
if { $pre_destroy_cb != "" } {
bind $w <Destroy> "+ $pre_destroy_cb"
}
bind $w <Destroy> "+ UI_PB_com_DismissActiveWindow $w %W"
bind $w <Destroy> "+ UI_PB_com_DeleteFromTopLevelList $w %W"
bind $w <Destroy> "+ __com_RehostNoLicenseMsg"
bind $w <Destroy> "+ __com_GrayOutDefaultButton %W"
if [info exists gPB(main_window)] {
if { [winfo toplevel [winfo parent $w]] == "$gPB(main_window)" } {
 bind $w <Destroy> "+ UI_PB_com_UnGraySaveOptions %W"
}
}
if { [info exists ::PID(activated)] && $::PID(activated) != "" } {
if { $gPB(use_info) != 1 } {
 bind $w <Destroy> "+ UI_PB_com_UnGraySaveOptions %W"
}
}
set gPB(prev_window_grab) [grab current]
if { [info exists ::gPB_GEOM($w)] } {
if { ![string match "*.pause" $w] } {
 UI_PB_debug_ForceMsg "\n #####  Fetch window geometry of >$w< >$::gPB_GEOM($w)< ##### \n"
}
set geom [string trim $::gPB_GEOM($w)]
}
if { $geom != "" && $geom != "AT_CURSOR" } {
wm geometry $w $geom
} elseif { $geom == "AT_CURSOR" } {
set xc [winfo pointerx .]
set yc [winfo pointery .]
wm geometry $w +$xc+$yc
} else {
set aw [UI_PB_com_AskActiveWindow]
set xc [expr [winfo rootx $aw] + 20]
set yc [expr [winfo rooty $aw] - 60]
wm geometry $w +$xc+$yc
}
if { $construct_cb != "" } \
{
eval $construct_cb
}
if ![info exists gPB(master_pid)] {
wm deiconify $w
} elseif {[string match $pw ".widget"] == 0} {
wm deiconify $w
}
if [info exists gPB(main_window)] {
if { $w != "$gPB(main_window)" } {
 if {$gPB(use_info) != 1} {
  UI_PB_com_GrayOutSaveOptions
 }
}
}
UI_PB_com_ClaimActiveWindow $w
if { [llength $args] == 0 } {
UI_PB_com_DisableMainWindow
} else {
if { [lindex $args 0] != 0 } {
 UI_PB_com_DisableMainWindow
}
}
if { $post_construct_cb != "" } \
{
eval $post_construct_cb
}
if 1 {
if { ![info exists gPB(master_pid)] || ![string match $pw ".widget"] } {
 if { ![PB_com_is_true gPB(DISABLE_MIN_MAX_BUTTONS)] } {
  if { [string match ".widget.main.*" $w] && \
   [llength $gPB(toplevel_list)] > 1 } {
   bind $w <Map>   "__map_transient   $w $pw"
   bind $w <Unmap> "__unmap_transient $w $pw"
  }
 }
}
}
UI_PB_com_AddToTopLevelList $w
__com_RaiseNoLicenseMsg
}

#=======================================================================
proc UI_PB_com_PositionWindow { w args } {
  global gPB
  set map_cb   ""
  set unmap_cb ""
  if 0 {
   set map_cb   [bind $w <Map>]
   set unmap_cb [bind $w <Unmap>]
  }
  update idletasks
  set screen_width  [lindex [wm maxsize .] 0]
  set screen_height [winfo vrootheight .]
  if { [llength $args] && [lindex $args 0] == "non_deco" } {
   set WIN_X 0
   set WIN_Y 0
   } else {
   set WIN_X $gPB(WIN_X)
   set WIN_Y $gPB(WIN_Y)
  }
  set xc [expr [winfo rootx $w] - $WIN_X]
  set yc [expr [winfo rooty $w] - $WIN_Y]
  set geom_x "+$xc"
  set geom_y "+$yc"
  set ww [winfo width  $w]
  set wh [winfo height $w]
  set geom_w "$ww"
  set geom_h "$wh"
  set ww [expr $ww + $WIN_X + $WIN_X]
  set wh [expr $wh + $WIN_Y + $WIN_X]
  if { $ww >= $screen_width } {
   set geom_x "+0"
   set geom_w $gPB(win_max_width)
   set dx 1
   } else {
   set dx [expr $xc + $ww - $screen_width]
   if { $dx > 0 } {
    set geom_x "+[expr $screen_width - $ww]"
   }
  }
  if { $wh >= $screen_height } {
   set geom_y "+0"
   set geom_h $gPB(win_max_height)
   set dy 1
   } else {
   set dy [expr $yc + $wh - $screen_height]
   if { $dy > 0 } {
    set geom_y "-0"
   }
  }
  if { $xc < 0 } {
   set geom_x "+0"
   set dx 1
  }
  if { $yc < 0 } {
   set geom_y "+0"
   set dy 1
  }
  if { $dx > 0 || $dy > 0 } {
   wm geometry $w [join [list $geom_w x $geom_h $geom_x$geom_y] "" ]
   update idletasks
  }
  if { $map_cb   != "" } {
   bind $w <Map>   "$map_cb"
  }
  if { $unmap_cb != "" } {
   bind $w <Unmap> "$unmap_cb"
  }
  focus $w
 }

#=======================================================================
proc UI_PB_com_CenterWindow { w args } {
  global gPB
  update idletasks
  if { $::tcl_version >= 8.6 } {
   set screen_width  [winfo screenwidth .]
   } else {
   set screen_width  [winfo vrootwidth .]
  }
  set screen_height [winfo vrootheight .]
  if { [llength $args] && [lindex $args 0] == "non_deco" } {
   set WIN_X 0
   set WIN_Y 0
   } else {
   set WIN_X $gPB(WIN_X)
   set WIN_Y $gPB(WIN_Y)
  }
  set ww [winfo width  $w]
  set wh [winfo height $w]
  set geom_w "$ww"
  set geom_h "$wh"
  set ww [expr $ww + $WIN_X + $WIN_X]
  set wh [expr $wh + $WIN_Y + $WIN_X]
  set win_max_width  [expr $screen_width  - $WIN_X - $WIN_X]
  set win_max_height [expr $screen_height - $WIN_Y - $WIN_X]
  if { $ww >= $screen_width } {
   set geom_w $win_max_width
  }
  if { $wh >= $screen_height } {
   set geom_h $win_max_height
  }
  set xc [expr $screen_width / 2]
  set yc [expr $screen_height / 2]
  set geom_x [expr $xc - ($geom_w/2) - $WIN_X]
  set geom_y [expr $yc - ($geom_h/2) - $WIN_Y]
  wm geometry $w [join [list $geom_w x $geom_h + $geom_x + $geom_y] "" ]
  update idletasks
  focus $w
 }

#=======================================================================
proc UI_PB_com_ResizeWindow { w args } {
  update idletasks
  set reqwi [winfo reqwidth  $w]
  set reqhi [winfo reqheight $w]
  set ww [winfo width  $w]
  if { $ww < $reqwi } { set ww $reqwi }
  wm geometry $w "${ww}x${reqhi}"
 }

#=======================================================================
proc __com_RaiseNoLicenseMsg {} {
  global gPB
  if {[ info exists gPB(NO_LICENSE_msg) ] && \
   [ winfo exists $gPB(NO_LICENSE_msg) ]} {
   update idletasks
   set aw [UI_PB_com_AskActiveWindow]
   set re_parent 1
   if { $aw == "$gPB(NO_LICENSE_msg)" } {
    set re_parent 0
   }
   if { [winfo exists $gPB(top_window).new]  && \
    $aw == "$gPB(top_window).new" } {
    set re_parent 0
   }
   if { [winfo exists $gPB(top_window).open]  && \
    $aw == "$gPB(top_window).open" } {
    set re_parent 0
   }
   if { [info exists gPB(main_window).save_as]  && \
    [winfo exists $gPB(main_window).save_as]  && \
    $aw == "$gPB(main_window).save_as" } {
    set re_parent 0
   }
   if { $re_parent } {
    wm transient $gPB(NO_LICENSE_msg) $aw
    } else {
    wm transient $gPB(NO_LICENSE_msg) $gPB(top_window)
    raise $gPB(NO_LICENSE_msg)
   }
  }
 }

#=======================================================================
proc __com_ReleaseNoLicenseMsg {} {
  global gPB
  if {[ info exists gPB(NO_LICENSE_msg) ] && \
   [ winfo exists $gPB(NO_LICENSE_msg) ]} {
   wm transient $gPB(NO_LICENSE_msg) $gPB(top_window)
   update
  }
 }

#=======================================================================
proc __com_RehostNoLicenseMsg {} {
  global gPB
  if {[ info exists gPB(NO_LICENSE_msg) ] && \
   [ winfo exists $gPB(NO_LICENSE_msg) ]} {
   set aw [UI_PB_com_AskActiveWindow]
   wm transient $gPB(NO_LICENSE_msg) $aw
  }
 }

#=======================================================================
proc __com_GrayOutDefaultButton {{m_win NULL}} {
  global gPB
  if { ![string match $m_win NULL] } {
   if { ![string match $m_win [winfo toplevel $m_win]] } {
    return
   }
  }
  if { [info exists gPB(Default_Button,win)] } {
   set aw [UI_PB_com_AskActiveWindow]
   if { [lsearch -exact $gPB(Default_Button,win) $aw] >= 0 } {
    $gPB(Default_Button,$aw) config -state disabled
   }
  }
 }

#=======================================================================
proc UI_PB_com_GrayOutSaveOptions { } {
  global gPB
  if [info exists gPB(master_pid)] {
   comm::comm send -async $gPB(master_pid) [list __com_GrayOutSaveOptions_mod]
   } else {
   __com_GrayOutSaveOptions_mod
  }
 }

#=======================================================================
proc __com_GrayOutSaveOptions_mod { } {
  global gPB
  set mb $gPB(main_menu_bar).file.m
  $mb entryconfigure $gPB(menu_index,file,save)    -state disabled
  $mb entryconfigure $gPB(menu_index,file,save_as) -state disabled
  bind all <Control-s> ""
  bind all <Control-a> ""
  set mm $gPB(main_menu).tool
  [$mm subwidget save] config -state disabled
 }

#=======================================================================
proc UI_PB_com_UnGraySaveOptions {{m_win NULL}} {
  global gPB
  if { ![string match $m_win NULL] } {
   if { ![string match $m_win [winfo toplevel $m_win]] } {
    return
   }
  }
  if { [info exists gPB(master_pid)] } {
   comm::comm send -async $gPB(master_pid) [list __com_UnGraySaveOptions_mod]
   } else {
   __com_UnGraySaveOptions_mod
  }
 }

#=======================================================================
proc __com_UnGraySaveOptions_mod { } {
  global gPB
  set mb $gPB(main_menu_bar).file.m
  $mb entryconfigure $gPB(menu_index,file,save)    -state normal
  $mb entryconfigure $gPB(menu_index,file,save_as) -state normal
  bind all <Control-s> "UI_PB_SavePost"
  bind all <Control-a> "UI_PB_SavePostAs"
  set mm $gPB(main_menu).tool
  [$mm subwidget save] config -state normal
  global LicInfo
  if { [info exists LicInfo(user_right_limit)] && $LicInfo(user_right_limit) == "YES" } {
   $gPB(file_menu) entryconfigure $gPB(menu_index,file,save_as) -state disabled
   bind all <Control-s> ""
  }
  if { [info exists LicInfo(SITE_ID_IS_OK_FOR_PT)] } {
   if {$gPB(PB_LICENSE) == "UG_POST_AUTHOR" && $LicInfo(SITE_ID_IS_OK_FOR_PT) == 0} {
    if {[lsearch $gPB(lic_list) $LicInfo(post_license)] >= 0} {
     $mb entryconfigure $gPB(menu_index,file,save_as) -state disabled
     bind all <Control-s> ""
    }
   }
  }
 }

#=======================================================================
proc UI_PB_com_AddToTopLevelList { w args } {
  global gPB
  if { $w != "$gPB(top_window).new"  && \
   $w != "$gPB(top_window).open" && \
   [lsearch $gPB(toplevel_list) $w] < 0 } {
   set gPB(toplevel_list) [linsert $gPB(toplevel_list) end $w]
  }
  UI_PB_com_DisableXButton $w
 }

#=======================================================================
proc UI_PB_com_DeleteFromTopLevelList { w {m_win NULL}} {
   global gPB
   if { ![string match $m_win NULL] } {
    if { ![string match $m_win [winfo toplevel $m_win]] } {
     return
    }
   }
   set wi [lsearch $gPB(toplevel_list) $w]
   if { $wi >= 0 } {
    set gPB(toplevel_list) [lreplace $gPB(toplevel_list) $wi $wi]
   }
   UI_PB_com_EnableXButton $w
  }

#=======================================================================
proc UI_PB_com_DeleteTopLevelWindows { args } {
  global gPB
  __com_ReleaseNoLicenseMsg
  set w [lindex $gPB(toplevel_list) end]
  while { $w != "" } {
   wm withdraw  $w
   destroy      $w
   set w [lindex $gPB(toplevel_list) end]
  }
  set gPB(toplevel_list) {}
  set gPB(main_window) ""
  if [info exists gPB(book)] {
   unset gPB(book)
  }
  if 0 {
   if [winfo exists .pb_debug] {
    destroy .pb_debug
   }
  }
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
  set acw $gPB(top_window)
  if { [winfo exists $gPB(active_window)] } {
   set acw $gPB(active_window)
   } else {
   set iend [expr [llength $gPB(active_window_list)] - 1]
   for { set i $iend } { $i > -1 } { incr i -1 } {
    set acw [lindex $gPB(active_window_list) $i]
    if [winfo exists $acw] {
     continue
    }
   }
  }
  return $acw
 }

#=======================================================================
proc UI_PB_com_DisableMainWindow { args } {
  if [UI_PB_com_DisableMain] { return }
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
   bind [$pb_book_id subwidget nbframe] <1>  __com_InactiveTabMsg
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
    0 { ;# Machine Tool
     UI_PB_mach_DisableWindow chap
    }
    1 { ;# Program & Tool Path
     UI_PB_prog_DisableWindow chap
    }
    2 { ;# N/C Data Definitions
     UI_PB_def_DisableWindow chap
    }
    3 { ;# Listing File
    }
    4 { ;# Files Preview
     set gPB($sect_id,b1_cb) [bind [$sect_id subwidget nbframe] <1>]
     bind [$sect_id subwidget nbframe] <1>  __com_InactiveTabMsg
     set t $Page::($page_obj,tree)
     set h [$t subwidget hlist]
     switch $page_tab \
     {
      0 {  ;# Events
      }
      1 {  ;# Definitions
      }
     }
    }
    5 { ;# Post Advisor
    }
   }
  }
 }

#=======================================================================
proc UI_PB_com_GetCurrentTabPageObj { } {
  global gPB
  set main_tab       $Book::($gPB(book),current_tab)
  set main_page_obj  [lindex $Book::($gPB(book),page_obj_list) $main_tab]
  set curr_book_obj  $Page::($main_page_obj,book_obj)
  set curr_tab       $Book::($curr_book_obj,current_tab)
  set page_obj       [lindex $Book::($curr_book_obj,page_obj_list) $curr_tab]
  return $page_obj
 }

#=======================================================================
proc __com_InactiveTabMsg {  } {
  global gPB
  if { !$gPB(use_info) } \
  {
   tk_messageBox -parent [UI_PB_com_AskActiveWindow] -type ok -icon error \
   -message "$gPB(msg,close_subwin)"
  }
 }

#=======================================================================
proc UI_PB_com_EnableMainWindow { args } {
  if [UI_PB_com_EnableMain] { return }
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
    0 { ;# Machine Tool
     UI_PB_mach_EnableWindow chap
    }
    1 { ;# Program & Tool Path
     UI_PB_prog_EnableWindow chap
    }
    2 { ;# N/C Data Definitions
     UI_PB_def_EnableWindow chap
    }
    3 { ;# Listing File
    }
    4 { ;# Code Preview
    }
    5 { ;# Post Advisor
    }
   }
  }
 }

#=======================================================================
proc UI_PB_com_DelistActiveWindow { win args } {
  global gPB
  if { $win != $gPB(top_window) } {
   set wi [lsearch $gPB(active_window_list) $win]
   if { $wi > -1 } {
    set gPB(active_window_list) [lreplace $gPB(active_window_list) $wi $wi]
    set gPB(active_window) [lindex $gPB(active_window_list) end]
   }
  }
 }

#=======================================================================
proc UI_PB_com_DismissActiveWindow { win {m_win NULL} } {
  global gPB
  if { ![string match $m_win NULL] } {
   if { ![string match $m_win [winfo toplevel $m_win]] } {
    return
   }
  }
  if { $win != $gPB(top_window) } {
   UI_PB_com_DelistActiveWindow $win
   set cwg [grab current]
   if { $cwg != $win } {
    grab release $cwg
    if { [info exists gPB(prev_window_grab)] && $gPB(prev_window_grab) != "" && \
     [winfo exists $gPB(prev_window_grab)] } {
     grab $gPB(prev_window_grab)
    }
   }
  }
  UI_PB_com_EnableMainWindow
  set actw [UI_PB_com_AskActiveWindow]
  if [winfo exists $actw] \
  {
   focus $actw
  }
 }

#=======================================================================
proc UI_PB_com_RetImageAppdText { ADDR_OBJ ELEM_MOM_VAR IMG_NAME \
  WORD_APP_TEXT } {
  upvar $ADDR_OBJ addr_obj
  upvar $ELEM_MOM_VAR elem_mom_var
  upvar $IMG_NAME image_name
  upvar $WORD_APP_TEXT word_app_text
  global mom_sys_arr
  set font $::gPB(nc_code_font)  ;# tixOption(fixed_font_sm)
  if { $addr_obj == "Command" } \
  {
   if { [string match "MOM_*" $elem_mom_var] || \
    [string match "ELSE"  $elem_mom_var] || \
   [string match "END"   $elem_mom_var] }  \
   {
    set WORD_LEADER $elem_mom_var
   } else \
   {
    set WORD_LEADER $command::($elem_mom_var,name)
   }
   set word_app_text ""
   set special_blk_flag 1
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
   set special_blk_flag 1
   } elseif { $addr_obj == "Macro" } \
  { ;#<06-03-09 wbh>
   set WORD_LEADER ""
   function::GetDisplayText $elem_mom_var word_app_text
   set special_blk_flag 1
  } else \
  {
   set WORD_LEADER $address::($addr_obj,add_leader)
   PB_com_MapMOMVariable mom_sys_arr addr_obj elem_mom_var word_app_text
   PB_int_ApplyFormatAppText addr_obj word_app_text
  }
  set leader_len [string length $WORD_LEADER]
  if 0 {{
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
  }}
  global env
  append temp_image_name "pb_" $WORD_LEADER "_addr"
  if { [file exists "$env(PB_HOME)/images/$temp_image_name.xbm"] } {
   set image_name $WORD_LEADER
   set no_chars 3
   if { [info exists special_blk_flag] && $special_blk_flag } {
    set use_font $font
    UI_PB_com_TrimOrFillAppTextForSpecial word_app_text use_font
    unset special_blk_flag
    } else {
    UI_PB_com_TrimOrFillAppText word_app_text no_chars
   }
   } else {
   set image_name blank
   set no_chars 5
   append temp_app_text $WORD_LEADER $word_app_text
   if { [info exists special_blk_flag] && $special_blk_flag } {
    set use_font $font
    UI_PB_com_TrimOrFillAppTextForSpecial temp_app_text use_font
    unset special_blk_flag
    } else {
    UI_PB_com_TrimOrFillAppText temp_app_text no_chars
   }
   set word_app_text $temp_app_text
  }
  set temp_image_name ""
  append temp_image_name "pb_" $image_name "_addr"
  set image_name $temp_image_name
 }

#=======================================================================
proc UI_PB_blk_CreateIcon { canvas bitmap label } {
  set font $::gPB(nc_code_font)
  set comp [image create compound -window $canvas \
  -bd 1 \
  -background #c0c0ff \
  -borderwidth 2 \
  -relief raised \
  -showbackground 1]
  set image_addr [tix getimage $bitmap]
  $comp add image -image $image_addr
  $comp add text -text $label -font $font -anchor w
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
proc UI_PB_com_TrimOrFillAppTextForSpecial { APP_TEXT CUR_FONT } {
  upvar $APP_TEXT app_text
  upvar $CUR_FONT cur_font
  set max_width 600
  set actual_width [font measure $cur_font $app_text]
  if { $actual_width > $max_width } \
  {
   set diff_width [expr $actual_width - $max_width]
   set char_width [font measure $cur_font "c"]
   set no_of_more [expr $diff_width / $char_width]
   set no_len [string length $app_text]
   set app_text [string range $app_text 0 [expr $no_len - $no_of_more - 4]]
   append app_text "..."
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
  set font $::gPB(nc_code_font)  ;# tixOption(font_sm)
  set nc_width [font measure $font $blk_nc_code]
  set blank_width [font measure $font " "]
  set act_width 143  ;#<Jun-30-2016> was 145
  set new_nc_code $blk_nc_code
  if { $act_width >= $nc_width } \
  {
   set diff_width [expr $act_width - $nc_width]
   set no_of_blanks [expr $diff_width / $blank_width]
   for { set count 0 } { $count < $no_of_blanks } { incr count } \
   {
    append new_nc_code " "
   }
  } else \
  {
   set no_of_chars [string length $new_nc_code]
   set ii [expr $no_of_chars - 2]
   while { $nc_width > $act_width } \
   {
    set new_nc_code [string range $blk_nc_code 0 $ii]
    append new_nc_code "..."
    set nc_width [font measure $font $new_nc_code]
    incr ii -1
   }
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
   append blk_nc_code "$mom_sys_arr(Word_Separator)"
   unset app_image_name
  }
 }

#=======================================================================
proc UI_PB_com_RetActiveBlkElems { BLK_ELEM_OBJ_LIST args } {
  upvar $BLK_ELEM_OBJ_LIST blk_elem_obj_list
  set elem_flag [lindex $args 0]
  global post_object
  Post::GetObjList $post_object address add_obj_list
  foreach blk_elem_obj $blk_elem_obj_list \
  {
   set add_obj $block_element::($blk_elem_obj,elem_add_obj)
   if { [lsearch $add_obj_list "$add_obj"] < 0 } {
    if [catch {set add_name $address::($add_obj,add_name)}] {
     continue
     } elseif { $add_name != "rapid1" && \
     $add_name != "rapid2" && \
     $add_name != "rapid3" } {
     continue
    }
   }
   set add_name $address::($add_obj,add_name)
   if { $add_name == "rapid1" || \
    $add_name == "rapid2" || \
    $add_name == "rapid3" } {
    lappend temp_blk_elem_list $blk_elem_obj
    continue
   }
   if { $elem_flag == "" } \
   {
    if { $address::($add_obj,word_status) == 0} \
    {
     lappend temp_blk_elem_list $blk_elem_obj
    }
   } else \
   {
    array set mseq_attr $address::($add_obj,def_mseq_attr)
    if { $mseq_attr(1) == 0 } \
    {
     lappend temp_blk_elem_list $blk_elem_obj
    }
    unset mseq_attr
   }
  }
  if { [info exists temp_blk_elem_list] } \
  {
   set blk_elem_obj_list $temp_blk_elem_list
   unset temp_blk_elem_list
  } else \
  {
   set blk_elem_obj_list ""
  }
 }

#=======================================================================
proc __com_RetTextPosAttr { BLK_ELEM_OBJ_LIST TEXT_LDTR_ARR } {
  upvar $BLK_ELEM_OBJ_LIST blk_elem_obj_list
  upvar $TEXT_LDTR_ARR text_ldtr_arr
  set index 0
  foreach blk_elem_obj $blk_elem_obj_list \
  {
   set add_obj $block_element::($blk_elem_obj,elem_add_obj)
   if { [string compare $address::($add_obj,add_name) "Text"] == 0 } \
   {
    if { $index == 0 } \
    {
     set text_ldtr_arr($blk_elem_obj,leading) ""
    } else \
    {
     set text_ldtr_arr($blk_elem_obj,leading) \
     [lindex $blk_elem_obj_list [expr $index - 1]]
     set leading_elm [lindex $blk_elem_obj_list [expr $index - 1]]
     set add_obj $block_element::($leading_elm,elem_add_obj)
     UI_PB_debug_ForceMsg "\n #####  leading_obj : >$address::($add_obj,add_name)< of $block_element::($leading_elm,parent_name) \n"
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
proc __com_SeparateTextElements { BLK_ELEM_OBJ_LIST TEXT_ELEM_LIST } {
  upvar $BLK_ELEM_OBJ_LIST blk_elem_obj_list
  upvar $TEXT_ELEM_LIST text_elem_list
  set no_elems [llength $blk_elem_obj_list]
  for { set count 0 } { $count < $no_elems } { incr count } \
  {
   set blk_elem_obj [lindex $blk_elem_obj_list $count]
   set add_obj $block_element::($blk_elem_obj,elem_add_obj)
   if { [string compare $address::($add_obj,add_name) "Text"] != 0 } \
   {
    lappend temp_blk_elem_list $blk_elem_obj
   } else \
   {
    lappend text_elem_list $blk_elem_obj
   }
  }
  if { [info exists temp_blk_elem_list] } \
  {
   set blk_elem_obj_list $temp_blk_elem_list
  } else \
  {
   set blk_elem_obj_list ""
  }
 }

#=======================================================================
proc __com_AddTextElements { BLK_ELEM_OBJ_LIST TEXT_ELEM_LIST TEXT_LDTR_ARR } {
  upvar $BLK_ELEM_OBJ_LIST blk_elem_obj_list
  upvar $TEXT_ELEM_LIST text_elem_list
  upvar $TEXT_LDTR_ARR text_ldtr_arr
  if { [info exists text_ldtr_arr] } \
  {
   foreach text_obj $text_elem_list \
   {
    set leading_obj  $text_ldtr_arr($text_obj,leading)
    set trailing_obj $text_ldtr_arr($text_obj,trailing)
    if 1 {
     if { $leading_obj != "" } \
     {
      set lead_res [lsearch $blk_elem_obj_list $leading_obj]
      set add_obj $block_element::($leading_obj,elem_add_obj)
      UI_PB_debug_ForceMsg "\n %%%  leading_obj : >$address::($add_obj,add_name)< found $lead_res %%% \n"
      if { $lead_res != -1 } \
      {
       set blk_elem_obj_list [linsert $blk_elem_obj_list \
       [expr $lead_res + 1] $text_obj]
      }
     } else \
     {
      if { $trailing_obj != "" } \
      {
       set trail_res [lsearch $blk_elem_obj_list $trailing_obj]
       if { $trail_res != -1 } \
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
    if 0 {
     if { $leading_obj == "" } \
     {
      set blk_elem_obj_list [linsert $blk_elem_obj_list 0 $text_obj]
      } elseif { $trailing_obj != "" } \
     {
      set trail_res [lsearch $blk_elem_obj_list $trailing_obj]
      if { $trail_res != -1 } \
      {
       set blk_elem_obj_list [linsert $blk_elem_obj_list \
       $trail_res $text_obj]
      }
      } elseif { $leading_obj != "" } \
     {
      set lead_res [lsearch $blk_elem_obj_list $leading_obj]
      if { $lead_res != -1 } \
      {
       set blk_elem_obj_list [linsert $blk_elem_obj_list \
       [expr $lead_res + 1] $text_obj]
      }
     } else \
     {
      set blk_elem_obj_list [linsert $blk_elem_obj_list end $text_obj]
     }
    }
   }
  }
 }

#=======================================================================
proc UI_PB_com_SortBlockElements { BLK_ELEM_OBJ_LIST args } {
  upvar $BLK_ELEM_OBJ_LIST blk_elem_obj_list
  set elem_flag [lindex $args 0]
  __com_RetTextPosAttr blk_elem_obj_list text_ldtr_arr
  __com_SeparateTextElements blk_elem_obj_list text_elem_list
  set no_elements [llength $blk_elem_obj_list]
  for { set ii 0 } { $ii < [expr $no_elements - 1] } { incr ii } \
  {
   for { set jj [expr $ii + 1] } { $jj < $no_elements } { incr jj } \
   {
    set blk_ii_obj [lindex $blk_elem_obj_list $ii]
    set add_ii_obj $block_element::($blk_ii_obj,elem_add_obj)
    if { $elem_flag == "" } \
    {
     set add_ii_index $address::($add_ii_obj,seq_no)
    } else \
    {
     array set mseq_attr $address::($add_ii_obj,def_mseq_attr)
     set add_ii_index $mseq_attr(3)
     unset mseq_attr
    }
    set blk_jj_obj [lindex $blk_elem_obj_list $jj]
    set add_jj_obj $block_element::($blk_jj_obj,elem_add_obj)
    if { $elem_flag == "" } \
    {
     set add_jj_index $address::($add_jj_obj,seq_no)
    } else \
    {
     array set mseq_attr $address::($add_jj_obj,def_mseq_attr)
     set add_jj_index $mseq_attr(3)
     unset mseq_attr
    }
    if { $add_jj_index < $add_ii_index } \
    {
     set blk_elem_obj_list [lreplace $blk_elem_obj_list $ii $ii \
     $blk_jj_obj]
     set blk_elem_obj_list [lreplace $blk_elem_obj_list $jj $jj \
     $blk_ii_obj]
    }
   }
  }
  __com_AddTextElements blk_elem_obj_list text_elem_list text_ldtr_arr
 }

#=======================================================================
proc UI_PB_com_ApplyMastSeqBlockElem { BLK_ELEM_OBJ_LIST args } {
  upvar $BLK_ELEM_OBJ_LIST blk_elem_obj_list
  set elem_flag [lindex $args 0]
  UI_PB_com_RetActiveBlkElems blk_elem_obj_list $elem_flag
  UI_PB_com_SortBlockElements blk_elem_obj_list $elem_flag
 }

#=======================================================================
proc UI_PB_com_CheckIFCondition { EVENT_OBJ } {
  upvar $EVENT_OBJ     event_obj
  set if_found   0 ;# Keep track of balance of IF/ELSE/END. Should be 0 at the end of a command.
  set else_found 0 ;#
  foreach row_elem_obj $event::($event_obj,evt_elem_list) \
  {
   foreach elem_obj $row_elem_obj \
   {
    set block_obj $event_element::($elem_obj,block_obj)
    if { $block::($block_obj,blk_type) == "command" } \
    {
     set cmd_blk_elem [lindex $block::($block_obj,elem_addr_list) 0]
     if { [string trim $cmd_blk_elem] != "" } \
     {
      set cmd_obj $block_element::($cmd_blk_elem,elem_mom_variable)
      set cmd_name ""
      if { [string match "MOM_*" $cmd_obj] || \
       [string match "ELSE"  $cmd_obj] || \
      [string match "END"   $cmd_obj] }  \
      {
       set cmd_name $cmd_obj
       } elseif { [string match "$::gPB(condition_cmd_prefix)*" $command::($cmd_obj,name)] } \
      {
       set cmd_name "IF($command::($cmd_obj,name))"
       } elseif { [info exists command::($cmd_obj,name)] } \
      {
       set cmd_name $command::($cmd_obj,name)
      }
      if { $cmd_name != "" } \
      {
       switch $cmd_name {
        ELSE {
         incr else_found $if_found
        }
        END  {
         if { $else_found > 0 } {
          set else_found [expr $else_found - $if_found]
         }
         incr if_found -1
        }
        default {
         if { [string match "IF(*)" $cmd_name] } {
          incr if_found
         }
        }
       }
      }
      UI_PB_debug_ForceMsg "\n %%%  cmd_name : >$cmd_name< => $if_found  %%% \n"
     } ;# $cmd_blk_elem != ""
    } ;# command
   } ;# elem_obj
  } ;# row_elem_obj
  if { $if_found == 0 && $else_found == 0 } {
   return 1
   } else {
   set msg "Conditional logic is incomplete in event handler of $event::($event_obj,event_name)!"
   UI_PB_debug_ForceMsg "\n %%% $msg %%% \n"
   tk_messageBox -parent [UI_PB_com_AskActiveWindow] -type ok -icon error \
   -message $msg
   return 0
  }
 }

#=======================================================================
proc UI_PB_com_ReturnEventNcOutAttr { EVENT_OBJ EVT_NC_WIDTH \
  EVT_NC_HEIGHT EVT_NC_OUTPUT } {
  upvar $EVENT_OBJ     event_obj
  upvar $EVT_NC_WIDTH  evt_nc_width
  upvar $EVT_NC_HEIGHT evt_nc_height
  upvar $EVT_NC_OUTPUT evt_nc_output  ;# <= This var is not created when event has no content!
  global tixOption
  global mom_sys_arr
  set evt_nc_width 0
  set evt_nc_height 0
  set temp_evt_nc_output ""
  set font $::gPB(nc_code_font)  ;# tixOption(font_sm)
  set if_indent 0
  set if_found  0 ;# Keep track of balance of IF/ELSE/END. Should be 0 at the end of a command.
  if { [info exists ::gPB(condition_indent)] } {
   set idt $::gPB(condition_indent)
   } else {
   set idt 3
  }
  foreach row_elem_obj $event::($event_obj,evt_elem_list) \
  {
   set blank_str ""
   foreach elem_obj $row_elem_obj \
   {
    set block_obj $event_element::($elem_obj,block_obj)
    if { [info exists event_element::($elem_obj,indent)] && \
     $event_element::($elem_obj,indent) > 0 } {
     for { set i 0 } { $i < $event_element::($elem_obj,indent) } { incr i } {
      append blank_str " "
     }
    }
    for { set i 0 } { $i < $if_indent } { incr i } {
     append blank_str " "
    }
    if { $block::($block_obj,blk_type) == "command" } \
    {
     set cmd_blk_elem [lindex $block::($block_obj,elem_addr_list) 0]
     if { [string trim $cmd_blk_elem] == "" } {
      continue
     }
     set cmd_obj $block_element::($cmd_blk_elem,elem_mom_variable)
     if { [string match "MOM_*" $cmd_obj] || \
      [string match "ELSE"  $cmd_obj] || \
     [string match "END"   $cmd_obj] }  \
     {
      set cmd_name $cmd_obj
     } else \
     {
      if { [string match "$::gPB(condition_cmd_prefix)*" $command::($cmd_obj,name)] } {
       set cmd_name "IF($command::($cmd_obj,name))"
       } else {
       set cmd_name $command::($cmd_obj,name)
      }
     }
     switch $cmd_name {
      ELSE {
       if { $if_found == 0 } {
        incr if_indent $idt
       }
      }
      END  {
       set if_indent [expr { $if_indent > $idt  ?  $if_indent - $idt  :  0 }]
       incr if_found -1
      }
      default {
       if { [string match "IF(*)" $cmd_name] } {
        incr if_indent $idt
        incr if_found
       }
      }
     }
     if { ($cmd_name == "ELSE" || $cmd_name == "END") } {
      if { [string length $blank_str] > $idt } {
       set blank_str [string range $blank_str $idt end]
       } else {
       set blank_str ""
      }
     }
     append temp_evt_nc_output $blank_str
     append temp_evt_nc_output $cmd_name "\n"
     set evt_nc_height [expr $evt_nc_height + [font metrics $font -linespace]]
     } elseif { $block::($block_obj,blk_type) == "comment" } \
    {
     set blk_elem [lindex $block::($block_obj,elem_addr_list) 0]
     set comm_data ""
     if { ![string match "$::gPB(tcl_line_blk)*" $block::($block_obj,block_name)] } {
      append comm_data "$mom_sys_arr(Comment_Start)"
      append comm_data $block_element::($blk_elem,elem_mom_variable)
      append comm_data "$mom_sys_arr(Comment_End)"
      } else {
      append comm_data "# $block_element::($blk_elem,elem_mom_variable)"
     }
     append temp_evt_nc_output $blank_str
     append temp_evt_nc_output $comm_data "\n"
     set evt_nc_height [expr $evt_nc_height + [font metrics $font -linespace]]
     } elseif { $block::($block_obj,blk_type) == "macro" }  {
     set func_blk_elem [lindex $block::($block_obj,elem_addr_list) 0]
     set func_obj $block_element::($func_blk_elem,elem_mom_variable)
     function::GetDisplayText $func_obj func_text
     if { [info exists block_element::($func_blk_elem,func_prefix)] && \
     $block_element::($func_blk_elem,func_prefix) != "" } \
     {
      set temp_str $block_element::($func_blk_elem,func_prefix)
      append temp_str " " $func_text
      set func_text $temp_str
      unset temp_str
     }
     append temp_evt_nc_output $blank_str
     append temp_evt_nc_output $func_text "\n"
     set evt_nc_height [expr $evt_nc_height + [font metrics $font -linespace]]
    } else \
    {
     foreach blk_elem $block::($block_obj,elem_addr_list) \
     {
      lappend row_blk_elem_list $blk_elem
     }
     append temp_evt_nc_output $blank_str
    }
   }
   if [info exists row_blk_elem_list] \
   {
    UI_PB_com_ApplyMastSeqBlockElem row_blk_elem_list
    if [info exists row_blk_nc_output] \
    {
     unset row_blk_nc_output
    }
    UI_PB_com_CreateBlkNcCode row_blk_elem_list row_blk_nc_output
    if [info exists row_blk_elem_list] \
    {
     unset row_blk_elem_list
    }
    if [info exists row_blk_nc_output] \
    {
     set evt_nc_height [expr $evt_nc_height + [font metrics $font -linespace]]
     append temp_evt_nc_output $row_blk_nc_output "\n"
     unset row_blk_nc_output
    }
   }
  }
  if 0 {
   if { $if_found != 0 } {
    set msg "Conditional logic is incomplete in event handler of $event::($event_obj,event_name)!"
    UI_PB_debug_ForceMsg "\n %%% $msg %%% \n"
    tk_messageBox -parent [UI_PB_com_AskActiveWindow] -type ok -icon error \
    -message $msg
    return 0
   }
  }
  set evt_nc_width 0
  foreach str [split $temp_evt_nc_output \n] {
   set blk_nc_width [font measure $font $str]
   if { $blk_nc_width > $evt_nc_width } {
    set evt_nc_width $blk_nc_width
   }
  }
  if { $evt_nc_width > 0 } {
   set evt_nc_width [expr $evt_nc_width + [font measure $font " "]]
   set evt_nc_output $temp_evt_nc_output
   } else {
   set evt_nc_height 0
  }
  if { $if_found != 0 } {
   set msg "Conditional logic is incomplete in event handler of $event::($event_obj,event_name)!"
   UI_PB_debug_ForceMsg "\n %%% $msg %%% \n"
   tk_messageBox -parent [UI_PB_com_AskActiveWindow] -type ok -icon error \
   -message $msg
   return 0
  }
  return 1
 }
 if 0 {

#=======================================================================
proc UI_PB_com_CreateRectangle  { page_obj x1 y1 x2 y2 \
  fill_color outline_color width tag} {
  set canvas $Page::($page_obj,bot_canvas)
  set wi $Page::($page_obj,bot_width)
  set hi $Page::($page_obj,bot_height)
  set reconf 0
  if [expr $x2 >= $wi] {
   set wi [expr $wi + 50]
   set Page::($page_obj,bot_width) $wi
   set reconf 1
  }
  if [expr $y2 >= $hi] {
   set hi [expr $hi + 50]
   set Page::($page_obj,bot_height) $hi
   set reconf 1
  }
  if $reconf {
   $canvas config -scrollregion "0 0 $wi $hi"
  }
  if [string match "" $width] {
   set width 0
  }
  if [string match "" $tag] {
   set tag stationary
  }
  if [string match "" $fill_color] {
   set rect_id [$canvas create rect $x1 $y1 $x2 $y2 \
   -outline  $outline_color \
   -width    $width \
   -tag      $tag]
   } else {
   set rect_id [$canvas create rect $x1 $y1 $x2 $y2 \
   -fill     $fill_color \
   -outline  $outline_color \
   -width    $width \
   -tag      $tag]
  }
  return $rect_id
 }
}

#=======================================================================
proc UI_PB_com_CreateRectangle  { page_obj x1 y1 x2 y2 \
  fill_color outline_color width tag } {
  set canvas $Page::($page_obj,bot_canvas)
  set wi $Page::($page_obj,bot_width)
  set hi $Page::($page_obj,bot_height)
  set reconf 0
  if [expr $x2 >= $wi] {
   set wi [expr $wi + 50]
   set Page::($page_obj,bot_width) $wi
   set reconf 1
  }
  if [expr $y2 >= $hi] {
   set hi [expr $hi + 50]
   set Page::($page_obj,bot_height) $hi
   set reconf 1
  }
  if $reconf {
   $canvas config -scrollregion "0 0 $wi $hi"
  }
  set cmd_string ""
  if { ![string match "" $fill_color] } {
   set cmd_string "$cmd_string -fill $fill_color"
  }
  if { ![string match "" $outline_color] } {
   set cmd_string "$cmd_string -outline  $outline_color"
  }
  if { ![string match "" $width] } {
   set cmd_string "$cmd_string -width $width"
  }
  if { ![string match "" $tag] } {
   set cmd_string "$cmd_string -tag $tag"
  }
  return [eval $canvas create rect $x1 $y1 $x2 $y2 $cmd_string]
 }

#=======================================================================
proc CB_nb_def { w tab_img book_obj } {
  if { $Book::($book_obj,x_def_tab_img) != 0 } \
  {
   $Book::($book_obj,x_def_tab_img) config -showbackground 0
  }
  $tab_img config -showbackground 1
  set Book::($book_obj,x_def_tab_img) $tab_img
 }

#=======================================================================
proc UI_PB_com_CreateRowAttr { column_frm row_no label mom_var data_type } {
  global tixOption
  global gPB
  set row_frm [frame $column_frm.$row_no]
  set bgc lightSkyBlue
  $row_frm config -relief solid -bd 1 -bg $bgc
  pack $row_frm -side top -fill x -expand yes
  if {[string index $label 0] == "\$"} {
   set label [set [string range $label 1 end]]
  }
  Page::CreateLblEntry $data_type $mom_var $row_frm int $label
  $row_frm.int config -bg $bgc -font $tixOption(bold_font)
 }

#=======================================================================
proc UI_PB_com_CreateCodeRowAttr { column_frm row_no label mom_var data_type args} {
  global tixOption
  set row_frm [frame $column_frm.$row_no]
  set bgc lightSkyBlue
  $row_frm config -relief solid -bd 1 -bg $bgc
  pack $row_frm -side top -fill x -expand yes
  set code_type [lindex $args 0]
  UI_PB_mthd_CreateLblCodeEntry $data_type $mom_var $row_frm int $label $code_type
  $row_frm.int config -bg $bgc -font $tixOption(bold_font)
 }

#=======================================================================
proc UI_PB_com_CheckElemBlkTemplate { BLOCK_OBJ NEW_BLK_ELEM_OBJ } {
  upvar $BLOCK_OBJ block_obj
  upvar $NEW_BLK_ELEM_OBJ new_blk_elem_obj
  if { ![string compare "Command" $block_element::($new_blk_elem_obj,elem_add_obj)] || \
  ![string compare "Macro"   $block_element::($new_blk_elem_obj,elem_add_obj)] } \
  {
   set new_blk_elem_addr $block_element::($new_blk_elem_obj,elem_add_obj)
   set new_elem_add_leader ""
  } else \
  {
   set blk_elem_add_obj $block_element::($new_blk_elem_obj,elem_add_obj)
   set new_blk_elem_addr $address::($blk_elem_add_obj,add_name)
   set new_elem_add_leader $address::($blk_elem_add_obj,add_leader)
  }
  if { [string compare $new_blk_elem_addr "Text"]    == 0 || \
   [string compare $new_blk_elem_addr "Command"] == 0 || \
  [string compare $new_blk_elem_addr "Macro"]   == 0 } \
  {
   return 0
  }
  set blk_elem_flag 0
  set add_flag [__com_CheckAddressInBlk block_obj new_blk_elem_addr]
  if { $add_flag >= 0 } \
  {
   global gPB
   tk_messageBox -parent [UI_PB_com_AskActiveWindow] \
   -type ok -icon error -message "$gPB(msg,block_exist)"
   return 1
  }
  if { $new_elem_add_leader == "G" } \
  {
  }
  if { $new_elem_add_leader == "M" } \
  {
  }
  return 0
 }

#=======================================================================
proc __com_CheckAddressInBlk { BLOCK_OBJ NEW_BLK_ELEM_ADDR } {
  upvar $BLOCK_OBJ block_obj
  upvar $NEW_BLK_ELEM_ADDR new_blk_elem_addr
  if { $block::($block_obj,active_blk_elem_list) != "" } \
  {
   PB_int_GetBlockElementAddr new_blk_elem_addr base_addr_list
   foreach blk_elem_obj $block::($block_obj,active_blk_elem_list) \
   {
    set blk_elem_addr_obj $block_element::($blk_elem_obj,elem_add_obj)
    set blk_elem_addr $address::($blk_elem_addr_obj,add_name)
    foreach address_name $base_addr_list \
    {
     if { [string compare $address_name "$blk_elem_addr"] == 0 } \
     {
      return 1
     }
     switch $address_name {
      X -
      Y -
      Z {
       switch $blk_elem_addr {
        rapid1 -
        rapid2 -
        rapid3 {
         return 1
        }
       }
      }
     }
    }
   }
  }
  return -1 ;# was 0
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
  global text_dlg_res
  global gPB
  set text_dlg_res 0
  set bot_canvas $Page::($page_obj,bot_canvas)
  set elem_text_var $block_element::($new_elem_obj,elem_mom_variable)
  set win [toplevel $bot_canvas.txtent]
  set toplevel_index [llength $gPB(toplevel_list)]
  set win_index [expr $toplevel_index + 1]
  set gPB(toplevel_disable_$win_index) 1
  set gPB(NEW_OBJ_OK) 0
  UI_PB_com_CreateTransientWindow $win \
  "$label_name $gPB(com,text_entry_trans,title,Label)" "" \
  "" "UI_PB_blk_DisableBlkPageWidgets $page_obj" "" \
  "UI_PB_com_CancelTextElem $win $page_obj $new_elem_obj; \
  UI_PB_blk_ActivateBlkPageWidgets $page_obj $win_index"
  set text_frm [frame $win.frame]
  pack $text_frm -side top -fill both -expand yes
  label $text_frm.lab -text $label_name -anchor w
  entry $text_frm.ent -textvariable elem_text_var -width 40 -relief sunken
  if 0 {
   set add_obj $block_element::($new_elem_obj,elem_add_obj)
   set fmt_obj $address::($add_obj,add_format)
   switch $format::($fmt_obj,for_dtype) \
   {
    "Numeral"     { set data_type n }
    "Text String" { set data_type s }
   }
   bind $text_frm.ent <KeyPress> "UI_PB_com_DisableSpecialKeys %W %K $data_type"
  }
  bind $text_frm.ent <KeyRelease> "%W config -state normal"
  pack $text_frm.lab -side left -fill both -padx 10 -pady 10
  pack $text_frm.ent -side right -fill x -padx 10 -pady 10 -expand yes
  focus $text_frm.ent
  $text_frm.ent select range 0 end
  bind $text_frm.ent <Return> "UI_PB_com_UpdateTextElem $win $page_obj \
  $new_elem_obj"
  set t $text_frm.ent
  set restore_cb "__blk_AddrExpRestore $t $new_elem_obj"
  bind $t <3> "UI_PB_blk_AddrExpPopup $t \"$restore_cb\" %X %Y"
  if { [info exists gPB(VIEW_ADDRESS)] && $gPB(VIEW_ADDRESS) } {
   UI_PB_com_DisableWindow $win
  }
  set label_list {"gPB(nav_button,cancel,Label)" \
  "gPB(nav_button,ok,Label)"}
  set cb_arr(gPB(nav_button,cancel,Label)) \
  "UI_PB_com_CancelTextElem $win $page_obj $new_elem_obj"
  set cb_arr(gPB(nav_button,ok,Label)) \
  "UI_PB_com_UpdateTextElem $win $page_obj $new_elem_obj"
  UI_PB_com_CreateButtonBox $win label_list cb_arr
  PB_com_unset_var ::gPB(VIEW_ADDRESS)
 }

#=======================================================================
proc UI_PB_com_DisableSpecialKeys { widget key data_type } {
  global elem_text_var
  set disable_flag 0
  switch $data_type \
  {
   "n" {
    switch $key \
    {
     "exclam"        -
     "quotedbl"      -
     "numbersign"    -
     "ampersand"     -
     "quoteright"    -
     "period"        -
     "semicolon"     -
     "less"          -
     "equal"         -
     "greater"       -
     "question"      -
     "at"            -
     "bracketleft"   -
     "backslash"     -
     "bracketright"  -
     "asciicircum"   -
     "quoteleft"     -
     "braceleft"     -
     "bar"           -
     "braceright"    -
     "asciitilde"    { set disable_flag 1 }
    }
   }
   "s" {
   }
  }
  if { $disable_flag } \
  {
   $widget config -state disabled
  }
 }

#=======================================================================
proc UI_PB_com_SpecialKeyRelease { widget key data_type } {
  global elem_text_var
  $widget config -state normal
  if { $key == "bracketleft" || $key == "bracketright" } \
  {
   set ik [$widget index insert]
   set ib [expr $ik - 2]
   set b  [string index [$widget get] $ib]
   if { $b != "\\" } \
   {
    $widget insert [expr $ib + 1] "\\"
   }
  }
 }

#=======================================================================
proc UI_PB_com_CancelTextElem { win page_obj elem_obj } {
  global gPB
  if [info exists gPB(NEW_OBJ_OK)] {
   if $gPB(NEW_OBJ_OK) {
    unset gPB(NEW_OBJ_OK)
    return
    } else {
    unset gPB(NEW_OBJ_OK)
   }
   } else {
   return
  }
  global text_dlg_res
  if { $text_dlg_res == 0 } \
  {
   set block_element::($elem_obj,elem_mom_variable) "000"
   set text_dlg_res "cancel"
  }
  destroy $win
 }

#=======================================================================
proc UI_PB_com_UpdateTextElem { win page_obj elem_obj } {
  global elem_text_var
  global text_dlg_res
  global gPB
  set add_obj $block_element::($elem_obj,elem_add_obj)
  set fmt_obj $address::($add_obj,add_format)
  set for_name $format::($fmt_obj,for_name)
  if [ UI_PB_add_ValidateExp $elem_text_var $for_name ] {
   return
  }
  set block_element::($elem_obj,elem_mom_variable) $elem_text_var
  set text_dlg_res "ok"
  set gPB(NEW_OBJ_OK) 0
  destroy $win
 }

#=======================================================================
proc UI_PB_com_RetIntFromVal { value } {
  set int_val [tixGetInt -trunc $value]
  return $int_val
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
  return $value
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
     if { $fmt_obj_attr(7) } \
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
proc UI_PB_com_CheckDupChar { widget key_type positive data_type} {
  global gPB
  set entry_val [$widget get]
  switch $key_type \
  {
   "plus"   {
    set insdx [$widget index insert]
    if [$widget select present] {
     set sel_1 [$widget index sel.first]
     set sel_2 [$widget index sel.last]
     if { $sel_1 > $sel_2 } {
      set sel $sel_1
      set sel_1 $sel_2
      set sel_2 $sel
     }
     } else {
     set sel_1 $insdx
     set sel_2 $insdx
    }
    set sel_1 [expr $sel_1 - 1]
    set sel_2 [expr $sel_2 + 1]
    set char_sel_1 [string index $entry_val $sel_1]
    set char_sel_2 [string index $entry_val $sel_2]
    set char_insdx [string index $entry_val $insdx]
    if { "$char_sel_1" == "+"  || \
     "$char_sel_1" == "-"  || \
     "$char_sel_2" == "+"  || \
     "$char_sel_2" == "-"  || \
     "$char_insdx" == "+"  || \
     "$char_insdx" == "-" } {
     return 0
    }
    return 1
   }
   "minus"  {
    if { [$widget select present] } \
    {
     set sel_f [$widget index sel.first]
     set sel_s [$widget index sel.last]
     if { $sel_f == 0 || $sel_s == 0} \
     {
      if { $positive } {
       return 0
       } else {
       return 1
      }
     }
     } elseif { [$widget index insert] == 0 && \
     [string first "+" $entry_val] == -1 &&
    [string first "-" $entry_val] == -1} \
    {
     if { $positive } {
      return 0
      } else {
      return 1
     }
    } else \
    {
     return 0
    }
   }
   "period" {
    set flag [string first "." $entry_val]
    if { $flag != -1 } \
    {
     return 0
    } else \
    {
     return 1
    }
   }
   "c"     {
    if [info exists gPB(prev_key)] {
     if {$gPB(prev_key) == "Control_L" || $gPB(prev_key) == "Control_R"} {
      return 1
      } else {
      return 0
     }
     } else {
     return 0
    }
   }
   "v"     {
    if [info exists gPB(prev_key)] {
     if {$gPB(prev_key) == "Control_L" || $gPB(prev_key) == "Control_R"} {
      set str ""
      if [catch { set str [selection get -selection CLIPBOARD] }] {
       return 0
       } else {
       return [UI_PB_com_CheckString $str $data_type]
      }
      } else {
      return 0
     }
     } else {
     return 0
    }
   }
   "x"     {
    if [info exists gPB(prev_key)] {
     if {$gPB(prev_key) == "Control_L" || $gPB(prev_key) == "Control_R"} {
      return 1
      } else {
      return 0
     }
     } else {
     return 0
    }
   }
   default {
    return 1
   }
  }
 }

#=======================================================================
proc x_UI_PB_com_CheckDupChar { widget key_type } {
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
     [string index $entry_val 0] != "+" &&
    [string index $entry_val 0] != "-" } \
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
    if { $flag != -1 } \
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
proc UI_PB_com_Validate_Control_V { w keysum ascii {obj any} } {
  global gPB
  set str [$w get]
  if { [$w selection present] } {
   set sel_first [$w index sel.first]
   set sel_end [$w index sel.last]
   set str "[string range $str 0 [expr $sel_first - 1]][string range $str $sel_end end]"
   set idx $sel_first
   } else {
   set idx [$w index insert]
  }
  if { [catch {set str_in_mem [selection get -selection CLIPBOARD]}] } {
   set temp_str "[string range $str 0 [expr $idx - 1]]$ascii[string range $str $idx end]"
   } else {
   set temp_str "[string range $str 0 [expr $idx - 1]]$str_in_mem[string range $str $idx end]"
  }
  set pattern {^[a-z0-9A-Z_]+$}
  switch $obj \
  {
   "block" \
   {
    set str_len $gPB(MOM_block_name_len)
   }
   "head" \
   {
    set str_len [expr $gPB(MOM_block_name_len) - 18]
   }
   "address" -
   "format" -
   default \
   {
    set str_len $gPB(MOM_obj_name_len)
   }
  }
  set disable_flag 0
  if ![regexp {^$} $temp_str] {
   if ![regexp $pattern $temp_str] {
    set disable_flag 1
    } elseif { [expr [string length $temp_str] > $str_len] } {
    set disable_flag 1
   }
  }
  if {$disable_flag == 1} {
   $w config -state disabled
   set gPB(Name_error) 1
  }
 }

#=======================================================================
proc UI_PB_com_Validate_Control_V_Release { w } {
  global gPB
  $w config -state normal
  if { [info exists gPB(Name_error)] && $gPB(Name_error) == 1 } {
   tk_messageBox -parent [UI_PB_com_AskActiveWindow] \
   -type ok -icon error \
   -message "$gPB(msg,control_v_limit)"
   set gPB(Name_error) 0
   focus $w
  }
 }

#=======================================================================
proc UI_PB_com_ValidateObjectName { object_name {allow_1st_underscore 0} } {
  if { !$allow_1st_underscore } {
   set pat "^\[0-9\_\]+"
   } else {
   set pat "^(\_)*\[0-9\]+"
  }
  set cmd [concat regexp -indices \{$pat\} \$object_name match]
  if { [eval $cmd] == 1 } {
   return 0
   } else {
   return 1
  }
 }

#=======================================================================
proc UI_PB_com_ErrorInvalidObjectName { } {
  tk_messageBox -parent [UI_PB_com_AskActiveWindow] -type ok -icon error \
  -message "Object name may not start with numeral(s) or underscore!"
 }

#=======================================================================
proc UI_PB_com_RestrictStringLength { widget key {obj any} } {
  global gPB
  set ent_string [$widget get]
  switch $obj \
  {
   "block" \
   {
    set str_len $gPB(MOM_block_name_len)
   }
   "head" \
   {
    set str_len [expr $gPB(MOM_block_name_len) - 18]
   }
   "address" -
   "format" -
   default \
   {
    set str_len $gPB(MOM_obj_name_len)
   }
  }
  if { [string length $ent_string] >= $str_len } \
  {
   if { [$widget selection present] == 1 && \
    [expr [string length $ent_string] - [$widget index sel.last] + [$widget index sel.first]] < $str_len } {
    } else {
    if { $key == "space" } \
    {
     set ent_sel_flag [$widget select present]
     if { $ent_sel_flag == 0 } \
     {
      $widget config -state disabled
     }
     } elseif { $key != "BackSpace" && \
    $key != "Delete" } \
    {
     $widget config -state disabled
    }
   }
  }
 }

#=======================================================================
proc UI_PB_com_DisableSpaceKey { widget key } {
  if { $key == "space" } \
  {
   if 0 {
    set ent_sel_flag [$widget select present]
    if { $ent_sel_flag == 0 } \
    {
     $widget config -state disabled
    }
   }
   $widget config -state disabled
  }
 }

#=======================================================================
proc UI_PB_com_hasSpecialChars { str } {
  if { 0 } {
   set pat "^\[a-z0-9A-Z_\.\-\]*\$"
   set cmd [concat regexp -all \{$pat\} \$str]
   if { [eval $cmd] == 0 } {
    return 1
    } else {
    return 0
   }
  }
  if { 0 } {
   regsub -all {[a-z0-9A-Z_.-]*} $str {} str2
   if { [string length $str2] > 0 } {
    return 1
    } else {
    return 0
   }
  }
  for { set i 0 } { $i < [string length $str] } { incr i } {
   set c [string index $str $i]
   if { ![string compare $c "\\"]  || \
    ![string compare $c "\/"]  || \
    ![string compare $c "\:"]  || \
    ![string compare $c "\*"]  || \
    ![string compare $c "\""]  || \
    ![string compare $c "\<"]  || \
    ![string compare $c "\>"]  || \
    ![string compare $c "\|"] } {
    return 1
   }
  }
  return 0
 }

#=======================================================================
proc UI_PB_com_DisableSpecialChars { widget key {allow_minus 0} {allow_1st_underscore 0} } {
  set disable_flag 0
  switch $key \
  {
   "percent"       -
   "apostrophe"    -
   "asterisk"      -
   "plus"          -
   "comma"         -
   "grave"         -
   "space"         -
   "dollar"        -
   "exclam"        -
   "quotedbl"      -
   "numbersign"    -
   "ampersand"     -
   "quoteright"    -
   "period"        -
   "semicolon"     -
   "less"          -
   "equal"         -
   "greater"       -
   "question"      -
   "at"            -
   "bracketleft"   -
   "slash"         -
   "backslash"     -
   "bracketright"  -
   "quoteleft"     -
   "braceleft"     -
   "bar"           -
   "braceright"    -
   "asciicircum"   -
   "asciitilde"    { set disable_flag 1 }
   "minus"         {
    if { $allow_minus == 0 } {
     set disable_flag 1
    }
   }
  }
  if { $disable_flag } \
  {
   $widget config -state disabled
   return
  }
  set icursor [$widget index insert]
  set ent_val [$widget get]
  if { !$allow_1st_underscore } {
   if { ![string compare $key "underscore"] && \
    ($icursor == 0 || \
    [string index $ent_val [expr $icursor - 1]] == "/" || \
    [string index $ent_val [expr $icursor - 1]] == "\\") } {
    set disable_flag 1
   }
  }
  set is_1st_digit 0
  scan [string index $key 0] "%c" sv
  if { $sv > "47" && $sv < "58" } {
   set is_1st_digit 1
  }
  if { $is_1st_digit && \
   ($icursor == 0 || \
   [string index $ent_val [expr $icursor - 1]] == "/" || \
   [string index $ent_val [expr $icursor - 1]] == "\\") } {
   set disable_flag 1
  }
  if { $disable_flag } \
  {
   $widget config -state disabled
  }
 }

#=======================================================================
proc UI_PB_com_DisableKeysForProc { widget key } {
  set disable_flag 0
  switch $key \
  {
   "space"         -
   "dollar"        -
   "numbersign"    -
   "semicolon"     -
   "bracketleft"   -
   "bracketright"  -
   "backslash"     -
   "asciicircum"   { set disable_flag 1 }
  }
  switch $key \
  {
   "period"        -
   "quotedbl"      -
   "braceleft"     -
   "braceright"    { set disable_flag 1 }
  }
  if { $disable_flag } \
  {
   $widget config -state disabled
  }
 }

#=======================================================================
proc UI_PB_com_ValidateDataOfEntry { widget key data_type args } {
  global gPB
  set positive 0
  if [llength $args] {
   set positive [lindex $args 0]
  }
  set ent_var ""
  catch { set ent_var [$widget cget -textvariable] }
  if { [string compare "" $ent_var] } {
   set len [string length $ent_var]
   set loc [string first "\(" $ent_var]
   if { $loc != -1 } {
    set var [string range $ent_var [expr $loc + 1] [expr $len - 2]]
   }
  }
  if { ![info exists var] } { return }
  if { [info exists gPB(tool_path_event,$var)] && $gPB(tool_path_event,$var) == 1 } {
   set data_type [UI_PB_com_RetSysVarDataType var]
  }
  set disable_flag 0
  switch $data_type \
  {
   "i" {
    if { $key >= 0 && $key <= 9 || \
     $key == "plus" || $key  == "minus" || \
     $key == "BackSpace" || $key == "Tab" || \
     $key == "Shift_R" || $key == "Shift_L" || \
     $key == "Control_L" || $key == "Control_R" || \
    $key == "c" || $key == "v" || $key == "x" || $key == "Delete"} \
    {
     set disable_flag [UI_PB_com_CheckDupChar $widget $key $positive $data_type]
    }
   }
   "f" {
    if { $key >= 0 && $key <= 9 || \
     $key == "period" || \
     $key == "plus" || $key  == "minus" || \
     $key == "BackSpace" || $key == "Tab" || \
     $key == "Shift_R" || $key == "Shift_L" || \
     $key == "Control_L" || $key == "Control_R" || \
    $key == "c" || $key == "v" || $key == "x" || $key == "Delete"} \
    {
     set disable_flag [UI_PB_com_CheckDupChar $widget $key $positive $data_type]
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
  set gPB(prev_key) $key ;#<01-11-06 peter>
 }

#=======================================================================
proc UI_PB_com_GetFomFrmAddname { add_name FMT_OBJ_ATTR } {
  upvar $FMT_OBJ_ATTR fmt_obj_attr
  global post_object
  set add_obj_list $Post::($post_object,add_obj_list)
  PB_com_RetObjFrmName add_name add_obj_list add_obj
  if { $add_obj } {
   set for_obj $address::($add_obj,add_format)
   format::readvalue $for_obj fmt_obj_attr
   } else {
   UI_PB_debug_ForceMsg "\n %%% Unknown address >$add_name<\n"
  }
 }

#=======================================================================
proc UI_PB_com_FormatCode_x { widget add_name} {
  global mom_sys_arr
  global mom_sim_arr
  global gPB
  $widget config -state normal
  UI_PB_com_GetFomFrmAddname $add_name fmt_obj_attr
  set var [$widget cget -textvariable]
  set ind [string length $var]
  set temp_var [string range $var 13 [expr $ind - 2]]
  set inp_value [$widget get]
  UI_PB_debug_ForceMsg "input value is $inp_value"
  PB_fmt_RetFmtOptVal fmt_obj_attr inp_value fmt_value
  UI_PB_debug_ForceMsg "output value is $fmt_value"
  set $var $fmt_value
  UI_PB_debug_ForceMsg "variable name is $var variable value is [set $var]"
 }

#=======================================================================
proc UI_PB_com_FormatCode { widget add_name args } {
  global mom_sys_arr
  global mom_sim_arr
  global gPB
  if {[llength $args]} {
   set gb_arr [lindex $args 0]
   set var [lindex $args 1]
   set var "\$$var"
   set format_flag [lindex $args 2]
  }
  if { ![info exists format_flag] || ![string compare "" $format_flag] } {
   set format_flag 0
  }
  $widget config -state normal
  UI_PB_com_GetFomFrmAddname $add_name fmt_obj_attr
  set tmp_var [$widget cget -textvariable]
  set inp_value [$widget get]
  UI_PB_debug_ForceMsg "input value is $inp_value"
  PB_fmt_RetFmtOptVal fmt_obj_attr inp_value fmt_value $format_flag
  UI_PB_debug_ForceMsg "output value is $fmt_value"
  set $tmp_var $fmt_value
  PB_fmt_RetValFrmFmt fmt_obj_attr fmt_value real_value
  if {[info exists gb_arr]} {
   set ${gb_arr}($var) $real_value
  }
 }

#=======================================================================
proc UI_PB_com_CheckString {str data_type} {
  set length [string length $str]
  set result 1
  for {set index 0} {$index < $length} {incr index} {
   set char [string index $str $index]
   if {$data_type == "i"} {
    if {$char < "0" || $char > "9"} {
     set result 0
     break
    }
    } elseif {$data_type == "f"} {
    if {$char < "0" || $char > "9"} {
     if {$char != "."} {
      set result 0
      break
     }
    }
   }
  }
  return $result
 }

#=======================================================================
proc UI_PB_com_HighlightTclKeywords { w } {
  if {[winfo class $w] == "Ctext"} {
   ctext::addHighlightClass $w key1 maroon4 [list append regexp regsub string subst \
   concat join lappend lindex linsert list llength lrange \
   lreplace lsearch lset lsort split expr break catch continue \
   error eval for foreach if return switch update uplevel \
   vwait while array global incr namespace proc rename set \
   unset upvar variable close file gets open puts read info \
   source cd exec exit pwd pid time clock]
   ctext::addHighlightClassForSpecialChars $w key2 red {{}}
   ctext::addHighlightClassForSpecialChars $w key3 red {[]}
   ctext::addHighlightClassForRegexp  $w key5 cyan4 {MOM_[^\n\r\s]*}
   ctext::addHighlightClassForRegexp  $w key6 RoyalBlue4 {#[^\n\r]*}
   ctext::addHighlightClassForRegexp  $w key7 red {".*"}
   ctext::addHighlightClassForRegexp  $w key8 cyan4 {PB_call_macro}
   set fnt "$::gPB(fixed_font) bold"
   ctext::highlight $w 1.0 end $fnt
  }
}

#=======================================================================
proc UI_PB_com_HighlightDefKeywords {w} {
  if {[winfo class $w] == "Ctext"} {
   ctext::addHighlightClass $w key1 maroon4 [list FORMAT ADDRESS WORD_SEPARATOR \
   END_OF_LINE SEQUENCE FORCE MAX MIN LEADER ZERO_FORMAT \
   BLOCK_TEMPLATE INCLUDE]
   ctext::addHighlightClassForSpecialChars $w key2 red {{}}
   ctext::addHighlightClassForSpecialChars $w key3 red {[]}
   ctext::addHighlightClassForRegexp $w key4 DarkOrchid3 {mom_[^\n\r\s\(\)\]]*}
   set fnt "$::gPB(fixed_font) bold"
   ctext::highlight $w 1.0 end $fnt
  }
 }

#=======================================================================
proc UI_PB_com_HighlightUdeKeywords {w} {
  if { ![string compare [winfo class $w] "Ctext"] } {
   ctext::addHighlightClass $w key1 maroon4 [list EVENT PARAM UI_LABEL \
   TOGGLE DEFVAL TYPE OPTIONS POST_EVENT CATEGORY \
   CYCLE SYS_CYCLE UI_HELP FILE]
   ctext::addHighlightClassForSpecialChars $w key2 red {{}}
   ctext::addHighlightClassForSpecialChars $w key3 blue {""}
   set fnt "$::gPB(fixed_font) bold"
   ctext::highlight $w 1.0 end $fnt
  }
 }

#=======================================================================
proc UI_PB_com_SelectLanguage { lan } {
  global gPB LanMapTable env
  if [string match [msgcat::mclocale] $lan] {
   return
  }
  set topwin $gPB(top_window)
  if [winfo exists .widget.new] {
   destroy .widget.new
  }
  set children [tixDescendants $topwin]
  UI_PB_com_SetLanMapTable
  set gPB(LANG) $lan
  if [string match pb_msg_english $gPB(LANG)] {
   set gPB(localization) 0
   } else {
   set gPB(localization) 1
  }
  source $env(PB_HOME)/app/ui/ui_pb_language.tcl
  source $env(PB_HOME)/app/ui/ui_pb_fonts.tcl
  global tixOption paOption
  set tixOption(font)           $gPB(font)
  set tixOption(font_sm)        $gPB(font_sm)
  set tixOption(bold_font)      $gPB(bold_font)
  set tixOption(bold_font_lg)   $gPB(bold_font_lg)
  set tixOption(italic_font)    $gPB(italic_font)
  set tixOption(fixed_font)     $gPB(fixed_font)
  set tixOption(fixed_font_sm)  $gPB(fixed_font_sm)
  option add *font $tixOption(bold_font) $tixOption(prioLevel)
  option add *Label.font                    $tixOption(font)
  option add *Menu.font                     $tixOption(bold_font)
  option add *Checkbutton.font              $tixOption(font)
  option add *Radiobutton.font              $tixOption(font)
  option add *Entry.font                    $tixOption(font)
  option add *TixOptionMenu.label.font      $tixOption(font)
  option add *TixLabelFrame.label.font      $tixOption(italic_font)
  option add *TixLabelEntry.label.font      $tixOption(font)
  set style_normal_index  [lsearch -exact $gPB(sys_font_style) $gPB(font_style_normal)]
  set gPB(sys_font_style) [lreplace $gPB(sys_font_style) $style_normal_index $style_normal_index]
  set style_bold_index    [lsearch -exact $gPB(sys_font_style) $gPB(font_style_bold)]
  set gPB(sys_font_style) [lreplace $gPB(sys_font_style) $style_bold_index $style_bold_index]
  set gPB(font_style_normal) [tixDisplayStyle imagetext \
  -bg $paOption(tree_bg) -padx 4 -pady 1 -font $tixOption(font) \
  -selectforeground blue -selectbackground lightblue]
  set gPB(font_style_bold) [tixDisplayStyle imagetext \
  -bg $paOption(tree_bg) -padx 4 -pady 2 -font $tixOption(bold_font) \
  -selectforeground blue -selectbackground lightblue]
  lappend gPB(sys_font_style) $gPB(font_style_normal) $gPB(font_style_bold)
  foreach child $children {
   switch -- [winfo class $child] {
    Toplevel {
     if { [info exists LanMapTable($child)] } {
      wm title $child [set $LanMapTable($child)]
      } elseif { $child == ".widget" } {
      set vi  [string last "." $gPB(Postbuilder_Version)]
      set ver [string range $gPB(Postbuilder_Version) 0 [expr $vi - 1]]
      set ver [expr $ver - 1999.0]
      set ext [string range $gPB(Postbuilder_Version) $vi end]
      if { [info exists gPB(Postbuilder_Release_Version)] && $gPB(Postbuilder_Release_Version) != "" } {
       set release_version $gPB(Postbuilder_Release_Version)
       } else {
       set release_version $ver$ext
      }
      set gPB(Postbuilder_Release) "$gPB(main,title,UG)/$gPB(main,title,Post_Builder)\
      $gPB(main,title,Version) $release_version"
      set title $gPB(Postbuilder_Release)
      if { $gPB(PB_LICENSE) == "UG_POST_AUTHOR" } {
       if { $::disable_internal_user_lc || $::disable_license_win_title } {
        set title $title
        } else {
        set title "$title - $gPB(main,title,license_control)"
       }
      }
      wm title $child $title
      if { [info exists env(MULTI_INTERP)] && $env(MULTI_INTERP) == 1 } {
       set gPB(def_title) $title
      }
     }
    }
    Label    {
     if ![string match $child ".widget.f3.status"] {
      if [string match $child ".widget.new.top.level1.name"] {
       $child config -text [format "%-10s" "$gPB(new,name,Label)"] \
       -font $gPB(bold_font)
       } else {
       if [info exists LanMapTable($child)] {
        $child config -text [set $LanMapTable($child)]
        if {[string match ".widget.new.top.level5.left.bottom.label" $child] || \
         [string match ".widget.new.top.level5.left.top.label" $child] || \
         [string match ".widget.new.top.level3.lbf.label" $child]} {
         $child config -font $gPB(italic_font)
         } else {
         $child config -font $gPB(bold_font)
        }
       }
      }
      } else {
      $child config -font $gPB(bold_font)
      set gPB(menu_bar_status) $gPB(main,default,Status)
     }
    }
    Button   {
     if { [info exists LanMapTable($child)] } {
      $child config -text [set $LanMapTable($child)] \
      -font $gPB(bold_font)
     }
    }
    Menubutton {
     if { [info exists LanMapTable($child)] } {
      $child config -text [set $LanMapTable($child)] \
      -font $gPB(bold_font)
      if ![string match ".widget.new.*" $child] {
       if {$gPB(localization) == 0} {
        $child config -underline 0
        } else {
        $child config -underline -1
       }
      }
     }
    }
    Menu     {
     set Last [$child index last]
     if {$Last != "none"} {
      for {set i 0} {$i <= $Last} {incr i} {
       set type [$child type $i]
       if {$type != "tearoff" && $type != "separator"} {
        if ![string match $child ".widget.f.mb.option.m.lan"] {
         if [info exists LanMapTable($child,$i)] {
          $child entryconfigure $i -label [set $LanMapTable($child,$i)] \
          -font $gPB(bold_font)
          if ![string match ".widget.new.*" $child] {
           if {$gPB(localization) == 0} {
            if [string match "Save As*" \
            [set $LanMapTable($child,$i)]] {
             $child entryconfigure $i -underline 1
            } elseif [string match "Exit" \
            [set $LanMapTable($child,$i)]] {
             $child entryconfigure $i -underline 1
            } elseif [string match "Browse Licenses" \
            [set $LanMapTable($child,$i)]] {
             $child entryconfigure $i -underline 7
            } elseif [string match "Acknowledgements" \
            [set $LanMapTable($child,$i)]] {
             $child entryconfigure $i -underline 1
             } else {
             $child entryconfigure $i -underline 0
            }
            } else {
            $child entryconfigure $i -underline -1
           }
          }
         }
         if [string match $child ".widget.f.mb.file.m.posts_list"] {
          if { $i == $Last } {
           $child entryconfigure $i \
           -label [set gPB(nav_button,manage,Label)] \
           -font $gPB(bold_font)
           } elseif { [$child type $i] != "separator" } {
           $child entryconfigure $i -font $gPB(bold_font)
          }
         }
         } else {
         set val [lindex [$child entryconfigure $i -value] end]
         if { $gPB(localize_lan_menu_item) != 0 } {
          $child entryconfigure $i -label [set gPB($val)] \
          -font $gPB(bold_font)
          } else {
          $child entryconfigure $i -font $gPB(bold_font)
         }
        }
       }
      }
     }
    }
    TixLabelFrame {
     if { [info exists LanMapTable($child)] } {
      set lbl [$child subwidget label]
      $lbl config -font $gPB(italic_font)
      $child config -label [set $LanMapTable($child)]
     }
    }
    Radiobutton {
     if { [info exists LanMapTable($child)] } {
      $child config -text [set $LanMapTable($child)] \
      -font $gPB(font)
     }
    }
   }
  }
  PB_com_unset_var LanMapTable
 }

#=======================================================================
proc UI_PB_com_SetLanMapTable {} {
  global LanMapTable
  set LanMapTable(.widget.f.mb.file)     gPB(main,file,Label)
  set LanMapTable(.widget.f.mb.file.m,0) gPB(main,file,new,Label)
  set LanMapTable(.widget.f.mb.file.m,1) gPB(main,file,open,Label)
  set LanMapTable(.widget.f.mb.file.m,3) gPB(nav_button,save,Label)
  set LanMapTable(.widget.f.mb.file.m,4) gPB(main,file,save_as,Label)
  set LanMapTable(.widget.f.mb.file.m,5) gPB(main,file,close,Label)
  set LanMapTable(.widget.f.mb.file.m,7) gPB(main,file,exit,Label)
  set LanMapTable(.widget.f.mb.file.m,9)  gPB(main,file,properties,Label)
  set LanMapTable(.widget.f.mb.file.m,10) gPB(main,file,history,Label)
  set LanMapTable(.widget.f.mb.help) gPB(main,help,Label)
  set LanMapTable(.widget.f.mb.help.m,0) gPB(tool,bal,Label)
  set LanMapTable(.widget.f.mb.help.m,1) gPB(tool,chelp,Label)
  if { [llength [info commands UIPB__createGauge]] == 0 } {
   set LanMapTable(.widget.f.mb.help.m,3) gPB(main,help,dialog,Label)
   set LanMapTable(.widget.f.mb.help.m,4) gPB(main,help,manual,Label)
   set LanMapTable(.widget.f.mb.help.m,6) gPB(main,help,about,Label)
   if { [info exists ::gPB(release_notes)] } {
    set LanMapTable(.widget.f.mb.help.m,7) gPB(main,help,rel_note,Label)
    set LanMapTable(.widget.f.mb.help.m,9) gPB(main,help,tcl_man,Label)
    } else {
    set LanMapTable(.widget.f.mb.help.m,8) gPB(main,help,tcl_man,Label)
   }
   } else {
   set LanMapTable(.widget.f.mb.help.m,3) gPB(main,help,manual,Label)
   set LanMapTable(.widget.f.mb.help.m,5) gPB(main,help,about,Label)
   if { [info exists ::gPB(release_notes)] } {
    set LanMapTable(.widget.f.mb.help.m,6) gPB(main,help,rel_note,Label)
    set LanMapTable(.widget.f.mb.help.m,8) gPB(main,help,tcl_man,Label)
    } else {
    set LanMapTable(.widget.f.mb.help.m,7) gPB(main,help,tcl_man,Label)
   }
  }
  set LanMapTable(.widget.f.mb.window) gPB(main,windows,Label)
  set LanMapTable(.widget.f.mb.option) gPB(main,options,Label)
  set LanMapTable(.widget.f.mb.option.m,0) gPB(main,options,cmd_check,Label)
  set LanMapTable(.widget.f.mb.option.m,2) gPB(main,options,backup,Label)
  set LanMapTable(.widget.f.mb.option.m,4) gPB(ude,editor,enable,Label)
  set LanMapTable(.widget.f.mb.option.m,6) gPB(language,Label)
  set LanMapTable(.widget.f.mb.option.m,8) gPB(main,options,debug,Label)
  set LanMapTable(.widget.f.mb.option.m.opts,1) gPB(main,options,cmd_check,command,Label)
  set LanMapTable(.widget.f.mb.option.m.opts,2) gPB(main,options,cmd_check,block,Label)
  set LanMapTable(.widget.f.mb.option.m.opts,3) gPB(main,options,cmd_check,address,Label)
  set LanMapTable(.widget.f.mb.option.m.opts,4) gPB(main,options,cmd_check,format,Label)
  set LanMapTable(.widget.f.mb.option.m.bck,0) gPB(main,options,backup,one,Label)
  set LanMapTable(.widget.f.mb.option.m.bck,1) gPB(main,options,backup,all,Label)
  set LanMapTable(.widget.f.mb.option.m.bck,2) gPB(main,options,backup,none,Label)
  set LanMapTable(.widget.f.mb.option.m.ude,0) gPB(nav_button,yes,Label)
  set LanMapTable(.widget.f.mb.option.m.ude,1) gPB(nav_button,no,Label)
  set LanMapTable(.widget.f.mb.option.m.ude,2) gPB(ude,editor,enable,as_saved,Label)
  set LanMapTable(.widget.f.mb.util) gPB(main,utils,Label)
  set LanMapTable(.widget.f.mb.util.m,0) gPB(main,utils,etpdf,Label)
  set LanMapTable(.widget.f.mb.util.m,2) gPB(main,utils,bmv,Label)
  set LanMapTable(.widget.f.mb.util.m,4) gPB(main,utils,blic,Label)
  set LanMapTable(.widget.new) gPB(new,title,Label)
  set LanMapTable(.widget.new.box.act_0) gPB(nav_button,ok,Label)
  set LanMapTable(.widget.new.box.act_1) gPB(ude,editor,dlg,cnl,Label)
  set LanMapTable(.widget.new.top.level2.lab) gPB(machine,info,desc,Label)
  set LanMapTable(.widget.new.top.level3.lbf) gPB(new,post_unit,Label)
  set LanMapTable(.widget.new.top.level3.lbf.border.frame.inch) gPB(new,inch,Label)
  set LanMapTable(.widget.new.top.level3.lbf.border.frame.mm) gPB(new,millimeter,Label)
  set LanMapTable(.widget.new.top.level3.lbf.label) gPB(new,post_unit,Label)
  set LanMapTable(.widget.new.top.level5.left.top) gPB(machine,display_trans,title,Label)
  set LanMapTable(.widget.new.top.level5.left.top.border.frame.mill) gPB(ude,editor,eventdlg,EC_MILL,Label)
  set LanMapTable(.widget.new.top.level5.left.top.border.frame.lathe) gPB(ude,editor,eventdlg,EC_LATHE,Label)
  set LanMapTable(.widget.new.top.level5.left.top.border.frame.wedm) gPB(new,wire,Label)
  set LanMapTable(.widget.new.top.level5.left.top.border.frame.punch) gPB(new,punch,Label)
  set LanMapTable(.widget.new.top.level5.left.top.border.frame.axis.frame.menubutton) gPB(new,mill_3,Label)
  set LanMapTable(.widget.new.top.level5.left.top.border.frame.axis.frame.menubutton.menu,0) gPB(new,mill_3,Label)
  set LanMapTable(.widget.new.top.level5.left.top.border.frame.axis.frame.menubutton.menu,1) gPB(new,mill_3MT,desc,Label)
  set LanMapTable(.widget.new.top.level5.left.top.border.frame.axis.frame.menubutton.menu,2) gPB(new,mill_4T,Label)
  set LanMapTable(.widget.new.top.level5.left.top.border.frame.axis.frame.menubutton.menu,3) gPB(new,mill_4H,Label)
  set LanMapTable(.widget.new.top.level5.left.top.border.frame.axis.frame.menubutton.menu,4) gPB(new,mill_5HH,Label)
  set LanMapTable(.widget.new.top.level5.left.top.border.frame.axis.frame.menubutton.menu,5) gPB(new,mill_5TT,Label)
  set LanMapTable(.widget.new.top.level5.left.top.border.frame.axis.frame.menubutton.menu,6) gPB(new,mill_5HT,Label)
  set LanMapTable(.widget.new.top.level5.left.top.label) gPB(machine,display_trans,title,Label)
  set LanMapTable(.widget.new.top.level5.left.bottom) gPB(machine,info,controller,Label)
  set LanMapTable(.widget.new.top.level5.left.bottom.border.frame.type.g) gPB(new,generic,Label)
  set LanMapTable(.widget.new.top.level5.left.bottom.border.frame.type.s) gPB(new,library,Label)
  set LanMapTable(.widget.new.top.level5.left.bottom.border.frame.type.u) gPB(new,user,Label)
  set LanMapTable(.widget.new.top.level5.left.bottom.border.frame.user.but) gPB(new,user,browse,Label)
  set LanMapTable(.widget.new.top.level5.left.bottom.label) gPB(machine,info,controller,Label)
 }

#=======================================================================
proc UI_PB_com_CopyVarDataFromMasterInterp { subpid } {
  uplevel #0 {
   set VAR_DATA [list]
   set a [list gPB(LANG) disable_license disable_internal_user_lc \
   gPB(PB_SITE_ID) gPB(LANG) gPB(PB_LICENSE) gPB(lic_list) \
   gPB(FORCE_SYNTAX_CHECK) gPB(LOG_MSG_ENABLED) gPB(Runtime_Log) \
   gPB(Session_Log) gPB(localization) tixOption gPB(screen_width) \
   auto_path gPB(active_window_list) gPB(active_window) gPB(top_window) \
   gPB(main_window) gPB(main_window_disabled) gPB(def_title) \
   gPB(toplevel_list) gPB(help_win_id) gPB(native_dialog_present) gPB(screen_width) \
   gPB(screen_height) gPB(TOP_WIN_HI) gPB(entry_color) gPB(backup_method) \
   gPB(use_info) gPB(WIN_X) gPB(WIN_Y) gPB(no_output_events_list) gPB(check_box_status) \
   gPB(check_cc_syntax_error) gPB(check_cc_unknown_block) gPB(check_cc_unknown_command) \
   gPB(check_cc_unknown_format) gPB(check_cc_unknown_address) gPB_help_tips \
   gPB_use_balloons gPB(action) gPB(help_tool) gPB(c_help,tool_button) gPB(use_bal)]
   if { [string match $gPB(action) "new"] } {
    set a [concat $a [list pb_output_file output_unit gPB(new_machine_type) mach_axis \
    gPB(mach_sys_controller) mach_cntl_type ude_enable]]
    if { [string match $::mach_cntl_type "User"] } {
     set a [concat $a [list gPB(mach_user_controller)]]
    }
    } else {
    set a [concat $a [list gPB(o_file_name) gPB(o_dlg_id) gPB(o_args)]]
    if { [string match $gPB(action) "cmd_line_pui"] } {
     set a [concat $a [list gPB(CMD_LINE_PUI) gPB(auto_qc)]]
    }
   }
   if { [info exists gPB(open_files_list)] } {
    set a [concat $a [list gPB(open_files_list)]]
   }
   foreach one $a {
    if { [array exists $one] } {
     foreach n [array names $one] {
      lappend VAR_DATA [list ${one}($n) [set ${one}($n)]]
     }
     } else {
     lappend VAR_DATA [list ${one} [set ${one}]]
    }
   }
   unset a
   unset one
   unset n
  }
  foreach one $::VAR_DATA {
   set str "set [lindex $one 0] [list [lindex $one 1]]"
   comm::comm send $subpid [list eval $str]
  }
 }

#=======================================================================
proc UI_PB_com_CopyInterp { } {
  global env gPB
  comm::comm send $gPB(master_pid) [list UI_PB_com_CopyVarDataFromMasterInterp [comm::comm self]]
  uplevel #0 {
   source $env(PB_HOME)/app/ui/ui_pb_language.tcl
   source $env(PB_HOME)/app/ui/ui_pb_fonts.tcl
   __SetOptions
   __CreateStyle
  }
  toplevel .widget
  wm withdraw .widget
 }

#=======================================================================
proc UI_PB_com_Action {} {
  global gPB
  set cmd_str {if {$PID(activated) != ""} {set PID($PID(activated),title) \
   [wm title $gPB(top_window)]}}
   comm::comm send $gPB(master_pid) [list eval $cmd_str]
   if [string match $gPB(action) "new"] {
    __NewPost_mod .widget.new
    comm::comm send -async $gPB(master_pid) [list __ChangeTopWinTitle $gPB(def_title)]
    } else {
    set ret_cod [UI_PB_file_EditPost_mod $gPB(o_dlg_id) $gPB(o_file_name) $gPB(o_args)]
    if ![string match $gPB(action) "cmd_line_pui"] {
     comm::comm send $gPB(master_pid) [list set ::ret_cod $ret_cod]
     UI_PB_DestroyProgress
     if [string match $ret_cod TCL_ERROR] {
      if [string match windows $::tcl_platform(platform)] {
       exec taskkill /f /pid [pid]
       } else {
       exec kill [pid]
      }
     }
    }
   }
   global post_object
   if [string match $gPB(action) "new"] {
    set post_name $Post::($post_object,out_pui_file)
    } else {
    set post_name "$Post::($post_object,output_dir)/$Post::($post_object,out_pui_file)"
   }
   if {![info exists ret_cod] || $ret_cod != "TCL_ERROR"} {
    comm::comm send $gPB(master_pid) \
    [list UI_PB_com_UpdateWindowsMenu [comm::comm self] $post_name add]
   }
   PB_init_balloons -state $gPB(use_bal)
   if [string match $gPB(action) "cmd_line_pui"] {
    comm::comm send $gPB(master_pid) [list set ::ret_cod $ret_cod]
   }
  }

#=======================================================================
proc UI_PB_com_UpdateWindowsMenu {sub_pid post_name type} {
  global gPB PID
  if { $type == "add" } {
   if {$PID(activated) != ""} {
    comm::comm send -async $PID(activated) { wm withdraw $gPB(main_window) }
   }
   set PID(activated) $sub_pid
   lappend PID(posts_list) $sub_pid
   lappend PID(posts_name_list) $post_name
   } elseif { $type == "delete" } {
   set idx [lsearch $PID(posts_list) $sub_pid]
   set PID(posts_list) [lreplace $PID(posts_list) $idx $idx]
   set PID(posts_name_list) [lreplace $PID(posts_name_list) $idx $idx]
   if { [llength $PID(posts_list)] != 0 } {
    set PID(activated) [lindex $PID(posts_list) 0]
    comm::comm send -async $PID(activated) {wm deiconify $gPB(main_window)}
    if [info exists PID($PID(activated),title)] {
     wm title $gPB(top_window) $PID($PID(activated),title)
    }
    } else {
    set PID(activated) ""
   }
   } elseif { $type == "update" } {
   set idx [lsearch $PID(posts_list) $sub_pid]
   set PID(posts_name_list) [lreplace $PID(posts_name_list) $idx $idx $post_name]
  }
  __main_AddWindowsMenu
  set PID(cur_pid) $PID(activated)
 }

#=======================================================================
proc UI_PB_com_ChangeCHelpState {st} {
  global gPB
  if [info exists gPB(master_pid)] {
   comm::comm send -async $gPB(master_pid) [list UI_PB_com_ChangeCHelpState_mod $st]
   } else {
   UI_PB_com_ChangeCHelpState_mod $st
  }
 }

#=======================================================================
proc UI_PB_com_ChangeCHelpState_mod {st} {
  global gPB
  $gPB(c_help,tool_button) config -state $st
  $gPB(main_menu_bar).help.m entryconfigure $gPB(menu_index,help,chelp) -state $st
 }

#=======================================================================
proc UI_PB_com_DisableProcess { } {
  if { ![winfo exists .dummy] } {
   toplevel .dummy
   wm withdraw .dummy
  }
  grab .dummy
 }

#=======================================================================
proc UI_PB_com_EnableProcess { } {
  if [winfo exists .dummy] {
   grab release .dummy
   destroy .dummy
  }
 }

#=======================================================================
proc UI_PB_com_CanBeOverwrited { pid pui_file } {
  global PID
  set idx [lsearch $PID(posts_name_list) $pui_file]
  if {$idx < 0} {
   return 1
   } else {
   set co_pid [lindex $PID(posts_list) $idx]
   if {$co_pid == $pid} {
    return 1
    } else {
    return 0
   }
  }
 }

#=======================================================================
proc UI_PB_com_DisableXButton {win} {
  global gPB
  foreach one $gPB(toplevel_list) {
   if { $one != $win } {
    if ![info exists gPB(sens,wm_str,$one)] {
     set gPB(sens,wm_str,$one) [wm protocol $one WM_DELETE_WINDOW]
     wm protocol $one WM_DELETE_WINDOW [list set dummy dummy]
    }
   }
  }
  set one .widget.new
  if [winfo exists $one] {
   if {$one != $win} {
    if ![info exists gPB(sens,wm_str,$one)] {
     set gPB(sens,wm_str,$one) [wm protocol $one WM_DELETE_WINDOW]
     wm protocol $one WM_DELETE_WINDOW [list set dummy dummy]
    }
   }
  }
 }

#=======================================================================
proc UI_PB_com_EnableXButton {win} {
  global gPB
  set one [lindex $gPB(toplevel_list) end]
  if { $one != $win } {
   if [info exists gPB(sens,wm_str,$one)] {
    wm protocol $one WM_DELETE_WINDOW $gPB(sens,wm_str,$one)
    unset gPB(sens,wm_str,$one)
   }
  }
  set one .widget.new
  if { [winfo exists $one] } {
   if [info exists gPB(sens,wm_str,$one)] {
    wm protocol $one WM_DELETE_WINDOW $gPB(sens,wm_str,$one)
    unset gPB(sens,wm_str,$one)
   }
  }
 }

#=======================================================================
proc UI_PB_com_RemoveTab { inp_line RET_LINE } {
  upvar $RET_LINE ret_line
  set BLANKS_4_TAB 4
  set sl [string length $inp_line]
  set ret_line ""
  for { set i 0 } { $i < $sl } { incr i } {
   set c [string index $inp_line $i]
   scan "$c" "%c" sv
   if { $sv == "9" } {
    set sv 32
    set s [format "%c" $sv]
    for { set j 1 } { $j <= $BLANKS_4_TAB } { incr j } {
     append ret_line $s
    }
    } else {
    append ret_line $c
   }
  }
 }
