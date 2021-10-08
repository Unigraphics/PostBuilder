########################### Virtual NC Controller ############################
#                                                                            #
# Copyright (c) 1999/2000/2001/2002/2003/2004/2005/2006/2007/2008/2009/2010  #
#                                                                            #
#                           Siemens PLM Software                             #
#                                                                            #
##############################################################################
#                       V N C _ C O M M O N _ V 7 5 0 . T C L
##############################################################################
#
# DESCRIPTION
#
#   This file contains handlers for incremental VNC conversion.
#
##############################################################################


#=============================================================
proc PB_CMD_vnc__ask_head_spindle_axis { } {
#=============================================================
# This command retuns the head spindle axis, if any.
# - Existence of the axis can be interrogated from the kin model per
#   componemt classified as _DEVICE_HOLDER_ON_HEAD

# pb602(c) -

   global mom_sim_head_spindle_axis
   global mom_sim_head_spindle_axis_defined

   if { [info exists mom_sim_head_spindle_axis_defined] } {
return
   }


   global mom_sim_result

   set sim_result_saved $mom_sim_result

   set mom_sim_result ""

   set machine_base MACHINE_BASE
   PB_SIM_call SIM_ask_machine_base_component

   if { ![string match "" $mom_sim_result] } {
      set machine_base $mom_sim_result
   }


   set mom_sim_head_spindle_axis_defined 0


   VNC_unset_vars  COMP_class

   set class _DEVICE_HOLDER_ON_HEAD
   set mode  SYSTEM

   set cmd_name "PB_SIM_cycle_comp_of_class"

   if { ![catch { $cmd_name COMP_class $machine_base $class $mode }] } {
      if { [info exists COMP_class($class,comp)] } {
         if [catch { PB_SIM_call SIM_ask_axis_of_component $COMP_class($class,comp) } res] {

            set mom_sim_result $sim_result_saved
return
         }
      }
   }

   if { [string length $mom_sim_result] &&\
        [string compare "0" $mom_sim_result] &&\
        [string compare _NONE $mom_sim_result] } {

      set mom_sim_head_spindle_axis $mom_sim_result
      set mom_sim_head_spindle_axis_defined 1
   }


   set mom_sim_result $sim_result_saved
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

  # pb601(a) -
  # Search for R word if the leader of Address R is R.
  # >>> Not sure this will always work!
   VNC_parse_nc_word mom_sim_o_buffer $mom_sim_address(R,leader) 2 PB_CMD_vnc__R_code


  # pb602(a) - Search for IJK to override R mode
  #         ==> R-in-use flag can be still in effect resulted from previous (turn) post

   if { [info exists mom_sim_nc_register(R_IN_USE)] } {

      if { [info exists mom_sim_nc_block] } {
         set tmp_o_buff $mom_sim_nc_block
      } else {
         set tmp_o_buff $mom_sim_o_buffer
      }

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

      set r $mom_sim_nc_register(R)
      set a [expr atan2($dy,$dx)]
      set b [expr acos(sqrt($dx*$dx + $dy*$dy) / (2.0*$r))]

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
               if { [EQ_is_equal $mom_sim_pos(0) $mom_sim_prev_pos(0)] && [EQ_is_equal $mom_sim_pos(1) $mom_sim_prev_pos(1)] } {

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
proc PB_CMD_vnc__cycle_move { } {
#=============================================================
  global mom_sim_lg_axis
  global mom_sim_pos mom_sim_prev_pos
  global mom_sim_cycle_rapid_to_pos
  global mom_sim_cycle_feed_to_pos
  global mom_sim_cycle_retract_to_pos
  global mom_sim_cycle_mode
  global mom_sim_nc_register


   set mom_sim_pos(0) $mom_sim_prev_pos(0)
   set mom_sim_pos(1) $mom_sim_prev_pos(1)
   set mom_sim_pos(2) $mom_sim_prev_pos(2)


   if { $mom_sim_cycle_mode(start_block) } {

     global mom_sim_cycle_spindle_axis
     global mom_sim_cycle_rapid_to_dist
     global mom_sim_cycle_feed_to_dist
     global mom_sim_cycle_retract_to_dist
     global mom_sim_cycle_entry_pos

      set rapid_to_pos(0) $mom_sim_nc_register(X)
      set rapid_to_pos(1) $mom_sim_nc_register(Y)
      set rapid_to_pos(2) $mom_sim_nc_register(Z)

      if { [expr $mom_sim_cycle_entry_pos($mom_sim_cycle_spindle_axis) > $rapid_to_pos($mom_sim_cycle_spindle_axis)] } {
         set mom_sim_cycle_entry_pos($mom_sim_cycle_spindle_axis) $rapid_to_pos($mom_sim_cycle_spindle_axis)
      }

      set rapid_to_pos($mom_sim_cycle_spindle_axis)  $mom_sim_cycle_rapid_to_pos($mom_sim_cycle_spindle_axis)

      if { [string match "*R -*" $mom_sim_cycle_mode(rapid_to)] } {
         if { [string match "*Distance*" $mom_sim_cycle_mode(rapid_to)] } {
            set rapid_to_pos($mom_sim_cycle_spindle_axis) \
                [expr $mom_sim_cycle_entry_pos($mom_sim_cycle_spindle_axis) + $mom_sim_cycle_rapid_to_dist]
         }
      }
      set mom_sim_cycle_rapid_to_pos(0) $rapid_to_pos(0)
      set mom_sim_cycle_rapid_to_pos(1) $rapid_to_pos(1)
      set mom_sim_cycle_rapid_to_pos(2) $rapid_to_pos(2)

      set feed_to_pos(0) $mom_sim_nc_register(X)
      set feed_to_pos(1) $mom_sim_nc_register(Y)
      set feed_to_pos(2) $mom_sim_nc_register(Z)
      set feed_to_pos($mom_sim_cycle_spindle_axis)  $mom_sim_cycle_feed_to_pos($mom_sim_cycle_spindle_axis)

      switch $mom_sim_cycle_mode(feed_to) {
         "Distance" {
            set feed_to_pos($mom_sim_cycle_spindle_axis) \
                [expr $mom_sim_cycle_entry_pos($mom_sim_cycle_spindle_axis) - $mom_sim_cycle_feed_to_dist]
         }
      }
      set mom_sim_cycle_feed_to_pos(0) $feed_to_pos(0)
      set mom_sim_cycle_feed_to_pos(1) $feed_to_pos(1)
      set mom_sim_cycle_feed_to_pos(2) $feed_to_pos(2)

      set retract_to_pos(0) $mom_sim_nc_register(X)
      set retract_to_pos(1) $mom_sim_nc_register(Y)
      set retract_to_pos(2) $mom_sim_nc_register(Z)
      set retract_to_pos($mom_sim_cycle_spindle_axis)  $mom_sim_cycle_retract_to_pos($mom_sim_cycle_spindle_axis)

      if { [string match "K -*" $mom_sim_cycle_mode(retract_to)] } {
         if { [string match "*Distance*" $mom_sim_cycle_mode(retract_to)] } {
            set retract_to_pos($mom_sim_cycle_spindle_axis) \
                [expr $mom_sim_cycle_entry_pos($mom_sim_cycle_spindle_axis) + $mom_sim_cycle_retract_to_dist]
         }
      }
      set mom_sim_cycle_retract_to_pos(0) $retract_to_pos(0)
      set mom_sim_cycle_retract_to_pos(1) $retract_to_pos(1)
      set mom_sim_cycle_retract_to_pos(2) $retract_to_pos(2)
   }

  # Preserve current position & motion type
   for { set i 0 } { $i < 3 } { incr i } {
      set sim_pos_save($i) $mom_sim_pos($i)
   }
   set sim_motion_type_save $mom_sim_nc_register(MOTION)


   set mom_sim_nc_register(MOTION) LINEAR

  # pb750(c) - Retain current last position
   set last_x $mom_sim_nc_register(LAST_X)
   set last_y $mom_sim_nc_register(LAST_Y)
   set last_z $mom_sim_nc_register(LAST_Z)


  # Clear off rotary move, if any, @ current pos
  #
   global mom_sim_cycle_spindle_axis

  # pb750(i) -
  # pb750(d) - Handle retract-to of "G98/G99" mode properly
   if { [string match "*CYCLE_RETURN_AUTO" $mom_sim_cycle_mode(retract_to)] } {
      set mom_sim_pos($mom_sim_cycle_spindle_axis) $mom_sim_cycle_retract_to_pos($mom_sim_cycle_spindle_axis)
   }

  # To prevent premature Z move
   foreach i {0 1 2} {
     if { $i != $mom_sim_cycle_spindle_axis } {
        set mom_sim_pos($i) $mom_sim_cycle_rapid_to_pos($i)
     }
   }

  # pb750(i) -
   PB_SIM_call VNC_rapid_move


  # Rapid to
    set mom_sim_pos(0) $mom_sim_cycle_rapid_to_pos(0)
    set mom_sim_pos(1) $mom_sim_cycle_rapid_to_pos(1)
    set mom_sim_pos(2) $mom_sim_cycle_rapid_to_pos(2)

  # pb750(i) -
   PB_SIM_call VNC_rapid_move


  # Feed to
    set mom_sim_pos(0) $mom_sim_cycle_feed_to_pos(0)
    set mom_sim_pos(1) $mom_sim_cycle_feed_to_pos(1)
    set mom_sim_pos(2) $mom_sim_cycle_feed_to_pos(2)

   PB_SIM_call VNC_linear_move


  # Retract to
    set mom_sim_pos(0) $mom_sim_cycle_retract_to_pos(0)
    set mom_sim_pos(1) $mom_sim_cycle_retract_to_pos(1)
    set mom_sim_pos(2) $mom_sim_cycle_retract_to_pos(2)

   PB_SIM_call VNC_linear_move


  # pb750(i) - This perhaps should only be done @ cycle-off
  if 0 {
  # Restore registers back to entry (or reference) pos of the cycle.
   global mom_sim_cycle_spindle_axis
   set mom_sim_pos($mom_sim_cycle_spindle_axis) $sim_pos_save($mom_sim_cycle_spindle_axis)
  }

  # Restore last position
   set mom_sim_nc_register(LAST_X) $last_x
   set mom_sim_nc_register(LAST_Y) $last_y
   set mom_sim_nc_register(LAST_Z) $last_z

  # Restore motion type
   set mom_sim_nc_register(MOTION) $sim_motion_type_save
}


#=============================================================
proc PB_CMD_vnc__cycle_set { } {
#=============================================================
  global mom_sim_o_buffer
  global mom_sim_address mom_sim_pos mom_sim_prev_pos
  global mom_sim_nc_register
  global mom_sim_cycle_mode
  global mom_sim_cycle_rapid_to_pos
  global mom_sim_cycle_feed_to_pos
  global mom_sim_cycle_retract_to_pos
  global mom_sim_cycle_entry_pos
  global mom_sim_cycle_rapid_to_dist
  global mom_sim_cycle_feed_to_dist
  global mom_sim_cycle_retract_to_dist
  global mom_sim_cycle_spindle_axis

  global mom_sim_machine_type
  global mom_sim_4th_axis_plane mom_sim_5th_axis_plane


  # Interrogate tool axis to determine whether principal axis should be reversed.
  # This direction is needed when any of the cycle's parmeters is incremental.

  # Apply mirror factors to axis direction for all cases.
   global mom_sim_x_factor mom_sim_y_factor mom_sim_z_factor

   set axis_direction 1

   if { [string match "*head*" $mom_sim_machine_type] } {
      switch $mom_sim_4th_axis_plane {
         "ZX" {
          # Change axis direction only when it coincides with principal plane direction.
           if { $mom_sim_cycle_spindle_axis == 1 } {
            if { [EQ_is_equal $mom_sim_nc_register(fourth_axis) -90.0] } {
               set axis_direction -1
            }
            set axis_direction [expr $mom_sim_y_factor * $axis_direction]
           }
         }
         "YZ" {
           if { $mom_sim_cycle_spindle_axis == 0 } {
            if { [EQ_is_equal $mom_sim_nc_register(fourth_axis) 90.0] } {
               set axis_direction -1
            }
            set axis_direction [expr $mom_sim_x_factor * $axis_direction]
           }
         }
         "XY" {
           if { $mom_sim_cycle_spindle_axis == 2 } {
            set axis_direction [expr $mom_sim_z_factor * $axis_direction]
           }
         }
      }
   }

   if { [string match "5_axis_dual_head" $mom_sim_machine_type] } {
      switch $mom_sim_5th_axis_plane {
         "ZX" {
           if { $mom_sim_cycle_spindle_axis == 1 } {
            if { [EQ_is_equal $mom_sim_nc_register(fifth_axis) -90.0] } {
               set axis_direction -1
            }
            set axis_direction [expr $mom_sim_y_factor * $axis_direction]
           }
         }
         "YZ" {
           if { $mom_sim_cycle_spindle_axis == 0 } {
            if { [EQ_is_equal $mom_sim_nc_register(fifth_axis) 90.0] } {
               set axis_direction -1
            }
            set axis_direction [expr $mom_sim_x_factor * $axis_direction]
           }
         }
         "XY" {
           if { $mom_sim_cycle_spindle_axis == 2 } {
            set axis_direction [expr $mom_sim_z_factor * $axis_direction]
           }
         }
      }
   }

  # Determine axis direction for XZC mill-turn
   if { [string match "3_axis_mill_turn" $mom_sim_machine_type] } {
      if { $mom_sim_cycle_spindle_axis == 0 } {
         set axis_direction [expr $mom_sim_x_factor * $axis_direction]
      }
   }


  # Grab prev pos as entry pos
   foreach i { 0 1 2 } {
      set mom_sim_cycle_entry_pos($i) $mom_sim_prev_pos($i)
   }


  # nc_register(K_cycle) may never be set, since it's in conflict with nc_register(K).
   if { [info exists mom_sim_nc_register(K)] } {
      set mom_sim_nc_register(K_cycle) $mom_sim_nc_register(K)
   }

   if { ![info exists mom_sim_nc_register(K_cycle)] } {
      set mom_sim_nc_register(K_cycle) 0
   }

   if { ![info exists mom_sim_nc_register(R)] } {
      set mom_sim_nc_register(R) 0
   }

  # Initialize registers in case...
   if { ![info exists mom_sim_nc_register(X)] } {
      set mom_sim_nc_register(X) 0.0
   }
   if { ![info exists mom_sim_nc_register(Y)] } {
      set mom_sim_nc_register(Y) 0.0
   }
   if { ![info exists mom_sim_nc_register(Z)] } {
      set mom_sim_nc_register(Z) 0.0
   }

   set mom_sim_cycle_feed_to_pos(0) $mom_sim_nc_register(X)
   set mom_sim_cycle_feed_to_pos(1) $mom_sim_nc_register(Y)
   set mom_sim_cycle_feed_to_pos(2) $mom_sim_nc_register(Z)

   switch $mom_sim_cycle_mode(feed_to) {
      "Distance" {
         set mom_sim_cycle_feed_to_dist [expr abs($mom_sim_nc_register(Z)) * $axis_direction]

         if { $mom_sim_cycle_spindle_axis == 2 } { ;# Z axis
            set mom_sim_cycle_feed_to_pos(2) [expr $mom_sim_pos(2) - $mom_sim_cycle_feed_to_dist]
         } else {
            set mom_sim_cycle_feed_to_pos(2) $mom_sim_pos(2)
         }

        #<08-09-06 gsl> Recalculate top of hole per bottom. May not be needed???
         set mom_sim_cycle_entry_pos($mom_sim_cycle_spindle_axis) \
             [expr $mom_sim_cycle_feed_to_pos($mom_sim_cycle_spindle_axis) + $mom_sim_cycle_feed_to_dist]
      }
   }


  # Initialize rapid-to pos to feed-to pos
   set mom_sim_cycle_rapid_to_pos(0) $mom_sim_cycle_feed_to_pos(0)
   set mom_sim_cycle_rapid_to_pos(1) $mom_sim_cycle_feed_to_pos(1)
   set mom_sim_cycle_rapid_to_pos(2) $mom_sim_cycle_feed_to_pos(2)

   if { [string match "*R -*" $mom_sim_cycle_mode(rapid_to)] } {
      if { [string match "*Distance*" $mom_sim_cycle_mode(rapid_to)] } {
#>>>
        # The 1st hole may have been @ rapid-to pos already.
         set mom_sim_cycle_rapid_to_dist [expr $mom_sim_nc_register(R) * $axis_direction]

         if { [EQ_is_equal $mom_sim_cycle_entry_pos($mom_sim_cycle_spindle_axis) $mom_sim_pos($mom_sim_cycle_spindle_axis)] } {

           #<08-08-06 gsl> May not be needed or a bug
           if 0 {
            set mom_sim_cycle_entry_pos($mom_sim_cycle_spindle_axis) \
                [expr $mom_sim_cycle_entry_pos($mom_sim_cycle_spindle_axis) - $mom_sim_cycle_rapid_to_dist]
           }
         }

         set mom_sim_cycle_rapid_to_pos($mom_sim_cycle_spindle_axis) \
             [expr $mom_sim_cycle_entry_pos($mom_sim_cycle_spindle_axis) + $mom_sim_cycle_rapid_to_dist]

      } else {
         set mom_sim_cycle_rapid_to_pos($mom_sim_cycle_spindle_axis) $mom_sim_nc_register(R)
      }
   }


  # pb600 -
  # - Compensate for no retract-to condition
  #
   if { $axis_direction > 0 } {
      if { $mom_sim_cycle_rapid_to_pos($mom_sim_cycle_spindle_axis) <= $mom_sim_cycle_feed_to_pos($mom_sim_cycle_spindle_axis) } {
         set mom_sim_cycle_rapid_to_pos($mom_sim_cycle_spindle_axis) $mom_sim_cycle_entry_pos($mom_sim_cycle_spindle_axis)
      }
   } elseif { $axis_direction < 0 } {
      if { $mom_sim_cycle_rapid_to_pos($mom_sim_cycle_spindle_axis) >= $mom_sim_cycle_feed_to_pos($mom_sim_cycle_spindle_axis) } {
         set mom_sim_cycle_rapid_to_pos($mom_sim_cycle_spindle_axis) $mom_sim_cycle_entry_pos($mom_sim_cycle_spindle_axis)
      }
   }


  # Initialize retract-to pos
   set mom_sim_cycle_retract_to_pos(0) $mom_sim_cycle_rapid_to_pos(0)
   set mom_sim_cycle_retract_to_pos(1) $mom_sim_cycle_rapid_to_pos(1)
   set mom_sim_cycle_retract_to_pos(2) $mom_sim_cycle_rapid_to_pos(2)

   if { [string match "K*" $mom_sim_cycle_mode(retract_to)] } {
      if { [string match "*Distance*" $mom_sim_cycle_mode(retract_to)] } {
#>>>
        # The 1st hole may have been @ rapid-to pos already.
         set mom_sim_cycle_retract_to_dist [expr abs($mom_sim_nc_register(K_cycle)) * $axis_direction]

         if { [EQ_is_equal $mom_sim_cycle_entry_pos($mom_sim_cycle_spindle_axis) $mom_sim_pos($mom_sim_cycle_spindle_axis)] } {

           #<08-09-06 gsl> Same reason for R word
           if 0 {
            set mom_sim_cycle_entry_pos($mom_sim_cycle_spindle_axis) \
                [expr $mom_sim_cycle_entry_pos($mom_sim_cycle_spindle_axis) - $mom_sim_cycle_retract_to_dist]
           }
         }

         set mom_sim_cycle_retract_to_pos($mom_sim_cycle_spindle_axis) \
             [expr $mom_sim_cycle_entry_pos($mom_sim_cycle_spindle_axis) + $mom_sim_cycle_retract_to_dist]

      } else {
         set mom_sim_cycle_retract_to_pos($mom_sim_cycle_spindle_axis) $mom_sim_nc_register(K_cycle)
      }

   } elseif { [string match "G98/G99*" $mom_sim_cycle_mode(retract_to)] } {

      global mom_sim_nc_func

     # G98 - Retract to last Z before cycle

     # pb750(d) - Handle retract-to of "G98/G99" mode properly
      if { [VNC_parse_nc_word mom_sim_o_buffer $mom_sim_nc_func(CYCLE_RETURN_AUTO) 1] } {
         set mom_sim_cycle_mode(retract_to) "G98/G99 - CYCLE_RETURN_AUTO"
      }

      if { [string match "*CYCLE_RETURN_AUTO" $mom_sim_cycle_mode(retract_to)] } {

         switch $mom_sim_cycle_spindle_axis {
            0 {
               set mom_sim_cycle_retract_to_pos($mom_sim_cycle_spindle_axis) $mom_sim_nc_register(LAST_X)
            }
            1 {
               set mom_sim_cycle_retract_to_pos($mom_sim_cycle_spindle_axis) $mom_sim_nc_register(LAST_Y)
            }
            default {
               set mom_sim_cycle_retract_to_pos($mom_sim_cycle_spindle_axis) $mom_sim_nc_register(LAST_Z)
            }
         }
      }
   }


   if { !$mom_sim_cycle_mode(start_block) } {
      PB_SIM_call PB_CMD_vnc__cycle_move
   }
}


#=============================================================
proc PB_CMD_vnc__define_misc_procs { } {
#=============================================================
 uplevel #0 {

  #-----------------------------------------------------------
  proc VNC_move_machine_linear_axis { axis to_coord args } {
  #-----------------------------------------------------------
  #  axis     : Name of axis in machine model
  #  to_coord : Target position in axis-coordinate
  #  args     : optional feed rate (IPM or MMPM) if specified
  #
     global mom_sim_result mom_sim_rapid_feed_rate


     if { [info exists mom_sim_result] } {
        set __sim_result $mom_sim_result
     }

     SIM_ask_axis_position $axis
     set fr_coord $mom_sim_result

     set delta [expr abs($to_coord - $fr_coord)]

     if { ![EQ_is_zero $delta] } {

        if { [llength $args] == 0 } {
           set feed $mom_sim_rapid_feed_rate
        } else {
           set feed_fpm [lindex $args 0]
           set feed [expr $feed_fpm > $mom_sim_rapid_feed_rate ? $mom_sim_rapid_feed_rate : $feed_fpm]
        }

        if { ![EQ_is_zero $feed] } {
           set time [expr 60.0 * abs($delta / $feed)]
        } else {
           set time 10
        }

        PB_SIM_call SIM_move_linear_axis $time $axis $to_coord
     }

     if { [info exists __sim_result] } {
        set mom_sim_result $__sim_result
     } else {
        unset mom_sim_result
     }
  }

  #-----------------------------------------------------------
  proc VNC_move_machine_rotary_axis { axis to_coord args } {
  #-----------------------------------------------------------
  #  axis     : Name of axis in machine model
  #  to_coord : Target position in axis-coordinate
  #  args     : optional feed rate (DPM) if specified
  #
     global mom_sim_result mom_sim_max_dpm


     if { [info exists mom_sim_result] } {
        set __sim_result $mom_sim_result
     }

     SIM_ask_axis_position $axis
     set fr_coord $mom_sim_result

     set delta [expr abs($to_coord - $fr_coord)]

     if { ![EQ_is_zero $delta] } {

        if { [llength $args] == 0 } {
           set feed $mom_sim_max_dpm
        } else {
           set feed_dpm [lindex $args 0]
           set feed [expr $feed_dpm > $mom_sim_max_dpm ? $mom_sim_max_dpm : $feed_dpm]
        }

        if { ![EQ_is_zero $feed] } {
           set time [expr 60.0 * abs($delta / $feed)]
        } else {
           set time 10
        }

        PB_SIM_call SIM_move_rotary_axis $time $axis $to_coord
     }

     if { [info exists __sim_result] } {
        set mom_sim_result $__sim_result
     } else {
        unset mom_sim_result
     }
  }

  #-----------------------------------------------------------
  proc VNC_output_vnc_msg { message } {
  #-----------------------------------------------------------
     global mom_sim_message

     set mom_sim_message $message
     PB_SIM_call PB_CMD_vnc__output_vnc_msg
  }

  #-----------------------------------------------------------
  proc VNC_rotate_head_spindle_axis { degrees } {
  #-----------------------------------------------------------
  # This command rotates the head spindle axis.
  # - Existence of the axis can be interrogated from the kin model per
  #   componemt classified as _DEVICE_HOLDER_ON_HEAD

  # ==> Comment out next line to active this function for "flash tool" simulation
  return


     global mom_sim_head_spindle_axis

     PB_SIM_call PB_CMD_vnc__ask_head_spindle_axis

     if { [info exists mom_sim_head_spindle_axis] } {
        PB_SIM_call VNC_move_machine_rotary_axis $mom_sim_head_spindle_axis $degrees
        PB_SIM_call SIM_update
     }
  }

  #-----------------------------------------------------------
  proc VNC_string_match { STR TKN } {
  #-----------------------------------------------------------
  # Match 2 string if they both exist
  #
     upvar $STR str
     upvar $TKN tkn

     if { [info exists str] && [info exists tkn] && [string match "$str" "$tkn"] } {
  return 1
     } else {
  return 0
     }
  }

  #-----------------------------------------------------------
  proc VNC_pause_win64 { args } {
  #-----------------------------------------------------------
   global env
   if { [info exists env(PB_SUPPRESS_UGPOST_DEBUG)]  &&  $env(PB_SUPPRESS_UGPOST_DEBUG) == 1 } {
  return
   }

   global gPB
   if { [info exists gPB(PB_disable_VNC_pause)]  &&  $gPB(PB_disable_VNC_pause) == 1 } {
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
    # - A separated process will be created to construct the Tk dialog.
    #   This process will communicate with the main process via the state of a scratch file.
    #   This scratch file will collect the messages that need to be conveyed from the
    #   child process to the main process.
    ######
     global mom_logname

     set pause_file_name "[MOM_ask_env_var UGII_TMP_DIR]/${mom_logname}_mom_pause_[clock clicks].txt"

     if { [file exists $pause_file_name] } {
        file delete -force $pause_file_name
     }

     regsub -all {\\} $cam_aux_dir {/}  cam_aux_dir
     regsub -all { }  $cam_aux_dir {\ } cam_aux_dir

     regsub -all {\\} $pause_file_name {/}  pause_file_name
     regsub -all { }  $pause_file_name {\ } pause_file_name



    ######
    # The assumption at this point is we will always have the scratch file as the 1st
    # argument and optionally the title and message as the 2nd and 3rd arguments
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
          set gPB(PB_disable_VNC_pause) 1
       }
       cancel {
          close $fid
          file delete -force $pause_file_name

          set gPB(PB_disable_VNC_pause) 1
          PB_SIM_call SIM_mtd_reset

          uplevel #0 {
             MOM_abort "*** User Abort *** "
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

  #-----------------------------------------------------------
  proc VNC_pause { args } {
  #-----------------------------------------------------------
   global env
   if { [info exists env(PB_SUPPRESS_UGPOST_DEBUG)]  &&  $env(PB_SUPPRESS_UGPOST_DEBUG) == 1 } {
  return
   }

   global gPB
   if { [info exists gPB(PB_disable_VNC_pause)]  &&  $gPB(PB_disable_VNC_pause) == 1 } {
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

       VNC_pause_win64 $args
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
          set gPB(PB_disable_VNC_pause) 1
       }
       cancel {
          set gPB(PB_disable_VNC_pause) 1
          PB_SIM_call SIM_mtd_reset

          uplevel #0 {
             MOM_abort "*** User Abort *** "
          }
       }
       default { return }
     }
   }
  }

  #-----------------------------------------------------------
  proc VNC_escape_special_chars { s1 } {
  #-----------------------------------------------------------
  # This command is used to preprocess block buffer.
  #
   set s2 ""

   set len [string length $s1]
   for { set i 0 } { $i < $len } { incr i } {

      set c [string index $s1 $i]
      scan "$c" "%c" cv

     # Octal ASCII codes
      #  " = 042
      #  $ = 044
      #  & = 046
      #  ; = 073
      #  [ = 133
      #  \ = 134
      #  ] = 135
      #  { = 173
      #  | = 174
      #  } = 175

     # Do not escape the surrounding quotes, if any.
      if { $i == 0 || $i == [expr $len - 1] } {
         if { $cv == 042 } {
            set s2 "$s2$c"
            continue
         }
      }

      if { $cv == 042  || \
           $cv == 044  || \
           $cv == 046  || \
           $cv == 073  || \
           $cv == 0133 || \
           $cv == 0134 || \
           $cv == 0135 || \
           $cv == 0173 || \
           $cv == 0174 || \
           $cv == 0175 } {

        # Add an escape char
         set s2 "$s2\\"
      }

      set s2 "$s2$c"
   }

  return $s2
  }

  #-----------------------------------------------------------
  proc VNC_update_sim_pos { } {
  #-----------------------------------------------------------
   global mom_sim_pos

   if { ![catch {set pos [PB_SIM_call SIM_ask_last_position_zcs]} ] } {
      set mom_sim_pos(0) [lindex $pos 0]
      set mom_sim_pos(1) [lindex $pos 1]
      set mom_sim_pos(2) [lindex $pos 2]
   }
  }

  #-----------------------------------------------------------
  proc VNC_set_current_ref_junction { ref_jct } {
  #-----------------------------------------------------------

   PB_SIM_call SIM_set_current_ref_junction $ref_jct

   global mom_sim_current_junction

   if { [info exists mom_sim_current_junction] } {
      if { ![catch {set pos [PB_SIM_call SIM_ask_last_position_zcs]} ] } {
         global mom_sim_pos
         set mom_sim_pos(0) [lindex $pos 0]
         set mom_sim_pos(1) [lindex $pos 1]
         set mom_sim_pos(2) [lindex $pos 2]
      }
   }
  }

  #-----------------------------------------------------------
  proc VNC_unset_procs { args } {
  #-----------------------------------------------------------

     if { [llength $args] == 0 } {
  return
     }

     foreach p $args {
        if { [llength [info commands [string trim $p] ] ] } {
           rename $p ""
        }
     }
  }

  #-----------------------------------------------------------
  proc VNC_unset_vars { args } {
  #-----------------------------------------------------------

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

  #-----------------------------------------------------------
  proc VNC_info { args } {
  #-----------------------------------------------------------
     if { [llength $args] > 0 } {
        set msg [lindex $args 0]
     } else {
        set msg ""
     }
     MOM_output_to_listing_device $msg
  }

  #-----------------------------------------------------------
  proc VNC_parse_nc_word { O_BUFF word flag args } {
  #-----------------------------------------------------------
  # - Reduce buffer & execute callback only
  #   when the requested type of match is found.
  #
  #   Arguments -
  #
  #     BUFFER  : Reference (pointer) to the block buffer
  #               (Normally you pass in "mom_sim_o_buffer" without "$" sign.)
  #               ** At this point, the block sequence number
  #                  has been removed from "mom_sim_o_buffer".
  #
  #     word    : token (string pattern) to be identified
  #
  #     flag    : 0 = Any match, do not remove token
  #               1 = Exact match
  #               2 = Extended match
  #               3 = Any match
  #
  #     args    : Optional callback command string to be executed
  #               when a match has been found.
  #
  #   Return -
  #               0 = No match
  #               1 = Match found
  #              -1 = Match found but callback not found
  #
    upvar $O_BUFF o_buff

     set tmp_buff $o_buff

     set status [VNC_parse_nc_block tmp_buff $word]

     if { $status > 0 } {
        if { $flag == 0  ||  $flag == 3  ||  $status == $flag } {
          # Trim buffer
           if { $flag != 0 } {
              set o_buff $tmp_buff
           }

          # Execute callback
           if { [llength $args] > 0 } {
              set exec_cb [string trim [lindex $args 0]]
           } else {
              set exec_cb ""
           }

           if { ![string match "" $exec_cb] } {
              if { [llength [info commands "$exec_cb"]] } {
                 eval "$exec_cb"
              } else {
  return -1
              }
           }
  return 1
        }
     }

  return 0
  }

  #-----------------------------------------------------------
  proc  MTX3_xform_csys { a b c x y z CSYS } {
  #-----------------------------------------------------------
     upvar $CSYS csys

  # <Note> a, b, c, x, y & z are measured w.r.t current csys space.
  #
  #                     Rotation about
  #         X                  Y                  Z
  # ----------------   ----------------   ----------------
  #   1     0     0     cosB   0   sinB    cosC -sinC    0
  #   0   cosA -sinA     0     1     0     sinC  cosC    0
  #   0   sinA  cosA   -sinB   0   cosB      0     0     1


    # Validate input data
     if { [EQ_is_zero $a] && [EQ_is_zero $b] && [EQ_is_zero $c] &&\
          [EQ_is_zero $x] && [EQ_is_zero $y] && [EQ_is_zero $z] } {
  return
     }


    #----------
    # Ratation
    #----------
     set xa [expr +1*$a]
     set yb [expr +1*$b]
     set zc [expr +1*$c]

     array set mm [array get csys]

     if { ![EQ_is_zero $a] || ![EQ_is_zero $b] || ![EQ_is_zero $c] } {

       # Rotate about X
       #
        set mx(0) 1;            set mx(1) 0;            set mx(2) 0
        set mx(3) 0;            set mx(4) [cosD $xa];   set mx(5) [-sinD $xa]
        set mx(6) 0;            set mx(7) [sinD $xa];   set mx(8) [cosD $xa]

       # Rotate about Y
       #
        set my(0) [cosD $yb];   set my(1) 0;            set my(2) [sinD $yb]
        set my(3) 0;            set my(4) 1;            set my(5) 0
        set my(6) [-sinD $yb];  set my(7) 0;            set my(8) [cosD $yb]

       # Rotate about Z
       #
        set mz(0) [cosD $zc];   set mz(1) [-sinD $zc];  set mz(2) 0
        set mz(3) [sinD $zc];   set mz(4) [cosD $zc];   set mz(5) 0
        set mz(6) 0;            set mz(7) 0;            set mz(8) 1

        MTX3_multiply  my mx mt
        MTX3_multiply  mz mt ma
        MTX3_transpose ma mt
        MTX3_multiply  mm mt csys
     }

    #-------------
    # Translation
    #-------------
     set u(0) $x;  set u(1) $y;  set u(2) $z
     MTX3_transpose mm ma
     MTX3_vec_multiply u ma v

     set csys(9)  [expr $csys(9)  + $v(0)]
     set csys(10) [expr $csys(10) + $v(1)]
     set csys(11) [expr $csys(11) + $v(2)]

     for { set i 0 } { $i < 12 } { incr i } {
        if { [EQ_is_zero $csys($i)] } {
           set csys($i) 0.0
        }
     }
  }

  #-----------------------------------------------------------
  proc VNC_map_from_machine_offsets { offsets } {
  #-----------------------------------------------------------
  # This function converts a 5-element offsets to a 6-element offsets.
  #

   if { [llength $offsets] == 6 } {
      return $offsets
   }

   global mom_sim_machine_type
   global mom_sim_4th_axis_plane
   global mom_sim_5th_axis_plane

   set xyzabc [list [lindex $offsets 0] [lindex $offsets 1] [lindex $offsets 2] 0.0 0.0 0.0]

   set 4th_index 0
   set 5th_index 0
   set ang4 [lindex $offsets 3]
   set ang5 [lindex $offsets 4]

   if { [string match "4*" $mom_sim_machine_type] } {
      switch $mom_sim_4th_axis_plane {
         "YZ" {
            set 4th_index 3
         }
         "ZX" {
            set 4th_index 4
         }
         "XY" {
            set 4th_index 5
         }
      }
      if { $4th_index > 0 } {
         set xyzabc [lreplace $xyzabc $4th_index $4th_index $ang4]
      }
   }

   if { [string match "5*" $mom_sim_machine_type] } {
      switch $mom_sim_4th_axis_plane {
         "XY" {
            set 4th_index 5
            switch $mom_sim_5th_axis_plane {
               "YZ" {
                  set 5th_index 3
               }
               "ZX" {
                  set 5th_index 4
               }
            }
         }
         "YZ" {
            set 4th_index 3
            switch $mom_sim_5th_axis_plane {
               "XY" {
                  set 5th_index 5
               }
               "ZX" {
                  set 5th_index 4
               }
            }
         }
         "ZX" {
            set 4th_index 4
            switch $mom_sim_5th_axis_plane {
               "XY" {
                  set 5th_index 5
               }
               "YZ" {
                  set 5th_index 3
               }
            }
         }
      }
      if { $4th_index > 0 } {
         set xyzabc [lreplace $xyzabc $4th_index $4th_index $ang4]
      }
      if { $5th_index > 0 } {
         set xyzabc [lreplace $xyzabc $5th_index $5th_index $ang5]
      }
   }

  return $xyzabc
  }

  #-----------------------------------------------------------
  proc VNC_map_to_machine_offsets { offsets } {
  #-----------------------------------------------------------
  # This function converts a 6-element offsets to a 5-element
  # offsets for an orthogonal machine.
  #

   if { [llength $offsets] == 5 } {
      return $offsets
   }

   global mom_sim_machine_type
   global mom_sim_4th_axis_plane
   global mom_sim_5th_axis_plane

   set xyzab [list [lindex $offsets 0] [lindex $offsets 1] [lindex $offsets 2] 0.0 0.0]

   set 4th_index 0
   set 5th_index 0

   if { [string match "4*" $mom_sim_machine_type] } {
      switch $mom_sim_4th_axis_plane {
         "YZ" {
            set 4th_index 3
         }
         "ZX" {
            set 4th_index 4
         }
         "XY" {
            set 4th_index 5
         }
      }
      if { $4th_index > 0 } {
         set ang4 [lindex $offsets $4th_index]
         set xyzab [lreplace $xyzab 3 3 $ang4]
      }
   }

   if { [string match "5*" $mom_sim_machine_type] } {
      switch $mom_sim_4th_axis_plane {
         "XY" {
            set 4th_index 5
            switch $mom_sim_5th_axis_plane {
               "YZ" {
                  set 5th_index 3
               }
               "ZX" {
                  set 5th_index 4
               }
            }
         }
         "YZ" {
            set 4th_index 3
            switch $mom_sim_5th_axis_plane {
               "XY" {
                  set 5th_index 5
               }
               "ZX" {
                  set 5th_index 4
               }
            }
         }
         "ZX" {
            set 4th_index 4
            switch $mom_sim_5th_axis_plane {
               "XY" {
                  set 5th_index 5
               }
               "YZ" {
                  set 5th_index 3
               }
            }
         }
      }
      if { $4th_index > 0 } {
         set ang4 [lindex $offsets $4th_index]
         set xyzab [lreplace $xyzab 3 3 $ang4]
      }
      if { $5th_index > 0 } {
         set ang5 [lindex $offsets $5th_index]
         set xyzab [lreplace $xyzab 4 4 $ang5]
      }
   }

  return $xyzab
  }

 } ;# uplevel
}


#=============================================================
proc PB_CMD_vnc__M_misc_code { } {
#=============================================================
  global mom_sim_nc_register
  global mom_sim_nc_func


   set codes_list [list]

   set var_list {mom_sim_nc_func(PROG_STOP)\
                 mom_sim_nc_func(PROG_OPSTOP)\
                 mom_sim_nc_func(PROG_END)\
                 mom_sim_nc_func(TOOL_CHANGE)\
                 mom_sim_nc_func(PROG_STOP_REWIND)}

   foreach var $var_list {
     if { [info exists $var] } {
       lappend codes_list [set $var]
     }
   }

   global mom_sim_o_buffer

   foreach code $codes_list {

      if { [VNC_parse_nc_word mom_sim_o_buffer $code 1] } {

         if { [VNC_string_match mom_sim_nc_func(PROG_STOP)         code] } {

         } elseif { [VNC_string_match mom_sim_nc_func(PROG_OPSTOP) code] } {
           # pb750(e) - Prvent movement caused by this code
            global mom_sim_motion_begun
            set mom_sim_motion_begun 0

         } elseif { [VNC_string_match mom_sim_nc_func(PROG_END)    code] } {

           # Reset following functions on NC controller to the initial state.
           # (Fanuc System 9 Series)
           #
           #  G22 - Store stroke limit function ON
           #  G40 - Cutcom OFF
           #  G49 - Tool length adjust OFF
           #  G50 - Scaling OFF
           #  G54 - Work coordinate system 1
           #  G64 - Cutting mode
           #  G67 - Macro modal call cancel
           #  G69 - Coordinate system rotation OFF
           #  G80 - Canned cycle cancel
           #  G98 - Return to initial level (cycle)

            PB_SIM_call VNC_reset_controller

         } elseif { [VNC_string_match mom_sim_nc_func(TOOL_CHANGE)      code] } {

            PB_SIM_call VNC_tool_change

         } elseif { [VNC_string_match mom_sim_nc_func(PROG_STOP_REWIND) code] } {

            PB_SIM_call VNC_rewind_stop_program

         } else {
         }

         break
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
         lappend coord_list $mom_sim_lg_axis(4)  $mom_sim_pos(3)
      set pattern [expr $pattern + 10]
      }
   }
   if { [info exists mom_sim_lg_axis(5)] } {
      if { [expr $mom_sim_pos(4) != $mom_sim_prev_pos(4)] } {
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
      1 { ;# Pure 5th axis rotation -

         PB_SIM_call VNC_move_machine_rotary_axis $mom_sim_mt_axis(5) $mom_sim_pos(4)
         set pattern 0
      }

      10 { ;# Pure 4th axis rotation -

         PB_SIM_call VNC_move_machine_rotary_axis $mom_sim_mt_axis(4) $mom_sim_pos(3)
         set pattern 0
      }

      11 { ;# Pure compound rotation -

         PB_SIM_call VNC_move_machine_rotary_axis $mom_sim_mt_axis(4) $mom_sim_pos(3)
         PB_SIM_call VNC_move_machine_rotary_axis $mom_sim_mt_axis(5) $mom_sim_pos(4)
         set pattern 0
      }
   }


   if { [expr $pattern > 0] } {

     # Force rotary direction
      global mom_sim_5th_axis_has_limits
      if { [info exists mom_sim_lg_axis(5)] } {
         if { !$mom_sim_5th_axis_has_limits } {
            PB_SIM_call SIM_set_axis_rotary_dir_mode $mom_sim_lg_axis(5) "ALWAYS_SHORTEST"
         }
      }

      eval PB_SIM_call VNC_move_linear_zcs RAPID $coord_list


     # In case tool is not yet activated...
      global mom_sim_tool_loaded
      if { ![string match "" [string trim $mom_sim_tool_loaded]] } {
         PB_SIM_call SIM_activate_tool $mom_sim_tool_loaded
      }
      PB_SIM_call SIM_update


     # Force rotary direction
      if { [info exists mom_sim_lg_axis(5)] } {
         if { !$mom_sim_5th_axis_has_limits } {
            global mom_sim_5th_axis_direction
            if { ![string match "" [string trim $mom_sim_5th_axis_direction] ] } {
               PB_SIM_call SIM_set_axis_rotary_dir_mode $mom_sim_lg_axis(5) $mom_sim_5th_axis_direction

               global mom_sim_result
               PB_SIM_call SIM_normalize_rotary_axis $mom_sim_mt_axis(5) NORM_180
               PB_SIM_call SIM_ask_axis_position $mom_sim_mt_axis(5)
               if { [EQ_is_zero $mom_sim_result] } {
                  set mom_sim_result 0.0
               }
               set mom_sim_pos(4) $mom_sim_result
               PB_SIM_call VNC_move_machine_rotary_axis $mom_sim_mt_axis(5) $mom_sim_pos(4)
               unset mom_sim_result
            }
         }
      }
   }

   PB_SIM_call SIM_update
   PB_SIM_call VNC_update_sim_pos

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




