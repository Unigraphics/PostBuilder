########################### Virtual NC Controller ############################
#                                                                            #
# Copyright (c) 1999/2000/2001/2002/2003/2004/2005/2006/2007/2008,           #
#                                                                            #
#                           Siemens PLM Software                             #
#                                                                            #
##############################################################################
#                       V N C _ C O M M O N _ V 6 0 1 . T C L
##############################################################################
#
# DESCRIPTION
#
#   This file contains handlers for incremental VNC conversion.
#
##############################################################################

#=============================================================
proc PB_CMD_vnc__G_adjust_code { } {
#=============================================================
  global mom_sim_nc_register
  global mom_sim_nc_func


   set codes_list [list]

   set var_list {mom_sim_nc_func(TL_ADJUST_PLUS)\
                 mom_sim_nc_func(TL_ADJUST_MINUS)\
                 mom_sim_nc_func(TL_ADJUST_CANCEL)}

   foreach var $var_list {
     if { [info exists $var] } {
       lappend codes_list [set $var]
     }
   }

   global mom_sim_o_buffer
   foreach code $codes_list {

      if { [VNC_parse_nc_word mom_sim_o_buffer $code 1] } {

         if { [VNC_string_match mom_sim_nc_func(TL_ADJUST_PLUS) code] } {

           # When there's been a tool change, reset ref junction.
           # We may need to retrieve the actual tool length, if any, from H register.

            set mom_sim_nc_register(TL_ADJUST) PLUS

         } elseif { [VNC_string_match mom_sim_nc_func(TL_ADJUST_MINUS) code] } {

            set mom_sim_nc_register(TL_ADJUST) MINUS

         } elseif { [VNC_string_match mom_sim_nc_func(TL_ADJUST_CANCEL) code] } {

            set mom_sim_nc_register(TL_ADJUST) OFF

           # pb601(d) - Turn off linearization
            PB_SIM_call SIM_set_linearization OFF
         }

         break
      }
   }


  # Comp tool length when needed.
   if { $mom_sim_nc_register(TL_ADJUST) != "OFF" } {

      global mom_sim_current_junction
      if { [info exists mom_sim_current_junction] } {
         PB_SIM_call VNC_set_current_ref_junction $mom_sim_current_junction
      }

     # Restore ref jct to tool
      global mom_sim_tool_junction mom_sim_current_tool_junction mom_sim_current_junction
      set mom_sim_tool_junction "$mom_sim_current_tool_junction"
      set mom_sim_current_junction "$mom_sim_tool_junction"
   }

   if { [info exists mom_sim_nc_register(TOOL_CHANGED)] } {
      unset mom_sim_nc_register(TOOL_CHANGED)
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

         PB_SIM_call SIM_ask_number_of_child_components $base_comp
         set n_comp $mom_sim_result

         for { set i 0 } { $i < $n_comp } { incr i } {

            PB_SIM_call SIM_ask_nth_child_component $base_comp $i
            set comp $mom_sim_result

            if { $class_type == "SYSTEM" } {
               PB_SIM_call SIM_is_component_of_system_class $comp $class
            } else {
               PB_SIM_call SIM_is_component_of_user_class $comp $class
            }

            if { $mom_sim_result == 1 } {

               switch $class {

                  _DEVICE {
                     PB_SIM_call SIM_ask_number_of_channels_at_component $comp
                     set n_ch $mom_sim_result

                     for { set idx 0 } { $idx < $n_ch } { incr idx } {

                        PB_SIM_call SIM_ask_nth_channel_at_component $comp $idx
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
                    # Potential problem - K-comp can be renamed to become different from actual tool name.
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

   if { ![catch { SIM_ask_number_of_channels }] } {
      if { $mom_sim_result == 1 } {
return 1
      }
   } else {
return 1
   }


   global mom_sim_active_channels

   if { [info exists mom_sim_active_channels] } {
return [llength $mom_sim_active_channels]
   }



   set mom_sim_result ""

   set machine_base MACHINE_BASE
   PB_SIM_call SIM_ask_machine_base_component

   if { ![string match "" $mom_sim_result] } {
      set machine_base $mom_sim_result
   }


   VNC_unset_vars  COMP_class

   set class _DEVICE
   set mode  SYSTEM

   if { ![catch { PB_SIM_cycle_comp_of_class COMP_class $machine_base $class $mode }] } {
      if { [info exists COMP_class(active_chan)] } {
         set mom_sim_active_channels $COMP_class(active_chan)
return [llength $COMP_class(active_chan)]
      }
   }

return 1
}


#=============================================================
proc PB_CMD_vnc__ask_number_of_lathe_spindles { } {
#=============================================================
# This function cycles through the kinematic model to determine
# the number of K-components classified as _LATHE_SPINDLE.
#
# pb601(j) - Removed definition of PB_SIM_cycle_comp_of_class from this command

   global mom_sim_result

   global mom_sim_lathe_spindles

   if { [info exists mom_sim_lathe_spindles] } {
return [llength $mom_sim_lathe_spindles]
   }


   set mom_sim_result ""

   set machine_base MACHINE_BASE
   PB_SIM_call SIM_ask_machine_base_component

   if { ![string match "" $mom_sim_result] } {
      set machine_base $mom_sim_result
   }


   VNC_unset_vars  COMP_class

   set class _LATHE_SPINDLE
   set mode  SYSTEM

   if { ![catch { PB_SIM_cycle_comp_of_class COMP_class $machine_base $class $mode }] } {
      if { [info exists COMP_class($class,comp)] } {
         set mom_sim_lathe_spindles $COMP_class($class,comp)
return [llength $COMP_class($class,comp)]
      }
   }

return 0
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
               set helix_pitch [expr 2*$mom_sim_PI*$dz/$mom_sim_helix_pitch]
            }
         }

         if { [string match "" $helix_pitch] } {

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

         } else {

            set helix_pitch "P $helix_pitch"

            eval PB_SIM_call SIM_move_helical_zcs $dir 0 0 $mom_sim_lg_axis(Y) $mom_sim_pos(1) $mom_sim_lg_axis(Z) $mom_sim_pos(2)\
                                                           $mom_sim_lg_axis(J) $j $mom_sim_lg_axis(K) $k $helix_pitch
         }
      }

      "ZX" {

        # Detect helical condition
         if { [info exists mom_sim_helix_pitch] && ![EQ_is_zero $mom_sim_helix_pitch] } {
            set dz [expr $mom_sim_pos(1) - $mom_sim_prev_pos(1)]
            if { ![EQ_is_zero $dz] } {
               set helix_pitch [expr 2*$mom_sim_PI*$dz/$mom_sim_helix_pitch]
            }
         }

         if { [string match "" $helix_pitch] } {

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

         } else {

            set helix_pitch "P $helix_pitch"

            eval PB_SIM_call SIM_move_helical_zcs 0 $dir 0 $mom_sim_lg_axis(Z) $mom_sim_pos(2) $mom_sim_lg_axis(X) $mom_sim_pos(0)\
                                                           $mom_sim_lg_axis(K) $k $mom_sim_lg_axis(I) $i $helix_pitch
         }
      }

      default {

        # Detect helical condition
         if { [info exists mom_sim_helix_pitch] && ![EQ_is_zero $mom_sim_helix_pitch] } {
            set dz [expr $mom_sim_pos(2) - $mom_sim_prev_pos(2)]
            if { ![EQ_is_zero $dz] } {
               set helix_pitch [expr 2*$mom_sim_PI*$dz/$mom_sim_helix_pitch]
            }
         }

         if { [string match "" $helix_pitch] } {

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

            eval PB_SIM_call SIM_move_circular_zcs 0 0 $dir $mom_sim_lg_axis(X) $mom_sim_pos(0) $mom_sim_lg_axis(Y) $mom_sim_pos(1)\
                                                            $mom_sim_lg_axis(I) $i $mom_sim_lg_axis(J) $j
         } else {

           # Problem with helix move handling
           if 0 { ;# It doesn't seem to work as documented.
            if [EQ_is_lt $helix_pitch [expr 2*$mom_sim_PI]] {
               set helix_pitch "$mom_sim_lg_axis(Z) $mom_sim_pos(2)"
            } else {
               set helix_pitch "$mom_sim_lg_axis(Z) $mom_sim_pos(2) P $helix_pitch"
            }
           }

            set helix_pitch "P $helix_pitch"

            eval PB_SIM_call SIM_move_helical_zcs 0 0 $dir $mom_sim_lg_axis(X) $mom_sim_pos(0) $mom_sim_lg_axis(Y) $mom_sim_pos(1)\
                                                           $mom_sim_lg_axis(I) $i $mom_sim_lg_axis(J) $j $helix_pitch
         }
      }
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

   set mom_sim_message "TOOL_TYPE==$mom_tool_type"
   PB_SIM_call PB_CMD_vnc__output_vnc_msg

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
      if [info exists mom_sim_spindle_group] {
         PB_SIM_call SIM_assign_channel_to_spindle $mom_sim_result1 $mom_sim_spindle_group
      }

      PB_SIM_call PB_CMD_vnc__set_speed
   }
  }
}


#=============================================================
proc PB_CMD_vnc__send_dogs_home { } {
#=============================================================
  global mom_sim_mt_axis
  global mom_sim_num_machine_axes
  global mom_sim_nc_register
  global mom_sim_result mom_sim_result1


  # Make sure the polar mode is OFF.
   PB_SIM_call SIM_set_linearization OFF


  # Determine the axes that need to move per intermediate pt specified.
   set move_X 0
   set move_Y 0
   set move_Z 0
   set move_4 0
   set move_5 0

   PB_SIM_call SIM_ask_nc_axes_of_mtool


   if { [info exists mom_sim_nc_register(REF_INT_PT_X)] } {
      if { [info exists mom_sim_mt_axis(X)] } {
         if { [lsearch $mom_sim_result1 "$mom_sim_mt_axis(X)"] >= 0 } {
            set move_X 1
         }
      }
   }
   if { [info exists mom_sim_nc_register(REF_INT_PT_Y)] } {
      if { [info exists mom_sim_mt_axis(Y)] } {
         if { [lsearch $mom_sim_result1 "$mom_sim_mt_axis(Y)"] >= 0 } {
            set move_Y 1
         }
      }
   }
   if { [info exists mom_sim_nc_register(REF_INT_PT_Z)] } {
      if { [info exists mom_sim_mt_axis(Z)] } {
         if { [lsearch $mom_sim_result1 "$mom_sim_mt_axis(Z)"] >= 0 } {
            set move_Z 1
         }
      }
   }

   if { $mom_sim_num_machine_axes > 3 } {
      if { [info exists mom_sim_nc_register(REF_INT_PT_4)] } {
         set move_4 1
      }
   }

   if { $mom_sim_num_machine_axes > 4 } {
      if { [info exists mom_sim_nc_register(REF_INT_PT_5)] } {
         set move_5 1
      }
   }


  # Establish machine home position in MTCS for the 1st time.
   global mom_sim_pos_mtcs
   global mom_sim_lg_axis
   global mom_sim_spindle_jct mom_sim_current_junction
   global mom_sim_pivot_jct

  # Make use of pivot junction
   if { [info exists mom_sim_pivot_jct] } {
      PB_SIM_call SIM_set_current_ref_junction $mom_sim_pivot_jct
   } else {
      PB_SIM_call SIM_set_current_ref_junction $mom_sim_spindle_jct
   }

  # To prevent ref jct being reset to tool tip in sim_motion
   global mom_sim_tool_junction mom_sim_current_tool_junction
   global mom_sim_current_junction    
   set mom_sim_current_tool_junction "$mom_sim_tool_junction"
   set mom_sim_tool_junction "$mom_sim_current_junction"


  # Keep track of current position
   PB_SIM_call VNC_update_sim_pos


  # Set RAPID mode
   PB_SIM_call VNC_set_feedrate_mode RAPID

   set time 1

  # Establish ref pt
   if { ![info exists mom_sim_pos_mtcs(0)] } {
      if $move_X {
         PB_SIM_call SIM_move_linear_axis 1 $mom_sim_mt_axis(X) [lindex $mom_sim_nc_register(REF_PT) 0]
         set ref_pt [PB_SIM_call SIM_ask_last_position_mtcs]
         set mom_sim_pos_mtcs(0) [lindex $ref_pt 0]
      }
   }
   if { ![info exists mom_sim_pos_mtcs(1)] } {
      if $move_Y {
         if { [info exists mom_sim_mt_axis(Y)] } {
            PB_SIM_call SIM_move_linear_axis 1 $mom_sim_mt_axis(Y) [lindex $mom_sim_nc_register(REF_PT) 1]
            set ref_pt [PB_SIM_call SIM_ask_last_position_mtcs]
            set mom_sim_pos_mtcs(1) [lindex $ref_pt 1]
         }
      }
   }
   if { ![info exists mom_sim_pos_mtcs(2)] } {
      if $move_Z {
         PB_SIM_call SIM_move_linear_axis 1 $mom_sim_mt_axis(Z) [lindex $mom_sim_nc_register(REF_PT) 2]
         set ref_pt [PB_SIM_call SIM_ask_last_position_mtcs]
         set mom_sim_pos_mtcs(2) [lindex $ref_pt 2]
      }
   }

  # Always zero rotary axes ???
   if { $mom_sim_num_machine_axes > 3 } {
     # set move_4 1
   }

   if { $mom_sim_num_machine_axes > 4 } {
     # set move_5 1
   }


   set coord_list [list]
   if $move_X {
      lappend coord_list $mom_sim_lg_axis(X) $mom_sim_pos_mtcs(0)
   }
   if $move_Y {
      lappend coord_list $mom_sim_lg_axis(Y) $mom_sim_pos_mtcs(1)
   }
   if $move_Z {
      lappend coord_list $mom_sim_lg_axis(Z) $mom_sim_pos_mtcs(2)
   }


   if { [llength $coord_list] > 0 } {
      eval PB_SIM_call SIM_move_linear_mtcs $coord_list
   }


global mom_sim_message
set mom_sim_message "REF PT >$mom_sim_nc_register(REF_PT)<"
PB_CMD_vnc__send_message


  # If a rotary axis is limitless, only unwind it to the modulu of 360!
  #
   global mom_sim_num_machine_axes mom_sim_mt_axis
   global mom_sim_4th_axis_has_limits mom_sim_5th_axis_has_limits
   global mom_sim_4th_axis_direction mom_sim_5th_axis_direction

   global mom_sim_pos

   global mom_sim_4th_axis_max_limit mom_sim_4th_axis_min_limit
   global mom_sim_5th_axis_max_limit mom_sim_5th_axis_min_limit

   if { [expr $mom_sim_num_machine_axes > 4] } {

      if $move_5 {

         if $mom_sim_5th_axis_has_limits {

            set mom_sim_pos(4) 0

         } else {

            PB_SIM_call SIM_ask_axis_position $mom_sim_mt_axis(5)

            if { ![EQ_is_equal $mom_sim_result $mom_sim_pos(4)] } {

               PB_SIM_call SIM_normalize_rotary_axis $mom_sim_mt_axis(5) NORM_180
               set mom_sim_pos(4) 0.0

            } else {

               if { [expr $mom_sim_pos(4) < 0.0] } {
                  set sign -1
               } else {
                  set sign 1
               }

               set rem [expr fmod($mom_sim_pos(4),360)]
               if { [expr abs($rem) > 180] } {
                  set mom_sim_pos(4) [expr $mom_sim_pos(4) + $sign*360 - $rem]
               } else {
                  set mom_sim_pos(4) [expr $mom_sim_pos(4) - $rem]
               }

               if { [EQ_is_zero $mom_sim_pos(4)] } {
                  set mom_sim_pos(4) 0.0
               }
            }
         }

         PB_SIM_call SIM_set_interpolation OFF

         if { [EQ_is_lt $mom_sim_pos(4) $mom_sim_5th_axis_min_limit] ||\
              [EQ_is_gt $mom_sim_pos(4) $mom_sim_5th_axis_max_limit] } {

            PB_SIM_call SIM_normalize_rotary_axis $mom_sim_mt_axis(5) NORM_180
            PB_SIM_call SIM_ask_axis_position $mom_sim_mt_axis(5)
            set mom_sim_pos(4) $mom_sim_result
         }

         PB_SIM_call SIM_move_rotary_axis 5 $mom_sim_mt_axis(5) $mom_sim_pos(4)
         PB_SIM_call SIM_set_interpolation ON
      }
   }

   if { [expr $mom_sim_num_machine_axes > 3] } {

      if $move_4 {

         if $mom_sim_4th_axis_has_limits {

            set mom_sim_pos(3) 0

         } else {

            PB_SIM_call SIM_ask_axis_position $mom_sim_mt_axis(4)

            if { ![EQ_is_equal $mom_sim_result $mom_sim_pos(3)] } {

               PB_SIM_call SIM_normalize_rotary_axis $mom_sim_mt_axis(4) NORM_180
               set mom_sim_pos(3) 0.0

            } else {

               if { [expr $mom_sim_pos(3) < 0.0] } {
                  set sign -1
               } else {
                  set sign 1
               }
               set rem [expr fmod($mom_sim_pos(3),360)]
               if { [expr abs($rem) > 180] } {
                  set mom_sim_pos(3) [expr $mom_sim_pos(3) + $sign*360 - $rem]
               } else {
                  set mom_sim_pos(3) [expr $mom_sim_pos(3) - $rem]
               }

               if { [EQ_is_zero $mom_sim_pos(3)] } {
                  set mom_sim_pos(3) 0.0
               }
            }
         }

         PB_SIM_call SIM_set_interpolation OFF

         if { [EQ_is_lt $mom_sim_pos(3) $mom_sim_4th_axis_min_limit] ||
              [EQ_is_gt $mom_sim_pos(3) $mom_sim_4th_axis_max_limit] } {

            PB_SIM_call SIM_normalize_rotary_axis $mom_sim_mt_axis(4) NORM_180
            PB_SIM_call SIM_ask_axis_position $mom_sim_mt_axis(4)
            set mom_sim_pos(3) $mom_sim_result
         }

         PB_SIM_call SIM_move_rotary_axis 5 $mom_sim_mt_axis(4) $mom_sim_pos(3)
         PB_SIM_call SIM_set_interpolation ON
      }
   }


   PB_SIM_call SIM_update


 # pb601(e) - It seems to be needed for MS NT4200 kit, otherwise lower turret doesn't move properly.
 #            This was deemed to cause prematured change of tracking jct and disabled in pb600.
 if 1 {
  # pb501 -
  # PB_SIM_call SIM_set_current_ref_junction $mom_sim_current_junction

  # Restore current tool ref jct
   global mom_sim_tool_junction mom_sim_current_tool_junction
   global mom_sim_current_junction
   if { [info exists mom_sim_current_tool_junction] } {
      set mom_sim_tool_junction "$mom_sim_current_tool_junction"
      set mom_sim_current_junction "$mom_sim_tool_junction"
   }

  # Restore tracking point back to tool tip
   PB_SIM_call SIM_set_current_ref_junction $mom_sim_current_junction
 }


  # Keep track of current position
   PB_SIM_call VNC_update_sim_pos


  # Zero Y for lathe mode
   if { [string match "TURN" $mom_sim_nc_register(MACHINE_MODE)] } {
      set mom_sim_pos(1) 0
   }


  # Zero all other axes
   set mom_sim_pos(5) 0
   set mom_sim_pos(6) 0
   set mom_sim_pos(7) 0
}


#=============================================================
proc PB_CMD_vnc__set_param_per_msg { } {
#=============================================================
# This function may not be executed in a standalone NC file
# simulation. Parameters defined here will need to be set
# some place else.
#
  global mom_sim_msg_key mom_sim_msg_word


VNC_output_debug_msg "VNC_MSG - key:$mom_sim_msg_key  word:$mom_sim_msg_word"


  #-------------------------
  # Execute user's function
  #-------------------------
   PB_SIM_call PB_CMD_vnc____set_param_per_msg


   global mom_sim_tool_number mom_sim_tool_data

   switch $mom_sim_msg_key {

      "CUT_DATA_TYPE" {
         global mom_sim_cut_data_type
         set mom_sim_cut_data_type $mom_sim_msg_word
      }

      "CONTACT_TRACKING_TYPE" {
         global mom_sim_contact_tracking_type
         set mom_sim_contact_tracking_type $mom_sim_msg_word
      }

      "CONTACT_TRACKING_DIAMETER" {
         global mom_sim_tool_cutcom_offset
         set mom_sim_tool_cutcom_offset [expr $mom_sim_msg_word / 2]
      }

      "CONTACT_TRACKING_DISTANCE" {
         global mom_sim_tool_adjust_offset
         set mom_sim_tool_adjust_offset $mom_sim_msg_word
      }

      "HELIX_PITCH" {
        # pb601(c) -
         global mom_sim_PI
         global mom_sim_helix_pitch
         set mom_sim_helix_pitch "$mom_sim_msg_word"
      }

      "HELIX_PITCH_TYPE" {
         global mom_sim_helix_pitch_type
         set mom_sim_helix_pitch_type "$mom_sim_msg_word"
      }

      "HELIX_OUTPUT_MODE" {
         global mom_sim_helix_output_mode
         set mom_sim_helix_output_mode "$mom_sim_msg_word"
      }

      "SPINDLE_DIRECTION" {
         global mom_sim_spindle_direction
         set mom_sim_spindle_direction "$mom_sim_msg_word"
      }

      "SPINDLE_MODE" {
         global mom_sim_spindle_mode
         global mom_sim_nc_register

         switch $mom_sim_msg_word {
            RPM { set mom_sim_msg_word REV_PER_MIN }
         }
         set mom_sim_spindle_mode $mom_sim_msg_word
         set mom_sim_nc_register(SPINDLE_MODE) $mom_sim_spindle_mode
      }

      "SPINDLE_MAX_RPM" {
         global mom_sim_spindle_max_rpm

        # Set maximum spindle speed to controller's default.
         global mom_sim_default_spindle_max_rpm
         if { [EQ_is_gt $mom_sim_msg_word 0.0] } {
            set mom_sim_spindle_max_rpm "$mom_sim_msg_word"
         } else {
            set mom_sim_spindle_max_rpm $mom_sim_default_spindle_max_rpm
         }
      }

      "SPINDLE_SPEED" {
         global mom_sim_spindle_speed mom_sim_spindle_mode
         set mom_sim_spindle_speed "$mom_sim_msg_word"

         PB_SIM_call PB_CMD_vnc__set_speed
      }

      "TOOL_NUMBER" {
         set mom_sim_tool_number "$mom_sim_msg_word"

         global mom_sim_tool_change
         set mom_sim_tool_change 1

         global mom_sim_tool_carrier_id
         if { [info exists mom_sim_tool_carrier_id] } {
            set mom_sim_tool_data($mom_sim_tool_number,carrier_id) "\"$mom_sim_tool_carrier_id\""
         }
      }

      "TOOL_NAME" {
         global mom_sim_ug_tool_name
         set mom_sim_ug_tool_name "$mom_sim_msg_word"

        # Capture tool data in an array.
         set mom_sim_tool_data($mom_sim_tool_number,name) $mom_sim_ug_tool_name
      }

      "TOOL_TYPE" {
         global mom_sim_tool_type
         set mom_sim_tool_type "$mom_sim_msg_word"

        # Capture tool type
         if { [string match "MILL*" [string toupper $mom_sim_tool_type]] } {
            set type MILL
         } elseif { [string match "DRILL*" [string toupper $mom_sim_tool_type]] } {
            set type DRILL
         } else {
            set type TURN
         }
         set mom_sim_tool_data($mom_sim_tool_number,type) $type
      }

      "TOOL_OFFSET" {
         global mom_sim_tool_offset_used
         set mom_sim_tool_offset_used "$mom_sim_msg_word"

         set mom_sim_tool_data($mom_sim_tool_number,offset_used) $mom_sim_tool_offset_used
      }

      "TOOL_X_OFF" {
         global mom_sim_tool_offset
         set mom_sim_tool_offset(0) "$mom_sim_msg_word"

         set mom_sim_tool_data($mom_sim_tool_number,x_off) $mom_sim_tool_offset(0)
      }

      "TOOL_Y_OFF" {
         global mom_sim_tool_offset
         set mom_sim_tool_offset(1) "$mom_sim_msg_word"

         set mom_sim_tool_data($mom_sim_tool_number,y_off) $mom_sim_tool_offset(1)
      }

      "TOOL_Z_OFF" {
         global mom_sim_tool_offset
         set mom_sim_tool_offset(2) "$mom_sim_msg_word"

         set mom_sim_tool_data($mom_sim_tool_number,z_off) $mom_sim_tool_offset(2)
      }

      "TOOL_CARRIER_ID" {
         global mom_sim_tool_carrier_id
         set mom_sim_tool_carrier_id "$mom_sim_msg_word"

         if { [info exists mom_sim_tool_number] } {
            set mom_sim_tool_data($mom_sim_tool_number,carrier_id) "\"$mom_sim_tool_carrier_id\""
         }
      }

      "SPINDLE_GROUP" {
         global mom_sim_spindle_group
         set mom_sim_spindle_group "$mom_sim_msg_word"
      }

      "TOOL_POCKET_ID" {
         global mom_sim_tool_pocket_id
         set mom_sim_tool_pocket_id "$mom_sim_msg_word"

         set mom_sim_tool_data($mom_sim_tool_number,pocket_id) "\"$mom_sim_tool_pocket_id\""
      }

      "TOOL_DIAMETER" {
         global mom_sim_tool_diameter
         set mom_sim_tool_diameter "$mom_sim_msg_word"

         global mom_sim_cut_data_type
         if { [info exists mom_sim_cut_data_type] &&\
              [string match "CONTACT_CONTOUR" $mom_sim_cut_data_type] } {
            global mom_sim_contact_tracking_type
            if { [string match "BOTTOM" $mom_sim_contact_tracking_type] } {
               global mom_sim_tool_cutcom_offset
               set mom_sim_tool_cutcom_offset [expr $mom_sim_tool_diameter / 2]
            }
         }

         set mom_sim_tool_data($mom_sim_tool_number,diameter) $mom_sim_tool_diameter
      }

      "TOOL_CUTCOM_REG" {
         global mom_sim_tool_cutcom_register
         set mom_sim_tool_cutcom_register "$mom_sim_msg_word"

        # Register cutcom offset
         global mom_sim_tool_cutcom_offset

         if { ![info exists mom_sim_tool_cutcom_offset] } {
            set mom_sim_tool_cutcom_offset 0.0
         }

         global mom_sim_tool_cutcom_data

         set mom_sim_tool_cutcom_data($mom_sim_tool_cutcom_register) $mom_sim_tool_cutcom_offset

         set mom_sim_tool_data($mom_sim_tool_number,cutcom_register) $mom_sim_tool_cutcom_register
      }

      "TOOL_ADJUST_REG" {
         global mom_sim_tool_adjust_register
         set mom_sim_tool_adjust_register "$mom_sim_msg_word"

        # Register length offset
         global mom_sim_tool_adjust_offset

         if { ![info exists mom_sim_tool_adjust_offset] } {
            set mom_sim_tool_adjust_offset 0.0
         }

         global mom_sim_tool_adjust_data

         set mom_sim_tool_adjust_data($mom_sim_tool_adjust_register) $mom_sim_tool_adjust_offset

         set mom_sim_tool_data($mom_sim_tool_number,adjust_register) $mom_sim_tool_adjust_register
      }

      "HEAD_NAME" {
         global mom_sim_machine_head
         set mom_sim_machine_head "$mom_sim_msg_word"
      }

      "POST_NAME" {
         global mom_sim_post_name
         global mom_sim_vnc_handler_loaded

         set mom_sim_post_name "$mom_sim_msg_word"

         set new_vnc_file [string trim ${mom_sim_post_name}_vnc.tcl]
         set new_vnc_file [join [split $new_vnc_file \\] /]

         if { [string compare [string trim $mom_sim_vnc_handler_loaded] $new_vnc_file] } {
            uplevel #0 {
               source ${mom_sim_post_name}_vnc.tcl
            }

            PB_SIM_call PB_CMD_vnc__init_sim_vars
         }
      }

      "CYCLE_SPINDLE_AXIS" {
         global mom_sim_cycle_spindle_axis
         set mom_sim_cycle_spindle_axis "$mom_sim_msg_word"
      }

      "CSYS_FIXTURE_OFFSET" {
         global mom_sim_fixture_offset
         set mom_sim_fixture_offset "$mom_sim_msg_word"
      }

      default {
      }
   }


  # Grab CSYS_MTX_'s
  #
   global mom_sim_csys_matrix mom_sim_csys_set
   global mom_sim_csys_data

   global mom_sim_fixture_offset
   if { ![info exists mom_sim_fixture_offset] } {
      set mom_sim_fixture_offset 0
   }


   if { [string match "CSYS_MTX_*" $mom_sim_msg_key] } {
      set tokens [split $mom_sim_msg_key _]
      set idx [lindex $tokens 2]

      set mom_sim_csys_matrix($idx) "$mom_sim_msg_word"

     # Store CSYS matrix
      set mom_sim_csys_data($mom_sim_fixture_offset,$idx) "$mom_sim_msg_word"


     # When csys is completely defined, map and set ZCS junction for simulation.
      if { $idx == 11 } {

        #++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
        # -- We don't want to override G68.1 CSYS configuration
        #    that has been defined per NC code instead of MCS object.
        #++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
         if { ![info exists mom_sim_nc_register(CSYS_ROTATION)] } {

            PB_SIM_call PB_CMD_vnc__set_kinematics
            set mom_sim_csys_set 1

           # Signal a new CSYS is set (See M304 for sub-spindle)
            global mom_sim_csys_origin_initial
            set mom_sim_csys_origin_initial 1
         }
      }
   }


  # Grab NURBS data
  #
   global mom_sim_nurbs_start
   global mom_sim_nurbs_order
   global mom_sim_nurbs_knot_count
   global mom_sim_nurbs_knots
   global mom_sim_nurbs_point_count
   global mom_sim_nurbs_points
   global mom_sim_nurbs_point_end_index

   if { [string match "NURBS_START" $mom_sim_msg_key] } {
      set mom_sim_nurbs_start 0
   }

   if { [string match "NURBS_ORDER" $mom_sim_msg_key] } {
      set mom_sim_nurbs_order $mom_sim_msg_word
   }

   if { [string match "NURBS_KNOT_COUNT" $mom_sim_msg_key] } {
      set mom_sim_nurbs_knot_count $mom_sim_msg_word
      set mom_sim_nurbs_knots [list]
   }

   if { [string match "NURBS_POINT_COUNT" $mom_sim_msg_key] } {
      set mom_sim_nurbs_point_count $mom_sim_msg_word
      set mom_sim_nurbs_points [list]
      set mom_sim_nurbs_point_end_index [expr $mom_sim_nurbs_point_count - 1]
   }

   if { [string match "NURBS_KNOTS*" $mom_sim_msg_key] } {
      lappend mom_sim_nurbs_knots $mom_sim_msg_word
   }

  # Info of control points is the last set of parameters passed from a NURBS event.
  # (See PB_CMD_vnc__pass_nurbs_data)
  #
   if { [string match "NURBS_POINTS*" $mom_sim_msg_key] } {
      lappend mom_sim_nurbs_points $mom_sim_msg_word

     # When the control points list is completed, set off simulation.
      if { [string match "*($mom_sim_nurbs_point_end_index,Z)*" $mom_sim_msg_key] } {
         global mom_sim_nc_register
         set mom_sim_nc_register(MOTION) NURBS

         set mom_sim_nurbs_start 1
         PB_SIM_call PB_CMD_vnc__sim_motion

         VNC_unset_vars  mom_sim_nurbs_start
      }
   }


  # Nullify msg key
   set mom_sim_msg_key ""
   set mom_sim_msg_word ""
}


#=============================================================
proc PB_CMD_vnc__start_polar_motion { } {
#=============================================================
# This function alters motion's sim positions for polar simulation.
# Polar mode should have been initiated when certain N/C code
# has been encounterred.
#

   global mom_sim_polar_mode

   if { [info exists mom_sim_polar_mode] && $mom_sim_polar_mode > 0 } {

     # Always turn it on here, incase it's off
      PB_SIM_call SIM_set_linearization ON

      if { $mom_sim_polar_mode == 2 } {

         PB_SIM_call PB_CMD_vnc__linearize_polar_motion

       return
      }


      global mom_sim_pos
      global mom_sim_prev_pos

      global mom_sim_lg_axis
      global mom_sim_nc_register

     # If needed, make Z move first
      if { ![EQ_is_equal $mom_sim_pos(2) $mom_sim_prev_pos(2)] } {
        # PB_SIM_call VNC_move_linear_zcs CUT  $mom_sim_lg_axis(Z) $mom_sim_pos(2)
        # set mom_sim_nc_register(LAST_Z) $mom_sim_pos(2)
      }

     # pb601(f) - Do this first to correct polar mode on sub-spindle
      global mom_sim_x_factor
      if { $mom_sim_x_factor == -1 } {
         set mom_sim_pos(0) [expr $mom_sim_pos(0)*$mom_sim_x_factor]
         set mom_sim_pos(1) [expr $mom_sim_pos(1)*$mom_sim_x_factor]
         set mom_sim_pos(5) [expr $mom_sim_pos(5)*$mom_sim_x_factor]
         set mom_sim_pos(6) [expr $mom_sim_pos(6)*$mom_sim_x_factor]
      }

     # Re-compute X/Y & I/J to compensate initial angle
      global RAD2DEG
      global mom_sim_init_polar_c_angle mom_sim_num_machine_axes

      if { [info exists mom_sim_init_polar_c_angle] && ![EQ_is_zero $mom_sim_init_polar_c_angle] } {

         set c_axis [expr $mom_sim_num_machine_axes - 1]

        # Adjust X/Y
         set R     [expr sqrt( pow($mom_sim_pos($c_axis),2) + pow($mom_sim_pos(0),2) )]
         set THETA [expr atan2( $mom_sim_pos($c_axis), $mom_sim_pos(0) ) + $mom_sim_init_polar_c_angle/$RAD2DEG]
         set mom_sim_pos(0)       [expr $R * cos($THETA)]
         set mom_sim_pos($c_axis) [expr $R * sin($THETA)]

        # Adjust I/J (arc center vector)
         set R     [expr sqrt( pow($mom_sim_pos(6),2) + pow($mom_sim_pos(5),2) )]
         set THETA [expr atan2( $mom_sim_pos(6), $mom_sim_pos(5) ) + $mom_sim_init_polar_c_angle/$RAD2DEG]
         set mom_sim_pos(5) [expr $R * cos($THETA)]
         set mom_sim_pos(6) [expr $R * sin($THETA)]
      }


      global mom_sim_mt_axis
      global mom_sim_polar_output_format


      if { [info exists mom_sim_mt_axis(5)] } {

         PB_SIM_call SIM_set_rotary_axes_config  [concat $mom_sim_mt_axis(5)]

        # C is Y
         if { ![info exists mom_sim_polar_output_format] || [string match "XCZ" $mom_sim_polar_output_format] } {

            set mom_sim_pos(1) $mom_sim_pos(4)

           # Fall back to previous angle
            set mom_sim_pos(4) $mom_sim_prev_pos(4)
         }

      } elseif { [info exists mom_sim_mt_axis(4)] } {

         PB_SIM_call SIM_set_rotary_axes_config  [concat $mom_sim_mt_axis(4)]

        # C is Y
         if { ![info exists mom_sim_polar_output_format] || [string match "XCZ" $mom_sim_polar_output_format] } {

            set mom_sim_pos(1) $mom_sim_pos(3)

           # Fall back to previous angle
            set mom_sim_pos(3) $mom_sim_prev_pos(3)
         }
      }

      PB_SIM_call SIM_set_machining_mode MILL_CX
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
  global mom_sim_tool_junction mom_sim_current_junction
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

   if { $tool_number != ""  &&  [info exists mom_sim_tool_data($tool_number,name)] } {
      set mom_sim_ug_tool_name $mom_sim_tool_data($tool_number,name)
   } else {
      set mom_sim_tool_change 0
return
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
            if [info exists mom_sim_spindle_group] {
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

      set tool_change_time 5


      set mom_sim_result ""

     # Rotate turret to index lathe tool
      if { [info exists mom_sim_tool_carrier_id] && [info exists mom_sim_tool_pocket_id] && [info exists mom_sim_turret_carriers] } {

         if { [lsearch $mom_sim_turret_carriers $mom_sim_tool_carrier_id] >= 0 } {

           # Handle mixed use of tools on a turret and stationary tools.
            if { ![catch { PB_SIM_call SIM_ask_kim_comp_name_by_id "TOOL" $mom_sim_ug_tool_name }] } {
               set done_tool_change 1
            }

            if $done_tool_change {

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

                 #<03-30-07 gsl> pb501 - Correct error
                  if { !$pocket_id } {
                     set pocket_id $pockets_num
                  }
               }
               set turret_rotation_angle [expr $cutter_holder_angle_delta + $mom_sim_add_turret_angle + $mom_sim_pocket_angle($mom_sim_tool_carrier_id,$pocket_id)]
 
              # - Reduce turret rotation
               set turret_rotation_angle [expr fmod($turret_rotation_angle,360)]
               if { [expr $turret_rotation_angle > 180] } { ;# May need to compare with previous angle
                  set turret_rotation_angle [expr $turret_rotation_angle - 360]
               }

 
              # - This commnad doesn't seem to matter!
              # Set rotation direction
              if 0 {
               PB_SIM_call SIM_set_axis_rotary_dir_mode $mom_sim_turret_axis($mom_sim_tool_carrier_id) "ALWAYS_SHORTEST"
              }

               PB_SIM_call SIM_move_rotary_axis $tool_change_time $mom_sim_turret_axis($mom_sim_tool_carrier_id) $turret_rotation_angle
            }
         }
      }


     # Initialize previous spindle component when needed.
      global mom_sim_prev_spindle_comp
      if { ![info exists mom_sim_prev_spindle_comp] } {
         set mom_sim_prev_spindle_comp $mom_sim_spindle_comp
      }


     # Change tool for mills
      if { $done_tool_change == 0 } {

        # pb502(13) -
        # Always unmount on-the-fly tool
         PB_SIM_call VNC_unmount_tool $sim_prev_tool_name

         PB_SIM_call VNC_set_ref_jct {""}
         PB_SIM_call SIM_mount_tool $tool_change_time "UG_NAME" "$mom_sim_ug_tool_name" "$mom_sim_spindle_comp" "$mom_sim_spindle_jct"

        # By default, this variable is NOT set to indicate that tool length
        # compensation is done immediately @ tool change, otherwise it's set
        # in ____map command to cause compensation to be done @ length comp
        # (G43) function.

         global mom_sim_tool_length_comp_auto

         if { [info exists mom_sim_tool_length_comp_auto] && $mom_sim_tool_length_comp_auto == 0 } {
            set mom_sim_nc_register(TOOL_CHANGED) 1
         }
      }

     # Retain spindle component
      set mom_sim_prev_spindle_comp $mom_sim_spindle_comp

     # Fetch tool comp ID
      set sim_tool_name $mom_sim_result 
   }


   PB_SIM_call SIM_update 


   if {$sim_tool_name != ""} {
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
      global mom_sim_tool_junction mom_sim_current_tool_junction
      global mom_sim_current_junction    
      set mom_sim_current_tool_junction "$mom_sim_tool_junction"
      set mom_sim_tool_junction "$mom_sim_current_junction"
   }

  # pb502(12) -
  # Init this var for a new tool
   global mom_sim_current_tool_junction
   VNC_unset_vars mom_sim_current_tool_junction
}




