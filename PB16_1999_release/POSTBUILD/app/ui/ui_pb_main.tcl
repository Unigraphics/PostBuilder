################################################################################
# **************                                                               #
# ui_pb_main.tcl                                                               #
# **************                                                               #
#  Entry program to Postino                                                    #
#------------------------------------------------------------------------------#
#                                                                              #
# Copyright (c) 1999, Unigraphics Solutions Inc.                               #
#                                                                              #
# See the file "license.terms" for information on usage and redistribution     #
# of this file, and for a DISCLAIMER OF ALL WARRANTIES.                        #
#                                                                              #
#                                                                              #
# Description                                                                  #
#     This file contains all the main procedures of post builder.              #
#                                                                              #
#                                                                              #
# Revisions                                                                    #
#                                                                              #
#   Date        Who       Reason                                               #
# 01-feb-1999   gsl   Initial                                                  #
# 07-Apr-1999   mnb   Changed bitmap names                                     #
# 19-May-1999   gsl   Added more options to "Help" pulldown menu.              #
# 20-May-1999   gsl   Renamed from "post_builder.tcl".                         #
# 27-May-1999   gsl   Added Help icons.                                        #
# 02-Jun-1999   mnb   V16 Code Integration                                     #
# 03-Jun-1999   gsl   Added Ballon & Context Sensitive Help icons.             #
# 10-Jun-1999   mnb   source pb_proc_parser.tcl, to display event procedure    #
# 14-Jun-1999   mnb   Attached Tab procedure to Preview page                   #
# 15-Jun-1999   mnb   Removed puts                                             #
# 29-Jun-1999   mnb   Made pb_book as global variable                          #
# 26-Jul-1999   gsl   Move UI_PB_main_menu to post_builder.c.                  #
# 07-Sep-1999   mnb   Updates the current page data .. whenever save is        #
#                     selected                                                 #
# 06-Oct-1999   gsl   Added Context Sensitive Help mechanism.                  #
# 18-Oct-1999   gsl   Minor changes                                            #
# 22-Oct-1999   gsl   Added use of UI_PB_com_CreateTransientWinow.             #
# 17-Nov-1999   gsl   Submitted for phase-22.                                  #
# 23-Nov-1999   gsl   Submitted for phase-22.                                  #
#                                                                              #
# $HISTORY$                                                                    #
#                                                                              #
################################################################################
global env
global tixOption

#+++++++++++++++++++++++++++++++++++++++++++++++++++
# Various attributes that can be set in PostBuilder
#+++++++++++++++++++++++++++++++++++++++++++++++++++
  tix addbitmapdir [tixFSJoin $env(PB_HOME) images]

  set paOption(title_bg)       darkSeaGreen3
  set paOption(title_fg)       lightYellow
  set paOption(table_bg)       lightSkyBlue
  set paOption(app_bg)         #9676a2 ;# #b87888
  set paOption(tree_bg)        lightYellow ;#fefae0 Linen SeaShell Ivory MintCream
  set paOption(butt_bg)        Gold1 ;# #f0da1c
  set paOption(app_butt_bg)    #d0c690 ;# #a8d464 #b0868e
  set paOption(can_bg)         #ace8d2
  set paOption(can_trough_bg)  #7cdabc
  set paOption(trough_bg)      #f0da1c
  set paOption(trough_wd)      12
  set paOption(file)           [tix getimage pb_textfile]
  set paOption(folder)         [tix getimage pb_folder]
  set paOption(format)         [tix getimage pb_format]
  set paOption(address)        [tix getimage pb_address]
  set paOption(popup)          #e3e3e3
  set paOption(seq_bg)         yellow ;#Aquamarine1 AntiqueWhite CadetBlue1 #8ceeb6 #f8de58
  set paOption(seq_fg)         blue3 ;#Purple4 NavyBlue Purple3
  set paOption(event)          skyBlue3
  set paOption(cell_color)     paleTurquoise
  set paOption(active_color)   burlyWood1
  set paOption(focus)          lightYellow
  set paOption(balloon)        yellow
  set paOption(select_clr)     orange ;# YellowGreen PaleGreen1 Orchid
  set paOption(menu_bar_bg)    lightBlue ;# Aquamarine1
  set paOption(text)           lightSkyBlue
  set paOption(disabled_fg)       gray
  set paOption(tree_disabled_fg)  lightGray

  option add *Menu.background        gray95
  option add *Menu.activeBackground  blue
  option add *Menu.activeForeground  yellow
  option add *Menu.selectColor       $paOption(select_clr)
  option add *Menu.activeBorderWidth 0
  option add *Menu.font              {helvetica 10 bold}
  
  option add *Button.cursor                   hand2
  option add *Button.activeBackground         $paOption(focus)
  option add *Button.activeForeground         black
  option add *Button.disabledForeground       $paOption(disabled_fg)
  option add *Menubutton.cursor               hand2
  option add *Menubutton.activeBackground     $paOption(focus)
  option add *Checkbutton.cursor              hand2
  option add *Checkbutton.activeBackground    $paOption(focus)
  option add *Checkbutton.disabledForeground  $paOption(disabled_fg)
  option add *Checkbutton.selectColor         $paOption(select_clr)
  option add *Radiobutton.cursor              hand2
  option add *Radiobutton.activeBackground    $paOption(focus)
  option add *Radiobutton.disabledForeground  $paOption(disabled_fg)
  option add *Radiobutton.selectColor         $paOption(select_clr)
  option add *TixOptionMenu.cursor            hand2
  
  option add *TixNoteBook.tagPadX       6
  option add *TixNoteBook.tagPadY       4
  option add *TixNoteBook.borderWidth   2
  option add *TixNoteBook.font          {helvetica 14 bold}

  option add *TixLabelFrame.label.font  $tixOption(italic_font)


source $env(PB_DIR)/ui/ui_pb_tclindex.tcl
source $env(PB_DIR)/ui/ui_pb_resource.tcl
source $env(PB_DIR)/dbase/pb_file.tcl
##source $env(PB_DIR)/dbase/pb_mdfa.tcl
source $env(PB_DIR)/dbase/pb_proc_parser.tcl
source $env(PB_DIR)/ui/ui_pb_file.tcl
source $env(PB_DIR)/ui/ui_pb_class.tcl
source $env(PB_DIR)/ui/ui_pb_method.tcl
source $env(PB_DIR)/ui/ui_pb_sequence.tcl
source $env(PB_DIR)/ui/ui_pb_toolpath.tcl
source $env(PB_DIR)/ui/ui_pb_common.tcl
source $env(PB_DIR)/ui/ui_pb_balloon.tcl
source $env(PB_DIR)/ui/ui_pb_context_help.tcl

#===============================================================================
proc UI_PB_main {w} {
#===============================================================================
  global auto_path gPB_dir
  global paOption tixOption
  global gPB

   #**************************************
   # Initialize "my" window manager stuff
   #**************************************
    set gPB(active_window_list)   {}
    set gPB(active_window)        ""
    set gPB(top_window)           ""
    set gPB(top_window).new       ""
    set gPB(top_window).open      ""
    set gPB(main_window)          ""
    set gPB(main_window_disabled) 0
    set gPB(toplevel_list)        {}

   #***************************************************************
   # Define some font styles
   #---------------------------------------------------------------
   #   Following attributes are available to the Display Items.
   #   However, most of them will be overwritten by the properties
   #   of the HList.  Therefore, no need to specify them here.
   #
   #     activeBackground        activeForeground
   #     anchor                  background
   #     disabledBackground      disabledForeground
   #     foreground              font
   #     justify                 padX
   #     padY                    selectBackground
   #     selectForeground        wrapLength
   #
   #***************************************************************
    set gPB(font_style_normal) [tixDisplayStyle imagetext \
                -bg $paOption(tree_bg) -padx 4 -pady 1 -font $tixOption(font) \
                -selectforeground blue]

    set gPB(font_style_bold) [tixDisplayStyle imagetext \
                -bg $paOption(tree_bg) -padx 4 -pady 2 -font $tixOption(bold_font) \
                -selectforeground blue]

    set gPB(font_style_normal_gray) [tixDisplayStyle imagetext \
                -fg $paOption(tree_disabled_fg) \
                -bg $paOption(tree_bg) \
                -padx 4 -pady 1 -font $tixOption(font)]

    set gPB(font_style_bold_gray) [tixDisplayStyle imagetext \
                -fg $paOption(tree_disabled_fg) \
                -bg $paOption(tree_bg) \
                -padx 4 -pady 2 -font $tixOption(bold_font)]


    if ![info exists gPB_dir] {
	# Initialize the auto_path and the bitmap directory. The gPB_dir
	# variable would be already set by the test program, if we are
	# running in the self test more
	#
	set script [info script]
	if {$script != {}} {
	    set gPB_dir [file dirname $script]
	} else {
	    set gPB_dir [pwd]
	}

	set gPB_dir [tixFSAbsPath $gPB_dir]
    }

    lappend auto_path $gPB_dir
    tix addbitmapdir [tixFSJoin $gPB_dir bitmaps]

    toplevel     $w
    wm title     $w "Unigraphics Post Builder"
    wm geometry  $w 1000x110+100+20
    wm resizable $w 0 0
    wm protocol  $w WM_DELETE_WINDOW "UI_PB_ExitPost"

    $w config -bg $paOption(app_bg)

    set gPB(top_window) $w
    UI_PB_com_ClaimActiveWindow $w

    set main_menu [UI_PB__main_menu   $w]
    set status    [UI_PB__main_status $w]

   # Save away main menu id to be used in Context Help
    set gPB(main_menu)  $main_menu

    pack $main_menu -side top    -fill x
    pack $status    -side bottom -fill x

   # Register Context Sensitive Help for menu-bar items
    set mb $gPB(main_menu_bar)
    set gPB(c_help,$mb.file)	"main,file"
    set gPB(c_help,$mb.option)	"main,options"
    set gPB(c_help,$mb.help)	"main,help"

   # Register Context Sensitive Help for tool palette items
    set gPB(c_help,[$main_menu.tool subwidget new])	"tool,new"
    set gPB(c_help,[$main_menu.tool subwidget open])	"tool,open"
    set gPB(c_help,[$main_menu.tool subwidget save])	"tool,save"
    set gPB(c_help,[$main_menu.help subwidget bal])	"tool,bal"
    set gPB(c_help,[$main_menu.help subwidget wtd])	"tool,what"
    set gPB(c_help,[$main_menu.help subwidget dia])	"tool,dialog"
    set gPB(c_help,[$main_menu.help subwidget man])	"tool,manual"

   # Configures the file options
    $mb.file.m entryconfigure 4 -state disabled
    $mb.file.m entryconfigure 5 -state disabled
    $mb.file.m entryconfigure 6 -state disabled

   # Configures the tixselect icons
    [$main_menu.tool subwidget save] config -state disabled

   # Find active Entry widget background color
    if ![info exists gPB(entry_color)] \
    {
      entry .xxxentry
      set gPB(entry_color) [lindex [.xxxentry config -bg] end]
      tixDestroy .xxxentry
    }
}

#-------------------------------------------------------------------------------
proc CB_HelpCmd { w opt } {
#-------------------------------------------------------------------------------
 global gPB

 # Keep first 3 buttons always popped to behave like action buttons
  switch -exact -- $w \
  {
    man -
    dia -
    wtd {
      set idx [lsearch $gPB(help_sel_var) $w]
      if {$idx >= 0} {
        set gPB(help_sel_var) [lreplace $gPB(help_sel_var) $idx $idx]
      } else {
       # To prevent CB from being called twice
       # due to button's value changed twice.
        return
      }
    }
  }

 # Take action
  switch -exact -- $w \
  {
    man { HelpCmd_man $w }
    dia { HelpCmd_dia $w }
    wtd { HelpCmd_wtd $w }
    bal { HelpCmd_bal $w }
    inf { HelpCmd_inf $w }
  }
}

#-------------------------------------------------------------------------------
proc HelpCmd_inf { w } {
#-------------------------------------------------------------------------------
  global gPB

   if {[lsearch $gPB(help_sel_var) $w] >= 0} {
     set gPB(use_info) 1
   } else {
     set gPB(use_info) 0
   }

   UI_PB_chelp_SetContextHelp
}

#-------------------------------------------------------------------------------
proc HelpCmd_bal { w } {
#-------------------------------------------------------------------------------
  global gPB

   if {[lsearch $gPB(help_sel_var) $w] >= 0} {
     set gPB(use_bal) 1
   } else {
     set gPB(use_bal) 0
   }

   SetBalloonHelp
}

#-------------------------------------------------------------------------------
proc HelpCmd_wtd { w } {
#-------------------------------------------------------------------------------
return [tk_messageBox -parent [UI_PB_com_AskActiveWindow] -type ok -icon error \
                      -message "Pending implementation"]
}

#-------------------------------------------------------------------------------
proc HelpCmd_dia { w } {
#-------------------------------------------------------------------------------
return [tk_messageBox -parent [UI_PB_com_AskActiveWindow] -type ok -icon error \
                      -message "Pending implementation"]
}

#-------------------------------------------------------------------------------
proc HelpCmd_man { w } {
#-------------------------------------------------------------------------------
return [tk_messageBox -parent [UI_PB_com_AskActiveWindow] -type ok -icon error \
                      -message "Pending implementation"]
}

#-------------------------------------------------------------------------------
proc SetBalloonHelp {} {
#-------------------------------------------------------------------------------
  global gPB
  global gPB_use_balloons gPB_help_tips

   set gPB_use_balloons $gPB(use_bal)
   set gPB_help_tips(state) $gPB(use_bal)

  # Reset Balloon Tip button
   set idx [lsearch $gPB(help_sel_var) bal]

   if { $gPB(use_bal) && $idx >= 0 } \
   {
     return
   } elseif { !$gPB(use_bal) && $idx < 0 } \
   {
     return
   } else \
   {
    # Set the button
     if { $gPB(use_bal) } \
     {
       set gPB(help_sel_var) [linsert $gPB(help_sel_var) 0 bal]
     } else \
     {
       set gPB(help_sel_var) [lreplace $gPB(help_sel_var) $idx $idx]
     }
   }
}

#-------------------------------------------------------------------------------
proc SetContextHelp {} {
#-------------------------------------------------------------------------------
  global gPB

  # Reset Context Help button
   set idx [lsearch $gPB(help_sel_var) inf]

   if { $gPB(use_info) && $idx >= 0 } \
   {
puts "Context Help On"

    # Retrive toplevels currently available
    #
     for {set i 0} {$i < [llength $gPB(active_window_list)]} {incr i} \
     {
       set tw [lindex $gPB(active_window_list) $i]

puts "---------------------"
puts "Toplevel found -> $tw"
puts "---------------------"

       set wlist [tixDescendants $tw]
       for {set j 0} {$j < [llength $wlist]} {incr j} \
       {
         set witem [lindex $wlist $j]

##puts "Widget : $witem"

         if ![catch {set cur [$witem config -cursor]} result] {

          #============================================================
          # Remember to leave the Scrollers alone!
          #============================================================

          #============================================================
          # We should change cursor only for those who have registered
          # the callback for context sensitive help
          #============================================================
           if [info exists gPB(c_help,$witem)] {
##puts "  with csh = $witem"
#<gsl>           set gPB(c_help,cursor,$witem) [lindex $cur end]
#<gsl>           $witem config -cursor question_arrow
#<gsl>         set gPB(c_help,b1,$witem) [bind $witem <1>]
#<gsl>         bind $witem <1> "PB_context_help $w \[winfo -displayof $w containing %X %Y]"
#<gsl>         grab $w
           }
         }
       }
     }

return [tk_messageBox -parent [UI_PB_com_AskActiveWindow] -type ok -icon error \
                      -message "Pending implementation"]
   } elseif { !$gPB(use_info) && $idx < 0 } \
   {
puts "Context Help Off"
     set wlist [tixDescendants $gPB(top_window)]
     for {set i 0} {$i < [llength $wlist]} {incr i} \
     {
        set witem [lindex $wlist $i]
        if [info exists gPB(c_help,cursor,$witem)] {
          $witem config -cursor $gPB(c_help,cursor,$witem)
        }
     }
     return
   }
}

#===============================================================================
proc UI_PB_ExitPost { args } {
#===============================================================================
  global gPB

  if { [info exists gPB(main_window)] && $gPB(main_window) != "" } \
  {
   # Calls the post close proceuder
    set choice [UI_PB_ClosePost]
    if { $choice == "yes" || $choice == "no" } \
    {
      exit
    }
  } else \
  {
    exit
  }
}

#===============================================================================
proc UI_PB_save_a_post { args } {
#===============================================================================
 global gPB

  # Updates the current page objects
   UI_PB_UpdateCurrentBookPageAttr gPB(book)

  # Outputs the Def & TCL files
   PB_CreateDefTclFiles

  set gPB(session) EDIT
}

#===============================================================================
proc UI_PB_ClosePost {args} {
#===============================================================================
 global gPB

  set choice [tk_messageBox -parent $gPB(active_window) -type yesnocancel \
              -icon question -message "Save your changes before closing\
                                       the Post in progress"]

  if { $choice == "yes" } \
  {
   # Saves the post
    UI_PB_SavePost

   # Deletes the post widgets & objects
    if { $gPB(session) == "EDIT" } \
    {
     # Delete all toplevel windows
     #
      UI_PB_com_DeleteTopLevelWindows

    } else \
    {
return
    }
  } elseif { $choice == "no" } \
  {
   # Delete all toplevel windows
   #
    UI_PB_com_DeleteTopLevelWindows
  }

return $choice
}

#-------------------------------------------------------------------------------
proc DeletePostWidgets { } {
#-------------------------------------------------------------------------------
  global gPB

   # Clean up tixGrid
    if [info exists gPB(tix_grid)] \
    {
      global addr_app_text

      PB_int_AddrSummaryAttr addr_name_list addr_app_text addr_desc_arr
      set no_addr [llength $addr_name_list]
      for {set count 0} {$count < [expr $no_addr + 1]} {incr count} \
      {
        $gPB(tix_grid) delete row $count
      }
      unset gPB(tix_grid)
    }

   # Activates the file menu options
    UI_PB_EnableFileOptions

   #===================================
   # We MUST delete all Post objects!!!
   #===================================
}

#===============================================================================
proc UI_PB_main_window {args} {
#===============================================================================
 global paOption
 global gPB


 # Fresh start a main window...
  if { [info exists gPB(main_window)] } {
    unset gPB(main_window)
  }

 # Create main window
  set mw [toplevel $gPB(top_window).main]
  UI_PB_com_CreateTransientWindow $mw "Post Processor" "1000x700+100+165" \
                                  "UI_PB_ClosePost" "DeletePostWidgets" 0

  set gPB(main_window) $mw

  set ww [tixScrolledWindow $mw.scr]
  [$ww subwidget hsb] config -troughcolor $paOption(trough_bg) \
                              -width       $paOption(trough_wd)
  [$ww subwidget vsb] config -troughcolor $paOption(trough_bg) \
                              -width       $paOption(trough_wd)
  pack $ww -expand yes -fill both -padx 3 -pady 3
  set sw [$ww subwidget window]

  set w [tixNoteBook $sw.nb -ipadx 3 -ipady 3]
  [$w subwidget nbframe] config -backpagecolor $paOption(app_bg) \
                                -tabpadx 0 -tabpady 0
  bind [$w subwidget nbframe] <Button-1> "UI_PB_NoteBookTabBinding $w %x %y"

  set gPB(book) [new Book w]

  Book::CreatePage $gPB(book) mac "Machine Tool" pb_machine \
                   UI_PB_MachineTool UI_PB_MachToolTab
 
  Book::CreatePage $gPB(book) pro "Program & Tool Path" pb_prog \
                   UI_PB_ProgTpth UI_PB_ProgTpthTab

  Book::CreatePage $gPB(book) def "N/C Data Definitions" pb_mcd \
                   UI_PB_Def UI_PB_DefTab

  Book::CreatePage $gPB(book) lis "Listing File" pb_listing \
                   UI_PB_List UI_PB_ListTab

  Book::CreatePage $gPB(book) pre "Files Preview" pb_output \
                   UI_PB_Preview UI_PB_PreviewTab

  Book::CreatePage $gPB(book) adv "Post Advisor" pb_advisor \
                   UI_PB_Advisor UI_PB_AdvisorTab

  set Book::($gPB(book),x_def_tab_img) 0
  set Book::($gPB(book),current_tab) -1

  pack $w -expand yes -fill both
}

#===============================================================================
proc UI_PB_NoteBookTabBinding { book_id x y } {
#===============================================================================
    global machTree

    if { [info exists machTree] && ([UI_PB__MachToolValidation] == "bad") } {
        return
    } else {
        tixNoteBook:MouseDown $book_id $x $y
    }
}

#===============================================================================
proc UI_PB_MachToolTab { book_id page_img book_obj } {
#===============================================================================
  CB_nb_def $book_id $page_img $book_obj
  UI_PB_DeleteBookAttr book_obj
  set Book::($book_obj,current_tab) 0
  UI_PB_UpdateBookAttr book_obj
}

#===============================================================================
proc UI_PB_ProgTpthTab { book_id page_img book_obj } {
#===============================================================================
  CB_nb_def $book_id $page_img $book_obj
  UI_PB_DeleteBookAttr book_obj
  set Book::($book_obj,current_tab) 1
  UI_PB_UpdateBookAttr book_obj
}

#===============================================================================
proc UI_PB_DefTab { book_id page_img book_obj } {
#===============================================================================
  CB_nb_def $book_id $page_img $book_obj
  UI_PB_DeleteBookAttr book_obj
  set Book::($book_obj,current_tab) 2
  UI_PB_UpdateBookAttr book_obj
}

#===============================================================================
proc UI_PB_ListTab { book_id page_img book_obj } {
#===============================================================================
  CB_nb_def $book_id $page_img $book_obj
  UI_PB_DeleteBookAttr book_obj
  set Book::($book_obj,current_tab) 3
  UI_PB_UpdateBookAttr book_obj
}

#===============================================================================
proc UI_PB_PreviewTab { book_id page_img book_obj } {
#===============================================================================
  CB_nb_def $book_id $page_img $book_obj
  UI_PB_DeleteBookAttr book_obj
  set Book::($book_obj,current_tab) 4
  UI_PB_UpdateBookAttr book_obj
}

#===============================================================================
proc UI_PB_AdvisorTab { book_id page_img book_obj } {
#===============================================================================
  CB_nb_def $book_id $page_img $book_obj
  UI_PB_DeleteBookAttr book_obj
  set Book::($book_obj,current_tab) 5
  UI_PB_UpdateBookAttr book_obj
}

#===============================================================================
proc UI_PB__MachToolValidation {} {
#===============================================================================
  global machTree axisoption

  if { [info exists machTree] } {
      switch -- $axisoption {
          "3" {
              set axis_type 3
          }
          "4H" -
          "4T" {
              set axis_type 4
          }
          "5TT" -
          "5HH" -
          "5HT" {
              set axis_type 5
          }
      }
      return [ValidateMachObjAttr $machTree $axis_type]
  }
}

#===============================================================================
proc UI_PB_DeleteBookAttr { BOOK_OBJ } {
#===============================================================================
  upvar $BOOK_OBJ book_obj

  switch -exact -- $Book::($book_obj,current_tab) \
  {
      0 {
           set page_obj [lindex $Book::($book_obj,page_obj_list) 0]
           global mom_kin_var
           PB_int_UpdateKinVar mom_kin_var
        }
      1 {
           set page_obj [lindex $Book::($book_obj,page_obj_list) 1]
           if {[info exists Page::($page_obj,book_obj)]} \
           {
             set page_book_obj $Page::($page_obj,book_obj)
             UI_PB_progtpth_DeleteTabAtt page_book_obj
           }
        }
      2 {
           set page_obj [lindex $Book::($book_obj,page_obj_list) 2]
           if {[info exists Page::($page_obj,book_obj)]} \
           {
             set page_book_obj $Page::($page_obj,book_obj)
             UI_PB_Def_UpdatePrevTabElems page_book_obj
           }
        }
      3 {
           set page_obj [lindex $Book::($book_obj,page_obj_list) 3]
        }
      4 {
           set page_obj [lindex $Book::($book_obj,page_obj_list) 4]
        }
      5 {
           set page_obj [lindex $Book::($book_obj,page_obj_list) 5]
        }
  }
}

#===============================================================================
proc UI_PB_UpdateBookAttr { BOOK_OBJ } {
#===============================================================================
  upvar $BOOK_OBJ book_obj

  switch -exact -- $Book::($book_obj,current_tab) \
  {
      0 {
           set page_obj [lindex $Book::($book_obj,page_obj_list) 0]
           UI_PB_mach_CreateTabAttr $page_obj
        }
      1 {
           set page_obj [lindex $Book::($book_obj,page_obj_list) 1]
           if {[info exists Page::($page_obj,book_obj)]} \
           {
             set page_book_obj $Page::($page_obj,book_obj)
             UI_PB_progtpth_CreateTabAttr page_book_obj
           }
        }
      2 {
           set page_obj [lindex $Book::($book_obj,page_obj_list) 2]
           if {[info exists Page::($page_obj,book_obj)]} \
           {
             set page_book_obj $Page::($page_obj,book_obj)
             UI_PB_Def_CreateTabAttr page_book_obj
           }
        }
      3 {
           set page_obj [lindex $Book::($book_obj,page_obj_list) 3]
        }
      4 {
           set page_obj [lindex $Book::($book_obj,page_obj_list) 4]
           if {[info exists Page::($page_obj,book_obj)]} \
           {
              set page_book_obj $Page::($page_obj,book_obj)
              UI_PB_prv_CreateTabAttr page_book_obj
           }
        }
      5 {
           set page_obj [lindex $Book::($book_obj,page_obj_list) 5]
        }
  }
}

#===============================================================================
proc UI_PB_UpdateProgTpthBook { PRG_BOOK } {
#===============================================================================
  upvar $PRG_BOOK prg_book

  switch -exact -- $Book::($prg_book,current_tab) \
  {
     0 { 
          set page_obj [lindex $Book::($prg_book,page_obj_list) 0]
          UI_PB_evt_GetSequenceIndex page_obj seq_index
          set seq_obj [lindex $Page::($page_obj,seq_obj_list) $seq_index]
       }

     1 {
          set page_obj [lindex $Book::($prg_book,page_obj_list) 1]
          UI_PB_gcd_ApplyGcodeData $prg_book $page_obj
       }

     2 {
          set page_obj [lindex $Book::($prg_book,page_obj_list) 2]
          UI_PB_gcd_ApplyMcodeData $prg_book $page_obj
       }

     3 {
          set page_obj [lindex $Book::($prg_book,page_obj_list) 3]
          UI_PB_ads_UpdateAddressObjects
       }

     4 {
          set page_obj [lindex $Book::($prg_book,page_obj_list) 4]
          UI_PB_mseq_ApplyMastSeq page_obj
       }
  }
}

#===============================================================================
proc UI_PB_UpdateNCDefBoock { DEF_BOOK } {
#===============================================================================
  upvar $DEF_BOOK def_book

  switch -exact -- $Book::($def_book,current_tab) \
  {
     0  { 
           set page_obj [lindex $Book::($def_book,page_obj_list) 0]
           UI_PB_blk_BlkApplyCallBack $page_obj
        }

     1  {
           set page_obj [lindex $Book::($def_book,page_obj_list) 1]
           UI_PB_addr_ApplyCurrentAddrData page_obj
        }

     2  {
           set page_obj [lindex $Book::($def_book,page_obj_list) 2]
           UI_PB_fmt_ApplyCurrentFmtData page_obj
        }

     3  {
           set page_obj [lindex $Book::($def_book,page_obj_list) 3]
           UI_PB_oth_ApplyOtherAttr
        }
  }
}

#===============================================================================
proc UI_PB_UpdateCurrentBookPageAttr { PB_BOOK } {
#===============================================================================
  upvar $PB_BOOK book

  switch -exact -- $Book::($book,current_tab) \
  {
     0  {
           set page_obj [lindex $Book::($book,page_obj_list) 0]
           global mom_kin_var
           PB_int_UpdateKinVar mom_kin_var
        }

     1  {
           set page_obj [lindex $Book::($book,page_obj_list) 1]
           if {[info exists Page::($page_obj,book_obj)]} \
           {
             set page_book_obj $Page::($page_obj,book_obj)
             UI_PB_UpdateProgTpthBook page_book_obj 
           }
        }

     2  {
           set page_obj [lindex $Book::($book,page_obj_list) 2]
           if {[info exists Page::($page_obj,book_obj)]} \
           {
             set page_book_obj $Page::($page_obj,book_obj)
             UI_PB_UpdateNCDefBoock page_book_obj
           }
        }

     3  {
           set page_obj [lindex $Book::($book,page_obj_list) 3]
        }

     4  {
           set page_obj [lindex $Book::($book,page_obj_list) 4]
           if {[info exists Page::($page_obj,book_obj)]} \
           {
              set page_book_obj $Page::($page_obj,book_obj)
           }
        }

     5  {
           set page_obj [lindex $Book::($book,page_obj_list) 5]
        }
  }
}

#-------------------------------------------------------------------------------
proc UI_PB__main_status {top} {
#-------------------------------------------------------------------------------
  global gPB

  set w [frame $top.f3 -relief raised -bd 1]
  set gPB(statusbar) \
	[label $w.status -font {helvetica 12 bold} -bg Black -fg Gold1 \
	 -relief sunken -bd 1 -textvariable gPB(menu_bar_status)]

  set gPB(menu_bar_status) "Thank you for using UG Post Builder"

  tixForm $gPB(statusbar) -padx 3 -pady 3 -left 0 -right %70
  return $w
}

