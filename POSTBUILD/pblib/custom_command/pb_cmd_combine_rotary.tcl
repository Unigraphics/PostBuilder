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
# Custom commands in this file will allow you to combine consecutive
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
# The combining of blocks will terminate when the rotary axis
# being combined reverses or the total angle (in degrees) of
# the combined rotary move would have exceeded 180 degrees.
#
# The current linear move will be suppressed and combined with next motion, when
# both moves are linear and of the same type (FIRSTCUT, CUT, STEPOVER or RAPID).
#
#=============================================================================
## HEADER BLOCK END ##


#=============================================================
proc PB_CMD__combine_rotary_check { } {
#=============================================================
# Combine consecutive rotary moves
#
#
# These custom commands will allow you to combine consecutive
# rotary moves into a single move when there is no change in
# X, Y and Z.
#
# Motion types that can be combined are:
#     FIRSTCUT, CUT, STEPOVER & RAPID
#
# ==> This function will only work in NX3 or later.
#
# - Add PB_CMD__combine_rotary_init to Start of Program marker
# - Add PB_CMD__combine_rotary_output to Linear and/or Rapid Move events
#   before any blocks to be output
# - Add PB_CMD__combine_rotary_check call in custom command PB_CMD_before_motion
#
# The combining of blocks will terminate when the rotary axis
# being combined reverses or the total number of degrees of
# the combined rotary move would have exceeded 180 degrees.
#
# The current linear or rapid move will be suppressed if current and
# next motions are of the same type (FIRSTCUT, CUT, STEPOVER or RAPID).
#
#-------------------------------------------------------------
# 27-Jul-2010 gsl - Added comments and rewrote by removing
#                   the need of "format" commands, number of
#                   decimal places and some funny logics
# 30-Apr-2013 gsl - Added use of ROUND (ugpost_base)
# 13-Jun-2013 gsl - Preserve or recompute feedrate when moves are combined
# 13-Mov-2013 gsl - Allow pure rotary of rapid moves to be combined
# 19-Mov-2013 gsl - Revised the way to recompute FRN
#

   # Skip execution, if function of combining rotary moves is not activated.
   #
    global mom_sys_combine_rotary_mode
    if { ![info exists mom_sys_combine_rotary_mode] } {
return
    }


   # This command should be called by PB_CMD_before_motion
   #
    if { ![CALLED_BY "PB_CMD_before_motion"] } {
return
    }


    global mom_sys_skip_move

    global mom_nxt_pos
    global mom_pos
    global mom_prev_pos
    global mom_nxt_motion_type
    global mom_motion_type

    global prev_4th_output
    global prev_5th_output
    global last_4th_output
    global last_5th_output
    global last_4th_dir
    global last_5th_dir


    set mom_sys_skip_move "NO"


   # Read-ahead must be enabled
   #
    if { [info exists mom_nxt_pos] && [info exists mom_nxt_motion_type] } {

        global mom_kin_machine_resolution
        global mom_kin_4th_axis_min_incr
        global mom_kin_5th_axis_min_incr

        set tolm $mom_kin_machine_resolution
        set tol4 $mom_kin_4th_axis_min_incr
        set tol5 $mom_kin_5th_axis_min_incr

       # Initialize previous position
        if { ![info exists prev_4th_output] } { set prev_4th_output [ROUND $mom_pos(3) $tol4] }
        if { ![info exists prev_5th_output] } { set prev_5th_output [ROUND $mom_pos(4) $tol5] }

       # Retain previous position
        set P4 $prev_4th_output
        set P5 $prev_5th_output

        set prev_4th_output [ROUND $mom_pos(3) $tol4] 
        set prev_5th_output [ROUND $mom_pos(4) $tol5] 

       # Initialize last position
        if { ![info exists last_4th_output] } { set last_4th_output $P4 }
        if { ![info exists last_5th_output] } { set last_5th_output $P5 }

       # Initialize last direction indicator
        if { ![info exists last_4th_dir] } { set last_4th_dir 0 }
        if { ![info exists last_5th_dir] } { set last_5th_dir 0 }


        set PX [ROUND $mom_prev_pos(0) $tolm]
        set PY [ROUND $mom_prev_pos(1) $tolm]
        set PZ [ROUND $mom_prev_pos(2) $tolm]

        set NX [ROUND $mom_nxt_pos(0) $tolm]
        set NY [ROUND $mom_nxt_pos(1) $tolm]
        set NZ [ROUND $mom_nxt_pos(2) $tolm]

        set N4 [ROUND $mom_nxt_pos(3) $tol4]
        set N5 [ROUND $mom_nxt_pos(4) $tol5]

        set CX [ROUND $mom_pos(0) $tolm]
        set CY [ROUND $mom_pos(1) $tolm]
        set CZ [ROUND $mom_pos(2) $tolm]

        set C4 [ROUND $mom_pos(3) $tol4]
        set C5 [ROUND $mom_pos(4) $tol5]

        set D4 [expr $C4 - $P4]

        if [EQ_is_equal $D4 0] {
            set cur_4th_dir 0
        } elseif { ([EQ_is_gt $D4 -180] && [EQ_is_lt $D4 0]) || [EQ_is_gt $D4 180] } {
            set cur_4th_dir -1
        } else {
            set cur_4th_dir 1
        }

        set T4 [expr $N4 - $last_4th_output]

        if [EQ_is_equal $T4 0] {
            set tot_4th_dir 0
        } elseif { ([EQ_is_gt $T4 -180] && [EQ_is_lt $T4 0]) || [EQ_is_gt $T4 180] } {
            set tot_4th_dir -1
        } else {
            set tot_4th_dir 1
        }

        if { [EQ_is_lt [expr $cur_4th_dir * $last_4th_dir] 0] ||\
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

        set T5 [expr $N5 - $last_5th_output]

        if [EQ_is_equal $T5 0] {
            set tot_5th_dir 0
        } elseif { ([EQ_is_gt $T5 -180] && [EQ_is_lt $T5 0]) || [EQ_is_gt $T5 180] } {
            set tot_5th_dir -1
        } else {
            set tot_5th_dir 1
        }

        if { [EQ_is_lt [expr $cur_5th_dir * $last_5th_dir] 0] ||\
             [EQ_is_lt [expr $cur_5th_dir * $tot_5th_dir] 0] } {
            set switch_dir_5th "YES"
        } else {
            set switch_dir_5th "NO"
        }


        if { (![string compare "CUT"      $mom_motion_type] && ![string compare "CUT"      $mom_nxt_motion_type]) ||\
             (![string compare "FIRSTCUT" $mom_motion_type] && ![string compare "FIRSTCUT" $mom_nxt_motion_type]) ||\
             (![string compare "RAPID"    $mom_motion_type] && ![string compare "RAPID"    $mom_nxt_motion_type]) ||\
             (![string compare "STEPOVER" $mom_motion_type] && ![string compare "STEPOVER" $mom_nxt_motion_type]) } {

            if { [EQ_is_equal $PX $CX] && [EQ_is_equal $PY $CY] && [EQ_is_equal $PZ $CZ] &&\
                 [EQ_is_equal $NX $CX] && [EQ_is_equal $NY $CY] && [EQ_is_equal $NZ $CZ] } {

                if {![EQ_is_equal $P4 $C4] && [EQ_is_equal $P5 $C5] &&\
                    ![EQ_is_equal $N4 $C4] && [EQ_is_equal $N5 $C5] &&\
                     $mom_sys_combine_rotary_mode != 5 && ![string compare "NO" $switch_dir_4th] } {

                    set mom_sys_skip_move "YES"
                    MOM_force once fourth_axis
                    set mom_sys_combine_rotary_mode "4"

                } elseif\
                   { [EQ_is_equal $P4 $C4] && ![EQ_is_equal $P5 $C5] &&\
                     [EQ_is_equal $N4 $C4] && ![EQ_is_equal $N5 $C5] &&\
                     $mom_sys_combine_rotary_mode != 4 && ![string compare "NO" $switch_dir_5th] } {

                    set mom_sys_skip_move "YES"
                    MOM_force once fifth_axis
                    set mom_sys_combine_rotary_mode "5"
                }
            }
        }


       # Skip next output -
       # Preserve current feedrate
        global mom_user_combined_rotary_feed feed
        global mom_sys_contour_feed_mode

        if { ![string compare $mom_sys_skip_move "YES"] } {

          # Recompute feedrate, if it's FRN
           if { [string match "FRN" $mom_sys_contour_feed_mode(ROTARY)] } {

              if { ![info exists mom_user_combined_rotary_feed] } {
                 set mom_user_combined_rotary_feed 0.0
                 set current_feed_num 1.0
              } else {
                 set current_feed_num $mom_user_combined_rotary_feed
              }

              set mom_user_combined_rotary_feed \
                  [expr $current_feed_num * $feed / ( $mom_user_combined_rotary_feed + $feed )]

           } else {
              if { ![info exists mom_user_combined_rotary_feed] } {
                 set mom_user_combined_rotary_feed $feed
              }
           }
return
        }

        if { [info exists mom_user_combined_rotary_feed] } {
           set feed $mom_user_combined_rotary_feed
           unset mom_user_combined_rotary_feed
        }

        set mom_sys_combine_rotary_mode "1"

        set last_4th_output $C4
        set last_5th_output $C5
        set last_4th_dir $cur_4th_dir
        set last_5th_dir $cur_5th_dir
    }
}


#=============================================================
proc PB_CMD__combine_rotary_init { } {
#=============================================================
# This command should only be called in "Start of Program"
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
    if ![CMD_EXIST ROUND] {

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
    global mom_sys_combine_rotary_mode mom_sys_skip_move

    if { [info exists mom_sys_skip_move] } {
        unset mom_sys_skip_move
    }


   # Enable combining rotary moves with read-ahead function
   #
    global mom_kin_read_ahead_next_motion

    set mom_sys_combine_rotary_mode     "1"
    set mom_kin_read_ahead_next_motion  "TRUE"

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
    global mom_sys_combine_rotary_mode
    if { ![info exists mom_sys_combine_rotary_mode] } {
return
    }


   # This command should be called by MOM_linear_move or MOM_rapid_move
   #
    if { ![CALLED_BY "MOM_linear_move"] && ![CALLED_BY "MOM_rapid_move"] } {
return
    }


   # Flag set in PB_CMD__combine_rotary_check to tell if next block should be combined.
   #
    global mom_sys_skip_move

   # Need to skip output, exchange the end points' info then abort
   #
    if { ![string compare $mom_sys_skip_move "YES"] } {

        global mom_pos mom_prev_pos
        global mom_mcs_goto mom_prev_mcs_goto

        VMOV 5 mom_prev_pos mom_pos
        VMOV 3 mom_prev_mcs_goto mom_mcs_goto

        MOM_reload_variable -a mom_pos
        MOM_reload_variable -a mom_mcs_goto

        MOM_abort_event
    }
}





