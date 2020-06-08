#=========================================================================
#                     UI_PB_ADDRSEQ.TCL
#=========================================================================
##############################################################################
# Description                                                                #
#     This file contains all functions dealing with the creation of          #
#     ui elements for Address Sequence page..                                #
#                                                                            #
# Revisions                                                                  #
#                                                                            #
#   Date        Who      Reason                                              #
# 01-Feb-1999   mnb      Initial                                             #
# 10-Mar-1999   gsl      Used real balloon mechanism for Master Sequence.    #
# 10-Mar-1999   gsl      Revised popup mechanism for Master Sequence.        #
# 02-Jun-1999   mnb      Code Integration                                    #
# 10-Jun-1999   mnb      Removed address N from master sequence              #
# 07-Sep-1999   mnb      Added comments                                      
# 21-Sep-1999   mnb      New Address created in Block/Address page can be    #
#                        sequenced.                                          #
# 17-Nov-1999   gsl      Submitted for phase-22.                             #
#                                                                            #
# $HISTORY$                                                                  #
#                                                                            #
##############################################################################

#=========================================================================
# Main procedure of the Word Sequencing Page .  This procedure is called
# when the word Sequence page is selected for the first time. It basically
# creates the widgets required for sequenceing the addresses.
#
#         Inputs    :  Post Builder Book id
#                      Master Sequence page object
#
#         Outputs   :  Widgets of Master sequence page
#
#=========================================================================
proc UI_PB_ProgTpth_WordSeq {book_id mseq_page} {
#=========================================================================
   global paOption

  # Gets the master sequence page id
    set Page::($mseq_page,page_id) [$book_id subwidget \
                                 $Page::($mseq_page,page_name)]
  
  # Sets the master sequence page attributes
    UI_PB_mseq_SetPageAttributes mseq_page

  # Creates top and bottom canvas of master sequence
    UI_PB_mseq_CreateMastSeqCanvas mseq_page

  # Creates attributes of the box ( Default & Restore buttons)
    $Page::($mseq_page,box) config -bg $paOption(butt_bg)
    $Page::($mseq_page,box) add def -text Default \
                   -command "UI_PB_mseq_DefaultCallBack $mseq_page" -width 10
    $Page::($mseq_page,box) add rst -text Restore \
                   -command "UI_PB_mseq_RestoreCallBack $mseq_page" -width 10

  # Bind popup menu to Mseq components
    set bot_canvas $Page::($mseq_page,bot_canvas)
    set menu [menu $bot_canvas.pop]
    $menu config -bg $paOption(popup) -tearoff 0
    set Page::($mseq_page,menu) $menu
    bind $bot_canvas <3> "UI_PB_mseq_PopupSetOptions $mseq_page %X %Y"
}

#========================================================================
#  This proceduer gets the address object list from database, sorts them
#  according to the master sequence and displays them in the master seq
#  Page.  It also makes a copy of the address data as restore data.
#
#        Inputs   :  Master Seq page object
#
#        Outputs  :  Displays addresses acctoding to their sequence
#
#========================================================================
proc UI_PB_mseq_CreateMastSeqElements { PAGE_OBJ } {
#========================================================================
  upvar $PAGE_OBJ page_obj

  # Creates the master sequence elements
    PB_int_RetAddressObjList add_obj_list
    foreach addr_obj $add_obj_list \
    {
      address::RestoreMseqAttr $addr_obj
    }

  # Sorts the addresses according to their master sequence
    UI_PB_mseq_SortAddresses add_obj_list

  # Displays the address as the icons in the mseq page
    UI_PB_mseq_CreateComponents page_obj add_obj_list
}

#=========================================================================
#  This procedure sets the master sequence page attributes.
#
#       Inputs  :  Mseq page object
#
#       Outputs :  page attributes
#
#=========================================================================
proc UI_PB_mseq_SetPageAttributes { PAGE_OBJ } {
#=========================================================================
  upvar $PAGE_OBJ page_obj

  set Page::($page_obj,in_focus_cell_obj) 0
  set Page::($page_obj,out_focus_cell_obj) 0
  set Page::($page_obj,in_focus_divi_obj) 0
  set Page::($page_obj,out_focus_divi_obj) 0
  set Page::($page_obj,drag_sensitivity) 3
  set Page::($page_obj,x_icon) 0
  set Page::($page_obj,cell_color) 0
  set Page::($page_obj,divi_color) 0
}

#=========================================================================
# This procedure creates the canvas and active & inactive widgets.
#
#        Inputs   :  Mseq page object
#
#        Outputs  :  Canvas, active & inactive widgets
#
#=========================================================================
proc UI_PB_mseq_CreateMastSeqCanvas { PAGE_OBJ } {
#=========================================================================
  upvar $PAGE_OBJ page_obj
  global paOption

  set page_id $Page::($page_obj,page_id)

  # top & botttom Canvas dimensions
    set top_canvas_dim(0) 100
    set top_canvas_dim(1) 100
    set bot_canvas_dim(0) 1000
    set bot_canvas_dim(1) 1000

  set fy [frame $page_id.f]
  pack $fy -fill both -expand yes

  set canvas_frame [frame $fy.f]
  pack $canvas_frame -expand yes -fill both
  set Page::($page_obj,canvas_frame) $canvas_frame
  Page::CreateCanvas $page_obj top_canvas_dim bot_canvas_dim

  set top_canvas  $Page::($page_obj,top_canvas)
  set frm1 [frame $top_canvas.fm1]
  set frm2 [frame $top_canvas.fm2]

  pack $frm1 $frm2 -side left -padx 130 -pady 20 -fill both -expand yes

  # Widgets in the tp canvas
  label $frm1.bit1 -height 1 -width 2 -background pink -relief sunken -bd 2
  label $frm1.l1 -text " Output - Active        "
  label $frm2.l2 -text " Output - Suppressed "
  label $frm2.bit2 -height 1 -width 2 -background #c0c0ff -relief raised -bd 2

  pack $frm1.l1 $frm1.bit1 -side right -padx 4 -pady 8
  pack $frm2.bit2 $frm2.l2 -side left -padx 4 -pady 8
}

#===============================================================================
#  This procedure adds the options to the popup menu. It activates the
#  popup options only when the cursor is on the address icons.
#
#        Inputs   :  Mseq Page Object
#
#        Outputs  :  popup options
#
#===============================================================================
proc UI_PB_mseq_PopupSetOptions { page_obj x y } {
#===============================================================================
   if {![info exists Page::($page_obj,popup_flag)]} \
   {
     set Page::($page_obj,popup_flag) 0
   }

   set popup_flag $Page::($page_obj,popup_flag)
   set menu $Page::($page_obj,menu)

   if {$popup_flag == 0} \
   {
     $menu delete 0 end
     $menu add command -label "New" -state normal \
                               -command "UI_PB_mseq_CreateUDIcon"
     $menu add command -label "Edit" -state disabled
     $menu add sep
     $menu add command -label "Delete" -state disabled
     $menu add sep
     $menu add command -label "Activate All" -state normal \
                               -command "UI_PB_mseq_ActivateAllIcons $page_obj"

   } else { ;# On element

     $menu delete 0 end
     $menu add command -label "New"  -state normal \
                               -command "UI_PB_mseq_CreateUDIcon"
     $menu add command -label "Edit" -state normal \
                               -command ""
     $menu add sep
     $menu add command -label "Delete" -command ""
     $menu add sep
     $menu add command -label "Activate All" -state normal \
                               -command "UI_PB_mseq_ActivateAllIcons $page_obj"

     set Page::($page_obj,popup_flag) 0
   }

  # Utilize end_drag callback to swap addresses when needed.
   if [info exists Page::($page_obj,being_dragged)] \
   {
     if {$Page::($page_obj,being_dragged) == \
                   $Page::($page_obj,drag_sensitivity)} \
     {
       UI_PB_mseq_ItemEndDrag $page_obj
     }
   }

  # Position popup menu per longest label + paddings
   set fnt [lindex [$menu config -font] end]
   set dx [font measure $fnt "Activate All"]
   tk_popup $menu [expr $x + $dx/2 + 15] [expr $y + 13] 0
}

#===============================================================================
#  It is a callback procedure attached to the third mouse button & bind to the
#  address icon.
#===============================================================================
proc UI_PB_mseq_PopupMenu { page_obj } {
#===============================================================================

   set Page::($page_obj,popup_flag) 1
}

#===============================================================================
#  This procedure pops up the under construction message, when the create
#  option is selected from the popup menu. 
#===============================================================================
proc UI_PB_mseq_CreateUDIcon {} {
#===============================================================================

#PoP-Up Message
        tk_messageBox -type ok -icon error\
        -message "Under construction"

}

#===============================================================================
# This is a callback procedure attached to the popup menu option "Activate All"
# It bascially activates all the icons .. by sunkening the icons
#
#          Inputs   :  Mseq Page Object
#
#          Outputs  :  Activates all the addresses
#
#===============================================================================
proc UI_PB_mseq_ActivateAllIcons { page_obj } {
#===============================================================================
   foreach elem_obj $Page::($page_obj,mseq_addr_list) \
   {
     if {$address::($elem_obj,word_status)} \
     {
       $address::($elem_obj,icon_id) configure \
                       -relief sunken -background pink
       set address::($elem_obj,word_status) 0
     }
   }
}

#==============================================================================
# This proceduer stores the master sequence index of the address in the
# address object.
#
#          Inputs  :  Mseq page object
#
#          Outputs :  master sequence index is stored as an attribute
#                     of address object.
#
#==============================================================================
proc UI_PB_mseq_ApplyMastSeq { PAGE_OBJ } {
#==============================================================================
  upvar $PAGE_OBJ page_obj

  if { [info exists Page::($page_obj,mseq_addr_list)]} \
  {
    set index 0
    foreach addr_obj $Page::($page_obj,mseq_addr_list) \
    {
       set address::($addr_obj,seq_no) $index
       incr index
    }
  }
}

#==============================================================================
#  This proceduer deletes all the widgets of the master sequence bot canvas.
#==============================================================================
proc UI_PB_mseq_DeleteMastSeqElems { PAGE_OBJ } {
#==============================================================================
  upvar $PAGE_OBJ page_obj
  set bot_canvas $Page::($page_obj,bot_canvas)

  # Deletes the icon, divided line & rectangle behind the icon
    foreach elem_obj $Page::($page_obj,mseq_addr_list) \
    {
       $bot_canvas delete $address::($elem_obj,image_id)     
       $bot_canvas delete $address::($elem_obj,divi_id)     
       $bot_canvas delete $address::($elem_obj,rect_id)     
    }

  # Deletes the divided lines at the end of the row
    foreach divi_id $Page::($page_obj,divi_id) \
    {
       $bot_canvas delete $divi_id
    }
  unset Page::($page_obj,mseq_addr_list)
}

#==============================================================================
#  This is a callback procedure attached to the restore action button of
#  word sequence page. It bascially restores the master sequence.
#
#==============================================================================
proc UI_PB_mseq_RestoreCallBack { page_obj } {
#===============================================================================
   UI_PB_mseq_DeleteMastSeqElems page_obj

   # Gets the address object list from the data base
     PB_adr_RetAddressObjList add_obj_list

   # sets the restore data as the current data of an address
     foreach addr_obj $add_obj_list \
     {
        array set add_mseq_attr $address::($addr_obj,rest_mseq_attr)
        address::SetMseqAttr $addr_obj add_mseq_attr
        unset add_mseq_attr
     }

   # Sorts the address according to the restore sequence
     UI_PB_mseq_SortAddresses add_obj_list

   # Displays all the addresses in the page
     UI_PB_mseq_CreateComponents page_obj add_obj_list
}

#===============================================================================
# This is a callback proceduer attached to the Defualt action button of the
# Word Sequence page. It basically brings up the default master sequence.
#===============================================================================
proc UI_PB_mseq_DefaultCallBack { page_obj } {
#===============================================================================

   # Deletes the master sequence widgets
     UI_PB_mseq_DeleteMastSeqElems page_obj

   # Gets the address object list from data base
     PB_adr_RetAddressObjList add_obj_list

   # Sets default data as the current data
     foreach addr_obj $add_obj_list \
     {
        array set add_mseq_attr $address::($addr_obj,def_mseq_attr)
        address::SetMseqAttr $addr_obj add_mseq_attr
        unset add_mseq_attr
     }

   # Sorts the address according to the default sequence
     UI_PB_mseq_SortAddresses add_obj_list

   # Displays the addresses as icons in the page
     UI_PB_mseq_CreateComponents page_obj add_obj_list
}

#===============================================================================
#  This proceduer displays each address as an icon in the mseq page. 
#  It uses the leader of an address to get the image name and the
#  representive mom variable for the text that goes with the icon.
#===============================================================================
proc UI_PB_mseq_CreateComponents { PAGE_OBJ ADD_OBJ_LIST } {
#===============================================================================
  upvar $PAGE_OBJ page_obj
  upvar $ADD_OBJ_LIST add_obj_list
  global tixOption

  set bot_canvas $Page::($page_obj,bot_canvas)
  set h_cell 30       ;# cell height
  set w_cell 52       ;# cell width
  set w_divi 4        ;# divider width
  set x_orig 100      ;# upper-left corner of 1st cell
  set y_orig 75
  set cell_color paleturquoise
  set divi_color turquoise
  set no_rowelem 12

  #Create several compound images in the canvas
  set total_elems [llength $add_obj_list]

   set rows [expr $total_elems / $no_rowelem]
   if { [expr $total_elems % $no_rowelem] } \
   {
       incr rows
   } 
   
  #----------------------------------------
  # Create rectangular cells to hold icons
  #----------------------------------------
   set x0 $x_orig
   set y0 $y_orig
   set yc [expr $y0 + [expr $h_cell / 2]]
   set count 0

   for {set no 0} {$no < $rows} {incr no} \
   {
      set ii 0
      while {$ii < $no_rowelem && $count < $total_elems} \
      {
          set addr_obj [lindex $add_obj_list $count]
          address::readMseqAttr $addr_obj addr_mseq_attr
          lappend mseq_addr_list $addr_obj

          #--------------
          # Divider cell
          #--------------
           set y1 [expr $y0 + $h_cell]
           set x1 [expr $x0 + $w_divi]
     
           lappend corner $x0 $y0 $x1 $y1
           set address::($addr_obj,divi_dim) $corner
           unset corner
     
           set address::($addr_obj,divi_id) [UI_PB_com_CreateRectangle \
                    $bot_canvas $x0 $y0 $x1 $y1 $divi_color $divi_color]
          #--------------
          # Holding cell
          #--------------
           set x0 $x1
           set x1 [expr $x0 + $w_cell]
     
           lappend corner $x0 $y0 $x1 $y1
           set address::($addr_obj,rect_dim) $corner
           unset corner

           set address::($addr_obj,rect_id) [UI_PB_com_CreateRectangle \
                $bot_canvas $x0 $y0 $x1 $y1 $cell_color $divi_color]

          # Place icons into cell
           set xc [expr [expr $x0 + $x1] / 2]

          # Creates a image
            UI_PB_com_RetImageAppdText addr_obj addr_mseq_attr(0) \
                                       temp_image_name addr_app_text

           set image_id [UI_PB_blk_CreateIcon $bot_canvas $temp_image_name \
                                  $addr_app_text]
           set icon_id [$bot_canvas create image  $xc $yc \
                           -image $image_id -tag movable]
           unset temp_image_name
           unset addr_app_text

           set address::($addr_obj,image_id) $icon_id
           set address::($addr_obj,icon_id) $image_id
           set address::($addr_obj,xc) $xc
           set address::($addr_obj,yc) $yc

           if { $address::($addr_obj,word_status) == 0} \
           {
               $image_id configure -relief sunken -background pink
           } else \
           {
               $image_id configure -relief raised -background #c0c0ff
           }
           set x0 $x1
           incr count
           incr ii
       }

       #--------------
       # Last divider
       #--------------
       if { $ii != 0} \
       {
          set x1 [expr $x0 + $w_divi]
          lappend corner $x0 $y0 $x1 $y1
          lappend divi_dim $corner
          unset corner

          lappend divi_id [UI_PB_com_CreateRectangle $bot_canvas $x0 $y0 \
                           $x1 $y1 $divi_color $divi_color]
          set x0 $x_orig
          set y0 [expr $y0 + $h_cell + 70]
          set yc [expr $y0 + [expr $h_cell / 2]]
       }
       if { $count == $total_elems } { break }
    }
    
    set Page::($page_obj,divi_dim) $divi_dim
    set Page::($page_obj,divi_id) $divi_id
    unset divi_dim
    unset divi_id
   
    if {[info exist mseq_addr_list]} \
    {
       set Page::($page_obj,mseq_addr_list) $mseq_addr_list
       unset mseq_addr_list
    }

  # Binds the elements of master sequence with mouse actions
    UI_PB_mseq_BindProcs page_obj
}

#===============================================================================
#  This proceduer binds all the mouse buttons with the callbacks. These
#  proceduers are triggered when the cursor is in the bottom canvas only.
#===============================================================================
proc UI_PB_mseq_BindProcs { PAGE_OBJ } {
#===============================================================================
  upvar $PAGE_OBJ page_obj

  set bot_canvas $Page::($page_obj,bot_canvas)

  #---------------------
  # Bind icons to mouse
  #---------------------
   $bot_canvas bind movable <1>   "UI_PB_mseq_ItemStartDrag $page_obj %x %y"

   $bot_canvas bind movable <B1-Motion>  "UI_PB_mseq_ItemDrag $page_obj %x %y"

   $bot_canvas bind movable <ButtonRelease-1> "UI_PB_mseq_ItemEndDrag $page_obj"

   $bot_canvas bind movable <3>     "UI_PB_mseq_PopupMenu $page_obj"

   $bot_canvas bind movable <Enter> "UI_PB_mseq_ItemFocusOn $page_obj %x %y"

   $bot_canvas bind movable <Leave>  "UI_PB_mseq_ItemFocusOff  $page_obj"
}

#==========================================================================
proc UI_PB_mseq_HighLightDividers { page_obj x y } {
#==========================================================================
  set bot_canvas $Page::($page_obj,bot_canvas)
  set focus_addrelem 0
  set check_type "divi_dim"

  UI_PB_mseq_GetBlkElemObjFromCursorPos page_obj focus_addrelem \
                                        $check_type $x $y

  set Page::($page_obj,in_focus_divi_obj) $focus_addrelem

  if { $Page::($page_obj,in_focus_divi_obj) } \
  {
     set Page::($page_obj,add_act) "insert"
  }

  if { $Page::($page_obj,in_focus_divi_obj) != \
           $Page::($page_obj,out_focus_divi_obj) } \
  {
      UI_PB_mseq_UnHighLightCellDividers page_obj

      if { !$Page::($page_obj,in_focus_divi_obj) } { return }

      set cell_highlight_color navyblue
      set in_focus_obj $Page::($page_obj,in_focus_divi_obj)
    
      set Page::($page_obj,divi_color) [lindex [$bot_canvas itemconfigure \
                 $address::($in_focus_obj,divi_id) -fill] end]
      $bot_canvas itemconfigure $address::($in_focus_obj,divi_id) \
                 -fill $cell_highlight_color
      set Page::($page_obj,out_focus_divi_obj) \
                        $Page::($page_obj,in_focus_divi_obj)
  }

}

#==========================================================================
proc UI_PB_mseq_GetBlkElemObjFromCursorPos { PAGE_OBJ ADDR_ELEM_OBJ \
                                             check_type x y } {
#==========================================================================
  upvar $PAGE_OBJ page_obj
  upvar $ADDR_ELEM_OBJ addr_elem_obj
  set h_cell 40

  #----------------------
  # Locate in-focus cell
  #----------------------
  foreach addr_obj $Page::($page_obj,mseq_addr_list) \
  {
     set corner $address::($addr_obj,$check_type)
     if {$x >= [lindex $corner 0] && $x < [lindex $corner 2] && \
         $y >= [expr [lindex $corner 1] - $h_cell] && \
         $y < [expr [lindex $corner 3] + $h_cell]} \
     {
        set addr_elem_obj $addr_obj
        break
     }
  }
}

#==========================================================================
proc UI_PB_mseq_UnHighLightCellDividers { PAGE_OBJ } {
#==========================================================================
  upvar $PAGE_OBJ page_obj
  set bot_canvas $Page::($page_obj,bot_canvas)

   if { $Page::($page_obj,out_focus_cell_obj) } \
   {
      set addr_obj $Page::($page_obj,out_focus_cell_obj)
      $bot_canvas itemconfigure $address::($addr_obj,rect_id) \
                      -fill $Page::($page_obj,cell_color)
      set Page::($page_obj,out_focus_cell_obj) 0
   }

   if { $Page::($page_obj,out_focus_divi_obj) } \
   {
       set addr_obj $Page::($page_obj,out_focus_divi_obj)
       $bot_canvas itemconfigure $address::($addr_obj,divi_id) \
                       -fill $Page::($page_obj,divi_color)
       set Page::($page_obj,out_focus_divi_obj) 0
   }

   if { [info exists Page::($page_obj,balloon)] == 1} \
   {
       $bot_canvas delete $Page::($page_obj,balloon)
       $bot_canvas delete $Page::($page_obj,ball_text)
   }
}

#==========================================================================
proc UI_PB_mseq_ItemFocusOn { page_obj x y} {
#==========================================================================
   global paOption
   global gPB_help_tips

   set bot_canvas $Page::($page_obj,bot_canvas)
   set x [$bot_canvas canvasx $x]
   set y [$bot_canvas canvasy $y]
   set focus_addrelem 0

   set check_type "rect_dim"
   UI_PB_mseq_GetBlkElemObjFromCursorPos page_obj focus_addrelem \
                                   $check_type $x $y

   set Page::($page_obj,in_focus_cell_obj) $focus_addrelem
   if { $Page::($page_obj,in_focus_cell_obj) } \
   {
     set Page::($page_obj,add_act) "swap"
   }  

  #---------------------------------------
  # Restore balloon to the dragged cell's
  # when no other cell is in-focus.
  #---------------------------------------
   if {$gPB_help_tips(state)} \
   {
     if {!$Page::($page_obj,in_focus_cell_obj)} \
     {
       global dragged_balloon
       if [info exists dragged_balloon] \
       {
         PB_init_balloons -color $paOption(balloon)
         set gPB_help_tips($bot_canvas) $dragged_balloon
       }
     }
   }

  #-----------------------------
  # Highlight new in-focus cell
  #-----------------------------
   if { $Page::($page_obj,in_focus_cell_obj) != \
        $Page::($page_obj,out_focus_cell_obj) } \
   {
     UI_PB_mseq_UnHighLightCellDividers page_obj

     if {$gPB_help_tips(state)} \
     {
       PB_init_balloons -color $paOption(balloon)
     }

   # Change balloon background if the in-focus cell isn't the one being dragged.
     if {$gPB_help_tips(state)} \
     {
       global dragged_cell
       if [info exists dragged_cell] \
       {
         if {$Page::($page_obj,in_focus_cell_obj) != $dragged_cell} \
         {
           PB_init_balloons -color white
         }
       }
     }

    # No cell's in-focus, nothing else to do...
     if {!$Page::($page_obj,in_focus_cell_obj)} { return }

     set cell_highlight_color navyblue
     set in_focus_obj $Page::($page_obj,in_focus_cell_obj)

     set Page::($page_obj,cell_color) [lindex [$bot_canvas itemconfigure \
                $address::($in_focus_obj,rect_id) -fill] end]
     $bot_canvas itemconfigure $address::($in_focus_obj,rect_id) \
                    -fill $cell_highlight_color

     if {$gPB_help_tips(state)} \
     {
       UI_PB_mseq_CreateBalloon page_obj
     }
     set Page::($page_obj,out_focus_cell_obj) \
                    $Page::($page_obj,in_focus_cell_obj)
   }
}

#==========================================================================
proc UI_PB_mseq_CreateBalloon { PAGE_OBJ } {
#==========================================================================
   upvar $PAGE_OBJ page_obj

    set c $Page::($page_obj,bot_canvas)
    set in_focus_obj $Page::($page_obj,in_focus_cell_obj)
    set desc $address::($in_focus_obj,word_desc)
    set add_leader $address::($in_focus_obj,add_leader)

    set add_rep_mom_var $address::($in_focus_obj,rep_mom_var)
    PB_com_MapMOMVariable in_focus_obj add_rep_mom_var elem_app_text
    PB_int_ApplyFormatAppText in_focus_obj elem_app_text

    append word_desc $add_leader $elem_app_text - $desc
    global gPB_help_tips
    set gPB_help_tips($c) $word_desc
    unset word_desc
}

#==============================================================================
proc UI_PB_mseq_ItemFocusOff { page_obj } {
#===============================================================================
  set bot_canvas $Page::($page_obj,bot_canvas)

  # Restore cell color
   if { $Page::($page_obj,out_focus_cell_obj) } \
   {
      set out_focus_obj $Page::($page_obj,out_focus_cell_obj)
      $bot_canvas itemconfigure $address::($out_focus_obj,rect_id) \
                  -fill $Page::($page_obj,cell_color)
      if { [info exists Page::($page_obj,balloon)] == 1} \
      {
          $bot_canvas delete $Page::($page_obj,balloon)
          $bot_canvas delete $Page::($page_obj,ball_text)
      }
   }

  # Delete balloon
   global gPB_help_tips
   if {$gPB_help_tips(state)} \
   {
     if [info exists gPB_help_tips($bot_canvas)] {
       unset gPB_help_tips($bot_canvas)
     }
     PB_cancel_balloon
   }

   set Page::($page_obj,in_focus_cell_obj) 0
   set Page::($page_obj,out_focus_cell_obj) 0
}

#===============================================================================
proc UI_PB_mseq_ItemStartDrag { page_obj x y} {
#===============================================================================
   set bot_canvas $Page::($page_obj,bot_canvas)
   set Page::($page_obj,being_dragged) 0

  # Highlight current icon
   $bot_canvas raise current
   set Page::($page_obj,x_icon) [$bot_canvas find withtag current]

   set origin_x [$bot_canvas canvasx $x]
   set origin_y [$bot_canvas canvasy $y]

   set Page::($page_obj,last_x)   $origin_x
   set Page::($page_obj,last_y)   $origin_y

  # Highlight in-focus cell
    UI_PB_mseq_ItemFocusOn $page_obj $x $y

  # Remember what's being dragged.
   global gPB_help_tips
   global dragged_balloon dragged_cell
   if {$gPB_help_tips(state)} \
   {
     set dragged_balloon $gPB_help_tips($bot_canvas)
     set dragged_cell $Page::($page_obj,in_focus_cell_obj)
   }
}

#===========================================================================
proc UI_PB_mseq_ItemDrag { page_obj x y} {
#===========================================================================
  if {$Page::($page_obj,being_dragged) < $Page::($page_obj,drag_sensitivity)} \
  {
      incr Page::($page_obj,being_dragged)
  }

  set bot_canvas $Page::($page_obj,bot_canvas)
  set xc [$bot_canvas canvasx $x]
  set yc [$bot_canvas canvasy $y]

  # Translate element
    $bot_canvas move current [expr $xc - $Page::($page_obj,last_x)] \
                             [expr $yc - $Page::($page_obj,last_y)]

  set Page::($page_obj,last_x) $xc
  set Page::($page_obj,last_y) $yc

  # Highlight in-focus cell
    UI_PB_mseq_ItemFocusOn $page_obj $x $y
    UI_PB_mseq_HighLightDividers $page_obj $x $y

  # Draw a connecting line from current object to in-focus cell
    UI_PB_mseq_DrawConnectLine page_obj

  # To cover the connecting line
   if { $Page::($page_obj,in_focus_cell_obj) } \
   {
      set in_focus_obj $Page::($page_obj,in_focus_cell_obj)
      $bot_canvas raise $address::($in_focus_obj,rect_id)
   }

  # To cover the connecting line
   if { $Page::($page_obj,in_focus_divi_obj) } \
   {
      set in_focus_obj $Page::($page_obj,in_focus_divi_obj)
      $bot_canvas raise $address::($in_focus_obj,divi_id)
   }
   $bot_canvas raise movable
}

#===============================================================================
proc UI_PB_mseq_DrawConnectLine { PAGE_OBJ } {
#===============================================================================
  upvar $PAGE_OBJ page_obj
   global paOption

   set bot_canvas $Page::($page_obj,bot_canvas)

  # Make sure there's a cell in-focus.
   if {$Page::($page_obj,in_focus_cell_obj) || \
       $Page::($page_obj,in_focus_divi_obj)} \
   {
     set vtx {}
     if { $Page::($page_obj,in_focus_cell_obj)} \
     {
       set in_focus_obj $Page::($page_obj,in_focus_cell_obj)
       set coords [$bot_canvas coords $address::($in_focus_obj,rect_id)]
     } else \
     {
       set in_focus_obj $Page::($page_obj,in_focus_divi_obj)
       set coords [$bot_canvas coords $address::($in_focus_obj,divi_id)]
     }

    # Center of cell
     set x0 [lindex $coords 0]
     set y0 [lindex $coords 1]
     set x1 [lindex $coords 2]
     set y1 [lindex $coords 3]
     lappend vtx [expr [expr $x0 + $x1] / 2] [expr [expr $y0 + $y1] / 2]

    # Center of icon in action
     set coords [$bot_canvas coords current]
     set x1 [expr [lindex $coords 0] + 1]
     set y1 [lindex $coords 1]
     lappend vtx $x1 $y1
     set x1 [expr $x1 - 2]
     lappend vtx $x1 $y1

    # Draw line
     if {[$bot_canvas gettags connect_line] == "connect_line"} {

       eval {$bot_canvas coords connect_line} $vtx
    
     } else {
    
       eval {$bot_canvas create poly} $vtx {-fill $paOption(focus) \
                                            -outline $paOption(focus) \
                                            -tag connect_line}
     }
   } else {

     if {[$bot_canvas gettags connect_line] == "connect_line"} \
     {
       $bot_canvas delete connect_line
     }
   }
}

#===============================================================================
proc UI_PB_mseq_ItemEndDrag { page_obj } {
#===============================================================================
   set bot_canvas $Page::($page_obj,bot_canvas)

   UI_PB_mseq_UnHighLightCellDividers page_obj

  # Delete connecting line
   $bot_canvas delete connect_line

  # Find source cell number & id
   foreach addr_obj $Page::($page_obj,mseq_addr_list) \
   {
     if {$address::($addr_obj,image_id) == $Page::($page_obj,x_icon)} \
     {
       set Page::($page_obj,source_elem_obj) $addr_obj
       break;
     }
   }

   if {$Page::($page_obj,being_dragged) < $Page::($page_obj,drag_sensitivity)} \
   {
     set im [$bot_canvas itemconfigure current -image]
     set relief_status [[lindex $im end] cget -relief]

     switch $relief_status \
     {
       raised {
                [lindex $im end] configure -relief sunken \
                                           -background pink 
                 set address::($addr_obj,word_status) 0
              }
 
       sunken {
                [lindex $im end] configure -relief raised \
                                           -background #c0c0ff
                set address::($addr_obj,word_status) 1
              }
     }
   }

   if {![string compare $Page::($page_obj,add_act) "swap"] } \
   {
      UI_PB_mseq_SwapCells page_obj
   } elseif { ![string compare $Page::($page_obj,add_act) "insert"] } \
   {
      UI_PB_mseq_InsertCell page_obj
   } else \
   {
      UI_PB_mseq_ReturnCell page_obj
   }

   set Page::($page_obj,add_act)            0
   set Page::($page_obj,x_icon)             0
   set Page::($page_obj,in_focus_cell_obj)  0
   set Page::($page_obj,out_focus_cell_obj) 0
   set Page::($page_obj,in_focus_divi_obj)  0
   set Page::($page_obj,out_focus_divi_obj) 0

  # Cleanup balloon stuff
   global gPB_help_tips

   if {$gPB_help_tips(state)} \
   {
     if [info exists gPB_help_tips($bot_canvas)] {
       unset gPB_help_tips($bot_canvas)
     }
     PB_cancel_balloon

     global dragged_balloon dragged_cell
     if [info exists dragged_balloon] {unset dragged_balloon}
     if [info exists dragged_cell] {unset dragged_cell}
   }
   set Page::($page_obj,being_dragged) 0
}

#===============================================================================
proc UI_PB_mseq_ReturnCell { PAGE_OBJ  } {
#===============================================================================
   upvar $PAGE_OBJ page_obj
   set bot_canvas $Page::($page_obj,bot_canvas)
   set source_elem_obj $Page::($page_obj,source_elem_obj)

   $bot_canvas coords $address::($source_elem_obj,image_id) \
      $address::($source_elem_obj,xc) $address::($source_elem_obj,yc)
}

#===============================================================================
proc UI_PB_mseq_SwapCells { PAGE_OBJ } {
#===============================================================================
  upvar $PAGE_OBJ page_obj
  set bot_canvas $Page::($page_obj,bot_canvas)

  set source_elem_obj $Page::($page_obj,source_elem_obj)
  set target_elem_obj $Page::($page_obj,in_focus_cell_obj)

  if {!$target_elem_obj}\
  {
     set target_elem_obj $source_elem_obj
  }

  # Relocate icons to new positions
   $bot_canvas coords $address::($source_elem_obj,image_id) \
          $address::($target_elem_obj,xc) $address::($target_elem_obj,yc)
   $bot_canvas coords $address::($target_elem_obj,image_id) \
          $address::($source_elem_obj,xc) $address::($source_elem_obj,yc)

  # Exchange data
   # center of the icon
    set x $address::($source_elem_obj,xc)
    set y $address::($source_elem_obj,yc)
    set address::($source_elem_obj,xc) $address::($target_elem_obj,xc)
    set address::($source_elem_obj,yc) $address::($target_elem_obj,yc)
    set address::($target_elem_obj,xc) $x
    set address::($target_elem_obj,yc) $y

   # Corners of cell and divider
    set rect_corner $address::($source_elem_obj,rect_dim)
    set divi_corner $address::($source_elem_obj,divi_dim)
    set address::($source_elem_obj,rect_dim) \
                     $address::($target_elem_obj,rect_dim)
    set address::($source_elem_obj,divi_dim) \
                     $address::($target_elem_obj,divi_dim)
    set address::($target_elem_obj,rect_dim) $rect_corner
    set address::($target_elem_obj,divi_dim) $divi_corner

  # rect and divider ids
    set rect_id $address::($source_elem_obj,rect_id)
    set divi_id $address::($source_elem_obj,divi_id)
    set address::($source_elem_obj,rect_id) $address::($target_elem_obj,rect_id)
    set address::($source_elem_obj,divi_id) $address::($target_elem_obj,divi_id)
    set address::($target_elem_obj,rect_id) $rect_id
    set address::($target_elem_obj,divi_id) $divi_id

    set temp_elem_obj_list $Page::($page_obj,mseq_addr_list)
    unset Page::($page_obj,mseq_addr_list)

    set source_index [lsearch $temp_elem_obj_list $source_elem_obj]
    set target_index [lsearch $temp_elem_obj_list $target_elem_obj]

    set temp_elem_obj_list [lreplace $temp_elem_obj_list $source_index \
                             $source_index $target_elem_obj]
    set temp_elem_obj_list [lreplace $temp_elem_obj_list $target_index \
                             $target_index $source_elem_obj]
    set Page::($page_obj,mseq_addr_list) $temp_elem_obj_list
    unset temp_elem_obj_list
}

#=============================================================================
proc UI_PB_mseq_InsertCell { PAGE_OBJ } {
#=============================================================================
  upvar $PAGE_OBJ page_obj
  set bot_canvas $Page::($page_obj,bot_canvas)

  set mseq_addr_list $Page::($page_obj,mseq_addr_list)
  set source_elem_obj $Page::($page_obj,source_elem_obj)
  set target_elem_obj $Page::($page_obj,in_focus_divi_obj)

  if {$target_elem_obj == 0} { set target_elem_obj $source_elem_obj }

  set source_cell_num [lsearch $mseq_addr_list $source_elem_obj]
  set target_cell_num [lsearch $mseq_addr_list $target_elem_obj]

 # if the source cell num is less than target then interchange the
 # object ids
  if {$target_cell_num > $source_cell_num} \
  {
      set expression { set test [expr $ii > $source_cell_num ] }
      incr target_cell_num -1
      set inc_num -1  
  } else \
  {
      set expression { set test [expr $ii < $source_cell_num ] }
      set inc_num 1
  }

 # Sets all the attributes of source elem to temp variables
   set source_xc $address::($source_elem_obj,xc)
   set source_yc $address::($source_elem_obj,yc)
   set source_rect_dim $address::($source_elem_obj,rect_dim)
   set source_divi_dim $address::($source_elem_obj,divi_dim)
   set source_rect_id $address::($source_elem_obj,rect_id)
   set source_divi_id $address::($source_elem_obj,divi_id)

    set temp_elem_obj $source_elem_obj
    for {set ii $target_cell_num} { [eval $expression] } {incr ii $inc_num} \
    {
        set elem_obj [lindex $mseq_addr_list $ii]
        $bot_canvas coords $address::($temp_elem_obj,image_id) \
                   $address::($elem_obj,xc) $address::($elem_obj,yc)
        set address::($temp_elem_obj,xc) $address::($elem_obj,xc)
        set address::($temp_elem_obj,yc) $address::($elem_obj,yc)
        set address::($temp_elem_obj,rect_dim) $address::($elem_obj,rect_dim)
        set address::($temp_elem_obj,divi_dim) $address::($elem_obj,divi_dim)
        set address::($temp_elem_obj,rect_id) $address::($elem_obj,rect_id)
        set address::($temp_elem_obj,divi_id) $address::($elem_obj,divi_id)
        
        set mseq_addr_list [lreplace $mseq_addr_list $ii $ii $temp_elem_obj]
        set temp_elem_obj $elem_obj
    }

    set address::($temp_elem_obj,xc) $source_xc
    set address::($temp_elem_obj,yc) $source_yc
    set address::($temp_elem_obj,rect_dim) $source_rect_dim
    set address::($temp_elem_obj,divi_dim) $source_divi_dim
    set address::($temp_elem_obj,rect_id) $source_rect_id
    set address::($temp_elem_obj,divi_id) $source_divi_id
    $bot_canvas coords $address::($temp_elem_obj,image_id) \
          $source_xc $source_yc
    set mseq_addr_list [lreplace $mseq_addr_list $source_cell_num \
                               $source_cell_num $temp_elem_obj]
    
    unset Page::($page_obj,mseq_addr_list)
    set Page::($page_obj,mseq_addr_list) $mseq_addr_list
    unset mseq_addr_list
}

#===============================================================================
#  This proceduer sorts the addresses according to the master sequence.
#  The sequence number is stored as an attribute of an address object.
#
#        Inputs   :  Address object list
#
#        Outputs  :  Sorted address object list
#
#===============================================================================
proc UI_PB_mseq_SortAddresses { ADD_OBJ_LIST } {
#===============================================================================
  upvar $ADD_OBJ_LIST add_obj_list

  foreach add_obj $add_obj_list \
  {
    if {[string compare $address::($add_obj,rep_mom_var) ""]} \
    {
       lappend new_add_list $add_obj
    }
  }

  set add_obj_list $new_add_list
  set no_elements [llength $add_obj_list]
  for {set ii 0} {$ii < [expr $no_elements - 1]} {incr ii} \
  {
     for {set jj [expr $ii + 1]} {$jj < $no_elements} {incr jj} \
     {
         set addr_ii_obj [lindex $add_obj_list $ii]
         set addr_ii_indx $address::($addr_ii_obj,seq_no)

         set addr_jj_obj [lindex $add_obj_list $jj]
         set addr_jj_indx $address::($addr_jj_obj,seq_no)
         if {$addr_jj_indx < $addr_ii_indx} \
         {
            set add_obj_list [lreplace $add_obj_list $ii $ii $addr_jj_obj]
            set add_obj_list [lreplace $add_obj_list $jj $jj $addr_ii_obj]
         }
     }
  }
}

