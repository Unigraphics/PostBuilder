##############################################################################

#=============================================================================
#
#=============================================================================
if { ![file exists $gPB(user_manual_file)] } {
   set gPB(user_manual_file)    "$env(PB_HOME)/doc/ugpost/index.html"
}


#=============================================================================
# Custom command syntax checker toggle switch
#
#  1 : Hide switch (Always perform syntax checking)
#  0 : Show switch
#=============================================================================
set gPB(FORCE_SYNTAX_CHECK) 0


#=============================================================================
# List PB_CMD_kin commands in the Custom Command page
#
#  1 : List
#  0 : Hide
#=============================================================================
set gPB(LIST_PB_CMD_KIN) 1


#=============================================================================
# Retain old PB_CMD commands after post conversion
#
#  1 : Keep
#  0 : Not
#=============================================================================
set gPB(KEEP_OLD_PB_CMD) 0


#=============================================================================
# Hide "Post Files Preview" page
#
#  1 : Hide
#  0 : Display
#=============================================================================
set gPB(HIDE_POST_PREVIEW_PAGE) 0


#=============================================================================
# Confirm permission to save Post to directory or files.
#
#  1 : Yes
#  0 : No
#=============================================================================
set gPB(CONFIRM_WRITE_PERMISSION) 1


#=============================================================================
# Highlight new features in a new release of Post Builder.
#
#  1 : Yes
#  0 : No
#=============================================================================
set gPB(HIGHLIGHT_NEW_FEATURE) 0
set gPB(NEW_FEATURE_COLOR)     cyan







