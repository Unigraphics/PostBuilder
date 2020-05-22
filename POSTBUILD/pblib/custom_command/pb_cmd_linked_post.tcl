##############################################################################
#                                                                            #
# Copyright (c) 1999/2000/2001/2002/2003/2004, Unigraphics Solutions Inc.    #
#                                                                            #
##############################################################################

#=============================================================
proc PB_CMD_kin_init_linked_post { } {
#=============================================================
#
# This procedure will be executed automatically at the start of program and
# anytime it is loaded as a slave post of a linked post.
#
# This procudure will allow you to define more than one post
# for a single NC program.  This is useful for mill/turns with more
# than one live milling turret.  It can be used for any combination
# of maching modes (turning, three axis, four axis, five axis).
#  
# The HEAD ude will be included in UG NX.  If you want to use the 
# linked post functionality in v18 or earlier you will need to add the
# following lines of code (without the #) to your ude.cdl file located
# in the MACH/resource/user_def_event directory.
#
#EVENT  head 
#{ 
#   UI_LABEL "Head" 
#   PARAM command_status 
#   { 
#      TYPE o 
#      DEFVAL "Active" 
#      OPTIONS "Active","Inactive","User Defined" 
#      UI_LABEL "Status" 
#   }
#   PARAM head_name 
#   { 
#      TYPE   s 
#      TOGGLE Off 
#      UI_LABEL "Name" 
#   } 
#}

# The HEAD UDE command is used to detemine which head or postprocessor 
# will be used for each operation.  The recommended way of assigning the 
# UDE is to create a method group for each head or post you wish to use.  
# Place all of your operations in the method group that represents the 
# head or post for that operation in the method view.  Assign the UDE 
# using the Edit/Object/Start Post/Head option and entering your head 
# name as text.  If you assign the UDE to an individual operation, this 
# function will NOT work. The MOM_head event will be generated and the 
# correct post will be called in whenever an operation from a different 
# METHOD is postprocessed.
#


uplevel #0 {


if 0 {

# The following example defines three heads.  The UDE command HEAD/ZHEAD
# will execute the post mill_zaxis.  The files mill_zaxis.tcl and 
# mill_zaxis.def will be used to postprocess until another HEAD command
# is encountered.  All head names must be all caps.
#
# The following table defines the name of the head and the post that
# will be used when that head is specified in the toolpath with a
# UDE (User Defined Event).  

#  set mom_sys_postname(ZHEAD)        "mill_zaxis"
#  set mom_sys_postname(XHEAD)        "mill_xaxis"
#  set mom_sys_postname(TURN)         "lathe"
#

if {![info exists mom_sys_postname]} {
  set mom_sys_postname(ZHEAD)        "mill_zaxis"
  set mom_sys_postname(XHEAD)        "mill_xaxis"
  set mom_sys_postname(TURN)         "lathe"
}

}


# This procedure will also allow you to output code when switching from one
# machining mode to another.  The procedure PB_CMD_start_of_zhead will be 
# executed if it exists whenever the zhead is used.  Likewise and procedure
# is called each time a new head is used to turn off the previous mode and
# initiate the new mode.

# When several posts are linked together only the master post (the one with
# this custom command imported) will control the listing, warning, verbosity
# of error diagnostics, group output and the review tool.  The master post 
# will also output the Start of Program and End of Program events.  The 
# slave posts will not output any Start of Program or End of Program events 
# nor control any run-time functions.

proc MOM_head {} {

   global mom_head_name mom_sys_postname
   global mom_load_event_handler 
   global current_head
   global mom_warning_info
   global mom_sys_head_change_init_program

   if { ![info exists current_head] } {
      set current_head ""
   }   

   if { [info exists mom_head_name] } {
      set mom_head_name [string toupper $mom_head_name]
   }

   if { [info exists mom_sys_postname($mom_head_name)] && $current_head != "$mom_head_name" } {

      if { [llength [info commands PB_CMD_end_of_$current_head]] } {PB_CMD_end_of_$current_head}
 
      set current_head $mom_head_name

      set mom_load_event_handler  [MOM_ask_env_var UGII_CAM_POST_DIR]$mom_sys_postname($mom_head_name).tcl
      MOM_load_definition_file    [MOM_ask_env_var UGII_CAM_POST_DIR]$mom_sys_postname($mom_head_name).def

      if { [llength [info commands PB_CMD_start_of_$current_head]] } {PB_CMD_start_of_$current_head}
      set mom_sys_head_change_init_program 1


      rename MOM_start_of_program MOM_start_of_program_save
      rename MOM_end_of_program MOM_end_of_program_save
 
   } else {

      set mom_warning_info "Bad head name"
      MOM_catch_warning
   }
}


proc MOM_Head {} {MOM_head}
proc MOM_HEAD {} {MOM_head}


} ;# end uplevel
} ;# end PB_CMD_init_linked_post


#=============================================================
proc PB_CMD_start_of_TURN { } {
#=============================================================
   MOM_output_literal "Code to turn on the TURN head"
}

#=============================================================
proc PB_CMD_start_of_XHEAD { } {
#=============================================================
   MOM_output_literal "Code to turn on the XHEAD"
}

#=============================================================
proc PB_CMD_start_of_ZHEAD { } {
#=============================================================
   MOM_output_literal "Code to turn on the ZHEAD"
}

#=============================================================
proc PB_CMD_end_of_TURN { } {
#=============================================================
   MOM_output_literal "Code to turn off the TURN head"
}

#=============================================================
proc PB_CMD_end_of_XHEAD { } {
#=============================================================
   MOM_output_literal "Code to turn off the XHEAD"
}

#=============================================================
proc PB_CMD_end_of_ZHEAD { } {
#=============================================================
   MOM_output_literal "Code to turn off the ZHEAD"
}

