global gPB tixOption
set gPB(c_help,font)    $tixOption(font_sm)
set gPB(c_help,width)   300
set gPB(c_help,color)   cyan
set gPB(c_help,state)   1

#=======================================================================
proc UI_PB_chelp_SetContextHelp {} {
  global gPB PID
  UI_PB_chelp_SetContextHelp_mod
  if {[info exists PID(activated)] && $PID(activated) != ""} {
   comm::comm send $PID(activated) [list set gPB(help_sel_var) $gPB(help_sel_var)]
   comm::comm send $PID(activated) [list set gPB(use_info) $gPB(use_info)]
   comm::comm send $PID(activated) [list UI_PB_chelp_SetContextHelp_mod]
  }
 }

#=======================================================================
proc UI_PB_chelp_SetContextHelp_mod {} {
  global gPB
  global paOption
  global gPB_use_balloons
  set idx [lsearch $gPB(help_sel_var) inf]
  if { $gPB(use_info) && $idx >= 0 } \
  {
   } elseif { !$gPB(use_info) && $idx < 0 } \
  {
  } else \
  {
   if { $gPB(use_info) } \
   {
    set gPB(help_sel_var) [linsert $gPB(help_sel_var) 1 inf]
   } else \
   {
    set gPB(help_sel_var) [lreplace $gPB(help_sel_var) $idx $idx]
   }
   set idx [lsearch $gPB(help_sel_var) inf]
  }
  global gPB_help_tips
  if { $gPB(use_info) && $idx >= 0 } \
  {
   UI_PB_debug_DisplayMsg "===> Context Help ON <==="
   set gPB_use_balloons 0
   set gPB_help_tips(state) 0
   __turn_on_CSH $gPB(top_window)
   if ![info exists gPB(master_pid)] {
    __displayChelpIndicator
    } else {
    if ![string compare $::tix_version 8.4] {
     bind all <MouseWheel> {}
     bind all <Shift-MouseWheel> {}
     if {[bind all <Enter>] != ""} {
      set ::is_mouse_wheel_enabled 1
      } else {
      set ::is_mouse_wheel_enabled 0
     }
     bind all <Enter> {}
    }
   }
   } elseif { !$gPB(use_info) && $idx < 0 } \
  {
   UI_PB_debug_DisplayMsg  "<=== Context Help OFF ===>"
   __turn_off_CSH $gPB(top_window)
   set gPB_use_balloons $gPB(use_bal)
   set gPB_help_tips(state) $gPB(use_bal)
   if ![string compare $::tix_version 8.4] {
    bind all <MouseWheel> {UI_PB_mthd_MouseWheel %W %D %X %Y}
    bind all <Shift-MouseWheel> {UI_PB_mthd_MouseWheel %W %D %X %Y x}
    if {$::is_mouse_wheel_enabled == 1} {
     tk_focusFollowsMouse
     } else {
     bind all <Enter> ""
    }
   }
   if ![info exists gPB(master_pid)] {
    destroy $gPB(CSH_msg)
   }
  }
 }

#=======================================================================
proc __displayChelpIndicator {} {
  global gPB
  set gPB(CSH_msg) [UI_PB_com_AskActiveWindow].csh
  set win $gPB(CSH_msg)
  toplevel $win
  set x [expr 20 + [winfo pointerx .]]
  set y [expr 20 + [winfo pointery .]]
  if ![string compare $::tix_version 8.4] {
   if {$::tcl_platform(platform) == "windows"} {
    wm attributes $win -topmost 1
   }
   bind all <MouseWheel> {}
   bind all <Shift-MouseWheel> {}
   if {[bind all <Enter>] != ""} {
    set ::is_mouse_wheel_enabled 1
    } else {
    set ::is_mouse_wheel_enabled 0
   }
   bind all <Enter> {}
  }
  UI_PB_com_CreateTransientWindow $win "$gPB(main,help,chelp,Label)" "+$x+$y" \
  "__constructChelpIndicator $win" "" \
  "" "__dismissChelpIndicator" 0
  UI_PB_com_DismissActiveWindow $win
  wm resizable $gPB(CSH_msg) 0 0
  UI_PB_com_PositionWindow $win
 }

#=======================================================================
proc __constructChelpIndicator { win } {
  global gPB
  frame $win.f -relief sunken -bd 2 -bg $gPB(entry_color)
  pack $win.f -fill both -expand yes
  frame $win.f.b -bg skyBlue
  pack $win.f.b -padx 7 -pady 6
  label $win.f.b.l -text "$gPB(main,help,chelp,Context)" -font $gPB(bold_font) \
  -fg yellow -bg blue
  pack $win.f.b.l -padx 2 -pady 2
  frame $win.fb -relief sunken -bd 1 -takefocus 1 \
  -highlightcolor black -highlightthickness 1
  pack $win.fb -pady 5
  button $win.fb.b -text "$gPB(nav_button,cancel,Label)" \
  -command "__dismissChelpIndicator" -takefocus 0
  set img_id [image create compound -window $win.fb.b -padx 5]
  $img_id add text -text "$gPB(nav_button,cancel,Label)"
  $img_id add space -width 5
  $img_id add image -image [tix getimage pb_info]
  $win.fb.b config -image $img_id
  unset img_id
  pack $win.fb.b -side bottom -padx 1 -pady 1
 }

#=======================================================================
proc __dismissChelpIndicator {} {
  global gPB
  set idx [lsearch $gPB(help_sel_var) inf]
  if { $idx >= 0 } {
   set gPB(help_sel_var) [lreplace $gPB(help_sel_var) $idx $idx]
  }
 }

#=======================================================================
proc __turn_on_CSH { w } {
  UI_PB_debug_DisplayMsg  " turn on CSH"
  global gPB
  global paOption
  set top_win $gPB(top_window)
  set act_win [UI_PB_com_AskActiveWindow]
  if {[info exists gPB(main_window)] && [winfo exists $gPB(main_window)]} {
   if [string match $act_win $gPB(main_window)] {
    set wlist [UI_PB_com_GetWidgetsToSwitchState]
    set book_ids_aname [array names Book:: *book_id]
    foreach one $book_ids_aname {
     set book_id $Book::($one)
     lappend wlist [$book_id subwidget nbframe]
    }
    } else {
    set wlist [tixDescendants $act_win]
   }
   } else {
   set wlist [tixDescendants $w]
  }
  if {![string match $act_win $gPB(top_window)] && [lsearch $wlist $top_win] < 0} {
   if [info exists gPB(top_window_children)] {
    set wlist [concat $wlist $gPB(top_window_children)]
   }
  }
  if [info exists gPB(master_pid)] {
   UI_PB_com_DisableXButton .dummy
  }
  for {set j 0} {$j < [llength $wlist]} {incr j} \
  {
   set witem [lindex $wlist $j]
   if { $witem == "$gPB(help_tool)" } \
   { continue }
   set wclass [winfo class $witem]
   if 0 {
    if { $wclass == "Toplevel"  || \
     $wclass == "TixFileSelectDialog"  || \
     $wclass == "TixExFileSelectDialog" } {
     set cur_win $witem
    }
    if { [info exists cur_win] && $cur_win != "$top_win"  &&  $cur_win != "$act_win" } \
    { continue }
   }
   set tlw [winfo toplevel $witem]
   if { $tlw != "$top_win"  &&  $tlw != "$act_win" } \
   { continue }
   UI_PB_debug_DisplayMsg "Widget Class == $wclass   $witem   $tlw" no_debug
   switch -exact -- $wclass \
   {
    Label {
     continue
    }
    Scrollbar {
     continue
    }
    Checkbutton -
    Radiobutton {
     set gPB(c_help,state,$witem)   [lindex [$witem config -state] end]
     set gPB(c_help,<Enter>,$witem) [bind $witem <Enter>]
     set gPB(c_help,<Leave>,$witem) [bind $witem <Leave>]
     set gPB(c_help,dfgclr,$witem)  [lindex [$witem config -disabledforeground] end]
     set bgc [lindex [$witem config -bg] end]
     if [string match "normal" $gPB(c_help,state,$witem)] {
      set fgc [lindex [$witem config -fg] end]
      } else {
      set fgc [lindex [$witem config -disabledforeground] end]
     }
     $witem config -state disabled -disabledforeground $fgc
     bind $witem <Enter> "$witem config -bg $paOption(focus) -disabledforeground black"
     bind $witem <Leave> "$witem config -bg $bgc -disabledforeground $fgc"
    }
    Entry {
     set gPB(c_help,state,$witem) [lindex [$witem config -state] end]
     set gPB(c_help,<Key>,$witem)        [bind $witem <Key>]
     set gPB(c_help,<KeyRelease>,$witem) [bind $witem <KeyRelease>]
     set gPB(c_help,<Double-Button-1>,$witem) [bind $witem <Double-Button-1>]
     $witem config -state disabled
     bind $witem <Key> " "
     bind $witem <KeyRelease> " "
     bind $witem <Double-Button-1> ""
    }
    TixPanedWindow {
     continue
    }
    TixFileSelectBox {
     continue
    }
    TixExFileSelectBox {
     continue
    }
    TixStdButtonBox {
     continue
    }
    TixButtonBox {
     continue
    }
    TixScrolledListBox {
     set gPB(c_help,state,$witem)   [lindex [$witem config -state] end]
     $witem config -state disabled
     continue
    }
    Listbox {
    }
    TixDirList {
     continue
    }
    TixCheckList {}
    TixHList {
     set child [lindex [$witem info children] 0]
     set children [$witem info children "$child"]
     if { [llength $children] == 0 } {
      set children [$witem info children]
      } else {
      foreach child $children {
       if {![string match "" $child]} {
        set state [lindex [$witem entryconfig $child -state] end]
        set gPB(c_help,tree_state,$witem) $state
       }
      }
     }
     if {![info exists gPB(c_help,tree_state,$witem)]} {
      set gPB(c_help,tree_state,$witem) "normal"
     }
     if {[string match "normal" $gPB(c_help,tree_state,$witem)]} {
      UI_PB_com_DisableTree $witem $children NORMAL
      } else {
      UI_PB_com_DisableTree $witem $children GRAY
     }
     set gPB(c_help,browse_cmd,$witem) [lindex [$witem config -browsecmd] end]
     $witem config -browsecmd ""
     if { ![catch { $witem config -indicatorcmd }] } {
      set gPB(c_help,indicator_cmd,$witem) [lindex [$witem config -indicatorcmd] end]
      $witem config -indicatorcmd "UI_PB_cmd_DisableSelection $witem 0"
     }
    }
    TixComboBox {
     set arrow [$witem subwidget arrow]
     set arrow_state   [lindex [$arrow config -state] end]
     if [string match "normal" $arrow_state] {
      set fgc [lindex [$arrow config -fg] end]
      } else {
      set fgc [lindex [$arrow config -disabledforeground] end]
     }
     set bgc [lindex [$arrow config -bg] end]
     set gPB(c_help,state,$witem)   [lindex [$witem config -state] end]
     set gPB(c_help,<Enter>,$arrow) [bind $arrow <Enter>]
     set gPB(c_help,<Leave>,$arrow) [bind $arrow <Leave>]
     $witem config -state disabled
     $arrow config -disabledforeground $fgc
     bind $arrow <Enter> "$arrow config -bg $paOption(focus)"
     bind $arrow <Leave> "$arrow config -bg $bgc"
    }
    Menubutton {
     set gPB(c_help,menu,$witem) [$witem cget -menu]
     $witem config -menu ""
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
     set gPB(c_help,tags,$witem) $tl
     for {set t 0} {$t < [llength $tl]} {incr t} \
     {
      set bi [lindex $tl $t]
      set bl [$witem bind $bi]
      for {set b 0} {$b < [llength $bl]} {incr b} \
      {
       set seq [lindex $bl $b]
       if { $seq != "<Enter>"  &&  $seq != "<Leave>" } \
       {
        set cb  [$witem bind $bi $seq]
        set gPB(c_help,$seq,$witem,$bi) "$cb"
        $witem bind $bi $seq " "
       }
      }
      if [info exists gPB(c_help,$witem,$bi)] {
       if [ info exists gPB($gPB(c_help,$witem,$bi),Label) ] {
        set title $gPB($gPB(c_help,$witem,$bi),Label)
        } else {
        set title " "
       }
       set text  $gPB($gPB(c_help,$witem,$bi),Context)
       $witem bind $bi <ButtonRelease-1> " UI_PB_chelp__display_msg \
       \"$title\" \"$text\" "
      }
     }
    } ;# Canvas
   } ;# switch of widget classes
   if { $witem != $gPB(c_help,tool_button) } \
   {
    if ![catch {set cmd [$witem config -command]} result] \
    {
     set gPB(c_help,cmd,$witem) [lindex $cmd end]
     $witem config -command ""
    }
    set gPB(c_help,<Button-1>,$witem)        [bind $witem <Button-1>]
    set gPB(c_help,<ButtonRelease-1>,$witem) [bind $witem <ButtonRelease-1>]
    set gPB(c_help,<Button-3>,$witem)        [bind $witem <Button-3>]
    set gPB(c_help,<ButtonRelease-3>,$witem) [bind $witem <ButtonRelease-3>]
    bind $witem <Button-1>        ""
    bind $witem <ButtonRelease-1> ""
    bind $witem <Button-3>        ""
    bind $witem <ButtonRelease-3> ""
   }
   if [info exists gPB(c_help,$witem)] {
    UI_PB_debug_DisplayMsg "         Widget with CSH : $witem" no_debug
    if ![catch {set cur [$witem config -cursor]} result] {
     if ![ info exists gPB(c_help,$witem,on) ] {
      set gPB(c_help,cur,$witem) [lindex $cur end]
     }
     $witem config -cursor question_arrow
     if [ info exists gPB($gPB(c_help,$witem),Label) ] {
      set title $gPB($gPB(c_help,$witem),Label)
      } else {
      set title " "
     }
     set text  $gPB($gPB(c_help,$witem),Context)
     switch -exact -- [winfo class $witem] \
     {
      Radiobutton {
      }
      Menubutton {
       if { $text == " " } \
       {
        $witem config -menu $gPB(c_help,menu,$witem)
       }
      } ;# Menubutton
     } ;# switch
     bind $witem <ButtonRelease-1> " UI_PB_chelp__display_msg \
     \"$title\" \"$text\" "
    } ;# change cursor
   } ;# if CSH registered
   set gPB(c_help,$witem,on) $witem
  } ;# for each widget item
 }

#=======================================================================
proc __turn_off_CSH { w } {
  UI_PB_debug_DisplayMsg  " turn off CSH"
  global gPB
  global paOption
  set top_win $gPB(top_window)
  set act_win [UI_PB_com_AskActiveWindow]
  if {[info exists gPB(main_window)] && [winfo exists $gPB(main_window)]} {
   if [string match $act_win $gPB(main_window)] {
    set wlist [UI_PB_com_GetWidgetsToSwitchState]
    set book_ids_aname [array names Book:: *book_id]
    foreach one $book_ids_aname {
     set book_id $Book::($one)
     lappend wlist [$book_id subwidget nbframe]
    }
    } else {
    set wlist [tixDescendants $act_win]
   }
   } else {
   set wlist [tixDescendants $w]
  }
  if {![string match $act_win $gPB(top_window)]&& [lsearch $wlist $top_win] < 0} {
   if [info exists gPB(top_window_children)] {
    set wlist [concat $wlist $gPB(top_window_children)]
   }
  }
  if [info exists gPB(master_pid)] {
   UI_PB_com_EnableXButton .dummy
  }
  for {set j 0} {$j < [llength $wlist]} {incr j} \
  {
   set witem [lindex $wlist $j]
   if { $witem == "$gPB(help_tool)" } \
   { continue }
   set wclass [winfo class $witem]
   if 0 {
    if { $wclass == "Toplevel"  || \
     $wclass == "TixFileSelectDialog"  || \
     $wclass == "TixExFileSelectDialog" } {
     set cur_win $witem
    }
    if {  [info exists cur_win] && $cur_win != "$top_win"  &&  $cur_win != "$act_win" } \
    { continue }
   }
   set tlw [winfo toplevel $witem]
   if { $tlw != "$top_win"  &&  $tlw != "$act_win" } \
   { continue }
   if [info exists gPB(c_help,dfgclr,$witem)] {
    $witem config -disabledforeground "$gPB(c_help,dfgclr,$witem)"
   }
   if [info exists gPB(c_help,cur,$witem)] {
    $witem config -cursor "$gPB(c_help,cur,$witem)"
   }
   if [info exists gPB(c_help,state,$witem)] {
    $witem config -state "$gPB(c_help,state,$witem)"
   }
   if [info exists gPB(c_help,<Enter>,$witem)] {
    bind $witem <Enter> "$gPB(c_help,<Enter>,$witem)"
   }
   if [info exists gPB(c_help,<Leave>,$witem)] {
    bind $witem <Leave> "$gPB(c_help,<Leave>,$witem)"
   }
   if [info exists gPB(c_help,<Button-1>,$witem)] {
    bind $witem <Button-1> "$gPB(c_help,<Button-1>,$witem)"
   }
   if [info exists gPB(c_help,<ButtonRelease-1>,$witem)] {
    bind $witem <ButtonRelease-1> "$gPB(c_help,<ButtonRelease-1>,$witem)"
   }
   if [info exists gPB(c_help,<Button-3>,$witem)] {
    bind $witem <Button-3> "$gPB(c_help,<Button-3>,$witem)"
   }
   if [info exists gPB(c_help,<ButtonRelease-3>,$witem)] {
    bind $witem <ButtonRelease-3> "$gPB(c_help,<ButtonRelease-3>,$witem)"
   }
   if [info exists gPB(c_help,cmd,$witem)] {
    $witem config -command "$gPB(c_help,cmd,$witem)"
   }
   switch -exact -- $wclass \
   {
    Entry {
     bind $witem <Key>        $gPB(c_help,<Key>,$witem)
     bind $witem <KeyRelease> $gPB(c_help,<KeyRelease>,$witem)
     bind $witem <Double-Button-1> $gPB(c_help,<Double-Button-1>,$witem)
    }
    TixCheckList {}
    TixHList {
     set child [lindex [$witem info children] 0]
     set children [$witem info children "$child"]
     if { [llength $children] == 0 } {
      set children [$witem info children]
     }
     if {[info exists gPB(c_help,tree_state,$witem)] && [string match "normal" $gPB(c_help,tree_state,$witem)]} {
      UI_PB_com_EnableTree $witem $children
     }
     if [info exists gPB(c_help,browse_cmd,$witem)] {
      $witem config -browsecmd $gPB(c_help,browse_cmd,$witem)
     }
     if [info exists gPB(c_help,indicator_cmd,$witem)] {
      $witem config -indicatorcmd $gPB(c_help,indicator_cmd,$witem)
     }
    }
    Menubutton {
     if [info exists gPB(c_help,menu,$witem)] \
     {
      $witem config -menu $gPB(c_help,menu,$witem)
     }
    }
    Canvas {
     if { $gPB(c_help,tags,$witem) != {} } \
     {
      set tl $gPB(c_help,tags,$witem)
      for {set t 0} {$t < [llength $tl]} {incr t} \
      {
       set bi [lindex $tl $t]
       set bl [$witem bind $bi]
       for {set b 0} {$b < [llength $bl]} {incr b} \
       {
        set seq [lindex $bl $b]
        if { $seq != "<Enter>"  &&  $seq != "<Leave>" } \
        {
         if [info exists gPB(c_help,$seq,$witem,$bi)] \
         {
          set cb  $gPB(c_help,$seq,$witem,$bi)
          $witem bind $bi $seq "$cb"
         }
        }
       }
      }
     }
    } ;# Canvas
   } ;# switch of widget classes
  } ;# for each widget
  set win .context_help
  if {[winfo exists $win]} \
  {
   destroy $win
  }
 }

#=======================================================================
proc UI_PB_chelp__display_msg {title text} {
  global gPB
  if [info exists gPB(master_pid)] {
   comm::comm send $gPB(master_pid) [list UI_PB_chelp__display_msg_mod $title $text]
   } else {
   UI_PB_chelp__display_msg_mod $title $text
  }
 }

#=======================================================================
proc UI_PB_chelp__display_msg_mod {title text} {
  global gPB
  global paOption
  set x [winfo pointerx .]
  set y [winfo pointery .]
  set dx 20
  set dy 15
  if { $text == " " } {
   return
  }
  set win .context_help
  if {[winfo exists $win]} \
  {
   destroy $win
  }
  toplevel $win -relief sunken -bg black -bd 2
  wm overrideredirect $win true
  wm positionfrom $win program
  if {$::tix_version == "8.4" && $::tcl_platform(platform) == "windows"} {
   wm attributes $win -topmost 1
  }
  if 0 {
   set wlist [split "$text" "\n"]
   set bw 0
   foreach w $wlist {
    set ww [font measure $gPB(c_help,font) "  $w"] ;# To allow leading blank char
    if { $bw < $ww } {
     set bw [expr $ww + 12] ;# To allow a bit more than -padx 5 in message box
    }
   }
   if {$bw > $gPB(c_help,width)} {
    set bw $gPB(c_help,width)
   }
   set dx 20
   set dy 15
   set bx [expr $x + $dx + $bw]
   if {$bx > $gPB(screen_width)} {
    set bx [expr $x - $dx / 2 - $bw]
    } else {
    set bx [expr $x + $dx]
   }
  }
  if { $title != " " } {
   label $win.title \
   -text "$title" -bg $paOption(header_bg) -fg $paOption(title_fg) \
   -wraplength $gPB(c_help,width) \
   -justify left -padx 5 -pady 2
   pack $win.title -side top    -fill x
  }
  label $win.text \
  -text "$text" \
  -wraplength $gPB(c_help,width) \
  -bg $gPB(c_help,color) -font $gPB(c_help,font) \
  -justify left -padx 5 -pady 3
  pack $win.text  -side bottom -fill x
  wm geometry $win "+[expr $x + $dy]+[expr $y + $dy]"
  UI_PB_com_PositionWindow $win "non_deco"
  bind $win <ButtonRelease-1> "UI_PB_chelp__dismiss_msg $win %X %Y"
 }

#=======================================================================
proc UI_PB_chelp__dismiss_msg { w x y } {
  global gPB
  raise $w
  destroy $w
 }

#=======================================================================
proc UI_PB_chelp_DisplayMenuItemCsh { witem } {
  global gPB
  if [info exists gPB(c_help,$witem)] {
   set index [$witem index active]
   if { $index == "none" } { ;# tearoff menu item
    set i 0
    while {1} {
     incr i
     set wi $gPB(top_window).tearoff$i
     if [winfo exists $wi] {
      set idx [$wi index active]
      if { $idx != "none" } {
       set item "c_help,$witem,$idx"
       break;
      }
     }
     if { $i == 5 } { return }
    }
    } else {
    set item "c_help,$witem,$index"
   }
   if [ info exists gPB($gPB($item),Label) ] {
    set title $gPB($gPB($item),Label)
    } else {
    set title " "
   }
   set text  $gPB($gPB($item),Context)
   UI_PB_chelp__display_msg "$title" "$text"
  }
 }
