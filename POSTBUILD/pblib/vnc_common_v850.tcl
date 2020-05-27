########################### Virtual NC Controller ############################
#                                                                            #
# Copyright (C) 1999/2000/2001/2002/2003/2004/2005/2006/2007/2008/2009/2010/ #
#               2011                                                         #
#                                                                            #
#                           Siemens PLM Software                             #
#                                                                            #
##############################################################################
#                       V N C _ C O M M O N _ V 8 5 0 . T C L
##############################################################################
#
# DESCRIPTION
#
#   This file contains handlers for incremental VNC conversion.
#
##############################################################################


#=============================================================
proc PB_CMD_vnc__pass_csys_data { } {
#=============================================================
# This function is only executed in an in-process ISV
# to pass csys definitions.
#

# pb800(c) - Restored this command from pb700


  global mom_sim_control_out mom_sim_control_in
  global mom_sim_vnc_msg_prefix
  global mom_csys_matrix

  global mom_coordinate_system_purpose
  global mom_special_output
  global mom_kin_coordinate_system_type
  global mom_machine_csys_matrix
  global mom_sim_message


   if { [info exists mom_machine_csys_matrix] } {

      global mom_main_mcs
      global mom_coordinate_system_purpose

      global mom_sim_main_mcs
      global mom_sim_machine_type


     # Grab main MCS
      MTX3_transpose mom_machine_csys_matrix mainMCS

       set mainMCS(9)  $mom_machine_csys_matrix(9)
       set mainMCS(10) $mom_machine_csys_matrix(10)
       set mainMCS(11) $mom_machine_csys_matrix(11)


#VNC_info "Main MCS : $mom_main_mcs"
#VNC_info "mainMCS 1 : [VNC_sort_array_vals mainMCS]"

     #==========================================================
     # CSYS Purpose  (mom_coordinate_system_purpose)
     # ------------
     #                      1 : Main
     #                      0 : Local
     #
     # Special Output  (mom_special_output)
     # --------------
     #                      0 : None
     #                      1 : Use Main MCS
     #                      2 : Fixture Offset
     #                      3 : CSYS Rotation
     #
     # Coordinate System Type  (mom_kin_coordinate_system_type)
     # ----------------------
     #          When CSYS Purpose = 1 (Main)
     #                      LOCAL
     #
     #          When CSYS Purpose = 0 (Local)
     #                      MAIN  : Special Output = 1 (Use Main MCS)
     #                      LOCAL : Special Output = 0 (None), 2 (Fixture Offset)
     #                      CSYS  : Special Output = 3 (CSYS Rotation)
     #==========================================================

      set coordinate_system_mode  $mom_kin_coordinate_system_type


if 0 {
 VNC_info "mainMCS 2      : [VNC_sort_array_vals mainMCS]"
 VNC_info "  machine csys : [VNC_sort_array_vals mom_machine_csys_matrix]"
 VNC_info "  csys matrix  : [VNC_sort_array_vals mom_csys_matrix]"
 VNC_info "CSYS Purpose : $mom_coordinate_system_purpose \nSpecial Output : $mom_special_output\
           \nCoordinate System Type : $mom_kin_coordinate_system_type"
 VNC_info "Coordinate system mode : $coordinate_system_mode"
}


     # 850(f) - Ensure var being defined
      global mom_fixture_offset_value
      if { ![info exists mom_fixture_offset_value] } {
         set mom_fixture_offset_value 0
      }


     # Extract offsets between a local and the mainMCS
     #
      if { [string compare $coordinate_system_mode "MAIN"] } {

         global mom_sim_nc_register mom_sim_wcs_offsets

        # Fetch fixture offset # specified with the CSYS object
         if { $mom_fixture_offset_value > 0 } {

            set mom_sim_nc_register(WCS) $mom_fixture_offset_value


           # Set linear offsets
            set mom_sim_wcs_offsets($mom_fixture_offset_value)\
                [list $mom_csys_matrix(9) $mom_csys_matrix(10) $mom_csys_matrix(11) 0.0 0.0 0.0]

           # Find angular offsets per axis of rotation
            global mom_sim_machine_type
            global mom_sim_4th_axis_plane mom_sim_5th_axis_plane

            if { ![string match "*wedm"  $mom_sim_machine_type] &&\
                 ![string match "*lathe" $mom_sim_machine_type] &&\
                 ![string match "*punch" $mom_sim_machine_type] } {

               for { set i 0 } { $i < 9 } { incr i } {
                 set csys($i) $mom_csys_matrix($i)
               }

               set fourth_ang 0.0
               set fifth_ang  0.0

               set 4th_index 0
               set 5th_index 0

               if { [string match "4*" $mom_sim_machine_type] } {
                  switch $mom_sim_4th_axis_plane {
                     "XY" {
                        set fourth_ang [rad2deg [expr atan2($csys(1),$csys(0))]]
                        set 4th_index 5
                     }
                     "YZ" {
                        set fourth_ang [rad2deg [expr atan2(-1*$csys(7),$csys(8))]]
                        set 4th_index 3
                     }
                     "ZX" {
                        set fourth_ang [rad2deg [expr atan2($csys(6),$csys(8))]]
                        set 4th_index 4
                     }
                  }
                  if { [string match "*head*" $mom_sim_machine_type] } {
                     set fourth_ang [expr -1 * $fourth_ang]
                  }
               }

               if { [string match "5*" $mom_sim_machine_type] } {
                  switch $mom_sim_4th_axis_plane {
                     "XY" {
                        set 4th_index 5
                        switch $mom_sim_5th_axis_plane {
                           "YZ" {
                             # C/A
                              # Rotate Y' to XY plane for A
                               set fifth_ang  [rad2deg [expr atan2($csys(5),$csys(4))]]
                               set d [expr sqrt( $csys(5)*$csys(5) + $csys(4)*$csys(4) )]

                              # Rotate Y' to Y on XY plane for C
                               set fourth_ang  [rad2deg [expr -1*atan2($csys(3),$d)]]

                               set 5th_index 3
                           }
                           "ZX" {
                             # C/B
                              # Rotate X' to XY plane for B
                               set fifth_ang  [rad2deg [expr -1*atan2($csys(2),$csys(0))]]
                               set d [expr sqrt( $csys(2)*$csys(2) + $csys(0)*$csys(0) )]

                              # Rotate X' to X on ZX plane for C
                               set fourth_ang  [rad2deg [expr atan2($csys(1),$d)]]

                               set 5th_index 4
                           }
                        }
                     }
                     "YZ" {
                        set 4th_index 3
                        switch $mom_sim_5th_axis_plane {
                           "XY" {
                             # A/C
                              # Rotate Z' to YZ plane for C (measured on XY plane)
                               set fifth_ang [rad2deg [expr -1*atan2($csys(6),$csys(7))]]
                               set d [expr sqrt( $csys(7)*$csys(7) + $csys(6)*$csys(6) )]

                              # Rotate Z' to Z on ZX plane for A
                               set fourth_ang [rad2deg [expr -1*atan2($d,$csys(8))]]

                               set 5th_index 5
                           }
                           "ZX" {
                             # A/B
                              # Rotate Z' to YZ plane for B (measured on XZ plane)
                               set fifth_ang  [rad2deg [expr atan2($csys(6),$csys(8))]]
                               set d [expr sqrt( $csys(6)*$csys(6) + $csys(8)*$csys(8) )]

                              # Rotate Z' to Z on ZX plane for B
                               set fourth_ang [rad2deg [expr -1*atan2($csys(7),$d)]]

                               set 5th_index 4
                           }
                        }
                     }
                     "ZX" {
                        set 4th_index 4
                        switch $mom_sim_5th_axis_plane {
                           "XY" {
                             # B/C
                              # Rotate Z' to ZX plane for C (measured on XY plane)
                               set fifth_ang [rad2deg [expr atan2($csys(7),$csys(6))]]

                              # Rotate Z' to Z on YZ plane for B
                               set d [expr sqrt( $csys(7)*$csys(7) + $csys(6)*$csys(6) )]
                               set fourth_ang [rad2deg [expr atan2($d,$csys(8))]]

                               set 5th_index 5
                           }
                           "YZ" {
                             # B/A
                              # Rotate Z' to ZX plane for A (measured on YZ plane)
                               set fifth_ang  [rad2deg [expr -1*atan2($csys(7),$csys(8))]]
                               set d [expr sqrt( $csys(7)*$csys(7) + $csys(8)*$csys(8) )]

                              # Rotate Z' to Z on YZ plane for B
                               set fourth_ang [rad2deg [expr atan2($csys(6),$d)]]

                               set 5th_index 3
                           }
                        }
                     }
                  }

                 # Negate angles for heads
                  if { [string match "*dual_head*" $mom_sim_machine_type] } {
                     set fourth_ang [expr -1 * $fourth_ang]
                     set fifth_ang  [expr -1 * $fifth_ang]
                  }
                  if { [string match "*head_table*" $mom_sim_machine_type] } {
                     set fourth_ang [expr -1 * $fourth_ang]
                  }
               }

              # Update fixture offset with angular offsets
               if { $4th_index > 0 } {
                  set mom_sim_wcs_offsets($mom_fixture_offset_value)\
                      [lreplace $mom_sim_wcs_offsets($mom_fixture_offset_value) $4th_index $4th_index $fourth_ang]
               }
               if { $5th_index > 0 } {
                  set mom_sim_wcs_offsets($mom_fixture_offset_value)\
                      [lreplace $mom_sim_wcs_offsets($mom_fixture_offset_value) $5th_index $5th_index $fifth_ang]
               }
            }


           # Rotate WCS offsets for MCSX lathe work plane
            if { [string match "*lathe" $mom_sim_machine_type] } {

               global mom_lathe_spindle_axis

               if { [info exists mom_lathe_spindle_axis] && [string match "MCSX" $mom_lathe_spindle_axis] } {

                  set x_off [lindex $mom_sim_wcs_offsets($mom_fixture_offset_value) 1]
                  set y_off [lindex $mom_sim_wcs_offsets($mom_fixture_offset_value) 2]
                  set z_off [lindex $mom_sim_wcs_offsets($mom_fixture_offset_value) 0]
                  set a_off [lindex $mom_sim_wcs_offsets($mom_fixture_offset_value) 3]
                  set b_off [lindex $mom_sim_wcs_offsets($mom_fixture_offset_value) 4]
                  set c_off [lindex $mom_sim_wcs_offsets($mom_fixture_offset_value) 5]

                  set mom_sim_wcs_offsets($mom_fixture_offset_value) [list $x_off $y_off $z_off $a_off $b_off $c_off]
               }
            }

         } ;# fixture_offset > 0

      } ;# LOCAL


      if { [string match "MAIN" $coordinate_system_mode] } {

        # Origin UDE specifies the offsets from a main MCS to the desired reference CSYS for output.
        # This UDE will not be known or involved in standalone NC files.
         global mom_origin

         for { set i 9 } { $i < 12 } { incr i } {
            if { [info exists mom_origin] } {
               set mainMCS($i) [expr $mainMCS($i) + $mom_origin([expr $i - 9])]
            }
         }

      } else {

         MTX3_multiply mainMCS mom_csys_matrix matrix

         set u(0) $mom_csys_matrix(9)
         set u(1) $mom_csys_matrix(10)
         set u(2) $mom_csys_matrix(11)

         MTX3_vec_multiply u mom_machine_csys_matrix w

         set matrix(9)  [expr $mainMCS(9)  + $w(0)]
         set matrix(10) [expr $mainMCS(10) + $w(1)]
         set matrix(11) [expr $mainMCS(11) + $w(2)]


        # To be passed as VNC param msgs
         array set local_mainMCS [array get mainMCS]
         array set mainMCS [array get matrix]
      }


     # Rotate main CSYS matrix for lathe MCSX work plane
      if { [string match "*lathe" $mom_sim_machine_type] } {

         global mom_lathe_spindle_axis

         if { [info exists mom_lathe_spindle_axis] && [string match "MCSX" $mom_lathe_spindle_axis] } {
            MTX3_x mainMCS x
            MTX3_y mainMCS y
            MTX3_z mainMCS z

            set mainMCS(0) $y(0)
            set mainMCS(1) $y(1)
            set mainMCS(2) $y(2)

            set mainMCS(3) $z(0)
            set mainMCS(4) $z(1)
            set mainMCS(5) $z(2)

            set mainMCS(6) $x(0)
            set mainMCS(7) $x(1)
            set mainMCS(8) $x(2)
         }
      }


     # Output WCS number
     #
      set fixture_offset $mom_fixture_offset_value

      set mom_sim_message "CSYS_FIXTURE_OFFSET==$fixture_offset"
      PB_SIM_call PB_CMD_vnc__output_vnc_msg


#VNC_info "mainMCS passed : [VNC_sort_array_vals mainMCS]"
     #---------------------
     # Pass MCS definition
     #---------------------
      for { set i 0 } { $i < 12 } { incr i } {
         set mom_sim_message "CSYS_MTX_$i==$mainMCS($i)"
         PB_SIM_call PB_CMD_vnc__output_vnc_msg
      }


     # Retain a copy of main, local & the currently active csys matrix
      global mom_sim_main_csys_matrix
      global mom_sim_local_csys_matrix
      global mom_sim_csys_matrix

      if { [string match "MAIN" $coordinate_system_mode] } {
         array set mom_sim_main_csys_matrix  [array get mainMCS]
      } else {
         array set mom_sim_main_csys_matrix  [array get local_mainMCS]
         array set mom_sim_local_csys_matrix [array get matrix]
      }

#VNC_info "Final coordinate system mode : $coordinate_system_mode"
#VNC_info "       csys : [VNC_sort_array_vals mom_sim_csys_matrix]"
#VNC_info " local csys : [VNC_sort_array_vals mom_sim_local_csys_matrix]"
#VNC_info " main  csys : [VNC_sort_array_vals mom_sim_main_csys_matrix]"
   }
}


#=============================================================
proc PB_CMD_vnc__pass_tool_data { } {
#=============================================================
  global mom_tool_name
  global mom_tool_type
  global mom_tool_offset_defined mom_tool_offset
  global mom_sim_message


   if { ![info exists mom_tool_offset_defined] } {
      set mom_tool_offset_defined 0
   }
   if { ![info exists mom_tool_offset(0)] } { set mom_tool_offset(0) 0 }
   if { ![info exists mom_tool_offset(1)] } { set mom_tool_offset(1) 0 }
   if { ![info exists mom_tool_offset(2)] } { set mom_tool_offset(2) 0 }

   global mom_tool_number
   if { ![info exists mom_tool_number] } {
return
   }
   set mom_sim_message "TOOL_NUMBER==$mom_tool_number"
   PB_SIM_call PB_CMD_vnc__output_vnc_msg

   set mom_sim_message "TOOL_NAME==$mom_tool_name"
   PB_SIM_call PB_CMD_vnc__output_vnc_msg

  # 850(g) - Tool type may not exist
   if { [info exists mom_tool_type] } {
      set mom_sim_message "TOOL_TYPE==$mom_tool_type"
      PB_SIM_call PB_CMD_vnc__output_vnc_msg
   }

   set mom_sim_message "TOOL_OFFSET==$mom_tool_offset_defined"
   PB_SIM_call PB_CMD_vnc__output_vnc_msg

   set mom_sim_message "TOOL_X_OFF==$mom_tool_offset(0)"
   PB_SIM_call PB_CMD_vnc__output_vnc_msg

   set mom_sim_message "TOOL_Y_OFF==$mom_tool_offset(1)"
   PB_SIM_call PB_CMD_vnc__output_vnc_msg

   set mom_sim_message "TOOL_Z_OFF==$mom_tool_offset(2)"
   PB_SIM_call PB_CMD_vnc__output_vnc_msg


   global mom_tool_diameter mom_tool_adjust_register mom_tool_cutcom_register

   if { [info exists mom_tool_diameter] } {
      set mom_sim_message "TOOL_DIAMETER==$mom_tool_diameter"
      PB_SIM_call PB_CMD_vnc__output_vnc_msg
   }
   if { [info exists mom_tool_cutcom_register] } {
      set mom_sim_message "TOOL_CUTCOM_REG==$mom_tool_cutcom_register"
      PB_SIM_call PB_CMD_vnc__output_vnc_msg
   }
   if { [info exists mom_tool_adjust_register] } {
      set mom_sim_message "TOOL_ADJUST_REG==$mom_tool_adjust_register"
      PB_SIM_call PB_CMD_vnc__output_vnc_msg
   }

   global mom_pocket_id
   if { [info exists mom_pocket_id] } {
      set mom_sim_message "TOOL_POCKET_ID==$mom_pocket_id"
      PB_SIM_call PB_CMD_vnc__output_vnc_msg
   }


  # pb601(g) -
  if 0 {
  # pb502(7) -
  # Fetch info from devices (tool blocks on turret)
   global mom_sim_result mom_sim_result1

   if { ![catch { SIM_ask_base_device_holder_of_comp $mom_tool_name }] } {
      set mom_sim_message "TOOL_POCKET_ID==$mom_sim_result1"
      PB_SIM_call PB_CMD_vnc__output_vnc_msg
   }

   if { ![catch { SIM_ask_base_device_of_comp $mom_tool_name }] } {
     # Only allow numeric carrier ID
      if [catch {expr $mom_sim_result1 - 1} ] {
return
      }

      set mom_sim_message "TOOL_CARRIER_ID==$mom_sim_result1"
      PB_SIM_call PB_CMD_vnc__output_vnc_msg

      global mom_sim_spindle_group
      if { [info exists mom_sim_spindle_group] } {
         PB_SIM_call SIM_assign_channel_to_spindle $mom_sim_result1 $mom_sim_spindle_group
      }

      PB_SIM_call PB_CMD_vnc__set_speed
   }
  }
}


#=============================================================
proc PB_CMD_vnc__rapid_segment { } {
#=============================================================
# This function is the old PB_CMD_vnc__rapid_move
#
  global mom_sim_lg_axis
  global mom_sim_nc_register
  global mom_sim_num_machine_axes

  global mom_sim_pos mom_sim_prev_pos

  global mom_sim_4th_axis_has_limits mom_sim_5th_axis_has_limits
  global mom_sim_result


  # pb750(g)
   PB_SIM_call SIM_set_linearization OFF

   set coord_list [list]
   set pattern 0

   if { [expr $mom_sim_pos(0) != $mom_sim_prev_pos(0)] } {
      lappend coord_list $mom_sim_lg_axis(X)  $mom_sim_pos(0)
      set pattern [expr $pattern + 10000]
   }
   if { [expr $mom_sim_pos(1) != $mom_sim_prev_pos(1)] } {
      lappend coord_list $mom_sim_lg_axis(Y)  $mom_sim_pos(1)
      set pattern [expr $pattern + 1000]
   }
   if { [expr $mom_sim_pos(2) != $mom_sim_prev_pos(2)] } {
      lappend coord_list $mom_sim_lg_axis(Z)  $mom_sim_pos(2)
      set pattern [expr $pattern + 100]
   }
   if { [info exists mom_sim_lg_axis(4)] } {
      if { [expr $mom_sim_pos(3) != $mom_sim_prev_pos(3)] } {

        # pb850(i) - Reduce rotation for limitless 4th rotary axis
         if { !$mom_sim_4th_axis_has_limits } {
            PB_SIM_call SIM_set_axis_rotary_dir_mode $mom_sim_lg_axis(4) "ALWAYS_SHORTEST"
            if { [expr ($mom_sim_pos(3) - $mom_sim_prev_pos(3)) > 180] } {
               set mom_sim_pos(3) [expr $mom_sim_pos(3) - 360]
            } elseif { [expr ($mom_sim_pos(3) - $mom_sim_prev_pos(3)) < -180] } {
               set mom_sim_pos(3) [expr $mom_sim_pos(3) + 360]
            }
         }

         lappend coord_list $mom_sim_lg_axis(4)  $mom_sim_pos(3)
         set pattern [expr $pattern + 10]
      }
   }
   if { [info exists mom_sim_lg_axis(5)] } {
      if { [expr $mom_sim_pos(4) != $mom_sim_prev_pos(4)] } {

        # pb850(i) - Reduce rotation for limitless 5th rotary axis
         if { !$mom_sim_5th_axis_has_limits } {
            PB_SIM_call SIM_set_axis_rotary_dir_mode $mom_sim_lg_axis(5) "ALWAYS_SHORTEST"
            if { [expr ($mom_sim_pos(4) - $mom_sim_prev_pos(4)) > 180] } {
               set mom_sim_pos(4) [expr $mom_sim_pos(4) - 360]
            } elseif { [expr ($mom_sim_pos(3) - $mom_sim_prev_pos(3)) < -180] } {
               set mom_sim_pos(4) [expr $mom_sim_pos(4) + 360]
            }
         }

         lappend coord_list $mom_sim_lg_axis(5)  $mom_sim_pos(4)
         set pattern [expr $pattern + 1]
      }
   }


   global mom_sim_mt_axis
   global mom_sim_max_dpm

   if { ![info exists mom_sim_max_dpm] || ![EQ_is_gt $mom_sim_max_dpm 0.0] } {
      set mom_sim_max_dpm 10000
   }


   switch $pattern {
      1 {
        # Pure 5th axis rotation -
         PB_SIM_call VNC_move_machine_rotary_axis $mom_sim_mt_axis(5) $mom_sim_pos(4)
      }

      10 {
        # Pure 4th axis rotation -
         PB_SIM_call VNC_move_machine_rotary_axis $mom_sim_mt_axis(4) $mom_sim_pos(3)
      }

      11 {
        # Pure compound rotation -
         PB_SIM_call VNC_move_machine_rotary_axis $mom_sim_mt_axis(4) $mom_sim_pos(3)
         PB_SIM_call VNC_move_machine_rotary_axis $mom_sim_mt_axis(5) $mom_sim_pos(4)
      }
   }


   if { [expr $pattern > 0] } {

      if { [expr $pattern > 11] } {
         eval PB_SIM_call VNC_move_linear_zcs RAPID $coord_list
      }

     # In case tool is not yet activated...
      global mom_sim_tool_loaded
      if { ![string match "" [string trim $mom_sim_tool_loaded]] } {
         PB_SIM_call SIM_activate_tool $mom_sim_tool_loaded
      }
      PB_SIM_call SIM_update

     # pb850(i) - Reset state for limitless 4th rotary axis
      if { [info exists mom_sim_lg_axis(4)] } {
         if { !$mom_sim_4th_axis_has_limits } {

            global mom_sim_4th_axis_direction
            if { ![string match "" [string trim $mom_sim_4th_axis_direction] ] } {
              # Reinstate rotary direction
               PB_SIM_call SIM_set_axis_rotary_dir_mode $mom_sim_lg_axis(4) $mom_sim_4th_axis_direction
            }

            PB_SIM_call SIM_set_interpolation OFF

            PB_SIM_call SIM_normalize_rotary_axis $mom_sim_mt_axis(4) NORM_180
            PB_SIM_call SIM_ask_axis_position $mom_sim_mt_axis(4)
            if { [EQ_is_zero $mom_sim_result] } {
               set mom_sim_result 0.0
            }
            set mom_sim_pos(3) $mom_sim_result
            PB_SIM_call VNC_move_machine_rotary_axis $mom_sim_mt_axis(4) $mom_sim_pos(3)
            unset mom_sim_result

            PB_SIM_call SIM_set_interpolation ON
         }
      }

     # pb850(i) - Reset state for limitless 5th rotary axis
      if { [info exists mom_sim_lg_axis(5)] } {
         if { !$mom_sim_5th_axis_has_limits } {

            global mom_sim_5th_axis_direction
            if { ![string match "" [string trim $mom_sim_5th_axis_direction] ] } {
              # Reinstate rotary direction
               PB_SIM_call SIM_set_axis_rotary_dir_mode $mom_sim_lg_axis(5) $mom_sim_5th_axis_direction
            }

            PB_SIM_call SIM_set_interpolation OFF

            PB_SIM_call SIM_normalize_rotary_axis $mom_sim_mt_axis(5) NORM_180
            PB_SIM_call SIM_ask_axis_position $mom_sim_mt_axis(5)
            if { [EQ_is_zero $mom_sim_result] } {
               set mom_sim_result 0.0
            }
            set mom_sim_pos(4) $mom_sim_result
            PB_SIM_call VNC_move_machine_rotary_axis $mom_sim_mt_axis(5) $mom_sim_pos(4)
            unset mom_sim_result

            PB_SIM_call SIM_set_interpolation ON
         }
      }
   }

   PB_SIM_call SIM_update

  # pb751(c) - No reference has changed, no need to update
  # PB_SIM_call VNC_update_sim_pos

   set mom_sim_nc_register(LAST_X) $mom_sim_pos(0)
   set mom_sim_nc_register(LAST_Y) $mom_sim_pos(1)
   set mom_sim_nc_register(LAST_Z) $mom_sim_pos(2)
}


#=============================================================
proc PB_CMD_vnc__set_speed { } {
#=============================================================
  global mom_sim_nc_register
  global mom_sim_spindle_speed mom_sim_spindle_mode
  global mom_sim_spindle_max_rpm
  global mom_sim_primary_channel
  global mom_sim_tool_carrier_id

  global mom_carrier_name


   set spindle_speed $mom_sim_nc_register(S)
   set spindle_mode  $mom_sim_nc_register(SPINDLE_MODE)

   if { [expr $mom_sim_nc_register(S) <= 0.0] } {
      if { [expr $mom_sim_spindle_speed > 0.0] } {
         set spindle_speed $mom_sim_spindle_speed
      } else {
        # pb750(f) - Not to fake spindle speed
        # set spindle_speed $mom_sim_spindle_max_rpm
        # set spindle_mode  "REV_PER_MIN"
      }
   }


  # Set primary channel
   set primary_channel_set 0

   if { [info exists mom_sim_primary_channel] } {

      if { [string compare $spindle_mode "REV_PER_MIN"] || ![string compare $mom_sim_nc_register(MACHINE_MODE) "TURN"] } {

         if { [info exists mom_sim_tool_carrier_id] } {
           # pb502(8) -
           # Device name string with mom_carrier_name will fail the "expr" comparison.
           # - Make sure only numeral ID is assigned to mom_sim_tool_carrier_id.
            if { ![catch {expr $mom_sim_tool_carrier_id != $mom_carrier_name} ] } {
               set mom_sim_tool_carrier_id $mom_carrier_name
            }

            if { $mom_sim_primary_channel == $mom_sim_tool_carrier_id } {
               PB_SIM_call SIM_primary_channel $mom_sim_primary_channel
               set primary_channel_set 1
            }
         }
      }
   }


  # Set max spindle rpm
   if { $primary_channel_set } {

      if { ![string compare $mom_sim_nc_register(MACHINE_MODE) "TURN"] } {

        # Reduce spindle speed to the max
         if { ![string compare $spindle_mode "REV_PER_MIN"] } {
            if { [EQ_is_gt $spindle_speed $mom_sim_spindle_max_rpm] } {
               set spindle_speed $mom_sim_spindle_max_rpm
            }
         }

        # Set max spindle speed
         PB_SIM_call SIM_set_max_spindle_speed $mom_sim_spindle_max_rpm "REV_PER_MIN"
      }
   }


  # pb850(h) - Error protect against 0 spindle speed (machine control oper)
   if { [EQ_is_le $spindle_speed 0.0] } {
return
   }


  # Pass on spindle data
   set mom_sim_spindle_mode  $spindle_mode
   set mom_sim_spindle_speed $spindle_speed

   if { [string match "REV_PER_MIN" $spindle_mode] } {

      switch "$mom_sim_nc_register(MACHINE_MODE)" {
         "MILL" {
            PB_SIM_call SIM_set_speed $spindle_speed $spindle_mode
         }
         "TURN" {
            if { $primary_channel_set } {
               PB_SIM_call SIM_set_spindle_speed $spindle_speed $spindle_mode
            }
         }
      }

   } else {

      if { $primary_channel_set } {
         if { [string match "SFM" $spindle_mode] } {
            PB_SIM_call SIM_set_surface_speed $spindle_speed "FEET_PER_MIN"
            set mom_sim_spindle_mode "FEET_PER_MIN"
         } else {
            PB_SIM_call SIM_set_surface_speed $spindle_speed "M_PER_MIN"
            set mom_sim_spindle_mode "M_PER_MIN"
         }
      }
   }
}


#=============================================================
proc PB_CMD_vnc__tool_change { } {
#=============================================================
  global sim_prev_tool_name
  global mom_sim_result mom_sim_result1
  global mom_sim_ug_tool_name
  global mom_sim_tool_loaded
  global mom_sim_spindle_comp mom_sim_spindle_jct
  global mom_sim_lg_axis
  global mom_sim_nc_register
  global mom_sim_machine_type
  global mom_sim_tool_offset_used mom_sim_tool_offset mom_sim_tool_mount
  global mom_sim_output_reference_method
  global mom_sim_tool_junction mom_sim_current_tool_junction mom_sim_current_junction
  global mom_sim_pivot_distance
  global mom_sim_tool_change


  global mom_sim_pos mom_sim_prev_pos


  # Fetch UG tool name per tool number
   global mom_sim_address
   global mom_sim_tool_data
   global mom_sim_tool_number

   set tool_number ""

  # pb850(j) - 
  # Preprocessor may set tool number to "0" per T code to force a tool-return
   if { [info exists mom_sim_tool_number] } {
      set tool_number $mom_sim_tool_number
   } elseif { [info exists mom_sim_nc_register($mom_sim_address(T,leader))] } {
      set tool_number $mom_sim_nc_register($mom_sim_address(T,leader))
   }

   if { [string length $tool_number] > 0  &&  [info exists mom_sim_tool_data($tool_number,name)] } {
      set mom_sim_ug_tool_name $mom_sim_tool_data($tool_number,name)
   } else {
     # pb800(i)
      set mom_sim_ug_tool_name ""
   }

  # pb800(i)
   if { ![info exists sim_prev_tool_name] } {
      set sim_prev_tool_name ""
   }

   if { [string match "$sim_prev_tool_name" $mom_sim_ug_tool_name] } {
      set mom_sim_tool_change 0
return
   }


  # Allow users to use specified tool change position.
   if { [llength [info commands "PB_CMD_vnc____go_to_tool_change_position"]] } {

      PB_SIM_call PB_CMD_vnc____go_to_tool_change_position

   } elseif { [llength [info commands "PB_CMD_vnc__go_to_tool_change_position"]] } {
     # Legacy
      PB_SIM_call PB_CMD_vnc__go_to_tool_change_position

   } else {

     # By default, turret does not return to ref pt for tool change
      global mom_sim_tool_carrier_id
      global mom_sim_turret_carriers
      global mom_sim_tool_pocket_id

      set done_position 0


      if { [info exists mom_sim_tool_carrier_id] && [info exists mom_sim_turret_carriers] } {

        # pb601(h)
         global mom_sim_comp_class
         if { [info exists mom_sim_comp_class(_CARRIER,$mom_sim_ug_tool_name)] } {

            set mom_sim_tool_carrier_id $mom_sim_comp_class(_CARRIER,$mom_sim_ug_tool_name)

            set mom_sim_tool_data($tool_number,carrier_id) "\"$mom_sim_tool_carrier_id\""

            global mom_sim_spindle_group
            if { [info exists mom_sim_spindle_group] } {
               PB_SIM_call SIM_assign_channel_to_spindle $mom_sim_tool_carrier_id $mom_sim_spindle_group
            }

            PB_SIM_call PB_CMD_vnc__set_speed
         }


        # Not sure this is always true for all machines!!!
         if { [lsearch $mom_sim_turret_carriers $mom_sim_tool_carrier_id] >= 0 } {

           # pb601(h)
            if { ![catch { SIM_ask_base_device_holder_of_comp $mom_sim_ug_tool_name }] } {
               set mom_sim_tool_pocket_id "$mom_sim_result1"
               set mom_sim_tool_data($tool_number,pocket_id) "\"$mom_sim_tool_pocket_id\""
            }

            set mom_sim_nc_register(REF_INT_PT_X) -939
            set mom_sim_nc_register(REF_INT_PT_Y) -939

            VNC_unset_vars  mom_sim_nc_register(REF_INT_PT_Z)

           # Position spindle to reference point.
            PB_SIM_call PB_CMD_vnc__send_dogs_home

           # Unset temporary intermediate reference point
            VNC_unset_vars  mom_sim_nc_register(REF_INT_PT_X) mom_sim_nc_register(REF_INT_PT_Y)

            set done_position 1
         }
      }

      if { $done_position == 0 } {
        # Fake a temporary intermediate reference point to send all dogs home
         set mom_sim_nc_register(REF_INT_PT_X) -939
         set mom_sim_nc_register(REF_INT_PT_Y) -939
         set mom_sim_nc_register(REF_INT_PT_Z) -939

        # Position spindle to reference point.
         PB_SIM_call PB_CMD_vnc__send_dogs_home

        # Unset temporary intermediate reference point
         VNC_unset_vars  mom_sim_nc_register(REF_INT_PT_X) mom_sim_nc_register(REF_INT_PT_Y) mom_sim_nc_register(REF_INT_PT_Z)
      }
   }


   set sim_tool_name ""


#>>>>>
#  This is where you add detailed movements such as rotating tool changer,
#  unmounting old tool and mounting new tool and/or getting next tool in ready position.
#<<<<<

  # User provided tool change sequence
   if { [llength [info commands "PB_CMD_vnc__user_tool_change"]] } {

      set sim_tool_name [PB_SIM_call PB_CMD_vnc__user_tool_change]

   } elseif { [llength [info commands "PB_CMD_vnc____tool_change"]] } {

      set sim_tool_name [PB_SIM_call PB_CMD_vnc____tool_change]

   } else {

      global mom_sim_tool_carrier_id
      global mom_sim_turret_carriers
      global mom_sim_turret_axis
      global mom_sim_tool_pocket_id


      set done_tool_change 0


      set mom_sim_result ""

     # Rotate turret to index lathe tool
      if { [info exists mom_sim_tool_carrier_id] &&\
           [info exists mom_sim_tool_pocket_id] &&\
           [info exists mom_sim_turret_carriers] } {

         if { [lsearch $mom_sim_turret_carriers $mom_sim_tool_carrier_id] >= 0 } {

           # Handle mixed use of tools on a turret and stationary tools.
            if { ![catch { PB_SIM_call SIM_ask_kim_comp_name_by_id "TOOL" $mom_sim_ug_tool_name }] } {
               set done_tool_change 1
            }

           # pb801(g) -
           # pb800(h) - Only handle when pocket ID is an integer
            if { ![catch { expr $mom_sim_tool_pocket_id }] } {

               if { $done_tool_change } {

                  global mom_sim_pocket_angle

                 # Handle holder angle with operation
                  set cutter_holder_angle_delta 0.0
                  set cutter_holder_angle_delta [PB_SIM_call PB_CMD_vnc__compute_tool_holder_angle_delta]

                 # Actual turret rotation angle = rot angle based on pocket ID + tool holder delta
                  global mom_sim_turret_data
                  global mom_sim_add_turret_angle

                  set pocket_id $mom_sim_tool_pocket_id

                  if { [info exists mom_sim_turret_data($mom_sim_tool_carrier_id,pockets_num)] } {
                     set pockets_num $mom_sim_turret_data($mom_sim_tool_carrier_id,pockets_num)
                     set pocket_id [expr int(fmod($pocket_id,$pockets_num))]

                     if { !$pocket_id } {
                        set pocket_id $pockets_num
                     }
                  }
                  set turret_rotation_angle [expr $cutter_holder_angle_delta +\
                                                  $mom_sim_add_turret_angle +\
                                                  $mom_sim_pocket_angle($mom_sim_tool_carrier_id,$pocket_id)]

                 # Reduce turret rotation
                  set turret_rotation_angle [expr fmod($turret_rotation_angle,360)]
                  if { [expr $turret_rotation_angle > 180] } { ;# May need to compare with previous angle
                     set turret_rotation_angle [expr $turret_rotation_angle - 360]
                  }

                  set __sim_result $mom_sim_result

                  SIM_ask_axis_position $mom_sim_turret_axis($mom_sim_tool_carrier_id)
                  set __prev_angle $mom_sim_result
                  if { [expr ($turret_rotation_angle - $__prev_angle) > 180] } {
                     set turret_rotation_angle [expr $turret_rotation_angle - 360]
                  } elseif { [expr ($turret_rotation_angle - $__prev_angle) < -180] } {
                     set turret_rotation_angle [expr $turret_rotation_angle + 360]
                  }

                  set mom_sim_result $__sim_result

                  PB_SIM_call VNC_move_machine_rotary_axis $mom_sim_turret_axis($mom_sim_tool_carrier_id)\
                                                           $turret_rotation_angle
               }
            }
         }
      }


     # Change tool for mills
      if { $done_tool_change == 0 } {

        # pb502(13) -
        # Always unmount fly tool

        # pb853 - Fix error with condition below
        # pb850(m) - Adjust rotary angle only for machine with "head"
        # pb602(q) - Rotate B-head to tool change angle (set in PB_CMD_vnc____map_machine_tool_axes)
        #
         if { [string match "*head*" $mom_sim_machine_type] } {

            global mom_sim_mt_axis
            if { [info exists mom_sim_mt_axis(4)] } {

               global mom_sim_tool_change_angle

               if { ![info exists mom_sim_tool_change_angle] } {
                  set mom_sim_tool_change_angle 0
               }

               set mom_sim_pos(3) $mom_sim_tool_change_angle

               PB_SIM_call VNC_move_machine_rotary_axis $mom_sim_mt_axis(4) $mom_sim_pos(3)
               PB_SIM_call SIM_update
            }
         }


        # pb602(c) - Add condition to accommodate flash tool handling
        # Restore spindle axis to ready orientation
         global mom_sim_flash_tool
         if { ![info exists mom_sim_flash_tool] } {
            set mom_sim_flash_tool 0
         }

         PB_SIM_call VNC_rotate_head_spindle_axis 0

        # pb603(j) - Unmount fly tool in current carrier, if any
         global mom_sim_fly_tool_mounted
         if { [info exists mom_sim_tool_carrier_id] } {
            if { [info exists mom_sim_fly_tool_mounted($mom_sim_tool_carrier_id)] } {
               PB_SIM_call VNC_unmount_tool $mom_sim_fly_tool_mounted($mom_sim_tool_carrier_id)
            }
         } else {
            if { [info exists mom_sim_fly_tool_mounted(0)] } {
               PB_SIM_call VNC_unmount_tool $mom_sim_fly_tool_mounted(0)
            }
         }


        # pb801(g) - Also validate a null tool
        # pb800(i) - Next tool is null, bail out!
         if { [string match "0" $tool_number] || [string trim $mom_sim_ug_tool_name] == "" } {

           # Null following jct to send tool home properly
             set mom_sim_tool_junction         ""
             set mom_sim_current_tool_junction ""
             set mom_sim_current_junction      ""

             set mom_sim_tool_change 0
return
         }


         global mom_sim_tool_change_time
         if { ![info exists mom_sim_tool_change_time] || [EQ_is_le $mom_sim_tool_change_time 0.0] } {
            set tool_change_time 5
         } else {
            set tool_change_time $mom_sim_tool_change_time
         }

         PB_SIM_call VNC_set_ref_jct {""}
         PB_SIM_call SIM_mount_tool $tool_change_time "UG_NAME" "$mom_sim_ug_tool_name"\
                                    "$mom_sim_spindle_comp" "$mom_sim_spindle_jct"

        # pb603(j) - Remember the fly tool mounted in carrier
         if { [info exists mom_sim_tool_carrier_id] } {
            set mom_sim_fly_tool_mounted($mom_sim_tool_carrier_id) $mom_sim_ug_tool_name
         } else {
            set mom_sim_fly_tool_mounted(0) $mom_sim_ug_tool_name
         }


        # pb602(c) - Accommodate flash tool handling
        # Flash spindle axis if required
         if { $mom_sim_flash_tool } {
            PB_SIM_call VNC_rotate_head_spindle_axis 180
         }


        # By default, this variable is NOT set to indicate that tool length
        # compensation is done immediately @ tool change, otherwise it's set
        # in ____map command to cause compensation to be done @ length comp
        # (G43) function.

         global mom_sim_tool_length_comp_auto

         if { [info exists mom_sim_tool_length_comp_auto] && $mom_sim_tool_length_comp_auto == 0 } {
            set mom_sim_nc_register(TOOL_CHANGED) 1
         }
      }

     # Fetch tool comp ID
      set sim_tool_name $mom_sim_result
   }


   PB_SIM_call SIM_update


   if { [string length $sim_tool_name] > 0 } {
      PB_SIM_call SIM_activate_tool $sim_tool_name
   } else {
return
   }


   PB_SIM_call SIM_update


   set sim_prev_tool_name $mom_sim_ug_tool_name
   set mom_sim_tool_loaded $sim_tool_name


  # Flag that a tool change is done.
   set mom_sim_tool_change 0


   PB_SIM_call VNC_set_ref_jct $sim_tool_name

   set mom_sim_tool_junction "$mom_sim_current_junction"


  #++++++++++++++++++++++++++++++++++++++++++++++++++++++
  # Create a junction per tool offsets to track N/C data.
  #++++++++++++++++++++++++++++++++++++++++++++++++++++++
   set use_tool_tip_jct 1

   if { $mom_sim_tool_data($tool_number,offset_used) || [expr $mom_sim_pivot_distance != 0.0] } {

      if { ![string match "*_wedm" $mom_sim_machine_type] } {
         if { [string match "*axis*" $mom_sim_machine_type] } {
            set use_tool_tip_jct 0
            set x_offset [expr -1.0 * ($mom_sim_tool_data($tool_number,z_off) + $mom_sim_pivot_distance)]
            set y_offset 0.0
            set z_offset 0.0

         } elseif { [string match "*lathe*" $mom_sim_machine_type] } {
            if { [string match "TURRET_REF" $mom_sim_output_reference_method] } {
               set use_tool_tip_jct 0
               set x_offset $mom_sim_tool_data($tool_number,x_off)
               set y_offset $mom_sim_tool_data($tool_number,y_off)
               set z_offset 0.0
            }
         }
      }
   }


  #<911-2008 gsl> pb602 - This looks like a MUST fix !!!!!
   global mom_sim_curr_jct_matrix mom_sim_curr_jct_origin
   global mom_sim_result mom_sim_result1

   PB_SIM_call SIM_ask_init_junction_xform $mom_sim_tool_junction
   set mom_sim_curr_jct_matrix "$mom_sim_result"
   set mom_sim_curr_jct_origin "$mom_sim_result1"


   if { !$use_tool_tip_jct } {
      global mom_sim_tool_x_offset mom_sim_tool_y_offset mom_sim_tool_z_offset

      set mom_sim_tool_x_offset $x_offset
      set mom_sim_tool_y_offset $y_offset
      set mom_sim_tool_z_offset $z_offset

      PB_SIM_call PB_CMD_vnc__offset_tool_jct
   }


   if { [string match "TURN" $mom_sim_nc_register(MACHINE_MODE)] } {
      set mom_sim_pos(1) 0
   }

  # Reset mom_sim_prev_pos to disable unnecessary move
   for { set i 0 } { $i < 5 } { incr i } {
      set mom_sim_prev_pos($i) $mom_sim_pos($i)
   }


  # pb602 - Current tool jct should always be preserved!
   set mom_sim_current_tool_junction "$mom_sim_tool_junction"


  # Track @ pivot pt for the initial move
  # - Require a good pivot jct!
  #
   if { [info exists mom_sim_nc_register(TOOL_CHANGED)] } {
      global mom_sim_spindle_jct mom_sim_pivot_jct

      if { [info exists mom_sim_pivot_jct] } {
         PB_SIM_call VNC_set_current_ref_junction $mom_sim_pivot_jct
      } else {
         PB_SIM_call VNC_set_current_ref_junction $mom_sim_spindle_jct
      }

     # To prevent ref jct being reset to tool tip in sim_motion
      set mom_sim_tool_junction "$mom_sim_current_junction"
   }
}


#=============================================================
proc PB_CMD_vnc__ask_number_of_active_channels { } {
#=============================================================
# This function cycles through the kinematic model to determine
# if the model is a multi-channel machine.
#
# This function returns the number of K-components classified as _DEVICE.
#

   set cmd_name "PB_SIM_cycle_comp_of_class"

   if { [llength [info commands $cmd_name]] == 0 } {

      # pb850(k) - Remove PB_SIM_call from this command. It caused error in ISV QC mode.
      # pb601(i) -
      #=====================================================
      proc $cmd_name { COMP_CLASS base_comp class class_type args } {
      #=====================================================
      # This command recurrsively identifies all NC axes
      # from a machine model.

         upvar $COMP_CLASS comp_class

        # Added args for passing channel number to collect tools per each carrier
         if { [llength $args] > 0 } {
            set chan [lindex $args 0]
         } else {
            set chan ""
         }

         global mom_sim_result mom_sim_result1

         set n_comp 0

         if [string match "*_SPUN" $base_comp] {
            return
         }
         if [catch { SIM_ask_number_of_child_components $base_comp }] {
            return
         } else {
            set n_comp $mom_sim_result
         }

         for { set i 0 } { $i < $n_comp } { incr i } {

            if ![catch { SIM_ask_nth_child_component $base_comp $i }] {
               set comp $mom_sim_result

               set mom_sim_result 0
               if { ![string compare "SYSTEM" $class_type] } {
                  if [catch { SIM_is_component_of_system_class $comp $class }] {
                     continue
                  }
               } else {
                  if [catch { SIM_is_component_of_user_class $comp $class }] {
                     continue
                  }
               }
            } else {
               continue
            }

            if { $mom_sim_result == 1 } {

               switch $class {

                  _DEVICE {
                     SIM_ask_number_of_channels_at_component $comp
                     set n_ch $mom_sim_result

                     for { set idx 0 } { $idx < $n_ch } { incr idx } {

                        SIM_ask_nth_channel_at_component $comp $idx
                        set ch $mom_sim_result

                        if { [info exists comp_class(active_chan)] } {
                           if { [lsearch $comp_class(active_chan) $ch] < 0 } {
                              lappend comp_class(active_chan) $ch
                           }
                        } else {
                           lappend comp_class(active_chan) $ch
                        }

                       #<07-15-08 gsl> Find tools on this device
                        eval { [lindex [info level 0] 0] comp_class $comp _TOOL $class_type $ch }
                     }
                  }

                  _DEVICE_HOLDER {
                  }

                  _TOOL {
                    # pb601(i) -
                    #*************************************************************************************
                    # Potentail problem - K-comp can be renamed to become different from actual tool name.
                    # ==> Dependant K-comp should be read only!
                    # 
                     set comp_class(_CARRIER,$comp) $chan

                     global mom_sim_comp_class
                     set mom_sim_comp_class(_CARRIER,$comp) $chan
                  }

                  default {
                     lappend comp_class($class,comp) $comp
                  }
               }
            }

            eval { [lindex [info level 0] 0] comp_class $comp $class $class_type $chan }
         }
      }
   }



   global mom_sim_result

  # pb602(d) - Preserve status
   set sim_result_saved $mom_sim_result


   VNC_unset_vars n_channels

   if { ![catch { SIM_ask_number_of_channels }] } {
      if { $mom_sim_result == 1 } {
         set n_channels 1
      }
   } else {
      set n_channels 1
   }

   global mom_sim_active_channels

   if { [info exists mom_sim_active_channels] } {
      set n_channels [llength $mom_sim_active_channels]
   }

   if [info exists n_channels] {
      set mom_sim_result $sim_result_saved
return $n_channels
   }


   set cmd_name "PB_SIM_cycle_comp_of_class"


   set mom_sim_result ""

   set machine_base MACHINE_BASE
   PB_SIM_call SIM_ask_machine_base_component

   if { ![string match "" $mom_sim_result] } {
      set machine_base $mom_sim_result
   }


   VNC_unset_vars  COMP_class

   set class _DEVICE
   set mode  SYSTEM

   set n_channels 1
   if { ![catch { PB_SIM_cycle_comp_of_class COMP_class $machine_base $class $mode }] } {
      if { [info exists COMP_class(active_chan)] } {
         set mom_sim_active_channels $COMP_class(active_chan)
         set n_channels [llength $COMP_class(active_chan)]
      }
   }

   set mom_sim_result $sim_result_saved

return $n_channels
}




