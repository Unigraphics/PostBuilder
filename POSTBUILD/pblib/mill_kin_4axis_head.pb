## POSTBUILDER_VERSION=2000.0.2.1
#########################################################################
#                                                                       #
#  This is the POST UI FILE used to read and write the parameters       #
#  associated with a specific post processor.                           #
#                                                                       #
#  WARNING: The Syntax of the file should not be changed!!!             #
#                                                                       #
#########################################################################


## POST EVENT HANDLER START
tcl_file  mill_5.tcl
## POST EVENT HANDLER END


## KINEMATIC VARIABLES START
"$mom_kin_machine_type"                   "4_axis_head"
"$mom_kin_4th_axis_type"                  "Head"
"$mom_kin_4th_axis_leader"                "B"
"$mom_kin_4th_axis_plane"                 "ZX"
"$mom_kin_4th_axis_ang_offset"            "0.0"
"$mom_kin_4th_axis_center_offset(0)"      "0.0"
"$mom_kin_4th_axis_center_offset(1)"      "0.0"
"$mom_kin_4th_axis_center_offset(2)"      "0.0"
"$mom_kin_4th_axis_direction"             "MAGNITUDE_DETERMINES_DIRECTION"
"$mom_kin_4th_axis_limit_action"          "Warning"
"$mom_kin_4th_axis_max_limit"             "360"
"$mom_kin_4th_axis_min_incr"              "0.001"
"$mom_kin_4th_axis_min_limit"             "0"
"$mom_kin_4th_axis_rotation"              "standard"
"$mom_kin_4th_axis_zero"                  "0.0"
"$mom_kin_linearization_flag"             "1"
"$mom_kin_linearization_tol"              "0.001"
## KINEMATIC VARIABLES END

## MASTER SEQUENCE START
G_feed            "$mom_sys_feed_rate_mode_code($feed_mode)"  0  "Feedrate Mode G-Code"  0
fourth_axis       "$mom_sys_blank_code" 0 "4th Axis Position"  0
fifth_axis        "$mom_sys_blank_code" 1 "5th Axis Position"  0
## MASTER SEQUENCE END

## MOM SYS VARIABLES START
{G_feed} \
      {"$mom_sys_feed_rate_mode_code(DPM)" "94" "DPM Feed Rate Mode"}
{fourth_axis} \
      {"$mom_out_angle_pos(0)" "" "4th Axis Angle"}
{PB_Dummy} \
      {"$4th_axis_direction" "Magnitude_Determines_Direction" ""}
{PB_Tcl_Var} \
      {"$mom_sys_leader(fourth_axis)" "B" ""} \
      {"$mom_sys_contour_feed_mode(LINEAR)" "IPM" ""} \
      {"$mom_sys_contour_feed_mode(ROTARY)" "IPM" ""} \
      {"$mom_sys_contour_feed_mode(LINEAR_ROTARY)" "IPM" ""} \
      {"$mom_sys_feed_param(DPM,format)" "Feed_DPM" ""}
## MOM SYS VARIABLES END

