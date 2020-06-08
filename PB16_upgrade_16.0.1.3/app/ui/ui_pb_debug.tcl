################################################################################
# ***************                                                              #
# ui_pb_debug.tcl                                                              #
# ***************                                                              #
#  Debug procedures for Post Builder                                           #
#------------------------------------------------------------------------------#
#                                                                              #
# Copyright (c) 1999, Unigraphics Solutions Inc.                               #
#                                                                              #
# See the file "license.terms" for information on usage and redistribution     #
# of this file, and for a DISCLAIMER OF ALL WARRANTIES.                        #
#                                                                              #
#                                                                              #
# Description                                                                  #
#     This file contains the debugging procedures for the Post Builder.        #
#                                                                              #
#                                                                              #
# Revisions                                                                    #
#                                                                              #
#   Date        Who       Reason                                               #
# 07-Feb-2000   GSL   Initial                                                  #
# 26-Apr-2000 mnb/gsl V17008 submission                                      #
#                                                                              #
# $HISTORY$                                                                    #
#                                                                              #
################################################################################
global tcl_platform
global gPB


set gPB(DEBUG) 0
set gPB(debug_win) .pb_debug

#-------------------------------------------------------------------------------
proc UI_PB_debug_CreateMsgWin {} {
#-------------------------------------------------------------------------------
 global tixOption
 global paOption
 global gPB

  set w $gPB(debug_win)
  toplevel     $w
  wm title $w "UG Post Builder Messages"
  wm geometry  $w 300x325+50+50

  set f [frame $w.f -relief sunken -bd 1]
  pack $f -padx 2 -pady 6 -fill both -expand yes

  set lsw [tixScrolledWindow $f.lsw -scrollbar both]

  [$lsw subwidget hsb] config -troughcolor $paOption(trough_bg) \
                              -width       $paOption(trough_wd)

  [$lsw subwidget vsb] config -troughcolor $paOption(trough_bg) \
                              -width       $paOption(trough_wd)

  pack $lsw -side bottom -fill both -expand yes

  set lswf [$lsw subwidget window]

  set ltext [text $lswf.tx -bg yellow \
                           -font $tixOption(font) \
                           -height 200 -wrap word -bd 0]

  pack $ltext -side top -fill both -expand yes

  set gPB(MSG) $ltext
}

#-------------------------------------------------------------------------------
proc UI_PB_debug_DisplayMsg {s} {
#-------------------------------------------------------------------------------
 global tcl_platform
 global gPB

  if { $gPB(DEBUG) } \
  {
    if {$tcl_platform(platform) == "windows"} \
    {
      set w $gPB(debug_win)

      if { ![winfo exists $w] } \
      {
        UI_PB_debug_CreateMsgWin
      }

      if {[wm state $w] == "iconic"}\
      {
         wm deiconify $w
      }

      $gPB(MSG) insert end "$s\n"

    } elseif {$tcl_platform(platform) == "unix"} \
    {
      puts "$s"
    }
  }
}

#-------------------------------------------------------------------------------
proc UI_PB_debug_ForceMsg {s} {
#-------------------------------------------------------------------------------
 global gPB

  set debug_flag $gPB(DEBUG)
  set gPB(DEBUG) 1
  UI_PB_debug_DisplayMsg $s
  set gPB(DEBUG) $debug_flag
}

