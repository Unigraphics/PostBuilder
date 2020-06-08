#==============================================================================
#                         UI_PB_COMMON.TCL
#==============================================================================
###############################################################################
# Description                                                                 #
#     This file contains all the common functions.                            #
#                                                                             #
# Revisions                                                                   #
#                                                                             #
#   Date        Who       Reason                                              #
# 01-feb-1999   mnb       Initial                                             #
# 07-Apr-1999   mnb       Removed puts                                        #
# 02-Jun-1999   mnb       Code Integration                                    #
# 04-Jun-1999   mnb       Added pb_ to image names                            #
# 28-Jun-1999   mnb       Text can be placed at any position in a block       #
# 30-Jun-1999   mnb       Added a procedure to create text window             #
# 07-Sep-1999   mnb       Added Validity functions for the entry widget.      #
# 21-Sep-1999   mnb       Changed the Text Dialog proc to handle event        #
# 21-Oct-1999   gsl       Added CreateTransientWindow, ClaimActiveWindow,     #
#                         DismissActiveWindow & GrabWindow.                   #
# 17-Nov-1999   gsl       Submitted for phase-22.                             #
#                                                                             #
# $HISTORY$                                                                   #
#                                                                             #
###############################################################################

#==============================================================================
proc UI_PB_com_CreateTransientWindow { w title geom \
                                       win_close_cb pre_destroy_cb \
                                       args } {
#==============================================================================
 global gPB


 #-----------------------------------------------
 # Cleanup arguments by removing unwanted blanks
 #-----------------------------------------------
  set geom           [string trim $geom           " "]
  set win_close_cb   [string trim $win_close_cb   " "]
  set pre_destroy_cb [string trim $pre_destroy_cb " "]

 #-------------------------------------
 # Validate existence of parent window
 #-------------------------------------
  set pw [winfo parent $w]
  if { $pw == "" } {
return [tk_messageBox -parent [UI_PB_com_AskActiveWindow] -type ok -icon error \
                      -message "Transient window requires parent window defined."]
  } else {
    wm transient $w $pw
  }

 #-------------------------------
 # Hide window before completion
 #-------------------------------
  wm withdraw $w

 #-----------
 # Set title
 #-----------
  wm title $w $title

 #-------------------------------------------------
 # Callback to be executed when window is <CLOSE>d.
 #-------------------------------------------------
  if { $win_close_cb != "" } {
    wm protocol $w WM_DELETE_WINDOW "$win_close_cb"
  }

 #----------------------------------------------------
 # Callback to be executed when window is <DESTROY>ed.
 #----------------------------------------------------
  if { $pre_destroy_cb != "" } {
    bind $w <Destroy> "$pre_destroy_cb"
  }
  bind $w <Destroy> "+UI_PB_com_DismissActiveWindow $w"
  bind $w <Destroy> "+UI_PB_com_DeleteFromTopLevelList $w"

 #--------------------------------------------------------------------
 # Memorize current grab to be restored when this window is dismissed.
 #--------------------------------------------------------------------
  set gPB(prev_window_grab) [grab current]

 #---------------------
 # Set window geometry
 #---------------------
  if { $geom != "" } {
   #
   # Specified...
   #
    wm geometry $w $geom

  } else {
   #
   # Not specified, shift it from current active window.
   #
    set aw [UI_PB_com_AskActiveWindow]
    set xc [expr [winfo rootx $aw] + 20]
    set yc [expr [winfo rooty $aw] - 60]

    wm geometry $w +$xc+$yc
  }

 #----------------
 # Display window
 #----------------
  wm deiconify $w
  focus $w

 #---------------------
 # Track active window
 #---------------------
  UI_PB_com_ClaimActiveWindow $w

 #------------------------------------
 # Parse additional arguments, if any.
 #------------------------------------
  if {[llength $args] == 0} {

    UI_PB_com_DisableMainWindow

  } else {

    if { [lindex $args 0] != 0 } {
      UI_PB_com_DisableMainWindow
    }
  }

##  if {[llength $args] > 0} {
##
##    if { [lindex $args 0] != 0 } {
##      UI_PB_com_DisableMainWindow
##    }
##  }

 #------------------------------------
 # Add to toplevel To-Be-Deleted list
 #------------------------------------
  UI_PB_com_AddToTopLevelList $w

## "wm withdraw" callback causes File Selection dialog
## to withdraw upon realization.
##  bind $w <Destroy> "+wm withdraw $w"
}

#==============================================================================
proc UI_PB_com_AddToTopLevelList { w args } {
#==============================================================================
 global gPB

  if { $w != "$gPB(top_window).new"  && \
       $w != "$gPB(top_window).open" && \
       [lsearch $gPB(toplevel_list) $w] < 0 } {

    set gPB(toplevel_list) [linsert $gPB(toplevel_list) end $w]
  }
}

#==============================================================================
proc UI_PB_com_DeleteFromTopLevelList { w args } {
#==============================================================================
 global gPB

  set wi [lsearch $gPB(toplevel_list) $w]

  if { $wi >= 0 } {

    set gPB(toplevel_list) [lreplace $gPB(toplevel_list) $wi $wi]
  }
}

#==============================================================================
proc UI_PB_com_DeleteTopLevelWindows { args } {
#==============================================================================
 global gPB

  set w [lindex $gPB(toplevel_list) end]

  while { $w != "" } {

    wm withdraw    $w
    tixDestroy     $w

    set w [lindex $gPB(toplevel_list) end]
  }

  set gPB(toplevel_list) {}
  set gPB(main_window) ""
  unset gPB(book)
}

#==============================================================================
proc UI_PB_com_ClaimActiveWindow { win args } {
#==============================================================================
 global gPB

  set wi [lsearch -exact $gPB(active_window_list) $win]

  if { $wi < 0 } {
   #
   # Window not in the active list.. Add it to the list.
   #
    set gPB(active_window_list) [linsert $gPB(active_window_list) end $win]

  } elseif { $wi == [expr [llength $gPB(active_window_list)] - 1] } {
   #
   # Window already active... Do nothing.
   #

  } else {
   #
   # Window in the list but not active... Move it to the end of list.
   #
      set gPB(active_window_list) [lreplace $gPB(active_window_list) $wi $wi]
      set gPB(active_window_list) [linsert  $gPB(active_window_list) end $win]
  }

  set gPB(active_window) $win
}

#==============================================================================
proc UI_PB_com_AskActiveWindow { args } {
#==============================================================================
 global gPB

  if { $gPB(active_window) == 0 || $gPB(active_window) == "" } {
return $gPB(top_window)
  } else {
return $gPB(active_window)
  }
}

#==============================================================================
proc UI_PB_com_DisableMainWindow { args } {
#==============================================================================
 global gPB
 global paOption tixOption
 global machTree machData

 #**************************************
 # Main window is not yet created. Bail!
 #**************************************
  if { ![info exists gPB(book)] } {
return
  }

 #***************************
 # Not yet disabled... Do it.
 #***************************
  if { $gPB(main_window_disabled) == 0 && \
       $gPB(active_window) != $gPB(main_window) && \
       $gPB(active_window) != $gPB(top_window) } \
  {
    set gPB(main_window_disabled) 1

    set pb_book_id $Book::($gPB(book),book_id)

   #*******************************************************************
   # Save away the Button-1 callback and attach a message dialog to it.
   #*******************************************************************
    set gPB(pb_book_b1_cb) [bind [$pb_book_id subwidget nbframe] <1>]

    bind [$pb_book_id subwidget nbframe] <1> \
         "tk_messageBox -parent [UI_PB_com_AskActiveWindow] -type ok -icon error \
          -message \"You have to close all sub-windows to enable this tab.\""

    $pb_book_id pageconfig mac -state disabled
    $pb_book_id pageconfig pro -state disabled
    $pb_book_id pageconfig def -state disabled
    $pb_book_id pageconfig lis -state disabled
    $pb_book_id pageconfig pre -state disabled
    $pb_book_id pageconfig adv -state disabled

    set pb_book_page_list $Book::($gPB(book),page_obj_list)

    set current_book_tab $Book::($gPB(book),current_tab)

   #**********
   # Chapters
   #**********
    set chap    [lindex $pb_book_page_list $current_book_tab]

   #***************************************
   # Disable sub-tabs, if the chapter is...
   #  = 1 : Program & Tool Path
   #  = 2 : N/C Data Definitions
   #  = 4 : Files Preview
   #***************************************
    if { $current_book_tab == 1 || \
         $current_book_tab == 2 || \
         $current_book_tab == 4 } {

     #**********
     # Sections
     #**********
      set sect    $Page::($chap,book_obj)
      set sect_id $Book::($sect,book_id)

     #***********************
     # Get tabbed pages info
     #***********************
      set page_tab $Book::($sect,current_tab)
      set page_obj [lindex $Book::($sect,page_obj_list) $page_tab]

    }

   #***************************
   # Retrieve some font styles
   #***************************
    set sty_n  $gPB(font_style_normal)
    set sty_b  $gPB(font_style_bold)
    set sty_ng $gPB(font_style_normal_gray)
    set sty_bg $gPB(font_style_bold_gray)


    switch $current_book_tab \
    {
      0 { ;# Machine Tool

        UI_PB_mach_DisableWindow
      }

      1 { ;# Program & Tool Path

        UI_PB_prog_DisableWindow chap
      }

      2 { ;# N/C Data Definitions

        UI_PB_def_DisableWindow chap
      }

      3 { ;# Listing File
      }

      4 { ;# Files Preview

       # Save away the Button-1 callback and attach a message dialog to it.
       #
        set gPB($sect_id,b1_cb) [bind [$sect_id subwidget nbframe] <1>]

        bind [$sect_id subwidget nbframe] <1> \
             "tk_messageBox -parent [UI_PB_com_AskActiveWindow] -type ok -icon error\
              -message \"You have to close all sub-windows to enable this tab.\""

        $sect_id pageconfig eve -state disabled
        $sect_id pageconfig def -state disabled

        set t $Page::($page_obj,tree)
        set h [$t subwidget hlist]

       # Disable tree items on tabbed pages
        switch $page_tab \
        {
          0 {  ;# Events
        
           # Disable everything first, then enable the selected item.
          }
          1 {  ;# Definitions
        
           # Disable everything first, then enable the selected item.
          }
        }
      }

      5 { ;# Post Advisor
      }
    }
  }
}

#==============================================================================
proc UI_PB_com_EnableMainWindow { args } {
#==============================================================================
 global gPB

 # More than main window still open... Leave it disabled.
 #
  if { [llength $gPB(toplevel_list)] > 1 } {
return
  }

  if { $gPB(main_window_disabled) } \
  {
    set pb_book_id $Book::($gPB(book),book_id)

   # Restore Button-1 callback for the book
    bind [$pb_book_id subwidget nbframe] <1> $gPB(pb_book_b1_cb)

    $pb_book_id pageconfig mac -state normal
    $pb_book_id pageconfig pro -state normal
    $pb_book_id pageconfig def -state normal
    $pb_book_id pageconfig lis -state normal
    $pb_book_id pageconfig pre -state normal
    $pb_book_id pageconfig adv -state normal

    set pb_book_page_list $Book::($gPB(book),page_obj_list)

    set current_book_tab $Book::($gPB(book),current_tab)

    set gPB(main_window_disabled) 0

   # Enable chapter's tabs, if any...
   #
    if { $current_book_tab == 1 || \
         $current_book_tab == 2 || \
         $current_book_tab == 4 } {

      set chap    [lindex $pb_book_page_list $current_book_tab]
      set sect    $Page::($chap,book_obj)
      set sect_id $Book::($sect,book_id)

     # Restore Button-1 callback for the chapter
      bind [$sect_id subwidget nbframe] <1> $gPB($sect_id,b1_cb)

    }

   #***************************
   # Retrieve some font styles
   #***************************
    set sty_n  $gPB(font_style_normal)
    set sty_b  $gPB(font_style_bold)
    set sty_ng $gPB(font_style_normal_gray)
    set sty_bg $gPB(font_style_bold_gray)


    switch $current_book_tab \
    {
      0 { ;# Machine Tool

        UI_PB_mach_EnableWindow
      }

      1 { ;# Program & Tool Path

        UI_PB_prog_EnableWindow chap
      }

      2 { ;# N/C Data Definitions

        UI_PB_def_EnableWindow chap

####        $sect_id pageconfig blk -state normal
####        $sect_id pageconfig adr -state normal
####        $sect_id pageconfig fmt -state normal
####        $sect_id pageconfig ele -state normal
      }

      3 { ;# Listing File
      }

      4 { ;# Code Preview

        $sect_id pageconfig eve -state normal
        $sect_id pageconfig def -state normal
      }

      5 { ;# Post Advisor
      }
    }
  }
}

#==============================================================================
proc UI_PB_com_DismissActiveWindow { win args } {
#==============================================================================
 global gPB

 #------------------------
 # Leave top window alone
 #------------------------
  if { $win != $gPB(top_window) } {

    set wi [lsearch $gPB(active_window_list) $win]

   # Unclaim active window status
    if { $wi > -1 } {
      set gPB(active_window_list) [lreplace $gPB(active_window_list) $wi $wi]
      set gPB(active_window) [lindex $gPB(active_window_list) end]
    }

   # Release window grab
    set cwg [grab current]

    if { $cwg != $win } {
      grab release $cwg

     # Restore previous window grab
      if { $gPB(prev_window_grab) != "" && \
           [winfo exists $gPB(prev_window_grab)] } {
        grab $gPB(prev_window_grab)
      }
    }
  }

 # Enable main window when needed.
  UI_PB_com_EnableMainWindow

 # Set focus onto avtive window
  focus [UI_PB_com_AskActiveWindow]
}

#==============================================================================
proc UI_PB_com_RetImageAppdText { ADDR_OBJ ELEM_MOM_VAR IMG_NAME \
                                  WORD_APP_TEXT} {
#==============================================================================
  upvar $ADDR_OBJ addr_obj
  upvar $ELEM_MOM_VAR elem_mom_var
  upvar $IMG_NAME image_name
  upvar $WORD_APP_TEXT word_app_text

  set WORD_LEADER $address::($addr_obj,add_leader)
  set WORD_LEADER [string trim $WORD_LEADER]
  PB_com_MapMOMVariable addr_obj elem_mom_var word_app_text
  PB_int_ApplyFormatAppText addr_obj word_app_text

  set leader_len [string length $WORD_LEADER]
  if { $leader_len > 1} \
  {
     set no_chars 5
     set image_name "blank"
     append temp_app_text $WORD_LEADER $word_app_text 
     UI_PB_com_TrimOrFillAppText temp_app_text no_chars
     set word_app_text $temp_app_text
     unset temp_app_text
  } elseif { $leader_len == 0} \
  {
     set no_chars 5
     set image_name "blank"
     UI_PB_com_TrimOrFillAppText word_app_text no_chars
  } else \
  {
     set no_chars 3
     set image_name $WORD_LEADER
     UI_PB_com_TrimOrFillAppText word_app_text no_chars
  }

  append temp_image_name "pb_" $image_name "_addr"
  set image_name $temp_image_name
  unset temp_image_name
}

#==========================================================================
proc UI_PB_blk_CreateIcon { canvas bitmap label } {
#==========================================================================
  global tixOption
  set fixed_font  -*-courier-medium-r-*-*-12-*-*-*-*-*-*-*

  set comp [image create compound -window $canvas \
                                  -bd 1 \
                                  -background #c0c0ff \
                                  -borderwidth 2 \
                                  -relief raised \
                                  -showbackground 1]

  set image_addr [tix getimage $bitmap]
  $comp add image -image $image_addr
  # Using fixed font to keep all buttons in same size
    $comp add text -text $label -font $fixed_font -anchor w

  return $comp
}

#==========================================================================
proc UI_PB_com_TrimOrFillAppText { APP_TEXT NO_CHARS } {
#==========================================================================
  upvar $APP_TEXT app_text
  upvar $NO_CHARS no_chars
 
  set app_text_len [string length $app_text]
 
  if {$app_text_len < $no_chars}\
  {
     append temp_var $app_text
     for {set x $app_text_len} {$x < $no_chars} {incr x}\
     {
       append temp_var " "
     }
     set app_text $temp_var
     unset temp_var
  } elseif {$app_text_len > $no_chars}\
  {
     set app_text [string range $app_text 0 [expr $no_chars - 1]]
  }
}

#==============================================================================
proc UI_PB_com_ChangeCursor { canvas_id } {
#==============================================================================
  global tcl_platform

  if {$tcl_platform(platform) == "unix"} \
  {
   # Change cursor
     global env
     set cur "$env(PB_HOME)/images/pb_hand.xbm"
     set msk "$env(PB_HOME)/images/pb_hand.mask"
     $canvas_id config -cursor "@$cur $msk black white"
  }
}

#==============================================================================
proc UI_PB_com_FormatString { string } {
#==============================================================================

    set actual_width [font measure {Helvetica 10} $string]

    set blank_width [font measure {Helvetica 10} " "]

    set font_width 100
    if {$font_width > $actual_width} \
    {
       set diff_width [expr $font_width - $actual_width]
       set no_of_blanks [expr $diff_width / $blank_width]
       for {set count 0} {$count < $no_of_blanks} {incr count} \
       {
            append string " "
       }
    }
    return $string
}

#=============================================================================
proc UI_PB_com_ReturnBlockName { EVENT_OBJ BLOCK_NAME } {
#=============================================================================
  upvar $EVENT_OBJ event_obj
  upvar $BLOCK_NAME block_name

  set event_name $event::($event_obj,event_name)
  set temp_event_name [split $event_name]
  set event_name [join $temp_event_name _ ]
  set event_name [string tolower $event_name]

  # Validates the block name
    set obj_attr(0) $event_name
    PB_int_GetAllBlockNames blk_name_list
    PB_com_SetDefaultName blk_name_list obj_attr
    set block_name $obj_attr(0)
}

#==============================================================================
proc UI_PB_com_CreateBlkNcCode { BLK_ELEM_OBJ_LIST BLK_NC_CODE} {
#==============================================================================
  upvar $BLK_ELEM_OBJ_LIST blk_elem_obj_list
  upvar $BLK_NC_CODE blk_nc_code

  foreach blk_elem $blk_elem_obj_list\
  {
     set add_obj $block_element::($blk_elem,elem_add_obj)
     set add_leader $address::($add_obj,add_leader)
     set blk_elem_mom_var $block_element::($blk_elem,elem_mom_variable)
     PB_com_MapMOMVariable add_obj blk_elem_mom_var app_text
     PB_int_ApplyFormatAppText add_obj app_text
     set app_image_name ${add_leader}${app_text}
     lappend blk_nc_code $app_image_name
     unset app_image_name
   }
}

#==============================================================================
proc UI_PB_com_RetActiveBlkElems { BLK_ELEM_OBJ_LIST } {
#==============================================================================
   upvar $BLK_ELEM_OBJ_LIST blk_elem_obj_list

   foreach blk_elem_obj $blk_elem_obj_list \
   {
      set add_obj $block_element::($blk_elem_obj,elem_add_obj)
      if { $address::($add_obj,word_status) == 0} \
      {
         lappend temp_blk_elem_list $blk_elem_obj
      }
   }
  
   if {[info exists temp_blk_elem_list]}\
   {
     set blk_elem_obj_list $temp_blk_elem_list
     unset temp_blk_elem_list
   } else \
   {
     set blk_elem_obj_list ""
   }
}

#==============================================================================
proc UI_PB_com_RetTextPosAttr {BLK_ELEM_OBJ_LIST TEXT_LDTR_ARR} {
#==============================================================================
  upvar $BLK_ELEM_OBJ_LIST blk_elem_obj_list
  upvar $TEXT_LDTR_ARR text_ldtr_arr

  set index 0
  foreach blk_elem_obj $blk_elem_obj_list \
  {
     set add_obj $block_element::($blk_elem_obj,elem_add_obj)
     if {[string compare $address::($add_obj,add_name) "Text"] == 0} \
     {
        if { $index == 0} \
        {
           set text_ldtr_arr($blk_elem_obj,leading) "" 
        } else \
        {
           set text_ldtr_arr($blk_elem_obj,leading) \
                    [lindex $blk_elem_obj_list [expr $index - 1]]
        }

        if { [llength $blk_elem_obj_list] == [expr $index + 1] } \
        {
           set text_ldtr_arr($blk_elem_obj,trailing) ""
        } else \
        {
           set text_ldtr_arr($blk_elem_obj,trailing) \
                    [lindex $blk_elem_obj_list [expr $index + 1]]
        }

     }
     incr index
  }
}

#==============================================================================
proc UI_PB_com_SeperateTextElements {BLK_ELEM_OBJ_LIST TEXT_ELEM_LIST} {
#==============================================================================
  upvar $BLK_ELEM_OBJ_LIST blk_elem_obj_list
  upvar $TEXT_ELEM_LIST text_elem_list

  set no_elems [llength $blk_elem_obj_list]

  for {set count 0} {$count < $no_elems} {incr count} \
  {
     set blk_elem_obj [lindex $blk_elem_obj_list $count]
     set add_obj $block_element::($blk_elem_obj,elem_add_obj)
     if {[string compare $address::($add_obj,add_name) "Text"] != 0} \
     {
        lappend temp_blk_elem_list $blk_elem_obj
     } else \
     {
        lappend text_elem_list $blk_elem_obj
     }
  }

  if {[info exists temp_blk_elem_list]} \
  {
     set blk_elem_obj_list $temp_blk_elem_list
  } else \
  {
     set blk_elem_obj_list ""
  }
}

#==============================================================================
proc UI_PB_com_AddTextElements { BLK_ELEM_OBJ_LIST TEXT_ELEM_LIST  \
                                 TEXT_LDTR_ARR } {
#==============================================================================
  upvar $BLK_ELEM_OBJ_LIST blk_elem_obj_list
  upvar $TEXT_ELEM_LIST text_elem_list
  upvar $TEXT_LDTR_ARR text_ldtr_arr

  if {[info exists text_ldtr_arr]} \
  {
     foreach text_obj $text_elem_list \
     {
        set leading_obj $text_ldtr_arr($text_obj,leading)
        set trailing_obj $text_ldtr_arr($text_obj,trailing)
        if {$leading_obj != ""} \
        {
           set lead_res [lsearch $blk_elem_obj_list $leading_obj]
           if {$lead_res != -1} \
           {
               set blk_elem_obj_list [linsert $blk_elem_obj_list \
                                           [expr $lead_res + 1] $text_obj]
           }
        } else \
        {
           if {$trailing_obj != ""} \
           {
              set trail_res [lsearch $blk_elem_obj_list $trailing_obj]
              if {$trail_res != -1} \
              {
                 set blk_elem_obj_list [linsert $blk_elem_obj_list \
                                           $trail_res $text_obj]
              } else \
              {
                 set blk_elem_obj_list [linsert $blk_elem_obj_list 0 $text_obj]
              }
           } else \
           {
              set blk_elem_obj_list [linsert $blk_elem_obj_list 0 $text_obj]
           }
        }
     }
  }
}

#==============================================================================
proc UI_PB_com_SortBlockElements {BLK_ELEM_OBJ_LIST} {
#==============================================================================
  upvar $BLK_ELEM_OBJ_LIST blk_elem_obj_list

  # Returns the text address leading and trailing elements
    UI_PB_com_RetTextPosAttr blk_elem_obj_list text_ldtr_arr

  # Seperates text elements
    UI_PB_com_SeperateTextElements blk_elem_obj_list text_elem_list

  set no_elements [llength $blk_elem_obj_list]
  for {set ii 0} {$ii < [expr $no_elements - 1]} {incr ii} \
  {
     for {set jj [expr $ii + 1]} {$jj < $no_elements} {incr jj} \
     {
         set blk_ii_obj [lindex $blk_elem_obj_list $ii]
         set add_ii_obj $block_element::($blk_ii_obj,elem_add_obj)
         set add_ii_index $address::($add_ii_obj,seq_no)

         set blk_jj_obj [lindex $blk_elem_obj_list $jj]
         set add_jj_obj $block_element::($blk_jj_obj,elem_add_obj)
         set add_jj_index $address::($add_jj_obj,seq_no)
         if {$add_jj_index < $add_ii_index} \
         {
              set blk_elem_obj_list [lreplace $blk_elem_obj_list $ii $ii \
                                           $blk_jj_obj]

              set blk_elem_obj_list [lreplace $blk_elem_obj_list $jj $jj \
                                           $blk_ii_obj]
          }
     }
  }

  # Adds the text elements to the block element list
    UI_PB_com_AddTextElements blk_elem_obj_list text_elem_list \
                              text_ldtr_arr
}

#==============================================================================
proc UI_PB_com_ApplyMastSeqBlockElem { BLK_ELEM_OBJ_LIST } {
#==============================================================================
  upvar $BLK_ELEM_OBJ_LIST blk_elem_obj_list

  UI_PB_com_RetActiveBlkElems blk_elem_obj_list
  UI_PB_com_SortBlockElements blk_elem_obj_list
}

#==============================================================================
proc UI_PB_com_ReturnEventNcOutAttr { EVENT_OBJ EVT_NC_WIDTH \
                                      EVT_NC_HEIGHT EVT_NC_OUTPUT} {
#==============================================================================
   upvar $EVENT_OBJ event_obj
   upvar $EVT_NC_WIDTH evt_nc_width
   upvar $EVT_NC_HEIGHT evt_nc_height
   upvar $EVT_NC_OUTPUT evt_nc_output

   set evt_nc_width 0
   set evt_nc_height 0

   foreach row_elem_obj $event::($event_obj,evt_elem_list) \
   {
      foreach elem_obj $row_elem_obj \
      {
         set block_obj $event_element::($elem_obj,block_obj)
         foreach blk_elem $block::($block_obj,elem_addr_list) \
         {
            lappend row_blk_elem_list $blk_elem
         }
      }

      if {[info exists row_blk_elem_list]} \
      {
          UI_PB_com_ApplyMastSeqBlockElem row_blk_elem_list
          if {[info exist row_blk_nc_output]} \
          {
              unset row_blk_nc_output
          }
          UI_PB_com_CreateBlkNcCode row_blk_elem_list row_blk_nc_output

          if {[info exists row_blk_elem_list]} \
          {
              unset row_blk_elem_list
          }

          if {[info exists row_blk_nc_output]} \
          {
              set blk_nc_width [font measure {Helvetica 10} \
                         $row_blk_nc_output]
              set evt_nc_height [expr $evt_nc_height + \
                      [font metrics {Helvetica 10} -linespace]]
              if {$blk_nc_width > $evt_nc_width} \
              {
                 set evt_nc_width $blk_nc_width
              }
              append temp_evt_nc_output $row_blk_nc_output "\n"
              unset row_blk_nc_output
          }
       }
   }

   if {[info exists temp_evt_nc_output]} \
   {
      set evt_nc_output $temp_evt_nc_output
      unset temp_evt_nc_output
   }
}

#==============================================================================
proc UI_PB_com_CreateRectangle  { canvas x1 y1 x2 y2 \
                                   fill_color outline_color} {
#===============================================================================
  set cell_box_width 0
  set rect_id [$canvas create rect \
                   $x1 $y1 $x2 $y2 -outline $outline_color \
                   -width $cell_box_width -fill $fill_color -tag stationary]
  return $rect_id
}

#==============================================================================
proc CB_nb_def {w tab_img book_obj} {
#==============================================================================
  # Unhighlight previously selected tab
    if {$Book::($book_obj,x_def_tab_img) != 0} \
    {
       $Book::($book_obj,x_def_tab_img) config -showbackground 0
    }

  # Highlight currently selected tab
    $tab_img config -showbackground 1

  # Remember this tab
    set Book::($book_obj,x_def_tab_img) $tab_img
}

#===============================================================================
proc UI_PB_com_CreateRowAttr { column_frm row_no label mom_var data_type } {
#===============================================================================
  global tixOption
  global mom_sys_arr
  set row_frm [frame $column_frm.$row_no]
  set bgc lightSkyBlue
  $row_frm config -relief solid -bd 1 -bg $bgc
  pack $row_frm -side top -fill x -expand yes

  Page::CreateLblEntry $data_type $mom_var $row_frm int $label
  $row_frm.int config -bg $bgc -font $tixOption(bold_font)
}

#===============================================================================
proc UI_PB_com_CheckElemBlkTemplate { BLOCK_OBJ NEW_BLK_ELEM_ADDR } {
#===============================================================================
  upvar $BLOCK_OBJ block_obj
  upvar $NEW_BLK_ELEM_ADDR new_blk_elem_addr

  set blk_elem_flag 0

  if {[string compare $new_blk_elem_addr "Text"] == 0} \
  {
     return $blk_elem_flag
  }

  if {[info exists block::($block_obj,active_blk_elem_list)]} \
  {
     # Returns the addresses
       PB_int_GetBlockElementAddr new_blk_elem_addr base_addr_list

     foreach blk_elem_obj $block::($block_obj,active_blk_elem_list) \
     {
        set blk_elem_addr_obj $block_element::($blk_elem_obj,elem_add_obj)
        set blk_elem_addr $address::($blk_elem_addr_obj,add_name)
        foreach address_name $base_addr_list \
        {
          if {[string compare $address_name $blk_elem_addr] == 0}\
          {
             set blk_elem_flag 1
             return $blk_elem_flag
          }
        }
     }
   }
   return $blk_elem_flag
}

#=========================================================================
proc UI_PB_com_DisplyErrorMssg { ELEM_ADDR_NAME } {
#=========================================================================
  upvar $ELEM_ADDR_NAME elem_addr_name

  tk_messageBox -parent [UI_PB_com_AskActiveWindow] -type ok -icon error \
          -message "An element of the selected Address exists \
                    in the Block Template"
}

#=========================================================================
proc UI_PB_com_CreateTextEntry { PAGE_OBJ NEW_ELEM_OBJ label_name} {
#=========================================================================
  upvar $PAGE_OBJ page_obj
  upvar $NEW_ELEM_OBJ new_elem_obj
  global paOption
  global elem_text_var
  global text_dial_respose
  set text_dial_respose 0

  set bot_canvas $Page::($page_obj,bot_canvas)
  set elem_text_var $block_element::($new_elem_obj,elem_mom_variable)


  set win [toplevel $bot_canvas.txtent]
##  wm title $win " $label_name Entry " 

  UI_PB_com_CreateTransientWindow $win "$label_name Entry" "" "" ""

  # grabs the window
##    grab set $win




  set text_frm [frame $win.frame]

  set box [tixButtonBox $win.box \
             -orientation horizontal \
             -bd 2 \
             -relief sunken \
             -bg yellow]
   pack $text_frm -side top -fill both -expand yes
   pack $box -side bottom -fill x -padx 3 -pady 3

  label $text_frm.lab -text $label_name -anchor w

  entry $text_frm.ent -textvariable elem_text_var -width 40 -relief sunken

  pack $text_frm.lab -side left -fill both -padx 10 -pady 10
  pack $text_frm.ent -side right -fill both -padx 10 -pady 10

  focus $text_frm.ent
  $text_frm.ent select range 0 end

  # Adds the action buttons
    $box config -bg $paOption(butt_bg)
    $box add can -text Cancel -width 10 -bg $paOption(app_butt_bg) \
               -command "UI_PB_com_CancelTextElem $win $page_obj $new_elem_obj"
    $box add ok -text Ok -width 10 -bg $paOption(app_butt_bg) \
               -command "UI_PB_com_UpdateTextElem $win $page_obj $new_elem_obj"

    bind $text_frm.ent <Return> "UI_PB_com_UpdateTextElem $win $page_obj \
                                 $new_elem_obj"
}

#=========================================================================
proc UI_PB_com_CancelTextElem { win page_obj elem_obj } {
#=========================================================================
  global text_dial_respose
 
  if { $text_dial_respose == 0 } \
  {
    set block_element::($elem_obj,elem_mom_variable) "000"
    set text_dial_respose "cancel"
  }

  destroy $win
}

#=========================================================================
proc UI_PB_com_UpdateTextElem { win page_obj elem_obj } {
#=========================================================================
  global elem_text_var
  global text_dial_respose

  set block_element::($elem_obj,elem_mom_variable) $elem_text_var
  set text_dial_respose "ok"

  destroy $win
}

#=========================================================================
proc UI_PB_com_RetIntFromVal { value } {
#=========================================================================
  set int_val [tixGetInt -nocomplain $value]

  if { $int_val } \
  {
    return $int_val
  } else \
  {
    return 0
  }
}

#=========================================================================
proc UI_PB_com_RetFloatFromVal { value } {
#=========================================================================
  set int_val [tixGetInt -nocomplain $value]

  if { $int_val } \
  {
    if { [string first "." $value] } \
    {
       return $value
    } else \
    {
       return $int_val
    }
  } else \
  {
    return 0.0
  }
}

#=========================================================================
proc UI_PB_com_RetValByDataType { value data_type } {
#=========================================================================

  switch $data_type \
  {
     "i"  {
             set int_val [UI_PB_com_RetIntFromVal $value]
             return $int_val
          }

     "f"  {
             set float_val [UI_PB_com_RetFloatFromVal $value] 
             return $float_val
          }

     "s"  {
             return $value
          }
  }
}

#=========================================================================
proc UI_PB_com_RetAddrOfMOMSysVar { MOM_VAR } {
#=========================================================================
  upvar $MOM_VAR mom_var

  PB_adr_RetAddressObjList add_obj_list

  set mom_var_add 0
  foreach add_obj $add_obj_list \
  {
     address::readvalue $add_obj add_obj_attr
     PB_int_RetMOMVarAsscAddress add_obj_attr(0) add_mom_var_list
     if { [lsearch $add_mom_var_list $mom_var] != -1 } \
     {
       set mom_var_add $add_obj
       break
     }
  }
  return $mom_var_add
}

#=========================================================================
proc UI_PB_com_RetSysVarDataType { MOM_VAR } {
#=========================================================================
  upvar $MOM_VAR mom_var

  set add_obj [UI_PB_com_RetAddrOfMOMSysVar mom_var]

  if { $add_obj } \
  {
     address::readvalue $add_obj add_obj_attr
     format::readvalue $add_obj_attr(1) fmt_obj_attr

     switch $fmt_obj_attr(1) \
     {
        "Integer"     {
                         set data_type i
                      }

        "Real Number" {
                         set data_type f
                      }

        "Text String" {
                         set data_type s
                      }
     }
  } else \
  {
     set data_type s
  }
  return $data_type
}

#=========================================================================
proc UI_PB_com_CheckDuplicatChar { widget key_type } {
#=========================================================================
  set entry_val [$widget get]

  switch $key_type \
  {
     "plus"   {
                 if { [$widget select present] } \
                 {
                    set sel_f [$widget index sel.first]
                    set sel_s [$widget index sel.last]
                    if { $sel_f == 0 || $sel_s == 0} \
                    {
                      return 1
                    }
                 } elseif { [$widget index insert] == 0 && \
                            [string first "+" $entry_val] == -1 &&
                            [string first "-" $entry_val] == -1} \
                 {
                      return 1
                 } else \
                 {
                      return 0
                 }
              }

     "minus"  {
                 if { [$widget select present] } \
                 {
                    set sel_f [$widget index sel.first]
                    set sel_s [$widget index sel.last]
                    if { $sel_f == 0 || $sel_s == 0} \
                    {
                      return 1
                    }
                 } elseif { [$widget index insert] == 0 && \
                            [string first "+" $entry_val] == -1 &&
                            [string first "-" $entry_val] == -1} \
                 {
                      return 1
                 } else \
                 {
                      return 0
                 }
              }

     "period" {
                 set flag [string first "." $entry_val]
                 if {$flag != -1} \
                 {
                   return 0
                 } else \
                 {
                   return 1
                 }
              }

      default {
                  return 1
              }
  }
}

#=========================================================================
# This procedure validates the data of an entry, based upon the data type.
#  i  -  Integer, f  - float,  and s - string 
# If the input key doesn't match the data type, it disables the entry ..
# upon pressing the key and enables it after release the key ..
#=========================================================================
proc UI_PB_com_ValidateDataOfEntry { widget key data_type } {
#=========================================================================
  set disable_flag 0
  switch $data_type \
  {
     "i" {
           if { $key >= 0 && $key <= 9 || $key == "plus" || \
                $key  == "minus" || $key == "BackSpace" || \
                $key == "Tab" || $key == "Shift_R"} \
           {
              set disable_flag [UI_PB_com_CheckDuplicatChar $widget $key]
           }
         }

     "f" {
           if { $key >= 0 && $key <= 9 || $key == "period" || \
                $key == "plus" || $key  == "minus" || \
                $key == "BackSpace" || $key == "Tab" || $key == "Shift_R"} \
           {
              set disable_flag [UI_PB_com_CheckDuplicatChar $widget $key]
           }
         }

     "s" {
              set disable_flag 1
         }

  }

  if { !$disable_flag } \
  {
      $widget config -state disabled
  }
}
