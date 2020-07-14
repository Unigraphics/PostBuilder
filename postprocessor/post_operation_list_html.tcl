#####################################################################
#                 POST_OPERATION_LIST_HTML.TCL
#####################################################################
# Description
# -----------
#  This file contains the control section for creating a Shop Floor
#  Docs for Operation List in html format through Post Processor.
# 
######################################################################
# 
#_______________________________________________________________________________
# Here you should define any global variables that will be used in any one
# of the event handler.
#_______________________________________________________________________________

  
  set mom_sys_output_file_suffix                "html"
  set line_flag 0

  # This procedure creates a part documentation.
  set mom_source_directory [MOM_ask_env_var UGII_CAM_SHOP_DOC_DIR]
  source "${mom_source_directory}shopdoc_header.tcl"
  set table_flag 0
  set template_type ""
  set template_subtype ""

#==============================================================================
proc MOM_Start_Part_Documentation {} {
#==============================================================================

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
      if {[string length $mom_output_file_suffix] > 0} {
        set output_extn ".${mom_output_file_suffix}"
      }
    }
    set pre_ptp_name "${mom_output_file_directory}${mom_output_file_basename}${output_extn}"

    if {[string length $output_extn] == 0} {
        if {[info exists mom_sys_output_file_suffix] } {
            if {[string length $mom_sys_output_file_suffix] > 0} {
                set output_extn ".${mom_sys_output_file_suffix}"
            }
        }
    }

    set ptp_file_name "${mom_output_file_directory}${mom_output_file_basename}${output_extn}"

    MOM_close_output_file $pre_ptp_name
    if {"$ptp_file_name" != "$pre_ptp_name"} {MOM_close_output_file $ptp_file_name}
    if {[file exists $pre_ptp_name]} {
      MOM_remove_file $pre_ptp_name
    }
    if {[file exists $ptp_file_name]} {
      MOM_remove_file $ptp_file_name
    }

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
    create_operation_list_html   
}


#=============================================================
proc create_operation_list_html {} {
#=============================================================
  global setup_header 
  global current_program_name mom_cycle_group_name mom_group_name
  global shop_docs_block shop_docs_output
  global mom_operation_name mom_operation_type 
  global template_type template_subtype mom_tool_name
  global mom_operation_name

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

    set setup_header 0

    set shop_docs_block 0
    set cam_post_dir [MOM_ask_env_var UGII_CAM_SHOP_DOC_DIR]
    MOM_do_template_file ${cam_post_dir}post_operation_list_html.tpl
    unset shop_docs_block
}


#==============================================================================
proc MOM_End_Part_Documentation {} {
#==============================================================================
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


#=============================================================================
proc MOM_TOOL_BODY { } {
#=============================================================================
  global mom_operation_name
  global mom_operation_type
  global mom_tool_name
  global template_type
  global template_subtype
  global table_flag
  global cycle_program_name current_program_name
 
  set n1 [string toupper $cycle_program_name]
  set n2 [string toupper $current_program_name]
  if {$n1 != $n2} {return}
 
  if {!$table_flag} \
  {
    MOM_output_literal "<BR>"
    MOM_output_literal "<CENTER><table WIDTH=700 BORDER=1>"
    MOM_output_literal "<th ALIGN=CENTER WIDTH=33%><FONT COLOR=800000>\
                             OPERATION NAME </FONT></th>"
    MOM_output_literal "<th ALIGN=CENTER WIDTH=34%><FONT COLOR=800000>\
                             OPERATION TYPE </FONT></th>"
    MOM_output_literal "<th ALIGN=CENTER WIDTH=33%><FONT COLOR=800000>\
                             TOOL NAME </FONT></th>"
    MOM_output_literal "</tr>"
    set table_flag 1
  }

  if { $template_type == ""  && $template_subtype == ""} \
  {
      set oper_desc "--/--"
  } elseif { $template_type == "" } \
  {
      set oper_desc "--/"
      append oper_desc $template_type
  } elseif { $template_subtype == ""} \
  {
      set oper_desc "$template_type/"
      append oper_desc "--"
  } else \
  {
      set oper_desc "$template_type/$template_subtype"
  }

  MOM_output_literal "<tr>"
  MOM_output_literal "<td ALIGN=CENTER>$mom_operation_name</td>"
  MOM_output_literal "<td ALIGN=CENTER>$oper_desc</td>"
  MOM_output_literal "<td ALIGN=CENTER>$mom_tool_name</td>"
  MOM_output_literal "</tr>"

  set template_type ""
  set template_subtype ""

}


#=============================================================================
proc MOM_SETUP_HDR {} {
#=============================================================================
  Setup_Header_html
}

  
#=============================================================================
proc MOM_PROGRAMVIEW_HDR {} {
#=============================================================================
  global mom_object_name cycle_program_name
  global mom_member_nest_level
  global mom_object_name
  global table_flag

  set cycle_program_name $mom_object_name

  if {$table_flag} \
  {
     MOM_output_literal "</table>"
     MOM_output_literal "<BR>"
     set table_flag 0
  }

   MOM_output_literal "<BR>"
   MOM_output_literal "<CENTER><table WIDTH=700 BORDER=0>"
   MOM_output_literal "<tr ALIGN=CENTER VALIGN=CENTER>"
   MOM_output_literal "<th ALIGN=LEFT WIDTH=50%><FONT COLOR=800000>\
           PROGRAM NAME : $mom_object_name </FONT></th>"
   MOM_output_literal "</tr>"
   MOM_output_literal "</table>"

   MOM_output_literal "<CENTER><table WIDTH=700 BORDER=1>"
   MOM_output_literal "<tr ALIGN=CENTER VALIGN=CENTER>"
   MOM_output_literal "<th ALIGN=CENTER WIDTH=33%><FONT COLOR=800000>\
                             OPERATION NAME </FONT></th>"
   MOM_output_literal "<th ALIGN=CENTER WIDTH=34%><FONT COLOR=800000>\
                             OPERATION DESCRIPTION </FONT></th>"
   MOM_output_literal "<th ALIGN=CENTER WIDTH=33%><FONT COLOR=800000>\
                             TOOL NAME </FONT></th>"
   MOM_output_literal "</tr>"
   MOM_output_literal "<BR>"
   set table_flag 1
}


#=============================================================================
proc MOM_SETUP_FTR { } {
#=============================================================================
}


#=============================================================================
proc MOM_MEMBERS_HDR { } {
#=============================================================================
  global mom_sys_program_stack cycle_program_name
  global current_program_name

  lappend mom_sys_program_stack $cycle_program_name

  if {[lsearch $mom_sys_program_stack "$current_program_name"] >= 0 } {
     set cycle_program_name $current_program_name
  }
}


#=============================================================================
proc MOM_MEMBERS_FTR { } {
#=============================================================================
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


#=============================================================================
proc MOM_PROGRAM_BODY { } {
#=============================================================================
   global mom_object_name cycle_program_name
   set cycle_program_name $mom_object_name
}


#=============================================================================
proc MOM_SETUP_BODY { } {
#=============================================================================
}


#=============================================================================
proc MOM_OPER_BODY { } {
#=============================================================================
  global mom_template_type
  global mom_template_subtype
  global template_type
  global template_subtype
  global mom_operation_name
  global mom_operation_type
 
  set template_type $mom_template_type
  set template_subtype $mom_template_subtype
  
  if { $mom_operation_type == "Wire EDM" } \
  {
      set oper_desc "$template_type/$template_subtype"
      MOM_output_literal "<tr>"
      MOM_output_literal "<td ALIGN=CENTER>$mom_operation_name</td>"
      MOM_output_literal "<td ALIGN=CENTER>$oper_desc</td>"
      MOM_output_literal "<td ALIGN=CENTER>WIRE</td>"
      MOM_output_literal "</tr>"
  }

}


#=============================================================================
proc MOM_TOOL_HDR { } {
#=============================================================================
}
  

#=============================================================================
proc MOM_TOOL_FTR { } {
#=============================================================================
}


#=============================================================================
proc MOM_PROGRAMVIEW_FTR { } {
#=============================================================================
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



