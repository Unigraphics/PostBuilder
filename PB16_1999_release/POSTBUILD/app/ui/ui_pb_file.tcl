################################################################################
# **************                                                               #
# ui_pb_file.tcl                                                               #
# **************                                                               #
#  File handling utilities.                                                    #
#------------------------------------------------------------------------------#
#                                                                              #
# Copyright (c) 1999, Unigraphics Solutions Inc.                               #
#                                                                              #
# See the file "license.terms" for information on usage and redistribution     #
# of this file, and for a DISCLAIMER OF ALL WARRANTIES.                        #
#                                                                              #
#                                                                              #
# Description                                                                  #
#     This file contains all functions dealing with selecting the pui file     #
#     and event handlers based upon the type of machine.                       #
#                                                                              #
#                                                                              #
# Revisions                                                                    #
#                                                                              #
#   Date        Who   Reason                                                   #
# 01-feb-1999   bmp   Initial                                                  #
# 02-Jun-1999   mnb   Code Integration                                         #
# 04-Jun-1999   gsl   Rename procedures and propagate changes accordingly.     #
# 07-Sep-1999   mnb   Integrated for Phase18                                   #
# 21-Sep-1999   mnb   Removed Sequence No & Changed Output Unit                #
# 18-Oct-1999   gsl   Minor changes                                            #
# 22-Oct-1999   gsl   Added use of UI_PB_com_CreateTransientWinow.             #
# 17-Nov-1999   gsl   Submitted for phase-22.                                  #
#                                                                              #
# $HISTORY$                                                                    #
#                                                                              #
################################################################################

#===============================================================================
proc UI_PB_OpenPost { } {
#===============================================================================
 global tixOption
 global paOption
 global gPB


  set win $gPB(top_window).open

  if { [winfo exists $win] } \
  {
    $win popup
    UI_PB_com_ClaimActiveWindow $win
  } else \
  {
    tixFileSelectDialog $win -command "PB_UI_EditPost $win"
    UI_PB_com_CreateTransientWindow $win "Edit Post" "500x400+200+200" \
                                    "" "UI_PB_OpenDestroy $win"
    $win popup

   # Sets the file box attributes
    set file_box [$win subwidget fsbox]
    $file_box config -pattern "*.pui"
    set top_filter_ent [[$file_box subwidget filter] subwidget entry]
    bind $top_filter_ent <Return> "UI_PB_OpenDlgFilter $win"

   # Sets the Action Button box attributes
    set but_box [$win subwidget btns]
    $but_box config -bg $paOption(butt_bg) -relief sunken
    tixDestroy [$but_box subwidget help]

   # Re-claim the active window status, due to tixDestroy above.
    UI_PB_com_ClaimActiveWindow $win

   # Apply filter before dispalying dialog
    UI_PB_OpenDlgFilter $win

    [$but_box subwidget cancel] config -width 10 -command "UI_PB_OpenCancel_CB $win"
    [$but_box subwidget apply]  config -width 10 -command "UI_PB_OpenDlgFilter $win"
    [$but_box subwidget ok]     config -width 10
  }

 # Activate save, close & Save As options and
 # deactivate open & close
  UI_PB_GreyOutAllFileOpts
}

#===============================================================================
proc UI_PB_OpenDestroy { win } {
#===============================================================================
 # Activates the open, new file opetions
  UI_PB_EnableFileOptions
}

#===============================================================================
proc UI_PB_OpenCancel_CB { dialog_id } {
#===============================================================================
  $dialog_id popdown

 # Active file options
  UI_PB_EnableFileOptions
}

#===============================================================================
proc UI_PB_OpenDlgFilter { dlg_id } {
#===============================================================================
  set file_box [$dlg_id subwidget fsbox]
  $file_box config -pattern "*.pui"

 # Updates the file listing box
  UI_PB_UpdateFileListBox $dlg_id
}

#===============================================================================
proc PB_UI_EditPost { dlg_id file_name } {
#===============================================================================
 global gPB


  set top_win $gPB(top_window)

  if { ![file exists $file_name] } \
  {
    tk_messageBox -parent $top_win -type ok -icon question \
                  -message "Select a valid Post Builder Session file."
    $dlg_id popup
return
  } else \
  {
    set extension [file extension $file_name]
    if { [string compare $extension ".pui"] != 0 } \
    {
      tk_messageBox -parent $top_win -type ok -icon warning \
                    -message "Select a valid Post Builder Session file."
      $dlg_id popup
return
    }
  }

  PB_Start $file_name

 # Sets the post output files
  set pui_file [file tail $file_name]
  PB_int_ReadPostFiles dir def_file tcl_file
  PB_int_SetPostOutputFiles dir pui_file def_file tcl_file

 # Hide Open Post dialog
  UI_PB_com_DismissActiveWindow $dlg_id
  $dlg_id popdown

 # Create main window
  if [catch { UI_PB_main_window } result] {
return tk_messageBox -parent $gPB(top_window) -type ok -icon error \
                     -message "Incorrect contents in Post Builder Session file."
  }
  update

  UI_PB_ActivateOpenFileOpts
  AcceptMachineToolSelection 

  set gPB(session) EDIT
}

#===============================================================================
proc UI_PB_SavePost { args } {
#===============================================================================
 global gPB

  if { $gPB(session) == "NEW" } \
  {
    UI_PB_SavePostAs
    tkwait variable gPB(session)
  } else \
  {
    UI_PB_save_a_post
  }
}

#===============================================================================
proc UI_PB_SavePostAs { args } {
#===============================================================================
 global tixOption
 global paOption
 global gPB
 global gpb_file_ext
 global gpb_pui_file
 global gpb_def_file
 global gpb_tcl_file


  PB_int_ReadPostOutputFiles cur_dir gpb_pui_file gpb_def_file \
                             gpb_tcl_file

  set win $gPB(main_window).save_as

  if { [winfo exists $win] } \
  {
    $win popup
    UI_PB_com_ClaimActiveWindow $win
    set file_box [$win subwidget fsbox]
    $file_box config -directory $cur_dir
  } else \
  {
    set gpb_file_ext "pui"
    tixFileSelectDialog $win -command "UI_PB_SavePbFiles $win"

    UI_PB_com_CreateTransientWindow $win "Save As" "540x450+150+230" \
                                    "" ""
    $win popup

    # Sets the file box attributes
     set file_box [$win subwidget fsbox]
     $file_box config -directory $cur_dir
     $file_box config -pattern "*.pui"
     set top_filter_ent [[$file_box subwidget filter] subwidget entry]
     bind $top_filter_ent <Return> "UI_PB_SaveAsSetPattern $win"

    # Binds the listing box browse
     set file_scrlistbox [$file_box subwidget filelist]
     $file_scrlistbox config -browsecmd "UI_PB_AssignFileName $win"
     $file_scrlistbox config -command ""

    # Unpacks the selection ComboBox
     pack forget [$file_box subwidget selection]
     pack forget $file_box.f3

    # Creates the frames for pui, tcl & def files
     set frm [frame $file_box.ptd -relief solid -bd 1 -bg lightSkyBlue]
     pack $frm -fill both -padx 12 -pady 10

      # pui file
       radiobutton $frm.rad1 -text "Post Builder Session" \
                    -bg lightSkyBlue -highlightthickness 0 \
                    -variable gpb_file_ext -font $tixOption(bold_font) \
                    -value pui -command "UI_PB_SaveAsRad_CB $win pui"
       entry $frm.ent1 -width 30 -relief sunken -bd 1 \
              -textvariable gpb_pui_file
       grid $frm.rad1 -row 0 -column 0 -padx 5 -pady 5 -sticky nw
       grid $frm.ent1 -row 0 -column 1 -padx 5 -pady 5 -sticky e

      # def file
       radiobutton $frm.rad2 -text "N/C Data Definition" \
                    -bg lightSkyBlue -highlightthickness 0 \
                    -variable gpb_file_ext -font $tixOption(bold_font) \
                    -value def -command "UI_PB_SaveAsRad_CB $win def"
       entry $frm.ent2 -width 30 -relief sunken -bd 1 \
              -textvariable gpb_def_file
       grid $frm.rad2 -row 1 -column 0 -padx 5 -pady 5 -sticky nw
       grid $frm.ent2 -row 1 -column 1 -padx 5 -pady 5 -sticky e

      # tcl file
       radiobutton $frm.rad3 -text "Event Handlers" \
                    -bg lightSkyBlue -highlightthickness 0 \
                    -variable gpb_file_ext -font $tixOption(bold_font) \
                    -value tcl -command "UI_PB_SaveAsRad_CB $win tcl"
       entry $frm.ent3 -width 30 -relief sunken -bd 1 \
              -textvariable gpb_tcl_file
       grid $frm.rad3 -row 2 -column 0 -padx 5 -pady 5 -sticky nw
       grid $frm.ent3 -row 2 -column 1 -padx 5 -pady 5 -sticky e

   # Sets the Action Button box attributes
    set but_box [$win subwidget btns]
    $but_box config -bg $paOption(butt_bg) -relief sunken
    tixDestroy [$but_box subwidget help]

   # Re-claim the active window status, due to tixDestroy above.
    UI_PB_com_ClaimActiveWindow $win

   # Apply filter before displaying the dialog
    UI_PB_SaveAsDlgFilter $win

    [$but_box subwidget cancel] config -width 10 -command "UI_PB_SaveAsCancel_CB $win"
    [$but_box subwidget apply]  config -width 10 -command "UI_PB_SaveAsDlgFilter $win"
    [$but_box subwidget ok]     config -width 10

   # Enables or Disables the entry's of a file
    UI_PB_UpdateFileExtWidgets $win pui
  }
}

#===============================================================================
proc UI_PB_SaveAsCancel_CB { dialog_id } {
#===============================================================================
  $dialog_id popdown

  UI_PB_com_DismissActiveWindow $dialog_id
}

#===============================================================================
proc UI_PB_SaveAsDlgFilter { win } {
#===============================================================================
 # Sets the pattern 
  UI_PB_SaveAsSetPattern $win

 # Updates the file listing box
  UI_PB_UpdateFileListBox $win 
}

#===============================================================================
proc UI_PB_UpdateFileListBox { win } {
#===============================================================================
  set file_box [$win subwidget fsbox]
  set pattern [$file_box cget -pattern]
  set dir [$file_box cget -directory]

 # <GSL 11-16-99> Trim redundant chars off the directory name under WNT
  global tcl_platform
  if {$tcl_platform(platform) != "unix"} \
  {
    set dir [string trimright $dir "*"]
    set dir [string trimright $dir "\\"]
    $file_box config -directory $dir
  }

  set file_listbox [[$file_box subwidget filelist] subwidget listbox]
  $file_listbox delete 0 end
##  set cur_dir [pwd]

  cd $dir
  foreach match [glob -nocomplain -- $pattern] \
  {
    $file_listbox insert end $match
  }
##  cd $cur_dir
}

#===============================================================================
proc UI_PB_UpdateFileExtWidgets { dialog_id file_ext } {
#===============================================================================
 global gPB

  set file_box [$dialog_id subwidget fsbox]
  $file_box config -pattern "*.$file_ext"

  switch $file_ext \
  {
     "pui"  {
               $file_box.ptd.ent1 config -state normal -bg $gPB(entry_color)
               $file_box.ptd.ent2 config -state disabled -bg lightBlue
               $file_box.ptd.ent3 config -state disabled -bg lightBlue
               focus $file_box.ptd.ent1
            }

     "def"  {
               $file_box.ptd.ent1 config -state disabled -bg lightBlue
               $file_box.ptd.ent2 config -state normal -bg $gPB(entry_color)
               $file_box.ptd.ent3 config -state disabled -bg lightBlue
               focus $file_box.ptd.ent2
            }

     "tcl"  {
               $file_box.ptd.ent1 config -state disabled -bg lightBlue
               $file_box.ptd.ent2 config -state disabled -bg lightBlue
               $file_box.ptd.ent3 config -state normal -bg $gPB(entry_color)
               focus $file_box.ptd.ent3
            }
  }
}

#===============================================================================
proc UI_PB_SaveAsRad_CB { dialog_id file_ext } {
#===============================================================================
  set file_box [$dialog_id subwidget fsbox]
  $file_box config -pattern "*.$file_ext"

 # Enables or Disables the entry's of a file
  UI_PB_UpdateFileExtWidgets $dialog_id $file_ext

 # Updates the files in the file listing box
  UI_PB_UpdateFileListBox $dialog_id 
}

#===============================================================================
proc UI_PB_SaveAsSetPattern { win } {
#===============================================================================
  global gpb_file_ext

  set file_box [$win subwidget fsbox]
  $file_box config -pattern "*.$gpb_file_ext"
}

#===============================================================================
proc UI_PB_AssignFileName { win } {
#===============================================================================
  global gpb_file_ext
  global gpb_pui_file
  global gpb_def_file
  global gpb_tcl_file

  set file_box [$win subwidget fsbox]
  set file_listbox [[$file_box subwidget filelist] subwidget listbox]

  set sel_index [$file_listbox curselection]
  set sel_file_name [$file_listbox get $sel_index $sel_index]

  switch $gpb_file_ext \
  {
     "pui"  { set gpb_pui_file $sel_file_name }
     "def"  { set gpb_def_file $sel_file_name }
     "tcl"  { set gpb_tcl_file $sel_file_name }
  }
}

#===============================================================================
proc UI_PB_SavePbFiles { win args } {
#===============================================================================
 global gPB
 global gpb_pui_file
 global gpb_def_file
 global gpb_tcl_file

  set main_win $gPB(main_window)

  if { [string compare $gpb_pui_file ""] == 0 } \
  {
    tk_messageBox -parent $main_win -type ok -icon warning \
                  -message "Enter file name for the Post Builder Session."
    $win popup
return
  } elseif { [string compare $gpb_def_file ""] == 0 } \
  {
    tk_messageBox -parent $main_win -type ok -icon warning \
                  -message "Enter file name for the N/C Data Definition."
    $win popup
return
  } elseif { [string compare $gpb_tcl_file ""] == 0 } \
  {
    tk_messageBox -parent $main_win -type ok -icon warning \
                  -message "Enter file name for the Event Handlers."
    $win popup
return
  }

  UI_PB_AttachExtToFile gpb_pui_file pui
  UI_PB_AttachExtToFile gpb_def_file def
  UI_PB_AttachExtToFile gpb_tcl_file tcl

  set file_box [$win subwidget fsbox]
  set top_filter_ent [[$file_box subwidget filter] subwidget entry]
  set entry_text [$top_filter_ent get]
  set cur_dir [file dirname $entry_text]

  PB_int_SetPostOutputFiles cur_dir gpb_pui_file gpb_def_file gpb_tcl_file

 # Outputs the post files
  UI_PB_save_a_post

 # Releases the window
  UI_PB_com_DismissActiveWindow $win
}

#===============================================================================
proc UI_PB_AttachExtToFile { FILE_NAME ext } {
#===============================================================================
  upvar $FILE_NAME file_name

  if { [string match *.$ext $file_name] == 0 } \
  {
    set file_name $file_name.$ext
  }
}

#===============================================================================
proc UI_PB_GreyOutAllFileOpts { } {
#===============================================================================
 global gPB

  set pb_topwin $gPB(top_window)

 # Configures the file options
  set mb $gPB(main_menu_bar).file.m
  $mb entryconfigure 1 -state disabled
  $mb entryconfigure 2 -state disabled
  if [catch { $mb entryconfigure 3 -state disabled } result] { }
  $mb entryconfigure 4 -state disabled
  $mb entryconfigure 5 -state disabled
  $mb entryconfigure 6 -state disabled

 # Configures the tool icons
  set mm $gPB(main_menu).tool
  [$mm subwidget new]  config -state disabled
  [$mm subwidget open] config -state disabled
  [$mm subwidget save] config -state disabled
}

#===============================================================================
proc UI_PB_ActivateOpenFileOpts { } {
#===============================================================================
 global gPB

  set pb_topwin $gPB(top_window)

 # Configures the file options
  set mb $gPB(main_menu_bar).file.m
  $mb entryconfigure 1 -state disabled
  $mb entryconfigure 2 -state disabled
  if [catch { $mb entryconfigure 3 -state disabled } result] { }
  $mb entryconfigure 4 -state normal
  $mb entryconfigure 5 -state normal
  $mb entryconfigure 6 -state normal

 # Configures the tool icons
  set mm $gPB(main_menu).tool
  [$mm subwidget new] config -state disabled
  [$mm subwidget open] config -state disabled
  [$mm subwidget save] config -state normal
}

#===============================================================================
proc UI_PB_NewPost { } {
#===============================================================================
 global tixOption paOption
 global gPB

  set win $gPB(top_window).new

  if [winfo exists $win] {
    wm deiconify $win
    UI_PB_com_ClaimActiveWindow $win
return
  }

 # Create dialog window
  toplevel $win
  UI_PB_com_CreateTransientWindow $win "Create New Post Processor" "+300+250" \
                                  "tixDestroy $win" "UI_PB_NewDestroy"
  global output_unit
  global mach_type
  global axisoption
  global controller
  global pb_output_file

  set output_unit "Inches"
  set mach_type "Mill"
  set axisoption "3-Axis"
  set pb_output_file "[pwd]/mill3ax"

  frame $win.top -relief raised -bd 1
  pack $win.top -side top -fill both -expand yes

  frame $win.top.level1 
  frame $win.top.level2
  frame $win.top.level3
  frame $win.top.level5
  frame $win.top.level5.left
  frame $win.top.level5.right

  # Name
    set pname [tixLabelEntry $win.top.level1.name -label "Name             " \
               -options {
                           entry.width 49 
                           entry.textVariable pb_output_file
                        }]
    [$pname subwidget entry] config -bg $paOption(tree_bg)
    pack $pname -side left -padx 5 -pady 5

    pack $win.top.level1 -side top -fill x -expand yes
    pack $win.top.level2 -side top -fill x -expand yes
    pack $win.top.level3 -side top -fill both -expand yes
    pack $win.top.level5 -side top -fill both -expand yes
    pack $win.top.level5.left -side left -fill both -expand yes
    pack $win.top.level5.right -side right -fill both -expand yes
    
  # Description
    set desc_lab [label $win.top.level2.lab -text "Description"]
    set desc_txt [tixScrolledText $win.top.level2.desc \
                              -height 50 -width 400 -scrollbar y]

    [$desc_txt subwidget text] config -bg $paOption(tree_bg)
    [$desc_txt subwidget vsb]  config -width $paOption(trough_wd) \
                                      -troughcolor $paOption(trough_bg)

    pack $desc_lab -side left -padx 5 -pady 5
    pack $desc_txt -side left -padx 5 -pady 5

  # Output Unit
    tixLabelFrame $win.top.level3.lbf -label "Post Output Unit"
    set out_frame [$win.top.level3.lbf subwidget frame]
    pack $win.top.level3.lbf -side left -pady 10

    radiobutton $out_frame.inch -text "Inches" -variable output_unit \
             -anchor w  -value "Inches"

    radiobutton $out_frame.mm -text "Millimeters" \
             -variable output_unit -anchor w -value "Millimeters"
    pack $out_frame.inch $out_frame.mm -side left -padx 10 -pady 5

  # Controller
    tixLabelFrame $win.top.level5.left.bottom -label "Controller"
    set fb [$win.top.level5.left.bottom subwidget frame]
    grid $win.top.level5.left.bottom -row 2 -pady 10

    tixOptionMenu $fb.contr      \
        -variable controller     \
        -options {
           entry.anchor e
           menubutton.width       30
         }
    [$fb.contr subwidget menubutton] config -font $tixOption(bold_font) \
                                         -bg  lightSkyBlue
    pack $fb.contr -padx 5 -pady 2
   
  # Machine Tool Image
    canvas $win.top.level5.right.can -width 300 -height 300
    $win.top.level5.right.can config -bg black -relief sunken
    pack $win.top.level5.right.can -fill both -expand yes -padx 5 \
                            -pady 5 
    
    global env
    image create photo myphoto -file $env(PB_HOME)/images/pb_hg500.gif
    $win.top.level5.right.can create image 150 150 -image myphoto

  # Machine Type
    tixLabelFrame $win.top.level5.left.top -label "Machine Tool"
    set fa [$win.top.level5.left.top subwidget frame]
    grid $win.top.level5.left.top -row 1 -sticky w 

    radiobutton $fa.mill -text "Mill" -variable mach_type -anchor w \
            -value "Mill" -command "CB_MachType $win Mill $fa $fb"

    radiobutton $fa.lathe -text "Lathe" -variable mach_type -anchor w \
            -value "Lathe" -command "CB_MachType $win Lathe $fa $fb"

    radiobutton $fa.wedm -text "Wire EDM" -variable mach_type -anchor w \
            -value "Wedm" -command "CB_MachType $win Wedm $fa $fb"

    radiobutton $fa.punch -text "Punch" -variable mach_type -anchor w \
            -value "Punch" -command "CB_MachType $win Punch $fa $fb"

  # Axis Type
    tixOptionMenu $fa.axis      \
        -variable axisoption     \
        -command  "CB_MachineAxisType $win" \
        -options {
           entry.anchor e
           menubutton.width       30
         }
    [$fa.axis subwidget menubutton] config -font $tixOption(bold_font) \
                                           -bg lightSkyBlue

    grid $fa.mill -sticky w -padx 5 -pady 2
    grid $fa.lathe -sticky w -padx 5 -pady 2
    grid $fa.wedm  -sticky w -padx 5 -pady 2
    grid $fa.punch -sticky w -padx 5 -pady 2
    grid $fa.axis -sticky w -padx 5 -pady 2

  # Use a ButtonBox to hold the buttons.
    global paOption
    tixButtonBox $win.box \
              -orientation horizontal \
              -relief sunken \
              -bd 2 \
              -bg $paOption(butt_bg)

    $win.box add rej -text Cancel -underline 0 \
               -command "UI_PB_NewCancel_CB $win" -width 10
    $win.box add acc -text Ok -underline 0 \
               -command "OpenNewFile $win" -width 10

    pack $win.box -side bottom -fill x -padx 3 -pady 3

  # Machine Description & Optional menus are created
    CB_MachType $win $mach_type $fa $fb

  # Activates save, close & Save As options and deactivates
  # open & close
    UI_PB_GreyOutAllFileOpts
}

#===============================================================================
proc UI_PB_NewCancel_CB { win } {
#===============================================================================
  UI_PB_EnableFileOptions
  wm withdraw $win
}

#===============================================================================
proc UI_PB_NewDestroy { args } {
#===============================================================================
 # Activates the file options
  UI_PB_EnableFileOptions

 # Releases the grab
###    grab release $win
}

#===============================================================================
proc UI_PB_EnableFileOptions  { } {
#===============================================================================
 global gPB

 # Configures the file options
  set mb $gPB(main_menu_bar).file.m
  $mb entryconfigure 1 -state normal
  $mb entryconfigure 2 -state normal
  if [catch { $mb entryconfigure 3 -state normal } result] { }
  $mb entryconfigure 4 -state disabled
  $mb entryconfigure 5 -state disabled
  $mb entryconfigure 6 -state disabled

 # Configures the tool icons
  set mm $gPB(main_menu).tool
  [$mm subwidget new]  config -state normal
  [$mm subwidget open] config -state normal
  [$mm subwidget save] config -state disabled

 # Unclaim active window status and release the grab
  UI_PB_com_DismissActiveWindow [UI_PB_com_AskActiveWindow]
}

#===============================================================================
proc CreateMachineTypeOptMenu { widget mach_type } {
#===============================================================================
 global axisoption

  set opt_labels(2H)    "2-Axis Horizontal"
  set opt_labels(2V)    "2-Axis Vertical"
  set opt_labels(3)     "3-Axis"
  set opt_labels(4T)    "4-Axis with Rotary Table"
  set opt_labels(4H)    "4-Axis with Rotary Head"
  set opt_labels(4I)    "4-Axis Independent (Merging)"
  set opt_labels(4D)    "4-Axis Dependent"
  set opt_labels(5HH)   "5-Axis with Dual Rotary Heads"
  set opt_labels(5TT)   "5-Axis with Dual Rotary Tables"
  set opt_labels(5HT)   "5-Axis with Rotary Head and Table"
  set opt_labels(2)     "2-Axis Wire EDM"
  set opt_labels(4)     "4-Axis Wire EDM"

 # Deletes the current options
  set cur_opt_names [$widget.axis entries]
  foreach name $cur_opt_names \
  {
    $widget.axis delete $name
  }

  switch $mach_type \
  {
     "Mill"   {
                 set opts { 3 4T 4H 5HH 5TT 5HT }
                 $widget.axis config -state normal
              }

     "Lathe"  { 
                 set opts { 2H 2V 4I 4D }
                 $widget.axis config -state normal
              }

     "Wedm"   {
                 set opts { 2 4 }
                 $widget.axis config -state normal
              }

     default  {
                 set opts ""
                 set axisoption ""
                 $widget.axis config -state disabled
              }
  }

  foreach opt $opts \
  {
     $widget.axis add command $opt -label $opt_labels($opt)
  }
}

#===============================================================================
proc CreateControllerOptMenu { widget mach_type } {
#===============================================================================
  set opts_cont { Generic AllnBrdy BrdgPrt BrwnShrp Cincin KrnyTrckr Fanuc \
                  GE GN GddngLws Heiden Mazak Seimens}

  set opt_labels_c(Generic)      "Generic"
  set opt_labels_c(AllnBrdy)     "Allen Bradley"
  set opt_labels_c(BrdgPrt)      "Bridgeport"
  set opt_labels_c(BrwnShrp)     "Brown & Sharp"
  set opt_labels_c(Cincin)       "Cinicinnatti Milacron         "
  set opt_labels_c(KrnyTrckr)    "Kearny & Tracker"
  set opt_labels_c(Fanuc)        "Fanuc"
  set opt_labels_c(GE)           "General Electric"
  set opt_labels_c(GN)           "General Numerics"
  set opt_labels_c(GddngLws)     "Gidding & Lewis"
  set opt_labels_c(Heiden)       "Heidenhain"
  set opt_labels_c(Mazak)        "Mazak"
  set opt_labels_c(Seimens)      "Seimens"

  set cur_opt_names [$widget.contr entries]
  foreach name $cur_opt_names \
  {
    $widget.contr delete $name
  }

  foreach opt $opts_cont \
  {
    $widget.contr add command $opt -label $opt_labels_c($opt)
  }
}

#===============================================================================
proc OpenNewFile {w} {
#===============================================================================
 global mach_type
 global axisoption
 global output_unit
 global controller
 global pb_output_file
 global env
 global gPB

  if { $mach_type != "Mill" || $controller != "Generic" } \
  {
     tk_messageBox -parent $w -type ok -icon question \
             -message "Post Builder currently has only been implemented \
                       for Generic Milling Machines"
     return
  }

 # Standard file name format
  set file_format { machine axis controller units }
    
  append stand_file_name pb
  foreach label $file_format \
  {
     switch $label \
     {
       "controller" {
                       append stand_file_name _
                       append stand_file_name $controller
                    }

       "machine"    {
                       append stand_file_name _
                       append stand_file_name $mach_type
                    }

       "axis"       {
                       if { $axisoption != "" } \
                       {
                          append stand_file_name _
                          append stand_file_name $axisoption   
                       }
                    }

       "units"      {
                       append stand_file_name _
                       switch $output_unit \
                       {
                          "Inches"       { append stand_file_name "IN" }
                          "Millimeters"  { append stand_file_name "MM" }
                       }
                    }
    }
  }

  set dot_index [string last . $pb_output_file]
  if { $dot_index != -1 } \
  {
    set pb_output_file [string range $pb_output_file 0 [expr $dot_index - 1]]
  }

  set pb_std_file $env(PB_HOME)/pblib/$stand_file_name.pui
  PB_Start $pb_std_file

 # Sets the post output files
  set dir [file dirname $pb_output_file]
  if { $dir == "." } \
  {
    set dir [pwd]
  }
  set file_name [file tail $pb_output_file]
  set pui_file $file_name.pui 
  set def_file $file_name.def
  set tcl_file $file_name.tcl
  PB_int_SetPostOutputFiles dir pui_file def_file tcl_file

 # Hide New Post dialog
  UI_PB_com_DismissActiveWindow $w
  wm withdraw $w

 # Create main window
  UI_PB_main_window

  update

  UI_PB_ActivateOpenFileOpts
  AcceptMachineToolSelection 

  set gPB(session) NEW
}

#===============================================================================
proc CB_MachType { win mach_type fa fb } {
#===============================================================================
  switch -- $mach_type \
  {
      "Lathe"    {
                    set desc "This is a Lathe Machine."                
                 }
      "Wedm"     {
                    set desc "This is a Wire EDM Machine." 
                 }
      "Punch"    {
                    set desc "This is a Punch Machine." 
                 }
      "Mill"     {
                    set desc "This is a Milling Machine."
                 }
  }

  [$win.top.level2.desc subwidget text] delete 1.0 end
  [$win.top.level2.desc subwidget text] insert 1.0 $desc

 # Creates the machine axis options
  CreateMachineTypeOptMenu $fa $mach_type 

 # Creates the Controller options
  CreateControllerOptMenu $fb $mach_type
}

#===============================================================================
proc CB_MachineAxisType { win args } {
#===============================================================================
  global axisoption

  switch -- $axisoption \
  {
     "2"  {
             set desc "This is a 2-Axis Wire EDM Machine"
          }
     "4"  {
             set desc "This is a 4-Axis Wire EDM Machine"
          }
     "2H" {
             set desc "This is a 2-Axis Horizontal Lathe Machine"
          }
     "2V" {
             set desc "This is a 2-Axis Vertical Lathe Machine"
          }
     "4I" {
             set desc "This is a 4-Axis Independent Lathe Machine"
          }
     "4D" {
             set desc "This is a 4-Axis Dependent Lathe Machine"
          }
     "3"  {
              set desc "This is a 3-Axis Milling Machine."
          }
     "4H" {
              set desc "This is a 4-Axis Milling Machine With Rotary Head."
          }
     "4T" {
              set desc "This is a 4-Axis Milling Machine With Rotaty Tabel."
          }
     "5TT" {
              set desc "This is a 5-Axis Milling Machine With Dual Rotary \
                        Tables."
           }
     "5HH" {
              set desc "This is a 5-Axis Milling Machine with Dual Rotary \
                        Heads."
           }
     "5HT" {
              set desc "This is a 5-Axis Milling Machine With Rotary Head \
                        and Table."
           }        
  }

  [$win.top.level2.desc subwidget text] delete 1.0 end
  [$win.top.level2.desc subwidget text] insert 1.0 $desc
}

#===============================================================================
proc AcceptMachineToolSelection { } {
#===============================================================================
 global axisoption MachineToolObject
 global mach_type
 global machData machTree
 global mom_kin_var
 global general_param axis_4th_param axis_5th_param

  set general_param {"mom_kinematic_unit" "mom_kin_output_unit" \
                     "mom_kin_x_axis_limit" "mom_kin_y_axis_limit" \
                     "mom_kin_z_axis_limit" "mom_kin_home_x_pos" \
                     "mom_kin_home_y_pos" "mom_kin_machine_resolution" \
                     "mom_kin_max_traversal_rate"}

  set axis_4th_param {"mom_kin_4th_axis_type" "mom_kin_4th_axis_plane" \
                    "mom_kin_4th_axis_address" "mom_kin_4th_axis_min_incr" \
                    "mom_kin_4th_axis_max_limit" "mom_kin_4th_axis_min_limit" \
                    "mom_kin_4th_axis_rotation" "mom_kin_4th_axis_center_offset(0)" \
                    "mom_kin_4th_axis_center_offset(1)" "mom_kin_4th_axis_center_offset(2)" \
                    "mom_kin_4th_axis_ang_offset" "mom_kin_pivot_guage_offset" \
                    "mom_kin_max_dpm" "mom_kin_linearization_flag" \
                    "mom_kin_linearization_tol" "mom_kin_4th_axis_limit_action"}

  set axis_5th_param {"mom_kin_5th_axis_type" "mom_kin_5th_axis_plane" \
                    "mom_kin_5th_axis_address" "mom_kin_5th_axis_min_incr" \
                    "mom_kin_5th_axis_max_limit" "mom_kin_5th_axis_min_limit" \
                    "mom_kin_5th_axis_rotation" "mom_kin_5th_axis_center_offset(0)" \
                    "mom_kin_5th_axis_center_offset(1)" "mom_kin_5th_axis_center_offset(2)" \
                    "mom_kin_5th_axis_ang_offset" "mom_kin_pivot_guage_offset" \
                    "mom_kin_max_dpm" "mom_kin_linearization_flag" \
                    "mom_kin_linearization_tol" "mom_kin_5th_axis_limit_action"}

 # Retrieve the default machine kinematic parameters according to the
 # type of machine tool you choose
  PB_int_RetDefKinVarValues general_param mom_kin_var
  PB_int_RetDefKinVarValues axis_4th_param mom_kin_var
  PB_int_RetDefKinVarValues axis_5th_param mom_kin_var

  if { $axisoption != "3" } \
  { 
     set mom_kin_var(mom_kin_4th_axis_plane) "yz"
     set mom_kin_var(mom_kin_4th_axis_address) "A"
     set mom_kin_var(mom_kin_5th_axis_plane) "zx"
     set mom_kin_var(mom_kin_5th_axis_address) "B"
     if { $axisoption == "4T" || $axisoption == "5T"} \
     {
          set mom_kin_var(mom_kin_4th_axis_type) "Table"
     } elseif {  $axisoption ==  "4H" || \
                 $axisoption == "5HH" || \
                 $axisoption == "5HT" } \
     {
         set mom_kin_var(mom_kin_4th_axis_type) "Head"
     }

     if { $axisoption == "5TT" || \
          $axisoption == "5HT" } \
     {
         set mom_kin_var(mom_kin_5th_axis_type) "Table"
     } elseif { $axisoption == "5HH" } \
     {
         set mom_kin_var(mom_kin_5th_axis_type) "Head"
     }
  }

  if { [info exists machData] } \
  {
      [$machTree subwidget hlist] delete all
      BuildMachTreeList
      [$machTree subwidget hlist] anchor set 0.0
      MachDisplayParams $machTree machData
      ChangeOffsetEntryDisplay
  }
}
