###############################################################################
#                                                                             #
# DESCRIPTION                                                                 #
# create the def and event handler files from the post builder data base.     #
#                                                                             #
# REVISIONS                                                                   #
#                                                                             #
# REV  DATE        WHO  PR       REASON                                       #
# 00   30Mar1999   MKG           Initial                                      #
# 01   14May1999   mnb           Integrated with post builder                 #
# 02   20May1999   mnb           Added event procedures                       #
# 03   02Jun1999   mnb           Code Integration                             #
# 04   14Jun1999   mnb           Added procedures to output WordSeperator,    #
#                                End of Line and Sequence Number              #
# 05   16Jun1999   mnb           Changed Tcl output file name                 #
# 06   29Jun1999   mnb           Added Composite Blocks                       #
# 07   30Jun1999   mnb           Added ugpost_base.tcl procedures             #
# 08   07Sep1999   mnb           Changed % to & format                        #
# 09   13Oct1999   mnb           Added API's for getting block element        #
#                                modality & Event variables                   # #                                                                             #
# $HISTORY$                                                                   #
###############################################################################

#===========================================================================
#             API'S FOR CODE GENERATION
#===========================================================================

#===========================================================================
# This proceduer returns the word Seperator
#
#      Inputs  :  word seperator
#
#      Output  :  Formatted word seperator
#
#===========================================================================
proc PB_output_GetWordSeperator { word_sep WSP_OUTPUT } {
#===========================================================================
  upvar $WSP_OUTPUT wsp_output

  set wsp_output "WORD_SEPARATOR \"$word_sep\""
}

#===========================================================================
# This proceduer returns the End of Line
#
#     Inputs  :  end of line character
#
#     Outputs :  Formatted end of line
#
#===========================================================================
proc PB_output_GetEndOfLine { end_of_line ENDLINE_OUTPUT } {
#===========================================================================
  upvar $ENDLINE_OUTPUT endline_output

  set endline_output "END_OF_LINE \"$end_of_line\""
}

#===========================================================================
# This proceduer returns the sequence
#
#     Inputs  : An array which contains sequence block,
#               start value, increment & frequencey.
#
#     Outputs : Formatted Sequence
#
#===========================================================================
proc PB_output_GetSequenceNumber { SEQ_PARAM SEQUENCE_OUTPUT } {
#===========================================================================
  upvar $SEQ_PARAM seq_param
  upvar $SEQUENCE_OUTPUT sequence_output

  set sequence_output "SEQUENCE $seq_param(0) $seq_param(1) \
                            $seq_param(2) $seq_param(3)"
}

#===========================================================================
# This proceduer returns the format name list and its format
#
#    Inputs  :  Format Object list
#
#    Outputs :  Format Name list
#               Format i.e & or % format
#
#===========================================================================
proc PB_output_GetFmtObjAttr {FMT_OBJ_LIST FMT_NAME_ARR FMT_VAL_ARR} {
#===========================================================================
  upvar $FMT_OBJ_LIST fmt_obj_list
  upvar $FMT_NAME_ARR fmt_name_arr
  upvar $FMT_VAL_ARR fmt_val_arr

  set ind 0

  foreach fmt_obj $fmt_obj_list\
  {
     # Gets the format name
       set fmt_name_arr($ind) $format::($fmt_obj,for_name)
       format::readvalue $fmt_obj fmt_obj_attr

     # Gets the format
       PB_fmt_RetFmtFrmAttr fmt_obj_attr for_value
       set fmt_val_arr($ind) $for_value
       incr ind
  }
}

#===========================================================================
# This proceduer returns address names and the formatted address
#
#      Inputs  :  Address object list
#
#      Outputs :  The address names are stored in the array adr_name_arr
#                 The formatted address in adr_val_arr
#
#===========================================================================
proc PB_output_GetAdrObjAttr {ADD_OBJ_LIST ADR_NAME_ARR ADR_VAL_ARR} {
#===========================================================================
  upvar $ADD_OBJ_LIST add_obj_list
  upvar $ADR_NAME_ARR adr_name_arr
  upvar $ADR_VAL_ARR adr_val_arr

  set ind 0
  foreach adr_obj $add_obj_list\
  {
     # Stores the address name in the array
       set adr_name_arr($ind) $address::($adr_obj,add_name)

     # Gets the address object attributes
      address::readvalue $adr_obj adr_obj_attr

     # Gets the formatted address
       PB_adr_RetAddFrmAddAttr adr_obj_attr val_list

     set adr_val_arr($ind) $val_list
     unset val_list
     incr ind
  }
}

#===========================================================================
# This proceduer returns the block name arr and the block templates
#
#     Inputs   :  Block Object list
#
#     Outputs  :  The names of block are stored in blk_name_arr
#                 The block templates are stored in blk_value_arr
#
#===========================================================================
proc PB_output_GetBlkObjAttr {BLK_OBJ_LIST BLK_NAME_ARR BLK_VALUE_ARR} {
#===========================================================================
 upvar $BLK_OBJ_LIST blk_obj_list
 upvar $BLK_NAME_ARR blk_name_arr
 upvar $BLK_VALUE_ARR blk_value_arr

 set indx 0
 foreach block_obj $blk_obj_list\
 {
   # Gets the block name
     set blk_name_arr($indx) $block::($block_obj,block_name)

   # Gets the block object attributes
     block::readvalue $block_obj blk_obj_attr

   # Gets the block template details
     PB_blk_RetBlkFrmBlkAttr blk_obj_attr blk_value_list

   # Stores the template in the array
     set blk_value_arr($indx) $blk_value_list

   unset blk_value_list
   incr indx
 } 
}

#===========================================================================
# This proceduer returns all the composite blocks
#===========================================================================
proc PB_output_GetCompositeBlks { COMP_BLK_LIST } {
#===========================================================================
  upvar $COMP_BLK_LIST comp_blk_list
  global post_object

  set seq_obj_list $Post::($post_object,seq_obj_list)
  lappend in_sequence [lindex $seq_obj_list 0] [lindex $seq_obj_list 1] \
                      [lindex $seq_obj_list 5] [lindex $seq_obj_list 6]

  foreach seq_obj $in_sequence \
  {
     set evt_obj_list $sequence::($seq_obj,evt_obj_list)
     foreach evt_obj $evt_obj_list \
     {
        set evt_elem_list $event::($evt_obj,evt_elem_list)
        foreach evt_elem_row $evt_elem_list \
        {
           set no_of_rowelem [llength $evt_elem_row]
           if {$no_of_rowelem > 1} \
           {
              set temp_event_name $event::($evt_obj,event_name)    
              set temp_event_name [string tolower $temp_event_name]
              set temp_evt_name [join [split $temp_event_name " "] _ ]
              set blk_obj_attr(0)  $temp_evt_name
              PB_int_GetAllBlockNames blk_name_list
              PB_com_SetDefaultName blk_name_list blk_obj_attr
              set comp_blk_elem ""
              foreach evt_elem_obj $evt_elem_row \
              {
                 set block_obj $event_element::($evt_elem_obj,block_obj)
                 foreach blk_elem_obj $block::($block_obj,elem_addr_list) \
                 {
                    lappend comp_blk_elem $blk_elem_obj
                 }
              }
              UI_PB_com_ApplyMastSeqBlockElem comp_blk_elem
              set blk_obj_attr(1) [llength $comp_blk_elem]
              set blk_obj_attr(2) $comp_blk_elem
              PB_blk_CreateBlkObj blk_obj_attr comp_blk_obj
              lappend comp_blk_list $comp_blk_obj
              # Sets the first event element name as the composite blocks 
              # name. It is not good.... something has to be done here.
                set first_elem_obj [lindex $evt_elem_row 0]
                set event_element::($first_elem_obj,evt_elem_name) \
                                             $blk_obj_attr(0)
           }
        }
     }
  }
}

#===========================================================================
proc PB_output_GetMomSysVars {MOM_SYS_NAME_ARR MOM_SYS_VAL_ARR} {
#===========================================================================
  upvar $MOM_SYS_NAME_ARR mom_sys_name_arr
  upvar $MOM_SYS_VAL_ARR mom_sys_val_arr

  global post_object
  
  array set mom_sys_var_arr $Post::($post_object,mom_sys_var_list)
  array set mom_sys_g_codes $Post::($post_object,g_codes)
  array set mom_sys_m_codes $Post::($post_object,m_codes)
  
  # Gets all G-codes
    set no_of_g_codes [array size mom_sys_g_codes]
    set ind 0
    for {set count 0} { $count < $no_of_g_codes } {incr count} \
    {
       set mom_sys_var $mom_sys_g_codes($count)
       set mom_sys_name_arr($ind) [string trimleft $mom_sys_var \$]
       set mom_sys_val_arr($ind) $mom_sys_var_arr($mom_sys_var)
       incr ind
    }

  # Gets all M-codes
    set no_of_m_codes [array size mom_sys_m_codes]
    for {set count 0} { $count < $no_of_m_codes } {incr count} \
    {
       set mom_sys_var $mom_sys_m_codes($count)
       set mom_sys_name_arr($ind) [string trimleft $mom_sys_var \$]
       set mom_sys_val_arr($ind) $mom_sys_var_arr($mom_sys_var)
       incr ind
    }
}

#===========================================================================
proc PB_output_GetMomKinVars { KIN_NAME_ARR KIN_VAL_ARR } {
#===========================================================================
  upvar $KIN_NAME_ARR kin_name_arr
  upvar $KIN_VAL_ARR kin_val_arr

  global post_object
  set ind 0

  array set mom_kin_var_arr $Post::($post_object,mom_kin_var_list)
  set mom_kin_name_list [array names mom_kin_var_arr]

  foreach mom_kin_var $mom_kin_name_list\
  {
     set kin_name_arr($ind) [string trimleft $mom_kin_var \$]
     set kin_val_arr($ind) $mom_kin_var_arr($mom_kin_var)
     incr ind
  }
}

#=========================================================================
# This proceduer returns the address of the block, whcih are to be
# forced before outputting the block.
#
#     Outputs  :  A list of address, which are to be forced are stored
#                 in the array, with the block name as the index
#
#=========================================================================
proc PB_output_RetBlksModality { BLK_MOD_ARR } {
#=========================================================================
  upvar $BLK_MOD_ARR blk_mod_arr
  global post_object

  # Gets the blocks object list from the post object
    set blk_obj_list $Post::($post_object,blk_obj_list)

  foreach blk_obj $blk_obj_list \
  {
    # Returns the list of addresses to be forced
      PB_blk_BlockModality blk_obj blk_mod_adds

    set block_name $block::($blk_obj,block_name)
    set blk_mod_arr($block_name) $blk_mod_adds
  }
}

#=========================================================================
# This proceduer returns the event ui variables and their values
#
#     Outputs  :  A list of ui event variables 
#                 Value of the variable
#
#=========================================================================
proc PB_output_GetEventsVariables {EVENT_VAR_ARR EVENT_VALUE_ARR } {
#=========================================================================
  upvar $EVENT_VAR_ARR event_var_arr
  upvar $EVENT_VALUE_ARR event_value_arr
  global post_object

  # mom_sys_arr
    array set mom_sys_arr $Post::($post_object,mom_sys_var_list)

  # Gets all the sequence objects
    set seq_obj_list $Post::($post_object,seq_obj_list)

    lappend out_sequence [lindex $seq_obj_list 2] [lindex $seq_obj_list 3] \
                         [lindex $seq_obj_list 4]
    unset seq_obj_list

  # Gets the mom variables of all the events
    foreach seq_list $out_sequence \
    {
       foreach seq_obj $seq_list \
       {
         # Gets events of a sequence
           set evt_obj_list $sequence::($seq_obj,evt_obj_list)
           foreach evt_obj $evt_obj_list \
           {
              # Gets the variables of an event
                PB_evt_RetEventVars evt_obj evt_vars
              
              # Gets event name
                set event_name $event::($evt_obj,event_name)

              # Stores the variables in the array, with event name
              #  as the index
                set event_var_arr($event_name) $evt_vars

              # Stores the values of all the variables
                foreach var $evt_vars \
                {
                   set event_value_arr($var) $mom_sys_arr($var)
                }
           }
       }
    }
}

#=========================================================================
# This proceduer returns the event names and the list of the blocks
# that go with each event.
#
#     Outputs  :  Event Name
#                 Event Blocks list
#
#=========================================================================
proc PB_output_GetEvtObjAttr { EVT_NAME_ARR EVT_BLK_ARR } {
#=========================================================================
  upvar $EVT_NAME_ARR evt_name_list
  upvar $EVT_BLK_ARR evt_blk_arr

  global post_object

  # Gets all the sequence objects
    set seq_obj_list $Post::($post_object,seq_obj_list)

    lappend in_sequence [lindex $seq_obj_list 0] [lindex $seq_obj_list 1] \
                        [lindex $seq_obj_list 5] [lindex $seq_obj_list 6]

    lappend out_sequence [lindex $seq_obj_list 2] [lindex $seq_obj_list 3] \
                         [lindex $seq_obj_list 4]
    unset seq_obj_list
    lappend seq_obj_list $in_sequence $out_sequence

  set evt_name_list ""
  foreach seq_list $seq_obj_list \
  {
     foreach seq_obj $seq_list \
     {
       # Gets events of a sequence
         set evt_obj_list $sequence::($seq_obj,evt_obj_list)
         foreach evt_obj $evt_obj_list \
         {
            set evt_blk_name_list ""
            set temp_event_name $event::($evt_obj,event_name)    
            set temp_event_name [string tolower $temp_event_name]
            set temp_evt_name [join [split $temp_event_name " "] _ ]
            append event_name MOM_ $temp_evt_name
            
            if { [lsearch $evt_name_list $event_name] == -1 } \
            {
               lappend evt_name_list $event_name
            }
            
            set evt_elem_list $event::($evt_obj,evt_elem_list)
            foreach evt_elem_row $evt_elem_list \
            {
               if { [llength $evt_elem_row] > 1} \
               {
                  set first_elem_obj [lindex $evt_elem_row 0]
                  lappend evt_blk_name_list \
                               $event_element::($first_elem_obj,evt_elem_name)
               } else \
               {
                  foreach evt_elem_obj $evt_elem_row \
                  {
                     set block_obj $event_element::($evt_elem_obj,block_obj)
                     lappend evt_blk_name_list $block::($block_obj,block_name)
                  }
               }
            }
            lappend evt_blk_arr($event_name) $evt_blk_name_list
            unset event_name
         }
     }
  }
  PB_output_EliminatePbEvents evt_name_list evt_blk_arr
}

#=========================================================================
# This proceduer removes the Post Builder events from the arrays
#=========================================================================
proc PB_output_EliminatePbEvents { EVT_NAME_LIST EVT_BLK_ARR } {
#=========================================================================
  upvar $EVT_NAME_LIST evt_name_list
  upvar $EVT_BLK_ARR evt_blk_arr

  # Post Builder events
    set pb_events { "MOM_inch_/_metric_mode" "MOM_feedrate" \
                  "MOM_cycle_set" }

  foreach event_name $pb_events \
  {
     set evt_flag [lsearch $evt_name_list $event_name]
     if { $evt_flag != -1 } \
     {
         set evt_name_list [lreplace $evt_name_list $evt_flag \
                                     $evt_flag]
         unset evt_blk_arr($event_name)
     }
  }
}

#=========================================================================
#                  CODE GENERATION PROCEDURES
#=========================================================================

#=========================================================================
#                   DEF file writing modules
#=========================================================================

#=========================================================================
proc PB_PB2DEF_write_formats { FILE_ID FMT_NAME_ARR FMT_VAL_ARR } {
#=========================================================================
  upvar $FILE_ID file_id
  upvar $FMT_NAME_ARR fmt_name_arr
  upvar $FMT_VAL_ARR fmt_val_arr

  puts $file_id "################ FORMAT DECLARATIONS #################"
  set idxlist [array names fmt_name_arr]
  foreach idx $idxlist \
  { 
     puts $file_id "  FORMAT $fmt_name_arr($idx) $fmt_val_arr($idx)" 
  }
}

#========================================================================
proc PB_PB2DEF_write_addresses { FILE_ID ADR_NAME_ARR ADR_VAL_ARR } {
#========================================================================
  upvar $FILE_ID file_id
  upvar $ADR_NAME_ARR adr_name_arr
  upvar $ADR_VAL_ARR adr_val_arr

  puts $file_id "################ ADDRESS DECLARATIONS ################"
  set idxlist [array names adr_name_arr]

  foreach idx $idxlist \
  {
      puts $file_id "  ADDRESS $adr_name_arr($idx) "
      puts $file_id "  \{"
      set ii [llength $adr_val_arr($idx)]
      for {set jj 0} {$jj < $ii} {incr jj} \
      {
          puts $file_id "      [lindex $adr_val_arr($idx) $jj]"
      }
      puts $file_id "  \}\n"
  }
}

#========================================================================
proc PB_PB2DEF_write_block_templates { FILE_ID BLK_NAME_ARR BLK_VAL_ARR } {
#========================================================================
  upvar $FILE_ID file_id
  upvar $BLK_NAME_ARR blk_name_arr
  upvar $BLK_VAL_ARR blk_val_arr

  puts $file_id "############ BLOCK TEMPLATE DECLARATIONS #############"
  set idxlist [array names blk_name_arr]

  foreach idx $idxlist \
  {
      puts $file_id "  BLOCK_TEMPLATE $blk_name_arr($idx) "
      puts $file_id "  \{"
      set ii [llength $blk_val_arr($idx)]
      for {set jj 0} {$jj < $ii} {incr jj} \
      {
         puts $file_id "       [lindex $blk_val_arr($idx) $jj]"
      }
      puts $file_id "  \}\n"
  }
}

#============================================================================
proc PB_PB2DEF_main { PARSER_OBJ OUTPUT_DEF_FILE } {
#============================================================================
  upvar $PARSER_OBJ parser_obj
  upvar $OUTPUT_DEF_FILE def_file
  global post_object

  # Block, Address and Format object list
    set fmt_obj_list $Post::($post_object,fmt_obj_list)
    set add_obj_list $Post::($post_object,add_obj_list)
    set blk_obj_list $Post::($post_object,blk_obj_list)
    array set mom_sys_var $Post::($post_object,mom_sys_var_list)
    array set mom_kin_var_arr $Post::($post_object,mom_kin_var_list)
  
  # Listing File Objects
    set listfile_obj $Post::($post_object,list_obj_list)
    set list_addr_obj_list $ListingFile::($listfile_obj,add_obj_list)
    set list_blk_obj $ListingFile::($listfile_obj,block_obj)

  set file_list $ParseFile::($parser_obj,file_list)
  array set bef_com_data $ParseFile::($parser_obj,bef_com_data_list)
  array set aft_com_data $ParseFile::($parser_obj,aft_com_data_list)

  set file_name [lindex $file_list 0]
  set before_formatting $bef_com_data($file_name)
  set after_formatting $aft_com_data($file_name)

  set deff_id [open $def_file w+]

  foreach line $before_formatting \
  {
     puts $deff_id $line
  }
  if { [llength $before_formatting] == 0 } \
  {
     puts $deff_id "MACHINE  $mom_kin_var_arr(mom_kin_machine_type)"
  }
  puts $deff_id " "

  puts $deff_id "FORMATTING"
  puts $deff_id "\{"
  
  # Outputs the word seperator
    PB_output_GetWordSeperator $mom_sys_var(Word_Seperator) word_sep 
    puts $deff_id "  $word_sep"
 
  # Outputs the End of Block
    PB_output_GetEndOfLine $mom_sys_var(End_of_Block) endof_line 
    puts $deff_id "  $endof_line"

  # Outputs the Sequence Number
    set seq_param_arr(0) $mom_sys_var(seqnum_block)
    set seq_param_arr(1) $mom_sys_var(seqnum_start)
    set seq_param_arr(2) $mom_sys_var(seqnum_incr)
    set seq_param_arr(3) $mom_sys_var(seqnum_freq)
    PB_output_GetSequenceNumber seq_param_arr sequence_num
    puts $deff_id "  $sequence_num"
    puts $deff_id ""

  # Outputs the formats
    PB_output_GetFmtObjAttr fmt_obj_list fmt_name_arr fmt_val_arr
    PB_PB2DEF_write_formats deff_id fmt_name_arr fmt_val_arr
    unset fmt_name_arr fmt_val_arr
    puts $deff_id ""

  # Outputs the Address
    PB_output_GetAdrObjAttr add_obj_list adr_name_arr adr_val_arr
    PB_PB2DEF_write_addresses deff_id adr_name_arr adr_val_arr
    unset adr_name_arr adr_val_arr
    puts $deff_id ""

  # Outputs the Listing File Address
    PB_output_GetAdrObjAttr list_addr_obj_list adr_name_arr adr_val_arr
    PB_PB2DEF_write_addresses deff_id adr_name_arr adr_val_arr
    if {[info exists adr_name_arr]} \
    {
       unset adr_name_arr adr_val_arr
    }
    puts $deff_id ""

  # Outputs the Blocks
    PB_output_GetBlkObjAttr blk_obj_list blk_name_arr blk_val_arr
    PB_PB2DEF_write_block_templates deff_id blk_name_arr blk_val_arr
    unset blk_name_arr blk_val_arr

  # Outputs the Composite Blocks
    PB_output_GetCompositeBlks comp_blk_list

    if {[info exists comp_blk_list]} \
    {
       PB_output_GetBlkObjAttr comp_blk_list blk_name_arr blk_val_arr
       PB_PB2DEF_write_block_templates deff_id blk_name_arr blk_val_arr
       unset blk_name_arr blk_val_arr
    }

  # Outputs the Post Block
    if {[info exists Post::($post_object,post_blk_list)]} \
    {
       set post_blk_list $Post::($post_object,post_blk_list)
       PB_output_GetBlkObjAttr post_blk_list blk_name_arr blk_val_arr
       PB_PB2DEF_write_block_templates deff_id blk_name_arr blk_val_arr
       unset blk_name_arr blk_val_arr
    }

  # Outputs the Listing Block
    PB_output_GetBlkObjAttr list_blk_obj blk_name_arr blk_val_arr
    PB_PB2DEF_write_block_templates deff_id blk_name_arr blk_val_arr
    if {[info exists blk_name_arr]} \
    {
       unset blk_name_arr blk_val_arr
    }
    puts $deff_id "\}"

  foreach line $after_formatting \
  {
     puts $deff_id $line
  }
  close $deff_id
}

#=========================================================================
#                          TCL file writing modules
#=========================================================================
#============================================================================
proc PB_PB2TCL_write_sys_var_arr { TCLF_ID } {
#============================================================================
  upvar $TCLF_ID tclf_id

  # Gets all the sys variables
    PB_output_GetMomSysVars sys_name_arr sys_val_arr 

  puts $tclf_id "########## SYSTEM VARIABLE DECLARATIONS ##############"
  set idxlist [array names sys_name_arr]
  foreach idx $idxlist \
  { 
     puts $tclf_id "  set $sys_name_arr($idx) $sys_val_arr($idx)"
  }
}

#============================================================================
proc PB_PB2TCL_write_kin_var_arr { TCLF_ID } {
#============================================================================
  upvar $TCLF_ID tclf_id

  PB_output_GetMomKinVars kin_name_arr kin_val_arr
  puts $tclf_id "####### KINEMATIC VARIABLE DECLARATIONS ##############"

  set idxlist [array names kin_name_arr]
  foreach idx $idxlist \
  { 
     puts $tclf_id "  set $kin_name_arr($idx) $kin_val_arr($idx)" 
  }
}

#==========================================================================
proc MY_PB_output_GetMomFlyVars {fly_name_arr fly_val_arr} {
#==========================================================================
  upvar $fly_name_arr name $fly_val_arr val

  set name(0)  "mom_fly_G_codes_per_block"             
  set val(0) 1
  set name(1)  "mom_fly_M_codes_per_block" 
  set val(1) 1 
  set name(2)  "mom_fly_use_rapid_at_max_fpm" 
  set val(2)  TRUE 
  set name(3)  "mom_fly_work_plane_change"
  set val(3)  TRUE 
  set name(4)  "mom_fly_spindle_axis"  
  set val(4) Z
  set name(5)  "mom_fly_cutcom_off_before_change" 
  set val(5) TRUE 
}

#======================================================================
proc PB2TCL_read_fly_var {fly_name} {
#======================================================================
# get fly variables; hardcoded in MY_PB_output_GetMomFlyVars
  set fly_val ""

  MY_PB_output_GetMomFlyVars fly_name_arr fly_val_arr
  set idxlist [array names fly_name_arr]
  foreach idx $idxlist \
  {
    if {$fly_name_arr($idx) == "$fly_name"} \
    {
       set fly_val "$fly_val_arr($idx)" 
       break
    }
  }
  return $fly_val
}

#=====================================================================
proc PB_output_CycleSet { TCLF_ID } {
#=====================================================================
  upvar $TCLF_ID tclf_id
  puts $tclf_id "#============================================================="
  puts $tclf_id "proc CYCLE_set \{ \} \{"
  puts $tclf_id "#============================================================="
  puts $tclf_id "     global cycle_name mom_spindle_axis"

  switch [PB2TCL_read_fly_var mom_fly_spindle_axis] \
  {

     "X"      {set spindle_axis 0} 
     "Y"      {set spindle_axis 1} 
     default  {set spindle_axis 2}
  }
  puts $tclf_id "     if \{ \[info exists mom_spindle_axis \] == 0\} \{"
  puts $tclf_id "        set mom_spindle_axis $spindle_axis"
  puts $tclf_id "     \}"
  puts $tclf_id "     MOM_force once G_motion X Y Z R"
  puts $tclf_id "     if \{ \[string first DWELL \$cycle_name\] != -1 \} \{"
  puts $tclf_id "        MOM_force once cycle_dwell \}"
  puts $tclf_id "     if \{ \[string first NODRAG \$cycle_name\] != -1 \} \{"
  puts $tclf_id "       MOM_force once cycle_nodrag \}"
  puts $tclf_id "     if \{ \[string first DEEP \$cycle_name\]!= -1 \} \{"
  puts $tclf_id "       MOM_force once cycle_step \}"
  puts $tclf_id "     if \{ \[string first BREAK_CHIP \$cycle_name\] \
                                            != -1 \} \{"
  puts $tclf_id "       MOM_force once cycle_step"
  puts $tclf_id "     \}"
  puts $tclf_id "\n\}"
}

#=====================================================================
proc PB_output_CircleSet { TCLF_ID } {
#=====================================================================
  upvar $TCLF_ID tclf_id

  puts $tclf_id "\n"
  puts $tclf_id "#============================================================="
  puts $tclf_id "proc CIRCLE_set \{ \} \{"
  puts $tclf_id "#============================================================="
  puts $tclf_id "     global mom_pos_arc_plane"
  puts $tclf_id "     MOM_suppress off I J K"
  puts $tclf_id "     switch \$mom_pos_arc_plane \{"
  puts $tclf_id "       XY \{ MOM_suppress always K \}"
  puts $tclf_id "       YZ \{ MOM_suppress always I \}"
  puts $tclf_id "       ZX \{ MOM_suppress always J \}"
  puts $tclf_id "     \}"
  puts $tclf_id "\}"

}

#=====================================================================
proc PB_output_CoolantSet { TCLF_ID } {
#=====================================================================
  upvar $TCLF_ID tclf_id

  puts $tclf_id "\n"
  puts $tclf_id "#============================================================="
  puts $tclf_id "proc COOLANT_set \{ \} \{"
  puts $tclf_id "#============================================================="
  puts $tclf_id "     global mom_coolant_status mom_coolant_mode"
  puts $tclf_id "     if \{ \$mom_coolant_status != \"OFF\" \} \\"
  puts $tclf_id "     \{" 
  puts $tclf_id "         set mom_coolant_status ON "
  puts $tclf_id "     \}"
  puts $tclf_id "      if \{ \$mom_coolant_status == \"ON\" \} \\"
  puts $tclf_id "      \{"
  puts $tclf_id "          if \{ \$mom_coolant_mode != \"\" \} \\"
  puts $tclf_id "          \{"
  puts $tclf_id "               set mom_coolant_status \$mom_coolant_mode "
  puts $tclf_id "          \}"
  puts $tclf_id "      \}"
  puts $tclf_id "\}"
}

#=====================================================================
proc PB_output_CutcomSet { TCLF_ID } {
#=====================================================================
  upvar $TCLF_ID tclf_id

  puts $tclf_id "\n"
  puts $tclf_id "#============================================================="
  puts $tclf_id "proc CUTCOM_set \{ \} \{"
  puts $tclf_id "#============================================================="
  puts $tclf_id "     global mom_cutcom_status mom_cutcom_mode"
  puts $tclf_id "     if \{ \$mom_cutcom_status != \"OFF\" \} \\"
  puts $tclf_id "     \{"
  puts $tclf_id "          set mom_cutcom_status ON"
  puts $tclf_id "     \} "
  puts $tclf_id "     if \{ \$mom_cutcom_status == \"ON\" \} \\"
  puts $tclf_id "     \{"
  puts $tclf_id "          if \{ \$mom_cutcom_mode != \"\" \} \\"
  puts $tclf_id "          \{"
  puts $tclf_id "              set mom_cutcom_status \$mom_cutcom_mode"
  puts $tclf_id "          \}"
  puts $tclf_id "     \}"
  puts $tclf_id "\}"
}

#=====================================================================
proc PB_output_SpindleSet { TCLF_ID } {
#=====================================================================
  upvar $TCLF_ID tclf_id

  puts $tclf_id "\n"
  puts $tclf_id "#============================================================="
  puts $tclf_id "proc SPINDLE_set \{ \} \{"
  puts $tclf_id "#============================================================="
  puts $tclf_id "     global mom_spindle_status mom_spindle_mode"
  puts $tclf_id "     if \{ \$mom_spindle_status != \"OFF\" \} \\"
  puts $tclf_id "     \{"
  puts $tclf_id "          set mom_spindle_status ON"
  puts $tclf_id "     \}"  

  puts $tclf_id "     if \{ \$mom_spindle_status == \"ON\" \} \\"
  puts $tclf_id "     \{"
  puts $tclf_id "          if \{ \$mom_spindle_mode != \"\" \} \\"
  puts $tclf_id "          \{"
  puts $tclf_id "               set mom_spindle_status \$mom_spindle_mode"
  puts $tclf_id "          \}"
  puts $tclf_id "     \}"
  puts $tclf_id "\}"
}

#=====================================================================
proc PB_output_OpskipSet { TCLF_ID } {
#=====================================================================
  upvar $TCLF_ID tclf_id

  puts $tclf_id "\n"
  puts $tclf_id "#============================================================="
  puts $tclf_id "proc OPSKIP_set \{ \} \{"
  puts $tclf_id "#============================================================="
  puts $tclf_id "     global mom_opskip_status mom_sys_opskip_code"
  puts $tclf_id "     switch \$mom_opskip_status \\"
  puts $tclf_id "     \{"
  puts $tclf_id "         ON      \{ "
  puts $tclf_id "                       MOM_set_line_leader always \
                                                        \$mom_sys_opskip_code"
  puts $tclf_id "                 \}"
  puts $tclf_id "        default  \{"
  puts $tclf_id "                       MOM_set_line_leader off \
                                                        \$mom_sys_opskip_code"
  puts $tclf_id "                  \}"
  puts $tclf_id "     \}"
  puts $tclf_id "\}"
}

#=====================================================================
proc PB_output_RapidSet { TCLF_ID } {
#=====================================================================
  upvar $TCLF_ID tclf_id

  puts $tclf_id "\n"
  puts $tclf_id "#============================================================="
  puts $tclf_id "proc RAPID_set \{ \} \{"
  puts $tclf_id "#============================================================="
  puts $tclf_id "     global mom_spindle_axis "
  puts $tclf_id "     global mom_pos mom_last_z_pos "
  puts $tclf_id "     global spindle_first"

  if {[PB2TCL_read_fly_var mom_fly_work_plane_change] == "TRUE"} \
  {
    switch [PB2TCL_read_fly_var mom_fly_spindle_axis] \
    {
        "X"     {set spindle_axis 0} 
        "Y"     {set spindle_axis 1} 
        default {set spindle_axis 2}
    }
    puts $tclf_id "     if \{ \[info exists mom_spindle_axis\] == 0\} \\"
    puts $tclf_id "     \{"
    puts $tclf_id "          set mom_spindle_axis $spindle_axis"
    puts $tclf_id "     \}"
    puts $tclf_id "     if \{ \$mom_pos(\$mom_spindle_axis) > \
                                                \$mom_last_z_pos\}\\"
    puts $tclf_id "     \{"
    puts $tclf_id "          set spindle_first TRUE"
    puts $tclf_id "     \} else \\"
    puts $tclf_id "     \{"
    puts $tclf_id "          set spindle_first FALSE"
    puts $tclf_id "     \}"
  } else {
    puts $tclf_id "     set spindle_first NONE"
  }
  puts $tclf_id "\}"
}

#=====================================================================
proc PB_output_SeqnoSet { TCLF_ID } {
#=====================================================================
  upvar $TCLF_ID tclf_id

  puts $tclf_id "\n"
  puts $tclf_id "#============================================================="
  puts $tclf_id "proc SEQNO_set \{ \} \{"
  puts $tclf_id "#============================================================="
  puts $tclf_id "     global mom_sequence_mode mom_sequence_number"
  puts $tclf_id "     global mom_sequence_increment mom_sequence_frequency"

  puts $tclf_id "     if \{ \[info exists mom_sequence_mode\] \} \\"
  puts $tclf_id "     \{"
  puts $tclf_id "        switch \$mom_sequence_mode \\"
  puts $tclf_id "        \{"
  puts $tclf_id "              OFF  \{"
  puts $tclf_id "                       MOM_set_seq_off"
  puts $tclf_id "                   \}" 
  puts $tclf_id "              ON   \{"
  puts $tclf_id "                       MOM_set_seq_on"
  puts $tclf_id "                   \}" 
  puts $tclf_id "           default \{"
  puts $tclf_id "                       MOM_output_literal \"error: \
                                        mom_sequence_mode unknown\" "
  puts $tclf_id "                   \}"
  puts $tclf_id "        \}"
  puts $tclf_id "     \} else \\"
  puts $tclf_id "     \{"
  puts $tclf_id "         MOM_reset_sequence \$mom_sequence_number \\"
  puts $tclf_id "             \$mom_sequence_increment \$mom_sequence_frequency"
  puts $tclf_id "     \}"
  puts $tclf_id "\}"
}

#=====================================================================
proc PB_output_ModeSet { TCLF_ID } {
#=====================================================================
  upvar $TCLF_ID tclf_id

  puts $tclf_id "\n"
  puts $tclf_id "#============================================================="
  puts $tclf_id "proc MODES_set \{ \} \{"
  puts $tclf_id "#============================================================="
  puts $tclf_id "     global mom_output_mode"
  puts $tclf_id "     switch \$mom_output_mode \\"
  puts $tclf_id "     \{ "
  puts $tclf_id "          ABSOLUTE \{"
  puts $tclf_id "                       set isincr OFF"
  puts $tclf_id "                   \}"
  puts $tclf_id "          default  \{"
  puts $tclf_id "                       set isincr ON"
  puts $tclf_id "                   \}"
  puts $tclf_id "     \}"
  puts $tclf_id "     MOM_incremental \$isincr X Y Z"
  puts $tclf_id "\}"
}

#=====================================================================
proc PB_PB2TCL_write_tcl_procs { TCLF_ID } {
#=====================================================================
  upvar $TCLF_ID tclf_id

  puts $tclf_id "############## EVENT HANDLING SECTION ################"

  # outputs all the general procedures
    PB_output_CycleSet  tclf_id 
    PB_output_CircleSet tclf_id 
    PB_output_CoolantSet tclf_id 
    PB_output_CutcomSet tclf_id 
    PB_output_SpindleSet  tclf_id 
    PB_output_OpskipSet  tclf_id 
    PB_output_RapidSet  tclf_id 
    PB_output_SeqnoSet  tclf_id 
    PB_output_ModeSet  tclf_id 

  # get event attributes for writing event procs; 
  # hardcoded in MY_PB_output_GetEvtObjAttr"
    PB_output_GetEvtObjAttr evt_name_list evt_blk_arr

  # Gets event variables & modality of block addresses
    PB_output_RetBlksModality blk_mod_arr
    PB_output_GetEventsVariables event_var_arr event_value_arr

  foreach event_name $evt_name_list \
  { 
     PB_output_GetEventProcData event_name evt_blk_arr($event_name) \
                                event_output
     PB_PB2TCL_write_event_procs tclf_id event_output
     unset event_output
  }
}

#===============================================================================
proc PB_PB2TCL_write_event_procs { TCLF_ID EVENT_OUTPUT } {
#===============================================================================
  upvar $TCLF_ID tclf_id
  upvar $EVENT_OUTPUT event_output

  foreach line $event_output \
  {
    puts $tclf_id "$line"
  }
}

#===============================================================================
proc PB_output_DefaultDataAEvent { EVT_NAME EVENT_OUTPUT } {
#===============================================================================
  upvar $EVENT_OUTPUT event_output
  upvar $EVT_NAME evt_name

  switch $evt_name \
  {
    MOM_drill_text          -
    MOM_drill               -
    MOM_drill_dwell         -
    MOM_drill_counter_sink  -
    MOM_drill_csink_dwell   -
    MOM_drill_deep          -
    MOM_drill_break_chip    -
    MOM_tap                 -
    MOM_bore                -
    MOM_bore_dwell          -
    MOM_bore_drag           -
    MOM_bore_no_drag        -
    MOM_bore_back           -
    MOM_bore_manual         -
    MOM_bore_manual_dwell  { lappend event_output "     global cycle_name"
                             append event_move $evt_name _move
                             set cycle_name [string toupper \
                                           [string trimleft $evt_name MOM_]]
                             lappend event_output "     set cycle_name $cycle_name"
                             lappend event_output "     CYCLE_set"
                             lappend event_output "\}"
                             lappend event_output "\n"
                             lappend event_output "#============================================================="
                             lappend event_output "proc  $event_move \{ \} \{"
                             lappend event_output "#============================================================="
                             unset event_move
                           }
    MOM_circular_move      {
                             lappend event_output "    CIRCLE_set"
                           }
    MOM_initial_move       { lappend event_output "     global mom_feed_rate "
                             lappend event_output "     global mom_feed_rate_per_rev"
                             lappend event_output "     global mom_kin_max_fpm"
                             lappend event_output "     global mom_motion_type "
                             lappend event_output "     global in_sequence "
                             lappend event_output "     set in_sequence none"
                             lappend event_output "     MOM_force once G_motion X Y Z"
                           }
    MOM_linear_move        { lappend event_output "     global mom_feed_rate "
                             lappend event_output "     global mom_feed_rate_per_rev"
                             lappend event_output "     global mom_kin_max_fpm"
                             if {[PB2TCL_read_fly_var \
                                  mom_fly_use_rapid_at_max_fpm] == "TRUE"} \
                             {
                                lappend event_output "     if \{ \$mom_feed_rate >= \
                                                         \$mom_kin_max_fpm \} \\"
                                lappend event_output "     \{"
                                lappend event_output "         MOM_rapid_move "
                                lappend event_output "         return"
                                lappend event_output "     \}"
                             }
                           }
    MOM_coolant_on         -
    MOM_cutcom_on          -
    MOM_spindle_rpm        -
    MOM_spindle_css        { lappend event_output "     global in_sequence"
                             switch $evt_name {
                               MOM_spindle_rpm  -
                               MOM_spindle_css  {lappend event_output "     \
                                                                   SPINDLE_set"}
                             }
                           }
    MOM_tool_change        {
                             lappend event_output "     global in_sequence"
                           }
    MOM_opskip             {lappend event_output "     OPSKIP_set"}
    MOM_rapid_move         {lappend event_output "     global spindle_first"
                            lappend event_output "     RAPID_set"
                           }
    MOM_sequence_number    {lappend event_output "     SEQNO_set"}
    MOM_set_modes          {lappend event_output "     MODES_set"}
    MOM_start_of_program   {lappend event_output "     global in_sequence"
                            lappend event_output "     global mom_logname"
                            lappend event_output "     global mom_date"
                            lappend event_output "     set in_sequence \
                                                               start_of_program"
                            lappend event_output "#*** The following procedure \
                                       opens the warning and listing files"
                            lappend event_output "     OPEN_files"
                            lappend event_output "#*** The following procedure \
                                 lists the header information in commentary dat"
                            lappend event_output "     LIST_FILE_HEADER"
                            lappend event_output "     MOM_output_literal \
                            \"(############################################)\""
                            lappend event_output "     MOM_output_literal \"(# Created By   : \
                                                \$mom_logname) \""
                            lappend event_output "     MOM_output_literal \"(# Creation Date: \
                                                \$mom_date)\""
                            lappend event_output "     MOM_output_literal \
                            \"(############################################)\""
                           }
    MOM_start_of_path      {lappend event_output "     global in_sequence "
                            lappend event_output "     set in_sequence start_of_path"
                           }
  }

  switch $evt_name \
  {
    MOM_coolant_on      -
    MOM_coolant_off     {
                           lappend event_output "     COOLANT_set"
                        }
    MOM_cutcom_on       {
                          if {[PB2TCL_read_fly_var \
                                mom_fly_cutcom_off_before_change] == "TRUE"} {
                            lappend event_output "     global mom_cutcom_status"
                            lappend event_output "     if \{ \$mom_cutcom_status != \"SAME\"\} \\"
                            lappend event_output "     \{"
                            lappend event_output "         global mom_sys_cutcom_code"
                            lappend event_output "         MOM_output_literal \
                                                        \$mom_sys_cutcom_code(OFF) "
                            lappend event_output "     \}"
                          }
                          lappend event_output "     CUTCOM_set"
                        }
  }
}

#===============================================================================
proc PB_output_BlockOfAEvent { EVT_NAME STMT EVENT_OUTPUT jj } {
#===============================================================================
  upvar $EVT_NAME evt_name
  upvar $STMT stmt
  upvar $EVENT_OUTPUT event_output

  # 1=uppercase found: a proc name, else block template name
   set isupper [regexp {^[A-Z]+} $stmt] ;
   switch $isupper \
   {
      1       {"    $stmt"}
      default \
      {
        switch $evt_name \
        {
          MOM_coolant_on         -
          MOM_cutcom_on          -
          MOM_spindle_rpm        -
          MOM_tool_change        -
          MOM_spindle_css    {
                               switch $jj \
                               {
                                  0 {lappend event_output "     if \{ \$in_sequence \
                                         != \"none\" \} \{ \
                                       MOM_do_template $stmt \}"}
                                  1 {lappend event_output "     if \{ \$in_sequence \
                                         == \"none\" \} \{\
                                       MOM_do_template $stmt \}"}
                               }
                             }
          MOM_rapid_move     {
                               #  set template($icnt) $stmt
                               # incr icnt
                             }
         MOM_start_of_program  {

                                 if {$stmt == "literal4"} {lappend event_output "     \
                                           MOM_suppress once N"}
                                 lappend event_output "     MOM_do_template $stmt"
                               }
        MOM_initial_move     {
                               if {$stmt == "spindle_start"} {
                                   lappend event_output "     MOM_force once G_motion \
                                           X Y Z G M_spin M_cool S T H"}
                                   lappend event_output "     MOM_do_template $stmt"
                             }
        default              {lappend event_output "     MOM_do_template $stmt"}
      }
    }
  }
}

#===============================================================================
proc PB_output_GetEventProcData { EVT_NAME EVT_VAL EVENT_OUTPUT } {
#===============================================================================
  upvar $EVT_NAME evt_name
  upvar $EVT_VAL evt_val
  upvar $EVENT_OUTPUT event_output

  lappend event_output "\n"
  lappend event_output "#============================================================="
  lappend event_output "proc $evt_name \{ \} \{"
  lappend event_output "#============================================================="

  # Outputs the default data of a event
    PB_output_DefaultDataAEvent evt_name event_output

  set no_of_lists [llength $evt_val]
  for {set jj 0} {$jj < $no_of_lists} {incr jj} \
  {
     set sublist [lindex $evt_val $jj]
     set ii [llength $sublist]
     set stmt [lindex $sublist 0]

     if {$stmt == "MOM_force" || $stmt == "MOM_suppress"} \
     {
        lappend event_output "       $sublist"
     } else \
     {
        for {set kk 0} {$kk < $ii} {incr kk} \
        {
          set stmt [lindex $sublist $kk]
          PB_output_BlockOfAEvent evt_name stmt event_output $jj
        }
     }
  }

  switch $evt_name \
  {
    MOM_rapid_move   {
                       set blk_name_list [lindex $evt_val 0]
                       if {[llength $blk_name_list] == 1} \
                       {
                          lappend event_output "     MOM_do_template \
                                                     [lindex $blk_name_list 0]"
                       } else {
                          lappend event_output "     if \{ \$spindle_first == \
                                                     \"TRUE\" \} \\"
                          lappend event_output "     \{"
                          lappend event_output "          MOM_do_template \
                                                     [lindex $blk_name_list 0]"
                          lappend event_output "          MOM_do_template \
                                                     [lindex $blk_name_list 1]"
                          lappend event_output "     \} elseif \{ \
                                              \$spindle_first == \"FALSE\"\}\\"
                          lappend event_output "      \{"
                          lappend event_output "          MOM_do_template \
                                                     [lindex $blk_name_list 0]"
                          lappend event_output "          MOM_do_template \
                                                     [lindex $blk_name_list 1]"
                          lappend event_output "     \} else \\"
                          lappend event_output "     \{ "
                          lappend event_output "          MOM_do_template\
                                                      [lindex $blk_name_list 0]"
                          lappend event_output "      \}"
                       }
                   }
  MOM_initial_move {
                      if {[PB2TCL_read_fly_var mom_fly_use_rapid_at_max_fpm] \
                                     == "TRUE"} {
                         lappend event_output "     if \{ \$mom_feed_rate >= \
                                                   \$mom_kin_max_fpm \} \\"
                         lappend event_output "     \{"
                         lappend event_output "         MOM_rapid_move"
                         lappend event_output "         return"
                         lappend event_output "     \}"
                      }
                      lappend event_output "     if \{ \$mom_motion_type == \
                                              \"RAPID\" \} \\"
                      lappend event_output "     \{"
                      lappend event_output "         MOM_rapid_move "
                      lappend event_output "     \} else \\"
                      lappend event_output "     \{"
                      lappend event_output "         MOM_linear_move "
                      lappend event_output "     \}"
                   }
  MOM_end_of_program {
                       lappend event_output "#**** The following procedure \
                            lists the tool list with time in commentary data"
                       lappend event_output "     LIST_FILE_TRAILER"
                       lappend event_output "#**** The following procedure \
                                    closes the warning and listing files"     
                       lappend event_output "     CLOSE_files"
                   }
 }
 lappend event_output "\}"
}

#============================================================================
proc PB_PB2TCL_main { OUTPUT_TCL_FILE } {
#============================================================================
  upvar $OUTPUT_TCL_FILE tcl_file
  global log_data

  set tclf_id [open $tcl_file w] 

  puts $tclf_id "############ TCL FILE ######################################"
  puts $tclf_id "# USER AND DATE STAMP"
  puts $tclf_id "############################################################"
  puts $tclf_id ""
  puts $tclf_id "  set cam_post_dir \[MOM_ask_env_var UGII_CAM_POST_DIR\]"
  puts $tclf_id "# source \${cam_post_dir}mom_debug.tcl"
  puts $tclf_id "# source \${cam_post_dir}mom_review.tcl"
  puts $tclf_id "# MOM_set_debug_mode ON"
  puts $tclf_id "  source \${cam_post_dir}ugpost_base.tcl"
  puts $tclf_id ""

  PB_PB2TCL_write_sys_var_arr tclf_id

  puts $tclf_id ""

  PB_PB2TCL_write_kin_var_arr tclf_id

  puts $tclf_id ""

  puts $tclf_id ""

  PB_PB2TCL_write_tcl_procs tclf_id

  close $tclf_id
}
