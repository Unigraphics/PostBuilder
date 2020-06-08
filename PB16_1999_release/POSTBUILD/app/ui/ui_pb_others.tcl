#===============================================================================
#                      UI_PB_OTHERS.TCL
#===============================================================================
##############################################################################
# Description                                                                #
#     This file contains all functions dealing with the creation of          #
#     ui elements for Other Elements page.                                   #
#                                                                            #
# Revisions                                                                  #
#                                                                            #
#   Date        Who       Reason                                             #
# 01-feb-1999   gsl       Initial                                            #
# 30-Apr-1999   gsl       Removed components tree.                           #
# 02-Jun-1999   mnb       Code Integration                                   #
# 10-Jun-1999   mnb       Attached callbacks to action button                #
# 14-Jun-1999   mnb       Added Supress Sequence Number check button         #
# 17-Nov-1999   gsl       Submitted for phase-22.                            #
#                                                                            #
# $HISTORY$                                                                  #
#                                                                            #
##############################################################################

#===============================================================================
proc UI_PB_Def_OtherElements {book_id other_page_obj} {
#===============================================================================
  global tixOption
  global paOption

  set w [$book_id subwidget $Page::($other_page_obj,page_name)]

  # Parameter pane
    AddPageGenParm $other_page_obj $w 0
}


#==============================================================================
proc AddPageGenParm {page_obj p e} {
#==============================================================================
  global tixOption
  global paOption

  set f [frame $p.f -relief sunken -bd 1]
  pack $f -expand yes -fill both -padx 3

  UI_PB_ads_CreateSpecialChars page_obj $f

  # Navigation buttons
  #
   set bb [tixButtonBox $p.bb -orientation horizontal \
         -relief sunken -bd 2 -bg $paOption(butt_bg)]
   pack $bb -fill x -padx 3 -pady 3

   $bb add def -text Default \
               -command "UI_PB_oth_DefaultCallBack" \
               -width 10 -underline 0
   $bb add app -text Restore \
               -command "UI_PB_oth_RestCallBack $page_obj" \
               -width 10 -underline 0
}

#============================================================================
proc UI_PB_oth_DefaultCallBack { } {
#============================================================================

  UI_PB_ads_SpecDefaultCallBack
}

#============================================================================
proc UI_PB_oth_RestCallBack { page_obj } {
#============================================================================

  UI_PB_ads_SpecRestCallBack $page_obj
}

#============================================================================
proc UI_PB_oth_UpdateOtherPage { PAGE_OBJ } {
#============================================================================
  upvar $PAGE_OBJ page_obj
  global mom_sys_arr

  # Restores the values of these mom variables
    set mom_var_list {"seqnum_start" "seqnum_incr" "seqnum_freq" \
                      "Word_Seperator" "Decimal_Point" "End_of_Block" \
                      "Comment_Start" "Comment_End"}

    foreach var $mom_var_list \
    {
      set rest_spec_momvar($var) $mom_sys_arr($var)
    }
    set Page::($page_obj,rest_spec_momvar) [array get rest_spec_momvar]
}

#============================================================================
proc UI_PB_oth_ApplyOtherAttr { } {
#============================================================================
  global mom_sys_arr
  global special_char

  set mom_var_list {"Word_Seperator" "Decimal_Point" "End_of_Block" \
                    "Comment_Start" "Comment_End"}

  foreach option $mom_var_list \
  {
    set mom_sys_arr($option) $special_char($option,char)
  }
  
  PB_int_UpdateMOMVar mom_sys_arr
}
