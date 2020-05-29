##############################################################################
# Description
#     This is the event handler file for generic 3axis mill
#
# Revisions
#
#   Date        Who   Reason
# 02-jul-1998   whb   Original
# 31-jul-1998   whb   make system independent
# 26-aug-1998   dty   Add path for ugpost_base.tcl
# 02-dec-1998   bmp   Modified the path for sourced files
# 06-feb-1999   Binu  Changed the environment varibale UGII_CAM_RESOURCE to
#                     UGII_CAM_RESOURCE.
# 24-mar-1999   DTY   Remove source paths
# 20-apr-1999   whb   fix I J K output for arcs
# 01-jun-1999   whb   fix MOM_sequence_number
# 21-Jun-1999   whb   check equality within tolerance ('EQ')
# 27-Jul-1999   whb     add CHECK_OPER_TYPE
# 24-Sep-1999   vb    new machine with preloaded tools
# 31-Jan-2000   whb   add nurbs, make corrections for a working post.
# 22-Mar-2000   whb   update missing globals & add first_tool checking
# 27-Jun-2000   whb   fix circular IJK suppress error
#
# $HISTORY$
#
###############################################################################
###############################################################################
# EVENT HANDLER SECTION 
#   This section contains the control section for mill3ax post processor. 
#   This program logic determinies the output to the post processor file.
# 
#   The following procedures are performed in the order the events are
#   generated.
###############################################################################
#______________________________________________________________________________
#The following command invokes the debugging mode.
#______________________________________________________________________________
#         source [MOM_ask_env_var UGII_CAM_DEBUG_DIR]mom_debug.tcl
#         source [MOM_ask_env_var UGII_CAM_DEBUG_DIR]mom_review.tcl
#********Setting the debug mode ON/OFF
#         MOM_set_debug_mode ON

#______________________________________________________________________________
#The following command invokes the warning mode and the default settings.
#______________________________________________________________________________
         source [MOM_ask_env_var UGII_CAM_POST_DIR]ugpost_base.tcl
#______________________________________________________________________________
#The following file consists of default values set for G & M codes
#______________________________________________________________________________

#********M code declaration

         set mom_sys_program_stop_code              0
         set mom_sys_optional_stop_code             1
         set mom_sys_end_of_program_code            2

         set mom_sys_spindle_direction_code(CLW)    3
         set mom_sys_spindle_direction_code(CCLW)   4
         set mom_sys_spindle_direction_code(OFF)    5

         set mom_sys_tool_change_code               6

         set mom_sys_coolant_code(MIST)             7
         set mom_sys_coolant_code(FLOOD)            8
         set mom_sys_coolant_code(TAP)              8
         set mom_sys_coolant_code(OFF)              9

         set mom_sys_clamp_code(ON)                 10
         set mom_sys_clamp_code(OFF)                11
         set mom_sys_clamp_code(AXISON)             10
         set mom_sys_clamp_code(AXISOFF)            11

#********G code declaration

         set mom_sys_rapid_code                     0

         set mom_sys_linear_code                    1

         set mom_sys_circle_code(CLW)               2
         set mom_sys_circle_code(CCLW)              3

         set mom_sys_delay_code(REVOLUTIONS)        4
         set mom_sys_delay_code(SECONDS)            4

         set mom_sys_nurbs_precision_code           5
         set mom_sys_nurbs_code                     6.2

         set mom_sys_cutcom_plane_code(XY)          17
         set mom_sys_cutcom_plane_code(ZX)          18
         set mom_sys_cutcom_plane_code(YZ)          19

         set mom_sys_cutcom_code(OFF)               40
         set mom_sys_cutcom_code(LEFT)              41
         set mom_sys_cutcom_code(RIGHT)             42

         set mom_sys_inch_code                      70
         set mom_sys_metric_code                    71

         set mom_sys_cycle_breakchip_code           73
         set mom_sys_cycle_bore_no_drag_code        76

         set mom_sys_cycle_off                      80
         set mom_sys_cycle_drill_code               81
         set mom_sys_cycle_drill_dwell_code         82
         set mom_sys_cycle_drill_deep_code          83
         set mom_sys_cycle_tap_code                 84
         set mom_sys_cycle_bore_code                85
         set mom_sys_cycle_bore_drag_code           86
         set mom_sys_cycle_bore_back_code           87
         set mom_sys_cycle_bore_manual_code         88
         set mom_sys_cycle_bore_manual_dwell_code   89
         set mom_sys_cycle_bore_dwell_code          89
 
         set mom_sys_output_code(ABSOLUTE)          90
         set mom_sys_output_code(INCREMENTAL)       91

#_______________________________________________________________________________
# Kinematic Declarations
#_______________________________________________________________________________
         set mom_kin_machine_type                   3_axis_mill
         set mom_kin_machine_resolution             .0001
         set mom_kin_nurbs_output_type              BSPLINE

#_______________________________________________________________________________
# Global Variable Declaration
#_______________________________________________________________________________
         set mom_sys_list_file_columns              132
         set mom_sys_list_file_rows                 50
         set mom_sys_commentary_output              ON
#         set mom_sys_list_output                    OFF
         set mom_sys_group_output                   OFF
         set nurbs_move_flag                        0
         set nurbs_knot_count                       0
         set anchor_flag                            0
         set coolant_flag                           0
         set first_tool                             0

         set mom_tool_number                        0
         set mom_spindle_rpm                        0
#_______________________________________________________________________________
proc  MOM_start_of_program {} {
#_______________________________________________________________________________
# This procedure is executed at the very begining of the program.
# It gets called before any command is read from the task file.
#_______________________________________________________________________________
         global mom_part_name
         global mom_logname
         global mom_date
#********The following procedure opens the warning and listing files
         OPEN_files
#********The following procedure lists the header information in commentary data
         LIST_FILE_HEADER 

         MOM_output_literal "(######## TASK  : $mom_part_name ############)"
         MOM_output_literal "(# Created By   : $mom_logname)"
         MOM_output_literal "(# Creation Date: $mom_date)"
         MOM_output_literal "(############################################)"
         MOM_suppress always N
         MOM_output_literal "%"
         MOM_suppress off    N
         MOM_output_literal "G70 G90"

}

proc     MOM_end_of_program {} {
#_______________________________________________________________________________
# This procedure is executed at the end of the program after all
# the paths are traversed.
#_______________________________________________________________________________
         global mom_part_name

         MOM_spindle_off
         MOM_coolant_off

         MOM_do_template end_of_program
         MOM_output_literal "(###### END OF TASK: $mom_part_name #########)"

#********The following procedure lists the tool list with time in commentary data
         LIST_FILE_TRAILER
#********The following procedure closes the warning and listing files
         CLOSE_files
}

proc  MOM_start_of_path {} {
#_______________________________________________________________________________
# This procedure is executed at the begining of each path in the task
# It gets called after all the general parameters of the path are loaded
# like the path name and the tool name.
#_______________________________________________________________________________
         global mom_path_name
         global mom_tool_name

         MOM_output_literal "(----------------------------------------------------)"
         MOM_output_literal "(Start path: $mom_path_name with tool: $mom_tool_name)"
         MOM_output_literal "(----------------------------------------------------)"

         CHECK_OPER_TYPE
}

proc  MOM_end_of_path {} {
#_______________________________________________________________________________
# This procedure is executed at the end of a path.
#_______________________________________________________________________________
         global mom_path_name
         global nurbs_move_flag

         if {$nurbs_move_flag == 1} {MOM_output_literal "G05 P0"}

         MOM_output_literal "(End Of Path $mom_path_name)"
         set nurbs_move_flag 0
}

proc  MOM_tool_change {} {
#_______________________________________________________________________________
# This procedure is executed at any time there is a tool change.
# It gets called after the tool change data is loaded like the tool number 
# and the register numbers.
#_______________________________________________________________________________
        global first_tool
        set first_tool 0
}

proc  MOM_first_tool {} {
#_______________________________________________________________________________
# This procedure is executed for the first operation, with a tool, in the task.
#_______________________________________________________________________________
        global first_tool
        set first_tool 1
}

proc  MOM_initial_move {} {
#_______________________________________________________________________________
# This procedure is executed for the initial move of each operation.  It assumes 
# the tool is moving from a safe position at rapid to the start of the operation.
#_______________________________________________________________________________
        global   mom_tool_number
        global   mom_coolant_status mom_coolant_mode
        global   mom_spindle_rpm
        global   mom_warning_info
        global   anchor_flag
        global   coolant_flag
        global   first_tool

        set anchor_flag 1
        if { [info exists mom_tool_number] == 0 } {
           set mom_warning_info "TOOL NUMBER NOT SET, DEFAULTING TO 0"
           MOM_catch_warning
           set mom_tool_number 0
        }
        if {$coolant_flag == 1} {
            if {$mom_coolant_mode == "" && $mom_coolant_status == "SAME"} {
                set mom_coolant_mode FLOOD
            }
            if {$mom_coolant_status != "OFF"} {
                set mom_coolant_status $mom_coolant_mode
                MOM_force once coolant_m
            }
        }
	
        if {$first_tool == 0} {
            MOM_spindle_off
            MOM_coolant_off
        }

        MOM_force once  G mode_g Z
        MOM_do_template return_home
        MOM_force once T M
	MOM_do_template tool_change
	MOM_do_template tool_preselect

        MOM_force once motion_g X Y Z H
        MOM_do_template rapid_xy

        if {[info exists mom_spindle_rpm] != 0} {
            if {$mom_spindle_rpm != 0} {
                MOM_force once S spindle_m
                MOM_do_template spindle_start
            } else {
                set mom_warning_info "SPINDLE RPM IS 0"
                MOM_catch_warning
            }
        }

	MOM_do_template rapid_z

}

proc  MOM_first_move {} {
#_______________________________________________________________________________
# This procedure is executed before the motion event is activated.
#_______________________________________________________________________________
         global mom_motion_event
         global mom_warning_info
         global mom_spindle_rpm
         if {[info exists mom_spindle_rpm] != 0} {
            if {$mom_spindle_rpm != 0} {
                MOM_force once S spindle_m
                MOM_do_template spindle_start
            } else {
                set mom_warning_info "SPINDLE RPM IS 0"
                MOM_catch_warning
            }
         }
         catch {MOM_$mom_motion_event}
}

proc  MOM_linear_move {} {
#_______________________________________________________________________________
# This procedure is executed for each linear move. It gets called after
# the positioning varables, position and tool axis (X,Y,Z,TAX,TAY,TAZ) are loaded.
#_______________________________________________________________________________
         global mom_cutcom_mode
         global mom_cutcom_status
         global anchor_flag

         set anchor_flag 1

         if {$mom_cutcom_status == "ON"} {
            set mom_cutcom_status $mom_cutcom_mode
         } elseif {$mom_cutcom_status == "OFF"} {
            MOM_suppress once cutcom_g
         }

         MOM_do_template linear
}

proc  MOM_circular_move {} {
#_______________________________________________________________________________
# This procedure is executed for each circular move. It gets called after
# the circle data are loaded (end point and center).
#_______________________________________________________________________________
         global mom_pos_arc_axis
         global g_plane
         global mom_cutcom_status mom_cutcom_mode
         global anchor_flag

         set anchor_flag 1

         if {$mom_cutcom_status == "ON"} {
            set mom_cutcom_status $mom_cutcom_mode
         } elseif {$mom_cutcom_status == "OFF"} {
            MOM_suppress once cutcom_g
         }

         if {[EQ_is_equal abs($mom_pos_arc_axis(2)) 1.0]} {
             set g_plane "17"
             MOM_suppress once K
         } elseif {[EQ_is_equal abs($mom_pos_arc_axis(1)) 1.0]} {
             set g_plane "18"
             MOM_suppress once J
         } elseif {[EQ_is_equal abs($mom_pos_arc_axis(0)) 1.0]} {
             set g_plane "19"
             MOM_suppress once I
         }

         MOM_do_template circle
}

proc  MOM_helix_move {} {
#_______________________________________________________________________________
# This procedure is executed for each circular move. It gets called after
# the circle data are loaded (end point and center).
#_______________________________________________________________________________
         global mom_pos_arc_axis
         global g_plane
         global mom_cutcom_status mom_cutcom_mode
         global anchor_flag

         set anchor_flag 1

         if {$mom_cutcom_status == "ON"} {
            set mom_cutcom_status $mom_cutcom_mode
         } elseif {$mom_cutcom_status == "OFF"} {
            MOM_suppress once cutcom_g
         }

         if {[EQ_is_equal abs($mom_pos_arc_axis(2)) 1.0]} {
             set g_plane "17"
             MOM_suppress once K
         } elseif {[EQ_is_equal abs($mom_pos_arc_axis(1)) 1.0]} {
             set g_plane "18"
             MOM_suppress once J
         } elseif {[EQ_is_equal abs($mom_pos_arc_axis(0)) 1.0]} {
             set g_plane "19"
             MOM_suppress once I
         }

         MOM_do_template helix
}

proc  MOM_rapid_move {} {
#_______________________________________________________________________________
# This procedure is executed for each rapid move. It gets called after
# the positioning varables, position and tool axis (X,Y,Z,TAX,TAY,TAZ) are loaded.
#_______________________________________________________________________________
         global mom_last_pos
         global mom_pos
         global mom_coolant_status mom_coolant_mode
         global anchor_flag

         set anchor_flag 1
         set mom_coolant_status $mom_coolant_mode

         if {[EQ_is_gt $mom_pos(2) $mom_last_pos(2)]} {
            if {![EQ_is_zero [expr ($mom_pos(2)-$mom_last_pos(2))]]} {
               MOM_do_template rapid_z
            }
            if {![EQ_is_zero [expr (abs($mom_pos(0)-$mom_last_pos(0))+abs($mom_pos(1)-$mom_last_pos(1)))]]} {
               MOM_do_template rapid_xy
            }
         } else {
            if {![EQ_is_zero [expr (abs($mom_pos(0)-$mom_last_pos(0))+abs($mom_pos(1)-$mom_last_pos(1)))]]} {
               MOM_do_template rapid_xy
            }
            if {![EQ_is_zero [expr ($mom_pos(2)-$mom_last_pos(2))]]} {
               MOM_do_template rapid_z
            }
         }
}

proc MOM_nurbs_move {} {
#_______________________________________________________________________________
# This procedure is executed for each nurbs move.
#_______________________________________________________________________________
  global mom_nurbs_knot_count
  global mom_nurbs_point_count
  global mom_nurbs_order

  global nurbs_knot_count
  global nurbs_precision
  global nurbs_move_flag
  global anchor_flag

  if {$nurbs_move_flag == 0} {
      set nurbs_precision 10000
      MOM_do_template nurbs_start
      set nurbs_move_flag 1
  }

  FEEDRATE_SET
  if {$anchor_flag == 1} {
      MOM_do_template anchor_point
      set anchor_flag 0
  }

  set nurbs_knot_count 0
  MOM_set_address_format motion_g nurb_code
  MOM_force once motion_g order X Y Z

  while {$nurbs_knot_count < $mom_nurbs_point_count} {
         MOM_do_template nurbs
         set nurbs_knot_count [expr $nurbs_knot_count + 1]
  }
  while {$nurbs_knot_count < $mom_nurbs_knot_count} {
         MOM_do_template knots
         set nurbs_knot_count [expr $nurbs_knot_count + 1]
  }
  MOM_set_address_format motion_g Register_2

}

proc  MOM_before_output {} {
#_______________________________________________________________________________
# This procedure is executed just before a line is about to be output
# to the file. It loads the line into a variable MOM_o_buffer and then calls
# this procedure. When it returns from this procedure, the variable MOM_o_buffer
# is read and written to the file.
#_______________________________________________________________________________

#########The following procedure invokes the listing file with warnings.

         LIST_FILE
}

proc  cycle_set {} {
#_______________________________________________________________________________
# This procedure is executed for each new cycle.  This will make sure all   
# non-modal addresses and Cycle parameters are output that need to be output
# at the start of a new cycle.
#_______________________________________________________________________________
         global mom_cycle_retract_mode
         global g_return

         MOM_force once motion_g X Y Z R cycle_dwell cycle_nodrag cycle_step

         if {$mom_cycle_retract_mode == "MANUAL"} {
            set g_return 99
         } elseif {$mom_cycle_retract_mode == "AUTO"} {
            set g_return 98
         } else {
            set g_return 99
         }
} 

proc  MOM_cycle_plane_change {} {
#_______________________________________________________________________________
# This procedure is executed at the end of cycle motion when there is a cycle 
# move occuring at a higher level than the previous position.
#_______________________________________________________________________________
         MOM_do_template cycle_plane_change
}

proc  MOM_cycle_off {} {
#_______________________________________________________________________________
# This procedure is executed at the end of cycle motion.
#_______________________________________________________________________________
         MOM_do_template cycle_off
}

proc  MOM_drill {} {
#_______________________________________________________________________________
# This procedure is executed at the begining of a drill cycle.
#_______________________________________________________________________________
	 cycle_set
}

proc  MOM_drill_move {} {
#_______________________________________________________________________________
# This procedure is executed for the goto of a drill cycle.
#_______________________________________________________________________________
	 MOM_do_template cycle_drill
}

proc  MOM_drill_dwell {} {
#_______________________________________________________________________________
# This procedure is executed at the begining of a drill dwell cycle.
#_______________________________________________________________________________
	 cycle_set
}

proc  MOM_drill_dwell_move {} {
#_______________________________________________________________________________
# This procedure is executed for the goto of a drill dwell cycle.
#_______________________________________________________________________________
       	 MOM_do_template cycle_drill_dwell
}

proc  MOM_drill_counter_sink {} {
#_______________________________________________________________________________
# This procedure is executed at the begining of a drill cycle.
#_______________________________________________________________________________
         MOM_drill
}

proc  MOM_drill_counter_sink_move {} {
#_______________________________________________________________________________
# This procedure is executed for the goto of a drill cycle.
#_______________________________________________________________________________
	 MOM_drill_move
}

proc  MOM_drill_csink_dwell {} {
#_______________________________________________________________________________
# This procedure is executed at the begining of a drill dwell cycle.
#_______________________________________________________________________________
	 MOM_drill_dwell
}

proc  MOM_drill_csink_dwell_move {} {
#_______________________________________________________________________________
# This procedure is executed for the goto of a drill dwell cycle.
#_______________________________________________________________________________
       	 MOM_drill_dwell_move
}

proc  MOM_drill_deep {} {
#_______________________________________________________________________________
# This procedure is executed at the begining of a deep cycle.
#_______________________________________________________________________________
	 cycle_set
}

proc  MOM_drill_deep_move {} {
#_______________________________________________________________________________
# This procedure is executed for the goto of a  deep cycle.
#_______________________________________________________________________________
       	 MOM_do_template cycle_drill_deep
}

proc  MOM_drill_break_chip {} {
#_______________________________________________________________________________
# This procedure is executed at the begining of a brkchp cycle.
#_______________________________________________________________________________
       	 cycle_set
}

proc  MOM_drill_break_chip_move {} {
#_______________________________________________________________________________
# This procedure is executed for the goto of a  brkchp cycle.
#_______________________________________________________________________________
       	 MOM_do_template cycle_breakchip
}

proc  MOM_tap {} {
#_______________________________________________________________________________
# This procedure is executed at the begining of a tap cycle.
#_______________________________________________________________________________
	 cycle_set
}

proc  MOM_tap_move {} {
#_______________________________________________________________________________
# This procedure is executed for the goto of a tap cycle.
#_______________________________________________________________________________
       	 MOM_do_template cycle_tap
}

proc  MOM_bore {} {
#_______________________________________________________________________________
# This procedure is executed at the begining of a bore cycle.
#_______________________________________________________________________________
	 cycle_set
}

proc  MOM_bore_move {} {
#_______________________________________________________________________________
# This procedure is executed for the goto of a bore cycle.
#_______________________________________________________________________________
         MOM_do_template cycle_bore
}

proc  MOM_bore_dwell {} {
#_______________________________________________________________________________
# This procedure is executed at the begining of a bore cycle.
#_______________________________________________________________________________
	 cycle_set
}

proc  MOM_bore_dwell_move {} {
#_______________________________________________________________________________
# This procedure is executed for the goto of a bore dwell cycle.
#_______________________________________________________________________________
         MOM_do_template cycle_bore_dwell
}

proc  MOM_bore_drag {} {
#_______________________________________________________________________________
# This procedure is executed at the begining of a bore drag cycle.
#_______________________________________________________________________________
	 cycle_set
}

proc  MOM_bore_drag_move {} {
#_______________________________________________________________________________
# This procedure is executed for the goto of a bore_drag cycle.
#_______________________________________________________________________________
         MOM_do_template cycle_bore_drag
}

proc  MOM_bore_no_drag {} {
#_______________________________________________________________________________
# This procedure is executed at the begining of a bore nodrag cycle.
#_______________________________________________________________________________
	 cycle_set
}

proc  MOM_bore_no_drag_move {} {
#_______________________________________________________________________________
# This procedure is executed for the goto of a bore nodrag cycle.
#_______________________________________________________________________________
       	 MOM_do_template cycle_bore_no_drag
}

proc  MOM_bore_back {} {
#_______________________________________________________________________________
# This procedure is executed at the begining of a bore back cycle.
#_______________________________________________________________________________
	 cycle_set
}

proc  MOM_bore_back_move {} {
#_______________________________________________________________________________
# This procedure is executed for the goto of a back bore cycle.
#_______________________________________________________________________________
       	 MOM_do_template cycle_bore_back
}

proc  MOM_bore_manual {} {
#_______________________________________________________________________________
# This procedure is executed at the begining of a bore manual cycle.
#_______________________________________________________________________________
	 cycle_set
}

proc  MOM_bore_manual_move {} {
#_______________________________________________________________________________
# This procedure is executed for the goto of a manual bore cycle.
#_______________________________________________________________________________
       	 MOM_do_template cycle_bore_manual
}

proc  MOM_bore_manual_dwell {} {
#_______________________________________________________________________________
# This procedure is executed at the begining of a bore manual dwell bore cycle.
#_______________________________________________________________________________
	 cycle_set
}

proc  MOM_bore_manual_dwell_move {} {
#_______________________________________________________________________________
# This procedure is executed for the goto of a manual dwell borecycle.
#_______________________________________________________________________________
       	 MOM_do_template cycle_bore_manual_dwell
}

proc  MOM_load_tool {} {
#_______________________________________________________________________________
# This procedure is executed for the LOAD/TOOL command.  All output for the LOAD
# command will take place with the initial move.
#_______________________________________________________________________________
}

proc  MOM_sequence_number {} {
#_______________________________________________________________________________
# This procedure is executed for the Sequence Number command.
#_______________________________________________________________________________
         global mom_sequence_mode
         global mom_sequence_number
         global mom_sequence_increment
         global mom_sequence_frequency
         global mom_sequence_text
         global mom_warning_info
         if {[isset mom_sequence_mode] == "y"} {
            if {$mom_sequence_mode == "OFF"} {
               MOM_set_seq_off
            } elseif {$mom_sequence_mode == "ON"} {
               MOM_set_seq_on
            } elseif {$mom_sequence_mode == "AUTO"} {
               set mom_warning_info \
                   "SEQNO/AUTO not implemented: Event Name: MOM_sequence_number"
               MOM_catch_warning
            } elseif {$mom_sequence_mode == "N"} {
               MOM_reset_sequence $mom_sequence_number $mom_sequence_increment \
                                  $mom_sequence_frequency
            } else {
               set mom_warning_info \
                   "MOM_SEQUENCE_MODE UNKNOWN: Event Name: MOM_sequence_number"
               MOM_catch_warning
            }
         } else {
            MOM_reset_sequence $mom_sequence_number $mom_sequence_increment $mom_sequence_frequency
         }
}

proc  MOM_set_modes {} {
#_______________________________________________________________________________
# This procedure is executed for the Set Mode command.
#_______________________________________________________________________________
         global mom_output_mode
         global mom_arc_mode
         global mom_feed_rate_output_mode
         global mom_parallel_to_axis
         global mom_machine_mode
         global mom_modes_text


# "ABSOLUTE", "INCREMENTAL"
            if {$mom_output_mode == "ABSOLUTE"} {
                MOM_incremental OFF X Y Z
            } elseif {$mom_output_mode == "INCREMENTAL"} {
                MOM_incremental ON X Y Z
            }
# "LINEAR", "CIRCULAR"
            if {$mom_arc_mode == "LINEAR"} {
            } elseif {$mom_arc_mode == "CIRCULAR"} {
            }
# "OFF", "IPM", "IPR", "MMPM", "MMPR", "INVERSE"
            if {$mom_feed_rate_output_mode == "FPM"} {
            } elseif {$mom_feed_rate_output_mode == "FPR"} {
            } elseif {$mom_feed_rate_output_mode == "INVERSE"} {
            } elseif {$mom_feed_rate_output_mode == "OFF"} {
            }
# "ZAXIS", "WAXIS", "UAXIS"
            if {$mom_parallel_to_axis == "ZAXIS"} {
            } elseif {$mom_parallel_to_axis == "WAXIS"} {
            } elseif {$mom_parallel_to_axis == "UAXIS"} {
            }
# "MILL", "TURN", "PUNCH", "LASER", "TORCH", "WIRE"
            if {$mom_machine_mode == "MILL"} {
            } elseif {$mom_machine_mode == "TURN"} {
            } elseif {$mom_machine_mode == "PUNCH"} {
            } elseif {$mom_machine_mode == "LASER"} {
            } elseif {$mom_machine_mode == "TORCH"} {
            } elseif {$mom_machine_mode == "WIRE"} {
            }
}

proc  MOM_cutcom_on {} {
#_______________________________________________________________________________
# This procedure is executed when the Cutcom command is activated.
#_______________________________________________________________________________
}

proc  MOM_cutcom_off {} {
#_______________________________________________________________________________
# This procedure is executed when the Cutcom command is deactivated.
#_______________________________________________________________________________
         MOM_do_template cutcom_off

}

proc  MOM_spindle_rpm {} {
#_______________________________________________________________________________
# This procedure is executed when the Spindle command is activated.
#_______________________________________________________________________________
}

proc  MOM_spindle_off {} {
#_______________________________________________________________________________
# This procedure is executed when the Spindle command is deactivated.
#_______________________________________________________________________________
         MOM_do_template spindle_off
}

proc  MOM_coolant_on {} {
#_______________________________________________________________________________
# This procedure is executed when the Coolant command is activated.
#_______________________________________________________________________________
        global   coolant_flag
        set coolant_flag 1
}

proc  MOM_coolant_off {} {
#_______________________________________________________________________________
# This procedure is executed when the Coolant command is deactivated.
#_______________________________________________________________________________
         MOM_do_template coolant_off
}

proc  MOM_opstop {} {
#_______________________________________________________________________________
# This procedure is executed when the Optional Stop command is activated.
#_______________________________________________________________________________
         MOM_do_template opstop
}

proc  MOM_stop {} {
#_______________________________________________________________________________
# This procedure is executed when the Program Stop command is activated.
#_______________________________________________________________________________
         MOM_do_template stop
}

proc  MOM_opskip_on {} {
#_______________________________________________________________________________
# This procedure is executed when the Optional skip command is activated.
#_______________________________________________________________________________
         MOM_set_line_leader always "/"
}

proc  MOM_opskip_off {} {
#_______________________________________________________________________________
# This procedure is executed when the Optional skip command is activated.
#_______________________________________________________________________________
         MOM_set_line_leader off "/"
}

proc  MOM_delay {} {
#_______________________________________________________________________________
# This procedure is executed when the Delay command is activated.
#_______________________________________________________________________________
         MOM_force_block Once delay
         MOM_do_template delay
}

proc  MOM_auxfun {} {
#_______________________________________________________________________________
# This procedure is executed when the Auxiliary command is activated.
#_______________________________________________________________________________
         MOM_do_template auxiliary
}

proc  MOM_prefun {} {
#_______________________________________________________________________________
# This procedure is executed when the Preparatory function command is activated.
#_______________________________________________________________________________
         MOM_do_template preparatory
}

proc  MOM_length_compensation {} {
#_______________________________________________________________________________
# This procedure is executed when the Tool Length Compensation command is activated.
#_______________________________________________________________________________
}

proc  MOM_tool_preselect {} {
#_______________________________________________________________________________
# This procedure is executed when the Tool Preselect command is activated.
#_______________________________________________________________________________
}

proc  MOM_text {} {
#_______________________________________________________________________________
# This procedure is executed when the Text command is activated.
#_______________________________________________________________________________
         global   mom_user_defined_text
         MOM_output_literal "($mom_user_defined_text)" 
}

################################################################################
