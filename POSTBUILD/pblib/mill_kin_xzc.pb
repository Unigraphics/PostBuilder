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
tcl_file  mill_kin_xzc.tcl
## POST EVENT HANDLER END


## KINEMATIC VARIABLES START
"$mom_kin_machine_type"                   "3_axis_mill"
"$mom_kin_4th_axis_ang_offset"            "0.0"
"$mom_kin_4th_axis_center_offset(0)"      "0.0"
"$mom_kin_4th_axis_center_offset(1)"      "0.0"
"$mom_kin_4th_axis_center_offset(2)"      "0.0"
"$mom_kin_4th_axis_direction"             "MAGNITUDE_DETERMINES_DIRECTION"
"$mom_kin_4th_axis_leader"                "C"
"$mom_kin_4th_axis_limit_action"          "Warning"
"$mom_kin_4th_axis_max_limit"             "360"
"$mom_kin_4th_axis_min_incr"              "0.001"
"$mom_kin_4th_axis_min_limit"             "0"
"$mom_kin_4th_axis_plane"                 "YZ"
"$mom_kin_4th_axis_rotation"              "standard"
"$mom_kin_4th_axis_type"                  "Table"
"$mom_kin_4th_axis_zero"                  "0.0"
## KINEMATIC VARIABLES END

## MASTER SEQUENCE START
fourth_axis       "$mom_sys_blank_code" 0 "4th Axis Position" 0
fifth_axis        "$mom_sys_blank_code" 1 "5th Axis Position" 0
## MASTER SEQUENCE END

