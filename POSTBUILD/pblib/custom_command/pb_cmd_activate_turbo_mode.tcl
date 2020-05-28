##############################################################################
#                                                                            #
# Copyright (c) 1999/2000/2001/2002/2003/2004/2005/2006, UGS PLM Solutions.  #
# Copyright (c) 2007/2008/2009, SIEMENS PLM Softwares.                       #
#                                                                            #
##############################################################################



#=============================================================
proc PB_CMD_activate_Fanuc_turbo_mode { } {
#=============================================================
#
#  This custom command will activate the turbo process mode for
#  the FANUC style of 3-axis & 5-axis mill posts. The execution
#  time will be about 5 to 10 times faster than the normal process.
#
#  This command may only be used with Post Builder 3.2.1 or later
#  and NX2 or newer.
#
#  ==> Place this command with the "Start of Program" event marker.
#
#
#  The following turbo blocks are defined within this command:
#
#     linear_move_turbo
#     circular_move_turbo
#     rapid_move_turbo
#     sequence_number_turbo
#
#  All rapid motion is output in a single move.
#
#  ==> You may re-arrange the words sequence within each block template.
#      You MUST NOT, however, edit the expression in the words,
#      remove or add any other words in any of these turbo blocks.
#
#
#  In Post Builder, you may modify the Word parameters from
#  the N/C Data Defitions dialog to configure the output of that
#  word used within the turbo blocks. You may also modify the Format
#  parameters.
#
#  Any custom commands in the linear move, circular move, rapid move
#  and mom_before_motion events will be ignored.
#



   global mom_kin_machine_type

   if { [string match "*wedm*" $mom_kin_machine_type] ||\
        [string match "*lathe*" $mom_kin_machine_type] ||\
        [string match "*mill_turn*" $mom_kin_machine_type] } {

      set msg "Turbo mode can only be activated for 3, 4 & 5-axis mill posts!"

      if { [llength [info commands PAUSE] ] } {
         PAUSE "Turbo Mode Activation Error" $msg
      }

      CATCH_WARNING $msg
return
   }



  # Open scratch file for turbo blocks definition
   global mom_logname
   global env

   set ugii_tmp_dir [MOM_ask_env_var UGII_TMP_DIR]

   set def_file_name  [file join $ugii_tmp_dir __${mom_logname}_turbo_blocks_[clock clicks].def]
   if { [catch { set tmp_file [open "$def_file_name" w] } res] } {

      if { ![info exists res] } {
         set res "$def_file_name\nFile open error!"
      }
      if { [llength [info commands PAUSE] ] } {
         PAUSE "Turbo Blocks Definition Error" $res
      }

      CATCH_WARNING $res
return
   }



  # Skip multi-axis turbo mode for pre-NX7
   if { ![string match "3_axis_mill" $mom_kin_machine_type] } {
      global env

      set ugii_version [string trimleft [MOM_ask_env_var UGII_VERSION] v]
      if { $ugii_version < 7 } {

         CATCH_WARNING "Multi-axis turbo mode is not available in NX$ugii_version."
         close $tmp_file
return
      }
   }



  # Activate turbo mode
  # -- Turbo mode may be set outside of this command or
  #    forced to be "TRUE" here.
   global mom_kin_is_turbo_output

   if { ![info exists mom_kin_is_turbo_output] } {
      set turbo_mode  "TRUE"
   } else {
      set turbo_mode  $mom_kin_is_turbo_output
   }

   set mom_kin_is_turbo_output  $turbo_mode

   MOM_reload_kinematics


   if { ![string match "TRUE" $mom_kin_is_turbo_output] } {
      close $tmp_file
return
   }



   fconfigure $tmp_file -translation lf

  # Define turbo blocks
   puts $tmp_file "MACHINE mill"
   puts $tmp_file ""
   puts $tmp_file "FORMATTING"
   puts $tmp_file "\{"
   puts $tmp_file "  BLOCK_TEMPLATE circular_move_turbo"
   puts $tmp_file "  \{"
   puts $tmp_file "       G_plane\[^sys_cutcom_plane_code(CUTCOM_PLANE)\]\\opt"
   puts $tmp_file "       G_motion\[^sys_circle_code(ARC_DIRECTION)\]\\opt"
   puts $tmp_file "       G_mode\[^sys_output_code(OUTPUT_MODE)\]"
   puts $tmp_file "       X\[^POSX\]"
   puts $tmp_file "       Y\[^POSY\]"
   puts $tmp_file "       Z\[^POSZ\]"
   puts $tmp_file "       I\[^CENTERX\]"
   puts $tmp_file "       J\[^CENTERY\]"
   puts $tmp_file "       K\[^CENTERZ\]"
   puts $tmp_file "       F\[^FEED\]"
   puts $tmp_file "       S\[^SPINDLE_SPEED\]"
   puts $tmp_file "       M_spindle\[^sys_spindle_direction_code(SPINDLE_DIRECTION)\]\\opt"
   puts $tmp_file "       M_coolant\[^sys_coolant_code(COOLNT_STATUS)\]\\opt"
   puts $tmp_file "  \}"
   puts $tmp_file ""

   if { [string match "3_axis_mill" $mom_kin_machine_type] } {

      puts $tmp_file "  BLOCK_TEMPLATE linear_move_turbo"
      puts $tmp_file "  \{"
      puts $tmp_file "       G_cutcom\[^sys_cutcom_code(CUTCOM_STATUS)\]\\opt"
      puts $tmp_file "       G_plane\[^sys_cutcom_plane_code(CUTCOM_PLANE)\]\\opt"
      puts $tmp_file "       G_motion\[^sys_linear_code\]"
      puts $tmp_file "       G_mode\[^sys_output_code(OUTPUT_MODE)\]"
      puts $tmp_file "       X\[^POSX\]"
      puts $tmp_file "       Y\[^POSY\]"
      puts $tmp_file "       Z\[^POSZ\]"
      puts $tmp_file "       F\[^FEED\]"
      puts $tmp_file "       D\[^cutcom_adjust_register\]\\opt"
      puts $tmp_file "       S\[^SPINDLE_SPEED\]"
      puts $tmp_file "       M_spindle\[^sys_spindle_direction_code(SPINDLE_DIRECTION)\]\\opt"
      puts $tmp_file "       M_coolant\[^sys_coolant_code(COOLNT_STATUS)\]\\opt"
      puts $tmp_file "  \}"
      puts $tmp_file ""
      puts $tmp_file "  BLOCK_TEMPLATE rapid_move_turbo"
      puts $tmp_file "  \{"
      puts $tmp_file "       G_adjust\[^sys_adjust_code\]"
      puts $tmp_file "       G_motion\[^sys_rapid_code\]"
      puts $tmp_file "       G_mode\[^sys_output_code(OUTPUT_MODE)\]"
      puts $tmp_file "       X\[^POSX\]"
      puts $tmp_file "       Y\[^POSY\]"
      puts $tmp_file "       Z\[^POSZ\]"
      puts $tmp_file "       H\[^tool_adjust_register\]\\opt"
      puts $tmp_file "       S\[^SPINDLE_SPEED\]"
      puts $tmp_file "       M_spindle\[^sys_spindle_direction_code(SPINDLE_DIRECTION)\]\\opt"
      puts $tmp_file "       M_coolant\[^sys_coolant_code(COOLNT_STATUS)\]\\opt"
      puts $tmp_file "  \}"

   } elseif { [string match "4_axis*" $mom_kin_machine_type] } {

      puts $tmp_file "  BLOCK_TEMPLATE linear_move_turbo"
      puts $tmp_file "  \{"
      puts $tmp_file "       G_cutcom\[^sys_cutcom_code(CUTCOM_STATUS)\]\\opt"
      puts $tmp_file "       G_plane\[^sys_cutcom_plane_code(CUTCOM_PLANE)\]\\opt"
      puts $tmp_file "       G_motion\[^sys_linear_code\]"
      puts $tmp_file "       G_mode\[^sys_output_code(OUTPUT_MODE)\]"
      puts $tmp_file "       X\[^POSX\]"
      puts $tmp_file "       Y\[^POSY\]"
      puts $tmp_file "       Z\[^POSZ\]"
      puts $tmp_file "       fourth_axis\[^POS4\]"
      puts $tmp_file "       F\[^FEED\]"
      puts $tmp_file "       D\[^cutcom_adjust_register\]\\opt"
      puts $tmp_file "       S\[^SPINDLE_SPEED\]"
      puts $tmp_file "       M_spindle\[^sys_spindle_direction_code(SPINDLE_DIRECTION)\]\\opt"
      puts $tmp_file "       M_coolant\[^sys_coolant_code(COOLNT_STATUS)\]\\opt"
      puts $tmp_file "  \}"
      puts $tmp_file ""
      puts $tmp_file "  BLOCK_TEMPLATE rapid_move_turbo"
      puts $tmp_file "  \{"
      puts $tmp_file "       G_adjust\[^sys_adjust_code\]"
      puts $tmp_file "       G_motion\[^sys_rapid_code\]"
      puts $tmp_file "       G_mode\[^sys_output_code(OUTPUT_MODE)\]"
      puts $tmp_file "       X\[^POSX\]"
      puts $tmp_file "       Y\[^POSY\]"
      puts $tmp_file "       Z\[^POSZ\]"
      puts $tmp_file "       fourth_axis\[^POS4\]"
      puts $tmp_file "       H\[^tool_adjust_register\]\\opt"
      puts $tmp_file "       S\[^SPINDLE_SPEED\]"
      puts $tmp_file "       M_spindle\[^sys_spindle_direction_code(SPINDLE_DIRECTION)\]\\opt"
      puts $tmp_file "       M_coolant\[^sys_coolant_code(COOLNT_STATUS)\]\\opt"
      puts $tmp_file "  \}"

   } else {

      puts $tmp_file "  BLOCK_TEMPLATE linear_move_turbo"
      puts $tmp_file "  \{"
      puts $tmp_file "       G_cutcom\[^sys_cutcom_code(CUTCOM_STATUS)\]\\opt"
      puts $tmp_file "       G_plane\[^sys_cutcom_plane_code(CUTCOM_PLANE)\]\\opt"
      puts $tmp_file "       G_motion\[^sys_linear_code\]"
      puts $tmp_file "       G_mode\[^sys_output_code(OUTPUT_MODE)\]"
      puts $tmp_file "       X\[^POSX\]"
      puts $tmp_file "       Y\[^POSY\]"
      puts $tmp_file "       Z\[^POSZ\]"
      puts $tmp_file "       fourth_axis\[^POS4\]"
      puts $tmp_file "       fifth_axis\[^POS5\]"
      puts $tmp_file "       F\[^FEED\]"
      puts $tmp_file "       D\[^cutcom_adjust_register\]\\opt"
      puts $tmp_file "       S\[^SPINDLE_SPEED\]"
      puts $tmp_file "       M_spindle\[^sys_spindle_direction_code(SPINDLE_DIRECTION)\]\\opt"
      puts $tmp_file "       M_coolant\[^sys_coolant_code(COOLNT_STATUS)\]\\opt"
      puts $tmp_file "  \}"
      puts $tmp_file ""
      puts $tmp_file "  BLOCK_TEMPLATE rapid_move_turbo"
      puts $tmp_file "  \{"
      puts $tmp_file "       G_adjust\[^sys_adjust_code\]"
      puts $tmp_file "       G_motion\[^sys_rapid_code\]"
      puts $tmp_file "       G_mode\[^sys_output_code(OUTPUT_MODE)\]"
      puts $tmp_file "       X\[^POSX\]"
      puts $tmp_file "       Y\[^POSY\]"
      puts $tmp_file "       Z\[^POSZ\]"
      puts $tmp_file "       fourth_axis\[^POS4\]"
      puts $tmp_file "       fifth_axis\[^POS5\]"
      puts $tmp_file "       H\[^tool_adjust_register\]\\opt"
      puts $tmp_file "       S\[^SPINDLE_SPEED\]"
      puts $tmp_file "       M_spindle\[^sys_spindle_direction_code(SPINDLE_DIRECTION)\]\\opt"
      puts $tmp_file "       M_coolant\[^sys_coolant_code(COOLNT_STATUS)\]\\opt"
      puts $tmp_file "  \}"
   }

   puts $tmp_file ""
   puts $tmp_file "  BLOCK_TEMPLATE sequence_number_turbo"
   puts $tmp_file "  \{"
   puts $tmp_file "       N\[^SEQNUM\]"
   puts $tmp_file "  \}"
   puts $tmp_file "\}"


   close $tmp_file


  # Load turbo blocks

   global tcl_platform
   if { [string match "*windows*" $tcl_platform(platform)] } {
      regsub -all {/} $def_file_name {\\} def_file_name
   }

   if { [catch { MOM_load_definition_file  "$def_file_name" } res] } {

     # Disable turbo mode, if loading failed
      set mom_kin_is_turbo_output  "FALSE"
      MOM_reload_kinematics

      CATCH_WARNING $res
   }

   MOM_remove_file  $def_file_name
}





