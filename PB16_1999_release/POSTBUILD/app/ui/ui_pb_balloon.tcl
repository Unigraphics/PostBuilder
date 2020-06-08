#===============================================================================
#                       UI_PB_BALLOON.TCL
#===============================================================================
################################################################################
# Description                                                                  #
#     This file contains all functions dealing with the creation of            #
#     Ballon.                                                                  #
#                                                                              #
# Revisions                                                                    #
#                                                                              #
#   Date        Who       Reason                                               #
# 01-feb-1999   gsl       Initial                                              #
# 02-Jun-1999   mnb       Code Integration                                     #
# 04-Jun-1999   gsl       Reposition balloon w.r.t. screen size                #
# 15-Jun-1999   mnb       Removed puts                                         #
# 28-Jun-1999   gsl       Removed use of gPB_help_tips($name_to_bind\_enabled) #
# 17-Nov-1999   gsl       Submitted for phase-22.                              #
#                                                                              #
# $HISTORY$                                                                    #
#                                                                              #
################################################################################

# Tcl Library to provide balloon help.
# balloon help bindings are automatically added to all buttons and
# menus by init_balloon call.
# you have only to provide descriptions for buttons or menu items by
# setting elements of global gPB_help_tips array, indexed by button path or
# menu path,item to something useful.
# if you want to have balloon helps for any other widget you can
# do so by enable_balloon widget_path_or_class
# or enable_balloon_selective widget_path_or_class Tcl_Script
#
# You can toggle balloon help globally on and off by setting variable
# gPB_use_balloons to true or false
################################################################################
## 
## 
##                         BALLOON.TCL 
##  
##                       Help balloon Tcl library
##                 Copyright(c) by Victor B Wagner, 1997
## 
## Usage:
## 
## 1. init balloon help system by calling init_balloons in startup part
##    of yor Tcl application
## 
## 2. Whenever you want particular widget to show help balloon,
##    set an element of global array widget with index of widget name
##    to desired text. This is almost all.
##    
##    for example:
## 
##    button .mywin.ok -text Ok -command do_it
##    set help_tips(.mywin.ok) {Perform desired action}
## 
## 3. For menu widget you can would have separate balloons for each item.
##    Help_tips indices are formed of menu name and item number,separated by
##    comma.
##  
##   for example
##   
##    menu .menu.file.m
##    .menu.file.m add command -text Open -command open_file
##    set help_tips(.menu.file.m,1) {Open an existing file}
##   
## 4. You can toggle displaying of balloons on and off globally by setting 
##    global variable gPB_use_balloons to 1 (on) or 0 (off).
##    Note: it is automatically turned on by init_balloons procedure.
## 
## 5. Balloons for other widgets.
##    comand enable_balloon allows to add balloons to widgets other than
##    buttons and menus.
## 
##    It accepts following parameters:
## 
## 
##    enable_balloon name_to_bind ?script?
## 
##   where name_to_bind can be any name, acceptable by bind, i.e
##   either name of INDIVIDUAL WIDGET or WIDGET CLASS, and
##   script is tcl function, which returns additional index for part of
##   widget. If you omit it, you'll have same help text anywhere in widget.
##   This script could contain any % substitutuins, acceptable by bind command.
##    
##   For menu widget I'm using	"%W index active"
##     
## Further custimization:
## 
##   init_balloons accept three options 
##     -delay value  
##     delay between last mouse event and instant, when balloon appear.
##     delay must be specified in milliseconds as for after command
##     -width pixels 
##     width of balloon, specified in units, suitable for -wraplength option
##     of label widget
## 
##     -color color 
##     background color of ballon. Any form, acceptable by Tk
## 
## 
## GETOPT procedure
##    
##     getopt array ?option value ...?
##    
##    parses list of options. All options and values can be a separate arguments,
##    or form a single list, so if you procedure is declared as.
##  
##    myproc {param args}
## 
##    call
##    
##    getopt arglist $args
##  
##    would be correct.
##    array should contain an element for each allowed option, probably
##    initiliazed by its default value.
## 
##    Indices of array shouldn't have a leading dash.
## 
##    getopt parses list of options and replaces default values by supplied ones.
## 
##    array could be local variable
## 
## 
################################################################################

set gPB_help_tips(font)    {helvetica 9}
set gPB_help_tips(screen)  1280
set gPB_help_tips(width)   150
set gPB_help_tips(color)   #ffff60
set gPB_help_tips(delay)   500
set gPB_help_tips(state)   1


#===============================================================================
proc PB_init_balloons {args} {
#===============================================================================
  global gPB_help_tips gPB_use_balloons

  getopt gPB_help_tips $args
  set gPB_use_balloons $gPB_help_tips(state)

#<gsl> It may not be all that desirable to enable the balloon
#<gsl> for the entire class of widgets. This may hamper the performance.
#<gsl> It should be done on the selective basis.
#<gsl>
#<gsl>  PB_set_balloons

  PB_enable_balloon Canvas
}


#===============================================================================
proc PB_set_balloons {} {
#===============================================================================
  PB_enable_balloon Button
  PB_enable_balloon Menubutton
  PB_enable_balloon Menu "%W index active" 
  PB_enable_balloon tixNoteBookFrame
  PB_enable_balloon Canvas
  PB_enable_balloon Listbox "%W index @%x,%y" 
}


#===============================================================================
proc PB_enable_balloon {name_to_bind {script {}}} {
#===============================================================================
  global gPB_help_tips

  if ![llength $script] {
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


#===============================================================================
proc PB_wait_balloon {} {
#===============================================================================
  if [winfo exists .balloon_help] {
    tkwait variable .balloon_help
  }
}

#===============================================================================
proc PB_reset_balloon {window x y {item {}}} {
#===============================================================================
  PB_cancel_balloon
  schedule_balloon $window $x $y $item
}


#===============================================================================
proc PB_cancel_balloon {} {
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
proc schedule_balloon {window x y {item {}}} {
#===============================================================================
  global gPB_use_balloons gPB_help_tips balloon_after_ID 

  if !$gPB_use_balloons return

  if [string length $item] {
    set index "$window,$item"
  } else {set index $window}

  if [info exists gPB_help_tips($index)] {
    set balloon_after_ID [after $gPB_help_tips(delay) \
               "create_balloon \"$gPB_help_tips($index)\" $x $y"]
  }
}


#===============================================================================
proc create_balloon {text x y} {
#===============================================================================
  global balloon_after_ID gPB_help_tips

  if {![winfo exists .balloon_help]} \
  {
    toplevel .balloon_help -relief flat \
                           -bg black -bd 1
    wm overrideredirect .balloon_help true
    wm positionfrom .balloon_help program

   # Compute balloon width to adjust its position
    set bw [font measure $gPB_help_tips(font) " $text"]
    if {$bw > $gPB_help_tips(width)} {
      set bw $gPB_help_tips(width)
    }

   # Position Balloon w.r.t. scrren size
    set bx [expr $x + 10 + $bw]

    if {$bx > $gPB_help_tips(screen)} {
      set bx [expr $x - 10 - $bw]
    } else {
      set bx [expr $x + 10]
    }

    label .balloon_help.lead -text " " -bg orange
    label .balloon_help.tip -text "$text" -wraplength $gPB_help_tips(width) \
                            -bg $gPB_help_tips(color) -font $gPB_help_tips(font) \
                            -bd 1 -justify left

    pack .balloon_help.lead -side left -fill y
    pack .balloon_help.tip  -side left -fill y

    wm geometry .balloon_help "+$bx+[expr $y+5]"
  }
}


################################################################################
# Simple tk-like option parser
# usage getopt arrname args
# where arrname - array which have entries for all possible options
# without leading dash (possible empty)
#
#===============================================================================
proc getopt {arrname args} {
#===============================================================================
  if {[llength $args]==1} {eval set args $args}
  if {![llength $args]} return
  if {[llength $args]%2!=0} {error "Odd count of opt. arguments"}
  array set tmp $args
  foreach i [uplevel array names $arrname] {
   if [info exists tmp(-$i)] {
      uplevel set "$arrname\($i\)" $tmp(-$i)
      unset tmp(-$i)
   }
  }
  set wrong_list [array names tmp]
  if [llength $wrong_list] { 
    set msg "Unknown option(s) $wrong_list. Must be one of:"
    foreach i [uplevel array names $arrname] {
      append msg " -$i"
    }
    error $msg 
  }
}
