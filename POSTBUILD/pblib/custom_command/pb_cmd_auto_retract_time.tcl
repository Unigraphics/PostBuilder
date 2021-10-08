##############################################################################
#                                                                            #
# Copyright (c) 1999/2000/2001/2002/2003/2004, Unigraphics Solutions Inc.    #
#                                                                            #
##############################################################################

#=============================================================
proc PB_CMD_automatic_retract { } {
#=============================================================
#
# This command will perform an automatic retract, tool change
# and re-engage sequence when the maximum cutting time of
# a tool is reached.
#
#
# Import this command and call it in the PB_CMD_before_motion
# custom command.
#
#
   global mom_event_time
   global mom_motion_type
   global mom_sys_current_cutting_time 
   global mom_sys_automatic_retract_distance
   global mom_sys_automatic_reengage_distance
   global mom_sys_automatic_reengage_feedrate
   global mom_sys_max_cut_time_per_tool
   global mom_sys_min_cut_time_per_tool
   global mom_sys_cut_motion_types
   global mom_sys_tool_change_motion_types
   global mom_pos
   global mom_prev_pos
   global mom_prev_tool_axis
   global mom_motion_event
   global feed
   global operation_sequence
   global mom_kin_4th_axis_type
   global mom_tool_number
   global mom_tool_adjust_register
   global mom_sys_max_cut_time_per_tool
   global mom_sys_tool_number
   global mom_sys_next_tool_number 


   if {![info exists mom_sys_current_cutting_time]} {set mom_sys_current_cutting_time 0.0}				

   set ix [lsearch -exact $mom_sys_cut_motion_types $mom_motion_type]

   if {$ix > -1} {
      set mom_sys_current_cutting_time [expr $mom_sys_current_cutting_time  + $mom_event_time]
   }

   set ix [lsearch -exact $mom_sys_tool_change_motion_types $mom_motion_type]
   if { $mom_sys_max_cut_time_per_tool < $mom_sys_current_cutting_time || \
        ($ix < 0 && $mom_sys_min_cut_time_per_tool < $mom_sys_current_cutting_time)} {

      set mom_sys_current_cutting_time 0.0

      MOM_output_literal "G40"
      MOM_output_literal "M00"

      if {[info exists mom_kin_4th_axis_type] && ![string compare "Table" $mom_kin_4th_axis_type] } {
         set vec(0) 0.0
         set vec(1) 0.0
         set vec(2) 1.0
      } else {
         set vec(0) $mom_prev_tool_axis(0)
         set vec(1) $mom_prev_tool_axis(1)
         set vec(2) $mom_prev_tool_axis(2)
      }

      for {set i 0} {$i < 3} {incr i} {
         set sav_pos($i) $mom_pos($i)
         set mom_pos($i) [expr $mom_prev_pos($i) + $mom_sys_automatic_retract_distance*$vec($i)]
      }

      MOM_rapid_move


      if {![info exists mom_sys_next_tool_number]} {set mom_sys_next_tool_number 0}
      set mom_tool_number [lindex $mom_sys_tool_number $mom_sys_next_tool_number]
      set mom_tool_adjust_register $mom_tool_number
      MOM_tool_change
      incr mom_sys_next_tool_number

      if {$mom_sys_next_tool_number >= [llength $mom_sys_tool_number]} {
         set mom_sys_next_tool_number 0
      }

     #
     # The following commands will force out all active data.  Add or remove 
     # words that are not applicable
     #
     # coordinate data
      MOM_force once X Y Z 

     # g code
      MOM_force once G_motion 

     # feedrate 
      MOM_force once F 

     # spindle and coolant
      MOM_force once S M_spindle M_coolant

      set save_event $mom_motion_event
      set mom_motion_event "first_move"
      MOM_rapid_move
      set mom_motion_event $save_event

      for {set i 0} {$i < 3} {incr i} {
         set mom_pos($i) \
             [expr $mom_prev_pos($i) + $mom_sys_automatic_reengage_distance*$mom_prev_tool_axis($i)]
      }

      MOM_rapid_move

      for {set i 0} {$i < 3} {incr i} {
         set mom_pos($i) $mom_prev_pos($i)
      }

      set save_feed $feed
      set feed $mom_sys_automatic_reengage_feedrate
      MOM_force once G_cutcom

      MOM_linear_move

      set feed $save_feed

      for {set i 0} {$i < 3} {incr i} {
         set mom_pos($i) $sav_pos($i)
      }
   }
}


#=============================================================
proc PB_CMD_init_auto_retract { } {
#=============================================================
#
#  This command initializes the parameters for an automatic
#  tape break sequence.
#
#
#  Imported this command to the post as needed. It will
#  be executed automatically at the start of program and anytime
#  when the post is loaded as a slave post of a linked post.
#
#
   global mom_sys_automatic_retract_distance
   global mom_sys_automatic_reengage_distance
   global mom_sys_automatic_reengage_feedrate
   global mom_sys_max_cut_time_per_tool
   global mom_sys_min_cut_time_per_tool
   global mom_sys_cut_motion_types
   global mom_sys_tool_number 
   global mom_sys_tool_change_motion_types

  #
  # These variables are used to control the cutting time per tool.  A tool 
  # change will occur after the minimum and before the maximum cutting time.  
  # If a suitable move type occurs in the tool path after 
  # the minimum but before the maximum time a retract and tool change 
  # will take place before that motion.  If no suitable move type is 
  # encountered after the minimum and before the maximum, a retract and 
  # tool change will occur immediately regardless of the motion type.
  #
   set mom_sys_max_cut_time_per_tool	 	60.0
   set mom_sys_min_cut_time_per_tool         30.0

  #
  # This variable is used to control the delta move along the tool axis when 
  # breaking the tape.
  #
   set mom_sys_automatic_retract_distance 		10.0

  #
  # This variable is used to define how close the reengage distance gets to 
  # the previous point.
  #
   set mom_sys_automatic_reengage_distance 	.1

  #
  # This variable defines the feedrate used to reengage to the previous point.
  # It is assumed to be in IPM or MMPM.
  #
   set mom_sys_automatic_reengage_feedrate 	10.0

  #
  # This list controls the tool numbers that will be used for the replacement 
  # tools.  This list may be as short or long as you need it.  If you only want
  # to load tool 1 every time then you could use {1}.
  #
   set mom_sys_tool_number 		{1 2 3 4 5 6}

  #
  # This list contains the cut types that will be used to increment the cutting 
  # time.
  #
   set mom_sys_cut_motion_types		{CUT FIRSTCUT STEPOVER CYCLE}

  #
  # This list contains the cut types that will NOT be used for automatic retract
  # and tool change.  If you know that your stepovers will be off the part, you
  # may want to remove STEPOVER from this list.
  #
   set mom_sys_tool_change_motion_types   {CUT FIRSTCUT STEPOVER CYCLE} 
}

