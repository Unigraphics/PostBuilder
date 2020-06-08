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
# 22-feb-1999   bmp   Initial                                                #
# 07-Apr-1999   mnb   Removed puts                                           #
# 02-Jun-1999   mnb   Code Integration                                       #
#                                                                            #
# $HISTORY$                                                                  #
#                                                                            #
##############################################################################

#=============================================================================
#The input to the function is the FILE Object and the POST OBJECT.
#This function is called from the classes.tcl file. The ude.def file is
#read and the data is passed to the function which creates the UDE PARAM
#and UDE EVENT Objects and finally the UDE Object.
#=============================================================================

proc PB_ude_UdeInitParse {this POST_OBJ} {
  upvar $POST_OBJ post_obj
  set event_start_flag 0
  set param_start_flag 0
  set event_create_flag 0
  set param_create_flag 0
  set param_attr ""
  set event_attr ""
  set param_obj_list ""
  set event_obj_list ""
  set ude_obj_list ""
  
  #Read the UDE.DEF file and create PARAM, UDE EVENT and UDE Objects.
  while { [gets $File::($this,FilePointer) line] >= 0 }\
  {
      #Remove the left side spaces from the line.
      set line [string trimleft $line " "]

      #Checks whether the line is a comment or a null line.
      set comnt_check [string index $line 0]

      if {[string compare $comnt_check #] == 0||[string compare $comnt_check ""] == 0}\
      {
         continue
      } else\
      {
         #If the line is continued to the next line using a slash the subsequent
         #lines are appended to the main line and then only passed to the parsing
         #function.

         #sets the length of the line and checks the last character for slash.
         set line_length [string length $line]
         set last_char_test [string index $line [expr $line_length - 1]]
          
         #If the line is continued to the next line, the original line is appended.
         if {[string compare $last_char_test \\] == 0}\
         {
           set line_wo_sl [string range $line 0 [expr $line_length - 2]]
           append temp_line $line_wo_sl
           continue
         } elseif {[info exists temp_line]}\
         {
           append temp_line $line
           set line $temp_line
           unset temp_line
         }
         
         #Calling the UDE secondary parsing function which finds the attribute
         #of UDE Events, Params and finally creates the UDE Object.
         PB_ude_UdeSecParse line event_start_flag param_start_flag \
                                 event_create_flag param_create_flag \
                                 event_attr param_attr param_obj_list \
                                 event_obj_list
      }
  }

  PB_ude_CreateLastParamEvtObj param_attr param_obj_list event_attr \
                               event_obj_list ude_obj_list
  set Post::($post_obj,ude_obj) $ude_obj_list
#  puts "The TOTAL UDE EVENTS AREATED ARE = [llength $ude::($ude_obj_list,event_obj_list)]"
}

#==================================================================================
#This function takes the line and all the flags initialised for condition checking
#flags as input and the attribute list and object list are output from the 
#procedure. The objects lists and the attribute lists are initialized outside the
#procedure and these lists are referenced inside the subsequent procedures called.
#==================================================================================

proc PB_ude_UdeSecParse {LINE EVENT_START_FLAG PARAM_START_FLAG \
                         EVENT_CREATE_FLAG PARAM_CREATE_FLAG \
                         EVENT_ATTR PARAM_ATTR PARAM_OBJ_LIST \
                         EVENT_OBJ_LIST} {
  upvar $LINE line
  upvar $EVENT_START_FLAG event_start_flag
  upvar $PARAM_START_FLAG param_start_flag
  upvar $EVENT_CREATE_FLAG event_create_flag
  upvar $PARAM_CREATE_FLAG param_create_flag
  upvar $EVENT_ATTR event_attr
  upvar $PARAM_ATTR param_attr
  upvar $PARAM_OBJ_LIST param_obj_list
  upvar $EVENT_OBJ_LIST event_obj_list
   

  #Sets the event start flag and checks the event create flag if the line 
  #contains the "EVENT" string.
  switch -glob $line\
  {
    EVENT*      {
                   #sets the event start flag active.
                   set event_start_flag 1
                  
                   #Creates the UDE EVENT Object if flag is set.
                   if {$event_create_flag}\
                   {
                      #Creates the PARAM Object if flag is set.
                      if {$param_create_flag}\
                      {
                         #Call for setting the PARAM Object attribute and creating 
                         #the PARAM Object.
                         PB_ude_CreateParamObjAttr param_attr param_obj_list

                         #unsets the PARAM Object attribute list.
                         unset param_attr
                          
                         #sets the param create flag inactive.
                         set param_create_flag 0
                      }

                      #Call for setting the UDE EVENT Object attribute and creating
                      #the UDE EVENT Object.
                      PB_ude_CreateEventObjAttr event_attr param_obj_list event_obj_list

                      #unsets the UDE EVENT Object attribute list.
                      unset event_attr

                      #sets the param start flag and event create flag inactive.
                      set param_start_flag 0
                      set event_create_flag 0
                   }
                }
  }
  
   #If the event start flag is active set event create flag active.
   if {$event_start_flag}\
   {
     #sets the event create flag active.
     set event_create_flag 1

     #If param start flag is inactive start appending event attribute list.
     if {!$param_start_flag}\
     {
        switch -glob $line\
        {
          EVENT*         {
                            lappend event_attr $line
                         }
          POST_EVENT*    {
                            lappend event_attr $line
                         }
          UI_LABEL*      {
                            lappend event_attr $line
                         }
          CATEGORY*      {
                            lappend event_attr $line
                         }
        }
     }

     #Sets the param start flag and checks the param create flag if the line
     #contains the "PARAM" string. 
     switch -glob $line\
     {
       PARAM*    {
                   #sets the param start flag active.
                   set param_start_flag 1

                   #If the param create flag is active call the function to
                   #intitialise the param object attribute and create param object.
                   if {$param_create_flag}\
                   {
                      PB_ude_CreateParamObjAttr param_attr param_obj_list 
                      unset param_attr
                      set param_create_flag 0
                   }
         
                   #Start appending the param attribute list.
                   lappend param_attr $line
                 }
     }

     #Ifparam start flag is active start appending the param attribute list.
     if {$param_start_flag}\
     {
       switch -glob $line\
       {
          
          TYPE*         { 
                          lappend param_attr $line
                        }
          DEFVAL*       {
                          lappend param_attr $line
                        }
          OPTIONS*      {
                          lappend param_attr $line
                        }
          UI_LABEL*     {
                          lappend param_attr $line
                        }
          TOGGLE*       {
                          lappend param_attr $line
                        }
       }

       #set the param create flag active.
       set param_create_flag 1
     }
   }
}

#=================================================================================
#This function creates the ude event attribute array for the creation of the UDE 
#EVENT object. The ude event attribute list and the param object list are input 
#to the function and the updated object list is output from the function after 
#creating the UDE EVENT Object.
#=================================================================================

proc PB_ude_CreateEventObjAttr {ATTR_LIST PARAM_OBJ_LIST EVENT_OBJ_LIST} {
  upvar $ATTR_LIST attr_list
  upvar $PARAM_OBJ_LIST param_obj_list
  upvar $EVENT_OBJ_LIST event_obj_list
  
  #Checks for the POST_EVENT, UI_LABEL, CATEGORY attributes.
  set pevt_srch [lsearch $attr_list POST_EVENT*]
  set lbl_srch [lsearch $attr_list UI_LABEL*]
  set cat_srch [lsearch $attr_list CATEGORY*]

  #If the attributes are missing the values are initialised for the
  #attributes and appended to the attribute list.
  if {$pevt_srch == -1}\
  {
    lappend attr_list {POST_EVENT ""}
  } 

  if {$lbl_srch == -1}\
  {
    lappend attr_list {UI_LABEL ""}
  } 

  if {$cat_srch == -1}\
  {
    lappend attr_list {CATEGORY ""}
  }

  #The attribute list is converted into the attribute array for the creation of
  #the UDE EVENT Object.
  foreach attr $attr_list\
  {
    switch -glob $attr\
    {
      EVENT*      {
                     set event_obj_attr(0) [lindex $attr 1]  
                  } 
      POST_EVENT* {
                     set event_obj_attr(1) [lindex $attr 1]  
                  } 
      UI_LABEL*   {
                     set event_obj_attr(2) [lindex $attr 1]  
                  } 
      CATEGORY*   {
                     set event_obj_attr(3) [lrange $attr 1 end]  
                  } 
    } 
  }
  
  #Sets the param object list as the ude event object attribute and unsets it.
  set event_obj_attr(4) $param_obj_list
  unset param_obj_list
  
  #Function call for the creation of UDE EVENT Object.
  PB_ude_CreateEventObj event_obj_attr event_obj_list
}

#=================================================================================
#This function creates the param attribute array for the creation of the PARAM
#object. The param attribute list is input to the function and the updated object
#list is output from the function after creating the PARAM Object.
#=================================================================================

proc PB_ude_CreateParamObjAttr {ATTR_LIST PARAM_OBJ_LIST} {
   upvar $ATTR_LIST attr_list
   upvar $PARAM_OBJ_LIST param_obj_list
  
   #Modifies the PARAM Object attribute list by adding the missing attributes. 
   PB_ude_InitParamAttr attr_list

   #List elements are converted into attribute array element.
   #The attribute array index is dependent on the object definition
   #in the classes.tcl file.
   foreach attr $attr_list\
   {
     switch -glob $attr\
     {
       PARAM*    {
                   set param_obj_attr(0) [lindex $attr 1]
                 }
       TYPE*     {
                   set param_obj_attr(1) [lindex $attr 1]
                 }
       DEFVAL*   {
                     set param_obj_attr(2) [lindex $attr 1]
                 }
       OPTIONS*  {
                   set param_obj_attr(3) [string trimleft $attr "OPTIONS "]
                 }
       TOGGLE*   {
                   if {![string compare $param_obj_attr(1) s]}\
                   {
                     set param_obj_attr(2) [lindex $attr 1]
                   } else\
                   {
                     set param_obj_attr(3) [lindex $attr 1]
                   }
                 }
       UI_LABEL* {
                   if {[string compare $param_obj_attr(1) s] == 0 || \
                       [string compare $param_obj_attr(1) b] == 0}\
                   {
                     set param_obj_attr(3) [lindex $attr 1]
                   } elseif {[string compare $param_obj_attr(1) p] == 0}\
                   {
                     set param_obj_attr(2) [lindex $attr 1]
                   } else\
                   {
                     set param_obj_attr(4) [lindex $attr 1]
                   }
                 }
     }
   }

   #Function call to create the UDE PARAM Object
   PB_ude_CreateParamObj param_obj_attr param_obj_list
}

#=================================================================================
#This function modifies the attribute list of the PARAM Object. From the input
#list the missing attribute elements are added and the values initialized for the
#missing attributes.
#=================================================================================

proc PB_ude_InitParamAttr {ATTR_LIST} {
   upvar $ATTR_LIST attr_list
  
   #Checking for the attribute TYPE and finds the data type of the object.
   set test [lsearch $attr_list TYPE*]
   set type_elem [lindex $attr_list $test]
   set dtype [lindex $type_elem 1]
  
   #Depending upon the data type the mising elements are found and the added to
   #the list. Null values are initialised for the missing attributes. The atributes
   #of the object depends on the defiition in the classes.tcl file. 
   switch $dtype\
   {
     i - d - \
     o - b     {
                 set dval_srch [lsearch $attr_list DEFVAL*]

                 if {$dval_srch == -1}\
                 {
                    lappend attr_list {DEFVAL ""}
                 }

                 switch $dtype\
                 {
                    i - d  {
                              set tog_srch [lsearch $attr_list TOGGLE*]
                              if {$tog_srch == -1}\
                              {
                                 lappend attr_list {TOGGLE ""}
                              }
                           }
                 }
               }
     s         {
                 set tog_srch [lsearch $attr_list TOGGLE*]
                 if {$tog_srch == -1}\
                 {
                   lappend attr_list {TOGGLE ""}
                 }
               }
       
   }

   #Finding the UI_LABEL attribute. This is common for all data types.
   set lbl_srch [lsearch $attr_list UI_LABEL*]
  
   if {$lbl_srch == -1}\
   {
     lappend attr_list {UI_LABEL ""}
   }
}

#=================================================================================
#This function takes the param attributes and event attributes and calls the
#param and event create function. After that the UDE Object is created.
# The updated object list is output from this function. This function is 
#called to create the last param and event object and the UDE Object at the 
#end of the parsing.
#=================================================================================

proc PB_ude_CreateLastParamEvtObj {PARAM_ATTR PARAM_OBJ_LIST EVENT_ATTR \
                                   EVENT_OBJ_LIST UDE_OBJ_LIST} {
   upvar $PARAM_ATTR param_attr
   upvar $PARAM_OBJ_LIST param_obj_list
   upvar $EVENT_ATTR event_attr
   upvar $EVENT_OBJ_LIST event_obj_list
   upvar $UDE_OBJ_LIST ude_obj_list

   #Calls the param object create function
   PB_ude_CreateParamObjAttr param_attr param_obj_list

   #Calls the ude event object create function
   PB_ude_CreateEventObjAttr event_attr param_obj_list event_obj_list

   #Sets the attributes of UDE Object
   set ude_obj_attr(0) DEFALUT
   set ude_obj_attr(1) $event_obj_list
   
   #Function call to create the UDE Object  
   PB_ude_CreateUdeObject ude_obj_attr ude_obj_list
}

#=================================================================================
#This function takes the object attributes and the updated PARAM object list
#as the input, creates the PARAM Object and returns the updated object list.
#=================================================================================

proc PB_ude_CreateParamObj { OBJ_ATTR OBJ_LIST } {
  upvar $OBJ_ATTR obj_attr
  upvar $OBJ_LIST obj_list

  #Creates new object.
  set object [param::CreateObject obj_attr(1)]
  
  #Appends object id to the object list.
  lappend obj_list $object
  
  #sets the latest value to the object created.
  param::ObjectSetValue $object obj_attr
#  puts "The UDE PARAM object is Created: $object "
}

#=================================================================================
#This function takes the object attributes and the updated UDE EVENT object list
#as the input, creates the UDE EVENT Object and returns the updated object list.
#=================================================================================

proc PB_ude_CreateEventObj { OBJ_ATTR OBJ_LIST } {
  upvar $OBJ_ATTR obj_attr
  upvar $OBJ_LIST obj_list

  #Creates new object.
  set object [new ude_event]
  
  #Appends object id to the object list.
  lappend obj_list $object
  
  #sets the latest value to the object created.
  ude_event::setvalue $object obj_attr
#  puts "The UDE EVENT object is Created: $object "
}

#=================================================================================
#This function takes the object attributes and the updated UDE object list
#as the input, creates the UDE Object and returns the updated object list.
#=================================================================================

proc PB_ude_CreateUdeObject { OBJ_ATTR OBJ_LIST } {
  upvar $OBJ_ATTR obj_attr
  upvar $OBJ_LIST obj_list

  #Creates new object.
  set object [new ude]
  
  #Appends object id to the object list.
  lappend obj_list $object
  
  #sets the latest value to the object created.
  ude::setvalue $object obj_attr
#  puts "The UDE object is Created: $object "
}
