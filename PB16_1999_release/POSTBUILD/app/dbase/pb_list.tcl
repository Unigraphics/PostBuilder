##############################################################################
# Description                                                                #
#     This file contains all functions dealing with the LISTFILE Object.     #
# The definition file is read and the respective LISTFILE Objects are        #
# created. All actions on the listfile page of the UI is mapped into the     #
# respective functions in this file through the interface file.              #
#                                                                            #
# Revisions                                                                  #
#                                                                            #
#   Date        Who   Reason                                                 #
# 01-feb-1999   bmp   Initial                                                #
# 07-Apr-1999   mnb   Removed puts                                           #
# 02-Jun-1999   mnb   Code Integration                                       #
#                                                                            #
# $HISTORY$                                                                  #
#                                                                            #
##############################################################################

#=============================================================================
#This procedure takes the list file block element object list and post object 
#list as the input and the list file attributes are set according to the 
#address names stored in the block element. The list file object is stored as 
#the post object attribute.
#=============================================================================

proc PB_lfl_AttrFromDef { BLK_OBJ POST_OBJ} {
  upvar $BLK_OBJ blk_obj
  upvar $POST_OBJ post_obj

  #Sets the list file object from post object.
  set list_file_obj $Post::($post_obj,list_obj_list)

  #List file addresses are seperated from other addresses.
  set blk_elem_obj_list $block::($blk_obj,elem_addr_list)

  foreach object $blk_elem_obj_list\
  {
    #sets the address object from the block element object.
    set add_obj $block_element::($object,elem_add_obj)

    #sets the address name.
    set add_obj_name $address::($add_obj,add_name)
    
    #According to the address names the list file attributes are set.
    switch $add_obj_name\
    {
       LF_XABS      {set ListingFile::($list_file_obj,x)     1}
       LF_YABS      {set ListingFile::($list_file_obj,y)     1}
       LF_ZABS      {set ListingFile::($list_file_obj,z)     1}
       LF_AAXIS     {set ListingFile::($list_file_obj,4axis) 1}
       LF_BAXIS     {set ListingFile::($list_file_obj,5axis) 1}
       LF_FEED      {set ListingFile::($list_file_obj,feed)  1}
       LF_SPEED     {set ListingFile::($list_file_obj,speed) 1}
    }
  }

  #The list file attributes are read and stored as the default value.
  ListingFile::readvalue $list_file_obj obj_attr
  ListingFile::DefaultValue $list_file_obj obj_attr
  ListingFile::SetLfileBlockObj $list_file_obj blk_obj
}

#===============================================================================
#This function takes the object attributes and the updated LIST FILE object list
#as the input, creates the LIST FILE Object and returns the updated object list.
#We are creating only one list file object and the list will be having only one
#element.
#===============================================================================

proc PB_lfl_CreateLfileObj { OBJ_ATTR OBJ_LIST } {
  upvar $OBJ_ATTR obj_attr
  upvar $OBJ_LIST obj_list

  #Creates new object.
  set object [new ListingFile]

  #Appends object id to the object list.
  lappend obj_list $object

  #sets the latest value to the object created.
  ListingFile::setvalue_from_pui $object obj_attr

  #Sets the default value to the object.
  ListingFile::readvalue $object obj_attr
  ListingFile::DefaultValue $object obj_attr
#  puts "The object is Created: $object "
}


#=================================================================================
#This procedure will take the LIST FILE Object as the input and returns the 
#Default value stored in the object as the output.
#=================================================================================

proc PB_lfl_DefLfileParams { OBJECT OBJ_ATTR } {
  upvar $OBJECT   object
  upvar $OBJ_ATTR obj_attr
  
  #Sets the default value.
  array set obj_attr $ListingFile::($object,def_value)
}

#=================================================================================
#This procedure will take the LIST FILE Object as the input and returns the 
#Restore value stored in the object as the output.
#=================================================================================

proc PB_lfl_ResLfileParams { OBJECT OBJ_ATTR } {
  upvar $OBJECT   object
  upvar $OBJ_ATTR obj_attr
  
  #Sets the resotre value.
  array set obj_attr $ListingFile::($object,restore_value)
}

#=================================================================================
#This procedure will take the LIST FILE Object as the input and returns the 
#Restore value stored in the object as the output.
#=================================================================================

proc PB_lfl_RetDisVars { OBJECT OBJ_ATTR } {
  upvar $OBJECT   object
  upvar $OBJ_ATTR obj_attr

  #Reads and sets the latest value in the attribute array.
  ListingFile::readvalue $object obj_attr
}
