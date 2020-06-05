##############################################################################
#                                                                            #
# Copyright (c) 1999/2000,                        Unigraphics Solutions Inc. #
# Copyright (c) 2001/2002/2003/2004/2005/2006,    UGS/PLM Solutions.         #
# Copyright (c) 2007 ~ 2017,                      SIEMENS/PLM Software       #
#                                                                            #
##############################################################################
#                       P B _ P O S T _ B A S E . T C L
##############################################################################
#
# DESCRIPTION
#
#   This file contains common functions for building all posts.
#   ==> These commands are only populated during the creation of a new post.
#   ==> When a post is upgraded, only the new commands will be populated;
#       there will be no overrides to any existing (non-PB_CMD_kin) commands.
#   ==> Non-PB_CMD_kin commands to be enforced or replaced during upgrade
#       of a post should be defined in pb_base.tcl.
#
#   ==> PB_CMD_kin commands will always override the existing commands.
#
##############################################################################
#    PB_CMD__handle_end_of_subop_path
#    PB_CMD__handle_start_of_subop_path
#    PB_CMD__interop_is_transition_path
#    PB_CMD__interop_init_vars
#    PB_CMD_kin_before_output
#    PB_CMD_before_output
#    PB_CMD_kin_abort_event
#    PB_CMD_abort_event
#    PB_CMD___log_revisions
#    PB_CMD__config_post_options
#    PB_CMD__manage_part_attributes
#    PB_CMD__suppress_probe_bore_clearance_retract
#    PB_CMD_ask_machine_type
#    PB_CMD_kin_set_csys
#    PB_CMD_set_csys
#    PB_CMD_kin_end_of_path
#    PB_CMD_kin_feedrate_set
#    PB_CMD_start_of_alignment_character
#    PB_CMD_end_of_alignment_character
#    PB_CMD_pause
#    PB_CMD_run_postprocess
#
#    OUTPUT_MACRO
#    GET_SUBOP_MOVE_NAME
#    ABORT_EVENT_CHECK
#    HANDLE_FIRST_LINEAR_MOVE
#    OPERATOR_MSG
#    WORKPLANE_SET
##############################################################################


  set cam_post_dir [MOM_ask_env_var UGII_CAM_POST_DIR]


  if { ![info exists mom_sys_post_initialized] } {

     source ${cam_post_dir}ugpost_base.tcl
     set mom_sys_post_initialized 1
  }


#=============================================================
proc OUTPUT_MACRO { macro_string suppress_seqno } {
#=============================================================
# This command will be called in PB_call_macro to split a macro string
# into multiple lines of output by the separator "{n}" token.
#
# 03-04-2019 gsl - New
#
# OPERATOR_MSG "MACRO_STRING : $macro_string"

   set seqno_status [MOM_set_seq_off]
   if { [string match "on" $seqno_status] } { MOM_set_seq_on }

   if { [string match "on" $seqno_status] && $suppress_seqno } {
      set suppress_seqno 1
   } else {
      set suppress_seqno 0
   }


  # Define split_str -
   set split_str "\{n\}"

   set string_list [split $macro_string ${split_str}]
   set list_len [llength $string_list]

   set blank ""

   set i 0
   foreach s $string_list {
      if { $i == 0 } {
         if { $suppress_seqno } {
            MOM_suppress once N
            MOM_output_literal $s
         } else {
            MOM_output_literal $s

            if { $list_len > 1 } {
               set n_blank [expr [string length [MOM_ask_address_value N]] +\
                                 [string length $::mom_sys_word_separator] +\
                                 [string length $::mom_sys_leader(N)]]

               if { $n_blank > 0 } {
                  append blank [format %${n_blank}c 32]
               }
            }
         }
      } else {
         if [string match "on" $seqno_status] {
            MOM_suppress once N
         }
         if { $suppress_seqno } {
            MOM_output_literal $s
         } else {
            MOM_output_literal "${blank}$s"
         }
      }
      incr i
   }
}


#=============================================================
proc GET_SUBOP_MOVE_NAME { move_type } {
#=============================================================
# Aug-15-2018 gsl - Return GMC subop name of interOp path
#
   switch $move_type {
      10 {
         set move_name "Tool_Change_Container"
      }
      11 {
         set move_name "Tool_Change_Position"
      }
      12 {
         set move_name "Rotary_Tool_Center_Point_On"
      }
      13 {
         set move_name "Rotary_Tool_Center_Point_Off"
      }
      115 {
         set move_name "Move_to_Machine_Postion"
      }
      810 {
         set move_name "Rotary_Point_Vector_Move"
      }
      default {
         set move_name "Unknown"
      }
   }

return $move_name
}


#=============================================================
proc PB_CMD__handle_end_of_subop_path { } {
#=============================================================
# 10/31/2018 gsl - This command can be called by MOM_end_of_subop_path handler.
#
   global mom_move_type
   global mom_move_type_name ;# <-- not reliable!
   global mom_RTCP ;# ON/OFF

   set subop [GET_SUBOP_MOVE_NAME $::mom_move_type]

# OPERATOR_MSG ">>> End of subop >$subop< $::mom_move_type"

   switch "$subop" {
      "Tool_Change_Container" {
        # Remove info of tool change position when done.
         UNSET_VARS ::mom_sys_interop_tool_change_pos
      }
      "Tool_Change_Position" {
        # Save tool change position info
         if { $::mom_interop_has_tool_change_container } {
            VMOV 5 ::mom_pos ::mom_sys_interop_tool_change_pos
         }
      }
      "Rotary_Tool_Center_Point_On" {
      }
      "Rotary_Tool_Center_Point_Off" {
      }
      "Move_to_Machine_Postion" {
      }
      "Rotary_Point_Vector_Move" {
      }
      default {
      }
   }
}


#=============================================================
proc PB_CMD__handle_start_of_subop_path { } {
#=============================================================
# 10/31/2018 gsl - This command can be called by MOM_start_of_subop_path handler.
#
   global mom_move_type
   global mom_move_type_name
   global mom_RTCP ;# ON/OFF

   global mom_tool_change_status

   set subop [GET_SUBOP_MOVE_NAME $::mom_move_type]

# OPERATOR_MSG ">>> Start of subop >$subop< $::mom_move_type"

   switch "$subop" {
      "Rotary_Tool_Center_Point_On" {
      }
      "Rotary_Tool_Center_Point_Off" {
      }
      "Move_to_Machine_Postion" {
      }
      "Rotary_Point_Vector_Move" {
      }
      default {
      }
   }
}


#=============================================================
proc PB_CMD__interop_is_transition_path { } {
#=============================================================
# 10/31/2018 gsl - This command can be used to identify an interOp operation.
#
   if { $::mom_operation_type_enum == 900 } {
return 1
   } else {
return 0
   }
}


#=============================================================
proc PB_CMD__interop_init_vars { } {
#=============================================================
# 31-Aug-2018 gsl - This command can be used to initialize some variables
#                   referenced while handling interOp GMC subops.
#
   INIT_VAR ::mom_interop_has_tool_change_container
   INIT_VAR ::mom_interop_has_tool_change_position
   INIT_VAR ::mom_interop_has_tool_change
}


#===============================================================================
proc PB_CMD_kin_before_output { } {
#===============================================================================
# Broker command ensuring PB_CMD_before_output, if present, gets executed
# by MOM_before_output.
#
# ==> DO NOT add anything here!
# ==> All customization must be done in PB_CMD_before_output!
# ==> PB_CMD_before_output MUST NOT call any "MOM_output" commands!
#
   if { [CMD_EXIST PB_CMD_before_output] } {
      PB_CMD_before_output
   }
}


if 0 {  ;# Hide this command by defualt
#===============================================================================
proc PB_CMD_before_output { } {
#===============================================================================
# This command allows users to massage the NC code (mom_o_buffer) before
# it gets output.  If present in the post, this command is executed
# automatically by MOM_before_output.
#
# - DO NOT overload "MOM_before_output", all customization must be done here!
# - DO NOT call any MOM output commands here, it will become cyclicle!
# - DO NOT attach this command to any event marker!
#
# ==> This command may be removed or renamed, if nothing to be processed here,
#     to improve post performance.

   global mom_o_buffer
   global mom_sys_leader
   global mom_sys_control_out mom_sys_control_in

}
}


#=============================================================
proc PB_CMD_kin_abort_event { } {
#=============================================================
   if { [CMD_EXIST PB_CMD_abort_event] } {
      PB_CMD_abort_event
   }
}


#=============================================================
proc PB_CMD_abort_event { } {
#=============================================================
# This command is automatically called by every motion event
# to abort its handler based on the flag set by other events
# under certain conditions, such as an invalid tool axis vector.
#
# Users can set the global variable mom_sys_abort_next_event to
# different severity levels (non-zero) throughout the post and
# designate how to handle different conditions in this command.
#
# - Rapid, linear, circular and cycle move events have this trigger
#   built in by default in PB6.0.
#
# 06-17-13 gsl - Do not abort event, by default, when signal is "1".
# 07-16-15 gsl - Added level 3 handling

   if { [info exists ::mom_sys_abort_next_event] } {

      switch $::mom_sys_abort_next_event {
         2 -
         3 {
           # User may choose to abort NX/Post
            set __abort_post 0

            if { $__abort_post } {
               set msg "NX/Post Aborted: Illegal Move ($::mom_sys_abort_next_event)"

               if { [info exists ::mom_post_in_simulation] && $::mom_post_in_simulation == "MTD" } {
                 # In simulation, user will choose "Cancel" to stop the process.
                  PAUSE MOM_abort $msg
               } else {
                  MOM_abort $msg
               }
            }

           # Level 2 only aborts current event; level 3 will abort entire motion.
            if { $::mom_sys_abort_next_event == 2 } {
               unset ::mom_sys_abort_next_event
            }

            CATCH_WARNING "Event aborted!"
            MOM_abort_event
         }
         default {
            unset ::mom_sys_abort_next_event
            CATCH_WARNING "Event warned!"
         }
      }

   }
}


#=============================================================
proc PB_CMD___log_revisions { } {
#=============================================================
# Dummy command to log changes in this post --
#
# 15-Jul-2014 gsl - Initial version
#
}


#=============================================================
proc PB_CMD__config_post_options { } {
#=============================================================
# <PB v10.03>
# This command should be called by Start-of-Program event;
# it enables users to set options (not via UI) that would
# affect the behavior and output of this post.
#
# Comment out next line to activate this command
return

  # <PB v10.03>
  # - Feed mode for RETRACT motion has been handled as RAPID,
  #   next option enables users to treat RETRACT as CONTOURing.
  #
   if { ![info exists ::mom_sys_retract_feed_mode] } {
      set ::mom_sys_retract_feed_mode  "CONTOUR"
   }
}


#=============================================================
proc PB_CMD__manage_part_attributes { } {
#=============================================================
# This command allows the user to manage the MOM variables
# generated for the part attributes, in case of conflicts.
#
# ==> This command is executed automatically when present in
#     the post. DO NOT add or call it in any event or command.
#

  # This command should only be called by MOM__part_attributes!
   if { ![CALLED_BY "MOM__part_attributes"] } {
return
   }

  #+++++++++++++++++++++++++++++++++++++
  # You may manage part attributes here
  #+++++++++++++++++++++++++++++++++++++
}


#=============================================================
proc PB_CMD__suppress_probe_bore_clearance_retract { } {
#=============================================================
# - For Probing Operation -
#
# By default, NX/Post generates protected moves to enter and retract from
# the bore feature of a probing cycle when the radial clearance is zero.
#
# ==> This command can be attached to the "Start of Program" event
#     to suppress the retract motion of the protected move.
# 
# 19-Mar-2019 gsl - New
#
   set ::mom_sys_suppress_probe_bore_clearance_retract 1
}


#=============================================================
proc PB_CMD_ask_machine_type { } {
#=============================================================
# Utility to return machine type per mom_kin_machine_type
#
# Revisions:
#-----------
# 02-26-09 gsl - Initial version
#
   global mom_kin_machine_type

   if { [string match "*wedm*" $mom_kin_machine_type] } {
return WEDM
   } elseif { [string match "*axis*" $mom_kin_machine_type] } {
return MILL
   } elseif { [string match "*lathe*" $mom_kin_machine_type] } {
return TURN
   } else {
return $mom_kin_machine_type
   }
}


#=============================================================
proc PB_CMD_kin_set_csys { } {
#=============================================================
   if { [CMD_EXIST PB_CMD_set_csys] } {
      PB_CMD_set_csys
   }
}


#=============================================================
proc PB_CMD_set_csys { } {
#=============================================================
# This custom command is provided as the default to nullify
# the same command in a linked post that may have been
# imported from pb_cmd_coordinate_system_rotation.tcl.
#
}


#=============================================================
proc PB_CMD_kin_end_of_path { } {
#=============================================================
  # Record tool time for this operation.
   if { [CMD_EXIST PB_CMD_set_oper_tool_time] } {
      PB_CMD_set_oper_tool_time
   }

  # Clear tool holder angle used in operation
   global mom_use_b_axis
   UNSET_VARS mom_use_b_axis
}


#=============================================================
proc PB_CMD_kin_feedrate_set { } {
#=============================================================
# This command supercedes the functionalites provided by the
# FEEDRATE_SET in ugpost_base.tcl.  Post Builder automatically
# generates proper call sequences to this command in the
# Event handlers.
#
# This command must be used in conjunction with ugpost_base.tcl.
#
   global   feed com_feed_rate
   global   mom_feed_rate_output_mode super_feed_mode feed_mode
   global   mom_cycle_feed_rate_mode mom_cycle_feed_rate
   global   mom_cycle_feed_rate_per_rev
   global   mom_motion_type
   global   Feed_IPM Feed_IPR Feed_MMPM Feed_MMPR Feed_INV
   global   mom_sys_feed_param
   global   mom_sys_cycle_feed_mode


   set super_feed_mode $mom_feed_rate_output_mode

   set f_pm [ASK_FEEDRATE_FPM]
   set f_pr [ASK_FEEDRATE_FPR]


  #<12-16-2014 gsl> To determine feed mode for RETRACT per motion type
   global mom_motion_event
   if { ![info exists mom_motion_event] } {
      set mom_motion_event UNDEFINED
   }

   set feed_type RAPID


   switch $mom_motion_type {

      CYCLE {
         if { [info exists mom_sys_cycle_feed_mode] } {
            if { [string compare "Auto" $mom_sys_cycle_feed_mode] } {
               set mom_cycle_feed_rate_mode $mom_sys_cycle_feed_mode
            }
         }
         if { [info exists mom_cycle_feed_rate_mode] }    { set super_feed_mode $mom_cycle_feed_rate_mode }
         if { [info exists mom_cycle_feed_rate] }         { set f_pm $mom_cycle_feed_rate }
         if { [info exists mom_cycle_feed_rate_per_rev] } { set f_pr $mom_cycle_feed_rate_per_rev }
      }

      FROM -
      RETURN -
      LIFT -
      TRAVERSAL -
      GOHOME -
      GOHOME_DEFAULT -
      RAPID {
        #<Sep-07-2016 gsl>
        # SUPER_FEED_MODE_SET RAPID
         if { [string match "linear_move"   $mom_motion_event] ||\
              [string match "circular_move" $mom_motion_event] } {
            set feed_type CONTOUR
         }
      }

      default {
        #<Sep-07-2016 gsl>
         if { !([EQ_is_zero $f_pm] && [EQ_is_zero $f_pr]) } {
            set feed_type CONTOUR
         }
      }
   }

  #<Sep-07-2016 gsl>
   if { ![string match "CYCLE" $mom_motion_type] } {
      SUPER_FEED_MODE_SET $feed_type
   }


  # Treat RETRACT as cutting when specified
   global mom_sys_retract_feed_mode
   if { [string match "RETRACT" $mom_motion_type] } {

      if { [info exist mom_sys_retract_feed_mode] && [string match "CONTOUR" $mom_sys_retract_feed_mode] } {
         if { !([EQ_is_zero $f_pm] && [EQ_is_zero $f_pr]) } {
            SUPER_FEED_MODE_SET CONTOUR
         }
      }
   }


   set feed_mode $super_feed_mode


  # Adjust feedrate format per Post output unit again.
   global mom_kin_output_unit
   if { ![string compare "IN" $mom_kin_output_unit] } {
      switch $feed_mode {
         MMPM {
            set feed_mode "IPM"
            CATCH_WARNING "Feedrate mode MMPM changed to IPM"
         }
         MMPR {
            set feed_mode "IPR"
            CATCH_WARNING "Feedrate mode MMPR changed to IPR"
         }
      }
   } else {
      switch $feed_mode {
         IPM {
            set feed_mode "MMPM"
            CATCH_WARNING "Feedrate mode IPM changed to MMPM"
         }
         IPR {
            set feed_mode "MMPR"
            CATCH_WARNING "Feedrate mode IPR changed to MMPR"
         }
      }
   }


   switch $feed_mode {
      IPM     -
      MMPM    { set feed $f_pm }
      IPR     -
      MMPR    { set feed $f_pr }
      DPM     { set feed [PB_CMD_FEEDRATE_DPM] }
      FRN     -
      INVERSE { set feed [PB_CMD_FEEDRATE_NUMBER] }
      default {
         CATCH_WARNING "INVALID FEED RATE MODE"
         return
      }
   }


  # Post Builder provided format for the current mode:
   if { [info exists mom_sys_feed_param(${feed_mode},format)] } {
      MOM_set_address_format F $mom_sys_feed_param(${feed_mode},format)
   } else {
      switch $feed_mode {
         IPM     -
         MMPM    -
         IPR     -
         MMPR    -
         DPM     -
         FRN     { MOM_set_address_format F Feed_${feed_mode} }
         INVERSE { MOM_set_address_format F Feed_INV }
      }
   }


  # Commentary output
   set com_feed_rate $f_pm


  # Execute user's command, if any.
   if { [CMD_EXIST PB_CMD_FEEDRATE_SET] } {
      PB_CMD_FEEDRATE_SET
   }
}


#=============================================================
proc PB_CMD_start_of_alignment_character { } {
#=============================================================
# This command can be used to output a special sequence number character.  
# Replace the ":" with any character that you require.
# You must use the command "PB_CMD_end_of_alignment_character" to reset
# the sequence number back to the original setting.
#
   global mom_sys_leader saved_seq_num
   set saved_seq_num $mom_sys_leader(N)
   set mom_sys_leader(N) ":"
}


#=============================================================
proc PB_CMD_end_of_alignment_character { } {
#=============================================================
# This command restores sequnece number back to the orignal.
# It may be used with the command "PM_CMD_start_of_alignment_character"
#
   global mom_sys_leader saved_seq_num
   if { [info exists saved_seq_num] } {
      set mom_sys_leader(N) $saved_seq_num
   }
}


#=============================================================
proc PB_CMD_pause { } {
#=============================================================
# This command enables you to pause the UG/Post processing.
#
   PAUSE
}


#=============================================================
proc PB_CMD_run_postprocess { } {
#=============================================================
# This is an example showing how MOM_run_postprocess can be used.
# It can be called in the Start of Program event (or anywhere)
# to process the same objects being posted using a secondary post.
# 
# ==> It's advisable NOT to use the active post and the same
#     output file for this secondary posting job.
# ==> Ensure legitimate and fully qualified file path for post processor and
#     the output file are specified (in platform convention) for the command.
#

#++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
# CAUTION - Comment out next line to activate this function!
return
#++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++

   MOM_run_postprocess "[file dirname $::mom_event_handler_file_name]/MORI_HORI_Sub.tcl"\
                       "[file dirname $::mom_event_handler_file_name]/MORI_HORI_Sub.def"\
                       "${::mom_output_file_directory}sub_program.out"
}


#=============================================================
proc PB_CMD_cancel_suppress_force_once_per_event { } {
#=============================================================
# This command can be called to cancel the effect of
# "MOM_force Once" & "MOM_suppress Once" for each event.
#
# => It's to keep the effect of force & suppress once within
#    the scope of the event that issues the commands and
#    eliminate the unexpected residual effect of such commands
#    that may have been issued by other events.
#
# PB v11.02 -
#
   MOM_cancel_suppress_force_once_per_event
}


#=============================================================
proc ABORT_EVENT_CHECK { } {
#=============================================================
# Called by every motion event to abort its handler based on
# the setting of mom_sys_abort_next_event.
#
   if { [info exists ::mom_sys_abort_next_event] && $::mom_sys_abort_next_event } {
      if { [CMD_EXIST PB_CMD_kin_abort_event] } {
         PB_CMD_kin_abort_event
      }
   }
}


#=============================================================
proc HANDLE_FIRST_LINEAR_MOVE { } {
#=============================================================
# Called by MOM_linear_move to handle the 1st linear move of an operation.
#
   if { ![info exists ::first_linear_move] } {
      set ::first_linear_move 0
   }
   if { !$::first_linear_move } {
      PB_first_linear_move
      incr ::first_linear_move
   }
}


#=============================================================
proc OPERATOR_MSG { msg {seq_no 0} } {
#=============================================================
# This command will output a single or a set of operator message(s).
#
#   msg    : Message(s separated by new-line character)
#   seq_no : 0 Output message without sequence number (Default)
#            1 Output message with sequence number
#
  # Don't opskip operator's messages
   if { [info exists ::mom_sys_opskip_on] && $::mom_sys_opskip_on } {
      MOM_set_line_leader off $::mom_sys_opskip_block_leader
   }

   foreach s [split $msg \n] {
      set s1 "$::mom_sys_control_out $s $::mom_sys_control_in"
      if { !$seq_no } {
         MOM_suppress once N
      }
      MOM_output_literal $s1
   }

   if { [info exists ::mom_sys_opskip_on] && $::mom_sys_opskip_on } {
      MOM_set_line_leader always $::mom_sys_opskip_block_leader
   }

   set ::mom_o_buffer ""
}


#=============================================================
proc WORKPLANE_SET { } {
#=============================================================
   global mom_cycle_spindle_axis
   global mom_sys_spindle_axis
   global traverse_axis1 traverse_axis2

   if { ![info exists mom_sys_spindle_axis] } {
      set mom_sys_spindle_axis(0) 0.0
      set mom_sys_spindle_axis(1) 0.0
      set mom_sys_spindle_axis(2) 1.0
   }

   if { ![info exists mom_cycle_spindle_axis] } {
      set x $mom_sys_spindle_axis(0)
      set y $mom_sys_spindle_axis(1)
      set z $mom_sys_spindle_axis(2)

      if { [EQ_is_zero $y] && [EQ_is_zero $z] } {
         set mom_cycle_spindle_axis 0
      } elseif { [EQ_is_zero $x] && [EQ_is_zero $z] } {
         set mom_cycle_spindle_axis 1
      } else {
         set mom_cycle_spindle_axis 2
      }
   }

   if { $mom_cycle_spindle_axis == 2 } {
      set traverse_axis1 0 ; set traverse_axis2 1
   } elseif { $mom_cycle_spindle_axis == 0 } {
      set traverse_axis1 1 ; set traverse_axis2 2
   } elseif { $mom_cycle_spindle_axis == 1 } {
      set traverse_axis1 0 ; set traverse_axis2 2
   }
}




