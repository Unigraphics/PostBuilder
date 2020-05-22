#=============================================================
proc PB_CMD_init_turbo { } {
#=============================================================
#
#  This custom command may only be used with Post Builder 3.2.1
#  or later and NX2 or later.
#
#  Place this custom command with the "Start of Program" marker.
#
#
#  This custom command will activate the turbo process mode for
#  the 3-axis mill posts. The execution time will be about 5 to
#  10 times faster than the normal process.
#
#  Special Blocks are included in any 3-axis mill post created
#  by Post Builder v3.2.1 and on.
#
#  The blocks being output are formatted similar to that of the
#  Fanuc type of controllers.
#
#  The following turbo blocks will appear in the Block section
#  of N/C Data Definitions in Post Builder:
#
#     linear_move_turbo
#     circular_move_turbo
#     rapid_move_turbo
#     sequence_number_turbo
#
#  In Post Builder, you may modify the Word parameters from
#  the N/C Data Defitions dialog to configure the output of that
#  word used within the turbo blocks. You may also modify the Format
#  parameters. You may not, however, edit the expression in the
#  words, remove or add words in any turbo block.
#
#  All rapid motion is output in a single move.  Any custom 
#  commands in the linear move, circular move, rapid move and 
#  mom_before_motion event markers will be ignored.
#

  global mom_kin_machine_type

  if {$mom_kin_machine_type == "3_axis_mill"} {

    uplevel #0 {
      set mom_kin_is_turbo_output  "TRUE"
      MOM_reload_kinematics
    }
  }
}

