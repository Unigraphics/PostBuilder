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
#
#  <Ex.>
#       ::msgcat::mcset $gPB(LANG) "MC(main,title,Unigraphics)"  "Unigraphics"
#       -------------------------------------------------------  -------------
#                             - Variable -                         - String -
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




if { [info exists gPB(LANG_TEST)] } {
  #======================================================
  # Return 1 when this language file is ready to be used
  #======================================================
return 1
}



#=============================================================================
# pb10.03
#=============================================================================
::msgcat::mcset $gPB(LANG) "MC(msg,filename_with_spec_char)"              "Dateiname mit speziellen Zeichen wird nicht unterstützt."
::msgcat::mcset $gPB(LANG) "MC(msg,not_post_comp_file)"                   "Die Komponente des Postprozessors kann nicht für diesen Einschluss ausgewählt werden."
::msgcat::mcset $gPB(LANG) "MC(listing,output,warning,warn_file)"         "Warnungsdatei"
::msgcat::mcset $gPB(LANG) "MC(listing,output,warning,nc_output)"         "NC-Ausgabe"

#=============================================================================
# pb10.02
#=============================================================================
::msgcat::mcset $gPB(LANG) "MC(machine,resolution,check,Label)"           "Prüfen für aktuellen Postprozessor unterdrücken"
::msgcat::mcset $gPB(LANG) "MC(main,options,debug,Label)"                 "Post-Debug-Meldungen einbetten"
::msgcat::mcset $gPB(LANG) "MC(encrypt,suppress,Label)"                   "Lizenzänderung für aktuellen Postprozessor deaktivieren"
::msgcat::mcset $gPB(LANG) "MC(main,title,license_control)"               "Lizenzsteuerung"

#=============================================================================
# pb902
#=============================================================================
::msgcat::mcset $gPB(LANG) "MC(other,ude_include_def,Label)"              "Andere CDL- oder DEFDatei einschließen"
#-----------------------------------------------------------------------------
# Labels for new tapping cycles
#-----------------------------------------------------------------------------
::msgcat::mcset $gPB(LANG) "MC(event,cycle,tap_deep,name)"                "Gewindebohrer, tief"
::msgcat::mcset $gPB(LANG) "MC(event,cycle,tap_break_chip,name)"          "Gewindebohrer, Span brechen"
::msgcat::mcset $gPB(LANG) "MC(g_code,tap_float,name)"                    "Gewindebohrer, fließend"
::msgcat::mcset $gPB(LANG) "MC(g_code,tap_deep,name)"                     "Gewindebohrer, tief"
::msgcat::mcset $gPB(LANG) "MC(g_code,tap_break_chip,name)"               "Gewindebohrer, Span brechen"
#-----------------------------------------------------------------------------
# Defined strings that did not make it to the local language files.
# - These strings should be included for translation in the later release.
#-----------------------------------------------------------------------------
::msgcat::mcset $gPB(LANG) "MC(event,cycle,plane_change,axis,label)"      "Wkz-Achsenänderung zwischen Bohrungen erkennen"
::msgcat::mcset $gPB(LANG) "MC(event,feedrates,mode,rapid)"               "Schnellbemaßung"
::msgcat::mcset $gPB(LANG) "MC(event,feedrates,mode,cutting)"             "Bearbeiten"

#=============================================================================
# pb800
#=============================================================================
::msgcat::mcset $gPB(LANG) "MC(event,misc,subop_start,name)"      "Pfadanfang der Unteroperation"
::msgcat::mcset $gPB(LANG) "MC(event,misc,subop_end,name)"        "Pfadende der Unteroperation"
::msgcat::mcset $gPB(LANG) "MC(event,misc,contour_start,name)"    "Konturstart"
::msgcat::mcset $gPB(LANG) "MC(event,misc,contour_end,name)"      "Konturende"
::msgcat::mcset $gPB(LANG) "MC(prog,tree,misc,Label)"             "Verschiedenes"
::msgcat::mcset $gPB(LANG) "MC(event,cycle,lathe_rough,name)"     "Dreh-Schruppen"
::msgcat::mcset $gPB(LANG) "MC(main,file,properties,Label)"       "Postprozessor-Eigenschaften"

::msgcat::mcset $gPB(LANG) "MC(ude,editor,popup,MSG_CATEGORY)"    "Das benutzerdefinierte Element für einen Fräs- bzw. Dreh-Postprozessor kann u. U. nicht nur mit einer \"Drahterodieren\"-Kategorie festgelegt werden."

::msgcat::mcset $gPB(LANG) "MC(event,cycle,plane_change,label)"   "Arbeitsebenen-Änderung auf untere erkennen"
::msgcat::mcset $gPB(LANG) "MC(format,check_1,error,msg)"         "Das Format unterstützt den Wert der Ausdrücke nicht"

::msgcat::mcset $gPB(LANG) "MC(format,check_4,error,msg)"         "Ändern Sie das Format der zugehörigen Adresse, bevor Sie diese Seite verlassen bzw. diesen Postprozessor speichern."
::msgcat::mcset $gPB(LANG) "MC(format,check_5,error,msg)"         "Ändern Sie das Format, bevor Sie diese Seite verlassen oder diesen Postprozessor speichern."
::msgcat::mcset $gPB(LANG) "MC(format,check_6,error,msg)"         "Ändern Sie das Format der zugehörigen Adresse, bevor Sie diese Seite öffnen."

::msgcat::mcset $gPB(LANG) "MC(msg,old_block,maximum_length)"     "Die Namen der folgenden Datenblöcke haben den Längengrenzwert überschritten:"
::msgcat::mcset $gPB(LANG) "MC(msg,old_address,maximum_length)"   "Die Namen der folgenden Wörter haben den Längengrenzwert überschritten:"
::msgcat::mcset $gPB(LANG) "MC(msg,block_address,check,title)"    "Prüfen von Datenblock- und Wortnamen"
::msgcat::mcset $gPB(LANG) "MC(msg,block_address,maximum_length)" "Einige der Datenblöcke bzw. Wörter haben den Längengrenzwert überschritten."

::msgcat::mcset $gPB(LANG) "MC(address,maximum_name_msg)"         "Die Zeichenfolgelänge hat die max. zulässige Länge überschritten."

::msgcat::mcset $gPB(LANG) "MC(ude,import,oth_list,Label)"        "Andere CDL-Datei einschließen"
::msgcat::mcset $gPB(LANG) "MC(ude,import,oth_list,Context)"      "Wählen Sie die Option \\\"Neu\\\" aus dem Kontextmenü (Klick auf rechte Maustaste) aus, um diesem Postprozessor andere CDL-Dateien hinzuzufügen."
::msgcat::mcset $gPB(LANG) "MC(ude,import,ihr_list,Label)"        "UDE von einem Postprozessor übernehmen"
::msgcat::mcset $gPB(LANG) "MC(ude,import,ihr_list,Context)"      "Wählen Sie die Option \\\"Neu\\\" aus dem Kontextmenü aus (Klick auf rechte Maustaste), um die Definitionen benutzerdefinierter Elemente sowie verknüpfter Handles aus einem Postprozessor zu übernehmen."
::msgcat::mcset $gPB(LANG) "MC(ude,import,up,Label)"              "Nach oben"
::msgcat::mcset $gPB(LANG) "MC(ude,import,down,Label)"            "Nach unten"
::msgcat::mcset $gPB(LANG) "MC(msg,exist_cdl_file)"               "Die festgelegte CDL-Datei ist bereits enthalten."

::msgcat::mcset $gPB(LANG) "MC(listing,link_var,check,Label)"     "Tcl-Variablen mit C-Variablen verbinden"
::msgcat::mcset $gPB(LANG) "MC(listing,link_var,check,Context)"   "Ein Satz häufig geänderter Tcl-Variablen (wie \\\"mom_pos\\\") kann direkt mit den internen C-Variablen verbunden werden, um die Leistung des Postprozessings zu verbessern. Bestimmte Beschränkungen müssen jedoch beachtet werden, um mögliche Fehler und Unterschiede in der NC-Ausgabe zu vermeiden. "

::msgcat::mcset $gPB(LANG) "MC(msg,check_resolution,title)"       "Lineares/Rotations-Bewegungsergebnis prüfen"
::msgcat::mcset $gPB(LANG) "MC(msg,check_resolution,linear)"      "Die Formateinstellung unterstützt die Ausgabe für die \"lineare Bewegungsauflösung\" möglicherweise nicht."
::msgcat::mcset $gPB(LANG) "MC(msg,check_resolution,rotary)"      "Die Formateinstellung unterstützt die Ausgabe für die \"Rotationsbewegungsauflösung\" möglicherweise nicht."

::msgcat::mcset $gPB(LANG) "MC(cmd,export,desc,label)"            "Eingabebeschreibung für die exportierten benutzerdef. Befehle"
::msgcat::mcset $gPB(LANG) "MC(cmd,desc_dlg,title)"               "Beschreibung"
::msgcat::mcset $gPB(LANG) "MC(block,delete_row,Label)"           "Alle aktiven Element in dieser Zeile löschen"
::msgcat::mcset $gPB(LANG) "MC(block,exec_cond,set,Label)"        "Ausgabebedingung"
::msgcat::mcset $gPB(LANG) "MC(block,exec_cond,new,Label)"        "Neu..."
::msgcat::mcset $gPB(LANG) "MC(block,exec_cond,edit,Label)"       "Bearbeiten..."
::msgcat::mcset $gPB(LANG) "MC(block,exec_cond,remove,Label)"     "Entfernen..."

::msgcat::mcset $gPB(LANG) "MC(cust_cmd,name_msg_for_cond)"       "Geben Sie einen anderen Namen an.  \nDer Ausgabebedingungs-Befehl sollte folgendes Präfix enthalten"

::msgcat::mcset $gPB(LANG) "MC(machine,linearization,Label)"         "Linearisierungs-Interpolation"
::msgcat::mcset $gPB(LANG) "MC(machine,linearization,angle,Label)"   "Drehwinkel"
::msgcat::mcset $gPB(LANG) "MC(machine,linearization,angle,Context)" "Interpolierte Punkte werden basierend auf der Verteilung von Start- und Endwinkeln der Drehachsen berechnet."
::msgcat::mcset $gPB(LANG) "MC(machine,linearization,axis,Label)"    "Wkz-Achse"
::msgcat::mcset $gPB(LANG) "MC(machine,linearization,axis,Context)"  "Interpolierte Punkte werden basierend auf der Verteilung von Start- und Endvektoren der Wkz-Achse berechnet."
::msgcat::mcset $gPB(LANG) "MC(machine,resolution,continue,Label)"   "Weiter"
::msgcat::mcset $gPB(LANG) "MC(machine,resolution,abort,Label)"      "Abbrechen"

::msgcat::mcset $gPB(LANG) "MC(machine,axis,def_lintol,Label)"       "Standardtoleranz"
::msgcat::mcset $gPB(LANG) "MC(machine,axis,def_lintol,Context)"     "Linearisierungs-Standardtoleranz"
::msgcat::mcset $gPB(LANG) "MC(sub_post,inch,Lable)"                 " IN"
::msgcat::mcset $gPB(LANG) "MC(sub_post,metric,Lable)"               "MM"
::msgcat::mcset $gPB(LANG) "MC(new_sub,title,Label)"                 "Neuen untergeordneten Postprozessor erstellen"
::msgcat::mcset $gPB(LANG) "MC(new,sub_post,toggle,label)"           "Untergeordneter Postprozessor"
::msgcat::mcset $gPB(LANG) "MC(new,sub_post,toggle,tmp_label)"       "Untergeordneter Postprozessor, nur Einheiten"
::msgcat::mcset $gPB(LANG) "MC(new,unit_post,filename,msg)"          "Der neue untergeordnete Postprozessor für alternative Ausgabeeinheiten sollte benannt werden,\n indem Sie \"postfix\" \"__MM\" or \"__IN\" an den Namen des Hauptpostprozessors anhängen."
::msgcat::mcset $gPB(LANG) "MC(new,alter_unit,toggle,label)"         "Alternative Ausgabeeinheiten"
::msgcat::mcset $gPB(LANG) "MC(new,main_post,label)"                 "Haupt-Postprozessor"
::msgcat::mcset $gPB(LANG) "MC(new,main_post,warning_1,msg)"         "Es kann nur ein vollständiger Haupt-Postprozessor für das Erzeugen eines neuen untergeordneten Postprozessors verwendet werden."
::msgcat::mcset $gPB(LANG) "MC(new,main_post,warning_2,msg)"         "Der Haupt-Postprozessor muss in\n in Post Builder-Version 8.0 oder einer neuen Version erzeugt oder gespeichert werden."
::msgcat::mcset $gPB(LANG) "MC(new,main_post,specify_err,msg)"       "Der Haupt-Postprozessor muss für das Erzeugen eines untergeordneten Postprozessors festgelegt sein."
::msgcat::mcset $gPB(LANG) "MC(machine,gen,alter_unit,Label)"        "Ausgabeeinheiten des untergeordneten Postprozessors:"
::msgcat::mcset $gPB(LANG) "MC(unit_related_param,tab,Label)"        "Einheitenparameter"
::msgcat::mcset $gPB(LANG) "MC(unit_related_param,feed_rate,Label)"  "Vorschub"
::msgcat::mcset $gPB(LANG) "MC(listing,alt_unit,frame,Label)"        "Optionaler untergeordneter Postprozessor mit alternativen Einheiten"
::msgcat::mcset $gPB(LANG) "MC(listing,alt_unit,default,Label)"      "Standard"
::msgcat::mcset $gPB(LANG) "MC(listing,alt_unit,default,Context)"    "Der Standardname des untergeordneten Postprozessors mit alternativen Einheiten ist <Postprozessor-Name>__MM oder <Postprozessor-Name>__IN"
::msgcat::mcset $gPB(LANG) "MC(listing,alt_unit,specify,Label)"      "Angeben"
::msgcat::mcset $gPB(LANG) "MC(listing,alt_unit,specify,Context)"    "Geben Sie den Namen eines untergeordneten Postprozessors mit alternativen Einheiten an"
::msgcat::mcset $gPB(LANG) "MC(listing,alt_unit,select_name,Label)"  "Name auswählen"
::msgcat::mcset $gPB(LANG) "MC(listing,alt_unit,warning_1,msg)"      "Es kann nur ein untergeordneten Postprozessors mit alternativen Einheiten ausgewählt werden."
::msgcat::mcset $gPB(LANG) "MC(listing,alt_unit,warning_2,msg)"      "Der ausgewählte untergeordnete Postprozessor unterstützt die alternativen Ausgabeeinheiten für diesen Postprozessor nicht."

::msgcat::mcset $gPB(LANG) "MC(listing,alt_unit,post_name,Label)"    "Untergeordneten Postprozessor mit alternativen Einheiten"
::msgcat::mcset $gPB(LANG) "MC(listing,alt_unit,post_name,Context)"  "Der NX-Postprozessor verwendet den untergeordneten Postprozessor mit Einheiten, falls angegeben, um die alternativen Ausgabeeinheiten für diesen Postprozessor zu verarbeiten."


##--------------------
## New string in v7.5
##
::msgcat::mcset $gPB(LANG) "MC(machine,axis,violation,user,evt_title)"  "Benutzerdefinierte Aktion bei Verletzung der Achsenbegrenzung"
::msgcat::mcset $gPB(LANG) "MC(event,helix,name)"                       "Spiralförmige Verschiebung"
::msgcat::mcset $gPB(LANG) "MC(event,circular,ijk_param,prefix,msg)"    "In Adressen verwendete Ausdrücke"
::msgcat::mcset $gPB(LANG) "MC(event,circular,ijk_param,postfix,msg)"   "werden nicht von den Änderungen an dieser Option beeinflusst."
::msgcat::mcset $gPB(LANG) "MC(isv,spec_codelist,default,msg)"          "Mit dieser Aktion wird die Liste spezieller NC-Codes und\n deren Handler auf den Status zurückgesetzt, der vorhanden war, als dieser Postprozessor geöffnet bzw. erzeugt wurde.\n\n Möchten Sie fortfahren?"
::msgcat::mcset $gPB(LANG) "MC(isv,spec_codelist,restore,msg)"          "Mit dieser Aktion wird die Liste spezieller NC-Codes und\n deren Handler auf den Status zurückgesetzt, der vorhanden war, als diese Seite zuletzt besucht wurde.\n\n Möchten Sie fortfahren?"
::msgcat::mcset $gPB(LANG) "MC(msg,block_format_command,paste_err)"     "Objektname ist bereits vorhanden...Einfügen ungültig."
::msgcat::mcset $gPB(LANG) "MC(main,file,open,choose_cntl_type)"        "Eine Steuerungsfamilie auswählen"
::msgcat::mcset $gPB(LANG) "MC(cust_cmd,import,no_vnc_cmd,msg)"         "Diese Datei enthält keinen neuen oder anderen VNC-Befehl."
::msgcat::mcset $gPB(LANG) "MC(cust_cmd,import,no_cmd,msg)"             "Diese Datei enthält keinen neuen oder anderen benutzerdef. Befehl."
::msgcat::mcset $gPB(LANG) "MC(isv,tool_info,name_same_err,Msg)"        "Die Wkz-Namen dürfen nicht identisch sein."
::msgcat::mcset $gPB(LANG) "MC(msg,limit_to_change_license)"            "Sie sind nicht der Verfasser dieses Postprozessors. \nSie haben keine Berechtigung, um die Lizenz des Postprozessors umzubenennen bzw. zu ändern."
::msgcat::mcset $gPB(LANG) "MC(output,other_opts,validation,msg)"       "Der Name der TCL-Benutzerdatei muss angegeben werden."
::msgcat::mcset $gPB(LANG) "MC(machine,empty_entry_err,msg)"            "Es befinden sich leere Einträge auf der Seite \"Parameter\"."
::msgcat::mcset $gPB(LANG) "MC(msg,control_v_limit)"                    "Die Zeichenfolge, die Sie versuchen einzufügen, hat u. U.\n die zulässige Länge überschritten oder\n hat mehrere Einträge bzw. ungültige Zeichen enthalten."
::msgcat::mcset $gPB(LANG) "MC(block,capital_name_msg)"                 "Der erste Buchstabe des Quadernamens darf kein Großbuchstabe sein.\n Legen Sie einen anderen Namen fest."
::msgcat::mcset $gPB(LANG) "MC(machine,axis,violation,user,Label)"      "Benutzerdefiniert"
::msgcat::mcset $gPB(LANG) "MC(machine,axis,violation,user,Handler)"    "Handler"
::msgcat::mcset $gPB(LANG) "MC(new,user,file,NOT_EXIST)"                "Diese Benutzerdatei ist nicht vorhanden."
::msgcat::mcset $gPB(LANG) "MC(new,include_vnc,Label)"                  "Virtuelle NC-Steuerung einschließen"
::msgcat::mcset $gPB(LANG) "MC(other,opt_equal,Label)"                  "Gleichheitszeichen (=)"
::msgcat::mcset $gPB(LANG) "MC(event,nurbs,name)"                       "NURBS-Verschiebung"
::msgcat::mcset $gPB(LANG) "MC(event,cycle,tap_float,name)"             "Gewindebohrer, fließend"
::msgcat::mcset $gPB(LANG) "MC(event,cycle,thread,name)"                "Gewinde"
::msgcat::mcset $gPB(LANG) "MC(ude,editor,group,MSG_NESTED_GROUP)"      "Die eingebundene Gruppierung wird nicht unterstützt."
::msgcat::mcset $gPB(LANG) "MC(ude,editor,bmp,Label)"                   "Bitmap"
::msgcat::mcset $gPB(LANG) "MC(ude,editor,bmp,Context)"                 "Fügen Sie eine neuen Bitmap-Parameter durch Ziehen in die rechte Liste hinzu."
::msgcat::mcset $gPB(LANG) "MC(ude,editor,group,Label)"                 "Gruppe"
::msgcat::mcset $gPB(LANG) "MC(ude,editor,group,Context)"               "Fügen Sie eine neuen Gruppierungsparameter durch Ziehen in die rechte Liste hinzu."
::msgcat::mcset $gPB(LANG) "MC(ude,editor,eventdlg,DESC,Label)"         "Beschreibung"
::msgcat::mcset $gPB(LANG) "MC(ude,editor,eventdlg,DESC,Context)"       "Ereignisinformationen angeben"
::msgcat::mcset $gPB(LANG) "MC(ude,editor,eventdlg,URL,Label)"          "URL"
::msgcat::mcset $gPB(LANG) "MC(ude,editor,eventdlg,URL,Context)"        "URL für Ereignisbeschreibung festlegen"
::msgcat::mcset $gPB(LANG) "MC(ude,editor,param,MSG_WRONG_IMAGE_FILE)"  "Die Bilddatei muss in BMP-Format sein."
::msgcat::mcset $gPB(LANG) "MC(ude,editor,param,MSG_WRONG_IMAGE_FOLDER)" "Der Name der Bitmap-Datei sollte keinen Verzeichnispfad enthalten."
::msgcat::mcset $gPB(LANG) "MC(ude,editor,param,MSG_WRONG_VAR_NAME)"    "Der Name der Variable muss mit einem Buchstaben beginnen."
::msgcat::mcset $gPB(LANG) "MC(ude,editor,param,MSG_WRONG_KEYWORD)"     "Der Variablenname darf kein Schlüsselwort enthalten: "
::msgcat::mcset $gPB(LANG) "MC(ude,editor,status_label)"                "Status"
::msgcat::mcset $gPB(LANG) "MC(ude,editor,vector,Label)"                "Vektor"
::msgcat::mcset $gPB(LANG) "MC(ude,editor,vector,Context)"              "Fügen Sie eine neuen Vektorparameter durch Ziehen in die rechte Liste hinzu."
::msgcat::mcset $gPB(LANG) "MC(ude,editor,popup,MSG_URL_FORMAT)"        "Die URL muss sich im Format \"http://*\" or \"file://*\" befinden, wobei keine Schrägstriche verwendet werden."
::msgcat::mcset $gPB(LANG) "MC(ude,editor,popup,MSG_BLANK_HELP_INFO)"   "Beschreibung sowie URL müssen angegeben werden."
::msgcat::mcset $gPB(LANG) "MC(new,MSG_NO_AXIS)"                        "Die Achsenkonfiguration muss für eine Wkz-Maschine ausgewählt werden."
::msgcat::mcset $gPB(LANG) "MC(machine,info,controller_type,Label)"     "Steuerungsfamilie"
::msgcat::mcset $gPB(LANG) "MC(block,func_combo,Label)"                 "Makro"
::msgcat::mcset $gPB(LANG) "MC(block,prefix_popup,add,Label)"           "Präfix-Text hinzufügen"
::msgcat::mcset $gPB(LANG) "MC(block,prefix_popup,edit,Label)"          "Präfix-Text bearbeiten"
::msgcat::mcset $gPB(LANG) "MC(block,prefix,Label)"                     "Präfix"
::msgcat::mcset $gPB(LANG) "MC(block,suppress_popup,Label)"             "Sequenznummer unterdrücken"
::msgcat::mcset $gPB(LANG) "MC(block,custom_func,Label)"                "Benutzerdefinierte Makro"
::msgcat::mcset $gPB(LANG) "MC(seq,combo,macro,Label)"                  "Benutzerdefinierte Makro"
::msgcat::mcset $gPB(LANG) "MC(func,tab,Label)"                         "Makro"
::msgcat::mcset $gPB(LANG) "MC(func,exp,msg)"                           "Ein Ausdruck für einen Makro-Parameter sollte nicht leer sein."
::msgcat::mcset $gPB(LANG) "MC(func,edit,name,Label)"                   "Makro-Name"
::msgcat::mcset $gPB(LANG) "MC(func,disp_name,Label)"                   "Ausgabename"
::msgcat::mcset $gPB(LANG) "MC(func,param_list,Label)"                  "Parameterliste"
::msgcat::mcset $gPB(LANG) "MC(func,separator,Label)"                   "Trennzeichen"
::msgcat::mcset $gPB(LANG) "MC(func,start,Label)"                       "Startzeichen"
::msgcat::mcset $gPB(LANG) "MC(func,end,Label)"                         "Endzeichen"
::msgcat::mcset $gPB(LANG) "MC(func,output,name,Label)"                 "Ausgabeattribut"
::msgcat::mcset $gPB(LANG) "MC(func,output,check,Label)"                "Name des Ausgabeparameters"
::msgcat::mcset $gPB(LANG) "MC(func,output,link,Label)"                 "Verbindungszeichen"
::msgcat::mcset $gPB(LANG) "MC(func,col_param,Label)"                   "Parameter"
::msgcat::mcset $gPB(LANG) "MC(func,col_exp,Label)"                     "Ausdruck"
::msgcat::mcset $gPB(LANG) "MC(func,popup,insert,Label)"                "Neu"
::msgcat::mcset $gPB(LANG) "MC(func,name,err_msg)"                      "Der Makro-Name darf kein Leerzeichen enthalten."
::msgcat::mcset $gPB(LANG) "MC(func,name,blank_err)"                    "Der Makro-Name darf nicht leer sein."
::msgcat::mcset $gPB(LANG) "MC(func,name,contain_err)"                  "Der Makro-Name darf nur Buchstaben, Zahlen sowie Einträge mit Unterstrichen enthalten."
::msgcat::mcset $gPB(LANG) "MC(func,tree_node,start_err)"               "Knotenname muss mit einem Großbuchstaben beginnen."
::msgcat::mcset $gPB(LANG) "MC(func,tree_node,contain_err)"             "Der Knoten-Name darf nur Buchstaben, Zahlen sowie Einträge mit Unterstrichen enthalten."
::msgcat::mcset $gPB(LANG) "MC(func,help,Label)"                        "Informationen"
::msgcat::mcset $gPB(LANG) "MC(func,help,Context)"                      "Informationen zu Objekt zeigen"
::msgcat::mcset $gPB(LANG) "MC(func,help,MSG_NO_INFO)"                  "Es sind keine Informationen zu dieser Makro vorhanden."


##------
## Title
##
::msgcat::mcset $gPB(LANG) "MC(main,title,Unigraphics)"             "Unigraphics"
::msgcat::mcset $gPB(LANG) "MC(main,title,UG)"                      "NX"
::msgcat::mcset $gPB(LANG) "MC(main,title,Post_Builder)"            "Post Builder"

::msgcat::mcset $gPB(LANG) "MC(main,title,Version)"                 "Version"
::msgcat::mcset $gPB(LANG) "MC(main,default,Status)"                "Neu oder Öffnen aus Menü Datei auswählen."
::msgcat::mcset $gPB(LANG) "MC(main,save,Status)"                   "PP speichern"

##------
## File
##
::msgcat::mcset $gPB(LANG) "MC(main,file,Label)"                    "Datei"

::msgcat::mcset $gPB(LANG) "MC(main,file,Balloon)"                  "\ Neu, Öffnen, Speichern,\nSpeichern\ Wie, Schließen und Beenden"

::msgcat::mcset $gPB(LANG) "MC(main,file,Context)"                  "\ Neu, Öffnen, Speichern,\nSpeichern\ Wie, Schließen und Beenden"
::msgcat::mcset $gPB(LANG) "MC(main,file,menu,Context)"             " "

::msgcat::mcset $gPB(LANG) "MC(main,file,new,Label)"                "Neu ..."
::msgcat::mcset $gPB(LANG) "MC(main,file,new,Balloon)"              "Neuen Postprozessor erzeugen."
::msgcat::mcset $gPB(LANG) "MC(main,file,new,Context)"              "Neuen Postprozessor erzeugen."
::msgcat::mcset $gPB(LANG) "MC(main,file,new,Busy)"                 "Neuen Postprozessor erzeugen ..."

::msgcat::mcset $gPB(LANG) "MC(main,file,open,Label)"               "Öffnen ..."
::msgcat::mcset $gPB(LANG) "MC(main,file,open,Balloon)"             "Einen vorhandenen Postprozessor bearbeiten."
::msgcat::mcset $gPB(LANG) "MC(main,file,open,Context)"             "Einen vorhandenen Postprozessor bearbeiten."
::msgcat::mcset $gPB(LANG) "MC(main,file,open,Busy)"                "Postprozessor wird geöffnet ..."

::msgcat::mcset $gPB(LANG) "MC(main,file,mdfa,Label)"               "MDFA importieren ..."
::msgcat::mcset $gPB(LANG) "MC(main,file,mdfa,Balloon)"             "Neuen Postprozessor aus MDFA erzeugen."
::msgcat::mcset $gPB(LANG) "MC(main,file,mdfa,Context)"             "Neuen Postprozessor aus MDFA erzeugen."

::msgcat::mcset $gPB(LANG) "MC(main,file,save,Label)"               "Speichern"
::msgcat::mcset $gPB(LANG) "MC(main,file,save,Balloon)"             "PP in Bearbeitung speichern."
::msgcat::mcset $gPB(LANG) "MC(main,file,save,Context)"             "PP in Bearbeitung speichern."
::msgcat::mcset $gPB(LANG) "MC(main,file,save,Busy)"                "PP wird gespeichert ..."

::msgcat::mcset $gPB(LANG) "MC(main,file,save_as,Label)"            "Speichern unter ..."
::msgcat::mcset $gPB(LANG) "MC(main,file,save_as,Balloon)"          "PP mit neuem Namen speichern."
::msgcat::mcset $gPB(LANG) "MC(main,file,save_as,Context)"          "PP mit neuem Namen speichern."

::msgcat::mcset $gPB(LANG) "MC(main,file,close,Label)"              "Schließen"
::msgcat::mcset $gPB(LANG) "MC(main,file,close,Balloon)"            "PP in Bearbeitung speichern."
::msgcat::mcset $gPB(LANG) "MC(main,file,close,Context)"            "PP in Bearbeitung speichern."

::msgcat::mcset $gPB(LANG) "MC(main,file,exit,Label)"               "Beenden"
::msgcat::mcset $gPB(LANG) "MC(main,file,exit,Balloon)"             "Postprozessor beenden.                                                                                                                                                                                                      "
::msgcat::mcset $gPB(LANG) "MC(main,file,exit,Context)"             "Postprozessor beenden.                                                                                                                                                                                                      "

::msgcat::mcset $gPB(LANG) "MC(main,file,history,Label)"            "Kürzlich geöffnete Postprozessoren"
::msgcat::mcset $gPB(LANG) "MC(main,file,history,Balloon)"          "Einen zuvor geprüften PP bearbeiten."
::msgcat::mcset $gPB(LANG) "MC(main,file,history,Context)"          "Einen PP bearbeiten, der in der vorherigen Post Builder-Sitzung überprüft wurde."

##---------
## Options
##
::msgcat::mcset $gPB(LANG) "MC(main,options,Label)"                 "Optionen"

::msgcat::mcset $gPB(LANG) "MC(main,options,Balloon)"               " Benutzerdefinierte \ Befehle\ überprüfen, Stütz-\ PP"
::msgcat::mcset $gPB(LANG) "MC(main,options,Context)"               " "
::msgcat::mcset $gPB(LANG) "MC(main,options,menu,Context)"          " "

::msgcat::mcset $gPB(LANG) "MC(main,windows,Label)"                 "Windows"
::msgcat::mcset $gPB(LANG) "MC(main,windows,Balloon)"               "Liste der Bearbeitungs-Postprozessoren"
::msgcat::mcset $gPB(LANG) "MC(main,windows,Context)"               " "
::msgcat::mcset $gPB(LANG) "MC(main,windows,menu,Context)"          " "

::msgcat::mcset $gPB(LANG) "MC(main,options,properties,Label)"      "Eigenschaften"
::msgcat::mcset $gPB(LANG) "MC(main,options,properties,Balloon)"    "Eigenschaften"
::msgcat::mcset $gPB(LANG) "MC(main,options,properties,Context)"    "Eigenschaften"

::msgcat::mcset $gPB(LANG) "MC(main,options,advisor,Label)"         "PP-Assistent"
::msgcat::mcset $gPB(LANG) "MC(main,options,advisor,Balloon)"       "PP-Assistent"
::msgcat::mcset $gPB(LANG) "MC(main,options,advisor,Context)"       "PP-Assistent aktivieren/deaktivieren"

::msgcat::mcset $gPB(LANG) "MC(main,options,cmd_check,Label)"       "Benutzerdefinierte Befehle überprüfen"
::msgcat::mcset $gPB(LANG) "MC(main,options,cmd_check,Balloon)"     "Benutzerdefinierte Befehle überprüfen"
::msgcat::mcset $gPB(LANG) "MC(main,options,cmd_check,Context)"     "Änderungen für Überprüfung der benutzerdefinierten Befehle"

::msgcat::mcset $gPB(LANG) "MC(main,options,cmd_check,syntax,Label)"   "Syntaxfehler"
::msgcat::mcset $gPB(LANG) "MC(main,options,cmd_check,command,Label)"  "Unbekannte Befehle"
::msgcat::mcset $gPB(LANG) "MC(main,options,cmd_check,block,Label)"    "Unbekannte Blöcke"
::msgcat::mcset $gPB(LANG) "MC(main,options,cmd_check,address,Label)"  "Unbekannte Adressen"
::msgcat::mcset $gPB(LANG) "MC(main,options,cmd_check,format,Label)"   "Unbekannte Formate"

::msgcat::mcset $gPB(LANG) "MC(main,options,backup,Label)"          "PP-Datensicherung"
::msgcat::mcset $gPB(LANG) "MC(main,options,backup,Balloon)"        "PP-Datensicherungsmethode"
::msgcat::mcset $gPB(LANG) "MC(main,options,backup,Context)"        "Datensicherheitskopien beim Speichern des PP in Bearbeitung erstellen"

::msgcat::mcset $gPB(LANG) "MC(main,options,backup,one,Label)"      "Datensicherung des Originals"
::msgcat::mcset $gPB(LANG) "MC(main,options,backup,all,Label)"      "Datensicherung bei jedem Speichern"
::msgcat::mcset $gPB(LANG) "MC(main,options,backup,none,Label)"     "Keine Datensicherung"

##-----------
## Utilities
##
::msgcat::mcset $gPB(LANG) "MC(main,utils,Label)"                   "Dienstprogramme"
::msgcat::mcset $gPB(LANG) "MC(main,utils,Balloon)"                 "\ MOM-\ Variable\ auswählen, PP\ installieren"
::msgcat::mcset $gPB(LANG) "MC(main,utils,Context)"                 " "
::msgcat::mcset $gPB(LANG) "MC(main,utils,menu,Context)"            " "

::msgcat::mcset $gPB(LANG) "MC(main,utils,etpdf,Label)"             "PP-Vorlagen-Datendatei bearbeiten"

::msgcat::mcset $gPB(LANG) "MC(main,utils,bmv,Label)"               "MOM-Variablen durchsuchen"
::msgcat::mcset $gPB(LANG) "MC(main,utils,blic,Label)"              "Lizenzen durchsuchen"


##------
## Help
##
::msgcat::mcset $gPB(LANG) "MC(main,help,Label)"                    "Hilfe"
::msgcat::mcset $gPB(LANG) "MC(main,help,Balloon)"                  "Hilfeoptionen"
::msgcat::mcset $gPB(LANG) "MC(main,help,Context)"                  "Hilfeoptionen"
::msgcat::mcset $gPB(LANG) "MC(main,help,menu,Context)"             " "

::msgcat::mcset $gPB(LANG) "MC(main,help,bal,Label)"                "Texthinweis"
::msgcat::mcset $gPB(LANG) "MC(main,help,bal,Balloon)"              "Texthinweise und Symbole"
::msgcat::mcset $gPB(LANG) "MC(main,help,bal,Context)"              "Anzeige von Texthinweisen für Symbole aktivieren/ deaktivieren."

::msgcat::mcset $gPB(LANG) "MC(main,help,chelp,Label)"              "Kontextabhängige Hilfe"
::msgcat::mcset $gPB(LANG) "MC(main,help,chelp,Balloon)"            "Kontextabhängige Hilfe in Dialogfensterelementen"
::msgcat::mcset $gPB(LANG) "MC(main,help,chelp,Context)"            "Kontextabhängige Hilfe in Dialogfensterelementen"

::msgcat::mcset $gPB(LANG) "MC(main,help,what,Label)"               "Was ist zu tun?"
::msgcat::mcset $gPB(LANG) "MC(main,help,what,Balloon)"             "Was kann hier getan werden?"
::msgcat::mcset $gPB(LANG) "MC(main,help,what,Context)"             "Was kann hier getan werden?"

::msgcat::mcset $gPB(LANG) "MC(main,help,dialog,Label)"             "Hilfe zu diesem Dialogfenster"
::msgcat::mcset $gPB(LANG) "MC(main,help,dialog,Balloon)"           "Hilfe zu diesem Dialogfenster"
::msgcat::mcset $gPB(LANG) "MC(main,help,dialog,Context)"           "Hilfe zu diesem Dialogfenster"

::msgcat::mcset $gPB(LANG) "MC(main,help,manual,Label)"             "Benutzerhandbuch"
::msgcat::mcset $gPB(LANG) "MC(main,help,manual,Balloon)"           "Benutzerhandbuch"
::msgcat::mcset $gPB(LANG) "MC(main,help,manual,Context)"           "Benutzerhandbuch"

::msgcat::mcset $gPB(LANG) "MC(main,help,about,Label)"              "Informationen zum Postprozessor"
::msgcat::mcset $gPB(LANG) "MC(main,help,about,Balloon)"            "Informationen zum Postprozessor"
::msgcat::mcset $gPB(LANG) "MC(main,help,about,Context)"            "Informationen zum Postprozessor"

::msgcat::mcset $gPB(LANG) "MC(main,help,rel_note,Label)"           "Versionsinformationen"
::msgcat::mcset $gPB(LANG) "MC(main,help,rel_note,Balloon)"         "Versionsinformationen"
::msgcat::mcset $gPB(LANG) "MC(main,help,rel_note,Context)"         "Versionsinformationen"

::msgcat::mcset $gPB(LANG) "MC(main,help,tcl_man,Label)"            "Tcl/Tk Referenzhandbuch"
::msgcat::mcset $gPB(LANG) "MC(main,help,tcl_man,Balloon)"          "Tcl/Tk Referenzhandbuch"
::msgcat::mcset $gPB(LANG) "MC(main,help,tcl_man,Context)"          "Tcl/Tk Referenzhandbuch"

##----------
## Tool Bar
##
::msgcat::mcset $gPB(LANG) "MC(tool,new,Label)"                     "Neu"
::msgcat::mcset $gPB(LANG) "MC(tool,new,Context)"                   "Neuen Postprozessor erzeugen."

::msgcat::mcset $gPB(LANG) "MC(tool,open,Label)"                    "Öffnen"
::msgcat::mcset $gPB(LANG) "MC(tool,open,Context)"                  "Einen vorhandenen Postprozessor bearbeiten."

::msgcat::mcset $gPB(LANG) "MC(tool,save,Label)"                    "Speichern"
::msgcat::mcset $gPB(LANG) "MC(tool,save,Context)"                  "PP in Bearbeitung speichern."

::msgcat::mcset $gPB(LANG) "MC(tool,bal,Label)"                     "Texthinweis"
::msgcat::mcset $gPB(LANG) "MC(tool,bal,Context)"                   "Anzeige von Texthinweisen für Symbole aktivieren/ deaktivieren."

::msgcat::mcset $gPB(LANG) "MC(tool,chelp,Label)"                   "Kontextabhängige Hilfe"
::msgcat::mcset $gPB(LANG) "MC(tool,chelp,Context)"                 "Kontextabhängige Hilfe in Dialogfensterelementen"

::msgcat::mcset $gPB(LANG) "MC(tool,what,Label)"                    "Was ist zu tun?"
::msgcat::mcset $gPB(LANG) "MC(tool,what,Context)"                  "Was kann hier getan werden?"

::msgcat::mcset $gPB(LANG) "MC(tool,dialog,Label)"                  "Hilfe zu diesem Dialogfenster"
::msgcat::mcset $gPB(LANG) "MC(tool,dialog,Context)"                "Hilfe zu diesem Dialogfenster"

::msgcat::mcset $gPB(LANG) "MC(tool,manual,Label)"                  "Benutzerhandbuch"
::msgcat::mcset $gPB(LANG) "MC(tool,manual,Context)"                "Benutzerhandbuch"

#=============
# Main Window
#=============

##-----------------
## Common Messages
##
::msgcat::mcset $gPB(LANG) "MC(msg,error,title)"                    "Postprozessor-Fehler"
::msgcat::mcset $gPB(LANG) "MC(msg,dialog,title)"                   "Postprozessor-Meldung"
::msgcat::mcset $gPB(LANG) "MC(msg,warning)"                        "Warnung"
::msgcat::mcset $gPB(LANG) "MC(msg,error)"                          "Fehler"
::msgcat::mcset $gPB(LANG) "MC(msg,invalid_data)"                   "Für den Parameter wurden ungültige Daten eingegeben"
::msgcat::mcset $gPB(LANG) "MC(msg,invalid_browser_cmd)"            "Unbekannter Browser-Befehl :"
::msgcat::mcset $gPB(LANG) "MC(msg,wrong_filename)"                 "Der Dateiname wurde geändert."
::msgcat::mcset $gPB(LANG) "MC(msg,user_ctrl_limit)"                "Ein lizenzierter Postprozessor kann nicht als Steuerung\n zum Erzeugen eines neuen Postprozessors verwendet werden, wenn Sie nicht der Ersteller sind."
::msgcat::mcset $gPB(LANG) "MC(msg,import_limit)"                   "Sie sind nicht der Ersteller dieses lizenzierten Postprozessors.\n Benutzerdefinierte Befehle werden u. U. nicht importiert."
::msgcat::mcset $gPB(LANG) "MC(msg,limit_msg)"                      "Sie sind nicht der Ersteller dieses lizenzierten Postprozessors."
::msgcat::mcset $gPB(LANG) "MC(msg,no_file)"                        "Verschlüsselte Datei ist für diesen lizenzierten Postprozessor nicht vorhanden."
::msgcat::mcset $gPB(LANG) "MC(msg,no_license)"                     "Sie besitzen keine gültige Lizenz zum Ausführen dieser Funktion."
::msgcat::mcset $gPB(LANG) "MC(msg,no_license_title)"               "NX/Postprozessor - Nicht lizenzierte Verwendung"
::msgcat::mcset $gPB(LANG) "MC(msg,no_license_dialog)"              "Es ist zulässig, dass Sie den NX/Postprozessor\n ohne gültige Lizenz verwenden.  Allerdings können Sie\n Ihre Arbeit nicht speichern."
::msgcat::mcset $gPB(LANG) "MC(msg,pending)"                        "Diese Option wird in der zukünftigen Version implementiert."
::msgcat::mcset $gPB(LANG) "MC(msg,save)"                           "Möchten Sie Ihre Änderungen vor dem\n Schließen des PP in Bearbeitung speichern?"
::msgcat::mcset $gPB(LANG) "MC(msg,version_check)"                  "Ein mit einer neueren Version des Post Builders erzeugter PP kann nicht in dieser Version geöffnet werden."

::msgcat::mcset $gPB(LANG) "MC(msg,file_corruption)"                "Fehlerhafte Inhalte in der Postprozessor-Sitzungsdatei."
::msgcat::mcset $gPB(LANG) "MC(msg,bad_tcl_file)"                   "Fehlerhafte Inhalte in der Tcl-Datei Ihres Postprozessors."
::msgcat::mcset $gPB(LANG) "MC(msg,bad_def_file)"                   "Fehlerhafte Inhalte in der Definitionsdatei Ihres Postprozessors."
::msgcat::mcset $gPB(LANG) "MC(msg,invalid_post)"                   "Sie müssen mindestens einen Satz mit Tcl- & Definitionsdateien für Ihren PP festlegen."
::msgcat::mcset $gPB(LANG) "MC(msg,invalid_dir)"                    "Verzeichnis ist nicht vorhanden."
::msgcat::mcset $gPB(LANG) "MC(msg,invalid_file)"                   "Datei nicht gefunden oder ungültig."
::msgcat::mcset $gPB(LANG) "MC(msg,invalid_def_file)"               "Definitionsdatei kann nicht geöffnet werden"
::msgcat::mcset $gPB(LANG) "MC(msg,invalid_tcl_file)"               "Datei mit Ereignis-Behandlungsroutine kann nicht geöffnet werden"
::msgcat::mcset $gPB(LANG) "MC(msg,dir_perm)"                       "Sie besitzen keinen Schreibzugriff auf das Verzeichnis:"
::msgcat::mcset $gPB(LANG) "MC(msg,file_perm)"                      "Sie besitzen keine Schreibberechtigung für"

::msgcat::mcset $gPB(LANG) "MC(msg,file_exist)"                     "ist bereits vorhanden. \nTrotzdem ersetzen?"
::msgcat::mcset $gPB(LANG) "MC(msg,file_missing)"                   "Einige bzw. alle Dateien für diesen PP sind nicht vorhanden.\n PP kann nicht geöffnet werden."
::msgcat::mcset $gPB(LANG) "MC(msg,sub_dialog_open)"                "Das Bearbeiten aller Parameter-Unterdialogfenster muss abgeschlossen sein, bevor der PP gespeichert wird."
::msgcat::mcset $gPB(LANG) "MC(msg,generic)"                        "Postprozessor wurde nur für allgemeine Fräsmaschinen implementiert."
::msgcat::mcset $gPB(LANG) "MC(msg,min_word)"                       "Ein Datenblock sollte mindestens ein Wort enthalten."
::msgcat::mcset $gPB(LANG) "MC(msg,name_exists)"                    "ist bereits vorhanden.\n Einen anderen Namen festlegen."
::msgcat::mcset $gPB(LANG) "MC(msg,in_use)"                         "Diese Komponente wird verwendet.\n Sie kann nicht gelöscht werden."
::msgcat::mcset $gPB(LANG) "MC(msg,do_you_want_to_proceed)"         "Als vorhandene Datenelemente annehmen und fortfahren."
::msgcat::mcset $gPB(LANG) "MC(msg,not_installed_properly)"         "wurde nicht richtig installiert."
::msgcat::mcset $gPB(LANG) "MC(msg,no_app_to_open)"                 "Keine zu öffnende Anwendung "
::msgcat::mcset $gPB(LANG) "MC(msg,save_change)"                    "Änderungen speichern?"

::msgcat::mcset $gPB(LANG) "MC(msg,external_editor)"                "Externer Editor"

# - Do not translate EDITOR
::msgcat::mcset $gPB(LANG) "MC(msg,set_ext_editor)"                 "Die Umgebungsvariable \"EDITOR\" kann verwendet werden, um den gewünschten Texteditor zu aktivieren."
::msgcat::mcset $gPB(LANG) "MC(msg,filename_with_space)"            "Dateinamen mit Leerzeichen werden nicht unterstützt."
::msgcat::mcset $gPB(LANG) "MC(msg,filename_protection)"            "Die von einem Bearbeitungs-Postprozessor verwendete ausgewählte Datei darf nicht überschrieben werden."


##--------------------
## Common Function
##
::msgcat::mcset $gPB(LANG) "MC(msg,parent_win)"                     "Ein temporäres Fenster erfordert, dass sein übergeordnetes Fenster definiert ist."
::msgcat::mcset $gPB(LANG) "MC(msg,close_subwin)"                   "Alle untergeordneten Fenster müssen geschlossen sein, um diese Registerkarte zu aktivieren."
::msgcat::mcset $gPB(LANG) "MC(msg,block_exist)"                    "Ein Element des ausgewählten Wortes existiert in der Datenblock-Vorlage."
::msgcat::mcset $gPB(LANG) "MC(msg,num_gcode_1)"                    "Anzahl von G - Codes sind beschränkt auf"
::msgcat::mcset $gPB(LANG) "MC(msg,num_gcode_2)"                    "pro Datenblock"
::msgcat::mcset $gPB(LANG) "MC(msg,num_mcode_1)"                    "Anzahl von M - Codes sind beschränkt auf"
::msgcat::mcset $gPB(LANG) "MC(msg,num_mcode_2)"                    "pro Datenblock"
::msgcat::mcset $gPB(LANG) "MC(msg,empty_entry)"                    "Der Eintrag sollte nicht leer sein."

::msgcat::mcset $gPB(LANG) "MC(msg,edit_feed_fmt)"                  "Formate für Adresse \"F\" können auf der Vorschub-Parameterseite bearbeitet werden"

::msgcat::mcset $gPB(LANG) "MC(msg,seq_num_max)"                    "Der maximale Wert der Sequenznummer sollte nicht überschreiten die zugewiesene N-Kapazität von"

::msgcat::mcset $gPB(LANG) "MC(msg,no_cdl_name)"                    "Der PP-Name sollte festgelegt sein."
::msgcat::mcset $gPB(LANG) "MC(msg,no_def_name)"                    "Der Ordner sollte festgelegt sein.\n Und das Muster sollte \"\$UGII_*\"sein."
::msgcat::mcset $gPB(LANG) "MC(msg,no_own_name)"                    "Der Ordner sollte festgelegt sein.\n Und das Muster sollte \"\$UGII_*\"sein."
::msgcat::mcset $gPB(LANG) "MC(msg,no_oth_ude_name)"                "Der andere cdl-Dateiname sollte festgelegt sein.\n Und das Muster sollte \"\$UGII_*\"sein."
::msgcat::mcset $gPB(LANG) "MC(msg,not_oth_cdl_file)"               "Nur CDL-Datei ist zulässig."
::msgcat::mcset $gPB(LANG) "MC(msg,not_pui_file)"                   "Nur PUI-Datei ist zulässig."
::msgcat::mcset $gPB(LANG) "MC(msg,not_cdl_file)"                   "Nur CDL-Datei ist zulässig."
::msgcat::mcset $gPB(LANG) "MC(msg,not_def_file)"                   "Nur DEF-Datei ist zulässig."
::msgcat::mcset $gPB(LANG) "MC(msg,not_own_cdl_file)"               "Nur eigene CDL-Datei ist zulässig."
::msgcat::mcset $gPB(LANG) "MC(msg,no_cdl_file)"                    "Der ausgewählte PP enthält keine verknüpfte CDL-Datei."
::msgcat::mcset $gPB(LANG) "MC(msg,cdl_info)"                       "Die CDL- und Definitionsdateien des ausgewählten Postprozessors werden in der Definitionsdatei dieses Postprozessors referenziert (Einschließen).\n Die Tcl-Datei des ausgewählten Postprozessors wird bei Laufzeit von der Datei mit Ereignis-Behandlungsroutine dieses Postprozessors als Ausgangspunkt verwendet."

::msgcat::mcset $gPB(LANG) "MC(msg,add_max1)"                       "Maximaler Adresswert"
::msgcat::mcset $gPB(LANG) "MC(msg,add_max2)"                       "sollte nicht überschreiten die Kapazität des Formats von"


::msgcat::mcset $gPB(LANG) "MC(com,text_entry_trans,title,Label)"   "Eintrag"

##---------------------------
## Common Navigation Buttons
##
::msgcat::mcset $gPB(LANG) "MC(nav_button,no_license,Message)"      "Sie besitzen keine gültige Lizenz zum Ausführen dieser Funktion."

::msgcat::mcset $gPB(LANG) "MC(nav_button,ok,Label)"                "OK"
::msgcat::mcset $gPB(LANG) "MC(nav_button,ok,Context)"              "Diese Schaltfläche ist nur in einem Unterdialogfenster verfügbar. Damit können Änderungen gespeichert und das Dialogfenster geschlossen werden."
::msgcat::mcset $gPB(LANG) "MC(nav_button,cancel,Label)"            "Abbrechen"
::msgcat::mcset $gPB(LANG) "MC(nav_button,cancel,Context)"          "Diese Schaltfläche ist nur in einem Unterdialogfenster verfügbar. Damit kann das Dialogfenster geschlossen werden."
::msgcat::mcset $gPB(LANG) "MC(nav_button,default,Label)"           "Standard"
::msgcat::mcset $gPB(LANG) "MC(nav_button,default,Context)"         "Mit dieser Schaltfläche können die Parameter im aktuellen Dialogfenster für eine Komponente bis zu der Bedingung wieder hergestellt werden, bei welcher der PP in der Sitzung erzeugt bzw. geöffnet wurde. \n \nJedoch wird der Name der fraglichen Komponente, falls verfügbar, nur bis zum Ausgangstatus der aktuell geöffneten Komponente wieder hergestellt."
::msgcat::mcset $gPB(LANG) "MC(nav_button,restore,Label)"           "Wiederherstellen"
::msgcat::mcset $gPB(LANG) "MC(nav_button,restore,Context)"         "Mit dieser Schaltfläche können die Parameter im aktuellen Dialogfenster auf die Ausgangseinstellungen der aktuell geöffneten Komponente wieder hergestellt werden."
::msgcat::mcset $gPB(LANG) "MC(nav_button,apply,Label)"             "Anwenden"
::msgcat::mcset $gPB(LANG) "MC(nav_button,apply,Context)"           "Mit dieser Schaltfläche können Änderungen ohne das Schließen des aktuellen Dialogfensters gespeichert werden.  Dadurch wird auch die Ausgangsbedingung des aktuellen Dialogfensters wieder hergestellt. \n \n(Siehe \"Wiederherstellen\" für die Ausgangsbedingung)"
::msgcat::mcset $gPB(LANG) "MC(nav_button,filter,Label)"            "Filter"
::msgcat::mcset $gPB(LANG) "MC(nav_button,filter,Context)"          "Mit dieser Schaltfläche wird der Verzeichnisfilter angewendet und Dateien aufgelistet, die die Bedingung erfüllen."
::msgcat::mcset $gPB(LANG) "MC(nav_button,yes,Label)"               "Ja"
::msgcat::mcset $gPB(LANG) "MC(nav_button,yes,Context)"             "Ja"
::msgcat::mcset $gPB(LANG) "MC(nav_button,no,Label)"                "Nein"
::msgcat::mcset $gPB(LANG) "MC(nav_button,no,Context)"              "Nein"
::msgcat::mcset $gPB(LANG) "MC(nav_button,help,Label)"              "Hilfe"
::msgcat::mcset $gPB(LANG) "MC(nav_button,help,Context)"            "Hilfe"

::msgcat::mcset $gPB(LANG) "MC(nav_button,open,Label)"              "Öffnen"
::msgcat::mcset $gPB(LANG) "MC(nav_button,open,Context)"            "Diese Schaltfläche ermöglicht das Öffnen des ausgewählten Postprozessors zur Bearbeitung."

::msgcat::mcset $gPB(LANG) "MC(nav_button,save,Label)"              "Speichern"
::msgcat::mcset $gPB(LANG) "MC(nav_button,save,Context)"            "Diese Schaltfläche steht im Dialogfenster \"Speichern Unter\" zur Verfügung, was Ihnen das Speichern des PPs in Bearbeitung ermöglicht."

::msgcat::mcset $gPB(LANG) "MC(nav_button,manage,Label)"            "Verwalten ..."
::msgcat::mcset $gPB(LANG) "MC(nav_button,manage,Context)"          "Diese Schaltfläche ermöglicht das Verwalten der Historie des kürzlich überprüften PPs."

::msgcat::mcset $gPB(LANG) "MC(nav_button,refresh,Label)"           "Aktualisieren"
::msgcat::mcset $gPB(LANG) "MC(nav_button,refresh,Context)"         "Mit dieser Schaltfläche wird die Liste entsprechend der Existenz von Objekten aktualisiert."

::msgcat::mcset $gPB(LANG) "MC(nav_button,cut,Label)"               "Ausschneiden"
::msgcat::mcset $gPB(LANG) "MC(nav_button,cut,Context)"             "Mit dieser Schaltfläche wird das ausgewählte Objekt von der Liste entfernt."

::msgcat::mcset $gPB(LANG) "MC(nav_button,copy,Label)"              "Kopieren"
::msgcat::mcset $gPB(LANG) "MC(nav_button,copy,Context)"            "Mit dieser Schaltfläche wir das ausgewählte Objekt kopiert."

::msgcat::mcset $gPB(LANG) "MC(nav_button,paste,Label)"             "Einfügen"
::msgcat::mcset $gPB(LANG) "MC(nav_button,paste,Context)"           "Mit dieser Schaltfläche wird das Objekt in den Puffer und zurück in die Liste eingefügt."

::msgcat::mcset $gPB(LANG) "MC(nav_button,edit,Label)"              "Bearbeiten"
::msgcat::mcset $gPB(LANG) "MC(nav_button,edit,Context)"            "Mit dieser Schaltfläche wird das Objekt im Puffer bearbeitet."

::msgcat::mcset $gPB(LANG) "MC(nav_button,ex_editor,Label)"         "Externen Editor verwenden"

##------------
## New dialog
##
::msgcat::mcset $gPB(LANG) "MC(new,title,Label)"                    "Neuen Postprozessor erstellen"
::msgcat::mcset $gPB(LANG) "MC(new,Status)"                         "Name eingeben & Parameter für den neuen PP auswählen."

::msgcat::mcset $gPB(LANG) "MC(new,name,Label)"                     "PP-Name"
::msgcat::mcset $gPB(LANG) "MC(new,name,Context)"                   "Name des zu erzeugenden Postprozessors"

::msgcat::mcset $gPB(LANG) "MC(new,desc,Label)"                     "Beschreibung"
::msgcat::mcset $gPB(LANG) "MC(new,desc,Context)"                   "Beschreibung des zu erzeugenden Postprozessors"

#Description for each selection
::msgcat::mcset $gPB(LANG) "MC(new,mill,desc,Label)"                "Dies ist eine Fräsmaschine."
::msgcat::mcset $gPB(LANG) "MC(new,lathe,desc,Label)"               "Dies ist eine Drehmaschine."
::msgcat::mcset $gPB(LANG) "MC(new,wedm,desc,Label)"                "Dies ist eine Drahterodieren-Maschine."

::msgcat::mcset $gPB(LANG) "MC(new,wedm_2,desc,Label)"              "Dies ist eine 2-achsige Drahterodieren-Maschine."
::msgcat::mcset $gPB(LANG) "MC(new,wedm_4,desc,Label)"              "Dies ist eine 4-achsige Drahterodieren-Maschine."
::msgcat::mcset $gPB(LANG) "MC(new,lathe_2,desc,Label)"             "Dies ist eine 2-achsige horizontale Drehmaschine."
::msgcat::mcset $gPB(LANG) "MC(new,lathe_4,desc,Label)"             "Dies ist eine 4-achsige abhängige Drehmaschine."
::msgcat::mcset $gPB(LANG) "MC(new,mill_3,desc,Label)"              "Dies ist eine 3-achsige Fräsmaschine."
::msgcat::mcset $gPB(LANG) "MC(new,mill_3MT,desc,Label)"            "3-achsige Fräs-Drehmaschine (XZC)"
::msgcat::mcset $gPB(LANG) "MC(new,mill_4H,desc,Label)"             "Dies ist eine 4-achsige Fräsmaschine mit\n Rotationskopf."
::msgcat::mcset $gPB(LANG) "MC(new,mill_4T,desc,Label)"             "Dies ist eine 4-achsige Fräsmaschine mit\n Drehtisch."
::msgcat::mcset $gPB(LANG) "MC(new,mill_5TT,desc,Label)"            "Dies ist eine 5-achsige Fräsmaschine mit\n Doppeldrehtisch."
::msgcat::mcset $gPB(LANG) "MC(new,mill_5HH,desc,Label)"            "Dies ist eine 5-achsige Fräsmaschine mit\n Doppel-Rotationsköpfen."
::msgcat::mcset $gPB(LANG) "MC(new,mill_5HT,desc,Label)"            "Dies ist eine 5-achsige Fräsmaschine mit\n Rotationskopf und Drehtisch."
::msgcat::mcset $gPB(LANG) "MC(new,punch,desc,Label)"               "Dies ist eine Stanzmaschine."

::msgcat::mcset $gPB(LANG) "MC(new,post_unit,Label)"                "PP-Ausgabeeinheit"

::msgcat::mcset $gPB(LANG) "MC(new,inch,Label)"                     "Zoll"
::msgcat::mcset $gPB(LANG) "MC(new,inch,Context)"                   "Postprozessor-Ausgabeeinheit - Zoll"
::msgcat::mcset $gPB(LANG) "MC(new,millimeter,Label)"               "Millimeter"
::msgcat::mcset $gPB(LANG) "MC(new,millimeter,Context)"             "Postprozessor-Ausgabeeinheit - Millimeter"

::msgcat::mcset $gPB(LANG) "MC(new,machine,Label)"                  "Werkzeug"
::msgcat::mcset $gPB(LANG) "MC(new,machine,Context)"                "Der Wkz-Maschinentyp, für den der Postprozessor erzeugt werden soll."

::msgcat::mcset $gPB(LANG) "MC(new,mill,Label)"                     "Fräsen"
::msgcat::mcset $gPB(LANG) "MC(new,mill,Context)"                   "Fräsmaschine"
::msgcat::mcset $gPB(LANG) "MC(new,lathe,Label)"                    "Drehen"
::msgcat::mcset $gPB(LANG) "MC(new,lathe,Context)"                  "Drehmaschine"
::msgcat::mcset $gPB(LANG) "MC(new,wire,Label)"                     "Drahterodieren"
::msgcat::mcset $gPB(LANG) "MC(new,wire,Context)"                   "Drahterodieren-Maschine"
::msgcat::mcset $gPB(LANG) "MC(new,punch,Label)"                    "Stempel"

::msgcat::mcset $gPB(LANG) "MC(new,axis,Label)"                     "Maschinenachsenauswahl"
::msgcat::mcset $gPB(LANG) "MC(new,axis,Context)"                   "Anzahl und Typ der Maschinenachsen"

#Axis Number
::msgcat::mcset $gPB(LANG) "MC(new,axis_2,Label)"                   "2-Achsen"
::msgcat::mcset $gPB(LANG) "MC(new,axis_3,Label)"                   "3-Achsen"
::msgcat::mcset $gPB(LANG) "MC(new,axis_4,Label)"                   "4-Achsen"
::msgcat::mcset $gPB(LANG) "MC(new,axis_5,Label)"                   "5-achsig"
::msgcat::mcset $gPB(LANG) "MC(new,axis_XZC,Label)"                 "XZC"


#Axis Type
::msgcat::mcset $gPB(LANG) "MC(new,mach_axis,Label)"                "Wkz-Maschinen-Ausgabe"
::msgcat::mcset $gPB(LANG) "MC(new,mach_axis,Context)"              "Wkz-Maschinen-Achse auswählen"
::msgcat::mcset $gPB(LANG) "MC(new,lathe_2,Label)"                  "2-Achsen"
::msgcat::mcset $gPB(LANG) "MC(new,mill_3,Label)"                   "3-Achsen"
::msgcat::mcset $gPB(LANG) "MC(new,mill_3MT,Label)"                 "3-achsige Fräs-Drehmaschine (XZC)"
::msgcat::mcset $gPB(LANG) "MC(new,mill_4T,Label)"                  "4 Achsen mit Drehtisch"
::msgcat::mcset $gPB(LANG) "MC(new,mill_4H,Label)"                  "4 Achsen mit Rotationskopf"
::msgcat::mcset $gPB(LANG) "MC(new,lathe_4,Label)"                  "4-Achsen"
::msgcat::mcset $gPB(LANG) "MC(new,mill_5HH,Label)"                 "5 Achsen mit Doppel-Rotationsköpfen"
::msgcat::mcset $gPB(LANG) "MC(new,mill_5TT,Label)"                 "5 Achsen mit Doppeldrehtischen"
::msgcat::mcset $gPB(LANG) "MC(new,mill_5HT,Label)"                 "5 Achsen mit Rotationskopf und Drehtisch"
::msgcat::mcset $gPB(LANG) "MC(new,wedm_2,Label)"                   "2-Achsen"
::msgcat::mcset $gPB(LANG) "MC(new,wedm_4,Label)"                   "4-Achsen"
::msgcat::mcset $gPB(LANG) "MC(new,punch,Label)"                    "Stempel"

::msgcat::mcset $gPB(LANG) "MC(new,control,Label)"                  "Regler"
::msgcat::mcset $gPB(LANG) "MC(new,control,Context)"                "PP-Steuerung auswählen"

#Controller Type
::msgcat::mcset $gPB(LANG) "MC(new,generic,Label)"                  "Allgemein"
::msgcat::mcset $gPB(LANG) "MC(new,library,Label)"                  "Bibliothek"
::msgcat::mcset $gPB(LANG) "MC(new,user,Label)"                     "Benutzer"
::msgcat::mcset $gPB(LANG) "MC(new,user,browse,Label)"              "Durchsuchen"

# - Machine tool/ controller brands
::msgcat::mcset $gPB(LANG) "MC(new,allen,Label)"                    "Allen Bradley"
::msgcat::mcset $gPB(LANG) "MC(new,bridge,Label)"                   "Bridgeport"
::msgcat::mcset $gPB(LANG) "MC(new,brown,Label)"                    "Brown & Sharp"
::msgcat::mcset $gPB(LANG) "MC(new,cincin,Label)"                   "Cincinati Milacron"
::msgcat::mcset $gPB(LANG) "MC(new,kearny,Label)"                   "Kearny & Tracker"
::msgcat::mcset $gPB(LANG) "MC(new,fanuc,Label)"                    "Fanuc"
::msgcat::mcset $gPB(LANG) "MC(new,ge,Label)"                       "General Electric"
::msgcat::mcset $gPB(LANG) "MC(new,gn,Label)"                       "General Numerics"
::msgcat::mcset $gPB(LANG) "MC(new,gidding,Label)"                  "Gidding & Lewis"
::msgcat::mcset $gPB(LANG) "MC(new,heiden,Label)"                   "Heidenhain"
::msgcat::mcset $gPB(LANG) "MC(new,mazak,Label)"                    "Mazak"
::msgcat::mcset $gPB(LANG) "MC(new,seimens,Label)"                  "Siemens"

##-------------
## Open dialog
##
::msgcat::mcset $gPB(LANG) "MC(open,title,Label)"                   "PP bearbeiten"
::msgcat::mcset $gPB(LANG) "MC(open,Status)"                        "Eine zu öffnende PUI-Datei auswählen."
::msgcat::mcset $gPB(LANG) "MC(open,file_type_pui)"                 "Postprozessor-Sitzungsdateien"
::msgcat::mcset $gPB(LANG) "MC(open,file_type_tcl)"                 "Tcl-Skript-Dateien"
::msgcat::mcset $gPB(LANG) "MC(open,file_type_def)"                 "Definitionsdateien"
::msgcat::mcset $gPB(LANG) "MC(open,file_type_cdl)"                 "CDL-Dateien"

##-------------
## Misc dialog
##
::msgcat::mcset $gPB(LANG) "MC(open_save,dlg,title,Label)"          "Wählen Sie eine Datei."
::msgcat::mcset $gPB(LANG) "MC(exp_cc,dlg,title,Label)"             "Benutzerdefinierte Befehle exportieren"
::msgcat::mcset $gPB(LANG) "MC(show_mt,title,Label)"                "Werkzeug"

##----------------
## Utils dialog
##
::msgcat::mcset $gPB(LANG) "MC(mvb,title,Label)"                    "MOM-Variablenbrowser"
::msgcat::mcset $gPB(LANG) "MC(mvb,cat,Label)"                      "Kategorie"
::msgcat::mcset $gPB(LANG) "MC(mvb,search,Label)"                   "Suchen"
::msgcat::mcset $gPB(LANG) "MC(mvb,defv,Label)"                     "Standardwert"
::msgcat::mcset $gPB(LANG) "MC(mvb,posv,Label)"                     "Mögliche Werte"
::msgcat::mcset $gPB(LANG) "MC(mvb,data,Label)"                     "Datentyp"
::msgcat::mcset $gPB(LANG) "MC(mvb,desc,Label)"                     "Beschreibung"

::msgcat::mcset $gPB(LANG) "MC(inposts,title,Label)"                "Bearbeiten von \"template_post.dat\""
::msgcat::mcset $gPB(LANG) "MC(tpdf,text,Label)"                    "PP-Vorlagen-Datendatei"
::msgcat::mcset $gPB(LANG) "MC(inposts,edit,title,Label)"           "Eine Linie bearbeiten"
::msgcat::mcset $gPB(LANG) "MC(inposts,edit,post,Label)"            "Postprozessor"


##----------------
## Save As dialog
##
::msgcat::mcset $gPB(LANG) "MC(save_as,title,Label)"                "Speichern unter"
::msgcat::mcset $gPB(LANG) "MC(save_as,name,Label)"                 "PP-Name"
::msgcat::mcset $gPB(LANG) "MC(save_as,name,Context)"               "Der Name, mit dem der Postprozessor gespeichert werden soll."
::msgcat::mcset $gPB(LANG) "MC(save_as,Status)"                     "Geben Sie den neuen Postprozessor-Namen ein."
::msgcat::mcset $gPB(LANG) "MC(save_as,file_type_pui)"              "Postprozessor-Sitzungsdateien"

##----------------
## Common Widgets
##
::msgcat::mcset $gPB(LANG) "MC(common,entry,Label)"                 "Eintrag"
::msgcat::mcset $gPB(LANG) "MC(common,entry,Context)"               "Sie werden einen neuen Wert im Eingabefeld festlegen."

##-----------
## Note Book
##
::msgcat::mcset $gPB(LANG) "MC(nbook,tab,Label)"                    "Notizbuch-Registerkarte"
::msgcat::mcset $gPB(LANG) "MC(nbook,tab,Context)"                  "Eine Registerkarte kann ausgewählt werden, um zur gewünschten Parameterseite zu gelangen. \n \nDie Parameter in einer Registerkarte sind u. U. in Gruppen unterteilt. Auf jede Parametergruppe kann mit einer anderen Registerkarte zugegriffen werden."

##------
## Tree
##
::msgcat::mcset $gPB(LANG) "MC(tree,select,Label)"                  "Komponentenbaum"
::msgcat::mcset $gPB(LANG) "MC(tree,select,Context)"                "Sie können eine anzuzeigende Komponente auswählen, oder deren Inhalt bzw. Parameter bearbeiten."
::msgcat::mcset $gPB(LANG) "MC(tree,create,Label)"                  "Erzeugen"
::msgcat::mcset $gPB(LANG) "MC(tree,create,Context)"                "Eine neue Komponente durch Kopieren des ausgewählten Elements erstellen."
::msgcat::mcset $gPB(LANG) "MC(tree,cut,Label)"                     "Ausschneiden"
::msgcat::mcset $gPB(LANG) "MC(tree,cut,Context)"                   "Eine Komponente ausschneiden."
::msgcat::mcset $gPB(LANG) "MC(tree,paste,Label)"                   "Einfügen"
::msgcat::mcset $gPB(LANG) "MC(tree,paste,Context)"                 "Eine Komponente einfügen."
::msgcat::mcset $gPB(LANG) "MC(tree,rename,Label)"                  "Umbenennen"

##------------------
## Encrypt dialogs
##
::msgcat::mcset $gPB(LANG) "MC(encrypt,browser,Label)"              "Lizenzen-Liste"
::msgcat::mcset $gPB(LANG) "MC(encrypt,title,Label)"                "Eine Lizenz auswählen"
::msgcat::mcset $gPB(LANG) "MC(encrypt,output,Label)"               "Verschlüsselte Ausgabe"
::msgcat::mcset $gPB(LANG) "MC(encrypt,license,Label)"              "Lizenz:  "

#++++++++++++++
# Machine Tool
#++++++++++++++
::msgcat::mcset $gPB(LANG) "MC(machine,tab,Label)"                  "Werkzeug"
::msgcat::mcset $gPB(LANG) "MC(machine,Status)"                     "Maschinen-Kinematik-Parameter festlegen."

::msgcat::mcset $gPB(LANG) "MC(msg,no_display)"                     "Ein Bild für diese Wkz-Maschinen-Konfiguration ist nicht verfügbar."
::msgcat::mcset $gPB(LANG) "MC(msg,no_4th_ctable)"                  "4. Achse - C-Tabelle ist nicht zulässig."
::msgcat::mcset $gPB(LANG) "MC(msg,no_4th_max_min)"                 "4. Achse - maximale Achsenbegrenzung darf nicht mit minimaler Achsenbegrenzung übereinstimmen."
::msgcat::mcset $gPB(LANG) "MC(msg,no_4th_both_neg)"                "Begrenzungen der 4. Achse dürfen nicht beide negativ sein."
::msgcat::mcset $gPB(LANG) "MC(msg,no_4th_5th_plane)"               "Ebene der 4. Achse darf nicht mit Ebene der 5. Achse identisch sein."
::msgcat::mcset $gPB(LANG) "MC(msg,no_4thT_5thH)"                   "4. Achsentabelle und 5. Achsenkopf sind nicht zulässig."
::msgcat::mcset $gPB(LANG) "MC(msg,no_5th_max_min)"                 "Maximale Achsenbegrenzung der 5. Achse darf nicht mit der minimalen Achsenbegrenzung übereinstimmen."
::msgcat::mcset $gPB(LANG) "MC(msg,no_5th_both_neg)"                "Begrenzungen der 5. Achse dürfen nicht beide negativ sein."

##---------
# Post Info
##
::msgcat::mcset $gPB(LANG) "MC(machine,info,title,Label)"           "PP-Informationen"
::msgcat::mcset $gPB(LANG) "MC(machine,info,desc,Label)"            "Beschreibung"
::msgcat::mcset $gPB(LANG) "MC(machine,info,type,Label)"            "Systemtyp"
::msgcat::mcset $gPB(LANG) "MC(machine,info,kinematics,Label)"      "Kinematik"
::msgcat::mcset $gPB(LANG) "MC(machine,info,unit,Label)"            "Ausgabemodus"
::msgcat::mcset $gPB(LANG) "MC(machine,info,controller,Label)"      "Regler"
::msgcat::mcset $gPB(LANG) "MC(machine,info,history,Label)"         "Historie"

##---------
## Display
##
::msgcat::mcset $gPB(LANG) "MC(machine,display,Label)"              "Wkz-Maschine anzeigen"
::msgcat::mcset $gPB(LANG) "MC(machine,display,Context)"            "Mit dieser Option kann die Wkz-Maschine angezeigt werden."
::msgcat::mcset $gPB(LANG) "MC(machine,display_trans,title,Label)"  "Werkzeug"


##---------------
## General parms
##
::msgcat::mcset $gPB(LANG) "MC(machine,gen,Label)"                      "Allgemeine Parameter"
    
::msgcat::mcset $gPB(LANG) "MC(machine,gen,out_unit,Label)"             "PP-Ausgabeeinheit:"
::msgcat::mcset $gPB(LANG) "MC(machine,gen,out_unit,Context)"           "Postprozessing-Ausgabeeinheit"
::msgcat::mcset $gPB(LANG) "MC(machine,gen,out_unit,inch,Label)"        "Zoll" 
::msgcat::mcset $gPB(LANG) "MC(machine,gen,out_unit,metric,Label)"      "Metrisch"

::msgcat::mcset $gPB(LANG) "MC(machine,gen,travel_limit,Label)"         "Weggrenzen der linearen Achse"
::msgcat::mcset $gPB(LANG) "MC(machine,gen,travel_limit,Context)"       "Weggrenzen der linearen Achse"
::msgcat::mcset $gPB(LANG) "MC(machine,gen,travel_limit,x,Label)"       "X"
::msgcat::mcset $gPB(LANG) "MC(machine,gen,travel_limit,x,Context)"     "Maschinen-Weggrenze entlang X-Achse definieren."
::msgcat::mcset $gPB(LANG) "MC(machine,gen,travel_limit,y,Label)"       "Y"
::msgcat::mcset $gPB(LANG) "MC(machine,gen,travel_limit,y,Context)"     "Maschinen-Weggrenze entlang Y-Achse definieren."
::msgcat::mcset $gPB(LANG) "MC(machine,gen,travel_limit,z,Label)"       "Z"
::msgcat::mcset $gPB(LANG) "MC(machine,gen,travel_limit,z,Context)"     "Maschinen-Weggrenze entlang Z-Achse definieren."

::msgcat::mcset $gPB(LANG) "MC(machine,gen,home_pos,Label)"             "Ausgangsposition"
::msgcat::mcset $gPB(LANG) "MC(machine,gen,home_pos,Context)"           "Ausgangsposition"
::msgcat::mcset $gPB(LANG) "MC(machine,gen,home_pos,x,Label)"           "X"
::msgcat::mcset $gPB(LANG) "MC(machine,gen,home_pos,x,Context)"         "Maschinen-Ausgangsposition der X-Achse bezüglich der physischen Nullposition der Achse.  Maschine kehrt für automatischen Wkz-Wechsel zu dieser Position zurück."
::msgcat::mcset $gPB(LANG) "MC(machine,gen,home_pos,y,Label)"           "Y"
::msgcat::mcset $gPB(LANG) "MC(machine,gen,home_pos,y,Context)"         "Maschinen-Ausgangsposition der Y-Achse bezüglich der physischen Nullposition der Achse.  Maschine kehrt für automatischen Wkz-Wechsel zu dieser Position zurück."
::msgcat::mcset $gPB(LANG) "MC(machine,gen,home_pos,z,Label)"           "Z"
::msgcat::mcset $gPB(LANG) "MC(machine,gen,home_pos,z,Context)"         "Maschinen-Ausgangsposition der Z-Achse bezüglich der physischen Nullposition der Achse.  Maschine kehrt für automatischen Wkz-Wechsel zu dieser Position zurück."

::msgcat::mcset $gPB(LANG) "MC(machine,gen,step_size,Label)"            "Lineare Bewegungsauflösung"
::msgcat::mcset $gPB(LANG) "MC(machine,gen,step_size,min,Label)"        "Minimum"
::msgcat::mcset $gPB(LANG) "MC(machine,gen,step_size,min,Context)"      "Minimale Auflösung"

::msgcat::mcset $gPB(LANG) "MC(machine,gen,traverse_feed,Label)"        "Querungsvorschub"
::msgcat::mcset $gPB(LANG) "MC(machine,gen,traverse_feed,max,Label)"    "Maximum"
::msgcat::mcset $gPB(LANG) "MC(machine,gen,traverse_feed,max,Context)"  "Maximaler Vorschub"

::msgcat::mcset $gPB(LANG) "MC(machine,gen,circle_record,Label)"        "Kreisspurverfahren ausgeben"
::msgcat::mcset $gPB(LANG) "MC(machine,gen,circle_record,yes,Label)"    "Ja"
::msgcat::mcset $gPB(LANG) "MC(machine,gen,circle_record,yes,Context)"  "Kreisspurverfahren ausgeben."
::msgcat::mcset $gPB(LANG) "MC(machine,gen,circle_record,no,Label)"     "Nein"
::msgcat::mcset $gPB(LANG) "MC(machine,gen,circle_record,no,Context)"   "Linearspurverfahren ausgeben."

::msgcat::mcset $gPB(LANG) "MC(machine,gen,config_4and5_axis,oth,Label)"    "Sonstige"

# Wire EDM parameters
::msgcat::mcset $gPB(LANG) "MC(machine,gen,wedm,wire_tilt)"             "Drahtbiegesteuerung"
::msgcat::mcset $gPB(LANG) "MC(machine,gen,wedm,angle)"                 "Winkel"
::msgcat::mcset $gPB(LANG) "MC(machine,gen,wedm,coord)"                 "Koordinaten"

# Lathe parameters
::msgcat::mcset $gPB(LANG) "MC(machine,gen,turret,Label)"               "Revolverkopf"
::msgcat::mcset $gPB(LANG) "MC(machine,gen,turret,Context)"             "Revolverkopf"
::msgcat::mcset $gPB(LANG) "MC(machine,gen,turret,conf,Label)"          "Konfigurieren"
::msgcat::mcset $gPB(LANG) "MC(machine,gen,turret,conf,Context)"        "Wenn \"Zwei Revolver\" ausgewählt ist, erlaubt diese Option die Konfiguration der Parameter."
::msgcat::mcset $gPB(LANG) "MC(machine,gen,turret,one,Label)"           "Einzelrevolver"
::msgcat::mcset $gPB(LANG) "MC(machine,gen,turret,one,Context)"         "Einzelrevolver-Drehmaschine"
::msgcat::mcset $gPB(LANG) "MC(machine,gen,turret,two,Label)"           "Zwei Revolverköpfe"
::msgcat::mcset $gPB(LANG) "MC(machine,gen,turret,two,Context)"         "Zwei-Revolverdrehmaschine"

::msgcat::mcset $gPB(LANG) "MC(machine,gen,turret,conf_trans,Label)"    "Revolverkopf-Konfiguration"
::msgcat::mcset $gPB(LANG) "MC(machine,gen,turret,prim,Label)"          "Primärer Revolverkopf"
::msgcat::mcset $gPB(LANG) "MC(machine,gen,turret,prim,Context)"        "Ziel für primären Revolverkopf auswählen."
::msgcat::mcset $gPB(LANG) "MC(machine,gen,turret,sec,Label)"           "Sekundärer Revolverkopf"
::msgcat::mcset $gPB(LANG) "MC(machine,gen,turret,sec,Context)"         "Ziel für sekundären Revolverkopf auswählen."
::msgcat::mcset $gPB(LANG) "MC(machine,gen,turret,designation,Label)"   "Kennzeichen"
::msgcat::mcset $gPB(LANG) "MC(machine,gen,turret,xoff,Label)"          "X-Abstand"
::msgcat::mcset $gPB(LANG) "MC(machine,gen,turret,xoff,Context)"        "X-Offset festlegen"
::msgcat::mcset $gPB(LANG) "MC(machine,gen,turret,zoff,Label)"          "Z-Abstand"
::msgcat::mcset $gPB(LANG) "MC(machine,gen,turret,zoff,Context)"        "Z-Offset festlegen"

::msgcat::mcset $gPB(LANG) "MC(machine,gen,turret,front,Label)"         "Vorne"
::msgcat::mcset $gPB(LANG) "MC(machine,gen,turret,rear,Label)"          "Hinten"
::msgcat::mcset $gPB(LANG) "MC(machine,gen,turret,right,Label)"         "Rechts"
::msgcat::mcset $gPB(LANG) "MC(machine,gen,turret,left,Label)"          "Links"
::msgcat::mcset $gPB(LANG) "MC(machine,gen,turret,side,Label)"          "Seite"
::msgcat::mcset $gPB(LANG) "MC(machine,gen,turret,saddle,Label)"        "Sattel"

::msgcat::mcset $gPB(LANG) "MC(machine,gen,axis_multi,Label)"           "Achsen-Multiplikator"
::msgcat::mcset $gPB(LANG) "MC(machine,gen,axis_multi,dia,Label)"       "Durchmesser-Programmierung"
::msgcat::mcset $gPB(LANG) "MC(machine,gen,axis_multi,dia,Context)"     "Diese Option ermöglicht die Aktivierung der Durchmesser-Programmierung durch Verdopplung der ausgewählten Adressen in der N/C-Ausgabe."
::msgcat::mcset $gPB(LANG) "MC(machine,gen,axis_multi,2x,Label)"        "2X"
::msgcat::mcset $gPB(LANG) "MC(machine,gen,axis_multi,2x,Context)"      "Dieser Schalter ermöglicht die Aktivierung der Durchmesser-Programmierung durch Verdopplung der X-Achsenkoordinaten in der N/C-Ausgabe."

::msgcat::mcset $gPB(LANG) "MC(machine,gen,axis_multi,2y,Label)"        "2Y"
::msgcat::mcset $gPB(LANG) "MC(machine,gen,axis_multi,2y,Context)"      "Dieser Schalter ermöglicht die Durchmesser-Programmierung durch Verdopplung der Y-Achsenkoordinaten in der N/C-Ausgabe."
::msgcat::mcset $gPB(LANG) "MC(machine,gen,axis_multi,2i,Label)"        "2I"
::msgcat::mcset $gPB(LANG) "MC(machine,gen,axis_multi,2i,Context)"      "Dieser Schalter ermöglicht die Verdopplung der Werte von \"I\" der Kreisspurverfahren, wenn die Durchmesser-Programmierung verwendet wird."
::msgcat::mcset $gPB(LANG) "MC(machine,gen,axis_multi,2j,Label)"        "2J"
::msgcat::mcset $gPB(LANG) "MC(machine,gen,axis_multi,2j,Context)"      "Dieser Schalter ermöglicht die Verdopplung der Werte von \"J\" der Kreisspurverfahren, wenn die Durchmesser-Programmierung verwendet wird."

::msgcat::mcset $gPB(LANG) "MC(machine,gen,axis_multi,mir,Label)"       "Ausgabe spiegeln"
::msgcat::mcset $gPB(LANG) "MC(machine,gen,axis_multi,mir,Context)"     "Diese Optionen ermöglichen die Spiegelung der ausgewählten Adressen durch Negation ihrer Werte in der N/C-Ausgabe."
::msgcat::mcset $gPB(LANG) "MC(machine,gen,axis_multi,x,Label)"         "-X"
::msgcat::mcset $gPB(LANG) "MC(machine,gen,axis_multi,x,Context)"       "Dieser Schalter ermöglicht die Negation der X-Achsenkoordinate in der N/C-Ausgabe."
::msgcat::mcset $gPB(LANG) "MC(machine,gen,axis_multi,y,Label)"         "-Y"
::msgcat::mcset $gPB(LANG) "MC(machine,gen,axis_multi,y,Context)"       "Dieser Schalter ermöglicht die Negierung der Y-Achsenkoordinate in der N/C-Ausgabe."
::msgcat::mcset $gPB(LANG) "MC(machine,gen,axis_multi,z,Label)"         "-Z"
::msgcat::mcset $gPB(LANG) "MC(machine,gen,axis_multi,z,Context)"       "Dieser Schalter ermöglicht die Negation der Z-Achsenkoordinate in der N/C-Ausgabe."
::msgcat::mcset $gPB(LANG) "MC(machine,gen,axis_multi,i,Label)"         "-I"
::msgcat::mcset $gPB(LANG) "MC(machine,gen,axis_multi,i,Context)"       "Dieser Schalter ermöglicht die Negation der Werte von \"I\" der Kreisspurverfahren in der N/C-Ausgabe."
::msgcat::mcset $gPB(LANG) "MC(machine,gen,axis_multi,j,Label)"         "-J"
::msgcat::mcset $gPB(LANG) "MC(machine,gen,axis_multi,j,Context)"       "Dieser Schalter ermöglicht die Negation der Werte von \"J\" der Kreisspurverfahren in der N/C-Ausgabe."
::msgcat::mcset $gPB(LANG) "MC(machine,gen,axis_multi,k,Label)"         "-K"
::msgcat::mcset $gPB(LANG) "MC(machine,gen,axis_multi,k,Context)"       "Dieser Schalter ermöglicht die Negation der Werte von \"K\" der Kreisspurverfahren in der N/C-Ausgabe."

::msgcat::mcset $gPB(LANG) "MC(machine,gen,output,Label)"               "Ausgabemethode"
::msgcat::mcset $gPB(LANG) "MC(machine,gen,output,Context)"             "Ausgabemethode"
::msgcat::mcset $gPB(LANG) "MC(machine,gen,output,tool_tip,Label)"      "QuickInfo"
::msgcat::mcset $gPB(LANG) "MC(machine,gen,output,tool_tip,Context)"    "Ausgabe in Bezug auf Werkzeug-Tipp"
::msgcat::mcset $gPB(LANG) "MC(machine,gen,output,turret_ref,Label)"    "Revolverkopf-Referenz"
::msgcat::mcset $gPB(LANG) "MC(machine,gen,output,turret_ref,Context)"  "Ausgabe in Bezug auf Revolverkopf-Referenz"

::msgcat::mcset $gPB(LANG) "MC(machine,gen,lathe_turret,msg)"           "Bezeichnung des primären Revolverkopfs darf nicht identisch mit der des sekundären Revolverkopfs sein."
::msgcat::mcset $gPB(LANG) "MC(machine,gen,turret_chg,msg)"             "Eine Änderung dieser Option erfordert u. U. das Hinzufügen bzw. Löschen eines G92-Quaders in den Werkzeugwechsel-Ereignissen."
# Entries for XZC/Mill-Turn
::msgcat::mcset $gPB(LANG) "MC(machine,gen,spindle_axis,Label)"             "Ausgangs-Spindelachse"
::msgcat::mcset $gPB(LANG) "MC(machine,gen,spindle_axis,Context)"           "Die für das Fräswerkzeug bestimmte Ausgangsspindelachse kann entweder als parallel oder senkrecht zur Z-Achse festgelegt werden.  Die Wkz-Achse der Operation muss der festgelegten Spindelachse entsprechen.  Ein Fehler tritt auf, wenn der Postprozessor nicht mit der festgelegten Spindelachse positioniert werden kann. \nDieser Vektor kann von der festgelegten Spindelachse mit einem Kopfobjekt überschrieben werden."

::msgcat::mcset $gPB(LANG) "MC(machine,gen,position_in_yaxis,Label)"        "Position auf Y-Achse"
::msgcat::mcset $gPB(LANG) "MC(machine,gen,position_in_yaxis,Context)"      "Maschine besitzt eine programmierbare Y-Achse, die bei dem Konturfräsen positioniert werden kann.  Diese Option ist nur anwendbar, wenn sich die Spindelachse nicht entlang der Z-Achse befindet."

::msgcat::mcset $gPB(LANG) "MC(machine,gen,mach_mode,Label)"                "Bearbeit.-Verfahren"
::msgcat::mcset $gPB(LANG) "MC(machine,gen,mach_mode,Context)"              "Bearbeitungsverfahren kann entweder XZC-Fräsmaschine oder einfache Fräs-/ Drehmaschine sein."

::msgcat::mcset $gPB(LANG) "MC(machine,gen,mach_mode,xzc_mill,Label)"       "XZC-Fräsmaschine"
::msgcat::mcset $gPB(LANG) "MC(machine,gen,mach_mode,xzc_mill,Context)"     "Eine XZC-Fräsmaschine hat einen Drehtisch oder eine Aufspannplatte als C-Rotationsachse auf einer Fräs-/ Drehmaschine befestigt. Alle XY-Verschiebungen werden zu X und C konvertiert, wobei X einen Radiuswert und C den Winkel darstellt."

::msgcat::mcset $gPB(LANG) "MC(machine,gen,mach_mode,mill_turn,Label)"      "Einfache Fräs-/ Drehmaschine"
::msgcat::mcset $gPB(LANG) "MC(machine,gen,mach_mode,mill_turn,Context)"    "Dieser XZC-Fräs-Postprozessor wird mit einem Dreh-Postprozessor verknüpft, um ein Programm zu erstellen, das sowohl Fräs- als auch Drehoperationen enthält.  Der Operationstyp bestimmt, welcher Postprozessor für das Erzeugen der N/C-Ausgaben verwendet wird."

::msgcat::mcset $gPB(LANG) "MC(machine,gen,mill_turn,lathe_post,Label)"     "Dreh-Postprozessor"
::msgcat::mcset $gPB(LANG) "MC(machine,gen,mill_turn,lathe_post,Context)"   "Für einen einfachen Fräs-/ Dreh-Postprozessor ist ein Dreh-Postprozessor erforderlich, um die Drehoperationen in einem Programm nachzubearbeiten."

::msgcat::mcset $gPB(LANG) "MC(machine,gen,lathe_post,select_name,Label)"   "Name auswählen"
::msgcat::mcset $gPB(LANG) "MC(machine,gen,lathe_post,select_name,Context)" "Wählen Sie den Namen eines Dreh-Postprozessors aus, der in einem einfachen Fräs-/Dreh-Postprozessor verwendet werden soll. Wahrscheinlich befindet sich dieser Dreh-Postprozessor während der NX/Postprozessor-Laufzeit im Verzeichnis \\\$UGII_CAM_POST_DIR; anderenfalls wird ein Postprozessor mit identischem Namen in dem Verzeichnis verwendet, in dem der Fräs-Postprozessor enthalten ist."

::msgcat::mcset $gPB(LANG) "MC(machine,gen,coord_mode,Label)"               "Standard-Koordinatenmodus"
::msgcat::mcset $gPB(LANG) "MC(machine,gen,coord_mode,Context)"             "Diese Optionen legen die Ausgangseinstellungen für den Koordinatenausgabenmodus als polar (XZC) oder kartesisch (XYZ) fest.  Dieser Modus kann mit den Operationen programmierten benutzerdefinierten Elementen \\\"FESTLEGEN/POLAR,AN\\\" geändert werden."

::msgcat::mcset $gPB(LANG) "MC(machine,gen,coord_mode,polar,Label)"         "Polar"
::msgcat::mcset $gPB(LANG) "MC(machine,gen,coord_mode,polar,Context)"       "Koordinatenausgabe in XZC."

::msgcat::mcset $gPB(LANG) "MC(machine,gen,coord_mode,cart,Label)"          "Kartesisch"
::msgcat::mcset $gPB(LANG) "MC(machine,gen,coord_mode,cart,Context)"        "Koordinatenausgabe in XYZ."

::msgcat::mcset $gPB(LANG) "MC(machine,gen,xzc_arc_mode,Label)"             "Kreisspurverfahren-Modus"
::msgcat::mcset $gPB(LANG) "MC(machine,gen,xzc_arc_mode,Context)"           "Diese Optionen definieren die Ausgaben des Kreisspurverfahren, die sich im polaren (XCR) oder kartesischen (XYIJ) Modus befinden sollen."

::msgcat::mcset $gPB(LANG) "MC(machine,gen,xzc_arc_mode,polar,Label)"       "Polar"
::msgcat::mcset $gPB(LANG) "MC(machine,gen,xzc_arc_mode,polar,Context)"     "Kreisspurverfahren-Ausgabe in XCR."

::msgcat::mcset $gPB(LANG) "MC(machine,gen,xzc_arc_mode,cart,Label)"        "Kartesisch"
::msgcat::mcset $gPB(LANG) "MC(machine,gen,xzc_arc_mode,cart,Context)"      "Kreisspurverfahren-Ausgabe in XYIJ."

::msgcat::mcset $gPB(LANG) "MC(machine,gen,def_spindle_axis,Label)"         "Ausgangs-Spindelachse"
::msgcat::mcset $gPB(LANG) "MC(machine,gen,def_spindle_axis,Context)"       "Die Ausgangs-Spindelachse wird u. U. von der mit einem Kopfobjekt definierten Spindelachse außer Kraft gesetzt. \nDer Vektor muss kein Einheitsvektor sein."


##-----------------
## 4-th Axis parms
##
::msgcat::mcset $gPB(LANG) "MC(machine,axis,fourth,Label)"              "Vierte Achse"

::msgcat::mcset $gPB(LANG) "MC(machine,axis,radius_output,Label)"       "Radiusausgabe"
::msgcat::mcset $gPB(LANG) "MC(machine,axis,radius_output,Context)"     "Wenn sich die Wkz-Achse entlang der Z-Achse (0,0,1) befindet, kann der Postprozessor auswählen, ob der Radius (X) der polaren Koordinaten als \\\"Immer positiv\\\", \\\"Immer negativ\\\" oder \\\"Kürzester Abstand\\\" ausgegeben werden soll."

::msgcat::mcset $gPB(LANG) "MC(machine,axis,type_head,Label)"           "Kopf"
::msgcat::mcset $gPB(LANG) "MC(machine,axis,type_table,Label)"          "Tabelle"

##-----------------
## 5-th Axis parms
##
::msgcat::mcset $gPB(LANG) "MC(machine,axis,fifth,Label)"               "Fünfte Achse"

::msgcat::mcset $gPB(LANG) "MC(machine,axis,rotary,Label)"              "Rotationsachse"

::msgcat::mcset $gPB(LANG) "MC(machine,axis,offset,Label)"              "Mittelpunkt Nullbearbeitung zu Mittelpunkt Rotationsachse"
::msgcat::mcset $gPB(LANG) "MC(machine,axis,offset,4,Label)"            "Mittelpunkt Nullbearbeitung zu Mittelpunkt 4. Achse"
::msgcat::mcset $gPB(LANG) "MC(machine,axis,offset,5,Label)"            "Mittelpunkt 4. Achse zu Mittelpunkt 5. Achse"
::msgcat::mcset $gPB(LANG) "MC(machine,axis,offset,x,Label)"            "X-Abstand"
::msgcat::mcset $gPB(LANG) "MC(machine,axis,offset,x,Context)"          "X-Offset der Rotationsachse festlegen."
::msgcat::mcset $gPB(LANG) "MC(machine,axis,offset,y,Label)"            "Y-Abstand"
::msgcat::mcset $gPB(LANG) "MC(machine,axis,offset,y,Context)"          "Y-Offset der Rotationsachse festlegen."
::msgcat::mcset $gPB(LANG) "MC(machine,axis,offset,z,Label)"            "Z-Abstand"
::msgcat::mcset $gPB(LANG) "MC(machine,axis,offset,z,Context)"          "Z-Offset der Rotationsachse festlegen."

::msgcat::mcset $gPB(LANG) "MC(machine,axis,rotation,Label)"            "Achsenrotation"
::msgcat::mcset $gPB(LANG) "MC(machine,axis,rotation,norm,Label)"       "Normal"
::msgcat::mcset $gPB(LANG) "MC(machine,axis,rotation,norm,Context)"     "Achsenrotationsrichtung auf senkrecht festlegen."
::msgcat::mcset $gPB(LANG) "MC(machine,axis,rotation,rev,Label)"        "Umgekehrt"
::msgcat::mcset $gPB(LANG) "MC(machine,axis,rotation,rev,Context)"      "Umzukehrende Achsenrotationsrichtung festlegen."

::msgcat::mcset $gPB(LANG) "MC(machine,axis,direction,Label)"           "Achsrichtung"
::msgcat::mcset $gPB(LANG) "MC(machine,axis,direction,Context)"         "Achsenrichtung auswählen."

::msgcat::mcset $gPB(LANG) "MC(machine,axis,con_motion,Label)"              "Aufeinanderfolgende Rotationsbewegungen"
::msgcat::mcset $gPB(LANG) "MC(machine,axis,con_motion,combine,Label)"      "Kombiniert"
::msgcat::mcset $gPB(LANG) "MC(machine,axis,con_motion,combine,Context)"    "Dieser Schalter ermöglicht die Aktivierung/ Deaktivierung der Linearisierung. Damit wird die Toleranzoption aktiviert/ deaktiviert."
::msgcat::mcset $gPB(LANG) "MC(machine,axis,con_motion,tol,Label)"      "Toleranz"
::msgcat::mcset $gPB(LANG) "MC(machine,axis,con_motion,tol,Context)"    "Diese Option ist nur aktiv, wenn der Schalter \"Kombiniert\" aktiviert ist. Toleranz festlegen."

::msgcat::mcset $gPB(LANG) "MC(machine,axis,violation,Label)"           "Ausnahmeverarbeitung der Achsenbegrenzung"
::msgcat::mcset $gPB(LANG) "MC(machine,axis,violation,warn,Label)"      "Warnung"
::msgcat::mcset $gPB(LANG) "MC(machine,axis,violation,warn,Context)"    "Ausgabewarnung bei Verletzung der Achsenbegrenzungen."
::msgcat::mcset $gPB(LANG) "MC(machine,axis,violation,ret,Label)"       "Abfahren / Erneutes Anfahren"
::msgcat::mcset $gPB(LANG) "MC(machine,axis,violation,ret,Context)"     "Bei Verletzung der Achsenbegrenzungen Abfahren / Erneut Anfahren. \n \nIm benutzerdefinierten Befehl \"PB_CMD_init_rotaty\", können folgende Parameter angepasst werden, um die gewünschten Bewegungen zu erreichen: \n \n   mom_kin_retract_type \n   mom_kin_retract_distance \n   mom_kin_reengage_distance"

::msgcat::mcset $gPB(LANG) "MC(machine,axis,limits,Label)"              "Achsenbegrenzungen (Grad)"
::msgcat::mcset $gPB(LANG) "MC(machine,axis,limits,min,Label)"          "Minimum"
::msgcat::mcset $gPB(LANG) "MC(machine,axis,limits,min,Context)"        "Minimale Rotationsachsenbegrenzung (Grad) festlegen."
::msgcat::mcset $gPB(LANG) "MC(machine,axis,limits,max,Label)"          "Maximum"
::msgcat::mcset $gPB(LANG) "MC(machine,axis,limits,max,Context)"        "Maximale Rotationsachsenbegrenzung (Grad) festlegen."

::msgcat::mcset $gPB(LANG) "MC(machine,axis,incr_text)"                 "Diese Rotationsachse kann inkremental sein"

::msgcat::mcset $gPB(LANG) "MC(machine,axis,rotary_res,Label)"          "Rotationsbewegungsauflösung (Grad)"
::msgcat::mcset $gPB(LANG) "MC(machine,axis,rotary_res,Context)"        "Rotationsbewegungsauflösung (Grad) festlegen."

::msgcat::mcset $gPB(LANG) "MC(machine,axis,ang_offset,Label)"          "Winkel-Offset (Grad)"
::msgcat::mcset $gPB(LANG) "MC(machine,axis,ang_offset,Context)"        "Winkel-Offset (Grad) der Achse festlegen."

::msgcat::mcset $gPB(LANG) "MC(machine,axis,pivot,Label)"               "Drehpunkt-Abstand "
::msgcat::mcset $gPB(LANG) "MC(machine,axis,pivot,Context)"             "Drehpunkt-Abstand festlegen"

::msgcat::mcset $gPB(LANG) "MC(machine,axis,max_feed,Label)"            "Max. Vorschub (Grad/Min)"
::msgcat::mcset $gPB(LANG) "MC(machine,axis,max_feed,Context)"          "Max. Vorschub (Grad/Min) definieren"

::msgcat::mcset $gPB(LANG) "MC(machine,axis,plane,Label)"               "Rotationsebene"
::msgcat::mcset $gPB(LANG) "MC(machine,axis,plane,Context)"             "XY, YZ, ZX, etc. als Rotationsebene auswählen. Die Option \\\"Andere\\\" ermöglicht das Festlegen eines beliebigen Vektors."

::msgcat::mcset $gPB(LANG) "MC(machine,axis,plane,normal,Label)"        "Ebenennormalenvektor"
::msgcat::mcset $gPB(LANG) "MC(machine,axis,plane,normal,Context)"      "Ebenennormalenvektor als Rotationsachse festlegen. \nDer Vektor muss kein Einheitsvektor sein."
::msgcat::mcset $gPB(LANG) "MC(machine,axis,plane,4th,Label)"           "4-Achsen-Ebenennormale"
::msgcat::mcset $gPB(LANG) "MC(machine,axis,plane,4th,Context)"         "Ebenennormalenvektor für die 4-Achsenrotation festlegen."
::msgcat::mcset $gPB(LANG) "MC(machine,axis,plane,5th,Label)"           "5-Achsen-Ebenennormale"
::msgcat::mcset $gPB(LANG) "MC(machine,axis,plane,5th,Context)"         "Ebenennormalenvektor für die 5-Achsenrotation festlegen."

::msgcat::mcset $gPB(LANG) "MC(machine,axis,leader,Label)"              "Wort-Bezugspfeil"
::msgcat::mcset $gPB(LANG) "MC(machine,axis,leader,Context)"            "Wort-Bezugspfeil festlegen"

::msgcat::mcset $gPB(LANG) "MC(machine,axis,config,Label)"              "Konfigurieren"
::msgcat::mcset $gPB(LANG) "MC(machine,axis,config,Context)"            "Diese Option ermöglicht die Definition der 4- & 5-Achsenparameter."

::msgcat::mcset $gPB(LANG) "MC(machine,axis,r_axis_conf_trans,Label)"   "Rotationsachsenkonfiguration"
::msgcat::mcset $gPB(LANG) "MC(machine,axis,4th_axis,Label)"            "4-Achsen"
::msgcat::mcset $gPB(LANG) "MC(machine,axis,5th_axis,Label)"            "5-Achsen"
::msgcat::mcset $gPB(LANG) "MC(machine,axis,head,Label)"                " Kopf "
::msgcat::mcset $gPB(LANG) "MC(machine,axis,table,Label)"               " Tabelle "

::msgcat::mcset $gPB(LANG) "MC(machine,axis,rotary_lintol,Label)"       "Linearisierungs-Standardtoleranz"
::msgcat::mcset $gPB(LANG) "MC(machine,axis,rotary_lintol,Context)"     "Dieser Wert wird als Standardtoleranz für die Linearisierung der Drehverschiebung verwendet, wenn der PP-Befehl \"LINTOL/AN\" mit aktuellen oder vorausgehenden Operationen festgelegt wurde. Der Befehlt \"LINTOL\" kann auch eine andere Linearisierungstoleranz festlegen."

#+++++++++++++++++++++
# Program & Tool Path
#+++++++++++++++++++++
::msgcat::mcset $gPB(LANG) "MC(progtpth,tab,Label)"                 "Programm & Werkzeugweg"

##---------
## Program
##
::msgcat::mcset $gPB(LANG) "MC(prog,tab,Label)"                     "Programm"
::msgcat::mcset $gPB(LANG) "MC(prog,Status)"                        "Ereignisausgabe definieren"

::msgcat::mcset $gPB(LANG) "MC(prog,tree,Label)"                    "Programm -- Sequenzbaum"
::msgcat::mcset $gPB(LANG) "MC(prog,tree,Context)"                  "Ein N/C-Programm wird in fünf Segmente unterteilt: vier(4) Sequenzen, und der Körper des Werkzeugwegs: \n \n * Programmstart-Sequenz \n * Operationsstart-Sequenz \n * Werkzeugweg \n * Operationsend-Sequenz \n * Programmend-Sequenz \n \nJede Sequenz besteht aus einer Reihe von Markierungen. Eine Markierung gibt ein programmierbares Ereignis an, und tritt in einem bestimmten Stadium eines N/C-Programms auf. Jede Markierung kann einer bestimmten Anordnung von N/C-Codes zugeordnet werden, die ausgegeben wird wenn das Programm nachbearbeitet wird. \n \nDer Werkzeugweg wird aus zahlreichen Ereignissen gebildet. Diese werden in drei(3) Gruppen unterteilt: \n \n * Maschinensteuerung \n * Bewegungen \n * Zyklen \n"

::msgcat::mcset $gPB(LANG) "MC(prog,tree,prog_strt,Label)"          "Programmstart-Sequenz"
::msgcat::mcset $gPB(LANG) "MC(prog,tree,prog_end,Label)"           "Programmend-Sequenz"
::msgcat::mcset $gPB(LANG) "MC(prog,tree,oper_strt,Label)"          "Operationsstart-Sequenz"
::msgcat::mcset $gPB(LANG) "MC(prog,tree,oper_end,Label)"           "Operationsend-Sequenz"
::msgcat::mcset $gPB(LANG) "MC(prog,tree,tool_path,Label)"          "Werkzeugweg"
::msgcat::mcset $gPB(LANG) "MC(prog,tree,tool_path,mach_cnt,Label)" "Maschinensteuerung"
::msgcat::mcset $gPB(LANG) "MC(prog,tree,tool_path,motion,Label)"   "Bewegung"
::msgcat::mcset $gPB(LANG) "MC(prog,tree,tool_path,cycle,Label)"    "Festzyklen"
::msgcat::mcset $gPB(LANG) "MC(prog,tree,linked_posts,Label)"       "Verknüpfte PP-Sequenz"

::msgcat::mcset $gPB(LANG) "MC(prog,add,Label)"                     "Sequenz -- Datenblock hinzufügen"
::msgcat::mcset $gPB(LANG) "MC(prog,add,Context)"                   "Ein neuer Datenblock kann durch Drücken dieser Schaltfläche und Ziehen in die gewünschte Markierung hinzugefügt werden.  Datenblöcke können auch neben, über, oder unter einem vorhandenen Datenblock angehängt werden."

::msgcat::mcset $gPB(LANG) "MC(prog,trash,Label)"                   "Sequenz -- Abfalleimer"
::msgcat::mcset $gPB(LANG) "MC(prog,trash,Context)"                 "Ungewünschte Datenblöcke können aus der Sequenz entfernt werden, indem er in diesen Abfalleimer verschoben werden."

::msgcat::mcset $gPB(LANG) "MC(prog,block,Label)"                   "Sequenz -- Datenblock"
::msgcat::mcset $gPB(LANG) "MC(prog,block,Context)"                 "Jeder ungewünschte Datenblock kann aus der Sequenz entfernt werden, indem er in diesen Abfalleimer gezogen wird. \n \nEs kann auch ein Kontextmenü durch Klicken auf die rechte Maustaste aktiviert werden.  Mehrere Optionen werden im Menü zur Verfügung stehen : \n \n * Bearbeiten \n * Kraftausgabe \n * Schneiden \n * Kopieren als \n * Einfügen \n * Löschen \n"

::msgcat::mcset $gPB(LANG) "MC(prog,select,Label)"                  "Sequenz -- Datenblockauswahl"
::msgcat::mcset $gPB(LANG) "MC(prog,select,Context)"                "Der Typ der Datenblock-Komponente, der zur Sequenz hinzugefügt werden soll, kann aus der Liste ausgewählt werden. \n\AVerfügbare Komponententypen sind : \n \n * Neuer Datenblock \n * Vorhandener N/C-Datenblock \n * Bedienermeldung \n * Benutzerdefinierter Befehl \n"

::msgcat::mcset $gPB(LANG) "MC(prog,oper_temp,Label)"               "Eine Sequenzvorlage auswählen"
::msgcat::mcset $gPB(LANG) "MC(prog,add_block,Label)"               "Datenblock hinzufügen"
::msgcat::mcset $gPB(LANG) "MC(prog,seq_comb_nc,Label)"             "Kombinierte N/C Code-Datenblöcke anzeigen"
::msgcat::mcset $gPB(LANG) "MC(prog,seq_comb_nc,Context)"           "Diese Schaltfläche ermöglicht die Anzeige von Inhalten einer Sequenz in Bezug auf Datenblöcke oder N/C-Codes. \n \nN/C-Codes zeigen Wörter in korrekter Reihenfolge an."

::msgcat::mcset $gPB(LANG) "MC(prog,plus,Label)"                    "Programm -- Zusammenfassen / Schalter erweitern"
::msgcat::mcset $gPB(LANG) "MC(prog,plus,Context)"                  "Mit dieser Schaltfläche können die Äste dieser Komponente zusammengefasst oder erweitert werden."

::msgcat::mcset $gPB(LANG) "MC(prog,marker,Label)"                  "Sequenz -- Markierung"
::msgcat::mcset $gPB(LANG) "MC(prog,marker,Context)"                "Die Markierung einer Sequenz gibt mögliche Ereignisse an, die programmiert werden, und in einer Sequenz in einem bestimmten Stadium eines N/C-Programms auftreten können \n \nAuszugebende Datenblöcke die (in) jeder Markierung angehängt/ angeordnet werden ."

::msgcat::mcset $gPB(LANG) "MC(prog,event,Label)"                   "Programm -- Ereignis"
::msgcat::mcset $gPB(LANG) "MC(prog,event,Context)"                 "Jedes Ereignis kann mit einem einzigen linken Mausklick bearbeitet werden."

::msgcat::mcset $gPB(LANG) "MC(prog,nc_code,Label)"                 "Programm -- N/C-Code"
::msgcat::mcset $gPB(LANG) "MC(prog,nc_code,Context)"               "Der Text in diesem Fenster zeigt den bezeichnenden N/C-Code an, der bei dieser Markierung bzw. von diesem Ereignis ausgegeben werden soll."
::msgcat::mcset $gPB(LANG) "MC(prog,undo_popup,Label)"              "Rückgängig"

## Sequence
##
::msgcat::mcset $gPB(LANG) "MC(seq,combo,new,Label)"                "Neuer Datenblock"
::msgcat::mcset $gPB(LANG) "MC(seq,combo,comment,Label)"            "Bedienermeldung"
::msgcat::mcset $gPB(LANG) "MC(seq,combo,custom,Label)"             "Benutzerdefinierter Befehl"

::msgcat::mcset $gPB(LANG) "MC(seq,new_trans,title,Label)"          "Blockiert"
::msgcat::mcset $gPB(LANG) "MC(seq,cus_trans,title,Label)"          "Benutzerdefinierter Befehl"
::msgcat::mcset $gPB(LANG) "MC(seq,oper_trans,title,Label)"         "Bedienermeldung"

::msgcat::mcset $gPB(LANG) "MC(seq,edit_popup,Label)"               "Bearbeiten"
::msgcat::mcset $gPB(LANG) "MC(seq,force_popup,Label)"              "Kraftausgabe"
::msgcat::mcset $gPB(LANG) "MC(seq,rename_popup,Label)"             "Umbenennen"
::msgcat::mcset $gPB(LANG) "MC(seq,rename_popup,Context)"           "Der Name für diese Komponente kann festgelegt werden."
::msgcat::mcset $gPB(LANG) "MC(seq,cut_popup,Label)"                "Ausschneiden"
::msgcat::mcset $gPB(LANG) "MC(seq,copy_popup,Label)"               "Kopieren als"
::msgcat::mcset $gPB(LANG) "MC(seq,copy_popup,ref,Label)"           "Referenzierte Datenblöcke"
::msgcat::mcset $gPB(LANG) "MC(seq,copy_popup,new,Label)"           "Neue Datenblöcke"
::msgcat::mcset $gPB(LANG) "MC(seq,paste_popup,Label)"              "Einfügen"
::msgcat::mcset $gPB(LANG) "MC(seq,paste_popup,before,Label)"       "Vorher"
::msgcat::mcset $gPB(LANG) "MC(seq,paste_popup,inline,Label)"       "Innen"
::msgcat::mcset $gPB(LANG) "MC(seq,paste_popup,after,Label)"        "Nachher"
::msgcat::mcset $gPB(LANG) "MC(seq,del_popup,Label)"                "Löschen"

::msgcat::mcset $gPB(LANG) "MC(seq,force_trans,title,Label)"        "Einmalige Kraftausgabe"

##--------------
## Toolpath
##
::msgcat::mcset $gPB(LANG) "MC(tool,event_trans,title,Label)"       "Ereignis"

::msgcat::mcset $gPB(LANG) "MC(tool,event_seq,button,Label)"        "Eine Ereignisvorlage auswählen"
::msgcat::mcset $gPB(LANG) "MC(tool,add_word,button,Label)"         "Wort hinzufügen"

::msgcat::mcset $gPB(LANG) "MC(tool,format_trans,title,Label)"      "FORMAT"

::msgcat::mcset $gPB(LANG) "MC(tool,circ_trans,title,Label)"        "Kreisförmige Bewegung -- Ebenencodes"
::msgcat::mcset $gPB(LANG) "MC(tool,circ_trans,frame,Label)"        " Codes der Ebene G "
::msgcat::mcset $gPB(LANG) "MC(tool,circ_trans,xy,Label)"           "XY-Ebene"
::msgcat::mcset $gPB(LANG) "MC(tool,circ_trans,yz,Label)"           "YZ-Ebene"
::msgcat::mcset $gPB(LANG) "MC(tool,circ_trans,zx,Label)"           "ZX-Ebene"

::msgcat::mcset $gPB(LANG) "MC(tool,ijk_desc,arc_start,Label)"          "Bogenstart zu Mittelpunkt"
::msgcat::mcset $gPB(LANG) "MC(tool,ijk_desc,arc_center,Label)"         "Bogenmittelpunkt zu Start"
::msgcat::mcset $gPB(LANG) "MC(tool,ijk_desc,u_arc_start,Label)"        "Ungekennzeichneter Bogenstartpunkt zu Mittelpunkt"
::msgcat::mcset $gPB(LANG) "MC(tool,ijk_desc,absolute,Label)"           "Absoluter Bogenmittelpunkt"
::msgcat::mcset $gPB(LANG) "MC(tool,ijk_desc,long_thread_lead,Label)"   "Längs-Gewindeführung"
::msgcat::mcset $gPB(LANG) "MC(tool,ijk_desc,tran_thread_lead,Label)"   "Quer-Gewindeführung"

::msgcat::mcset $gPB(LANG) "MC(tool,spindle,range,type,Label)"              "Spindelbereichstyp"
::msgcat::mcset $gPB(LANG) "MC(tool,spindle,range,range_M,Label)"           "Separater Bereich - M-Code (M41)"
::msgcat::mcset $gPB(LANG) "MC(tool,spindle,range,with_spindle_M,Label)"    "Bereichsnummer mit M-Spindelcode (M13)"
::msgcat::mcset $gPB(LANG) "MC(tool,spindle,range,hi_lo_with_S,Label)"      "Hoher/Niedriger Bereich mit S-Code (S+100)"
::msgcat::mcset $gPB(LANG) "MC(tool,spindle,range,nonzero_range,msg)"       "Die Anzahl der Spindelbereiche muss größer als Null sein."

::msgcat::mcset $gPB(LANG) "MC(tool,spindle_trans,title,Label)"         "Spindelbereich-Codetabelle"
::msgcat::mcset $gPB(LANG) "MC(tool,spindle_trans,range,Label)"         "Bereich"
::msgcat::mcset $gPB(LANG) "MC(tool,spindle_trans,code,Label)"          "Code"
::msgcat::mcset $gPB(LANG) "MC(tool,spindle_trans,min,Label)"           "Minimum (RPM)"
::msgcat::mcset $gPB(LANG) "MC(tool,spindle_trans,max,Label)"           "Maximum (RPM)"

::msgcat::mcset $gPB(LANG) "MC(tool,spindle_desc,sep,Label)"            " Separater Bereich - M-Code (M41, M42 ...) "
::msgcat::mcset $gPB(LANG) "MC(tool,spindle_desc,range,Label)"          " Bereichsnummer mit M-Spindelcode (M13, M23 ...)"
::msgcat::mcset $gPB(LANG) "MC(tool,spindle_desc,high,Label)"           " Hoher/Niedriger Bereich mit S-Code (S+100/S-100)"
::msgcat::mcset $gPB(LANG) "MC(tool,spindle_desc,odd,Label)"            " Ungerader/Gerader Bereich mit S-Code"


::msgcat::mcset $gPB(LANG) "MC(tool,config,mill_opt1,Label)"            "Wkz-Nummer"
::msgcat::mcset $gPB(LANG) "MC(tool,config,mill_opt2,Label)"            "Wkz-Nummer und Längen-Offset-Nummer"
::msgcat::mcset $gPB(LANG) "MC(tool,config,mill_opt3,Label)"            "Längen-Offset-Nummer und Wkz-Nummer"

::msgcat::mcset $gPB(LANG) "MC(tool,config,title,Label)"                "Wkz-Codekonfiguration"
::msgcat::mcset $gPB(LANG) "MC(tool,config,output,Label)"               "Ausgabe"

::msgcat::mcset $gPB(LANG) "MC(tool,config,lathe_opt1,Label)"           "Wkz-Nummer"
::msgcat::mcset $gPB(LANG) "MC(tool,config,lathe_opt2,Label)"           "Wkz-Nummer und Längen-Offset-Nummer"
::msgcat::mcset $gPB(LANG) "MC(tool,config,lathe_opt3,Label)"           "Revolverindex und Wkz-Nummer"
::msgcat::mcset $gPB(LANG) "MC(tool,config,lathe_opt4,Label)"           "Revolverindex-Werkzeugnummer und Längen-Offset-Nummer"

::msgcat::mcset $gPB(LANG) "MC(tool,conf_desc,num,Label)"               "Wkz-Nummer"
::msgcat::mcset $gPB(LANG) "MC(tool,conf_desc,next_num,Label)"          "Folgende Wkz-Nummer"
::msgcat::mcset $gPB(LANG) "MC(tool,conf_desc,index_num,Label)"         "Revolverindex und Wkz-Nummer"
::msgcat::mcset $gPB(LANG) "MC(tool,conf_desc,index_next_num,Label)"    "Revolverindex und folgende Wkz-Nummer"
::msgcat::mcset $gPB(LANG) "MC(tool,conf_desc,num_len,Label)"           "Wkz-Nummer und Längen-Offset-Nummer"
::msgcat::mcset $gPB(LANG) "MC(tool,conf_desc,next_num_len,Label)"      "Folgende Wkz-Nummer und Längen-Offset-Nummer"
::msgcat::mcset $gPB(LANG) "MC(tool,conf_desc,len_num,Label)"           "Längen-Offset-Nummer und Wkz-Nummer"
::msgcat::mcset $gPB(LANG) "MC(tool,conf_desc,len_next_num,Label)"      "Längen-Offset-Nummer und folgende Wkz-Nummer"
::msgcat::mcset $gPB(LANG) "MC(tool,conf_desc,index_num_len,Label)"     "Revolverindex, Wkz-Nummer und Längen-Offset-Nummer"
::msgcat::mcset $gPB(LANG) "MC(tool,conf_desc,index_next_num_len,Label)"    "Revolverindex, folgende Wkz-Nummer und Längen-Offset-Nummer"

::msgcat::mcset $gPB(LANG) "MC(tool,oper_trans,title,Label)"            "Bedienermeldung"
::msgcat::mcset $gPB(LANG) "MC(tool,cus_trans,title,Label)"             "Benutzerdefinierter Befehl"

##--------------------------
## Labels for Event dialogs
##
::msgcat::mcset $gPB(LANG) "MC(event,feed,IPM_mode)"                "IPM-Modus (Zoll/Min)"

##---------
## G Codes
##
::msgcat::mcset $gPB(LANG) "MC(gcode,tab,Label)"                    "G-Codes"
::msgcat::mcset $gPB(LANG) "MC(gcode,Status)"                       "G-Codes festlegen"

##---------
## M Codes
##
::msgcat::mcset $gPB(LANG) "MC(mcode,tab,Label)"                    "M-Codes"
::msgcat::mcset $gPB(LANG) "MC(mcode,Status)"                       "M-Codes festlegen"

##-----------------
## Words Summary
##
::msgcat::mcset $gPB(LANG) "MC(addrsum,tab,Label)"                  "Wortzusammenfassung"
::msgcat::mcset $gPB(LANG) "MC(addrsum,Status)"                     "Parameter angeben"

::msgcat::mcset $gPB(LANG) "MC(addrsum,col_addr,Label)"             "Wort"
::msgcat::mcset $gPB(LANG) "MC(addrsum,col_addr,Context)"           "Eine Wortadresse kann durch das Klicken mit der linken Maustaste auf den Namen bearbeitet werden."
::msgcat::mcset $gPB(LANG) "MC(addrsum,col_lead,Label)"             "Führung/Code"
::msgcat::mcset $gPB(LANG) "MC(addrsum,col_data,Label)"             "Datentyp"
::msgcat::mcset $gPB(LANG) "MC(addrsum,col_plus,Label)"             "Plus (+)"
::msgcat::mcset $gPB(LANG) "MC(addrsum,col_lzero,Label)"            "Anführende Null"
::msgcat::mcset $gPB(LANG) "MC(addrsum,col_int,Label)"              "Ganzzahl"
::msgcat::mcset $gPB(LANG) "MC(addrsum,col_dec,Label)"              "Dezimal (.)"
::msgcat::mcset $gPB(LANG) "MC(addrsum,col_frac,Label)"             "Bruch"
::msgcat::mcset $gPB(LANG) "MC(addrsum,col_tzero,Label)"            "Nachfolgende Null"
::msgcat::mcset $gPB(LANG) "MC(addrsum,col_modal,Label)"            "Modal ?"
::msgcat::mcset $gPB(LANG) "MC(addrsum,col_min,Label)"              "Minimum"
::msgcat::mcset $gPB(LANG) "MC(addrsum,col_max,Label)"              "Maximum"
::msgcat::mcset $gPB(LANG) "MC(addrsum,col_trail,Label)"            "Präfix"

::msgcat::mcset $gPB(LANG) "MC(addrsum,radio_text,Label)"           "Text"
::msgcat::mcset $gPB(LANG) "MC(addrsum,radio_num,Label)"            "Numerisch"

::msgcat::mcset $gPB(LANG) "MC(addrsum,addr_trans,title,Label)"     "WORT"
::msgcat::mcset $gPB(LANG) "MC(addrsum,other_trans,title,Label)"    "Weitere Datenelemente"

##-----------------
## Word Sequencing
##
::msgcat::mcset $gPB(LANG) "MC(wseq,tab,Label)"                     "Wortsequenzen"
::msgcat::mcset $gPB(LANG) "MC(wseq,Status)"                        "Wörter in Reihenfolge bringen"

::msgcat::mcset $gPB(LANG) "MC(wseq,word,Label)"                    "Master-Wortsequenz"
::msgcat::mcset $gPB(LANG) "MC(wseq,word,Context)"                  "Die Reihenfolge der Worte, wie sie in der N/C-Ausgabe angezeigt werden, kann durch Ziehen jedes Wortes in die gewünschte Position erreicht werden. \n \nWenn sich das gezogene Wort auf das andere Wort fokussiert (Farbe der Rechtecksänderung), wird die Position dieser 2 Wörter ausgetauscht. Wenn ein Wort innerhalb des Fokus eines Trennzeichens zwischen zwei Wörtern gezogen wird, wird das Wort zwischen diesen zwei Wörtern eingefügt. \n \nJedes Wort kann von der Ausgabe an die N/C-Datei unterdrückt werden, indem es mit einem linken Mausklick deaktiviert wird. \n \nDiese Wörter können auch mit Hilfe der Optionen des Kontextmenüs manipuliert werden : \n \n * Neu \n * Bearbeiten \n * Löschen \n * Alle aktivieren \n"

::msgcat::mcset $gPB(LANG) "MC(wseq,active_out,Label)"              " Ausgabe - Aktiv     "
::msgcat::mcset $gPB(LANG) "MC(wseq,suppressed_out,Label)"          " Ausgabe - Unterdrückt "

::msgcat::mcset $gPB(LANG) "MC(wseq,popup_new,Label)"               "Neu"
::msgcat::mcset $gPB(LANG) "MC(wseq,popup_undo,Label)"              "Rückgängig"
::msgcat::mcset $gPB(LANG) "MC(wseq,popup_edit,Label)"              "Bearbeiten"
::msgcat::mcset $gPB(LANG) "MC(wseq,popup_delete,Label)"            "Löschen"
::msgcat::mcset $gPB(LANG) "MC(wseq,popup_all,Label)"               "Alle aktivieren"
::msgcat::mcset $gPB(LANG) "MC(wseq,transient_win,Label)"           "WORT"
::msgcat::mcset $gPB(LANG) "MC(wseq,cannot_suppress_msg)"           "darf nicht unterdrückt werden.  Wurde verwendet als einzelnes Element in"
::msgcat::mcset $gPB(LANG) "MC(wseq,empty_block_msg)"               "Unterdrückung der Ausgabe dieser Adresse resultiert in ungültigen, leeren Datenblöcken."

##----------------
## Custom Command
##
::msgcat::mcset $gPB(LANG) "MC(cust_cmd,tab,Label)"                 "Benutzerdefinierter Befehl"
::msgcat::mcset $gPB(LANG) "MC(cust_cmd,Status)"                    "Benutzerdefinierte Befehle definieren"

::msgcat::mcset $gPB(LANG) "MC(cust_cmd,name,Label)"                "Befehlsname"
::msgcat::mcset $gPB(LANG) "MC(cust_cmd,name,Context)"              "Der hier eingegebene Name wird mit einem Präfix \"PB_CMD_\" versehen, um als tatsächlicher Befehlsname zu gelten."
::msgcat::mcset $gPB(LANG) "MC(cust_cmd,proc,Label)"                "Vorgehensweise"
::msgcat::mcset $gPB(LANG) "MC(cust_cmd,proc,Context)"              "Geben Sie ein Tcl-Skript ein, um die Funktionalität dieses Befehls zu definieren. \n \n * Es ist zu beachten, dass die Skriptinhalte nicht vom Post Builder analysiert werden, aber in der Tcl-Datei gespeichert werden. Daher sind Sie für die syntaktische Korrektheit dieses Skripts verantwortlich."

::msgcat::mcset $gPB(LANG) "MC(cust_cmd,name_msg)"                  "Ungültiger benutzerdefinierter Befehlsname.\n Einen anderen Namen festlegen"
::msgcat::mcset $gPB(LANG) "MC(cust_cmd,name_msg_1)"                "für spezielle benutzerdefinierte Befehle reserviert.\n Einen anderen Namen festlegen"
::msgcat::mcset $gPB(LANG) "MC(cust_cmd,name_msg_2)"                "Nur benutzerdefinierte VNC-Befehlsnamen wie \n PB_CMD_vnc____* sind zulässig.\n Einen anderen Namen festlegen"

::msgcat::mcset $gPB(LANG) "MC(cust_cmd,import,Label)"              "Importieren"
::msgcat::mcset $gPB(LANG) "MC(cust_cmd,import,Context)"            "Benutzerdefinierte Befehle aus einer ausgewählten Tcl-Datei in den PP in Bearbeitung importieren."
::msgcat::mcset $gPB(LANG) "MC(cust_cmd,export,Label)"              "Exportieren"
::msgcat::mcset $gPB(LANG) "MC(cust_cmd,export,Context)"            "Benutzerdefinierte Befehle aus dem PP in Bearbeitung in eine Tcl-Datei exportieren."
::msgcat::mcset $gPB(LANG) "MC(cust_cmd,import,tree,Label)"         "Benutzerdefinierte Befehle importieren"
::msgcat::mcset $gPB(LANG) "MC(cust_cmd,import,tree,Context)"       "Diese Liste enthält die Vorgehensweisen für benutzerdefinierte Befehle und Tcl, die in der für den Import festgelegten Datei gefunden wurden. Eine Vorschau der Inhalte jeder Vorgehensweise kann erreicht werden, indem das Element in der Liste durch Klicken mit der linken Maustaste ausgewählt wird. Jede bereits im PP in Bearbeitung vorhandene Vorgehensweise ist <vorhanden> gekennzeichnet. Ein Doppelklick mit der linken Maustaste auf das Element aktiviert das Kontrollkästchen neben dem Element. Dies ermöglicht die Auswahl bzw. Abwahl einer zu importierenden Vorgehensweise. Standardmäßig werden alle Vorgehensweisen für den Import ausgewählt. Jedes Element kann abgewählt werden, um das Überschreiben einer vorhandenen Vorgehensweise zu vermeiden."

::msgcat::mcset $gPB(LANG) "MC(cust_cmd,export,tree,Label)"         "Benutzerdefinierte Befehle exportieren"
::msgcat::mcset $gPB(LANG) "MC(cust_cmd,export,tree,Context)"       "Diese Liste enthält die Vorgehensweisen für benutzerdefinierte Befehle und Tcl, die im PP in Bearbeitung vorhanden sind. Eine Vorschau der Inhalte jeder Vorgehensweise kann erreicht werden, indem das Element in der Liste mit einem linken Mausklick ausgewählt wird.  Ein Doppelklick mit der linken Maustaste auf das Element aktiviert das Kontrollkästchen neben dem Element.  Dies ermöglicht, dass nur gewünschte Vorgehensweisen für den Export ausgewählt werden."

::msgcat::mcset $gPB(LANG) "MC(cust_cmd,error,title)"               "Fehler für benutzerdefinierten Befehl"
::msgcat::mcset $gPB(LANG) "MC(cust_cmd,error,msg)"                 "Überprüfung der benutzerdefinierten Befehle kann aktiviert bzw. deaktiviert werden, indem die Schalter im Pulldown-Menü des Hauptmenüelements \"Optionen -> Benutzerdefinierte Befehle überprüfen\" festgelegt werden."

::msgcat::mcset $gPB(LANG) "MC(cust_cmd,select_all,Label)"          "Alle auswählen"
::msgcat::mcset $gPB(LANG) "MC(cust_cmd,select_all,Context)"        "Auf diese Schaltfläche klicken, um alle angezeigten Befehle zu importieren bzw. exportieren."
::msgcat::mcset $gPB(LANG) "MC(cust_cmd,deselect_all,Label)"        "Alle Auswahlen aufheben"
::msgcat::mcset $gPB(LANG) "MC(cust_cmd,deselect_all,Context)"      "Auf diese Schaltfläche klicken, um die Auswahl aller Befehle aufzuheben."

::msgcat::mcset $gPB(LANG) "MC(cust_cmd,import,warning,title)"      "Warnung beim Importieren/ Exportieren des benutzerdefinierten Befehls"
::msgcat::mcset $gPB(LANG) "MC(cust_cmd,import,warning,msg)"        "Kein Element für Import bzw. Export ausgewählt."



::msgcat::mcset $gPB(LANG) "MC(cust_cmd,cmd,msg)"                   "Befehle : "
::msgcat::mcset $gPB(LANG) "MC(cust_cmd,blk,msg)"                   "Datenblöcke: "
::msgcat::mcset $gPB(LANG) "MC(cust_cmd,add,msg)"                   "Adressen : "
::msgcat::mcset $gPB(LANG) "MC(cust_cmd,fmt,msg)"                   "Formate : "
::msgcat::mcset $gPB(LANG) "MC(cust_cmd,referenced,msg)"            "in benutzerdefiniertem Befehl referenziert "
::msgcat::mcset $gPB(LANG) "MC(cust_cmd,not_defined,msg)"           "wurden noch nicht im aktuellen Bereich des PP in Bearbeitung definiert."
::msgcat::mcset $gPB(LANG) "MC(cust_cmd,cannot_delete,msg)"         "kann nicht gelöscht werden."
::msgcat::mcset $gPB(LANG) "MC(cust_cmd,save_post,msg)"             "PP trotzdem speichern?"


##------------------
## Operator Message
##
::msgcat::mcset $gPB(LANG) "MC(opr_msg,text,Label)"                 "Bedienermeldung"
::msgcat::mcset $gPB(LANG) "MC(opr_msg,text,Context)"               "Als Bedienermeldung anzuzeigender Text.  Das erforderliche Sonderzeichen für den Anfang bzw. Ende der Meldung wird vom Post Builder automatisch zugeordnet. Diese Zeichen werden auf der Parameterseite \"Weitere Datenelemente\" unter der Registerkarte \"N/C-Datendefinitionen\"."

::msgcat::mcset $gPB(LANG) "MC(opr_msg,name,Label)"                 "Meldungsname"
::msgcat::mcset $gPB(LANG) "MC(opr_msg,empty_operator)"             "Eine Bedienermeldung sollte nicht leer sein."


##--------------
## Linked Posts
##
::msgcat::mcset $gPB(LANG) "MC(link_post,tab,Label)"                "Verknüpfte Postprozessoren"
::msgcat::mcset $gPB(LANG) "MC(link_post,Status)"                   "Verknüpfte Postprozessoren definieren"

::msgcat::mcset $gPB(LANG) "MC(link_post,toggle,Label)"             "Diesen Postprozessor mit weiteren verknüpfen"
::msgcat::mcset $gPB(LANG) "MC(link_post,toggle,Context)"           "Mit diesem Postprozessor können weitere Postprozessoren verknüpft werden, um komplexe Maschinenwerkzeuge zu bearbeiten, die mehrere Kombinationen einfacher Fräs- und Drehmodi ausführen."

::msgcat::mcset $gPB(LANG) "MC(link_post,head,Label)"               "Kopf"
::msgcat::mcset $gPB(LANG) "MC(link_post,head,Context)"             "Eine komplexe Wkz-Maschine kann seine Bearbeitungsoperationen mit Hilfe verschiedener Kinematiksätze in unterschiedlichen Bearbeitungsverfahren ausführen.  Jeder Kinematiksatz wird als unabhängiger Kopf im NX/Postprozessor behandelt. Bearbeitungsoperationen, die mit einem speziellen Kopf ausgeführt werden müssen, werden in einer Gruppe im Maschinenwerkzeug oder der Bearbeitungsmethodenansicht platziert. Ein \\\"Kopf\\\"-UDE wird dann der Gruppe zugewiesen, um den Kopfnamen zu bestimmen."

::msgcat::mcset $gPB(LANG) "MC(link_post,post,Label)"               "Postprozessor"
::msgcat::mcset $gPB(LANG) "MC(link_post,post,Context)"             "Ein Postprozessor ist einem Kopf für die Erstellung der N/C-Codes zugewiesen."

::msgcat::mcset $gPB(LANG) "MC(link_post,link,Label)"               "Verknüpfter Postprozessor"
::msgcat::mcset $gPB(LANG) "MC(link_post,link,Context)"             "[::msgcat::mc MC(link_post,head,Context)] \n\n [::msgcat::mc MC(link_post,post,Context)]"


::msgcat::mcset $gPB(LANG) "MC(link_post,new,Label)"                "Neu"
::msgcat::mcset $gPB(LANG) "MC(link_post,new,Context)"              "Eine neue Verbindung erzeugen."

::msgcat::mcset $gPB(LANG) "MC(link_post,edit,Label)"               "Bearbeiten"
::msgcat::mcset $gPB(LANG) "MC(link_post,edit,Context)"             "Eine Verbindung bearbeiten."

::msgcat::mcset $gPB(LANG) "MC(link_post,delete,Label)"             "Löschen"
::msgcat::mcset $gPB(LANG) "MC(link_post,delete,Context)"           "Eine Verbindung löschen."

::msgcat::mcset $gPB(LANG) "MC(link_post,select_name,Label)"        "Name auswählen"
::msgcat::mcset $gPB(LANG) "MC(link_post,select_name,Context)"      "Wählen Sie den Namen eines Postprozessors aus, der dem Kopf zugewiesen werden soll. Wahrscheinlich befindet sich dieser Postprozessor während der NX/Postprozessor-Laufzeit in dem Verzeichnis, in dem sich der Haupt-Postprozessor befindet; anderenfalls wird ein Postprozessor mit identischem Namen im Verzeichnis \\\$UGII_CAM_POST_DIR verwendet."

::msgcat::mcset $gPB(LANG) "MC(link_post,start_of_head,Label)"      "Kopfanfang"
::msgcat::mcset $gPB(LANG) "MC(link_post,start_of_head,Context)"    "Die N/C-Codes oder -Aktionen festlegen, die am Kopfanfang ausgeführt werden sollen."

::msgcat::mcset $gPB(LANG) "MC(link_post,end_of_head,Label)"        "Kopfende"
::msgcat::mcset $gPB(LANG) "MC(link_post,end_of_head,Context)"      "Die N/C-Codes oder -Aktionen festlegen, die am Kopfende ausgeführt werden sollen."
::msgcat::mcset $gPB(LANG) "MC(link_post,dlg,head,Label)"           "Kopf"
::msgcat::mcset $gPB(LANG) "MC(link_post,dlg,post,Label)"           "Postprozessor"
::msgcat::mcset $gPB(LANG) "MC(link_post,dlg,title,Label)"          "Verknüpfter Postprozessor"

#++++++++++++++++++++++
# N/C Data Definitions
#++++++++++++++++++++++
::msgcat::mcset $gPB(LANG) "MC(nc_data,tab,Label)"                  "N/C-Datendefinitionen"

##-------
## BLOCK
##
::msgcat::mcset $gPB(LANG) "MC(block,tab,Label)"                    "Block"
::msgcat::mcset $gPB(LANG) "MC(block,Status)"                       "Die Blockschablonen definieren"

::msgcat::mcset $gPB(LANG) "MC(block,name,Label)"                   "Blockname"
::msgcat::mcset $gPB(LANG) "MC(block,name,Context)"                 "Den Blocknamen eingeben"

::msgcat::mcset $gPB(LANG) "MC(block,add,Label)"                    "Wort hinzufügen"
::msgcat::mcset $gPB(LANG) "MC(block,add,Context)"                  "Ein neues Wort kann einem Block hinzugefügt werden, indem diese Schaltfläche gedrückt wird und dann in den angezeigten Block im nachfolgenden Fenster gezogen wird.  Die zu erzeugende Wortart wird aus dem Listenfenster rechts neben dieser Schaltfläche ausgewählt."

::msgcat::mcset $gPB(LANG) "MC(block,select,Label)"                 "BLOCK -- Wortauswahl"
::msgcat::mcset $gPB(LANG) "MC(block,select,Context)"               "Die gewünschte Wortart, die dem Block hinzugefügt werden soll, kann aus dieser Liste ausgewählt werden."

::msgcat::mcset $gPB(LANG) "MC(block,trash,Label)"                  "BLOCK -- Abfalleimer"
::msgcat::mcset $gPB(LANG) "MC(block,trash,Context)"                "Ungewünschte Wörter können aus dem Block entfernt werden, indem sie in diesen Abfalleimer verschoben werden."

::msgcat::mcset $gPB(LANG) "MC(block,word,Label)"                   "BLOCK -- Wort"
::msgcat::mcset $gPB(LANG) "MC(block,word,Context)"                 "Ungewünschte Wörter in diesem Block können entfernt werden, indem sie in diesen Abfalleimer verschoben werden. \n \nDurch Klicken auf die rechte Maustaste kann auch ein Kontextmenü aktiviert werden.  Mehrere Optionen werden im Menü verfügbar sein : \n \n * Bearbeiten \n * Element ändern -> \n * Optional \n * Kein Leerzeichen \n * Kraftausgabe \n * Löschen \n"

::msgcat::mcset $gPB(LANG) "MC(block,verify,Label)"                 "BLOCK -- Wortüberprüfung"
::msgcat::mcset $gPB(LANG) "MC(block,verify,Context)"               "Dieses Fenster zeigt den bezeichnenden N/C-Code an, der für ein im Block ausgewähltes Wort (unterdrückt) im obigen Fenster ausgegeben werden soll."

::msgcat::mcset $gPB(LANG) "MC(block,new_combo,Label)"              "Neue Adresse"
::msgcat::mcset $gPB(LANG) "MC(block,text_combo,Label)"             "Textelement"
::msgcat::mcset $gPB(LANG) "MC(block,oper_combo,Label)"             "Bedienermeldung"
::msgcat::mcset $gPB(LANG) "MC(block,comm_combo,Label)"             "Befehl"

::msgcat::mcset $gPB(LANG) "MC(block,edit_popup,Label)"             "Bearbeiten"
::msgcat::mcset $gPB(LANG) "MC(block,view_popup,Label)"             "Ansicht"
::msgcat::mcset $gPB(LANG) "MC(block,change_popup,Label)"           "Element ändern"
::msgcat::mcset $gPB(LANG) "MC(block,user_popup,Label)"             "Benutzerdefinierter Ausdruck"
::msgcat::mcset $gPB(LANG) "MC(block,opt_popup,Label)"              "Optional"
::msgcat::mcset $gPB(LANG) "MC(block,no_sep_popup,Label)"           "Kein Leerzeichen"
::msgcat::mcset $gPB(LANG) "MC(block,force_popup,Label)"            "Kraftausgabe"
::msgcat::mcset $gPB(LANG) "MC(block,delete_popup,Label)"           "Löschen"
::msgcat::mcset $gPB(LANG) "MC(block,undo_popup,Label)"             "Rückgängig"
::msgcat::mcset $gPB(LANG) "MC(block,delete_all,Label)"             "Alle aktiven Elemente löschen"

::msgcat::mcset $gPB(LANG) "MC(block,cmd_title,Label)"              "Benutzerdefinierter Befehl"
::msgcat::mcset $gPB(LANG) "MC(block,oper_title,Label)"             "Bedienermeldung"
::msgcat::mcset $gPB(LANG) "MC(block,addr_title,Label)"             "WORT"

::msgcat::mcset $gPB(LANG) "MC(block,new_trans,title,Label)"        "WORT"

::msgcat::mcset $gPB(LANG) "MC(block,new,word_desc,Label)"          "Neue Adresse"
::msgcat::mcset $gPB(LANG) "MC(block,oper,word_desc,Label)"         "Bedienermeldung"
::msgcat::mcset $gPB(LANG) "MC(block,cmd,word_desc,Label)"          "Benutzerdefinierter Befehl"
::msgcat::mcset $gPB(LANG) "MC(block,user,word_desc,Label)"         "Benutzerdefinierter Ausdruck"
::msgcat::mcset $gPB(LANG) "MC(block,text,word_desc,Label)"         "Textzeichenfolge"

::msgcat::mcset $gPB(LANG) "MC(block,user,expr,Label)"              "Ausdruck"

::msgcat::mcset $gPB(LANG) "MC(block,msg,min_word)"                 "Ein Datenblock sollte mindestens ein Wort enthalten."

::msgcat::mcset $gPB(LANG) "MC(block,name_msg)"                     "Ungültiger Blockname.\n Einen anderen Namen festlegen."

##---------
## ADDRESS
##
::msgcat::mcset $gPB(LANG) "MC(address,tab,Label)"                  "WORT"
::msgcat::mcset $gPB(LANG) "MC(address,Status)"                     "Wörter definieren"

::msgcat::mcset $gPB(LANG) "MC(address,name,Label)"                 "Wortname"
::msgcat::mcset $gPB(LANG) "MC(address,name,Context)"               "Der Wortname kann bearbeitet werden."

::msgcat::mcset $gPB(LANG) "MC(address,verify,Label)"               "WORT -- Überprüfung"
::msgcat::mcset $gPB(LANG) "MC(address,verify,Context)"             "Dieses Fenster zeigt den bezeichnenden N/C-Code an, der für ein Wort ausgegeben werden soll."

::msgcat::mcset $gPB(LANG) "MC(address,leader,Label)"               "Leiter"
::msgcat::mcset $gPB(LANG) "MC(address,leader,Context)"             "Eine beliebige Zeichenanzahl kann als Bezugspfeil für ein Wort eingegeben werden; ebenso kann mit der rechten Maustaste ein Zeichen aus dem Kontextmenü ausgewählt werden."

::msgcat::mcset $gPB(LANG) "MC(address,format,Label)"               "Format"
::msgcat::mcset $gPB(LANG) "MC(address,format,edit,Label)"          "Bearbeiten"
::msgcat::mcset $gPB(LANG) "MC(address,format,edit,Context)"        "Diese Schaltfläche ermöglicht das Bearbeiten des Formats, das von einem Wort verwendet wird."
::msgcat::mcset $gPB(LANG) "MC(address,format,new,Label)"           "Neu"
::msgcat::mcset $gPB(LANG) "MC(address,format,new,Context)"         "Diese Schaltfläche ermöglicht das Erstellen eines neuen Formats."

::msgcat::mcset $gPB(LANG) "MC(address,format,select,Label)"        "WORT -- Format auswählen"
::msgcat::mcset $gPB(LANG) "MC(address,format,select,Context)"      "Diese Schaltfläche ermöglicht, dass verschiedene Formate für ein Wort ausgewählt werden."

::msgcat::mcset $gPB(LANG) "MC(address,trailer,Label)"              "Präfix"
::msgcat::mcset $gPB(LANG) "MC(address,trailer,Context)"            "Eine beliebige Zeichenanzahl kann als Präfix für ein Wort eingegeben werden; ebenso kann mit der rechten Maustaste ein Zeichen aus dem Kontextmenü ausgewählt werden."

::msgcat::mcset $gPB(LANG) "MC(address,modality,Label)"             "Modal ?"
::msgcat::mcset $gPB(LANG) "MC(address,modality,Context)"           "Mit dieser Option kann die Modalität für ein Wort festgelegt werden."

::msgcat::mcset $gPB(LANG) "MC(address,modal_drop,off,Label)"       "Aus"
::msgcat::mcset $gPB(LANG) "MC(address,modal_drop,once,Label)"      "Einmalig"
::msgcat::mcset $gPB(LANG) "MC(address,modal_drop,always,Label)"    "Immer"

::msgcat::mcset $gPB(LANG) "MC(address,max,value,Label)"            "Maximum"
::msgcat::mcset $gPB(LANG) "MC(address,max,value,Context)"          "Ein maximaler Wert für ein Wort wird festgelegt."

::msgcat::mcset $gPB(LANG) "MC(address,value,text,Label)"           "Wert"

::msgcat::mcset $gPB(LANG) "MC(address,trunc_drop,Label)"           "Wert abschneiden"
::msgcat::mcset $gPB(LANG) "MC(address,warn_drop,Label)"            "Anwender warnen"
::msgcat::mcset $gPB(LANG) "MC(address,abort_drop,Label)"           "Prozess abbrechen"

::msgcat::mcset $gPB(LANG) "MC(address,max,error_handle,Label)"     "Ausnahmeverarbeitung"
::msgcat::mcset $gPB(LANG) "MC(address,max,error_handle,Context)"   "Mit dieser Schaltfläche kann die Methode für die Ausnahmeverarbeitung auf den maximalen Wert festgelegt werden: \n \n * Wert abschneiden \n * Anwender warnen \n * Verarbeitung abbrechen \n"

::msgcat::mcset $gPB(LANG) "MC(address,min,value,Label)"            "Minimum"
::msgcat::mcset $gPB(LANG) "MC(address,min,value,Context)"          "Ein minimaler Wert für ein Wort wird festgelegt."

::msgcat::mcset $gPB(LANG) "MC(address,min,error_handle,Label)"     "Ausnahmeverarbeitung"
::msgcat::mcset $gPB(LANG) "MC(address,min,error_handle,Context)"   "Mit dieser Schaltfläche kann die Methode für die Ausnahmeverarbeitung auf den minimalen Wert festgelegt werden: \n \n * Wert abschneiden \n * Anwender warnen \n * Verarbeitung abbrechen \n"

::msgcat::mcset $gPB(LANG) "MC(address,format_trans,title,Label)"   "FORMAT "
::msgcat::mcset $gPB(LANG) "MC(address,none_popup,Label)"           "Kein"

::msgcat::mcset $gPB(LANG) "MC(address,exp,Label)"                  "Ausdruck"
::msgcat::mcset $gPB(LANG) "MC(address,exp,Context)"                "Ein Ausdruck oder eine Konstante kann für einen Block festgelegt werden."
::msgcat::mcset $gPB(LANG) "MC(address,exp,msg)"                    "Ein Ausdruck für ein Blockelement sollte nicht leer sein."
::msgcat::mcset $gPB(LANG) "MC(address,exp,space_only)"             "Ein Ausdruck für in Blockelement, das numerisches Format verwendet, darf nicht nur Leerzeichen enthalten."

## No translation is needed for this string.
::msgcat::mcset $gPB(LANG) "MC(address,exp,spec_char)"              "\!  \"  \#  \&  \'  \.  \;  \<  \=  \>  \?  \@ \[  \\  \]  \^  \`  \{  \|  \}  \~"

::msgcat::mcset $gPB(LANG) "MC(address,exp,spec_char_msg)"          "Sonderzeichen \n [::msgcat::mc MC(address,exp,spec_char)] \ndürfen nicht in einem Ausdruck für numerische Daten verwendet werden."



::msgcat::mcset $gPB(LANG) "MC(address,name_msg)"                   "Ungültiger Wortname.\n Bitte einen anderen Namen festlegen."
# - No translation for rapid1, rapid2 & rapid3
::msgcat::mcset $gPB(LANG) "MC(address,rapid_add_name_msg)"         "Eilgang1, Eilgang2 und Eilgang3 sind für die interne Verwendung des Post Builders reserviert.\n Bitte einen anderen Namen festlegen."

::msgcat::mcset $gPB(LANG) "MC(address,rapid1,desc)"                "Eilgangposition entlang Längsachse"
::msgcat::mcset $gPB(LANG) "MC(address,rapid2,desc)"                "Eilgangposition entlang Querachse"
::msgcat::mcset $gPB(LANG) "MC(address,rapid3,desc)"                "Eilgangposition entlang Spindelachse"

##--------
## FORMAT
##
::msgcat::mcset $gPB(LANG) "MC(format,tab,Label)"                   "FORMAT"
::msgcat::mcset $gPB(LANG) "MC(format,Status)"                      "Definieren Sie die Formate"

::msgcat::mcset $gPB(LANG) "MC(format,verify,Label)"                "FORMAT -- Überprüfung"
::msgcat::mcset $gPB(LANG) "MC(format,verify,Context)"              "Dieses Fenster zeigt den bezeichnenden N/C-Code an, der mit dem festgelegten Format ausgegeben werden soll."

::msgcat::mcset $gPB(LANG) "MC(format,name,Label)"                  "Formatname"
::msgcat::mcset $gPB(LANG) "MC(format,name,Context)"                "Der Formatname kann bearbeitet werden."

::msgcat::mcset $gPB(LANG) "MC(format,data,type,Label)"             "Datentyp"
::msgcat::mcset $gPB(LANG) "MC(format,data,type,Context)"           "Der Datentyp für ein Format kann festgelegt werden."
::msgcat::mcset $gPB(LANG) "MC(format,data,num,Label)"              "Numerisch"
::msgcat::mcset $gPB(LANG) "MC(format,data,num,Context)"            "Diese Optionen definieren den Datentyp eines Formats als \"Numerisch\"."
::msgcat::mcset $gPB(LANG) "MC(format,data,num,integer,Label)"      "FORMAT -- Stellen der Ganzzahl"
::msgcat::mcset $gPB(LANG) "MC(format,data,num,integer,Context)"    "Diese Option definiert die Anzahl der Stellen einer Ganzzahl bzw. den Ganzzahlteil einer reellen Zahl."
::msgcat::mcset $gPB(LANG) "MC(format,data,num,fraction,Label)"     "FORMAT -- Bruchstellen"
::msgcat::mcset $gPB(LANG) "MC(format,data,num,fraction,Context)"   "Diese Option definiert die Anzahl der Stellen für den Bruchteil einer reellen Zahl."
::msgcat::mcset $gPB(LANG) "MC(format,data,num,decimal,Label)"      "Dezimalpunkt ausgeben (.)"
::msgcat::mcset $gPB(LANG) "MC(format,data,num,decimal,Context)"    "Mit dieser Option können Dezimalpunkte in N/C-Codes ausgegeben werden."
::msgcat::mcset $gPB(LANG) "MC(format,data,num,lead,Label)"         "Anführende Nullen ausgeben"
::msgcat::mcset $gPB(LANG) "MC(format,data,num,lead,Context)"       "Diese Option ermöglicht anführenden Nullen den Zusatz zu Nummern im N/C-Code."
::msgcat::mcset $gPB(LANG) "MC(format,data,num,trail,Label)"        "Nachfolgende Nullen ausgeben"
::msgcat::mcset $gPB(LANG) "MC(format,data,num,trail,Context)"      "Diese Option ermöglicht nachfolgenden Nullen den Zusatz zu reellen Nummern im N/C-Code."
::msgcat::mcset $gPB(LANG) "MC(format,data,text,Label)"             "Text"
::msgcat::mcset $gPB(LANG) "MC(format,data,text,Context)"           "Diese Option definiert den Datentyp eines Formats als \"Textzeichenfolge\"."
::msgcat::mcset $gPB(LANG) "MC(format,data,plus,Label)"             "Anführendes Pluszeichen (+) ausgeben"
::msgcat::mcset $gPB(LANG) "MC(format,data,plus,Context)"           "Mit dieser Option können Pluszeichen in N/C-Codes ausgegeben werden."
::msgcat::mcset $gPB(LANG) "MC(format,zero_msg)"                    "Eine Kopie des Nullformats kann nicht erzeugt werden"
::msgcat::mcset $gPB(LANG) "MC(format,zero_cut_msg)"                "Ein Nullformat kann nicht gelöscht werden"

::msgcat::mcset $gPB(LANG) "MC(format,data,dec_zero,msg)"           "Mindestens eine der Optionen des Dezimalpunkts, der anführenden bzw. nachfolgenden Nullen sollte geprüft werden."

::msgcat::mcset $gPB(LANG) "MC(format,data,no_digit,msg)"           "Die Anzahl der Stellen für Ganzzahl und Bruch sollte nicht beide Null betragen."

::msgcat::mcset $gPB(LANG) "MC(format,name_msg)"                    "Ungültiger Formatname.\n Einen anderen Namen festlegen."
::msgcat::mcset $gPB(LANG) "MC(format,error,title)"                 "Formatfehler"
::msgcat::mcset $gPB(LANG) "MC(format,error,msg)"                   "Dieses Format wurde in Adressen verwendet"

##---------------------
## Other Data Elements
##
::msgcat::mcset $gPB(LANG) "MC(other,tab,Label)"                    "Weitere Datenelemente"
::msgcat::mcset $gPB(LANG) "MC(other,Status)"                       "Parameter festlegen"

::msgcat::mcset $gPB(LANG) "MC(other,seq_num,Label)"                "Sequenznummer"
::msgcat::mcset $gPB(LANG) "MC(other,seq_num,Context)"              "Dieser Schalter ermöglicht die Aktivierung/Deaktivierung der Ausgabe von Sequenznummern im N/C-Code."
::msgcat::mcset $gPB(LANG) "MC(other,seq_num,start,Label)"          "Sequenznummer-Start"
::msgcat::mcset $gPB(LANG) "MC(other,seq_num,start,Context)"        "Sequenznummer-Start festlegen"
::msgcat::mcset $gPB(LANG) "MC(other,seq_num,inc,Label)"            "Sequenznummer-Inkrement"
::msgcat::mcset $gPB(LANG) "MC(other,seq_num,inc,Context)"          "Inkrement der Sequenznummern festlegen."
::msgcat::mcset $gPB(LANG) "MC(other,seq_num,freq,Label)"           "Sequenznummer-Frequenz"
::msgcat::mcset $gPB(LANG) "MC(other,seq_num,freq,Context)"         "Die im N/C-Code angezeigte Frequenz der Sequenznummern festlegen."
::msgcat::mcset $gPB(LANG) "MC(other,seq_num,max,Label)"            "Sequenznummer-Maximum"
::msgcat::mcset $gPB(LANG) "MC(other,seq_num,max,Context)"          "Max. Wert der Sequenznummern festlegen."

::msgcat::mcset $gPB(LANG) "MC(other,chars,Label)"                  "Sonderzeichen"
::msgcat::mcset $gPB(LANG) "MC(other,chars,word_sep,Label)"         "Leerzeichen"
::msgcat::mcset $gPB(LANG) "MC(other,chars,word_sep,Context)"       "Ein als Leerzeichen zu verwendendes Leerzeichen festlegen."
::msgcat::mcset $gPB(LANG) "MC(other,chars,decimal_pt,Label)"       "Dezimalpunkt"
::msgcat::mcset $gPB(LANG) "MC(other,chars,decimal_pt,Context)"     "Ein als Dezimalpunkt zu verwendendes Zeichen festlegen."
::msgcat::mcset $gPB(LANG) "MC(other,chars,end_of_block,Label)"     "Blockende"
::msgcat::mcset $gPB(LANG) "MC(other,chars,end_of_block,Context)"   "Ein als Blockende zu verwendendes Zeichen festlegen."
::msgcat::mcset $gPB(LANG) "MC(other,chars,comment_start,Label)"    "Meldungsanfang"
::msgcat::mcset $gPB(LANG) "MC(other,chars,comment_start,Context)"  "Zeichen als Anfang einer Bedienermeldungszeile festlegen."
::msgcat::mcset $gPB(LANG) "MC(other,chars,comment_end,Label)"      "Meldungsende"
::msgcat::mcset $gPB(LANG) "MC(other,chars,comment_end,Context)"    "Zeichen als Ende einer Bedienermeldungszeile festlegen."

::msgcat::mcset $gPB(LANG) "MC(other,opskip,Label)"                 "OPSKIP"
::msgcat::mcset $gPB(LANG) "MC(other,opskip,leader,Label)"          "Bezugslinie"
::msgcat::mcset $gPB(LANG) "MC(other,opskip,leader,Context)"        "OPSKIP-Bezugslinie"

::msgcat::mcset $gPB(LANG) "MC(other,gm_codes,Label)"               "G- & M-Codeausgabe pro Block"
::msgcat::mcset $gPB(LANG) "MC(other,g_codes,Label)"                "Anzahl von G-Codes pro Block"
::msgcat::mcset $gPB(LANG) "MC(other,g_codes,Context)"              "Dieser Schalter ermöglicht die Aktivierung/Deaktivierung der Kontrolle der Anzahl von G-Codes pro N/C-Ausgabeblock."
::msgcat::mcset $gPB(LANG) "MC(other,g_codes,num,Label)"            "Anzahl von G-Codes"
::msgcat::mcset $gPB(LANG) "MC(other,g_codes,num,Context)"          "Anzahl der G-Codes pro N/C-Ausgabeblock festlegen."
::msgcat::mcset $gPB(LANG) "MC(other,m_codes,Label)"                "Anzahl von M-Codes"
::msgcat::mcset $gPB(LANG) "MC(other,m_codes,Context)"              "Dieser Schalter ermöglicht die Aktivierung/Deaktivierung der Kontrolle der Anzahl von M-Codes pro N/C-Ausgabeblock."
::msgcat::mcset $gPB(LANG) "MC(other,m_codes,num,Label)"            "Anzahl von M-Codes pro Block"
::msgcat::mcset $gPB(LANG) "MC(other,m_codes,num,Context)"          "Anzahl der M-Codes pro N/C-Ausgabeblock festlegen."

::msgcat::mcset $gPB(LANG) "MC(other,opt_none,Label)"               "Kein"
::msgcat::mcset $gPB(LANG) "MC(other,opt_space,Label)"              "Raum"
::msgcat::mcset $gPB(LANG) "MC(other,opt_dec,Label)"                "Dezimal (.)"
::msgcat::mcset $gPB(LANG) "MC(other,opt_comma,Label)"              "Komma (,)"
::msgcat::mcset $gPB(LANG) "MC(other,opt_semi,Label)"               "Strichpunkt (;)"
::msgcat::mcset $gPB(LANG) "MC(other,opt_colon,Label)"              "Doppelpunkt (:)"
::msgcat::mcset $gPB(LANG) "MC(other,opt_text,Label)"               "Textzeichenfolge"
::msgcat::mcset $gPB(LANG) "MC(other,opt_left,Label)"               "Linke Klammer ("
::msgcat::mcset $gPB(LANG) "MC(other,opt_right,Label)"              "Rechte Klammer )"
::msgcat::mcset $gPB(LANG) "MC(other,opt_pound,Label)"              "Raute-Zeichen (\#)"
::msgcat::mcset $gPB(LANG) "MC(other,opt_aster,Label)"              "Sternchen (*)"
::msgcat::mcset $gPB(LANG) "MC(other,opt_slash,Label)"              "Schrägstrich (/)"
::msgcat::mcset $gPB(LANG) "MC(other,opt_new_line,Label)"           "Neue Zeile (\\012)"

# UDE Inclusion
::msgcat::mcset $gPB(LANG) "MC(other,ude,Label)"                    "Benutzerdefinierte Ereignisse"
::msgcat::mcset $gPB(LANG) "MC(other,ude_include,Label)"            "Andere CDL-Datei einschließen"
::msgcat::mcset $gPB(LANG) "MC(other,ude_include,Context)"          "Mit dieser Option kann dieser Postprozessor eine Referenz in eine CDL-Datei der Definitionsdatei einschließen."

::msgcat::mcset $gPB(LANG) "MC(other,ude_file,Label)"               "CDL-Dateiname"
::msgcat::mcset $gPB(LANG) "MC(other,ude_file,Context)"             "Pfad - und Dateiname einer CDL-Datei, die in der Definitionsdatei dieses Postprozessors referenziert (Einschließen) werden sollen.  Der Pfadname muss mit einer UG-Umgebungsvariable (\\\$UGII) oder keiner beginnen.  Wenn kein Pfad festgelegt ist, wird \"UGII_CAM_FILE_SEARCH_PATH\" zur Dateilokalisierung bei UG/NX-Laufzeit verwendet."
::msgcat::mcset $gPB(LANG) "MC(other,ude_select,Label)"             "Name auswählen"
::msgcat::mcset $gPB(LANG) "MC(other,ude_select,Context)"           "Wählen Sie eine CDL-Datei aus, die in der Definitionsdatei dieses Postprozessors referenziert (einschließen) werden soll.  Standardmäßig wird dem ausgewählten Dateinamen \\\$\"UGII_CAM_USER_DEF_EVENT_DIR/\" vorangestellt.  Der Pfadname kann nach der Auswahl wie gewünscht bearbeitet werden."


#+++++++++++++++++
# Output Settings
#+++++++++++++++++
::msgcat::mcset $gPB(LANG) "MC(output,tab,Label)"                   "Ausgabeeinstellungen"
::msgcat::mcset $gPB(LANG) "MC(output,Status)"                      "Ausgabeparameter konfigurieren"

#++++++++++++++
# VNC Controls
#++++++++++++++
::msgcat::mcset $gPB(LANG) "MC(output,vnc,Label)"                   "Virtuelle N/C-Steuerung"
::msgcat::mcset $gPB(LANG) "MC(output,vnc,mode,std,Label)"          "Standalone"
::msgcat::mcset $gPB(LANG) "MC(output,vnc,mode,sub,Label)"          "Untergeordnet"
::msgcat::mcset $gPB(LANG) "MC(output,vnc,status,Label)"            "Wählen Sie eine VNC-Datei aus."
::msgcat::mcset $gPB(LANG) "MC(output,vnc,mis_match,Label)"         "Die ausgewählte Datei stimmt nicht mit dem VNC-Standarddateinamen überein.\n Datei erneut auswählen?"
::msgcat::mcset $gPB(LANG) "MC(output,vnc,output,Label)"            "Virtuelle N/C-Steuerung (VNC) erzeugen"
::msgcat::mcset $gPB(LANG) "MC(output,vnc,output,Context)"          "Diese Option ermöglicht das Erzeugen einer virtuellen N/C-Steuerung (VNC).  Daher kann ein mit aktivierter VNC erzeugter Postprozessor für ISV verwendet werden"
::msgcat::mcset $gPB(LANG) "MC(output,vnc,main,Label)"              "Master-VNC"
::msgcat::mcset $gPB(LANG) "MC(output,vnc,main,Context)"            "Der Name des Master-VNC, für den das untergeordnete VNC als Ausgangspunkt verwendet wird.  Wahrscheinlich befindet sich dieser Postprozessor während der ISV-Laufzeit in dem Verzeichnis, in dem sich das untergeordnete VNC befindet; anderenfalls wird ein Postprozessor mit identischem Namen im Verzeichnis \\\$\"UGII_CAM_POST_DIR\" verwendet."


::msgcat::mcset $gPB(LANG) "MC(output,vnc,main,err_msg)"                 "Master-VNC muss für eine untergeordnete VNC festgelegt werden."
::msgcat::mcset $gPB(LANG) "MC(output,vnc,main,select_name,Label)"       "Name auswählen"
::msgcat::mcset $gPB(LANG) "MC(output,vnc,main,select_name,Context)"     "Wählen Sie den Namen eines VNC aus, für das das untergeordnete VNC als Ausgangspunkt verwendet werden soll.  Wahrscheinlich befindet sich dieser Postprozessor während der ISV-Laufzeit in dem Verzeichnis, in dem sich das untergeordnete VNC befindet; anderenfalls wird ein Postprozessor mit identischem Namen im Verzeichnis \\\$\"UGII_CAM_POST_DIR\" verwendet."

::msgcat::mcset $gPB(LANG) "MC(output,vnc,mode,Label)"                   "Virtueller N/C-Steuerungsmodus"
::msgcat::mcset $gPB(LANG) "MC(output,vnc,mode,Context)"                 "Eine virtuelle N/C-Steuerung kann entweder \"eigenständig\" oder der Master-VNC \"untergeordnet\" sein."
::msgcat::mcset $gPB(LANG) "MC(output,vnc,mode,std,Context)"             "Eine alleinstehende VNC ist \"eigenständig\"."
::msgcat::mcset $gPB(LANG) "MC(output,vnc,mode,sub,Context)"             "Ein untergeordnetes VNC ist stark abhängig von der Master-VNC.  Während der ISV-Laufzeit wird das untergeordnete VNC vom Master-VNC als Ausgangspunkt verwendet."
::msgcat::mcset $gPB(LANG) "MC(output,vnc,pb_ver,msg)"                   "Mit Post Builder erzeugte virtuelle N/C-Steuerung "
#++++++++++++++
# Listing File
#++++++++++++++
::msgcat::mcset $gPB(LANG) "MC(listing,tab,Label)"                  "Auflistungsdatei"
::msgcat::mcset $gPB(LANG) "MC(listing,Status)"                     "Parameter der Auflistungsdatei festlegen"

::msgcat::mcset $gPB(LANG) "MC(listing,gen,Label)"                  "Auflistungsdatei erzeugen"
::msgcat::mcset $gPB(LANG) "MC(listing,gen,Context)"                "Dieser Schalter ermöglicht die Aktivierung/Deaktivierung der Auflistungsdateiausgabe."

::msgcat::mcset $gPB(LANG) "MC(listing,Label)"                      "Auflistungsdatei-Elemente"
::msgcat::mcset $gPB(LANG) "MC(listing,parms,Label)"                "Komponenten"

::msgcat::mcset $gPB(LANG) "MC(listing,parms,x,Label)"              "X-Koordinate"
::msgcat::mcset $gPB(LANG) "MC(listing,parms,x,Context)"            "Dieser Schalter ermöglicht die Aktivierung/Deaktivierung der Ausgabe der X-Koordinate in die Auflistungsdatei."

::msgcat::mcset $gPB(LANG) "MC(listing,parms,y,Label)"              "Y-Koordinate"
::msgcat::mcset $gPB(LANG) "MC(listing,parms,y,Context)"            "Dieser Schalter ermöglicht die Aktivierung/Deaktivierung der Ausgabe der Y-Koordinate in die Auflistungsdatei."

::msgcat::mcset $gPB(LANG) "MC(listing,parms,z,Label)"              "Z-Koordinate"
::msgcat::mcset $gPB(LANG) "MC(listing,parms,z,Context)"            "Dieser Schalter ermöglicht die Aktivierung/Deaktivierung der Ausgabe der Z-Koordinate in die Auflistungsdatei."

::msgcat::mcset $gPB(LANG) "MC(listing,parms,4,Label)"              "4-Achsenwinkel"
::msgcat::mcset $gPB(LANG) "MC(listing,parms,4,Context)"            "Dieser Schalter ermöglicht die Aktivierung/Deaktivierung der Ausgabe des 4-Achsenwinkel in die Auflistungsdatei."

::msgcat::mcset $gPB(LANG) "MC(listing,parms,5,Label)"              "5-Achsenwinkel"
::msgcat::mcset $gPB(LANG) "MC(listing,parms,5,Context)"            "Dieser Schalter ermöglicht die Aktivierung/Deaktivierung der Ausgabe des 5-Achsenwinkel in die Auflistungsdatei."

::msgcat::mcset $gPB(LANG) "MC(listing,parms,feed,Label)"           "Vorschub"
::msgcat::mcset $gPB(LANG) "MC(listing,parms,feed,Context)"         "Dieser Schalter ermöglicht die Aktivierung/Deaktivierung der Vorschubausgabe in die Auflistungsdatei."

::msgcat::mcset $gPB(LANG) "MC(listing,parms,speed,Label)"          "Geschwindigkeit"
::msgcat::mcset $gPB(LANG) "MC(listing,parms,speed,Context)"        "Dieser Schalter ermöglicht die Aktivierung/Deaktivierung der Spindelausgabe in die Auflistungsdatei."

::msgcat::mcset $gPB(LANG) "MC(listing,extension,Label)"            "Auflistungsdatei-Erweiterung"
::msgcat::mcset $gPB(LANG) "MC(listing,extension,Context)"          "Auflistungsdatei-Erweiterung festlegen"

::msgcat::mcset $gPB(LANG) "MC(listing,nc_file,Label)"              "N/C-Ausgabedateierweiterung"
::msgcat::mcset $gPB(LANG) "MC(listing,nc_file,Context)"            "N/C-Ausgabedateierweiterung festlegen"

::msgcat::mcset $gPB(LANG) "MC(listing,header,Label)"               "Programmkopf"
::msgcat::mcset $gPB(LANG) "MC(listing,header,oper_list,Label)"     "Operationsliste"
::msgcat::mcset $gPB(LANG) "MC(listing,header,tool_list,Label)"     "Werkzeugliste"

::msgcat::mcset $gPB(LANG) "MC(listing,footer,Label)"               "Programm-Fußzeile"
::msgcat::mcset $gPB(LANG) "MC(listing,footer,cut_time,Label)"      "Gesamtbearbeitungszeit"

::msgcat::mcset $gPB(LANG) "MC(listing,format,Label)"                   "Seitenformat"
::msgcat::mcset $gPB(LANG) "MC(listing,format,print_header,Label)"      "Seitenkopfzeile drucken"
::msgcat::mcset $gPB(LANG) "MC(listing,format,print_header,Context)"    "Dieser Schalter ermöglicht die Aktivierung/Deaktivierung der Ausgabe der Seitenkopfzeile in die Auflistungsdatei."

::msgcat::mcset $gPB(LANG) "MC(listing,format,length,Label)"        "Seitenlänge (Zeilen)"
::msgcat::mcset $gPB(LANG) "MC(listing,format,length,Context)"      "Zeilenanzahl pro Seite für die Auflistungsdatei festlegen."
::msgcat::mcset $gPB(LANG) "MC(listing,format,width,Label)"         "Seitenbreite (Spalten)"
::msgcat::mcset $gPB(LANG) "MC(listing,format,width,Context)"       "Spaltenanzahl pro Seite für die Auflistungsdatei festlegen."

::msgcat::mcset $gPB(LANG) "MC(listing,other,tab,Label)"            "Weitere Optionen"
::msgcat::mcset $gPB(LANG) "MC(listing,output,Label)"               "Ausgabe-Steuerungselemente"

::msgcat::mcset $gPB(LANG) "MC(listing,output,warning,Label)"       "Ausgabe-Warnmeldung"
::msgcat::mcset $gPB(LANG) "MC(listing,output,warning,Context)"     "Dieser Schalter ermöglicht die Aktivierung/Deaktivierung der Ausgabe von Warnmeldungen bei dem Postprozessing."

::msgcat::mcset $gPB(LANG) "MC(listing,output,review,Label)"        "\"Review Tool\" aktivieren"
::msgcat::mcset $gPB(LANG) "MC(listing,output,review,Context)"      "Mit diesem Schalter kann das \"Review Tool\" während des Postprozessings aktiviert werden."

::msgcat::mcset $gPB(LANG) "MC(listing,output,group,Label)"         "Gruppenausgabe erzeugen"
::msgcat::mcset $gPB(LANG) "MC(listing,output,group,Context)"       "Mit diesem Schalter kann die Kontrolle der Gruppenausgabe während des Postprozessings aktiviert/deaktiviert werden."

::msgcat::mcset $gPB(LANG) "MC(listing,output,verbose,Label)"       "Verbose-Fehlermeldung anzeigen"
::msgcat::mcset $gPB(LANG) "MC(listing,output,verbose,Context)"     "Mit diesem Schalter können erweiterte Beschreibungen für die Fehlerbedingungen angezeigt werden. Die Geschwindigkeit des Postprozessings wird dadurch verringert."

::msgcat::mcset $gPB(LANG) "MC(listing,oper_info,Label)"            "Operationsinformation"
::msgcat::mcset $gPB(LANG) "MC(listing,oper_info,parms,Label)"      "Operationsparameter"
::msgcat::mcset $gPB(LANG) "MC(listing,oper_info,tool,Label)"       "Werkzeugparameter"
::msgcat::mcset $gPB(LANG) "MC(listing,oper_info,cut_time,,Label)"  "Bearbeitungszeit"


#<09-19-00 gsl>
::msgcat::mcset $gPB(LANG) "MC(listing,user_tcl,frame,Label)"       "Tcl-Ausgangsbenutzer"
::msgcat::mcset $gPB(LANG) "MC(listing,user_tcl,check,Label)"       "Tcl-Datei des Ausgangsbenutzers"
::msgcat::mcset $gPB(LANG) "MC(listing,user_tcl,check,Context)"     "Mit diesem Schalter können Sie Ihre Tcl-Datei als Ausgangspunkt verwenden. "
::msgcat::mcset $gPB(LANG) "MC(listing,user_tcl,name,Label)"        "Dateiname"
::msgcat::mcset $gPB(LANG) "MC(listing,user_tcl,name,Context)"      "Legen Sie den Namen einer Tcl-Datei fest, die für diesen Postprozessor als Ausgangspunkt verwendet werden soll."

#++++++++++++++++
# Output Preview
#++++++++++++++++
::msgcat::mcset $gPB(LANG) "MC(preview,tab,Label)"                  "Vorschau der PP-Dateien"
::msgcat::mcset $gPB(LANG) "MC(preview,new_code,Label)"             "Neuer Code"
::msgcat::mcset $gPB(LANG) "MC(preview,old_code,Label)"             "Alter Code"

##---------------------
## Event Handler
##
::msgcat::mcset $gPB(LANG) "MC(event_handler,tab,Label)"            "Ereignis-Handler"
::msgcat::mcset $gPB(LANG) "MC(event_handler,Status)"               "Ereignis auswählen, um den Vorgang anzuzeigen"

##---------------------
## Definition
##
::msgcat::mcset $gPB(LANG) "MC(definition,tab,Label)"               "Definitionen"
::msgcat::mcset $gPB(LANG) "MC(definition,Status)"                  "Element auswählen, um die Inhalte anzuzeigen"

#++++++++++++++
# Post Advisor
#++++++++++++++
::msgcat::mcset $gPB(LANG) "MC(advisor,tab,Label)"                  "PP-Assistent"
::msgcat::mcset $gPB(LANG) "MC(advisor,Status)"                     "PP-Assistent"

::msgcat::mcset $gPB(LANG) "MC(definition,word_txt,Label)"          "WORD_SEPARATOR"
::msgcat::mcset $gPB(LANG) "MC(definition,end_txt,Label)"           "END_OF_BLOCK"
::msgcat::mcset $gPB(LANG) "MC(definition,seq_txt,Label)"           "SEQUENCE_NUM"
::msgcat::mcset $gPB(LANG) "MC(definition,include,Label)"           "Einschließen"
::msgcat::mcset $gPB(LANG) "MC(definition,format_txt,Label)"        "FORMAT"
::msgcat::mcset $gPB(LANG) "MC(definition,addr_txt,Label)"          "WORT"
::msgcat::mcset $gPB(LANG) "MC(definition,block_txt,Label)"         "Block"
::msgcat::mcset $gPB(LANG) "MC(definition,comp_txt,Label)"          "Zusammengesetzter BLOCK"
::msgcat::mcset $gPB(LANG) "MC(definition,post_txt,Label)"          "PP-BLOCK"
::msgcat::mcset $gPB(LANG) "MC(definition,oper_txt,Label)"          "Dummy-Meldungs-BLOCK"

#+++++++++++++
# Balloon
#+++++++++++++
::msgcat::mcset $gPB(LANG) "MC(msg,odd)"                            "Ungerade Anzahl optionaler Argumente"
::msgcat::mcset $gPB(LANG) "MC(msg,wrong_list_1)"                   "Unbekannte Optionen"
::msgcat::mcset $gPB(LANG) "MC(msg,wrong_list_2)"                   ". Muss enthalten sein in:"

#+++++++++++++++++
# Event UI Labels
#+++++++++++++++++

### Program Start
::msgcat::mcset $gPB(LANG) "MC(event,start_prog,name)"              "Programmstart"

### Operation Start
::msgcat::mcset $gPB(LANG) "MC(event,opr_start,start_path,name)"    "Pfadanfang"
::msgcat::mcset $gPB(LANG) "MC(event,opr_start,from_move,name)"     "Von Bewegung"
::msgcat::mcset $gPB(LANG) "MC(event,opr_start,fst_tool,name)"      "Erstes Werkzeug"
::msgcat::mcset $gPB(LANG) "MC(event,opr_start,auto_tc,name)"       "Autom. Wkz-Wechsel"
::msgcat::mcset $gPB(LANG) "MC(event,opr_start,manual_tc,name)"     "Manueller Wkz-Wechsel"
::msgcat::mcset $gPB(LANG) "MC(event,opr_start,init_move,name)"     "Ausgangsbewegung"
::msgcat::mcset $gPB(LANG) "MC(event,opr_start,fst_move,name)"      "Erste Bewegung"
::msgcat::mcset $gPB(LANG) "MC(event,opr_start,appro_move,name)"    "Annäherungsbewegung"
::msgcat::mcset $gPB(LANG) "MC(event,opr_start,engage_move,name)"   "Anfahrbewegung"
::msgcat::mcset $gPB(LANG) "MC(event,opr_start,fst_cut,name)"       "1. Schnitt"
::msgcat::mcset $gPB(LANG) "MC(event,opr_start,fst_lin_move,name)"  "Erste lineare Verschiebung"
::msgcat::mcset $gPB(LANG) "MC(event,opr_start,start_pass,name)"    "Weganfang"
::msgcat::mcset $gPB(LANG) "MC(event,opr_start,cutcom_move,name)"   "Wkz-Kompensationsbewegung"
::msgcat::mcset $gPB(LANG) "MC(event,opr_start,lead_move,name)"     "Zuführbewegung"

### Operation End
::msgcat::mcset $gPB(LANG) "MC(event,opr_end,ret_move,name)"        "Abfahrbewegung"
::msgcat::mcset $gPB(LANG) "MC(event,opr_end,rtn_move,name)"        "Rückfahrbewegung"
::msgcat::mcset $gPB(LANG) "MC(event,opr_end,goh_move,name)"        "Ausgangspositionsbewegung"
::msgcat::mcset $gPB(LANG) "MC(event,opr_end,end_path,name)"        "Pfadende"
::msgcat::mcset $gPB(LANG) "MC(event,opr_end,lead_move,name)"       "Rückzugbewegung"
::msgcat::mcset $gPB(LANG) "MC(event,opr_end,end_pass,name)"        "Wegende"

### Program End
::msgcat::mcset $gPB(LANG) "MC(event,end_prog,name)"                "rogrammende"


### Tool Change
::msgcat::mcset $gPB(LANG) "MC(event,tool_change,name)"             "Werkzeugwechsel"
::msgcat::mcset $gPB(LANG) "MC(event,tool_change,m_code)"           "M-Code"
::msgcat::mcset $gPB(LANG) "MC(event,tool_change,m_code,tl_chng)"   "Werkzeugwechsel"
::msgcat::mcset $gPB(LANG) "MC(event,tool_change,m_code,pt)"        "Primärer Revolverkopf"
::msgcat::mcset $gPB(LANG) "MC(event,tool_change,m_code,st)"        "Sekundärer Revolverkopf"
::msgcat::mcset $gPB(LANG) "MC(event,tool_change,t_code)"           "T-Code"
::msgcat::mcset $gPB(LANG) "MC(event,tool_change,t_code,conf)"      "Konfigurieren"
::msgcat::mcset $gPB(LANG) "MC(event,tool_change,t_code,pt_idx)"    "Primärer Revolverindex"
::msgcat::mcset $gPB(LANG) "MC(event,tool_change,t_code,st_idx)"    "Sekundärer Revolverindex"
::msgcat::mcset $gPB(LANG) "MC(event,tool_change,tool_num)"         "Wkz-Nummer"
::msgcat::mcset $gPB(LANG) "MC(event,tool_change,tool_num,min)"     "Minimum"
::msgcat::mcset $gPB(LANG) "MC(event,tool_change,tool_num,max)"     "Maximum"
::msgcat::mcset $gPB(LANG) "MC(event,tool_change,time)"             "Zeit (Sek.)"
::msgcat::mcset $gPB(LANG) "MC(event,tool_change,time,tl_chng)"     "Werkzeugwechsel"
::msgcat::mcset $gPB(LANG) "MC(event,tool_change,retract)"          "Abfahren"
::msgcat::mcset $gPB(LANG) "MC(event,tool_change,retract_z)"        "Rückzug zu Z von"

### Length Compensation
::msgcat::mcset $gPB(LANG) "MC(event,length_compn,name)"            "Längenkompensation"
::msgcat::mcset $gPB(LANG) "MC(event,length_compn,g_code)"          "G-Code"
::msgcat::mcset $gPB(LANG) "MC(event,length_compn,g_code,len_adj)"  "Wkz-Längenanpassung"
::msgcat::mcset $gPB(LANG) "MC(event,length_compn,t_code)"          "T-Code"
::msgcat::mcset $gPB(LANG) "MC(event,length_compn,t_code,conf)"     "Konfigurieren"
::msgcat::mcset $gPB(LANG) "MC(event,length_compn,len_off)"         "Offset-Längenregister"
::msgcat::mcset $gPB(LANG) "MC(event,length_compn,len_off,min)"     "Minimum"
::msgcat::mcset $gPB(LANG) "MC(event,length_compn,len_off,max)"     "Maximum"

### Set Modes
::msgcat::mcset $gPB(LANG) "MC(event,set_modes,name)"               "Modi einstellen"
::msgcat::mcset $gPB(LANG) "MC(event,set_modes,out_mode)"           "Ausgabemodus"
::msgcat::mcset $gPB(LANG) "MC(event,set_modes,g_code)"             "G-Code"
::msgcat::mcset $gPB(LANG) "MC(event,set_modes,g_code,absolute)"    "Absolut"
::msgcat::mcset $gPB(LANG) "MC(event,set_modes,g_code,incremental)" "Inkremental"
::msgcat::mcset $gPB(LANG) "MC(event,set_modes,rotary_axis)"        "Rotationsachse kann inkremental sein"

### Spindle RPM
::msgcat::mcset $gPB(LANG) "MC(event,spindle_rpm,name)"                     "U/min der Spindel"
::msgcat::mcset $gPB(LANG) "MC(event,spindle_rpm,dir_m_code)"               "Spindelrichtung - M-Codes"
::msgcat::mcset $gPB(LANG) "MC(event,spindle_rpm,dir_m_code,cw)"            "Im Uhrzeigersinn (CW)"
::msgcat::mcset $gPB(LANG) "MC(event,spindle_rpm,dir_m_code,ccw)"           "Geg. Uhrzeigersinn (CCW)"
::msgcat::mcset $gPB(LANG) "MC(event,spindle_rpm,range_control)"            "Spindelbereichssteuerung"
::msgcat::mcset $gPB(LANG) "MC(event,spindle_rpm,range_control,dwell_time)" "Bereichswechselhaltezeit (Sek.)"
::msgcat::mcset $gPB(LANG) "MC(event,spindle_rpm,range_control,range_code)" "Bereichscode festlegen"

### Spindle CSS
::msgcat::mcset $gPB(LANG) "MC(event,spindle_css,name)"             "CSS-Spindel"
::msgcat::mcset $gPB(LANG) "MC(event,spindle_css,g_code)"           "G-Spindelcode"
::msgcat::mcset $gPB(LANG) "MC(event,spindle_css,g_code,const)"     "Konstanter Flächencode"
::msgcat::mcset $gPB(LANG) "MC(event,spindle_css,g_code,max)"       "Maximaler RPM-Code"
::msgcat::mcset $gPB(LANG) "MC(event,spindle_css,g_code,sfm)"       "Code für Abbruch von SFM"
::msgcat::mcset $gPB(LANG) "MC(event,spindle_css,max)"              "Max. RPM bei CSS"
::msgcat::mcset $gPB(LANG) "MC(event,spindle_css,sfm)"              "Immer IPR-Modus für SFM festlegen"

### Spindle Off
::msgcat::mcset $gPB(LANG) "MC(event,spindle_off,name)"             "Spindel deaktiviert"
::msgcat::mcset $gPB(LANG) "MC(event,spindle_off,dir_m_code)"       "Spindelrichtung - M-Code"
::msgcat::mcset $gPB(LANG) "MC(event,spindle_off,dir_m_code,off)"   "Aus"

### Coolant On
::msgcat::mcset $gPB(LANG) "MC(event,coolant_on,name)"              "Kühlmittel ein"
::msgcat::mcset $gPB(LANG) "MC(event,coolant_on,m_code)"            "M-Code"
::msgcat::mcset $gPB(LANG) "MC(event,coolant_on,m_code,on)"         "Ein"
::msgcat::mcset $gPB(LANG) "MC(event,coolant_on,m_code,flood)"      "Fluten"
::msgcat::mcset $gPB(LANG) "MC(event,coolant_on,m_code,mist)"       "Nebel"
::msgcat::mcset $gPB(LANG) "MC(event,coolant_on,m_code,thru)"       "Durch"
::msgcat::mcset $gPB(LANG) "MC(event,coolant_on,m_code,tap)"        "Gewindebohrer"

### Coolant Off
::msgcat::mcset $gPB(LANG) "MC(event,coolant_off,name)"             "Kühlmittel aus"
::msgcat::mcset $gPB(LANG) "MC(event,coolant_off,m_code)"           "M-Code"
::msgcat::mcset $gPB(LANG) "MC(event,coolant_off,m_code,off)"       "Aus"

### Inch Metric Mode
::msgcat::mcset $gPB(LANG) "MC(event,inch_metric_mode,name)"            "Zoll - Metrischer Modus"
::msgcat::mcset $gPB(LANG) "MC(event,inch_metric_mode,g_code)"          "G-Code"
::msgcat::mcset $gPB(LANG) "MC(event,inch_metric_mode,g_code,english)"  "Englisch (Zoll)"
::msgcat::mcset $gPB(LANG) "MC(event,inch_metric_mode,g_code,metric)"   "Metrisch (Millimeter)"

### Feedrates
::msgcat::mcset $gPB(LANG) "MC(event,feedrates,name)"               "Vorschübe"
::msgcat::mcset $gPB(LANG) "MC(event,feedrates,ipm_mode)"           "IPM-Modus"
::msgcat::mcset $gPB(LANG) "MC(event,feedrates,ipr_mode)"           "IPR-Modus"
::msgcat::mcset $gPB(LANG) "MC(event,feedrates,dpm_mode)"           "DPM-Modus"
::msgcat::mcset $gPB(LANG) "MC(event,feedrates,mmpm_mode)"          "MMPM-Modus"
::msgcat::mcset $gPB(LANG) "MC(event,feedrates,mmpr_mode)"          "MMPR-Modus"
::msgcat::mcset $gPB(LANG) "MC(event,feedrates,frn_mode)"           "FRN-Modus"
::msgcat::mcset $gPB(LANG) "MC(event,feedrates,g_code)"             "G-Code"
::msgcat::mcset $gPB(LANG) "MC(event,feedrates,format)"             "Format"
::msgcat::mcset $gPB(LANG) "MC(event,feedrates,max)"                "Maximum"
::msgcat::mcset $gPB(LANG) "MC(event,feedrates,min)"                "Minimum"
::msgcat::mcset $gPB(LANG) "MC(event,feedrates,mode,label)"         "Vorschubmodi"
::msgcat::mcset $gPB(LANG) "MC(event,feedrates,mode,lin)"           "Nur linear"
::msgcat::mcset $gPB(LANG) "MC(event,feedrates,mode,rot)"           "Nur drehbar"
::msgcat::mcset $gPB(LANG) "MC(event,feedrates,mode,lin_rot)"       "Linear und drehbar"
::msgcat::mcset $gPB(LANG) "MC(event,feedrates,mode,rap_lin)"       "Nur Linear-Eilgang"
::msgcat::mcset $gPB(LANG) "MC(event,feedrates,mode,rap_rot)"       "Nur Dreh-Eilgang"
::msgcat::mcset $gPB(LANG) "MC(event,feedrates,mode,rap_lin_rot)"   "Linear- und Dreh-Eilgang"
::msgcat::mcset $gPB(LANG) "MC(event,feedrates,cycle_mode)"         "Zyklus-Vorschubmodus"
::msgcat::mcset $gPB(LANG) "MC(event,feedrates,cycle)"              "Zyklus"

### Cutcom On
::msgcat::mcset $gPB(LANG) "MC(event,cutcom_on,name)"               "Wkz-Kompensation aktiviert"
::msgcat::mcset $gPB(LANG) "MC(event,cutcom_on,g_code)"             "G-Code"
::msgcat::mcset $gPB(LANG) "MC(event,cutcom_on,left)"               "Links"
::msgcat::mcset $gPB(LANG) "MC(event,cutcom_on,right)"              "Rechts"
::msgcat::mcset $gPB(LANG) "MC(event,cutcom_on,app_planes)"         "Anwendbare Ebenen"
::msgcat::mcset $gPB(LANG) "MC(event,cutcom_on,edit_planes)"        "Ebenencodes bearbeiten"
::msgcat::mcset $gPB(LANG) "MC(event,cutcom_on,reg)"                "Wkz-Komp.-Register"
::msgcat::mcset $gPB(LANG) "MC(event,cutcom_on,min)"                "Minimum"
::msgcat::mcset $gPB(LANG) "MC(event,cutcom_on,max)"                "Maximum"
::msgcat::mcset $gPB(LANG) "MC(event,cutcom_on,bef)"                "Wkz-Kompensation vor Wechsel deaktivieren"

### Cutcom Off
::msgcat::mcset $gPB(LANG) "MC(event,cutcom_off,name)"              "Wkz-Kompensation deaktiviert"
::msgcat::mcset $gPB(LANG) "MC(event,cutcom_off,g_code)"            "G-Code"
::msgcat::mcset $gPB(LANG) "MC(event,cutcom_off,off)"               "Aus"

### Delay
::msgcat::mcset $gPB(LANG) "MC(event,delay,name)"                   "Verzögerung"
::msgcat::mcset $gPB(LANG) "MC(event,delay,seconds)"                "Sekunden"
::msgcat::mcset $gPB(LANG) "MC(event,delay,seconds,g_code)"         "G-Code"
::msgcat::mcset $gPB(LANG) "MC(event,delay,seconds,format)"         "Format"
::msgcat::mcset $gPB(LANG) "MC(event,delay,out_mode)"               "Ausgabemodus"
::msgcat::mcset $gPB(LANG) "MC(event,delay,out_mode,sec)"           "Nur Sekunden"
::msgcat::mcset $gPB(LANG) "MC(event,delay,out_mode,rev)"           "Nur Umdrehungen"
::msgcat::mcset $gPB(LANG) "MC(event,delay,out_mode,feed)"          "Abhängig von Vorschub"
::msgcat::mcset $gPB(LANG) "MC(event,delay,out_mode,ivs)"           "Umkehrzeit"
::msgcat::mcset $gPB(LANG) "MC(event,delay,revolution)"             "Umdrehungen"
::msgcat::mcset $gPB(LANG) "MC(event,delay,revolution,g_code)"      "G-Code"
::msgcat::mcset $gPB(LANG) "MC(event,delay,revolution,format)"      "Format"

### Option Stop
::msgcat::mcset $gPB(LANG) "MC(event,opstop,name)"                  "Opstop"

### Auxfun
::msgcat::mcset $gPB(LANG) "MC(event,auxfun,name)"                  "Auxfun"

### Prefun
::msgcat::mcset $gPB(LANG) "MC(event,prefun,name)"                  "Prefun"

### Load Tool
::msgcat::mcset $gPB(LANG) "MC(event,loadtool,name)"                "Werkzeug laden"

### Stop
::msgcat::mcset $gPB(LANG) "MC(event,stop,name)"                    "Beenden"

### Tool Preselect
::msgcat::mcset $gPB(LANG) "MC(event,toolpreselect,name)"           "Wkz-Vorauswahl"

### Thread Wire
::msgcat::mcset $gPB(LANG) "MC(event,threadwire,name)"              "Gewindedraht"

### Cut Wire
::msgcat::mcset $gPB(LANG) "MC(event,cutwire,name)"                 "Drahtkorn"

### Wire Guides
::msgcat::mcset $gPB(LANG) "MC(event,wireguides,name)"              "Drahtführung"

### Linear Move
::msgcat::mcset $gPB(LANG) "MC(event,linear,name)"                  "Lineare Verschiebung"
::msgcat::mcset $gPB(LANG) "MC(event,linear,g_code)"                "G-Code"
::msgcat::mcset $gPB(LANG) "MC(event,linear,motion)"                "Lineare Bewegung"
::msgcat::mcset $gPB(LANG) "MC(event,linear,assume)"                "Angenommener Eilmodus bei max. Querungsvorschub"

### Circular Move
::msgcat::mcset $gPB(LANG) "MC(event,circular,name)"                "Kreisförmige Verschiebung"
::msgcat::mcset $gPB(LANG) "MC(event,circular,g_code)"              "Bewegung - G-Code"
::msgcat::mcset $gPB(LANG) "MC(event,circular,clockwise)"           "Im Uhrzeigersinn(CLW)"
::msgcat::mcset $gPB(LANG) "MC(event,circular,counter-clock)"       "Geg. Uhrzeigersinn(CCLW)"
::msgcat::mcset $gPB(LANG) "MC(event,circular,record)"              "Kreisspurverfahren"
::msgcat::mcset $gPB(LANG) "MC(event,circular,full_circle)"         "Vollkreis"
::msgcat::mcset $gPB(LANG) "MC(event,circular,quadrant)"            "Quadrant"
::msgcat::mcset $gPB(LANG) "MC(event,circular,ijk_def)"             "IJK-Definition"
::msgcat::mcset $gPB(LANG) "MC(event,circular,ij_def)"              "IJ-Definition"
::msgcat::mcset $gPB(LANG) "MC(event,circular,ik_def)"              "IK-Definition"
::msgcat::mcset $gPB(LANG) "MC(event,circular,planes)"              "Anwendbare Ebenen"
::msgcat::mcset $gPB(LANG) "MC(event,circular,edit_planes)"         "Ebenencodes bearbeiten"
::msgcat::mcset $gPB(LANG) "MC(event,circular,radius)"              "Radius"
::msgcat::mcset $gPB(LANG) "MC(event,circular,min)"                 "Minimum"
::msgcat::mcset $gPB(LANG) "MC(event,circular,max)"                 "Maximum"
::msgcat::mcset $gPB(LANG) "MC(event,circular,arc_len)"             "Minimale Bogenlänge"

### Rapid Move
::msgcat::mcset $gPB(LANG) "MC(event,rapid,name)"                   "Eilgangbewegung"
::msgcat::mcset $gPB(LANG) "MC(event,rapid,g_code)"                 "G-Code"
::msgcat::mcset $gPB(LANG) "MC(event,rapid,motion)"                 "Schnelle Bewegung"
::msgcat::mcset $gPB(LANG) "MC(event,rapid,plane_change)"           "Arbeitsebenen-Wechsel"

### Lathe Thread
::msgcat::mcset $gPB(LANG) "MC(event,lathe,name)"                   "Gewindeschneiden"
::msgcat::mcset $gPB(LANG) "MC(event,lathe,g_code)"                 "Gewinde - G-Code"
::msgcat::mcset $gPB(LANG) "MC(event,lathe,cons)"                   "Konstante"
::msgcat::mcset $gPB(LANG) "MC(event,lathe,incr)"                   "Inkremental"
::msgcat::mcset $gPB(LANG) "MC(event,lathe,decr)"                   "Dekremental"

### Cycle
::msgcat::mcset $gPB(LANG) "MC(event,cycle,g_code)"                 "G-Code & Anpassung"
::msgcat::mcset $gPB(LANG) "MC(event,cycle,customize,Label)"        "Anpassen"
::msgcat::mcset $gPB(LANG) "MC(event,cycle,customize,Context)"      "Mit diesem Schalter kann ein Zyklus angepasst werden. \n\nStandardmäßig wird die Basiskonstruktion jedes Zyklus von den Einstellungen der gemeinsam verwendeten Parameter definiert. Diese gemeinsamen Elemente in jedem Zyklus dürfen nicht geändert werden. \n\nMit der Aktivierung dieses Schalters erhalten Sie vollständige Kontrolle über die Konfiguration eines Zyklus.  Vorgenommene Änderungen an den gemeinsam verwendeten Parametern beeinträchtigen den angepassten Zyklus nicht mehr."
::msgcat::mcset $gPB(LANG) "MC(event,cycle,start,Label)"            "Zyklusanfang"
::msgcat::mcset $gPB(LANG) "MC(event,cycle,start,Context)"          "Diese Option kann für Maschinen-Wkz, die Zyklen mit Hilfe eines Zyklus-Startblocks (G79...) nachdem der Zyklus definiert wurde (G81...), aktiviert werden."
::msgcat::mcset $gPB(LANG) "MC(event,cycle,start,text)"             "Zyklus-Startblock für Zyklusausführung verwenden"
::msgcat::mcset $gPB(LANG) "MC(event,cycle,rapid_to)"               "Eilgang - Zu"
::msgcat::mcset $gPB(LANG) "MC(event,cycle,retract_to)"             "Rückzug - Zu"
::msgcat::mcset $gPB(LANG) "MC(event,cycle,plane_control)"          "Zyklus-Ebenensteuerung"
::msgcat::mcset $gPB(LANG) "MC(event,cycle,com_param,name)"         "Gemeinsame Parameter"
::msgcat::mcset $gPB(LANG) "MC(event,cycle,cycle_off,name)"         "Zyklus deaktiviert"
::msgcat::mcset $gPB(LANG) "MC(event,cycle,plane_chng,name)"        "Zyklus-Ebenenwechsel"
::msgcat::mcset $gPB(LANG) "MC(event,cycle,drill,name)"             "Bohrer"
::msgcat::mcset $gPB(LANG) "MC(event,cycle,drill_dwell,name)"       "Bohrhaltezeit"
::msgcat::mcset $gPB(LANG) "MC(event,cycle,drill_text,name)"        "Bohrer, Eingabe"
::msgcat::mcset $gPB(LANG) "MC(event,cycle,drill_csink,name)"       "Bohrer, Kegelsenkung"
::msgcat::mcset $gPB(LANG) "MC(event,cycle,drill_deep,name)"        "Bohrer, tief"
::msgcat::mcset $gPB(LANG) "MC(event,cycle,drill_brk_chip,name)"    "Bohrer, Spanbrechen"
::msgcat::mcset $gPB(LANG) "MC(event,cycle,tap,name)"               "Gewindebohrer"
::msgcat::mcset $gPB(LANG) "MC(event,cycle,bore,name)"              "Aufbohrwerkzeug"
::msgcat::mcset $gPB(LANG) "MC(event,cycle,bore_dwell,name)"        "Bohrhaltezeit"
::msgcat::mcset $gPB(LANG) "MC(event,cycle,bore_drag,name)"         "Bohrung, ziehen"
::msgcat::mcset $gPB(LANG) "MC(event,cycle,bore_no_drag,name)"      "Bohrung, nicht ziehen"
::msgcat::mcset $gPB(LANG) "MC(event,cycle,bore_back,name)"         "Rückbohrung"
::msgcat::mcset $gPB(LANG) "MC(event,cycle,bore_manual,name)"       "Bohrung, manuell"
::msgcat::mcset $gPB(LANG) "MC(event,cycle,bore_manual_dwell,name)" "Bohrhaltezeit, manuell"
::msgcat::mcset $gPB(LANG) "MC(event,cycle,peck_drill,name)"        "Spanbohren"
::msgcat::mcset $gPB(LANG) "MC(event,cycle,break_chip,name)"        "Span brechen"
::msgcat::mcset $gPB(LANG) "MC(event,cycle,drill_dwell_sf,name)"    "Bohrerhaltezeit (Punktfläche)"
::msgcat::mcset $gPB(LANG) "MC(event,cycle,drill_deep_peck,name)"   "Bohrer, tief (Spanbohren)"
::msgcat::mcset $gPB(LANG) "MC(event,cycle,bore_ream,name)"         "Bohrung (Reibahle)"
::msgcat::mcset $gPB(LANG) "MC(event,cycle,bore_no-drag,name)"      "Bohrung, nicht ziehen"

##------------
## G Code
##
::msgcat::mcset $gPB(LANG) "MC(g_code,rapid,name)"                  "Schnelle Bewegung"
::msgcat::mcset $gPB(LANG) "MC(g_code,linear,name)"                 "Lineare Bewegung"
::msgcat::mcset $gPB(LANG) "MC(g_code,circular_clw,name)"           "Kreisförmige Interpolation CLW"
::msgcat::mcset $gPB(LANG) "MC(g_code,circular_cclw,name)"          "Kreisförmige Interpolation CCLW"
::msgcat::mcset $gPB(LANG) "MC(g_code,delay_sec,name)"              "Verzögerung (Sek.)"
::msgcat::mcset $gPB(LANG) "MC(g_code,delay_rev,name)"              "Verzögerung (Umdr.)"
::msgcat::mcset $gPB(LANG) "MC(g_code,pln_xy,name)"                 "XY-Ebene"
::msgcat::mcset $gPB(LANG) "MC(g_code,pln_zx,name)"                 "ZX-Ebene"
::msgcat::mcset $gPB(LANG) "MC(g_code,pln_yz,name)"                 "YZ-Ebene"
::msgcat::mcset $gPB(LANG) "MC(g_code,cutcom_off,name)"             "Wkz-Kompensation deaktiviert"
::msgcat::mcset $gPB(LANG) "MC(g_code,cutcom_left,name)"            "Wkz-Kompensation links"
::msgcat::mcset $gPB(LANG) "MC(g_code,cutcom_right,name)"           "Wkz-Kompensation rechts"
::msgcat::mcset $gPB(LANG) "MC(g_code,length_plus,name)"            "Wkz-Längenanpassung plus"
::msgcat::mcset $gPB(LANG) "MC(g_code,length_minus,name)"           "Wkz-Längenanpassung minus"
::msgcat::mcset $gPB(LANG) "MC(g_code,length_off,name)"             "Wkz-Längenanpassung deaktiviert"
::msgcat::mcset $gPB(LANG) "MC(g_code,inch,name)"                   "Zoll-Modus"
::msgcat::mcset $gPB(LANG) "MC(g_code,metric,name)"                 "Metrischer Modus"
::msgcat::mcset $gPB(LANG) "MC(g_code,cycle_start,name)"            "Zyklus-Anfangscode"
::msgcat::mcset $gPB(LANG) "MC(g_code,cycle_off,name)"              "Zyklus deaktiviert"
::msgcat::mcset $gPB(LANG) "MC(g_code,cycle_drill,name)"            "Zyklusbohrer"
::msgcat::mcset $gPB(LANG) "MC(g_code,cycle_drill_dwell,name)"      "Zyklusbohrerhaltezeit"
::msgcat::mcset $gPB(LANG) "MC(g_code,cycle_drill_deep,name)"       "Zyklusbohrer, tief"
::msgcat::mcset $gPB(LANG) "MC(g_code,cycle_drill_bc,name)"         "Zyklusbohrer, Spanbrechen"
::msgcat::mcset $gPB(LANG) "MC(g_code,tap,name)"                    "Zyklus-Gewindebohrer"
::msgcat::mcset $gPB(LANG) "MC(g_code,bore,name)"                   "Zyklusbohrung"
::msgcat::mcset $gPB(LANG) "MC(g_code,bore_drag,name)"              "Zyklusbohrung, ziehen"
::msgcat::mcset $gPB(LANG) "MC(g_code,bore_no_drag,name)"           "Zyklusbohrung, nicht ziehen"
::msgcat::mcset $gPB(LANG) "MC(g_code,bore_dwell,name)"             "Zyklusbohrhaltezeit"
::msgcat::mcset $gPB(LANG) "MC(g_code,bore_manual,name)"            "Zyklusbohrung, manuell"
::msgcat::mcset $gPB(LANG) "MC(g_code,bore_back,name)"              "Zyklusrückbohrung"
::msgcat::mcset $gPB(LANG) "MC(g_code,bore_manual_dwell,name)"      "Zyklusbohrhaltezeit, manuell"
::msgcat::mcset $gPB(LANG) "MC(g_code,abs,name)"                    "Absoluter Modus"
::msgcat::mcset $gPB(LANG) "MC(g_code,inc,name)"                    "Inkrementaler Modus"
::msgcat::mcset $gPB(LANG) "MC(g_code,cycle_retract_auto,name)"     "Zyklus-Rückzug (AUTOMATISCH)"
::msgcat::mcset $gPB(LANG) "MC(g_code,cycle_retract_manual,name)"   "Zyklus-Rückzug (MANUELL)"
::msgcat::mcset $gPB(LANG) "MC(g_code,reset,name)"                  "Zurücksetzen"
::msgcat::mcset $gPB(LANG) "MC(g_code,fr_ipm,name)"                 "IPM-Vorschubmodus"
::msgcat::mcset $gPB(LANG) "MC(g_code,fr_ipr,name)"                 "IPR-Vorschubmodus"
::msgcat::mcset $gPB(LANG) "MC(g_code,fr_frn,name)"                 "FRN-Vorschubmodus"
::msgcat::mcset $gPB(LANG) "MC(g_code,spindle_css,name)"            "CSS-Spindel"
::msgcat::mcset $gPB(LANG) "MC(g_code,spindle_rpm,name)"            "U/min der Spindel"
::msgcat::mcset $gPB(LANG) "MC(g_code,ret_home,name)"               "Zurück zu Ausgangsposition"
::msgcat::mcset $gPB(LANG) "MC(g_code,cons_thread,name)"            "Konstantes Gewinde"
::msgcat::mcset $gPB(LANG) "MC(g_code,incr_thread,name)"            "Inkrementales Gewinde"
::msgcat::mcset $gPB(LANG) "MC(g_code,decr_thread,name)"            "Dekrementales Gewinde"
::msgcat::mcset $gPB(LANG) "MC(g_code,feedmode_in,pm)"              "IPM-Vorschubmodus"
::msgcat::mcset $gPB(LANG) "MC(g_code,feedmode_in,pr)"              "IPR-Vorschubmodus"
::msgcat::mcset $gPB(LANG) "MC(g_code,feedmode_mm,pm)"              "MMPM-Vorschubmodus"
::msgcat::mcset $gPB(LANG) "MC(g_code,feedmode_mm,pr)"              "MMPR-Vorschubmodus"
::msgcat::mcset $gPB(LANG) "MC(g_code,feedmode,dpm)"                "DPM-Vorschubmodus"

##------------
## M Code
##
::msgcat::mcset $gPB(LANG) "MC(m_code,stop_manual_tc,name)"         "Anhalten/Manueller Wkz-Wechsel"
::msgcat::mcset $gPB(LANG) "MC(m_code,stop,name)"                   "Beenden"
::msgcat::mcset $gPB(LANG) "MC(m_code,opt_stop,name)"               "Opstop"
::msgcat::mcset $gPB(LANG) "MC(m_code,prog_end,name)"               "Programmende"
::msgcat::mcset $gPB(LANG) "MC(m_code,spindle_clw,name)"            "Spindel aktiviert/Im Uhrzeigersinn"
::msgcat::mcset $gPB(LANG) "MC(m_code,spindle_cclw,name)"           "Spindel - Geg. Uhrzeigersinn"
::msgcat::mcset $gPB(LANG) "MC(m_code,lathe_thread,type1)"          "Konstantes Gewinde"
::msgcat::mcset $gPB(LANG) "MC(m_code,lathe_thread,type2)"          "Inkrementales Gewinde"
::msgcat::mcset $gPB(LANG) "MC(m_code,lathe_thread,type3)"          "Dekrementales Gewinde"
::msgcat::mcset $gPB(LANG) "MC(m_code,spindle_off,name)"            "Spindel deaktiviert"
::msgcat::mcset $gPB(LANG) "MC(m_code,tc_retract,name)"             "Wkz-Wechsel/Rückzug"
::msgcat::mcset $gPB(LANG) "MC(m_code,coolant_on,name)"             "Kühlmittel ein"
::msgcat::mcset $gPB(LANG) "MC(m_code,coolant_fld,name)"            "Kühlmittelfluss"
::msgcat::mcset $gPB(LANG) "MC(m_code,coolant_mist,name)"           "Kühlschmiernebel"
::msgcat::mcset $gPB(LANG) "MC(m_code,coolant_thru,name)"           "Kühlmitteldurchfluss"
::msgcat::mcset $gPB(LANG) "MC(m_code,coolant_tap,name)"            "Kühlmittelausfluss"
::msgcat::mcset $gPB(LANG) "MC(m_code,coolant_off,name)"            "Kühlmittel aus"
::msgcat::mcset $gPB(LANG) "MC(m_code,rewind,name)"                 "Wiederholen"
::msgcat::mcset $gPB(LANG) "MC(m_code,thread_wire,name)"            "Gewindedraht"
::msgcat::mcset $gPB(LANG) "MC(m_code,cut_wire,name)"               "Drahtkorn"
::msgcat::mcset $gPB(LANG) "MC(m_code,fls_on,name)"                 "Spülen aktiviert"
::msgcat::mcset $gPB(LANG) "MC(m_code,fls_off,name)"                "Spülen deaktiviert"
::msgcat::mcset $gPB(LANG) "MC(m_code,power_on,name)"               "Leistung aktiviert"
::msgcat::mcset $gPB(LANG) "MC(m_code,power_off,name)"              "Ausschalten"
::msgcat::mcset $gPB(LANG) "MC(m_code,wire_on,name)"                "Draht aktiviert"
::msgcat::mcset $gPB(LANG) "MC(m_code,wire_off,name)"               "Draht deaktiviert"
::msgcat::mcset $gPB(LANG) "MC(m_code,pri_turret,name)"             "Primärer Revolverkopf"
::msgcat::mcset $gPB(LANG) "MC(m_code,sec_turret,name)"             "Sekundärer Revolverkopf"

##------------
## UDE
##
::msgcat::mcset $gPB(LANG) "MC(ude,editor,enable,Label)"            "UDE-Editor aktivieren"
::msgcat::mcset $gPB(LANG) "MC(ude,editor,enable,as_saved,Label)"   "Wie gespeichert"
::msgcat::mcset $gPB(LANG) "MC(ude,editor,TITLE)"                   "Benutzerdefiniertes Ereignis"

::msgcat::mcset $gPB(LANG) "MC(ude,editor,no_ude)"                  "Kein relevantes UDE."

::msgcat::mcset $gPB(LANG) "MC(ude,editor,int,Label)"               "Ganzzahl"
::msgcat::mcset $gPB(LANG) "MC(ude,editor,int,Context)"             "Fügen Sie einen neuen Ganzzahlparameter durch Ziehen in die rechte Liste hinzu. "

::msgcat::mcset $gPB(LANG) "MC(ude,editor,real,Label)"              "Reell"
::msgcat::mcset $gPB(LANG) "MC(ude,editor,real,Context)"            "Fügen Sie einen neuen reellen Parameter durch Ziehen in die rechte Liste hinzu."

::msgcat::mcset $gPB(LANG) "MC(ude,editor,txt,Label)"               "Text"
::msgcat::mcset $gPB(LANG) "MC(ude,editor,txt,Context)"             "Fügen Sie einen neuen Zeichenfolge-Parameter durch Ziehen in die rechte Liste hinzu."

::msgcat::mcset $gPB(LANG) "MC(ude,editor,bln,Label)"               "Boolesch"
::msgcat::mcset $gPB(LANG) "MC(ude,editor,bln,Context)"             "Fügen Sie einen neuen booleschen Parameter durch Ziehen in die rechte Liste hinzu."

::msgcat::mcset $gPB(LANG) "MC(ude,editor,opt,Label)"               "Option"
::msgcat::mcset $gPB(LANG) "MC(ude,editor,opt,Context)"             "Fügen Sie eine neuen Optionsparameter durch Ziehen in die rechte Liste hinzu."

::msgcat::mcset $gPB(LANG) "MC(ude,editor,pnt,Label)"               "Punkt"
::msgcat::mcset $gPB(LANG) "MC(ude,editor,pnt,Context)"             "Fügen Sie einen neuen Punktparameter durch Ziehen in die rechte Liste hinzu."

::msgcat::mcset $gPB(LANG) "MC(ude,editor,trash,Label)"             "Editor -- Abfalleimer"
::msgcat::mcset $gPB(LANG) "MC(ude,editor,trash,Context)"           "Ungewünschte Parameter können aus der rechten Liste entfernt werden, indem sie in diesen Abfalleimer verschoben werden."

::msgcat::mcset $gPB(LANG) "MC(ude,editor,event,Label)"             "Ereignis"
::msgcat::mcset $gPB(LANG) "MC(ude,editor,event,Context)"           "Ereignisparameter können hier mit MT1 bearbeitet werden."

::msgcat::mcset $gPB(LANG) "MC(ude,editor,param,Label)"             "Ereignis -- Parameter"
::msgcat::mcset $gPB(LANG) "MC(ude,editor,param,Context)"           "Jeder Parameter kann durch Rechtsklicken, oder durch Änderung der Parameterreihenfolge mit der Option Ziehen&Ablegen bearbeitet werden .\n \nDer hellblaue Parameter ist systemdefiniert und kann nicht gelöscht werden. \nDer braune Parameter ist nicht systemdefiniert und kann geändert bzw. gelöscht werden."

::msgcat::mcset $gPB(LANG) "MC(ude,editor,param,edit,Label)"        "Parameter -- Option"
::msgcat::mcset $gPB(LANG) "MC(ude,editor,param,edit,Context)"      "Klicken Sie auf Maustaste 1, um die Standardoption auszuwählen.\n Auf die Maustaste 1 doppelklicken, um Option zu bearbeiten."
::msgcat::mcset $gPB(LANG) "MC(ude,editor,param,editor,Label)"      "Parametertyp: "

::msgcat::mcset $gPB(LANG) "MC(ude,editor,pnt,sel,Label)"           "Auswählen"
::msgcat::mcset $gPB(LANG) "MC(ude,editor,pnt,dsp,Label)"           "Anzeigen"

::msgcat::mcset $gPB(LANG) "MC(ude,editor,dlg,ok,Label)"            "OK"
::msgcat::mcset $gPB(LANG) "MC(ude,editor,dlg,bck,Label)"           "Hinten"
::msgcat::mcset $gPB(LANG) "MC(ude,editor,dlg,cnl,Label)"           "Abbrechen"

::msgcat::mcset $gPB(LANG) "MC(ude,editor,paramdlg,PL,Label)"       "Parameterbezeichnung"
::msgcat::mcset $gPB(LANG) "MC(ude,editor,paramdlg,VN,Label)"       "Variablenname"
::msgcat::mcset $gPB(LANG) "MC(ude,editor,paramdlg,DF,Label)"       "Standardwert"
::msgcat::mcset $gPB(LANG) "MC(ude,editor,paramdlg,PL,Context)"     "Parameterbezeichnung festlegen"
::msgcat::mcset $gPB(LANG) "MC(ude,editor,paramdlg,VN,Context)"     "Variablenname festlegen"
::msgcat::mcset $gPB(LANG) "MC(ude,editor,paramdlg,DF,Context)"     "Standardwert festlegen"
::msgcat::mcset $gPB(LANG) "MC(ude,editor,paramdlg,TG)"             "Umschalten"
::msgcat::mcset $gPB(LANG) "MC(ude,editor,paramdlg,TG,B,Label)"     "Umschalten"
::msgcat::mcset $gPB(LANG) "MC(ude,editor,paramdlg,TG,B,Context)"   "Umschaltwert auswählen"
::msgcat::mcset $gPB(LANG) "MC(ude,editor,paramdlg,ON,Label)"       "Auf Kontur"
::msgcat::mcset $gPB(LANG) "MC(ude,editor,paramdlg,OFF,Label)"      "Aus"
::msgcat::mcset $gPB(LANG) "MC(ude,editor,paramdlg,ON,Context)"     "Standardwert als \"AKTIVIERT\" auswählen"
::msgcat::mcset $gPB(LANG) "MC(ude,editor,paramdlg,OFF,Context)"    "Standardwert als \"DEAKTIVIERT\" auswählen"
::msgcat::mcset $gPB(LANG) "MC(ude,editor,paramdlg,OL)"             "Optionsliste"
::msgcat::mcset $gPB(LANG) "MC(ude,editor,paramdlg,ADD,Label)"      "Hinzufügen"
::msgcat::mcset $gPB(LANG) "MC(ude,editor,paramdlg,CUT,Label)"      "Ausschneiden"
::msgcat::mcset $gPB(LANG) "MC(ude,editor,paramdlg,PASTE,Label)"    "Einfügen"
::msgcat::mcset $gPB(LANG) "MC(ude,editor,paramdlg,ADD,Context)"    "Ein Element hinzufügen"
::msgcat::mcset $gPB(LANG) "MC(ude,editor,paramdlg,CUT,Context)"    "Ein Element bearbeiten"
::msgcat::mcset $gPB(LANG) "MC(ude,editor,paramdlg,PASTE,Context)"  "Ein Element einfügen"
::msgcat::mcset $gPB(LANG) "MC(ude,editor,paramdlg,ENTRY,Label)"    "Option"
::msgcat::mcset $gPB(LANG) "MC(ude,editor,paramdlg,ENTRY,Context)"  "Ein Element eingeben"
::msgcat::mcset $gPB(LANG) "MC(ude,editor,eventdlg,EN,Label)"       "Ereignisname"
::msgcat::mcset $gPB(LANG) "MC(ude,editor,eventdlg,EN,Context)"     "Ereignisname festlegen"
::msgcat::mcset $gPB(LANG) "MC(ude,editor,eventdlg,PEN,Label)"      "PP-Name"
::msgcat::mcset $gPB(LANG) "MC(ude,editor,eventdlg,PEN,Context)"    "PP-Name festlegen"
::msgcat::mcset $gPB(LANG) "MC(ude,editor,eventdlg,PEN,C,Label)"    "PP-Name"
::msgcat::mcset $gPB(LANG) "MC(ude,editor,eventdlg,PEN,C,Context)"  "Dieser Schalter gibt an, ob der PP-Name festgelegt werden kann"
::msgcat::mcset $gPB(LANG) "MC(ude,editor,eventdlg,EL,Label)"       "Ereignisbezeichnung"
::msgcat::mcset $gPB(LANG) "MC(ude,editor,eventdlg,EL,Context)"     "Ereignisbezeichnung festlegen"
::msgcat::mcset $gPB(LANG) "MC(ude,editor,eventdlg,EL,C,Label)"     "Ereignisbezeichnung"
::msgcat::mcset $gPB(LANG) "MC(ude,editor,eventdlg,EL,C,Context)"   "Dieser Schalter gibt an, ob die Ereignisbezeichnung festgelegt werden kann"

::msgcat::mcset $gPB(LANG) "MC(ude,editor,eventdlg,EC,Label)"           "Kategorie"
::msgcat::mcset $gPB(LANG) "MC(ude,editor,eventdlg,EC,Context)"         "Dieser Schalter gibt an, ob die Kategorie festgelegt werden kann"
::msgcat::mcset $gPB(LANG) "MC(ude,editor,eventdlg,EC_MILL,Label)"      "Fräsen"
::msgcat::mcset $gPB(LANG) "MC(ude,editor,eventdlg,EC_DRILL,Label)"     "Bohrer"
::msgcat::mcset $gPB(LANG) "MC(ude,editor,eventdlg,EC_LATHE,Label)"     "Drehen"
::msgcat::mcset $gPB(LANG) "MC(ude,editor,eventdlg,EC_WEDM,Label)"      "Drahterodieren"
::msgcat::mcset $gPB(LANG) "MC(ude,editor,eventdlg,EC_MILL,Context)"    "Fräs-Kategorie festlegen"
::msgcat::mcset $gPB(LANG) "MC(ude,editor,eventdlg,EC_DRILL,Context)"   "Bohrer-Kategorie festlegen"
::msgcat::mcset $gPB(LANG) "MC(ude,editor,eventdlg,EC_LATHE,Context)"   "Drehmaschinen-Kategorie festlegen"
::msgcat::mcset $gPB(LANG) "MC(ude,editor,eventdlg,EC_WEDM,Context)"    "Drahterodieren-Kategorie festlegen"

::msgcat::mcset $gPB(LANG) "MC(ude,editor,EDIT)"                    "Ereignis bearbeiten"
::msgcat::mcset $gPB(LANG) "MC(ude,editor,CREATE)"                  "Maschinen-Steuerungsereignis erzeugen"
::msgcat::mcset $gPB(LANG) "MC(ude,editor,popup,HELP)"              "Hilfe"
::msgcat::mcset $gPB(LANG) "MC(ude,editor,popup,EDIT)"              "Anwenderdefinierte Parameter bearbeiten..."
::msgcat::mcset $gPB(LANG) "MC(ude,editor,param,EDIT)"              "Bearbeiten..."
::msgcat::mcset $gPB(LANG) "MC(ude,editor,param,VIEW)"              "Ansicht..."
::msgcat::mcset $gPB(LANG) "MC(ude,editor,popup,DELETE)"            "Löschen"
::msgcat::mcset $gPB(LANG) "MC(ude,editor,popup,CREATE)"            "Erzeugen Sie ein neues Maschinen-Steuerungsereignis..."
::msgcat::mcset $gPB(LANG) "MC(ude,editor,popup,IMPORT)"            "Maschinen-Steuerungsereignisse importieren..."
::msgcat::mcset $gPB(LANG) "MC(ude,editor,popup,MSG_BLANK)"         "Der Ereignisname darf nicht leer sein."
::msgcat::mcset $gPB(LANG) "MC(ude,editor,popup,MSG_SAMENAME)"      "Der Ereignisname ist bereits vorhanden."
::msgcat::mcset $gPB(LANG) "MC(ude,editor,popup,MSG_SameHandler)"   "Ereignis-Handler ist bereits vorhanden. \nBitte ändern Sie den Ereignis - bzw. PP-Namen nach der Prüfung."
::msgcat::mcset $gPB(LANG) "MC(ude,validate)"                       "Es existiert kein Parameter in diesem Ereignis."
::msgcat::mcset $gPB(LANG) "MC(ude,prev,tab,Label)"                 "Benutzerdefinierte Ereignisse"
::msgcat::mcset $gPB(LANG) "MC(ude,prev,ude,Label)"                 "Maschinen-Steuerungsereignisse"
::msgcat::mcset $gPB(LANG) "MC(ude,prev,udc,Label)"                 "Anwenderdefinierte Zyklen"
::msgcat::mcset $gPB(LANG) "MC(ude,prev,mc,Label)"                  "Systemmaschinen-Steuerungsereignisse"
::msgcat::mcset $gPB(LANG) "MC(ude,prev,nmc,Label)"                 "Nicht-Systemmaschinen-Steuerungsereignisse"
::msgcat::mcset $gPB(LANG) "MC(udc,prev,sys,Label)"                 "Systemzyklen"
::msgcat::mcset $gPB(LANG) "MC(udc,prev,nsys,Label)"                "Nicht-Systemzyklen"
::msgcat::mcset $gPB(LANG) "MC(ude,prev,Status)"                    "Element für Definition auswählen"
::msgcat::mcset $gPB(LANG) "MC(ude,editor,opt,MSG_BLANK)"           "Die Optionszeichenfolge darf nicht leer sein."
::msgcat::mcset $gPB(LANG) "MC(ude,editor,opt,MSG_SAME)"            "Die Optionszeichenfolge ist bereits vorhanden."
::msgcat::mcset $gPB(LANG) "MC(ude,editor,opt,MSG_PST_SAME)"        "Die eingefügte Optionen ist bereits vorhanden."
::msgcat::mcset $gPB(LANG) "MC(ude,editor,opt,MSG_IDENTICAL)"       "Einige Optionen sind identisch."
::msgcat::mcset $gPB(LANG) "MC(ude,editor,opt,NO_OPT)"              "Es ist keine Option in der Liste vorhanden."
::msgcat::mcset $gPB(LANG) "MC(ude,editor,param,MSG_NO_VNAME)"      "Der Variablenname darf nicht leer sein."
::msgcat::mcset $gPB(LANG) "MC(ude,editor,param,MSG_EXIST_VNAME)"   "Der Variablenname ist bereits vorhanden."
::msgcat::mcset $gPB(LANG) "MC(ude,editor,spindle_css,INFO)"        "Dieses Ereignis verwendet das UDE gemeinsam mit \"RPM-Spindel\""
::msgcat::mcset $gPB(LANG) "MC(ude,import,ihr,Label)"               "UDE von einem Postprozessor übernehmen"

::msgcat::mcset $gPB(LANG) "MC(ude,import,ihr,Context)"             "Diese Option ermöglicht diesem Postprozessor die Übernahme der UDE-Definition und deren Handler von einem Postprozessor."

::msgcat::mcset $gPB(LANG) "MC(ude,import,sel,Label)"               "Postprozessor auswählen"

::msgcat::mcset $gPB(LANG) "MC(ude,import,sel,Context)"             "Wählen Sie die PUI-Datei des gewünschten Postprozessors aus. Es ist empfehlenswert, dass alle mit dem übernommenen Postprozessor verknüpften Dateien (PUI, Def, Tcl & CDL) in demselben Verzeichnis (Ordner) für die Laufzeitverwendung platziert werden."

::msgcat::mcset $gPB(LANG) "MC(ude,import,name_cdl,Label)"          "CDL-Dateiname"

::msgcat::mcset $gPB(LANG) "MC(ude,import,name_cdl,Context)"        "Mit dem ausgewählten Postprozessor verknüpfter Pfad- und Dateiname der CDL-Datei, die in der Definitionsdatei dieses Postprozessors referenziert (Einschließen) werden. Der Pfadname muss mit einer UG-Umgebungsvariable (\\\$UGII) oder keiner beginnen. Wenn kein Pfad festgelegt wurde, wird das Verzeichnis \"UGII_CAM_FILE_SEARCH_PATH\" verwendet, um die Datei während der UG/NX-Laufzeit zu lokalisieren."

::msgcat::mcset $gPB(LANG) "MC(ude,import,name_def,Label)"          "Definitions-Dateiname"
::msgcat::mcset $gPB(LANG) "MC(ude,import,name_def,Context)"        "Pfad- und Dateiname der Definitionsdatei des ausgewählten Postprozessors, die in der Definitionsdatei dieses Postprozessors referenziert (Einschließen) werden.  Der Pfadname muss mit einer Umgebungsvariable (\\\$UGII) oder keiner beginnen. Wenn kein Pfad festgelegt wurde, wird das Verzeichnis \" UGII_CAM_FILE_SEARCH_PATH\" verwendet, um die Datei während der UG/NX-Laufzeit zu lokalisieren."

::msgcat::mcset $gPB(LANG) "MC(ude,import,include_cdl,Label)"       "CDL"
::msgcat::mcset $gPB(LANG) "MC(ude,import,ihr_pst,Label)"           "Postprozessor"
::msgcat::mcset $gPB(LANG) "MC(ude,import,ihr_folder,Label)"        "Ordner"
::msgcat::mcset $gPB(LANG) "MC(ude,import,own_folder,Label)"        "Ordner"
::msgcat::mcset $gPB(LANG) "MC(ude,import,own,Label)"               "Eigene CDL-Datei einschließen"

::msgcat::mcset $gPB(LANG) "MC(ude,import,own,Context)"             "Diese Option ermöglicht, dass dieser Postprozessor die Referenz zu seiner CDL-Datei in die Definitionsdatei einschließt."

::msgcat::mcset $gPB(LANG) "MC(ude,import,own_ent,Label)"           "Eigene CDL-Datei"

::msgcat::mcset $gPB(LANG) "MC(ude,import,own_ent,Context)"         "Pfad- und Dateiname der CDL-Datei, die mit diesem Postprozessor, der in der Definitionsdatei dieses Postprozessors referenziert (Einschließen) wird, verknüpft sind.  Der eigentliche Dateiname wird beim Speichern dieses Postprozessors bestimmt.  Der Pfadname muss mit einer UG-Umgebungsvariablen (\\\$UGII) oder keiner beginnen.  Wenn kein Pfad festgelegt wurde, wird das Verzeichnis \"UGII_CAM_FILE_SEARCH_PATH\" verwendet, um die Datei während der UG/NX-Laufzeit zu lokalisieren."

::msgcat::mcset $gPB(LANG) "MC(ude,import,sel,pui,status)"          "PUI-Datei auswählen"
::msgcat::mcset $gPB(LANG) "MC(ude,import,sel,cdl,status)"          "CDL-Datei auswählen"

##---------
## UDC
##
::msgcat::mcset $gPB(LANG) "MC(udc,editor,TITLE)"                   "Anwenderdefinierter Zyklus"
::msgcat::mcset $gPB(LANG) "MC(udc,editor,CREATE)"                  "Anwenderdefinierten Zyklus erzeugen"
::msgcat::mcset $gPB(LANG) "MC(udc,editor,TYPE)"                    "Zyklustyp"
::msgcat::mcset $gPB(LANG) "MC(udc,editor,type,UDC)"                "Benutzerdefiniert"
::msgcat::mcset $gPB(LANG) "MC(udc,editor,type,SYSUDC)"             "Systemdefiniert"
::msgcat::mcset $gPB(LANG) "MC(udc,editor,CYCLBL,Label)"            "Zyklusbezeichnung"
::msgcat::mcset $gPB(LANG) "MC(udc,editor,CYCNAME,Label)"           "Zyklusname"
::msgcat::mcset $gPB(LANG) "MC(udc,editor,CYCLBL,Context)"          "Zyklusbezeichnung festlegen"
::msgcat::mcset $gPB(LANG) "MC(udc,editor,CYCNAME,Context)"         "Zyklusname festlegen"
::msgcat::mcset $gPB(LANG) "MC(udc,editor,CYCLBL,C,Label)"          "Zyklusbezeichnung"
::msgcat::mcset $gPB(LANG) "MC(udc,editor,CYCLBL,C,Context)"        "Mit diesem Schalter kann die Zyklusbezeichnung festgelegt werden"
::msgcat::mcset $gPB(LANG) "MC(udc,editor,popup,EDIT)"              "Anwenderdefinierte Parameter bearbeiten..."
::msgcat::mcset $gPB(LANG) "MC(udc,editor,popup,MSG_BLANK)"         "Der Zyklusname darf nicht leer sein."
::msgcat::mcset $gPB(LANG) "MC(udc,editor,popup,MSG_SAMENAME)"      "Der Zyklusname ist bereits vorhanden."
::msgcat::mcset $gPB(LANG) "MC(udc,editor,popup,MSG_SameHandler)"   "Ereignis-Handler ist bereits vorhanden.\n Bitte den Zyklus-Ereignisnamen ändern."
::msgcat::mcset $gPB(LANG) "MC(udc,editor,popup,MSG_ISSYSCYC)"      "Der Zyklusname gehört zu einem Systemzyklustyp."
::msgcat::mcset $gPB(LANG) "MC(udc,editor,popup,MSG_SYSCYC_EXIST)"  "Dieser Systemzyklus ist bereits vorhanden."
::msgcat::mcset $gPB(LANG) "MC(udc,editor,EDIT)"                    "Zyklusereignis bearbeiten"
::msgcat::mcset $gPB(LANG) "MC(udc,editor,popup,CREATE)"            "Neuen anwenderdefinierten Zyklus erstellen..."
::msgcat::mcset $gPB(LANG) "MC(udc,editor,popup,IMPORT)"            "Anwenderdefinierte Zyklen importieren..."
::msgcat::mcset $gPB(LANG) "MC(udc,drill,csink,INFO)"               "Dieses Ereignis verwendet den Handler gemeinsam mit dem Bohrer."
::msgcat::mcset $gPB(LANG) "MC(udc,drill,simulate,INFO)"            "Dieses Ereignis ist eine simulierte Zyklusart."
::msgcat::mcset $gPB(LANG) "MC(udc,drill,dwell,INFO)"               "Dieses Ereignis verwendet den anwenderdefinierten Zyklus gemeinsam mit "


#######
# IS&V
#######
::msgcat::mcset $gPB(LANG) "MC(isv,tab,label)"                      "Virtuelle N/C-Steuerung"
::msgcat::mcset $gPB(LANG) "MC(isv,Status)"                         "Parameter für ISV festlegen"
::msgcat::mcset $gPB(LANG) "MC(isv,review,Status)"                  "VNC-Befehle überprüfen"

::msgcat::mcset $gPB(LANG) "MC(isv,setup,Label)"                    "Konfiguration"
::msgcat::mcset $gPB(LANG) "MC(isv,vnc_command,Label)"              "VNC-Befehle"
####################
# General Definition
####################
::msgcat::mcset $gPB(LANG) "MC(isv,select_Main)"                    "VNC-Masterdatei für untergeordnete VNC auswählen."
::msgcat::mcset $gPB(LANG) "MC(isv,setup,machine,Label)"            "Werkzeug"
::msgcat::mcset $gPB(LANG) "MC(isv,setup,component,Label)"          "Werkzeugbestückung"
::msgcat::mcset $gPB(LANG) "MC(isv,setup,mac_zcs_frame,Label)"      "Nullreferenz programmieren"
::msgcat::mcset $gPB(LANG) "MC(isv,setup,mac_zcs,Label)"            "Komponente"
::msgcat::mcset $gPB(LANG) "MC(isv,setup,mac_zcs,Context)"          "Legen Sie eine Komponente als ZCS-Referenzbasis fest. Dies sollte eine nicht drehbare Komponente sein, mit der das Teil direkt oder indirekt im Kinematik-Baum verbunden ist."
::msgcat::mcset $gPB(LANG) "MC(isv,setup,spin_com,Label)"           "Komponente"
::msgcat::mcset $gPB(LANG) "MC(isv,setup,spin_com,Context)"         "Legen Sie eine Komponente fest, mit der Werkzeuge befestigt sind. Dies sollte die Spindel-Komponente für einen Fräs-Postprozessor und die Revolver-Komponente für einen Dreh-Postprozessor sein."

::msgcat::mcset $gPB(LANG) "MC(isv,setup,spin_jct,Label)"           "Verbindung"
::msgcat::mcset $gPB(LANG) "MC(isv,setup,spin_jct,Context)"         "Definieren Sie eine Verbindung für die Befestigungswerkzeuge. Für einen Fräs-Postprozessor ist dies die Verbindung in der Mitte der Spindelfläche. Für einen Dreh-Postprozessor ist es die drehbare Revolververbindung. Wenn der Revolver befestigt ist, ist es die Wkz-Befestigungshalterung."

::msgcat::mcset $gPB(LANG) "MC(isv,setup,axis_name,Label)"          "An Wkz-Maschine festgelegte Achse"
::msgcat::mcset $gPB(LANG) "MC(isv,setup,axis_name,Context)"        "Legen Sie die Achsennamen fest, die mit der Kinematik-Konfiguration der Wkz-Maschine übereinstimmt"




::msgcat::mcset $gPB(LANG) "MC(isv,setup,axis_frm,Label)"           "NC-Achsennamen"
::msgcat::mcset $gPB(LANG) "MC(isv,setup,rev_fourth,Label)"         "Rotation umkehren"
::msgcat::mcset $gPB(LANG) "MC(isv,setup,rev_fourth,Context)"       "Legen Sie die Achsenrotationsrichtung fest. Diese kann entweder umgekehrt oder normal sein.  Dies gilt nur für einen Drehtisch."
::msgcat::mcset $gPB(LANG) "MC(isv,setup,rev_fifth,Label)"          "Rotation umkehren"

::msgcat::mcset $gPB(LANG) "MC(isv,setup,fourth_limit,Label)"       "Rotationsgrenze"
::msgcat::mcset $gPB(LANG) "MC(isv,setup,fourth_limit,Context)"     "Legen Sie fest, ob diese Rotationsachse Grenzen enthält"
::msgcat::mcset $gPB(LANG) "MC(isv,setup,fifth_limit,Label)"        "Rotationsgrenze"
::msgcat::mcset $gPB(LANG) "MC(isv,setup,limiton,Label)"            "Ja"
::msgcat::mcset $gPB(LANG) "MC(isv,setup,limitoff,Label)"           "Nein"
::msgcat::mcset $gPB(LANG) "MC(isv,setup,fourth_table,Label)"       "4-Achsen"
::msgcat::mcset $gPB(LANG) "MC(isv,setup,fifth_table,Label)"        "5-Achsen"
::msgcat::mcset $gPB(LANG) "MC(isv,setup,header,Label)"             " Tabelle "
::msgcat::mcset $gPB(LANG) "MC(isv,setup,intialization,Label)"      "Regler"
::msgcat::mcset $gPB(LANG) "MC(isv,setup,general_def,Label)"        "Ausgangseinstellung"
::msgcat::mcset $gPB(LANG) "MC(isv,setup,advanced_def,Label)"       "Weitere Optionen"
::msgcat::mcset $gPB(LANG) "MC(isv,setup,InputOutput,Label)"        "Spezielle NC-Codes"

::msgcat::mcset $gPB(LANG) "MC(isv,setup,program,Label)"            "Standard-Programmdefinition"
::msgcat::mcset $gPB(LANG) "MC(isv,setup,output,Label)"             "Programmdefinition exportieren"
::msgcat::mcset $gPB(LANG) "MC(isv,setup,output,Context)"           "Programmdefinition in eine Datei speichern"
::msgcat::mcset $gPB(LANG) "MC(isv,setup,input,Label)"              "Programmdefinition importieren"
::msgcat::mcset $gPB(LANG) "MC(isv,setup,input,Context)"            "Programmdefinition aus einer Datei abrufen"
::msgcat::mcset $gPB(LANG) "MC(isv,setup,file_err,Msg)"             "Die ausgewählte Datei stimmt nicht mit dem Standarddateityp der Programmdefinitionsdatei überein. Fortfahren?"
::msgcat::mcset $gPB(LANG) "MC(isv,setup,wcs,Label)"                "Nullpunktverschiebung"
::msgcat::mcset $gPB(LANG) "MC(isv,setup,tool,Label)"               "Wkz-Daten"
::msgcat::mcset $gPB(LANG) "MC(isv,setup,g_code,Label)"             "Spezieller G-Code"
::msgcat::mcset $gPB(LANG) "MC(isv,setup,special_vnc,Label)"        "Spezieller NC-Code"

::msgcat::mcset $gPB(LANG) "MC(isv,setup,initial,frame,Label)"      ""
::msgcat::mcset $gPB(LANG) "MC(isv,setup,initial_motion,Label)"     "Bewegung"
::msgcat::mcset $gPB(LANG) "MC(isv,setup,initial_motion,Context)"   "Ausgangsbewegung der Wkz-Maschine festlegen"

::msgcat::mcset $gPB(LANG) "MC(isv,setup,spindle,frame,Label)"      "Spindel"
::msgcat::mcset $gPB(LANG) "MC(isv,setup,spindle_mode,Label)"       "Modus"
::msgcat::mcset $gPB(LANG) "MC(isv,setup,spindle_direction,Label)"  "Richtung"
::msgcat::mcset $gPB(LANG) "MC(isv,setup,spindle,frame,Context)"    "Einheit der Ausgangsspindeldrehzahl und Rotationsrichtung festlegen"

::msgcat::mcset $gPB(LANG) "MC(isv,setup,feedrate_mode,Label)"      "Vorschubmodus"
::msgcat::mcset $gPB(LANG) "MC(isv,setup,feedrate_mode,Context)"    "Einheit des Ausgangsvorschubs festlegen"

::msgcat::mcset $gPB(LANG) "MC(isv,setup,boolean,frame,Label)"      "Boolesches Element definieren"
::msgcat::mcset $gPB(LANG) "MC(isv,setup,power_on_wcs,Label)"       "WCS aktivieren  "
::msgcat::mcset $gPB(LANG) "MC(isv,setup,power_on_wcs,Context)"     "0 gibt an, dass die Standardkoordinate der Null-Bearbeitung verwendet wird\n 1 gibt an, dass die erste anwenderdefinierte Nullpunktverschiebung  (Arbeitskoordinate) verwendet wird"

::msgcat::mcset $gPB(LANG) "MC(isv,setup,use_s_leader,Label)"       "S verwendet"
::msgcat::mcset $gPB(LANG) "MC(isv,setup,use_f_leader,Label)"       "F verwendet"


::msgcat::mcset $gPB(LANG) "MC(isv,setup,dog_leg,Label)"            "Knickpunkt-Eilgang"
::msgcat::mcset $gPB(LANG) "MC(isv,setup,dog_leg,Context)"          "Mit \"Aktiviert\" werden die Eilgangbewegungen winkelförmig bewegt; Mit \"Deaktiviert\" werden die Eilgangbewegungen entsprechend des NC-Codes (Punkt zu Punkt) bewegt."

::msgcat::mcset $gPB(LANG) "MC(isv,setup,dog_leg,yes)"              "Ja"
::msgcat::mcset $gPB(LANG) "MC(isv,setup,dog_leg,no)"               "Nein"

::msgcat::mcset $gPB(LANG) "MC(isv,setup,on_off_frame,Label)"       "AKTIVIEREN/DEAKTIVIEREN definieren"
::msgcat::mcset $gPB(LANG) "MC(isv,setup,stroke_limit,Label)"       "Anschlaggrenze"
::msgcat::mcset $gPB(LANG) "MC(isv,setup,cutcom,Label)"             "Wkz-Kompensation"
::msgcat::mcset $gPB(LANG) "MC(isv,setup,tl_adjust,Label)"          "Wkz-Längenanpassung"
::msgcat::mcset $gPB(LANG) "MC(isv,setup,scale,Label)"              "Maßstab"
::msgcat::mcset $gPB(LANG) "MC(isv,setup,macro_modal,Label)"        "Makro-modal"
::msgcat::mcset $gPB(LANG) "MC(isv,setup,wcs_rotate,Label)"         "WCS-Rotation"
::msgcat::mcset $gPB(LANG) "MC(isv,setup,cycle,Label)"              "Zyklus"

::msgcat::mcset $gPB(LANG) "MC(isv,setup,initial_mode,frame,Label)"     "Eingabemodus"
::msgcat::mcset $gPB(LANG) "MC(isv,setup,initial_mode,frame,Context)"   "Ausgangseingabe als \"absolut\" oder \"inkremental\" festlegen"

###################
# Input/Out Related
###################
::msgcat::mcset $gPB(LANG) "MC(isv,sign_define,frame,Label)"        ""
::msgcat::mcset $gPB(LANG) "MC(isv,sign_define,rewindstop,Label)"   "Rücklaufhaltecode"
::msgcat::mcset $gPB(LANG) "MC(isv,sign_define,rewindstop,Context)" "Rücklaufhaltecode festlegen"

::msgcat::mcset $gPB(LANG) "MC(isv,control_var,frame,Label)"        "Steuern Sie die Variablen"

::msgcat::mcset $gPB(LANG) "MC(isv,sign_define,convarleader,Label)"     "Leiter"
::msgcat::mcset $gPB(LANG) "MC(isv,sign_define,convarleader,Context)"   "Steuerungsvariable festlegen"
::msgcat::mcset $gPB(LANG) "MC(isv,sign_define,conequ,Label)"           "Gleichheitszeichen"
::msgcat::mcset $gPB(LANG) "MC(isv,sign_define,conequ,Context)"         "Gleichheitszeichen festlegen"
::msgcat::mcset $gPB(LANG) "MC(isv,sign_define,percent,Label)"          "Prozentzeichen %"
::msgcat::mcset $gPB(LANG) "MC(isv,sign_define,leaderjing,Label)"       "Spitz #"
::msgcat::mcset $gPB(LANG) "MC(isv,sign_define,text_string,Label)"      "Textzeichenfolge"

::msgcat::mcset $gPB(LANG) "MC(isv,inputmode,frame,Label)"          ""
::msgcat::mcset $gPB(LANG) "MC(isv,input_mode,Label)"               "Ausgangsmodus"
::msgcat::mcset $gPB(LANG) "MC(isv,absolute_mode,Label)"            "Absolut"
::msgcat::mcset $gPB(LANG) "MC(isv,incremental_style,frame,Label)"  "Inkrementaler Modus"

::msgcat::mcset $gPB(LANG) "MC(isv,incremental_mode,Label)"         "Inkremental"
::msgcat::mcset $gPB(LANG) "MC(isv,incremental_gcode,Label)"        "G-Code"
::msgcat::mcset $gPB(LANG) "MC(isv,incremental_gcode,Context)"      "Verwendung von G90 G91, um zwischen absoluten und inkrementalen Modus zu unterscheiden"
::msgcat::mcset $gPB(LANG) "MC(isv,incremental_uvw,Label)"          "Sonderbezugspfeil"
::msgcat::mcset $gPB(LANG) "MC(isv,incremental_uvw,Context)"        "Ein Sonderbezugspfeil kann verwendet werden, um zwischen dem absoluten und inkrementalen Modus zu unterscheiden. Beispielsweise: Bezugspfeil "
::msgcat::mcset $gPB(LANG) "MC(isv,incr_x,Label)"                   "X "
::msgcat::mcset $gPB(LANG) "MC(isv,incr_y,Label)"                   "Y "
::msgcat::mcset $gPB(LANG) "MC(isv,incr_z,Label)"                   "Z "
::msgcat::mcset $gPB(LANG) "MC(isv,incr_a,Label)"                   "Vierte Achse "
::msgcat::mcset $gPB(LANG) "MC(isv,incr_b,Label)"                   "5. Achse "

::msgcat::mcset $gPB(LANG) "MC(isv,incr_x,Context)"                 "Speziellen X-Achsenbezugspfeil festlegen, der im inkrementalen Stil verwendet wird"
::msgcat::mcset $gPB(LANG) "MC(isv,incr_y,Context)"                 "Speziellen Y-Achsenbezugspfeil festlegen, der im inkrementalen Stil verwendet wird"
::msgcat::mcset $gPB(LANG) "MC(isv,incr_z,Context)"                 "Speziellen Z-Achsenbezugspfeil festlegen, der im inkrementalen Stil verwendet wird"
::msgcat::mcset $gPB(LANG) "MC(isv,incr_a,Context)"                 "Speziellen 4-Achsenbezugspfeil festlegen, der im inkrementalen Stil verwendet wird"
::msgcat::mcset $gPB(LANG) "MC(isv,incr_b,Context)"                 "Speziellen 5-Achsenbezugspfeil festlegen, der im inkrementalen Stil verwendet wird"
::msgcat::mcset $gPB(LANG) "MC(isv,vnc_mes,frame,Label)"            "VNC-Meldung ausgeben"

::msgcat::mcset $gPB(LANG) "MC(isv,vnc_message,Label)"              "VNC-Meldung auflisten"
::msgcat::mcset $gPB(LANG) "MC(isv,vnc_message,Context)"            "Sobald die Option geprüft ist, werden alle VNC-Debug-Meldungen bei der Simulation im Operationsmeldungsfenster angezeigt."

::msgcat::mcset $gPB(LANG) "MC(isv,vnc_mes,prefix,Label)"           "Präfix der Meldung"
::msgcat::mcset $gPB(LANG) "MC(isv,spec_desc,Label)"                "Beschreibung"
::msgcat::mcset $gPB(LANG) "MC(isv,spec_codelist,Label)"            "Code-Liste"
::msgcat::mcset $gPB(LANG) "MC(isv,spec_nccode,Label)"              "NC-Code / Zeichenfolge"

################
# WCS Definition
################
::msgcat::mcset $gPB(LANG) "MC(isv,machine_zero,offset,Label)"      "Nullbearbeitungs-Abstand von\nWkz-Maschine-Nullbefestigung"
::msgcat::mcset $gPB(LANG) "MC(isv,wcs_offset,frame,Label)"         "Nullpunktverschiebung"
::msgcat::mcset $gPB(LANG) "MC(isv,wcs_leader,Label)"               " Code "
::msgcat::mcset $gPB(LANG) "MC(isv,wcs_number,Label)"               "    "
::msgcat::mcset $gPB(LANG) "MC(isv,wcs_offset,origin_x,Label)"      " X-Offset  "
::msgcat::mcset $gPB(LANG) "MC(isv,wcs_offset,origin_y,Label)"      " Y-Offset  "
::msgcat::mcset $gPB(LANG) "MC(isv,wcs_offset,origin_z,Label)"      " Z-Offset  "
::msgcat::mcset $gPB(LANG) "MC(isv,wcs_offset,a_offset,Label)"      " A-Offset  "
::msgcat::mcset $gPB(LANG) "MC(isv,wcs_offset,b_offset,Label)"      " B-Offset  "
::msgcat::mcset $gPB(LANG) "MC(isv,wcs_offset,c_offset,Label)"      " C-Offset  "
::msgcat::mcset $gPB(LANG) "MC(isv,wcs_offset,wcs_num,Label)"       "Koordinatensystem"
::msgcat::mcset $gPB(LANG) "MC(isv,wcs_offset,wcs_num,Context)"     "Anzahl der Nullpunktverschiebungen festlegen, die hinzugefügt werden muss"
::msgcat::mcset $gPB(LANG) "MC(isv,wcs_offset,wcs_add,Label)"       "Hinzufügen"
::msgcat::mcset $gPB(LANG) "MC(isv,wcs_offset,wcs_add,Context)"     "Neues Nullpunktverschiebungs-KSYS hinzufügen; Position festlegen"
::msgcat::mcset $gPB(LANG) "MC(isv,wcs_offset,wcs_err,Msg)"         "Diese KSYS-Nummer ist bereits vorhanden."
::msgcat::mcset $gPB(LANG) "MC(isv,tool_info,frame,Label)"          "Wkz-Informationen"
::msgcat::mcset $gPB(LANG) "MC(isv,tool_info,tool_entry,Label)"     "Neuen Wkz-Namen eingeben"
::msgcat::mcset $gPB(LANG) "MC(isv,tool_info,tool_name,Label)"      "       Name       "

::msgcat::mcset $gPB(LANG) "MC(isv,tool_info,tool_num,Label)"       " Werkzeug "
::msgcat::mcset $gPB(LANG) "MC(isv,tool_info,add_tool,Label)"       "Hinzufügen"
::msgcat::mcset $gPB(LANG) "MC(isv,tool_info,tool_diameter,Label)"  " Durchmesser "
::msgcat::mcset $gPB(LANG) "MC(isv,tool_info,offset_usder,Label)"   "   Spitzen-Offsets   "
::msgcat::mcset $gPB(LANG) "MC(isv,tool_info,carrier_id,Label)"     " Träger-ID "
::msgcat::mcset $gPB(LANG) "MC(isv,tool_info,pocket_id,Label)"      " Taschen-ID "
::msgcat::mcset $gPB(LANG) "MC(isv,tool_info,cutcom_reg,Label)"     "     Wkz-Kompensation     "
::msgcat::mcset $gPB(LANG) "MC(isv,tool_info,cutreg,Label)"         "Register "
::msgcat::mcset $gPB(LANG) "MC(isv,tool_info,cutval,Label)"         "Offset "
::msgcat::mcset $gPB(LANG) "MC(isv,tool_info,adjust_reg,Label)"     " Längenanpassung "
::msgcat::mcset $gPB(LANG) "MC(isv,tool_info,tool_type,Label)"      "   Typ   "
::msgcat::mcset $gPB(LANG) "MC(isv,prog,setup,Label)"               "Standard-Programmdefinition"
::msgcat::mcset $gPB(LANG) "MC(isv,prog,setup_right,Label)"         "Programmdefinition"
::msgcat::mcset $gPB(LANG) "MC(isv,output,setup_data,Label)"        "Programmdefinitionsdatei festlegen"
::msgcat::mcset $gPB(LANG) "MC(isv,input,setup_data,Label)"         "Programmdefinitionsdatei auswählen"

::msgcat::mcset $gPB(LANG) "MC(isv,tool_info,toolnum,Label)"        "Wkz-Nummer  "
::msgcat::mcset $gPB(LANG) "MC(isv,tool_info,toolnum,Context)"      "Wkz-Nummer festlegen, die hinzugefügt werden muss"
::msgcat::mcset $gPB(LANG) "MC(isv,tool_info,add_tool,Context)"     "Neues Werkzeug hinzufügen; Parameter festlegen"
::msgcat::mcset $gPB(LANG) "MC(isv,tool_info,add_err,Msg)"          "Die Wkz-Nummer ist bereits vorhanden."
::msgcat::mcset $gPB(LANG) "MC(isv,tool_info,name_err,Msg)"         "Wkz-Name darf nicht leer sein."

###########################
# Special G code Definition
###########################

::msgcat::mcset $gPB(LANG) "MC(isv,g_code,frame,Label)"             "Spezieller G-Code"
::msgcat::mcset $gPB(LANG) "MC(isv,g_code,frame,Context)"           "In der Simulation verwendete G-Codes festlegen"
::msgcat::mcset $gPB(LANG) "MC(isv,g_code,from_home,Label)"         "Von Ausgangsposition"
::msgcat::mcset $gPB(LANG) "MC(isv,g_code,return_home,Label)"       "Zur Startseite zurückkehren"
::msgcat::mcset $gPB(LANG) "MC(isv,g_code,mach_wcs,Label)"          "Maschinenbezugsbewegung"
::msgcat::mcset $gPB(LANG) "MC(isv,g_code,set_local,Label)"         "Lokale Koordinate festlegen"

###########################
# Special NC Custom Command
###########################

::msgcat::mcset $gPB(LANG) "MC(isv,spec_command,frame,Label)"       "NC-Sonderbefehle"
::msgcat::mcset $gPB(LANG) "MC(isv,spec_command,frame,Context)"     "Für Sondergeräte festgelegte NC-Befehle"


::msgcat::mcset $gPB(LANG) "MC(isv,spec_pre,frame,Label)"           "Befehle vorbearbeiten"
::msgcat::mcset $gPB(LANG) "MC(isv,spec_pre,frame,Context)"         "Befehlslisten enthalten alle Token bzw. Symbole, die verarbeitet werden müssen bevor ein Block der Syntaxanalyse für Koordinaten unterliegt"

::msgcat::mcset $gPB(LANG) "MC(isv,spec_command,add,Label)"         "Hinzufügen"
::msgcat::mcset $gPB(LANG) "MC(isv,spec_command,edit,Label)"        "Bearbeiten"
::msgcat::mcset $gPB(LANG) "MC(isv,spec_command,delete,Label)"      "Löschen"
::msgcat::mcset $gPB(LANG) "MC(isv,spec_command,title,Label)"       "Sonderbefehl für andere Geräte"
::msgcat::mcset $gPB(LANG) "MC(isv,spec_command,add_sim,Label)"     "SIM-Befehl @Cursor hinzufügen"
::msgcat::mcset $gPB(LANG) "MC(isv,spec_command,init_sim,Label)"    "Bitte einen Befehl auswählen"

::msgcat::mcset $gPB(LANG) "MC(isv,spec_command,preleader,Label)"   "Leiter"
::msgcat::mcset $gPB(LANG) "MC(isv,spec_command,preleader,Context)" "Bezugspfeil für vorbearbeiteten anwenderdef. Befehl festlegen."

::msgcat::mcset $gPB(LANG) "MC(isv,spec_command,precode,Label)"     "Code"
::msgcat::mcset $gPB(LANG) "MC(isv,spec_command,precode,Context)"   "Bezugspfeil für vorbearbeiteten anwenderdef. Befehl festlegen."

::msgcat::mcset $gPB(LANG) "MC(isv,spec_command,leader,Label)"      "Leiter"
::msgcat::mcset $gPB(LANG) "MC(isv,spec_command,leader,Context)"    "Bezugspfeil für anwenderdef. Befehl festlegen."

::msgcat::mcset $gPB(LANG) "MC(isv,spec_command,code,Label)"        "Code"
::msgcat::mcset $gPB(LANG) "MC(isv,spec_command,code,Context)"      "Bezugspfeil für anwenderdef. Befehl festlegen."

::msgcat::mcset $gPB(LANG) "MC(isv,spec_command,add,Context)"       "Neuen anwenderdef. Befehl hinzufügen"
::msgcat::mcset $gPB(LANG) "MC(isv,spec_command,add_err,Msg)"       "Dieser Token wurde bereits bearbeitet."
::msgcat::mcset $gPB(LANG) "MC(isv,spec_command,sel_err,Msg)"       "Bitte einen Befehl auswählen"
::msgcat::mcset $gPB(LANG) "MC(isv,export,error,title)"             "Warnung"

::msgcat::mcset $gPB(LANG) "MC(isv,tool_table,title,Label)"         "Wkz-Tabelle"
::msgcat::mcset $gPB(LANG) "MC(isv,ex_editor,warning,Msg)"          "Dies ist ein vom System erzeugter VNC-Befehl. Änderungen werden nicht gespeichert."


# - Languages
#
::msgcat::mcset $gPB(LANG) "MC(language,Label)"                     "Sprache"
::msgcat::mcset $gPB(LANG) "MC(pb_msg_english)"                     "Englisch"
::msgcat::mcset $gPB(LANG) "MC(pb_msg_french)"                      "Französisch"
::msgcat::mcset $gPB(LANG) "MC(pb_msg_german)"                      "Deutsch"
::msgcat::mcset $gPB(LANG) "MC(pb_msg_italian)"                     "Italienisch"
::msgcat::mcset $gPB(LANG) "MC(pb_msg_japanese)"                    "Japanisch"
::msgcat::mcset $gPB(LANG) "MC(pb_msg_korean)"                      "Koreanisch"
::msgcat::mcset $gPB(LANG) "MC(pb_msg_russian)"                     "Russisch"
::msgcat::mcset $gPB(LANG) "MC(pb_msg_simple_chinese)"              "Vereinfachtes Chinesisch"
::msgcat::mcset $gPB(LANG) "MC(pb_msg_spanish)"                     "Spanisch"
::msgcat::mcset $gPB(LANG) "MC(pb_msg_traditional_chinese)"         "Chinesisch (Traditionell)"

### Exit Options Dialog
::msgcat::mcset $gPB(LANG) "MC(exit,options,Label)"                 "Optionen für Beenden"
::msgcat::mcset $gPB(LANG) "MC(exit,options,SaveAll,Label)"         "Beenden und alle speichern"
::msgcat::mcset $gPB(LANG) "MC(exit,options,SaveNone,Label)"        "Beenden ohne Speichern"
::msgcat::mcset $gPB(LANG) "MC(exit,options,SaveSelect,Label)"      "Beenden und ausgewählte speichern"

### OptionMenu Items
::msgcat::mcset $gPB(LANG) "MC(optionMenu,item,Other)"       "Sonstige"
::msgcat::mcset $gPB(LANG) "MC(optionMenu,item,None)"        "Kein"
::msgcat::mcset $gPB(LANG) "MC(optionMenu,item,RT_R)"        "Eilgang & R"
::msgcat::mcset $gPB(LANG) "MC(optionMenu,item,Rapid)"       "Schnellbemaßung"
::msgcat::mcset $gPB(LANG) "MC(optionMenu,item,RS)"          "Spindeleilgang"
::msgcat::mcset $gPB(LANG) "MC(optionMenu,item,C_off_RS)"    "Zyklus deaktivieren, dann Spindeleilgang"
::msgcat::mcset $gPB(LANG) "MC(optionMenu,item,IPM)"         "IPM"
::msgcat::mcset $gPB(LANG) "MC(optionMenu,item,FRN)"         "FRN"
::msgcat::mcset $gPB(LANG) "MC(optionMenu,item,IPR)"         "IPR"
::msgcat::mcset $gPB(LANG) "MC(optionMenu,item,Auto)"        "Autom."
::msgcat::mcset $gPB(LANG) "MC(optionMenu,item,DPM)"         "DPM"
::msgcat::mcset $gPB(LANG) "MC(optionMenu,item,Abs_Inc)"     "Absolut/Inkremental"
::msgcat::mcset $gPB(LANG) "MC(optionMenu,item,Abs_Only)"    "Nur absolut"
::msgcat::mcset $gPB(LANG) "MC(optionMenu,item,Inc_Only)"    "Nur inkremental"
::msgcat::mcset $gPB(LANG) "MC(optionMenu,item,SD)"          "Kürzester Abstand"
::msgcat::mcset $gPB(LANG) "MC(optionMenu,item,AP)"          "Immer positiv"
::msgcat::mcset $gPB(LANG) "MC(optionMenu,item,AN)"          "Immer negativ"
::msgcat::mcset $gPB(LANG) "MC(optionMenu,item,Z_Axis)"      "Z-Achse"
::msgcat::mcset $gPB(LANG) "MC(optionMenu,item,+X_Axis)"     "+X-Achse"
::msgcat::mcset $gPB(LANG) "MC(optionMenu,item,-X_Axis)"     "-X-Achse"
::msgcat::mcset $gPB(LANG) "MC(optionMenu,item,Y_Axis)"      "Y-Achse"
::msgcat::mcset $gPB(LANG) "MC(optionMenu,item,MDD)"         "Der Betrag bestimmt die Richtung"
::msgcat::mcset $gPB(LANG) "MC(optionMenu,item,SDD)"         "Das Zeichen bestimmt die Richtung"



