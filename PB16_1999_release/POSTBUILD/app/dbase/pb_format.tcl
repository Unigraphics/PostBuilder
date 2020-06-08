##############################################################################
# Description                                                                #
#     This file contains all functions dealing with the FORMAT Object.       #
# The definition file is read and the respective FORMAT Objects are          #
# created. All actions on the format page of the UI is mapped into the       #
# respective functions in this file through the interface file.              #
#                                                                            #
# Revisions                                                                  #
#                                                                            #
#   Date        Who   Reason                                                 #
# 01-feb-1999   bmp   Initial                                                #
# 07-Apr-1999   mnb   Removed puts                                           #
# 04-May-1999   mnb   Added procedures, which returns the format code for    #
#                     Definition file.                                       #
# 02-Jun-1999   mnb   Code Integration                                       #
# 16-Jun-1999   mnb   Corrected the  format                                  #
# 28-Jun-1999   mnb   Made changes to format output                          #
# 07-Sep-1999   mnb   Parses the & format and outputs the format in & format #
# 13-Oct-1999   mnb   Phase 20 Integration                                   #
#                                                                            #
# $HISTORY$                                                                  #
#                                                                            #
##############################################################################

#=============================================================================
#The input to the function is the FILE Object and the FORMAT OBJECT List.
#This function is called from the classes.tcl file. The Definition file is
#read and the lines containing FORMAT are passed into the secondary parsing
#function.
#=============================================================================

proc PB_fmt_FmtInitParse {this OBJ_LIST} {
  upvar $OBJ_LIST obj_list

  array set format_arr $ParseFile::($this,format_list)
  array set arr_size $ParseFile::($this,arr_size_list)
  set file_name_list $ParseFile::($this,file_list)

  foreach f_name $file_name_list \
  {
     set no_of_formats $arr_size($f_name,format)
     for {set count 0} {$count < $no_of_formats} {incr count} \
     {
        set format_data [lindex $format_arr($f_name,$count,data) 0]
        PB_com_RemoveBlanks format_data
        set format_text $format_arr($f_name,$count,text)
        PB_fmt_FmtSecParse format_data obj_list
     }
  }
}

#===============================================================================
#This function takes the line containing FORMAT as the input and the two portions
#of the line are split into the format name and the format value. The format value
#is then again split into respective attributes needed for the creation of the
#FORMAT object and the OBJECT List is returned.
#===============================================================================

proc PB_fmt_FmtSecParse {FMT_LINE OBJ_LIST} {
  upvar $FMT_LINE fmt_line
  upvar $OBJ_LIST obj_list

  set ret_code 0

  # Sets the first and second portion of the line as object attributes.
    set obj_attr(0) [lindex $fmt_line 1]
    set obj_attr(1) [lindex $fmt_line 2]

  # Returns the object id from object name.
    PB_com_RetObjFrmName obj_attr(0) obj_list ret_code

  # Checks the return code whether the object with the same name exists or not.
    if {!$ret_code}\
    {
      # The value portion of the line is split into the respective 
      # attributes of the FORMAT Object.
        if { [string first % $obj_attr(1)] != -1 } \
        {
            PB_fmt_SplitPercFormat obj_attr
        } elseif { [string first & $obj_attr(1)] != -1 } \
        {
            PB_fmt_SplitAmperSignFormat obj_attr
        }

      # The FORMAT Object is created passing the object attributes. 
      # The obj_list is the return list from the function which stores 
      # the "id" of the object created.
        PB_fmt_CreateFmtObj obj_attr obj_list
  }
}

#==============================================================================
#This function takes the object attributes and the updated FORMAT object list
#as the input, creates the FORMAT Object and returns the updated object list.
#==============================================================================

proc PB_fmt_CreateFmtObj { OBJ_ATTR OBJ_LIST } {
  upvar $OBJ_ATTR obj_attr
  upvar $OBJ_LIST obj_list

  # Creates new object.
    set object [new format]
  
  # Appends object id to the object list.
    lappend obj_list $object
  
  # sets the latest value to the object created.
    format::setvalue $object obj_attr
   
  # Sets the default value to the object.
    format::DefaultValue $object obj_attr
#    puts "The object is Created: $object "
}

#==============================================================================
proc PB_fmt_SplitAmperSignFormat { OBJ_ATTR } {
#==============================================================================
  upvar $OBJ_ATTR obj_attr

  # Splits each charater and stores it as a list.
    set attr_list [split $obj_attr(1) {}]

  # Sets default value for the object attributes
    set obj_attr(2) 0
    set obj_attr(3) 0
    set obj_attr(4) 0
    set obj_attr(5) ""
    set obj_attr(6) 0
    set obj_attr(7) ""

  set count 1
  foreach elem $attr_list \
  {
     if { [string compare $elem " "] == 0 || \
          [string compare $elem &] == 0 || \
          [string compare $elem \"] == 0 } \
     { 
        continue 
     }

     switch -- $count \
     {
        1  {
              switch -- $elem \
              {
                 _   {  set obj_attr(2) 0 }
                 +   {  set obj_attr(2) 1 }
                 -   {  set obj_attr(2) 3 }
              }
           }

        2  {
              switch -- $elem \
              {
                 _   {  set obj_attr(3) 0 }
                 0   {  set obj_attr(3) 1 }
              }
           }

        3  {
              switch -- $elem \
              {
                 _         {  set obj_attr(5) 0 }
                 default   {  set obj_attr(5) $elem }
              }
           }

        4  {
              switch -- $elem \
              {
                 _   {  set obj_attr(6) 0 }
                 .   {  set obj_attr(6) 1 }
              }
           }

        5  {
              switch -- $elem \
              {
                 _         {  set obj_attr(7) 0 }
                 default   {  set obj_attr(7) $elem }
              }
           }

        6  {
              switch -- $elem \
              {
                 _   {  set obj_attr(4) 0 }
                 0   {  set obj_attr(4) 1 }
              }
           }
     }
     incr count
  }

  if { $obj_attr(6) == 1 } \
  {
     set obj_attr(1) "Real Number" 
     set obj_attr(5) [expr $obj_attr(5) - $obj_attr(7)]
  } elseif { $obj_attr(7) > 0 } \
  {
     set obj_attr(1) "Real Number"
     set obj_attr(5) [expr $obj_attr(5) - $obj_attr(7)]
  } elseif { $obj_attr(6) == 0 && $obj_attr(7) == 0 && \
             $obj_attr(5) > 0 } \
  {
     set obj_attr(1) "Integer" 
  } else \
  {
     set obj_attr(1) "Text String"
  }

}

#==============================================================================
#This function takes the value portion of the lines containing FORMAT
#from the definition file and each character is the mapped to the 
#appropriate attribute of the FORMAT object.
#===============================================================================
proc PB_fmt_SplitPercFormat { OBJ_ATTR } {
#===============================================================================
  upvar $OBJ_ATTR obj_attr
  set count 1

  # Splits each charater and stores it as a list.
    set attr_list [split $obj_attr(1) {}]

  # Sets default value for the object attributes
    set obj_attr(2) 0
    set obj_attr(3) 0
    set obj_attr(4) 0
    set obj_attr(5) ""
    set obj_attr(6) 0
    set obj_attr(7) ""

  # Maps value for each attribute of the FORMAT Object. Each element of the
  # attribute list is mapped to the respective attribute of the FORMAT Object
  # defined in the classes.tcl file.

    foreach attr $attr_list\
    {
      switch -- $attr\
      {
       .       { set obj_attr(6) 1 }
       f       { set obj_attr(1) "Real Number" }
       d       { set obj_attr(1) Integer }
       s       { set obj_attr(1) "Text String" }
       +       { set obj_attr(2) 1 }
       -       { set obj_attr(2) 3 }
       0       { if {!$obj_attr(6) && ![string compare $obj_attr(5) ""]}\
                 {
                    set obj_attr(3) 1
                 } elseif {!$obj_attr(6)}\
                 {
                    append obj_attr(5) $attr
                 } elseif {$obj_attr(6)}\
                 {
                    set obj_attr(7) $attr
                 }
               }
       \"      {}
       %       {}
       default { if {$count == 1 && !$obj_attr(6)}\
                 {
                    append obj_attr(5) $attr
                    incr count
                 } elseif {!$obj_attr(6)}\
                 {
                    append obj_attr(5) $attr
                 } else\
                 {
                    set obj_attr(7) $attr
                    if {$obj_attr(5) == ""}\
                    {
                       set obj_attr(5) [expr 8 - $obj_attr(7)]
                    } else\
                    {
                       set obj_attr(5) [expr $obj_attr(5) - $obj_attr(7)]
                    }
                 }
               }
      }
 }
}

#===============================================================================
#This function is called from the interface file, the callback from the "Create" button
#of the Format page. New FORMAT Object is created taking the object attribute, object list
#name list and object index from the UI passed through the interface file.
#===============================================================================

proc PB_fmt_CreateNewFmtObj { OBJ_LIST OBJ_ATTR OBJ_INDEX} {
  upvar $OBJ_LIST obj_list
  upvar $OBJ_ATTR obj_attr
  upvar $OBJ_INDEX obj_index

  #The FORMAT Object is created passing the object attributes. The obj_list
  #is the return list from the function which stores the "id" of the object
  #created.
  PB_fmt_CreateFmtObj obj_attr obj_list

  #Sets the object index for the new object. if the index is null, sets to zero.
  if {$obj_index == ""}\
  {
     set obj_index 0
  } else\
  {
     incr obj_index
  }

  #Finding the length of the object list.
  set length [llength $obj_list]
  
  #The newely created object is removed from the list.
  set RearrObj [lindex $obj_list [expr $length -1]]

  #The newely created object is removed and inserted in the 
  #correct object index.
  set obj_list [lreplace $obj_list [expr $length - 1] [expr $length -1]]
  set obj_list [linsert $obj_list $obj_index $RearrObj]
}

#===============================================================================
#This procedure reads value from the buffer object, creates a new FORMAT Object and 
#stores the value in the new object,  and returns the value to the UI. The Input to 
#the procedure are object list, name list, object, object index and buffer object and 
#the output from the procedure is the updated name and object list along with the 
#display attributes for the new PASTE object.
#===============================================================================

proc PB_fmt_PasteFmtBuffObj {OBJ_LIST BUFF_OBJ_ATTR OBJ_INDEX} {
  upvar $OBJ_LIST fmt_obj_list
  upvar $BUFF_OBJ_ATTR buff_obj_attr
  upvar $OBJ_INDEX obj_index

  # Create new FORMAT Object with the attributes read from the buffer object.
    PB_fmt_CreateFmtObj buff_obj_attr fmt_obj_list

  # If the count is greater than or equal to one insert the PASTE Object 
  # after the current object
    set count [llength $fmt_obj_list]
    if { $obj_index == ""} \
    {
       set obj_index 0
    } elseif { $count > 1} \
    {
       incr obj_index
       set Rearrange_I [expr [llength $fmt_obj_list] - 1]
       set LastElement [lindex $fmt_obj_list $Rearrange_I]
       set fmt_obj_list [lreplace $fmt_obj_list $Rearrange_I $Rearrange_I]
       set fmt_obj_list [linsert $fmt_obj_list $obj_index $LastElement]
    } 
}

#==============================================================================
#This function returns the format string given the object attribute as the input.
#Corresponding to each of the format attribute the values are mapped and the final
#string is output from the procedure.
#===============================================================================

proc PB_fmt_RetFmtFrmAttr {OBJ_ATTR VALUE} {
  upvar $OBJ_ATTR obj_attr
  upvar $VALUE nvar
  
  #Sets the %string as it is at the beginning of all the format strings.
  set nvar "\"&"

  #For each of the attributes the values are mapped to the corresponding value.
  for {set i 0} {$i < 9} {incr i}\
  {
     switch $i\
     {
        0   {}
        1   { 
              switch $obj_attr($i)\
              {
                 "Real Number"   {set dt f}
                 "Integer"       {set dt d}
                 "Text String"   {set nvar \"%s\" ; return}
              }
            }
        2   { if {$obj_attr($i)}\
              {
                 if {$obj_attr($i) == 3}\
                 {
                    append nvar -
                 } else\
                 {
                    append nvar +
                 }
              } else \
              {
                append nvar _
              }
            }
        3   { if {$obj_attr($i)}\
              {
                 append nvar 0
              } else \
              {
                 append nvar _
              }
            }
        4   {}
        5   { 
              if {[string compare $dt "f"] == 0} \
              {
                 set temp_fpart [expr $obj_attr(5) + $obj_attr(7)]
                 append nvar $temp_fpart
              } elseif {$obj_attr($i) != 0} \
              {
                append nvar $obj_attr($i)
              }
            }
        6   { if {$obj_attr($i)}\
              {
                 append nvar "."
              } else \
              {
                 append nvar _
              }
            }
        7   { 
              if {[string compare $dt "f"] == 0} \
              {
                 append nvar $obj_attr($i)
              } else \
              {
                 append nvar _
              }
            }
        8   {
              if {$obj_attr(4) || [string compare $dt "d"] == 0} \
              {
                append nvar 0
              } else \
              {
                append nvar _
              }
              append nvar \"
            }
  default   {}  
     }
  }
}

#===============================================================================
#This procdure takes the input as the object attribute and the input value, calculates
#the OUTPUT value by applying the format to the input value.
#===============================================================================

proc PB_fmt_RetFmtOptVal {OBJ_ATTR INP_VALUE DIS_VALUE} {
  upvar $OBJ_ATTR obj_attr
  upvar $INP_VALUE inp_value
  upvar $DIS_VALUE dis_value

  #Sets the display value to null initially.
  set dis_value ""
  if { $inp_value == "" } { return } 

  #Initialize the negative flag to zero.
  set neg_flag 0

  #Finds the position of the decimal place.
  set dec_pt [string first "." $inp_value]

  #If input value is there split the input value into first and second part.
  if {$dec_pt != -1}\
  {
     set fpart [string range $inp_value 0 [expr $dec_pt - 1]]
     set spart [string range $inp_value [expr $dec_pt + 1] end]
  } else\
  {
     #Else initialize the second part to null.
     set fpart $inp_value
     set spart ""
  }

  #Check whether the input value contains negative sign.
  if {[string match -* $fpart]}\
  {
     #Set the first part and negative flag.
     set len [string length $fpart]
     set fpart [string range $fpart 1 $len]
     set neg_flag 1
  }

  #For each of the attributes map into the corresponding output.
  #The data type is identified, + and - signs appended, Leading zeros
  #and trailing zeros are appended to the value.
  for {set i 1} {$i < 8} {incr i}\
  {
     switch $i\
     {
        1       { switch $obj_attr($i)\
                  {
                    "Text String" { set dis_value $inp_value
                                    break
                                  }
                  }
                }
        2       { switch $obj_attr($i)\
                  {
                    1       { append dis_value + }
                    default { if {$neg_flag}\
                              {
                                append dis_value -
                              }
                            }
                  }
                } 
        3       { switch $obj_attr($i)\
                  {
                    1       {set lz 0}
                    0       {set lz 1}
                  }
                }
        4       { switch $obj_attr($i)\
                  { 
                    1       {set tz 0}
                    0       {set tz 1}
                  }
                }
        5       { switch $obj_attr($i)\
                  {
                    ""      {}
                    default { 
                              set length [string length $fpart]
                              if {$length > $obj_attr($i)} \
                              {
                                set end_no [expr $obj_attr($i) - 1]
                                set fpart [string range $fpart 0 $end_no]
                              }

                              if {$lz == 0}\
                              {
                                 set length [string length $fpart]
                                 set num_zero \
                                     [expr $obj_attr($i) - $length]
                                 if { $num_zero >= 0}\
                                 {
                                    for {set j 0} {$j < $num_zero} \
                                                          {incr j}\
                                    {
                                       append dis_value 0
                                    }
                                    append dis_value $fpart
                                 }
                              } else\
                              {
                                append dis_value $fpart
                              }
                            }
                  }
                }
        6       { switch $obj_attr($i)\
                  {
                    1      {
                              append dis_value .
                           }
                    0      {}
                  } 
                }
        7       { switch $obj_attr($i)\
                  {
                    ""      {
                               if {![string compare $obj_attr(5) ""]}\
                               {
                                 set dis_value $fpart 
                               }
                            }
                    default { 
                              set length [string length $spart]
                              if {$length > $obj_attr($i)} \
                              {
                                  set end_no [expr $obj_attr($i) - 1]
                                  set spart [string range $spart 0 $end_no]
                              }

                              if {$tz == 0}\
                              {
                                 append dis_value $spart
                                 set length [string length $spart]
                                 set num_zero \
                                     [expr $obj_attr($i) - $length]
                                 if { $num_zero >= 0}\
                                 {
                                    for {set k 0} {$k < $num_zero} \
                                                          {incr k}\
                                    {
                                       append dis_value 0
                                    }
                                 }
                              } elseif {$tz == 1} \
                              {
                                 append dis_value $spart
                              }
                            }
                  }
                }

        default {}
     }
  }
}

#=============================================================================
# Returns all the format objects
#=============================================================================
proc PB_fmt_RetFormatObjs { FMT_OBJ_LIST } {
#=============================================================================
  upvar $FMT_OBJ_LIST fmt_obj_list
  global post_object

  set fmt_obj_list $Post::($post_object,fmt_obj_list)
}

#=============================================================================
# Returns the format names list
#=============================================================================
proc PB_fmt_GetFmtNameList { FMT_OBJ_LIST FMT_NAME_LIST } {
#=============================================================================
  upvar $FMT_OBJ_LIST fmt_obj_list
  upvar $FMT_NAME_LIST fmt_name_list

  foreach fmt_obj $fmt_obj_list \
  {
     lappend fmt_name_list $format::($fmt_obj,for_name)
  }
  
  if {![info exists fmt_name_list]} \
  {
     set fmt_name_list ""
  }
}
