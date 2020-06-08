##############################################################################
# Description                                                                #
#     This file contains all functions dealing with parsing a TCL file       #
#                                                                            #
# Revisions                                                                  #
#                                                                            #
#   Date        Who       Reason                                             #
# 01-feb-1999   naveen    Initial                                            #
# 07-jun-1999   mnb       Added Event Handler parser proceduers              #
# 28-jun-1999   mnb       Tcl file is opened in read mode only               #
# 13-Oct-1999   mnb       Phase 20 Integration.                              #
#                                                                            #
# $HISTORY$                                                                  #
#                                                                            #
##############################################################################

#===============================================================================
proc PB_pps_ParseTclFile { EVENT_PROC_DATA } {
#===============================================================================
  upvar $EVENT_PROC_DATA event_proc_data
  global post_object
  global env

  Post::ReadPostFiles $post_object dir def_file tcl_file
  set tcl_file_name $dir/$tcl_file
  set tcl_fid [open $tcl_file_name r]

  set proc_strt 0
  while { [gets $tcl_fid line] >= 0 }\
  {
     if { [string match "*proc*" $line] == 1 && \
          [string match "*MOM*" $line] == 1 } \
     {
       set proc_strt 1
       set temp_line $line
       PB_com_RemoveBlanks temp_line

       set event_name [lindex $temp_line 1]
       unset temp_line
       lappend proc_data $prev_line

     } elseif { $proc_strt == 1 && \
                [string compare "\}" $line] == 0} \
     {
       set proc_strt 2
       lappend proc_data $line
     }

     if { $proc_strt == 1} \
     {
       lappend proc_data $line
     } elseif { $proc_strt == 2} \
     {
       set event_proc_data($event_name) $proc_data
       unset proc_data
       set proc_strt  0
     }
     set prev_line $line
  }
}
