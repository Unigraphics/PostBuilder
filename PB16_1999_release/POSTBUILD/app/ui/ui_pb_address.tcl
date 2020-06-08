#=============================================================================
#                    UI_PB_ADDRESS.TCL
#=============================================================================
##############################################################################
# Description                                                                #
#     This file contains all functions dealing with the creation of          #
#     ui elements for Address page..                                         #
#                                                                            #
# Revisions                                                                  #
#                                                                            #
#   Date        Who         Reason                                           #
# 01-feb-1999   gsl & mnb   Initial                                          #
# 07-Apr-1999   mnb         Selection of Address from tree is corrected      #
# 04-May-1999   gsl         Added more attributes                            #
# 02-Jun-1999   mnb         Code Integration                                 #
# 14-Jun-1999   mnb         Changed UI_PB_addr_ActivateAddrParams arguments  #
# 29-Jun-1999   gsl         Removed Help from options                        #
# 07-Sep-1999   mnb         Editting Format & New toplevel format page       #
# 21-Sep-1999   mnb         Can create, cut & paste the address in the tree  #
# 18-Oct-1999   gsl         Minor changes                                    #
# 17-Nov-1999   gsl         Submitted for phase-22.                                #
#                                                                            #
# $HISTORY$                                                                  #
#                                                                            #
##############################################################################

#=============================================================================
# This is the main procedure of the Address page. This procedure is called
# when the address tab in the post builder is selected for the first time.
# It creates all the widgets required to display the attributes of  an
# attributes.
#
#        Inputs   :  post builder Book id
#                    Address Page object
#
#        Outputs  :  Address page with all required widgets
#
#=============================================================================
proc UI_PB_Def_Address {book_id addr_page_obj} {
#=============================================================================
  global tixOption
  global paOption
  global add_dis_attr
  global AddObjAttr

  set add_dis_attr(0) 0
  set add_dis_attr(1) 0
  set add_dis_attr(2) 0

  # Gets the address page id from book id
    set Page::($addr_page_obj,page_id) [$book_id subwidget \
                                $Page::($addr_page_obj,page_name)]

  # Creates a pane
    Page::CreatePane $addr_page_obj

  # Add create, cut and paste buttons to left pane
    UI_PB_addr_AddCompLeftPane addr_page_obj

  # Create a tree frame in the left frame
    Page::CreateTree $addr_page_obj

  # Creates the tree elements
    UI_PB_addr_CreateTreeElements addr_page_obj

  # Divides the main frame into three frames
    UI_PB_addr_CreateAddrFrames addr_page_obj

  # Creates leader, format and trailer buttons
    UI_PB_addr_CreateLeadFmtTrailButtons addr_page_obj

  # Sets the attributes of the active address
    UI_PB_addr_AddDisplayParams $addr_page_obj 0

  # Creates the parameters of Address in the middle frame
    UI_PB_addr_CreateMiddleFrameParam addr_page_obj

  # Creates action buttons
    UI_PB_addr_CreateActionButtons addr_page_obj

  # Activate the address ui items based upon the value that is set
    UI_PB_addr_ActivateAddrParams $addr_page_obj
}

#=============================================================================
# This procedure creates the tree elements i.e it displays the address
# in the left side window.
#
#         Inputs   :  Address page object
#
#         Outputs  :  Displays Address in the left window
#
#=============================================================================
proc UI_PB_addr_CreateTreeElements { PAGE_OBJ } {
#=============================================================================
  upvar $PAGE_OBJ page_obj
  global paOption

  # Gets the tree widget id
    set tree $Page::($page_obj,tree)
    set h [$tree subwidget hlist]
    $h config -bg $paOption(tree_bg)

  $tree config \
	-command   "UI_PB_addr_AddrItemSelec $page_obj" \
        -browsecmd "UI_PB_addr_AddrItemSelec $page_obj"
}

#=============================================================================
# This procedure adds the Buttons Create, Paste & Cut above the tree
# Widget.
#
#       Inputs   :  Address Page object
#
#       Outputs  :  Creates, Create, Paste,Cut Buttons
#
#=============================================================================
proc UI_PB_addr_AddCompLeftPane { PAGE_OBJ } {
#=============================================================================
  upvar $PAGE_OBJ page_obj
  global paOption

  # Buttons
    # Gets the left pane widget id
      set left_pane $Page::($page_obj,left_pane_id)

    # Creates new frame in left pane
      set but [frame $left_pane.f]
      pack $but -side top -fill x -padx 7
 
    # Creates the buttons on the new frame
      set new [button $but.new -text "Create" -bg $paOption(app_butt_bg) \
                      -command "UI_PB_addr_CreateAddress $page_obj"]
      set del [button $but.del -text "Cut" -bg $paOption(app_butt_bg) \
                     -command "UI_PB_addr_CutAddress $page_obj"]
      set pas [button $but.pas -text "Paste" -bg $paOption(app_butt_bg) \
                     -command "UI_PB_addr_PasteAddress $page_obj"]
                                    
   pack $new $del $pas -side left -fill x -expand yes
}

#=============================================================================
# This procedure gets the address objects from the database and displays
# the address names in the tree widget as tree elements. It makes the
# address corresponding to the input index as active tree element.
#
#      Inputs  :  Address page object
#                 Index of address selected from tree
#
#      Outputs :  Creates Tree elements
#
#=============================================================================
proc UI_PB_addr_DisplayNameList { PAGE_OBJ OBJ_INDEX } {
#=============================================================================
  upvar $PAGE_OBJ page_obj
  upvar $OBJ_INDEX obj_index
  global paOption
  global gPB

  # Gets tre widget ids
    set tree $Page::($page_obj,tree)
    set h [$tree subwidget hlist]

  # Gets the icon of an address
    set file  [tix getimage pb_address]

  # Deletes all current tree elements
    $h delete all
    $h add 0  -itemtype imagetext -text "" -image $paOption(folder) \
                                           -state disabled

  # Database calls .. returns the address object list
    PB_int_RetAddressObjList addr_obj_list

  # Displays the address names as tree elements
    set style $gPB(font_style_normal)
    set count [llength $addr_obj_list]
    for {set ix 0} {$ix < $count} {incr ix}\
    {
        set addr_obj [lindex $addr_obj_list $ix]
        set addr_name $address::($addr_obj,add_name)
        $h add 0.$ix -itemtype imagetext -text $addr_name -image $file -style $style
    }

  # Makes the address corresponding to the index as active
  # Tree element.
    if {$obj_index >= 0} \
    {
      $h selection set 0.$obj_index
    } else \
    {
      $h selection set 0.0
    }
    $tree autosetmode
}

#=============================================================================
# This procedure creates a new address
#=============================================================================
proc UI_PB_addr_CreateAddress { page_obj } {
#=============================================================================
  global ADDRESSOBJATTR

  UI_PB_addr_ApplyCurrentAddrData page_obj
  set act_addr_obj $Page::($page_obj,act_addr_obj)

  # Database call to create a new address object
    PB_int_AddCreateObject act_addr_obj ADDRESSOBJATTR obj_index

  # Makes newly created address as active address
    set add_name $ADDRESSOBJATTR(0)
    set ADDRESSOBJATTR(1) $format::($ADDRESSOBJATTR(1),for_name)

  # Sets the attributes of new address in the global variable
    UI_PB_addr_UpdateAddrAttr ADDRESSOBJATTR $add_name

  # Updates the attributes of the address page
    UI_PB_addr_DisplayNameList page_obj obj_index
    UI_PB_addr_AddDisplayParams $page_obj $obj_index
    UI_PB_addr_ActivateAddrParams $page_obj
}

#=============================================================================
proc UI_PB_addr_CutAddress { page_obj } {
#=============================================================================
  global ADDRESSOBJATTR

  # Gets the tree widget id from the page object
    set tree $Page::($page_obj,tree)
    set HLIST [$tree subwidget hlist]

  # Gets the index of the selected format
    set ent [$HLIST info selection]
    set obj_index [string range $ent 2 [string length $ent]]

  set act_add_obj $Page::($page_obj,act_addr_obj)

  # An error message is popued up, if the format is used by an address
    if {$address::($act_add_obj,blk_elem_list) != ""} \
    {
       set address_name $address::($act_add_obj,add_name)
       tk_messageBox -type ok -icon error\
           -message "Address \"$address_name\" is used by the Block Elements. \
                     Address cannot be deleted"
       return
    }

  # Selected address object is deleted from the database
    PB_int_AddCutObject act_add_obj obj_index add_mom_var add_var_desc \
                        add_mseq_attr

  # Stores the address attributes as buffer for pasting
    set Page::($page_obj,add_buff_obj_attr) [array get ADDRESSOBJATTR]
    set Page::($page_obj,add_buff_mom_var) $add_mom_var
    set Page::($page_obj,add_buff_var_desc) $add_var_desc
    set Page::($page_obj,add_buff_mseq_attr) [array get add_mseq_attr]

  # Unsets the address attributes in the global variable
    set add_name $ADDRESSOBJATTR(0)
    UI_PB_addr_UnsetAddrAttr $add_name

  # Updates the address page attributes
    UI_PB_addr_DisplayNameList page_obj obj_index
    UI_PB_addr_AddDisplayParams $page_obj $obj_index
    UI_PB_addr_ActivateAddrParams $page_obj
}

#=============================================================================
proc UI_PB_addr_PasteAddress { page_obj } {
#=============================================================================

  # gets the tree widget id from page object
    set tree $Page::($page_obj,tree)
    set HLIST [$tree subwidget hlist]
    set ent [$HLIST info selection]
    set obj_index [string range $ent 2 [string length $ent]]

  # if there is no format object in the buffer, it just does nothing
    if {![info exists Page::($page_obj,add_buff_obj_attr)]} \
    {
       return
    }
    array set add_buff_obj_attr $Page::($page_obj,add_buff_obj_attr)
    set add_mom_var $Page::($page_obj,add_buff_mom_var)
    set add_var_desc $Page::($page_obj,add_buff_var_desc)
    array set add_mseq_attr $Page::($page_obj,add_buff_mseq_attr)

  # Data base call, which adds the buffer format object to the database
    set temp_index $obj_index
    PB_int_AddPasteObject add_buff_obj_attr obj_index add_mom_var add_var_desc \
                          add_mseq_attr
    unset Page::($page_obj,add_buff_obj_attr)
    unset Page::($page_obj,add_buff_mom_var)
    unset Page::($page_obj,add_buff_var_desc)
    unset Page::($page_obj,add_buff_mseq_attr)

   if {$temp_index != $obj_index } \
   {
     # Sets the attributes of new address in the global variable
       set add_name $add_buff_obj_attr(0)
       set add_buff_obj_attr(1) $format::($add_buff_obj_attr(1),for_name)
       UI_PB_addr_UpdateAddrAttr add_buff_obj_attr $add_name

     # Updates the address page attributes
       UI_PB_addr_DisplayNameList page_obj obj_index
       UI_PB_addr_AddDisplayParams $page_obj $obj_index
       UI_PB_addr_ActivateAddrParams $page_obj
   }
}

#=============================================================================
# This procedure Creates a popup menu and binds it to the leader widget.
# When the third mouse button is clicked on the leader widget, it popups
# this popup menu.
#
#       Inputs    :  Address Page object
#
#       Outputs   :  Popup menu
#
#=============================================================================
proc UI_PB_addr_CreateLeaderPopup { PAGE_OBJ } {
#=============================================================================
  upvar $PAGE_OBJ page_obj
  global AddObjAttr
  global add_dis_attr

  # Gets the middle frame id
    set f $Page::($page_obj,middle_frame)

  # Creates the popup menu and binds it to the lead widget
    set menu [menu $f.pop]
    bind $f.lea_val <1> "focus %W"
    bind $f.lea_val <3> "tk_popup $menu %X %Y"

  # Options displayed in the popup menu
    set options_list {A B C D E F G H I J K L M N O \
                      P Q R S T U V W X Y Z None}

  # Adds the options to the popup menu
  set bind_widget $f.lea_val
  set callback "UI_PB_addr_SelectLeader"
  UI_PB_addr_SetPopupOptions page_obj menu options_list callback \
                             bind_widget 
}

#=============================================================================
#  This procedure creates all the frames required for the address page,
#  to display the address attributes.
#
#        Inputs  :  Address Page Object
#
#        Outputs :  Top frame    ( To display format )
#                   Middle Frame ( to display address attribute )
#                   Bottom Frame ( For Action buttons )
#
#=============================================================================
proc UI_PB_addr_CreateAddrFrames { PAGE_OBJ } {
#=============================================================================
  upvar $PAGE_OBJ page_obj
  
  # Canvas frame is the main frame
    set canvas_frame $Page::($page_obj,canvas_frame)

  # Creates the tixbutton frame
    set top_frame [tixButtonBox $canvas_frame.top \
                 -orientation horizontal \
                 -bd 2 \
                 -relief sunken \
                 -bg gray85]
    set Page::($page_obj,top_frame) $top_frame

  # Creates a middle frame
    set middle_frame [frame $canvas_frame.mid]
    set Page::($page_obj,middle_frame) $middle_frame

  # Creates bottom frame
    set bottom_frame [frame $canvas_frame.bot]
    set Page::($page_obj,bottom_frame) $bottom_frame

  pack $top_frame -side top -fill x -padx 3 -pady 3
  pack $middle_frame -side top -pady 10 -fill both
  pack $bottom_frame -side bottom -fill x
}

#=============================================================================
# This procedure creates the options of a combobox .. basically it creates
# a list of formats as combobox elements.
#
#     Inputs   :  Address Page Object
#
#     Outputs  :  Combobox Elements
#
#=============================================================================
proc UI_PB_addr_CreateComboAttr { PAGE_OBJ } {
#=============================================================================
  upvar $PAGE_OBJ page_obj
  global Format_Name

  # Deletes the existing options list
    set fmt_frm [$Page::($page_obj,middle_frame).fmt subwidget frame]
    set fmt_sel $fmt_frm.fmt_sel
    set lbx [$fmt_sel subwidget listbox]
    $lbx delete 0 end

  # Recreates the options list

    # Database call ... returns the format object list
      PB_int_RetFormatObjList fmt_obj_list

    set name_arr_size [llength $fmt_obj_list]
    for {set ind 0} {$ind < $name_arr_size} {incr ind}\
    {
        set fmt_obj [lindex $fmt_obj_list $ind]
        set fmt_name $format::($fmt_obj,for_name)
        $fmt_sel insert end $fmt_name
    }
}

#=============================================================================
#  This procedure creates the widgets required to display address parameters
#  in the middle frame.
#
#       Inputs  :  Address Page Object
#
#       Outputs :  Middle frame widgets
#
#=============================================================================
proc UI_PB_addr_CreateMiddleFrameParam { PAGE_OBJ } {
#=============================================================================
  upvar $PAGE_OBJ page_obj
  global add_dis_attr
  global tixOption
  global paOption
  global ADDRESSOBJATTR
  global gPB_help_tips
  global Format_Name

  # Gets the middle frame widget id
    set f $Page::($page_obj,middle_frame)

  # Blank Line
    label $f.blk -text " "
  

  # LEADER Widget
    label $f.lea -text Leader \
                 -font $tixOption(bold_font)
    entry $f.lea_val -textvariable "ADDRESSOBJATTR(8)" \
                     -cursor hand2 \
                     -width 5 -borderwidth 4 \
                     -highlightcolor lightYellow \
                     -background royalBlue \
                     -foreground yellow \
                     -selectbackground lightYellow \
                     -selectforeground black
    bind  $f.lea_val <Return> "+UI_PB_addr__ApplyLeader $page_obj "

   # Creates the leader popup menu
     UI_PB_addr_CreateLeaderPopup page_obj

   # FORMAT Widget
     tixLabelFrame $f.fmt -label "Format"
     set fmt_frm [$f.fmt subwidget frame]

     button $fmt_frm.but -text " Edit " -font $tixOption(bold_font) \
               -command "UI_PB_addr_EditFormat $page_obj"
     pack $fmt_frm.but -side left -padx 10 -pady 5

     set fmt_sel [tixComboBox $fmt_frm.fmt_sel \
                -dropdown   yes \
                -editable   false \
                -variable   Format_Name \
                -command    "UI_PB_addr_SelectFormat $page_obj" \
                -selectmode immediate \
                -grab       local \
                -listwidth  45 \
                -options {
                   listbox.height   4
                   listbox.anchor   w
                   entry.width      12
                }]

     pack $fmt_frm.fmt_sel -side right -padx 10 -pady 5 
     [$fmt_sel subwidget entry] config -bg lightBlue -cursor ""
     global lbx
     set lbx [$fmt_sel subwidget listbox]
 
   # Creates combo options list
     UI_PB_addr_CreateComboAttr page_obj
     tixSetSilent $fmt_sel $ADDRESSOBJATTR(1)

   # Maximum Widget
     tixLabelFrame $f.max -label "Maximum"
     set max [$f.max subwidget frame]

     global var_max_val
     tixLabelEntry $max.val \
               -label "Value" \
               -options {
                  label.width 18
                  label.anchor w
                  entry.width 12
                  entry.anchor e
                  entry.textVariable ADDRESSOBJATTR(4)
               }

    if {![info exists ADDRESSOBJATTR(4)]  ||  $ADDRESSOBJATTR(4) == ""} {
      set ADDRESSOBJATTR(4) 999999999.9999
    }

    set m_opts {truncate warn abort}

    set m_opt_labels(truncate)  "Truncate Value"
    set m_opt_labels(warn)      "Warn User"
    set m_opt_labels(abort)     "Abort Process"

    tixOptionMenu $max.err \
               -label "Violation Handling" \
               -variable ADDRESSOBJATTR(5) \
               -options {
                  label.width 18
                  label.anchor w
                  menubutton.width 12
               }

    foreach opt $m_opts {
        $max.err add command $opt -label $m_opt_labels($opt)
    }

    pack $max.val -side top    -fill x -padx 10 -pady 4
    pack $max.err -side bottom -fill x -padx 10 -pady 2

  # MINIMUM Widget
    tixLabelFrame $f.min -label "Minimum"
    set min [$f.min subwidget frame]

    global var_min_val
    tixLabelEntry $min.val \
                -label "Value" \
                -options {
                   label.width 18
                   label.anchor w
                   entry.width 12
                   entry.anchor e
                   entry.textVariable ADDRESSOBJATTR(6)
                }

   if {![info exists ADDRESSOBJATTR(6)]  ||  $ADDRESSOBJATTR(6) == ""} {
      set ADDRESSOBJATTR(6) -999999999.9999
   }

   tixOptionMenu $min.err \
               -label "Violation Handling" \
               -variable ADDRESSOBJATTR(7) \
               -options {
                  label.width 18
                  label.anchor w
                  menubutton.width 12
               }

   foreach opt $m_opts {
       $min.err add command $opt -label $m_opt_labels($opt)
   }

   pack $min.val -side top    -fill x -padx 10 -pady 4
   pack $min.err -side bottom -fill x -padx 10 -pady 2


  # FORCE Widget
    set opts {off once always}
    set opt_labels(off)         "Off"
    set opt_labels(once)        "Once"
    set opt_labels(always)      "Always"

    tixOptionMenu $f.mod \
               -label "Modality Override" \
               -variable ADDRESSOBJATTR(2) \
               -options {
                  label.width 22
                  label.anchor w
                  menubutton.width 8
               }

    foreach opt $opts {
        $f.mod add command $opt -label $opt_labels($opt)
    }
 
    if {![info exists ADDRESSOBJATTR(2)]  ||  $ADDRESSOBJATTR(2) == ""} {
      set ADDRESSOBJATTR(2) $opt_labels(once)
    }
 
  # TRAILER
    label $f.tra -text "Trailer " \
                 -font $tixOption(bold_font)

    entry $f.tra_val -textvariable ADDRESSOBJATTR(9) \
                     -cursor hand2 \
                     -width 5 -borderwidth 4 \
                     -highlightcolor lightYellow \
                     -background royalBlue \
                     -foreground yellow \
                     -selectbackground lightYellow \
                     -selectforeground black
    bind  $f.tra_val <Return> "+UI_PB_addr__ApplyTrailer $page_obj "

  # Force this guy to be active.
    set ADDRESSOBJATTR(10) 1
    UI_PB_addr_SetCheckButPopStatus $page_obj ADDRESSOBJATTR(10)

   
  # <GSL>
    set menu [menu $f.pop1]
    bind $f.tra_val <1> "focus %W"
    bind $f.tra_val <3> "tk_popup $menu %X %Y"

    set bind_widget $f.tra_val
    set options_list {A B C D E F G H I J K L M N O \
                      P Q R S T U V W X Y Z None}

    set callback "UI_PB_addr_SelectTrailer"
    UI_PB_addr_SetPopupOptions page_obj menu options_list callback \
                               bind_widget

  # Packs all the widgets in terms of row and columns
    grid $f.blk            -
    grid $f.lea     -row 1 -col 0 -padx 5 -pady 3 -sticky w
    grid $f.lea_val -row 1 -col 1 -padx 5 -pady 3 -sticky nse
    grid $f.fmt            -      -padx 1 -pady 3 -sticky ew
    grid $f.tra     -row 3 -col 0 -padx 5 -pady 3 -sticky w
    grid $f.tra_val -row 3 -col 1 -padx 5 -pady 3 -sticky nse
    grid $f.mod            -      -padx 5 -pady 3 -sticky ew
    grid $f.max            -      -padx 1 -pady 3 -sticky ew
    grid $f.min            -      -padx 1 -pady 1 -sticky ew
}

#=============================================================================
# This is a callback function, attached to Edit button of format. It gets
# format object of the format selected in the combobox and brings up the
# format Page .. with selected format attributes.
#
#      Inputs   : Address Page Object
#
#      Outputs  : Format Page 
#
#=============================================================================
proc UI_PB_addr_EditFormat { page_obj } {
#=============================================================================
  global Format_Name

  set canvas_frame $Page::($page_obj,canvas_frame)

  # Gets the format object of the format 
    PB_int_RetFmtObjFromName Format_Name fmt_obj

  # Brings up the format page
    UI_PB_fmt_CreateFmtPage $fmt_obj $canvas_frame
}

#=============================================================================
# This proceudre sets the status of the widget passed, based upon the
# value of the state.
# 
#     Inputs  :  Widget id
#                state value
#
#     Outputs :  The widget is either disabled or enabled
#
#=============================================================================
proc UI_PB_addr_SetCheckButtonState {widget STATE} {
#=============================================================================
  upvar $STATE state
  switch $state\
  {
     0      {$widget config -state disabled}
     1      {$widget config -state normal}
  }
}

#=============================================================================
# This procedures creates the action buttons of address page and attaches
# callbacks to those action buttons.
#
#      Inputs  :  Address Page Object
#
#      Outputs :  Action buttons with callbacks
#
#=============================================================================
proc UI_PB_addr_CreateActionButtons { PAGE_OBJ } {
#=============================================================================
  upvar $PAGE_OBJ page_obj
  global paOption

  set bottom_frame $Page::($page_obj,bottom_frame)

  # Buttons
    set bb [tixButtonBox $bottom_frame.bb -orientation horizontal \
            -relief sunken -bd 2 -bg $paOption(butt_bg)]

    # Defualt button
      $bb add def -text Default -width 10 -underline 0 -command \
         "UI_PB_addr_AddDefaultCallBack $page_obj"

    # Restore Button
      $bb add app -text Restore -underline 0 -width 10 -command \
         "UI_PB_addr_AddRestoreCallBack $page_obj"
  pack $bb -fill x -padx 3 -pady 3
}

#=============================================================================
# This procedure creates the buttons to display leader, format and the
# trailing characters of an address. These buttons are created in the
# top frame.
#
#       Inputs   : Address Page object
#
#       Outputs  : Leader,format,trailing buttons.
#
#=============================================================================
proc UI_PB_addr_CreateLeadFmtTrailButtons { PAGE_OBJ } {
#=============================================================================
  upvar $PAGE_OBJ page_obj
  global tixOption
  global paOption

  # Gets the id of top frame
    set top_frame $Page::($page_obj,top_frame)
    global forget_flag

  # Create leader, format & trailing buttons
    button $top_frame.ldr -text "" -cursor "" \
                  -font $tixOption(bold_font) \
                  -bg darkSeaGreen3 -relief flat \
                  -state disabled -disabledforeground lightYellow
    button $top_frame.fmt -text "" -cursor "" \
                  -font $tixOption(bold_font) \
                  -bg darkSeaGreen3 -relief flat \
                  -state disabled -disabledforeground lightYellow
    button $top_frame.trl -text "" -cursor "" \
                  -font $tixOption(bold_font) \
                  -bg darkSeaGreen3 -relief flat \
                  -state disabled -disabledforeground lightYellow

  grid $top_frame.ldr -row 1 -column 1 -pady 10
  grid $top_frame.fmt -row 1 -column 2 -pady 10
  grid $top_frame.trl -row 1 -column 3 -pady 10

  set forget_flag 0
  $top_frame.ldr configure -activebackground darkSeaGreen3
  $top_frame.fmt configure -activebackground darkSeaGreen3
  $top_frame.trl configure -activebackground darkSeaGreen3
}

#=============================================================================
#  This procedure creates balloon, for combobox elements
#=============================================================================
proc Browse_Cmd {LBX FORMATNAMELIST x y} {
#=============================================================================
  upvar $LBX lbx
  upvar $FORMATNAMELIST FormatNameList
  global gPB_help_tips
  global old_ind
  global balloon_on

  # Identify list item @ cursor
  set ind [$lbx index @$x,$y]

  set wh [winfo height $lbx]
  set ww [winfo width $lbx]

  if {![info exists balloon_on]} {
    set balloon_on 0
  }

   if {$gPB_help_tips(state)} \
   {
    # Display balloon when cursor is within the listbox window.
     if {$x >= 0 && $x <= $ww && $y >= 0 && $y <= $wh} \
     {
       set px [winfo pointerx $lbx]
       set py [winfo pointery $lbx]

      # Redisplay balloon when cursor moves into new list item.
       if [info exists old_ind] \
       {
         if {$ind != $old_ind} \
         {
           PB_reset_balloon $lbx $px $py $ind
           set balloon_on 1
         }
       }

      # Display balloon when cursor moves back into listbox.
       if {$balloon_on == 0} \
       {
         PB_reset_balloon $lbx $px $py $ind
         set balloon_on 1
       }

    # Suppress balloon when cursor moves out of listbox.
     } else \
     {
       PB_cancel_balloon
       set balloon_on 0
     }
   }

   set old_ind $ind
}

#=============================================================================
# This proceduer writes back the address data to the database.
#
#      Inputs  :  Address Page Object
#
#      Outputs :  Writes the address attributes to database
#
#=============================================================================
proc UI_PB_addr_ApplyCurrentAddrData { PAGE_OBJ } {
#=============================================================================
  upvar $PAGE_OBJ page_obj
  global ADDRESSOBJATTR
  global Format_Name

  if {[info exist Page::($page_obj,act_addr_obj)]} \
  {
     set act_addr_obj $Page::($page_obj,act_addr_obj)
     set ADDRESSOBJATTR(1) $Format_Name
     
     set addr_name $ADDRESSOBJATTR(0)
     UI_PB_addr_UpdateAddrAttr ADDRESSOBJATTR $addr_name
     PB_int_AddApplyObject act_addr_obj ADDRESSOBJATTR
  }
}

#=============================================================================
# This proceduer calls the proceduer to update database & unsets some
# address page object attributes.
#
#      Inputs  :  Address Page Object
#
#      Outputs :  Writes the address attributes to database
#
#=============================================================================
proc UI_PB_addr_AddressApply { PAGE_OBJ } {
#=============================================================================
  upvar $PAGE_OBJ page_obj

  if {[info exist Page::($page_obj,act_addr_obj)]} \
  {
     # Calls the apply proceduer
     UI_PB_addr_ApplyCurrentAddrData page_obj
     unset Page::($page_obj,act_addr_obj)
     unset Page::($page_obj,act_addr_name)
  }
}

#=============================================================================
# This proceduer is a callback function, attached to the Defualt button.
# It gets the default data of an selected address from the database and
# displays them.
#
#       Inputs  :  Address page object
#
#       Outputs :  Displays Default data of an address
#
#=============================================================================
proc UI_PB_addr_AddDefaultCallBack { page_obj } {
#=============================================================================
  global ADDRESSOBJATTR

  # Gets active address object
    set act_addr_obj $Page::($page_obj,act_addr_obj)

  # gets the default attributes of the address object
    array set def_addr_obj_attr $address::($act_addr_obj,def_value)
    set fmt_obj $def_addr_obj_attr(1)
    set def_addr_obj_attr(1) $format::($fmt_obj,for_name)

  # Updates the Address page widgets
    set cur_addr_name $def_addr_obj_attr(0)
    UI_PB_addr_UpdateAddrAttr def_addr_obj_attr $cur_addr_name
    UI_PB_addr_SetAddressAttr $page_obj
    UI_PB_addr_ActivateAddrParams $page_obj
}

#=============================================================================
# This proceduer is called, when the Restore button of the Address page
# is selected. It restores back the data of an active address.
#
#        Inputs   :  Address page Object
#
#        Outputs  :  Restores the address data.
#
#=============================================================================
proc UI_PB_addr_AddRestoreCallBack { page_obj } {
#=============================================================================
  array set rest_addressobjattr $Page::($page_obj,rest_addressobjattr)
  
  set cur_addr_name $rest_addressobjattr(0)
  UI_PB_addr_UpdateAddrAttr rest_addressobjattr $cur_addr_name
  UI_PB_addr_SetAddressAttr $page_obj
  UI_PB_addr_ActivateAddrParams $page_obj
}

#=============================================================================
# This is a callback proceduer attached to combobox. For a selected
# format, it gets the formatted value and displays on the format
# button in the top frame.
#
#         Inputs   :  Address page object
#
#         Outputs  :  New formatted value
#
#=============================================================================
proc UI_PB_addr_SelectFormat {page_obj args} {
#=============================================================================
  global ADDRESSOBJATTR
  global add_dis_attr
  global Format_Name

  set ADDRESSOBJATTR(1) $Format_Name

  # Gets the formatted value of selected format
    PB_int_DisplayFormatValue ADDRESSOBJATTR(1) ADDRESSOBJATTR(0) \
                            add_dis_attr(1) fmt_disp
    set add_dis_attr(1) $fmt_disp

  # Displays the new formatted value on the format button
    UI_PB_addr__ConfigureAddrFormat page_obj
}

#=============================================================================
# This proceduer creates the popup options.
#
#       Inputs   :  Address Page Object
#                   Menu widget id
#                   A list of Options
#                   Callback proceduer
#                   bind widget id
#
#       Ouputs   :  Popup options menu
#
#=============================================================================
proc UI_PB_addr_SetPopupOptions {PAGE_OBJ MENU OPTIONS_LIST \
                                 CALLBACK BIND_WIDGET} {
#=============================================================================
   upvar $PAGE_OBJ page_obj
   upvar $MENU menu1
   upvar $OPTIONS_LIST options_list
   upvar $CALLBACK callback
   upvar $BIND_WIDGET bind_widget

   set count 1
   foreach ELEMENT $options_list \
   {
     if {$ELEMENT == "Help"} \
     {
         $menu1 add command -label $ELEMENT

     } elseif {$ELEMENT == "None"} \
     {
         $menu1 add command -label $ELEMENT -command \
                "$callback $page_obj $bind_widget \"\""
     } else \
     {
       if {$count == 1} \
       {
         $menu1 add command -label $ELEMENT -columnbreak 1 -command \
                "$callback $page_obj $bind_widget $ELEMENT"
       } else \
       {
         $menu1 add command -label $ELEMENT -command \
                "$callback $page_obj $bind_widget $ELEMENT"
       }
     }

     if {$count == 9} \
     { 
       set count 0
     }
     incr count
   }
}

#=============================================================================
#  This is a callback proceduer attached to the leader popup menu. This
#  proceduer updates the text of the leader button.
#
#         Inputs   :  Address Page Object
#                     Entry Widget id
#                     New Leader
#
#         Outputs  :  Updates the entry & Leader button
#
#=============================================================================
proc UI_PB_addr_SelectLeader {page_obj b str} {
#=============================================================================
   global ADDRESSOBJATTR
   global add_dis_attr

   # Updates the entry
     UI_PB_addr__UpdateEntry $b $str
     set ADDRESSOBJATTR(8) $str

   # Updates the text of Leader button in top frame
     set add_dis_attr(0) $ADDRESSOBJATTR(8)
     UI_PB_addr__ConfigureAddrLeader page_obj
     $b selection range 0 end
}

#=============================================================================
# It updates the leader entry.
#
#     Inputs    :  Entry widget id
#                  New String
#
#     Outputs   :  Updates the contents of the entry
#
#=============================================================================
proc UI_PB_addr__UpdateEntry {e str} {
#=============================================================================
   $e delete 0 end
   $e insert 0 $str
}

#=============================================================================
#  This is a callback proceduer attached to the Trailer popup menu. This
#  proceduer updates the text of the Trailer button.
#
#         Inputs   :  Address Page Object
#                     Entry Widget id
#                     New Trailer
#
#         Outputs  :  Updates the trailer entry & trailer button
#
#=============================================================================
proc UI_PB_addr_SelectTrailer {page_obj b str} {
#=============================================================================
  global ADDRESSOBJATTR
  global add_dis_attr

  # Updates the entry
    UI_PB_addr__UpdateEntry $b $str
    set ADDRESSOBJATTR(9) $str

  # Updates the trailer button
    set add_dis_attr(2) $ADDRESSOBJATTR(9)
    UI_PB_addr__ConfigureAddrTrailer page_obj
    $b selection range 0 end
}

#=============================================================================
# It is a callback proceduer, attached to the leader entry. It update
# the leader of an address.
#
#     Inputs   :  Address Page Object
#
#     Outputs  :  Updates the address parameters
#
#=============================================================================
proc UI_PB_addr__ApplyLeader {page_obj} {
#=============================================================================
   global add_dis_attr
   global ADDRESSOBJATTR

   set f $Page::($page_obj,middle_frame)
   set ADDRESSOBJATTR(8) [ $f.lea_val get ]

   set add_dis_attr(0) $ADDRESSOBJATTR(8)
   UI_PB_addr__ConfigureAddrLeader page_obj
   $f.lea_val selection range 0 end
}

#=============================================================================
# It is a callback proceduer, attached to the Trailer entry. It update
# the trailer of an address.
#
#     Inputs   :  Address Page Object
#
#     Outputs  :  Updates the address parameters
#
#=============================================================================
proc UI_PB_addr__ApplyTrailer {page_obj} {
#=============================================================================
   global add_dis_attr
   global ADDRESSOBJATTR

   set f $Page::($page_obj,middle_frame)
   set ADDRESSOBJATTR(9) [ $f.tra_val get ]

   set add_dis_attr(2) $ADDRESSOBJATTR(9)
   UI_PB_addr__ConfigureAddrTrailer page_obj
   $f.tra_val selection range 0 end
}

#=============================================================================
# It is a callback proceduer attached to the tree elements. It displays the
# attributes of the selecte address from the tree.
#
#         Inputs   :  Address page object
#
#         Outputs  :  Displays the attributes of selected address
#
#=============================================================================
proc UI_PB_addr_AddrItemSelec { page_obj args } {
#=============================================================================

  # Gets the tree widget & selected index
    set tree $Page::($page_obj,tree)
    set HLIST [$tree subwidget hlist]
    set ent [$HLIST info selection]
    set index [string range $ent 2 [string length $ent]]

  if {[string compare $index ""] == 0}\
  {
    set index 0
    $HLIST selection clear
    $HLIST anchor clear
    $HLIST selection set 0.0
    $HLIST anchor set 0.0
  }

  # Applys the attributes of the previous address
    UI_PB_addr_AddressApply page_obj

  # Displays the attributes of selected address
    UI_PB_addr_AddDisplayParams $page_obj $index
    UI_PB_addr_ActivateAddrParams $page_obj
}

#=============================================================================
#  This procedure gets the address object corresponding to the selected
#  index and displays the attributes of the address in the address page.
#  It also stores the attributes as the restore data.
#
#         Inputs   :  Address page object
#                     Selected index
#        
#         Outputs  :  Displays Address attributes
#
#=============================================================================
proc UI_PB_addr_AddDisplayParams { page_obj index} {
#=============================================================================
  global ADDRESSOBJATTR

  # Returns the address object list
    PB_int_RetAddressObjList addr_obj_list

  if {$index >= 0} \
  {
     set addr_obj [lindex $addr_obj_list $index]
     set Page::($page_obj,act_addr_obj) $addr_obj
     set Page::($page_obj,act_addr_name) $address::($addr_obj,add_name)

     # Sets the global variable
       UI_PB_addr_SetAddressAttr $page_obj

     # Restores the data of an address
       if {[info exists Page::($page_obj,rest_addressobjattr)]} \
       {
           unset Page::($page_obj,rest_addressobjattr)
       }
       set Page::($page_obj,rest_addressobjattr) [array get ADDRESSOBJATTR]
  }
}

#=============================================================================
# This procedure activates the widgets of an address page, based upon the
# selected address parameters.
#
#        Inputs   :  Address page object
#
#        Outputs  :  Activates valid address page widgets
#
#=============================================================================
proc UI_PB_addr_ActivateAddrParams { page_obj } {
#=============================================================================
  global ADDRESSOBJATTR
  global add_dis_attr

  set middle_frame $Page::($page_obj,middle_frame)
  UI_PB_addr_SetCheckButtonState $middle_frame.mod ADDRESSOBJATTR(3)
  UI_PB_addr_SetCheckButtonState $middle_frame.min_val ADDRESSOBJATTR(7)
  UI_PB_addr_SetCheckButtonState $middle_frame.max_val ADDRESSOBJATTR(5)
  UI_PB_addr__UpdateEntry $middle_frame.lea_val $ADDRESSOBJATTR(8)
  UI_PB_addr__UpdateEntry $middle_frame.tra_val $ADDRESSOBJATTR(9)

  set add_obj $Page::($page_obj,act_addr_obj)
  set addr_name $address::($add_obj,add_name)
  set addr_glob_var $address::($add_obj,rep_mom_var)
  PB_com_MapMOMVariable add_obj addr_glob_var blk_elem_text
  PB_int_GetElemDisplayAttr addr_name blk_elem_text add_dis_attr
  UI_PB_addr__ConfigureAddrAttributes page_obj
  UI_PB_addr_SetCheckButPopStatus $page_obj ADDRESSOBJATTR(10)
}

#=============================================================================
#  Sets the globla variables of address page
#=============================================================================
proc UI_PB_addr_SetAddressAttr { page_obj } {
#=============================================================================
  global gpb_addr_var
  global ADDRESSOBJATTR
  global Format_Name

  set add_name $Page::($page_obj,act_addr_name)
  set ADDRESSOBJATTR(0) $gpb_addr_var($add_name,name)
  set ADDRESSOBJATTR(1) $gpb_addr_var($add_name,fmt_name)
  set ADDRESSOBJATTR(2) $gpb_addr_var($add_name,modal)
  set ADDRESSOBJATTR(3) $gpb_addr_var($add_name,modl_status)
  set ADDRESSOBJATTR(4) $gpb_addr_var($add_name,add_max)
  set ADDRESSOBJATTR(5) $gpb_addr_var($add_name,max_status)
  set ADDRESSOBJATTR(6) $gpb_addr_var($add_name,add_min)
  set ADDRESSOBJATTR(7) $gpb_addr_var($add_name,min_status)
  set ADDRESSOBJATTR(8) $gpb_addr_var($add_name,leader_name)
  set ADDRESSOBJATTR(9) $gpb_addr_var($add_name,trailer)
  set ADDRESSOBJATTR(10) $gpb_addr_var($add_name,trail_status)
  set ADDRESSOBJATTR(11) $gpb_addr_var($add_name,incremental)

  set Format_Name $ADDRESSOBJATTR(1)
}

#=============================================================================
# Updates the global variables of the address summary page.
#
#    Inputs   :  Address Attributes
#                Address name
#
#    Outputs  :  Updates the global variable of add sum page
#
#=============================================================================
proc UI_PB_addr_UpdateAddrAttr { TEMP_ADDOBJATTR add_name } {
#=============================================================================
  upvar $TEMP_ADDOBJATTR temp_addobjattr

  # Address summary page global variable
    global gpb_addr_var

  set gpb_addr_var($add_name,name) $temp_addobjattr(0)
  set gpb_addr_var($add_name,fmt_name) $temp_addobjattr(1)
  set gpb_addr_var($add_name,modal) $temp_addobjattr(2)
  set gpb_addr_var($add_name,modl_status) $temp_addobjattr(3)
  set gpb_addr_var($add_name,add_max) $temp_addobjattr(4)
  set gpb_addr_var($add_name,max_status) $temp_addobjattr(5)
  set gpb_addr_var($add_name,add_min) $temp_addobjattr(6)
  set gpb_addr_var($add_name,min_status) $temp_addobjattr(7)
  set gpb_addr_var($add_name,leader_name) $temp_addobjattr(8)
  set gpb_addr_var($add_name,trailer) $temp_addobjattr(9)
  set gpb_addr_var($add_name,trail_status) $temp_addobjattr(10)
  set gpb_addr_var($add_name,incremental) $temp_addobjattr(11)
}

#=============================================================================
# Updates the global variables of the address summary page.
#
#    Inputs   :  Address Attributes
#                Address name
#
#    Outputs  :  Updates the global variable of add sum page
#
#=============================================================================
proc UI_PB_addr_UnsetAddrAttr { add_name } {
#=============================================================================
  # Address summary page global variable
    global gpb_addr_var

  unset gpb_addr_var($add_name,name) 
  unset gpb_addr_var($add_name,fmt_name) 
  unset gpb_addr_var($add_name,modal)
  unset gpb_addr_var($add_name,modl_status)
  unset gpb_addr_var($add_name,add_max)
  unset gpb_addr_var($add_name,max_status)
  unset gpb_addr_var($add_name,add_min)
  unset gpb_addr_var($add_name,min_status)
  unset gpb_addr_var($add_name,leader_name)
  unset gpb_addr_var($add_name,trailer)
  unset gpb_addr_var($add_name,trail_status)
  unset gpb_addr_var($add_name,incremental)
}

#=============================================================================
#  This procedure attaches the popup menu if the stat is 1 and disables
#  the popup menu if the state is 0
#
#       Inputs  :  Address page object
#                  state value
#
#       Outputs :  popup menu
#
#=============================================================================
proc UI_PB_addr_SetCheckButPopStatus {page_obj STATE} {
#=============================================================================
  upvar $STATE state
  global add_dis_attr
  global forget_flag

  set middle_frame $Page::($page_obj,middle_frame)

  if {!$state}\
  {
      $middle_frame.tra_val configure -state disabled -cursor ""
      bind $middle_frame.tra_val <3> ""
      set forget_flag 1
  } else\
  {
      $middle_frame.tra_val configure -state normal -cursor hand2
      bind $middle_frame.tra_val <1> "focus %W"
      bind $middle_frame.tra_val <3> "tk_popup $middle_frame.pop1 %X %Y"
      set forget_flag 0
  }
  UI_PB_addr__ConfigureAddrAttributes page_obj
}

#=============================================================================
#  This proceduer configures the text of the leader button in the top frame
#
#        Inputs   :  Address page object
#
#        Outputs  :  configures the text leader button
#
#=============================================================================
proc UI_PB_addr__ConfigureAddrLeader { PAGE_OBJ } {
#=============================================================================
   upvar $PAGE_OBJ page_obj
   global add_dis_attr

   set top_frame $Page::($page_obj,top_frame)

   $top_frame.ldr configure -text $add_dis_attr(0)

   if {[string compare $add_dis_attr(0) ""]} \
   {
       grid $top_frame.ldr -row 1 -column 1 -pady 10
   } else \
   {
       grid forget $top_frame.ldr
   }
}

#=============================================================================
#  This proceduer configures the text of the format button in the top frame
#
#        Inputs   :  Address page object
#
#        Outputs  :  configures the text format button
#
#=============================================================================
proc UI_PB_addr__ConfigureAddrFormat { PAGE_OBJ } {
#=============================================================================
   upvar $PAGE_OBJ page_obj
   global add_dis_attr

   set top_frame $Page::($page_obj,top_frame)

   $top_frame.fmt configure -text $add_dis_attr(1)
}

#=============================================================================
#  This proceduer configures the text of the trailer button in the top frame
#
#        Inputs   :  Address page object
#
#        Outputs  :  configures the text trailer button
#
#=============================================================================
proc UI_PB_addr__ConfigureAddrTrailer { PAGE_OBJ } {
#=============================================================================
   upvar $PAGE_OBJ page_obj
   global add_dis_attr
   global forget_flag

   set top_frame $Page::($page_obj,top_frame)

   $top_frame.trl configure -text $add_dis_attr(2)

   if {[string compare $add_dis_attr(2) ""]} \
   {
     if {$forget_flag == 0} \
     {
         grid $top_frame.trl -row 1 -column 3 -pady 10
     } else \
     {
         grid forget $top_frame.trl
     }
   } else \
   {
       grid forget $top_frame.trl
   }
}

#=============================================================================
# This proceduer calls the leader, format and trailer configuration
# procedures.
#
#        Inputs    :  Address page object
#
#        Outputs   :  Configures the text of leader, format &
#                     trailer buttons.
#
#=============================================================================
proc UI_PB_addr__ConfigureAddrAttributes { PAGE_OBJ } {
#=============================================================================
   upvar $PAGE_OBJ page_obj

   UI_PB_addr__ConfigureAddrLeader  page_obj
   UI_PB_addr__ConfigureAddrFormat  page_obj
   UI_PB_addr__ConfigureAddrTrailer page_obj
}

#=============================================================================
proc UI_PB_addr_TabAddressCreate { addr_page_obj } {
#=============================================================================
  set tree $Page::($addr_page_obj,tree)
  set HLIST [$tree subwidget hlist]

  set ent [$HLIST info selection]
  set index [string range $ent 2 [string length $ent]]
  if {[string compare $index ""] == 0} \
  {
    set index 0
  }

  # Displays the addresses in the tree widget.
    UI_PB_addr_DisplayNameList addr_page_obj index

  # Updates the address page attributes
    UI_PB_addr_AddrItemSelec $addr_page_obj
    UI_PB_addr_CreateComboAttr addr_page_obj
}

#==============================================================================
#  This procedure creates the format page on a new top level
#
#           Inputs   :   Address object
#                        Top level frame
#
#           Outputs  :   Address page
#
#==============================================================================
proc UI_PB_addr_CreateAddressPage { win add_obj NEW_ADD_PAGE } {
#==============================================================================
  upvar $NEW_ADD_PAGE new_add_page

  global ADDRESSOBJATTR
  global Format_Name
  global paOption
  global add_dis_attr

  set add_dis_attr(0) 0
  set add_dis_attr(1) 0
  set add_dis_attr(2) 0

  address::readvalue $add_obj ADDRESSOBJATTR
  format::readvalue $ADDRESSOBJATTR(1) fmt_obj_attr
  set ADDRESSOBJATTR(1) $fmt_obj_attr(0)
  set pname $ADDRESSOBJATTR(0)
   
  set Format_Name $ADDRESSOBJATTR(1)

  set new_add_page [new Page $pname $pname]
  toplevel $win
  UI_PB_com_CreateTransientWindow $win "ADDRESS : $ADDRESSOBJATTR(0)" {} "" ""

  # Grabs the window
###    grab set $win

  set Page::($new_add_page,canvas_frame) $win
  set Page::($new_add_page,act_addr_obj) $add_obj
  set Page::($new_add_page,act_addr_name) $ADDRESSOBJATTR(0)
  set Page::($new_add_page,rest_addressobjattr) [array get ADDRESSOBJATTR]

  # Divides the main frame into three frames
    UI_PB_addr_CreateAddrFrames new_add_page

  # Creates leader, format and trailer buttons
    UI_PB_addr_CreateLeadFmtTrailButtons new_add_page

  # Creates the parameters of Address in the middle frame
    UI_PB_addr_CreateMiddleFrameParam new_add_page

  # Activate the address ui items based upon the value that is set
    UI_PB_addr_ActivateAddrParams $new_add_page
}

#==============================================================================
proc UI_PB_add_EditAddActions { win BLK_PAGE_OBJ NEW_ADD_PAGE BLK_ELEM_OBJ} {
#==============================================================================
  upvar $BLK_PAGE_OBJ blk_page_obj
  upvar $NEW_ADD_PAGE new_add_page
  upvar $BLK_ELEM_OBJ blk_elem_obj
  global paOption

  # Creates the Action buttons
    set ff $Page::($new_add_page,bottom_frame)
    set box1_frm [frame $ff.box1]
    set box2_frm [frame $ff.box2]

    tixForm $box1_frm -top 0 -left 3 -right %50 -padright 20
    tixForm $box2_frm -top 0 -left $box1_frm -padx 3 -right %100

    set bb1 [tixButtonBox $box1_frm.bb -orientation horizontal \
          -relief sunken -bd 2 -bg $paOption(butt_bg)]

    set bb2 [tixButtonBox $box2_frm.bb -orientation horizontal \
          -relief sunken -bd 2 -bg $paOption(butt_bg)]

    $bb1 add def -text Default -width 10 -underline 0 -command \
           "UI_PB_addr_AddDefaultCallBack $new_add_page"
    $bb1 add rest -text Restore -underline 0 -width 10 -command \
           "UI_PB_addr_AddRestoreCallBack $new_add_page"

    $bb2 add canc -text Cancel -underline 0 -width 10 -command \
           "UI_PB_add_EditCancelCallBack $new_add_page $win"
    $bb2 add ok -text Ok -width 10 -underline 0 -command \
           "UI_PB_add_EditOkCallBack $blk_page_obj $new_add_page $win \
                                     $blk_elem_obj"
    pack $bb1 -fill x
    pack $bb2 -fill x
}

#=============================================================================
#  It is a OK Callback proceduer. It updates the attributes of an address
#  and destroys the top level.
#
#     Inputs  :  Address page object
#                window id
#
#     Outputs :  updates the address attributes & destroys the toplevel
#
#=============================================================================
proc UI_PB_add_EditOkCallBack { blk_page_obj add_page_obj win blk_elem_obj } {
#=============================================================================
  global elem_text_var

  # Updates the mom varaible of the element
    set block_element::($blk_elem_obj,elem_mom_variable) $elem_text_var

  # Updates the address attributes
    UI_PB_addr_ApplyCurrentAddrData add_page_obj
    set add_obj $block_element::($blk_elem_obj,elem_add_obj)
    set base_addr $address::($add_obj,add_name)
    UI_PB_blk_ReplaceIcon blk_page_obj $base_addr $blk_elem_obj

  # Configures the element buttons
    UI_PB_blk_ConfigureLeader blk_page_obj blk_elem_obj

###  grab release $win
  tixDestroy $win

  # Unset the new format page data
}

#=============================================================================
# It is Cancel Callback procedure. It destroys the toplevel.
#
#     Inputs  :  Address page object
#                window id
#
#     Outputs :  Destroys the toplevel
#
#=============================================================================
proc UI_PB_add_EditCancelCallBack { add_page_obj win } {
#=============================================================================

###  grab release $win
  tixDestroy $win

  # Unset the new format page data
}

#==============================================================================
proc UI_PB_add_NewAddActions { win blk_page_obj event_obj evt_elem_obj \
                               NEW_ADD_PAGE BLK_ELEM_OBJ page_name } {
#==============================================================================
  upvar $NEW_ADD_PAGE new_add_page
  upvar $BLK_ELEM_OBJ blk_elem_obj
  global paOption

  # Creates the Action buttons
    set ff $Page::($new_add_page,bottom_frame)
    set box1_frm [frame $ff.box1]
    set box2_frm [frame $ff.box2]

    tixForm $box1_frm -top 0 -left 3 -right %50 -padright 20
    tixForm $box2_frm -top 0 -left $box1_frm -padx 3 -right %100

    set bb1 [tixButtonBox $box1_frm.bb -orientation horizontal \
          -relief sunken -bd 2 -bg $paOption(butt_bg)]

    set bb2 [tixButtonBox $box2_frm.bb -orientation horizontal \
          -relief sunken -bd 2 -bg $paOption(butt_bg)]

    $bb1 add def -text Default -width 10 -underline 0 -command \
           "UI_PB_addr_AddDefaultCallBack $new_add_page"
    $bb1 add rest -text Restore -underline 0 -width 10 -command \
           "UI_PB_addr_AddRestoreCallBack $new_add_page"

    if { $page_name == "block" } \
    {
       $bb2 add canc -text Cancel -underline 0 -width 10 -command \
           "UI_PB_add_NewBlkCancelCallBack $blk_page_obj $new_add_page $win \
                                           $blk_elem_obj"
    } elseif { $page_name == "event" } \
    {
       $bb2 add canc -text Cancel -underline 0 -width 10 -command \
           "UI_PB_add_NewEvtCancelCallBack $blk_page_obj $event_obj \
                       $evt_elem_obj $new_add_page $win $blk_elem_obj"
    }

    $bb2 add ok -text Ok -width 10 -underline 0 -command \
           "UI_PB_add_NewOkCallBack $blk_page_obj $new_add_page $win \
                                    $blk_elem_obj"
    pack $bb1 -fill x
    pack $bb2 -fill x
}

#=============================================================================
proc UI_PB_add_NewBlkCancelCallBack { blk_page_obj add_page_obj win \
                                      blk_elem_obj } {
#=============================================================================

  set add_obj $block_element::($blk_elem_obj,elem_add_obj)
  PB_int_RemoveAddObjFromList add_obj
 
  set Page::($blk_page_obj,source_elem_obj) $blk_elem_obj
  UI_PB_blk_UpdateCells blk_page_obj

###  grab release $win
  tixDestroy $win

}

#=============================================================================
proc UI_PB_add_NewEvtCancelCallBack { blk_page_obj event_obj evt_elem_obj \
                                      new_add_page win blk_elem_obj } {
#=============================================================================
  set add_obj $block_element::($blk_elem_obj,elem_add_obj)
  PB_int_RemoveAddObjFromList add_obj

  set Page::($blk_page_obj,source_blk_elem_obj) $blk_elem_obj
  set Page::($blk_page_obj,source_evt_elem_obj) $evt_elem_obj

  UI_PB_tpth_PutBlockElemTrash blk_page_obj event_obj

###  grab release $win
  tixDestroy $win
}

#=============================================================================
proc UI_PB_add_NewOkCallBack { blk_page_obj add_page_obj win blk_elem_obj } {
#=============================================================================
  global elem_text_var

  # Updates the address attributes
    UI_PB_addr_ApplyCurrentAddrData add_page_obj

  # Database call returns the descrptions of all mom variables
    PB_int_GetWordVarDesc WordDescArray

  # Replaces the icon
    set block_element::($blk_elem_obj,elem_mom_variable) $elem_text_var
    set addr_obj $block_element::($blk_elem_obj,elem_add_obj)
    set base_addr $address::($addr_obj,add_name)
    set WordDescArray($base_addr) ""
    PB_int_UpdateAddVariablesAttr WordDescArray base_addr
    
    UI_PB_blk_ReplaceIcon blk_page_obj $base_addr $blk_elem_obj

  # Configures the element buttons
    UI_PB_blk_ConfigureLeader blk_page_obj blk_elem_obj

###  grab release $win
  tixDestroy $win
}
