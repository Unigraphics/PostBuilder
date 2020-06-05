## HEADER BLOCK START ##
##############################################################################
#                                                                            #
# Copyright(c) 1999/2000/2001/2002/2003/2004/2005/2006, UGS PLM Solutions.   #
# Copyright(c) 2007 ~ 2019,                             SIEMENS PLM Software #
#                                                                            #
##############################################################################
#           P B _ C M D _ S U B P R O G R A M _ O U T P U T . T C L
##############################################################################
#
# This script file contains custom commands & supporting math functions that
# will equip a post with the ability to produce subprogram outputs in Fanuc style
# by using the functionalities provided via Process Patterning mechanism.
#
#=============================================================================
#
# Import all commands in this script file to enable a post to produce
# subprogram outputs in Fanuc style.
#
# ==> Functionalities are available in NX1899 & newer versions of NX.
# ==> Posted output produced as the result of these commnads only
#     serves as a sample. The user should modify the commands to
#     adjust the output as desired and necessary. 
#
#-----------------------------------------------------------------------------
# Main custom commands are :
#
#  PB_CMD__pattern_set_csys_start
#  - This command should be called by MOM_pattern_set_csys_start event handler to initialize
#    and process the transformation of coordinate system for an instance of a process pattern.
#
#  PB_CMD__pattern_set_csys_end
#  - This command should be called by MOM_pattern_set_csys_end to complete
#    the construction of subprogram and to restore VNC configuration.
#
#  PB_CMD__subprogram_output_start
#  - This command should be called by MOM_initial_move & MOM_first_move 
#    under the condition when subprogram output is enabled.
#
#  PB_CMD__subprogram_output_end
#  - This command is called by PB_CMD__pattern_set_csys_end, currently;
#    it will complete the construction of a subprogram and make the initial call.
#
#  PB_CMD__subprogram_output_dump
#  - This command should be called by MOM_end_of_program
#    under the condition when subprogram output is enabled.
#
#  PB_CMD__check_block_running_post_oper_path
#  - This condition command checks if an event is being triggered during
#    the execution of MOM_post_oper_path command, of which the event
#    may need to be handled differently.
#
#  PB_CMD__check_block_subprogram_output_on
#  - This condition command can be called by MOM_initial_move,
#    MOM_first_move & MOM_end_of_program, or any event applicable,
#    to determine if subprogram output has been enabled.
#    => Ability to produce subprogram output should have been determined in
#       PB_CMD__pattern_set_csys_start.
#
#  PB_CMD_fixture_offset
#  - This command will be called by PB_CMD__pattern_set_csys_start,
#    PB_CMD__subprogram_output_end, MOM_initial_move & MOM_first_move
#    to manage and output fixture offset instructions
#
#  PB_CMD_patch_fixture_offset_blocks
#  - This command will be called by PB_CMD_fixture_offset
#    to add the definition of block templates needed
#    to output fixture offset instructions.
#
#=============================================================================
## HEADER BLOCK END ##




#-------------------------------------------------------------
proc VEC3_find_principal_angle { VEC plane } {
#-------------------------------------------------------------
# Compute angle of a vector w.r.t a given principal plane.
# It returns angle in degrees.
#
# Jan 24, 2013 gsl -
#
   upvar $VEC v

  # Assign principal plane axis vector
   switch $plane {
      XY {
        # set p(0) 0.0;  set p(1) 0.0;  set p(2) 1.0
         set r1 $v(2);  set r2 $v(0);  set r3 $v(1)
      }
      YZ {
        # set p(0) 1.0;  set p(1) 0.0;  set p(2) 0.0
         set r1 $v(0);  set r2 $v(1);  set r3 $v(2)
      }
      ZX {
        # set p(0) 0.0;  set p(1) 1.0;  set p(2) 0.0
         set r1 $v(1);  set r2 $v(2);  set r3 $v(0)
      }
      default { }
   }

   expr { $::RAD2DEG*atan2($r1,[expr sqrt($r2*$r2 + $r3*$r3)]) }
}

#-------------------------------------------------------------
proc VEC3_find_plane_angle { VEC VECP } {
#-------------------------------------------------------------
# Compute angle of a vector w.r.t the plane of a given normal.
# It returns angle in degrees.
#
# Jan 24, 2013 gsl -
#
   upvar $VEC  v
   upvar $VECP p ;# Plane normal vector

   expr { 90.0 - $::RAD2DEG * acos([VEC3_dot v p]) }
}

#-------------------------------------------------------------
proc MTX2_det { MTX2 } {
#-------------------------------------------------------------
   upvar $MTX2  m2

return [expr $m2(0)*$m2(3) - $m2(1)*$m2(2)]
}

#-------------------------------------------------------------
proc MTX3_det { MTX3 } {
#-------------------------------------------------------------
   upvar $MTX3  m3

return [expr $m3(0)*( $m3(4)*$m3(8) - $m3(5)*$m3(7) ) - \
             $m3(3)*( $m3(1)*$m3(8) - $m3(2)*$m3(7) ) + \
             $m3(6)*( $m3(1)*$m3(5) - $m3(2)*$m3(4) )]
}

#-------------------------------------------------------------
proc MTX3_init { CSYS } {
#-------------------------------------------------------------
   upvar $CSYS  csys

   set csys(0) 1.0;  set csys(1) 0.0;  set csys(2) 0.0
   set csys(3) 0.0;  set csys(4) 1.0;  set csys(5) 0.0
   set csys(6) 0.0;  set csys(7) 0.0;  set csys(8) 1.0
}

#-------------------------------------------------------------
proc MTX3_invert { CSYS ISYS } {
#-------------------------------------------------------------
   upvar $CSYS  csys
   upvar $ISYS  isys

   set a11 $csys(0);  set a12 $csys(1);  set a13 $csys(2)
   set a21 $csys(3);  set a22 $csys(4);  set a23 $csys(5)
   set a31 $csys(6);  set a32 $csys(7);  set a33 $csys(8)

   set m3_det [MTX3_det csys]

   for { set i 0 } { $i < 9 } { incr i } {
      switch $i {
         0 { set m2(0) $a22; set m2(1) $a23; set m2(2) $a32; set m2(3) $a33 }
         1 { set m2(0) $a13; set m2(1) $a12; set m2(2) $a33; set m2(3) $a32 }
         2 { set m2(0) $a12; set m2(1) $a13; set m2(2) $a22; set m2(3) $a23 }
         3 { set m2(0) $a23; set m2(1) $a21; set m2(2) $a33; set m2(3) $a31 }
         4 { set m2(0) $a11; set m2(1) $a13; set m2(2) $a31; set m2(3) $a33 }
         5 { set m2(0) $a13; set m2(1) $a11; set m2(2) $a23; set m2(3) $a21 }
         6 { set m2(0) $a21; set m2(1) $a22; set m2(2) $a31; set m2(3) $a32 }
         7 { set m2(0) $a12; set m2(1) $a11; set m2(2) $a32; set m2(3) $a31 }
         8 { set m2(0) $a11; set m2(1) $a12; set m2(2) $a21; set m2(3) $a22 }
         default {}
      }

      set isys($i) [expr [MTX2_det m2] / $m3_det]
   }
}

#-------------------------------------------------------------
proc CSYS_diff { CSYS_REF CSYS_TGT CSYS_OFF } {
#-------------------------------------------------------------
# Find offset (matrix) from one CSYS to another.
#
   upvar $CSYS_REF c1 ;# Reference CSYS
   upvar $CSYS_TGT c2 ;# Target CSYS
   upvar $CSYS_OFF c3 ;# Offset matrix

    set u(0) [expr $c2(9)  - $c1(9)]
    set u(1) [expr $c2(10) - $c1(10)]
    set u(2) [expr $c2(11) - $c1(11)]

   MTX3_vec_multiply u c1 w

   MTX3_invert c1 c1i
   MTX3_multiply c1i c2 c3

   set c3(9)  $w(0)
   set c3(10) $w(1)
   set c3(11) $w(2)
}

#-------------------------------------------------------------
proc CSYS_match { CSYS1 CSYS2 CDIFF } {
#-------------------------------------------------------------
# Compare 2 CSYS matrix -
#
# It returns 1 when two matrices are identical and returns 0 otherwise.
# It also stores the differences in an array of 12.
#
   upvar $CSYS1 c1
   upvar $CSYS2 c2
   upvar $CDIFF c3

   set is_equal 1

   for { set i 0 } { $i < 12 } { incr i } {
      set c3($i) [expr $c1($i) - $c2($i)]
      if { $is_equal && ![EQ_is_zero $c3($i)] } {
         set is_equal 0  ;# Do not break, need to return entire DIFF matrix.
      }
   }

return $is_equal
}

#-------------------------------------------------------------
proc CSYS_ask_rotary_angles { ANG_A  ANG_B  ANG_C  CSYS } {
#-------------------------------------------------------------
# Find rotations of a orthogonal machine from given CSYS matrix.
#
# For a 5-axis machine, there will be 2 angles most (with 1 zero);
# one of them is the 4th-axis rotation which should be performed first!
#
#
# Jan 24, 2013 gsl -
# Jun 04, 2013 gsl - initialize angles
# Apr 18, 2019 gsl - 5-axis case was not complete.
#
   upvar $ANG_A ang_A
   upvar $ANG_B ang_B
   upvar $ANG_C ang_C
   upvar $CSYS  csys

   set ang_A 0.0
   set ang_B 0.0
   set ang_C 0.0

   global mom_kin_machine_type
   global mom_kin_4th_axis_plane mom_kin_5th_axis_plane

   # Do we ever need this for lathe?
   if [string match "MILL" [PB_CMD_ask_machine_type]] {

      # Principal axes: (X/Y/Z)
      set px(0) 1.0;  set px(1) 0.0;  set px(2) 0.0;
      set py(0) 0.0;  set py(1) 1.0;  set py(2) 0.0;
      set pz(0) 0.0;  set pz(1) 0.0;  set pz(2) 1.0;

      # CSYS matrix: (X'/Y'/Z')
      set ppx(0) $csys(0)
      set ppx(1) $csys(1)
      set ppx(2) $csys(2)

      set ppy(0) $csys(3)
      set ppy(1) $csys(4)
      set ppy(2) $csys(5)

      set ppz(0) $csys(6)
      set ppz(1) $csys(7)
      set ppz(2) $csys(8)


      if { [string match "4*" $mom_kin_machine_type] } {

         switch $mom_kin_4th_axis_plane {
            "XY" {
               set ang_C [expr $::RAD2DEG * atan2($ppx(1),$ppx(0))]
            }
            "YZ" {
               set ang_A [expr $::RAD2DEG * atan2(-1*$ppz(1),$ppz(2))]
            }
            "ZX" {
               set ang_B [expr $::RAD2DEG * atan2($ppz(0),$ppz(2))]
            }
         }
      }

      if { [string match "5*" $mom_kin_machine_type] } {

         switch $mom_kin_4th_axis_plane {
            "XY" {
              # Find principal angle of X' on XY plane to rotate about Y(B).
               set ang_B [VEC3_find_principal_angle ppx XY]

              # If X' is on XY plane already, find angle of Y' instead to rotate about X(A).
               if [EQ_is_zero $ang_B] {
                  set ang_A [VEC3_find_principal_angle ppy XY]
               }

              # Find angle from projected X' on XY to X to rotate about Z(C).
               set v(0) $ppx(0)
               set v(1) $ppx(1)
               set v(2) 0.0
               VEC3_unitize v u
               if [EQ_is_gt [VEC3_mag u] 0.0] {
                  set ang_C [expr { $::RAD2DEG * atan2(-$u(1),$u(0)) }]
               }
            }

            "YZ" {
              # Find principal angle of Y' on YZ plane to rotate about Z.
               set ang_C [VEC3_find_principal_angle ppy YZ]

              # If Y' is on YZ plane already, find angle of Z' on YZ plane.
               if [EQ_is_zero $ang_C] {
                  set ang_B [VEC3_find_principal_angle ppz YZ]
               }

              # Find angle from projected Y' on YZ to Y.
               set v(0) 0.0
               set v(1) $ppy(1)
               set v(2) $ppy(2)
               VEC3_unitize v u
               if [EQ_is_gt [VEC3_mag u] 0.0] {
                  set ang_A [expr { $::RAD2DEG * atan2(-$u(2),$u(1)) }]
               }
            }

            "ZX" {

              # Find principal angle of Z' on ZX plane to rotate about X.
               set ang_A [VEC3_find_principal_angle ppz ZX]
               if { [EQ_is_zero $ang_A] && [EQ_is_equal [VEC3_dot ppz pz] -1.0] } {
                  set ang_A 180.0
               }

              # If Z' is on ZX plane already, find angle of X' instead.
               if [EQ_is_zero $ang_A] {
                  set ang_C [VEC3_find_principal_angle ppx ZX]
               }
               if { [EQ_is_zero $ang_C] && [EQ_is_equal [VEC3_dot ppx px] -1.0] } {
                  set ang_C 180.0
               } else {
                  set ang_C [expr -$ang_C] ;# Not sure why C needs to be negated???
               }

              # Find angle from projected Z' on ZX to Z. to rotate about Y.
               set v(0) $ppz(0)
               set v(1) 0.0
               set v(2) $ppz(2)
               VEC3_unitize v u
               if [EQ_is_gt [VEC3_mag u] 0.0] {
                  set ang_B [expr { $::RAD2DEG * atan2(-$u(0),$u(2)) }]
               }
            }
         }

         switch $mom_kin_5th_axis_plane {
            "XY" {
               set ang_C [expr $::RAD2DEG * atan2($ppx(1),$ppx(0))]
            }
            "YZ" {
               set ang_A [expr $::RAD2DEG * atan2(-1*$ppz(1),$ppz(2))]
            }
            "ZX" {
               set ang_B [expr $::RAD2DEG * atan2($ppz(0),$ppz(2))]
            }
         }
      }
   }
}

#-------------------------------------------------------------
proc ARR_sort_array_vals { ARR } {
#-------------------------------------------------------------
# This command will sort and return a list containing indexed elements of an array.
#
   upvar $ARR arr

   set list [list]
   foreach a [lsort -dictionary [array names arr]] {
      if ![catch {expr $arr($a)}] {
         set val [format "%+.5f" $arr($a)]
      } else {
         set val $arr($a)
      }
      lappend list ($a) $val
   }

return $list
}

#-------------------------------------------------------------
proc  deg2rad { a } {
#-------------------------------------------------------------
return [expr $a * $::DEG2RAD]
}

#-------------------------------------------------------------
proc  rad2deg { a } {
#-------------------------------------------------------------
return [expr $a * $::RAD2DEG]
}

#-------------------------------------------------------------
proc  sinD { a } {
#-------------------------------------------------------------
return [expr sin( $::DEG2RAD * $a )]
}

#-------------------------------------------------------------
proc  -sinD { a } {
#-------------------------------------------------------------
return [expr -1 * sin( $::DEG2RAD * $a )]
}

#-------------------------------------------------------------
proc  cosD { a } {
#-------------------------------------------------------------
return [expr cos( $::DEG2RAD * $a )]
}

#-------------------------------------------------------------
proc  -cosD { a } {
#-------------------------------------------------------------
return [expr -1 * cos( $::DEG2RAD * $a )]
}

#=============================================================
proc  MTX3_xform_csys { a b c x y z CSYS } {
#=============================================================
   upvar $CSYS csys
#
#                     Rotation about
#         X                  Y                  Z
# ----------------   ----------------   ----------------
#   1     0     0     cosB   0   sinB    cosC -sinC    0
#   0   cosA -sinA     0     1     0     sinC  cosC    0
#   0   sinA  cosA   -sinB   0   cosB      0     0     1

   if { [EQ_is_zero $a] && [EQ_is_zero $b] && [EQ_is_zero $c] && [EQ_is_zero $x] && [EQ_is_zero $y] && [EQ_is_zero $z] } {
return
   }


   set xa [expr -1*$a]
   set yb [expr -1*$b]
   set zc [expr -1*$c]

  #<12-14-05 gsl>
   for { set i 0 } { $i < 9 } { incr i } {
      set mm($i) $csys($i)
   }

  # Rotate about X
   set mx(0) 1;           set mx(1) 0;           set mx(2) 0
   set mx(3) 0;           set mx(4) [cosD $xa];  set mx(5) [-sinD $xa]
   set mx(6) 0;           set mx(7) [sinD $xa];  set mx(8) [cosD $xa]

  # Rotate about Y
   set my(0) [cosD $yb];  set my(1) 0;           set my(2) [sinD $yb]
   set my(3) 0;           set my(4) 1;           set my(5) 0
   set my(6) [-sinD $yb]; set my(7) 0;           set my(8) [cosD $yb]

  # Rotate about Z
   set mz(0) [cosD $zc];  set mz(1) [-sinD $zc]; set mz(2) 0;
   set mz(3) [sinD $zc];  set mz(4) [cosD $zc];  set mz(5) 0;
   set mz(6) 0;           set mz(7) 0;           set mz(8) 1

#   MTX3_multiply  mz my ma
#   MTX3_multiply  ma mx mt
#   MTX3_multiply  mt mm m2
#   MTX3_transpose m2 csys

   MTX3_multiply  my mx ma
   MTX3_transpose ma mt
   MTX3_multiply  mz mt ma
   MTX3_multiply  ma mm m2
   MTX3_transpose m2 csys

  #<12-14-05 gsl> Add translation
   set csys(9)  [expr $csys(9)  + $x]
   set csys(10) [expr $csys(10) + $y]
   set csys(11) [expr $csys(11) + $z]
}

#=============================================================
proc ARR_sort_array_to_list { ARR {by_value 0} {by_decr 0} } {
#=============================================================
# This command will sort and build a list of elements of an array.
#
#   ARR      : Array Name
#   by_value : 0 Sort elements by names (default)
#              1 Sort elements by values
#   by_decr  : 0 Sort into increasing order (default)
#              1 Sort into decreasing order
#
#   Return a list of {name value} couplets
#
#-------------------------------------------------------------
# Feb-24-2016 gsl - Added by_decr flag
#
   upvar $ARR arr

   set list [list]
   foreach { e v } [array get arr] {
      if { [expr $::tcl_version > 8.1] && [string is double "$v"] } {
         set v [format "%.4f" $v]
      }
      lappend list "$e $v"
   }

   set val [lindex [lindex $list 0] $by_value]

   if { $by_decr } {
      set trend "decreasing"
   } else {
      set trend "increasing"
   }

   if [expr $::tcl_version > 8.1] {
      if [string is integer "$val"] {
         set list [lsort -integer    -$trend -index $by_value $list]
      } elseif [string is double "$val"] {
         set list [lsort -real       -$trend -index $by_value $list]
      } else {
         set list [lsort -dictionary -$trend -index $by_value $list]
      }
   } else {
      set list    [lsort -dictionary -$trend -index $by_value $list]
   }

return $list
}


#=============================================================
proc PB_CMD__pattern_set_csys_start { } {
#=============================================================
# This command should be called by MOM_pattern_set_csys_start event handler to initialize
# and process the transformation of coordinate system for an instance of a process pattern.
#
# Using the data resulted from the MOM core processor, this command can determine and prepare
# to output subsequent path (w.r.t. the same coordinate system) into the form of subprograms.
#

  # Prevent accidental call to this command
   if { ![CALLED_BY MOM_pattern_set_csys_start] } {
 return
   }

  # Something has gone really wrong when these vars are absent.
   if { ![info exists ::mom_process_patterning_pattern_mcs] ||\
        ![info exists ::mom_process_patterning_subroutine_program] } {
 return
   }

  # Just information -
   if { $::mom_process_pattern_index == 0 } {
      OPERATOR_MSG_debug "::mom_process_patterning_pattern_mcs        = $::mom_process_patterning_pattern_mcs"
      OPERATOR_MSG_debug "::mom_process_patterning_subroutine_program = $::mom_process_patterning_subroutine_program"
      OPERATOR_MSG_debug "::mom_process_pattern_group_name            = $::mom_process_pattern_group_name"
      OPERATOR_MSG_debug "::mom_process_pattern_count                 = $::mom_process_pattern_count"
      OPERATOR_MSG_debug "::mom_pattern_source_csys_matrix   : [ARR_sort_array_to_list ::mom_pattern_source_csys_matrix]"
      OPERATOR_MSG_debug "::mom_pattern_source_csys_origin   : [ARR_sort_array_to_list ::mom_pattern_source_csys_origin]"
      OPERATOR_MSG_debug "::mom_pattern_source_origin        : [ARR_sort_array_to_list ::mom_pattern_source_origin]"
   }

   OPERATOR_MSG_debug "::mom_process_pattern_index        = $::mom_process_pattern_index"
   OPERATOR_MSG_debug "::mom_pattern_csys_matrix          : [ARR_sort_array_to_list ::mom_pattern_csys_matrix]"
   OPERATOR_MSG_debug "::mom_pattern_csys_origin          : [ARR_sort_array_to_list ::mom_pattern_csys_origin]"
   OPERATOR_MSG_debug "::mom_pattern_instance_csys_matrix : [ARR_sort_array_to_list ::mom_pattern_instance_csys_matrix]"


  # Set control to output & call subroutine -
  # - Current scheme with this post enables subprogram output Only
  #   when both toggle options are checked with a Pattern Group on ONT.
  #
   if { $::mom_process_patterning_pattern_mcs == "Yes" &&\
        $::mom_process_patterning_subroutine_program == "Yes" } {
      set ::PATTERN_OUTPUT(SUB) 1
   } else {
      set ::PATTERN_OUTPUT(SUB) 0
   }


# For Dev debug -
# set ::PATTERN_OUTPUT(SUB) 0


   VMOV 12 ::mom_pattern_csys_matrix  this_pattern_csys_matrix

  # Initialize some vars -
   if { ![info exists ::mom_sys_sub_program_ready] } {
      set ::mom_sys_sub_program_ready 0
   }

   if { ![info exists ::mom_fixture_offset_value] } {
      set ::mom_fixture_offset_value 0
   }


  # Configure how subprograms are numbered and incremented -
   if { $::PATTERN_OUTPUT(SUB) } {
      if { $::mom_process_pattern_index == 0 } {

         set ::mom_sys_sub_program_ready 0

        # Initialize subprogram number -
         if { ![info exists ::mom_sys_subprogram_number] } {
            set ::mom_sys_subprogram_number 1000
         } else {
            incr ::mom_sys_subprogram_number 100
         }

      } else {

        # Increment fixture offset number for subsequent subprogram calls.
         incr ::mom_fixture_offset_value
      }
   }


  #-------------------------------------
  # No need to process the 0th instance
  #
   if { $::mom_process_pattern_index == 0 } {
     # The 1st subprogram call will use current fixture offset number.
return
   }


  #++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
  # @ Very first oper of the 0th instance, mom_csys_matrix is not yet set!
  #
   if ![info exists ::mom_csys_matrix] {
return
   }



 set instance_index [expr $::mom_process_pattern_index + 1]
 OPERATOR_MSG "PATTERN : $::mom_process_pattern_group_name #$instance_index INSTANCE OF $::mom_process_pattern_count"


  # Find the rotational & linear offsets from the transformation matrix of current instance of a pattern,
  # and extract data to output NC instructions of coordinate system changes before calling a subprogram.
  #
   VMOV 12 ::mom_pattern_instance_csys_matrix CSYS_OFF

   CSYS_ask_rotary_angles ANG_A ANG_B ANG_C CSYS_OFF

   if { ![EQ_is_zero $ANG_A] || ![EQ_is_zero $ANG_B] || ![EQ_is_zero $ANG_C] } {

     # Negate rotations for table
      set ANG_A [format "%.4f" [expr -1*$ANG_A]]
      set ANG_B [format "%.4f" [expr -1*$ANG_B]]
      set ANG_C [format "%.4f" [expr -1*$ANG_C]]

      MOM_output_literal "G90 G00 A$ANG_A B$ANG_B C$ANG_C"
      MOM_disable_address fourth_axis fifth_axis

      MOM_output_literal "G69"
      if { ![EQ_is_zero $ANG_A] } {
         MOM_output_literal "G68 I1 R$ANG_A"
      }
      if { ![EQ_is_zero $ANG_B] } {
         MOM_output_literal "G68 J1 R$ANG_B"
      }
      if { ![EQ_is_zero $ANG_C] } {
         MOM_output_literal "G68 K1 R$ANG_C"
      }
   }


   set output_factor 1.0
   if { ![string match "$::mom_output_unit" "$::mom_part_unit"] } {
      if { [string match "MM" $::mom_output_unit] } {
         set output_factor 25.4
      } else {
         set output_factor [expr 1/25.4]
      }
   }


   if { [EQ_is_zero $ANG_A] && [EQ_is_zero $ANG_B] && [EQ_is_zero $ANG_C] } {
      set CSYS_OFF(9)  0.0
      set CSYS_OFF(10) 0.0
      set CSYS_OFF(11) 0.0
   } else {
      if { ![EQ_is_zero $ANG_A] } {
         set CSYS_OFF(9) 0.0
      }
      if { ![EQ_is_zero $ANG_B] } {
         set CSYS_OFF(10) 0.0
      }
      if { ![EQ_is_zero $ANG_C] } {
         set CSYS_OFF(11) 0.0
      }
   }


   set this_pattern_csys_matrix(9)   [expr $this_pattern_csys_matrix(9)  - $CSYS_OFF(9)]
   set this_pattern_csys_matrix(10)  [expr $this_pattern_csys_matrix(10) - $CSYS_OFF(10)]
   set this_pattern_csys_matrix(11)  [expr $this_pattern_csys_matrix(11) - $CSYS_OFF(11)]


  # Output a local shift instruction
   MOM_output_literal "G52 X0.0 Y0.0 Z 0.0"
   PB_CMD_fixture_offset

   if { [EQ_is_zero $ANG_A] && [EQ_is_zero $ANG_B] && [EQ_is_zero $ANG_C] } {

      set X_shift [format "%.4f" [expr $this_pattern_csys_matrix(9)  * $output_factor - $::mom_csys_origin(0)]]
      set Y_shift [format "%.4f" [expr $this_pattern_csys_matrix(10) * $output_factor - $::mom_csys_origin(1)]]
      set Z_shift [format "%.4f" [expr $this_pattern_csys_matrix(11) * $output_factor - $::mom_csys_origin(2)]]

      MOM_output_literal "G52 X$X_shift Y$Y_shift Z$Z_shift"
   }


   # Call subprogram for current instance
   if { $::PATTERN_OUTPUT(SUB) } {
      MOM_output_literal "M98 P$::mom_sys_subprogram_number"
      MOM_output_text " "
   }


if 0 {
PAUSE "A = $ANG_A, B = $ANG_B, C = $ANG_C\n\n\
       pattern_csys_matrix = [ARR_sort_array_to_list ::mom_pattern_csys_matrix]\n\n\
       csys_matrix         = [ARR_sort_array_to_list ::mom_csys_matrix] [ARR_sort_array_to_list ::mom_csys_origin]\n\n\
       msys_matrix         = [ARR_sort_array_to_list ::mom_msys_matrix] [ARR_sort_array_to_list ::mom_msys_origin]"
}


  # Pass the CSYS information that will be used to
  # set the ZCS coordinate system for simulation.
  #
   if { ![EQ_is_zero $ANG_A] || ![EQ_is_zero $ANG_B] || ![EQ_is_zero $ANG_C] } {

      if { [info exists ::sim_mtd_initialized] && $::sim_mtd_initialized } {
         if [llength [info commands PB_VNC_pass_csys_data] ] {
            VMOV 12 ::mom_csys_matrix saved_csys_matrix
           # VMOV 9  ::mom_csys_matrix this_pattern_csys_matrix
            VMOV 9  ::mom_pattern_source_csys_matrix this_pattern_csys_matrix
            VMOV 12  this_pattern_csys_matrix ::mom_csys_matrix

            set ::mom_sim_csys_set 0
            PB_VNC_pass_csys_data
            set ::mom_sim_csys_set 1

            VMOV 12 saved_csys_matrix ::mom_csys_matrix
         }
      }
   }

}


#=============================================================
proc PB_CMD__subprogram_output_start { } {
#=============================================================
# This command should be called by MOM_initial_move & MOM_first_move 
# under the condition when subprogram output is enabled.
#

  # Start building of a subprogram, close it off @ MOM_pattern_set_csys_end
  #
   if { [info exists ::PATTERN_OUTPUT(SUB)] && $::PATTERN_OUTPUT(SUB) &&\
        $::mom_process_pattern_index == 0 } {

      if { ![info exists ::mom_sys_sub_program_ready] } {
         set ::mom_sys_sub_program_ready 0
      }

     # Suspend current output file
      MOM_close_output_file $::ptp_file_name

     # Prepare output file to collect subprograms
      if { ![info exists  ::mom_sys_subprogram_output_file] ||\
           ![file exists $::mom_sys_subprogram_output_file] } {

         set out_file "${::mom_output_file_directory}${::mom_logname}__tmp_output_[clock clicks].spf"

         set ::mom_sys_subprogram_output_file "${out_file}"
      }

      MOM_open_output_file "${::mom_sys_subprogram_output_file}"

     # Output subprogram name
      MOM_disable_address N
      if { $::mom_sys_sub_program_ready == 0 } {
         MOM_output_text "O${::mom_sys_subprogram_number}"
         PB_CMD_oper_info
      }

      set ::mom_sys_sub_program_ready 1
   }

}


#=============================================================
proc PB_CMD__subprogram_output_end { } {
#=============================================================
# This command is called by PB_CMD__pattern_set_csys_end, currently;
# it will complete the construction of a subprogram and make the initial call.
# 

   if { [info exists ::PATTERN_OUTPUT(SUB)] && $::PATTERN_OUTPUT(SUB) &&\
        $::mom_process_pattern_index == 0 } {

     # End current subprogram
      MOM_output_text "M99"
      MOM_output_text " "

      MOM_close_output_file $::mom_sys_subprogram_output_file

     # Resume main program output
      MOM_open_output_file  $::ptp_file_name

     # Make the first call (0th instance)
      MOM_output_text " "

 set instance_index [expr $::mom_process_pattern_index + 1]
 OPERATOR_MSG "PATTERN : $::mom_process_pattern_group_name #$instance_index INSTANCE OF $::mom_process_pattern_count"

      PB_CMD_fixture_offset

      MOM_output_literal "M98 P$::mom_sys_subprogram_number"
      MOM_output_text " "

      set ::PATTERN_OUTPUT(SUB) 0
   }

}


#=============================================================
proc PB_CMD__pattern_set_csys_end { } {
#=============================================================
# This command should be called by MOM_pattern_set_csys_end to complete
# the construction of subprogram and to restore VNC configuration.
#

  # Prevent accidental call to this command
   if { ![CALLED_BY MOM_pattern_set_csys_end] } {
 return
   }

  # Complete subprogram output
   PB_CMD__subprogram_output_end

  # Restore to previous VNC configuration
   if { [info exists ::sim_mtd_initialized] && $::sim_mtd_initialized } {
      if [llength [info commands PB_VNC_pass_csys_data] ] {
         set ::mom_sim_csys_set 0
         PB_VNC_pass_csys_data
         set ::mom_sim_csys_set 1
      }
   }

}


#=============================================================
proc PB_CMD__subprogram_output_dump { } {
#=============================================================
# This command should be called by MOM_end_of_program
# under the condition when subprogram output is enabled.
#

   if { [info exists ::PATTERN_OUTPUT(SUB)] && $::PATTERN_OUTPUT(SUB) } {

      if { [info exists  ::mom_sys_subprogram_output_file] &&\
           [file exists $::mom_sys_subprogram_output_file] } {

         if { [file size $::mom_sys_subprogram_output_file] } {

           #---------------------------------------------------------
           # Combine subprograms with contents of existing N/C file -
           #---------------------------------------------------------
            MOM_close_output_file $::ptp_file_name

            if [file exists __tmp_output_file] {
               file delete -force __tmp_output_file 
            }
            file rename $::ptp_file_name __tmp_output_file

           # Open a fresh PTP file -
            MOM_open_output_file $::ptp_file_name
 
           # Construct final program -
            MOM_suppress Once N
            MOM_do_template rewind_stop_code 

           # Append subprograms -
            set src [open "$::mom_sys_subprogram_output_file" RDONLY]
            while { [eof $src] == 0 } {
               MOM_output_text [gets $src]
            }
            close $src

           # Append contents of PTP file -
            set src [open __tmp_output_file RDONLY]
            while { [eof $src] == 0 } {
               set line [gets $src]
               if { $line != "%" } {
                  MOM_output_text $line
               }
            }
            close $src
            file delete __tmp_output_file

            MOM_enable_address N
         }

         file delete "$::mom_sys_subprogram_output_file"
      }
   }

}


#=============================================================
proc PB_CMD__check_block_running_post_oper_path { } {
#=============================================================
# This custom command should return
#   1 : Output
#   0 : No output

   global mom_logname

   if { [info exists ::mom_post_oper_path] && $::mom_post_oper_path } {
      OPERATOR_MSG_debug "==> Running MOM_post_oper_path, skip [info level -1]"
      MOM_enable_address N
      CLOSE_files
 return 1
   }

 return 0
}



#=============================================================
proc PB_CMD__check_block_subprogram_output_on { } {
#=============================================================
# This condition command can be called by MOM_initial_move,
# MOM_first_move & MOM_end_of_program, or any event applicable,
# to determine if subprogram output has been enabled.
#
# This custom command should return
#   1 : Output
#   0 : No output

   global mom_logname

   if { [info exists ::PATTERN_OUTPUT(SUB)] && $::PATTERN_OUTPUT(SUB) } {
 return 1
   } else {
 return 0
   }
}


#=============================================================
proc PB_CMD_fixture_offset { } {
#=============================================================
# This command will be called by PB_CMD__pattern_set_csys_start,
# PB_CMD__subprogram_output_end, MOM_initial_move & MOM_first_move
# to manage and output fixture offset instructions
# 
  global mom_fixture_offset_value

   if { [CMD_EXIST PB_CMD_patch_fixture_offset_blocks] } {
      PB_CMD_patch_fixture_offset_blocks
   }

   if { ![info exists mom_fixture_offset_value] } {
      set mom_fixture_offset_value 0
   }

   if { [info exists mom_fixture_offset_value] } {
      if { $mom_fixture_offset_value < 0 } {
         set mom_fixture_offset_value 0
      }
      if { $mom_fixture_offset_value > 6 } {
         set mom_fixture_offset_value [expr $mom_fixture_offset_value - 6]
         MOM_do_template fixture_number_enhancement
return
      }
   }

   MOM_do_template fixture_number
}


#=============================================================
proc PB_CMD_patch_fixture_offset_blocks { } {
#=============================================================
# This command will be called by PB_CMD_fixture_offset
# to add the definition of block templates needed
# to output fixture offset instructions.
#
   global mom_logname

   if { [MOM_has_definition_element BLOCK fixture_number] &&\
        [MOM_has_definition_element BLOCK fixture_number_enhancement] &&\
        [MOM_has_definition_element ADDRESS P_fixture_offset] } {

      # Both blocks & needed address exist, do nothing -
return
   }

   set ugii_tmp_dir [MOM_ask_env_var UGII_TMP_DIR]
   set def_file_name  [file join $ugii_tmp_dir __${mom_logname}_patch_fixture_offset_blocks_[clock clicks].def]

   if { [catch { set tmp_file [open "$def_file_name" w] } res] } {

      if { ![info exists res] } {
         set res "$def_file_name\nFile open error!"
      }

      if { [llength [info commands PAUSE] ] } {
         PAUSE "Definition patch file error" "$res"
      }

      CATCH_WARNING "$res"
return
   }


   fconfigure $tmp_file -translation lf

   puts $tmp_file "MACHINE mill"
   puts $tmp_file "FORMATTING"
   puts $tmp_file "{"

   if { ![MOM_has_definition_element ADDRESS P_fixture_offset] } {
      puts $tmp_file "  ADDRESS P_fixture_offset"
      puts $tmp_file "  {"
      puts $tmp_file "      FORMAT      Digit_2"
      puts $tmp_file "      FORCE       off"
      puts $tmp_file "      MAX         99 Truncate"
      puts $tmp_file "      MIN         1 Truncate"
      puts $tmp_file "      LEADER      \"P\""
      puts $tmp_file "  }"
   }

   if { ![MOM_has_definition_element BLOCK fixture_number] } {
      puts $tmp_file "  BLOCK_TEMPLATE fixture_number"
      puts $tmp_file "  {"
      puts $tmp_file "       G\[\$mom_fixture_offset_value + 53\]"
      puts $tmp_file "  }"
   }

   if { ![MOM_has_definition_element BLOCK fixture_number_enhancement] } {
      puts $tmp_file "  BLOCK_TEMPLATE fixture_number_enhancement"
      puts $tmp_file "  {"
      puts $tmp_file "       Text\[G54.1\]"
      puts $tmp_file "       P_fixture_offset\[\$mom_fixture_offset_value\]"
      puts $tmp_file "  }"
   }

   puts $tmp_file "}"

   close $tmp_file

   global tcl_platform
   if { [string match "*windows*" $tcl_platform(platform)] } {
      regsub -all {/} $def_file_name {\\} def_file_name
   }

   if { [catch { MOM_load_definition_file  "$def_file_name" } res] } {
      CATCH_WARNING $res
   }

   MOM_remove_file $def_file_name
}


#=============================================================
proc OPERATOR_MSG_debug { msg {seq_no 0} } {
#=============================================================
# This command will output a single or a set of operator message(s).
#
#   msg    : Message(s separated by new-line character)
#   seq_no : 0 Output message without sequence number (Default)
#            1 Output message with sequence number
#

# - Suppress debug messages; comment out next line to reveal messages -
 return

   foreach s [split $msg \n] {
      set s1 "$::mom_sys_control_out $s $::mom_sys_control_in"
      if { [string length $s] > 0 } {
         if { !$seq_no } {
            MOM_suppress once N
         }
         MOM_output_literal $s1
      }
   }

   set ::mom_o_buffer ""
}



