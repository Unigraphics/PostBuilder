proc PB_CMD_initialize_tool_list {} {

# 
# Use these custom commands to generate a tool list at either
# the beginning or end of your NC file.
#
# Place the custom command PB_CMD_initialize_tool_list in 
# the start of program event marker 
#
# This procedure is used to add the shop docs event handlers
# to your post.  You may edit the proc MOM_TOOL_BODY to
# customize the output for your tool list.
#
# This tool list will generate three separate lists, one for
# drilling tools, one for milling tools and one for turning
# tools.  Only the tools used in the current program will be
# listed.
#
# In order to create the tool list, you must add the proc
# PB_CMD_create_tool_list to either the start of program 
# event marker or the end of program event marker depending
# on whether you want the tool list at the beginning or end
# of your NC tape.
#
# The file post_tool_list.tpl must reside in the 
# mach\resource\shop_docs directory.
#

uplevel #0 {
proc MOM_TOOL_BODY { } {
    global mom_tool_name
    global mom_tool_diameter
    global mom_tool_length
    global mom_tool_type
    global mom_template_subtype
    global mom_tool_point_angle
    global mom_tool_flute_length
    global mom_tool_length_adjust_register
    global mom_tool_nose_radius
    global mom_tool_corner1_radius
    global mom_tool_flute_length
    global mom_tool_orientation
    global tool_head setup_header
    global number_of_tools
    global mom_sys_control_out mom_sys_control_in
    global cycle_program_name current_program_name
    global mom_sys_tool_stack mom_sys_tool_time

    set n1 [string toupper $cycle_program_name]
    set n2 [string toupper $current_program_name]
    if {$n1 != $n2 && $n1 != ""} {return}
 
    if {[info exist mom_sys_tool_stack]} {
      if {[lsearch $mom_sys_tool_stack "$mom_tool_name"] >= 0 } {return}
    }
    lappend mom_sys_tool_stack $mom_tool_name

    set ci $mom_sys_control_in
    set co $mom_sys_control_out

    set tool_type [MAP_TOOL_TYPE]

    if {$setup_header == "1"} {

      switch $tool_type {
         "MILL"  { incr number_of_tools(mill) }
         "DRILL" { incr number_of_tools(drill) }
         "LATHE" { incr number_of_tools(lathe) }
      }
    }

    if {$tool_head != $tool_type} { return }
    
    if {$mom_template_subtype == ""} {set mom_template_subtype $mom_tool_type}

    if {$tool_type == "MILL"} {

      set output [format "%-20s %-20s %-10.4f %-10.4f %-10.4f %-10d" \
                $mom_tool_name $mom_template_subtype\
                $mom_tool_diameter $mom_tool_corner1_radius \
                $mom_tool_flute_length $mom_tool_length_adjust_register] 
      if {[info exists mom_sys_tool_time($mom_tool_name)]} {
          set tool_time [format "%-10.2f" $mom_sys_tool_time($mom_tool_name)]
      } else {
          set tool_time ""
      }
      shop_doc_output_literal "$co$output$tool_time$ci"

    } elseif {$tool_type == "DRILL"} {

      set mom_tool_point_angle [expr (180.0 / 3.14159) * $mom_tool_point_angle]
      set output [format "%-20s %-20s %-10.4f %-10.4f %-10.4f %-10d" \
                $mom_tool_name $mom_template_subtype \
                $mom_tool_diameter $mom_tool_point_angle \
                $mom_tool_flute_length $mom_tool_length_adjust_register] 
      if {[info exists mom_sys_tool_time($mom_tool_name)]} {
          set tool_time [format "%-10.2f" $mom_sys_tool_time($mom_tool_name)]
      } else {
          set tool_time ""
      }
      shop_doc_output_literal "$co$output$tool_time$ci"

    } elseif {$tool_type == "LATHE"} {

      set pi [expr 2 * asin(1.0)]
      set tool_orient [expr (180. / 3.14159) * $mom_tool_orientation]
      set output [format "%-20s %-20s %-10.4f %-15.4f %-10d" \
                $mom_tool_name $mom_template_subtype \
                $mom_tool_nose_radius $tool_orient \
                $mom_tool_length_adjust_register] 
      if {[info exists mom_sys_tool_time($mom_tool_name)]} {
          set tool_time [format "%-10.2f" $mom_sys_tool_time($mom_tool_name)]
      } else {
          set tool_time ""
      }
      shop_doc_output_literal "$co$output$tool_time$ci"

    }
}

proc MOM_SETUP_HDR {} {
  global setup_header
  global tool_head
  global mom_sys_control_out mom_sys_control_in

  set ci $mom_sys_control_in
  set co $mom_sys_control_out

  # Calls the setup header
    if { $setup_header  == 0} {
       shop_doc_output_literal "$co-----------------------------------------------------------------------------------------------$ci"
       shop_doc_output_literal "$co                                                                                               $ci"
       shop_doc_output_literal "$co                                TOOL LIST                                                      $ci"
       shop_doc_output_literal "$co                                                                                               $ci"
       set setup_header 1
       set tool_head ""

    } elseif { $setup_header == 1} {
       set tool_head "LATHE"
       set setup_header 2
    } elseif { $setup_header == 2} {
       set tool_head "DRILL"
       set setup_header 3
    } elseif { $setup_header == 3} {
       set tool_head "MILL"
       set setup_header 4
    }
}

#=============================================================================
proc MOM_PROGRAMVIEW_HDR {} {
#=============================================================================
   global mom_object_type
   global mom_object_name
   global tool_head
   global line_flag
   global number_of_tools
   global mom_sys_control_out mom_sys_control_in
  
   set ci $mom_sys_control_in
   set co $mom_sys_control_out

   set tool_name  "TOOL NAME"
   set tool_desc  "DESCRIPTION"
   set tool_dia   "DIAMETER"
   set corner_rad "COR RAD"
   set tip_ang    "TIP ANG"
   set flute_len  "FLUTE LEN"
   set adjust     "ADJ REG"
   set nose_dia   "NOSE RAD"
   set tool_orient "TOOL ORIENT"
   set mach_time "MACH TIME"

     switch $tool_head \
     {

       "DRILL" {
                  if { $number_of_tools(drill) > 0 } \
                  {
                     shop_doc_output_literal "$co                                                                                               $ci"
                     shop_doc_output_literal "$co                       DRILLING TOOLS                                                          $ci"
                     shop_doc_output_literal "$co-----------------------------------------------------------------------------------------------$ci"
                     set output [format "%-20s %-20s %-10s %-10s %-10s %-9s %-10s" \
                        $tool_name $tool_desc \
                        $tool_dia $tip_ang $flute_len $adjust $mach_time] 
                     shop_doc_output_literal "$co$output$ci"
                     shop_doc_output_literal "$co-----------------------------------------------------------------------------------------------$ci"
                     set line_flag 1
                  }
               }
       "MILL"  {
                  if { $number_of_tools(mill) > 0 } \
                  {
                     shop_doc_output_literal "$co                                                                                               $ci"
                     shop_doc_output_literal "$co                       MILLING TOOLS                                                           $ci"
                     shop_doc_output_literal "$co-----------------------------------------------------------------------------------------------$ci"
                     set output [format "%-20s %-20s %-10s %-10s %-10s %-9s %-10s" \
                        $tool_name $tool_desc \
                        $tool_dia $corner_rad $flute_len $adjust $mach_time] 
                     shop_doc_output_literal "$co$output$ci"
                     shop_doc_output_literal "$co-----------------------------------------------------------------------------------------------$ci"
                     set line_flag 1
                  }
               }
       "LATHE" {
                  if { $number_of_tools(lathe) > 0 } \
                  {
                     shop_doc_output_literal "$co                                                                                               $ci"
                     shop_doc_output_literal "$co                       TURNING TOOLS                                                           $ci"
                     shop_doc_output_literal "$co----------------------------------------------------------------------------------------------$ci"
                     set output [format "%-20s %-20s %-10s %-15s %-9s %-10s" \
                        $tool_name $tool_desc $nose_dia $tool_orient $adjust $mach_time] 
                     shop_doc_output_literal "$co$output$ci"
                     shop_doc_output_literal "$co----------------------------------------------------------------------------------------------$ci"
                     set line_flag 1
                  }
               }
     }
}

proc MOM_SETUP_FTR { } {
}

proc MOM_MEMBERS_HDR { } {
global mom_sys_program_stack cycle_program_name

lappend mom_sys_program_stack $cycle_program_name

global current_program_name
if {[lsearch $mom_sys_program_stack "$current_program_name"] >= 0 } {
   set cycle_program_name $current_program_name
}
}

proc MOM_MEMBERS_FTR { } {
global mom_sys_program_stack cycle_program_name

set mom_sys_program_stack [lreplace $mom_sys_program_stack end end]
set cycle_program_name [lindex $mom_sys_program_stack end]

global current_program_name
if {[lsearch $mom_sys_program_stack "$current_program_name"] >= 0 } {
   set cycle_program_name $current_program_name
}
}

proc MOM_PROGRAM_BODY { } {

global mom_object_name cycle_program_name

set cycle_program_name $mom_object_name
}

proc MOM_SETUP_BODY { } {
}
proc MOM_OPER_BODY { } {
}
proc MOM_TOOL_HDR { } {
}
proc MOM_TOOL_FTR { } {
}
proc MOM_PROGRAMVIEW_FTR { } {
   global mom_sys_tool_stack

   if {[info exists mom_sys_tool_stack]} {unset mom_sys_tool_stack}
}
proc MOM_SETUP_BODY { } {
}

#=============================================================================
proc MAP_TOOL_TYPE { } {
#=============================================================================
  global mom_tool_type

  if {[string match "Milling*" $mom_tool_type]} {
    return "MILL"
  } elseif { [string match "Turning*" $mom_tool_type]} {
    return "LATHE"
  } elseif { [string match "Grooving*" $mom_tool_type]} {
    return "LATHE"
  } elseif { [string match "Threading*" $mom_tool_type]} {
    return "LATHE"
  } elseif { [string match "Drilling*" $mom_tool_type]} {
    return "DRILL"
  } else {
    return ""
  }
}

#=============================================================================
proc TOOL_LIST_start_of_group {} {
#=============================================================================
global mom_cycle_group_name mom_group_name

if {![info exists mom_cycle_group_name]} {set mom_cycle_group_name $mom_group_name}
}


proc shop_doc_output_literal { line } {
    global tool_list_commentary list_file
    if {[info exists tool_list_commentary]} {
	if {[info exists line]} {puts $list_file $line}
    } else {
	MOM_output_literal $line
    }
}

}
}

proc PB_CMD_create_tool_list {} {

#
# Place this custom command in either the start of program
# or end of program event markers to generate a tool list
# at either the start or end of your NC file.
#
# You will also need to place the custom command 
# PB_CMD_initialize_tool_list in the start of program event 
# marker.
#
# The file post_tool_list.tpl must reside in the 
# mach\resource\shop_docs directory.
#

    global setup_header number_of_tools
    global mom_sys_control_out mom_sys_control_in
    global current_program_name mom_cycle_group_name mom_group_name
    global shop_docs_block shop_docs_output
    global mom_tool_number mom_tool_length_adjust_register mom_tool_name

    set saved_tool_number $mom_tool_number
    set saved_adjust_register $mom_tool_length_adjust_register
    set saved_tool_name $mom_tool_name

    if {[info exists shop_docs_output]} {return}
    set shop_docs_output 0

    if {![info exists mom_cycle_group_name]} {
      if {[info exists mom_group_name]} {
        set mom_cycle_group_name $mom_group_name
      } else {
        set mom_cycle_group_name ""
      }
    } 
    
    set current_program_name $mom_cycle_group_name

    set ci $mom_sys_control_in
    set co $mom_sys_control_out

    set number_of_tools(mill) 0
    set number_of_tools(drill) 0
    set number_of_tools(lathe) 0
    set setup_header 0

    set shop_docs_block 0

    set cam_shop_doc_dir [MOM_ask_env_var UGII_CAM_SHOP_DOC_DIR]
    MOM_do_template_file ${cam_shop_doc_dir}post_tool_list.tpl

    shop_doc_output_literal "$co                                                                                               $ci"
    shop_doc_output_literal "$co-----------------------------------------------------------------------------------------------$ci"

    set mom_tool_number $saved_tool_number 
    set mom_tool_length_adjust_register $saved_adjust_register 
    set mom_tool_name $saved_tool_name 

    unset shop_docs_block
}


