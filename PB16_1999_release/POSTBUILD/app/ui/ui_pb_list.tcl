#=============================================================================
#                      UI_PB_LIST.TCL
#=============================================================================
##############################################################################
# Description                                                                #
#     This file contains all functions dealing with the creation of          #
#     ui elements for Listing file page.                                     #
#                                                                            #
# Revisions                                                                  #
#                                                                            #
#   Date        Who       Reason                                             #
# 01-feb-1999   mnb       Initial                                            #
# 12-May-1999   gsl       Eliminated redundant frames in AddListPage.        #
# 02-Jun-1999   mnb       Code Integration                                   #
# 14-Jun-1999   mnb       Removed Apply Action button                        #
# 17-Nov-1999   gsl       Submitted for phase-22.                            #
#                                                                            #
# $HISTORY$                                                                  #
#                                                                            #
##############################################################################

#*****************************************************************************
proc UI_PB_List { book_id list_page_obj } {
#*****************************************************************************
    global tixOption

    AddListPage [$book_id subwidget $Page::($list_page_obj,page_name)] 0
}

#=============================================================================
proc AddListPage {w n} {
#=============================================================================
  global tixOption
  global paOption
  global ListObjectList
  global ListObjectAttr

   set ff [frame $w.ff -relief sunken -bd 1]
   pack $ff -side top -expand yes -fill both -padx 5

   set f [frame $ff.f]
   pack $f -side top -pady 30

   set bb [tixButtonBox $w.bb -orientation horizontal \
          -relief sunken -bd 2 -bg $paOption(butt_bg)]
   pack $bb -fill x -padx 5 -pady 5


   set list [frame $f.1]
   set nam  [frame $f.2]
   set g1   [frame $f.3 ] 
   set g2   [frame $f.4 ] 
   set g3   [frame $f.5 ] 
   set g4   [frame $f.6 ] 

   checkbutton $list.lisflg -text "Generate Listing File" \
               -variable ListObjectAttr(listfile) \
               -relief flat -font $tixOption(bold_font) \
               -bd 2 -anchor w -padx 6

   tixLabelEntry $nam.fnm -label "File Name" \
        -options {
            entry.width 30
            entry.anchor e
            label.anchor w
            entry.textVariable ListObjectAttr(fname)
        }


   tixLabelFrame $g1.param -label "List of Parameters"
   tixLabelFrame $g2.fmt   -label "Page Format"
   tixLabelFrame $g2.warn  -label "Warning"
   tixLabelFrame $g3.head  -label "Program Header"
   tixLabelFrame $g3.foot  -label "Program Footer"
   tixLabelFrame $g4.body  -label "Operator Messages"
   

  # CALL BACK FUNCTIONS
   $list.lisflg config -command \
           "UI_PB_lst__SetCheckButtonState $nam.fnm ListObjectAttr(listfile)"

   pack $list.lisflg
   pack $nam.fnm
   pack $g1.param
   pack $g2.fmt  -side top
   pack $g2.warn -side bottom
   pack $g3.head -side top
   pack $g3.foot -side bottom
   pack $g4.body -fill both

   grid $list -row 0 -column 0 -padx 10 -pady 20 -sticky nw
   grid $nam  -row 0 -column 1 -padx 10 -pady 20 -sticky nw
   grid $g1   -row 1 -column 0 -padx 10 -pady 10 -sticky nw
   grid $g2   -row 1 -column 1 -padx 10 -pady 10 -sticky ns
   grid $g3   -row 2 -column 0 -padx 10 -sticky nw
   grid $g4   -row 2 -column 1 -padx 10 -sticky ns

   set f1 [$g1.param subwidget frame]
   set f2 [$g2.fmt   subwidget frame]
   set f3 [$g2.warn  subwidget frame]
   set f4 [$g3.head  subwidget frame]
   set f5 [$g4.body  subwidget frame]
   set f6 [$g3.foot  subwidget frame]

   grid columnconfig $f 1 -minsize 180

#---  Parameters list

   checkbutton $f1.x -text "X-Coordinate" -variable ListObjectAttr(x) \
         -relief flat -bd 2 -anchor w -padx 6 -width 30

   checkbutton $f1.y -text "Y-Coordinate" -variable ListObjectAttr(y) \
         -relief flat -bd 2 -anchor w -padx 6 -width 30

   checkbutton $f1.z -text "Z-Coordinate" -variable ListObjectAttr(z) \
         -relief flat -bd 2 -anchor w -padx 6 -width 30

   checkbutton $f1.4a -text "4th Axis Angle" -variable ListObjectAttr(4axis) \
         -relief flat  -bd 2 -anchor w -padx 6 -width 30

   checkbutton $f1.5a -text "5th Axis Angle" -variable ListObjectAttr(5axis) \
         -relief flat  -bd 2 -anchor w -padx 6 -width 30

   checkbutton $f1.fed -text "Feed" -variable ListObjectAttr(feed) \
         -relief flat  -bd 2 -anchor w -padx 6 -width 30

   checkbutton $f1.spd -text "Speed" -variable ListObjectAttr(speed) \
         -relief flat  -bd 2 -anchor w -padx 6 -width 30

   pack $f1.x $f1.y $f1.z $f1.4a $f1.5a $f1.fed $f1.spd -side top \
         -anchor w

#---- Page Format

   checkbutton $f2.hed -text "Print Page Header" \
         -variable ListObjectAttr(head) \
         -relief flat  -bd 2 -anchor w -padx 6 -width 30

   tixLabelEntry $f2.row -label "Page Length (Rows)" \
         -options {
            label.width 20
            label.anchor w
            entry.width 10
            entry.anchor e
            entry.textVariable ListObjectAttr(lines)
         }

   [$f2.row subwidget label] config -font $tixOption(font)

   tixLabelEntry $f2.col -label "Page Width (Columns)" \
         -options {
            label.width 20
            label.anchor w
            entry.width 10
            entry.anchor e
            entry.textVariable ListObjectAttr(column)
         }

   [$f2.col subwidget label] config -font $tixOption(font)

   pack $f2.hed -side top
   pack $f2.row -side top -fill x -padx 10 -pady 5
   pack $f2.col -side top -fill x -padx 10 -pady 3


#----- Warnings

   checkbutton $f3.warn -text "Suppress all Warnings" \
         -variable ListObjectAttr(warn) \
         -relief flat  -bd 2 -anchor w -padx 6 -width 30

   pack $f3.warn -side top -anchor w

#------- Program Header

   checkbutton $f4.oper -text "Operation List" \
         -variable ListObjectAttr(oper) \
         -relief flat  -bd 2 -anchor w -padx 6 -width 30

   checkbutton $f4.tool -text "Tool List" \
         -variable ListObjectAttr(tool) \
         -relief flat  -bd 2 -anchor w -padx 6 -width 30

   pack $f4.oper $f4.tool -side top -anchor w

#--------- Operator Messages

   checkbutton $f5.strt -text "Start Of Path" \
         -variable ListObjectAttr(start_path) \
         -relief flat  -bd 2 -anchor w -padx 6 -width 30

   checkbutton $f5.chng -text "Tool Change" \
         -variable ListObjectAttr(tool_chng) \
         -relief flat  -bd 2 -anchor w -padx 6 -width 30

   checkbutton $f5.end -text "End Of Path" \
         -variable ListObjectAttr(end_path) \
         -relief flat  -bd 2 -anchor w -padx 6 -width 30

   checkbutton $f5.time -text "Machining Time" \
         -variable ListObjectAttr(oper_time) \
         -relief flat  -bd 2 -anchor w -padx 6 -width 30

   pack $f5.strt $f5.chng $f5.end $f5.time -side top -anchor w

#--------- Program Footer
 
   checkbutton $f6.time -text "Total Machining Time" \
         -variable ListObjectAttr(setup_time) \
         -relief flat  -bd 2 -anchor w -padx 6 -width 30
   
   pack $f6.time -side top -anchor w



   $bb add def -text Default -underline 0 -width 10 -command \
        "DefListObjAttr ListObjectList ListObjectAttr"
   $bb add res -text Restore -underline 0 -width 10 -command \
        "RestoreListObjAttr ListObjectList ListObjectAttr"

   UI_PB_lst__SetCheckButtonState $nam.fnm ListObjectAttr(listfile)
}

#=============================================================================
proc UI_PB_lst__SetCheckButtonState {widget STATE} {
#=============================================================================
  upvar $STATE state
  switch $state\
  {
     0      {$widget config -state disabled}
     1      {$widget config -state normal}
  }
}

