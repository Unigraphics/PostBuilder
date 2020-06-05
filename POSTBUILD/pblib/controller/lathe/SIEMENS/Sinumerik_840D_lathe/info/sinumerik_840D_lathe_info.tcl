set gPB(func,help,sinumerik,cycle_81)   "CYCLE81 (RTP, RFP, SDIS, DP, DPR)\n\n\
                                         RTP:   Retraction plane (absolute)\n\
                                         RFP:   Reference plane (absolute)\n\
                                         SDIS:  Safety distance (enter without sign)\n\
                                         DP:    Final drilling depth (absolute)\n\
                                         DPR:   Final drilling depth relative to reference plane(enter without sign)"
set gPB(func,help,sinumerik,cycle_82)   "CYCLE82 (RTP, RFP, SDIS, DP, DPR, DTB)\n\n\
                                         RTP:   Retraction plane (absolute)\n\
                                         RFP:   Reference plane (absolute)\n\
                                         SDIS:  Safety distance (enter without sign)\n\
                                         DP:    Final drilling depth (absolute)\n\
                                         DPR:   Final drilling depth relative to reference plane (enter without sign)\n\
                                         DTB:   Dwell time at final drilling depth (chip breaking)"
set gPB(func,help,sinumerik,cycle_83)   "CYCLE83 (RTP, RFP, SDIS, DP, DPR, FDEP, FDPR, DAM, DTB, DTS, FRF, VARI, \
                                                  _AXN, _MDEP, _VRT, _DTD, _DIS1)\n\n\
                                         RTP:   Retraction plane (absolute)\n\
                                         RFP:   Reference plane (absolute)\n\
                                         SDIS:  Safety distance (enter without sign)\n\
                                         DP:    Final drilling depth (absolute)\n\
                                         DPR:   Final drilling depth relative to reference plane (enter without sign)\n\
                                         FDEP:  First drilling depth (absolute)\n\
                                         FDPR:  First drilling depth relative to reference plane (enter without sign)\n\
                                         DAM:   Degression:(enter without sign)\n       \
                                                Values:>0 degression as value\n              \
                                                       <0 degression factor\n              \
                                                       =0 no degression\n\
                                         DTB:   Dwell time at final drilling depth (chip breaking)\n       \
                                                Values:>0 in seconds\n              \
                                                       <0 in revolutions\n\
                                         DTS:   Dwell time at starting point and for swarf removal\n       \
                                                Values:>0 in seconds\n              \
                                                       <0 in revolutions\n\
                                         FRF:   Feedrate factor for first drilling depth (enter without sign)\n       \
                                                Value range: 0.001 ... 1\n\
                                         VARI:  Type of machining\n       \
                                                Values:0 chip breaking\n              \
                                                       1 swarf removal\n\
                                         _AXN:  Tool axis:\n       \
                                                Values: 1 = 1st geometry axis\n               \
                                                        2 = 2nd geometry axis\n               \
                                                        or else 3rd geometry axis\n\
                                         _MDEP: Minimum drilling depth\n\
                                         _VRT:  Variable retraction distance for chip breaking (VARI=0):\n       \
                                                Values:>0 is retraction distance\n              \
                                                       =0 setting is 1 mm\n\
                                         _DTD:  Dwell time at final drilling depth\n       \
                                                Values:>0 in seconds\n              \
                                                       <0 in revolutions\n              \
                                                       =0 value as for DTB\n\
                                         _DIS1: Programmable limit distance on re-insertion in hole (VARI=1 for swarf removal)\n       \
                                                Values:>0 programmable value applies\n              \
                                                       =0 automatic calculation"
set gPB(func,help,sinumerik,cycle_84)   "CYCLE84 (RTP, RFP, SDIS, DP, DPR, DTB, SDAC, MPIT, PIT, POSS, SST, SST1, \
                                                  _AXN, _PTAB, _TECHNO, _VARI, _DAM, _VRT)\n\n\
                                         RTP:   Retraction plane (absolute)\n\
                                         RFP:   Reference plane (absolute)\n\
                                         SDIS:  Safety distance (enter without sign)\n\
                                         DP:    Final drilling depth (absolute)\n\
                                         DPR:   Final drilling depth relative to reference plane (enter without sign)\n\
                                         DTB:   Dwell time at final drilling depth (chip breaking)\n\
                                         SDAC:  Direction of rotation after end of cycle\n       \
                                                Values:3, 4 or 5\n\
                                         MPIT:  Pitch as thread size (with sign)\n       \
                                                Value range: 3 (for M3) ... 48 (for M48), the sign determines the direction of \n                    \
                                                             rotation in the thread\n\
                                         PIT:   Pitch as value (with sign)\n       \
                                                Value range: 0.001 ... 2000.000mm, the sign determines the direction of rotation \n                    \
                                                             in the thread\n\
                                         POSS:  Spindle position for oriented spindle stop in the cycle (in degress)\n\
                                         SST:   Speed for tapping\n\
                                         SST1:  Speed for retraction\n\
                                         _AXN:  Tool axis:\n       \
                                                Values: 1 = 1st geometry axis\n               \
                                                        2 = 2nd geometry axis\n               \
                                                        or else 3rd geometry axis\n\
                                         _PTAB: Evaluation of thread pitch PIT\n       \
                                                Values: 0...according to programmed system of units inch/metric\n               \
                                                        1...pitch in mm\n               \
                                                        2...pitch in thread starts per inch\n               \
                                                        3...pitch in inches.revolution\n\
                                         _TECHNO: Technological settings\n\
                                         _VARI:  Type of machining\n        \
                                                 Values: 0...tapping in ome pass\n                \
                                                         1...deep hole tapping with chip breakage\n                \
                                                         2...deep hole tapping with stock removal\n\
                                         _DAM:   Incremental drilling depth\n        \
                                                 Value range: 0 <+ max. value\n\
                                         _VRT:   Variable retraction distance for chip breakage\n        \
                                                 Value range: 0 <+ max. value"
set gPB(func,help,sinumerik,cycle_840)  "CYCLE840 (RTP, RFP, SDIS, DP, DPR, DTB, SDR, SDAC, ENC, MPIT, PIT, _AXN, _PTAB, _TECHNO)\n\n\
                                         RTP:   Retraction plane (absolute)\n\
                                         RFP:   Reference plane (absolute)\n\
                                         SDIS:  Safety distance (enter without sign)\n\
                                         DP:    Final drilling depth (absolute)\n\
                                         DPR:   Final drilling depth relative to reference plane (enter without sign)\n\
                                         DTB:   Dwell time at final drilling depth (chip breaking)\n\
                                         SDR:   Direction of rotation for retraction\n       \
                                                Values: 0 (automatic reversal of direction of rotation)\n               \
                                                        3 or 4 (for M3 or M4)\n\
                                         SDAC:  Direction of rotation after end of cycle\n       \
                                                Values:3, 4 or 5\n\
                                         ENC:   Tapping with/without encoder\n       \
                                                Values: 0 = with encoder, without dwell time\n               \
                                                        1 = without encoder, first programs the cycle, then the feed\n              \
                                                       11 = without encoder, calculates the feed in the cycle\n              \
                                                       20 = with encoder, with dwell time\n\
                                         MPIT:  Pitch as thread size\n       \
                                                Value range: 3 (for M3) ... 48 (for M48)\n\
                                         PIT:   Pitch as value\n       \
                                                Value range: 0.001 ... 2000.000mm\n\
                                         _AXN:  Tool axis:\n       \
                                                Values: 1 = 1st geometry axis\n               \
                                                        2 = 2nd geometry axis\n               \
                                                        or else 3rd geometry axis\n\
                                         _PTAB: Evaluation of thread pitch PIT\n       \
                                                Values: 0...according to programmed system of units inch/metric\n               \
                                                        1...pitch in mm\n               \
                                                        2...pitch in thread starts per inch\n               \
                                                        3...pitch in inches.revolution\n\
                                         _TECHNO: Technological settings"
set gPB(func,help,sinumerik,cycle_85)   "CYCLE85 (RTP, RFP, SDIS, DP, DPR, DTB, FFR, RFF)\n\n\
                                         RTP:   Retraction plane (absolute)\n\
                                         RFP:   Reference plane (absolute)\n\
                                         SDIS:  Safety distance (enter without sign)\n\
                                         DP:    Final drilling depth (absolute)\n\
                                         DPR:   Final drilling depth relative to reference plane (enter without sign)\n\
                                         DTB:   Dwell time at final drilling depth (chip breaking)\n\
                                         FFR:   Feedrate\n\
                                         PFF:   retraction feedrate"
set gPB(func,help,sinumerik,cycle_97)   "CYCLE97 (PIT, MPIT, SPL, FPL, DM1, DM2, APP, ROP, TDEP, FAL, IANG,\
                                         NSP, NRC, NID, VARI, NUMT, _VRT)\n\n\
                                         PIT:   Thread pitch as a value (enter without sign)\n\
                                         MPIT:  Thread pitch as thread size\n       \
                                                Range of values: 3 (for M3) ... 60 (for M60)\n\
                                         SPL:   Thread starting point in the longitudinal axis\n\
                                         FPL:   Thread end point in the longitudinal axis\n\
                                         DM1:   Thread diameter at the starting point\n\
                                         DM2:   Thread diameter at the end point\n\
                                         APP:   Run-in path (enter without sign)\n\
                                         ROP:   Run-out path (enter without sign)\n\
                                         TDEP:  Thread depth (enter without sign)\n\
                                         FAL:   Finishing allowance (enter without sign)\n\
                                         IANG:  Infeed angle\n       \
                                                Range of values:\n       \
                                                \"+\" (for flank infeed at the flank)\n       \
                                                \"-\" (for alternating flank infeed)\n\
                                         NSP:   Starting point offset for the first thread turn (enter without sign)\n\
                                         NRC:   Number of roughing cuts (enter without sign)\n\
                                         NID:   Number of idle passes (enter without sign)\n\
                                         VARI:  Definition of the machining type for the thread\n       \
                                                Range of values: 1 ... 4\n\
                                         NUMT:  Number of thread turns (enter without sign)\n\
                                         _VRT:  Variable retraction distance based on initial diameter, incremental (enter without sign)"
set gPB(func,help,sinumerik,cycle_95)   "CYCLE95 (NPP, MID, FALZ, FALX, FAL, FF1, FF2, FF3, VARI, DT, DAM, _VRT)\n\n\
                                         NPP:   Name of contour subroutine\n\
                                         MID:   Infeed depth (enter without sign)\n\
                                         FALZ:  Finishing allowance in the longitudinal axis (enter without sign)\n\
                                         FALZ:  Finishing allowance in the transverse axis (enter without sign)\n\
                                         FAL:   Finishing allowance according to the contour (enter without sign)\n\
                                         FF1:   Feedrate for roughing without undercut\n\
                                         FF2:   Feedrate for insertion into relief cut elements\n\
                                         FF3:   Feedrate for finishing\n\
                                         VARI:  Machining type\n       \
                                                Range of values: 1...12, 201...212\n       \
                                                HUNDREDS DIGIT:\n       \
                                                Values:\n       \
                                                0: With rounding at the contour\n       \
                                                No residual corners remain, the contour is rounded with overlapping. This\n       \
                                                means that rounding is performed across multiple intersections.\n       \
                                                2: Without rounding at the contour\n       \
                                                Contours are always rounded to the previous roughing intersection followed \n       \
                                                by retraction. Residual corners can remain, depending on the ratio of the \n       \
                                                tool radius to infeed depth (MID).\n\
                                         DT:    Dwell time fore chip breaking when roughing\n\
                                         DAM:   Path length after which each roughing step is interrupted for chip breaking\n\
                                         _VRT:  Lift-off distance from contour when roughing, incremental (to be entered without sign)"

