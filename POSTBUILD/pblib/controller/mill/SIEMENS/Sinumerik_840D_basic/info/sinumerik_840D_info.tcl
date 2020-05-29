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
set gPB(func,help,sinumerik,cycle_86)   "CYCLE86 (RTP, RFP, SDIS, DP, DPR, DTB, SIR, RPA, RPO, RPAP, POSS)\n\n\
                                         RTP:   Retraction plane (absolute)\n\
                                         RFP:   Reference plane (absolute)\n\
                                         SDIS:  Safety distance (enter without sign)\n\
                                         DP:    Final drilling depth (absolute)\n\
                                         DPR:   Final drilling depth relative to reference plane (enter without sign)\n\
                                         DTB:   Dwell time at final drilling depth (chip breaking)\n\
                                         SDIR:  Direction of rotation\n       \
                                                Values: 3 (for M3)\n               \
                                                        4 (for M4)\n\
                                         RPA:   Retraction path in abscissa of the active plane (incremental, enter with sign)\n\
                                         RPO:   Retraction path in ordinate of the active plane (incremental, enter with sign)\n\
                                         RPAP:  Retraction path in applicate of the active plane (incremental, enter with sign)\n\
                                         POSS:  Spindle position for oriented spindle stop in the cycle (in degress)"
set gPB(func,help,sinumerik,cycle_87)   "CYCLE87 (RTP, RFP, SDIS, DP, DPR, SDIR)\n\n\
                                         RTP:   Retraction plane (absolute)\n\
                                         RFP:   Reference plane (absolute)\n\
                                         SDIS:  Safety distance (enter without sign)\n\
                                         DP:    Final drilling depth (absolute)\n\
                                         DPR:   Final drilling depth relative to reference plane (enter without sign)\n\
                                         SDIR:  Direction of rotation\n       \
                                                Values: 3 (for M3)\n               \
                                                        4 (for M4)"
set gPB(func,help,sinumerik,cycle_88)   "CYCLE88 (RTP, RFP, SDIS, DP, DPR, DTB, SDIR)\n\n\
                                         RTP:   Retraction plane (absolute)\n\
                                         RFP:   Reference plane (absolute)\n\
                                         SDIS:  Safety distance (enter without sign)\n\
                                         DP:    Final drilling depth (absolute)\n\
                                         DPR:   Final drilling depth relative to reference plane (enter without sign)\n\
                                         DTB:   Dwell time at final drilling depth\n\
                                         SDIR:  Direction of rotation\n       \
                                                Values: 3 (for M3)\n               \
                                                        4 (for M4)"
set gPB(func,help,sinumerik,cycle_89)   "CYCLE89 (RTP, RFP, SDIS, DP, DPR, DTB)\n\n\
                                         RTP:   Retraction plane (absolute)\n\
                                         RFP:   Reference plane (absolute)\n\
                                         SDIS:  Safety distance (enter without sign)\n\
                                         DP:    Final drilling depth (absolute)\n\
                                         DPR:   Final drilling depth relative to reference plane (enter without sign)\n\
                                         DTB:   Dwell time at final drilling depth (chip breaking)"
set gPB(func,help,sinumerik,cycle_800)  "CYCLE800 (_FR, _TC, _ST, _MODE, _X0, _Y0, _Z0, _A, _B. _C, _X1, _Y1, _Z1, _DIR, _FR_I)\n\n\
                                         _FR:   Retraction Method                   Always use 1\n\
                                         _TC:   Swivel Data Record	            Use \"\" as default in template post. (Setup by\n                                           \
                                                                                    machine tool builder)\n\
                                         _ST:   Swivel Plane			    Always use 0\n\
                                         _MODE: Swivel Mode			    Always use 57 ( = binary 00111001)\n\
                                         _X0,_Y0,_Z0:   Reference Point Prior	    x,y,z relative to prior coordinate zero\n\
                                         _A:    Angle relative to x axis along YZ   Range -180~+180\n\
                                         _B:    Angle relative to y axis along ZX   Range -90~+90\n\
                                         _C:    Angle relative to z axis along XY   Range -180~+180\n\
                                         _X1,_Y1,_Z1:   Reference Point after	    Always use 0\n\
                                         _DIR:  Direction preference		    +1 or -1\n\
                                         _FR_I: Incremental retract		    not used"
set gPB(func,help,sinumerik,cycle_832)  "CYCLE832 (_TOL, _TOLM)\n\n\
                                         This function is used for Sinumerik 840D NC V6.x\n\n\
                                         _TOL          Tolerance of machining axes\n\
                                         _TOLM         Tolerance mode"
set gPB(func,help,sinumerik,cycle_832_v7)  "CYCLE832 (_TOL, _TOLM, 1)\n\n\
                                           This function is used for Sinumerik 840D NC V7.x\n\n\
                                           _TOL          Tolerance of machining axes\n\
                                           _TOLM         Tolerance mode"
