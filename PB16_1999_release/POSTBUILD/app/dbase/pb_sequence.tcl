##############################################################################
# Description                                                                #
#     This file contains all functions dealing with the SEQUENCE Object.     #
# There are five sequences, events for each of the sequences are created     #
# from the data defined in the PUI file.                                     #
#                                                                            #
# Revisions                                                                  #
#                                                                            #
#   Date        Who   Reason                                                 #
# 01-feb-1999   bmp   Initial                                                #
# 02-Jun-1999   mnb   Code Integration                                       #
#                                                                            #
# $HISTORY$                                                                  #
#                                                                            #
##############################################################################

#=============================================================================
#The input to the function is the post object. The data read from the PUI 
#file is read and sequences are created. After the sequences are created the
#corresponding events for each of the sequences are made. These events carry
#the information regarding the specific blocks of the events.
#=============================================================================

proc PB_seq_CreateSequences {POST_OBJ} {
  upvar $POST_OBJ post_obj

  #Initialize the sequence object list.
  set seq_obj_list ""

  #sets the extension for event list and event block list (Name fixed in PUI).
  set evt_list_ext "_evt_list"
  set evt_blk_list_ext "_evt_blk_list"

  #sets the sequence index.
  set ind 0

  #sets the sequence name list first part.
  set seq_name_list {prog_start oper_start tpth_ctrl \
                     tpth_mot tpth_cycle oper_end prog_end}

  #sets the sequence names.
  set seq_names {"Program Start Sequence" "Operation Start Sequence" \
                 "Machine Control" "Motions" "Cycles" \
                 "Operation End Sequence" "Program End Sequence"}
  
  #Creates Sequence events for each of the sequence.
  foreach sequence $seq_name_list\
  {
     #Initialize the event object list.
     set evt_obj_list ""

     #sets the event list name and event block list name (Name set in PUI).
     set evt_list_name $sequence$evt_list_ext
     set evt_blk_list_name $sequence$evt_blk_list_ext

     #Creates sequence events.
     PB_evt_CreateSeqEvents post_obj evt_obj_list evt_list_name \
                            evt_blk_list_name sequence

     # returns the combo box elements of a sequence
     PB_seq_RetSeqCombElems comb_elem_list

     #sets the sequence object attributes.
     set seq_obj_attr(0) [lindex $seq_names $ind]
     set seq_obj_attr(1) $evt_obj_list
     set seq_obj_attr(2) $comb_elem_list
     
     #Creates the sequence object.
     PB_seq_CreateSeqObj seq_obj_attr seq_obj_list
     incr ind
  }

  #Sets the sequence object list as post object attribute.
  set Post::($post_obj,seq_obj_list) $seq_obj_list

}

#===============================================================================
#This function takes the object attributes and the updated SEQUENCE object list
#as the input, creates the SEQUENCE Object and returns the updated object list.
#===============================================================================

proc PB_seq_CreateSeqObj {OBJ_ATTR OBJ_LIST} {
  upvar $OBJ_ATTR obj_attr
  upvar $OBJ_LIST obj_list

  #Creates new object.
  set object [new sequence]

  #Appends object id to the object list.
  lappend obj_list $object

  #sets the latest value to the object created.
  sequence::setvalue $object obj_attr
  sequence::DefaultValue $object obj_attr
}

#===============================================================================
#This function takes the sequence object and the block object list as input
#and outputs the event object list. 
#===============================================================================

proc PB_seq_RetSeqEvtBlkObj { SEQ_OBJ EVT_OBJ_LIST } {
  upvar $SEQ_OBJ seq_obj
  upvar $EVT_OBJ_LIST evt_obj_list

  #Sets the event object list from the sequence object.
   set evt_obj_list $sequence::($seq_obj,evt_obj_list)
}

#===============================================================================
#This function takes block object list as input and outputs the combo 
#box element list. 
#===============================================================================

proc PB_seq_RetSeqCombElems { COMB_ELEM_LIST } {
  upvar $COMB_ELEM_LIST comb_elem_list
  global post_object

  #Unsets the list if already exists.
  if {[info exists comb_elem_list]}\
  {
     unset comb_elem_list
  }

  set blk_obj_list $Post::($post_object,blk_obj_list)

  #Creates combo box element list.
  foreach blk_obj $blk_obj_list\
  {
     set blk_name $block::($blk_obj,block_name)
     PB_com_GetModEvtBlkName blk_name
     lappend comb_elem_list $blk_name
  }
}
