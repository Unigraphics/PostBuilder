################################################################################
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
################################################################################
#
# 
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
         set mom_sys_cutcom_plane_code(XZ)          18
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
         set mom_sys_frn_factor                     "1.0"

         set mom_sys_output_file_suffix             "ptp"
         set mom_sys_list_file_suffix               "lpt"
#_______________________________________________________________________________
         set tape_bytes 0
#_______________________________________________________________________________
set PI [expr 2.0 * asin(1.0)]                    ; #value PI
set RAD2DEG [expr 90.0 / asin(1.0)]              ; #multiplier to convert radians to degrees
set DEG2RAD [expr asin(1.0) / 90.0]              ; #multiplier to convert degrees to radians


###############################################################################
#
# DESCRIPTION
#
#   Redefine MOM_output_text when in simualation
#
###############################################################################
if { [info exists mom_post_in_simulation] && $mom_post_in_simulation != 0 } {

   if { [llength [info commands "ugpost_MOM_output_text"]] == 0 } {

      rename MOM_output_text ugpost_MOM_output_text

      #============================================
      proc MOM_output_text { string } {
      #============================================
         set status [MOM_set_seq_off]
         set buffer [MOM_output_literal "$string"]

         if { [string match "on" $status] } {
            MOM_set_seq_on
         }

       return $buffer
      }

   }
}


#<12-19-2012 gsl> camvisual9087 - Use improved math functions
#+++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
if [file exists [MOM_ask_env_var UGII_CAM_POST_DIR]ugpost_base_math.tcl] {

   source [MOM_ask_env_var UGII_CAM_POST_DIR]ugpost_base_math.tcl

} else {

################################################################################
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
#  EQ_is_zero_tol(s, tol)  (abs(s) < tol)                Return true if scalar is zero
#  EQ_is_equal_tol(s, t, tol)  (abs(s-t) <= tol)         Return true if scalars are equal
#
################################################################################
proc  EQ_is_equal {s t} {
         global mom_system_tolerance

         if { [expr abs($s - $t)] <= $mom_system_tolerance } { return 1 } else { return 0 }
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

         if { [expr abs($s)] <= $mom_system_tolerance } { return 1 } else { return 0 }
}
proc  EQ_is_zero_tol {s tol} {
         if { [expr abs($s)] <= $tol } { return 1 } else { return 0 }
}
proc  EQ_is_equal_tol {s t tol} {
         if { [expr abs($s - $t)] <= $tol } { return 1 } else { return 0 }
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
         set w1(0) 0.0
         set w1(1) 0.0
         set w1(2) 0.0
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
#
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
      for {set ii 0} {$ii < 9} {incr ii} {
        if {![EQ_is_equal $m1($ii) $n1($ii)]} {return 0}
      }
      return 1
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

} ;# ugpost_base_math.tcl
#+++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++

#===============================================================================
proc UNSET_VARS { args } {
#===============================================================================
# Inputs: List of variable names
#

   if { [llength $args] == 0 } {
return
   }

   foreach VAR $args {

      set VAR [string trim $VAR]
      if { $VAR != "" } {

         upvar $VAR var

         if { [array exists var] } {
            if { [expr $::tcl_version > 8.1] } {
               array unset var
            } else {
               foreach a [array names var] {
                  if { [info exists var($a)] } {
                     unset var($a)
                  }
               }
               unset var
            }
         }

         if { [info exists var] } {
            unset var
         }
      }
   }
}

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



#===============================================================================
proc  MOM__part_attributes {} {
#===============================================================================
# This handler allows the users to manage the MOM variables
# resulted from the part attributes.

   global mom_origin
   if [info exists mom_origin] {
      unset mom_origin
   }

  # Executing a special PB custom command to manage the part attributes.
  # They may be in conflict with other MOM variables being generated
  # during NX/Post subsequently.
  #
   if { [llength [info commands "PB_CMD__manage_part_attributes"]] > 0 } {
      PB_CMD__manage_part_attributes
   }
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
# to the file. It loads the line into a variable mom_o_buffer and then calls
# this procedure. When it returns from this procedure, the variable mom_o_buffer
# is read and written to the file.
#_______________________________________________________________________________

#########The following procedure invokes the listing file with warnings.

         LIST_FILE
}

proc  MOM_opskip_on {} {
#_______________________________________________________________________________
# This procedure is executed when the Optional skip command is activated.
#_______________________________________________________________________________
    global mom_sys_opskip_block_leader
    MOM_set_line_leader always  $mom_sys_opskip_block_leader
}

proc  MOM_opskip_off {} {
#_______________________________________________________________________________
# This procedure is executed when the Optional skip command is activated.
#_______________________________________________________________________________
    global mom_sys_opskip_block_leader
    MOM_set_line_leader off  $mom_sys_opskip_block_leader
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
         global mom_pprint_defined

         if {[info exists mom_pprint_defined]} {
            if {$mom_pprint_defined == 0} { return }
         }

         PPRINT_OUTPUT
}

proc  MOM_operator_message {} {
#_______________________________________________________________________________
# This procedure is executed when the Operator Message command is activated.
#_______________________________________________________________________________
         global mom_operator_message mom_operator_message_defined
         global mom_operator_message_status
         global ptp_file_name group_output_file mom_group_name
         global mom_sys_commentary_output
         global mom_sys_control_in
         global mom_sys_control_out
         global mom_sys_ptp_output
         global mom_post_in_simulation

         if { [info exists mom_operator_message_defined] && $mom_operator_message_defined == 0 } {
             return
         }

         if { ![string match "ON" $mom_operator_message] && ![string match "OFF" $mom_operator_message] } {
             set brac_start [string first \( $mom_operator_message]
             set brac_end [string last \) $mom_operator_message]
             if { $brac_start != 0 } {
                set text_string "("
             } else {
                set text_string ""
             }
             append text_string $mom_operator_message
             if { $brac_end == -1 || \
                  $brac_end != [expr [string length $mom_operator_message] -1 ] } {
                append text_string ")"
             }

             set st [MOM_set_seq_off]

            # Suspend output to PTP
             MOM_close_output_file   $ptp_file_name

             if { [hiset mom_group_name] } {
                if { [hiset group_output_file($mom_group_name)] } {
                   MOM_close_output_file $group_output_file($mom_group_name)
                }
             }

            # 5767232 -
            # 6686893 - seq num were output in nx6
            # if { [string match "on" $st] } { MOM_suppress once N }

            #<01Jun2011 wbh> Only output text to commentary file when postprocessing
             if { ![info exists mom_post_in_simulation] || $mom_post_in_simulation == 0 } {
                MOM_output_literal $text_string
             }

            # Resume output to PTP
             if { [string match "ON" $mom_sys_ptp_output] } {
                MOM_open_output_file    $ptp_file_name
             }

             if { [hiset mom_group_name] } {
                if { [hiset group_output_file($mom_group_name)] } {
                   MOM_open_output_file $group_output_file($mom_group_name)
                }
             }

             if { [string match "on" $st] } { MOM_set_seq_on }

             set need_commentary $mom_sys_commentary_output
             set mom_sys_commentary_output OFF
             regsub -all {[)]} $text_string $mom_sys_control_in text_string
             regsub -all {[(]} $text_string $mom_sys_control_out text_string

             MOM_output_literal $text_string

             set mom_sys_commentary_output $need_commentary

         } else {
             set mom_operator_message_status $mom_operator_message
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
         catch { MOM_$mom_motion_event }
}

proc  ASK_DELTA_4TH_OR_5TH { axis_no } {
#_______________________________________________________________________________
# returns the delta degrees rotation of the axis_no(4 or 5)
#_______________________________________________________________________________
  global   mom_pos mom_prev_pos
  global   mom_rotary_delta_4th mom_rotary_delta_5th

  if {$axis_no == 4 && [hiset mom_rotary_delta_4th]} {return $mom_rotary_delta_4th}
  if {$axis_no == 5 && [hiset mom_rotary_delta_5th]} {return $mom_rotary_delta_5th}
  incr axis_no -1 ; set a180 180.0
  set abs_pos [expr sqrt($mom_pos($axis_no) * $mom_pos($axis_no))]
  set abs_prev_pos [expr sqrt($mom_prev_pos($axis_no) * $mom_prev_pos($axis_no))]
  set rotdel [expr $abs_pos - $abs_prev_pos]
  set abs_rotdel [expr sqrt($rotdel * $rotdel)]
  if {[EQ_is_gt $abs_rotdel $a180]} {
    set rotdel [expr 360.0 - $abs_rotdel]
  } else {
    set rotdel $abs_rotdel
  }

  return $rotdel
}

proc ASK_SMALLER_OF_4TH_5TH {} {
#_______________________________________________________________________________
# returns shortest delta degrees rotation out of 4th and 5th
#_______________________________________________________________________________
  global   mom_kin_machine_type rot_cnt

  set minrot 0.0

  set machine_type [string tolower $mom_kin_machine_type]
  if { ![hiset rot_cnt] } {
    switch $machine_type {
      4_axis_head       -
      4_axis_table      -
      3_axis_mill_turn  -
      mill_turn         { set rot_cnt 1 }
      5_axis_dual_table -
      5_axis_dual_head  -
      5_axis_head_table { set rot_cnt 2 }
      default           { set rot_cnt 0 }
    }
  }

  # determine minrot: shortest of the 4th and 5th rotations
  if {$rot_cnt > 0} { set minrot [ASK_DELTA_4TH_OR_5TH 4] }

  if {$rot_cnt == 2} {
    set tmprot [ASK_DELTA_4TH_OR_5TH 5]
    if {![EQ_is_zero $tmprot] && $tmprot < $minrot} {set minrot $tmprot}
  }

  return $minrot
}

proc  ASK_DELTA_MOVE {} {
#_______________________________________________________________________________
# returns the delta distance(IN or MM) for the current move
#_______________________________________________________________________________
  global   mom_motion_distance

  if {[hiset mom_motion_distance]} {return $mom_motion_distance} else {return 0.0}
}

proc ASK_FEEDRATE_FPM {} {
#_______________________________________________________________________________
# returns feed rate IN or MM per min
#_______________________________________________________________________________
  global mom_feed_rate

  if {[hiset mom_feed_rate]} {
    return $mom_feed_rate
  } else {
    set mom_warning_info "FEED RATE UNDEFINED" ; MOM_catch_warning ; return 0.0
  }
}

proc ASK_FEEDRATE_FPR {} {
#_______________________________________________________________________________
# returns feed rate IN or MM per rev
#_______________________________________________________________________________
  global mom_feed_rate_per_rev

  if {[hiset mom_feed_rate_per_rev]} {return $mom_feed_rate_per_rev} else {return 0.0}
}

proc PB_CMD_FEEDRATE_NUMBER {} {
#_______________________________________________________________________________
# returns feed rate number in inverse time
#_______________________________________________________________________________
  global   mom_feed_rate_number mom_feed_rate

  if {[hiset mom_feed_rate_number]} {
    return $mom_feed_rate_number
  } else {
    if {![hiset mom_feed_rate]} {return 0.0}
    set delta_distance [ASK_DELTA_MOVE]
    if {[EQ_is_zero $delta_distance] || [EQ_is_zero $mom_feed_rate]} {
      return 0.0
    } else {
      set f_rn [expr $mom_sys_frn_factor * $mom_feed_rate / $delta_distance] ; return $f_rn
    }
  }
}

proc PB_CMD_FEEDRATE_DPM {} {
#_______________________________________________________________________________
# returns feed rate in degrees per min
#_______________________________________________________________________________
  global   mom_feed_rate_dpm

  if {[hiset mom_feed_rate_dpm]} {
    return $mom_feed_rate_dpm
  } else {
    set f_rn [PB_CMD_FEEDRATE_NUMBER]
    set minrot [ASK_SMALLER_OF_4TH_5TH]
    set d_pm [expr $minrot * $f_rn] ; return $d_pm
  }
}

proc SUPER_FEED_MODE_SET { feed_type } {
#_______________________________________________________________________________
# This procedure selects the proper feed rate mode into super_feed_mode
#_______________________________________________________________________________
  global   mom_sys_contour_feed_mode mom_sys_rapid_feed_mode
  global   mom_pos mom_prev_pos mom_kin_machine_type
  global   super_feed_mode
  global   mom_output_unit
  global   mom_feed_set_mode ;# from Set Modes UDE
  global   mom_motion_event
  global   mom_kin_machine_resolution
  global   mom_kin_4th_axis_min_incr mom_kin_5th_axis_min_incr


  # Fetch feed rate modes defined in post
  switch $feed_type {
    "CONTOUR" {
      if { [hiset mom_sys_contour_feed_mode(LINEAR)] } {
        set feed_mode(LINEAR) $mom_sys_contour_feed_mode(LINEAR)
      }

      if { [hiset mom_sys_contour_feed_mode(ROTARY)] } {
        set feed_mode(ROTARY) $mom_sys_contour_feed_mode(ROTARY)
      }

      if { [hiset mom_sys_contour_feed_mode(LINEAR_ROTARY)] } {
        set feed_mode(LINEAR_ROTARY) $mom_sys_contour_feed_mode(LINEAR_ROTARY)
      }
    }
    "RAPID" {
      if { [hiset mom_sys_rapid_feed_mode(LINEAR)] } {
        set feed_mode(LINEAR) $mom_sys_rapid_feed_mode(LINEAR)
      }

      if { [hiset mom_sys_rapid_feed_mode(ROTARY)] } {
        set feed_mode(ROTARY) $mom_sys_rapid_feed_mode(ROTARY)
      }

      if { [hiset mom_sys_rapid_feed_mode(LINEAR_ROTARY)] } {
        set feed_mode(LINEAR_ROTARY) $mom_sys_rapid_feed_mode(LINEAR_ROTARY)
      }
    }
  }

  if { [hiset mom_kin_machine_type] } {

    set machine_type [string tolower $mom_kin_machine_type]

    #<14Jun2011 wbh> The wedm type is "2_axis_wedm" or "4_axis_wedm"
    if { [string match "*wedm" $machine_type] } { return }

    switch $machine_type {

      "lathe"  { return }

      "3_axis_mill" {

        # Set Modes UDE has precedence of controlling feed rate
        if { [hiset mom_feed_set_mode] && [string match "OFF" $mom_feed_set_mode] } {

           if { [hiset feed_mode(LINEAR)] } { ;#<11-28-12 gsl> feed_mode is not yet set for 3-axis posts (in PB)
              set super_feed_mode $feed_mode(LINEAR)
           } else {
              if { [string match "IN" $mom_output_unit] } {
                set super_feed_mode "IPM"
              } else {
                set super_feed_mode "MMPM"
              }
           }
        }
      }

      default {

       # Multi-axis
        #<11-28-12 gsl> Would mom_feed_set_mode ONLY affect non-RAPID motions???
        if { ([hiset mom_feed_set_mode] && [string match "OFF" $mom_feed_set_mode]) ||\
             [string match "RAPID" $feed_type] } {

          set islinear_move 0 ; set isrotary_move 0

         #<09May2011 wbh> 6453414 Check the existence of mom_motion_event
          if { ![info exists mom_motion_event] } {
             set mom_motion_event UNDEFINED
          }

         #<25May2011 wbh> 6452797 Get the linear and rotary resolution in post
          set tol_linear $mom_kin_machine_resolution
          set tol_rot4 $mom_kin_4th_axis_min_incr

          if { [string match "circular_move" $mom_motion_event] } { set islinear_move 1 }

          switch $machine_type {
            4_axis_head       -
            4_axis_table      -
            3_axis_mill_turn  -
            mill_turn         {

             #<25May2011 wbh> 6452797 Use EQ_is_equal_tol instead of EQ_is_equal
              if { ![EQ_is_equal_tol $mom_pos(3) $mom_prev_pos(3) $tol_rot4] } { set isrotary_move 1 }

              if { ![EQ_is_equal_tol $mom_pos(0) $mom_prev_pos(0) $tol_linear] || \
                   ![EQ_is_equal_tol $mom_pos(1) $mom_prev_pos(1) $tol_linear] || \
                   ![EQ_is_equal_tol $mom_pos(2) $mom_prev_pos(2) $tol_linear] } { set islinear_move 1 }
            }
            5_axis_dual_table -
            5_axis_dual_head  -
            5_axis_head_table {

              set tol_rot5 $mom_kin_5th_axis_min_incr

              if { ![EQ_is_equal_tol $mom_pos(3) $mom_prev_pos(3) $tol_rot4] || \
                   ![EQ_is_equal_tol $mom_pos(4) $mom_prev_pos(4) $tol_rot5] } { set isrotary_move 1 }

              if { ![EQ_is_equal_tol $mom_pos(0) $mom_prev_pos(0) $tol_linear] || \
                   ![EQ_is_equal_tol $mom_pos(1) $mom_prev_pos(1) $tol_linear] || \
                   ![EQ_is_equal_tol $mom_pos(2) $mom_prev_pos(2) $tol_linear] } { set islinear_move 1 }
            }
          }

          if { $islinear_move } {

            if { $isrotary_move } {

              if { [hiset feed_mode(LINEAR_ROTARY)] } {

                set super_feed_mode $feed_mode(LINEAR_ROTARY)

              } elseif { [hiset feed_mode(ROTARY)] } {

                set super_feed_mode $feed_mode(ROTARY)

              } elseif { [hiset feed_mode(LINEAR)] } {

                set super_feed_mode $feed_mode(LINEAR)

              } else {

                if { [string match "CONTOUR" $feed_type] } {
                  if { [string match "IN" $mom_output_unit] } {
                    set super_feed_mode "IPM"
                  } else {
                    set super_feed_mode "MMPM"
                  }
                }
              }
            } else {

              if { [hiset feed_mode(LINEAR)] } {

                set super_feed_mode $feed_mode(LINEAR)

              } else {

                if { [string match "CONTOUR" $feed_type] } {
                  if { [string match "IN" $mom_output_unit] } {
                    set super_feed_mode "IPM"
                  } else {
                    set super_feed_mode "MMPM"
                  }
                }
              }
            }

          } else {  ;# islinear_move

            if { $isrotary_move } {

              if { [hiset feed_mode(ROTARY)] } {

                set super_feed_mode $feed_mode(ROTARY)

              } elseif { [hiset feed_mode(LINEAR_ROTARY)] } {

                set super_feed_mode $feed_mode(LINEAR_ROTARY)

              } elseif { [hiset feed_mode(LINEAR)] } {

                set super_feed_mode $feed_mode(LINEAR)

              } else {

                if { [string match "CONTOUR" $feed_type] } {
                  if { [string match "IN" $mom_output_unit] } {
                    set super_feed_mode "IPM"
                  } else {
                    set super_feed_mode "MMPM"
                  }
                }

              }

            }  ;# isrotary_move

          }  ;# !islinear_move

        }  ;# mom_feed_set_mode == "OFF" || feed_type == "RAPID"

      }

    }  ;# switch machine_type

  } else {

   # It's not likely mom_kin_machine_type is not defined.
    if { [hiset feed_mode(LINEAR)] } {
      set super_feed_mode $feed_mode(LINEAR)
    }
  }
}

set feed 0.0 ; set feed_mode IPM

proc  FEEDRATE_SET {} {
#_______________________________________________________________________________
# This procedure is executed when the Feedrate is set.
#_______________________________________________________________________________
  global   feed com_feed_rate
  global   mom_feed_rate_output_mode super_feed_mode feed_mode
  global   mom_cycle_feed_rate_mode mom_cycle_feed_rate
  global   mom_cycle_feed_rate_per_rev
  global   mom_motion_type
  global   mom_warning_info
  global   Feed_IPM Feed_IPR Feed_MMPM Feed_MMPR Feed_INV
  global   mom_sys_feed_param

  set super_feed_mode $mom_feed_rate_output_mode

  set f_pm [ASK_FEEDRATE_FPM] ; set f_pr [ASK_FEEDRATE_FPR]

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
      if { [EQ_is_zero $f_pm] && [EQ_is_zero $f_pr] } {
        SUPER_FEED_MODE_SET RAPID
      } else {
        SUPER_FEED_MODE_SET CONTOUR
      }
    }
  }

  set feed_mode $super_feed_mode


#<11-06-00 gsl> Adjust feedrate format per Post output unit again.
##  global $mom_output_unit
##  if {$mom_output_unit == "IN"} {
##     switch $feed_mode {
##       MMPM    { set feed_mode "IPM" }
##       MMPR    { set feed_mode "IPR" }
##     }
##  } else {
##     switch $feed_mode {
##       IPM    { set feed_mode "MMPM" }
##       IPR    { set feed_mode "MMPR" }
##     }
##  }


  switch $feed_mode {
    IPM     -
    MMPM    { set feed $f_pm }
    IPR     -
    MMPR    { set feed $f_pr }
    DPM     { set feed [PB_CMD_FEEDRATE_DPM] }
    FRN     -
    INVERSE { set feed [PB_CMD_FEEDRATE_NUMBER] }
    default { set mom_warning_info "INVALID FEED RATE MODE" ; MOM_catch_warning ; return }
  }

  # Post Builder provided format for the current mode:
  if { [info exists mom_sys_feed_param(${feed_mode},format)] != 0 } {
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

  set com_feed_rate $f_pm
}

#=============================================================
set cycle_name DRILL

proc CYCLE_SET { } {
#=============================================================
  global cycle_name

  WORKPLANE_SET

  set address_list {G_motion X Y Z R G_return}
  foreach address $address_list {
     if { [MOM_has_definition_element ADDRESS $address] } {
        MOM_force once $address
     }
  }

  if { [string first DWELL $cycle_name] != -1 } { MOM_force once cycle_dwell }
  if { [string first NODRAG $cycle_name] != -1 } { MOM_force once cycle_nodrag }
  if { [string first DEEP $cycle_name]!= -1 } { MOM_force once cycle_step ; MOM_force once cycle_step1 }
  if { [string first BREAK_CHIP $cycle_name]  != -1 } { MOM_force once cycle_step ; MOM_force once cycle_step1 }
}

#=============================================================
proc CIRCLE_SET { } {
#=============================================================
  global mom_pos_arc_plane
  switch $mom_pos_arc_plane {
    XY { MOM_suppress once Z K }
    YZ { MOM_suppress once X I }
    ZX { MOM_suppress once Y J }
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
proc CUTCOM_SET { } {
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
  global mom_cutcom_adjust_register mom_tool_cutcom_register mom_cutcom_register
  global mom_update_post_cmds_from_tool

  switch $evt_name {
    MOM_start_of_path {
      if {$mom_update_post_cmds_from_tool} {
        if {[info exists mom_tool_length_adjust_register]} {
          set mom_tool_adjust_register $mom_tool_length_adjust_register
        }
        UNSET_VARS mom_tool_length_adjust_register
      }
    }
    MOM_cutcom_on {
      if {$mom_update_post_cmds_from_tool} {
        if {[info exists mom_tool_cutcom_register]} {
          set mom_cutcom_adjust_register $mom_tool_cutcom_register
        } elseif {[info exists mom_cutcom_register]} {
          set mom_cutcom_adjust_register $mom_cutcom_register
        }
        UNSET_VARS mom_tool_cutcom_register mom_cutcom_register
      }
    }
    MOM_length_compensation {
      if {$mom_update_post_cmds_from_tool} {
        if {[info exists mom_length_comp_register]} {
          set mom_tool_adjust_register $mom_length_comp_register
        }
        UNSET_VARS mom_length_comp_register
      }
    }
  }
}

#=============================================================
proc SPINDLE_SET { } {
#=============================================================
  global mom_spindle_status mom_spindle_mode

  if { $mom_spindle_status == "UNDEFINED" } {
return
  }

  if { $mom_spindle_status != "OFF" } {
     set mom_spindle_status ON
  }

  if { $mom_spindle_status == "ON" && $mom_spindle_mode != "" } {
     set mom_spindle_status $mom_spindle_mode
  }

  # <23-Oct-15 ljt> avoid to trigger spindle for some operation. i.e. Deep Hole Drilling, Back Countersinking.
  if { [info exists ::mom_spindle_startup_status] && [info exists ::mom_spindle_direction] } {
     if { ![string compare "OFF" $::mom_spindle_startup_status] &&\
          ![string compare "OFF" $mom_spindle_status] } {

        set ::mom_spindle_direction "OFF"
     }
  }

#<11-06-00 gsl> Make sure mom_spindle_speed is set.
##  global mom_spindle_speed mom_spindle_rpm
##  if { ![info exists mom_spindle_speed] } {
##     if { [info exists mom_spindle_rpm] } {
##        set mom_spindle_speed $mom_spindle_rpm
##     }
##  }
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
#<10-11-2006 Murthy> Initialization for Generic Motion Operations
  set mom_machine_mode_uc [string toupper $mom_machine_mode]
  if {$mom_machine_mode_uc == "NONE" || $mom_machine_mode == "UNDEFINED"} {
     set spindle_first NONE
     set rapid_spindle_inhibit FALSE
     set rapid_traverse_inhibit FALSE
  }
  if {$mom_machine_mode != "MILL" && $mom_machine_mode != "DRILL"} {return}

  WORKPLANE_SET ; set rapid_spindle_inhibit FALSE ; set rapid_traverse_inhibit FALSE

  if { $mom_pos($mom_cycle_spindle_axis) <=  $mom_last_pos($mom_cycle_spindle_axis)} {
    set going_lower 1
  } else {
    set going_lower 0
  }

  if {[info exists mom_sys_work_plane_change] == 0} {set mom_sys_work_plane_change 1}

  if {$mom_sys_work_plane_change} {
    if {$going_lower} {set spindle_first FALSE} else {set spindle_first TRUE}

#<01-17-01 gsl> Force output in Initial Move and First Move.
    if {$mom_motion_event != "initial_move" && $mom_motion_event != "first_move"} {

       if {[EQ_is_equal $mom_pos($mom_cycle_spindle_axis) $mom_last_pos($mom_cycle_spindle_axis)]} {
         set rapid_spindle_inhibit TRUE
       } else {set rapid_spindle_inhibit FALSE}

       if {[EQ_is_equal $mom_pos($traverse_axis1) $mom_prev_pos($traverse_axis1)] && \
           [EQ_is_equal $mom_pos($traverse_axis2) $mom_prev_pos($traverse_axis2)] && \
           [EQ_is_equal $mom_pos(3) $mom_prev_pos(3)] && \
           [EQ_is_equal $mom_pos(4) $mom_prev_pos(4)] } {
         set rapid_traverse_inhibit TRUE
       } else {set rapid_traverse_inhibit FALSE}
     }

  } else { set spindle_first NONE }
}


#========================<4133654>============================
proc SEQNO_RESET { } {
#=============================================================
  global mom_sequence_mode mom_sequence_number mom_sequence_increment mom_sequence_frequency
  global mom_def_sequence_start mom_def_sequence_increment mom_def_sequence_frequency mom_def_sequence_maximum
  global mom_sys_seqnum_start mom_sys_seqnum_freq mom_sys_seqnum_incr mom_seqnum

  if {[hiset mom_def_sequence_start] && [hiset mom_def_sequence_increment] && \
      [hiset mom_def_sequence_frequency]} {
    set mom_sequence_number $mom_def_sequence_start
    set mom_sequence_increment $mom_def_sequence_increment
    set mom_sequence_frequency $mom_def_sequence_frequency
  } elseif {[hiset mom_sys_seqnum_start] && [hiset mom_sys_seqnum_incr] && [hiset mom_sys_seqnum_freq]} {
    set mom_sequence_number $mom_sys_seqnum_start
    set mom_sequence_increment $mom_sys_seqnum_incr
    set mom_sequence_frequency $mom_sys_seqnum_freq
  } else {
    set mom_sequence_number 10
    set mom_sequence_increment 10
    set mom_sequence_frequency 1
  }
}

#=============================================================
proc SEQNO_SET { } {
#=============================================================
  global mom_sequence_mode mom_sequence_number mom_sequence_increment mom_sequence_frequency
  global mom_seqnum

  if { [info exists mom_sequence_mode] } {
    switch $mom_sequence_mode {
      OFF     { MOM_set_seq_off }
      ON      { MOM_set_seq_on }
      N       {
         MOM_reset_sequence $mom_sequence_number $mom_sequence_increment $mom_sequence_frequency
         MOM_set_seq_on ; #<4133654>
      }
      default { MOM_output_literal "error:  mom_sequence_mode unknown" }
    }
  } else {
    MOM_reset_sequence $mom_sequence_number $mom_sequence_increment $mom_sequence_frequency
    MOM_set_seq_on ; #<4133654>
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


  #<09-14-09 wbh> PR1741519 - Set incremental flag for fourth_axis & fifth_axis.
  #
   if { [MOM_ask_env_var "UGII_CAM_POST_DISABLE_INCR_MODE_FIX"] != 1 } {

      foreach { nth ip addr } { 4th 0 fourth_axis 5th 1 fifth_axis } {

         global mom_kin_${nth}_axis_incr_switch
         global mom_kin_${nth}_axis_direction
         global mom_kin_${nth}_axis_direction_save

         if { [info exists mom_kin_${nth}_axis_incr_switch] && \
              [string match "ON" [set mom_kin_${nth}_axis_incr_switch]] } {

            MOM_incremental $isincr $addr

            if ![info exists mom_kin_${nth}_axis_direction_save] {
               set mom_kin_${nth}_axis_direction_save [set mom_kin_${nth}_axis_direction]
            }

            if [string match "ON" $isincr] {
               set mom_kin_${nth}_axis_direction "MAGNITUDE_DETERMINES_DIRECTION"
            } else {
               set mom_kin_${nth}_axis_direction [set mom_kin_${nth}_axis_direction_save]
            }

            MOM_reload_kinematics


           #<06-08-2015 gsl> 6832974 - If axis direction mode has changed from sign-det to magn-det,
           #                 normalize previous angle to avoid unnecessary 1st increment.
           #
            if { [llength [info commands MOM_set_address_with_value]] & \
                 [string match "ON" $isincr] && \
                 [string match "SIGN_DETERMINES_DIRECTION" [set mom_kin_${nth}_axis_direction_save]] } {

               set old_val $::mom_out_angle_pos($ip)
               set ::mom_out_angle_pos($ip) [LIMIT_ANGLE $::mom_out_angle_pos($ip)]
               set ::mom_out_angle_pos($ip) [ROTSET $::mom_prev_pos([expr $ip+3]) $::mom_out_angle_pos($ip) \
                                                "MAGNITUDE_DETERMINES_DIRECTION" \
                                                [set ::mom_kin_${nth}_axis_leader] ::mom_sys_leader($addr) \
                                                [set ::mom_kin_${nth}_axis_min_limit] \
                                                [set ::mom_kin_${nth}_axis_max_limit]]

              # Reset address' state as needed
               if { ![EQ_is_equal $old_val $::mom_out_angle_pos($ip)] } {
                  MOM_set_address_with_value $addr "$::mom_out_angle_pos($ip)"
               }
            }
         }
      }
   }

}

#============================================================="
proc IN_SEQUENCE { evt_name } {
#============================================================="
  global in_sequence mom_motion_type

  # if it is a move event:
  set move_event [string last "move" $evt_name]
  if { $move_event != -1 } {
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
      MOM_start_of_program { set in_sequence start_of_program }
      MOM_start_of_path    { set in_sequence start_of_path }
      MOM_end_of_path      { set in_sequence end_of_path }
      MOM_end_of_program   { set in_sequence end_of_program }
      default              { }
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

  if { [isset mom_kin_machine_type] == "n" } {
    set machine_type MILL
  } elseif { [regexp lathe $mom_kin_machine_type] == 1 } {
    set machine_type TURN
  } elseif { [regexp wedm $mom_kin_machine_type] == 1 } {
    set machine_type WIRE
  } elseif { [regexp mill_turn $mom_kin_machine_type] == 1 } {
    set machine_type MILL-TURN
  } else {
    set machine_type MILL
  }

  if { [string match "MILL-TURN" $machine_type] } {
    if { ![string match "MILL" $mom_machine_mode] && ![string match "TURN" $mom_machine_mode] } {
      set mom_warning_info \
         "MISMATCHED operation($mom_machine_mode) and machine($machine_type): Event Name: MOM_start_of_path"
      MOM_catch_warning
    }
  } elseif { ![string match "$machine_type" $mom_machine_mode] } {
    set mom_warning_info \
        "MISMATCHED operation($mom_machine_mode) and machine($machine_type): Event Name: MOM_start_of_path"
    MOM_catch_warning
  }
}

#=============================================================
proc OPERATOR_MSG { msg {seq_no 0} } {
#=============================================================
# This command will output a single or a set of operator message(s).
#
#   msg    : Message(s separated by new-line character)
#   seq_no : 0 Output message without sequence number (Default)
#            1 Output message with sequence number
#
   foreach s [split $msg \n] {
      if { !$seq_no } {
         MOM_output_text    "$::mom_sys_control_out $s $::mom_sys_control_in"
      } else {
         MOM_output_literal "$::mom_sys_control_out $s $::mom_sys_control_in"
      }
   }

  # Clear output buffer containing the message -
   set ::mom_o_buffer ""
}

#=============================================================
proc Enhance_Warning_Msg { msg } {
#=============================================================
# This command is called by MOM_catch_warning to enhance the message output to the warning file.
#
# May-16-2015 gsl - (nx11.0.0) New


  # Oct-27-2017 gsl - Enhanced the condition below:
   if { [info level] > 1 && \
       ![string match "MOM_catch_warning*" [info level -1] ] } {
return $msg
   }


   global mom_motion_event
   global mom_event_number
   global mom_motion_type
   global mom_operation_name

   global mom_o_buffer
   if { ![info exists mom_o_buffer] } {
      set mom_o_buffer ""
   }

   if { ![info exists mom_motion_event] } {
      set mom_motion_event ""
   }

   if { ![info exists ::mom_current_motion] } {
      set ::mom_current_motion $mom_motion_event
   }

   if { [string length $::mom_current_motion] } {
      set event_name MOM_$::mom_current_motion
   } else {
      set event_name [MOM_ask_event_type]
   }

   set event_num [expr $mom_event_number - 1]

   if { [info exists mom_operation_name] && [string length $mom_operation_name] } {
      set msg "$msg\n\  Operation $mom_operation_name -\
                        Event $event_num : $event_name ($mom_motion_type)\n\    $mom_o_buffer\n"
   } else {
      set msg "$msg\n\  Event $event_num : $event_name ($mom_motion_type)\n\    $mom_o_buffer\n"
   }

return $msg
}

#===============================================================================
proc MOM_catch_warning { } {
#===============================================================================
# This procedure generates the warnings for missing procedures and values
# falling out of MIN/MAX.
#
# Apr-15-2015 gsl - (nx10.0.2) Added LIST option to display warning messages in listing window
# May-16-2015 gsl - (nx11.0.0) Call Enhance_Warning_Msg
#-------------------------------------------------------------------------------

   global mom_warning_info
   global warn_file list_file warn_count
   global group_warn_file group_list_file group_warn_count
   global mom_sequence_mode mom_sequence_number mom_sequence_increment mom_sequence_frequency

   if { [regexp "MOM_msys"         $mom_warning_info] == 1 } { return }
   if { [regexp "MOM_machine_mode" $mom_warning_info] == 1 } { return }
   if { [regexp "MOM_origin"       $mom_warning_info] == 1 } { return }
   if { [regexp "MOM_translate"    $mom_warning_info] == 1 } { return }
   if { [regexp "MOM_lintol"       $mom_warning_info] == 1 } { return }
   if { [regexp "MOM_tlset"        $mom_warning_info] == 1 } { return }


  # Identify certain warnings of multi-axis post
   if { [llength [info commands "PB_catch_warning"]] > 0 } {
      PB_catch_warning
   }

   if { [regexp  "mom_seqnum" $mom_warning_info] == 1 } {
      MOM_reset_sequence $mom_sequence_number $mom_sequence_increment $mom_sequence_frequency
   }

   global mom_sys_warning_output

   if { [string match "ON" [string toupper $mom_sys_warning_output]] } {

     #<Oct-27-2017 gsl> "CATCH_WARNING*" was "CATCH_WARNING" below.
     #<May-16-2016> NX11.0 - Enhance warning msg when this handler is not called by CATCH_WARNING.
      if { [info level] == 1 || ![string match "CATCH_WARNING*" [info level -1]] } {
         set mom_warning_info [Enhance_Warning_Msg $mom_warning_info]
      }

     #<NX10.0.3> Warning messages may be directed to NC output
      global mom_sys_warning_output_option

      if { ![info exists mom_sys_warning_output_option] } {
         set mom_sys_warning_output_option "FILE"
      }

      switch [string toupper $mom_sys_warning_output_option] {
         FILE {
            if { [hiset warn_file] } {
               puts $warn_file "$mom_warning_info "
            }
         }

         LIST {
            OPERATOR_MSG "$mom_warning_info"
         }
      }

      incr warn_count
      if { [hiset list_file] } { puts $list_file "$mom_warning_info " }

      if { [hiset group_warn_file] } {
         puts $group_warn_file "$mom_warning_info " ; incr group_warn_count
         if { [hiset group_list_file] } { puts $group_list_file "$mom_warning_info " }
      }
   }
}

#_______________________________________________________________________________
# The following procedures are executed to get the commentary data output and the
# warning output. The commentary output data is stored in the the file ptp_name.lpt.
# The warning data is stored in the file ptp_name_warning.out.
#_______________________________________________________________________________
proc  OPEN_files { } {

  global mom_logname mom_date mom_ug_version mom_part_name mom_event_handler_file_name mom_definition_file_name
  global mom_output_file_directory mom_output_file_basename mom_output_file_suffix
  global mom_sys_output_file_suffix mom_sys_list_file_suffix output_extn list_extn
  global mom_parent_group_name mom_sys_group_output
  global ptp_file_name lpt_file_name warning_file_name mom_group_name prev_group_name
  global list_file warn_file group_list_file group_warn_file group_level
  global group_output_file group_lpt_file_name group_warning_file_name
  global warn_count line_count page_number
  global group_warn_count group_line_count group_page_number
  global mom_sys_ptp_output mom_sys_list_output mom_sys_warning_output mom_warning_info
  global isinit_files isinit_group
  global mom_tool_use ; # Temporary fix for mom_tool_count bug
  global mom_post_in_simulation

  if { ![hiset isinit_files] } {

    for { set i 0 } { $i <= 100 } { incr i } {
      set mom_tool_use($i,0) 0
    }

    SEQNO_RESET ; #<4133654>

    set output_extn "" ; set list_extn ""

    if { [hiset mom_output_file_suffix] } {
      if { [string length $mom_output_file_suffix] > 0 } {
        set output_extn ".${mom_output_file_suffix}"
      }
    }

   #<Dec-10-2015 gsl> Error encountered in NX10.02, output dir may not be set in Sync Manager
   #                  Redefine output dir early here for subsequent consumption.
    # Set working directory to prevent error with unknown "./"
    if { [file exists "${mom_output_file_directory}"] && [file writable "${mom_output_file_directory}"] } {
       cd ${mom_output_file_directory}
    } else {
       cd "[MOM_ask_env_var UGII_TMP_DIR]"

      # Direct outputs to temp dir
       if { [string match "windows" $::tcl_platform(platform)] } {
          set mom_output_file_directory "[file nativename [pwd]]\\"
       } else {
          set mom_output_file_directory "[file nativename [pwd]]/"
       }
    }

    set pre_ptp_name "${mom_output_file_directory}${mom_output_file_basename}${output_extn}"

    #<18Nov2010 wbh> No need to add the post defined output file suffix
    #<01Jun2011 wbh> Not add file suffix only when postprocessing
    set add_flag 1
    if { [info exists mom_post_in_simulation] && $mom_post_in_simulation == 0 } {
       set add_flag 0
    }
    if { $add_flag && [string length $output_extn] == 0 } {
      if { [string length $mom_sys_output_file_suffix] > 0 } {
        set output_extn ".${mom_sys_output_file_suffix}"
      }
    }

    if { [string length $mom_sys_list_file_suffix] > 0 } {
      set list_extn ".${mom_sys_list_file_suffix}"
    }

    set ptp_file_name "${mom_output_file_directory}${mom_output_file_basename}${output_extn}"
    set lpt_file_name "${mom_output_file_directory}${mom_output_file_basename}${list_extn}"
    set warning_file_name "${mom_output_file_directory}${mom_output_file_basename}_warning.out"

    # puts stdout  "******************************************************"
    # puts stdout  "  UG_POST    VERSION       : $mom_ug_version"
    # puts stdout  "******************************************************"
    # puts stdout  "  USER NAME / DATE  : $mom_logname / $mom_date"
    # puts stdout  "  INPUT PART        : $mom_part_name"
    # puts stdout  "  USING             : $mom_event_handler_file_name, $mom_definition_file_name"
    # puts stdout  "******************************************************"

    MOM_close_output_file $pre_ptp_name

    global tcl_version

    if { [string compare "$ptp_file_name" "$pre_ptp_name"] } {
      if { $tcl_version < 8.0 } {
        MOM_close_output_file $ptp_file_name
      } else {
        MOM_close_output_file [file nativename $ptp_file_name]
      }
    }

    # puts stdout  "  CLOSED PRE-EXISTING MAIN $ptp_file_name"
    if { [file exists $pre_ptp_name] } {
      MOM_remove_file $pre_ptp_name
      # puts stdout  "  REMOVED PRE-EXISTING MAIN $pre_ptp_name"
    }

    if { [file exists $ptp_file_name] } {
      MOM_remove_file $ptp_file_name
      # puts stdout  "  REMOVED PRE-EXISTING MAIN $ptp_file_name"
    }

if 0 { ;# Moved up
    # Set working directory to prevent error with unknown "./"
    #<Dec-10-2015 gsl> Output dir may not be set in Sync Manager
    if { [file exists "${mom_output_file_directory}"] && [file writable "${mom_output_file_directory}"] } {
       cd ${mom_output_file_directory}
    } else {
       cd "[MOM_ask_env_var UGII_TMP_DIR]"
       set mom_output_file_directory [pwd]
    }
}

    if { $mom_sys_ptp_output == "ON" } {
      if { $tcl_version < 8.0 } {
        if { ![file exists $ptp_file_name] } {
           MOM_open_output_file $ptp_file_name
        }
      } else {
        if { ![file exists [file nativename $ptp_file_name]] && ![file exists $ptp_file_name] } {
           MOM_open_output_file [file nativename $ptp_file_name]
        }
      }
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
        set group_name_lowercase [string tolower $mom_group_name]

        if {$mom_sys_ptp_output == "ON"} {
          set grp_ptp_name "${mom_output_file_basename}_${group_name_lowercase}${output_extn}"
          if { [string length $grp_ptp_name] > 132} {
            set grp_ptp_name "${group_name_lowercase}${output_extn}"
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
          # MOM_output_literal "(*** generating group file $group_output_file($mom_group_name) ***)"
        }

        if {$mom_sys_list_output == "ON"} {
          set grp_lpt_name ${mom_output_file_basename}_${group_name_lowercase}${list_extn}
          if { [string length $grp_lpt_name] > 132} {
            set grp_lpt_name ${group_name_lowercase}${list_extn}
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
          set grp_warn_name ${mom_output_file_basename}_${group_name_lowercase}_warning.out
          if {[string length $grp_warn_name] > 132} {
            set grp_warn_name ${group_name_lowercase}_warning.out
            if {[string length $grp_warn_name] > 132} { set grp_warn_name ${group_name_lowercase}.out }
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

proc  CLOSE_files { } {

   global warn_file list_file
   global group_warn_file group_list_file
   global warn_count

   if { [hiset group_list_file] == 0 && [hiset group_warn_file] == 0 } {

      if { [hiset list_file] } { close $list_file ; unset list_file }
      if { [hiset warn_file] } { close $warn_file ; unset warn_file }
      if { [hiset warn_count] && $warn_count > 0 } {

         # 7626318 - Issue reminder per file size
         if { [file exists $::warning_file_name] && [expr [file size $::warning_file_name] > 0.0] } {
            MOM_output_to_listing_device\
                  "***********************************************************"
            MOM_output_to_listing_device\
                  "Check $::warning_file_name for any Errors/Warnings during postprocessing"
            MOM_output_to_listing_device\
                  "***********************************************************"
         }
      }

   } else {

      if { [hiset group_list_file] } { close $group_list_file ; unset group_list_file }
      if { [hiset group_warn_file] } { close $group_warn_file ; unset group_warn_file }
   }

   # Remove zero files
   if { [file exists $::warning_file_name] && ![expr [file size $::warning_file_name] > 0.0] } {
      MOM_remove_file $::warning_file_name
   }
   if { [file exists $::lpt_file_name] && ![expr [file size $::lpt_file_name] > 0.0] } {
      MOM_remove_file $::lpt_file_name
   }
   if { [info exists ::group_warning_file_name] } {
      if { [file exists $::group_warning_file_name] && ![expr [file size $::group_warning_file_name] > 0.0] } {
         MOM_remove_file $::group_warning_file_name
      }
   }
   if { [info exists ::group_lpt_file_name] } {
      if { [file exists $::group_lpt_file_name] && ![expr [file size $::group_lpt_file_name] > 0.0] } {
         MOM_remove_file $::group_lpt_file_name
      }
   }

  #<Dec-15-2017 gsl> 9038137 - Free directory of output file.
   cd "[MOM_ask_env_var UGII_TMP_DIR]"
}

proc LIST_FILE { } {

       global mom_o_buffer
         global space_buffer
         global list_file group_list_file
         global mom_sys_list_file_columns
         global mom_sys_list_file_rows
         global warn_count
         global group_warn_count
         global mom_sys_list_output mom_sys_commentary_output
         global tape_bytes
         global shop_docs_block
         global mom_sys_control_in mom_sys_filler
         global sys_axis mom_pos com_feed_rate mom_spindle_speed mom_kin_output_unit
         global commentary_out

         incr tape_bytes [string length $mom_o_buffer]

         if { ![string match "ON" $mom_sys_list_output] } { return }

        # Only output when commentary is ON
         if { ![string match "ON" $mom_sys_commentary_output] } { return }

         set commentary ""

         if { ![info exists mom_kin_output_unit] } { set mom_kin_output_unit "IN" }

        # When the line does'nt contain control-in char and is not from shop-doc...
         if { [string last $mom_sys_control_in $mom_o_buffer] < 0 && ![info exists shop_docs_block] } {
           if { $mom_kin_output_unit == "IN" } {
             if { $commentary_out(x)     > 0 } { set commentary [format "%10.4f" $mom_pos(0)] }
             if { $commentary_out(y)     > 0 } { append commentary [format "%10.4f" $mom_pos(1)] }
             if { $commentary_out(z)     > 0 } { append commentary [format "%10.4f" $mom_pos(2)] }
             if { $commentary_out(4axis) > 0 } { append commentary [format "%8.3f" $mom_pos(3)] }
             if { $commentary_out(5axis) > 0 } { append commentary [format "%8.3f" $mom_pos(4)] }
             if { $commentary_out(feed)  > 0 } { append commentary [format "%7.1f" $com_feed_rate] }
             if { $commentary_out(speed) > 0 } { append commentary [format "%5.0f" $mom_spindle_speed] }
           } else {
             if { $commentary_out(x)     > 0 } { set commentary [format "%10.3f" $mom_pos(0)] }
             if { $commentary_out(y)     > 0 } { append commentary [format "%10.3f" $mom_pos(1)] }
             if { $commentary_out(z)     > 0 } { append commentary [format "%10.3f" $mom_pos(2)] }
             if { $commentary_out(4axis) > 0 } { append commentary [format "%8.3f" $mom_pos(3)] }
             if { $commentary_out(5axis) > 0 } { append commentary [format "%8.3f" $mom_pos(4)] }
             if { $commentary_out(feed)  > 0 } { append commentary [format "%7.0f" $com_feed_rate] }
             if { $commentary_out(speed) > 0 } { append commentary [format "%5.0f" $mom_spindle_speed] }
           }

           set local_o_buffer $mom_o_buffer
           set outs [concat $local_o_buffer " "]
           set outs_length [string length $outs]
           set commentary_length [string length $commentary]
           if { [expr $outs_length + $commentary_length] < $mom_sys_list_file_columns } {
                  set filler [format "%*s" [expr $mom_sys_list_file_columns - $outs_length - [string length $commentary]] " "]
                  append outs "$filler$commentary"
           } else {
                  set filler [format "%*s" [expr $mom_sys_list_file_columns - [string length $commentary]] " "]
                  append outs "\n$filler$commentary"
           }
         } else {
           set outs $mom_o_buffer
         }

         if { [hiset list_file] }       { puts $list_file $outs }
         if { [hiset group_list_file] } { puts $group_list_file $outs }
}

proc  LIST_FILE_HEADER { } {

  global mom_sys_list_output mom_sys_header_output mom_sys_list_file_columns
  global mom_ug_version mom_logname mom_date
  global mom_part_name mom_event_handler_file_name mom_definition_file_name
  global ptp_file_name lpt_file_name warning_file_name
  global group_output_file group_lpt_file_name group_warning_file_name mom_group_name
  global list_file group_list_file mom_sys_filler_length
  global warn_count mom_sys_leader mom_sys_filler
  global group_warn_count global header
  global isdone_list_file prev_group_lpt_file_name
  global mom_kin_machine_type
  global mom_sys_commentary_list commentary_out


   set warn_count 0
   set group_warn_count 0
   set blan      " "
   set mom_sys_list_file_columns 100

   if { ![info exist mom_kin_machine_type] } { set mom_kin_machine_type "3_axis_mill" }

   set machine_type [string tolower $mom_kin_machine_type]
   switch $machine_type {
      lathe             { set sys_axis 2 }
      4_axis_head -
      4_axis_table -
      3_axis_mill_turn -
      mill_turn         { set sys_axis 4 }
      5_axis_dual_table -
      5_axis_dual_head -
      5_axis_head_table { set sys_axis 5 }
      default           { set sys_axis 3 }
   }

   if { ![info exist mom_sys_commentary_list] } { set mom_sys_commentary_list "x y z 4axis 5axis feed speed" }

   if { [lsearch $mom_sys_commentary_list "x"] >= 0 } {
     set commentary_out(x) "1"
   } else {
     set commentary_out(x) "0"
   }

   if { [lsearch $mom_sys_commentary_list "y"] >= 0 && $sys_axis != 2 } {
     set commentary_out(y) "1"
   } else {
     set commentary_out(y) "0"
   }

   if { [lsearch $mom_sys_commentary_list "z"] >= 0 } {
     set commentary_out(z) "1"
   } else {
     set commentary_out(z) "0"
   }

   if { [lsearch $mom_sys_commentary_list "4axis"] >= 0 && $sys_axis >= 4 } {
     set commentary_out(4axis) "1"
   } else {
     set commentary_out(4axis) "0"
   }

   if { [lsearch $mom_sys_commentary_list "5axis"] >= 0 && $sys_axis == 5 } {
     set commentary_out(5axis) "1"
   } else {
     set commentary_out(5axis) "0"
   }

   if { [lsearch $mom_sys_commentary_list "feed"] >= 0 } {
     set commentary_out(feed) "1"
   } else {
     set commentary_out(feed) "0"
   }

   if { [lsearch $mom_sys_commentary_list "speed"] >= 0 } {
     set commentary_out(speed) "1"
   } else {
     set commentary_out(speed) "0"
   }

   set commentary_header ""

   if { $commentary_out(x) > 0 }     { set commentary_header "  ABS-X  " }
   if { $commentary_out(y) > 0 }     { append commentary_header "   ABS-Y  " }
   if { $commentary_out(z) > 0 }     { append commentary_header "   ABS-Z  " }
   if { $commentary_out(4axis) > 0 } { append commentary_header " ABS-$mom_sys_leader(fourth_axis)  " }
   if { $commentary_out(5axis) > 0 } { append commentary_header " ABS-$mom_sys_leader(fifth_axis)  " }
   if { $commentary_out(feed) > 0  } { append commentary_header " FEED" }
   if { $commentary_out(speed) > 0 } { append commentary_header "  RPM" }

   set commentary_header_length [string length $commentary_header]
   set mom_sys_filler_length [expr $mom_sys_list_file_columns-$commentary_header_length]
   set mom_sys_filler [format "%*s" $mom_sys_filler_length " "]

   if { ![string match "ON" $mom_sys_header_output] || ![string match "ON" $mom_sys_list_output] } { return }

   if { [hiset list_file] && ![hiset isdone_list_file] } {
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

    puts $list_file  "                VERSION       NUMBER : $mom_ug_version"
    puts $list_file  "                EXECUTED      BY     : $mom_logname"
    puts $list_file  "                EXECUTION     DATE   : $mom_date"
    puts $list_file  "                POST          NAME   : "
    puts $list_file  "                TCL     FILE  NAME   : $mom_event_handler_file_name"
    puts $list_file  "                DEF     FILE  NAME   : $mom_definition_file_name"
    puts $list_file  "                PART    FILE  NAME   : $mom_part_name"

    if { [hiset ptp_file_name]     } { puts $list_file  "                PTP     FILE  NAME   : $ptp_file_name" }
    if { [hiset lpt_file_name]     } { puts $list_file  "                LPT     FILE  NAME   : $lpt_file_name" }
    if { [hiset warning_file_name] } { puts $list_file  "                WARNING FILE  NAME   : $warning_file_name" }

    puts $list_file  "\n"
    puts $list_file $mom_sys_filler$commentary_header

    set isdone_list_file TRUE
  }

  if { ![hiset group_lpt_file_name] } { return }

  if { [hiset prev_group_lpt_file_name] } {
    if { [string match "$prev_group_lpt_file_name" $group_lpt_file_name] } {
      return
    } else {
      set prev_group_lpt_file_name $group_lpt_file_name
    }
  } else {
    set prev_group_lpt_file_name $group_lpt_file_name
  }

  if { [hiset group_list_file] } {
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

    puts $group_list_file  "     VERSION NUMBER :       $mom_ug_version"
    puts $group_list_file  "     EXECUTED BY :          $mom_logname"
    puts $group_list_file  "     EXECUTION DATE :       $mom_date"
    puts $group_list_file  "     POST NAME : "
    puts $group_list_file  "     TCL FILE NAME :        $mom_event_handler_file_name"
    puts $group_list_file  "     DEF FILE NAME :        $mom_definition_file_name"
    puts $group_list_file  "     PART FILE NAME :       $mom_part_name"

    if { [hiset group_output_file($mom_group_name)] } {
      puts $group_list_file  "   PTP FILE NAME :        $group_output_file($mom_group_name)"
    }

    puts $group_list_file  "     LPT FILE NAME :        $group_lpt_file_name"

    if { [hiset group_warning_file_name] } {
      puts $group_list_file  "     WARNING FILE NAME :    $group_warning_file_name"
    }

    puts $group_list_file  "\n"
    puts $list_file $mom_sys_filler$commentary_header
  }
}

proc  LIST_FILE_TRAILER { } {

  global list_file warn_count page_number
  global group_list_file group_warn_count group_page_number
  global mom_machine_time
  global mom_tool_use
  global mom_tool_count
  global tape_bytes mom_output_unit

  if { [hiset mom_machine_time] == 0 } { set mom_machine_time 0 }

  if { [hiset list_file] && [hiset group_list_file] == 0 } {
    puts $list_file  "\f"
    puts $list_file  "     \n\n\n\n\n\n\n                    "
    puts $list_file  "     UG_POST MACHINE TIME            :[ format  "%.2f" $mom_machine_time]"

    if { $mom_output_unit == "IN" } {
      set tape_feet [expr $tape_bytes / 120.0]
      puts $list_file  "     UG_POST TAPE FEET               :[ format  "%.2f" $tape_feet]"
    } else {
      set tape_meters [expr $tape_bytes * 25.4 / 10000.0]
      puts $list_file  "     UG_POST TAPE METERS             :[ format  "%.2f" $tape_meters]"
    }

    puts $list_file  "     NUMBER OF WARNINGS              : $warn_count"

    if { [isset mom_tool_count] == "n" } { return }

    puts $list_file  "\f "
    puts $list_file  "********************************************************************************"
    puts $list_file  "                       TOOL LIST WITH TOOL USED TIME"
    puts $list_file  "********************************************************************************"

    if { [hiset mom_tool_count] } {
      for { set nn 0 } { $nn < $mom_tool_count } { incr nn } {
        if { [hiset mom_tool_use($nn,0)] && [hiset mom_tool_use($nn,1)] } {
          set a [scan $mom_tool_use($nn,0) %d tn]
          puts $list_file  "  TOOL  NUMBER [ format  "%s  %.2f"    $tn         $mom_tool_use($nn,1)] minutes"
        }
      }
    }

    puts $list_file  "********************************************************************************"
  }

  if { [hiset group_list_file] } {
    puts $group_list_file  "\f"
    puts $group_list_file  "     \n\n\n\n\n\n\n                    "
    puts $group_list_file  "     UG_POST MACHINE TIME            :[ format  "%.2f" $mom_machine_time]"
    puts $group_list_file  "     NUMBER OF WARNINGS              : $warn_count"

    if { [isset mom_tool_count] == "n" } { return }

    puts $group_list_file  "\f "
    puts $group_list_file  "********************************************************************************"
    puts $group_list_file  "                       TOOL LIST WITH TOOL USED TIME"
    puts $group_list_file  "********************************************************************************"

    if { [hiset mom_tool_count] } {
      for { set nn 0 } { $nn < $mom_tool_count } { incr nn } {
        if { [hiset mom_tool_use($nn,0)] && [hiset mom_tool_use($nn,1)] } {
          set a [scan $mom_tool_use($nn,0) %d tn]
          puts $list_file  "  TOOL  NUMBER [ format  "%s  %.2f"    $tn         $mom_tool_use($nn,1)] minutes"
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
         global mom_sys_commentary_output
         global mom_sys_control_in
         global mom_sys_control_out
         global mom_warning_info
         global mom_sys_ptp_output

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

            set st [MOM_set_seq_off]
            MOM_close_output_file   $ptp_file_name
            if {[hiset mom_group_name]} {
               if {[hiset group_output_file($mom_group_name)]} {
                  MOM_close_output_file $group_output_file($mom_group_name)
               }
            }
            MOM_output_literal      $text_string
            if {$mom_sys_ptp_output == "ON"} {MOM_open_output_file    $ptp_file_name }
            if {[hiset mom_group_name]} {
               if {[hiset group_output_file($mom_group_name)]} {
                  MOM_open_output_file $group_output_file($mom_group_name)
               }
            }
            if {$st == "on"} {MOM_set_seq_on}
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
               set st [MOM_set_seq_off]
               MOM_close_output_file   $ptp_file_name
               if {[hiset mom_group_name]} {
                  if {[hiset group_output_file($mom_group_name)]} {
                     MOM_close_output_file $group_output_file($mom_group_name)
                  }
               }
               MOM_output_literal      $mom_pprint
               if {$mom_sys_ptp_output == "ON"} {MOM_open_output_file    $ptp_file_name }
               if {[hiset mom_group_name]} {
                  if {[hiset group_output_file($mom_group_name)]} {
                     MOM_open_output_file $group_output_file($mom_group_name)
                  }
               }
               if { $st == "on" } { MOM_set_seq_on }
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
               set st [ MOM_set_seq_off ]
               MOM_close_output_file   $ptp_file_name
               if {[hiset mom_group_name]} {
                  if {[hiset group_output_file($mom_group_name)]} {
                     MOM_close_output_file $group_output_file($mom_group_name)
                  }
               }
               MOM_output_literal $mom_pprint
               if {$mom_sys_ptp_output == "ON"} {MOM_open_output_file    $ptp_file_name }
               if {[hiset mom_group_name]} {
                  if {[hiset group_output_file($mom_group_name)]} {
                     MOM_open_output_file $group_output_file($mom_group_name)
                  }
               }
               if { $st == "on" } { MOM_set_seq_on }
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
  global mom_sequence_number mom_sequence_increment mom_sequence_frequency
  global mom_sys_ptp_output

  if {[regexp NC_PROGRAM $mom_group_name] == 1} {set group_level 0 ; return}
  if {[hiset mom_sys_group_output]} { if {$mom_sys_group_output == "OFF"} {set group_level 0 ; return}}
  if {[hiset group_level]} {incr group_level} else {set group_level 1}
  if {$group_level > 1} {return}

  # reset sequence number; what do we reset the sequence number to?
  SEQNO_RESET ; #<4133654>
  MOM_reset_sequence $mom_sequence_number $mom_sequence_increment $mom_sequence_frequency

  # temporarily close the main ptp_file_name if MOM_start_of_program is revisited
  # proof of MOM_start_of_program being revisited: ptp_file_name would be defined
  if {[info exists ptp_file_name]} {
    MOM_close_output_file $ptp_file_name ; MOM_start_of_program
    if {$mom_sys_ptp_output == "ON"} {MOM_open_output_file $ptp_file_name }
  } else {
    MOM_start_of_program
  }
}

proc MOM_end_of_group {} {
  global mom_sys_group_output group_output_file group_level mom_group_name
  global mom_parent_group_name mom_group_name ptp_file_name
  global mom_sys_ptp_output

  if {[hiset group_level]} {
    if {$group_level == 0} {
      return
    } else {
      if {$group_level == 1} {
        MOM_close_output_file $ptp_file_name ; MOM_end_of_program
        if {$mom_sys_ptp_output == "ON"} {MOM_open_output_file $ptp_file_name }
        MOM_close_output_file $group_output_file($mom_group_name)
        unset group_output_file($mom_group_name)
      }
      incr group_level -1
    }
  } else {return}
}

#<4133654> mom_seqnum exceeds MAX ? calls MOM_sequence_overflow(if exists), else mom_seqnum is reset.
#proc MOM_sequence_overflow {} {}

proc  MOM_text {} {
#_______________________________________________________________________________
# This procedure is executed when the Text command is activated.
#_______________________________________________________________________________
  global mom_user_defined_text mom_record_fields
  global mom_sys_control_out mom_sys_control_in
  global mom_record_text mom_pprint set mom_Instruction mom_operator_message
  global mom_pprint_defined mom_operator_message_defined

  switch $mom_record_fields(0) {
  "PPRINT"
         {
           set mom_pprint_defined 1
           set mom_pprint $mom_record_text
           MOM_pprint
         }
  "INSERT"
         {
           set mom_Instruction $mom_record_text
           MOM_insert
         }
  "DISPLY"
         {
           set mom_operator_message_defined 1
           set mom_operator_message $mom_record_text
           MOM_operator_message
         }
  default
         {
           if { [info exists mom_user_defined_text] } {
             MOM_output_literal "${mom_sys_control_out}${mom_user_defined_text}${mom_sys_control_in}"
           }
         }
  }
}

proc  MOM_start_of_thread {} {
#_______________________________________________________________________________
# This procedure is executed at the start of thread
#_______________________________________________________________________________
}

proc  MOM_end_of_thread {} {
#_______________________________________________________________________________
# This procedure is executed at the end of thread
#_______________________________________________________________________________
}

proc MOM_tracking_point_change {} {
#_______________________________________________________________________________
# This procedure is executed when tracking point change in GMC.
#_______________________________________________________________________________
	# Foce output of linear axes, to make sure there is a motion if only tracking point changed.
	MOM_force Once X Y Z
}

#=============================================================
proc MOM_before_contour_end { } {
#=============================================================
   # This event is triggered before the last segment of contour geometry is processed,
   # it can help to output proper Z coordinate for turn facing cycle.
}



################################################################################
# NX may provide additional elements for NX/Post
# ==> User should not overload this file!
#
if [file exists [MOM_ask_env_var UGII_CAM_POST_DIR]pb_base.tcl] {
   source [MOM_ask_env_var UGII_CAM_POST_DIR]pb_base.tcl
}


# Customer can provide additional elements for NX/Post.
#
#   This file allows the users to provide their own handlers or custom commands
#   that can be shared by the posts of their site.
#
#   This file should be placed in the $UGII_CAM_POST_DIR directory.
#   This file will not be delivered as part of the NX release.
#   The customer is responsible for the maintenance and migration of this file.
#
if [file exists [MOM_ask_env_var UGII_CAM_POST_DIR]ugpost_base_custom.tcl] {
   source [MOM_ask_env_var UGII_CAM_POST_DIR]ugpost_base_custom.tcl
}
