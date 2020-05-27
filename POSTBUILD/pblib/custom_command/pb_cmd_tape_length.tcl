#=============================================================
proc PB_CMD_ptp_size { } {
#=============================================================
# Output the current size of the ptp output file.
# Add this to the end of the End of Program event. 

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

