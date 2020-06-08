#===============================================================================
#                    UI_PB_TOOLPATH.TCL
#===============================================================================
##############################################################################
# Description                                                                #
#     This file contains all functions dealing with the creation of          #
#     ui elements for Tool Path Sequenc Events.                              #
#                                                                            #
# Revisions                                                                  #
#                                                                            #
#   Date        Who       Reason                                             #
# 01-feb-1999   mnb       Initial                                            #
# 07-Apr-1999   mnb       Changed bitmap name                                #
# 02-Jun-1999   mnb       Code Integration                                   #
# 04-Jun-1999   mnb       Added pb_ to image names                           #
# 14-Jun-1999   mnb       Added pb_ to optional images                       #
# 22-Jun-1999   gsl       Grab the Sequence page when event window is opened.#
# 28-Jun-1999   mnb       A Text element can be added multiple times to      #
#                         any block of an event                              #
# 29-Jun-1999   mnb       Changed text background color                      #
# 07-Jul-1999   mnb       Incorporated Work Plane change for Rapid Event     #
# 07-Sep-1999   mnb       Block Element Address can be editted & an          #
#                         expression can be added as mom vairbale            #
# 21-Sep-1999   mnb       Added Modality                                     #
# 17-Nov-1999   gsl       Submitted for phase-22.                            #
#                                                                            #
# $HISTORY$                                                                  #
#                                                                            #
##############################################################################

#===============================================================================
proc UI_PB_evt_ToolPath { SEQ_PAGE_OBJ SEQ_OBJ EVENT_OBJ} {
#===============================================================================
  upvar $SEQ_PAGE_OBJ seq_page_obj
  upvar $SEQ_OBJ seq_obj
  upvar $EVENT_OBJ event_obj
  global paOption gPB

  set sequence_name $sequence::($seq_obj,seq_name)
  set event_name $event::($event_obj,event_name)
  set dbase_evt_name $event_name

  set bot_canvas $Page::($seq_page_obj,bot_canvas)
  set evt_img_id $event::($event_obj,icon_id)
  set img [lindex [$bot_canvas itemconfigure $evt_img_id -image] end]
  $img config -relief sunken -bg pink


 # Top level doesn't accept a string having capital chars
  set temp_event_name [split $event_name]
  set event_name [join $temp_event_name _ ]
  set event_name [string tolower $event_name]

##  set seq_canvas $Page::($seq_page_obj,canvas_frame)


  set win $gPB(main_window).$event_name

  if {[winfo exists $win]} \
  {
    raise $win
    focus $win
return
  } else {
    toplevel $win
  }

  # Register this window with the Sequence page
    lappend Page::($seq_page_obj,event_list) $event::($event_obj,event_name)

  set evt_book [new Book win]
  Book::CreateTopLvlPage $evt_book "$event_name"
  set page_obj $Book::($evt_book,top_lvl_evt_page)
  set Page::($page_obj,event_name) $event::($event_obj,event_name)
  
#<gsl>  UI_PB_tpth_LockBookPages seq_page_obj 

  UI_PB_com_CreateTransientWindow $win "EVENT : $dbase_evt_name" "800x700+200+200" \
                                       "UI_PB_tpth_CancelCallBack \
                                        $seq_page_obj $page_obj $event_obj" ""
  set Page::($page_obj,win) $win
  set page_frm $Page::($page_obj,page_id) 
  pack $page_frm -fill both -expand yes

  set ncout_flag 0
  if {[string compare $sequence_name "Machine Control"] == 0} \
  {
      set ncout_flag 1
  }

  # Database call for getting the Event items and ude flag
    PB_int_RetEvtCombElems comb_box_elems

  set item_obj_list $event::($event_obj,evt_itm_obj_list)
  set ude_flag $sequence::($seq_obj,ude_flag)

  if { [llength $item_obj_list ] > 0 } \
  {
     UI_PB_tpth_CreateHorzPane page_obj
     UI_PB_tpth_CreateToolPathComponents page_obj seq_page_obj seq_obj \
                                         event_obj $ncout_flag
     UI_PB_tpth_CreateItemsOfEvent page_obj item_obj_list
     UI_PB_tpth_PackItems page_obj
  } else \
  {
     wm geometry $win 800x500+200+200
     set page_id $Page::($page_obj,page_id)
     set Page::($page_obj,canvas_frame) $page_id
     set Page::($page_obj,param_frame) $page_id
     set Page::($page_obj,box_frame) $page_id
     UI_PB_tpth_CreateToolPathComponents page_obj seq_page_obj seq_obj \
                                         event_obj $ncout_flag
  }

  UI_PB_tpth_CreateMembersOfItem page_obj event_obj

  if {$ude_flag} \
  {
     set no_items [llength $item_obj_list]
     if {$no_items > 0} \
     {
        UI_PB_tpth_CreateUserDefIcon page_obj no_items
     }
  }

  set Page::($page_obj,dummy_blk) 0
  UI_PB_tpth_CreateElemObjects page_obj event_obj

  # Returns the mom variables used by the event
    UI_PB_tpth_GetEventMomVars event_obj evt_mom_var_list
    set Page::($page_obj,evt_mom_var_list) [array get evt_mom_var_list]

  # Restores the event data
    UI_PB_tpth_RestoreEventData page_obj event_obj

  # PopupMenu bind call
    set Page::($page_obj,block_popup_flag) 0
    UI_PB_blk_CreatePopupMenu page_obj

  set Page::($page_obj,blk_WordNameList) $comb_box_elems
  UI_PB_tpth_CreateEventBlockTemplates page_obj event_obj
  UI_PB_blk_CreateMenuOptions page_obj
}

#===============================================================================
proc UI_PB_tpth_LockBookPages { SEQ_PAGE_OBJ } {
#===============================================================================
 upvar $SEQ_PAGE_OBJ seq_page_obj
 global gPB

  if {[llength $Page::($seq_page_obj,event_list)] > 0} \
  {
      set pb_book_id $Book::($gPB(book),book_id)

      $pb_book_id pageconfig mac -state disabled
      $pb_book_id pageconfig pro -state disabled
      $pb_book_id pageconfig def -state disabled
      $pb_book_id pageconfig lis -state disabled
      $pb_book_id pageconfig pre -state disabled
      $pb_book_id pageconfig adv -state disabled

      set pb_book_page_list $Book::($gPB(book),page_obj_list)

      set prg_tpth_page [lindex $pb_book_page_list 1]

      set prg_tpth_book $Page::($prg_tpth_page,book_obj)
      set prg_tpth_book_id $Book::($prg_tpth_book,book_id)

      $prg_tpth_book_id pageconfig prog -state disabled
      $prg_tpth_book_id pageconfig gcod -state disabled
      $prg_tpth_book_id pageconfig mcod -state disabled
      $prg_tpth_book_id pageconfig asum -state disabled
      $prg_tpth_book_id pageconfig wseq -state disabled
   }
}

#===============================================================================
proc UI_PB_tpth_RestoreEventData { PAGE_OBJ EVENT_OBJ } {
#===============================================================================
  upvar $PAGE_OBJ page_obj
  upvar $EVENT_OBJ event_obj
  global mom_sys_arr

  # Restores the event attributes
    event::RestoreValue $event_obj

  # Restores the Event elements data
    if {[string compare $event::($event_obj,evt_elem_list) ""] != 0} \
    {
       foreach evt_elem_obj $event::($event_obj,evt_elem_list) \
       {
           # Restores the event element data
             event_element::RestoreValue $evt_elem_obj

           # Restores the block data
             set block_obj $event_element::($evt_elem_obj,block_obj)
             block::RestoreValue $block_obj

           # Restores the block Elements data
             if {[string compare $block::($block_obj,elem_addr_list) ""] != 0} \
             {
                foreach blk_elem_obj $block::($block_obj,elem_addr_list) \
                {
                   block_element::RestoreValue $blk_elem_obj
                }
             }
       }
    }

  # Restores the values of event mom variables
    array set evt_mom_var $Page::($page_obj,evt_mom_var_list)
    set no_vars [array size evt_mom_var]
    for {set count 0} {$count < $no_vars} {incr count} \
    {
       set mom_var $evt_mom_var($count)
       set rest_evt_mom_var($mom_var) $mom_sys_arr($mom_var)

       if {[string match \$mom* $mom_var]} \
       {
           set data_type [UI_PB_com_RetSysVarDataType mom_var]
           set mom_sys_arr($mom_var) [UI_PB_com_RetValByDataType \
                                $mom_sys_arr($mom_var) $data_type]
       }
    }

    if {[info exists rest_evt_mom_var]} \
    {
       set Page::($page_obj,rest_evt_mom_var) [array get rest_evt_mom_var]
    }
}

#===============================================================================
proc UI_PB_tpth_GetEventMomVars { EVENT_OBJ EVT_MOM_VAR_LIST } {
#===============================================================================
  upvar $EVENT_OBJ event_obj
  upvar $EVT_MOM_VAR_LIST evt_mom_var_list

  set count 0
  if {[string compare $event::($event_obj,evt_itm_obj_list) ""] != 0} \
  {
     foreach item_obj $event::($event_obj,evt_itm_obj_list) \
     {
        if {[string compare $item::($item_obj,grp_obj_list) ""] != 0} \
        {
           foreach grp_obj $item::($item_obj,grp_obj_list) \
           {
             if {[string compare $item_group::($grp_obj,mem_obj_list) ""] != 0} \
             {
                foreach mem_obj $item_group::($grp_obj,mem_obj_list) \
                {
                   if {[string compare $group_member::($mem_obj,mom_var) "null"]} \
                   {
                      if {$group_member::($mem_obj,widget_type) == 5} \
                      {
                         append temp_var $group_member::($mem_obj,mom_var) _int
                         set evt_mom_var_list($count) $temp_var
                         unset temp_var
                         incr count
                         append temp_var $group_member::($mem_obj,mom_var) _dec
                         set evt_mom_var_list($count) $temp_var
                         unset temp_var
                         incr count
                      } else \
                      {
                         set evt_mom_var_list($count) $group_member::($mem_obj,mom_var)
                         incr count
                      }
                   }
                }
             }
           }
        }
     }
  }
}

#===============================================================================
proc UI_PB_tpth_CreateToolPathComponents { PAGE_OBJ SEQ_PAGE_OBJ SEQ_OBJ \
                                           EVENT_OBJ ncout_flag } {
#===============================================================================
  upvar $PAGE_OBJ page_obj
  upvar $SEQ_PAGE_OBJ seq_page_obj
  upvar $SEQ_OBJ seq_obj
  upvar $EVENT_OBJ event_obj
  global paOption
  global val

  set top_canvas_dim(0) 80
  set top_canvas_dim(1) 400
  set bot_canvas_dim(0) 1000
  set bot_canvas_dim(1) 1000

  Page::CreateCanvas $page_obj top_canvas_dim bot_canvas_dim
  set bot_canvas $Page::($page_obj,bot_canvas)
  $bot_canvas config -height 100 -width 400

  # Adds apply,restore,default buttons
   UI_PB_tpth_AddApplyDef page_obj seq_page_obj seq_obj event_obj
         
  # Template Button
   set temp_box [tixButtonBox $Page::($page_obj,canvas_frame).temp \
                 -orientation horizontal \
                 -bd 2 \
                 -relief sunken \
                 -bg gray]

  pack $temp_box -side bottom -fill x -pady 5 -padx 3
  $temp_box add seqtmp -width 30 \
                -text "Select An Event Template" \
                -bg $paOption(app_butt_bg) 

  #Create this frame only for Machine control events
  if {$ncout_flag} \
  {
     UI_PB_tpth_CreateNCOutputFrame page_obj
  }

  # Adds the Add and Trash buttons to the top canvas
   set Page::($page_obj,add_name) " Add Word "
   Page::CreateAddTrashinCanvas $page_obj
   Page::CreateMenu $page_obj

  #Binds the Add button
   UI_PB_blk_AddBindProcs page_obj
   set top_canvas $Page::($page_obj,top_canvas)

   # Binds the motion of first mouse button
   $top_canvas bind add_movable <B1-Motion> \
                        "UI_PB_tpth_ItemDrag1 $page_obj \
                                              $event_obj \
                                              %x %y"
   # Binds the release of first mouse button
   $top_canvas bind add_movable <ButtonRelease-1> \
                        "UI_PB_tpth_ItemEndDrag1 $page_obj \
                                                 $event_obj \
                                                 %x %y"
}

#=============================================================================
proc UI_PB_tpth_CreateEventBlockTemplates { PAGE_OBJ EVENT_OBJ } {
#=============================================================================
  upvar $PAGE_OBJ page_obj
  upvar $EVENT_OBJ event_obj

  UI_PB_tpth_SetPageAttributes page_obj

  # Creates the block elements
    UI_PB_tpth_CreateBlkElements page_obj event_obj
}

#=============================================================================
proc UI_PB_tpth_CreateNCOutputFrame { PAGE_OBJ } {
#=============================================================================
  upvar $PAGE_OBJ page_obj
  global evt_ncoutput_status

  set canvas_frame $Page::($page_obj,canvas_frame)
  set ncout_frame [frame $canvas_frame.ncout]
  pack $ncout_frame -side bottom -fill x -pady 5

  set option_list {"Output Imediately" "Output Later"}
  
  set lbl_frame [Page::CreateLblFrame $ncout_frame ncfrm "N/C Code"]
  grid $lbl_frame
  set output_frm [$lbl_frame subwidget frame]

  set no 0
  set var "\$evt_ncoutput_status"
  foreach option $option_list \
  {
    Page::CreateRadioButton $var $output_frm rad_$no $option
    incr no
  }
}

#=============================================================================
proc UI_PB_tpth_CreateItemsOfEvent { PAGE_OBJ ITEM_OBJ_LIST} {
#=============================================================================
  upvar $PAGE_OBJ page_obj
  upvar $ITEM_OBJ_LIST item_obj_list

  set param_frm $Page::($page_obj,param_frame)
  set item_row 0
  set item_col 0
  set count 0
  foreach item_obj $item_obj_list \
  {
     set item_label $item::($item_obj,label)
     if {[string compare $item_label "null"] != 0} \
     {
         set widget_id [Page::CreateLblFrame $param_frm ent_$count $item_label]
     } else \
     {
         set widget_id [Page::CreateFrame $param_frm ent_$count]
     }
     set item::($item_obj,row) $item_row
     set item::($item_obj,col) $item_col
     set item::($item_obj,widget_id) $widget_id

     if {$item_col != 1} \
     {
          lappend row_items_list $item_obj
          lappend pack_row_items 0
          incr item_col
     } else \
     {
          incr item_row
          set item_col 0
          lappend row_items_list $item_obj
          lappend row_item_obj $row_items_list
          unset row_items_list

          lappend pack_row_items 0
          lappend packed_items $pack_row_items
          unset pack_row_items
     }
     incr count
  }

  if {[info exists row_items_list]} \
  {
     lappend row_item_obj $row_items_list
     unset row_items_list
  }

  if {[info exists pack_row_items]} \
  {
     lappend packed_items $pack_row_items
     unset pack_row_items
  }
  set Page::($page_obj,items_in_row) $row_item_obj
  set Page::($page_obj,packed_items) $packed_items

}

#==============================================================================
proc UI_PB_tpth_CreateUserDefIcon { PAGE_OBJ NO_ITEMS } {
#==============================================================================
  upvar $PAGE_OBJ page_obj
  upvar $NO_ITEMS no_items

  set row_items $Page::($page_obj,items_in_row)
  set param_frame $Page::($page_obj,param_frame)

  set ude_frame [Page::CreateFrame $param_frame ude]
  set no_rows [llength $Page::($page_obj,items_in_row)]

  if { $no_items == 1 } \
  {
     set topitem_obj [lindex $row_items 0]
     set ref_topitem_id $item::($topitem_obj,widget_id)
     tixForm $ude_frame  -top 10  -pady 5 \
                         -bottom &$ref_topitem_id \
                         -left  $ref_topitem_id  \
                         -padx 70
  } elseif {[expr $no_items % 2] == 0 || $no_rows ==  1} \
  {
     set last_elem [llength [lindex $row_items [expr $no_rows - 1]]]
     set topitem_obj [lindex [lindex $row_items [expr $no_rows - 1]] \
                                          [expr $last_elem - 1]]
     set ref_topitem_id $item::($topitem_obj,widget_id)
     tixForm $ude_frame  -top   $ref_topitem_id  -pady 5 \
                         -left  &$ref_topitem_id  \
                         -right &$ref_topitem_id  -padx 25
  
  } else \
  {
     set topitem_obj [lindex [lindex $row_items [expr $no_rows - 2]] 1]
     set ref_topitem_id $item::($topitem_obj,widget_id)
     set sideitem_obj [lindex [lindex $row_items [expr $no_rows - 1]] 0]
     set ref_sideitem_id $item::($sideitem_obj,widget_id)
     tixForm $ude_frame  -top   $ref_topitem_id  -pady 5 \
                         -bottom &$ref_sideitem_id \
                         -left  &$ref_topitem_id  \
                         -right &$ref_topitem_id  -padx 25
  }

  set f_image [tix getimage pb_user]
  button $ude_frame.but -image $f_image
  global gPB_help_tips
  PB_enable_balloon $ude_frame.but
  set gPB_help_tips($ude_frame.but) {User-Defined parameters}
  pack $ude_frame.but -side right -padx 5 -pady 5
}

#==============================================================================
proc UI_PB_tpth_GetItemMembersCount { ITEM_OBJ } {
#==============================================================================
   upvar $ITEM_OBJ item_obj

   set item_groups $item::($item_obj,grp_obj_list)

   set no_of_members 0
   foreach group_obj $item_groups \
   {
      set group_align $item_group::($group_obj,elem_align)
      if {[string compare $group_align "V"] == 0} \
      {
            set no_of_members [expr $item_group::($group_obj,nof_elems) + \
                              $no_of_members]
      } else \
      {
            incr no_of_members
      }
   }
   return $no_of_members
}

#==============================================================================
proc UI_PB_tpth_PackItems { PAGE_OBJ } {
#==============================================================================
  upvar $PAGE_OBJ page_obj

  foreach row_items $Page::($page_obj,items_in_row) \
  {
     # gets the count of members of row items

     if {[llength $row_items] > 1} \
     {
       set first_item_obj [lindex $row_items 0]
       set sec_item_obj [lindex $row_items 1]
       set first_grp_members [UI_PB_tpth_GetItemMembersCount \
                                         first_item_obj]
       set sec_grp_members [UI_PB_tpth_GetItemMembersCount \
                                         sec_item_obj]
     } else \
     {
       set first_item_obj [lindex $row_items 0]
       set first_grp_members 0
       set sec_grp_members 0

     }

     if {$sec_grp_members > $first_grp_members} \
     {
         set item::($sec_item_obj,ref_side) "left"
         UI_PB_tpth_TixForm page_obj sec_item_obj
         set item::($first_item_obj,ref_side) "right"
         UI_PB_tpth_TixForm page_obj first_item_obj
     } elseif {$first_grp_members == 0 && $sec_grp_members == 0} \
     {
         set item::($first_item_obj,ref_side) "right"
         UI_PB_tpth_TixForm page_obj first_item_obj
     } else \
     {
         set item::($first_item_obj,ref_side) "right"
         UI_PB_tpth_TixForm page_obj first_item_obj
         set item::($sec_item_obj,ref_side) "left"
         UI_PB_tpth_TixForm page_obj sec_item_obj
     }
  }
}

#===============================================================================
proc UI_PB_tpth_CreateMembersOfItem { PAGE_OBJ EVENT_OBJ} {
#===============================================================================
  upvar $PAGE_OBJ page_obj
  upvar $EVENT_OBJ event_obj

  if {![info exists Page::($page_obj,items_in_row)]} \
  {
    return
  }

  set item_obj_list $Page::($page_obj,items_in_row) 

  foreach row_items $item_obj_list \
  {
     foreach item_obj $row_items \
     {
        if {[string compare $item::($item_obj,label) "null"] != 0} \
        {
            set widget_id [$item::($item_obj,widget_id) subwidget frame]
        } else \
        {
            set widget_id $item::($item_obj,widget_id)
        }
        set item_group_list $item::($item_obj,grp_obj_list)
        
        set grp_no 0
        if {[string compare $item::($item_obj,grp_align) "V"] == 0} \
        { 
            set pack_item "top"
        } else \
        {
            set pack_item "left"
        }

        foreach group_obj $item_group_list \
        {    
           set group_align $item_group::($group_obj,elem_align)
           set members_obj_list $item_group::($group_obj,mem_obj_list)
           set grp_name $item_group::($group_obj,name)
           if {[string compare $grp_name "null"] == 0} \
           {
              set grp_frame [Page::CreateFrame $widget_id grp_$grp_no]
              pack $grp_frame -side $pack_item -expand yes -fill both -padx 20
           } else \
           {
              set grp_lblframe [Page::CreateLblFrame $widget_id grp_$grp_no \
                                                       $grp_name]
              pack $grp_lblframe -side $pack_item -padx 20
              set grp_frame [$grp_lblframe subwidget frame]
           }
           set memb_no 0
           if {![string compare $group_align "V"]} \
           {
              set memb_pack "top"
           } else \
           {
              set memb_pack "left"
           }

           foreach member_obj $members_obj_list \
           {
               set memb_frame [Page::CreateFrame $grp_frame memb_$memb_no]
               pack $memb_frame -side $memb_pack -expand yes -fill both
               UI_PB_tpth_CreateAWidget page_obj event_obj member_obj \
                                        $memb_frame $memb_no 
               incr memb_no
           }
           incr grp_no
        }
     }
  }
}

#===============================================================================
proc UI_PB_tpth_TixForm { PAGE_OBJ ITEM_OBJ} {
#===============================================================================
  upvar $PAGE_OBJ page_obj
  upvar $ITEM_OBJ item_obj

  UI_PB_tpth_GetReferenceWidgets page_obj item_obj ref_topitem_id \
                                 ref_sideitem_id

  if {$ref_topitem_id} \
  {
    set ref_topitem_id $item::($ref_topitem_id,widget_id)
  }

  if {$ref_sideitem_id} \
  {
    set ref_sideitem_id $item::($ref_sideitem_id,widget_id)
  }

  set packed_items $Page::($page_obj,packed_items)
  set item_row $item::($item_obj,row)
  set item_col $item::($item_obj,col)
  set row_items [lindex $packed_items $item_row]
  set row_items [lreplace $row_items $item_col $item_col $item_obj]
  set packed_items [lreplace $packed_items $item_row $item_row $row_items]
  set Page::($page_obj,packed_items) $packed_items

  set ref_side $item::($item_obj,ref_side)
  set widget_id $item::($item_obj,widget_id)

  if { $ref_topitem_id == 0  && $ref_sideitem_id == 0 } \
  {
       tixForm $widget_id  -top  10  -pady 5 \
                           -$ref_side %50 -padx 25
  } elseif { $ref_topitem_id == 0 && $ref_sideitem_id != 0 } \
  {
       tixForm $widget_id  -top  10  -pady 5 \
                           -bottom &$ref_sideitem_id \
                           -$ref_side $ref_sideitem_id -padx 25
  } elseif { $ref_topitem_id != 0 && $ref_sideitem_id == 0} \
  {
       tixForm $widget_id  -top   $ref_topitem_id  -pady 5 \
                           -left  &$ref_topitem_id  \
                           -right &$ref_topitem_id  -padx 25
  } else \
  {
       tixForm $widget_id  -top   $ref_topitem_id  -pady 5 \
                           -bottom &$ref_sideitem_id \
                           -left  &$ref_topitem_id  \
                           -right &$ref_topitem_id  -padx 25
  }
}

#===============================================================================
proc UI_PB_tpth_GetReferenceWidgets { PAGE_OBJ ITEM_OBJ REF_TOPITEM_ID \
                                      REF_SIDEITEM_ID} {
#===============================================================================
    upvar $PAGE_OBJ page_obj
    upvar $ITEM_OBJ item_obj
    upvar $REF_TOPITEM_ID ref_topitem_id
    upvar $REF_SIDEITEM_ID ref_sideitem_id

    set packed_items $Page::($page_obj,packed_items)
    set ref_side $item::($item_obj,ref_side)

    set row $item::($item_obj,row)
    set col $item::($item_obj,col)

    if {$row} \
    {
       set row_item_list  [lindex $packed_items [expr $row - 1]]
       set ref_topitem_id [lindex  $row_item_list $col]
    } else \
    {
       set ref_topitem_id 0
    }

    if {[string compare $ref_side "left"] == 0} \
    {
       set ref_incr -1
    } else \
    {
       set ref_incr 1
    }

    set row_item_list  [lindex $packed_items $row]
    if {[llength $row_item_list] > 1} \
    {
       set ref_sideitem_id [lindex $row_item_list [expr $col + $ref_incr]]
    } else \
    {
       set ref_sideitem_id 0
    }
}

#===============================================================================
proc UI_PB_tpth_CreateAWidget {PAGE_OBJ EVENT_OBJ MEMBER_OBJ inp_frm no} {
#===============================================================================
   upvar $PAGE_OBJ page_obj
   upvar $EVENT_OBJ event_obj
   upvar $MEMBER_OBJ member_obj
   global mom_sys_arr

   set label $group_member::($member_obj,label)
   if {[string compare $label "null"] == 0} \
   {
       set label ""
   }

   set widget_type $group_member::($member_obj,widget_type)
   set val1 $group_member::($member_obj,mom_var)
   set call_back $group_member::($member_obj,callback)

   switch $widget_type \
   {
       0 {
            set ext int_$no
            Page::CreateIntControl $val1 $inp_frm $ext $label
         }

       1 {
            set ext but_$no
            Page::CreateButton $inp_frm $ext $label 
         }

       2 {
            set data_type $group_member::($member_obj,data_type)
            set ext lent_$no
            Page::CreateLblEntry $data_type $val1 $inp_frm $ext $label 
         }
 
       3 {
            set ext chkbut_$no
            Page::CreateCheckButton $val1 $inp_frm $ext $label 
         }

       4 {
            set ext radbut_$no
            Page::CreateRadioButton $val1 $inp_frm $ext $label 
         }

       5 {
            set ext flot_$no
            append temp1 $val1 _int
            append temp2 $val1 _dec
            set val1 $temp1
            set val2 $temp2
            unset temp1 
            unset temp2
            Page::CreateFloatControl $val1 $val2 $inp_frm $ext $label 
         }

       6 {
            set ext bent_$no
            Page::CreateEntry $val1 $inp_frm $ext
         }
      
       7 {
            set ext lb_$no
            Page::CreateLabel $inp_frm $ext $label
         }
    
       8 {
            set ext opt_$no
            set optional_lis $group_member::($member_obj,opt_list)
            Page::CreateOptionalMenu $val1 $inp_frm $ext $optional_lis \
                                     $label
         }
   }
   if {[string compare $call_back "null"] != 0} \
   {
        $inp_frm.$ext config -command "$call_back $page_obj \
                              $event_obj $member_obj"
   }
}

#===============================================================================
proc UI_PB_tpth_OtherOptions { page_obj event_obj member_obj } {
#===============================================================================
  global mom_sys_arr
  global paOption

  set canvas_frame $Page::($page_obj,canvas_frame)
  if {[winfo exists $canvas_frame.oth]} \
  {
    raise $scanvas_frame.oth
    focus $scanvas_frame.oth
return
  }

  set mom_variables {\$oth_rev_xy_plane \$oth_rev_yz_plane \$oth_rev_zx_plane \
                     \$oth_sup_out_ijk_zero \$oth_sup_out_ijk_xyz}

  foreach var $mom_variables \
  {
    set rest_var($var) $mom_sys_arr($var)
  }
  set Page::($page_obj,rest_page_momvalues) [array get rest_var]
  set Page::($page_obj,page_momvars) $mom_variables

  set win [toplevel $canvas_frame.oth]
  UI_PB_com_CreateTransientWindow $win "Circular Move -- Other Options" "" "" ""

  set top_frm [frame $win.top]
  set bot_frm [frame $win.bot]
  pack $top_frm -side top -fill x -padx 10 -pady 10 
  pack $bot_frm -side bottom -fill x -padx 10 -pady 10

  set plane_lbfrm [Page::CreateLblFrame $top_frm ijk " IJK Options "]
  pack $plane_lbfrm -side top -pady 5 -padx 25
  set pln_frm [$plane_lbfrm subwidget frame]

  # IJK Options
    set frm1 [frame $pln_frm.1]
    set frm2 [frame $pln_frm.2]
    set frm3 [frame $pln_frm.3]
    pack $frm1 $frm2 $frm3 -side left -anchor nw -padx 10 -pady 10 

    UI_PB_mthd_CreateCheckButton \$oth_rev_xy_plane $frm1 rad "XY"
    UI_PB_mthd_CreateCheckButton \$oth_rev_yz_plane $frm2 rad "YZ"
    UI_PB_mthd_CreateCheckButton \$oth_rev_zx_plane $frm3 rad "ZX"

  # Suppress output of i = 0, j = 0, k = 0;
    set ijk_zero [frame $top_frm.ijk0]
    pack $ijk_zero -side top -pady 5 -padx 25
    UI_PB_mthd_CreateCheckButton \$oth_sup_out_ijk_zero $ijk_zero rad \
                  "Suppress Output of \{I = 0\} \{J = 0\} \{k = 0\}"

  # Suppress output of i = x, j = y, k = z;
    set ijk_xyz [frame $top_frm.ijkxyz]
    pack $ijk_xyz -side top -pady 5 -padx 25
    UI_PB_mthd_CreateCheckButton \$oth_sup_out_ijk_xyz $ijk_xyz rad \
                  "Suppress Output of \{I = X\} \{J = Y\} \{k = Z\}"

    UI_PB_tpth_DialogActionButtons $win $page_obj $bot_frm
}

#===============================================================================
proc UI_PB_tpth_IJKOptions { page_obj event_obj member_obj } {
#===============================================================================
  global mom_sys_arr
  global paOption

  set canvas_frame $Page::($page_obj,canvas_frame)
  set win $canvas_frame.ijk

  if {[winfo exists $win]} \
  {
    raise $win
    focus $win
return
  } else {
    toplevel $win
    UI_PB_com_CreateTransientWindow $win "Circular Move -- I, J, K Options" "" "" ""
  }

  set mom_variables {\$cir_ijk_opt}

  foreach var $mom_variables \
  {
    set rest_var($var) $mom_sys_arr($var)
  }
  set Page::($page_obj,rest_page_momvalues) [array get rest_var]
  set Page::($page_obj,page_momvars) $mom_variables

  set top_frm [frame $win.top]
  set bot_frm [frame $win.bot]
  pack $top_frm -side top -fill x -padx 10 -pady 10 
  pack $bot_frm -side bottom -fill x -padx 10 -pady 10

  set plane_lbfrm [Page::CreateLblFrame $top_frm ijk " IJK Options "]
  pack $plane_lbfrm -pady 5 -padx 25
  set pln_frm [$plane_lbfrm subwidget frame]

  # IJK Options
    set frm1 [frame $pln_frm.1]
    set frm2 [frame $pln_frm.2]
    set frm3 [frame $pln_frm.3]
    set frm4 [frame $pln_frm.4]
    pack $frm1 $frm2 $frm3 $frm4  -anchor nw -padx 10 -pady 10 

    UI_PB_mthd_CreateRadioButton \$cir_ijk_opt $frm1 rad \
                      "Vector-Start of Arc to Center"
    $frm1.rad config -command "UI_PB_tpth_IJKRadBut_CB"
    UI_PB_mthd_CreateRadioButton \$cir_ijk_opt $frm2 rad \
                      "Vector-Center to Start of Arc"
    $frm2.rad config -command "UI_PB_tpth_IJKRadBut_CB"
    UI_PB_mthd_CreateRadioButton \$cir_ijk_opt $frm3 rad \
                      "Unsigned Vector-Start of Arc to Center"
    $frm3.rad config -command "UI_PB_tpth_IJKRadBut_CB"
    UI_PB_mthd_CreateRadioButton \$cir_ijk_opt $frm4 rad \
                      "Vector-Absolute Arc Center"
    $frm4.rad config -command "UI_PB_tpth_IJKRadBut_CB"

  # Bottom Frame
    set box1_frm [frame $bot_frm.box1]
    set box2_frm [frame $bot_frm.box2]

    tixForm $box1_frm -top 0 -left 3 -right %50 -padright 20
    tixForm $box2_frm -top 0 -left $box1_frm -padx 3 -right %100

    set bb1 [tixButtonBox $box1_frm.bb -orientation horizontal \
             -relief sunken -bd 2 -bg $paOption(butt_bg)]

    set bb2 [tixButtonBox $box2_frm.bb -orientation horizontal \
             -relief sunken -bd 2 -bg $paOption(butt_bg)]

    $bb1 add def -text Default -width 10 -underline 0 \
                 -command "UI_PB_tpth_IJKDefault_CB $page_obj"
    $bb1 add res -text Restore -underline 0 -width 10 \
                 -command "UI_PB_tpth_IJKRestore_CB $page_obj"

    $bb2 add cac -text Cancel -width 10 -underline 0 \
                 -command "UI_PB_tpth_DialogCancel_CB $win $page_obj"
    $bb2 add ok -text Ok -width 10 -underline 0 \
                 -command "UI_PB_tpth_DialogOk_CB $win $page_obj"
    pack $bb1 -fill x
    pack $bb2 -fill x
}

#===============================================================================
proc UI_PB_tpth_IJKRadBut_CB { } {
#===============================================================================
  global mom_sys_arr

  set mom_sys_arr(\$cir_vector) [join [split $mom_sys_arr(\$cir_ijk_opt) _] " "]
}

#===============================================================================
proc UI_PB_tpth_IJKDefault_CB { page_obj } {
#===============================================================================
  global mom_sys_arr

  UI_PB_tpth_DialogDefault_CB $page_obj
  set mom_sys_arr(\$cir_vector) [join [split $mom_sys_arr(\$cir_ijk_opt) _] " "]
}

#===============================================================================
proc UI_PB_tpth_IJKRestore_CB { page_obj } {
#===============================================================================
  global mom_sys_arr

  UI_PB_tpth_DialogRestore_CB $page_obj
  set mom_sys_arr(\$cir_vector) [join [split $mom_sys_arr(\$cir_ijk_opt) _] " "]
}

#===============================================================================
proc UI_PB_tpth_EditPlaneCodes { page_obj event_obj member_obj } {
#===============================================================================
  global mom_sys_arr

  set canvas_frame $Page::($page_obj,canvas_frame)
  set win $canvas_frame.epc

  if {[winfo exists $win]} \
  {
    raise $win
    focus $win
return
  } else {
    toplevel $win
    UI_PB_com_CreateTransientWindow $win "Circular Move -- Plane Codes" "" "" ""
  }

  set mom_variables { \$mom_sys_cutcom_plane_code(XY) \
                      \$mom_sys_cutcom_plane_code(YZ) \
                      \$mom_sys_cutcom_plane_code(ZX)}

  foreach var $mom_variables \
  {
    set rest_var($var) $mom_sys_arr($var)
  }
  set Page::($page_obj,rest_page_momvalues) [array get rest_var]
  set Page::($page_obj,page_momvars) $mom_variables

  set top_frm [frame $win.top]
  set bot_frm [frame $win.bot]
  pack $top_frm -side top -fill x -padx 10 -pady 10 
  pack $bot_frm -side bottom -fill x -padx 10 -pady 10

  set plane_lbfrm [Page::CreateLblFrame $top_frm edt " Plane G Codes "]
  pack $plane_lbfrm -pady 5 -padx 25
  set pln_frm [$plane_lbfrm subwidget frame]

  # Plane Codes
    set xy_frm [frame $pln_frm.xy]
    set yz_frm [frame $pln_frm.yz]
    set zx_frm [frame $pln_frm.zx]
    pack $xy_frm $yz_frm $zx_frm -anchor nw -padx 10 -pady 10 

    UI_PB_mthd_CreateLblEntry a \$mom_sys_cutcom_plane_code(XY) $xy_frm \
                                 int "XY Plane"
    UI_PB_mthd_CreateLblEntry a \$mom_sys_cutcom_plane_code(YZ) $yz_frm \
                                 int "YZ Plane"
    UI_PB_mthd_CreateLblEntry a \$mom_sys_cutcom_plane_code(ZX) $zx_frm \
                                 int "ZX Plane"

    UI_PB_tpth_DialogActionButtons $win $page_obj $bot_frm
}

#===============================================================================
proc UI_PB_tpth_DialogActionButtons { win page_obj action_frm } {
#===============================================================================
  global paOption

  # Bottom Frame
    set box1_frm [frame $action_frm.box1]
    set box2_frm [frame $action_frm.box2]

    tixForm $box1_frm -top 0 -left 3 -right %50 -padright 20
    tixForm $box2_frm -top 0 -left $box1_frm -padx 3 -right %100

    set bb1 [tixButtonBox $box1_frm.bb -orientation horizontal \
             -relief sunken -bd 2 -bg $paOption(butt_bg)]

    set bb2 [tixButtonBox $box2_frm.bb -orientation horizontal \
             -relief sunken -bd 2 -bg $paOption(butt_bg)]

    $bb1 add def -text Default -width 10 -underline 0 \
                 -command "UI_PB_tpth_DialogDefault_CB $page_obj"
    $bb1 add res -text Restore -underline 0 -width 10 \
                 -command "UI_PB_tpth_DialogRestore_CB $page_obj"

    $bb2 add cac -text Cancel -width 10 -underline 0 \
                 -command "UI_PB_tpth_DialogCancel_CB $win $page_obj"
    $bb2 add ok -text Ok -width 10 -underline 0 \
                 -command "UI_PB_tpth_DialogOk_CB $win $page_obj"
    pack $bb1 -fill x
    pack $bb2 -fill x
}

#===============================================================================
proc UI_PB_tpth_DialogDefault_CB { page_obj } {
#===============================================================================
  global mom_sys_arr
  set mom_var_list $Page::($page_obj,page_momvars)

  set count 0
  foreach var $mom_var_list \
  {
     set mom_var_arr($count) $var
     incr count
  }

  PB_int_RetDefMOMVarValues mom_var_arr def_var_values 
  foreach var $mom_var_list \
  {
     set mom_sys_arr($var) $def_var_values($var)
  }
}

#===============================================================================
proc UI_PB_tpth_DialogRestore_CB { page_obj } {
#===============================================================================
  global mom_sys_arr
  set mom_var_list $Page::($page_obj,page_momvars)
  array set rest_var_values $Page::($page_obj,rest_page_momvalues)

  foreach var $mom_var_list \
  {
     set mom_sys_arr($var) $rest_var_values($var)
  }
}

#===============================================================================
proc UI_PB_tpth_DialogOk_CB { win page_obj } {
#===============================================================================
  global mom_sys_arr
  set mom_var_list $Page::($page_obj,page_momvars)

  PB_int_UpdateMOMVar mom_sys_arr
  foreach var $mom_var_list \
  {
    set rest_var_values($var) $mom_sys_arr($var)
  }
  unset Page::($page_obj,rest_page_momvalues)
  unset Page::($page_obj,page_momvars)

  destroy $win
}

#===============================================================================
proc UI_PB_tpth_DialogCancel_CB { win page_obj } {
#===============================================================================

  UI_PB_tpth_DialogRestore_CB $page_obj
  unset Page::($page_obj,rest_page_momvalues)
  unset Page::($page_obj,page_momvars)

  destroy $win
}

#===============================================================================
proc UI_PB_tpth_ConfToolCode { page_obj event_obj member_obj } {
#===============================================================================
  global tixOption
  global paOption
  global mom_sys_arr

  set canvas_frame $Page::($page_obj,canvas_frame)
  set win $canvas_frame.tlcd

  if {[winfo exists $win]} \
  {
    raise $win
    focus $win
return
  } else {
    toplevel $canvas_frame.tlcd
    UI_PB_com_CreateTransientWindow $win "Tool Code Configuration" "" "" ""
  }

  set mom_variables { \$tool_min_num \$tool_max_num \$tool_num_output}
  foreach var $mom_variables \
  {
    set rest_var($var) $mom_sys_arr($var)
  }
  set Page::($page_obj,rest_page_momvalues) [array get rest_var]
  set Page::($page_obj,page_momvars) $mom_variables

  set top_frm [tixButtonBox $win.top -orientation horizontal \
                 -bd 2 -relief sunken -bg gray85]
  set mid_frm [frame $win.mid]
  set bot_frm [frame $win.bot]

  pack $top_frm -side top -fill x -padx 10 -pady 10 
  pack $mid_frm -padx 10 -pady 10
  pack $bot_frm -side bottom -fill x -padx 10 -pady 10

  # Top Frame
    button $top_frm.fmt -text "" -cursor "" \
                  -font $tixOption(bold_font) \
                  -bg darkSeaGreen3 -relief flat \
                  -state disabled -disabledforeground lightYellow
    grid $top_frm.fmt -row 1 -column 1 -pady 20

  $top_frm.fmt configure -activebackground darkSeaGreen3

  # Middle Frame
    set tl_num_frm [Page::CreateLblFrame $mid_frm tlnum "Tool Number"]
    set out_frm [Page::CreateLblFrame $mid_frm out "Output"]
  
    tixForm $tl_num_frm -top 10 -left %10 -right %90 -pady 5 -padx 25
    tixForm $out_frm -top $tl_num_frm -left &$tl_num_frm \
                     -right &$tl_num_frm -pady 5 -padx 25

    set tlsubfrm  [$tl_num_frm subwidget frame]
    set outsubfrm [$out_frm    subwidget frame]

  # Tool Number
    set lft_frm [frame $tlsubfrm.lft]
    set rgh_frm [frame $tlsubfrm.rgt]
    pack $lft_frm -side left 
    pack $rgh_frm -side right 

    UI_PB_mthd_CreateIntControl \$tool_min_num $lft_frm int Minimum
    UI_PB_mthd_CreateIntControl \$tool_max_num $rgh_frm int Maximum

  # Output
    set frm1 [frame $outsubfrm.top]
    set frm2 [frame $outsubfrm.mid]
    set frm3 [frame $outsubfrm.bot]
    pack $frm1 -anchor nw -pady 10 -padx 10
    pack $frm2 -anchor nw -pady 10 -padx 10
    pack $frm3 -anchor nw -pady 10 -padx 10
    UI_PB_mthd_CreateRadioButton \$tool_num_output $frm1 rad \
                      "Tool Number Only"
    $frm1.rad config -command "UI_PB_tpth_ChangeToolCodeOutput $top_frm"
    UI_PB_mthd_CreateRadioButton \$tool_num_output $frm2 rad \
                      "Tool Number And Length Offset Number"
    $frm2.rad config -command "UI_PB_tpth_ChangeToolCodeOutput $top_frm"
    UI_PB_mthd_CreateRadioButton \$tool_num_output $frm3 rad \
                      "Length Offset Number And Tool Number"
    $frm3.rad config -command "UI_PB_tpth_ChangeToolCodeOutput $top_frm"

  # Bottom Frame
    set box1_frm [frame $bot_frm.box1]
    set box2_frm [frame $bot_frm.box2]

    tixForm $box1_frm -top 0 -left 3 -right %50 -padright 20
    tixForm $box2_frm -top 0 -left $box1_frm -padx 3 -right %100

    set bb1 [tixButtonBox $box1_frm.bb -orientation horizontal \
             -relief sunken -bd 2 -bg $paOption(butt_bg)]

    set bb2 [tixButtonBox $box2_frm.bb -orientation horizontal \
             -relief sunken -bd 2 -bg $paOption(butt_bg)]

    $bb1 add def -text Default -width 10 -underline 0 \
                 -command "UI_PB_tpth_ToolConfDefault $page_obj $top_frm"
    $bb1 add res -text Restore -underline 0 -width 10 \
                 -command "UI_PB_tpth_ToolConfRestore $page_obj $top_frm"

    $bb2 add cac -text Cancel -width 10 -underline 0 \
                 -command "UI_PB_tpth_DialogCancel_CB $win $page_obj"
    $bb2 add ok -text Ok -width 10 -underline 0 \
                 -command "UI_PB_tpth_DialogOk_CB $win $page_obj"
    pack $bb1 -fill x
    pack $bb2 -fill x

    UI_PB_tpth_ChangeToolCodeOutput $top_frm
}

#===============================================================================
proc UI_PB_tpth_ChangeToolCodeOutput { top_frm } {
#===============================================================================
  global mom_sys_arr

  set button_widget $top_frm.fmt

  set tool_number 1
  set length_offset 1
  set toolnum_var "\$mom_tool_number"
  set length_adjust "\$mom_tool_adjust_register"

  set toolnum_add [UI_PB_com_RetAddrOfMOMSysVar toolnum_var]
  set tooloff_add [UI_PB_com_RetAddrOfMOMSysVar length_adjust]

  address::readvalue $toolnum_add toolnum_addr_attr
  address::readvalue $tooloff_add tooloff_addr_attr

  format::readvalue $toolnum_addr_attr(1) toolnum_fmt_attr
  format::readvalue $tooloff_addr_attr(1) tooloff_fmt_attr

  switch $mom_sys_arr(\$tool_num_output) \
  {
    Tool_Number_Only  \
    {
       set inp_value 1
    }

    Tool_Number_And_Length_Offset_Number \
    {
       set toolnum_fmt_attr(5) [expr $toolnum_fmt_attr(5) + \
                                                $tooloff_fmt_attr(5)]
       set raise_p [expr $toolnum_fmt_attr(5) - 1]
       set inp_value [expr [expr pow(10,$raise_p) * 1] + 2]
    }

    Length_Offset_Number_And_Tool_Number \
    {
       set toolnum_fmt_attr(5) [expr $toolnum_fmt_attr(5) + \
                                           $tooloff_fmt_attr(5)]
       set raise_p [expr $toolnum_fmt_attr(5) - 1]
       set inp_value [expr [expr pow(10,$raise_p) * 1] + 2]

    }
  }

  PB_fmt_RetFmtOptVal toolnum_fmt_attr inp_value fmt_value
  $top_frm.fmt configure -text $fmt_value
}

#===============================================================================
proc UI_PB_tpth_ToolConfDefault { page_obj top_frm } {
#===============================================================================
  UI_PB_tpth_DialogDefault_CB $page_obj
  UI_PB_tpth_ChangeToolCodeOutput $top_frm 
}

#===============================================================================
proc UI_PB_tpth_ToolConfRestore { page_obj top_frm } {
#===============================================================================
  UI_PB_tpth_DialogRestore_CB $page_obj
  UI_PB_tpth_ChangeToolCodeOutput $top_frm 
}

#===============================================================================
proc UI_PB_tpth_EditRapidBlocks { page_obj event_obj member_obj } {
#===============================================================================
  global mom_sys_arr

  set variable $group_member::($member_obj,mom_var)
  set event_name $event::($event_obj,event_name)
  set evt_elem_list $event::($event_obj,evt_elem_list)

  # Deletes the event attributes 
    UI_PB_tpth_DeleteTpthEventBlkAttr page_obj event_obj
    UI_PB_tpth_SetPageAttributes page_obj

  set index 0
  set spin_blk 0
  set trav_blk 0
  foreach evt_elem_obj $evt_elem_list \
  {
     set block_obj $event_element::($evt_elem_obj,block_obj)
     set block_name $block::($block_obj,block_name)
     switch $block_name \
     {
        "rapid_traverse" { 
                           set trav_blk $block_obj
                           set trav_index $index
                         }
        "rapid_spindle"  { 
                           set spin_blk $block_obj
                           set spin_index $index
                         }
     }
     incr index
  }

  if { $mom_sys_arr($variable) && $trav_blk != 0 } \
  {
     set blk_obj_attr(0) "rapid_spindle"
     foreach tra_elem_obj $block::($trav_blk,active_blk_elem_list) \
     {
        set trav_elem_add $block_element::($tra_elem_obj,elem_add_obj)
        set trav_add_name $address::($trav_elem_add,add_name)
        if {[string compare $trav_add_name "Z"] == 0 || \
            [string compare $trav_add_name "H"] == 0 || \
            [string compare $trav_add_name "M_cool"] == 0} \
        {
           lappend spin_blk_elem $tra_elem_obj
        } else \
        {
           lappend tra_blk_elem $tra_elem_obj
           if {[string compare $trav_add_name "G_motion"] == 0} \
           {
              PB_int_CreateBlkElemFromElemObj tra_elem_obj new_elem_obj \
                                              blk_obj_attr
              lappend spin_blk_elem $new_elem_obj
              set block_element::($new_elem_obj,owner) $event_name
           }
        }
     }
     set block::($trav_blk,active_blk_elem_list) $tra_blk_elem
     PB_int_CreateNewBlock blk_obj_attr(0) spin_blk_elem event_name \
                           new_blk_obj
     set block::($new_blk_obj,active_blk_elem_list) $spin_blk_elem
     set evt_elem_type "normal"
     PB_int_CreateNewEventElement new_blk_obj evt_elem_type new_evt_elem_obj
     lappend event::($event_obj,evt_elem_list) $new_evt_elem_obj
  } elseif { $spin_blk } \
  {
     foreach spin_blk_elem_obj $block::($spin_blk,active_blk_elem_list) \
     {
        set spin_elem_add $block_element::($spin_blk_elem_obj,elem_add_obj)
        set blk_exist_flag 0
        foreach tra_elem_obj $block::($trav_blk,active_blk_elem_list) \
        {
           set trav_elem_add $block_element::($tra_elem_obj,elem_add_obj)
           if {$trav_elem_add == $spin_elem_add} \
           {
              set blk_exist_flag 1
              break
           }
        }

        if { !$blk_exist_flag } \
        {
           lappend block::($trav_blk,active_blk_elem_list) $spin_blk_elem_obj
           set blk_exist_flag 0
        }
     }

     PB_int_RemoveBlkObjFrmList spin_blk
     set evt_elem_list [lreplace $evt_elem_list $spin_index $spin_index]
     set event::($event_obj,evt_elem_list) $evt_elem_list
  }

  foreach evt_elem_obj $event::($event_obj,evt_elem_list) \
  {
    set elem_blk_obj $event_element::($evt_elem_obj,block_obj)
    # Sorts the block elements of a Block template
      set active_blk_elem_list $block::($elem_blk_obj,active_blk_elem_list)
      UI_PB_com_SortBlockElements active_blk_elem_list
      set block::($elem_blk_obj,active_blk_elem_list) $active_blk_elem_list
      unset active_blk_elem_list

    # Gets the image ids of all the elements of a block
      UI_PB_blk_CreateBlockImages page_obj elem_blk_obj

    # sets the origin of the block
      set block::($elem_blk_obj,x_orig) $Page::($page_obj,x_orig)
      set block::($elem_blk_obj,y_orig) $Page::($page_obj,y_orig)
      UI_PB_tpth_CreateDividers page_obj elem_blk_obj

    # Creates the block elements
      set block_owner $block::($elem_blk_obj,blk_owner)
      set new_blk_elem_obj 0
      UI_PB_blk_CreateBlockCells page_obj elem_blk_obj new_blk_elem_obj \
                                 block_owner
      set Page::($page_obj,y_orig) [expr \
             $Page::($page_obj,y_orig) + $Page::($page_obj,blk_blkdist)]
  }
}

#===============================================================================
proc UI_PB_tpth_SetPageAttributes { PAGE_OBJ } {
#===============================================================================
  upvar $PAGE_OBJ page_obj

  set Page::($page_obj,h_cell) 30       ;# cell height
  set Page::($page_obj,w_cell) 62       ;# cell width
  set Page::($page_obj,w_divi) 4        ;# divider width
  set Page::($page_obj,x_orig) 80       ;# upper-left corner of 1st cell
  set Page::($page_obj,y_orig) 30
  set Page::($page_obj,rect_region) 15  ;# Block rectangle region
  set Page::($page_obj,add_blk) 0
  set Page::($page_obj,add_flag) 0
  set Page::($page_obj,icon_top) 0
  set Page::($page_obj,icon_bot) 0
  set Page::($page_obj,blk_blkdist) 60
  set Page::($page_obj,in_focus_elem) 0
  set Page::($page_obj,out_focus_elem) 0
  set Page::($page_obj,active_blk_elem) 0
  set Page::($page_obj,trash_flag) 0
  set Page::($page_obj,source_blk_elem_obj) 0
  set Page::($page_obj,source_evt_elem_obj) 0
}

#===============================================================================
proc UI_PB_tpth_CreateHorzPane { PAGE_OBJ } {
#===============================================================================
  upvar $PAGE_OBJ page_obj
  global paOption

  set page_id $Page::($page_obj,page_id)
  set pane [tixPanedWindow $page_id.pane -orient vertical]
  pack $pane -expand yes -fill both

  set f1 [$pane add p1 -expand 1.5]
  set f2 [$pane add p2 -expand 1]

  $f1 config -relief flat
  $f2 config -relief flat

  set p1s [$pane subwidget p1]
  set p1p [frame $p1s.pp] 
  pack $p1p -expand yes -fill both -pady 6

  tixScrolledWindow $p1p.scr
  [$p1p.scr subwidget hsb] config -troughcolor $paOption(trough_bg) \
                                  -width $paOption(trough_wd)
  [$p1p.scr subwidget vsb] config -troughcolor $paOption(trough_bg) \
                              -width $paOption(trough_wd)
  pack $p1p.scr -padx 5 -expand yes -fill both

  set p1t [$p1p.scr subwidget window]
  set top_frm [frame $p1t.f]
  pack $top_frm -expand yes -fill both
  set Page::($page_obj,canvas_frame) $top_frm

  set p2s [$pane subwidget p2]
  set p2p [frame $p2s.pp]
  set p3p [frame $p2p.bb]
  pack $p2p -expand yes -fill both
  pack $p3p -side bottom -expand yes -fill both

  tixScrolledWindow $p2p.scr
  [$p2p.scr subwidget hsb] config -troughcolor $paOption(trough_bg) \
                              -width       $paOption(trough_wd)
  [$p2p.scr subwidget vsb] config -troughcolor $paOption(trough_bg) \
                              -width       $paOption(trough_wd)
   pack $p2p.scr -padx 5 -pady 5 -expand yes -fill both

   set p2t [$p2p.scr subwidget window]
   set sec_frm [frame $p2t.f]
   pack $sec_frm -fill both -expand yes
   set Page::($page_obj,param_frame) $sec_frm

   set Page::($page_obj,box_frame) $p3p
}

#==============================================================================
proc UI_PB_tpth_ItemDrag1 {page_obj event_obj x y} {
#==============================================================================
  set bot_canvas $Page::($page_obj,bot_canvas)
  set top_canvas $Page::($page_obj,top_canvas)
  set panel_hi $Page::($page_obj,panel_hi)

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

    set sel_addr $Page::($page_obj,sel_base_addr)
    UI_PB_tpth_HighlightSeperators $page_obj $event_obj \
                        $sel_addr $xx $yy
}

#===============================================================================
proc UI_PB_tpth_UnHighLightSep { PAGE_OBJ } {
#===============================================================================
   upvar $PAGE_OBJ page_obj
   global paOption

   set main_cell_color $paOption(can_bg)
   set divi_color turquoise
   set bot_canvas $Page::($page_obj,bot_canvas)

   switch $Page::($page_obj,add_flag) \
   {

     1 {
         $bot_canvas itemconfigure [lindex $Page::($page_obj,focus_rect) 0] \
                -outline $main_cell_color -fill $main_cell_color
         $bot_canvas itemconfigure [lindex $Page::($page_obj,focus_rect) 1] \
                -outline $main_cell_color -fill $main_cell_color
         $bot_canvas itemconfigure [lindex $Page::($page_obj,focus_rect) 2] \
                -outline $main_cell_color -fill $main_cell_color
         unset Page::($page_obj,focus_rect)
       }
     2 {
         set act_blk_elem $Page::($page_obj,insert_elem)
         $bot_canvas itemconfigure $block_element::($act_blk_elem,div_id) \
                     -outline $divi_color -fill $divi_color
       }
     3 {
         set active_evt_elem $Page::($page_obj,active_evt_elem_obj)
         set act_blk_obj $event_element::($active_evt_elem,block_obj)
         $bot_canvas itemconfigure $block::($act_blk_obj,div_id) \
                     -outline $divi_color -fill $divi_color
       }
   }

   if {[info exists Page::($page_obj,focus_sep)]} \
   {
       $bot_canvas itemconfigure $Page::($page_obj,focus_sep) \
              -outline $main_cell_color -fill $main_cell_color
       unset Page::($page_obj,focus_sep)
   }
}

#===============================================================================
proc UI_PB_tpth_AddTextElemeToBlk { PAGE_OBJ EVENT_OBJ ADD_TO_EVT_ELEM_OBJ \
                                    NEW_ELEM_OBJ text_label } {
#===============================================================================
  upvar $PAGE_OBJ page_obj
  upvar $EVENT_OBJ event_obj
  upvar $ADD_TO_EVT_ELEM_OBJ add_to_evt_elem_obj
  upvar $NEW_ELEM_OBJ new_elem_obj

  set bot_canvas $Page::($page_obj,bot_canvas)
  set sel_base_addr $Page::($page_obj,sel_base_addr)

  # popup text window, if text element is added
    UI_PB_com_CreateTextEntry page_obj new_elem_obj $text_label
    tkwait window $bot_canvas.txtent

    if {[string compare $block_element::($new_elem_obj,elem_mom_variable) \
                 "000"] != 0} \
    {
       UI_PB_blk_ReplaceIcon page_obj $sel_base_addr $new_elem_obj
    } else \
    {
       set evt_elem_obj_list $event::($event_obj,evt_elem_list)
       switch $Page::($page_obj,add_blk) \
       {
           "row"    {
                        set evt_elem_obj $add_to_evt_elem_obj
                    }

           "top"    {
                       set elem_index [lsearch $evt_elem_obj_list \
                                                    $add_to_evt_elem_obj]
                       set evt_elem_obj [lindex $evt_elem_obj_list \
                                                  [expr $elem_index - 1]]
                    }
            
           "bottom" {
                       set elem_index [lsearch $evt_elem_obj_list \
                                                    $add_to_evt_elem_obj]
                       set evt_elem_obj [lindex $evt_elem_obj_list \
                                                  [expr $elem_index + 1]]
                    }
        }

        set block_obj $event_element::($evt_elem_obj,block_obj)
        set no_blk_elems [llength $block::($block_obj,active_blk_elem_list)]
        set source_cell_num [lsearch $block::($block_obj,active_blk_elem_list) \
                                      $new_elem_obj]
        
        set no_event_elems [llength $event::($event_obj,evt_elem_list)]
        set elem_index [lsearch $event::($event_obj,evt_elem_list) evt_elem_obj] 

        if { $no_blk_elems > 1 || $elem_index == [expr $no_event_elems - 1]} \
        {
           UI_PB_tpth_DeleteElemOfRow page_obj event_obj evt_elem_obj \
                                      source_cell_num
      
        } elseif  { $no_blk_elems == 1} \
        {
            UI_PB_tpth_DeleteARow page_obj event_obj evt_elem_obj
        }
    }
}

#===============================================================================
proc UI_PB_tpth_ItemEndDrag1 {page_obj event_obj x y } {
#===============================================================================
   set top_canvas $Page::($page_obj,top_canvas)
   set bot_canvas $Page::($page_obj,bot_canvas)

   UI_PB_tpth_UnHighLightSep page_obj

  if {$Page::($page_obj,icon_top)} \
  {
      $top_canvas delete $Page::($page_obj,icon_top)
      set Page::($page_obj,icon_top) 0
  }

  if {$Page::($page_obj,icon_bot)} \
  {
      $bot_canvas delete $Page::($page_obj,icon_bot)
      set Page::($page_obj,icon_bot) 0
  }

  $Page::($page_obj,add) configure -relief raised \
                        -background #c0c0ff

  if { $Page::($page_obj,add_blk) != 0} \
  {
     set add_to_evt_elem_obj $Page::($page_obj,active_evt_elem_obj)
     set new_elem_mom_var $Page::($page_obj,new_elem_mom_var)
     set sel_base_addr $Page::($page_obj,sel_base_addr)

     # Creates new address
       if { [string compare $sel_base_addr "New_Address"] == 0 } \
       {
           set sel_base_addr "user_add"
           set fmt_name "String"
           PB_int_CreateNewAddress sel_base_addr fmt_name new_add_obj
       }

    # Database call for creating a new block element
      set add_to_blk_obj $event_element::($add_to_evt_elem_obj,block_obj)
      PB_int_AddNewBlockElemObj sel_base_addr new_elem_mom_var \
                                add_to_blk_obj new_elem_obj
      set block_element::($new_elem_obj,owner) $event::($event_obj,event_name)

     switch $Page::($page_obj,add_blk) \
     {
        "row" \
         {
              UI_PB_tpth_AddBlkElemRow page_obj add_to_evt_elem_obj new_elem_obj
         }
        "top" \
         {
              UI_PB_tpth_AddBlkElemTopOrBottom page_obj event_obj \
                                      add_to_evt_elem_obj new_elem_obj
         }
        "bottom" \
         {
              UI_PB_tpth_AddBlkElemTopOrBottom page_obj event_obj \
                                      add_to_evt_elem_obj new_elem_obj
         }
     }
    
     # It is executed for text element only
       if { [string compare $Page::($page_obj,sel_base_addr) "Text"] == 0} \
       {
           UI_PB_tpth_AddTextElemeToBlk page_obj event_obj add_to_evt_elem_obj \
                                        new_elem_obj Text
       } elseif { [string compare $Page::($page_obj,sel_base_addr) \
                             "New_Address"] == 0} \
       {
           UI_PB_blk_NewAddress page_obj event_obj add_to_evt_elem_obj \
                                new_elem_obj event
       } elseif { [string match "*User Defined*" \
                         $block_element::($new_elem_obj,elem_desc)] } \
       {
           UI_PB_tpth_AddTextElemeToBlk page_obj event_obj add_to_evt_elem_obj \
                                        new_elem_obj Expression
       }
  }
  set Page::($page_obj,add_blk) 0
  set Page::($page_obj,add_flag) 0

   # Restore cursor and focus
     $top_canvas config -cursor ""
     UI_PB_blk_ItemFocusOn1 $page_obj $x $y
}

#===============================================================================
proc UI_PB_tpth_AddBlkElemRow {PAGE_OBJ ADD_TO_EVT_ELEM_OBJ NEW_BLK_ELEM_OBJ} {
#===============================================================================
  upvar $PAGE_OBJ page_obj
  upvar $ADD_TO_EVT_ELEM_OBJ add_to_evt_elem_obj
  upvar $NEW_BLK_ELEM_OBJ new_blk_elem_obj

  set bot_canvas $Page::($page_obj,bot_canvas)
  if {$Page::($page_obj,active_blk_elem)} \
  {
      set act_blk_elem_obj $Page::($page_obj,active_blk_elem)
      set icon_id $block_element::($act_blk_elem_obj,icon_id)
      set im [$bot_canvas itemconfigure $icon_id -image]
      [lindex $im end] configure -relief raised \
                                 -background #c0c0ff
  }

  # Checks the existance of the block element in the block template
  # if the block element exists it gives out a error message and returns
   set add_to_blk_obj $event_element::($add_to_evt_elem_obj,block_obj)
   set new_blk_elem_add_obj $block_element::($new_blk_elem_obj,elem_add_obj)
   set new_blk_elem_add_name $address::($new_blk_elem_add_obj,add_name)
   set blk_elem_flag [UI_PB_com_CheckElemBlkTemplate add_to_blk_obj \
                                     new_blk_elem_add_name]
   if {$blk_elem_flag} \
   {
     UI_PB_com_DisplyErrorMssg new_blk_elem_add_name
     return
   }

   # Deletes all the existing cells and icons of a block
     UI_PB_blk_DeleteCellsIcons page_obj add_to_blk_obj

   if { $Page::($page_obj,add_flag) == 1 || \
        $Page::($page_obj,add_flag) == 3 } \
   {
      lappend block::($add_to_blk_obj,active_blk_elem_list) $new_blk_elem_obj
   } else \
   {
     set active_blk_elem_list $block::($add_to_blk_obj,active_blk_elem_list)
     set insert_elem $Page::($page_obj,insert_elem)
     set insert_indx [lsearch $active_blk_elem_list $insert_elem]
     set active_blk_elem_list [linsert $active_blk_elem_list $insert_indx \
                                     $new_blk_elem_obj]
     set block::($add_to_blk_obj,active_blk_elem_list) $active_blk_elem_list
     unset active_blk_elem_list
   }

   # Sorts the block elements of a Block template
     set active_blk_elem_list $block::($add_to_blk_obj,active_blk_elem_list)
     UI_PB_com_SortBlockElements active_blk_elem_list
     set block::($add_to_blk_obj,active_blk_elem_list) $active_blk_elem_list
     unset active_blk_elem_list

   # Gets the image ids of all the elements of a block
     UI_PB_blk_CreateBlockImages page_obj add_to_blk_obj
     UI_PB_tpth_CreateDividers page_obj add_to_blk_obj

   # proc is called to create the block cells
    set Page::($page_obj,x_orig) $block::($add_to_blk_obj,x_orig)
    set Page::($page_obj,y_orig) $block::($add_to_blk_obj,y_orig)
    set block_owner $block::($add_to_blk_obj,blk_owner)
    UI_PB_blk_CreateBlockCells page_obj add_to_blk_obj new_blk_elem_obj \
                               block_owner
}

#===============================================================================
proc UI_PB_tpth_AddBlkElemTopOrBottom { PAGE_OBJ EVENT_OBJ ADD_TO_EVT_ELEM_OBJ \
                                        NEW_BLK_ELEM_OBJ} {
#===============================================================================
   upvar $PAGE_OBJ page_obj
   upvar $EVENT_OBJ event_obj
   upvar $ADD_TO_EVT_ELEM_OBJ add_to_evt_elem_obj
   upvar $NEW_BLK_ELEM_OBJ new_blk_elem_obj

   set bot_canvas $Page::($page_obj,bot_canvas)
   set event_name $event::($event_obj,event_name)

   set no_elems [llength $event::($event_obj,evt_elem_list)]
   set elem_index [lsearch $event::($event_obj,evt_elem_list) \
                                            $add_to_evt_elem_obj]

   if {$Page::($page_obj,active_blk_elem)} \
   {
      set act_blk_elem_obj $Page::($page_obj,active_blk_elem)
      set icon_id $block_element::($act_blk_elem_obj,icon_id)
      set im [$bot_canvas itemconfigure $icon_id -image]
      [lindex $im end] configure -relief raised \
                                 -background #c0c0ff
   }

   set elem_obj [lindex $event::($event_obj,evt_elem_list) $elem_index]
   set add_to_blk_obj $event_element::($elem_obj,block_obj)

   if {![string compare $Page::($page_obj,add_blk) "bottom"]} \
   {
      incr elem_index
   } 

   for {set count $elem_index} {$count < $no_elems} {incr count} \
   {
      set del_elem [lindex $event::($event_obj,evt_elem_list) $count]
      set del_blk $event_element::($del_elem,block_obj)

      # Deletes all the existing cells and icons of a block
        UI_PB_blk_DeleteCellsIcons page_obj del_blk

      if {[info exists block::($del_blk,sep_id)]} \
      {
         set bot_canvas $Page::($page_obj,bot_canvas)
         $bot_canvas delete [lindex $block::($del_blk,sep_id) 0]
         $bot_canvas delete [lindex $block::($del_blk,sep_id) 1]
         unset block::($del_blk,sep_id)
      }
   }
   
   # Gets the unique block name
     UI_PB_com_ReturnBlockName event_obj new_block_name

   # Creates a new block
     PB_int_CreateNewBlock new_block_name new_blk_elem_obj \
                           event_name new_block_obj

   # Creates a new event element
     set evt_elem_type "normal"
     PB_int_CreateNewEventElement new_block_obj evt_elem_type new_evt_elem

   # Appends new block element to the new block
     lappend block::($new_block_obj,active_blk_elem_list) $new_blk_elem_obj

    set temp_evt_elem_list $event::($event_obj,evt_elem_list)
    unset event::($event_obj,evt_elem_list)

    for {set count 0} {$count < $elem_index} {incr count} \
    {
       lappend event::($event_obj,evt_elem_list) \
                   [lindex $temp_evt_elem_list $count]
    }

    lappend event::($event_obj,evt_elem_list) $new_evt_elem
    
    for {set count $elem_index} {$count < $no_elems} \
                  {incr count} \
    {
       lappend event::($event_obj,evt_elem_list) \
                            [lindex $temp_evt_elem_list $count]
    }

    if {$elem_index >= $no_elems} \
    {
       set elem_obj [lindex $event::($event_obj,evt_elem_list) \
                         [expr $elem_index - 1]]
       set block_obj $event_element::($elem_obj,block_obj)
       set Page::($page_obj,x_orig) $block::($block_obj,x_orig)
       set Page::($page_obj,y_orig) [expr $block::($block_obj,y_orig) \
                       + $Page::($page_obj,blk_blkdist)]

    } else \
    {
       set elem_obj [lindex $event::($event_obj,evt_elem_list) \
                                   [expr $elem_index + 1]]
       set block_obj $event_element::($elem_obj,block_obj)
       set Page::($page_obj,x_orig) $block::($block_obj,x_orig)
       set Page::($page_obj,y_orig) $block::($block_obj,y_orig)
    }
    incr no_elems

    for {set count $elem_index} {$count < $no_elems} \
                   {incr count} \
    {
      set elem_obj [lindex $event::($event_obj,evt_elem_list) $count]
      set block_obj $event_element::($elem_obj,block_obj)

      # Gets the image ids of all the elements of a block
        UI_PB_blk_CreateBlockImages page_obj block_obj

      # proc is called to create the block cells
        set block::($block_obj,x_orig) $Page::($page_obj,x_orig)
       set block::($block_obj,y_orig) $Page::($page_obj,y_orig)
       UI_PB_tpth_CreateDividers page_obj block_obj

       if {$count == $elem_index} \
       {
          set active_blk_elem $new_blk_elem_obj
       } else \
       {
         set active_blk_elem 0
       }
      
       UI_PB_blk_CreateBlockCells page_obj block_obj active_blk_elem \
                                  event_name
       set Page::($page_obj,y_orig) \
           [expr $Page::($page_obj,y_orig) + $Page::($page_obj,blk_blkdist)]
    }
    set Page::($page_obj,active_blk_obj) $new_block_obj
    set add_to_evt_elem_obj $new_evt_elem
}

#===============================================================================
proc UI_PB_tpth_HighLightTopSeperator { PAGE_OBJ EVT_ELEM_OBJ } {
#===============================================================================
  upvar $PAGE_OBJ page_obj
  upvar $EVT_ELEM_OBJ evt_elem_obj
  global paOption

  set block_obj $event_element::($evt_elem_obj,block_obj)
  set bot_canvas $Page::($page_obj,bot_canvas)
  set high_color $paOption(focus)
  set sep_id [lindex $block::($block_obj,sep_id) 0]
  $bot_canvas itemconfigure $sep_id \
           -outline $high_color -fill $high_color
  set Page::($page_obj,focus_sep) $sep_id
  set Page::($page_obj,active_evt_elem_obj) $evt_elem_obj
  set Page::($page_obj,add_blk) "top"
}

#===============================================================================
proc UI_PB_tpth_HighLightCellDividers { PAGE_OBJ EVT_ELEM_OBJ xx yy} {
#===============================================================================
  upvar $PAGE_OBJ page_obj
  upvar $EVT_ELEM_OBJ evt_elem_obj
  global paOption

  set high_color $paOption(focus)
  set bot_canvas $Page::($page_obj,bot_canvas)
  set block_obj $event_element::($evt_elem_obj,block_obj)
  set rect_region $Page::($page_obj,rect_region)

  foreach blk_elem_obj $block::($block_obj,active_blk_elem_list) \
  {
     if { $yy > [expr $block_element::($blk_elem_obj,div_corn_y0) - \
                         $rect_region] && \
          $yy < [expr $block_element::($blk_elem_obj,div_corn_y1) + \
                         $rect_region] && \
          $xx > [expr $block_element::($blk_elem_obj,div_corn_x0) - 10] && \
          $xx < [expr $block_element::($blk_elem_obj,div_corn_x1) + 10]} \
     {
         $bot_canvas itemconfigure $block_element::($blk_elem_obj,div_id) \
                -fill $high_color -outline $high_color
         set Page::($page_obj,active_evt_elem_obj) $evt_elem_obj
         set Page::($page_obj,insert_elem) $blk_elem_obj
         set Page::($page_obj,add_blk) row
         set Page::($page_obj,add_flag) 2
         break
     } else \
     {
         set Page::($page_obj,add_blk) 0
         set Page::($page_obj,add_flag) 0
     }
  }

  if {$Page::($page_obj,add_blk) == 0} \
  {
     if { $yy > [expr $block::($block_obj,div_corn_y0) - \
                         $rect_region] && \
          $yy < [expr $block::($block_obj,div_corn_y1) + \
                         $rect_region] && \
          $xx > [expr $block::($block_obj,div_corn_x0) - 10] && \
          $xx < [expr $block::($block_obj,div_corn_x1) + 10]} \
     {
         $bot_canvas itemconfigure $block::($block_obj,div_id) \
                        -fill $high_color -outline $high_color
         set Page::($page_obj,active_evt_elem_obj) $evt_elem_obj
         set Page::($page_obj,add_blk) row
         set Page::($page_obj,add_flag) 3
     } else \
     {
         set Page::($page_obj,add_blk) 0
         set Page::($page_obj,add_flag) 0
     }
  }
}

#===============================================================================
proc UI_PB_tpth_HighLightRow { PAGE_OBJ EVT_ELEM_OBJ} {
#===============================================================================
  upvar $PAGE_OBJ page_obj
  upvar $EVT_ELEM_OBJ evt_elem_obj
  global paOption

  set block_obj $event_element::($evt_elem_obj,block_obj)
  set bot_canvas $Page::($page_obj,bot_canvas)
  set high_color $paOption(focus)
  set sep_id1 [lindex $block::($block_obj,sep_id) 0]
  $bot_canvas itemconfigure $sep_id1 \
            -outline $high_color -fill $high_color

  set sep_id2 [lindex $block::($block_obj,sep_id) 1]
  $bot_canvas itemconfigure $sep_id2 \
           -outline $high_color -fill $high_color

  $bot_canvas itemconfigure $block::($block_obj,rect) \
           -outline $high_color -fill $high_color

  lappend Page::($page_obj,focus_rect) $block::($block_obj,rect) \
                $sep_id1 $sep_id2
  set Page::($page_obj,active_evt_elem_obj) $evt_elem_obj
  set Page::($page_obj,add_blk) "row"
  set Page::($page_obj,add_flag) 1
}

#===============================================================================
proc UI_PB_tpth_HighLightBottomSeperator { PAGE_OBJ EVT_ELEM_OBJ} {
#===============================================================================
  upvar $PAGE_OBJ page_obj
  upvar $EVT_ELEM_OBJ evt_elem_obj
  global paOption

  set block_obj $event_element::($evt_elem_obj,block_obj)
  set bot_canvas $Page::($page_obj,bot_canvas)
  set high_color $paOption(focus)
  set sep_id [lindex $block::($block_obj,sep_id) 1]
  $bot_canvas itemconfigure $sep_id \
           -outline $high_color -fill $high_color
  set Page::($page_obj,focus_sep) $sep_id
  set Page::($page_obj,active_evt_elem_obj) $evt_elem_obj
  set Page::($page_obj,add_blk) "bottom"
}

#===============================================================================
proc UI_PB_tpth_HighlightSeperators {page_obj event_obj sel_addr x y } {
#===============================================================================
   global paOption
   set h_cell $Page::($page_obj,h_cell)
   set w_divi $Page::($page_obj,w_divi)
   set rect_region $Page::($page_obj,rect_region)
   set high_color $paOption(focus)
   set main_cell_color $paOption(can_bg)
   set bot_canvas $Page::($page_obj,bot_canvas)

   set event_elem_list $event::($event_obj,evt_elem_list)
   set event_name $event::($event_obj,event_name)

   UI_PB_tpth_UnHighLightSep page_obj

   set Page::($page_obj,add_flag) 0
   set Page::($page_obj,add_blk) 0

   foreach elem_obj $event_elem_list \
   {
      set block_obj $event_element::($elem_obj,block_obj)
      set blk_x0 $block::($block_obj,x_orig)
      set blk_y0 $block::($block_obj,y_orig)
      set blk_height $block::($block_obj,blk_h)
      set blk_width $block::($block_obj,blk_w)

     # Avoids highlighting the block seperatores of the blocks, which
     # are not owned by the event 
       if {[string compare $event_name $block::($block_obj,blk_owner)] != 0} \
       {
          set Page::($page_obj,add_blk) 0
          continue
       }

     # It avoids highlighting the row and the two seperators, if there is
     # is only one element in the block, and that itself is dragged.
      if {$Page::($page_obj,source_evt_elem_obj) != 0} \
      {
         set source_evt_elem_obj $Page::($page_obj,source_evt_elem_obj)
         set source_blk_obj $event_element::($source_evt_elem_obj,block_obj)
         if {[llength $block::($source_blk_obj,active_blk_elem_list)] \
                    == 1 && $elem_obj == $source_evt_elem_obj} \
         {
             set Page::($page_obj,add_blk) 0
             continue
         }
      }

     # This part of the code is for highlighting the top seperator of a block
      if {$y > [expr $blk_y0 - $rect_region] && $y < $blk_y0 && \
          $x > [expr $blk_x0 - [expr 6 * $rect_region]] && \
          $x < [expr $blk_width + [expr 6 * $rect_region]]} \
      {
         # To avoid highlighting the seperators, if there are no block elements
         # in the page
          if {$block::($block_obj,active_blk_elem_list) == ""} \
          {
             set Page::($page_obj,add_blk) 0
             continue
          }
          UI_PB_tpth_HighLightTopSeperator page_obj elem_obj
         break
     # This part of the code is for highlighting the, row of a block
      } elseif { $y >= $blk_y0 && $y <= $blk_height && \
          $x > [expr $blk_x0 - [expr 6 * $rect_region]] && \
          $x < [expr $blk_width + [expr 6 * $rect_region]]} \
      {
        
        # It does not hightlight the row of a block, when one of the
        # block element is dragged.
         if {$Page::($page_obj,source_evt_elem_obj) != 0 && \
             [string compare $sel_addr "Text"] != 0 } \
         {
            set source_evt_elem_obj $Page::($page_obj,source_evt_elem_obj)
            set source_blk_obj $event_element::($source_evt_elem_obj,block_obj)
            if {$block_obj == $source_blk_obj} \
            {
                set Page::($page_obj,add_blk) 0
                continue
            }
         }
         if { [string compare $sel_addr "Text"] != 0} \
         {         
            UI_PB_tpth_HighLightRow page_obj elem_obj
         } else \
         {
            UI_PB_tpth_HighLightCellDividers page_obj elem_obj $x $y
         }
         break
     # This part of the code is for highlighting the bottom seperator of a block
      } elseif { $y > $blk_height && $y < [expr $blk_height + $rect_region] && \
                 $x > [expr $blk_x0 - [expr 6 * $rect_region]] && \
                 $x < [expr $blk_width + [expr 6 * $rect_region]]} \
      {
         # To avoid highlighting the seperators, if there are no block elements
         # in the page
          if {$block::($block_obj,active_blk_elem_list) == ""} \
          {
             set Page::($page_obj,add_blk) 0
             continue
          }
          UI_PB_tpth_HighLightBottomSeperator page_obj elem_obj
         break
      } else \
      {
         set Page::($page_obj,add_blk) 0
         set Page::($page_obj,add_flag) 0
      }
   }
}

#=======================================================================
proc UI_PB_tpth_AddApplyDef {PAGE_OBJ SEQ_PAGE_OBJ SEQ_OBJ EVENT_OBJ } {
#=======================================================================
  upvar $PAGE_OBJ page_obj
  upvar $SEQ_PAGE_OBJ seq_page_obj
  upvar $EVENT_OBJ event_obj
  upvar $SEQ_OBJ seq_obj
  global paOption
  
  pack forget $Page::($page_obj,box)

 # Template Button
  set frame [frame $Page::($page_obj,box_frame).frm1]
  pack $frame -side bottom -fill x -pady 5 -padx 3

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
              -command "UI_PB_tpth_DefaultCallBack $page_obj $event_obj"
  $box1 add und -text Restore -width 10 \
              -bg $paOption(app_butt_bg) \
              -command "UI_PB_tpth_RestoreCallBack $page_obj $event_obj"
  $box1 add app -text Apply -width 10 \
                         -bg $paOption(app_butt_bg) \
              -command "UI_PB_tpth_ApplyCallBack $page_obj $seq_page_obj \
                                                 $seq_obj $event_obj"

 # Box2 attributes
  $box2 add canc -text Cancel -width 10 \
              -bg $paOption(app_butt_bg) \
              -command "UI_PB_tpth_CancelCallBack $seq_page_obj $page_obj $event_obj"
  $box2 add ok -text OK -width 10 \
              -bg $paOption(app_butt_bg) \
              -command "UI_PB_tpth_OkCallBack $page_obj $seq_page_obj \
                                              $seq_obj $event_obj"
}

#============================================================================
proc UI_PB_tpth_DeleteDummyBlock { PAGE_OBJ EVENT_OBJ } {
#============================================================================
  upvar $PAGE_OBJ page_obj
  upvar $EVENT_OBJ event_obj

  if {$Page::($page_obj,dummy_blk)} \
  {
    if {[llength $event::($event_obj,evt_elem_list)] == 1} \
    {
      set evt_elem_obj [lindex $event::($event_obj,evt_elem_list) 0]
      set block_obj $event_element::($evt_elem_obj,block_obj)
      if {$block::($block_obj,active_blk_elem_list) == ""} \
      {
         PB_int_RemoveBlkObjFrmList block_obj
         set event::($event_obj,evt_elem_list) [lreplace \
                       $event::($event_obj,evt_elem_list) 0 0]
      }
    }
  }
}

#============================================================================
proc UI_PB_tpth_DeleteTpthBlock { SEQ_PAGE_OBJ EVENT_OBJ } {
#============================================================================
  upvar $SEQ_PAGE_OBJ seq_page_obj
  upvar $EVENT_OBJ event_obj

  set bot_canvas $Page::($seq_page_obj,bot_canvas)

  if {[info exists event::($event_obj,blk_text)]} \
  {
      $bot_canvas delete $event::($event_obj,blk_text)
  }

  if {[info exists event::($event_obj,blk_rect)]} \
  {
      $bot_canvas delete $event::($event_obj,blk_rect)
  }
  
  # Deletes the line, that connect the event and block
   if {[info exists event::($event_obj,extra_lines)]} \
   {
      $bot_canvas delete $event::($event_obj,extra_lines)
   }
}

#============================================================================
proc UI_PB_tpth_UnsetTpthEvtBlkAttr { EVENT_OBJ } {
#============================================================================
  upvar $EVENT_OBJ event_obj

 if {[info exists event::($event_obj,evt_elem_list)]} \
 {
     foreach elem_obj $event::($event_obj,evt_elem_list) \
     {
        set block_obj $event_element::($elem_obj,block_obj)
        if {[info exists block::($block_obj,sep_id)]} \
        {
            unset block::($block_obj,sep_id)
        }
     }
  }
}

#============================================================================
proc UI_PB_UpdateSequenceEvent { SEQ_PAGE_OBJ SEQ_OBJ EVENT_OBJ} {
#============================================================================
  upvar $SEQ_PAGE_OBJ seq_page_obj
  upvar $SEQ_OBJ seq_obj
  upvar $EVENT_OBJ event_obj

  if {[string compare $event::($event_obj,evt_elem_list) ""] != 0} \
  {
     set updat_no_elems [llength $event::($event_obj,evt_elem_list)]
     array set rest_evt_obj_attr $event::($event_obj,rest_value)
     set act_no_elems [llength $rest_evt_obj_attr(2)]
     unset rest_evt_obj_attr

     UI_PB_evt_CreateElemOfTpthEvent seq_page_obj seq_obj event_obj

     set current_evt_name $event::($event_obj,event_name)
     PB_int_RetCycleComAndSharedEvts cycle_com_evt cycle_shared_evts
     if {$act_no_elems != $updat_no_elems || \
         [string compare $current_evt_name $cycle_com_evt] == 0} \
     {
       set active_evt_index [lsearch $sequence::($seq_obj,evt_obj_list) \
                              $event_obj]
       UI_PB_evt_TransformEvtElem seq_page_obj seq_obj active_evt_index
     }
  }
}

#============================================================================
proc UI_PB_tpth_OkCallBack { page_obj seq_page_obj seq_obj event_obj } {
#============================================================================
  global mom_sys_arr
  global paOption

  UI_PB_tpth_DeleteDummyBlock page_obj event_obj

  if {$Page::($seq_page_obj,active_seq) == $seq_obj} \
  {
      UI_PB_tpth_DeleteTpthBlock seq_page_obj event_obj
  }

   if {[string compare $event::($event_obj,evt_elem_list) ""] != 0} \
   {
     array set event_rest_data $event::($event_obj,rest_value)
     foreach elem_obj $event::($event_obj,evt_elem_list)\
     {
        set blk_obj $event_element::($elem_obj,block_obj)
        if {[info exists block::($blk_obj,active_blk_elem_list)]} \
        {
           set block::($blk_obj,elem_addr_list) \
                       $block::($blk_obj,active_blk_elem_list)
           unset block::($blk_obj,active_blk_elem_list)
           set evt_elem_index [lsearch $event_rest_data(2) $elem_obj]
           if { $evt_elem_index == -1 } \
           {
              block::readvalue $blk_obj blk_obj_attr
              block::DefaultValue $blk_obj blk_obj_attr
              unset blk_obj_attr
           }
        } else \
        {
           set block::($blk_obj,elem_addr_list) ""
        }
     }
   }

   PB_int_UpdateMOMVar mom_sys_arr
   if {[string compare $event::($event_obj,event_name) "Cycle Set"] == 0} \
   {
       # Deletes the post blocks and post elements
         UI_PB_tpth_DeletePostBlocks event_obj

       # Adds post blocks 
         PB_int_CreateCyclePostBlks event_obj
   }
  destroy $Page::($page_obj,win)
  set bot_canvas $Page::($seq_page_obj,bot_canvas)
  set evt_img_id $event::($event_obj,icon_id)
  set img [lindex [$bot_canvas itemconfigure $evt_img_id -image] end]
  if { $img != "" } \
  {
     $img config -relief raised -bg $paOption(event)
  }

  UI_PB_tpth_UpdateCycleEvent event_obj seq_obj
  if {$Page::($seq_page_obj,active_seq) == $seq_obj} \
  {
      UI_PB_UpdateSequenceEvent seq_page_obj seq_obj event_obj
  }
      UI_PB_tpth_UnsetTpthEvtBlkAttr event_obj
      set event::($event_obj,event_open) 0
      UI_PB_tpth_ReleaseSeqPageGrab $seq_page_obj $page_obj
}

#============================================================================
proc UI_PB_tpth_CancelCallBack { seq_page_obj page_obj event_obj } {
#============================================================================
  global mom_sys_arr
  global paOption

  # Replaces the event run time data with restore data
    array set rest_evt_obj_attr $event::($event_obj,rest_value)
    event::setvalue $event_obj rest_evt_obj_attr

  # Replaces the element run time data with restore data
    if {[string compare $event::($event_obj,evt_elem_list) ""] != 0} \
    {
      foreach elem_obj $event::($event_obj,evt_elem_list)\
      {
         set blk_obj $event_element::($elem_obj,block_obj)
         if {[info exists block::($blk_obj,active_blk_elem_list)]} \
         {
            unset block::($blk_obj,active_blk_elem_list)
         }
        # Event element data
          array set rest_elem_obj_attr $event_element::($elem_obj,rest_value)
          event_element::setvalue $elem_obj rest_elem_obj_attr

        # Block data
          array set rest_blk_obj_attr $block::($blk_obj,rest_value)
          block::setvalue $blk_obj rest_blk_obj_attr

        # Block Element data
          foreach blk_elem_obj $block::($blk_obj,elem_addr_list) \
          {
             array set blk_elem_attr $block_element::($blk_elem_obj,rest_value)
             block_element::setvalue $blk_elem_obj blk_elem_attr
             unset blk_elem_attr
          }
      }
    }

   if {[info exist Page::($page_obj,rest_evt_mom_var)]} \
   {
     array set rest_evt_mom_var $Page::($page_obj,rest_evt_mom_var)
     array set evt_mom_var $Page::($page_obj,evt_mom_var_list)
     set no_vars [array size evt_mom_var]
     for {set count 0} {$count < $no_vars} {incr count} \
     {
        set mom_var $evt_mom_var($count)
        set mom_sys_arr($mom_var) $rest_evt_mom_var($mom_var)
     }
   }

   # Destroy the Event window
     destroy $Page::($page_obj,win)

  set bot_canvas $Page::($seq_page_obj,bot_canvas)
  set evt_img_id $event::($event_obj,icon_id)
  set img [lindex [$bot_canvas itemconfigure $evt_img_id -image] end]
  if { $img != "" } \
  {
     $img config -relief raised -bg $paOption(event)
  }

  # Release the Sequence page grab when necessary.
    UI_PB_tpth_ReleaseSeqPageGrab $seq_page_obj $page_obj
    set event::($event_obj,event_open) 0
}

#============================================================================
proc UI_PB_tpth_ReleaseSeqPageGrab { seq_page_obj page_obj } {
#============================================================================
  # Find the index of the Event name in the list
   set event_name $Page::($page_obj,event_name)
   set idx [lsearch $Page::($seq_page_obj,event_list) $event_name]

  # Delete this Event from the list
   if {$idx >= 0} \
   {
     set Page::($seq_page_obj,event_list) \
         [lreplace $Page::($seq_page_obj,event_list) $idx $idx]
   }

  # Release the grabbing on the Sequence page when no Event window is open.
   if {![llength $Page::($seq_page_obj,event_list)]} \
   {
#<gsl>      UI_PB_tpth_UnLockBookPages
   }
}

#===============================================================================
proc UI_PB_tpth_UnLockBookPages { } {
#===============================================================================
  global gPB

  set pb_book_id $Book::($gPB(book),book_id)

  $pb_book_id pageconfig mac -state normal
  $pb_book_id pageconfig pro -state normal
  $pb_book_id pageconfig def -state normal
  $pb_book_id pageconfig lis -state normal
  $pb_book_id pageconfig pre -state normal
  $pb_book_id pageconfig adv -state normal

  set pb_book_page_list $Book::($gPB(book),page_obj_list)
  set prg_tpth_page [lindex $pb_book_page_list 1]
  set prg_tpth_book $Page::($prg_tpth_page,book_obj)
  set prg_tpth_book_id $Book::($prg_tpth_book,book_id)

  $prg_tpth_book_id pageconfig prog -state normal
  $prg_tpth_book_id pageconfig gcod -state normal
  $prg_tpth_book_id pageconfig mcod -state normal
  $prg_tpth_book_id pageconfig asum -state normal
  $prg_tpth_book_id pageconfig wseq -state normal
}

#============================================================================
proc UI_PB_tpth_DeleteTpthEventBlkAttr { PAGE_OBJ EVENT_OBJ } {
#============================================================================
  upvar $PAGE_OBJ page_obj
  upvar $EVENT_OBJ event_obj

  set bot_canvas $Page::($page_obj,bot_canvas)
  if {[string compare $event::($event_obj,evt_elem_list) ""] != 0} \
  {
     foreach evt_elem_obj $event::($event_obj,evt_elem_list) \
     {
        # Deletes the existing blk elements
          set block_obj $event_element::($evt_elem_obj,block_obj)
          UI_PB_blk_DeleteCellsIcons page_obj block_obj
          if {[info exists block::($block_obj,sep_id)]} \
          {
             $bot_canvas delete [lindex $block::($block_obj,sep_id) 0]
             $bot_canvas delete [lindex $block::($block_obj,sep_id) 1]
             unset block::($block_obj,sep_id)
          }
     }
  }
}

#============================================================================
proc UI_PB_tpth_DefaultCallBack { page_obj event_obj } {
#============================================================================
  global mom_sys_arr

  # Deletes the block attributes of a tool path event
    UI_PB_tpth_DeleteTpthEventBlkAttr page_obj event_obj

  array set evt_obj_attr $event::($event_obj,def_value)
  event::setvalue $event_obj evt_obj_attr

  if {[string compare $event::($event_obj,evt_elem_list) ""] != 0} \
  {
      foreach elem_obj $event::($event_obj,evt_elem_list) \
      {
         array set evt_elem_obj_attr $event_element::($elem_obj,def_value)
         event_element::setvalue $elem_obj evt_elem_obj_attr
         unset evt_elem_obj_attr

         set block_obj $event_element::($elem_obj,block_obj)
         array set blk_obj_attr $block::($block_obj,def_value)
         block::setvalue $block_obj blk_obj_attr
         unset blk_obj_attr
         foreach blk_elem_obj $block::($block_obj,elem_addr_list) \
         {
            array set blk_elem_attr $block_element::($blk_elem_obj,def_value)
            block_element::setvalue $blk_elem_obj blk_elem_attr
            unset blk_elem_attr
         }
      }
  }

  set Page::($page_obj,dummy_blk) 0
  UI_PB_tpth_CreateElemObjects page_obj event_obj

  # Recreates the event block elements
    UI_PB_tpth_CreateEventBlockTemplates page_obj event_obj

  # Sets the default values to the global variable
    array set evt_mom_var $Page::($page_obj,evt_mom_var_list)
    PB_int_RetDefMOMVarValues evt_mom_var def_val_mom_var
    set no_vars [array size evt_mom_var]
    for {set count 0} {$count < $no_vars} {incr count} \
    {
       set mom_var $evt_mom_var($count)
       if {[string match \$mom* $mom_var]} \
       {
          set data_type [UI_PB_com_RetSysVarDataType mom_var]
          set mom_sys_arr($mom_var) [UI_PB_com_RetValByDataType \
                             $def_val_mom_var($mom_var) $data_type]
       }
    }
}

#============================================================================
proc UI_PB_tpth_RestoreCallBack { page_obj event_obj } {
#============================================================================
  global mom_sys_arr

  # Deletes the block attributes of a tool path event
    UI_PB_tpth_DeleteTpthEventBlkAttr page_obj event_obj

  array set evt_obj_attr $event::($event_obj,rest_value)
  event::setvalue $event_obj evt_obj_attr

  if {[string compare $event::($event_obj,evt_elem_list) ""] != 0} \
  {
      foreach elem_obj $event::($event_obj,evt_elem_list) \
      {
         array set evt_elem_obj_attr $event_element::($elem_obj,rest_value)
         event_element::setvalue $elem_obj evt_elem_obj_attr
         unset evt_elem_obj_attr

         set block_obj $event_element::($elem_obj,block_obj)
         array set blk_obj_attr $block::($block_obj,rest_value)
         block::setvalue $block_obj blk_obj_attr
         unset blk_obj_attr

         foreach blk_elem_obj $block::($block_obj,elem_addr_list) \
         {
            array set blk_elem_attr $block_element::($blk_elem_obj,rest_value)
            block_element::setvalue $blk_elem_obj blk_elem_attr
            unset blk_elem_attr
         }
      }
  }

  if {[info exist Page::($page_obj,rest_evt_mom_var)]} \
  {
     array set rest_evt_mom_var $Page::($page_obj,rest_evt_mom_var)
     array set evt_mom_var $Page::($page_obj,evt_mom_var_list)
     set no_vars [array size evt_mom_var]
     for {set count 0} {$count < $no_vars} {incr count} \
     {
        set mom_var $evt_mom_var($count)
        if {[string match \$mom* $mom_var]} \
        {
           set data_type [UI_PB_com_RetSysVarDataType mom_var]
           set mom_sys_arr($mom_var) [UI_PB_com_RetValByDataType \
                          $rest_evt_mom_var($mom_var) $data_type]
        }
     }
  }

  # Recreates the event block elements
    UI_PB_tpth_CreateEventBlockTemplates page_obj event_obj
}

#============================================================================
proc UI_PB_tpth_ValidateEventUIData { EVENT_OBJ } {
#============================================================================
  upvar $EVENT_OBJ event_obj

  foreach item_obj $event::($event_obj,evt_itm_obj_list) \
  {
     foreach grp_obj $item::($item_obj,grp_obj_list) \
     {
        foreach mem_obj $item_group::($grp_obj,mem_obj_list) \
        {
            group_member::readvalue $mem_obj mem_obj_attr
            UI_PB_com_ValidateData mem_obj_attr(2) mem_obj_attr(3) ret_code
            if { $ret_code} \
            {
               tk_messageBox -type ok -icon error \
                    -message "Invalid data has been keyed in for the parameter \
                              $mem_obj_attr(0)"
               return 1
            }
        }
     }
  }
  return 0
}

#============================================================================
proc UI_PB_tpth_UpdateEventFloats { EVENT_OBJ MOM_SYS_ARR } {
#============================================================================
  upvar $EVENT_OBJ event_obj
  upvar $MOM_SYS_ARR mom_sys_arr

  foreach item_obj $event::($event_obj,evt_itm_obj_list) \
  {
     foreach grp_obj $item::($item_obj,grp_obj_list) \
     {
        foreach mem_obj $item_group::($grp_obj,mem_obj_list) \
        {
            group_member::readvalue $mem_obj mem_obj_attr
            if {$mem_obj_attr(1) == 5} \
            {
               append var1 $mem_obj_attr(3) _int
               append var2 $mem_obj_attr(3) _dec
               append value $mom_sys_arr($var1) . $mom_sys_arr($var2)
               set mom_sys_arr($mem_obj_attr(3)) $value
               unset var1 var2 value
            }
        }
     }
  }
}

#============================================================================
proc UI_PB_tpth_ApplyCallBack { page_obj seq_page_obj seq_obj event_obj } {
#============================================================================
  global mom_sys_arr

  UI_PB_tpth_DeleteTpthBlock seq_page_obj event_obj
  if {[string compare $event::($event_obj,evt_elem_list) ""] != 0} \
  {
     array set event_rest_data $event::($event_obj,rest_value)
     foreach elem_obj $event::($event_obj,evt_elem_list)\
     {
        set blk_obj $event_element::($elem_obj,block_obj)
        if {[info exist block::($blk_obj,active_blk_elem_list)]} \
        {
           set block::($blk_obj,elem_addr_list) \
                       $block::($blk_obj,active_blk_elem_list)
           set evt_elem_index [lsearch $event_rest_data(2) $elem_obj]
           if { $evt_elem_index == -1 } \
           {
              block::readvalue $blk_obj blk_obj_attr
              block::DefaultValue $blk_obj blk_obj_attr
              unset blk_obj_attr
           }
        } else \
        {
           set block::($blk_obj,elem_addr_list) ""
        }
     }
  }

  PB_int_UpdateMOMVar mom_sys_arr
  if {[string compare $event::($event_obj,event_name) "Cycle Set"] == 0} \
  {
     UI_PB_tpth_UpdateCycleSetEvent page_obj event_obj
  } else \
  {
     UI_PB_tpth_DeleteAndRecreateIcons page_obj event_obj
  }

  UI_PB_tpth_UpdateCycleEvent event_obj seq_obj
  if { $Page::($seq_page_obj,active_seq) == $seq_obj} \
  {
      UI_PB_UpdateSequenceEvent seq_page_obj seq_obj event_obj
  }
  set Page::($page_obj,active_blk_elem) 0

  # Restores the event data
    UI_PB_tpth_RestoreEventData page_obj event_obj
}

#============================================================================
proc UI_PB_tpth_UpdateCycleSetEvent { PAGE_OBJ EVENT_OBJ } {
#============================================================================
  upvar $PAGE_OBJ page_obj
  upvar $EVENT_OBJ event_obj

  # Deletes the block attributes of a tool path event
    UI_PB_tpth_DeleteTpthEventBlkAttr page_obj event_obj

  # Deletes the post blocks and post elements
    UI_PB_tpth_DeletePostBlocks event_obj

  # Adds post blocks 
    PB_int_CreateCyclePostBlks event_obj

  # Creates the block templates
    UI_PB_tpth_CreateEventBlockTemplates page_obj event_obj 
}

#==========================================================================
proc UI_PB_tpth_DeletePostBlocks { EVENT_OBJ } {
#==========================================================================
  upvar $EVENT_OBJ event_obj

  foreach evt_elem_obj $event::($event_obj,evt_elem_list) \
  {
     set block_obj $event_element::($evt_elem_obj,block_obj)
     if {[string compare $block::($block_obj,blk_owner) "post"] == 0} \
     {
        continue
     }

     foreach blk_elem_obj $block::($block_obj,elem_addr_list) \
     {
       if {[string compare $block_element::($blk_elem_obj,owner) "post"] == 0 \
          && [string compare $block_element::($blk_elem_obj,elem_mom_variable) \
              "\$mom_sys_cycle_reps_code"] != 0} \
       {
          continue
       }
       lappend blk_elem_list $blk_elem_obj
     }

     if {[info exists blk_elem_list]} \
     {
        set block::($block_obj,elem_addr_list) $blk_elem_list
        unset blk_elem_list
     }
     lappend evt_elem_list $evt_elem_obj
  }

  if {[info exists evt_elem_list]} \
  {
     set event::($event_obj,evt_elem_list) $evt_elem_list
     unset evt_elem_list
  }
}

#============================================================================
proc UI_PB_tpth_CreateRapidToBlock { EVENT_OBJ } {
#============================================================================
  upvar $EVENT_OBJ event_obj
  global mom_sys_arr

  switch $mom_sys_arr(\$cycle_rapto_opt) \
  {
     "None"        {
                      set elem_address ""
                      set elem_mom_var ""
                      set add_rep_blk_addr ""
                      set add_rep_blk_var ""
                   }

     "R"           {
                      set elem_address ""
                      set elem_mom_var ""
                      set add_rep_blk_addr {"R"}
                      set add_rep_blk_var {"$mom_cycle_rapid_to_pos(2)"}
                   }

     "G00_X_Y_&_R" {
                      set elem_address {{"G_motion" "X" "Y"}}
                      set elem_mom_var {{"$mom_sys_rapid_code" "$mom_pos(0)" \
                                        "$mom_pos(1)"}}
                      set add_rep_blk_addr {"R"}
                      set add_rep_blk_var {"$mom_cycle_rapid_to_pos(2)"}
                   }

     "G00_X_Y_Z"   {
                      set elem_address {{"G_motion" "X" "Y"} {"Z"}}
                      set elem_mom_var {{"$mom_sys_rapid_code" "$mom_pos(0)" \
                                        "$mom_pos(1)"} {"$mom_pos(2)"}}
                      set add_rep_blk_addr ""
                      set add_rep_blk_var ""
                   }
     default       {
                      set elem_address ""
                      set elem_mom_var ""
                      set add_rep_blk_addr ""
                      set add_rep_blk_var ""
                   }
  }


  # Creates new post objects based upon the selected option
    UI_PB_tpth_CreatePostBlock event_obj elem_address elem_mom_var \
                               evt_elem_list 

  if {[info exists evt_elem_list]} \
  {
     foreach evt_elem_obj $event::($event_obj,evt_elem_list) \
     {
        lappend evt_elem_list $evt_elem_obj
     }
     set event::($event_obj,evt_elem_list) $evt_elem_list
     unset evt_elem_list
  }

  # Adds the new post element to the representive block
    UI_PB_tpth_AddPostElementToBlock event_obj add_rep_blk_addr \
                                     add_rep_blk_var
}

#============================================================================
proc UI_PB_tpth_CreatePostBlock { EVENT_OBJ ELEM_ADDRESS ELEM_MOM_VAR \
                                  EVT_ELEM_LIST } {
#============================================================================
  upvar $EVENT_OBJ event_obj
  upvar $ELEM_ADDRESS elem_address
  upvar $ELEM_MOM_VAR elem_mom_var
  upvar $EVT_ELEM_LIST evt_elem_list

  if {$elem_address != ""} \
  {
     set no_blks [llength $elem_address]
     for {set ii 0} {$ii < $no_blks} {incr ii} \
     {
        set blk_obj [new block]
        set blk_elem_adds [lindex $elem_address $ii]
        set blk_elem_vars [lindex $elem_mom_var $ii]
        set no_of_elems [llength $blk_elem_adds]
        for {set jj 0} {$jj < $no_of_elems} {incr jj} \
        {
            set add_name [lindex $blk_elem_adds $jj]
            set mom_var [lindex $blk_elem_vars $jj]
            PB_int_AddNewBlockElemObj add_name mom_var blk_obj \
                                      new_elem_obj
            lappend blk_elem_obj_list $new_elem_obj
            set block_element::($new_elem_obj,owner) "post"
        }
        set blk_obj_attr(0) "post_rapid_$ii"
        set blk_obj_attr(1) [llength $blk_elem_obj_list]
        set blk_obj_attr(2) $blk_elem_obj_list
        block::setvalue $blk_obj blk_obj_attr
        set block::($blk_obj,blk_owner) "post"
        unset blk_obj_attr
        unset blk_elem_obj_list
        set evt_elem_obj_attr(0) "post_rapid_$ii"
        set evt_elem_obj_attr(1) $blk_obj
        set evt_elem_obj_attr(2) "normal"
        set evt_elem_obj [new event_element]
        event_element::setvalue $evt_elem_obj evt_elem_obj_attr
        unset evt_elem_obj_attr
        lappend evt_elem_list $evt_elem_obj
     }
  }
}

#============================================================================
proc UI_PB_tpth_AddPostElementToBlock { EVENT_OBJ ADD_REP_BLK_ADDR \
                                        ADD_REP_BLK_VAR } {
#============================================================================
  upvar $EVENT_OBJ event_obj
  upvar $ADD_REP_BLK_ADDR add_rep_blk_addr
  upvar $ADD_REP_BLK_VAR add_rep_blk_var

  if {$add_rep_blk_addr != ""} \
  {
     foreach evt_elem_obj $event::($event_obj,evt_elem_list) \
     {
        set cyc_block_obj $event_element::($evt_elem_obj,block_obj)
        set ret [UI_PB_tpth_CheckCycleRefWord cyc_block_obj]
        if {$ret == 1} { break }
     }

     set no_of_elems [llength $add_rep_blk_addr]
     for {set jj 0} {$jj < $no_of_elems} {incr jj} \
     {
        set blk_elem_add [lindex $add_rep_blk_addr $jj]
        set blk_elem_var [lindex $add_rep_blk_var $jj]
        PB_int_AddNewBlockElemObj blk_elem_add blk_elem_var cyc_block_obj \
                                  new_elem_obj
        set block_element::($new_elem_obj,owner) "post"
        lappend block::($cyc_block_obj,elem_addr_list) $new_elem_obj
     }
  }
}

#============================================================================
proc UI_PB_tpth_CreateRetractToBlock { EVENT_OBJ } {
#============================================================================
  upvar $EVENT_OBJ event_obj
  global mom_sys_arr
  
  switch $mom_sys_arr(\$cycle_recto_opt) \
  {
      "None"       {
                      set elem_address ""
                      set elem_mom_var ""
                      set add_rep_blk_addr ""
                      set add_rep_blk_var ""
                   }

      "K"          { 
                      set elem_address ""
                      set elem_mom_var ""
                      set add_rep_blk_addr {"K_cycle"}
                      set add_rep_blk_var {"$mom_cycle_retract_to"}
                   }

      "G98/G99"    {
                      set elem_address {{"G_return"}}
                      set elem_mom_var {{"$mom_sys_canned_cyc_ret_plane"}}
                      set add_rep_blk_addr ""
                      set add_rep_blk_var ""
                   }

      "Rapid_Z_Move"     {
                            set elem_address {{"G_motion" "Z"}}
                            set elem_mom_var {{"$mom_sys_rapid_code" "$mom_cycle_retract_to"}}
                            set add_rep_blk_addr ""
                            set add_rep_blk_var ""
                         }

      "Cycle_Off_then_Rapid_Z_Move"  {
                                        set elem_address {{"G_motion"} {"G_motion" "Z"}}
                                        set elem_mom_var {{"$mom_sys_cycle_off"} \
                                               {"$mom_sys_rapid_code" "$mom_cycle_retract_to"}}
                                        set add_rep_blk_addr ""
                                        set add_rep_blk_var ""
                                    }
      default              {
                               set elem_address ""
                               set elem_mom_var ""
                               set add_rep_blk_addr ""
                               set add_rep_blk_var ""
                           }
  }

  # Creates new post objects based upon the selected option
    UI_PB_tpth_CreatePostBlock event_obj elem_address elem_mom_var \
                               evt_elem_list 

  if {[info exists evt_elem_list]} \
  {
     foreach evt_elem_obj $evt_elem_list \
     {
       lappend event::($event_obj,evt_elem_list) $evt_elem_obj
     }
     unset evt_elem_list
  }

  # Adds the new post element to the representive block
    UI_PB_tpth_AddPostElementToBlock event_obj add_rep_blk_addr \
                                     add_rep_blk_var
}

#============================================================================
proc UI_PB_tpth_CreateCycleStartBlock { EVENT_OBJ } {
#============================================================================
  upvar $EVENT_OBJ event_obj
  global mom_sys_arr

  switch $mom_sys_arr(\$cycle_start_blk) \
  {
    "None"      {
                    set elem_address ""
                    set elem_mom_var ""
                }

    "G79_X_Y_Z" {
                    set elem_address {{"G_motion" "X" "Y" "Z"}}
                    set elem_mom_var {{"$mom_sys_cycle_start_code" "$mom_pos(0)" \
                                       "$mom_pos(1)" "$mom_pos(2)"}}
                }
  }

  # Creates new post objects based upon the selected option
    UI_PB_tpth_CreatePostBlock event_obj elem_address elem_mom_var \
                               evt_elem_list 

  if {[info exists evt_elem_list]} \
  {
     foreach evt_elem_obj $evt_elem_list \
     {
       lappend event::($event_obj,evt_elem_list) $evt_elem_obj
     }
     unset evt_elem_list
  }
}

#============================================================================
proc UI_PB_tpth_CreateCyclePlaneBlock { EVENT_OBJ } {
#============================================================================
  upvar $EVENT_OBJ event_obj
  global mom_sys_arr

  switch $mom_sys_arr(\$cycle_plane_control_opt) \
  {
     "None"               {
                              set add_rep_blk_addr ""
                              set add_rep_blk_var ""
                          }

     "G17_/_G18_/_G19"    {
                              set add_rep_blk_addr {"G_plane"}
                              set add_rep_blk_var {"$mom_sys_cutcom_plane_code($mom_cutcom_plane)"}
                          }
    
     "G81_/_G181_/_G281"  {
                              set add_rep_blk_addr ""
                              set add_rep_blk_var ""
                          }

     "R_/_R'_R''"         {
                              set add_rep_blk_addr ""
                              set add_rep_blk_var ""
                          }
      default             {
                              set add_rep_blk_addr ""
                              set add_rep_blk_var ""
                          }
  }

  # Adds the new post element to the representive block
    UI_PB_tpth_AddPostElementToBlock event_obj add_rep_blk_addr \
                                     add_rep_blk_var
}

#============================================================================
proc UI_PB_tpth_DeleteComEvtBlkElems { CYC_EVT_OBJ COM_EVT_NAME } {
#============================================================================
  upvar $CYC_EVT_OBJ cyc_evt_obj
  upvar $COM_EVT_NAME com_evt_name

  foreach cyc_evt_elem_obj $event::($cyc_evt_obj,evt_elem_list)\
  {
     set cyc_blk_obj $event_element::($cyc_evt_elem_obj,block_obj)
     set blk_elem_list $block::($cyc_blk_obj,elem_addr_list)

     # Gets the index of all the common elements
       set index 0
       foreach blk_elem_obj $blk_elem_list \
       {
          set blk_elem_owner $block_element::($blk_elem_obj,owner)
          if { [string compare $blk_elem_owner $com_evt_name] == 0} \
          {
             # deletes the block element object
          } else \
          {
             lappend new_blk_elem_list $blk_elem_obj
          }
          incr index
       }
       
       if {[info exists new_blk_elem_list]} \
       {
          set block::($cyc_blk_obj,elem_addr_list) $new_blk_elem_list
          unset new_blk_elem_list
       } else \
       {
          set block::($cyc_blk_obj,elem_addr_list) ""
       }
  }

  # Deletes the event elements which has got null block elements
    foreach cyc_evt_elem_obj $event::($cyc_evt_obj,evt_elem_list)\
    {
       set blk_obj $event_element::($cyc_evt_elem_obj,block_obj)
       if {[string compare $block::($blk_obj,elem_addr_list) ""] != 0}\
       {
           lappend new_cyc_evt_elems $cyc_evt_elem_obj
       }
    }

    if {[info exists new_cyc_evt_elems]} \
    {
       set event::($cyc_evt_obj,evt_elem_list) $new_cyc_evt_elems
       unset new_cyc_evt_elems
    } else \
    {
       set event::($cyc_evt_obj,evt_elem_list) ""
    }
}

#============================================================================
proc UI_PB_tpth_AddComBlkElemToBlk { COM_BLK_OBJ ADD_BLK_ELEM_LIST \
                                     CUR_EVT_NAME DUP_ADDR_FLAG } {
#============================================================================
  upvar $COM_BLK_OBJ com_blk_obj
  upvar $ADD_BLK_ELEM_LIST add_blk_elem_list
  upvar $CUR_EVT_NAME cur_evt_name
  upvar $DUP_ADDR_FLAG dup_addr_flag

  block::readvalue $com_blk_obj blk_obj_attr

  foreach blk_elem_obj $block::($com_blk_obj,elem_addr_list) \
  {
     if {$dup_addr_flag} \
     {
        set blk_elem_mom_var $block_element::($blk_elem_obj,elem_mom_variable)
        if {[string match "\$mom_sys_cycle*" $blk_elem_mom_var]} \
        {
           continue
        }
     }
     block_element::readvalue $blk_elem_obj blk_elem_attr
     PB_blk_CreateBlkElemObj blk_elem_attr new_blk_elem \
                             blk_obj_attr
     lappend add_blk_elem_list $new_blk_elem
     set block_element::($new_blk_elem,owner) $cur_evt_name
     unset blk_elem_attr
  }
}

#============================================================================
proc UI_PB_tpth_CheckCycleRefWord { BLOCK_OBJ } {
#============================================================================
  upvar $BLOCK_OBJ block_obj

  if {[string compare $block::($block_obj,blk_owner) "post"] == 0} \
  {
     return 0
  }

  foreach blk_elem_obj $block::($block_obj,elem_addr_list) \
  {
     set blk_elem_mom_var $block_element::($blk_elem_obj,elem_mom_variable)
     if {[string match "\$mom_sys_cycle*" $blk_elem_mom_var]}\
     {
        return 1
     }
  }
  return 0
}

#============================================================================
proc UI_PB_tpth_CreateEvtElemFrmEvtObj { EVT_ELEM_OBJ NEW_EVT_ELEM_OBJ \
                                         EVENT_NAME } {
#============================================================================
  upvar $EVT_ELEM_OBJ evt_elem_obj
  upvar $NEW_EVT_ELEM_OBJ new_evt_elem_obj
  upvar $EVENT_NAME current_evt_name

  # Adds the common elements to the block
    set blk_obj $event_element::($evt_elem_obj,block_obj)
    set new_block_name $block::($blk_obj,block_name)

  # Creates a new block
    set dup_addr 0
    UI_PB_tpth_AddComBlkElemToBlk blk_obj cyc_elem_addr_list \
                                  current_evt_name dup_addr

  set new_block_obj [new block]
  set blk_obj_attr(0) $new_block_name
  set blk_obj_attr(1) [llength $cyc_elem_addr_list]
  set blk_obj_attr(2) $cyc_elem_addr_list
  block::setvalue $new_block_obj blk_obj_attr
  block::DefaultValue $new_block_obj blk_obj_attr
  unset blk_obj_attr

  set new_evt_elem_obj [new event_element]
  set evt_elem_attr(0) $new_block_name
  set evt_elem_attr(1) $new_block_obj
  set evt_elem_attr(2) "normal"
  event_element::setvalue $new_evt_elem_obj evt_elem_attr
  event_element::DefaultValue $new_evt_elem_obj evt_elem_attr
}

#============================================================================
proc UI_PB_tpth_UpdateCycleEvent { EVENT_OBJ SEQ_OBJ } {
#============================================================================
  upvar $EVENT_OBJ event_obj
  upvar $SEQ_OBJ seq_obj

  set current_evt_name $event::($event_obj,event_name)
  PB_int_RetCycleComAndSharedEvts cycle_com_evt cycle_shared_evts

  if {[string compare $cycle_com_evt $current_evt_name] == 0} \
  {
    # Gets no of current event elements
      set cur_evt_elems [llength $event::($event_obj,evt_elem_list)]

    # Gets all the cycle event objects
      set evt_obj_list $sequence::($seq_obj,evt_obj_list)

    # Updates the blocks of the cycle events
      foreach cycle_event_name $cycle_shared_evts \
      {
        # Returns the event objects by using the event name
          PB_com_RetObjFrmName cycle_event_name evt_obj_list cycle_evt_obj

        # Procedure deletes the common elements of all blocks
          UI_PB_tpth_DeleteComEvtBlkElems cycle_evt_obj current_evt_name

        # Adds the common blocks to the cycle event
          foreach evt_elem_obj $event::($event_obj,evt_elem_list) \
          {
             set evt_blk $event_element::($evt_elem_obj,block_obj)
             set ret [UI_PB_tpth_CheckCycleRefWord evt_blk]
             if {$ret == 0} \
             {
                UI_PB_tpth_CreateEvtElemFrmEvtObj evt_elem_obj \
                                     new_evt_elem_obj current_evt_name
                lappend act_cyc_evt_elem $new_evt_elem_obj
             } else \
             {
                foreach cyc_evt_elem $event::($cycle_evt_obj,evt_elem_list)\
                {
                   set cyc_evt_blk $event_element::($cyc_evt_elem,block_obj)
                   set ret_code [UI_PB_tpth_CheckCycleRefWord cyc_evt_blk]
                   if {$ret_code == 1}\
                   {
                      # Adds the common elements to the block
                        set cyc_elem_addr_list \
                                 $block::($cyc_evt_blk,elem_addr_list)

                        # Flag is set to remove the representive element
                        set dup_addr 1
                        UI_PB_tpth_AddComBlkElemToBlk evt_blk \
                               cyc_elem_addr_list current_evt_name dup_addr
                        set block::($cyc_evt_blk,elem_addr_list) \
                                       $cyc_elem_addr_list
                        unset cyc_elem_addr_list
                   }
                   lappend act_cyc_evt_elem $cyc_evt_elem
                }
             }
          }
          if {[info exists act_cyc_evt_elem]} \
          {
             set event::($cycle_evt_obj,evt_elem_list) $act_cyc_evt_elem
             unset act_cyc_evt_elem
          }
      }
   }
}

#============================================================================
proc UI_PB_tpth_DeleteAndRecreateIcons { PAGE_OBJ EVENT_OBJ } {
#============================================================================
  upvar $PAGE_OBJ page_obj
  upvar $EVENT_OBJ event_obj
  global paOption

  set bot_canvas $Page::($page_obj,bot_canvas)

  if {[string compare $event::($event_obj,evt_elem_list) ""] != 0} \
  {
     foreach elem_obj $event::($event_obj,evt_elem_list)\
     {
        set blk_obj $event_element::($elem_obj,block_obj)
        foreach blk_elem_obj $block::($blk_obj,elem_addr_list) \
        {
          $bot_canvas delete $block_element::($blk_elem_obj,icon_id)  
          set blk_elem_addr $block_element::($blk_elem_obj,elem_add_obj)
          set blk_elem_add_name $address::($blk_elem_addr,add_name)
          set addr_leader $address::($blk_elem_addr,add_leader)
          set blk_elem_mom_var $block_element::($blk_elem_obj,elem_mom_variable)

          UI_PB_com_RetImageAppdText blk_elem_addr blk_elem_mom_var \
                                img_name blk_elem_text
          set blk_elem_img  [UI_PB_blk_CreateIcon $bot_canvas $img_name \
                                               $blk_elem_text]
          append opt_img pb_ $block_element::($blk_elem_obj,elem_opt_nows_var)
          set name_addr [tix getimage $opt_img]
          unset opt_img

          $blk_elem_img add image -image $name_addr

          set blk_elem_owner $block_element::($blk_elem_obj,owner)
          if {[string compare $blk_elem_owner "post"] == 0} \
          {
             set icon_id [$bot_canvas create image \
                        $block_element::($blk_elem_obj,xc) \
                        $block_element::($blk_elem_obj,yc) \
                        -image $blk_elem_img -tag nonmovable]
             set im [$bot_canvas itemconfigure $icon_id -image]
             [lindex $im end] configure -relief flat
          } else \
          {
             set icon_id [$bot_canvas create image \
                        $block_element::($blk_elem_obj,xc) \
                        $block_element::($blk_elem_obj,yc) \
                        -image $blk_elem_img -tag movable]
          }

          if {[string compare $blk_elem_add_name "Text"] == 0} \
          {
             set im [$bot_canvas itemconfigure $icon_id -image]
             [lindex $im end] configure -bg $paOption(text)
          }
          set block_element::($blk_elem_obj,icon_id) $icon_id
        }
     }
  }
}

#============================================================================
proc UI_PB_tpth_CreateDividers { PAGE_OBJ BLOCK_OBJ } {
#============================================================================
  upvar $PAGE_OBJ page_obj
  upvar $BLOCK_OBJ block_obj

  global paOption
  set bot_canvas $Page::($page_obj,bot_canvas)

  set h_cell $Page::($page_obj,h_cell)       ;# cell height
  set w_cell $Page::($page_obj,w_cell)       ;# cell width
  set w_divi $Page::($page_obj,w_divi)       ;# divider width
  set x_orig $block::($block_obj,x_orig)  ;# upper-left corner of 1st cell
  set y_orig $block::($block_obj,y_orig)
  set main_cell_color $paOption(can_bg)

  if {[info exists block::($block_obj,active_blk_elem_list)]} \
  {
      set n_comp [llength $block::($block_obj,active_blk_elem_list)]
  } else \
  {
      set n_comp 0
  }

  if {[info exists block::($block_obj,sep_id)]} \
  {
     $bot_canvas delete [lindex $block::($block_obj,sep_id) 0]
     $bot_canvas delete [lindex $block::($block_obj,sep_id) 1]
  }

  #-------------------
  # Creates Divider
  #-------------------
   set x0 [expr $x_orig + $w_divi]
   set y0 $y_orig
   set x1 [expr $x0 + [expr [expr $w_divi + $w_cell] * $n_comp] + \
                    $w_divi]
   set y1 [expr $y_orig + $w_divi]

   lappend div_id [$bot_canvas create rect $x0 $y0 $x1 $y1 \
                     -fill $main_cell_color -outline $main_cell_color \
                     -tag stationary]

   set y0 [expr $y_orig + $h_cell + $w_divi]
   set y1 [expr $y0 + $w_divi]

   lappend div_id [$bot_canvas create rect $x0 $y0 $x1 $y1 \
                     -fill $main_cell_color -outline $main_cell_color \
                     -tag stationary]

   set block::($block_obj,sep_id) $div_id
}

#============================================================================
proc UI_PB_tpth_CreateBlkElements { PAGE_OBJ EVENT_OBJ } {
#============================================================================
  upvar $PAGE_OBJ page_obj
  upvar $EVENT_OBJ event_obj

  set event_name $event::($event_obj,event_name)
  foreach event_elem $event::($event_obj,evt_elem_list) \
  {
     set block_obj $event_element::($event_elem,block_obj)
     # Gets the sorted list of the block elements according to
     # the master sequence
       UI_PB_blk_GetBlkAttrSort page_obj block_obj

     # Gets the image ids of all the elements of a block
       UI_PB_blk_CreateBlockImages page_obj block_obj

       # sets the origin of the block
       set block::($block_obj,x_orig) $Page::($page_obj,x_orig)
       set block::($block_obj,y_orig) $Page::($page_obj,y_orig)
       UI_PB_tpth_CreateDividers page_obj block_obj

     # Creates the block elements
       set active_blk_elem_obj 0
       UI_PB_blk_CreateBlockCells page_obj block_obj active_blk_elem_obj \
                                  event_name

       set Page::($page_obj,y_orig) [expr \
             $Page::($page_obj,y_orig) + $Page::($page_obj,blk_blkdist)]
  }
     # Bind procs
       UI_PB_tpth_IconBindProcs page_obj event_obj
}

#==========================================================================
proc UI_PB_tpth_IconBindProcs { PAGE_OBJ EVENT_OBJ } {
#==========================================================================
  upvar $PAGE_OBJ page_obj
  upvar $EVENT_OBJ event_obj

  set bot_canvas $Page::($page_obj,bot_canvas)

  $bot_canvas bind movable <Enter> "UI_PB_tpth_BlkFocusOn $page_obj $event_obj\
                                                          %x %y"

  $bot_canvas bind movable <Leave> "UI_PB_tpth_BlkFocusOff $page_obj"

  $bot_canvas bind movable <1>   "UI_PB_tpth_StartDragBlk $page_obj $event_obj\
                                                          %x %y"

  $bot_canvas bind movable <B1-Motion>  "UI_PB_tpth_DragBlk $page_obj \
                                                            $event_obj \
                                                            %x %y"

  $bot_canvas bind movable <ButtonRelease-1> "UI_PB_tpth_EndDragBlk $page_obj \
                                                                 $event_obj" 

  $bot_canvas bind movable <3>        "UI_PB_tpth_BindRightButton $page_obj \
                                                                  %x %y"

  $bot_canvas bind nonmovable <Enter> "UI_PB_tpth_BlkFocusOn $page_obj \
                                               $event_obj %x %y"

  $bot_canvas bind nonmovable <Leave> "UI_PB_tpth_BlkFocusOff $page_obj"

  $bot_canvas bind nonmovable <1>     "UI_PB_tpth_StartDragBlk $page_obj \
                                                          $event_obj %x %y"
}

#==========================================================================
proc UI_PB_tpth_BindRightButton { page_obj x y } {
#==========================================================================
  set active_blk_elem $Page::($page_obj,in_focus_elem)

  UI_PB_blk_BlockPopupMenu page_obj active_blk_elem $x $y
}

#==========================================================================
proc UI_PB_tpth_BlkFocusOn { page_obj event_obj x y} {
#==========================================================================
   global gPB_help_tips
   set bot_canvas $Page::($page_obj,bot_canvas)

   set x [$bot_canvas canvasx $x]
   set y [$bot_canvas canvasy $y]

   #----------------------
   # Locate in-focus cell
   #----------------------
    UI_PB_tpth_GetEvtElemAndBlkElem event_obj act_blk_elem act_evt_elem $x $y
    set Page::($page_obj,in_focus_elem) $act_blk_elem

    # Change cursor
      $bot_canvas config -cursor hand2

   #-----------------------------
   # Highlight new in-focus cell
   #-----------------------------
   if {$Page::($page_obj,in_focus_elem) != \
           $Page::($page_obj,out_focus_elem)} \
   {
      if { $Page::($page_obj,out_focus_elem) } \
      {
        set out_focus_elem $Page::($page_obj,out_focus_elem)
        $bot_canvas itemconfigure $block_element::($out_focus_elem,rect) \
                   -fill $Page::($page_obj,x_color)
      }

      set cell_highlight_color navyblue
      set in_focus_elem $Page::($page_obj,in_focus_elem)
      set Page::($page_obj,x_color) [lindex [$bot_canvas itemconfigure \
              $block_element::($in_focus_elem,rect) -fill] end]

      $bot_canvas itemconfigure $block_element::($in_focus_elem,rect) \
                   -fill $cell_highlight_color
      set Page::($page_obj,out_focus_elem) $Page::($page_obj,in_focus_elem)

      if { $Page::($page_obj,in_focus_elem) } \
      {
        if {$gPB_help_tips(state)} \
        {
          global tpth_item_focus_on

          if {![info exists tpth_item_focus_on]} \
          {
            set tpth_item_focus_on 0
          }
          if {$tpth_item_focus_on == 0} \
          {
            UI_PB_blk_CreateBalloon page_obj
            set tpth_item_focus_on 1
          }
        }
      }
   }
}

#==========================================================================
proc UI_PB_tpth_GetEvtElemAndBlkElem { EVENT_OBJ ACTIVE_BLK_ELEM_OBJ \
                                       ACTIVE_EVENT_ELEM x y } {
#==========================================================================
  upvar $EVENT_OBJ event_obj
  upvar $ACTIVE_BLK_ELEM_OBJ active_blk_elem_obj
  upvar $ACTIVE_EVENT_ELEM active_event_elem

  set event_elems $event::($event_obj,evt_elem_list)

  set active_blk_elem_obj 0
  set break_flag 0
   foreach elem_obj $event_elems \
   {
       set block_obj $event_element::($elem_obj,block_obj)
       set active_blk_elem_list $block::($block_obj,active_blk_elem_list)
       foreach blk_elem_obj $active_blk_elem_list \
       {
           if {$x >= $block_element::($blk_elem_obj,rect_corn_x0) && \
               $x < $block_element::($blk_elem_obj,rect_corn_x1) && \
               $y >= $block_element::($blk_elem_obj,rect_corn_y0) && \
               $y < $block_element::($blk_elem_obj,rect_corn_y1)} \
           {
              set active_blk_elem_obj $blk_elem_obj
              set active_event_elem $elem_obj
              set break_flag 1
              break;
           }
       }
       if {$break_flag} { break } 
   }
}

#==========================================================================
proc UI_PB_tpth_BlkFocusOff { page_obj } {
#==========================================================================
   set bot_canvas $Page::($page_obj,bot_canvas)

   if { $Page::($page_obj,out_focus_elem) } \
   {
       set out_focus_elem $Page::($page_obj,out_focus_elem)
       $bot_canvas itemconfigure $block_element::($out_focus_elem,rect) \
               -fill $Page::($page_obj,x_color)
   }

   set Page::($page_obj,in_focus_elem) 0
   set Page::($page_obj,out_focus_elem) 0

   # Restore cursor
    $bot_canvas config -cursor ""

   # Balloon stuff
    global gPB_help_tips
    if {$gPB_help_tips(state)} \
    {
      if [info exists gPB_help_tips($bot_canvas)] {
        unset gPB_help_tips($bot_canvas)
      }
      PB_cancel_balloon
      global tpth_item_focus_on
      set tpth_item_focus_on 0
    }
}

#==========================================================================
proc UI_PB_tpth_StartDragBlk { page_obj event_obj x y } {
#==========================================================================
   global paOption
   set bot_canvas $Page::($page_obj,bot_canvas)

   # Unhighlight previously selected icon
    if {$Page::($page_obj,active_blk_elem)} \
    {
      set act_blk_elem_obj $Page::($page_obj,active_blk_elem)
      set act_blk_elem_add_obj $block_element::($act_blk_elem_obj,elem_add_obj)
      set act_blk_add_name $address::($act_blk_elem_add_obj,add_name)
      set icon_id $block_element::($act_blk_elem_obj,icon_id)

      set im [$bot_canvas itemconfigure $icon_id -image]
      set icon_tag [lindex [$bot_canvas itemconfigure $icon_id -tags] end]
      if {[string compare $icon_tag "nonmovable"] == 0} \
      {
         [lindex $im end] configure -relief flat -background #c0c0ff
      } else \
      {
         [lindex $im end] configure -relief raised -background #c0c0ff
      }

      if {[string compare $act_blk_add_name "Text"] == 0} \
      {
         [lindex $im end] configure -background $paOption(text)
      }
    }

   # Highlight current icon
    $bot_canvas raise current
    set im [$bot_canvas itemconfigure current -image]
    set cur_img_tag [lindex [lindex [$bot_canvas itemconfigure current \
                              -tags] end] 0]
    [lindex $im end] configure -relief sunken -background pink

    set panel_hi $Page::($page_obj,panel_hi)

    # Fine adjustment in next 2 lines is needed to line up icons nicely.
    # This may have something to do with the -bd & -relief in canvas.
      set dx 1
      set dy [expr $panel_hi + 2]

    set xx [$bot_canvas canvasx $x]
    set yy [$bot_canvas canvasy $y]

    # Finds source block object and block element object
      UI_PB_tpth_GetEvtElemAndBlkElem event_obj focus_blk_elem \
                                      focus_evt_elem $xx $yy
      set Page::($page_obj,active_blk_elem) $focus_blk_elem

    if {[string compare $cur_img_tag "movable"] == 0} \
    {
       set origin_xb [$bot_canvas canvasx $x]
       set origin_yb [$bot_canvas canvasy $y]
       set Page::($page_obj,last_xb)   $origin_xb
       set Page::($page_obj,last_yb)   $origin_yb
       set blk_elem_addr $block_element::($focus_blk_elem,elem_add_obj)
 
       set blk_elem_mom_var $block_element::($focus_blk_elem,elem_mom_variable)
       UI_PB_com_RetImageAppdText blk_elem_addr blk_elem_mom_var \
                                  image_name blk_elem_text

       set Page::($page_obj,source_blk_elem_obj) $focus_blk_elem
       set Page::($page_obj,source_evt_elem_obj) $focus_evt_elem

       set origin_xt [expr [expr $block_element::($focus_blk_elem,rect_corn_x0) \
                      + $block_element::($focus_blk_elem,rect_corn_x1)] / 2]
       set origin_yt [expr [expr $block_element::($focus_blk_elem,rect_corn_y0) \
                      + $block_element::($focus_blk_elem,rect_corn_y1)] / 2]

       set diff_x [expr $xx - $origin_xt]
       set diff_y [expr $yy - $origin_yt]

       set top_canvas $Page::($page_obj,top_canvas)
       set img_addr [UI_PB_blk_CreateIcon $top_canvas $image_name $blk_elem_text]

       append opt_img pb_ $block_element::($focus_blk_elem,elem_opt_nows_var)
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

       $bot_canvas bind movable <Enter> ""
       $bot_canvas bind movable <Leave> ""

       # Change cursor
#<gsl>         UI_PB_com_ChangeCursor $bot_canvas
    }
}

#==========================================================================
proc UI_PB_tpth_DragBlk { page_obj event_obj x y } {
#==========================================================================
   global env
   set bot_canvas $Page::($page_obj,bot_canvas)

   # Change cursor
#<gsl>   UI_PB_com_ChangeCursor $bot_canvas

   set panel_hi $Page::($page_obj,panel_hi)

   set xc [$bot_canvas canvasx $x]
   set yc [$bot_canvas canvasy $y]

  # Translate element
    $bot_canvas move current [expr $xc - $Page::($page_obj,last_xb)] \
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

    set focus_blk_elem $Page::($page_obj,source_blk_elem_obj)
    set sel_addr_obj $block_element::($focus_blk_elem,elem_add_obj)
    set sel_addr_name $address::($sel_addr_obj,add_name)
    UI_PB_tpth_HighlightSeperators $page_obj $event_obj \
                          $sel_addr_name $xc $yc
}

#==========================================================================
proc UI_PB_tpth_EndDragBlk { page_obj event_obj } {
#==========================================================================
  global paOption
  set bot_canvas $Page::($page_obj,bot_canvas)

  UI_PB_tpth_UnHighLightSep page_obj

  if {$Page::($page_obj,trash_flag)} \
  {
      UI_PB_tpth_PutBlockElemTrash page_obj event_obj
      [lindex $Page::($page_obj,trash) 0] configure \
                        -background $paOption(app_butt_bg)

  } elseif {$Page::($page_obj,add_blk) != 0} \
  {
      UI_PB_tpth_SwapBlockElements page_obj event_obj
  } else \
  {
     set source_blk_elem_obj $Page::($page_obj,source_blk_elem_obj)
      UI_PB_blk_ReturnAddr page_obj source_blk_elem_obj
  }

  # Deletes the icon that has been created in the top canvas
    $Page::($page_obj,top_canvas) delete $Page::($page_obj,icon_top)

  # Delete connecting line
    $Page::($page_obj,top_canvas) delete connect_line

  # Rebind callbacks
    $bot_canvas bind movable <Enter>     "UI_PB_tpth_BlkFocusOn $page_obj \
                                                             $event_obj \
                                                             %x %y"
    $bot_canvas bind movable <Leave>     "UI_PB_tpth_BlkFocusOff $page_obj"

  # Adjust cursor
    $bot_canvas config -cursor ""

    set Page::($page_obj,source_blk_elem_obj) 0
    set Page::($page_obj,source_evt_elem_obj) 0
    set Page::($page_obj,add_blk) 0
    set Page::($page_obj,add_flag) 0
    set Page::($page_obj,trash_flag) 0
}

#==========================================================================
proc UI_PB_tpth_SwapBlockElements {PAGE_OBJ EVENT_OBJ} {
#==========================================================================
   upvar $PAGE_OBJ page_obj
   upvar $EVENT_OBJ event_obj

   # Source block and block element
     set source_blk_elem_obj $Page::($page_obj,source_blk_elem_obj)
     set source_evt_elem_obj $Page::($page_obj,source_evt_elem_obj)

   # source block element is added to active block obj
     set add_to_evt_elem $Page::($page_obj,active_evt_elem_obj)
     set add_to_blk_obj $event_element::($add_to_evt_elem,block_obj)

    if {[string compare $Page::($page_obj,add_blk) "row"] == 0} \
    {
      set new_elem_add_obj $block_element::($source_blk_elem_obj,elem_add_obj)
      set new_elem_add_name $address::($new_elem_add_obj,add_name)
      set blk_exists_flag [UI_PB_com_CheckElemBlkTemplate add_to_blk_obj \
                                    new_elem_add_name]
      if {$blk_exists_flag} \
      {
         UI_PB_com_DisplyErrorMssg new_elem_add_name
         set source_blk_elem_obj $Page::($page_obj,source_blk_elem_obj)
         UI_PB_blk_ReturnAddr page_obj source_blk_elem_obj
         return
      }
    }

    UI_PB_tpth_PutBlockElemTrash page_obj event_obj

    switch $Page::($page_obj,add_blk) \
    {
       "row" \
        {
           UI_PB_tpth_AddBlkElemRow page_obj add_to_evt_elem source_blk_elem_obj
        }
       "top" \
        {
           UI_PB_tpth_AddBlkElemTopOrBottom page_obj event_obj add_to_evt_elem \
                                            source_blk_elem_obj
        }
       "bottom" \
        {
           UI_PB_tpth_AddBlkElemTopOrBottom page_obj event_obj add_to_evt_elem \
                                            source_blk_elem_obj
        }
    }

    set Page::($page_obj,add_blk) 0
    set Page::($page_obj,add_flag) 0
}

#==========================================================================
proc UI_PB_tpth_PutBlockElemTrash { PAGE_OBJ EVENT_OBJ } {
#==========================================================================
  upvar $PAGE_OBJ page_obj
  upvar $EVENT_OBJ event_obj

  set bot_canvas $Page::($page_obj,bot_canvas)

  # Unhighlight previously selected icon
   if {$Page::($page_obj,active_blk_elem)} \
   {
      set act_blk_elem_obj $Page::($page_obj,active_blk_elem)
      set icon_id $block_element::($act_blk_elem_obj,icon_id)
      set im [$bot_canvas itemconfigure $icon_id -image]
      [lindex $im end] configure -relief raised -background #c0c0ff
   }

  set source_blk_elem_obj $Page::($page_obj,source_blk_elem_obj)
  set evt_elem_obj $Page::($page_obj,source_evt_elem_obj)

  set block_obj $event_element::($evt_elem_obj,block_obj)
  set no_blk_elems [llength $block::($block_obj,active_blk_elem_list)]
  set source_cell_num [lsearch $block::($block_obj,active_blk_elem_list) \
                               $source_blk_elem_obj]

  # Removes the blk object from the address blk element list.
    set addr_obj $block_element::($source_blk_elem_obj,elem_add_obj)
    address::DeleteFromBlkElemList $addr_obj source_blk_elem_obj

  set no_event_elems [llength $event::($event_obj,evt_elem_list)]
  set elem_index [lsearch $event::($event_obj,evt_elem_list) evt_elem_obj] 

  if { $no_blk_elems > 1 || $elem_index == [expr $no_event_elems - 1]} \
  {
     UI_PB_tpth_DeleteElemOfRow page_obj event_obj evt_elem_obj source_cell_num

  } elseif  { $no_blk_elems == 1} \
  {
     UI_PB_tpth_DeleteARow page_obj event_obj evt_elem_obj
  }
}

#==========================================================================
proc UI_PB_tpth_DeleteARow { PAGE_OBJ EVENT_OBJ EVT_ELEM_OBJ } {
#==========================================================================
  upvar $PAGE_OBJ page_obj
  upvar $EVENT_OBJ event_obj
  upvar $EVT_ELEM_OBJ evt_elem_obj

  set event_name $event::($event_obj,event_name)
  set elem_index [lsearch $event::($event_obj,evt_elem_list) $evt_elem_obj]
  set bot_canvas $Page::($page_obj,bot_canvas)

  # Deletes the existing blk elements
    set block_obj $event_element::($evt_elem_obj,block_obj)
    UI_PB_blk_DeleteCellsIcons page_obj block_obj

    if {[info exists block::($block_obj,sep_id)]} \
    {
        $bot_canvas delete [lindex $block::($block_obj,sep_id) 0]
        $bot_canvas delete [lindex $block::($block_obj,sep_id) 1]
    }

  # Deletes the block from the block list
    PB_int_RemoveBlkObjFrmList block_obj

  set x_orig $block::($block_obj,x_orig)
  set y_orig $block::($block_obj,y_orig)

  set no_elems [llength $event::($event_obj,evt_elem_list)]
  if {$elem_index || [expr $elem_index + 1] < $no_elems} \
  {
     set event_elems $event::($event_obj,evt_elem_list)
     unset event::($event_obj,evt_elem_list)
     set event_elems [lreplace $event_elems $elem_index $elem_index]
     set event::($event_obj,evt_elem_list) $event_elems
     incr no_elems -1
  } else \
  {
     set evt_elem_obj [lindex $event::($event_obj,evt_elem_list) $elem_index]
     set elem_blk_obj $event_element::($evt_elem_obj,block_obj)
     set block::($elem_blk_obj,active_blk_elem_list) ""
  }

  for {set count $elem_index} {$count < $no_elems} {incr count} \
  {
     set temp_elem_obj [lindex $event::($event_obj,evt_elem_list) $count]
     set temp_blk_obj $event_element::($temp_elem_obj,block_obj)

     # Deletes the existing blk elements
        UI_PB_blk_DeleteCellsIcons page_obj temp_blk_obj

     set Page::($page_obj,x_orig) $x_orig
     set Page::($page_obj,y_orig) $y_orig

     set block::($temp_blk_obj,x_orig) $Page::($page_obj,x_orig)
     set block::($temp_blk_obj,y_orig) $Page::($page_obj,y_orig)
     UI_PB_tpth_CreateDividers page_obj temp_blk_obj

     # Creates the block elements
       UI_PB_blk_CreateBlockImages page_obj temp_blk_obj

       set active_blk_elem_obj 0
       UI_PB_blk_CreateBlockCells page_obj temp_blk_obj active_blk_elem_obj \
                                  event_name
       set y_orig [expr $y_orig + $Page::($page_obj,blk_blkdist)]
  }

  if { $elem_index } \
  {
     set active_elem_obj \
         [lindex $event::($event_obj,evt_elem_list) [expr $elem_index - 1]]
     set active_blk_obj $event_element::($active_elem_obj,block_obj)
     set active_blk_elem_obj [lindex \
         $block::($active_blk_obj,active_blk_elem_list) end]
     set im [$Page::($page_obj,bot_canvas) itemconfigure \
         $block_element::($active_blk_elem_obj,icon_id) -image]
     [lindex $im end] configure -relief sunken -bg pink
     set Page::($page_obj,active_blk_elem) $active_blk_elem_obj
  } else \
  {
     set Page::($page_obj,active_blk_elem) 0
  }
}

#==========================================================================
proc UI_PB_tpth_DeleteElemOfRow { PAGE_OBJ EVENT_OBJ EVT_ELEM_OBJ \
                                  SOURCE_CELL_NUM} {
#==========================================================================
  upvar $PAGE_OBJ page_obj
  upvar $EVENT_OBJ event_obj
  upvar $EVT_ELEM_OBJ evt_elem_obj
  upvar $SOURCE_CELL_NUM source_cell_num

  set bot_canvas $Page::($page_obj,bot_canvas)
  set event_name $event::($event_obj,event_name)

  set block_obj $event_element::($evt_elem_obj,block_obj)
  set no_blk_elems [llength $block::($block_obj,active_blk_elem_list)]
  set elem_index [lsearch $event::($event_obj,evt_elem_list) $evt_elem_obj]
  set no_event_elemss [llength $event::($event_obj,evt_elem_list)]

  # Deletes the existing blk elements
    UI_PB_blk_DeleteCellsIcons page_obj block_obj

   set block::($block_obj,active_blk_elem_list) \
       [lreplace $block::($block_obj,active_blk_elem_list) \
             $source_cell_num $source_cell_num]

   set Page::($page_obj,x_orig) $block::($block_obj,x_orig)
   set Page::($page_obj,y_orig) $block::($block_obj,y_orig)

  if {$no_blk_elems > 1} \
  {
    if {$source_cell_num > 0} \
    {
      set active_blk_elem_obj [lindex \
         $block::($block_obj,active_blk_elem_list) [expr $source_cell_num -1]]
    } elseif {$source_cell_num == 0} \
    {
      set active_blk_elem_obj [lindex \
        $block::($block_obj,active_blk_elem_list) $source_cell_num]
    }
  } elseif {$elem_index == [expr $no_event_elems - 1]} \
  {
      if {[info exists block::($block_obj,sep_id)]} \
      {
          $bot_canvas delete [lindex $block::($block_obj,sep_id) 0]
          $bot_canvas delete [lindex $block::($block_obj,sep_id) 1]
      }
      set event::($event_obj,evt_elem_list) \
        [lreplace $event::($event_obj,evt_elem_list) $elem_index $elem_index]

      if {$elem_index > 0} \
      {
        set active_blk_obj [lindex  \
             $event::($event_obj,evt_elem_list) [expr $elem_index -1]]
        set active_blk_elem_obj \
             [lindex $block::($active_blk_obj,active_blk_elem_list) end] 
      } else \
      {
         set no_elems [llength $event::($event_obj,evt_elem_list)]
         set new_block_obj [new block]
         set blk_obj_attr(0) "sample_$no_elems"
         set blk_obj_attr(1) ""
         set blk_obj_attr(2) ""
         set blk_obj_attr(3) ""
         set blk_obj_attr(4) ""

         block::setvalue $new_block_obj blk_obj_attr
         set new_evt_elem_obj [new event_element]
         set evt_elem_obj_attr(0) "sample_$no_elems"
         set evt_elem_obj_attr(1) $new_block_obj
         set evt_elem_obj_attr(2) "normal"
         event_element::setvalue $new_evt_elem_obj evt_elem_obj_attr

         lappend event::($event_obj,evt_elem_list) $new_evt_elem_obj

         # sets the origin of the block
           set block::($new_block_obj,x_orig) $Page::($page_obj,x_orig)
           set block::($new_block_obj,y_orig) $Page::($page_obj,y_orig)
           set active_blk_elem_obj 0

         set Page::($page_obj,active_evt_elem_obj) $new_evt_elem_obj
         UI_PB_tpth_CreateDividers page_obj new_block_obj
         UI_PB_blk_CreateBlockImages page_obj new_block_obj
         UI_PB_blk_CreateBlockCells page_obj new_block_obj active_blk_elem_obj \
                                    event_name
         set Page::($page_obj,active_blk_elem) 0
         return
      }
  } else \
  {
    set active_blk_elem_obj 0
  }

  # Creates the block elements
   if {[llength $block::($block_obj,active_blk_elem_list)] > 0} \
   {
      UI_PB_tpth_CreateDividers page_obj block_obj
      UI_PB_blk_CreateBlockImages page_obj block_obj
      UI_PB_blk_CreateBlockCells page_obj block_obj active_blk_elem_obj \
                                 event_name
   } else \
   {
      set im [$bot_canvas itemconfigure \
               $block_element::($active_blk_elem_obj,icon_id) -image]
      [lindex $im end] configure -relief sunken -bg pink
      set Page::($page_obj,active_blk_elem) $active_blk_elem_obj
   }
}

#==========================================================================
proc UI_PB_tpth_CreateElemObjects { PAGE_OBJ EVENT_OBJ } {
#==========================================================================
  upvar $PAGE_OBJ page_obj
  upvar $EVENT_OBJ event_obj

  if {[string compare $event::($event_obj,evt_elem_list) ""] != 0} \
  {
     set test_blk_obj [lindex $event::($event_obj,evt_elem_list) 0]
     if {[info exists event_element::($test_blk_obj,block_obj)]} \
     {
       return
     }
  } else \
  {
     set temp_event_name [split $Page::($page_obj,event_name)]
     set event_name [join $temp_event_name _ ]
     set event_name [string tolower $event_name]
     set block_name $event_name
     set blk_elem_list ""
     set blk_owner $event::($event_obj,event_name)
     PB_int_CreateNewBlock block_name blk_elem_list blk_owner \
                           blk_obj

     set elem_type "normal"
     PB_int_CreateNewEventElement blk_obj elem_type evt_elem

     set event::($event_obj,evt_elem_list) $evt_elem
     set Page::($page_obj,dummy_blk) 1
  }
}
