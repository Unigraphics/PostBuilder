##############################################################################
# Description                                                                #
#     This file contains all functions dealing with the MDFA.                #
#                                                                            #
# Revisions                                                                  #
#                                                                            #
#   Date        Who       Reason                                             #
# 01-feb-1999   bmp       Initial                                            #
# 02-Jun-1999   mnb       Code Integration                                   #
# 07-Sep-1999   mnb       Integrated MDFT with Post Builder                  #
# 21-Sep-1999   mnb       Updates the Database                               #
# 13-Oct-1999   mnb       Incorporated the changes of database               #
# 26-Oct-1999   gsl       Added use of UI_PB_com_CreateTransientWindow.      #
# 17-Nov-1999   gsl       Submitted for phase-22.                                #
#                                                                            #
# $HISTORY$                                                                  #
#                                                                            #
##############################################################################
global env

source $env(PB_DIR)/mdfa/main.tcl

#===========================================================================
# API for the Formats
#============================================================================
proc PB_mdfc_CreateFormatObject { MDFA_FMT_OBJ_ATTR MDFA_FMT_LIST } {
#============================================================================
  upvar $MDFA_FMT_OBJ_ATTR mdfa_fmt_obj_attr
  upvar $MDFA_FMT_LIST mdfa_fmt_list

  PB_fmt_CreateFmtObj mdfa_fmt_obj_attr mdfa_fmt_list
#  puts "Format object is created [lrange $mdfa_fmt_list end end]"
}

#===========================================================================
# API for the Address
#===========================================================================
proc PB_mdfc_CreateAddrObject { MDFA_ADD_OBJ_ATTR MDFA_FMT_LIST \
                                MDFA_ADD_LIST } {
#===========================================================================
  upvar $MDFA_ADD_OBJ_ATTR mdfa_add_obj_attr
  upvar $MDFA_FMT_LIST mdfa_fmt_list
  upvar $MDFA_ADD_LIST mdfa_add_list

  PB_com_RetObjFrmName mdfa_add_obj_attr(1) mdfa_fmt_list ret_code
  set mdfa_add_obj_attr(1) $ret_code

  PB_adr_CreateValidAdrObj mdfa_add_obj_attr mdfa_add_list
#  puts "Address object created [lrange $mdfa_add_list end end]"
}

#===========================================================================
#  API for the blocks
#===========================================================================
proc PB_mdfa_CreateBlockObj { BLK_NAME BLK_ADD_LIST BLK_MOM_VAR \
                              BLK_OPT_VAL MDFA_BLK_LIST MDFA_ADD_LIST} {
#===========================================================================
  upvar $BLK_NAME blk_name
  upvar $BLK_ADD_LIST blk_add_list
  upvar $BLK_MOM_VAR blk_mom_var
  upvar $BLK_OPT_VAL blk_opt_val
  upvar $MDFA_BLK_LIST mdfa_blk_list
  upvar $MDFA_ADD_LIST mdfa_add_list
  global post_object

  set blk_obj_attr(0) $blk_name
  set no_blk_elems [llength $blk_add_list]
  set blk_elem_list ""

  for {set count 0} {$count < $no_blk_elems} {incr count} \
  {
     set blk_elem_obj_attr(0) [lindex $blk_add_list $count]
     set blk_elem_obj_attr(1) [lindex $blk_mom_var $count]
     set blk_elem_obj_attr(2) [lindex $blk_opt_val $count]
     switch $blk_elem_obj_attr(2) \
     {
       0       { set blk_elem_obj_attr(2) "blank" }
       1       { set blk_elem_obj_attr(2) "opt"   }
       2       { set blk_elem_obj_attr(2) "nows"  }
       3       { set blk_elem_obj_attr(2) "both"  }
       default { set blk_elem_obj_attr(2) "blank" }
     }

     switch $blk_elem_obj_attr(0)\
     {
        "LF_ENUM" - "LF_XABS" -
        "LF_YABS"  - "LF_ZABS"  -
        "LF_AAXIS" - "LF_BAXIS" -
        "LF_FEED"  -
        "LF_TIME"  -
        "LF_SPEED"  {
                       PB_blk_RetLfileAddObjFromList blk_elem_obj_attr
                       set blk_elem_obj_attr(3) ""
                       set blk_elem_obj_attr(4) 0
                    }
        default     {
                       PB_com_RetObjFrmName blk_elem_obj_attr(0) mdfa_add_list \
                                            ret_code
                       set blk_elem_obj_attr(0) $ret_code
   
                       set addr_name $address::($blk_elem_obj_attr(0),add_name)
                       PB_blk_RetWordDescArr addr_name elem_word_desc \
                                             blk_elem_obj_attr(1)
                       set blk_elem_obj_attr(3) $elem_word_desc
                       set blk_elem_obj_attr(4) 0
                    }
     }

     PB_blk_CreateBlkElemObj blk_elem_obj_attr new_elem_obj blk_obj_attr
     lappend blk_elem_list $new_elem_obj
     unset blk_elem_obj_attr
  }

  set blk_obj_attr(1) [llength $blk_elem_list]
  set blk_obj_attr(2) $blk_elem_list
  PB_blk_CreateBlkObj blk_obj_attr new_blk_obj
  if { [string compare $blk_obj_attr(0) "comment_data"] != 0} \
  {
     lappend mdfa_blk_list $new_blk_obj
  } else \
  {
     PB_lfl_AttrFromDef new_blk_obj post_object
  }
#  puts "BLOCK OBJ is Created $blk_obj_attr(0) $new_blk_obj"
  unset blk_obj_attr
}

#############################################################################
#           MDFA IMPORT
#############################################################################

#============================================================================
proc PB_mdfa_ImportMdfa { } {
#============================================================================
 global paOption
 global gPB

  set win $gPB(top_window).mdfa

  if { [winfo exists $win] } \
  {
    $win popup
  } else \
  {
    tixFileSelectDialog $win -command "PB_mdfa_ParseMdfa $win"

    UI_PB_com_CreateTransientWindow $win "Import MDFA" "540x450+250+250" \
                                    "" "PB_mdfa_ImportDestroy $win"
    $win popup

   # Sets the file box attributes
    set file_box [$win subwidget fsbox]
    $file_box config -pattern "*.mdfa"
    set top_filter_ent [[$file_box subwidget filter] subwidget entry]
    bind $top_filter_ent <Return> "PB_mdfa_ImportDlgFilter $win"

   # Sets the Action Button box attributes
    set but_box [$win subwidget btns]
    $but_box config -bg $paOption(butt_bg) -relief sunken

    destroy [$but_box subwidget help]

   #---------------------------------------------------------------------------
   # We need to re-claim the active window status, because a "destroy" command
   # has been issued. That causes the current window to lose its active status.
   #---------------------------------------------------------------------------
    UI_PB_com_ClaimActiveWindow $win

    [$but_box subwidget apply]  config -width 10 -command "PB_mdfa_ImportDlgFilter $win"
    [$but_box subwidget cancel] config -width 10 -command "PB_mdfa_ImportCancel_CB $win"
    [$but_box subwidget ok]     config -width 10
  }

 # Greyed out all saving options
  UI_PB_GreyOutAllFileOpts
}

#=========================================================================
proc PB_mdfa_ImportDlgFilter { dlg_id } {
#=========================================================================
  set file_box [$dlg_id subwidget fsbox]
  $file_box config -pattern "*.mdfa"

 # Updates the file listing box
  UI_PB_UpdateFileListBox $dlg_id
}

#=========================================================================
proc PB_mdfa_ImportDestroy { win } {
#=========================================================================
  # Activates the open, new file opetions
    UI_PB_EnableFileOptions
}

#=========================================================================
proc PB_mdfa_ImportCancel_CB { win } {
#=========================================================================
  $win popdown

  # Actives the file options
    UI_PB_EnableFileOptions
}

#=========================================================================
proc PB_mdfa_ParseMdfa { win mdfa_file_name } {
#=========================================================================
  if { [string compare $mdfa_file_name ""] == 0 } \
  {
     tk_messageBox -type ok -icon question \
                  -message "File is not selected"
     $win popup
return
  }

  set extension [file extension $mdfa_file_name]
  if { [string compare $extension ".mdfa"] != 0 } \
  {
     tk_messageBox -type ok -icon warning \
          -message "Selected file is not a mdfa. Pick a mdfa file"
     $win popup
return
  }

  if [catch {open $mdfa_file_name r} mdfa_file] \
  {
     tk_messageBox -type ok -icon error \
          -message "File \"$mdfa_file_name\" doesn't exists"
     $win popup
  } else \
  {
     MDFT_translator $mdfa_file
     PB_mdfa_CreateMdfaPost $mdfa_file_name
     tkwait variable mdfa_file_name

    # Activates save, close & Save As options
     UI_PB_ActivateOpenFileOpts

    # Unclaim active window status and release the grab
     UI_PB_com_UnclaimActiveWindow $win

    global gPB
     set gPB(session) NEW
  }
}

#============================================================================
proc PB_mdfa_CreateMdfaFormats { FORMAT_VAR_DATA MDFA_FMT_LIST } {
#============================================================================
  upvar $FORMAT_VAR_DATA format_var_data
  upvar $MDFA_FMT_LIST mdfa_fmt_list

  set  final_indx [array size format_var_data]
  set  no_of_fmts  [expr $final_indx/8]

  for {set count 0} {$count < $no_of_fmts } {incr count}\
  {
     for {set no_attr 0} {$no_attr < 8 } {incr no_attr}\
     {
         set fmt_obj_attr($no_attr) $format_var_data($count,$no_attr)
     }
     PB_mdfc_CreateFormatObject fmt_obj_attr mdfa_fmt_list
  }
}

#============================================================================
proc PB_mdfa_CreateMdfaAddresses { ADDRESSES_NAMES ADDRESSES_VAR_DATA \
                                   MDFA_FMT_LIST MDFA_ADDR_LIST \
                                   MDFA_LFADDR_LIST } {
#============================================================================
  upvar $ADDRESSES_NAMES address_names
  upvar $ADDRESSES_VAR_DATA addresses_var_data
  upvar $MDFA_FMT_LIST mdfa_fmt_list
  upvar $MDFA_ADDR_LIST mdfa_addr_list
  upvar $MDFA_LFADDR_LIST mdfa_lfaddr_list

  set no_of_addr [array size address_names]

  for {set count 0} {$count < $no_of_addr } {incr count}\
  {
     set add_name $address_names($count)
     for {set no_of_attr 0} { $no_of_attr < 12 } { incr no_of_attr} \
     {
       set addr_obj_attr($no_of_attr) $addresses_var_data($add_name,$no_of_attr)
     }
     PB_mdfc_CreateAddrObject addr_obj_attr mdfa_fmt_list mdfa_addr_list 
     unset addr_obj_attr
  }

  PB_adr_SepBlkAndLFileAddLists mdfa_addr_list mdfa_lfaddr_list
  PB_adr_CreateTextAddObj mdfa_addr_list mdfa_fmt_list
}

#============================================================================
proc PB_mdfa_CreateMdfaBlocks { BLOCK_NAMES BLOCK_TEMPLATE_DATA \
                                MDFA_BLK_LIST MDFA_ADDR_LIST } {
#============================================================================
  upvar $BLOCK_NAMES block_names
  upvar $BLOCK_TEMPLATE_DATA block_template_data
  upvar $MDFA_BLK_LIST mdfa_blk_list
  upvar $MDFA_ADDR_LIST mdfa_addr_list

  set no_of_blks [array size block_names]
  for {set count 0} {$count < $no_of_blks} {incr count} \
  {
     set blk_name $block_names($count)
     set blk_add_list $block_template_data($blk_name,add_list)
     set blk_mom_var $block_template_data($blk_name,var_list)
     set blk_opt_val $block_template_data($blk_name,opt_list)
     PB_mdfa_CreateBlockObj blk_name blk_add_list blk_mom_var \
                            blk_opt_val mdfa_blk_list mdfa_addr_list
  }
}

#============================================================================
proc PB_mdfa_OverwriteEventData { POST_OBJECT EVENT_NAMES \
                                  EVENT_TEMPLATE_DATA } {
#============================================================================
  global $POST_OBJECT post_object
  global $EVENT_NAMES event_names
  global $EVENT_TEMPLATE_DATA event_template_data

  set seq_list {prog_start oper_start tpth_ctrl tpth_mot \
                tpth_cycle oper_end prog_end}

  set mdfa_event_names [array names event_template_data]
  foreach sequence $seq_list \
  {
      append seq_evt_nam $sequence "_evt_list"
      append seq_evt_blk_nam $sequence "_evt_blk_list"

      array set seq_evt_arr $Post::($post_object,$seq_evt_nam)
      array set seq_evt_blk_arr $Post::($post_object,$seq_evt_blk_nam)

      set no_evts [array size seq_evt_arr]
      for {set count 0} {$count < $no_evts} {incr count} \
      {
         set event_name_list [split $seq_evt_arr($count)]
         foreach elem $event_name_list \
         {
            set new_elem [string tolower $elem]
            lappend new_event_name $new_elem
         }
         set new_event_name [linsert $new_event_name 0 "MOM"]
         set event_name [join $new_event_name _]
         unset new_event_name
         set exist_flag [lsearch $mdfa_event_names $event_name]

         if { $exist_flag == -1} \
         {
            set seq_evt_blk_arr($count) ""
         } else \
         {
            set seq_evt_blk_arr($count) \
                       $event_template_data($event_name)
         }
      }
      set Post::($post_object,$seq_evt_nam) [array get seq_evt_arr]
      set Post::($post_object,$seq_evt_blk_nam) [array get seq_evt_blk_arr]
      unset seq_evt_nam seq_evt_blk_nam
      unset seq_evt_arr seq_evt_blk_arr
  }
  set Post::($post_object,cyl_com_evt) ""
  set Post::($post_object,cyl_evt_sh_com_evt) ""
}

#============================================================================
proc PB_mdfa_OverwriteKinVariables { KINEMATIC_VARIABLES } {
#============================================================================
  upvar $KINEMATIC_VARIABLES kinematic_variables
  global mom_kin_var
  global post_object

  foreach element  [lsort [ array names kinematic_variables]]\
  {
     set mom_kin_var($element) $kinematic_variables($element)
  }

  set Post::($post_object,mom_kin_var_list) [array get mom_kin_var]
  set Post::($post_object,def_mom_kin_var_list) [array get mom_kin_var]
}

#============================================================================
proc PB_mdfa_OverwriteSysVariables { SYSTEM_VAR_DATA } {
#============================================================================
  upvar $SYSTEM_VAR_DATA system_var_data
  global mom_sys_arr
  global post_object

  foreach element  [lsort [ array names System_var_data]]\
  {
     set mdfa_sys_var \$$element
     set mom_sys_arr($mdfa_sys_var) $system_var_data($element)
  }
  set Post::($post_object,mom_sys_var_list) [array get mom_sys_arr]
  set Post::($post_object,def_mom_sys_var_list) [array get mom_sys_arr]
}

#============================================================================
proc PB_mdfa_MiscProc { POST_OBJECT MDFA_FILE } {
#============================================================================
  upvar $POST_OBJECT post_object
  upvar $MDFA_FILE mdfa_file

  # Listing File Objects
#    set listfile_obj [new ListingFile]
#    set Post::($post_object,list_obj_list) $listfile_obj
#    set ListingFile::($listfile_obj,add_obj_list) ""
#    set ListingFile::($listfile_obj,block_obj) ""

  set FileId FP1
  set parser_obj [new ParseFile $FileId]
  set Post::($post_object,def_parse_obj) $parser_obj
  set ParseFile::($parser_obj,file_list)  $mdfa_file
  set bef_com_data($mdfa_file) ""
  set aft_com_data($mdfa_file) ""
  set ParseFile::($parser_obj,bef_com_data_list) [array get bef_com_data]
  set ParseFile::($parser_obj,aft_com_data_list) [array get aft_com_data]
}

#============================================================================
proc PB_mdfa_CreateMdfaPost { mdfa_file_name } {
#============================================================================
  global env
  global post_object
  global mach_type axisoption

 # MDFA variables
  global Format_var_data
  global Addresses_name
  global Addresses_var_data
  global block_names
  global block_template_data
  global event_names
  global event_template_data
  global obj_attr_kinematic_variables
  global obj_attr_fly_variables
  global System_var_data
  global Word_Separator_var_data
  global EOL_var_data
  global Sequence_var_data
  global ListObjectAttr
  global ListObjectList
  set pui_file_id FP2

  # Gets Machine type and the axis type
    PB_com_GetMachAxisType obj_attr_kinematic_variables \
                           mach_type axisoption
    set output_unit $obj_attr_kinematic_variables(mom_kin_output_unit)
    set file_name pb_${mach_type}_${axisoption}_Generic_${output_unit}

  # Parses the default pui file based upon the machine type
    set pui_file_name "$env(PB_HOME)/pblib/$file_name.pui"
    PB_com_ReadPuiFile pui_file_name pui_file_id post_object

  # Word seperator
    set Post::($post_object,word_sep) $Word_Separator_var_data

  # End of Block
    set Post::($post_object,end_of_line) $EOL_var_data

  # Sequence Number block data
    set Post::($post_object,sequence_param) [array get Sequence_var_data]

  # Creates MDFA format objects
    PB_mdfa_CreateMdfaFormats Format_var_data mdfa_fmt_list

  # Creates MDFA Address objects
    PB_mdfa_CreateMdfaAddresses Addresses_name Addresses_var_data \
                                mdfa_fmt_list mdfa_addr_list mdfa_lfile_list
    PB_adr_SortAddresses mdfa_addr_list

  # Stores the format object list as post object attribuite.
    Post::SetObjListasAttr $post_object mdfa_fmt_list

  # Stores the address object list as post object attribuite.
    Post::SetObjListasAttr $post_object mdfa_addr_list
    ListingFile::SetLfileAddObjList $post_object mdfa_lfile_list

  # Creates the data for all the block elements.
    Post::WordAddNamesSubNamesDesc $post_object

  # Sets the master sequence.
    Post::SetDefMasterSequence $post_object mdfa_addr_list

  # Create mdfa block templates and store it in the post 
  # object
    PB_mdfa_CreateMdfaBlocks block_names block_template_data \
                             mdfa_blk_list mdfa_addr_list
    Post::SetObjListasAttr $post_object mdfa_blk_list

  # Returns the display variables for the Block page.
    PB_blk_RetDisVars mdfa_blk_list BlockNameList WordDescArray \
                                    post_object

  # Returns the display variables for the List File page.
    set ListObjectList $Post::($post_object,list_obj_list)
    PB_lfl_RetDisVars ListObjectList ListObjectAttr

  # Creates mdfa events & sequence
    PB_mdfa_OverwriteEventData post_object event_names event_template_data
    PB_seq_CreateSequences post_object

  # Temperary fix for listing file data
    PB_mdfa_MiscProc post_object mdfa_file_name

  # Defines all the global variables for the ui
    PB_int_DefineUIGlobVar

  # Overwrites the data of mom_sys_variables and kinematic
  # variables
    PB_mdfa_OverwriteSysVariables System_var_data
    PB_mdfa_OverwriteKinVariables obj_attr_kinematic_variables

  # Sets the post output files
    set dir [file dirname $mdfa_file_name]
    if { $dir == "." } \
    {
       set dir [pwd]
    }
    set file_name [file tail $mdfa_file_name]
    set file_name [file rootname $file_name]
    set pui_file $file_name.pui
    set def_file $file_name.def
    set tcl_file $file_name.tcl
    PB_int_SetPostOutputFiles dir pui_file def_file tcl_file

  # Activates save, close & Save As options and deactivates
  # open & close
    UI_PB_ActivateOpenFileOpts

  UI_PB_main_window
  update
  AcceptMachineToolSelection 
}
