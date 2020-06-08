#===============================================================================
#                  UI_PB_MACHINETOOL.TCL
#===============================================================================
################################################################################
# Description                                                                  #
#     This file contains all functions dealing with the creation of            #
#     ui elements for Machine Tool Book.                                       #
#                                                                              #
# Revisions                                                                    #
#                                                                              #
#   Date        Who       Reason                                               #
# 01-feb-1999   gsl       Initial                                              #
# 01-Jun-1999   gsl       Consolidated assignments for rotary axes with        #
# 02-Jun-1999   mnb       V16 p.11 code Integration                            #
# 08-Jun-1999   mnb       Added mom kin variables                              #
# 10-Jun-1999   mnb       Attached callbacks to rotary axis configuration      #
#                         window                                               #
# 13-Jun-1999   mnb       Attached callbacks to Action buttons                 #
# 29-Jun-1999   mnb       Updates machine tool image                           #
# 07-Sep-1999   mnb       Changed entry widget attributes                      #
# 18-Oct-1999   gsl       Added setTolState.                                   #
# 19-Oct-1999   gsl       Manage the image window correctly.                   #
# 03-Nov-1999   gsl       Added UI_PB_mach_DisableWindow &                     #
#                               UI_PB_mach_EnableWindow.                       #
# 17-Nov-1999   gsl       Submitted for phase-22.                              #
#                                                                              #
# $HISTORY$                                                                    #
#                                                                              #
################################################################################

#===============================================================================
proc UI_PB_mach_DisableWindow { args } {
#===============================================================================
  global machData machTree
  global gPB

    set h [$machTree subwidget hlist]

   #***************************
   # Retrieve some font styles
   #***************************
    set sty_n  $gPB(font_style_normal)
    set sty_ng $gPB(font_style_normal_gray)

   #***************************************************
   # Disable everything, then enable the selected item.
   #***************************************************
    $h entryconfig 0.0 -state disabled -style $sty_ng

    switch $machData(1) \
    {
      "4-Axis" \
      {
        $h entryconfig 0.1 -state disabled -style $sty_ng
      }

      "5-Axis" \
      {
        $h entryconfig 0.1 -state disabled -style $sty_ng
        $h entryconfig 0.2 -state disabled -style $sty_ng
      }
    }

    set anc [$h info anchor]
    $h entryconfig $anc -state normal -style $sty_n
}

#===============================================================================
proc UI_PB_mach_EnableWindow { args } {
#===============================================================================
  global machData machTree
  global gPB

    set h [$machTree subwidget hlist]

   #***************************
   # Retrieve some font styles
   #***************************
    set sty_n  $gPB(font_style_normal)
    set sty_ng $gPB(font_style_normal_gray)

   #*******************
   # Enable everything.
   #*******************
    $h entryconfig 0.0 -state normal -style $sty_n

    switch $machData(1) \
    {
      "4-Axis" \
      {
        $h entryconfig 0.1 -state normal -style $sty_n
      }

      "5-Axis" \
      {
        $h entryconfig 0.1 -state normal -style $sty_n
        $h entryconfig 0.2 -state normal -style $sty_n
      }
    }
}

#===============================================================================
proc UI_PB_MachineTool { book_id mctl_page_obj } {
#===============================================================================
  global paOption
  global machData

  set f [$book_id subwidget $Page::($mctl_page_obj,page_name)]
  
  # machine type
    set machData(0) "Mill"
  # axis_type
    set machData(1) 5-Axis
  # spindle_type
    set machData(2) Vertical
  # image name
    set machData(3) "pb_mill_3axis.gif"
  # unit
    set machData(4) "Milimeter(mm)"
  # empty spot
    set machData(5) empty
  # empty spot
    set machData(6) empty
  # general parameters
    set machData(7) "General Parameters"
  # primary rotary axis 
    set machData(8) "Fourth Axis"
  # secondary rotary axis
    set machData(9) "Fifth Axis"

  set general_param {"mom_kinematic_unit" "mom_kin_output_unit" \
                     "mom_kin_x_axis_limit" "mom_kin_y_axis_limit" \
                     "mom_kin_z_axis_limit" "mom_kin_home_x_pos" \
                     "mom_kin_home_y_pos" "mom_kin_home_z_pos" \
                     "mom_kin_machine_resolution" "mom_kin_max_traversal_rate"}

  set axis_4th_param {"mom_kin_4th_axis_type" "mom_kin_4th_axis_plane" \
                      "mom_kin_4th_axis_address" "mom_kin_4th_axis_min_incr" \
                      "mom_kin_4th_axis_max_limit" \
                      "mom_kin_4th_axis_min_limit" \
                      "mom_kin_4th_axis_rotation" \
                      "mom_kin_4th_axis_center_offset(0)" \
                      "mom_kin_4th_axis_center_offset(1)" \
                      "mom_kin_4th_axis_center_offset(2)" \
                      "mom_kin_4th_axis_ang_offset" \
                      "mom_kin_pivot_guage_offset" \
                      "mom_kin_max_dpm" "mom_kin_linearization_flag" \
                      "mom_kin_linearization_tol" \
                      "mom_kin_4th_axis_limit_action"}

  set axis_5th_param {"mom_kin_5th_axis_type" "mom_kin_5th_axis_plane" \
                      "mom_kin_5th_axis_address" "mom_kin_5th_axis_min_incr" \
                      "mom_kin_5th_axis_max_limit" "mom_kin_5th_axis_min_limit" \
                      "mom_kin_5th_axis_rotation" \
                      "mom_kin_5th_axis_center_offset(0)" \
                      "mom_kin_5th_axis_center_offset(1)" \
                      "mom_kin_5th_axis_center_offset(2)" \
                      "mom_kin_5th_axis_ang_offset" \
                      "mom_kin_pivot_guage_offset" \
                      "mom_kin_max_dpm" "mom_kin_linearization_flag" \
                      "mom_kin_linearization_tol" \
                      "mom_kin_5th_axis_limit_action"}

  # Stores all the kin variables
    set Page::($mctl_page_obj,general_param)   $general_param
    set Page::($mctl_page_obj,axis_4th_param)  $axis_4th_param
    set Page::($mctl_page_obj,axis_5th_param)  $axis_5th_param
  AddMachParam $f mctl_page_obj
}

#===============================================================================
proc AddMachParam {w PAGE_OBJ } {
#===============================================================================
  upvar $PAGE_OBJ page_obj
  global tixOption
  global paOption
  global machData
  global axisoption
  global machTree paramPath

   # pane = nb.page.pane
    set pane [tixPanedWindow $w.pane -orient horizontal]
    pack $pane -expand yes -fill both

    set f1 [$pane add p1 -expand 1 -size 275]
    set f3 [$pane add p3 -expand 2 -size 625]

    $f1 config -relief flat
    $f3 config -relief flat

   # Left pane: the Tree:
    set tree [tixTree $f1.slb \
        -options {
            hlist.indicator         1
            hlist.indent            20
            hlist.drawbranch        1
            hlist.selectMode        single
            hlist.width             40
            hlist.separator         "."
            hlist.wideselect        false
        }]
    set machTree $tree

   # Buttons
    set but [frame $f1.f]
    set disp [button $but.disp -text "Display Machine Tool" \
                             -bg $paOption(app_butt_bg) \
                             -command "AddMachImage"]

    pack $disp -expand yes

    pack $but -side top -fill x -padx 7


    [$tree subwidget hsb] config -troughcolor $paOption(trough_bg) \
                                 -width       $paOption(trough_wd)
    [$tree subwidget vsb] config -troughcolor $paOption(trough_bg) \
                                 -width       $paOption(trough_wd)

    pack $tree -side top -fill both -expand yes -padx 5

    BuildMachTreeList
    $tree config \
        -browsecmd "MachDisplayParams $tree machData"

   # Parameter pane
   #
    set machData(gen) [frame $f3.gen -relief sunken -bd 1]
    AddGeneralParams page_obj $machData(gen) "general_param"

    switch $machData(1) \
    {
      "4-Axis" {

        set machData(4th) [frame $f3.4th -relief sunken -bd 1]
        AddRotaryAxisParams page_obj $machData(4th) "axis_4th_param" 4
      }

      "5-Axis" {

        set machData(4th) [frame $f3.4th -relief sunken -bd 1]
        set machData(5th) [frame $f3.5th -relief sunken -bd 1]
        AddRotaryAxisParams page_obj $machData(4th) "axis_4th_param" 4
        AddRotaryAxisParams page_obj $machData(5th) "axis_5th_param" 5
      }
    }
}

#===============================================================================
proc BuildMachTreeList {} {
#===============================================================================
    global machTree machData
    global paOption tixOption

    set h [$machTree subwidget hlist]
    $h config -bg $paOption(tree_bg)

    uplevel #0 set TRANSPARENT_GIF_COLOR [$h cget -bg]

    set mach_comp [tix getimage pb_mach_kin]

    SetMachTreeTitle

    global gPB
    set style  $gPB(font_style_bold)
    set style1 $gPB(font_style_normal)

    $h add 0 -itemtype imagetext -text "$machData(1) $machData(0)" \
                                 -image $paOption(folder) -style $style \
                                 -state disabled

    $h add 0.0  -itemtype imagetext -text $machData(7) -image $mach_comp \
                                                       -style $style1

    switch $machData(1) \
    {
      "4-Axis" {

        $h add 0.1 -itemtype imagetext -text $machData(8) -image $mach_comp \
                                                          -style $style1
      }

      "5-Axis" {

        $h add 0.1 -itemtype imagetext -text $machData(8) -image $mach_comp \
                                                          -style $style1
        $h add 0.2 -itemtype imagetext -text $machData(9) -image $mach_comp \
                                                          -style $style1
      }

      default {}
    }

    $h anchor set 0.0
    $h selection set 0.0
}

#===============================================================================
proc SetMachTreeTitle {} {
#===============================================================================
  global mach_type axisoption machData

  set machData(0) $mach_type 

  if { $mach_type == "Mill" } \
  {
     switch -- $axisoption \
     {    
       "3"  {
                set machData(1) "3-Axis"
            }
       "4T" -
       "4H" {
                set machData(1) "4-Axis"
            }
       "5HH" -
       "5TT" -
       "5HT" {
                set machData(1) "5-Axis"
             }
        }
    }
}

#===============================================================================
proc MachDisplayParams {tree MACHDATA args} {
#===============================================================================
   upvar $MACHDATA machData

   set HLIST [$tree subwidget hlist]
   set ent   [$HLIST info anchor]
   set indx  [string range $ent 2 [string length $ent]]


   if {[info exists machData(5th)] && [winfo exists $machData(5th)]} {
     pack forget $machData(5th)
   }

   if {[info exists machData(4th)] && [winfo exists $machData(4th)]} {
     pack forget $machData(4th)
   }

   pack forget $machData(gen)

   switch $machData([expr $indx + 7])\
   {
      "General Parameters" {
                             pack $machData(gen) -expand yes -fill both -padx 5
                           }
                              
      "Fourth Axis"        {
                             pack $machData(4th) -expand yes -fill both -padx 5
                           }

      "Fifth Axis"         {
                             pack $machData(5th) -expand yes -fill both -padx 5
                           }
   }
}

#===============================================================================
proc AddGeneralParams {PAGE_OBJ w axis_param} {
#===============================================================================
  upvar $PAGE_OBJ page_obj
  global tixOption
  global paOption
  global mom_kin_var 
  global machData
  
    set f [frame $w.f]
    pack $f -side top -pady 30 -fill both

    switch $mom_kin_var(mom_kin_output_unit) \
    {
       "IN" { set output_unit "Inch" }
       "MM" { set output_unit "Metric" }
       default { set output_unit $mom_kin_var(mom_kin_output_unit) }
    }

    set pf [frame $f.pf -bg royalBlue]
    grid $pf -padx 10 -pady 10 -sticky ew
    label $pf.postunit -text "Post Output Unit = $output_unit" \
                       -fg white -bg royalBlue
    pack $pf.postunit -pady 10

    tixLabelFrame $f.kinunit -label "Kinematic Data Unit"
    tixLabelFrame $f.limit -label "Linear Axis Travel Limit"
    tixLabelFrame $f.home -label "Home Position"
    tixLabelFrame $f.res -label "Linear Motion Step Size"
    tixLabelFrame $f.trav -label "Traversal Feed Rate"

    set fk [$f.kinunit subwidget frame]
    set fl [$f.limit subwidget frame]
    set fh [$f.home subwidget frame]
    set fr [$f.res subwidget frame]
    set ft [$f.trav subwidget frame]

  # Kinematic units
    radiobutton $fk.in -text Inch -variable mom_kin_var(mom_kinematic_unit) \
                   -value Inch
    radiobutton $fk.mm -text Metric -variable mom_kin_var(mom_kinematic_unit) \
                   -value Metric
    pack $fk.in -side left  -padx 15 -pady 5
    pack $fk.mm -side right -padx 15 -pady 5

    tixLabelEntry $fl.x -label [format %-30s X] \
        -options {
            entry.width 10
            entry.anchor w
            label.anchor e
            entry.textVariable mom_kin_var(mom_kin_x_axis_limit)
        }
    bind [$fl.x subwidget entry] <KeyPress> \
                         "UI_PB_com_ValidateDataOfEntry %W %K i"
    bind [$fl.x subwidget entry] <KeyRelease> { %W config -state normal }

    tixLabelEntry $fl.y -label [format %-30s Y] \
        -options {
            entry.width 10
            entry.anchor w
            label.anchor e
            entry.textVariable mom_kin_var(mom_kin_y_axis_limit)
        }
    bind [$fl.y subwidget entry] <KeyPress> \
                          "UI_PB_com_ValidateDataOfEntry %W %K i"
    bind [$fl.y subwidget entry] <KeyRelease> { %W config -state normal }

    tixLabelEntry $fl.z -label [format %-30s Z] \
        -options {
            entry.width 10 
            entry.anchor w
            label.anchor e
            entry.textVariable mom_kin_var(mom_kin_z_axis_limit)
        }
    bind [$fl.z subwidget entry] <KeyPress> \
                         "UI_PB_com_ValidateDataOfEntry %W %K i"
    bind [$fl.z subwidget entry] <KeyRelease> { %W config -state normal }

    pack $fl.x $fl.y $fl.z -padx 10 -pady 7

    tixLabelEntry $fh.x -label [format %-30s X] \
        -options {
            entry.width 10
            entry.anchor w
            label.anchor e
            entry.textVariable mom_kin_var(mom_kin_home_x_pos)
        }
    bind [$fh.x subwidget entry] <KeyPress> \
                           "UI_PB_com_ValidateDataOfEntry %W %K f"
    bind [$fh.x subwidget entry] <KeyRelease> { %W config -state normal }

    tixLabelEntry $fh.y -label [format %-30s Y] \
        -options {
            entry.width 10
            entry.anchor w
            label.anchor e
            entry.textVariable mom_kin_var(mom_kin_home_y_pos)
        }
    bind [$fh.y subwidget entry] <KeyPress> \
                              "UI_PB_com_ValidateDataOfEntry %W %K f"
    bind [$fh.y subwidget entry] <KeyRelease> { %W config -state normal }

    tixLabelEntry $fh.z -label [format %-30s Z] \
        -options {
            entry.width 10
            entry.anchor w
            label.anchor e
            entry.textVariable mom_kin_var(mom_kin_home_z_pos)
        }
    bind [$fh.z subwidget entry] <KeyPress> \
                               "UI_PB_com_ValidateDataOfEntry %W %K f"
    bind [$fh.z subwidget entry] <KeyRelease> { %W config -state normal }

    pack $fh.x $fh.y $fh.z -side top -padx 10 -pady 7

    tixLabelEntry $fr.value -label [format %-23s Minimum] \
        -options {
            entry.width 10
            entry.anchor w
            label.anchor e
            entry.textVariable mom_kin_var(mom_kin_machine_resolution)
        }
    bind [$fr.value subwidget entry] <KeyPress> \
                               "UI_PB_com_ValidateDataOfEntry %W %K f"
    bind [$fr.value subwidget entry] <KeyRelease> { %W config -state normal }

    pack $fr.value -padx 10 -pady 7

    tixLabelEntry $ft.value -label [format %-23s Maximum]\
        -options {
            entry.width 10
            entry.anchor w
            label.anchor e
            entry.textVariable mom_kin_var(mom_kin_max_traversal_rate)
        }
    bind [$ft.value subwidget entry] <KeyPress> \
                            "UI_PB_com_ValidateDataOfEntry %W %K i"
    bind [$ft.value subwidget entry] <KeyRelease> { %W config -state normal }

    pack $ft.value -padx 10 -pady 7

    grid $f.kinunit -padx 5 -pady 15 -sticky we
    grid $f.limit $f.home -padx 5  -pady 15 
    grid $f.res $f.trav -padx 5  -pady 15 

   # Action buttons
    set ff [frame $w.ff]
    pack $ff -side bottom -fill x
    addActionButtons page_obj $ff $axis_param
}

#===============================================================================
proc AddRotaryAxisParams {PAGE_OBJ w axis_param n_axis} {
#===============================================================================
  upvar $PAGE_OBJ page_obj

  global tixOption
  global paOption
  global x_limit
  global machData
  global mom_kin_var

    switch $n_axis {

     4 {
         set axis_rotation       mom_kin_4th_axis_rotation
         set axis_max_limit      mom_kin_4th_axis_max_limit
         set axis_min_limit      mom_kin_4th_axis_min_limit
         set axis_min_incr       mom_kin_4th_axis_min_incr
         set axis_center_offset0 mom_kin_4th_axis_center_offset(0)
         set axis_center_offset1 mom_kin_4th_axis_center_offset(1)
         set axis_center_offset2 mom_kin_4th_axis_center_offset(2)
         set axis_ang_offset     mom_kin_4th_axis_ang_offset
         set axis_limit_action   mom_kin_4th_axis_limit_action
         set axis_pivot_offset   mom_kin_pivot_guage_offset
         set axis_max_dpm        mom_kin_max_dpm
         set axis_linear_tol     mom_kin_linearization_tol
       }

     5 {
         set axis_min_incr       mom_kin_5th_axis_min_incr
         set axis_max_limit      mom_kin_5th_axis_max_limit
         set axis_min_limit      mom_kin_5th_axis_min_limit
         set axis_rotation       mom_kin_5th_axis_rotation
         set axis_center_offset0 mom_kin_5th_axis_center_offset(0)
         set axis_center_offset1 mom_kin_5th_axis_center_offset(1)
         set axis_center_offset2 mom_kin_5th_axis_center_offset(2)
         set axis_ang_offset     mom_kin_5th_axis_ang_offset
         set axis_limit_action   mom_kin_5th_axis_limit_action
         set axis_pivot_offset   mom_kin_pivot_guage_offset
         set axis_max_dpm        mom_kin_max_dpm
         set axis_linear_tol     mom_kin_linearization_tol
       }

     default {}
    }

    set f [frame $w.f]

    pack $f -side top -pady 30 -fill both

    tixLabelFrame $f.mach      -label "Rotary Axis"
    tixLabelFrame $f.loffset   -label "Machine Zero to Rotary Axis Center"
    tixLabelFrame $f.direction -label "Axis Rotation Direction"
    tixLabelFrame $f.combine   -label "Consecutive Linear Motions"
    tixLabelFrame $f.action    -label "Axis Limit Violation Handling"
    tixLabelFrame $f.limits    -label "Rotary Axis Limits (Deg)"

    set fm [$f.mach subwidget frame]
    set fo [$f.loffset subwidget frame]
    set fd [$f.direction subwidget frame]
    set fc [$f.combine subwidget frame]
    set fa [$f.action  subwidget frame]
    set fl [$f.limits subwidget frame]

   # Rotary axis
    if {$n_axis == 4} \
    {
      switch $machData(1) \
      {
        "4-Axis" {

          configParms $fm 4TH_AXIS
        }

        "5-Axis" {

          createRotaryAxisConfig $fm
        }
      }
    } else \
    {
      createRotaryAxisConfig $fm
    }

   # Max/Min
    tixLabelEntry $f.resolution -label "Min. Angular Step Size (Deg)" \
        -options {
            label.width 26 
            entry.width 10
            entry.anchor e 
            label.anchor w
        }
    [$f.resolution subwidget entry] config -textvariable \
                                mom_kin_var($axis_min_incr)
    bind [$f.resolution subwidget entry] <KeyPress> \
                               "UI_PB_com_ValidateDataOfEntry %W %K f"
    bind [$f.resolution subwidget entry] <KeyRelease> \
                               { %W config -state normal }

    tixLabelEntry $fl.min -label "Minimum" \
        -options {
            label.width 25 
            entry.width 10
            entry.anchor e
            label.anchor w
        }
    [$fl.min subwidget entry] config -textvariable mom_kin_var($axis_min_limit)
    bind [$fl.min subwidget entry] <KeyPress> \
                               "UI_PB_com_ValidateDataOfEntry %W %K f"
    bind [$fl.min subwidget entry] <KeyRelease> { %W config -state normal }

    tixLabelEntry $fl.max -label "Maximum" \
        -options {
            label.width 25 
            entry.width 10 
            entry.anchor e
            label.anchor w
        }
    [$fl.max subwidget entry] config -textvariable mom_kin_var($axis_max_limit)
    bind [$fl.max subwidget entry] <KeyPress> \
                                  "UI_PB_com_ValidateDataOfEntry %W %K f"
    bind [$fl.max subwidget entry] <KeyRelease> { %W config -state normal }

    grid $fl.min -padx 5 -pady 2 
    grid $fl.max -padx 5 -pady 2 
 

   # Linear Offset 
    radiobutton $fd.normal -text Standard -width 13 -anchor w \
                  -variable mom_kin_var($axis_rotation) -value standard 
    radiobutton $fd.reverse -text Reverse -width 14 -anchor w \
                  -variable mom_kin_var($axis_rotation) -value Reverse

    grid $fd.normal $fd.reverse -padx 5 -pady 16 

    tixLabelEntry $fo.x -label "X Offset" \
        -options {
            label.width 20 
            entry.width 10 
            entry.anchor e 
            label.anchor w
        }
    [$fo.x subwidget entry] config -textvariable \
                                     mom_kin_var($axis_center_offset0)
    bind [$fo.x subwidget entry] <KeyPress> \
                             "UI_PB_com_ValidateDataOfEntry %W %K f"
    bind [$fo.x subwidget entry] <KeyRelease> { %W config -state normal }

    tixLabelEntry $fo.y -label "Y Offset" \
        -options {
            label.width 20 
            entry.width  10 
            entry.anchor e 
            label.anchor w
        }
    [$fo.y subwidget entry] config -textvariable \
                                      mom_kin_var($axis_center_offset1)
    bind [$fo.y subwidget entry] <KeyPress> \
                               "UI_PB_com_ValidateDataOfEntry %W %K f"
    bind [$fo.y subwidget entry] <KeyRelease> { %W config -state normal }

    tixLabelEntry $fo.z -label "Z Offset" \
        -options {
            label.width 20 
            entry.width 10 
            entry.anchor e 
            label.anchor w
        }
    [$fo.z subwidget entry] config -textvariable \
                                     mom_kin_var($axis_center_offset2)
    bind [$fo.z subwidget entry] <KeyPress> \
                              "UI_PB_com_ValidateDataOfEntry %W %K f"
    bind [$fo.z subwidget entry] <KeyRelease> { %W config -state normal }

    grid $fo.x  -sticky w -padx 5 -pady 0
    grid $fo.y  -sticky w -padx 5 -pady 0
    grid $fo.z  -sticky w -padx 5 -pady 0

   # Angular Offset
    tixLabelEntry $f.aoffset -label "Angular Offset  (Deg)" \
        -options {
            label.width 21 
            entry.width 10
            entry.anchor e 
            label.anchor w
        }
    [$f.aoffset subwidget entry] config \
                -textvariable mom_kin_var($axis_ang_offset)
    bind [$f.aoffset subwidget entry] <KeyPress> \
                             "UI_PB_com_ValidateDataOfEntry %W %K f"
    bind [$f.aoffset subwidget entry] <KeyRelease> { %W config -state normal }

    tixLabelEntry $f.dist -label "Pivot Distance" \
        -options {
            label.width  21 
            entry.width  10
            entry.anchor e 
            label.anchor w
        }
    [$f.dist subwidget entry] config \
                -textvariable mom_kin_var($axis_pivot_offset)
    bind [$f.dist subwidget entry] <KeyPress> \
                          "UI_PB_com_ValidateDataOfEntry %W %K f"
    bind [$f.dist subwidget entry] <KeyRelease> { %W config -state normal }

    tixLabelEntry $f.dpm -label "Max. Feed Rate (Deg/Min)" \
        -options {
            label.width 26 
            entry.width 10
            entry.anchor w
            label.anchor w
        }
    [$f.dpm subwidget entry] config \
                -textvariable mom_kin_var($axis_max_dpm)
    bind [$f.dpm subwidget entry] <KeyPress> \
                              "UI_PB_com_ValidateDataOfEntry %W %K f"
    bind [$f.dpm subwidget entry] <KeyRelease> { %W config -state normal }

   # Consecutive Linear Motions
    checkbutton $fc.rotary_motion -text "Combined" \
                -variable mom_kin_var(mom_kin_linearization_flag) \
                -command "setTolState $fc"

    tixLabelEntry $fc.tol -label "Tolerance  " \
        -options {
            label.width 20
            entry.width 10
            entry.anchor e 
            label.anchor w
            entry.textVariable mom_kin_var(mom_kin_linearization_tol)
        }
    [$fc.tol subwidget entry] config \
                -textvariable mom_kin_var($axis_linear_tol)

    grid $fc.rotary_motion -sticky w -padx 5 -pady 2
    grid $fc.tol           -sticky w -padx 5 -pady 2


   # Axis Violation Action 
    radiobutton $fa.warning -text "Warning" -width 27 -anchor w \
                        -variable mom_kin_var($axis_limit_action) \
                        -value Warning 
    radiobutton $fa.ret -text "Retract / Re-Engage" -width 27 -anchor w \
                        -variable mom_kin_var($axis_limit_action) \
                        -value "Retract / Re-Engage" 

    grid $fa.warning       -sticky w -padx 5 -pady 2
    grid $fa.ret           -sticky w -padx 5 -pady 2

    grid $f.mach       $f.loffset  -padx 5  -pady 5  -sticky news
    grid $f.resolution $f.dist     -padx 15 -pady 5  -sticky ew
    grid $f.dpm        $f.aoffset  -padx 15 -pady 5  -sticky ew
    grid $f.direction  $f.combine  -padx 5  -pady 20 -sticky news
    grid $f.limits     $f.action   -padx 5  -pady 5  -sticky news

   # Action buttons
    set ff [frame $w.ff]
    pack $ff -side bottom -fill x
    addActionButtons page_obj $ff $axis_param
}

#===============================================================================
proc setTolState { fc } {
#===============================================================================
 global mom_kin_var
 global gPB

  set e [$fc.tol subwidget entry]

  if { $mom_kin_var(mom_kin_linearization_flag) } \
  {
#<gsl 10-18-99>
# Due to some technical difficulties, we don't change bg color just yet.
    $e config -state normal
    bind $e <KeyPress> "UI_PB_com_ValidateDataOfEntry %W %K f"
    bind $e <KeyRelease> { %W config -state normal }

  } else \
  {
    $e config -state disabled
    bind $e <KeyPress> ""
    bind $e <KeyRelease> ""
  }
}

#===============================================================================
proc addActionButtons { PAGE_OBJ f axis_param } {
#===============================================================================
  upvar $PAGE_OBJ page_obj
  global paOption

    set bb [tixButtonBox $f.bb -orientation horizontal \
            -relief sunken -bd 2 -bg $paOption(butt_bg)]

    $bb add def -text "Default" -underline 0 -width 10 \
                -bg $paOption(app_butt_bg) \
                -command "UI_PB_mach_DefaultCallBack $page_obj $axis_param"

    $bb add app -text "Restore" -underline 0 -width 10 \
                -bg $paOption(app_butt_bg) \
                -command "UI_PB_mach_RestoreCallBack $page_obj $axis_param"

    pack $bb -fill x -padx 3 -pady 3
}

#===============================================================================
proc createRotaryAxisConfig { f } {
#===============================================================================
    set bb [tixButtonBox $f.bb -orientation horizontal]
    $bb config -relief flat -bg navyBlue -pady 6
    $bb add spec -text "Configuration" -width 20
    grid $bb

    set b [$bb subwidget spec]
    $b config -command "configRotaryAxisWin $b"
}

#===============================================================================
proc configRotaryAxisWin { f } {
#===============================================================================
  global paOption tixOption
  global gPB

    set w $gPB(top_window).axis_config

    if { [winfo exists $w] } {
      raise $w
      focus $w
return
    } else  {
      toplevel $w
    }

    UI_PB_com_CreateTransientWindow $w "Rotary Axis Configuration" "+500+300" \
                                       "" ""

    set page_frm [frame $w.f1 -relief sunken -bd 1]
    pack $page_frm -fill both -expand yes -padx 6 -pady 5
    configRotaryAxisParms $page_frm

    set frame [frame $w.f2]
    pack $frame -side bottom -fill x -padx 3 -pady 4
    configRotaryAxisNavButtons $frame
}

#===============================================================================
proc configRotaryAxisParms { f } {
#===============================================================================
  global tixOption
  global paOption
  global x_limit
  global machData
  global mom_kin_var

  tixLabelFrame $f.4th      -label "4th Axis"
  tixLabelFrame $f.5th      -label "5th Axis"
  grid $f.4th $f.5th -padx 10 -pady 30

  set f4 [$f.4th subwidget frame]
  set f5 [$f.5th subwidget frame]
  configParms $f4 4TH_AXIS
  configParms $f5 5TH_AXIS
}

#===============================================================================
proc configParms { fm axis_type } {
#===============================================================================
  global mom_kin_var

    if { $axis_type == "4TH_AXIS" } \
    {
      set AXIS mom_kin_4th_axis
    } else \
    {
      set AXIS mom_kin_5th_axis
    }

    set temp_name $mom_kin_var($AXIS\_plane)

    append head_var $AXIS _type
    radiobutton $fm.head -text Head -variable mom_kin_var($head_var) \
                       -value Head
    radiobutton $fm.table -text Table -variable mom_kin_var($head_var) \
                       -value Table

    set opts {xy yz zx}

    set opt_labels(xy)      "XY"
    set opt_labels(yz)      "YZ"
    set opt_labels(zx)      "ZX"
    append plane_type $AXIS _plane
    tixOptionMenu $fm.plane -label "Plane of Rotation" \
        -variable mom_kin_var($plane_type) \
        -options {
            label.width 25 
            label.anchor w 
            entry.anchor e
            menubutton.width 6 
        }

    foreach opt $opts {
        $fm.plane add command $opt -label $opt_labels($opt)
        }

    set mom_kin_var($plane_type) $temp_name

    tixLabelEntry $fm.address -label "Address Leader" \
        -options {
            label.width  25 
            entry.width 10
            entry.anchor e 
            label.anchor w
        }

    append rotary_leader $AXIS _address
    [$fm.address subwidget entry] config -textvariable \
                                    mom_kin_var($rotary_leader)

    grid $fm.head       $fm.table -sticky w  -padx 5 
    grid $fm.plane      -         -sticky w  -padx 5
    grid $fm.address    -         -sticky nw -padx 5
}

#===============================================================================
proc configRotaryAxisNavButtons { frame } {
#===============================================================================
  global paOption

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
    $box1 add res -text Default -width 10 \
                -bg $paOption(app_butt_bg) \
                -command "UI_PB_mach_RotaryDefCallBack"

    $box1 add und -text Restore -width 10 \
                -bg $paOption(app_butt_bg) \
                -command "UI_PB_mach_RotaryResCallBack"

    $box1 add app -text Apply -width 10 \
                -bg $paOption(app_butt_bg) \
                -command "UI_PB_mach_RotaryAppCallBack"

   # Box2 attributes
    $box2 add ca -text Cancel -width 10 \
                 -bg $paOption(app_butt_bg) \
                 -command "destroy [winfo parent $frame]"

    $box2 add ok -text OK -width 10 \
                 -bg $paOption(app_butt_bg) \
                 -command "acceptRotaryAxisConfig [winfo parent $frame]"
}

#===============================================================================
proc UI_PB_mach_RotaryResCallBack { } {
#===============================================================================
  global mom_kin_var
  global rest_mom_kin_var

  # Fourth Axis parameters
    set mom_kin_var(mom_kin_4th_axis_type) \
                       $rest_mom_kin_var(mom_kin_4th_axis_type)
    set mom_kin_var(mom_kin_4th_axis_plane) \
                       $rest_mom_kin_var(mom_kin_4th_axis_plane)
    set mom_kin_var(mom_kin_4th_axis_address) \
                       $rest_mom_kin_var(mom_kin_4th_axis_address)

  # Fifth Axis parameters
    set mom_kin_var(mom_kin_5th_axis_type) \
                       $rest_mom_kin_var(mom_kin_5th_axis_type)
    set mom_kin_var(mom_kin_5th_axis_plane) \
                       $rest_mom_kin_var(mom_kin_5th_axis_plane)
    set mom_kin_var(mom_kin_5th_axis_address) \
                       $rest_mom_kin_var(mom_kin_5th_axis_address)
}

#===============================================================================
proc UI_PB_mach_RotaryAppCallBack { } {
#===============================================================================
  global mom_kin_var
  global rest_mom_kin_var

  # Fourth Axis parameters
    set rest_mom_kin_var(mom_kin_4th_axis_type) \
                       $mom_kin_var(mom_kin_4th_axis_type)
    set rest_mom_kin_var(mom_kin_4th_axis_plane) \
                       $mom_kin_var(mom_kin_4th_axis_plane)
    set rest_mom_kin_var(mom_kin_4th_axis_address) \
                       $mom_kin_var(mom_kin_4th_axis_address)

  # Fifth Axis parameters
    set rest_mom_kin_var(mom_kin_5th_axis_type) \
                       $mom_kin_var(mom_kin_5th_axis_type)
    set rest_mom_kin_var(mom_kin_5th_axis_plane) \
                       $mom_kin_var(mom_kin_5th_axis_plane)
    set rest_mom_kin_var(mom_kin_5th_axis_address) \
                       $mom_kin_var(mom_kin_5th_axis_address)
    CBMachHeadTable 
}

#===============================================================================
proc UI_PB_mach_RotaryDefCallBack { } {
#===============================================================================
  PB_int_RetDefKinVars def_mom_kin_var
  global mom_kin_var

  # Fourth Axis parameters
    set mom_kin_var(mom_kin_4th_axis_type) \
                       $def_mom_kin_var(mom_kin_4th_axis_type)
    set mom_kin_var(mom_kin_4th_axis_plane) \
                       $def_mom_kin_var(mom_kin_4th_axis_plane)
    set mom_kin_var(mom_kin_4th_axis_address) \
                       $def_mom_kin_var(mom_kin_4th_axis_address)

  # Fifth Axis parameters
    set mom_kin_var(mom_kin_5th_axis_type) \
                       $def_mom_kin_var(mom_kin_5th_axis_type)
    set mom_kin_var(mom_kin_5th_axis_plane) \
                       $def_mom_kin_var(mom_kin_5th_axis_plane)
    set mom_kin_var(mom_kin_5th_axis_address) \
                       $def_mom_kin_var(mom_kin_5th_axis_address)
}

#===============================================================================
proc acceptRotaryAxisConfig { w } {
#===============================================================================
   if {[CBMachHeadTable] == "TCL_OK"} \
   {
     destroy $w
   }
}

#===============================================================================
proc CBMachHeadTable {} {
#===============================================================================
  global axisoption machTree
  global mom_kin_var

    set 4head $mom_kin_var(mom_kin_4th_axis_type)

    if { $axisoption == "4T" && $4head == "Head" } \
    {
        set axisoption "4H"
return TCL_OK
    } elseif { $axisoption == "4H" && $4head == "Table" } \
    {
        set axisoption "4T"
return TCL_OK
    }

    if { ![info exists mom_kin_var(mom_kin_5th_axis_type)] } \
    {
return TCL_OK
    }

    set 5head $mom_kin_var(mom_kin_5th_axis_type)

    if { $4head == "Head" && $5head == "Head" } {
        set axisoption  "5HH"
    } elseif { $4head == "Table" && $5head == "Table" } {
        set axisoption  "5TT"
    } elseif { $4head == "Head" && $5head == "Table" } {
        set axisoption "5HT"
    } else {

      if {[ValidateMachObjAttr $machTree 5] == "TCL_OK"} \
      {
        switch -- $axisoption {
            "5HH" {
                set mom_kin_var(mom_kin_4th_axis_type) "Head"
                set mom_kin_var(mom_kin_5th_axis_type) "Head"
            }
            "5TT" {
                set mom_kin_var(mom_kin_4th_axis_type) "Table"
                set mom_kin_var(mom_kin_5th_axis_type) "Table"
            }
            "5HT" {
                set mom_kin_var(mom_kin_4th_axis_type) "Head"
                set mom_kin_var(mom_kin_5th_axis_type) "Table"
            } 
        }
      } else \
      {
return TCL_ERROR
      }
    }

    ChangeOffsetEntryDisplay

return TCL_OK
}

#===============================================================================
proc CBMach5thAxisPlane { value } {
#===============================================================================
  global mach5thOffsetPath    
  global axisoption

    if { $axisoption !=  "5TT" }   { return }
    if { ![info exists mach5thOffsetPath] } { return } 

    ChangeOffsetEntryDisplay 
}

#===============================================================================
proc ChangeOffsetEntryDisplay { } {
#===============================================================================
    global mach5thOffsetPath
    global mom_kin_var
    global axisoption
    global gridOffset

    if { [info exists mach5thOffsetPath] } {
        set fo $mach5thOffsetPath
        if { [info exists gridOffset(x)] && $gridOffset(x) == "true" } {
            grid forget $mach5thOffsetPath.x
            set gridOffset(x) false
        }
        if { [info exists gridOffset(y)] && $gridOffset(y) == "true" } {
            grid forget $mach5thOffsetPath.y
            set gridOffset(y) false
        }
        if { [info exists gridOffset(z)] && $gridOffset(z) == "true" } {
            grid forget $mach5thOffsetPath.z
            set gridOffset(z) false
        }
    } else {
return
    }

    if { $axisoption == "5TT" } {
        if { $mom_kin_var(mom_kin_5th_axis_plane) == "zx" } {
            grid $fo.y  -sticky w -padx 5 -pady 3
            set gridOffset(y) true 
        } elseif {  $mom_kin_var(mom_kin_5th_axis_plane) == "xy" } {
            grid $fo.z  -sticky w -padx 5 -pady 3 
            set gridOffset(z) true
        } else {
            grid $fo.x  -sticky w -padx 5 -pady 3 
            set gridOffset(x) true
        }  
    } elseif { $axisoption == "5HH" || \
               $axisoption == "5HT" } {
         grid $fo.x  -sticky w -padx 5 -pady 3 
         set gridOffset(x) true           
         grid $fo.y  -sticky w -padx 5 -pady 3
         set gridOffset(y) true
         grid $fo.z  -sticky w -padx 5 -pady 3 
         set gridOffset(z) true
    } 
}

#===============================================================================
proc UI_PB_mach_DefaultCallBack { page_obj axis_param } {
#===============================================================================
  global mom_kin_var

  if {[string compare $axis_param "general_param"] == 0} \
  {
     set mom_var_list $Page::($page_obj,general_param)
  } elseif { [string compare $axis_param "axis_4th_param"] == 0 } \
  {
     set mom_var_list $Page::($page_obj,axis_4th_param)
  } else \
  {
     set mom_var_list $Page::($page_obj,axis_5th_param)
  }
  PB_int_RetDefKinVarValues mom_var_list def_mom_kin_var
  foreach kin_var $mom_var_list \
  {
     set mom_kin_var($kin_var) $def_mom_kin_var($kin_var)
  }
}

#===============================================================================
proc UI_PB_mach_RestoreCallBack { page_obj axis_param } {
#===============================================================================
  global mom_kin_var
  global rest_mom_kin_var

  if {[string compare $axis_param "general_param"] == 0} \
  {
     set mom_var_list $Page::($page_obj,general_param)
  } elseif { [string compare $axis_param "axis_4th_param"] == 0 } \
  {
     set mom_var_list $Page::($page_obj,axis_4th_param)
  } else \
  {
     set mom_var_list $Page::($page_obj,axis_5th_param)
  }
  foreach kin_var $mom_var_list \
  {
     set mom_kin_var($kin_var) $rest_mom_kin_var($kin_var)
  }
}

set w 0

#===============================================================================
proc DisplayMachImage {} {
#===============================================================================
   global w

  # Verify if image needs to be reconstructed,
  # due to parameter changes, or simply restored.

   if {[winfo exists $w]} \
   {
     if {[wm state $w] == "iconic"}\
     {
        wm deiconify $w
     } else\
     {
        raise $w
        focus $w
     }
   } else \
   {
     AddMachImage
   }
}

#===============================================================================
proc AddMachImage {} {
#===============================================================================
    global machData
    global w
    global mach_type axisoption
    global mom_kin_var
    global imagefile ImageWindowText

    # 4x1,4y1-4xmin; 4x2,4y2-4xmax; 4ax1,4ay1-arrow start
    # 4ax2,4ay2-arrow end; 4sx,4sy-direction symbol
    global 4x1 4y1 4x2 4y2 4ax1 4ay1 4ax2 4ay2 4sx 4sy
    # 5x1,5y1-5xmin; 5x2,5y2-5xmax; 5ax1,5ay1-arrow start
    # 5ax2,5ay2-arrow end; 5sx,5sy-direction symbol
    global 5x1 5y1 5x2 5y2 5ax1 5ay1 5ax2 5ay2 5sx 5sy 
    # 5axis offset vector. 5ox, 5oy for one of X, Y, Z
    global 5ox 5oy

    if {[info exists w]} {
        destroy $w
    }
    set imagefile ""
    ConstructMachDisplayParameters
    if { $imagefile == "" } { return }

    global gPB
    set w $gPB(active_window).mach_image
    toplevel $w
    wm title $w "Machine Tool"
    wm geometry $w 800x700+300+200

    label $w.lab  -justify left -text $ImageWindowText

    pack $w.lab -anchor c -padx 10 -pady 6
    tixCObjView $w.c
    pack $w.c -expand yes -fill both -padx 4 -pady 2

    image create photo myphoto -file $imagefile
    [$w.c subwidget canvas] create image 390 340 -image myphoto \
                                -anchor c
    if { $mach_type == "Mill" && $axisoption != "3" } {
        set 4xmin $mom_kin_var(mom_kin_4th_axis_min_limit)
        set 4xmax $mom_kin_var(mom_kin_4th_axis_max_limit)
        set 4dire $mom_kin_var(mom_kin_4th_axis_rotation)
        set 4address $mom_kin_var(mom_kin_4th_axis_address)
        if { $4dire == "standard" } {
            set 4sign +$4address
        } else {
            set 4sign -$4address
        }
        if { $4dire == "standard" } {  
            [$w.c subwidget canvas] create text $4x1 $4y1 -text $4xmin \
                          -fill white -font {helvetica 18 bold}
            [$w.c subwidget canvas] create text $4x2 $4y2 -text $4xmax \
                          -fill white -font {helvetica 18 bold}
        } else {
            [$w.c subwidget canvas] create text $4x2 $4y2 -text $4xmin \
                          -fill white -font {helvetica 18 bold}
            [$w.c subwidget canvas] create text $4x1 $4y1 -text $4xmax \
                          -fill white -font {helvetica 18 bold}
        }
        eval {[$w.c subwidget canvas] create line} {$4ax1 $4ay1 $4ax2 $4ay2} \
            {-tag arrow -arrow last -arrowshape [list 20 25 8] -fill yellow}
        [$w.c subwidget canvas] create text $4sx $4sy -text $4sign \
                          -fill white -font {helvetica 22 bold}

        if { $axisoption == "5HH" || \
             $axisoption == "5TT" || \
             $axisoption == "5HT" } {
            set 5xmin $mom_kin_var(mom_kin_5th_axis_min_limit)
            set 5xmax $mom_kin_var(mom_kin_5th_axis_max_limit)
            set 5dire $mom_kin_var(mom_kin_5th_axis_rotation)
            set 5address $mom_kin_var(mom_kin_5th_axis_address)
            if { $5dire == "standard" } {
                set 5sign +$5address
            } else {
                set 5sign -$5address
            }
            if { $5dire == "standard" } {
                [$w.c subwidget canvas] create text $5x1 $5y1 -text $5xmin \
                                     -fill white -font {helvetica 18 bold}
                [$w.c subwidget canvas] create text $5x2 $5y2 -text $5xmax \
                                     -fill white -font {helvetica 18 bold}
            } else {
                [$w.c subwidget canvas] create text $5x2 $5y2 -text $5xmin \
                                     -fill white -font {helvetica 18 bold}
                [$w.c subwidget canvas] create text $5x1 $5y1 -text $5xmax \
                                     -fill white -font {helvetica 18 bold}
            }
            eval {[$w.c subwidget canvas] create line} \
              {$5ax1 $5ay1 $5ax2 $5ay2} \
              {-tag arrow -arrow last -arrowshape [list 20 25 8] -fill yellow}
            [$w.c subwidget canvas] create text $5sx $5sy -text $5sign \
                          -fill white -font {helvetica 22 bold}
            if { $axisoption == "5TT" } {
                if { $mom_kin_var(mom_kin_5th_axis_plane) == "zx" } {
                    set offset $mom_kin_var(mom_kin_5th_axis_center_offset\(1\))
                } elseif { $mom_kin_var(mom_kin_5th_axis_plane) == "xy" } {
                    set offset $mom_kin_var(mom_kin_5th_axis_center_offset\(2\))
                } elseif {  $mom_kin_var(mom_kin_5th_axis_plane) == "yz" } {
                    set offset $mom_kin_var(mom_kin_5th_axis_center_offset\(0\))
                } 
                [$w.c subwidget canvas] create text $5ox $5oy -text $offset \
                                     -fill white -font {helvetica 18 bold}
            }
        }
    }
    $w.c adjustscrollregion
}

#===============================================================================
proc ConstructMachDisplayParameters {} {
#===============================================================================
    global mach_type axisoption machTree
    global imagefile directory
    global ImageWindowText
    global env


    set directory "$env(PB_HOME)/images/mach_tool/"

    if { ![info exists mach_type] || ![info exists axisoption] } { 
        tk_messageBox -parent [UI_PB_com_AskActiveWindow] -type ok -icon error \
                     -message "Please select a machine tool!"
        return 
    }
    if { $mach_type == "Mill" } {
        switch -- $axisoption {    
            "3" {
                 set ImageWindowText [list 3-Axis $mach_type]
                 append imagefile $directory pb_m3x_v.gif
            }
            "4T" -
            "4H" {
                if { [ValidateMachObjAttr $machTree 4] == "TCL_ERROR" } { return }
                set ImageWindowText [list 4-Axis $mach_type]
                Construct4thAxisDisplayParameter
            }
            "5HH" -
            "5TT" -
            "5HT" {
                if { [ValidateMachObjAttr $machTree 5] == "TCL_ERROR" } { return }
                set ImageWindowText [list 5-Axis $mach_type]
                Construct5thAxisDisplayParameter
            }
        }
    }
}

#===============================================================================
proc Construct4thAxisDisplayParameter {} {
#===============================================================================
    global mom_kin_var
    global imagefile directory
    # 4x1,4y1-4xmin; 4x2,4y2-4xmax; 4sx,4sy-direction symbol 
    # 4ax1_1,4ay1_1-arrow start normal; 4ax2_1,4ay2_1-arrow end normal
    # 4ax1_2,4ay1_2-arrow start reversed; 4ax2_2,4ay2_2-arrow end reversed    

    set 4head $mom_kin_var(mom_kin_4th_axis_type)
    set 4plane $mom_kin_var(mom_kin_4th_axis_plane)
    set 4address $mom_kin_var(mom_kin_4th_axis_address)

    if { $4plane == "yz" && $4address == "A" } {
        if { $4head == "Table" } {
            Set4thDispParams 200 380 320 390 258 374 \
                             313 421 308 407 \
                             220 411 223 383
            append imagefile $directory pb_m4x_TA_h.gif
        } elseif { $4head == "Head" } {
            Set4thDispParams 550 450 550 380 458 440 \
                             507 367 525 374 \
                             517 442 536 425
            append imagefile $directory pb_m4x_HA_h.gif
        }
    } elseif { $4plane == "zx" && $4address == "B" } {
        if { $4head == "Table" } {
            Set4thDispParams 550 430 330 430 434 515 \
                             359 482 333 478 \
                             520 463 545 452
            append imagefile $directory pb_m4x_TB_h.gif
        } elseif { $4head == "Head" } {
            Set4thDispParams 585 319 490 325 538 309 \
                             514 348 526 362 \
                             581 349 574 363
            append imagefile $directory pb_m4x_HB_h.gif
        }
    } else {
        tk_messageBox -parent [UI_PB_com_AskActiveWindow] -type ok -icon question \
              -message "No Display For This Machine Tool Configuration"
        return
    }
}

#===============================================================================
proc Set4thDispParams { x1 y1 x2 y2 sx sy ax1_1 ay1_1 ax2_1 ay2_1 \
                        ax1_2 ay1_2 ax2_2 ay2_2 } {
#===============================================================================
    global mom_kin_var 
    # 4x1,4y1-4xmin; 4x2,4y2-4xmax; 4sx,4sy-direction symbol 
    # 4ax1_1,4ay1_1-arrow start normal; 4ax2_1,4ay2_1-arrow end normal
    # 4ax1_2,4ay1_2-arrow start reversed; 4ax2_2,4ay2_2-arrow end reversed
    global 4x1 4y1 4x2 4y2 4ax1 4ay1 4ax2 4ay2 4sx 4sy

    set 4dire $mom_kin_var(mom_kin_4th_axis_rotation) 
    set 4x1 $x1; set 4y1 $y1
    set 4x2 $x2; set 4y2 $y2
    set 4sx $sx; set 4sy $sy
    if { $4dire == "standard" } {
        set 4ax1 $ax1_1; set 4ay1 $ay1_1
        set 4ax2 $ax2_1; set 4ay2 $ay2_1
    } else {
        set 4ax1 $ax1_2; set 4ay1 $ay1_2
        set 4ax2 $ax2_2; set 4ay2 $ay2_2
    }
}

#===============================================================================
proc Set5thDispParams { x1 y1 x2 y2 sx sy ax1_1 ay1_1 ax2_1 ay2_1 \
                        ax1_2 ay1_2 ax2_2 ay2_2 ox oy } {
#===============================================================================
    global mom_kin_var 
    # 5x1,5y1-5xmin; 5x2,5y2-4xmax; 5sx,5sy-direction symbol
    # 5ax1_1,5ay1_1-arrow start normal; 5ax2_1,5ay2_1-arrow end normal
    # 5ax1_2,5ay1_2-arrow start reversed; 5ax2_2,5ay2_2-arrow end reversed
    # 5axis offset vector. 5ox, 5oy for one of X, Y, Z
    global 5x1 5y1 5x2 5y2 5ax1 5ay1 5ax2 5ay2 5sx 5sy 
    global 5ox 5oy

    set 5dire $mom_kin_var(mom_kin_5th_axis_rotation) 
    set 5x1 $x1; set 5y1 $y1
    set 5x2 $x2; set 5y2 $y2
    set 5sx $sx; set 5sy $sy
    if { $5dire == "standard" } {
        set 5ax1 $ax1_1; set 5ay1 $ay1_1
        set 5ax2 $ax2_1; set 5ay2 $ay2_1
    } else {
        set 5ax1 $ax1_2; set 5ay1 $ay1_2
        set 5ax2 $ax2_2; set 5ay2 $ay2_2
    }
    set 5ox $ox
    set 5oy $oy
}

#===============================================================================
proc Construct5thAxisDisplayParameter {} {
#===============================================================================
    global imagefile directory
    global axisoption
    global mom_kin_var

    # 4x1,4y1-4xmin; 4x2,4y2-4xmax; 4sx,4sy-direction symbol 
    # 4ax1_1,4ay1_1-arrow start normal; 4ax2_1,4ay2_1-arrow end normal
    # 4ax1_2,4ay1_2-arrow start reversed; 4ax2_2,4ay2_2-arrow end reversed

    # 5x1,5y1-5xmin; 5x2,5y2-4xmax; 5sx,5sy-direction symbol
    # 5ax1_1,5ay1_1-arrow start normal; 5ax2_1,5ay2_1-arrow end normal
    # 5ax1_2,5ay1_2-arrow start reversed; 5ax2_2,5ay2_2-arrow end reversed 
    # 5axis offset position. 5ox, 5oy for one of X, Y, Z if 5axis table-table

    set 4plane $mom_kin_var(mom_kin_4th_axis_plane)
    set 4address $mom_kin_var(mom_kin_4th_axis_address)

    set 5plane $mom_kin_var(mom_kin_5th_axis_plane)
    set 5address $mom_kin_var(mom_kin_5th_axis_address)

    if { $4plane == "yz" && $4address == "A" } {
        if { $5plane == "zx" && $5address == "B" } {
            if { $axisoption == "5HH" } {
                Set4thDispParams 470 270 450 220 381 281 \
                                 424 253 444 237 \
                                 451 304 467 293
                Set5thDispParams 540 270 500 300 580 347 \
                                 497 346 494 316 \
                                 545 290 530 285 \
                                 0 0 
                append imagefile $directory \
                         pb_m5x_HA_HB_v.gif
            } elseif { $axisoption == "5TT" } {
                Set4thDispParams 250 420 370 450 307 439 \
                                 361 491 354 471 \
                                 267 470 271 443 
                Set5thDispParams 470 550 480 440 531 477 \
                                 506 413 492 422 \
                                 509 535 485 531 \
                                 240 536
                append imagefile $directory \
                          pb_m5x_TA_TB_v.gif
            } elseif { $axisoption == "5HT" } {
                Set4thDispParams 470 240 390 280 393 253 \
                                 420 283 419 256 \
                                 462 269 452 255  
                Set5thDispParams 540 500 680 440 607 469 \
                                 678 474 670 461 \
                                 564 530 570 502 \
                                 0 0
                append imagefile $directory \
                           pb_m5x_HA_TB_v.gif
            }
        } elseif { $5plane == "xy" && $5address == "C" } {
            if { $axisoption == "5HH" } {
                tk_messageBox -parent [UI_PB_com_AskActiveWindow] -type ok \
                -icon question -message "No Display For This Machine Tool Configuration"
                return
            } elseif { $axisoption == "5TT" } {
                Set4thDispParams 230 480 340 480 286 460 \
                                 342 512 337 496 \
                                 255 495 259 470 
                Set5thDispParams 410 390 460 470 478 393 \
                                 495 446 474 448 \
                                 420 413 399 423 \
                                 240 530
                append imagefile $directory \
                        pb_m5x_TA_TC_v.gif
            } elseif { $axisoption == "5HT" } {
                Set4thDispParams 430 220 355 250 355 223 \
                                 386 255 385 228 \
                                 426 241 417 228  
                Set5thDispParams 610 450 380 460 479 476 \
                                 393 507 373 505 \
                                 589 484 607 477 \
                                 0 0
                append imagefile $directory \
                          pb_m5x_HA_TC_v.gif
            }
        } else {
            tk_messageBox -parent [UI_PB_com_AskActiveWindow] -type ok -icon question \
                 -message "No Display For This Machine Tool Configuration"
            return
        } 
    } elseif { $4plane == "zx" && $4address == "B" } {
        if { $5plane == "yz" && $5address == "A" } {
            if { $axisoption == "5HH" } {
                Set4thDispParams 580 240 520 250 610 280 \
                                 539 288 529 272 \
                                 581 275 578 257 
                Set5thDispParams 480 280 440 290 396 327 \
                                 442 328 440 309 \
                                 486 305 476 293 \
                                 0 0
                append imagefile $directory \
                    pb_m5x_HB_HA_v.gif
            } elseif { $axisoption == "5TT" } {
                Set4thDispParams 550 400 650 410 560 556 \
                                 647 447 646 427 \
                                 555 432 568 411 
                Set5thDispParams 410 475 455 350 439 412 \
                                 462 369 448 365 \
                                 433 460 413 440 \
                                 690 500
                append imagefile $directory \
                            pb_m5x_TB_TA_v.gif
            } elseif { $axisoption == "5HT" } {
                Set4thDispParams 520 230 450 280 553 314 \
                                 483 306 481 279 \
                                 532 252 517 248 
                Set5thDispParams 310 410 400 500 347 465 \
                                 385 535 385 520 \
                                 294 451 309 434 \
                                 0 0
                append imagefile $directory \
                              pb_m5x_HB_TA_v.gif
            }
        } elseif { $5plane == "xy" && $5address == "C" } {
            if { $axisoption == "5HH" } {
                tk_messageBox -parent [UI_PB_com_AskActiveWindow] -type ok \
                -icon question -message "No Display For This Machine Tool Configuration"
                return
            } elseif { $axisoption == "5TT" } {
                Set4thDispParams 460 460 560 420 534 577 \
                                 565 450 557 438 \
                                 467 496 471 474
                Set5thDispParams 380 425 470 360 393 355 \
                                 443 376 457 383 \
                                 373 403 393 408 \
                                 590 510
                append imagefile $directory \
                         pb_m5x_TB_TC_v.gif 
            } elseif { $axisoption == "5HT" } {
                Set4thDispParams 465 190 401 235 488 271 \
                                 431 254 430 232 \
                                 474 218 462 209
                Set5thDispParams 570 465 376 477 459 548 \
                                 396 509 380 506 \
                                 556 490 571 484 \
                                 0 0
                append imagefile $directory \
                              pb_m5x_HB_TC_v.gif
            }
        } else {
            tk_messageBox -parent [UI_PB_com_AskActiveWindow] -type ok -icon question \
                  -message "No Display For This Machine Tool Configuration"
            return
        }
    } elseif { $4plane == "xy" && $4address == "C" } {
        if { $5plane == "yz" && $5address == "A" } {
            if { $axisoption == "5HH" } {
                Set4thDispParams 410 190 590 220 603 262 \
                                 562 252 584 246 \
                                 419 219 429 204  
                Set5thDispParams 490 290 410 330 410 304 \
                                 442 331 441 303 \
                                 485 313 476 301 \
                                 0 0
                append imagefile $directory \
                               pb_m5x_HC_HA_v.gif
            } elseif { $axisoption == "5TT" } {
                if { $4address == "C" } {
                    tk_messageBox -parent [UI_PB_com_AskActiveWindow] -type ok \
                    -icon error -message "4 axis C table not allowed"
                    return
                }
            } elseif { $axisoption == "5HT" } {
                tk_messageBox -parent [UI_PB_com_AskActiveWindow] -type ok \
                -icon question -message "No Display For This Machine Tool Configuration"
                return
            }
        } elseif { $5plane == "zx" && $5address == "B" } {
            if { $axisoption == "5HH" } {
                Set4thDispParams 370 200 540 230 560 265 \
                                 510 254 529 249 \
                                 374 220 385 211 
                Set5thDispParams 530 330 460 290 504 299 \
                                 482 314 500 304 \
                                 519 356 522 343 \
                                 0 0
                append imagefile $directory \
                         pb_m5x_HC_HB_v.gif
            } elseif { $axisoption == "5TT" } {
                if { $4address == "C" } {
                    tk_messageBox -parent [UI_PB_com_AskActiveWindow] -type ok \
                    -icon error -message "4 axis C table not allowed"
                    return
                }
            } elseif { $axisoption == "5HT" } {
                tk_messageBox -parent [UI_PB_com_AskActiveWindow] -type ok \
                -icon question -message "No Display For This Machine Tool Configuration"
                return
            }
        } else {
            tk_messageBox -parent [UI_PB_com_AskActiveWindow] -type ok -icon question \
                  -message "No Display For This Machine Tool Configuration"
            return
        }
    } else {
        tk_messageBox -parent [UI_PB_com_AskActiveWindow] -type ok -icon question \
            -message "No Display For This Machine Tool Configuration"
        return
    }
}

#===============================================================================
proc ValidateMachObjAttr { tree axis_type } {
#===============================================================================
    global mom_kin_var

    switch -- $axis_type {
        3 {
            return TCL_OK  
        }
        4 {
            if { $mom_kin_var(mom_kin_4th_axis_plane) == "xy" && \
                 $mom_kin_var(mom_kin_4th_axis_address) == "C" && \
                 $mom_kin_var(mom_kin_4th_axis_type) == "Table" } {
                 tk_messageBox -parent [UI_PB_com_AskActiveWindow] -type ok \
                 -icon error -message "4th axis C table not allowed"
                 return TCL_ERROR
            }
            set 4xmin $mom_kin_var(mom_kin_4th_axis_min_limit)
            set 4xmax $mom_kin_var(mom_kin_4th_axis_max_limit)
            set 4range [expr $4xmax - $4xmin]
            if { $4range == 0 } {
                tk_messageBox -parent [UI_PB_com_AskActiveWindow] -type ok \
                -icon error -message "4th axis maximum axis limit can not be equal to \
                      minimum axis limit!"
                return TCL_ERROR
            } elseif { $4xmax < 0 && $4xmin < 0 } {
                tk_messageBox -parent [UI_PB_com_AskActiveWindow] -type ok -icon error \
                -message "4th axis limits can not both be negative!"
                return TCL_ERROR
            }
        }
        5 {
            if { $mom_kin_var(mom_kin_4th_axis_plane) == $mom_kin_var(mom_kin_5th_axis_plane) } {
                tk_messageBox -parent [UI_PB_com_AskActiveWindow] -type ok -icon error \
                      -message "Plane of the 4th axis can not be \
                                the same as that of the 5th axis"
                return TCL_ERROR
            }
            if { $mom_kin_var(mom_kin_4th_axis_plane) == "xy" && \
                 $mom_kin_var(mom_kin_4th_axis_address) == "C" && \
                 $mom_kin_var(mom_kin_4th_axis_type) == "Table" } {
                tk_messageBox -parent [UI_PB_com_AskActiveWindow] -type ok \
                -icon error -message "4th axis C table not allowed"
                return TCL_ERROR
            }
            if { $mom_kin_var(mom_kin_4th_axis_type) == "Table" && \
                     $mom_kin_var(mom_kin_5th_axis_type) == "Head" } {  
                tk_messageBox -parent [UI_PB_com_AskActiveWindow] -type ok \
                -icon error -message "4th axis table and 5th axis head not allowed"
                return TCL_ERROR
            }
            set 4xmin $mom_kin_var(mom_kin_4th_axis_min_limit)
            set 4xmax $mom_kin_var(mom_kin_4th_axis_max_limit)
            set 4range [expr $4xmax - $4xmin]
            if { $4range == 0 } {
                tk_messageBox -parent [UI_PB_com_AskActiveWindow] -type ok -icon error \
                -message "4th axis maximum axis limit can not be equal to \
                      minimum axis limit!"
                return TCL_ERROR
            } elseif { $4xmax < 0 && $4xmin < 0 } {
                tk_messageBox -parent [UI_PB_com_AskActiveWindow] -type ok -icon error \
                -message "4th axis limits can not both be negative!"
                return TCL_ERROR
            }
            set 5xmin $mom_kin_var(mom_kin_5th_axis_min_limit)
            set 5xmax $mom_kin_var(mom_kin_5th_axis_max_limit)
            set 5range [expr $5xmax - $5xmin]
            if { $5range == 0 } {
                tk_messageBox -parent [UI_PB_com_AskActiveWindow] -type ok -icon error \
                 -message "5th axis maximum axis limit can not be equal to \
                      minimum axis limit!"
                return TCL_ERROR
            } elseif { $5xmax < 0 && $5xmin < 0 } {
                tk_messageBox -parent [UI_PB_com_AskActiveWindow] -type ok -icon error \
                 -message "5th axis limits can not both be negative"
                return TCL_ERROR
            }
        }
    }
return TCL_OK
}

#=================================================================================
proc UI_PB_mach_CreateTabAttr { mach_page_obj } {
#=================================================================================
  global mom_kin_var
  global rest_mom_kin_var

  # restores the mom_kin_var
    array set rest_mom_kin_var [array get mom_kin_var]
}
