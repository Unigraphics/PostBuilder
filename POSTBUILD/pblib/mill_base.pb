#########################################################################
#                                                                       #
#  WARNING: The Syntax of the file should not be changed!!!             #
#                                                                       #
#########################################################################

## EVENTS USER INTERFACE START
{Cycle Parameters} \
     {{"G Code & Customization" 2  H} \
        {{"null" 14 V} \
                {"" 7  n null null null} \
                {"" 7  n null null null} \
                {"$gPB(event,cycle,customize,Label)" 3  n $mom_sys_sim_cycle_drill              null null "event,cycle,customize"} \
                {"$gPB(event,cycle,customize,Label)" 3  n $mom_sys_sim_cycle_drill_dwell        null null "event,cycle,customize"} \
                {"$gPB(event,cycle,customize,Label)" 3  n $mom_sys_sim_cycle_drill_deep         null null "event,cycle,customize"} \
                {"$gPB(event,cycle,customize,Label)" 3  n $mom_sys_sim_cycle_drill_break_chip   null null "event,cycle,customize"} \
                {"$gPB(event,cycle,customize,Label)" 3  n $mom_sys_sim_cycle_tap                null null "event,cycle,customize"} \
                {"$gPB(event,cycle,customize,Label)" 3  n $mom_sys_sim_cycle_bore               null null "event,cycle,customize"} \
                {"$gPB(event,cycle,customize,Label)" 3  n $mom_sys_sim_cycle_bore_drag          null null "event,cycle,customize"} \
                {"$gPB(event,cycle,customize,Label)" 3  n $mom_sys_sim_cycle_bore_nodrag        null null "event,cycle,customize"} \
                {"$gPB(event,cycle,customize,Label)" 3  n $mom_sys_sim_cycle_bore_manual        null null "event,cycle,customize"} \
                {"$gPB(event,cycle,customize,Label)" 3  n $mom_sys_sim_cycle_bore_dwell         null null "event,cycle,customize"} \
                {"$gPB(event,cycle,customize,Label)" 3  n $mom_sys_sim_cycle_bore_back          null null "event,cycle,customize"} \
                {"$gPB(event,cycle,customize,Label)" 3  n $mom_sys_sim_cycle_bore_manual_dwell  null null "event,cycle,customize"}} \
        {{"null" 14 V} \
                {"Cycle Start" 2  a $mom_sys_cycle_start_code UI_PB_tpth_EntryCallBack null} \
                {"Cycle Off" 2  a $mom_sys_cycle_off UI_PB_tpth_EntryCallBack null} \
                {"Drill" 2  a $mom_sys_cycle_drill_code UI_PB_tpth_EntryCallBack null} \
                {"Drill Dwell (SpotFace)" 2  a $mom_sys_cycle_drill_dwell_code UI_PB_tpth_EntryCallBack null} \
                {"Drill Deep (Peck)" 2  a $mom_sys_cycle_drill_deep_code UI_PB_tpth_EntryCallBack null} \
                {"Drill Break Chip" 2  a $mom_sys_cycle_drill_break_chip_code UI_PB_tpth_EntryCallBack null} \
                {"Tap" 2  a $mom_sys_cycle_tap_code UI_PB_tpth_EntryCallBack null} \
                {"Bore (Ream)" 2  a $mom_sys_cycle_bore_code UI_PB_tpth_EntryCallBack null} \
                {"Bore Drag" 2  a $mom_sys_cycle_bore_drag_code UI_PB_tpth_EntryCallBack null} \
                {"Bore No-Drag" 2  a $mom_sys_cycle_bore_no_drag_code UI_PB_tpth_EntryCallBack null} \
                {"Bore Manual" 2  a $mom_sys_cycle_bore_manual_code UI_PB_tpth_EntryCallBack null} \
                {"Bore Dwell" 2  a $mom_sys_cycle_bore_dwell_code UI_PB_tpth_EntryCallBack null} \
                {"Bore Back" 2  a $mom_sys_cycle_bore_back_code UI_PB_tpth_EntryCallBack null} \
                {"Bore Manual Dwell" 2  a $mom_sys_cycle_bore_manual_dwell_code UI_PB_tpth_EntryCallBack null}}} \
     {{"null" 4  V} \
        {{"Cycle Start" 2  H} \
                {"G79 X Y Z" 3  n $cycle_start_blk UI_PB_tpth_CycleStartBlks null "event,cycle,start"} \
                {"Use Cycle Start Block To Execute Cycle" 7  n null null null}} \
        {{"Rapid - To" 1  V} \
                {"null" 8  n $cycle_rapto_opt UI_PB_tpth_CycleRapidBlks {"None" "R" "Rapid Traverse & R" "Rapid"}}} \
        {{"Retract - To" 1  V} \
                {"null" 8  n $cycle_recto_opt UI_PB_tpth_CycleRetractBlks {"None" "K" "G98/G99" "Rapid Spindle" "Cycle Off then Rapid Spindle"}}} \
        {{"Cycle Plane Control" 1  V} \
                {"null" 8  n $cycle_plane_control_opt UI_PB_tpth_CyclePlaneElem {"None" "G17/G18/G19"}}}}
{Circular Move} \
     {{"Motion G Code" 1  V} \
        {{"null" 2  V} \
                {"Clockwise (CLW)" 2  a $mom_sys_circle_code(CLW) UI_PB_tpth_EntryCallBack null} \
                {"Counter-Clockwise (CCLW)" 2  a $mom_sys_circle_code(CCLW) UI_PB_tpth_EntryCallBack null}}} \
     {{"Applicable Planes" 2  V} \
        {{"null" 4  H} \
                {"XY" 4  n $mom_kin_arc_valid_plane null null} \
                {"YZ" 4  n $mom_kin_arc_valid_plane null null} \
                {"ZX" 4  n $mom_kin_arc_valid_plane null null} \
                {"XYZ" 4  n $mom_kin_arc_valid_plane null null}} \
        {{"null" 1  V} \
                {"Edit Plane Codes" 1  n null UI_PB_tpth_EditPlaneCodes null}}} \
     {{"Circular Record" 1  V} \
        {{"null" 2  H} \
                {"Full Circle" 4  n $mom_kin_arc_output_mode null null} \
                {"Quadrant" 4  n $mom_kin_arc_output_mode null null}}} \
     {{"Radius" 1  V} \
        {{"null" 2  V} \
                {"Minimum" 2  f $mom_kin_min_arc_radius null null} \
                {"Maximum" 2  f $mom_kin_max_arc_radius null null}}} \
     {{"IJK Definition" 1  V} \
        {{"null" 1  V} \
                {"null" 10  n $mom_sys_cir_vector UI_PB_tpth_IJKParameters {"Vector - Arc Start to Center" "Vector - Arc Center to Start" "Unsigned Vector - Arc Start to Center" "Vector - Absolute Arc Center"}}}} \
     {{"null" 1  V} \
        {{"null" 1  V} \
                {"Minimum Arc Length" 2  f $mom_kin_min_arc_length null null}}}
{Tool Change} \
     {{"$gPB(event,tool_change,m_code)" 1  V} \
        {{"null" 1  V} \
                {"$gPB(event,tool_change,m_code,tl_chng)" 2  a $mom_sys_tool_change_code UI_PB_tpth_EntryCallBack null}}} \
     {{"$gPB(event,tool_change,t_code)" 1  V} \
        {{"null" 1  V} \
                {"$gPB(event,tool_change,t_code,conf)" 1  n null UI_PB_tpth_ConfToolCode null}}} \
     {{"$gPB(event,tool_change,tool_num)" 1  V} \
        {{"null" 2  V} \
                {"$gPB(event,tool_change,tool_num,min)" 0  i $tl_num_min null null} \
                {"$gPB(event,tool_change,tool_num,max)" 0  i $tl_num_max null null}}} \
     {{"$gPB(event,tool_change,time)" 1  V} \
        {{"null" 1  V} \
                {"$gPB(event,tool_change,time,tl_chng)" 2  f $mom_kin_tool_change_time null null}}} \
     {{"$gPB(event,tool_change,retract)" 1  V} \
        {{"null" 2  H} \
                {"$gPB(event,tool_change,retract_z)" 3  n $tl_retract_status null null} \
                {"null" 2  f $tl_retract_z_pos null null}}}
## EVENTS USER INTERFACE END

