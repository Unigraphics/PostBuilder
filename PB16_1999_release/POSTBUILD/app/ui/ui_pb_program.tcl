#===============================================================================
#                 UI_PB_PROGRAM.TCL
#===============================================================================
##############################################################################
# Description                                                                #
#     This file contains all functions dealing with the creation of          #
#     ui elements for Program page..                                         #
#                                                                            #
# Revisions                                                                  #
#                                                                            #
#   Date        Who       Reason                                             #
# 01-feb-1999   mnb       Initial                                            #
# 02-Jun-1999   mnb       Code Integration                                   #
# 23-Jun-1999   gsl       Added envent_list attribute to Sequence apge       #
#                         to keep track of opened Event windows.             #
# 29-Jun-1999   mnb       Removed User Defined events from tree              #
# 07-Sep-1999   mnb       Changed the top canvas menu to combobox & added    #
#                         popup menu to edit blocks                          #  
# 21-Sep-1999   mnb       Changed Menu in Sequence page to Combo Box         #
# 18-Oct-1999   gsl       Minor changes                                      #
# 22-Oct-1999   gsl       Removed grayed-out popup menu.                     #
# 03-Nov-1999   gsl       Added UI_PB_prog_DisableWindow &                   #
#                               UI_PB_prog_EnableWindow.                     #
# 17-Nov-1999   gsl       Submitted for phase-22.                            #
#                                                                            #
# $HISTORY$                                                                  #
#                                                                            #
##############################################################################


#=====================================================================
proc UI_PB_prog_DisableWindow { CHAP } {
#=====================================================================
 upvar  $CHAP chap
 global gPB

   
   #**********
   # Sections
   #**********
    set sect    $Page::($chap,book_obj)
    set sect_id $Book::($sect,book_id)

   #*******************************************************************
   # Save away the Button-1 callback and attach a message dialog to it.
   #*******************************************************************
    set gPB($sect_id,b1_cb) [bind [$sect_id subwidget nbframe] <1>]

    bind [$sect_id subwidget nbframe] <1> \
         "tk_messageBox -parent [UI_PB_com_AskActiveWindow] -type ok -icon error\
          -message \"You have to close all sub-windows to enable this tab.\""

   # Disable notebook tabs
    $sect_id pageconfig prog -state disabled
    $sect_id pageconfig gcod -state disabled
    $sect_id pageconfig mcod -state disabled
    $sect_id pageconfig asum -state disabled
    $sect_id pageconfig wseq -state disabled

   #****************************************************
   # Retrieve some font styles for disabling tree items
   #****************************************************
    set sty_n  $gPB(font_style_normal)
    set sty_b  $gPB(font_style_bold)
    set sty_ng $gPB(font_style_normal_gray)
    set sty_bg $gPB(font_style_bold_gray)

   #***********************
   # Get tabbed pages info
   #***********************
    set page_tab $Book::($sect,current_tab)
    set page_obj [lindex $Book::($sect,page_obj_list) $page_tab]

   # Disable tree items on Program tab
    set page_tab $Book::($sect,current_tab)

    if { $page_tab == 0 } \
    {
      set t $Page::($page_obj,tree)
      set h [$t subwidget hlist]

     # Disable everything first, then enable branches selectively.
      $h entryconfig 0.0   -state disabled -style $sty_bg
      $h entryconfig 0.1   -state disabled -style $sty_bg
      $h entryconfig 0.2   -state disabled -style $sty_bg
      $h entryconfig 0.2.0 -state disabled -style $sty_ng
      $h entryconfig 0.2.1 -state disabled -style $sty_ng
      $h entryconfig 0.2.2 -state disabled -style $sty_ng
      $h entryconfig 0.3   -state disabled -style $sty_bg
      $h entryconfig 0.4   -state disabled -style $sty_bg

     # The 3rd char of the selected item...
      set anc [$h info anchor]
      set ind [string index $anc 2]

      if { [string compare $ind "2"] == 0 } \
      {
       # Event items
        $h entryconfig $anc -state normal -style $sty_n

      } else \
      {
       # Sequence items
        $h entryconfig $anc -state normal -style $sty_b
      }

     # Disable items on canvas frame
      set f $Page::($page_obj,canvas_frame)
    }
}

#=====================================================================
proc UI_PB_prog_EnableWindow { CHAP } {
#=====================================================================
 upvar  $CHAP chap
 global gPB

   #**********
   # Sections
   #**********
    set sect    $Page::($chap,book_obj)
    set sect_id $Book::($sect,book_id)

   #*******************************************
   # Restore Button-1 callback for the chapter
   #*******************************************
    bind [$sect_id subwidget nbframe] <1> $gPB($sect_id,b1_cb)

   #*************
   # Enable tabs
   #*************
    $sect_id pageconfig prog -state normal
    $sect_id pageconfig gcod -state normal
    $sect_id pageconfig mcod -state normal
    $sect_id pageconfig asum -state normal
    $sect_id pageconfig wseq -state normal

   #***************************************************
   # Retrieve some font styles for enabling tree items
   #***************************************************
    set sty_n  $gPB(font_style_normal)
    set sty_b  $gPB(font_style_bold)

    if { $Book::($sect,current_tab) == 0 } \
    {
      set page_obj [lindex $Book::($sect,page_obj_list) 0]

      set t $Page::($page_obj,tree)
      set h [$t subwidget hlist]

      $h entryconfig 0.0   -state normal -style $sty_b
      $h entryconfig 0.1   -state normal -style $sty_b
      $h entryconfig 0.2   -state normal -style $sty_b
      $h entryconfig 0.2.0 -state normal -style $sty_n
      $h entryconfig 0.2.1 -state normal -style $sty_n
      $h entryconfig 0.2.2 -state normal -style $sty_n
      $h entryconfig 0.3   -state normal -style $sty_b
      $h entryconfig 0.4   -state normal -style $sty_b
    }
}

#=====================================================================
proc UI_PB_ProgTpth_Program {book_id prog_page} {
#=====================================================================
   global paOption
   global tixOption
   global mom_sys_arr

   set Page::($prog_page,page_id) [$book_id subwidget \
                                   $Page::($prog_page,page_name)]
   set top_canvas_dim(0) 80
   set top_canvas_dim(1) 400
   set bot_canvas_dim(0) 2000
   set bot_canvas_dim(1) 2000
   set index 0

  # Returns the database sequence objects
    PB_int_RetSequenceObjs seq_obj_list 

  # Set the sequence objects to sequence page
    set Page::($prog_page,seq_obj_list) $seq_obj_list

  # Initialize event list
    set Page::($prog_page,event_list) {}

   Page::CreatePane $prog_page
   Page::CreateTree $prog_page
   UI_PB_evt_CreateTree prog_page

   set canvas_frm $Page::($prog_page,canvas_frame)

   # Creates NC Code output toggle button
     set nc_frm [frame $canvas_frm.nc -bg navyBlue]
     pack $nc_frm -side top -fill x
    
     checkbutton $nc_frm.bnc -text "Display Blocks in N/C Code" \
        -relief ridge -bd 1 -font $tixOption(bold_font) \
        -variable mom_sys_arr(seq_blk_nc_code) -anchor c \
        -command "UI_PB_evt_ChangeSeqDisplay $prog_page"
     pack $nc_frm.bnc -pady 6

   set Page::($prog_page,disp_nc_frm) $nc_frm
   set Page::($prog_page,disp_nc_flag) 0
   Page::CreateCanvas $prog_page top_canvas_dim bot_canvas_dim

   # Template Button
     $Page::($prog_page,box) config -relief sunken \
                   -bg gray 
     $Page::($prog_page,box) add seqtmp -width 30 \
                 -text "Select A Sequence Template" \
                 -bg $paOption(app_butt_bg)
     set Page::($prog_page,box_flag) 0
     set Page::($prog_page,hor_scrol_flag) 0

   # Creates Apply & Default buttons
     set canvas_frame $Page::($prog_page,canvas_frame)
     set act_box [tixButtonBox $canvas_frame.appbut \
                   -orientation horizontal \
                   -bd 2 \
                   -relief sunken]
     $act_box config -bg $paOption(butt_bg)
     pack $act_box -side bottom -fill x -padx 3 -pady 3

     $act_box add def -text "Default" -width 10 \
                    -command "UI_PB_evt_DefaultCallBack $prog_page"
     $act_box add und -text "Restore" -width 10 \
                    -command "UI_PB_evt_RestoreCallBack $prog_page"

   set Page::($prog_page,act_box) $act_box
   set Page::($prog_page,act_box_flag) 0
   set Page::($prog_page,add_name) " Add Block "
   Page::CreateAddTrashinCanvas $prog_page 
   UI_PB_evt_CreateComboBox $prog_page

   # Attaches the bind procedures to the Add icon
     UI_PB_evt_AddBindProcs prog_page

   Page::AddComponents $prog_page
   UI_PB_evt_SetASequenceAttr $prog_page 0
   
   # Creates canvas popup menu
     UI_PB_evt_CreatePopupMenu $prog_page
}

#==========================================================================
# This procedure creates the comboBox widget.
#==========================================================================
proc UI_PB_evt_CreateComboBox { page_obj } {
#==========================================================================
  # Gets the top canvas id from the page object
    set top_canvas $Page::($page_obj,top_canvas)

  # Creates a frame on top canvas to put the entry and
  # menu button
    set evt_frm [frame $top_canvas.f]
    $top_canvas create window 350 40 -window $evt_frm

  # Creates combobox
    set blk_sel [tixComboBox $evt_frm.blk_sel \
                -dropdown   yes \
                -editable   false \
                -variable   CB_Block_Name \
                -command    "" \
                -grab       local \
                -listwidth  335 \
                -options {
                   listbox.height   10
                   listbox.anchor   c
                   entry.width      38
                }]

    pack $evt_frm.blk_sel -side right
    set Page::($page_obj,comb_widget) $blk_sel
    [$blk_sel subwidget entry] config -bg lightBlue -justify center -cursor ""
}

#==========================================================================
# This procedure creates the popup menu for all the sequences
#==========================================================================
proc UI_PB_evt_CreatePopupMenu { page_obj } {
#==========================================================================
  global tixOption
  global paOption

  set bot_canvas $Page::($page_obj,bot_canvas)
  option add *Menu.tearOff   0

  set popup [menu $bot_canvas.pop]
  set Page::($page_obj,popup) $popup
  set Page::($page_obj,popup_flag) 0
  $popup add separator

  bind $bot_canvas <3> "UI_PB_evt_CanvasPopupMenu $page_obj %X %Y"
}

#=====================================================================
proc UI_PB_evt_CanvasPopupMenu { page_obj x y } {
#=====================================================================
  set popup $Page::($page_obj,popup)
  if { $Page::($page_obj,popup_flag) == 1} \
  {
    set Page::($page_obj,popup_flag) 0

   # Position popup menu
    tk_popup $popup $x $y
  }

}

#=====================================================================
proc UI_PB_evt_ChangeSeqDisplay { page_obj } {
#=====================================================================
  global mom_sys_arr

  set act_seq_obj $Page::($page_obj,active_seq)
  set bot_canvas $Page::($page_obj,bot_canvas)

  UI_PB_evt_DeleteSeqEvents page_obj act_seq_obj

  switch $Page::($page_obj,prev_seq) \
  {
      0  { set mom_sys_arr(\$pgss_blk_nc) $mom_sys_arr(seq_blk_nc_code) }
      1  { set mom_sys_arr(\$pges_blk_nc) $mom_sys_arr(seq_blk_nc_code) }
      3  { set mom_sys_arr(\$opss_blk_nc) $mom_sys_arr(seq_blk_nc_code) }
      4  { set mom_sys_arr(\$opes_blk_nc) $mom_sys_arr(seq_blk_nc_code) }
  }

  # Sets all the sequence attributes to the seq_obj
    UI_PB_evt_SetSequenceObjAttr act_seq_obj

  # Top Canvas
    UI_PB_evt_TopCanvasPackUnpack page_obj

  if { $Page::($page_obj,prev_seq) == 0 } \
  {
     # unpacks the template and horizontal scroller
       UI_PB_evt_PackActCanvasItems page_obj
  }

  if { $mom_sys_arr(seq_blk_nc_code) == 1 } \
  {
     bind $bot_canvas <3> ""
  } else \
  {
     bind $bot_canvas <3> "UI_PB_evt_CanvasPopupMenu $page_obj %X %Y"
  }

  UI_PB_evt_CreateSeqAttributes page_obj
}

#=====================================================================
proc UI_PB_evt_RestoreCallBack { page_obj } {
#=====================================================================
   set prev_seq $Page::($page_obj,prev_seq)
   set seq_obj [lindex $Page::($page_obj,seq_obj_list) $prev_seq]

  # Deletes the objects of previous sequence
    UI_PB_evt_DeleteObjectsPrevSeq page_obj
    UI_PB_evt_SetSequenceObjAttr seq_obj

  foreach event_obj $sequence::($seq_obj,evt_obj_list) \
  {
     array set evt_obj_attr $event::($event_obj,rest_value)
     event::setvalue $event_obj evt_obj_attr
     foreach row_evt_elem $event::($event_obj,evt_elem_list) \
     {
       foreach evt_elem $row_evt_elem \
       {
          array set evt_elem_obj_attr $event_element::($evt_elem,rest_value)
          event_element::setvalue $evt_elem evt_elem_obj_attr
       }
     }
  }
  UI_PB_evt_CreateSeqAttributes page_obj
}

#=====================================================================
proc UI_PB_evt_DefaultCallBack { page_obj } {
#=====================================================================
  set prev_seq $Page::($page_obj,prev_seq)
  set seq_obj [lindex $Page::($page_obj,seq_obj_list) $prev_seq]
  # Deletes the objects of previous sequence
    UI_PB_evt_DeleteObjectsPrevSeq page_obj
    UI_PB_evt_SetSequenceObjAttr seq_obj

  foreach event_obj $sequence::($seq_obj,evt_obj_list) \
  {
     array set evt_obj_attr $event::($event_obj,def_value)
     event::setvalue $event_obj evt_obj_attr
     foreach row_evt_elem $event::($event_obj,evt_elem_list) \
     {
       foreach evt_elem $row_evt_elem \
       {
          array set evt_elem_obj_attr $event_element::($evt_elem,def_value)
          event_element::setvalue $evt_elem evt_elem_obj_attr
       }
     }
  }
  UI_PB_evt_CreateSeqAttributes page_obj
}

#=====================================================================
proc UI_PB_evt_prog {PAGE_OBJ} {
#=====================================================================
  upvar $PAGE_OBJ page_obj
  
  set Page::($page_obj,glob_evnt_dim) {170 26}
  set Page::($page_obj,glob_blk_dim) {170 25}
  set Page::($page_obj,glob_blk_blkdist_hor) 20
  set Page::($page_obj,glob_blk_blkdist_ver) 25
  set Page::($page_obj,glob_evt_blkdist) 30
  set Page::($page_obj,glob_evt_evtdist) 30
  set Page::($page_obj,glob_text_shift) 10
  set Page::($page_obj,glob_rect_gap) 3
  set Page::($page_obj,prev_seq) -1
  set Page::($page_obj,cen_shift) 4
  set Page::($page_obj,topcanvas_flag) 0
  set Page::($page_obj,drag_sensitivity) 3

  set tree $Page::($page_obj,tree)
  set sec_frm $Page::($page_obj,canvas_frame)

}

#=====================================================================
proc UI_PB_evt_CreateTree {PAGE_OBJ} {
#=====================================================================
 upvar $PAGE_OBJ page_obj
 global paOption
 global tixOption
 global gPB

  set tree $Page::($page_obj,tree)
  set sec_frm $Page::($page_obj,canvas_frame)

  $tree config \
        -command "UI_PB_evt_progItemSelection $page_obj" \
        -browsecmd "UI_PB_evt_progItemSelection $page_obj"
 
  set h [$tree subwidget hlist]
  $h config -bg $paOption(tree_bg)

  uplevel #0 set TRANSPARENT_GIF_COLOR [$h cget -bg]

  set file   $paOption(file)
  set folder $paOption(folder)
  set seq    [tix getimage pb_sequence]
  set subseq [tix getimage pb_sub_seq]

  set style  $gPB(font_style_bold)
  set style1 $gPB(font_style_normal)

  $h add 0     -itemtype imagetext -text "" -image $folder -state disabled

  $h add 0.0   -itemtype imagetext -text "Program Start Sequence" \
                                   -image $seq    -style $style
  $h add 0.1   -itemtype imagetext -text "Operation Start Sequence" \
                                   -image $seq    -style $style
  $h add 0.2   -itemtype imagetext -text "Tool Path Events" \
                                   -image $seq    -style $style

  $h add 0.2.0 -itemtype imagetext -text "Machine Control" \
                                   -image $subseq -style $style1
  $h add 0.2.1 -itemtype imagetext -text "Motions" \
                                   -image $subseq -style $style1
  $h add 0.2.2 -itemtype imagetext -text "Cycles" \
                                   -image $subseq -style $style1

  $h add 0.3   -itemtype imagetext -text "Operation End Sequence" \
                                   -image $seq    -style $style
  $h add 0.4   -itemtype imagetext -text "Program End Sequence" \
                                   -image $seq    -style $style

  $h selection set 0.0
  $h anchor set 0.0
}

#==================================================================
proc UI_PB_evt_GetSequenceIndex { PAGE_OBJ SEQ_INDEX } {
#==================================================================
  upvar $PAGE_OBJ page_obj
  upvar $SEQ_INDEX seq_index

  switch $Page::($page_obj,prev_seq) \
  {
     0    { set seq_index 0 }
     1    { set seq_index 1 }
     2    { set seq_index 2 }
     2.1  { set seq_index 3 }
     2.2  { set seq_index 4 }
     3    { set seq_index 5 }
     4    { set seq_index 6 }
  }
}

#==================================================================
proc UI_PB_evt_DeleteObjectsPrevSeq { PAGE_OBJ } {
#==================================================================
  upvar $PAGE_OBJ page_obj

  # gets the previous sequence object
    UI_PB_evt_GetSequenceIndex page_obj prev_seq_index
    set prev_seq_obj [lindex $Page::($page_obj,seq_obj_list) \
                $prev_seq_index]

  # Deletes all the Events and blocks of the previous sequence
    UI_PB_evt_DeleteSeqEvents page_obj prev_seq_obj

  # Deletes the combobox entry text
    if {[info exists sequence::($prev_seq_obj,comb_text)]}\
    {
         $Page::($page_obj,top_canvas) delete \
                      $sequence::($prev_seq_obj,comb_text)
    }
}

#==================================================================
proc UI_PB_evt_PackActCanvasItems { PAGE_OBJ } {
#==================================================================
   upvar $PAGE_OBJ page_obj
   global mom_sys_arr

   # Unpacks the sequence template box
     if {$Page::($page_obj,box_flag) == 0} \
     {
         pack forget $Page::($page_obj,box)
         set Page::($page_obj,box_flag) 1
     }

   # Packs the Action canvas, if it is not packed
     if {$Page::($page_obj,action_flag) == 1 && \
         $mom_sys_arr(seq_blk_nc_code) == 0 } \
     {
         pack $Page::($page_obj,action_canvas) -side bottom \
                 -fill both -padx 3
         set Page::($page_obj,action_flag) 0
     } elseif { $Page::($page_obj,action_flag) == 0 && \
                $mom_sys_arr(seq_blk_nc_code) == 1 } \
     {
         pack forget $Page::($page_obj,action_canvas)
         set Page::($page_obj,action_flag) 1
     }

   # Unpacks the horizontal scroller bar
     if {$Page::($page_obj,hor_scrol_flag) == 0} \
     {
         pack forget $Page::($page_obj,hor_scrol)
         set Page::($page_obj,hor_scrol_flag) 1
     }
}

#==================================================================
proc UI_PB_evt_CreateSeqAttributes { PAGE_OBJ } {
#==================================================================
  upvar $PAGE_OBJ page_obj

  grab set $Page::($page_obj,canvas_frame)
  switch $Page::($page_obj,prev_seq) \
  {
      0  { 
            set seq_obj [lindex $Page::($page_obj,seq_obj_list) 0]
            UI_PB_evt_SeqComponents page_obj seq_obj
            set Page::($page_obj,active_seq) $seq_obj
         }

      1  { 
            set seq_obj [lindex $Page::($page_obj,seq_obj_list) 1]
            UI_PB_evt_SeqComponents page_obj seq_obj
            set Page::($page_obj,active_seq) $seq_obj
         }

      2  { 
            set seq_obj [lindex $Page::($page_obj,seq_obj_list) 2]
            UI_PB_evt_ToolPathSeqComponents page_obj seq_obj
            set Page::($page_obj,active_seq) $seq_obj
         }

     2.1 { 
            set seq_obj [lindex $Page::($page_obj,seq_obj_list) 3]
            UI_PB_evt_ToolPathSeqComponents page_obj seq_obj
            set Page::($page_obj,active_seq) $seq_obj

         }
 
     2.2 { 
            set seq_obj [lindex $Page::($page_obj,seq_obj_list) 4]
            UI_PB_evt_ToolPathSeqComponents page_obj seq_obj
            set Page::($page_obj,active_seq) $seq_obj
         }

      3  { 
            set seq_obj [lindex $Page::($page_obj,seq_obj_list) 5]
            UI_PB_evt_SeqComponents page_obj seq_obj
            set Page::($page_obj,active_seq) $seq_obj
         }
 
      4  { 
            set seq_obj [lindex $Page::($page_obj,seq_obj_list) 6]
            UI_PB_evt_SeqComponents page_obj seq_obj
            set Page::($page_obj,active_seq) $seq_obj
         }
  }
  grab release $Page::($page_obj,canvas_frame)
}

#==================================================================
proc UI_PB_evt_RestoreSeqObjData { SEQ_OBJ } {
#==================================================================
  upvar $SEQ_OBJ seq_obj

  # Restore the sequence data
    sequence::RestoreValue $seq_obj

  # Restores the sequence event data
    foreach event_obj $sequence::($seq_obj,evt_obj_list) \
    {
        event::RestoreValue $event_obj
        foreach row_evt_elem $event::($event_obj,evt_elem_list) \
        {
           foreach evt_elem $row_evt_elem \
           {
               event_element::RestoreValue $evt_elem
           }
        }
    }
}

#==================================================================
proc UI_PB_evt_TopCanvasPackUnpack { PAGE_OBJ } {
#==================================================================
  upvar $PAGE_OBJ page_obj
  global mom_sys_arr

  # Top Canvas
    if { $mom_sys_arr(seq_blk_nc_code) == 1 && \
         $Page::($page_obj,topcanvas_flag) == 0} \
    {
       pack forget $Page::($page_obj,top_canvas)
       set Page::($page_obj,topcanvas_flag) 1
    } elseif { $mom_sys_arr(seq_blk_nc_code) == 0 && \
               $Page::($page_obj,topcanvas_flag) == 1} \
    {
       pack forget $Page::($page_obj,bot_canvas)
       pack forget $Page::($page_obj,ver_scrol)
       pack $Page::($page_obj,top_canvas) -side top -fill x -padx 3
       set Page::($page_obj,topcanvas_flag) 0
       pack $Page::($page_obj,bot_canvas) -side left -expand yes \
                         -fill both -padx 3
       pack $Page::($page_obj,ver_scrol) -side right -fill y
    }
}

#==================================================================
proc UI_PB_evt_PackDispNcFrame { PAGE_OBJ } {
#==================================================================
  upvar $PAGE_OBJ page_obj

  # NC Code Display Code Frame
    if { $Page::($page_obj,disp_nc_flag) } \
    {
       pack forget $Page::($page_obj,canvas_frame).frame
       pack $Page::($page_obj,disp_nc_frm) -side top -fill x
       pack $Page::($page_obj,canvas_frame).frame \
                -side top -fill both -expand yes
       set Page::($page_obj,disp_nc_flag) 0
    }
}

#==================================================================
proc UI_PB_evt_UnpackDispNcFrame { PAGE_OBJ } {
#==================================================================
  upvar $PAGE_OBJ page_obj

  # NC Code Display Code Frame
    if { $Page::($page_obj,disp_nc_flag) == 0 } \
    {
       pack forget $Page::($page_obj,disp_nc_frm)
       set Page::($page_obj,disp_nc_flag) 1
    }
}

#==================================================================
proc UI_PB_evt_ProgStartSeq { PAGE_OBJ } {
#==================================================================
  upvar $PAGE_OBJ page_obj
  global mom_sys_arr

  if { $Page::($page_obj,prev_seq) == -1 } \
  {
     set seq_obj [lindex $Page::($page_obj,seq_obj_list) 0]

     # Sets all the sequence attributes to the seq_obj
       UI_PB_evt_SetSequenceObjAttr seq_obj
     set Page::($page_obj,prev_seq) 0

     # Creates the Action canvas blocks
       UI_PB_evt_CreateActionCanvas page_obj seq_obj
       set Page::($page_obj,action_flag) 0

     # unpacks the template and horizontal scroller
       UI_PB_evt_PackActCanvasItems page_obj

     # Top Canvas
       UI_PB_evt_TopCanvasPackUnpack page_obj

  } else \
  {
     # Deletes the objects of previous sequence
       UI_PB_evt_DeleteObjectsPrevSeq page_obj

     # Packs the NC Code frame
       UI_PB_evt_PackDispNcFrame page_obj

     if {$Page::($page_obj,act_box_flag) == 1}\
     {
        pack $Page::($page_obj,act_box) -side bottom -fill x \
                                  -padx 3 -pady 3
        set Page::($page_obj,act_box_flag) 0
     }
     set Page::($page_obj,prev_seq) 0

     # unpacks the template and horizontal scroller
       UI_PB_evt_PackActCanvasItems page_obj

     set seq_obj [lindex $Page::($page_obj,seq_obj_list) 0]

     # Sets all the sequence attributes to the seq_obj
       UI_PB_evt_SetSequenceObjAttr seq_obj
  
     # Top Canvas
       UI_PB_evt_TopCanvasPackUnpack page_obj
       $Page::($page_obj,bot_canvas) yview moveto 0
  }
}

#==================================================================
proc UI_PB_evt_OperStartSeq { PAGE_OBJ } {
#==================================================================
  upvar $PAGE_OBJ page_obj
  global mom_sys_arr

  # Deletes the objects of previous sequence
    UI_PB_evt_DeleteObjectsPrevSeq page_obj

  set seq_obj [lindex $Page::($page_obj,seq_obj_list) 1]
  # Sets all the sequence attributes to the seq_obj
    UI_PB_evt_SetSequenceObjAttr seq_obj

    set Page::($page_obj,prev_seq) 1

  # Unpacks the action canvas and packs the hor scroller
    UI_PB_evt_PackforgetBoxActCanvas page_obj
           
  # Packs the NC Code frame
    UI_PB_evt_PackDispNcFrame page_obj

  # Top Canvas
    UI_PB_evt_TopCanvasPackUnpack page_obj

  if {$Page::($page_obj,act_box_flag) == 1}\
  {
     pack $Page::($page_obj,act_box) -side bottom -fill x \
                             -padx 3 -pady 3
     set Page::($page_obj,act_box_flag) 0
  }

  # Packs the template sequence
    if {$Page::($page_obj,box_flag) == 1} \
    {
        pack $Page::($page_obj,box) -side bottom -fill x \
                      -padx 3 -pady 3
        set Page::($page_obj,box_flag) 0
    }
    $Page::($page_obj,bot_canvas) yview moveto 0
    $Page::($page_obj,bot_canvas) xview moveto 0
}

#==================================================================
proc UI_PB_evt_MachineControl { PAGE_OBJ } {
#==================================================================
  upvar $PAGE_OBJ page_obj

  # Deletes the objects of previous sequence
    UI_PB_evt_DeleteObjectsPrevSeq page_obj
    set seq_obj [lindex $Page::($page_obj,seq_obj_list) 2]

  # Sets all the sequence attributes to the seq_obj
    UI_PB_evt_SetSequenceObjAttr seq_obj

  set Page::($page_obj,prev_seq) 2
  UI_PB_evt_PackforgetBoxActCanvas page_obj

  # Unpacks the nc frame
    UI_PB_evt_UnpackDispNcFrame page_obj

  if {$Page::($page_obj,topcanvas_flag) == 0} \
  {
     pack forget $Page::($page_obj,top_canvas)
     set Page::($page_obj,topcanvas_flag) 1
  }

  set sequence::($seq_obj,ude_flag) 1
  if {$Page::($page_obj,act_box_flag) == 0}\
  {
     pack forget $Page::($page_obj,act_box)
     set Page::($page_obj,act_box_flag) 1
  }
  $Page::($page_obj,bot_canvas) yview moveto 0
  $Page::($page_obj,bot_canvas) xview moveto 0
}

#==================================================================
proc UI_PB_evt_Cycles { PAGE_OBJ } {
#==================================================================
  upvar $PAGE_OBJ page_obj

  # Deletes the objects of previous sequence
    UI_PB_evt_DeleteObjectsPrevSeq page_obj

  set seq_obj [lindex $Page::($page_obj,seq_obj_list) 3]
  # Sets all the sequence attributes to the seq_obj
    UI_PB_evt_SetSequenceObjAttr seq_obj

  set Page::($page_obj,prev_seq) 2.1
  UI_PB_evt_PackforgetBoxActCanvas page_obj

  # Unpacks the Nc toggle frame
  UI_PB_evt_UnpackDispNcFrame page_obj

  if {$Page::($page_obj,topcanvas_flag) == 0} \
  {
     pack forget $Page::($page_obj,top_canvas)
     set Page::($page_obj,topcanvas_flag) 1
  }
  set sequence::($seq_obj,ude_flag) 0
  if {$Page::($page_obj,act_box_flag) == 0}\
  {
     pack forget $Page::($page_obj,act_box)
     set Page::($page_obj,act_box_flag) 1
  }
  $Page::($page_obj,bot_canvas) yview moveto 0
  $Page::($page_obj,bot_canvas) xview moveto 0
}

#==================================================================
proc UI_PB_evt_Motion { PAGE_OBJ } {
#==================================================================
  upvar $PAGE_OBJ page_obj

  # Deletes the objects of previous sequence
    UI_PB_evt_DeleteObjectsPrevSeq page_obj

  set seq_obj [lindex $Page::($page_obj,seq_obj_list) 4]
  # Sets all the sequence attributes to the seq_obj
    UI_PB_evt_SetSequenceObjAttr seq_obj

  set Page::($page_obj,prev_seq) 2.2
  UI_PB_evt_PackforgetBoxActCanvas page_obj

  # Unpacks the nc frame
    UI_PB_evt_UnpackDispNcFrame page_obj

  if {$Page::($page_obj,topcanvas_flag) == 0} \
  {
     pack forget $Page::($page_obj,top_canvas)
     set Page::($page_obj,topcanvas_flag) 1
  }
  set sequence::($seq_obj,ude_flag) 0
  if {$Page::($page_obj,act_box_flag) == 0}\
  {
     pack forget $Page::($page_obj,act_box)
     set Page::($page_obj,act_box_flag) 1
  }
  $Page::($page_obj,bot_canvas) yview moveto 0
  $Page::($page_obj,bot_canvas) xview moveto 0
}

#==================================================================
proc UI_PB_evt_UserDefined { PAGE_OBJ } {
#==================================================================
  upvar $PAGE_OBJ page_obj
  # Deletes the objects of previous sequence
    UI_PB_evt_DeleteObjectsPrevSeq page_obj

# To be implemented
# set sequence::($seq_obj,ude_flag) 0
}

#==================================================================
proc UI_PB_evt_OperEndSeq { PAGE_OBJ } {
#==================================================================
  upvar $PAGE_OBJ page_obj
  global mom_sys_arr

  # Deletes the objects of previous sequence
    UI_PB_evt_DeleteObjectsPrevSeq page_obj

  set seq_obj [lindex $Page::($page_obj,seq_obj_list) 5]
  # Sets all the sequence attributes to the seq_obj
    UI_PB_evt_SetSequenceObjAttr seq_obj

  # packs the nc frame
    UI_PB_evt_PackDispNcFrame page_obj

  # Top Canvas
    UI_PB_evt_TopCanvasPackUnpack page_obj

   set Page::($page_obj,prev_seq) 3
   UI_PB_evt_PackforgetBoxActCanvas page_obj
   if {$Page::($page_obj,act_box_flag) == 1}\
   {
      pack $Page::($page_obj,act_box) -side bottom -fill x \
                           -padx 3 -pady 3
      set Page::($page_obj,act_box_flag) 0
   }
   $Page::($page_obj,bot_canvas) yview moveto 0
   $Page::($page_obj,bot_canvas) xview moveto 0
}

#==================================================================
proc UI_PB_evt_ProgEndSeq { PAGE_OBJ } {
#==================================================================
  upvar $PAGE_OBJ page_obj
  global mom_sys_arr

  # Deletes the objects of previous sequence
    UI_PB_evt_DeleteObjectsPrevSeq page_obj

  set seq_obj [lindex $Page::($page_obj,seq_obj_list) 6]

  # Sets all the sequence attributes to the seq_obj
    UI_PB_evt_SetSequenceObjAttr seq_obj

  # packs the nc frame
    UI_PB_evt_PackDispNcFrame page_obj

  # Top Canvas
    UI_PB_evt_TopCanvasPackUnpack page_obj

  set Page::($page_obj,prev_seq) 4

  UI_PB_evt_PackforgetBoxActCanvas page_obj
  if {$Page::($page_obj,act_box_flag) == 1}\
  {
     pack $Page::($page_obj,act_box) -side bottom -fill x \
                           -padx 3 -pady 3
     set Page::($page_obj,act_box_flag) 0
  }
  $Page::($page_obj,bot_canvas) yview moveto 0
  $Page::($page_obj,bot_canvas) xview moveto 0
}

#==================================================================
proc UI_PB_evt_progItemSelection {page_obj args} {
#==================================================================
  set tree $Page::($page_obj,tree)
  set HLIST [$tree subwidget hlist]
  set ent [$HLIST info anchor]
  set index [string range $ent 2 [string length $ent]]

  if { [string compare $index ""] == 0} \
  {
     set index 0
     $HLIST selection clear
     $HLIST anchor clear 
     $HLIST selection set 0.0
     $HLIST anchor set 0.0
  } elseif {$index == 2} \
  {
       $HLIST selection clear
       $HLIST anchor clear 
       $HLIST selection set 0.2.0
       $HLIST anchor set 0.2.0
  }

  if {$Page::($page_obj,prev_seq) != $index} \
  {
     # Display all the attributes of a sequence
       UI_PB_evt_SetASequenceAttr $page_obj $index

     # Restores the sequence data
       UI_PB_evt_GetSequenceIndex page_obj seq_index
       set seq_obj [lindex $Page::($page_obj,seq_obj_list) $seq_index]
       UI_PB_evt_RestoreSeqObjData seq_obj

     # Creates the sequence elements
       UI_PB_evt_CreateSeqAttributes page_obj
  }
}

#==================================================================
proc UI_PB_evt_SetASequenceAttr {page_obj index} {
#==================================================================
  global mom_sys_arr
  set bot_canvas $Page::($page_obj,bot_canvas)

  switch $index \
  {
      0 {
            set mom_sys_arr(seq_blk_nc_code) $mom_sys_arr(\$pgss_blk_nc)
            UI_PB_evt_ProgStartSeq page_obj
            bind $bot_canvas <3> "UI_PB_evt_CanvasPopupMenu $page_obj %X %Y"
        }
      1 {
            set mom_sys_arr(seq_blk_nc_code) $mom_sys_arr(\$pges_blk_nc)
            UI_PB_evt_OperStartSeq page_obj
            bind $bot_canvas <3> "UI_PB_evt_CanvasPopupMenu $page_obj %X %Y"
        }
      2 {
            UI_PB_evt_MachineControl page_obj
            bind $bot_canvas <3> ""
        }
    2.0 {
            UI_PB_evt_MachineControl page_obj
            bind $bot_canvas <3> ""
        }
    2.1 {
            UI_PB_evt_Cycles page_obj
            bind $bot_canvas <3> ""
        }
    2.2 {
            UI_PB_evt_Motion page_obj
            bind $bot_canvas <3> ""
        }
    2.3 {
            UI_PB_evt_UserDefined page_obj
            bind $bot_canvas <3> ""
        }
      3 {
            set mom_sys_arr(seq_blk_nc_code) $mom_sys_arr(\$opss_blk_nc)
            UI_PB_evt_OperEndSeq page_obj
            bind $bot_canvas <3> "UI_PB_evt_CanvasPopupMenu $page_obj %X %Y"
        }
      4 {
            set mom_sys_arr(seq_blk_nc_code) $mom_sys_arr(\$opes_blk_nc)
            UI_PB_evt_ProgEndSeq page_obj
            bind $bot_canvas <3> "UI_PB_evt_CanvasPopupMenu $page_obj %X %Y"
        }
  }
}

#=======================================================
proc UI_PB_evt_PackforgetBoxActCanvas {PAGE_OBJ} {
#=======================================================
  upvar $PAGE_OBJ page_obj

  # unpacks the action canvas
   if {$Page::($page_obj,action_flag) == 0} \
   {
       pack forget $Page::($page_obj,action_canvas)
       set Page::($page_obj,action_flag) 1
   }

  # packs the horizontal scroller, if it is not packed
   if {$Page::($page_obj,hor_scrol_flag) == 1} \
   {
       pack forget $Page::($page_obj,bot_canvas)
       pack $Page::($page_obj,hor_scrol) -side bottom -fill x
       pack $Page::($page_obj,bot_canvas) -side left \
                      -expand yes -fill both -padx 3
       set Page::($page_obj,hor_scrol_flag) 0
   }

  # Unpacks the sequence template selection box
  if {$Page::($page_obj,box_flag) == 0} \
  {
      pack forget $Page::($page_obj,box)
      set Page::($page_obj,box_flag) 1
  }
}

#=======================================================
proc UI_PB_evt_SetSequenceObjAttr {SEQ_OBJ} {
#=======================================================
 upvar $SEQ_OBJ seq_obj

  set sequence::($seq_obj,region) 60
  set sequence::($seq_obj,evt_focus_cell) 0
  set sequence::($seq_obj,blk_focus_cell) 0
  set sequence::($seq_obj,active_evt) 0
  set sequence::($seq_obj,focus_rect) 0
  set sequence::($seq_obj,focus_sep) 0
  set sequence::($seq_obj,icon_top) 0
  set sequence::($seq_obj,icon_top_text) 0
  set sequence::($seq_obj,icon_bot) 0
  set sequence::($seq_obj,icon_bot_text) 0
  set sequence::($seq_obj,add_blk) 0
  set sequence::($seq_obj,blk_temp) 0
  set sequence::($seq_obj,drag_flag) 0
  set sequence::($seq_obj,trash_flag) 0
  set sequence::($seq_obj,action_blk_add) 0
}

