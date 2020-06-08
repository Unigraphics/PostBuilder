#=============================================================================
#                     UI_PB_SEQUENCE.TCL
#=============================================================================
##############################################################################
# Description                                                                #
#     This file contains all functions dealing with the creation of          #
#     ui elements of the sequences.                                          #
#                                                                            #
# Revisions                                                                  #
#                                                                            #
#   Date        Who       Reason                                             #
# 01-feb-1999   mnb       Initial                                            #
# 07-Apr-1999   mnb       Changed bitmap names                               #
# 02-Jun-1999   mnb       Code Integration                                   #
# 29-Jun-1999   mnb       Changes event image properties, when the event     #
#                         dialog is open                                     #
# 07-Sep-1999   mnb       A new block can be created and added to any event  #
#                         in the sequence page                               #
# 21-Sep-1999   mnb       Added Modality (Force Output Dialog) to a block    #
# 18-Oct-1999   gsl       Minor changes                                      #
# 22-Oct-1999   gsl       Added "Delete" option to the popup menu.           #
# 09-Nov-1999   gsl       Disable entire canvas when a Block is being edited #
#                         (UI_PB_evt_EditBlock)                              #
# 17-Nov-1999   gsl       Submitted for phase-22.                            #
#                                                                            #
# $HISTORY$                                                                  #
#                                                                            #
##############################################################################

#==========================================================================
# This procedure creates the menu options i.e a list of blocks
# that are valid for a Sequence.
#==========================================================================
proc UI_PB_evt_CreateMenuOptions {PAGE_OBJ SEQ_OBJ} {
#==========================================================================
  upvar $PAGE_OBJ page_obj
  upvar $SEQ_OBJ seq_obj

  global tixOption
  global CB_Block_Name

  # Gets the menubutton id
    set comb_widget $Page::($page_obj,comb_widget)
    set lbx [$comb_widget subwidget listbox]

  # Deletes all the existing options
    $lbx delete 0 end

  # no of combobox elements
    set no_of_elements [llength $sequence::($seq_obj,comb_elem_list)]
  
  # Adds new block option to combo box
    $comb_widget insert end "New Block"

  # Adds the options to the combobox
    for {set jj 0} {$jj < $no_of_elements} {incr jj} \
    {
       set element [lindex $sequence::($seq_obj,comb_elem_list) $jj]
       $comb_widget insert end $element 
    }

  # Sets the combobox variable to the first option, as default
    set comb_var [lindex $sequence::($seq_obj,comb_elem_list) 0]
    set sequence::($seq_obj,comb_var) $comb_var
    set CB_Block_Name $comb_var
}

#==========================================================================
# This procedure is called whenever an option is selected
# from the combobox list.
#==========================================================================
proc UI_PB_evt_ComboSelection {page_obj seq_obj sel_index} {
#==========================================================================
  global tixOption

  # Gets the selected option, from the combo list,through the index
    set selected_elem [lindex $sequence::($seq_obj,comb_elem_list) \
                     $sel_index]
    set comb_var $selected_elem

  # Checks for the combobox text entry, if it exists delets it
   if {[info exists sequence::($seq_obj,comb_text)]}\
   {
      $Page::($page_obj,top_canvas) delete \
                       $sequence::($seq_obj,comb_text)
   }

  # Creates a new combobox text entry, with selected option
   set sequence::($seq_obj,comb_text) [$Page::($page_obj,top_canvas) \
        create text $Page::($page_obj,entry_cx) \
        $Page::($page_obj,entry_cy) -text $comb_var -font $tixOption(font)]

   set sequence::($seq_obj,comb_var) $comb_var
}

#===============================================================
# This procedure creates the action canvas for the action
# blocks. The action blocks exists only for the
# Program Start of Sequence.
#===============================================================
proc UI_PB_evt_CreateActionCanvas {PAGE_OBJ SEQ_OBJ} {
#===============================================================
   upvar $PAGE_OBJ page_obj
   upvar $SEQ_OBJ seq_obj
   global tixOption
 
   # Hard coded action block names
    set prog_start_act {"Program ID" "Part No" "Tape Leader"}

   # Gets all the page attributes
    set t_shift $Page::($page_obj,glob_text_shift)
    set blk_width [lindex $Page::($page_obj,glob_evnt_dim) 0]
    set blk_height [lindex $Page::($page_obj,glob_evnt_dim) 1]
    set blk_blkdis $Page::($page_obj,glob_blk_blkdist_hor)
    set rect_gap $Page::($page_obj,glob_rect_gap)

    set canvas_frame $Page::($page_obj,canvas_frame)

   # Creates the action canvas in the canvas frame
    set action_canvas [canvas $canvas_frame.act]

   pack $action_canvas -side bottom -fill x -padx 3
   $action_canvas config -height 70

   set Page::($page_obj,action_canvas) $action_canvas
   set Page::($page_obj,act_canvas_hi) 70

  # Hard coded the center of the first action block
   set xc 120
   set yc 35
   
  # Creates a rectangle around the action blocks based upon
  # the no of action blocks
   set no_action_blk [llength $prog_start_act]
   set x1 [expr $xc - [expr $blk_width / 2] - $rect_gap]
   set y1 [expr $yc - [expr $blk_height / 2] - $rect_gap]
   set x2 [expr $x1 + [expr $blk_width * $no_action_blk] + \
          [expr $blk_blkdis * [expr $no_action_blk - 1]] + \
          [expr 2 * $rect_gap]]
   set y2 [expr $y1 + $blk_height + [expr 2 * $rect_gap]]

  # stores the action rect and its coords as the attribute of sequence
   set sequence::($seq_obj,action_rect) [$action_canvas create rect \
           $x1 $y1 $x2 $y2 -fill lightgray -outline lightgray]

   lappend sequence::($seq_obj,action_dim) $x1 $y1 $x2 $y2
 
  # Creates the ui block objects of action blocks
   foreach act_elem $prog_start_act \
   {
       set act_blk_obj [new block]
       set blk_obj_attr(0) $act_elem
       set blk_obj_attr(1) ""
       set blk_obj_attr(2) "" 
       set blk_obj_attr(3) ""
       set blk_obj_attr(4) ""
       block::setvalue $act_blk_obj blk_obj_attr

       set act_elem_obj [new event_element]
       set elem_obj_attr(0) $act_elem
       set elem_obj_attr(1) $act_blk_obj
       set elem_obj_attr(2) "action"
       event_element::setvalue $act_elem_obj elem_obj_attr

      #stores the type of block
        set blk_img_id [UI_PB_blk_CreateIcon $action_canvas pb_block ""]
        $blk_img_id config -bg lightsteelblue1

      # creates the action icon at the xc and yc center
        set img_id [$action_canvas create image $xc $yc -image $blk_img_id \
                    -tag act_movable]
      # stores the image id as the attribute of block object
        set event_element::($act_elem_obj,icon_id) $img_id

      # Creates the text widget for the action block
        set text_id [$action_canvas create text [expr $xc + $t_shift] \
                    $yc -text $act_elem -font $tixOption(bold_font) \
                    -tag act_movable]
      # stores the text_id and the icon center
        set event_element::($act_elem_obj,text_id) $text_id
        set event_element::($act_elem_obj,xc) $xc
        set event_element::($act_elem_obj,yc) $yc

      # stores the icon id and text id as a list
       lappend sequence::($seq_obj,action_texticon) $text_id $img_id
       set xc [expr $xc + $blk_width + $blk_blkdis]

      # Creates a tempory list of all the action block objects
       lappend temp_actelem_list $act_elem_obj
   }
      # stores the action block object in the sequence object
       set sequence::($seq_obj,action_elem_list) $temp_actelem_list
       set sequence::($seq_obj,def_action_elem_list) $temp_actelem_list
       set sequence::($seq_obj,rest_action_elem_list) $temp_actelem_list
       
      # Bind procedure
       UI_PB_evt_ActionBindProcs page_obj seq_obj
}

#=====================================================================
# This procedure attaches the bind calls to the action blocks
#=====================================================================
proc UI_PB_evt_ActionBindProcs {PAGE_OBJ SEQ_OBJ} {
#=====================================================================
   upvar $PAGE_OBJ page_obj
   upvar $SEQ_OBJ seq_obj

   # Gets the action canvas id
     set action_canvas $Page::($page_obj,action_canvas)

   # Binds Enter 
     $action_canvas bind act_movable <Enter> \
                       "UI_PB_evt_ActionFocusOn $action_canvas $seq_obj"
   # Binds Leave
     $action_canvas bind act_movable <Leave> \
                       "UI_PB_evt_ActionFocusOff $action_canvas $seq_obj"
   # Binds First mouse button
     $action_canvas bind act_movable <1> \
                       "UI_PB_evt_ActionStartDrag $page_obj $seq_obj %x %y"
   # Binds the First button motion
     $action_canvas bind act_movable <B1-Motion> \
                       "UI_PB_evt_ActionDrag $page_obj $seq_obj %x %y"
   # Binds the release of the first button
     $action_canvas bind act_movable <ButtonRelease-1> \
                       "UI_PB_evt_ActionEndDrag $page_obj $seq_obj" 
}

#=====================================================================
proc UI_PB_evt_ActionUnBindProcs {PAGE_OBJ SEQ_OBJ} {
#=====================================================================
   upvar $PAGE_OBJ page_obj
   upvar $SEQ_OBJ seq_obj

   # Gets the action canvas id
     set action_canvas $Page::($page_obj,action_canvas)

   # UnBinds Enter 
     $action_canvas bind act_movable <Enter> ""

   # UnBinds Leave
     $action_canvas bind act_movable <Leave> ""

   # UnBinds First mouse button
     $action_canvas bind act_movable <1> ""

   # UnBinds the First button motion
     $action_canvas bind act_movable <B1-Motion> ""

   # UnBinds the release of the first button
     $action_canvas bind act_movable <ButtonRelease-1> ""
}

#========================================================================
# This procedure highlights the in focus action block, when the
# cursor enters the action block.
#=========================================================================
proc UI_PB_evt_ActionFocusOn {action_canvas seq_obj} {
#=========================================================================
  global paOption
 
  # Gets the texticon list of action blocks
    set texticon_id $sequence::($seq_obj,action_texticon)
  
  # Based upon the current x and y position, it returns the
  # icon id  of action block
    set img [UI_PB_evt_GetCurrentImage $action_canvas texticon_id]

  # The icon id of the action block is stored as the focus block
    set sequence::($seq_obj,act_focus_cell) $img
    $img configure -background $paOption(focus)

  # Change cursor
    $action_canvas config -cursor hand2
}

#========================================================================
# This procedure unhighlights the in focus action block, when the
# cursor leaves the action block.
#========================================================================
proc UI_PB_evt_ActionFocusOff {action_canvas seq_obj} {
#========================================================================
  # Unhighlight current icon
    set act_focus_cell $sequence::($seq_obj,act_focus_cell)

    if {$act_focus_cell != 0} \
    {
       $act_focus_cell configure -background lightsteelblue1
       set sequence::($seq_obj,act_focus_cell) 0
    }

  # Restore cursor
    $action_canvas config -cursor ""
}

#=======================================================================
# This procedure returns the action block object, based upon
# the image name.
#========================================================================
proc UI_PB_evt_GetActionBlock {PAGE_OBJ SEQ_OBJ image_name} {
#========================================================================
  upvar $PAGE_OBJ page_obj
  upvar $SEQ_OBJ seq_obj

  # Gets the list of action block objects
    set action_elem_list $sequence::($seq_obj,action_elem_list)
    set action_canvas $Page::($page_obj,action_canvas)

  # Cycles all the action block objects, and matches
  # the image name with the icon id stored in the action
  # block objects.
    foreach action_elem_obj $action_elem_list \
    {
      set img_id $event_element::($action_elem_obj,icon_id) 
      set elem_img_name [lindex [$action_canvas itemconfigure \
                            $img_id -image] end]
      if {[string compare $image_name $elem_img_name] == 0} \
      {
         set sequence::($seq_obj,drag_blk_obj) $action_elem_obj
         break
      }
   }
}

#=========================================================================
# This procedure is called, when first mouse button is clicked on the
# Action block. 
#==========================================================================
proc UI_PB_evt_ActionStartDrag {page_obj seq_obj x y} {
#==========================================================================
  global paOption
  global tixOption

  set bot_canvas $Page::($page_obj,bot_canvas)
  set action_canvas $Page::($page_obj,action_canvas)
  set t_shift $Page::($page_obj,glob_text_shift)

  # Returns the top and bottom portion of the canvas, that is
  # not to be seen
   set y_shift [$bot_canvas yview]
  
  # Gets the top portion of canvas
   set top_portion [expr [lindex $y_shift 0] * $Page::($page_obj,bot_height)]

  # Gets the bottom canvas height
   set canvas_hi [expr [expr [lindex $y_shift 1] - [lindex $y_shift 0]] * \
                                         $Page::($page_obj,bot_height)]

   set Page::($page_obj,bot_canvas_hi) $canvas_hi
   set panel_hi $Page::($page_obj,bot_canvas_hi)
   set dy [expr $panel_hi + 6]

   set xx [$action_canvas canvasx $x]
   set yy [$action_canvas canvasy $y]

   set texticon_id $sequence::($seq_obj,action_texticon)
  # Gets the current action block image based upon cursor location
   set img [UI_PB_evt_GetCurrentImage $action_canvas texticon_id]

   set sequence::($seq_obj,prev_act_blk_xc) $xx
   set sequence::($seq_obj,prev_act_blk_yc) $yy

   UI_PB_evt_GetActionBlock page_obj seq_obj $img
   set elem_obj $sequence::($seq_obj,drag_blk_obj)
      
  # Action block center is obtained
   set elem_xc $event_element::($elem_obj,xc)
   set elem_yc $event_element::($elem_obj,yc)
 
  # Calculates the distance between the cursor and the
  # action block center
   set diff_x [expr $xx - $elem_xc]
   set diff_y [expr $yy - $elem_yc]

  # Creates a block image in the bottom canvas
   set img_addr [UI_PB_blk_CreateIcon $bot_canvas pb_block ""]
   $img_addr config -bg $paOption(focus)

  # Creates the new block image in the bottom canvas
   set elem_bot_img [$bot_canvas create image [expr $x - $diff_x] \
                     [expr $y + $dy - $diff_y + $top_portion] \
                     -image $img_addr -tag del_block]
 
  # Creates the text widget 
    set block_obj $event_element::($elem_obj,block_obj)
   set elem_text $block::($block_obj,block_name)
   set elem_bot_text [$bot_canvas create text [expr $x - $diff_x + $t_shift] \
              [expr $y + $dy - $diff_y + $top_portion] -text $elem_text \
              -font $tixOption(bold_font) -tag act_movable]
 
  # Stores the attributes of action block as atributes of sequence
   set sequence::($seq_obj,icon_bot) $elem_bot_img
   set sequence::($seq_obj,icon_bot_text) $elem_bot_text
   set sequence::($seq_obj,prev_bot_blk_xc) $x
   set sequence::($seq_obj,prev_bot_blk_yc) \
                    [expr $y + $panel_hi + $top_portion]
}

#==========================================================================
# This procedure is triggered, when the cursor is moved by
# pressing the first mouse button on the action block
#==========================================================================
proc UI_PB_evt_ActionDrag {page_obj seq_obj x y} {
#==========================================================================
   set bot_canvas $Page::($page_obj,bot_canvas)
   set action_canvas $Page::($page_obj,action_canvas)
  
  # Gets the height of the bottom canvas
    set panel_hi $Page::($page_obj,bot_canvas_hi)

   set xa [$action_canvas canvasx $x]
   set ya [$action_canvas canvasy $y]
 
   set texticon_id $sequence::($seq_obj,action_texticon)
  # Gets the current icon and test id based upon the cursor location
    set objects [UI_PB_evt_GetCurrentCanvasObject $action_canvas texticon_id]

  # Translates the icon  and text in action canvas
   $action_canvas move [lindex $objects 0] \
         [expr $xa - $sequence::($seq_obj,prev_act_blk_xc)] \
         [expr $ya - $sequence::($seq_obj,prev_act_blk_yc)]

   $action_canvas move [lindex $objects 1] \
         [expr $xa - $sequence::($seq_obj,prev_act_blk_xc)] \
         [expr $ya - $sequence::($seq_obj,prev_act_blk_yc)]

   $action_canvas raise [lindex $objects 0]
   $action_canvas raise [lindex $objects 1]
 
   set xb [$bot_canvas canvasx $x]
   set yb [$bot_canvas canvasy $y]

  # Translates the icon and text in bottom canvas
   $bot_canvas move $sequence::($seq_obj,icon_bot) \
        [expr $xb - $sequence::($seq_obj,prev_bot_blk_xc)] \
        [expr $yb - $sequence::($seq_obj,prev_bot_blk_yc) + $panel_hi] 

   $bot_canvas move $sequence::($seq_obj,icon_bot_text) \
        [expr $xb - $sequence::($seq_obj,prev_bot_blk_xc)] \
        [expr $yb - $sequence::($seq_obj,prev_bot_blk_yc) + $panel_hi] 

   set sequence::($seq_obj,prev_act_blk_xc) $xa
   set sequence::($seq_obj,prev_act_blk_yc) $ya
 
   set yb [expr $yb + $panel_hi]

   set sequence::($seq_obj,prev_bot_blk_xc) $xb
   set sequence::($seq_obj,prev_bot_blk_yc) $yb

  # Gets the Event object based upon the cursor location
   UI_PB_evt_GetEventObjFromCurPos page_obj seq_obj $xb $yb
 
  # Based upon the cursor position, it highlights the
  # top or bottom seperators or the rectangle itself
   UI_PB_evt_HighLightSep page_obj seq_obj $xb $yb
}

#=========================================================================
# This proecedure is called, when the first mouse button holding the
# action block is released
#==========================================================================
proc UI_PB_evt_ActionEndDrag {page_obj seq_obj} {
#==========================================================================
   global paOption

   set action_canvas $Page::($page_obj,action_canvas)
   set bot_canvas $Page::($page_obj,bot_canvas)
   set drag_elem_obj $sequence::($seq_obj,drag_blk_obj)

  # Deletes the temporary block icon, created in the
  # bottom canvas, for drag and drop.
   if {$sequence::($seq_obj,icon_bot) != 0} \
   {
       $bot_canvas delete $sequence::($seq_obj,icon_bot)
       set sequence::($seq_obj,icon_bot) 0
       $bot_canvas delete $sequence::($seq_obj,icon_bot_text)
       set sequence::($seq_obj,icon_bot_text) 0
   }

  # Checks for the existence of the event, at the point of
  # releasing the first mouse button. If it didnot find
  # any event, it returns the action block to its original
  # position.
   if {![info exists sequence::($seq_obj,add_blkto_evt_obj)]} \
   {
       UI_PB_evt_ReturnActionBlock page_obj seq_obj
       return
   }

  # Checks for the adding conditions. Whether it has
  # to be added to a existing row, or above a block (top) or
  # below a block (bot). If neither of these conditions is
  # is satisfied it returns back to its original position.
   if {$sequence::($seq_obj,add_blk) != 0} \
   {
      # Unhighlights the highligted seperators
       UI_PB_evt_UnHighlightSeperators $bot_canvas seq_obj
       set active_evt_obj $sequence::($seq_obj,add_blkto_evt_obj)
      
      # Checks status of the Event. Whether it is collapsed or in the
      # expanded status. If it is collapsed, block is returned to its
      # original position.
      if {[string compare $event::($active_evt_obj,col_image) "minus"] == 0} \
       {
           $action_canvas delete $event_element::($drag_elem_obj,icon_id)
          # Creates a new element of a event
           set new_elem_obj [new event_element]
           set block_obj $event_element::($drag_elem_obj,block_obj)
           set elem_obj_attr(0) $block::($block_obj,block_name)
           set elem_obj_attr(1) $block_obj
           set elem_obj_attr(2) "action"
           event_element::setvalue $new_elem_obj elem_obj_attr

           switch $sequence::($seq_obj,add_blk) \
           {
               "row" \
               {
                   # Adds the action block to a selected row
                   UI_PB_evt_AddBlkToARow page_obj seq_obj new_elem_obj
               }
               "top" \
               {
                  # Adds the action block, above the selected row 
                   UI_PB_evt_AddBlkAboveOrBelow page_obj seq_obj new_elem_obj
               }
               "bottom" \
               {
                  # Adds the action block, below the selected row 
                   UI_PB_evt_AddBlkAboveOrBelow page_obj seq_obj new_elem_obj
               }
            }
       }
       set sequence::($seq_obj,add_blk) 0
   } else \
   {
      # Returns the action block to its originla position
       UI_PB_evt_ReturnActionBlock page_obj seq_obj
   }
}

#==============================================================================
# This procedure locates the draged action block at its
# original position
#===============================================================================
proc UI_PB_evt_ReturnActionBlock {PAGE_OBJ SEQ_OBJ} {
#===============================================================================
  upvar $PAGE_OBJ page_obj
  upvar $SEQ_OBJ seq_obj

   set action_canvas $Page::($page_obj,action_canvas)
   set drag_elem_obj $sequence::($seq_obj,drag_blk_obj)
   set text_shift $Page::($page_obj,glob_text_shift)

   set texticon_id $sequence::($seq_obj,action_texticon)

  # Gets the icon and text ids based upon the current cursor location
   set objects [UI_PB_evt_GetCurrentCanvasObject $action_canvas texticon_id]
   $action_canvas coords [lindex $objects 0] \
        $event_element::($drag_elem_obj,xc) $event_element::($drag_elem_obj,yc)
   $action_canvas coords [lindex $objects 1] \
        [expr $event_element::($drag_elem_obj,xc) \
         + $text_shift] $event_element::($drag_elem_obj,yc)
}

#==========================================================================
# This procedure attaches the bind calls to the Add icon
#==========================================================================
proc UI_PB_evt_AddBindProcs { PAGE_OBJ } {
#==========================================================================
  upvar $PAGE_OBJ page_obj
  set top_canvas $Page::($page_obj,top_canvas)

  # Binds Enter of cursor to Add icon
    $top_canvas bind add_movable <Enter> "UI_PB_evt_AddFocusOn $top_canvas"

  # Binds Leave
    $top_canvas bind add_movable <Leave> "UI_PB_evt_AddFocusOff $top_canvas"

  # Binds First mouse button
    $top_canvas bind add_movable <1> "UI_PB_evt_AddStartDrag $page_obj \
                                                 %x %y"
  # Binds the First button motion
    $top_canvas bind add_movable <B1-Motion> "UI_PB_evt_AddDrag $page_obj \
                                                 %x %y"
  # Binds the release of first button
    $top_canvas bind add_movable <ButtonRelease-1> "UI_PB_evt_AddEndDrag \
                                                  $page_obj"
}

#==========================================================================
proc UI_PB_evt_AddUnBindProcs { PAGE_OBJ } {
#==========================================================================
  upvar $PAGE_OBJ page_obj
  set top_canvas $Page::($page_obj,top_canvas)

  # UnBinds Enter of cursor to Add icon
    $top_canvas bind add_movable <Enter> ""

  # UnBinds Leave
    $top_canvas bind add_movable <Leave> ""

  # UnBinds First mouse button
    $top_canvas bind add_movable <1> ""

  # UnBinds the First button motion
    $top_canvas bind add_movable <B1-Motion> ""

  # UnBinds the release of first button
    $top_canvas bind add_movable <ButtonRelease-1> ""
}

#==========================================================================
# This procedure is called whenever the cursor enters the
# Add icon
#==========================================================================
proc UI_PB_evt_AddFocusOn {top_canvas} {
#==========================================================================
  global paOption

  # Highlight current icon by changing the background color 
  # of the icon
    set im [$top_canvas itemconfigure current -image]
    [lindex $im end] configure -background $paOption(focus)


# Change cursor
set c $top_canvas
$c config -cursor hand2
}

#==========================================================================
# This proecedure is called whenever the cursor leves the Add icon
#==========================================================================
proc UI_PB_evt_AddFocusOff {top_canvas} {
#==========================================================================
  global paOption

  # Unhighlight current icon by changing the bacground color  of
  # icon to its original color
    set im [$top_canvas itemconfigure current -image]
    [lindex $im end] configure -background $paOption(app_butt_bg)


# Change cursor
set c $top_canvas
$c config -cursor ""
}

#==========================================================================
# This procedure is called upon the clicking the 
# first mouse button on the Add icon.
#==========================================================================
proc UI_PB_evt_AddStartDrag {page_obj x y} {
#==========================================================================
   global paOption
   global tixOption
   global CB_Block_Name

   # Gets the Sequence objects based upon the selected
   # Sequence.
     UI_PB_evt_GetSequenceIndex page_obj seq_index
     set seq_obj [lindex $Page::($page_obj,seq_obj_list) $seq_index]
     set sequence::($seq_obj,comb_var) $CB_Block_Name

    set top_canvas $Page::($page_obj,top_canvas)
    set bot_canvas $Page::($page_obj,bot_canvas)

  # Top canvas height
    set panel_hi $Page::($page_obj,panel_hi)
    set t_shift $Page::($page_obj,glob_text_shift)

  # Draws icon in the top canvas
    set xt [$top_canvas canvasx $x]
    set yt [$top_canvas canvasy $y]

  # Creates the new block icon in the top canvas
    set icon1 [UI_PB_blk_CreateIcon $top_canvas pb_block ""]

    set icon_top [$top_canvas create image $xt $yt \
                         -image $icon1]
   # Creates the text widget
    set icon_top_text [$top_canvas create text [expr $xt + $t_shift] \
             $yt -text $sequence::($seq_obj,comb_var) \
                 -font $tixOption(bold_font)]

   # configures the icon backgorund
    $icon1 config -bg $paOption(butt_bg)

   # Stores the icon id and its text id
    set sequence::($seq_obj,icon_top) $icon_top
    set sequence::($seq_obj,icon_top_text) $icon_top_text

  # Creates new block icon in the bottom canvas
    set xb [$bot_canvas canvasx $x]
    set yb [$bot_canvas canvasy [expr $y - $panel_hi - 2]]

    set icon2 [UI_PB_blk_CreateIcon $bot_canvas pb_block ""]
    set icon_bot [$bot_canvas create image $xb $yb \
                        -image $icon2]
    set icon_bot_text [$bot_canvas create text [expr $xb + $t_shift] \
             $yb  -text $sequence::($seq_obj,comb_var) \
                  -font $tixOption(bold_font)]

    $icon2 config -bg $paOption(butt_bg)
    set sequence::($seq_obj,icon_bot) $icon_bot
    set sequence::($seq_obj,icon_bot_text) $icon_bot_text
}

#==========================================================================
# This procedure is triggered, when the cursor is moved by
# pressing the first mouse button on the add block
#==========================================================================
proc UI_PB_evt_AddDrag {page_obj x y} {
#==========================================================================
   set top_canvas $Page::($page_obj,top_canvas)
   set bot_canvas $Page::($page_obj,bot_canvas)

   UI_PB_evt_GetSequenceIndex page_obj seq_index
   set seq_obj [lindex $Page::($page_obj,seq_obj_list) $seq_index]

   set xx [$top_canvas canvasx $x]
   set yy [$top_canvas canvasy $y]

  # Translates the icon in top canvas
   $top_canvas coords $sequence::($seq_obj,icon_top) $xx $yy
   $top_canvas coords $sequence::($seq_obj,icon_top_text) $xx $yy

   set panel_hi $Page::($page_obj,panel_hi)
   set dy [expr $panel_hi + 2]
   set xx [$bot_canvas canvasx $x]
   set yy [$bot_canvas canvasy [expr $y - $dy]]

  # Translates the block icon in bottom canvas
   $bot_canvas coords $sequence::($seq_obj,icon_bot) $xx $yy
   $bot_canvas coords $sequence::($seq_obj,icon_bot_text) $xx $yy

  # Gets the Event object, based upon the current cursor location.
   UI_PB_evt_GetEventObjFromCurPos page_obj seq_obj $xx $yy

  # Highlights the seperators of block templates, based on
  # the cursor location
   UI_PB_evt_HighLightSep page_obj seq_obj $xx $yy
}

#========================================================================
# This procedure returns the Event object based upon the location
# of the cursor.
#=========================================================================
proc UI_PB_evt_GetEventObjFromCurPos {PAGE_OBJ SEQ_OBJ x y} {
#==========================================================================
   upvar $PAGE_OBJ page_obj
   upvar $SEQ_OBJ seq_obj

   set evt_dim_height [lindex $Page::($page_obj,glob_evnt_dim) 1] 
   set evt_evtdist $Page::($page_obj,glob_evt_evtdist)
   set flag 0

  # Cycles through events of a Sequence, matching the cursor
  # coordinates with the Event range. (Right upper corner of Event to the
  # right lower corner of the last block of the event)
   foreach evt_obj $sequence::($seq_obj,evt_obj_list) \
   {
     if {$y > [expr $event::($evt_obj,yc) - [expr $evt_dim_height / 2] \
         - [expr $evt_evtdist / 2]] && $y < \
         [expr $event::($evt_obj,event_height) - [expr $evt_dim_height / 2] \
         - [expr $evt_evtdist / 2]] } \
     {
          set sequence::($seq_obj,add_blkto_evt_obj) $evt_obj
          set flag 1
          break
     }

   }

   if {$flag == 0} \
   {
       if {[info exists sequence::($seq_obj,add_blkto_evt_obj)]} \
       {
           unset sequence::($seq_obj,add_blkto_evt_obj)
       }
   }
}

#=========================================================================
proc UI_PB_evt_HighLightRowOfEvent { PAGE_OBJ SEQ_OBJ EVT_OBJ COUNT } {
#=========================================================================
  upvar $PAGE_OBJ page_obj
  upvar $SEQ_OBJ seq_obj
  upvar $EVT_OBJ evt_obj
  upvar $COUNT count
  global paOption

  set bot_canvas $Page::($page_obj,bot_canvas)

  # If the cursor is within the upper right corner and the
  # lower left corner of the block template. It highlights
  # the two seperators and the rectangle.
    set rect_id [lindex $event::($evt_obj,rect_id) $count]
    $bot_canvas itemconfigure $rect_id -outline $paOption(focus) \
                   -fill $paOption(focus)
 
   set temp_sep [lindex $event::($evt_obj,sep_id) $count]
   set sep_id1 [lindex $temp_sep 0]
   set sep_id2 [lindex $temp_sep 1]
   $bot_canvas itemconfigure $sep_id1 -outline $paOption(focus)
   $bot_canvas itemconfigure $sep_id2 -outline $paOption(focus)
   lappend list_ids $rect_id $sep_id1 $sep_id2
   set sequence::($seq_obj,focus_rect) $list_ids
   set sequence::($seq_obj,add_blk) "row"
   set sequence::($seq_obj,blk_temp) $count
}

#=========================================================================
proc UI_PB_evt_AvoidHighLightRow { SEQ_OBJ ACTIVE_EVT_OBJ COUNT } {
#=========================================================================
  upvar $SEQ_OBJ seq_obj
  upvar $ACTIVE_EVT_OBJ active_evt_obj
  upvar $COUNT count

  # To avoid highligting the row of a dragged block 
    if {[info exists sequence::($seq_obj,drag_evt_obj)]} \
    {
        if {$sequence::($seq_obj,drag_evt_obj) == $active_evt_obj \
             && $sequence::($seq_obj,drag_row) == $count} \
        {
           set sequence::($seq_obj,add_blk) 0
           set sequence::($seq_obj,blk_temp) 0
           return 1
        } else \
        {
           return 0
        }
    } else \
    {
       return 0
    }
}

#=========================================================================
proc UI_PB_evt_AvoidHighLightTopOrBottomSep { SEQ_OBJ ACTIVE_EVT_OBJ COUNT } {
#=========================================================================
  upvar $SEQ_OBJ seq_obj
  upvar $ACTIVE_EVT_OBJ active_evt_obj
  upvar $COUNT count

  # To avoid highligting the top seperator, if there is
  # is only one block in the row, and if that block itself
  # is draged.
    if {[info exists sequence::($seq_obj,drag_evt_obj)]} \
    {
       set drag_evt_obj $sequence::($seq_obj,drag_evt_obj)
       set drag_row $sequence::($seq_obj,drag_row)
       set temp_length \
       [llength [lindex $event::($drag_evt_obj,evt_elem_list) $drag_row]]
       if {$drag_evt_obj == $active_evt_obj && \
           $drag_row == $count && $temp_length == 1} \
       {
           return 1
       } else \
       {
           return 0
       }
    } else \
    {
       return 0
    }
}

#=========================================================================
proc UI_PB_evt_HighLightTopSeperator { PAGE_OBJ SEQ_OBJ EVT_OBJ COUNT } {
#=========================================================================
   upvar $PAGE_OBJ page_obj
   upvar $SEQ_OBJ seq_obj
   upvar $EVT_OBJ evt_obj
   upvar $COUNT count
   global paOption

   set bot_canvas $Page::($page_obj,bot_canvas)

   set temp_sep [lindex $event::($evt_obj,sep_id) $count]
   set sep_id [lindex $temp_sep 0]
   set sequence::($seq_obj,focus_sep) $sep_id
   $bot_canvas itemconfigure $sep_id -outline $paOption(focus)
   set sequence::($seq_obj,add_blk) "top"
   set sequence::($seq_obj,blk_temp) $count
}

#=========================================================================
proc UI_PB_evt_HighLightBottomSeperator { PAGE_OBJ SEQ_OBJ EVT_OBJ COUNT } {
#=========================================================================
  upvar $PAGE_OBJ page_obj
  upvar $SEQ_OBJ seq_obj
  upvar $EVT_OBJ evt_obj
  upvar $COUNT count
  global paOption

  set bot_canvas $Page::($page_obj,bot_canvas)

  set temp_sep [lindex $event::($evt_obj,sep_id) $count]
  set sep_id [lindex $temp_sep 1]
  set sequence::($seq_obj,focus_sep) $sep_id
  $bot_canvas itemconfigure $sep_id -outline $paOption(focus)
  set sequence::($seq_obj,add_blk) "bottom"
  set sequence::($seq_obj,blk_temp) $count
}

#=========================================================================
# This procedure Highlights the seperators of the block template (row) and
# the row itself, based upon the position of the cursor.
#==========================================================================
proc UI_PB_evt_HighLightSep {PAGE_OBJ SEQ_OBJ x y} {
#==========================================================================
  upvar $PAGE_OBJ page_obj
  upvar $SEQ_OBJ seq_obj
  global paOption

  set region $sequence::($seq_obj,region)
  set blk_dim_height [lindex $Page::($page_obj,glob_blk_dim) 1]
  set bot_canvas $Page::($page_obj,bot_canvas)
  set rect_gap $Page::($page_obj,glob_rect_gap)

 # Unhighlights the rectangle and two seperators
   UI_PB_evt_UnHighlightSeperators $bot_canvas seq_obj

 # Checks for an event, to which the block has to be added
  if {[info exists sequence::($seq_obj,add_blkto_evt_obj)]} \
  {
      # Gets the selected event to which block has to be added
        set active_evt_obj $sequence::($seq_obj,add_blkto_evt_obj)

      # Gets the no of block template rows    
        set no_rows $event::($active_evt_obj,block_nof_rows)
        set event_width $event::($active_evt_obj,event_width)
        set event_xc $event::($active_evt_obj,xc)

     if {$no_rows > 0} \
     {
        for {set count 0} {$count < $no_rows} {incr count} \
        {
           set row_elem_objs [lindex $event::($active_evt_obj,evt_elem_list) \
                                $count]
           set elem_obj [lindex $row_elem_objs 0]
           set yc $event_element::($elem_obj,yc)

           # To Highlight the rectangle
            if {$y > [expr $yc - [expr $blk_dim_height / 2]] && \
                $y < [expr $yc + [expr $blk_dim_height / 2]] && \
                $x > [expr $event_xc - $region] && \
                $x < [expr $event_xc + $event_width + $region]} \
            {
                set high_flag [UI_PB_evt_AvoidHighLightRow seq_obj \
                                                   active_evt_obj count]
                if {$high_flag} { return }

                UI_PB_evt_HighLightRowOfEvent page_obj seq_obj \
                                                   active_evt_obj count
                break

           # To Highlight the top seperator.
            } elseif {$y > [expr $yc - [expr $blk_dim_height / 2] - \
                           [expr 3 * $rect_gap]] && \
                      $y < [expr $yc - [expr $blk_dim_height / 2]] && \
                      $x > [expr $event_xc - $region] && \
                      $x < [expr $event_xc + $event_width + $region]} \
            {
                set high_flag [UI_PB_evt_AvoidHighLightTopOrBottomSep seq_obj \
                                                         active_evt_obj count]
                if {$high_flag} { return }

                UI_PB_evt_HighLightTopSeperator page_obj seq_obj \
                                                      active_evt_obj count
                break

           # To HighLight the bottom Seperato.
            } elseif {$y > [expr $yc + [expr $blk_dim_height / 2]] && \
                      $y < [expr $yc + [expr $blk_dim_height / 2] + \
                           [expr 3 * $rect_gap]] && \
                      $x > [expr $event_xc - $region] && \
                      $x < [expr $event_xc + $event_width + $region]} \
            {
                set high_flag [UI_PB_evt_AvoidHighLightTopOrBottomSep seq_obj \
                                                          active_evt_obj count]
                if {$high_flag} { return }

                UI_PB_evt_HighLightBottomSeperator page_obj seq_obj \
                                                       active_evt_obj count
                break
            } else \
            {
                set sequence::($seq_obj,add_blk) 0
                set sequence::($seq_obj,blk_temp) 0
            }
        }
      # If the event has got zero no of block templates (rows)
      } elseif {$no_rows == 0} \
      {
          set yc $event::($active_evt_obj,yc)
    
          if {$y > [expr $yc - [expr $blk_dim_height / 2]] && \
              $y < [expr $yc + [expr $blk_dim_height / 2]] && \
              $x > [expr $event_xc - $region] && \
              $x < [expr $event_xc + $event_width + $region]} \
          {
              set rect_id [lindex $event::($active_evt_obj,rect_id) 0]
              $bot_canvas itemconfigure $rect_id -outline $paOption(focus) \
                          -fill $paOption(focus)
              lappend list_ids $rect_id 
              set sequence::($seq_obj,focus_rect) $list_ids
              set sequence::($seq_obj,add_blk) "top"
          }
      }
  } else \
  {
      set sequence::($seq_obj,add_blk) 0
      set sequence::($seq_obj,blk_temp) 0
  }
}

#==========================================================================
proc UI_PB_evt_DeleteTemporaryIcons { PAGE_OBJ SEQ_OBJ } {
#==========================================================================
  upvar $PAGE_OBJ page_obj
  upvar $SEQ_OBJ seq_obj

  set top_canvas $Page::($page_obj,top_canvas)
  set bot_canvas $Page::($page_obj,bot_canvas)

  # Deletes the temporary iocn created in the top canvas
  # for drag and drop.
   if {$sequence::($seq_obj,icon_top) != 0} \
   {
      $top_canvas delete $sequence::($seq_obj,icon_top)
      set sequence::($seq_obj,icon_top) 0
      $top_canvas delete $sequence::($seq_obj,icon_top_text)
      set sequence::($seq_obj,icon_top_text) 0
   }

  # Deletes the temporary iocn created in the bottom canvas
  # for drag and drop.
   if {$sequence::($seq_obj,icon_bot) != 0} \
   {
       $bot_canvas delete $sequence::($seq_obj,icon_bot)
       set sequence::($seq_obj,icon_bot) 0
       $bot_canvas delete $sequence::($seq_obj,icon_bot_text)
       set sequence::($seq_obj,icon_bot_text) 0
   }
}

#==========================================================================
# This proceduer is triggered, when the first mouse button holding
# the add block is released.
#==========================================================================
proc UI_PB_evt_AddEndDrag {page_obj} {
#==========================================================================
  global paOption
  
  set bot_canvas $Page::($page_obj,bot_canvas)
  UI_PB_evt_GetSequenceIndex page_obj seq_index
  set seq_obj [lindex $Page::($page_obj,seq_obj_list) $seq_index]

  UI_PB_evt_DeleteTemporaryIcons page_obj seq_obj

  # Checks for the event at the cursor location. if it didnot
  # find a event it does nothing.
   if {![info exists sequence::($seq_obj,add_blkto_evt_obj)]} \
   {
       return
   }

  # Unhighlightes the highlighted seperators
   UI_PB_evt_UnHighlightSeperators $bot_canvas seq_obj

   set active_evt_obj $sequence::($seq_obj,add_blkto_evt_obj)

  # Checks for the status of the Event.
   if {[string compare $event::($active_evt_obj,col_image) "minus"] == 0} \
   {
      set new_elem_name $sequence::($seq_obj,comb_var)

      if { [string compare $new_elem_name "New Block"] == 0 } \
      {
         set active_evt_name $event::($active_evt_obj,event_name)
         set new_elem_name "new_block"
         set new_blk_elem_list ""
         PB_int_CreateNewBlock new_elem_name new_blk_elem_list \
                               active_evt_name new_block_obj
         
      } else \
      {
         set temp_name [split $new_elem_name " "]
         set new_elem_name [join $temp_name "_"]
         set new_elem_name [string tolower $new_elem_name]
      }

      set elem_type "normal"
      PB_int_GetNewEventElement active_evt_obj new_elem_name \
                                elem_type elem_obj
      UI_PB_evt_AddBlockToEvent page_obj seq_obj elem_obj

     # Add a new Block to the Sequence
      if { [string compare $new_elem_name "new_block"] == 0  && \
            $sequence::($seq_obj,add_blk) != 0 } \
      {
         set blk_img_id $event_element::($elem_obj,icon_id)
         set img [lindex [$bot_canvas itemconfigure $blk_img_id -image] end]
         $img config -relief sunken -bg pink

         update 
         set canvas_frame $Page::($page_obj,canvas_frame)
         
         # Gets the unique block name
           UI_PB_com_ReturnBlockName active_evt_obj new_block_name
           set block::($new_block_obj,block_name) $new_block_name


    UI_PB_evt__DisplayBlockPage $page_obj $seq_obj $new_block_obj $elem_obj


##         UI_PB_blk_CreateBlockPage new_block_obj canvas_frame new_blkpg_obj
##         UI_PB_blk_NewBlkActionButtons new_blkpg_obj page_obj seq_obj \
                                       active_evt_obj elem_obj
      }
   }
   set sequence::($seq_obj,add_blk) 0
}

#=========================================================================
proc UI_PB_evt_AddBlockToEvent { PAGE_OBJ SEQ_OBJ ELEM_OBJ } {
#=========================================================================
  upvar $PAGE_OBJ page_obj
  upvar $SEQ_OBJ seq_obj
  upvar $ELEM_OBJ elem_obj

  # Based upon the selection, it adds the block to a template, 
  # or above the selected templated or below a block template
    switch $sequence::($seq_obj,add_blk) \
    {
      "row" \
       {
          set blk_exists_flag [UI_PB_evt_CheckBlkInTemplate seq_obj elem_obj]

          # Checks for the existance of new block in the block template.
          # if it exists it popups an error message.
            if {$blk_exists_flag} \
            {
               set block_obj $event_element::($elem_obj,block_obj)
               set block_name $block::($block_obj,block_name)
               tk_messageBox -type ok -icon error \
                    -message "Block $block_name exists in the Block Template"
               return
            }

            UI_PB_evt_AddBlkToARow page_obj seq_obj elem_obj
       }
       "top" \
        {
            UI_PB_evt_AddBlkAboveOrBelow page_obj seq_obj elem_obj
        }
        "bottom" \
        {
            UI_PB_evt_AddBlkAboveOrBelow page_obj seq_obj elem_obj
        }
    }
}

#=========================================================================
# This procedure returns a value based upon the  existance of the 
# new block in the block template (row). If the new block exists
# in the template it returns 1 else it returns 0.
#==========================================================================
proc UI_PB_evt_CheckBlkInTemplate {SEQ_OBJ NEW_ELEM_OBJ} {
#==========================================================================
  upvar $SEQ_OBJ seq_obj
  upvar $NEW_ELEM_OBJ new_elem_obj

  set block_obj $event_element::($new_elem_obj,block_obj)
  set new_block_name $block::($block_obj,block_name)

  set active_evt_obj $sequence::($seq_obj,add_blkto_evt_obj)
  set blk_temp_no $sequence::($seq_obj,blk_temp)
  set row_elements [lindex $event::($active_evt_obj,evt_elem_list) \
                                  $blk_temp_no]
  set blk_exists 0

 # Cycles through the block objects
  foreach elem_obj $row_elements \
  {
      set block_obj $event_element::($elem_obj,block_obj)
      set temp_blk_name $block::($block_obj,block_name)
      if {[string compare $temp_blk_name $new_block_name] == 0} \
      {
         set blk_exists 1
         break
      }
  }

  if {$blk_exists} \
  {
    return 1
  } else \
  {
    return 0
  }
}

#=========================================================================
# This procedure unhighlights the block template seperators, 
# if they are highlited.
#==========================================================================
proc UI_PB_evt_UnHighlightSeperators {bot_canvas SEQ_OBJ} {
#==========================================================================
   upvar $SEQ_OBJ seq_obj
   global paOption

  # Unhighlights the top or bottom seperators.
  # If a block is added above or below the template
   if {$sequence::($seq_obj,focus_sep) != 0} \
   {
       $bot_canvas itemconfigure $sequence::($seq_obj,focus_sep) \
                -outline $paOption(can_bg) 
       set sequence::($seq_obj,focus_sep) 0
   }

  # Unhighlights the top, bottom and the rect. 
  # If the block is added to the row itself
   if {$sequence::($seq_obj,focus_rect) != 0} \
   {
      set length [llength $sequence::($seq_obj,focus_rect)]

      set rect_id [lindex $sequence::($seq_obj,focus_rect) 0]
      $bot_canvas itemconfigure $rect_id -outline $paOption(can_bg) \
                   -fill $paOption(can_bg)

      if {$length > 1} \
      {
          set sep_id1 [lindex $sequence::($seq_obj,focus_rect) 1]
          $bot_canvas itemconfigure $sep_id1 -outline $paOption(can_bg)

          set sep_id2 [lindex $sequence::($seq_obj,focus_rect) 2]
          $bot_canvas itemconfigure $sep_id2 -outline $paOption(can_bg)
       }
    }
}

#==========================================================================
# This procedure adds the new element to the existing block
# template (row).
#==========================================================================
proc UI_PB_evt_AddBlkToARow {PAGE_OBJ SEQ_OBJ ELEM_OBJ} {
#==========================================================================
  upvar $PAGE_OBJ page_obj
  upvar $SEQ_OBJ seq_obj
  upvar $ELEM_OBJ elem_obj

 # Gets the bottom canvas id and the dimensions of the block.
   set bot_canvas $Page::($page_obj,bot_canvas)
   set blk_blkdist $Page::($page_obj,glob_blk_blkdist_hor)
   set blk_dim_width [lindex $Page::($page_obj,glob_blk_dim) 0]

 # Gets the event object, to which an new block has to be added.
   set active_evt_obj $sequence::($seq_obj,add_blkto_evt_obj)

 # gets the row number i.e block template
  set blk_temp_no $sequence::($seq_obj,blk_temp)

 # Gets the block list of the template
  set row_elem_list [lindex $event::($active_evt_obj,evt_elem_list) \
                           $blk_temp_no]
  set last_elem_obj [lindex $row_elem_list end]

  set x1 $event_element::($last_elem_obj,xc)
  set elem_xc [expr $event_element::($last_elem_obj,xc) + $blk_blkdist + \
                                 $blk_dim_width]
  set elem_yc $event_element::($last_elem_obj,yc)
  
 # Appends the new block to the selected block template
  lappend row_elem_list $elem_obj 
  set event::($active_evt_obj,evt_elem_list) [lreplace \
            $event::($active_evt_obj,evt_elem_list) $blk_temp_no \
            $blk_temp_no $row_elem_list]
  
  set event_element::($elem_obj,xc) $elem_xc
  set event_element::($elem_obj,yc) $elem_yc

 # creates the new block
  UI_PB_evt_CreateEventElement page_obj seq_obj elem_obj

  set line_id [UI_PB_evt_CreateLine bot_canvas $x1 $elem_yc \
                      $elem_xc $elem_yc]
  set event_element::($elem_obj,line_id) $line_id 

 # Deletes all the seperators of the templates and recreates
 # them.
  $bot_canvas delete [lindex $event::($active_evt_obj,rect_id) \
                             $blk_temp_no]

  set sep_list [lindex $event::($active_evt_obj,sep_id) \
                       $blk_temp_no]

   $bot_canvas delete [lindex $sep_list 0]
   $bot_canvas delete [lindex $sep_list 1]

  set temp_ids [UI_PB_evt_CreateARowTempRect page_obj active_evt_obj \
                                 blk_temp_no]

  set rect_sep [lindex $temp_ids 0]
  set event::($active_evt_obj,rect_id) \
       [lreplace $event::($active_evt_obj,rect_id) \
                   $blk_temp_no $blk_temp_no $rect_sep]

  set sep_list [lrange $temp_ids 1 end]
  set event::($active_evt_obj,sep_id) \
         [lreplace $event::($active_evt_obj,sep_id) \
                   $blk_temp_no $blk_temp_no $sep_list]
}

#==========================================================================
# This procedure is called for adding a new block, above or
# below the selected block template.
#==========================================================================
proc UI_PB_evt_AddBlkAboveOrBelow {PAGE_OBJ SEQ_OBJ NEW_ELEM_OBJ} {
#==========================================================================
  upvar $PAGE_OBJ page_obj
  upvar $SEQ_OBJ seq_obj
  upvar $NEW_ELEM_OBJ new_elem_obj

  # Gets the selected event and the block template no.
   set active_evt_obj $sequence::($seq_obj,add_blkto_evt_obj)
   set blk_tempno $sequence::($seq_obj,blk_temp)

  # Total no of block templates in the event.
   set no_of_templates $event::($active_evt_obj,block_nof_rows)

  # Deletes all the blocks of the events
   UI_PB_evt_DeleteEventElements page_obj seq_obj active_evt_obj
  
  # if the new block has to be added below the selected templated
  # block, it increments the block template number.
   switch $sequence::($seq_obj,add_blk) \
   {
      "bottom" \
       {
          incr blk_tempno
       }
   }
  
   for {set count 0} {$count < $blk_tempno} {incr count} \
   {
      set temp_list [lindex $event::($active_evt_obj,evt_elem_list) $count]
      lappend elem_obj_list $temp_list
   }

   lappend elem_obj_list $new_elem_obj

  # Realigns all the template blocks in sequence.
   for {set count $blk_tempno} {$count < $no_of_templates} \
                                  {incr count} \
   {
      set temp_list [lindex $event::($active_evt_obj,evt_elem_list) $count]
      lappend elem_obj_list $temp_list
   }
 
   set event::($active_evt_obj,evt_elem_list) $elem_obj_list
   unset elem_obj_list
   set event::($active_evt_obj,block_nof_rows) [expr $no_of_templates + 1]

  # Creates all the blocks of a event
   UI_PB_evt_CreateElementsOfEvent page_obj seq_obj active_evt_obj 
 
   set active_evt_index [lsearch $sequence::($seq_obj,evt_obj_list) \
                          $active_evt_obj]

  # Transforms all other Events and blocks of there respective 
  # Events.
   UI_PB_evt_TransformEvtElem page_obj seq_obj active_evt_index
}

#=========================================================================
# This procedure creates the events and blocks of the non tool path
# Sequence
#=========================================================================
proc UI_PB_evt_CreateSeqEvent {PAGE_OBJ SEQ_OBJ TPTH_EVENT_FLAG} {
#=========================================================================
  upvar $PAGE_OBJ page_obj
  upvar $SEQ_OBJ seq_obj
  upvar $TPTH_EVENT_FLAG tpth_event_flag
   
   global tixOption
   global paOption
  
   set origin(0) 60
   set origin(1) 50

  # Gets the dimensions of Event and block icons
   set evt_dim_width [lindex $Page::($page_obj,glob_evnt_dim) 0]
   set evt_dim_height [lindex $Page::($page_obj,glob_evnt_dim) 1]
   set blk_dim_width [lindex $Page::($page_obj,glob_blk_dim) 0]
   set blk_dim_height [lindex $Page::($page_obj,glob_blk_dim) 1]

   set prev_evt_focus_cell $sequence::($seq_obj,evt_focus_cell)
   set prev_blk_focus_cell $sequence::($seq_obj,blk_focus_cell)

  # total no of events in the sequence.
   set no_of_events [llength $sequence::($seq_obj,evt_obj_list)]
   set bot_canvas $Page::($page_obj,bot_canvas)

  # calculates the center of first event.
   set evt_xc [expr [expr $origin(0) + $evt_dim_width] / 2]
   set evt_yc [expr [expr $origin(1) + $evt_dim_height] / 2]

  # unbinds the event procs
    UI_PB_evt_UnBindEvtProcs page_obj

   for {set evt_count 0} {$evt_count < $no_of_events} {incr evt_count} \
   {
      # Creates the Event Icon
       set evt_obj [lindex $sequence::($seq_obj,evt_obj_list) $evt_count]
       set event::($evt_obj,xc) $evt_xc
       set event::($evt_obj,yc) $evt_yc
       set event::($evt_obj,col_image) "minus"
       UI_PB_evt_CreateEvent page_obj seq_obj evt_obj
    
      # Creates Blocks of a Event
       if {$tpth_event_flag == 0} \
       {
          UI_PB_evt_CreateElementsOfEvent page_obj seq_obj evt_obj 
       } else \
       {
          UI_PB_evt_CreateElemOfTpthEvent page_obj seq_obj evt_obj
       }
       set evt_yc $event::($evt_obj,event_height)
   }

    $bot_canvas bind col_movable <1> "UI_PB_evt_CollapseAEvent $page_obj \
                                     $seq_obj %x %y"
}

#=========================================================================
# This proecedure deletes all the events and its blocks of a
# specified sequence.
#=========================================================================
proc UI_PB_evt_DeleteSeqEvents  {PAGE_OBJ SEQ_OBJ} {
#=========================================================================
   upvar $PAGE_OBJ page_obj
   upvar $SEQ_OBJ seq_obj

   set bot_canvas $Page::($page_obj,bot_canvas)

  # Cycles through all the events of a sequence
    foreach evt_obj $sequence::($seq_obj,evt_obj_list) \
    {
       # Deletes the event
         UI_PB_evt_DeleteAEvent $bot_canvas seq_obj evt_obj
 
       # Deletes all the blocks
         UI_PB_evt_DeleteEventElements page_obj seq_obj evt_obj
    }
}

#=========================================================================
# This proecedure creates a Collapse icon for an Event.
#=========================================================================
proc UI_PB_evt_CreateCollapseIcon {PAGE_OBJ SEQ_OBJ EVT_OBJ} {
#=========================================================================
  upvar $PAGE_OBJ page_obj
  upvar $SEQ_OBJ seq_obj
  upvar $EVT_OBJ evt_obj

  # Gets the image name of collapse from the library
    set image_name $event::($evt_obj,col_image)

  # Gets the center and dimensions of the Event.
    set icon_xc $event::($evt_obj,xc)
    set icon_yc $event::($evt_obj,yc)
    set evt_dim_width [lindex $Page::($page_obj,glob_evnt_dim) 0]
    set bot_canvas $Page::($page_obj,bot_canvas)

  # Creates the collapse icon and stores the icon id and
  # its center as attributes of event.
    set col_img_id [UI_PB_blk_CreateIcon $bot_canvas $image_name ""]

   set xc [expr [expr $icon_xc - [expr $evt_dim_width / 2]] - 15]
   set yc $icon_yc
   set icon_id [$bot_canvas create image $xc $yc \
                      -image $col_img_id -tag col_movable]
   set event::($evt_obj,col_icon_id) $icon_id
}

#==========================================================================
# This procedure returns the flag, as 1 if the block is displayed with the
# NC code and 0 if the block is displayed with the block name.
#==========================================================================
proc UI_PB_evt_RetBlkTypeFlag { PAGE_OBJ } {
#==========================================================================
  upvar $PAGE_OBJ page_obj
  global mom_sys_arr

  if {$Page::($page_obj,prev_seq) == 0 || $Page::($page_obj,prev_seq) == 1 || \
      $Page::($page_obj,prev_seq) == 3 || $Page::($page_obj,prev_seq) == 4} \
  {
       switch $Page::($page_obj,prev_seq) \
      {
         0  { set flag $mom_sys_arr(\$pgss_blk_nc) }
         1  { set flag $mom_sys_arr(\$pges_blk_nc) }
         3  { set flag $mom_sys_arr(\$opss_blk_nc) }
         4  { set flag $mom_sys_arr(\$opes_blk_nc) }
      }
  } else \
  {
      set flag 1
  }
  return $flag
}

#==========================================================================
# This procedure is called, when the first mouse button is
# clicked on the collapse icon.
# It collapses a event by deleting all the blocks of the event.
#==========================================================================
proc UI_PB_evt_CollapseAEvent {page_obj seq_obj x y} {
#==========================================================================
  global paOption

  set bot_canvas $Page::($page_obj,bot_canvas)
  set yy [$bot_canvas canvasy $y]

  # Gets the no of events in the sequence.
    set no_of_events [llength $sequence::($seq_obj,evt_obj_list)]

  # Based upon the cursor location, it gets the event object
  # index.
   for {set count 0} {$count < $no_of_events} {incr count} \
   {
        set evt_obj [lindex $sequence::($seq_obj,evt_obj_list) $count]
        if {$yy > [expr $event::($evt_obj,yc) - 10] && \
            $yy < [expr $event::($evt_obj,yc) + 10]} \
        {
            set evnt_index $count
        }
   }
  
  # Based upon the event index it gets the event object
   set evt_obj [lindex $sequence::($seq_obj,evt_obj_list) $evnt_index]

   set xc $event::($evt_obj,xc)
   set yc $event::($evt_obj,yc)
   set evt_evtdist $Page::($page_obj,glob_evt_evtdist)
   set evt_dim_height [lindex $Page::($page_obj,glob_evnt_dim) 1]

  # It checks whether the collapse image is minus or plus.
  # if it is minus it deletes all the blocks and transforms
  # all the other events to top. Else if it is plus, it creates
  # all the blocks and trasforms other events to down.

  set tpth_flag [UI_PB_evt_RetBlkTypeFlag page_obj]
  if {[string compare $event::($evt_obj,col_image) "minus"] == 0} \
  {
      # Checks for the no of block templates in an event.
      # if the no of block templates are zero, it does nothing
       if {$event::($evt_obj,block_nof_rows) == 0} \
       {
          return
       }
     
     if {$tpth_flag} \
     {
       # sets the height of the event.
        set event::($evt_obj,event_height) [expr $yc + $evt_evtdist + \
                                           [expr $evt_dim_height / 2]]
        $bot_canvas delete $event::($evt_obj,blk_text)
        $bot_canvas delete $event::($evt_obj,blk_rect)
     } else \
     {
        # sets the height of the event.
          set event::($evt_obj,event_height) [expr $yc + $evt_evtdist + \
                                              $evt_dim_height]
     }

     # Deletes all the blocks of an event
      UI_PB_evt_DeleteEventElements page_obj seq_obj evt_obj
     
      $bot_canvas delete $event::($evt_obj,col_icon_id)
      set event::($evt_obj,col_image) "plus"

  } elseif {[string compare $event::($evt_obj,col_image) "plus"] == 0} {

     # Creates the blocks of an event.
      if {$tpth_flag} \
      {
        UI_PB_evt_CreateElemOfTpthEvent page_obj seq_obj evt_obj
      } else \
      {
        UI_PB_evt_CreateElementsOfEvent page_obj seq_obj evt_obj
      }

      $bot_canvas delete $event::($evt_obj,col_icon_id)
      set event::($evt_obj,col_image) "minus"
  }
   # replaces the collapse icon with plus
     UI_PB_evt_CreateCollapseIcon page_obj seq_obj evt_obj

   # Transforms other events
     if {$event::($evt_obj,block_nof_rows) > 1} \
     {
        UI_PB_evt_TransformEvtElem page_obj seq_obj evnt_index
     }
}

#==========================================================================
# This procedure delets all the attributes of an Event.
#==========================================================================
proc UI_PB_evt_DeleteAEvent {bot_canvas SEQ_OBJ EVT_OBJ} {
#==========================================================================
   upvar $SEQ_OBJ seq_obj
   upvar $EVT_OBJ evt_obj

  # Deletes the icon
   $bot_canvas delete $event::($evt_obj,icon_id)
  # Deletes the text widget
   $bot_canvas delete $event::($evt_obj,text_id)
  # Deletes the collapse icon
   $bot_canvas delete $event::($evt_obj,col_icon_id)
  # Deletes the rectangle (drawn for 3D effect)
   $bot_canvas delete $event::($evt_obj,evt_rect)

  # Removes the icon id and text id from the texticon list
   set index [lsearch $sequence::($seq_obj,texticon_ids) \
                      $event::($evt_obj,text_id)]
   if {$index != -1} \
   {
      set sequence::($seq_obj,texticon_ids) \
      [lreplace $sequence::($seq_obj,texticon_ids) $index [expr $index + 1]]
   }

   if {[info exists event::($evt_obj,blk_text)]} \
   {
       $bot_canvas delete $event::($evt_obj,blk_text)
   }

   if {[info exists event::($evt_obj,blk_rect)]} \
   {
       $bot_canvas delete $event::($evt_obj,blk_rect)
   }
}

#==========================================================================
# Transforms all the events and its blocks from the specified
# Event object index.
#==========================================================================
proc UI_PB_evt_TransformEvtElem {PAGE_OBJ SEQ_OBJ EVNT_INDEX} {
#==========================================================================
  upvar $PAGE_OBJ page_obj
  upvar $SEQ_OBJ seq_obj
  upvar $EVNT_INDEX evnt_index

  # all the event dimensions
   set evt_evtdist $Page::($page_obj,glob_evt_evtdist)
   set bot_canvas $Page::($page_obj,bot_canvas)
   set evt_dim_height [lindex $Page::($page_obj,glob_evnt_dim) 1]
   set evt_evtdis $Page::($page_obj,glob_evt_evtdist)
   set no_of_events [llength $sequence::($seq_obj,evt_obj_list)]
   
  set tpth_flag [UI_PB_evt_RetBlkTypeFlag page_obj]

  # Cycles through the Events and delets an event and its blocks
  # It cycles from the specified index.
   for {set count [expr $evnt_index + 1]} {$count < $no_of_events} \
              {incr count} \
   {
       set evt_obj [lindex $sequence::($seq_obj,evt_obj_list) $count]
      # Deletes the event
        UI_PB_evt_DeleteAEvent $bot_canvas seq_obj evt_obj

      # Deletes all the blocks
        UI_PB_evt_DeleteEventElements page_obj seq_obj evt_obj
   }

   set ind_evt_obj [lindex $sequence::($seq_obj,evt_obj_list) $evnt_index]
   set evt_xc $event::($ind_evt_obj,xc)
   set evt_yc $event::($ind_evt_obj,event_height)

   for {set count [expr $evnt_index + 1]} {$count < $no_of_events} \
              {incr count} \
   {
      # Creates the Event Icon
       set evt_obj [lindex $sequence::($seq_obj,evt_obj_list) $count]
       set event::($evt_obj,xc) $evt_xc
       set event::($evt_obj,yc) $evt_yc
       UI_PB_evt_CreateEvent page_obj seq_obj evt_obj

      # Create Blocks of a Event
       if {[string compare $event::($evt_obj,col_image) "minus"] == 0} \
       {
          if {$tpth_flag} \
          {
              UI_PB_evt_CreateElemOfTpthEvent page_obj seq_obj evt_obj 
          } else \
          {
              UI_PB_evt_CreateElementsOfEvent page_obj seq_obj evt_obj 
          }
          set evt_yc $event::($evt_obj,event_height)
       } else \
       {
          if {$tpth_flag} \
          {
             set evt_yc [expr $evt_yc + [expr $evt_dim_height / 2] + \
                                            $evt_evtdis]
          } else \
          {
              set evt_yc [expr $evt_yc + $evt_dim_height + $evt_evtdis]
          }
       }
   }
}

#==========================================================================
# This procedure create an Event.
#==========================================================================
proc UI_PB_evt_CreateEvent { PAGE_OBJ SEQ_OBJ EVT_OBJ } {
#==========================================================================
  upvar $PAGE_OBJ page_obj
  upvar $SEQ_OBJ seq_obj
  upvar $EVT_OBJ evt_obj

  global tixOption
  global paOption

  if {$Page::($page_obj,prev_seq) == 0 || $Page::($page_obj,prev_seq) == 1 || \
      $Page::($page_obj,prev_seq) == 3 || $Page::($page_obj,prev_seq) == 4} \
  {
      set icon_bg $paOption(seq_bg)
      set text_bg $paOption(seq_fg)
      set icon_relief flat
      set bd_width 1

  } else \
  {
      set icon_bg $paOption(event)
      set text_bg white
      set icon_relief raised
      set bd_width 2
  }

  # Gets all the Event dimension, which are stored
  # as page attributes.
   set t_shift $Page::($page_obj,glob_text_shift)
   set bot_canvas $Page::($page_obj,bot_canvas)
   set evt_dim_width [lindex $Page::($page_obj,glob_evnt_dim) 0]
   set evt_dim_height [lindex $Page::($page_obj,glob_evnt_dim) 1]
  
  # Creates a minus collapse icon.
   UI_PB_evt_CreateCollapseIcon page_obj seq_obj evt_obj

  # Creates Event icon and locates it at the specified center
   set evt_img_id [UI_PB_blk_CreateIcon $bot_canvas pb_event ""]
   $evt_img_id config -bg $icon_bg -borderwidth $bd_width

   set evt_xc $event::($evt_obj,xc)
   set evt_yc $event::($evt_obj,yc)
  
   set icon_id [$bot_canvas create image $evt_xc $evt_yc \
                     -image $evt_img_id -tag evt_movable]

   $evt_img_id config -relief $icon_relief

 # Creates the event text
   set event_name $event::($evt_obj,event_name)
   set text_id [$bot_canvas create text [expr $evt_xc + $t_shift] $evt_yc \
                   -text $event_name -font $tixOption(bold_font) \
                   -fill $text_bg -tag evt_movable]

   set event::($evt_obj,icon_id) $icon_id
   set event::($evt_obj,text_id) $text_id
   lappend sequence::($seq_obj,texticon_ids) $text_id $icon_id
   set cen_shift $Page::($page_obj,cen_shift)

  # creates a rectangle to hold the Event icon
   set cordx1 [expr $evt_xc + $cen_shift - [expr $evt_dim_width / 2]]
   set cordy1 [expr $evt_yc + $cen_shift - [expr $evt_dim_height / 2]]
   set cordx2 [expr $evt_xc + $cen_shift + [expr $evt_dim_width / 2]]
   set cordy2 [expr $evt_yc + $cen_shift + [expr $evt_dim_height / 2]]

   set rect_id [$bot_canvas create rect $cordx1 $cordy1 $cordx2 $cordy2 \
                -outline navyblue -fill navyblue] 

   $bot_canvas lower $rect_id
   set event::($evt_obj,evt_rect) $rect_id
}

#==========================================================================
# This procedure creates the blocks of toolpath event in the
# specified way.
#==========================================================================
proc UI_PB_evt_CreateElemOfTpthEvent {PAGE_OBJ SEQ_OBJ EVT_OBJ} { 
#==========================================================================
  upvar $PAGE_OBJ page_obj
  upvar $SEQ_OBJ seq_obj
  upvar $EVT_OBJ evt_obj
    
  global paOption
  global tixOption

  set bot_canvas $Page::($page_obj,bot_canvas)
  set evt_blkdist $Page::($page_obj,glob_evt_blkdist)
  set evt_evtdist $Page::($page_obj,glob_evt_evtdist)
  set evt_dim_width [lindex $Page::($page_obj,glob_evnt_dim) 0]
  set evt_dim_height [lindex $Page::($page_obj,glob_evnt_dim) 1]
  set rect_gap $Page::($page_obj,glob_rect_gap)

  # Event center from event object
    set evt_xc $event::($evt_obj,xc)
    set evt_yc $event::($evt_obj,yc)

  # Calculates the first blocks center
    set blk_corner1_x [expr $evt_xc + [expr $evt_dim_width / 2] + \
                                              $evt_blkdist] 
    set blk_corner1_y [expr $evt_yc - [expr $evt_dim_height / 2]]

  # No of block templates
    set rows $event::($evt_obj,block_nof_rows)
    set event::($evt_obj,event_width) 0

  # Creates Block templates
    UI_PB_com_ReturnEventNcOutAttr evt_obj str_size ver_height \
                                   evt_nc_output
    set blk_corner2_x [expr $blk_corner1_x + $str_size + 10]
    set blk_corner2_y [expr $blk_corner1_y + $ver_height + 10]

   if {[info exists evt_nc_output]} \
   {
      set rect_id [$bot_canvas create rect $blk_corner1_x $blk_corner1_y \
                    $blk_corner2_x $blk_corner2_y -outline black \
                    -width $rect_gap -fill $paOption(tree_bg)]

      set line_id [UI_PB_evt_CreateLine bot_canvas $evt_xc \
                          $evt_yc $blk_corner1_x $evt_yc]
      set xc [expr $blk_corner1_x + [expr $str_size / 2]]
      set yc [expr $blk_corner1_y + [expr $ver_height / 2]]
      set text_id [$bot_canvas create text [expr $xc + 5] [expr $yc + 13] \
                    -text $evt_nc_output -justify left]

      set event::($evt_obj,blk_rect) $rect_id
      set event::($evt_obj,blk_text) $text_id
      set event::($evt_obj,extra_lines) $line_id
      unset evt_nc_output
   }

   if {$ver_height} \
   {
       set event::($evt_obj,event_height) [expr $blk_corner1_y + \
                   $ver_height + $evt_evtdist + 10]
   } else \
   {
       set event::($evt_obj,event_height) [expr $blk_corner1_y + \
                   $evt_dim_height + $evt_evtdist]
   }

#### Update has a problem, when there is only one event in the sequence.

   # updates the display
     if { $Page::($page_obj,prev_seq) != 0 && \
          $Page::($page_obj,prev_seq) != 6 } \
     {
        update idletasks
     }
}

#==========================================================================
# This procedure creates the blocks of an event in the
# specified way.
#==========================================================================
proc UI_PB_evt_CreateElementsOfEvent { PAGE_OBJ SEQ_OBJ EVT_OBJ } { 
#==========================================================================
   upvar $PAGE_OBJ page_obj
   upvar $SEQ_OBJ seq_obj
   upvar $EVT_OBJ evt_obj
    
   global paOption
   global tixOption

  # Gets all the block attributes
    set bot_canvas $Page::($page_obj,bot_canvas)
    set blk_blkdist_hor $Page::($page_obj,glob_blk_blkdist_hor)
    set blk_blkdist_ver $Page::($page_obj,glob_blk_blkdist_ver)
    set evt_blkdist $Page::($page_obj,glob_evt_blkdist)
    set evt_evtdist $Page::($page_obj,glob_evt_evtdist)
    set t_shift $Page::($page_obj,glob_text_shift)
    set blk_dim_width [lindex $Page::($page_obj,glob_blk_dim) 0]
    set blk_dim_height [lindex $Page::($page_obj,glob_blk_dim) 1]
    set evt_dim_width [lindex $Page::($page_obj,glob_evnt_dim) 0]
    set evt_dim_height [lindex $Page::($page_obj,glob_evnt_dim) 1]

  # Event center from event object
    set evt_xc $event::($evt_obj,xc)
    set evt_yc $event::($evt_obj,yc)
    set x1 $evt_xc
    
  # Calculates the first blocks center
    set elem_xc [expr $evt_dim_width + $evt_xc + $evt_blkdist] 
    set elem_yc $evt_yc

  # No of block templates
    set rows $event::($evt_obj,block_nof_rows)
    set event::($evt_obj,event_width) 0

  # Creates Block templates
    for {set count 0} {$count < $rows} {incr count} \
    {
        set evt_row_elem_list [lindex $event::($evt_obj,evt_elem_list) $count]
       
      # Creates the blocks of a template block (row)
        foreach evt_elem_obj $evt_row_elem_list \
        {
           set event_element::($evt_elem_obj,xc) $elem_xc
           set event_element::($evt_elem_obj,yc) $elem_yc
 
          # Creates a block
            UI_PB_evt_CreateEventElement page_obj seq_obj evt_elem_obj
        
          # Creates a line either connecting a event and a block
          # or block and a block.
            set line_id [UI_PB_evt_CreateLine bot_canvas $x1 $elem_yc \
                            $elem_xc $elem_yc]

          # Stores the line id as attribute of block object
            set event_element::($evt_elem_obj,line_id) $line_id 

            set x1 $elem_xc
            set elem_xc [expr $elem_xc + $blk_dim_width + $blk_blkdist_hor]
        }

        # Creates a rectangle and the two seperators, above and
        # below the block template.
         set temp_ids [UI_PB_evt_CreateARowTempRect page_obj evt_obj count]
         lappend temp_rect [lindex $temp_ids 0]
         lappend sep_ids [lrange $temp_ids 1 end]
         if { $count < [expr $rows - 1]} \
         {
            set x1 [expr $evt_xc + [expr $evt_dim_width / 2] + \
                                [expr $evt_blkdist / 2]]
            set y2 [expr $elem_yc + $blk_dim_height + $blk_blkdist_ver]

           # Creates a line, to connect two block templates (rows)
            set line_id [UI_PB_evt_CreateLine bot_canvas $x1 \
                                         $elem_yc $x1 $y2]
            lappend extra_lines $line_id
            set elem_yc $y2
            set elem_xc [expr $evt_dim_width + $evt_xc + $evt_blkdist] 
            set y1 $y2
         }
    }

   # if the no of block templates are zero. It just draws
   # a rectangle as a seperator.      
    if {$rows == 0} \
    {
       set temp_ids [UI_PB_evt_CreateARowTempRect page_obj evt_obj count]
       lappend temp_rect [lindex $temp_ids 0]
    }

   # stores the line_ids (the line connecting the two block template)
   # as attributes of event object
    if {[info exists extra_lines]}\
    {
        set event::($evt_obj,extra_lines) $extra_lines
    }

   # stores the ids of all the block templates rectangles.
    if {[info exists temp_rect]}\
    {
        set event::($evt_obj,rect_id) $temp_rect
    }
   
   # stores the ids of top and bottom seperators of all
   # block templates.
    if {[info exists sep_ids]} \
    {
        set event::($evt_obj,sep_id) $sep_ids
    }

    set event::($evt_obj,event_height) [expr $elem_yc + $evt_dim_height \
                                                     + $evt_evtdist]
}

#============================================================================
# This procedure creates a block.
#============================================================================
proc UI_PB_evt_CreateEventElement {PAGE_OBJ SEQ_OBJ EVT_ELEM_OBJ } {
#============================================================================
   upvar $PAGE_OBJ page_obj
   upvar $SEQ_OBJ seq_obj
   upvar $EVT_ELEM_OBJ evt_elem_obj

   global paOption
   global tixOption

   set bot_canvas $Page::($page_obj,bot_canvas)
   set blk_dim_width [lindex $Page::($page_obj,glob_blk_dim) 0]
   set blk_dim_height [lindex $Page::($page_obj,glob_blk_dim) 1]
   set t_shift $Page::($page_obj,glob_text_shift)
   set rect_gap $Page::($page_obj,glob_rect_gap)

   set elem_img_id [UI_PB_blk_CreateIcon $bot_canvas pb_block ""]
   $elem_img_id configure -bg lightSkyBlue

   set elem_xc $event_element::($evt_elem_obj,xc)
   set elem_yc $event_element::($evt_elem_obj,yc)
    
   # creates a rectangle to hold the block icon
     set cordx1 [expr $elem_xc - [expr $blk_dim_width / 2]]
     set cordy1 [expr $elem_yc - [expr $blk_dim_height / 2]]
     set cordx2 [expr $elem_xc + [expr $blk_dim_width / 2]]
     set cordy2 [expr $elem_yc + [expr $blk_dim_height / 2]]
     set rect_id [$bot_canvas create rect $cordx1 $cordy1 $cordx2 $cordy2 \
                   -outline lightgray -fill lightgray] 
     set event_element::($evt_elem_obj,rect_id) $rect_id

     # Puts the block icon at the specfied center
       set elem_icon_id [$bot_canvas create image $elem_xc $elem_yc  \
                      -image $elem_img_id -tag blk_movable]

       set event_element::($evt_elem_obj,icon_id) $elem_icon_id
       set block_obj $event_element::($evt_elem_obj,block_obj)
       set elem_text $block::($block_obj,block_name)

    # Replaces the underscores in the string with space
      PB_com_GetModEvtBlkName elem_text

      set elem_text_id [$bot_canvas create text [expr $elem_xc + $t_shift] \
                 $elem_yc -text $elem_text -font $tixOption(bold_font) \
                 -tag blk_movable]

    set event_element::($evt_elem_obj,text_id) $elem_text_id 

    lappend sequence::($seq_obj,texticon_ids) $elem_text_id $elem_icon_id
}

#============================================================================
# This procedure creates a Block template rectangle and the two
# seperators, one above the block template and another one below
# the block template. It returns the ids.
#============================================================================
proc UI_PB_evt_CreateARowTempRect {PAGE_OBJ EVT_OBJ COUNT} {
#============================================================================
   upvar $PAGE_OBJ page_obj
   upvar $EVT_OBJ evt_obj
   upvar $COUNT count
   global paOption

   set bot_canvas $Page::($page_obj,bot_canvas)

  # Gets all the dimensions of an event and block
   set rect_gap $Page::($page_obj,glob_rect_gap)
   set evt_dim_width [lindex $Page::($page_obj,glob_evnt_dim) 0]
   set blk_dim_width [lindex $Page::($page_obj,glob_blk_dim) 0]
   set blk_dim_height [lindex $Page::($page_obj,glob_blk_dim) 1]
   set blk_blkdist_hor $Page::($page_obj,glob_blk_blkdist_hor)
   set blk_blkdist_ver $Page::($page_obj,glob_blk_blkdist_ver)
   set evt_blkdist $Page::($page_obj,glob_evt_blkdist)

  # no of block templates
    set no_rows $event::($evt_obj,block_nof_rows)

  # Checks for the no of block templates (rows), if
  # there are zero no of rows, it just creates a rectangle.
  # else it creates a rectangle and two seperators.
   if {$no_rows} \
   {
      # Gets the list of block objects of the template block.
        set elem_obj_list [lindex $event::($evt_obj,evt_elem_list) $count]

      # no of blocks in block template.
        set no_elems [llength $elem_obj_list]

      # first block center.
        set first_blk_obj [lindex $elem_obj_list 0]
        set xc $event_element::($first_blk_obj,xc)
        set yc $event_element::($first_blk_obj,yc)

      # Calculates the upper and lower corners for the rectangle
        set x1 [expr $xc - [expr $blk_dim_width / 2]]
        set y1 [expr $yc - [expr $blk_dim_height / 2]]
   
        set x2 [expr $x1 + [expr $blk_dim_width * $no_elems] + \
               [expr $blk_blkdist_hor * [expr $no_elems - 1]]]
    
        set y2 [expr $y1 + $blk_dim_height]
        set event_width $x2
     
      # Creates the rectangle    
        set rect_id [$bot_canvas create rect [expr $x1 - $rect_gap] \
               [expr $y1 - $rect_gap] [expr $x2 + $rect_gap] \
               [expr $y2 + $rect_gap] -outline $paOption(can_bg) \
                -width $rect_gap -fill $paOption(can_bg)]

       $bot_canvas lower $rect_id
 
      # Creates the two seperators
       set top_sep [$bot_canvas create rect $x1 [expr $y1 - $rect_gap] \
                      $x2 [expr $y1 - 1]\
                     -outline $paOption(can_bg) -width $rect_gap]

       set bot_sep [$bot_canvas create rect $x1 [expr $y2 + 1] \
                     $x2 [expr $y2 + $rect_gap] \
                     -outline $paOption(can_bg)  -width $rect_gap]

      lappend template_ids $rect_id $top_sep $bot_sep

   } else \
   {
     # For the else condition, it creates only a rectangle
      set xc [expr $event::($evt_obj,xc) + $evt_dim_width + \
                   $evt_blkdist]
      set yc $event::($evt_obj,yc)
      set no_elems 1

      set x1 [expr $xc - [expr $blk_dim_width / 2]]
      set y1 [expr $yc - [expr $blk_dim_height / 2]]
   
      set x2 [expr $x1 + [expr $blk_dim_width * $no_elems] + \
              [expr $blk_blkdist_hor * [expr $no_elems - 1]]]
   
      set y2 [expr $y1 + $blk_dim_height]
      set event_width $x2
   
      set rect_id [$bot_canvas create rect [expr $x1 - $rect_gap] \
                  [expr $y1 - $rect_gap] [expr $x2 + $rect_gap] \
                  [expr $y2 + $rect_gap] -outline $paOption(can_bg) \
                         -width $rect_gap -fill $paOption(can_bg)]

      $bot_canvas lower $rect_id

      lappend template_ids $rect_id 
   }

   if {$event_width > $event::($evt_obj,event_width)} \
   {
       set event::($evt_obj,event_width) $event_width
   }

   return $template_ids
}

#============================================================================
# This procedure deletes the blocks of an event.
#============================================================================
proc UI_PB_evt_DeleteEventElements {PAGE_OBJ SEQ_OBJ EVT_OBJ } {
#============================================================================
   upvar $PAGE_OBJ page_obj
   upvar $SEQ_OBJ seq_obj
   upvar $EVT_OBJ evt_obj

   set bot_canvas $Page::($page_obj,bot_canvas)
   set no_of_rows $event::($evt_obj,block_nof_rows)

   set tpth_flag [UI_PB_evt_RetBlkTypeFlag page_obj]

  # Cycles through the block templates (rows)
   if {!$tpth_flag} \
   {
      for {set count 0} {$count < $no_of_rows} {incr count} \
      {
         # Gets the list of blocks of a row
           set row_elem_objs [lindex $event::($evt_obj,evt_elem_list) $count]       

         # cycles through the blocks of a row
           foreach elem_obj $row_elem_objs \
           {
             # Deletes the block icon
                $bot_canvas delete $event_element::($elem_obj,icon_id)
   
             # Deletes the rectangle
                $bot_canvas delete $event_element::($elem_obj,rect_id) 

             # Deletes the text id
                $bot_canvas delete $event_element::($elem_obj,text_id)

             # Deletes the line that joins two blocks or block and
             # event.
                $bot_canvas delete $event_element::($elem_obj,line_id)
           
             # Deletes the text and icon ids from the texticon list
                set index [lsearch $sequence::($seq_obj,texticon_ids) \
                              $event_element::($elem_obj,text_id)]
                if {$index != -1} \
                {
                   set sequence::($seq_obj,texticon_ids) \
                   [lreplace $sequence::($seq_obj,texticon_ids) \
                                        $index [expr $index + 1]]
                }
          }
      }

     # Deletes the rectangles of each block template 
      if {[info exists event::($evt_obj,rect_id)]} \
      {
          foreach rect_id $event::($evt_obj,rect_id) \
          {
              $bot_canvas delete $rect_id
          }
      }

     # Deletes the two seperatores of each block template
      if {[info exists event::($evt_obj,sep_id)]} \
      {
          foreach sep_list $event::($evt_obj,sep_id) \
          {
              foreach sep_id $sep_list \
              {
                  $bot_canvas delete $sep_id
              }
          }
      }
  }

  # Deletes the lines, that connect the two block templates (rows)
   if {[info exists event::($evt_obj,extra_lines)]} \
   {
       foreach line $event::($evt_obj,extra_lines) \
       {
           $bot_canvas delete $line
       }
   }
}

#============================================================================
# This procedure attaches the bind procedures to the Event icons
#============================================================================
proc UI_PB_evt_EvtBindProcs { PAGE_OBJ SEQ_OBJ } {
#============================================================================
    upvar $PAGE_OBJ page_obj
    upvar $SEQ_OBJ seq_obj
    
   set bot_canvas $Page::($page_obj,bot_canvas)

   # Binds the enter of the cursor
    $bot_canvas bind evt_movable <Enter> "UI_PB_evt_EventFocusOn $bot_canvas \
                                                      $seq_obj"
   # Binds the leave of the cursor
    $bot_canvas bind evt_movable <Leave> "UI_PB_evt_EventFocusOff $bot_canvas \
                                                      $seq_obj"
   # Binds the first mouse button
    $bot_canvas bind evt_movable <1> "UI_PB_evt_EventStartDrag $page_obj \
                                                      $seq_obj"
}

#============================================================================
proc UI_PB_evt_EvtUnBindProcs { PAGE_OBJ SEQ_OBJ } {
#============================================================================
    upvar $PAGE_OBJ page_obj
    upvar $SEQ_OBJ seq_obj
    
   set bot_canvas $Page::($page_obj,bot_canvas)

   # UnBinds the enter of the cursor
    $bot_canvas bind evt_movable <Enter> ""

   # UnBinds the leave of the cursor
    $bot_canvas bind evt_movable <Leave> ""

   # UnBinds the first mouse button
    $bot_canvas bind evt_movable <1>     ""
}

#============================================================================
# This procedure unbinds the binded procedures to event icon
#============================================================================
proc UI_PB_evt_UnBindEvtProcs { PAGE_OBJ } {
#============================================================================
  upvar $PAGE_OBJ page_obj

  set bot_canvas $Page::($page_obj,bot_canvas)

  # Binds the enter of the cursor
    $bot_canvas bind evt_movable <Enter> ""

  # Binds the leave of the cursor
    $bot_canvas bind evt_movable <Leave> "" 
                                        
  # Binds the first mouse button
    $bot_canvas bind evt_movable <1>     ""
}

#============================================================================
# This procedure attaches the bind procedures to the Block icons
#==========================================================================
proc UI_PB_evt_BlkBindProcs { PAGE_OBJ SEQ_OBJ } {
#==========================================================================
    upvar $PAGE_OBJ page_obj
    upvar $SEQ_OBJ seq_obj

    set bot_canvas $Page::($page_obj,bot_canvas)
  
   # Binds the Enter
     $bot_canvas bind blk_movable <Enter> "UI_PB_evt_BlockFocusOn $page_obj \
                                                  $seq_obj"
   # Binds the Leave
     $bot_canvas bind blk_movable <Leave> "UI_PB_evt_BlockFocusOff $page_obj \
                                                  $seq_obj"
   # Binds the first mouse button
     $bot_canvas bind blk_movable <1> "UI_PB_evt_BlockStartDrag $page_obj \
                                                  $seq_obj %x %y"
   # Binds the motion of first mouse button
     $bot_canvas bind blk_movable <B1-Motion> "UI_PB_evt_BlockDrag $page_obj \
                                                  $seq_obj %x %y"
   # Binds the release of first mouse button
     $bot_canvas bind blk_movable <ButtonRelease-1> "UI_PB_evt_BlockEndDrag \
                                                  $page_obj $seq_obj"
   # Binds the third mouse button
     $bot_canvas bind blk_movable <3> "UI_PB_evt_CreateBlkPopup $page_obj \
                                             $seq_obj"
}

#==========================================================================
proc UI_PB_evt_BlkUnBindProcs { PAGE_OBJ SEQ_OBJ } {
#==========================================================================
    upvar $PAGE_OBJ page_obj
    upvar $SEQ_OBJ seq_obj

    set bot_canvas $Page::($page_obj,bot_canvas)
  
   # UnBinds the Enter
     $bot_canvas bind blk_movable <Enter> ""

   # UnBinds the Leave
     $bot_canvas bind blk_movable <Leave> ""

   # UnBinds the first mouse button
     $bot_canvas bind blk_movable <1> ""

   # UnBinds the motion of first mouse button
     $bot_canvas bind blk_movable <B1-Motion> ""

   # UnBinds the release of first mouse button
     $bot_canvas bind blk_movable <ButtonRelease-1> ""

   # UnBinds the third mouse button
     $bot_canvas bind blk_movable <3> ""
}

#============================================================================
# This procedure unbinds the bind procs of Blocks
#==========================================================================
proc UI_PB_evt_UnBindBlkProcs { PAGE_OBJ } {
#==========================================================================
   upvar $PAGE_OBJ page_obj

   set bot_canvas $Page::($page_obj,bot_canvas)
  
   # Binds the Enter
     $bot_canvas bind blk_movable <Enter> " "

   # Binds the Leave
     $bot_canvas bind blk_movable <Leave> " "

   # Binds the first mouse button
     $bot_canvas bind blk_movable <1> " "

   # Binds the motion of first mouse button
     $bot_canvas bind blk_movable <B1-Motion> " "

   # Binds the release of first mouse button
     $bot_canvas bind blk_movable <ButtonRelease-1> " "
}

#==========================================================================
# This procedure is triggered, when the cursor enters the
# Event icon. It highlights the event, by changing the
# background color of icon to yellow.
#==========================================================================
proc UI_PB_evt_EventFocusOn { bot_canvas seq_obj} {
#==========================================================================
   global paOption

   set texticon_id $sequence::($seq_obj,texticon_ids)

  # Gets the image id based upon the cursor location.
    set objects [UI_PB_evt_GetCurrentCanvasObject $bot_canvas texticon_id]
    set img [lindex [$bot_canvas itemconfigure [lindex $objects 0] -image] end]
    $img configure -background $paOption(focus)
    $bot_canvas itemconfigure [lindex $objects 1] -fill black
    set sequence::($seq_obj,evt_focus_cell) $objects


# Change cursor
set c $bot_canvas
$c config -cursor hand2
}

#========================================================================
# This procedure returns the icon name based upon the cursor 
# position. The inputs to this procedure are the canvas id
# and a list which contains the text icon ids of the canvas.
#==========================================================================
proc UI_PB_evt_GetCurrentImage {canvas TEXTICON_ID } {
#==========================================================================
  upvar $TEXTICON_ID texticon_ids

  # It gets the list of options that can be configured
    set test [$canvas itemconfigure current]
  
  # Gets the index of -text from the list
    set text_flag [lsearch $test "-text*"]

  # Gets the index of -image from the list
    set image_flag [lsearch $test "-image*"]

  if {$image_flag != -1} \
  {
     # gets the image id from the list
       set img [lindex [$canvas itemconfigure current -image] end]

  } elseif {$text_flag != -1} \
  {
     # gets the text id from the list
       set text_id [$canvas find withtag current]
  
     # gets the image id from the textiocn list based
     # upon the text id index
       set index [lsearch $texticon_ids $text_id]
       set icon_id [lindex $texticon_ids [expr $index + 1]]
       set img [lindex [$canvas itemconfigure $icon_id -image] end]
  }
  return $img
}

#==============================================================================
# This procedure returns the text and icon ids based upon
# the cursor location.
#==============================================================================
proc UI_PB_evt_GetCurrentCanvasObject {bot_canvas TEXTICON_ID} {
#==============================================================================
  upvar $TEXTICON_ID texticon_ids

  # It gets the list of options that can be configured
    set test [$bot_canvas itemconfigure current]

  # Gets the index of -text from the list
    set text_flag [lsearch $test "-text*"]

  # Gets the index of -image from the list
    set image_flag [lsearch $test "-image*"]

  if {$image_flag != -1} \
  {
     set img [$bot_canvas find withtag current]
     set index [lsearch $texticon_ids $img]
     set text_id [lindex $texticon_ids [expr $index - 1]]
     lappend objects $img $text_id

  } elseif {$text_flag != -1} \
  {
      set text_id [$bot_canvas find withtag current]
     # gets the image id from the textiocn list based
     # upon the text id index
      set index [lsearch $texticon_ids $text_id]
      set icon_id [lindex $texticon_ids [expr $index + 1]]
      lappend objects $icon_id $text_id
  }
  return $objects
}

#==========================================================================
# This procedure is triggered, when the cursor leaves the
# Event icon. It unhighlights the event, by changing the
# background color of icon to its original color
#==========================================================================
proc UI_PB_evt_EventFocusOff { bot_canvas seq_obj } {
#==========================================================================
   global paOption
   set prev_evt_focus_cell $sequence::($seq_obj,evt_focus_cell)
   set texticon_id $sequence::($seq_obj,texticon_ids)

   # Gets the image id based upon the cursor location.
     set objects [UI_PB_evt_GetCurrentCanvasObject $bot_canvas texticon_id]

   foreach event_obj $sequence::($seq_obj,evt_obj_list) \
   {
      if { $event::($event_obj,icon_id) == [lindex $objects 0] } { break }
   }

   # Unhighlight current icon
   if {$prev_evt_focus_cell != 0} \
   {
      set img [lindex [$bot_canvas itemconfigure \
                        [lindex $prev_evt_focus_cell 0] -image] end]
      if {[string compare $img ""] != 0 } \
      {
         if {$event::($event_obj,event_open)} \
         {
            $img configure -background pink
         } else \
         {
            $img configure -background $paOption(event)
         }

         $bot_canvas itemconfigure [lindex $prev_evt_focus_cell 1] -fill white
         set sequence::($seq_obj,prev_evt_focus_cell) 0
      }
   }


# Change cursor
set c $bot_canvas
$c config -cursor ""
}

#==========================================================================
# This procedure is called when the first mouse button is
# clicked on any of the event icon.
#==========================================================================
proc UI_PB_evt_EventStartDrag { page_obj seq_obj } {
#==========================================================================
  set texticon_id $sequence::($seq_obj,texticon_ids)
  set bot_canvas $Page::($page_obj,bot_canvas)

  # Gets the image id based upon the cursor location.
    set objects [UI_PB_evt_GetCurrentCanvasObject $bot_canvas texticon_id]

   foreach event_obj $sequence::($seq_obj,evt_obj_list) \
   {
      if { $event::($event_obj,icon_id) == [lindex $objects 0] } { break }
   }

  # Calls the respective event procedure
    set event::($event_obj,event_open) 1
    UI_PB_evt_ToolPath page_obj seq_obj event_obj
}

#=========================================================================
proc UI_PB_eve_CreateBalloon { PAGE_OBJ } {
#=========================================================================
  upvar $PAGE_OBJ page_obj
  global gPB_help_tips
  global gPB

   if {$gPB_help_tips(state)} \
   {
     set c $Page::($page_obj,bot_canvas)

     if {![info exists gPB(seq_page_blk_item_focus_on)]} \
     {
       set gPB(seq_page_blk_item_focus_on) 0
     }

     if {$gPB(seq_page_blk_item_focus_on) == 0} \
     {
       set gPB_help_tips($c) {Block Description}
       set gPB(seq_page_blk_item_focus_on) 1
     }
   }
}

#=========================================================================
proc UI_PB_eve_DeleteBalloon { PAGE_OBJ } {
#=========================================================================
  upvar $PAGE_OBJ page_obj
  global gPB_help_tips

   if {$gPB_help_tips(state)} \
   {
     set c $Page::($page_obj,bot_canvas)

     if [info exists gPB_help_tips($c)] {
       unset gPB_help_tips($c)
     }
     PB_cancel_balloon
     global gPB
     set gPB(seq_page_blk_item_focus_on) 0
   }
}

#==========================================================================
# This procedure is triggered, when the cursor enters the
# Block icon. It highlights the Block, by changing the
# background color of icon to yellow.
#==========================================================================
proc UI_PB_evt_BlockFocusOn { page_obj seq_obj } {
#==========================================================================
  global paOption

   set bot_canvas $Page::($page_obj,bot_canvas)
   set texticon_id $sequence::($seq_obj,texticon_ids)
   set img [UI_PB_evt_GetCurrentImage $bot_canvas texticon_id]
   set sequence::($seq_obj,blk_focus_cell) $img
   $img configure -background $paOption(focus)

  # Add balloon help
   UI_PB_eve_CreateBalloon page_obj


# Change cursor
set c $bot_canvas
$c config -cursor hand2
}

#==========================================================================
# This procedure is triggered, when the cursor leaves the
# Block icon. It unhighlights the Block, by changing the
# background color of icon to its original color.
#==========================================================================
proc UI_PB_evt_BlockFocusOff { page_obj seq_obj } {
#==========================================================================
   global paOption

   set bot_canvas $Page::($page_obj,bot_canvas)

   # Unhighlight current icon
     set prev_blk_focus_cell $sequence::($seq_obj,blk_focus_cell)
 
    if {$prev_blk_focus_cell != 0} \
    {
        $prev_blk_focus_cell configure -background lightSkyBlue
        set sequence::($seq_obj,blk_focus_cell) 0
    }

   # Unset balloon
    UI_PB_eve_DeleteBalloon page_obj


# Change cursor
set c $bot_canvas
$c config -cursor ""
}

#=========================================================================
# This procedure returns the block object based upon the
# block icon id
#=========================================================================
proc UI_PB_evt_GetBlkObjFromImageid {PAGE_OBJ SEQ_OBJ focus_img} {
#=========================================================================
  upvar $PAGE_OBJ page_obj
  upvar $SEQ_OBJ seq_obj

   set bot_canvas $Page::($page_obj,bot_canvas)
   set active_blk_flag 0

  # Cycles through the events
   foreach evt_obj $sequence::($seq_obj,evt_obj_list) \
   {
    # Gets the no of block templates of an event
      set no_rows $event::($evt_obj,block_nof_rows)

     for {set count 0} {$count < $no_rows} {incr count} \
     {
       # Cycles through the blocks of the block template
        set row_elem_objs [lindex $event::($evt_obj,evt_elem_list) $count]
        foreach elem_obj $row_elem_objs \
        {
           set elem_img $event_element::($elem_obj,icon_id)
           set img_name [lindex [$bot_canvas itemconfigure $elem_img -image] end]

           # Compares the image id with the block object image id
            if {[string compare $img_name $focus_img] == 0} \
            {
                 set sequence::($seq_obj,drag_blk_obj) $elem_obj
                 set sequence::($seq_obj,drag_evt_obj) $evt_obj
                 set sequence::($seq_obj,drag_row) $count
                 set active_blk_flag 1
                 break
            }
        }
                           
        if {$active_blk_flag} {break}
     }
        if {$active_blk_flag} {break}
  }
}

#==========================================================================
# This procedure is called, when the first mouse button is
# clicked on the Block icon. It creates the temporary icon
# in the top and action canvas based upon the type of block.
# If the block that is dragged is a normal one, then it will
# be draggable only in the bottom and top canvas. While the
# action block is draggable in bottom canvas and action canvas.
#==========================================================================
proc UI_PB_evt_BlockStartDrag {page_obj seq_obj x y} {
#==========================================================================
  global paOption
  global tixOption

 # for editing the block
   set Page::($page_obj,being_dragged) 0

 # Gets the id of bottom and top canvas
  set bot_canvas $Page::($page_obj,bot_canvas)
  set top_canvas $Page::($page_obj,top_canvas)
  set t_shift $Page::($page_obj,glob_text_shift)

 # maps the cursor coords to the bottom canvas
  set xx [$bot_canvas canvasx $x]
  set yy [$bot_canvas canvasy $y]

 # Gets the current block image name, based upon the cursor
  set texticon_id $sequence::($seq_obj,texticon_ids)
  set img [UI_PB_evt_GetCurrentImage $bot_canvas texticon_id]

  set sequence::($seq_obj,prev_bot_blk_xc) $xx
  set sequence::($seq_obj,prev_bot_blk_yc) $yy

 # Gets the block object based upon the block image id
  UI_PB_evt_GetBlkObjFromImageid page_obj seq_obj $img
  set elem_obj $sequence::($seq_obj,drag_blk_obj)
     
  set elem_xc $event_element::($elem_obj,xc)
  set elem_yc $event_element::($elem_obj,yc)

 # calculates the distance between the center of
 # block that is dragged and the cursor location.
  set diff_x [expr $xx - $elem_xc]
  set diff_y [expr $yy - $elem_yc]

 # Top canvas height
  set panel_hi $Page::($page_obj,panel_hi)
  set dy [expr $panel_hi + 2]
  set block_obj $event_element::($elem_obj,block_obj)
  set elem_text $block::($block_obj,block_name)

 # If the block that is dragged is a normal one, then the
 # Temporary icon is created only in the top canvas.
  if {[string compare $event_element::($elem_obj,type) "normal"] == 0} \
  {
      set img_addr [UI_PB_blk_CreateIcon $top_canvas pb_block ""]
      $img_addr config -bg $paOption(focus)
    
     # creates the temporary icon in top canvas
      set elem_top_img [$top_canvas create image [expr $x - $diff_x] \
                 [expr $y + $dy - $diff_y] -image $img_addr -tag new_comp]

     # creates the temporary text in top canvas
      set elem_top_text [$top_canvas create text [expr $x - $diff_x + $t_shift] \
             [expr $y + $dy - $diff_y] -text $elem_text \
             -font $tixOption(bold_font) -tag blk_movable]

      set sequence::($seq_obj,blk_top_img) $elem_top_img
      set sequence::($seq_obj,blk_top_text) $elem_top_text
      set sequence::($seq_obj,prev_top_blk_xc) $x
      set sequence::($seq_obj,prev_top_blk_yc) [expr $y + $panel_hi]

 # If the block that is dragged is a action block, then the
 # Temporary icon is created only in the action canvas.
  } elseif {$Page::($page_obj,action_flag) == 0 && \
      [string compare $event_element::($elem_obj,type) "action"] == 0} \
  {
      set act_canvas $Page::($page_obj,action_canvas)
      set act_img_addr [UI_PB_blk_CreateIcon $act_canvas pb_block ""]
      $act_img_addr config -bg $paOption(focus)

     # gets the top and bottom portion of the canvas that is
     # not visable.
      set y_shift [$bot_canvas yview]
  
      # Gets the top portion of canvas that is not visable.
       set top_portion [expr [lindex $y_shift 0] * 2000]

      # difference of top and bottom gives the visable portion.
      # that is the height of the bottom canvas
       set bot_canvas_hi [expr [expr [lindex $y_shift 1] \
                             - [lindex $y_shift 0]] * 2000]
       set dy [expr $bot_canvas_hi + 6]
       set Page::($page_obj,bot_canvas_hi) $bot_canvas_hi
     
      # creates the temporary icon in action canvas
       set elem_act_img [$act_canvas create image [expr $x - $diff_x] \
                         [expr $y - $dy - $diff_y - $top_portion] \
                         -image $act_img_addr -tag del_block]

      # creates the temporary text in action canvas
       set elem_act_text [$act_canvas create text \
           [expr $x - $diff_x + $t_shift] [expr $y - $dy - $diff_y - \
           $top_portion] -text $elem_text -font $tixOption(bold_font) \
           -tag blk_movable]

       set sequence::($seq_obj,blk_act_img) $elem_act_img
       set sequence::($seq_obj,blk_act_text) $elem_act_text
       set sequence::($seq_obj,prev_act_blk_xc) $x
       set sequence::($seq_obj,prev_act_blk_yc) \
                [expr $y - $bot_canvas_hi - $top_portion]
  }


# Change cursor to grab
#<gsl> UI_PB_com_ChangeCursor $bot_canvas
}

#==========================================================================
# This procedure is triggered, when the mouse is moved without
# releasing the first mouse button.
#==========================================================================
proc UI_PB_evt_BlockDrag {page_obj seq_obj x y} {
#==========================================================================
  if {$Page::($page_obj,being_dragged) < $Page::($page_obj,drag_sensitivity)} \
  {
      incr Page::($page_obj,being_dragged)
  }

  set top_canvas $Page::($page_obj,top_canvas)
  set bot_canvas $Page::($page_obj,bot_canvas)
  set panel_hi $Page::($page_obj,panel_hi)

  set xb [$bot_canvas canvasx $x]
  set yb [$bot_canvas canvasy $y]

  # Translate elements in the bottom canvas
   set texticon_id $sequence::($seq_obj,texticon_ids)
   set objects [UI_PB_evt_GetCurrentCanvasObject $bot_canvas texticon_id]
  
   # icon
    $bot_canvas move [lindex $objects 0] \
         [expr $xb - $sequence::($seq_obj,prev_bot_blk_xc)] \
         [expr $yb - $sequence::($seq_obj,prev_bot_blk_yc)]
 
   # text
    $bot_canvas move [lindex $objects 1] \
         [expr $xb - $sequence::($seq_obj,prev_bot_blk_xc)] \
         [expr $yb - $sequence::($seq_obj,prev_bot_blk_yc)]
 
   set sequence::($seq_obj,prev_bot_blk_xc) $xb
   set sequence::($seq_obj,prev_bot_blk_yc) $yb

  $bot_canvas raise [lindex $objects 0]
  $bot_canvas raise [lindex $objects 1]

  set elem_obj $sequence::($seq_obj,drag_blk_obj)

  # if the block that is dragged is a normal one, then the
  # temporary block created in the top canvas is moved.
   if {[string compare $event_element::($elem_obj,type) "normal"] == 0} \
   {
       set xt [$top_canvas canvasx $x]
       set yt [$top_canvas canvasy $y]
     
      $top_canvas move $sequence::($seq_obj,blk_top_img) \
           [expr $xt - $sequence::($seq_obj,prev_top_blk_xc)] \
           [expr $yt - $sequence::($seq_obj,prev_top_blk_yc) + $panel_hi] 

      $top_canvas move $sequence::($seq_obj,blk_top_text) \
           [expr $xt - $sequence::($seq_obj,prev_top_blk_xc)] \
           [expr $yt - $sequence::($seq_obj,prev_top_blk_yc) + $panel_hi] 

    
      set sequence::($seq_obj,prev_top_blk_xc) $xt
      set sequence::($seq_obj,prev_top_blk_yc) [expr $yt + $panel_hi]

      UI_PB_evt_TrashFocusOn page_obj seq_obj $x $y
   }

  # Gets the event object based upon the current cursor location
   UI_PB_evt_GetEventObjFromCurPos page_obj seq_obj $xb $yb

  # Highlights the seperators based upon the cursor location
   UI_PB_evt_HighLightSep page_obj seq_obj $xb $yb

  # if the block that is dragged is a action block, then it
  # is translated in the action canvas.
   if {$Page::($page_obj,action_flag) == 0 && \
       [string compare $event_element::($elem_obj,type) "action"] == 0} \
   {
       set action_canvas $Page::($page_obj,action_canvas)
       set bot_canvas_hi $Page::($page_obj,bot_canvas_hi)
       set xa [$action_canvas canvasx $x]
       set ya [$action_canvas canvasy $y]
     
       $action_canvas move $sequence::($seq_obj,blk_act_img) \
            [expr $xa - $sequence::($seq_obj,prev_act_blk_xc)] \
            [expr $ya - $sequence::($seq_obj,prev_act_blk_yc) - $bot_canvas_hi] 
     
       $action_canvas move $sequence::($seq_obj,blk_act_text) \
            [expr $xa - $sequence::($seq_obj,prev_act_blk_xc)] \
            [expr $ya - $sequence::($seq_obj,prev_act_blk_yc) - \
            $bot_canvas_hi] 

       set sequence::($seq_obj,prev_act_blk_xc) $xa
       set ya [expr $ya - $bot_canvas_hi]
       set sequence::($seq_obj,prev_act_blk_yc) $ya

     # Highlights the action rectangle based upon the cursor
     # location.
       UI_PB_evt_HighLightActionRect page_obj seq_obj $xa $ya
   }
}

#==========================================================================
# This procedure is called, when the first mouse button holding the
# block of an event is released. If the block, that is dragged is a
# normal one, and if it is released within the range of the trash icon,it 
# deletes that block and transforms the other events and their blocks. Else
# the dragged block is added to any of the template block or above or 
# below template block of the event based upon its release.
#
# If the block dragged is a action block, and if it is released
# in the range of the action canvas, it deletes the dragged block,
# transforms the other events and their blocks and puts the action
# block in action canvas.
#==========================================================================
proc UI_PB_evt_BlockEndDrag {page_obj seq_obj} {
#==========================================================================
  global paOption
  global tixOption

  set bot_canvas $Page::($page_obj,bot_canvas)
  set elem_obj $sequence::($seq_obj,drag_blk_obj)

  # Deletes the temporary icon created in the top canvas
   if {[string compare $event_element::($elem_obj,type) "normal"] == 0} \
   {
     set top_canvas $Page::($page_obj,top_canvas)
     $top_canvas delete $sequence::($seq_obj,blk_top_img)
     $top_canvas delete $sequence::($seq_obj,blk_top_text)
   }

  # Deletes the temporary icon created in the action canvas
   if {$Page::($page_obj,action_flag) == 0 && \
     [string compare $event_element::($elem_obj,type) "action"] == 0} \
   {
      set action_canvas $Page::($page_obj,action_canvas)
      $action_canvas delete $sequence::($seq_obj,blk_act_img)
      $action_canvas delete $sequence::($seq_obj,blk_act_text)
   }

  # Unhighlights the seperators, if the seperators are
  # highlighted
   UI_PB_evt_UnHighlightSeperators $bot_canvas seq_obj

  # Edit the block
    if {$Page::($page_obj,being_dragged) < \
                 $Page::($page_obj,drag_sensitivity)} \
   {
      set focus_img $event_element::($elem_obj,icon_id)
      UI_PB_evt_EditBlock $page_obj $seq_obj $focus_img
   }

  # Checks if the dragged block is released with in the
  # region of trashcan.
   if {$sequence::($seq_obj,trash_flag)} \
   {
     # Deletes the dragged block and transforms other
     # events and their blocks.
      UI_PB_evt_PutBlkInTrash page_obj seq_obj

  # Checks if the dragged block is released within
  # the regions of the other block templates.
   } elseif {$sequence::($seq_obj,add_blk) != 0} \
   {
      # Based upon the release, it either adds to a
      # a row or above or below the row
       UI_PB_evt_SwapBlocks page_obj seq_obj

  # Checks if the dragged block is released within the
  # region of the action canvas.
   } elseif {$sequence::($seq_obj,action_blk_add)} \
   {
     # Deletes the dragged block, and puts in the action
     # action canvas
      UI_PB_evt_AddBlockActionCanvas page_obj seq_obj

   } else \
   {
      # Else returns to its original position.
       UI_PB_evt_ReturnBlock page_obj seq_obj
   }

   set sequence::($seq_obj,prev_top_blk_xc) 0
   set sequence::($seq_obj,prev_top_blk_yc) 0
   set sequence::($seq_obj,drag_flag) 0
   set sequence::($seq_obj,trash_flag) 0
   set sequence::($seq_obj,add_blk) 0
   set sequence::($seq_obj,action_blk_add) 0

   unset sequence::($seq_obj,drag_blk_obj)
   unset sequence::($seq_obj,drag_evt_obj)

   set trash_cell $Page::($page_obj,trash)
   [lindex $trash_cell 0] config -bg $paOption(app_butt_bg)
   
   # Delete connecting line
   $Page::($page_obj,top_canvas) delete connect_line

   # Unset balloon
    UI_PB_eve_DeleteBalloon page_obj
}

#======================================================================
proc UI_PB_evt_CreateBlkPopup { page_obj seq_obj } {
#======================================================================
  set bot_canvas $Page::($page_obj,bot_canvas)
  set texticon_id $sequence::($seq_obj,texticon_ids)
  set focus_img [UI_PB_evt_GetCurrentImage $bot_canvas texticon_id]

  set popup $Page::($page_obj,popup)
  $popup delete 0 end
  $popup add command -label "Edit" -state normal \
            -command "UI_PB_evt_EditBlock $page_obj $seq_obj $focus_img"
  $popup add command -label "Force Output" -state normal \
            -command "UI_PB_evt_EvtBlockModality $page_obj $seq_obj $focus_img"
  $popup add sep
  $popup add command -label "Delete"

  set Page::($page_obj,popup_flag) 1
}

#======================================================================
proc UI_PB_evt_EvtBlockModality { page_obj seq_obj focus_img } {
#======================================================================
  set bot_canvas $Page::($page_obj,bot_canvas)

  UI_PB_evt_GetBlkObjFromImageid page_obj seq_obj $focus_img
  set element_obj $sequence::($seq_obj,drag_blk_obj)
  set current_blk_obj $event_element::($element_obj,block_obj)

  # Creates the block page
    $bot_canvas bind blk_movable <Leave> ""
    set canvas_frame $Page::($page_obj,canvas_frame)
    set evt_img_id $event_element::($element_obj,icon_id)
    set img [lindex [$bot_canvas itemconfigure $evt_img_id -image] end]
    $img config -relief sunken -bg pink
    update

    UI_PB_blk_ModalityDialog page_obj seq_obj element_obj canvas_frame
}

#======================================================================
proc UI_PB_evt_EditBlock { page_obj seq_obj focus_img } {
#======================================================================
  UI_PB_evt_GetBlkObjFromImageid page_obj seq_obj $focus_img
  set element_obj $sequence::($seq_obj,drag_blk_obj)
  set current_blk_obj $event_element::($element_obj,block_obj)

  # Creates the block page
    set bot_canvas $Page::($page_obj,bot_canvas)
    $bot_canvas bind blk_movable <Leave> ""
##     set canvas_frame $Page::($page_obj,canvas_frame)
    set evt_img_id $event_element::($element_obj,icon_id)
    set img [lindex [$bot_canvas itemconfigure $evt_img_id -image] end]
    $img config -relief sunken -bg pink
    update


    UI_PB_evt__DisplayBlockPage $page_obj $seq_obj $current_blk_obj $element_obj


## # UnBind callbacks to the canvas
## tixDisableAll $canvas_frame
## UI_PB_evt_ActionUnBindProcs  page_obj seq_obj
## UI_PB_evt_AddUnBindProcs     page_obj
## UI_PB_evt_BlkUnBindProcs     page_obj seq_obj
## set c $Page::($page_obj,bot_canvas)
## $c config -cursor ""
## ## global gPB_help_tips
## ## unset gPB_help_tips($c)
## 
## 
##     UI_PB_blk_CreateBlockPage current_blk_obj canvas_frame new_blkpage_obj
##     UI_PB_blk_EditBlkActionButtons new_blkpage_obj page_obj seq_obj \
##                                    element_obj
## 
## block::readvalue $current_blk_obj blk_obj_attr
## tkwait window $canvas_frame.$blk_obj_attr(0)
## 
## # ReBind callbacks to the canvas
## tixEnableAll $canvas_frame
## UI_PB_evt_ActionBindProcs  page_obj seq_obj
## UI_PB_evt_AddBindProcs     page_obj
## UI_PB_evt_BlkBindProcs     page_obj seq_obj
}

#======================================================================
proc UI_PB_evt__DisplayBlockPage { page_obj seq_obj block_obj element_obj } {
#======================================================================
##  UI_PB_evt_GetBlkObjFromImageid page_obj seq_obj $focus_img

  # Creates the block page
   set bot_canvas $Page::($page_obj,bot_canvas)
   $bot_canvas bind blk_movable <Leave> ""
   set canvas_frame $Page::($page_obj,canvas_frame)

# UnBind callbacks to the canvas
tixDisableAll $canvas_frame
UI_PB_evt_ActionUnBindProcs  page_obj seq_obj
UI_PB_evt_AddUnBindProcs     page_obj
UI_PB_evt_BlkUnBindProcs     page_obj seq_obj
set c $Page::($page_obj,bot_canvas)
$c config -cursor ""


    UI_PB_blk_CreateBlockPage block_obj canvas_frame new_blk_page_obj
    UI_PB_blk_EditBlkActionButtons new_blk_page_obj page_obj seq_obj \
                                   element_obj

block::readvalue $block_obj blk_obj_attr
tkwait window $canvas_frame.$blk_obj_attr(0)

# ReBind callbacks to the canvas
tixEnableAll $canvas_frame
UI_PB_evt_ActionBindProcs  page_obj seq_obj
UI_PB_evt_AddBindProcs     page_obj
UI_PB_evt_BlkBindProcs     page_obj seq_obj
}

#======================================================================
# This procedure deletes the dragged action block of an event,
# transforms the other events and their blocks and at the same 
# time it adds the action block to the action canvas. 
#======================================================================
proc UI_PB_evt_AddBlockActionCanvas {PAGE_OBJ SEQ_OBJ} {
#======================================================================
  upvar $PAGE_OBJ page_obj
  upvar $SEQ_OBJ seq_obj
  global tixOption
  global paOption

  # Deletes the dragged block and transforms the other
  # events and their blocks.
   UI_PB_evt_PutBlkInTrash page_obj seq_obj

   set elem_obj $sequence::($seq_obj,drag_blk_obj)
   set action_canvas $Page::($page_obj,action_canvas)
   set t_shift $Page::($page_obj,glob_text_shift)

  # Unhighlights the highlighted action canvas rectangle.
   $action_canvas itemconfigure $sequence::($seq_obj,action_rect) \
         -fill lightgray -outline lightgray

   set act_img_addr [UI_PB_blk_CreateIcon $action_canvas pb_block ""]
   set block_obj $event_element::($elem_obj,block_obj)
   set blk_text $block::($block_obj,block_name)
   $act_img_addr config -bg lightsteelblue1

  # Cycles through the action blocks and based upon the
  # action block name it gets the action block object
   foreach act_elem_obj $sequence::($seq_obj,action_elem_list) \
   {
       set act_blk_obj $event_element::($act_elem_obj,block_obj)
       if {[string compare $block::($act_blk_obj,block_name) \
                $blk_text] == 0} \
       {
           set action_elem $act_elem_obj
           break
       }
   }

  # Creates the action block at its original position
   set xc $event_element::($action_elem,xc)
   set yc $event_element::($action_elem,yc)
 
   set elem_act_img [$action_canvas create image $xc \
                 $yc -image $act_img_addr -tag act_movable]
 
   set elem_act_text [$action_canvas create text \
                [expr $xc + $t_shift] $yc -text $blk_text \
                 -font $tixOption(bold_font) -tag act_movable] 
 
   lappend sequence::($seq_obj,action_texticon) $elem_act_text $elem_act_img
   set event_element::($action_elem,icon_id) $elem_act_img
   set event_element::($action_elem,text_id) $elem_act_text
}

#========================================================================
# This procedure either adds the dragged block to the
# selected row or above the selected row or below the
# selected row based upon the location at which the dragged
# block is released.
#========================================================================
proc UI_PB_evt_SwapBlocks {PAGE_OBJ SEQ_OBJ} {
#========================================================================
    upvar $PAGE_OBJ page_obj
    upvar $SEQ_OBJ seq_obj

  # if the dragged block is released outside the range of
  # block templates, then it does nothing.
   if {![info exists sequence::($seq_obj,add_blkto_evt_obj)]} \
   {
       return
   }

  # dragged block object.
    set drag_elem_obj $sequence::($seq_obj,drag_blk_obj)

  # checks for the new block in the template block
   if {[string compare $sequence::($seq_obj,add_blk) "row"] == 0} \
   {
     set blk_exists_flag [UI_PB_evt_CheckBlkInTemplate seq_obj drag_elem_obj]

     # Checks for the existance of new block in the block template.
     # if it exists it popups an error message.
      if {$blk_exists_flag} \
      {
         set bot_canvas $Page::($page_obj,bot_canvas)
         UI_PB_evt_BlockFocusOff $page_obj $seq_obj

         set block_obj $event_element::($drag_elem_obj,block_obj)
         set block_name $block::($block_obj,block_name)
         tk_messageBox -type ok -icon error \
             -message "Block $block_name exists in the Block Template"

         UI_PB_evt_ReturnBlock page_obj seq_obj
         return
      }
   }

   set drag_evt_obj $sequence::($seq_obj,drag_evt_obj)
   set no_rows $event::($drag_evt_obj,block_nof_rows)

  # Gets the block template number (row no) and the index
  # of the block itself in the block template.
   for {set count 0} {$count < $no_rows} {incr count} \
   {
       set elem_index [lsearch [lindex $event::($drag_evt_obj,evt_elem_list) \
                     $count] $sequence::($seq_obj,drag_blk_obj)]

       if {$elem_index != -1} { break }
   }

  # Event object to which the block has to be added.
   set add_evt_obj $sequence::($seq_obj,add_blkto_evt_obj)

  # if the collapse image is minus, then only the block is added,
  # otherwise the dragged block is returned back to its original position.
   if {[string compare $event::($add_evt_obj,col_image) "minus"] == 0} \
   {
      # finds the no of blocks in the block template, from which
      # the block is dragged.
       if {[llength [lindex $event::($drag_evt_obj,evt_elem_list) $count]] > 1} \
       {
           UI_PB_evt_AddDragBlockToRow page_obj seq_obj count elem_index
       } else \
       {
           UI_PB_evt_AddDragBlockAboveOrBelow page_obj seq_obj count
       }
   } else \
   {
      UI_PB_evt_ReturnBlock page_obj seq_obj
   }
}

#========================================================================
proc UI_PB_evt_AddDragBlockToRow { PAGE_OBJ SEQ_OBJ COUNT ELEM_INDEX} {
#========================================================================
  upvar $PAGE_OBJ page_obj
  upvar $SEQ_OBJ seq_obj
  upvar $COUNT count
  upvar $ELEM_INDEX elem_index

   set drag_evt_obj $sequence::($seq_obj,drag_evt_obj)
   set drag_elem_obj $sequence::($seq_obj,drag_blk_obj)

  # Deletes all the blocks of an dragged event.
    UI_PB_evt_DeleteEventElements page_obj seq_obj drag_evt_obj
    set row_elem_list [lindex $event::($drag_evt_obj,evt_elem_list) $count] 
   
  # updates the block template list by eliminating the
  # dragged block.
    set row_elem_list [lreplace $row_elem_list $elem_index $elem_index] 
    set event::($drag_evt_obj,evt_elem_list) \
    [lreplace $event::($drag_evt_obj,evt_elem_list) $count $count $row_elem_list]
         
  # Creates the blocks of an event again.
    UI_PB_evt_CreateElementsOfEvent page_obj seq_obj drag_evt_obj 

  # Then adds the dragged block to the selected block template
  # of an event.
    UI_PB_evt_AddBlockToEvent page_obj seq_obj drag_elem_obj
}

#========================================================================
proc UI_PB_evt_AddDragBlockAboveOrBelow { PAGE_OBJ SEQ_OBJ COUNT} {
#========================================================================
  upvar $PAGE_OBJ page_obj
  upvar $SEQ_OBJ seq_obj
  upvar $COUNT count

   set drag_evt_obj $sequence::($seq_obj,drag_evt_obj)
   set drag_elem_obj $sequence::($seq_obj,drag_blk_obj)

  # Deletes the blocks of an dragged event
    UI_PB_evt_DeleteEventElements page_obj seq_obj drag_evt_obj

  # updates all the block templates of an dragged event, by 
  # eliminating the dragged block.
    set add_evt_obj $sequence::($seq_obj,add_blkto_evt_obj)
    set event::($drag_evt_obj,evt_elem_list) \
          [lreplace $event::($drag_evt_obj,evt_elem_list) $count $count]
    set event::($drag_evt_obj,block_nof_rows) \
          [expr $event::($drag_evt_obj,block_nof_rows) - 1]

  # if the block is dragged and added to the
  # same event
   if {$drag_evt_obj == $add_evt_obj} \
   {
       if {$sequence::($seq_obj,blk_temp) > $count} \
       {
          incr sequence::($seq_obj,blk_temp) -1
       }
   }

  # creates the blocks of an event agin
    UI_PB_evt_CreateElementsOfEvent page_obj seq_obj drag_evt_obj 

    set active_evt_index [lsearch $sequence::($seq_obj,evt_obj_list) \
                                  $drag_evt_obj]
    UI_PB_evt_TransformEvtElem page_obj seq_obj active_evt_index

  # finally it adds the dragged block to the selected template block
  # of an event
    UI_PB_evt_AddBlockToEvent page_obj seq_obj drag_elem_obj
}

#========================================================================
# This procedure deletes the dragged block and transforms other
# events and their blocks.
#========================================================================
proc UI_PB_evt_PutBlkInTrash {PAGE_OBJ SEQ_OBJ } {
#========================================================================
  upvar $PAGE_OBJ page_obj
  upvar $SEQ_OBJ seq_obj

  # Gets the Event object, of the dragged block 
    set active_evt_obj $sequence::($seq_obj,drag_evt_obj)

  # Removes the block object from the block event list
    set evt_elem_obj $sequence::($seq_obj,drag_blk_obj)
    set block_obj $event_element::($evt_elem_obj,block_obj)
    block::DeleteFromEventList $block_obj active_evt_obj

  # total no of block templates in an event
    set no_rows $event::($active_evt_obj,block_nof_rows)
   
  # finds the block template number and its index in the block
  # block template.
    for {set count 0} {$count < $no_rows} {incr count} \
    {
       set elem_index [lsearch [lindex $event::($active_evt_obj,evt_elem_list) \
               $count] $sequence::($seq_obj,drag_blk_obj)]

       if {$elem_index != -1} { break }
    }

  # It deletes the blocks of an dragged event and updates the
  # template block and recreates all the blocks of an event.
    if {[llength [lindex $event::($active_evt_obj,evt_elem_list) \
                                                     $count]] > 1} \
     {
         UI_PB_evt_DeleteEventElements page_obj seq_obj active_evt_obj
         set row_elem_list [lindex $event::($active_evt_obj,evt_elem_list) \
                                        $count] 
        
         set row_elem_list [lreplace $row_elem_list $elem_index $elem_index] 
         set event::($active_evt_obj,evt_elem_list) \
             [lreplace $event::($active_evt_obj,evt_elem_list) $count \
              $count $row_elem_list]
         UI_PB_evt_CreateElementsOfEvent page_obj seq_obj active_evt_obj 
     } else \
     {
         UI_PB_evt_DeleteEventElements page_obj seq_obj active_evt_obj
         set event::($active_evt_obj,evt_elem_list) \
            [lreplace $event::($active_evt_obj,evt_elem_list) $count $count]
         set event::($active_evt_obj,block_nof_rows) [expr $no_rows - 1]

         UI_PB_evt_CreateElementsOfEvent page_obj seq_obj active_evt_obj 

         set active_evt_index [lsearch $sequence::($seq_obj,evt_obj_list) \
                                       $active_evt_obj]
         UI_PB_evt_TransformEvtElem page_obj seq_obj active_evt_index
     }
}

#=========================================================================
# This procedure highlights the trashcan, if the cursor location
# falls within the region of the trash. It highlights by changing
# the background color to yellow.
#=========================================================================
proc UI_PB_evt_TrashFocusOn {PAGE_OBJ SEQ_OBJ x y} {
#=========================================================================
  upvar $PAGE_OBJ page_obj
  upvar $SEQ_OBJ seq_obj
  global paOption

  set top_canvas $Page::($page_obj,top_canvas)
  set trash_cell $Page::($page_obj,trash)

  if {$x > [lindex $trash_cell 1] && $x < [lindex $trash_cell 2] && \
      $y > [lindex $trash_cell 3] && $y < [lindex $trash_cell 4]} \
  {
      [lindex $trash_cell 0] config -bg $paOption(focus)
      UI_PB_blk_TrashConnectLine page_obj
      set sequence::($seq_obj,trash_flag) 1
  } else \
  {
      [lindex $trash_cell 0] config -bg $paOption(app_butt_bg)
      set sequence::($seq_obj,trash_flag) 0
      $top_canvas delete connect_line
  }
}

#=========================================================================
# This procedure highlights the action canvas rectangle, if the 
# cursor location falls within the region of the action canvas 
# rectangle. It highlights by filling the rectangle with yellow.
#==========================================================================
proc UI_PB_evt_HighLightActionRect {PAGE_OBJ SEQ_OBJ x y} {
#==========================================================================
  upvar $PAGE_OBJ page_obj
  upvar $SEQ_OBJ seq_obj
  global paOption

  set action_canvas $Page::($page_obj,action_canvas)
  set action_dim $sequence::($seq_obj,action_dim)

  if {$x > [expr [lindex $action_dim 0] - 20] && \
      $x < [expr [lindex $action_dim 2] + 20] && \
      $y > [expr [lindex $action_dim 1] - 20] && \
      $y < [expr [lindex $action_dim 3] + 20]} \
  {
     $action_canvas itemconfigure $sequence::($seq_obj,action_rect) \
                       -fill $paOption(focus) -outline $paOption(focus)
     set sequence::($seq_obj,action_blk_add) 1
  } else \
  {
     $action_canvas itemconfigure $sequence::($seq_obj,action_rect) \
                       -fill lightgray -outline lightgray
     set sequence::($seq_obj,action_blk_add) 0
  }
}

#==========================================================================
# This procedure puts back the dragged block of an event to
# its original position.
#==========================================================================
proc UI_PB_evt_ReturnBlock {PAGE_OBJ SEQ_OBJ} {
#==========================================================================
   upvar $PAGE_OBJ page_obj
   upvar $SEQ_OBJ seq_obj
   
   set bot_canvas $Page::($page_obj,bot_canvas)
   set text_shift $Page::($page_obj,glob_text_shift)

  # Gets the block object
   set elem_obj $sequence::($seq_obj,drag_blk_obj)

  # puts it at its center
   $bot_canvas coords $event_element::($elem_obj,icon_id) \
          $event_element::($elem_obj,xc) $event_element::($elem_obj,yc)
   $bot_canvas coords $event_element::($elem_obj,text_id) \
          [expr $event_element::($elem_obj,xc) + $text_shift] \
           $event_element::($elem_obj,yc)
}

#==========================================================================
# This procedure creates a line in the canvas. The inputs are
# the canvas id, the top upper corner and the lower left
# corner coordinates.
#==========================================================================
proc UI_PB_evt_CreateLine {CANVAS_ID x1 y1 x2 y2} {
#==========================================================================
  upvar $CANVAS_ID canvas_id

  set line_id [$canvas_id create line $x1 $y1 $x2 $y2]

  $canvas_id lower $line_id

  return $line_id
}

#==========================================================================
# This procedure is called, when the program start of sequence or
# Operation start of sequence or program end sequence or Operation
# end sequence is selected from the tree.
#==========================================================================
proc UI_PB_evt_SeqComponents {PAGE_OBJ SEQ_OBJ} {
      
#==========================================================================
  upvar $PAGE_OBJ page_obj
  upvar $SEQ_OBJ seq_obj
  global mom_sys_arr

  # Creates the events and blocks of the sequence
    if { $mom_sys_arr(seq_blk_nc_code) } \
    {
       set tpth_event_flag 1
    } else \
    {
       set tpth_event_flag 0
    }

    UI_PB_evt_CreateSeqEvent page_obj seq_obj tpth_event_flag
    UI_PB_evt_CreateMenuOptions page_obj seq_obj
  
  # Bind procs for event and blocks
    if { $mom_sys_arr(seq_blk_nc_code) } \
    {
       UI_PB_evt_UnBindBlkProcs page_obj 
    } else \
    {
       UI_PB_evt_BlkBindProcs page_obj seq_obj
    }
}

#==========================================================================
proc UI_PB_evt_ActivateEvent { PAGE_OBJ SEQ_OBJ } {
#==========================================================================
  upvar $PAGE_OBJ page_obj
  upvar $SEQ_OBJ seq_obj

  set seq_evt_list $sequence::($seq_obj,evt_obj_list)
  set bot_canvas $Page::($page_obj,bot_canvas)
  foreach event_name $Page::($page_obj,event_list) \
  {
     PB_com_RetObjFrmName event_name seq_evt_list ret_obj 
     if { $ret_obj } \
     {
        set evt_img_id $event::($ret_obj,icon_id)
        set img [lindex [$bot_canvas itemconfigure $evt_img_id -image] end]
        $img config -relief sunken -bg pink
     }
  }
}

#==========================================================================
# This procedure is called, when the Tool Path elements  is
# selected from the tree. 
#==========================================================================
proc UI_PB_evt_ToolPathSeqComponents {PAGE_OBJ SEQ_OBJ } {
#==========================================================================
  upvar $PAGE_OBJ page_obj
  upvar $SEQ_OBJ seq_obj

   set tpth_event_flag 1
  # Creates the events and blocks of the sequence
   UI_PB_evt_CreateSeqEvent page_obj seq_obj tpth_event_flag
   UI_PB_evt_CreateMenuOptions page_obj seq_obj
   UI_PB_evt_EvtBindProcs page_obj seq_obj
   UI_PB_evt_UnBindBlkProcs page_obj 
   UI_PB_evt_ActivateEvent page_obj seq_obj
}

