#===============================================================================
proc PB_CMD_map_new_iks_params { } {
#===============================================================================
# This command maps old offsets parameters to points & vectors for new IKS
# It should be called after the offsets of machine kinematics have been modified.
# ==> This command only affects multi-axis mill posts where new IKS is in use.
#
# 10-17-2013 gsl - (pb901) Initial release
#
  global mom_kin_iks_usage

  if { ![info exists mom_kin_iks_usage] || $mom_kin_iks_usage == 0 } {
return
  }

  global mom_kin_machine_type
  global mom_kin_spindle_axis
  global mom_kin_machine_zero_offset
  global mom_kin_4th_axis_center_offset mom_kin_5th_axis_center_offset
  global mom_kin_pivot_gauge_offset
  global mom_kin_4th_axis_point mom_kin_5th_axis_point
  global mom_kin_4th_axis_type mom_kin_5th_axis_type


  #<07-27-06 gsl> Disable new IKS parms for non-multi-axis post
   if { [string match "*wedm"  $mom_kin_machine_type] ||\
        [string match "*lathe" $mom_kin_machine_type] ||\
        [string match "*punch" $mom_kin_machine_type] ||\
        [string match "*3*"    $mom_kin_machine_type] } {

      foreach i { 0 1 2 } {
         set mom_kin_machine_zero_offset($i) 0.0
      }

      foreach axis { 4th 5th } {
         foreach i { 0 1 2 } {
            set mom_kin_${axis}_axis_center_offset($i) 0.0
            set mom_kin_${axis}_axis_point($i)         0.0
         }
      }

   } else {

      if ![string length [string trim $mom_kin_spindle_axis(0)]] {
         set mom_kin_spindle_axis(0) 0.0
      }
      if ![string length [string trim $mom_kin_spindle_axis(1)]] {
         set mom_kin_spindle_axis(1) 0.0
      }
      if ![string length [string trim $mom_kin_spindle_axis(2)]] {
         set mom_kin_spindle_axis(2) 1.0
      }

     # Define pivot-gauge vector per spindle axis vector
      foreach i { 0 1 2 } {
         set pg_vec($i) [expr $mom_kin_spindle_axis($i) * $mom_kin_pivot_gauge_offset]
      }

      if [string match "*4*" $mom_kin_machine_type] {

        # Init machine zero offset
         foreach i { 0 1 2 } {
            set mom_kin_machine_zero_offset($i) \
               [expr $pg_vec($i) + $mom_kin_4th_axis_center_offset($i)]
         }

         if [string match "Table" $mom_kin_4th_axis_type] {
            foreach i { 0 1 2 } {
               set mom_kin_4th_axis_point($i) $mom_kin_machine_zero_offset($i)
            }
         } else {
            foreach i { 0 1 2 } {
               set mom_kin_4th_axis_point($i) $pg_vec($i)
            }
         }

        # Init 5th point to zeros
         foreach i { 0 1 2 } {
            set mom_kin_5th_axis_point($i) 0.0
         }

        # Map axis of rotation vector
         SetPlaneNormalVector 4TH_AXIS

      } elseif [string match "*5*" $mom_kin_machine_type] {

         set machine_kin "HH"
         switch $mom_kin_4th_axis_type {
            Head  {
               switch $mom_kin_5th_axis_type {
                  Head  {
                  }
                  Table {
                     set machine_kin "HT"
                  }
               }
            }
            Table {
               switch $mom_kin_5th_axis_type {
                  Head  {
                     set machine_kin "TH"
                  }
                  Table {
                     set machine_kin "TT"
                  }
               }
            }
         }

        # Init machine zero offset
         foreach i { 0 1 2 } {
            set mom_kin_machine_zero_offset($i) \
                [expr $pg_vec($i) + $mom_kin_4th_axis_center_offset($i) + \
                                    $mom_kin_5th_axis_center_offset($i)]
         }

         switch $machine_kin {
            "HH" {
               foreach i { 0 1 2 } {
                  set mom_kin_4th_axis_point($i) \
                      [expr $pg_vec($i) + $mom_kin_4th_axis_center_offset($i)]

                  set mom_kin_5th_axis_point($i) $pg_vec($i)
               }
            }
            "HT" {
               foreach i { 0 1 2 } {
                  set mom_kin_4th_axis_point($i) $pg_vec($i)
                  set mom_kin_5th_axis_point($i) $mom_kin_machine_zero_offset($i)
               }
            }
            "TH" {
               foreach i { 0 1 2 } {
                  set mom_kin_5th_axis_point($i) $pg_vec($i)
                  set mom_kin_4th_axis_point($i) $mom_kin_machine_zero_offset($i)
               }
            }
            "TT" {
               foreach i { 0 1 2 } {
                  set mom_kin_4th_axis_point($i) \
                      [expr $pg_vec($i) + $mom_kin_4th_axis_center_offset($i)]

                  set mom_kin_5th_axis_point($i) $mom_kin_machine_zero_offset($i)
               }
            }
         }

        # Map axis of rotation vectors
         SetPlaneNormalVector 4TH_AXIS
         SetPlaneNormalVector 5TH_AXIS
      }
   }

  # Update all kin vars
   MOM_reload_kinematics
}

#-------------------------------------------------------------------------------
proc SetPlaneNormalVector { axis_type } {
#-------------------------------------------------------------------------------
  global mom_kin_4th_axis_plane mom_kin_5th_axis_plane
  global mom_kin_4th_axis_vector mom_kin_5th_axis_vector


   if [string match "4TH_AXIS" $axis_type] {
      set plane $mom_kin_4th_axis_plane
   } else {
      set plane $mom_kin_5th_axis_plane
   }

   switch $plane {
      "XY" {
         set vi 0
         set vj 0
         set vk 1
      }
      "YZ" {
         set vi 1
         set vj 0
         set vk 0
      }
      "ZX" {
         set vi 0
         set vj 1
         set vk 0
      }
      default {
        # Skip settting of non-orthogonal axis
return
      }
   }

   if [string match "4TH_AXIS" $axis_type] {
      set mom_kin_4th_axis_vector(0) $vi
      set mom_kin_4th_axis_vector(1) $vj
      set mom_kin_4th_axis_vector(2) $vk
   } else {
      set mom_kin_5th_axis_vector(0) $vi
      set mom_kin_5th_axis_vector(1) $vj
      set mom_kin_5th_axis_vector(2) $vk
   }
}

