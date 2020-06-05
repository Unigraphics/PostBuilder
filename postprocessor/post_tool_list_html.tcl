#####################################################################
#    P O S T _ T O O L _ L I S T _ H T M L. T C L
#####################################################################
# Description
# -----------
#  This file contains the control section for creating a Shop Floor
#  Docs for Tool List in html format through Post Processor in the PROGRAMVIEW.
# 
######################################################################
# 
#_______________________________________________________________________________
# Here you should define any global variables that will be used in any one
# of the event handler.
#_______________________________________________________________________________

set mom_source_directory [MOM_ask_env_var UGII_CAM_SHOP_DOC_DIR]
source "${mom_source_directory}shopdoc_header.tcl"
set table_flag 0
set setup_header 0
set Tool_No(mill) 0
set Tool_No(drill) 0
set Tool_No(lathe) 0

set mom_sys_output_file_suffix                "html"
set line_flag 0


# This procedure creates a part documentation.
#============================================================================
proc MOM_Start_Part_Documentation {} {
#============================================================================

  # Calls the shopdocs header
    ShopDoc_Header_html
}


#=============================================================
proc MOM_start_of_program { } {
#=============================================================
  global mom_sys_output_file_suffix mom_sys_list_file_suffix output_extn list_extn
  global ptp_file_name lpt_file_name warning_file_name mom_group_name prev_group_name
  global mom_output_file_directory mom_output_file_basename
  global mom_sys_ptp_output
  global mom_output_file_suffix
  global isinit_files isinit_group

  if {![info exists isinit_files]} {
    set output_extn ""
    if {[info exists mom_output_file_suffix]} {
      if {[string length $mom_output_file_suffix] > 0} { set output_extn ".${mom_output_file_suffix}" }
    }
    set pre_ptp_name "${mom_output_file_directory}${mom_output_file_basename}${output_extn}"

    if {[string length $output_extn] == 0} {
        if {[info exists mom_sys_output_file_suffix]} {
            if {[string length $mom_sys_output_file_suffix] > 0} {
                set output_extn ".${mom_sys_output_file_suffix}"
            }
        }
    }

    set ptp_file_name "${mom_output_file_directory}${mom_output_file_basename}${output_extn}"
    MOM_close_output_file $pre_ptp_name
    if {"$ptp_file_name" != "$pre_ptp_name"} {MOM_close_output_file $ptp_file_name}
    if {[file exists $pre_ptp_name]} { MOM_remove_file $pre_ptp_name }
    if {[file exists $ptp_file_name]} { MOM_remove_file $ptp_file_name }
    MOM_open_output_file $ptp_file_name
    set isinit_files TRUE
  }
}


#=============================================================
proc MOM_start_of_group {} {
#=============================================================
    if {[info exists ptp_file_name]} {
      MOM_close_output_file $ptp_file_name ; MOM_start_of_program
      MOM_open_output_file $ptp_file_name
    } else {
      MOM_start_of_program
    }
    create_tool_list_html
}


#=============================================================
proc create_tool_list_html {} {
#=============================================================
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

   # set ci $mom_sys_control_in
   # set co $mom_sys_control_out

    set number_of_tools(mill) 0
    set number_of_tools(drill) 0
    set number_of_tools(lathe) 0
    set setup_header 0

    set shop_docs_block 0
    set cam_post_dir [MOM_ask_env_var UGII_CAM_SHOP_DOC_DIR]
    MOM_do_template_file ${cam_post_dir}post_tool_list_html.tpl
    shop_doc_output_literal "
                                            "

    set mom_tool_number $saved_tool_number
    set mom_tool_length_adjust_register $saved_adjust_register
    set mom_tool_name $saved_tool_name

    unset shop_docs_block
}


#============================================================================
#proc MOM_Part_Documentation {} {
#============================================================================
#  MOM_do_template_file "[MOM_ask_env_var UGII_CAM_SHOP_DOC_DIR]tool_list.tpl"
#}


#============================================================================
proc MOM_End_Part_Documentation {} {
#============================================================================
  MOM_output_literal "</HTML>"
}


#=============================================================================
proc shop_doc_output_literal { line } {
#=============================================================================
  global tool_list_commentary list_file
  if {[info exists tool_list_commentary]} {
      if {[info exists line]} {puts $list_file $line}
  } else {
      MOM_output_literal $line
  }
}


# Setup
#===============================================================================
proc MOM_SETUP_HDR {} {
#===============================================================================
  global setup_header
  global tool_head
  if { $setup_header  == 0} \
  {
     Setup_Header_html
     MOM_output_literal "<P ALIGN=CENTER><B><FONT SIZE=4 COLOR=800000><I> \
                         TOOLING  LIST </I></FONT></B></P>"
     set setup_header 1
     set tool_head ""
  } elseif { $setup_header == 1} \
  {
     set tool_head "LATHE"
     set setup_header 2
  } elseif { $setup_header == 2} \
  {
     set tool_head "DRILL"
     set setup_header 3
  } elseif { $setup_header == 3} \
  {
     set tool_head "MILL"
     set setup_header 4
  }
}

#=============================================================================
proc MOM_PROGRAM_BODY { } {
#=============================================================================
  global mom_object_name cycle_program_name
  set cycle_program_name $mom_object_name
}


#============================================================================
proc MOM_SETUP_BODY {} {
#============================================================================
}


#=============================================================================
proc MOM_OPER_BODY { } {
#=============================================================================
  global mom_template_type
  global mom_template_subtype
  global template_type
  global template_subtype

  set template_type $mom_template_type
  set template_subtype $mom_template_subtype

}

#============================================================================
proc MOM_SETUP_FTR {} {
#============================================================================
}


#============================================================================
proc  MOM_MEMBERS_HDR {} {
#============================================================================
  global mom_sys_program_stack cycle_program_name
  global current_program_name

  lappend mom_sys_program_stack $cycle_program_name

  if {[lsearch $mom_sys_program_stack "$current_program_name"] >= 0 } {
     set cycle_program_name $current_program_name
  }

}

#============================================================================
proc MOM_MEMBERS_FTR { } {
#============================================================================
  global mom_sys_program_stack cycle_program_name
  global current_program_name
  global table_flag

  set mom_sys_program_stack [lreplace $mom_sys_program_stack end end]
  set cycle_program_name [lindex $mom_sys_program_stack end]
  if {[lsearch $mom_sys_program_stack "$current_program_name"] >= 0 } {
     set cycle_program_name $current_program_name

     if { $table_flag == 1} \
     {
       MOM_output_literal "</table>"
       MOM_output_literal "<BR>"
       set table_flag 0
     }
  }
}

# Operation
#===============================================================================
proc MOM_TOOL_BODY {} {
#===============================================================================
  global mom_tool_name
  global mom_template_subtype
  global mom_tool_diameter
  global mom_tool_nose_radius
  global mom_tool_length_adjust_register
  global mom_tool_orientation
  global mom_tool_corner1_radius
  global mom_tool_point_angle
  global mom_tool_flute_length
  global setup_header
  global tool_head
  global Tool_No
  global cycle_program_name current_program_name
  
  set n1 [string toupper $cycle_program_name]
  set n2 [string toupper $current_program_name]
  if {$n1 != $n2} {return}


  MapToolType tool_type

  if {$setup_header > 1} \
  {
     if { [string compare $tool_head $tool_type] } { return }

     switch $tool_head \
     {

       "DRILL" {
                  set pi [expr 2 * asin(1.0)]
                  set mom_tool_point_angle [expr [expr 180 / $pi] * \
                                                 $mom_tool_point_angle]
                  MOM_output_literal "<tr>"
                  MOM_output_literal "<td ALIGN=CENTER>$mom_tool_name</td>"
                  MOM_output_literal "<td ALIGN=CENTER>$mom_template_subtype</td>"
                  MOM_output_literal "<td ALIGN=CENTER>[format "%10.4f" \
                                      $mom_tool_diameter]</td>"
                  MOM_output_literal "<td ALIGN=CENTER>[format "%10.4f" \
                                      $mom_tool_point_angle]</td>"
                  MOM_output_literal "<td ALIGN=CENTER>[format "%10.4f" \
                                       $mom_tool_flute_length]</td>"
                  MOM_output_literal "<td ALIGN=CENTER>[format "%10d" \
                                       $mom_tool_length_adjust_register]</td>"
                  MOM_output_literal "</tr>"
               }
       "MILL"  {
                  MOM_output_literal "<tr>"
                  MOM_output_literal "<td ALIGN=CENTER>$mom_tool_name</td>"
                  MOM_output_literal "<td ALIGN=CENTER>$mom_template_subtype</td>"
                  MOM_output_literal "<td ALIGN=CENTER>[format "%10.4f" \
                                      $mom_tool_diameter]</td>"
                  MOM_output_literal "<td ALIGN=CENTER>[format "%10.4f" \
                                      $mom_tool_corner1_radius]</td>"
                  MOM_output_literal "<td ALIGN=CENTER>[format "%10.4f" \
                                       $mom_tool_flute_length]</td>"
                  MOM_output_literal "<td ALIGN=CENTER>[format "%10d" \
                                       $mom_tool_length_adjust_register]</td>"
                  MOM_output_literal "</tr>"
               }
       "LATHE" {
                  set tool_orient [expr [expr 180 / 3.14] * \
                                     $mom_tool_orientation]
                  MOM_output_literal "<tr>"
                  MOM_output_literal "<td ALIGN=CENTER>$mom_tool_name</td>"
                  MOM_output_literal "<td ALIGN=CENTER>$mom_template_subtype</td>"
                  MOM_output_literal "<td ALIGN=CENTER>[format "%10.4f" \
                                       $mom_tool_nose_radius]</td>"
                  MOM_output_literal "<td ALIGN=CENTER>[format "%10.4f" \
                                       $tool_orient]</td>"
                  MOM_output_literal "<td ALIGN=CENTER>[format "%10d" \
                                       $mom_tool_length_adjust_register]</td>"
                  MOM_output_literal "</tr>"
              }
     }
  } else \
  {
     switch $tool_type \
     {
         "MILL"  { incr Tool_No(mill) }
         "DRILL" { incr Tool_No(drill) }
         "LATHE" { incr Tool_No(lathe) }
      }
  }
}

#============================================================================
proc MOM_PROGRAMVIEW_HDR {} {
#============================================================================
   global mom_object_type
   global mom_object_name
   global table_flag
   global tool_head
   global Tool_No

    if {$table_flag} \
   {
      MOM_output_literal "</table>"
      MOM_output_literal "<BR>"
      set table_flag 0
   }

   switch $tool_head \
   {
     "DRILL" {
               if { $Tool_No(drill) > 0 } \
               {
                  MOM_output_literal "<CENTER><table WIDTH=700 BORDER=0>"
                  MOM_output_literal "<tr ALIGN=CENTER VALIGN=CENTER>"
                  MOM_output_literal "<th ALIGN=LEFT WIDTH=100%><FONT \
                                 COLOR=800000> DRILLING TOOLS </FONT></th>"
                  MOM_output_literal "</tr> </table>"
                  MOM_output_literal "<CENTER><table WIDTH=700 BORDER=1>"
                  MOM_output_literal "<tr ALIGN=CENTER VALIGN=CENTER>"
                  MOM_output_literal "<th ALIGN=CENTER WIDTH=20%><FONT \
                                 COLOR=800000> TOOL NAME </FONT></th>"
                  MOM_output_literal "<th ALIGN=CENTER WIDTH=25%><FONT \
                                 COLOR=800000> DESCRIPTION </FONT></th>"
                  MOM_output_literal "<th ALIGN=CENTER WIDTH=15%><FONT \
                                 COLOR=800000> DIAMETER </FONT></th>"
                  MOM_output_literal "<th ALIGN=CENTER WIDTH=15%><FONT \
                                 COLOR=800000> TIP ANG </FONT></th>"
                  MOM_output_literal "<th ALIGN=CENTER WIDTH=15%><FONT \
                                 COLOR=800000> FLUTE LEN </FONT></th>"
                  MOM_output_literal "<th ALIGN=CENTER WIDTH=10%><FONT \
                                 COLOR=800000> ADJ REG </FONT></th>"
                  MOM_output_literal "</tr>"
                  MOM_output_literal "<BR>"
                  set table_flag 1
               }
             }
     "MILL"  {
               if { $Tool_No(mill) > 0 } \
               {
                  MOM_output_literal "<CENTER><table WIDTH=700 BORDER=0>"
                  MOM_output_literal "<tr ALIGN=CENTER VALIGN=CENTER>"
                  MOM_output_literal "<th ALIGN=LEFT WIDTH=100%><FONT \
                                 COLOR=800000> MILLING TOOLS </FONT></th>"
                  MOM_output_literal "</tr> </table>"
                  MOM_output_literal "<CENTER><table WIDTH=700 BORDER=1>"
                  MOM_output_literal "<tr ALIGN=CENTER VALIGN=CENTER>"
                  MOM_output_literal "<th ALIGN=CENTER WIDTH=20%><FONT \
                                 COLOR=800000> TOOL NAME </FONT></th>"
                  MOM_output_literal "<th ALIGN=CENTER WIDTH=25%><FONT \
                                 COLOR=800000> DESCRIPTION </FONT></th>"
                  MOM_output_literal "<th ALIGN=CENTER WIDTH=15%><FONT \
                                 COLOR=800000> DIAMETER </FONT></th>"
                  MOM_output_literal "<th ALIGN=CENTER WIDTH=15%><FONT \
                                 COLOR=800000> COR RAD </FONT></th>"
                  MOM_output_literal "<th ALIGN=CENTER WIDTH=15%><FONT \
                                 COLOR=800000> FLUTE LEN </FONT></th>"
                  MOM_output_literal "<th ALIGN=CENTER WIDTH=10%><FONT \
                                 COLOR=800000> ADJ REG </FONT></th>"
                  MOM_output_literal "</tr>"
                  MOM_output_literal "<BR>"
                  set table_flag 1
               }
             }
     "LATHE" {
               if { $Tool_No(lathe) > 0 } \
               {
                  MOM_output_literal "<CENTER><table WIDTH=700 BORDER=0>"
                  MOM_output_literal "<tr ALIGN=CENTER VALIGN=CENTER>"
                  MOM_output_literal "<th ALIGN=LEFT WIDTH=100%><FONT \
                                 COLOR=800000> TURNING TOOLS </FONT></th>"
                  MOM_output_literal "</tr> </table>"
                  MOM_output_literal "<CENTER><table WIDTH=700 BORDER=1>"
                  MOM_output_literal "<tr ALIGN=CENTER VALIGN=CENTER>"
                  MOM_output_literal "<th ALIGN=CENTER WIDTH=25%><FONT \
                                 COLOR=800000> TOOL NAME </FONT></th>"
                  MOM_output_literal "<th ALIGN=CENTER WIDTH=35%><FONT \
                                 COLOR=800000> DESCRIPTION </FONT></th>"
                  MOM_output_literal "<th ALIGN=CENTER WIDTH=15%><FONT \
                                 COLOR=800000> NOSE RAD </FONT></th>"
                  MOM_output_literal "<th ALIGN=CENTER WIDTH=15%><FONT \
                                 COLOR=800000> TOOL ORIENT </FONT></th>"
                  MOM_output_literal "<th ALIGN=CENTER WIDTH=10%><FONT \
                                 COLOR=800000> ADJ REG </FONT></th>"
                  MOM_output_literal "</tr>"
                  MOM_output_literal "<BR>"
                  set table_flag 1
               }
             }
    }
}


#============================================================================
proc MOM_PROGRAMVIEW_FTR {} {
#============================================================================
  global table_flag
  if {$table_flag} \
  {
     MOM_output_literal "</table>"
     MOM_output_literal "<BR>"
     set table_flag 0
  }
}


#=============================================================================
proc TOOL_LIST_start_of_group {} {
#=============================================================================
  global mom_cycle_group_name mom_group_name

  if {![info exists mom_cycle_group_name]} {set mom_cycle_group_name $mom_group_name}
}

