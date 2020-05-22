## POSTBUILDER_VERSION=2000.0.2.1
#########################################################################
#                                                                       #
#  This is the POST UI FILE used to read and write the parameters       #
#  associated with a spedific post processor.                           #
#                                                                       #
#  WARNING: The Syntax of the file should not be changed!!!             #
#                                                                       #
#########################################################################

## KINEMATIC VARIABLES START
"$mom_kin_arc_valid_plane"                "XY"
## KINEMATIC VARIABLES END

## EVENTS USER INTERFACE START
{Cycle Parameters} \
     {{"G Code & Customization" 2 H} \
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
                {"Cycle Start" 2  a $mom_sys_cycle_start_code UI_PB_tpth_EntryCallBack null} \
                {"Cycle Off" 2  a $mom_sys_cycle_off UI_PB_tpth_EntryCallBack null} \
                {"Drill" 2  a $mom_sys_cycle_drill_code UI_PB_tpth_EntryCallBack null} \
                {"Drill Dwell (SpotFace)" 2  a $mom_sys_cycle_drill_dwell_code UI_PB_tpth_EntryCallBack null} \
                {"Drill Deep (Peck)" 2  a $mom_sys_cycle_drill_deep_code UI_PB_tpth_EntryCallBack null} \
                {"Drill Break Chip" 2  a $mom_sys_cycle_drill_break_chip_code UI_PB_tpth_EntryCallBack null} \
                {"Tap" 2  a $mom_sys_cycle_tap_code UI_PB_tpth_EntryCallBack null} \
                {"Bore" 2  a $mom_sys_cycle_bore_code UI_PB_tpth_EntryCallBack null}}} \
     {{"null" 3  V} \
        {{"Cycle Start" 2  H} \
                {"G79 X Y Z" 3  n $cycle_start_blk UI_PB_tpth_CycleStartBlks null "event,cycle,start"} \
                {"Use Cycle Start Block To Execute Cycle" 7  n null null null}} \
        {{"Rapid - To" 1  V} \
                {"null" 8  n $cycle_rapto_opt UI_PB_tpth_CycleRapidBlks {"None" "R" "Rapid Traverse & R" "Rapid"}}} \
        {{"Retract - To" 1  V} \
                {"null" 8  n $cycle_recto_opt UI_PB_tpth_CycleRetractBlks {"None" "K" "G98/G99" "Rapid Spindle" "Cycle Off then Rapid Spindle"}}}}

{Tool Change} \
     {{"M Code" 1  V} \
        {{"null" 3  V} \
                {"Tool Change" 2  a $mom_sys_tool_change_code UI_PB_tpth_EntryCallBack null} \
                {"Primary Turret" 2  a $mom_sys_head_code(INDEPENDENT) UI_PB_tpth_EntryCallBack null} \
                {"Secondary Turret" 2  a $mom_sys_head_code(DEPENDENT) UI_PB_tpth_EntryCallBack null}}} \
     {{"T Code" 1  V} \
        {{"null" 3  V} \
                {"Primary Turret Index" 2  i $mom_sys_turret_index(INDEPENDENT) null null} \
                {"Secondary Turret Index" 2  i $mom_sys_turret_index(DEPENDENT) null null} \
                {"Configure" 1  n null UI_PB_tpth_ConfToolCode null}}} \
     {{"Tool Number" 1  V} \
        {{"null" 2  V} \
                {"Minimum" 0  i $tl_num_min null null} \
                {"Maximum" 0  i $tl_num_max null null}}} \
     {{"Time (Sec)" 1  V} \
        {{"null" 1  V} \
                {"Tool Change" 2  f $mom_kin_tool_change_time null null}}}
## EVENTS USER INTERFACE END

