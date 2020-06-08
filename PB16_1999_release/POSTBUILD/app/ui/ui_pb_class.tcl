#==============================================================================
#                       UI_PB_CLASS.TCL
#==============================================================================
##############################################################################
# Description                                                                #
#     This file contains the ui classes.                                     #
#                                                                            #
# Revisions                                                                  #
#                                                                            #
#   Date        Who       Reason                                             #
# 01-feb-1999   mnb       Initial                                            #
# 02-Jun-1999   mnb       Code Integration                                   #
# 29-Jun-1999   mnb       Added grab attributes                              #
# 07-Sep-1999   mnb       Added few new page methods                         #
# 17-Nov-1999   gsl       Submitted for phase-22.                            #
#                                                                            #
# $HISTORY$                                                                  #
#                                                                            #
##############################################################################

class Book {
    proc Book {this BOOK_ID} {
        upvar $BOOK_ID book_id
        set Book::($this,book_id) $book_id
    }

    proc ~Book {this} {}
   
    proc CreatePage {this page_name plabel pg_image \
                     first_cb second_cb} \
    {
      global paOption
      set book_id $Book::($this,book_id)
      set new_page [new Page $page_name $plabel]
      set img_id [image create compound -window [$book_id subwidget nbframe] -pady 0 \
                    -background $paOption(focus) -showbackground 0]
      if { [string compare $pg_image ""] != 0} \
      {
          set pg_img_id [tix getimage $pg_image]
          $img_id add image -image $pg_img_id
          $img_id add space -width 5
      }

      $img_id add text -text $plabel
      $book_id add $page_name -createcmd "$first_cb $book_id $new_page" \
        -wraplength 200 -image $img_id -raisecmd "$second_cb $book_id \
                               $img_id $this"
      lappend Book::($this,page_obj_list) $new_page
    }
    
    proc CreateTopLvlPage {this page_name} {
       set new_page [new Page $page_name "npage"]
       set Book::($this,top_lvl_evt_page) $new_page
       
       set book_id $Book::($this,book_id)
       set page_id [frame $book_id.frm -width 900 -height 700]
       set Page::($new_page,page_id) $page_id
    }

    proc RetPageObj {this page_name} {
       set page_obj_list $Book::($this,page_obj_list)
       
       foreach object $page_obj_list\
       {
         set pname $Page::($object,page_name)
         if {[string compare $pname $page_name] == 0}\
         {
            return $object
         }
       }
    }
}

class Page {
    proc Page {this pname plabel} {
       set Page::($this,page_name) $pname
       set Page::($this,page_label) $plabel
    }
   
    proc ~Page {this} {}

    proc CreateFrame {inp_frm frm_ext} {
       set frame_id [UI_PB_mthd_CreateFrame $inp_frm $frm_ext]
       return $frame_id
    }

    proc CreateLabel {inp_frm ext label} {
       UI_PB_mthd_CreateLabel $inp_frm $ext $label
    }

    proc CreateLblFrame {inp_frm ext label} {
       UI_PB_mthd_CreateLblFrame $inp_frm $ext $label
    }

    proc CreateIntControl {var inp_frm ext label} {

       UI_PB_mthd_CreateIntControl $var $inp_frm $ext $label 
    }

    proc CreateFloatControl {val1 val2 inp_frm ext label} {

       UI_PB_mthd_CreateFloatControl $val1 $val2 $inp_frm $ext $label 
    }

    proc CreateLblEntry {data_type var inp_frm ext label} {
 
       UI_PB_mthd_CreateLblEntry $data_type $var $inp_frm $ext $label 

    }

    proc CreateCheckButton {var inp_frm ext label} {

       UI_PB_mthd_CreateCheckButton $var $inp_frm $ext $label 
    }

    proc CreateButton { inp_frm ext label} {

       UI_PB_mthd_CreateButton $inp_frm $ext $label 
  
    }

    proc CreateRadioButton { var inp_frm ext label} {

       UI_PB_mthd_CreateRadioButton $var $inp_frm $ext $label
   
    }

    proc CreateEntry { var inp_frm ext } {

      UI_PB_mthd_CreateEntry $var $inp_frm $ext
    
    }

    proc CreateOptionalMenu { var inp_frm ext optional_list label} {

      UI_PB_mthd_CreateOptionalMenu $var $inp_frm $ext $optional_list \
                                      $label
    }


    proc CreatePane {this} {
       
        UI_PB_mthd_CreatePane $this
    }

    proc CreateCheckList {this} {

        UI_PB_mthd_CreateCheckList $this

    }

    proc CreateTree {this} {

        UI_PB_mthd_CreateTree $this

    }
    proc CreateCanvas {this TOP_CANVAS_DIM BOT_CANVAS_DIM} {
       upvar $TOP_CANVAS_DIM top_canvas_dim
       upvar $BOT_CANVAS_DIM bot_canvas_dim

       UI_PB_mthd_CreateCanvas $this top_canvas_dim bot_canvas_dim
    }

    proc CreateAddTrashinCanvas {this} \
    {

       UI_PB_mthd_CreateAddTrashinCanvas $this
    }

    proc CreateMenu { this } \
    {
       UI_PB_mthd_CreateMenu $this
    }

    proc AddComponents {this} {

      set page_name $Page::($this,page_name)

      UI_PB_evt_$page_name this 
    }
} 
