#==============================================================================
#                        UI_PB_PROGTPTH.TCL
#==============================================================================
##############################################################################
# Description                                                                #
#     This file contains all functions dealing with the creation of          #
#     ui elements for Program & Tool Path Book.                              #
#                                                                            #
# Revisions                                                                  #
#                                                                            #
#   Date        Who       Reason                                             #
# 01-feb-1999   mnb       Initial                                            #
# 07-apr-1999   mnb       Removed puts                                       #
# 02-Jun-1999   mnb       Code Integration                                   #
# 13-Jun-1999   mnb       Attached Tab procedures to Address Summary page    #
# 07-Sep-1999   mnb       Tree index is stored as the sequence index         #
# 21-Sep-1999   mnb       Changed Address Summary Tab Procedure, to update   #
#                         Grid rows                                          #
# 17-Nov-1999   gsl       Submitted for phase-22.                            #
#                                                                            #
# $HISTORY$                                                                  #
#                                                                            #
##############################################################################

#==============================================================================
proc UI_PB_ProgTpth { book_id prgtpth_page_obj } {
#==============================================================================
   set f [$book_id subwidget $Page::($prgtpth_page_obj,page_name)]

   set w [tixNoteBook $f.nb -ipadx 5 -ipady 5]
   [$w subwidget nbframe] config -tabpady 0

   set evnt_book [new Book w]
   set Page::($prgtpth_page_obj,book_obj) $evnt_book
   Book::CreatePage $evnt_book prog "Program" "" UI_PB_ProgTpth_Program \
                                     UI_PB_progtpth_ProgramTab
   Book::CreatePage $evnt_book gcod "G Codes" "" UI_PB_ProgTpth_Gcode \
                                     UI_PB_progtpth_GcodeTab
   Book::CreatePage $evnt_book mcod "M Codes" "" UI_PB_ProgTpth_Mcode \
                                     UI_PB_progtpth_McodeTab
   Book::CreatePage $evnt_book asum "Address Summary" "" \
                    UI_PB_ProgTpth_AddSum UI_PB_progtpth_AddsumTab
   Book::CreatePage $evnt_book wseq "Word Sequencing" "" \
                     UI_PB_ProgTpth_WordSeq UI_PB_progtpth_WordSeqTab

   pack $f.nb -expand yes -fill both
   set Book::($evnt_book,x_def_tab_img) 0
   set Book::($evnt_book,current_tab) -1
}

#==============================================================================
proc UI_PB_progtpth_ProgramTab {book_id page_img book_obj} {
#==============================================================================
  CB_nb_def $book_id $page_img $book_obj
  
  UI_PB_progtpth_DeleteTabAtt book_obj

  set Book::($book_obj,current_tab) 0
  UI_PB_progtpth_CreateTabAttr book_obj
}

#==============================================================================
proc UI_PB_progtpth_GcodeTab {book_id page_img book_obj} {
#==============================================================================

  CB_nb_def $book_id $page_img $book_obj
  UI_PB_progtpth_DeleteTabAtt book_obj
  set Book::($book_obj,current_tab) 1
  UI_PB_progtpth_CreateTabAttr book_obj
}

#==============================================================================
proc UI_PB_progtpth_McodeTab {book_id page_img book_obj} {
#==============================================================================

  CB_nb_def $book_id $page_img $book_obj
  UI_PB_progtpth_DeleteTabAtt book_obj
  set Book::($book_obj,current_tab) 2
  UI_PB_progtpth_CreateTabAttr book_obj
}

#==============================================================================
proc UI_PB_progtpth_AddsumTab {book_id page_img book_obj} {
#==============================================================================
  CB_nb_def $book_id $page_img $book_obj
  UI_PB_progtpth_DeleteTabAtt book_obj
  set Book::($book_obj,current_tab) 3
  UI_PB_progtpth_CreateTabAttr book_obj
}

#==============================================================================
proc UI_PB_progtpth_WordSeqTab {book_id page_img book_obj} {
#==============================================================================
  CB_nb_def $book_id $page_img $book_obj
  UI_PB_progtpth_DeleteTabAtt book_obj
  set Book::($book_obj,current_tab) 4
  UI_PB_progtpth_CreateTabAttr book_obj
}

#==============================================================================
proc UI_PB_progtpth_CreateTabAttr { BOOK_OBJ } {
#==============================================================================
  upvar $BOOK_OBJ book_obj

  switch -exact -- $Book::($book_obj,current_tab) \
  {
      0 {
           set page_obj [lindex $Book::($book_obj,page_obj_list) 0]
           UI_PB_evt_GetSequenceIndex page_obj seq_index
           set seq_obj [lindex $Page::($page_obj,seq_obj_list) $seq_index]
           UI_PB_evt_RestoreSeqObjData seq_obj
           UI_PB_evt_CreateSeqAttributes page_obj
        }

      1 {
          set page_obj [lindex $Book::($book_obj,page_obj_list) 1]
          UI_PB_gcd_RestoreGcodeData $page_obj
        }

      2 {
          set page_obj [lindex $Book::($book_obj,page_obj_list) 2]
          UI_PB_mcd_RestoreMcodeData $page_obj
        }

      3 {
          set page_obj [lindex $Book::($book_obj,page_obj_list) 3]
          UI_PB_ads_TabAddrsumCreate page_obj
        }

      4 {
          set page_obj [lindex $Book::($book_obj,page_obj_list) 4]
          UI_PB_mseq_CreateMastSeqElements page_obj
        }
  }
}

#==============================================================================
proc UI_PB_progtpth_DeleteTabAtt { BOOK_OBJ } {
#==============================================================================
  upvar $BOOK_OBJ book_obj

  switch -exact -- $Book::($book_obj,current_tab) \
  {
      0 {
           set page_obj [lindex $Book::($book_obj,page_obj_list) 0]
           # Deletes the objects of previous sequence
             UI_PB_evt_DeleteObjectsPrevSeq page_obj
        }

      1 {
          set page_obj [lindex $Book::($book_obj,page_obj_list) 1]
          UI_PB_gcd_ApplyGcodeData $book_obj $page_obj
        }

      2 {
          set page_obj [lindex $Book::($book_obj,page_obj_list) 2]
          UI_PB_mcd_ApplyMcodeData $book_obj $page_obj
        }

      3 {
          set page_obj [lindex $Book::($book_obj,page_obj_list) 3]
          UI_PB_ads_UpdateAddressObjects
        }

      4 {
          set page_obj [lindex $Book::($book_obj,page_obj_list) 4]
          UI_PB_mseq_ApplyMastSeq page_obj
          UI_PB_mseq_DeleteMastSeqElems page_obj
        }
  }
}
