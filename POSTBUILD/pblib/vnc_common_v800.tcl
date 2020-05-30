########################### Virtual NC Controller ############################
#                                                                            #
# Copyright (C) 1999/2000/2001/2002/2003/2004/2005/2006/2007/2008/2009/2010/ #
#               2011                                                         #
#                                                                            #
#                           Siemens PLM Software                             #
#                                                                            #
##############################################################################
#                       V N C _ C O M M O N _ V 8 0 0 . T C L
##############################################################################
#
# DESCRIPTION
#
#   This file contains handlers for incremental VNC conversion.
#
##############################################################################



#=============================================================
proc PB_CMD_vnc__rewind_stop_code { } {
#=============================================================
# pb800(l) -
# Command to handle tape rewind-stop code,
# it's executed automatically by VNC processor.

  global mom_sim_nc_register
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

           # pb800(h) - Only handle when pocket ID is an integer
            if { ![catch [expr $mom_sim_tool_pocket_id] ] } {

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
 
                 # - Reduce turret rotation
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

        # pb602(q) - Rotate B-head to tool change angle (set in PB_CMD_vnc____map_machine_tool_axes)
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


        # pb800(i) - Next tool is null, bail out!
         if { [string match "0" $tool_number] } {

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
         PB_SIM_call SIM_mount_tool $tool_change_time "UG_NAME" "$mom_sim_ug_tool_name" "$mom_sim_spindle_comp" "$mom_sim_spindle_jct"

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
proc PB_CMD_vnc__circular_move { } {
#=============================================================
  global mom_sim_address mom_sim_pos mom_sim_prev_pos
  global mom_sim_lg_axis
  global mom_sim_nc_register
  global mom_sim_circular_dir
  global mom_sim_circular_vector

  global mom_sim_o_buffer
  global mom_sim_nc_block


  # Clear R in use condition
   if { [info exists mom_sim_nc_register(R_IN_USE)] } {

     # Unset it only if not modal!
      if { !$mom_sim_address(R,modal) } {
         VNC_unset_vars  mom_sim_nc_register(R_IN_USE)
      }
   }

  # pb601(a) - Search for R word if the leader of Address R is R.
  # pb800(f) - Look at original block buffer
   if { [info exists mom_sim_nc_block] } {
      set tmp_o_buff $mom_sim_nc_block
   } else {
      set tmp_o_buff $mom_sim_o_buffer
   }

   VNC_parse_nc_word tmp_o_buff $mom_sim_address(R,leader) 2 PB_CMD_vnc__R_code


  # pb602(a) - Search for IJK to override R mode
  #         ==> R-in-use flag can be still in effect resulted from previous (turn) post

   if { [info exists mom_sim_nc_register(R_IN_USE)] } {

      if { [VNC_parse_nc_word tmp_o_buff $mom_sim_address(I,leader) 2] ||\
           [VNC_parse_nc_word tmp_o_buff $mom_sim_address(J,leader) 2] ||\
           [VNC_parse_nc_word tmp_o_buff $mom_sim_address(K,leader) 2] } {

         VNC_unset_vars mom_sim_nc_register(R_IN_USE)
      }
   }


   PB_SIM_call VNC_set_feedrate_mode CUT


   set dir $mom_sim_circular_dir
   set plane $mom_sim_nc_register(PLANE)


  # When "Unsigned Vector - Arc Start to Center" is used to define
  # the arc center vector, fake it into R case for arc center calculation.

   if { [string match "Unsigned Vector - Arc Start to Center" $mom_sim_circular_vector] } {

      set mom_sim_nc_register(R_IN_USE) 1

      if { [info exists mom_sim_nc_register(R)] } {
         set R_saved $mom_sim_nc_register(R)
      } else {
         set R_saved none
      }

      switch $plane {
         "YZ" {
            set dx $mom_sim_pos(6)
            set dy $mom_sim_pos(7)
         }
         "ZX" {
            set dx $mom_sim_pos(7)
            set dy $mom_sim_pos(5)
         }
         default {
            set dx $mom_sim_pos(5)
            set dy $mom_sim_pos(6)
         }
      }

     # Arc radius
      set mom_sim_nc_register(R) [expr sqrt($dx*$dx + $dy*$dy)]
   }


  # Find arc center vector
   if { [info exists mom_sim_nc_register(R_IN_USE)] } {

      switch $plane {
         "YZ" {
            set dx [expr $mom_sim_pos(1) - $mom_sim_prev_pos(1)]
            set dy [expr $mom_sim_pos(2) - $mom_sim_prev_pos(2)]
         }
         "ZX" {
            set dx [expr $mom_sim_pos(2) - $mom_sim_prev_pos(2)]
            set dy [expr $mom_sim_pos(0) - $mom_sim_prev_pos(0)]
         }
         default {
            set dx [expr $mom_sim_pos(0) - $mom_sim_prev_pos(0)]
            set dy [expr $mom_sim_pos(1) - $mom_sim_prev_pos(1)]
         }
      }

     # pb800(g) -
      set r $mom_sim_nc_register(R)
      set a [expr atan2($dy,$dx)]
       set t [expr sqrt($dx*$dx + $dy*$dy) / (2.0*$r)]
       if [EQ_is_gt $t  1.0] { set t  1.0 }
       if [EQ_is_lt $t -1.0] { set t -1.0 }
      set b [expr acos($t)]

     # Complement of an arc
      if { [expr $r < 0] } {
         set dir [expr -1 * $dir]
      }

      set c [expr $a + $dir*$b]

      switch $plane {
         "YZ" {
            set j [expr $r * cos($c) + $mom_sim_prev_pos(1)]
            set k [expr $r * sin($c) + $mom_sim_prev_pos(2)]
         }
         "ZX" {
            set k [expr $r * cos($c) + $mom_sim_prev_pos(2)]
            set i [expr $r * sin($c) + $mom_sim_prev_pos(0)]
         }
         default {
            set i [expr $r * cos($c) + $mom_sim_prev_pos(0)]
            set j [expr $r * sin($c) + $mom_sim_prev_pos(1)]
         }
      }

     # Restore R register
      if { [string match "Unsigned Vector - Arc Start to Center" $mom_sim_circular_vector] } {
         if { [string match "none" $R_saved] } {
            VNC_unset_vars  mom_sim_nc_register(R)
         } else {
            set mom_sim_nc_register(R) $R_saved
         }
      }

   } else {

      switch $mom_sim_circular_vector {
         "Vector - Arc Start to Center" {
            set i [expr $mom_sim_prev_pos(0) + $mom_sim_pos(5)]
            set j [expr $mom_sim_prev_pos(1) + $mom_sim_pos(6)]
            set k [expr $mom_sim_prev_pos(2) + $mom_sim_pos(7)]
         }

         "Vector - Arc Center to Start" {
            set i [expr $mom_sim_prev_pos(0) - $mom_sim_pos(5)]
            set j [expr $mom_sim_prev_pos(1) - $mom_sim_pos(6)]
            set k [expr $mom_sim_prev_pos(2) - $mom_sim_pos(7)]
         }

         "Vector - Absolute Arc Center" {
            set i $mom_sim_pos(5)
            set j $mom_sim_pos(6)
            set k $mom_sim_pos(7)
         }
      }
   }

  # pb800(g) -
   if ![info exists i] { set i 0.0 }
   if ![info exists j] { set j 0.0 }
   if ![info exists k] { set k 0.0 }


  #=====================
  # Validate arc record
  #=====================
  # pb750(j) -

  # To be implemented as "Other Options" of VNC's configuration
   global mom_sim_validate_arc mom_sim_validate_arc_tol

  # Allow overriding by setting env vars
   global env
   if { [info exists env(UGII_CAM_SIM_VALIDATE_ARC)] } {
      set mom_sim_validate_arc $env(UGII_CAM_SIM_VALIDATE_ARC)
   }
   if { ![info exists mom_sim_validate_arc] } {
     # Default to ON, if not set
      set mom_sim_validate_arc 1
   }

   if { $mom_sim_validate_arc } {

     # Determine tolerance for validation
      global mom_sim_output_unit

      if { [info exists env(UGII_CAM_SIM_VALIDATE_ARC_TOL)] } {
         set mom_sim_validate_arc_tol $env(UGII_CAM_SIM_VALIDATE_ARC_TOL)
      }
      if { ![info exists mom_sim_validate_arc_tol] } {
         if { [string match "MM" $mom_sim_output_unit] } {
            set mom_sim_validate_arc_tol 0.0011
         } else {
            set mom_sim_validate_arc_tol 0.00011
         }
      }

     # Arc center
      set Xs [expr $mom_sim_prev_pos(0) - $i]
      set Ys [expr $mom_sim_prev_pos(1) - $j]
      set Zs [expr $mom_sim_prev_pos(2) - $k]
      set Xe [expr $mom_sim_pos(0) - $i]
      set Ye [expr $mom_sim_pos(1) - $j]
      set Ze [expr $mom_sim_pos(2) - $k]

     # Start & end radius
      switch $plane {
         "XY" {
            set Rs [expr sqrt( $Xs*$Xs + $Ys*$Ys )]
            set Re [expr sqrt( $Xe*$Xe + $Ye*$Ye )]
         }
         "YZ" {
            set Rs [expr sqrt( $Ys*$Ys + $Zs*$Zs )]
            set Re [expr sqrt( $Ye*$Ye + $Ze*$Ze )]
         }
         "ZX" {
            set Rs [expr sqrt( $Zs*$Zs + $Xs*$Xs )]
            set Re [expr sqrt( $Ze*$Ze + $Xe*$Xe )]
         }
         default {
            set Rs [expr sqrt( $Xs*$Xs + $Ys*$Ys + $Zs*$Zs )]
            set Re [expr sqrt( $Xe*$Xe + $Ye*$Ye + $Ze*$Ze )]
         }
      }

     # Output VNC message when error
      if { [expr abs($Re - $Rs) > $mom_sim_validate_arc_tol] } {
         VNC_send_message "*** BAD ARC ***"
         VNC_send_message "$mom_sim_nc_block"
         VNC_send_message "  Start R: $Rs  End R: $Re   Diff = [expr abs($Re - $Rs)] > $mom_sim_validate_arc_tol"
         VNC_send_message "  ($mom_sim_prev_pos(0), $mom_sim_prev_pos(1), $mom_sim_prev_pos(2)) ->\
                             ($mom_sim_pos(0), $mom_sim_pos(1), $mom_sim_pos(2))\n"
      }
   }



   global mom_sim_arc_output_mode
   global mom_sim_PI

  # pb601(b) -
   global mom_sim_helix_pitch
   set helix_pitch ""

   switch $plane {
      "YZ" {

        # Detect helical condition
         if { [info exists mom_sim_helix_pitch] && ![EQ_is_zero $mom_sim_helix_pitch] } {
            set dz [expr $mom_sim_pos(0) - $mom_sim_prev_pos(0)]
            if { ![EQ_is_zero $dz] } {
               set helix_pitch [expr abs(2*$mom_sim_PI*$dz/$mom_sim_helix_pitch)]
            }
         }

         if { [string length $helix_pitch] == 0 } {

           # Handle full circle using half circle pt
            if { [string match "FULL_CIRCLE" $mom_sim_arc_output_mode] } {
               if { [EQ_is_equal $mom_sim_pos(1) $mom_sim_prev_pos(1)] && [EQ_is_equal $mom_sim_pos(2) $mom_sim_prev_pos(2)] } {

                  set dx [expr $mom_sim_pos(1) - $j]
                  set dy [expr $mom_sim_pos(2) - $k]
                  set a [expr atan2($dy,$dx)]
                  set b [expr $a + $mom_sim_PI]
                  set r [expr sqrt($dx*$dx + $dy*$dy)]
                  set px [expr $j + $r*cos($b)]
                  set py [expr $k + $r*sin($b)]

                  PB_SIM_call SIM_move_circular_zcs $dir 0 0 $mom_sim_lg_axis(Y) $px $mom_sim_lg_axis(Z) $py\
                                                             $mom_sim_lg_axis(J) $j $mom_sim_lg_axis(K) $k
               }
            }

            eval PB_SIM_call SIM_move_circular_zcs $dir 0 0 $mom_sim_lg_axis(Y) $mom_sim_pos(1)\
                                                            $mom_sim_lg_axis(Z) $mom_sim_pos(2)\
                                                            $mom_sim_lg_axis(J) $j $mom_sim_lg_axis(K) $k
         } else {

          # pb602(r) - Activate logic below
           if 1 {
            if { [EQ_is_lt $helix_pitch [expr 2*$mom_sim_PI]] } {
               set helix_pitch "$mom_sim_lg_axis(X) $mom_sim_pos(0)"
            } else {
               set helix_pitch "$mom_sim_lg_axis(X) $mom_sim_pos(0) P $helix_pitch"
            }
           } else {
            set helix_pitch "P $helix_pitch"
           }

            eval PB_SIM_call SIM_move_helical_zcs $dir 0 0 $mom_sim_lg_axis(Y) $mom_sim_pos(1)\
                                                           $mom_sim_lg_axis(Z) $mom_sim_pos(2)\
                                                           $mom_sim_lg_axis(J) $j $mom_sim_lg_axis(K) $k $helix_pitch
         }
      }

      "ZX" {

        # Detect helical condition
         if { [info exists mom_sim_helix_pitch] && ![EQ_is_zero $mom_sim_helix_pitch] } {
            set dz [expr $mom_sim_pos(1) - $mom_sim_prev_pos(1)]
            if { ![EQ_is_zero $dz] } {
               set helix_pitch [expr abs(2*$mom_sim_PI*$dz/$mom_sim_helix_pitch)]
            }
         }

         if { [string length $helix_pitch] == 0 } {

           # Handle full circle using half circle pt
            if { [string match "FULL_CIRCLE" $mom_sim_arc_output_mode] } {
               if { [EQ_is_equal $mom_sim_pos(2) $mom_sim_prev_pos(2)] && [EQ_is_equal $mom_sim_pos(0) $mom_sim_prev_pos(0)] } {

                  set dx [expr $mom_sim_pos(2) - $k]
                  set dy [expr $mom_sim_pos(0) - $i]
                  set a [expr atan2($dy,$dx)]
                  set b [expr $a + $mom_sim_PI]
                  set r [expr sqrt($dx*$dx + $dy*$dy)]
                  set px [expr $k + $r*cos($b)]
                  set py [expr $i + $r*sin($b)]

                  PB_SIM_call SIM_move_circular_zcs 0 $dir 0 $mom_sim_lg_axis(Z) $px $mom_sim_lg_axis(X) $py\
                                                             $mom_sim_lg_axis(K) $k $mom_sim_lg_axis(I) $i
               }
            }

            eval PB_SIM_call SIM_move_circular_zcs 0 $dir 0 $mom_sim_lg_axis(Z) $mom_sim_pos(2)\
                                                            $mom_sim_lg_axis(X) $mom_sim_pos(0)\
                                                            $mom_sim_lg_axis(K) $k $mom_sim_lg_axis(I) $i
         } else {

          # pb602(r) - Activate logic below
           if 1 {
            if { [EQ_is_lt $helix_pitch [expr 2*$mom_sim_PI]] } {
               set helix_pitch "$mom_sim_lg_axis(Y) $mom_sim_pos(1)"
            } else {
               set helix_pitch "$mom_sim_lg_axis(Y) $mom_sim_pos(1) P $helix_pitch"
            }
           } else {
            set helix_pitch "P $helix_pitch"
           }

            eval PB_SIM_call SIM_move_helical_zcs 0 $dir 0 $mom_sim_lg_axis(Z) $mom_sim_pos(2)\
                                                           $mom_sim_lg_axis(X) $mom_sim_pos(0)\
                                                           $mom_sim_lg_axis(K) $k $mom_sim_lg_axis(I) $i $helix_pitch
         }
      }

      default {

        # Detect helical condition
         if { [info exists mom_sim_helix_pitch] && ![EQ_is_zero $mom_sim_helix_pitch] } {
            set dz [expr $mom_sim_pos(2) - $mom_sim_prev_pos(2)]
            if { ![EQ_is_zero $dz] } {
               set helix_pitch [expr abs(2*$mom_sim_PI*$dz/$mom_sim_helix_pitch)]
            }
         }

         if { [string length $helix_pitch] == 0 } {

           # Handle full circle using half circle pt
            if { [string match "FULL_CIRCLE" $mom_sim_arc_output_mode] } {
               if { [EQ_is_equal $mom_sim_pos(0) $mom_sim_prev_pos(0)] && \
                    [EQ_is_equal $mom_sim_pos(1) $mom_sim_prev_pos(1)] } {

                  set dx [expr $mom_sim_pos(0) - $i]
                  set dy [expr $mom_sim_pos(1) - $j]
                  set a [expr atan2($dy,$dx)]
                  set b [expr $a + $mom_sim_PI]
                  set r [expr sqrt($dx*$dx + $dy*$dy)]
                  set px [expr $i + $r*cos($b)]
                  set py [expr $j + $r*sin($b)]

                  PB_SIM_call SIM_move_circular_zcs 0 0 $dir $mom_sim_lg_axis(X) $px $mom_sim_lg_axis(Y) $py\
                                                             $mom_sim_lg_axis(I) $i $mom_sim_lg_axis(J) $j
               }
            }

            eval PB_SIM_call SIM_move_circular_zcs 0 0 $dir $mom_sim_lg_axis(X) $mom_sim_pos(0)\
                                                            $mom_sim_lg_axis(Y) $mom_sim_pos(1)\
                                                            $mom_sim_lg_axis(I) $i $mom_sim_lg_axis(J) $j
         } else {

          # pb602(r) - Activate logic below
           if 1 {
            if { [EQ_is_lt $helix_pitch [expr 2*$mom_sim_PI]] } {
               set helix_pitch "$mom_sim_lg_axis(Z) $mom_sim_pos(2)"
            } else {
               set helix_pitch "$mom_sim_lg_axis(Z) $mom_sim_pos(2) P $helix_pitch"
            }
           } else {
            set helix_pitch "P $helix_pitch"
           }

            eval PB_SIM_call SIM_move_helical_zcs 0 0 $dir $mom_sim_lg_axis(X) $mom_sim_pos(0)\
                                                           $mom_sim_lg_axis(Y) $mom_sim_pos(1)\
                                                           $mom_sim_lg_axis(I) $i $mom_sim_lg_axis(J) $j $helix_pitch
         }
      }
   }
}


#=============================================================
proc PB_CMD_vnc__ask_speed_mode { } {
#=============================================================
  global mom_spindle_mode

   if { [info exists mom_spindle_mode] } {
      switch $mom_spindle_mode {
         RPM     { set speed_units "REV_PER_MIN" }
         default { set speed_units "UNKNOWN SPEED UNITS" }
      }
   } else {
      set speed_units "UNKNOWN SPEED UNITS"
   }

return $speed_units
}


#=============================================================
proc PB_CMD_vnc__calculate_duration_time { } {
#=============================================================
  global mom_sim_motion_linear_or_angular
  global mom_sim_travel_delta mom_sim_duration_time
  global mom_sim_feedrate_mode
  global mom_sim_nc_register
  global mom_sim_rapid_feed_rate
  global mom_sim_max_dpm


  # pb800(d) - Ensure delta is handled as a real number
   set mom_sim_travel_delta [expr double($mom_sim_travel_delta)]


  # Execute user supplied command for time calculation
   if { [llength [info commands "PB_CMD_vnc__user_calculate_duration_time"]] } {
      PB_SIM_call PB_CMD_vnc__user_calculate_duration_time
return
   }


   set delta [expr abs($mom_sim_travel_delta)]

  # Prescreen condition
   if { ![EQ_is_gt $delta 0.0] } {
      set mom_sim_duration_time 0.0
return
   }


   set linear_or_angular $mom_sim_motion_linear_or_angular

  # Determine feed rate & mode
   if { [string match "RAPID" $mom_sim_nc_register(MOTION)] || [expr $mom_sim_nc_register(F) <= 0.0] } {

      set feed $mom_sim_rapid_feed_rate

      if { ![string compare "MM" $mom_sim_nc_register(UNIT)] } {
         set mode MM_PER_MIN
      } else {
         set mode INCH_PER_MIN
      }
   } else {
      set feed $mom_sim_nc_register(F)
      set mode $mom_sim_nc_register(FEED_MODE)
   }

  # pb800(d) - Ensure feed is a real number
   set feed [expr double(abs($feed))]


  # Initialize time
   set mom_sim_duration_time 1.0

   if { ![string compare "ANGULAR" $linear_or_angular] } {

     # Find correct feed rate mode for a pure ratary move
      global mom_sim_feed_param
      global mom_sim_rapid_feed_mode
      global mom_sim_contour_feed_mode

      if { ![string compare "RAPID" $mom_sim_nc_register(MOTION)] } {
         if { [info exists mom_sim_max_dpm] && [EQ_is_gt $mom_sim_max_dpm 0.0] } {
            set mom_sim_duration_time [expr ($delta / $mom_sim_max_dpm) * 60.0]
         }
      } else {

        # Calculate time for pure rotary move with DPM, if defined.
         global mom_sim_feedrate_dpm
         if { [info exists mom_sim_feedrate_dpm] && [EQ_is_gt $mom_sim_feedrate_dpm 0.0] } {
            set mom_sim_duration_time [expr ($delta / $mom_sim_feedrate_dpm) * 60.0]
         } elseif { ![EQ_is_zero $feed] } {

           # We actually need to know the direction of rotation to convert FPM to DPM.
           # +++ Use kluge for now

            set mom_sim_duration_time [expr ($delta / $feed)]
         }
      }

   } else { ;# LINEAR

      if { ![EQ_is_zero $feed] } {

         switch $mode {
            INCH_PER_MIN -
            MM_PER_MIN   {

               set mom_sim_duration_time [expr ($delta / $feed) * 60.0]
            }

            INCH_PER_REV -
            MM_PER_REV   {

               global mom_sim_spindle_mode mom_sim_spindle_speed
               global mom_sim_PI mom_sim_prev_pos mom_sim_pos

               switch $mom_sim_spindle_mode {
                  "REV_PER_MIN" {
                     set feed [expr $feed * $mom_sim_spindle_speed]
                  }
                  "SFM" -
                  "FEET_PER_MIN" {
                    # The spindle direction may not always be along Z-axis.
                    # We may need more sophisticated formula here!
                    #
                     if { ![EQ_is_zero [expr $mom_sim_prev_pos(0) + $mom_sim_pos(0)] ] } {
                        set feed [expr $feed * $mom_sim_spindle_speed * 12.0 /\
                                       abs($mom_sim_PI * ($mom_sim_prev_pos(0) + $mom_sim_pos(0)))]
                     } else {
                        set feed $mom_sim_rapid_feed_rate
                     }
                  }
                  "SMM" -
                  "M_PER_MIN" {
                     if { ![EQ_is_zero [expr $mom_sim_prev_pos(0) + $mom_sim_pos(0)] ] } {
                        set feed [expr $feed * $mom_sim_spindle_speed * 1000.0 /\
                                       abs($mom_sim_PI * ($mom_sim_prev_pos(0) + $mom_sim_pos(0)))]
                     } else {
                        set feed $mom_sim_rapid_feed_rate
                     }
                  }
               }

               if { ![EQ_is_zero $feed] } {
                  set mom_sim_duration_time [expr ($delta / $feed) * 60.0]
               }
            }

            MM_PER_100REV {
              # FRN mode
               set mom_sim_duration_time [expr 60.0 / $feed]
            }
         }
      }
   }


 if 0 { ;# debug
   global __sim_total_time
   if { ![info exists __sim_total_time] } {
      set __sim_total_time 0.0
   }
   set __sim_total_time [expr $__sim_total_time + $mom_sim_duration_time]
 }

}


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


     # Extract offsets between a local and the mainMCS
     #
      if { [string compare $coordinate_system_mode "MAIN"] } {

         global mom_fixture_offset_value
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
      global mom_fixture_offset_value
      if { ![info exists mom_fixture_offset_value] } {
         set fixture_offset 0
      } else {
         set fixture_offset $mom_fixture_offset_value
      }
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
proc PB_CMD_vnc__pass_csys_data__pb750 { } {
#=============================================================
# pb800(c) - This command is retained as backup.
#
# This function is only executed in an in-process ISV
# to pass csys definitions.
#
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

if 0 {
VNC_info "machine csys matrix : [VNC_sort_array_vals mom_machine_csys_matrix]"
VNC_info "local csys matrix : [VNC_sort_array_vals mom_csys_matrix]"
VNC_info " CSYS Purpose : $mom_coordinate_system_purpose\n\
           Special Output : $mom_special_output\n\
           Coordinate System Type : $mom_kin_coordinate_system_type"
}

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
     #                      MAIN  : Special Output = 1
     #                      LOCAL : Special Output = 0, 2
     #                      CSYS  : Special Output = 3
     #==========================================================

      set main_mcs_found 0

      if { $mom_coordinate_system_purpose == 1 } {

         set coordinate_system_mode  MAIN

        # Set a flag to preserve real mainMCS later
         set main_mcs_found 1

      } else {

        # pb750(h) -
        # set coordinate_system_mode  $mom_kin_coordinate_system_type
         set coordinate_system_mode  LOCAL
      }


     # A local MCS without main becomes a main MCS itself.
     # mom_machine_csys_matrix containing ACS matrix is redefined with the local MCS itself.
     #
      if { $coordinate_system_mode  != "MAIN" } {

         if { [string match "GEOMETRY" $mom_main_mcs] || [string match "NONE" $mom_main_mcs] } {

            set coordinate_system_mode MAIN
         }
      }


     # Define mainMCS for any MAIN mode
     #
      if { [string match "MAIN" $coordinate_system_mode] } {

         MTX3_transpose mom_machine_csys_matrix mcs_matrix
         MTX3_multiply mcs_matrix mom_csys_matrix mainMCS

         set u(0) $mom_csys_matrix(9)
         set u(1) $mom_csys_matrix(10)
         set u(2) $mom_csys_matrix(11)

         MTX3_vec_multiply u mom_machine_csys_matrix w

         set mainMCS(9)  [expr $mom_machine_csys_matrix(9)  + $w(0)]
         set mainMCS(10) [expr $mom_machine_csys_matrix(10) + $w(1)]
         set mainMCS(11) [expr $mom_machine_csys_matrix(11) + $w(2)]

        # Preserve a real main MCS
         if $main_mcs_found {
            array set mom_sim_main_mcs [array get mainMCS]
         }

      } else {

        # Extract offsets between a local and the mainMCS
        #

         global mom_fixture_offset_value
         global mom_sim_nc_register mom_sim_wcs_offsets

        # Fetch fixture offset # specified with the CSYS object
         if { $mom_fixture_offset_value > 0 } {

            set mom_sim_nc_register(WCS) $mom_fixture_offset_value

           # Set linear offsets
            set mom_sim_wcs_offsets($mom_fixture_offset_value) \
                [list $mom_csys_matrix(9) $mom_csys_matrix(10) $mom_csys_matrix(11) 0.0 0.0 0.0]

           # Find angular offsets per axis of rotation
            global mom_sim_machine_type
            global mom_sim_4th_axis_plane mom_sim_5th_axis_plane

            if { ![string match "*wedm" $mom_sim_machine_type] &&\
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
                  set mom_sim_wcs_offsets($mom_fixture_offset_value) \
                      [lreplace $mom_sim_wcs_offsets($mom_fixture_offset_value) $4th_index $4th_index $fourth_ang]
               }
               if { $5th_index > 0 } {
                  set mom_sim_wcs_offsets($mom_fixture_offset_value) \
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


     # Fetch the real main MCS, if any.
     # pb502(15) - <03-21-2007 lili> add condition $mom_coordinate_system_purpose in judge
      if { [info exists mom_sim_main_mcs ] && $mom_coordinate_system_purpose } { 
         array set mainMCS [array get mom_sim_main_mcs]
      }


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

#VNC_info "Lathe work plane MCSX"
         }
      }


     # Output WCS number
     #
      global mom_fixture_offset_value
      if { ![info exists mom_fixture_offset_value] } {
         set fixture_offset 0
      } else {
         set fixture_offset $mom_fixture_offset_value
      }
      set mom_sim_message "CSYS_FIXTURE_OFFSET==$fixture_offset"
      PB_SIM_call PB_CMD_vnc__output_vnc_msg


     #---------------------------------------------------------------------------
     # Always simulate N/C codes w.r.t. the qualified main MCS.
     # A local MCS will not be referenced until a G68 or G54 etc. is encountered.
     #---------------------------------------------------------------------------
      for { set i 0 } { $i < 12 } { incr i } {
         set mom_sim_message "CSYS_MTX_$i==$mainMCS($i)"
         PB_SIM_call PB_CMD_vnc__output_vnc_msg
      }

#VNC_info "$coordinate_system_mode mainMCS --> [VNC_sort_array_vals mainMCS]"


     # Retain a copy of main, local & the currently active csys matrix
      global mom_sim_main_csys_matrix
      global mom_sim_local_csys_matrix
      global mom_sim_csys_matrix

      if { ![string match "MAIN" $coordinate_system_mode] } {
         array set mom_sim_csys_matrix        [array get matrix]
         array set mom_sim_local_csys_matrix  [array get matrix]
      } else {
         array set mom_sim_main_csys_matrix   [array get mainMCS]
      }
   }
}


#=============================================================
proc PB_CMD_vnc__init_sim_vars { } {
#=============================================================
  global mom_sim_word_separator mom_sim_word_separator_len
  global mom_sim_pos
  global mom_sim_tool_loaded
  global mom_sim_tool_junction
  global mom_sim_curr_jct_matrix mom_sim_curr_jct_origin
  global mom_sim_nc_register
  global mom_sim_wcs_offsets
  global mom_sim_ug_tool_name
  global mom_sim_result mom_sim_result1


  # Define some misc commands.
  # -> This call must be done 1st!!!
   PB_SIM_call PB_CMD_vnc__define_misc_procs


  # pb502(14) - Add user's own commands
   PB_SIM_call PB_CMD_vnc__define_user_misc_procs


  # pb600 -
  # - Retain current state of the participating NC axes, if any, before switching to new set
  #
   global mom_sim_mt_axis

   if { [info exists mom_sim_mt_axis(X)] && [info exists mom_sim_pos(0)] } {
      set mom_sim_nc_register($mom_sim_mt_axis(X)) $mom_sim_pos(0)
   }
   if { [info exists mom_sim_mt_axis(Y)] && [info exists mom_sim_pos(1)] } {
      set mom_sim_nc_register($mom_sim_mt_axis(Y)) $mom_sim_pos(1)
   }
   if { [info exists mom_sim_mt_axis(Z)] && [info exists mom_sim_pos(2)] } {
      set mom_sim_nc_register($mom_sim_mt_axis(Z)) $mom_sim_pos(2)
   }
   if { [info exists mom_sim_mt_axis(4)] && [info exists mom_sim_pos(3)] } {
      set mom_sim_nc_register($mom_sim_mt_axis(4)) $mom_sim_pos(3)
   }
   if { [info exists mom_sim_mt_axis(5)] && [info exists mom_sim_pos(4)] } {
      set mom_sim_nc_register($mom_sim_mt_axis(5)) $mom_sim_pos(4)
   }


  # Initialize var that defers tool length comp @ tool change until G43/44
   global mom_sim_tool_length_comp_auto
   VNC_unset_vars mom_sim_tool_length_comp_auto


  # Transfer static data from the Post.
  #
   PB_SIM_call VNC_load_post_definitions


  # Inspect NC functions
  #
   PB_SIM_call PB_CMD_vnc__inspect_nc_func


  # When a VNC is used to output VNC messages only w/o simulation.
  #
   global mom_sim_vnc_msg_only
   if { [info exists mom_sim_vnc_msg_only] && $mom_sim_vnc_msg_only } {
return
   }


  # Abolish end-of-block symbol for CAM program (non-standalone NC program) simulation
   global mom_sim_post_builder_rev_post
   global mom_sim_end_of_block mom_sim_end_of_block_len
   if { !$mom_sim_post_builder_rev_post } {
      set mom_sim_end_of_block ""
      set mom_sim_end_of_block_len 0
   }


  # Display this VNC name in ISV.
  #
   PB_SIM_call PB_CMD_vnc__display_version


  # Initialize controller's input unit to post's output unit
  #
   global mom_sim_output_unit
   if { ![info exists mom_sim_nc_register(UNIT)] } {
      set mom_sim_nc_register(UNIT) $mom_sim_output_unit
   }


  # Undefine machine tool kinematics assignment
  # to clear up residual variables.
  #
   global mom_sim_zcs_base mom_sim_zcs_base_MCS mom_sim_zcs_base_LCS
   global mom_sim_spindle_comp mom_sim_spindle_jct mom_sim_pivot_jct
   global mom_sim_advanced_kinematic_jct
   global mom_sim_mt_axis

   VNC_unset_vars  mom_sim_zcs_base_MCS\
                   mom_sim_zcs_base_LCS\
                   mom_sim_zcs_base\
                   mom_sim_spindle_comp\
                   mom_sim_spindle_jct\
                   mom_sim_pivot_jct\
                   mom_sim_advanced_kinematic_jct\
                   mom_sim_mt_axis


  # pb502(5) -
  # Save machine base component as global var
  #
   global mom_sim_machine_base_comp
   set mom_sim_result ""
   set mom_sim_machine_base_comp MACHINE_BASE
   PB_SIM_call SIM_ask_machine_base_component
   if { ![string match "" $mom_sim_result] } {
      set mom_sim_machine_base_comp $mom_sim_result
   }


  # Interrogate actual number of NC axes from model
  # This enables use of a higher dof driver on a lower dof machine.
   global mom_sim_num_machine_axes

   PB_SIM_call SIM_ask_nc_axes_of_mtool
   if { $mom_sim_result < $mom_sim_num_machine_axes } {
      set mom_sim_num_machine_axes $mom_sim_result
   }


  # Additional angle to index tool turret on Z-X plane for sub-spindle
  # When necessary, this angle can be specified in the ____map function or
  # other command that surely gets executed.
   global mom_sim_add_turret_angle
   set mom_sim_add_turret_angle 0.0

  # Force some parms to be defined
   set map_machine_ok 1
   if { [catch { PB_SIM_call PB_CMD_vnc____map_machine_tool_axes }] } {
      set map_machine_ok 0
   }


  #------------------------------
  # Map machine tool assignments
  #------------------------------
  # Account for multi-spindle case.
   if { [PB_SIM_call PB_CMD_vnc__ask_number_of_active_channels] > 1 ||\
        [PB_SIM_call PB_CMD_vnc__ask_number_of_lathe_spindles] > 1 } {

      if { !$map_machine_ok } {
        # Fetch machine kinematics from model
         if { [string match "TRUE" [PB_SIM_call MOM_validate_machine_model]] } {
            PB_SIM_call PB_CMD_vnc__reload_machine_tool_axes
         }
      }

   } else {

      if { [string match "TRUE" [PB_SIM_call MOM_validate_machine_model]] } {
        # Fetch machine kinematics from model
         if { [catch { PB_SIM_call PB_CMD_vnc__reload_machine_tool_axes }] } {
            PB_SIM_call PB_CMD_vnc____map_machine_tool_axes
         }
      }
   }


  # Initialize a null list for other NC codes to be simulated.
  # Actual code list will be defined in PB_CMD_vnc____set_nc_definitions.
  #
   global mom_sim_other_nc_codes
   global mom_sim_other_nc_codes_ex

   set mom_sim_other_nc_codes [list]
   set mom_sim_other_nc_codes_ex [list]


  # Add user's NC data definition.
  #
   if { [llength [info commands "PB_CMD_vnc__set_nc_definitions"]] } {
      PB_SIM_call PB_CMD_vnc__set_nc_definitions
   } else {
      PB_SIM_call PB_CMD_vnc____set_nc_definitions
   }


  # pb800(b) -
  # Load alternate unit setting for VNC
  #
   PB_SIM_call VNC_load_alternate_unit_settings


  # Add more user's NC data definition required for conversion.
  # (Legacy only)
   PB_SIM_call PB_CMD_vnc__fix_nc_definitions


  # Unset Y axis for a lathe, if necessary.
  #
   PB_SIM_call PB_CMD_vnc__unset_Y_axis


  # Validity check for machine tool parameters.
  #
   PB_SIM_call PB_CMD_vnc__validate_machine_tool


  # Nullify ref pos of MTCS
   global mom_sim_pos_mtcs
   VNC_unset_vars  mom_sim_pos_mtcs


  # Logical axes assignments (not from the post?)
  # It works to equate logical names to the physical names.
  #
   global mom_sim_lg_axis mom_sim_nc_axes mom_sim_address

  # Linear axes are commanded by logical names, whereas
  # rotary axes are commanded by physical names.
  #
   set mom_sim_lg_axis(X) X
   set mom_sim_lg_axis(Y) Y
   set mom_sim_lg_axis(Z) Z
   set mom_sim_lg_axis(I) I
   set mom_sim_lg_axis(J) J
   set mom_sim_lg_axis(K) K

  # Unset rotary axes first
   if { [info exists mom_sim_lg_axis(4)] } {
      unset mom_sim_lg_axis(4)
   }
   if { [info exists mom_sim_lg_axis(5)] } {
      unset mom_sim_lg_axis(5)
   }

   set mom_sim_nc_axes [concat $mom_sim_lg_axis(X) $mom_sim_lg_axis(Y) $mom_sim_lg_axis(Z)]

   switch $mom_sim_num_machine_axes {
      4 {
         set mom_sim_lg_axis(4) $mom_sim_mt_axis(4)
         lappend mom_sim_nc_axes $mom_sim_lg_axis(4)
      }
      5 {
         set mom_sim_lg_axis(4) $mom_sim_mt_axis(4)
         set mom_sim_lg_axis(5) $mom_sim_mt_axis(5)
         lappend mom_sim_nc_axes $mom_sim_lg_axis(4) $mom_sim_lg_axis(5)
      }
   }


  # Initialize data for simulation.
  #
   if { ![info exists mom_sim_ug_tool_name] } {
      set mom_sim_ug_tool_name ""
   }

   if { ![info exists mom_sim_tool_loaded] } {
      set mom_sim_tool_loaded ""
   }

   if { ![info exists mom_sim_tool_junction] } {
      set mom_sim_tool_junction "$mom_sim_spindle_jct"
   }

  #<911-2008> pb602(e) - Do not assume curr_jct (only defined in PB_CMD_vnc__offset_tool_jct)
  #                      Also see changes in PB_CMD_vnc__create_tmp_jct
  if 0 {
   if { ![info exists mom_sim_curr_jct_matrix] } {
      lappend mom_sim_curr_jct_matrix 1.0 0.0 0.0  0.0 1.0 0.0  0.0 0.0 1.0
   }

   if { ![info exists mom_sim_curr_jct_origin] } {
      lappend mom_sim_curr_jct_origin 0.0 0.0 0.0
   }
  }

   for { set i 0 } { $i < 8 } { incr i } {
      if { ![info exists mom_sim_pos($i)] } {
         set mom_sim_pos($i) 0
      }
   }


  # pb600 -
  # - Restore machine to the previously visited state, if any.
  #
   if { [info exists mom_sim_nc_register($mom_sim_mt_axis(X))] } {
      set mom_sim_pos(0) $mom_sim_nc_register($mom_sim_mt_axis(X))
   }
   if { [info exists mom_sim_nc_register($mom_sim_mt_axis(Z))] } {
      set mom_sim_pos(2) $mom_sim_nc_register($mom_sim_mt_axis(Z))
   }
   if { [info exists mom_sim_mt_axis(Y)] } {
      if { [info exists mom_sim_nc_register($mom_sim_mt_axis(Y))] } {
         set mom_sim_pos(1) $mom_sim_nc_register($mom_sim_mt_axis(Y))
      }
   }
   if { $mom_sim_num_machine_axes > 3 } {
      if { [info exists mom_sim_nc_register($mom_sim_mt_axis(4))] } {
         set mom_sim_pos(3) $mom_sim_nc_register($mom_sim_mt_axis(4))
      }
   }
   if { $mom_sim_num_machine_axes > 4 } {
      if { [info exists mom_sim_nc_register($mom_sim_mt_axis(5))] } { 
         set mom_sim_pos(4) $mom_sim_nc_register($mom_sim_mt_axis(5))
      }
   }


  # Initialize controller's states, in case, not set in a VNC by
  # PB_CMD_vnc____set_nc_definitions
  #
   global mom_sim_vnc_msg_prefix
   if { ![info exists mom_sim_vnc_msg_prefix] } {
      set mom_sim_vnc_msg_prefix  "VNC_MSG::"
   }

   global mom_sim_spindle_max_rpm mom_sim_spindle_speed
   if { ![info exists mom_sim_spindle_max_rpm] } {
      set mom_sim_spindle_max_rpm 0
   }
   if { ![info exists mom_sim_spindle_speed] } {
      set mom_sim_spindle_speed 0
   }

   global mom_sim_cycle_spindle_axis
   if { ![info exists mom_sim_cycle_spindle_axis] } {
      set mom_sim_cycle_spindle_axis 2
   }

   if { ![info exists mom_sim_nc_register(POWER_ON_WCS)] } {
      set mom_sim_nc_register(POWER_ON_WCS) 0
   }

   if { ![info exists mom_sim_nc_register(WCS)] } {
      set mom_sim_nc_register(WCS) $mom_sim_nc_register(POWER_ON_WCS)
   }

   if { ![info exists mom_sim_nc_register(MOTION)] } {
      set mom_sim_nc_register(MOTION) RAPID
   }
   if { ![info exists mom_sim_nc_register(INPUT)] } {
      set mom_sim_nc_register(INPUT) ABS
   }
   if { ![info exists mom_sim_nc_register(STROKE_LIMIT)] } {
      set mom_sim_nc_register(STROKE_LIMIT) ON
   }
   if { ![info exists mom_sim_nc_register(CUTCOM)] } {
      set mom_sim_nc_register(CUTCOM) OFF
   }
   if { ![info exists mom_sim_nc_register(TL_ADJUST)] } {
      set mom_sim_nc_register(TL_ADJUST) OFF
   }
   if { ![info exists mom_sim_nc_register(SCALE)] } {
      set mom_sim_nc_register(SCALE) OFF
   }
   if { ![info exists mom_sim_nc_register(MACRO_MODAL)] } {
      set mom_sim_nc_register(MACRO_MODAL) OFF
   }
   if { ![info exists mom_sim_nc_register(WCS_ROTATE)] } {
      set mom_sim_nc_register(WCS_ROTATE) OFF
   }
   if { ![info exists mom_sim_nc_register(CYCLE)] } {
      set mom_sim_nc_register(CYCLE) OFF
   }
   if { ![info exists mom_sim_nc_register(CYCLE_RETURN)] } {
      set mom_sim_nc_register(CYCLE_RETURN) INIT_LEVEL
   }
   if { ![info exists mom_sim_nc_register(RETURN_HOME)] } {
      set mom_sim_nc_register(RETURN_HOME) 0
   }
   if { ![info exists mom_sim_nc_register(FROM_HOME)] } {
      set mom_sim_nc_register(FROM_HOME) 0
   }
   if { ![info exists mom_sim_nc_register(MAIN_OFFSET)] } {
      set mom_sim_nc_register(MAIN_OFFSET) [list 0.0 0.0 0.0 0.0 0.0]
   }
   if { ![info exists mom_sim_nc_register(LOCAL_OFFSET)] } {
      set mom_sim_nc_register(LOCAL_OFFSET) [list 0.0 0.0 0.0 0.0 0.0]
   }
   if { ![info exists mom_sim_nc_register(WORK_OFFSET)] } {
      set mom_sim_nc_register(WORK_OFFSET) [PB_SIM_call VNC_map_to_machine_offsets\
                                                        $mom_sim_wcs_offsets($mom_sim_nc_register(WCS))]
   }

   if { ![info exists mom_sim_nc_register(SPINDLE_DIRECTION)] } {
      set mom_sim_nc_register(SPINDLE_DIRECTION) OFF
   }
   if { ![info exists mom_sim_nc_register(SPINDLE_MODE)] } {
      set mom_sim_nc_register(SPINDLE_MODE) REV_PER_MIN
   }
   if { ![info exists mom_sim_nc_register(S)] } {
      set mom_sim_nc_register(S) 0
   }
   if { ![info exists mom_sim_nc_register(FEED_MODE)] } {
      switch $mom_sim_nc_register(UNIT) {
         MM {
            set mom_sim_nc_register(FEED_MODE) MM_PER_MIN
         }
         default {
            set mom_sim_nc_register(FEED_MODE) INCH_PER_MIN
         }
      }
   }
   if { ![info exists mom_sim_nc_register(F)] } {
      set mom_sim_nc_register(F) 0
   }

   global mom_sim_rapid_dogleg
   if { ![info exists mom_sim_rapid_dogleg] } {
      set mom_sim_rapid_dogleg  0
   }


#>>>>>
  # Initialize subspindle activation state
  #
   if { ![info exists mom_sim_nc_register(CROSS_MACHINING)] } {
      set mom_sim_nc_register(CROSS_MACHINING) 0
   }

  # Initialize machine mode
  #
   global mom_sim_machine_type
   if { [string match "*wedm*" $mom_sim_machine_type] } {
      set mom_sim_nc_register(MACHINE_MODE) WEDM
   } elseif { [string match "*lathe*" $mom_sim_machine_type] } {
      set mom_sim_nc_register(MACHINE_MODE) TURN
   } else {
      set mom_sim_nc_register(MACHINE_MODE) MILL
   }

  # Initialize plane code
  #
   if { [string match "TURN" $mom_sim_nc_register(MACHINE_MODE)] } {
      set mom_sim_nc_register(PLANE) ZX
   } else {
      set mom_sim_nc_register(PLANE) XY
   }

  # Initialize CSYS state
  #
   global mom_sim_csys_set
   if { ![info exists mom_sim_csys_set] } {
      set mom_sim_csys_set  0
   }

  # Initialize tool offsets
  #
   global mom_sim_tool_offset_used mom_sim_tool_offset
   if { ![info exists mom_sim_tool_offset_used] } {
      set mom_sim_tool_offset_used 0
   }

   if { ![info exists mom_sim_tool_offset] } {
      set mom_sim_tool_offset(0) 0.0
      set mom_sim_tool_offset(1) 0.0
      set mom_sim_tool_offset(2) 0.0
   }

   global mom_sim_pivot_distance
   if { ![info exists mom_sim_pivot_distance] } {
      set mom_sim_pivot_distance 0.0
   }

  # Set default N/C output unit.  This value will be used
  # when no output unit function is specified in the N/C code.
  # It's also used as the intial mode when controller is reset.
  #
   set mom_sim_nc_register(DEF_UNIT)       $mom_sim_nc_register(UNIT)

  #-----------------------------------
  # Set the machine tool driver units.
  #-----------------------------------
   if { [string match "MM" $mom_sim_nc_register(UNIT)] } {
      PB_SIM_call SIM_set_mtd_units "MM"
   } else {
      PB_SIM_call SIM_set_mtd_units "INCH"
   }

  #--------------------------------
  # Set rotary axis direction mode.
  #--------------------------------
   global mom_sim_4th_axis_direction mom_sim_5th_axis_direction
   global mom_sim_4th_axis_max_limit mom_sim_5th_axis_max_limit
   global mom_sim_4th_axis_min_limit mom_sim_5th_axis_min_limit
   global mom_sim_4th_axis_has_limits mom_sim_5th_axis_has_limits

   if { [info exists mom_sim_lg_axis(4)] } {
      if { ![string match " " $mom_sim_4th_axis_direction] } {
         if { [string match "MAGNITUDE_DETERMINES_DIRECTION" $mom_sim_4th_axis_direction] } {

           # pb751(a) - Added "mom_sim_5th_axis_has_limits" condition
            if { [EQ_is_zero $mom_sim_4th_axis_min_limit] &&\
                 [EQ_is_equal $mom_sim_4th_axis_max_limit 360.0] &&\
                !$mom_sim_4th_axis_has_limits } {

               set mom_sim_4th_axis_direction "ALWAYS_SHORTEST"
            }
         }
         PB_SIM_call SIM_set_axis_rotary_dir_mode $mom_sim_lg_axis(4) $mom_sim_4th_axis_direction
      }
   }

   if { [info exists mom_sim_lg_axis(5)] } {
      if { ![string match " " $mom_sim_5th_axis_direction] } {
         if { [string match "MAGNITUDE_DETERMINES_DIRECTION" $mom_sim_5th_axis_direction] } {

           # pb751(a) - Added "mom_sim_5th_axis_has_limits" condition
            if { [EQ_is_zero $mom_sim_5th_axis_min_limit] &&\
                 [EQ_is_equal $mom_sim_5th_axis_max_limit 360.0] &&\
                !$mom_sim_5th_axis_has_limits } {

               set mom_sim_5th_axis_direction "ALWAYS_SHORTEST"
            }
         }
         PB_SIM_call SIM_set_axis_rotary_dir_mode $mom_sim_lg_axis(5) $mom_sim_5th_axis_direction
      }
   }


  #--------------------------------------------------------
  # Define max feed rate for each axis, if not yet defined.
  #--------------------------------------------------------
   global mom_sim_rapid_feed_rate
   global mom_sim_rapid_feed mom_sim_rapid_unit
   global mom_sim_spindle_max_rpm


   if { ![info exists mom_sim_rapid_feed(X)] } {
      set mom_sim_rapid_feed(X) $mom_sim_rapid_feed_rate
   }
   if { ![info exists mom_sim_rapid_feed(Y)] } {
      set mom_sim_rapid_feed(Y) $mom_sim_rapid_feed_rate
   }
   if { ![info exists mom_sim_rapid_feed(Z)] } {
      set mom_sim_rapid_feed(Z) $mom_sim_rapid_feed_rate
   }
   if { ![info exists mom_sim_rapid_feed(4)] } {
      set mom_sim_rapid_feed(4) $mom_sim_rapid_feed_rate
   }
   if { ![info exists mom_sim_rapid_feed(5)] } {
      set mom_sim_rapid_feed(5) $mom_sim_rapid_feed_rate
   }

   if { ![info exists mom_sim_rapid_unit(X)] } {
      set mom_sim_rapid_unit(X) $mom_sim_nc_register(FEED_MODE)
   }
   if { ![info exists mom_sim_rapid_unit(Y)] } {
      set mom_sim_rapid_unit(Y) $mom_sim_nc_register(FEED_MODE)
   }
   if { ![info exists mom_sim_rapid_unit(Z)] } {
      set mom_sim_rapid_unit(Z) $mom_sim_nc_register(FEED_MODE)
   }
   if { ![info exists mom_sim_rapid_unit(4)] } {
      set mom_sim_rapid_unit(4) REV_PER_MIN
   }
   if { ![info exists mom_sim_rapid_unit(5)] } {
      set mom_sim_rapid_unit(5) REV_PER_MIN
   }


  # Default max rpm
   global mom_sim_default_spindle_max_rpm
   if { ![info exists mom_sim_default_spindle_max_rpm] } {
      set mom_sim_default_spindle_max_rpm 10000
   }

   if { ![info exists mom_sim_spindle_max_rpm] || ![EQ_is_gt $mom_sim_spindle_max_rpm 0.0] } {
      set mom_sim_spindle_max_rpm $mom_sim_default_spindle_max_rpm
   }


  #------------------------------------------------
  # Initialize parameters required by Sync Manager
  # for the components involved in this driver.
  #
   global mom_multi_channel_mode

   if { [info exists mom_multi_channel_mode] } {


      global mom_sim_delay_one_block
      set mom_sim_delay_one_block 0


     # In case sync manager is not yet initialized...
      global mom_sim_sync_manager_initialized
      if { ![info exists mom_sim_sync_manager_initialized] } {
         PB_SIM_call PB_CMD_vnc__start_of_program
      }


      global mom_sim_result mom_sim_result1
      PB_SIM_call SIM_ask_nc_axes_of_mtool

      set axes_list {X Y Z 4 5}
      foreach axis $axes_list {
         if { [info exists mom_sim_mt_axis($axis)] } {
            if { [lsearch $mom_sim_result1 $mom_sim_mt_axis($axis)] >= 0 } {
               PB_SIM_call SIM_mach_max_axis_rapid_velocity $mom_sim_mt_axis($axis) $mom_sim_rapid_feed($axis) $mom_sim_rapid_unit($axis)
            }
         }
      }
   }


  #-------------------------------------------------------------------------------
  # Initialize reference CSYS w.r.t the MTCS junction with the machine model.
  # - This also establishes the machine datum csys.
  # - This matrix is also used to define the 1st version of the main & local csys.
  #
   if { $mom_sim_csys_set == 0 } {

     # Fix legacy offsets (5 elements -> 6 elements)
     # set n_wcs [array size mom_sim_wcs_offsets]
      set n_wcs [array names mom_sim_wcs_offsets]

      foreach i $n_wcs {
         if { [llength $mom_sim_wcs_offsets($i)] == 5 } {
            set mom_sim_wcs_offsets($i) [PB_SIM_call VNC_map_from_machine_offsets $mom_sim_wcs_offsets($i)]
         }
      }


     # Offsets between MTCS and the main WCS
      global mom_sim_machine_zero_offsets
      if { ![info exists mom_sim_machine_zero_offsets] } {
         set mom_sim_machine_zero_offsets  [list 0.0 0.0 0.0]
      }


     # Define all Work Coordinate Systems
     #
      PB_SIM_call PB_CMD_vnc__define_wcs
   }


  # Initialize cut data type
   global mom_sim_cut_data_type
   if { ![info exists mom_sim_cut_data_type] } {
      set mom_sim_cut_data_type "CENTERLINE"
   }


  # Reset this var for each vnc
   VNC_unset_vars mom_sim_nc_register(TOOL_CHANGED)


  # Translate pivot jct to the plane of spindle axis
  # - We only need to do this for machines with rotary head.
  #
   global mom_sim_machine_type mom_sim_mt_axis
   global mom_sim_spindle_jct mom_sim_pivot_jct

   if { ![info exists mom_sim_pivot_jct] || [string match "" $mom_sim_pivot_jct] } {
return
   }


  # Turning tools can also be mounted into B-head.
  # pb603(a) -
   if { ![string match "*wedm*" $mom_sim_machine_type] } {

      if { [info exists mom_sim_mt_axis(4)] } {

         SIM_ask_axis_dof_junction $mom_sim_mt_axis(4)

         set axis_dof [expr abs($mom_sim_result1)]

         SIM_ask_init_junction_xform $mom_sim_pivot_jct

         set i 0
         foreach v $mom_sim_result {
            set pivot_jct_matrix($i) $v
            incr i
         }
         foreach v $mom_sim_result1 {
            set pivot_jct_matrix($i) $v
            incr i
         }

         set spindle_org [SIM_transform_point {0.0 0.0 0.0} $mom_sim_spindle_jct $mom_sim_pivot_jct]

         set x 0.0
         set y 0.0
         set z 0.0
         switch $axis_dof {
            1 {
               set x [lindex $spindle_org 0]
            }
            2 {
               set y [lindex $spindle_org 1]
            }
            default {
               set z [lindex $spindle_org 2]
            }
         }

         MTX3_xform_csys 0 0 0 $x $y $z pivot_jct_matrix

         set idx [string first "@" $mom_sim_pivot_jct]
         if { $idx >= 0 } {
            set pivot_comp [string range $mom_sim_pivot_jct 0 [expr $idx - 1]]
         } else {
            set pivot_comp $mom_sim_spindle_comp
         }

         set jct_origin [list]
         for { set i 9 } { $i < 12 } { incr i } {
            lappend jct_origin $pivot_jct_matrix($i)
         }

         set jct_matrix [list]
         for { set i 0 } { $i < 9 } { incr i } {
            lappend jct_matrix $pivot_jct_matrix($i)
         }

        # Redefine a pivot jct just for tracking NC codes
         set mom_sim_pivot_jct __SIM_PIVOT_JCT

         PB_SIM_call SIM_ask_is_junction_exist __SIM_PIVOT_JCT

         if { $mom_sim_result == 1 } {
            PB_SIM_call SIM_delete_junction $mom_sim_pivot_jct
         }

         eval PB_SIM_call SIM_create_junction $mom_sim_pivot_jct $pivot_comp $jct_origin $jct_matrix
      }
   } ;# Translate pivot
}




