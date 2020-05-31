#26
global tixOption
set gPB_help_tips(font)    $tixOption(font_sm)
set gPB_help_tips(screen)  1280 ;# Initialized, actual value found & set in pb.c.
set gPB_help_tips(width)   300 ;#<01-11-02 gsl> was 250.
set gPB_help_tips(color)   #ffff60
set gPB_help_tips(delay)   500
set gPB_help_tips(state)   1
set gPB_help_tips(life)    30000

#=======================================================================
proc PB_init_balloons {args} {
  global gPB_help_tips gPB_use_balloons
  getopt gPB_help_tips $args
  set gPB_use_balloons $gPB_help_tips(state)
  PB_enable_balloon Canvas
 }

#=======================================================================
proc PB_set_balloons {} {
  PB_enable_balloon Button
  PB_enable_balloon Menubutton
  PB_enable_balloon Menu "%W index active"
  PB_enable_balloon tixNoteBookFrame
  PB_enable_balloon Canvas
  PB_enable_balloon Listbox "%W index @%x,%y"
 }

#=======================================================================
proc PB_enable_balloon {name_to_bind {script {}}} {
    global gPB_help_tips
    if { ![llength $script] } {
     bind $name_to_bind <Any-Enter>  "+schedule_balloon %W %X %Y"
     bind $name_to_bind <Any-Motion> "+PB_reset_balloon %W %X %Y"
     } else {
     bind $name_to_bind <Any-Enter>  "+schedule_balloon %W %X %Y \[$script\]"
     bind $name_to_bind <Any-Motion> "+PB_reset_balloon %W %X %Y \[$script\]"
    }
    bind $name_to_bind <1>               "+PB_cancel_balloon"
    bind $name_to_bind <ButtonRelease-1> "+PB_cancel_balloon"
    bind $name_to_bind <Any-Enter>       "+PB_wait_balloon"
    bind $name_to_bind <Any-Leave>       "+PB_cancel_balloon"
    bind $name_to_bind <Any-Leave>       "+PB_wait_balloon"
   }

#=======================================================================
proc PB_disable_balloon { name_to_bind } {
  bind $name_to_bind <Any-Enter>       ""
  bind $name_to_bind <Any-Leave>       ""
  bind $name_to_bind <Any-Motion>      ""
  bind $name_to_bind <1>               ""
  bind $name_to_bind <ButtonRelease-1> ""
 }

#=======================================================================
proc PB_wait_balloon {} {
  if { [winfo exists .balloon_help] } {
   tkwait variable .balloon_help
  }
 }

#=======================================================================
proc PB_reset_balloon {window x y {item {}}} {
    PB_cancel_balloon
    schedule_balloon $window $x $y $item
   }

#=======================================================================
proc PB_cancel_balloon {} {
  global balloon_after_ID
  global balloon_exists
  if { [info exists balloon_after_ID] } {
   after cancel $balloon_after_ID
   unset balloon_after_ID
  }
  if { [winfo exists .balloon_help] } {
   destroy .balloon_help
  }
 }

#=======================================================================
proc schedule_balloon {window x y {item {}}} {
    global gPB_use_balloons gPB_help_tips balloon_after_ID
    if { !$gPB_use_balloons } { return }
    if { [string length $item] } {
     set index "$window,$item"
     } else { set index $window }
    if { [info exists gPB_help_tips($index)] } {
     if { $gPB_help_tips($index) == "" } { return }
     if { [info exists ::gPB(enable_func_exp)] && $::gPB(enable_func_exp) } \
     {
      set bal_text [PB_output_EscapeSpecialControlChar $gPB_help_tips($index)]
     } else \
     {
      set bal_text [PB_output_EscapeSpecialControlChar_no_dollar $gPB_help_tips($index)]
     }
     if 0 {
      set balloon_after_ID [after $gPB_help_tips(delay) \
      "catch { create_balloon \"$gPB_help_tips($index)\" $x $y; \
      after $gPB_help_tips(life) \"PB_cancel_balloon\"}"]
     }
     set balloon_after_ID [after $gPB_help_tips(delay) \
     "catch { create_balloon \"$bal_text\" $x $y; \
     after $gPB_help_tips(life) \"PB_cancel_balloon\"}"]
    }
   }

#=======================================================================
proc create_balloon {text x y} {
  global balloon_after_ID gPB_help_tips
  if { ![winfo exists .balloon_help] } \
  {
   toplevel .balloon_help -relief flat -bg black -bd 1
   wm overrideredirect .balloon_help true
   wm positionfrom .balloon_help program
   set width [expr $gPB_help_tips(width) - 6] ;# To allow -padx 3 in balloon
   if 0 {
    global tcl_platform
    if { $tcl_platform(platform) == "windows" } {
     if { [font measure $gPB_help_tips(font) "$text"] > $width } {
      set cc [string length $text]
      set text_1 ""
      set jj 0
      for { set ii 0 } { $ii < $cc } { incr ii } {
       if { [string index $text $ii] == " " } {
        set text_1 "$text_1[string range $text $jj [expr $ii - 1]]"
        set jj $ii
        continue
       }
       set wx  [string range $text $jj $ii]
       set wxl [font measure $gPB_help_tips(font) $wx]
       if { $wxl > $width } {
        set text_1 "$text_1[string range $text $jj [expr $ii - 1]] "
        set jj $ii
       }
      }
      set text_1 "$text_1[string range $text $jj $cc]"
      set text $text_1
     }
    }
    set wlist [split "$text" "\n"]
    set bw 0
    foreach w $wlist {
     set ww [font measure $gPB_help_tips(font) "$w"]
     if { $bw < $ww } {
      set bw $ww
     }
    }
    if { $bw > $width } {
     set bw $gPB_help_tips(width)
    }
    set dx 10
    set dy 10
    set bx [expr $x + $dx + $bw]
    if { $bx > $gPB_help_tips(screen) } {
     set bx [expr $x - $dx / 2 - $bw]
     } else {
     set bx [expr $x + $dx]
    }
   }
   label .balloon_help.lead -text " " -bg orange -pady 2
   label .balloon_help.tip  -text "$text" -wraplength $gPB_help_tips(width) \
   -bg $gPB_help_tips(color) -font $gPB_help_tips(font) \
   -bd 1 -justify left -padx 3 -pady 2
   pack .balloon_help.lead -side left -fill y
   pack .balloon_help.tip  -side left -fill both -expand yes
   set dx 10
   set dy 10
   wm geometry .balloon_help "+[expr $x + $dx]+[expr $y + $dy]"
   UI_PB_com_PositionWindow .balloon_help "non_deco"
   update idletasks
   tkwait visibility .balloon_help
  }
 }

#=======================================================================
proc getopt { arrname args } {
  global gPB
  if { [llength $args] == 1 }   { eval set args $args }
  if {![llength $args] }        { return }
  if { [llength $args]%2 != 0 } { error "$gPB(msg,odd)" }
  array set tmp $args
  foreach i [uplevel array names $arrname] {
   if { [info exists tmp(-$i)] } {
    uplevel set "$arrname\($i\)" $tmp(-$i)
    unset tmp(-$i)
   }
  }
  set wrong_list [array names tmp]
  if { [llength $wrong_list] } {
   set msg "$gPB(msg,wrong_list_1) $wrong_list. $gPB(msg,wrong_list_2)"
   foreach i [uplevel array names $arrname] {
    append msg " -$i"
   }
   error $msg
  }
 }
