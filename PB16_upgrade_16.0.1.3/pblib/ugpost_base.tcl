###############################################################################
#
# DESCRIPTION
#
#   This section contains the base section for all post processors. 
#   It sets the default G and M codes.
#   If any of the procs do not exist in the EVENT HANDLER tcl file,ie, an
#   event is triggered from the event generator without the proc,
#   warnings are generated.
#   If there is a proc which needs to be in all post processors without the
#   user modifying it, put it here,eg, mom_pprint and mom_operator_message.
#
#
# REVISIONS
#
#      Date       Who       Reason
#    22May1998    whb       Initial
#    02Jul1998    whb       Update FEEDRATE_SET and commentary output
#    08Jul1998    whb       close files
#    30Jul1998    MKG       MOM_catch_warning automatically handles min-max 
#                           errors.
#    31Aug1998    MKG       MOM_start_of_group/end_of_group for individual 
#                           group outputs.
#    17Feb1999    CSN       Handling MOM_first_move
#    12May1999    whb       add EQ_is... procs to detect equality between scalars
#    17May1999    whb       VEC3... procs used to manipulate vectors
#                           MTX3... procs used to manipulate matrices
# 10-Jun-1999   whb     remove puts to stdout (NO stdout on NT)
# 16-Jun-1999   whb     use listing output as per dialog
# 25-Jun-1999   whb     undo 16-Jun-1999 listing removed from dialog
# 20-Jul-1999   satya   Used [info exists..] instead of catch in LIST_FILE
#                       function
# 27-Jul-1999   whb     add CHECK_OPER_TYPE
# 15-Nov-1999   whb     truncate output name to 30 characters.
# 17-Dec-1999   MKG     Post Builder related enhancements.
# 21-Feb-2000   MKG     4116197 resolve duplicate variables in TOOL_SET.
# 25Apr00       MKG     Modified RAPID_SET, FEEDRATE_SET.
# 04May00       MKG     initialize some globals.
# 05May00       MNB     Listing & Warning File output as per Post Builder
#                       settings.
# 09May00       MKG     lathe related changes in RAPID_SET.
# 18May00       MKG     appropriately open/close group files.
# 24May00       Satya   Modified MOM_catch_warning to NOT raise warning for 
#                       not handling MOM_machine_mode and MOM_msys
# 25May00       MKG 4101215,4136490 delete any pre-existing files, implement file suffixes.
# 01Jun00       MKG 4152774 set mom_group_name [string tolower $mom_group_name] in MOM_end_of_group.
# 13Jun00       whb 4156433 add MOM_insert, MOM_lintol, MOM_translate, MOM_origin, MOM_tlset
# 20Jun00       whb 4156249 fix operator messages to handle control out and in chars.
# 28Jun00       whb         change message for warning file
# 14Jul00       whb         update for post builder defaults.
# 25Jul00       MKG         check for _status UNDEFINED.
# 07Aug00       gsl         Modified logic in OPEN_files for out file extension.
#
# $HISTORY$
#
################################################################################
# BASE SECTION 
#   This section contains the base section for all post processors. 
#   If any of the files doesn't exit in the EVENT HANDLER tcl file,
#   Warnings are generated               
################################################################################
#_______________________________________________________________________________
# Default G/M codes
#_______________________________________________________________________________
         set mom_sys_program_stop_code              0
         set mom_sys_optional_stop_code             1
         set mom_sys_end_of_program_code            2

         set mom_sys_spindle_direction_code(CLW)    3
         set mom_sys_spindle_direction_code(CCLW)   4
         set mom_sys_spindle_direction_code(OFF)    5

         set mom_sys_tool_change_code               6

         set mom_sys_coolant_code(MIST)             7
         set mom_sys_coolant_code(ON)               8
         set mom_sys_coolant_code(FLOOD)            8
         set mom_sys_coolant_code(TAP)              8
         set mom_sys_coolant_code(OFF)              9

         set mom_sys_clamp_code(ON)                 10
         set mom_sys_clamp_code(OFF)                11
         set mom_sys_clamp_code(AXISON)             10
         set mom_sys_clamp_code(AXISOFF)            11

         set mom_sys_rewind_code                    30

         set mom_sys_rapid_code                     0
         set mom_sys_linear_code                    1

         set mom_sys_circle_code(CLW)               2
         set mom_sys_circle_code(CCLW)              3

         set mom_sys_delay_code(REVOLUTIONS)        4
         set mom_sys_delay_code(SECONDS)            4

         set mom_sys_cutcom_plane_code(XY)          17
         set mom_sys_cutcom_plane_code(ZX)          18
         set mom_sys_cutcom_plane_code(YZ)          19

         set mom_sys_return_code                    28

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

         set mom_sys_spindle_max_rpm_code           92

         set mom_sys_feed_rate_mode_code(FRN)       93
         set mom_sys_feed_rate_mode_code(IPM)       94
         set mom_sys_feed_rate_mode_code(MMPM)      94
         set mom_sys_feed_rate_mode_code(IPR)       95
         set mom_sys_feed_rate_mode_code(MMPR)      95

         set mom_sys_spindle_mode_code(SFM)         96
         set mom_sys_spindle_mode_code(SMM)         96
         set mom_sys_spindle_mode_code(RPM)         97

#_______________________________________________________________________________
# Global Variable Declaration
#_______________________________________________________________________________
         set mom_sys_list_file_columns              132
         set mom_sys_list_file_rows                 40
         set mom_sys_commentary_output              OFF
         set mom_sys_list_output                    OFF
         set mom_sys_ptp_output                     ON
         set mom_sys_group_output                   OFF
         set mom_sys_header_output                  ON
         set mom_sys_warning_output                 OFF
         set mom_sys_rewind_stop_code               %
         set mom_sys_control_in                     )
         set mom_sys_control_out                    (
         set mom_sys_opskip_block_leader            \\
         set mom_sys_spindle_ranges                 0
         set mom_sys_home_pos(0)                    0
         set mom_sys_home_pos(1)                    0
         set mom_sys_home_pos(2)                    0
         set mom_sys_zero                           0
         set mom_sys_seqnum_start                   10
         set mom_sys_seqnum_incr                    10
         set mom_sys_seqnum_freq                    1
         set mom_sys_leader(fourth_axis)            A
         set mom_sys_leader(fifth_axis)             B
         set mom_sys_leader(N)                      N
         set mom_event_time                         0.0
         set com_feed_rate                          0

         set mom_system_tolerance                   .0000001

         set mom_sys_output_file_suffix             "ptp"
         set mom_sys_list_file_suffix               "lpt"
#_______________________________________________________________________________
set PI [expr 2.0 * asin(1.0)]                    ; #value PI
set RAD2DEG [expr 90.0 / asin(1.0)]              ; #multiplier to convert radians to degrees
set DEG2RAD [expr asin(1.0) / 90.0]              ; #multiplier to convert degrees to radians

###############################################################################
#
# DESCRIPTION
#
#   Procs used to detect equality between scalars of real data type.
#
#  global mom_system_tolerance
#  EQ_is_equal(s, t)  (abs(s-t) <= mom_system_tolerance) Return true if scalars are equal
#  EQ_is_ge(s, t)     (s > t - mom_system_tolerance)     Return true if s is greater than
#                                            or equal to t
#  EQ_is_gt(s, t)     (s > t + mom_system_tolerance)     Return true if s is greater than t
#  EQ_is_le(s, t)     (s < t + mom_system_tolerance)     Return true if s is less than or
#                                            equal to t
#  EQ_is_lt(s, t)     (s < t - mom_system_tolerance)     Return true if s is less than t
#  EQ_is_zero(s)      (abs(s) < mom_system_tolerance)    Return true if scalar is zero
################################################################################
proc  EQ_is_equal {s t} {
         global mom_system_tolerance

         if { abs([expr ($s - $t)]) <= $mom_system_tolerance } { return 1 } else { return 0 }
}
proc  EQ_is_ge {s t} {
         global mom_system_tolerance

         if { $s > [expr ($t - $mom_system_tolerance)] } { return 1 } else { return 0 }
}
proc  EQ_is_gt {s t} {
         global mom_system_tolerance

         if { $s > [expr ($t + $mom_system_tolerance)] } { return 1 } else { return 0 }
}
proc  EQ_is_le {s t} {
         global mom_system_tolerance

         if { $s < [expr ($t + $mom_system_tolerance)] } { return 1 } else { return 0 }
}
proc  EQ_is_lt {s t} {
         global mom_system_tolerance

         if { $s < [expr ($t - $mom_system_tolerance)] } { return 1 } else { return 0 }
}
proc  EQ_is_zero {s} {
         global mom_system_tolerance

         if { abs($s) <= $mom_system_tolerance } { return 1 } else { return 0 }
}

################################################################################
#
# DESCRIPTION
#
#   Procs used to manipulate vectors
#
#  VEC3_add(u,v,w)                  w = u + v          Vector addition
#  VEC3_cross(u,v,w)                w = ( u X v )      Vector cross product
#  VEC3_dot(u,v)                    (u dot v)          Vector dot product
#  VEC3_init(x,y,z,w)               w = (x, y, z)      Initialize a vector from
#                                                      coordinates
#  VEC3_is_equal(u,v,tol)           (||(u-v)|| < tol)  Are vectors equal?
#  VEC3_is_zero(u,tol)              (|| u || < tol)    Is vector zero?
#  VEC3_mag(u)                      ( || u || )        Vector magnitude
#  VEC3_negate(u,w)                 w = (-u)           Vector negate
#  VEC3_scale(s,u,w)                w = (s*u)          Vector scale
#  VEC3_sub(u,v,w)                  w = u - v          Vector subtraction
#  VEC3_unitize(u,tol,len,w)        *len = || u ||     Vector unitization
#                                   w = u / *len
################################################################################

#  VEC3_add(u,v,w)                  w = u + v          Vector addition
proc  VEC3_add {u v w} {
      upvar $u u1 ; upvar $v v1 ; upvar $w w1
      for {set ii 0} {$ii < 3} {incr ii} {
          set w1($ii) [expr ($u1($ii) + $v1($ii))]
      }
}

#  VEC3_cross(u,v,w)                w = ( u X v )      Vector cross product
proc  VEC3_cross {u v w} {
      upvar $u u1 ; upvar $v v1 ; upvar $w w1
      set w1(0) [expr ($u1(1) * $v1(2) - $u1(2) * $v1(1))]
      set w1(1) [expr ($u1(2) * $v1(0) - $u1(0) * $v1(2))]
      set w1(2) [expr ($u1(0) * $v1(1) - $u1(1) * $v1(0))]
}

#  VEC3_dot(u,v)                    (u dot v)          Vector dot product
proc  VEC3_dot {u v} {
      upvar $u u1 ; upvar $v v1
      return  [expr ($u1(0) * $v1(0) + $u1(1) * $v1(1) + $u1(2) * $v1(2))]
}

#  VEC3_init(x,y,z,w)               w = (x, y, z)      Initialize a vector from
#                                                      coordinates
proc  VEC3_init {x y z w} {
      upvar $x x1 ; upvar $y y1 ; upvar $z z1 ; upvar $w w1
      set w1(0) $x1 ; set w1(1) $y1 ; set w1(2) $z1
}

#  VEC3_is_equal(u,v,tol)           (||(u-v)|| < tol)  Are vectors equal?
proc  VEC3_is_equal {u v} {
      upvar $u u1 ; upvar $v v1
      set is_equal 1
      for {set ii 0} {$ii < 3} {incr ii} {
          if {![EQ_is_equal $u1($ii) $v1($ii)]} {
              set is_equal 0
              break
          }
      }
      return $is_equal
}

#  VEC3_is_zero(u,tol)              (|| u || < tol)    Is vector zero?
proc  VEC3_is_zero {u} {
      upvar $u u1
      set v1(0) 0.0 ; set v1(1) 0.0 ; set v1(2) 0.0
      set is_equal 1
      for {set ii 0} {$ii < 3} {incr ii} {
          if {![EQ_is_equal $u1($ii) $v1($ii)]} {
              set is_equal 0
              break
          }
      }
      return $is_equal
}

#  VEC3_mag(u)                      ( || u || )        Vector magnitude
proc  VEC3_mag {u} {
      upvar $u u1
      return [expr (sqrt([VEC3_dot u1 u1]))]
}

#  VEC3_negate(u,w)                 w = (-u)           Vector negate
proc  VEC3_negate {u w} {
      upvar $u u1 ; upvar $w w1
      for {set ii 0} {$ii < 3} {incr ii} {
          set w1($ii) [expr (-$u1($ii))]
      }
}

#  VEC3_scale(s,u,w)                w = (s*u)          Vector scale
proc  VEC3_scale {s u w} {
      upvar $s s1 ; upvar $u u1 ; upvar $w w1
      for {set ii 0} {$ii < 3} {incr ii} {
          set w1($ii) [expr ($s1 * $u1($ii))]
      }
}

#  VEC3_sub(u,v,w)                  w = u - v          Vector subtraction
proc  VEC3_sub {u v w} {
      upvar $u u1 ; upvar $v v1 ; upvar $w w1
      for {set ii 0} {$ii < 3} {incr ii} {
          set w1($ii) [expr ($u1($ii) - $v1($ii))]
      }
}

#  VEC3_unitize(u,tol,len,w)        *len = || u ||     Vector unitization
#                                   w = u / *len
proc  VEC3_unitize {u w} {
      upvar $u u1 ; upvar $w w1
      if {[VEC3_is_zero u1]} {
         set len 0.0
         VEC3_init 0.0 0.0 0.0 w1
      } else {
         set len [VEC3_mag u1]
         set scale [expr (1.0/$len)]
         VEC3_scale scale u1 w1
      }
      return $len
}

################################################################################
#
# DESCRIPTION
#
#   Procs used to manipulate matrices
#
#  MTX3_init_x_y_z (u, v, w, r) r = (u, v, w)      Initialize a matrix from
#                                                  given x, y and z vectors
#  MTX3_is_equal(m,n,a)         (m == n)           Determine if two matrices
#                                                  are equal to within a given
#                                                  tolerance
#  MTX3_multiply(m, n, r)       r = ( m X n )      Matrix multiplication
#  MTX3_transpose(m, r)         r = trns(m)        Transpose of matrix
#  MTX3_scale(s,r)              r = (s*(u))        Scale a matrix by s
#  MTX3_sub(m,n,r)              r = (m - n)        Matrix subtraction
#  MTX3_add(m,n,r)              r = (m - n)        Matrix addition
#  MTX3_vec_multiply(u, m, w)   w = (u X m)        Vector/matrix multiplication
#  MTX3_x(m, w)                 w = (1st column)   First column vector of matrix
#  MTX3_y(m, w)                 w = (2nd column)   Second column vector of matrix
#  MTX3_z(m, w)                 w = (3rd column)   Third column vector of matrix
################################################################################

#  MTX3_init_x_y_z (u, v, w, r) r = (u, v, w)      Initialize a matrix from
#                                                  given x, y and z vectors
proc  MTX3_init_x_y_z { u v w r } {
      upvar $u u1 ; upvar $v v1 ; upvar $w w1 ; upvar $r r1
      set status 0

#   Unitize the input vectors and proceed if neither vector is zero.

    if {[VEC3_unitize u1 xxxxx] && \
        [VEC3_unitize v1 yyyyy] && \
        [VEC3_unitize w1 zzzzz]} {

#       Proceed if the input vectors are orthogonal

        if {[EQ_is_zero [VEC3_dot xxxxx yyyyy]] && \
            [EQ_is_zero [VEC3_dot xxxxx zzzzz]] && \
            [EQ_is_zero [VEC3_dot yyyyy zzzzz]]} {

#           Cross the unitized input vectors and initialize the matrix
#           Orthonormal test is stricter than EQ_ask_systol, so
#           recalculate y and z.

            set status 1
            VEC3_cross xxxxx yyyyy zzzzz
            set len [VEC3_unitize zzzzz zzzzz]
            VEC3_cross zzzzz xxxxx yyyyy

            set r1(0) $xxxxx(0)
            set r1(1) $xxxxx(1)
            set r1(2) $xxxxx(2)
            set r1(3) $yyyyy(0)
            set r1(4) $yyyyy(1)
            set r1(5) $yyyyy(2)
            set r1(6) $zzzzz(0)
            set r1(7) $zzzzz(1)
            set r1(8) $zzzzz(2)

        }
    }
    return $status
}

#  MTX3_is_equal(m,n,a)         (m == n)           Determine if two matrices
#                                                  are equal to within a given
#                                                  tolerance
proc  MTX3_is_equal { m n } {
      upvar $m m1 ; upvar $n n1
      set status 1

      for {set ii 0} {$ii < 9} {incr ii} {
          if {![EQ_is_equal $m1($ii) n1($ii)]} {
             set status 0
             break
          }
      }
      return $status
}

#  MTX3_multiply(m, n, r)       r = ( m X n )      Matrix multiplication
proc  MTX3_multiply { m n r } {
      upvar $m m1 ; upvar $n n1 ; upvar $r r1
      set r1(0) [expr ($m1(0) * $n1(0) + $m1(3) * $n1(1) + $m1(6) * $n1(2))]
      set r1(1) [expr ($m1(1) * $n1(0) + $m1(4) * $n1(1) + $m1(7) * $n1(2))]
      set r1(2) [expr ($m1(2) * $n1(0) + $m1(5) * $n1(1) + $m1(8) * $n1(2))]
      set r1(3) [expr ($m1(0) * $n1(3) + $m1(3) * $n1(4) + $m1(6) * $n1(5))]
      set r1(4) [expr ($m1(1) * $n1(3) + $m1(4) * $n1(4) + $m1(7) * $n1(5))]
      set r1(5) [expr ($m1(2) * $n1(3) + $m1(5) * $n1(4) + $m1(8) * $n1(5))]
      set r1(6) [expr ($m1(0) * $n1(6) + $m1(3) * $n1(7) + $m1(6) * $n1(8))]
      set r1(7) [expr ($m1(1) * $n1(6) + $m1(4) * $n1(7) + $m1(7) * $n1(8))]
      set r1(8) [expr ($m1(2) * $n1(6) + $m1(5) * $n1(7) + $m1(8) * $n1(8))]
}

#  MTX3_transpose(m, r)         r = trns(m)        Transpose of matrix
proc  MTX3_transpose { m r } {
      upvar $m m1 ; upvar $r r1
      set r1(0) $m1(0)
      set r1(1) $m1(3)
      set r1(2) $m1(6)
      set r1(3) $m1(1)
      set r1(4) $m1(4)
      set r1(5) $m1(7)
      set r1(6) $m1(2)
      set r1(7) $m1(5)
      set r1(8) $m1(8)
}

#  MTX3_scale(s,r)              r = (s*(u))        Scale a matrix by s
proc  MTX3_scale { s r } {
      upvar $r r1
      for {set ii 0} {$ii < 9} {incr ii} {
          set r1($ii) [expr ($s * $r1($ii))]
      }
}

#  MTX3_sub(m,n,r)              r = (m - n)        Matrix subtraction
proc  MTX3_sub { m n r } {
      upvar $m m1 ; upvar $n n1 ; upvar $r r1
      for {set ii 0} {$ii < 9} {incr ii} {
          set r1($ii) [expr ($m1($ii) - $n1($ii))]
      }
}

#  MTX3_add(m,n,r)              r = (m + n)        Matrix addition
proc  MTX3_add { m n r } {
      upvar $m m1 ; upvar $n n1 ; upvar $r r1
      for {set ii 0} {$ii < 9} {incr ii} {
          set r1($ii) [expr ($m1($ii) + $n1($ii))]
      }
}

#  MTX3_vec_multiply(u, m, w)   w = (u X m)        Vector/matrix multiplication
proc  MTX3_vec_multiply { u m w } {
      upvar $u u1 ; upvar $m m1 ; upvar $w w1
      set w1(0) [expr ($u1(0) * $m1(0) + $u1(1) * $m1(1) + $u1(2) * $m1(2))]
      set w1(1) [expr ($u1(0) * $m1(3) + $u1(1) * $m1(4) + $u1(2) * $m1(5))]
      set w1(2) [expr ($u1(0) * $m1(6) + $u1(1) * $m1(7) + $u1(2) * $m1(8))]
}

#  MTX3_x(m, w)                 w = (1st column)   First column vector of matrix
proc  MTX3_x { m w } {
      upvar $m m1 ; upvar $w w1
      set w1(0) $m1(0)
      set w1(1) $m1(1)
      set w1(2) $m1(2)
}

#  MTX3_y(m, w)                 w = (2nd column)   Second column vector of matrix
proc  MTX3_y { m w } {
      upvar $m m1 ; upvar $w w1
      set w1(0) $m1(3)
      set w1(1) $m1(4)
      set w1(2) $m1(5)
}

#  MTX3_z(m, w)                 w = (3rd column)   Third column vector of matrix
proc  MTX3_z { m w } {
      upvar $m m1 ; upvar $w w1
      set w1(0) $m1(6)
      set w1(1) $m1(7)
      set w1(2) $m1(8)
}
#_______________________________________________________________________________
proc  MOM_start_of_program {} {
#_______________________________________________________________________________
# This procedure is executed at the very begining of the program.
# It gets called before any command is read from the task file.
#_______________________________________________________________________________
         global warn_file
         global mom_sys_list_file_columns
         global warn_count
         global list_file

         OPEN_files 
         LIST_FILE_HEADER 
         
         puts $warn_file "MISSING EVENT HANDLER: Event Name: MOM_start_of_program"
         puts $list_file "MISSING EVENT HANDLER: Event Name: MOM_start_of_program"
         incr warn_count +1
}

proc  MOM_end_of_program {} {
#_______________________________________________________________________________
# This procedure is executed at the end of the program after all
# the paths are traversed.
#_______________________________________________________________________________
         global warn_file
         global list_file
         global warn_count

         puts $warn_file "MISSING EVENT HANDLER: Event Name: MOM_end_of_program"
         puts $list_file "MISSING EVENT HANDLER: Event Name: MOM_end_of_program"
         incr warn_count +1

         LIST_FILE_TRAILER
         CLOSE_files
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

proc  MOM_opskip_on {} {
#_______________________________________________________________________________
# This procedure is executed when the Optional skip command is activated.
#_______________________________________________________________________________
         OPSKIP_SET
}

proc  MOM_opskip_off {} {
#_______________________________________________________________________________
# This procedure is executed when the Optional skip command is activated.
#_______________________________________________________________________________
         OPSKIP_SET
}

proc  MOM_insert {} {
#_______________________________________________________________________________
# This procedure is executed when the Insert command is activated.
#_______________________________________________________________________________
         global mom_Instruction

         MOM_output_literal "$mom_Instruction"
}

proc  MOM_pprint {} {
#_______________________________________________________________________________
# This procedure is executed when the PPrint command is activated.
#_______________________________________________________________________________
         PPRINT_OUTPUT
}

proc  MOM_operator_message {} {
#_______________________________________________________________________________
# This procedure is executed when the Operator Message command is activated.
#_______________________________________________________________________________
         global mom_operator_message
         global ptp_file_name group_output_file mom_group_name
         global need_commentary
         global mom_sys_commentary_output
         global mom_sys_control_in
         global mom_sys_control_out

         if {$mom_operator_message != "ON" && $mom_operator_message != "OFF"} {
             set brac_start [string first \( $mom_operator_message]
             set brac_end [string last \) $mom_operator_message]
             if {$brac_start != 0} {
               set text_string "("
             } else {
               set text_string ""
             }
             append text_string $mom_operator_message
             if {$brac_end != [expr [string length $mom_operator_message] -1]} {
               append text_string ")"
             }

             MOM_set_seq_off
             MOM_close_output_file   $ptp_file_name
             if {[hiset mom_group_name]} {
                if {[hiset group_output_file($mom_group_name)]} {
                   MOM_close_output_file $group_output_file($mom_group_name)
                }
             }
             MOM_output_literal      $text_string
             MOM_open_output_file    $ptp_file_name
             if {[hiset mom_group_name]} {
                if {[hiset group_output_file($mom_group_name)]} {
                   MOM_open_output_file $group_output_file($mom_group_name)
                }
             }
             MOM_set_seq_on
             set need_commentary $mom_sys_commentary_output
             set mom_sys_commentary_output OFF
             regsub -all {[)]} $text_string $mom_sys_control_in text_string
             regsub -all {[(]} $text_string $mom_sys_control_out text_string
             MOM_output_literal $text_string
             set mom_sys_commentary_output $need_commentary
         }
}

proc  MOM_before_motion {} {
#_______________________________________________________________________________
# This procedure is executed before the motion event is activated.
#_______________________________________________________________________________
         FEEDRATE_SET
}

proc  MOM_first_move {} {
#_______________________________________________________________________________
# This procedure is executed before the motion event is activated.
#_______________________________________________________________________________
         global mom_motion_event
         catch {MOM_$mom_motion_event}
}

proc SUPER_FEED_MODE_SET { feed_type } {
#_______________________________________________________________________________
# This procedure selects the proper feed rate mode into super_feed_mode
#_______________________________________________________________________________
  global   mom_sys_contour_feed_mode mom_sys_rapid_feed_mode
  global   mom_pos mom_prev_pos mom_kin_machine_type
  global   super_feed_mode

  if {$feed_type == "CONTOUR"} {
    if {[hiset mom_sys_contour_feed_mode(LINEAR)]} {
      set feed_mode(LINEAR) $mom_sys_contour_feed_mode(LINEAR)
    }
    if {[hiset mom_sys_contour_feed_mode(ROTARY)]} {
      set feed_mode(ROTARY) $mom_sys_contour_feed_mode(ROTARY)
    }
    if {[hiset mom_sys_contour_feed_mode(LINEAR_ROTARY)]} {
      set feed_mode(LINEAR_ROTARY) $mom_sys_contour_feed_mode(LINEAR_ROTARY)
    }
  } elseif {$feed_type == "RAPID"} {
    if {[hiset mom_sys_rapid_feed_mode(LINEAR)]} {
      set feed_mode(LINEAR) $mom_sys_rapid_feed_mode(LINEAR)
    }
    if {[hiset mom_sys_rapid_feed_mode(ROTARY)]} {
      set feed_mode(ROTARY) $mom_sys_rapid_feed_mode(ROTARY)
    }
    if {[hiset mom_sys_rapid_feed_mode(LINEAR_ROTARY)]} {
      set feed_mode(LINEAR_ROTARY) $mom_sys_rapid_feed_mode(LINEAR_ROTARY)
    }
  }

  if {[hiset mom_kin_machine_type]} {
    if {$mom_kin_machine_type == "3_axis_mill"} {
      if {[hiset feed_mode(LINEAR)]} {
        set super_feed_mode $feed_mode(LINEAR)
      }
    } else {
      set islinear_move 0 ; set isrotary_move 0
      switch $mom_kin_machine_type {
        4_axis_head  -
        4_axis_table -
        mill_turn {
          if {![EQ_is_equal $mom_pos(3) $mom_prev_pos(3)]} { set isrotary_move 1 }
          if {![EQ_is_equal $mom_pos(0) $mom_prev_pos(0)] || \
              ![EQ_is_equal $mom_pos(1) $mom_prev_pos(1)] || \
              ![EQ_is_equal $mom_pos(2) $mom_prev_pos(2)]} { set islinear_move 1 }
        }
        5_axis_dual_table -
        5_axis_dual_head  -
        5_axis_head_table {
          if {![EQ_is_equal $mom_pos(3) $mom_prev_pos(3)] || \
              ![EQ_is_equal $mom_pos(4) $mom_prev_pos(4)]} { set isrotary_move 1 }
          if {![EQ_is_equal $mom_pos(0) $mom_prev_pos(0)] || \
              ![EQ_is_equal $mom_pos(1) $mom_prev_pos(1)] || \
              ![EQ_is_equal $mom_pos(2) $mom_prev_pos(2)]} { set islinear_move 1 }
        }
      }

      if {$islinear_move} {
        if {$isrotary_move} {
          if {[hiset feed_mode(LINEAR_ROTARY)]} {
            set super_feed_mode $feed_mode(LINEAR_ROTARY)
          } elseif {[hiset feed_mode(ROTARY)]} {
            set super_feed_mode $feed_mode(ROTARY)
          } elseif {[hiset feed_mode(LINEAR)]} {
            set super_feed_mode $feed_mode(LINEAR)
          }
        } else {
          if {[hiset feed_mode(LINEAR)]} {
            set super_feed_mode $feed_mode(LINEAR)
          }
        }
      } else {
        if {$isrotary_move} {
          if {[hiset feed_mode(ROTARY)]} {
            set super_feed_mode $feed_mode(ROTARY)
          } elseif {[hiset feed_mode(LINEAR_ROTARY)]} {
            set super_feed_mode $feed_mode(LINEAR_ROTARY)
          } elseif {[hiset feed_mode(LINEAR)]} {
            set super_feed_mode $feed_mode(LINEAR)
          }
        }
      }
    }
  } else {
    if {[hiset feed_mode(LINEAR)]} {
      set super_feed_mode $feed_mode(LINEAR)
    }
  }
}

set feed 0.0 ; set feed_mode IPM

proc  FEEDRATE_SET {} {
#_______________________________________________________________________________
# This procedure is executed when the Feedrate is set.
#_______________________________________________________________________________
  global   feed feed_mode com_feed_rate
  global   mom_motion_type
  global   mom_cycle_feed_rate_mode mom_cycle_feed_rate
  global   mom_cycle_feed_rate_per_rev
  global   mom_feed_rate_output_mode
  global   mom_feed_rate mom_feed_rate_per_rev mom_feed_rate_number
  global   mom_warning_info
  global   Feed_IPM Feed_IPR Feed_MMPM Feed_MMPR Feed_INV
  global   mom_sys_feed_param
  global   super_feed_mode

  set super_feed_mode $mom_feed_rate_output_mode
  set f_pm $mom_feed_rate
  if {[hiset mom_feed_rate_per_rev]} {
    set f_pr $mom_feed_rate_per_rev
  } else {
    set f_pr 0.0
  }

  switch $mom_motion_type {

    CYCLE {
      if {[hiset mom_cycle_feed_rate_mode]} { set super_feed_mode $mom_cycle_feed_rate_mode }
      if {[hiset mom_cycle_feed_rate]} { set f_pm $mom_cycle_feed_rate }
      if {[hiset mom_cycle_feed_rate_per_rev]} { set f_pr $mom_cycle_feed_rate_per_rev }
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
      if {[EQ_is_zero $f_pm] && [EQ_is_zero $f_pr]} {
        SUPER_FEED_MODE_SET RAPID
      } else {
        SUPER_FEED_MODE_SET CONTOUR
      }
    }
  }

  set feed_mode $super_feed_mode

  #post builder provided format for the current mode:
  if {[info exists mom_sys_feed_param(${feed_mode},FORMAT)] != 0} {
    MOM_set_address_format F $mom_sys_feed_param(${feed_mode},FORMAT) ; set is_format_set 1
  } else {set is_format_set 0}

  switch $feed_mode {
    IPM     { if {!$is_format_set} {MOM_set_address_format F Feed_${feed_mode} } ; set feed $f_pm }
    MMPM    { if {!$is_format_set} {MOM_set_address_format F Feed_${feed_mode} } ; set feed $f_pm }
    IPR     { if {!$is_format_set} {MOM_set_address_format F Feed_${feed_mode} } ; set feed $f_pr }
    MMPR    { if {!$is_format_set} {MOM_set_address_format F Feed_${feed_mode} } ; set feed $f_pr }
    INVERSE { if {!$is_format_set} {MOM_set_address_format F Feed_INV } ; set feed $mom_feed_rate_number }
    default { set mom_warning_info "INVALID FEED RATE" ; MOM_catch_warning ; return }
  }

  set com_feed_rate $f_pm
}

#=============================================================
set cycle_name DRILL

proc CYCLE_SET { } {
#=============================================================
  global cycle_name

  WORKPLANE_SET
  MOM_force once G_motion X Y Z R
  if { [string first DWELL $cycle_name] != -1 } { MOM_force once cycle_dwell }
  if { [string first NODRAG $cycle_name] != -1 } { MOM_force once cycle_nodrag }
  if { [string first DEEP $cycle_name]!= -1 } { MOM_force once cycle_step }
  if { [string first BREAK_CHIP $cycle_name]  != -1 } { MOM_force once cycle_step }
}

#=============================================================
proc CIRCLE_SET { } {
#=============================================================
  global mom_pos_arc_plane
  switch $mom_pos_arc_plane {
    XY { MOM_suppress once K }
    YZ { MOM_suppress once I }
    ZX { MOM_suppress once J }
  }
}

#=============================================================
proc COOLANT_SET { } {
#=============================================================
  global mom_coolant_status mom_coolant_mode
  if { $mom_coolant_status == "UNDEFINED" } { return }
  if { $mom_coolant_status != "OFF" } { set mom_coolant_status ON }
  if { $mom_coolant_status == "ON" } {
    if { $mom_coolant_mode != "" } { set mom_coolant_status $mom_coolant_mode }
  }
}

#=============================================================
proc CUTCOM_SET {} {
#=============================================================
  global mom_cutcom_status mom_cutcom_mode
  
  if { $mom_cutcom_status == "UNDEFINED" } { return }
  if { $mom_cutcom_status != "OFF" } { set mom_cutcom_status ON }
  if { $mom_cutcom_status == "ON" } {
    if { $mom_cutcom_mode != "" } { set mom_cutcom_status $mom_cutcom_mode }
  }
}

#=============================================================
# call this proc in MOM_start_of_path to fix duplicate variable names.
#
proc TOOL_SET { {evt_name none} } {
#=============================================================
  global mom_tool_adjust_register mom_tool_length_adjust_register mom_length_comp_register
  global mom_cutcom_adjust_register mom_tool_cutcom_register

  switch $evt_name {
    MOM_start_of_path {
      if {[info exists mom_tool_length_adjust_register]} {
        set mom_tool_adjust_register $mom_tool_length_adjust_register
      }
      if {[info exists mom_tool_cutcom_register]} {
        set mom_cutcom_adjust_register $mom_tool_cutcom_register
      }
    }
    MOM_length_compensation {
      if {[info exists mom_length_comp_register]} {
        set mom_tool_adjust_register $mom_length_comp_register
      }
    }
  }
}

#=============================================================
proc SPINDLE_SET { } {
#=============================================================
  global mom_spindle_status mom_spindle_mode
  if { $mom_spindle_status == "UNDEFINED" } { return }
  if { $mom_spindle_status != "OFF" } { set mom_spindle_status ON }
  if { $mom_spindle_status == "ON" } {
    if { $mom_spindle_mode != "" } { set mom_spindle_status $mom_spindle_mode }
  }
}

#=============================================================
proc OPSKIP_SET { } {
#=============================================================
  global mom_opskip_status mom_sys_opskip_code
  switch $mom_opskip_status {
    ON       { MOM_set_line_leader always  $mom_sys_opskip_code }
    default  { MOM_set_line_leader off  $mom_sys_opskip_code }
  }
}

#=============================================================
proc WORKPLANE_SET { } {
#=============================================================
  global mom_cycle_spindle_axis mom_sys_spindle_axis ; #(0,1,2: x,y,z)-> PB
  global traverse_axis1 traverse_axis2

  if {[info exists mom_sys_spindle_axis] == 0} {set mom_sys_spindle_axis 2}
  if {[info exists mom_cycle_spindle_axis] == 0} {set mom_cycle_spindle_axis $mom_sys_spindle_axis}

  if {$mom_cycle_spindle_axis == 2} {
    set traverse_axis1 0 ; set traverse_axis2 1
  } elseif {$mom_cycle_spindle_axis == 0} {
    set traverse_axis1 1 ; set traverse_axis2 2
  } elseif {$mom_cycle_spindle_axis == 1} {
    set traverse_axis1 0 ; set traverse_axis2 2
  }
}

#=============================================================
proc RAPID_SET { } {
#=============================================================
  global mom_cycle_spindle_axis mom_sys_work_plane_change ; #(0/1: NO/YES)-> PB
  global traverse_axis1 traverse_axis2 mom_motion_event mom_machine_mode
  global mom_pos mom_prev_pos mom_from_pos mom_last_pos mom_sys_home_pos ; #->sys for PB
  global mom_sys_tool_change_pos
  global spindle_first rapid_spindle_inhibit rapid_traverse_inhibit

  if {[info exists mom_from_pos($mom_cycle_spindle_axis)] == 0 && \
      [info exists  mom_sys_home_pos($mom_cycle_spindle_axis)]} {
    set mom_from_pos(0) $mom_sys_home_pos(0)
    set mom_from_pos(1) $mom_sys_home_pos(1)
    set mom_from_pos(2) $mom_sys_home_pos(2)
  } elseif {[info exists  mom_sys_home_pos($mom_cycle_spindle_axis)] == 0 && \
            [info exists mom_from_pos($mom_cycle_spindle_axis)]} {
    set mom_sys_home_pos(0) $mom_from_pos(0)
    set mom_sys_home_pos(1) $mom_from_pos(1)
    set mom_sys_home_pos(2) $mom_from_pos(2)
  } elseif {[info exists  mom_sys_home_pos($mom_cycle_spindle_axis)] == 0 && \
            [info exists mom_from_pos($mom_cycle_spindle_axis)] == 0} {
    set mom_from_pos(0) 0.0 ; set mom_sys_home_pos(0) 0.0
    set mom_from_pos(1) 0.0 ; set mom_sys_home_pos(1) 0.0
    set mom_from_pos(2) 0.0 ; set mom_sys_home_pos(2) 0.0
  }

  if {[info exists mom_sys_tool_change_pos($mom_cycle_spindle_axis)] == 0} {
    set mom_sys_tool_change_pos($mom_cycle_spindle_axis) 100000.0
  }

  if {$mom_motion_event == "initial_move" || $mom_motion_event == "first_move"} {
    set mom_last_pos($mom_cycle_spindle_axis) $mom_sys_tool_change_pos($mom_cycle_spindle_axis)
  } else {
    if {[info exists mom_last_pos($mom_cycle_spindle_axis)] == 0} {
      set mom_last_pos($mom_cycle_spindle_axis) $mom_sys_home_pos($mom_cycle_spindle_axis)
    }
  }

  if {$mom_machine_mode != "MILL"} {return}

  WORKPLANE_SET ; set rapid_spindle_inhibit FALSE ; set rapid_traverse_inhibit FALSE

  if { $mom_pos($mom_cycle_spindle_axis) <=  $mom_last_pos($mom_cycle_spindle_axis)} {
    set going_lower 1
  } else {
    set going_lower 0
  }

  if {[info exists mom_sys_work_plane_change] == 0} {set mom_sys_work_plane_change 1}

  if {$mom_sys_work_plane_change} {
    if {$going_lower} {set spindle_first FALSE} else {set spindle_first TRUE}

    if {[EQ_is_equal $mom_pos($mom_cycle_spindle_axis) $mom_last_pos($mom_cycle_spindle_axis)]} {
      set rapid_spindle_inhibit TRUE
    } else {set rapid_spindle_inhibit FALSE}

    if {[EQ_is_equal $mom_pos($traverse_axis1) $mom_prev_pos($traverse_axis1)] && \
        [EQ_is_equal $mom_pos($traverse_axis2) $mom_prev_pos($traverse_axis2)]} {
      set rapid_traverse_inhibit TRUE
    } else {set rapid_traverse_inhibit FALSE}

  } else { set spindle_first NONE }
}

#=============================================================
proc SEQNO_SET { } {
#=============================================================
  global mom_sequence_mode mom_sequence_number
  global mom_sequence_increment mom_sequence_frequency
  if { [info exists mom_sequence_mode] } {
    switch $mom_sequence_mode {
      OFF     { MOM_set_seq_off }
      ON      { MOM_set_seq_on }
      default { MOM_output_literal "error:  mom_sequence_mode unknown" }
    }
  } else {
    MOM_reset_sequence $mom_sequence_number $mom_sequence_increment $mom_sequence_frequency
  }
}

#=============================================================
proc MODES_SET { } {
#=============================================================
  global mom_output_mode
  switch $mom_output_mode {
    ABSOLUTE { set isincr OFF }
    default  { set isincr ON }
  }
  MOM_incremental $isincr X Y Z
}

#============================================================="
proc IN_SEQUENCE { evt_name } {
#============================================================="
  global in_sequence mom_motion_type

  # if it is a move event:
  set move_event [string last "move" $evt_name]
  if {$move_event != -1} {
    switch $mom_motion_type {
      CUT            { set in_sequence none }
      RAPID          {  }
      ENGAGE         {  }
      RETRACT        {  }
      FIRSTCUT       { set in_sequence none }
      APPROACH       {  }
      STEPOVER       { set in_sequence none }
      DEPARTURE      {  }
      RETURN         {set in_sequence RETURN }
      TRAVERSAL      {  }
      SIDECUT        { set in_sequence none }
      FROM           { set in_sequence FROM }
      GOHOME         {set in_sequence GOHOME }
      GOHOME_DEFAULT {set in_sequence GOHOME }
      CYCLE          {  }
      LIFT           {  }
      UNDEFINED      {  }
    }
  } else {
    switch $evt_name {
      MOM_start_of_program {set in_sequence start_of_program}
      MOM_start_of_path {set in_sequence start_of_path}
      MOM_end_of_path {set in_sequence end_of_path}
      MOM_end_of_program {set in_sequence end_of_program}
      default  { }
    }
  }
}

proc CHECK_OPER_TYPE {} {
#_______________________________________________________________________________
# This procedure generates the warnings for mismatched machine_type and machine_mode.
#_______________________________________________________________________________
  global mom_kin_machine_type
  global mom_machine_mode
  global mom_warning_info
  
  if {[isset mom_kin_machine_type] == "n"} {
    set machine_type MILL
  } elseif {[regexp lathe $mom_kin_machine_type] == 1} {
    set machine_type TURN
  } elseif {[regexp wedm $mom_kin_machine_type] == 1} {
    set machine_type WIRE
  } elseif {[regexp mill_turn $mom_kin_machine_type] == 1} {
    set machine_type MILL-TURN
  } else {
    set machine_type MILL
  }

  if {$machine_type == "MILL-TURN"} {
    if {$mom_machine_mode != "MILL" && $mom_machine_mode != "TURN"} {
      set mom_warning_info \
         "MISMATCHED operation($mom_machine_mode) and machine($machine_type): Event Name: MOM_start_of_path"
      MOM_catch_warning
    }
  } elseif {$machine_type != $mom_machine_mode} {
    set mom_warning_info \
        "MISMATCHED operation($mom_machine_mode) and machine($machine_type): Event Name: MOM_start_of_path"
    MOM_catch_warning
  }
}
proc MOM_catch_warning {} {
#_______________________________________________________________________________
# This procedure generates the warnings for missing procedures and values
# falling out of MIN/MAX. 
#_______________________________________________________________________________
         global mom_warning_info
         global warn_file list_file warn_count
         global group_warn_file group_list_file group_warn_count
         global mom_sys_seqnum_start mom_sys_seqnum_freq mom_sys_seqnum_incr

         if {[regexp "MOM_msys" $mom_warning_info] == 1} { return }
         if {[regexp "MOM_machine_mode" $mom_warning_info] == 1} { return }
         if {[regexp "MOM_origin" $mom_warning_info] == 1} { return }
         if {[regexp "MOM_translate" $mom_warning_info] == 1} { return }
         if {[regexp "MOM_lintol" $mom_warning_info] == 1} { return }
         if {[regexp "MOM_tlset" $mom_warning_info] == 1} { return }
  
         if { [regexp  "mom_seqnum" $mom_warning_info] == 1 } {
            if {[hiset mom_sys_seqnum_start] && [hiset mom_sys_seqnum_freq] && [hiset mom_sys_seqnum_incr]} {
              MOM_reset_sequence $mom_sys_seqnum_start $mom_sys_seqnum_incr $mom_sys_seqnum_freq
            }
         }

         if {[hiset list_file]} {puts $list_file "$mom_warning_info "}
         if {[hiset warn_file]} {
           puts $warn_file "$mom_warning_info " ; incr warn_count +1
         }
         if {[hiset group_list_file]} {puts $group_list_file "$mom_warning_info "}
         if {[hiset group_warn_file]} {
           puts $group_warn_file "$mom_warning_info " ; incr group_warn_count +1
         }
}

#_______________________________________________________________________________
# The following procedures are executed to get the commentary data output and the
# warning output. The commentary output data is stored in the the file ptp_name.lpt.
# The warning data is stored in the file ptp_name_warning.out.
#_______________________________________________________________________________
proc  OPEN_files {} {
  global mom_logname mom_date mom_ug_version mom_part_name mom_event_handler_file_name mom_definition_file_name
  global mom_output_file_directory mom_output_file_basename mom_output_file_suffix
  global mom_sys_output_file_suffix mom_sys_list_file_suffix output_extn list_extn
  global mom_parent_group_name mom_group_name mom_sys_group_output
  global ptp_file_name lpt_file_name warning_file_name mom_group_name prev_group_name
  global list_file warn_file group_list_file group_warn_file group_level
  global group_output_file group_lpt_file_name group_warning_file_name
  global warn_count line_count page_number
  global group_warn_count group_line_count group_page_number
  global mom_sys_ptp_output mom_sys_list_output mom_sys_warning_output mom_warning_info
  global isinit_files isinit_group
  global mom_tool_use ; # Temporary fix for mom_tool_count bug

  if {![hiset isinit_files]} {
    for {set i 0} {$i <= 100} {incr i} { set mom_tool_use($i,0) 0 }

    set output_extn "" ; set list_extn ""

    if {[hiset mom_output_file_suffix]} {
      if {[string length $mom_output_file_suffix] > 0} {
        set output_extn ".${mom_output_file_suffix}"
      }
    }

    if {[string length $output_extn] == 0} {
      if {[string length $mom_sys_output_file_suffix] > 0} {
        set output_extn ".${mom_sys_output_file_suffix}"
      }
    }

    if {[string length $mom_sys_list_file_suffix] > 0} {
      set list_extn ".${mom_sys_list_file_suffix}"
    }

    set ptp_file_name "${mom_output_file_directory}${mom_output_file_basename}${output_extn}"
    set lpt_file_name "${mom_output_file_directory}${mom_output_file_basename}${list_extn}"
    set warning_file_name "${mom_output_file_directory}${mom_output_file_basename}_warning.out"

    # puts stdout  "******************************************************"
    # puts stdout  "  UG_POST    VERSION       : $mom_ug_version"
    # puts stdout  "******************************************************"
    # puts stdout  "  USER NAME / DATE   : $mom_logname / $mom_date"
    # puts stdout  "  INPUT PART        : $mom_part_name"
    # puts stdout  "  USING             : $mom_event_handler_file_name , $mom_definition_file_name"
    # puts stdout  "******************************************************"

    MOM_close_output_file $ptp_file_name
    # puts stdout  "  CLOSED PRE-EXISTING MAIN $ptp_file_name"
    if {$mom_sys_ptp_output == "ON"} {
      if {[file exists $ptp_file_name]} {
        MOM_remove_file $ptp_file_name
        # puts stdout  "  REMOVED PRE-EXISTING MAIN $ptp_file_name"
      }
      MOM_open_output_file $ptp_file_name
      # puts stdout  "  OPENED FRESH MAIN $ptp_file_name"
      # puts stdout  "  GENERATING        : $ptp_file_name"
    }

    if {$mom_sys_list_output == "ON"} {
      if {[file exists $lpt_file_name]} {
        MOM_remove_file $lpt_file_name
        # puts stdout  "  REMOVED PRE-EXISTING MAIN $lpt_file_name"
      }
      set list_file [open "$lpt_file_name" w ] ; set line_count 0 ; set page_number 0
      # puts stdout  "  OPENED FRESH MAIN $lpt_file_name ; CHANNEL $list_file"
      # puts stdout  "  GENERATING        : $lpt_file_name"
    }

    if {$mom_sys_warning_output == "ON"} {
      if {[file exists $warning_file_name]} {
        MOM_remove_file $warning_file_name
        # puts stdout  "  REMOVED PRE-EXISTING MAIN $warning_file_name"
      }
      set warn_file [open "$warning_file_name" w ] ; set warn_count 0
      # puts stdout  "  OPENED FRESH MAIN $warning_file_name ; CHANNEL $warn_file"
      # puts stdout  "  GENERATING        : $warning_file_name"
    }

    set isinit_files TRUE
  }

  if {$mom_sys_group_output == "ON"} {
    if {[hiset mom_group_name] && [hiset group_level]} {
      if {[hiset prev_group_name]} {
        if {$mom_group_name == "$prev_group_name"} {
          return
        } else {
          if {[hiset group_output_file($prev_group_name)]} {
            MOM_close_output_file $group_output_file($prev_group_name)
            # puts stdout  "  CLOSED PREVIOUS GROUP $group_output_file($prev_group_name)"
          }
          if {[hiset group_list_file]} {
            # puts stdout  "  CLOSED PREVIOUS GROUP LIST CHANNEL $group_list_file"
            close $group_list_file ; unset group_list_file
          }
          if {[hiset group_warn_file]} {
            # puts stdout  "  CLOSED PREVIOUS GROUP WARN CHANNEL $group_warn_file"
            close $group_warn_file ; unset group_warn_file
          }
        }
      }
      set prev_group_name $mom_group_name

      if {![hiset isinit_group($mom_group_name)] && $group_level == 1} {
        if {$mom_sys_ptp_output == "ON"} {
          set grp_ptp_name "${mom_output_file_basename}_${mom_group_name}${output_extn}"
          if { [string length $grp_ptp_name] > 30} {
            set grp_ptp_name "${mom_group_name}${output_extn}"
            set mom_warning_info "Group name too long. Creating $grp_ptp_name"
            MOM_catch_warning
          }
          set group_output_file($mom_group_name) "${mom_output_file_directory}${grp_ptp_name}"
          MOM_close_output_file $group_output_file($mom_group_name)
          # puts stdout  "  CLOSED PRE-EXISTING GROUP $group_output_file($mom_group_name)"
          if {[file exists $group_output_file($mom_group_name)]} {
            MOM_remove_file $group_output_file($mom_group_name)
            # puts stdout  "  REMOVED PRE-EXISTING GROUP $group_output_file($mom_group_name)"
          }
          MOM_open_output_file $group_output_file($mom_group_name)
          # puts stdout  "  OPENED FRESH GROUP $group_output_file($mom_group_name)"
          # puts stdout  "  GENERATING GROUP FILE  : $group_output_file($mom_group_name)"
          MOM_output_literal "(*** generating group file $group_output_file($mom_group_name) ***)"
        }

        if {$mom_sys_list_output == "ON"} {
          set grp_lpt_name ${mom_output_file_basename}_${mom_group_name}${list_extn}
          if { [string length $grp_lpt_name] > 30} {
            set grp_lpt_name ${mom_group_name}${list_extn}
            set mom_warning_info "Group name too long. Creating $grp_lpt_name"
            MOM_catch_warning
          }
          set group_lpt_file_name "${mom_output_file_directory}${grp_lpt_name}"
          if {[hiset group_list_file]} {
            # puts stdout  "  CLOSED PRE-EXISTING GROUP LIST CHANNEL $group_list_file"
            close $group_list_file ; unset group_list_file
          }
          if {[file exists $group_lpt_file_name]} {
            MOM_remove_file $group_lpt_file_name
            # puts stdout  "  REMOVED PRE-EXISTING GROUP LIST $group_lpt_file_name"
          }
          set group_list_file [open "$group_lpt_file_name" w] ; set group_line_count 0 ; set group_page_number 0
          # puts stdout  "  OPENED FRESH GROUP LIST $group_lpt_file_name ; CHANNEL $group_list_file"
          # puts stdout  "  GENERATING GROUP FILE  : $group_lpt_file_name"
        }

        if {$mom_sys_warning_output == "ON"} {
          set grp_warn_name ${mom_output_file_basename}_${mom_group_name}_warning.out
          if {[string length $grp_warn_name] > 30} {
            set grp_warn_name ${mom_group_name}_warning.out
            if {[string length $grp_warn_name] > 30} { set grp_warn_name ${mom_group_name}.out }
            set mom_warning_info "Group name too long. Creating $grp_warn_name"
            MOM_catch_warning
          }
          set group_warning_file_name ${mom_output_file_directory}${grp_warn_name}
          if {[hiset group_warn_file]} {
            # puts stdout  "  CLOSED PRE-EXISTING GROUP WARN CHANNEL $group_warn_file"
            close $group_warn_file ; unset group_warn_file
          }
          if {[file exists $group_warning_file_name]} {
            MOM_remove_file $group_warning_file_name
            # puts stdout  "  REMOVED PRE-EXISTING GROUP WARN $group_warning_file_name"
          }
          set group_warn_file [open "$group_warning_file_name" w] ; set group_warn_count 0
          # puts stdout  "  OPENED FRESH GROUP WARN $group_warning_file_name ; CHANNEL $group_warn_file"
          # puts stdout  "  GENERATING GROUP FILE  : $group_warning_file_name"
        }

        set isinit_group($mom_group_name) TRUE
      }
    }
  }
}

proc  CLOSE_files {} {
         global warn_file list_file
         global group_warn_file group_list_file
         global warning_file_name
         global warn_count

         if {[hiset group_list_file] == 0 && [hiset group_warn_file] == 0} {
           if {[hiset list_file]} {close $list_file ; unset list_file}
           if {[hiset warn_file]} {close $warn_file ; unset warn_file}
           if { $warn_count > 0 } {
              MOM_output_to_listing_device\
                  "***********************************************************"
              MOM_output_to_listing_device\
                  "Check $warning_file_name for any Errors/Warnings during postprocessing"
              MOM_output_to_listing_device\
                  "***********************************************************"
              }
         } else {
           if {[hiset group_list_file]} {close $group_list_file ; unset group_list_file}
           if {[hiset group_warn_file]} {close $group_warn_file ; unset group_warn_file}
         }
}

proc  LIST_FILE {} {
	 global mom_o_buffer
         global space_buffer
         global list_file group_list_file
         global mom_sys_list_file_columns
         global mom_sys_list_file_rows
         global warn_count line_count page_number
         global group_warn_count group_line_count group_page_number
         global page_title
         global header 
         global spaces1
         global mom_sys_commentary_output

#*****************ASSUMPTION*************************
         global mom_pos
         if { [info exists mom_pos(3)] == 0 } {
            set mom_pos(3) 0
         } 
         if { [info exists mom_pos(4)] == 0 } {
            set mom_pos(4) 0
         }   
#****************************************************
         set local_o_buffer $mom_o_buffer
         set commentary [ MOM_do_template comment_data CREATE ]
         set outs [ concat $local_o_buffer " " ]
         set list_cut [expr ( $mom_sys_list_file_columns  +  1)]

         if { [string length $outs] < $mom_sys_list_file_columns } {
                append outs $spaces1
                set outs [string range $outs 0 $list_cut]
                append outs $commentary
         } else {
                append outs "\n$spaces1 $commentary "
                incr line_count  +1
                incr group_line_count +1
         }

         incr line_count  +1 ; incr group_line_count +1
         
         if {[hiset list_file]} {
           if { $line_count == $mom_sys_list_file_rows} {
               puts $list_file " \f "
               puts $list_file $page_title$page_number
               puts $list_file $header
               incr page_number +1
               set line_count 0
           }
           if { $mom_sys_commentary_output == "ON"} {puts $list_file $outs}
         }
         if {[hiset group_list_file]} {
           if { $group_line_count == $mom_sys_list_file_rows} {
               puts $group_list_file " \f "
               puts $group_list_file $page_title$page_number
               puts $group_list_file $header
               incr group_page_number +1
               set group_line_count 0
           }
           if { $mom_sys_commentary_output == "ON"} {puts $group_list_file $outs}
         }
} 

proc  LIST_FILE_HEADER {} {
  global mom_sys_list_output mom_sys_header_output mom_sys_list_file_columns
  global mom_ug_version mom_logname mom_date
  global mom_part_name mom_event_handler_file_name mom_definition_file_name
  global ptp_file_name lpt_file_name warning_file_name
  global group_output_file group_lpt_file_name group_warning_file_name mom_group_name
  global list_file group_list_file
  global warn_count line_count page_number
  global group_warn_count group_line_count group_page_number
  global page_title header spaces1
  global isdone_list_file prev_group_lpt_file_name

  set line_count 0 ; set warn_count 0 ; set page_number 1
  set group_line_count 0 ; set group_warn_count 0 ; set group_page_number 1
  set blan      " "
  set header    " "
  set page_title "UGPOST $mom_ug_version $mom_part_name $mom_date"
  set spaces1 ""
  set sub_header1 "Page "

  if { $mom_sys_header_output != "ON" } { return }

  for { set inx 0 } { $inx < [expr ($mom_sys_list_file_columns - 96)] } { incr inx +1 } {
       append page_title $blan 
  }
  append page_title $sub_header1

  set mom_sys_list_file_columns [expr ($mom_sys_list_file_columns - 90)]

  set sub_header2 " EVE-NO  ABS-X     ABS-Y     ABS-Z     4AXIS    5AXIS    FEED    RPM   MIN"
  for { set inx 0 } { $inx < $mom_sys_list_file_columns } { incr inx +1 } {
       append header $blan 
  }

  set spaces1 $header
  append header $sub_header2 

  if {[hiset list_file] && ![hiset isdone_list_file]} {
    puts $list_file $page_title
    puts $list_file  "\n\n\n\n\n\n\n"            
  
    puts $list_file  "\t\tUU     UU    GGGGG        PPPPPP     OOOOO      SSSSS   TTTTTTTT"
    puts $list_file  "\t\tUU     UU   GGGGGGG      PPPPPPPP   OOOOOOO    SSSSSSS  TTTTTTTT"
    puts $list_file  "\t\tUU     UU  GG     GG     PP    PP  OO     OO  SS           TT   "
    puts $list_file  "\t\tUU     UU  GG            PP    PP  OO     OO  SS           TT   "
    puts $list_file  "\t\tUU     UU  GG   GGGG     PPPPPPP   OO     OO    SSSSSS     TT   "
    puts $list_file  "\t\tUU     UU  GG     GG     PPPPPP    OO     OO         SS    TT   "
    puts $list_file  "\t\tUU     UU  GG     GG     PP        OO     OO  SS     SS    TT   "
    puts $list_file  "\t\t UUUUUUU    GGGGGGG      PP         OOOOOOO   SSSSSSSS     TT   "
    puts $list_file  "\t\t  UUUUU      GGGGG       PP          OOOOO     SSSSSS      TT   "

    puts $list_file  "\n\n\n\n\n\n\n"            
  
    puts $list_file  "     UG_POST    VERSION       NUMBER : $mom_ug_version"            
    puts $list_file  "     UG_POST    EXECUTED      BY     : $mom_logname" 
    puts $list_file  "     UG_POST    EXECUTION     DATE   : $mom_date" 
    puts $list_file  "     UG_POST    POST          NAME   : "            
    puts $list_file  "     UG_POST    TCL     FILE  NAME   : $mom_event_handler_file_name"            
    puts $list_file  "     UG_POST    DEF     FILE  NAME   : $mom_definition_file_name"            
    puts $list_file  "     UG_POST    PART    FILE  NAME   : $mom_part_name"
    if {[hiset ptp_file_name]} {puts $list_file  "     UG_POST    PTP     FILE  NAME   : $ptp_file_name"}
    if {[hiset lpt_file_name]} {puts $list_file  "     UG_POST    LPT     FILE  NAME   : $lpt_file_name"}
    if {[hiset warning_file_name]} {puts $list_file  "     UG_POST    WARNING FILE  NAME   : $warning_file_name"}
    puts $list_file  "\f"          
    puts $list_file $page_title$page_number
    puts $list_file $header

    incr page_number +1
    set isdone_list_file TRUE
  }

  if {![hiset group_lpt_file_name]} {return}
  if {[hiset prev_group_lpt_file_name]} {
    if {$group_lpt_file_name == "$prev_group_lpt_file_name"} {
      return
    } else {
      set prev_group_lpt_file_name $group_lpt_file_name
    }
  } else {
    set prev_group_lpt_file_name $group_lpt_file_name
  }

  if {[hiset group_list_file]} {
    puts $group_list_file $page_title
    puts $group_list_file  "\n\n\n\n\n\n\n"            
 
    puts $group_list_file  "\t\tUU     UU    GGGGG        PPPPPP     OOOOO      SSSSS   TTTTTTTT"
    puts $group_list_file  "\t\tUU     UU   GGGGGGG      PPPPPPPP   OOOOOOO    SSSSSSS  TTTTTTTT"
    puts $group_list_file  "\t\tUU     UU  GG     GG     PP    PP  OO     OO  SS           TT   "
    puts $group_list_file  "\t\tUU     UU  GG            PP    PP  OO     OO  SS           TT   "
    puts $group_list_file  "\t\tUU     UU  GG   GGGG     PPPPPPP   OO     OO    SSSSSS     TT   "
    puts $group_list_file  "\t\tUU     UU  GG     GG     PPPPPP    OO     OO         SS    TT   "
    puts $group_list_file  "\t\tUU     UU  GG     GG     PP        OO     OO  SS     SS    TT   "
    puts $group_list_file  "\t\t UUUUUUU    GGGGGGG      PP         OOOOOOO   SSSSSSSS     TT   "
    puts $group_list_file  "\t\t  UUUUU      GGGGG       PP          OOOOO     SSSSSS      TT   "

    puts $group_list_file  "\n\n\n\n\n\n\n"            
 
    puts $group_list_file  "     UG_POST    VERSION       NUMBER : $mom_ug_version"            
    puts $group_list_file  "     UG_POST    EXECUTED      BY     : $mom_logname" 
    puts $group_list_file  "     UG_POST    EXECUTION     DATE   : $mom_date" 
    puts $group_list_file  "     UG_POST    POST          NAME   : "            
    puts $group_list_file  "     UG_POST    TCL     FILE  NAME   : $mom_event_handler_file_name"            
    puts $group_list_file  "     UG_POST    DEF     FILE  NAME   : $mom_definition_file_name"            
    puts $group_list_file  "     UG_POST    PART    FILE  NAME   : $mom_part_name"
    if {[hiset group_output_file($mom_group_name)]} {
      puts $group_list_file  "     UG_POST    PTP     FILE  NAME   : $group_output_file($mom_group_name)"
    }
    puts $group_list_file  "     UG_POST    LPT     FILE  NAME   : $group_lpt_file_name"
    if {[hiset group_warning_file_name]} {puts $group_list_file  "     UG_POST    WARNING FILE  NAME   : $group_warning_file_name"}
    puts $group_list_file  "\f"          
    puts $group_list_file $page_title$group_page_number
    puts $group_list_file $header

    incr group_page_number +1
  }
}

proc  LIST_FILE_TRAILER {} {
         global list_file warn_count page_number
         global group_list_file group_warn_count group_page_number
         global page_title
         global mom_machine_time
         global mom_tool_use
         global mom_tool_count
  
         if {[hiset mom_machine_time] == 0} {set mom_machine_time 0}
         if {[hiset list_file] && [hiset group_list_file] == 0} {
           puts $list_file  "\f"          
           puts $list_file        $page_title$page_number
           puts $list_file  "     \n\n\n\n\n\n\n                    "            
           puts $list_file  "     UG_POST MACHINE TIME            :[ format  "%.2f" $mom_machine_time]" 
           puts $list_file  "     NUMBER OF WARNINGS              : $warn_count"
           if {[isset mom_tool_count] == "n"} {return}
           puts $list_file  "\f "          
           puts $list_file  "********************************************************************************"
           puts $list_file  "                       TOOL LIST WITH TOOL USED TIME"
           puts $list_file  "********************************************************************************"

           if {[hiset mom_tool_count]} {
             for { set nn 0 } { $nn < $mom_tool_count } {incr nn} {
               if {[hiset mom_tool_use($nn,0)] && [hiset mom_tool_use($nn,1)]} {
                 puts $list_file  "  TOOL  NUMBER [ format  "%.2f  %.2f"    $mom_tool_use($nn,0)         $mom_tool_use($nn,1)] minutes"
               }
             }
           }
           puts $list_file  "********************************************************************************"
         }
         if {[hiset group_list_file]} {
           puts $group_list_file  "\f"          
           puts $group_list_file        $page_title$page_number
           puts $group_list_file  "     \n\n\n\n\n\n\n                    "            
           puts $group_list_file  "     UG_POST MACHINE TIME            :[ format  "%.2f" $mom_machine_time]" 
           puts $group_list_file  "     NUMBER OF WARNINGS              : $warn_count"
           if {[isset mom_tool_count] == "n"} {return}
           puts $group_list_file  "\f "          
           puts $group_list_file  "********************************************************************************"
           puts $group_list_file  "                       TOOL LIST WITH TOOL USED TIME"
           puts $group_list_file  "********************************************************************************"

           if {[hiset mom_tool_count]} {
             for { set nn 0 } { $nn < $mom_tool_count } {incr nn} {
               if {[hiset mom_tool_use($nn,0)] && [hiset mom_tool_use($nn,1)]} {
                 puts $group_list_file  "  TOOL  NUMBER [ format  "%.2f  %.2f"    $mom_tool_use($nn,0)         $mom_tool_use($nn,1)] minutes"
               }
             }
           }
           puts $group_list_file  "********************************************************************************"
         }
}

proc PPRINT_OUTPUT {} {
         global mom_pprint
         global mom_operator_message_status
         global ptp_file_name group_output_file mom_group_name
         global need_commentary
         global mom_sys_commentary_output
         global mom_sys_control_in
         global mom_sys_control_out
         global mom_warning_info

         if {$mom_operator_message_status == "ON"} {

            set brac_start [string first \( $mom_pprint]
            set brac_end [string last \) $mom_pprint]
            if {$brac_start != 0} {
               set text_string "("
            } else {
               set text_string ""
            }
            append text_string $mom_pprint
            if {$brac_end != [expr [string length $mom_pprint] -1]} {
               append text_string ")"
            }

            MOM_set_seq_off
            MOM_close_output_file   $ptp_file_name
            if {[hiset mom_group_name]} {
               if {[hiset group_output_file($mom_group_name)]} {
                  MOM_close_output_file $group_output_file($mom_group_name)
               }
            }
            MOM_output_literal      $text_string
            MOM_open_output_file    $ptp_file_name
            if {[hiset mom_group_name]} {
               if {[hiset group_output_file($mom_group_name)]} {
                  MOM_open_output_file $group_output_file($mom_group_name)
               }
            }
            MOM_set_seq_on
            set need_commentary $mom_sys_commentary_output
            set mom_sys_commentary_output OFF
            regsub -all {[)]} $text_string $mom_sys_control_in text_string
            regsub -all {[(]} $text_string $mom_sys_control_out text_string
            MOM_output_literal $text_string
            set mom_sys_commentary_output $need_commentary

         } elseif {$mom_operator_message_status == "OFF"} {
            set brac_start [string first \( $mom_pprint]
            set brac_end   [string first \) $mom_pprint]
            set length [string length $mom_pprint]

            if { ($brac_start >= 0) && ($brac_end > $brac_start) } {
               MOM_set_seq_off
               MOM_close_output_file   $ptp_file_name
               if {[hiset mom_group_name]} {
                  if {[hiset group_output_file($mom_group_name)]} {
                     MOM_close_output_file $group_output_file($mom_group_name)
                  }
               }
               MOM_output_literal      $mom_pprint
               MOM_open_output_file    $ptp_file_name
               if {[hiset mom_group_name]} {
                  if {[hiset group_output_file($mom_group_name)]} {
                     MOM_open_output_file $group_output_file($mom_group_name)
                  }
               }
               MOM_set_seq_on
               set brack [string range $mom_pprint $brac_start $brac_end]
               set out 0
               for {set ii $brac_end} {$ii < $length} {incr ii} {
                  if {($out == 0) && ([string index $mom_pprint $ii] == "(")} {
                     set out 1
                     set brac_start $ii
                  } elseif {($out == 1) && ([string index $mom_pprint $ii] == ")")} {
                     set out 0
                     set brac_end $ii
                     append brack [string range $mom_pprint $brac_start $brac_end]
                  }

               }
############
#set brac_end_last [string last \) $mom_pprint $length]
#while {$brac_end < $brac_end_last} {
#        set brac_start [string first \( $mom_pprint $brac_end]
#        if {$brac_start == -1} {set brac_start [expr $brac_end +1]}
#        set brac_end   [string first \) $mom_pprint $brac_end]
#        if {$brac_end != -1} {
#          append brack [string range $mom_pprint $brac_start $brac_end]
#        }
#}
############
               set need_commentary $mom_sys_commentary_output
               set mom_sys_commentary_output OFF
               set text_string $brack
               regsub -all {[)]} $text_string $mom_sys_control_in text_string
               regsub -all {[(]} $text_string $mom_sys_control_out text_string
               MOM_output_literal $text_string
               set mom_sys_commentary_output $need_commentary
            } else {
               if { ($brac_start >= 0) && ($brac_end == -1) } {
                  set mom_warning_info "PPRINT-NO CONTROL-IN FOLLOWING CONTROL-OUT"
                  MOM_catch_warning
               } elseif { ($brac_start == -1) && ($brac_end >= 0) } {
                  set mom_warning_info "PPRINT-NO CONTROL-OUT PRECEDING CONTROL-IN"
                  MOM_catch_warning
               }
               MOM_set_seq_off
               MOM_close_output_file   $ptp_file_name
               if {[hiset mom_group_name]} {
                  if {[hiset group_output_file($mom_group_name)]} {
                     MOM_close_output_file $group_output_file($mom_group_name)
                  }
               }
               MOM_output_literal $mom_pprint
               MOM_open_output_file    $ptp_file_name
               if {[hiset mom_group_name]} {
                  if {[hiset group_output_file($mom_group_name)]} {
                     MOM_open_output_file $group_output_file($mom_group_name)
                  }
               }
               MOM_set_seq_on
            }
         }
}

#_______________________________________________________________________________
# utility to return "y" if the variable v1 is set, else "n"
# example set xx [isset yy] returns xx as "y" or "n"
# example if {[isset yy] == "y"} {puts $list_file "yy"}
#_______________________________________________________________________________
proc isset { v1 } {
         upvar $v1 v2
         if { [info exists v2] } { return y } else { return n }
}

#_______________________________________________________________________________
# utility to return TRUE(1) if the variable v1 is set, else FALSE(0)
# example set xx [hiset yy] returns xx as TRUE(1) or FALSE(0)
# example if {[hiset yy]} {puts $list_file "yy"}
#_______________________________________________________________________________
proc hiset { v1 } {
         upvar $v1 v2
         if { [info exists v2] } { return 1 } else { return 0 }
}

#_______________________________________________________________________________
# utility to return a variable v1 after formatting it per f1
# example set x [fmt $y "%.3f"] returns x after formatting y per %.3f
#_______________________________________________________________________________
proc fmt { v1 f1 } {
         set v2 [format $f1 $v1] ; return $v2
}

proc CASE { v1 } {
#______________________________________________________________________
#
# RETURNS STRING IN UPPER CASE
#______________________________________________________________________

  set v2 [string toupper $v1]
  return $v2
}

proc MOM_start_of_group {} {
  global mom_sys_group_output mom_group_name group_level ptp_file_name
  global mom_sys_seqnum_start mom_sys_seqnum_freq mom_sys_seqnum_incr

  if {[regexp NC_PROGRAM $mom_group_name] == 1} {set group_level 0 ; return}
  set mom_group_name [string tolower $mom_group_name]
  if {[hiset mom_sys_group_output]} { if {$mom_sys_group_output == "OFF"} {set group_level 0 ; return}}
  if {[hiset group_level]} {incr group_level} else {set group_level 1}
  if {$group_level > 1} {return}

  # reset sequence number; what do we reset the sequence number to?  
  if {[hiset mom_sys_seqnum_start] && [hiset mom_sys_seqnum_freq] && [hiset mom_sys_seqnum_incr]} {
    MOM_reset_sequence $mom_sys_seqnum_start $mom_sys_seqnum_incr $mom_sys_seqnum_freq
  }

  # temporarily close the main ptp_file_name if MOM_start_of_program is revisited
  # proof of MOM_start_of_program being revisited: ptp_file_name would be defined
  if {[info exists ptp_file_name]} {
    MOM_close_output_file $ptp_file_name ; MOM_start_of_program ; MOM_open_output_file $ptp_file_name
  } else {
    MOM_start_of_program
  }
}

proc MOM_end_of_group {} {
  global mom_sys_group_output group_output_file group_level mom_group_name
  global mom_parent_group_name mom_group_name ptp_file_name

  if {[hiset group_level]} {
    if {$group_level == 0} {
      return
    } else {
      if {$group_level == 1} {
        set mom_group_name [string tolower $mom_group_name]
        MOM_close_output_file $ptp_file_name ; MOM_end_of_program ; MOM_open_output_file $ptp_file_name
        MOM_close_output_file $group_output_file($mom_group_name)
        unset group_output_file($mom_group_name)
      }
      incr group_level -1
    }
  } else {return}
}
