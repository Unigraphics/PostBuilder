#==============================================================================
#                     UI_PB_BLOCK.TCL
#==============================================================================
##############################################################################
# Description                                                                #
#     This file contains all functions dealing with the creation of          #
#     ui elements for Block page.                                            #
#                                                                            #
# Revisions                                                                  #
#                                                                            #
#   Date        Who       Reason                                             #
# 01-feb-1999   mnb       Initial                                            #
# 02-Jun-1999   mnb       Code Integration                                   #
# 04-Jun-1999   mnb       Added pb_ to the imaged names                      #
# 14-Jun-1999   gsl       Clean up balloon when a block element is trashed.  #
# 16-Jun-1999   mnb       Updates the Combobox, when block page is selected  #
# 28-Jun-1999   mnb       Text can be added multiple times to a block        #
# 29-Jun-1999   mnb       Changed text background color                      #
# 01-Jul-1999   mnb       Text can be positioned at any position in a block  #
# 06-Jul-1999   mnb       Brings up a text entry dialog, when a text address #
#                         is added to a block.                               #
# 07-Sep-1999   mnb       Editting Block Element Address & New toplevel      #
#                         Block Page                                         #
# 21-Sep-1999   mnb       Added Modality attribute to block element          #
# 18-Oct-1999   gsl       Minor changes                                      #
# 22-Oct-1999   gsl       Added "Delete" option to the popup menu.           #
# 17-Nov-1999   gsl       Submitted for phase-22.                            #
#                                                                            #
# $HISTORY$                                                                  #
#                                                                            #
##############################################################################

#===============================================================================
proc UI_PB_Def_Block {book_id blk_page_obj} {
#===============================================================================
  global tixOption
  global paOption

# Widget ids
  global popupvar
  set blk_elm_attr(0) 0
  set blk_elm_attr(1) 0
  set blk_elm_attr(2) 0

  set Page::($blk_page_obj,page_id) [$book_id subwidget \
                            $Page::($blk_page_obj,page_name)]

# Sets the block page attributes
  UI_PB_blk_SetPageAttributes blk_page_obj

# Creates the pane for page block
  Page::CreatePane $blk_page_obj

# Adds the buttons create cut and paste to the left pane
  UI_PB_blk_AddComponentsLeftPane blk_page_obj

# Creates the Tree 
  Page::CreateTree $blk_page_obj
  UI_PB_blk_CreateTreeElements blk_page_obj

# Creates the top and bottom canvases
  set top_canvas_dim(0) 80
  set top_canvas_dim(1) 400
  set bot_canvas_dim(0) 2000
  set bot_canvas_dim(1) 1000
  Page::CreateCanvas $blk_page_obj top_canvas_dim \
                     bot_canvas_dim
  UI_PB_blk_AddTopFrameItems blk_page_obj
  UI_PB_blk_AddActionButtons blk_page_obj

 # Adds the Add and Trash buttons to the top canvas
  set Page::($blk_page_obj,add_name) " Add Word "
  Page::CreateAddTrashinCanvas $blk_page_obj
  Page::CreateMenu $blk_page_obj

  #Binds the Add button
   UI_PB_blk_AddBindProcs blk_page_obj
   set top_canvas $Page::($blk_page_obj,top_canvas)
   $top_canvas bind add_movable <B1-Motion> \
                        "UI_PB_blk_ItemDrag1 $blk_page_obj \
                                               %x %y"
   $top_canvas bind add_movable <ButtonRelease-1> \
                        "UI_PB_blk_ItemEndDrag1 $blk_page_obj \
                                               %x %y"
  # PopupMenu bind call
    UI_PB_blk_CreatePopupMenu blk_page_obj
    set Page::($blk_page_obj,blk_WordNameList) ""
}

#===============================================================
proc UI_PB_blk_SetPageAttributes { PAGE_OBJ } {
#===============================================================
  upvar $PAGE_OBJ page_obj

  set Page::($page_obj,block_popup_flag) 0
  set Page::($page_obj,trl_flag) 0
  set Page::($page_obj,lead_flag) 0
  set Page::($page_obj,fmt_flag) 0
  set Page::($page_obj,h_cell) 30       ;# cell height
  set Page::($page_obj,w_cell) 62       ;# cell width
  set Page::($page_obj,w_divi) 4        ;# divider width
  set Page::($page_obj,rect_region) 80  ;# Block rectangle region
  set Page::($page_obj,x_orig) 60       ;# upper-left corner of 1st cell
  set Page::($page_obj,y_orig) 120
  set Page::($page_obj,add_flag) 0
}

#========================================================================
proc UI_PB_blk_AddComponentsLeftPane {PAGE_OBJ} {
#========================================================================
  upvar $PAGE_OBJ page_obj
  global paOption

  # Left pane
    set left_pane $Page::($page_obj,left_pane_id)

  # Buttons
    set but [frame $left_pane.f]
    set new [button $but.new -text "Create" \
                        -command "UI_PB_blk_CreateABlock $page_obj" \
                        -bg $paOption(app_butt_bg)]
   set del [button $but.del -text "Cut" \
                        -command "UI_PB_blk_CutABlock $page_obj" \
                        -bg $paOption(app_butt_bg)]
   set pas [button $but.pas -text "Paste" \
                        -command "UI_PB_blk_PasteABlock $page_obj" \
                        -bg $paOption(app_butt_bg)]
   pack $new $del $pas -side left -fill x -expand yes

   pack $but -side top -fill x -padx 7
}

#================================================================
proc UI_PB_blk_CreateABlock { page_obj } {
#================================================================
  set active_blk_obj $Page::($page_obj,active_blk_obj)

  # Creates a new block
    PB_int_BlockCreateObject active_blk_obj obj_index

    UI_PB_blk_DisplayNameList page_obj obj_index
    UI_PB_blk_BlkItemSelection $page_obj
}

#================================================================
proc UI_PB_blk_CutABlock { page_obj } {
#================================================================
  set tree $Page::($page_obj,tree)
  set HLIST [$tree subwidget hlist]
  set ent [$HLIST info selection]
  set obj_index [string range $ent 2 [string length $ent]]

  set active_blk_obj $Page::($page_obj,active_blk_obj)

 # Checks if the block is reffered by an event.
  if {$block::($active_blk_obj,evt_addr_list) != ""} \
  {
      set block_name $block::($active_blk_obj,block_name)
      tk_messageBox -type ok -icon error\
         -message "Block \"$block_name\" is used by an Event. \
                   Block cannot be deleted"
  } else \
  {
     # Cuts the block object
       PB_int_BlockCutObject active_blk_obj obj_index
       set Page::($page_obj,buff_blk_obj) $active_blk_obj

       UI_PB_blk_DisplayNameList page_obj obj_index
       UI_PB_blk_BlkItemSelection $page_obj
  }
}

#================================================================
proc UI_PB_blk_PasteABlock { page_obj } {
#================================================================
  set tree $Page::($page_obj,tree)
  set HLIST [$tree subwidget hlist]
  set ent [$HLIST info selection]
  set obj_index [string range $ent 2 [string length $ent]]

  if {![info exists Page::($page_obj,buff_blk_obj)]} \
  {
     return
  }

  set buff_blk_obj $Page::($page_obj,buff_blk_obj)
  set temp_index $obj_index
  PB_int_BlockPasteObject buff_blk_obj obj_index

  if { $temp_index != $obj_index } \
  {
     UI_PB_blk_DisplayNameList page_obj obj_index
     UI_PB_blk_BlkItemSelection $page_obj
  }
}

#================================================================
proc UI_PB_blk_CreateTreeElements {PAGE_OBJ} {
#================================================================
  upvar $PAGE_OBJ page_obj
  global paOption
   
  set tree $Page::($page_obj,tree)

  set h [$tree subwidget hlist]
  $h config -bg $paOption(tree_bg)

  uplevel #0 set TRANSPARENT_GIF_COLOR [$h cget -bg]

  $tree config \
      -command   "UI_PB_blk_BlkItemSelection $page_obj" \
      -browsecmd "UI_PB_blk_BlkItemSelection $page_obj" 
}

#===============================================================================
proc UI_PB_blk_DisplayNameList { PAGE_OBJ OBJ_INDEX } {
#===============================================================================
  upvar $PAGE_OBJ page_obj
  upvar $OBJ_INDEX obj_index
  global paOption

  set tree $Page::($page_obj,tree)
  set HLIST [$tree subwidget hlist]

  $HLIST delete all
  $HLIST add 0 -itemtype imagetext -text "" -image $paOption(folder) -state disabled
  set file   [tix getimage pb_block_s]

  PB_int_RetBlkObjList blk_obj_list
  set no_fmt [llength $blk_obj_list]
  global gPB
  set style $gPB(font_style_normal)
  for {set count 0} {$count < $no_fmt} {incr count}\
  {
     set blk_obj [lindex $blk_obj_list $count]
     set blk_name $block::($blk_obj,block_name)
     $HLIST add 0.$count -itemtype imagetext -text $blk_name -image $file \
                                             -style $style
  }

  if { $obj_index >= $no_fmt } \
  {
    set obj_index [expr $no_fmt - 1]
    $HLIST selection set 0.$obj_index
  } elseif {$obj_index >= 0}\
  {
     $HLIST selection set 0.$obj_index
  } else\
  {
     $HLIST selection set 0
  }
  $tree autosetmode
}

#===============================================================================
proc UI_PB_blk_BlkItemSelection { page_obj args } {
#===============================================================================
  set tree $Page::($page_obj,tree)
  set HLIST [$tree subwidget hlist]
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

  # Database call returns the block object list
    PB_int_RetBlkObjList blk_obj_list
    set block_obj [lindex $blk_obj_list $index]

   if {[info exists Page::($page_obj,active_blk_obj)]} \
   {
      if {$block_obj == $Page::($page_obj,active_blk_obj)} \
      {
         return
      }
   }

  # Deletes all the existing cells and icons
  if {[info exists Page::($page_obj,active_blk_obj)]} \
  {
    set active_blk $Page::($page_obj,active_blk_obj)
    UI_PB_blk_DeleteCellsIcons page_obj active_blk
    unset block::($active_blk,rest_value)
    foreach blk_elem_obj $block::($active_blk,elem_addr_list) \
    {
        unset block_element::($blk_elem_obj,rest_value)
    }
    UI_PB_blk_BlkApplyCallBack $page_obj
  }

  # Displays block attributes in the block page
    UI_PB_blk_DisplayBlockAttr page_obj block_obj
}

#=============================================================================
proc UI_PB_blk_DisplayBlockAttr { PAGE_OBJ BLOCK_OBJ } {
#=============================================================================
  upvar $PAGE_OBJ page_obj
  upvar $BLOCK_OBJ block_obj

  # Attributes of Page are set here
    set Page::($page_obj,in_focus_elem) 0
    set Page::($page_obj,out_focus_elem) 0
    set Page::($page_obj,active_blk_elem) 0
    set Page::($page_obj,trash_flag) 0

  # Restores the block data (makes a copy of the existing block data)
    block::RestoreValue $block_obj
    foreach blk_elem_obj $block::($block_obj,elem_addr_list) \
    {
        block_element::RestoreValue $blk_elem_obj
    }

  # Gets the sorted list of the block elements according to
  # the master sequence
    UI_PB_blk_GetBlkAttrSort page_obj block_obj

  if {[info exists block::($block_obj,active_blk_elem_list)]} \
  {
       set active_blk_elem_obj \
               [lindex $block::($block_obj,active_blk_elem_list) 0]
       if { $active_blk_elem_obj == "" } \
       {
          set active_blk_elem_obj 0
       }
  } else \
  {
       set active_blk_elem_obj 0
  }

  # Gets the image ids of all the elements of a block
    UI_PB_blk_CreateBlockImages page_obj block_obj

  # proc is called to create the block cells
    set block_owner $block::($block_obj,blk_owner)
    UI_PB_blk_CreateBlockCells page_obj block_obj active_blk_elem_obj \
                               block_owner 
    UI_PB_blk_ConfigureLeader page_obj active_blk_elem_obj
   
  # Block Elements binding procedures
    UI_PB_blk_IconBindProcs page_obj
}

#===============================================================================
proc UI_PB_blk_GetBlkAttrSort {PAGE_OBJ BLOCK_OBJ } {
#===============================================================================
   upvar $PAGE_OBJ page_obj
   upvar $BLOCK_OBJ block_obj

  # checks the status of the each block element in the master list 
  # and returns a list of active block elements
  if {[info exists block::($block_obj,active_blk_elem_list)]} \
  {
      unset block::($block_obj,active_blk_elem_list)
  }

 # Creates the active blk element list based upon the status of
 # each block element in the master sequence.
  if {[info exists block::($block_obj,elem_addr_list)]} \
  {
    set active_blk_elem_list $block::($block_obj,elem_addr_list)
    UI_PB_com_ApplyMastSeqBlockElem active_blk_elem_list
    set block::($block_obj,active_blk_elem_list) $active_blk_elem_list
  }
}

#=================================================================
proc UI_PB_blk_DeleteCellsIcons {PAGE_OBJ BLOCK_OBJ} {
#=================================================================
  upvar $PAGE_OBJ page_obj
  upvar $BLOCK_OBJ block_obj

  set c $Page::($page_obj,bot_canvas)

  if {[info exists block::($block_obj,active_blk_elem_list)]} \
  {
    # Deletes all the cells and icons
      foreach blk_elem_obj $block::($block_obj,active_blk_elem_list) \
      { 
           $c delete $block_element::($blk_elem_obj,rect)
           $c delete $block_element::($blk_elem_obj,div_id)
           $c delete $block_element::($blk_elem_obj,icon_id)
      }
  }

  if {[info exists block::($block_obj,div_id)]} \
  {
      $c delete $block::($block_obj,div_id)
  }

  if {[info exists block::($block_obj,rect)]} \
  {
      $c delete $block::($block_obj,rect)
  }
}

#====================================================================
proc UI_PB_blk_CreateBlockImages { PAGE_OBJ BLOCK_OBJ } {
#====================================================================
  upvar $PAGE_OBJ page_obj
  upvar $BLOCK_OBJ block_obj

  if {![info exists block::($block_obj,active_blk_elem_list)]} \
  {
     return
  }

  set bot_canvas $Page::($page_obj,bot_canvas)
  foreach blk_elem_obj $block::($block_obj,active_blk_elem_list) \
  {
     set blk_elem_addr $block_element::($blk_elem_obj,elem_add_obj)
     set addr_leader $address::($blk_elem_addr,add_leader)
     set blk_elem_mom_var $block_element::($blk_elem_obj,elem_mom_variable)
  
     UI_PB_com_RetImageAppdText blk_elem_addr blk_elem_mom_var \
                                img_name blk_elem_text

     set blk_elem_img  [UI_PB_blk_CreateIcon $bot_canvas $img_name \
                                          $blk_elem_text]
     set block_element::($blk_elem_obj,blk_img) $blk_elem_img
  }
}

#=============================================================================
proc UI_PB_blk_AddTopFrameItems {PAGE_OBJ} {
#=============================================================================
  upvar $PAGE_OBJ page_obj

  global tixOption
  global paOption

  set blk_elm_attr(0) 0
  set blk_elm_attr(1) 0
  set blk_elm_attr(2) 0
  #-------------------------
  # Address
  #-------------------------
  set canvas_frame $Page::($page_obj,canvas_frame)
  set frm [tixButtonBox $canvas_frame.act \
              -orientation horizontal \
              -bd 2 \
              -relief sunken \
              -bg gray85]

    pack $frm -side bottom -fill x -padx 3 -pady 3

    button $frm.adr -text "$blk_elm_attr(0)" -cursor "" \
                    -font $tixOption(bold_font) -bg darkSeaGreen3 -relief flat \
                    -state disabled -disabledforeground lightYellow
    button $frm.fmt -text "$blk_elm_attr(1)" -cursor "" \
                    -font $tixOption(bold_font) -bg darkSeaGreen3 -relief flat \
                    -state disabled -disabledforeground lightYellow
    button $frm.trl -text "$blk_elm_attr(2)" -cursor "" \
                    -font $tixOption(bold_font) -bg darkSeaGreen3 -relief flat \
                    -state disabled -disabledforeground lightYellow

  # Suppress the hilightcolor
    $frm.adr configure -activebackground darkSeaGreen3
    $frm.fmt configure -activebackground darkSeaGreen3
    $frm.trl configure -activebackground darkSeaGreen3

    grid $frm.adr -row 1 -column 1  -pady 10
    grid $frm.fmt -row 1 -column 2  -pady 10
    grid $frm.trl -row 1 -column 3  -pady 10

    set Page::($page_obj,fmt) $frm.fmt
    set Page::($page_obj,addr) $frm.adr
    set Page::($page_obj,trailer) $frm.trl
}

#=============================================================================
proc UI_PB_blk_AddActionButtons { PAGE_OBJ } {
#=============================================================================
  upvar $PAGE_OBJ page_obj
  global paOption

  #-----------------------
  # Create action buttons
  #-----------------------
  set box $Page::($page_obj,box)
  $box config -bg $paOption(butt_bg)
  $box add def -text Default -width 10 -bg $paOption(app_butt_bg) \
               -command "UI_PB_blk_DefaultCallBack $page_obj"

  $box add apl -text Restore -width 10 -bg $paOption(app_butt_bg) \
               -command "UI_PB_blk_RestoreCallBack $page_obj"
}

#===========================================================================
proc UI_PB_blk_AddBindProcs {PAGE_OBJ} {
#===========================================================================
   upvar $PAGE_OBJ page_obj

   set top_canvas $Page::($page_obj,top_canvas)

   $top_canvas bind add_movable <1> \
                        "UI_PB_blk_ItemStartDrag1 $page_obj \
                                                  %x %y"

   $top_canvas bind add_movable <Enter> \
                        "UI_PB_blk_ItemFocusOn1 $page_obj \
                                                %x %y"

    $top_canvas bind add_movable <Leave> \
                        "UI_PB_blk_ItemFocusOff1 $page_obj"
}

#============================================================================
proc UI_PB_blk_CreatePopupMenu {PAGE_OBJ} {
#============================================================================
  upvar $PAGE_OBJ page_obj
  global tixOption
  global paOption
  global popupvar

  set bot_canvas $Page::($page_obj,bot_canvas)
  option add *Menu.tearOff   0

  set blockpopup [menu $bot_canvas.pop]
  set Page::($page_obj,blockpopup) $blockpopup
  set Page::($page_obj,block_popup_flag) 0

  bind $bot_canvas <3> "UI_PB_blk_CanvasPopupMenu $page_obj popupvar %X %Y"
}

#==========================================================================
proc UI_PB_blk_BlkApplyCallBack {page_obj} {
#==========================================================================
  set WordNameList $Page::($page_obj,blk_WordNameList)
  set block_obj $Page::($page_obj,active_blk_obj)

  if {![info exists block::($block_obj,active_blk_elem_list)]} \
  {
       return
  }

  set blk_obj_attr(0) $block::($block_obj,block_name)
  set blk_obj_attr(1) [llength $block::($block_obj,active_blk_elem_list)]
  set blk_obj_attr(2) $block::($block_obj,active_blk_elem_list)
  set blk_obj_attr(3) $WordNameList

 # sets the run time data to the block
   block::setvalue $block_obj blk_obj_attr
}

#==========================================================================
proc UI_PB_blk_RestoreCallBack { page_obj } {
#==========================================================================
  set block_obj $Page::($page_obj,active_blk_obj)

  # Deletes all the existing cells and icons
    UI_PB_blk_DeleteCellsIcons page_obj block_obj

  # Sets the block data to default values
    array set blk_obj_attr $block::($block_obj,rest_value)
    block::setvalue $block_obj blk_obj_attr
    unset blk_obj_attr

  # Sets the restore data of the block as run time data.
    foreach blk_elem_obj $block::($block_obj,elem_addr_list) \
    {
        array set blk_elem_obj_attr $block_element::($blk_elem_obj,rest_value)
        block_element::setvalue $blk_elem_obj blk_elem_obj_attr
        unset blk_elem_obj_attr
    }

  # Gets the active block elements list and sorts list of the block elements 
  # according to the master sequence
    UI_PB_blk_GetBlkAttrSort page_obj block_obj

    if {[info exists block::($block_obj,active_blk_elem_list)]} \
    {
         set active_blk_elem_obj \
             [lindex $block::($block_obj,active_blk_elem_list) 0]
    } else \
    {
        set active_blk_elem_obj 0
    }

  # Gets the image ids of all the elements of a block
    UI_PB_blk_CreateBlockImages page_obj block_obj

  # This procedure is called to create the block and itscells
    set block_owner $block::($block_obj,blk_owner)
    UI_PB_blk_CreateBlockCells page_obj block_obj active_blk_elem_obj \
                               block_owner
    UI_PB_blk_ConfigureLeader page_obj active_blk_elem_obj
  
  # Block Elements binding procedures
    UI_PB_blk_IconBindProcs page_obj
}

#==========================================================================
proc UI_PB_blk_DefaultCallBack {page_obj} {
#==========================================================================
  set block_obj $Page::($page_obj,active_blk_obj)

  # Deletes all the existing cells and icons
    UI_PB_blk_DeleteCellsIcons page_obj block_obj

  # Sets the block data to default values
    array set blk_obj_attr $block::($block_obj,def_value)
    block::setvalue $block_obj blk_obj_attr
    unset blk_obj_attr

  # Sets the default data of the block elements as the run time data
    foreach blk_elem_obj $block::($block_obj,elem_addr_list) \
    {
       array set blk_elem_obj_attr $block_element::($blk_elem_obj,def_value)
       block_element::setvalue $blk_elem_obj blk_elem_obj_attr
       unset blk_elem_obj_attr
    }

  # Gets the sorted list of the block elements according to
  # the master sequence
    UI_PB_blk_GetBlkAttrSort page_obj block_obj
    if {[info exists block::($block_obj,active_blk_elem_list)]} \
    {
         set active_blk_elem_obj \
             [lindex $block::($block_obj,active_blk_elem_list) 0]
    } else \
    {
        set active_blk_elem_obj 0
    }

  # Gets the image ids of all the elements of a block
    UI_PB_blk_CreateBlockImages page_obj block_obj

  # This procedure is called to create the block and itscells
    set block_owner $block::($block_obj,blk_owner)
    UI_PB_blk_CreateBlockCells page_obj block_obj active_blk_elem_obj \
                               block_owner
    UI_PB_blk_ConfigureLeader page_obj active_blk_elem_obj
  
  # Block Elements binding procedures
    UI_PB_blk_IconBindProcs page_obj
}

#==========================================================================
proc UI_PB_blk_CanvasPopupMenu {page_obj POPUPVAR x y} {
#==========================================================================
   upvar $POPUPVAR popupvar

   set blockpopup $Page::($page_obj,blockpopup)
   if { $Page::($page_obj,block_popup_flag) == 0} \
   {
###      set popupvar(0) 0
###      set popupvar(1) 0
###      set popupvar(2) 0
###      $blockpopup delete 0 end
###      $blockpopup add command -label "Edit Word" -state disabled
###      $blockpopup add cascade -label "Change Element" -menu $blockpopup.change \
###                            -state disabled
###      $blockpopup add checkbutton -label "Optional" \
###                          -variable popupvar(1) -state disabled
###      $blockpopup add checkbutton -label "No Word Seperator" \
###                         -variable popupvar(0)  -state disabled
###      $blockpopup add checkbutton -label "Force Output" \
###                         -variable popupvar(2)  -state disabled
   } else \
   {
     set Page::($page_obj,block_popup_flag) 0

    # Position popup menu 
     tk_popup $blockpopup $x $y 
   }
}

#=============================================================================
proc UI_PB_blk_CombSelection { page_obj base_addr index} {
#=============================================================================
  global tixOption

  # Database call returns the descrptions of all mom variables
    PB_int_GetWordVarDesc WordDescArray

##<GSL 11-17-99>
 set add_leader ""
 
 if { [string compare $base_addr "New_Address"] == 0} \
  {
     set mom_var ""
     set new_word_mom_var ""
     set app_text ""
  } else \
  {
     PB_int_RetAddrObjFromName base_addr add_obj

##<GSL 11-17-99>     set add_leader $address::($add_obj,add_leader)
     if {[string compare $address::($add_obj,add_name) "Text"] == 0} \
     {
        set mom_var ""
        set new_word_mom_var ""
     } else \
     {
##<GSL 11-17-99>
        set add_leader $address::($add_obj,add_leader)

        PB_int_RetMOMVarAsscAddress base_addr word_mom_var_list
        set mom_var [lindex $word_mom_var_list $index]
        PB_int_GetNewBlockElement base_addr index new_word_mom_var
     }
     PB_com_MapMOMVariable add_obj mom_var app_text
     PB_int_ApplyFormatAppText add_obj app_text
  }

  set desc ""
  set word_desc [lindex $WordDescArray($base_addr) $index]
  if { $word_desc == "" } \
  {
    set word_desc "User Defined Expression"
  }

  append desc $base_addr " (" $add_leader $app_text - $word_desc " )"
  set comb_var $desc
  set Page::($page_obj,comb_var) $desc

  set Page::($page_obj,new_elem_mom_var) $new_word_mom_var
  set Page::($page_obj,sel_base_addr) $base_addr

  if {[info exists Page::($page_obj,comb_text)]} \
  {
     $Page::($page_obj,top_canvas) delete \
               $Page::($page_obj,comb_text)
  }
  set Page::($page_obj,comb_text) [$Page::($page_obj,top_canvas) \
             create text $Page::($page_obj,entry_cx) \
                         $Page::($page_obj,entry_cy) \
                         -text $comb_var -font $tixOption(font)]
}

#=============================================================================
proc UI_PB_blk_GetActiveAddresses { PAGE_OBJ } {
#=============================================================================
  upvar $PAGE_OBJ page_obj

  set temp_wordnamelist ""

  # Database call returns the address object list
    PB_int_RetAddressObjList add_obj_list

  foreach addr_obj $add_obj_list \
  {
     if { $addr_obj } \
     {
        if { $address::($addr_obj,word_status) == 0} \
        {
           set addr_name $address::($addr_obj,add_name)
           if { [string compare $addr_name Text] != 0 && \
                [string compare $addr_name N] != 0} \
           {
              lappend temp_wordnamelist $addr_name
           }
        }
     }
  }
  set Page::($page_obj,blk_WordNameList) $temp_wordnamelist
}

#=============================================================================
proc UI_PB_blk_CreateMenuElement { PAGE_OBJ comb_widget element_index \
                                   NO_OF_ADDR} {
#=============================================================================
  upvar $PAGE_OBJ page_obj
  upvar $NO_OF_ADDR no_of_addr

  set word [lindex $Page::($page_obj,blk_WordNameList) $element_index]
  PB_int_RetAddrObjFromName word add_obj
  set add_leader $address::($add_obj,add_leader)

  # Database call returns the descrptions of all mom variables
    PB_int_GetWordVarDesc WordDescArray

  if { [info exists WordDescArray($word)] } \
  {
     set list_len [llength $WordDescArray($word)]
     PB_int_RetMOMVarAsscAddress word word_mom_var_list
  } else \
  {
     set list_len 0
  }

  if { $list_len == 0} \
  {
     set index 0
     $comb_widget add command -label $word \
                 -command "UI_PB_blk_CombSelection $page_obj $word $index" 
  } else \
  {
     $comb_widget add cascade -label $word -menu  $comb_widget.m$no_of_addr
     catch {destroy $comb_widget.m$no_of_addr}
     menu $comb_widget.m$no_of_addr
     for {set count 0} {$count < $list_len} {incr count} \
     {
         set mom_var [lindex $word_mom_var_list $count]
         set desc [lindex $WordDescArray($word) $count]

         PB_com_MapMOMVariable add_obj mom_var app_text
         PB_int_ApplyFormatAppText add_obj app_text

         append sublabel $add_leader $app_text - $desc
         $comb_widget.m$no_of_addr add command  -label $sublabel \
                  -command "UI_PB_blk_CombSelection $page_obj $word $count" 
         unset sublabel
     }
     append sublabel $add_leader - "User Defined Expression"
     $comb_widget.m$no_of_addr add command  -label $sublabel \
              -command "UI_PB_blk_CombSelection $page_obj $word $count" 
     unset sublabel
     incr no_of_addr
  }
}

#=============================================================================
proc UI_PB_blk_CreateMenuOptions { PAGE_OBJ } {
#=============================================================================
  upvar $PAGE_OBJ page_obj

  set comb_widget $Page::($page_obj,comb_widget)
  $comb_widget delete 0 end

  UI_PB_blk_GetActiveAddresses page_obj

  set basewords_length [llength $Page::($page_obj,blk_WordNameList)]

  if {$basewords_length > 20} \
  {  
     set no_options 20
  } else \
  {
     set no_options $basewords_length
  }

  # Adds new address option
    $comb_widget add command -label "New Word" \
                 -command "UI_PB_blk_CombSelection $page_obj New_Address 0" 
    $comb_widget add command -label "Text" \
                 -command "UI_PB_blk_CombSelection $page_obj Text 0" 
    $comb_widget add separator

  set no_of_addr 0
  for {set ii 0} {$ii < $no_options} {incr ii} \
  {
      UI_PB_blk_CreateMenuElement page_obj $comb_widget $ii no_of_addr
  }

  if {$no_options < $basewords_length} \
  {
     set no_of_addr 0
     $comb_widget add cascade -label More -menu $comb_widget.more     
     catch {destroy $comb_widget.more}
     menu $comb_widget.more
     set comb_widget $comb_widget.more

     for {set jj $no_options} {$jj < $basewords_length} {incr jj} \
     {
        UI_PB_blk_CreateMenuElement page_obj $comb_widget $jj no_of_addr
     }
  }

  set comb_label_desc [lindex $Page::($page_obj,blk_WordNameList) 0] 
  UI_PB_blk_CombSelection $page_obj $comb_label_desc 0 
}

#=============================================================================
proc UI_PB_blk_CreateBlockCells { PAGE_OBJ BLOCK_OBJ ACTIVE_BLK_ELEM_OBJ \
                                  BLOCK_OWNER } {
#=============================================================================
    upvar $PAGE_OBJ page_obj
    upvar $BLOCK_OBJ block_obj
    upvar $ACTIVE_BLK_ELEM_OBJ active_blk_elem_obj
    upvar $BLOCK_OWNER block_owner
    global paOption

    set cell_color paleturquoise
    set divi_color turquoise
    set main_cell_color $paOption(can_bg)

    set c $Page::($page_obj,bot_canvas)
    set Page::($page_obj,active_blk_obj) $block_obj

    if {[info exists block::($block_obj,active_blk_elem_list)]} \
    {
      set no_of_elements [llength $block::($block_obj,active_blk_elem_list)]
    } else \
    {
      set no_of_elements 0
    }

    set h_cell $Page::($page_obj,h_cell)       ;# cell height
    set w_cell $Page::($page_obj,w_cell)       ;# cell width
    set w_divi $Page::($page_obj,w_divi)       ;# divider width
    set x_orig $Page::($page_obj,x_orig)       ;# upper-left corner of 1st cell
    set y_orig $Page::($page_obj,y_orig)

   # Create several compound images in the canvas
     set n_comp $no_of_elements

   #----------------------------------------
   # Create rectangular cells to hold icons
   #----------------------------------------
   set x0 $x_orig
   set y0 $y_orig
   set x1 [expr $x0 + [expr [expr $w_divi + $w_cell] * $n_comp] + \
                    $w_divi + [expr 2 * $w_divi]]
   set y1 [expr $y0 + $h_cell + [expr 2 * $w_divi]]

   set block::($block_obj,rect) [UI_PB_com_CreateRectangle $c $x0 $y0 $x1 $y1 \
                                     $main_cell_color $main_cell_color]
   set block::($block_obj,blk_h) $y1
   set block::($block_obj,blk_w) $x1
   $c lower $block::($block_obj,rect)

   set block::($block_obj,rect_x0) $x0
   set block::($block_obj,rect_y0) $y0
   set block::($block_obj,rect_x1) $x1
   set block::($block_obj,rect_y1) $y1

    set x0 [expr $x_orig + $w_divi]
    set y0 [expr $y_orig + $w_divi]
    set yc [expr $y0 + [expr $h_cell / 2]]

    for {set i 0} {$i < $n_comp} {incr i 1} {

    #--------------
    # Divider cell
    #--------------
      set blk_elem_obj [lindex $block::($block_obj,active_blk_elem_list) $i]
      set j  [expr 2 * $i]
      set y1 [expr $y0 + $h_cell]
      set x1 [expr $x0 + $w_divi]

      set block_element::($blk_elem_obj,div_corn_x0) $x0
      set block_element::($blk_elem_obj,div_corn_y0) $y0
      set block_element::($blk_elem_obj,div_corn_x1) $x1
      set block_element::($blk_elem_obj,div_corn_y1) $y1

      set block_element::($blk_elem_obj,div_id) [UI_PB_com_CreateRectangle $c \
                           $x0 $y0 $x1 $y1 $divi_color $divi_color ]

   #--------------
   # Holding cell
   #--------------
      set k [expr $j + 1]
      set x0 $x1
      set x1 [expr $x0 + $w_cell]

      set block_element::($blk_elem_obj,rect_corn_x0)   $x0
      set block_element::($blk_elem_obj,rect_corn_y0)   $y0
      set block_element::($blk_elem_obj,rect_corn_x1)   $x1
      set block_element::($blk_elem_obj,rect_corn_y1)   $y1

      set block_element::($blk_elem_obj,rect) [UI_PB_com_CreateRectangle $c \
                        $x0 $y0 $x1 $y1 $cell_color $divi_color]

   # Place icons into cell
      set xc [expr [expr $x0 + $x1] / 2]
      append opt_img pb_ $block_element::($blk_elem_obj,elem_opt_nows_var)
      if { $block_element::($blk_elem_obj,force) } \
      {
         append opt_img _f
      }
      set name_addr [tix getimage $opt_img]
      unset opt_img
      $block_element::($blk_elem_obj,blk_img) add image -image $name_addr
      set blk_elem_owner $block_element::($blk_elem_obj,owner)
      set blk_elem_add_obj $block_element::($blk_elem_obj,elem_add_obj)
      set address_name $address::($blk_elem_add_obj,add_name)

      if {[string compare $blk_elem_owner $block_owner] == 0} \
      {
         set icon_id [$c create image  $xc $yc \
              -image $block_element::($blk_elem_obj,blk_img) -tag movable]
      } else \
      {
         set icon_id [$c create image  $xc $yc \
              -image $block_element::($blk_elem_obj,blk_img) -tag nonmovable]
         set im [$c itemconfigure $icon_id -image]
         [lindex $im end] configure -relief flat
      }

      if {[string compare $address_name "Text"] == 0} \
      {
         set im [$c itemconfigure $icon_id -image]
         [lindex $im end] configure -bg $paOption(text)
      }

      set block_element::($blk_elem_obj,icon_id) $icon_id
      set block_element::($blk_elem_obj,xc)   $xc
      set block_element::($blk_elem_obj,yc)   $yc

      set x0 $x1
    }

   #--------------
   # Last divider
   #--------------
    if {[info exists k] == 1} \
    {
        set k [expr $k + 1]
    } else \
    {
        set k 0
    }

    set x1 [expr $x0 + $w_divi]
    set y1 [expr $y0 + $h_cell]

    set block::($block_obj,div_corn_x0)   $x0
    set block::($block_obj,div_corn_y0)   $y0
    set block::($block_obj,div_corn_x1)   $x1
    set block::($block_obj,div_corn_y1)   $y1

    set block::($block_obj,div_id) [UI_PB_com_CreateRectangle $c $x0 $y0 \
                              $x1 $y1 $divi_color $divi_color]

    if {$active_blk_elem_obj != 0} \
    {
      set im [$c itemconfigure $block_element::($active_blk_elem_obj,icon_id) \
                                   -image]
      [lindex $im end] configure -relief sunken -bg pink
      set Page::($page_obj,active_blk_elem) $active_blk_elem_obj
    }
}

#==========================================================================
proc UI_PB_blk_IconBindProcs {PAGE_OBJ} {
#==========================================================================
  upvar $PAGE_OBJ page_obj

   set bot_canvas $Page::($page_obj,bot_canvas)

   #---------------------
   # Bind block element icons to mouse
   #---------------------
    $bot_canvas bind movable <1>          "UI_PB_blk_StartDragAddr $page_obj \
                                                                    %x %y"

    $bot_canvas bind movable <B1-Motion>  "UI_PB_blk_DragAddr    $page_obj \
                                                                    %x %y"

    $bot_canvas bind movable <Enter>      "UI_PB_blk_AddrFocusOn $page_obj \
                                                                  %x %y"
         
    $bot_canvas bind movable <Leave>      "UI_PB_blk_AddrFocusOff $page_obj"

    $bot_canvas bind movable <ButtonRelease-1> "UI_PB_blk_EndDragAddr  \
                                                $page_obj"

    $bot_canvas bind movable <3>          "UI_PB_blk_BindRightButton $page_obj \
                                                               %x %y"

    $bot_canvas bind nonmovable <1>       "UI_PB_blk_StartDragAddr $page_obj \
                                                                   %x %y"

    $bot_canvas bind nonmovable <Enter>   "UI_PB_blk_AddrFocusOn $page_obj \
                                                                 %x %y"
         
    $bot_canvas bind nonmovable <Leave>   "UI_PB_blk_AddrFocusOff $page_obj"
}

#==========================================================================
proc UI_PB_blk_ConfigureLeader { PAGE_OBJ ACTIVE_BLK_ELEM } {
#==========================================================================
  upvar $PAGE_OBJ page_obj
  upvar $ACTIVE_BLK_ELEM active_blk_elem_obj

  if {![info exist Page::($page_obj,trailer)]} { return }

  if {$active_blk_elem_obj} \
  {
     set addr_obj $block_element::($active_blk_elem_obj,elem_add_obj)
     set addr_name $address::($addr_obj,add_name)
     set blk_elem_mom_var \
          $block_element::($active_blk_elem_obj,elem_mom_variable)
     PB_com_MapMOMVariable addr_obj blk_elem_mom_var blk_elem_text
     PB_int_ApplyFormatAppText addr_obj blk_elem_text
     PB_int_GetElemDisplayAttr addr_name blk_elem_text blk_elm_attr
  } else {
     set blk_elm_attr(0) ""
     set blk_elm_attr(1) ""
     set blk_elm_attr(2) ""
  }

 # Packs and unpacks the leader button based upon the value that is
 # set to blk_elem_attr(0)
  if {[string compare $blk_elm_attr(0) ""]} \
  {
      if {$Page::($page_obj,lead_flag) == 1} \
      {
         grid $Page::($page_obj,addr) -row 1 -column 1 -pady 10
         $Page::($page_obj,addr) configure -text $blk_elm_attr(0)
         set Page::($page_obj,lead_flag) 0
      } else \
      {
         $Page::($page_obj,addr) configure -text $blk_elm_attr(0)
      }
  } else \
  {
      if {$Page::($page_obj,lead_flag) == 0} \
      {
         grid forget $Page::($page_obj,addr)
         set Page::($page_obj,lead_flag) 1
      }
  }

 # Packs and unpacks the format button based upon the value that is
 # set to blk_elem_attr(1)
  if {[string compare $blk_elm_attr(1) ""]} \
  {
      if {$Page::($page_obj,fmt_flag) == 1} \
      {
         grid $Page::($page_obj,fmt) -row 1 -column 2 -pady 10
         $Page::($page_obj,fmt) configure -text $blk_elm_attr(1)
         set Page::($page_obj,fmt_flag) 0
      } else \
      {
         $Page::($page_obj,fmt) configure -text $blk_elm_attr(1)
      }
  } else \
  {
      if {$Page::($page_obj,fmt_flag) == 0} \
      {
         grid forget $Page::($page_obj,fmt)
         set Page::($page_obj,fmt_flag) 1
      }
  }

 # Packs and unpacks the trailer button based upon the value that is
 # set to blk_elem_attr(2)
  if {[string compare $blk_elm_attr(2) ""]} \
  {
      if {$Page::($page_obj,trl_flag) == 1} \
      {
         grid $Page::($page_obj,trailer) -row 1 -column 3 -pady 10
         $Page::($page_obj,trailer) configure -text $blk_elm_attr(2)
         set Page::($page_obj,trl_flag) 0
      } else \
      {
         $Page::($page_obj,trailer) configure -text $blk_elm_attr(2)
      }
  } else \
  {
      if {$Page::($page_obj,trl_flag) == 0} \
      {
         grid forget $Page::($page_obj,trailer)
         set Page::($page_obj,trl_flag) 1
      }
  }
}

#==========================================================================
proc UI_PB_blk_BindRightButton {page_obj x y} {
#==========================================================================
   set block_obj $Page::($page_obj,active_blk_obj)
   set active_blk_elem $block::($block_obj,active_blk_elem)

   UI_PB_blk_BlockPopupMenu page_obj active_blk_elem $x $y 

  # Utilize end_drag CB to return block element to position.
   if { [info exists Page::($page_obj,being_dragged)] &&
        $Page::($page_obj,being_dragged) } \
   {
     UI_PB_blk_EndDragAddr $page_obj
   }
}

#=========================================================================
proc UI_PB_blk_BlockPopupMenu { PAGE_OBJ ACTIVE_BLK_ELEM x y } {
#=========================================================================
  upvar $PAGE_OBJ page_obj
  upvar $ACTIVE_BLK_ELEM active_blk_elem
  global paOption
  global popupvar

  set bot_canvas $Page::($page_obj,bot_canvas)
  set xx [$bot_canvas canvasx $x]
  set yy [$bot_canvas canvasy $y]

  # Database call returns the descrptions of all mom variables
    PB_int_GetWordVarDesc WordDescArray

  set addr_obj $block_element::($active_blk_elem,elem_add_obj)
  set base_addr $address::($addr_obj,add_name)
  set add_leader $address::($addr_obj,add_leader)
  set list_length [llength $WordDescArray($base_addr)]
  set blockpopup $Page::($page_obj,blockpopup)
  set canvas_frame $Page::($page_obj,canvas_frame)

  if {$list_length >= 1} \
  {
      UI_PB_blk_GetOptionImageName \
           $block_element::($active_blk_elem,elem_opt_nows_var) popupvar
      set popupvar(2) $block_element::($active_blk_elem,force)
      $blockpopup delete 0 end
      $blockpopup add command -label "Edit" -state normal \
             -command "UI_PB_blk_EditAddress $page_obj $active_blk_elem"
      $blockpopup add cascade -label "Change Element" -menu $blockpopup.change \
                            -state normal
      $blockpopup add checkbutton -label "Optional" \
                          -variable popupvar(1) -state normal \
                          -command "UI_PB_blk_AddNowsOpt $page_obj popupvar \
                                             $base_addr $active_blk_elem"

      $blockpopup add checkbutton -label "No Word Seperator" \
                         -variable popupvar(0)  -state normal \
                         -command "UI_PB_blk_AddNowsOpt $page_obj popupvar \
                                             $base_addr $active_blk_elem"

      $blockpopup add checkbutton -label "Force Output" \
                         -variable popupvar(2)  -state normal \
                         -command "UI_PB_blk_AddForceOpt $page_obj popupvar \
                                                  $base_addr $active_blk_elem"
      $blockpopup add sep
      $blockpopup add command -label "Delete"

      catch {destroy $blockpopup.change}
      menu $blockpopup.change

      PB_int_RetMOMVarAsscAddress base_addr word_mom_var_list
      set mom_var_length [llength $word_mom_var_list]
      set momvar_found_flag 0
      for {set count 0} {$count < $mom_var_length} {incr count} \
      {
        set subdesc [lindex $WordDescArray($base_addr) $count]
        if {[regexp -- $subdesc $block_element::($active_blk_elem,elem_desc)] \
              == 0} \
        {
           set mom_var [lindex $word_mom_var_list $count]

           PB_com_MapMOMVariable addr_obj mom_var app_text
           PB_int_ApplyFormatAppText addr_obj app_text
           append sublabel $add_leader $app_text - $subdesc

           $blockpopup.change add command -label $sublabel \
                       -command "UI_PB_blk_PopupSelection $page_obj \
                                 $base_addr $count $active_blk_elem"
           unset sublabel
        } else \
        {
           set momvar_found_flag 1
        }
      }
      
      if { $momvar_found_flag } \
      {
         $blockpopup.change add command -label "User Defined Expression" \
                    -command "UI_PB_blk_PopupSelection $page_obj \
                              $base_addr $count $active_blk_elem"
      }
   } else {
####################
### What is this ???
####################
      UI_PB_blk_GetOptionImageName \
             $block_element::($active_blk_elem,elem_opt_nows_var) popupvar
      set popupvar(2) $block_element::($active_blk_elem,force)
      $blockpopup delete 0 end
      $blockpopup add command -label "Edit Word" -state normal \
             -command "UI_PB_blk_EditAddress $page_obj $active_blk_elem"
      $blockpopup add cascade -label "Change Element" -menu $blockpopup.change \
                            -state disabled
      $blockpopup add checkbutton -label "Optional" \
                          -variable popupvar(1) -state normal \
                          -command "UI_PB_blk_AddNowsOpt $page_obj popupvar \
                                             $base_addr $active_blk_elem"

      $blockpopup add checkbutton -label "No Word Seperator" \
                         -variable popupvar(0)  -state normal \
                         -command "UI_PB_blk_AddNowsOpt $page_obj popupvar \
                                             $base_addr $active_blk_elem"

      $blockpopup add checkbutton -label "Force Output" \
                         -variable popupvar(2)  -state normal \
                         -command "UI_PB_blk_AddForceOpt $page_obj popupvar \
                                                  $base_addr $active_blk_elem"
   }
   set Page::($page_obj,block_popup_flag) 1
}

#==========================================================================
proc UI_PB_blk_EditAddress { blk_page_obj active_blk_elem } {
#==========================================================================
  global elem_text_var
  set canvas_frame $Page::($blk_page_obj,canvas_frame)
  set win $canvas_frame.addr

  set add_obj $block_element::($active_blk_elem,elem_add_obj)
  UI_PB_addr_CreateAddressPage $win $add_obj new_add_page

  # Creates Expression parameters
   set expr_frm [frame $win.expr]
   pack $expr_frm -side top

   set elem_text_var $block_element::($active_blk_elem,elem_mom_variable)
   label $expr_frm.lab -text Expression -anchor w
   entry $expr_frm.ent -textvariable elem_text_var -width 25 -relief sunken

  # Changes the status of the expression entry, based upon the option
  # selected. The entry is enabled, if a user defined expression is select
  # else it is disabled.
   if { [string match User* $block_element::($active_blk_elem,elem_desc)] }\
   {
      $expr_frm.ent config -state normal -bg white
   } else \
   {
      $expr_frm.ent config -state disabled -bg lightBlue
   }

   pack $expr_frm.lab -side left  -pady 10
   pack $expr_frm.ent -side right -pady 10 -padx 10
   focus $expr_frm.ent

   UI_PB_add_EditAddActions $win blk_page_obj new_add_page active_blk_elem
}

#==========================================================================
proc UI_PB_blk_NewAddress { BLK_PAGE_OBJ EVENT_OBJ EVT_ELEM_OBJ NEW_ELEM_OBJ \
                            page_name } {
#==========================================================================
  upvar $BLK_PAGE_OBJ blk_page_obj
  upvar $EVENT_OBJ event_obj
  upvar $EVT_ELEM_OBJ evt_elem_obj
  upvar $NEW_ELEM_OBJ new_elem_obj
  global elem_text_var
  set canvas_frame $Page::($blk_page_obj,canvas_frame)

  # new address dialog
  set win $canvas_frame.addr
  set new_add_obj $block_element::($new_elem_obj,elem_add_obj)
  UI_PB_addr_CreateAddressPage $win $new_add_obj new_add_page

  set expr_frm [frame $win.expr]
  pack $expr_frm -side top -pady 10

  set elem_text_var ""
  label $expr_frm.lab -text Expression -anchor w
  entry $expr_frm.ent -textvariable elem_text_var -width 24 -relief sunken

  pack $expr_frm.lab -side left -fill both -padx 10 -pady 10
  pack $expr_frm.ent -side right -fill both -padx 5 -pady 10
  focus $expr_frm.ent

  UI_PB_add_NewAddActions $win $blk_page_obj $event_obj $evt_elem_obj \
                          new_add_page new_elem_obj $page_name
}

#==========================================================================
proc UI_PB_blk_GetOptionImageName {optimagname POPUPVAR} {
#==========================================================================
  upvar $POPUPVAR popupvar

  switch $optimagname \
  {
     "both"  {
                 set popupvar(0) 1
                 set popupvar(1) 1
             }
     "nows"  {
                 set popupvar(0) 1
                 set popupvar(1) 0
             }
     "opt"   {
                 set popupvar(0) 0
                 set popupvar(1) 1
             }
     "blank" {
                 set popupvar(0) 0
                 set popupvar(1) 0
             }
  }
}

#==========================================================================
proc UI_PB_blk_AddForceOpt { page_obj POPUPVAR base_addr active_blk_elem } {
#==========================================================================
  upvar $POPUPVAR popupvar

  set block_element::($active_blk_elem,force) $popupvar(2)
  UI_PB_blk_ReplaceIcon page_obj $base_addr $active_blk_elem
}

#==========================================================================
proc UI_PB_blk_AddNowsOpt {page_obj POPUPVAR base_addr active_blk_elem } {
#==========================================================================
   upvar $POPUPVAR popupvar

   if {$popupvar(0) == 1 && $popupvar(1) == 1} \
   {
        set block_element::($active_blk_elem,elem_opt_nows_var) both

   } elseif {$popupvar(0) == 0 && $popupvar(1) == 1} \
   {
        set block_element::($active_blk_elem,elem_opt_nows_var) opt

   } elseif {$popupvar(0) == 1 && $popupvar(1) == 0} \
   {
        set block_element::($active_blk_elem,elem_opt_nows_var) nows

   } else \
   {
        set block_element::($active_blk_elem,elem_opt_nows_var) blank
   }
       
    UI_PB_blk_ReplaceIcon page_obj $base_addr $active_blk_elem
}

#==========================================================================
proc UI_PB_blk_PopupSelection {page_obj base_addr sel_index blk_elem_obj} {
#==========================================================================
    set bot_canvas $Page::($page_obj,bot_canvas)

    # Database call returns the descrptions of all mom variables
      PB_int_GetWordVarDesc WordDescArray

    PB_int_GetNewBlockElement base_addr sel_index word_mom_var

    if { $word_mom_var == "" } \
    {
      set word_mom_var $block_element::($blk_elem_obj,elem_mom_variable)

      UI_PB_com_CreateTextEntry page_obj blk_elem_obj Expression
      tkwait window $bot_canvas.txtent

      if { [string compare $block_element::($blk_elem_obj,elem_mom_variable) \
                "000"] == 0 } \
      {
         set block_element::($blk_elem_obj,elem_mom_variable) $word_mom_var
         return
      }
      set block_element::($blk_elem_obj,elem_desc) "User Defined Expression"
    } else \
    {
       set sel_subdesc [lindex $WordDescArray($base_addr) $sel_index]
       set block_element::($blk_elem_obj,elem_mom_variable) $word_mom_var
       set block_element::($blk_elem_obj,elem_desc) $sel_subdesc
    }

    UI_PB_blk_ReplaceIcon page_obj $base_addr $blk_elem_obj
    UI_PB_blk_ConfigureLeader page_obj blk_elem_obj
}

#==========================================================================
proc UI_PB_blk_ReplaceIcon {PAGE_OBJ base_addr blk_elem_obj} {
#==========================================================================
  upvar $PAGE_OBJ page_obj
  global paOption

  set bot_canvas $Page::($page_obj,bot_canvas)

  set blk_elem_addr $block_element::($blk_elem_obj,elem_add_obj)
  set addr_leader $address::($blk_elem_addr,add_leader)
  set blk_elem_mom_var $block_element::($blk_elem_obj,elem_mom_variable)
  
  UI_PB_com_RetImageAppdText blk_elem_addr blk_elem_mom_var \
                             img_name blk_elem_text

  set img_id [UI_PB_blk_CreateIcon $bot_canvas $img_name $blk_elem_text]
  set xc [expr [expr $block_element::($blk_elem_obj,rect_corn_x0) + \
                     $block_element::($blk_elem_obj,rect_corn_x1)] / 2]
  set yc [expr [expr $block_element::($blk_elem_obj,rect_corn_y0) + \
                     $block_element::($blk_elem_obj,rect_corn_y1)] / 2]

  append opt_img pb_ $block_element::($blk_elem_obj,elem_opt_nows_var)
  if { $block_element::($blk_elem_obj,force) } \
  {
     append opt_img _f
  }
  $img_id add image -image [tix getimage $opt_img]
  unset opt_img

  set icon_id [$bot_canvas create image  $xc $yc -image $img_id -tag movable]

  set exist_icon_id $block_element::($blk_elem_obj,icon_id)
  set im [lindex [$bot_canvas itemconfigure $exist_icon_id -image] end]
  set relief_status [lindex [$im configure -relief] end]
  $bot_canvas delete $exist_icon_id

  set block_element::($blk_elem_obj,icon_id) $icon_id
  set blk_elem_add_obj $block_element::($blk_elem_obj,elem_add_obj)
  set address_name $address::($blk_elem_add_obj,add_name)

  $img_id configure -relief $relief_status
  if {$relief_status == "sunken"} \
  {
      $img_id configure -bg pink
      set Page::($page_obj,active_blk_elem) $blk_elem_obj
  } elseif {[string compare $address_name "Text"] == 0} \
  {
      $img_id configure -bg $paOption(text)
  }
}

#==========================================================================
proc UI_PB_blk_AddrFocusOn {page_obj x y} {
#==========================================================================
  global gPB_help_tips

  set c $Page::($page_obj,bot_canvas)
  set block_obj $Page::($page_obj,active_blk_obj)
  set active_blk_elem_list $block::($block_obj,active_blk_elem_list)

  set x [$c canvasx $x]
  set y [$c canvasy $y]

   #----------------------
   # Locate in-focus cell
   #----------------------
   foreach blk_elem_obj $active_blk_elem_list \
   {
       if {$x >= $block_element::($blk_elem_obj,rect_corn_x0) && \
           $x < $block_element::($blk_elem_obj,rect_corn_x1)} \
       { 
          set Page::($page_obj,in_focus_elem) $blk_elem_obj

          # Change cursor
            $c config -cursor hand2
            break
       }
    }

   #-----------------------------
   # Highlight new in-focus cell
   #-----------------------------
   if {$Page::($page_obj,in_focus_elem) != \
           $Page::($page_obj,out_focus_elem)} \
   {
      if { $Page::($page_obj,out_focus_elem) } \
      {
        set out_focus_elem $Page::($page_obj,out_focus_elem)
        $c itemconfigure $block_element::($out_focus_elem,rect) \
                   -fill $Page::($page_obj,x_color)
      }

      set cell_highlight_color navyblue
      set in_focus_elem $Page::($page_obj,in_focus_elem)
      set Page::($page_obj,x_color) [lindex [$c itemconfigure \
              $block_element::($in_focus_elem,rect) -fill] end]

      $c itemconfigure $block_element::($in_focus_elem,rect) \
                   -fill $cell_highlight_color

      set Page::($page_obj,out_focus_elem) $Page::($page_obj,in_focus_elem)

      if { $Page::($page_obj,in_focus_elem) } \
      {
        if {$gPB_help_tips(state)} \
        {
          global item_focus_on

          if {![info exists item_focus_on]} \
          {
            set item_focus_on 0
          }
          if {$item_focus_on == 0} \
          {
            UI_PB_blk_CreateBalloon page_obj
            set item_focus_on 1
          }
        }
        set block::($block_obj,active_blk_elem) $in_focus_elem
      }
   }
}

#==========================================================================
proc UI_PB_blk_CreateBalloon { PAGE_OBJ } {
#==========================================================================
   upvar $PAGE_OBJ page_obj

    set c $Page::($page_obj,bot_canvas)
    set in_focus_elem $Page::($page_obj,in_focus_elem)

    set add_obj $block_element::($in_focus_elem,elem_add_obj)
    set add_leader $address::($add_obj,add_leader)

    set blk_elem_mom_var $block_element::($in_focus_elem,elem_mom_variable)
    PB_com_MapMOMVariable add_obj blk_elem_mom_var blk_elem_text
    PB_int_ApplyFormatAppText add_obj blk_elem_text
    
    set elem_desc $block_element::($in_focus_elem,elem_desc)
    append desc $add_leader $blk_elem_text - $elem_desc

    global gPB_help_tips
    set gPB_help_tips($c) $desc
}

#==========================================================================
proc UI_PB_blk_AddrFocusOff {page_obj} {
#==========================================================================
   # Restore cell color
   set c $Page::($page_obj,bot_canvas)

    if { $Page::($page_obj,out_focus_elem) } \
    {
       set out_focus_elem $Page::($page_obj,out_focus_elem)
       $c itemconfigure $block_element::($out_focus_elem,rect) \
               -fill $Page::($page_obj,x_color)
    }

    set Page::($page_obj,in_focus_elem) 0
    set Page::($page_obj,out_focus_elem) 0

   # Restore cursor
    $c config -cursor ""    

   # Clean up balloon
    UI_PB_blk_DeleteBalloon page_obj
}

#==========================================================================
proc UI_PB_blk_DeleteBalloon { PAGE_OBJ } {
#==========================================================================
   upvar $PAGE_OBJ page_obj
   global gPB_help_tips

    set c $Page::($page_obj,bot_canvas)

    if {$gPB_help_tips(state)} \
    {
      if [info exists gPB_help_tips($c)] {
        unset gPB_help_tips($c)
      }
      PB_cancel_balloon
      global item_focus_on
      set item_focus_on 0
    }
}

#==========================================================================
proc UI_PB_blk_StartDragAddr {page_obj x y} {
#==========================================================================
  global paOption
  set Page::($page_obj,being_dragged) 1
  set c $Page::($page_obj,bot_canvas)
  set block_obj $Page::($page_obj,active_blk_obj)

  # Unhighlight previously selected icon
    if {$Page::($page_obj,active_blk_elem)} \
    {
      set active_blk_elem $Page::($page_obj,active_blk_elem)
      set icon_id $block_element::($active_blk_elem,icon_id)
      set im [$c itemconfigure $icon_id -image]
      set icon_tag [lindex [$c itemconfigure $icon_id -tags] end]
      if {[string compare $icon_tag "nonmovable"] == 0} \
      {
         [lindex $im end] configure -relief flat -background #c0c0ff
      } else \
      {
         [lindex $im end] configure -relief raised -background #c0c0ff
      }

      set blk_elem_add_obj $block_element::($active_blk_elem,elem_add_obj)
      set address_name $address::($blk_elem_add_obj,add_name)
      if {[string compare $address_name "Text"] == 0} \
      {
         [lindex $im end] configure -background $paOption(text)
      }
    }

  # Highlight current icon
    $c raise current
    set im [$c itemconfigure current -image]
    set cur_img_tag [lindex [lindex [$c itemconfigure current -tags] end] 0]
    [lindex $im end] configure -relief sunken -background pink

    set xx [$c canvasx $x]
    set yy [$c canvasy $y]

    set active_blk_elem_list $block::($block_obj,active_blk_elem_list)
    foreach blk_elem_obj $active_blk_elem_list \
    {
       if {$xx >= $block_element::($blk_elem_obj,rect_corn_x0) && \
           $xx < $block_element::($blk_elem_obj,rect_corn_x1)} \
       { 
              set focus_blk $blk_elem_obj
              set Page::($page_obj,source_elem_obj) $focus_blk
              set Page::($page_obj,active_blk_elem) $focus_blk
              break;
       }
    }

    UI_PB_blk_ConfigureLeader page_obj focus_blk

    if {[string compare $cur_img_tag "movable"] == 0} \
    {
       set origin_xb [$c canvasx $x]
       set origin_yb [$c canvasy $y]
       set Page::($page_obj,last_xb)   $origin_xb
       set Page::($page_obj,last_yb)   $origin_yb
    
       # Create corresponding icon in component panel
         set panel_hi $Page::($page_obj,panel_hi)

       # Fine adjustment in next 2 lines is needed to line up icons nicely.
       # This may have something to do with the -bd & -relief in canvas.
         set dx 1
         set dy [expr $panel_hi + 2]

       set blk_elem_addr $block_element::($blk_elem_obj,elem_add_obj)
       set addr_leader $address::($blk_elem_addr,add_leader)
       set blk_elem_mom_var $block_element::($blk_elem_obj,elem_mom_variable)
  
       UI_PB_com_RetImageAppdText blk_elem_addr blk_elem_mom_var \
                                  image_name blk_elem_text

       set origin_xt [expr [expr $block_element::($focus_blk,rect_corn_x0) + \
                            $block_element::($focus_blk,rect_corn_x1)] / 2] 
       set origin_yt [expr [expr $block_element::($focus_blk,rect_corn_y0) + \
                            $block_element::($focus_blk,rect_corn_y1)] / 2] 

       set diff_x [expr $xx - $origin_xt]
       set diff_y [expr $yy - $origin_yt]

       set top_canvas $Page::($page_obj,top_canvas)
       set img_addr [UI_PB_blk_CreateIcon $top_canvas $image_name \
                                          $blk_elem_text]

       append opt_img pb_ $block_element::($focus_blk,elem_opt_nows_var)
       $img_addr add image -image [tix getimage $opt_img]
       unset opt_img

       set icon_top [$top_canvas create image \
                 [expr $x - $dx - $diff_x] [expr $y + $dy - $diff_y] \
                 -image $img_addr -tag new_comp]
       set Page::($page_obj,icon_top) $icon_top

       set last_xt [expr $x - $dx]
       set last_yt [expr $y + $dy]
    
       set Page::($page_obj,last_xt) $last_xt
       set Page::($page_obj,last_yt) $last_yt

       set im [$top_canvas itemconfigure $icon_top -image]
       [lindex $im end] configure -relief sunken -background pink

       $c bind movable <Enter> ""
       $c bind movable <Leave> ""
    
       # Change cursor
         UI_PB_com_ChangeCursor $c
    }
}

#============================================================================
proc UI_PB_blk_DragAddr {page_obj x y} {
#============================================================================
    set c $Page::($page_obj,bot_canvas)
    set panel_hi $Page::($page_obj,panel_hi)

    set xc [$c canvasx $x]
    set yc [$c canvasy $y]

  # Translate element
    $c move current [expr $xc - $Page::($page_obj,last_xb)] \
                    [expr $yc - $Page::($page_obj,last_yb)]

    set dx 1
    set dy [expr $panel_hi + 2]
 
    set top_canvas $Page::($page_obj,top_canvas)
    set xp [$top_canvas canvasx $x]
    set yp [$top_canvas canvasy $y]

    $top_canvas move $Page::($page_obj,icon_top) \
            [expr $xp - $Page::($page_obj,last_xt) - $dx] \
            [expr $yp - $Page::($page_obj,last_yt) + $dy]

    set Page::($page_obj,last_xb) $xc
    set Page::($page_obj,last_yb) $yc
    set Page::($page_obj,last_xt) [expr $xp - $dx]
    set Page::($page_obj,last_yt) [expr $yp + $dy]

  # Highlight the trash cell
    UI_PB_blk_TrashFocusOn $page_obj $x $y

    set focus_blk_elem $Page::($page_obj,source_elem_obj)
    set addr_obj $block_element::($focus_blk_elem,elem_add_obj)
    set add_name $address::($addr_obj,add_name)

    if {[string compare $add_name "Text"] == 0} \
    {
        UI_PB_blk_HighLightCellDividers $page_obj $xc $yc
    }
}

#============================================================================
proc UI_PB_blk_TrashFocusOn {page_obj x y} {
#============================================================================
   global paOption

   set panel_hi $Page::($page_obj,panel_hi)

   # Highlight current icon
   set trash_cell  $Page::($page_obj,trash)

     if {$x > [lindex $trash_cell 1] && $x < [lindex $trash_cell 2] && \
         $y > [lindex $trash_cell 3] && $y < [lindex $trash_cell 4]} \
     {
        [lindex $trash_cell 0] configure -background $paOption(focus)
        UI_PB_blk_TrashConnectLine page_obj
        set Page::($page_obj,trash_flag) 1

     } else \
     {
        [lindex $trash_cell 0] configure -background $paOption(app_butt_bg)
        set top_canvas $Page::($page_obj,top_canvas)
        $top_canvas delete connect_line
        set Page::($page_obj,trash_flag) 0
     }
}

#============================================================================
proc UI_PB_blk_EndDragAddr {page_obj} {
#============================================================================
   global paOption

   set Page::($page_obj,being_dragged) 0
   set c $Page::($page_obj,bot_canvas)
   set target_cell_num 0
   set source_cell_num 0

   set block_obj $Page::($page_obj,active_blk_obj)
   # Find source cell number id
     if {$Page::($page_obj,add_flag) == 2} \
     {
        set prev_act_elem $Page::($page_obj,insert_elem)
        $c itemconfigure $block_element::($prev_act_elem,div_id) \
            -fill $Page::($page_obj,div_col) -outline $Page::($page_obj,div_col)
        $c delete connect_line
     } elseif {$Page::($page_obj,add_flag) == 3} \
     {
        $c itemconfigure $block::($block_obj,div_id) \
            -fill $Page::($page_obj,div_col) -outline $Page::($page_obj,div_col)
        $c delete connect_line
     }

   # Trash can in focus, dispose element.
    if { $Page::($page_obj,trash_flag) == 1 } \
    {
       UI_PB_blk_UpdateCells page_obj

       [lindex $Page::($page_obj,trash) 0] configure \
               -background $paOption(app_butt_bg)
       set Page::($page_obj,trash_flag) 0

    # Drop for Text address elements
    } elseif {$Page::($page_obj,add_flag)} \
    {
        UI_PB_blk_ChangeTextPosition page_obj
        set Page::($page_obj,add_flag) 0
    } else \
    {
        set source_elem_obj $Page::($page_obj,source_elem_obj)
        UI_PB_blk_ReturnAddr page_obj source_elem_obj
    }

   # Clean up balloon
     UI_PB_blk_DeleteBalloon page_obj

   # Deletes the icon that has been created in the top canvas
    $Page::($page_obj,top_canvas) delete $Page::($page_obj,icon_top)

   # Delete connecting line
     $Page::($page_obj,top_canvas) delete connect_line

   # Rebind callbacks
    $c bind movable <Enter>           "UI_PB_blk_AddrFocusOn $page_obj \
                                                             %x %y"
    $c bind movable <Leave>           "UI_PB_blk_AddrFocusOff $page_obj"

   # Adjust cursor
    $c config -cursor ""

    set last_xb $Page::($page_obj,last_xb)
    set last_yb $Page::($page_obj,last_yb)

    UI_PB_blk_AddrFocusOn  $page_obj $last_xb $last_yb
}

#============================================================================
proc UI_PB_blk_ChangeTextPosition { PAGE_OBJ } {
#============================================================================
   upvar $PAGE_OBJ page_obj

   set c $Page::($page_obj,bot_canvas)
   set block_obj $Page::($page_obj,active_blk_obj)
   set source_elem_obj $Page::($page_obj,source_elem_obj)

   # Deletes all the existing cells and icons
     UI_PB_blk_DeleteCellsIcons page_obj block_obj

    set block_elem_obj_list $block::($block_obj,active_blk_elem_list)
    set cur_indx [lsearch $block_elem_obj_list $source_elem_obj]
    set block_elem_obj_list [lreplace $block_elem_obj_list \
                                  $cur_indx $cur_indx]

    if {$Page::($page_obj,add_flag) == 1 || \
        $Page::($page_obj,add_flag) == 3} \
    {
        lappend block_elem_obj_list $source_elem_obj
    } else \
    {
        set insert_blk_elem $Page::($page_obj,insert_elem)
        set insert_indx [lsearch $block_elem_obj_list $insert_blk_elem]
        set block_elem_obj_list [linsert $block_elem_obj_list \
                         $insert_indx $source_elem_obj]
    }

  set block::($block_obj,active_blk_elem_list) $block_elem_obj_list

  # Gets the image ids of all the elements of a block
    UI_PB_blk_CreateBlockImages page_obj block_obj 

  # proc is called to create the block cells
    set block_owner $block::($block_obj,blk_owner)
    UI_PB_blk_CreateBlockCells page_obj block_obj source_elem_obj \
                               block_owner
  
  # Block Elements binding procedures
    UI_PB_blk_IconBindProcs page_obj

    UI_PB_blk_ConfigureLeader page_obj source_elem_obj
}

#============================================================================
proc UI_PB_blk_UpdateCells {PAGE_OBJ} {
#============================================================================
   upvar $PAGE_OBJ page_obj

   set c $Page::($page_obj,bot_canvas)
   set block_obj $Page::($page_obj,active_blk_obj)

   set source_elem_obj $Page::($page_obj,source_elem_obj)
   set source_cell_num [lsearch $block::($block_obj,active_blk_elem_list) \
                                $source_elem_obj]

   # gets the address object
     set addr_obj $block_element::($source_elem_obj,elem_add_obj)
     address::DeleteFromBlkElemList $addr_obj source_elem_obj

   # Deletes the source icon
    $c delete $block_element::($source_elem_obj,icon_id)
    set block_obj $Page::($page_obj,active_blk_obj)

    UI_PB_blk_UpdateBlkElements page_obj block_obj source_cell_num

    if {$source_cell_num >= 0} \
    {
        set active_blk_elem [lindex $block::($block_obj,active_blk_elem_list) \
                      $source_cell_num]
        UI_PB_blk_ConfigureLeader page_obj active_blk_elem 
    } else \
    {
        set active_blk_elem 0
        UI_PB_blk_ConfigureLeader page_obj active_blk_elem
    }
}

#===============================================================================
proc UI_PB_blk_UpdateBlkElements { PAGE_OBJ BLOCK_OBJ SOURCE_CELL_NUM} {
#===============================================================================
   upvar $PAGE_OBJ page_obj
   upvar $BLOCK_OBJ block_obj
   upvar $SOURCE_CELL_NUM source_cell_num

   set bot_canvas $Page::($page_obj,bot_canvas)
   set source_elem_obj $Page::($page_obj,source_elem_obj)

   # Deletes all the existing cells and icons
     UI_PB_blk_DeleteCellsIcons page_obj block_obj

   set block::($block_obj,active_blk_elem_list) \
             [lreplace $block::($block_obj,active_blk_elem_list) \
                               $source_cell_num $source_cell_num]
  # Block Element Activation
    set no_of_elements [llength $block::($block_obj,active_blk_elem_list)]
    if {$source_cell_num >= $no_of_elements} \
    {
        set source_cell_num [expr $source_cell_num - 1]
    }

    if {$source_cell_num >= 0} \
    {
        set active_blk_elem [lindex $block::($block_obj,active_blk_elem_list) \
                      $source_cell_num]
    } else {
        set active_blk_elem 0
    }

    # Gets the image ids of all the elements of a block
      UI_PB_blk_CreateBlockImages page_obj block_obj 

    set block_owner $block::($block_obj,blk_owner)
    UI_PB_blk_CreateBlockCells page_obj block_obj active_blk_elem \
                               block_owner
}

#===========================================================================
proc UI_PB_blk_DeleteRect {PAGE_OBJ} {
#===========================================================================
   upvar $PAGE_OBJ page_obj
   global paOption

   set x_orig $Page::($page_obj,x_orig)
   set y_orig $Page::($page_obj,y_orig)
   set h_cell $Page::($page_obj,h_cell)
   set w_cell $Page::($page_obj,w_cell)
   set w_divi $Page::($page_obj,w_divi)
   set cell_box_width 4
   set main_cell_color $paOption(can_bg)

   set c $Page::($page_obj,bot_canvas)

   set block_obj $Page::($page_obj,active_blk_obj)
   $c delete $block::($block_obj,rect)

   set no_icons [llength $block::($block_obj,active_blk_elem_list)]

      set x0 [expr $x_orig]
      set y0 [expr $y_orig]
   
      set x1 [expr $x0 + [expr [expr [expr $w_cell + $w_divi] * \
                                           $no_icons] + $w_divi + 8]]
      set y1 [expr $y0 + $h_cell + 8]
   
      set block::($block_obj,rect) [$c create rect $x0 $y0 $x1 $y1 \
                           -fill $main_cell_color -outline $main_cell_color \
                           -tag stationary]
      $c lower $block::($block_obj,rect)

      set block::($block_obj,rect_x0) $x0
      set block::($block_obj,rect_y0) $y0
      set block::($block_obj,rect_x1) $x1
      set block::($block_obj,rect_y1) $y1
}

#==============================================================================
proc UI_PB_blk_AddTextElement { PAGE_OBJ NEW_ELEM_OBJ text_label } {
#==============================================================================
  upvar $PAGE_OBJ page_obj
  upvar $NEW_ELEM_OBJ new_elem_obj

  set bot_canvas $Page::($page_obj,bot_canvas)
  set sel_base_addr $Page::($page_obj,sel_base_addr)
  set block_obj $Page::($page_obj,active_blk_obj)
  set block_owner $block::($block_obj,blk_owner)

  # popup text window, if text element is added
    UI_PB_com_CreateTextEntry page_obj new_elem_obj $text_label
    tkwait window $bot_canvas.txtent
    if {[string compare $block_element::($new_elem_obj,elem_mom_variable) \
                  "000"] != 0} \
    {
        UI_PB_blk_ReplaceIcon page_obj $sel_base_addr $new_elem_obj
        UI_PB_blk_ConfigureLeader page_obj new_elem_obj
    } else \
    {
        UI_PB_blk_DeleteCellsIcons page_obj block_obj

        set block_elem_obj_list $block::($block_obj,active_blk_elem_list)
        set new_index [lsearch $block_elem_obj_list $new_elem_obj]
        set block_elem_obj_list [lreplace $block_elem_obj_list \
                                     $new_index $new_index]
        set block::($block_obj,active_blk_elem_list) $block_elem_obj_list
        set no_elems [llength $block_elem_obj_list]
        if { $no_elems == 0} \
        {
           set active_elem 0
        } elseif { $new_index >= 0 && $new_index < $no_elems} \
        {
           set active_elem [lindex $block_elem_obj_list $new_index]
        } elseif { $new_index == $no_elems} \
        {
           set active_elem [lindex  $block_elem_obj_list \
                                       [expr $new_index - 1]]
        }
        # Gets the image ids of all the elements of a block
          UI_PB_blk_CreateBlockImages page_obj block_obj 
          UI_PB_blk_CreateBlockCells page_obj block_obj active_elem \
                                     block_owner
          UI_PB_blk_ConfigureLeader page_obj active_elem
     }
}

#==============================================================================
proc UI_PB_blk_AddCell {PAGE_OBJ} {
#==============================================================================
  upvar $PAGE_OBJ page_obj

  set bot_canvas $Page::($page_obj,bot_canvas)
  set block_obj $Page::($page_obj,active_blk_obj)

  set new_elem_mom_var $Page::($page_obj,new_elem_mom_var)
  set sel_base_addr $Page::($page_obj,sel_base_addr)

  # Checks the existance of the block element in the block template
  # if the block element exists it gives out a error message and returns
    set blk_elem_flag [UI_PB_com_CheckElemBlkTemplate block_obj \
                                     sel_base_addr]
   if {$blk_elem_flag} \
   {
     UI_PB_com_DisplyErrorMssg sel_base_addr
     return
   }

 # Deletes all the existing cells and icons
   UI_PB_blk_DeleteCellsIcons page_obj block_obj

 # Creates new address
   if { [string compare $sel_base_addr "New_Address"] == 0 } \
   {
       set sel_base_addr "user_def"
       set fmt_name "String"
       PB_int_CreateNewAddress sel_base_addr fmt_name new_add_obj
   }

  # Gets the data of the new block element from the database
  # New block element is added to the block object.
    PB_int_AddNewBlockElemObj sel_base_addr new_elem_mom_var \
                       block_obj new_elem_obj
    set block_element::($new_elem_obj,owner) $block::($block_obj,blk_owner)

    if {[info exists block::($block_obj,active_blk_elem_list)]} \
    {
       set block_elem_obj_list $block::($block_obj,active_blk_elem_list)
    }

    if {$Page::($page_obj,add_flag) == 1 || \
        $Page::($page_obj,add_flag) == 3} \
    {
        lappend block_elem_obj_list $new_elem_obj
    } else \
    {
        set insert_blk_elem $Page::($page_obj,insert_elem)
        set insert_indx [lsearch $block_elem_obj_list $insert_blk_elem]
        set block_elem_obj_list [linsert $block_elem_obj_list \
                         $insert_indx $new_elem_obj]
    }

  # Sorts the block elements of a Block template
    UI_PB_com_SortBlockElements block_elem_obj_list
    set block::($block_obj,active_blk_elem_list) $block_elem_obj_list
    unset block_elem_obj_list

  # Gets the image ids of all the elements of a block
    UI_PB_blk_CreateBlockImages page_obj block_obj 

  # proc is called to create the block cells
    set block_owner $block::($block_obj,blk_owner)
    UI_PB_blk_CreateBlockCells page_obj block_obj new_elem_obj \
                               block_owner

  # Block Elements binding procedures
    UI_PB_blk_IconBindProcs page_obj

    UI_PB_blk_ConfigureLeader page_obj new_elem_obj

    if {[string compare $Page::($page_obj,sel_base_addr) "Text"] == 0} \
    {
      # Called only for text elements
        UI_PB_blk_AddTextElement page_obj new_elem_obj Text
    } elseif { [string compare $Page::($page_obj,sel_base_addr) \
                       "New_Address"] == 0 } \
    {
       # Brings up New address dialog
         set event_obj 0
         set evt_elem_obj 0
         UI_PB_blk_NewAddress page_obj event_obj evt_elem_obj \
                              new_elem_obj block
    } elseif { [string match "*User Defined*" \
                       $block_element::($new_elem_obj,elem_desc)] } \
    {
      # Called for adding an expression
        UI_PB_blk_AddTextElement page_obj new_elem_obj Expression
    } 
}

#==============================================================================
proc UI_PB_blk_TrashConnectLine { PAGE_OBJ } {
#==============================================================================
  global paOption
  upvar $PAGE_OBJ page_obj

  set vtx {}
  set panel_hi $Page::($page_obj,panel_hi)

  # Center of cell
      set x0 [lindex $Page::($page_obj,trash) 1] 
      set x1 [lindex $Page::($page_obj,trash) 2]
      set y0 [lindex $Page::($page_obj,trash) 3]
      set y1 [lindex $Page::($page_obj,trash) 4]

      set x11 [expr [expr $x0 + $x1] / 2]
      set y11 [expr [expr [expr $y0 + $y1] / 2] + $panel_hi]
      lappend vtx $x11 $y11

  # Center of icon in action
      set top_canvas $Page::($page_obj,top_canvas)
      set coords [$top_canvas coords new_comp]
      set x1 [expr [lindex $coords 0] + 1]
      set y1 [lindex $coords 1]

      lappend vtx $x1 $y1
      lappend vtx [expr $x1 - 2] $y1

  # Draw line
     if {[$top_canvas gettags connect_line] == "connect_line"} \
     {
        eval {$top_canvas coords connect_line} $vtx
     } else \
     {
        eval {$top_canvas create poly} $vtx {-fill $paOption(focus) \
                                    -width 1 -outline $paOption(focus) \
                                    -tag connect_line}
     }

     $top_canvas lower connect_line
}

#=============================================================================
proc UI_PB_blk_ItemFocusOn1 {page_obj x y} {
#=============================================================================
  global paOption
  set top_canvas $Page::($page_obj,top_canvas)

   # Highlight current icon
    set im [$top_canvas itemconfigure current -image]
    if [string compare $im ""] \
    {
      [lindex $im end] configure -background $paOption(focus)
    }

   # Change cursor
    $top_canvas config -cursor hand2

    set Page::($page_obj,add_button_focus_on) 1
}

#=============================================================================
proc UI_PB_blk_ItemFocusOff1 {page_obj} {
#=============================================================================
  global paOption

  set top_canvas $Page::($page_obj,top_canvas)

  if {$Page::($page_obj,add_button_focus_on)} \
  {
     # Unhighlight current icon
      set im [$top_canvas itemconfigure current -image]
      [lindex $im end] configure -background $paOption(app_butt_bg)

     # Restore cursor
      $top_canvas config -cursor ""

      set Page::($page_obj,add_button_focus_on) 0
  }
}

#=============================================================================
proc UI_PB_blk_ItemStartDrag1 {page_obj x y} {
#=============================================================================
  global paOption

  set c $Page::($page_obj,bot_canvas)
  set Page::($page_obj,add_cell_flag) 0

  $c raise current

  set origin_xt [$c canvasx $x]
  set origin_yt [$c canvasy $y]

  set Page::($page_obj,last_xt) $origin_xt
  set Page::($page_obj,last_yt) $origin_yt

  # Depress Add button
    $Page::($page_obj,add) configure -bg $paOption(focus) -relief sunken

  # Create icons on all canvases @ cursor
    UI_PB_blk_DrawIconInAllCanvas $page_obj $x $y

  # Change cursor
    UI_PB_com_ChangeCursor $Page::($page_obj,top_canvas)
}

#==============================================================================
proc UI_PB_blk_DrawIconInAllCanvas {page_obj x y } {
#==============================================================================
  set panel_hi $Page::($page_obj,panel_hi)
  set top_canvas $Page::($page_obj,top_canvas)
  set bot_canvas $Page::($page_obj,bot_canvas)
  set new_elem_mom_var $Page::($page_obj,new_elem_mom_var)
  set new_elem_addr $Page::($page_obj,sel_base_addr)

  if { [string compare $new_elem_addr "New_Address"] == 0} \
  {
     set image_name "pb_blank_addr"
     set app_text ""
     set no_chars 5
     UI_PB_com_TrimOrFillAppText app_text no_chars
  } else \
  {
     PB_int_RetAddrObjFromName new_elem_addr add_obj
     UI_PB_com_RetImageAppdText add_obj new_elem_mom_var \
                                image_name app_text
  }

  # Next lines are needed for coords mapping to be correct in
  # canvas that displays the block.
    set dx 0
    set dy [expr $panel_hi + 2]
    set xc [$bot_canvas canvasx [expr $x + $dx]]
    set yc [$bot_canvas canvasy [expr $y - $dy]]
    set cmp2 [UI_PB_blk_CreateIcon $bot_canvas $image_name $app_text]
    $cmp2 add image -image [tix getimage pb_blank]
    set icon_bot [$bot_canvas create image $xc $yc \
                 -image $cmp2 -tag movable]
    set Page::($page_obj,icon_bot) $icon_bot
    $cmp2 configure -relief sunken -background pink

  # Draw icon in component panel
    set xc [$top_canvas canvasx $x]
    set yc [$top_canvas canvasy $y]
    set cmp1 [UI_PB_blk_CreateIcon $top_canvas $image_name $app_text]
    $cmp1 add image -image [tix getimage pb_blank]
    set icon_top [$top_canvas create image $xc $yc \
                 -image $cmp1 -tag new_comp]

    $cmp1 configure -relief sunken -background pink
    set Page::($page_obj,icon_top) $icon_top

   # Since it's already in the callback func attached to the "add_movable"
   # tag, the func will not be executed for the newly created items.
   # We have to tweak the state of focus to avoid the FocusOff1 CB,
   # that will reset the cursor, being executed automatically,
   # because the "Add" button has been obstructed by the new button.

    set Page::($page_obj,add_button_focus_on) 0
}

#==============================================================================
proc UI_PB_blk_ItemDrag1 {page_obj x y} {
#==============================================================================
  set bot_canvas $Page::($page_obj,bot_canvas)
  set top_canvas $Page::($page_obj,top_canvas)
  set panel_hi $Page::($page_obj,panel_hi)
  set sel_addr $Page::($page_obj,sel_base_addr)

  # Icon in the component panel does not need to be
  # manipulated when it goes too far out of the panel.
    set xx [$top_canvas canvasx $x]
    set yy [$top_canvas canvasy $y]
    $top_canvas coords $Page::($page_obj,icon_top) $xx $yy

    set dx 1
    set dy [expr $panel_hi + 2]
    set xx [$bot_canvas canvasx [expr $x + $dx]]
    set yy [$bot_canvas canvasy [expr $y - $dy]]
    $bot_canvas coords $Page::($page_obj,icon_bot) $xx $yy

    if { [string compare $sel_addr "Text"] != 0 } \
    {
       UI_PB_blk_HighlightRect $page_obj $xx $yy
    } else \
    {
       UI_PB_blk_HighLightCellDividers $page_obj $xx $yy
    }
}

#==============================================================================
proc UI_PB_blk_HighLightCellDividers { page_obj xx yy } {
#==============================================================================
  global paOption

  set high_color $paOption(focus)
  set bot_canvas $Page::($page_obj,bot_canvas)
  set block_obj $Page::($page_obj,active_blk_obj)
  set rect_region $Page::($page_obj,rect_region)

  if {$Page::($page_obj,add_flag) == 2} \
  {
     set prev_act_elem $Page::($page_obj,insert_elem)
     $bot_canvas itemconfigure $block_element::($prev_act_elem,div_id) \
         -fill $Page::($page_obj,div_col) -outline $Page::($page_obj,div_col)
  } elseif {$Page::($page_obj,add_flag) == 3} \
  {
     $bot_canvas itemconfigure $block::($block_obj,div_id) \
         -fill $Page::($page_obj,div_col) -outline $Page::($page_obj,div_col)
  }

  set Page::($page_obj,add_flag) 0

  foreach blk_elem_obj $block::($block_obj,active_blk_elem_list) \
  {
     if { $yy > [expr $block_element::($blk_elem_obj,div_corn_y0) - \
                         $rect_region] && \
          $yy < [expr $block_element::($blk_elem_obj,div_corn_y1) + \
                         $rect_region] && \
          $xx > [expr $block_element::($blk_elem_obj,div_corn_x0) - 10] && \
          $xx < [expr $block_element::($blk_elem_obj,div_corn_x1) + 10]} \
     {
         set Page::($page_obj,div_col) [lindex [$bot_canvas itemconfigure \
                         $block_element::($blk_elem_obj,div_id) -fill] end]
         $bot_canvas itemconfigure $block_element::($blk_elem_obj,div_id) \
                -fill $high_color -outline $high_color
         set Page::($page_obj,active_blk_obj) $block_obj
         set Page::($page_obj,insert_elem) $blk_elem_obj
         set rect_coord(0) $block_element::($blk_elem_obj,div_corn_x0)
         set rect_coord(1) $block_element::($blk_elem_obj,div_corn_y0)
         set rect_coord(2) $block_element::($blk_elem_obj,div_corn_x1)
         set rect_coord(3) $block_element::($blk_elem_obj,div_corn_y1)
         UI_PB_blk_BlockConnectLine page_obj rect_coord
         set Page::($page_obj,add_flag) 2
         break
     } else \
     {
         $bot_canvas delete connect_line
         set Page::($page_obj,add_flag) 0
     }
  }

  if {!$Page::($page_obj,add_flag)} \
  {
     if { $yy > [expr $block::($block_obj,div_corn_y0) - \
                         $rect_region] && \
          $yy < [expr $block::($block_obj,div_corn_y1) + \
                         $rect_region] && \
          $xx > [expr $block::($block_obj,div_corn_x0) - 10] && \
          $xx < [expr $block::($block_obj,div_corn_x1) + 10]} \
     {
         set Page::($page_obj,div_col) [lindex [$bot_canvas itemconfigure \
                         $block::($block_obj,div_id) -fill] end]
         $bot_canvas itemconfigure $block::($block_obj,div_id) \
                        -fill $high_color -outline $high_color
         set Page::($page_obj,active_blk_obj) $block_obj
         set rect_coord(0) $block::($block_obj,div_corn_x0)
         set rect_coord(1) $block::($block_obj,div_corn_y0)
         set rect_coord(2) $block::($block_obj,div_corn_x1)
         set rect_coord(3) $block::($block_obj,div_corn_y1)
         UI_PB_blk_BlockConnectLine page_obj rect_coord
         set Page::($page_obj,add_flag) 3
     } else \
     {
         $bot_canvas delete connect_line
         set Page::($page_obj,add_flag) 0
     }
  }
}

#==============================================================================
proc UI_PB_blk_HighlightRect {page_obj x y} {
#==============================================================================
  global paOption

  set high_color $paOption(focus)
  set bot_canvas $Page::($page_obj,bot_canvas)
  set block_obj $Page::($page_obj,active_blk_obj)

  if {[info exists Page::($page_obj,rect_col)] == 1} \
   {
        $bot_canvas itemconfigure $block::($block_obj,rect) \
                 -fill $Page::($page_obj,rect_col) 
   }

    if {$x > [expr $block::($block_obj,rect_x0) - \
                       [expr $Page::($page_obj,rect_region) / 1.5]] && \
        $x < [expr $block::($block_obj,rect_x1) + \
                       $Page::($page_obj,rect_region)] && \
        $y > [expr $block::($block_obj,rect_y0) - \
                       $Page::($page_obj,rect_region)] && \
        $y < [expr $block::($block_obj,rect_y1) + \
                       $Page::($page_obj,rect_region)] } \
     {
         set Page::($page_obj,rect_col) [lindex [$bot_canvas itemconfigure \
                             $block::($block_obj,rect) -fill] end]
         $bot_canvas itemconfigure $block::($block_obj,rect) -fill $high_color
         set Page::($page_obj,active_blk_obj) $block_obj
         set rect_coord(0) $block::($block_obj,rect_x0)
         set rect_coord(1) $block::($block_obj,rect_y0)
         set rect_coord(2) $block::($block_obj,rect_x1)
         set rect_coord(3) $block::($block_obj,rect_y1)
         UI_PB_blk_BlockConnectLine page_obj rect_coord
         set Page::($page_obj,add_flag) 1
     } else \
     {
         $bot_canvas delete connect_line
         set Page::($page_obj,add_flag) 0
     }
}

#==============================================================================
proc UI_PB_blk_BlockConnectLine {PAGE_OBJ RECT_COORD} {
#==============================================================================
  upvar $PAGE_OBJ page_obj
  upvar $RECT_COORD rect_coord
  global paOption

  set panel_hi $Page::($page_obj,panel_hi)

  set vtx {}
  set top_canvas $Page::($page_obj,top_canvas)
  set bot_canvas $Page::($page_obj,bot_canvas)

 # Center of Block
  set x0 $rect_coord(0)
  set y0 $rect_coord(1)
  set x1 $rect_coord(2)
  set y1 $rect_coord(3)
  set x11 [expr [expr $x0 + $x1] / 2]
  set y11 [expr [expr $y0 + $y1] / 2]
  lappend vtx $x11 $y11

  set new_originx [$top_canvas canvasx 0]

  # Center of icon in action
      set coords [$top_canvas coords $Page::($page_obj,icon_top)]
      set x1 [expr [lindex $coords 0] - $new_originx]
      set y1 [lindex $coords 1]
      set y1 [expr $y1 - $panel_hi]
      set x1 [$bot_canvas canvasx $x1]
      set x1 [expr $x1 + 1]
      set y1 [$bot_canvas canvasy $y1]
      lappend vtx $x1 $y1
      set x1 [expr $x1 - 2]
      lappend vtx $x1 $y1


  # Draw line
     if {[$bot_canvas gettags connect_line] == "connect_line"} \
     {
        eval {$bot_canvas coords connect_line} $vtx
     } else \
     {
        eval {$bot_canvas create poly} $vtx {-fill $paOption(focus) \
                                  -width 1 -outline $paOption(focus) \
                                    -tag connect_line}
        $bot_canvas lower connect_line
     }
}

#==============================================================================
proc UI_PB_blk_ItemEndDrag1 {page_obj x1 y1} {
#==============================================================================
  set bot_canvas $Page::($page_obj,bot_canvas)
  set top_canvas $Page::($page_obj,top_canvas)

  set block_obj $Page::($page_obj,active_blk_obj)

  if {[info exists Page::($page_obj,rect_col)] == 1} \
  {
     $bot_canvas itemconfigure $block::($block_obj,rect) \
                   -fill $Page::($page_obj,rect_col)
  }

  if {$Page::($page_obj,add_flag) == 2} \
  {
     set prev_act_elem $Page::($page_obj,insert_elem)
     $bot_canvas itemconfigure $block_element::($prev_act_elem,div_id) \
         -fill $Page::($page_obj,div_col) -outline $Page::($page_obj,div_col)
  } elseif {$Page::($page_obj,add_flag) == 3} \
  {
     $bot_canvas itemconfigure $block::($block_obj,div_id) \
         -fill $Page::($page_obj,div_col) -outline $Page::($page_obj,div_col)
  }

 # Cleanup ghost icons
  if {$Page::($page_obj,icon_bot)} \
  {
     $bot_canvas delete $Page::($page_obj,icon_bot)
     set Page::($page_obj,icon_bot) 0
     if {$Page::($page_obj,add_flag)} \
     {
        $bot_canvas delete connect_line
        UI_PB_blk_AddCell page_obj
        set Page::($page_obj,add_flag) 0
     }
  }

  if {$Page::($page_obj,icon_top)} \
  {
     $top_canvas delete $Page::($page_obj,icon_top)
     set Page::($page_obj,icon_top) 0
  }

   $Page::($page_obj,add) configure -relief raised \
                         -background #c0c0ff

  # Restore cursor and focus
   $top_canvas config -cursor ""
   UI_PB_blk_ItemFocusOn1 $page_obj $x1 $y1
}

#==============================================================================
proc UI_PB_blk_ReturnAddr {PAGE_OBJ SOURCE_BLK_ELEM} {
#==============================================================================
  upvar $PAGE_OBJ page_obj
  upvar $SOURCE_BLK_ELEM source_blk_elem

  set c $Page::($page_obj,bot_canvas)

  set icon_id $block_element::($Page::($page_obj,active_blk_elem),icon_id)
  $c coords $icon_id $block_element::($source_blk_elem,xc) \
                     $block_element::($source_blk_elem,yc)
}

#=============================================================================
proc UI_PB_blk_TabBlockDelete { blk_page_obj } {
#=============================================================================
  # Deletes all the existing cells and icons
    if {[info exists Page::($blk_page_obj,active_blk_obj)]} \
    {
       set active_blk $Page::($blk_page_obj,active_blk_obj)
       UI_PB_blk_DeleteCellsIcons blk_page_obj active_blk

       # updates the active block
         UI_PB_blk_BlkApplyCallBack $blk_page_obj

       unset block::($active_blk,active_blk_elem_list)
       unset Page::($blk_page_obj,active_blk_obj)
    }
}

#=============================================================================
proc UI_PB_blk_TabBlockCreate { blk_page_obj } {
#=============================================================================
  set tree $Page::($blk_page_obj,tree)
  set HLIST [$tree subwidget hlist]

  set ent [$HLIST info selection]
  set index [string range $ent 2 [string length $ent]]
  if {[string compare $index ""] == 0} \
  {
    set index 0
  }

  # Recreates the block tree
    UI_PB_blk_DisplayNameList blk_page_obj index

  # Creates combobox elements
    UI_PB_blk_CreateMenuOptions blk_page_obj 

  UI_PB_blk_BlkItemSelection $blk_page_obj
}

#==============================================================================
proc UI_PB_blk_CreateBlockPage { BLOCK_OBJ FRAME NEW_BLK_PAGE } {
#==============================================================================
  upvar $BLOCK_OBJ block_obj
  upvar $FRAME frame
  upvar $NEW_BLK_PAGE new_blk_page
  global popupvar
  global paOption

  block::readvalue $block_obj blk_obj_attr
  set pname $blk_obj_attr(0)
  set new_blk_page [new Page $pname $pname]

  set win [toplevel $frame.$blk_obj_attr(0)]

  UI_PB_com_CreateTransientWindow $win "BLOCK : $blk_obj_attr(0)" \
                                       "700x600+200+200" "" ""
  # Sets Page parameters
    set Page::($new_blk_page,canvas_frame) $win

  # Sets the block page attributes
    UI_PB_blk_SetPageAttributes new_blk_page

  # Creates a frame for action buttons
    set act_frm [frame $win.actbut]
    pack $act_frm -side bottom -fill x -padx 1 -pady 3

  # Creates the top and bottom canvases
    set top_canvas_dim(0) 80
    set top_canvas_dim(1) 400
    set bot_canvas_dim(0) 2000
    set bot_canvas_dim(1) 1000
    Page::CreateCanvas $new_blk_page top_canvas_dim bot_canvas_dim

  # Adds items to the top canvas
    UI_PB_blk_AddTopFrameItems new_blk_page

  # Adds the Add and Trash buttons to the top canvas
    set Page::($new_blk_page,add_name) " Add Word "
    Page::CreateAddTrashinCanvas $new_blk_page
    Page::CreateMenu $new_blk_page

  # Binds the Add button
    UI_PB_blk_AddBindProcs new_blk_page
    set top_canvas $Page::($new_blk_page,top_canvas)
    $top_canvas bind add_movable <B1-Motion> \
                        "UI_PB_blk_ItemDrag1 $new_blk_page %x %y"
    $top_canvas bind add_movable <ButtonRelease-1> \
                        "UI_PB_blk_ItemEndDrag1 $new_blk_page %x %y"
  # PopupMenu bind call
    UI_PB_blk_CreatePopupMenu new_blk_page

  # Database call for getting the Event items and ude flag
    PB_int_RetEvtCombElems comb_box_elems
    set Page::($new_blk_page,blk_WordNameList) $comb_box_elems

  # Creates combobox elements
    UI_PB_blk_CreateMenuOptions new_blk_page

  # Adds Action buttons
    set box_frm $Page::($new_blk_page,box)
    pack forget $box_frm
    set Page::($new_blk_page,box) $act_frm

  # Displays block attributes in the block page
    UI_PB_blk_DisplayBlockAttr new_blk_page block_obj
}

#===============================================================================
proc UI_PB_blk_EditBlkActionButtons { NEW_BLK_PAGE SEQ_PAGE_OBJ SEQ_OBJ \
                                      ELEMENT_OBJ } {
#===============================================================================
  upvar $NEW_BLK_PAGE new_blk_page
  upvar $SEQ_PAGE_OBJ seq_page_obj
  upvar $SEQ_OBJ seq_obj
  upvar $ELEMENT_OBJ element_obj
  global paOption

  set act_frm $Page::($new_blk_page,box)

  set box1_frm [frame $act_frm.box1]
  set box2_frm [frame $act_frm.box2]
    
  tixForm $box1_frm -top 0 -left 1 -right %50 -padright 20
  tixForm $box2_frm -top 0 -left $box1_frm -padx 1 -right %100

  set box1 [tixButtonBox $box1_frm.bb -orientation horizontal \
           -bd 2 -relief sunken -bg $paOption(butt_bg)]

  set box2 [tixButtonBox $box2_frm.bb -orientation horizontal \
           -bd 2 -relief sunken -bg $paOption(butt_bg)]

  $box1 add def -text Default -width 10 -bg $paOption(app_butt_bg) \
               -command "UI_PB_blk_DefaultCallBack $new_blk_page"
  $box1 add apl -text Restore -width 10 -bg $paOption(app_butt_bg) \
               -command "UI_PB_blk_RestoreCallBack $new_blk_page"

  $box2 add canc -text Cancel -width 10 -bg $paOption(app_butt_bg) \
               -command "UI_PB_blk_EditCancel_CB $new_blk_page $seq_page_obj \
                                                 $seq_obj $element_obj"
  $box2 add ok -text Ok -width 10 -bg $paOption(app_butt_bg) \
               -command "UI_PB_blk_EditOk_CB $new_blk_page $seq_page_obj \
                                             $seq_obj $element_obj"

  pack $box1 -fill x
  pack $box2 -fill x
}

#==============================================================================
proc UI_PB_blk_EditOk_CB { page_obj seq_page_obj seq_obj elem_obj } {
#==============================================================================

  UI_PB_blk_BlkApplyCallBack $page_obj

  set bot_canvas $Page::($seq_page_obj,bot_canvas)
  set blk_img_id $event_element::($elem_obj,icon_id)
  set img [lindex [$bot_canvas itemconfigure $blk_img_id -image] end]
  $img config -relief raised -bg lightSkyBlue

  # Binds the Leave
    $bot_canvas bind blk_movable <Leave> \
                     "UI_PB_evt_BlockFocusOff $seq_page_obj $seq_obj"

#<gsl>  grab release $Page::($page_obj,canvas_frame)
  destroy $Page::($page_obj,canvas_frame)
}

#==============================================================================
proc UI_PB_blk_EditCancel_CB { page_obj seq_page_obj seq_obj elem_obj } {
#==============================================================================
  set block_obj $event_element::($elem_obj,block_obj)
  set bot_canvas $Page::($seq_page_obj,bot_canvas)
  set blk_img_id $event_element::($elem_obj,icon_id)
  set img [lindex [$bot_canvas itemconfigure $blk_img_id -image] end]

  $img config -relief raised -bg lightSkyBlue

  # Changes block data to restore data or previous apply
    array set blk_obj_attr $block::($block_obj,rest_value)
    block::setvalue $block_obj blk_obj_attr
    unset blk_obj_attr

  # Changes data back to restore data or previous apply
    foreach blk_elem_obj $block::($block_obj,elem_addr_list) \
    {
       array set blk_elem_obj_attr $block_element::($blk_elem_obj,rest_value)
       block_element::setvalue $blk_elem_obj blk_elem_obj_attr
       unset blk_elem_obj_attr
    }

  # Binds the Leave
    $bot_canvas bind blk_movable <Leave> \
                     "UI_PB_evt_BlockFocusOff $seq_page_obj $seq_obj"

#<gsl>  grab release $Page::($page_obj,canvas_frame)
  destroy $Page::($page_obj,canvas_frame)
}

#===============================================================================
proc UI_PB_blk_NewBlkActionButtons { NEW_BLK_PAGE SEQ_PAGE_OBJ SEQ_OBJ \
                                     EVT_OBJ ELEM_OBJ } {
#===============================================================================
  upvar $NEW_BLK_PAGE new_blk_page
  upvar $SEQ_PAGE_OBJ seq_page_obj
  upvar $SEQ_OBJ seq_obj
  upvar $EVT_OBJ evt_obj
  upvar $ELEM_OBJ elem_obj
  global paOption

  set act_frm $Page::($new_blk_page,box)

  set box1_frm [frame $act_frm.box1]
  set box2_frm [frame $act_frm.box2]
    
  tixForm $box1_frm -top 0 -left 1 -right %50 -padright 20
  tixForm $box2_frm -top 0 -left $box1_frm -padx 1 -right %100

  set box1 [tixButtonBox $box1_frm.bb -orientation horizontal \
           -bd 2 -relief sunken -bg $paOption(butt_bg)]

  set box2 [tixButtonBox $box2_frm.bb -orientation horizontal \
           -bd 2 -relief sunken -bg $paOption(butt_bg)]

  $box1 add def -text Default -width 10 -bg $paOption(app_butt_bg) \
               -command "UI_PB_blk_DefaultCallBack $new_blk_page"
  $box1 add apl -text Restore -width 10 -bg $paOption(app_butt_bg) \
               -command "UI_PB_blk_RestoreCallBack $new_blk_page"

  $box2 add canc -text Cancel -width 10 -bg $paOption(app_butt_bg) \
            -command "UI_PB_blk_NewBlkCancel_CB $new_blk_page $seq_page_obj\
                                            $seq_obj $evt_obj $elem_obj"
  $box2 add ok -text Ok -width 10 -bg $paOption(app_butt_bg)\
            -command "UI_PB_blk_NewBlkOk_CB $new_blk_page $seq_page_obj\
                                            $seq_obj $evt_obj $elem_obj"
  pack $box1 -fill x
  pack $box2 -fill x
}

#==============================================================================
proc UI_PB_blk_NewBlkOk_CB { page_obj seq_page_obj seq_obj \
                             evt_obj elem_obj} {
#==============================================================================
  global tixOption

  # Applys the block data
    UI_PB_blk_BlkApplyCallBack $page_obj
    set block_obj $Page::($page_obj,active_blk_obj)
    block::readvalue $block_obj blk_obj_attr
    block::DefaultValue $block_obj blk_obj_attr
    unset blk_obj_attr

  # Replaces the underscores in the string with space
    set elem_text $block::($block_obj,block_name)
    set bot_canvas $Page::($seq_page_obj,bot_canvas)
    set t_shift $Page::($seq_page_obj,glob_text_shift)
    set elem_xc $event_element::($elem_obj,xc)
    set elem_yc $event_element::($elem_obj,yc)

    PB_com_GetModEvtBlkName elem_text
    # Deletes the rectangle
      $bot_canvas delete $event_element::($elem_obj,text_id)
      set index [lsearch $sequence::($seq_obj,texticon_ids) \
                          $event_element::($elem_obj,text_id)]
      set elem_icon_id [lindex $sequence::($seq_obj,texticon_ids) \
                              [expr $index + 1]]
      set sequence::($seq_obj,texticon_ids) \
              [lreplace $sequence::($seq_obj,texticon_ids) $index \
                               [expr $index + 1]]

    set elem_text_id [$bot_canvas create text [expr $elem_xc + $t_shift] \
           $elem_yc -text $elem_text -font $tixOption(bold_font) \
                 -tag blk_movable]
    set event_element::($elem_obj,text_id) $elem_text_id
    lappend sequence::($seq_obj,texticon_ids) $elem_text_id $elem_icon_id

#<gsl>  grab release $Page::($page_obj,canvas_frame)
  destroy $Page::($page_obj,canvas_frame)

  set blk_img_id $event_element::($elem_obj,icon_id)
  set img [lindex [$bot_canvas itemconfigure $blk_img_id -image] end]
  $img config -relief raised -bg lightSkyBlue

}

#==============================================================================
proc UI_PB_blk_NewBlkCancel_CB { page_obj seq_page_obj seq_obj \
                                 evt_obj elem_obj } {
#==============================================================================

  set sequence::($seq_obj,drag_evt_obj) $evt_obj
  set sequence::($seq_obj,drag_blk_obj) $elem_obj

  UI_PB_evt_PutBlkInTrash seq_page_obj seq_obj

  # Deletes the block object
    set block_obj $event_element::($elem_obj,block_obj)
    PB_int_RemoveBlkObjFrmList block_obj

  unset sequence::($seq_obj,drag_blk_obj)
  unset sequence::($seq_obj,drag_evt_obj)

#<gsl>  grab release $Page::($page_obj,canvas_frame)
  destroy $Page::($page_obj,canvas_frame)
}

#==============================================================================
proc UI_PB_blk_ModalityDialog { SEQ_PAGE_OBJ SEQ_OBJ ELEM_OBJ CANVAS_FRAME } {
#==============================================================================
  upvar $SEQ_PAGE_OBJ seq_page_obj
  upvar $SEQ_OBJ seq_obj
  upvar $ELEM_OBJ elem_obj
  upvar $CANVAS_FRAME canvas_frame
  global blk_modality
  global paOption
  global tixOption

  set block_obj $event_element::($elem_obj,block_obj)
  block::readvalue $block_obj blk_obj_attr

  set win [toplevel $canvas_frame.mod]
  UI_PB_com_CreateTransientWindow $win "Force Output Once" "" "" ""

#<gsl>  wm title $win " Force Output"

#<gsl>  # Grabs the window
#<gsl>    grab set $win


  set top_frm [frame $win.top -relief ridge -bd 2]
  pack $top_frm -side top -fill both
  set bot_frm [frame $win.bot]
  pack $bot_frm -side bottom -fill x

  set box1 [tixButtonBox $bot_frm.bb -orientation horizontal \
           -bd 2 -relief sunken -bg $paOption(butt_bg)]
  pack $box1 -fill x

  $box1 add can -text Cancel -width 10 -bg $paOption(app_butt_bg)\
           -command "UI_PB_blk_ModalityCancel_CB $win $seq_page_obj $seq_obj \
                                             $elem_obj"
  $box1 add ok -text Ok -width 10 -bg $paOption(app_butt_bg)\
           -command "UI_PB_blk_ModalityOk_CB $win $seq_page_obj $seq_obj \
                                               $elem_obj blk_modality"
  set count 0
  foreach blk_elem_obj $blk_obj_attr(2) \
  {
     block_element::readvalue $blk_elem_obj blk_elem_obj_attr
     set blk_modality($count) $block_element::($blk_elem_obj,force)

     set add_obj $blk_elem_obj_attr(0)
     address::readvalue $add_obj add_obj_attr

     PB_com_MapMOMVariable add_obj blk_elem_obj_attr(1) app_text
     PB_int_ApplyFormatAppText add_obj app_text

     set inp_frm [frame $top_frm.$count -relief solid -bd 2]
     pack $inp_frm -side top -padx 5 -pady 5 -fill both
     append label $add_obj_attr(8) $app_text

     checkbutton $inp_frm.chk -text $label -variable blk_modality($count) \
            -font $tixOption(bold_font) -relief flat -bd 2 -anchor w
     pack $inp_frm.chk -side left -padx 15
     unset label blk_elem_obj_attr add_obj_attr
     incr count
  }
}

#===============================================================================
proc UI_PB_blk_ModalityCancel_CB { win seq_page_obj seq_obj elem_obj} {
#===============================================================================
#<gsl>  grab release $win
  destroy $win

  set bot_canvas $Page::($seq_page_obj,bot_canvas)
  set evt_img_id $event_element::($elem_obj,icon_id)
  set img [lindex [$bot_canvas itemconfigure $evt_img_id -image] end]
  $img config -relief raised -bg lightSkyBlue

  # Binds the Leave
    $bot_canvas bind blk_movable <Leave> \
                     "UI_PB_evt_BlockFocusOff $seq_page_obj $seq_obj"
}

#===============================================================================
proc UI_PB_blk_ModalityOk_CB { win seq_page_obj seq_obj elem_obj \
                               BLK_MODALITY } {
#===============================================================================
  upvar $BLK_MODALITY blk_modality

  set block_obj $event_element::($elem_obj,block_obj)
  block::readvalue $block_obj blk_obj_attr

  set count 0
  foreach blk_elem_obj $blk_obj_attr(2) \
  {
     set block_element::($blk_elem_obj,force) $blk_modality($count)
     incr count
  }

#<gsl>  grab release $win
  destroy $win

  set bot_canvas $Page::($seq_page_obj,bot_canvas)
  set evt_img_id $event_element::($elem_obj,icon_id)
  set img [lindex [$bot_canvas itemconfigure $evt_img_id -image] end]
  $img config -relief raised -bg lightSkyBlue

  # Binds the Leave
    $bot_canvas bind blk_movable <Leave> \
                     "UI_PB_evt_BlockFocusOff $seq_page_obj $seq_obj"
}

