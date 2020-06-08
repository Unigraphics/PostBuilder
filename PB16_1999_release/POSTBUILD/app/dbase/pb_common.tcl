##############################################################################
# Description                                                                #
#     This file contains all the common functions dealing with the POST      #
# BUILDER Objects. This file contains some main functions which define data  #
# for the new BLOCK ELEMENT Object. All the baloon description for block     #
# elements are also done within that function. There are procedures that     #
# deal with the POST Object also in this file.                               #
# Revisions                                                                  #
#                                                                            #
#   Date        Who   Reason                                                 #
# 01-feb-1999   bmp   Initial                                                #
# 05-May-1999   mnb   Removed redundant procedures                           #
# 02-Jun-1999   mnb   Code Integration                                       #
# 10-Jun-1999   mnb   Added procedures to parse Word Seperator, End of Line  #
#                     and Sequence Number statements of Definition file      #
# 07-Sep-1999   mnb   Modified MapMOMVariable proceduer to handle expressions#
# 21-Sep-1999   mnb   Removed Duplicate proceduers                           #
# 13-Oct-1999   mnb   Gets the machin type & axisoptiosn from the kinematci  #
#                     variable mom_kin_machine_type                          #
#                                                                            #
# $HISTORY$                                                                  #
#                                                                            #
##############################################################################

#=============================================================================
#This procedure takes the name list and the object attribute as the input
#and sets a name defalut name for the new object to be created. It will cycle 
#through the name list and the valid name with "_number" will be set, where
#number is the incremental index number. Eg:"_1", "_2", "_3" etc.
#=============================================================================

proc PB_com_SetDefaultName {NAME_LIST OBJ_ATTR} {
  upvar $NAME_LIST name_list
  upvar $OBJ_ATTR obj_attr

  #Sets the count, and initializez the index and flags.
  set count [llength $name_list]
  set dindex 1
  set dflag 0
  set match_flag 0
  set obj_name $obj_attr(0)

  #If name list count is zero set the name as DEFAULT else add the index.
  if { $count == 0}\
  {
     set obj_attr(0) DEFAULT
  } else\
  {
     # Procedure call for finding out the correct index.
       set dindex 0
       PB_com_ValidateName name_list obj_attr(0) dindex
       if {$dindex} \
       {
         append name $obj_attr(0) _ $dindex
         set obj_attr(0) $name
         unset name
       } 
  }
# puts "After Processing the valus is : $obj_attr(0)"
}


#=============================================================================
#This is a recursive function which finds the correct index to be appended to
#to the DEFAULT string. This procedure takes the name list and the default 
#name as the input and sets the default name to the correct value.
#=============================================================================

proc PB_com_ValidateName {NAME_LIST DEF_NAME DINDEX} {
  upvar $NAME_LIST name_list
  upvar $DEF_NAME def_name
  upvar $DINDEX inx

  #Sets the count from the name list.
  set count [llength $name_list]

  #Checks the index of name in the list and if it matches the index in the
  #name list, the index is incremented else the first index value is set.
  #Eg: if DEFAULT_3 is there in the name list, and DEFAULT_1 and DEFAULT_2 
  #doesn't exist then DEFAULT_1 will be set for the new object.
  if {$inx} \
  {
      append act_name $def_name _ $inx
  } else \
  {
      set act_name $def_name
  }

  for {set i 0} {$i < $count} {incr i}\
  {
     set fmt_name [lindex $name_list $i]
     if { [string compare $act_name $fmt_name] == 0}\
     {
        incr inx
        PB_com_ValidateName name_list def_name inx
     } else\
     {
        continue
     }
  }
}

#=============================================================================
#This procedure takes the line as the input and removes the blanks from the 
#line and the line without blanks are output.
#=============================================================================

proc PB_com_RemoveBlanks {line} {
   upvar $line line_wob

   #Splits the line and sets the index of the first blank.
   set line_wob [split $line_wob]
   set blank_index [lsearch $line_wob \0]

   #Cycles through the list abd removes the blank.
   while { $blank_index >= 0}\
   {
      set line_wob [lreplace $line_wob $blank_index $blank_index]
      set blank_index [lsearch $line_wob \0]
   }
}

#=============================================================================
#This procedure takes the block naem with underscores as input, removes the
#underscores and converts the first letter of each word to upper case.
#eg: "example_template_name will get converted to "Example Template Name".
#=============================================================================

proc PB_com_GetModEvtBlkName {INP_NAME} {
  upvar $INP_NAME inp_name

  set temp_name [split $inp_name ""]
  set first_chr [string toupper [lindex $temp_name 0]]
  set temp_name [lreplace $temp_name 0 0 $first_chr]
  set und_sc_ind [lsearch $temp_name "_"]

  while { $und_sc_ind >= 0}\
  {
     set temp_name [lreplace $temp_name $und_sc_ind $und_sc_ind " "]
     set next_chr [string toupper [lindex $temp_name [expr $und_sc_ind + 1]]]
     set temp_name [lreplace $temp_name [expr $und_sc_ind + 1] \
                             [expr $und_sc_ind + 1] $next_chr]
     set und_sc_ind [lsearch $temp_name "_"]
  }
 
  set inp_name [join $temp_name ""]
}

#=============================================================================
#This is a common function which takes the object name, object list as input
#and outputs the object id for the object name. This functiion works for
#object types format, address, block, event and sequence.
#=============================================================================

proc PB_com_RetObjFrmName {OBJ_NAME OBJ_LIST RET_CODE} {
upvar $OBJ_NAME obj_name
upvar $OBJ_LIST obj_list
upvar $RET_CODE ret_code

  #If object list exists get the object id for the object name.
  if {[info exists obj_list] != 0}\
  {
     #Cycles through the object list.
     foreach object $obj_list\
     {
        #Sets the class name.
        set ClassName [string trim [classof $object] ::]

        #Depending on th eclass name the object names are found.
        switch $ClassName\
        {
            format    {set CheckName $format::($object,for_name)}
            address   {set CheckName $address::($object,add_name)}
            block     {set CheckName $block::($object,block_name)}
            event     {set CheckName $event::($object,event_name)}
            sequence  {set CheckName $sequence::($object,seq_name)}
        }
        
        #If object is found the id is returned else error code (0) is returned.
        if { [string compare $obj_name $CheckName] == 0 }\
        {
           set ret_code $object
           break
        } else\
        {
           set ret_code 0
        }
     }
  }
}

#=======================================================================
proc PB_com_WordSubNamesDesc {POST_OBJECT WORD_SUBNAMES_DESC_ARRAY \
                              WORD_MOM_VAR MOM_SYS_ARR} {
#=======================================================================
  upvar $POST_OBJECT post_object
  upvar $WORD_SUBNAMES_DESC_ARRAY word_subnames_desc_array
  upvar $WORD_MOM_VAR word_mom_var
  upvar $MOM_SYS_ARR mom_sys_arr

  array set add_name_arr $Post::($post_object,add_name_list)
  array set add_mom_var_arr $Post::($post_object,add_mom_var_list)

  set no_adds [array size add_name_arr]

  for {set count 0} {$count < $no_adds} {incr count} \
  {
     set add_name $add_name_arr($count)
     foreach line $add_mom_var_arr($count) \
     {
        set mom_sys_arr([lindex $line 0]) [lindex $line 1]
        lappend word_mom_var($add_name) [lindex $line 0]
        lappend word_subnames_desc_array($add_name) [lindex $line 2]
     }
  }
}

#=============================================================================
#This procedure sets the appended text for the addresses having multi
#character leaders. If the addresses have multi characeter leaders, then the
#image name will be blank and the leader plus the appended text together will
#be the appended text. Here the leaders are seperated from the appended text
#and made as the actual appended text for list searching.
#=============================================================================

proc PB_com_GetAppTxtForMultiCharLdrs {APP_TEXT ADD_NAME ACT_APP_TEXT} {
  upvar $APP_TEXT app_text
  upvar $ADD_NAME add_name
  upvar $ACT_APP_TEXT act_app_text

  global post_object

  #Sets the appended text and the address object list.
  set act_app_text $app_text
  set add_obj_list $Post::($post_object,add_obj_list)

  #Returns address object from address name.
  PB_com_RetObjFrmName add_name add_obj_list ret_code

  #If a valid id is returned, remove leader from the appended text.
  if {$ret_code != 0}\
  {
     set add_leader $address::($ret_code,add_leader)
     set add_srch [string first $add_leader $app_text]
     if {$add_srch != -1}\
     {
       set str_len [string length $add_leader]
       set act_app_text [string range $app_text $str_len end]
     }
  }
}

#=============================================================================
#This procedure sets the image name and appended text for image names that 
#doesn't belong from A-Z. For these cases the image names is set as blank and
#the image name and appended text are appended as the actual appended text.
#=============================================================================

proc PB_com_ValidateImgName {WORD_IMG_NAME WORD_APP_TEXT} {
  upvar $WORD_IMG_NAME word_img_name
  upvar $WORD_APP_TEXT word_app_text

  #Checks the image name and sets the image name and appended text if it is
  #not from A-Z.
  switch $word_img_name\
  {
     A - B - C - D - E -
     F - G - H - I - J -
     K - L - M - N - O -
     P - Q - R - S - T -
     U - V - W - X - Y -
     Z       {}
     default {
               #Appends the image name and appended text.
               append temp_app_text $word_img_name $word_app_text

               #Sets the appended text and image name.
               set word_app_text $temp_app_text
               set word_img_name blank
    
               #Unsets the appended text.
               unset temp_app_text
             }
  }
}

#=============================================================================
#This procedure takes the PUI file name and PUI file id as input and creates
# post object, parses the pui file and stores all the attributes in the 
#post object.
#=============================================================================

proc PB_com_ReadPuiFile {PuiFileName PuiFileID POST_OBJ} {
  upvar $PuiFileName FileName
  upvar $PuiFileID FileId
  upvar $POST_OBJ post_obj
  
  #Creates the post object
  set post_obj [new Post $FileName]

  #Creates the PUI File Object.
  set pui_file_obj [new ParseFile $FileId]

  #Invokes procedure for opening a file.
  File::OpenFileRead $pui_file_obj $FileName

  #Parses the PUI File.
  ParseFile::ParsePuiFile $pui_file_obj post_obj
}

#=============================================================================
#This procedure takes the cdl file name, cdl file id and the post object as
#the input and parses the ude file, stores all the attributes in the objects
#and finally the ude object is stored in the post object.
#=============================================================================

proc PB_com_ReadUdeFile {CDL_FILE_NAME CDL_FILE_ID POST_OBJ} {
  upvar $CDL_FILE_NAME cdl_file_name
  upvar $CDL_FILE_ID cdl_file_id
  upvar $POST_OBJ post_obj

  #Creates the UDE File Object.
  set ude_file_obj [new ParseFile $cdl_file_id]

  #Invokes procedure for opening a file.
  File::OpenFileRead $ude_file_obj $cdl_file_name

  #Parses the UDE File.
  ParseFile::ParseUdeFile $ude_file_obj post_obj
}

#=============================================================================
#This procedure takes the definition file name, definition file id and the
#post object as the input, parses the definition file, creates the format, 
#address and block objects and stores all th eobject list as post object 
#attributes.
#=============================================================================

proc PB_com_ReadDfltDefFile {DefFileName FILEID POST_OBJ} {
  upvar $DefFileName FileName
  upvar $FILEID FileId
  upvar $POST_OBJ post_obj

  global ListObjectList
  global ListObjectAttr

  set FObjIndex 0
  set AObjIndex 0
  set BObjIndex 0

  # Creates the definition file object.
    set pobj [new ParseFile $FileId]
    set Post::($post_obj,def_parse_obj) $pobj

  # Parses the Definition file
    ParseFile::ParseDefFile $pobj $FileName

  # Parses the Word Seperator portion
    ParseFile::ParseWordSep $pobj

  # Parses the End of line portion
    ParseFile::ParseEndOfLine $pobj

  # Parses the Sequence  portion
    ParseFile::ParseSequence $pobj

  # Parses the format portion of the definition file.
    ParseFile::ParseFormat $pobj FormatObjList

  # Parse Addresses from the Definition File, Create Valid Address
  # objects and then seggregate the addresses used for blocks
  # and that for the listing file. The block address object list
  # and the listing file address object list are then set as
  # post object attributes.

    ParseFile::ParseAddress $pobj AddObjList LfileAddObjList FormatObjList
    PB_adr_SortAddresses AddObjList

  # Stores the format object list as post object attribuite.
    Post::SetObjListasAttr $post_obj FormatObjList

  # Stores the address object list as post object attribute
    Post::SetObjListasAttr $post_obj AddObjList
    ListingFile::SetLfileAddObjList $post_obj LfileAddObjList

  # Creates the data for all the block elements.
    Post::WordAddNamesSubNamesDesc $post_obj

  # Sets the master sequence.
    Post::SetDefMasterSequence $post_obj AddObjList

  # Parses the block template portion of the definition file and stores the
  # block object list as the post object attribute.
    ParseFile::ParseBlockTemp $pobj BlockObjList AddObjList post_obj
    Post::SetObjListasAttr $post_obj BlockObjList

  # Returns the display variables for the Block page.
    PB_blk_RetDisVars BlockObjList BlockNameList WordDescArray post_obj

  # Returns the display variables for the List File page.
    set ListObjectList $Post::($post_obj,list_obj_list)
    PB_lfl_RetDisVars ListObjectList ListObjectAttr 
}

#=============================================================================
proc PB_com_MapMOMVariable { ADD_OBJ BLK_ELEM_MOM_VAR MOM_VAR_VALUE } {
#=============================================================================
  upvar $ADD_OBJ add_obj
  upvar $BLK_ELEM_MOM_VAR blk_elem_mom_var
  upvar $MOM_VAR_VALUE mom_var_value
 
  set add_name $address::($add_obj,add_name)

  if {[string compare $add_name "Text"] == 0} \
  {
    set mom_var_value $blk_elem_mom_var
  } else \
  {
      global post_object
      array set mom_sys_var_arr $Post::($post_object,mom_sys_var_list)
      set mom_var_names [array names mom_sys_var_arr]
      set var_index [lsearch $mom_var_names $blk_elem_mom_var]
      if { $var_index != -1 } \
      {
         set mom_var_value $mom_sys_var_arr($blk_elem_mom_var)
      } else \
      {
         set mom_var_value ""
      }
  }
}

#============================================================================
proc PB_com_GetMachAxisType { KINEMATIC_VARIABLES MACH_TYPE AXISOPTION } {
#============================================================================
  upvar $KINEMATIC_VARIABLES kinematic_variables
  upvar $MACH_TYPE mach_type
  upvar $AXISOPTION axisoption

  switch $kinematic_variables(mom_kin_machine_type) \
  {
    "3_axis_mill"       {
                           set mach_type "Mill"
                           set axisoption "3"
                        }

    "4_axis_head"       {
                           set mach_type "Mill"
                           set axisoption "4H"
                        }
 
    "4_axis_table"      {
                           set mach_type "Mill"
                           set axisoption "4T"
                        }

    "5_axis_dual_table" {
                           set mach_type "Mill"
                           set axisoption "5TT"
                        }

    "5_axis_dual_head"  {
                           set mach_type "Mill"
                           set axisoption "5HH"
                        }

    "5_axis_head_table" {
                           set mach_type "Mill"
                           set axisoption "5HT"

                        }

    "lathe"             {
                           set mach_type "Lathe"
                           set axisoption "2H"
                        }

    "2_axis_wedm"       {
                           set mach_type "Wire EDM"
                           set axisoption "2"
                        }

    "4_axis_wedm"       {
                           set mach_type "Wire EDM"
                           set axisoption "4"
                        }
    "mill_turn"         {
                           set mach_type "Mill/Turn"
                           set axisoption "3axis"
                        }
  }
}
