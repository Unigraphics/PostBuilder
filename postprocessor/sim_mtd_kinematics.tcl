##############################################################################
# Description
#     This file contains functions to set the MOM POST kinematics
#     data based on the kinematics model. This should be done as
#     part of the other machine tool driver setting for simulation.
#     This file is intended to replace the manual setting that is 
#     currently done for those parameters. Currently NOT all POST
#     kinematics parameters are set by the functions in this file.
#     At this point the primary focus of the functions is on setting
#     the geometric characteristics of the kinematics parameters.
#
#     The following are the parameters that are currently set. The other
#     parameters need to be set PRIOR to calling SIM_set_post_kinematics 
#
#               mom_kin_x_axis_limit                    
#               mom_kin_y_axis_limit                  
#               mom_kin_z_axis_limit                      
#
#               mom_kin_4th_axis_plane  
#               mom_kin_4th_axis_vector  
#               mom_kin_4th_axis_center_offset 
#               mom_kin_4th_axis_min_limit 
#               mom_kin_4th_axis_max_limit 
#
#               mom_kin_5th_axis_plane  
#               mom_kin_5th_axis_vector  
#               mom_kin_5th_axis_center_offset 
#               mom_kin_5th_axis_min_limit 
#               mom_kin_5th_axis_max_limit 
#
#               mom_kin_5th_axis_inclination_to_4th 
#               mom_kin_pivot_gauge_offset   
#               mom_kin_gauge_to_pivot      
#
#
# Revisions
#
#   Date        Who            Reason
# 31-Oct-2001   Yakove Dayan   First Version
# 20-Jul-2002   Yakove Dayan   Comment setting global sim_4th_axis and sim_5th_axis
#                              check for debug
# 13-May-2003   Nusrat Hamid   Corrected the calculation for 5th Axis centre offset
# 15-Sep-2003   Jeremy Wight   PR4794927 - don't change kinematics for tables
# 21-Jan-2004   Vladimir Davydov Temporary suppress center offsets calculation. 
# 09-Mar-2006  Tammy Baxter            No code changes made (p4 writer issue)
#                        
#
# $HISTORY$
#
###############################################################################

#
# Function: SIM_set_post_kinematics
# 
# This functions retrieve the kinematics model the kinematics data 
# and set the mom post global kinematics parameters accordingly. 
#
# Arguments:
#   ref_jct  - this is a reference junction used to compute offset and
#              rotary axis and planes. The 4th and 5th rotation axis, 
#              rotation plane and offsets are defined i.r.t this junction. 
#              For example:
#              o for 5 axis with two rotary tables. this junction reference
#                a junction defined where the program zero junction (MCS) is
#                defined. Normaly this will be at the origin of the 4th axis
#                degree of freedom axis.
#              o for 5 axis with two heads, this is a reference to a junction
#                defined where the 4th axis DOF is defined. 
#
#   X_axis   - logical name of the X axis  used for setting limits only
#   Y_axis   - logical name of the Y axis  used for setting limits only
#   Z_axis   - logical name of the Z axis  used for setting limits only
#   4th_axis(optional) - logical name of the 4th axis degree of freedom
#   5th_axis(optional) - name of the 5th axis degree of freedom
#   pivot_jct(optional)- the pivot junction
#   gauge_jct(optional)- the gauge junction
#          the pivot and gauge junctions are used to compute the offset 
#          that is added to Z offset and translate the tool tip point
#          to the pivot point. In this case the G codes coordinates drive the
#          pivot point not the tool tip.         
#      
# Note:
#    o this setting is intended mainly for 5-axis table-table configuration. but
#      could be also used with corresponding changes for other machine tool 
#      configuration.
#    o there are some other  kinematics variables that need to be set
#      outside to this function. This function focuses primarily on
#      the geometry setting
#
#=============================================================
proc SIM_set_post_kinematics { ref_jct X_axis Y_axis Z_axis {4th_axis ""} {5th_axis ""} {pivot_jct ""} {gauge_jct ""} } {
#=============================================================

  global mom_sim_result 
  global mom_sim_result1
#  global sim_4th_axis sim_5th_axis                     

  global mom_kin_machine_type      #type like  lathe,5_axis_dual_table,5_axis_dual_head,5_axis_head_table, 4_axis_head, ...          
  global mom_kin_x_axis_limit                    
  global mom_kin_y_axis_limit                  
  global mom_kin_z_axis_limit 

  global mom_kin_4th_axis_plane          # plane of rotation e.g. XY, YZ, XZ or none 
  global mom_kin_4th_axis_vector         # axis of rotation i.r.t MCS 
#  global mom_kin_4th_axis_angles         # define axis of rotation in angles instead of vector
  global mom_kin_4th_axis_center_offset  # location of center of rotation i.r.t. MCS 
  global mom_kin_4th_axis_min_limit 
  global mom_kin_4th_axis_max_limit 
#  global mom_kin_4th_axis_min_incr 
#  global mom_kin_4th_axis_direction       # determines how to move from angle1 to angle2. e.g ALWAYS_SHORTEST  
#  global mom_kin_4th_axis_zero            # angular offset automatically added to angle 
  global mom_kin_4th_axis_rotation        # standard or reverse direction
  global mom_kin_4th_axis_type            # axis type e.g. Table or Head 

  global mom_kin_5th_axis_plane 
  global mom_kin_5th_axis_vector 
#  global mom_kin_5th_axis_angles 
  global mom_kin_5th_axis_center_offset
#  global mom_kin_5th_axis_min_incr 
  global mom_kin_5th_axis_min_limit 
  global mom_kin_5th_axis_max_limit 
#  global mom_kin_5th_axis_direction 
#  global mom_kin_5th_axis_zero 
  global mom_kin_5th_axis_rotation 
  global mom_kin_5th_axis_type

  global mom_kin_5th_axis_inclination_to_4th # angle in degrees between 5th and 4th axis  

  global mom_kin_pivot_gauge_offset   # Z offset between gauge point and pivot point  
  global mom_kin_gauge_to_pivot       # if we have more than one Z offset  
  global sim_cfg_debug

  set PI      [expr { atan(1.0)*4.0 } ]
  set PI2DEG  [expr { 180.0/$PI }]

#  set sim_4th_axis $4th_axis
#  set sim_5th_axis $5th_axis

#
#==============  SET linear axes  ==============
#

  # map logical axes to phisical axes
  set x_ph [ SIM_map_logical_to_phisical_axis $X_axis ]
  set y_ph [ SIM_map_logical_to_phisical_axis $Y_axis ]
  set z_ph [ SIM_map_logical_to_phisical_axis $Z_axis ]

  # set axes limits
  SIM_ask_axis_limits $x_ph
  set mom_kin_x_axis_limit $mom_sim_result 

  SIM_ask_axis_limits $y_ph
  set mom_kin_y_axis_limit  $mom_sim_result 

  SIM_ask_axis_limits $z_ph
  set mom_kin_z_axis_limit  $mom_sim_result 


   #
   #----- compute Z offset between gauge point to pivot point.
   #
   if { $pivot_jct != "" && $gauge_jct != "" } {

     set vector [ SIM_ask_offsets_mtcs $pivot_jct $gauge_jct INITIAL ]

     for {set i 0} {$i<3} {incr i} {
       set value [lindex $vector  $i]
       set mom_kin_gauge_to_pivot($i)  $value 
     }
    
     set mom_kin_pivot_gauge_offset [expr { abs($mom_kin_gauge_to_pivot(2)) }] 
     
   } else {
     set mom_kin_gauge_to_pivot(0) 0.0
     set mom_kin_gauge_to_pivot(1) 0.0
     set mom_kin_gauge_to_pivot(2) 0.0

     set mom_kin_pivot_gauge_offset 0.0
   }

  if { $4th_axis == "" } {
      return
  }
#
#==============  SET 4th axis setting  ==============
#

  # first map logical to phisical axis
  set 4th_ph [ SIM_map_logical_to_phisical_axis $4th_axis ]

  #
  #--- set axis limits
  #
  SIM_ask_axis_limits $4th_ph
  set mom_kin_4th_axis_max_limit $mom_sim_result 
  set mom_kin_4th_axis_min_limit $mom_sim_result1 

  #
  #---- set axis vector of rotation i.r.t. $4th_jct coordinate system
  #
  SIM_ask_axis_dof_junction $4th_ph
  set 4th_jct $mom_sim_result
  set 4th_num $mom_sim_result1

  set vector [list 0.0 0.0 0.0 ]
  if { $4th_num > 0 } {
     incr 4th_num -1
     set  n 1.0
  } else {
     incr 4th_num 1
     set n -1.0
     set 4th_num [expr $4th_num * -1]
  }
 
  set vector [lreplace $vector $4th_num $4th_num $n]
  
  # transform vector to ref_jct and make it unit vector
  set axis_vec [ SIM_transform_vector $vector $4th_jct $ref_jct INITIAL INITIAL] 

  set 4th_axis_nvec [ MOM_SIM_VNormL $axis_vec ]

  for {set i 0} {$i<3} {incr i} {
       set mom_kin_4th_axis_vector($i)  [lindex $4th_axis_nvec  $i]
  }

  #
  #----- set offset of center of rotation from MCS (ref_jct)
  #
  # TEMPORARY: set the offset to zero until we find out what the post processor expects. 
  #      [Vladimir Davydov 01/21/04]
  #
  set point [list 0.0 0.0 0.0 ]
  set center_offset [ SIM_transform_point $point $4th_jct $ref_jct INITIAL INITIAL] 
  for {set i 0} {$i<3} {incr i} {
       set value [lindex $center_offset  $i]
       set mom_kin_4th_axis_center_offset($i) 0
       #$value 
  }
  
  #
  #--- define rotation plane type
  set mom_kin_4th_axis_plane NONE

  set X_vec   [list 1.0 0.0 0.0]
  set cosA    [expr {abs ([ MOM_SIM_VMultiplyL $X_vec $4th_axis_nvec])} ]
  set dOne    [expr {$cosA - 1.0 }]
  if { [expr abs($dOne) ] < 0.000001 } {
     set mom_kin_4th_axis_plane YZ
  }

  if {$mom_kin_4th_axis_plane == "NONE" } {
    set Y_vec   [list 0.0 1.0 0.0]
    set cosA    [expr {abs ([ MOM_SIM_VMultiplyL $Y_vec $4th_axis_nvec])} ]
    set dOne    [expr {$cosA - 1.0 }]
    if { [ expr abs($dOne) ] < 0.000001 } {
     set mom_kin_4th_axis_plane ZX
    }
  }

  if {$mom_kin_4th_axis_plane == "NONE" } {
    set Z_vec   [list 0.0 0.0 1.0]
    set cosA    [expr {abs ([ MOM_SIM_VMultiplyL $Z_vec $4th_axis_nvec])} ]
    set dOne    [expr {$cosA - 1.0 }]
    if { [expr abs($dOne)]< 0.000001 } {
     set mom_kin_4th_axis_plane XY
    }
  }


  #
  #------ for now, the following data cannot be retrieved from KIM, but
  #       could change in the future
  #
  #set mom_kin_4th_axis_min_incr   0.001

  # determines how to move from angle1 to angle2. e.g ALWAYS_SHORTEST 
  #set mom_kin_4th_axis_direction      SIGN_DETERMINES_DIRECTION
  
  # direction of axis standard or reverse 
  #set mom_kin_4th_axis_rotation        standard

  #  angular offset automatically added (by controller) to rotation angle
  #set mom_kin_4th_axis_zero            0.0


  # head type Head or Table. retrieve the system class
  # of axis owning component
  #set mom_kin_4th_axis_type            "Table"

#
#==============  SET 5th axis setting  ==============
#

  if { $5th_axis == "" } {
      return
  }

  # first map logical to phisical axis
  set 5th_ph [ SIM_map_logical_to_phisical_axis $5th_axis ]

  #
  #--- set axis limits
  #
  SIM_ask_axis_limits $5th_ph
  set mom_kin_5th_axis_max_limit $mom_sim_result 
  set mom_kin_5th_axis_min_limit $mom_sim_result1 

  #
  #---- set axis vector of rotation i.r.t. $5th_jct coordinate system
  #
  SIM_ask_axis_dof_junction $5th_ph
  set 5th_jct $mom_sim_result
  set 5th_num $mom_sim_result1
  
  set vector [list 0.0 0.0 0.0 ]
  if { $5th_num > 0 } {
     incr 5th_num -1
     set  n 1.0
  } else {
     incr 5th_num 1
     set n -1.0
     set 5th_num [expr $5th_num * -1]
  }

  set vector [lreplace $vector $5th_num $5th_num $n]

  # transform vector to ref_jct and make it unit vector
  set axis_vec [ SIM_transform_vector $vector $5th_jct $ref_jct INITIAL INITIAL] 

  set 5th_axis_nvec [ MOM_SIM_VNormL $axis_vec ]

  for {set i 0} {$i<3} {incr i} {
       set mom_kin_5th_axis_vector($i)  [lindex $5th_axis_nvec  $i]
  }
 
  #
  #----- set offset of center of rotation from MCS (ref_jct)
  #
  set point [list 0.0 0.0 0.0 ]
  
  # 
  # NOTE: The line below used to be
  #   set center_offset [ SIM_transform_point $point $5th_jct $ref_jct INITIAL INITIAL] 
  # I have Changed it to be the offset from the the '4th_jct' and not from the 'ref_jct'
  # This is what the post_processor expects. [Nusrat Hamid 05/13/03]
  # TEMPORARY: set the offset to zero until we find out what the post processor expects. 
  #            [Vladimir Davydov 01/21/04]
  # 
  set center_offset [ SIM_transform_point $point $5th_jct $4th_jct INITIAL INITIAL] 
  for {set i 0} {$i<3} {incr i} {
       set value [lindex $center_offset  $i]
       set mom_kin_5th_axis_center_offset($i)  0
       # $value 
  }
  
  #
  #--- define rotation plane type
  set mom_kin_5th_axis_plane NONE

  set X_vec   [list 1.0 0.0 0.0]
  set cosA    [expr {abs ([ MOM_SIM_VMultiplyL $X_vec $5th_axis_nvec])} ]
  set dOne    [expr {$cosA - 1.0 }]
  if { [expr abs($dOne) ] < 0.000001 } {
     set mom_kin_5th_axis_plane YZ
  }

  if {$mom_kin_5th_axis_plane == "NONE" } {
    set Y_vec   [list 0.0 1.0 0.0]
    set cosA    [expr {abs ([ MOM_SIM_VMultiplyL $Y_vec $5th_axis_nvec])} ]
    set dOne    [expr {$cosA - 1.0 }]
    if { [ expr abs($dOne) ] < 0.000001 } {
     set mom_kin_5th_axis_plane ZX
    }
  }

  if {$mom_kin_5th_axis_plane == "NONE" } {
    set Z_vec   [list 0.0 0.0 1.0]
    set cosA    [expr {abs ([ MOM_SIM_VMultiplyL $Z_vec $5th_axis_nvec])} ]
    set dOne    [expr {$cosA - 1.0 }]
    if { [expr abs($dOne)]< 0.000001 } {
     set mom_kin_5th_axis_plane XY
    }
  }

  #
  #------ for now, the following data cannot be retrieved from KIM, but
  #       could change in the future
  #
  #set mom_kin_5th_axis_min_incr   0.001

  # determines how to move from angle1 to angle2. e.g ALWAYS_SHORTEST 
  #set mom_kin_5th_axis_direction      SIGN_DETERMINES_DIRECTION
  
  # direction of axis standard or reverse 
  #set mom_kin_5th_axis_rotation        standard

  #  angular offset automatically added (by controller) to rotation angle
  #set mom_kin_5th_axis_zero            0.0


  # head type Head or Table. retrieve the system class
  # of axis owning component
  #set mom_kin_5th_axis_type            "Table"

#
#==============  SET other 5-axis setting  ==============
#

 #
 #---- find the angle between the two vectors of rotation.
 #     note: it is assumed that the vectors are unit vector
 # 
 set cosAng [ MOM_SIM_VMultiplyL $4th_axis_nvec $5th_axis_nvec]
 set mom_kin_5th_axis_inclination_to_4th [ expr { acos($cosAng) * $PI2DEG } ]

 #
 #----------------- output setting -----------------
 # 
 if {[info exists sim_cfg_debug]} {
   SIM_dbg_write_message " "
   SIM_dbg_write_message "NOTE: the following TCL variables have been set by simulation driver:"
   SIM_dbg_write_message " "

   SIM_dbg_write_message " mom_kin_x_axis_limit  =$mom_kin_x_axis_limit"  
   SIM_dbg_write_message " mom_kin_y_axis_limit  =$mom_kin_y_axis_limit"                 
   SIM_dbg_write_message " mom_kin_z_axis_limit  =$mom_kin_z_axis_limit"                  

   SIM_dbg_write_message " mom_kin_pivot_gauge_offset =$mom_kin_pivot_gauge_offset"

   SIM_dbg_write_message " mom_kin_gauge_to_pivot(0)  =$mom_kin_gauge_to_pivot(0)"   
   SIM_dbg_write_message " mom_kin_gauge_to_pivot(1)  =$mom_kin_gauge_to_pivot(1)" 
   SIM_dbg_write_message " mom_kin_gauge_to_pivot(2)  =$mom_kin_gauge_to_pivot(2)"

   SIM_dbg_write_message " mom_kin_4th_axis_plane     =$mom_kin_4th_axis_plane" 
   SIM_dbg_write_message " mom_kin_4th_axis_vector(0) =$mom_kin_4th_axis_vector(0)"
   SIM_dbg_write_message " mom_kin_4th_axis_vector(1) =$mom_kin_4th_axis_vector(1)"  
   SIM_dbg_write_message " mom_kin_4th_axis_vector(2) =$mom_kin_4th_axis_vector(2)" 
   SIM_dbg_write_message " mom_kin_4th_axis_min_limit        =$mom_kin_4th_axis_min_limit"
   SIM_dbg_write_message " mom_kin_4th_axis_max_limit        =$mom_kin_4th_axis_max_limit"
   SIM_dbg_write_message " mom_kin_4th_axis_center_offset(0) =$mom_kin_4th_axis_center_offset(0)" 
   SIM_dbg_write_message " mom_kin_4th_axis_center_offset(1) =$mom_kin_4th_axis_center_offset(1)"
   SIM_dbg_write_message " mom_kin_4th_axis_center_offset(2) =$mom_kin_4th_axis_center_offset(2)"  

   SIM_dbg_write_message " mom_kin_5th_axis_plane     =$mom_kin_5th_axis_plane" 
   SIM_dbg_write_message " mom_kin_5th_axis_vector(0) =$mom_kin_5th_axis_vector(0)"
   SIM_dbg_write_message " mom_kin_5th_axis_vector(1) =$mom_kin_5th_axis_vector(1)"  
   SIM_dbg_write_message " mom_kin_5th_axis_vector(2) =$mom_kin_5th_axis_vector(2)" 
   SIM_dbg_write_message " mom_kin_5th_axis_min_limit        =$mom_kin_5th_axis_min_limit"
   SIM_dbg_write_message " mom_kin_5th_axis_max_limit        =$mom_kin_5th_axis_max_limit"
   SIM_dbg_write_message " mom_kin_5th_axis_center_offset(0) =$mom_kin_5th_axis_center_offset(0)" 
   SIM_dbg_write_message " mom_kin_5th_axis_center_offset(1) =$mom_kin_5th_axis_center_offset(1)"
   SIM_dbg_write_message " mom_kin_5th_axis_center_offset(2) =$mom_kin_5th_axis_center_offset(2)"  
   SIM_dbg_write_message " mom_kin_5th_axis_inclination_to_4th =$mom_kin_5th_axis_inclination_to_4th"      
   SIM_dbg_write_message " mom_kin_4th_axis_rotation = $mom_kin_4th_axis_rotation " 
   SIM_dbg_write_message " mom_kin_5th_axis_rotation = $mom_kin_5th_axis_rotation " 
 }

}
