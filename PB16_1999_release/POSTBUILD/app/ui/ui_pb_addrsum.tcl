#=============================================================================
#                  UI_PB_ADDRSUM.TCL
#=============================================================================
##############################################################################
# Description                                                                #
#     This file contains all functions dealing with the creation of          #
#     ui elements for Address Summary page.                                  #
#                                                                            #
# Revisions                                                                  #
#                                                                            #
#   Date        Who       Reason                                             #
# 01-feb-1999   mnb       Initial                                            #
# 07-Apr-1999   mnb       Attached callbacks to action buttons               #
# 26-Apr-1999   gsl       Applied tixGrid.                                   #
# 26-May-1999   gsl       Attached popup menu to left mouse button for       #
#                         Leader & Trailer.                                  #
# 02-Jun-1999   mnb       Code Integration                                   #
# 09-Jun-1999   mnb       Update Address, Format objects & Attached callbacks#
#                         to action buttons                                  #
# 14-Jun-1999   gsl       Associated balloons with Address names             #
# 15-Jun-1999   mnb       Attached callbacks to update the format            #
# 15-Jun-1999   mnb       Set selectmode to immediate for tixcontrol         #
# 16-Jun-1999   mnb       Updates format value                               #
# 01-Jul-1999   mnb       Added new line option to End of Block              #
# 07-Jul-1999   mnb       Enables the entry when the option is set to text   #
# 07-Sep-1999   mnb       Added Address Data Type widget & Changes the       #
#                         the status of widgets based upon the data type     #
# 21-Sep-1999   mnb       Adds & Deletes the addresses from the grid, based  #
#                         upon the addition and creation of address in       #
#                         Block/Address page.                                #
# 16-Nov-1999   gsl       Revised UI_PB_ads_UpdateGridRows &                 #
#                         UI_PB_ads_TabAddrsumCreate to prevent tixGrid from #
#                         crash.                                             #
# 17-Nov-1999   gsl       Submitted for phase-22.                            #
#                                                                            #
# $HISTORY$                                                                  #
#                                                                            #
##############################################################################

#*****************************************************************************
proc UI_PB_ProgTpth_AddSum {book_id page_obj} {
#*****************************************************************************
  global paOption

  set Page::($page_obj,page_id) [$book_id subwidget \
                            $Page::($page_obj,page_name)]
  set page_id $Page::($page_obj,page_id)

  set top_frm [frame $page_id.top]
  set mid_frm [frame $page_id.mid]
  set bot_frm [frame $page_id.bot]

  pack $top_frm -side top -fill both -expand yes
  pack $mid_frm -side top -fill both -expand yes -pady 5
  pack $bot_frm -side bottom -fill both -expand yes

 # Creates scroller window in top frame
  tixScrolledGrid $top_frm.scr -bd 0 -scrollbar auto
  [$top_frm.scr subwidget hsb] config -troughcolor $paOption(trough_bg) \
                               -width $paOption(trough_wd)
  [$top_frm.scr subwidget vsb] config -troughcolor $paOption(trough_bg) \
                               -width $paOption(trough_wd)

  pack $top_frm.scr -padx 3 -pady 0
  set grid [$top_frm.scr subwidget grid]

  global gPB
  set gPB(tix_grid) $grid

  $grid config -relief sunken -bd 3 \
               -formatcmd "SimpleFormat $grid" \
               -state disabled \
               -height 10 -width 9

 # Set the size of the columns
 #
  $grid size col default -size auto -pad0 5 -pad1 5
  $grid size row default -size auto -pad0 3 -pad1 4

  UI_PB_ads__CreateAdrAttributes page_obj $grid
  UI_PB_ads__CreateSpecCharButton page_obj $mid_frm
  UI_PB_ads__CreateActionButtons $bot_frm page_obj

 # Flag
   set Page::($page_obj,addsum_flag) 0
}

#-----------------------------------------------------------------------------
proc SimpleFormat {w area x1 y1 x2 y2} {
#-----------------------------------------------------------------------------
#
# This command is called whenever the background of the grid needs to
# be reformatted. The x1, y1, x2, y2 specifies the four corners of the area
# that needs to be reformatted.
#
# area:
#  x-margin:    the horizontal margin
#  y-margin:    the vertical margin
#  s-margin:    the overlap area of the x- and y-margins
#  main:        The rest
#
#-----------------------------------------------------------------------------
  global margin
  global paOption

  set bg(s-margin) royalBlue
  set bg(x-margin) $paOption(title_bg)
  set bg(y-margin) $paOption(table_bg)
  set bg(main)     gray20

  case $area {
    main {
          # The "grid" format is consecutive boxes without 3d borders
          #
           $w format grid $x1 $y1 $x2 $y2 -anchor se
    }
    {x-margin} {
           $w format border $x1 $y1 $x2 $y2 \
                -fill 1 -relief raised -bd 2 -bg $bg($area)
    }
    {y-margin} {
           $w format border $x1 $y1 $x2 $y2 \
                -fill 1 -relief raised -bd 2 -bg $bg($area)
    }
    {s-margin} {
           $w format border $x1 $y1 $x2 $y2 \
                -fill 1 -relief raised -bd 2 -bg $bg($area)
    }
  }
}

#=============================================================================
proc UI_PB_ads__CreateAdrAttributes { PAGE_OBJ grid } {
#=============================================================================
  upvar $PAGE_OBJ page_obj
  global paOption tixOption
  global addr_app_text
  global gpb_addr_var
  global gpb_fmt_var

  set title_col(0)  "Address"
  set title_col(1)  "Leader"
  set title_col(2)  "Data Type"
  set title_col(3)  "Plus (+)"
  set title_col(4)  "Lead Zero"
  set title_col(5)  "Integer"
  set title_col(6)  "Decimal (.)"
  set title_col(7)  "Fraction"
  set title_col(8)  "Trail Zero"
  set title_col(9)  "Modality Override"
  set title_col(10) "Minimum"
  set title_col(11) "Maximum"
  set title_col(12) "Trailer"

  set no_col 13

 # Add column titles
 #
  set style [tixDisplayStyle text -refwindow $grid \
             -fg $paOption(title_fg) \
             -anchor c -font $tixOption(bold_font)]

  $grid set 0 0 -itemtype text -text $title_col(0) \
                -style [tixDisplayStyle text -refwindow $grid \
                        -fg yellow -anchor c -font $tixOption(bold_font)]

  for {set col 1} {$col < $no_col} {incr col} {
    $grid set $col 0 -itemtype text -text $title_col($col) -style $style
  }

  PB_int_AddrSummaryAttr addsum_add_name_list addr_app_text add_desc_arr
  set no_addr [llength $addsum_add_name_list]
  set cur_addsum_list ""
  for {set count 0} {$count < $no_addr} {incr count} \
  {
    set add_name [lindex $addsum_add_name_list $count]
    set add_desc $add_desc_arr($count)

    UI_PB_ads__CreateFirstColAttr $grid [expr $count + 1] $add_name $add_desc
    UI_PB_ads__CreateSecColAttr  $page_obj $grid [expr $count + 1] $add_name
    lappend cur_addsum_list $add_name
  }
  set Page::($page_obj,cur_addsum_list) $cur_addsum_list
  set Page::($page_obj,total_no_rows) [expr $count + 1] 
}

#=============================================================================
proc UI_PB_ads__CreateFirstColAttr { grid no_row add_name add_desc } {
#=============================================================================
  global paOption tixOption
  global addr_app_text
  global gpb_addr_var


 set name_frm $grid.name_$add_name
 if { ![winfo exists $name_frm] } {
  set name_frm [frame $grid.name_$add_name -bg lightSkyBlue]
  set addn [button $name_frm.name -text $add_name \
                                  -font $tixOption(bold_font) \
                                  -width 10 -anchor w \
                                  -relief flat -bd 0 \
                                  -background $paOption(table_bg) \
                                  -highlightbackground $paOption(table_bg) \
                                  -state disabled \
                                  -disabledforeground blue \
                                  -cursor ""]

  bind $addn <Enter> "+%W config -highlightbackground cyan"
  bind $addn <Leave> "+%W config -highlightbackground $paOption(table_bg)"

  pack $addn -side right -anchor e -padx 3
  PB_enable_balloon $addn
  global gPB_help_tips
  set gPB_help_tips($addn) $add_desc
 }
 $grid set 0 $no_row -itemtype window -window $name_frm

 set add_frm $grid.add_$add_name 
 if { ![winfo exists $add_frm] } {
  set add_frm [frame $grid.add_$add_name] 

  set but [entry $add_frm.but \
                     -textvariable gpb_addr_var($add_name,leader_name) \
                     -cursor hand2 \
                     -width 5 -borderwidth 4 \
                     -highlightcolor lightYellow \
                     -background royalBlue \
                     -foreground yellow \
                     -selectbackground lightYellow \
                     -selectforeground black]

  bind $but <Enter> " CB__AttachPopupMenu page_obj $add_frm $add_name LEADER "

  set ent [entry $add_frm.ent -textvariable addr_app_text($add_name) \
                  -state disabled -relief solid -width 6 -borderwidth 1 \
                  -justify left -bg lightBlue]
  pack $but -side left -anchor ne -padx 2
  pack $ent -side right -anchor nw -padx 2 -pady 5
 }
 $grid set 1 $no_row -itemtype window -window $add_frm
}

#-----------------------------------------------------------------------------
proc CB__AttachPopupMenu {PAGE_OBJ w add_name attr} {
#-----------------------------------------------------------------------------
  upvar $PAGE_OBJ     page_obj

  if {![winfo exists $w.pop]} \
  {
    set menu [menu $w.pop -tearoff 0]
    bind $w.but <1>      "focus %W"
    bind $w.but <3>      "focus %W"
    bind $w.but <3>      "+tk_popup $menu %X %Y"

    UI_PB_ads__SetPopupOptions page_obj menu $w $add_name $attr
  }
}

#-----------------------------------------------------------------------------
proc getAttrType {attr} {
#-----------------------------------------------------------------------------
   if {$attr == "LEADER"} \
   {
     set type leader_name
   } elseif {$attr == "TRAILER"} \
   {
     set type trailer
   } else \
   {
     set answer [tk_messageBox -message \
     "Attribute type should be LEADER or TRAILER! \n(proc getAttrType)" \
                -type ok -icon error]

     set type leader_name
   }

return $type
}

#=============================================================================
proc UI_PB_ads__SetPopupOptions {PAGE_OBJ MENU add_frm add_name attr} {
#=============================================================================
   upvar $PAGE_OBJ     page_obj
   upvar $MENU         menu
   global gpb_addr_var


   set type [getAttrType $attr]

   set options_list {A B C D E F G H I J K L M N O \
                     P Q R S T U V W X Y Z None}

   set count 1
   foreach ELEMENT $options_list \
   {
     if {$ELEMENT == "None"} \
     {
       set elmt "\"\""
       $menu add command -label $ELEMENT -command \
              "setLeaderTrailer $add_frm $add_name $type $elmt"
     } elseif {$ELEMENT == "Help"} \
     {
       $menu add command -label $ELEMENT
     } else \
     {
       if {$count == 1} \
       {
         $menu add command -label $ELEMENT -columnbreak 1 -command \
              "setLeaderTrailer $add_frm $add_name $type $ELEMENT"
       } else \
       {
         $menu add command -label $ELEMENT -command \
              "setLeaderTrailer $add_frm $add_name $type $ELEMENT"
       }
     }

     if {$count == 9} \
     {
       set count 0
     }
     incr count
   }
}

#-----------------------------------------------------------------------------
proc setLeaderTrailer {add_frm add_name type elmt } {
#-----------------------------------------------------------------------------
  global gpb_addr_var
  global add_dis_attr
  global AddObjAttr

   if {$type == "leader_name"} \
   {
     set add_dis_attr(0) $elmt
   } else \
   {
     set add_dis_attr(2) $elmt
   }

   set gpb_addr_var($add_name,$type) $elmt
   $add_frm.but selection range 0 end
}

#=============================================================================
proc UI_PB_ads__RadDataCallBack { grid row_no data_type format_name } {
#=============================================================================
  global gPB
  set grid $gPB(tix_grid)

  PB_int_GetAddrListFormat format_name fmt_addr_list
  foreach add_name $fmt_addr_list \
  {
     UI_PB_ads__DisableDataAttr $grid $add_name $data_type $format_name
  }
}

#=============================================================================
proc UI_PB_ads__DisableDataAttr { grid add_name data_type fmt_name } {
#=============================================================================
  global gpb_fmt_var

  switch $data_type \
  {
     "Int"   {
                $grid.plus_$add_name.ch config -state normal
                $grid.lez_$add_name.ch config -state normal
                $grid.int_$add_name.con config -state normal
                $grid.dec_$add_name.ch config -state disabled
                $grid.fra_$add_name.con config -state disabled
                $grid.trz_$add_name.ch config -state disabled
                $grid.min_$add_name.ent config -state normal
                $grid.max_$add_name.ent config -state normal
                update idletasks
             }

     "Real"  {
                $grid.plus_$add_name.ch config -state normal
                $grid.lez_$add_name.ch config -state normal
                $grid.int_$add_name.con config -state normal
                $grid.dec_$add_name.ch config -state normal
                $grid.fra_$add_name.con config -state normal
                $grid.trz_$add_name.ch config -state normal
                $grid.min_$add_name.ent config -state normal
                $grid.max_$add_name.ent config -state normal
                update idletasks
             }

     "Text"  {
                $grid.plus_$add_name.ch config -state disabled
                $grid.lez_$add_name.ch config -state disabled
                $grid.int_$add_name.con config -state disabled
                $grid.dec_$add_name.ch config -state disabled
                $grid.fra_$add_name.con config -state disabled
                $grid.trz_$add_name.ch config -state disabled
                $grid.min_$add_name.ent config -state disabled
                $grid.max_$add_name.ent config -state disabled
                update idletasks
             }
  }
}

#=============================================================================
proc UI_PB_ads__CreateSecColAttr { page_obj grid no_row add_name } {
#=============================================================================
  global gpb_addr_var
  global gpb_fmt_var
  global paOption

  set temp_var $gpb_addr_var($add_name,modal)
  set fmt_name $gpb_addr_var($add_name,fmt_name)

  # Data Type widget
  set dat_frm $grid.dat_$add_name
  if { ![winfo exists $dat_frm] } {
    set dat_frm [frame $grid.dat_$add_name]
    radiobutton $dat_frm.int -text Int -variable \
         gpb_fmt_var($fmt_name,dtype) -value Integer \
         -command "UI_PB_ads__RadDataCallBack $grid $no_row Int $fmt_name"
    radiobutton $dat_frm.flt -text Real -variable \
         gpb_fmt_var($fmt_name,dtype) -value "Real Number" \
         -command "UI_PB_ads__RadDataCallBack $grid $no_row Real $fmt_name"
    radiobutton $dat_frm.text -text Text -variable \
         gpb_fmt_var($fmt_name,dtype) -value "Text String" \
         -command "UI_PB_ads__RadDataCallBack $grid $no_row Text $fmt_name"

    pack $dat_frm.int -side left -anchor ne
    pack $dat_frm.flt -side left -anchor ne
    pack $dat_frm.text -side right -anchor nw
  }
  $grid set 2 $no_row -itemtype window -window $dat_frm

  # Plus Widget
  set pls_frm $grid.plus_$add_name
  if { ![winfo exists $pls_frm] } {
    set pls_frm [frame $grid.plus_$add_name]
    set plus [checkbutton $pls_frm.ch \
             -command "UI_PB_UpdateAllAddFmt $page_obj $fmt_name" \
             -variable gpb_fmt_var($fmt_name,plus_status)]
    pack $plus -anchor n
  }
  $grid set 3 $no_row -itemtype window -window $pls_frm

  # Leading zeros widget
  set lez_frm $grid.lez_$add_name
  if { ![winfo exists $lez_frm] } {
    set lez_frm [frame $grid.lez_$add_name]
    set lead_zero [checkbutton $lez_frm.ch \
                -command "UI_PB_UpdateAllAddFmt $page_obj $fmt_name" \
                -variable gpb_fmt_var($fmt_name,lead_zero)]
    pack $lead_zero -anchor n
  }
  $grid set 4 $no_row -itemtype window -window $lez_frm

  # Integer widget
  set int_frm $grid.int_$add_name
  if { ![winfo exists $int_frm] } {
    set int_frm [frame $grid.int_$add_name]
    set var 0
    UI_PB_ads__CreateIntControl $page_obj $int_frm con $fmt_name $add_name \
                                [expr $no_row - 1]
  }
  $grid set 5 $no_row -itemtype window -window $int_frm

  # Decimal widget
  set dec_frm $grid.dec_$add_name
  if { ![winfo exists $dec_frm] } {
    set dec_frm [frame $grid.dec_$add_name]
    set dec_pt [checkbutton $dec_frm.ch \
                -command "UI_PB_UpdateAllAddFmt $page_obj $fmt_name" \
                -variable gpb_fmt_var($fmt_name,decimal)]
    pack $dec_pt -anchor n
  }
  $grid set 6 $no_row -itemtype window -window $dec_frm

  # Fraction widget
  set fra_frm $grid.fra_$add_name
  if { ![winfo exists $fra_frm] } {
    set fra_frm [frame $grid.fra_$add_name]
    set var 0
    UI_PB_ads__CreateFracControl $page_obj $fra_frm con $fmt_name $add_name \
                                 [expr $no_row - 1]
  }
  $grid set 7 $no_row -itemtype window -window $fra_frm

  # Trailing Zeros
  set trz_frm $grid.trz_$add_name
  if { ![winfo exists $trz_frm] } {
    set trz_frm [frame $grid.trz_$add_name]
    set trail_zero [checkbutton $trz_frm.ch \
                -command "UI_PB_UpdateAllAddFmt $page_obj $fmt_name" \
                -variable gpb_fmt_var($fmt_name,trailzero)]
    pack $trail_zero -anchor n
  }
  $grid set 8 $no_row -itemtype window -window $trz_frm

  # Modality widget
  set mod_frm $grid.modl_$add_name
  if { ![winfo exists $mod_frm] } {
    set mod_frm [frame $grid.modl_$add_name]
    tixOptionMenu $mod_frm.opt \
                    -variable gpb_addr_var($add_name,modal) \
                    -options { menubutton.width 6 }
    foreach opt {always once off} {
    $mod_frm.opt add command $opt -label $opt
    }
    $mod_frm.opt config -value $temp_var
    tixForm $mod_frm.opt -top 3 -left %10 -right %95
  }
  $grid set 9 $no_row -itemtype window -window $mod_frm

  # Minimum widget
  set min_frm $grid.min_$add_name
  if { ![winfo exists $min_frm] } {
    set min_frm [frame $grid.min_$add_name]
    entry $min_frm.ent -width 8 -relief sunken \
                       -textvariable gpb_addr_var($add_name,add_min)

    tixForm $min_frm.ent -top 3 -left %10 -right %95
    bind $min_frm.ent <KeyPress> "UI_PB_com_ValidateDataOfEntry %W %K f"
    bind $min_frm.ent <KeyRelease> { %W config -state normal }
  }
  $grid set 10 $no_row -itemtype window -window $min_frm

  # Maximum Widget
  set max_frm $grid.max_$add_name
  if { ![winfo exists $max_frm] } {
    set max_frm [frame $grid.max_$add_name]
    entry $max_frm.ent -width 8 -relief sunken \
                       -textvariable gpb_addr_var($add_name,add_max)

    tixForm $max_frm.ent -top 3 -left %10 -right %95
    bind $max_frm.ent <KeyPress> "UI_PB_com_ValidateDataOfEntry %W %K f"
    bind $max_frm.ent <KeyRelease> { %W config -state normal }
  }
  $grid set 11 $no_row -itemtype window -window $max_frm

  # Trailing Characters
  set tra_frm $grid.trail_$add_name
  if { ![winfo exists $tra_frm] } {
    set tra_frm [frame $grid.trail_$add_name]
    set but [entry $tra_frm.but \
                       -textvariable gpb_addr_var($add_name,trailer) \
                       -cursor hand2 \
                       -width 5 -borderwidth 4 \
                       -highlightcolor lightYellow \
                       -background royalBlue \
                       -foreground yellow \
                       -selectbackground lightYellow \
                       -selectforeground black]
    bind $but <Enter> " CB__AttachPopupMenu page_obj $tra_frm $add_name \
                                          TRAILER "
    tixForm $but -top 3 -left 5
  }
  $grid set 12 $no_row -itemtype window -window $tra_frm
}

#=============================================================================
proc UI_PB_ads__CreateFracControl { page_obj inp_frm ext fmt_name add_name \
                                    no_row} {
#=============================================================================
  global gpb_fmt_var

  tixControl $inp_frm.$ext -integer true \
        -command "UI_PB_UpdateFmtDisplay $page_obj $add_name $fmt_name \
                                         $no_row" \
        -selectmode immediate \
        -variable gpb_fmt_var($fmt_name,fraction) \
        -options {
               entry.width 3
               label.anchor e
         }
  $inp_frm.$ext.frame config -relief sunken -bd 1
  $inp_frm.$ext.frame.entry config -relief flat

  grid $inp_frm.$ext -padx 5 -pady 4
}

#=============================================================================
proc UI_PB_ads__CreateIntControl { page_obj inp_frm ext fmt_name add_name \
                                   no_row} {
#=============================================================================
  global gpb_fmt_var

  tixControl $inp_frm.$ext -integer true \
        -command "UI_PB_UpdateFmtDisplay $page_obj $add_name $fmt_name \
                                         $no_row" \
        -selectmode immediate \
        -variable gpb_fmt_var($fmt_name,integer) \
        -options {
               entry.width 3
               label.anchor e
         }
  $inp_frm.$ext.frame config -relief sunken -bd 1
  $inp_frm.$ext.frame.entry config -relief flat

  grid $inp_frm.$ext -padx 5 -pady 4

  pack $inp_frm.$ext.frame.entry -side right
  pack $inp_frm.$ext.frame.incr -side top
  pack $inp_frm.$ext.frame.decr -side bottom
}

#=============================================================================
proc UI_PB_UpdateAllAddFmt { page_obj fmt_name args } {
#=============================================================================
  set addr_name_list $Page::($page_obj,cur_addsum_list)

  PB_int_GetAddrListFormat fmt_name fmt_addr_list

  if {[info exists fmt_addr_list]} \
  {
     foreach add_name $fmt_addr_list \
     {
       set temp_index [lsearch $addr_name_list $add_name]
       if {$temp_index != -1} \
       {
          UI_PB_UpdateFmtDisplay $page_obj $add_name $fmt_name
       }
     }
  }
}

#=============================================================================
proc UI_PB_UpdateFmtDisplay { page_obj add_name fmt_name args } {
#=============================================================================
  global gpb_fmt_var
  global gpb_addr_var
  global addr_app_text

  if {$gpb_fmt_var($fmt_name,decimal) == 1} \
  {
    set fmt_obj_attr(1) "Real Number"
  } elseif {$gpb_fmt_var($fmt_name,decimal) == 0 && \
            $gpb_fmt_var($fmt_name,integer) == 0} \
  {
    set fmt_obj_attr(1) "Text String"
  } elseif {$gpb_fmt_var($fmt_name,decimal) == 0} \
  {
    set fmt_obj_attr(1) "Integer"
  }

  set fmt_obj_attr(2) $gpb_fmt_var($fmt_name,plus_status)
  set fmt_obj_attr(3) $gpb_fmt_var($fmt_name,lead_zero)
  set fmt_obj_attr(4) $gpb_fmt_var($fmt_name,trailzero)
  set fmt_obj_attr(5) $gpb_fmt_var($fmt_name,integer)
  set fmt_obj_attr(6) $gpb_fmt_var($fmt_name,decimal)
  set fmt_obj_attr(7) $gpb_fmt_var($fmt_name,fraction)

  set addr_name_list $Page::($page_obj,cur_addsum_list)
  if { [lsearch $addr_name_list $add_name] != -1 } \
  {
     PB_int_GetAdsFmtValue add_name fmt_obj_attr dis_attr
     set addr_app_text($add_name) $dis_attr
  }
}

#=============================================================================
proc UI_PB_ads__CreateSpecCharButton { PAGE_OBJ mid_frm } {
#=============================================================================
  upvar $PAGE_OBJ page_obj
  global paOption

  set bb [tixButtonBox $mid_frm.bb -orientation horizontal]
  $bb config -relief flat -bg navyBlue -padx 7 -pady 6
  $bb add spec -text "Other Data Elements"
  pack $bb -side bottom

  [$bb subwidget spec] config -padx 10 -command \
                       "UI_PB_ads__CreateSpecialCharsWin $page_obj"
}

#=============================================================================
proc UI_PB_ads__CreateSpecialCharsWin { page_obj } {
#=============================================================================
  global paOption tixOption
  global gPB

  set w [toplevel $gPB(active_window).spec]

  UI_PB_com_CreateTransientWindow $w "Other Data Elements" "+500+300" "" ""

  set page_frm [frame $w.f1 -relief sunken -bd 1]
  pack $page_frm -fill both -expand yes -padx 6 -pady 5
  UI_PB_ads_CreateSpecialChars page_obj $page_frm

  set frame [frame $w.f2]
  pack $frame -side bottom -fill x -padx 3 -pady 4

  set box1_frm [frame $frame.box1]
  set box2_frm [frame $frame.box2]

  tixForm $box1_frm -top 0 -left 3 -right %60 -padright 20
  tixForm $box2_frm -top 0 -left $box1_frm -padx 3 -right %100

  set box1 [tixButtonBox $box1_frm.resapp \
                 -orientation horizontal \
                 -bd 2 \
                 -relief sunken \
                 -bg $paOption(butt_bg)]

  set box2 [tixButtonBox $box2_frm.okcan \
                 -orientation horizontal \
                 -bd 2 \
                 -relief sunken \
                 -bg $paOption(butt_bg)]
  pack $box1 -fill x
  pack $box2 -fill x

 # Box1 attributes
  $box1 add def -text Default -width 10 \
                -bg $paOption(app_butt_bg) \
                -command "UI_PB_ads_SpecDefaultCallBack"

  $box1 add rest -text Restore -width 10 \
                -bg $paOption(app_butt_bg) \
                -command "UI_PB_ads_SpecRestCallBack $page_obj"

  $box1 add app -text Apply -width 10 \
                -bg $paOption(app_butt_bg) \
                -command "UI_PB_ads_SpecApplyCallBack"

 # Box2 attributes
  $box2 add canc -text Cancel -width 10 \
                 -bg $paOption(app_butt_bg) \
                 -command "tixDestroy $w"

  $box2 add ok -text OK -width 10 \
               -bg $paOption(app_butt_bg) \
               -command "UI_PB_ads_SpecOkCallBack $w"
}

#============================================================================
proc UI_PB_ads_SpecOkCallBack { w } {
#============================================================================

  UI_PB_ads_SpecApplyCallBack
  tixDestroy $w
}

#============================================================================
proc UI_PB_ads_SpecDefaultCallBack { } {
#============================================================================
  global mom_sys_arr
  global special_char
  set mom_var_list {0 "seqnum_start" 1 "seqnum_incr" 2 "seqnum_freq" \
                    3 "Word_Seperator" 4 "Decimal_Point" 5 "End_of_Block" \
                    6 "Comment_Start" 7 "Comment_End"}

  array set mom_var_arr $mom_var_list
  PB_int_RetDefMOMVarValues mom_var_arr mom_var_value
 
  for {set count 0} {$count < 8} {incr count} \
  {
    set var $mom_var_arr($count)
    set mom_sys_arr($var) $mom_var_value($var)
  }

  for {set count 3} {$count < 8} {incr count} \
  {
    set option_lab $mom_var_arr($count)
    UI_PB_ads__GetValuesforSpecOptions option_lab opt_value
    set special_char($option_lab,label) $opt_value
    set special_char($option_lab,char) $mom_sys_arr($option_lab)
  }
}

#============================================================================
proc UI_PB_ads_SpecRestCallBack { page_obj } {
#============================================================================
  global mom_sys_arr
  global special_char
  set mom_var_list {"seqnum_start" "seqnum_incr" "seqnum_freq" \
                    "Word_Seperator" "Decimal_Point" "End_of_Block" \
                    "Comment_Start" "Comment_End"}

  array set rest_mom_value $Page::($page_obj,rest_spec_momvar)
  foreach var $mom_var_list \
  {
    set mom_sys_arr($var) $rest_mom_value($var)
  }

  for {set count 3} {$count < 8} {incr count} \
  {
    set option_lab [lindex $mom_var_list $count]
    UI_PB_ads__GetValuesforSpecOptions option_lab opt_value
    set special_char($option_lab,label) $opt_value
    set special_char($option_lab,char) $mom_sys_arr($option_lab)
  }
}

#============================================================================
proc UI_PB_ads_SpecApplyCallBack { } {
#============================================================================
  global mom_sys_arr
  global special_char
  set mom_var_list {"seqnum_start" "seqnum_incr" "seqnum_freq" \
                    "Word_Seperator" "Decimal_Point" "End_of_Block" \
                    "Comment_Start" "Comment_End"}

  for {set count 3} {$count < 8} {incr count} \
  {
    set var [lindex $mom_var_list $count]
    set mom_sys_arr($var) $special_char($var,char)
  }
  PB_int_UpdateMOMVar mom_sys_arr
}

#*****************************************************************************
proc UI_PB_ads_CreateSpecialChars { PAGE_OBJ page_frm } {
#*****************************************************************************
  upvar $PAGE_OBJ page_obj
  global paOption tixOption
  global mom_sys_arr
  global gPB_gcode_no
  global gPB_mcode_no

  set f [frame $page_frm.f]
  pack $f -side top -pady 40

 # Creates the frames
   tixLabelFrame $f.top -label "Sequence Number"
   tixLabelFrame $f.bot -label "Special Characters"
   tixLabelFrame $f.gmcd -label "G & M Codes Output Per Block"

   tixForm $f.bot  -top 10 -pady 5 \
                   -left %50 -padx 10
   tixForm $f.gmcd -top $f.bot -pady 5 \
                                  -right $f.bot -padx 10
   tixForm $f.top  -top 10 -pady 5 -bottom &$f.bot \
                   -left &$f.gmcd -right $f.bot -padx 10
 #----------------
 # Sequence Number
 #----------------
  set top_frm [$f.top subwidget frame]

 # Sequence Number suppression
  set seqst_frm [frame $top_frm.status]
  pack $seqst_frm -side top -fill x -expand yes -padx 10

  checkbutton $seqst_frm.chk -text "Suppress Sequence Number Output" \
              -variable mom_sys_arr(SeqNo_output) -font $tixOption(font) \
              -relief flat -bd 2 -anchor c
  pack $seqst_frm.chk -pady 10 -side left

 # Sequence Number Start
  set start_frm [frame $top_frm.start]
  pack $start_frm -side top -fill x -expand yes -padx 10 -pady 5

  set start_left  [frame $start_frm.left]
  set start_right [frame $start_frm.right]

  pack $start_left  -side left
  pack $start_right -side right

  set lab_start [label $start_left.lbl -anchor w -text "Start" \
                                       -font $tixOption(font)]
  pack $lab_start -side left -fill both

  set label ""

  Page::CreateIntControl seqnum_start $start_right int $label

 # Sequence Number Increment
  set incr_frm [frame $top_frm.incr]
  pack $incr_frm -side top -fill x -expand yes -padx 10 -pady 5

  set incr_left  [frame $incr_frm.left]
  set incr_right [frame $incr_frm.right]

  pack $incr_left  -side left
  pack $incr_right -side right

  set lab_incr [label $incr_left.lbl -anchor w -text "Increment" \
                                     -font $tixOption(font)]
  pack $lab_incr -side left -fill both

  Page::CreateIntControl seqnum_incr $incr_right int $label

 # Sequence Number Frequency
  set freq_frm [frame $top_frm.freq]
  pack $freq_frm -side top -fill x -expand yes -padx 10 -pady 5

  set freq_left  [frame $freq_frm.left]
  set freq_right [frame $freq_frm.right]

  pack $freq_left  -side left
  pack $freq_right -side right

  set lab_freq [label $freq_left.lbl -anchor w -text "Frequency" \
                                       -font $tixOption(font)]
  pack $lab_freq -side left -fill both

  Page::CreateIntControl seqnum_freq $freq_right int $label

 #-------------------
 # Special Characters
 #-------------------
  set spc_frm [$f.bot subwidget frame]

  set option_1 {"None" "Space" "Decimal (.)" "Comma (,)" "Semicolon (;)" \
                "Colon (:)" "Text" }

  set option_2 {"None" "Left Parenthesis" "Right Parenthesis" \
                "Pound Sign (\#)" "Asterisk (*)" "Comma (,)" \
                "Semicolon (;)" "Colon (:)" "Slash (/)" \
                "Text" }
 
  set label_list {"Word_Seperator" "Decimal_Point" "End_of_Block" \
                  "Comment_Start" "Comment_End"}
  set count 0
  foreach label $label_list \
  {
    if {$count < 2} \
    {
      set options $option_1
    } elseif {$count == 2} \
    {
      set options $option_1
      lappend options "New Line (\\012)"
    } else \
    {
      set options $option_2
    }

    UI_PB_ads__GetValuesforSpecOptions label default
    UI_PB_ads__CreateSpecAttr $spc_frm $label $options $count $default
    incr count
    unset options
  }

  #=======================
  # G & M Codes Per Block
  #=======================
   set gmcd_frm [$f.gmcd subwidget frame]

   set gcd_frm [frame $gmcd_frm.gcd]
   set mcd_frm [frame $gmcd_frm.mcd]
   pack $gcd_frm -side top -fill both -padx 10 -pady 5
   pack $mcd_frm -side top -fill both -padx 10 -pady 5

   set gPB_gcode_no 0
   set gPB_mcode_no 0
   if { $mom_sys_arr(\$mom_sys_gcodes_per_block) != "None" } \
   {
     set gPB_gcode_no 1
   }

   if { $mom_sys_arr(\$mom_sys_mcodes_per_block) != "None" } \
   {
     set gPB_mcode_no 1
   }

   checkbutton $gcd_frm.chk -variable gPB_gcode_no -relief flat -bd 2 \
          -anchor w -command "UI_PB_ads__SetStatusGMButton gcd $gcd_frm.int"
   pack $gcd_frm.chk -side left
   Page::CreateIntControl \$mom_sys_gcodes_per_block $gcd_frm int \
                           "Number of G-Codes"
   checkbutton $mcd_frm.chk -variable gPB_mcode_no -relief flat -bd 2 \
          -anchor w -command "UI_PB_ads__SetStatusGMButton mcd $mcd_frm.int"
   pack $mcd_frm.chk -side left
   Page::CreateIntControl \$mom_sys_mcodes_per_block $mcd_frm int \
                          "Number of M-Codes"
   UI_PB_ads__SetStatusGMButton gcd $gcd_frm.int 
   UI_PB_ads__SetStatusGMButton mcd $mcd_frm.int 
}

#=============================================================================
proc UI_PB_ads__SetStatusGMButton { type widget_id } {
#=============================================================================
  global gPB_gcode_no
  global gPB_mcode_no
  global mom_sys_arr
 
  switch $type \
  {
     "gcd" {
             if { $gPB_gcode_no } \
             {
                $widget_id config -state normal
             } else \
             {
                set mom_sys_arr(\$mom_sys_gcodes_per_block) "None"
                $widget_id config -state disabled
             }
           }

     "mcd" {
             if { $gPB_mcode_no } \
             {
                $widget_id config -state normal
             } else \
             {
                set mom_sys_arr(\$mom_sys_mcodes_per_block) "None"
                $widget_id config -state disabled
             }
           }
  }
}

#=============================================================================
proc UI_PB_ads__CreateSpecAttr { spc_frm label options count default} {
#=============================================================================
  global special_char
  global tixOption

  set special_char($label,label) $default

  set frame [frame $spc_frm.$count]
  pack $frame -side top -fill both -padx 5

  set temp_lab [split $label "_"]
  set disp_lab [join $temp_lab " "]
  set lbl [label $frame.lbl -text $disp_lab -anchor w \
                            -font $tixOption(font)]
  pack $lbl -side left -padx 5 -pady 2

  set ent [entry $frame.ent -textvariable special_char($label,char) \
                        -font $tixOption(bold_font) -bg lightBlue \
                        -relief sunken -width 4] 
  set opt_menu [tixOptionMenu $frame.opt -variable special_char($label,label) \
                     -command "UI_PB_ads__SetSpecChar $spc_frm $count $label" \
                     -options { menubutton.width 14
                                menubutton.height 1
                              }]
  UI_PB_ads__SetSpecChar $spc_frm $count $label

  foreach opt $options \
  {
    $opt_menu add command $opt -label $opt
  }
  pack $opt_menu $ent -side right -fill x -padx 5 -pady 2
  $opt_menu config -value $default
}

#=============================================================================
proc UI_PB_ads__GetValuesforSpecOptions { OPTION_LAB OPT_VALUE } {
#=============================================================================
  upvar $OPTION_LAB option_lab
  upvar $OPT_VALUE opt_value

  global mom_sys_arr
  if {[string compare $mom_sys_arr($option_lab) " "] == 0} \
  {
    set opt_value "Space"
  } elseif {[string compare $mom_sys_arr($option_lab) ""] == 0} \
  {
    set opt_value "None"
  } else \
  {
    switch $mom_sys_arr($option_lab) \
    {
      "."     {set opt_value "Decimal (.)"}
      ","     {set opt_value "Comma (,)"}
      ";"     {set opt_value "Semicolon (;)"}
      ":"     {set opt_value "Colon (:)"}
      "("     {set opt_value "Left Parenthesis"}
      ")"     {set opt_value "Right Parenthesis"}
      "\#"    {set opt_value "Pound Sign (\#)"}
      "*"     {set opt_value "Asterisk (*)"}
      "/"     {set opt_value "Slash (/)"}     
      "\\012"  {set opt_value "New Line (\\012)"}
      default {
                set opt_value "Text" 
                set special_char($option_lab,char) $mom_sys_arr($option_lab)
              }
    }
  }
}

#=============================================================================
proc UI_PB_ads__SetSpecChar { frame count option_lab args } {
#=============================================================================
  global special_char
  global mom_sys_arr
  
  switch $special_char($option_lab,label) \
  {
    None                {
                          set special_char($option_lab,char) ""
                          $frame.$count.ent config -state disabled
                        }

    Space               {
                          set special_char($option_lab,char) " "
                          $frame.$count.ent config -state disabled
                        }

    "Decimal (.)"       {
                          set special_char($option_lab,char) "."
                          $frame.$count.ent config -state disabled
                        }

    "Comma (,)"         {
                          set special_char($option_lab,char) ","
                          $frame.$count.ent config -state disabled
                        }

    "Semicolon (;)"     {
                          set special_char($option_lab,char) ";"
                          $frame.$count.ent config -state disabled
                        }

    "Colon (:)"         {
                          set special_char($option_lab,char) ":"
                          $frame.$count.ent config -state disabled
                        }

    "Text"              {
                          set special_char($option_lab,char) \
                                          $mom_sys_arr($option_lab)
                          $frame.$count.ent config -state normal
                        }

    "Left Parenthesis"  {
                          set special_char($option_lab,char) "(" 
                          $frame.$count.ent config -state disabled
                        }

    "Right Parenthesis" {
                          set special_char($option_lab,char) ")" 
                          $frame.$count.ent config -state disabled
                        }

    "Pound Sign (\#)"   {
                          set special_char($option_lab,char) "\#"
                          $frame.$count.ent config -state disabled
                        }

    "Asterisk (*)"      {
                          set special_char($option_lab,char) "*" 
                          $frame.$count.ent config -state disabled
                        }

    "Slash (/)"         {
                          set special_char($option_lab,char) "/"
                          $frame.$count.ent config -state disabled
                        }     

    "New Line (\\012)"  {
                          set special_char($option_lab,char) "\\012"
                          $frame.$count.ent config -state disabled
                        }
  }
}

#=============================================================================
proc UI_PB_ads__CreateActionButtons { act_frm PAGE_OBJ } {
#=============================================================================
  upvar $PAGE_OBJ page_obj
  global paOption

  set box [tixButtonBox $act_frm.act \
              -orientation horizontal \
              -bd 2 \
              -relief sunken \
              -bg $paOption(butt_bg)]

  pack $box -side bottom -fill x -padx 3 -pady 3

  $box add def -text Default -width 10 -bg $paOption(app_butt_bg) \
               -command "UI_PB_ads__DefaultCallBack $page_obj"
  $box add res -text Restore -width 10 -bg $paOption(app_butt_bg) \
               -command "UI_PB_ads__RestoreCallBack $page_obj"
}

#=============================================================================
proc UI_PB_ads_UpdateDataWidgets { PAGE_OBJ } {
#=============================================================================
  upvar $PAGE_OBJ page_obj
  global gpb_fmt_var gpb_addr_var
  global gPB

  set grid $gPB(tix_grid)

  set add_name_list $Page::($page_obj,cur_addsum_list)
  foreach add_name $add_name_list \
  {
     set fmt_name $gpb_addr_var($add_name,fmt_name)
     set data_type $gpb_fmt_var($fmt_name,dtype)
     switch $data_type \
     {
        "Integer"      { set data_type "Int" }
        "Real Number"  { set data_type "Real" }
        "Text String"  { set data_type "Text" }
     }
     UI_PB_ads__DisableDataAttr $grid $add_name $data_type $fmt_name
  }
}

#=============================================================================
proc UI_PB_ads_UpdateAddrSumPage { PAGE_OBJ } {
#=============================================================================
  upvar $PAGE_OBJ page_obj
  global gpb_fmt_var
  global gpb_addr_var
  global mom_sys_arr

  set Page::($page_obj,rest_gpb_fmt_var) [array get gpb_fmt_var]
  set Page::($page_obj,rest_gpb_addr_var) [array get gpb_addr_var]

  # Restores the values of these mom variables
  set mom_var_list {"seqnum_start" "seqnum_incr" "seqnum_freq" \
                    "Word_Seperator" "Decimal_Point" "End_of_Block" \
                    "Comment_Start" "Comment_End"}

  foreach var $mom_var_list \
  {
    set rest_spec_momvar($var) $mom_sys_arr($var)
  }
  set Page::($page_obj,rest_spec_momvar) [array get rest_spec_momvar]

  PB_int_RetFormatObjList fmt_obj_list
  foreach fmt_obj $fmt_obj_list \
  {
     set fmt_name $format::($fmt_obj,for_name)
     UI_PB_UpdateAllAddFmt $page_obj $fmt_name
  }

  # Updates the data widgets
    UI_PB_ads_UpdateDataWidgets page_obj
}

#=============================================================================
proc UI_PB_ads__DefaultCallBack { page_obj } {
#=============================================================================
  global gpb_fmt_var gpb_addr_var

  PB_int_RetDefAddrFmtArrys gpb_fmt_var gpb_addr_var

  # Updates the data widgets
    UI_PB_ads_UpdateDataWidgets page_obj
}

#=============================================================================
proc UI_PB_ads__RestoreCallBack { page_obj } {
#=============================================================================
  global gpb_fmt_var
  global gpb_addr_var

  array set gpb_fmt_var $Page::($page_obj,rest_gpb_fmt_var)
  array set gpb_addr_var $Page::($page_obj,rest_gpb_addr_var)

  # Updates the data widgets
    UI_PB_ads_UpdateDataWidgets
}

#=============================================================================
proc UI_PB_ads_UpdateAddressObjects { } {
#=============================================================================
  global gpb_addr_var
  global gpb_fmt_var

  PB_int_RetAddressObjList add_obj_list
  foreach add_obj $add_obj_list \
  {
    address::readvalue $add_obj add_obj_attr
    set add_name $add_obj_attr(0)

   # Address attributes
    set add_obj_attr(2) $gpb_addr_var($add_name,modal)
    set add_obj_attr(3) $gpb_addr_var($add_name,modl_status)
    set add_obj_attr(4) $gpb_addr_var($add_name,add_max)
    set add_obj_attr(5) $gpb_addr_var($add_name,max_status)
    set add_obj_attr(6) $gpb_addr_var($add_name,add_min)
    set add_obj_attr(7) $gpb_addr_var($add_name,min_status)
    set add_obj_attr(8) $gpb_addr_var($add_name,leader_name)
    set add_obj_attr(9) $gpb_addr_var($add_name,trailer)
    set add_obj_attr(10) $gpb_addr_var($add_name,trail_status)
    set add_obj_attr(11) gpb_addr_var($add_name,incremental)
    address::setvalue $add_obj add_obj_attr
    unset add_obj_attr
  }

  PB_int_RetFormatObjList fmt_obj_list
  foreach fmt_obj $fmt_obj_list \
  {
    format::readvalue $fmt_obj fmt_obj_attr
    set fmt_name $fmt_obj_attr(0)

    set fmt_obj_attr(1) $gpb_fmt_var($fmt_name,dtype)
    set fmt_obj_attr(2) $gpb_fmt_var($fmt_name,plus_status)
    set fmt_obj_attr(3) $gpb_fmt_var($fmt_name,lead_zero)
    set fmt_obj_attr(4) $gpb_fmt_var($fmt_name,trailzero)
    set fmt_obj_attr(5) $gpb_fmt_var($fmt_name,integer)
    set fmt_obj_attr(6) $gpb_fmt_var($fmt_name,decimal)
    set fmt_obj_attr(7) $gpb_fmt_var($fmt_name,fraction)
    format::setvalue $fmt_obj fmt_obj_attr
    unset fmt_obj_attr
  }
}

#===============================================================================
proc UI_PB_ads_TabAddrsumCreate { PAGE_OBJ } {
#===============================================================================
  upvar $PAGE_OBJ page_obj
  global gPB

  set grid $gPB(tix_grid)
  set prev_addsum_list $Page::($page_obj,cur_addsum_list)
  set prev_no_adds [llength $prev_addsum_list]

  PB_int_RetAddrNameList addr_name_list


  # Cover the window during the construction of scrolled grid.
  set page_id $Page::($page_obj,page_id)
  set top $page_id.top
  set tf $top.f
  if { ![winfo exists $tf] } {
    set tf [frame $top.f]
  }
  place $tf -x 0 -y 0 -relwidth 1 -relheight 1
  raise $tf
  update

  # Deletes the address in the address summary page, which are deleted by user
    set act_addsum_list ""
    set count 1
    set no_of_deletes 0
    foreach add_name $prev_addsum_list \
    {
       set index [lsearch $addr_name_list $add_name]
       if { $index == -1 }\
       {
          set act_row_no [expr $count - $no_of_deletes]
          UI_PB_ads_UpdateGridRows $grid $act_row_no $add_name $prev_no_adds
          incr prev_no_adds -1
          incr no_of_deletes
       } else \
       {
          lappend act_addsum_list $add_name
       }
       incr count
    }


  # Uncover the scrolled grid window.
  place forget $tf
  update


  # Additions of new address elements to the address summary page
    set new_add_list ""
    foreach add_name $addr_name_list \
    {
       if { [lsearch $prev_addsum_list $add_name] == -1 } \
       {
          incr prev_no_adds
          PB_int_RetAddrObjFromName add_name add_obj
          set add_desc $address::($add_obj,word_desc)
          UI_PB_ads__CreateFirstColAttr $grid $prev_no_adds $add_name $add_desc
          UI_PB_ads__CreateSecColAttr  $page_obj $grid $prev_no_adds $add_name
          lappend new_add_list $add_name
       }
    }

  # appends all the new address to current addsummary list
    foreach new_add $new_add_list \
    {
      lappend act_addsum_list $new_add
    }

  set Page::($page_obj,cur_addsum_list) $act_addsum_list

  # Updates the address summary widget status based upon the
  # address attributes
    UI_PB_ads_UpdateAddrSumPage page_obj
}

#==============================================================================
proc UI_PB_ads_UpdateGridRows { grid row_no add_name total_no_rows } {
#===============================================================================

  # Make entire grid table invisible
  # -- Somehow this keeps the grid alive!!!
   $grid config -height 1
   update idletasks

  # Delete the row
   $grid delete row $row_no $row_no

  # Move up the rest of the table
   if { $row_no < $total_no_rows } \
   {
     set move_row [expr $row_no + 1]
     $grid move row $move_row $total_no_rows -1
   }

  # Reveal grid table
   if { $total_no_rows > 9 } {
     $grid config -height 10
   } else {
     $grid config -height $total_no_rows
   }
   update idletasks
}
