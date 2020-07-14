##############################################################
# This file is used to output ini file for CSE simulaiton. It
# should be sourced in postprocessor as a user tcl file.
#
##############################################################

proc ISV_ini_convert_unit {var} {
   global mom_kin_output_unit
   global mom_part_units
   if {![info exists mom_part_units]} {
return
   }
   upvar 1 $var value
   if {[string compare $mom_part_units "metric"]} {
      set value [expr $value * 25.4]
   }
}
     
     
#----------------------------------------------------------------
#Return the type num for tool;
#default mill tool 121;
#default lathe tool 500;
#default drill tool 200.
#----------------------------------------------------------------
proc ISV_ini_map_tool_type {tool_index} {
   global mom_tool_ug_subtype
   global mom_tool_ug_type
   global mom_tool_diameter
   global mom_tool_length
   global mom_tool_corner1_radius
   global mom_tool_taper_angle mom_tool_name mom_tool_tip_angle
		 
   global mom_isv_tool_type
   global mom_isv_tool_diameter
   global mom_isv_tool_x_correction
   global mom_isv_tool_r_correction
   global mom_isv_tool_corner1_radius
   global mom_isv_tool_point_angle
   
   switch $mom_isv_tool_type($tool_index) {
      "Milling" {       
          if { [info exists mom_isv_tool_corner1_radius($tool_index)] && $mom_isv_tool_corner1_radius($tool_index) > 0.0 } {
          #121 End mill (with fillet)
   return 121
          } else {
          #120 End mill (without fillet)
   return 120
          }            
      }
      "Drilling" {
   return 200
      }
      "Turning" {
   return 500
      }
      "Grooving" {
   return 520
      }
      "Threading" {
   return 540
      }
      default {
   return 100
      }
   }
}
      
#=============================================================
proc ISV_ini_get_mcs_info { } {
#=============================================================
   
   global mom_sys_tool_list_output_type
   global isv_ini_mcs_info
   global mom_kin_output_unit
   global mom_part_unit
   global mom_operation_name_list
   global mom_mcsname_attach_opr
   global mom_mcs_info
   
   catch {MOM_ask_mcs_info}
   #get operations' mcs list
   set mcs_list [list]
   if {[info exists mom_operation_name_list]} {
      foreach operation $mom_operation_name_list {
         if {[llength $mcs_list] == 0} {
            lappend mcs_list $mom_mcsname_attach_opr($operation)
         } else {
            set flag 0
            foreach mcs_name $mcs_list {				   
               if {[string match $mcs_name $mom_mcsname_attach_opr($operation)]} { set flag 1}			   
            } 
            if {$flag ==0} {
               lappend mcs_list $mom_mcsname_attach_opr($operation)
            } 	   
         }		   
      }
   } 
   
 
   # get Machine zero matrix and origin
   global mom_sim_result mom_sim_result1
   catch {MOM_ask_machine_zero_junction_name}
   if {[info exists mom_sim_result] && $mom_sim_result != ""} {
      MOM_ask_init_junction_xform $mom_sim_result
   } else {
      MOM_output_to_listing_device "No machine zero junction!"
   return
   }
 
   set i 0
   foreach value $mom_sim_result {
      set main_mcs_matrix($i) $value
      incr i
   }
   
   set i 0
   foreach value $mom_sim_result1 {
      set main_mcs_origin($i) $value
      incr i
   }
    

   #get fixture MCS list
   set fixture_list [list]
   foreach mcs $mcs_list {
     # MOM_output_to_listing_device "[info exists mom_mcs_info($mcs,offset_val)]"
     # MOM_output_to_listing_device "parent [info exists mom_mcs_info($mom_mcs_info($mcs,parent),offset_val)]"

     #<lili 2013-05-01> Update conditions to get fixture offset coordinate name
     #                  Related to PR6845685, cannot use  $mom_mcs_info($mom_mcs_info($mcs,parent),offset_val)!=0
      while { $mcs != "" && $mom_mcs_info($mcs,parent) != "" && $mom_mcs_info($mcs,purpose)==0 && $mom_mcs_info($mcs,output_type)!=2 } {
         set mcs $mom_mcs_info($mcs,parent)
      }

      if {$mcs != "" && $mom_mcs_info($mcs,purpose)==0 && $mom_mcs_info($mcs,output_type)==2} {
         if {[llength $fixture_list]==0} {         
            lappend fixture_list $mcs
         } else {	 
            set flag 0
            foreach fixture $fixture_list {
               if {![string compare $fixture $mcs]} {set flag 1}
            }
            if {$flag ==0} {
               lappend fixture_list $mcs
            } 
         }
      }
   }
 
   global ini_file_channel_number
   set isv_ini_mcs_info(0) ""
   set isv_ini_mcs_info(1) ""
   set isv_ini_mcs_info(2) ""
   if {[info exists ini_file_channel_number] && $ini_file_channel_number ==2} {
      append isv_ini_mcs_info(1) "\n\$P_UIFR\[0\]=CTRANS(X1,0.0,Y1,0.0,Z1,0.0)\n"
      append isv_ini_mcs_info(2) "\n\$P_UIFR\[0\]=CTRANS(X2,0.0,Z2,0.0)\n"
   } else {
      append isv_ini_mcs_info(0) "\n\$P_UIFR\[0\]=CTRANS(X,0.0,Y,0.0,Z,0.0)\n"
   }
   

   foreach mcs $fixture_list {     
      #Convert offset from ABS to Machine MCS
      set origin_v(0) [expr $mom_mcs_info($mcs,org,0) - $main_mcs_origin(0)]
      set origin_v(1) [expr $mom_mcs_info($mcs,org,1) - $main_mcs_origin(1)]
      set origin_v(2) [expr $mom_mcs_info($mcs,org,2) - $main_mcs_origin(2)]
      MTX3_vec_multiply origin_v main_mcs_matrix temp_offset 

      #<lili 2013-06-20> Update unit convertion for origin offset
      global mom_output_unit
      if {$mom_output_unit == "IN"} {
         set temp_x_offset [format "%-.6f" [expr 25.4*$temp_offset(0)]]
         set temp_y_offset [format "%-.6f" [expr 25.4*$temp_offset(1)]]
         set temp_z_offset [format "%-.6f" [expr 25.4*$temp_offset(2)]]
      } else {
         set temp_x_offset [format "%-.6f" $temp_offset(0)]
         set temp_y_offset [format "%-.6f" $temp_offset(1)]
         set temp_z_offset [format "%-.6f" $temp_offset(2)]
      }
        
      if {[info exists ini_file_channel_number] && $ini_file_channel_number ==2} {
         append isv_ini_mcs_info(1) "\$P_UIFR\[$mom_mcs_info($mcs,offset_val)\]=CTRANS(X1,$temp_x_offset,Y1,$temp_y_offset,Z1,$temp_z_offset)\n"
         append isv_ini_mcs_info(2) "\$P_UIFR\[$mom_mcs_info($mcs,offset_val)\]=CTRANS(X2,$temp_x_offset,Z2,$temp_z_offset)\n"
      } else {
         append isv_ini_mcs_info(0) "\$P_UIFR\[$mom_mcs_info($mcs,offset_val)\]=CTRANS(X,$temp_x_offset,Y,$temp_y_offset,Z,$temp_z_offset)\n"
      }
   }
}

#=============================================================
proc ISV_ini_get_tool_info { } {
#=============================================================
   global mom_isv_tool_count
   global mom_isv_tool_name
   global mom_isv_tool_type
   global mom_isv_tool_number
   global mom_isv_tool_carrier_id
   global mom_isv_tool_type
   global mom_isv_tool_flute_length
   global mom_isv_tool_x_correction
   global mom_isv_tool_y_correction
   global mom_isv_tool_z_correction
   global mom_isv_tool_r_correction
   global mom_isv_tool_carrier_name
   global mom_isv_tool_pocket_id
   global mom_isv_tool_diameter
   global mom_isv_tool_nose_radius
   global mom_isv_tool_corner1_radius
   global mom_isv_tool_adjust_register
   global mom_isv_tracking_point_count
   global isv_ini_tool_info 
   global isv_ini_tool_count
   global mom_isv_tool_channel_id
   global mom_isv_tool_p_number
   global mom_multi_channel_mode
   
   set isv_ini_tool_count(0) 0
   set isv_ini_tool_count(1) 0
   set isv_ini_tool_count(2) 0
   
   set isv_ini_tool_info(0) [list]
   set isv_ini_tool_info(1) [list]
   set isv_ini_tool_info(2) [list]

   for {set i 0} {$i<$mom_isv_tool_count} {incr i} {
       set tool_info ""  
       append tool_info "\$TC_TP1\[$mom_isv_tool_number($i)\]=$mom_isv_tool_number($i)\n"
       append tool_info "\$TC_TP2\[$mom_isv_tool_number($i)\]=\"$mom_isv_tool_name($i)\"\n"	
       append tool_info "\$TC_TP8\[$mom_isv_tool_number($i)\]=10\n"

       if {$mom_isv_tracking_point_count($i)==0} {set mom_isv_tracking_point_count($i) 1}
       for {set j 0} {$j<$mom_isv_tracking_point_count($i)} {incr j} {
          if {![info exists mom_isv_tool_adjust_register($i,$j)]} {set mom_isv_tool_adjust_register($i,$j) 1}
          append tool_info "\$TC_DP1\[$mom_isv_tool_number($i),$mom_isv_tool_adjust_register($i,$j)\]=[ISV_ini_map_tool_type $i]\n" 
           if {([string match "Milling" $mom_isv_tool_type($i)] ||[string match "Drilling" $mom_isv_tool_type($i)]) && \
              [info exists mom_isv_tool_flute_length($i)] } {
             set temp $mom_isv_tool_flute_length($i)
             catch {ISV_ini_convert_unit temp}
             set temp [format "%-.4f" $temp]
             append tool_info "\$TC_DP2\[$mom_isv_tool_number($i),$mom_isv_tool_adjust_register($i,$j)\]=$temp\n"
          } elseif {[info exists mom_isv_tool_p_number($i,$j)]} {
             append tool_info "\$TC_DP2\[$mom_isv_tool_number($i),$mom_isv_tool_adjust_register($i,$j)\]=$mom_isv_tool_p_number($i,$j)\n"
          }
          if { [info exists mom_isv_tool_x_correction($i,$j)] } {
             set temp $mom_isv_tool_x_correction($i,$j)
             catch {ISV_ini_convert_unit temp}
             set temp [format "%-.4f" $temp]
             append tool_info "\$TC_DP3\[$mom_isv_tool_number($i),$mom_isv_tool_adjust_register($i,$j)\]=$temp\n"
          }
          if { [info exists mom_isv_tool_y_correction($i,$j)] } {
             set temp $mom_isv_tool_y_correction($i,$j)
             catch {ISV_ini_convert_unit temp}
             set temp [format "%-.4f" $temp]
             append tool_info "\$TC_DP4\[$mom_isv_tool_number($i),$mom_isv_tool_adjust_register($i,$j)\]=$temp\n"
          }
          if { [info exists mom_isv_tool_z_correction($i,$j)] } {
             set temp $mom_isv_tool_z_correction($i,$j)
             catch {ISV_ini_convert_unit temp}
             set temp [format "%-.4f" $temp]
             append tool_info "\$TC_DP5\[$mom_isv_tool_number($i),$mom_isv_tool_adjust_register($i,$j)\]=$temp\n"
          }
          if {([string match "Milling" $mom_isv_tool_type($i)] ||[string match "Drilling" $mom_isv_tool_type($i)]) && \
              [info exists mom_isv_tool_r_correction($i,$j)]} {
             set temp $mom_isv_tool_r_correction($i,$j)
             catch {ISV_ini_convert_unit temp}
             set temp [format "%-.4f" $temp]
             append tool_info "\$TC_DP6\[$mom_isv_tool_number($i),$mom_isv_tool_adjust_register($i,$j)\]=$temp\n"
          } elseif {[info exists mom_isv_tool_nose_radius($i)]} {
             set temp $mom_isv_tool_nose_radius($i)
             catch {ISV_ini_convert_unit temp }
             set temp [format "%-.4f" $temp]
             append tool_info "\$TC_DP6\[$mom_isv_tool_number($i),$mom_isv_tool_adjust_register($i,$j)\]=$temp\n"
          }
          if { [info exists mom_isv_tool_corner1_radius($i)] } {
             set temp $mom_isv_tool_corner1_radius($i)
             catch {ISV_ini_convert_unit temp}
             set temp [format "%-.4f" $temp]
             append tool_info "\$TC_DP7\[$mom_isv_tool_number($i),$mom_isv_tool_adjust_register($i,$j)\]=$temp\n"
          }
       }
       #<lili 2013-06-20> Fix below check condition. 
       if {![info exists mom_isv_tool_pocket_id($i)] || [string length [string trim $mom_isv_tool_pocket_id($i)]] == 0 || \
            $mom_isv_tool_pocket_id($i) == "n/a" } {
          append tool_info "\$TC_MPP6\[1,1\]=$mom_isv_tool_number($i)\n\n\n"
       } else {
          append tool_info "\$TC_MPP6\[1,$mom_isv_tool_pocket_id($i)\]=$mom_isv_tool_number($i)\n\n\n"
       }
       if {$mom_isv_tool_channel_id($i) == 1} {
          append isv_ini_tool_info(1) $tool_info
          incr isv_ini_tool_count(1)
       } elseif {$mom_isv_tool_channel_id($i) == 2} {
          append isv_ini_tool_info(2) $tool_info
          incr isv_ini_tool_count(2)
       } else {
          append isv_ini_tool_info(0) $tool_info
          incr isv_ini_tool_count(0)
       }
   }

   global ini_file_channel_number
   if {![info exists mom_multi_channel_mode]} {		  
      set ini_file_channel_number 1 
      if {$isv_ini_tool_count(2)>0 || $isv_ini_tool_count(1)>0  } {
         set ini_file_channel_number 2
      }
   } else {
      set ini_file_channel_number 2
   }
}

#=============================================================
proc ISV_ini_output_ini_file { } {
#=============================================================
   global mom_output_file_basename
   global mom_part_name
   global mom_event_handler_file_name
   global isv_ini_tool_info
   global isv_ini_mcs_info
   global mom_kin_output_unit
   global mom_warning_info
   global isv_ini_file_dir
   global mom_sinumerik_ini_existing
   global mom_sinumerik_ini_location
   global isv_ini_tool_count
   global mom_multi_channel_mode

   #Get ini file output directory
   if {![info exists mom_sinumerik_ini_location]} {set mom_sinumerik_ini_location "Part"}
   switch $mom_sinumerik_ini_location {
      "CSE" {
          set post_dir "[file dirname [info script]]/"
          regsub "/postprocessor/" $post_dir "/cse_driver/" ini_dir
      }
      "ENV" {
          set ini_dir [MOM_ask_env_var UGII_CAM_CSE_USER_DIR] 
      }
      "Part" - 
      default {
          set part_dir "[file dirname $mom_part_name]/"
          if {[catch {file mkdir ${part_dir}cse_files/}]} {
          MOM_output_to_listing_device "$part_dir : No write access!"
return
          }
          set ini_dir ${part_dir}cse_files/
       }
   }
   if {[catch {file mkdir ${ini_dir}subprog/}]} {
      MOM_output_to_listing_device "$ini_dir : No write access!"
return
   }
   set ini_dir ${ini_dir}subprog/
   if {![file isdirectory $ini_dir]} {
      MOM_output_to_listing_device "$ini_dir : Directory does not exist!"
return
   }
 
   #Handle exsiting ini files in place where the one will be created.
   if {$isv_ini_tool_count(1)!=0 || ![info exists mom_multi_channel_mode]} {
      set current_dir [pwd]	    
      if {![info exists mom_sinumerik_ini_existing]} {set mom_sinumerik_ini_existing "Rename"}
      switch $mom_sinumerik_ini_existing {
         "Keep" {}
         "Delete" { 
             cd $ini_dir
             set ini_file_list [glob -nocomplain *.ini]
             foreach existing_file $ini_file_list { 
                if {![info exists mom_multi_channel_mode] || [string compare $existing_file to_ini_2.ini]} {
                   if {[catch {file delete $existing_file }]} {
                      MOM_output_to_listing_device "$existing_file : No write access!"
                      cd $current_dir
return
                   }
                }
             }
             cd $current_dir
         }
         "Rename" - 
         default {
             cd $ini_dir
             set ini_file_list [glob -nocomplain *.ini]
             foreach backup $ini_file_list {
                if {![info exists mom_multi_channel_mode] || [string compare $backup to_ini_2.ini]} {
                   if {[catch {file rename -force $backup $backup.bck}]} {
                      MOM_output_to_listing_device "$backup : No write access!"
                      cd $current_dir
return
                   }
                }
             }
             cd $current_dir
         }
      }
   } else {
       if {[string compare $mom_sinumerik_ini_existing "Keep"] && [string compare $mom_sinumerik_ini_existing "Delete"]} {				 
          set current_dir [pwd]
          cd $ini_dir
          if {[file exists "to_ini_2.ini"]} {
             if {[catch {file rename -force "to_ini_2.ini" "to_ini_2.ini.bck"}]} {
                MOM_output_to_listing_device "$backup : No write access!"
                cd $current_dir
return
             }
          }
          cd $current_dir
       }
   }	

   #Output ini file 
   global ini_file_channel_number
   if {$ini_file_channel_number==1} {
      set ini_file_name "${ini_dir}to_ini.ini"
      if {[catch {open "$ini_file_name" w} ini_file]} {
         MOM_output_to_listing_device "$ini_file_name : No write access!"
return
      }           
      puts $ini_file $isv_ini_mcs_info(0)
      puts $ini_file $isv_ini_tool_info(0)
      puts $ini_file "M17"
      close $ini_file
      set isv_ini_file_dir $ini_dir
   } else {
      for {set i 1} {$i<=2} {incr i} {
         if {$isv_ini_tool_count($i)!=0 || ![info exists mom_multi_channel_mode]} {			   
            set ini_file_name "${ini_dir}to_ini_$i.ini"
            if {[catch {open "$ini_file_name" w} ini_file]} {
               MOM_output_to_listing_device "$ini_file_name : No write access!"
   return
            }        
            puts $ini_file "CHANDATA($i)"						     
            puts $ini_file $isv_ini_mcs_info($i)
            puts $ini_file $isv_ini_tool_info($i)
            puts $ini_file "M17"
            close $ini_file
            set isv_ini_file_dir $ini_dir
         }
      }
   } 
}
 
if {[llength [info commands OPEN_files]] && ![llength [info commands sys_OPEN_files]]} {
   global mom_cse_ini_file_initialized
   set mom_cse_ini_file_initialized 0
   rename OPEN_files sys_OPEN_files
   
   uplevel #0 {
      proc OPEN_files {} {
         global mom_cse_ini_file_initialized
         global mom_sinumerik_ini_create
         global mom_sinumerik_ini_location
         global mom_sinumerik_ini_existing
         global mom_sinumerik_ini_end_status
	 
         set mom_sinumerik_ini_create "Yes"
         set mom_sinumerik_ini_location "Part"
         set mom_sinumerik_ini_existing "Rename"
         set mom_sinumerik_ini_end_status "Keep"

         if {$mom_cse_ini_file_initialized == 0} {
            if {[llength [info commands PB_CMD_init_ini_files] ]} { 
               PB_CMD_init_ini_files
            }
            switch $mom_sinumerik_ini_create {
               "No" {}
               "Yes" -
               default {                
                   ISV_ini_get_tool_info
                   ISV_ini_get_mcs_info 
                   ISV_ini_output_ini_file
                   set mom_cse_ini_file_initialized 1
               }
            }
         }
         sys_OPEN_files
      }
   };#uplevel
}

if {[llength [info commands MOM__halt]] && ![llength [info commands MOM__sys_halt]]} {
   rename MOM__halt MOM__sys_halt
}
proc MOM__halt {} {	
   if {[llength [info commands MOM__sys_halt]]} {
      MOM__sys_halt
   }
   global isv_ini_file_dir
   set ini_file_name [list]
   if {[info exists isv_ini_file_dir]} {
      global mom_sinumerik_ini_end_status
      global isv_ini_tool_count
      global mom_multi_channel_mode
      global ini_file_channel_number
      if {$ini_file_channel_number==1} {
         lappend ini_file_name "${isv_ini_file_dir}to_ini.ini"
      } else {
         lappend ini_file_name "${isv_ini_file_dir}to_ini_1.ini"
         lappend ini_file_name "${isv_ini_file_dir}to_ini_2.ini"
      }
      if {![info exists mom_multi_channel_mode]} {		
         if {[info exists mom_sinumerik_ini_end_status]} {
            if {![string compare $mom_sinumerik_ini_end_status "Rename"]} {
               foreach file_name $ini_file_name {
                  catch {file rename -force $file_name $file_name.bck}
               }
            } elseif {![string compare $mom_sinumerik_ini_end_status "Delete"]} {
               foreach file_name $ini_file_name {
                  catch {file delete $file_name}
               }
            } 
         }
      }
   }
}
