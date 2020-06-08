#=============================================================================
#                      UI_PB_PREVIEW.TCL
#=============================================================================
##############################################################################
# Description                                                                #
#     This file contains all functions dealing with the creation of          #
#     ui elements for Preview page..                                         #
#                                                                            #
# Revisions                                                                  #
#                                                                            #
#   Date        Who       Reason                                             #
# 01-feb-1999   gsl       Initial                                            #
# 30-May-1999   mnb       Added preview procedures                           #
# 02-Jun-1999   mnb       Code Integration                                   #
# 07-jun-1999   mnb       Displays the old and new event procedures          #
# 14-Jun-1999   mnb       Added procedures to output worseperator endofline  #
#                         and sequence number                                #
# 29-Jun-1999   mnb       Added Composite Blocks                             #
# 07-Sep-1999   mnb       Format is changed from % to & format               #
# 17-Nov-1999   gsl       Submitted for phase-22.                            #
#                                                                            #
# $HISTORY$                                                                  #
#                                                                            #
##############################################################################

#============================================================================
proc UI_PB_Preview { book_id pre_page_obj } {
#============================================================================
  global paOption

  set f [$book_id subwidget $Page::($pre_page_obj,page_name)]
  set w [tixNoteBook $f.nb -ipadx 5 -ipady 5]
  [$f.nb subwidget nbframe] config -tabpady 0

  set prev_book [new Book w]
  set Page::($pre_page_obj,book_obj) $prev_book

  Book::CreatePage $prev_book eve "Event Handlers" "" UI_PB_prv_EventHandler \
                                   UI_PB_prv_EventTab
  Book::CreatePage $prev_book def "Definitions" "" UI_PB_prv_Definition \
                                   UI_PB_prv_DefTab
                          
  pack $f.nb -expand yes -fill both
  set Book::($prev_book,x_def_tab_img) 0
  set Book::($prev_book,current_tab) -1
}

#=============================================================
proc UI_PB_prv_EventHandler { book_id eve_page_obj } {
#=============================================================
  global tixOption
  global paOption

  set Page::($eve_page_obj,page_id) [$book_id subwidget \
                            $Page::($eve_page_obj,page_name)]

  # Creates the pane for event preview page
    Page::CreatePane $eve_page_obj

  # Creates the tree
    Page::CreateCheckList $eve_page_obj
    UI_PB_prv_CreateEveListElements eve_page_obj

  # Right pane: the Text
    UI_PB_prv_CreateSecPaneElems eve_page_obj 

  # Parses the Event Handler
    PB_pps_ParseTclFile event_proc_data
    set Page::($eve_page_obj,evt_proc_list) [array get event_proc_data]
}

#======================================================================
proc UI_PB_prv_CreateSecPaneElems { PAGE_OBJ } {
#======================================================================
  upvar $PAGE_OBJ page_obj
  global paOption
  global tixOption
  set sec_pane $Page::($page_obj,canvas_frame)

  set pane [tixPanedWindow $sec_pane.pane -orient vertical]
  pack $pane -fill both -expand yes

  set f1 [$pane add p1 -expand 1 -size 200]
  set f2 [$pane add p2 -expand 1 -size 200]

  $f1 config -relief flat
  $f2 config -relief flat

  # First pane
   set p1s [$pane subwidget p1]
   set p1_frame [frame $p1s.frm -relief sunken -bd 1]
   pack $p1_frame -padx 2 -pady 6 -fill both -expand yes

   set lla [label $p1_frame.la -text "New Code" -bg darkSeaGreen3 \
                           -fg lightYellow -bd 2 -relief raised -anchor c]
   pack $lla -side top -fill x

   set lsw [tixScrolledWindow $p1_frame.lsw -scrollbar auto]
   [$lsw subwidget hsb] config -troughcolor $paOption(trough_bg) \
                               -width       $paOption(trough_wd)
   [$lsw subwidget vsb] config -troughcolor $paOption(trough_bg) \
                               -width       $paOption(trough_wd)

   pack $lsw -side bottom -fill both -expand yes

   set lswf [$lsw subwidget window]

   set ltext [text $lswf.tx -bg yellow \
                            -font $tixOption(bold_font) \
                            -height 200 -wrap word -bd 0]
   pack $ltext -side top -fill both -expand yes

   set p2s [$pane subwidget p2]
   set p2_frame [frame $p2s.frm -relief sunken -bd 1]
   pack $p2_frame -padx 4 -pady 6 -expand yes -fill both

   set rla [label $p2_frame.la -text "Old Code" -bg darkSeaGreen3 \
                               -fg lightYellow -bd 2 -relief raised -anchor c]
   pack $rla -side top -fill x

   set rsw [tixScrolledWindow $p2_frame.rsw -scrollbar auto]
   [$rsw subwidget hsb] config -troughcolor $paOption(trough_bg) \
                               -width       $paOption(trough_wd)
   [$rsw subwidget vsb] config -troughcolor $paOption(trough_bg) \
                               -width       $paOption(trough_wd)
   pack $rsw -side bottom -fill both -expand yes

   set rswf [$rsw subwidget window]
   set rtext [text $rswf.tx -bg lightGoldenRod1 -fg blue \
                            -font $tixOption(bold_font) \
                            -height 200 -wrap word -bd 0]
   pack $rtext -side bottom -fill both -expand yes

  set Page::($page_obj,ltext) $ltext
  set Page::($page_obj,rtext) $rtext
}

#======================================================================
proc UI_PB_prv_CreateEveListElements { EVE_PAGE_OBJ } {
#======================================================================
 upvar $EVE_PAGE_OBJ eve_page_obj
 global paOption
 global tixOption
 global gPB


  set tree $Page::($eve_page_obj,tree)

  set h [$tree subwidget hlist]
  $h config -bg $paOption(tree_bg)

  set style  $gPB(font_style_bold)
  set style1 $gPB(font_style_normal)

  uplevel #0 set TRANSPARENT_GIF_COLOR [$h cget -bg]

  set file   $paOption(file)
  set folder $paOption(folder)
  set seq  [tix getimage pb_sequence]

  set t 0
  $h add 0 -itemtype imagetext -text "" -image $folder -state disabled

  PB_int_RetSequenceObjs seq_obj_list
  foreach seq_obj $seq_obj_list \
  {
     $h add 0.$t -itemtype imagetext -text $sequence::($seq_obj,seq_name) \
                                     -image $seq -style $style -state disabled
     set evt_indx 0
     foreach evt_obj $sequence::($seq_obj,evt_obj_list)\
     {
        set event_name $event::($evt_obj,event_name)
        if { [string compare $event_name "Inch / Metric Mode"] == 0 || \
             [string compare $event_name "Feedrates"] == 0 || \
             [string compare $event_name "Cycle Set"] == 0} \
        {
          incr evt_indx
          continue
        }
           
        $h add 0.$t.$evt_indx -itemtype imagetext -text $event_name -style $style1
        $tree setstatus 0.$t.$evt_indx on
        incr evt_indx
     }
     incr t
  }

  $tree configure -browsecmd "UI_PB_prv_TclTreeSelection $eve_page_obj"

  $h selection set 0.0
  $h anchor set 0.0

  $tree autosetmode
  $tree setmode 0 none
}

#===============================================================
proc UI_PB_prv_TclTreeSelection { page_obj args } {
#===============================================================
  set tree $Page::($page_obj,tree)
  set HLIST [$tree subwidget hlist]
  set ent [$HLIST info selection]
  set index [string range $ent 2 [string length $ent]]

  if {[string compare $index ""] == 0} \
  {
     $HLIST selection clear
     $HLIST anchor clear
     $HLIST selection set 0.0
     $HLIST anchor set 0.0
     set index 0
  }
  
  set dot_indx [string first . $index]
  if {$dot_indx != -1} \
  {
     set first_indx [string range $index 0 [expr $dot_indx -1]]
     set sec_indx [string range $index [expr $dot_indx + 1] end]
  } else \
  {
     $HLIST selection clear
     $HLIST anchor clear
     $HLIST selection set 0.$index.0
     $HLIST anchor set 0.$index.0
     set first_indx $index
     set sec_indx 0
  } 
  UI_PB_prv_DisplayTclCode first_indx sec_indx page_obj
}

#===============================================================
proc UI_PB_prv_DisplayTclCode { FIRST_INDX SEC_INDX PAGE_OBJ } {
#===============================================================
  upvar $FIRST_INDX first_indx
  upvar $SEC_INDX sec_indx
  upvar $PAGE_OBJ page_obj

  PB_int_RetSequenceObjs seq_obj_list
  set evt_blks ""
  switch $first_indx \
  {
      0  -
      3  -
      4  -
      5  -
      6  {
            set seq_obj [lindex $seq_obj_list $first_indx]
            set event_obj [lindex $sequence::($seq_obj,evt_obj_list) \
                                        $sec_indx]
            set temp_evt_blks ""
            UI_PB_prv_GetBlkNamesOFEvent event_obj temp_evt_blks
            lappend evt_blks $temp_evt_blks
         }

      1  {
            set seq_obj [lindex $seq_obj_list 1]
            set event_obj [lindex $sequence::($seq_obj,evt_obj_list) \
                                        $sec_indx]
            set temp_evt_blks ""
            UI_PB_prv_GetBlkNamesOFEvent event_obj temp_evt_blks
            lappend evt_blks $temp_evt_blks
    
            set sec_seq_obj [lindex $seq_obj_list 2]
            set seq_evt_obj_list $sequence::($sec_seq_obj,evt_obj_list)
            set evt_name $event::($event_obj,event_name)
            PB_com_RetObjFrmName evt_name seq_evt_obj_list next_event_obj
            if {$next_event_obj != 0} \
            {
               set temp_evt_blks ""
               UI_PB_prv_GetBlkNamesOFEvent next_event_obj temp_evt_blks
               lappend evt_blks $temp_evt_blks
            }
         }

      2  {
            set seq_obj [lindex $seq_obj_list 2]
            set event_obj [lindex $sequence::($seq_obj,evt_obj_list) \
                                        $sec_indx]
            set sec_seq_obj [lindex $seq_obj_list 1]
            set seq_evt_obj_list $sequence::($sec_seq_obj,evt_obj_list)
            set evt_name $event::($event_obj,event_name)
            PB_com_RetObjFrmName evt_name seq_evt_obj_list next_event_obj
            if {$next_event_obj != 0} \
            {
               set temp_evt_blks ""
               UI_PB_prv_GetBlkNamesOFEvent next_event_obj temp_evt_blks
               lappend evt_blks $temp_evt_blks
            }

            set temp_evt_blks ""
            UI_PB_prv_GetBlkNamesOFEvent event_obj temp_evt_blks
            lappend evt_blks $temp_evt_blks
         }
  }

  set temp_event_name $event::($event_obj,event_name)
  set temp_event_name [string tolower $temp_event_name]
  set temp_evt_name [join [split $temp_event_name " "] _ ]
  append event_name MOM_ $temp_evt_name
  unset temp_evt_name

  PB_output_GetEventProcData event_name evt_blks event_output

  if {$first_indx == 4} \
  {
     array set event_proc_data $Page::($page_obj,evt_proc_list)
     set name_list [array names event_proc_data]
     append temp_name $event_name _move
     if { [lsearch $name_list $temp_name] != -1} \
     {
       lappend temp_evt_list $event_name $temp_name
       set event_name $temp_evt_list
       unset temp_evt_list temp_name
     }
  }
  UI_PB_prv_DisplayEventProc page_obj event_output event_name
}

#=============================================================================
proc  UI_PB_prv_GetBlkNamesOFEvent { EVENT_OBJ EVT_BLKS } {
#=============================================================================
  upvar $EVENT_OBJ event_obj
  upvar $EVT_BLKS evt_blks

  foreach evt_elem_row $event::($event_obj,evt_elem_list) \
  {
     if { [llength $evt_elem_row] > 1} \
     {
        set first_elem_obj [lindex $evt_elem_row 0]
        lappend evt_blks $event_element::($first_elem_obj,evt_elem_name)
     } else \
     {
        foreach evt_elem_obj $evt_elem_row \
        {
           set block_obj $event_element::($evt_elem_obj,block_obj)
           lappend evt_blks $block::($block_obj,block_name)
        }
     }
  }
}

#=============================================================================
proc UI_PB_prv_DisplayEventProc { PAGE_OBJ EVENT_OUTPUT EVT_NAME_LIST } {
#=============================================================================
  upvar $PAGE_OBJ page_obj
  upvar $EVENT_OUTPUT event_output
  upvar $EVT_NAME_LIST evt_name_list

  set ltext $Page::($page_obj,ltext)
  set rtext $Page::($page_obj,rtext)

  $ltext delete 1.0 end

  foreach line $event_output \
  {
     $ltext insert end "    $line\n"
  }

  array set event_proc_data $Page::($page_obj,evt_proc_list)
  $rtext delete 1.0 end

  foreach event_name $evt_name_list \
  {
     set old_event_output $event_proc_data($event_name)
     $rtext insert end "\n\n"
     foreach line $old_event_output \
     {
         $rtext insert end "    $line\n"
     }
  }
}

#================================================================
proc UI_PB_prv_Definition { book_id def_page_obj } {
#================================================================
  global tixOption
  global paOption

  set Page::($def_page_obj,page_id) [$book_id subwidget \
                         $Page::($def_page_obj,page_name)]
 
  # Creates a pane
    Page::CreatePane $def_page_obj

  # Creates a tree in left pane
    Page::CreateCheckList $def_page_obj

  # Right pane: the Text
    UI_PB_prv_CreateSecPaneElems def_page_obj 
}

#=========================================================================
proc UI_PB_prv_CreateDefListElements { DEF_PAGE_OBJ INDEX } {
#=========================================================================
  upvar $DEF_PAGE_OBJ def_page_obj
  upvar $INDEX index
  global paOption
  global tixOption

  set tree $Page::($def_page_obj,tree)
  set h [$tree subwidget hlist]
  $h config -bg $paOption(tree_bg)

##  set style [tixDisplayStyle imagetext -refwindow $h
##           -bg $paOption(tree_bg) -padx 4 -font $tixOption(bold_font)]
  global gPB
  set style  $gPB(font_style_bold)
  set style1 $gPB(font_style_normal)

  uplevel #0 set TRANSPARENT_GIF_COLOR [$h cget -bg]

  set file   $paOption(file)
  set folder $paOption(folder)

  $h delete all
  $h add 0   -itemtype imagetext -text "" -image $folder -state disabled

  $tree setstatus 0 none
  $h add 0.0 -itemtype imagetext -text "WORD_SEPARATOR" -style $style1
  $h add 0.1 -itemtype imagetext -text "END_OF_BLOCK"   -style $style1
  $h add 0.2 -itemtype imagetext -text "SEQUENCE_NUM"   -style $style1

  $tree setstatus 0.0 on
  $tree setstatus 0.1 on
  $tree setstatus 0.2 on

  PB_int_RetFormatObjList fmt_obj_list
  set fmt_img [tix getimage pb_format]
  $h add 0.3 -itemtype imagetext -text "FORMAT" -image $fmt_img -style $style \
                                                -state disabled

  set t 0
  foreach fmt_obj $fmt_obj_list \
  {
    $h add 0.3.$t -itemtype imagetext -style $style1 \
                  -text $format::($fmt_obj,for_name)
    $tree setstatus 0.3.$t on
    incr t
  }

  PB_int_RetAddressObjList add_obj_list
  set add_img [tix getimage pb_address]
  $h add 0.4 -itemtype imagetext -text "ADDRESS" -image $add_img \
                                 -style $style -state disabled

  set t 0
  foreach add_obj $add_obj_list \
  {
    $h add 0.4.$t -itemtype imagetext \
                    -text $address::($add_obj,add_name) -style $style1
    $tree setstatus 0.4.$t on
    incr t
  }

  PB_int_RetBlkObjList blk_obj_list
  set blk_img [tix getimage pb_block_s]
  $h add 0.5 -itemtype imagetext -text "BLOCK" -image $blk_img \
                                 -style $style -state disabled
  set t 0
  foreach blk_obj $blk_obj_list \
  {
    $h add 0.5.$t -itemtype imagetext \
                    -text $block::($blk_obj,block_name) -style $style1
    $tree setstatus 0.5.$t on
    incr t
  }
  set Page::($def_page_obj,blk_obj_list) $blk_obj_list

  set comp_blk_list ""
  PB_output_GetCompositeBlks comp_blk_list
  foreach blk_obj $comp_blk_list \
  {
    $h add 0.5.$t -itemtype imagetext \
                    -text $block::($blk_obj,block_name) -style $style1
    $tree setstatus 0.5.$t on
    incr t
  }
  set Page::($def_page_obj,comp_blk_list) $comp_blk_list

  $tree configure -browsecmd "UI_PB_DefinitionTreeSelect $def_page_obj"
 
  $h selection set 0.$index
  $h anchor set 0.$index

  $tree autosetmode
  $tree setmode 0 none
}

#======================================================================
proc UI_PB_DefinitionTreeSelect { page_obj args } {
#======================================================================
  set tree $Page::($page_obj,tree)
  set HLIST [$tree subwidget hlist]
  set ent [$HLIST info selection]
  set index [string range $ent 2 [string length $ent]]

  if {[string compare $index ""] == 0} \
  {
     $HLIST selection clear
     $HLIST anchor clear
     $HLIST selection set 0.0
     $HLIST anchor set 0.0
     set index 0
  }
  
  set dot_indx [string first . $index]
  if {$dot_indx != -1} \
  {
     set first_indx [string range $index 0 [expr $dot_indx -1]]
     set sec_indx [string range $index [expr $dot_indx + 1] end]
  } elseif {$index == 0 || $index == 1 || $index == 2} \
  {
      set first_indx $index
      set sec_indx 0
  } elseif { $index == 3 || $index == 4 ||  $index == 5} \
  {
     $HLIST selection clear
     $HLIST anchor clear
     $HLIST selection set 0.$index.0
     $HLIST anchor set 0.$index.0
     set first_indx $index
     set sec_indx 0
  } 
  UI_PB_prv_DisplayDefCode first_indx sec_indx page_obj
}

#======================================================================
proc UI_PB_prv_DisplayDefCode { FIRST_INDX SEC_INDX PAGE_OBJ } {
#======================================================================
  upvar $FIRST_INDX first_indx
  upvar $SEC_INDX sec_indx
  upvar $PAGE_OBJ page_obj

  switch $first_indx \
  {
     0 {
          UI_PB_prv_WordSep page_obj
       }

     1 {
          UI_PB_prv_EndOfBlock page_obj
       }

     2 {
          UI_PB_prv_SeqNumber page_obj
       }

     3 {
          UI_PB_prv_Format page_obj sec_indx
       }

     4 {
          UI_PB_prv_Address page_obj sec_indx
       }

     5 {
          UI_PB_prv_BlockTemplate page_obj sec_indx
       }
  }
}

#======================================================================
proc UI_PB_prv_WordSep { PAGE_OBJ } {
#======================================================================
  upvar $PAGE_OBJ page_obj
  global mom_sys_arr

  set ltext $Page::($page_obj,ltext)
  set rtext $Page::($page_obj,rtext)

  # New code
    PB_output_GetWordSeperator $mom_sys_arr(Word_Seperator) new_word_sep
    UI_PB_prv_OutputWordSep ltext new_word_sep

  # Old code
    set mom_var_arr(0) "Word_Seperator"
    PB_int_RetDefMOMVarValues mom_var_arr mom_var_value
    PB_output_GetWordSeperator $mom_var_value(Word_Seperator) word_sep
    UI_PB_prv_OutputWordSep rtext word_sep
}

#======================================================================
proc UI_PB_prv_OutputWordSep { TEXT_WIDGET WORD_SEP } {
#======================================================================
  upvar $TEXT_WIDGET text_widget
  upvar $WORD_SEP word_sep

  $text_widget delete 1.0 end

  $text_widget insert end "\n"
  $text_widget insert end "\n"
  $text_widget insert end "\n"
  $text_widget insert end "\n"
  $text_widget insert end "         $word_sep"
}

#======================================================================
proc UI_PB_prv_EndOfBlock { PAGE_OBJ } {
#======================================================================
  upvar $PAGE_OBJ page_obj
  global mom_sys_arr

  set ltext $Page::($page_obj,ltext)
  set rtext $Page::($page_obj,rtext)

  # new code
    PB_output_GetEndOfLine $mom_sys_arr(End_of_Block) new_endof_line
    UI_PB_prv_OutputEndBlk ltext new_endof_line
  
  # Old code
    set mom_var_arr(0) "End_of_Block"
    PB_int_RetDefMOMVarValues mom_var_arr mom_var_value
    PB_output_GetEndOfLine $mom_var_value(End_of_Block) endof_line
    UI_PB_prv_OutputEndBlk rtext endof_line
}

#======================================================================
proc UI_PB_prv_OutputEndBlk { TEXT_WIDGET END_OF_LINE } {
#======================================================================
  upvar $TEXT_WIDGET text_widget
  upvar $END_OF_LINE end_of_line

  $text_widget delete 1.0 end

  $text_widget insert end "\n"
  $text_widget insert end "\n"
  $text_widget insert end "\n"
  $text_widget insert end "\n"
  $text_widget insert end "         $end_of_line"
}
#======================================================================
proc UI_PB_prv_SeqNumber { PAGE_OBJ } {
#======================================================================
  upvar $PAGE_OBJ page_obj
  global mom_sys_arr

  set ltext $Page::($page_obj,ltext)
  set rtext $Page::($page_obj,rtext)

  set seq_param(0) $mom_sys_arr(seqnum_block)
  set seq_param(1) $mom_sys_arr(seqnum_start)
  set seq_param(2) $mom_sys_arr(seqnum_incr)
  set seq_param(3) $mom_sys_arr(seqnum_freq)
  PB_output_GetSequenceNumber seq_param new_seq_num
  UI_PB_prv_OutputSeqNo ltext new_seq_num

  set mom_var_arr(0) "seqnum_block"
  set mom_var_arr(1) "seqnum_start"
  set mom_var_arr(2) "seqnum_incr"
  set mom_var_arr(3) "seqnum_freq"
  PB_int_RetDefMOMVarValues mom_var_arr mom_var_value
  set seq_param(0) $mom_var_value(seqnum_block)
  set seq_param(1) $mom_var_value(seqnum_start)
  set seq_param(2) $mom_var_value(seqnum_incr)
  set seq_param(3) $mom_var_value(seqnum_freq)
  PB_output_GetSequenceNumber seq_param seq_num
  UI_PB_prv_OutputSeqNo rtext seq_num
}

#======================================================================
proc UI_PB_prv_OutputSeqNo { TEXT_WIDGET SEQUENCE_NUM } {
#======================================================================
  upvar $TEXT_WIDGET text_widget
  upvar $SEQUENCE_NUM sequence_num

  $text_widget delete 1.0 end

  $text_widget insert end "\n"
  $text_widget insert end "\n"
  $text_widget insert end "\n"
  $text_widget insert end "\n"
  $text_widget insert end "         $sequence_num"
}
#======================================================================
proc UI_PB_prv_Format { PAGE_OBJ INDEX } {
#======================================================================
  upvar $PAGE_OBJ page_obj
  upvar $INDEX index

  set ltext $Page::($page_obj,ltext)
  set rtext $Page::($page_obj,rtext)
  PB_int_RetFormatObjList fmt_obj_list

  set fmt_obj [lindex $fmt_obj_list $index]

  # Outputs the new address code in left window
    format::readvalue $fmt_obj fmt_obj_attr
    PB_fmt_RetFmtFrmAttr fmt_obj_attr for_value
    UI_PB_prv_OutputFormat ltext fmt_obj_attr(0) for_value

  # Outputs the old address code in right window
    array set def_fmt_obj_attr $format::($fmt_obj,def_value)
    PB_fmt_RetFmtFrmAttr def_fmt_obj_attr def_for_value
    UI_PB_prv_OutputFormat rtext def_fmt_obj_attr(0) def_for_value
}

#======================================================================
proc UI_PB_prv_OutputFormat { TEXT_WIDGET FMT_NAME FMT_VALUE } {
#======================================================================
  upvar $TEXT_WIDGET text_widget
  upvar $FMT_NAME fmt_name
  upvar $FMT_VALUE fmt_value

  $text_widget delete 1.0 end

  $text_widget insert end "\n"
  $text_widget insert end "\n"
  $text_widget insert end "\n"
  $text_widget insert end "\n"

  $text_widget insert end "         FORMAT $fmt_name  $fmt_value"
}

#======================================================================
proc UI_PB_prv_Address { PAGE_OBJ INDEX } {
#======================================================================
  upvar $PAGE_OBJ page_obj
  upvar $INDEX index

  set ltext $Page::($page_obj,ltext)
  set rtext $Page::($page_obj,rtext)

  PB_int_RetAddressObjList add_obj_list
  set add_obj [lindex $add_obj_list $index]

  # Outputs the new address code in left window
    address::readvalue $add_obj add_obj_attr
    PB_adr_RetAddFrmAddAttr add_obj_attr add_val_list
    UI_PB_prv_OutputAddress ltext add_obj_attr(0) add_val_list

  # Outputs the old address code in right window
    array set def_add_obj_attr $address::($add_obj,def_value)
    PB_adr_RetAddFrmAddAttr def_add_obj_attr def_add_val_list
    UI_PB_prv_OutputAddress rtext def_add_obj_attr(0) def_add_val_list
}

#======================================================================
proc UI_PB_prv_OutputAddress { TEXT_WIDGET ADD_NAME ADD_VALUE } {
#======================================================================
  upvar $TEXT_WIDGET text_widget
  upvar $ADD_NAME add_name
  upvar $ADD_VALUE add_value

  $text_widget delete 1.0 end

  $text_widget insert end "\n"
  $text_widget insert end "\n"
  $text_widget insert end "\n"
  $text_widget insert end "\n"

  $text_widget insert end "        ADDRESS $add_name\n"
  $text_widget insert end "        \{\n"
  set ii [llength $add_value]
  for {set jj 0} {$jj < $ii} {incr jj} \
  {
      $text_widget insert end "              [lindex $add_value $jj]\n"
  }
  $text_widget insert end "        \}\n"
}

#======================================================================
proc UI_PB_prv_BlockTemplate { PAGE_OBJ INDEX} {
#======================================================================
  upvar $PAGE_OBJ page_obj
  upvar $INDEX index

  set ltext $Page::($page_obj,ltext)
  set rtext $Page::($page_obj,rtext)

  set blk_obj_list $Page::($page_obj,blk_obj_list)
  set comp_blk_list $Page::($page_obj,comp_blk_list)

  set no_of_actblks [llength $blk_obj_list]
  
  if {$index < $no_of_actblks} \
  {
     set block_obj [lindex $blk_obj_list $index]
  } else \
  {
     set block_obj [lindex $comp_blk_list [expr $index - $no_of_actblks]]
  }

  # Outputs the new code in left window
    block::readvalue $block_obj blk_obj_attr
    PB_blk_RetBlkFrmBlkAttr blk_obj_attr blk_value
    UI_PB_prv_OutputBlockTemplate ltext blk_obj_attr(0) blk_value 

  # Outputs the old code in right window
    array set def_blk_obj_attr $block::($block_obj,def_value)
    PB_blk_RetBlkFrmBlkAttr def_blk_obj_attr def_blk_value
    UI_PB_prv_OutputBlockTemplate rtext def_blk_obj_attr(0) def_blk_value 
}

#===========================================================================
proc UI_PB_prv_OutputBlockTemplate { TEXT_WIDGET BLOCK_NAME BLK_VALUE } {
#===========================================================================
  upvar $TEXT_WIDGET text_widget
  upvar $BLOCK_NAME block_name
  upvar $BLK_VALUE blk_value

  $text_widget delete 1.0 end

  $text_widget insert end  "\n"
  $text_widget insert end  "\n"
  $text_widget insert end  "\n"
  $text_widget insert end  "         BLOCK_TEMPLATE $block_name\n"
  $text_widget insert end  "         \{\n"

  set line_no 6
  set ii [llength $blk_value]
  for {set jj 0} {$jj < $ii} {incr jj} \
  {
     $text_widget insert end "              [lindex $blk_value $jj]\n"
     incr line_no
  }
  $text_widget insert end "         \}\n"
}

#===========================================================================
proc UI_PB_prv_CreateTabAttr { BOOK_OBJ } {
#===========================================================================
  upvar $BOOK_OBJ book_obj

  switch -exact -- $Book::($book_obj,current_tab) \
  {
     0 {
         set page_obj [lindex $Book::($book_obj,page_obj_list) 0]
         UI_PB_prv_TclTreeSelection $page_obj
       }

     1 {
         set page_obj [lindex $Book::($book_obj,page_obj_list) 1]
         set tree $Page::($page_obj,tree)
         set HLIST [$tree subwidget hlist]

         set ent [$HLIST info selection]
         set index [string range $ent 2 [string length $ent]]

         if {[string compare $index ""] == 0} \
         {
           set index 0
         }

         UI_PB_prv_CreateDefListElements page_obj index
         UI_PB_DefinitionTreeSelect $page_obj
       }
  }
}

#===========================================================================
proc UI_PB_prv_EventTab { book_id page_img book_obj } {
#===========================================================================
  CB_nb_def $book_id $page_img $book_obj
  set Book::($book_obj,current_tab) 0

  UI_PB_prv_CreateTabAttr book_obj
}

#===========================================================================
proc UI_PB_prv_DefTab { book_id page_img book_obj } {
#===========================================================================
  CB_nb_def $book_id $page_img $book_obj
  set Book::($book_obj,current_tab) 1

  UI_PB_prv_CreateTabAttr book_obj
}