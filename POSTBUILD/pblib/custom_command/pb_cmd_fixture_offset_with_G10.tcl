##############################################################################
#                                                                            #
# Copyright (c) 1999/2000/2001/2002/2003/2004, Unigraphics Solutions Inc.    #
#                                                                            #
##############################################################################

#=============================================================
proc PB_CMD_set_csys { } {
#=============================================================
#
#  Fixture Offset with G10
#
#  This custom command will be executed automatically in
#  MOM_set_csys evet handler!
#
#  This custom command will determine the correct information for
#  the G10 work coordinate system definition.  A G10 block will
#  be output every time the MCS changes.
#
#  You must define a main MCS in the Geometry view.
#
#  You may need to customize the MCS dialog.  If so, add the option
#  for Coordinate System Purpose and Special Output to the MCS dialog.
#  Set Coordinate System Purpose to MAIN for the main MCS and LOCAL
#  for the local MCS.  The Special Output should be set to FIXTURE
#  OFFSET.
#
#  For four axis machines the coordinates systems must meet the following
#  critera.
#
#  For rotary axis tables in the YZ plane the X axis of the local
#  MCS must be parallel (not reversed) with the X axis of the main MCS
#
#  For rotary axis tables in the ZX plane the Y axis of the local
#  MCS must be parallel (not reversed) with the Y axis of the main MCS
#
#  For rotary axis tables in the XY plane the Z axis of the local
#  MCS must be parallel (not reversed) with the Z axis of the main MCS
#  
#  For three axis mills the X, Y and Z axis of the local MCS must be
#  parallel with X, Y and Z axis of the main MCS.
#
#  Five axis mills, XZC mills and lathes are not supported with this
#  function.
#

  global mom_kin_coordinate_system_type

  if {$mom_kin_coordinate_system_type != "LOCAL"} {
return
  }

  global mom_csys_matrix
  global RAD2DEG
  global mom_kin_machine_type
  global mom_fixture_offset_value
  global mom_kin_4th_axis_plane
  global mom_warning_info
  global mom_sys_leader

  set m0 $mom_csys_matrix(0)
  set m1 $mom_csys_matrix(1)
  set m2 $mom_csys_matrix(2)
  set m4 $mom_csys_matrix(4)
  set m7 $mom_csys_matrix(7)
  set m8 $mom_csys_matrix(8)

  set X [format "%.4f" $mom_csys_matrix(9)]
  set Y [format "%.4f" $mom_csys_matrix(10)]
  set Z [format "%.4f" $mom_csys_matrix(11)]

  if {$mom_kin_machine_type == "3_axis_mill"} {
    if {![EQ_is_equal $m0 1.0] || ![EQ_is_equal $m4 1.0] || ![EQ_is_equal $m8 1.0] } {
      set mom_warning_info "No rotation allowed for three axis mill fixture offset"
      MOM_catch_warning
return
    } else {
      MOM_output_literal "G10 L2 P$mom_fixture_offset_value X$X Y$Y Z$Z"
    }
  } elseif {[EQ_is_equal $m0 1.0] && $mom_kin_4th_axis_plane == "YZ"} {
     set A [expr atan2($m7,$m8)*$RAD2DEG]
     if {[EQ_is_lt $A 0.0]} {set A [expr $A+360.0]}
     set A [format "%.3f" $A]
     MOM_output_literal "G10 L2 P$mom_fixture_offset_value X$X Y$Y Z$Z $mom_sys_leader(fourth_axis)$A"
  } elseif {[EQ_is_equal $m4 1.0] && $mom_kin_4th_axis_plane == "ZX"} {
     set B [expr atan2($m2,$m0)*$RAD2DEG]
     if {[EQ_is_lt $B 0.0]} {set B [expr $B+360.0]}
     set B [format "%.3f" $B]
     MOM_output_literal "G10 L2 P$mom_fixture_offset_value X$X Y$Y Z$Z $mom_sys_leader(fourth_axis)$B"
  } elseif {[EQ_is_equal $m8 1.0] && $mom_kin_4th_axis_plane == "XY"} {
     set C [expr atan2($m1,$m0)*$RAD2DEG]
     if {[EQ_is_lt $C 0.0]} {set C [expr $C+360.0]}
     set C [format "%.3f" $B]
     MOM_output_literal "G10 L2 P$mom_fixture_offset_value X$X Y$Y Z$Z $mom_sys_leader(fourth_axis)$C"
  } else {
    set mom_warning_info "Invalid rotation for fixture offset"
    MOM_catch_warning
return
  }
  MOM_output_literal "G[expr 53+$mom_fixture_offset_value]"
}

