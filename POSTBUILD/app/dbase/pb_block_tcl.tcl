#20

#=======================================================================
proc PB_blk_BlkInitParse { this OBJ_LIST ADDOBJ_LIST POST_OBJ } {
  upvar $OBJ_LIST obj_list
  upvar $ADDOBJ_LIST addobj_list
  upvar $POST_OBJ post_obj
  global gPB
  set add_start 0
  set add_count 0
  set blk_elem_obj_list ""
  if { [info exists gPB(old_version_pui_idx)] } {
   set parse_old_version_flag $gPB(parse_old_version_flag)
   } else {
   set parse_old_version_flag 0
  }
  set old_version_blk_name_list ""
  array set block_temp_arr $ParseFile::($this,block_temp_list)
  array set arr_size $ParseFile::($this,arr_size_list)
  set comp_blk_list [lindex $Post::($post_obj,comp_blk_list) 0]
  set file_name_list $ParseFile::($this,file_list)
  if 0 {
   set nf [expr [llength $file_name_list] - 1]
   for { set i $nf } { $i >= 0 } { incr i -1 } {
    lappend file_list [lindex $file_name_list $i]
   }
  }
  set mdef [lindex $file_name_list 0]
  set file_list [lreplace $file_name_list 0 0]
  lappend file_list $mdef
  UI_PB_debug_ForceMsg "\n ++++++ Parsing Block from files: $file_list\n"
  foreach f_name $file_list \
  {
   if { ![string match $f_name $Post::($post_obj,def_file)] } {
    set gPB(CR8_EXT_OBJ) 1
    } else {
    set defined_blk_list [list]
   }
   set no_of_blocks $arr_size($f_name,block)
   for { set count 0 } { $count < $no_of_blocks } { incr count } \
   {
    set blk_start 0
    set open_flag 0
    set close_flag 0
    foreach line $block_temp_arr($f_name,$count,data) \
    {
     UI_PB_debug_ForceMsg "BLOCK -->$line<"
     if { [string match "*BLOCK_TEMPLATE*" $line] } \
     {
      set temp_line $line
      PB_com_RemoveBlanks temp_line
      set blk_name [lindex $temp_line 1]
      set comp_flag -1
      set comp_flag [lsearch $comp_blk_list $blk_name]
      if { !$gPB(DISABLE_COMP_BLK) } {
       if { $comp_flag != -1 } { break }
       } else {
       if { $comp_flag != -1 } {
        set idx [string last "_" $blk_name]
        set blk [string range $blk_name 0 [expr $idx - 1]]
        set seq_list { prog_start oper_start oper_end prog_end }
        foreach seq $seq_list {
         set evt_list ${seq}_evt_list
         set blk_list ${seq}_evt_blk_list
         set n_evt [expr [llength $Post::($post_obj,$evt_list)] / 2]
         array set evt_name_arr   $Post::($post_obj,$evt_list)
         array set evt_blk_arr    $Post::($post_obj,$blk_list)
         for { set ie 0 } { $ie < $n_evt } { incr ie } {
          set n_blk [llength $evt_blk_arr($ie)]
          set evt [join [split [string tolower $evt_name_arr($ie)]] _]
          for { set ib 0 } { $ib < $n_blk } { incr ib } {
           if { [llength [lindex $evt_blk_arr($ie) $ib]] == 1 } {
            continue
            } else {
            set evt [join [split [string tolower $evt_name_arr($ie)]] _]
            if { ![string compare $blk $evt] } {
             set evt_blk_arr($ie) [lreplace $evt_blk_arr($ie) $ib $ib $blk_name]
             set comp_blk_list [lreplace $comp_blk_list $comp_flag $comp_flag]
             UI_PB_debug_ForceMsg "\n ++++++ Comp Block replaced $seq $evt $blk_name\n"
            }
           }
          }
         }
         set Post::($post_obj,$blk_list) [array get evt_blk_arr]
         PB_com_unset_var evt_name_arr
         PB_com_unset_var evt_blk_arr
        }
       }
      } ;# gPB(DISABLE_COMP_BLK)
      set blk_obj_attr(0) [lindex $temp_line 1]
      if 0 {
       if { [string match "rapid_traverse_*" $blk_obj_attr(0)] || \
        [string match "rapid_spindle_*"  $blk_obj_attr(0)] } {
        continue
        } else {
        set blk_start 1
       }
       } else {
       if { [string match "rapid_traverse_xy" $blk_obj_attr(0)] || \
        [string match "rapid_traverse_yz" $blk_obj_attr(0)] || \
        [string match "rapid_traverse_xz" $blk_obj_attr(0)] || \
        [string match "rapid_spindle_x"   $blk_obj_attr(0)] || \
        [string match "rapid_spindle_y"   $blk_obj_attr(0)] || \
        [string match "rapid_spindle_z"   $blk_obj_attr(0)] } {
        continue
        } else {
        set blk_start 1
        if { $::gPB(CR8_EXT_OBJ) == 0 } {
         if { [lsearch $defined_blk_list $blk_obj_attr(0)] > -1 } {
          set blk_obj_attr(0) [PB_com_GetNextObjName $blk_obj_attr(0) block]
          UI_PB_debug_ForceMsg "\n ++++++ New for duplicate Block : $blk_obj_attr(0)\n"
         }
        }
        if { $parse_old_version_flag } {
         lappend old_version_blk_name_list $blk_obj_attr(0)
        }
       }
      }
     }
     if {$blk_start} \
     {
      if {$open_flag == 0} \
      {
       PB_com_CheckOpenBracesInLine line open_flag
       set blk_elem_obj_list ""
       if {$open_flag} \
       {
        set line [string trimleft $line]
        set line [string range $line 1 end]
       }
      }
      if {$close_flag == 0} \
      {
       PB_com_CheckCloseBracesInLine line close_flag
       if {$close_flag} \
       {
        set line [string trimright $line]
        set line [string range $line 0 [expr [string length $line] - 2]]
       }
      }
      if {$open_flag} \
      {
       set line [string trim $line]
       if { ![string match "" $line] } \
       {
        PB_blk_CreateBlkElems line blk_elem_obj_list blk_obj_attr addobj_list
       }
      }
      if {$close_flag} \
      {
       if { $blk_elem_obj_list != "" } \
       {
        PB_blk_CreateBlock blk_obj_attr obj_list blk_elem_obj_list post_obj
        set blk_elem_obj_list ""
        if { $::gPB(CR8_EXT_OBJ) == 0 } {
         lappend defined_blk_list $blk_obj_attr(0)
        }
       }
       set blk_start 0
      }
     }
    }
   }
   set ::gPB(CR8_EXT_OBJ) 0
  }
  if { $gPB(DISABLE_COMP_BLK) == 1 } {
   set Post::($post_obj,comp_blk_list) [lreplace $Post::($post_obj,comp_blk_list) 0 0]
  }
  PB_blk_SetRapidBlockObjs post_obj obj_list
  if { $parse_old_version_flag && [llength $old_version_blk_name_list] > 0 } {
   PB_blk_UpdateBlockModality post_obj old_version_blk_name_list
  }
 }

#=======================================================================
proc PB_blk_CheckJoinBrace_left { LINE } {
  upvar $LINE line
  set test [string first "\{" $line]
   if {$test != -1}\
   {
    set line [string range $line [expr $test + 1] end]
   }
  }

#=======================================================================
proc PB_blk_CheckJoinBrace_right { LINE } {
  upvar $LINE line
 set test [string last "\}" $line]
 if {$test != -1}\
 {
  set line [string range $line 0 [expr $test - 1]]
 }
}

#=======================================================================
proc PB_blk_CreateBlkElems { LINE BLK_ELEM_OBJ_LIST BLK_OBJ_ATTR ADDOBJ_LIST} {
  upvar $LINE line
  upvar $BLK_ELEM_OBJ_LIST blk_elem_obj_list
  upvar $BLK_OBJ_ATTR blk_obj_attr
  upvar $ADDOBJ_LIST addobj_list
  PB_blk_SplitBlkTmplElem line blk_elem_obj_list blk_obj_attr addobj_list
 }

#=======================================================================
proc PB_blk_SplitBlkTmplElem { SplitVar BLK_ELEM_OBJ_LIST BLK_OBJ_ATTR \
  ADDOBJ_LIST } {
  upvar $SplitVar split_var
  upvar $BLK_ELEM_OBJ_LIST blk_elem_obj_list
  upvar $BLK_OBJ_ATTR blk_obj_attr
  upvar $ADDOBJ_LIST addobj_list
  PB_blk_BlkOptNowsCheck split_var blk_elem_obj_attr
  set addr_found 0
  if { [string index $split_var 0] != "\"" } {
   set trim_char [string first "\[" $split_var]
   set trim_char1 [string last "\]" $split_var]
   if { $trim_char > 0  &&  $trim_char1 > 0 } {
    set addr_found 1
   }
  }
  if { $addr_found } \
  {
   set text_flag 0
   set blk_elem_obj_attr(0) [string range $split_var 0 [expr $trim_char - 1]]
   if 0 {
    set blk_obj_list $Post::($::post_object,blk_obj_list)
    PB_com_RetObjFrmName blk_obj_attr(0) blk_obj_list blk_obj
    if { $blk_obj > 0 } {
     foreach elem $block::($blk_obj,elem_addr_list) \
     {
      set add_obj $block_element::($elem,elem_add_obj)
      set add_name $address::($add_obj,add_name)
      if { ![string compare $blk_elem_obj_attr(0) $add_name] } {
       return
      }
     }
    }
   }
   if { $::gPB(DISABLE_COMP_BLK) == 1 } {
    foreach elem $blk_elem_obj_list {
     set add_obj $block_element::($elem,elem_add_obj)
     set add_name $address::($add_obj,add_name)
     if [string compare "Text" $add_name] {
      if { ![string compare $blk_elem_obj_attr(0) $add_name] &&\
       ![string compare $blk_obj_attr(0) $block_element::($elem,parent_name)] } {
       return
      }
     }
    }
   }
   set temp_var [string range $split_var [expr $trim_char + 1] \
   [expr $trim_char1 - 1]]
   set blk_elem_obj_attr(1) $temp_var
  } else \
  {
   set blk_elem_obj_attr(0) "Text"
  set split_var [string trimright $split_var \}]
  set split_var [string range $split_var 1 [expr [string length $split_var] - 2]]
  set blk_elem_obj_attr(1) $split_var
 }
 PB_blk_BlkElemForceOpt blk_obj_attr(0) blk_elem_obj_attr
 switch $blk_elem_obj_attr(0) \
 {
  LF_ENUM  - LF_XABS  -
  LF_YABS  - LF_ZABS  -
  LF_AAXIS - LF_BAXIS -
  LF_FEED  - LF_TIME  -
  LF_SPEED   {
   PB_blk_RetLfileAddObjFromList blk_elem_obj_attr
   set ignore 0
  }
  default    {
   if { [string first # $blk_elem_obj_attr(0)] == -1 } \
   {
    PB_com_RetObjFrmName blk_elem_obj_attr(0) addobj_list ret_code
    if [PB_file_is_JE_POST_DEV] {
     if { $ret_code == 0 } \
     {
      global post_object
      PB_adr_InitAdrObj addr_attr
      set addr_attr(0)  "$blk_elem_obj_attr(0)"         ;# name
      set addr_attr(1)  "String"                        ;# Format
      set addr_attr(8)  [string index $addr_attr(0) 0]  ;# Use 1st char as leader
      set addr_attr(14) 1                               ;# is_dummy
      PB_adr_CreateAdrObj addr_attr addobj_list
      PB_com_RetObjFrmName blk_elem_obj_attr(0) addobj_list ret_code
      Post::SetObjListasAttr $post_object addobj_list
     }
    }
    if { $ret_code == 0 } \
    {
     return [tk_messageBox -parent [UI_PB_com_AskActiveWindow] \
     -type ok -icon error -message "Block element $blk_elem_obj_attr(0)\
     not found in definition file."]
    }
    set blk_elem_obj_attr(0) $ret_code
    set addr_name $address::($blk_elem_obj_attr(0),add_name)
    PB_blk_RetWordDescArr addr_name elem_word_desc blk_elem_obj_attr(1)
    set blk_elem_obj_attr(3) $elem_word_desc
    set ignore 0
   } else \
   {
    set ignore 1
   }
  }
 }
 if { !$ignore } \
 {
  PB_blk_CreateBlkElemObj blk_elem_obj_attr new_elem_obj blk_obj_attr
  lappend blk_elem_obj_list $new_elem_obj
 }
}

#=======================================================================
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

#=======================================================================
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
   if { $block_name == "rapid_traverse" || \
   $block_name == "rapid_spindle" } \
   {
    if { [lsearch $mod_add_list "rapid1"] != -1 && \
    $blk_elem_obj_attr(0) == "X" } \
    {
     set blk_elem_obj_attr(4) 1
    }
    if { [lsearch $mod_add_list "rapid2"] != -1 && \
    $blk_elem_obj_attr(0) == "Y" } \
    {
     set blk_elem_obj_attr(4) 1
    }
    if { [lsearch $mod_add_list "rapid3"] != -1 && \
    $blk_elem_obj_attr(0) == "Z" } \
    {
     set blk_elem_obj_attr(4) 1
    }
   }
  } else \
  {
   set blk_elem_obj_attr(4) 0
  }
 }

#=======================================================================
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

#=======================================================================
proc PB_blk_CreateBlkElemObj {BLK_ELEM_OBJ_ATTR NEW_ELEM_OBJ BLK_OBJ_ATTR} {
  upvar $BLK_ELEM_OBJ_ATTR blk_elem_obj_attr
  upvar $NEW_ELEM_OBJ new_elem_obj
  upvar $BLK_OBJ_ATTR blk_obj_attr
  set new_elem_obj [new block_element $blk_obj_attr(0)]
  block_element::setvalue $new_elem_obj blk_elem_obj_attr
  block_element::DefaultValue $new_elem_obj blk_elem_obj_attr
  set add_obj $blk_elem_obj_attr(0)
  if { $add_obj != "" } \
  {
   address::AddToBlkElemList $add_obj new_elem_obj
   address::AddToBlkElemList $add_obj new_elem_obj
  }
 }

#=======================================================================
proc PB_blk_CreateBlock { BLK_OBJ_ATTR BLK_OBJ_LIST BLK_ELEM_OBJ_LIST \
  POST_OBJ } {
  upvar $BLK_ELEM_OBJ_LIST blk_elem_obj_list
  upvar $BLK_OBJ_ATTR blk_obj_attr
  upvar $BLK_OBJ_LIST blk_obj_list
  upvar $POST_OBJ post_obj
  array set word_mom_var_list $Post::($post_obj,word_mom_var)
  set add_mom_var_list [list]
  if [info exists word_mom_var_list(Operator_Message)] {
   set add_mom_var_list $word_mom_var_list(Operator_Message)
  }
  set blk_obj_attr(1) [llength $blk_elem_obj_list]
  set blk_obj_attr(2) $blk_elem_obj_list
  if { [lsearch $add_mom_var_list $blk_obj_attr(0)] != -1 } \
  {
   set blk_obj_attr(3) "comment"
   PB_blk_CreateBlkObj blk_obj_attr object
   PB_blk_AddToCommentList object post_obj
   } elseif { [string compare $blk_obj_attr(0) "comment_data"] != 0 } \
  {
   set ret_code 0
   PB_com_RetObjFrmName blk_obj_attr(0) blk_obj_list ret_code
   if { $ret_code != 0 } \
   {
    set index [lsearch $blk_obj_list $ret_code]
    set blk_obj_list [lreplace $blk_obj_list $index $index]
    PB_com_DeleteObject $ret_code
   }
   set blk_obj_attr(3) "normal"
   PB_blk_CreateBlkObj blk_obj_attr object
   lappend blk_obj_list $object
  } else \
  {
   if { 0 && $Post::($post_obj,list_obj_list) != "" } {}
   set blk_obj_attr(3) "normal"
   PB_blk_CreateBlkObj blk_obj_attr object
   PB_lfl_AttrFromDef object post_obj
  }
 }

#=======================================================================
proc PB_blk_AddToCommentList { COMMENT_BLK POST_OBJ } {
  upvar $COMMENT_BLK comment_blk
  upvar $POST_OBJ post_obj
  array set mom_var_arr $Post::($post_obj,mom_sys_var_list)
  set blk_elem [lindex $block::($comment_blk,elem_addr_list) 0]
  set block_element::($blk_elem,elem_add_obj) "Comment"
  set elem_mom_var "$block_element::($blk_elem,elem_mom_variable)"
  set block_element::($blk_elem,elem_mom_variable) $elem_mom_var
  set block_element::($blk_elem,elem_desc) "Operator Message"
  block_element::readvalue $blk_elem blk_elem_attr
  block_element::DefaultValue $blk_elem blk_elem_attr
  set comment_blk_list $Post::($post_obj,comment_blk_list)
  lappend comment_blk_list $comment_blk
  set Post::($post_obj,comment_blk_list) $comment_blk_list
 }

#=======================================================================
proc PB_blk_CreateCommentBlk { BLK_NAME BLK_ELEM BLK_OBJ POST_OBJ } {
  upvar $BLK_NAME blk_name
  upvar $BLK_ELEM blk_elem
  upvar $BLK_OBJ blk_obj
  upvar $POST_OBJ post_obj
  set blk_attr(0) $blk_name
  set blk_attr(1) 1
  set blk_attr(2) $blk_elem
  set blk_attr(3) "comment"
  PB_blk_CreateBlkObj blk_attr blk_obj
  PB_blk_AddToCommentList blk_obj post_obj
 }

#=======================================================================
proc PB_blk_CreateCommentBlkElem { ELEM_NAME BLK_ELEM_OBJ } {
  upvar $ELEM_NAME elem_name
  upvar $BLK_ELEM_OBJ blk_elem_obj
  set blk_elem_obj_attr(0) "Comment"
  set blk_elem_obj_attr(1) ""
  set blk_elem_obj_attr(2) blank
  set blk_elem_obj_attr(3) "Operator Message"
  set blk_elem_obj_attr(4) 0
  set blk_obj_attr(0) $elem_name
  PB_blk_CreateBlkElemObj blk_elem_obj_attr blk_elem_obj blk_obj_attr
 }

#=======================================================================
proc PB_blk_CreateCmdBlkObj { CMD_BLK_NAME CMD_BLK_ELEM CMD_BLK_OBJ } {
  upvar $CMD_BLK_NAME cmd_blk_name
  upvar $CMD_BLK_ELEM cmd_blk_elem
  upvar $CMD_BLK_OBJ cmd_blk_obj
  set cmd_blk_attr(0) $cmd_blk_name
  set cmd_blk_attr(1) 1
  set cmd_blk_attr(2) $cmd_blk_elem
  set cmd_blk_attr(3) "command"
  PB_blk_CreateBlkObj cmd_blk_attr cmd_blk_obj
 }

#=======================================================================
proc PB_blk_CreateCmdBlkElem { CMD_ELEM_NAME CMD_OBJ CMD_BLK_ELEM } {
  upvar $CMD_ELEM_NAME cmd_elem_name
  upvar $CMD_OBJ cmd_obj
  upvar $CMD_BLK_ELEM cmd_blk_elem
  set blk_elem_obj_attr(0) "Command"
  if { $cmd_obj } \
  {
   set blk_elem_obj_attr(1) $cmd_obj
   set blk_elem_obj_attr(3) "Custom Command"
  } else \
  {
   set blk_elem_obj_attr(1) $cmd_elem_name
   set blk_elem_obj_attr(3) "MOM Command"
  }
  set blk_elem_obj_attr(2) blank
  set blk_elem_obj_attr(4) 0
  set cmd_blk_attr(0) $cmd_elem_name
  PB_blk_CreateBlkElemObj blk_elem_obj_attr cmd_blk_elem cmd_blk_attr
  if { $cmd_obj } \
  {
   command::AddToBlkElemList $cmd_obj cmd_blk_elem
   command::AddToBlkElemList $cmd_obj cmd_blk_elem
  }
 }

#=======================================================================
proc PB_blk_CreateBlkObj { BLK_OBJ_ATTR BLK_OBJ } {
  upvar $BLK_OBJ_ATTR blk_obj_attr
  upvar $BLK_OBJ blk_obj
  PB_mthd_SetObjExtAttr blk_obj_attr "block"
  set blk_obj [new block]
  block::setvalue $blk_obj blk_obj_attr
  block::DefaultValue $blk_obj blk_obj_attr
  PB_mthd_CatalogPostExtObj blk_obj_attr "block"
 }

#=======================================================================
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

#=======================================================================
proc PB_blk_AddNewBlkElem {BASE_ELEMENT INDEX WORD_MOM_VAR} {
  upvar $BASE_ELEMENT base_element
  upvar $INDEX index
  upvar $WORD_MOM_VAR word_mom_var
  global post_object
  array set word_mom_var_list $Post::($post_object,word_mom_var)
  set word_mom_var [lindex $word_mom_var_list($base_element) $index]
 }

#=======================================================================
proc PB_blk_BlkGetNewElemObjAttr { BLK_ELEM_ADR_NAME BLK_ELEM_MOM_VAR\
  BLK_ELEM_OBJ_ATTR } {
  upvar $BLK_ELEM_ADR_NAME blk_elem_adr_name
  upvar $BLK_ELEM_MOM_VAR blk_elem_mom_var
  upvar $BLK_ELEM_OBJ_ATTR blk_elem_obj_attr
  global post_object
  if { [string compare $blk_elem_adr_name "rapid1"] == 0 || \
   [string compare $blk_elem_adr_name "rapid2"] == 0 ||
  [string compare $blk_elem_adr_name "rapid3"] == 0 } \
  {
   set rap_add_list $Post::($post_object,rap_add_list)
   PB_com_RetObjFrmName blk_elem_adr_name rap_add_list blk_elem_add_obj
   set elem_word_desc $address::($blk_elem_add_obj,word_desc)
  } else \
  {
   set add_obj_list $Post::($post_object,add_obj_list)
   PB_com_RetObjFrmName blk_elem_adr_name add_obj_list blk_elem_add_obj
   PB_blk_RetWordDescArr blk_elem_adr_name elem_word_desc blk_elem_mom_var
  }
  set blk_elem_obj_attr(0) $blk_elem_add_obj
  set blk_elem_obj_attr(1) $blk_elem_mom_var
  set new_mom_list [split $blk_elem_mom_var \$]
  if { [llength $new_mom_list] > 2 } \
  {
   set blk_elem_obj_attr(2) "opt"
  } else \
  {
   set blk_elem_obj_attr(2) "blank"
  }
  set blk_elem_obj_attr(3) $elem_word_desc
  set blk_elem_obj_attr(4) 0
 }

#=======================================================================
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

#=======================================================================
proc PB_blk_RetValidCboxBlkElemAddr {ELEM_ADDRESS BASE_ELEMENT_LIST} {
  upvar $ELEM_ADDRESS elem_address
  upvar $BASE_ELEMENT_LIST base_element_list
  global post_object
  set add_obj_list $Post::($post_object,add_obj_list)
  switch "$elem_address" \
  {
   "K_cycle"        -
   "K"              {
    set addr_name "K_cycle"
    PB_com_RetObjFrmName addr_name add_obj_list add_obj
    if { [info exists address::($add_obj,add_leader)] } {
     set first_kcy_name $address::($add_obj,add_leader)
     } else {
     set first_kcy_name ""
    }
    set addr_name "K"
    PB_com_RetObjFrmName addr_name add_obj_list add_obj
    if { [info exists address::($add_obj,add_leader)] } {
     set first_k_name $address::($add_obj,add_leader)
     } else {
     set first_k_name ""
    }
    if { ![string compare $first_kcy_name $first_k_name] } \
    {
     switch "$elem_address" \
     {
      "K_cycle" {lappend base_element K}
      "K"       {lappend base_element K_cycle}
     }
    }
   }
   "dwell" -
   "cycle_dwell" -
   "P_cutcom"       {
    set addr_name "dwell"
    PB_com_RetObjFrmName addr_name add_obj_list add_obj
    if { [info exists address::($add_obj,add_leader)] } {
     set first_dw_name $address::($add_obj,add_leader)
     } else {
     set first_dw_name ""
    }
    set addr_name "cycle_dwell"
    PB_com_RetObjFrmName addr_name add_obj_list add_obj
    if { [info exists address::($add_obj,add_leader)] } {
     set first_cd_name $address::($add_obj,add_leader)
     } else {
     set first_cd_name ""
    }
    set addr_name "P_cutcom"
    PB_com_RetObjFrmName addr_name add_obj_list add_obj
    if { [info exists address::($add_obj,add_leader)] } {
     set first_pcc_name $address::($add_obj,add_leader)
     } else {
     set first_pcc_name ""
    }
    if { ![string compare $first_dw_name $first_cd_name] } \
    {
     switch "$elem_address" \
     {
      "dwell"       { lappend base_element cycle_dwell }
      "cycle_dwell" { lappend base_element dwell }
     }
    }
    if { ![string compare $first_dw_name $first_pcc_name] } \
    {
     switch "$elem_address" \
     {
      "dwell"    { lappend base_element P_cutcom }
      "P_cutcom" { lappend base_element dwell }
     }
    }
    if { ![string compare $first_cd_name $first_pcc_name] } \
    {
     switch "$elem_address" \
     {
      "cycle_dwell" { lappend base_element P_cutcom }
      "P_cutcom"    { lappend base_element cycle_dwell }
     }
    }
   }
   "cycle_step1" -
   "I"              {
    set addr_name "cycle_step1"
    PB_com_RetObjFrmName addr_name add_obj_list add_obj
    if { [info exists address::($add_obj,add_leader)] } {
     set first_ics_name $address::($add_obj,add_leader)
     } else {
     set first_ics_name ""
    }
    set addr_name "I"
    PB_com_RetObjFrmName addr_name add_obj_list add_obj
    if { [info exists address::($add_obj,add_leader)] } {
     set first_i_name  $address::($add_obj,add_leader)
     } else {
     set first_i_name ""
    }
    if {![string compare $first_ics_name $first_i_name]}\
    {
     switch "$elem_address" \
     {
      "cycle_step1" { lappend base_element I }
      "I"           { lappend base_element cycle_step1 }
     }
    }
   }
   "cycle_step" -
   "Q_cutcom"       {
    set addr_name "cycle_step"
    PB_com_RetObjFrmName addr_name add_obj_list add_obj
    if { [info exists address::($add_obj,add_leader)] } {
     set first_q_name $address::($add_obj,add_leader)
     } else {
     set first_q_name ""
    }
    set addr_name "Q_cutcom"
    PB_com_RetObjFrmName addr_name add_obj_list add_obj
    if { [info exists address::($add_obj,add_leader)] } {
     set first_qcc_name $address::($add_obj,add_leader)
     } else {
     set first_qcc_name ""
    }
    if { ![string compare $first_q_name $first_qcc_name] } \
    {
     switch "$elem_address" \
     {
      "cycle_step" { lappend base_element Q_cutcom }
      "Q_cutcom"   { lappend base_element cycle_step }
     }
    }
   }
  }
  lappend base_element $elem_address
  if { [info exists base_element] }\
  {
   set base_element_list $base_element
   unset base_element
  }
 }

#=======================================================================
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

#=======================================================================
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

#=======================================================================
proc PB_blk_RetWordDescArr {BLK_ELEM_ADDR ELEM_WORD_DESC BLK_ELEM_MOM_VAR} {
  upvar $BLK_ELEM_ADDR  elem_word_add
  upvar $ELEM_WORD_DESC elem_word_desc
  upvar $BLK_ELEM_MOM_VAR blk_elem_mom_var
  global post_object
  global gPB
  if 0 {
   if 0 {
    if { [string match user_* $elem_word_add]} \
    {
     set elem_word_desc "$gPB(block,new,word_desc,Label)"
     return
     } elseif { [string match \$mom* $blk_elem_mom_var] == 0 } \
    {
     set elem_word_desc "$gPB(block,user,word_desc,Label)"
     return
    }
    } else {
    if { [string match user_* $elem_word_add]} \
    {
     set elem_word_desc "$gPB(block,new,word_desc,Label)"
     return
     } elseif { ![string match "*\$mom*" $blk_elem_mom_var] } \
    {
     set elem_word_desc "$gPB(block,user,word_desc,Label)"
     return
    }
   }
  }
  set add_obj_list $Post::($post_object,add_obj_list)
  array set word_desc_array $Post::($post_object,word_desc_array)
  array set word_mom_var_arr $Post::($post_object,word_mom_var)
  array set mom_sys_var_arr $Post::($post_object,mom_sys_var_list)
  if { [info exists word_mom_var_arr($elem_word_add)] } \
  {
   set word_mom_test [lsearch $word_mom_var_arr($elem_word_add) \
   $blk_elem_mom_var]
   if {$word_mom_test != -1} \
   {
    set elem_word_desc [lindex $word_desc_array($elem_word_add) \
    $word_mom_test]
   } else \
   {
    switch $elem_word_add \
    {
     Text    { set elem_word_desc "$gPB(block,text,word_desc,Label)" }
     default { set elem_word_desc "$gPB(block,user,word_desc,Label)" }
    }
   }
  } else \
  {
   set elem_word_desc "$gPB(block,user,word_desc,Label)"
  }
 }

#=======================================================================
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

#=======================================================================
proc PB_blk_GetBlockNames { BLK_OBJ_LIST BLK_NAME_LIST } {
  upvar $BLK_OBJ_LIST blk_obj_list
  upvar $BLK_NAME_LIST blk_name_list
  set blk_name_list ""
  foreach blk_obj $blk_obj_list \
  {
   lappend blk_name_list $block::($blk_obj,block_name)
  }
 }

#=======================================================================
proc PB_blk_GetCmdNamelist { CMD_BLK_LIST CMD_NAME_LIST } {
  upvar $CMD_BLK_LIST cmd_blk_list
  upvar $CMD_NAME_LIST cmd_name_list
  set cmd_name_list ""
  foreach cmd_obj $cmd_blk_list \
  {
   lappend cmd_name_list $command::($cmd_obj,name)
  }
 }

#=======================================================================
proc NIU__PB_blk_CreateCmdBlkFromCmdBlkObj { CMD_BLK_LIST CMD_BLK_OBJ OBJ_INDEX} {
  upvar $CMD_BLK_LIST cmd_blk_list
  upvar $CMD_BLK_OBJ cmd_blk_obj
  upvar $OBJ_INDEX obj_index
  block::readvalue $cmd_blk_obj act_blk_obj_attr
  set blk_elem_obj [lindex $act_blk_obj_attr(2) 0]
  set cmd_obj $block_element::($blk_elem_obj,elem_mom_variable)
  if { [string match "*MOM_*" $cmd_obj] == 0 } \
  {
   PB_pps_CreateCmdFromCmdObj cmd_blk_list cmd_obj obj_index
   set new_cmd_obj [lindex $cmd_blk_list $obj_index]
   set act_blk_obj_attr(0) $command::($new_cmd_obj,name)
  } else \
  {
   set new_cmd_obj 0
  }
  set new_blk_elem_list ""
  PB_blk_CreateCmdBlkElem act_blk_obj_attr(0) new_cmd_obj cmd_blk_elem
  lappend new_blk_elem_list $cmd_blk_elem
  set act_blk_obj_attr(2) $new_blk_elem_list
  PB_blk_CreateCmdBlkObj act_blk_obj_attr(0) act_blk_obj_attr(2) new_cmd_blk
 }

#=======================================================================
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

#=======================================================================
proc PB_blk_CreateCopyOfABlock { ACT_BLK_OBJ NEW_BLK_OBJ } {
  upvar $ACT_BLK_OBJ act_blk_obj
  upvar $NEW_BLK_OBJ new_blk_obj
  block::readvalue $act_blk_obj act_blk_obj_attr
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
 }

#=======================================================================
proc PB_blk_RetBlkFrmBlkAttr__backup_Jul-20-2016 { BLK_OBJ_ATTR BLK_VALUE args } {
  upvar $BLK_OBJ_ATTR blk_obj_attr
  upvar $BLK_VALUE blk_value
  global post_object
  set elem_flag [lindex $args 0]
  set blk_elem_obj_list $blk_obj_attr(2)
  if { $blk_obj_attr(3) != "command" && \
   $blk_obj_attr(3) != "comment" && \
  $blk_obj_attr(3) != "macro" } \
  {
   UI_PB_com_ApplyMastSeqBlockElem blk_elem_obj_list $elem_flag
  }
  set blk_value ""
  set temp_cmp_var ""
  foreach block_elem $blk_elem_obj_list\
  {
   if { $elem_flag == "" } \
   {
    block_element::readvalue $block_elem blk_elem_obj_attr
    array set mom_var_arr $Post::($post_object,mom_sys_var_list)
   } else \
   {
    array set blk_elem_obj_attr $block_element::($block_elem,def_value)
    array set mom_var_arr $Post::($post_object,def_mom_sys_var_list)
   }
   set elem_opt_var $blk_elem_obj_attr(2)
   set add_obj $blk_elem_obj_attr(0)
   set elem_mom_var $blk_elem_obj_attr(1)
   if { $add_obj == "Command" || \
    $add_obj == "Comment" || \
   $add_obj == "Macro" } \
   {
    set add_name ""
   } else \
   {
    set add_name $address::($add_obj,add_name)
   }
   if { $add_name != "" } \
   {
    append temp_cmp_var $add_name \[ $elem_mom_var \]
    switch $elem_opt_var\
    {
     nows   -
     opt      {
      append temp_cmp_var \\$elem_opt_var
     }
     both     {
      append temp_cmp_var \\opt\\nows
     }
     default  {
     }
    }
    } elseif { $add_name == "" && $add_obj == "Comment" } \
   {
    if [string match "$::gPB(tcl_line_blk)*" $blk_obj_attr(0)] {
     append temp_cmp_var "# $elem_mom_var"
     } else {
     append temp_cmp_var "\"$mom_var_arr(Comment_Start)"
     append temp_cmp_var "$elem_mom_var"
     append temp_cmp_var "$mom_var_arr(Comment_End)\""
    }
   } else \
   {
    append temp_cmp_var "\"$elem_mom_var\""
   }
   lappend blk_value $temp_cmp_var
   unset temp_cmp_var
  }
 }

#=======================================================================
proc PB_blk_RetBlkFrmBlkAttr { BLK_OBJ_ATTR BLK_VALUE args } {
  upvar $BLK_OBJ_ATTR blk_obj_attr
  upvar $BLK_VALUE blk_value
  global post_object
  set elem_flag [lindex $args 0]
  set blk_elem_obj_list $blk_obj_attr(2)
  if { $blk_obj_attr(3) != "command" && \
   $blk_obj_attr(3) != "comment" && \
  $blk_obj_attr(3) != "macro" } \
  {
   UI_PB_com_ApplyMastSeqBlockElem blk_elem_obj_list $elem_flag
  }
  set blk_value    ""
  set temp_cmp_var ""
  foreach block_elem $blk_elem_obj_list \
  {
   if { $elem_flag == "" } \
   {
    block_element::readvalue $block_elem blk_elem_obj_attr
    array set mom_var_arr $Post::($post_object,mom_sys_var_list)
   } else \
   {
    array set blk_elem_obj_attr $block_element::($block_elem,def_value)
    array set mom_var_arr $Post::($post_object,def_mom_sys_var_list)
   }
   set elem_opt_var $blk_elem_obj_attr(2)
   set add_obj $blk_elem_obj_attr(0)
   set elem_mom_var $blk_elem_obj_attr(1)
   if { $add_obj == "Command" || \
    $add_obj == "Comment" || \
   $add_obj == "Macro" } \
   {
    set add_name ""
   } else \
   {
    set add_name $address::($add_obj,add_name)
   }
   if { $add_name != "" } \
   {
    append temp_cmp_var $add_name \[ $elem_mom_var \]
    switch $elem_opt_var\
    {
     nows   -
     opt      {
      append temp_cmp_var \\$elem_opt_var
     }
     both     {
      append temp_cmp_var \\opt\\nows
     }
     default  {
     }
    }
   } else \
   {
    if { $add_obj == "Comment" } \
    {
     if [string match "$::gPB(tcl_line_blk)*" $blk_obj_attr(0)] {
      append temp_cmp_var "# $elem_mom_var"
      } else {
      append temp_cmp_var "\"$mom_var_arr(Comment_Start)"
      append temp_cmp_var "$elem_mom_var"
      append temp_cmp_var "$mom_var_arr(Comment_End)\""
     }
     } elseif { $add_obj == "Command" } \
    {
     UI_PB_debug_ForceMsg "\n ++++++ [info level 0] blk_obj_attr(0): $blk_obj_attr(0)\n"
     if [string match "$::gPB(condition_cmd_prefix)*" $blk_obj_attr(0)] {
      append temp_cmp_var "IF($elem_mom_var)"
      } else {
      append temp_cmp_var "$elem_mom_var"
     }
    } else \
    {
     append temp_cmp_var "\"$elem_mom_var\""
    }
   }
   lappend blk_value $temp_cmp_var
   unset temp_cmp_var
  }
 }

#=======================================================================
proc PB_blk_BlockModality { BLK_OBJ MOD_ADD_LIST } {
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

#=======================================================================
proc PB_blk_SetRapidBlockObjs { POST_OBJ BLK_OBJ_LIST } {
  upvar $POST_OBJ post_obj
  upvar $BLK_OBJ_LIST blk_obj_list
  array set mom_sys_arr $Post::($post_obj,mom_sys_var_list)
  set rapid_1 ""
  set rapid_2 ""
  if [info exists mom_sys_arr(\$pb_rapid_1)] {
   set rapid_1 $mom_sys_arr(\$pb_rapid_1)
  }
  if [info exists mom_sys_arr(\$pb_rapid_2)] {
   set rapid_2 $mom_sys_arr(\$pb_rapid_2)
  }
  set ret_code 0
  if { $rapid_1 != "" } \
  {
   PB_com_RetObjFrmName rapid_1 blk_obj_list ret_code
   if { $ret_code > 0 } \
   {
    set rapid_1 $ret_code
   } else \
   {
    set rapid_1 ""
   }
  }
  set ret_code 0
  if { $rapid_2 != "" } \
  {
   PB_com_RetObjFrmName rapid_2 blk_obj_list ret_code
   if { $ret_code > 0 } \
   {
    set rapid_2 $ret_code
   } else \
   {
    set rapid_2 ""
   }
  }
  set mom_sys_arr(\$pb_rapid_1) $rapid_1
  set mom_sys_arr(\$pb_rapid_2) $rapid_2
  UI_PB_debug_ForceMsg "\n ++++++ $mom_sys_arr(\$pb_rapid_1) id : $rapid_1 +++++\n"
  UI_PB_debug_ForceMsg "\n ++++++ $mom_sys_arr(\$pb_rapid_2) id : $rapid_2 +++++\n"
  set Post::($post_obj,mom_sys_var_list) [array get mom_sys_arr]
 }

#=======================================================================
proc PB_blk_RemoveTurboBlocks { } {
  global machData
  if { [string match $machData(0) "Mill"] &&\
   ( [string match $machData(1) "XZC"] || [string match $machData(1) "4-Axis"] ) } {
   global post_object
   set blk_obj_list $Post::($post_object,blk_obj_list)
   set temp_blk_list $blk_obj_list
   foreach one $blk_obj_list {
    set blk_name $block::($one,block_name)
    if { [string match "*_turbo" $blk_name] } {
     set idx [lsearch $temp_blk_list $one]
     set temp_blk_list [lreplace $temp_blk_list $idx $idx]
     PB_com_DeleteObject $one
    }
   }
   set Post::($post_object,blk_obj_list) $temp_blk_list
  }
 }

#=======================================================================
proc PB_blk_CreateFuncBlkElem { FUNC_ELEM_NAME FUNC_OBJ FUNC_BLK_ELEM } {
  upvar $FUNC_ELEM_NAME func_elem_name
  upvar $FUNC_OBJ func_obj
  upvar $FUNC_BLK_ELEM func_blk_elem
  set blk_elem_obj_attr(0) "Macro"
  if { $func_obj } {
   set blk_elem_obj_attr(1) $func_obj
   set blk_elem_obj_attr(3) ""
   } else {
   set blk_elem_obj_attr(1) $func_elem_name
   set blk_elem_obj_attr(3) ""
  }
  set blk_elem_obj_attr(2) blank
  set blk_elem_obj_attr(4) 0
  set func_blk_attr(0) $func_elem_name
  PB_blk_CreateBlkElemObj blk_elem_obj_attr func_blk_elem func_blk_attr
  if { $func_obj } {
   function::AddToBlkElemList $func_obj func_blk_elem
   function::AddToBlkElemList $func_obj func_blk_elem
  }
 }

#=======================================================================
proc PB_blk_CreateFuncBlkObj { BLK_NAME BLK_ELEM BLK_OBJ } {
  upvar $BLK_NAME blk_name
  upvar $BLK_ELEM blk_elem
  upvar $BLK_OBJ blk_obj
  set blk_attr(0) $blk_name
  set blk_attr(1) 1
  set blk_attr(2) $blk_elem
  set blk_attr(3) "macro"
  PB_blk_CreateBlkObj blk_attr blk_obj
 }

#=======================================================================
proc PB_blk_UpdateBlockModality { POST_OBJ BLK_NAME_LIST } {
  upvar $POST_OBJ post_obj
  upvar $BLK_NAME_LIST blk_name_list
  global gPB
  if { ![info exists gPB(old_version_pui_idx)] } {
   return
  }
  if { !$gPB(parse_old_version_flag) } {
   return
  }
  if { [info exists Post::($post_obj,blk_mod_list)] && \
   $Post::($post_obj,blk_mod_list) != "" } {
   array set blk_mod_arr $Post::($post_obj,blk_mod_list)
   foreach blk_name $blk_name_list {
    if { [info exists blk_mod_arr($blk_name)] } {
     unset blk_mod_arr($blk_name)
    }
   }
   set len [llength $Post::($post_obj,old_pui_blk_mod_list)]
   for { set i 0 } { $i < $len } { incr i 2 } {
    set temp_name [lindex $Post::($post_obj,old_pui_blk_mod_list) $i]
    set temp_val  [lindex $Post::($post_obj,old_pui_blk_mod_list) [expr $i + 1]]
    set blk_mod_arr($temp_name) $temp_val
   }
   set Post::($post_obj,blk_mod_list) [array get blk_mod_arr]
   } else {
   set Post::($post_obj,blk_mod_list) $Post::($post_obj,old_pui_blk_mod_list)
  }
 }