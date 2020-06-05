set gPB(func,help,heidenhain,cycle_200)   "CYCL DEF 200 Q200= Q201= Q206= Q202= Q210= Q203= Q204= Q211=\n\n\
                                           Q200: Set-up clearance(incremental value), distance between tool tip and workpiece surface.\n\
                                           Q201: Depth(incremental value), distance between workpiece surface and bottom of hole\n      \
                                                 (tip of drilltaper).\n\
                                           Q206: Feed rate for plunging, traversing speed of the tool during drilling in mm/min.\n\
                                           Q202: Plunging depth(incremental value), Infeed per cut. The depth does not have to be\n      \
                                                 a multiple of the plunging depth.\n\
                                           Q210: Dwell time at top, time in seconds that the tool remains at set-up clearance after\n      \
                                                 having been retracted from the hole for chip release.\n\
                                           Q203: Workpiece surface coordinate(absolute value), coordinate of the workpiece surface.\n\
                                           Q204: 2nd set-up clearance(incremental value), coordinate in the tool axis at which\n      \
                                                 no collision between tool and workpiece (clamping devices) can occur.\n\
                                           Q211: Dwell time at depth, time in seconds that the tool remains at the hole bottom."

set gPB(func,help,heidenhain,cycle_201)   "CYCL DEF 201 Q200= Q201= Q206= Q211= Q208= Q203= Q204=\n\n\
                                           Q200: Set-up clearance(incremental value), distance between tool tip and workpiece surface.\n\
                                           Q201: Depth(incremental value), distance between workpiece surface and bottom of hole.\n\
                                           Q206: Feed rate for plunging, traversing speed of the tool during reaming in mm/min.\n\
                                           Q211: Dwell time at depth, time in seconds that the tool remains at the hole bottom.\n\
                                           Q208: Retraction feed rate, traversing speed of the tool in mm/min when retracting from\n      \
                                                 the hole. If you enter Q208 = 0, the tool retracts at the reaming feed rate.\n\
                                           Q203: Workpiece surface coordinate(absolute value), coordinate of the workpiece surface.\n\
                                           Q204: 2nd set-up clearance(incremental value), coordinate in the tool axis at which\n      \
                                                 no collision between tool and workpiece (clamping devices) can occur."

set gPB(func,help,heidenhain,cycle_202)   "CYCL DEF 202 Q200= Q201= Q206= Q211= Q208= Q203= Q204= Q214= Q236=\n\n\
                                           Q200: Set-up clearance(incremental value), distance between tool tip and workpiece surface.\n\
                                           Q201: Depth(incremental value), distance between workpiece surface and bottom of hole.\n\
                                           Q206: Feed rate for plunging, traversing speed of the tool during boring in mm/min.\n\
                                           Q211: Dwell time at depth, time in seconds that the tool remains at the hole bottom.\n\
                                           Q208: Retraction feed rate, traversing speed of the tool in mm/min when retracting from\n      \
                                                 the hole. If you enter Q208 = 0, the tool retracts at feed rate for plunging.\n\
                                           Q203: Workpiece surface coordinate(absolute value), coordinate of the workpiece surface.\n\
                                           Q204: 2nd set-up clearance(incremental value), coordinate in the tool axis at which\n      \
                                                 no collision between tool and workpiece (clamping devices) can occur.\n\
                                           Q214: Disengaging direction (0/1/2/3/4), determine the direction in which the TNC retracts\n      \
                                                 the tool at the hole bottom (after spindle orientation).\n      \
                                                 0 -- Do not retract tool\n      \
                                                 1 -- Retract tool in the negative ref. axis direction\n      \
                                                 2 -- Retract tool in the neg. secondary axis direction\n      \
                                                 3 -- Retract tool in the positive ref. axis direction\n      \
                                                 4 -- Retract tool in the pos. secondary axis direction\n\
                                           Q236: Angle for spindle orientation(absolute value), angle at which the TNC positions the\n      \
                                                 tool before retracting it."

set gPB(func,help,heidenhain,cycle_204)   "CYCL DEF 204 Q200= Q249= Q250= Q251= Q252= Q253= Q254= Q255= Q203= Q204= Q214= Q236=\n\n\
                                           Q200: Set-up clearance(incremental value), distance between tool tip and workpiece surface.\n      \
                                                 Enter a positive value.\n\
                                           Q249: Depth of counterbore (incremental value), distance between underside of workpiece and\n      \
                                                 the top of the hole. A positive sign means the hole will be bored in the positive\n      \
                                                 spindle axis direction.\n\
                                           Q250: Material thickness (incremental value), thickness of the workpiece.\n\
                                           Q251: Off-center distance (incremental value), offcenter distance for the boring bar;\n      \
                                                 value from tool data sheet.\n\
                                           Q252: Tool edge height (incremental value), distance between the underside of the boring bar\n      \
                                                 and the main cutting tooth; value from tool data sheet.\n\
                                           Q253: Feed rate for pre-positioning, traversing speed of the tool when moving in and out of\n      \
                                                 the workpiece, in mm/min.\n\
                                           Q254: Feed rate for counterboring, traversing speed of the tool during counterboring\n      \
                                                 in mm/min.\n\
                                           Q255: Dwell time, Dwell time in seconds at the top of the bore hole.\n\
                                           Q203: Workpiece surface coordinate(absolute value), coordinate of the workpiece surface.\n\
                                           Q204: 2nd set-up clearance(incremental value), coordinate in the tool axis at which\n      \
                                                 no collision between tool and workpiece (clamping devices) can occur.\n\
                                           Q214: Disengaging direction (0/1/2/3/4), determine the direction in which the TNC retracts\n      \
                                                 the tool at the hole bottom (after spindle orientation).\n      \
                                                 0 -- Do not retract tool\n      \
                                                 1 -- Retract tool in the negative ref. axis direction\n      \
                                                 2 -- Retract tool in the neg. secondary axis direction\n      \
                                                 3 -- Retract tool in the positive ref. axis direction\n      \
                                                 4 -- Retract tool in the pos. secondary axis direction\n\
                                           Q236: Angle for spindle orientation(absolute value), angle at which the TNC positions the\n      \
                                                 tool before retracting it."

set gPB(func,help,heidenhain,cycle_207)   "CYCL DEF 207 Q200= Q201= Q239= Q203= Q204=\n\n\
                                           Q200: Set-up clearance(incremental value), distance between tool tip (at starting position)\n      \
                                                 and workpiece surface.\n\
                                           Q201: Total hole depth (incremental value), distance between workpiece surface and\n      \
                                                 end of thread.\n\
                                           Q239: Pitch of the thread. The algebraic sign differentiates between right-hand and\n      \
                                                 left-hand threads.\n      \
                                                 + -- right-hand thread\n      \
                                                 - -- left-hand thread\n\
                                           Q203: Workpiece surface coordinate(absolute value), coordinate of the workpiece surface.\n\
                                           Q204: 2nd set-up clearance(incremental value), coordinate in the tool axis at which\n      \
                                                 no collision between tool and workpiece (clamping devices) can occur."

set gPB(func,help,heidenhain,cycle_209)   "CYCL DEF 209 Q200= Q201= Q239= Q203= Q204= Q257= Q256= Q336=\n\n\
                                           Q200: Set-up clearance(incremental value), distance between tool tip (at starting position)\n      \
                                                 and workpiece surface.\n\
                                           Q201: Thread depth (incremental value), distance between workpiece surface and\n      \
                                                 end of thread.\n\
                                           Q239: Pitch of the thread. The algebraic sign differentiates between right-hand and\n      \
                                                 left-hand threads. \n      \
                                                 + -- right-hand thread\n      \
                                                 - -- left-hand thread\n\
                                           Q203: Workpiece surface coordinate(absolute value), coordinate of the workpiece surface.\n\
                                           Q204: 2nd set-up clearance(incremental value), coordinate in the tool axis at which\n      \
                                                 no collision between tool and workpiece (clamping devices) can occur.\n\
                                           Q257: Infeed depth for chip breaking (incrementalvalue), depth at which TNC carries out\n      \
                                                 chip breaking.\n\
                                           Q256: Retraction rate for chip breaking, the TNC multiplies the pitch Q239 by the programmed\n      \
                                                 value and retracts the tool by the calculated value during chip breaking. If you enter\n      \
                                                 Q256 = 0, the TNC retracts the tool completely from the hole (to the set-up clearance)\n      \
                                                 for chip release.\n\
                                           Q336: Angle for spindle orientation (absolute value): Angle at which the TNC positions the\n      \
                                                 tool before machining the thread. This allows you to regroove the thread, if required."

set gPB(func,help,heidenhain,cycle_262)   "CYCL DEF 262 Q335= Q239= Q201= Q355= Q253= Q351= Q200= Q203= Q204= Q207=\n\n\
                                           Q335: Nominal diameter, nominal thread diameter.\n\
                                           Q239: Pitch of the thread. The algebraic sign differentiates between right-hand and left-hand\n      \
                                                 threads. \n      \
                                                 + -- right-hand thread\n      \
                                                 - -- left-hand thread\n\
                                           Q201: Thread depth (incremental value), distance between workpiece surface and root of thread.\n\
                                           Q355: Threads per step, number of thread revolutions by which the tool is offset,\n      \
                                                 (see figure at right):\n      \
                                                 0  -- one 360бу helical path to the depth of thread.\n      \
                                                 1  -- continuous helical path over the entire length of the thread\n      \
                                                 >1 -- several helical paths with approach anddeparture; between them, the TNC offsets\n            \
                                                       the tool by Q355, multiplied by the pitch.\n\
                                           Q253: Feed rate for pre-positioning, traversing speed of the tool when moving in and out of\n      \
                                                 the workpiece, in mm/min.\n\
                                           Q351: Climb or up-cut, type of milling operation with M03.\n      \
                                                 +1 -- climb milling\n      \
                                                 -1 -- up-cut milling.\n\
                                           Q200: Set-up clearance (incremental value), distance between tool tip and workpiece surface.\n\
                                           Q203: Workpiece surface coordinate (absolute value), coordinate of the workpiece surface.\n\
                                           Q204: 2nd set-up clearance (incremental value), coordinate in the tool axis at which\n      \
                                                 no collision between tool and workpiece (clamping devices) can occur.\n\
                                           Q207: Feed rate for milling, traversing speed of the tool in mm/min while milling."

