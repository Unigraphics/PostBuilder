################################################################################
#                                                                              #
# Copyright (c) 1999/2000/2001/2002/2003/2004, Unigraphics Solutions Inc.      #
#                                                                              #
################################################################################
#                       U I _ P B _ D E B U G . T C L
################################################################################
#                                                                              #
# Description                                                                  #
#     This file contains the debugging procedures for the Post Builder.        #
#                                                                              #
################################################################################


if { [info exists env(PB_SUPPRESS_ALL_DEBUG)] } {
    set gPB(SUPPRESS_ALL_DEBUG) $env(PB_SUPPRESS_ALL_DEBUG)
}

if { ![info exists gPB(SUPPRESS_ALL_DEBUG)] } {
    set gPB(SUPPRESS_ALL_DEBUG) 1
}

if { ![info exists gPB(DEBUG)] } {
    set gPB(DEBUG) 0
}

if { ![info exists gPB(MSG)] } {
    set gPB(MSG) 0
}



set gPB(debug_index) 0
set gPB(debug_win) .pb_debug


if { [info exists env(PB_DEBUG)] } {
    set gPB(DEBUG) $env(PB_DEBUG)
}


#-------------------------------------------------------------------------------

#=======================================================================
proc __Pause { args } {
  #-------------------------------------------------------------------------------
    global gPB
  
     UI_PB_debug_Pause [join $args]
 }
 
 #<02-25-05 gsl> Rewrote with scrollable text window
 if 0 {
  #-------------------------------------------------------------------------------

#=======================================================================
proc UI_PB_debug_Pause { args } {
  #-------------------------------------------------------------------------------
    global gPB
  
     if $gPB(SUPPRESS_ALL_DEBUG) { return }
  
  update
  
     set awin [UI_PB_com_AskActiveWindow]
     set args "$gPB(debug_index) :\n[join [__Trace] \n]\n[join $args]"
  
     tk_messageBox -parent $awin -type ok -icon info -message "$args"
  
     incr gPB(debug_index)
 }
}

#-------------------------------------------------------------------------------

#=======================================================================
proc UI_PB_debug_Pause { msg {trace 1} } {
  #-------------------------------------------------------------------------------
    global gPB
  
     if $gPB(SUPPRESS_ALL_DEBUG) { return }
  
  update
  
    global tixOption paOption
  
     set win [toplevel [UI_PB_com_AskActiveWindow].pause]
  
     if { $trace } {
        # set text "$gPB(debug_index) :\n[join [__Trace] \n]\n\n[join $args]"
         set text "$gPB(debug_index) :\n[join [__Trace] \n]\n\n$msg"
      } else {
         set text "$msg"
     }
  
     incr gPB(debug_index)
  
     set xc [expr [winfo rootx $gPB(top_window)] + 300]
     set yc [expr [winfo rooty $gPB(top_window)] + 300]
  
     UI_PB_com_CreateTransientWindow $win "Post Builder Message" "+$xc+$yc" "" "" \
                                          "grab release $win; destroy $win" \
                                          "grab release $win; destroy $win"
     set b [frame $win.b]
     pack $b -side bottom -expand no -fill x
  
     set t [frame $win.t -relief sunken -bd 2]
     pack $t -side top -expand yes -fill both
  
  
     set lsw [tixScrolledText $t.lsw -scrollbar auto]
     pack $lsw -side bottom -fill both -expand yes
     set ltext [$lsw subwidget text]
     $ltext config -bg skyBlue -fg black -font $tixOption(fixed_font) -wrap word -bd 0 -padx 20 -pady 15
     $ltext insert end "$text"
  
  
     frame $b.f -relief sunken -bd 1 -takefocus 1 \
                -highlightcolor black -highlightthickness 1
     pack $b.f -pady 5
  
     button $b.f.b -text "$gPB(nav_button,ok,Label)" -width 10 \
                   -command "destroy $win" -takefocus 0
     pack $b.f.b -side bottom -padx 1 -pady 1
  
  
     UI_PB_com_PositionWindow $win
     raise $win
     grab $win
     tkwait window $win
 }
 
 #-------------------------------------------------------------------------------

#=======================================================================
proc UI_PB_debug_CreateMsgWin { } {
  #-------------------------------------------------------------------------------
    global tixOption
    global paOption
    global gPB
  
  
     set gPB(debug_index) 0
  
     set w $gPB(debug_win)
     toplevel     $w
     wm title $w "Post Builder Messages"
     wm geometry  $w 300x325+50+50
  
     set f [frame $w.f -relief sunken -bd 1]
     pack $f -padx 2 -pady 6 -fill both -expand yes
  
     set lsw [tixScrolledText $f.lsw -scrollbar auto]
  
     pack $lsw -side bottom -fill both -expand yes
  
     set ltext [$lsw subwidget text]
  
     $ltext config  -bg black -fg lightGreen -font $tixOption(fixed_font) -wrap word -bd 0
  
     set gPB(MSG) $ltext
 }
 
 #-------------------------------------------------------------------------------

#=======================================================================
proc __Trace { } {
  #-------------------------------------------------------------------------------
  return [UI_PB_debug_Trace]
 }
 
 #-------------------------------------------------------------------------------

#=======================================================================
proc UI_PB_debug_Trace { args } {
  #-------------------------------------------------------------------------------
    global gPB
  
     if $gPB(SUPPRESS_ALL_DEBUG) { return }
  
     set start_idx 1
  
     set str ""
     set level [info level]
  
     for { set i $start_idx } { $i < $level } { incr i } {
         set s "[lindex [info level $i] 0]"
         if { ![string match "*_Pause" $s] && ![string match "*_Trace" $s] } {
             lappend str $s
         }
     }
  
  return $str
 }
 
 #-------------------------------------------------------------------------------

#=======================================================================
proc UI_PB_debug_DisplayMsg { s args } {
  #-------------------------------------------------------------------------------
    global tcl_platform
    global gPB
  
  
     if $gPB(SUPPRESS_ALL_DEBUG) { return }
  
  
     set no_debug 0
     set debug_state $gPB(DEBUG)
  
     if { [llength $args] && [lindex $args 0] == "no_debug" } {
         set no_debug 1
         set gPB(DEBUG) 1
     }
  
     set str ""
  
     if { $gPB(DEBUG) } \
     {
         if { $no_debug == 0 } {
             set level [info level]
             for { set i 1 } { $i < $level } { incr i } {
                 set str "$str\[ [lindex [info level $i] 0] \]"
             }
    
            # set s ">\[ [lindex [info level -1] 0] \] $s<"
    
            #<11-29-01 gsl> set s "$str\n $gPB(debug_index) ==>$s<"
             set str "$str\n $gPB(debug_index) ==>"
             incr gPB(debug_index)
         }
   
         if { [string match "windows" $tcl_platform(platform)] } \
         {
             set w $gPB(debug_win)
    
             if { ![winfo exists $w] } \
             {
                 UI_PB_debug_CreateMsgWin
             }
    
             if { [string match "iconic" [wm state $w]] }\
             {
                 wm deiconify $w
             }
    
             $gPB(MSG) tag configure redbg -background red
             $gPB(MSG) tag configure blubg -background blue
             $gPB(MSG) insert end " " redbg
             $gPB(MSG) insert end "$str"
             $gPB(MSG) insert end "$s" blubg
             $gPB(MSG) insert end "<\n"
    
             $gPB(MSG) yview moveto 1.0
    
          } elseif { [string match "unix" $tcl_platform(platform)] } \
         {
             puts "$str$s<"
         }
   
        #<06-07-12 gsl> Also write to a file
         global env
         if { ![info exists gPB(Debug_Log)] || [string length $gPB(Debug_Log)] == 0 } {
             set gPB(Debug_Log) [file nativename "$env(PB_HOME)/__$env(LOGNAME)_PB_debug_[clock clicks].log"]
         }
         if { ![catch {set fid [open $gPB(Debug_Log) a+]}] } {
             puts $fid "$str$s<"
             close $fid
         }
     }
  
    # Restore debug state
     set gPB(DEBUG) $debug_state
 }
 
 #-------------------------------------------------------------------------------

#=======================================================================
proc UI_PB_debug_ForceMsg { s } {
  #-------------------------------------------------------------------------------
    global gPB
  
  
     if $gPB(SUPPRESS_ALL_DEBUG) { return }
  
  
     set debug_state $gPB(DEBUG)
     set gPB(DEBUG) 1
  
     UI_PB_debug_DisplayMsg $s
  
     set gPB(DEBUG) $debug_state
 }
 
 #-------------------------------------------------------------------------------

#=======================================================================
proc UI_PB_debug_DebugMsg { s } {
  #-------------------------------------------------------------------------------
    global gPB
  
  
     if $gPB(SUPPRESS_ALL_DEBUG) { return }
  
  
     set debug_state $gPB(DEBUG)
     set gPB(DEBUG) 0
  
     UI_PB_debug_DisplayMsg $s
  
     set gPB(DEBUG) $debug_state
 }
 
 
 
 
