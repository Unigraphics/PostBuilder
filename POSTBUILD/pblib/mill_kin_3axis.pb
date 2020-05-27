## POSTBUILDER_VERSION=2000.0.2.1
#########################################################################
#                                                                       #
#  This is the POST UI FILE used to read and write the parameters       #
#  associated with a specific post processor.                           #
#                                                                       #
#  WARNING: The Syntax of the file should not be changed!!!             #
#                                                                       #
#########################################################################

## KINEMATIC VARIABLES START
"$mom_kin_machine_type"                   "3_axis_mill"
## KINEMATIC VARIABLES END


## MASTER SEQUENCE START
fourth_axis       "$mom_sys_blank_code" 1 "4th Axis Position" 0
fifth_axis        "$mom_sys_blank_code" 1 "5th Axis Position" 0
## MASTER SEQUENCE END

