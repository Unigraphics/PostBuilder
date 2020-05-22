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
## POST EVENT HANDLER END


## KINEMATIC VARIABLES START
"$mom_kin_machine_type"                   "2_axis_wedm"
## KINEMATIC VARIABLES END

## MASTER SEQUENCE START
fourth_axis                 "$mom_sys_blank_code"  1  "Upper Wire Guide Position"  0
fifth_axis                  "$mom_sys_blank_code"  1  "Upper Wire Guide Position"  0
## MASTER SEQUENCE END

## MOM SYS VARIABLES START
{PB_Dummy} \
      {"$4th_axis_direction" "Magnitude_Determines_Direction" ""}
{PB_Tcl_Var} \
      {"$mom_sys_contour_feed_mode(LINEAR)" "IPM" ""} \
      {"$mom_sys_contour_feed_mode(ROTARY)" "IPM" ""} \
      {"$mom_sys_contour_feed_mode(LINEAR_ROTARY)" "IPM" ""} \
      {"$mom_sys_feed_param(DPM,format)" "Feed_DPM" ""}
## MOM SYS VARIABLES END

