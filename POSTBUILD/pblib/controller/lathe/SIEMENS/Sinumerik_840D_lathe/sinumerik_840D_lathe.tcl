########################## TCL Event Handlers ##########################
#
#  sinumerik_840D_lathe.tcl -
#
#  Created by lili  @  25 July 2012 11:00:17 China Standard Time
#  with Post Builder version  8.0.1.
#
########################################################################


  set cam_post_dir [MOM_ask_env_var UGII_CAM_POST_DIR]


  if { ![info exists mom_sys_post_initialized] } {

     if { ![info exists mom_sys_ugpost_base_initialized] } {
        source ${cam_post_dir}ugpost_base.tcl
        set mom_sys_ugpost_base_initialized 1
     }
 
 
     set mom_sys_debug_mode OFF
 
 
     if { ![info exists env(PB_SUPPRESS_UGPOST_DEBUG)] } {
        set env(PB_SUPPRESS_UGPOST_DEBUG) 0
     }
 
     if $env(PB_SUPPRESS_UGPOST_DEBUG) {
        set mom_sys_debug_mode OFF
     }
 
     if { ![string compare $mom_sys_debug_mode "OFF"] } {
 
        proc MOM_before_each_add_var {} {}
        proc MOM_before_each_event {} {}
        proc MOM_end_debug {} {}
 
     } else {
 
        set cam_debug_dir [MOM_ask_env_var UGII_CAM_DEBUG_DIR]
        source ${cam_debug_dir}mom_review.tcl
     }
 
     MOM_set_debug_mode $mom_sys_debug_mode


   ####  Listing File variables 
     set mom_sys_list_output                       "OFF"
     set mom_sys_header_output                     "OFF"
     set mom_sys_list_file_rows                    "40" 
     set mom_sys_list_file_columns                 "30" 
     set mom_sys_warning_output                    "OFF"
     set mom_sys_group_output                      "OFF"
     set mom_sys_list_file_suffix                  "lpt"
     set mom_sys_output_file_suffix                "mpf"
     set mom_sys_commentary_output                 "ON" 
     set mom_sys_commentary_list                   "x z feed speed"
     set mom_sys_pb_link_var_mode                  "OFF"
     set mom_sys_use_default_unit_fragment         "ON" 
     set mom_sys_alt_unit_post_name                "sinumerik_840D_lathe__IN.pui"


   #=============================================================
   proc MOM_before_output { } {
   #=============================================================
   # This command is executed just before every NC block is
   # to be output to a file.
   #
   # - Never overload this command!
   # - Any customization should be done in PB_CMD_before_output!
   #

      if { [llength [info commands PB_CMD_kin_before_output]] &&\
           [llength [info commands PB_CMD_before_output]] } {

         PB_CMD_kin_before_output
      }

   ######### The following procedure invokes the listing file with warnings.

      global mom_sys_list_output
      if { [string match "ON" $mom_sys_list_output] } {
         LIST_FILE
      } else {
         global tape_bytes mom_o_buffer
         if { ![info exists tape_bytes] } {
            set tape_bytes [string length $mom_o_buffer]
         } else {
            incr tape_bytes [string length $mom_o_buffer]
         }
      }
   }


     if { [string match "OFF" [MOM_ask_env_var UGII_CAM_POST_LINK_VAR_MODE]] } {
        set mom_sys_link_var_mode                     "OFF"
     } else {
        set mom_sys_link_var_mode                     "$mom_sys_pb_link_var_mode"
     }


     set mom_sys_control_out                       ";"  
     set mom_sys_control_in                        ""   

     set mom_sys_post_initialized 1
  }


########## SYSTEM VARIABLE DECLARATIONS ##############
  set mom_sys_rapid_code                        "0"  
  set mom_sys_linear_code                       "1"  
  set mom_sys_circle_code(CLW)                  "2"  
  set mom_sys_circle_code(CCLW)                 "3"  
  set mom_sys_lathe_thread_advance_type(1)      "33" 
  set mom_sys_lathe_thread_advance_type(2)      "34" 
  set mom_sys_lathe_thread_advance_type(3)      "35" 
  set mom_sys_delay_code(SECONDS)               "4"  
  set mom_sys_delay_code(REVOLUTIONS)           "4"  
  set mom_sys_cutcom_code(OFF)                  "40" 
  set mom_sys_cutcom_code(LEFT)                 "41" 
  set mom_sys_cutcom_code(RIGHT)                "42" 
  set mom_sys_unit_code(IN)                     "700"
  set mom_sys_unit_code(MM)                     "710"
  set mom_sys_output_code(ABSOLUTE)             "90" 
  set mom_sys_output_code(INCREMENTAL)          "91" 
  set mom_sys_feed_rate_mode_code(IPM)          "94" 
  set mom_sys_feed_rate_mode_code(IPR)          "95" 
  set mom_sys_feed_rate_mode_code(FRN)          "93" 
  set mom_sys_spindle_mode_code(SFM)            "96" 
  set mom_sys_spindle_mode_code(RPM)            "97" 
  set mom_sys_feed_rate_mode_code(MMPM)         "94" 
  set mom_sys_feed_rate_mode_code(MMPR)         "95" 
  set mom_sys_program_stop_code                 "0"  
  set mom_sys_optional_stop_code                "1"  
  set mom_sys_end_of_program_code               "2"  
  set mom_sys_spindle_direction_code(CLW)       "3"  
  set mom_sys_spindle_direction_code(CCLW)      "4"  
  set mom_sys_spindle_direction_code(OFF)       "5"  
  set mom_sys_tool_change_code                  "6"  
  set mom_sys_coolant_code(MIST)                "7"  
  set mom_sys_coolant_code(ON)                  "8"  
  set mom_sys_coolant_code(FLOOD)               "8"  
  set mom_sys_coolant_code(OFF)                 "9"  
  set mom_sys_head_code(INDEPENDENT)            "21" 
  set mom_sys_head_code(DEPENDENT)              "22" 
  set mom_sys_rewind_code                       "30" 
  set mom_sys_sim_cycle_drill                   "0"  
  set mom_sys_sim_cycle_drill_dwell             "0"  
  set mom_sys_sim_cycle_drill_deep              "0"  
  set mom_sys_sim_cycle_drill_break_chip        "0"  
  set mom_sys_sim_cycle_tap                     "0"  
  set mom_sys_sim_cycle_bore                    "0"  
  set mom_sys_cir_vector                        "Vector - Arc Start to Center"
  set mom_sys_spindle_max_rpm_code              "92" 
  set mom_sys_spindle_cancel_sfm_code           "93" 
  set mom_sys_spindle_ranges                    "0"  
  set mom_sys_delay_output_mode                 "SECONDS"
  set mom_sys_rewind_stop_code                  "\#" 
  set mom_sys_home_pos(0)                       "0"  
  set mom_sys_home_pos(1)                       "0"  
  set mom_sys_home_pos(2)                       "0"  
  set mom_sys_zero                              "0"  
  set mom_sys_opskip_block_leader               "/"  
  set mom_sys_seqnum_start                      "10" 
  set mom_sys_seqnum_incr                       "10" 
  set mom_sys_seqnum_freq                       "1"  
  set mom_sys_seqnum_max                        "99999999"
  set mom_sys_lathe_x_double                    "2"  
  set mom_sys_lathe_i_double                    "1"  
  set mom_sys_lathe_x_factor                    "1"  
  set mom_sys_lathe_z_factor                    "1"  
  set mom_sys_lathe_i_factor                    "1"  
  set mom_sys_lathe_k_factor                    "1"  
  set mom_sys_leader(N)                         "N"  
  set mom_sys_leader(X)                         "X"  
  set mom_sys_leader(Y)                         "Y"  
  set mom_sys_leader(Z)                         "Z"  
  set mom_sys_turret_index(INDEPENDENT)         "1"  
  set mom_sys_turret_index(DEPENDENT)           "2"  
  set mom_sys_delay_param(SECONDS,format)       "Dwell_SECONDS"
  set mom_sys_delay_param(REVOLUTIONS,format)   "Dwell_REVOLUTIONS"
  set mom_sys_contour_feed_mode(LINEAR)         "MMPM"
  set mom_sys_rapid_feed_mode(LINEAR)           "MMPM"
  set mom_sys_cycle_feed_mode                   "MMPM"
  set mom_sys_feed_param(IPM,format)            "Feed_IPM"
  set mom_sys_feed_param(IPR,format)            "Feed_IPR"
  set mom_sys_feed_param(FRN,format)            "Feed_INV"
  set mom_sys_vnc_rapid_dogleg                  "1"  
  set mom_sys_prev_mach_head                    ""   
  set mom_sys_curr_mach_head                    ""   
  set mom_sys_feed_param(MMPM,format)           "Feed_MMPM"
  set mom_sys_feed_param(MMPR,format)           "Feed_MMPR"
  set mom_sys_output_cycle95                    "1"  
  set mom_sys_linearization_method              "angle"
  set mom_sys_post_description                  "This is a 2-Axis Horizontal Lathe Machine."
  set mom_sys_ugpadvkins_used                   "0"
  set mom_sys_post_builder_version              "8.0.1"

####### KINEMATIC VARIABLE DECLARATIONS ##############
  set mom_kin_4th_axis_center_offset(0)         "0.0"
  set mom_kin_4th_axis_center_offset(1)         "0.0"
  set mom_kin_4th_axis_center_offset(2)         "0.0"
  set mom_kin_4th_axis_max_limit                "0.0"
  set mom_kin_4th_axis_min_incr                 "0.0"
  set mom_kin_4th_axis_min_limit                "0.0"
  set mom_kin_4th_axis_point(0)                 "0.0"
  set mom_kin_4th_axis_point(1)                 "0.0"
  set mom_kin_4th_axis_point(2)                 "0.0"
  set mom_kin_4th_axis_zero                     "0.0"
  set mom_kin_5th_axis_center_offset(0)         "0.0"
  set mom_kin_5th_axis_center_offset(1)         "0.0"
  set mom_kin_5th_axis_center_offset(2)         "0.0"
  set mom_kin_5th_axis_max_limit                "0.0"
  set mom_kin_5th_axis_min_incr                 "0.0"
  set mom_kin_5th_axis_min_limit                "0.0"
  set mom_kin_5th_axis_point(0)                 "0.0"
  set mom_kin_5th_axis_point(1)                 "0.0"
  set mom_kin_5th_axis_point(2)                 "0.0"
  set mom_kin_5th_axis_zero                     "0.0"
  set mom_kin_arc_output_mode                   "FULL_CIRCLE"
  set mom_kin_arc_valid_plane                   "XY" 
  set mom_kin_clamp_time                        "2.0"
  set mom_kin_dependent_head                    "NONE"
  set mom_kin_flush_time                        "2.0"
  set mom_kin_ind_to_dependent_head_x           "0"  
  set mom_kin_ind_to_dependent_head_z           "0"  
  set mom_kin_independent_head                  "NONE"
  set mom_kin_linearization_flag                "1"  
  set mom_kin_linearization_tol                 "0.001"
  set mom_kin_machine_resolution                ".001"
  set mom_kin_machine_type                      "lathe"
  set mom_kin_machine_zero_offset(0)            "0.0"
  set mom_kin_machine_zero_offset(1)            "0.0"
  set mom_kin_machine_zero_offset(2)            "0.0"
  set mom_kin_max_arc_radius                    "99999.999"
  set mom_kin_max_dpm                           "0.0"
  set mom_kin_max_fpm                           "10000"
  set mom_kin_max_fpr                           "1000"
  set mom_kin_max_frn                           "99999.999"
  set mom_kin_min_arc_length                    "0.20"
  set mom_kin_min_arc_radius                    "0.001"
  set mom_kin_min_dpm                           "0.0"
  set mom_kin_min_fpm                           "1.0"
  set mom_kin_min_fpr                           "0.001"
  set mom_kin_min_frn                           "0.001"
  set mom_kin_output_unit                       "MM" 
  set mom_kin_pivot_gauge_offset                "0.0"
  set mom_kin_post_data_unit                    "MM" 
  set mom_kin_rapid_feed_rate                   "15000"
  set mom_kin_tool_change_time                  "30" 
  set mom_kin_x_axis_limit                      "1000"
  set mom_kin_y_axis_limit                      "1000"
  set mom_kin_z_axis_limit                      "1000"




if [llength [info commands MOM_SYS_do_template] ] {
   if [llength [info commands MOM_do_template] ] {
      rename MOM_do_template ""
   }
   rename MOM_SYS_do_template MOM_do_template
}




if { [llength [info commands MOM_do_template]] == 0 } {
   proc MOM_do_template { args } {}
}


if { ![info exists mom_sys_lathe_x_double] } { set mom_sys_lathe_x_double 1 }
if { ![info exists mom_sys_lathe_y_double] } { set mom_sys_lathe_y_double 1 }
if { ![info exists mom_sys_lathe_i_double] } { set mom_sys_lathe_i_double 1 }
if { ![info exists mom_sys_lathe_j_double] } { set mom_sys_lathe_j_double 1 }
if { ![info exists mom_sys_lathe_x_factor] } { set mom_sys_lathe_x_factor 1 }
if { ![info exists mom_sys_lathe_y_factor] } { set mom_sys_lathe_y_factor 1 }
if { ![info exists mom_sys_lathe_z_factor] } { set mom_sys_lathe_z_factor 1 }
if { ![info exists mom_sys_lathe_i_factor] } { set mom_sys_lathe_i_factor 1 }
if { ![info exists mom_sys_lathe_j_factor] } { set mom_sys_lathe_j_factor 1 }
if { ![info exists mom_sys_lathe_k_factor] } { set mom_sys_lathe_k_factor 1 }


if { $mom_sys_lathe_x_double != 1 || \
     $mom_sys_lathe_y_double != 1 || \
     $mom_sys_lathe_i_double != 1 || \
     $mom_sys_lathe_j_double != 1 || \
     $mom_sys_lathe_x_factor != 1 || \
     $mom_sys_lathe_y_factor != 1 || \
     $mom_sys_lathe_z_factor != 1 || \
     $mom_sys_lathe_i_factor != 1 || \
     $mom_sys_lathe_j_factor != 1 || \
     $mom_sys_lathe_k_factor != 1 } {

   rename MOM_do_template MOM_SYS_do_template

   #====================================
   proc MOM_do_template { block args } {
   #====================================
     global mom_sys_lathe_x_double
     global mom_sys_lathe_y_double
     global mom_sys_lathe_i_double
     global mom_sys_lathe_j_double
     global mom_sys_lathe_x_factor
     global mom_sys_lathe_y_factor
     global mom_sys_lathe_z_factor
     global mom_sys_lathe_i_factor
     global mom_sys_lathe_j_factor
     global mom_sys_lathe_k_factor

     global mom_prev_pos mom_pos mom_pos_arc_center mom_ref_pos_arc_center mom_from_pos mom_from_ref_pos
     global mom_ref_pos mom_prev_ref_pos mom_gohome_pos mom_gohome_ref_pos
     global mom_cycle_rapid_to_pos mom_cycle_feed_to_pos mom_cycle_retract_to_pos
     global mom_cycle_clearance_to_pos
     global mom_cycle_feed_to mom_cycle_rapid_to
     global mom_tool_x_offset mom_tool_y_offset mom_tool_z_offset

     global mom_lathe_thread_lead_i mom_lathe_thread_lead_k


     #-----------------------------------
     # Lists of variables to be modified
     #-----------------------------------
      set var_list_1 { mom_pos(\$i) \
                       mom_ref_pos(\$i) \
                       mom_prev_ref_pos(\$i) \
                       mom_from_pos(\$i) \
                       mom_from_ref_pos(\$i) \
                       mom_gohome_pos(\$i) \
                       mom_gohome_ref_pos(\$i) \
                       mom_cycle_rapid_to_pos(\$i) \
                       mom_cycle_feed_to_pos(\$i) \
                       mom_cycle_retract_to_pos(\$i) \
                       mom_cycle_clearance_to_pos(\$i) }

      set var_list_2 { mom_prev_pos(\$i) \
                       mom_pos_arc_center(\$i) \
                       mom_ref_pos_arc_center(\$i) }

      set var_list_3 { mom_cycle_feed_to \
                       mom_cycle_rapid_to \
                       mom_lathe_thread_lead_i \
                       mom_lathe_thread_lead_k }


     # Retain current values
      set var_list [concat $var_list_1 $var_list_2]

      foreach var $var_list {
         for { set i 0 } { $i < 3 } { incr i } {
            if [eval info exists [set var]] {
               set val [eval format $[set var]]
               eval set __[set var] $val
            }
         }
      }

      foreach var $var_list_3 {
         if [eval info exists [set var]] {
             set val [eval format $[set var]]
             eval set __[set var] $val
         }
      }

     # Adjust X, Y & Z values
      set _factor(0) [expr $mom_sys_lathe_x_double * $mom_sys_lathe_x_factor]
      set _factor(1) [expr $mom_sys_lathe_y_double * $mom_sys_lathe_y_factor]
      set _factor(2) $mom_sys_lathe_z_factor

      foreach var $var_list_1 {
         for { set i 0 } { $i < 3 } { incr i } {
            if [expr $_factor($i) != 1] {
               if [eval info exists [set var]] {
                  set val [eval format $[set var]]
                  eval set [set var] [expr $val * $_factor($i)]
               }
            }
         }
      }

     # Adjust I, J & K
      set _factor(0) [expr $mom_sys_lathe_i_factor * $mom_sys_lathe_i_double]
      set _factor(1) [expr $mom_sys_lathe_j_factor * $mom_sys_lathe_j_double]
      set _factor(2)       $mom_sys_lathe_k_factor

      foreach var $var_list_2 {
         for { set i 0 } { $i < 3 } { incr i } {
            if [expr $_factor($i) != 1] {
               if [eval info exists [set var]] {
                  set val [eval format $[set var]]
                  eval set [set var] [expr $val * $_factor($i)]
               }
            }
         }
      }

     # Adjust Cycle's & threading registers
      foreach var $var_list_3 {
         if [eval info exists [set var]] {

            set val [eval format $[set var]]

            switch "$var" {
               "mom_cycle_feed_to"  -
               "mom_cycle_rapid_to" {
                  eval set [set var] [expr $val * $mom_sys_lathe_z_factor]
               }
               "mom_lathe_thread_lead_i" {
                  eval set [set var] [expr $val * $mom_sys_lathe_i_factor * $mom_sys_lathe_i_double]
               }
               "mom_lathe_thread_lead_k" {
                  eval set [set var] [expr $val * $mom_sys_lathe_k_factor]
               }
            }
         }
      }


     # Neutralize all factors to avoid double multiplication in the legacy posts.
      set _lathe_x_double $mom_sys_lathe_x_double
      set _lathe_y_double $mom_sys_lathe_y_double
      set _lathe_i_double $mom_sys_lathe_i_double
      set _lathe_j_double $mom_sys_lathe_j_double
      set _lathe_x_factor $mom_sys_lathe_x_factor
      set _lathe_y_factor $mom_sys_lathe_y_factor
      set _lathe_z_factor $mom_sys_lathe_z_factor
      set _lathe_i_factor $mom_sys_lathe_i_factor
      set _lathe_j_factor $mom_sys_lathe_j_factor
      set _lathe_k_factor $mom_sys_lathe_k_factor

      set mom_sys_lathe_x_double 1
      set mom_sys_lathe_y_double 1
      set mom_sys_lathe_i_double 1
      set mom_sys_lathe_j_double 1
      set mom_sys_lathe_x_factor 1
      set mom_sys_lathe_y_factor 1
      set mom_sys_lathe_z_factor 1
      set mom_sys_lathe_i_factor 1
      set mom_sys_lathe_j_factor 1
      set mom_sys_lathe_k_factor 1


     #-----------------------
     # Output block template
     #-----------------------
      set block_buffer [MOM_SYS_do_template $block $args]


     # Restore values
      foreach var $var_list {
         for { set i 0 } { $i < 3 } { incr i } {
            if [eval info exists [set var]] {
               set v __[set var]
               set val [eval format $$v]
               eval set [set var] $val
            }
         }
      }
      foreach var $var_list_3 {
         if [eval info exists [set var]] {
            set v __[set var]
            set val [eval format $$v]
            eval set [set var] $val
         }
      }

     # Restore factors
      set mom_sys_lathe_x_double $_lathe_x_double
      set mom_sys_lathe_y_double $_lathe_y_double
      set mom_sys_lathe_i_double $_lathe_i_double
      set mom_sys_lathe_j_double $_lathe_j_double
      set mom_sys_lathe_x_factor $_lathe_x_factor
      set mom_sys_lathe_y_factor $_lathe_y_factor
      set mom_sys_lathe_z_factor $_lathe_z_factor
      set mom_sys_lathe_i_factor $_lathe_i_factor
      set mom_sys_lathe_j_factor $_lathe_j_factor
      set mom_sys_lathe_k_factor $_lathe_k_factor

   return $block_buffer
   }
}







#=============================================================
proc MOM_start_of_program { } {
#=============================================================
  global mom_logname mom_date is_from
  global mom_coolant_status mom_cutcom_status
  global mom_clamp_status mom_cycle_status
  global mom_spindle_status mom_cutcom_plane pb_start_of_program_flag
  global mom_cutcom_adjust_register mom_tool_adjust_register
  global mom_tool_length_adjust_register mom_length_comp_register
  global mom_flush_register mom_wire_cutcom_adjust_register
  global mom_wire_cutcom_status

    set pb_start_of_program_flag 0
    set mom_coolant_status UNDEFINED
    set mom_cutcom_status  UNDEFINED
    set mom_clamp_status   UNDEFINED
    set mom_cycle_status   UNDEFINED
    set mom_spindle_status UNDEFINED
    set mom_cutcom_plane   UNDEFINED
    set mom_wire_cutcom_status  UNDEFINED

    catch {unset mom_cutcom_adjust_register}
    catch {unset mom_tool_adjust_register}
    catch {unset mom_tool_length_adjust_register}
    catch {unset mom_length_comp_register}
    catch {unset mom_flush_register}
    catch {unset mom_wire_cutcom_adjust_register}

    set is_from ""

    catch { OPEN_files } ; #open warning and listing files
    LIST_FILE_HEADER ; #list header in commentary listing



  global mom_sys_post_initialized
  if { $mom_sys_post_initialized > 1 } { return }


   # Load parameters for alternate output units
    PB_load_alternate_unit_settings
    rename PB_load_alternate_unit_settings ""


#************
uplevel #0 {


#=============================================================
proc MOM_sync { } {
#=============================================================
  if [llength [info commands PB_CMD_kin_handle_sync_event] ] {
    PB_CMD_kin_handle_sync_event
  }
}


#=============================================================
proc MOM_set_csys { } {
#=============================================================
  if [llength [info commands PB_CMD_kin_set_csys] ] {
    PB_CMD_kin_set_csys
  }
}


#=============================================================
proc MOM_msys { } {
#=============================================================
}


#=============================================================
proc MOM_end_of_program { } {
#=============================================================
   MOM_do_template end_of_program
   PB_CMD_output_cycle95_contour_file
   MOM_set_seq_off

#**** The following procedure lists the tool list with time in commentary data
   LIST_FILE_TRAILER

#**** The following procedure closes the warning and listing files
   CLOSE_files

   if [llength [info commands PB_CMD_kin_end_of_program] ] {
      PB_CMD_kin_end_of_program
   }
}


  incr mom_sys_post_initialized


} ;# uplevel
#***********


}


#=============================================================
proc PB_TURRET_HEAD_SET { } {
#=============================================================
  global mom_kin_independent_head mom_tool_head
  global turret_current

   set turret_current INDEPENDENT
   set ind_head NONE
   set dep_head NONE

   if { [string compare $mom_tool_head $mom_kin_independent_head] } {
      set turret_current DEPENDENT
   }

   if { [string compare $mom_tool_head "$ind_head"] && \
        [string compare $mom_tool_head "$dep_head"] } {
      CATCH_WARNING "mom_tool_head = $mom_tool_head IS INVALID, USING NONE"
   }
}


#=============================================================
proc PB_LATHE_THREAD_SET { } {
#=============================================================
  global mom_lathe_thread_type mom_lathe_thread_advance_type
  global mom_lathe_thread_lead_i mom_lathe_thread_lead_k
  global mom_motion_distance
  global mom_lathe_thread_increment mom_lathe_thread_value
  global thread_type thread_increment feed_rate_mode

    switch $mom_lathe_thread_advance_type {
      1 { set thread_type CONSTANT ; MOM_suppress once E }
      2 { set thread_type INCREASING ; MOM_force once E }
      default { set thread_type DECREASING ; MOM_force once E }
    }

    if { ![string compare $thread_type "INCREASING"] || ![string compare $thread_type "DECREASING"] } {
      if { $mom_lathe_thread_type != 1 } {
        set LENGTH $mom_motion_distance
        set LEAD $mom_lathe_thread_value
        set INCR $mom_lathe_thread_increment
        set E [expr abs(pow(($LEAD + ($INCR * $LENGTH)) , 2) - pow($LEAD , 2)) / 2 * $LENGTH]
        set thread_increment $E
      }
    }

    if { $mom_lathe_thread_lead_i == 0 } {
      MOM_suppress once I ; MOM_force once K
    } elseif { $mom_lathe_thread_lead_k == 0 } {
      MOM_suppress once K ; MOM_force once I
    } else {
      MOM_force once I ; MOM_force once K
    }
}


#=============================================================
proc PB_DELAY_TIME_SET { } {
#=============================================================
  global mom_sys_delay_param mom_delay_value
  global mom_delay_revs mom_delay_mode delay_time

  # Post Builder provided format for the current mode:
   if { [info exists mom_sys_delay_param(${mom_delay_mode},format)] != 0 } {
      MOM_set_address_format dwell $mom_sys_delay_param(${mom_delay_mode},format)
   }

   switch $mom_delay_mode {
      SECONDS { set delay_time $mom_delay_value }
      default { set delay_time $mom_delay_revs  }
   }
}


#=============================================================
proc MOM_before_motion { } {
#=============================================================
  global mom_motion_event mom_motion_type

   FEEDRATE_SET


   switch $mom_motion_type {
      ENGAGE   {PB_engage_move}
      APPROACH {PB_approach_move}
      FIRSTCUT {PB_first_cut}
      RETRACT  {PB_retract_move}
      RETURN   {PB_return_move}
   }

   if { [llength [info commands PB_CMD_kin_before_motion] ] } { PB_CMD_kin_before_motion }
   if { [llength [info commands PB_CMD_before_motion] ] }     { PB_CMD_before_motion }
}


#=============================================================
proc MOM_start_of_group { } {
#=============================================================
  global mom_sys_group_output mom_group_name group_level ptp_file_name
  global mom_sequence_number mom_sequence_increment mom_sequence_frequency
  global mom_sys_ptp_output pb_start_of_program_flag

   if { ![hiset group_level] } {
      set group_level 0
      return
   }

   if { [hiset mom_sys_group_output] } {
      if { ![string compare $mom_sys_group_output "OFF"] } {
         set group_level 0
         return
      }
   }

   if { [hiset group_level] } {
      incr group_level
   } else {
      set group_level 1
   }

   if { $group_level > 1 } {
      return
   }

   SEQNO_RESET ; #<4133654>
   MOM_reset_sequence $mom_sequence_number $mom_sequence_increment $mom_sequence_frequency

   if { [info exists ptp_file_name] } {
      MOM_close_output_file $ptp_file_name
      MOM_start_of_program
      if { ![string compare $mom_sys_ptp_output "ON"] } {
         MOM_open_output_file $ptp_file_name
      }
   } else {
      MOM_start_of_program
   }

   PB_start_of_program
   set pb_start_of_program_flag 1
}


#=============================================================
proc MOM_machine_mode { } {
#=============================================================
  global pb_start_of_program_flag
  global mom_operation_name mom_sys_change_mach_operation_name

   set mom_sys_change_mach_operation_name $mom_operation_name

   if { $pb_start_of_program_flag == 0 } {
      PB_start_of_program
      set pb_start_of_program_flag 1
   }

  # For simple mill-turn
   if { [llength [info commands PB_machine_mode] ] } {
      if { [catch {PB_machine_mode} res] } {
         CATCH_WARNING "$res"
      }
   }
}


#=============================================================
proc PB_FORCE { option args } {
#=============================================================
   set adds [join $args]
   if { [info exists option] && [llength $adds] } {
      lappend cmd MOM_force
      lappend cmd $option
      lappend cmd [join $adds]
      eval [join $cmd]
   }
}


#=============================================================
proc PB_SET_RAPID_MOD { mod_list blk_list ADDR NEW_MOD_LIST } {
#=============================================================
  upvar $ADDR addr
  upvar $NEW_MOD_LIST new_mod_list
  global mom_cycle_spindle_axis traverse_axis1 traverse_axis2


   set new_mod_list [list]

   foreach mod $mod_list {
      switch $mod {
         "rapid1" {
            set elem $addr($traverse_axis1)
            if { [lsearch $blk_list $elem] >= 0 } {
               lappend new_mod_list $elem
            }
         }
         "rapid2" {
            set elem $addr($traverse_axis2)
            if { [lsearch $blk_list $elem] >= 0 } {
               lappend new_mod_list $elem
            }
         }
         "rapid3" {
            set elem $addr($mom_cycle_spindle_axis)
            if { [lsearch $blk_list $elem] >= 0 } {
               lappend new_mod_list $elem
            }
         }
         default {
            set elem $mod
            if { [lsearch $blk_list $elem] >= 0 } {
               lappend new_mod_list $elem
            }
         }
      }
   }
}


########################
# Redefine FEEDRATE_SET
########################
if { [llength [info commands ugpost_FEEDRATE_SET] ] } {
   rename ugpost_FEEDRATE_SET ""
}

if { [llength [info commands FEEDRATE_SET] ] } {
   rename FEEDRATE_SET ugpost_FEEDRATE_SET
} else {
   proc ugpost_FEEDRATE_SET {} {}
}


#=============================================================
proc FEEDRATE_SET { } {
#=============================================================
   if { [llength [info commands PB_CMD_kin_feedrate_set] ] } {
      PB_CMD_kin_feedrate_set
   } else {
      ugpost_FEEDRATE_SET
   }
}


############## EVENT HANDLING SECTION ################


#=============================================================
proc MOM_auxfun { } {
#=============================================================
   MOM_do_template auxfun
}


#=============================================================
proc MOM_bore { } {
#=============================================================
  global cycle_name
  global cycle_init_flag

   set cycle_init_flag TRUE
   set cycle_name BORE
   CYCLE_SET
}


#=============================================================
proc MOM_bore_move { } {
#=============================================================
   global cycle_init_flag


   global mom_sys_abort_next_event
   if { [info exists mom_sys_abort_next_event] } {
      if { [llength [info commands PB_CMD_kin_abort_event]] } {
         PB_CMD_kin_abort_event
      }
   }


   if { ![string compare $cycle_init_flag "TRUE"] } {
      PB_CMD_init_cycle_parameters
      MOM_do_template cycle_parameters_1
      if { [PB_CMD__check_block_cycle_powerline] } {
         PB_call_macro CYCLE85_Bore_Dwell MCALL
      }
      if { [PB_CMD__check_block_cycle_solutionline] } {
         PB_call_macro CYCLE85_Bore_sl MCALL
      }
   }

   if { [llength [info commands PB_CMD_config_cycle_start]] } {
      PB_CMD_config_cycle_start
   }
   MOM_do_template cycle_parameters
   set cycle_init_flag FALSE
}


#=============================================================
proc MOM_circular_move { } {
#=============================================================

   global mom_sys_abort_next_event
   if { [info exists mom_sys_abort_next_event] } {
      if { [llength [info commands PB_CMD_kin_abort_event]] } {
         PB_CMD_kin_abort_event
      }
   }


   if { [PB_CMD__check_block_skip_for_cycle95] } {
      MOM_do_template circular_move
   }
   if { [PB_CMD__check_block_circular_for_cycle95] } {
      MOM_do_template circular_move_cycle95
   }
}


#=============================================================
proc MOM_contour_end { } {
#=============================================================
   PB_CMD_contour_end
}


#=============================================================
proc MOM_contour_start { } {
#=============================================================
   PB_CMD_contour_start
}


#=============================================================
proc MOM_coolant_off { } {
#=============================================================
   COOLANT_SET
   MOM_do_template coolant_off
}


#=============================================================
proc MOM_coolant_on { } {
#=============================================================
   COOLANT_SET
   MOM_do_template coolant_on
}


#=============================================================
proc MOM_cutcom_off { } {
#=============================================================
   CUTCOM_SET
   MOM_do_template cutcom_off
}


#=============================================================
proc MOM_cutcom_on { } {
#=============================================================
   CUTCOM_SET

   global mom_cutcom_adjust_register
   set cutcom_register_min 1
   set cutcom_register_max 99
   if { [info exists mom_cutcom_adjust_register] } {
      if { $mom_cutcom_adjust_register < $cutcom_register_min ||\
           $mom_cutcom_adjust_register > $cutcom_register_max } {
         CATCH_WARNING "CUTCOM register $mom_cutcom_adjust_register must be within the range between 1 and 99"
      }
   }
   MOM_do_template cutcom_on
}


#=============================================================
proc MOM_cycle_off { } {
#=============================================================
   PB_CMD_output_MCALL
   PB_CMD_output_thread_cycle
   PB_CMD_cancel_cycle
}


#=============================================================
proc MOM_cycle_plane_change { } {
#=============================================================
  global cycle_init_flag
  global mom_cycle_tool_axis_change
  global mom_cycle_clearance_plane_change

   set cycle_init_flag TRUE
}


#=============================================================
proc MOM_delay { } {
#=============================================================
   PB_DELAY_TIME_SET
   if { [PB_CMD__check_block_delay_seconds] } {
      MOM_do_template delay
   }
   if { [PB_CMD__check_block_delay_revolutions] } {
      MOM_do_template delay_1
   }
}


#=============================================================
proc MOM_drill { } {
#=============================================================
  global cycle_name
  global cycle_init_flag

   set cycle_init_flag TRUE
   set cycle_name DRILL
   CYCLE_SET
}


#=============================================================
proc MOM_drill_move { } {
#=============================================================
   global cycle_init_flag


   global mom_sys_abort_next_event
   if { [info exists mom_sys_abort_next_event] } {
      if { [llength [info commands PB_CMD_kin_abort_event]] } {
         PB_CMD_kin_abort_event
      }
   }


   if { ![string compare $cycle_init_flag "TRUE"] } {
      PB_CMD_init_cycle_parameters
      MOM_do_template cycle_parameters_1
      if { [PB_CMD__check_block_cycle_powerline] } {
         PB_call_macro CYCLE81 MCALL
      }
      if { [PB_CMD__check_block_cycle_solutionline] } {
         PB_call_macro CYCLE81_sl MCALL
      }
   }

   if { [llength [info commands PB_CMD_config_cycle_start]] } {
      PB_CMD_config_cycle_start
   }
   MOM_do_template cycle_parameters
   set cycle_init_flag FALSE
}


#=============================================================
proc MOM_drill_break_chip { } {
#=============================================================
  global cycle_name
  global cycle_init_flag

   set cycle_init_flag TRUE
   set cycle_name DRILL_BREAK_CHIP
   CYCLE_SET
}


#=============================================================
proc MOM_drill_break_chip_move { } {
#=============================================================
   global cycle_init_flag


   global mom_sys_abort_next_event
   if { [info exists mom_sys_abort_next_event] } {
      if { [llength [info commands PB_CMD_kin_abort_event]] } {
         PB_CMD_kin_abort_event
      }
   }


   if { ![string compare $cycle_init_flag "TRUE"] } {
      PB_CMD_init_cycle_parameters
      MOM_do_template cycle_parameters_1
      if { [PB_CMD__check_block_cycle_powerline] } {
         PB_call_macro CYCLE83_Break_Chip MCALL
      }
      if { [PB_CMD__check_block_cycle_solutionline] } {
         PB_call_macro CYCLE83_Break_Chip_sl MCALL
      }
   }

   if { [llength [info commands PB_CMD_config_cycle_start]] } {
      PB_CMD_config_cycle_start
   }
   MOM_do_template cycle_parameters
   set cycle_init_flag FALSE
}


#=============================================================
proc MOM_drill_deep { } {
#=============================================================
  global cycle_name
  global cycle_init_flag

   set cycle_init_flag TRUE
   set cycle_name DRILL_DEEP
   CYCLE_SET
}


#=============================================================
proc MOM_drill_deep_move { } {
#=============================================================
   global cycle_init_flag


   global mom_sys_abort_next_event
   if { [info exists mom_sys_abort_next_event] } {
      if { [llength [info commands PB_CMD_kin_abort_event]] } {
         PB_CMD_kin_abort_event
      }
   }


   if { ![string compare $cycle_init_flag "TRUE"] } {
      PB_CMD_init_cycle_parameters
      MOM_do_template cycle_parameters_1
      if { [PB_CMD__check_block_cycle_powerline] } {
         PB_call_macro CYCLE83_Deep MCALL
      }
      if { [PB_CMD__check_block_cycle_solutionline] } {
         PB_call_macro CYCLE83_Deep_sl MCALL
      }
   }

   if { [llength [info commands PB_CMD_config_cycle_start]] } {
      PB_CMD_config_cycle_start
   }
   MOM_do_template cycle_parameters
   set cycle_init_flag FALSE
}


#=============================================================
proc MOM_drill_dwell { } {
#=============================================================
  global cycle_name
  global cycle_init_flag

   set cycle_init_flag TRUE
   set cycle_name DRILL_DWELL
   CYCLE_SET
}


#=============================================================
proc MOM_drill_dwell_move { } {
#=============================================================
   global cycle_init_flag


   global mom_sys_abort_next_event
   if { [info exists mom_sys_abort_next_event] } {
      if { [llength [info commands PB_CMD_kin_abort_event]] } {
         PB_CMD_kin_abort_event
      }
   }


   if { ![string compare $cycle_init_flag "TRUE"] } {
      PB_CMD_init_cycle_parameters
      MOM_do_template cycle_parameters_1
      PB_CMD_compute_rapid_to_for_csink
      if { [PB_CMD__check_block_cycle_powerline] } {
         PB_call_macro CYCLE82 MCALL
      }
      if { [PB_CMD__check_block_cycle_solutionline] } {
         PB_call_macro CYCLE82_sl MCALL
      }
   }

   if { [llength [info commands PB_CMD_config_cycle_start]] } {
      PB_CMD_config_cycle_start
   }
   MOM_do_template cycle_parameters
   set cycle_init_flag FALSE
}


#=============================================================
proc MOM_end_of_path { } {
#=============================================================
  global mom_sys_add_cutting_time mom_sys_add_non_cutting_time
  global mom_cutting_time mom_machine_time

  # Accumulated time should be in minutes.
   set mom_cutting_time [expr $mom_cutting_time + $mom_sys_add_cutting_time]
   set mom_machine_time [expr $mom_machine_time + $mom_sys_add_cutting_time + $mom_sys_add_non_cutting_time]
   MOM_reload_variable mom_cutting_time
   MOM_reload_variable mom_machine_time

   if [llength [info commands PB_CMD_kin_end_of_path] ] {
      PB_CMD_kin_end_of_path
   }

   PB_CMD_end_of_path
   global mom_sys_in_operation
   set mom_sys_in_operation 0
}


#=============================================================
proc MOM_end_of_subop_path { } {
#=============================================================
}


#=============================================================
proc MOM_first_move { } {
#=============================================================
  global mom_feed_rate mom_feed_rate_per_rev mom_motion_type
  global mom_kin_max_fpm mom_motion_event
   COOLANT_SET ; CUTCOM_SET ; SPINDLE_SET ; RAPID_SET
   if { [PB_CMD__check_block_spindle_max_rpm] } {
      MOM_do_template spindle_max_rpm
   }
   if { [PB_CMD__check_block_spindle_rpm] } {
      MOM_force Once G_feed S M_spindle
      MOM_do_template spindle_rpm
   }
   if { [PB_CMD__check_block_spindle_css] } {
      MOM_force Once G_spin S M_spindle
      MOM_do_template spindle_css
   }
   catch {MOM_$mom_motion_event}
}


#=============================================================
proc MOM_first_tool { } {
#=============================================================
  global mom_tool_change_type mom_manual_tool_change
  global mom_sys_first_tool_handled

  # First tool only gets handled once
   if { [info exists mom_sys_first_tool_handled] } {
      MOM_tool_change
      return
   }

   set mom_sys_first_tool_handled 1

   PB_TURRET_HEAD_SET
   if { [info exists mom_tool_change_type] } {
      switch $mom_tool_change_type {
         MANUAL { PB_manual_tool_change }
         AUTO   { PB_auto_tool_change }
      }
   } elseif { [info exists mom_manual_tool_change] } {
      if { ![string compare $mom_manual_tool_change "TRUE"] } {
         PB_manual_tool_change
      }
   }
}


#=============================================================
proc MOM_from_move { } {
#=============================================================
  global mom_feed_rate mom_feed_rate_per_rev  mom_motion_type mom_kin_max_fpm
   COOLANT_SET ; CUTCOM_SET ; SPINDLE_SET ; RAPID_SET
}


#=============================================================
proc MOM_gohome_move { } {
#=============================================================
   MOM_rapid_move
}


#=============================================================
proc MOM_initial_move { } {
#=============================================================
  global mom_feed_rate mom_feed_rate_per_rev mom_motion_type
  global mom_kin_max_fpm mom_motion_event
   COOLANT_SET ; CUTCOM_SET ; SPINDLE_SET ; RAPID_SET
   if { [PB_CMD__check_block_spindle_max_rpm] } {
      MOM_force Once S_limit
      MOM_do_template spindle_max_rpm
   }
   if { [PB_CMD__check_block_spindle_rpm] } {
      MOM_force Once G_feed S M_spindle
      MOM_do_template spindle_rpm
   }
   if { [PB_CMD__check_block_spindle_css] } {
      MOM_force Once G_spin S M_spindle
      MOM_do_template spindle_css
   }

  global mom_programmed_feed_rate
   if { [EQ_is_equal $mom_programmed_feed_rate 0] } {
      MOM_rapid_move
   } else {
      MOM_linear_move
   }
}


#=============================================================
proc MOM_lathe_roughing { } {
#=============================================================
   PB_CMD_map_cycle95_param
   MOM_do_template lathe_roughing
   if { [PB_CMD__check_block_cycle_powerline] } {
      PB_call_macro CYCLE95
   }
   if { [PB_CMD__check_block_cycle_solutionline] } {
      PB_call_macro CYCLE95_sl
   }
}


#=============================================================
proc MOM_lathe_thread { } {
#=============================================================
  global cycle_name
  global cycle_init_flag

   set cycle_init_flag TRUE
   set cycle_name LATHE_THREAD
}


#=============================================================
proc MOM_lathe_thread_move { } {
#=============================================================
   global cycle_init_flag


   global mom_sys_abort_next_event
   if { [info exists mom_sys_abort_next_event] } {
      if { [llength [info commands PB_CMD_kin_abort_event]] } {
         PB_CMD_kin_abort_event
      }
   }


   PB_LATHE_THREAD_SET
   PB_CMD_fix_thread_cycle
   PB_CMD_lathe_thread_set
   MOM_do_template thread_move
   set cycle_init_flag FALSE
}


#=============================================================
proc MOM_length_compensation { } {
#=============================================================
   TOOL_SET MOM_length_compensation
}


#=============================================================
proc MOM_linear_move { } {
#=============================================================
  global feed_mode mom_feed_rate mom_kin_rapid_feed_rate

   if { ![string compare $feed_mode "IPM"] || ![string compare $feed_mode "MMPM"] } {
      if { [EQ_is_ge $mom_feed_rate $mom_kin_rapid_feed_rate] } {
         MOM_rapid_move
         return
      }
   }


   global mom_sys_abort_next_event
   if { [info exists mom_sys_abort_next_event] } {
      if { [llength [info commands PB_CMD_kin_abort_event]] } {
         PB_CMD_kin_abort_event
      }
   }


   global first_linear_move

   if { !$first_linear_move } {
      PB_first_linear_move
      incr first_linear_move
   }

   if { [PB_CMD__check_block_skip_for_cycle95] } {
      MOM_do_template linear_move
   }
   if { [PB_CMD__check_block_linear_for_cycle95] } {
      MOM_do_template linear_move_cycle95
   }
}


#=============================================================
proc MOM_load_tool { } {
#=============================================================
  global mom_tool_change_type mom_manual_tool_change
   PB_TURRET_HEAD_SET
}


#=============================================================
proc MOM_opstop { } {
#=============================================================
   MOM_do_template opstop
}


#=============================================================
proc MOM_prefun { } {
#=============================================================
   MOM_do_template prefun
}


#=============================================================
proc MOM_rapid_move { } {
#=============================================================
  global rapid_spindle_inhibit rapid_traverse_inhibit
  global spindle_first is_from
  global mom_cycle_spindle_axis traverse_axis1 traverse_axis2
  global mom_motion_event


   global mom_sys_abort_next_event
   if { [info exists mom_sys_abort_next_event] } {
      if { [llength [info commands PB_CMD_kin_abort_event]] } {
         PB_CMD_kin_abort_event
      }
   }


   set spindle_first NONE

   set aa(0) X ; set aa(1) Y ; set aa(2) Z
   RAPID_SET
   MOM_do_template rapid_move
}


#=============================================================
proc MOM_sequence_number { } {
#=============================================================
   SEQNO_SET
}


#=============================================================
proc MOM_set_modes { } {
#=============================================================
   MODES_SET
}


#=============================================================
proc MOM_spindle_css { } {
#=============================================================
   SPINDLE_SET
}


#=============================================================
proc MOM_spindle_off { } {
#=============================================================
   MOM_do_template spindle_off
}


#=============================================================
proc MOM_spindle_rpm { } {
#=============================================================
   SPINDLE_SET
}


#=============================================================
proc MOM_start_of_path { } {
#=============================================================
  global mom_sys_in_operation
   set mom_sys_in_operation 1

  global first_linear_move ; set first_linear_move 0
   TOOL_SET MOM_start_of_path


  global mom_sys_add_cutting_time mom_sys_add_non_cutting_time
  global mom_sys_machine_time mom_machine_time
   set mom_sys_add_cutting_time 0.0
   set mom_sys_add_non_cutting_time 0.0
   set mom_sys_machine_time $mom_machine_time

   if [llength [info commands PB_CMD_kin_start_of_path] ] {
      PB_CMD_kin_start_of_path
   }

   global mom_operation_name
   MOM_output_literal ";Operation : $mom_operation_name"
   if { [PB_CMD__check_block_start_of_path] } {
      MOM_do_template start_of_path
   }
}


#=============================================================
proc MOM_start_of_subop_path { } {
#=============================================================
}


#=============================================================
proc MOM_stop { } {
#=============================================================
   MOM_do_template stop
}


#=============================================================
proc MOM_tap { } {
#=============================================================
  global cycle_name
  global cycle_init_flag

   set cycle_init_flag TRUE
   set cycle_name TAP
   CYCLE_SET
}


#=============================================================
proc MOM_tap_move { } {
#=============================================================
   global cycle_init_flag


   global mom_sys_abort_next_event
   if { [info exists mom_sys_abort_next_event] } {
      if { [llength [info commands PB_CMD_kin_abort_event]] } {
         PB_CMD_kin_abort_event
      }
   }


   if { ![string compare $cycle_init_flag "TRUE"] } {
      PB_CMD_init_cycle_parameters
      MOM_do_template cycle_parameters_1
      PB_CMD_cycle_tap
      if { [PB_CMD__check_block_cycle_powerline] } {
         PB_call_macro CYCLE84 MCALL
      }
      if { [PB_CMD__check_block_cycle_solutionline] } {
         PB_call_macro CYCLE84_sl MCALL
      }
   }

   if { [llength [info commands PB_CMD_config_cycle_start]] } {
      PB_CMD_config_cycle_start
   }
   MOM_do_template cycle_parameters
   set cycle_init_flag FALSE
}


#=============================================================
proc MOM_tap_float { } {
#=============================================================
  global cycle_name
  global cycle_init_flag

   set cycle_init_flag TRUE
   set cycle_name TAP_FLOAT
   CYCLE_SET
}


#=============================================================
proc MOM_tap_float_move { } {
#=============================================================
   global cycle_init_flag


   global mom_sys_abort_next_event
   if { [info exists mom_sys_abort_next_event] } {
      if { [llength [info commands PB_CMD_kin_abort_event]] } {
         PB_CMD_kin_abort_event
      }
   }


   if { ![string compare $cycle_init_flag "TRUE"] } {
      PB_CMD_init_cycle_parameters
      MOM_do_template cycle_parameters_1
      PB_CMD_cycle_tap
      if { [PB_CMD__check_block_cycle_powerline] } {
         PB_call_macro CYCLE840 MCALL
      }
      if { [PB_CMD__check_block_cycle_solutionline] } {
         PB_call_macro CYCLE840_sl MCALL
      }
   }

   if { [llength [info commands PB_CMD_config_cycle_start]] } {
      PB_CMD_config_cycle_start
   }
   MOM_do_template cycle_parameters
   set cycle_init_flag FALSE
}


#=============================================================
proc MOM_thread { } {
#=============================================================
  global cycle_name
  global cycle_init_flag

   set cycle_init_flag TRUE
   set cycle_name THREAD
}


#=============================================================
proc MOM_thread_move { } {
#=============================================================
   global cycle_init_flag


   global mom_sys_abort_next_event
   if { [info exists mom_sys_abort_next_event] } {
      if { [llength [info commands PB_CMD_kin_abort_event]] } {
         PB_CMD_kin_abort_event
      }
   }


   PB_CMD_map_cycle97_param
   if { [PB_CMD__check_block_CYCLE97_Thread] } {
      PB_call_macro CYCLE97_Thread
   }
   set cycle_init_flag FALSE
}


#=============================================================
proc MOM_tool_change { } {
#=============================================================
  global mom_tool_change_type mom_manual_tool_change
   PB_TURRET_HEAD_SET
   if { [info exists mom_tool_change_type] } {
      switch $mom_tool_change_type {
         MANUAL { PB_manual_tool_change }
         AUTO   { PB_auto_tool_change }
      }
   } elseif { [info exists mom_manual_tool_change] } {
      if { ![string compare $mom_manual_tool_change "TRUE"] } {
         PB_manual_tool_change
      }
   }
}


#=============================================================
proc MOM_tool_preselect { } {
#=============================================================
  global mom_tool_preselect_number mom_tool_number mom_next_tool_number
   if {[info exists mom_tool_preselect_number]} {
      set mom_next_tool_number $mom_tool_preselect_number
   }
}


#=============================================================
proc PB_approach_move { } {
#=============================================================
   PB_CMD_init_cycle95_output
}


#=============================================================
proc PB_auto_tool_change { } {
#=============================================================
   global mom_tool_number mom_next_tool_number
   if { ![info exists mom_next_tool_number] } {
      set mom_next_tool_number $mom_tool_number
   }

   PB_CMD_alignment_block
   MOM_force Once T
   MOM_do_template auto_tool_change
   MOM_force Once M
   MOM_do_template auto_tool_change_2
   MOM_do_template auto_tool_change_1
}


#=============================================================
proc PB_engage_move { } {
#=============================================================
}


#=============================================================
proc PB_feedrates { } {
#=============================================================
}


#=============================================================
proc PB_first_cut { } {
#=============================================================
}


#=============================================================
proc PB_first_linear_move { } {
#=============================================================
  global mom_sys_first_linear_move

  # Set this variable to signal 1st linear move has been handled.
   set mom_sys_first_linear_move 1

}


#=============================================================
proc PB_manual_tool_change { } {
#=============================================================
   PB_CMD_alignment_block
   MOM_do_template stop
   MOM_force Once T
   MOM_do_template manual_tool_change_1
}


#=============================================================
proc PB_retract_move { } {
#=============================================================
}


#=============================================================
proc PB_return_move { } {
#=============================================================
}


#=============================================================
proc PB_start_of_program { } {
#=============================================================

   if [llength [info commands PB_CMD_kin_start_of_program] ] {
      PB_CMD_kin_start_of_program
   }

   PB_CMD_set_Sinumerik_version
   PB_CMD_init_ini_files
   MOM_set_seq_on
   MOM_do_template start_of_program

   if [llength [info commands PB_CMD_kin_start_of_program_2] ] {
      PB_CMD_kin_start_of_program_2
   }
}


#=============================================================
proc PB_CMD_FEEDRATE_SET { } {
#=============================================================
# This proc avoids output of G94/G95 if G96 is active

   global mom_spindle_mode

   if { $mom_spindle_mode == "SMM" || $mom_spindle_mode == "SFM" } {
      MOM_disable_address G_feed
   } else {
      MOM_enable_address G_feed
   }
}


#=============================================================
proc PB_CMD___log_revisions { } {
#=============================================================
# Dummy command to log changes in this post --
#
# 02-26-09 gsl - Initial version
# 03-20-11 gsl - Enhanced cycle95 handling
# 03-28-11 gsl - Refine PB_CDM_define_cycle95_handlers and call it in
#                PB_CMD_init_cycle95_output
# 03-30-11 gsl - Refine PB_CMD_init_cycle95_output
# 04-12-11 lili - Add "LBL_END" option into cycle95 output mode
# 04-15-11 lxy - Use Event marker to replace the definition of "MOM_contour_start" &
#                "MOM_contour_end" in PB_CMD_define_cycle95_handlers
#
}


#=============================================================
proc PB_CMD__check_block_CYCLE97_Thread { } {
#=============================================================
# This custom command should return
#   1 : Output BLOCK
#   0 : No output

   global mom_logname
   global thread_cycle_flag

   if { [info exists thread_cycle_flag] && $thread_cycle_flag == 1 } {
 return 1
   } else {
 return 0
   }

}


#=============================================================
proc PB_CMD__check_block_circular_for_cycle95 { } {
#=============================================================
# This custom command should return
#   1 : Output BLOCK
#   0 : No output

   global mom_sys_output_contour_motion
   global mom_siemens_cycle95_output_mode
   global mom_sys_cycle95_start

   if { [info exists mom_sys_cycle95_start] && $mom_sys_cycle95_start } {

      if { [info exists mom_siemens_cycle95_output_mode] &&\
           [string match "LBL_END" $mom_siemens_cycle95_output_mode] } {

         global cycle95_contour_file
         set o_buffer [MOM_do_template circular_move_cycle95 CREATE]
         lappend cycle95_contour_file $o_buffer
   return 0
      } else {
   return 1
      }
   } else {
   return 0
   }

}


#=============================================================
proc PB_CMD__check_block_cycle_powerline { } {
#=============================================================
# This custom command should return
#   1 : Output BLOCK
#   0 : No output

   global sinumerik_control_version


   if { ![info exists sinumerik_control_version] || [string match $sinumerik_control_version "Powerline"] } {
 return 1
   } else {
 return 0
   }
}


#=============================================================
proc PB_CMD__check_block_cycle_solutionline { } {
#=============================================================
# This custom command should return
#   1 : Output BLOCK
#   0 : No output

   global mom_logname
   global mom_cycle_feed_to_pos
   global mom_cycle_spindle_axis
   global mom_cross_hole_diameter
   global mom_depth_type
   global mom_siemens_cycle_gmode
   global mom_siemens_cycle_dmode
   global mom_siemens_cycle_amode
   global sinumerik_control_version
   global mom_motion_event


   if { [info exists sinumerik_control_version] && [string match $sinumerik_control_version "Solutionline"] } {

      if {![info exists mom_motion_event]} {
  return 0
      }

      switch $mom_motion_event {
         drill_move {
            if {[info exists mom_depth_type] && $mom_depth_type ==5 } {
               set mom_siemens_cycle_gmode 1
            } else {
               set mom_siemens_cycle_gmode 0
            }
            if {$mom_siemens_cycle_gmode ==1 && [info exists mom_cross_hole_diameter] } {
               set mom_cycle_feed_to_pos($mom_cycle_spindle_axis) $mom_cross_hole_diameter
            }
            set mom_siemens_cycle_dmode [expr 3-$mom_cycle_spindle_axis]
            set mom_siemens_cycle_amode 0
         }
         drill_dwell_move {
            set mom_siemens_cycle_gmode 0
            set mom_siemens_cycle_dmode [expr 3-$mom_cycle_spindle_axis]
            set mom_siemens_cycle_amode 0

         }
         drill_deep_move -
         drill_break_chip_move {
            set mom_siemens_cycle_gmode 0
            set mom_siemens_cycle_dmode [expr 3-$mom_cycle_spindle_axis]
            set mom_siemens_cycle_amode 0
         }
         bore_move -
         bore_dwell_move {
            set mom_siemens_cycle_plane [expr 3-$mom_cycle_spindle_axis]
            set mom_siemens_cycle_amode 0
         }
         default {}
      };#switch

return 1

   } else {

return 0
   }
}


#=============================================================
proc PB_CMD__check_block_delay_revolutions { } {
#=============================================================
# This custom command should return
#   1 : Output BLOCK
#   0 : No output

   global mom_logname
   global mom_delay_mode

   if { [string match $mom_delay_mode "REVOLUTIONS"] } {
return 1
   }

return 0
}


#=============================================================
proc PB_CMD__check_block_delay_seconds { } {
#=============================================================
# This custom command should return
#   1 : Output BLOCK
#   0 : No output

   global mom_logname
   global mom_delay_mode

   if { [string match $mom_delay_mode "SECONDS"] } {
return 1
   }

return 0
}


#=============================================================
proc PB_CMD__check_block_linear_for_cycle95 { } {
#=============================================================
# This custom command should return
#   1 : Output BLOCK
#   0 : No output

   global mom_sys_output_contour_motion
   global mom_siemens_cycle95_output_mode
   global mom_sys_cycle95_start

   if { [info exists mom_sys_cycle95_start] && $mom_sys_cycle95_start } {
      if { [info exists mom_siemens_cycle95_output_mode] && [string match "LBL_END" $mom_siemens_cycle95_output_mode] } {
         global cycle95_contour_file
         set o_buffer [MOM_do_template linear_move_cycle95 CREATE]
         lappend cycle95_contour_file $o_buffer

   return 0
      } else {
   return 1
      }
   } else {
   return 0
   }

}


#=============================================================
proc PB_CMD__check_block_skip_for_cycle95 { } {
#=============================================================
# This custom command should return
#   1 : Output BLOCK
#   0 : No output

   global mom_sys_output_contour_motion
   global mom_sys_cycle95_start

   if { [info exists mom_sys_cycle95_start] && $mom_sys_cycle95_start } {
      return 0
   } else {
      return 1
   }
}


#=============================================================
proc PB_CMD__check_block_spindle_css { } {
#=============================================================
# This custom command should return
#   1 : Output BLOCK
#   0 : No output

   global mom_spindle_mode
   global spindle_is_out
   global mom_spindle_maximum_rpm

   if { $mom_spindle_mode == "SFM" || $mom_spindle_mode == "SMM" } {
return 1
   }

return 0
}


#=============================================================
proc PB_CMD__check_block_spindle_max_rpm { } {
#=============================================================
# This custom command should return
#   1 : Output BLOCK
#   0 : No output

   global mom_spindle_mode
   global spindle_is_out
   global mom_spindle_maximum_rpm
   global mom_spindle_maximum_rpm_toggle


   if { $mom_spindle_mode == "SFM" || $mom_spindle_mode == "SMM" } {
      if { [info exists mom_spindle_maximum_rpm] && [expr $mom_spindle_maximum_rpm > 0] &&
           [info exists mom_spindle_maximum_rpm_toggle] && $mom_spindle_maximum_rpm_toggle } {
return 1
      }
   }

return 0
}


#=============================================================
proc PB_CMD__check_block_spindle_rpm { } {
#=============================================================
# This custom command should return
#   1 : Output BLOCK
#   0 : No output

   global mom_logname
   global mom_spindle_mode
   global spindle_is_out
   global mom_spindle_maximum_rpm

  #<2012-07-11 lili> enhance feed rate unit
  global mom_feed_cut_unit
  global feed_mode
  if {[info exists mom_feed_cut_unit]} {
     set feed_mode [string toupper $mom_feed_cut_unit]
  }

   if { $mom_spindle_mode == "RPM" } {
return 1
   }

return 0
}


#=============================================================
proc PB_CMD__check_block_spindle_rpm_preset { } {
#=============================================================
# This custom command should return
#   1 : Output BLOCK
#   0 : No output

   global mom_logname
   global mom_spindle_mode
   global spindle_is_out
   global mom_spindle_preset_rpm

   if { $mom_spindle_mode == "SFM" || $mom_spindle_mode == "SMM" } {
      if { [info exists mom_spindle_preset_rpm] && ![EQ_is_zero $mom_spindle_preset_rpm] } {
        MOM_force once G_spin M_spindle S
return 1
      }
   }

return 0
}


#=============================================================
proc PB_CMD__check_block_start_of_path { } {
#=============================================================
# This custom command should return
#   1 : Output BLOCK
#   0 : No output

   global mom_logname
   global mom_sys_lathe_x_double

   if {$mom_sys_lathe_x_double == 1} {
 return 0
   } elseif {$mom_sys_lathe_x_double == 2} {
 return 1
   }

}


#=============================================================
proc PB_CMD__log_revisions { } {
#=============================================================
# Dummy command to log changes in this post --
#
# 02-26-09 gsl - Initial version
#
}


#=============================================================
proc PB_CMD_abort_event { } {
#=============================================================
# This command can be called to abort an event based on the
# flag being set by other handler under certain conditions,
# such as an invalid tool axis vector.
#
# Users can set the global variable mom_sys_abort_next_event to
# different severity levels throughout the post and designate
# how to handle each condition in this command.
#
# - Rapid, linear, circular and cycle move events have this trigger
#   built in by default in PB6.0.
#

   global mom_sys_abort_next_event

   if { [info exists mom_sys_abort_next_event] } {

      switch $mom_sys_abort_next_event {
        1 -
        2 {
          # unset mom_sys_abort_next_event
           CATCH_WARNING "Event aborted!"

           MOM_abort_event
        }
        default {
           CATCH_WARNING "Event warned!"
        }
      }
   }
}


#=============================================================
proc PB_CMD_alignment_block { } {
#=============================================================
   MOM_force once X Z M_spindle M_coolant F
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
proc PB_CMD_before_motion { } {
#=============================================================

}


#=============================================================
proc PB_CMD_before_output { } {
#=============================================================
# This command allows users to massage the NC data (mom_o_buffer) before
# it finally gets output.  If present in the post, this command gets executed
# by MOM_before_output automatically.
#
# - DO NOT overload MOM_before_output! All customization should be done here!
# - DO NOT call any MOM output commands in this command, it will become cyclicle!
# - No need to attach this command to any event marker.
#

   global mom_o_buffer
   global mom_sys_leader
   global mom_sys_control_out mom_sys_control_in
}


#=============================================================
proc PB_CMD_cancel_cycle { } {
#=============================================================
# Unset parameters used in current cycle.

   global mom_cycle_delay_sec

   set cycle_param_list { DTB DAM DTS FRF VARI O_AXN O_MDEP O_VRT O_DTD O_DIS1 SDR SDAC MPIT ENC\
                          PIT POSS SST SST1 O_PTAB O_TECHNO O_VAR1 O_DAM  FFR RFF SDIR RPA RPO RPAP }

   foreach param $cycle_param_list {
      set param [string tolower $param]
      set param mom_siemens_cycle_$param

      global $param
      UNSET_VARS $param
   }

   UNSET_VARS mom_cycle_delay_sec
}


#=============================================================
proc PB_CMD_check_subroutine_name { } {
#=============================================================
# This proc is used to check if subroutine's name is valid.
# The first two characters must be letters.
# The others can be letters, numerals or underscore characters.
# Do not use more than 31 characters.
# No separators are to be used.

   global mom_machine_cycle_subroutine_name
   global mom_operation_name
   global mom_siemens_cycle95_output_mode
   global machine_cycle_subroutine_list
   global mom_sys_cycle95_subprogram_name
   global mom_sys_cycle95_subprogram_start
   global mom_sys_cycle95_subprogram_end


   if {[info exists mom_siemens_cycle95_output_mode] && [string match "LBL*" $mom_siemens_cycle95_output_mode]} {
      if {[string length $mom_sys_cycle95_subprogram_start]>31} {
         MOM_output_to_listing_device "Labels name in Operation $mom_operation_name should not more than 31 characters."
         set mom_sys_cycle95_subprogram_start [string range $mom_sys_cycle95_subprogram_start 0 30]
      }
      if {[string length $mom_sys_cycle95_subprogram_end]>31} {
         MOM_output_to_listing_device "Labels name in Operation $mom_operation_name should not more than 31 characters."
         set mom_sys_cycle95_subprogram_end [string range $mom_sys_cycle95_subprogram_end 0 26]_END
      }
      if {![regexp {^[A-Za-z][A-Za-z][A-Za-z0-9_]*$} $mom_sys_cycle95_subprogram_start]} {
         MOM_output_to_listing_device "Labels name in Operation $mom_operation_name should be letters, numerals or underscore characters.\
                                       \n The first two characters must be letters."
      }
      if {![regexp {^[A-Za-z][A-Za-z][A-Za-z0-9_]*$} $mom_sys_cycle95_subprogram_end]} {
         MOM_output_to_listing_device "Labels name in Operation $mom_operation_name should be letters, numerals or underscore characters.\
                                      \n The first two characters must be letters."
      }
   } else {
      if {[string length $mom_sys_cycle95_subprogram_name]>31} {
         MOM_output_to_listing_device "Subroutine name in Operation $mom_operation_name should not more than 31 characters."
         set mom_sys_cycle95_subprogram_name [string range $mom_sys_cycle95_subprogram_name 0 30]
      }
      if {![regexp {^[A-Za-z][A-Za-z][A-Za-z0-9_]*$} $mom_sys_cycle95_subprogram_name]} {
         MOM_output_to_listing_device "Subroutine name in Operation $mom_operation_name should be letters, numerals or underscore characters.\
                                      \n The first two characters must be letters."
      }
   }

   if {![info exists machine_cycle_subroutine_list]} {
      set machine_cycle_subroutine_list [list $mom_machine_cycle_subroutine_name]
   } else {
      foreach subroutine $machine_cycle_subroutine_list {
         if {[string compare $subroutine $mom_machine_cycle_subroutine_name]} {
            lappend machine_cycle_subroutine_list $mom_machine_cycle_subroutine_name
         } else {
            MOM_output_to_listing_device "Subroutine name $mom_machine_cycle_subroutine_name is duplicated in Operation $mom_operation_name"
         }
      }
   }
}


#=============================================================
proc PB_CMD_compute_rapid_to_for_csink { } {
#=============================================================

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
#
# ==> THIS COMMAND MAY NOT BE DELETED OR ADDED TO OTHER EVENT MARKERS!
#
}


#=============================================================
proc PB_CMD_contour_end { } {
#=============================================================
   global mom_machine_cycle_subroutine_name
   global mom_operation_name
   global mom_sys_output_contour_motion
   global mom_siemens_cycle95_output_mode

   global mom_sys_cycle95_start
   set mom_sys_cycle95_start 0

   if { [info exists mom_siemens_cycle95_output_mode] && [string match "SUB" $mom_siemens_cycle95_output_mode] } {

      global ptp_file_name
      global mom_output_file_directory
      global cycle95_subroutine_file

      if { [info exists cycle95_subroutine_file] } {

         MOM_output_literal "M17"
         MOM_close_output_file $cycle95_subroutine_file

        # Restore sequence number
         global mom_sequence_number mom_sequence_increment mom_sequence_frequency
         global mom_sequence_number_saved mom_sequence_increment_saved mom_sequence_frequency_saved

         set mom_sequence_number $mom_sequence_number_saved
         set mom_sequence_increment $mom_sequence_increment_saved
         set mom_sequence_frequency $mom_sequence_frequency_saved
         MOM_reset_sequence $mom_sequence_number $mom_sequence_increment $mom_sequence_frequency
      }

      MOM_open_output_file $ptp_file_name

   } elseif { [info exists mom_siemens_cycle95_output_mode] && [string match "LBL" $mom_siemens_cycle95_output_mode] } {

      global mom_sys_cycle95_subprogram_end

     # Output end label for in-line subprogram
      MOM_output_text "${mom_sys_cycle95_subprogram_end}:"

   } else {

      global cycle95_contour_file
      global mom_sys_cycle95_subprogram_end

      lappend cycle95_contour_file "${mom_sys_cycle95_subprogram_end}:"
   }


  #+++++++++++++++++++++++++++++++++++++++++
  # Tell NX/Post to end contour output mode
  #+++++++++++++++++++++++++++++++++++++++++
   set mom_sys_output_contour_motion 0


  #--------------------------
  # Output CYCLE95 statement
  #--------------------------
   MOM_lathe_roughing


  #++++++++++++++++++++++++++++++++++++++++++++++++
  # Output return move (X -> Z) after cycle95 call
  # ==> Detail moves may need to be adjusted
  #     according to the nature of the cut.
  #++++++++++++++++++++++++++++++++++++++++++++++++
   global mom_pos mom_pos_saved_for_cycle95

   VMOV 3 mom_pos_saved_for_cycle95 mom_pos
   MOM_reload_variable -a mom_pos

   MOM_force once G_motion G_mode X
   MOM_suppress once Z
   MOM_rapid_move

   MOM_force once Z
   MOM_rapid_move


  #--------------------------
  # handle machine time
  #--------------------------
   global mom_sys_machine_time mom_machine_time mom_toolpath_time
   if { [info exists mom_sys_machine_time] } {
      set mom_machine_time [expr $mom_sys_machine_time + $mom_toolpath_time]
      MOM_reload_variable mom_machine_time
   }
}


#=============================================================
proc PB_CMD_contour_start { } {
#=============================================================
   global mom_machine_cycle_subroutine_name
   global mom_operation_name
   global mom_siemens_cycle95_output_mode

   global mom_sys_cycle95_subprogram_name
   global mom_sys_cycle95_subprogram_start
   global mom_sys_cycle95_subprogram_end

   global mom_sys_cycle95_start
   set mom_sys_cycle95_start 1

   if { [info exists mom_siemens_cycle95_output_mode] && [string match "SUB" $mom_siemens_cycle95_output_mode] } {

      global ptp_file_name
      global mom_output_file_directory
      global cycle95_subroutine_file

      MOM_close_output_file $ptp_file_name

      set cycle95_subroutine_file "${mom_output_file_directory}${mom_sys_cycle95_subprogram_name}.SPF"

      if { [file exists $cycle95_subroutine_file] } {
         MOM_remove_file $cycle95_subroutine_file
      }

      MOM_open_output_file $cycle95_subroutine_file

      global mom_sequence_number mom_sequence_increment mom_sequence_frequency mom_seqnum
      global mom_sequence_number_saved mom_sequence_increment_saved mom_sequence_frequency_saved

     # Save sequence number
      set mom_sequence_number_saved $mom_seqnum
      set mom_sequence_increment_saved $mom_sequence_increment
      set mom_sequence_frequency_saved $mom_sequence_frequency

     # Set sequence number for subprogram
      set mom_sequence_number     100
      set mom_sequence_increment  10
      set mom_sequence_frequency  1

      MOM_reset_sequence $mom_sequence_number $mom_sequence_increment $mom_sequence_frequency

   } elseif { [info exists mom_siemens_cycle95_output_mode] && [string match "LBL" $mom_siemens_cycle95_output_mode] } {

     # Output instruction for main program to skip over the in-line subprogram
     # - All in-line labels are in upper case.
      MOM_output_literal "GOTOF $mom_sys_cycle95_subprogram_end"

     # Output start lebel for in-line subprogram
      MOM_output_text "${mom_sys_cycle95_subprogram_start}:"

   } else {
      global cycle95_contour_file

      if { ![info exists cycle95_contour_file] } {
         set cycle95_contour_file [list]
      }

      lappend cycle95_contour_file "${mom_sys_cycle95_subprogram_start}:"
   }

   MOM_force Once G_motion X Z
}


#=============================================================
proc PB_CMD_cycle_tap { } {
#=============================================================
# This procedure is used to set tap cycle parameters for sinumerik 840D
#

  #-------------------------------------------------------
  # Inputs for tapping
  #-------------------------------------------------------
   global mom_spindle_speed
   global mom_spindle_direction
   global mom_motion_event
   global feed

   global mom_siemens_cycle_sdr
   global mom_siemens_cycle_enc
   global mom_siemens_cycle_sdac
   global mom_siemens_cycle_mpit
   global mom_siemens_cycle_pit
   global mom_siemens_cycle_poss
   global mom_siemens_cycle_sst
   global mom_siemens_cycle_sst1
   global mom_siemens_cycle_sdac
   global mom_siemens_cycle_sdr
   global mom_siemens_cycle_enc
   global mom_siemens_cycle_o_ptab
   global mom_siemens_cycle_o_var1
   global mom_cycle_option


   if { ![string match "tap*_move" $mom_motion_event] } {
return
   }

   if { ![info exists mom_siemens_cycle_sdac] } {
      set mom_siemens_cycle_sdac 3
   } else {
      switch $mom_siemens_cycle_sdac {
         CLW     { set mom_siemens_cycle_sdac 3 }
         CCLW    { set mom_siemens_cycle_sdac 4 }
         Off     { set mom_siemens_cycle_sdac 5 }
         default {}
      }
   }

   global mom_siemens_cycle_mpit_defined

   if { [info exists mom_siemens_cycle_mpit] } {
      if { $mom_spindle_direction == "CCLW" } {
         set mom_siemens_cycle_mpit [expr -1*$mom_siemens_cycle_mpit]
      }

     # If users set mpit, pit will be ignored
      UNSET_VARS mom_siemens_cycle_pit
      UNSET_VARS mom_siemens_cycle_o_ptab

   } else {
      if { [info exists mom_siemens_cycle_o_ptab] } {
         switch $mom_siemens_cycle_o_ptab {
            "Post Defined"        { set mom_siemens_cycle_o_ptab 0 }
            "Millimeter"          { set mom_siemens_cycle_o_ptab 1 }
            "Groove per Inch"     { set mom_siemens_cycle_o_ptab 2 }
            "Inch per Revolution" { set mom_siemens_cycle_o_ptab 3 }
            default               {}
         }
      } else {
         set mom_siemens_cycle_o_ptab 0
      }

      if {[info exists mom_siemens_cycle_pit]} {
         if {$mom_siemens_cycle_pit == 0 || $mom_siemens_cycle_o_ptab == 0} {
            global mom_cycle_feed_rate_per_rev mom_cycle_feed_rate
            if {[info exist mom_cycle_feed_rate_per_rev] && ![EQ_is_zero $mom_cycle_feed_rate_per_rev]} {
                set mom_siemens_cycle_pit $mom_cycle_feed_rate_per_rev
            } elseif { [info exists mom_spindle_speed] && $mom_spindle_speed != 0 } {
                set mom_siemens_cycle_pit [expr $mom_cycle_feed_rate/$mom_spindle_speed]
            }
         }
         if {$mom_spindle_direction == "CCLW"} {
            set mom_siemens_cycle_pit [expr -1*$mom_siemens_cycle_pit]
         }
      } else {
         global mom_cycle_feed_rate_per_rev mom_cycle_feed_rate
         if {[info exist mom_cycle_feed_rate_per_rev] && ![EQ_is_zero $mom_cycle_feed_rate_per_rev]} {
            set mom_siemens_cycle_pit $mom_cycle_feed_rate_per_rev
            if {$mom_spindle_direction == "CCLW"} {
               set mom_siemens_cycle_pit [expr -1*$mom_siemens_cycle_pit]
            }
         } elseif { [info exists mom_spindle_speed] && $mom_spindle_speed != 0 } {
            set mom_siemens_cycle_pit [expr $mom_cycle_feed_rate/$mom_spindle_speed]
            if {$mom_spindle_direction == "CCLW"} {
               set mom_siemens_cycle_pit [expr -1*$mom_siemens_cycle_pit]
            }
         }
      }
   }

   if { [info exists mom_spindle_speed] } {
      set mom_siemens_cycle_sst $mom_spindle_speed
   }
   if {![info exists mom_siemens_cycle_sst1] } {
      set mom_siemens_cycle_sst1 0
   }

   if { [info exists mom_siemens_cycle_o_var1] } {
      switch $mom_siemens_cycle_o_var1 {
         "Single Pass" { set mom_siemens_cycle_o_var1 0 }
         "Break Chip"  { set mom_siemens_cycle_o_var1 1 }
         "Remove Chip" { set mom_siemens_cycle_o_var1 2 }
         default       {}
      }
   }

   if { [info exists mom_siemens_cycle_enc] } {
      switch $mom_siemens_cycle_enc {
         "Use Encoder-Dwell Off"             { set mom_siemens_cycle_enc 0  }
         "Use Encoder-Dwell On"              { set mom_siemens_cycle_enc 20 }
         "No Encoder-Feed Rate before Cycle" { set mom_siemens_cycle_enc 1  }
         "No Encoder-Feed Rate in Cycle"     { set mom_siemens_cycle_enc 11 }
         default  {}
      }
   }

   if { [info exists mom_siemens_cycle_sdr] } {
      switch $mom_siemens_cycle_sdr {
         "Reversal" { set mom_siemens_cycle_sdr 0 }
         "CLW"      { set mom_siemens_cycle_sdr 3 }
         "CCLW"     { set mom_siemens_cycle_sdr 4 }
         default    {}
      }
   }
}


#=============================================================
proc PB_CMD_end_of_alignment_character { } {
#=============================================================
# This command restores sequnece number back to orignal
# This command may be used with the command "PM_CMD_start_of_alignment_character"
#
   global mom_sys_leader saved_seq_num

   if { [info exists saved_seq_num] } {
      set mom_sys_leader(N) $saved_seq_num
   }
}


#=============================================================
proc PB_CMD_end_of_path { } {
#=============================================================
   global thread_cycle_flag

   set thread_cycle_flag 0
}


#=============================================================
proc PB_CMD_fix_thread_cycle { } {
#=============================================================
   global thread_cycle_flag

   if { [info exists thread_cycle_flag] && $thread_cycle_flag == -1 } {
      MOM_force Once G_motion X Y Z
      MOM_linear_move
      MOM_abort_event
   }
}


#=============================================================
proc PB_CMD_handle_sync_event { } {
#=============================================================
  global mom_sync_code
  global mom_sync_index
  global mom_sync_start
  global mom_sync_incr
  global mom_sync_max


  set mom_sync_start  99
  set mom_sync_incr   1
  set mom_sync_max    199


  if { ![info exists mom_sync_code] } {
    set mom_sync_code $mom_sync_start
  }

  set mom_sync_code [expr $mom_sync_code + $mom_sync_incr]

  MOM_output_literal "M$mom_sync_code"
}


#=============================================================
proc PB_CMD_init_cycle95_output { } {
#=============================================================
# ==> This command should be called in the event whose position can be output
#     as the "ready position" (outside of stock) for the CYCLE95 call.
#
#-----------------------------------------------------------------------------
# This command gathers information to determine if NX/Post should
# process contour data and produce subprogram & cycle95 instructions.
#
# The state of variable "mom_machine_control_motion_output" will indicate
# when turning processor will produce contour data whereas the variable
# "mom_sys_output_cycle95" indicates that post is equipped with the ability
# to output CYCLE95. This ability can be activated in the event below:
#
#   "Program & Tool Path"
#      -> "Program"
#          -> "Canned Cycles" -> "Turn Roughing"
#
#*****************************************************************************
# This command will only function when
#  - Turning processor has produced contour data
#  - The post is equipped with the ability to output cycle95
#
# What can be done here?
#  1. Select subprogram output style in either in-line or external SPF file
#  2. Specify labels and/or subprogram name
#  3. Validate subprogram name
#  4. Save current position to be output after the CYCLE95 call
#     - Output for the "return move" can be customized in "MOM_contour_end"
#       event handlers.
#  5. Skip over the remaining tool path events in the operation
#*****************************************************************************
#

   global mom_sys_output_contour_motion
   global mom_machine_control_motion_output
   global mom_sys_output_cycle95
   global mom_machine_cycle_subroutine_name
   global mom_operation_name

   set mom_sys_output_contour_motion 0

  #======================================================
  # When turning processor has produced contour data and
  # post is equipped with the ability to output cycle95:
  #======================================================
   if { ([info exists mom_machine_control_motion_output] && $mom_machine_control_motion_output == 2) && \
        ([info exists mom_sys_output_cycle95] && $mom_sys_output_cycle95) } {

     #----------------------------------------
     # Notify NX/Post to process contour data
     #----------------------------------------
      set mom_sys_output_contour_motion 1


     #####################################################
     # Set CYCLE95 contour output mode
     #
     #   LBL: Output subprogram in-line with main program
     #        (Enclosed in start & end labels)
     #   LBL_END: Output subprogram at end of main program
     #        (Enclosed in start & end labels)
     #   SUB: Output subprogram in a separate SPF file
     #####################################################
      global mom_siemens_cycle95_output_mode

     # set mom_siemens_cycle95_output_mode  "LBL"
      set mom_siemens_cycle95_output_mode "LBL_END"
     # set mom_siemens_cycle95_output_mode  "SUB"


     #++++++++++++++++++++++++++++++++++++++++++++++++
     # Defined start & end labels and subprogram name
     # ==> User may customize these labels as needed.
     #++++++++++++++++++++++++++++++++++++++++++++++++
      global mom_sys_cycle95_subprogram_name
      global mom_sys_cycle95_subprogram_start
      global mom_sys_cycle95_subprogram_end

     # Define subprogram name when it is not specified in NX.
      if { ![info exists mom_machine_cycle_subroutine_name] } {
         set  mom_machine_cycle_subroutine_name SUB_$mom_operation_name
         set mom_sys_cycle95_subprogram_end    "[string toupper $mom_operation_name]_END"
      } elseif { ![string compare "" $mom_machine_cycle_subroutine_name] } {
         set  mom_machine_cycle_subroutine_name SUB_$mom_operation_name
         set mom_sys_cycle95_subprogram_end    "[string toupper $mom_operation_name]_END"
      } else {
         set mom_sys_cycle95_subprogram_end    "[string toupper $mom_machine_cycle_subroutine_name]_END"
      }
      set mom_sys_cycle95_subprogram_name   "[string toupper $mom_machine_cycle_subroutine_name]"
      set mom_sys_cycle95_subprogram_start  "[string toupper $mom_machine_cycle_subroutine_name]"


     # Validate subprogram name and labels
      PB_CMD_check_subroutine_name


     #---------------------------------------------------------------
     # Save current position of this event.
     # - It will be used as the return position after the cycle call.
     #---------------------------------------------------------------
      global mom_pos mom_pos_saved_for_cycle95
      VMOV 3 mom_pos mom_pos_saved_for_cycle95


     #------------------------------
     # Skip to the end of operation
     #------------------------------
      MOM_abort_operation
   }
}


#=============================================================
proc PB_CMD_init_cycle_parameters { } {
#=============================================================
# This command is used to set cycle parameters for sinumerik 840D.

  PB_CMD_set_principal_axis

  #-------------------------------------------------------
  # Ouput cycle feed mode
  #-------------------------------------------------------
  global mom_motion_event
  switch $mom_motion_event {
     bore_move -
     bore_dwell_move { }
     default { MOM_do_template cycle_feed_mode }
  }

  #-------------------------------------------------------
  # Cycle parameters
  #-------------------------------------------------------
  global mom_cycle_delay_mode
  global mom_cycle_delay
  global mom_cycle_delay_revs
  global mom_siemens_cycle_dtb
  global mom_siemens_cycle_dts_mode
  global mom_siemens_cycle_dts
  global mom_siemens_cycle_o_dtd_mode
  global mom_siemens_cycle_o_dtd

  if { [info exists mom_cycle_delay_mode] } {
     set mom_cycle_delay_mode [string toupper $mom_cycle_delay_mode]
     if { [info exists mom_cycle_delay] && [string match "SECONDS" $mom_cycle_delay_mode] } {
        set mom_siemens_cycle_dtb [expr abs($mom_cycle_delay)]
     } elseif { [info exists mom_cycle_delay_revs] && [string match "REVOLUTIONS" $mom_cycle_delay_mode] } {
        set mom_siemens_cycle_dtb [expr -1*abs($mom_cycle_delay_revs)]
        set mom_cycle_delay_revs [expr -1*$mom_cycle_delay_revs]
     } elseif { [string match "OFF" $mom_cycle_delay_mode] } {

     } else {
        global mom_dwell mom_dwell_unit
        if { $mom_dwell_unit == 0 } {
           set mom_cycle_delay $mom_dwell
           set mom_siemens_cycle_dtb $mom_dwell
        } else {
           set mom_cycle_delay $mom_dwell
           set mom_cycle_delay_revs [expr -1*$mom_dwell]
           set mom_siemens_cycle_dtb [expr -1*abs($mom_dwell)]
        }
     }
  }

  if { [info exists mom_siemens_cycle_dts_mode] } {
     set mom_siemens_cycle_dts_mode [string toupper $mom_siemens_cycle_dts_mode]
     if { [info exists mom_siemens_cycle_dts] && [string match "SECONDS" $mom_siemens_cycle_dts_mode] } {
         set mom_siemens_cycle_dts [expr abs($mom_siemens_cycle_dts)]
     } elseif { [info exists mom_siemens_cycle_dts] && [string match "REVOLUTIONS" $mom_siemens_cycle_dts_mode] } {
         set mom_siemens_cycle_dts [expr -1*abs($mom_siemens_cycle_dts)]
     } elseif { [string match "OFF" $mom_siemens_cycle_dts_mode] } {
         catch { unset mom_siemens_cycle_dts }
     }
  }

  if { [info exists mom_siemens_cycle_o_dtd_mode] } {
     set mom_siemens_cycle_o_dtd_mode [string toupper $mom_siemens_cycle_o_dtd_mode]
     if { [info exists mom_siemens_cycle_o_dtd] && [string match "SECONDS" $mom_siemens_cycle_o_dtd_mode] } {
         set mom_siemens_cycle_o_dtd [expr abs($mom_siemens_cycle_o_dtd)]
     } elseif { [info exists mom_siemens_cycle_o_dtd] && [string match "REVOLUTIONS" $mom_siemens_cycle_o_dtd_mode] } {
         set mom_siemens_cycle_o_dtd [expr -1*abs($mom_siemens_cycle_o_dtd)]
     } elseif { [string match "ON" $mom_siemens_cycle_o_dtd_mode] } {
         set mom_siemens_cycle_o_dtd 0
     } elseif { [string match "OFF" $mom_siemens_cycle_o_dtd_mode] } {
         catch {unset mom_siemens_cycle_o_dtd}
     }
  }

  global mom_cycle_step1
  global mom_cycle_step2
  global mom_cycle_step3
  global feed
  global mom_sys_spindle_direction_code
  global mom_spindle_direction
  global mom_feed_retract_value

  global mom_siemens_cycle_fdpr
  global mom_siemens_cycle_dam
  global mom_siemens_cycle_frf
  global mom_siemens_cycle_ffr
  global mom_siemens_cycle_rff
  global mom_siemens_cycle_sdir
  global mom_siemens_cycle_o_mdep

  if { [info exists mom_cycle_step1] } {
     set mom_siemens_cycle_fdpr $mom_cycle_step1
  }
  if { [info exists mom_cycle_step2] } {
     set mom_siemens_cycle_dam $mom_cycle_step2
  }
  if { [info exists mom_cycle_step3] } {
      set mom_siemens_cycle_o_mdep $mom_cycle_step3
  }

  set mom_siemens_cycle_ffr $feed

  if {![info exists mom_siemens_cycle_rff] || [EQ_is_zero $mom_siemens_cycle_rff] } {
     if { [info exists mom_feed_retract_value] && ![EQ_is_zero $mom_feed_retract_value] } {
        set mom_siemens_cycle_rff $mom_feed_retract_value
     } else {
        set mom_siemens_cycle_rff $feed
     }
  }

  if {![info exists mom_siemens_cycle_frf] } {
     set mom_siemens_cycle_frf 1
  }

  set mom_siemens_cycle_sdir 3
  if { [info exists mom_spindle_direction] } {
      switch $mom_spindle_direction {
         "CLW"  { set mom_siemens_cycle_sdir 3}
         "CCLW" { set mom_siemens_cycle_sdir 4}
      }
  }
}


#=============================================================
proc PB_CMD_init_ini_files { } {
#=============================================================
# This procedure is used with simulation_ini.tcl file which should be sourced
# in postprocessor as a user tcl file for generating ini files.
# This procedure will be excuted when simulation_ini.tcl is sourcing.
# Once you source the simulation_ini.tcl file in a postprocessor, remove this
# procedure from Start of Program will NOT affect the result.
#
# Following mom variables are used to set the options for ini files.
# mom_sinumerik_ini_create
#    "Yes"          ini files will be created
#    "No "          ini files will not be created
#
# mom_sinumerik_ini_location
#    "Part"         ini files will be output to a subfolder \cse_files\subprog
#                   of cam part file location. If \cse_files\subprog is not exists
#                   post will create this folder.
#    "CSE"          ini files will be output to sub folder \subprog of \cse_driver
#                   folder which located in same directory of \postprocessor as installed
#                   machine examples.
#    "ENV"          ini files will be output to a sub folder \subprog of enviornment
#                   variable defined directory.
#                   If it is not exists, ini files will be output to "Part".
#
# mom_sinumerik_ini_existing
#    "Rename"       Rename existing ini files to .bck in place where the one is created.
#    "Keep"         Keep ini files in place where the one is created.
#    "Delete"       Delete ini files in place where the one is created.
#
# mom_sinumerik_ini_end_status
#    "Rename"       Rename created ini file to .bck file after post run.
#    "Keep"         Keep created ini files after post run.
#    "Delete"       Delete created ini files after post run.


  global mom_sinumerik_ini_create
  global mom_sinumerik_ini_location
  global mom_sinumerik_ini_keep_existing
  global mom_sinumerik_ini_end_status

  set mom_sinumerik_ini_create     "Yes"
  set mom_sinumerik_ini_location   "Part"
  set mom_sinumerik_ini_existing   "Rename"
  set mom_sinumerik_ini_end_status "Keep"

}


#=============================================================
proc PB_CMD_kin_abort_event { } {
#=============================================================
   if { [llength [info commands PB_CMD_abort_event]] } {
      PB_CMD_abort_event
   }
}


#=============================================================
proc PB_CMD_kin_before_output { } {
#=============================================================
# Broker command ensuring PB_CMD_before_output,if present, gets executed
# by MOM_before_output.
#
   if [llength [info commands PB_CMD_before_output] ] {
      PB_CMD_before_output
   }
}


#=============================================================
proc PB_CMD_kin_end_of_path { } {
#=============================================================
  # Record tool time for this operation.
   if { [llength [info commands PB_CMD_set_oper_tool_time] ] } {
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
      RETRACT -
      RETURN -
      LIFT -
      TRAVERSAL -
      GOHOME -
      GOHOME_DEFAULT -
      RAPID {
         SUPER_FEED_MODE_SET RAPID
      }

      default {
         if { [EQ_is_zero $f_pm] && [EQ_is_zero $f_pr] } {
            SUPER_FEED_MODE_SET RAPID
         } else {
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
   if { [llength [info commands "PB_CMD_FEEDRATE_SET"]] } {
      PB_CMD_FEEDRATE_SET
   }
}


#=============================================================
proc PB_CMD_kin_handle_sync_event { } {
#=============================================================
   PB_CMD_handle_sync_event
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
   set cmd PB_CMD_init_probing_cycles
   if { [llength [info commands "$cmd"]] } {
      eval $cmd
   }
}


#=============================================================
proc PB_CMD_kin_set_csys { } {
#=============================================================
   if [llength [info commands PB_CMD_set_csys] ] {
      PB_CMD_set_csys
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
      if { [llength [info commands "$cmd"]] } {
         eval $cmd
         rename $cmd ""
         proc $cmd { args } {}
      }
   }
}


#=============================================================
proc PB_CMD_lathe_thread_set { } {
#=============================================================
   global mom_lathe_thread_lead_i mom_lathe_thread_lead_k
   global mom_total_depth_angle
   global RAD2DEG

   if {![EQ_is_zero $mom_lathe_thread_lead_i] && ![EQ_is_zero $mom_lathe_thread_lead_k] } {
      set lead_angle [expr abs($RAD2DEG*$mom_total_depth_angle)]
      if { $lead_angle > 180.0 } {
         set lead_angle [expr fmod($lead_angle,180.0)]
      }
      if { [EQ_is_gt $lead_angle 45.0] && [EQ_is_lt $lead_angle 135.0] } {
         MOM_force Once I ; MOM_suppress Once K
      } else {
         MOM_force Once K ; MOM_suppress Once I
      }
   }

   if {[EQ_is_zero $mom_lathe_thread_lead_i]} {
      MOM_suppress Once I
   }

   if {[EQ_is_zero $mom_lathe_thread_lead_k]} {
      MOM_suppress Once K
   }
}


#=============================================================
proc PB_CMD_map_cycle95_param { } {
#=============================================================
   global mom_siemens_cycle_mid
   global mom_siemens_cycle_vari
   global mom_siemens_cycle_dam
   global mom_machine_cycle_subroutine_name
   global mom_siemens_cycle_subroutine_name
   global mom_siemens_cycle_mid
   global mom_cut_depth
   global mom_maximum
   global mom_stepover
   global mom_siemens_cycle_vari
   global mom_cleanup
   global mom_profiling
   global mom_local_return_dwell_flag
   global mom_local_return_dwell
   global mom_local_return_dwell_unit
   global mom_local_return_status
   global mom_local_return_mode
   global mom_local_return_distance
   global mom_siemens_cycle_dam
   global mom_feed_cut_unit
   global mom_feed_cut_value
   global mom_feed_stepover_unit
   global mom_feed_stepover_value
   global mom_feedrate_profile_cut_unit
   global mom_feedrate_profile_cut
   global mom_spindle_mode
   global mom_spindle_rpm mom_pos
   global mom_siemens_cycle95_output_mode


   global mom_sys_cycle95_subprogram_name
   global mom_sys_cycle95_subprogram_start
   global mom_sys_cycle95_subprogram_end

  # Subroutine name string to be referenced in CYCLE95 call
   if { [info exists mom_siemens_cycle95_output_mode] && [string match "SUB" $mom_siemens_cycle95_output_mode] } {
      set mom_siemens_cycle_subroutine_name $mom_sys_cycle95_subprogram_name
   } else {
      set mom_siemens_cycle_subroutine_name ${mom_sys_cycle95_subprogram_start}:${mom_sys_cycle95_subprogram_end}
   }

  # MID infeed depth
   global mom_turn_cycle_cut_depth
   global mom_sys_lathe_x_double
   if { [info exists mom_turn_cycle_cut_depth] } {
      set mom_siemens_cycle_mid $mom_turn_cycle_cut_depth
   } else {
      if { [info exists mom_stepover] } {
         if { $mom_stepover == 0 } {
            set mom_siemens_cycle_mid $mom_cut_depth
         } elseif { $mom_stepover == 1 || $mom_stepover == 2 }  {
            set mom_siemens_cycle_mid $mom_maximum
         }
      }
   }
   if {$mom_sys_lathe_x_double == 2} {
      set mom_siemens_cycle_mid [expr 2*$mom_siemens_cycle_mid]
   }

  # Feedrate
   global mom_operation_name
   global feed_mode

   if { [string match "SFM" $mom_spindle_mode] || [string match "SMM" $mom_spindle_mode] } {
      if { [string match "ipm" $mom_feed_cut_unit] || [string match "mmpm" $mom_feed_cut_unit] } {
         MOM_output_to_listing_device "WARNING: Cut feed rate unit $mom_feed_cut_unit doesn't match\
                                       spindle speed mode $mom_spindle_mode in $mom_operation_name!"
      }
   } else {
      set feed_mode [string toupper $mom_feed_cut_unit]
   }

   if { [string compare $mom_feed_cut_unit $mom_feed_stepover_unit] } {
      MOM_output_to_listing_device "WARNING: Stepover and Cut feed rate unit are different in $mom_operation_name!"
      MOM_output_to_listing_device "         In CYCLE95, FF2 will be as same as FF1!"

      set mom_feed_stepover_value $mom_feed_cut_value
   }

   if { [EQ_is_zero $mom_feed_stepover_value] } {
      set mom_feed_stepover_value $mom_feed_cut_value
   }

   if { [info exists mom_feedrate_profile_cut] } {
      if { $mom_feedrate_profile_cut_unit == 4 } {
         set mom_feedrate_profile_cut [expr $mom_feed_cut_value*$mom_feedrate_profile_cut/100]
      } elseif { ($mom_feedrate_profile_cut_unit == 1 && ![string match "*pm" $mom_feed_cut_unit]) ||\
                 ($mom_feedrate_profile_cut_unit == 2 && ![string match "*pr" $mom_feed_cut_unit]) } {
         MOM_output_to_listing_device "WARNING: Profile cut and Cut feed rate unit are different in $mom_operation_name!"
         MOM_output_to_listing_device "         In CYCLE95, FF3 will be as same as FF1!"

         set mom_feedrate_profile_cut $mom_feed_cut_value
      } else {
         if { [EQ_is_zero $mom_feedrate_profile_cut] } {
            set mom_feedrate_profile_cut $mom_feed_cut_value
         }
      }
   }

   # Convert feed rate unit
   global mom_kin_output_unit mom_part_unit

   if { ![string compare $mom_kin_output_unit $mom_part_unit] } {
      set mom_sys_unit_conversion "1.0"
   } elseif { ![string compare "IN" $mom_kin_output_unit] } {
      set mom_sys_unit_conversion [expr 1.0/25.4]
   } else {
      set mom_sys_unit_conversion 25.4
   }
   set mom_feed_cut_value [expr $mom_sys_unit_conversion*$mom_feed_cut_value]
   set mom_feed_stepover_value [expr $mom_sys_unit_conversion*$mom_feed_stepover_value]
   if { [info exists mom_feedrate_profile_cut] } {
      set mom_feedrate_profile_cut  [expr $mom_sys_unit_conversion*$mom_feedrate_profile_cut]
   }

  # DT-dwell time
   if { $mom_local_return_dwell_flag == 0 } {
      set mom_local_return_dwell 0
   } else {
      if { $mom_local_return_dwell_unit == 1 } {
         MOM_output_to_listing_device "WARNING: Local return dwell unit should be SECONDS in $mom_operation_name."
         MOM_output_to_listing_device "         DT value in CYCLE95 is the revolution value."
      }
   }

  # DAM
   if { [info exists mom_local_return_status] && $mom_local_return_status > 0 } {
      set mom_siemens_cycle_dam $mom_local_return_distance
   } else {
      set mom_siemens_cycle_dam 0
   }

}


#=============================================================
proc PB_CMD_map_cycle97_param { } {
#=============================================================
# This command is used to map cycle97 parameters.
# Under machine control cycle output condition, MOM_load_lathe_thread_cycle_params will return 1
# if it is executed properly. It will load cycle97 thread related MOM variables
# mom_lathe_thread_crest_line_start mom_lathe_thread_root_line_start
# mom_lathe_thread_crest_line_end mom_lathe_thread_clearance_start
# mom_lathe_thread_root_line_end  mom_lathe_thread_clearance_end
# MOM_skip_handler_to_event cycle_off is used to skip events between current event
# to MOM_cycle_off.
  global mom_turn_cycle97_machining_type
  global mom_turn_cycle_total_depth
  global mom_lathe_thread_crest_line_start mom_lathe_thread_crest_line_end
  global mom_lathe_thread_root_line_start  mom_lathe_thread_root_line_end
  global mom_lathe_thread_clearance_start mom_lathe_thread_clearance_end
  global mom_lathe_spindle_axis
  global mom_siemens_cycle_pit
  global mom_turn_thread_pitch_lead
  global mom_number_of_starts
  global mom_siemens_cycle_spl
  global mom_siemens_cycle_fpl
  global mom_siemens_cycle_dm1
  global mom_siemens_cycle_dm2
  global mom_siemens_cycle_fal
  global mom_total_depth_finish_passes_increment
  global mom_total_depth_finish_passes_number_of_passes
  global mom_siemens_cycle_nrc
  global mom_total_depth_constant_increment
  global mom_total_depth_constant_increment_source
  global mom_total_depth_increment_type
  global mom_tool_insert_length
  global mom_siemens_cycle_iang
  global mom_thread_infeed_vector mom_thread_infeed_angle
  global RAD2DEG

  if { [CMD_EXIST MOM_load_lathe_thread_cycle_params] && [MOM_load_lathe_thread_cycle_params] } {
     #++++++++++++++++++++++++++++++++++++++++++++++++++++
     # mom_siemens_cycle_pit -PIT pitch value
     #++++++++++++++++++++++++++++++++++++++++++++++++++++
     set mom_siemens_cycle_pit [expr $mom_turn_thread_pitch_lead/$mom_number_of_starts]

     #++++++++++++++++++++++++++++++++++++++++++++++++++++
     # mom_siemens_cycle_spl -SPL thread start point longitudinal
     # mom_siemens_cycle_fpl -FPL thread end point longitudinal
     # mom_siemens_cycle_dm1 -DM1 thread start point diameter
     # mom_siemens_cycle_dm2 -DM2 thread end point diameter
     #++++++++++++++++++++++++++++++++++++++++++++++++++++
     if {[string match $mom_lathe_spindle_axis "MCSX"]} {
        set mom_siemens_cycle_spl $mom_lathe_thread_crest_line_start(0)
        set mom_siemens_cycle_fpl $mom_lathe_thread_crest_line_end(0)
        set mom_siemens_cycle_dm1 [expr 2*$mom_lathe_thread_crest_line_start(1)]
        set mom_siemens_cycle_dm2 [expr 2*$mom_lathe_thread_crest_line_end(1)]
     } elseif {[string match $mom_lathe_spindle_axis "MCSZ"]} {
        set mom_siemens_cycle_spl $mom_lathe_thread_crest_line_start(2)
        set mom_siemens_cycle_fpl $mom_lathe_thread_crest_line_end(2)
        set mom_siemens_cycle_dm1 [expr 2*$mom_lathe_thread_crest_line_start(0)]
        set mom_siemens_cycle_dm2 [expr 2*$mom_lathe_thread_crest_line_end(0)]
     }

     #++++++++++++++++++++++++++++++++++++++++++++++++++++
     # mom_siemens_cycle_fal -FAL finish allowance
     #++++++++++++++++++++++++++++++++++++++++++++++++++++
     set mom_siemens_cycle_fal 0
     for {set i 0} {$i<100} {incr i} {
       set mom_siemens_cycle_fal [expr $mom_siemens_cycle_fal + $mom_total_depth_finish_passes_increment($i)*$mom_total_depth_finish_passes_number_of_passes($i)]
     }

     #++++++++++++++++++++++++++++++++++++++++++++++++++++
     # mom_siemens_cycle_nrc -NRC roughing cuts number
     #++++++++++++++++++++++++++++++++++++++++++++++++++++
     if {$mom_total_depth_increment_type == 0} {
        if {[info exists mom_total_depth_constant_increment_source]} {
           set constant_depth [expr $mom_tool_insert_length*$mom_total_depth_constant_increment/100]
           global mom_output_unit mom_part_unit
           if {[string compare $mom_output_unit $mom_part_unit]} {
              if {[string compare $mom_part_unit "MM"]} {
                 set constant_depth [expr $constant_depth/25.4]
              } else {
                 set constant_depth [expr $constant_depth*25.4]
              }
           }
        } else {
           set constant_depth $mom_total_depth_constant_increment
        }
        set mom_siemens_cycle_nrc  [expr ceil(($mom_turn_cycle_total_depth- $mom_siemens_cycle_fal)/$constant_depth)]
     } else {
        PAUSE "Thread CYCLE97 should be constant cut depth!"
     }

     # Skip to MOM_cycle_off
     if {[CMD_EXIST MOM_skip_handler_to_event]} {
        MOM_skip_handler_to_event cycle_off
        global thread_cycle_flag
        set thread_cycle_flag 1
     }
  }


}


#=============================================================
proc PB_CMD_output_MCALL { } {
#=============================================================
  global thread_cycle_flag

  if {[info exists thread_cycle_flag] && $thread_cycle_flag == 1} {
return
  }

  MOM_output_literal "MCALL"
}


#=============================================================
proc PB_CMD_output_cycle95_contour_file { } {
#=============================================================
   global cycle95_contour_file

   if { [info exist cycle95_contour_file] } {

      MOM_output_text " "

      foreach line $cycle95_contour_file {
         MOM_output_literal $line
      }

      MOM_output_literal "M30"
   }
}


#=============================================================
proc PB_CMD_output_spindle { } {
#=============================================================
  global mom_spindle_mode
  global spindle_is_out
  global mom_spindle_maximum_rpm


   if { ![info exists spindle_is_out] } {
      if { $mom_spindle_mode == "RPM" } {
         MOM_force once M_spindle S G_spin
         MOM_do_template spindle_rpm
      } elseif { $mom_spindle_mode == "SFM" || $mom_spindle_mode == "SMM" } {
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
proc PB_CMD_output_thread_cycle { } {
#=============================================================
# This command is used to output Sinumerik 840D thread cycle.
   global thread_cycle_flag
   global mom_crest_line_offset

   if { [info exists thread_cycle_flag] && $thread_cycle_flag == 1 } {
      set thread_cycle_flag -1
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
proc PB_CMD_reset_lathe_post { } {
#=============================================================
  global mom_kin_machine_type

   if { ![string compare "lathe" $mom_kin_machine_type] } {
      set mom_kin_machine_type "3_axis_mill"
      MOM_reload_kinematics

      set mom_kin_machine_type "lathe"
      MOM_reload_kinematics
   }
}


#=============================================================
proc PB_CMD_set_Sinumerik_version { } {
#=============================================================
# Please set Sinumerik Version here.
#
# Sinumerik control version "Powerline"
# Sinumerik control version "Solutionline"


   global sinumerik_control_version

   set sinumerik_control_version "Powerline"
  # set sinumerik_control_version "Solutionline"
}


#=============================================================
proc PB_CMD_set_csys { } {
#=============================================================
#  This custom command is provided as the default to nullify
#  the same command in a linked post that may have been
#  imported from pb_cmd_coordinate_system_rotation.tcl.
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

  global mom_lathe_spindle_axis
  global mom_kin_arc_valid_plane

   if { [info exists mom_lathe_spindle_axis] && $mom_lathe_spindle_axis == "MCSZ" } {
      set mom_kin_arc_valid_plane  "ZX"
      MOM_reload_kinematics
   }
}


#=============================================================
proc PB_CMD_set_principal_axis { } {
#=============================================================
# This command can be used to determine the principal axis.
#
# => It can be used to determine a proper work plane when the
#    "Work Plane" parameter is not specified with an operation.
#
#
# <06-22-09 gsl> - Extracted from PB_CMD_set_cycle_plane
# <10-09-09 gsl> - Do not define mom_pos_arc_plane unless it doesn't exist.
# <03-10-10 gsl> - Respect tool axis for 3-axis & XZC cases
# <01-21-11 gsl> - Enhance header description
#

   global mom_cycle_spindle_axis
   global mom_spindle_axis
   global mom_cutcom_plane mom_pos_arc_plane


  # Initialization spindle axis
   global mom_kin_spindle_axis
   global mom_sys_spindle_axis
   if { ![info exists mom_kin_spindle_axis] } {
      set mom_kin_spindle_axis(0) 0.0
      set mom_kin_spindle_axis(1) 0.0
      set mom_kin_spindle_axis(2) 1.0
   }
   if { ![info exists mom_sys_spindle_axis] } {
      VMOV 3 mom_kin_spindle_axis mom_sys_spindle_axis
   }
   if { ![info exists mom_spindle_axis] } {
      VMOV 3 mom_sys_spindle_axis mom_spindle_axis
   }


  # Default cycle spindle axis to Z
   set mom_cycle_spindle_axis 2


  #<03-10-10 gsl> pb751 - Respect tool axis for 3-axis & XZC
   global mom_kin_machine_type mom_tool_axis
   if [string match "3_axis*" $mom_kin_machine_type] {
      VMOV 3 mom_tool_axis spindle_axis
   } else {
      VMOV 3 mom_spindle_axis spindle_axis
   }


   if { [EQ_is_equal [expr abs($spindle_axis(0))] 1.0] } {
      set mom_cycle_spindle_axis 0
   }

   if { [EQ_is_equal [expr abs($spindle_axis(1))] 1.0] } {
      set mom_cycle_spindle_axis 1
   }

   switch $mom_cycle_spindle_axis {
      0 {
         set mom_cutcom_plane  YZ
      }
      1 {
         set mom_cutcom_plane  ZX
      }
      2 {
         set mom_cutcom_plane  XY
      }
      default {
         set mom_cutcom_plane  UNDEFINED
      }
   }

   # Set arc plane when it's not defined
   if { ![info exists mom_pos_arc_plane] || $mom_pos_arc_plane == "" } {
      set mom_pos_arc_plane $mom_cutcom_plane
   }

}


#=============================================================
proc PB_CMD_spindle_sfm_prestart { } {
#=============================================================
   global mom_spindle_mode
   global spindle_is_out


   if { [info exists spindle_is_out] } {
      unset spindle_is_out
   }
}


#=============================================================
proc PB_CMD_start_of_alignment_character { } {
#=============================================================
# This command can be used to output a special sequence number character.
# - Replace the ":" with any character that you require.
#
# ==> You must use the command "PB_CMD_end_of_alignment_character" to reset
#     the sequence number back to the original setting.

  global mom_sys_leader saved_seq_num
  set saved_seq_num $mom_sys_leader(N)
  set mom_sys_leader(N) ":"
}


#=============================================================
proc ARCTAN { y x } {
#=============================================================
   global PI

   if { [EQ_is_zero $y] } { set y 0 }
   if { [EQ_is_zero $x] } { set x 0 }

   if { [expr $y == 0] && [expr $x == 0] } {
      return 0
   }

   set ang [expr atan2($y,$x)]

   if { $ang < 0 } {
      return [expr $ang + $PI*2]
   } else {
      return $ang
   }
}


#=============================================================
proc CALLED_BY { caller {out_warn 0} args } {
#=============================================================
# This command can be used in the beginning of a command
# to designate a specific caller for the command in question.
#
# - Users can set the optional flag "out_warn" to "1" to output
#   warning message when a command is being called by a
#   non-designated caller. By default, warning message is suppressed.
#
#  Syntax:
#    if { ![CALLED_BY "cmd_string"] } { return ;# or do something }
#  or
#    if { ![CALLED_BY "cmd_string" 1] } { return ;# To output warning }
#
# Revisions:
#-----------
# 05-25-10 gsl - Initial implementation
# 03-09-11 gsl - Enhanced description
#

   if { ![string compare "$caller" [info level -2] ] } {
return 1
   } else {
      if { $out_warn } {
         CATCH_WARNING "\"[info level -1]\" can not be executed in \"[info level -2]\". \
                        It must be called by \"$caller\"!"
      }
return 0
   }
}


#=============================================================
proc CATCH_WARNING { msg {output 1} } {
#=============================================================
   global mom_warning_info
   global mom_motion_event
   global mom_event_number
   global mom_motion_type
   global mom_operation_name


   if { $output == 1 } {

      set level [info level]
      set call_stack ""
      for { set i 1 } { $i < $level } { incr i } {
         set call_stack "$call_stack\[ [lindex [info level $i] 0] \]"
      }

      global mom_o_buffer
      if { ![info exists mom_o_buffer] } {
         set mom_o_buffer ""
      }

      if { ![info exists mom_motion_event] } {
         set mom_motion_event ""
      }

      if { [info exists mom_operation_name] && [string length $mom_operation_name] } {
         set mom_warning_info "$msg\n\  Operation $mom_operation_name - Event $mom_event_number [MOM_ask_event_type] :\
                               $mom_motion_event ($mom_motion_type)\n\    $mom_o_buffer\n\      $call_stack"
      } else {
         set mom_warning_info "$msg\n\  Event $mom_event_number [MOM_ask_event_type] :\
                               $mom_motion_event ($mom_motion_type)\n\    $mom_o_buffer\n\      $call_stack"
      }

      MOM_catch_warning
   }

   set mom_warning_info $msg
}


#=============================================================
proc CMD_EXIST { cmd {out_warn 0} args } {
#=============================================================
# This command can be used to detect the existence of a command
# before executing it.
# - Users can set the optional flag "out_warn" to "1" to output
#   warning message when a command to be called doesn't exist.
#   By default, warning message is suppressed.
#
#  Syntax:
#    if { [CMD_EXIST "cmd_string"] } { cmd_string }
#  or
#    if { [CMD_EXIST "cmd_string" 1] } { cmd_string ;# To output warning }
#
# Revisions:
#-----------
# 05-25-10 gsl - Initial implementation
# 03-09-11 gsl - Enhanced description
#

   if { [llength [info commands "$cmd"] ] } {
return 1
   } else {
      if { $out_warn } {
         CATCH_WARNING "Command \"$cmd\" called by \"[info level -1]\" does not exist!"
      }
return 0
   }
}


proc CYCLE_SET {  } {
WORKPLANE_SET
}


#=============================================================
proc EQ_is_equal { s t } {
#=============================================================
return [EQ_is_zero [expr $s - $t]]
}


#=============================================================
proc EQ_is_zero { s } {
#=============================================================
   global mom_system_tolerance

   if { [info exists mom_system_tolerance] && [expr $mom_system_tolerance > 0.0] } {
      set tol $mom_system_tolerance
   } else {
      set tol 0.0000001
   }

   if { [expr abs($s) <= $tol] } { return 1 } else { return 0 }
}


#=============================================================
proc EXEC { command_string {__wait 1} } {
#=============================================================
# This command can be used in place of the intrinsic Tcl "exec" command
# of which some problems have been reported under Win64 O/S and multi-core
# processors environment.
#
#
# Input:
#   command_string -- command string
#   __wait         -- optional flag
#                     1 (default)   = Caller will wait until execution is complete.
#                     0 (specified) = Caller will not wait.
#
# Return:
#   Results of execution
#
#
# Revisions:
#-----------
# 05-19-10 gsl - Initial implementation
#

   global tcl_platform


   if { $__wait } {

      if { [string match "windows" $tcl_platform(platform)] } {

         global env mom_logname

        # Create a temporary file to collect output
         set result_file "$env(TEMP)/${mom_logname}__EXEC_[clock clicks].out"

        # Clean up existing file
         regsub -all {\\} $result_file {/}  result_file
        #regsub -all { }  $result_file {\ } result_file

         if { [file exists "$result_file"] } {
            file delete -force "$result_file"
         }

         set cmd [concat exec $command_string > \"$result_file\"]
         regsub -all {\\} $cmd {\\\\} cmd

         eval $cmd

        # Return results & clean up temporary file
         if { [file exists "$result_file"] } {
            set fid [open "$result_file" r]
            set result [read $fid]
            close $fid

            file delete -force "$result_file"

           return $result
         }

      } else {

         set cmd [concat exec $command_string]

        return [eval $cmd]
      }

   } else {

      if { [string match "windows" $tcl_platform(platform)] } {

         set cmd [concat exec $command_string &]
         regsub -all {\\} $cmd {\\\\} cmd

        return [eval $cmd]

      } else {

        return [exec $command_string &]
      }
   }
}




#=============================================================
proc INFO { args } {
#=============================================================
   MOM_output_to_listing_device [join $args]
}


#=============================================================
proc LIMIT_ANGLE { a } {
#=============================================================
   set a [expr fmod($a,360)]
   set a [expr ($a < 0) ? ($a + 360) : $a]

return $a
}


#=============================================================
proc PAUSE { args } {
#=============================================================
# Revisions:
#-----------
# 05-19-10 gsl - Use EXEC command
#

   global env

   if { [info exists env(PB_SUPPRESS_UGPOST_DEBUG)]  &&  $env(PB_SUPPRESS_UGPOST_DEBUG) == 1 } {
  return
   }


   global gPB

   if { [info exists gPB(PB_disable_MOM_pause)]  &&  $gPB(PB_disable_MOM_pause) == 1 } {
  return
   }


   global tcl_platform

   set cam_aux_dir  [MOM_ask_env_var UGII_CAM_AUXILIARY_DIR]

   if { [string match "*windows*" $tcl_platform(platform)] } {
      set ug_wish "ugwish.exe"
   } else {
      set ug_wish ugwish
   }

   if { [file exists ${cam_aux_dir}$ug_wish]  &&  [file exists ${cam_aux_dir}mom_pause.tcl] } {

      set title ""
      set msg ""

      if { [llength $args] == 1 } {
         set msg [lindex $args 0]
      }

      if { [llength $args] > 1 } {
         set title [lindex $args 0]
         set msg [lindex $args 1]
      }

      set command_string [concat \"${cam_aux_dir}$ug_wish\" \"${cam_aux_dir}mom_pause.tcl\" \"$title\" \"$msg\"]

      set res [EXEC $command_string]


      switch [string trim $res] {
         no {
            set gPB(PB_disable_MOM_pause) 1
         }
         cancel {
            set gPB(PB_disable_MOM_pause) 1

            uplevel #0 {
               MOM_abort "*** User Abort Post Processing *** "
            }
         }
         default {
            return
         }
      }

   } else {

      CATCH_WARNING "PAUSE not executed -- \"$ug_wish\" or \"mom_pause.tcl\" not found"
   }
}


#=============================================================
proc PAUSE_win64 { args } {
#=============================================================
   global env
   if { [info exists env(PB_SUPPRESS_UGPOST_DEBUG)]  &&  $env(PB_SUPPRESS_UGPOST_DEBUG) == 1 } {
  return
   }

   global gPB
   if { [info exists gPB(PB_disable_MOM_pause)]  &&  $gPB(PB_disable_MOM_pause) == 1 } {
  return
   }


   set cam_aux_dir  [MOM_ask_env_var UGII_CAM_AUXILIARY_DIR]
   set ug_wish "ugwish.exe"

   if { [file exists ${cam_aux_dir}$ug_wish] &&\
        [file exists ${cam_aux_dir}mom_pause_win64.tcl] } {

      set title ""
      set msg ""

      if { [llength $args] == 1 } {
         set msg [lindex $args 0]
      }

      if { [llength $args] > 1 } {
         set title [lindex $args 0]
         set msg [lindex $args 1]
      }


     ######
     # Define a scratch file and pass it to mom_pause_win64.tcl script -
     #
     #   A separated process will be created to construct the Tk dialog.
     #   This process will communicate with the main process via the state of a scratch file.
     #   This scratch file will collect the messages that need to be conveyed from the
     #   child process to the main process.
     ######
      global mom_logname
      set pause_file_name "$env(TEMP)/${mom_logname}_mom_pause_[clock clicks].txt"


     ######
     # Path names should be per unix style for "open" command
     ######
      regsub -all {\\} $pause_file_name {/}  pause_file_name
      regsub -all { }  $pause_file_name {\ } pause_file_name
      regsub -all {\\} $cam_aux_dir {/}  cam_aux_dir
      regsub -all { }  $cam_aux_dir {\ } cam_aux_dir

      if [file exists $pause_file_name] {
         file delete -force $pause_file_name
      }


     ######
     # Note that the argument order for mom_pasue.tcl has been changed
     # The assumption at this point is we will always have the communication file as the first
     # argument and optionally the title and message as the second and third arguments
     ######
      open "|${cam_aux_dir}$ug_wish ${cam_aux_dir}mom_pause_win64.tcl ${pause_file_name} {$title} {$msg}"


     ######
     # Waiting for the mom_pause to complete its process...
     # - This is indicated when the scratch file materialized and became read-only.
     ######
      while { ![file exists $pause_file_name] || [file writable $pause_file_name] } { }


     ######
     # Delay a 100 milli-seconds to ensure that sufficient time is given for the other process to complete.
     ######
      after 100


     ######
     # Open the scratch file to read and process the information.  Close it afterward.
     ######
      set fid [open "$pause_file_name" r]

      set res [string trim [gets $fid]]
      switch $res {
         no {
            set gPB(PB_disable_MOM_pause) 1
         }
         cancel {
            close $fid
            file delete -force $pause_file_name

            set gPB(PB_disable_MOM_pause) 1

            uplevel #0 {
               MOM_abort "*** User Abort Post Processing *** "
            }
         }
         default {}
      }


     ######
     # Delete the scratch file
     ######
      close $fid
      file delete -force $pause_file_name
   }
}


#=============================================================
proc PAUSE_x { args } {
#=============================================================
   global env
   if { [info exists env(PB_SUPPRESS_UGPOST_DEBUG)]  &&  $env(PB_SUPPRESS_UGPOST_DEBUG) == 1 } {
  return
   }

   global gPB
   if { [info exists gPB(PB_disable_MOM_pause)]  &&  $gPB(PB_disable_MOM_pause) == 1 } {
  return
   }



  #==========
  # Win64 OS
  #
   global tcl_platform

   if { [string match "*windows*" $tcl_platform(platform)] } {
      global mom_sys_processor_archit

      if { ![info exists mom_sys_processor_archit] } {
         set pVal ""
         set env_vars [array get env]
         set idx [lsearch $env_vars "PROCESSOR_ARCHITE*"]
         if { $idx >= 0 } {
            set pVar [lindex $env_vars $idx]
            set pVal [lindex $env_vars [expr $idx + 1]]
         }
         set mom_sys_processor_archit $pVal
      }

      if { [string match "*64*" $mom_sys_processor_archit] } {

         PAUSE_win64 $args
  return
      }
   }



   set cam_aux_dir  [MOM_ask_env_var UGII_CAM_AUXILIARY_DIR]


   if { [string match "*windows*" $tcl_platform(platform)] } {
     set ug_wish "ugwish.exe"
   } else {
     set ug_wish ugwish
   }

   if { [file exists ${cam_aux_dir}$ug_wish] && [file exists ${cam_aux_dir}mom_pause.tcl] } {

      set title ""
      set msg ""

      if { [llength $args] == 1 } {
         set msg [lindex $args 0]
      }

      if { [llength $args] > 1 } {
         set title [lindex $args 0]
         set msg [lindex $args 1]
      }

      set res [exec ${cam_aux_dir}$ug_wish ${cam_aux_dir}mom_pause.tcl $title $msg]
      switch $res {
         no {
            set gPB(PB_disable_MOM_pause) 1
         }
         cancel {
            set gPB(PB_disable_MOM_pause) 1

            uplevel #0 {
               MOM_abort "*** User Abort Post Processing *** "
            }
         }
         default { return }
      }
   }
}


#=============================================================
proc STR_MATCH { VAR str {out_warn 0} } {
#=============================================================
# This command will match a variable with a given string.
#
# - Users can set the optional flag "out_warn" to "1" to produce
#   warning message when the variable is not defined in the scope
#   of the caller of this function.
#
   upvar $VAR var

   if { [info exists var] && [string match "$var" "$str"] } {
return 1
   } else {
      if { $out_warn } {
         CATCH_WARNING "Variable $VAR is not defined in \"[info level -1]\"!"
      }
return 0
   }
}


#=============================================================
proc TRACE {  } {
#=============================================================
   set start_idx 1

   set str ""
   set level [info level]
   for { set i $start_idx } { $i < $level } { incr i } {
      set str "${str}[lindex [info level $i] 0]\n"
   }

return $str
}


#=============================================================
proc UNSET_VARS { args } {
#=============================================================
# Inputs: List of variable names
#

   if { [llength $args] == 0 } {
return
   }

   foreach VAR $args {
      upvar $VAR var

      global tcl_version

      if { [array exists var] } {
         if { [expr $tcl_version < 8.4] } {
            foreach a [array names var] {
               if { [info exists var($a)] } {
                  unset var($a)
               }
            }
            unset var
         } else {
            array unset var
         }
      }

      if { [info exists var] } {
         unset var
      }
   }
}


#=============================================================
proc VMOV { n p1 p2 } {
#=============================================================
  upvar $p1 v1 ; upvar $p2 v2

   for { set i 0 } { $i < $n } { incr i } {
      set v2($i) $v1($i)
   }
}


#=============================================================
proc WORKPLANE_SET {  } {
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


#=============================================================
proc PB_DEFINE_MACROS { } {
#=============================================================
   global mom_pb_macro_arr

   set mom_pb_macro_arr(CYCLE81) \
       [list {CYCLE81 ( , ) 0 {}} \
        {{{$mom_cycle_retract_to_pos($mom_cycle_spindle_axis)} 1 3 5 1 1 8 3} \
         {{$mom_pos($mom_cycle_spindle_axis)} 1 3 5 1 1 8 3} \
         {{$mom_cycle_clearance_plane} 1 3 5 1 1 8 3} \
         {{$mom_cycle_feed_to_pos($mom_cycle_spindle_axis)} 1 3 5 1 1 8 3}}]

   set mom_pb_macro_arr(CYCLE82) \
       [list {CYCLE82 ( , ) 0 {}} \
        {{{$mom_cycle_retract_to_pos($mom_cycle_spindle_axis)} 1 3 5 1 1 8 3} \
         {{$mom_pos($mom_cycle_spindle_axis)} 1 3 5 1 1 8 3} \
         {{$mom_cycle_clearance_plane} 1 3 5 1 1 8 3} \
         {{$mom_cycle_feed_to_pos($mom_cycle_spindle_axis)} 1 3 5 1 1 8 3} \
         {} \
         {{$mom_siemens_cycle_dtb} 1 3 5 1 1 8 3}}]

   set mom_pb_macro_arr(CYCLE83_Deep) \
       [list {CYCLE83 ( , ) 0 {}} \
        {{{$mom_cycle_retract_to_pos($mom_cycle_spindle_axis)} 1 3 5 1 1 8 3} \
         {{$mom_pos($mom_cycle_spindle_axis)} 1 3 5 1 1 8 3} \
         {{$mom_cycle_clearance_plane} 1 3 5 1 1 8 3} \
         {{$mom_cycle_feed_to_pos($mom_cycle_spindle_axis)} 1 3 5 1 1 8 3} \
         {} \
         {} \
         {{$mom_cycle_step1} 1 3 5 1 1 8 3} \
         {{$mom_cycle_step2} 1 3 5 1 1 8 3} \
         {{$mom_siemens_cycle_dtb} 1 3 5 1 1 8 3} \
         {{$mom_siemens_cycle_dts} 1 3 5 1 1 8 3} \
         {{$mom_siemens_cycle_frf} 1 3 5 1 1 8 3} \
         {1 0} \
         {{$mom_siemens_cycle_o_axn} 1 0 1 0 0 1} \
         {{$mom_cycle_step3} 1 3 5 1 1 8 3}}]

   set mom_pb_macro_arr(CYCLE83_Break_Chip) \
       [list {CYCLE83 ( , ) 0 {}} \
        {{{$mom_cycle_retract_to_pos($mom_cycle_spindle_axis)} 1 3 5 1 1 8 3} \
         {{$mom_pos($mom_cycle_spindle_axis)} 1 3 5 1 1 8 3} \
         {{$mom_cycle_clearance_plane} 1 3 5 1 1 8 3} \
         {{$mom_cycle_feed_to_pos($mom_cycle_spindle_axis)} 1 3 5 1 1 8 3} \
         {} \
         {} \
         {{$mom_siemens_cycle_fdpr} 1 3 5 1 1 8 3} \
         {{$mom_siemens_cycle_dam} 1 3 5 1 1 8 3} \
         {{$mom_siemens_cycle_dtb} 1 3 5 1 1 8 3} \
         {} \
         {{$mom_siemens_cycle_frf} 1 3 5 1 1 8 3} \
         {0 0} \
         {{$mom_siemens_cycle_o_axn} 1 0 1 0 0 1} \
         {{$mom_cycle_step3} 1 3 5 1 1 8 3}}]

   set mom_pb_macro_arr(CYCLE84) \
       [list {CYCLE84 ( , ) 0 {}} \
        {{{$mom_cycle_retract_to_pos($mom_cycle_spindle_axis)} 1 3 5 1 1 8 3} \
         {{$mom_pos($mom_cycle_spindle_axis)} 1 3 5 1 1 8 3} \
         {{$mom_cycle_clearance_plane} 1 3 5 1 1 8 3} \
         {{$mom_cycle_feed_to_pos($mom_cycle_spindle_axis)} 1 3 5 1 1 8 3} \
         {} \
         {{$mom_cycle_delay} 1 3 5 1 1 8 3} \
         {{$mom_siemens_cycle_sdac} 1 0 1 0 0 1} \
         {{$mom_siemens_cycle_mpit} 1 0 2 0 0 2} \
         {{$mom_siemens_cycle_pit} 1 3 5 1 1 8 3} \
         {{$mom_cycle_orient} 1 3 5 1 1 8 3} \
         {{$mom_spindle_speed} 1 2 7 1 1 9 2} \
         {{$mom_siemens_cycle_sst1} 1 2 7 1 1 9 2} \
         {{$mom_siemens_cycle_o_axn} 1 0 1 0 0 1}}]

   set mom_pb_macro_arr(CYCLE840) \
       [list {CYCLE840 ( , ) 0 {}} \
        {{{$mom_cycle_retract_to_pos($mom_cycle_spindle_axis)} 1 3 5 1 1 8 3} \
         {{$mom_pos($mom_cycle_spindle_axis)} 1 3 5 1 1 8 3} \
         {{$mom_cycle_clearance_plane} 1 3 5 1 1 8 3} \
         {{$mom_cycle_feed_to_pos($mom_cycle_spindle_axis)} 1 3 5 1 1 8 3} \
         {} \
         {{$mom_cycle_delay} 1 3 5 1 1 8 3} \
         {{$mom_siemens_cycle_sdr} 1 0 1 0 0 1} \
         {{$mom_siemens_cycle_sdac} 1 0 1 0 0 1} \
         {{$mom_siemens_cycle_enc} 1 0 2 0 0 2} \
         {{$mom_siemens_cycle_mpit} 1 0 2 0 0 2} \
         {{$mom_siemens_cycle_pit} 1 3 5 1 1 8 3} \
         {{$mom_siemens_cycle_o_axn} 1 0 1 0 0 1} \
         {{$mom_siemens_cycle_o_ptab} 1 0 1 0 0 1} \
         {{$mom_siemens_cycle_o_techno} 1 0 2 0 0 2}}]

   set mom_pb_macro_arr(CYCLE85_Bore) \
       [list {CYCLE85 ( , ) 0 {}} \
        {{{$mom_cycle_retract_to_pos($mom_cycle_spindle_axis)} 1 3 5 1 1 8 3} \
         {{$mom_pos($mom_cycle_spindle_axis)} 1 3 5 1 1 8 3} \
         {{$mom_cycle_clearance_plane} 1 3 5 1 1 8 3} \
         {{$mom_cycle_feed_to_pos($mom_cycle_spindle_axis)} 1 3 5 1 1 8 3} \
         {} \
         {} \
         {{$feed} 1 2 7 1 1 9 2} \
         {{$mom_siemens_cycle_rff} 1 2 7 1 1 9 2}}]

   set mom_pb_macro_arr(CYCLE85_Bore_Dwell) \
       [list {CYCLE85 ( , ) 0 {}} \
        {{{$mom_cycle_retract_to_pos($mom_cycle_spindle_axis)} 1 3 5 1 1 8 3} \
         {{$mom_pos($mom_cycle_spindle_axis)} 1 3 5 1 1 8 3} \
         {{$mom_cycle_clearance_plane} 1 3 5 1 1 8 3} \
         {{$mom_cycle_feed_to_pos($mom_cycle_spindle_axis)} 1 3 5 1 1 8 3} \
         {} \
         {{$mom_cycle_delay} 1 3 5 1 1 8 3} \
         {{$feed} 1 2 7 1 1 9 2} \
         {{$mom_siemens_cycle_rff} 1 2 7 1 1 9 2}}]

   set mom_pb_macro_arr(CYCLE97_Thread) \
       [list {CYCLE97 ( , ) 0 {}} \
        {{{$mom_siemens_cycle_pit} 1 3 5 1 1 8 3} \
         {} \
         {{$mom_siemens_cycle_spl} 1 3 5 1 1 8 3} \
         {{$mom_siemens_cycle_fpl} 1 3 5 1 1 8 3} \
         {{$mom_siemens_cycle_dm1} 1 3 5 1 1 8 3} \
         {{$mom_siemens_cycle_dm2} 1 3 5 1 1 8 3} \
         {0 1 3 5 1 1 8 3} \
         {0 1 3 5 1 1 8 3} \
         {{$mom_turn_cycle_total_depth} 1 3 5 1 1 8 3} \
         {{$mom_siemens_cycle_fal} 1 3 5 1 1 8 3} \
         {{$mom_siemens_cycle_iang} 1 3 5 1 1 8 3} \
         {0 0} \
         {{$mom_siemens_cycle_nrc} 1 0 2 0 0 2} \
         {{$mom_number_of_chases} 1 0 2 0 0 2} \
         {{$mom_turn_cycle97_machining_type} 1 0 2 0 0 2} \
         {{$mom_number_of_starts} 1 0 2 0 0 2} \
         {{$mom_minimum_clearance} 1 3 5 1 1 8 3}}]

   set mom_pb_macro_arr(MCALL) \
       [list {MCALL {} {} {} 0 {}} \
        {}]

   set mom_pb_macro_arr(CYCLE81_sl) \
       [list {CYCLE81 ( , ) 0 {}} \
        {{{$mom_cycle_retract_to_pos($mom_cycle_spindle_axis)} 1 3 5 1 1 8 3} \
         {{$mom_pos($mom_cycle_spindle_axis)} 1 3 5 1 1 8 3} \
         {{$mom_cycle_clearance_plane} 1 3 5 1 1 8 3} \
         {{$mom_cycle_feed_to_pos($mom_cycle_spindle_axis)} 1 3 5 1 1 8 3} \
         {} \
         {{$mom_siemens_cycle_dtb} 1 4 2 1 1 6 4} \
         {{$mom_siemens_cycle_gmode} 1 0 1 0 0 1} \
         {{$mom_siemens_cycle_dmode} 1 0 2 0 0 2} \
         {{$mom_siemens_cycle_amode} 1 0 2 0 0 2}}]

   set mom_pb_macro_arr(CYCLE82_sl) \
       [list {CYCLE82 ( , ) 0 {}} \
        {{{$mom_cycle_retract_to_pos($mom_cycle_spindle_axis)} 1 3 5 1 1 8 3} \
         {{$mom_pos($mom_cycle_spindle_axis)} 1 3 5 1 1 8 3} \
         {{$mom_cycle_clearance_plane} 1 3 5 1 1 8 3} \
         {{$mom_cycle_feed_to_pos($mom_cycle_spindle_axis)} 1 3 5 1 1 8 3} \
         {} \
         {{$mom_siemens_cycle_dtb} 1 3 5 1 1 8 3} \
         {{$mom_siemens_cycle_gmode} 1 0 1 0 0 1} \
         {{$mom_siemens_cycle_dmode} 1 0 2 0 0 2} \
         {{$mom_siemens_cycle_amode} 1 0 2 0 0 2}}]

   set mom_pb_macro_arr(CYCLE83_Deep_sl) \
       [list {CYCLE83 ( , ) 0 {}} \
        {{{$mom_cycle_retract_to_pos($mom_cycle_spindle_axis)} 1 3 5 1 1 8 3} \
         {{$mom_pos($mom_cycle_spindle_axis)} 1 3 5 1 1 8 3} \
         {{$mom_cycle_clearance_plane} 1 3 5 1 1 8 3} \
         {{$mom_cycle_feed_to_pos($mom_cycle_spindle_axis)} 1 3 5 1 1 8 3} \
         {} \
         {} \
         {{$mom_cycle_step1} 1 3 5 1 1 8 3} \
         {{$mom_cycle_step2} 1 3 5 1 1 8 3} \
         {{$mom_siemens_cycle_dtb} 1 3 5 1 1 8 3} \
         {{$mom_siemens_cycle_dts} 1 3 5 1 1 8 3} \
         {{$mom_siemens_cycle_frf} 1 3 5 1 1 8 3} \
         {1 0} \
         {{$mom_siemens_cycle_o_axn} 1 0 1 0 0 1} \
         {{$mom_cycle_step3} 1 3 5 1 1 8 3} \
         {} \
         {} \
         {} \
         {{$mom_siemens_cycle_gmode} 1 0 1 0 0 1} \
         {{$mom_siemens_cycle_dmode} 1 0 2 0 0 2} \
         {{$mom_siemens_cycle_amode} 1 0 2 0 0 2}}]

   set mom_pb_macro_arr(CYCLE83_Break_Chip_sl) \
       [list {CYCLE83 ( , ) 0 {}} \
        {{{$mom_cycle_retract_to_pos($mom_cycle_spindle_axis)} 1 3 5 1 1 8 3} \
         {{$mom_pos($mom_cycle_spindle_axis)} 1 3 5 1 1 8 3} \
         {{$mom_cycle_clearance_plane} 1 3 5 1 1 8 3} \
         {{$mom_cycle_feed_to_pos($mom_cycle_spindle_axis)} 1 3 5 1 1 8 3} \
         {} \
         {} \
         {{$mom_siemens_cycle_fdpr} 1 3 5 1 1 8 3} \
         {{$mom_siemens_cycle_dam} 1 3 5 1 1 8 3} \
         {{$mom_siemens_cycle_dtb} 1 3 5 1 1 8 3} \
         {} \
         {{$mom_siemens_cycle_frf} 1 3 5 1 1 8 3} \
         {0 0} \
         {{$mom_siemens_cycle_o_axn} 1 0 1 0 0 1} \
         {{$mom_cycle_step3} 1 3 5 1 1 8 3} \
         {} \
         {} \
         {} \
         {{$mom_siemens_cycle_gmode} 1 0 1 0 0 1} \
         {{$mom_siemens_cycle_dmode} 1 0 2 0 0 2} \
         {{$mom_siemens_cycle_amode} 1 0 2 0 0 2}}]

   set mom_pb_macro_arr(CYCLE84_sl) \
       [list {CYCLE84 ( , ) 0 {}} \
        {{{$mom_cycle_retract_to_pos($mom_cycle_spindle_axis)} 1 3 5 1 1 8 3} \
         {{$mom_pos($mom_cycle_spindle_axis)} 1 3 5 1 1 8 3} \
         {{$mom_cycle_clearance_plane} 1 3 5 1 1 8 3} \
         {{$mom_cycle_feed_to_pos($mom_cycle_spindle_axis)} 1 3 5 1 1 8 3} \
         {} \
         {{$mom_cycle_delay} 1 3 5 1 1 8 3} \
         {{$mom_siemens_cycle_sdac} 1 0 1 0 0 1} \
         {{$mom_siemens_cycle_mpit} 1 0 2 0 0 2} \
         {{$mom_siemens_cycle_pit} 1 3 5 1 1 8 3} \
         {{$mom_cycle_orient} 1 3 5 1 1 8 3} \
         {{$mom_spindle_speed} 1 2 7 1 1 9 2} \
         {{$mom_siemens_cycle_sst1} 1 2 7 1 1 9 2} \
         {{$mom_siemens_cycle_o_axn} 1 0 1 0 0 1} \
         {} \
         {} \
         {} \
         {} \
         {} \
         {} \
         {} \
         {} \
         {} \
         {{$mom_siemens_cycle_dmode} 1 0 2 0 0 2} \
         {{$mom_siemens_cycle_amode} 1 0 2 0 0 2}}]

   set mom_pb_macro_arr(CYCLE840_sl) \
       [list {CYCLE840 ( , ) 0 {}} \
        {{{$mom_cycle_retract_to_pos($mom_cycle_spindle_axis)} 1 3 5 1 1 8 3} \
         {{$mom_pos($mom_cycle_spindle_axis)} 1 3 5 1 1 8 3} \
         {{$mom_cycle_clearance_plane} 1 3 5 1 1 8 3} \
         {{$mom_cycle_feed_to_pos($mom_cycle_spindle_axis)} 1 3 5 1 1 8 3} \
         {} \
         {{$mom_cycle_delay} 1 3 5 1 1 8 3} \
         {{$mom_siemens_cycle_sdr} 1 0 1 0 0 1} \
         {{$mom_siemens_cycle_sdac} 1 0 1 0 0 1} \
         {{$mom_siemens_cycle_enc} 1 0 2 0 0 2} \
         {{$mom_siemens_cycle_mpit} 1 0 2 0 0 2} \
         {{$mom_siemens_cycle_pit} 1 3 5 1 1 8 3} \
         {{$mom_siemens_cycle_o_axn} 1 0 1 0 0 1} \
         {{$mom_siemens_cycle_o_ptab} 1 0 1 0 0 1} \
         {{$mom_siemens_cycle_o_techno} 1 0 2 0 0 2} \
         {} \
         {} \
         {} \
         {} \
         {{$mom_siemens_cycle_dmode} 1 0 2 0 0 2} \
         {{$mom_siemens_cycle_amode} 1 0 2 0 0 2}}]

   set mom_pb_macro_arr(CYCLE85_Bore_sl) \
       [list {CYCLE85 ( , ) 0 {}} \
        {{{$mom_cycle_retract_to_pos($mom_cycle_spindle_axis)} 1 3 5 1 1 8 3} \
         {{$mom_pos($mom_cycle_spindle_axis)} 1 3 5 1 1 8 3} \
         {{$mom_cycle_clearance_plane} 1 3 5 1 1 8 3} \
         {{$mom_cycle_feed_to_pos($mom_cycle_spindle_axis)} 1 3 5 1 1 8 3} \
         {} \
         {} \
         {{$feed} 1 2 7 1 1 9 2} \
         {{$mom_siemens_cycle_rff} 1 2 7 1 1 9 2} \
         {} \
         {{$mom_siemens_cycle_dmode} 1 0 2 0 0 2} \
         {{$mom_siemens_cycle_amode} 1 0 2 0 0 2}}]

   set mom_pb_macro_arr(CYCLE85_Bore_Dwell_sl) \
       [list {CYCLE85 ( , ) 0 {}} \
        {{{$mom_cycle_retract_to_pos($mom_cycle_spindle_axis)} 1 3 5 1 1 8 3} \
         {{$mom_pos($mom_cycle_spindle_axis)} 1 3 5 1 1 8 3} \
         {{$mom_cycle_clearance_plane} 1 3 5 1 1 8 3} \
         {{$mom_cycle_feed_to_pos($mom_cycle_spindle_axis)} 1 3 5 1 1 8 3} \
         {} \
         {{$mom_siemens_cycle_dtb} 1 3 5 1 1 8 3} \
         {{$feed} 1 2 7 1 1 9 2} \
         {{$mom_siemens_cycle_rff} 1 2 7 1 1 9 2} \
         {} \
         {{$mom_siemens_cycle_dmode} 1 0 2 0 0 2} \
         {{$mom_siemens_cycle_amode} 1 0 2 0 0 2}}]

   set mom_pb_macro_arr(CYCLE95) \
       [list {CYCLE95 ( , ) 0 {}} \
        {{{\"$mom_siemens_cycle_subroutine_name\"} 0} \
         {{$mom_siemens_cycle_mid} 1 3 5 1 1 8 3} \
         {{$mom_face_stock} 1 3 5 1 1 8 3} \
         {{$mom_radial_stock} 1 3 5 1 1 8 3} \
         {{$mom_stock_part} 1 3 5 1 1 8 3} \
         {{$mom_feed_cut_value} 1 3 5 1 1 8 3} \
         {{$mom_feed_stepover_value} 1 3 5 1 1 8 3} \
         {{$mom_feedrate_profile_cut} 1 3 5 1 1 8 3} \
         {{$mom_turn_cycle95_machining_type} 1 0 3 0 0 3} \
         {{$mom_local_return_dwell} 1 3 5 1 1 8 3} \
         {{$mom_siemens_cycle_dam} 1 3 5 1 1 8 3} \
         {{$mom_retract_level_part_distance} 1 4 5 1 1 9 4}}]

   set mom_pb_macro_arr(CYCLE95_sl) \
       [list {CYCLE95 ( , ) 0 {}} \
        {{{\"$mom_siemens_cycle_subroutine_name\"} 0} \
         {{$mom_siemens_cycle_mid} 1 3 5 1 1 8 3} \
         {{$mom_face_stock} 1 3 5 1 1 8 3} \
         {{$mom_radial_stock} 1 3 5 1 1 8 3} \
         {{$mom_stock_part} 1 3 5 1 1 8 3} \
         {{$mom_feed_cut_value} 1 3 5 1 1 8 3} \
         {{$mom_feed_stepover_value} 1 3 5 1 1 8 3} \
         {{$mom_feedrate_profile_cut} 1 3 5 1 1 8 3} \
         {{$mom_turn_cycle95_machining_type} 1 0 3 0 0 3} \
         {{$mom_local_return_dwell} 1 3 5 1 1 8 3} \
         {{$mom_siemens_cycle_dam} 1 3 5 1 1 8 3} \
         {{$mom_retract_level_part_distance} 1 4 5 1 1 9 4} \
         {0 1 0 1 0 0 1} \
         {0 1 0 1 0 0 1}}]
}


#=============================================================
proc PB_call_macro { macro_name { prefix "" } { suppress_seqno 0 } args } {
#=============================================================
   global mom_pb_macro_arr mom_warning_info
   if { ![info exists mom_pb_macro_arr($macro_name)] } {
      CATCH_WARNING "Macro $macro_name is not defined."
      return
   }

   set macro_attr_list $mom_pb_macro_arr($macro_name)

   set com_attr_list  [lindex $macro_attr_list 0]
   set disp_name      [lindex $com_attr_list 0]
   set start_char     [lindex $com_attr_list 1]
   set separator_char [lindex $com_attr_list 2]
   set end_char       [lindex $com_attr_list 3]
   set link_flag      [lindex $com_attr_list 4]
   set link_char      [lindex $com_attr_list 5]

   set param_list     [lindex $macro_attr_list 1]

   set text_string ""
   if { [string compare $prefix ""] != 0 } {
       append text_string $prefix " "
   }

   append text_string $disp_name $start_char

   set g_vars_list [list]
   set param_text_list [list]
   set last_index 0
   set count 0
   foreach param_attr $param_list {
      incr count
      if { [llength $param_attr] > 0 } {
         set exp [lindex $param_attr 0]
         if { $exp == "" } {
            lappend param_text_list ""
            continue
         }

         set dtype [lindex $param_attr 1]
         if { $dtype } {
            set temp_cmd "set data_val \[expr \$exp\]"
         } else {
            set temp_cmd "set data_string $exp"
         }

         set break_flag 0
         while { 1 } {
            if { [catch {eval $temp_cmd} res_val] } {
               if [string match "*no such variable*" $res_val] {
                  set __idx [string first ":" $res_val]
                  if { $__idx >= 0 } {
                     set temp_res [string range $res_val 0 [expr int($__idx - 1)]]
                     set temp_var [lindex $temp_res end]
                     set temp_var [string trim $temp_var "\""]
                     if { [string index $temp_var [expr [string length $temp_var] - 1]] == ")" } {
                        set __idx [string first "(" $temp_var]
                        set temp_var [string range $temp_var 0 [expr int($__idx - 1)]]
                     }

                     foreach one $g_vars_list {
                        if { [string compare $temp_var $one] == 0 } {
                           set break_flag 1
                        }
                     }
                     lappend g_vars_list $temp_var
                     global $temp_var
                  } else {
                     set break_flag 1
                  }
               } elseif [string match "*no such element*" $res_val] {
                  set break_flag 1
               } else {
                  CATCH_WARNING "Error to evaluate expression $exp in $macro_name: $res_val"
                  return
               }
            } else {
               break
            }

            if $break_flag {
               CATCH_WARNING "Error to evaluate expression $exp in $macro_name: $res_val"
               set data_string ""
               break
            }
         }

         if { !$break_flag && $dtype } {
            set is_double [lindex $param_attr 2]
            set int_width [lindex $param_attr 3]
            set is_decimal [lindex $param_attr 4]

            set max_val "1"
            set min_val "-1"
            set zero_char [string range "000000000" 0 [expr $int_width - 1]]
            append max_val $zero_char
            append min_val $zero_char

            if { [catch { expr $data_val >= $max_val } comp_res] } {
               set data_string ""
               CATCH_WARNING "Wrong data type to evaluate expression $exp in $macro_name: $comp_res"
            } elseif { $comp_res } {
               set data_string [expr $max_val - 1]
               CATCH_WARNING "MAX/MIN WARNING to evaluate expression $exp in $macro_name: MAX: $data_string"
            } elseif { [expr $data_val <= $min_val] } {
               set data_string [expr $min_val + 1]
               CATCH_WARNING "MAX/MIN WARNING to evaluate expression $exp in $macro_name: MIN: $data_string"
            } else {
               if { $is_double } {
                  set total_width [expr $int_width + $is_double]
                  catch { set data_string [format "%${total_width}.${is_double}f" $data_val] }
                  set data_string [string trimleft $data_string]
                  set data_string [string trimright $data_string 0]
                  if { !$is_decimal } {
                     set dec_index [string first . $data_string]
                     set dec_str [string range $data_string 0 [expr $dec_index - 1]]
                     append dec_str [string range $data_string [expr $dec_index + 1] end]
                     set data_string $dec_str
                  }
               } else {
                  set int_data [expr { int($data_val) }]
                  catch { set data_string [format "%${int_width}d" $int_data] }
                  set data_string [string trimleft $data_string]
                  if { $is_decimal } {
                     append data_string "."
                  }
               }
            }
         }

         if { $link_flag } {
            set temp_str ""
            append temp_str [lindex $param_attr end] $link_char $data_string
            set data_string $temp_str
         }
         lappend param_text_list $data_string

         if ![string match "" $data_string] {
            set last_index $count
         }
      } else {
         lappend param_text_list ""
      }
   }

   if { $last_index > 0 } {
      if { $last_index < $count } {
         set param_text_list [lreplace $param_text_list $last_index end]
      }
      append text_string [join $param_text_list $separator_char]
   }

   append text_string $end_char

   if { $suppress_seqno } {
      MOM_suppress once N
      MOM_output_literal $text_string
   } else {
      MOM_output_literal $text_string
   }
}


#=============================================================
proc PB_load_alternate_unit_settings { } {
#=============================================================
   global mom_output_unit mom_kin_output_unit

  # Skip this function when output unit agrees with post unit.
   if { ![string compare $mom_output_unit $mom_kin_output_unit] } {
return
   }


   global mom_event_handler_file_name

  # Set unit conversion factor
   if { ![string compare $mom_output_unit "MM"] } {
      set factor 25.4
   } else {
      set factor [expr 1/25.4]
   }

  # Define unit dependent variables list
   set unit_depen_var_list [list mom_kin_x_axis_limit mom_kin_y_axis_limit mom_kin_z_axis_limit \
                                 mom_kin_ind_to_dependent_head_x \
                                 mom_kin_ind_to_dependent_head_z]

   set unit_depen_arr_list [list mom_sys_home_pos]

  # Load unit dependent variables
   foreach var $unit_depen_var_list {
      if { ![info exists $var] } {
         global $var
      }
      if { [info exists $var] } {
         set $var [expr [set $var] * $factor]
         MOM_reload_variable $var
      }
   }

   foreach var $unit_depen_arr_list {
      if { ![info exists $var] } {
         global $var
      }
      foreach item [array names $var] {
         if { [info exists ${var}($item)] } {
            set ${var}($item) [expr [set ${var}($item)] * $factor]
         }
      }

      MOM_reload_variable -a $var
   }


  # Source alternate unit post fragment
   uplevel #0 {
      global mom_sys_alt_unit_post_name
      set alter_unit_post_name \
          "[file join [file dirname $mom_event_handler_file_name] [file rootname $mom_sys_alt_unit_post_name]].tcl"

      if { [file exists $alter_unit_post_name] } {
         source "$alter_unit_post_name"
      }
      unset alter_unit_post_name
   }

   if { [llength [info commands PB_load_address_redefinition]] > 0 } {
      PB_load_address_redefinition
   }

   MOM_reload_kinematics
}


if [info exists mom_sys_start_of_program_flag] {
   if [llength [info commands PB_CMD_kin_start_of_program] ] {
      PB_CMD_kin_start_of_program
   }
} else {
   set mom_sys_head_change_init_program 1
   set mom_sys_start_of_program_flag 1
}


