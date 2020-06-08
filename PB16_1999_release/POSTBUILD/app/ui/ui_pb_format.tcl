#===============================================================================
#                    UI_PB_FORMAT.TCL
#===============================================================================
##############################################################################
# Description                                                                #
#     This file contains all functions dealing with the creation of          #
#     ui elements for Format page.                                           #
#                                                                            #
# Revisions                                                                  #
#                                                                            #
#   Date        Who          Reason                                          #
# 01-feb-1999   gsl & mnb    Initial                                         #
# 07-Apr-1999   mnb          Removed puts                                    #
# 27-May-1999   gsl          Added display window to verify the format.      #
# 02-Jun-1999   mnb          Code Integration                                #
# 13-Jun-1999   mnb          Update address and format arrays                #
# 14-Jun-1999   gsl          Set tixControl -selectmode immediate.           #
# 07-Sep-1999   mnb          New toplevel format page.                       #
# 17-Nov-1999   gsl          Submitted for phase-22.                         #
#                                                                            #
# $HISTORY$                                                                  #
#                                                                            #
##############################################################################

#===============================================================================
# This procedure is called, when the format page is selected for the first
# time. This procedure creates the ui stuff for displaying the format data
#   
#      Inputs  :   Nc Data Definition book id
#                  format page object
#
#      Output  :   Widget ids stored as attributes of the page object.
#===============================================================================
proc UI_PB_Def_Format {book_id fmt_page_obj} {
#===============================================================================
  global tixOption
  global paOption
  global FORMATOBJATTR
  global fmt_dis_attr

  set Page::($fmt_page_obj,page_id) [$book_id subwidget \
                              $Page::($fmt_page_obj,page_name)]
  set Page::($fmt_page_obj,act_fmt_name) ""

 # Creates a pane
   Page::CreatePane $fmt_page_obj

 # Adds create, cut and paste buttons to left pane
   UI_PB_fmt_AddCompLeftPane fmt_page_obj

 # Creates a tree frame in the left frame
   Page::CreateTree $fmt_page_obj

 # Create the tree elements
   UI_PB_fmt_CreateTreeElements fmt_page_obj
   UI_PB_fmt_FormatDisplayParams fmt_page_obj 0

 # Divides the main frame into three
   UI_PB_fmt_CreateFmtFrames fmt_page_obj

 # Create format display
   UI_PB_fmt_CreateFmtDisplay fmt_page_obj

 # Create format components in the right frame
   UI_PB_fmt_AddPageFmtParm fmt_page_obj

 # Creates action buttons
   UI_PB_fmt_CreateActionButtons fmt_page_obj
}

#===============================================================================
# This procedure creates the tree elements. It displays all the formats in
# the tree frame and attaches the callback to each format name.
# 
#      Input      :  Format page object
#
#      Output     :  Nothing
#===============================================================================
proc UI_PB_fmt_CreateTreeElements { PAGE_OBJ } {
#===============================================================================
  upvar $PAGE_OBJ page_obj
  global paOption

  set tree $Page::($page_obj,tree)
  set page_id $Page::($page_obj,page_id)

  set h [$tree subwidget hlist]
  $h config -bg $paOption(tree_bg)

  set obj_index 0
  
  # Gets all the format names from the database and displays
  # all the format names in the tree frame
    UI_PB_fmt_DisplayNameList page_obj obj_index

  # Attaches the callback to all the format names
    $tree config \
	-command "UI_PB_fmt_FormatItemSelec $page_obj" \
	-browsecmd "UI_PB_fmt_FormatItemSelec $page_obj"
}

#==============================================================================
# This procedure creates the buttons, create, cut & paste in the left pane
#
#       Input   : Format page object
#
#       Output  : Nothing
#
#==============================================================================
proc UI_PB_fmt_AddCompLeftPane { PAGE_OBJ } {
#==============================================================================
  upvar $PAGE_OBJ page_obj
  global paOption
  
  set left_pane $Page::($page_obj,left_pane_id)

  set but [frame $left_pane.f]
  pack $but -side top -fill x -padx 7

  button $but.new -text "Create" -bg $paOption(app_butt_bg) \
        -command "UI_PB_fmt_CreateFormat $page_obj"
  button $but.del -text "Cut" -bg $paOption(app_butt_bg) \
        -command "UI_PB_fmt_CutFormat $page_obj"
  button $but.pas -text "Paste" -bg $paOption(app_butt_bg) \
        -command "UI_PB_fmt_PasteFormat $page_obj"

  pack $but.new $but.del $but.pas -side left -fill x -expand yes
}

#==============================================================================
# This procedure gets the format names from the database and displays them
# as tree elements. It highlights the format name based upon the index.
#
#      Inputs    :  Format Page object
#                   Index of the format selected 
#
#      Output    :  Nothing
#
#==============================================================================
proc UI_PB_fmt_DisplayNameList { PAGE_OBJ OBJ_INDEX } {
#==============================================================================
  upvar $PAGE_OBJ page_obj
  upvar $OBJ_INDEX obj_index
  global paOption

  set tree $Page::($page_obj,tree)
  set HLIST [$tree subwidget hlist]

  $HLIST delete all
  $HLIST add 0 -itemtype imagetext -text ""  -image $paOption(folder) -state disabled

  set file [tix getimage pb_format]

  # Gets all the format objects from the database
    PB_fmt_RetFormatObjs fmt_obj_list

  # Displays all the format names as tree elements
    global gPB
    set style $gPB(font_style_normal)
    set no_names [llength $fmt_obj_list]
    for {set count 0} {$count < $no_names} {incr count}\
    {
       set fmt_obj [lindex $fmt_obj_list $count]
      
       # Gets the format name from the format object
         set fmt_name $format::($fmt_obj,for_name)
       $HLIST add 0.$count -itemtype imagetext -text $fmt_name -image $file \
                                               -style $style
    }

  # Highlights the format name at the index
    if {$obj_index >= 0}\
    {
       $HLIST selection set 0.$obj_index
    } else\
    {
       $HLIST selection set 0
    }
    $tree autosetmode
}

#==============================================================================
# This procedure is called, when the Create button is selected. This creates
# new format, using the data of the selected format. After creating the
# new format, it updates the tree elements and the new format will be the
# active format.
#
#       Inputs   :  Format page object
#
#       Output   :  New format object
#
#==============================================================================
proc UI_PB_fmt_CreateFormat { page_obj } {
#==============================================================================
   global FORMATOBJATTR 
   global paOption

   set act_fmt_obj $Page::($page_obj,act_fmt_obj)

   # New format object will be created in the database, using the
   # selected formats data.
     PB_int_FormatCreateObject act_fmt_obj FORMATOBJATTR obj_index

 # Makes the new format as active format
   set fmt_name $FORMATOBJATTR(0)

   # Updates the Address Summary global arrays
     UI_PB_fmt_UpdateFmtArr FORMATOBJATTR $fmt_name

   # Recreates the tree elements
     UI_PB_fmt_DisplayNameList page_obj obj_index

   # Displays the new formats data
     UI_PB_fmt_FormatDisplayParams page_obj $obj_index
     UI_PB_fmt_PackFormatAttr $page_obj
}

#==============================================================================
# This procedure is called, when the cut button is selected. This procedure
# basically deletes the format selected, if it is not used by an address.
# If the selected format is used by an address .. an warning message is popued
# up, which tells user that the format cannot be deleted as it is used by
# some addresses. If the format is deleted, it recreates the tree elements
# and makes the next format as the active format.
# 
#      Inputs    :  Format  page object
#
#      Outputs   :  Selected format object deletion from the database
#
#==============================================================================
proc UI_PB_fmt_CutFormat { page_obj } {
#==============================================================================
  global FORMATOBJATTR

  # Gets the tree widget id from the page object
    set tree $Page::($page_obj,tree)
    set HLIST [$tree subwidget hlist]

  # Gets the index of the selected format
    set ent [$HLIST info selection]
    set obj_index [string range $ent 2 [string length $ent]]

  set active_fmt_obj $Page::($page_obj,act_fmt_obj)

  # An error message is popued up, if the format is used by an address
    if {$format::($active_fmt_obj,fmt_addr_list) != ""} \
    {
       set format_name $format::($active_fmt_obj,for_name)
       tk_messageBox -type ok -icon error\
           -message "Format \"$format_name\" is used by the Address. \
                     Format cannot be deleted"
       return
    }

   set Page::($page_obj,fmt_buff_obj_attr) [array get FORMATOBJATTR]

   # Selected format object is deleted from the database
     PB_int_FormatCutObject active_fmt_obj obj_index
     set fmt_name $FORMATOBJATTR(0)

   # Updates the address summary global variables
     UI_PB_fmt_UnsetFmtArr $fmt_name

   # Updates the format page tree elements
     UI_PB_fmt_DisplayNameList page_obj obj_index
     UI_PB_fmt_FormatDisplayParams page_obj $obj_index
     UI_PB_fmt_PackFormatAttr $page_obj
}

#==============================================================================
# This procedure is executed, when the Paste button in the format page is
# selected. It basically adds the cut format (buffer) to the database. 
#
#     Inputs    :  Format Page Object
#
#     Outputs   :  Adds the buffer format object to database
#
#==============================================================================
proc UI_PB_fmt_PasteFormat { page_obj } {
#==============================================================================
  global paOption

  # gets the tree widget id from page object
    set tree $Page::($page_obj,tree)
    set HLIST [$tree subwidget hlist]
    set ent [$HLIST info selection]
    set obj_index [string range $ent 2 [string length $ent]]

  # if there is no format object in the buffer, it just does nothing
    if {![info exists Page::($page_obj,fmt_buff_obj_attr)]} \
    {
       return
    }
    array set fmt_buff_obj_attr $Page::($page_obj,fmt_buff_obj_attr)

 # Data base call, which adds the buffer format object to the database
   set temp_index $obj_index
   PB_int_FormatPasteObject fmt_buff_obj_attr obj_index

  if {$temp_index != $obj_index } \
  {
    # Recreates the tree elements
      UI_PB_fmt_DisplayNameList page_obj obj_index

      set fmt_name $fmt_buff_obj_attr(0)
      UI_PB_fmt_UpdateFmtArr fmt_buff_obj_attr $fmt_name

    # Updates the ui of active Format
      UI_PB_fmt_FormatDisplayParams page_obj $obj_index
      UI_PB_fmt_PackFormatAttr $page_obj
  }
}

#==============================================================================
# This procedure is called, when enter(return key) is hit in the format name
# entry widget. This procedure changes the format name and updates
# the database. It pops up an error message, if the format exists.
# 
#
#        Inputs   :  Format page object
#
#        Outputs  :  Format name change .. updates database
#==============================================================================
proc UI_PB_fmt_FmtNameEntryCallBack { page_obj } {
#==============================================================================
  global FORMATOBJATTR

  set tree $Page::($page_obj,tree)
  set HLIST [$tree subwidget hlist]
  set ent [$HLIST info selection]
  set obj_index [string range $ent 2 [string length $ent]]

  set act_fmt_obj $Page::($page_obj,act_fmt_obj)
  set prev_fmt_name $Page::($page_obj,act_fmt_name)
  set cur_fmt_name $FORMATOBJATTR(0)

  if {[string compare $prev_fmt_name $cur_fmt_name] != 0} \
  {
     #  Gets the list of avialbale format objects
        PB_fmt_RetFormatObjs fmt_obj_list

     #  Checks, if there is any format by that name, returns 0
     #  if there is not format by that name.
        PB_com_RetObjFrmName cur_fmt_name fmt_obj_list ret_code

     if {$ret_code == 0} \
     {
        UI_PB_fmt_UpdateFmtNamesOfTree page_obj prev_fmt_name \
                          cur_fmt_name FORMATOBJATTR act_fmt_obj
     } else \
     {
        tk_messageBox -type ok -icon error\
         -message "Format \"$cur_fmt_name\" exists"
        set FORMATOBJATTR(0) $prev_fmt_name
     }
  }
}  

#==============================================================================
# This procedure is called to update the address summary global variables and
# the database, whenever the format name is changed.
#
#      Inputs   :  Format Page object
#                  Previous format name
#                  Current format name 
#                  Current format data
#                  Selected format object
#
#      Ouput    :  Updates the database
#
#==============================================================================
proc UI_PB_fmt_UpdateFmtNamesOfTree { PAGE_OBJ PREV_FMT_NAME CUR_FMT_NAME \
                                      CUR_FMT_OBJ_ATTR FMT_OBJ } {
#==============================================================================
  upvar $PAGE_OBJ page_obj
  upvar $PREV_FMT_NAME prev_fmt_name
  upvar $CUR_FMT_NAME cur_fmt_name
  upvar $CUR_FMT_OBJ_ATTR cur_fmt_obj_attr
  upvar $FMT_OBJ fmt_obj
  global gpb_addr_var

  # Deletes the data of the previous format name from the
  # global array
    UI_PB_fmt_UnsetFmtArr $prev_fmt_name

  # Sets the new format name data
    UI_PB_fmt_UpdateFmtArr cur_fmt_obj_attr $cur_fmt_name
    set format::($fmt_obj,for_name) $cur_fmt_name
    set Page::($page_obj,act_fmt_name) $cur_fmt_name

  # Updates the address summary global variables
    set add_obj_list $format::($fmt_obj,fmt_addr_list)
    foreach add_obj $add_obj_list \
    {
      set add_name $address::($add_obj,add_name)
      set gpb_addr_var($add_name,fmt_name) $cur_fmt_name
    }

  # Recreates the tree elements
    PB_fmt_RetFormatObjs fmt_obj_list
    set obj_index [lsearch $fmt_obj_list $fmt_obj]
    UI_PB_fmt_DisplayNameList page_obj obj_index
}

#=============================================================================
# This procedure creates the frames required for the format page. 
#
#       Inputs   :  Format Page Object
#
#       Output   :  Frame ids are stored as attributes of page object
#
#=============================================================================
proc UI_PB_fmt_CreateFmtFrames { PAGE_OBJ } {
#=============================================================================
  upvar $PAGE_OBJ page_obj
 
  set canvas_frame $Page::($page_obj,canvas_frame)

  # Creates the top frame
     set top_frame [tixButtonBox $canvas_frame.top \
                 -orientation horizontal \
                 -bd 2 \
                 -relief sunken \
                 -bg gray85]

     set Page::($page_obj,top_frame) $top_frame

  # Creates the middle frame
    set middle_frame [frame $canvas_frame.mid]
    set Page::($page_obj,middle_frame) $middle_frame

  # Creates the bottom frame
    set bottom_frame [frame $canvas_frame.bot]
    set Page::($page_obj,bottom_frame) $bottom_frame

  pack $top_frame    -side top    -fill x    -padx 3 -pady 3
  pack $middle_frame -side top    -fill both         -pady 30
  pack $bottom_frame -side bottom -fill x
}

#=============================================================================
# This procedure creates the widgets in the top frame. It creates a flat
# Button to display the formatted value of the selected format.
#
#     Inputs    :  Format Page Object
#
#     Outputs   :  Stores the button id as a attribute of page object
#
#=============================================================================
proc UI_PB_fmt_CreateFmtDisplay { PAGE_OBJ } {
#=============================================================================
  upvar $PAGE_OBJ page_obj
  global tixOption
  global paOption

  # Gets the top framr from the page object
    set top_frame $Page::($page_obj,top_frame)

  # Creates the button
    global forget_flag
    button $top_frame.fmt -text "" -cursor "" \
                  -font $tixOption(bold_font) \
                  -bg darkSeaGreen3 -relief flat \
                  -state disabled -disabledforeground lightYellow
    grid $top_frame.fmt -row 1 -column 1 -pady 10

  set forget_flag 0
  $top_frame.fmt configure -activebackground darkSeaGreen3

  # Displays the formatted value of the selected format on the button
    UI_PB_fmt__ConfigureFmtDisplay $page_obj
}

#==============================================================================
# Creates all the widgets, to display the data of the formats.
#
#       Inputs   :  Format Page Object
#
#       Outputs  :  The widget ids are stored as the attributes of
#                   page object.
#
#==============================================================================
proc UI_PB_fmt_AddPageFmtParm { PAGE_OBJ } {
#==============================================================================
  upvar $PAGE_OBJ page_obj
  global tixOption
  global paOption
  global FORMATOBJATTR

  set fch $Page::($page_obj,middle_frame)

  # Creates the entry to display the format name
    tixLabelEntry $fch.nam -label "Format Name: " \
	-options {
	    entry.width 20
	    entry.anchor w
	    label.anchor w
	    entry.textVariable FORMATOBJATTR(0)
	}
    set fch_entry [$fch.nam subwidget entry]
    bind $fch_entry <Return> "UI_PB_fmt_FmtNameEntryCallBack $page_obj"
    set Page::($page_obj,fmt_name_widget) $fch.nam

  # Creates the label frames, to display the data type of format
    tixLabelFrame $fch.typ -label "Data Type"
    set frm1 [$fch.typ subwidget frame]
    set Page::($page_obj,fmt_data_widget) $frm1

  # Creates the label frames, to display the attributes of data type
    tixLabelFrame $fch.pad -label "Padding"
    set frm2 [$fch.pad subwidget frame]
    set Page::($page_obj,fmt_pad_widget) $frm2

  set frm3 [frame $fch.ent]
  set Page::($page_obj,data_ent_widget) $frm3

  # Creates the check button
    global pls_sel
    checkbutton $fch.pls -text "Output Leading Plus Sign (+)" \
        -variable FORMATOBJATTR(2) \
        -relief flat -bd 2 -pady 0 -anchor w \
        -command " UI_PB_fmt__ConfigureFmtDisplay $page_obj "

  set Page::($page_obj,lead_plus_widget) $fch.pls

  grid $fch.nam - -pady 10 -sticky nw
  grid $fch.typ -row 1 -column 0 -pady 25 -sticky nw
  grid $fch.ent -row 1 -column 1 -sticky w
  grid $fch.pls - -sticky nw
  grid columnconfig $fch 1 -minsize 180

  pack $fch -side top -pady 30 -fill both

  # Creates radio buttons for data type
    UI_PB_fmt_CreateDataTypes page_obj

  # Creates trailing & leading zeros widgets
    UI_PB_fmt_CreatePaddingElements page_obj

  # Creates the Data type attributes
    UI_PB_fmt_CreateDataElements page_obj
}

#===============================================================================
# This procedure creates the widgets for data types of a format
#
#       Inputs   :  Format Page Object
#
#       Outputs  :  The widget ids are stored as the attributes of
#                   page object.
#
#===============================================================================
proc UI_PB_fmt_CreateDataTypes { PAGE_OBJ } { 
#===============================================================================
  upvar $PAGE_OBJ page_obj
  global typ_sel 
  global typ_sel_old 
  global FORMATOBJATTR

  set frm1 $Page::($page_obj,fmt_data_widget)
  set b 0
  set typ_sel_old $FORMATOBJATTR(1)

  foreach typ {Real\ Number Integer Text\ String} \
  {
      radiobutton $frm1.$b -text $typ \
         -variable FORMATOBJATTR(1) \
         -relief flat -value $typ -bd 2 -width 15 -anchor w \
         -command "UI_PB_fmt_PackFormatAttr $page_obj"

      pack $frm1.$b -side top -anchor w -padx 6
      incr b
  }
}

#==============================================================================
# This procedures creates the trailing and leading widgets. It packs them
# based upon the type of data. It packs leading widget, if it is an integer
# and packs both leading and trailing widgets, if it is a Real number.
#
#       Inputs   :  Format Page Object
#
#       Outputs  :  Packs the valid widgets
#
#==============================================================================
proc UI_PB_fmt_CreatePaddingElements { PAGE_OBJ } {
#==============================================================================
  upvar $PAGE_OBJ page_obj
  global pad_sel pad_selb
  global FORMATOBJATTR

  set frm2 $Page::($page_obj,fmt_pad_widget)

  # Fill in details for Padding frame
  # -- Contents vary per data type selected.

   # Real Number

        checkbutton $frm2.r_lead -text "Leading Zeros" \
           -command " UI_PB_fmt__ConfigureFmtDisplay $page_obj " \
           -variable FORMATOBJATTR(3) \
           -relief flat -bd 2 -anchor w -padx 10 -width 15

        checkbutton $frm2.r_tral -text "Trailing Zeros" \
           -command " UI_PB_fmt__ConfigureFmtDisplay $page_obj " \
           -variable FORMATOBJATTR(4) \
           -relief flat -bd 2 -anchor w -padx 10 -width 15


   # Integer

        checkbutton $frm2.i_lead -text "Leading Zeros" \
           -command " UI_PB_fmt__ConfigureFmtDisplay $page_obj " \
           -variable FORMATOBJATTR(3) \
           -relief flat -bd 2 -anchor w -padx 10 -width 15


   switch -exact -- $FORMATOBJATTR(1) {

     "Real Number" {

        pack $frm2.r_lead $frm2.r_tral -side top -anchor w
     }

     "Integer" {

        pack $frm2.i_lead -side top -anchor w
        set pad_sel "None"
     }

     "Text String" {

        grid forget $Page::($page_obj,fmt_pad_widget)
        grid forget $Page::($page_obj,lead_plus_widget)
     }
   }
}

#=============================================================================
# This procedure creates the widgets of the data type. If the data type
# is integer .. it creates only one tixcontrol widgets to accept the no 
# of digits. If it is real number, then it creates two tixcontrols to
# accept the no of digits before and after the decimal point. If it is
# a string it doesn't create any widgets.
#
#        Inputs    :  Format Page Object
#
#        Outputs   :  Valid data type attributes
#
#=============================================================================
proc UI_PB_fmt_CreateDataElements { PAGE_OBJ } {
#=============================================================================
  upvar $PAGE_OBJ page_obj
  global paOption
  global FORMATOBJATTR

  # Control buttons
    set frm3 $Page::($page_obj,data_ent_widget)
    set fch $Page::($page_obj,middle_frame)
    set f4 [frame $frm3.f]

    set callback " UI_PB_fmt__ConfigureFmtDisplay $page_obj "

  # Integer control
    tixControl $f4.a -integer true \
        -command    $callback \
        -selectmode immediate \
        -variable FORMATOBJATTR(5) \
        -options {
            entry.width 4
            label.anchor e
        }
  
  # Decimal point
    label $f4.lab -text "."

  # Fraction control
    tixControl $f4.b -integer true \
        -command    $callback \
        -selectmode immediate \
        -variable FORMATOBJATTR(7) \
        -min 0 -max 99 \
        -options {
                    entry.width 4
                    label.anchor e
                 }

    grid $f4.a $f4.lab $f4.b

    checkbutton $frm3.dec -text "Output Decimal Point (.)" \
        -command $callback \
        -variable FORMATOBJATTR(6) \
        -relief flat -bd 2 -pady 0 -anchor w

    tixControl $frm3.c -integer true \
        -command    $callback \
        -selectmode immediate \
        -variable FORMATOBJATTR(5) \
        -min 0 -max 99 \
        -options {
                   entry.width 4
                   label.anchor e
                 }

   # Flaten the entries
    $f4.a.frame.entry config -relief flat
    $f4.b.frame.entry config -relief flat
    $frm3.c.frame.entry config -relief flat

   # Sunken the frames
    $f4.a.frame config -relief sunken -bd 1
    $f4.b.frame config -relief sunken -bd 1
    $frm3.c.frame config -relief sunken -bd 1

   # Place control buttons to the left of the entry
    pack $f4.a.frame.entry -side right
    pack $f4.a.frame.incr -side top
    pack $f4.a.frame.decr -side bottom

    pack $frm3.c.frame.entry -side right
    pack $frm3.c.frame.incr -side top
    pack $frm3.c.frame.decr -side bottom

  # Packs the widgets based upon the data type of the format
    switch -exact -- $FORMATOBJATTR(1) {

      "Real Number" {
        pack $f4 $frm3.dec -side top -pady 5 -anchor w
        grid $fch.pad -pady 20 -sticky nw
      }

      "Integer" {
        pack $frm3.c -side top -pady 5 -anchor w
        grid $fch.pad -pady 20 -sticky nw
      }

      "Text String" {
      }
    }
}

#============================================================================
# This procedure creates the action buttons in the bottom frame.
#
#        Inputs    :  Format Page Object
#
#        Outputs   :  Valid data type attributes
#
#============================================================================
proc UI_PB_fmt_CreateActionButtons { PAGE_OBJ } {
#============================================================================
  upvar $PAGE_OBJ page_obj
  global paOption

  set tree $Page::($page_obj,tree)
  set ff   $Page::($page_obj,bottom_frame)

  # Buttons
  set bb [tixButtonBox $ff.bb -orientation horizontal \
          -relief sunken -bd 2 -bg $paOption(butt_bg)]

  $bb add def -text Default -width 10 -underline 0 -command \
         "UI_PB_fmt_DefaultCallBack $page_obj"
  $bb add app -text Restore -underline 0 -width 10 -command \
         "UI_PB_fmt_RestoreCallBack $page_obj" 
    
  pack $bb -fill x -padx 3 -pady 3
}

#=============================================================================
# This procedure unsets the attributes of a format, in the global variable
# gpb_fmt_var. which is used in address summary page.
#
#       Inputs    :  Format name
#
#       Outputs   :  updates the global variable gpb_fmt_var
#
#=============================================================================
proc UI_PB_fmt_UnsetFmtArr { fmt_name } {
#=============================================================================
  global gpb_fmt_var

  unset gpb_fmt_var($fmt_name,name)
  unset gpb_fmt_var($fmt_name,dtype)
  unset gpb_fmt_var($fmt_name,plus_status)
  unset gpb_fmt_var($fmt_name,lead_zero)
  unset gpb_fmt_var($fmt_name,trailzero)
  unset gpb_fmt_var($fmt_name,integer)
  unset gpb_fmt_var($fmt_name,decimal)
  unset gpb_fmt_var($fmt_name,fraction)
}

#=============================================================================
# This procedure stores the attributes of a format, in the global variable
# gpb_fmt_var. which is used in address summary page.
#
#       Inputs    :  Format Attributes
#                    Format name
#
#       Outputs   :  updates the global variable gpb_fmt_var
#
#=============================================================================
proc UI_PB_fmt_UpdateFmtArr { TEMP_FMT_ARR fmt_name } {
#=============================================================================
  upvar $TEMP_FMT_ARR temp_fmt_arr
  global gpb_fmt_var

  set gpb_fmt_var($fmt_name,name) $temp_fmt_arr(0)
  set gpb_fmt_var($fmt_name,dtype) $temp_fmt_arr(1)
  set gpb_fmt_var($fmt_name,plus_status) $temp_fmt_arr(2)
  set gpb_fmt_var($fmt_name,lead_zero) $temp_fmt_arr(3)
  set gpb_fmt_var($fmt_name,trailzero) $temp_fmt_arr(4)
  set gpb_fmt_var($fmt_name,integer) $temp_fmt_arr(5)
  set gpb_fmt_var($fmt_name,decimal) $temp_fmt_arr(6)
  set gpb_fmt_var($fmt_name,fraction) $temp_fmt_arr(7)
}

#=============================================================================
# This procedure updates the data of the current format in the database.
# It also updates the address summary global variables.
#
#        Inputs   :  format page object
#  
#        Outputs  :  updates address summary global variables and database
#
#=============================================================================
proc UI_PB_fmt_ApplyCurrentFmtData { PAGE_OBJ } {
#=============================================================================
  upvar $PAGE_OBJ page_obj
  global FORMATOBJATTR

  if {[info exists Page::($page_obj,act_fmt_obj)]} \
  {
     set act_fmt_obj $Page::($page_obj,act_fmt_obj)
     if {[string compare $FORMATOBJATTR(1) "Integer"] == 0} \
     {
        set FORMATOBJATTR(4) 0
        set FORMATOBJATTR(6) 0
        set FORMATOBJATTR(7) 0
     }
     # updates the database
       format::setvalue $act_fmt_obj FORMATOBJATTR
     
     set fmt_name $FORMATOBJATTR(0)
   
     # Updates the global variables
       UI_PB_fmt_UpdateFmtArr FORMATOBJATTR $fmt_name
  }
}
#=============================================================================
# This procedure updates the data of the selected format in the database.
# It also updates the address summary global variables.
#
#        Inputs   :  format page object
#  
#        Outputs  :  updates address summary global variables and database
#
#=============================================================================
proc UI_PB_fmt_ApplyFormat { PAGE_OBJ } {
#=============================================================================
  upvar $PAGE_OBJ page_obj
  global FORMATOBJATTR
  if {[info exists Page::($page_obj,act_fmt_obj)]} \
  {
     UI_PB_fmt_ApplyCurrentFmtData page_obj
     unset Page::($page_obj,act_fmt_obj)
     unset Page::($page_obj,act_fmt_name)
  }
}

#=============================================================================
#  This procedure is called, when the default button in the format page is
#  selected. It basically changes the format data to default data. 
#
#         Inputs  :   Format Page Object
#
#         Outputs :   Defualt format data
#
#=============================================================================
proc UI_PB_fmt_DefaultCallBack { page_obj } {
#=============================================================================
  global FORMATOBJATTR
  set act_fmt_obj $Page::($page_obj,act_fmt_obj)
  array set temp_fmt_obj_attr $format::($act_fmt_obj,def_value)
  set prev_fmt_name $Page::($page_obj,act_fmt_name)
  set cur_fmt_name $temp_fmt_obj_attr(0)
  
  if {[string compare $prev_fmt_name $cur_fmt_name] != 0} \
  {
     # Sets format name to default name and updates the tree elements
     UI_PB_fmt_UpdateFmtNamesOfTree page_obj prev_fmt_name cur_fmt_name \
                                    temp_fmt_obj_attr act_fmt_obj
  } else \
  {
     UI_PB_fmt_UpdateFmtArr temp_fmt_obj_attr $cur_fmt_name
  }

  # Based upon the format data type, packs the required widgets
    UI_PB_fmt_SetFormatAttr $page_obj
    UI_PB_fmt_PackFormatAttr $page_obj
}

#=============================================================================
#  This procedure is called, when the Restore button in the format page is
#  selected.  It basically changes the format data to the previously applied
#  format data.
#
#         Inputs  :   Format Page Object
#
#         Outputs :   Defualt format data
#
#=============================================================================
proc UI_PB_fmt_RestoreCallBack { page_obj } {
#=============================================================================
  global FORMATOBJATTR
  array set rest_formatobjattr $Page::($page_obj,rest_formatobjattr)
  set prev_fmt_name $Page::($page_obj,act_fmt_name)
  set cur_fmt_name $rest_formatobjattr(0)
  set act_fmt_obj $Page::($page_obj,act_fmt_obj)

  if {[string compare $prev_fmt_name $cur_fmt_name] != 0} \
  {
     # Sets the format name to restore name and updates the tree elements
     UI_PB_fmt_UpdateFmtNamesOfTree page_obj prev_fmt_name cur_fmt_name \
                                    rest_formatobjattr act_fmt_obj
  } else \
  {
     UI_PB_fmt_UpdateFmtArr rest_formatobjattr $cur_fmt_name
  }

  # Based upon the format data type, packs the required widgets
    UI_PB_fmt_SetFormatAttr $page_obj
    UI_PB_fmt_PackFormatAttr $page_obj
}

#=============================================================================
#  This procedure packs the valid widgets based upon the data type of a
#  format.
#
#        Inputs   :  Format Page Object
#
#        Outputs  :  Valid data type widgets
#
#=============================================================================
proc UI_PB_fmt_PackFormatAttr {page_obj} {
#=============================================================================
  global FORMATOBJATTR typ_sel_old

  set fch $Page::($page_obj,middle_frame)
  set frm2 $Page::($page_obj,fmt_pad_widget)
  set frm3 $Page::($page_obj,data_ent_widget)

  # Unpack
    switch -exact -- $typ_sel_old {

      "Real Number" {

          pack forget $frm2.r_lead $frm2.r_tral
          pack forget $frm3.f $frm3.dec
          grid forget $fch.pad
          grid forget $fch.pls
      }

      "Integer" {
        pack forget $frm2.i_lead
        pack forget $frm3.c
        grid forget $fch.pad
        grid forget $fch.pls
      }

      "Text String" {
       grid forget $fch.pad
       grid forget $fch.pls
      }
    }

   # Repack
    switch -exact -- $FORMATOBJATTR(1) {

      "Real Number" {
        pack $frm2.r_lead $frm2.r_tral -side top -anchor w
        pack $frm3.f $frm3.dec -side top -pady 5 -anchor w
        grid $fch.pls - -sticky nw
        grid $fch.pad -pady 20 -sticky nw
        set FORMATOBJATTR(6) 1
      }

      "Integer" {
        pack $frm2.i_lead -side top -anchor w
        pack $frm3.c -side top -pady 5 -padx 15 -anchor w
        grid $fch.pls - -sticky nw
        grid $fch.pad -pady 20 -sticky nw
      }

      "Text String" {
#        pack $frm2.s_none $frm2.s_left $frm2.s_rght -side top -anchor w
      }
    }

    set typ_sel_old $FORMATOBJATTR(1)
    UI_PB_fmt__ConfigureFmtDisplay $page_obj
}

#=============================================================================
# This is a callback procedure, attached to the tree elements i.e format names
# It displays the data of the selected format.
#
#    Inputs   :  Format Page object
#
#    Outputs  :  Displays Format data
#
#=============================================================================
proc UI_PB_fmt_FormatItemSelec {page_obj args} {
#=============================================================================
   # Gets the tree widget id
     set tree $Page::($page_obj,tree)
     set HLIST [$tree subwidget hlist]

   # Gets the index of the selected format
     set ent [$HLIST info selection]
     set index [string range $ent 2 [string length $ent]]
     if {[string compare $index ""] == 0} \
     {
        set index 0
        $HLIST selection clear
        $HLIST anchor clear
        $HLIST selection set 0.0
        $HLIST anchor set 0.0
     }

   # Updates the previous format data
     UI_PB_fmt_ApplyFormat page_obj

   # Displays the selected format data
     UI_PB_fmt_FormatDisplayParams page_obj $index
     UI_PB_fmt_PackFormatAttr $page_obj
}

#=============================================================================
# This procedure gets the format object from the database, based upon the
# selected format index. 
#
#        Inputs  :   Format Page Object
#                    Selected format index
#
#        Outputs :   Displays the selected format data
#
#=============================================================================
proc UI_PB_fmt_FormatDisplayParams { PAGE_OBJ index } {
#=============================================================================
  upvar $PAGE_OBJ page_obj
  global FORMATOBJATTR

  if {$index >= 0} \
  {
     # returns the format object list
       PB_int_RetFormatObjList fmt_obj_list

     set fmt_obj [lindex $fmt_obj_list $index]
     set Page::($page_obj,act_fmt_obj) $fmt_obj
     set Page::($page_obj,act_fmt_name) $format::($fmt_obj,for_name)

     UI_PB_fmt_SetFormatAttr $page_obj
     if {[info exists Page::($page_obj,rest_formatobjattr)]} \
     {
        unset Page::($page_obj,rest_formatobjattr)
     }
     set Page::($page_obj,rest_formatobjattr) [array get FORMATOBJATTR]
   }
}

#========================================================================
# Thsi procedures gets the format data from the address summary
# global variables.
#
#       Inputs   :  Format Page Object
#                   global variable gpb_fmt_var
#
#       Outputs  :  format data is set to the global variable
#                   FORMATOBJATTR
#
#========================================================================
proc UI_PB_fmt_SetFormatAttr { page_obj } {
#========================================================================
  global FORMATOBJATTR
  global gpb_fmt_var

  set fmt_name $Page::($page_obj,act_fmt_name)
  set FORMATOBJATTR(0) $gpb_fmt_var($fmt_name,name)
  set FORMATOBJATTR(1) $gpb_fmt_var($fmt_name,dtype)
  set FORMATOBJATTR(2) $gpb_fmt_var($fmt_name,plus_status)
  set FORMATOBJATTR(3) $gpb_fmt_var($fmt_name,lead_zero)
  set FORMATOBJATTR(4) $gpb_fmt_var($fmt_name,trailzero)
  set FORMATOBJATTR(5) $gpb_fmt_var($fmt_name,integer)
  set FORMATOBJATTR(6) $gpb_fmt_var($fmt_name,decimal)
  set FORMATOBJATTR(7) $gpb_fmt_var($fmt_name,fraction)
}

#=============================================================================
# This procedure displays the formatted value, based upon the selected
# format, on the button.
#
#         Inputs    :  Format Page Object
#
#         Outputs   :  displays formatted value
#
#=============================================================================
proc UI_PB_fmt__ConfigureFmtDisplay { page_obj args } {
#=============================================================================
  global fmt_dis_attr
  global FORMATOBJATTR

  if {[string compare $FORMATOBJATTR(1) "Integer"] == 0} \
  {
      set FORMATOBJATTR(4) 0
      set FORMATOBJATTR(6) 0
      set FORMATOBJATTR(7) 0
  }

  PB_int_GetFormat FORMATOBJATTR fmt_value
  set fmt_dis_attr $fmt_value
  set top_frame $Page::($page_obj,top_frame)
  $top_frame.fmt configure -text $fmt_dis_attr
}

#=============================================================================
# This procedure creates the format page.
#
#         Inputs    :  Format Page Object
#
#         Outputs   :  Format Page Widgets
#
#=============================================================================
proc UI_PB_fmt_CreateFmtPage { fmt_obj frame } {
#=============================================================================
  global FORMATOBJATTR
  global paOption

  format::readvalue $fmt_obj FORMATOBJATTR

  set win [toplevel $frame.fmt]

  UI_PB_com_CreateTransientWindow $win "FORMAT : $FORMATOBJATTR(0)" "" "" ""

  set pname $FORMATOBJATTR(0)
  set new_fmt_page [new Page $pname $pname]
  set Page::($new_fmt_page,canvas_frame) $win
  set Page::($new_fmt_page,act_fmt_obj) $fmt_obj
  set Page::($new_fmt_page,act_fmt_name) $FORMATOBJATTR(0)
  set Page::($new_fmt_page,rest_formatobjattr) [array get FORMATOBJATTR]

  # Divides the main frame into three
    UI_PB_fmt_CreateFmtFrames new_fmt_page

  # Create format display widget
    UI_PB_fmt_CreateFmtDisplay new_fmt_page

  # Create format components in the right frame
    UI_PB_fmt_AddPageFmtParm new_fmt_page

  # Creates the Action buttons
    set ff  $Page::($new_fmt_page,bottom_frame)
    set box1_frm [frame $ff.box1]
    set box2_frm [frame $ff.box2]

    tixForm $box1_frm -top 0 -left 1 -right %50 -padright 20
    tixForm $box2_frm -top 0 -left $box1_frm -padx 1 -right %100

    set bb1 [tixButtonBox $box1_frm.bb -orientation horizontal \
          -relief sunken -bd 2 -bg $paOption(butt_bg)]

    set bb2 [tixButtonBox $box2_frm.bb -orientation horizontal \
          -relief sunken -bd 2 -bg $paOption(butt_bg)]

    $bb1 add def -text Default -width 10 -underline 0 -command \
           "UI_PB_fmt_DefaultCallBack $new_fmt_page"
    $bb1 add rest -text Restore -underline 0 -width 10 -command \
           "UI_PB_fmt_RestoreCallBack $new_fmt_page"

    $bb2 add app -text Cancel -underline 0 -width 10 -command \
           "UI_PB_fmt_CancelCallBack $new_fmt_page $win"
    $bb2 add def -text Ok -width 10 -underline 0 -command \
           "UI_PB_fmt_OkCallBack $new_fmt_page $win"

    pack $bb1 -fill x
    pack $bb2 -fill x
}

#=============================================================================
# This procedure updates the format object
#
#         Inputs    :  Format Page Object
#
#         Outputs   :  Updates the format object
#
#=============================================================================
proc UI_PB_fmt_OkCallBack { fmt_page_obj win} {
#=============================================================================
  UI_PB_fmt_ApplyCurrentFmtData fmt_page_obj

  destroy $win

  # Unset the new format page data
}

#=============================================================================
# This procedure destroys the fmt page
#
#         Inputs    :  Format Page Object
#
#
#=============================================================================
proc UI_PB_fmt_CancelCallBack { fmt_page_obj win } {
#=============================================================================
  destroy $win

  # Unset the new format page data
}
