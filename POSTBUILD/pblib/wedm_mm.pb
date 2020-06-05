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
def_file  wedm_mm.def
## POST EVENT HANDLER END


## KINEMATIC VARIABLES START
"$mom_kin_linearization_tol"              "0.01"
"$mom_kin_machine_resolution"             ".001"
"$mom_kin_max_arc_radius"                 "99999.999"
"$mom_kin_min_arc_radius"                 "0.001"
"$mom_kin_min_arc_length"                 "0.001"
"$mom_kin_max_fpm"                        "10000"
"$mom_kin_min_fpm"                        "0.01"
"$mom_kin_rapid_feed_rate"                "10000"
"$mom_kin_output_unit"                    "MM"
"$mom_kin_post_data_unit"                 "MM"
"$mom_kin_rapid_feed_rate"                "15000"
"$mom_kin_x_axis_limit"                   "1000"
"$mom_kin_y_axis_limit"                   "1000"
"$mom_kin_z_axis_limit"                   "1000"
## KINEMATIC VARIABLES END

## EVENTS USER INTERFACE START
{Feedrates} \
     {{"$gPB(event,feedrates,mmpm_mode)" 3  V} \
        {{"$gPB(event,feedrates,format)" 1  V} \
                {"null" 9  n $mom_sys_feed_param(MMPM,format) UI_PB_tpth_EditFeedFmt null}} \
        {{"null" 1  V} \
                {"$gPB(event,feedrates,max)" 2  f $mom_kin_max_fpm null null}} \
        {{"null" 1  V} \
                {"$gPB(event,feedrates,min)" 2  f $mom_kin_min_fpm null null}}}
## EVENTS USER INTERFACE END

## MOM SYS VARIABLES START
{PB_Tcl_Var} \
      {"$mom_sys_contour_feed_mode(LINEAR)" "MMPM" ""} \
      {"$mom_sys_rapid_feed_mode(LINEAR)" "MMPM" ""} \
      {"$mom_sys_feed_param(MMPM,format)" "Feed_MMPM" ""} \
      {"$mom_sys_feed_param(MMPR,format)" "Feed_MMPR" ""} \
      {"$mom_sys_feed_param(FRN,format)" "Feed_INV" ""} \
      {"$mom_sys_cycle_feed_mode" "MMPM" ""}
## MOM SYS VARIABLES END

