##############################################################################
#                                                                            #
# Copyright (c) 1999/2000/2001/2002/2003/2004, Unigraphics Solutions Inc.    #
#                                                                            #
##############################################################################

#=============================================================
proc PB_CMD_ptp_file_size { } {
#=============================================================
#
#  Output the current size of the ptp output file.
#  Add this to the end of the End of Program event. 
#
   global ptp_file_name
   global mom_sys_control_out
   global mom_sys_control_in

   set ci $mom_sys_control_in
   set co $mom_sys_control_out

 # Check the file size

   MOM_close_output_file   $ptp_file_name
   set ptp_size [file size $ptp_file_name]
   MOM_open_output_file   $ptp_file_name


 # Put a message for the file size in the ptp file

   set ptp_feet [expr $ptp_size/120.]
   MOM_output_literal "$co PTP file size = $ptp_size bytes  [format "%5.1f" $ptp_feet] feet $ci"
}


#=============================================================
proc PB_CMD_output_tape_per_operation { } {
#=============================================================
#
#  This procedure can be used to output an N/C tape with each operation.
#  Place this custom command at the VERY begining of the Start of Operation
#  event marker.
#
#  This proc will also delete the initial program tape and rename it to 
#  {operation_name}{sequence number}{extension}.
#  Any N/C code output with the Program Start sequence will be lost.
# 
   global ptp_file_name
   global mom_output_file_directory
   global mom_operation_name
   global mom_output_file_basename
   global mom_sys_output_file_suffix

#
# Remove next two lines of code if you don't want the original nc tape
# with the start of program info to be deleted.
#
   set fn ${mom_output_file_directory}${mom_output_file_basename}.${mom_sys_output_file_suffix}
   if [file exists $fn] {MOM_remove_file $fn}

   MOM_close_output_file $ptp_file_name

   set ptp_file_name "${mom_output_file_directory}${mom_operation_name}.${mom_sys_output_file_suffix}"
   MOM_remove_file $ptp_file_name
   MOM_open_output_file $ptp_file_name
}

