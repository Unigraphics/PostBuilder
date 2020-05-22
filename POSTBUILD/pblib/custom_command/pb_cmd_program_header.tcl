#=============================================================
proc PB_CMD_program_header { } {
#=============================================================
#
#  This procedure will output a program header with the following format:
#
#       Attribute assigned to program (Name of program group)
#
#       Example: O0001 (NC_PROGRAM)
#
#
#  Place this custom command in the start of program event marker.  This 
#  custom command must be placed after any initial codes (such as #).  The
#  custom command MOM_set_seq_off must precede this custom command to 
#  prevent sequence numbers from being output with the program number.
#
#  If you are adding this custom command to a linked post, this custom
#  command must be added to the main post only.  It will not be output by
#  any subordinate posts.
#
#  If there is no attribute assigned to the program group, the string O0001 
#  will be used.  In any case the name of the program in Program View will
#  be output as a comment.
#
#  To assign an attribute to the program, right click on the program.  Under
#  properties, select attribute.  Use the string "program_number" as the 
#  title of the attribute.  Enter the string you need for the program
#  name, O0010 for example, as the value of the attribute.  Use type string for the
#  the attribute.  Each program group can have a unique program number.
#


global mom_attr_PROGRAMVIEW_PROGRAM_NUMBER
global mom_group_name

if {![info exists mom_group_name]} {set mom_group_name ""}
if {![info exists mom_attr_PROGRAMVIEW_PROGRAM_NUMBER]} {set mom_attr_PROGRAMVIEW_PROGRAM_NUMBER "O0001"}
MOM_output_literal "$mom_attr_PROGRAMVIEW_PROGRAM_NUMBER ($mom_group_name)"
}



