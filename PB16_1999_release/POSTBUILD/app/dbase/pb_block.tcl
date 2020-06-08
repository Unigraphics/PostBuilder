##############################################################################
# Description                                                                #
#     This is contains all the functions dealing with the BLOBK object.      #
#                                                                            #
# Revisions                                                                  #
#                                                                            #
#   Date        Who   Reason                                                 #
# 01-feb-1999   bmp   Initial                                                #
# 07-Apr-1999   mnb   Removed puts                                           #
# 05-May-1999   mnb   Added a procedure, which returns block code for the    #
#                     Definition file.                                       #
# 02-Jun-1999   mnb   Code Integration                                       #
# 21-Jun-1999   mnb   Added code to handle composite blocks                  #
# 23-Jun-1999   mnb   Better parser                                          #
# 02-Jul-1999   mnb   Changed the listing file block name to comment_data    #
# 07-Sep-1999   mnb   Fixed MDFT & Post Builder Integration problems         #
# 21-Sep-1999   mnb   Added force output, as an attribute of block element   #
# 13-Oct-1999   mnb   Added a proceduer to retrun the block elements         #
#                     modality.                                              #
#                                                                            #
# $HISTORY$                                                                  #
#                                                                            #
##############################################################################

#=======================================================================
proc PB_blk_BlkInitParse {this OBJ_LIST ADDOBJ_LIST POST_OBJ} {
#=======================================================================
   upvar $OBJ_LIST obj_list
   upvar $ADDOBJ_LIST addobj_list
   upvar $POST_OBJ post_obj
   set add_start 0
   set add_count 0
   set blk_elem_obj_list ""

   array set block_temp_arr $ParseFile::($this,block_temp_list)
   array set arr_size $ParseFile::($this,arr_size_list)
   set comp_blk_list $Post::($post_obj,comp_blk_list)
   set file_name_list $ParseFile::($this,file_list)

   foreach f_name $file_name_list \
   {
      set no_of_blocks $arr_size($f_name,block)
      for {set count 0} {$count < $no_of_blocks} {incr count} \
      {
        set blk_start 0
        set open_flag 0
        set close_flag 0
        foreach line $block_temp_arr($f_name,$count,data) \
        {
           if {[string match "*BLOCK_TEMPLATE*" $line]} \
           {
              set temp_line $line
              PB_com_RemoveBlanks temp_line

              # Composite blocks are eliminated
                set comp_flag [lsearch $comp_blk_list [lindex $temp_line 1]]
                if {$comp_flag != -1} { break }

                set blk_start 1
                set blk_obj_attr(0) [lindex $temp_line 1]
           }

           if {$blk_start} \
           {
              if {$open_flag == 0} \
              {
                 PB_mthd_CheckOpenBracesInLine line open_flag
              }

              if {$close_flag == 0} \
              {
                 PB_mthd_CheckCloseBracesInLine line close_flag
              }

              if {$open_flag} \
              {
                 PB_com_RemoveBlanks line
                 PB_blk_CheckJoinBrace_left line
                 PB_blk_CheckJoinBrace_right line
                 if {$line != ""} \
                 {
                    PB_blk_CreateBlkElems line blk_elem_obj_list blk_obj_attr \
                                          addobj_list
                 }
              }

              if {$close_flag} \
              {
                  PB_blk_CreateBlock blk_obj_attr obj_list blk_elem_obj_list \
                                      post_obj 
                  unset blk_elem_obj_list
                  set blk_start 0
              }
           }
        }
      }
   }
}

#=============================================================================
proc PB_blk_CheckJoinBrace_left { LINE } {
#=============================================================================
  upvar $LINE line

  set test [lsearch  -exact $line "\{"]
  if {$test == -1}\
  {
     set case_id [lsearch -glob $line "*\{*"]
     if {$case_id != -1} \
     {
        set element [lindex $line $case_id]
        set sub_case_id [string first "\{" $element]
        set new_string [string range [expr $sub_case_id  + 1] end]
        set line [lreplace $line $case_id $case_id $new_string]
        set line [lrange $line $case_id end]
     } else \
     {
        set line $line
     }
  } else\
  {
     set line [lrange $line [expr $test + 1] end]
  }
}

#==========================================================================
proc PB_blk_CheckJoinBrace_right { LINE } {
#==========================================================================
  upvar $LINE line
  
  set test [lsearch  -exact $line "\}"]

  if {$test == -1}\
  {
     set case_id [lsearch -glob $line "*\}*"]
     if {$case_id != -1} \
     {
        set element [lindex $line $case_id]
        set sub_case_id [string first "\{" $element]
        set new_string [string range 0 [expr $sub_case_id - 1]]
        set line [lreplace $line $case_id $case_id $new_string]
        set line [lrange $line $case_id end]
     } else \
     {
        set line $line
     }
  } else\
  {
     set line [lrange $line 0 [expr $test - 1]]
  }
}

proc PB_blk_CreateBlkElems { LINE BLK_ELEM_OBJ_LIST BLK_OBJ_ATTR ADDOBJ_LIST} {
  upvar $LINE line
  upvar $BLK_ELEM_OBJ_LIST blk_elem_obj_list
  upvar $BLK_OBJ_ATTR blk_obj_attr
  upvar $ADDOBJ_LIST addobj_list
 
  set nofelements [llength $line]

  for {set ne 0} {$ne < $nofelements} {incr ne}\
  {
      set split_var [lindex $line $ne]
      PB_blk_SplitBlkTmplElem split_var blk_elem_obj_list \
                              blk_obj_attr addobj_list
  }
}


proc PB_blk_SplitBlkTmplElem {SplitVar BLK_ELEM_OBJ_LIST BLK_OBJ_ATTR \
                              ADDOBJ_LIST} {
  upvar $SplitVar split_var
  upvar $BLK_ELEM_OBJ_LIST blk_elem_obj_list
  upvar $BLK_OBJ_ATTR blk_obj_attr
  upvar $ADDOBJ_LIST addobj_list

  PB_blk_BlkOptNowsCheck split_var blk_elem_obj_attr

  set trim_char [string first "\[" $split_var]
  set trim_char1 [string first "\]" $split_var]
  if {$trim_char != -1}\
  {
     set text_flag 0
     set blk_elem_obj_attr(0) [string range $split_var 0 [expr $trim_char - 1]]
     set blk_elem_obj_attr(1) [string range $split_var [expr $trim_char + 1] \
                              [expr $trim_char1 - 1]]
  } else\
  {
     set blk_elem_obj_attr(0) "Text"
     set split_var [string trimright $split_var \}]
     set split_var [string trimright $split_var \"]
     set split_var [string trimleft $split_var \"]
     set blk_elem_obj_attr(1) $split_var
  }
   
  PB_blk_BlkElemForceOpt blk_obj_attr(0) blk_elem_obj_attr

  switch $blk_elem_obj_attr(0)\
  {
     LF_ENUM  - LF_XABS  -
     LF_YABS  - LF_ZABS  -
     LF_AAXIS - LF_BAXIS -
     LF_FEED  -
     LF_SPEED    {
                    PB_blk_RetLfileAddObjFromList blk_elem_obj_attr
                 }
     default     {
                    PB_com_RetObjFrmName blk_elem_obj_attr(0) addobj_list \
                                         ret_code
                    set blk_elem_obj_attr(0) $ret_code

                    set addr_name $address::($blk_elem_obj_attr(0),add_name)
                    PB_blk_RetWordDescArr addr_name elem_word_desc \
                                          blk_elem_obj_attr(1)
                    set blk_elem_obj_attr(3) $elem_word_desc
                 }
  }  

  PB_blk_CreateBlkElemObj blk_elem_obj_attr new_elem_obj blk_obj_attr
  lappend blk_elem_obj_list $new_elem_obj
}

proc PB_blk_RetLfileAddObjFromList {BLK_ELEM_OBJ_ATTR} {
  upvar $BLK_ELEM_OBJ_ATTR blk_elem_obj_attr

  global post_object
  
  set list_file_obj $Post::($post_object,list_obj_list)
  set lfile_addobj_list $ListingFile::($list_file_obj,add_obj_list)
  PB_com_RetObjFrmName blk_elem_obj_attr(0) lfile_addobj_list ret_code
  set blk_elem_obj_attr(0) $ret_code
  set blk_elem_obj_attr(2) ""
  set blk_elem_obj_attr(3) ""
  set blk_elem_obj_attr(4) 0
}

proc  PB_blk_BlkElemForceOpt { BLOCK_NAME BLK_ELEM_OBJ_ATTR } {
  upvar $BLOCK_NAME block_name
  upvar $BLK_ELEM_OBJ_ATTR blk_elem_obj_attr
  global post_object

  array set blk_mod_arr $Post::($post_object,blk_mod_list)
  if { [info exists blk_mod_arr($block_name)] } \
  {
     set mod_add_list $blk_mod_arr($block_name)
     if { [lsearch $mod_add_list $blk_elem_obj_attr(0)] != -1} \
     {
         set blk_elem_obj_attr(4) 1
     } else \
     {
         set blk_elem_obj_attr(4) 0
     }
  } else \
  {
     set blk_elem_obj_attr(4) 0
  }
}

proc PB_blk_BlkOptNowsCheck {SPLIT_VAR BLK_ELEM_OBJ_ATTR} {
  upvar $SPLIT_VAR split_var
  upvar $BLK_ELEM_OBJ_ATTR blk_elem_obj_attr

  if {([string first "]\\opt" $split_var] != -1) || \
      ([string first "]\\nows" $split_var] != -1)}\
  {
     if {[string first "]\\opt" $split_var] != -1}\
     {
        if {[regexp "nows" $split_var]}\
        {
          set blk_elem_obj_attr(2) "both"
        } else\
        {
          set blk_elem_obj_attr(2) "opt"
        }
     } else\
     {
        if {[string first "\\opt" $split_var] != -1}\
        {
          set blk_elem_obj_attr(2) "both"
        } else\
        {
          set blk_elem_obj_attr(2) "nows"
        }
     }
  } else\
  {
     set blk_elem_obj_attr(2) "blank"
  }
}

proc PB_blk_CreateBlkElemObj {BLK_ELEM_OBJ_ATTR NEW_ELEM_OBJ BLK_OBJ_ATTR} {
  upvar $BLK_ELEM_OBJ_ATTR blk_elem_obj_attr
  upvar $NEW_ELEM_OBJ new_elem_obj
  upvar $BLK_OBJ_ATTR blk_obj_attr
  
  set new_elem_obj [new block_element $blk_obj_attr(0)]
  block_element::setvalue $new_elem_obj blk_elem_obj_attr
  block_element::DefaultValue $new_elem_obj blk_elem_obj_attr
#  puts "The Block Element is Created: $new_elem_obj "

  set add_obj $blk_elem_obj_attr(0)
  address::AddToBlkElemList $add_obj new_elem_obj
}

proc PB_blk_CreateBlock {BLK_OBJ_ATTR BLK_OBJ_LIST BLK_ELEM_OBJ_LIST \
                          POST_OBJ} {
  upvar $BLK_ELEM_OBJ_LIST blk_elem_obj_list
  upvar $BLK_OBJ_ATTR blk_obj_attr
  upvar $BLK_OBJ_LIST blk_obj_list
  upvar $POST_OBJ post_obj

  set blk_obj_attr(1) [llength $blk_elem_obj_list]
  set blk_obj_attr(2) $blk_elem_obj_list
  if {[string compare $blk_obj_attr(0) "comment_data"] != 0}\
  {
     PB_blk_CreateBlkObj blk_obj_attr object
     lappend blk_obj_list $object
#     puts "The BLOCK OBJECT IS CREATED : $object"
  } else\
  {
    PB_blk_CreateBlkObj blk_obj_attr object
    PB_lfl_AttrFromDef object post_obj
  }
} 

proc PB_blk_CreateBlkObj { BLK_OBJ_ATTR BLK_OBJ } {
  upvar $BLK_OBJ_ATTR blk_obj_attr
  upvar $BLK_OBJ blk_obj

  set blk_obj [new block]
  block::setvalue $blk_obj blk_obj_attr
  block::DefaultValue $blk_obj blk_obj_attr
}

proc PB_blk_RetDisVars {OBJ_LIST NAME_LIST WORD_DESC_ARRAY POST_OBJ} {
  upvar $OBJ_LIST obj_list
  upvar $NAME_LIST name_list
  upvar $WORD_DESC_ARRAY word_desc_array
  upvar $POST_OBJ post_obj
 
  set ind 0
  
  foreach object $obj_list\
  {
    set name_list($ind) $block::($object,block_name)
    incr ind
  }
  
  set word_desc_temp_list $Post::($post_obj,word_desc_array)
  array set word_desc_array $word_desc_temp_list
}

proc PB_blk_AddNewBlkElem {BASE_ELEMENT INDEX WORD_MOM_VAR} {
  upvar $BASE_ELEMENT base_element
  upvar $INDEX index
  upvar $WORD_MOM_VAR word_mom_var

  global post_object
  
  array set word_mom_var_list $Post::($post_object,word_mom_var)

  set word_mom_var [lindex $word_mom_var_list($base_element) $index]
}

proc PB_blk_BlkGetNewElemObjAttr { BLK_ELEM_ADR_NAME BLK_ELEM_MOM_VAR\
                                   BLK_ELEM_OBJ_ATTR } {
  upvar $BLK_ELEM_ADR_NAME blk_elem_adr_name
  upvar $BLK_ELEM_MOM_VAR blk_elem_mom_var
  upvar $BLK_ELEM_OBJ_ATTR blk_elem_obj_attr

  global post_object
  set add_obj_list $Post::($post_object,add_obj_list)

  PB_com_RetObjFrmName blk_elem_adr_name add_obj_list blk_elem_add_obj
  PB_blk_RetWordDescArr blk_elem_adr_name elem_word_desc blk_elem_mom_var

  set blk_elem_obj_attr(0) $blk_elem_add_obj
  set blk_elem_obj_attr(1) $blk_elem_mom_var
  set blk_elem_obj_attr(2) "blank"
  set blk_elem_obj_attr(3) $elem_word_desc
  set blk_elem_obj_attr(4) 0
}

proc PB_blk_AddNewBlkElemObj { BLK_ELEM_ADR_NAME BLK_ELEM_MOM_VAR\
                               BLK_OBJ_ATTR NEW_ELEM_OBJ } {
  upvar $BLK_ELEM_ADR_NAME blk_elem_adr_name
  upvar $BLK_ELEM_MOM_VAR blk_elem_mom_var
  upvar $BLK_OBJ_ATTR blk_obj_attr
  upvar $NEW_ELEM_OBJ new_elem_obj

  PB_blk_BlkGetNewElemObjAttr blk_elem_adr_name blk_elem_mom_var \
                              blk_elem_obj_attr
  PB_blk_CreateBlkElemObj blk_elem_obj_attr new_elem_obj blk_obj_attr
}

proc PB_blk_BlkApplyObjAttr {BLK_OBJECT BLK_OBJ_ATTR_IMG BLK_OBJ_ATTR_TEXT \
                             BLK_OBJ_ATTR_ADR BLK_OBJ_ATTR_OBJ BLK_OBJ_ATTR_OPT_IMG \
                             WORD_NAME_LIST} {
  upvar $BLK_OBJECT blk_object
  upvar $BLK_OBJ_ATTR_IMG blk_obj_attr_img
  upvar $BLK_OBJ_ATTR_TEXT blk_obj_attr_text
  upvar $BLK_OBJ_ATTR_ADR blk_obj_attr_adr
  upvar $BLK_OBJ_ATTR_OBJ blk_obj_attr_obj
  upvar $BLK_OBJ_ATTR_OPT_IMG blk_obj_attr_opt_img
  upvar $WORD_NAME_LIST word_name_list

  set no_of_elems [array size blk_obj_attr_obj]
  for {set cnt 0} {$cnt < $no_of_elems} {incr cnt}\
  {
     set blk_elem_img_name $blk_obj_attr_img($cnt)
     set blk_elem_app_text $blk_obj_attr_text($cnt)
     set blk_elem_adr_name $blk_obj_attr_adr($cnt)

     PB_blk_BlkGetNewElemObjAttr blk_elem_img_name blk_elem_app_text \
                                 blk_elem_adr_name blk_elem_obj_attr \
                                 blk_elem_obj_list

     set blk_elem_obj_attr(3) $blk_obj_attr_opt_img($cnt)
     block_element::setvalue $blk_obj_attr_obj($cnt) blk_elem_obj_attr
  }
  
  if {$no_of_elems > 0}\
  {
     set block_obj_attr(0) $block::($blk_object,block_name)
     set block_obj_attr(1) $no_of_elems
     set block_obj_attr(2) $blk_elem_obj_list
     set block_obj_attr(3) $word_name_list
     block::setvalue $blk_object block_obj_attr
  }
}

proc PB_blk_RetValidCboxBlkElemAddr {ELEM_ADDRESS BASE_ELEMENT_LIST} {
  upvar $ELEM_ADDRESS elem_address
  upvar $BASE_ELEMENT_LIST base_element_list
 
  global post_object
  set add_obj_list $Post::($post_object,add_obj_list)

  switch $elem_address\
  {
       K_cycle - K  {
                         set addr_name "K_cycle"
                         PB_com_RetObjFrmName addr_name add_obj_list add_obj
                         set first_kcy_name $address::($add_obj,add_leader)
                         set addr_name "K"
                         PB_com_RetObjFrmName addr_name add_obj_list add_obj
                         set first_k_name  $address::($add_obj,add_leader)
                         if {![string compare $first_kcy_name $first_k_name]}\
                         {
                            switch $elem_address\
                            {
                                 K_cycle {lappend base_element K}
                                 K       {lappend base_element K_cycle}
                            }
                         }
                     }
       dwell - 
       cycle_dwell -
       P_cutcom      {
                         set addr_name "dwell"
                         PB_com_RetObjFrmName addr_name add_obj_list add_obj
                         set first_dw_name $address::($add_obj,add_leader)
                         set addr_name "cycle_dwell"
                         PB_com_RetObjFrmName addr_name add_obj_list add_obj
                         set first_cd_name  $address::($add_obj,add_leader)
                         set addr_name "P_cutcom"
                         PB_com_RetObjFrmName addr_name add_obj_list add_obj
                         set first_pcc_name  $address::($add_obj,add_leader)
                         if {![string compare $first_dw_name $first_cd_name]}\
                         {
                            switch $elem_address\
                            {
                                dwell       {lappend base_element cycle_dwell}
                                cycle_dwell {lappend base_element dwell}
                            }
                         } 

                         if {![string compare $first_dw_name $first_pcc_name]}\
                         {
                            switch $elem_address\
                            {
                                dwell {lappend base_element P_cutcom}
                                P_cutcom {lappend base_element dwell}
                            }      
                         }

                         if {![string compare $first_cd_name $first_pcc_name]}\
                         {
                             switch $elem_address\
                             {
                                cycle_dwell {lappend base_element P_cutcom}
                                P_cutcom {lappend base_element cycle_dwell}
                             }      
                          }
                     }

      cycle_step1 - I {
                         set addr_name "cycle_step1"
                         PB_com_RetObjFrmName addr_name add_obj_list add_obj
                         set first_ics_name $address::($add_obj,add_leader)
                         set addr_name "I"
                         PB_com_RetObjFrmName addr_name add_obj_list add_obj
                         set first_i_name  $address::($add_obj,add_leader)
                         if {![string compare $first_ics_name $first_i_name]}\
                         {
                              switch $elem_address\
                              {
                                 cycle_step1 {lappend base_element I}
                                 I           {lappend base_element cycle_step1}
                              }
                          }
                      }
     cycle_step - 
     Q_cutcom         {
                         set addr_name "cycle_step"
                         PB_com_RetObjFrmName addr_name add_obj_list add_obj
                         set first_q_name $address::($add_obj,add_leader)
                         set addr_name "Q_cutcom"
                         PB_com_RetObjFrmName addr_name add_obj_list add_obj
                         set first_qcc_name  $address::($add_obj,add_leader)
                         if {![string compare $first_q_name $first_qcc_name]}\
                         {
                              switch $elem_address\
                              {
                                 cycle_step {lappend base_element Q_cutcom}
                                 Q_cutcom   {lappend base_element cycle_step}
                              }
                         }
                       }
  }

  lappend base_element $elem_address

  if {[info exists base_element]}\
  {
     set base_element_list $base_element
     unset base_element
  }
}

proc PB_blk_CreateComboBoxElems {BLK_ELEM_OBJ_LIST POST_OBJ ADD_NAMES} {
  upvar $BLK_ELEM_OBJ_LIST blk_elem_obj_list
  upvar $POST_OBJ post_obj
  upvar $ADD_NAMES add_name_list 

  set add_name_list $Post::($post_obj,word_name_list)
  
  foreach element $blk_elem_obj_list\
  {
    set add_obj $block_element::($element,elem_add_obj)
    set add_name $address::($add_obj,add_name)
    PB_blk_RetValidCboxBlkElemAddr add_name base_element_list 
    
     if {[info exists base_element_list]}\
     {
         foreach element $base_element_list\
         {
            set test_flag [lsearch $add_name_list $element]
            set add_name_list [lreplace $add_name_list $test_flag $test_flag]
         }
     } else\
     {
        set add_name $address::($add_obj,add_name)
        set test_flag [lsearch $add_name_list $add_name]
        if {$test_flag != -1}\
        {
            set add_name_list [lreplace $add_name_list $test_flag $test_flag]
        }
     }
  }
}

proc PB_blk_BlkDisParams {BLK_OBJECT WORD_NAME_LIST BAL_WORD_DESC_ARR} {
  upvar $BLK_OBJECT blk_object
  upvar $WORD_NAME_LIST word_name_list
  upvar $BAL_WORD_DESC_ARR bal_word_desc_arr

  set blk_elem_obj $block::($blk_object,elem_addr_list)
  
  set ind 0
  foreach object $blk_elem_obj\
  {
     set blk_obj_attr_text($ind) $block_element::($object,elem_append_text)
     set blk_obj_attr_mom($ind) $block_element::($object,elem_mom_variable)
     set blk_elem_add_obj $block_element::($object,elem_add_obj)
     set blk_obj_attr_adr($ind) $address::($blk_elem_add_obj,add_name)
     incr ind
  }
  
  PB_blk_RetWordDescArr blk_obj_attr_adr bal_word_desc_arr blk_obj_attr_mom
  set word_name_list $block::($blk_object,addr_names)
  PB_blk_SortComboBoxElems word_name_list
}

proc PB_blk_BlkDefObjAttr {BLK_OBJECT BLK_OBJ_ATTR_IMG BLK_OBJ_ATTR_TEXT BLK_OBJ_ATTR_ADR \
                      BLK_OBJ_ATTR_OPT_IMG BLK_ELEM_OBJ_ARRAY WORD_NAME_LIST BAL_WORD_DESC_ARR} {
  upvar $BLK_OBJECT blk_object
  upvar $BLK_OBJ_ATTR_IMG blk_obj_attr_img
  upvar $BlK_OBJ_ATTR_TEXT blk_obj_attr_text
  upvar $BLK_OBJ_ATTR_ADR blk_obj_attr_adr
  upvar $BLK_OBJ_ATTR_OPT_IMG blk_obj_attr_opt_img
  upvar $BLK_ELEM_OBJ_ARRAY blk_elem_obj_array
  upvar $WORD_NAME_LIST word_name_list
  upvar $BAL_WORD_DESC_ARR bal_word_desc_arr

  set ind 0
  set def_blk_attr_list $block::($blk_object,def_value)
  array set def_blk_attr_arr $def_blk_attr_list
  
    if {[array exists blk_obj_attr_img] != 0}\
    {
       unset blk_obj_attr_img
       unset blk_obj_attr_text
       unset blk_obj_attr_adr
       unset blk_obj_attr_opt_img
       unset blk_elem_obj_array
    }
  
  foreach object $def_blk_attr_arr(2)\
  {
     set def_value_list $block_element::($object,def_value)
     array set def_value_array $def_value_list
     set blk_obj_attr_img($ind) $def_value_array(0)
     set blk_obj_attr_text($ind) $def_value_array(4)
     set blk_obj_attr_mom($ind) $def_value_array(2)
     set blk_elem_add_obj $def_value_array(1)
     set blk_obj_attr_adr($ind) $address::($blk_elem_add_obj,add_name)
     set blk_obj_attr_opt_img($ind) $def_value_array(3)
     set blk_elem_obj_array($ind) $object
     incr ind
  }

  PB_blk_RetWordDescArr blk_obj_attr_adr bal_word_desc_arr blk_obj_attr_mom
  set word_name_list $def_blk_attr_arr(3)
  PB_blk_SortComboBoxElems word_name_list
}

proc PB_blk_RetWordDescArr {BLK_ELEM_ADDR ELEM_WORD_DESC BLK_ELEM_MOM_VAR} {
  upvar $BLK_ELEM_ADDR  elem_word_add
  upvar $ELEM_WORD_DESC elem_word_desc
  upvar $BLK_ELEM_MOM_VAR blk_elem_mom_var
  global post_object

  if { [string match user_* $elem_word_add]} \
  {
     set elem_word_desc "User Defined Address"
     return
  } elseif { $blk_elem_mom_var == "" } \
  {
     set elem_word_desc "User Defined Expression"
  }

  set add_obj_list $Post::($post_object,add_obj_list)
  array set word_desc_array $Post::($post_object,word_desc_array)
  array set word_mom_var_arr $Post::($post_object,word_mom_var)
  array set mom_sys_var_arr $Post::($post_object,mom_sys_var_list)
  set word_mom_test [lsearch $word_mom_var_arr($elem_word_add) \
                                                $blk_elem_mom_var]
  if {$word_mom_test != -1}\
  {
     set elem_word_desc [lindex $word_desc_array($elem_word_add) \
                                     $word_mom_test]
  } else\
  {
     switch $elem_word_add\
     {
       Text  {
                set elem_word_desc "Text String"
             }
     }
  }
}

proc PB_blk_SortComboBoxElems {WORD_NAME_LIST} {
  upvar $WORD_NAME_LIST word_name_list

  set word_name_list [lsort $word_name_list]
  set new_list ""
  foreach word_name $word_name_list\
  {
     if {[string match "G*" $word_name]} \
     {
        lappend new_list $word_name
        set word_name_list [lreplace $word_name_list \
                        [lsearch $word_name_list $word_name] \
                        [lsearch $word_name_list $word_name]]
     } elseif {[string match "M*" $word_name]} \
     {
        lappend new_list $word_name
        set word_name_list [lreplace $word_name_list \
                         [lsearch $word_name_list $word_name] \
                         [lsearch $word_name_list $word_name]]
     }
  }
  set word_name_list [join [lappend new_list $word_name_list]]
}

proc PB_blk_GetBlockNames { BLK_OBJ_LIST BLK_NAME_LIST } {
  upvar $BLK_OBJ_LIST blk_obj_list
  upvar $BLK_NAME_LIST blk_name_list

  foreach blk_obj $blk_obj_list \
  {
     lappend blk_name_list $block::($blk_obj,block_name)
  }

  if { ![info exists blk_name_list] } \
  {
     set blk_name_list ""
  }
}

proc PB_blk_CreateBlkFromBlkObj { BLK_OBJ_LIST ACT_BLK_OBJ OBJ_INDEX } {
  upvar $BLK_OBJ_LIST blk_obj_list
  upvar $ACT_BLK_OBJ act_blk_obj
  upvar $OBJ_INDEX obj_index

  block::readvalue $act_blk_obj act_blk_obj_attr
  PB_blk_GetBlockNames blk_obj_list blk_name_list
  PB_com_SetDefaultName blk_name_list act_blk_obj_attr

  foreach act_blk_elem $act_blk_obj_attr(2) \
  {
     block_element::readvalue $act_blk_elem act_blk_elem_attr
     PB_blk_CreateBlkElemObj act_blk_elem_attr new_elem_obj \
                             act_blk_obj_attr
     lappend new_blk_elem_list $new_elem_obj
  }

  if {[info exists new_blk_elem_list]} \
  {
     set act_blk_obj_attr(2) $new_blk_elem_list
  }

  PB_blk_CreateBlkObj act_blk_obj_attr new_blk_obj
  set blk_obj_list [linsert $blk_obj_list $obj_index $new_blk_obj]
}

#===========================================================================
proc PB_blk_RetBlkFrmBlkAttr { BLK_OBJ_ATTR BLK_VALUE } {
#===========================================================================
  upvar $BLK_OBJ_ATTR blk_obj_attr
  upvar $BLK_VALUE blk_value

  set blk_elem_obj_list $blk_obj_attr(2)
  # Applys the master sequence to row block elements
    UI_PB_com_ApplyMastSeqBlockElem blk_elem_obj_list

  set blk_value ""
  foreach block_elem $blk_elem_obj_list\
  {
     set add_obj $block_element::($block_elem,elem_add_obj)
     set add_name $address::($add_obj,add_name)
     set elem_mom_var $block_element::($block_elem,elem_mom_variable)
     set elem_opt_var $block_element::($block_elem,elem_opt_nows_var)

      switch $elem_opt_var\
      {
          blank    {
                     append temp_cmp_var $add_name \[ $elem_mom_var \]
                   }
          nows   -
          opt      {
                     append temp_cmp_var $add_name \
                             \[ $elem_mom_var \] \\ $elem_opt_var
                   }
          both     {
                     append temp_cmp_var $add_name \
                             \[ $elem_mom_var \] \\opt\\nows
                   }
          default  {
                     append temp_cmp_var $add_name \
                             \[ $elem_mom_var \]
                   }
      }
      lappend blk_value $temp_cmp_var
      unset temp_cmp_var
   }
}

#===========================================================================
proc PB_blk_BlockModality { BLK_OBJ MOD_ADD_LIST } {
#===========================================================================
  upvar $BLK_OBJ blk_obj
  upvar $MOD_ADD_LIST mod_add_list

  set mod_add_list ""
  block::readvalue $blk_obj blk_obj_attr
  foreach blk_elem_obj $blk_obj_attr(2) \
  {
     block_element::readvalue $blk_elem_obj blk_elem_obj_attr
     if { $blk_elem_obj_attr(4) } \
     {
        set add_name $address::($blk_elem_obj_attr(0),add_name)
        lappend mod_add_list $add_name
     }
     unset blk_elem_obj_attr
  }
  unset blk_obj_attr
}
