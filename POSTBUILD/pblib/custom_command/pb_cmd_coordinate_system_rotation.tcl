################################################################################
#                                                                              #
#  Copyright (c) 1999/2000/2001/2002/2003/2004, Unigraphics Solutions Inc.     #
#                                                                              #
################################################################################

#===============================================================================
proc PB_CMD_set_csys { } {
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


  #+++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
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


