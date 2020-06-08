#========================================================================
#                     UI_PB_METHODS.TCL
#========================================================================
##############################################################################
# Description                                                                #
#     This file contains all the methods of the ui classes.                  #
#                                                                            #
# Revisions                                                                  #
#                                                                            #
#   Date        Who       Reason                                             #
# 01-feb-1999   mnb       Initial                                            #
# 07-Apr_1999   mnb       Changed bitmap name                                #
# 02-Jun-1999   mnb       Code Integration                                   #
# 14-Jun-1999   gsl       Made tixControl react to the user's key strokes    #
#                         immaediately.                                      #
# 07-Sep-1999   mnb       Added few procedures for page class                #
# 21-Sep-1999   mnb       Added a new procedure, to create combo box menu    #
# 17-Nov-1999   gsl       Submitted for phase-22.                            #
#                                                                            #
# $HISTORY$                                                                  #
#                                                                            #
##############################################################################

#========================================================================
proc UI_PB_mthd_CreateFrame {inp_frm frm_ext} {
#========================================================================
    set frame_id [frame $inp_frm.$frm_ext]
    return $frame_id
}

#========================================================================
proc UI_PB_mthd_CreateLabel {inp_frm ext label} {
#========================================================================

  label $inp_frm.$ext -text $label -wraplength 170
  pack $inp_frm.$ext -pady 5
}

#========================================================================
proc UI_PB_mthd_CreateLblFrame {inp_frm ext label} {
#========================================================================
    tixLabelFrame $inp_frm.$ext -label $label
    return $inp_frm.$ext
}

#========================================================================
proc UI_PB_mthd_CreateIntControl {var inp_frm ext label} {
#========================================================================
  global mom_sys_arr
  global tixOption

  tixControl $inp_frm.$ext -integer true \
        -variable   mom_sys_arr($var) \
        -selectmode immediate \
        -options {
               entry.width 3
               label.anchor e
         }
  $inp_frm.$ext.frame config -relief sunken -bd 1
  $inp_frm.$ext.frame.entry config -relief flat
  
  if {[string compare $label ""] == 0} \
  {
      set text $label
  } else \
  {
    set text [UI_PB_com_FormatString $label]
    label $inp_frm.1_$ext -text $text -font $tixOption(font)
    pack $inp_frm.1_$ext -side left -padx 20 -pady 2
  }

  pack $inp_frm.$ext -side right -padx 5 -pady 2

}

#========================================================================
proc UI_PB_mthd_CreateFloatControl {val1 val2 inp_frm ext label} {
#========================================================================
  global mom_sys_arr
  global tixOption

  tixControl $inp_frm.1_$ext -integer true \
        -variable   mom_sys_arr($val1) \
        -selectmode immediate \
        -options {
               entry.width 2
               label.anchor e
         }

  label $inp_frm.2_$ext -text "."

  tixControl $inp_frm.3_$ext -integer true \
        -variable   mom_sys_arr($val2) \
        -selectmode immediate \
        -options {
               entry.width 2
               label.anchor e
         }
  $inp_frm.1_$ext.frame config -relief sunken -bd 1
  $inp_frm.1_$ext.frame.entry config -relief flat
  $inp_frm.3_$ext.frame config -relief sunken -bd 1
  $inp_frm.3_$ext.frame.entry config -relief flat

  if {[string compare $label ""] == 0} \
  {
      set text $label
  } else \
  {
      set text [format %-20s $label]
  }

  label $inp_frm.4_$ext -text $text -font $tixOption(font)
  pack $inp_frm.4_$ext $inp_frm.1_$ext $inp_frm.2_$ext \
       $inp_frm.3_$ext -side left

}

#========================================================================
proc UI_PB_mthd_CreateLblEntry { data_type var inp_frm ext label} {
#========================================================================
  global mom_sys_arr
  global tixOption

  if {[string compare $label ""] == 0} \
  {
      set text $label
  } else \
  {
      set text [format %-20s $label]
  }

  label $inp_frm.$ext -text $text -font $tixOption(font)
  entry $inp_frm.1_$ext -width 10 -relief sunken -bd 2 \
                        -textvariable mom_sys_arr($var)

   pack $inp_frm.$ext -side left -padx 5 -pady 5
   pack $inp_frm.1_$ext -side right -padx 5 -pady 5

   if { $data_type == "a" } \
   {
     set data_type [UI_PB_com_RetSysVarDataType var]
   }

   bind $inp_frm.1_$ext <KeyPress> "UI_PB_com_ValidateDataOfEntry %W %K \
                                            $data_type"
   bind $inp_frm.1_$ext <KeyRelease> {%W config -state normal }
}

#========================================================================
proc UI_PB_mthd_CreateCheckButton {var inp_frm ext label} {
#========================================================================
  global mom_sys_arr
  set text $label
  checkbutton $inp_frm.$ext -text "$text" \
                         -variable mom_sys_arr($var) \
                         -relief flat -bd 2 -anchor w

  pack $inp_frm.$ext -side left -padx 5
}

#========================================================================
proc UI_PB_mthd_CreateButton { inp_frm ext label} {
#========================================================================

  set text [format %-20s $label]
  button $inp_frm.$ext -text "$text"

  pack $inp_frm.$ext -padx 50 -anchor c 

}

#========================================================================
proc UI_PB_mthd_CreateRadioButton { var inp_frm ext label } {
#========================================================================
  global mom_sys_arr
  set text [join [split $label " "] _]
  radiobutton $inp_frm.$ext -text $label -variable mom_sys_arr($var) \
                            -value $text
  pack $inp_frm.$ext -side left -padx 5
}

#========================================================================
proc UI_PB_mthd_CreateEntry { var inp_frm ext } {
#========================================================================
  global mom_sys_arr

  entry $inp_frm.1_$ext -width 30 -relief sunken -bd 2 \
         -textvariable mom_sys_arr($var) -state disabled

   pack $inp_frm.1_$ext -side left

}

#========================================================================
proc UI_PB_mthd_CreateOptionalMenu { var inp_frm ext option_list \
                                     label } {
#========================================================================
  global mom_sys_arr
  set temp_value $mom_sys_arr($var)

  if { [string compare $label ""] == 0} \
  {
     set text ""
  } else \
  {
     set text [format %-25s $label]
  }
   
   tixOptionMenu $inp_frm.$ext -label $text \
        -variable mom_sys_arr($var) \
        -options {
                    menubutton.width 25
                 }

   foreach option $option_list \
   {
       set temp_opt [split $option " "]
       set opt [join $temp_opt _]
       $inp_frm.$ext add command $opt -label $option
       unset temp_opt opt
   }

   $inp_frm.$ext config -value $temp_value
   pack $inp_frm.$ext -padx 3 -pady 10
}

#========================================================================
proc UI_PB_mthd_CreatePane {this} {
#========================================================================
  global paOption
  set page_id $Page::($this,page_id)
  set pane [tixPanedWindow $page_id.pane -orient horizontal]
  pack $pane -expand yes -fill both

  set f1 [$pane add p1 -expand 1 -size 225]
  set f2 [$pane add p2 -expand 1 -size 675]
  set Page::($this,left_pane_id) $f1

  $f1 config -relief flat
  $f2 config -relief flat

  set p2s [$pane subwidget p2]
  set p2p [frame $p2s.pp]
  pack $p2p -expand yes -fill both

  tixScrolledWindow $p2p.scr
  [$p2p.scr subwidget hsb] config -troughcolor $paOption(trough_bg) \
                             -width       $paOption(trough_wd)
  [$p2p.scr subwidget vsb] config -troughcolor $paOption(trough_bg) \
                             -width       $paOption(trough_wd)
  pack $p2p.scr -padx 5 -expand yes -fill both

  set p2t [$p2p.scr subwidget window]
  set sec_frm [frame $p2t.f]
  pack $sec_frm -expand yes -fill both
  set Page::($this,canvas_frame) $sec_frm
}

#========================================================================
proc UI_PB_mthd_CreateTree {this} {
#========================================================================
   global paOption
   global tixOption

   set left_pane $Page::($this,left_pane_id)

   # Tree
      set tree [tixTree $left_pane.slb \
       -options {
            hlist.indicator   1
            hlist.indent      20
            hlist.drawbranch  1
            hlist.selectMode  single
            hlist.width       40
            hlist.separator   "."
            hlist.wideselect  false
        }]
     set Page::($this,tree) $tree

     [$tree subwidget hsb] config -troughcolor $paOption(trough_bg) \
                              -width $paOption(trough_wd)
     [$tree subwidget vsb] config -troughcolor $paOption(trough_bg) \
                              -width $paOption(trough_wd)
     pack $tree -side top -fill both -expand yes -padx 5

}

#========================================================================
proc UI_PB_mthd_CreateCheckList {this} {
#========================================================================
   global paOption
   global tixOption

   set left_pane $Page::($this,left_pane_id)

   # Tree
      set tree [tixCheckList $left_pane.slb \
       -options {
            relief            sunken
            hlist.indicator   1
            hlist.indent      20
            hlist.drawbranch  1
            hlist.selectMode  single
            hlist.width       40
            hlist.separator   "."
            hlist.wideselect  false
        }]
     set Page::($this,tree) $tree

     [$tree subwidget hsb] config -troughcolor $paOption(trough_bg) \
                              -width $paOption(trough_wd)
     [$tree subwidget vsb] config -troughcolor $paOption(trough_bg) \
                              -width $paOption(trough_wd)
     pack $tree -side top -fill both -expand yes -padx 5

}

#========================================================================
proc UI_PB_mthd_CreateCanvas {this TOP_CANVAS_DIM BOT_CANVAS_DIM} {
#========================================================================
   upvar $TOP_CANVAS_DIM top_canvas_dim
   upvar $BOT_CANVAS_DIM bot_canvas_dim
   global paOption

   # Gets the canvas frame id
     set WIDGET $Page::($this,canvas_frame)

   set seq_canvas_id [frame $WIDGET.frame]
   set box [tixButtonBox $WIDGET.box \
             -orientation horizontal \
             -bd 2 \
             -relief sunken \
             -bg yellow]
   pack $seq_canvas_id -side top -fill both -expand yes
   pack $box -side bottom -fill x -padx 3 -pady 3

   # Creates top canvas
     set top_canvas [canvas $seq_canvas_id.top]

   # configures the height and width of the top canvas
      $top_canvas config -height $top_canvas_dim(0) -width $top_canvas_dim(1)
      pack $top_canvas -side top -fill x -padx 3

   # Supress highlight color of top canvas
      set bc [$top_canvas config -background]
      $top_canvas config -highlightcolor [lindex $bc end]

   # Bottom Canvas
   # Create the horizontal scrollers for bottom canvas
     set hs [scrollbar $seq_canvas_id.hs -orient horizontal \
                      -troughcolor $paOption(can_trough_bg) \
                      -width       $paOption(trough_wd) \
                      -command     "$seq_canvas_id.bot xview"]

   # Create the vertical scrollers for bottom canvas
     set vs [scrollbar $seq_canvas_id.vs -orient vertical \
                     -troughcolor $paOption(can_trough_bg) \
                     -width       $paOption(trough_wd) \
                     -command     "$seq_canvas_id.bot yview"]

   # Creates the bottom canvas with horizontal and vertical scrollers
     set bot_canvas [canvas $seq_canvas_id.bot -relief sunken \
                     -bd 2 -bg $paOption(can_bg) \
                     -xscrollcommand "$seq_canvas_id.hs set" \
                     -yscrollcommand "$seq_canvas_id.vs set"]

     pack $hs -side bottom -fill x
     pack $bot_canvas -side left -expand yes -fill both -padx 3
     pack $vs -side right -fill y

   # Configures the scrollregion for the bottom canvas
     $bot_canvas config -scrollregion "0 0 $bot_canvas_dim(0) \
                              $bot_canvas_dim(1)"
   # Stores the top canvas and bottom canvas ids in the page object
     set Page::($this,act_can_frame) $seq_canvas_id
     set Page::($this,top_canvas) $top_canvas
     set Page::($this,bot_canvas) $bot_canvas
     set Page::($this,panel_hi) $top_canvas_dim(0)
     set Page::($this,hor_scrol) $hs
     set Page::($this,ver_scrol) $vs
     set Page::($this,bot_height) $bot_canvas_dim(0)
     set Page::($this,box) $box
}

#========================================================================
proc UI_PB_mthd_CreateMenu { this } {
#========================================================================
  # Gets the top canvas id from the page object
    set top_canvas $Page::($this,top_canvas)

  # Creates a frame on top canvas to put the entry and
  # menu button
    set evt_frm [frame $top_canvas.f]
    $top_canvas create window 495 40 -window $evt_frm

  # gets the image ids
    set cbx      [tix getbitmap cbxarrow]
    set entry_icon [UI_PB_blk_CreateIcon $top_canvas pb_comb_entry ""]

  # Entry icon
    $top_canvas create image 330 40 -image $entry_icon
    $entry_icon config -relief sunken -bd 2 -bg lightBlue
    set Page::($this,entry_cx) 330
    set Page::($this,entry_cy) 40

  # Creates a menu button
    menubutton $evt_frm.but -bitmap $cbx -width 17 -height 20 \
                     -relief raised -menu $evt_frm.but.menu

    pack $evt_frm.but -side left -padx 1
    set comb_widget $evt_frm.but.menu

  # Creates a menu
    menu $comb_widget
    set Page::($this,comb_widget) $comb_widget
}

#========================================================================
proc UI_PB_mthd_CreateAddTrashinCanvas {this} {
#========================================================================
    global paOption
    global tixOption

    # Gets the top canvas id from the page object
      set top_canvas $Page::($this,top_canvas)

    # Sets the top canvas height as a attribute of page object
      set panel_hi $Page::($this,panel_hi)

    # Creates the add and trash icons
      set evt_cell1(trash)  [UI_PB_blk_CreateIcon $top_canvas pb_trash ""]

    set add_comp [image create compound -window $top_canvas \
                               -bd 1 \
                               -background #c0c0ff \
                               -borderwidth 2 \
                               -relief raised \
                               -showbackground 1]
    $add_comp add text -text $Page::($this,add_name) \
                   -font $tixOption(bold_font) -anchor w

    # Puts the add icons at the specified center
      set dy [expr [expr $panel_hi / 2] + 2]
      $top_canvas create image 80 $dy -image $add_comp \
              -tag add_movable

    # configures the background color of add icon
      $add_comp config -bg $paOption(app_butt_bg)
      set Page::($this,add) $add_comp


    # Locates the Trash icon at the specified center
      $top_canvas create image 610 $dy -image $evt_cell1(trash) \
                -tag evt_trash

    # Configures the background color of trash icon
      $evt_cell1(trash) config -bg $paOption(app_butt_bg)


    # Stores the trash cell id the dimensions of the trash icon
      lappend trash_cell $evt_cell1(trash) [expr 610 - 80] \
                      [expr 610 + 80] -$panel_hi 0

     set Page::($this,trash) $trash_cell
}

