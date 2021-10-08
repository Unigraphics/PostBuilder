## HEADER BLOCK START ##
##############################################################################
#                                                                            #
# Copyright(c) 1999/2000/2001/2002/2003/2004/2005/2006, UGS PLM Solutions.   #
# Copyright(c) 2007 ~ 2015,                             SIEMENS PLM Software #
#                                                                            #
##############################################################################
#           P B _ C M D _ C O M B I N E _ R O T A R Y . T C L
##############################################################################
#
# Custom commands in this file can be used to combine consecutive rotary moves
#
#=============================================================================
#
# Custom commands in this file enable the users to combine consecutive
# rotary moves (of same motion type) into a single move when
# there is no change in X, Y and Z.
#
# ==> This functionality will only work in NX3 or newer.
#
#   - Add PB_CMD__combine_rotary_init to "Start of Program" event marker
#   - Add PB_CMD__combine_rotary_output to Linear and/or Rapid Move events
#     before any blocks to be output
#   - Call PB_CMD__combine_rotary_check in custom command PB_CMD_before_motion
#
# The combining of blocks will be terminated when the rotary axis
# being combined reverses its direction or the total angle of
# the combined rotary move would have exceeded 180 degrees.
#
# The current linear move will be suppressed and combined with next motion, when
# both moves are linear or rapid and of the same type (FIRSTCUT, CUT, STEPOVER or RAPID).
#
#=============================================================================
## HEADER BLOCK END ##


#=============================================================
proc PB_CMD__combine_rotary_check { } {
#=============================================================
# This command should be called in PB_CMD_before_motion to check
# the condition if consecutive rotary moves of a single rotary axis
# can be combined when there is no change in X, Y and Z.
#
# Motion types that can be combined are:
#     FIRSTCUT, CUT, STEPOVER & RAPID
#
# When current and next motions are of the same type (FIRSTCUT, CUT,
# STEPOVER or RAPID), the current linear or rapid move will be suppressed & combined
#
# Combining of blocks will be terminated when the rotary axis reverses
# its direction or the total combined angle has exceeded 180 degrees.
#
# * Rotary angles at the equator will be output.
#
# When a rotary axis has limited travel, "Retract / Re-Engage" method
# should be used to handle axis limit violation.
# "::mom_kin_4th_axis_limit_action" or "::mom_kin_5th_axis_limit_action"
# should be set properly.
#
#-------------------------------------------------------------
# 27-Jul-2010 gsl - Added comments and rewrote by removing
#                   the need of "format" commands, number of
#                   decimal places and some funny logics
# 30-Apr-2013 gsl - Added use of ROUND (ugpost_base)
# 13-Jun-2013 gsl - Preserve or recompute feedrate when moves are combined
# 13-Mov-2013 gsl - Allow pure rotary of rapid moves to be combined
# 19-Mov-2013 gsl - Revised the way to recompute FRN
# 18-Jan-2018 gsl - Lock mom_nxt_pos when needed.
# 03-Jul-2019 gsl - Use mom_out_angle_pos(0/1) in place of mom_pos(3/4)
# 15-Jul-2019 gsl - Patch up possible missing KIN variables to accommodate 4-axis cases
#

# Short circuit for debug -
#
# set ::mom_sys_skip_move NO
# return


   # Skip execution, if function of combining rotary moves is not activated.
   #
    if { ![info exists ::mom_sys_combine_rotary_mode] } {
return
    }


   # This command should be called by PB_CMD_before_motion
   #
    if { ![CALLED_BY "PB_CMD_before_motion"] } {
return
    }


   #---------------------------------------------------------------------------
   # Set this flag to also output rotary angles at equator (0, +/-180, +/-360)
   # => Comment out next line or set it to "0" to suppress the output -
    set ::mom_sys_combine_rotary_output_equator_angles 1

    set ::mom_sys_skip_move "NO"

   # Read-ahead must be enabled
   #
    if { [STR_MATCH ::mom_kin_read_ahead_next_motion "TRUE"] &&\
         [info exists ::mom_nxt_pos] && [info exists ::mom_nxt_motion_type] } {

       # Patch up possible missing KIN variables
        if { ![STR_MATCH ::mom_kin_machine_type "5_axis_*"] } {

           set vars_list { axis_min_incr\
                           axis_direction\
                           axis_leader\
                           axis_min_limit\
                           axis_max_limit\
                         }

           foreach kin_var $vars_list {
              if { [info exists ::mom_kin_4th_${kin_var}] && ![info exists ::mom_kin_5th_${kin_var}] } {
                 set ::mom_kin_5th_${kin_var} [set ::mom_kin_4th_${kin_var}]
              }
           }

           if { [info exists ::mom_sys_leader(fourth_axis)] && ![info exists ::mom_sys_leader(fifth_axis)] } {
              set ::mom_sys_leader(fifth_axis) [set ::mom_sys_leader(fourth_axis)]
           }
        }


        set tolm $::mom_kin_machine_resolution
        set tol4 $::mom_kin_4th_axis_min_incr
        set tol5 $::mom_kin_5th_axis_min_incr

       # Initialize previous position
        if { ![info exists ::prev_4th_output] } { set ::prev_4th_output [ROUND $::mom_out_angle_pos(0) $tol4] }
        if { ![info exists ::prev_5th_output] } { set ::prev_5th_output [ROUND $::mom_out_angle_pos(1) $tol5] }

       # Check if rotary axis has been repositioned (set in PB_CMD_reposition_move)
        if { [info exists ::mom_sys_rotary_axis_retract_repositioned] } {
          # OPERATOR_MSG "Rotary axis retract & repositioned."
           unset ::mom_sys_rotary_axis_retract_repositioned
        }

       # Retain previous position
        set P4 $::prev_4th_output
        set P5 $::prev_5th_output

        set ::prev_4th_output [ROUND $::mom_out_angle_pos(0) $tol4]
        set ::prev_5th_output [ROUND $::mom_out_angle_pos(1) $tol5]

       # Initialize last position
        if { ![info exists ::last_4th_output] } { set ::last_4th_output $P4 }
        if { ![info exists ::last_5th_output] } { set ::last_5th_output $P5 }

       # Initialize last direction indicator
        if { ![info exists ::last_4th_dir] } { set ::last_4th_dir 0 }
        if { ![info exists ::last_5th_dir] } { set ::last_5th_dir 0 }


       # Lock next pos when needed.
       if { [info exists ::mom_sys_rotary_axis_index] && [CMD_EXIST LOCK_AXIS] } {
          LOCK_AXIS ::mom_nxt_pos ::mom_nxt_pos ::mom_nxt_out_angle_pos
       }

       set ::mom_nxt_pos(3) [ROTSET $::mom_nxt_pos(3) $::mom_out_angle_pos(0) $::mom_kin_4th_axis_direction\
                                    $::mom_kin_4th_axis_leader ::mom_sys_leader(fourth_axis)\
                                    $::mom_kin_4th_axis_min_limit $::mom_kin_4th_axis_max_limit]

       set ::mom_nxt_pos(4) [ROTSET $::mom_nxt_pos(4) $::mom_out_angle_pos(1) $::mom_kin_5th_axis_direction\
                                    $::mom_kin_5th_axis_leader ::mom_sys_leader(fifth_axis)\
                                    $::mom_kin_5th_axis_min_limit $::mom_kin_5th_axis_max_limit]


        set PX [ROUND $::mom_prev_pos(0) $tolm]
        set PY [ROUND $::mom_prev_pos(1) $tolm]
        set PZ [ROUND $::mom_prev_pos(2) $tolm]

        set NX [ROUND $::mom_nxt_pos(0) $tolm]
        set NY [ROUND $::mom_nxt_pos(1) $tolm]
        set NZ [ROUND $::mom_nxt_pos(2) $tolm]

        set N4 [ROUND $::mom_nxt_pos(3) $tol4]
        set N5 [ROUND $::mom_nxt_pos(4) $tol5]

        set CX [ROUND $::mom_pos(0) $tolm]
        set CY [ROUND $::mom_pos(1) $tolm]
        set CZ [ROUND $::mom_pos(2) $tolm]

        set C4 [ROUND $::mom_out_angle_pos(0) $tol4]
        set C5 [ROUND $::mom_out_angle_pos(1) $tol5]

        set D4 [expr $C4 - $P4]

        if [EQ_is_equal $D4 0] {
            set cur_4th_dir 0
        } elseif { ([EQ_is_gt $D4 -180] && [EQ_is_lt $D4 0]) || [EQ_is_gt $D4 180] } {
            set cur_4th_dir -1
        } else {
            set cur_4th_dir 1
        }

        set T4 [expr $N4 - $::last_4th_output]

        if [EQ_is_equal $T4 0] {
            set tot_4th_dir 0
        } elseif { ([EQ_is_gt $T4 -180] && [EQ_is_lt $T4 0]) || [EQ_is_gt $T4 180] } {
            set tot_4th_dir -1
        } else {
            set tot_4th_dir 1
        }

        if { [EQ_is_lt [expr $cur_4th_dir * $::last_4th_dir] 0] ||\
             [EQ_is_lt [expr $cur_4th_dir * $tot_4th_dir] 0] } {
            set switch_dir_4th "YES"
        } else {
            set switch_dir_4th "NO"
        }

        set D5 [expr $C5 - $P5]

        if [EQ_is_equal $D5 0] {
            set cur_5th_dir 0
        } elseif { ([EQ_is_gt $D5 -180] && [EQ_is_lt $D5 0]) || [EQ_is_gt $D5 180] } {
            set cur_5th_dir -1
        } else {
            set cur_5th_dir 1
        }

        set T5 [expr $N5 - $::last_5th_output]

        if [EQ_is_equal $T5 0] {
            set tot_5th_dir 0
        } elseif { ([EQ_is_ge $T5 -180] && [EQ_is_lt $T5 0]) || [EQ_is_ge $T5 180] } {
            set tot_5th_dir -1
        } else {
            set tot_5th_dir 1
        }

        if { [EQ_is_lt [expr $cur_5th_dir * $::last_5th_dir] 0] ||\
             [EQ_is_lt [expr $cur_5th_dir * $tot_5th_dir] 0] } {
            set switch_dir_5th "YES"
        } else {
            set switch_dir_5th "NO"
        }

        if { ([STR_MATCH ::mom_motion_type "CUT"     ] && [STR_MATCH ::mom_motion_type "CUT"     ]) ||\
             ([STR_MATCH ::mom_motion_type "FIRSTCUT"] && [STR_MATCH ::mom_motion_type "FIRSTCUT"]) ||\
             ([STR_MATCH ::mom_motion_type "RAPID"   ] && [STR_MATCH ::mom_motion_type "RAPID"   ]) ||\
             ([STR_MATCH ::mom_motion_type "STEPOVER"] && [STR_MATCH ::mom_motion_type "STEPOVER"]) } {

            if { [EQ_is_equal $PX $CX] && [EQ_is_equal $PY $CY] && [EQ_is_equal $PZ $CZ] &&\
                 [EQ_is_equal $NX $CX] && [EQ_is_equal $NY $CY] && [EQ_is_equal $NZ $CZ] } {

                if {![EQ_is_equal $P4 $C4] && [EQ_is_equal $P5 $C5] &&\
                    ![EQ_is_equal $N4 $C4] && [EQ_is_equal $N5 $C5] &&\
                     $::mom_sys_combine_rotary_mode != 5 && [STR_MATCH switch_dir_4th "NO"] } {

                    set ::mom_sys_skip_move "YES"
                    MOM_force once fourth_axis
                    set ::mom_sys_combine_rotary_mode "4"

                } elseif\
                   { [EQ_is_equal $P4 $C4] && ![EQ_is_equal $P5 $C5] &&\
                     [EQ_is_equal $N4 $C4] && ![EQ_is_equal $N5 $C5] &&\
                     $::mom_sys_combine_rotary_mode != 4 && [STR_MATCH switch_dir_5th "NO"] } {

                    set ::mom_sys_skip_move "YES"
                    MOM_force once fifth_axis
                    set ::mom_sys_combine_rotary_mode "5"
                }
            }
        }

       # Update direction under all conditions
        set ::last_4th_dir $cur_4th_dir
        set ::last_5th_dir $cur_5th_dir

       # Output angles at equator
        if { [STR_MATCH ::mom_sys_combine_rotary_output_equator_angles 1] } {

           if { [STR_MATCH ::mom_sys_skip_move "YES"] } {
              switch $::mom_sys_combine_rotary_mode {
                 "4" {
                    set C4a [expr abs($C4)]
                    if { [EQ_is_equal $C4a 0.0] || [EQ_is_equal $C4a 180.0] || [EQ_is_equal $C4a 360.0] } {
                      # OPERATOR_MSG "Forced output of C4 = $C4a"
                       set ::mom_sys_skip_move "NO"
                    }
                 }
                 "5" {
                    set C5a [expr abs($C5)]
                    if { [EQ_is_equal $C5a 0.0] || [EQ_is_equal $C5a 180.0] || [EQ_is_equal $C5a 360.0] } {
                      # OPERATOR_MSG "Forced output of C5 = $C5a"
                       set ::mom_sys_skip_move "NO"
                    }
                 }
              }
           }

           if { [STR_MATCH ::mom_sys_skip_move "YES"] } {
              switch $::mom_sys_combine_rotary_mode {
                 "4" {
                    foreach eqt { 0.0 180.0 -180.0 360.0 -360.0 } {
                       if { ([EQ_is_lt $P4 $eqt] && [EQ_is_gt $C4 $eqt]) ||\
                            ([EQ_is_gt $P4 $eqt] && [EQ_is_lt $C4 $eqt]) } {

                         # OPERATOR_MSG "Forced output of $eqt before C4($C4) for ${::mom_motion_event}"
                          set ::mom_out_angle_pos(0) $eqt

                          set ::mom_sys_skip_move "NO"
                          MOM_${::mom_motion_event}
                          set ::mom_sys_skip_move "YES"

                          break
                       }
                    }
                 }
                 "5" {
                    foreach eqt { 0.0 180.0 -180.0 360.0 -360.0 } {
                       if { ([EQ_is_lt $P5 $eqt] && [EQ_is_gt $C5 $eqt]) ||\
                            ([EQ_is_gt $P5 $eqt] && [EQ_is_lt $C5 $eqt]) } {

                         # OPERATOR_MSG "Forced output of $eqt before C5($C5) for ${::mom_motion_event}"
                          set ::mom_out_angle_pos(1) $eqt

                          set ::mom_sys_skip_move "NO"
                          MOM_${::mom_motion_event}
                          set ::mom_sys_skip_move "YES"

                          break
                       }
                    }
                 }
              }
           }
        }


       # Skip output of next motion -
       # Preserve current feedrate

        if { [STR_MATCH ::mom_sys_skip_move "YES"] } {

          # Recompute feedrate, if it's FRN
           if { [STR_MATCH ::mom_sys_contour_feed_mode(ROTARY) "FRN"] } {

              if { ![info exists ::mom_user_combined_rotary_feed] } {
                 set ::mom_user_combined_rotary_feed 0.0
                 set current_feed_num 1.0
              } else {
                 set current_feed_num $::mom_user_combined_rotary_feed
              }

             # Combined FRN = (frn1 * frn2)/(frn1 + frn2)
              set ::mom_user_combined_rotary_feed \
                  [expr ($current_feed_num * $::mom_feed_rate_number) / ($::mom_user_combined_rotary_feed + $::mom_feed_rate_number)]

           } else {

              if { ![info exists ::mom_user_combined_rotary_feed] } {
                 set ::mom_user_combined_rotary_feed $::feed
              }
           }

          # Signal PB_CMD__combine_rotary_output to skip output of current move.
return
        }

        if { [info exists ::mom_user_combined_rotary_feed] } {
           set ::feed $::mom_user_combined_rotary_feed
           unset ::mom_user_combined_rotary_feed
        }

        set ::mom_sys_combine_rotary_mode "1"

        set ::last_4th_output $C4
        set ::last_5th_output $C5
    }
}


#=============================================================
proc PB_CMD__combine_rotary_init { } {
#=============================================================
# This command should only be called in "Start of Program" to
# initialize the functionality of combining consecutive
# rotary moves into a single move when there is no change in
# X, Y and Z.
#
# Motion types that will be combined are:
#     FIRSTCUT, CUT, STEPOVER & RAPID
#
# - Add PB_CMD__combine_rotary_output to Linear and/or Rapid Move events
#   before any blocks to be output
# - Add PB_CMD__combine_rotary_check call in custom command PB_CMD_before_motion
#
# The combining of blocks will be terminated when the rotary axis
# being combined reverses ts direction or the total angle of
# the combined rotary move would have exceeded 180 degrees.
#
# Rotary angles at the equator will be output.
#
# When a rotary axis has limited travel, "Retract / Re-Engage" method should be used
# to handle the condition of limit violations. "::mom_kin_4th_axis_limit_action" or
# "::mom_kin_5th_axis_limit_action" should be set properly.
#
#-------------------------------------------------------------
# 06-May-2013 gsl - Added ROUND, if not present, to work with older NX/Post
#

# ==> Uncomment next statement to disable the combine-rotary functionality
# return


   # This command should be called by PB_start_of_program
   #
    if { ![CALLED_BY "PB_start_of_program"] } {
return
    }


   # Function of combining rotary moves can only be used when
   # "MOM_abort_event" is available (NX3 & up).
   #
    if { ![CMD_EXIST MOM_abort_event] } {
        CATCH_WARNING "MOM_abort_event is an invalid command.  You must use NX3 or newer."
return
    }



   #<04-30-2013 gsl> This version only works when ROUND command is available.
   #
    if { ![CMD_EXIST ROUND] } {

    uplevel #0 {
       #===============================================================================
       proc ROUND { value {resol 1} } {
       #===============================================================================
       # This command rounds off a number by the given output resolution.
       # When the resolution is not specified, it rounds the number to an integer.
       #
       #<04-24-2013 gsl> Initial implementation
       #
          set ret_val $value

          # Perform regular rounding when output resolution is "1".
          if { [EQ_is_equal $resol 1] } \
          {
             return [expr round( $value )]
          }

          # When the output resolution is near "0", the original value is returned.
          if { ![EQ_is_zero $resol] } \
          {
              if [EQ_is_zero $value] \
              {
                 set ret_val 0.0

              } else \
              {
                 set sign 1

                 set x [expr $value / $resol]

                 # Either value or resol can be negative; and that will cause x to be negative.
                 if [expr $x < 0.0] \
                 {
                    set sign -1
                 }

                 # To compensate for the loss of floating point accuracy
                 set x [expr floor( abs($x) + 0.501 )]

                 set ret_val [expr $sign * $x * $resol]
              }
           }

           return $ret_val
       }

    } ;# uplevel
    }



   # Clear possible residual
    if { [info exists ::mom_sys_skip_move] } {
        unset ::mom_sys_skip_move
    }


   # Enable combining rotary moves with read-ahead function
   #
    set ::mom_sys_combine_rotary_mode     "1"
    set ::mom_kin_read_ahead_next_motion  "TRUE"

    MOM_reload_kinematics
}


#=============================================================
proc PB_CMD__combine_rotary_output { } {
#=============================================================
# This command should be called by Linear and/or Rapid Move event
# to skip the output when consecutive rotary moves can be combined.
#

   # Skip execution, if function of combining rotary moves is not activated.
   # - This flag should be set in PB_CMD__combine_rotary_init
   #
    if { ![info exists ::mom_sys_combine_rotary_mode] } {
return
    }


   # This command should be called by MOM_linear_move or MOM_rapid_move
   #
    if { ![CALLED_BY "MOM_linear_move"] && ![CALLED_BY "MOM_rapid_move"] } {
return
    }


   # Flag set in PB_CMD__combine_rotary_check to tell if next block should be combined.
   # - Need to skip output, exchange the end points' info then abort
   #
    if { [STR_MATCH ::mom_sys_skip_move "YES"] } {

        VMOV 5 ::mom_prev_pos      ::mom_pos
        VMOV 3 ::mom_prev_mcs_goto ::mom_mcs_goto

        MOM_reload_variable -a mom_pos
        MOM_reload_variable -a mom_mcs_goto

        MOM_abort_event
    }
}


#=============================================================
proc PB_CMD_reposition_move { } {
#=============================================================
#  This command is used by rotary axis retract to reposition the
#  rotary axes after the tool has been fully retracted.
#
#  You can modify this command to customize the reposition move.
#
#<08-Jul-2019 gsl> Set a variable to notify combine_rotary module to update data.

   MOM_suppress once X Y Z
   MOM_do_template rapid_traverse

   if { [info exists ::mom_sys_combine_rotary_mode] } {
      set ::prev_4th_output $::mom_out_angle_pos(0)
      set ::prev_5th_output $::mom_out_angle_pos(1)
      set ::mom_sys_rotary_axis_retract_repositioned 1
   }
}



