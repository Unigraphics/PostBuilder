## POSTBUILDER_VERSION=2000.0.2.1
#########################################################################
#                                                                       #
#  This is the POST UI FILE used to read and write the parameters       #
#  associated with a specific post processor.                           #
#                                                                       #
#  WARNING: The Syntax of the file should not be changed!!!             #
#                                                                       #
#########################################################################
#======
# V800
#======
# 12-Jan-2011 wbh - 6317125 Add MMPR option to Feedrates UI page


## POST EVENT HANDLER START
def_file  siemens_5_mm.def
## POST EVENT HANDLER END


## KINEMATIC VARIABLES START
"$mom_kin_linearization_tol"              "0.01"
"$mom_kin_machine_resolution"             "0.001"
"$mom_kin_max_arc_radius"                 "99999.999"
"$mom_kin_min_arc_radius"                 "0.001"
"$mom_kin_min_arc_length"                 "0.20"
"$mom_kin_max_fpm"                        "15000"
"$mom_kin_max_fpr"                        "1000"
"$mom_kin_max_frn"                        "1000"
"$mom_kin_min_fpm"                        "0.1"
"$mom_kin_min_fpr"                        "0.1"
"$mom_kin_min_frn"                        "0.01"
"$mom_kin_rapid_feed_rate"                "10000"
"$mom_kin_output_unit"                    "MM"
"$mom_kin_post_data_unit"                 "MM"
"$mom_kin_retract_distance"               "500"
"$mom_kin_x_axis_limit"                   "1000"
"$mom_kin_y_axis_limit"                   "1000"
"$mom_kin_z_axis_limit"                   "1000"
## KINEMATIC VARIABLES END

## GCODES START
"$mom_sys_feed_rate_mode_code(MMPM)"      "$gPB(g_code,feedmode_mm,pm)"
"$mom_sys_feed_rate_mode_code(MMPR)"      "$gPB(g_code,feedmode_mm,pr)"
## GCODES END

## EVENTS USER INTERFACE START
{Feedrates} \
     {{"$gPB(event,feedrates,mmpm_mode)" 4  V} \
        {{"null" 1  V} \
                {"$gPB(event,feedrates,g_code)" 2  a $mom_sys_feed_rate_mode_code(MMPM) UI_PB_tpth_EntryCallBack null}} \
        {{"$gPB(event,feedrates,format)" 1  V} \
                {"null" 9  n $mom_sys_feed_param(MMPM,format) UI_PB_tpth_EditFeedFmt null}} \
        {{"null" 1  V} \
                {"$gPB(event,feedrates,max)" 2  f $mom_kin_max_fpm null null}} \
        {{"null" 1  V} \
                {"$gPB(event,feedrates,min)" 2  f $mom_kin_min_fpm null null}}} \
     {{"$gPB(event,feedrates,mmpr_mode)" 4  V} \
        {{"null" 1  V} \
                {"$gPB(event,feedrates,g_code)" 2  a $mom_sys_feed_rate_mode_code(MMPR) UI_PB_tpth_EntryCallBack null}} \
        {{"$gPB(event,feedrates,format)" 1  V} \
                {"null" 9  n $mom_sys_feed_param(MMPR,format) UI_PB_tpth_EditFeedFmt null}} \
        {{"null" 1  V} \
                {"$gPB(event,feedrates,max)" 2  f $mom_kin_max_fpr null null}} \
        {{"null" 1  V} \
                {"$gPB(event,feedrates,min)" 2  f $mom_kin_min_fpr null null}}} \
     {{"$gPB(event,feedrates,frn_mode)" 4  V} \
        {{"null" 1  V} \
                {"$gPB(event,feedrates,g_code)" 2  a $mom_sys_feed_rate_mode_code(FRN) UI_PB_tpth_EntryCallBack null}} \
        {{"$gPB(event,feedrates,format)" 1  V} \
                {"null" 9  n $mom_sys_feed_param(FRN,format) UI_PB_tpth_EditFeedFmt null}} \
        {{"null" 1  V} \
                {"$gPB(event,feedrates,max)" 2  f $mom_kin_max_frn null null}} \
        {{"null" 1  V} \
                {"$gPB(event,feedrates,min)" 2  f $mom_kin_min_frn null null}}} \
     {{"$gPB(event,feedrates,dpm_mode)" 4  V} \
        {{"null" 1  V} \
                {"$gPB(event,feedrates,g_code)" 2  a $mom_sys_feed_rate_mode_code(DPM) UI_PB_tpth_EntryCallBack null}} \
        {{"$gPB(event,feedrates,format)" 1  V} \
                {"null" 9  n $mom_sys_feed_param(DPM,format) UI_PB_tpth_EditFeedFmt null}} \
        {{"null" 1  V} \
                {"$gPB(event,feedrates,max)" 2  f $mom_kin_max_dpm null null}} \
        {{"null" 1  V} \
                {"$gPB(event,feedrates,min)" 2  f $mom_kin_min_dpm null null}}} \
     {{"$gPB(event,feedrates,mode,label)" 7  V} \
        {{"null" 1  V} \
                {"$gPB(event,feedrates,mode,lin)" 8  n $mom_sys_contour_feed_mode(LINEAR) null {"MMPM" "MMPR" "FRN"}}} \
        {{"null" 1  V} \
                {"$gPB(event,feedrates,mode,rot)" 8  n $mom_sys_contour_feed_mode(ROTARY) null {"MMPM" "MMPR" "FRN" "DPM"}}} \
        {{"null" 1  V} \
                {"$gPB(event,feedrates,mode,lin_rot)" 8  n $mom_sys_contour_feed_mode(LINEAR_ROTARY) null {"MMPM" "MMPR" "FRN" "DPM"}}} \
        {{"null" 1  V} \
                {"$gPB(event,feedrates,mode,rap_lin)" 8  n $mom_sys_rapid_feed_mode(LINEAR) null {"MMPM" "MMPR" "FRN"}}} \
        {{"null" 1  V} \
                {"$gPB(event,feedrates,mode,rap_rot)" 8  n $mom_sys_rapid_feed_mode(ROTARY) null {"MMPM" "MMPR" "FRN" "DPM"}}} \
        {{"null" 1  V} \
                {"$gPB(event,feedrates,mode,rap_lin_rot)" 8  n $mom_sys_rapid_feed_mode(LINEAR_ROTARY) null {"MMPM" "MMPR" "FRN"}}} \
        {{"null" 1  V} \
                {"$gPB(event,feedrates,cycle)" 8  n $mom_sys_cycle_feed_mode null {"MMPM" "MMPR" "Auto"}}}}
## EVENTS USER INTERFACE END

## MOM SYS VARIABLES START
{G_feed} \
      {"$mom_sys_feed_rate_mode_code($feed_mode)" "$mom_sys_feed_rate_mode_code(MMPM)" "Feed Rate Mode"} \
      {"$mom_sys_feed_rate_mode_code(MMPM)" "94" "MMPM Feed Rate Mode"} \
      {"$mom_sys_feed_rate_mode_code(MMPR)" "95" "MMPR Feed Rate Mode"} \
      {"$mom_sys_feed_rate_mode_code(FRN)" "93" "FRN Feed Rate Mode"} \
      {"$mom_sys_feed_rate_mode_code(DPM)" "94" "DPM Feed Rate Mode"}
{PB_Tcl_Var} \
      {"$mom_sys_contour_feed_mode(LINEAR)" "MMPM" ""} \
      {"$mom_sys_contour_feed_mode(ROTARY)" "MMPM" ""} \
      {"$mom_sys_contour_feed_mode(LINEAR_ROTARY)" "MMPM" ""} \
      {"$mom_sys_rapid_feed_mode(LINEAR)" "MMPM" ""} \
      {"$mom_sys_rapid_feed_mode(ROTARY)" "MMPM" ""} \
      {"$mom_sys_rapid_feed_mode(LINEAR_ROTARY)" "MMPM" ""} \
      {"$mom_sys_feed_param(MMPM,format)" "Feed_MMPM" ""} \
      {"$mom_sys_feed_param(MMPR,format)" "Feed_MMPR" ""} \
      {"$mom_sys_feed_param(FRN,format)" "Feed_INV" ""} \
      {"$mom_sys_feed_param(DPM,format)" "Feed_DPM" ""} \
      {"$mom_sys_cycle_feed_mode" "MMPM" ""}
## MOM SYS VARIABLES END