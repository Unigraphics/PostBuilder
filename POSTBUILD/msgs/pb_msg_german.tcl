##############################################################################
#               Strings, labels and messages definition
##############################################################################

#######################  GUIDELINE FOR TRANSLATION  ##########################
if 0 {
#
# Tcl syntax is used in this file. The follwing key elements should be observed:
# 
# - A line started with a '#' sign defines comment; no translation is needed.
# - A string is defined by a sequence of alpha-numeric or symbols between a pair of double quotes ("...").
#   Ex.
#       ::msgcat::mcset pb_msg_german "MC(main,title,Unigraphics)"  "Unigraphics"
#       -----------------------------------------------------------  -------------
#                              - Variable -                            - String -
#
#       ==> "pb_msg_english" must be identical to the name of a particular language file.
#
#
# - A '\' character at the end of a line indicates the definition of a string
#   is continued into subsequent line(s).
# - A '\n' (new-line) token is used to display message in separated (list of) lines.
# - Any special character reserved for Tcl language (see definition for MC(address,exp,spec_char) below)
#   to be displayed in a message should be prefixed with a '\' (escape) character.
#   Ex.
#       '\ ' to preserve blanks within a string
#       '\$' to display a dollar sign in a label or message
#       '\"' to display a double quote sign in a label or message
#
# - A pair of '[]' (square brackets) is used to execute a Tcl command.
#
# - [::msgcat::mc ...] is occassionally used to transfer one string to the other.
#
#
# The following types of tokens (case sensitive) do not need to be translated:
# - Any single character prefixed by a '\' (as mentioned above)
# - Tokens (including single character) in all UPPER case
#   such as 'M', 'G', 'F', 'UGII' and 'EDITOR', except
#   'BLOCK', "WORD", 'FORMAT' and 'Wire EDM'.
# - Any contiguous string joined by "_" (underscore) characters
# - Any contiguous string containing numerals
# - Tcl
# - Tk
# - Tix
#
# Leading and trailing blanks in the strings ("  ...  ") should be preserved after translation.
#
# Set the return value to 1 (as "retrun 1") in the code fragment below when this language file is ready to be released.
#
}
##################  DO NOT CHANGE ANYTHING ABOVE THIS LINE ###################


# @<DEL>@ TEXT ENCLOSED within delete markers will be REMOVED                #
#============================================================================#
#                                                                            #
# Revisions                                                                  #
# ---------                                                                  #
#   Date   Who       Reason                                                  #
#======
# v800
#======
# 05-25-10 gsl - Revised "MC(cust_cmd,import,no_vnc_cmd,msg)" & "MC(cust_cmd,import,no_cmd,msg)"
#                to reflect the chage of behavior that only different & new commands will be listed for import.
# 03-01-11 gsl - MC(inposts,title,Label) was "Install Posts"
# 05-18-11 gsl - Added new strings for pb8
#============================================================================#
# TEXT ENCLOSED within delete markers will be REMOVED @<DEL>@                #


if { [info exists gPB(LANG_TEST)] } {
  #======================================================
  # Return 1 when this language file is ready to be used
  #======================================================
return 1
}


#=============================================================================
# pb800
#=============================================================================
::msgcat::mcset pb_msg_german "MC(event,misc,subop_start,name)"      "Pfadanfang der Unteroperation"
::msgcat::mcset pb_msg_german "MC(event,misc,subop_end,name)"        "Pfadende der Unteroperation"
::msgcat::mcset pb_msg_german "MC(event,misc,contour_start,name)"    "Konturstart"
::msgcat::mcset pb_msg_german "MC(event,misc,contour_end,name)"      "Konturende"
::msgcat::mcset pb_msg_german "MC(prog,tree,misc,Label)"             "Verschiedenes"
::msgcat::mcset pb_msg_german "MC(event,cycle,lathe_rough,name)"     "Dreh-Schruppen"
::msgcat::mcset pb_msg_german "MC(main,file,properties,Label)"       "Posten-Eigenschaften"

::msgcat::mcset pb_msg_german "MC(ude,editor,popup,MSG_CATEGORY)"    "Das anwenderdefinierte Element für einen Fräs- bzw. Drehposten kann u. U. nicht nur mit einer \"Drahterodieren\"-Kategorie festgelegt werden."

::msgcat::mcset pb_msg_german "MC(event,cycle,plane_change,label)"   "Dieses Ereignis auslösen, wenn Arbeitsebene niedriger ist"
::msgcat::mcset pb_msg_german "MC(format,check_1,error,msg)"         "Das Format unterstützt den Wert der Ausdrücke nicht"

::msgcat::mcset pb_msg_german "MC(format,check_4,error,msg)"         "Ändern Sie das Format der zugehörigen Adresse, bevor Sie diese Seite verlassen bzw. diesen Posten speichern."
::msgcat::mcset pb_msg_german "MC(format,check_5,error,msg)"         "Ändern Sie das Format, bevor Sie diese Seite verlassen oder diesen Posten speichern."
::msgcat::mcset pb_msg_german "MC(format,check_6,error,msg)"         "Ändern Sie das Format der zugehörigen Adresse, bevor Sie diese Seite öffnen."

::msgcat::mcset pb_msg_german "MC(msg,old_block,maximum_length)"     "Die Namen der folgenden Datenblöcke haben den Längengrenzwert überschritten:"
::msgcat::mcset pb_msg_german "MC(msg,old_address,maximum_length)"   "Die Namen der folgenden Wörter haben den Längengrenzwert überschritten:"
::msgcat::mcset pb_msg_german "MC(msg,block_address,check,title)"    "Prüfen von Datenblock- und Wortnamen"
::msgcat::mcset pb_msg_german "MC(msg,block_address,maximum_length)" "Einige der Datenblöcke bzw. Wörter haben den Längengrenzwert überschritten."

::msgcat::mcset pb_msg_german "MC(address,maximum_name_msg)"         "Die Zeichenfolgelänge hat die max. zulässige Länge überschritten."

::msgcat::mcset pb_msg_german "MC(ude,import,oth_list,Label)"        "Andere CDL-Datei einschließen"
::msgcat::mcset pb_msg_german "MC(ude,import,oth_list,Context)"      "Wählen Sie die Option \\\"Neu\\\" aus dem Kontextmenü (Klick auf rechte Maustaste) aus, um diesem Posten andere CDL-Dateien hinzuzufügen."
::msgcat::mcset pb_msg_german "MC(ude,import,ihr_list,Label)"        "UDE von einem Posten übernehmen"
::msgcat::mcset pb_msg_german "MC(ude,import,ihr_list,Context)"      "Wählen Sie die Option \\\"Neu\\\" aus dem Kontextmenü aus (Klick auf rechte Maustaste), um die Definitionen anwenderdef. Elemente sowie verknüpfter Handles aus einem Posten zu übernehmen."
::msgcat::mcset pb_msg_german "MC(ude,import,up,Label)"              "Nach oben"
::msgcat::mcset pb_msg_german "MC(ude,import,down,Label)"            "Nach unten"
::msgcat::mcset pb_msg_german "MC(msg,exist_cdl_file)"               "Die festgelegte CDL-Datei ist bereits enthalten."

::msgcat::mcset pb_msg_german "MC(listing,link_var,check,Label)"     "Tcl-Variablen mit C-Variablen verbinden"
::msgcat::mcset pb_msg_german "MC(listing,link_var,check,Context)"   "Ein Satz häufig geänderter Tcl-Variablen (wie \\\"mom_pos\\\") kann direkt mit den internen C-Variablen verbunden werden, um die Leistung der Nachbearbeitung zu verbessern. Bestimmte Beschränkungen müssen jedoch beachtet werden, um mögliche Fehler und Unterschieden in der NC-Ausgabe zu vermeiden. "

::msgcat::mcset pb_msg_german "MC(msg,check_resolution,title)"       "Lineares/Rotations-Bewegungsergebnis prüfen"
::msgcat::mcset pb_msg_german "MC(msg,check_resolution,linear)"      "Die Formateinstellung unterstützt die Ausgabe für die \"lineare Bewegungsauflösung\" möglicherweise nicht."
::msgcat::mcset pb_msg_german "MC(msg,check_resolution,rotary)"      "Die Formateinstellung unterstützt die Ausgabe für die \"Rotationsbewegungsauflösung\" möglicherweise nicht."

::msgcat::mcset pb_msg_german "MC(cmd,export,desc,label)"            "Eingabebeschreibung für die exportierten benutzerdef. Befehle"
::msgcat::mcset pb_msg_german "MC(cmd,desc_dlg,title)"               "Beschreibung"
::msgcat::mcset pb_msg_german "MC(block,delete_row,Label)"           "Alle aktiven Element in dieser Zeile löschen"
::msgcat::mcset pb_msg_german "MC(block,exec_cond,set,Label)"        "Ausgabebedingung"
::msgcat::mcset pb_msg_german "MC(block,exec_cond,new,Label)"        "Neu..."
::msgcat::mcset pb_msg_german "MC(block,exec_cond,edit,Label)"       "Bearbeiten..."
::msgcat::mcset pb_msg_german "MC(block,exec_cond,remove,Label)"     "Entfernen..."

::msgcat::mcset pb_msg_german "MC(cust_cmd,name_msg_for_cond)"       "Geben Sie einen anderen Namen an.  \nDer Ausgabebedingungs-Befehl sollte folgendes Präfix enthalten"

::msgcat::mcset pb_msg_german "MC(machine,linearization,Label)"         "Linearisierungs-Interpolation"
::msgcat::mcset pb_msg_german "MC(machine,linearization,angle,Label)"   "Drehwinkel"
::msgcat::mcset pb_msg_german "MC(machine,linearization,angle,Context)" "Interpolierte Punkte werden basierend auf der Verteileung von Start- und Endwinkeln der Drehachsen berechnet."
::msgcat::mcset pb_msg_german "MC(machine,linearization,axis,Label)"    "Wkz-Achse"
::msgcat::mcset pb_msg_german "MC(machine,linearization,axis,Context)"  "Interpolierte Punkte werden basierend auf der Verteilung von Start- und Endvektoren der Wkz-Achse berechnet."
::msgcat::mcset pb_msg_german "MC(machine,resolution,continue,Label)"   "Weiter"
::msgcat::mcset pb_msg_german "MC(machine,resolution,abort,Label)"      "Abbrechen"

::msgcat::mcset pb_msg_german "MC(machine,axis,def_lintol,Label)"       "Standardtoleranz"
::msgcat::mcset pb_msg_german "MC(machine,axis,def_lintol,Context)"     "Linearisierungs-Standardtoleranz"
::msgcat::mcset pb_msg_german "MC(sub_post,inch,Lable)"                 " IN"
::msgcat::mcset pb_msg_german "MC(sub_post,metric,Lable)"               "MM"
::msgcat::mcset pb_msg_german "MC(new_sub,title,Label)"                 "Neuen untergeordneten Postprozessor erstellen"
::msgcat::mcset pb_msg_german "MC(new,sub_post,toggle,label)"           "Untergeordneter Posten"
::msgcat::mcset pb_msg_german "MC(new,sub_post,toggle,tmp_label)"       "Nur Einheiten-Unterposten"
::msgcat::mcset pb_msg_german "MC(new,unit_post,filename,msg)"          "Der neue untergeordnete Posten für alternative Ausgabeeinheiten sollte benannt werden,\n indem Sie \"postfix\" \"__MM\" or \"__IN\" an den Namen des Hauptpostens anhängen."
::msgcat::mcset pb_msg_german "MC(new,alter_unit,toggle,label)"         "Alternative Ausgabeeinheiten"
::msgcat::mcset pb_msg_german "MC(new,main_post,label)"                 "Hauptposten"
::msgcat::mcset pb_msg_german "MC(new,main_post,warning_1,msg)"         "Es kann nur ein vollständiger Hauptposten für das Erzeugen eines neuen untergeordneten Postens verwendet werden."
::msgcat::mcset pb_msg_german "MC(new,main_post,warning_2,msg)"         "Der Hauptposten muss in\n in Post Builder-Version 8.0 oder einer neuen Version erzeugt oder gespeichert werden."
::msgcat::mcset pb_msg_german "MC(new,main_post,specify_err,msg)"       "Der Hauptposten muss für das Erzeugen eines untergeordneten Postens festgelegt sein."
::msgcat::mcset pb_msg_german "MC(machine,gen,alter_unit,Label)"        "Ausgabeeinheiten des Unterpostens :"
::msgcat::mcset pb_msg_german "MC(unit_related_param,tab,Label)"        "Einheitenparameter"
::msgcat::mcset pb_msg_german "MC(unit_related_param,feed_rate,Label)"  "Vorschub"
::msgcat::mcset pb_msg_german "MC(listing,alt_unit,frame,Label)"        "Optionale alternative Einheiten-Unterposten"
::msgcat::mcset pb_msg_german "MC(listing,alt_unit,default,Label)"      "Standard"
::msgcat::mcset pb_msg_german "MC(listing,alt_unit,default,Context)"    "Der Standardname alternativer Einheiten-Unterposten ist <Posten-Name>__MM or <Posten-Name>__IN"
::msgcat::mcset pb_msg_german "MC(listing,alt_unit,specify,Label)"      "Angeben"
::msgcat::mcset pb_msg_german "MC(listing,alt_unit,specify,Context)"    "Name eines alternativen Einheiten-Unterpostens angeben"
::msgcat::mcset pb_msg_german "MC(listing,alt_unit,select_name,Label)"  "Name auswählen"
::msgcat::mcset pb_msg_german "MC(listing,alt_unit,warning_1,msg)"      "Es kann nur ein alternativer Einheiten-Unterposten ausgewählt werden."
::msgcat::mcset pb_msg_german "MC(listing,alt_unit,warning_2,msg)"      "Der ausgewählte Unterposten unterstützt die alternative Ausgabeeinheiten für diesen Posten nicht."

::msgcat::mcset pb_msg_german "MC(listing,alt_unit,post_name,Label)"    "Alternativer Einheiten-Unterposten"
::msgcat::mcset pb_msg_german "MC(listing,alt_unit,post_name,Context)"  "Der NX-Posten verwendet den Einheiten-Unterposten, falls angegeben, um die alternativen Ausgabeeinheiten für diesen Posten zu verarbeiten."


##--------------------
## New string in v7.5
##
::msgcat::mcset pb_msg_german "MC(machine,axis,violation,user,evt_title)"  "Benutzerdefinierte Aktion bei Verletzung der Achsenbegrenzung"
::msgcat::mcset pb_msg_german "MC(event,helix,name)"                       "Spiralförmige Verschiebung"
::msgcat::mcset pb_msg_german "MC(event,circular,ijk_param,prefix,msg)"    "In Adressen verwendete Ausdrücke"
::msgcat::mcset pb_msg_german "MC(event,circular,ijk_param,postfix,msg)"   "werden nicht von den Änderungen an dieser Option beeinflusst."
::msgcat::mcset pb_msg_german "MC(isv,spec_codelist,default,msg)"          "Mit dieser Aktion wird die Liste besonderer NC-Codes sowie\n deren Handler auf den Status zurückgesetzt, als dieser Posten geöffnet bzw. erzeugt wurde.\n\n Möchten Sie fortfahren?"
::msgcat::mcset pb_msg_german "MC(isv,spec_codelist,restore,msg)"          "Mit dieser Aktion wird die Liste besonderer NC-Codes sowie\n deren Handler auf den Status zurückgesetzt, als diese Seite zuletzt besucht wurde.\n\n Möchten Sie fortfahren?"
::msgcat::mcset pb_msg_german "MC(msg,block_format_command,paste_err)"     "Objektname ist bereits vorhanden...Einfügen ungültig."
::msgcat::mcset pb_msg_german "MC(main,file,open,choose_cntl_type)"        "Eine Steuerungsfamilie auswählen"
::msgcat::mcset pb_msg_german "MC(cust_cmd,import,no_vnc_cmd,msg)"         "Diese Datei enthält keinen neuen oder anderen VNC-Befehl."
::msgcat::mcset pb_msg_german "MC(cust_cmd,import,no_cmd,msg)"             "Diese Datei enthält keinen neuen oder anderen benutzerdef. Befehl."
::msgcat::mcset pb_msg_german "MC(isv,tool_info,name_same_err,Msg)"        "Die Wkz-Namen dürfen nicht identisch sein."
::msgcat::mcset pb_msg_german "MC(msg,limit_to_change_license)"            "Sie sind nicht der Verfasser dieses Postens. \nSie haben keine Berechtigung die Lizenz des Postens umzubenennen bzw. zu ändern."
::msgcat::mcset pb_msg_german "MC(output,other_opts,validation,msg)"       "Der Name der TCL-Benutzerdatei muss angegeben werden."
::msgcat::mcset pb_msg_german "MC(machine,empty_entry_err,msg)"            "Es befinden sich leere Einträge auf der Seite \"Parameter\"."
::msgcat::mcset pb_msg_german "MC(msg,control_v_limit)"                    "Die Zeichenfolge, die Sie versuchen einzufügen, hat u. U.\n die zulässige Länge überschritten oder\n hat mehrere Einträge bzw. ungültige Zeichen enthalten."
::msgcat::mcset pb_msg_german "MC(block,capital_name_msg)"                 "Der erste Buchstabe des Quadernamens darf kein Großbuchstabe sein.\n Legen Sie einen anderen Namen fest."
::msgcat::mcset pb_msg_german "MC(machine,axis,violation,user,Label)"      "Anwenderdefiniert"
::msgcat::mcset pb_msg_german "MC(machine,axis,violation,user,Handler)"    "Handler"
::msgcat::mcset pb_msg_german "MC(new,user,file,NOT_EXIST)"                "Diese Benutzerdatei ist nicht vorhanden."
::msgcat::mcset pb_msg_german "MC(new,include_vnc,Label)"                  "Virtuelle NC-Steuerung einschließen"
::msgcat::mcset pb_msg_german "MC(other,opt_equal,Label)"                  "Gleichheitszeichen (=)"
::msgcat::mcset pb_msg_german "MC(event,nurbs,name)"                       "NURBS-Verschiebung"
::msgcat::mcset pb_msg_german "MC(event,cycle,tap_float,name)"             "Gewindebohrer , fließend"
::msgcat::mcset pb_msg_german "MC(event,cycle,thread,name)"                "Gewinde"
::msgcat::mcset pb_msg_german "MC(ude,editor,group,MSG_NESTED_GROUP)"      "Die eingebundene Gruppierung wird nicht unterstützt."
::msgcat::mcset pb_msg_german "MC(ude,editor,bmp,Label)"                   "Bitmap"
::msgcat::mcset pb_msg_german "MC(ude,editor,bmp,Context)"                 "Fügen Sie eine neuen Bitmap-Parameter durch Ziehen in die rechte Liste hinzu."
::msgcat::mcset pb_msg_german "MC(ude,editor,group,Label)"                 "Gruppe"
::msgcat::mcset pb_msg_german "MC(ude,editor,group,Context)"               "Fügen Sie eine neuen Gruppierungsparameter durch Ziehen in die rechte Liste hinzu."
::msgcat::mcset pb_msg_german "MC(ude,editor,eventdlg,DESC,Label)"         "Beschreibung"
::msgcat::mcset pb_msg_german "MC(ude,editor,eventdlg,DESC,Context)"       "Ereignisinformationen angeben"
::msgcat::mcset pb_msg_german "MC(ude,editor,eventdlg,URL,Label)"          "URL"
::msgcat::mcset pb_msg_german "MC(ude,editor,eventdlg,URL,Context)"        "URL für Ereignisbeschreibung festlegen"
::msgcat::mcset pb_msg_german "MC(ude,editor,param,MSG_WRONG_IMAGE_FILE)"  "Die Bilddatei muss in BMP-Format sein."
::msgcat::mcset pb_msg_german "MC(ude,editor,param,MSG_WRONG_IMAGE_FOLDER)" "Der Name der Bitmap-Datei sollte keinen Verzeichnispfad enthalten."
::msgcat::mcset pb_msg_german "MC(ude,editor,param,MSG_WRONG_VAR_NAME)"    "Der Name der Variable muss mit einem Buchstaben beginnen."
::msgcat::mcset pb_msg_german "MC(ude,editor,param,MSG_WRONG_KEYWORD)"     "Der Variablenname darf kein Schlüsselwort enthalten: "
::msgcat::mcset pb_msg_german "MC(ude,editor,status_label)"                "Status"
::msgcat::mcset pb_msg_german "MC(ude,editor,vector,Label)"                "Vektor"
::msgcat::mcset pb_msg_german "MC(ude,editor,vector,Context)"              "Fügen Sie eine neuen Vektorparameter durch Ziehen in die rechte Liste hinzu."
::msgcat::mcset pb_msg_german "MC(ude,editor,popup,MSG_URL_FORMAT)"        "Die URL muss sich im Format \"http://*\" or \"file://*\" befinden, wobei keine Schrägstriche verwendet werden."
::msgcat::mcset pb_msg_german "MC(ude,editor,popup,MSG_BLANK_HELP_INFO)"   "Beschreibung sowie URL müssen angegeben werden."
::msgcat::mcset pb_msg_german "MC(new,MSG_NO_AXIS)"                        "Die Achsenkonfiguration muss für eine Wkz-Maschine ausgewählt werden."
::msgcat::mcset pb_msg_german "MC(machine,info,controller_type,Label)"     "Steuerungsfamilie"
::msgcat::mcset pb_msg_german "MC(block,func_combo,Label)"                 "Makro"
::msgcat::mcset pb_msg_german "MC(block,prefix_popup,add,Label)"           "Präfix-Text hinzufügen"
::msgcat::mcset pb_msg_german "MC(block,prefix_popup,edit,Label)"          "Präfix-Text bearbeiten"
::msgcat::mcset pb_msg_german "MC(block,prefix,Label)"                     "Präfix"
::msgcat::mcset pb_msg_german "MC(block,suppress_popup,Label)"             "Sequenznummer unterdrücken"
::msgcat::mcset pb_msg_german "MC(block,custom_func,Label)"                "Benutzerdefinierte Makro"
::msgcat::mcset pb_msg_german "MC(seq,combo,macro,Label)"                  "Benutzerdefinierte Makro"
::msgcat::mcset pb_msg_german "MC(func,tab,Label)"                         "Makro"
::msgcat::mcset pb_msg_german "MC(func,exp,msg)"                           "Ein Ausdruck für einen Makro-Parameter sollte nicht leer sein."
::msgcat::mcset pb_msg_german "MC(func,edit,name,Label)"                   "Makro-Name"
::msgcat::mcset pb_msg_german "MC(func,disp_name,Label)"                   "Ausgabename"
::msgcat::mcset pb_msg_german "MC(func,param_list,Label)"                  "Parameterliste"
::msgcat::mcset pb_msg_german "MC(func,separator,Label)"                   "Trennzeichen"
::msgcat::mcset pb_msg_german "MC(func,start,Label)"                       "Startzeichen"
::msgcat::mcset pb_msg_german "MC(func,end,Label)"                         "Endzeichen"
::msgcat::mcset pb_msg_german "MC(func,output,name,Label)"                 "Ausgabeattribut"
::msgcat::mcset pb_msg_german "MC(func,output,check,Label)"                "Name des Ausgabeparameters"
::msgcat::mcset pb_msg_german "MC(func,output,link,Label)"                 "Verbindungszeichen"
::msgcat::mcset pb_msg_german "MC(func,col_param,Label)"                   "Parameter"
::msgcat::mcset pb_msg_german "MC(func,col_exp,Label)"                     "Ausdruck"
::msgcat::mcset pb_msg_german "MC(func,popup,insert,Label)"                "Neu"
::msgcat::mcset pb_msg_german "MC(func,name,err_msg)"                      "Der Makro-Name darf kein Leerzeichen enthalten."
::msgcat::mcset pb_msg_german "MC(func,name,blank_err)"                    "Der Makro-Name darf nicht leer sein."
::msgcat::mcset pb_msg_german "MC(func,name,contain_err)"                  "Der Makro-Name darf nur Buchstaben, Zahlen sowie Einträge mit Unterstrichen enthalten."
::msgcat::mcset pb_msg_german "MC(func,tree_node,start_err)"               "Knotenname muss mit einem Großbuchstaben beginnen."
::msgcat::mcset pb_msg_german "MC(func,tree_node,contain_err)"             "Der Knoten-Name darf nur Buchstaben, Zahlen sowie Einträge mit Unterstrichen enthalten."
::msgcat::mcset pb_msg_german "MC(func,help,Label)"                        "Informationen"
::msgcat::mcset pb_msg_german "MC(func,help,Context)"                      "Informationen zu Objekt zeigen"
::msgcat::mcset pb_msg_german "MC(func,help,MSG_NO_INFO)"                  "Es sind keine Informationen zu dieser Makro vorhanden."


##------
## Title
##
::msgcat::mcset pb_msg_german "MC(main,title,Unigraphics)"             "Unigraphics"
::msgcat::mcset pb_msg_german "MC(main,title,UG)"                      "NX"
::msgcat::mcset pb_msg_german "MC(main,title,Post_Builder)"            "Post Builder"

::msgcat::mcset pb_msg_german "MC(main,title,Version)"                 "Version"
::msgcat::mcset pb_msg_german "MC(main,default,Status)"                "Neu oder Öffnen aus Menü Datei auswählen."
::msgcat::mcset pb_msg_german "MC(main,save,Status)"                   "PP speichern"

##------
## File
##
::msgcat::mcset pb_msg_german "MC(main,file,Label)"                    "Datei"

::msgcat::mcset pb_msg_german "MC(main,file,Balloon)"                  "\ Neu, Öffnen, Speichern,\nSpeichern\ Wie, Schließen und Beenden"

::msgcat::mcset pb_msg_german "MC(main,file,Context)"                  "\ Neu, Öffnen, Speichern,\n Speichern\ Wie, Schließen und Beenden"
::msgcat::mcset pb_msg_german "MC(main,file,menu,Context)"             " "

::msgcat::mcset pb_msg_german "MC(main,file,new,Label)"                "Neu ..."
::msgcat::mcset pb_msg_german "MC(main,file,new,Balloon)"              "Neuen Posten erzeugen."
::msgcat::mcset pb_msg_german "MC(main,file,new,Context)"              "Neuen Posten erzeugen."
::msgcat::mcset pb_msg_german "MC(main,file,new,Busy)"                 "Neuen Posten erzeugen ..."

::msgcat::mcset pb_msg_german "MC(main,file,open,Label)"               "Öffnen ..."
::msgcat::mcset pb_msg_german "MC(main,file,open,Balloon)"             "Einen vorhandenen Posten bearbeiten."
::msgcat::mcset pb_msg_german "MC(main,file,open,Context)"             "Einen vorhandenen Posten bearbeiten."
::msgcat::mcset pb_msg_german "MC(main,file,open,Busy)"                "Posten wird geöffnet ..."

::msgcat::mcset pb_msg_german "MC(main,file,mdfa,Label)"               "MDFA importieren ..."
::msgcat::mcset pb_msg_german "MC(main,file,mdfa,Balloon)"             "Neuen Posten aus MDFA erzeugen."
::msgcat::mcset pb_msg_german "MC(main,file,mdfa,Context)"             "Neuen Posten aus MDFA erzeugen."

::msgcat::mcset pb_msg_german "MC(main,file,save,Label)"               "Speichern"
::msgcat::mcset pb_msg_german "MC(main,file,save,Balloon)"             "PP in Bearbeitung speichern."
::msgcat::mcset pb_msg_german "MC(main,file,save,Context)"             "PP in Bearbeitung speichern."
::msgcat::mcset pb_msg_german "MC(main,file,save,Busy)"                "PP wird gespeichert ..."

::msgcat::mcset pb_msg_german "MC(main,file,save_as,Label)"            "Speichern unter ..."
::msgcat::mcset pb_msg_german "MC(main,file,save_as,Balloon)"          "PP in einen neuen Namen speichern."
::msgcat::mcset pb_msg_german "MC(main,file,save_as,Context)"          "PP in einen neuen Namen speichern."

::msgcat::mcset pb_msg_german "MC(main,file,close,Label)"              "Schließen"
::msgcat::mcset pb_msg_german "MC(main,file,close,Balloon)"            "Posten in Bearbeitung speichern."
::msgcat::mcset pb_msg_german "MC(main,file,close,Context)"            "Posten in Bearbeitung speichern."

::msgcat::mcset pb_msg_german "MC(main,file,exit,Label)"               "Beenden"
::msgcat::mcset pb_msg_german "MC(main,file,exit,Balloon)"             "Postprozessor beenden.                                                                                                                                                                                                      "
::msgcat::mcset pb_msg_german "MC(main,file,exit,Context)"             "Postprozessor beenden.                                                                                                                                                                                                      "

::msgcat::mcset pb_msg_german "MC(main,file,history,Label)"            "Kürzlich geöffnete Posten"
::msgcat::mcset pb_msg_german "MC(main,file,history,Balloon)"          "Ein zuvor geprüftes PP bearbeiten."
::msgcat::mcset pb_msg_german "MC(main,file,history,Context)"          "Ein PP bearbeiten, das in der vorherigen Postprozessor-Sitzung überprüft wurde."

##---------
## Options
##
::msgcat::mcset pb_msg_german "MC(main,options,Label)"                 "Optionen"

::msgcat::mcset pb_msg_german "MC(main,options,Balloon)"               " Anwenderdef.\ Befehle\ überprüfen, Stütz-\ PP"
::msgcat::mcset pb_msg_german "MC(main,options,Context)"               " "
::msgcat::mcset pb_msg_german "MC(main,options,menu,Context)"          " "

::msgcat::mcset pb_msg_german "MC(main,windows,Label)"                 "Windows"
::msgcat::mcset pb_msg_german "MC(main,windows,Balloon)"               "Die Liste der Bearbeitungsposten"
::msgcat::mcset pb_msg_german "MC(main,windows,Context)"               " "
::msgcat::mcset pb_msg_german "MC(main,windows,menu,Context)"          " "

::msgcat::mcset pb_msg_german "MC(main,options,properties,Label)"      "Eigenschaften"
::msgcat::mcset pb_msg_german "MC(main,options,properties,Balloon)"    "Eigenschaften"
::msgcat::mcset pb_msg_german "MC(main,options,properties,Context)"    "Eigenschaften"

::msgcat::mcset pb_msg_german "MC(main,options,advisor,Label)"         "PP-Assistent"
::msgcat::mcset pb_msg_german "MC(main,options,advisor,Balloon)"       "PP-Assistent"
::msgcat::mcset pb_msg_german "MC(main,options,advisor,Context)"       "PP-Assistent aktivieren/ deaktivieren"

::msgcat::mcset pb_msg_german "MC(main,options,cmd_check,Label)"       "Anwenderdef. Befehle überprüfen"
::msgcat::mcset pb_msg_german "MC(main,options,cmd_check,Balloon)"     "Anwenderdef. Befehle überprüfen"
::msgcat::mcset pb_msg_german "MC(main,options,cmd_check,Context)"     "Änderungen für Überprüfung der anwenderdef. Befehle"

::msgcat::mcset pb_msg_german "MC(main,options,cmd_check,syntax,Label)"   "Syntaxfehler"
::msgcat::mcset pb_msg_german "MC(main,options,cmd_check,command,Label)"  "Unbekannte Befehle"
::msgcat::mcset pb_msg_german "MC(main,options,cmd_check,block,Label)"    "Unbekannte Blöcke"
::msgcat::mcset pb_msg_german "MC(main,options,cmd_check,address,Label)"  "Unbekannte Adressen"
::msgcat::mcset pb_msg_german "MC(main,options,cmd_check,format,Label)"   "Unbekannte Formate"

::msgcat::mcset pb_msg_german "MC(main,options,backup,Label)"          "PP-Datensicherung"
::msgcat::mcset pb_msg_german "MC(main,options,backup,Balloon)"        "PP-Datensicherungsmethode"
::msgcat::mcset pb_msg_german "MC(main,options,backup,Context)"        "Datensicherheitskopien beim Speichern des PP in Bearbeitung erstellen"

::msgcat::mcset pb_msg_german "MC(main,options,backup,one,Label)"      "Datensicherung des Originals"
::msgcat::mcset pb_msg_german "MC(main,options,backup,all,Label)"      "Datensicherung bei jedem Speichern"
::msgcat::mcset pb_msg_german "MC(main,options,backup,none,Label)"     "Keine Datensicherung"

##-----------
## Utilities
##
::msgcat::mcset pb_msg_german "MC(main,utils,Label)"                   "Dienstprogramme"
::msgcat::mcset pb_msg_german "MC(main,utils,Balloon)"                 "\ MOM-\ Variable\ auswählen, PP\ installieren"
::msgcat::mcset pb_msg_german "MC(main,utils,Context)"                 " "
::msgcat::mcset pb_msg_german "MC(main,utils,menu,Context)"            " "

::msgcat::mcset pb_msg_german "MC(main,utils,etpdf,Label)"             "PP-Vorlagen-Datendatei bearbeiten"

::msgcat::mcset pb_msg_german "MC(main,utils,bmv,Label)"               "MOM-Variablen durchsuchen"
::msgcat::mcset pb_msg_german "MC(main,utils,blic,Label)"              "Lizenzen durchsuchen"


##------
## Help
##
::msgcat::mcset pb_msg_german "MC(main,help,Label)"                    "Hilfe"
::msgcat::mcset pb_msg_german "MC(main,help,Balloon)"                  "Hilfeoptionen"
::msgcat::mcset pb_msg_german "MC(main,help,Context)"                  "Hilfeoptionen"
::msgcat::mcset pb_msg_german "MC(main,help,menu,Context)"             " "

::msgcat::mcset pb_msg_german "MC(main,help,bal,Label)"                "Texthinweis"
::msgcat::mcset pb_msg_german "MC(main,help,bal,Balloon)"              "Texthinweise und Symbole"
::msgcat::mcset pb_msg_german "MC(main,help,bal,Context)"              "Anzeige von Texthinweisen für Symbole aktivieren/ deaktivieren."

::msgcat::mcset pb_msg_german "MC(main,help,chelp,Label)"              "Kontextabhängige Hilfe"
::msgcat::mcset pb_msg_german "MC(main,help,chelp,Balloon)"            "Kontextabhängige Hilfe in Dialogfensterelementen"
::msgcat::mcset pb_msg_german "MC(main,help,chelp,Context)"            "Kontextabhängige Hilfe in Dialogfensterelementen"

::msgcat::mcset pb_msg_german "MC(main,help,what,Label)"               "Was ist zu tun?"
::msgcat::mcset pb_msg_german "MC(main,help,what,Balloon)"             "Was kann hier getan werden?"
::msgcat::mcset pb_msg_german "MC(main,help,what,Context)"             "Was kann hier getan werden?"

::msgcat::mcset pb_msg_german "MC(main,help,dialog,Label)"             "Hilfe zu diesem Dialogfenster"
::msgcat::mcset pb_msg_german "MC(main,help,dialog,Balloon)"           "Hilfe zu diesem Dialogfenster"
::msgcat::mcset pb_msg_german "MC(main,help,dialog,Context)"           "Hilfe zu diesem Dialogfenster"

::msgcat::mcset pb_msg_german "MC(main,help,manual,Label)"             "Benutzerhandbuch"
::msgcat::mcset pb_msg_german "MC(main,help,manual,Balloon)"           "Benutzerhandbuch"
::msgcat::mcset pb_msg_german "MC(main,help,manual,Context)"           "Benutzerhandbuch"

::msgcat::mcset pb_msg_german "MC(main,help,about,Label)"              "Informationen zum Postprozessor"
::msgcat::mcset pb_msg_german "MC(main,help,about,Balloon)"            "Informationen zum Postprozessor"
::msgcat::mcset pb_msg_german "MC(main,help,about,Context)"            "Informationen zum Postprozessor"

::msgcat::mcset pb_msg_german "MC(main,help,rel_note,Label)"           "Versionsinformationen"
::msgcat::mcset pb_msg_german "MC(main,help,rel_note,Balloon)"         "Versionsinformationen"
::msgcat::mcset pb_msg_german "MC(main,help,rel_note,Context)"         "Versionsinformationen"

::msgcat::mcset pb_msg_german "MC(main,help,tcl_man,Label)"            "Tcl/Tk Referenzhandbuch"
::msgcat::mcset pb_msg_german "MC(main,help,tcl_man,Balloon)"          "Tcl/Tk Referenzhandbuch"
::msgcat::mcset pb_msg_german "MC(main,help,tcl_man,Context)"          "Tcl/Tk Referenzhandbuch"

##----------
## Tool Bar
##
::msgcat::mcset pb_msg_german "MC(tool,new,Label)"                     "Neu"
::msgcat::mcset pb_msg_german "MC(tool,new,Context)"                   "Neuen Posten erzeugen."

::msgcat::mcset pb_msg_german "MC(tool,open,Label)"                    "Öffnen"
::msgcat::mcset pb_msg_german "MC(tool,open,Context)"                  "Einen vorhandenen Posten bearbeiten."

::msgcat::mcset pb_msg_german "MC(tool,save,Label)"                    "Speichern"
::msgcat::mcset pb_msg_german "MC(tool,save,Context)"                  "PP in Bearbeitung speichern."

::msgcat::mcset pb_msg_german "MC(tool,bal,Label)"                     "Texthinweis"
::msgcat::mcset pb_msg_german "MC(tool,bal,Context)"                   "Anzeige von Texthinweisen für Symbole aktivieren/ deaktivieren."

::msgcat::mcset pb_msg_german "MC(tool,chelp,Label)"                   "Kontextabhängige Hilfe"
::msgcat::mcset pb_msg_german "MC(tool,chelp,Context)"                 "Kontextabhängige Hilfe in Dialogfensterelementen"

::msgcat::mcset pb_msg_german "MC(tool,what,Label)"                    "Was ist zu tun?"
::msgcat::mcset pb_msg_german "MC(tool,what,Context)"                  "Was kann hier getan werden?"

::msgcat::mcset pb_msg_german "MC(tool,dialog,Label)"                  "Hilfe zu diesem Dialogfenster"
::msgcat::mcset pb_msg_german "MC(tool,dialog,Context)"                "Hilfe zu diesem Dialogfenster"

::msgcat::mcset pb_msg_german "MC(tool,manual,Label)"                  "Benutzerhandbuch"
::msgcat::mcset pb_msg_german "MC(tool,manual,Context)"                "Benutzerhandbuch"

#=============
# Main Window
#=============

##-----------------
## Common Messages
##
::msgcat::mcset pb_msg_german "MC(msg,error,title)"                    "Postprozessor-Fehler"
::msgcat::mcset pb_msg_german "MC(msg,dialog,title)"                   "Postprozessor-Meldung"
::msgcat::mcset pb_msg_german "MC(msg,warning)"                        "Warnung"
::msgcat::mcset pb_msg_german "MC(msg,error)"                          "Fehler"
::msgcat::mcset pb_msg_german "MC(msg,invalid_data)"                   "Für den Parameter wurden ungültige Daten eingegeben"
::msgcat::mcset pb_msg_german "MC(msg,invalid_browser_cmd)"            "Unbekannter Browser-Befehl :"
::msgcat::mcset pb_msg_german "MC(msg,wrong_filename)"                 "Der Dateiname wurde geändert."
::msgcat::mcset pb_msg_german "MC(msg,user_ctrl_limit)"                "Ein lizenzierter Posten kann nicht als Steuerung\n für die Erstellung eines neuen Postens verwendet werden, wenn Sie nicht der Author sind."
::msgcat::mcset pb_msg_german "MC(msg,import_limit)"                   "Sie sind nicht der Author dieses lizenzierten Postens.\n Anwenderdef. Befehle werden u. U. nicht importiert."
::msgcat::mcset pb_msg_german "MC(msg,limit_msg)"                      "Sie sind nicht der Author diese lizenzierten Postens."
::msgcat::mcset pb_msg_german "MC(msg,no_file)"                        "Verschlüsselte Datei ist für diesen lizenzierten Posten nicht vorhanden."
::msgcat::mcset pb_msg_german "MC(msg,no_license)"                     "Sie besitzen keine gültige Lizenz für die Ausführung dieser Funktion."
::msgcat::mcset pb_msg_german "MC(msg,no_license_title)"               "NX/Postprozessor - Nicht lizenzierte Verwendung"
::msgcat::mcset pb_msg_german "MC(msg,no_license_dialog)"              "Es ist zulässig, dass Sie den NX/Postprozessor\n ohne gültige Lizenz verwenden.  Jedoch werden Sie\n Ihre Arbeit nicht speichern können."
::msgcat::mcset pb_msg_german "MC(msg,pending)"                        "Diese Option wird in der zukünftigen Version implementiert."
::msgcat::mcset pb_msg_german "MC(msg,save)"                           "Möchten Sie Ihre Änderungen vor dem\n Schließen des PP in Bearbeitung speichern?"
::msgcat::mcset pb_msg_german "MC(msg,version_check)"                  "Mit einer neueren Version des Postprozessors erzeugtes PP kann nicht in dieser Version geöffnet werden."

::msgcat::mcset pb_msg_german "MC(msg,file_corruption)"                "Fehlerhafte Inhalte in der Postprozessor-Sitzungsdatei."
::msgcat::mcset pb_msg_german "MC(msg,bad_tcl_file)"                   "Fehlerhafte Inhalte in der Tcl-Datei Ihres Postens."
::msgcat::mcset pb_msg_german "MC(msg,bad_def_file)"                   "Fehlerhafte Inhalte in der Definitionsdatei Ihres Postens."
::msgcat::mcset pb_msg_german "MC(msg,invalid_post)"                   "Sie müssen mindestens einen Satz mit Tcl- & Definitionsdateien für Ihr PP festlegen."
::msgcat::mcset pb_msg_german "MC(msg,invalid_dir)"                    "Verzeichnis existiert nicht."
::msgcat::mcset pb_msg_german "MC(msg,invalid_file)"                   "Datei nicht gefunden oder ungültig."
::msgcat::mcset pb_msg_german "MC(msg,invalid_def_file)"               "Definitionsdatei kann nicht geöffnet werden"
::msgcat::mcset pb_msg_german "MC(msg,invalid_tcl_file)"               "Datei mit Ereignis-Behandlungsroutine kann nicht geöffnet werden"
::msgcat::mcset pb_msg_german "MC(msg,dir_perm)"                       "Sie besitzen keinen Schreibzugriff auf das Verzeichnis:"
::msgcat::mcset pb_msg_german "MC(msg,file_perm)"                      "Sie besitzen keine Schreibberechtigung für"

::msgcat::mcset pb_msg_german "MC(msg,file_exist)"                     "ist bereits vorhanden. \nTrotzdem ersetzen?"
::msgcat::mcset pb_msg_german "MC(msg,file_missing)"                   "Einige bzw. alle Dateien für dieses PP fehlen.\n PP kann nicht geöffnet werden."
::msgcat::mcset pb_msg_german "MC(msg,sub_dialog_open)"                "Das Bearbeiten aller Unterdialogfenster \"Parameter\" muss abgeschlossen sein, bevor das PP gespeichert wird."
::msgcat::mcset pb_msg_german "MC(msg,generic)"                        "Postprozessor wurde gegenwärtig nur für allgemeine Fräsmaschinen implementiert."
::msgcat::mcset pb_msg_german "MC(msg,min_word)"                       "Ein Datenblock sollte mindestens ein Wort enthalten."
::msgcat::mcset pb_msg_german "MC(msg,name_exists)"                    "ist bereits vorhanden.\n Einen anderen Namen festlegen."
::msgcat::mcset pb_msg_german "MC(msg,in_use)"                         "Diese Komponente wird verwendet.\n Sie kann nicht gelöscht werden."
::msgcat::mcset pb_msg_german "MC(msg,do_you_want_to_proceed)"         "Als vorhandene Datenelemente annehmen und fortfahren."
::msgcat::mcset pb_msg_german "MC(msg,not_installed_properly)"         "wurde nicht richtig installiert."
::msgcat::mcset pb_msg_german "MC(msg,no_app_to_open)"                 "Keine zu öffnende Anwendung "
::msgcat::mcset pb_msg_german "MC(msg,save_change)"                    "Änderungen speichern?"

::msgcat::mcset pb_msg_german "MC(msg,external_editor)"                "Externer Editor"

# - Do not translate EDITOR
::msgcat::mcset pb_msg_german "MC(msg,set_ext_editor)"                 "Die Umgebungsvariable \"EDITOR\" kann verwendet werden, um den gewünschten Texteditor zu aktivieren."
::msgcat::mcset pb_msg_german "MC(msg,filename_with_space)"            "Dateinamen mit Leerzeichen werden nicht unterstützt."
::msgcat::mcset pb_msg_german "MC(msg,filename_protection)"            "Die von einem Bearbeitungsposten verwendete ausgewählte Datei darf nicht überschrieben werden."


##--------------------
## Common Function
##
::msgcat::mcset pb_msg_german "MC(msg,parent_win)"                     "Ein temporäres Fenster erfordert, dass sein übergeordnetes Fenster definiert ist."
::msgcat::mcset pb_msg_german "MC(msg,close_subwin)"                   "Alle untergeordneten Fenster müssen geschlossen sein, um diese Registerkarte zu aktivieren."
::msgcat::mcset pb_msg_german "MC(msg,block_exist)"                    "Ein Element des ausgewählten Wortes existiert in der Datenblock-Vorlage."
::msgcat::mcset pb_msg_german "MC(msg,num_gcode_1)"                    "Anzahl von G - Codes sind beschränkt auf"
::msgcat::mcset pb_msg_german "MC(msg,num_gcode_2)"                    "pro Datenblock"
::msgcat::mcset pb_msg_german "MC(msg,num_mcode_1)"                    "Anzahl von M - Codes sind beschränkt auf"
::msgcat::mcset pb_msg_german "MC(msg,num_mcode_2)"                    "pro Datenblock"
::msgcat::mcset pb_msg_german "MC(msg,empty_entry)"                    "Der Eintrag sollte nicht leer sein."

::msgcat::mcset pb_msg_german "MC(msg,edit_feed_fmt)"                  "Formate für Adresse \"F\" können auf der Vorschub-Parameterseite bearbeitet werden"

::msgcat::mcset pb_msg_german "MC(msg,seq_num_max)"                    "Der maximale Wert der Sequenznummer sollte nicht überschreiten die zugewiesene N-Kapazität von"

::msgcat::mcset pb_msg_german "MC(msg,no_cdl_name)"                    "Der PP-Name sollte festgelegt sein."
::msgcat::mcset pb_msg_german "MC(msg,no_def_name)"                    "Der Ordner sollte festgelegt sein.\n Und das Muster sollte \"\$UGII_*\"sein."
::msgcat::mcset pb_msg_german "MC(msg,no_own_name)"                    "Der Ordner sollte festgelegt sein.\n Und das Muster sollte \"\$UGII_*\"sein."
::msgcat::mcset pb_msg_german "MC(msg,no_oth_ude_name)"                "Der andere cdl-Dateiname sollte festgelegt sein.\n Und das Muster sollte \"\$UGII_*\"sein."
::msgcat::mcset pb_msg_german "MC(msg,not_oth_cdl_file)"               "Nur CDL-Datei ist zulässig."
::msgcat::mcset pb_msg_german "MC(msg,not_pui_file)"                   "Nur PUI-Datei ist zulässig."
::msgcat::mcset pb_msg_german "MC(msg,not_cdl_file)"                   "Nur CDL-Datei ist zulässig."
::msgcat::mcset pb_msg_german "MC(msg,not_def_file)"                   "Nur DEF-Datei ist zulässig."
::msgcat::mcset pb_msg_german "MC(msg,not_own_cdl_file)"               "Nur eigene CDL-Datei ist zulässig."
::msgcat::mcset pb_msg_german "MC(msg,no_cdl_file)"                    "Das ausgewählte PP enthält keine verknüpfte CDL-Datei."
::msgcat::mcset pb_msg_german "MC(msg,cdl_info)"                       "Die CDL- und Definitionsdateien des ausgewählten Postens werden in der Definitionsdatei dieses Postens referenziert (EINSCHLIESSEN).\n Und die Tcl-Datei des ausgewählten Postens wird während der Laufzeit von der Datei mit Ereignis-Behandlungsroutine dieses Postens als Ausgangspunkt verwendet."

::msgcat::mcset pb_msg_german "MC(msg,add_max1)"                       "Maximaler Adresswert"
::msgcat::mcset pb_msg_german "MC(msg,add_max2)"                       "sollte nicht überschreiten die Kapazität des Formats von"


::msgcat::mcset pb_msg_german "MC(com,text_entry_trans,title,Label)"   "Eintrag"

##---------------------------
## Common Navigation Buttons
##
::msgcat::mcset pb_msg_german "MC(nav_button,no_license,Message)"      "Sie besitzen keine gültige Lizenz für die Ausführung dieser Funktion."

::msgcat::mcset pb_msg_german "MC(nav_button,ok,Label)"                "OK"
::msgcat::mcset pb_msg_german "MC(nav_button,ok,Context)"              "Diese Schaltfläche ist nur in einem Unterdialogfenster verfügbar. Damit können Änderungen gespeichert und das Dialogfenster geschlossen werden."
::msgcat::mcset pb_msg_german "MC(nav_button,cancel,Label)"            "Abbrechen"
::msgcat::mcset pb_msg_german "MC(nav_button,cancel,Context)"          "Diese Schaltfläche ist nur in einem Unterdialogfenster verfügbar. Damit kann das Dialogfenster geschlossen werden."
::msgcat::mcset pb_msg_german "MC(nav_button,default,Label)"           "Standard"
::msgcat::mcset pb_msg_german "MC(nav_button,default,Context)"         "Mit dieser Schaltfläche können die Parameter im aktuellen Dialogfenster für eine Komponente bis zu der Bedingung wieder hergestellt werden, bei welcher der PP in Sitzung erzeugt bzw. geöffnet wurde. \n \nJedoch wird der Name der fraglichen Komponente, falls verfügbar, nur bis zum Ausgangstatus der aktuell geöffneten Komponente wieder hergestellt."
::msgcat::mcset pb_msg_german "MC(nav_button,restore,Label)"           "Wiederherstellen"
::msgcat::mcset pb_msg_german "MC(nav_button,restore,Context)"         "Mit dieser Schaltfläche können die Parameter im aktuellen Dialogfenster auf die Ausgangseinstellungen der aktuell geöffneten Komponente wieder hergestellt werden."
::msgcat::mcset pb_msg_german "MC(nav_button,apply,Label)"             "Anwenden"
::msgcat::mcset pb_msg_german "MC(nav_button,apply,Context)"           "Mit dieser Schaltfläche können Änderungen ohne das Schließen des aktuellen Dialogfensters gespeichert werden.  Dadurch wird auch die Ausgangsbedingung des aktuellen Dialogfensters wieder hergestellt. \n \n(Siehe \"Wiederherstellen\" für die Ausgangsbedingung)"
::msgcat::mcset pb_msg_german "MC(nav_button,filter,Label)"            "Filter"
::msgcat::mcset pb_msg_german "MC(nav_button,filter,Context)"          "Mit dieser Schaltfläche wird der Verzeichnisfilter angewendet und Dateien aufgelistet, die die Bedingung erfüllen."
::msgcat::mcset pb_msg_german "MC(nav_button,yes,Label)"               "Ja"
::msgcat::mcset pb_msg_german "MC(nav_button,yes,Context)"             "Ja"
::msgcat::mcset pb_msg_german "MC(nav_button,no,Label)"                "Nein"
::msgcat::mcset pb_msg_german "MC(nav_button,no,Context)"              "Nein"
::msgcat::mcset pb_msg_german "MC(nav_button,help,Label)"              "Hilfe"
::msgcat::mcset pb_msg_german "MC(nav_button,help,Context)"            "Hilfe"

::msgcat::mcset pb_msg_german "MC(nav_button,open,Label)"              "Öffnen"
::msgcat::mcset pb_msg_german "MC(nav_button,open,Context)"            "Diese Schaltfläche ermöglicht das Öffnen des ausgewählten Postens zur Bearbeitung."

::msgcat::mcset pb_msg_german "MC(nav_button,save,Label)"              "Speichern"
::msgcat::mcset pb_msg_german "MC(nav_button,save,Context)"            "Diese Schaltfläche steht im Dialogfenster \"Speichern Unter\" zur Verfügung, was Ihnen das Speichern des PPs in Bearbeitung ermöglicht."

::msgcat::mcset pb_msg_german "MC(nav_button,manage,Label)"            "Verwalten ..."
::msgcat::mcset pb_msg_german "MC(nav_button,manage,Context)"          "Diese Schaltfläche ermöglicht das Verwalten der Historie des kürzlich überprüften PPs."

::msgcat::mcset pb_msg_german "MC(nav_button,refresh,Label)"           "Aktualisieren"
::msgcat::mcset pb_msg_german "MC(nav_button,refresh,Context)"         "Mit dieser Schaltfläche wird die Liste entsprechend der Existenz von Objekten aktualisiert."

::msgcat::mcset pb_msg_german "MC(nav_button,cut,Label)"               "Schnitt"
::msgcat::mcset pb_msg_german "MC(nav_button,cut,Context)"             "Mit dieser Schaltfläche wird das ausgewählte Objekt von der Liste entfernt."

::msgcat::mcset pb_msg_german "MC(nav_button,copy,Label)"              "Kopieren"
::msgcat::mcset pb_msg_german "MC(nav_button,copy,Context)"            "Mit dieser Schaltfläche wir das ausgewählte Objekt kopiert."

::msgcat::mcset pb_msg_german "MC(nav_button,paste,Label)"             "Einfügen"
::msgcat::mcset pb_msg_german "MC(nav_button,paste,Context)"           "Mit dieser Schaltfläche wird das Objekt in den Puffer und zurück in die Liste eingefügt."

::msgcat::mcset pb_msg_german "MC(nav_button,edit,Label)"              "Bearbeiten"
::msgcat::mcset pb_msg_german "MC(nav_button,edit,Context)"            "Mit dieser Schaltfläche wird das Objekt im Puffer bearbeitet."

::msgcat::mcset pb_msg_german "MC(nav_button,ex_editor,Label)"         "Externen Editor verwenden"

##------------
## New dialog
##
::msgcat::mcset pb_msg_german "MC(new,title,Label)"                    "Neuen Postprozessor erstellen"
::msgcat::mcset pb_msg_german "MC(new,Status)"                         "Name eingeben & Parameter für das neue PP auswählen."

::msgcat::mcset pb_msg_german "MC(new,name,Label)"                     "PP-Name"
::msgcat::mcset pb_msg_german "MC(new,name,Context)"                   "Name des zu erzeugenden Postprozessors"

::msgcat::mcset pb_msg_german "MC(new,desc,Label)"                     "Beschreibung"
::msgcat::mcset pb_msg_german "MC(new,desc,Context)"                   "Beschreibung des zu erzeugenden Postprozessors"

#Description for each selection
::msgcat::mcset pb_msg_german "MC(new,mill,desc,Label)"                "Dies ist eine Fräsmaschine."
::msgcat::mcset pb_msg_german "MC(new,lathe,desc,Label)"               "Dies ist eine Drehmaschine."
::msgcat::mcset pb_msg_german "MC(new,wedm,desc,Label)"                "Dies ist eine Drahterodieren-Maschine."

::msgcat::mcset pb_msg_german "MC(new,wedm_2,desc,Label)"              "Dies ist eine 2-achsige Drahterodieren-Maschine."
::msgcat::mcset pb_msg_german "MC(new,wedm_4,desc,Label)"              "Dies ist eine 4-achsige Drahterodieren-Maschine."
::msgcat::mcset pb_msg_german "MC(new,lathe_2,desc,Label)"             "Dies ist eine 2-achsige horizontale Drehmaschine."
::msgcat::mcset pb_msg_german "MC(new,lathe_4,desc,Label)"             "Dies ist eine 4-achsige abhängige Drehmaschine."
::msgcat::mcset pb_msg_german "MC(new,mill_3,desc,Label)"              "Dies ist eine 3-achsige Fräsmaschine."
::msgcat::mcset pb_msg_german "MC(new,mill_3MT,desc,Label)"            "3-achsige Fräs-Drehmaschine (XZC)"
::msgcat::mcset pb_msg_german "MC(new,mill_4H,desc,Label)"             "Dies ist eine 4-achsige Fräsmaschine mit\n Rotationskopf."
::msgcat::mcset pb_msg_german "MC(new,mill_4T,desc,Label)"             "Dies ist eine 4-achsige Fräsmaschine mit\n Drehtisch."
::msgcat::mcset pb_msg_german "MC(new,mill_5TT,desc,Label)"            "Dies ist eine 5-achsige Fräsmaschine mit\n Doppeldrehtisch."
::msgcat::mcset pb_msg_german "MC(new,mill_5HH,desc,Label)"            "Dies ist eine 5-achsige Fräsmaschine mit\n Doppel-Rotationsköpfen."
::msgcat::mcset pb_msg_german "MC(new,mill_5HT,desc,Label)"            "Dies ist eine 5-achsige Fräsmaschine mit\n Rotationskopf und Drehtisch."
::msgcat::mcset pb_msg_german "MC(new,punch,desc,Label)"               "Dies ist eine Stanzmaschine."

::msgcat::mcset pb_msg_german "MC(new,post_unit,Label)"                "PP-Ausgabeeinheit"

::msgcat::mcset pb_msg_german "MC(new,inch,Label)"                     "Zoll"
::msgcat::mcset pb_msg_german "MC(new,inch,Context)"                   "Postprozessor-Ausgabeeinheit - Zoll"
::msgcat::mcset pb_msg_german "MC(new,millimeter,Label)"               "Millimeter"
::msgcat::mcset pb_msg_german "MC(new,millimeter,Context)"             "Postprozessor-Ausgabeeinheit - Millimeter"

::msgcat::mcset pb_msg_german "MC(new,machine,Label)"                  "Wkz-Maschine"
::msgcat::mcset pb_msg_german "MC(new,machine,Context)"                "Der Wkz-Maschinentyp, für den der Postprozessor erzeugt werden soll."

::msgcat::mcset pb_msg_german "MC(new,mill,Label)"                     "Fräsen"
::msgcat::mcset pb_msg_german "MC(new,mill,Context)"                   "Fräsmaschine"
::msgcat::mcset pb_msg_german "MC(new,lathe,Label)"                    "Drehen"
::msgcat::mcset pb_msg_german "MC(new,lathe,Context)"                  "Drehmaschine"
::msgcat::mcset pb_msg_german "MC(new,wire,Label)"                     "Drahterodieren"
::msgcat::mcset pb_msg_german "MC(new,wire,Context)"                   "Drahterodieren-Maschine"
::msgcat::mcset pb_msg_german "MC(new,punch,Label)"                    "Stanzen"

::msgcat::mcset pb_msg_german "MC(new,axis,Label)"                     "Maschinenachsenauswahl"
::msgcat::mcset pb_msg_german "MC(new,axis,Context)"                   "Anzahl und Typ der Maschinenachsen"

#Axis Number
::msgcat::mcset pb_msg_german "MC(new,axis_2,Label)"                   "2-Achsen"
::msgcat::mcset pb_msg_german "MC(new,axis_3,Label)"                   "3-Achsen"
::msgcat::mcset pb_msg_german "MC(new,axis_4,Label)"                   "4-Achsen"
::msgcat::mcset pb_msg_german "MC(new,axis_5,Label)"                   "5-achsig"
::msgcat::mcset pb_msg_german "MC(new,axis_XZC,Label)"                 "XZC"


#Axis Type
::msgcat::mcset pb_msg_german "MC(new,mach_axis,Label)"                "Wkz-Maschinen-Ausgabe"
::msgcat::mcset pb_msg_german "MC(new,mach_axis,Context)"              "Wkz-Maschinen-Achse auswählen"
::msgcat::mcset pb_msg_german "MC(new,lathe_2,Label)"                  "2-Achsen"
::msgcat::mcset pb_msg_german "MC(new,mill_3,Label)"                   "3-Achsen"
::msgcat::mcset pb_msg_german "MC(new,mill_3MT,Label)"                 "3-achsige Fräs-Drehmaschine (XZC)"
::msgcat::mcset pb_msg_german "MC(new,mill_4T,Label)"                  "4 Achsen mit Drehtisch"
::msgcat::mcset pb_msg_german "MC(new,mill_4H,Label)"                  "4 Achsen mit Rotationskopf"
::msgcat::mcset pb_msg_german "MC(new,lathe_4,Label)"                  "4-Achsen"
::msgcat::mcset pb_msg_german "MC(new,mill_5HH,Label)"                 "5 Achsen mit Doppel-Rotationsköpfen"
::msgcat::mcset pb_msg_german "MC(new,mill_5TT,Label)"                 "5 Achsen mit Doppeldrehtischen"
::msgcat::mcset pb_msg_german "MC(new,mill_5HT,Label)"                 "5 Achsen mit Rotationskopf und Drehtisch"
::msgcat::mcset pb_msg_german "MC(new,wedm_2,Label)"                   "2-Achsen"
::msgcat::mcset pb_msg_german "MC(new,wedm_4,Label)"                   "4-Achsen"
::msgcat::mcset pb_msg_german "MC(new,punch,Label)"                    "Stanzen"

::msgcat::mcset pb_msg_german "MC(new,control,Label)"                  "Steuerung"
::msgcat::mcset pb_msg_german "MC(new,control,Context)"                "PP-Steuerung auswählen"

#Controller Type
::msgcat::mcset pb_msg_german "MC(new,generic,Label)"                  "Allgemein"
::msgcat::mcset pb_msg_german "MC(new,library,Label)"                  "Bibliothek"
::msgcat::mcset pb_msg_german "MC(new,user,Label)"                     "Anwender"
::msgcat::mcset pb_msg_german "MC(new,user,browse,Label)"              "Durchsuchen"

# - Machine tool/ controller brands
::msgcat::mcset pb_msg_german "MC(new,allen,Label)"                    "Allen Bradley"
::msgcat::mcset pb_msg_german "MC(new,bridge,Label)"                   "Bridgeport"
::msgcat::mcset pb_msg_german "MC(new,brown,Label)"                    "Brown & Sharp"
::msgcat::mcset pb_msg_german "MC(new,cincin,Label)"                   "Cincinnatti Milacron"
::msgcat::mcset pb_msg_german "MC(new,kearny,Label)"                   "Kearny & Tracker"
::msgcat::mcset pb_msg_german "MC(new,fanuc,Label)"                    "Fanuc"
::msgcat::mcset pb_msg_german "MC(new,ge,Label)"                       "General Electric"
::msgcat::mcset pb_msg_german "MC(new,gn,Label)"                       "General Numerics"
::msgcat::mcset pb_msg_german "MC(new,gidding,Label)"                  "Gidding & Lewis"
::msgcat::mcset pb_msg_german "MC(new,heiden,Label)"                   "Heidenhain"
::msgcat::mcset pb_msg_german "MC(new,mazak,Label)"                    "Mazak"
::msgcat::mcset pb_msg_german "MC(new,seimens,Label)"                  "Siemens"

##-------------
## Open dialog
##
::msgcat::mcset pb_msg_german "MC(open,title,Label)"                   "PP bearbeiten"
::msgcat::mcset pb_msg_german "MC(open,Status)"                        "Eine zu öffnende PUI-Datei auswählen."
::msgcat::mcset pb_msg_german "MC(open,file_type_pui)"                 "Postprozessor-Sitzungsdateien"
::msgcat::mcset pb_msg_german "MC(open,file_type_tcl)"                 "Tcl-Skripdateien"
::msgcat::mcset pb_msg_german "MC(open,file_type_def)"                 "Definitionsdateien"
::msgcat::mcset pb_msg_german "MC(open,file_type_cdl)"                 "CDL-Dateien"

##-------------
## Misc dialog
##
::msgcat::mcset pb_msg_german "MC(open_save,dlg,title,Label)"          "Wählen Sie eine Datei."
::msgcat::mcset pb_msg_german "MC(exp_cc,dlg,title,Label)"             "Anwenderdefinierte Befehle exportieren"
::msgcat::mcset pb_msg_german "MC(show_mt,title,Label)"                "Wkz-Maschine"

##----------------
## Utils dialog
##
::msgcat::mcset pb_msg_german "MC(mvb,title,Label)"                    "MOM-Variablenbrowser"
::msgcat::mcset pb_msg_german "MC(mvb,cat,Label)"                      "Kategorie"
::msgcat::mcset pb_msg_german "MC(mvb,search,Label)"                   "Suchen"
::msgcat::mcset pb_msg_german "MC(mvb,defv,Label)"                     "Standardwert"
::msgcat::mcset pb_msg_german "MC(mvb,posv,Label)"                     "Mögliche Werte"
::msgcat::mcset pb_msg_german "MC(mvb,data,Label)"                     "Datentyp"
::msgcat::mcset pb_msg_german "MC(mvb,desc,Label)"                     "Beschreibung"

::msgcat::mcset pb_msg_german "MC(inposts,title,Label)"                "Bearbeiten von \"template_post.dat\""
::msgcat::mcset pb_msg_german "MC(tpdf,text,Label)"                    "PP-Vorlagen-Datendatei"
::msgcat::mcset pb_msg_german "MC(inposts,edit,title,Label)"           "Eine Linie bearbeiten"
::msgcat::mcset pb_msg_german "MC(inposts,edit,post,Label)"            "Posten"


##----------------
## Save As dialog
##
::msgcat::mcset pb_msg_german "MC(save_as,title,Label)"                "Speichern unter"
::msgcat::mcset pb_msg_german "MC(save_as,name,Label)"                 "PP-Name"
::msgcat::mcset pb_msg_german "MC(save_as,name,Context)"               "Der Name, mit dem der Postprozessor gespeichert werden soll."
::msgcat::mcset pb_msg_german "MC(save_as,Status)"                     "Den neuen PP-Dateinamen eingeben."
::msgcat::mcset pb_msg_german "MC(save_as,file_type_pui)"              "Postprozessor-Sitzungsdateien"

##----------------
## Common Widgets
##
::msgcat::mcset pb_msg_german "MC(common,entry,Label)"                 "Eintrag"
::msgcat::mcset pb_msg_german "MC(common,entry,Context)"               "Sie werden einen neuen Wert im Eingabefeld festlegen."

##-----------
## Note Book
##
::msgcat::mcset pb_msg_german "MC(nbook,tab,Label)"                    "Notizbuch-Registerkarte"
::msgcat::mcset pb_msg_german "MC(nbook,tab,Context)"                  "Eine Registerkarte kann ausgewählt werden, um zur gewünschten Parameterseite zu gelangen. \n \nDie Parameter in einer Registerkarte sind u. U. in Gruppen unterteilt. Auf jede Parametergruppe kann mit einer anderen Registerkarte zugegriffen werden."

##------
## Tree
##
::msgcat::mcset pb_msg_german "MC(tree,select,Label)"                  "Komponentenbaum"
::msgcat::mcset pb_msg_german "MC(tree,select,Context)"                "Sie können eine anzuzeigende Komponente auswählen, oder deren Inhalt bzw. Parameter bearbeiten."
::msgcat::mcset pb_msg_german "MC(tree,create,Label)"                  "Erzeugen"
::msgcat::mcset pb_msg_german "MC(tree,create,Context)"                "Eine neue Komponente durch Kopieren des ausgewählten Elements erstellen."
::msgcat::mcset pb_msg_german "MC(tree,cut,Label)"                     "Schnitt"
::msgcat::mcset pb_msg_german "MC(tree,cut,Context)"                   "Eine Komponente ausschneiden."
::msgcat::mcset pb_msg_german "MC(tree,paste,Label)"                   "Einfügen"
::msgcat::mcset pb_msg_german "MC(tree,paste,Context)"                 "Eine Komponente einfügen."
::msgcat::mcset pb_msg_german "MC(tree,rename,Label)"                  "Umbenennen"

##------------------
## Encrypt dialogs
##
::msgcat::mcset pb_msg_german "MC(encrypt,browser,Label)"              "Lizenzen-Liste"
::msgcat::mcset pb_msg_german "MC(encrypt,title,Label)"                "Eine Lizenz auswählen"
::msgcat::mcset pb_msg_german "MC(encrypt,output,Label)"               "Verschlüsselte Ausgabe"
::msgcat::mcset pb_msg_german "MC(encrypt,license,Label)"              "Lizenz:  "

#++++++++++++++
# Machine Tool
#++++++++++++++
::msgcat::mcset pb_msg_german "MC(machine,tab,Label)"                  "Wkz-Maschine"
::msgcat::mcset pb_msg_german "MC(machine,Status)"                     "Maschinen-Kinematik-Parameter festlegen."

::msgcat::mcset pb_msg_german "MC(msg,no_display)"                     "Ein Bild für diese Wkz-Maschinen-Konfiguration ist nicht verfügbar."
::msgcat::mcset pb_msg_german "MC(msg,no_4th_ctable)"                  "4. Achse - C-Tabelle ist nicht zulässig."
::msgcat::mcset pb_msg_german "MC(msg,no_4th_max_min)"                 "4. Achse - maximale Achsenbegrenzung darf nicht mit minimaler Achsenbegrenzung übereinstimmen."
::msgcat::mcset pb_msg_german "MC(msg,no_4th_both_neg)"                "Begrenzungen der 4. Achse dürfen nicht beide negativ sein."
::msgcat::mcset pb_msg_german "MC(msg,no_4th_5th_plane)"               "Ebene der 4. Achse darf nicht mit Ebene der 5. Achse identisch sein."
::msgcat::mcset pb_msg_german "MC(msg,no_4thT_5thH)"                   "4. Achsentabelle und 5. Achsenkopf sind nicht zulässig."
::msgcat::mcset pb_msg_german "MC(msg,no_5th_max_min)"                 "Maximale Achsenbegrenzung der 5. Achse darf nicht mit der minimalen Achsenbegrenzung übereinstimmen."
::msgcat::mcset pb_msg_german "MC(msg,no_5th_both_neg)"                "Begrenzungen der 5. Achse dürfen nicht beide negativ sein."

##---------
# Post Info
##
::msgcat::mcset pb_msg_german "MC(machine,info,title,Label)"           "PP-Informationen"
::msgcat::mcset pb_msg_german "MC(machine,info,desc,Label)"            "Beschreibung"
::msgcat::mcset pb_msg_german "MC(machine,info,type,Label)"            "Maschinentyp"
::msgcat::mcset pb_msg_german "MC(machine,info,kinematics,Label)"      "Kinematik"
::msgcat::mcset pb_msg_german "MC(machine,info,unit,Label)"            "Ausgabeeinheit"
::msgcat::mcset pb_msg_german "MC(machine,info,controller,Label)"      "Steuerung"
::msgcat::mcset pb_msg_german "MC(machine,info,history,Label)"         "Historie"

##---------
## Display
##
::msgcat::mcset pb_msg_german "MC(machine,display,Label)"              "Wkz-Maschine anzeigen"
::msgcat::mcset pb_msg_german "MC(machine,display,Context)"            "Mit dieser Option kann die Wkz-Maschine angezeigt werden."
::msgcat::mcset pb_msg_german "MC(machine,display_trans,title,Label)"  "Wkz-Maschine"


##---------------
## General parms
##
::msgcat::mcset pb_msg_german "MC(machine,gen,Label)"                      "Allgemeine Parameter"
    
::msgcat::mcset pb_msg_german "MC(machine,gen,out_unit,Label)"             "PP-Ausgabeeinheit :"
::msgcat::mcset pb_msg_german "MC(machine,gen,out_unit,Context)"           "PP-Ausgabeeinheit"
::msgcat::mcset pb_msg_german "MC(machine,gen,out_unit,inch,Label)"        "Zoll" 
::msgcat::mcset pb_msg_german "MC(machine,gen,out_unit,metric,Label)"      "Metrisch"

::msgcat::mcset pb_msg_german "MC(machine,gen,travel_limit,Label)"         "Weggrenzen der linearen Achse"
::msgcat::mcset pb_msg_german "MC(machine,gen,travel_limit,Context)"       "Weggrenzen der linearen Achse"
::msgcat::mcset pb_msg_german "MC(machine,gen,travel_limit,x,Label)"       "X"
::msgcat::mcset pb_msg_german "MC(machine,gen,travel_limit,x,Context)"     "Maschinen-Weggrenze entlang X-Achse definieren."
::msgcat::mcset pb_msg_german "MC(machine,gen,travel_limit,y,Label)"       "Y"
::msgcat::mcset pb_msg_german "MC(machine,gen,travel_limit,y,Context)"     "Maschinen-Weggrenze entlang Y-Achse definieren."
::msgcat::mcset pb_msg_german "MC(machine,gen,travel_limit,z,Label)"       "Z"
::msgcat::mcset pb_msg_german "MC(machine,gen,travel_limit,z,Context)"     "Maschinen-Weggrenze entlang Z-Achse definieren."

::msgcat::mcset pb_msg_german "MC(machine,gen,home_pos,Label)"             "Ausgangsposition"
::msgcat::mcset pb_msg_german "MC(machine,gen,home_pos,Context)"           "Ausgangsposition"
::msgcat::mcset pb_msg_german "MC(machine,gen,home_pos,x,Label)"           "X"
::msgcat::mcset pb_msg_german "MC(machine,gen,home_pos,x,Context)"         "Maschinen-Ausgangsposition der X-Achse bezüglich der physischen Nullposition der Achse.  Maschine kehrt für automatischen Wkz-Wechsel zu dieser Position zurück."
::msgcat::mcset pb_msg_german "MC(machine,gen,home_pos,y,Label)"           "Y"
::msgcat::mcset pb_msg_german "MC(machine,gen,home_pos,y,Context)"         "Maschinen-Ausgangsposition der Y-Achse bezüglich der physischen Nullposition der Achse.  Maschine kehrt für automatischen Wkz-Wechsel zu dieser Position zurück."
::msgcat::mcset pb_msg_german "MC(machine,gen,home_pos,z,Label)"           "Z"
::msgcat::mcset pb_msg_german "MC(machine,gen,home_pos,z,Context)"         "Maschinen-Ausgangsposition der Z-Achse bezüglich der physischen Nullposition der Achse.  Maschine kehrt für automatischen Wkz-Wechsel zu dieser Position zurück."

::msgcat::mcset pb_msg_german "MC(machine,gen,step_size,Label)"            "Lineare Bewegungsauflösung"
::msgcat::mcset pb_msg_german "MC(machine,gen,step_size,min,Label)"        "Minimum"
::msgcat::mcset pb_msg_german "MC(machine,gen,step_size,min,Context)"      "Minimale Auflösung"

::msgcat::mcset pb_msg_german "MC(machine,gen,traverse_feed,Label)"        "Querungsvorschub"
::msgcat::mcset pb_msg_german "MC(machine,gen,traverse_feed,max,Label)"    "Maximum"
::msgcat::mcset pb_msg_german "MC(machine,gen,traverse_feed,max,Context)"  "Maximaler Vorschub"

::msgcat::mcset pb_msg_german "MC(machine,gen,circle_record,Label)"        "Kreisspurverfahren ausgeben"
::msgcat::mcset pb_msg_german "MC(machine,gen,circle_record,yes,Label)"    "Ja"
::msgcat::mcset pb_msg_german "MC(machine,gen,circle_record,yes,Context)"  "Kreisspurverfahren ausgeben."
::msgcat::mcset pb_msg_german "MC(machine,gen,circle_record,no,Label)"     "Nein"
::msgcat::mcset pb_msg_german "MC(machine,gen,circle_record,no,Context)"   "Linearspurverfahren ausgeben."

::msgcat::mcset pb_msg_german "MC(machine,gen,config_4and5_axis,oth,Label)"    "Sonstige"

# Wire EDM parameters
::msgcat::mcset pb_msg_german "MC(machine,gen,wedm,wire_tilt)"             "Drahtbiegesteuerung"
::msgcat::mcset pb_msg_german "MC(machine,gen,wedm,angle)"                 "Winkel"
::msgcat::mcset pb_msg_german "MC(machine,gen,wedm,coord)"                 "Koordinaten"

# Lathe parameters
::msgcat::mcset pb_msg_german "MC(machine,gen,turret,Label)"               "Revolverkopf"
::msgcat::mcset pb_msg_german "MC(machine,gen,turret,Context)"             "Revolverkopf"
::msgcat::mcset pb_msg_german "MC(machine,gen,turret,conf,Label)"          "Konfigurieren"
::msgcat::mcset pb_msg_german "MC(machine,gen,turret,conf,Context)"        "Wenn \"Zwei Revolver\" ausgewählt ist, erlaubt diese Option die Konfiguration der Parameter."
::msgcat::mcset pb_msg_german "MC(machine,gen,turret,one,Label)"           "Einzelrevolver"
::msgcat::mcset pb_msg_german "MC(machine,gen,turret,one,Context)"         "Einzelrevolver-Drehmaschine"
::msgcat::mcset pb_msg_german "MC(machine,gen,turret,two,Label)"           "Zwei Revolverköpfe"
::msgcat::mcset pb_msg_german "MC(machine,gen,turret,two,Context)"         "Zwei-Revolverdrehmaschine"

::msgcat::mcset pb_msg_german "MC(machine,gen,turret,conf_trans,Label)"    "Revolverkopf-Konfiguration"
::msgcat::mcset pb_msg_german "MC(machine,gen,turret,prim,Label)"          "Primärer Revolverkopf"
::msgcat::mcset pb_msg_german "MC(machine,gen,turret,prim,Context)"        "Ziel für primären Revolverkopf auswählen."
::msgcat::mcset pb_msg_german "MC(machine,gen,turret,sec,Label)"           "Sekundärer Revolverkopf"
::msgcat::mcset pb_msg_german "MC(machine,gen,turret,sec,Context)"         "Ziel für sekundären Revolverkopf auswählen."
::msgcat::mcset pb_msg_german "MC(machine,gen,turret,designation,Label)"   "Bezeichnung"
::msgcat::mcset pb_msg_german "MC(machine,gen,turret,xoff,Label)"          "X-Offset"
::msgcat::mcset pb_msg_german "MC(machine,gen,turret,xoff,Context)"        "X-Offset festlegen"
::msgcat::mcset pb_msg_german "MC(machine,gen,turret,zoff,Label)"          "Z-Offset"
::msgcat::mcset pb_msg_german "MC(machine,gen,turret,zoff,Context)"        "Z-Offset festlegen"

::msgcat::mcset pb_msg_german "MC(machine,gen,turret,front,Label)"         "Vorne"
::msgcat::mcset pb_msg_german "MC(machine,gen,turret,rear,Label)"          "Hinten"
::msgcat::mcset pb_msg_german "MC(machine,gen,turret,right,Label)"         "Rechts"
::msgcat::mcset pb_msg_german "MC(machine,gen,turret,left,Label)"          "Links"
::msgcat::mcset pb_msg_german "MC(machine,gen,turret,side,Label)"          "Seite"
::msgcat::mcset pb_msg_german "MC(machine,gen,turret,saddle,Label)"        "Sattel"

::msgcat::mcset pb_msg_german "MC(machine,gen,axis_multi,Label)"           "Achsen-Multiplikator"
::msgcat::mcset pb_msg_german "MC(machine,gen,axis_multi,dia,Label)"       "Durchmesser-Programmierung"
::msgcat::mcset pb_msg_german "MC(machine,gen,axis_multi,dia,Context)"     "Diese Option ermöglicht die Aktivierung der Durchmesser-Programmierung durch Verdopplung der ausgewählten Adressen in der N/C-Ausgabe."
::msgcat::mcset pb_msg_german "MC(machine,gen,axis_multi,2x,Label)"        "2X"
::msgcat::mcset pb_msg_german "MC(machine,gen,axis_multi,2x,Context)"      "Dieser Schalter ermöglicht die Aktivierung der Durchmesser-Programmierung durch Verdopplung der X-Achsenkoordinaten in der N/C-Ausgabe."

::msgcat::mcset pb_msg_german "MC(machine,gen,axis_multi,2y,Label)"        "2Y"
::msgcat::mcset pb_msg_german "MC(machine,gen,axis_multi,2y,Context)"      "Dieser Schalter ermöglicht die Durchmesser-Programmierung durch Verdopplung der Y-Achsenkoordinaten in der N/C-Ausgabe."
::msgcat::mcset pb_msg_german "MC(machine,gen,axis_multi,2i,Label)"        "2I"
::msgcat::mcset pb_msg_german "MC(machine,gen,axis_multi,2i,Context)"      "Dieser Schalter ermöglicht die Verdopplung der Werte von \"I\" der Kreisspurverfahren, wenn die Durchmesser-Programmierung verwendet wird."
::msgcat::mcset pb_msg_german "MC(machine,gen,axis_multi,2j,Label)"        "2J"
::msgcat::mcset pb_msg_german "MC(machine,gen,axis_multi,2j,Context)"      "Dieser Schalter ermöglicht die Verdopplung der Werte von \"J\" der Kreisspurverfahren, wenn die Durchmesser-Programmierung verwendet wird."

::msgcat::mcset pb_msg_german "MC(machine,gen,axis_multi,mir,Label)"       "Ausgabe spiegeln"
::msgcat::mcset pb_msg_german "MC(machine,gen,axis_multi,mir,Context)"     "Diese Optionen ermöglichen die Spiegelung der ausgewählten Adressen durch Negation ihrer Werte in der N/C-Ausgabe."
::msgcat::mcset pb_msg_german "MC(machine,gen,axis_multi,x,Label)"         "-X"
::msgcat::mcset pb_msg_german "MC(machine,gen,axis_multi,x,Context)"       "Dieser Schalter ermöglicht die Negation der X-Achsenkoordinate in der N/C-Ausgabe."
::msgcat::mcset pb_msg_german "MC(machine,gen,axis_multi,y,Label)"         "-Y"
::msgcat::mcset pb_msg_german "MC(machine,gen,axis_multi,y,Context)"       "Dieser Schalter ermöglicht die Negierung der Y-Achsenkoordinate in der N/C-Ausgabe."
::msgcat::mcset pb_msg_german "MC(machine,gen,axis_multi,z,Label)"         "-Z"
::msgcat::mcset pb_msg_german "MC(machine,gen,axis_multi,z,Context)"       "Dieser Schalter ermöglicht die Negation der Z-Achsenkoordinate in der N/C-Ausgabe."
::msgcat::mcset pb_msg_german "MC(machine,gen,axis_multi,i,Label)"         "-I"
::msgcat::mcset pb_msg_german "MC(machine,gen,axis_multi,i,Context)"       "Dieser Schalter ermöglicht die Negation der Werte von \"I\" der Kreisspurverfahren in der N/C-Ausgabe."
::msgcat::mcset pb_msg_german "MC(machine,gen,axis_multi,j,Label)"         "-J"
::msgcat::mcset pb_msg_german "MC(machine,gen,axis_multi,j,Context)"       "Dieser Schalter ermöglicht die Negation der Werte von \"J\" der Kreisspurverfahren in der N/C-Ausgabe."
::msgcat::mcset pb_msg_german "MC(machine,gen,axis_multi,k,Label)"         "-K"
::msgcat::mcset pb_msg_german "MC(machine,gen,axis_multi,k,Context)"       "Dieser Schalter ermöglicht die Negation der Werte von \"K\" der Kreisspurverfahren in der N/C-Ausgabe."

::msgcat::mcset pb_msg_german "MC(machine,gen,output,Label)"               "Ausgabemethode"
::msgcat::mcset pb_msg_german "MC(machine,gen,output,Context)"             "Ausgabemethode"
::msgcat::mcset pb_msg_german "MC(machine,gen,output,tool_tip,Label)"      "Werkzeug-Tipp"
::msgcat::mcset pb_msg_german "MC(machine,gen,output,tool_tip,Context)"    "Ausgabe in Bezug auf Werkzeug-Tipp"
::msgcat::mcset pb_msg_german "MC(machine,gen,output,turret_ref,Label)"    "Revolverkopf-Referenz"
::msgcat::mcset pb_msg_german "MC(machine,gen,output,turret_ref,Context)"  "Ausgabe in Bezug auf Revolverkopf-Referenz"

::msgcat::mcset pb_msg_german "MC(machine,gen,lathe_turret,msg)"           "Bezeichnung des primären Revolverkopfs darf nicht identisch mit der des sekundären Revolverkopfs sein."
::msgcat::mcset pb_msg_german "MC(machine,gen,turret_chg,msg)"             "Eine Änderung dieser Option erfordert u. U. das Hinzufügen bzw. Löschen eines G92-Quaders in den Werkzeugwechsel-Ereignissen."
# Entries for XZC/Mill-Turn
::msgcat::mcset pb_msg_german "MC(machine,gen,spindle_axis,Label)"             "Ausgangs-Spindelachse"
::msgcat::mcset pb_msg_german "MC(machine,gen,spindle_axis,Context)"           "Die für das Fräswerkzeug bestimmte Ausgangsspindelachse kann entweder als parallel oder senkrecht zur Z-Achse festgelegt werden.  Die Wkz-Achse der Operation muss der festgelegten Spindelachse entsprechen.  Ein Fehler tritt auf, wenn der Posten nicht mit der festgelegten Spindelachse positioniert werden kann. \nDieser Vektor kann von der festgelegten Spindelachse mit einem Kopfobjekt überschrieben werden."

::msgcat::mcset pb_msg_german "MC(machine,gen,position_in_yaxis,Label)"        "Position auf Y-Achse"
::msgcat::mcset pb_msg_german "MC(machine,gen,position_in_yaxis,Context)"      "Maschine besitzt eine programmierbare Y-Achse, die bei dem Konturfräsen positioniert werden kann.  Diese Option ist nur anwendbar, wenn sich die Spindelachse nicht entlang der Z-Achse befindet."

::msgcat::mcset pb_msg_german "MC(machine,gen,mach_mode,Label)"                "Bearbeitungsverfahren"
::msgcat::mcset pb_msg_german "MC(machine,gen,mach_mode,Context)"              "Bearbeitungsverfahren kann entweder XZC-Fräsmaschine oder einfache Fräs-/ Drehmaschine sein."

::msgcat::mcset pb_msg_german "MC(machine,gen,mach_mode,xzc_mill,Label)"       "XZC-Fräsmaschine"
::msgcat::mcset pb_msg_german "MC(machine,gen,mach_mode,xzc_mill,Context)"     "Eine XZC-Fräsmaschine hat einen Drehtisch oder eine Aufspannplatte als C-Rotationsachse auf einer Fräs-/ Drehmaschine befestigt. Alle XY-Verschiebungen werden zu X und C konvertiert, wobei X einen Radiuswert und C den Winkel darstellt."

::msgcat::mcset pb_msg_german "MC(machine,gen,mach_mode,mill_turn,Label)"      "Einfache Fräs-/ Drehmaschine"
::msgcat::mcset pb_msg_german "MC(machine,gen,mach_mode,mill_turn,Context)"    "Dieser XZC-Fräsposten wird mit einem Drehposten verknüpft, um ein Programm zu erstellen, das sowohl Fräs- als auch Drehoperationen enthält.  Der Operationstyp bestimmt, welcher Posten für die Erzeugung der N/C-Ausgaben verwendet wird."

::msgcat::mcset pb_msg_german "MC(machine,gen,mill_turn,lathe_post,Label)"     "Drehposten"
::msgcat::mcset pb_msg_german "MC(machine,gen,mill_turn,lathe_post,Context)"   "Ein Drehposten ist für einen einfachen Fräs-/ Drehposten erforderlich, um die Drehoperationen in einem Programm nachzubearbeiten."

::msgcat::mcset pb_msg_german "MC(machine,gen,lathe_post,select_name,Label)"   "Name auswählen"
::msgcat::mcset pb_msg_german "MC(machine,gen,lathe_post,select_name,Context)" "Wählen Sie den Namen eines Drehpostens aus, der in einem einfachen Fräs-/ Drehposten verwendet werden soll. Vermutlich kann dieser Posten im  Verzeichnis \\\$UGII_CAM_POST_DIR in der NX/Posten-Laufzeit gefunden werden; anderenfalls wird ein Posten mit identischem Namen in dem Verzeichnis verwendet, in dem der Fräsposten enthalten ist."

::msgcat::mcset pb_msg_german "MC(machine,gen,coord_mode,Label)"               "Standard-Koordinatenmodus"
::msgcat::mcset pb_msg_german "MC(machine,gen,coord_mode,Context)"             "Diese Optionen legen die Ausgangseinstellungen für den Koordinatenausgabenmodus als polar (XZC) oder kartesisch (XYZ) fest.  Dieser Modus kann mit den Operationen programmierten anwenderdefinierten Elementen \\\"FESTLEGEN/POLAR,AN\\\"."

::msgcat::mcset pb_msg_german "MC(machine,gen,coord_mode,polar,Label)"         "Polar"
::msgcat::mcset pb_msg_german "MC(machine,gen,coord_mode,polar,Context)"       "Koordinatenausgabe in XZC."

::msgcat::mcset pb_msg_german "MC(machine,gen,coord_mode,cart,Label)"          "Kartesisch"
::msgcat::mcset pb_msg_german "MC(machine,gen,coord_mode,cart,Context)"        "Koordinatenausgabe in XYZ."

::msgcat::mcset pb_msg_german "MC(machine,gen,xzc_arc_mode,Label)"             "Kreisspurverfahren-Modus"
::msgcat::mcset pb_msg_german "MC(machine,gen,xzc_arc_mode,Context)"           "Diese Optionen definieren die Ausgaben des Kreisspurverfahren, die sich im polaren (XCR) oder kartesischen (XYIJ) Modus befinden sollen."

::msgcat::mcset pb_msg_german "MC(machine,gen,xzc_arc_mode,polar,Label)"       "Polar"
::msgcat::mcset pb_msg_german "MC(machine,gen,xzc_arc_mode,polar,Context)"     "Kreisspurverfahren-Ausgabe in XCR."

::msgcat::mcset pb_msg_german "MC(machine,gen,xzc_arc_mode,cart,Label)"        "Kartesisch"
::msgcat::mcset pb_msg_german "MC(machine,gen,xzc_arc_mode,cart,Context)"      "Kreisspurverfahren-Ausgabe in XYIJ."

::msgcat::mcset pb_msg_german "MC(machine,gen,def_spindle_axis,Label)"         "Ausgangs-Spindelachse"
::msgcat::mcset pb_msg_german "MC(machine,gen,def_spindle_axis,Context)"       "Die Ausgangs-Spindelachse wird u. U. von der mit einem Kopfobjekt definierten Spindelachse außer Kraft gesetzt. \nDer Vektor muss kein Einheitsvektor sein."


##-----------------
## 4-th Axis parms
##
::msgcat::mcset pb_msg_german "MC(machine,axis,fourth,Label)"              "Vierte Achse"

::msgcat::mcset pb_msg_german "MC(machine,axis,radius_output,Label)"       "Radiusausgabe"
::msgcat::mcset pb_msg_german "MC(machine,axis,radius_output,Context)"     "Wenn sich die Wkz-Achse entlang der Z-Achse (0,0,1) befindet, kann der Posten entscheiden, ob der Radius (X) der polaren Koordinaten als \\\"Immer positiv\\\", \\\"Immer negativ\\\", oder \\\"Kürzester Abstand\\\" ausgegeben werden soll."

::msgcat::mcset pb_msg_german "MC(machine,axis,type_head,Label)"           "Winkelkopf"
::msgcat::mcset pb_msg_german "MC(machine,axis,type_table,Label)"          "Tabelle"

##-----------------
## 5-th Axis parms
##
::msgcat::mcset pb_msg_german "MC(machine,axis,fifth,Label)"               "Fünfte Achse"

::msgcat::mcset pb_msg_german "MC(machine,axis,rotary,Label)"              "Rotationsachse"

::msgcat::mcset pb_msg_german "MC(machine,axis,offset,Label)"              "Mittelpunkt Nullbearbeitung zu Mittelpunkt Rotationsachse"
::msgcat::mcset pb_msg_german "MC(machine,axis,offset,4,Label)"            "Mittelpunkt Nullbearbeitung zu Mittelpunkt 4. Achse"
::msgcat::mcset pb_msg_german "MC(machine,axis,offset,5,Label)"            "Mittelpunkt 4. Achse zu Mittelpunkt 5. Achse"
::msgcat::mcset pb_msg_german "MC(machine,axis,offset,x,Label)"            "X-Offset"
::msgcat::mcset pb_msg_german "MC(machine,axis,offset,x,Context)"          "X-Offset der Rotationsachse festlegen."
::msgcat::mcset pb_msg_german "MC(machine,axis,offset,y,Label)"            "Y-Offset"
::msgcat::mcset pb_msg_german "MC(machine,axis,offset,y,Context)"          "Y-Offset der Rotationsachse festlegen."
::msgcat::mcset pb_msg_german "MC(machine,axis,offset,z,Label)"            "Z-Offset"
::msgcat::mcset pb_msg_german "MC(machine,axis,offset,z,Context)"          "Z-Offset der Rotationsachse festlegen."

::msgcat::mcset pb_msg_german "MC(machine,axis,rotation,Label)"            "Achsenrotation"
::msgcat::mcset pb_msg_german "MC(machine,axis,rotation,norm,Label)"       "Normal"
::msgcat::mcset pb_msg_german "MC(machine,axis,rotation,norm,Context)"     "Achsenrotationsrichtung auf senkrecht festlegen."
::msgcat::mcset pb_msg_german "MC(machine,axis,rotation,rev,Label)"        "Umgekehrt"
::msgcat::mcset pb_msg_german "MC(machine,axis,rotation,rev,Context)"      "Umzukehrende Achsenrotationsrichtung festlegen."

::msgcat::mcset pb_msg_german "MC(machine,axis,direction,Label)"           "Achsrichtung"
::msgcat::mcset pb_msg_german "MC(machine,axis,direction,Context)"         "Achsenrichtung auswählen."

::msgcat::mcset pb_msg_german "MC(machine,axis,con_motion,Label)"              "Aufeinanderfolgende Rotationsbewegungen"
::msgcat::mcset pb_msg_german "MC(machine,axis,con_motion,combine,Label)"      "Kombiniert"
::msgcat::mcset pb_msg_german "MC(machine,axis,con_motion,combine,Context)"    "Dieser Schalter ermöglicht die Aktivierung/ Deaktivierung der Linearisierung. Damit wird die Toleranzoption aktiviert/ deaktiviert."
::msgcat::mcset pb_msg_german "MC(machine,axis,con_motion,tol,Label)"      "Toleranz"
::msgcat::mcset pb_msg_german "MC(machine,axis,con_motion,tol,Context)"    "Diese Option ist nur aktiv, wenn der Schalter \"Kombiniert\" aktiviert ist. Toleranz festlegen."

::msgcat::mcset pb_msg_german "MC(machine,axis,violation,Label)"           "Ausnahmeverarbeitung der Achsenbegrenzung"
::msgcat::mcset pb_msg_german "MC(machine,axis,violation,warn,Label)"      "Warnung"
::msgcat::mcset pb_msg_german "MC(machine,axis,violation,warn,Context)"    "Ausgabewarnung bei Verletzung der Achsenbegrenzungen."
::msgcat::mcset pb_msg_german "MC(machine,axis,violation,ret,Label)"       "Abfahren / Erneutes Anfahren"
::msgcat::mcset pb_msg_german "MC(machine,axis,violation,ret,Context)"     "Bei Verletzung der Achsenbegrenzungen Abfahren / Erneut Anfahren. \n \nIm anwenderdefinierten Befehl \"PB_CMD_init_rotaty\", können folgende Parameter angepasst werden, um die gewünschten Bewegungen zu erreichen: \n \n   mom_kin_retract_type \n   mom_kin_retract_distance \n   mom_kin_reengage_distance"

::msgcat::mcset pb_msg_german "MC(machine,axis,limits,Label)"              "Achsenbegrenzungen (Grad)"
::msgcat::mcset pb_msg_german "MC(machine,axis,limits,min,Label)"          "Minimum"
::msgcat::mcset pb_msg_german "MC(machine,axis,limits,min,Context)"        "Minimale Rotationsachsenbegrenzung (Grad) festlegen."
::msgcat::mcset pb_msg_german "MC(machine,axis,limits,max,Label)"          "Maximum"
::msgcat::mcset pb_msg_german "MC(machine,axis,limits,max,Context)"        "Maximale Rotationsachsenbegrenzung (Grad) festlegen."

::msgcat::mcset pb_msg_german "MC(machine,axis,incr_text)"                 "Diese Rotationsachse kann inkremental sein"

::msgcat::mcset pb_msg_german "MC(machine,axis,rotary_res,Label)"          "Rotationsbewegungsauflösung (Grad)"
::msgcat::mcset pb_msg_german "MC(machine,axis,rotary_res,Context)"        "Rotationsbewegungsauflösung (Grad) festlegen."

::msgcat::mcset pb_msg_german "MC(machine,axis,ang_offset,Label)"          "Winkel-Offset (Grad)"
::msgcat::mcset pb_msg_german "MC(machine,axis,ang_offset,Context)"        "Winkel-Offset (Grad) der Achse festlegen."

::msgcat::mcset pb_msg_german "MC(machine,axis,pivot,Label)"               "Drehpunkt-Abstand "
::msgcat::mcset pb_msg_german "MC(machine,axis,pivot,Context)"             "Drehpunkt-Abstand festlegen"

::msgcat::mcset pb_msg_german "MC(machine,axis,max_feed,Label)"            "Max. Vorschub (Grad/Min)"
::msgcat::mcset pb_msg_german "MC(machine,axis,max_feed,Context)"          "Max. Vorschub (Grad/Min) definieren"

::msgcat::mcset pb_msg_german "MC(machine,axis,plane,Label)"               "Rotationsebene"
::msgcat::mcset pb_msg_german "MC(machine,axis,plane,Context)"             "XY, YZ, ZX, etc. als Rotationsebene auswählen. Die Option \\\"Andere\\\" ermöglicht das Festlegen eines beliebigen Vektors."

::msgcat::mcset pb_msg_german "MC(machine,axis,plane,normal,Label)"        "Ebenennormalenvektor"
::msgcat::mcset pb_msg_german "MC(machine,axis,plane,normal,Context)"      "Ebenennormalenvektor als Rotationsachse festlegen. \nDer Vektor muss kein Einheitsvektor sein."
::msgcat::mcset pb_msg_german "MC(machine,axis,plane,4th,Label)"           "4-Achsen-Ebenennormale"
::msgcat::mcset pb_msg_german "MC(machine,axis,plane,4th,Context)"         "Ebenennormalenvektor für die 4-Achsenrotation festlegen."
::msgcat::mcset pb_msg_german "MC(machine,axis,plane,5th,Label)"           "5-Achsen-Ebenennormale"
::msgcat::mcset pb_msg_german "MC(machine,axis,plane,5th,Context)"         "Ebenennormalenvektor für die 5-Achsenrotation festlegen."

::msgcat::mcset pb_msg_german "MC(machine,axis,leader,Label)"              "Wort-Bezugspfeil"
::msgcat::mcset pb_msg_german "MC(machine,axis,leader,Context)"            "Wort-Bezugspfeil festlegen"

::msgcat::mcset pb_msg_german "MC(machine,axis,config,Label)"              "Konfigurieren"
::msgcat::mcset pb_msg_german "MC(machine,axis,config,Context)"            "Diese Option ermöglicht die Definition der 4- & 5-Achsenparameter."

::msgcat::mcset pb_msg_german "MC(machine,axis,r_axis_conf_trans,Label)"   "Rotationsachsenkonfiguration"
::msgcat::mcset pb_msg_german "MC(machine,axis,4th_axis,Label)"            "4-Achsen"
::msgcat::mcset pb_msg_german "MC(machine,axis,5th_axis,Label)"            "5-Achsen"
::msgcat::mcset pb_msg_german "MC(machine,axis,head,Label)"                " Winkelkopf "
::msgcat::mcset pb_msg_german "MC(machine,axis,table,Label)"               " Tabelle "

::msgcat::mcset pb_msg_german "MC(machine,axis,rotary_lintol,Label)"       "Linearisierungs-Standardtoleranz"
::msgcat::mcset pb_msg_german "MC(machine,axis,rotary_lintol,Context)"     "Dieser Wert wird als Standardtoleranz für die Linearisierung der Drehverschiebung verwendet, wenn der PP-Befehl \"LINTOL/AN\" mit aktuellen oder vorausgehenden Operationen festgelegt wurde. Der Befehlt \"LINTOL\" kann auch eine andere Linearisierungstoleranz festlegen."

#+++++++++++++++++++++
# Program & Tool Path
#+++++++++++++++++++++
::msgcat::mcset pb_msg_german "MC(progtpth,tab,Label)"                 "Programm & Werkzeugweg"

##---------
## Program
##
::msgcat::mcset pb_msg_german "MC(prog,tab,Label)"                     "Programm"
::msgcat::mcset pb_msg_german "MC(prog,Status)"                        "Ereignisausgabe definieren"

::msgcat::mcset pb_msg_german "MC(prog,tree,Label)"                    "Programm -- Sequenzbaum"
::msgcat::mcset pb_msg_german "MC(prog,tree,Context)"                  "Ein N/C-Programm wird in fünf Segmente unterteilt: vier(4) Sequenzen, und der Körper des Werkzeugwegs: \n \n * Programmstart-Sequenz \n * Operationsstart-Sequenz \n * Werkzeugweg \n * Operationsend-Sequenz \n * Programmend-Sequenz \n \nJede Sequenz besteht aus einer Reihe von Markierungen. Eine Markierung gibt ein programmierbares Ereignis an, und tritt in einem bestimmten Stadium eines N/C-Programms auf. Jede Markierung kann einer bestimmten Anordnung von N/C-Codes zugeordnet werden, die ausgegeben wird wenn das Programm nachbearbeitet wird. \n \nDer Werkzeugweg wird aus zahlreichen Ereignissen gebildet. Diese werden in drei(3) Gruppen unterteilt: \n \n * Maschinensteuerung \n * Bewegungen \n * Zyklen \n"

::msgcat::mcset pb_msg_german "MC(prog,tree,prog_strt,Label)"          "Programmstart-Sequenz"
::msgcat::mcset pb_msg_german "MC(prog,tree,prog_end,Label)"           "Programmend-Sequenz"
::msgcat::mcset pb_msg_german "MC(prog,tree,oper_strt,Label)"          "Operationsstart-Sequenz"
::msgcat::mcset pb_msg_german "MC(prog,tree,oper_end,Label)"           "Operationsend-Sequenz"
::msgcat::mcset pb_msg_german "MC(prog,tree,tool_path,Label)"          "Werkzeugweg"
::msgcat::mcset pb_msg_german "MC(prog,tree,tool_path,mach_cnt,Label)" "Maschinensteuerung"
::msgcat::mcset pb_msg_german "MC(prog,tree,tool_path,motion,Label)"   "Kinematik"
::msgcat::mcset pb_msg_german "MC(prog,tree,tool_path,cycle,Label)"    "Festzyklen"
::msgcat::mcset pb_msg_german "MC(prog,tree,linked_posts,Label)"       "Verknüpfte PP-Sequenz"

::msgcat::mcset pb_msg_german "MC(prog,add,Label)"                     "Sequenz -- Datenblock hinzufügen"
::msgcat::mcset pb_msg_german "MC(prog,add,Context)"                   "Ein neuer Datenblock kann durch Drücken dieser Schaltfläche und Ziehen in die gewünschte Markierung hinzugefügt werden.  Datenblöcke können auch neben, über, oder unter einem vorhandenen Datenblock angehängt werden."

::msgcat::mcset pb_msg_german "MC(prog,trash,Label)"                   "Sequenz -- Abfalleimer"
::msgcat::mcset pb_msg_german "MC(prog,trash,Context)"                 "Ungewünschte Datenblöcke können aus der Sequenz entfernt werden, indem er in diesen Abfalleimer verschoben werden."

::msgcat::mcset pb_msg_german "MC(prog,block,Label)"                   "Sequenz -- Datenblock"
::msgcat::mcset pb_msg_german "MC(prog,block,Context)"                 "Jeder ungewünschte Datenblock kann aus der Sequenz entfernt werden, indem er in diesen Abfalleimer gezogen wird. \n \nEs kann auch ein Kontextmenü durch Klicken auf die rechte Maustaste aktiviert werden.  Mehrere Optionen werden im Menü zur Verfügung stehen : \n \n * Bearbeiten \n * Kraftausgabe \n * Schneiden \n * Kopieren als \n * Einfügen \n * Löschen \n"

::msgcat::mcset pb_msg_german "MC(prog,select,Label)"                  "Sequenz -- Datenblockauswahl"
::msgcat::mcset pb_msg_german "MC(prog,select,Context)"                "Der Typ der Datenblock-Komponente, der zur Sequenz hinzugefügt werden soll, kann aus der Liste ausgewählt werden. \n\AVerfügbare Komponententypen sind : \n \n * Neuer Datenblock \n * Vorhandener N/C-Datenblock \n * Bedienermeldung \n * Anwenderdefinierter Befehl \n"

::msgcat::mcset pb_msg_german "MC(prog,oper_temp,Label)"               "Eine Sequenzvorlage auswählen"
::msgcat::mcset pb_msg_german "MC(prog,add_block,Label)"               "Datenblock hinzufügen"
::msgcat::mcset pb_msg_german "MC(prog,seq_comb_nc,Label)"             "Kombinierte N/C Code-Datenblöcke anzeigen"
::msgcat::mcset pb_msg_german "MC(prog,seq_comb_nc,Context)"           "Diese Schaltfläche ermöglicht die Anzeige von Inhalten einer Sequenz in Bezug auf Datenblöcke oder N/C-Codes. \n \nN/C-Codes zeigen Wörter in korrekter Reihenfolge an."

::msgcat::mcset pb_msg_german "MC(prog,plus,Label)"                    "Programm -- Zusammenfassen / Schalter erweitern"
::msgcat::mcset pb_msg_german "MC(prog,plus,Context)"                  "Mit dieser Schaltfläche können die Äste dieser Komponente zusammengefasst oder erweitert werden."

::msgcat::mcset pb_msg_german "MC(prog,marker,Label)"                  "Sequenz -- Markierung"
::msgcat::mcset pb_msg_german "MC(prog,marker,Context)"                "Die Markierung einer Sequenz gibt mögliche Ereignisse an, die programmiert werden, und in einer Sequenz in einem bestimmten Stadium eines N/C-Programms auftreten können \n \nAuszugebende Datenblöcke die (in) jeder Markierung angehängt/ angeordnet werden ."

::msgcat::mcset pb_msg_german "MC(prog,event,Label)"                   "Programm -- Ereignis"
::msgcat::mcset pb_msg_german "MC(prog,event,Context)"                 "Jedes Ereignis kann mit einem einzigen linken Mausklick bearbeitet werden."

::msgcat::mcset pb_msg_german "MC(prog,nc_code,Label)"                 "Programm -- N/C-Code"
::msgcat::mcset pb_msg_german "MC(prog,nc_code,Context)"               "Der Text in diesem Fenster zeigt den bezeichnenden N/C-Code an, der bei dieser Markierung bzw. von diesem Ereignis ausgegeben werden soll."
::msgcat::mcset pb_msg_german "MC(prog,undo_popup,Label)"              "Rückgängig"

## Sequence
##
::msgcat::mcset pb_msg_german "MC(seq,combo,new,Label)"                "Neuer Datenblock"
::msgcat::mcset pb_msg_german "MC(seq,combo,comment,Label)"            "Bedienermeldung"
::msgcat::mcset pb_msg_german "MC(seq,combo,custom,Label)"             "Anwenderdef. Befehl"

::msgcat::mcset pb_msg_german "MC(seq,new_trans,title,Label)"          "Quader"
::msgcat::mcset pb_msg_german "MC(seq,cus_trans,title,Label)"          "Anwenderdef. Befehl"
::msgcat::mcset pb_msg_german "MC(seq,oper_trans,title,Label)"         "Bedienermeldung"

::msgcat::mcset pb_msg_german "MC(seq,edit_popup,Label)"               "Bearbeiten"
::msgcat::mcset pb_msg_german "MC(seq,force_popup,Label)"              "Kraftausgabe"
::msgcat::mcset pb_msg_german "MC(seq,rename_popup,Label)"             "Umbenennen"
::msgcat::mcset pb_msg_german "MC(seq,rename_popup,Context)"           "Der Name für diese Komponente kann festgelegt werden."
::msgcat::mcset pb_msg_german "MC(seq,cut_popup,Label)"                "Schnitt"
::msgcat::mcset pb_msg_german "MC(seq,copy_popup,Label)"               "Kopieren als"
::msgcat::mcset pb_msg_german "MC(seq,copy_popup,ref,Label)"           "Referenzierte Datenblöcke"
::msgcat::mcset pb_msg_german "MC(seq,copy_popup,new,Label)"           "Neue Datenblöcke"
::msgcat::mcset pb_msg_german "MC(seq,paste_popup,Label)"              "Einfügen"
::msgcat::mcset pb_msg_german "MC(seq,paste_popup,before,Label)"       "Vorher"
::msgcat::mcset pb_msg_german "MC(seq,paste_popup,inline,Label)"       "Innen"
::msgcat::mcset pb_msg_german "MC(seq,paste_popup,after,Label)"        "Nachher"
::msgcat::mcset pb_msg_german "MC(seq,del_popup,Label)"                "Löschen"

::msgcat::mcset pb_msg_german "MC(seq,force_trans,title,Label)"        "Einmalige Kraftausgabe"

##--------------
## Toolpath
##
::msgcat::mcset pb_msg_german "MC(tool,event_trans,title,Label)"       "Ereignis"

::msgcat::mcset pb_msg_german "MC(tool,event_seq,button,Label)"        "Eine Ereignisvorlage auswählen"
::msgcat::mcset pb_msg_german "MC(tool,add_word,button,Label)"         "Wort hinzufügen"

::msgcat::mcset pb_msg_german "MC(tool,format_trans,title,Label)"      "FORMAT"

::msgcat::mcset pb_msg_german "MC(tool,circ_trans,title,Label)"        "Kreisförmige Bewegung -- Ebenencodes"
::msgcat::mcset pb_msg_german "MC(tool,circ_trans,frame,Label)"        " Codes der Ebene G "
::msgcat::mcset pb_msg_german "MC(tool,circ_trans,xy,Label)"           "XY-Ebene"
::msgcat::mcset pb_msg_german "MC(tool,circ_trans,yz,Label)"           "YZ-Ebene"
::msgcat::mcset pb_msg_german "MC(tool,circ_trans,zx,Label)"           "ZX-Ebene"

::msgcat::mcset pb_msg_german "MC(tool,ijk_desc,arc_start,Label)"          "Bogenstart zu Mittelpunkt"
::msgcat::mcset pb_msg_german "MC(tool,ijk_desc,arc_center,Label)"         "Bogenmittelpunkt zu Start"
::msgcat::mcset pb_msg_german "MC(tool,ijk_desc,u_arc_start,Label)"        "Ungekennzeichneter Bogenstartpunkt zu Mittelpunkt"
::msgcat::mcset pb_msg_german "MC(tool,ijk_desc,absolute,Label)"           "Absoluter Bogenmittelpunkt"
::msgcat::mcset pb_msg_german "MC(tool,ijk_desc,long_thread_lead,Label)"   "Längs-Gewindeführung"
::msgcat::mcset pb_msg_german "MC(tool,ijk_desc,tran_thread_lead,Label)"   "Quer-Gewindeführung"

::msgcat::mcset pb_msg_german "MC(tool,spindle,range,type,Label)"              "Spindelbereichstyp"
::msgcat::mcset pb_msg_german "MC(tool,spindle,range,range_M,Label)"           "Separater Bereich - M-Code (M41)"
::msgcat::mcset pb_msg_german "MC(tool,spindle,range,with_spindle_M,Label)"    "Bereichsnummer mit M-Spindelcode (M13)"
::msgcat::mcset pb_msg_german "MC(tool,spindle,range,hi_lo_with_S,Label)"      "Hoher/Niedriger Bereich mit S-Code (S+100)"
::msgcat::mcset pb_msg_german "MC(tool,spindle,range,nonzero_range,msg)"       "Die Anzahl der Spindelbereiche muss größer als Null sein."

::msgcat::mcset pb_msg_german "MC(tool,spindle_trans,title,Label)"         "Spindelbereich-Codetabelle"
::msgcat::mcset pb_msg_german "MC(tool,spindle_trans,range,Label)"         "Bereich"
::msgcat::mcset pb_msg_german "MC(tool,spindle_trans,code,Label)"          "Code"
::msgcat::mcset pb_msg_german "MC(tool,spindle_trans,min,Label)"           "Minimum (RPM)"
::msgcat::mcset pb_msg_german "MC(tool,spindle_trans,max,Label)"           "Maximum (RPM)"

::msgcat::mcset pb_msg_german "MC(tool,spindle_desc,sep,Label)"            " Separater Bereich - M-Code (M41, M42 ...) "
::msgcat::mcset pb_msg_german "MC(tool,spindle_desc,range,Label)"          " Bereichsnummer mit M-Spindelcode (M13, M23 ...)"
::msgcat::mcset pb_msg_german "MC(tool,spindle_desc,high,Label)"           " Hoher/Niedriger Bereich mit S-Code (S+100/S-100)"
::msgcat::mcset pb_msg_german "MC(tool,spindle_desc,odd,Label)"            " Ungerader/Gerader Bereich mit S-Code"


::msgcat::mcset pb_msg_german "MC(tool,config,mill_opt1,Label)"            "Wkz-Nummer"
::msgcat::mcset pb_msg_german "MC(tool,config,mill_opt2,Label)"            "Wkz-Nummer und Längen-Offset-Nummer"
::msgcat::mcset pb_msg_german "MC(tool,config,mill_opt3,Label)"            "Längen-Offset-Nummer und Wkz-Nummer"

::msgcat::mcset pb_msg_german "MC(tool,config,title,Label)"                "Wkz-Codekonfiguration"
::msgcat::mcset pb_msg_german "MC(tool,config,output,Label)"               "Ausgabe"

::msgcat::mcset pb_msg_german "MC(tool,config,lathe_opt1,Label)"           "Wkz-Nummer"
::msgcat::mcset pb_msg_german "MC(tool,config,lathe_opt2,Label)"           "Wkz-Nummer und Längen-Offset-Nummer"
::msgcat::mcset pb_msg_german "MC(tool,config,lathe_opt3,Label)"           "Revolverindex und Wkz-Nummer"
::msgcat::mcset pb_msg_german "MC(tool,config,lathe_opt4,Label)"           "Revolverindex-Werkzeugnummer und Längen-Offset-Nummer"

::msgcat::mcset pb_msg_german "MC(tool,conf_desc,num,Label)"               "Wkz-Nummer"
::msgcat::mcset pb_msg_german "MC(tool,conf_desc,next_num,Label)"          "Folgende Wkz-Nummer"
::msgcat::mcset pb_msg_german "MC(tool,conf_desc,index_num,Label)"         "Revolverindex und Wkz-Nummer"
::msgcat::mcset pb_msg_german "MC(tool,conf_desc,index_next_num,Label)"    "Revolverindex und folgende Wkz-Nummer"
::msgcat::mcset pb_msg_german "MC(tool,conf_desc,num_len,Label)"           "Wkz-Nummer und Längen-Offset-Nummer"
::msgcat::mcset pb_msg_german "MC(tool,conf_desc,next_num_len,Label)"      "Folgende Wkz-Nummer und Längen-Offset-Nummer"
::msgcat::mcset pb_msg_german "MC(tool,conf_desc,len_num,Label)"           "Längen-Offset-Nummer und Wkz-Nummer"
::msgcat::mcset pb_msg_german "MC(tool,conf_desc,len_next_num,Label)"      "Längen-Offset-Nummer und folgende Wkz-Nummer"
::msgcat::mcset pb_msg_german "MC(tool,conf_desc,index_num_len,Label)"     "Revolverindex, Wkz-Nummer und Längen-Offset-Nummer"
::msgcat::mcset pb_msg_german "MC(tool,conf_desc,index_next_num_len,Label)"    "Revolverindex, folgende Wkz-Nummer und Längen-Offset-Nummer"

::msgcat::mcset pb_msg_german "MC(tool,oper_trans,title,Label)"            "Bedienermeldung"
::msgcat::mcset pb_msg_german "MC(tool,cus_trans,title,Label)"             "Anwenderdef. Befehl"

##--------------------------
## Labels for Event dialogs
##
::msgcat::mcset pb_msg_german "MC(event,feed,IPM_mode)"                "IPM-Modus (Zoll/Min)"

##---------
## G Codes
##
::msgcat::mcset pb_msg_german "MC(gcode,tab,Label)"                    "G-Codes"
::msgcat::mcset pb_msg_german "MC(gcode,Status)"                       "G-Codes festlegen"

##---------
## M Codes
##
::msgcat::mcset pb_msg_german "MC(mcode,tab,Label)"                    "M-Codes"
::msgcat::mcset pb_msg_german "MC(mcode,Status)"                       "M-Codes festlegen"

##-----------------
## Words Summary
##
::msgcat::mcset pb_msg_german "MC(addrsum,tab,Label)"                  "Wortzusammenfassung"
::msgcat::mcset pb_msg_german "MC(addrsum,Status)"                     "Parameter angeben"

::msgcat::mcset pb_msg_german "MC(addrsum,col_addr,Label)"             "Wort"
::msgcat::mcset pb_msg_german "MC(addrsum,col_addr,Context)"           "Eine Wortadresse kann durch das Klicken mit der linken Maustaste auf den Namen bearbeitet werden."
::msgcat::mcset pb_msg_german "MC(addrsum,col_lead,Label)"             "Führung/Code"
::msgcat::mcset pb_msg_german "MC(addrsum,col_data,Label)"             "Datentyp"
::msgcat::mcset pb_msg_german "MC(addrsum,col_plus,Label)"             "Plus (+)"
::msgcat::mcset pb_msg_german "MC(addrsum,col_lzero,Label)"            "Anführende Null"
::msgcat::mcset pb_msg_german "MC(addrsum,col_int,Label)"              "Ganzzahl"
::msgcat::mcset pb_msg_german "MC(addrsum,col_dec,Label)"              "Dezimal (.)"
::msgcat::mcset pb_msg_german "MC(addrsum,col_frac,Label)"             "Bruch"
::msgcat::mcset pb_msg_german "MC(addrsum,col_tzero,Label)"            "Nachfolgende Null"
::msgcat::mcset pb_msg_german "MC(addrsum,col_modal,Label)"            "Modal ?"
::msgcat::mcset pb_msg_german "MC(addrsum,col_min,Label)"              "Minimum"
::msgcat::mcset pb_msg_german "MC(addrsum,col_max,Label)"              "Maximum"
::msgcat::mcset pb_msg_german "MC(addrsum,col_trail,Label)"            "Präfix"

::msgcat::mcset pb_msg_german "MC(addrsum,radio_text,Label)"           "Text"
::msgcat::mcset pb_msg_german "MC(addrsum,radio_num,Label)"            "Numerisch"

::msgcat::mcset pb_msg_german "MC(addrsum,addr_trans,title,Label)"     "WORT"
::msgcat::mcset pb_msg_german "MC(addrsum,other_trans,title,Label)"    "Weitere Datenelemente"

##-----------------
## Word Sequencing
##
::msgcat::mcset pb_msg_german "MC(wseq,tab,Label)"                     "Wortsequenzen"
::msgcat::mcset pb_msg_german "MC(wseq,Status)"                        "Wörter in Reihenfolge bringen"

::msgcat::mcset pb_msg_german "MC(wseq,word,Label)"                    "Master-Wortsequenz"
::msgcat::mcset pb_msg_german "MC(wseq,word,Context)"                  "Die Reihenfolge der Worte, wie sie in der N/C-Ausgabe angezeigt werden, kann durch Ziehen jedes Wortes in die gewünschte Position erreicht werden. \n \nWenn sich das gezogene Wort auf das andere Wort fokussiert (Farbe der Rechtecksänderung), wird die Position dieser 2 Wörter ausgetauscht. Wenn ein Wort innerhalb des Fokus eines Trennzeichens zwischen zwei Wörtern gezogen wird, wird das Wort zwischen diesen zwei Wörtern eingefügt. \n \nJedes Wort kann von der Ausgabe an die N/C-Datei unterdrückt werden, indem es mit einem linken Mausklick deaktiviert wird. \n \nDiese Wörter können auch mit Hilfe der Optionen des Kontextmenüs manipuliert werden : \n \n * Neu \n * Bearbeiten \n * Löschen \n * Alle aktivieren \n"

::msgcat::mcset pb_msg_german "MC(wseq,active_out,Label)"              " Ausgabe - Aktiv     "
::msgcat::mcset pb_msg_german "MC(wseq,suppressed_out,Label)"          " Ausgabe - Unterdrückt "

::msgcat::mcset pb_msg_german "MC(wseq,popup_new,Label)"               "Neu"
::msgcat::mcset pb_msg_german "MC(wseq,popup_undo,Label)"              "Rückgängig"
::msgcat::mcset pb_msg_german "MC(wseq,popup_edit,Label)"              "Bearbeiten"
::msgcat::mcset pb_msg_german "MC(wseq,popup_delete,Label)"            "Löschen"
::msgcat::mcset pb_msg_german "MC(wseq,popup_all,Label)"               "Alle aktivieren"
::msgcat::mcset pb_msg_german "MC(wseq,transient_win,Label)"           "WORT"
::msgcat::mcset pb_msg_german "MC(wseq,cannot_suppress_msg)"           "darf nicht unterdrückt werden.  Wurde verwendet als einzelnes Element in"
::msgcat::mcset pb_msg_german "MC(wseq,empty_block_msg)"               "Unterdrückung der Ausgabe dieser Adresse resultiert in ungültigen, leeren Datenblöcken."

##----------------
## Custom Command
##
::msgcat::mcset pb_msg_german "MC(cust_cmd,tab,Label)"                 "Anwenderdef. Befehl"
::msgcat::mcset pb_msg_german "MC(cust_cmd,Status)"                    "Anwenderdef. Befehle definieren"

::msgcat::mcset pb_msg_german "MC(cust_cmd,name,Label)"                "Befehlsname"
::msgcat::mcset pb_msg_german "MC(cust_cmd,name,Context)"              "Der hier eingegebene Name wird mit einem Präfix \"PB_CMD_\" versehen, um als tatsächlicher Befehlsname zu gelten."
::msgcat::mcset pb_msg_german "MC(cust_cmd,proc,Label)"                "Vorgehensweise"
::msgcat::mcset pb_msg_german "MC(cust_cmd,proc,Context)"              "Geben Sie ein Tcl-Skript ein, um die Funktionalität dieses Befehls zu definieren. \n \n * Es ist zu beachten, dass die Skriptinhalte nicht vom Postprozessor analysiert werden, aber in der Tcl-Datei gespeichert werden. Daher sind Sie für die syntaktische Korrektheit dieses Skripts verantwortlich."

::msgcat::mcset pb_msg_german "MC(cust_cmd,name_msg)"                  "Ungültiger anwenderdef. Befehlsname.\n Einen anderen Namen festlegen"
::msgcat::mcset pb_msg_german "MC(cust_cmd,name_msg_1)"                "für spezielle anwenderdef. Befehle reserviert.\n Einen anderen Namen festlegen"
::msgcat::mcset pb_msg_german "MC(cust_cmd,name_msg_2)"                "Nur anwenderdef. VNC-Befehlsnamen wie \n PB_CMD_vnc____* sind zulässig.\n Einen anderen Namen festlegen"

::msgcat::mcset pb_msg_german "MC(cust_cmd,import,Label)"              "Importieren"
::msgcat::mcset pb_msg_german "MC(cust_cmd,import,Context)"            "Anwenderdef. Befehle aus einer ausgewählten Tcl-Datei in den PP in Bearbeitung importieren."
::msgcat::mcset pb_msg_german "MC(cust_cmd,export,Label)"              "Exportieren"
::msgcat::mcset pb_msg_german "MC(cust_cmd,export,Context)"            "Anwenderdef. Befehle aus dem Posten in Bearbeitung in eine Tcl-Datei exportieren."
::msgcat::mcset pb_msg_german "MC(cust_cmd,import,tree,Label)"         "Anwenderdef. Befehle importieren"
::msgcat::mcset pb_msg_german "MC(cust_cmd,import,tree,Context)"       "Diese Liste enthält die Vorgehensweisen für anwenderdef. Befehle und Tcl, die in der für den Import festgelegten Datei gefunden wurden.  Eine Vorschau der Inhalte jeder Vorgehensweise kann erreicht werden, indem das Element in der Liste mit einem linken Mausklick ausgewählt wird. Jede bereits im PP in Bearbeitung existierende Vorgehensweise ist mit einer Anzeige <existiert> gekennzeichnet. Ein Doppelklick mit der linken Maustaste auf das Element aktiviert das Kontrollkästchen neben dem Element. Dies ermöglicht die Auswahl bzw. Abwahl einer zu importierenden Vorgehensweise. Standardmäßig werden alle Vorgehensweisen für den Import ausgewählt. Jedes Element kann abgewählt werden, um das Überschreiben einer vorhandenen Vorgehensweise zu vermeiden."

::msgcat::mcset pb_msg_german "MC(cust_cmd,export,tree,Label)"         "Anwenderdefinierte Befehle exportieren"
::msgcat::mcset pb_msg_german "MC(cust_cmd,export,tree,Context)"       "Diese Liste enthält die Vorgehensweisen für anwenderdef. Befehle und Tcl, die im PP in Bearbeitung vorhanden sind.  Eine Vorschau der Inhalte jeder Vorgehensweise kann erreicht werden, indem das Element in der Liste mit einem linken Mausklick ausgewählt wird.  Ein Doppelklick mit der linken Maustaste auf das Element aktiviert das Kontrollkästchen neben dem Element.  Dies ermöglicht, dass nur gewünschte Vorgehensweisen für den Export ausgewählt werden."

::msgcat::mcset pb_msg_german "MC(cust_cmd,error,title)"               "Fehler bei anwenderdef. Befehl"
::msgcat::mcset pb_msg_german "MC(cust_cmd,error,msg)"                 "Überprüfung der anwenderdef. Befehle kann aktiviert bzw. deaktiviert werden, indem die Schalter im Pulldown-Menü des Hauptmenüelements \"Optionen -> Anwenderdef. Befehle überprüfen\" festgelegt werden."

::msgcat::mcset pb_msg_german "MC(cust_cmd,select_all,Label)"          "Alle auswählen"
::msgcat::mcset pb_msg_german "MC(cust_cmd,select_all,Context)"        "Auf diese Schaltfläche klicken, um alle angezeigten Befehle zu importieren bzw. exportieren."
::msgcat::mcset pb_msg_german "MC(cust_cmd,deselect_all,Label)"        "Auswahl aller aufheben"
::msgcat::mcset pb_msg_german "MC(cust_cmd,deselect_all,Context)"      "Auf diese Schaltfläche klicken, um die Auswahl aller Befehle aufzuheben."

::msgcat::mcset pb_msg_german "MC(cust_cmd,import,warning,title)"      "Warnung beim Importieren/ Exportieren des anwenderdef. Befehls"
::msgcat::mcset pb_msg_german "MC(cust_cmd,import,warning,msg)"        "Kein Element für Import bzw. Export ausgewählt."



::msgcat::mcset pb_msg_german "MC(cust_cmd,cmd,msg)"                   "Befehle : "
::msgcat::mcset pb_msg_german "MC(cust_cmd,blk,msg)"                   "Datenblöcke: "
::msgcat::mcset pb_msg_german "MC(cust_cmd,add,msg)"                   "Adressen : "
::msgcat::mcset pb_msg_german "MC(cust_cmd,fmt,msg)"                   "Formate : "
::msgcat::mcset pb_msg_german "MC(cust_cmd,referenced,msg)"            "in anwenderdef. Befehl referenziert "
::msgcat::mcset pb_msg_german "MC(cust_cmd,not_defined,msg)"           "wurden noch nicht im aktuellen Bereich des PP in Bearbeitung definiert."
::msgcat::mcset pb_msg_german "MC(cust_cmd,cannot_delete,msg)"         "kann nicht gelöscht werden."
::msgcat::mcset pb_msg_german "MC(cust_cmd,save_post,msg)"             "PP trotzdem speichern?"


##------------------
## Operator Message
##
::msgcat::mcset pb_msg_german "MC(opr_msg,text,Label)"                 "Bedienermeldung"
::msgcat::mcset pb_msg_german "MC(opr_msg,text,Context)"               "Als Bedienermeldung anzuzeigender Text.  Das erforderliche Sonderzeichen für den Anfang bzw. Ende der Meldung wird vom Post Builder automatisch zugeordnet. Diese Zeichen werden auf der Parameterseite \"Weitere Datenelemente\" unter der Registerkarte \"N/C-Datendefinitionen\"."

::msgcat::mcset pb_msg_german "MC(opr_msg,name,Label)"                 "Meldungsname"
::msgcat::mcset pb_msg_german "MC(opr_msg,empty_operator)"             "Eine Bedienermeldung sollte nicht leer sein."


##--------------
## Linked Posts
##
::msgcat::mcset pb_msg_german "MC(link_post,tab,Label)"                "Verknüpfte Posten"
::msgcat::mcset pb_msg_german "MC(link_post,Status)"                   "Verknüpfte Posten definieren"

::msgcat::mcset pb_msg_german "MC(link_post,toggle,Label)"             "Diesen Posten mit weiteren Posten verknüpfen"
::msgcat::mcset pb_msg_german "MC(link_post,toggle,Context)"           "Weitere Posten können mit diesem Posten verknüpft werden, um komplexe Maschinenwerkzeuge zu bearbeiten, die mehrere Kombinationen einfacher Fräs- und Drehmodi ausführen."

::msgcat::mcset pb_msg_german "MC(link_post,head,Label)"               "Winkelkopf"
::msgcat::mcset pb_msg_german "MC(link_post,head,Context)"             "Eine komplexe Wkz-Maschine kann seine Bearbeitungsoperationen mit Hilfe verschiedener Kinematiksätze in unterschiedlichen Bearbeitungsverfahren ausführen.  Jeder Kinematiksatz wird als unabhängiger Kopf in NX/Posten behandelt. Bearbeitungsoperationen, die mit einem speziellen Kopf ausgeführt werden müssen, werden in einer Gruppe im Maschinenwerkzeug oder der Bearbeitungsmethodenansicht platziert. Ein \\\"Kopf\\\"-UDE wird dann der Gruppe zugewiesen, um den Kopfnamen zu bestimmen."

::msgcat::mcset pb_msg_german "MC(link_post,post,Label)"               "Posten"
::msgcat::mcset pb_msg_german "MC(link_post,post,Context)"             "Ein Posten ist einem Kopf für die Erstellung der N/C-Codes zugewiesen."

::msgcat::mcset pb_msg_german "MC(link_post,link,Label)"               "Ein verknüpfter Posten"
::msgcat::mcset pb_msg_german "MC(link_post,link,Context)"             "[::msgcat::mc MC(link_post,head,Context)] \n\n [::msgcat::mc MC(link_post,post,Context)]"


::msgcat::mcset pb_msg_german "MC(link_post,new,Label)"                "Neu"
::msgcat::mcset pb_msg_german "MC(link_post,new,Context)"              "Eine neue Verbindung erzeugen."

::msgcat::mcset pb_msg_german "MC(link_post,edit,Label)"               "Bearbeiten"
::msgcat::mcset pb_msg_german "MC(link_post,edit,Context)"             "Eine Verbindung bearbeiten."

::msgcat::mcset pb_msg_german "MC(link_post,delete,Label)"             "Löschen"
::msgcat::mcset pb_msg_german "MC(link_post,delete,Context)"           "Eine Verbindung löschen."

::msgcat::mcset pb_msg_german "MC(link_post,select_name,Label)"        "Name auswählen"
::msgcat::mcset pb_msg_german "MC(link_post,select_name,Context)"      "Wählen Sie den Namen eines Postens aus, der dem Kopf zugewiesen werden soll. Vermutlich kann dieser Posten in dem Verzeichnis gefunden werden, in dem sich der Hauptposten bei der NX/Posten-Laufzeit befindet; anderenfalls wird ein Posten mit identischem Namen im Verzeichnis \\\$UGII_CAM_POST_DIR verwendet."

::msgcat::mcset pb_msg_german "MC(link_post,start_of_head,Label)"      "Kopfanfang"
::msgcat::mcset pb_msg_german "MC(link_post,start_of_head,Context)"    "Die N/C-Codes oder -Aktionen festlegen, die am Kopfanfang ausgeführt werden sollen."

::msgcat::mcset pb_msg_german "MC(link_post,end_of_head,Label)"        "Kopfende"
::msgcat::mcset pb_msg_german "MC(link_post,end_of_head,Context)"      "Die N/C-Codes oder -Aktionen festlegen, die am Kopfende ausgeführt werden sollen."
::msgcat::mcset pb_msg_german "MC(link_post,dlg,head,Label)"           "Winkelkopf"
::msgcat::mcset pb_msg_german "MC(link_post,dlg,post,Label)"           "Posten"
::msgcat::mcset pb_msg_german "MC(link_post,dlg,title,Label)"          "Verknüpfter Posten"

#++++++++++++++++++++++
# N/C Data Definitions
#++++++++++++++++++++++
::msgcat::mcset pb_msg_german "MC(nc_data,tab,Label)"                  "N/C-Datendefinitionen"

##-------
## BLOCK
##
::msgcat::mcset pb_msg_german "MC(block,tab,Label)"                    "Block"
::msgcat::mcset pb_msg_german "MC(block,Status)"                       "Die Blockschablonen definieren"

::msgcat::mcset pb_msg_german "MC(block,name,Label)"                   "Blockname"
::msgcat::mcset pb_msg_german "MC(block,name,Context)"                 "Den Blocknamen eingeben"

::msgcat::mcset pb_msg_german "MC(block,add,Label)"                    "Wort hinzufügen"
::msgcat::mcset pb_msg_german "MC(block,add,Context)"                  "Ein neues Wort kann einem Block hinzugefügt werden, indem diese Schaltfläche gedrückt wird und dann in den angezeigten Block im nachfolgenden Fenster gezogen wird.  Die zu erzeugende Wortart wird aus dem Listenfenster rechts neben dieser Schaltfläche ausgewählt."

::msgcat::mcset pb_msg_german "MC(block,select,Label)"                 "BLOCK -- Wortauswahl"
::msgcat::mcset pb_msg_german "MC(block,select,Context)"               "Die gewünschte Wortart, die dem Block hinzugefügt werden soll, kann aus dieser Liste ausgewählt werden."

::msgcat::mcset pb_msg_german "MC(block,trash,Label)"                  "BLOCK -- Abfalleimer"
::msgcat::mcset pb_msg_german "MC(block,trash,Context)"                "Ungewünschte Wörter können aus dem Block entfernt werden, indem sie in diesen Abfalleimer verschoben werden."

::msgcat::mcset pb_msg_german "MC(block,word,Label)"                   "BLOCK -- Wort"
::msgcat::mcset pb_msg_german "MC(block,word,Context)"                 "Ungewünschte Wörter in diesem Block können entfernt werden, indem sie in diesen Abfalleimer verschoben werden. \n \nDurch Klicken auf die rechte Maustaste kann auch ein Kontextmenü aktiviert werden.  Mehrere Optionen werden im Menü verfügbar sein : \n \n * Bearbeiten \n * Element ändern -> \n * Optional \n * Kein Leerzeichen \n * Kraftausgabe \n * Löschen \n"

::msgcat::mcset pb_msg_german "MC(block,verify,Label)"                 "BLOCK -- Wortüberprüfung"
::msgcat::mcset pb_msg_german "MC(block,verify,Context)"               "Dieses Fenster zeigt den bezeichnenden N/C-Code an, der für ein im Block ausgewähltes Wort (unterdrückt) im obigen Fenster ausgegeben werden soll."

::msgcat::mcset pb_msg_german "MC(block,new_combo,Label)"              "Neue Adresse"
::msgcat::mcset pb_msg_german "MC(block,text_combo,Label)"             "Text"
::msgcat::mcset pb_msg_german "MC(block,oper_combo,Label)"             "Bedienermeldung"
::msgcat::mcset pb_msg_german "MC(block,comm_combo,Label)"             "Befehl"

::msgcat::mcset pb_msg_german "MC(block,edit_popup,Label)"             "Bearbeiten"
::msgcat::mcset pb_msg_german "MC(block,view_popup,Label)"             "Ansicht"
::msgcat::mcset pb_msg_german "MC(block,change_popup,Label)"           "Element ändern"
::msgcat::mcset pb_msg_german "MC(block,user_popup,Label)"             "Anwenderdefinierter Ausdruck"
::msgcat::mcset pb_msg_german "MC(block,opt_popup,Label)"              "Optional"
::msgcat::mcset pb_msg_german "MC(block,no_sep_popup,Label)"           "Kein Leerzeichen"
::msgcat::mcset pb_msg_german "MC(block,force_popup,Label)"            "Kraftausgabe"
::msgcat::mcset pb_msg_german "MC(block,delete_popup,Label)"           "Löschen"
::msgcat::mcset pb_msg_german "MC(block,undo_popup,Label)"             "Rückgängig"
::msgcat::mcset pb_msg_german "MC(block,delete_all,Label)"             "Alle aktiven Elemente löschen"

::msgcat::mcset pb_msg_german "MC(block,cmd_title,Label)"              "Anwenderdef. Befehl"
::msgcat::mcset pb_msg_german "MC(block,oper_title,Label)"             "Bedienermeldung"
::msgcat::mcset pb_msg_german "MC(block,addr_title,Label)"             "WORT"

::msgcat::mcset pb_msg_german "MC(block,new_trans,title,Label)"        "WORT"

::msgcat::mcset pb_msg_german "MC(block,new,word_desc,Label)"          "Neue Adresse"
::msgcat::mcset pb_msg_german "MC(block,oper,word_desc,Label)"         "Bedienermeldung"
::msgcat::mcset pb_msg_german "MC(block,cmd,word_desc,Label)"          "Anwenderdef. Befehl"
::msgcat::mcset pb_msg_german "MC(block,user,word_desc,Label)"         "Anwenderdefinierter Ausdruck"
::msgcat::mcset pb_msg_german "MC(block,text,word_desc,Label)"         "Textzeichenfolge"

::msgcat::mcset pb_msg_german "MC(block,user,expr,Label)"              "Ausdruck"

::msgcat::mcset pb_msg_german "MC(block,msg,min_word)"                 "Ein Datenblock sollte mindestens ein Wort enthalten."

::msgcat::mcset pb_msg_german "MC(block,name_msg)"                     "Ungültiger Blockname.\n Einen anderen Namen festlegen."

##---------
## ADDRESS
##
::msgcat::mcset pb_msg_german "MC(address,tab,Label)"                  "WORT"
::msgcat::mcset pb_msg_german "MC(address,Status)"                     "Wörter definieren"

::msgcat::mcset pb_msg_german "MC(address,name,Label)"                 "Wortname"
::msgcat::mcset pb_msg_german "MC(address,name,Context)"               "Der Wortname kann bearbeitet werden."

::msgcat::mcset pb_msg_german "MC(address,verify,Label)"               "WORT -- Überprüfung"
::msgcat::mcset pb_msg_german "MC(address,verify,Context)"             "Dieses Fenster zeigt den bezeichnenden N/C-Code an, der für ein Wort ausgegeben werden soll."

::msgcat::mcset pb_msg_german "MC(address,leader,Label)"               "Bezugspfeil"
::msgcat::mcset pb_msg_german "MC(address,leader,Context)"             "Eine beliebige Zeichenanzahl kann als Bezugspfeil für ein Wort eingegeben werden; ebenso kann mit der rechten Maustaste ein Zeichen aus dem Kontextmenü ausgewählt werden."

::msgcat::mcset pb_msg_german "MC(address,format,Label)"               "Format"
::msgcat::mcset pb_msg_german "MC(address,format,edit,Label)"          "Bearbeiten"
::msgcat::mcset pb_msg_german "MC(address,format,edit,Context)"        "Diese Schaltfläche ermöglicht die Bearbeitung des Formats, das von einem Wort verwendet wird."
::msgcat::mcset pb_msg_german "MC(address,format,new,Label)"           "Neu"
::msgcat::mcset pb_msg_german "MC(address,format,new,Context)"         "Diese Schaltfläche ermöglicht die Erstellung eines neuen Formats."

::msgcat::mcset pb_msg_german "MC(address,format,select,Label)"        "WORT -- Format auswählen"
::msgcat::mcset pb_msg_german "MC(address,format,select,Context)"      "Diese Schaltfläche ermöglicht, dass verschiedene Formate für ein Wort ausgewählt werden können."

::msgcat::mcset pb_msg_german "MC(address,trailer,Label)"              "Präfix"
::msgcat::mcset pb_msg_german "MC(address,trailer,Context)"            "Eine beliebige Zeichenanzahl kann als Präfix für ein Wort eingegeben werden; ebenso kann mit der rechten Maustaste ein Zeichen aus dem Kontextmenü ausgewählt werden."

::msgcat::mcset pb_msg_german "MC(address,modality,Label)"             "Modal ?"
::msgcat::mcset pb_msg_german "MC(address,modality,Context)"           "Mit dieser Option kann die Modalität für ein Wort festgelegt werden."

::msgcat::mcset pb_msg_german "MC(address,modal_drop,off,Label)"       "Aus"
::msgcat::mcset pb_msg_german "MC(address,modal_drop,once,Label)"      "Einmalig"
::msgcat::mcset pb_msg_german "MC(address,modal_drop,always,Label)"    "Immer"

::msgcat::mcset pb_msg_german "MC(address,max,value,Label)"            "Maximum"
::msgcat::mcset pb_msg_german "MC(address,max,value,Context)"          "Ein maximaler Wert für ein Wort wird festgelegt."

::msgcat::mcset pb_msg_german "MC(address,value,text,Label)"           "Wert"

::msgcat::mcset pb_msg_german "MC(address,trunc_drop,Label)"           "Wert abschneiden"
::msgcat::mcset pb_msg_german "MC(address,warn_drop,Label)"            "Anwender warnen"
::msgcat::mcset pb_msg_german "MC(address,abort_drop,Label)"           "Prozess abbrechen"

::msgcat::mcset pb_msg_german "MC(address,max,error_handle,Label)"     "Ausnahmeverarbeitung"
::msgcat::mcset pb_msg_german "MC(address,max,error_handle,Context)"   "Mit dieser Schaltfläche kann die Methode für die Ausnahmeverarbeitung auf den maximalen Wert festgelegt werden: \n \n * Wert abschneiden \n * Anwender warnen \n * Verarbeitung abbrechen \n"

::msgcat::mcset pb_msg_german "MC(address,min,value,Label)"            "Minimum"
::msgcat::mcset pb_msg_german "MC(address,min,value,Context)"          "Ein minimaler Wert für ein Wort wird festgelegt."

::msgcat::mcset pb_msg_german "MC(address,min,error_handle,Label)"     "Ausnahmeverarbeitung"
::msgcat::mcset pb_msg_german "MC(address,min,error_handle,Context)"   "Mit dieser Schaltfläche kann die Methode für die Ausnahmeverarbeitung auf den minimalen Wert festgelegt werden: \n \n * Wert abschneiden \n * Anwender warnen \n * Verarbeitung abbrechen \n"

::msgcat::mcset pb_msg_german "MC(address,format_trans,title,Label)"   "FORMAT "
::msgcat::mcset pb_msg_german "MC(address,none_popup,Label)"           "Keine"

::msgcat::mcset pb_msg_german "MC(address,exp,Label)"                  "Ausdruck"
::msgcat::mcset pb_msg_german "MC(address,exp,Context)"                "Ein Ausdruck oder eine Konstante kann für einen Block festgelegt werden."
::msgcat::mcset pb_msg_german "MC(address,exp,msg)"                    "Ein Ausdruck für ein Blockelement sollte nicht leer sein."
::msgcat::mcset pb_msg_german "MC(address,exp,space_only)"             "Ein Ausdruck für in Blockelement, das numerisches Format verwendet, darf nicht nur Leerzeichen enthalten."

## No translation is needed for this string.
::msgcat::mcset pb_msg_german "MC(address,exp,spec_char)"              "\!  \"  \#  \&  \'  \.  \;  \<  \=  \>  \?  \@ \[  \\  \]  \^  \`  \{  \|  \}  \~"

::msgcat::mcset pb_msg_german "MC(address,exp,spec_char_msg)"          "Sonderzeichen \n [::msgcat::mc MC(address,exp,spec_char)] \ndürfen nicht in einem Ausdruck für numerische Daten verwendet werden."



::msgcat::mcset pb_msg_german "MC(address,name_msg)"                   "Ungültiger Wortname.\n Bitte einen anderen Namen festlegen."
# - No translation for rapid1, rapid2 & rapid3
::msgcat::mcset pb_msg_german "MC(address,rapid_add_name_msg)"         "Eilgang1, Eilgang2 und Eilgang3 sind für die interne Verwendung des Post Builders reserviert.\n Bitte einen anderen Namen festlegen."

::msgcat::mcset pb_msg_german "MC(address,rapid1,desc)"                "Eilgangposition entlang Längsachse"
::msgcat::mcset pb_msg_german "MC(address,rapid2,desc)"                "Eilgangposition entlang Querachse"
::msgcat::mcset pb_msg_german "MC(address,rapid3,desc)"                "Eilgangposition entlang Spindelachse"

##--------
## FORMAT
##
::msgcat::mcset pb_msg_german "MC(format,tab,Label)"                   "FORMAT"
::msgcat::mcset pb_msg_german "MC(format,Status)"                      "Definieren Sie die Formate"

::msgcat::mcset pb_msg_german "MC(format,verify,Label)"                "FORMAT -- Überprüfung"
::msgcat::mcset pb_msg_german "MC(format,verify,Context)"              "Dieses Fenster zeigt den bezeichnenden N/C-Code an, der mit dem festgelegten Format ausgegeben werden soll."

::msgcat::mcset pb_msg_german "MC(format,name,Label)"                  "Formatname"
::msgcat::mcset pb_msg_german "MC(format,name,Context)"                "Der Formatname kann bearbeitet werden."

::msgcat::mcset pb_msg_german "MC(format,data,type,Label)"             "Datentyp"
::msgcat::mcset pb_msg_german "MC(format,data,type,Context)"           "Der Datentyp für ein Format kann festgelegt werden."
::msgcat::mcset pb_msg_german "MC(format,data,num,Label)"              "Numerisch"
::msgcat::mcset pb_msg_german "MC(format,data,num,Context)"            "Diese Optionen definieren den Datentyp eines Formats als \"Numerisch\"."
::msgcat::mcset pb_msg_german "MC(format,data,num,integer,Label)"      "FORMAT -- Stellen der Ganzzahl"
::msgcat::mcset pb_msg_german "MC(format,data,num,integer,Context)"    "Diese Option definiert die Anzahl der Stellen einer Ganzzahl bzw. den Ganzzahlteil einer reellen Zahl."
::msgcat::mcset pb_msg_german "MC(format,data,num,fraction,Label)"     "FORMAT -- Bruchstellen"
::msgcat::mcset pb_msg_german "MC(format,data,num,fraction,Context)"   "Diese Option definiert die Anzahl der Stellen für den Bruchteil einer reellen Zahl."
::msgcat::mcset pb_msg_german "MC(format,data,num,decimal,Label)"      "Dezimalpunkt ausgeben (.)"
::msgcat::mcset pb_msg_german "MC(format,data,num,decimal,Context)"    "Mit dieser Option können Dezimalpunkte in N/C-Codes ausgegeben werden."
::msgcat::mcset pb_msg_german "MC(format,data,num,lead,Label)"         "Anführende Nullen ausgeben"
::msgcat::mcset pb_msg_german "MC(format,data,num,lead,Context)"       "Diese Option ermöglicht anführenden Nullen den Zusatz zu Nummern im N/C-Code."
::msgcat::mcset pb_msg_german "MC(format,data,num,trail,Label)"        "Nachfolgende Nullen ausgeben"
::msgcat::mcset pb_msg_german "MC(format,data,num,trail,Context)"      "Diese Option ermöglicht nachfolgenden Nullen den Zusatz zu reellen Nummern im N/C-Code."
::msgcat::mcset pb_msg_german "MC(format,data,text,Label)"             "Text"
::msgcat::mcset pb_msg_german "MC(format,data,text,Context)"           "Diese Option definiert den Datentyp eines Formats als \"Textzeichenfolge\"."
::msgcat::mcset pb_msg_german "MC(format,data,plus,Label)"             "Anführendes Pluszeichen (+) ausgeben"
::msgcat::mcset pb_msg_german "MC(format,data,plus,Context)"           "Mit dieser Option können Pluszeichen in N/C-Codes ausgegeben werden."
::msgcat::mcset pb_msg_german "MC(format,zero_msg)"                    "Eine Kopie des Nullformats kann nicht erzeugt werden"
::msgcat::mcset pb_msg_german "MC(format,zero_cut_msg)"                "Ein Nullformat kann nicht gelöscht werden"

::msgcat::mcset pb_msg_german "MC(format,data,dec_zero,msg)"           "Mindestens eine der Optionen des Dezimalpunkts, der anführenden bzw. nachfolgenden Nullen sollte geprüft werden."

::msgcat::mcset pb_msg_german "MC(format,data,no_digit,msg)"           "Die Anzahl der Stellen für Ganzzahl und Bruch sollte nicht beide Null betragen."

::msgcat::mcset pb_msg_german "MC(format,name_msg)"                    "Ungültiger Formatname.\n Einen anderen Namen festlegen."
::msgcat::mcset pb_msg_german "MC(format,error,title)"                 "Formatfehler"
::msgcat::mcset pb_msg_german "MC(format,error,msg)"                   "Dieses Format wurde in Adressen verwendet"

##---------------------
## Other Data Elements
##
::msgcat::mcset pb_msg_german "MC(other,tab,Label)"                    "Weitere Datenelemente"
::msgcat::mcset pb_msg_german "MC(other,Status)"                       "Parameter festlegen"

::msgcat::mcset pb_msg_german "MC(other,seq_num,Label)"                "Sequenznummer"
::msgcat::mcset pb_msg_german "MC(other,seq_num,Context)"              "Dieser Schalter ermöglicht die Aktivierung/Deaktivierung der Ausgabe von Sequenznummern im N/C-Code."
::msgcat::mcset pb_msg_german "MC(other,seq_num,start,Label)"          "Sequenznummer-Start"
::msgcat::mcset pb_msg_german "MC(other,seq_num,start,Context)"        "Sequenznummer-Start festlegen"
::msgcat::mcset pb_msg_german "MC(other,seq_num,inc,Label)"            "Sequenznummer-Inkrement"
::msgcat::mcset pb_msg_german "MC(other,seq_num,inc,Context)"          "Inkrement der Sequenznummern festlegen."
::msgcat::mcset pb_msg_german "MC(other,seq_num,freq,Label)"           "Sequenznummer-Frequenz"
::msgcat::mcset pb_msg_german "MC(other,seq_num,freq,Context)"         "Die im N/C-Code angezeigte Frequenz der Sequenznummern festlegen."
::msgcat::mcset pb_msg_german "MC(other,seq_num,max,Label)"            "Sequenznummer-Maximum"
::msgcat::mcset pb_msg_german "MC(other,seq_num,max,Context)"          "Max. Wert der Sequenznummern festlegen."

::msgcat::mcset pb_msg_german "MC(other,chars,Label)"                  "Sonderzeichen"
::msgcat::mcset pb_msg_german "MC(other,chars,word_sep,Label)"         "Leerzeichen"
::msgcat::mcset pb_msg_german "MC(other,chars,word_sep,Context)"       "Ein als Leerzeichen zu verwendendes Leerzeichen festlegen."
::msgcat::mcset pb_msg_german "MC(other,chars,decimal_pt,Label)"       "Dezimalpunkt"
::msgcat::mcset pb_msg_german "MC(other,chars,decimal_pt,Context)"     "Ein als Dezimalpunkt zu verwendendes Zeichen festlegen."
::msgcat::mcset pb_msg_german "MC(other,chars,end_of_block,Label)"     "Blockende"
::msgcat::mcset pb_msg_german "MC(other,chars,end_of_block,Context)"   "Ein als Blockende zu verwendendes Zeichen festlegen."
::msgcat::mcset pb_msg_german "MC(other,chars,comment_start,Label)"    "Meldungsanfang"
::msgcat::mcset pb_msg_german "MC(other,chars,comment_start,Context)"  "Zeichen als Anfang einer Bedienermeldungszeile festlegen."
::msgcat::mcset pb_msg_german "MC(other,chars,comment_end,Label)"      "Meldungsende"
::msgcat::mcset pb_msg_german "MC(other,chars,comment_end,Context)"    "Zeichen als Ende einer Bedienermeldungszeile festlegen."

::msgcat::mcset pb_msg_german "MC(other,opskip,Label)"                 "OPSKIP"
::msgcat::mcset pb_msg_german "MC(other,opskip,leader,Label)"          "Bezugslinie"
::msgcat::mcset pb_msg_german "MC(other,opskip,leader,Context)"        "OPSKIP-Bezugslinie"

::msgcat::mcset pb_msg_german "MC(other,gm_codes,Label)"               "G- & M-Codeausgabe pro Block"
::msgcat::mcset pb_msg_german "MC(other,g_codes,Label)"                "Anzahl von G-Codes pro Block"
::msgcat::mcset pb_msg_german "MC(other,g_codes,Context)"              "Dieser Schalter ermöglicht die Aktivierung/Deaktivierung der Kontrolle der Anzahl von G-Codes pro N/C-Ausgabeblock."
::msgcat::mcset pb_msg_german "MC(other,g_codes,num,Label)"            "Anzahl von G-Codes"
::msgcat::mcset pb_msg_german "MC(other,g_codes,num,Context)"          "Anzahl der G-Codes pro N/C-Ausgabeblock festlegen."
::msgcat::mcset pb_msg_german "MC(other,m_codes,Label)"                "Anzahl von M-Codes"
::msgcat::mcset pb_msg_german "MC(other,m_codes,Context)"              "Dieser Schalter ermöglicht die Aktivierung/Deaktivierung der Kontrolle der Anzahl von M-Codes pro N/C-Ausgabeblock."
::msgcat::mcset pb_msg_german "MC(other,m_codes,num,Label)"            "Anzahl von M-Codes pro Block"
::msgcat::mcset pb_msg_german "MC(other,m_codes,num,Context)"          "Anzahl der M-Codes pro N/C-Ausgabeblock festlegen."

::msgcat::mcset pb_msg_german "MC(other,opt_none,Label)"               "Keine"
::msgcat::mcset pb_msg_german "MC(other,opt_space,Label)"              "Raum"
::msgcat::mcset pb_msg_german "MC(other,opt_dec,Label)"                "Dezimal (.)"
::msgcat::mcset pb_msg_german "MC(other,opt_comma,Label)"              "Komma (,)"
::msgcat::mcset pb_msg_german "MC(other,opt_semi,Label)"               "Strichpunkt (;)"
::msgcat::mcset pb_msg_german "MC(other,opt_colon,Label)"              "Doppelpunkt (:)"
::msgcat::mcset pb_msg_german "MC(other,opt_text,Label)"               "Textzeichenfolge"
::msgcat::mcset pb_msg_german "MC(other,opt_left,Label)"               "Linke Klammer ("
::msgcat::mcset pb_msg_german "MC(other,opt_right,Label)"              "Rechte Klammer )"
::msgcat::mcset pb_msg_german "MC(other,opt_pound,Label)"              "Raute-Zeichen (\#)"
::msgcat::mcset pb_msg_german "MC(other,opt_aster,Label)"              "Sternchen (*)"
::msgcat::mcset pb_msg_german "MC(other,opt_slash,Label)"              "Schrägstrich (/)"
::msgcat::mcset pb_msg_german "MC(other,opt_new_line,Label)"           "Neue Zeile (\\012)"

# UDE Inclusion
::msgcat::mcset pb_msg_german "MC(other,ude,Label)"                    "Anwenderdefinierte Ereignisse"
::msgcat::mcset pb_msg_german "MC(other,ude_include,Label)"            "Andere CDL-Datei einschließen"
::msgcat::mcset pb_msg_german "MC(other,ude_include,Context)"          "Mit dieser Option kann dieser Posten eine Referenz in eine CDL-Datei der Definitionsdatei einschließen."

::msgcat::mcset pb_msg_german "MC(other,ude_file,Label)"               "CDL-Dateiname"
::msgcat::mcset pb_msg_german "MC(other,ude_file,Context)"             "Pfad - und Dateiname einer CDL-Datei, die in der Definitionsdatei dieses Postens referenziert (EINSCHLIESSEN) werden sollen.  Der Pfadname muss mit einer UG-Umgebungsvariable (\\\$UGII) oder keiner beginnen.  Wenn kein Pfad festgelegt ist wird \"UGII_CAM_FILE_SEARCH_PATH\" zur Dateilokalisierung bei UG/NX-Laufzeit verwendet."
::msgcat::mcset pb_msg_german "MC(other,ude_select,Label)"             "Name auswählen"
::msgcat::mcset pb_msg_german "MC(other,ude_select,Context)"           "Eine CDL-Datei auswählen, die in der Definitionsdatei dieses Postens referenziert (EINSCHLIESSEN) werden soll.  Standardmäßig wird dem ausgewählten Dateinamen \\\$\"UGII_CAM_USER_DEF_EVENT_DIR/\" vorangestellt.  Der Pfadname kann nach der Auswahl wie gewünscht bearbeitet werden."


#+++++++++++++++++
# Output Settings
#+++++++++++++++++
::msgcat::mcset pb_msg_german "MC(output,tab,Label)"                   "Ausgabeeinstellungen"
::msgcat::mcset pb_msg_german "MC(output,Status)"                      "Ausgabeparameter konfigurieren"

#++++++++++++++
# VNC Controls
#++++++++++++++
::msgcat::mcset pb_msg_german "MC(output,vnc,Label)"                   "Virtuelle N/C-Steuerung"
::msgcat::mcset pb_msg_german "MC(output,vnc,mode,std,Label)"          "Alleinstehendes"
::msgcat::mcset pb_msg_german "MC(output,vnc,mode,sub,Label)"          "Untergeordnet"
::msgcat::mcset pb_msg_german "MC(output,vnc,status,Label)"            "Eine VNC-Datei auswählen"
::msgcat::mcset pb_msg_german "MC(output,vnc,mis_match,Label)"         "Die ausgewählte Datei stimmt nicht mit dem VNC-Standarddateinamen überein.\n Datei erneut auswählen?"
::msgcat::mcset pb_msg_german "MC(output,vnc,output,Label)"            "Virtuelle N/C-Steuerung (VNC) erzeugen"
::msgcat::mcset pb_msg_german "MC(output,vnc,output,Context)"          "Diese Option ermöglicht die Erzeugung einer virtuellen N/C-Steuerung (VNC).  Daher kann ein mit aktivierter VNC erzeugter Posten für ISV verwendet werden"
::msgcat::mcset pb_msg_german "MC(output,vnc,main,Label)"              "Master-VNC"
::msgcat::mcset pb_msg_german "MC(output,vnc,main,Context)"            "Der Name des Master-VNC, für den das untergeordnete VNC als Ausgangspunkt verwendet wird.  Vermutlich wird dieser Posten während der ISV-Laufzeit in dem Verzeichnis enthalten sein, in dem sich das untergeordnete VNC befindet; anderenfalls wird ein Posten mit identischem Namen im Verzeichnis \\\$\"UGII_CAM_POST_DIR\" verwendet."


::msgcat::mcset pb_msg_german "MC(output,vnc,main,err_msg)"                 "Master-VNC muss für eine untergeordnete VNC festgelegt werden."
::msgcat::mcset pb_msg_german "MC(output,vnc,main,select_name,Label)"       "Name auswählen"
::msgcat::mcset pb_msg_german "MC(output,vnc,main,select_name,Context)"     "Wählen Sie den Namen eines VNC, für das das untergeordnete VNC als Ausgangspunkt verwendet werden soll.  Vermutlich wird dieser Posten während der ISV-Laufzeit in dem Verzeichnis enthalten sein, in dem sich das untergeordnete VNC befindet; anderenfalls wird ein Posten mit identischem Namen im Verzeichnis \\\$\"UGII_CAM_POST_DIR\" verwendet."

::msgcat::mcset pb_msg_german "MC(output,vnc,mode,Label)"                   "Virtueller N/C-Steuerungsmodus"
::msgcat::mcset pb_msg_german "MC(output,vnc,mode,Context)"                 "Eine virtuelle N/C-Steuerung kann entweder \"eigenständig\" oder der Master-VNC \"untergeordnet\" sein."
::msgcat::mcset pb_msg_german "MC(output,vnc,mode,std,Context)"             "Eine alleinstehende VNC ist \"eigenständig\"."
::msgcat::mcset pb_msg_german "MC(output,vnc,mode,sub,Context)"             "Ein untergeordnetes VNC ist stark abhängig von der Master-VNC.  Während der ISV-Laufzeit wird das untergeordnete VNC vom Master-VNC als Ausgangspunkt verwendet."
::msgcat::mcset pb_msg_german "MC(output,vnc,pb_ver,msg)"                   "Mit Post Builder erzeugte virtuelle N/C-Steuerung "
#++++++++++++++
# Listing File
#++++++++++++++
::msgcat::mcset pb_msg_german "MC(listing,tab,Label)"                  "Auflistungsdatei"
::msgcat::mcset pb_msg_german "MC(listing,Status)"                     "Parameter der Auflistungsdatei festlegen"

::msgcat::mcset pb_msg_german "MC(listing,gen,Label)"                  "Auflistungsdatei erzeugen"
::msgcat::mcset pb_msg_german "MC(listing,gen,Context)"                "Dieser Schalter ermöglicht die Aktivierung/Deaktivierung der Auflistungsdateiausgabe."

::msgcat::mcset pb_msg_german "MC(listing,Label)"                      "Auflistungsdatei-Elemente"
::msgcat::mcset pb_msg_german "MC(listing,parms,Label)"                "Komponenten"

::msgcat::mcset pb_msg_german "MC(listing,parms,x,Label)"              "X-Koordinate"
::msgcat::mcset pb_msg_german "MC(listing,parms,x,Context)"            "Dieser Schalter ermöglicht die Aktivierung/Deaktivierung der Ausgabe der X-Koordinate in die Auflistungsdatei."

::msgcat::mcset pb_msg_german "MC(listing,parms,y,Label)"              "Y-Koordinate"
::msgcat::mcset pb_msg_german "MC(listing,parms,y,Context)"            "Dieser Schalter ermöglicht die Aktivierung/Deaktivierung der Ausgabe der Y-Koordinate in die Auflistungsdatei."

::msgcat::mcset pb_msg_german "MC(listing,parms,z,Label)"              "Z-Koordinate"
::msgcat::mcset pb_msg_german "MC(listing,parms,z,Context)"            "Dieser Schalter ermöglicht die Aktivierung/Deaktivierung der Ausgabe der Z-Koordinate in die Auflistungsdatei."

::msgcat::mcset pb_msg_german "MC(listing,parms,4,Label)"              "4-Achsenwinkel"
::msgcat::mcset pb_msg_german "MC(listing,parms,4,Context)"            "Dieser Schalter ermöglicht die Aktivierung/Deaktivierung der Ausgabe des 4-Achsenwinkel in die Auflistungsdatei."

::msgcat::mcset pb_msg_german "MC(listing,parms,5,Label)"              "5-Achsenwinkel"
::msgcat::mcset pb_msg_german "MC(listing,parms,5,Context)"            "Dieser Schalter ermöglicht die Aktivierung/Deaktivierung der Ausgabe des 5-Achsenwinkel in die Auflistungsdatei."

::msgcat::mcset pb_msg_german "MC(listing,parms,feed,Label)"           "Vorschub"
::msgcat::mcset pb_msg_german "MC(listing,parms,feed,Context)"         "Dieser Schalter ermöglicht die Aktivierung/Deaktivierung der Vorschubausgabe in die Auflistungsdatei."

::msgcat::mcset pb_msg_german "MC(listing,parms,speed,Label)"          "Drehzahl"
::msgcat::mcset pb_msg_german "MC(listing,parms,speed,Context)"        "Dieser Schalter ermöglicht die Aktivierung/Deaktivierung der Spindelausgabe in die Auflistungsdatei."

::msgcat::mcset pb_msg_german "MC(listing,extension,Label)"            "Auflistungsdatei-Erweiterung"
::msgcat::mcset pb_msg_german "MC(listing,extension,Context)"          "Auflistungsdatei-Erweiterung festlegen"

::msgcat::mcset pb_msg_german "MC(listing,nc_file,Label)"              "N/C-Ausgabedateierweiterung"
::msgcat::mcset pb_msg_german "MC(listing,nc_file,Context)"            "N/C-Ausgabedateierweiterung festlegen"

::msgcat::mcset pb_msg_german "MC(listing,header,Label)"               "Programm-Header"
::msgcat::mcset pb_msg_german "MC(listing,header,oper_list,Label)"     "Operationsliste"
::msgcat::mcset pb_msg_german "MC(listing,header,tool_list,Label)"     "Werkzeugliste"

::msgcat::mcset pb_msg_german "MC(listing,footer,Label)"               "Programm-Fußzeile"
::msgcat::mcset pb_msg_german "MC(listing,footer,cut_time,Label)"      "Gesamtbearbeitungszeit"

::msgcat::mcset pb_msg_german "MC(listing,format,Label)"                   "Seitenformat"
::msgcat::mcset pb_msg_german "MC(listing,format,print_header,Label)"      "Seitenkopfzeile drucken"
::msgcat::mcset pb_msg_german "MC(listing,format,print_header,Context)"    "Dieser Schalter ermöglicht die Aktivierung/Deaktivierung der Ausgabe der Seitenkopfzeile in die Auflistungsdatei."

::msgcat::mcset pb_msg_german "MC(listing,format,length,Label)"        "Seitenlänge (Zeilen)"
::msgcat::mcset pb_msg_german "MC(listing,format,length,Context)"      "Zeilenanzahl pro Seite für die Auflistungsdatei festlegen."
::msgcat::mcset pb_msg_german "MC(listing,format,width,Label)"         "Seitenbreite (Spalten)"
::msgcat::mcset pb_msg_german "MC(listing,format,width,Context)"       "Spaltenanzahl pro Seite für die Auflistungsdatei festlegen."

::msgcat::mcset pb_msg_german "MC(listing,other,tab,Label)"            "Weitere Optionen"
::msgcat::mcset pb_msg_german "MC(listing,output,Label)"               "Ausgabe-Steuerungselemente"

::msgcat::mcset pb_msg_german "MC(listing,output,warning,Label)"       "Ausgabe-Warnmeldung"
::msgcat::mcset pb_msg_german "MC(listing,output,warning,Context)"     "Dieser Schalter ermöglicht die Aktivierung/Deaktivierung der Ausgabe von Warnmeldungen bei der Nachbearbeitung."

::msgcat::mcset pb_msg_german "MC(listing,output,review,Label)"        "\"Review Tool\" aktivieren"
::msgcat::mcset pb_msg_german "MC(listing,output,review,Context)"      "Mit diesem Schalter kann das \"Review Tool\" während der Nachbearbeitung aktiviert werden."

::msgcat::mcset pb_msg_german "MC(listing,output,group,Label)"         "Gruppenausgabe erzeugen"
::msgcat::mcset pb_msg_german "MC(listing,output,group,Context)"       "Mit diesem Schalter kann die Kontrolle der Gruppenausgabe während der Nachbearbeitung aktiviert/deaktiviert werden."

::msgcat::mcset pb_msg_german "MC(listing,output,verbose,Label)"       "Verbose-Fehlermeldung anzeigen"
::msgcat::mcset pb_msg_german "MC(listing,output,verbose,Context)"     "Mit diesem Schalter können erweiterte Beschreibungen für die Fehlerbedingungen angezeigt werden. Die Geschwindigkeit der Nachbearbeitung wird dadurch verringert."

::msgcat::mcset pb_msg_german "MC(listing,oper_info,Label)"            "Operationsinformation"
::msgcat::mcset pb_msg_german "MC(listing,oper_info,parms,Label)"      "Operationsparameter"
::msgcat::mcset pb_msg_german "MC(listing,oper_info,tool,Label)"       "Werkzeugparameter"
::msgcat::mcset pb_msg_german "MC(listing,oper_info,cut_time,,Label)"  "Bearbeitungszeit"


#<09-19-00 gsl>
::msgcat::mcset pb_msg_german "MC(listing,user_tcl,frame,Label)"       "Tcl-Ausgangsbenutzer"
::msgcat::mcset pb_msg_german "MC(listing,user_tcl,check,Label)"       "Tcl-Datei des Ausgangsbenutzers"
::msgcat::mcset pb_msg_german "MC(listing,user_tcl,check,Context)"     "Mit diesem Schalter können Sie Ihre Tcl-Datei als Ausgangspunkt verwenden. "
::msgcat::mcset pb_msg_german "MC(listing,user_tcl,name,Label)"        "Dateiname"
::msgcat::mcset pb_msg_german "MC(listing,user_tcl,name,Context)"      "Legen Sie den Namen einer Tcl-Datei fest, die für diesen Posten als Ausgangspunkt verwendet werden soll."

#++++++++++++++++
# Output Preview
#++++++++++++++++
::msgcat::mcset pb_msg_german "MC(preview,tab,Label)"                  "Vorschau der PP-Dateien"
::msgcat::mcset pb_msg_german "MC(preview,new_code,Label)"             "Neuer Code"
::msgcat::mcset pb_msg_german "MC(preview,old_code,Label)"             "Alter Code"

##---------------------
## Event Handler
##
::msgcat::mcset pb_msg_german "MC(event_handler,tab,Label)"            "Ereignis-Handler"
::msgcat::mcset pb_msg_german "MC(event_handler,Status)"               "Ereignis auswählen, um den Vorgang anzuzeigen"

##---------------------
## Definition
##
::msgcat::mcset pb_msg_german "MC(definition,tab,Label)"               "Definitionen"
::msgcat::mcset pb_msg_german "MC(definition,Status)"                  "Element auswählen, um die Inhalte anzuzeigen"

#++++++++++++++
# Post Advisor
#++++++++++++++
::msgcat::mcset pb_msg_german "MC(advisor,tab,Label)"                  "PP-Assistent"
::msgcat::mcset pb_msg_german "MC(advisor,Status)"                     "PP-Assistent"

::msgcat::mcset pb_msg_german "MC(definition,word_txt,Label)"          "WORD_SEPARATOR"
::msgcat::mcset pb_msg_german "MC(definition,end_txt,Label)"           "END_OF_BLOCK"
::msgcat::mcset pb_msg_german "MC(definition,seq_txt,Label)"           "SEQUENCE_NUM"
::msgcat::mcset pb_msg_german "MC(definition,include,Label)"           "Einschließen"
::msgcat::mcset pb_msg_german "MC(definition,format_txt,Label)"        "FORMAT"
::msgcat::mcset pb_msg_german "MC(definition,addr_txt,Label)"          "WORT"
::msgcat::mcset pb_msg_german "MC(definition,block_txt,Label)"         "BLOCK"
::msgcat::mcset pb_msg_german "MC(definition,comp_txt,Label)"          "Zusammengesetzter BLOCK"
::msgcat::mcset pb_msg_german "MC(definition,post_txt,Label)"          "PP-BLOCK"
::msgcat::mcset pb_msg_german "MC(definition,oper_txt,Label)"          "Bedienermeldung"

#+++++++++++++
# Balloon
#+++++++++++++
::msgcat::mcset pb_msg_german "MC(msg,odd)"                            "Ungerade Anzahl optionaler Argumente"
::msgcat::mcset pb_msg_german "MC(msg,wrong_list_1)"                   "Unbekannte Optionen"
::msgcat::mcset pb_msg_german "MC(msg,wrong_list_2)"                   ". Muss enthalten sein in:"

#+++++++++++++++++
# Event UI Labels
#+++++++++++++++++

### Program Start
::msgcat::mcset pb_msg_german "MC(event,start_prog,name)"              "Programmstart"

### Operation Start
::msgcat::mcset pb_msg_german "MC(event,opr_start,start_path,name)"    "Pfadanfang"
::msgcat::mcset pb_msg_german "MC(event,opr_start,from_move,name)"     "Von Bewegung"
::msgcat::mcset pb_msg_german "MC(event,opr_start,fst_tool,name)"      "Erstes Werkzeug"
::msgcat::mcset pb_msg_german "MC(event,opr_start,auto_tc,name)"       "Autom. Wkz-Wechsel"
::msgcat::mcset pb_msg_german "MC(event,opr_start,manual_tc,name)"     "Manueller Wkz-Wechsel"
::msgcat::mcset pb_msg_german "MC(event,opr_start,init_move,name)"     "Ausgangsbewegung"
::msgcat::mcset pb_msg_german "MC(event,opr_start,fst_move,name)"      "Erste Bewegung"
::msgcat::mcset pb_msg_german "MC(event,opr_start,appro_move,name)"    "Annäherungsbewegung"
::msgcat::mcset pb_msg_german "MC(event,opr_start,engage_move,name)"   "Anfahrbewegung"
::msgcat::mcset pb_msg_german "MC(event,opr_start,fst_cut,name)"       "Erster Schnitt"
::msgcat::mcset pb_msg_german "MC(event,opr_start,fst_lin_move,name)"  "Erste lineare Verschiebung"
::msgcat::mcset pb_msg_german "MC(event,opr_start,start_pass,name)"    "Weganfang"
::msgcat::mcset pb_msg_german "MC(event,opr_start,cutcom_move,name)"   "Wkz-Kompensationsbewegung"
::msgcat::mcset pb_msg_german "MC(event,opr_start,lead_move,name)"     "Zuführbewegung"

### Operation End
::msgcat::mcset pb_msg_german "MC(event,opr_end,ret_move,name)"        "Abfahrbewegung"
::msgcat::mcset pb_msg_german "MC(event,opr_end,rtn_move,name)"        "Rückfahrbewegung"
::msgcat::mcset pb_msg_german "MC(event,opr_end,goh_move,name)"        "Ausgangspositionsbewegung"
::msgcat::mcset pb_msg_german "MC(event,opr_end,end_path,name)"        "Pfadende"
::msgcat::mcset pb_msg_german "MC(event,opr_end,lead_move,name)"       "Rückzugbewegung"
::msgcat::mcset pb_msg_german "MC(event,opr_end,end_pass,name)"        "Wegende"

### Program End
::msgcat::mcset pb_msg_german "MC(event,end_prog,name)"                "Programmende"


### Tool Change
::msgcat::mcset pb_msg_german "MC(event,tool_change,name)"             "Werkzeugwechsel"
::msgcat::mcset pb_msg_german "MC(event,tool_change,m_code)"           "M-Code"
::msgcat::mcset pb_msg_german "MC(event,tool_change,m_code,tl_chng)"   "Werkzeugwechsel"
::msgcat::mcset pb_msg_german "MC(event,tool_change,m_code,pt)"        "Primärer Revolverkopf"
::msgcat::mcset pb_msg_german "MC(event,tool_change,m_code,st)"        "Sekundärer Revolverkopf"
::msgcat::mcset pb_msg_german "MC(event,tool_change,t_code)"           "T-Code"
::msgcat::mcset pb_msg_german "MC(event,tool_change,t_code,conf)"      "Konfigurieren"
::msgcat::mcset pb_msg_german "MC(event,tool_change,t_code,pt_idx)"    "Primärer Revolverindex"
::msgcat::mcset pb_msg_german "MC(event,tool_change,t_code,st_idx)"    "Sekundärer Revolverindex"
::msgcat::mcset pb_msg_german "MC(event,tool_change,tool_num)"         "Wkz-Nummer"
::msgcat::mcset pb_msg_german "MC(event,tool_change,tool_num,min)"     "Minimum"
::msgcat::mcset pb_msg_german "MC(event,tool_change,tool_num,max)"     "Maximum"
::msgcat::mcset pb_msg_german "MC(event,tool_change,time)"             "Zeit (Sek.)"
::msgcat::mcset pb_msg_german "MC(event,tool_change,time,tl_chng)"     "Werkzeugwechsel"
::msgcat::mcset pb_msg_german "MC(event,tool_change,retract)"          "Abfahren"
::msgcat::mcset pb_msg_german "MC(event,tool_change,retract_z)"        "Rückzug zu Z von"

### Length Compensation
::msgcat::mcset pb_msg_german "MC(event,length_compn,name)"            "Längenkompensation"
::msgcat::mcset pb_msg_german "MC(event,length_compn,g_code)"          "G-Code"
::msgcat::mcset pb_msg_german "MC(event,length_compn,g_code,len_adj)"  "Wkz-Längenanpassung"
::msgcat::mcset pb_msg_german "MC(event,length_compn,t_code)"          "T-Code"
::msgcat::mcset pb_msg_german "MC(event,length_compn,t_code,conf)"     "Konfigurieren"
::msgcat::mcset pb_msg_german "MC(event,length_compn,len_off)"         "Offset-Längenregister"
::msgcat::mcset pb_msg_german "MC(event,length_compn,len_off,min)"     "Minimum"
::msgcat::mcset pb_msg_german "MC(event,length_compn,len_off,max)"     "Maximum"

### Set Modes
::msgcat::mcset pb_msg_german "MC(event,set_modes,name)"               "Modi einstellen"
::msgcat::mcset pb_msg_german "MC(event,set_modes,out_mode)"           "Ausgabemodus"
::msgcat::mcset pb_msg_german "MC(event,set_modes,g_code)"             "G-Code"
::msgcat::mcset pb_msg_german "MC(event,set_modes,g_code,absolute)"    "Absolut"
::msgcat::mcset pb_msg_german "MC(event,set_modes,g_code,incremental)" "Inkremental"
::msgcat::mcset pb_msg_german "MC(event,set_modes,rotary_axis)"        "Rotationsachse kann inkremental sein"

### Spindle RPM
::msgcat::mcset pb_msg_german "MC(event,spindle_rpm,name)"                     "U/min der Spindel"
::msgcat::mcset pb_msg_german "MC(event,spindle_rpm,dir_m_code)"               "Spindelrichtung - M-Codes"
::msgcat::mcset pb_msg_german "MC(event,spindle_rpm,dir_m_code,cw)"            "Im Uhrzeigersinn (CW)"
::msgcat::mcset pb_msg_german "MC(event,spindle_rpm,dir_m_code,ccw)"           "Geg. Uhrzeigersinn (CCW)"
::msgcat::mcset pb_msg_german "MC(event,spindle_rpm,range_control)"            "Spindelbereichssteuerung"
::msgcat::mcset pb_msg_german "MC(event,spindle_rpm,range_control,dwell_time)" "Bereichswechselhaltezeit (Sek.)"
::msgcat::mcset pb_msg_german "MC(event,spindle_rpm,range_control,range_code)" "Bereichscode festlegen"

### Spindle CSS
::msgcat::mcset pb_msg_german "MC(event,spindle_css,name)"             "CSS-Spindel"
::msgcat::mcset pb_msg_german "MC(event,spindle_css,g_code)"           "G-Spindelcode"
::msgcat::mcset pb_msg_german "MC(event,spindle_css,g_code,const)"     "Konstanter Flächencode"
::msgcat::mcset pb_msg_german "MC(event,spindle_css,g_code,max)"       "Maximaler RPM-Code"
::msgcat::mcset pb_msg_german "MC(event,spindle_css,g_code,sfm)"       "Code für Abbruch von SFM"
::msgcat::mcset pb_msg_german "MC(event,spindle_css,max)"              "Max. RPM bei CSS"
::msgcat::mcset pb_msg_german "MC(event,spindle_css,sfm)"              "Immer IPR-Modus für SFM festlegen"

### Spindle Off
::msgcat::mcset pb_msg_german "MC(event,spindle_off,name)"             "Spindel deaktiviert"
::msgcat::mcset pb_msg_german "MC(event,spindle_off,dir_m_code)"       "Spindelrichtung - M-Code"
::msgcat::mcset pb_msg_german "MC(event,spindle_off,dir_m_code,off)"   "Deaktiviert"

### Coolant On
::msgcat::mcset pb_msg_german "MC(event,coolant_on,name)"              "Kühlmittel aktiviert"
::msgcat::mcset pb_msg_german "MC(event,coolant_on,m_code)"            "M-Code"
::msgcat::mcset pb_msg_german "MC(event,coolant_on,m_code,on)"         "Aktiviert"
::msgcat::mcset pb_msg_german "MC(event,coolant_on,m_code,flood)"      "Fluss"
::msgcat::mcset pb_msg_german "MC(event,coolant_on,m_code,mist)"       "Nebel"
::msgcat::mcset pb_msg_german "MC(event,coolant_on,m_code,thru)"       "Durch"
::msgcat::mcset pb_msg_german "MC(event,coolant_on,m_code,tap)"        "Gewindebohrer"

### Coolant Off
::msgcat::mcset pb_msg_german "MC(event,coolant_off,name)"             "Kühlmittel deaktiviert"
::msgcat::mcset pb_msg_german "MC(event,coolant_off,m_code)"           "M-Code"
::msgcat::mcset pb_msg_german "MC(event,coolant_off,m_code,off)"       "Deaktiviert"

### Inch Metric Mode
::msgcat::mcset pb_msg_german "MC(event,inch_metric_mode,name)"            "Zoll - Metrischer Modus"
::msgcat::mcset pb_msg_german "MC(event,inch_metric_mode,g_code)"          "G-Code"
::msgcat::mcset pb_msg_german "MC(event,inch_metric_mode,g_code,english)"  "Englisch (Zoll)"
::msgcat::mcset pb_msg_german "MC(event,inch_metric_mode,g_code,metric)"   "Metrisch (Millimeter)"

### Feedrates
::msgcat::mcset pb_msg_german "MC(event,feedrates,name)"               "Vorschübe"
::msgcat::mcset pb_msg_german "MC(event,feedrates,ipm_mode)"           "IPM-Modus"
::msgcat::mcset pb_msg_german "MC(event,feedrates,ipr_mode)"           "IPR-Modus"
::msgcat::mcset pb_msg_german "MC(event,feedrates,dpm_mode)"           "DPM-Modus"
::msgcat::mcset pb_msg_german "MC(event,feedrates,mmpm_mode)"          "MMPM-Modus"
::msgcat::mcset pb_msg_german "MC(event,feedrates,mmpr_mode)"          "MMPR-Modus"
::msgcat::mcset pb_msg_german "MC(event,feedrates,frn_mode)"           "FRN-Modus"
::msgcat::mcset pb_msg_german "MC(event,feedrates,g_code)"             "G-Code"
::msgcat::mcset pb_msg_german "MC(event,feedrates,format)"             "Format"
::msgcat::mcset pb_msg_german "MC(event,feedrates,max)"                "Maximum"
::msgcat::mcset pb_msg_german "MC(event,feedrates,min)"                "Minimum"
::msgcat::mcset pb_msg_german "MC(event,feedrates,mode,label)"         "Vorschubmodi"
::msgcat::mcset pb_msg_german "MC(event,feedrates,mode,lin)"           "Nur linear"
::msgcat::mcset pb_msg_german "MC(event,feedrates,mode,rot)"           "Nur drehbar"
::msgcat::mcset pb_msg_german "MC(event,feedrates,mode,lin_rot)"       "Linear und drehbar"
::msgcat::mcset pb_msg_german "MC(event,feedrates,mode,rap_lin)"       "Nur Linear-Eilgang"
::msgcat::mcset pb_msg_german "MC(event,feedrates,mode,rap_rot)"       "Nur Dreh-Eilgang"
::msgcat::mcset pb_msg_german "MC(event,feedrates,mode,rap_lin_rot)"   "Linear- und Dreh-Eilgang"
::msgcat::mcset pb_msg_german "MC(event,feedrates,cycle_mode)"         "Zyklus-Vorschubmodus"
::msgcat::mcset pb_msg_german "MC(event,feedrates,cycle)"              "Zyklus"

### Cutcom On
::msgcat::mcset pb_msg_german "MC(event,cutcom_on,name)"               "Wkz-Kompensation aktiviert"
::msgcat::mcset pb_msg_german "MC(event,cutcom_on,g_code)"             "G-Code"
::msgcat::mcset pb_msg_german "MC(event,cutcom_on,left)"               "Links"
::msgcat::mcset pb_msg_german "MC(event,cutcom_on,right)"              "Rechts"
::msgcat::mcset pb_msg_german "MC(event,cutcom_on,app_planes)"         "Anwendbare Ebenen"
::msgcat::mcset pb_msg_german "MC(event,cutcom_on,edit_planes)"        "Ebenencodes bearbeiten"
::msgcat::mcset pb_msg_german "MC(event,cutcom_on,reg)"                "Wkz-Komp.-Register"
::msgcat::mcset pb_msg_german "MC(event,cutcom_on,min)"                "Minimum"
::msgcat::mcset pb_msg_german "MC(event,cutcom_on,max)"                "Maximum"
::msgcat::mcset pb_msg_german "MC(event,cutcom_on,bef)"                "Wkz-Kompensation vor Wechsel deaktivieren"

### Cutcom Off
::msgcat::mcset pb_msg_german "MC(event,cutcom_off,name)"              "Wkz-Kompensation deaktiviert"
::msgcat::mcset pb_msg_german "MC(event,cutcom_off,g_code)"            "G-Code"
::msgcat::mcset pb_msg_german "MC(event,cutcom_off,off)"               "Aus"

### Delay
::msgcat::mcset pb_msg_german "MC(event,delay,name)"                   "Verzögerung"
::msgcat::mcset pb_msg_german "MC(event,delay,seconds)"                "Sekunden"
::msgcat::mcset pb_msg_german "MC(event,delay,seconds,g_code)"         "G-Code"
::msgcat::mcset pb_msg_german "MC(event,delay,seconds,format)"         "Format"
::msgcat::mcset pb_msg_german "MC(event,delay,out_mode)"               "Ausgabemodus"
::msgcat::mcset pb_msg_german "MC(event,delay,out_mode,sec)"           "Nur Sekunden"
::msgcat::mcset pb_msg_german "MC(event,delay,out_mode,rev)"           "Nur Umdrehungen"
::msgcat::mcset pb_msg_german "MC(event,delay,out_mode,feed)"          "Abhängig von Vorschub"
::msgcat::mcset pb_msg_german "MC(event,delay,out_mode,ivs)"           "Umkehrzeit"
::msgcat::mcset pb_msg_german "MC(event,delay,revolution)"             "Umdrehungen"
::msgcat::mcset pb_msg_german "MC(event,delay,revolution,g_code)"      "G-Code"
::msgcat::mcset pb_msg_german "MC(event,delay,revolution,format)"      "Format"

### Option Stop
::msgcat::mcset pb_msg_german "MC(event,opstop,name)"                  "Opstop"

### Auxfun
::msgcat::mcset pb_msg_german "MC(event,auxfun,name)"                  "Auxfun"

### Prefun
::msgcat::mcset pb_msg_german "MC(event,prefun,name)"                  "Prefun"

### Load Tool
::msgcat::mcset pb_msg_german "MC(event,loadtool,name)"                "Werkzeug laden"

### Stop
::msgcat::mcset pb_msg_german "MC(event,stop,name)"                    "Stopp"

### Tool Preselect
::msgcat::mcset pb_msg_german "MC(event,toolpreselect,name)"           "Wkz-Vorauswahl"

### Thread Wire
::msgcat::mcset pb_msg_german "MC(event,threadwire,name)"              "Gewindedraht"

### Cut Wire
::msgcat::mcset pb_msg_german "MC(event,cutwire,name)"                 "Drahtkorn"

### Wire Guides
::msgcat::mcset pb_msg_german "MC(event,wireguides,name)"              "Drahtführung"

### Linear Move
::msgcat::mcset pb_msg_german "MC(event,linear,name)"                  "Lineare Verschiebung"
::msgcat::mcset pb_msg_german "MC(event,linear,g_code)"                "G-Code"
::msgcat::mcset pb_msg_german "MC(event,linear,motion)"                "Lineare Bewegung"
::msgcat::mcset pb_msg_german "MC(event,linear,assume)"                "Angenommener Eilmodus bei max. Querungsvorschub"

### Circular Move
::msgcat::mcset pb_msg_german "MC(event,circular,name)"                "Kreisförmige Verschiebung"
::msgcat::mcset pb_msg_german "MC(event,circular,g_code)"              "Bewegung - G-Code"
::msgcat::mcset pb_msg_german "MC(event,circular,clockwise)"           "Im Uhrzeigersinn(CLW)"
::msgcat::mcset pb_msg_german "MC(event,circular,counter-clock)"       "Geg. Uhrzeigersinn(CCLW)"
::msgcat::mcset pb_msg_german "MC(event,circular,record)"              "Kreisspurverfahren"
::msgcat::mcset pb_msg_german "MC(event,circular,full_circle)"         "Vollkreis"
::msgcat::mcset pb_msg_german "MC(event,circular,quadrant)"            "Quadrant"
::msgcat::mcset pb_msg_german "MC(event,circular,ijk_def)"             "IJK-Definition"
::msgcat::mcset pb_msg_german "MC(event,circular,ij_def)"              "IJ-Definition"
::msgcat::mcset pb_msg_german "MC(event,circular,ik_def)"              "IK-Definition"
::msgcat::mcset pb_msg_german "MC(event,circular,planes)"              "Anwendbare Ebenen"
::msgcat::mcset pb_msg_german "MC(event,circular,edit_planes)"         "Ebenencodes bearbeiten"
::msgcat::mcset pb_msg_german "MC(event,circular,radius)"              "Radius"
::msgcat::mcset pb_msg_german "MC(event,circular,min)"                 "Minimum"
::msgcat::mcset pb_msg_german "MC(event,circular,max)"                 "Maximum"
::msgcat::mcset pb_msg_german "MC(event,circular,arc_len)"             "Minimale Bogenlänge"

### Rapid Move
::msgcat::mcset pb_msg_german "MC(event,rapid,name)"                   "Eilgangbewegung"
::msgcat::mcset pb_msg_german "MC(event,rapid,g_code)"                 "G-Code"
::msgcat::mcset pb_msg_german "MC(event,rapid,motion)"                 "Eilgang"
::msgcat::mcset pb_msg_german "MC(event,rapid,plane_change)"           "Arbeitsebenen-Wechsel"

### Lathe Thread
::msgcat::mcset pb_msg_german "MC(event,lathe,name)"                   "Gewindeschneiden"
::msgcat::mcset pb_msg_german "MC(event,lathe,g_code)"                 "Gewinde - G-Code"
::msgcat::mcset pb_msg_german "MC(event,lathe,cons)"                   "Konstant"
::msgcat::mcset pb_msg_german "MC(event,lathe,incr)"                   "Inkremental"
::msgcat::mcset pb_msg_german "MC(event,lathe,decr)"                   "Dekremental"

### Cycle
::msgcat::mcset pb_msg_german "MC(event,cycle,g_code)"                 "G-Code & Anpassung"
::msgcat::mcset pb_msg_german "MC(event,cycle,customize,Label)"        "Anpassen"
::msgcat::mcset pb_msg_german "MC(event,cycle,customize,Context)"      "Mit diesem Schalter kann ein Zyklus angepasst werden. \n\nStandardmäßig wird die Basiskonstruktion jedes Zyklus von den Einstellungen der gemeinsam verwendeten Parameter definiert. Diese gemeinsamen Elemente in jedem Zyklus dürfen nicht geändert werden. \n\nMit der Aktivierung dieses Schalters erhalten Sie vollständige Kontrolle über die Konfiguration eines Zyklus.  Vorgenommene Änderungen an den gemeinsam verwendeten Parametern beeinträchtigen den angepassten Zyklus nicht mehr."
::msgcat::mcset pb_msg_german "MC(event,cycle,start,Label)"            "Zyklusanfang"
::msgcat::mcset pb_msg_german "MC(event,cycle,start,Context)"          "Diese Option kann für Maschinen-Wkz, die Zyklen mit Hilfe eines Zyklus-Startblocks (G79...) nachdem der Zyklus definiert wurde (G81...), aktiviert werden."
::msgcat::mcset pb_msg_german "MC(event,cycle,start,text)"             "Zyklus-Startblock für Zyklusausführung verwenden"
::msgcat::mcset pb_msg_german "MC(event,cycle,rapid_to)"               "Eilgang - Zu"
::msgcat::mcset pb_msg_german "MC(event,cycle,retract_to)"             "Rückzug - Zu"
::msgcat::mcset pb_msg_german "MC(event,cycle,plane_control)"          "Zyklus-Ebenensteuerung"
::msgcat::mcset pb_msg_german "MC(event,cycle,com_param,name)"         "Gemeinsam verwendete Parameter"
::msgcat::mcset pb_msg_german "MC(event,cycle,cycle_off,name)"         "Zyklus deaktiviert"
::msgcat::mcset pb_msg_german "MC(event,cycle,plane_chng,name)"        "Zyklus-Ebenenwechsel"
::msgcat::mcset pb_msg_german "MC(event,cycle,drill,name)"             "Bohrer"
::msgcat::mcset pb_msg_german "MC(event,cycle,drill_dwell,name)"       "Bohrhaltezeit"
::msgcat::mcset pb_msg_german "MC(event,cycle,drill_text,name)"        "Bohrer, Eingabe"
::msgcat::mcset pb_msg_german "MC(event,cycle,drill_csink,name)"       "Bohrer, Kegelsenkung"
::msgcat::mcset pb_msg_german "MC(event,cycle,drill_deep,name)"        "Bohrer, tief"
::msgcat::mcset pb_msg_german "MC(event,cycle,drill_brk_chip,name)"    "Bohrer, Spanbrechen"
::msgcat::mcset pb_msg_german "MC(event,cycle,tap,name)"               "Gewindebohrer"
::msgcat::mcset pb_msg_german "MC(event,cycle,bore,name)"              "Bohrung"
::msgcat::mcset pb_msg_german "MC(event,cycle,bore_dwell,name)"        "Bohrhaltezeit"
::msgcat::mcset pb_msg_german "MC(event,cycle,bore_drag,name)"         "Bohrung, ziehen"
::msgcat::mcset pb_msg_german "MC(event,cycle,bore_no_drag,name)"      "Bohrung, nicht ziehen"
::msgcat::mcset pb_msg_german "MC(event,cycle,bore_back,name)"         "Rückbohrung"
::msgcat::mcset pb_msg_german "MC(event,cycle,bore_manual,name)"       "Bohrung, manuell"
::msgcat::mcset pb_msg_german "MC(event,cycle,bore_manual_dwell,name)" "Bohrhaltezeit, manuell"
::msgcat::mcset pb_msg_german "MC(event,cycle,peck_drill,name)"        "Spanbohren"
::msgcat::mcset pb_msg_german "MC(event,cycle,break_chip,name)"        "Span brechen"
::msgcat::mcset pb_msg_german "MC(event,cycle,drill_dwell_sf,name)"    "Bohrerhaltezeit (Punktfläche)"
::msgcat::mcset pb_msg_german "MC(event,cycle,drill_deep_peck,name)"   "Bohrer, tief (Spanbohren)"
::msgcat::mcset pb_msg_german "MC(event,cycle,bore_ream,name)"         "Bohrung (Reibahle)"
::msgcat::mcset pb_msg_german "MC(event,cycle,bore_no-drag,name)"      "Bohrung, nicht ziehen"

##------------
## G Code
##
::msgcat::mcset pb_msg_german "MC(g_code,rapid,name)"                  "Schnelle Bewegung"
::msgcat::mcset pb_msg_german "MC(g_code,linear,name)"                 "Lineare Bewegung"
::msgcat::mcset pb_msg_german "MC(g_code,circular_clw,name)"           "Kreisförmige Interpolation CLW"
::msgcat::mcset pb_msg_german "MC(g_code,circular_cclw,name)"          "Kreisförmige Interpolation CCLW"
::msgcat::mcset pb_msg_german "MC(g_code,delay_sec,name)"              "Verzögerung (Sek.)"
::msgcat::mcset pb_msg_german "MC(g_code,delay_rev,name)"              "Verzögerung (Umdr.)"
::msgcat::mcset pb_msg_german "MC(g_code,pln_xy,name)"                 "XY-Ebene"
::msgcat::mcset pb_msg_german "MC(g_code,pln_zx,name)"                 "ZX-Ebene"
::msgcat::mcset pb_msg_german "MC(g_code,pln_yz,name)"                 "YZ-Ebene"
::msgcat::mcset pb_msg_german "MC(g_code,cutcom_off,name)"             "Wkz-Kompensation deaktiviert"
::msgcat::mcset pb_msg_german "MC(g_code,cutcom_left,name)"            "Wkz-Kompensation links"
::msgcat::mcset pb_msg_german "MC(g_code,cutcom_right,name)"           "Wkz-Kompensation rechts"
::msgcat::mcset pb_msg_german "MC(g_code,length_plus,name)"            "Wkz-Längenanpassung plus"
::msgcat::mcset pb_msg_german "MC(g_code,length_minus,name)"           "Wkz-Längenanpassung minus"
::msgcat::mcset pb_msg_german "MC(g_code,length_off,name)"             "Wkz-Längenanpassung deaktiviert"
::msgcat::mcset pb_msg_german "MC(g_code,inch,name)"                   "Zoll-Modus"
::msgcat::mcset pb_msg_german "MC(g_code,metric,name)"                 "Metrischer Modus"
::msgcat::mcset pb_msg_german "MC(g_code,cycle_start,name)"            "Zyklus-Anfangscode"
::msgcat::mcset pb_msg_german "MC(g_code,cycle_off,name)"              "Zyklus deaktiviert"
::msgcat::mcset pb_msg_german "MC(g_code,cycle_drill,name)"            "Zyklusbohrer"
::msgcat::mcset pb_msg_german "MC(g_code,cycle_drill_dwell,name)"      "Zyklusbohrerhaltezeit"
::msgcat::mcset pb_msg_german "MC(g_code,cycle_drill_deep,name)"       "Zyklusbohrer, tief"
::msgcat::mcset pb_msg_german "MC(g_code,cycle_drill_bc,name)"         "Zyklusbohrer, Spanbrechen"
::msgcat::mcset pb_msg_german "MC(g_code,tap,name)"                    "Zyklus-Gewindebohrer"
::msgcat::mcset pb_msg_german "MC(g_code,bore,name)"                   "Zyklusbohrung"
::msgcat::mcset pb_msg_german "MC(g_code,bore_drag,name)"              "Zyklusbohrung, ziehen"
::msgcat::mcset pb_msg_german "MC(g_code,bore_no_drag,name)"           "Zyklusbohrung, nicht ziehen"
::msgcat::mcset pb_msg_german "MC(g_code,bore_dwell,name)"             "Zyklusbohrhaltezeit"
::msgcat::mcset pb_msg_german "MC(g_code,bore_manual,name)"            "Zyklusbohrung, manuell"
::msgcat::mcset pb_msg_german "MC(g_code,bore_back,name)"              "Zyklusrückbohrung"
::msgcat::mcset pb_msg_german "MC(g_code,bore_manual_dwell,name)"      "Zyklusbohrhaltezeit, manuell"
::msgcat::mcset pb_msg_german "MC(g_code,abs,name)"                    "Absoluter Modus"
::msgcat::mcset pb_msg_german "MC(g_code,inc,name)"                    "Inkrementaler Modus"
::msgcat::mcset pb_msg_german "MC(g_code,cycle_retract_auto,name)"     "Zyklus-Rückzug (AUTOMATISCH)"
::msgcat::mcset pb_msg_german "MC(g_code,cycle_retract_manual,name)"   "Zyklus-Rückzug (MANUELL)"
::msgcat::mcset pb_msg_german "MC(g_code,reset,name)"                  "Zurücksetzen"
::msgcat::mcset pb_msg_german "MC(g_code,fr_ipm,name)"                 "IPM-Vorschubmodus"
::msgcat::mcset pb_msg_german "MC(g_code,fr_ipr,name)"                 "IPR-Vorschubmodus"
::msgcat::mcset pb_msg_german "MC(g_code,fr_frn,name)"                 "FRN-Vorschubmodus"
::msgcat::mcset pb_msg_german "MC(g_code,spindle_css,name)"            "CSS-Spindel"
::msgcat::mcset pb_msg_german "MC(g_code,spindle_rpm,name)"            "U/min der Spindel"
::msgcat::mcset pb_msg_german "MC(g_code,ret_home,name)"               "Zurück zu Ausgangsposition"
::msgcat::mcset pb_msg_german "MC(g_code,cons_thread,name)"            "Konstantes Gewinde"
::msgcat::mcset pb_msg_german "MC(g_code,incr_thread,name)"            "Inkrementales Gewinde"
::msgcat::mcset pb_msg_german "MC(g_code,decr_thread,name)"            "Dekrementales Gewinde"
::msgcat::mcset pb_msg_german "MC(g_code,feedmode_in,pm)"              "IPM-Vorschubmodus"
::msgcat::mcset pb_msg_german "MC(g_code,feedmode_in,pr)"              "IPR-Vorschubmodus"
::msgcat::mcset pb_msg_german "MC(g_code,feedmode_mm,pm)"              "MMPM-Vorschubmodus"
::msgcat::mcset pb_msg_german "MC(g_code,feedmode_mm,pr)"              "MMPR-Vorschubmodus"
::msgcat::mcset pb_msg_german "MC(g_code,feedmode,dpm)"                "DPM-Vorschubmodus"

##------------
## M Code
##
::msgcat::mcset pb_msg_german "MC(m_code,stop_manual_tc,name)"         "Anhalten/Manueller Wkz-Wechsel"
::msgcat::mcset pb_msg_german "MC(m_code,stop,name)"                   "Stopp"
::msgcat::mcset pb_msg_german "MC(m_code,opt_stop,name)"               "Opstop"
::msgcat::mcset pb_msg_german "MC(m_code,prog_end,name)"               "Programmende"
::msgcat::mcset pb_msg_german "MC(m_code,spindle_clw,name)"            "Spindel aktiviert/Im Uhrzeigersinn"
::msgcat::mcset pb_msg_german "MC(m_code,spindle_cclw,name)"           "Spindel - Geg. Uhrzeigersinn"
::msgcat::mcset pb_msg_german "MC(m_code,lathe_thread,type1)"          "Konstantes Gewinde"
::msgcat::mcset pb_msg_german "MC(m_code,lathe_thread,type2)"          "Inkrementales Gewinde"
::msgcat::mcset pb_msg_german "MC(m_code,lathe_thread,type3)"          "Dekrementales Gewinde"
::msgcat::mcset pb_msg_german "MC(m_code,spindle_off,name)"            "Spindel deaktiviert"
::msgcat::mcset pb_msg_german "MC(m_code,tc_retract,name)"             "Wkz-Wechsel/Rückzug"
::msgcat::mcset pb_msg_german "MC(m_code,coolant_on,name)"             "Kühlmittel aktiviert"
::msgcat::mcset pb_msg_german "MC(m_code,coolant_fld,name)"            "Kühlmittelfluss"
::msgcat::mcset pb_msg_german "MC(m_code,coolant_mist,name)"           "Kühlschmiernebel"
::msgcat::mcset pb_msg_german "MC(m_code,coolant_thru,name)"           "Kühlmitteldurchfluss"
::msgcat::mcset pb_msg_german "MC(m_code,coolant_tap,name)"            "Kühlmittelausfluss"
::msgcat::mcset pb_msg_german "MC(m_code,coolant_off,name)"            "Kühlmittel deaktiviert"
::msgcat::mcset pb_msg_german "MC(m_code,rewind,name)"                 "Wiederholen"
::msgcat::mcset pb_msg_german "MC(m_code,thread_wire,name)"            "Gewindedraht"
::msgcat::mcset pb_msg_german "MC(m_code,cut_wire,name)"               "Drahtkorn"
::msgcat::mcset pb_msg_german "MC(m_code,fls_on,name)"                 "Spülen aktiviert"
::msgcat::mcset pb_msg_german "MC(m_code,fls_off,name)"                "Spülen deaktiviert"
::msgcat::mcset pb_msg_german "MC(m_code,power_on,name)"               "Leistung aktiviert"
::msgcat::mcset pb_msg_german "MC(m_code,power_off,name)"              "Leistung deaktiviert"
::msgcat::mcset pb_msg_german "MC(m_code,wire_on,name)"                "Draht aktiviert"
::msgcat::mcset pb_msg_german "MC(m_code,wire_off,name)"               "Draht deaktiviert"
::msgcat::mcset pb_msg_german "MC(m_code,pri_turret,name)"             "Primärer Revolverkopf"
::msgcat::mcset pb_msg_german "MC(m_code,sec_turret,name)"             "Sekundärer Revolverkopf"

##------------
## UDE
##
::msgcat::mcset pb_msg_german "MC(ude,editor,enable,Label)"            "UDE-Editor aktivieren"
::msgcat::mcset pb_msg_german "MC(ude,editor,enable,as_saved,Label)"   "Wie gespeichert"
::msgcat::mcset pb_msg_german "MC(ude,editor,TITLE)"                   "Anwenderdefiniertes Ereignis"

::msgcat::mcset pb_msg_german "MC(ude,editor,no_ude)"                  "Kein relevantes UDE."

::msgcat::mcset pb_msg_german "MC(ude,editor,int,Label)"               "Ganzzahl"
::msgcat::mcset pb_msg_german "MC(ude,editor,int,Context)"             "Fügen Sie einen neuen Ganzzahlparameter durch Ziehen in die rechte Liste hinzu. "

::msgcat::mcset pb_msg_german "MC(ude,editor,real,Label)"              "Reell"
::msgcat::mcset pb_msg_german "MC(ude,editor,real,Context)"            "Fügen Sie einen neuen reellen Parameter durch Ziehen in die rechte Liste hinzu."

::msgcat::mcset pb_msg_german "MC(ude,editor,txt,Label)"               "Text"
::msgcat::mcset pb_msg_german "MC(ude,editor,txt,Context)"             "Fügen Sie einen neuen Zeichenfolge-Parameter durch Ziehen in die rechte Liste hinzu."

::msgcat::mcset pb_msg_german "MC(ude,editor,bln,Label)"               "Boolesch"
::msgcat::mcset pb_msg_german "MC(ude,editor,bln,Context)"             "Fügen Sie einen neuen booleschen Parameter durch Ziehen in die rechte Liste hinzu."

::msgcat::mcset pb_msg_german "MC(ude,editor,opt,Label)"               "Option"
::msgcat::mcset pb_msg_german "MC(ude,editor,opt,Context)"             "Fügen Sie eine neuen Optionsparameter durch Ziehen in die rechte Liste hinzu."

::msgcat::mcset pb_msg_german "MC(ude,editor,pnt,Label)"               "Punkt"
::msgcat::mcset pb_msg_german "MC(ude,editor,pnt,Context)"             "Fügen Sie einen neuen Punktparameter durch Ziehen in die rechte Liste hinzu."

::msgcat::mcset pb_msg_german "MC(ude,editor,trash,Label)"             "Editor -- Abfalleimer"
::msgcat::mcset pb_msg_german "MC(ude,editor,trash,Context)"           "Ungewünschte Parameter können aus der rechten Liste entfernt werden, indem sie in diesen Abfalleimer verschoben werden."

::msgcat::mcset pb_msg_german "MC(ude,editor,event,Label)"             "Ereignis"
::msgcat::mcset pb_msg_german "MC(ude,editor,event,Context)"           "Ereignisparameter können hier mit MT1 bearbeitet werden."

::msgcat::mcset pb_msg_german "MC(ude,editor,param,Label)"             "Ereignis -- Parameter"
::msgcat::mcset pb_msg_german "MC(ude,editor,param,Context)"           "Jeder Parameter kann durch Rechtsklicken, oder durch Änderung der Parameterreihenfolge mit der Option Ziehen&Ablegen bearbeitet werden .\n \nDer hellblaue Parameter ist systemdefiniert und kann nicht gelöscht werden. \nDer braune Parameter ist nicht systemdefiniert und kann geändert bzw. gelöscht werden."

::msgcat::mcset pb_msg_german "MC(ude,editor,param,edit,Label)"        "Parameter -- Option"
::msgcat::mcset pb_msg_german "MC(ude,editor,param,edit,Context)"      "Klicken Sie auf Maustaste 1, um die Standardoption auszuwählen.\n Auf die Maustaste 1 doppelklicken, um Option zu bearbeiten."
::msgcat::mcset pb_msg_german "MC(ude,editor,param,editor,Label)"      "Parametertyp: "

::msgcat::mcset pb_msg_german "MC(ude,editor,pnt,sel,Label)"           "Auswählen"
::msgcat::mcset pb_msg_german "MC(ude,editor,pnt,dsp,Label)"           "Anzeige"

::msgcat::mcset pb_msg_german "MC(ude,editor,dlg,ok,Label)"            "OK"
::msgcat::mcset pb_msg_german "MC(ude,editor,dlg,bck,Label)"           "Zurück"
::msgcat::mcset pb_msg_german "MC(ude,editor,dlg,cnl,Label)"           "Abbrechen"

::msgcat::mcset pb_msg_german "MC(ude,editor,paramdlg,PL,Label)"       "Parameterbezeichnung"
::msgcat::mcset pb_msg_german "MC(ude,editor,paramdlg,VN,Label)"       "Variblenname"
::msgcat::mcset pb_msg_german "MC(ude,editor,paramdlg,DF,Label)"       "Standardwert"
::msgcat::mcset pb_msg_german "MC(ude,editor,paramdlg,PL,Context)"     "Parameterbezeichnung festlegen"
::msgcat::mcset pb_msg_german "MC(ude,editor,paramdlg,VN,Context)"     "Variablenname festlegen"
::msgcat::mcset pb_msg_german "MC(ude,editor,paramdlg,DF,Context)"     "Standardwert festlegen"
::msgcat::mcset pb_msg_german "MC(ude,editor,paramdlg,TG)"             "Umschalten"
::msgcat::mcset pb_msg_german "MC(ude,editor,paramdlg,TG,B,Label)"     "Umschalten"
::msgcat::mcset pb_msg_german "MC(ude,editor,paramdlg,TG,B,Context)"   "Umschaltwert auswählen"
::msgcat::mcset pb_msg_german "MC(ude,editor,paramdlg,ON,Label)"       "Aktiviert"
::msgcat::mcset pb_msg_german "MC(ude,editor,paramdlg,OFF,Label)"      "Aus"
::msgcat::mcset pb_msg_german "MC(ude,editor,paramdlg,ON,Context)"     "Standardwert als \"AKTIVIERT\" auswählen"
::msgcat::mcset pb_msg_german "MC(ude,editor,paramdlg,OFF,Context)"    "Standardwert als \"DEAKTIVIERT\" auswählen"
::msgcat::mcset pb_msg_german "MC(ude,editor,paramdlg,OL)"             "Optionsliste"
::msgcat::mcset pb_msg_german "MC(ude,editor,paramdlg,ADD,Label)"      "Hinzufügen"
::msgcat::mcset pb_msg_german "MC(ude,editor,paramdlg,CUT,Label)"      "Schnitt"
::msgcat::mcset pb_msg_german "MC(ude,editor,paramdlg,PASTE,Label)"    "Einfügen"
::msgcat::mcset pb_msg_german "MC(ude,editor,paramdlg,ADD,Context)"    "Ein Element hinzufügen"
::msgcat::mcset pb_msg_german "MC(ude,editor,paramdlg,CUT,Context)"    "Ein Element bearbeiten"
::msgcat::mcset pb_msg_german "MC(ude,editor,paramdlg,PASTE,Context)"  "Ein Element einfügen"
::msgcat::mcset pb_msg_german "MC(ude,editor,paramdlg,ENTRY,Label)"    "Option"
::msgcat::mcset pb_msg_german "MC(ude,editor,paramdlg,ENTRY,Context)"  "Ein Element eingeben"
::msgcat::mcset pb_msg_german "MC(ude,editor,eventdlg,EN,Label)"       "Ereignisname"
::msgcat::mcset pb_msg_german "MC(ude,editor,eventdlg,EN,Context)"     "Ereignisname festlegen"
::msgcat::mcset pb_msg_german "MC(ude,editor,eventdlg,PEN,Label)"      "PP-Name"
::msgcat::mcset pb_msg_german "MC(ude,editor,eventdlg,PEN,Context)"    "PP-Name festlegen"
::msgcat::mcset pb_msg_german "MC(ude,editor,eventdlg,PEN,C,Label)"    "PP-Name"
::msgcat::mcset pb_msg_german "MC(ude,editor,eventdlg,PEN,C,Context)"  "Dieser Schalter gibt an, ob der PP-Name festgelegt werden kann"
::msgcat::mcset pb_msg_german "MC(ude,editor,eventdlg,EL,Label)"       "Ereignisbezeichnung"
::msgcat::mcset pb_msg_german "MC(ude,editor,eventdlg,EL,Context)"     "Ereignisbezeichnung festlegen"
::msgcat::mcset pb_msg_german "MC(ude,editor,eventdlg,EL,C,Label)"     "Ereignisbezeichnung"
::msgcat::mcset pb_msg_german "MC(ude,editor,eventdlg,EL,C,Context)"   "Dieser Schalter gibt an, ob die Ereignisbezeichnung festgelegt werden kann"

::msgcat::mcset pb_msg_german "MC(ude,editor,eventdlg,EC,Label)"           "Kategorie"
::msgcat::mcset pb_msg_german "MC(ude,editor,eventdlg,EC,Context)"         "Dieser Schalter gibt an, ob die Kategorie festgelegt werden kann"
::msgcat::mcset pb_msg_german "MC(ude,editor,eventdlg,EC_MILL,Label)"      "Fräsen"
::msgcat::mcset pb_msg_german "MC(ude,editor,eventdlg,EC_DRILL,Label)"     "Bohrer"
::msgcat::mcset pb_msg_german "MC(ude,editor,eventdlg,EC_LATHE,Label)"     "Drehen"
::msgcat::mcset pb_msg_german "MC(ude,editor,eventdlg,EC_WEDM,Label)"      "Drahterodieren"
::msgcat::mcset pb_msg_german "MC(ude,editor,eventdlg,EC_MILL,Context)"    "Fräs-Kategorie festlegen"
::msgcat::mcset pb_msg_german "MC(ude,editor,eventdlg,EC_DRILL,Context)"   "Bohrer-Kategorie festlegen"
::msgcat::mcset pb_msg_german "MC(ude,editor,eventdlg,EC_LATHE,Context)"   "Drehmaschinen-Kategorie festlegen"
::msgcat::mcset pb_msg_german "MC(ude,editor,eventdlg,EC_WEDM,Context)"    "Drahterodieren-Kategorie festlegen"

::msgcat::mcset pb_msg_german "MC(ude,editor,EDIT)"                    "Ereignis bearbeiten"
::msgcat::mcset pb_msg_german "MC(ude,editor,CREATE)"                  "Maschinen-Steuerungsereignis erzeugen"
::msgcat::mcset pb_msg_german "MC(ude,editor,popup,HELP)"              "Hilfe"
::msgcat::mcset pb_msg_german "MC(ude,editor,popup,EDIT)"              "Anwenderdefinierte Parameter bearbeiten..."
::msgcat::mcset pb_msg_german "MC(ude,editor,param,EDIT)"              "Bearbeiten..."
::msgcat::mcset pb_msg_german "MC(ude,editor,param,VIEW)"              "Ansicht..."
::msgcat::mcset pb_msg_german "MC(ude,editor,popup,DELETE)"            "Löschen"
::msgcat::mcset pb_msg_german "MC(ude,editor,popup,CREATE)"            "Erzeugen Sie ein neues Maschinen-Steuerungsereignis..."
::msgcat::mcset pb_msg_german "MC(ude,editor,popup,IMPORT)"            "Maschinen-Steuerungsereignisse importieren..."
::msgcat::mcset pb_msg_german "MC(ude,editor,popup,MSG_BLANK)"         "Der Ereignisname darf nicht leer sein."
::msgcat::mcset pb_msg_german "MC(ude,editor,popup,MSG_SAMENAME)"      "Der Ereignisname ist bereits vorhanden."
::msgcat::mcset pb_msg_german "MC(ude,editor,popup,MSG_SameHandler)"   "Ereignis-Handler ist bereits vorhanden. \nBitte ändern Sie den Ereignis - bzw. PP-Namen nach der Prüfung."
::msgcat::mcset pb_msg_german "MC(ude,validate)"                       "Es existiert kein Parameter in diesem Ereignis."
::msgcat::mcset pb_msg_german "MC(ude,prev,tab,Label)"                 "Anwenderdefinierte Ereignisse"
::msgcat::mcset pb_msg_german "MC(ude,prev,ude,Label)"                 "Maschinen-Steuerungsereignisse"
::msgcat::mcset pb_msg_german "MC(ude,prev,udc,Label)"                 "Anwenderdefinierte Zyklen"
::msgcat::mcset pb_msg_german "MC(ude,prev,mc,Label)"                  "Systemmaschinen-Steuerungsereignisse"
::msgcat::mcset pb_msg_german "MC(ude,prev,nmc,Label)"                 "Nicht-Systemmaschinen-Steuerungsereignisse"
::msgcat::mcset pb_msg_german "MC(udc,prev,sys,Label)"                 "Systemzyklen"
::msgcat::mcset pb_msg_german "MC(udc,prev,nsys,Label)"                "Nicht-Systemzyklen"
::msgcat::mcset pb_msg_german "MC(ude,prev,Status)"                    "Element für Definition auswählen"
::msgcat::mcset pb_msg_german "MC(ude,editor,opt,MSG_BLANK)"           "Die Optionszeichenfolge darf nicht leer sein."
::msgcat::mcset pb_msg_german "MC(ude,editor,opt,MSG_SAME)"            "Die Optionszeichenfolge ist bereits vorhanden."
::msgcat::mcset pb_msg_german "MC(ude,editor,opt,MSG_PST_SAME)"        "Die eingefügte Optionen ist bereits vorhanden."
::msgcat::mcset pb_msg_german "MC(ude,editor,opt,MSG_IDENTICAL)"       "Einige Optionen sind identisch."
::msgcat::mcset pb_msg_german "MC(ude,editor,opt,NO_OPT)"              "Es ist keine Option in der Liste vorhanden."
::msgcat::mcset pb_msg_german "MC(ude,editor,param,MSG_NO_VNAME)"      "Der Variablenname darf nicht leer sein."
::msgcat::mcset pb_msg_german "MC(ude,editor,param,MSG_EXIST_VNAME)"   "Der Variablenname ist bereits vorhanden."
::msgcat::mcset pb_msg_german "MC(ude,editor,spindle_css,INFO)"        "Dieses Ereignis verwendet das UDE gemeinsam mit \"RPM-Spindel\""
::msgcat::mcset pb_msg_german "MC(ude,import,ihr,Label)"               "UDE von einem Posten übernehmen"

::msgcat::mcset pb_msg_german "MC(ude,import,ihr,Context)"             "Diese Option ermöglicht diesem Posten die Übernahme der UDE-Definition und deren Handler von einem Posten."

::msgcat::mcset pb_msg_german "MC(ude,import,sel,Label)"               "Posten auswählen"

::msgcat::mcset pb_msg_german "MC(ude,import,sel,Context)"             "Wählen Sie die PUI-Datei des gewünschten Postens. Es ist empfehlenswert, dass alle mit dem übernommenen Posten verknüpften Dateien (PUI, Def, Tcl & CDL) im gleichen Verzeichnis (Ordner) für die Laufzeitverwendung platziert werden."

::msgcat::mcset pb_msg_german "MC(ude,import,name_cdl,Label)"          "CDL-Dateiname"

::msgcat::mcset pb_msg_german "MC(ude,import,name_cdl,Context)"        "Mit dem ausgewählten Posten verknüpfter Pfad- und Dateiname der CDL-Datei, die in der Definitionsdatei dieses Postens referenziert (EINSCHLIESSEN) werden. Der Pfadname muss mit einer UG-Umgebungsvariable (\\\$UGII) oder keiner beginnen. Wenn kein Pfad festgelegt wurde, wird das Verzeichnis \"UGII_CAM_FILE_SEARCH_PATH\" verwendet, um die Datei während der UG/NX-Laufzeit zu lokalisieren."

::msgcat::mcset pb_msg_german "MC(ude,import,name_def,Label)"          "Definitions-Dateiname"
::msgcat::mcset pb_msg_german "MC(ude,import,name_def,Context)"        "Pfad- und Dateiname der Definitionsdatei des ausgewählten Postens, die in der Definitionsdatei dieses Postens referenziert (EINSCHLIESSEN) werden.  Der Pfadname muss mit einer Umgebungsvariable (\\\$UGII) oder keiner beginnen. Wenn kein Pfad festgelegt wurde, wird das Verzeichnis \" UGII_CAM_FILE_SEARCH_PATH\" verwendet, um die Datei während der UG/NX-Laufzeit zu lokalisieren."

::msgcat::mcset pb_msg_german "MC(ude,import,include_cdl,Label)"       "CDL"
::msgcat::mcset pb_msg_german "MC(ude,import,ihr_pst,Label)"           "Posten"
::msgcat::mcset pb_msg_german "MC(ude,import,ihr_folder,Label)"        "Ordner"
::msgcat::mcset pb_msg_german "MC(ude,import,own_folder,Label)"        "Ordner"
::msgcat::mcset pb_msg_german "MC(ude,import,own,Label)"               "Eigene CDL-Datei einschließen"

::msgcat::mcset pb_msg_german "MC(ude,import,own,Context)"             "Diese Option ermöglicht, dass dieser Posten die Referenz zu seiner CDL-Datei in die Definitionsdatei einschließt."

::msgcat::mcset pb_msg_german "MC(ude,import,own_ent,Label)"           "Eigene CDL-Datei"

::msgcat::mcset pb_msg_german "MC(ude,import,own_ent,Context)"         "Pfad- und Dateiname der CDL-Datei, die mit diesem Posten, der in der Definitionsdatei dieses Postens referenziert (EINSCHLIESSEN) wird, verknüpft sind.  Der eigentliche Dateiname wird beim Speichern dieses Postens bestimmt.  Der Pfadname muss mit einer UG-Umgebungsvariable (\\\$UGII) oder keiner beginnen.  Wenn kein Pfad festgelegt wurde, wird das Verzeichnis \"UGII_CAM_FILE_SEARCH_PATH\" verwendet, um die Datei während der UG/NX-Laufzeit zu lokalisieren."

::msgcat::mcset pb_msg_german "MC(ude,import,sel,pui,status)"          "PUI-Datei auswählen"
::msgcat::mcset pb_msg_german "MC(ude,import,sel,cdl,status)"          "CDL-Datei auswählen"

##---------
## UDC
##
::msgcat::mcset pb_msg_german "MC(udc,editor,TITLE)"                   "Anwenderdefinierter Zyklus"
::msgcat::mcset pb_msg_german "MC(udc,editor,CREATE)"                  "Anwenderdefinierten Zyklus erzeugen"
::msgcat::mcset pb_msg_german "MC(udc,editor,TYPE)"                    "Zyklustyp"
::msgcat::mcset pb_msg_german "MC(udc,editor,type,UDC)"                "Anwenderdefiniert"
::msgcat::mcset pb_msg_german "MC(udc,editor,type,SYSUDC)"             "Systemdefiniert"
::msgcat::mcset pb_msg_german "MC(udc,editor,CYCLBL,Label)"            "Zyklusbezeichnung"
::msgcat::mcset pb_msg_german "MC(udc,editor,CYCNAME,Label)"           "Zyklusname"
::msgcat::mcset pb_msg_german "MC(udc,editor,CYCLBL,Context)"          "Zyklusbezeichnung festlegen"
::msgcat::mcset pb_msg_german "MC(udc,editor,CYCNAME,Context)"         "Zyklusname festlegen"
::msgcat::mcset pb_msg_german "MC(udc,editor,CYCLBL,C,Label)"          "Zyklusbezeichnung"
::msgcat::mcset pb_msg_german "MC(udc,editor,CYCLBL,C,Context)"        "Mit diesem Schalter kann die Zyklusbezeichnung festgelegt werden"
::msgcat::mcset pb_msg_german "MC(udc,editor,popup,EDIT)"              "Anwenderdefinierte Parameter bearbeiten..."
::msgcat::mcset pb_msg_german "MC(udc,editor,popup,MSG_BLANK)"         "Der Zyklusname darf nicht leer sein."
::msgcat::mcset pb_msg_german "MC(udc,editor,popup,MSG_SAMENAME)"      "Der Zyklusname ist bereits vorhanden."
::msgcat::mcset pb_msg_german "MC(udc,editor,popup,MSG_SameHandler)"   "Ereignis-Handler ist bereits vorhanden.\n Bitte den Zyklus-Ereignisnamen ändern."
::msgcat::mcset pb_msg_german "MC(udc,editor,popup,MSG_ISSYSCYC)"      "Der Zyklusname gehört zu einem Systemzyklustyp."
::msgcat::mcset pb_msg_german "MC(udc,editor,popup,MSG_SYSCYC_EXIST)"  "Dieser Systemzyklus ist bereits vorhanden."
::msgcat::mcset pb_msg_german "MC(udc,editor,EDIT)"                    "Zyklusereignis bearbeiten"
::msgcat::mcset pb_msg_german "MC(udc,editor,popup,CREATE)"            "Neuen anwenderdefinierten Zyklus erstellen..."
::msgcat::mcset pb_msg_german "MC(udc,editor,popup,IMPORT)"            "Anwenderdefinierte Zyklen importieren..."
::msgcat::mcset pb_msg_german "MC(udc,drill,csink,INFO)"               "Dieses Ereignis verwendet den Handler gemeinsam mit dem Bohrer."
::msgcat::mcset pb_msg_german "MC(udc,drill,simulate,INFO)"            "Dieses Ereignis ist eine simulierte Zyklusart."
::msgcat::mcset pb_msg_german "MC(udc,drill,dwell,INFO)"               "Dieses Ereignis verwendet den anwenderdefinierten Zyklus gemeinsam mit "


#######
# IS&V
#######
::msgcat::mcset pb_msg_german "MC(isv,tab,label)"                      "Virtuelle N/C-Steuerung"
::msgcat::mcset pb_msg_german "MC(isv,Status)"                         "Parameter für ISV festlegen"
::msgcat::mcset pb_msg_german "MC(isv,review,Status)"                  "VNC-Befehle überprüfen"

::msgcat::mcset pb_msg_german "MC(isv,setup,Label)"                    "Konfiguration"
::msgcat::mcset pb_msg_german "MC(isv,vnc_command,Label)"              "VNC-Befehle"
####################
# General Definition
####################
::msgcat::mcset pb_msg_german "MC(isv,select_Main)"                    "VNC-Masterdatei für untergeordnete VNC auswählen."
::msgcat::mcset pb_msg_german "MC(isv,setup,machine,Label)"            "Wkz-Maschine"
::msgcat::mcset pb_msg_german "MC(isv,setup,component,Label)"          "Werkzeugbestückung"
::msgcat::mcset pb_msg_german "MC(isv,setup,mac_zcs_frame,Label)"      "Nullreferenz programmieren"
::msgcat::mcset pb_msg_german "MC(isv,setup,mac_zcs,Label)"            "Komponente"
::msgcat::mcset pb_msg_german "MC(isv,setup,mac_zcs,Context)"          "Legen Sie eine Komponente als ZCS-Referenzbasis fest. Dies sollte  eine nicht drehbare Komponente sein, mit der das Teil direkt oder indirekt im Kinematik-Baum verbunden ist."
::msgcat::mcset pb_msg_german "MC(isv,setup,spin_com,Label)"           "Komponente"
::msgcat::mcset pb_msg_german "MC(isv,setup,spin_com,Context)"         "Legen Sie eine Komponente fest, mit der Werkzeuge befestigt sind. Dies sollte die Spindel-Komponente für einen Fräsposten und die Revolver-Komponente für ein Drehposten sein."

::msgcat::mcset pb_msg_german "MC(isv,setup,spin_jct,Label)"           "Verbindung"
::msgcat::mcset pb_msg_german "MC(isv,setup,spin_jct,Context)"         "Definieren Sie eine Verbindung für die Befestigungswerkzeuge. Für einen Fräsposten ist dies die Verbindung in der Mitte der Spindelfläche. Für einen Drehposten ist es die drehbare Revolververbindung. Und es ist die Wkz-Befestigungshalterung wenn der Revolver befestigt ist."

::msgcat::mcset pb_msg_german "MC(isv,setup,axis_name,Label)"          "An Wkz-Maschine festgelegte Achse"
::msgcat::mcset pb_msg_german "MC(isv,setup,axis_name,Context)"        "Legen Sie die Achsennamen fest, die mit der Kinematikkonfiguration der Wkz-Maschine übereinstimmt"




::msgcat::mcset pb_msg_german "MC(isv,setup,axis_frm,Label)"           "NC-Achsennamen"
::msgcat::mcset pb_msg_german "MC(isv,setup,rev_fourth,Label)"         "Rotation umkehren"
::msgcat::mcset pb_msg_german "MC(isv,setup,rev_fourth,Context)"       "Legen Sie die Achsenrotationsrichtung fest. Diese kann entweder umgekehrt oder normal sein.  Dies gilt nur für einen Drehtisch."
::msgcat::mcset pb_msg_german "MC(isv,setup,rev_fifth,Label)"          "Rotation umkehren"

::msgcat::mcset pb_msg_german "MC(isv,setup,fourth_limit,Label)"       "Rotationsgrenze"
::msgcat::mcset pb_msg_german "MC(isv,setup,fourth_limit,Context)"     "Legen Sie fest, ob diese Rotationsachse Grenzen enthält"
::msgcat::mcset pb_msg_german "MC(isv,setup,fifth_limit,Label)"        "Rotationsgrenze"
::msgcat::mcset pb_msg_german "MC(isv,setup,limiton,Label)"            "Ja"
::msgcat::mcset pb_msg_german "MC(isv,setup,limitoff,Label)"           "Nein"
::msgcat::mcset pb_msg_german "MC(isv,setup,fourth_table,Label)"       "4-Achsen"
::msgcat::mcset pb_msg_german "MC(isv,setup,fifth_table,Label)"        "5-Achsen"
::msgcat::mcset pb_msg_german "MC(isv,setup,header,Label)"             " Tabelle "
::msgcat::mcset pb_msg_german "MC(isv,setup,intialization,Label)"      "Steuerung"
::msgcat::mcset pb_msg_german "MC(isv,setup,general_def,Label)"        "Ausgangseinstellung"
::msgcat::mcset pb_msg_german "MC(isv,setup,advanced_def,Label)"       "Weitere Optionen"
::msgcat::mcset pb_msg_german "MC(isv,setup,InputOutput,Label)"        "Spezielle NC-Codes"

::msgcat::mcset pb_msg_german "MC(isv,setup,program,Label)"            "Standard-Programmdefinition"
::msgcat::mcset pb_msg_german "MC(isv,setup,output,Label)"             "Programmdefinition exportieren"
::msgcat::mcset pb_msg_german "MC(isv,setup,output,Context)"           "Programmdefinition in eine Datei speichern"
::msgcat::mcset pb_msg_german "MC(isv,setup,input,Label)"              "Programmdefinition importieren"
::msgcat::mcset pb_msg_german "MC(isv,setup,input,Context)"            "Programmdefinition aus einer Datei abrufen"
::msgcat::mcset pb_msg_german "MC(isv,setup,file_err,Msg)"             "Die ausgewählte Datei stimmt nicht mit dem Standarddateityp der Programmdefinitionsdatei überein. Fortfahren?"
::msgcat::mcset pb_msg_german "MC(isv,setup,wcs,Label)"                "Nullpunktverschiebung"
::msgcat::mcset pb_msg_german "MC(isv,setup,tool,Label)"               "Wkz-Daten"
::msgcat::mcset pb_msg_german "MC(isv,setup,g_code,Label)"             "Spezieller G-Code"
::msgcat::mcset pb_msg_german "MC(isv,setup,special_vnc,Label)"        "Spezieller NC-Code"

::msgcat::mcset pb_msg_german "MC(isv,setup,initial,frame,Label)"      ""
::msgcat::mcset pb_msg_german "MC(isv,setup,initial_motion,Label)"     "Kinematik"
::msgcat::mcset pb_msg_german "MC(isv,setup,initial_motion,Context)"   "Ausgangsbewegung der Wkz-Maschine festlegen"

::msgcat::mcset pb_msg_german "MC(isv,setup,spindle,frame,Label)"      "Spindel"
::msgcat::mcset pb_msg_german "MC(isv,setup,spindle_mode,Label)"       "Modus"
::msgcat::mcset pb_msg_german "MC(isv,setup,spindle_direction,Label)"  "Richtung"
::msgcat::mcset pb_msg_german "MC(isv,setup,spindle,frame,Context)"    "Einheit der Ausgangsspindeldrehzahl und Rotationsrichtung festlegen"

::msgcat::mcset pb_msg_german "MC(isv,setup,feedrate_mode,Label)"      "Vorschubmodus"
::msgcat::mcset pb_msg_german "MC(isv,setup,feedrate_mode,Context)"    "Einheit des Ausgangsvorschubs festlegen"

::msgcat::mcset pb_msg_german "MC(isv,setup,boolean,frame,Label)"      "Boolesches Element definieren"
::msgcat::mcset pb_msg_german "MC(isv,setup,power_on_wcs,Label)"       "WCS aktivieren  "
::msgcat::mcset pb_msg_german "MC(isv,setup,power_on_wcs,Context)"     "0 gibt an, dass die Standardkoordinate der Null-Bearbeitung verwendet wird\n 1 gibt an, dass die erste anwenderdefinierte Nullpunktverschiebung  (Arbeitskoordinate) verwendet wird"

::msgcat::mcset pb_msg_german "MC(isv,setup,use_s_leader,Label)"       "S verwendet"
::msgcat::mcset pb_msg_german "MC(isv,setup,use_f_leader,Label)"       "F verwendet"


::msgcat::mcset pb_msg_german "MC(isv,setup,dog_leg,Label)"            "Knickpunkt-Eilgang"
::msgcat::mcset pb_msg_german "MC(isv,setup,dog_leg,Context)"          "Mit \"Aktiviert\" werden die Eilgangbewegungen winkelförmig bewegt; Mit \"Deaktiviert\" werden die Eilgangbewegungen entsprechend des NC-Codes (Punkt zu Punkt) bewegt."

::msgcat::mcset pb_msg_german "MC(isv,setup,dog_leg,yes)"              "Ja"
::msgcat::mcset pb_msg_german "MC(isv,setup,dog_leg,no)"               "Nein"

::msgcat::mcset pb_msg_german "MC(isv,setup,on_off_frame,Label)"       "AKTIVIEREN/DEAKTIVIEREN definieren"
::msgcat::mcset pb_msg_german "MC(isv,setup,stroke_limit,Label)"       "Anschlaggrenze"
::msgcat::mcset pb_msg_german "MC(isv,setup,cutcom,Label)"             "Wkz-Kompensation"
::msgcat::mcset pb_msg_german "MC(isv,setup,tl_adjust,Label)"          "Wkz-Längenanpassung"
::msgcat::mcset pb_msg_german "MC(isv,setup,scale,Label)"              "Maßstab"
::msgcat::mcset pb_msg_german "MC(isv,setup,macro_modal,Label)"        "Makro-modal"
::msgcat::mcset pb_msg_german "MC(isv,setup,wcs_rotate,Label)"         "WCS-Rotation"
::msgcat::mcset pb_msg_german "MC(isv,setup,cycle,Label)"              "Zyklus"

::msgcat::mcset pb_msg_german "MC(isv,setup,initial_mode,frame,Label)"     "Eingabemodus"
::msgcat::mcset pb_msg_german "MC(isv,setup,initial_mode,frame,Context)"   "Ausgangseingabe als \"absolut\" oder \"inkremental\" festlegen"

###################
# Input/Out Related
###################
::msgcat::mcset pb_msg_german "MC(isv,sign_define,frame,Label)"        ""
::msgcat::mcset pb_msg_german "MC(isv,sign_define,rewindstop,Label)"   "Rücklaufhaltecode"
::msgcat::mcset pb_msg_german "MC(isv,sign_define,rewindstop,Context)" "Rücklaufhaltecode festlegen"

::msgcat::mcset pb_msg_german "MC(isv,control_var,frame,Label)"        "Variablen steuern"

::msgcat::mcset pb_msg_german "MC(isv,sign_define,convarleader,Label)"     "Bezugspfeil"
::msgcat::mcset pb_msg_german "MC(isv,sign_define,convarleader,Context)"   "Steuerungsvariable festlegen"
::msgcat::mcset pb_msg_german "MC(isv,sign_define,conequ,Label)"           "Gleichheitszeichen"
::msgcat::mcset pb_msg_german "MC(isv,sign_define,conequ,Context)"         "Gleichheitszeichen festlegen"
::msgcat::mcset pb_msg_german "MC(isv,sign_define,percent,Label)"          "Prozentzeichen %"
::msgcat::mcset pb_msg_german "MC(isv,sign_define,leaderjing,Label)"       "Spitz #"
::msgcat::mcset pb_msg_german "MC(isv,sign_define,text_string,Label)"      "Textzeichenfolge"

::msgcat::mcset pb_msg_german "MC(isv,inputmode,frame,Label)"          ""
::msgcat::mcset pb_msg_german "MC(isv,input_mode,Label)"               "Ausgangsmodus"
::msgcat::mcset pb_msg_german "MC(isv,absolute_mode,Label)"            "Absolut"
::msgcat::mcset pb_msg_german "MC(isv,incremental_style,frame,Label)"  "Inkrementaler Modus"

::msgcat::mcset pb_msg_german "MC(isv,incremental_mode,Label)"         "Inkremental"
::msgcat::mcset pb_msg_german "MC(isv,incremental_gcode,Label)"        "G-Code"
::msgcat::mcset pb_msg_german "MC(isv,incremental_gcode,Context)"      "Verwendung von G90 G91, um zwischen absoluten und inkrementalen Modus zu unterscheiden"
::msgcat::mcset pb_msg_german "MC(isv,incremental_uvw,Label)"          "Sonderbezugspfeil"
::msgcat::mcset pb_msg_german "MC(isv,incremental_uvw,Context)"        "Ein Sonderbezugspfeil kann verwendet werden, um zwischen dem absoluten und inkrementalen Modus zu unterscheiden. Beispielsweise: Bezugspfeil "
::msgcat::mcset pb_msg_german "MC(isv,incr_x,Label)"                   "X "
::msgcat::mcset pb_msg_german "MC(isv,incr_y,Label)"                   "Y "
::msgcat::mcset pb_msg_german "MC(isv,incr_z,Label)"                   "Z "
::msgcat::mcset pb_msg_german "MC(isv,incr_a,Label)"                   "Vierte Achse "
::msgcat::mcset pb_msg_german "MC(isv,incr_b,Label)"                   "5. Achse "

::msgcat::mcset pb_msg_german "MC(isv,incr_x,Context)"                 "Speziellen X-Achsenbezugspfeil festlegen, der im inkrementalen Stil verwendet wird"
::msgcat::mcset pb_msg_german "MC(isv,incr_y,Context)"                 "Speziellen Y-Achsenbezugspfeil festlegen, der im inkrementalen Stil verwendet wird"
::msgcat::mcset pb_msg_german "MC(isv,incr_z,Context)"                 "Speziellen Z-Achsenbezugspfeil festlegen, der im inkrementalen Stil verwendet wird"
::msgcat::mcset pb_msg_german "MC(isv,incr_a,Context)"                 "Speziellen 4-Achsenbezugspfeil festlegen, der im inkrementalen Stil verwendet wird"
::msgcat::mcset pb_msg_german "MC(isv,incr_b,Context)"                 "Speziellen 5-Achsenbezugspfeil festlegen, der im inkrementalen Stil verwendet wird"
::msgcat::mcset pb_msg_german "MC(isv,vnc_mes,frame,Label)"            "VNC-Meldung ausgeben"

::msgcat::mcset pb_msg_german "MC(isv,vnc_message,Label)"              "VNC-Meldung auflisten"
::msgcat::mcset pb_msg_german "MC(isv,vnc_message,Context)"            "Sobald die Option geprüft ist, werden alle VNC-Debug-Meldungen bei der Simulation im Operationsmeldungsfenster angezeigt."

::msgcat::mcset pb_msg_german "MC(isv,vnc_mes,prefix,Label)"           "Präfix der Meldung"
::msgcat::mcset pb_msg_german "MC(isv,spec_desc,Label)"                "Beschreibung"
::msgcat::mcset pb_msg_german "MC(isv,spec_codelist,Label)"            "Code-Liste"
::msgcat::mcset pb_msg_german "MC(isv,spec_nccode,Label)"              "NC-Code / Zeichenfolge"

################
# WCS Definition
################
::msgcat::mcset pb_msg_german "MC(isv,machine_zero,offset,Label)"      "Nullbearbeitungs-Abstand von\nWkz-Maschine-Nullbefestigung"
::msgcat::mcset pb_msg_german "MC(isv,wcs_offset,frame,Label)"         "Nullpunktverschiebung"
::msgcat::mcset pb_msg_german "MC(isv,wcs_leader,Label)"               " Code "
::msgcat::mcset pb_msg_german "MC(isv,wcs_number,Label)"               "    "
::msgcat::mcset pb_msg_german "MC(isv,wcs_offset,origin_x,Label)"      " X-Offset  "
::msgcat::mcset pb_msg_german "MC(isv,wcs_offset,origin_y,Label)"      " Y-Offset  "
::msgcat::mcset pb_msg_german "MC(isv,wcs_offset,origin_z,Label)"      " Z-Offset  "
::msgcat::mcset pb_msg_german "MC(isv,wcs_offset,a_offset,Label)"      " A-Offset  "
::msgcat::mcset pb_msg_german "MC(isv,wcs_offset,b_offset,Label)"      " B-Offset  "
::msgcat::mcset pb_msg_german "MC(isv,wcs_offset,c_offset,Label)"      " C-Offset  "
::msgcat::mcset pb_msg_german "MC(isv,wcs_offset,wcs_num,Label)"       "Koordinatensystem"
::msgcat::mcset pb_msg_german "MC(isv,wcs_offset,wcs_num,Context)"     "Anzahl der Nullpunktverschiebungen festlegen, die hinzugefügt werden muss"
::msgcat::mcset pb_msg_german "MC(isv,wcs_offset,wcs_add,Label)"       "Hinzufügen"
::msgcat::mcset pb_msg_german "MC(isv,wcs_offset,wcs_add,Context)"     "Neues Nullpunktverschiebungs-KSYS hinzufügen; Position festlegen"
::msgcat::mcset pb_msg_german "MC(isv,wcs_offset,wcs_err,Msg)"         "Diese KSYS-Nummer ist bereits vorhanden."
::msgcat::mcset pb_msg_german "MC(isv,tool_info,frame,Label)"          "Wkz-Informationen"
::msgcat::mcset pb_msg_german "MC(isv,tool_info,tool_entry,Label)"     "Neuen Wkz-Namen eingeben"
::msgcat::mcset pb_msg_german "MC(isv,tool_info,tool_name,Label)"      "       Name       "

::msgcat::mcset pb_msg_german "MC(isv,tool_info,tool_num,Label)"       " Werkzeug "
::msgcat::mcset pb_msg_german "MC(isv,tool_info,add_tool,Label)"       "Hinzufügen"
::msgcat::mcset pb_msg_german "MC(isv,tool_info,tool_diameter,Label)"  " Durchmesser "
::msgcat::mcset pb_msg_german "MC(isv,tool_info,offset_usder,Label)"   "   Spitzen-Offsets   "
::msgcat::mcset pb_msg_german "MC(isv,tool_info,carrier_id,Label)"     " Träger-ID "
::msgcat::mcset pb_msg_german "MC(isv,tool_info,pocket_id,Label)"      " Taschen-ID "
::msgcat::mcset pb_msg_german "MC(isv,tool_info,cutcom_reg,Label)"     "     CUTCOM     "
::msgcat::mcset pb_msg_german "MC(isv,tool_info,cutreg,Label)"         "Register "
::msgcat::mcset pb_msg_german "MC(isv,tool_info,cutval,Label)"         "Offset "
::msgcat::mcset pb_msg_german "MC(isv,tool_info,adjust_reg,Label)"     " Längenanpassung "
::msgcat::mcset pb_msg_german "MC(isv,tool_info,tool_type,Label)"      "   Typ   "
::msgcat::mcset pb_msg_german "MC(isv,prog,setup,Label)"               "Standard-Programmdefinition"
::msgcat::mcset pb_msg_german "MC(isv,prog,setup_right,Label)"         "Programmdefinition"
::msgcat::mcset pb_msg_german "MC(isv,output,setup_data,Label)"        "Programmdefinitionsdatei festlegen"
::msgcat::mcset pb_msg_german "MC(isv,input,setup_data,Label)"         "Programmdefinitionsdatei auswählen"

::msgcat::mcset pb_msg_german "MC(isv,tool_info,toolnum,Label)"        "Wkz-Nummer  "
::msgcat::mcset pb_msg_german "MC(isv,tool_info,toolnum,Context)"      "Wkz-Nummer festlegen, die hinzugefügt werden muss"
::msgcat::mcset pb_msg_german "MC(isv,tool_info,add_tool,Context)"     "Neues Werkzeug hinzufügen; Parameter festlegen"
::msgcat::mcset pb_msg_german "MC(isv,tool_info,add_err,Msg)"          "Die Wkz-Nummer ist bereits vorhanden."
::msgcat::mcset pb_msg_german "MC(isv,tool_info,name_err,Msg)"         "Wkz-Name darf nicht leer sein."

###########################
# Special G code Definition
###########################

::msgcat::mcset pb_msg_german "MC(isv,g_code,frame,Label)"             "G-Sondercode"
::msgcat::mcset pb_msg_german "MC(isv,g_code,frame,Context)"           "In der Simulation verwendete G-Codes festlegen"
::msgcat::mcset pb_msg_german "MC(isv,g_code,from_home,Label)"         "Von Ausgangsposition"
::msgcat::mcset pb_msg_german "MC(isv,g_code,return_home,Label)"       "Zurück zu Ausgangsposition"
::msgcat::mcset pb_msg_german "MC(isv,g_code,mach_wcs,Label)"          "Maschinenbezugsbewegung"
::msgcat::mcset pb_msg_german "MC(isv,g_code,set_local,Label)"         "Lokale Koordinate festlegen"

###########################
# Special NC Custom Command
###########################

::msgcat::mcset pb_msg_german "MC(isv,spec_command,frame,Label)"       "NC-Sonderbefehle"
::msgcat::mcset pb_msg_german "MC(isv,spec_command,frame,Context)"     "Für Sondergeräte festgelegte NC-Befehle"


::msgcat::mcset pb_msg_german "MC(isv,spec_pre,frame,Label)"           "Befehle vorbearbeiten"
::msgcat::mcset pb_msg_german "MC(isv,spec_pre,frame,Context)"         "Befehlslisten enthalten alle Token bzw. Symbole, die verarbeitet werden müssen bevor ein Block der Syntaxanalyse für Koordinaten unterliegt"

::msgcat::mcset pb_msg_german "MC(isv,spec_command,add,Label)"         "Hinzufügen"
::msgcat::mcset pb_msg_german "MC(isv,spec_command,edit,Label)"        "Bearbeiten"
::msgcat::mcset pb_msg_german "MC(isv,spec_command,delete,Label)"      "Löschen"
::msgcat::mcset pb_msg_german "MC(isv,spec_command,title,Label)"       "Sonderbefehl für andere Geräte"
::msgcat::mcset pb_msg_german "MC(isv,spec_command,add_sim,Label)"     "SIM-Befehl @Cursor hinzufügen"
::msgcat::mcset pb_msg_german "MC(isv,spec_command,init_sim,Label)"    "Bitte einen Befehl auswählen"

::msgcat::mcset pb_msg_german "MC(isv,spec_command,preleader,Label)"   "Bezugspfeil"
::msgcat::mcset pb_msg_german "MC(isv,spec_command,preleader,Context)" "Bezugspfeil für vorbearbeiteten anwenderdef. Befehl festlegen."

::msgcat::mcset pb_msg_german "MC(isv,spec_command,precode,Label)"     "Code"
::msgcat::mcset pb_msg_german "MC(isv,spec_command,precode,Context)"   "Bezugspfeil für vorbearbeiteten anwenderdef. Befehl festlegen."

::msgcat::mcset pb_msg_german "MC(isv,spec_command,leader,Label)"      "Bezugspfeil"
::msgcat::mcset pb_msg_german "MC(isv,spec_command,leader,Context)"    "Bezugspfeil für anwenderdef. Befehl festlegen."

::msgcat::mcset pb_msg_german "MC(isv,spec_command,code,Label)"        "Code"
::msgcat::mcset pb_msg_german "MC(isv,spec_command,code,Context)"      "Bezugspfeil für anwenderdef. Befehl festlegen."

::msgcat::mcset pb_msg_german "MC(isv,spec_command,add,Context)"       "Neuen anwenderdef. Befehl hinzufügen"
::msgcat::mcset pb_msg_german "MC(isv,spec_command,add_err,Msg)"       "Dieser Token wurde bereits bearbeitet."
::msgcat::mcset pb_msg_german "MC(isv,spec_command,sel_err,Msg)"       "Bitte einen Befehl auswählen"
::msgcat::mcset pb_msg_german "MC(isv,export,error,title)"             "Warnung"

::msgcat::mcset pb_msg_german "MC(isv,tool_table,title,Label)"         "Wkz-Tabelle"
::msgcat::mcset pb_msg_german "MC(isv,ex_editor,warning,Msg)"          "Dies ist ein vom System erzeugter VNC-Befehl. Änderungen werden nicht gespeichert."


# - Languages
#
::msgcat::mcset pb_msg_german "MC(language,Label)"                     "Sprache"
::msgcat::mcset pb_msg_german "MC(pb_msg_english)"                     "Englisch"
::msgcat::mcset pb_msg_german "MC(pb_msg_french)"                      "Französisch"
::msgcat::mcset pb_msg_german "MC(pb_msg_german)"                      "Deutsch"
::msgcat::mcset pb_msg_german "MC(pb_msg_italian)"                     "Italienisch"
::msgcat::mcset pb_msg_german "MC(pb_msg_japanese)"                    "Japanisch"
::msgcat::mcset pb_msg_german "MC(pb_msg_korean)"                      "Koreanisch"
::msgcat::mcset pb_msg_german "MC(pb_msg_russian)"                     "Russisch"
::msgcat::mcset pb_msg_german "MC(pb_msg_simple_chinese)"              "Vereinfachtes Chinesisch"
::msgcat::mcset pb_msg_german "MC(pb_msg_spanish)"                     "Spanisch"
::msgcat::mcset pb_msg_german "MC(pb_msg_traditional_chinese)"         "Chinesisch, traditionell"

### Exit Options Dialog
::msgcat::mcset pb_msg_german "MC(exit,options,Label)"                 "Optionen für Beenden"
::msgcat::mcset pb_msg_german "MC(exit,options,SaveAll,Label)"         "Beenden und alle speichern"
::msgcat::mcset pb_msg_german "MC(exit,options,SaveNone,Label)"        "Beenden ohne Speichern"
::msgcat::mcset pb_msg_german "MC(exit,options,SaveSelect,Label)"      "Beenden und ausgewählte speichern"

### OptionMenu Items
::msgcat::mcset pb_msg_german "MC(optionMenu,item,Other)"       "Sonstige"
::msgcat::mcset pb_msg_german "MC(optionMenu,item,None)"        "Keine"
::msgcat::mcset pb_msg_german "MC(optionMenu,item,RT_R)"        "Eilgang & R"
::msgcat::mcset pb_msg_german "MC(optionMenu,item,Rapid)"       "Eilgang"
::msgcat::mcset pb_msg_german "MC(optionMenu,item,RS)"          "Spindeleilgang"
::msgcat::mcset pb_msg_german "MC(optionMenu,item,C_off_RS)"    "Zyklus deaktivieren, dann Spindeleilgang"
::msgcat::mcset pb_msg_german "MC(optionMenu,item,IPM)"         "IPM"
::msgcat::mcset pb_msg_german "MC(optionMenu,item,FRN)"         "FRN"
::msgcat::mcset pb_msg_german "MC(optionMenu,item,IPR)"         "IPR"
::msgcat::mcset pb_msg_german "MC(optionMenu,item,Auto)"        "Autom."
::msgcat::mcset pb_msg_german "MC(optionMenu,item,DPM)"         "DPM"
::msgcat::mcset pb_msg_german "MC(optionMenu,item,Abs_Inc)"     "Absolut/Inkremental"
::msgcat::mcset pb_msg_german "MC(optionMenu,item,Abs_Only)"    "Nur absolut"
::msgcat::mcset pb_msg_german "MC(optionMenu,item,Inc_Only)"    "Nur inkremental"
::msgcat::mcset pb_msg_german "MC(optionMenu,item,SD)"          "Kürzester Abstand"
::msgcat::mcset pb_msg_german "MC(optionMenu,item,AP)"          "Immer positiv"
::msgcat::mcset pb_msg_german "MC(optionMenu,item,AN)"          "Immer negativ"
::msgcat::mcset pb_msg_german "MC(optionMenu,item,Z_Axis)"      "Z-Achse"
::msgcat::mcset pb_msg_german "MC(optionMenu,item,+X_Axis)"     "+X-Achse"
::msgcat::mcset pb_msg_german "MC(optionMenu,item,-X_Axis)"     "-X-Achse"
::msgcat::mcset pb_msg_german "MC(optionMenu,item,Y_Axis)"      "Y-Achse"
::msgcat::mcset pb_msg_german "MC(optionMenu,item,MDD)"         "Der Betrag bestimmt die Richtung"
::msgcat::mcset pb_msg_german "MC(optionMenu,item,SDD)"         "Das Zeichen bestimmt die Richtung"
