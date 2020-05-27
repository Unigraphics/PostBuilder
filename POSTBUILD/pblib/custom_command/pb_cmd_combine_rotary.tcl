## HEADER BLOCK START ##
##############################################################################
#                                                                            #
# Copyright (c) 1999/2000/2001/2002/2003/2004/2005/2006, UGS PLM Solutions.  #
# Copyright (c) 2007/2008/2009/2010, SIEMENS PLM Softwares.                  #
#                                                                            #
##############################################################################
#           P B _ C M D _ C O M B I N E _ R O T A R Y . T C L
##############################################################################
#
# Custom commands in this file can be used to combine consecutive rotary moves
#
#=============================================================================
#
# These custom commands will allow you to combine consecutive
# rotary moves into a single move when there is no change in
# X, Y and Z.
#
# ==> This function will only work in NX3 or later.
#
# - Add PB_CMD__combine_rotary_init to "Start of Program" event marker
# - Add PB_CMD__combine_rotary_output to "Linear Move" event before output block
# - Call PB_CMD__combine_rotary_check in custom command PB_CMD_before_motion
#
# The combining of blocks will terminate when the rotary axis
# being combined reverses or the total number of degrees of
# the combined rotary move would have exceeded 180 degrees.
#
# The current linear move will be suppressed if the current and the
# next motion are either CUT or FIRSTCUT and both are linear
# moves.
#
#=============================================================================
## HEADER BLOCK END ##

##############################################################################


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
# ==> This function will only work in NX3 or later.
#
# - Add PB_CMD__combine_rotary_init to Start of Program marker
# - Add PB_CMD__combine_rotary_output to Linear Move event before output block
# - Call PB_CMD__combine_rotary_check in custom command PB_CMD_before_motion
#
# The combining of blocks will terminate when the rotary axis
# being combined reverses or the total number of degrees of
# the combined rotary move would have exceeded 180 degrees.
#
# The current linear move will be suppressed if the current and the
# next motion are either CUT or FIRSTCUT and both are linear
# moves.
#
#-------------------------------------------------------------
# 27-Jul-2010 gsl - Added comments and rewrote by removing
#                   the need of "format" commands, number of
#                   decimal places and some funny logics
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

       # Initialize previous position
        if { ![info exists prev_4th_output] } { set prev_4th_output $mom_pos(3) }
        if { ![info exists prev_5th_output] } { set prev_5th_output $mom_pos(4) }

       # Retain previous position
        set P4 $prev_4th_output
        set P5 $prev_5th_output

        set prev_4th_output $mom_pos(3)
        set prev_5th_output $mom_pos(4)

       # Initialize last position
        if { ![info exists last_4th_output] } { set last_4th_output $P4 }
        if { ![info exists last_5th_output] } { set last_5th_output $P5 }

       # Initialize last direction indicator
        if { ![info exists last_4th_dir] } { set last_4th_dir 0 }
        if { ![info exists last_5th_dir] } { set last_5th_dir 0 }


        set PX $mom_prev_pos(0)
        set PY $mom_prev_pos(1)
        set PZ $mom_prev_pos(2)

        set NX $mom_nxt_pos(0)
        set NY $mom_nxt_pos(1)
        set NZ $mom_nxt_pos(2)

        set N4 $mom_nxt_pos(3)
        set N5 $mom_nxt_pos(4)

        set CX $mom_pos(0)
        set CY $mom_pos(1)
        set CZ $mom_pos(2)

        set C4 $mom_pos(3)
        set C5 $mom_pos(4)

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
        if {![string compare $mom_sys_skip_move "YES"] } {
return
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

# ==> Uncomment next statement to disable the combine-rotary function
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
        CATCH_WARNING "MOM_abort_event is an invalid command.  You must use NX3 or later."
return
    }


   # Clear possible residual
    global mom_sys_combine_rotary_mode mom_sys_skip_move

    if { [info exists mom_sys_combine_rotary_mode] } {
        unset mom_sys_combine_rotary_mode
    }

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
# This command should be called by Linear Move event to skip the output
# when consecutive rotary moves can be combined.
#

   # Skip execution, if function of combining rotary moves is not activated.
   #
    global mom_sys_combine_rotary_mode
    if { ![info exists mom_sys_combine_rotary_mode] } {
return
    }


   # This command should be called by MOM_linear_move
   #
    if { ![CALLED_BY "MOM_linear_move"] } {
return
    }


   # Flag set in PB_CMD__combine_rotary_check to tell if next block should be combined.
   #
    global mom_sys_skip_move

   # Need to skip output, exchange the end point info then abort
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



