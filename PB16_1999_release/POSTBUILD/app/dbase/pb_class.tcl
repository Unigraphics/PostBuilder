##############################################################################
# Description                                                                #
#     This fiel contains all the functions dealing with FORMAT objects       #
#                                                                            #
# Revisions                                                                  #
#                                                                            #
#   Date        Who   Reason                                                 #
# 01-feb-1999   bmp   Initial                                                #
# 03-May-1999   mnb   Added event element class                              #
# 20-May-1999   mnb   Added few new procedures to classes                    #
# 02-Jun-1999   mnb   Code Integration                                       #
# 11-Jun-1999   mnb   Added new procedures to the class ParseFile            #
# 14-Jun-1999   mnb   Eliminated N from combobox list                        #
# 29-Jun-1999   mnb   Added a new attribute for text element                 #
# 07-Sep-1999   mnb   Added a new attribute to group_member .. to store      #
#                     the data type of the widget                            #
# 21-Sep-1999   mnb   Force Output is an attribute of block element object   #
# 27-Sep-1999   mnb   Stores definition & Tcl file names of a post as Post   #
#                     object attributes                                      #
# 13-Oct-1999   mnb   Added new methods to Class Post, to store directory    #
#                     and tcl,def & pui file names                           #
#                                                                            #
# $HISTORY$                                                                  #
#                                                                            #
##############################################################################

class format {
    proc format {this} {
        set format::($this,for_name)      "DEFAULT"
        set format::($this,fmt_addr_list) ""
    }
    proc ~format {this} {}

    proc setvalue {this OBJ_ATTR} {
       upvar $OBJ_ATTR obj_attr

       set format::($this,for_name)       $obj_attr(0)
       set format::($this,for_dtype)      $obj_attr(1)
       set format::($this,for_leadplus)   $obj_attr(2)
       set format::($this,for_leadzero)   $obj_attr(3)
       set format::($this,for_trailzero)  $obj_attr(4)
       set format::($this,for_valfpart)   $obj_attr(5)
       set format::($this,for_outdecimal) $obj_attr(6)
       set format::($this,for_valspart)   $obj_attr(7)
    }

    proc readvalue {this OBJ_ATTR} {
      upvar $OBJ_ATTR obj_attr

      set obj_attr(0) $format::($this,for_name)
      set obj_attr(1) $format::($this,for_dtype)
      set obj_attr(2) $format::($this,for_leadplus)
      set obj_attr(3) $format::($this,for_leadzero)
      set obj_attr(4) $format::($this,for_trailzero)
      set obj_attr(5) $format::($this,for_valfpart)
      set obj_attr(6) $format::($this,for_outdecimal)
      set obj_attr(7) $format::($this,for_valspart)
    }

    proc DefaultValue {this OBJ_ATTR} {
       upvar $OBJ_ATTR obj_attr
    
       set def_value [array get obj_attr]
       set format::($this,def_value) $def_value
    }

    proc AddToAddressList {this ADDR_OBJ} {
       upvar $ADDR_OBJ addr_obj

       lappend format::($this,fmt_addr_list) $addr_obj
    }

    proc DeleteFromAddressList {this ADDR_OBJ} {
       upvar $ADDR_OBJ addr_obj

       set index [lsearch $format::($this,fmt_addr_list) \
                             $addr_obj]
       if {$index != -1} \
       {
         set format::($this,fmt_addr_list) \
              [lreplace $format::($this,fmt_addr_list) $index $index]
       }
    }
}

class address {
    proc address {this} {
        set address::($this,add_name)     "DEFAULT"
        set address::($this,obj_attr_cnt) 12
        set address::($this,blk_elem_list) ""
    }

    proc ~address {this} {}

    proc setvalue {this OBJ_ATTR} {
       upvar $OBJ_ATTR obj_attr

       set address::($this,add_name)           $obj_attr(0)
       set address::($this,add_format)         $obj_attr(1)
       set address::($this,add_force)          $obj_attr(2)
       set address::($this,add_force_status)   $obj_attr(3)
       set address::($this,add_max)            $obj_attr(4)
       set address::($this,add_max_status)     $obj_attr(5)
       set address::($this,add_min)            $obj_attr(6)
       set address::($this,add_min_status)     $obj_attr(7)
       set address::($this,add_leader)         $obj_attr(8)
       set address::($this,add_trailer)        $obj_attr(9)
       set address::($this,add_trailer_status) $obj_attr(10)
       set address::($this,add_incremental)    $obj_attr(11)
    }

    proc readvalue {this OBJ_ATTR} {
      upvar $OBJ_ATTR obj_attr

      set obj_attr(0)  $address::($this,add_name)
      set obj_attr(1)  $address::($this,add_format)
      set obj_attr(2)  $address::($this,add_force)
      set obj_attr(3)  $address::($this,add_force_status)
      set obj_attr(4)  $address::($this,add_max)
      set obj_attr(5)  $address::($this,add_max_status)
      set obj_attr(6)  $address::($this,add_min)
      set obj_attr(7)  $address::($this,add_min_status)
      set obj_attr(8)  $address::($this,add_leader)
      set obj_attr(9)  $address::($this,add_trailer)
      set obj_attr(10) $address::($this,add_trailer_status)
      set obj_attr(11) $address::($this,add_incremental)
    }

    proc DefaultValue {this OBJ_ATTR} {
       upvar $OBJ_ATTR obj_attr
    
       set def_value [array get obj_attr]
       set address::($this,def_value) $def_value
    }

    proc SetMseqAttr { this MSEQ_ATTR } {
       upvar $MSEQ_ATTR mseq_attr

       set address::($this,rep_mom_var) $mseq_attr(0)
       set address::($this,word_status) $mseq_attr(1)
       set address::($this,word_desc)   $mseq_attr(2)
       set address::($this,seq_no)      $mseq_attr(3)
    }

    proc readMseqAttr { this MSEQ_ATTR } {
       upvar $MSEQ_ATTR mseq_attr
      
       set mseq_attr(0) $address::($this,rep_mom_var)
       set mseq_attr(1) $address::($this,word_status)
       set mseq_attr(2) $address::($this,word_desc)
       set mseq_attr(3) $address::($this,seq_no)
    }

    proc DefaultMseqAttr {this MSEQ_ATTR} {
       upvar $MSEQ_ATTR mseq_attr
    
       set def_value [array get mseq_attr]
       set address::($this,def_mseq_attr) $def_value
    }

    proc RestoreMseqAttr {this} {
    
       address::readMseqAttr $this mseq_attr
       set rest_value [array get mseq_attr]
       set address::($this,rest_mseq_attr) $rest_value
    }

    proc AddToBlkElemList {this BLK_ELEM_OBJ} {
       upvar $BLK_ELEM_OBJ blk_elem_obj

       lappend address::($this,blk_elem_list) $blk_elem_obj
    }

    proc DeleteFromBlkElemList {this BLK_ELEM_OBJ} {
       upvar $BLK_ELEM_OBJ blk_elem_obj

       set index [lsearch $address::($this,blk_elem_list) \
                             $blk_elem_obj]
       if {$index != -1} \
       {
         set address::($this,blk_elem_list) \
              [lreplace $address::($this,blk_elem_list) $index $index]
       }
    }
}

class Post {
    proc Post {this post_name} {
        set Post::($this,post_name) $post_name
    }

    proc ~Post {this} {}

    proc SetPostFiles { this PUI_DIR POST_FILES } {
       upvar $PUI_DIR pui_dir
       upvar $POST_FILES post_files

       set Post::($this,pui_dir)  $pui_dir
       set Post::($this,def_file) $post_files(def_file)
       set Post::($this,tcl_file) $post_files(tcl_file)
    }

    proc ReadPostFiles { this PUI_DIR DEF_FILE TCL_FILE } {
       upvar $PUI_DIR pui_dir
       upvar $DEF_FILE def_file
       upvar $TCL_FILE tcl_file

       set pui_dir $Post::($this,pui_dir)
       set def_file $Post::($this,def_file)
       set tcl_file $Post::($this,tcl_file)
    }

    proc SetPostOutputFiles { this DIR PUI_FILE DEF_FILE TCL_FILE } {
       upvar $DIR dir
       upvar $PUI_FILE pui_file
       upvar $DEF_FILE def_file
       upvar $TCL_FILE tcl_file

       set Post::($this,output_dir) $dir
       set Post::($this,out_pui_file) $pui_file
       set Post::($this,out_def_file) $def_file
       set Post::($this,out_tcl_file) $tcl_file
    }

    proc ReadPostOutputFiles { this DIR PUI_FILE DEF_FILE TCL_FILE } {
       upvar $DIR dir
       upvar $PUI_FILE pui_file
       upvar $DEF_FILE def_file
       upvar $TCL_FILE tcl_file

       set dir $Post::($this,output_dir)
       set pui_file $Post::($this,out_pui_file)
       set def_file $Post::($this,out_def_file)
       set tcl_file $Post::($this,out_tcl_file)
    }

    proc InitG-Codes {this G_CODES G_CODES_DESC} {
       upvar $G_CODES g_codes
       upvar $G_CODES_DESC g_codes_desc


       set temp_g_codes [array get g_codes]
       set temp_g_codes_desc [array get g_codes_desc]

       set Post::($this,g_codes) $temp_g_codes
       set Post::($this,g_codes_desc) $temp_g_codes_desc
    }

    proc InitM-Codes {this M_CODES M_CODES_DESC} {
       upvar $M_CODES m_codes
       upvar $M_CODES_DESC m_codes_desc


       set temp_m_codes [array get m_codes]
       set temp_m_codes_desc [array get m_codes_desc]

       set Post::($this,m_codes) $temp_m_codes
       set Post::($this,m_codes_desc) $temp_m_codes_desc
    }
   
    proc InitMasterSequence { this MSQ_ADD_NAME MSQ_WORD_PARAM } {
        upvar $MSQ_ADD_NAME msq_add_name
        upvar $MSQ_WORD_PARAM msq_word_param
         
        set temp_msq_word_param  [array get msq_word_param]
        set Post::($this,msq_word_param)  $temp_msq_word_param
        set Post::($this,msq_add_name) $msq_add_name
    }
   
    proc SetDefMasterSequence {this ADD_OBJ_LIST} {
        upvar $ADD_OBJ_LIST add_obj_list

        set Post::($this,def_mast_seq) $add_obj_list
    }
    
    proc MachineTool {this machine_tool} {
        upvar $machine_tool mtool
        set Post::($this,machine_tool) $mtool
    }
    
    proc ListFileObject {this list_obj_list} {
        upvar $list_obj_list obj_list
        set Post::($this,list_obj_list) $obj_list
    }
    
    proc SetObjListasAttr {this OBJ_LIST} {
       upvar $OBJ_LIST obj_list
       
       set object [lindex $obj_list 0]
       set ClassName [string trim [classof $object] ::]
        switch $ClassName\
        {
            format    {set Post::($this,fmt_obj_list) $obj_list}
            address   {set Post::($this,add_obj_list) $obj_list}
            block     {set Post::($this,blk_obj_list) $obj_list}
        }
    }

    proc WordAddNamesSubNamesDesc {this} {

       set msq_add_name $Post::($this,msq_add_name)
       set Post::($this,word_name_list) $msq_add_name
       
       PB_com_WordSubNamesDesc this word_subnames_desc_array word_mom_var \
                               mom_sys_arr 

       set word_subnames_desc_list [array get word_subnames_desc_array]
       set word_mom_var_list [array get word_mom_var]
       set mom_sys_var_list [array get mom_sys_arr] 
       set Post::($this,word_desc_array) $word_subnames_desc_list
       set Post::($this,word_mom_var) $word_mom_var_list
       set Post::($this,mom_sys_var_list) $mom_sys_var_list
    }
}

class block_element {
    proc block_element {this block_name} {
        set block_element::($this,parent_name) $block_name
        set block_element::($this,owner) "NONE"
        set block_element::($this,force) 0
    }

    proc ~block_element {this} {}

    proc setvalue {this OBJ_ATTR} {
       upvar $OBJ_ATTR obj_attr

       set block_element::($this,elem_add_obj)      $obj_attr(0)
       set block_element::($this,elem_mom_variable) $obj_attr(1)
       set block_element::($this,elem_opt_nows_var) $obj_attr(2)
       set block_element::($this,elem_desc)         $obj_attr(3)
       set block_element::($this,force)             $obj_attr(4)
    }

    proc readvalue {this OBJ_ATTR} {
      upvar $OBJ_ATTR obj_attr

      set obj_attr(0) $block_element::($this,elem_add_obj)
      set obj_attr(1) $block_element::($this,elem_mom_variable)
      set obj_attr(2) $block_element::($this,elem_opt_nows_var)
      set obj_attr(3) $block_element::($this,elem_desc)
      set obj_attr(4) $block_element::($this,force)
    }

    proc DefaultValue {this OBJ_ATTR} {
       upvar $OBJ_ATTR obj_attr
    
       set def_value [array get obj_attr]
       set block_element::($this,def_value) $def_value
    }

    proc RestoreValue {this} {
       block_element::readvalue $this obj_attr
       set block_element::($this,rest_value) [array get obj_attr]
    }
}

class block {
    proc block {this} {
        set block::($this,block_name) "DEFAULT"
        set block::($this,blk_owner) "NONE"
        set block::($this,evt_addr_list) ""
    }

    proc ~block {this} {
        set count [llength $block::($this,elem_addr_list)]
        foreach element $block::($this,elem_addr_list)\
        {
         delete $element
        }
    }

    proc setvalue {this OBJ_ATTR} {
       upvar $OBJ_ATTR obj_attr

       set block::($this,block_name)         $obj_attr(0)
       set block::($this,block_nof_elements) $obj_attr(1)
       set block::($this,elem_addr_list)     $obj_attr(2)
    }

    proc readvalue {this OBJ_ATTR} {
      upvar $OBJ_ATTR obj_attr

      set obj_attr(0) $block::($this,block_name)
      set obj_attr(1) $block::($this,block_nof_elements)
      set obj_attr(2) $block::($this,elem_addr_list)
    }

    proc DefaultValue {this OBJ_ATTR} {
       upvar $OBJ_ATTR obj_attr
    
       set def_value [array get obj_attr]
       set block::($this,def_value) $def_value
    }

    proc RestoreValue {this} {

       block::readvalue $this obj_attr
       set block::($this,rest_value) [array get obj_attr]
    }

    proc AddToEventList {this EVENT_OBJ} {
       upvar $EVENT_OBJ event_obj

       lappend block::($this,evt_addr_list) $event_obj
    }

    proc DeleteFromEventList {this EVENT_OBJ} {
       upvar $EVENT_OBJ event_obj

       set index [lsearch $block::($this,evt_addr_list) \
                             $event_obj]
       if {$index != -1} \
       {
         set block::($this,evt_addr_list) \
              [lreplace $block::($this,evt_addr_list) $index $index]
       }
    }
}

class event_element {
    proc event_element {this} {
        set event_element($this,evt_elem_name) "DEFAULT"
    }

    proc ~event_element {this} { }

    proc setvalue {this OBJ_ATTR} {
      upvar $OBJ_ATTR obj_attr

      set event_element::($this,evt_elem_name) $obj_attr(0)
      set event_element::($this,block_obj) $obj_attr(1)
      set event_element::($this,type) $obj_attr(2)
    }

    proc readvalue {this OBJ_ATTR} {
      upvar $OBJ_ATTR obj_attr
      
      set obj_attr(0) $event_element::($this,evt_elem_name)
      set obj_attr(1) $event_element::($this,block_obj)
      set obj_attr(2) $event_element::($this,type)
    }

    proc DefaultValue {this OBJ_ATTR} {
       upvar $OBJ_ATTR obj_attr
    
       set def_value [array get obj_attr]
       set event_element::($this,def_value) $def_value
    }

    proc RestoreValue {this} {

       event_element::readvalue $this obj_attr
       set event_element::($this,rest_value) [array get obj_attr]
    }
}

class event {
    proc event {this} {
        set event::($this,event_name) "DEFAULT"
        set event::($this,event_open) 0
    }
    
    proc ~event {this} {}
    
    proc setvalue {this OBJ_ATTR} {
       upvar $OBJ_ATTR obj_attr

       set event::($this,event_name)          $obj_attr(0)
       set event::($this,block_nof_rows)      $obj_attr(1)
       set event::($this,evt_elem_list)       $obj_attr(2)
       set event::($this,evt_itm_obj_list)    $obj_attr(3)
    }

   proc readvalue {this OBJ_ATTR} {
       upvar $OBJ_ATTR obj_attr
       set obj_attr(0) $event::($this,event_name)
       set obj_attr(1) $event::($this,block_nof_rows)
       set obj_attr(2) $event::($this,evt_elem_list)
       set obj_attr(3) $event::($this,evt_itm_obj_list)
   }

   proc DefaultValue {this OBJ_ATTR} {
       upvar $OBJ_ATTR obj_attr
       set def_value [array get obj_attr]
       set event::($this,def_value) $def_value
   }

   proc RestoreValue {this} {
       event::readvalue $this obj_attr
       set event::($this,rest_value) [array get obj_attr]
   }
}

class sequence {
    proc sequence {this} {
        set sequence::($this,seq_name) "DEFAULT"
    }
    
    proc ~sequence {this} {}
    
    proc setvalue {this OBJ_ATTR} {
       upvar $OBJ_ATTR obj_attr

       set sequence::($this,seq_name)         $obj_attr(0)
       set sequence::($this,evt_obj_list)     $obj_attr(1)
       set sequence::($this,comb_elem_list)   $obj_attr(2)
    }

    proc readvalue {this OBJ_ATTR} {
       upvar $OBJ_ATTR obj_attr

       set obj_attr(0) $sequence::($this,seq_name)
       set obj_attr(1) $sequence::($this,evt_obj_list)
       set obj_attr(2) $sequence::($this,comb_elem_list)
    }

    proc DefaultValue {this OBJ_ATTR} {
       upvar $OBJ_ATTR obj_attr
       
       set def_value [array get obj_attr]
       set sequence::($this,def_value) $def_value
    }

   proc RestoreValue {this} {
       sequence::readvalue $this obj_attr
       set sequence::($this,rest_value) [array get obj_attr]
   }
}

class item {
    proc item {this} {
        set item::($this,item_name) "DEFAULT"
    }

    proc ~item {this} {}

    proc setvalue {this OBJ_ATTR} {
       upvar $OBJ_ATTR obj_attr
     
       set item::($this,label)         $obj_attr(0)
       set item::($this,nof_grps)      $obj_attr(1)
       set item::($this,grp_align)     $obj_attr(2)
       set item::($this,grp_obj_list)  $obj_attr(3)
    }

    proc readvalue {this OBJ_ATTR} {
       upvar $OBJ_ATTR obj_attr

       set obj_attr(0) $item::($this,label)
       set obj_attr(1) $item::($this,nof_grps)
       set obj_attr(2) $item::($this,grp_align)
       set obj_attr(3) $item::($this,grp_obj_list)
    }

    proc DefaultValue {this OBJ_ATTR} {
       upvar $OBJ_ATTR obj_attr
       
       set def_value [array get obj_attr]
       set item::($this,def_value) $def_value
    }

   proc RestoreValue {this} {
       item::readvalue $this obj_attr
       set item::($this,rest_value) [array get obj_attr]
   }
}

class item_group {
    proc item_group {this} {
       set item_group::($this,elem_name) "DEFAULT"
    }

    proc ~item_group {this} {}

    proc setvalue {this OBJ_ATTR} {
       upvar $OBJ_ATTR obj_attr
    
       set item_group::($this,name)            $obj_attr(0)
       set item_group::($this,nof_elems)       $obj_attr(1)
       set item_group::($this,elem_align)      $obj_attr(2)
       set item_group::($this,mem_obj_list)    $obj_attr(3)
    }

    proc readvalue {this OBJ_ATTR} {
       upvar $OBJ_ATTR obj_attr

       set obj_attr(0) $item_group::($this,name)
       set obj_attr(1) $item_group::($this,nof_elems)
       set obj_attr(2) $item_group::($this,elem_align)
       set obj_attr(3) $item_group::($this,mem_obj_list)
    }

    proc DefaultValue {this OBJ_ATTR} {
       upvar $OBJ_ATTR obj_attr
       
       set def_value [array get obj_attr]
       set item_group::($this,def_value) $def_value
    }

   proc RestoreValue {this} {
       item_group::readvalue $this obj_attr
       set item_group::($this,rest_value) [array get obj_attr]
   }
}

class group_member {
    proc group_member {this} {
       set group_member::($this,elem_name) "DEFAULT"
    }
    
    proc ~group_member {this} {}
  
    proc setvalue {this OBJ_ATTR} {
       upvar $OBJ_ATTR obj_attr

       set group_member::($this,label)       $obj_attr(0)
       set group_member::($this,widget_type) $obj_attr(1)
       set group_member::($this,data_type)   $obj_attr(2)
       set group_member::($this,mom_var)     $obj_attr(3)
       set group_member::($this,callback)    $obj_attr(4)
       set group_member::($this,opt_list)    $obj_attr(5)
    }

    proc readvalue {this OBJ_ATTR} {
       upvar $OBJ_ATTR obj_attr

       set obj_attr(0) $group_member::($this,label)
       set obj_attr(1) $group_member::($this,widget_type)
       set obj_attr(2) $group_member::($this,data_type)
       set obj_attr(3) $group_member::($this,mom_var)
       set obj_attr(4) $group_member::($this,callback)
       set obj_attr(5) $group_member::($this,opt_list)
    }

    proc DefaultValue {this OBJ_ATTR} {
       upvar $OBJ_ATTR obj_attr
       
       set def_value [array get obj_attr]
       set group_member::($this,def_value) $def_value
    }

   proc RestoreValue {this} {
       group_member::readvalue $this obj_attr
       set group_member::($this,rest_value) [array get obj_attr]
   }
}

class ListingFile {

     proc ListingFile {this} {

        set def_values {1 listfile.lpt 1 1 1 0 0 1 0 0 40 \
                        30 0 0 0 0 0 0 0}
        set arr_names {listfile fname x y z 4axis 5axis feed \
                      speed head lines column oper tool start_path \
                      tool_chng end_path oper_time setup_time}
        set ind 0
        foreach name $arr_names\
        {
           set ListingFile::($this,$name) [lindex $def_values $ind]
           incr ind
        }
        set ListingFile::($this,arr_names) $arr_names
     }
    
     proc ~ListingFile {this} {}
     
     proc setvalue_from_pui {this OBJ_ATTR} {
       upvar $OBJ_ATTR obj_attr

       set arr_names [array names obj_attr]
       foreach name $arr_names\
       {
          set ListingFile::($this,$name) $obj_attr($name)
       }
     }
     
     proc readvalue {this OBJ_ATTR} {
        upvar $OBJ_ATTR obj_attr

        set arr_names $ListingFile::($this,arr_names)
        foreach name $arr_names\
        {
           set obj_attr($name) $ListingFile::($this,$name)
        }
     }

     #Setting the address objects list as listing file attribute
     proc SetLfileAddObjList {post_obj LF_ADD_OBJ_LIST} {
        upvar $LF_ADD_OBJ_LIST lf_add_obj_list
        
        set lfile_obj $Post::($post_obj,list_obj_list)
        set ListingFile::($lfile_obj,add_obj_list) $lf_add_obj_list
     }

     # Sets the listing block
     proc SetLfileBlockObj { lfile_obj LF_BLK_OBJ } {
        upvar $LF_BLK_OBJ lf_blk_obj
   
        set ListingFile::($lfile_obj,block_obj) $lf_blk_obj
     }

     proc DefaultValue {this OBJ_ATTR} {
        upvar $OBJ_ATTR obj_attr
     
        set def_value [array get obj_attr]
        set ListingFile::($this,def_value) $def_value
        set ListingFile::($this,restore_value) $def_value
     }

     proc RestoreValue {this OBJ_ATTR} {
        upvar $OBJ_ATTR obj_attr
     
        set restore_value [array get obj_attr]
        set ListingFile::($this,restore_value) $restore_value
     }
}    

class MachineToolElement {

    proc MachineToolElement {this} {}

    proc ~MachineToolElement {this} {}

    proc GeneralParameters {this OBJ_ATTR} {
       upvar $OBJ_ATTR obj_attr
     
       set arr_names [array names obj_attr]
       foreach name $arr_names\
       {
          set MachineToolElement::($this,$name) $obj_attr($name)
       }
    }

    proc 4AxisParameters {this OBJ_ATTR} {
       upvar $OBJ_ATTR obj_attr
       set arr_names [array names obj_attr]
       foreach name $arr_names\
       {
          set MachineToolElement::($this,$name\_4) $obj_attr($name)
       }
    }

    proc 5AxisParameters {this OBJ_ATTR} {
       upvar $OBJ_ATTR obj_attr
       set arr_names [array names obj_attr]
       foreach name $arr_names\
       {
          set MachineToolElement::($this,$name\_5) $obj_attr($name)
       }
    }

    proc DefaultValue {this OBJ_ATTR IDENTIFIER} {
       upvar $OBJ_ATTR obj_attr
       upvar $IDENTIFIER identifier
    
       switch $identifier\
       {
           3-Axis             {
                                 set def_value [array get obj_attr]
                                 set MachineToolElement::($this,3axis_def_value) \
                                                         $def_value
                              }
           4-Axis             {
                                 set def_value [array get obj_attr]
                                 set MachineToolElement::($this,4axis_def_value) \
                                                         $def_value
                              }
           5-Axis             {
                                 set def_value [array get obj_attr]
                                 set MachineToolElement::($this,5axis_def_value) \
                                                         $def_value
                              }
       }
    }
}   

class param {
  
   proc param {this} {
       set param::($this,param_name) "DEFAULT"
   }

   proc ~param {this} {}

   proc CreateObject {TYPE} {
     upvar $TYPE type
     
     switch $type\
     {
        i   {
              set object [new integer]
            }
        d   {
              set object [new double]
            }
        o   {
              set object [new option]
            }
        b   {
              set object [new boolean]
            }
        s   {
              set object [new string]
            }
        p   {
              set object [new point]
            }
     }
     
     return $object
   }

   proc ObjectSetValue {this OBJ_ATTR} {
      upvar $OBJ_ATTR obj_attr

      set ClassName [string trim [classof $this] ::]
      switch $ClassName\
      {
         param::integer  {
                           param::integer::setvalue $this obj_attr
                         }
         param::double   {
                           param::double::setvalue $this obj_attr
                         }
         param::option   {
                           param::option::setvalue $this obj_attr
                         }
         param::boolean {
                           param::boolean::setvalue $this obj_attr
                         }
         param::string   {
                           param::string::setvalue $this obj_attr
                         }
         param::point    {
                           param::point::setvalue $this obj_attr
                         }
      }
   }

   class integer {
     proc integer {this} {
        set param::integer::($this,name) "INTEGER"
     }
     proc ~integer {this} {}

     proc setvalue {this OBJ_ATTR} {
        upvar $OBJ_ATTR obj_attr

        set param::integer::($this,name)      $obj_attr(0)
        set param::integer::($this,type)      $obj_attr(1)
        set param::integer::($this,def_value) $obj_attr(2)
        set param::integer::($this,toggle)    $obj_attr(3)
        set param::integer::($this,ui_label)  $obj_attr(4)
     }
   }

    class double {
       proc double {this} {
          set param::double::($this,name) "DOUBLE"
       }

       proc ~double  {this} {}

       proc setvalue {this OBJ_ATTR} {
         upvar $OBJ_ATTR obj_attr

         set param::double::($this,name)      $obj_attr(0)
         set param::double::($this,type)      $obj_attr(1)
         set param::double::($this,def_value) $obj_attr(2)
         set param::double::($this,toggle)    $obj_attr(3)
         set param::double::($this,ui_label)  $obj_attr(4)
       }
    }

    class option {
       proc option {this} {
          set param::option::($this,name) "OPTION"
       }

       proc ~option  {this} {}

       proc setvalue {this OBJ_ATTR} {
         upvar $OBJ_ATTR obj_attr

         set param::option::($this,name)      $obj_attr(0)
         set param::option::($this,type)      $obj_attr(1)
         set param::option::($this,def_value) $obj_attr(2)
         set param::option::($this,options)   $obj_attr(3)
         set param::option::($this,ui_label)  $obj_attr(4)
       }
    }

    class boolean {
       proc boolean {this} {
          set param::boolean::($this,name) "BOOLEAN"
       }

       proc ~boolean  {this} {}

       proc setvalue {this OBJ_ATTR} {
         upvar $OBJ_ATTR obj_attr

         set param::boolean::($this,name)      $obj_attr(0)
         set param::boolean::($this,type)      $obj_attr(1)
         set param::boolean::($this,def_value) $obj_attr(2)
         set param::boolean::($this,ui_label)  $obj_attr(3)
       }
    }

    class string {
       proc string {this} {
          set param::string::($this,name) "STRING"
       }

       proc ~string  {this} {}

       proc setvalue {this OBJ_ATTR} {
         upvar $OBJ_ATTR obj_attr

         set param::string::($this,name)      $obj_attr(0)
         set param::string::($this,type)      $obj_attr(1)
         set param::string::($this,toggle)    $obj_attr(2)
         set param::string::($this,ui_label)  $obj_attr(3)
       }
    }

    class point {
       proc point {this} {
          set param::point::($this,name) "STRING"
       }

       proc ~point  {this} {}

       proc setvalue {this OBJ_ATTR} {
         upvar $OBJ_ATTR obj_attr

         set param::point::($this,name)      $obj_attr(0)
         set param::point::($this,type)      $obj_attr(1)
         set param::point::($this,ui_label)  $obj_attr(2)
       }
    }
}

class ude_event {
  proc ude_event {this} {
     set ude_event::($this,name) "DEFAULT"
  }  

  proc ~ude_event  {this} {}

  proc setvalue {this OBJ_ATTR} {
    upvar $OBJ_ATTR obj_attr

    set ude_event::($this,name)           $obj_attr(0)
    set ude_event::($this,post_event)     $obj_attr(1)
    set ude_event::($this,ui_label)       $obj_attr(2)
    set ude_event::($this,category)       $obj_attr(3)
    set ude_event::($this,param_obj_list) $obj_attr(4)
  }
}

class ude {
  proc ude {this} {
     set ude::($this,name) "DEFAULT"
  }  

  proc ~ude {this} {}

  proc setvalue {this OBJ_ATTR} {
    upvar $OBJ_ATTR obj_attr

    set ude::($this,name)           $obj_attr(0)
    set ude::($this,event_obj_list) $obj_attr(1)
  }
}

class File {

    proc File {this FPointer} {
      set File::($this,FilePointer) $FPointer
    }

    proc ~File {this} {}

    proc OpenFileRead {this FName} {
      set File::($this,FileName) $FName
      set FPointer $File::($this,FilePointer)
      
         if [catch {open $FName r} $FPointer]\
         {
           puts stdout "Can't Open File $FName for Reading"
           exit
         }
      set evalvar "set evelinvar $$FPointer"
      set FpointerAddress [eval $evalvar]
      set File::($this,FilePointer) $FpointerAddress
    }
    
    proc OpenFileWrite {this FName} {
      set File::($this,FileName) $FName
      set FPointer $File::($this,FilePointer)
      
         if [catch {open $FName w} $FPointer]\
         {
           puts stdout "Can't Open File $FName for Reading"
           exit
         }
      set evalvar "set evelinvar $$FPointer"
      set FpointerAddress [eval $evalvar]
      set File::($this,FilePointer) $FpointerAddress
    }

    proc ResetFilePointer {this} {
      seek $File::($this,FilePointer) 0
    }

    proc CloseFile {this} {
       close $File::($this,FilePointer)
    }
}
      
class ParseFile {

     proc ParseFile {this FPointer} File {$FPointer} {}
     proc ~ParseFile {this} {}

     proc ParseDefFile {this file_name} {

        PB_mthd_DefFileInitParse $this $file_name
     }

     proc ParseWordSep {this} {

        PB_mach_GetWordSep $this
     }

     proc ParseEndOfLine {this} {

        PB_mach_GetEndOfLine $this
     }

     proc ParseSequence {this} {
 
        PB_mach_GetSequenceParams $this
     }

     proc ParseFormat {this OBJ_LIST} {
        upvar $OBJ_LIST obj_list

        PB_fmt_FmtInitParse $this obj_list
     }

     proc ParseAddress {this OBJ_LIST LF_OBJ_LIST FOBJ_LIST} {
        upvar $OBJ_LIST obj_list
        upvar $FOBJ_LIST fobj_list
        upvar $LF_OBJ_LIST lf_obj_list

        PB_adr_AdrInitParse $this obj_list fobj_list
        PB_adr_SepBlkAndLFileAddLists obj_list lf_obj_list
        PB_adr_CreateTextAddObj obj_list fobj_list
     }
     
     proc ParseBlockTemp {this OBJ_LIST ADDOBJ_LIST POST_OBJ} {
        upvar $OBJ_LIST obj_list
        upvar $ADDOBJ_LIST addobj_list
        upvar $POST_OBJ post_obj

        PB_blk_BlkInitParse $this obj_list addobj_list post_obj
     }

    proc ParsePuiFile {this POST_OBJ} {
       upvar $POST_OBJ post_obj
       PB_pui_ReadPuiCreateObjs this post_obj
    }

    proc ParseUdeFile {this POST_OBJ} {
       upvar $POST_OBJ post_obj
       PB_ude_UdeInitParse $this post_obj
    }
}

