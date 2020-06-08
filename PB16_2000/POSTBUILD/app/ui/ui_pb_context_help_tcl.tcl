#18
global gPB tixOption
set gPB(c_help,font)    $tixOption(font_sm)
set gPB(c_help,width)   300
set gPB(c_help,color)   #ffff60
set gPB(c_help,state)   1

#=======================================================================
proc UI_PB_chelp_SetContextHelp {} {
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
  set tw $gPB(top_window)
  global gPB_help_tips
  if { $gPB(use_info) && $idx >= 0 } \
  {
   UI_PB_debug_DisplayMsg "===> Context Help ON <==="
   set gPB_use_balloons 0
   set gPB_help_tips(state) 0
   __turn_on_CSH $tw
   } elseif { !$gPB(use_info) && $idx < 0 } \
  {
   UI_PB_debug_DisplayMsg  "<=== Context Help OFF ===>"
   __turn_off_CSH $tw
   set gPB_use_balloons $gPB(use_bal)
   set gPB_help_tips(state) $gPB(use_bal)
  }
 }

#=======================================================================
proc __turn_on_CSH { w } {
  global gPB
  global paOption
  set wlist [tixDescendants $w]
  for {set j 0} {$j < [llength $wlist]} {incr j} \
  {
   set witem [lindex $wlist $j]
   if { $witem == "$gPB(help_tool)" } \
   { continue }
   set wc [winfo class $witem]
   if { $wc == "Toplevel" } \
   {
    set cur_win $witem
   }
   if { $cur_win != $gPB(top_window)  &&  $cur_win != $gPB(active_window) } \
   { continue }
   UI_PB_debug_DisplayMsg  " widget $witem is class == $wc"
   switch -exact -- [winfo class $witem] \
   {
    Label {
     continue
    }
    Scrollbar {
     continue
    }
    Checkbutton -
    Radiobutton {
     set bgc [lindex [$witem config -bg] end]
     set fgc [lindex [$witem config -fg] end]
     set gPB(c_help,state,$witem)   [lindex [$witem config -state] end]
     set gPB(c_help,<Enter>,$witem) [bind $witem <Enter>]
     set gPB(c_help,<Leave>,$witem) [bind $witem <Leave>]
     $witem config -state disabled -disabledforeground $fgc
     bind $witem <Enter> "$witem config -bg $paOption(focus) -disabledforeground black"
     bind $witem <Leave> "$witem config -bg $bgc -disabledforeground $fgc"
    }
    Entry {
     set gPB(c_help,state,$witem) [lindex [$witem config -state] end]
     set gPB(c_help,<Key>,$witem)        [bind $witem <Key>]
     set gPB(c_help,<KeyRelease>,$witem) [bind $witem <KeyRelease>]
     $witem config -state disabled
     bind $witem <Key> " "
     bind $witem <KeyRelease> " "
    }
    TixHList {
     UI_PB_com_DisableTree $witem [$witem info children 0] NORMAL
     set gPB(c_help,browse_cmd,$witem) [lindex [$witem config -browsecmd] end]
     $witem config -browsecmd ""
    }
    TixComboBox {
     set arrow [$witem subwidget arrow]
     set fgc [lindex [$arrow config -fg] end]
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
       UI_PB_debug_DisplayMsg "         Canvas item with CSH : $witem (tag $bi)"
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
    } 
   } 
   if { $witem != $gPB(c_help,tool_button) } \
   {
    set gPB(c_help,<Button-1>,$witem)        [bind $witem <Button-1>]
    set gPB(c_help,<ButtonRelease-1>,$witem) [bind $witem <ButtonRelease-1>]
    set gPB(c_help,<Button-3>,$witem)        [bind $witem <Button-3>]
    set gPB(c_help,<ButtonRelease-3>,$witem) [bind $witem <ButtonRelease-3>]
    bind $witem <Button-1>        ""
    bind $witem <ButtonRelease-1> ""
    bind $witem <Button-3>        ""
    bind $witem <ButtonRelease-3> ""
    if ![catch {set cmd [$witem config -command]} result] \
    {
     set gPB(c_help,cmd,$witem) [lindex $cmd end]
     $witem config -command ""
    }
   }
   if [info exists gPB(c_help,$witem)] {
    UI_PB_debug_DisplayMsg "         Widget with CSH : $witem"
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
      } 
     } 
     bind $witem <ButtonRelease-1> " UI_PB_chelp__display_msg \
     \"$title\" \"$text\" "
    } 
   } 
   set gPB(c_help,$witem,on) $witem
  } 
 }

#=======================================================================
proc __turn_off_CSH { w } {
  global gPB
  global paOption
  set wlist [tixDescendants $w]
  for {set j 0} {$j < [llength $wlist]} {incr j} \
  {
   set witem [lindex $wlist $j]
   set wc [winfo class $witem]
   if { $wc == "Toplevel" } \
   {
    set cur_win $witem
   }
   if { $cur_win != $gPB(top_window)  &&  $cur_win != $gPB(active_window) } \
   { continue }
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
   switch -exact -- [winfo class $witem] \
   {
    Entry {
     bind $witem <Key>        $gPB(c_help,<Key>,$witem)
     bind $witem <KeyRelease> $gPB(c_help,<KeyRelease>,$witem)
    }
    TixHList {
     UI_PB_com_EnableTree $witem [$witem info children 0]
     if [info exists gPB(c_help,browse_cmd,$witem)] \
     {
      $witem config -browsecmd $gPB(c_help,browse_cmd,$witem)
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
    } 
   } 
  } 
  set win .context_help
  if {[winfo exists $win]} \
  {
   destroy $win
  }
 }

#=======================================================================
proc UI_PB_chelp__display_msg {title text} {
  global gPB
  set x [winfo pointerx .]
  set y [winfo pointery .]
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
  set wlist [split "$text" "\n"]
  set bw 0
  foreach w $wlist {
   set ww [font measure $gPB(c_help,font) "  $w"] 
   if { $bw < $ww } {
    set bw [expr $ww + 12] 
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
  if { $title != " " } {
   label $win.title \
   -text "$title" -bg royalBlue -fg lightYellow \
   -wraplength $gPB(c_help,width) \
   -justify left -padx 5 -pady 2
   pack $win.title -side top    -fill x
  }
  label $win.text \
  -text "$text" \
  -wraplength $gPB(c_help,width) \
  -bg cyan -font $gPB(c_help,font) \
  -justify left -padx 5 -pady 3
  pack $win.text  -side bottom -fill x
  wm geometry $win "+$bx+[expr $y + $dy]"
  tkwait visibility $win
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
   if { $index == "none" } { 
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
