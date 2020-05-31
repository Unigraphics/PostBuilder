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
set gPB(func,help,sinumerik,cycle_83)   "CYCLE83 (RTP, RFP, SDIS, DP, DPR, FDEP, FDPR, DAM, DTB, DTS, FRF, VARI)\n\n\
                                         RTP:   Retraction plane (absolute)\n\
                                         RFP:   Reference plane (absolute)\n\
                                         SDIS:  Safety distance (enter without sign)\n\
                                         DP:    Final drilling depth (absolute)\n\
                                         DPR:   Final drilling depth relative to reference plane (enter without sign)\n\
                                         FDEP:  First drilling depth (absolute)\n\
                                         FDPR:  First drilling depth relative to reference plane (enter without sign)\n\
                                         DAM:   Amount of degression(enter without sign)\n\
                                         DTB:   Dwell time at final drilling depth (chip breaking)\n\
                                         DTS:   Dwell time at starting point and for swarf removal\n\
                                         FRF:   Feedrate factor for first drilling depth (enter without sign)\n       \
                                                Value range: 0.001 ... 1\n\
                                         VARI:  Type of machining\n       \
                                                Values:0 chip breaking\n              \
                                                       1 swarf removal"
set gPB(func,help,sinumerik,cycle_84)   "CYCLE84 (RTP, RFP, SDIS, DP, DPR, DTB, SDAC, MPIT, PIT, POSS, SST, SST1)\n\n\
                                         RTP:   Retraction plane (absolute)\n\
                                         RFP:   Reference plane (absolute)\n\
                                         SDIS:  Safety distance (enter without sign)\n\
                                         DP:    Final drilling depth (absolute)\n\
                                         DPR:   Final drilling depth relative to reference plane (enter without sign)\n\
                                         DTB:   Dwell time at final drilling depth (chip breaking)\n\
                                         SDAC:  Direction of rotation after end of cycle\n       \
                                                Values:3, 4 or 5 (for M3, M4 or M5)\n\
                                         MPIT:  Thread lead as a thread size (signed):\n       \
                                                Range of values 3 (for M3) ... 48 (for M48); the sign determines \n       \
                                                the direction of rotation in the thread\n\
                                         PIT:   Thread lead as a value (signed)\n       \
                                                Range of values: 0.001 ... 2000.000 mm; the sign determines the \n       \
                                                direction of rotation in the thread\n\
                                         POSS:  Spindle position for oriented spindle stop in the cycle (in degress)\n\
                                         SST:   Speed for tapping\n\
                                         SST1:  Speed for retraction"
set gPB(func,help,sinumerik,cycle_840)  "CYCLE840 (RTP, RFP, SDIS, DP, DPR, DTB, SDR, SDAC, ENC, MPIT, PIT, AXN)\n\n\
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
                                                Values:3, 4 or 5 (fore M3, M4 or M5)\n\
                                         ENC:   Tapping with/without encoder\n       \
                                                Values: 0 = with encoder, 1 = without encoder\n\
                                         MPIT:  Thread lead as a thread size (signed):\n       \
                                                Range of values 3 (for M3) ... 48 (for M48)\n\
                                         PIT:   Thread lead as a value(signed)\n       \
                                                Range of values: 0.001 ... 2000.000 mm\n\
                                         AXN:   Tool axis:\n       \
                                                Values: 1 = First axis of the plane\n               \
                                                        2 = Second axis of the plane\n               \
                                                        otherwise, third axis of the plane"
set gPB(func,help,sinumerik,cycle_85)   "CYCLE85 (RTP, RFP, SDIS, DP, DPR, DTB, FFR, RFF)\n\n\
                                         RTP:   Retraction plane (absolute)\n\
                                         RFP:   Reference plane (absolute)\n\
                                         SDIS:  Safety distance (enter without sign)\n\
                                         DP:    Final drilling depth (absolute)\n\
                                         DPR:   Final drilling depth relative to reference plane (enter without sign)\n\
                                         DTB:   Dwell time at final drilling depth (chip breaking)\n\
                                         FFR:   Feedrate\n\
                                         PFF:   Retraction feedrate"
set gPB(func,help,sinumerik,cycle_86)   "CYCLE86 (RTP, RFP, SDIS, DP, DPR, DTB, SDIR, RPA, RPO, RPAP, POSS)\n\n\
                                         RTP:   Retraction plane (absolute)\n\
                                         RFP:   Reference plane (absolute)\n\
                                         SDIS:  Safety distance (enter without sign)\n\
                                         DP:    Final drilling depth (absolute)\n\
                                         DPR:   Final drilling depth relative to reference plane (enter without sign)\n\
                                         DTB:   Dwell time at final drilling depth (chip breaking)\n\
                                         SDIR:  Direction of rotation\n       \
                                                Values: 3 (for M3), 4 (for M4)\n\
                                         RPA:   Retraction path along the first axis of the plane (incremental, enter with sign)\n\
                                         RPO:   Retraction path along the second axis of the plane (incremental, enter with sign)\n\
                                         RPAP:  Retraction path along the drilling axis (incremental, enter with sign)\n\
                                         POSS:  Spindle position for oriented spindle stop in the cycle (in degress)"
set gPB(func,help,sinumerik,cycle_87)   "CYCLE87 (RTP, RFP, SDIS, DP, DPR, SDIR)\n\n\
                                         RTP:   Retraction plane (absolute)\n\
                                         RFP:   Reference plane (absolute)\n\
                                         SDIS:  Safety distance (enter without sign)\n\
                                         DP:    Final drilling depth (absolute)\n\
                                         DPR:   Final drilling depth relative to reference plane (enter without sign)\n\
                                         SDIR:  Direction of rotation\n       \
                                                Values: 3 (for M3), 4 (for M4)"
set gPB(func,help,sinumerik,cycle_88)   "CYCLE88 (RTP, RFP, SDIS, DP, DPR, DTB, SDIR)\n\n\
                                         RTP:   Retraction plane (absolute)\n\
                                         RFP:   Reference plane (absolute)\n\
                                         SDIS:  Safety distance (enter without sign)\n\
                                         DP:    Final drilling depth (absolute)\n\
                                         DPR:   Final drilling depth relative to reference plane (enter without sign)\n\
                                         DTB:   Dwell time at final drilling depth (chip breakage)\n\
                                         SDIR:  Direction of rotation\n       \
                                                Values: 3 (for M3), 4 (for M4)"
set gPB(func,help,sinumerik,cycle_89)   "CYCLE89 (RTP, RFP, SDIS, DP, DPR, DTB)\n\n\
                                         RTP:   Retraction plane (absolute)\n\
                                         RFP:   Reference plane (absolute)\n\
                                         SDIS:  Safety distance (enter without sign)\n\
                                         DP:    Final drilling depth (absolute)\n\
                                         DPR:   Final drilling depth relative to reference plane (enter without sign)\n\
                                         DTB:   Dwell time at final drilling depth (chip breakage)"
