##############################################################################
#                                                                            #
# Copyright (c) 1999/2000/2001/2002/2003/2004/2005, UGS PLM Solutions.       #
#                                                                            #
##############################################################################

#=============================================================
proc PB_CMD_alignment_block { } {
#=============================================================
  global spindle_is_out  

   MOM_force once X Z M_spindle M_coolant F G_feed

   if { [info exists spindle_is_out] } {
      unset spindle_is_out
   }
}


#=============================================================
proc PB_CMD_config_cycle_start { } {
#=============================================================
# When a post (PUI) is configured to use this command as the
# "post_startblk" parameter, this command will be inserted and
# output as the anchor element for the cycles using "cycle start"
# to execute the cycles.
#
# You can add codes here for the needs of individual cycles or
# any other purposes.
#
# ==> This command MUST NOT be deleted or added to other event markers.
#
}


#=============================================================
proc PB_CMD_kin_init_new_iks { } {
#=============================================================
   global mom_kin_machine_type mom_kin_iks_usage

   if { ![string compare "lathe" $mom_kin_machine_type] } {
      set mom_kin_iks_usage 0
      MOM_reload_kinematics
   }
}


#=============================================================
proc PB_CMD_kin_init_probing_cycles { } {
#=============================================================
# This is a broker command that will intialize settings for probing cycles.
# It will be called by PB_CMD_kin_start_of_program automatically
#
# ==> Do not change its name or use it in any other ways!
#
   if { ![CALLED_BY "PB_CMD_kin_start_of_program"] } {
return
   }


   set cmd PB_CMD_init_probing_cycles
   if { [CMD_EXIST "$cmd"] } {
      eval $cmd
   }
}


#=============================================================
proc PB_CMD_kin_start_of_path { } {
#=============================================================
# - For lathe post -
#
#  This command is executed at the start of every operation.
#  It will verify if a new head (post) was loaded and will
#  then initialize any functionality specific to that post.
#
#  It will also restore the master Start of Program &
#  End of Program event handlers.
#
#  --> DO NOT CHANGE THIS COMMAND UNLESS YOU KNOW WHAT YOU ARE DOING.
#  --> DO NOT CALL THIS COMMAND FROM ANY OTHER CUSTOM COMMAND.
#
  global mom_sys_head_change_init_program

   if { [info exists mom_sys_head_change_init_program] } {

      PB_CMD_kin_start_of_program
      unset mom_sys_head_change_init_program


     # Load alternate units' parameters
      if [CMD_EXIST PB_load_alternate_unit_settings] {
         PB_load_alternate_unit_settings
         rename PB_load_alternate_unit_settings ""
      }


     # Execute start of head callback in new post's context.
      global CURRENT_HEAD
      if { [info exists CURRENT_HEAD] && [CMD_EXIST PB_start_of_HEAD__$CURRENT_HEAD] } {
         PB_start_of_HEAD__$CURRENT_HEAD
      }

     # Restore master start & end of program handlers
      if { [CMD_EXIST "MOM_start_of_program_save"] } {
         if { [CMD_EXIST "MOM_start_of_program"] } {
            rename MOM_start_of_program ""
         }
         rename MOM_start_of_program_save MOM_start_of_program 
      }
      if { [CMD_EXIST "MOM_end_of_program_save"] } {
         if { [CMD_EXIST "MOM_end_of_program"] } {
            rename MOM_end_of_program ""
         }
         rename MOM_end_of_program_save MOM_end_of_program 
      }

     # Restore master head change event handler
      if { [CMD_EXIST "MOM_head_save"] } {
         if { [CMD_EXIST "MOM_head"] } {
            rename MOM_head ""
         }
         rename MOM_head_save MOM_head
      }

     # Reset solver state for lathe post
      if { [CMD_EXIST PB_CMD_reset_lathe_post] } {
         PB_CMD_reset_lathe_post
      }
   }

  # Initialize tool time accumulator for this operation.
   if { [CMD_EXIST PB_CMD_init_oper_tool_time] } {
      PB_CMD_init_oper_tool_time
   }
}


#=============================================================
proc PB_CMD_kin_start_of_program { } {
#=============================================================
#
#  This procedure will execute the following custom commands for
#  initialization.  They will be executed once at the start of 
#  program and again each time they are loaded as a linked post.  
#  After execution they will be deleted so that they are not 
#  present when a different post is loaded.  You may add a call 
#  to a procedure that you want executed when a linked post is 
#  loaded.  
#
#  Note when a linked post is called in, the Start of Program
#  event is not executed again.
#
#  DO NOT REMOVE ANY LINES FROM THIS PROCEDURE UNLESS YOU KNOW
#  WHAT YOU ARE DOING.  DO NOT CALL THIS PROCEDURE FROM ANY
#  OTHER CUSTOM COMMAND.
#
 
   set command_list [list]

   lappend command_list  PB_CMD_kin_init_new_iks

   lappend command_list  PB_CMD_initialize_tool_list
   lappend command_list  PB_CMD_init_tool_list
   lappend command_list  PB_CMD_init_tape_break
   lappend command_list  PB_CMD_set_lathe_arc_plane

   lappend command_list  PB_CMD_kin_init_probing_cycles
   lappend command_list  PB_DEFINE_MACROS


   foreach cmd $command_list {
      if { [CMD_EXIST "$cmd"] } {
         eval $cmd
         rename $cmd ""
         proc $cmd { args } {}
      }
   }
}


#=============================================================
proc PB_CMD_output_spindle { } {
#=============================================================
  global mom_spindle_mode 
  global spindle_is_out
  global mom_spindle_maximum_rpm

   if { ![info exists spindle_is_out] } { 
      if { ![string compare "RPM" $mom_spindle_mode] } {
         MOM_force once M_spindle S G_spin
         MOM_do_template spindle_rpm
      } elseif { ![string compare "SFM" $mom_spindle_mode] || ![string compare "SMM" $mom_spindle_mode] } {
         MOM_force once M_spindle S G G_spin

         if { [info exists mom_spindle_maximum_rpm] && [expr $mom_spindle_maximum_rpm > 0] } {
            MOM_do_template spindle_max_rpm
         }

         MOM_do_template spindle_css
      }
      set spindle_is_out 1
   }
}


#=============================================================
proc PB_CMD_reset_lathe_post { } {
#=============================================================
# ==> This command will be called by PB_CMD_kin_start_of_path automatically.
#     Do not change its name or use it in any other ways!
#
   if { ![CALLED_BY "PB_CMD_kin_start_of_path"] } {
return
   }


   global mom_kin_machine_type

   if { ![string compare "lathe" $mom_kin_machine_type] } {

     # Due to internal procedure, the kinematics must be reloaded twice!
     #
      set mom_kin_machine_type "3_axis_mill"
      MOM_reload_kinematics

      set mom_kin_machine_type "lathe"
      MOM_reload_kinematics
   }
}


#=============================================================
proc PB_CMD_set_lathe_arc_plane { } {
#=============================================================
# This custom command will switch the valid arc plane for lathes
# from XY to ZX when the users selects the ZX lathe work
# plane in the MCS dialog.  If this custom command is not used then
# all arcs will be output as linear moves when the user selects the 
# ZX Plane.
#
# Post Builder v3.0.1 executes this custom command automatically
# for all lathe posts.

  # ==> This command must be called by PB_CMD_kin_start_of_program.
  #
   if { ![CALLED_BY "PB_CMD_kin_start_of_program"] } {
return
   }


   global mom_lathe_spindle_axis
   global mom_kin_arc_valid_plane

   if { [info exists mom_lathe_spindle_axis] && ![string compare "MCSZ" $mom_lathe_spindle_axis] } {
      set mom_kin_arc_valid_plane  "ZX" 
      MOM_reload_kinematics
   }
}


#=============================================================
proc PB_CMD_spindle_sfm_prestart { } {
#=============================================================
  global mom_spindle_mode

   # Output preset instructions when spindle mode is SFM or SMM.
   if { ![string compare "SFM" $mom_spindle_mode] || ![string compare "SMM" $mom_spindle_mode] } {
      MOM_force once G_spin M_spindle S
      MOM_do_template spindle_rpm_preset
   }
}




