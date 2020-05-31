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
def_file  wedm_in.def
## POST EVENT HANDLER END


## KINEMATIC VARIABLES START
"$mom_kin_linearization_tol"              "0.001"
"$mom_kin_machine_resolution"             ".0001"
"$mom_kin_max_arc_radius"                 "9999.9999"
"$mom_kin_min_arc_radius"                 "0.0001"
"$mom_kin_min_arc_length"                 "0.0001"
"$mom_kin_max_fpm"                        "400"
"$mom_kin_min_fpm"                        "0.1"
"$mom_kin_output_unit"                    "IN"
"$mom_kin_post_data_unit"                 "IN"
"$mom_kin_rapid_feed_rate"                "600"
"$mom_kin_x_axis_limit"                   "50"
"$mom_kin_y_axis_limit"                   "50"
## KINEMATIC VARIABLES END

## GCODES START
## GCODES END

## EVENTS USER INTERFACE START
{Feedrates} \
     {{"$gPB(event,feedrates,ipm_mode)" 3  V} \
        {{"$gPB(event,feedrates,format)" 1  V} \
                {"null" 9  n $mom_sys_feed_param(IPM,format) UI_PB_tpth_EditFeedFmt null}} \
        {{"null" 1  V} \
                {"$gPB(event,feedrates,max)" 2  f $mom_kin_max_fpm null null}} \
        {{"null" 1  V} \
                {"$gPB(event,feedrates,min)" 2  f $mom_kin_min_fpm null null}}}
## EVENTS USER INTERFACE END

## MOM SYS VARIABLES START
{PB_Tcl_Var} \
      {"$mom_sys_contour_feed_mode(LINEAR)" "IPM" ""} \
      {"$mom_sys_rapid_feed_mode(LINEAR)" "IPM" ""} \
      {"$mom_sys_feed_param(IPM,format)" "Feed_IPM" ""} \
      {"$mom_sys_feed_param(IPR,format)" "Feed_IPR" ""} \
      {"$mom_sys_feed_param(FRN,format)" "Feed_INV" ""} \
      {"$mom_sys_cycle_feed_mode" "IPM" ""}
## MOM SYS VARIABLES END

