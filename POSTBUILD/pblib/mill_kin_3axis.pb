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
tcl_file  mill_3.tcl
## POST EVENT HANDLER END


## KINEMATIC VARIABLES START
"$mom_kin_machine_type"                   "3_axis_mill"
## KINEMATIC VARIABLES END


## MASTER SEQUENCE START
G_feed            "$mom_sys_feed_rate_mode_code($feed_mode)"  1  "Feedrate Mode G-Code"  0
fourth_axis       "$mom_sys_blank_code" 1 "4th Axis Position" 0
fifth_axis        "$mom_sys_blank_code" 1 "5th Axis Position" 0
## MASTER SEQUENCE END

