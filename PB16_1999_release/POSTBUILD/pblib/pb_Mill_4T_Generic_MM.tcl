############ TCL FILE ######################################
# USER AND DATE STAMP
############################################################

  set cam_post_dir [MOM_ask_env_var UGII_CAM_POST_DIR]
# source ${cam_post_dir}mom_debug.tcl
# source ${cam_post_dir}mom_review.tcl
# MOM_set_debug_mode ON
  source ${cam_post_dir}ugpost_base.tcl

########## SYSTEM VARIABLE DECLARATIONS ##############
  set mom_sys_spindle_mode_code(RPM) 97
  set mom_sys_program_stop_code 0
  set mom_sys_optional_stop_code 1
  set mom_sys_end_of_program_code 2
  set mom_sys_spindle_direction_code(CLW) 3
  set mom_sys_spindle_direction_code(CCLW) 4
  set mom_sys_spindle_direction_code(OFF) 5
  set mom_sys_tool_change_code 6
  set mom_sys_coolant_code(MIST) 7
  set mom_sys_coolant_code(ON) 8
  set mom_sys_coolant_code(FLOOD) 8
  set mom_sys_coolant_code(TAP) 8
  set mom_sys_coolant_code(OFF) 9
  set mom_sys_return_home 28
  set mom_sys_rewind_code 30
  set mom_sys_cutcom_code(LEFT) 41
  set mom_sys_cutcom_code(RIGHT) 42
  set mom_sys_adjust_code 43
  set mom_sys_adjust_code_minus 44
  set mom_sys_adjust_cancel_code 49
  set mom_sys_unit_code(IN) 70
  set mom_sys_unit_code(MM) 71
  set mom_sys_rapid_code 0
  set mom_sys_cycle_breakchip_code 73
  set mom_sys_linear_code 1
  set mom_sys_cycle_bore_no_drag_code 76
  set mom_sys_circle_code(CLW) 2
  set mom_sys_cycle_off 80
  set mom_sys_cycle_drill_code 81
  set mom_sys_circle_code(CCLW) 3
  set mom_sys_cycle_drill_deep_code 83
  set mom_sys_delay_code(SECONDS) 4
  set mom_sys_cycle_drill_dwell_code 82
  set mom_sys_delay_code(REVOLUTIONS) 4
  set mom_sys_cycle_tap_code 84
  set mom_sys_cutcom_plane_code(XY) 17
  set mom_sys_cycle_bore_code 85
  set mom_sys_cutcom_plane_code(ZX) 18
  set mom_sys_cycle_bore_drag_code 86
  set mom_sys_cutcom_plane_code(YZ) 19
  set mom_sys_cycle_bore_back_code 87
  set mom_sys_cutcom_code(OFF) 40
  set mom_sys_cycle_bore_manual_code 88
  set mom_sys_cycle_bore_dwell_code 89
  set mom_sys_output_code(ABSOLUTE) 90
  set mom_sys_output_code(INCREMENTAL) 91
  set mom_sys_absolute_pos_reset_code 92
  set mom_sys_feed_rate_mode_code(IPM) 94
  set mom_sys_feed_rate_mode_code(IPR) 95
  set mom_sys_spindle_mode_code(SFM) 96

####### KINEMATIC VARIABLE DECLARATIONS ##############
  set mom_kin_y_axis_limit 635
  set mom_kin_4th_axis_min_limit 0
  set mom_kin_output_unit Inch
  set mom_kin_flush_time 2.0
  set mom_kin_min_frn 0.0
  set mom_kin_tool_change_time 12.0
  set mom_kin_max_frn 0.0
  set mom_kin_5th_axis_min_limit 0
  set mom_kin_pivot_guage_offset 0.0
  set mom_kin_5th_axis_ang_offset 0.0
  set mom_kin_4th_axis_plane xy
  set mom_kin_4th_axis_zero 0.0
  set mom_kin_min_dpm 0.0
  set mom_kin_5th_axis_type Head
  set mom_kin_max_dpm 10
  set mom_kin_x_axis_limit 510
  set mom_kin_4th_axis_center_offset(0) 0.0
  set mom_kin_5th_axis_center_offset(0) 0.0
  set mom_kin_5th_axis_max_limit 360
  set mom_kin_4th_axis_address A
  set mom_kin_linearization_flag 1
  set mom_kin_5th_axis_zero 0.0
  set mom_kin_5th_axis_limit_action Warning
  set mom_kin_4th_axis_center_offset(1) 0.0
  set mom_kin_home_y_pos 0.0
  set mom_kin_4th_axis_type Head
  set mom_kin_clamp_time 2.0
  set mom_kin_5th_axis_center_offset(1) 0.0
  set mom_kin_min_fpm 0.0
  set mom_kin_4th_axis_rotation standard
  set mom_kin_4th_axis_limit_action Warning
  set mom_kin_5th_axis_rotation standard
  set mom_kin_max_fpm 1000
  set mom_kin_z_axis_limit 635
  set mom_kin_home_x_pos 0.0
  set mom_kin_machine_type 3_axis_mill
  set mom_kin_4th_axis_min_incr 0.001
  set mom_kin_machine_resolution .00001
  set mom_kin_home_z_pos 0.0
  set mom_kin_4th_axis_max_limit 360
  set mom_kin_min_fpr 0.0
  set mom_kin_5th_axis_address B
  set mom_kin_5th_axis_min_incr 0.001
  set mom_kin_max_traversal_rate 300
  set mom_kin_5th_axis_plane yz
  set mom_kin_4th_axis_center_offset(2) 0.0
  set mom_kin_max_fpr 0.0
  set mom_kin_5th_axis_center_offset(2) 0.0
  set mom_kin_4th_axis_ang_offset 0.0
  set mom_kin_linearization_tol 0.001


############## EVENT HANDLING SECTION ################
#=============================================================
proc CYCLE_set { } {
#=============================================================
     global cycle_name mom_spindle_axis
     if { [info exists mom_spindle_axis ] == 0} {
        set mom_spindle_axis 2
     }
     MOM_force once G_motion X Y Z R
     if { [string first DWELL $cycle_name] != -1 } {
        MOM_force once cycle_dwell }
     if { [string first NODRAG $cycle_name] != -1 } {
       MOM_force once cycle_nodrag }
     if { [string first DEEP $cycle_name]!= -1 } {
       MOM_force once cycle_step }
     if { [string first BREAK_CHIP $cycle_name]  != -1 } {
       MOM_force once cycle_step
     }

}


#=============================================================
proc CIRCLE_set { } {
#=============================================================
     global mom_pos_arc_plane
     MOM_suppress off I J K
     switch $mom_pos_arc_plane {
       XY { MOM_suppress always K }
       YZ { MOM_suppress always I }
       ZX { MOM_suppress always J }
     }
}


#=============================================================
proc COOLANT_set { } {
#=============================================================
     global mom_coolant_status mom_coolant_mode
     if { $mom_coolant_status != "OFF" } \
     {
         set mom_coolant_status ON 
     }
      if { $mom_coolant_status == "ON" } \
      {
          if { $mom_coolant_mode != "" } \
          {
               set mom_coolant_status $mom_coolant_mode 
          }
      }
}


#=============================================================
proc CUTCOM_set { } {
#=============================================================
     global mom_cutcom_status mom_cutcom_mode
     if { $mom_cutcom_status != "OFF" } \
     {
          set mom_cutcom_status ON
     } 
     if { $mom_cutcom_status == "ON" } \
     {
          if { $mom_cutcom_mode != "" } \
          {
              set mom_cutcom_status $mom_cutcom_mode
          }
     }
}


#=============================================================
proc SPINDLE_set { } {
#=============================================================
     global mom_spindle_status mom_spindle_mode
     if { $mom_spindle_status != "OFF" } \
     {
          set mom_spindle_status ON
     }
     if { $mom_spindle_status == "ON" } \
     {
          if { $mom_spindle_mode != "" } \
          {
               set mom_spindle_status $mom_spindle_mode
          }
     }
}


#=============================================================
proc OPSKIP_set { } {
#=============================================================
     global mom_opskip_status mom_sys_opskip_code
     switch $mom_opskip_status \
     {
         ON      { 
                       MOM_set_line_leader always  $mom_sys_opskip_code
                 }
        default  {
                       MOM_set_line_leader off  $mom_sys_opskip_code
                  }
     }
}


#=============================================================
proc RAPID_set { } {
#=============================================================
     global mom_spindle_axis 
     global mom_pos mom_last_z_pos 
     global spindle_first
     if { [info exists mom_spindle_axis] == 0} \
     {
          set mom_spindle_axis 2
     }
     if { $mom_pos($mom_spindle_axis) >  $mom_last_z_pos}\
     {
          set spindle_first TRUE
     } else \
     {
          set spindle_first FALSE
     }
}


#=============================================================
proc SEQNO_set { } {
#=============================================================
     global mom_sequence_mode mom_sequence_number
     global mom_sequence_increment mom_sequence_frequency
     if { [info exists mom_sequence_mode] } \
     {
        switch $mom_sequence_mode \
        {
              OFF  {
                       MOM_set_seq_off
                   }
              ON   {
                       MOM_set_seq_on
                   }
           default {
                       MOM_output_literal "error:  mom_sequence_mode unknown" 
                   }
        }
     } else \
     {
         MOM_reset_sequence $mom_sequence_number \
             $mom_sequence_increment $mom_sequence_frequency
     }
}


#=============================================================
proc MODES_set { } {
#=============================================================
     global mom_output_mode
     switch $mom_output_mode \
     { 
          ABSOLUTE {
                       set isincr OFF
                   }
          default  {
                       set isincr ON
                   }
     }
     MOM_incremental $isincr X Y Z
}


#=============================================================
proc MOM_start_of_program { } {
#=============================================================
     global in_sequence
     global mom_logname
     global mom_date
     set in_sequence  start_of_program
#*** The following procedure  opens the warning and listing files
     OPEN_files
#*** The following procedure  lists the header information in commentary dat
     LIST_FILE_HEADER
     MOM_output_literal "(################### #########################)"
     MOM_output_literal "(# Created By   :  $mom_logname) "
     MOM_output_literal "(# Creation Date:  $mom_date)"
     MOM_output_literal "(################### #########################)"
     MOM_do_template rewind_stop_code
     MOM_do_template output_unit
}


#=============================================================
proc MOM_start_of_path { } {
#=============================================================
     global in_sequence 
     set in_sequence start_of_path
     MOM_do_template coordinate_system
}


#=============================================================
proc MOM_from_move { } {
#=============================================================
     MOM_do_template from
}


#=============================================================
proc MOM_tool_change { } {
#=============================================================
     global in_sequence
     if { $in_sequence  != "none" } {  MOM_do_template return_home }
     if { $in_sequence  != "none" } {  MOM_do_template auto_tool_change }
     if { $in_sequence  == "none" } { MOM_do_template auto_tool_change }
     if { $in_sequence  == "none" } { MOM_do_template auto_tool_change_1 }
}


#=============================================================
proc MOM_spindle_rpm { } {
#=============================================================
     global in_sequence
      SPINDLE_set
     if { $in_sequence  == "none" } { MOM_do_template spindle_rpm }
}


#=============================================================
proc MOM_coolant_start { } {
#=============================================================
}


#=============================================================
proc MOM_initial_move { } {
#=============================================================
     global mom_feed_rate 
     global mom_feed_rate_per_rev
     global mom_kin_max_fpm
     global mom_motion_type 
     global in_sequence 
     set in_sequence none
     MOM_force once G_motion X Y Z
     MOM_do_template initial_move
     if { $mom_feed_rate >=  $mom_kin_max_fpm } \
     {
         MOM_rapid_move
         return
     }
     if { $mom_motion_type ==  "RAPID" } \
     {
         MOM_rapid_move 
     } else \
     {
         MOM_linear_move 
     }
}


#=============================================================
proc MOM_start_move { } {
#=============================================================
}


#=============================================================
proc MOM_approach_move { } {
#=============================================================
}


#=============================================================
proc MOM_engage_move { } {
#=============================================================
}


#=============================================================
proc MOM_retract_motion { } {
#=============================================================
     MOM_do_template tool_len_adj_off
     MOM_do_template coolant_off
     MOM_do_template spindle_off
}


#=============================================================
proc MOM_return_motion { } {
#=============================================================
}


#=============================================================
proc MOM_gohome_motion { } {
#=============================================================
}


#=============================================================
proc MOM_end_of_path { } {
#=============================================================
}


#=============================================================
proc MOM_end_of_program { } {
#=============================================================
     MOM_do_template end_of_program
#**** The following procedure  lists the tool list with time in commentary data
     LIST_FILE_TRAILER
#**** The following procedure  closes the warning and listing files
     CLOSE_files
}


#=============================================================
proc MOM_first_tool { } {
#=============================================================
}


#=============================================================
proc MOM_tool_length_comp { } {
#=============================================================
     MOM_do_template tool_length_adjust
}


#=============================================================
proc MOM_set_mode { } {
#=============================================================
     MOM_do_template set_mode
}


#=============================================================
proc MOM_spindle_off { } {
#=============================================================
     MOM_do_template spindle_off
}


#=============================================================
proc MOM_coolant_on { } {
#=============================================================
     global in_sequence
     COOLANT_set
     if { $in_sequence  != "none" } {  MOM_do_template coolant_on }
}


#=============================================================
proc MOM_coolant_off { } {
#=============================================================
     COOLANT_set
     MOM_do_template coolant_off
}


#=============================================================
proc MOM_feedrates { } {
#=============================================================
}


#=============================================================
proc MOM_cutcom_on { } {
#=============================================================
     global in_sequence
     global mom_cutcom_status
     if { $mom_cutcom_status != "SAME"} \
     {
         global mom_sys_cutcom_code
         MOM_output_literal  $mom_sys_cutcom_code(OFF) 
     }
     CUTCOM_set
     if { $in_sequence  != "none" } {  MOM_do_template cutcom_on }
}


#=============================================================
proc MOM_cutcom_off { } {
#=============================================================
     MOM_do_template cutcom_off
}


#=============================================================
proc MOM_delay { } {
#=============================================================
     MOM_do_template delay
}


#=============================================================
proc MOM_opstop { } {
#=============================================================
     MOM_do_template opstop
}


#=============================================================
proc MOM_opskip_on { } {
#=============================================================
}


#=============================================================
proc MOM_opskip_off { } {
#=============================================================
}


#=============================================================
proc MOM_auxfun { } {
#=============================================================
     MOM_do_template auxfun
}


#=============================================================
proc MOM_prefun { } {
#=============================================================
     MOM_do_template prefun
}


#=============================================================
proc MOM_load_tool { } {
#=============================================================
}


#=============================================================
proc MOM_sequence_number { } {
#=============================================================
     SEQNO_set
     MOM_do_template sequence_number
}


#=============================================================
proc MOM_stop { } {
#=============================================================
     MOM_do_template stop
}


#=============================================================
proc MOM_tool_preselect { } {
#=============================================================
     MOM_do_template tool_preselect
}


#=============================================================
proc MOM_linear_move { } {
#=============================================================
     global mom_feed_rate 
     global mom_feed_rate_per_rev
     global mom_kin_max_fpm
     if { $mom_feed_rate >=  $mom_kin_max_fpm } \
     {
         MOM_rapid_move 
         return
     }
     MOM_do_template linear
}


#=============================================================
proc MOM_circular_move { } {
#=============================================================
    CIRCLE_set
     MOM_do_template circle
}


#=============================================================
proc MOM_rapid_move { } {
#=============================================================
     global spindle_first
     RAPID_set
     if { $spindle_first ==  "TRUE" } \
     {
          MOM_do_template  rapid_traverse
          MOM_do_template  rapid_spindle
     } elseif {  $spindle_first == "FALSE"}\
      {
          MOM_do_template  rapid_traverse
          MOM_do_template  rapid_spindle
     } else \
     { 
          MOM_do_template rapid_traverse
      }
}


#=============================================================
proc MOM_cycle_off { } {
#=============================================================
     MOM_do_template cycle_off
}


#=============================================================
proc MOM_cycle_plane_change { } {
#=============================================================
     MOM_do_template cycle_plane_change
}


#=============================================================
proc MOM_drill { } {
#=============================================================
     global cycle_name
     set cycle_name DRILL
     CYCLE_set
}


#=============================================================
proc  MOM_drill_move { } {
#=============================================================
     MOM_do_template cycle_drill
}


#=============================================================
proc MOM_drill_dwell { } {
#=============================================================
     global cycle_name
     set cycle_name DRILL_DWELL
     CYCLE_set
}


#=============================================================
proc  MOM_drill_dwell_move { } {
#=============================================================
     MOM_do_template cycle_drill_dwell
}


#=============================================================
proc MOM_drill_deep { } {
#=============================================================
     global cycle_name
     set cycle_name DRILL_DEEP
     CYCLE_set
}


#=============================================================
proc  MOM_drill_deep_move { } {
#=============================================================
     MOM_do_template cycle_drill_deep
}


#=============================================================
proc MOM_drill_break_chip { } {
#=============================================================
     global cycle_name
     set cycle_name DRILL_BREAK_CHIP
     CYCLE_set
}


#=============================================================
proc  MOM_drill_break_chip_move { } {
#=============================================================
     MOM_do_template cycle_breakchip
}


#=============================================================
proc MOM_tap { } {
#=============================================================
     global cycle_name
     set cycle_name TAP
     CYCLE_set
}


#=============================================================
proc  MOM_tap_move { } {
#=============================================================
     MOM_do_template cycle_tap
}


#=============================================================
proc MOM_bore { } {
#=============================================================
     global cycle_name
     set cycle_name BORE
     CYCLE_set
}


#=============================================================
proc  MOM_bore_move { } {
#=============================================================
     MOM_do_template cycle_bore
}


#=============================================================
proc MOM_bore_drag { } {
#=============================================================
     global cycle_name
     set cycle_name BORE_DRAG
     CYCLE_set
}


#=============================================================
proc  MOM_bore_drag_move { } {
#=============================================================
     MOM_do_template cycle_bore_drag
}


#=============================================================
proc MOM_bore_no_drag { } {
#=============================================================
     global cycle_name
     set cycle_name BORE_NO_DRAG
     CYCLE_set
}


#=============================================================
proc  MOM_bore_no_drag_move { } {
#=============================================================
     MOM_do_template cycle_bore_no_drag
}


#=============================================================
proc MOM_bore_manual { } {
#=============================================================
     global cycle_name
     set cycle_name BORE_MANUAL
     CYCLE_set
}


#=============================================================
proc  MOM_bore_manual_move { } {
#=============================================================
     MOM_do_template cycle_bore_manual
}


#=============================================================
proc MOM_bore_dwell { } {
#=============================================================
     global cycle_name
     set cycle_name BORE_DWELL
     CYCLE_set
}


#=============================================================
proc  MOM_bore_dwell_move { } {
#=============================================================
     MOM_do_template cycle_bore_dwell
}


#=============================================================
proc MOM_bore_back { } {
#=============================================================
     global cycle_name
     set cycle_name BORE_BACK
     CYCLE_set
}


#=============================================================
proc  MOM_bore_back_move { } {
#=============================================================
     MOM_do_template cycle_bore_back
}


#=============================================================
proc MOM_bore_manual_dwell { } {
#=============================================================
     global cycle_name
     set cycle_name BORE_MANUAL_DWELL
     CYCLE_set
}


#=============================================================
proc  MOM_bore_manual_dwell_move { } {
#=============================================================
     MOM_do_template cycle_bore_m_dwell
}
