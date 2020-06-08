##############################################################################
# Description                                                                #
#     This file contains all functions dealing with the ADDRESS Object.      #
# The definition file is read and the respective ADDRESS Objects are         #
# created. All actions on the format page of the UI is mapped into the       #
# respective functions in this file through the interface file.              #
#                                                                            #
# Revisions                                                                  #
#                                                                            #
#   Date        Who   Reason                                                 #
# 01-feb-1999   bmp   Initial                                                #
# 07-Apr-1999   mnb   Removed puts                                           #
# 02-May-1999   mnb   Added a procedure, which return the address code for   #
#                     definition file.                                       #
# 02-Jun-1999   mnb   Code Integration                                       #
# 14-Jun-1999   mnb   Removed N from address list                            #
# 23-Jun-1999   mnb   Better parser                                          #
# 07-Sep-1999   mnb   Changed address attributes                             #
# 21-Sep-1999   mnb   Added Create, Cut & Paste address functions            #
#                                                                            #
# $HISTORY$                                                                  #
#                                                                            #
##############################################################################

#=============================================================================
#This procedure seggregates the lines valid for ADDRESS Object. 
#The input to the function is the FILE Object and the ADDRESS OBJECT List.
#This function is called from the classes.tcl file. The Definition file is
#read and the lines containing ADDRESS are passed into the secondary parsing
#function.
#=============================================================================

proc PB_adr_AdrInitParse {this OBJ_LIST FOBJ_LIST} {
   upvar $OBJ_LIST obj_list
   upvar $FOBJ_LIST fobj_list
   set add_start 0
   set ret_code 0

   array set address_arr $ParseFile::($this,address_list)
   array set arr_size $ParseFile::($this,arr_size_list)
   set file_name_list $ParseFile::($this,file_list)
   
   foreach f_name $file_name_list \
   {
      set no_of_address $arr_size($f_name,address)
      for {set count 0} {$count < $no_of_address} {incr count} \
      {
        set open_flag 0
        set close_flag 0
        set add_start 0
        foreach line $address_arr($f_name,$count,data) \
        {
          if {[string match "*ADDRESS*" $line]}\
          {
             set temp_line $line
             PB_com_RemoveBlanks temp_line
             set add_start 1
             # Initialize the address attribute values.
               PB_adr_InitAdrObj obj_attr

             set obj_attr(0) [lindex $temp_line 1]
             set obj_attr(8) [lindex $temp_line 1]
          }

          if { $add_start } \
          {
             if { $open_flag == 0} \
             {
                PB_mthd_CheckOpenBracesInLine line open_flag
             }

             if { $close_flag == 0} \
             {
                PB_mthd_CheckCloseBracesInLine line close_flag
             }

             if { $open_flag } \
             {
                # Removes all the blanks from a line
                  PB_com_RemoveBlanks line

                # Corresponding to each line the attributes are set.
                 switch -glob $line\
                 {
                   *FORMAT*  {
                                set obj_name [lindex $line 1]
       
                                # The FORMAT Object id is found out from 
                                # the format name.
                                  PB_com_RetObjFrmName obj_name fobj_list \
                                                       ret_code
                                  set obj_attr(1) $ret_code
                             }
                    *FORCE*  {
                                set obj_attr(2) [lindex $line 1]
                                set obj_attr(3) 1
                             }
                    *MAX*    {
                                set obj_attr(4) [lindex $line 1]
# Temp fix
#                               set obj_attr(5) 1
                                set obj_attr(5)
                             }
                    *MIN*    {
                                set obj_attr(6) [lindex $line 1]
# Temp fix
#                               set obj_attr(7) 1
                                set obj_attr(7)
                             }
                    *LEADER* {
                                # Extracts leader from the line
                                  PB_adr_ExtractLeader line leader
                                  set obj_attr(8) $leader
                             }
                    *TRAILER*   {
                                   set obj_attr(9) [lindex $line 1]
                                   set obj_attr(10) 1
                                }
                    *INCREMENTAL*  {
                                       set obj_attr(11) [lindex $line 1]
                                   }
                }
             }

             if { $close_flag } \
             {
                # Creates the address object after validating the name.
                  PB_adr_CreateValidAdrObj obj_attr obj_list
                  set add_start 0
                  set close_flag 0
             }
           }
        }
     }
   }
}

#===============================================================================
#This function takes the line as the input and extracts the leader from the line.
#The quotes are removed from the line string. All different combinations of the
#quotes are taken care in this function.
#===============================================================================

proc PB_adr_ExtractLeader {LINE LEADER} {
  upvar $LINE line
  upvar $LEADER leader
  
  #Testing for the left quote.
  set leader_part [lindex $line 1]
  set st_fst_test [string first \" $leader_part]
  set st_start [expr $st_fst_test + 1]
  
  #If left quote is there
  if {$st_fst_test != -1}\
  {
     set st_lst_test [string last \" $leader_part]
     set st_end [expr $st_lst_test - 1]
 
     #If the right quote is there.
     if {$st_lst_test != -1}\
     {
       set leader [string range $leader_part $st_start $st_end]
     } else\
     {
       #Only left quote is there.
       set leader [string range $leader_part $st_start end]
     }
  } else\
  {
     #Else set the leader
     set leader  $leader_part
  }
}

#===============================================================================
#This function takes the object attributes as the input and initializes the 
#attributes of the ADDRESS Object.
#===============================================================================

proc PB_adr_InitAdrObj {OBJ_ATTR} {
upvar $OBJ_ATTR obj_attr

  # Initialize the object attributes.The attributes are listed in the 
  # classes.tcl file.
    set obj_attr(0) ""
    set obj_attr(1) ""
    set obj_attr(2) ""
    set obj_attr(3) 1
    set obj_attr(4) ""
    set obj_attr(5) "truncate"
    set obj_attr(6) ""
    set obj_attr(7) "truncate"
    set obj_attr(8) ""
    set obj_attr(9) ""
    set obj_attr(10) 1
    set obj_attr(11) ""
    set obj_attr(12) ""
}

#===============================================================================
#This procedure takes the format object lits and adress object list as input,
#creates the dummy TEXT Address, which will be used to display Text Strings.
#The ADDRESS Object is then appended into the address object list.
#===============================================================================

proc PB_adr_CreateTextAddObj {ADD_OBJ_LIST FMT_OBJ_LIST} {
  upvar $ADD_OBJ_LIST add_obj_list
  upvar $FMT_OBJ_LIST fmt_obj_list
  
  set add_name "Text"
  # Returns the object id of Text address, if it exists
    PB_com_RetObjFrmName add_name add_obj_list ret_code
    if {$ret_code} { return }

  # Sets the format name used in the address as "String".
    set fmt_name "String"
 
  # Returns the object id from object name
    PB_com_RetObjFrmName fmt_name fmt_obj_list ret_code
    if { $ret_code == 0 } \
    {
       # Creates a new format by name String
         set fmt_str_obj_attr(0) "String"
         set fmt_str_obj_attr(1) "Text String"
         set fmt_str_obj_attr(2) 0
         set fmt_str_obj_attr(3) 0
         set fmt_str_obj_attr(4) 0
         set fmt_str_obj_attr(5) 0
         set fmt_str_obj_attr(6) 0
         set fmt_str_obj_attr(7) 0
         PB_fmt_CreateFmtObj fmt_str_obj_attr fmt_obj_list
         set ret_code [lindex $fmt_obj_list end]
    }

  #Initialize the address attribute values.
  PB_adr_InitAdrObj obj_attr
  
  #Sets the object name and format object.
  set obj_attr(0) "Text"
  set obj_attr(1) $ret_code
  
  #Creates the address object.
  PB_adr_CreateAdrObj obj_attr add_obj_list

  set no_adds [llength $add_obj_list]
  set object [lindex $add_obj_list [expr $no_adds - 1]]
  
  set mseq_attr(0) ""
  set mseq_attr(1) 0
  set mseq_attr(2) "Text String"
  set mseq_attr(3) $no_adds

  address::SetMseqAttr $object mseq_attr
  address::DefaultMseqAttr $object mseq_attr
}


#===============================================================================
#This procedure splits the address object list generated from the definition file
#into two seperate lists, the general address object list and the list file address
#object list. The address object list generated from the defenition file is passed
#into the function and list file object list is output, after removing the repective
#objects from the address object list, modifying it as general address object list.
#===============================================================================

proc PB_adr_SepBlkAndLFileAddLists {OBJ_LIST LF_OBJ_LIST} {
  upvar $OBJ_LIST obj_list
  upvar $LF_OBJ_LIST lf_obj_list
  
  foreach object $obj_list\
  {
    set add_name $address::($object,add_name)

    #Segregating the List File Addresses
    switch $add_name\
    {
       LF_ENUM  - LF_XABS  -
       LF_YABS  - LF_ZABS  -
       LF_AAXIS - LF_BAXIS -
       LF_FEED  - 
       LF_TIME  -
       LF_SPEED    {
                     lappend lf_obj_list $object
                     set obj_ind [lsearch $obj_list $object]
                     set obj_list [lreplace $obj_list $obj_ind $obj_ind]
                   }
    }      
  }
}


#===============================================================================
#This procedure creates a valid address object after checking the the name of the 
#object. The updated object list is output from the function.
#===============================================================================

proc PB_adr_CreateValidAdrObj {OBJ_ATTR OBJ_LIST} {
  upvar $OBJ_ATTR obj_attr
  upvar $OBJ_LIST obj_list
   
  set ret_code 0

  #Checking for the Occurance of an Address with the same name
  PB_com_RetObjFrmName obj_attr(0) obj_list ret_code

  if {!$ret_code}\
  { 
     #Creates the address object.
     PB_adr_CreateAdrObj obj_attr obj_list
  }
} 

#===============================================================================
#This function takes the object attributes and the latest ADDRESS object list
#as the input, creates the ADDRESS Object and returns the updated object list.
#===============================================================================

proc PB_adr_CreateAdrObj {OBJ_ATTR OBJ_LIST} {
  upvar $OBJ_ATTR obj_attr
  upvar $OBJ_LIST obj_list
  global post_object

  # Creates new object.
    set object [new address]

  # Appends object id to the object list.
    lappend obj_list $object

  # sets the latest value to the object created.
    address::setvalue $object obj_attr
  
  # Sets the default value to the object.
    address::DefaultValue $object obj_attr
#    puts "The ADD object is created : $object"

  # Appends the address to the format object
    set fmt_obj $obj_attr(1)
    format::AddToAddressList $fmt_obj object

  # Sets the master sequence attributes
    set addr_name $obj_attr(0)
    array set mseq_word_param $Post::($post_object,msq_word_param)
    if {[info exists mseq_word_param($addr_name)]} \
    {
       set addr_mseq_param $mseq_word_param($addr_name)
       set mseq_attr(0) [lindex $addr_mseq_param 0]
       set mseq_attr(1) [lindex $addr_mseq_param 1]
       set mseq_attr(2) [lindex $addr_mseq_param 2]
       set seq_no [lsearch $Post::($post_object,msq_add_name) $addr_name]
       set mseq_attr(3) $seq_no
    } elseif {[string compare $addr_name "N"] == 0} \
    {
       set mseq_attr(0) ""
       set mseq_attr(1) 0
       set mseq_attr(2) "Sequence Number"
       set seq_no [llength $Post::($post_object,msq_add_name)]
       set mseq_attr(3) $seq_no
    } else \
    {
       set mseq_attr(0) ""
       set mseq_attr(1) 0
       set mseq_attr(2) ""
       set seq_no [llength $Post::($post_object,msq_add_name)]
       set mseq_attr(3) $seq_no
    }
    address::SetMseqAttr $object mseq_attr
    address::DefaultMseqAttr $object mseq_attr
}

#===============================================================================
proc PB_adr_GetAddressNameList { ADD_OBJ_LIST ADD_NAME_LIST} {
#===============================================================================
  upvar $ADD_OBJ_LIST add_obj_list
  upvar $ADD_NAME_LIST add_name_list

  foreach add_obj $add_obj_list \
  {
     lappend add_name_list $address::($add_obj,add_name)
  }

  if {![info exists add_name_list]} \
  {
     set add_name_list ""
  }
}

#===============================================================================
proc PB_adr_SortAddresses { ADD_OBJ_LIST } {
#===============================================================================
  upvar $ADD_OBJ_LIST add_obj_list

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

#===============================================================================
proc PB_adr_RetAddressObjList { ADDR_OBJ_LIST } {
#===============================================================================
  upvar $ADDR_OBJ_LIST addr_obj_list
  global post_object

  set addr_obj_list $Post::($post_object,add_obj_list)
}

#===============================================================================
proc PB_adr_RetAddressNameList { ADDR_OBJ_LIST ADDR_NAME_LIST } {
#===============================================================================
  upvar $ADDR_OBJ_LIST addr_obj_list
  upvar $ADDR_NAME_LIST addr_name_list

  set addr_name_list ""
  foreach add_obj $addr_obj_list \
  {
     lappend addr_name_list $address::($add_obj,add_name)
  }
}

#===============================================================================
#This procedure is called from the UI APPLY button through the interface.
#The object list, name list, Object attributes and Object index is input
#to the function and the values are stored in the corresponding object
#and then the data is retrieved and dipalyed in the UI.
#===============================================================================

proc PB_adr_ApplyAdrObj {OBJ_LIST FOBJ_LIST OBJ_ATTR ADDR_OBJ} {
  upvar $OBJ_LIST obj_list
  upvar $FOBJ_LIST fobj_list
  upvar $OBJ_ATTR obj_attr
  upvar $ADDR_OBJ addr_obj

  # sets the format object
    PB_com_RetObjFrmName obj_attr(1) fobj_list ret_code
    set obj_attr(1) $ret_code
     
  # Gets the present attributes of address
    address::readvalue $addr_obj pres_obj_attr

  # Sets the value of the object.
    address::setvalue $addr_obj obj_attr

  if {$obj_attr(1) != $pres_obj_attr(1)} \
  {
     format::DeleteFromAddressList $pres_obj_attr(1) addr_obj
     format::AddToAddressList $obj_attr(1) addr_obj
  }
}

#===============================================================================
#This procedure reads the default value of a ADDRESS Object. The Object list and the
#Object index is given as input and the default value is read and stored in the
#Object attribute.
#===============================================================================

proc PB_adr_DefAdrObjAttr {OBJ_LIST OBJ_ATTR OBJ_INDEX} {
  upvar $OBJ_LIST obj_list
  upvar $OBJ_ATTR obj_attr
  upvar $OBJ_INDEX   obj_index

  #Sets the Object from the list.
  set object [lindex $obj_list $obj_index]

  #Reads the default value of the object and set it to the Object attribute.
  set default_value $address::($object,def_value)
  array set obj_attr $default_value

  #Sets the format name from the format object.
  set obj_attr(1) $format::($obj_attr(1),for_name)
}

#===============================================================================
proc PB_adr_RetAddFrmAddAttr { OBJ_ATTR ADD_VALUE } {
#===============================================================================
  upvar $OBJ_ATTR obj_attr
  upvar $ADD_VALUE add_value

  for {set jj 1} {$jj < 11} {incr jj}\
  {
     switch $jj\
     {
        1     {
                 if {$obj_attr($jj) != ""} {
                   set for_name $format::($obj_attr($jj),for_name)
                   lappend add_value "FORMAT  $for_name"
                 }
              }
        2     {
                 if {$obj_attr($jj) != ""}\
                 {
                    lappend add_value "FORCE   $obj_attr($jj)"
                 }
              }
        4     {
                 if {$obj_attr($jj) != ""}\
                 {
                    lappend add_value "MAX     $obj_attr($jj)"
                 }
              }
        6     {
                 if {$obj_attr($jj) != ""}\
                 {
                    lappend add_value "MIN     $obj_attr($jj)"
                 }
              }
        8     {
                 if {[string compare $obj_attr(0) $obj_attr($jj)]} \
                 {
                    lappend add_value "LEADER  \"$obj_attr($jj)\""
                 }
              }
        9     {
                 if {$obj_attr($jj) != ""}\
                 {
                    lappend add_value "TRAILER \"$obj_attr($jj)\""
                 }
               }
     }
  }
}

#===============================================================================
# This function is called from the interface file, the callback from the 
# "Create" button of the Address page. New ADDRESS Object is created taking 
# the object attribute, object list name list and object index from the UI 
# passed through the interface file.
#===============================================================================

proc PB_adr_CreateNewAdrObj { OBJ_LIST OBJ_ATTR OBJ_INDEX} {
  upvar $OBJ_LIST obj_list
  upvar $OBJ_ATTR obj_attr
  upvar $OBJ_INDEX obj_index

  # The address object is created. Format object is retrieved from 
  # the format name
    PB_adr_CreateAdrObj obj_attr obj_list

  #Sets the object index for the new object. if the index is null sets to zero.
  if {$obj_index == ""}\
  {
     set obj_index 0
  } else\
  {
     incr obj_index
  }

  # Finding the length of the object list.
    set length [llength $obj_list]

  # The newely created object is removed from the list.
    set RearrObj [lindex $obj_list [expr $length -1]]

  # The newely created object is removed and inserted in the 
  # correct object index.
    set obj_list [lreplace $obj_list [expr $length - 1] [expr $length -1]]
    set obj_list [linsert $obj_list $obj_index $RearrObj]

  # Sets master sequence parameters
    # Add master sequence parameters here, to sequence the new address
    set mseq_attr(0) "\$mom_usd_add_var"
    set mseq_attr(1) 0
    set mseq_attr(2) "User Defined Address"
    set mseq_attr(3) [llength $obj_list]
    address::SetMseqAttr $RearrObj mseq_attr
    address::DefaultMseqAttr $RearrObj mseq_attr
}

#===============================================================================
# This procedure reads value from the buffer object, creates a new ADDRESS 
# Object and #stores the value in the new object,  and returns the value to 
# the UI. The Input to the procedure are object list, name list, object, 
# object index and buffer object and the output from the procedure is the 
# updated name and object list along with the display attributes for the new 
# PASTE object.
#===============================================================================
proc PB_adr_PasteAdrBuffObj { ADD_OBJ_LIST BUFF_OBJ_ATTR ADD_MSEQ_ATTR \
                              OBJ_INDEX } {
  upvar $ADD_OBJ_LIST add_obj_list
  upvar $BUFF_OBJ_ATTR buff_obj_attr
  upvar $ADD_MSEQ_ATTR add_mseq_attr
  upvar $OBJ_INDEX obj_index
  global post_object

  # Create new Address Object with the attributes read from the buffer object.
    set fmt_obj_list $Post::($post_object,fmt_obj_list)
    PB_com_RetObjFrmName buff_obj_attr(1) fmt_obj_list ret_code
    set buff_obj_attr(1) $ret_code
    PB_adr_CreateAdrObj buff_obj_attr add_obj_list

  # If the count is greater than or equal to one insert the PASTE Object
  # after the current object
    set count [llength $add_obj_list]
    set Rearrange_I [expr $count - 1]
    set LastElement [lindex $add_obj_list $Rearrange_I]
    address::SetMseqAttr $LastElement add_mseq_attr
    address::DefaultMseqAttr $LastElement add_mseq_attr

    if { $obj_index == ""} \
    {
       set obj_index 0
    } elseif { $count > 1} \
    {
       incr obj_index
       set add_obj_list [lreplace $add_obj_list $Rearrange_I $Rearrange_I]
       set add_obj_list [linsert $add_obj_list $obj_index $LastElement]
    }
}
