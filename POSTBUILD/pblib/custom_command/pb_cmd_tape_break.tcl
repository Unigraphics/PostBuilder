##############################################################################
#                                                                            #
# Copyright (c) 1999/2000/2001/2002/2003/2004, Unigraphics Solutions Inc.    #
#                                                                            #
##############################################################################

#=============================================================
proc PB_CMD_automatic_retract { } {
#=============================================================
#
#  Calling PB_CMD_automatic_retract in the PB_CMD_before_motion
#  custom command will perform an automatic retract, tape break and re-engage
#  sequence when the maximum NC tape file length is reached.
#
#  The custom command PB_CMD_output_operation_tape may be used to output
#  a new tape for each operation.  Place it at the VERY top of the
#  "Start of Path" event marker.
#
#  The custom command PB_CMD_operation_header may be used to output a header
#  for the new tape.  Place it immediately after the PB_CMD_output_operation
#  custom command.
#
#  The custom command PB_CMD_operation_end may be used to output the end of tape
#  code and reset 
#

   global tape_bytes
   global mom_sys_max_tape_bytes
   global mom_sys_min_tape_bytes
   global mom_sys_automatic_retract_distance
   global mom_sys_automatic_reengage_distance
   global mom_sys_automatic_reengage_feedrate
   global mom_pos
   global mom_prev_pos
   global mom_prev_tool_axis
   global mom_operation_name
   global mom_motion_event
   global feed
   global operation_sequence
   global mom_kin_4th_axis_type
   global mom_sys_tool_change_motion_types
   global mom_motion_type


   set ix [lsearch -exact $mom_sys_tool_change_motion_types $mom_motion_type]
   if {$mom_sys_max_tape_bytes < $tape_bytes  || ($ix < 0 && $mom_sys_min_tape_bytes < $tape_bytes)} {

      MOM_output_literal "G40"
      MOM_output_literal "M00"

      if {[info exists mom_kin_4th_axis_type] && $mom_kin_4th_axis_type == "Table"} {
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

      MOM_force once M
      MOM_do_template end_of_program

      incr operation_sequence 

      PB_CMD_output_operation_tape
      PB_CMD_operation_header

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
         set mom_pos($i) [expr $mom_prev_pos($i) + $mom_sys_automatic_reengage_distance*$mom_prev_tool_axis($i)]
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
proc PB_CMD_init_tape_break { } {
#=============================================================
#
#  This procedure will be executed automatically at the start of program and
#  anytime it is loaded as a slave post of a linked post.
#
#  This procedure will perform an automatic retract, tape break and re-engage
#  sequence when the maximum nc tape file length is reached.  
#
#  There are four procedures that can be placed with event markers
#  to check for tape footage and output the needed codes.
#
#  Add the following line of code (without the #) to the PB_CMD_before_motion 
#  custom command.
#PB_CMD_automatic_retract
#
#  The custom command PB_CMD_output_operation_tape may also be used to output
#  a new tape for each operation.  Place that custom command at the VERY top
#  of the start of operation event marker.
#
#  The custom command PB_CMD_operation_header may be used to output a header
#  for the new tape.  Place it immediately after the PB_CMD_output_operation
#  custom command.
#
   global mom_sys_max_tape_bytes
   global mom_sys_min_tape_bytes
   global mom_sys_automatic_retract_distance
   global mom_sys_automatic_reengage_distance
   global mom_sys_automatic_reengage_feedrate
   global operation_sequence
   global mom_kin_4th_axis_type
   global mom_sys_cut_motion_types
   global mom_sys_tool_change_motion_types

#
#  These variables may be used to control the size of the nc file.  The post
#  will start checking for an appropriate motion type when the minimum 
#  tape bytes is reached.  If an appropriate motion type has not been 
#  encountered by the time the maximum tape bytes is reached, a tape break
#  will occur regardless of the motion type. 1 KB is approximately 1000 bytes.
#
   set mom_sys_max_tape_bytes	 		100000
   set mom_sys_min_tape_bytes	 		 90000

#
#  This variable is used to control the delta move along the tool axis when 
#  breaking the tape.
#
   set mom_sys_automatic_retract_distance 	100.0

#
#  This variable is used to define how close the reengage distance gets to 
#  the previous point.
#
   set mom_sys_automatic_reengage_distance 	10

#
#  This variable defines the feedrate used to reengage to the previous point.
#  It is assumed to be in IPM or MMPM.
#
   set mom_sys_automatic_reengage_feedrate 	100.0

#
#  This list contains the cut types that will NOT be used for automatic retract
#  and tape break.  If you know that your stepovers will be off the part, you
#  may want to remove STEPOVER from this list.
#
   set mom_sys_tool_change_motion_types   	{CUT FIRSTCUT STEPOVER CYCLE} 

   set operation_sequence 1
}


#=============================================================
proc PB_CMD_operation_header { } {
#=============================================================
#
#  This procedure will output a header for each operation.  Place this custom 
#  command at the start of operation event marker. 
# 

   global operation_sequence
   global mom_tool_number
   global mom_tool_diameter
   global mom_tool_corner1_radius 
   global mom_sys_control_out mom_sys_control_in
   global mom_seqnum
   global mom_pos
   global mom_feed_rate
   global mom_spindle_rpm

   set str [format "SEQ= %d  TOOL NUMBER = %d  CUTTER DIAMETER = %.2f" $operation_sequence $mom_tool_number $mom_tool_diameter]
   MOM_output_literal "$mom_sys_control_out$str$mom_sys_control_in"

   set seqstr ""
   if {$mom_seqnum < 9998} {set seqstr "0${seqstr}"}
   if {$mom_seqnum < 998} {set seqstr "0${seqstr}"}
   if {$mom_seqnum < 98} {set seqstr "0${seqstr}"}
   if {$mom_seqnum < 8} {set seqstr "0${seqstr}"}

   set str [format "START= N%s%.0f  X= %.3f  Y= %.3f  Z= %.3f" $seqstr [expr $mom_seqnum+2] $mom_pos(0) $mom_pos(1) $mom_pos(2)]   
   MOM_output_literal "$mom_sys_control_out$str$mom_sys_control_in"
   set str [format "STEP=  CORNER RADIUS= %.4f  FEED= %.2f  RPM= %.0f" $mom_tool_corner1_radius $mom_feed_rate $mom_spindle_rpm]
   MOM_output_literal "$mom_sys_control_out$str$mom_sys_control_in"
}


#=============================================================
proc PB_CMD_output_operation_tape { } {
#=============================================================
#
#  This procedure can be used to output an N/C tape with each operation.
#  Place this custom command at the VERY begining of the Start of Operation
#  event marker.
#
#  This proc will also delete the initial program tape and rename it to 
#  {operation_name}{sequence number}{extension}.
#  Any N/C code output with the Program Start sequence will be lost.
#  
   global ptp_file_name
   global mom_output_file_directory
   global mom_operation_name
   global mom_output_file_basename
   global output_extn
   global tape_bytes
   global operation_sequence
   global mom_sys_output_file_suffix

#
#  Remove the next two lines of code if you don't want the original nc tape
#  and the start of program output to be deleted.
#
   set fn ${mom_output_file_directory}${mom_output_file_basename}${output_extn}
   if { [file exists $fn] == "1" } { MOM_remove_file $fn }

   MOM_close_output_file $ptp_file_name

   set op_seq_leader ""
   if {$operation_sequence < 10} {set op_seq_leader "0"}

   set ptp_file_name "${mom_output_file_directory}${mom_operation_name}${op_seq_leader}${operation_sequence}.${mom_sys_output_file_suffix}"
   MOM_remove_file $ptp_file_name
   MOM_open_output_file $ptp_file_name

   set tape_bytes 0
}


#=============================================================
proc PB_CMD_operation_end { } {
#=============================================================
#
#  This procedure is used to output the end of program info when each
#  operation has a separate tape.
#

   global operation_sequence

   set operation_sequence 1

   MOM_force once M
   MOM_do_template end_of_program
}

