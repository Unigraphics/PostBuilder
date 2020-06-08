##############################################################################
# Description                                                                #
#     This file contains all functions dealing with the EVENT Object.        #
# The attributes for creating the EVENT object are obtained after parsing    #
# the PUI file an the Definition File. The data from PUI file is stored      #
# along with the Post object and used for creating the EVENT Object.         #
#                                                                            #
# Revisions                                                                  #
#                                                                            #
#   Date        Who   Reason                                                 #
# 15-feb-1999   bmp   Initial                                                #
# 07-Apr-1999   mnb   Removed puts                                           #
# 05-May-1999   mnb   Added procedure, which create post blocks for cycles   #
# 02-Jun-1999   mnb   Code Integration                                       #
# 07-Jun-1999   mnb   Event ui data is attached only to the tool path events #
# 25-Jun-1999   mnb   Apply Master Sequence while outputting blocks to       #
#                     Definition file                                        #
# 06-Jul-1999   mnb   Implemented work plane change for rapid event          #
# 13-Oct-1999   mnb   Added procedure to return the event dialog variables.  #
#                                                                            #
# $HISTORY$                                                                  #
#                                                                            #
##############################################################################

#=============================================================================
#The input to the function are the Post Object, Event list name and the Event
#block list name. The attributes are stored in the Post object with the 
#corresponding name. For each of the events the id of the block objects are
#found and along with other attributes the events are created.
#=============================================================================
proc PB_evt_CreateSeqEvents {POST_OBJ EVT_OBJ_LIST EVT_LIST_NAME \
                             EVT_BLK_LIST_NAME SEQ_NAME } {
  upvar $POST_OBJ post_obj
  upvar $EVT_OBJ_LIST evt_obj_list
  upvar $EVT_LIST_NAME evt_list_name
  upvar $EVT_BLK_LIST_NAME evt_blk_list_name
  upvar $SEQ_NAME sequence_name

  # Sets the event name array and event block names array.
    array set evt_name_arr $Post::($post_obj,$evt_list_name)
    array set evt_blk_arr $Post::($post_obj,$evt_blk_list_name)
 
  # Sets the array size (No of Events).
    set arr_sz [array size evt_name_arr]
  
  # Gets the common event and shared events
    set cycle_com_evt [lindex $Post::($post_obj,cyl_com_evt) 0]
    set cycle_shared_evts [lindex $Post::($post_obj,cyl_evt_sh_com_evt) 0]

  # For each of the event names, create EVENT Object.
  for {set sz 0} {$sz < $arr_sz} {incr sz}\
  {
     # Sets the block name array for the event.
       set evt_blk_list $evt_blk_arr($sz)
    
     # Returns the event element objects of an event.
       if {[lsearch $cycle_shared_evts $evt_name_arr($sz)] != -1 } \
       {
          PB_evt_RetCycleEventElements evt_blk_list post_obj evt_name_arr($sz) \
                                       evt_list_name evt_blk_list_name
       } else \
       {
          PB_evt_RetEventElements evt_blk_list post_obj evt_name_arr($sz) \
                                  sequence_name
       }

     # Sets the attributes of the Event.
       set evt_obj_attr(0) $evt_name_arr($sz)
       set evt_obj_attr(1) [llength $evt_blk_list]
       set evt_obj_attr(2) $evt_blk_list
     
     # Returns the item object list for creating the UI for the EVENT.
       if {[string compare $sequence_name "tpth_ctrl"] == 0 || \
           [string compare $sequence_name "tpth_mot"] == 0 || \
           [string compare $sequence_name "tpth_cycle"] == 0 } \
       {
          PB_evt_RetUIItemObjList item_obj_list evt_name_arr($sz) post_obj
       } else \
       {
          set item_obj_list ""
       }

     # Sets the item object list as the attribute of the event.
       set evt_obj_attr(3) $item_obj_list

     # Returns the UDE event object list.
       PB_evt_RetUdeEvtObj post_obj ude_evt_obj_list

     # Creates the Event Object.
       PB_evt_CreateEvtObj evt_obj_attr evt_obj_list

     # Adds the event obj to the block object
       set event_obj [lindex $evt_obj_list $sz]
       foreach row_elem $evt_blk_list \
       {
          foreach evt_elem $row_elem \
          {
             set blk_obj $event_element::($evt_elem,block_obj)
             block::AddToEventList $blk_obj event_obj
          }
       }
  }  
}

#===============================================================================
# This function returns the event nc output, event nc text width and
# event nc text height
#==============================================================================
proc PB_evt_RetNcOutputAttr { EVT_ELEM_LIST EVT_NC_OUTPUT EVT_NC_WIDTH \
                              EVT_NC_HEIGHT } {
#==============================================================================
  upvar $EVT_ELEM_LIST evt_elem_list
  upvar $EVT_NC_OUTPUT evt_nc_output
  upvar $EVT_NC_WIDTH evt_nc_width
  upvar $EVT_NC_HEIGHT evt_nc_height

  set evt_nc_width 0
  set evt_nc_height 0

  foreach row_elem_list $evt_elem_list \
  {
     set blk_nc_width 0
     set evt_nc_height [expr $evt_nc_height + \
                  [font metrics {Helvetica 10} -linespace]]
     foreach elem_obj $row_elem_list \
     {
         set block_obj $event_element::($elem_obj,block_obj)
         foreach blk_elem_obj $block::($block_obj,elem_addr_list) \
         {
            lappend row_blk_elem_list $blk_elem_obj
         }
     }
     # Applys the master sequence to row block elements
       UI_PB_com_ApplyMastSeqBlockElem row_blk_elem_list

     # Gets the block nc output
       PB_com_CreateBlkNcCode row_blk_elem_list blk_nc_output
       unset row_blk_elem_list

       set blk_nc_width [expr $blk_nc_width + \
            [font measure {Helvetica 10} $blk_nc_output)]]
       append evt_nc_output $blk_nc_output "\n"
       unset blk_nc_output

     if {$blk_nc_width > $evt_nc_width} \
     {
         set evt_nc_width $blk_nc_width
     }
  }
}

#===============================================================================
#This function takes the object attributes and the updated EVENT object list
#as the input, creates the EVENT Object and returns the updated object list.
#===============================================================================

proc PB_evt_CreateEvtObj {OBJ_ATTR OBJ_LIST} {
  upvar $OBJ_ATTR obj_attr
  upvar $OBJ_LIST obj_list
 
  #Creates new object.
  set object [new event]

  #Appends object id to the object list.
  lappend obj_list $object

  #sets the latest value to the object created.
  event::setvalue $object obj_attr
  event::DefaultValue $object obj_attr
  
#  puts "The event Object is created : $object"
}

proc PB_evt_RetUdeEvtObj {POST_OBJ UDE_EVT_OBJ_LIST} {
   upvar $POST_OBJ post_obj
   upvar $UDE_EVT_OBJ_LIST ude_evt_obj_list
}

#===============================================================================
#This function takes the input as the Event name and the Post Object, checks
#whether a UI Data is defined for the Event, creates the members, groups and the
#items which builds the UI of the event and returns the Item Object List.
#===============================================================================

proc PB_evt_RetUIItemObjList {ITEM_OBJ_LIST EVENT_NAME POST_OBJ} {
  upvar $ITEM_OBJ_LIST item_obj_list
  upvar $EVENT_NAME event_name
  upvar $POST_OBJ post_obj

  #Sets the UI Event name and Event item group member array from the PUI data.
  array set ui_evt_name_arr $Post::($post_obj,ui_evt_name_lis)
  array set ui_evt_itm_grp_mem_arr $Post::($post_obj,ui_evt_itm_grp_mem_lis)
  
  #Checks whether UI Item data is defined for the EVENT Name in Question.
  for {set ix 0} {$ix < [array size ui_evt_name_arr]} {incr ix}\
  {
     if {[string compare $ui_evt_name_arr($ix) $event_name] == 0}\
     {
       #If the names match, ITEM, GROUP and MEMBERS are created.
       PB_evt_CreateEvtUIItemGrpMemObj item_obj_list ui_evt_itm_grp_mem_arr($ix)
       break
     } else\
     {
       #Else sets the item object list as null.
       set item_obj_list ""
     }
  }
}

#===============================================================================
#This function takes the item, group and member attributes and for each item
#the groups and the group members are created and the item object list is 
#output from the function.
#===============================================================================

proc PB_evt_CreateEvtUIItemGrpMemObj {ITEM_OBJ_LIST UI_EVT_ITM_GRP_MEM_ATTR} {
  upvar $ITEM_OBJ_LIST item_obj_list
  upvar $UI_EVT_ITM_GRP_MEM_ATTR ui_evt_itm_grp_mem_attr

  #For each of the item in the attribute list from PUI.
  foreach item $ui_evt_itm_grp_mem_attr\
  {
     #Takes the first element from the list and splits as the item 
     #attribute list and the rest of the list elemnts as item groups.
     set item_attr_list [lindex $item 0]
     set item_grp_list [lrange $item 1 end]

     #Initialize the group object list and the item object index as zero.
     set grp_obj_list ""
     set itm_ind 0

     #For each of the group in the item group list, group and the
     #respective members are created.
     foreach group $item_grp_list\
     {
        #Splits the first element of the list using : as the delimeter 
        #and stores as the group attr list and the rest as member attr list.
        set grp_attr_list [lindex $group  0]
        set grp_mem_list [lrange $group 1 end]
 
        #Initialize the group object list and the group object index as zero.
        set mem_obj_list ""
        set grp_ind 0

        #For each member of the Group member list, create members.  
        foreach member $grp_mem_list\
        {
           #Splits the member attributes and stores as a list.
           set mem_attr_list $member
 
           #Initialize member index to zero.
           set mem_ind 0
 
           #Convert attribute list into attribute array.
           foreach mem_attr $mem_attr_list\
           {
              set mem_obj_attr($mem_ind) $mem_attr
              incr mem_ind
           }
         
           #Create UI Member taking the object attribute as the input, and
           #the updated object list is output from the procedure.
           PB_evt_CreateUIMember mem_obj_attr mem_obj_list
        }
        
        #For each group attribute list create groups.
        foreach grp_attr $grp_attr_list\
        {
           set grp_obj_attr($grp_ind) $grp_attr
           incr grp_ind
        }
     
        #Sets the member object list as the group attribute.
        set grp_obj_attr($grp_ind) $mem_obj_list
  
        #Create UI Group taking the object attribute as the input, and
        #the updated object list is output from the procedure.
        PB_evt_CreateUIGroup grp_obj_attr grp_obj_list
     }

     #Convert attribute list into attribute array.
     foreach item_attr $item_attr_list\
     {
        set item_obj_attr($itm_ind) $item_attr
        incr itm_ind
     }

     #Sets the group object list as the group attribute.
     set item_obj_attr($itm_ind) $grp_obj_list
    
     #Create UI Item taking the object attribute as the input, and
     #the updated object list is output from the procedure.
     PB_evt_CreateUIItem item_obj_attr item_obj_list
  }

}

#===============================================================================
#This function takes the object attributes and the updated ITEM object list
#as the input, creates the ITEM Object and returns the updated object list.
#===============================================================================

proc PB_evt_CreateUIItem {OBJ_ATTR OBJ_LIST} {
  upvar $OBJ_ATTR obj_attr
  upvar $OBJ_LIST obj_list

  #Creates new object.
  set object [new item]

  #Appends object id to the object list.
  lappend obj_list $object

  #Sets the default value to the object.
  item::setvalue $object obj_attr
  item::DefaultValue $object obj_attr

#  puts "The ITEM Object is created = $object"
}

#===============================================================================
#This function takes the object attributes and the updated GROUP object list
#as the input, creates the GROUP Object and returns the updated object list.
#===============================================================================

proc PB_evt_CreateUIGroup {OBJ_ATTR OBJ_LIST} {
  upvar $OBJ_ATTR obj_attr
  upvar $OBJ_LIST obj_list

  #Creates new object.
  set object [new item_group]

  #Appends object id to the object list.
  lappend obj_list $object
  
  #Sets the default value to the object.
  item_group::setvalue $object obj_attr
  item_group::DefaultValue $object obj_attr

#  puts "The GROUP Object is created = $object"
}

#===============================================================================
#This function takes the object attributes and the updated MEMBER object list
#as the input, creates the MEMBER Object and returns the updated object list.
#===============================================================================

proc PB_evt_CreateUIMember {OBJ_ATTR OBJ_LIST} {
  upvar $OBJ_ATTR obj_attr
  upvar $OBJ_LIST obj_list

  #Creates new object.
  set object [new group_member]
 
  #Appends object id to the object list.
  lappend obj_list $object
  
  #Sets the default value to the object.
  group_member::setvalue $object obj_attr
  group_member::DefaultValue $object obj_attr

#  puts "The GROUP MEMBER Object is created = $object"
}

#==============================================================================
# This procedure creates a event element. The inputs to the procedure
# are the attributes of the object. The output is a event element object
#==============================================================================
proc PB_evt_CreateEventElement { EVT_ELEM_OBJ EVT_OBJ_ATTR } { 
   upvar $EVT_ELEM_OBJ evt_elem_obj
   upvar $EVT_OBJ_ATTR evt_obj_attr

   set evt_elem_obj [new event_element]
   event_element::setvalue $evt_elem_obj evt_obj_attr
   event_element::DefaultValue $evt_elem_obj evt_obj_attr
}

#============================================================================
proc PB_evt_CheckCycleRefWord { BLOCK_OBJ } {
#============================================================================
  upvar $BLOCK_OBJ block_obj

  if {[string compare $block::($block_obj,blk_owner) "post"] == 0} \
  {
     return 0
  }

  foreach blk_elem_obj $block::($block_obj,elem_addr_list) \
  {
     set blk_elem_mom_var $block_element::($blk_elem_obj,elem_mom_variable)
     if {[string match "\$mom_sys_cycle*" $blk_elem_mom_var]} \
     {
        return 1
     }
  }
  return 0
}

#==============================================================================
# This procedure takes the block names list of an cycle event (Created From PUI)
# and retrieves the object id of that block and creates the event element for 
# each block object and creates the same type of list as the object names are 
# replaced by the object id's
#===============================================================================

proc PB_evt_RetCycleEventElements { EVT_BLK_LIST POST_OBJ EVENT_NAME \
                                    EVT_LIST_NAME EVT_BLK_LIST_NAME } {
  upvar $EVT_BLK_LIST evt_blk_list
  upvar $POST_OBJ post_obj
  upvar $EVENT_NAME event_name
  upvar $EVT_LIST_NAME evt_list_name
  upvar $EVT_BLK_LIST_NAME evt_blk_list_name
  
  # Sets the block object list (From PUI).
    set blk_obj_list $Post::($post_obj,blk_obj_list)

  # Gets the cycle common event
    set cycle_com_evt [lindex $Post::($post_obj,cyl_com_evt) 0]

  # Gets the event blk lists
    set evt_name_arr $Post::($post_obj,$evt_list_name)
    array set evt_blk_arr $Post::($post_obj,$evt_blk_list_name)

  # Gets the index of the common event
    set com_evt_indx [expr [lsearch $evt_name_arr $cycle_com_evt] - 1]

  # Gets the common event blocks
    set com_evt_blk_list $evt_blk_arr($com_evt_indx)

  # Retrieves the Object id from the object names and creates object 
  # id the list.
    foreach com_blk $com_evt_blk_list \
    {
       PB_com_RetObjFrmName com_blk blk_obj_list com_blk_obj
       block::readvalue $com_blk_obj com_blk_obj_attr
       set com_ret [PB_evt_CheckCycleRefWord com_blk_obj]
       if {$com_ret == 0} \
       {
           set new_blk_elem_list ""
           foreach com_blk_elem_obj $com_blk_obj_attr(2) \
           {
              block_element::readvalue $com_blk_elem_obj com_blk_elem_attr
              PB_blk_CreateBlkElemObj com_blk_elem_attr new_elem_obj \
                                      com_blk_obj_attr
              lappend new_blk_elem_list $new_elem_obj
              set block_element::($new_elem_obj,owner) $cycle_com_evt
              unset com_blk_elem_attr
           }
           set com_blk_obj_attr(2) $new_blk_elem_list
           PB_blk_CreateBlkObj com_blk_obj_attr new_blk_obj
           set block::($new_blk_obj,blk_owner) $cycle_com_evt

           set evt_obj_attr(0) $com_blk
           set evt_obj_attr(1) $new_blk_obj
           set evt_obj_attr(2) "normal"
           PB_evt_CreateEventElement evt_elem_obj evt_obj_attr 
           lappend evt_elem_obj_list $evt_elem_obj
           unset evt_obj_attr
       } else \
       {
          foreach blk_name $evt_blk_list\
          {
             PB_com_RetObjFrmName blk_name blk_obj_list blk_obj
             set com_ret [PB_evt_CheckCycleRefWord blk_obj]
             PB_evt_SetOwnerShipForBlkElem blk_obj event_name
             set evt_obj_attr(0) $blk_name
             set evt_obj_attr(1) $blk_obj
             set evt_obj_attr(2) "normal"
             PB_evt_CreateEventElement evt_elem_obj evt_obj_attr 
             lappend evt_elem_obj_list $evt_elem_obj
             unset evt_obj_attr
          }
       }
       unset com_blk_obj_attr
    }

    if {[info exists evt_elem_obj_list]} \
    {
       set evt_blk_list $evt_elem_obj_list
       unset evt_elem_obj_list
    } else \
    {
       set evt_blk_list ""
    }
}

#==============================================================================
#This procedure takes the block names list of an event (Created From PUI) and
#retrieves the object id of that block and creates the same type of list as the
#object names are replaced by the object id's
#===============================================================================

proc PB_evt_RetEventElements {EVT_BLK_LIST POST_OBJ EVENT_NAME SEQUENCE_NAME} {
  upvar $EVT_BLK_LIST evt_blk_list
  upvar $POST_OBJ post_obj
  upvar $EVENT_NAME event_name
  upvar $SEQUENCE_NAME sequence_name
  
  # Sets the block object list (From PUI).
    set blk_obj_list $Post::($post_obj,blk_obj_list)

  # Retrieves the Object id from the object names and creates object 
  # id the list.
    foreach blk_row $evt_blk_list\
    {
       foreach row_elem $blk_row\
       {
          PB_com_RetObjFrmName row_elem blk_obj_list blk_obj
          if {[string compare $sequence_name "tpth_ctrl"] == 0 || \
              [string compare $sequence_name "tpth_mot"] == 0 || \
              [string compare $sequence_name "tpth_cycle"] == 0 } \
          {
              PB_evt_SetOwnerShipForBlkElem blk_obj event_name
          }

          set evt_obj_attr(0) $row_elem
          set evt_obj_attr(1) $blk_obj
          set evt_obj_attr(2) "normal"
          PB_evt_CreateEventElement evt_elem_obj evt_obj_attr 
          unset evt_obj_attr
          lappend row_elem_list $evt_elem_obj
       }
  
       if {[info exists row_elem_list]}\
       {
          lappend row_list $row_elem_list
          unset row_elem_list
       }
   }
 
   # Sets the event block name list as event block object list.
     if {[info exists row_list]}\
     {
        set evt_blk_list $row_list
        unset row_list
     } else\
     {
        # If there are no blocks, sets the list as null.
          set evt_blk_list ""
     }

     if {[string compare $event_name "Cycle Set"] == 0} \
     {
       # Creates the Rapid block
         PB_evt_CreateRapidToBlock evt_blk_list

       # Creates the Retract block
         PB_evt_CreateRetractToBlock evt_blk_list

       # Creates the Cycle plane control block
         PB_evt_CreateCyclePlaneBlock evt_blk_list

       # Creates the Cycle Start Block
         PB_evt_CreateCycleStartBlock evt_blk_list

       # Stores the post blocks in the post object
         PB_evt_StorePostBlocks evt_blk_list
     } elseif { [string compare $event_name "Rapid Move"] == 0} \
     {
       # Work Plane change implementation
         PB_evt_RapidWrkPlaneChange evt_blk_list
     }
} 

#============================================================================
proc PB_evt_RapidWrkPlaneChange { EVT_BLK_LIST } {
#============================================================================
  upvar $EVT_BLK_LIST evt_blk_list

  foreach event_row $evt_blk_list \
  {
     foreach evt_elem_obj $event_row \
     {
        set blk_obj $event_element::($evt_elem_obj,block_obj)
        set block_name $block::($blk_obj,block_name)
        if {[string compare $block_name "rapid_traverse"] == 0 || \
            [string compare $block_name "rapid_spindle"] == 0} \
        {
           foreach blk_elem_obj $block::($blk_obj,elem_addr_list) \
           {
              set add_obj $block_element::($blk_elem_obj,elem_add_obj)
              switch $address::($add_obj,add_name) \
              {
                 "X" -
                 "Y" -
                 "Z" {
                       set block_element::($blk_elem_obj,owner) "post"
                     }
              }
           }
        }
     }
  }
}

#============================================================================
proc PB_evt_StorePostBlocks { EVT_ELEM_LIST } {
#============================================================================
  upvar $EVT_ELEM_LIST evt_elem_list
  global post_object

  if {[info exists Post::($post_object,post_blk_list)]} \
  {
     unset Post::($post_object,post_blk_list)
  }

  foreach evt_elem_obj $evt_elem_list \
  {
     set block_obj $event_element::($evt_elem_obj,block_obj)
     if { ![string compare $block::($block_obj,blk_owner) "post"]} \
     {
        lappend post_blk_list $block_obj
     }
  }

  if {[info exists post_blk_list]} \
  {
     set Post::($post_object,post_blk_list) $post_blk_list
  }
}

#============================================================================
proc PB_evt_CreateRapidToBlock { EVT_ELEM_LIST } {
#============================================================================
  upvar $EVT_ELEM_LIST evt_elem_list
  global post_object

  set post_blk_name "rapidto"
  array set mom_sys_var $Post::($post_object,mom_sys_var_list)
  switch $mom_sys_var(\$cycle_rapto_opt) \
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
    PB_evt_CreatePostBlock post_blk_name elem_address elem_mom_var \
                           new_elem_list

  if {[info exists new_elem_list]} \
  {
     foreach evt_elem_obj $evt_elem_list \
     {
        lappend new_elem_list $evt_elem_obj
     }
     unset evt_elem_list
     set evt_elem_list $new_elem_list
  }

  # Adds the new post element to the representive block
    PB_evt_AddPostElementToBlock evt_elem_list add_rep_blk_addr \
                                 add_rep_blk_var
}

#============================================================================
proc PB_evt_CreatePostBlock { BLOCK_NAME ELEM_ADDRESS ELEM_MOM_VAR \
                              EVT_ELEM_LIST } {
#============================================================================
  upvar $BLOCK_NAME block_name
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
        if {$ii != 0} \
        {
           append blk_obj_attr(0) "post_" $block_name _ $ii
        } else \
        {
           set blk_obj_attr(0) "post_$block_name"
        }
        for {set jj 0} {$jj < $no_of_elems} {incr jj} \
        {
            set add_name [lindex $blk_elem_adds $jj]
            set mom_var [lindex $blk_elem_vars $jj]
            PB_blk_AddNewBlkElemObj add_name mom_var blk_obj_attr \
                                      new_elem_obj
            lappend blk_elem_obj_list $new_elem_obj
            set block_element::($new_elem_obj,owner) "post"
        }
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
proc PB_evt_AddPostElementToBlock { EVT_ELEM_LIST ADD_REP_BLK_ADDR \
                                    ADD_REP_BLK_VAR } {
#============================================================================
  upvar $EVT_ELEM_LIST evt_elem_list
  upvar $ADD_REP_BLK_ADDR add_rep_blk_addr
  upvar $ADD_REP_BLK_VAR add_rep_blk_var

  if {$add_rep_blk_addr != ""} \
  {
     foreach evt_elem_obj $evt_elem_list \
     {
        set cyc_block_obj $event_element::($evt_elem_obj,block_obj)
        set ret [PB_evt_CheckCycleRefWord cyc_block_obj]
        if {$ret == 1} { break }
     }

     block::readvalue $cyc_block_obj cyc_blk_obj_attr
     set no_of_elems [llength $add_rep_blk_addr]
     for {set jj 0} {$jj < $no_of_elems} {incr jj} \
     {
        set blk_elem_add [lindex $add_rep_blk_addr $jj]
        set blk_elem_var [lindex $add_rep_blk_var $jj]
        PB_blk_AddNewBlkElemObj blk_elem_add blk_elem_var cyc_blk_obj_attr \
                                  new_elem_obj
        set block_element::($new_elem_obj,owner) "post"
        lappend block::($cyc_block_obj,elem_addr_list) $new_elem_obj
     }
     unset cyc_blk_obj_attr
  }
}

#============================================================================
proc PB_evt_CreateRetractToBlock { EVT_ELEM_LIST } {
#============================================================================
  upvar $EVT_ELEM_LIST evt_elem_list
  global post_object
 
  set post_blk_name "retracto"
  array set mom_sys_var $Post::($post_object,mom_sys_var_list)
  switch $mom_sys_var(\$cycle_recto_opt) \
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
    PB_evt_CreatePostBlock post_blk_name elem_address elem_mom_var \
                           new_elem_list

  if {[info exists new_elem_list]} \
  {
     foreach evt_elem_obj $new_elem_list \
     {
       lappend evt_elem_list $evt_elem_obj
     }
  }

  # Adds the new post element to the representive block
    PB_evt_AddPostElementToBlock evt_elem_list add_rep_blk_addr \
                                 add_rep_blk_var
}

#============================================================================
proc PB_evt_CreateCycleStartBlock { EVT_ELEM_LIST } {
#============================================================================
  upvar $EVT_ELEM_LIST evt_elem_list
  global post_object

  set post_blk_name "startblk"
  array set mom_sys_var $Post::($post_object,mom_sys_var_list)
  switch $mom_sys_var(\$cycle_start_blk) \
  {
      0   {
             set elem_address ""
             set elem_mom_var ""
          }

      1   {
             set elem_address {{"G_motion" "X" "Y" "Z"}}
             set elem_mom_var {{"$mom_sys_cycle_start_code" "$mom_pos(0)" \
                                "$mom_pos(1)" "$mom_pos(2)"}}
          }
  }

  # Creates new post objects based upon the selected option
    PB_evt_CreatePostBlock post_blk_name elem_address elem_mom_var \
                           new_elem_list

  if {[info exists new_elem_list]} \
  {
     foreach evt_elem_obj $new_elem_list \
     {
       lappend evt_elem_list $evt_elem_obj
     }
  }
}

#============================================================================
proc PB_evt_CreateCyclePlaneBlock { EVT_ELEM_LIST } {
#============================================================================
  upvar $EVT_ELEM_LIST evt_elem_list
  global post_object

  array set mom_sys_var $Post::($post_object,mom_sys_var_list)
  switch $mom_sys_var(\$cycle_plane_control_opt) \
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
    PB_evt_AddPostElementToBlock evt_elem_list add_rep_blk_addr \
                                 add_rep_blk_var
}

#===============================================================================
#This procedure sets the ownership for each block element. The ownership can be 
#set only when a block is referenced by and event. The owner of the block
#will be the respective event.
#===============================================================================

proc PB_evt_SetOwnerShipForBlkElem {BLK_OBJ EVENT_NAME} {
  upvar $BLK_OBJ blk_obj
  upvar $EVENT_NAME event_name
  global post_object

  set common_evt [lindex $Post::($post_object,cyl_com_evt) 0]
  set shared_evt_list [lindex $Post::($post_object,cyl_evt_sh_com_evt) 0]

  # Sets the block element object list.
    set blk_elem_obj_list $block::($blk_obj,elem_addr_list)
    set block::($blk_obj,blk_owner) $event_name

  # For each of the block element the ownership is set as the event name.
    if {[lsearch $shared_evt_list $event_name] != -1} \
    {
       set cycle_evt_list $Post::($post_object,tpth_cycle_evt_list)
       array set cycle_evt_blks $Post::($post_object,tpth_cycle_evt_blk_list)
       set indx [lindex $cycle_evt_list [expr [lsearch $cycle_evt_list \
                    $common_evt] - 1]]
       set com_evt_blks $cycle_evt_blks($indx)
       set blk_obj_list $Post::($post_object,blk_obj_list)
       foreach com_evt_blk_obj $com_evt_blks \
       {
          PB_com_RetObjFrmName com_evt_blk_obj blk_obj_list com_blk_obj
          set com_ret [PB_evt_CheckCycleRefWord com_blk_obj]
          if {$com_ret == 1} {break}
       }

       set blk_ret [PB_evt_CheckCycleRefWord blk_obj]
       if {$blk_ret == 1} \
       {
          foreach blk_elem $blk_elem_obj_list\
          {
             set ret [PB_evt_CheckElemInBlock com_blk_obj blk_elem]
             if {$ret == 1} \
             {
                set block_element::($blk_elem,owner) $common_evt
             } else \
             {
               if {[string match "\$mom_sys_cycle*" \
                       $block_element::($blk_elem,elem_mom_variable)]}\
               {
                  set block_element::($blk_elem,owner) "post"
               } else \
               {
                  set block_element::($blk_elem,owner) $event_name
               }
             }
          }  
       } else \
       {
          foreach blk_elem $blk_elem_obj_list\
          {
               set block_element::($blk_elem,owner) $event_name
          }
       }
    } else \
    {
         foreach blk_elem $blk_elem_obj_list\
         {
           if {[string compare $block_element::($blk_elem,elem_mom_variable) \
                  "\$mom_sys_cycle_reps_code"] == 0} \
           {
              set block_element::($blk_elem,owner) "post"
           } else \
           {
              set block_element::($blk_elem,owner) $event_name
           }
         }  
    }
}

#================================================================
proc PB_evt_CheckElemInBlock {BLK_OBJ ELEM_OBJ} {
#================================================================
  upvar $BLK_OBJ blk_obj
  upvar $ELEM_OBJ elem_obj

  set elem_addr_obj $block_element::($elem_obj,elem_add_obj)
  set elem_mom_var $block_element::($elem_obj,elem_mom_variable)

  foreach blk_elem_obj $block::($blk_obj,elem_addr_list)\
  {
     set blk_elem_add_obj $block_element::($blk_elem_obj,elem_add_obj)
     set blk_elem_mom_var $block_element::($blk_elem_obj,elem_mom_variable)
     if {$blk_elem_add_obj == $elem_addr_obj && \
         [string compare $elem_mom_var $blk_elem_mom_var] == 0}\
     {
        return 1
     }
  }
  return 0
}

#=========================================================================
proc PB_evt_RetEventVars { EVENT_OBJ EVT_VARS } {
#=========================================================================
  upvar $EVENT_OBJ event_obj
  upvar $EVT_VARS evt_vars

  event::readvalue $event_obj evt_obj_attr
  set evt_vars ""
  foreach item_obj $evt_obj_attr(3) \
  {
     item::readvalue $item_obj item_obj_attr
     foreach grp_obj $item_obj_attr(3) \
     {
        item_group::readvalue $grp_obj grp_obj_attr
        foreach mem_obj $grp_obj_attr(3) \
        {
           group_member::readvalue $mem_obj mem_obj_attr
           if { $mem_obj_attr(3) != "null" } \
           {
              lappend evt_vars $mem_obj_attr(3)
           }
           unset mem_obj_attr
        }
        unset grp_obj_attr
     }
     unset item_obj_attr
  }
  unset evt_obj_attr
}
