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

## EVENTS USER INTERFACE START
{Cutcom On} \
     {{"$gPB(event,cutcom_on,g_code)" 1  V} \
        {{"null" 2  V} \
                {"$gPB(event,cutcom_on,left)" 2  a $mom_sys_cutcom_code(LEFT) UI_PB_tpth_EntryCallBack null} \
                {"$gPB(event,cutcom_on,right)" 2  a $mom_sys_cutcom_code(RIGHT) UI_PB_tpth_EntryCallBack null}}} \
     {{"$gPB(event,cutcom_on,reg)" 1  V} \
        {{"null" 2  V} \
                {"$gPB(event,cutcom_on,max)" 0  i $rad_offset_max null null} \
                {"$gPB(event,cutcom_on,min)" 0  i $rad_offset_min null null}}} \
     {{"$gPB(event,cutcom_on,bef)" 1  V} \
        {{"null" 2  H} \
                {"$gPB(isv,setup,dog_leg,yes)" 4  n $cutcom_off_before_change null {"YES"}} \
                {"$gPB(isv,setup,dog_leg,no)" 4  n $cutcom_off_before_change null {"NO"}}}}
{Circular Move} \
     {{"$gPB(event,circular,g_code)" 1  V} \
        {{"null" 2  V} \
                {"$gPB(event,circular,clockwise)" 2  a $mom_sys_circle_code(CLW) UI_PB_tpth_EntryCallBack null} \
                {"$gPB(event,circular,counter-clock)" 2  a $mom_sys_circle_code(CCLW) UI_PB_tpth_EntryCallBack null}}} \
     {{"$gPB(event,circular,record)" 1  V} \
        {{"null" 2  H} \
                {"$gPB(event,circular,full_circle)" 4  n $mom_kin_arc_output_mode null {"FULL_CIRCLE"}} \
                {"$gPB(event,circular,quadrant)" 4  n $mom_kin_arc_output_mode null {"QUADRANT"}}}} \
     {{"$gPB(event,circular,radius)" 1  V} \
        {{"null" 2  V} \
                {"$gPB(event,circular,max)" 2  f $mom_kin_max_arc_radius null null} \
                {"$gPB(event,circular,min)" 2  f $mom_kin_min_arc_radius null null}}} \
     {{"$gPB(event,circular,ij_def)" 1  V} \
        {{"null" 1  V} \
                {"null" 10  n $mom_sys_cir_vector UI_PB_tpth_IJKParameters {"Vector - Arc Start to Center" "Vector - Arc Center to Start" "Unsigned Vector - Arc Start to Center" "Vector - Absolute Arc Center"}}}} \
     {{"null" 1  V} \
        {{"null" 1  V} \
                {"$gPB(event,circular,arc_len)" 2  f $mom_kin_min_arc_length null null}}}
## EVENTS USER INTERFACE END

