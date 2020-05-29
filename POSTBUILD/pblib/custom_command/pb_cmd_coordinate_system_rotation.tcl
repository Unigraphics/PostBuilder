################################################################################
#                                                                              #
#  Copyright (c) 1998/1999/2000,                     Unigraphics Solutions Inc.#
#  Copyright (c) 2001/2002/2003/2004,                EDS/UGS PLM Solutions.    #
#  Copyright (c) 2004/2005/2006,                     UGS Coorporation.         #
#  Copyright (c) 2007/2008/2009/2010/2011/2012/2013, SIEMENS PLM Softwares.    #
#                                                                              #
################################################################################

#=============================================================
proc PB_CMD_set_csys { } {
#=============================================================
#
#  This custom command will output the code needed to cause a
#  coordinate system transformation on the control.  Starting in NX2
#  MOM_set_csys event with a coordinate system type and matrix will be
#  output at the start of every tool path where the MCS changes.  If the
#  coordinate system type is CSYS, the coordinate system will be converted
#  into the rotations and translations needed.
#
#  This custom command can be modified to output the code needed for
#  a specific control. In this command, the codes are included for
#  Fanuc, Siemens, Heidenhain and Mazatrol controllers.
#
#  This custom command is used primarily for head/table or head/head
#  five-axis machines.
#
#
#  Import this command to the post. It will be executed automatically in
#  MOM_set_csys event handler.
#
#
#-------------------------------------------------------------------------------
#  Revisions
#*************
# 04-30-09 gsl - Retain current csys type in mom_sys_coordinate_system_status
# 11-03-09 gsl - m5 was m3 in "set sin_a [expr -1*$m5]"
#------
# v850
#------
# 03-13-12 gsl - Cleanup & call ROTSET with tolerant comparison
#              - Pass mom_init_pos to ROTSET instead of mom_pos
#------
# v900
#------
# 01-24-13 gsl - Use CATCH_WARNING
# 01-25-13 gsl - Compute compound rotations for Fanuc's G68 instruction (pr#6806015)
#                * Only orthogonal rotations are computed.
#                * The 1st rotation will be about the 4th axis; and the 2nd rotation may be arbitrary.
#                * Non-orthogoanl or Euler angles rotation (G68.2) not covered here!
# 06-04-13 gsl - VEC3_find_principal_angle was VEC3_find_spatial_angle
#              - Revised MTX3_ask_rotary_angles to take in CSYS as argument
# 07-07-13 gsl - Renamed MTX3_ask_rotary_angles to CSYS_ask_rotary_angles
#===============================================================================

# Only define new commands once,
if { ![CMD_EXIST "CSYS_ask_rotary_angles"] } {

uplevel #0 {

#-----------------------------------------------------------
proc VEC3_find_principal_angle { VEC plane } {
#-----------------------------------------------------------
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

  # expr { 90.0 - $::RAD2DEG * acos([VEC3_dot v p]) }
   expr { $::RAD2DEG*atan2($r1,[expr sqrt($r2*$r2 + $r3*$r3)]) }
}

#-----------------------------------------------------------
proc CSYS_ask_rotary_angles { ANG_A  ANG_B  ANG_C  CSYS } {
#-----------------------------------------------------------
# Find rotations of a orthogonal machine from given CSYS matrix.
#
# For a 5-axis machine, there will be 2 angles most (with 1 zero);
# one of them is the 4th-axis rotation which should be performed first!
#
#
# Jan 24, 2013 gsl -
# Jun 04, 2013 gsl - Initialize angles
# Jun 24, 2013 gsl - Revised
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
      }
   }
}

}  ;# uplevel
}  ;# CMD_EXIST


  #+++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
  # Choose one of controller types -
  #    siemens  fanuc  heidenhain_iso  heidenhain_conv  mazatrol
  #
  #  This custom commands is intended for general cases.  You may find that
  #  you need to make some adjustments to get the desired output.
  #

  # set controller_type siemens
   set controller_type fanuc
  # set controller_type heidenhain_iso
  # set controller_type heidenhain_conv
  # set controller_type mazatrol


   global mom_kin_coordinate_system_type
   global mom_sys_coordinate_system_status


  # When current MCS is not rotated -
   if { [string compare "CSYS" $mom_kin_coordinate_system_type] } {

     # Issue instructions to cancel MCS rotation, if it has been rotated previously.
      if { [info exists mom_sys_coordinate_system_status] && \
          ![string compare "CSYS" $mom_sys_coordinate_system_status] } {

         switch $controller_type {

            "siemens" {
               MOM_output_literal "TRANS X0.0 Y0.0 Z0.0"
               MOM_output_literal "ROT X0.0 Y0.0 Z0.0"
            }

            "fanuc" {
               MOM_output_literal "G69"
            }

            "heidenhain_iso" {
               MOM_output_literal "G7 L1=1 X5 0.0 Y5 0.0 Z5 0.0 A5 0.0 B5 0.0 C5 0.0"
            }

            "heidenhain_conv" {
               MOM_output_literal "CYCL DEF 19.0"
               MOM_output_literal "CYCL DEF 19.1 A0.0 B0.0 C0.0"
               MOM_output_literal "CYCL DEF 19.0"
               MOM_output_literal "CYCL DEF 19.1"
               MOM_output_literal "CYCL DEF 7.0"
               MOM_output_literal "CYCL DEF 7.1"
               MOM_output_literal "CYCL DEF 7.2"
               MOM_output_literal "CYCL DEF 7.3"
            }

            "mazatrol" {
               MOM_output_literal "G69.5"
            }
         }
      }

return
   }


  # Retain current MCS type
   set mom_sys_coordinate_system_status  $mom_kin_coordinate_system_type


  # Local settings for formatting outputs
   set coord_decimals  4
   set rotary_decimals 3


   global mom_csys_matrix

   set m0 $mom_csys_matrix(0)
   set m1 $mom_csys_matrix(1)
   set m3 $mom_csys_matrix(3)
   set m4 $mom_csys_matrix(4)
   set m5 $mom_csys_matrix(5)
   set m6 $mom_csys_matrix(6)
   set m7 $mom_csys_matrix(7)
   set m8 $mom_csys_matrix(8)

   set cos_b_sq [expr $m0*$m0 + $m3*$m3]

   if { [EQ_is_equal $cos_b_sq 0.0] } {

      set cos_b 0.0
      set cos_c 1.0
      set cos_a $m4
      set sin_c 0.0

      if { $m6 < 0.0 } {

         set sin_b 1.0
         set sin_a $m1

      } else {

         set sin_b -1.0
         set sin_a [expr -1*$m5]
      }

   } else {

      set cos_b [expr sqrt($cos_b_sq)]
      set sin_b [expr -$m6]

      set cos_a [expr $m8/$cos_b]
      set sin_a [expr $m7/$cos_b]

      set cos_c [expr $m0/$cos_b]
      set sin_c [expr $m3/$cos_b]
   }


   set x $mom_csys_matrix(9)
   set y $mom_csys_matrix(10)
   set z $mom_csys_matrix(11)

  # A/B/C angles in the order of rotations to be performed
   set a [expr -atan2($sin_a,$cos_a)*$::RAD2DEG]
   set b [expr -atan2($sin_b,$cos_b)*$::RAD2DEG]
   set c [expr -atan2($sin_c,$cos_c)*$::RAD2DEG]

   if { [EQ_is_lt $a 0.0] } { set a [expr $a + 360.0] }
   if { [EQ_is_lt $b 0.0] } { set b [expr $b + 360.0] }
   if { [EQ_is_lt $c 0.0] } { set c [expr $c + 360.0] }


  # ==> These vars will not need to be formatted, if output via Block templates
   set X [format "%.${coord_decimals}f"  $x]
   set Y [format "%.${coord_decimals}f"  $y]
   set Z [format "%.${coord_decimals}f"  $z]
   set A [format "%.${rotary_decimals}f" $a]
   set B [format "%.${rotary_decimals}f" $b]
   set C [format "%.${rotary_decimals}f" $c]

  #MOM_output_literal "X=$X Y=$Y Z=$Z A=$A  B=$B  C=$C"
  #MOM_output_literal "m0=$m0 m1=$m1 m2=$m2"
  #MOM_output_literal "m3=$m3 m4=$m4 m5=$m5"
  #MOM_output_literal "m6=$m6 m7=$m7 m8=$m8"

   global mom_kin_4th_axis_plane
   global mom_kin_5th_axis_plane
   global mom_kin_4th_axis_direction
   global mom_kin_5th_axis_direction
   global mom_kin_4th_axis_leader
   global mom_kin_5th_axis_leader
   global mom_kin_4th_axis_min_limit
   global mom_kin_4th_axis_max_limit
   global mom_kin_5th_axis_min_limit
   global mom_kin_5th_axis_max_limit
   global mom_out_angle_pos
   global mom_prev_out_angle_pos
   global mom_sys_leader

  # Data from addresses may not be precise
   if { ![info exists mom_prev_out_angle_pos(0)] } {
      set mom_prev_out_angle_pos(0) [MOM_ask_address_value fourth_axis]
      if { ![string compare "" [string trim $mom_prev_out_angle_pos(0)] ] } {
         set mom_prev_out_angle_pos(0) 0.0
      }
   }

   if { ![info exists mom_prev_out_angle_pos(1)] } {
      set mom_prev_out_angle_pos(1) [MOM_ask_address_value fifth_axis]
      if { ![string compare "" [string trim $mom_prev_out_angle_pos(1)] ] } {
         set mom_prev_out_angle_pos(1) 0.0
      }
   }


  # Compute rotary angles with tolerant comparison
   global mom_init_pos
   set tol_comp 1
   set mom_out_angle_pos(0) [ROTSET $mom_init_pos(3) $mom_prev_out_angle_pos(0) \
                                                     $mom_kin_4th_axis_direction \
                                                     $mom_kin_4th_axis_leader \
                                                      mom_sys_leader(fourth_axis) \
                                                     $mom_kin_4th_axis_min_limit \
                                                     $mom_kin_4th_axis_max_limit $tol_comp]

   set mom_out_angle_pos(1) [ROTSET $mom_init_pos(4) $mom_prev_out_angle_pos(1) \
                                                     $mom_kin_5th_axis_direction \
                                                     $mom_kin_5th_axis_leader \
                                                      mom_sys_leader(fifth_axis) \
                                                     $mom_kin_5th_axis_min_limit \
                                                     $mom_kin_5th_axis_max_limit $tol_comp]

  # Should mom_init_pos be refreshed here?
   set mom_init_pos(3) $mom_out_angle_pos(0)
   set mom_init_pos(4) $mom_out_angle_pos(1)


  # Pre-position rotary axes with mom_out_angle_pos
   PB_CMD_fourth_axis_rotate_move
   PB_CMD_fifth_axis_rotate_move


  if 0 { ;# For debug
   CATCH_WARNING  "Computed angles: A=$A, B=$B, C=$C\n\
                   mom_init_pos: $mom_init_pos(3), $mom_init_pos(4)"
  }


   switch $controller_type {

      "siemens" {

         MOM_output_literal "TRANS X$X Y$Y Z$Z"
         set rot ""

         set rot "ROT X$A"
         set rot "$rot ROT Y$B"
         set rot "$rot ROT Z$C"

         MOM_output_literal $rot
      }

      "fanuc" {

        #<01-25-2013 gsl>
        # 3D translation & rotation for Fanuc are cumulative -
        # 2 consecutive G68 blocks can be issued to achieve an arbitray orientation.
        #
         if { ![EQ_is_equal $A 0.0] && ![EQ_is_equal $B 0.0] && ![EQ_is_equal $C 0.0] } {

           if 0 {
            CATCH_WARNING  "Invalid coordinate system (A=$A, B=$B, C=$C).\
                            Unable to determine correct rotations."
           }


           #<01-24-2013 gsl> Recompute rotary angles
           #++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
            set ang_A 0.0; set ang_B 0.0; set ang_C 0.0
            CSYS_ask_rotary_angles ang_A ang_B ang_C mom_csys_matrix

             set A [format "%.${rotary_decimals}f" $ang_A]
             set B [format "%.${rotary_decimals}f" $ang_B]
             set C [format "%.${rotary_decimals}f" $ang_C]

           # Since compound rotations are dependent, 4th-axis angle should be rotated first
           # ==> Confirmed with Fanuc-30i manual that order of I/J/K can be arbitrary.
           # ==> G68.2 would take "proper" Euler angles in I/J/K as Z-X-Z rotations. <== Not covered here!
            switch $mom_kin_4th_axis_plane {

               "XY" {
                  if { ![EQ_is_equal $C 0.0] } {
                     MOM_output_literal "G68 X$X Y$Y Z$Z I0 J0 K1 R$C"

                     if { ![EQ_is_equal $A 0.0] } {
                        MOM_output_literal "G68 I1 J0 K0 R$A"
                     } else {
                        MOM_output_literal "G68 I0 J1 K0 R$B"
                     }
                  } else {
                     if { ![EQ_is_equal $A 0.0] } {
                        MOM_output_literal "G68 X$X Y$Y Z$Z I1 J0 K0 R$A"
                     } else {
                        MOM_output_literal "G68 X$X Y$Y Z$Z I0 J1 K0 R$B"
                     }
                  }
               }

               "YZ" {
                  if { ![EQ_is_equal $A 0.0] } {
                     MOM_output_literal "G68 X$X Y$Y Z$Z I1 J0 K0 R$A"

                     if { ![EQ_is_equal $C 0.0] } {
                        MOM_output_literal "G68 I0 J0 K1 R$C"
                     } else {
                        MOM_output_literal "G68 I0 J1 K0 R$B"
                     }
                  } else {
                     if { ![EQ_is_equal $C 0.0] } {
                        MOM_output_literal "G68 X$X Y$Y Z$Z I0 J0 K1 R$C"
                     } else {
                        MOM_output_literal "G68 X$X Y$Y Z$Z I0 J1 K0 R$B"
                     }
                  }
               }

               "ZX" {
                  if { ![EQ_is_equal $B 0.0] } {
                     MOM_output_literal "G68 X$X Y$Y Z$Z I0 J1 K0 R$B"

                     if { ![EQ_is_equal $C 0.0] } {
                        MOM_output_literal "G68 I0 J0 K1 R$C"
                     } else {
                        MOM_output_literal "G68 I1 J0 K0 R$A"
                     }
                  } else {
                     if { ![EQ_is_equal $C 0.0] } {
                        MOM_output_literal "G68 X$X Y$Y Z$Z I0 J0 K1 R$C"
                     } else {
                        MOM_output_literal "G68 X$X Y$Y Z$Z I1 J0 K0 R$A"
                     }
                  }
               }
            }
           #++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++

         } else {

            set a 0
            set b 0

            if { ![EQ_is_equal $A 0.0] } {
               MOM_output_literal "G68 X$X Y$Y Z$Z I1 J0 K0 R$A"
               set a 1
            }

            if { ![EQ_is_equal $B 0.0] } {
               if { $a == 0 } {
                  MOM_output_literal "G68 X$X Y$Y Z$Z I0 J1 K0 R$B"
               } else {
                  MOM_output_literal "G68 I0 J1 K0 R$B"
               }
               set b 1
            }

            if { ![EQ_is_equal $C 0.0] } {
               if { $a == 0 && $b == 0 } {
                  MOM_output_literal "G68 X$X Y$Y Z$Z I0 J0 K1 R$C"
               } else {
                  MOM_output_literal "G68 I0 J0 K1 R$C"
               }
            }
         }
      }

      "heidenhain_iso" {

         MOM_output_literal "G7 L1=1 X5 $X Y5 $Y Z5 $Z A5 $A B5 $B C5 $C"
      }

      "heidenhain_conv" {

         MOM_output_literal "CYCL DEF 19.0"
         MOM_output_literal "CYCL DEF 19.1 A0.0 B0.0 C0.0"
         MOM_output_literal "CYCL DEF 19.0"
         MOM_output_literal "CYCL DEF 19.1"
         MOM_output_literal "CYCL DEF 7.0"
         MOM_output_literal "CYCL DEF 7.1"
         MOM_output_literal "CYCL DEF 7.2"
         MOM_output_literal "CYCL DEF 7.3"
         MOM_output_literal "L Z0.0 F MAX M92"
         MOM_output_literal "L X0.0 Y0.0 F MAX M92"
         MOM_output_literal "CYCL DEF 7.0"
         MOM_output_literal "CYCL DEF 7.1 #1"
         MOM_output_literal "CYCL DEF 7.0"
         MOM_output_literal "CYCL DEF 7.1 X$X"
         MOM_output_literal "CYCL DEF 7.2 Y$Y"
         MOM_output_literal "CYCL DEF 7.3 Z$Z"
         MOM_output_literal "CYCL DEF 19.0"
         MOM_output_literal "CYCL DEF 19.1 A$A B$B C$C"

        # Angles will be stored in Q120/Q121/Q122 for A/B/C respectively.
        # - Next line may need to be adjusted.
        #
         MOM_output_literal "L B+Q121 C+Q122 F MAX"
      }

      "mazatrol" {

        #
        #  This is only valid on an Integrex type B axis.  The A and C axes
        #  cannot be used.
        #
         if { ![EQ_is_equal $A 0.0] || ![EQ_is_equal $C 0.0] } {

           # This situation can be resolved as for Fanuc -
            CATCH_WARNING  "Invalid coordinate system.  Unable to configure G125 blocks."

         } elseif { ![EQ_is_equal $B 0.0] } {

            MOM_output_literal "G125 X$X Y$Y Z$Z B$B R1 S0"
         }
      }

   } ;# controller_type
}


#===============================================================================
proc PB_CMD_set_csys__pre-nx9 { } {
#===============================================================================
#
#  This custom command will output the code needed to cause a
#  coordinate system transformation on the control.  Starting in NX2 a
#  MOM_set_csys event with a coordinate system type and matrix will be
#  output at the start of every tool path where the MCS changes.  If the
#  coordinate system type is CSYS, the coordinate system will be converted
#  into the rotations and translations needed.
#
#  This custom command can be modified to output the code needed for
#  a specific control. In this command, the codes are included for
#  Fanuc, Siemens, Heidenhain and Mazatrol controllers.
#
#  This custom command is used primarily for head/table or head/head
#  five-axis machines.
#
#
#  Import this command to the post. It will be executed automatically in
#  MOM_set_csys event handler.
#
#
#-------------------------------------------------------------------------------
#  Revisions
#*************
# 04-30-09 gsl - Retain current csys type in mom_sys_coordinate_system_status
# 11-03-09 gsl - m5 was m3 in "set sin_a [expr -1*$m5]"
#------
# v850
#------
# 03-13-12 gsl - Cleanup & call ROTSET with tolerant comparison
#              - Pass mom_init_pos to ROTSET instead of mom_pos
#===============================================================================


  #=========================================================================
  # Choose one of controller types -
  #    siemens  fanuc  heidenhain_iso  heidenhain_conv  mazatrol
  #
  #  This custom commands is intended for general cases.  You may find that
  #  you need to make some adjustments to get the desired output.
  #

   set controller_type siemens
  # set controller_type fanuc
  # set controller_type heidenhain_iso
  # set controller_type heidenhain_conv
  # set controller_type mazatrol


   global mom_kin_coordinate_system_type
   global mom_sys_coordinate_system_status


  # When current MCS is not rotated -
   if { [string compare "CSYS" $mom_kin_coordinate_system_type] } {

     # Issue instructions to cancel MCS rotation, if it has been rotated previously.
      if { [info exists mom_sys_coordinate_system_status] && \
          ![string compare "CSYS" $mom_sys_coordinate_system_status] } {

         switch $controller_type {

            "siemens" {
               MOM_output_literal "TRANS X0.0 Y0.0 Z0.0"
               MOM_output_literal "ROT X0.0 Y0.0 Z0.0"
            }

            "fanuc" {
               MOM_output_literal "G69"
            }

            "heidenhain_iso" {
               MOM_output_literal "G7 L1=1 X5 0.0 Y5 0.0 Z5 0.0 A5 0.0 B5 0.0 C5 0.0"
            }

            "heidenhain_conv" {
               MOM_output_literal "CYCL DEF 19.0"
               MOM_output_literal "CYCL DEF 19.1 A0.0 B0.0 C0.0"
               MOM_output_literal "CYCL DEF 19.0"
               MOM_output_literal "CYCL DEF 19.1"
               MOM_output_literal "CYCL DEF 7.0"
               MOM_output_literal "CYCL DEF 7.1"
               MOM_output_literal "CYCL DEF 7.2"
               MOM_output_literal "CYCL DEF 7.3"
            }

            "mazatrol" {
               MOM_output_literal "G69.5"
            }
         }
      }

return
   }


  # Retain current MCS type
   set mom_sys_coordinate_system_status  $mom_kin_coordinate_system_type


  # Local settings for formatting outputs
   set coord_decimals  4
   set rotary_decimals 3


   global mom_csys_matrix
   global RAD2DEG

   set m0 $mom_csys_matrix(0)
   set m1 $mom_csys_matrix(1)
   set m3 $mom_csys_matrix(3)
   set m4 $mom_csys_matrix(4)
   set m5 $mom_csys_matrix(5)
   set m6 $mom_csys_matrix(6)
   set m7 $mom_csys_matrix(7)
   set m8 $mom_csys_matrix(8)

   set cos_b_sq [expr $m0*$m0 + $m3*$m3]

   if { [EQ_is_equal $cos_b_sq 0.0] } {

      set cos_b 0.0
      set cos_c 1.0
      set cos_a $m4
      set sin_c 0.0

      if { $m6 < 0.0 } {

         set sin_b 1.0
         set sin_a $m1

      } else {

         set sin_b -1.0
         set sin_a [expr -1*$m5]
      }

   } else {

      set cos_b [expr sqrt($cos_b_sq)]
      set sin_b [expr -$m6]

      set cos_a [expr $m8/$cos_b]
      set sin_a [expr $m7/$cos_b]

      set cos_c [expr $m0/$cos_b]
      set sin_c [expr $m3/$cos_b]
   }


   set A [expr -atan2($sin_a,$cos_a)*$RAD2DEG]
   set B [expr -atan2($sin_b,$cos_b)*$RAD2DEG]
   set C [expr -atan2($sin_c,$cos_c)*$RAD2DEG]

   if { [EQ_is_lt $A 0.0] } { set A [expr $A + 360.0] }
   if { [EQ_is_lt $B 0.0] } { set B [expr $B + 360.0] }
   if { [EQ_is_lt $C 0.0] } { set C [expr $C + 360.0] }


  # ==> These vars will not need to be formatted, if output via Block templates
   set X [format "%.${coord_decimals}f"  $mom_csys_matrix(9)]
   set Y [format "%.${coord_decimals}f"  $mom_csys_matrix(10)]
   set Z [format "%.${coord_decimals}f"  $mom_csys_matrix(11)]
   set A [format "%.${rotary_decimals}f" $A]
   set B [format "%.${rotary_decimals}f" $B]
   set C [format "%.${rotary_decimals}f" $C]

  #MOM_output_literal "X=$X Y=$Y Z=$Z A=$A  B=$B  C=$C"
  #MOM_output_literal "m0=$m0 m1=$m1 m2=$m2"
  #MOM_output_literal "m3=$m3 m4=$m4 m5=$m5"
  #MOM_output_literal "m6=$m6 m7=$m7 m8=$m8"

   global mom_kin_4th_axis_plane
   global mom_kin_5th_axis_plane
   global mom_kin_4th_axis_direction
   global mom_kin_5th_axis_direction
   global mom_kin_4th_axis_leader
   global mom_kin_5th_axis_leader
   global mom_kin_4th_axis_min_limit 
   global mom_kin_4th_axis_max_limit
   global mom_kin_5th_axis_min_limit 
   global mom_kin_5th_axis_max_limit
   global mom_out_angle_pos
   global mom_prev_out_angle_pos
   global mom_sys_leader
   global mom_warning_info

  # Data from addresses may not be accurate(?)
   if { ![info exists mom_prev_out_angle_pos(0)] } {
      set mom_prev_out_angle_pos(0) [MOM_ask_address_value fourth_axis]
      if { ![string compare "" [string trim $mom_prev_out_angle_pos(0)] ] } {
         set mom_prev_out_angle_pos(0) 0.0
      }
   }

   if { ![info exists mom_prev_out_angle_pos(1)] } {
      set mom_prev_out_angle_pos(1) [MOM_ask_address_value fifth_axis]
      if { ![string compare "" [string trim $mom_prev_out_angle_pos(1)] ] } {
         set mom_prev_out_angle_pos(1) 0.0
      }
   }


  # Compute rotary angles with tolerant comparison
   global mom_init_pos
   set tol_comp 1
   set mom_out_angle_pos(0) [ROTSET $mom_init_pos(3) $mom_prev_out_angle_pos(0) \
                                                     $mom_kin_4th_axis_direction \
                                                     $mom_kin_4th_axis_leader \
                                                      mom_sys_leader(fourth_axis) \
                                                     $mom_kin_4th_axis_min_limit \
                                                     $mom_kin_4th_axis_max_limit $tol_comp]

   set mom_out_angle_pos(1) [ROTSET $mom_init_pos(4) $mom_prev_out_angle_pos(1) \
                                                     $mom_kin_5th_axis_direction \
                                                     $mom_kin_5th_axis_leader \
                                                      mom_sys_leader(fifth_axis) \
                                                     $mom_kin_5th_axis_min_limit \
                                                     $mom_kin_5th_axis_max_limit $tol_comp]

  # Should mom_init_pos be refreshed here?
   set mom_init_pos(3) $mom_out_angle_pos(0)
   set mom_init_pos(4) $mom_out_angle_pos(1)


  # Pre-position rotary axes
   PB_CMD_fourth_axis_rotate_move
   PB_CMD_fifth_axis_rotate_move


   switch $controller_type {

      "siemens" {

         MOM_output_literal "TRANS X$X Y$Y Z$Z"
         set rot ""

         set rot "ROT X$A"
         set rot "$rot ROT Y$B"
         set rot "$rot ROT Z$C"

         MOM_output_literal $rot
      }

      "fanuc" {

         if { ![EQ_is_equal $A 0.0] && ![EQ_is_equal $B 0.0] && ![EQ_is_equal $C 0.0] } {

            set mom_warning_info "Invalid coordinate system.  Unable to determine correct rotations."
            MOM_catch_warning

         } else {

            set a 0
            set b 0

            if { ![EQ_is_equal $A 0.0] } {
               MOM_output_literal "G68 X$X Y$Y Z$Z I1 J0 K0 R$A"
               set a 1
            }

            if { ![EQ_is_equal $B 0.0] } {
               if { $a == 0 } {
                  MOM_output_literal "G68 X$X Y$Y Z$Z I0 J1 K0 R$B"
               } else {
                  MOM_output_literal "G68 I0 J1 K0 R$B"
               }
               set b 1
            }

            if { ![EQ_is_equal $C 0.0] } {
               if { $a == 0 && $b == 0 } {
                  MOM_output_literal "G68 X$X Y$Y Z$Z I0 J0 K1 R$C"
               } else {
                  MOM_output_literal "G68 I0 J0 K1 R$C"
               }
            }
         }
      }

      "heidenhain_iso" {

         MOM_output_literal "G7 L1=1 X5 $X Y5 $Y Z5 $Z A5 $A B5 $B C5 $C"
      }

      "heidenhain_conv" {

         MOM_output_literal "CYCL DEF 19.0"
         MOM_output_literal "CYCL DEF 19.1 A0.0 B0.0 C0.0"
         MOM_output_literal "CYCL DEF 19.0"
         MOM_output_literal "CYCL DEF 19.1"
         MOM_output_literal "CYCL DEF 7.0"
         MOM_output_literal "CYCL DEF 7.1"
         MOM_output_literal "CYCL DEF 7.2"
         MOM_output_literal "CYCL DEF 7.3"
         MOM_output_literal "L Z0.0 F MAX M92"
         MOM_output_literal "L X0.0 Y0.0 F MAX M92"
         MOM_output_literal "CYCL DEF 7.0"
         MOM_output_literal "CYCL DEF 7.1 #1"
         MOM_output_literal "CYCL DEF 7.0"
         MOM_output_literal "CYCL DEF 7.1 X$X"
         MOM_output_literal "CYCL DEF 7.2 Y$Y"
         MOM_output_literal "CYCL DEF 7.3 Z$Z"
         MOM_output_literal "CYCL DEF 19.0"
         MOM_output_literal "CYCL DEF 19.1 A$A B$B C$C"
         MOM_output_literal "L B+Q121 C+Q122 F MAX"
      }

      "mazatrol" {
        #
        #  This is only valid on an Integrex type B axis.  The A and C axes
        #  cannot be used.
        #
         if { ![EQ_is_equal $A 0.0] || ![EQ_is_equal $C 0.0] } {
            global mom_warning_info
            set mom_warning_info "Invalid coordinate system.  Unable to configure G125 blocks."
            MOM_catch_warning
         } elseif { ![EQ_is_equal $B 0.0] } {
            MOM_output_literal "G125 X$X Y$Y Z$Z B$B R1 S0"
         }
      }
   }

}


