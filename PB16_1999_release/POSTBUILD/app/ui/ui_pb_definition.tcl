#==============================================================================
#                    UI_PB_DEFINITION.TCL
#==============================================================================
##############################################################################
# Description                                                                #
#     This file contains all functions dealing with the creation of          #
#     ui elements for Definition Book.                                       #
#                                                                            #
# Revisions                                                                  #
#                                                                            #
#   Date        Who       Reason                                             #
# 01-feb-1999   mnb       Initial                                            #
# 02-Jun-1999   mnb       Code Integration                                   #
# 14-Jun-1999   mnb       Attached procedure to Other's page Tab             #
# 21-Sep-1999   mnb       Changed Address Tab Procedure, to recreate the     #
#                         Address page tree elements.                        #
# 03-Nov-1999   gsl       Added UI_PB_def_DisableWindow &                    #
#                               UI_PB_def_EnableWindow.                      #
# 17-Nov-1999   gsl       Submitted for phase-22.                            #
#                                                                            #
# $HISTORY$                                                                  #
#                                                                            #
##############################################################################

#==============================================================================
proc UI_PB_def_DisableWindow { CHAP } {
#==============================================================================
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

   #***********************
   # Get tabbed pages info
   #***********************
    set page_tab $Book::($sect,current_tab)
    set page_obj [lindex $Book::($sect,page_obj_list) $page_tab]

   #***************************
   # Retrieve some font styles
   #***************************
    set sty_n  $gPB(font_style_normal)
    set sty_b  $gPB(font_style_bold)
    set sty_ng $gPB(font_style_normal_gray)
    set sty_bg $gPB(font_style_bold_gray)

   # Disable notebook tabs
    $sect_id pageconfig blk -state disabled
    $sect_id pageconfig adr -state disabled
    $sect_id pageconfig fmt -state disabled
    $sect_id pageconfig ele -state disabled

   # Disable tree items on tabbed pages
    switch $page_tab \
    {
      0 {  ;# BLOCK

        set t $Page::($page_obj,tree)
        set h [$t subwidget hlist]

       # Disable everything first, then enable the selected item.
      }
      1 {  ;# ADDRESS

        set t $Page::($page_obj,tree)
        set h [$t subwidget hlist]

       # Disable everything first, then enable the selected item.
      }
      2 {  ;# FORMAT

        set t $Page::($page_obj,tree)
        set h [$t subwidget hlist]

       # Disable everything first, then enable the selected item.
      }
    }
}

#==============================================================================
proc UI_PB_def_EnableWindow { CHAP } {
#==============================================================================
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

   #***********************
   # Get tabbed pages info
   #***********************
    set page_tab $Book::($sect,current_tab)
    set page_obj [lindex $Book::($sect,page_obj_list) $page_tab]

   #***************************
   # Retrieve some font styles
   #***************************
    set sty_n  $gPB(font_style_normal)
    set sty_b  $gPB(font_style_bold)
    set sty_ng $gPB(font_style_normal_gray)
    set sty_bg $gPB(font_style_bold_gray)

    $sect_id pageconfig blk -state normal
    $sect_id pageconfig adr -state normal
    $sect_id pageconfig fmt -state normal
    $sect_id pageconfig ele -state normal
}

#==============================================================================
proc UI_PB_Def {book_id def_page_obj} {
#==============================================================================
  global paOption
  set f [$book_id subwidget $Page::($def_page_obj,page_name)]

  set w [tixNoteBook $f.nb -ipadx 5 -ipady 5]
  [$w subwidget nbframe] config -tabpady 0

  set def_book [new Book w]
  set Page::($def_page_obj,book_obj) $def_book
  Book::CreatePage $def_book blk "BLOCK" "" UI_PB_Def_Block \
                                 UI_PB_Def_BlockTab
  Book::CreatePage $def_book adr "ADDRESS" "" UI_PB_Def_Address \
                                UI_PB_Def_AddressTab
  Book::CreatePage $def_book fmt "FORMAT" "" UI_PB_Def_Format \
                                UI_PB_Def_FormatTab
  Book::CreatePage $def_book ele "Other Data Elements" "" \
                   UI_PB_Def_OtherElements UI_PB_Def_OthElemTab

  pack $f.nb -expand yes -fill both
  set Book::($def_book,x_def_tab_img) 0
  set Book::($def_book,current_tab) -1
}

#=============================================================================
proc UI_PB_Def_BlockTab { book_id page_img book_obj} {
#=============================================================================
   CB_nb_def $book_id $page_img $book_obj
   UI_PB_Def_UpdatePrevTabElems book_obj
   set Book::($book_obj,current_tab) 0
   UI_PB_Def_CreateTabAttr book_obj
}

#=============================================================================
proc UI_PB_Def_AddressTab { book_id page_img book_obj} {
#=============================================================================
   CB_nb_def $book_id $page_img $book_obj
   UI_PB_Def_UpdatePrevTabElems book_obj
   set Book::($book_obj,current_tab) 1
   UI_PB_Def_CreateTabAttr book_obj
}

#=============================================================================
proc UI_PB_Def_FormatTab { book_id page_img book_obj} {
#=============================================================================
   CB_nb_def $book_id $page_img $book_obj
   UI_PB_Def_UpdatePrevTabElems book_obj
   set Book::($book_obj,current_tab) 2
   UI_PB_Def_CreateTabAttr book_obj
}

#=============================================================================
proc UI_PB_Def_OthElemTab { book_id page_img book_obj} {
#=============================================================================
   CB_nb_def $book_id $page_img $book_obj
   UI_PB_Def_UpdatePrevTabElems book_obj 
   set Book::($book_obj,current_tab) 3
   UI_PB_Def_CreateTabAttr book_obj
}

#=============================================================================
proc UI_PB_Def_CreateTabAttr { BOOK_OBJ } {
#=============================================================================
  upvar $BOOK_OBJ book_obj

  switch -exact -- $Book::($book_obj,current_tab) \
  {
     0 { 
          set page_obj [lindex $Book::($book_obj,page_obj_list) 0]
          UI_PB_blk_TabBlockCreate $page_obj
       }
     1 { 
          set page_obj [lindex $Book::($book_obj,page_obj_list) 1]
          UI_PB_addr_TabAddressCreate $page_obj
       }
     2 { 
          set page_obj [lindex $Book::($book_obj,page_obj_list) 2]
          UI_PB_fmt_FormatItemSelec $page_obj
       }
     3 { 
          set page_obj [lindex $Book::($book_obj,page_obj_list) 3]
          UI_PB_oth_UpdateOtherPage page_obj
       }
  }
}

#=============================================================================
proc UI_PB_Def_UpdatePrevTabElems { BOOK_OBJ } { 
#=============================================================================
  upvar $BOOK_OBJ book_obj

  switch -exact -- $Book::($book_obj,current_tab) \
  {
     0 { 
          set page_obj [lindex $Book::($book_obj,page_obj_list) 0]
          UI_PB_blk_TabBlockDelete $page_obj
       }
     1 { 
          set page_obj [lindex $Book::($book_obj,page_obj_list) 1]
          UI_PB_addr_AddressApply page_obj 
       }
     2 { 
          set page_obj [lindex $Book::($book_obj,page_obj_list) 2]
          UI_PB_fmt_ApplyFormat page_obj 
       }
     3 { 
          set page_obj [lindex $Book::($book_obj,page_obj_list) 3]
          UI_PB_oth_ApplyOtherAttr 
       }
  }
}
