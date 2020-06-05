##############################################################################
#                                                                            #
#       WARNING: The Syntax of the file should not be changed!!!             #
#                                                                            #
##############################################################################


## POST EVENT HANDLER START
tcl_file  mill_3.tcl
## POST EVENT HANDLER END


## KINEMATIC VARIABLES START
"$mom_kin_machine_type"                     "lathe"
"$mom_kin_arc_valid_plane"                  "XY"
## KINEMATIC VARIABLES END


## EVENTS USER INTERFACE START
{Delay} \
     {{"$gPB(event,delay,seconds)" 2  V} \
        {{"null" 1  V} \
                {"$gPB(event,delay,seconds,g_code)" 2  a $mom_sys_delay_code(SECONDS) UI_PB_tpth_EntryCallBack null}} \
        {{"$gPB(event,delay,seconds,format)" 1  V} \
                {"null" 9  n $mom_sys_delay_param(SECONDS,format) UI_PB_tpth_EditFeedFmt null}}} \
     {{"$gPB(event,delay,revolution)" 2  V} \
        {{"null" 1  V} \
                {"$gPB(event,delay,revolution,g_code)" 2  a $mom_sys_delay_code(REVOLUTIONS) UI_PB_tpth_EntryCallBack null}} \
        {{"$gPB(event,delay,revolution,format)" 1  V} \
                {"null" 9  n $mom_sys_delay_param(REVOLUTIONS,format) UI_PB_tpth_EditFeedFmt null}}}

{Cycle Parameters} \
     {{"$gPB(event,cycle,g_code)" 2 H} \
        {{"null" 8 V} \
                {"" 7  n null null null} \
                {"" 7  n null null null} \
                {"$gPB(event,cycle,customize,Label)" 3  n $mom_sys_sim_cycle_drill              null null "event,cycle,customize"} \
                {"$gPB(event,cycle,customize,Label)" 3  n $mom_sys_sim_cycle_drill_dwell        null null "event,cycle,customize"} \
                {"$gPB(event,cycle,customize,Label)" 3  n $mom_sys_sim_cycle_drill_deep         null null "event,cycle,customize"} \
                {"$gPB(event,cycle,customize,Label)" 3  n $mom_sys_sim_cycle_drill_break_chip   null null "event,cycle,customize"} \
                {"$gPB(event,cycle,customize,Label)" 3  n $mom_sys_sim_cycle_tap                null null "event,cycle,customize"} \
                {"$gPB(event,cycle,customize,Label)" 3  n $mom_sys_sim_cycle_bore               null null "event,cycle,customize"}} \
        {{"null" 8 V} \
                {"$gPB(event,cycle,start,Label)" 2  a $mom_sys_cycle_start_code UI_PB_tpth_EntryCallBack null} \
                {"$gPB(event,cycle,cycle_off,name)" 2  a $mom_sys_cycle_off UI_PB_tpth_EntryCallBack null} \
                {"$gPB(event,cycle,drill,name)" 2  a $mom_sys_cycle_drill_code UI_PB_tpth_EntryCallBack null} \
                {"$gPB(event,cycle,drill_dwell_sf,name)" 2  a $mom_sys_cycle_drill_dwell_code UI_PB_tpth_EntryCallBack null} \
                {"$gPB(event,cycle,drill_deep_peck,name)" 2  a $mom_sys_cycle_drill_deep_code UI_PB_tpth_EntryCallBack null} \
                {"$gPB(event,cycle,drill_brk_chip,name)" 2  a $mom_sys_cycle_drill_break_chip_code UI_PB_tpth_EntryCallBack null} \
                {"$gPB(event,cycle,tap,name)" 2  a $mom_sys_cycle_tap_code UI_PB_tpth_EntryCallBack null} \
                {"$gPB(event,cycle,bore,name)" 2  a $mom_sys_cycle_bore_code UI_PB_tpth_EntryCallBack null}}} \
     {{"null" 3  V} \
        {{"$gPB(event,cycle,start,Label)" 2  H} \
                {"G79 X Y Z" 3  n $cycle_start_blk UI_PB_tpth_CycleStartBlks null "event,cycle,start"} \
                {"$gPB(event,cycle,start,text)" 7  n null null null}} \
        {{"$gPB(event,cycle,rapid_to)" 1  V} \
                {"null" 8  n $cycle_rapto_opt UI_PB_tpth_CycleRapidBlks {"None" "R" "Rapid Traverse & R" "Rapid"}}} \
        {{"$gPB(event,cycle,retract_to)" 1  V} \
                {"null" 8  n $cycle_recto_opt UI_PB_tpth_CycleRetractBlks {"None" "K" "G98/G99" "Rapid Spindle" "Cycle Off then Rapid Spindle"}}}}

{Tool Change} \
     {{"$gPB(event,tool_change,m_code)" 1  V} \
        {{"null" 3  V} \
                {"$gPB(event,tool_change,m_code,tl_chng)" 2  a $mom_sys_tool_change_code UI_PB_tpth_EntryCallBack null} \
                {"$gPB(event,tool_change,m_code,pt)" 2  a $mom_sys_head_code(INDEPENDENT) UI_PB_tpth_EntryCallBack null} \
                {"$gPB(event,tool_change,m_code,st)" 2  a $mom_sys_head_code(DEPENDENT) UI_PB_tpth_EntryCallBack null}}} \
     {{"$gPB(event,tool_change,t_code)" 1  V} \
        {{"null" 3  V} \
                {"$gPB(event,tool_change,t_code,pt_idx)" 2  i $mom_sys_turret_index(INDEPENDENT) null null} \
                {"$gPB(event,tool_change,t_code,st_idx)" 2  i $mom_sys_turret_index(DEPENDENT) null null} \
                {"$gPB(event,tool_change,t_code,conf)" 1  n null UI_PB_tpth_ConfToolCode null}}} \
     {{"$gPB(event,tool_change,tool_num)" 1  V} \
        {{"null" 2  V} \
                {"$gPB(event,tool_change,tool_num,max)" 0  i $tl_num_max null null} \
                {"$gPB(event,tool_change,tool_num,min)" 0  i $tl_num_min null null}}} \
     {{"$gPB(event,tool_change,time)" 1  V} \
        {{"null" 1  V} \
                {"$gPB(event,tool_change,m_code,tl_chng)" 2  f $mom_kin_tool_change_time null null}}}
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
     {{"$gPB(event,circular,ik_def)" 1  V} \
        {{"null" 1  V} \
                {"null" 10  n $mom_sys_cir_vector UI_PB_tpth_IJKParameters {"Vector - Arc Start to Center" "Vector - Arc Center to Start" "Unsigned Vector - Arc Start to Center" "Vector - Absolute Arc Center"}}}} \
     {{"null" 1  V} \
        {{"null" 1  V} \
                {"$gPB(event,circular,arc_len)" 2  f $mom_kin_min_arc_length null null}}}
## EVENTS USER INTERFACE END


