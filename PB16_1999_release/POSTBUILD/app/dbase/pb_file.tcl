##############################################################################
# Description                                                                #
#     This file contains all the api functions, which wiil be used for       #
#     getting the data of the database objects.                              #
#                                                                            #
# Revisions                                                                  #
#                                                                            #
#   Date        Who   Reason                                                 #
# 01-feb-1999   bmp   Initial                                                #
# 07-Apr-1999   mnb   Added env. variable                                    #
# 10-Apr-1999   gsl   Encapsulated main procedure into PB_Start.             #
# 05-May-1999   mnb   Added a procedure, to output tcl def and pui files     #
# 02-Jun-1999   mnb   Code Integration                                       #
# 16-Jun-1999   mnb   stores mom_sys_arr in post object                      #
# 23-Jun-1999   mnb   Corrected format                                       #
# 08-Jul-1999   mnb   Added a procedure to create new blk element from       #
#                     Current blk element                                    #
# 07-Sep-1999   mnb   Added proceduers to update the database                #
# 21-Sep-1999   mnb   Added APIs for creating, Cutting & Deleting an address #
#                     object from database                                   #
# 13-Oct-1999   mnb   Added few more API's                                   #
# 17-Nov-1999   gsl   Submitted for phase-22.                                #
#                                                                            #
# $HISTORY$                                                                  #
#                                                                            #
##############################################################################
global env

if {[catch {package require stooop 3.0}]} {
    # in case stooop package is not installed
    source $env(PB_HOME)/tcl/exe/stooop.tcl
}

namespace import stooop::*

source $env(PB_DIR)/dbase/pb_class.tcl
source $env(PB_DIR)/dbase/pb_method.tcl
source $env(PB_DIR)/dbase/pb_common.tcl
source $env(PB_DIR)/dbase/pb_format.tcl
source $env(PB_DIR)/dbase/pb_address.tcl
source $env(PB_DIR)/dbase/pb_block.tcl
source $env(PB_DIR)/dbase/pb_list.tcl
source $env(PB_DIR)/dbase/pb_pui_parser.tcl
source $env(PB_DIR)/dbase/pb_machine.tcl
source $env(PB_DIR)/dbase/pb_event.tcl
source $env(PB_DIR)/dbase/pb_sequence.tcl
source $env(PB_DIR)/dbase/pb_ude.tcl
source $env(PB_DIR)/dbase/pb_output.tcl

#=====================================================================
proc PB_int_FormatCreateObject { ACT_FMT_OBJ FormatObjAttr OBJ_INDEX} {
#=====================================================================
  upvar $ACT_FMT_OBJ act_fmt_obj
  upvar $FormatObjAttr obj_attr
  upvar $OBJ_INDEX obj_index
  global post_object

  PB_fmt_RetFormatObjs fmt_obj_list
  set obj_index [lsearch $fmt_obj_list $act_fmt_obj]

  PB_fmt_GetFmtNameList fmt_obj_list fmt_name_list
  PB_com_SetDefaultName fmt_name_list obj_attr
  PB_fmt_CreateNewFmtObj fmt_obj_list obj_attr obj_index
  set Post::($post_object,fmt_obj_list) $fmt_obj_list
}

#==================================================================
proc PB_int_BlockCreateObject { ACT_BLK_OBJ OBJ_INDEX } {
#==================================================================
  upvar $ACT_BLK_OBJ act_blk_obj
  upvar $OBJ_INDEX obj_index
  global post_object

  set blk_obj_list $Post::($post_object,blk_obj_list)
  set obj_index [lsearch $blk_obj_list $act_blk_obj]

  # Sets the object index for the new object. if the index is null,
  # sets to zero.
    if {$obj_index == ""}\
    {
       set obj_index 0
    } else\
    {
       incr obj_index
    }

  PB_blk_CreateBlkFromBlkObj blk_obj_list act_blk_obj obj_index
  set Post::($post_object,blk_obj_list) $blk_obj_list
}

#==================================================================
proc PB_int_CreateNewEventElement { BLOCK_OBJ ELEM_TYPE EVT_ELEM_OBJ } { 
#==================================================================
  upvar $BLOCK_OBJ block_obj
  upvar $ELEM_TYPE elem_type
  upvar $EVT_ELEM_OBJ evt_elem_obj

  set elem_obj_attr(0) $block::($block_obj,block_name)
  set elem_obj_attr(1) $block_obj
  set elem_obj_attr(2) $elem_type

  PB_evt_CreateEventElement evt_elem_obj elem_obj_attr
  unset elem_obj_attr
}

#==================================================================
proc PB_int_CreateNewBlock { BLOCK_NAME BLK_ELEM_LIST BLK_OWNER \
                             BLK_OBJ } {
#==================================================================
  upvar $BLOCK_NAME block_name
  upvar $BLK_ELEM_LIST blk_elem_list
  upvar $BLK_OWNER blk_owner
  upvar $BLK_OBJ blk_obj
  global post_object

  set blk_obj_attr(0) $block_name
  set blk_obj_attr(1) [llength $blk_elem_list]
  set blk_obj_attr(2) $blk_elem_list

  PB_blk_CreateBlkObj blk_obj_attr blk_obj
  unset blk_obj_attr

  set block::($blk_obj,blk_owner) $blk_owner
  lappend Post::($post_object,blk_obj_list) $blk_obj
}

#==============================================================
proc PB_int_RemoveBlkObjFrmList { BLOCK_OBJ } {
#==============================================================
  upvar $BLOCK_OBJ block_obj
  global post_object
  set index [lsearch $Post::($post_object,blk_obj_list) $block_obj]

  if {$index != -1} \
  {
     set Post::($post_object,blk_obj_list) \
         [lreplace $Post::($post_object,blk_obj_list) $index $index]
  }
}

#==================================================================
proc PB_int_GetAllBlockNames { BLOCK_NAME_LIST } {
#==================================================================
  upvar $BLOCK_NAME_LIST block_name_list
  global post_object

  set blk_obj_list $Post::($post_object,blk_obj_list)
  PB_blk_GetBlockNames blk_obj_list block_name_list
}

#==================================================================
proc PB_int_DisplayFormatValue {FMT_NAME ADD_NAME INP_VALUE DIS_VALUE} {
#==================================================================
  upvar $FMT_NAME fmt_name
  upvar $ADD_NAME add_name
  upvar $INP_VALUE inp_value
  upvar $DIS_VALUE dis_value
  
  global post_object

  set add_obj_list $Post::($post_object,add_obj_list)
  PB_com_RetObjFrmName add_name add_obj_list add_obj
  set add_rep_mom_var $address::($add_obj,rep_mom_var)
  PB_com_MapMOMVariable add_obj add_rep_mom_var app_text

  set fmt_obj_list $Post::($post_object,fmt_obj_list)
  PB_com_RetObjFrmName fmt_name fmt_obj_list fmt_obj

  format::readvalue $fmt_obj for_obj_attr
  PB_int_ReturnInputValue app_text for_obj_attr(1) inp_value
  PB_fmt_RetFmtOptVal for_obj_attr inp_value dis_value
}

#=============================================================
proc PB_int_ApplyFormatAppText { ADD_OBJ APP_TEXT } {
#=============================================================
  upvar $ADD_OBJ add_obj
  upvar $APP_TEXT app_text
  global post_object

  if {[string length $app_text] > 0 && \
      [tixGetInt -nocomplain $app_text] != 0 || $app_text == 0} \
  {
    set fmt_obj $address::($add_obj,add_format)
    format::readvalue $fmt_obj fmt_obj_attr
    PB_fmt_RetFmtOptVal fmt_obj_attr app_text dis_value
    set app_text $dis_value
  }
}

#=============================================================
proc PB_int_FormatCutObject { ACTIVE_FMT_OBJ OBJ_INDEX } {
#=============================================================
  upvar $ACTIVE_FMT_OBJ active_fmt_obj
  upvar $OBJ_INDEX obj_index
  global post_object

  set fmt_obj_list $Post::($post_object,fmt_obj_list)
  set fmt_obj_list [lreplace $fmt_obj_list $obj_index $obj_index]
  set Post::($post_object,fmt_obj_list) $fmt_obj_list

  if { $obj_index == [llength $fmt_obj_list]} \
  {
     incr obj_index -1
  }
}

#===================================================================
proc PB_int_BlockCutObject { ACTIVE_BLK_OBJ OBJ_INDEX } {
#===================================================================
  upvar $ACTIVE_BLK_OBJ active_blk_obj
  upvar $OBJ_INDEX obj_index
  global post_object

  set blk_obj_list $Post::($post_object,blk_obj_list)
  set blk_obj_list [lreplace $blk_obj_list $obj_index $obj_index]
  set Post::($post_object,blk_obj_list) $blk_obj_list

  if { $obj_index == [llength $blk_obj_list]} \
  {
     incr obj_index -1
  }
}

#===================================================================
proc PB_int_BlockPasteObject { BUFF_BLK_OBJ OBJ_INDEX } {
#===================================================================
  upvar $BUFF_BLK_OBJ buff_blk_obj
  upvar $OBJ_INDEX obj_index
  global post_object

  set blk_obj_list $Post::($post_object,blk_obj_list)
  set count [llength $blk_obj_list]
  if { $count } \
  {
     set block_name $block::($buff_blk_obj,block_name)
     PB_com_RetObjFrmName block_name blk_obj_list ret_code
     if {$ret_code}\
     {
        # PoP-Up Message
          tk_messageBox -type ok -icon error\
          -message "Object Name Exists...Paste Invalid"
          return
     }
  }

  # Sets the object index for the new object. if the index is null,
  # sets to zero.
    if {$obj_index == ""}\
    {
       set obj_index 0
    } else\
    {
       incr obj_index
    }

  PB_blk_CreateBlkFromBlkObj blk_obj_list buff_blk_obj obj_index
  set Post::($post_object,blk_obj_list) $blk_obj_list
}

#===================================================================
proc PB_int_FormatPasteObject { BUFF_OBJ_ATTR OBJ_INDEX } {
#===================================================================
  upvar $BUFF_OBJ_ATTR buff_obj_attr
  upvar $OBJ_INDEX obj_index
  global paOption
  global post_object

  set fmt_obj_list $Post::($post_object,fmt_obj_list)
  set count [llength $fmt_obj_list]
  if { $count }\
  {
     PB_com_RetObjFrmName buff_obj_attr(0) fmt_obj_list ret_code
     if {$ret_code}\
     {
        # PoP-Up Message
          tk_messageBox -type ok -icon error\
          -message "Object Name Exists...Paste Invalid"
          return
     }
  }
  PB_fmt_PasteFmtBuffObj fmt_obj_list buff_obj_attr obj_index
  set Post::($post_object,fmt_obj_list) $fmt_obj_list
}

#===============================================================================
proc PB_int_AddrSummaryAttr { ADD_NAME_LIST ADD_APP_TEXT ADD_DESC_ARR } {
#===============================================================================
   upvar $ADD_NAME_LIST add_name_list
   upvar $ADD_APP_TEXT add_app_text
   upvar $ADD_DESC_ARR add_desc_arr
   global post_object

   set add_obj_list $Post::($post_object,add_obj_list)
   set index 0
   
   set add_name_list ""
   foreach add_obj $add_obj_list \
   {
      address::readvalue $add_obj add_obj_attr
      set add_name $add_obj_attr(0)
      lappend add_name_list $add_name
      set add_rep_mom_var $address::($add_obj,rep_mom_var)
      PB_com_MapMOMVariable add_obj add_rep_mom_var app_text
      PB_int_GetElemDisplayAttr add_name app_text dis_attr
      set add_app_text($add_name) $dis_attr(1)
      set add_desc_arr($index) $address::($add_obj,word_desc)
      incr index
   }
}

#===============================================================================
proc PB_int_RetDefKinVars { DEF_MOM_KIN_VAR } {
#===============================================================================
  upvar $DEF_MOM_KIN_VAR def_mom_kin_var
  global post_object
  
  array set def_mom_kin_var $Post::($post_object,def_mom_kin_var_list)
}

#===============================================================================
proc PB_int_RetDefAddrFmtArrys { DEF_GPB_FMT_VAR DEF_GPB_ADDR_VAR } {
#===============================================================================
  upvar $DEF_GPB_FMT_VAR def_gpb_fmt_var
  upvar $DEF_GPB_ADDR_VAR def_gpb_addr_var
  global post_object

  array set def_gpb_fmt_var $Post::($post_object,def_gpb_fmt_var)
  array set def_gpb_addr_var $Post::($post_object,def_gpb_addr_var) 
}

#===============================================================================
#  Defines all the global variabels required for the ui stuff
#===============================================================================
proc PB_int_DefineUIGlobVar { } {
#===============================================================================
   global post_object
   global gpb_fmt_var
   global gpb_addr_var
   global mom_sys_arr
   global mom_kin_var
   global mach_type
   global axisoption

   set add_obj_list $Post::($post_object,add_obj_list)

   foreach add_obj $add_obj_list \
   {
      address::readvalue $add_obj add_obj_attr
      set add_name $add_obj_attr(0)
      set addr_fmt_obj $add_obj_attr(1)
      set addr_fmt_name $format::($addr_fmt_obj,for_name) 

     # Address attributes
      set gpb_addr_var($add_name,name) $add_obj_attr(0)
      set gpb_addr_var($add_name,fmt_name) $addr_fmt_name
      set gpb_addr_var($add_name,modal) $add_obj_attr(2)
      set gpb_addr_var($add_name,modl_status) $add_obj_attr(3)
      set gpb_addr_var($add_name,add_max) $add_obj_attr(4)
      set gpb_addr_var($add_name,max_status) $add_obj_attr(5)
      set gpb_addr_var($add_name,add_min)   $add_obj_attr(6)
      set gpb_addr_var($add_name,min_status) $add_obj_attr(7)
      set gpb_addr_var($add_name,leader_name) $add_obj_attr(8)
      set gpb_addr_var($add_name,trailer) $add_obj_attr(9)
      set gpb_addr_var($add_name,trail_status) $add_obj_attr(10)
      set gpb_addr_var($add_name,incremental) $add_obj_attr(11)
      unset add_obj_attr
   }

   set fmt_obj_list $Post::($post_object,fmt_obj_list)
   foreach fmt_obj $fmt_obj_list \
   {
      format::readvalue $fmt_obj fmt_obj_attr

      set fmt_name $fmt_obj_attr(0)
    # Format Attributes
      set gpb_fmt_var($fmt_name,name) $fmt_obj_attr(0)
      set gpb_fmt_var($fmt_name,dtype) $fmt_obj_attr(1)
      set gpb_fmt_var($fmt_name,plus_status) $fmt_obj_attr(2)
      set gpb_fmt_var($fmt_name,lead_zero) $fmt_obj_attr(3)
      set gpb_fmt_var($fmt_name,trailzero) $fmt_obj_attr(4)
      set gpb_fmt_var($fmt_name,integer)  $fmt_obj_attr(5)
      set gpb_fmt_var($fmt_name,decimal) $fmt_obj_attr(6)
      set gpb_fmt_var($fmt_name,fraction) $fmt_obj_attr(7)
      unset fmt_obj_attr
   }

  #Sets the defaults of address and formats
   set Post::($post_object,def_gpb_fmt_var) [array get gpb_fmt_var]
   set Post::($post_object,def_gpb_addr_var) [array get gpb_addr_var]

  #Sets the mom sys variables list.
   array set mom_sys_arr $Post::($post_object,mom_sys_var_list)

  # Sets the Sequece number variables
    array set seq_params $Post::($post_object,sequence_param)
    set mom_sys_arr(seqnum_block) $seq_params(block)
    set mom_sys_arr(seqnum_start) $seq_params(start)
    set mom_sys_arr(seqnum_incr) $seq_params(increment)
    set mom_sys_arr(seqnum_freq) $seq_params(frequency)

  # Sets the WordSeq
    set mom_sys_arr(Word_Seperator) $Post::($post_object,word_sep)

  # Sets the End of Line
    set mom_sys_arr(End_of_Block) $Post::($post_object,end_of_line)

  # Sets the varaibles for other options in the Others Page.
  # It is hardcoded, it has to be changed.
    set mom_sys_arr(Decimal_Point) "."
    set mom_sys_arr(Comment_Start) ""
    set mom_sys_arr(Comment_End) ""
    set Post::($post_object,mom_sys_var_list) [array get mom_sys_arr]
    set Post::($post_object,def_mom_sys_var_list) [array get mom_sys_arr]

  # gets the kinematic variables
    PB_mach_RetMachineToolAttr mom_kin_var

  # Gets the machine type & Axis
    PB_com_GetMachAxisType mom_kin_var mach_type axisoption
}

#===============================================================================
proc PB_int_GCodePageAttributes { G_CODES_DESC G_CODES_VAR } {
#===============================================================================
  upvar $G_CODES_DESC g_codes_desc
  upvar $G_CODES_VAR g_codes_var
  global post_object

  array set g_codes_mom_var $Post::($post_object,g_codes)
  array set g_codes_desc $Post::($post_object,g_codes_desc)

  #Sets the mom sys variables list.
   array set mom_sys_var_arr $Post::($post_object,mom_sys_var_list)

  set arr_size [array size g_codes_mom_var]
  
  # The code for each g code is set
    for {set count 0} {$count < $arr_size} {incr count}\
    {
        set g_codes_var($count) $g_codes_mom_var($count)
    }
}

#===============================================================================
proc PB_int_MCodePageAttributes { M_CODES_DESC M_CODES_VAR } {
#===============================================================================
  upvar $M_CODES_DESC m_codes_desc
  upvar $M_CODES_VAR m_codes_var
  global post_object

  array set m_codes_mom_var $Post::($post_object,m_codes)
  array set m_codes_desc $Post::($post_object,m_codes_desc)


  set arr_size [array size m_codes_mom_var]
  
  # The code for each g code is set
  for {set count 0} {$count < $arr_size} {incr count}\
  {
      set m_codes_var($count) $m_codes_mom_var($count)
  }
}

#==============================================================
proc PB_int_AddApplyObject { ADDR_OBJ ADDR_OBJ_ATTR } {
#==============================================================
  upvar $ADDR_OBJ addr_obj
  upvar $ADDR_OBJ_ATTR addr_obj_attr
  global post_object

  set add_obj_list $Post::($post_object,add_obj_list)
  set fmt_obj_list $Post::($post_object,fmt_obj_list)

  PB_adr_ApplyAdrObj add_obj_list fmt_obj_list addr_obj_attr addr_obj
}

#==================================================================
proc PB_int_AddCreateObject { ACT_ADDR_OBJ OBJ_ATTR OBJ_INDEX } {
#==================================================================
  upvar $ACT_ADDR_OBJ act_addr_obj
  upvar $OBJ_ATTR obj_attr
  upvar $OBJ_INDEX obj_index
  global post_object
  
  array set word_mom_var_arr $Post::($post_object,word_mom_var)
  array set word_desc_arr $Post::($post_object,word_desc_array)

  PB_adr_RetAddressObjList add_obj_list
  set obj_index [lsearch $add_obj_list $act_addr_obj]

  PB_adr_GetAddressNameList add_obj_list add_name_list
  set prev_add_name $obj_attr(0)
  set obj_attr(0) "user_def"
  PB_com_SetDefaultName add_name_list obj_attr
  PB_adr_CreateNewAdrObj add_obj_list obj_attr obj_index
  set word_mom_var_arr($obj_attr(0)) $word_mom_var_arr($prev_add_name)
  set word_desc_arr($obj_attr(0)) $word_desc_arr($prev_add_name)

  # Updates the database
    set Post::($post_object,add_obj_list) $add_obj_list
    set Post::($post_object,word_mom_var) [array get word_mom_var_arr]
    set Post::($post_object,word_desc_array) [array get word_desc_arr]
}

#===============================================================================
proc PB_int_CreateNewAddress { ADD_NAME FORMAT_NAME ADD_OBJ } {
#===============================================================================
  upvar $ADD_NAME add_name
  upvar $FORMAT_NAME format_name
  upvar $ADD_OBJ add_obj
  global post_object

  PB_adr_InitAdrObj add_obj_attr
  set add_obj_attr(0) $add_name

  # Sets the default address name
    PB_adr_RetAddressObjList add_obj_list
    PB_adr_GetAddressNameList add_obj_list add_name_list
    PB_com_SetDefaultName add_name_list add_obj_attr

  # Gets the format object
    PB_fmt_RetFormatObjs fmt_obj_list
    PB_com_RetObjFrmName format_name fmt_obj_list fmt_obj
    set add_obj_attr(1) $fmt_obj

  PB_adr_CreateAdrObj add_obj_attr add_obj

  # Add master sequence parameters here, to sequence the new address
    set mseq_attr(0) "\$mom_usd_add_var"
    set mseq_attr(1) 0
    set mseq_attr(2) "User Defined Address"
    set mseq_attr(3) [llength $add_obj_list]
    address::SetMseqAttr $add_obj mseq_attr
    address::DefaultMseqAttr $add_obj mseq_attr

  set add_obj_list $Post::($post_object,add_obj_list)
  lappend add_obj_list $add_obj
  set Post::($post_object,add_obj_list) $add_obj_list
  set add_name $add_obj_attr(0)
}

#===========================================================================
proc PB_int_UpdateAddVariablesAttr { WORD_DESC_ARR BASE_ADDR } {
#===========================================================================
  upvar $WORD_DESC_ARR word_desc_arr
  upvar $BASE_ADDR base_addr
  global post_object

  array set word_mom_var_list $Post::($post_object,word_mom_var)
  set word_mom_var_list($base_addr) ""
  set Post::($post_object,word_mom_var) [array get word_mom_var_list]
  set Post::($post_object,word_desc_array) [array get word_desc_arr]
}

#============================================================================
proc PB_int_AddCutObject { ACTIVE_ADD_OBJ OBJ_INDEX ADD_MOM_VAR \
                           ADD_VAR_DESC ADD_MSEQ_ATTR } {
#============================================================================
  upvar $ACTIVE_ADD_OBJ active_add_obj
  upvar $OBJ_INDEX obj_index
  upvar $ADD_MOM_VAR add_mom_var
  upvar $ADD_VAR_DESC add_var_desc
  upvar $ADD_MSEQ_ATTR add_mseq_attr
  global post_object

  array set word_mom_var_arr $Post::($post_object,word_mom_var)
  array set word_desc_arr $Post::($post_object,word_desc_array)

  set add_name $address::($active_add_obj,add_name)
  address::readMseqAttr $active_add_obj add_mseq_attr

  # Deletes the address object from the format addr_list
    PB_int_RemoveAddObjFromList active_add_obj

  set add_mom_var $word_mom_var_arr($add_name)
  set add_var_desc $word_desc_arr($add_name)
  unset word_mom_var_arr($add_name)
  unset word_desc_arr($add_name)
  set Post::($post_object,word_mom_var) [array get word_mom_var_arr]
  set Post::($post_object,word_desc_array) [array get word_desc_arr]

  PB_adr_RetAddressObjList add_obj_list
  if { $obj_index == [llength $add_obj_list]} \
  {
     incr obj_index -1
  }
}

#==========================================================================
proc PB_int_AddPasteObject { BUFF_OBJ_ATTR OBJ_INDEX ADD_MOM_VAR \
                             ADD_VAR_DESC ADD_MSEQ_ATTR } {
#==========================================================================
  upvar $BUFF_OBJ_ATTR buff_obj_attr
  upvar $OBJ_INDEX obj_index
  upvar $ADD_MOM_VAR add_mom_var
  upvar $ADD_VAR_DESC add_var_desc
  upvar $ADD_MSEQ_ATTR add_mseq_attr
  global post_object

  set add_obj_list $Post::($post_object,add_obj_list)
  set count [llength $add_obj_list]

  if { $count }\
  {
     PB_com_RetObjFrmName buff_obj_attr(0) add_obj_list ret_code
     if {$ret_code}\
     {
        # PoP-Up Message
          tk_messageBox -type ok -icon error\
          -message "Object Name Exists...Paste Invalid"
          return
     }
  }

  PB_adr_PasteAdrBuffObj add_obj_list buff_obj_attr add_mseq_attr \
                         obj_index
  array set word_mom_var_arr $Post::($post_object,word_mom_var)
  array set word_desc_arr $Post::($post_object,word_desc_array)
  set word_mom_var_arr($buff_obj_attr(0)) $add_mom_var
  set word_desc_arr($buff_obj_attr(0)) $add_var_desc

  # Updates the database
    set Post::($post_object,add_obj_list) $add_obj_list
    set Post::($post_object,word_mom_var) [array get word_mom_var_arr]
    set Post::($post_object,word_desc_array) [array get word_desc_arr]
}

#=========================================================================
proc PB_int_GetWordVarDesc { WORD_DESC_ARRAY } {
#=========================================================================
  upvar $WORD_DESC_ARRAY word_desc_array
  global post_object
 
  array set word_desc_array $Post::($post_object,word_desc_array)
}

#==============================================================
proc ApplyListObjAttr {ListObjectAttr ListObjectList} {
#==============================================================
  upvar $ListObjectAttr obj_attr
  upvar $ListObjectList obj_list

  set object [lindex $obj_list 0]
  ListingFile::RestoreValue $object obj_attr
  ListingFile::setvalue_from_pui $object obj_attr
# PB_lfl_WritebackPui obj_list
}

#==============================================================
proc DefListObjAttr {ListObjectList ListObjectAttr} {
#==============================================================
  upvar $ListObjectList object
  upvar $ListObjectAttr obj_attr

  PB_lfl_DefLfileParams object obj_attr
}

#==============================================================
proc RestoreListObjAttr {ListObjectList ListObjectAttr} {
#==============================================================
  upvar $ListObjectList object
  upvar $ListObjectAttr obj_attr

  PB_lfl_ResLfileParams object obj_attr
}

#=====================================================================
proc PB_int_CreateBlkElemFromElemObj { BLK_ELEM_OBJ NEW_ELEM_OBJ \
                                       BLK_OBJ_ATTR } {
#=====================================================================
  upvar $BLK_ELEM_OBJ blk_elem_obj
  upvar $NEW_ELEM_OBJ new_elem_obj
  upvar $BLK_OBJ_ATTR blk_obj_attr

  block_element::readvalue $blk_elem_obj blk_elem_obj_attr
  PB_blk_CreateBlkElemObj blk_elem_obj_attr new_elem_obj blk_obj_attr
}

#==============================================================
proc PB_int_AddNewBlockElemObj {BLK_ELEM_ADR_NAME BLK_ELEM_MOM_VAR \
                                BLOCK_OBJ NEW_BLK_ELEM_OBJ } {
#==============================================================
  upvar $BLK_ELEM_ADR_NAME blk_elem_adr_name
  upvar $BLK_ELEM_MOM_VAR blk_elem_mom_var
  upvar $BLOCK_OBJ block_obj
  upvar $NEW_BLK_ELEM_OBJ new_blk_elem_obj

  set blk_obj_attr(0) $block::($block_obj,block_name)
  PB_blk_AddNewBlkElemObj blk_elem_adr_name blk_elem_mom_var\
                          blk_obj_attr new_blk_elem_obj
}


#==============================================================
proc PB_int_GetAddrListFormat { FMT_NAME ADDR_LIST } {
#==============================================================
  upvar $FMT_NAME fmt_name
  upvar $ADDR_LIST addr_list
  global post_object

  set fmt_obj_list $Post::($post_object,fmt_obj_list)
  PB_com_RetObjFrmName fmt_name fmt_obj_list fmt_obj
  
  set addr_obj_list $format::($fmt_obj,fmt_addr_list)

  foreach add_obj $addr_obj_list \
  {
    lappend addr_list $address::($add_obj,add_name)
  }
}

#==============================================================
proc PB_int_GetAdsFmtValue {ADD_NAME ADS_FMT_ATTR DIS_ATTR} {
#==============================================================
  upvar $ADD_NAME add_name
  upvar $ADS_FMT_ATTR ads_fmt_attr
  upvar $DIS_ATTR dis_attr
  global post_object

  if {[info exists dis_attr]}\
  {
     unset dis_attr
  }

  set add_obj_list $Post::($post_object,add_obj_list)
  PB_com_RetObjFrmName add_name add_obj_list add_obj

  set add_rep_mom_var $address::($add_obj,rep_mom_var)
  PB_com_MapMOMVariable add_obj add_rep_mom_var app_text

  PB_int_ReturnInputValue app_text ads_fmt_attr(1) inp_value
  PB_fmt_RetFmtOptVal ads_fmt_attr inp_value value
  set dis_attr $value
}

#==============================================================
proc PB_int_GetElemDisplayAttr {ADD_NAME APP_TEXT DIS_ATTR} {
#==============================================================
  upvar $ADD_NAME add_name
  upvar $APP_TEXT app_text
  upvar $DIS_ATTR dis_attr

  global post_object
  if {[info exists dis_attr]}\
  {
     unset dis_attr
  }

  set add_obj_list $Post::($post_object,add_obj_list)
  PB_com_RetObjFrmName add_name add_obj_list add_obj

  set dis_attr(0) $address::($add_obj,add_leader)
  set trailer_status $address::($add_obj,add_trailer_status)
  if {$trailer_status}\
  {
     set dis_attr(2) $address::($add_obj,add_trailer)
  } else\
  {
     set dis_attr(2) ""
  }

  set format_obj $address::($add_obj,add_format)
  format::readvalue $format_obj for_obj_attr

  PB_int_ReturnInputValue app_text for_obj_attr(1) inp_value
  PB_fmt_RetFmtOptVal for_obj_attr inp_value value
  set dis_attr(1) $value
}

#==============================================================
proc PB_int_GetFormat { FMT_OBJ_ATTR FMT_VALUE } {
#==============================================================
  upvar $FMT_OBJ_ATTR fmt_obj_attr
  upvar $FMT_VALUE fmt_value

  if {[string compare $fmt_obj_attr(1) "Integer"] == 0} \
  {
     set inp_value 1
  } elseif {[string compare $fmt_obj_attr(1) "Real Number"] == 0} \
  {
     set inp_value 1.234
  } else \
  {
     set inp_value ""
  }

  PB_fmt_RetFmtOptVal fmt_obj_attr inp_value fmt_value
}

#==============================================================
proc PB_int_ReturnInputValue {APP_TEXT FMT_DTYPE INP_VALUE} {
#==============================================================
  upvar $APP_TEXT app_text
  upvar $FMT_DTYPE fmt_dtype
  upvar $INP_VALUE inp_value

  set inp_value ""
  if {[string compare $app_text ""] == 0} \
  {
     switch $fmt_dtype \
     {
        "Real Number" {
                         set inp_value 1.234
                      }

        "Integer"     {
                         set inp_value 1
                      }

        "Text String" {
                         set inp_value ""
                      }
     }
  } else \
  {
    set is_number [tixGetInt -nocomplain $app_text]
    if {$is_number} \
    {
       set inp_value $app_text
    } else \
    {
       switch $fmt_dtype \
       {
        "Real Number" {
                         set inp_value 1.234
                      }

        "Integer"     {
                         set inp_value 1
                      }
        "Text String" {
                         set inp_value $app_text
                      }
       }
    }
  }
}

#==============================================================
proc PB_int_GetGroupWordAddress {IMAGE_NAME IMAGE_TEXT} {
#==============================================================
  global post_object

  set word_image_name_list $Post::($post_object,word_img_name)
  set word_app_text_list $Post::($post_object,word_app_text)
 
  array set word_image_array $word_image_name_list
  array set word_app_text_array $word_app_text_list
  set add_list [array names word_image_array] 

  foreach address $add_list\
  {
     set img_sub_list $word_image_array($address)
     set elem_check [lsearch $img_sub_list $IMAGE_NAME]

     if {$elem_check != -1}\
     {
        set app_text_sub_list $word_app_text_array($address)
        set text_elem_check [lsearch $app_text_sub_list $IMAGE_TEXT)]
        if {$text_elem_check != -1}\
        {
           set IMAGE_TEXT [lindex $word_app_text_array($address) 0]
        }
     }
  }
  append temp_app_img_name $IMAGE_NAME $IMAGE_TEXT
  return $temp_app_img_name
}

#==============================================================
proc PB_int_GetNewBlockElement {BASE_ELEMENT INDEX WORD_MOM_VAR} {
#==============================================================
  upvar $BASE_ELEMENT base_element
  upvar $INDEX index
  upvar $WORD_MOM_VAR word_mom_var
  
  PB_blk_AddNewBlkElem base_element index word_mom_var
}

#==============================================================
proc PB_int_GetBlockElementAddr {ELEM_ADDRESS BASE_ELEMENT_LIST } {
#==============================================================
  upvar $ELEM_ADDRESS elem_address
  upvar $BASE_ELEMENT_LIST base_element_list

  PB_blk_RetValidCboxBlkElemAddr elem_address base_element_list
}

#==============================================================
proc PB_int_RetSequenceObjs { SEQ_OBJ_LIST } {
#==============================================================
  upvar $SEQ_OBJ_LIST seq_obj_list
  global post_object

  set seq_obj_list $Post::($post_object,seq_obj_list)
}

#==============================================================
proc PB_int_RetEvtCombElems { COMB_BOX_ELEMS } {
#==============================================================
  upvar $COMB_BOX_ELEMS comb_box_elems
  global post_object

  set comb_box_elems $Post::($post_object,word_name_list)
}

#==============================================================
proc PB_int_DbaseRetSeqEvtBlkObj {EVT_OBJ_LIST INDEX} {
#==============================================================
  upvar $EVT_OBJ_LIST evt_obj_list
  upvar $INDEX index
 
  global post_object
  set seq_obj [lindex $Post::($post_object,seq_obj_list) $index]
  PB_seq_RetSeqEvtBlkObj seq_obj evt_obj_list
}

#==============================================================
proc PB_int_DbaseRetSeqCombElems { COMB_ELEM_LIST } {
#==============================================================
  upvar $COMB_ELEM_LIST comb_elem_list
 
  global post_object
  set blk_obj_list $Post::($post_object,blk_obj_list)
  PB_seq_RetSeqCombElems blk_obj_list comb_elem_list
}

#==============================================================
proc PB_int_RetBlkObjList { BLK_OBJ_LIST } {
#==============================================================
   upvar $BLK_OBJ_LIST blk_obj_list

   #sets the post object.
   global post_object
  
   #sets the block object list. 
   set blk_obj_list $Post::($post_object,blk_obj_list)
}

#==============================================================
proc PB_int_GetNewEventElement { EVENT_OBJ BLK_NAME ELEM_TYPE ELEM_OBJ } {
#==============================================================
   upvar $EVENT_OBJ event_obj
   upvar $BLK_NAME blk_name
   upvar $ELEM_TYPE elem_type
   upvar $ELEM_OBJ elem_obj

   #sets the post object.
   global post_object

   #sets the block object list.
    set blk_obj_list $Post::($post_object,blk_obj_list)

   #Returns object from name.
    PB_com_RetObjFrmName blk_name blk_obj_list block_obj

   set evt_elem_attr(0) $blk_name
   set evt_elem_attr(1) $block_obj
   set evt_elem_attr(2) $elem_type

   PB_evt_CreateEventElement elem_obj evt_elem_attr
   block::AddToEventList $block_obj event_obj
}

#===============================================================
proc PB_int_RetMOMVarAsscAddress { ADDRESS_NAME ADD_MOM_VAR_LIST } {
#===============================================================
  upvar $ADDRESS_NAME address_name
  upvar $ADD_MOM_VAR_LIST add_mom_var_list

  global post_object

  array set word_mom_var_list $Post::($post_object,word_mom_var)

  if { [info exists word_mom_var_list($address_name)] } \
  {
     set add_mom_var_list $word_mom_var_list($address_name)
  } else \
  {
     set add_mom_var_list ""
  }
}

#=================================================================
proc PB_int_RetAddressObjList { ADDR_OBJ_LIST } {
#=================================================================
  upvar $ADDR_OBJ_LIST addr_obj_list

  PB_adr_RetAddressObjList addr_obj_list
}

#=================================================================
proc PB_int_RetAddrObjFromName { ADDR_NAME ADDR_OBJ } {
#=================================================================
  upvar $ADDR_NAME addr_name
  upvar $ADDR_OBJ addr_obj

  PB_adr_RetAddressObjList addr_obj_list
  PB_com_RetObjFrmName addr_name addr_obj_list addr_obj
}

#=====================================================
proc PB_int_RetAddrNameList { ADDR_NAME_LIST } {
#=====================================================
  upvar $ADDR_NAME_LIST addr_name_list

  PB_adr_RetAddressObjList addr_obj_list
  PB_adr_RetAddressNameList addr_obj_list addr_name_list
}

#=====================================================
proc PB_int_RemoveAddObjFromList { ADD_OBJ } {
#=====================================================
  upvar $ADD_OBJ add_obj
  global post_object

  PB_adr_RetAddressObjList addr_obj_list

  set add_index [lsearch $addr_obj_list $add_obj]
  if { $add_index != -1 } \
  {
     set add_fmt_obj $address::($add_obj,add_format)
     format::DeleteFromAddressList $add_fmt_obj add_obj
     set addr_obj_list [lreplace $addr_obj_list $add_index $add_index]
     set Post::($post_object,add_obj_list) $addr_obj_list
  }
}

#=====================================================
proc PB_int_RetFormatObjList { FMT_OBJ_LIST } {
#=====================================================
  upvar $FMT_OBJ_LIST fmt_obj_list
  
  PB_fmt_RetFormatObjs fmt_obj_list
}

#======================================================================
proc PB_int_RetFmtNameList { FMT_NAME_LIST } {
#======================================================================
  upvar $FMT_NAME_LIST fmt_name_list

  PB_fmt_RetFormatObjs fmt_obj_list
  PB_fmt_GetFmtNameList fmt_obj_list fmt_name_list
}

#======================================================================
proc PB_int_RetFmtObjFromName { FMT_NAME FMT_OBJ } {
#======================================================================
   upvar $FMT_NAME fmt_name
   upvar $FMT_OBJ fmt_obj

  PB_fmt_RetFormatObjs fmt_obj_list
  PB_com_RetObjFrmName fmt_name fmt_obj_list fmt_obj
}

#======================================================================
proc PB_int_RetDefKinVarValues { KIN_VAR_LIST KIN_VAR_VALUE } {
#======================================================================
  upvar $KIN_VAR_LIST kin_var_list
  upvar $KIN_VAR_VALUE kin_var_value

  global post_object

  array set def_kin_var $Post::($post_object,def_mom_kin_var_list)
  foreach kin_var $kin_var_list \
  {
     set kin_var_value($kin_var) $def_kin_var($kin_var)
  }
}

#======================================================================
proc PB_int_RetDefMOMVarValues { MOM_VAR_ARR MOM_VAR_VALUE } {
#======================================================================
  upvar $MOM_VAR_ARR mom_var_arr
  upvar $MOM_VAR_VALUE mom_var_value
  global post_object

  array set def_mom_var $Post::($post_object,def_mom_sys_var_list)
  set no_mom_var [array size mom_var_arr]
  for {set count 0} { $count < $no_mom_var } { incr count } \
  {
      set mom_var $mom_var_arr($count)
      set mom_var_value($mom_var) $def_mom_var($mom_var)
  }
}

#======================================================================
proc PB_int_UpdateMOMVar { MOM_SYS_VAR } {
#======================================================================
  upvar $MOM_SYS_VAR mom_sys_var
  global post_object

  set Post::($post_object,mom_sys_var_list) \
                             [array get mom_sys_var]
}


#========================================================================
proc PB_int_UpdateKinVar { MOM_KIN_VAR } {
#========================================================================
  upvar $MOM_KIN_VAR mom_kin_var
  global post_object

  set Post::($post_object,mom_kin_var_list) \
                                  [array get mom_kin_var]
}

#========================================================================
proc PB_int_RetCycleComAndSharedEvts { CYCLE_COM_EVT CYCLE_SHARED_EVTS } {
#========================================================================
  upvar $CYCLE_COM_EVT cycle_com_evt
  upvar $CYCLE_SHARED_EVTS cycle_shared_evts
  global post_object

  set cycle_com_evt [lindex $Post::($post_object,cyl_com_evt) 0]
  set cycle_shared_evts [lindex $Post::($post_object,cyl_evt_sh_com_evt) 0]
}

#===================================================================
proc PB_int_CreateCyclePostBlks { EVENT_OBJ } {
#===================================================================
  upvar $EVENT_OBJ event_obj
  global post_object

  set evt_elem_list $event::($event_obj,evt_elem_list)

  # Creates the Rapid block
    PB_evt_CreateRapidToBlock evt_elem_list

  # Creates the Retract block
    PB_evt_CreateRetractToBlock evt_elem_list

  # Creates the Cycle plane control block
    PB_evt_CreateCyclePlaneBlock evt_elem_list

  # Creates the Cycle Start Block
    PB_evt_CreateCycleStartBlock evt_elem_list

  # Stores the post blocks in the post object
    PB_evt_StorePostBlocks evt_elem_list

  set event::($event_obj,evt_elem_list) $evt_elem_list
}

#==============================================================================
proc PB_int_ReadPostFiles { DIR DEF_FILE TCL_FILE } {
#==============================================================================
  upvar $DIR dir
  upvar $DEF_FILE def_file
  upvar $TCL_FILE tcl_file
  global post_object

  Post::ReadPostFiles $post_object dir def_file tcl_file
}

#==============================================================================
proc PB_int_SetPostOutputFiles { DIR PUI_FILE DEF_FILE TCL_FILE } {
#==============================================================================
  upvar $DIR dir
  upvar $PUI_FILE pui_file
  upvar $DEF_FILE def_file
  upvar $TCL_FILE tcl_file
  global post_object

  Post::SetPostOutputFiles $post_object dir pui_file def_file \
                           tcl_file
}

#==============================================================================
proc PB_int_ReadPostOutputFiles { DIR PUI_FILE DEF_FILE TCL_FILE } {
#==============================================================================
  upvar $DIR dir
  upvar $PUI_FILE pui_file
  upvar $DEF_FILE def_file
  upvar $TCL_FILE tcl_file
  global post_object

  Post::ReadPostOutputFiles $post_object dir pui_file def_file \
                            tcl_file
}

#===================================================================
proc PB_Start { pui_file_name args } {
#===================================================================
   global post_object
   global env

#   set cdl_file_name "$env(PB_HOME)/pblib/ude.def"
   set def_file_id FP1
   set pui_file_id FP2
   set cdl_file_id FP3

   # Read All Defaults File Create Objects and Display in the UI
     PB_com_ReadPuiFile pui_file_name pui_file_id post_object
#     PB_com_ReadUdeFile cdl_file_name cdl_file_id post_object

   # Gets the definition file & Tcl file name
     Post::ReadPostFiles $post_object dir def_file tcl_file

    set def_file [file join $dir $def_file]
    PB_com_ReadDfltDefFile def_file def_file_id post_object
    PB_seq_CreateSequences post_object

   # Defines all the global variables for the ui
     PB_int_DefineUIGlobVar
}

#====================================================================
proc PB_CreateDefTclFiles { args } {
#====================================================================
  global post_object
  if {![info exists post_object]} { return }

  set def_parse_obj $Post::($post_object,def_parse_obj)
  Post::ReadPostOutputFiles $post_object dir pui_file def_file tcl_file

  set pui_file [file join $dir $pui_file]
  set def_file [file join $dir $def_file]
  set tcl_file [file join $dir $tcl_file]

  # Outputs Definition file
    PB_PB2DEF_main def_parse_obj def_file

  # Outputs Event Handler (TCL)
    PB_PB2TCL_main tcl_file

  # Outputs Post Builder PUI file 
    PB_pui_WritePuiFile pui_file
}
