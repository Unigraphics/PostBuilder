##############################################################################
#                                                                            #
# Copyright (c) 1999/2000/2001/2002/2003/2004, Unigraphics Solutions Inc.    #
#                                                                            #
##############################################################################
#
# pb_cmd_feeds_speeds_utils
#
# 06-26-08 gsl - Spindle speed range should be based on RPM not SFM in
#                PB_CMD_spindle_sfm_range_select
# 06-30-08 gsl - Wrote PB_CMD_spindle_range_select to consolidated spindle range
#                selection for both RPM & CSS mode
#                - Legacy commands are also preserved.
#


#=============================================================
proc PB_CMD_force_FRN_F_code { } {
#=============================================================
#
#  This command can be used to force out F codes for FRN mode.
#  All F codes output with IPM or MMPM will still be  modal.
#
#
#  Import this command and place it at the start of your Linear Move
#  event.
#
#
   global feed_mode

   if { $feed_mode == "FRN" || $feed_mode == "INVERSE" } {
      MOM_force once F
   }
}


#=============================================================
proc PB_CMD_FEEDRATE_NUMBER { } {
#=============================================================
#
#  This command allows you to modify the feed rate number
#  after it has been calculated by the system.
#
#
#  Import this command as needed.  It will be executed automatically.
#
#
   global mom_feed_rate_number

   set mom_sys_frn_factor 1.0

   if { [info exists mom_feed_rate_number] } {
      return [expr $mom_feed_rate_number * $mom_sys_frn_factor]
   } else {
      return 0.0
   }
}


#=============================================================
proc PB_CMD_spindle_rpm_check { } {
#=============================================================
#
# This procedure will verify that the speficied RPM falls
# within the limits defined for that spindle range. 
#
# This procedure should be placed in an event marker after
# the range has been determined and before the spindle code
# is output.
#

   global mom_sys_spindle_param
   global mom_spindle_mode 
   global mom_spindle_rpm 
   global mom_spindle_speed 
   global mom_spindle_range 
   global mom_warning_info


   if { ![info exist mom_sys_spindle_param] } {
return
   }

   if { ![info exist mom_spindle_range] } {
return
   }

   if { [info exist mom_spindle_rpm] && $mom_spindle_rpm > 0.0 } {
      set speed $mom_spindle_rpm
   } else {
      set speed $mom_spindle_speed
   }  

   if {$speed < $mom_sys_spindle_param($mom_spindle_range,min)} {
      set mom_warning_info "Spindle RPM less than minimum"
      MOM_catch_warning
   } elseif {$speed > $mom_sys_spindle_param($mom_spindle_range,max)} {
      set mom_warning_info "Spindle RPM greater than maximum"
      MOM_catch_warning
   }
}


#=============================================================
proc PB_CMD_spindle_range_select { } {
#=============================================================
#  
# This procedure will select the appropriate spindle range based 
# on the spindle table provided in Post Builder.
#
# This procedure will generate variable mom_spindle_range which
# will be used in the word M_range to output M code for spindle
# range selection.
# - The maximum RPM is used to determine the spindle range for
#   spindle in CSS (SFM/SMM) mode, otherwise a warning message
#   will be generated.
# - Warning message will also be generated when an insufficient
#   maximum RPM has been specified with CSS spindle mode.
#
# You must place this custom command in the event(s) where a
# spindle range needs to be determined before the block containing
# word M_range is output.
#
# - Any unused ranges must contain min 0 and max 0.
# - Posts created before PB v2.0.1, by default, may have min of 1
#   and max of 9999. They need to be modified to correctly check
#   for spindle ranges.
#

   global mom_sys_spindle_param
   global mom_spindle_rpm
   global mom_spindle_speed 
   global mom_spindle_range 


   if { ![info exist mom_sys_spindle_param] } {
      set mom_spindle_range 1
return
   }


   if { [info exist mom_spindle_rpm] && $mom_spindle_rpm > 0.0 } {
      set speed $mom_spindle_rpm
   } else {
      set speed $mom_spindle_speed
   }


  # CSS spindle mode must use max RPM to determine spindle range.
  #
   global mom_spindle_mode
   global mom_warning_info
   global mom_path_name

   if { $mom_spindle_mode == "SFM" || $mom_spindle_mode == "SMM" } {

      global mom_spindle_maximum_rpm_toggle mom_spindle_maximum_rpm
      if { [info exists mom_spindle_maximum_rpm_toggle] && $mom_spindle_maximum_rpm_toggle } {

         if { [info exists mom_spindle_maximum_rpm] } {
            if { $mom_spindle_maximum_rpm > $speed } {
               set speed $mom_spindle_maximum_rpm
            } else {
              # Error - Insufficient max spindle speed
               set mom_warning_info "$mom_path_name - Max spindle RPM is less than current RPM for\
                                     $mom_spindle_mode spindle mode to select a proper spindle range."
               MOM_catch_warning
              # MOM_abort "$mom_warning_info"
            }
         }
      } else {
        # Warning - Range can not be reliably selected when no max RPM is defined.
          set mom_warning_info "$mom_path_name - Max spindle RPM must be defined to select a\
                                spindle range in $mom_spindle_mode spindle mode."
          MOM_catch_warning
         # MOM_abort "$mom_warning_info"
      }
   }


  # Post Builder currently only supports 9 spindle ranges.
   if { ![info exist mom_number_of_ranges] } {
      set mom_number_of_ranges 9
   }

   set mom_spindle_range 1
   for { set i 1 } { $i <= $mom_number_of_ranges } { incr i } {
      if { $speed > $mom_sys_spindle_param($i,min) && $speed <= $mom_sys_spindle_param($i,max) } {
         set mom_spindle_range $i
       return
      } elseif { $speed > $mom_sys_spindle_param($i,max) } {
        # Select next range if speed exceeds current range.
         set mom_spindle_range [expr { ($i < $mom_number_of_ranges) ? ($i + 1) : $i }]
      }
   }

   PB_CMD_spindle_rpm_check
}

#=============================================================
proc PB_CMD_spindle_rpm_range_select { } {
#=============================================================
return [PB_CMD_spindle_range_select]
}


#=============================================================
proc PB_CMD_spindle_sfm_range_select { } {
#=============================================================
return [PB_CMD_spindle_range_select]
}


#=============================================================
proc PB_CMD_spindle_table { } {
#=============================================================
#
#  This procedure should be placed in an event marker before you output your spindle code.  
#  If you output your spindle code with motion, you can place this custom command in the 
#  initial move event marker.
#
#  This procedure will return the scode nearest to your specified rpm.  You can modify
#  this table as needed.  You may add, delete or modify  rpm and scodes as needed.  
#  The rpm values must increase.  For instance,  rpm(2) must be larger that rpm(1).
#  Spindle range LOW will use spindle range, spindle range MEDIUM will use
#  spindle range 2 and spindle range HIGH will use spindle range 3  The variable
#  range_table_max_index  must set the number of entries in the table for that
#  range.
#
#  The default is for nine ranges and nine s codes per range.
#

   global mom_spindle_range  mom_spindle_speed mom_warning_info


   if {![info exist mom_spindle_range] } {set mom_spindle_range 1}
   if {$mom_spindle_range < 1} {set mom_spindle_range 1}

   if {$mom_spindle_range == 1 || $mom_spindle_range == "LOW"} {

#
# Spindle Range 1
#
      set rpm(0)         100    ; set scode(0)  1
      set rpm(1)         200    ; set scode(1)  2
      set rpm(2)         300    ; set scode(2)  3
      set rpm(3)         400    ; set scode(3)  4
      set rpm(4)         500    ; set scode(4)  5
      set rpm(5)         600    ; set scode(5)  6
      set rpm(6)         700    ; set scode(6)  7
      set rpm(7)         800    ; set scode(7)  8
      set rpm(8)         900    ; set scode(8)  9
      set rpm(9)        1000    ; set scode(9)  10
      set range_table_max_index 9

   } elseif {$mom_spindle_range == 2 || $mom_spindle_range == "MEDIUM"} { 
#
# Spindle Range 2
#
      set rpm(0)        1100    ; set scode(0)  11
      set rpm(1)        1200    ; set scode(1)  12
      set rpm(2)        1300    ; set scode(2)  13
      set rpm(3)        1400    ; set scode(3)  14
      set rpm(4)        1500    ; set scode(4)  15
      set rpm(5)        1600    ; set scode(5)  16
      set rpm(6)        1700    ; set scode(6)  17
      set rpm(7)        1800    ; set scode(7)  18
      set rpm(8)        1900    ; set scode(8)  19
      set rpm(9)        2000    ; set scode(9)  20
      set range_table_max_index 9

   } elseif {$mom_spindle_range == 3 || $mom_spindle_range == "HIGH"} { 
#
# Spindle Range 3
#
      set rpm(0)        2100    ; set scode(0)  21
      set rpm(1)        2200    ; set scode(1)  22
      set rpm(2)        2300    ; set scode(2)  23
      set rpm(3)        2400    ; set scode(3)  24
      set rpm(4)        2500    ; set scode(4)  25
      set rpm(5)        2600    ; set scode(5)  26
      set rpm(6)        2700    ; set scode(6)  27
      set rpm(7)        2800    ; set scode(7)  28
      set rpm(8)        2900    ; set scode(8)  29
      set rpm(9)        3000    ; set scode(9)  30
      set range_table_max_index 9

   } elseif {$mom_spindle_range == 4} {
#
# Spindle Range 4
#
      set rpm(0)        3100    ; set scode(0)  31
      set rpm(1)        3200    ; set scode(1)  32
      set rpm(2)        3300    ; set scode(2)  33
      set rpm(3)        3400    ; set scode(3)  34
      set rpm(4)        3500    ; set scode(4)  35
      set rpm(5)        3600    ; set scode(5)  36
      set rpm(6)        3700    ; set scode(6)  37
      set rpm(7)        3800    ; set scode(7)  38
      set rpm(8)        3900    ; set scode(8)  39
      set rpm(9)        4000    ; set scode(9)  40
      set range_table_max_index 9
  
   } elseif {$mom_spindle_range == 5} {
#
# Spindle Range 5
#
      set rpm(0)        4100    ; set scode(0)  41
      set rpm(1)        4200    ; set scode(1)  42
      set rpm(2)        4300    ; set scode(2)  43
      set rpm(3)        4400    ; set scode(3)  44
      set rpm(4)        4500    ; set scode(4)  45
      set rpm(5)        4600    ; set scode(5)  46
      set rpm(6)        4700    ; set scode(6)  47
      set rpm(7)        4800    ; set scode(7)  48
      set rpm(8)        4900    ; set scode(8)  49
      set rpm(9)        5000    ; set scode(9)  50
      set range_table_max_index 9

   } elseif {$mom_spindle_range == 6} {
#
# Spindle Range 6
#
      set rpm(0)        5100    ; set scode(0)  51
      set rpm(1)        5200    ; set scode(1)  52
      set rpm(2)        5300    ; set scode(2)  53
      set rpm(3)        5400    ; set scode(3)  54
      set rpm(4)        5500    ; set scode(4)  55
      set rpm(5)        5600    ; set scode(5)  56
      set rpm(6)        5700    ; set scode(6)  57
      set rpm(7)        5800    ; set scode(7)  58
      set rpm(8)        5900    ; set scode(8)  59
      set rpm(9)        6000    ; set scode(9)  60
      set range_table_max_index 9
 
   } elseif {$mom_spindle_range == 7} {
#
# Spindle Range 7
#
      set rpm(0)        6100    ; set scode(0)  61
      set rpm(1)        6200    ; set scode(1)  62
      set rpm(2)        6300    ; set scode(2)  63
      set rpm(3)        6400    ; set scode(3)  64
      set rpm(4)        6500    ; set scode(4)  65
      set rpm(5)        6600    ; set scode(5)  66
      set rpm(6)        6700    ; set scode(6)  67
      set rpm(7)        6800    ; set scode(7)  68
      set rpm(8)        6900    ; set scode(8)  69
      set rpm(9)        7000    ; set scode(9)  70
      set range_table_max_index 9
 
   } elseif {$mom_spindle_range == 8} {
#
# Spindle Range 8
#
      set rpm(0)        7100    ; set scode(0)  71
      set rpm(1)        7200    ; set scode(1)  72
      set rpm(2)        7300    ; set scode(2)  73
      set rpm(3)        7400    ; set scode(3)  74
      set rpm(4)        7500    ; set scode(4)  75
      set rpm(5)        7600    ; set scode(5)  76
      set rpm(6)        7700    ; set scode(6)  77
      set rpm(7)        7800    ; set scode(7)  78
      set rpm(8)        7900    ; set scode(8)  79
      set rpm(9)        8000    ; set scode(9)  80
      set range_table_max_index 9
 
   } elseif {$mom_spindle_range == 9} {
#
# Spindle Range 9
#
      set rpm(0)        8100    ; set scode(0)  81
      set rpm(1)        8200    ; set scode(1)  82
      set rpm(2)        8300    ; set scode(2)  83
      set rpm(3)        8400    ; set scode(3)  84
      set rpm(4)        8500    ; set scode(4)  85
      set rpm(5)        8600    ; set scode(5)  86
      set rpm(6)        8700    ; set scode(6)  87
      set rpm(7)        8800    ; set scode(7)  88
      set rpm(8)        8900    ; set scode(8)  89
      set rpm(9)        9000    ; set scode(9)  90
      set range_table_max_index 9
  
   } elseif {$mom_spindle_range == 10} {
#
# Spindle Range 10
#
      set rpm(0)        9100    ; set scode(0)  91
      set rpm(1)        9200    ; set scode(1)  92
      set rpm(2)        9300    ; set scode(2)  93
      set rpm(3)        9400    ; set scode(3)  94
      set rpm(4)        9500    ; set scode(4)  95
      set rpm(5)        9600    ; set scode(5)  96
      set rpm(6)        9700    ; set scode(6)  97
      set rpm(7)        9800    ; set scode(7)  98
      set rpm(8)        9900    ; set scode(8)  99
      set rpm(9)        10000   ; set scode(9)  100
      set range_table_max_index 9
 
   }


   set s_code $scode(0)

   if {$mom_spindle_speed  <  $rpm(0)} {
      set mom_warning_info "spindle speed under minimum, assumed minimum"
      MOM_catch_warning

   } elseif {$mom_spindle_speed  >  $rpm($range_table_max_index)} {
      set mom_warning_info "spindle speed over maximum, assumed maximum"
      MOM_catch_warning
      set s_code $scode($range_table_max_index)

   } else {
      for {set i 1} {$i  <=  $range_table_max_index} {incr i} {
         set max [expr ($rpm($i) +  $rpm([expr $i-1])) / 2.0]
         if {$mom_spindle_speed <=  $max} {
            set s_code $scode([expr $i-1])
            break
         }
      }
   }


   global mom_spindle_speed

   set mom_spindle_speed $s_code
}




