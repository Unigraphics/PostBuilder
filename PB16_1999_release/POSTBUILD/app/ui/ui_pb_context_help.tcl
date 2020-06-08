#===============================================================================
#                       UI_PB_CONTEXT_HELP.TCL
#===============================================================================
################################################################################
# Description                                                                  #
#     This file attempts to perform context sensitive help service.            #
#                                                                              #
# Revisions                                                                    #
#                                                                              #
#   Date        Who       Reason                                               #
# 01-Oct-1999   gsl       Initial (Cloned from ui_pb_balloon.tcl)              #
# 17-Nov-1999   gsl       Submitted for phase-22.                              #
#                                                                              #
# $HISTORY$                                                                    #
#                                                                              #
################################################################################

# You can toggle Context Sensitive Help globally on and off by setting variable
# gPB_context_help to true or false.
################################################################################
################################################################################

set gPB_chelp(font)    {helvetica 9}
set gPB_chelp(screen)  1280
set gPB_chelp(width)   200
set gPB_chelp(color)   #ffff60
set gPB_chelp(state)   1


#===============================================================================
proc UI_PB_init_chelp {args} {
#===============================================================================
  global gPB_help_tips gPB_use_balloons

  getopt gPB_help_tips $args
  set gPB_use_balloons $gPB_help_tips(state)

  PB_enable_balloon Canvas
}


#===============================================================================
proc PB_set_chelp {} {
#===============================================================================
  PB_enable_balloon Button
  PB_enable_balloon Menubutton
  PB_enable_balloon Menu "%W index active" 
  PB_enable_balloon tixNoteBookFrame
  PB_enable_balloon Canvas
  PB_enable_balloon Listbox "%W index @%x,%y" 
}


#===============================================================================
proc PB_enable_chelp {name_to_bind {script {}}} {
#===============================================================================
  global gPB_help_tips

##  if ![llength $script] {
##    bind $name_to_bind <Any-Enter>  "+schedule_balloon %W %X %Y"
##    bind $name_to_bind <Any-Motion> "+PB_reset_balloon %W %X %Y"
##  } else {
##    bind $name_to_bind <Any-Enter>  "+schedule_balloon %W %X %Y \[$script\]"
##    bind $name_to_bind <Any-Motion> "+PB_reset_balloon %W %X %Y \[$script\]"
##  }
##
##  bind $name_to_bind <1>               "+PB_cancel_balloon"
##  bind $name_to_bind <ButtonRelease-1> "+PB_cancel_balloon"
##  bind $name_to_bind <Any-Enter>       "+PB_wait_balloon"
##  bind $name_to_bind <Any-Leave>       "+PB_cancel_balloon"
##  bind $name_to_bind <Any-Leave>       "+PB_wait_balloon"


  if ![llength $script] {
    bind $name_to_bind <1>  "+schedule_balloon %W %X %Y"
    bind $name_to_bind <ButtonRelease-1> "+PB_reset_balloon %W %X %Y"
  } else {
    bind $name_to_bind <1>  "+schedule_balloon %W %X %Y \[$script\]"
    bind $name_to_bind <ButtonRelease-1> "+PB_reset_balloon %W %X %Y \[$script\]"
  }

  bind $name_to_bind <Any-Enter>       "+PB_wait_balloon"
  bind $name_to_bind <Any-Leave>       "+PB_cancel_balloon"
  bind $name_to_bind <Any-Leave>       "+PB_wait_balloon"
}


#===============================================================================
proc PB_wait_chelp {} {
#===============================================================================
  if [winfo exists .balloon_help] {
    tkwait variable .balloon_help
  }
}

#===============================================================================
proc PB_reset_chelp {window x y {item {}}} {
#===============================================================================
  PB_cancel_balloon
  schedule_balloon $window $x $y $item
}


#===============================================================================
proc PB_cancel_chelp {} {
#===============================================================================
  global balloon_after_ID
  global balloon_exists

  if [info exists balloon_after_ID] {
    after cancel $balloon_after_ID
    unset balloon_after_ID 
  }

  if [winfo exists .balloon_help] {
    destroy .balloon_help
  }
}


#===============================================================================
proc schedule_chelp {widget x y} {
#===============================================================================
  global gPB

  if !$gPB(use_info) return

  if [info exists gPB(c_help,title,$widget)] {
    create_balloon \"$gPB(c_help,title,$widget)\" \"$gPB(c_help,text,$widget)\" $x $y
  }
}


#===============================================================================
proc PB_context_help {title text x y} {
#===============================================================================
  global gPB

  if {![winfo exists .context_help]} \
  {
    toplevel .context_help -relief raised \
                           -bg black -bd 3
    wm overrideredirect .context_help true
    wm positionfrom .context_help program


   # Compute balloon width to adjust its position
    set bw [font measure $gPB(c_help,font) " $text"]
    if {$bw > $gPB(c_help,width)} {
      set bw $gPB(c_help,width)
    }

   # Position window w.r.t. screen size
    set bx [expr $x + 10 + $bw]

    if {$bx > $gPB(c_help,screen)} {
      set bx [expr $x - 10 - $bw]
    } else {
      set bx [expr $x + 10]
    }

    label .context_help.title -text "$title" -bg royalBlue -fg lightYellow \
                              -justify left
    label .context_help.text  -text "$text" -wraplength $gPB(c_help,width) \
                              -bg cyan -font $gPB(c_help,font) -justify left

    pack .context_help.title  -side top -fill x
    pack .context_help.text n -side bot -fill x

    wm geometry .context_help "+$bx+[expr $y+5]"
  }
}

