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
# pb1899
#=============================================================================
# Start and end of coordinate system change event of a pattern instance.
::msgcat::mcset $gPB(LANG) "MC(event,misc,pattern_csys_start,name)"       "Początek układu współrzędnych ustawień wzoru"
::msgcat::mcset $gPB(LANG) "MC(event,misc,pattern_csys_end,name)"         "Koniec układu współrzędnych ustawień wzoru"

# Toggle to signal post being able to process and output subprograms
::msgcat::mcset $gPB(LANG) "MC(listing,subprog_out,check,Label)"          "Włącz wyjście podprogramu"

::msgcat::mcset $gPB(LANG) "MC(listing,subprog_out,check,Context)"        "Ten przełącznik powiadomi procesor rdzeniowy NX/Post, że ten postprocesor umożliwia tworzenie wyjścia podprogramu."

::msgcat::mcset $gPB(LANG) "MC(address,leader,err_msg)"                   "Linia odniesienia adresu X, Y, Z, fourth_axis, fifth_axis i N nie powinna być skonfigurowana wyrażeniem zawierającym zmienne. \n\nTę kontrolę można wyłączyć, ustawiając dla gPB(ALLOW_VAR_SYS_LEADER) wartość \"1\" w pliku ui_pb_user_resource.tcl."

#=============================================================================
# pb1872
#=============================================================================
# Event triggered, during lathe roughing cycle, before the last segment of contour geometry is processed.
::msgcat::mcset $gPB(LANG) "MC(event,misc,before_contour_end,name)"       "Przed końcem profilu"


#=============================================================================
# pb1847
#=============================================================================
# Toggle to enable post output transition path
::msgcat::mcset $gPB(LANG) "MC(listing,tran_path,check,Label)"            "Wyjściowa ścieżka przejścia"

::msgcat::mcset $gPB(LANG) "MC(listing,tran_path,check,Context)"          "Ten przełącznik włącza moduł NX/Post w celu przetworzenia i wyświetlenia zdarzeń, które wynikły ze ścieżki przejścia pomiędzy operacjami."


#=============================================================================
# pb12.02
#=============================================================================
# Dialog title for displaying the text of FORMAT, ADDRESS & BLOCK's definition
::msgcat::mcset $gPB(LANG) "MC(block,def_popup,Label)"                    "Definicja"

::msgcat::mcset $gPB(LANG) "MC(msg,info,obj_undef)"                       "Jeszcze nie skonfigurowano informacji o tym obiekcie."

::msgcat::mcset $gPB(LANG) "MC(msg,info,vnc_cmd_by_pb)"                   "Polecenie VNC wygenerowane przez program Post Builder w celu przekazania ustawień postprocesora do sterownika VNC."

::msgcat::mcset $gPB(LANG) "MC(msg,info,vnc_util)"                        "Polecenia narzędzia VNC zdefiniowane w PB_CMD_vnc__define_misc_procs."

::msgcat::mcset $gPB(LANG) "MC(msg,info,sim_cmd)"                         "Polecenia SIM, które zostaną użyte w sterowniku symulacji."

::msgcat::mcset $gPB(LANG) "MC(msg,info,pb_vnc_cmd)"                      "Polecenia wygenerowane przez program Post Builder do połączenia kluczowych zdarzeń postprocesora ze sterownikiem VNC."

::msgcat::mcset $gPB(LANG) "MC(msg,info,vnc_broker_cmd)"                  "Polecenie Broker użyte w sterowniku VNC do wykonywania innych poleceń."

# Confirmation when user is about to delete an event
::msgcat::mcset $gPB(LANG) "MC(msg,event,delete_confirm)"                 "Czy na pewno chcesz usunąć zdarzenie"


#=============================================================================
# pb12.01
#=============================================================================
# User specified how to handle situation of rotary axis limit violation
::msgcat::mcset $gPB(LANG) "MC(event,misc,user_limit_action,name)"        "Akcja limitu osi użytkownika"

# Skip output of NC code when rotary limit violation has occurred.
::msgcat::mcset $gPB(LANG) "MC(machine,axis,violation,omit,Label)"        "Pomiń wyjście"

# Add/edit notes for a set of custom commands to be exported.
::msgcat::mcset $gPB(LANG) "MC(func,edit_note,Label)"                     "Edytuj uwagi"

#=============================================================================
# pb12.00
#=============================================================================
# Short for "information about ..."
::msgcat::mcset $gPB(LANG) "MC(block,info_popup,Label)"                   "Informacje"

#=============================================================================
# pb11.02
#=============================================================================
# Markers of events taking place at the start & end of cut regions.
::msgcat::mcset $gPB(LANG) "MC(event,misc,region_start_marker,name)"      "Początek znacznika regionu"
::msgcat::mcset $gPB(LANG) "MC(event,misc,region_end_marker,name)"        "Koniec znacznika regionu"

#=============================================================================
# pb11.01
#=============================================================================
# A comment of Tcl language
::msgcat::mcset $gPB(LANG) "MC(event,combo,tcl_line,Label)"               "Komentarz Tcl"

#=============================================================================
# pb10.03
#=============================================================================
::msgcat::mcset $gPB(LANG) "MC(msg,filename_with_spec_char)"              "Nazwa pliku zawierająca znaki specjalne nie jest obsługiwana!"
::msgcat::mcset $gPB(LANG) "MC(msg,not_post_comp_file)"                   "Nie można wybrać własnego komponentu postprocesora dla tego uwzględnienia!"
::msgcat::mcset $gPB(LANG) "MC(listing,output,warning,warn_file)"         "Plik ostrzeżeń"
::msgcat::mcset $gPB(LANG) "MC(listing,output,warning,nc_output)"         "Plik wyjściowy NC"

#=============================================================================
# pb10.02
#=============================================================================
::msgcat::mcset $gPB(LANG) "MC(machine,resolution,check,Label)"           "Zablokuj sprawdzanie bieżącego postprocesora"
::msgcat::mcset $gPB(LANG) "MC(main,options,debug,Label)"                 "Osadź komunikaty o usuwaniu błędów postprocesora"
::msgcat::mcset $gPB(LANG) "MC(encrypt,suppress,Label)"                   "Wyłącz zmianę licencji dla bieżącego postprocesora"
::msgcat::mcset $gPB(LANG) "MC(main,title,license_control)"               "Kontrola licencji"

#=============================================================================
# pb902
#=============================================================================
::msgcat::mcset $gPB(LANG) "MC(other,ude_include_def,Label)"              "Uwzględnij inny plik CDL lub DEF"
#-----------------------------------------------------------------------------
# Labels for new tapping cycles
#-----------------------------------------------------------------------------
::msgcat::mcset $gPB(LANG) "MC(event,cycle,tap_deep,name)"                "Gwintowanie głębokie"
::msgcat::mcset $gPB(LANG) "MC(event,cycle,tap_break_chip,name)"          "Gwintowanie podczas wiercenia z odwiórowaniem"
::msgcat::mcset $gPB(LANG) "MC(g_code,tap_float,name)"                    "Gwintowanie z uchwytem zmiennym"
::msgcat::mcset $gPB(LANG) "MC(g_code,tap_deep,name)"                     "Gwintowanie głębokie"
::msgcat::mcset $gPB(LANG) "MC(g_code,tap_break_chip,name)"               "Gwintowanie podczas wiercenia z odwiórowaniem"
#-----------------------------------------------------------------------------
# Defined strings that did not make it to the local language files.
# - These strings should be included for translation in the later release.
#-----------------------------------------------------------------------------
::msgcat::mcset $gPB(LANG) "MC(event,cycle,plane_change,axis,label)"      "Wykryj zmianę osi narzędzia między otworami"
::msgcat::mcset $gPB(LANG) "MC(event,feedrates,mode,rapid)"               "Szybki"
::msgcat::mcset $gPB(LANG) "MC(event,feedrates,mode,cutting)"             "Obróbka"

#=============================================================================
# pb800
#=============================================================================
::msgcat::mcset $gPB(LANG) "MC(event,misc,subop_start,name)"      "Początek ścieżki podoperacji"
::msgcat::mcset $gPB(LANG) "MC(event,misc,subop_end,name)"        "Koniec ścieżki podoperacji"
::msgcat::mcset $gPB(LANG) "MC(event,misc,contour_start,name)"    "Początek profilu"
::msgcat::mcset $gPB(LANG) "MC(event,misc,contour_end,name)"      "Koniec profilu"
::msgcat::mcset $gPB(LANG) "MC(prog,tree,misc,Label)"             "Różne"
::msgcat::mcset $gPB(LANG) "MC(event,cycle,lathe_rough,name)"     "Obróbka zgrubna tokarką"
::msgcat::mcset $gPB(LANG) "MC(main,file,properties,Label)"       "Właściwości postprocesora"

::msgcat::mcset $gPB(LANG) "MC(ude,editor,popup,MSG_CATEGORY)"    "UDE dla postprocesora frezarki lub tokarki nie może być określone tylko przy użyciu kategorii \"Wedm\"!"

::msgcat::mcset $gPB(LANG) "MC(event,cycle,plane_change,label)"   "Wykryj zmianę płaszczyzny roboczej na niższą"
::msgcat::mcset $gPB(LANG) "MC(format,check_1,error,msg)"         "Format nie może zostać dostosowany do wartości wyrażeń"

::msgcat::mcset $gPB(LANG) "MC(format,check_4,error,msg)"         "Zmień format powiązanego adresu przed opuszczeniem tej strony lub zapisaniem tego postprocesora!"
::msgcat::mcset $gPB(LANG) "MC(format,check_5,error,msg)"         "Zmodyfikuj format przed opuszczeniem tej strony lub zapisaniem tego postprocesora!"
::msgcat::mcset $gPB(LANG) "MC(format,check_6,error,msg)"         "Zmień format powiązanego adresu przed przejściem na tę stronę!"

::msgcat::mcset $gPB(LANG) "MC(msg,old_block,maximum_length)"     "Przekroczono ograniczenie długości nazw następujących bloków:"
::msgcat::mcset $gPB(LANG) "MC(msg,old_address,maximum_length)"   "Przekroczono ograniczenie długości nazw następujących słów:"
::msgcat::mcset $gPB(LANG) "MC(msg,block_address,check,title)"    "Sprawdzanie nazwy bloku i słowa"
::msgcat::mcset $gPB(LANG) "MC(msg,block_address,maximum_length)" "Przekroczono ograniczenie długości niektórych nazw słów lub bloków."

::msgcat::mcset $gPB(LANG) "MC(address,maximum_name_msg)"         "Przekroczono ograniczenie długości łańcucha."

::msgcat::mcset $gPB(LANG) "MC(ude,import,oth_list,Label)"        "Uwzględnij inny plik CDL"
::msgcat::mcset $gPB(LANG) "MC(ude,import,oth_list,Context)"      "Wybierz opcję \\\"Nowy\\\" z menu podręcznego (kliknięcie prawym przyciskiem myszy), aby uwzględnić inne pliki CDL z tym postprocesorem."
::msgcat::mcset $gPB(LANG) "MC(ude,import,ihr_list,Label)"        "Przejmij UDE z postprocesora"
::msgcat::mcset $gPB(LANG) "MC(ude,import,ihr_list,Context)"      "Wybierz opcję \\\"Nowy\\\" z menu podręcznego (kliknięcie prawym przyciskiem myszy), aby przejąć definicje UDE i powiązane programy obsługi z postprocesora."
::msgcat::mcset $gPB(LANG) "MC(ude,import,up,Label)"              "Góra"
::msgcat::mcset $gPB(LANG) "MC(ude,import,down,Label)"            "Dół"
::msgcat::mcset $gPB(LANG) "MC(msg,exist_cdl_file)"               "Określony plik CDL został już uwzględniony!"

::msgcat::mcset $gPB(LANG) "MC(listing,link_var,check,Label)"     "Połącz zmienne Tcl ze zmiennymi C"
::msgcat::mcset $gPB(LANG) "MC(listing,link_var,check,Context)"   "Zestaw często zmienianych zmiennych Tcl (np. \\\"mom_pos\\\") można połączyć bezpośrednio z wewnętrznymi zmiennymi C w celu poprawienia wydajności przetwarzania wyników. Należy jednak przestrzegać pewnych ograniczeń, aby uniknąć możliwych błędów i innych plików wyjściowych NC."

::msgcat::mcset $gPB(LANG) "MC(msg,check_resolution,title)"       "Sprawdź rozdzielczość ruchu liniowego/obrotowego"
::msgcat::mcset $gPB(LANG) "MC(msg,check_resolution,linear)"      "Ustawienie formatu może nie przyjąć wyniku opcji \"Rozdzielczość ruchu liniowego\"."
::msgcat::mcset $gPB(LANG) "MC(msg,check_resolution,rotary)"      "Ustawienie formatu może nie przyjąć wyniku opcji \"Rozdzielczość ruchu obrotowego\"."

::msgcat::mcset $gPB(LANG) "MC(cmd,export,desc,label)"            "Wprowadź opis dla eksportowanych poleceń niestandardowych"
::msgcat::mcset $gPB(LANG) "MC(cmd,desc_dlg,title)"               "Opis"
::msgcat::mcset $gPB(LANG) "MC(block,delete_row,Label)"           "Usuń wszystkie aktywne elementy w tym wierszu"
::msgcat::mcset $gPB(LANG) "MC(block,exec_cond,set,Label)"        "Warunek wyjściowy"
::msgcat::mcset $gPB(LANG) "MC(block,exec_cond,new,Label)"        "Nowy..."
::msgcat::mcset $gPB(LANG) "MC(block,exec_cond,edit,Label)"       "Edytuj..."
::msgcat::mcset $gPB(LANG) "MC(block,exec_cond,remove,Label)"     "Usuń..."

::msgcat::mcset $gPB(LANG) "MC(cust_cmd,name_msg_for_cond)"       "Podaj inną nazwę. \nPolecenie Warunek wyjściowy powinno rozpoczynać się ciągiem"

::msgcat::mcset $gPB(LANG) "MC(machine,linearization,Label)"         "Interpolacja linearyzacji"
::msgcat::mcset $gPB(LANG) "MC(machine,linearization,angle,Label)"   "Kąt obrotu"
::msgcat::mcset $gPB(LANG) "MC(machine,linearization,angle,Context)" "Punkty interpolowane będą obliczane na podstawie rozkładu kątów początkowych i końcowych osi obrotu."
::msgcat::mcset $gPB(LANG) "MC(machine,linearization,axis,Label)"    "Oś narzędzia"
::msgcat::mcset $gPB(LANG) "MC(machine,linearization,axis,Context)"  "Punkty interpolowane będą obliczane na podstawie rozkładu wektorów początkowych i końcowych osi narzędzia."
::msgcat::mcset $gPB(LANG) "MC(machine,resolution,continue,Label)"   "Kontynuuj"
::msgcat::mcset $gPB(LANG) "MC(machine,resolution,abort,Label)"      "Przerwij"

::msgcat::mcset $gPB(LANG) "MC(machine,axis,def_lintol,Label)"       "Tolerancja domyślna"
::msgcat::mcset $gPB(LANG) "MC(machine,axis,def_lintol,Context)"     "Domyślna tolerancja linearyzacji"
::msgcat::mcset $gPB(LANG) "MC(sub_post,inch,Lable)"                 "IN"
::msgcat::mcset $gPB(LANG) "MC(sub_post,metric,Lable)"               "MM"
::msgcat::mcset $gPB(LANG) "MC(new_sub,title,Label)"                 "Utwórz nowy postprocesor podrzędny"
::msgcat::mcset $gPB(LANG) "MC(new,sub_post,toggle,label)"           "Postprocesor podrzędny"
::msgcat::mcset $gPB(LANG) "MC(new,sub_post,toggle,tmp_label)"       "Postprocesor podrzędny tylko dla jednostek"
::msgcat::mcset $gPB(LANG) "MC(new,unit_post,filename,msg)"          "Nazwę nowego postprocesora podrzędnego dla alternatywnych jednostek wyjściowych należy nadać\n przez dodanie przyrostka \"__MM\" lub \"__IN\" do nazwy postprocesora głównego."
::msgcat::mcset $gPB(LANG) "MC(new,alter_unit,toggle,label)"         "Alternatywna jednostka wyjściowa"
::msgcat::mcset $gPB(LANG) "MC(new,main_post,label)"                 "Postprocesor główny"
::msgcat::mcset $gPB(LANG) "MC(new,main_post,warning_1,msg)"         "Do utworzenia nowego postprocesora podrzędnego można użyć wyłącznie kompletnego postprocesora głównego!"
::msgcat::mcset $gPB(LANG) "MC(new,main_post,warning_2,msg)"         "Postprocesor główny należy utworzyć lub zapisać\n w programie Post Builder w wersji 8.0 lub nowszej."
::msgcat::mcset $gPB(LANG) "MC(new,main_post,specify_err,msg)"       "W celu utworzenia postprocesora podrzędnego należy określić postprocesor główny!"
::msgcat::mcset $gPB(LANG) "MC(machine,gen,alter_unit,Label)"        "Jednostki wyjściowe postprocesora podrzędnego:"
::msgcat::mcset $gPB(LANG) "MC(unit_related_param,tab,Label)"        "Parametry jednostek"
::msgcat::mcset $gPB(LANG) "MC(unit_related_param,feed_rate,Label)"  "Posuw"
::msgcat::mcset $gPB(LANG) "MC(listing,alt_unit,frame,Label)"        "Opcjonalny procesor podrzędny jednostek alternatywnych"
::msgcat::mcset $gPB(LANG) "MC(listing,alt_unit,default,Label)"      "Domyślnie"
::msgcat::mcset $gPB(LANG) "MC(listing,alt_unit,default,Context)"    "Nazwa domyślna postprocesora podrzędnego jednostek alternatywnych będzie mieć postać <nazwa postprocesora>__MM lub <nazwa postprocesora>__IN"
::msgcat::mcset $gPB(LANG) "MC(listing,alt_unit,specify,Label)"      "Określ"
::msgcat::mcset $gPB(LANG) "MC(listing,alt_unit,specify,Context)"    "Określ nazwę postprocesora podrzędnego jednostek alternatywnych"
::msgcat::mcset $gPB(LANG) "MC(listing,alt_unit,select_name,Label)"  "Wybierz nazwę"
::msgcat::mcset $gPB(LANG) "MC(listing,alt_unit,warning_1,msg)"      "Można wybrać wyłącznie postprocesor podrzędny jednostek alternatywnych!"
::msgcat::mcset $gPB(LANG) "MC(listing,alt_unit,warning_2,msg)"      "Wybrany postprocesor podrzędny nie może obsługiwać alternatywnych jednostek wyjściowych tego postprocesora!"

::msgcat::mcset $gPB(LANG) "MC(listing,alt_unit,post_name,Label)"    "Procesor podrzędny jednostek alternatywnych"
::msgcat::mcset $gPB(LANG) "MC(listing,alt_unit,post_name,Context)"  "Postprocesor programu NX użyje tego postprocesora podrzędnego jednostek, jeśli został podany, do obsługi alternatywnych jednostek wyjściowych tego postprocesora."


##--------------------
## New string in v7.5
##
::msgcat::mcset $gPB(LANG) "MC(machine,axis,violation,user,evt_title)"  "Akcja użytkownika w przypadku naruszenia limitu osi"
::msgcat::mcset $gPB(LANG) "MC(event,helix,name)"                       "Ruch spiralny"
::msgcat::mcset $gPB(LANG) "MC(event,circular,ijk_param,prefix,msg)"    "Zmiana tej opcji"
::msgcat::mcset $gPB(LANG) "MC(event,circular,ijk_param,postfix,msg)"   "nie będzie mieć wpływu na wyrażenia użyte w adresach!"
::msgcat::mcset $gPB(LANG) "MC(isv,spec_codelist,default,msg)"          "Ta akcja spowoduje przywrócenie listy specjalnych kodów NC\n oraz ich programów obsługi do stanu, gdy ten postprocesor został otwarty lub utworzony.\n\n Czy chcesz kontynuować?"
::msgcat::mcset $gPB(LANG) "MC(isv,spec_codelist,restore,msg)"          "Ta akcja spowoduje przywrócenie listy specjalnych kodów NC\n oraz ich programów obsługi do stanu, gdy ta strona została ostatnio odwiedzona.\n\n Czy chcesz kontynuować?"
::msgcat::mcset $gPB(LANG) "MC(msg,block_format_command,paste_err)"     "Nazwa obiektu już istnieje... Wklejenie nieprawidłowe!"
::msgcat::mcset $gPB(LANG) "MC(main,file,open,choose_cntl_type)"        "Wybierz rodzinę sterownika"
::msgcat::mcset $gPB(LANG) "MC(cust_cmd,import,no_vnc_cmd,msg)"         "Ten plik nie zawiera żadnego nowego ani innego polecenia VNC!"
::msgcat::mcset $gPB(LANG) "MC(cust_cmd,import,no_cmd,msg)"             "Ten plik nie zawiera żadnego nowego ani innego polecenia niestandardowego!"
::msgcat::mcset $gPB(LANG) "MC(isv,tool_info,name_same_err,Msg)"        "Nazwy narzędzi nie mogą być takie same!"
::msgcat::mcset $gPB(LANG) "MC(msg,limit_to_change_license)"            "Nie jesteś autorem tego postprocesora. \nNie masz uprawnień do zmiany jego nazwy ani licencji."
::msgcat::mcset $gPB(LANG) "MC(output,other_opts,validation,msg)"       "Należy podać nazwę pliku tcl użytkownika."
::msgcat::mcset $gPB(LANG) "MC(machine,empty_entry_err,msg)"            "Na tej stronie parametrów występują puste wpisy."
::msgcat::mcset $gPB(LANG) "MC(msg,control_v_limit)"                    "Łańcuch, który próbujesz wkleić, może \n przekraczać ograniczenie długości, \n zawierać wiele wierszy lub nieprawidłowe znaki."
::msgcat::mcset $gPB(LANG) "MC(block,capital_name_msg)"                 "Znak wiodący nazwy bloku nie może być wielką literą!\n Podaj inną nazwę."
::msgcat::mcset $gPB(LANG) "MC(machine,axis,violation,user,Label)"      "Użytkownika"
::msgcat::mcset $gPB(LANG) "MC(machine,axis,violation,user,Handler)"    "Program obsługi"
::msgcat::mcset $gPB(LANG) "MC(new,user,file,NOT_EXIST)"                "Ten plik użytkownika nie istnieje!"
::msgcat::mcset $gPB(LANG) "MC(new,include_vnc,Label)"                  "Uwzględnij wirtualny kontroler NC"
::msgcat::mcset $gPB(LANG) "MC(other,opt_equal,Label)"                  "Znak równości (=)"
::msgcat::mcset $gPB(LANG) "MC(event,nurbs,name)"                       "Ruch NURBS"
::msgcat::mcset $gPB(LANG) "MC(event,cycle,tap_float,name)"             "Gwintowanie z uchwytem zmiennym"
::msgcat::mcset $gPB(LANG) "MC(event,cycle,thread,name)"                "Gwint"
::msgcat::mcset $gPB(LANG) "MC(ude,editor,group,MSG_NESTED_GROUP)"      "Grupowanie zagnieżdżone nie jest obsługiwane!"
::msgcat::mcset $gPB(LANG) "MC(ude,editor,bmp,Label)"                   "Bitmapa"
::msgcat::mcset $gPB(LANG) "MC(ude,editor,bmp,Context)"                 "Dodaj nowy parametr bitmapy przez przeciągnięcie do listy z prawej strony."
::msgcat::mcset $gPB(LANG) "MC(ude,editor,group,Label)"                 "Grupa"
::msgcat::mcset $gPB(LANG) "MC(ude,editor,group,Context)"               "Dodaj nowy parametr grupowania przez przeciągnięcie do listy z prawej strony."
::msgcat::mcset $gPB(LANG) "MC(ude,editor,eventdlg,DESC,Label)"         "Opis"
::msgcat::mcset $gPB(LANG) "MC(ude,editor,eventdlg,DESC,Context)"       "Określ informacje zdarzenia"
::msgcat::mcset $gPB(LANG) "MC(ude,editor,eventdlg,URL,Label)"          "URL"
::msgcat::mcset $gPB(LANG) "MC(ude,editor,eventdlg,URL,Context)"        "Określ adres URL dla opisu zdarzenia"
::msgcat::mcset $gPB(LANG) "MC(ude,editor,param,MSG_WRONG_IMAGE_FILE)"  "Plik obrazu musi być w formacie BMP!"
::msgcat::mcset $gPB(LANG) "MC(ude,editor,param,MSG_WRONG_IMAGE_FOLDER)" "Nazwa pliku bitmapy nie może zawierać ścieżki katalogu!"
::msgcat::mcset $gPB(LANG) "MC(ude,editor,param,MSG_WRONG_VAR_NAME)"    "Nazwa zmiennej musi rozpoczynać się literą."
::msgcat::mcset $gPB(LANG) "MC(ude,editor,param,MSG_WRONG_KEYWORD)"     "W nazwie zmiennej nie może występować słowo kluczowe: "
::msgcat::mcset $gPB(LANG) "MC(ude,editor,status_label)"                "Status"
::msgcat::mcset $gPB(LANG) "MC(ude,editor,vector,Label)"                "Wektor"
::msgcat::mcset $gPB(LANG) "MC(ude,editor,vector,Context)"              "Dodaj nowy parametr wektora przez przeciągnięcie do listy z prawej strony."
::msgcat::mcset $gPB(LANG) "MC(ude,editor,popup,MSG_URL_FORMAT)"        "Adres URL musi być w formacie \"http://*\" lub \"file://*\" bez ukośnika odwrotnego."
::msgcat::mcset $gPB(LANG) "MC(ude,editor,popup,MSG_BLANK_HELP_INFO)"   "Należy określić opis i adres URL!"
::msgcat::mcset $gPB(LANG) "MC(new,MSG_NO_AXIS)"                        "Należy wybrać konfigurację osi dla obrabiarki."
::msgcat::mcset $gPB(LANG) "MC(machine,info,controller_type,Label)"     "Rodzina sterownika"
::msgcat::mcset $gPB(LANG) "MC(block,func_combo,Label)"                 "Makro"
::msgcat::mcset $gPB(LANG) "MC(block,prefix_popup,add,Label)"           "Dodaj tekst przedrostka"
::msgcat::mcset $gPB(LANG) "MC(block,prefix_popup,edit,Label)"          "Edytuj tekst przedrostka"
::msgcat::mcset $gPB(LANG) "MC(block,prefix,Label)"                     "Przedrostek"
::msgcat::mcset $gPB(LANG) "MC(block,suppress_popup,Label)"             "Zablokuj kolejny numer"
::msgcat::mcset $gPB(LANG) "MC(block,custom_func,Label)"                "Makro niestandardowe"
::msgcat::mcset $gPB(LANG) "MC(seq,combo,macro,Label)"                  "Makro niestandardowe"
::msgcat::mcset $gPB(LANG) "MC(func,tab,Label)"                         "Makro"
::msgcat::mcset $gPB(LANG) "MC(func,exp,msg)"                           "Wyrażenie dla parametru makra nie może być puste."
::msgcat::mcset $gPB(LANG) "MC(func,edit,name,Label)"                   "Nazwa makra"
::msgcat::mcset $gPB(LANG) "MC(func,disp_name,Label)"                   "Wyjściowa nazwa"
::msgcat::mcset $gPB(LANG) "MC(func,param_list,Label)"                  "Lista parametrów"
::msgcat::mcset $gPB(LANG) "MC(func,separator,Label)"                   "Separator"
::msgcat::mcset $gPB(LANG) "MC(func,start,Label)"                       "Znak początkowy"
::msgcat::mcset $gPB(LANG) "MC(func,end,Label)"                         "Znak końcowy"
::msgcat::mcset $gPB(LANG) "MC(func,output,name,Label)"                 "Atrybut wyjściowy"
::msgcat::mcset $gPB(LANG) "MC(func,output,check,Label)"                "Nazwa atrybutów wyjściowych"
::msgcat::mcset $gPB(LANG) "MC(func,output,link,Label)"                 "Znak łącza"
::msgcat::mcset $gPB(LANG) "MC(func,col_param,Label)"                   "Parametr"
::msgcat::mcset $gPB(LANG) "MC(func,col_exp,Label)"                     "Wyrażenie"
::msgcat::mcset $gPB(LANG) "MC(func,popup,insert,Label)"                "Nowy"
::msgcat::mcset $gPB(LANG) "MC(func,name,err_msg)"                      "Nazwa makra nie może zawierać spacji!"
::msgcat::mcset $gPB(LANG) "MC(func,name,blank_err)"                    "Nazwa makra nie może być pusta!"
::msgcat::mcset $gPB(LANG) "MC(func,name,contain_err)"                  "Nazwa makra powinna zawierać wyłącznie litery, cyfry i znaki podkreślenia!"
::msgcat::mcset $gPB(LANG) "MC(func,tree_node,start_err)"               "Nazwa węzła musi rozpoczynać się wielką literą!"
::msgcat::mcset $gPB(LANG) "MC(func,tree_node,contain_err)"             "W nazwie węzła można używać wyłącznie liter, cyfr i znaków podkreślenia!"
::msgcat::mcset $gPB(LANG) "MC(func,help,Label)"                        "Informacje"
::msgcat::mcset $gPB(LANG) "MC(func,help,Context)"                      "Pokaż informacje o obiekcie."
::msgcat::mcset $gPB(LANG) "MC(func,help,MSG_NO_INFO)"                  "Dla tego makra nie podano żadnych informacji."


##------
## Title
##
::msgcat::mcset $gPB(LANG) "MC(main,title,Unigraphics)"             "Unigraphics"
::msgcat::mcset $gPB(LANG) "MC(main,title,UG)"                      "NX"
::msgcat::mcset $gPB(LANG) "MC(main,title,Post_Builder)"            "Post Builder"

::msgcat::mcset $gPB(LANG) "MC(main,title,Version)"                 "Wersja"
::msgcat::mcset $gPB(LANG) "MC(main,default,Status)"                "Z menu Plik wybierz opcję Nowy lub Otwórz."
::msgcat::mcset $gPB(LANG) "MC(main,save,Status)"                   "Zapisz postprocesor."

##------
## File
##
::msgcat::mcset $gPB(LANG) "MC(main,file,Label)"                    "Plik"

::msgcat::mcset $gPB(LANG) "MC(main,file,Balloon)"                  "\ Nowy, Otwórz, Zapisz,\n Zapisz\ jako, Zamknij i Zakończ"

::msgcat::mcset $gPB(LANG) "MC(main,file,Context)"                  "\ Nowy, Otwórz, Zapisz,\n Zapisz\ jako, Zamknij i Zakończ"
::msgcat::mcset $gPB(LANG) "MC(main,file,menu,Context)"             " "

::msgcat::mcset $gPB(LANG) "MC(main,file,new,Label)"                "Nowy..."
::msgcat::mcset $gPB(LANG) "MC(main,file,new,Balloon)"              "Utwórz nowy postprocesor."
::msgcat::mcset $gPB(LANG) "MC(main,file,new,Context)"              "Utwórz nowy postprocesor."
::msgcat::mcset $gPB(LANG) "MC(main,file,new,Busy)"                 "Tworzenie nowego postprocesora..."

::msgcat::mcset $gPB(LANG) "MC(main,file,open,Label)"               "Otwórz..."
::msgcat::mcset $gPB(LANG) "MC(main,file,open,Balloon)"             "Edytuj istniejący postprocesor."
::msgcat::mcset $gPB(LANG) "MC(main,file,open,Context)"             "Edytuj istniejący postprocesor."
::msgcat::mcset $gPB(LANG) "MC(main,file,open,Busy)"                "Otwieranie postprocesora..."

::msgcat::mcset $gPB(LANG) "MC(main,file,mdfa,Label)"               "Importuj MDFA..."
::msgcat::mcset $gPB(LANG) "MC(main,file,mdfa,Balloon)"             "Utwórz nowy postprocesor z MDFA."
::msgcat::mcset $gPB(LANG) "MC(main,file,mdfa,Context)"             "Utwórz nowy postprocesor z MDFA."

::msgcat::mcset $gPB(LANG) "MC(main,file,save,Label)"               "Zapisz"
::msgcat::mcset $gPB(LANG) "MC(main,file,save,Balloon)"             "Zapisz postprocesor w toku."
::msgcat::mcset $gPB(LANG) "MC(main,file,save,Context)"             "Zapisz postprocesor w toku."
::msgcat::mcset $gPB(LANG) "MC(main,file,save,Busy)"                "Zapisywanie postprocesora..."

::msgcat::mcset $gPB(LANG) "MC(main,file,save_as,Label)"            "Zapisz jako..."
::msgcat::mcset $gPB(LANG) "MC(main,file,save_as,Balloon)"          "Zapisz postprocesor pod nową nazwą."
::msgcat::mcset $gPB(LANG) "MC(main,file,save_as,Context)"          "Zapisz postprocesor pod nową nazwą."

::msgcat::mcset $gPB(LANG) "MC(main,file,close,Label)"              "Zamknij"
::msgcat::mcset $gPB(LANG) "MC(main,file,close,Balloon)"            "Zamknij postprocesor w toku."
::msgcat::mcset $gPB(LANG) "MC(main,file,close,Context)"            "Zamknij postprocesor w toku."

::msgcat::mcset $gPB(LANG) "MC(main,file,exit,Label)"               "Zakończ"
::msgcat::mcset $gPB(LANG) "MC(main,file,exit,Balloon)"             "Zakończ pracę programu Post Builder."
::msgcat::mcset $gPB(LANG) "MC(main,file,exit,Context)"             "Zakończ pracę programu Post Builder."

::msgcat::mcset $gPB(LANG) "MC(main,file,history,Label)"            "Ostatnio otwarte postprocesory"
::msgcat::mcset $gPB(LANG) "MC(main,file,history,Balloon)"          "Edytuj wcześniej odwiedzony postprocesor."
::msgcat::mcset $gPB(LANG) "MC(main,file,history,Context)"          "Edytuj postprocesor odwiedzony podczas wcześniejszych sesji programu Post Builder."

##---------
## Options
##
::msgcat::mcset $gPB(LANG) "MC(main,options,Label)"                 "Opcje"

::msgcat::mcset $gPB(LANG) "MC(main,options,Balloon)"               " Sprawdź poprawność\ poleceń\ niestandardowych, Kopia zapasowa\ postprocesora"
::msgcat::mcset $gPB(LANG) "MC(main,options,Context)"               " "
::msgcat::mcset $gPB(LANG) "MC(main,options,menu,Context)"          " "

::msgcat::mcset $gPB(LANG) "MC(main,windows,Label)"                 "Okna"
::msgcat::mcset $gPB(LANG) "MC(main,windows,Balloon)"               "Lista edytowania postprocesorów"
::msgcat::mcset $gPB(LANG) "MC(main,windows,Context)"               " "
::msgcat::mcset $gPB(LANG) "MC(main,windows,menu,Context)"          " "

::msgcat::mcset $gPB(LANG) "MC(main,options,properties,Label)"      "Właściwości"
::msgcat::mcset $gPB(LANG) "MC(main,options,properties,Balloon)"    "Właściwości"
::msgcat::mcset $gPB(LANG) "MC(main,options,properties,Context)"    "Właściwości"

::msgcat::mcset $gPB(LANG) "MC(main,options,advisor,Label)"         "Doradca postprocesora"
::msgcat::mcset $gPB(LANG) "MC(main,options,advisor,Balloon)"       "Doradca postprocesora"
::msgcat::mcset $gPB(LANG) "MC(main,options,advisor,Context)"       "Włącz/wyłącz doradcę postprocesora."

::msgcat::mcset $gPB(LANG) "MC(main,options,cmd_check,Label)"       "Sprawdź poprawność poleceń niestandardowych"
::msgcat::mcset $gPB(LANG) "MC(main,options,cmd_check,Balloon)"     "Sprawdź poprawność poleceń niestandardowych"
::msgcat::mcset $gPB(LANG) "MC(main,options,cmd_check,Context)"     "Przełączniki do sprawdzania poprawności poleceń niestandardowych"

::msgcat::mcset $gPB(LANG) "MC(main,options,cmd_check,syntax,Label)"   "Błędy składni"
::msgcat::mcset $gPB(LANG) "MC(main,options,cmd_check,command,Label)"  "Nieznane polecenia"
::msgcat::mcset $gPB(LANG) "MC(main,options,cmd_check,block,Label)"    "Nieznane bloki"
::msgcat::mcset $gPB(LANG) "MC(main,options,cmd_check,address,Label)"  "Nieznane adresy"
::msgcat::mcset $gPB(LANG) "MC(main,options,cmd_check,format,Label)"   "Nieznane formaty"

::msgcat::mcset $gPB(LANG) "MC(main,options,backup,Label)"          "Kopia zapasowa postprocesora"
::msgcat::mcset $gPB(LANG) "MC(main,options,backup,Balloon)"        "Metoda kopii zapasowej postprocesora"
::msgcat::mcset $gPB(LANG) "MC(main,options,backup,Context)"        "Utwórz kopie zapasowe podczas zapisywania postprocesora w toku."

::msgcat::mcset $gPB(LANG) "MC(main,options,backup,one,Label)"      "Kopia zapasowa oryginału"
::msgcat::mcset $gPB(LANG) "MC(main,options,backup,all,Label)"      "Twórz kopię zapasową podczas każdego zapisu"
::msgcat::mcset $gPB(LANG) "MC(main,options,backup,none,Label)"     "Brak kopii zapasowej"

##-----------
## Utilities
##
::msgcat::mcset $gPB(LANG) "MC(main,utils,Label)"                   "Narzędzia"
::msgcat::mcset $gPB(LANG) "MC(main,utils,Balloon)"                 "\ Wybierz\ zmienną\ MOM, Instaluj\ postprocesor"
::msgcat::mcset $gPB(LANG) "MC(main,utils,Context)"                 " "
::msgcat::mcset $gPB(LANG) "MC(main,utils,menu,Context)"            " "

::msgcat::mcset $gPB(LANG) "MC(main,utils,etpdf,Label)"             "Edytuj plik danych postprocesora szablonów"

::msgcat::mcset $gPB(LANG) "MC(main,utils,bmv,Label)"               "Przeglądaj zmienne MOM"
::msgcat::mcset $gPB(LANG) "MC(main,utils,blic,Label)"              "Przeglądaj licencje"


##------
## Help
##
::msgcat::mcset $gPB(LANG) "MC(main,help,Label)"                    "Pomoc"
::msgcat::mcset $gPB(LANG) "MC(main,help,Balloon)"                  "Opcje pomocy"
::msgcat::mcset $gPB(LANG) "MC(main,help,Context)"                  "Opcje pomocy"
::msgcat::mcset $gPB(LANG) "MC(main,help,menu,Context)"             " "

::msgcat::mcset $gPB(LANG) "MC(main,help,bal,Label)"                "Wskazówka symbolu pozycji"
::msgcat::mcset $gPB(LANG) "MC(main,help,bal,Balloon)"              "Wskazówka symbolu pozycji na ikonach"
::msgcat::mcset $gPB(LANG) "MC(main,help,bal,Context)"              "Włącz/wyłącz wyświetlanie wskazówek symboli pozycji dla ikon."

::msgcat::mcset $gPB(LANG) "MC(main,help,chelp,Label)"              "Pomoc kontekstowa"
::msgcat::mcset $gPB(LANG) "MC(main,help,chelp,Balloon)"            "Pomoc kontekstowa dla obiektów w oknie dialogowym"
::msgcat::mcset $gPB(LANG) "MC(main,help,chelp,Context)"            "Pomoc kontekstowa dla obiektów w oknie dialogowym"

::msgcat::mcset $gPB(LANG) "MC(main,help,what,Label)"               "Co zrobić?"
::msgcat::mcset $gPB(LANG) "MC(main,help,what,Balloon)"             "Co można tutaj zrobić?"
::msgcat::mcset $gPB(LANG) "MC(main,help,what,Context)"             "Co można tutaj zrobić?"

::msgcat::mcset $gPB(LANG) "MC(main,help,dialog,Label)"             "Pomoc dla okna dialogowego"
::msgcat::mcset $gPB(LANG) "MC(main,help,dialog,Balloon)"           "Pomoc dla tego okna dialogowego"
::msgcat::mcset $gPB(LANG) "MC(main,help,dialog,Context)"           "Pomoc dla tego okna dialogowego"

::msgcat::mcset $gPB(LANG) "MC(main,help,manual,Label)"             "Podręcznik użytkownika"
::msgcat::mcset $gPB(LANG) "MC(main,help,manual,Balloon)"           "Podręcznik pomocy użytkownika"
::msgcat::mcset $gPB(LANG) "MC(main,help,manual,Context)"           "Podręcznik pomocy użytkownika"

::msgcat::mcset $gPB(LANG) "MC(main,help,about,Label)"              "Post Builder - informacje"
::msgcat::mcset $gPB(LANG) "MC(main,help,about,Balloon)"            "Post Builder - informacje"
::msgcat::mcset $gPB(LANG) "MC(main,help,about,Context)"            "Post Builder - informacje"

::msgcat::mcset $gPB(LANG) "MC(main,help,rel_note,Label)"           "Wskazówki do wersji"
::msgcat::mcset $gPB(LANG) "MC(main,help,rel_note,Balloon)"         "Wskazówki do wersji"
::msgcat::mcset $gPB(LANG) "MC(main,help,rel_note,Context)"         "Wskazówki do wersji"

::msgcat::mcset $gPB(LANG) "MC(main,help,tcl_man,Label)"            "Podręczniki Tcl/Tk"
::msgcat::mcset $gPB(LANG) "MC(main,help,tcl_man,Balloon)"          "Podręczniki Tcl/Tk"
::msgcat::mcset $gPB(LANG) "MC(main,help,tcl_man,Context)"          "Podręczniki Tcl/Tk"

##----------
## Tool Bar
##
::msgcat::mcset $gPB(LANG) "MC(tool,new,Label)"                     "Nowy"
::msgcat::mcset $gPB(LANG) "MC(tool,new,Context)"                   "Utwórz nowy postprocesor."

::msgcat::mcset $gPB(LANG) "MC(tool,open,Label)"                    "Otwórz"
::msgcat::mcset $gPB(LANG) "MC(tool,open,Context)"                  "Edytuj istniejący postprocesor."

::msgcat::mcset $gPB(LANG) "MC(tool,save,Label)"                    "Zapisz"
::msgcat::mcset $gPB(LANG) "MC(tool,save,Context)"                  "Zapisz postprocesor w toku."

::msgcat::mcset $gPB(LANG) "MC(tool,bal,Label)"                     "Wskazówka symbolu pozycji"
::msgcat::mcset $gPB(LANG) "MC(tool,bal,Context)"                   "Włącz/wyłącz wyświetlanie wskazówek symboli pozycji dla ikon."

::msgcat::mcset $gPB(LANG) "MC(tool,chelp,Label)"                   "Pomoc kontekstowa"
::msgcat::mcset $gPB(LANG) "MC(tool,chelp,Context)"                 "Pomoc kontekstowa dla obiektów w oknie dialogowym"

::msgcat::mcset $gPB(LANG) "MC(tool,what,Label)"                    "Co zrobić?"
::msgcat::mcset $gPB(LANG) "MC(tool,what,Context)"                  "Co można tutaj zrobić?"

::msgcat::mcset $gPB(LANG) "MC(tool,dialog,Label)"                  "Pomoc dla okna dialogowego"
::msgcat::mcset $gPB(LANG) "MC(tool,dialog,Context)"                "Pomoc dla tego okna dialogowego"

::msgcat::mcset $gPB(LANG) "MC(tool,manual,Label)"                  "Podręcznik użytkownika"
::msgcat::mcset $gPB(LANG) "MC(tool,manual,Context)"                "Podręcznik pomocy użytkownika"

#=============
# Main Window
#=============

##-----------------
## Common Messages
##
::msgcat::mcset $gPB(LANG) "MC(msg,error,title)"                    "Błąd programu Post Builder"
::msgcat::mcset $gPB(LANG) "MC(msg,dialog,title)"                   "Komunikat programu Post Builder"
::msgcat::mcset $gPB(LANG) "MC(msg,warning)"                        "Ostrzeżenie"
::msgcat::mcset $gPB(LANG) "MC(msg,error)"                          "Błąd"
::msgcat::mcset $gPB(LANG) "MC(msg,invalid_data)"                   "Wprowadzono nieprawidłowe dane dla parametru"
::msgcat::mcset $gPB(LANG) "MC(msg,invalid_browser_cmd)"            "Nieprawidłowe polecenie przeglądarki:"
::msgcat::mcset $gPB(LANG) "MC(msg,wrong_filename)"                 "Nazwa pliku została zmieniona!"
::msgcat::mcset $gPB(LANG) "MC(msg,user_ctrl_limit)"                "Licencjonowany postprocesor nie może być używany jako sterownik\n podczas tworzenia nowego postprocesora, jeśli nie jesteś autorem!"
::msgcat::mcset $gPB(LANG) "MC(msg,import_limit)"                   "Nie jesteś autorem tego licencjonowanego postprocesora.\n Nie można zaimportować poleceń niestandardowych!"
::msgcat::mcset $gPB(LANG) "MC(msg,limit_msg)"                      "Nie jesteś autorem tego licencjonowanego postprocesora!"
::msgcat::mcset $gPB(LANG) "MC(msg,no_file)"                        "Brak pliku zaszyfrowanego dla tego licencjonowanego postprocesora!"
::msgcat::mcset $gPB(LANG) "MC(msg,no_license)"                     "Nie masz odpowiedniej licencji do wykonania tej funkcji!"
::msgcat::mcset $gPB(LANG) "MC(msg,no_license_title)"               "Nielicencjonowane użycie programu NX/Post Builder"
::msgcat::mcset $gPB(LANG) "MC(msg,no_license_dialog)"              "Możesz używać programu NX/Post Builder\n bez odpowiedniej licencji. Zapisanie wyników\n pracy nie będzie jednak możliwe."
::msgcat::mcset $gPB(LANG) "MC(msg,pending)"                        "Obsługa tej opcji zostanie wdrożona w kolejnych wydaniach."
::msgcat::mcset $gPB(LANG) "MC(msg,save)"                           "Czy chcesz zapisać zmiany\n przed zamknięciem postprocesora w toku?"
::msgcat::mcset $gPB(LANG) "MC(msg,version_check)"                  "W tej wersji programu Post Builder nie można otworzyć postprocesora utworzonego w nowszej wersji tego programu."

::msgcat::mcset $gPB(LANG) "MC(msg,file_corruption)"                "Nieprawidłowa zawartość pliku sesji programu Post Builder."
::msgcat::mcset $gPB(LANG) "MC(msg,bad_tcl_file)"                   "Nieprawidłowa zawartość pliku Tcl tego postprocesora."
::msgcat::mcset $gPB(LANG) "MC(msg,bad_def_file)"                   "Nieprawidłowa zawartość pliku definicji tego postprocesora."
::msgcat::mcset $gPB(LANG) "MC(msg,invalid_post)"                   "Należy określić co najmniej jeden zestaw plików Tcl i definicji dla tego postprocesora."
::msgcat::mcset $gPB(LANG) "MC(msg,invalid_dir)"                    "Katalog nie istnieje."
::msgcat::mcset $gPB(LANG) "MC(msg,invalid_file)"                   "Nie znaleziono pliku lub plik jest nieprawidłowy."
::msgcat::mcset $gPB(LANG) "MC(msg,invalid_def_file)"               "Nie można otworzyć pliku definicji"
::msgcat::mcset $gPB(LANG) "MC(msg,invalid_tcl_file)"               "Nie można otworzyć pliku programu obsługi zdarzeń"
::msgcat::mcset $gPB(LANG) "MC(msg,dir_perm)"                       "Nie masz uprawnień do zapisu w katalogu:"
::msgcat::mcset $gPB(LANG) "MC(msg,file_perm)"                      "Nie masz uprawnień do zapisu w"

::msgcat::mcset $gPB(LANG) "MC(msg,file_exist)"                     "już istnieją! \nCzy mimo to chcesz je zastąpić?"
::msgcat::mcset $gPB(LANG) "MC(msg,file_missing)"                   "Brakuje niektórych lub wszystkich plików tego postprocesora.\n Nie można otworzyć tego postprocesora."
::msgcat::mcset $gPB(LANG) "MC(msg,sub_dialog_open)"                "Przed zapisaniem tego postprocesora należy zakończyć edycję we wszystkich podrzędnych oknach dialogowych parametrów!"
::msgcat::mcset $gPB(LANG) "MC(msg,generic)"                        "Program Post Builder został obecnie wdrożony tylko dla frezarek ogólnych."
::msgcat::mcset $gPB(LANG) "MC(msg,min_word)"                       "Blok powinien zawierać co najmniej jedno słowo."
::msgcat::mcset $gPB(LANG) "MC(msg,name_exists)"                    "już istnieje!\n Podaj inną nazwę."
::msgcat::mcset $gPB(LANG) "MC(msg,in_use)"                         "Ten komponent jest używany.\n Nie można go usunąć."
::msgcat::mcset $gPB(LANG) "MC(msg,do_you_want_to_proceed)"         "Można je przyjąć jako elementy istniejących danych i kontynuować."
::msgcat::mcset $gPB(LANG) "MC(msg,not_installed_properly)"         "nie zainstalowano pomyślnie."
::msgcat::mcset $gPB(LANG) "MC(msg,no_app_to_open)"                 "Brak aplikacji do otwarcia"
::msgcat::mcset $gPB(LANG) "MC(msg,save_change)"                    "Czy zapisać te zmiany?"

::msgcat::mcset $gPB(LANG) "MC(msg,external_editor)"                "Edytor zewnętrzny"

# - Do not translate EDITOR
::msgcat::mcset $gPB(LANG) "MC(msg,set_ext_editor)"                 "Można użyć zmiennej środowiskowej EDITOR, aby uaktywnić ulubiony edytor tekstu."
::msgcat::mcset $gPB(LANG) "MC(msg,filename_with_space)"            "Nazwa pliku zawierająca spacje nie jest obsługiwana!"
::msgcat::mcset $gPB(LANG) "MC(msg,filename_protection)"            "Nie można zastąpić wybranego pliku, używanego przez jeden z edytowanych postprocesorów!"


##--------------------
## Common Function
##
::msgcat::mcset $gPB(LANG) "MC(msg,parent_win)"                     "Okno przejściowe wymaga zdefiniowania okna nadrzędnego."
::msgcat::mcset $gPB(LANG) "MC(msg,close_subwin)"                   "Aby włączyć tę kartę, należy zamknąć wszystkie okna podrzędne."
::msgcat::mcset $gPB(LANG) "MC(msg,block_exist)"                    "W szablonie bloku występuje element wybranego słowa."
::msgcat::mcset $gPB(LANG) "MC(msg,num_gcode_1)"                    "Liczba kodów G jest ograniczona do"
::msgcat::mcset $gPB(LANG) "MC(msg,num_gcode_2)"                    "na blok"
::msgcat::mcset $gPB(LANG) "MC(msg,num_mcode_1)"                    "Liczba kodów M jest ograniczona do"
::msgcat::mcset $gPB(LANG) "MC(msg,num_mcode_2)"                    "na blok"
::msgcat::mcset $gPB(LANG) "MC(msg,empty_entry)"                    "Wpis nie powinien być pusty."

::msgcat::mcset $gPB(LANG) "MC(msg,edit_feed_fmt)"                  "Formaty adresu \"F\" można edytować na stronie parametrów Prędkości posuwu"

::msgcat::mcset $gPB(LANG) "MC(msg,seq_num_max)"                    "Maksymalna wartość Kolejny numer nie powinna przekraczać pojemności N adresów"

::msgcat::mcset $gPB(LANG) "MC(msg,no_cdl_name)"                    "Należy określić nazwę postprocesora!"
::msgcat::mcset $gPB(LANG) "MC(msg,no_def_name)"                    "Należy określić nazwę folderu!\n Szyk powinien mieć postać \"\$UGII_*\"!"
::msgcat::mcset $gPB(LANG) "MC(msg,no_own_name)"                    "Należy określić nazwę folderu!\n Szyk powinien mieć postać \"\$UGII_*\"!"
::msgcat::mcset $gPB(LANG) "MC(msg,no_oth_ude_name)"                "Należy określić nazwę innego pliku cdl!\n Szyk powinien mieć postać \"\$UGII_*\"!"
::msgcat::mcset $gPB(LANG) "MC(msg,not_oth_cdl_file)"               "Dozwolony jest tylko plik CDL!"
::msgcat::mcset $gPB(LANG) "MC(msg,not_pui_file)"                   "Dozwolony jest tylko plik PUI!"
::msgcat::mcset $gPB(LANG) "MC(msg,not_cdl_file)"                   "Dozwolony jest tylko plik CDL!"
::msgcat::mcset $gPB(LANG) "MC(msg,not_def_file)"                   "Dozwolony jest tylko plik DEF!"
::msgcat::mcset $gPB(LANG) "MC(msg,not_own_cdl_file)"               "Dozwolony jest tylko własny plik CDL!"
::msgcat::mcset $gPB(LANG) "MC(msg,no_cdl_file)"                    "Wybrany postprocesor nie zawiera powiązanego pliku CDL."
::msgcat::mcset $gPB(LANG) "MC(msg,cdl_info)"                       "Pliki CDL i definicji wybranego postprocesora zostaną powiązane (UWZGLĘDNIJ) w pliku definicji tego postprocesora.\n Plik Tcl wybranego postprocesora będzie pochodzić z pliku programu obsługi zdarzeń tego postprocesora podczas działania."

::msgcat::mcset $gPB(LANG) "MC(msg,add_max1)"                       "Maksymalna wartość adresu"
::msgcat::mcset $gPB(LANG) "MC(msg,add_max2)"                       "nie powinna przekraczać pojemności formatu"


::msgcat::mcset $gPB(LANG) "MC(com,text_entry_trans,title,Label)"   "Wejście"

##---------------------------
## Common Navigation Buttons
##
::msgcat::mcset $gPB(LANG) "MC(nav_button,no_license,Message)"      "Nie masz odpowiedniej licencji do wykonania tej funkcji!"

::msgcat::mcset $gPB(LANG) "MC(nav_button,ok,Label)"                "OK"
::msgcat::mcset $gPB(LANG) "MC(nav_button,ok,Context)"              "Ten przycisk jest dostępny wyłącznie w podrzędnym oknie dialogowym. Umożliwia zapisanie zmian i zamknięcie danego okna dialogowego."
::msgcat::mcset $gPB(LANG) "MC(nav_button,cancel,Label)"            "Anuluj"
::msgcat::mcset $gPB(LANG) "MC(nav_button,cancel,Context)"          "Ten przycisk jest dostępny wyłącznie w podrzędnym oknie dialogowym. Umożliwia zamknięcie danego okna dialogowego."
::msgcat::mcset $gPB(LANG) "MC(nav_button,default,Label)"           "Domyślnie"
::msgcat::mcset $gPB(LANG) "MC(nav_button,default,Context)"         "Ten przycisk umożliwia przywrócenie parametrów w bieżącym oknie dialogowym komponentu do stanu w momencie utworzenia lub otwarcia postprocesora w sesji. \n \nJednakże nazwa danego komponentu, jeśli występuje, zostanie przywrócona tylko do stanu początkowego bieżącej wizyty w tym komponencie."
::msgcat::mcset $gPB(LANG) "MC(nav_button,restore,Label)"           "Przywróć"
::msgcat::mcset $gPB(LANG) "MC(nav_button,restore,Context)"         "Ten przycisk umożliwia przywrócenie początkowych ustawień parametrów w bieżącym oknie dialogowym bieżącej wizyty w tym komponencie."
::msgcat::mcset $gPB(LANG) "MC(nav_button,apply,Label)"             "Zastosuj"
::msgcat::mcset $gPB(LANG) "MC(nav_button,apply,Context)"           "Ten przycisk umożliwia zapisanie zmian bez zamykania bieżącego okna dialogowego. Spowoduje również ponowne ustawienie stanu początkowego bieżącego okna dialogowego. \n \n(Patrz polecenie Przywróć, aby uzyskać informacje dotyczące stanu początkowego)"
::msgcat::mcset $gPB(LANG) "MC(nav_button,filter,Label)"            "Filtr"
::msgcat::mcset $gPB(LANG) "MC(nav_button,filter,Context)"          "Ten przycisk spowoduje zastosowanie filtra katalogów i wyświetlenie listy spełniającej ten warunek."
::msgcat::mcset $gPB(LANG) "MC(nav_button,yes,Label)"               "Tak"
::msgcat::mcset $gPB(LANG) "MC(nav_button,yes,Context)"             "Tak"
::msgcat::mcset $gPB(LANG) "MC(nav_button,no,Label)"                "Nie"
::msgcat::mcset $gPB(LANG) "MC(nav_button,no,Context)"              "Nie"
::msgcat::mcset $gPB(LANG) "MC(nav_button,help,Label)"              "Pomoc"
::msgcat::mcset $gPB(LANG) "MC(nav_button,help,Context)"            "Pomoc"

::msgcat::mcset $gPB(LANG) "MC(nav_button,open,Label)"              "Otwórz"
::msgcat::mcset $gPB(LANG) "MC(nav_button,open,Context)"            "Ten przycisk umożliwia otworzenie wybranego postprocesora do edycji."

::msgcat::mcset $gPB(LANG) "MC(nav_button,save,Label)"              "Zapisz"
::msgcat::mcset $gPB(LANG) "MC(nav_button,save,Context)"            "Ten przycisk jest dostępny w oknie dialogowym Zapisz jako i umożliwia zapisanie postprocesora w toku."

::msgcat::mcset $gPB(LANG) "MC(nav_button,manage,Label)"            "Zarządzaj..."
::msgcat::mcset $gPB(LANG) "MC(nav_button,manage,Context)"          "Ten przycisk umożliwia zarządzanie historią ostatnio odwiedzonych postprocesorów."

::msgcat::mcset $gPB(LANG) "MC(nav_button,refresh,Label)"           "Odśwież"
::msgcat::mcset $gPB(LANG) "MC(nav_button,refresh,Context)"         "Ten przycisk odświeża listę według obecności obiektów."

::msgcat::mcset $gPB(LANG) "MC(nav_button,cut,Label)"               "Wytnij"
::msgcat::mcset $gPB(LANG) "MC(nav_button,cut,Context)"             "Ten przycisk umożliwia wycięcie wybranego obiektu z listy."

::msgcat::mcset $gPB(LANG) "MC(nav_button,copy,Label)"              "Kopiuj"
::msgcat::mcset $gPB(LANG) "MC(nav_button,copy,Context)"            "Ten przycisk umożliwia skopiowanie wybranego obiektu."

::msgcat::mcset $gPB(LANG) "MC(nav_button,paste,Label)"             "Wklej"
::msgcat::mcset $gPB(LANG) "MC(nav_button,paste,Context)"           "Ten przycisk umożliwia wklejenie obiektu w buforze na liście."

::msgcat::mcset $gPB(LANG) "MC(nav_button,edit,Label)"              "Edytuj"
::msgcat::mcset $gPB(LANG) "MC(nav_button,edit,Context)"            "Ten przycisk umożliwia edytowanie obiektu w buforze!"

::msgcat::mcset $gPB(LANG) "MC(nav_button,ex_editor,Label)"         "Użyj edytora zewnętrznego"

##------------
## New dialog
##
::msgcat::mcset $gPB(LANG) "MC(new,title,Label)"                    "Utwórz nowy postprocesor"
::msgcat::mcset $gPB(LANG) "MC(new,Status)"                         "Wprowadź nazwę i wybierz parametr nowego postprocesora."

::msgcat::mcset $gPB(LANG) "MC(new,name,Label)"                     "Nazwa postprocesora"
::msgcat::mcset $gPB(LANG) "MC(new,name,Context)"                   "Nazwa postprocesora, który należy utworzyć"

::msgcat::mcset $gPB(LANG) "MC(new,desc,Label)"                     "Opis"
::msgcat::mcset $gPB(LANG) "MC(new,desc,Context)"                   "Opis postprocesora, który należy utworzyć"

#Description for each selection
::msgcat::mcset $gPB(LANG) "MC(new,mill,desc,Label)"                "To jest frezarka."
::msgcat::mcset $gPB(LANG) "MC(new,lathe,desc,Label)"               "To jest tokarka."
::msgcat::mcset $gPB(LANG) "MC(new,wedm,desc,Label)"                "To jest obrabiarka drutów EDM."

::msgcat::mcset $gPB(LANG) "MC(new,wedm_2,desc,Label)"              "To jest 2-osiowa obrabiarka drutów EDM."
::msgcat::mcset $gPB(LANG) "MC(new,wedm_4,desc,Label)"              "To jest 4-osiowa obrabiarka drutów EDM."
::msgcat::mcset $gPB(LANG) "MC(new,lathe_2,desc,Label)"             "To jest 2-osiowa tokarka pozioma."
::msgcat::mcset $gPB(LANG) "MC(new,lathe_4,desc,Label)"             "To jest 4-osiowa tokarka zależna."
::msgcat::mcset $gPB(LANG) "MC(new,mill_3,desc,Label)"              "To jest frezarka 3-osiowa."
::msgcat::mcset $gPB(LANG) "MC(new,mill_3MT,desc,Label)"            "Tokarko-frezarka 3-osiowa (XZC)"
::msgcat::mcset $gPB(LANG) "MC(new,mill_4H,desc,Label)"             "To jest frezarka 4-osiowa\n z głowicą obrotową."
::msgcat::mcset $gPB(LANG) "MC(new,mill_4T,desc,Label)"             "To jest frezarka 4-osiowa\n ze stołem obrotowym."
::msgcat::mcset $gPB(LANG) "MC(new,mill_5TT,desc,Label)"            "To jest frezarka 5-osiowa\n z podwójnymi stołami obrotowymi."
::msgcat::mcset $gPB(LANG) "MC(new,mill_5HH,desc,Label)"            "To jest frezarka 5-osiowa\n z podwójnymi głowicami obrotowymi."
::msgcat::mcset $gPB(LANG) "MC(new,mill_5HT,desc,Label)"            "To jest frezarka 5-osiowa\n z głowicą obrotową i stołem obrotowym."
::msgcat::mcset $gPB(LANG) "MC(new,punch,desc,Label)"               "To jest wykrawarka."

::msgcat::mcset $gPB(LANG) "MC(new,post_unit,Label)"                "Jednostka wyjściowa postprocesora"

::msgcat::mcset $gPB(LANG) "MC(new,inch,Label)"                     "Cale"
::msgcat::mcset $gPB(LANG) "MC(new,inch,Context)"                   "Jednostka wyjściowa postprocesora, cale"
::msgcat::mcset $gPB(LANG) "MC(new,millimeter,Label)"               "Milimetry"
::msgcat::mcset $gPB(LANG) "MC(new,millimeter,Context)"             "Jednostka wyjściowa postprocesora, milimetry"

::msgcat::mcset $gPB(LANG) "MC(new,machine,Label)"                  "Obrabiarka"
::msgcat::mcset $gPB(LANG) "MC(new,machine,Context)"                "Typ obrabiarki, dla której zostanie utworzony postprocesor."

::msgcat::mcset $gPB(LANG) "MC(new,mill,Label)"                     "Frez"
::msgcat::mcset $gPB(LANG) "MC(new,mill,Context)"                   "Frezarka"
::msgcat::mcset $gPB(LANG) "MC(new,lathe,Label)"                    "Tokarka"
::msgcat::mcset $gPB(LANG) "MC(new,lathe,Context)"                  "Tokarka"
::msgcat::mcset $gPB(LANG) "MC(new,wire,Label)"                     "Drut EDM"
::msgcat::mcset $gPB(LANG) "MC(new,wire,Context)"                   "Obrabiarka drutów EDM"
::msgcat::mcset $gPB(LANG) "MC(new,punch,Label)"                    "Wytłoczenie"

::msgcat::mcset $gPB(LANG) "MC(new,axis,Label)"                     "Wybór osi obrabiarki"
::msgcat::mcset $gPB(LANG) "MC(new,axis,Context)"                   "Liczba i typ osi obrabiarki"

#Axis Number
::msgcat::mcset $gPB(LANG) "MC(new,axis_2,Label)"                   "2 osie"
::msgcat::mcset $gPB(LANG) "MC(new,axis_3,Label)"                   "3 osie"
::msgcat::mcset $gPB(LANG) "MC(new,axis_4,Label)"                   "4 osie"
::msgcat::mcset $gPB(LANG) "MC(new,axis_5,Label)"                   "5-osie"
::msgcat::mcset $gPB(LANG) "MC(new,axis_XZC,Label)"                 "XZC"


#Axis Type
::msgcat::mcset $gPB(LANG) "MC(new,mach_axis,Label)"                "Oś obrabiarki"
::msgcat::mcset $gPB(LANG) "MC(new,mach_axis,Context)"              "Wybierz oś obrabiarki"
::msgcat::mcset $gPB(LANG) "MC(new,lathe_2,Label)"                  "2 osie"
::msgcat::mcset $gPB(LANG) "MC(new,mill_3,Label)"                   "3 osie"
::msgcat::mcset $gPB(LANG) "MC(new,mill_3MT,Label)"                 "Tokarko-frezarka 3-osiowa (XZC)"
::msgcat::mcset $gPB(LANG) "MC(new,mill_4T,Label)"                  "4 osie ze stołem obrotowym"
::msgcat::mcset $gPB(LANG) "MC(new,mill_4H,Label)"                  "4 osie z głowicą obrotową"
::msgcat::mcset $gPB(LANG) "MC(new,lathe_4,Label)"                  "4 osie"
::msgcat::mcset $gPB(LANG) "MC(new,mill_5HH,Label)"                 "5 osi z podwójnymi głowicami obrotowymi"
::msgcat::mcset $gPB(LANG) "MC(new,mill_5TT,Label)"                 "5 osi z podwójnymi stołami obrotowymi"
::msgcat::mcset $gPB(LANG) "MC(new,mill_5HT,Label)"                 "5 osi z głowicą obrotową i stołem obrotowym"
::msgcat::mcset $gPB(LANG) "MC(new,wedm_2,Label)"                   "2 osie"
::msgcat::mcset $gPB(LANG) "MC(new,wedm_4,Label)"                   "4 osie"
::msgcat::mcset $gPB(LANG) "MC(new,punch,Label)"                    "Wytłoczenie"

::msgcat::mcset $gPB(LANG) "MC(new,control,Label)"                  "Sterownik"
::msgcat::mcset $gPB(LANG) "MC(new,control,Context)"                "Wybierz sterownik postprocesora."

#Controller Type
::msgcat::mcset $gPB(LANG) "MC(new,generic,Label)"                  "Ogólne"
::msgcat::mcset $gPB(LANG) "MC(new,library,Label)"                  "Biblioteka"
::msgcat::mcset $gPB(LANG) "MC(new,user,Label)"                     "Użytkownika"
::msgcat::mcset $gPB(LANG) "MC(new,user,browse,Label)"              "Przeglądaj"

# - Machine tool/ controller brands
::msgcat::mcset $gPB(LANG) "MC(new,allen,Label)"                    "Allen Bradley"
::msgcat::mcset $gPB(LANG) "MC(new,bridge,Label)"                   "Bridgeport"
::msgcat::mcset $gPB(LANG) "MC(new,brown,Label)"                    "Brown & Sharp"
::msgcat::mcset $gPB(LANG) "MC(new,cincin,Label)"                   "Cincinnatti Milacron"
::msgcat::mcset $gPB(LANG) "MC(new,kearny,Label)"                   "Kearny & Tracker"
::msgcat::mcset $gPB(LANG) "MC(new,fanuc,Label)"                    "Fanuc"
::msgcat::mcset $gPB(LANG) "MC(new,ge,Label)"                       "General Electric"
::msgcat::mcset $gPB(LANG) "MC(new,gn,Label)"                       "General Numerics"
::msgcat::mcset $gPB(LANG) "MC(new,gidding,Label)"                  "Gidding & Lewis"
::msgcat::mcset $gPB(LANG) "MC(new,heiden,Label)"                   "Heidenhain"
::msgcat::mcset $gPB(LANG) "MC(new,mazak,Label)"                    "Mazak"
::msgcat::mcset $gPB(LANG) "MC(new,seimens,Label)"                  "Seimens"

##-------------
## Open dialog
##
::msgcat::mcset $gPB(LANG) "MC(open,title,Label)"                   "Edytuj postprocesor"
::msgcat::mcset $gPB(LANG) "MC(open,Status)"                        "Wybierz plik PUI do otwarcia."
::msgcat::mcset $gPB(LANG) "MC(open,file_type_pui)"                 "Pliki sesji programu Post Builder"
::msgcat::mcset $gPB(LANG) "MC(open,file_type_tcl)"                 "Pliki skryptu Tcl"
::msgcat::mcset $gPB(LANG) "MC(open,file_type_def)"                 "Pliki definicji"
::msgcat::mcset $gPB(LANG) "MC(open,file_type_cdl)"                 "Pliki CDL"

##-------------
## Misc dialog
##
::msgcat::mcset $gPB(LANG) "MC(open_save,dlg,title,Label)"          "Wybierz plik"
::msgcat::mcset $gPB(LANG) "MC(exp_cc,dlg,title,Label)"             "Eksportuj polecenia niestandardowe"
::msgcat::mcset $gPB(LANG) "MC(show_mt,title,Label)"                "Obrabiarka"

##----------------
## Utils dialog
##
::msgcat::mcset $gPB(LANG) "MC(mvb,title,Label)"                    "Przeglądarka zmiennych MOM"
::msgcat::mcset $gPB(LANG) "MC(mvb,cat,Label)"                      "Kategoria"
::msgcat::mcset $gPB(LANG) "MC(mvb,search,Label)"                   "Wyszukaj"
::msgcat::mcset $gPB(LANG) "MC(mvb,defv,Label)"                     "Wartości domyślne"
::msgcat::mcset $gPB(LANG) "MC(mvb,posv,Label)"                     "Możliwe wartości"
::msgcat::mcset $gPB(LANG) "MC(mvb,data,Label)"                     "Typ danych"
::msgcat::mcset $gPB(LANG) "MC(mvb,desc,Label)"                     "Opis"

::msgcat::mcset $gPB(LANG) "MC(inposts,title,Label)"                "Edytuj plik template_post.dat"
::msgcat::mcset $gPB(LANG) "MC(tpdf,text,Label)"                    "Plik danych postprocesora szablonów"
::msgcat::mcset $gPB(LANG) "MC(inposts,edit,title,Label)"           "Edytuj linię"
::msgcat::mcset $gPB(LANG) "MC(inposts,edit,post,Label)"            "Postprocesor"


##----------------
## Save As dialog
##
::msgcat::mcset $gPB(LANG) "MC(save_as,title,Label)"                "Zapisz jako"
::msgcat::mcset $gPB(LANG) "MC(save_as,name,Label)"                 "Nazwa postprocesora"
::msgcat::mcset $gPB(LANG) "MC(save_as,name,Context)"               "Nazwa postprocesora, który ma być zapisany pod nową nazwą."
::msgcat::mcset $gPB(LANG) "MC(save_as,Status)"                     "Wprowadź nową nazwę pliku postprocesora."
::msgcat::mcset $gPB(LANG) "MC(save_as,file_type_pui)"              "Pliki sesji programu Post Builder"

##----------------
## Common Widgets
##
::msgcat::mcset $gPB(LANG) "MC(common,entry,Label)"                 "Wejście"
::msgcat::mcset $gPB(LANG) "MC(common,entry,Context)"               "Nową wartość należy określić w polu wprowadzania."

##-----------
## Note Book
##
::msgcat::mcset $gPB(LANG) "MC(nbook,tab,Label)"                    "Karta Notatnik"
::msgcat::mcset $gPB(LANG) "MC(nbook,tab,Context)"                  "Można wybrać kartę, aby przejść do wybranej strony parametrów. \n \nParametry na tej karcie można podzielić na grupy. Dostęp do każdej grupy parametrów można uzyskać za pomocą innej karty."

##------
## Tree
##
::msgcat::mcset $gPB(LANG) "MC(tree,select,Label)"                  "Drzewo komponentów"
::msgcat::mcset $gPB(LANG) "MC(tree,select,Context)"                "Można wybrać komponent, aby wyświetlić lub edytować jego zawartość lub parametry."
::msgcat::mcset $gPB(LANG) "MC(tree,create,Label)"                  "Utwórz"
::msgcat::mcset $gPB(LANG) "MC(tree,create,Context)"                "Utwórz nowy komponent, kopiujący wybrany element."
::msgcat::mcset $gPB(LANG) "MC(tree,cut,Label)"                     "Wytnij"
::msgcat::mcset $gPB(LANG) "MC(tree,cut,Context)"                   "Wytnij komponent."
::msgcat::mcset $gPB(LANG) "MC(tree,paste,Label)"                   "Wklej"
::msgcat::mcset $gPB(LANG) "MC(tree,paste,Context)"                 "Wklej komponent."
::msgcat::mcset $gPB(LANG) "MC(tree,rename,Label)"                  "Zmień nazwę"

##------------------
## Encrypt dialogs
##
::msgcat::mcset $gPB(LANG) "MC(encrypt,browser,Label)"              "Lista licencji"
::msgcat::mcset $gPB(LANG) "MC(encrypt,title,Label)"                "Wybierz licencję"
::msgcat::mcset $gPB(LANG) "MC(encrypt,output,Label)"               "Szyfruj wynik"
::msgcat::mcset $gPB(LANG) "MC(encrypt,license,Label)"              "Licencja:  "

#++++++++++++++
# Machine Tool
#++++++++++++++
::msgcat::mcset $gPB(LANG) "MC(machine,tab,Label)"                  "Obrabiarka"
::msgcat::mcset $gPB(LANG) "MC(machine,Status)"                     "Określ parametry kinematyczne obrabiarki."

::msgcat::mcset $gPB(LANG) "MC(msg,no_display)"                     "Obraz konfiguracji tej obrabiarki jest niedostępny."
::msgcat::mcset $gPB(LANG) "MC(msg,no_4th_ctable)"                  "Tabela C 4. osi jest niedozwolona."
::msgcat::mcset $gPB(LANG) "MC(msg,no_4th_max_min)"                 "Maksymalny limit 4. osi nie może być taki sam jak minimalny limit osi!"
::msgcat::mcset $gPB(LANG) "MC(msg,no_4th_both_neg)"                "Oba limity 4. osi nie mogą być ujemne!"
::msgcat::mcset $gPB(LANG) "MC(msg,no_4th_5th_plane)"               "Płaszczyzna 4. osi nie może być taka sama jak płaszczyzna 5. osi."
::msgcat::mcset $gPB(LANG) "MC(msg,no_4thT_5thH)"                   "Tabela 4. osi i głowica 5. osi są niedozwolone."
::msgcat::mcset $gPB(LANG) "MC(msg,no_5th_max_min)"                 "Maksymalny limit 5. osi nie może być taki sam jak minimalny limit osi!"
::msgcat::mcset $gPB(LANG) "MC(msg,no_5th_both_neg)"                "Oba limity 5. osi nie mogą być ujemne!"

##---------
# Post Info
##
::msgcat::mcset $gPB(LANG) "MC(machine,info,title,Label)"           "Informacje o postprocesorze"
::msgcat::mcset $gPB(LANG) "MC(machine,info,desc,Label)"            "Opis"
::msgcat::mcset $gPB(LANG) "MC(machine,info,type,Label)"            "Typ obrabiarki"
::msgcat::mcset $gPB(LANG) "MC(machine,info,kinematics,Label)"      "Kinematyka"
::msgcat::mcset $gPB(LANG) "MC(machine,info,unit,Label)"            "Jednostka wyjściowa"
::msgcat::mcset $gPB(LANG) "MC(machine,info,controller,Label)"      "Sterownik"
::msgcat::mcset $gPB(LANG) "MC(machine,info,history,Label)"         "Historia"

##---------
## Display
##
::msgcat::mcset $gPB(LANG) "MC(machine,display,Label)"              "Wyświetl obrabiarkę"
::msgcat::mcset $gPB(LANG) "MC(machine,display,Context)"            "Ta opcja powoduje wyświetlenie obrabiarki"
::msgcat::mcset $gPB(LANG) "MC(machine,display_trans,title,Label)"  "Obrabiarka"


##---------------
## General parms
##
::msgcat::mcset $gPB(LANG) "MC(machine,gen,Label)"                      "Parametry ogólne"
    
::msgcat::mcset $gPB(LANG) "MC(machine,gen,out_unit,Label)"             "Jednostka wyjściowa postprocesora:"
::msgcat::mcset $gPB(LANG) "MC(machine,gen,out_unit,Context)"           "Jednostka wyjściowa przetwarzania końcowego:"
::msgcat::mcset $gPB(LANG) "MC(machine,gen,out_unit,inch,Label)"        "Cal" 
::msgcat::mcset $gPB(LANG) "MC(machine,gen,out_unit,metric,Label)"      "Metryczne"

::msgcat::mcset $gPB(LANG) "MC(machine,gen,travel_limit,Label)"         "Limity ruchu w osi liniowej"
::msgcat::mcset $gPB(LANG) "MC(machine,gen,travel_limit,Context)"       "Limity ruchu w osi liniowej"
::msgcat::mcset $gPB(LANG) "MC(machine,gen,travel_limit,x,Label)"       "X"
::msgcat::mcset $gPB(LANG) "MC(machine,gen,travel_limit,x,Context)"     "Określ limit ruchu obrabiarki wzdłuż osi X."
::msgcat::mcset $gPB(LANG) "MC(machine,gen,travel_limit,y,Label)"       "Y"
::msgcat::mcset $gPB(LANG) "MC(machine,gen,travel_limit,y,Context)"     "Określ limit ruchu obrabiarki wzdłuż osi Y."
::msgcat::mcset $gPB(LANG) "MC(machine,gen,travel_limit,z,Label)"       "Z"
::msgcat::mcset $gPB(LANG) "MC(machine,gen,travel_limit,z,Context)"     "Określ limit ruchu obrabiarki wzdłuż osi Z."

::msgcat::mcset $gPB(LANG) "MC(machine,gen,home_pos,Label)"             "Pozycja wyjściowa"
::msgcat::mcset $gPB(LANG) "MC(machine,gen,home_pos,Context)"           "Pozycja wyjściowa"
::msgcat::mcset $gPB(LANG) "MC(machine,gen,home_pos,x,Label)"           "X"
::msgcat::mcset $gPB(LANG) "MC(machine,gen,home_pos,x,Context)"         "Pozycja wyjściowa osi X obrabiarki względem zera fizycznego osi. Obrabiarka wraca do tej pozycji w celu automatycznej zmiany narzędzia."
::msgcat::mcset $gPB(LANG) "MC(machine,gen,home_pos,y,Label)"           "Y"
::msgcat::mcset $gPB(LANG) "MC(machine,gen,home_pos,y,Context)"         "Pozycja wyjściowa osi Y obrabiarki względem zera fizycznego osi. Obrabiarka wraca do tej pozycji w celu automatycznej zmiany narzędzia."
::msgcat::mcset $gPB(LANG) "MC(machine,gen,home_pos,z,Label)"           "Z"
::msgcat::mcset $gPB(LANG) "MC(machine,gen,home_pos,z,Context)"         "Pozycja wyjściowa osi Z obrabiarki względem zera fizycznego osi. Obrabiarka wraca do tej pozycji w celu automatycznej zmiany narzędzia."

::msgcat::mcset $gPB(LANG) "MC(machine,gen,step_size,Label)"            "Rozdzielczość ruchu liniowego"
::msgcat::mcset $gPB(LANG) "MC(machine,gen,step_size,min,Label)"        "Minimum"
::msgcat::mcset $gPB(LANG) "MC(machine,gen,step_size,min,Context)"      "Minimalna rozdzielczość"

::msgcat::mcset $gPB(LANG) "MC(machine,gen,traverse_feed,Label)"        "Prędkość posuwu przejazdu"
::msgcat::mcset $gPB(LANG) "MC(machine,gen,traverse_feed,max,Label)"    "Maksimum"
::msgcat::mcset $gPB(LANG) "MC(machine,gen,traverse_feed,max,Context)"  "Maksymalna prędkość posuwu"

::msgcat::mcset $gPB(LANG) "MC(machine,gen,circle_record,Label)"        "Rekord kołowy wyniku"
::msgcat::mcset $gPB(LANG) "MC(machine,gen,circle_record,yes,Label)"    "Tak"
::msgcat::mcset $gPB(LANG) "MC(machine,gen,circle_record,yes,Context)"  "Rekord kołowy wyniku."
::msgcat::mcset $gPB(LANG) "MC(machine,gen,circle_record,no,Label)"     "Nie"
::msgcat::mcset $gPB(LANG) "MC(machine,gen,circle_record,no,Context)"   "Rekord liniowy wyniku."

::msgcat::mcset $gPB(LANG) "MC(machine,gen,config_4and5_axis,oth,Label)"    "Inne"

# Wire EDM parameters
::msgcat::mcset $gPB(LANG) "MC(machine,gen,wedm,wire_tilt)"             "Sterowanie odchyleniem drutów"
::msgcat::mcset $gPB(LANG) "MC(machine,gen,wedm,angle)"                 "Kąty"
::msgcat::mcset $gPB(LANG) "MC(machine,gen,wedm,coord)"                 "Współrzędne"

# Lathe parameters
::msgcat::mcset $gPB(LANG) "MC(machine,gen,turret,Label)"               "Głowica"
::msgcat::mcset $gPB(LANG) "MC(machine,gen,turret,Context)"             "Głowica"
::msgcat::mcset $gPB(LANG) "MC(machine,gen,turret,conf,Label)"          "Konfiguruj"
::msgcat::mcset $gPB(LANG) "MC(machine,gen,turret,conf,Context)"        "W przypadku wybrania dwóch głowic ta opcja umożliwia skonfigurowanie parametrów."
::msgcat::mcset $gPB(LANG) "MC(machine,gen,turret,one,Label)"           "Jedna głowica"
::msgcat::mcset $gPB(LANG) "MC(machine,gen,turret,one,Context)"         "Obrabiarka z jedną głowicą"
::msgcat::mcset $gPB(LANG) "MC(machine,gen,turret,two,Label)"           "Dwie głowice"
::msgcat::mcset $gPB(LANG) "MC(machine,gen,turret,two,Context)"         "Obrabiarka z dwiema głowicami"

::msgcat::mcset $gPB(LANG) "MC(machine,gen,turret,conf_trans,Label)"    "Konfiguracja głowic"
::msgcat::mcset $gPB(LANG) "MC(machine,gen,turret,prim,Label)"          "Głowica główna"
::msgcat::mcset $gPB(LANG) "MC(machine,gen,turret,prim,Context)"        "Wybierz oznaczenie głowicy głównej."
::msgcat::mcset $gPB(LANG) "MC(machine,gen,turret,sec,Label)"           "Głowica pomocnicza"
::msgcat::mcset $gPB(LANG) "MC(machine,gen,turret,sec,Context)"         "Wybierz oznaczenie głowicy pomocniczej."
::msgcat::mcset $gPB(LANG) "MC(machine,gen,turret,designation,Label)"   "Oznaczenie"
::msgcat::mcset $gPB(LANG) "MC(machine,gen,turret,xoff,Label)"          "Odsunięcie X"
::msgcat::mcset $gPB(LANG) "MC(machine,gen,turret,xoff,Context)"        "Określ odsunięcie X."
::msgcat::mcset $gPB(LANG) "MC(machine,gen,turret,zoff,Label)"          "Odsunięcie Z"
::msgcat::mcset $gPB(LANG) "MC(machine,gen,turret,zoff,Context)"        "Określ odsunięcie Z."

::msgcat::mcset $gPB(LANG) "MC(machine,gen,turret,front,Label)"         "PRZÓD"
::msgcat::mcset $gPB(LANG) "MC(machine,gen,turret,rear,Label)"          "TYŁ"
::msgcat::mcset $gPB(LANG) "MC(machine,gen,turret,right,Label)"         "PRAWY"
::msgcat::mcset $gPB(LANG) "MC(machine,gen,turret,left,Label)"          "LEWY"
::msgcat::mcset $gPB(LANG) "MC(machine,gen,turret,side,Label)"          "BOK"
::msgcat::mcset $gPB(LANG) "MC(machine,gen,turret,saddle,Label)"        "SANIE"

::msgcat::mcset $gPB(LANG) "MC(machine,gen,axis_multi,Label)"           "Mnożniki osi"
::msgcat::mcset $gPB(LANG) "MC(machine,gen,axis_multi,dia,Label)"       "Programowanie średnicy"
::msgcat::mcset $gPB(LANG) "MC(machine,gen,axis_multi,dia,Context)"     "Te opcje umożliwiają programowanie średnicy przez podwojenie wartości wybranych adresów w wyniku sterowania numerycznego (N/C)."
::msgcat::mcset $gPB(LANG) "MC(machine,gen,axis_multi,2x,Label)"        "2X"
::msgcat::mcset $gPB(LANG) "MC(machine,gen,axis_multi,2x,Context)"      "Ten przełącznik umożliwia programowanie średnicy przez podwojenie współrzędnych osi X w wynikach sterowania numerycznego (N/C)."

::msgcat::mcset $gPB(LANG) "MC(machine,gen,axis_multi,2y,Label)"        "2Y"
::msgcat::mcset $gPB(LANG) "MC(machine,gen,axis_multi,2y,Context)"      "Ten przełącznik umożliwia programowanie średnicy przez podwojenie współrzędnych osi Y w wynikach sterowania numerycznego (N/C)."
::msgcat::mcset $gPB(LANG) "MC(machine,gen,axis_multi,2i,Label)"        "2I"
::msgcat::mcset $gPB(LANG) "MC(machine,gen,axis_multi,2i,Context)"      "Ten przełącznik umożliwia podwojenie wartości I rekordów kołowych w przypadku użycia programowania średnicy."
::msgcat::mcset $gPB(LANG) "MC(machine,gen,axis_multi,2j,Label)"        "2J"
::msgcat::mcset $gPB(LANG) "MC(machine,gen,axis_multi,2j,Context)"      "Ten przełącznik umożliwia podwojenie wartości J rekordów kołowych w przypadku użycia programowania średnicy."

::msgcat::mcset $gPB(LANG) "MC(machine,gen,axis_multi,mir,Label)"       "Odbicie lustrzane wyniku"
::msgcat::mcset $gPB(LANG) "MC(machine,gen,axis_multi,mir,Context)"     "Te opcje umożliwiają odbicie lustrzane wybranych adresów przez zanegowanie ich wartości w wynikach sterowania numerycznego (N/C)."
::msgcat::mcset $gPB(LANG) "MC(machine,gen,axis_multi,x,Label)"         "-X"
::msgcat::mcset $gPB(LANG) "MC(machine,gen,axis_multi,x,Context)"       "Ten przełącznik umożliwia zanegowanie współrzędnych X w wynikach sterowania numerycznego (N/C)."
::msgcat::mcset $gPB(LANG) "MC(machine,gen,axis_multi,y,Label)"         "-Y"
::msgcat::mcset $gPB(LANG) "MC(machine,gen,axis_multi,y,Context)"       "Ten przełącznik umożliwia zanegowanie współrzędnych Y w wynikach sterowania numerycznego (N/C)."
::msgcat::mcset $gPB(LANG) "MC(machine,gen,axis_multi,z,Label)"         "-Z"
::msgcat::mcset $gPB(LANG) "MC(machine,gen,axis_multi,z,Context)"       "Ten przełącznik umożliwia zanegowanie współrzędnych Z w wynikach sterowania numerycznego (N/C)."
::msgcat::mcset $gPB(LANG) "MC(machine,gen,axis_multi,i,Label)"         "-I"
::msgcat::mcset $gPB(LANG) "MC(machine,gen,axis_multi,i,Context)"       "Ten przełącznik umożliwia zanegowanie wartości I rekordów kołowych w wynikach sterowania numerycznego (N/C)."
::msgcat::mcset $gPB(LANG) "MC(machine,gen,axis_multi,j,Label)"         "-J"
::msgcat::mcset $gPB(LANG) "MC(machine,gen,axis_multi,j,Context)"       "Ten przełącznik umożliwia zanegowanie wartości J rekordów kołowych w wynikach sterowania numerycznego (N/C)."
::msgcat::mcset $gPB(LANG) "MC(machine,gen,axis_multi,k,Label)"         "-K"
::msgcat::mcset $gPB(LANG) "MC(machine,gen,axis_multi,k,Context)"       "Ten przełącznik umożliwia zanegowanie wartości K rekordów kołowych w wynikach sterowania numerycznego (N/C)."

::msgcat::mcset $gPB(LANG) "MC(machine,gen,output,Label)"               "Metoda tworzenia wyniku"
::msgcat::mcset $gPB(LANG) "MC(machine,gen,output,Context)"             "Metoda tworzenia wyniku"
::msgcat::mcset $gPB(LANG) "MC(machine,gen,output,tool_tip,Label)"      "Ostrze narzędzia"
::msgcat::mcset $gPB(LANG) "MC(machine,gen,output,tool_tip,Context)"    "Wynik z uwzględnieniem ostrza narzędzia"
::msgcat::mcset $gPB(LANG) "MC(machine,gen,output,turret_ref,Label)"    "Odniesienie głowicy"
::msgcat::mcset $gPB(LANG) "MC(machine,gen,output,turret_ref,Context)"  "Wynik z uwzględnieniem odniesienia głowicy"

::msgcat::mcset $gPB(LANG) "MC(machine,gen,lathe_turret,msg)"           "Oznaczenie głowicy głównej nie może być takie same jak oznaczenie głowicy pomocniczej."
::msgcat::mcset $gPB(LANG) "MC(machine,gen,turret_chg,msg)"             "Zmiana tej opcji może wymagać dodania lub usunięcia bloku G92 w zdarzeniach zmiany narzędzia."
# Entries for XZC/Mill-Turn
::msgcat::mcset $gPB(LANG) "MC(machine,gen,spindle_axis,Label)"             "Początkowa oś wrzeciona"
::msgcat::mcset $gPB(LANG) "MC(machine,gen,spindle_axis,Context)"           "Początkową oś wrzeciona oznaczoną dla aktywnego narzędzia frezarskiego można określić jako równoległą do osi Z lub prostopadłą do osi Z. Oś narzędzia operacji musi być zgodna z określoną osią wrzeciona. Jeśli postprocesor nie będzie mógł ustawić pozycji określonej dla osi wrzeciona, wystąpi błąd. \nTen wektor można zastąpić określeniem osi wrzeciona z obiektem głowicy."

::msgcat::mcset $gPB(LANG) "MC(machine,gen,position_in_yaxis,Label)"        "Pozycja na osi Y"
::msgcat::mcset $gPB(LANG) "MC(machine,gen,position_in_yaxis,Context)"      "Obrabiarka jest wyposażona w programowalną oś Y, którą może ustawić podczas profilowania. Ta opcja ma zastosowanie tylko w przypadku, gdy oś wrzeciona nie występuje wzdłuż osi Z."

::msgcat::mcset $gPB(LANG) "MC(machine,gen,mach_mode,Label)"                "Tryb obrabiarki"
::msgcat::mcset $gPB(LANG) "MC(machine,gen,mach_mode,Context)"              "Dostępne tryby obrabiarki to Frezarka XZC lub Prosta tokarko-frezarka."

::msgcat::mcset $gPB(LANG) "MC(machine,gen,mach_mode,xzc_mill,Label)"       "Frezarka XZC"
::msgcat::mcset $gPB(LANG) "MC(machine,gen,mach_mode,xzc_mill,Context)"     "Frezarka XZC będzie wyposażona w stół lub uchwyt zablokowany na tokarko-frezarce jako obrotowa oś C. Wszystkie ruchy XY zostaną przekonwertowane na ruchy X i C, gdzie X oznacza wartość promienia, a C oznacza kąt."

::msgcat::mcset $gPB(LANG) "MC(machine,gen,mach_mode,mill_turn,Label)"      "Prosta tokarko-frezarka"
::msgcat::mcset $gPB(LANG) "MC(machine,gen,mach_mode,mill_turn,Context)"    "Ten postprocesor frezarki XZC zostanie powiązany z postprocesorem tokarki w celu przetworzenia programu zawierającego zarówno operacje frezowania, jak i toczenia. Typ operacji będzie określać, który postprocesor zostanie użyty do uzyskania wyników sterowania numerycznego (N/C)."

::msgcat::mcset $gPB(LANG) "MC(machine,gen,mill_turn,lathe_post,Label)"     "Postprocesor tokarki"
::msgcat::mcset $gPB(LANG) "MC(machine,gen,mill_turn,lathe_post,Context)"   "Postprocesor tokarki jest wymagany w przypadku postprocesora prostej tokarko-frezarki w celu przetwarzania końcowego operacji toczenia w programie."

::msgcat::mcset $gPB(LANG) "MC(machine,gen,lathe_post,select_name,Label)"   "Wybierz nazwę"
::msgcat::mcset $gPB(LANG) "MC(machine,gen,lathe_post,select_name,Context)" "Wybierz nazwę postprocesora tokarki, który będzie używany w postprocesorze Prosta tokarko-frezarka. Najprawdopodobniej będzie można go znaleźć w katalogu \\\$UGII_CAM_POST_DIR podczas uruchamiania programu NX/postprocesora. W innym przypadku zostanie użyty postprocesor o tej samej nazwie w katalogu, w którym jest przechowywany postprocesor frezarki."

::msgcat::mcset $gPB(LANG) "MC(machine,gen,coord_mode,Label)"               "Domyślny tryb współrzędnej"
::msgcat::mcset $gPB(LANG) "MC(machine,gen,coord_mode,Context)"             "Te opcje definiują początkowe ustawienia trybu wyjścia współrzędnej jako Biegunowe (XZC) lub Kartezjańskie (XYZ). Ten tryb można zmienić za pomocą polecenia \\\"SET/POLAR,ON\\\" programowanego narzędzia UDE z operacjami."

::msgcat::mcset $gPB(LANG) "MC(machine,gen,coord_mode,polar,Label)"         "Biegunowe"
::msgcat::mcset $gPB(LANG) "MC(machine,gen,coord_mode,polar,Context)"       "Wynik współrzędnych w XZC."

::msgcat::mcset $gPB(LANG) "MC(machine,gen,coord_mode,cart,Label)"          "Kartezjańskie"
::msgcat::mcset $gPB(LANG) "MC(machine,gen,coord_mode,cart,Context)"        "Wynik współrzędnych w XYZ."

::msgcat::mcset $gPB(LANG) "MC(machine,gen,xzc_arc_mode,Label)"             "Tryb rekordu kołowego"
::msgcat::mcset $gPB(LANG) "MC(machine,gen,xzc_arc_mode,Context)"           "Te opcje definiują wynik rekordów kołowych w trybie Biegunowe (XCR) lub Kartezjańskie (XYIJ)."

::msgcat::mcset $gPB(LANG) "MC(machine,gen,xzc_arc_mode,polar,Label)"       "Biegunowe"
::msgcat::mcset $gPB(LANG) "MC(machine,gen,xzc_arc_mode,polar,Context)"     "Wynik kołowy w XCR."

::msgcat::mcset $gPB(LANG) "MC(machine,gen,xzc_arc_mode,cart,Label)"        "Kartezjańskie"
::msgcat::mcset $gPB(LANG) "MC(machine,gen,xzc_arc_mode,cart,Context)"      "Wynik kołowy w XYIJ."

::msgcat::mcset $gPB(LANG) "MC(machine,gen,def_spindle_axis,Label)"         "Początkowa oś wrzeciona"
::msgcat::mcset $gPB(LANG) "MC(machine,gen,def_spindle_axis,Context)"       "Początkową oś wrzeciona można zastąpić osią wrzeciona określoną z obiektem głowicy. \nWektor nie musi być znormalizowany."


##-----------------
## 4-th Axis parms
##
::msgcat::mcset $gPB(LANG) "MC(machine,axis,fourth,Label)"              "Czwarta oś"

::msgcat::mcset $gPB(LANG) "MC(machine,axis,radius_output,Label)"       "Wynik promieniowy"
::msgcat::mcset $gPB(LANG) "MC(machine,axis,radius_output,Context)"     "Gdy oś narzędzia przebiega wzdłuż osi Z (0,0,1), postprocesor umożliwia uzyskanie wyniku w postaci promienia (X) współrzędnych biegunowych \\\"Zawsze dodatni\\\", \\\"Zawsze ujemny\\\" lub \\\"Najkrótsza odległość\\\"."

::msgcat::mcset $gPB(LANG) "MC(machine,axis,type_head,Label)"           "Głowica"
::msgcat::mcset $gPB(LANG) "MC(machine,axis,type_table,Label)"          "Tabela"

##-----------------
## 5-th Axis parms
##
::msgcat::mcset $gPB(LANG) "MC(machine,axis,fifth,Label)"               "Piąta oś"

::msgcat::mcset $gPB(LANG) "MC(machine,axis,rotary,Label)"              "Oś obrotowa"

::msgcat::mcset $gPB(LANG) "MC(machine,axis,offset,Label)"              "Środek punktu zerowego maszyny do osi obrotowej"
::msgcat::mcset $gPB(LANG) "MC(machine,axis,offset,4,Label)"            "Środek punktu zerowego maszyny do 4. osi"
::msgcat::mcset $gPB(LANG) "MC(machine,axis,offset,5,Label)"            "Środek 4. osi do środka 5. osi"
::msgcat::mcset $gPB(LANG) "MC(machine,axis,offset,x,Label)"            "Odsunięcie X"
::msgcat::mcset $gPB(LANG) "MC(machine,axis,offset,x,Context)"          "Określ odsunięcie X osi obrotowej."
::msgcat::mcset $gPB(LANG) "MC(machine,axis,offset,y,Label)"            "Odsunięcie Y"
::msgcat::mcset $gPB(LANG) "MC(machine,axis,offset,y,Context)"          "Określ odsunięcie Y osi obrotowej."
::msgcat::mcset $gPB(LANG) "MC(machine,axis,offset,z,Label)"            "Odsunięcie Z"
::msgcat::mcset $gPB(LANG) "MC(machine,axis,offset,z,Context)"          "Określ odsunięcie Z osi obrotowej."

::msgcat::mcset $gPB(LANG) "MC(machine,axis,rotation,Label)"            "Obrót osi"
::msgcat::mcset $gPB(LANG) "MC(machine,axis,rotation,norm,Label)"       "Normalny"
::msgcat::mcset $gPB(LANG) "MC(machine,axis,rotation,norm,Context)"     "Ustaw kierunek obrotu osi na Normalny."
::msgcat::mcset $gPB(LANG) "MC(machine,axis,rotation,rev,Label)"        "Odwrócony"
::msgcat::mcset $gPB(LANG) "MC(machine,axis,rotation,rev,Context)"      "Ustaw kierunek obrotu osi na Odwrócony."

::msgcat::mcset $gPB(LANG) "MC(machine,axis,direction,Label)"           "Kierunek osi"
::msgcat::mcset $gPB(LANG) "MC(machine,axis,direction,Context)"         "Wybierz kierunek osi."

::msgcat::mcset $gPB(LANG) "MC(machine,axis,con_motion,Label)"              "Kolejne ruchy obrotowe"
::msgcat::mcset $gPB(LANG) "MC(machine,axis,con_motion,combine,Label)"      "Połączone"
::msgcat::mcset $gPB(LANG) "MC(machine,axis,con_motion,combine,Context)"    "Ten przełącznik umożliwia włączenie/wyłączenie linearyzacji. Powoduje włączenie/wyłączenie opcji Tolerancja."
::msgcat::mcset $gPB(LANG) "MC(machine,axis,con_motion,tol,Label)"      "Tolerancja"
::msgcat::mcset $gPB(LANG) "MC(machine,axis,con_motion,tol,Context)"    "Ta opcja jest aktywna tylko wtedy, gdy przełącznik Połączone jest aktywny. Określ tolerancję."

::msgcat::mcset $gPB(LANG) "MC(machine,axis,violation,Label)"           "Obsługa naruszenia limitu osi"
::msgcat::mcset $gPB(LANG) "MC(machine,axis,violation,warn,Label)"      "Ostrzeżenie"
::msgcat::mcset $gPB(LANG) "MC(machine,axis,violation,warn,Context)"    "Ostrzeżenia dotyczące danych wyjściowych podczas naruszenia limitu osi."
::msgcat::mcset $gPB(LANG) "MC(machine,axis,violation,ret,Label)"       "Wyjście/Ponowne wejście"
::msgcat::mcset $gPB(LANG) "MC(machine,axis,violation,ret,Context)"     "Wyjście/ponowne wejście w przypadku naruszenia limitu osi. \n \nW poleceniu niestandardowym PB_CMD_init_rotaty, w celu osiągnięcia żądanych ruchów można dostosować następujące parametry: \n \n   mom_kin_retract_type \n   mom_kin_retract_distance \n   mom_kin_reengage_distance"

::msgcat::mcset $gPB(LANG) "MC(machine,axis,limits,Label)"              "Limity osi (stopnie)"
::msgcat::mcset $gPB(LANG) "MC(machine,axis,limits,min,Label)"          "Minimum"
::msgcat::mcset $gPB(LANG) "MC(machine,axis,limits,min,Context)"        "Określ minimalny limit osi obrotowej (stopnie)."
::msgcat::mcset $gPB(LANG) "MC(machine,axis,limits,max,Label)"          "Maksimum"
::msgcat::mcset $gPB(LANG) "MC(machine,axis,limits,max,Context)"        "Określ maksymalny limit osi obrotowej (stopnie)."

::msgcat::mcset $gPB(LANG) "MC(machine,axis,incr_text)"                 "Ta oś obrotowa może być przyrostowa"

::msgcat::mcset $gPB(LANG) "MC(machine,axis,rotary_res,Label)"          "Rozdzielczość ruchu obrotowego (stopnie)"
::msgcat::mcset $gPB(LANG) "MC(machine,axis,rotary_res,Context)"        "Określ rozdzielczość ruchu obrotowego (stopnie)."

::msgcat::mcset $gPB(LANG) "MC(machine,axis,ang_offset,Label)"          "Odsunięcie kątowe (stopnie)"
::msgcat::mcset $gPB(LANG) "MC(machine,axis,ang_offset,Context)"        "Określ odsunięcie kątowe osi (stopnie)."

::msgcat::mcset $gPB(LANG) "MC(machine,axis,pivot,Label)"               "Odległość obrotu"
::msgcat::mcset $gPB(LANG) "MC(machine,axis,pivot,Context)"             "Określ odległość obrotu."

::msgcat::mcset $gPB(LANG) "MC(machine,axis,max_feed,Label)"            "Maks. prędkość posuwu (stopnie/min)"
::msgcat::mcset $gPB(LANG) "MC(machine,axis,max_feed,Context)"          "Określ maksymalną prędkość posuwu (stopnie/min)."

::msgcat::mcset $gPB(LANG) "MC(machine,axis,plane,Label)"               "Płaszczyzna obrotu"
::msgcat::mcset $gPB(LANG) "MC(machine,axis,plane,Context)"             "Jako płaszczyznę obrotu wybierz płaszczyznę XY, YZ, ZX lub opcję Inna. Opcja \\\"Inna\\\" umożliwia określenie dowolnego wektora."

::msgcat::mcset $gPB(LANG) "MC(machine,axis,plane,normal,Label)"        "Wektor płaszczyzny normalnej"
::msgcat::mcset $gPB(LANG) "MC(machine,axis,plane,normal,Context)"      "Określ wektor normalny płaszczyzny jako oś obrotu. \nWektor nie musi być znormalizowany."
::msgcat::mcset $gPB(LANG) "MC(machine,axis,plane,4th,Label)"           "Normalna płaszczyzny 4. osi"
::msgcat::mcset $gPB(LANG) "MC(machine,axis,plane,4th,Context)"         "Określ wektor normalny płaszczyzny do obrotu 4. osi."
::msgcat::mcset $gPB(LANG) "MC(machine,axis,plane,5th,Label)"           "Normalna płaszczyzny 5. osi"
::msgcat::mcset $gPB(LANG) "MC(machine,axis,plane,5th,Context)"         "Określ wektor normalny płaszczyzny do obrotu 5. osi."

::msgcat::mcset $gPB(LANG) "MC(machine,axis,leader,Label)"              "Linia odniesienia słowa"
::msgcat::mcset $gPB(LANG) "MC(machine,axis,leader,Context)"            "Określ linię odniesienia słowa."

::msgcat::mcset $gPB(LANG) "MC(machine,axis,config,Label)"              "Konfiguruj"
::msgcat::mcset $gPB(LANG) "MC(machine,axis,config,Context)"            "Ta opcja umożliwia zdefiniowanie parametrów 4. i 5. osi."

::msgcat::mcset $gPB(LANG) "MC(machine,axis,r_axis_conf_trans,Label)"   "Konfiguracja osi obrotowej"
::msgcat::mcset $gPB(LANG) "MC(machine,axis,4th_axis,Label)"            "4. oś"
::msgcat::mcset $gPB(LANG) "MC(machine,axis,5th_axis,Label)"            "5. oś"
::msgcat::mcset $gPB(LANG) "MC(machine,axis,head,Label)"                " Głowica "
::msgcat::mcset $gPB(LANG) "MC(machine,axis,table,Label)"               " Tabela "

::msgcat::mcset $gPB(LANG) "MC(machine,axis,rotary_lintol,Label)"       "Domyślna tolerancja linearyzacji"
::msgcat::mcset $gPB(LANG) "MC(machine,axis,rotary_lintol,Context)"     "Ta wartość zostanie użyta jako tolerancja domyślna w celu linearyzacji ruchów obrotowych po określeniu polecenia postprocesora LINTOL/ON z bieżącą lub poprzednią operacją. Polecenie LINTOL/ umożliwia również określenie innej tolerancji linearyzacji."

#+++++++++++++++++++++
# Program & Tool Path
#+++++++++++++++++++++
::msgcat::mcset $gPB(LANG) "MC(progtpth,tab,Label)"                 "Ścieżka programu i narzędzia"

##---------
## Program
##
::msgcat::mcset $gPB(LANG) "MC(prog,tab,Label)"                     "Program"
::msgcat::mcset $gPB(LANG) "MC(prog,Status)"                        "Definiuj wynik zdarzeń"

::msgcat::mcset $gPB(LANG) "MC(prog,tree,Label)"                    "Program - Drzewo sekwencji"
::msgcat::mcset $gPB(LANG) "MC(prog,tree,Context)"                  "Program sterowania numerycznego (N/C) jest podzielony na pięć segmentów: cztery (4) sekwencje i obiekt Ścieżka narzędzia: \n \n * Sekwencja uruchomienia programu \n * Sekwencja uruchomienia operacji \n * Ścieżka narzędzia \n * Sekwencja zakończenia operacji \n * Sekwencja zakończenia programu \n \nKażda sekwencja składa się z serii znaczników. Znacznik wskazuje zdarzenie, które można zaprogramować i które może wystąpić na określonym etapie programu sterowania numerycznego (N/C). Każdy znacznik można dołączyć z określonym rozmieszczeniem kodów N/C, które zostaną uzyskane po wykonaniu przetwarzania końcowego programu. \n \nŚcieżka narzędzia składa się z wielu zdarzeń. Podzielono je na trzy (3) grupy: \n \n * Kontrola obrabiarki \n * Ruchy \n * Cykle \n"

::msgcat::mcset $gPB(LANG) "MC(prog,tree,prog_strt,Label)"          "Sekwencja uruchomienia programu"
::msgcat::mcset $gPB(LANG) "MC(prog,tree,prog_end,Label)"           "Sekwencja zakończenia programu"
::msgcat::mcset $gPB(LANG) "MC(prog,tree,oper_strt,Label)"          "Sekwencja uruchomienia operacji"
::msgcat::mcset $gPB(LANG) "MC(prog,tree,oper_end,Label)"           "Sekwencja zakończenia operacji"
::msgcat::mcset $gPB(LANG) "MC(prog,tree,tool_path,Label)"          "Ścieżka narzędzia"
::msgcat::mcset $gPB(LANG) "MC(prog,tree,tool_path,mach_cnt,Label)" "Kontrola obrabiarki"
::msgcat::mcset $gPB(LANG) "MC(prog,tree,tool_path,motion,Label)"   "Ruch"
::msgcat::mcset $gPB(LANG) "MC(prog,tree,tool_path,cycle,Label)"    "Cykle standardowe"
::msgcat::mcset $gPB(LANG) "MC(prog,tree,linked_posts,Label)"       "Sekwencja postprocesorów połączonych"

::msgcat::mcset $gPB(LANG) "MC(prog,add,Label)"                     "Sekwencja - Dodaj blok"
::msgcat::mcset $gPB(LANG) "MC(prog,add,Context)"                   "Do sekwencji można dodać nowy blok, naciskając ten przycisk i przeciągając go do żądanego znacznika. Bloki można również dołączać obok, ponad i poniżej istniejącego bloku."

::msgcat::mcset $gPB(LANG) "MC(prog,trash,Label)"                   "Sekwencja - Kosz"
::msgcat::mcset $gPB(LANG) "MC(prog,trash,Context)"                 "Z sekwencji można wyrzucić niechciane bloki, przeciągając je do tego kosza."

::msgcat::mcset $gPB(LANG) "MC(prog,block,Label)"                   "Sekwencja - Blok"
::msgcat::mcset $gPB(LANG) "MC(prog,block,Context)"                 "Z sekwencji można wyrzucić niechciany blok, przeciągając go do tego kosza. \n \nMożna również uaktywnić menu podręczne, naciskając prawy przycisk myszy. W menu jest dostępnych wiele usług: \n \n * Edytuj \n * Wymuś wynik \n * Wytnij \n * Kopiuj jako \n * Wklej \n * Usuń \n"

::msgcat::mcset $gPB(LANG) "MC(prog,select,Label)"                  "Sekwencja - Wybór bloku"
::msgcat::mcset $gPB(LANG) "MC(prog,select,Context)"                "Z tej listy można wybrać typ komponentu Blok, który należy dodać do sekwencji. \n\A Dostępne typy komponentów: \n \n * Nowy blok \n * Istniejący blok sterowania numerycznego (N/C) \n * Komunikat dla operatora \n * Polecenie niestandardowe \n"

::msgcat::mcset $gPB(LANG) "MC(prog,oper_temp,Label)"               "Wybierz szablon sekwencji"
::msgcat::mcset $gPB(LANG) "MC(prog,add_block,Label)"               "Dodaj blok"
::msgcat::mcset $gPB(LANG) "MC(prog,seq_comb_nc,Label)"             "Wyświetl połączone bloki kodu N/C"
::msgcat::mcset $gPB(LANG) "MC(prog,seq_comb_nc,Context)"           "Ten przycisk umożliwia wyświetlenie zawartości sekwencji z uwzględnieniem bloków lub kodów N/C. \n \nKody N/C będą wyświetlać słowa w odpowiedniej kolejności."

::msgcat::mcset $gPB(LANG) "MC(prog,plus,Label)"                    "Program - przełącznik Zwiń/Rozwiń"
::msgcat::mcset $gPB(LANG) "MC(prog,plus,Context)"                  "Ten przycisk umożliwia zwinięcie lub rozwinięcie gałęzi danego komponentu."

::msgcat::mcset $gPB(LANG) "MC(prog,marker,Label)"                  "Sekwencja - Znacznik"
::msgcat::mcset $gPB(LANG) "MC(prog,marker,Context)"                "Znaczniki sekwencji wskazują możliwe zdarzenia, które można programować i które mogą występować w sekwencji na określonym etapie programu N/C. \n \nBloki można dołączać/rozmieszczać w celu uzyskania wyniku przy każdym znaczniku."

::msgcat::mcset $gPB(LANG) "MC(prog,event,Label)"                   "Program - Zdarzenie"
::msgcat::mcset $gPB(LANG) "MC(prog,event,Context)"                 "Każde zdarzenie można edytować za pomocą jednego kliknięcia lewym przyciskiem myszy."

::msgcat::mcset $gPB(LANG) "MC(prog,nc_code,Label)"                 "Program - Kod sterowania numerycznego (N/C)"
::msgcat::mcset $gPB(LANG) "MC(prog,nc_code,Context)"               "Tekst wyświetlany w tym polu stanowi reprezentatywny kod N/C, który zostanie wyświetlony przy danym znaczniku lub z danego zdarzenia."
::msgcat::mcset $gPB(LANG) "MC(prog,undo_popup,Label)"              "Cofnij"

## Sequence
##
::msgcat::mcset $gPB(LANG) "MC(seq,combo,new,Label)"                "Nowy blok"
::msgcat::mcset $gPB(LANG) "MC(seq,combo,comment,Label)"            "Komunikat dla operatora"
::msgcat::mcset $gPB(LANG) "MC(seq,combo,custom,Label)"             "Polecenie niestandardowe"

::msgcat::mcset $gPB(LANG) "MC(seq,new_trans,title,Label)"          "Blok"
::msgcat::mcset $gPB(LANG) "MC(seq,cus_trans,title,Label)"          "Polecenie niestandardowe"
::msgcat::mcset $gPB(LANG) "MC(seq,oper_trans,title,Label)"         "Komunikat dla operatora"

::msgcat::mcset $gPB(LANG) "MC(seq,edit_popup,Label)"               "Edytuj"
::msgcat::mcset $gPB(LANG) "MC(seq,force_popup,Label)"              "Wymuś wynik"
::msgcat::mcset $gPB(LANG) "MC(seq,rename_popup,Label)"             "Zmień nazwę"
::msgcat::mcset $gPB(LANG) "MC(seq,rename_popup,Context)"           "Można określić nazwę danego komponentu."
::msgcat::mcset $gPB(LANG) "MC(seq,cut_popup,Label)"                "Wytnij"
::msgcat::mcset $gPB(LANG) "MC(seq,copy_popup,Label)"               "Kopiuj jako"
::msgcat::mcset $gPB(LANG) "MC(seq,copy_popup,ref,Label)"           "Powiązane bloki"
::msgcat::mcset $gPB(LANG) "MC(seq,copy_popup,new,Label)"           "Nowe bloki"
::msgcat::mcset $gPB(LANG) "MC(seq,paste_popup,Label)"              "Wklej"
::msgcat::mcset $gPB(LANG) "MC(seq,paste_popup,before,Label)"       "Przed"
::msgcat::mcset $gPB(LANG) "MC(seq,paste_popup,inline,Label)"       "Osiowo"
::msgcat::mcset $gPB(LANG) "MC(seq,paste_popup,after,Label)"        "Po"
::msgcat::mcset $gPB(LANG) "MC(seq,del_popup,Label)"                "Usuń"

::msgcat::mcset $gPB(LANG) "MC(seq,force_trans,title,Label)"        "Wymuś wynik jeden raz"

##--------------
## Toolpath
##
::msgcat::mcset $gPB(LANG) "MC(tool,event_trans,title,Label)"       "Zdarzenie"

::msgcat::mcset $gPB(LANG) "MC(tool,event_seq,button,Label)"        "Wybierz szablon zdarzenia"
::msgcat::mcset $gPB(LANG) "MC(tool,add_word,button,Label)"         "Dodaj słowo"

::msgcat::mcset $gPB(LANG) "MC(tool,format_trans,title,Label)"      "FORMAT"

::msgcat::mcset $gPB(LANG) "MC(tool,circ_trans,title,Label)"        "Ruch kołowy- Kody płaszczyzny"
::msgcat::mcset $gPB(LANG) "MC(tool,circ_trans,frame,Label)"        " Kody G płaszczyzny "
::msgcat::mcset $gPB(LANG) "MC(tool,circ_trans,xy,Label)"           "Płaszczyzna XY"
::msgcat::mcset $gPB(LANG) "MC(tool,circ_trans,yz,Label)"           "Płaszczyzna YZ"
::msgcat::mcset $gPB(LANG) "MC(tool,circ_trans,zx,Label)"           "Płaszczyzna ZX"

::msgcat::mcset $gPB(LANG) "MC(tool,ijk_desc,arc_start,Label)"          "Początek łuku względem środka"
::msgcat::mcset $gPB(LANG) "MC(tool,ijk_desc,arc_center,Label)"         "Środek łuku względem początku"
::msgcat::mcset $gPB(LANG) "MC(tool,ijk_desc,u_arc_start,Label)"        "Początek łuku bez znaku względem środka"
::msgcat::mcset $gPB(LANG) "MC(tool,ijk_desc,absolute,Label)"           "Bezwzględny środek łuku"
::msgcat::mcset $gPB(LANG) "MC(tool,ijk_desc,long_thread_lead,Label)"   "Wzdłużne przystawienie gwintu"
::msgcat::mcset $gPB(LANG) "MC(tool,ijk_desc,tran_thread_lead,Label)"   "Poprzeczne przystawienie gwintu"

::msgcat::mcset $gPB(LANG) "MC(tool,spindle,range,type,Label)"              "Typ zakresu wrzeciona"
::msgcat::mcset $gPB(LANG) "MC(tool,spindle,range,range_M,Label)"           "Osobny kod M zakresu (M41)"
::msgcat::mcset $gPB(LANG) "MC(tool,spindle,range,with_spindle_M,Label)"    "Numer zakresu z kodem M wrzeciona (M13)"
::msgcat::mcset $gPB(LANG) "MC(tool,spindle,range,hi_lo_with_S,Label)"      "Zakres wysoki/niski z kodem S (S+100)"
::msgcat::mcset $gPB(LANG) "MC(tool,spindle,range,nonzero_range,msg)"       "Liczba zakresów wrzeciona musi być większa od zera."

::msgcat::mcset $gPB(LANG) "MC(tool,spindle_trans,title,Label)"         "Tabela kodów zakresu wrzeciona"
::msgcat::mcset $gPB(LANG) "MC(tool,spindle_trans,range,Label)"         "Przedział"
::msgcat::mcset $gPB(LANG) "MC(tool,spindle_trans,code,Label)"          "Kod"
::msgcat::mcset $gPB(LANG) "MC(tool,spindle_trans,min,Label)"           "Minimalnie (obr./min)"
::msgcat::mcset $gPB(LANG) "MC(tool,spindle_trans,max,Label)"           "Maksymalnie (obr./min)"

::msgcat::mcset $gPB(LANG) "MC(tool,spindle_desc,sep,Label)"            " Osobny kod M zakresu (M41, M42 itd.) "
::msgcat::mcset $gPB(LANG) "MC(tool,spindle_desc,range,Label)"          " Numer zakresu z kodem M wrzeciona (M13, M23 itd.)"
::msgcat::mcset $gPB(LANG) "MC(tool,spindle_desc,high,Label)"           " Zakres wysoki/niski z kodem S (S+100/S-100)"
::msgcat::mcset $gPB(LANG) "MC(tool,spindle_desc,odd,Label)"            " Zakres parzysty/nieparzysty z kodem S"


::msgcat::mcset $gPB(LANG) "MC(tool,config,mill_opt1,Label)"            "Nr narzędzia T"
::msgcat::mcset $gPB(LANG) "MC(tool,config,mill_opt2,Label)"            "Numer narzędzia i numer odsunięcia długości"
::msgcat::mcset $gPB(LANG) "MC(tool,config,mill_opt3,Label)"            "Numer odsunięcia długości i numer narzędzia"

::msgcat::mcset $gPB(LANG) "MC(tool,config,title,Label)"                "Konfiguracja kodu narzędzia"
::msgcat::mcset $gPB(LANG) "MC(tool,config,output,Label)"               "Wyjście"

::msgcat::mcset $gPB(LANG) "MC(tool,config,lathe_opt1,Label)"           "Nr narzędzia T"
::msgcat::mcset $gPB(LANG) "MC(tool,config,lathe_opt2,Label)"           "Numer narzędzia i numer odsunięcia długości"
::msgcat::mcset $gPB(LANG) "MC(tool,config,lathe_opt3,Label)"           "Indeks głowicy i numer narzędzia"
::msgcat::mcset $gPB(LANG) "MC(tool,config,lathe_opt4,Label)"           "Indeks głowicy, numer narzędzia i numer odsunięcia długości"

::msgcat::mcset $gPB(LANG) "MC(tool,conf_desc,num,Label)"               "Nr narzędzia T"
::msgcat::mcset $gPB(LANG) "MC(tool,conf_desc,next_num,Label)"          "Numer następnego narzędzia"
::msgcat::mcset $gPB(LANG) "MC(tool,conf_desc,index_num,Label)"         "Indeks głowicy i numer narzędzia"
::msgcat::mcset $gPB(LANG) "MC(tool,conf_desc,index_next_num,Label)"    "Indeks głowicy i numer następnego narzędzia"
::msgcat::mcset $gPB(LANG) "MC(tool,conf_desc,num_len,Label)"           "Numer narzędzia i numer odsunięcia długości"
::msgcat::mcset $gPB(LANG) "MC(tool,conf_desc,next_num_len,Label)"      "Numer następnego narzędzia i numer odsunięcia długości"
::msgcat::mcset $gPB(LANG) "MC(tool,conf_desc,len_num,Label)"           "Numer odsunięcia długości i numer narzędzia"
::msgcat::mcset $gPB(LANG) "MC(tool,conf_desc,len_next_num,Label)"      "Numer odsunięcia długości i numer następnego narzędzia"
::msgcat::mcset $gPB(LANG) "MC(tool,conf_desc,index_num_len,Label)"     "Indeks głowicy, numer narzędzia i numer odsunięcia długości"
::msgcat::mcset $gPB(LANG) "MC(tool,conf_desc,index_next_num_len,Label)"    "Indeks głowicy, numer następnego narzędzia i numer odsunięcia długości"

::msgcat::mcset $gPB(LANG) "MC(tool,oper_trans,title,Label)"            "Komunikat dla operatora"
::msgcat::mcset $gPB(LANG) "MC(tool,cus_trans,title,Label)"             "Polecenie niestandardowe"

##--------------------------
## Labels for Event dialogs
##
::msgcat::mcset $gPB(LANG) "MC(event,feed,IPM_mode)"                "Tryb IPM (cale/min)"

##---------
## G Codes
##
::msgcat::mcset $gPB(LANG) "MC(gcode,tab,Label)"                    "Kody G"
::msgcat::mcset $gPB(LANG) "MC(gcode,Status)"                       "Określ kody G"

##---------
## M Codes
##
::msgcat::mcset $gPB(LANG) "MC(mcode,tab,Label)"                    "Kody M"
::msgcat::mcset $gPB(LANG) "MC(mcode,Status)"                       "Określ kody M"

##-----------------
## Words Summary
##
::msgcat::mcset $gPB(LANG) "MC(addrsum,tab,Label)"                  "Podsumowanie słów"
::msgcat::mcset $gPB(LANG) "MC(addrsum,Status)"                     "Podaj parametry"

::msgcat::mcset $gPB(LANG) "MC(addrsum,col_addr,Label)"             "Word"
::msgcat::mcset $gPB(LANG) "MC(addrsum,col_addr,Context)"           "Adres słowa można edytować, klikając jego nazwę lewym przyciskiem myszy."
::msgcat::mcset $gPB(LANG) "MC(addrsum,col_lead,Label)"             "Linia odniesienia/Kod"
::msgcat::mcset $gPB(LANG) "MC(addrsum,col_data,Label)"             "Typ danych"
::msgcat::mcset $gPB(LANG) "MC(addrsum,col_plus,Label)"             "Plus (+)"
::msgcat::mcset $gPB(LANG) "MC(addrsum,col_lzero,Label)"            "Zero wiodące"
::msgcat::mcset $gPB(LANG) "MC(addrsum,col_int,Label)"              "Całkowite"
::msgcat::mcset $gPB(LANG) "MC(addrsum,col_dec,Label)"              "Ułamek (.)"
::msgcat::mcset $gPB(LANG) "MC(addrsum,col_frac,Label)"             "Ułamek"
::msgcat::mcset $gPB(LANG) "MC(addrsum,col_tzero,Label)"            "Zero końcowe"
::msgcat::mcset $gPB(LANG) "MC(addrsum,col_modal,Label)"            "Modalna ?"
::msgcat::mcset $gPB(LANG) "MC(addrsum,col_min,Label)"              "Minimum"
::msgcat::mcset $gPB(LANG) "MC(addrsum,col_max,Label)"              "Maksimum"
::msgcat::mcset $gPB(LANG) "MC(addrsum,col_trail,Label)"            "Blok końcowy"

::msgcat::mcset $gPB(LANG) "MC(addrsum,radio_text,Label)"           "Tekst"
::msgcat::mcset $gPB(LANG) "MC(addrsum,radio_num,Label)"            "Liczbowy"

::msgcat::mcset $gPB(LANG) "MC(addrsum,addr_trans,title,Label)"     "SŁOWO"
::msgcat::mcset $gPB(LANG) "MC(addrsum,other_trans,title,Label)"    "Inne elementy danych"

##-----------------
## Word Sequencing
##
::msgcat::mcset $gPB(LANG) "MC(wseq,tab,Label)"                     "Sekwencjonowanie słów"
::msgcat::mcset $gPB(LANG) "MC(wseq,Status)"                        "Sekwencja słów"

::msgcat::mcset $gPB(LANG) "MC(wseq,word,Label)"                    "Główna sekwencja słów"
::msgcat::mcset $gPB(LANG) "MC(wseq,word,Context)"                  "Kolejność słów wyświetlanych w wyniku sterowania numerycznego (N/C) można zmienić, przeciągając  dowolne słowo w żądane położenie. \n \nJeśli przeciągane słowo zostaniu uaktywnione (kolor prostokąta uległ zmianie) z innym słowem, położenia tych 2 słów zostaną zamienione. Jeśli słowo zostanie przeciągnięte na separator między 2 słowami, określone słowo zostanie umieszczone między tymi 2 słowami. \n \nKażde słowo można zablokować, aby nie występowało w pliku wyniku sterowania numerycznego (N/C), wyłączając je jednym kliknięciem lewego przycisku myszy. \n \nSłowami można również manipulować za pomocą opcji z menu podręcznego: \n \n * Nowy \n * Edytuj \n * Usuń \n * Aktywuj wszystko \n"

::msgcat::mcset $gPB(LANG) "MC(wseq,active_out,Label)"              " Wynik - Aktywny     "
::msgcat::mcset $gPB(LANG) "MC(wseq,suppressed_out,Label)"          " Wynik - Zablokowany "

::msgcat::mcset $gPB(LANG) "MC(wseq,popup_new,Label)"               "Nowy"
::msgcat::mcset $gPB(LANG) "MC(wseq,popup_undo,Label)"              "Cofnij"
::msgcat::mcset $gPB(LANG) "MC(wseq,popup_edit,Label)"              "Edytuj"
::msgcat::mcset $gPB(LANG) "MC(wseq,popup_delete,Label)"            "Usuń"
::msgcat::mcset $gPB(LANG) "MC(wseq,popup_all,Label)"               "Aktywuj wszystko"
::msgcat::mcset $gPB(LANG) "MC(wseq,transient_win,Label)"           "SŁOWO"
::msgcat::mcset $gPB(LANG) "MC(wseq,cannot_suppress_msg)"           "nie można zablokować. Użyto go jako jeden element w"
::msgcat::mcset $gPB(LANG) "MC(wseq,empty_block_msg)"               "Zablokowanie wyniku tego adresu spowoduje wystąpienie nieprawidłowych pustych bloków."

##----------------
## Custom Command
##
::msgcat::mcset $gPB(LANG) "MC(cust_cmd,tab,Label)"                 "Polecenie niestandardowe"
::msgcat::mcset $gPB(LANG) "MC(cust_cmd,Status)"                    "Definiuj polecenia niestandardowe"

::msgcat::mcset $gPB(LANG) "MC(cust_cmd,name,Label)"                "Nazwa polecenia"
::msgcat::mcset $gPB(LANG) "MC(cust_cmd,name,Context)"              "Wprowadzona nazwa zostanie poprzedzona oznaczeniem PB_CMD_, aby mogła stać się rzeczywistą nazwą polecenia."
::msgcat::mcset $gPB(LANG) "MC(cust_cmd,proc,Label)"                "Procedura"
::msgcat::mcset $gPB(LANG) "MC(cust_cmd,proc,Context)"              "Aby zdefiniować funkcję tego polecenia, należy wprowadzić skrypt Tcl. \n \n * Należy pamiętać, że zawartość tego skryptu nie będzie analizowana przez program Post Builder, ale zostanie zapisana w pliku Tcl. Dlatego też za prawidłowość składniową skryptu odpowiada sam użytkownik."

::msgcat::mcset $gPB(LANG) "MC(cust_cmd,name_msg)"                  "Nieprawidłowa nazwa polecenia niestandardowego.\n Określ inną nazwę"
::msgcat::mcset $gPB(LANG) "MC(cust_cmd,name_msg_1)"                "jest zarezerwowana dla specjalnych poleceń niestandardowych.\n Określ inną nazwę"
::msgcat::mcset $gPB(LANG) "MC(cust_cmd,name_msg_2)"                "Dozwolone są tylko nazwy poleceń niestandardowych VNC, np. \n PB_CMD_vnc____*.\n Określ inną nazwę"

::msgcat::mcset $gPB(LANG) "MC(cust_cmd,import,Label)"              "Importuj"
::msgcat::mcset $gPB(LANG) "MC(cust_cmd,import,Context)"            "Importuj polecenia niestandardowe z wybranego pliku Tcl do postprocesora w toku."
::msgcat::mcset $gPB(LANG) "MC(cust_cmd,export,Label)"              "Eksportuj"
::msgcat::mcset $gPB(LANG) "MC(cust_cmd,export,Context)"            "Eksportuj polecenia niestandardowe z postprocesora do pliku Tcl."
::msgcat::mcset $gPB(LANG) "MC(cust_cmd,import,tree,Label)"         "Importuj polecenia niestandardowe"
::msgcat::mcset $gPB(LANG) "MC(cust_cmd,import,tree,Context)"       "Ta lista zawiera procedury poleceń niestandardowych i inne procedury Tcl występujące w pliku określonym do importu. Podgląd zawartości każdej procedury można wyświetlić, wybierając element na liście jednym kliknięciem lewego przycisku myszy. Każda procedura, która już występuje w postprocesorze w toku, jest oznaczona wskaźnikiem <istnieje>. Dwukrotne kliknięcie elementu lewym przyciskiem myszy powoduje przełączanie pola wyboru występującego obok danego elementu. Umożliwia to zaznaczenie lub usunięcie zaznaczenia procedury do importu. Domyślnie wszystkie procedury są zaznaczone do importu. Aby uniknąć zastąpienia istniejącej procedury, można usunąć zaznaczenie dowolnego elementu."

::msgcat::mcset $gPB(LANG) "MC(cust_cmd,export,tree,Label)"         "Eksportuj polecenia niestandardowe"
::msgcat::mcset $gPB(LANG) "MC(cust_cmd,export,tree,Context)"       "Ta lista zawiera procedury poleceń niestandardowych i inne procedury Tcl występujące w postprocesorze w toku. Można wyświetlić podgląd zawartości każdej procedury, wybierając element na liście jednym kliknięciem lewego przycisku myszy.  Dwukrotne kliknięcie elementu lewym przyciskiem myszy powoduje przełączanie pola wyboru występującego obok danego elementu. Umożliwia to wybranie tylko określonych procedur do eksportu."

::msgcat::mcset $gPB(LANG) "MC(cust_cmd,error,title)"               "Błąd polecenia niestandardowego"
::msgcat::mcset $gPB(LANG) "MC(cust_cmd,error,msg)"                 "Sprawdzanie poprawności poleceń niestandardowych można włączyć lub wyłączyć, ustawiając przełączniki w rozwijanym elemencie menu głównego \"Opcje -> Sprawdź poprawność poleceń niestandardowych\"."

::msgcat::mcset $gPB(LANG) "MC(cust_cmd,select_all,Label)"          "Wybierz wszystko"
::msgcat::mcset $gPB(LANG) "MC(cust_cmd,select_all,Context)"        "Kliknij ten przycisk, aby wybrać wszystkie wyświetlane polecenia do importu lub eksportu."
::msgcat::mcset $gPB(LANG) "MC(cust_cmd,deselect_all,Label)"        "Usuń zaznaczenie wszystkich"
::msgcat::mcset $gPB(LANG) "MC(cust_cmd,deselect_all,Context)"      "Kliknij ten przycisk, aby usunąć zaznaczenie wszystkich poleceń."

::msgcat::mcset $gPB(LANG) "MC(cust_cmd,import,warning,title)"      "Ostrzeżenie dotyczące importu/eksportu poleceń niestandardowych"
::msgcat::mcset $gPB(LANG) "MC(cust_cmd,import,warning,msg)"        "Nie wybrano żadnego elementu do importu lub eksportu."



::msgcat::mcset $gPB(LANG) "MC(cust_cmd,cmd,msg)"                   "Polecenia : "
::msgcat::mcset $gPB(LANG) "MC(cust_cmd,blk,msg)"                   "Bloki : "
::msgcat::mcset $gPB(LANG) "MC(cust_cmd,add,msg)"                   "Adresy: "
::msgcat::mcset $gPB(LANG) "MC(cust_cmd,fmt,msg)"                   "Formaty : "
::msgcat::mcset $gPB(LANG) "MC(cust_cmd,referenced,msg)"            "z powiązaniami w poleceniu niestandardowym "
::msgcat::mcset $gPB(LANG) "MC(cust_cmd,not_defined,msg)"           "nie zostały zdefiniowane w bieżącym zakresie postprocesora w toku."
::msgcat::mcset $gPB(LANG) "MC(cust_cmd,cannot_delete,msg)"         "nie mogą być usunięte."
::msgcat::mcset $gPB(LANG) "MC(cust_cmd,save_post,msg)"             "Czy mimo to chcesz zapisać ten postprocesor?"


##------------------
## Operator Message
##
::msgcat::mcset $gPB(LANG) "MC(opr_msg,text,Label)"                 "Komunikat dla operatora"
::msgcat::mcset $gPB(LANG) "MC(opr_msg,text,Context)"               "Tekst, który ma być wyświetlany jako komunikat dla operatora. Wymagane znaki specjalne na początku i na końcu komunikatu zostaną automatycznie dołączone przez program Post Builder. Te znaki określono na stronie parametrów \"Inne elementy danych\", na karcie \"Definicje danych N/C\"."

::msgcat::mcset $gPB(LANG) "MC(opr_msg,name,Label)"                 "Nazwa komunikatu"
::msgcat::mcset $gPB(LANG) "MC(opr_msg,empty_operator)"             "Komunikat dla operatora nie powinien być pusty."


##--------------
## Linked Posts
##
::msgcat::mcset $gPB(LANG) "MC(link_post,tab,Label)"                "Postprocesory połączone"
::msgcat::mcset $gPB(LANG) "MC(link_post,Status)"                   "Definiuj postprocesory połączone"

::msgcat::mcset $gPB(LANG) "MC(link_post,toggle,Label)"             "Połącz inne postprocesory z tym postprocesorem"
::msgcat::mcset $gPB(LANG) "MC(link_post,toggle,Context)"           "Z tym postprocesorem można połączyć inne postprocesory, aby obsługiwać złożone obrabiarki, które realizują co najmniej dwie kombinacje trybu prostego frezowania i toczenia."

::msgcat::mcset $gPB(LANG) "MC(link_post,head,Label)"               "Głowica"
::msgcat::mcset $gPB(LANG) "MC(link_post,head,Context)"             "Złożona obrabiarka może wykonywać operacje obróbki z użyciem różnych zestawów kinematyki w różnych trybach obróbki. Każdy zestaw kinematyki jest traktowany jako niezależna głowica w programie NX/postprocesorze. Operacje obróbki, wymagające wykonania z użyciem określonej głowicy, zostaną umieszczone razem jako grupa w widoku Obrabiarka lub Metoda obróbki. Następnie UDE \\\"Głowica\\\" zostanie przypisane do grupy w celu określenia nazwy tej głowicy."

::msgcat::mcset $gPB(LANG) "MC(link_post,post,Label)"               "Postprocesor"
::msgcat::mcset $gPB(LANG) "MC(link_post,post,Context)"             "Postprocesor jest przypisany do głowicy w celu uzyskania kodów N/C."

::msgcat::mcset $gPB(LANG) "MC(link_post,link,Label)"               "Postprocesor połączony"
::msgcat::mcset $gPB(LANG) "MC(link_post,link,Context)"             "[::msgcat::mc MC(link_post,head,Context)] \n\n [::msgcat::mc MC(link_post,post,Context)]"


::msgcat::mcset $gPB(LANG) "MC(link_post,new,Label)"                "Nowy"
::msgcat::mcset $gPB(LANG) "MC(link_post,new,Context)"              "Utwórz nowe połączenie."

::msgcat::mcset $gPB(LANG) "MC(link_post,edit,Label)"               "Edytuj"
::msgcat::mcset $gPB(LANG) "MC(link_post,edit,Context)"             "Edytuj połączenie."

::msgcat::mcset $gPB(LANG) "MC(link_post,delete,Label)"             "Usuń"
::msgcat::mcset $gPB(LANG) "MC(link_post,delete,Context)"           "Usuń połączenie."

::msgcat::mcset $gPB(LANG) "MC(link_post,select_name,Label)"        "Wybierz nazwę"
::msgcat::mcset $gPB(LANG) "MC(link_post,select_name,Context)"      "Wybierz nazwę postprocesora, który należy przypisać do głowicy. Ten postprocesor najprawdopodobniej będzie można znaleźć w katalogu postprocesora głównego podczas uruchamiania programu NX/postprocesora. W innym przypadku zostanie użyty postprocesor o tej samej nazwie w katalogu \\\$UGII_CAM_POST_DIR."

::msgcat::mcset $gPB(LANG) "MC(link_post,start_of_head,Label)"      "Początek głowicy"
::msgcat::mcset $gPB(LANG) "MC(link_post,start_of_head,Context)"    "Określ kody N/C lub akcje do wykonania na początku tej głowicy."

::msgcat::mcset $gPB(LANG) "MC(link_post,end_of_head,Label)"        "Koniec głowicy"
::msgcat::mcset $gPB(LANG) "MC(link_post,end_of_head,Context)"      "Określ kody N/C lub akcje do wykonania na końcu tej głowicy."
::msgcat::mcset $gPB(LANG) "MC(link_post,dlg,head,Label)"           "Głowica"
::msgcat::mcset $gPB(LANG) "MC(link_post,dlg,post,Label)"           "Postprocesor"
::msgcat::mcset $gPB(LANG) "MC(link_post,dlg,title,Label)"          "Postprocesor połączony"

#++++++++++++++++++++++
# N/C Data Definitions
#++++++++++++++++++++++
::msgcat::mcset $gPB(LANG) "MC(nc_data,tab,Label)"                  "Definicje danych N/C"

##-------
## BLOCK
##
::msgcat::mcset $gPB(LANG) "MC(block,tab,Label)"                    "BLOCK"
::msgcat::mcset $gPB(LANG) "MC(block,Status)"                       "Definiuj szablony bloku"

::msgcat::mcset $gPB(LANG) "MC(block,name,Label)"                   "Nazwa bloku"
::msgcat::mcset $gPB(LANG) "MC(block,name,Context)"                 "Wprowadź nazwę bloku"

::msgcat::mcset $gPB(LANG) "MC(block,add,Label)"                    "Dodaj słowo"
::msgcat::mcset $gPB(LANG) "MC(block,add,Context)"                  "Nowe słowo można dodać do bloku, naciskając ten przycisk i przeciągając go do bloku wyświetlanego w oknie poniżej. Typ słowa, które zostanie utworzone, można wybrać w polu listy znajdującym się po prawej stronie tego przycisku."

::msgcat::mcset $gPB(LANG) "MC(block,select,Label)"                 "BLOK - Wybór słowa"
::msgcat::mcset $gPB(LANG) "MC(block,select,Context)"               "Z tej listy można wybrać typ żądanego słowa, które należy dodać do bloku."

::msgcat::mcset $gPB(LANG) "MC(block,trash,Label)"                  "BLOK - Kosz"
::msgcat::mcset $gPB(LANG) "MC(block,trash,Context)"                "Z bloku można wyrzucić niechciane słowa, przeciągając je do tego kosza."

::msgcat::mcset $gPB(LANG) "MC(block,word,Label)"                   "BLOK - Słowo"
::msgcat::mcset $gPB(LANG) "MC(block,word,Context)"                 "Z bloku można wyrzucić niechciane słowo, przeciągając je do tego kosza. \n \nMożna również uaktywnić menu podręczne, naciskając prawy przycisk myszy. W menu jest dostępnych wiele usług: \n \n * Edytuj \n * Zmień element -> \n * Opcjonalny \n * Bez separatora słów \n * Wymuś wynik \n * Usuń \n"

::msgcat::mcset $gPB(LANG) "MC(block,verify,Label)"                 "BLOK - Weryfikacja słowa"
::msgcat::mcset $gPB(LANG) "MC(block,verify,Context)"               "W tym oknie jest wyświetlany reprezentatywny kod N/C, który zostanie wyświetlony dla słowa wybranego (naciśniętego) w bloku pokazanym w oknie powyżej."

::msgcat::mcset $gPB(LANG) "MC(block,new_combo,Label)"              "Nowy adres"
::msgcat::mcset $gPB(LANG) "MC(block,text_combo,Label)"             "Element tekstowy"
::msgcat::mcset $gPB(LANG) "MC(block,oper_combo,Label)"             "Komunikat dla operatora"
::msgcat::mcset $gPB(LANG) "MC(block,comm_combo,Label)"             "Polecenie"

::msgcat::mcset $gPB(LANG) "MC(block,edit_popup,Label)"             "Edytuj"
::msgcat::mcset $gPB(LANG) "MC(block,view_popup,Label)"             "Widok"
::msgcat::mcset $gPB(LANG) "MC(block,change_popup,Label)"           "Zmień element"
::msgcat::mcset $gPB(LANG) "MC(block,user_popup,Label)"             "Wyrażenie użytkownika"
::msgcat::mcset $gPB(LANG) "MC(block,opt_popup,Label)"              "Opcjonalnie"
::msgcat::mcset $gPB(LANG) "MC(block,no_sep_popup,Label)"           "Brak separatora słów"
::msgcat::mcset $gPB(LANG) "MC(block,force_popup,Label)"            "Wymuś wynik"
::msgcat::mcset $gPB(LANG) "MC(block,delete_popup,Label)"           "Usuń"
::msgcat::mcset $gPB(LANG) "MC(block,undo_popup,Label)"             "Cofnij"
::msgcat::mcset $gPB(LANG) "MC(block,delete_all,Label)"             "Usuń wszystkie aktywne elementy"

::msgcat::mcset $gPB(LANG) "MC(block,cmd_title,Label)"              "Polecenie niestandardowe"
::msgcat::mcset $gPB(LANG) "MC(block,oper_title,Label)"             "Komunikat dla operatora"
::msgcat::mcset $gPB(LANG) "MC(block,addr_title,Label)"             "SŁOWO"

::msgcat::mcset $gPB(LANG) "MC(block,new_trans,title,Label)"        "SŁOWO"

::msgcat::mcset $gPB(LANG) "MC(block,new,word_desc,Label)"          "Nowy adres"
::msgcat::mcset $gPB(LANG) "MC(block,oper,word_desc,Label)"         "Komunikat dla operatora"
::msgcat::mcset $gPB(LANG) "MC(block,cmd,word_desc,Label)"          "Polecenie niestandardowe"
::msgcat::mcset $gPB(LANG) "MC(block,user,word_desc,Label)"         "Wyrażenie użytkownika"
::msgcat::mcset $gPB(LANG) "MC(block,text,word_desc,Label)"         "Ciąg tekstu"

::msgcat::mcset $gPB(LANG) "MC(block,user,expr,Label)"              "Wyrażenie"

::msgcat::mcset $gPB(LANG) "MC(block,msg,min_word)"                 "Blok powinien zawierać co najmniej jedno słowo."

::msgcat::mcset $gPB(LANG) "MC(block,name_msg)"                     "Nieprawidłowa nazwa bloku.\n Określ inną nazwę."

##---------
## ADDRESS
##
::msgcat::mcset $gPB(LANG) "MC(address,tab,Label)"                  "SŁOWO"
::msgcat::mcset $gPB(LANG) "MC(address,Status)"                     "Definiuj słowa"

::msgcat::mcset $gPB(LANG) "MC(address,name,Label)"                 "Nazwa słowa"
::msgcat::mcset $gPB(LANG) "MC(address,name,Context)"               "Nazwę słowa można edytować."

::msgcat::mcset $gPB(LANG) "MC(address,verify,Label)"               "SŁOWO - Weryfikacja"
::msgcat::mcset $gPB(LANG) "MC(address,verify,Context)"             "W tym oknie jest wyświetlany reprezentatywny kod N/C, który zostanie wyświetlony dla danego słowa."

::msgcat::mcset $gPB(LANG) "MC(address,leader,Label)"               "Linia odniesienia"
::msgcat::mcset $gPB(LANG) "MC(address,leader,Context)"             "Jako blok początkowy słowa można wprowadzić dowolną liczbę znaków lub wybrać znak z menu podręcznego po naciśnięciu prawego przycisku myszy."

::msgcat::mcset $gPB(LANG) "MC(address,format,Label)"               "Format"
::msgcat::mcset $gPB(LANG) "MC(address,format,edit,Label)"          "Edytuj"
::msgcat::mcset $gPB(LANG) "MC(address,format,edit,Context)"        "Ten przycisk umożliwia edytowanie formatu używanego przez słowo."
::msgcat::mcset $gPB(LANG) "MC(address,format,new,Label)"           "Nowy"
::msgcat::mcset $gPB(LANG) "MC(address,format,new,Context)"         "Ten przycisk umożliwia utworzenie nowego formatu."

::msgcat::mcset $gPB(LANG) "MC(address,format,select,Label)"        "SŁOWO - Wybór formatu"
::msgcat::mcset $gPB(LANG) "MC(address,format,select,Context)"      "Ten przycisk umożliwia wybranie innego formatu słowa."

::msgcat::mcset $gPB(LANG) "MC(address,trailer,Label)"              "Blok końcowy"
::msgcat::mcset $gPB(LANG) "MC(address,trailer,Context)"            "Można wprowadzić dowolną liczbę znaków jako blok końcowy słowa lub wybrać znak z menu podręcznego po naciśnięciu prawego przycisku myszy."

::msgcat::mcset $gPB(LANG) "MC(address,modality,Label)"             "Modalna ?"
::msgcat::mcset $gPB(LANG) "MC(address,modality,Context)"           "Ta opcja umożliwia ustawienie modalności słowa."

::msgcat::mcset $gPB(LANG) "MC(address,modal_drop,off,Label)"       "Wyłącz"
::msgcat::mcset $gPB(LANG) "MC(address,modal_drop,once,Label)"      "Raz"
::msgcat::mcset $gPB(LANG) "MC(address,modal_drop,always,Label)"    "Zawsze"

::msgcat::mcset $gPB(LANG) "MC(address,max,value,Label)"            "Maksimum"
::msgcat::mcset $gPB(LANG) "MC(address,max,value,Context)"          "Należy określić maksymalną wartość słowa."

::msgcat::mcset $gPB(LANG) "MC(address,value,text,Label)"           "Wartość"

::msgcat::mcset $gPB(LANG) "MC(address,trunc_drop,Label)"           "Obetnij wartość"
::msgcat::mcset $gPB(LANG) "MC(address,warn_drop,Label)"            "Ostrzeż użytkownika"
::msgcat::mcset $gPB(LANG) "MC(address,abort_drop,Label)"           "Przerwij przetwarzanie"

::msgcat::mcset $gPB(LANG) "MC(address,max,error_handle,Label)"     "Obsługa naruszenia"
::msgcat::mcset $gPB(LANG) "MC(address,max,error_handle,Context)"   "Ten przycisk umożliwia określenie metody obsługi naruszenia wartości maksymalnej: \n \n * Obetnij wartość \n * Ostrzeż użytkownika \n * Przerwij przetwarzanie \n"

::msgcat::mcset $gPB(LANG) "MC(address,min,value,Label)"            "Minimum"
::msgcat::mcset $gPB(LANG) "MC(address,min,value,Context)"          "Należy określić minimalną wartość słowa."

::msgcat::mcset $gPB(LANG) "MC(address,min,error_handle,Label)"     "Obsługa naruszenia"
::msgcat::mcset $gPB(LANG) "MC(address,min,error_handle,Context)"   "Ten przycisk umożliwia określenie metody obsługi naruszenia wartości minimalnej: \n \n * Obetnij wartość \n * Ostrzeż użytkownika \n * Przerwij przetwarzanie \n"

::msgcat::mcset $gPB(LANG) "MC(address,format_trans,title,Label)"   "FORMAT "
::msgcat::mcset $gPB(LANG) "MC(address,none_popup,Label)"           "Brak"

::msgcat::mcset $gPB(LANG) "MC(address,exp,Label)"                  "Wyrażenie"
::msgcat::mcset $gPB(LANG) "MC(address,exp,Context)"                "Można określić wyrażenie lub stałą bloku."
::msgcat::mcset $gPB(LANG) "MC(address,exp,msg)"                    "Wyrażenie dla elementu Blok nie powinno być puste."
::msgcat::mcset $gPB(LANG) "MC(address,exp,space_only)"             "Wyrażenie dla elementu Blok z użyciem formatu liczbowego nie może zawierać samych spacji."

## No translation is needed for this string.
::msgcat::mcset $gPB(LANG) "MC(address,exp,spec_char)"              "\!  \"  \#  \&  \'  \.  \;  \<  \=  \>  \?  \@ \[  \\  \]  \^  \`  \{  \|  \}  \~"

::msgcat::mcset $gPB(LANG) "MC(address,exp,spec_char_msg)"          "Znaki specjalne \n [::msgcat::mc MC(address,exp,spec_char)] \n nie mogą być używane w wyrażeniu dla danych liczbowych."



::msgcat::mcset $gPB(LANG) "MC(address,name_msg)"                   "Nieprawidłowa nazwa słowa.\n Określ inną nazwę."
# - No translation for rapid1, rapid2 & rapid3
::msgcat::mcset $gPB(LANG) "MC(address,rapid_add_name_msg)"         "rapid1, rapid2 i rapid3 są zarezerwowane do użytku wewnętrznego przez program Post Builder.\n Określ inną nazwę."

::msgcat::mcset $gPB(LANG) "MC(address,rapid1,desc)"                "Szybka pozycja wzdłuż osi wzdłużnej"
::msgcat::mcset $gPB(LANG) "MC(address,rapid2,desc)"                "Szybka pozycja wzdłuż osi poprzecznej"
::msgcat::mcset $gPB(LANG) "MC(address,rapid3,desc)"                "Szybka pozycja wzdłuż osi wrzeciona"

##--------
## FORMAT
##
::msgcat::mcset $gPB(LANG) "MC(format,tab,Label)"                   "FORMAT"
::msgcat::mcset $gPB(LANG) "MC(format,Status)"                      "Definiuj formaty"

::msgcat::mcset $gPB(LANG) "MC(format,verify,Label)"                "FORMAT - Weryfikacja"
::msgcat::mcset $gPB(LANG) "MC(format,verify,Context)"              "W tym oknie jest wyświetlany reprezentatywny kod N/C, który zostanie wyświetlony z użyciem określonego formatu."

::msgcat::mcset $gPB(LANG) "MC(format,name,Label)"                  "Nazwa formatu"
::msgcat::mcset $gPB(LANG) "MC(format,name,Context)"                "Nazwę formatu można edytować."

::msgcat::mcset $gPB(LANG) "MC(format,data,type,Label)"             "Typ danych"
::msgcat::mcset $gPB(LANG) "MC(format,data,type,Context)"           "Należy określić typ danych dla formatu."
::msgcat::mcset $gPB(LANG) "MC(format,data,num,Label)"              "Liczbowy"
::msgcat::mcset $gPB(LANG) "MC(format,data,num,Context)"            "Za pomocą tej opcji można zdefiniować typ danych formatu jako Liczbowy."
::msgcat::mcset $gPB(LANG) "MC(format,data,num,integer,Label)"      "FORMAT - Cyfry liczb całkowitych"
::msgcat::mcset $gPB(LANG) "MC(format,data,num,integer,Context)"    "Ta opcja umożliwia określenie ilości liczb całkowitych lub części całkowitej liczby rzeczywistej."
::msgcat::mcset $gPB(LANG) "MC(format,data,num,fraction,Label)"     "FORMAT - Cyfry ułamka"
::msgcat::mcset $gPB(LANG) "MC(format,data,num,fraction,Context)"   "Ta opcja umożliwia określenie liczby cyfr części ułamkowej liczby rzeczywistej."
::msgcat::mcset $gPB(LANG) "MC(format,data,num,decimal,Label)"      "Wyświetlanie separatora dziesiętnego (.)"
::msgcat::mcset $gPB(LANG) "MC(format,data,num,decimal,Context)"    "Ta opcja umożliwia wyświetlanie separatorów dziesiętnych w kodzie N/C."
::msgcat::mcset $gPB(LANG) "MC(format,data,num,lead,Label)"         "Wyświetlanie zer wiodących"
::msgcat::mcset $gPB(LANG) "MC(format,data,num,lead,Context)"       "Ta opcja umożliwia wypełnianie liczb w kodzie N/C zerami wiodącymi."
::msgcat::mcset $gPB(LANG) "MC(format,data,num,trail,Label)"        "Wyświetlanie zer końcowych"
::msgcat::mcset $gPB(LANG) "MC(format,data,num,trail,Context)"      "Ta opcja umożliwia wypełnianie liczb rzeczywistych w kodzie N/C zerami końcowymi."
::msgcat::mcset $gPB(LANG) "MC(format,data,text,Label)"             "Tekst"
::msgcat::mcset $gPB(LANG) "MC(format,data,text,Context)"           "Za pomocą tej opcji można zdefiniować typ danych formatu jako Ciąg tekstu."
::msgcat::mcset $gPB(LANG) "MC(format,data,plus,Label)"             "Wyświetlanie wiodącego znaku plus (+)"
::msgcat::mcset $gPB(LANG) "MC(format,data,plus,Context)"           "Ta opcja umożliwia wyświetlanie znaków plus w kodzie N/C."
::msgcat::mcset $gPB(LANG) "MC(format,zero_msg)"                    "Nie można wykonać kopii formatu zerowego"
::msgcat::mcset $gPB(LANG) "MC(format,zero_cut_msg)"                "Nie można usunąć formatu zerowego"

::msgcat::mcset $gPB(LANG) "MC(format,data,dec_zero,msg)"           "Musi być zaznaczona przynajmniej jedna z następujących opcji: Separator dziesiętny, Zera wiodące lub Zera końcowe."

::msgcat::mcset $gPB(LANG) "MC(format,data,no_digit,msg)"           "Liczba cyfr w liczbach całkowitych i ułamkach nie może być jednocześnie zerowa."

::msgcat::mcset $gPB(LANG) "MC(format,name_msg)"                    "Nieprawidłowa nazwa formatu.\n Określ inną nazwę."
::msgcat::mcset $gPB(LANG) "MC(format,error,title)"                 "Błąd formatu"
::msgcat::mcset $gPB(LANG) "MC(format,error,msg)"                   "Ten format został użyty w adresach"

##---------------------
## Other Data Elements
##
::msgcat::mcset $gPB(LANG) "MC(other,tab,Label)"                    "Inne elementy danych"
::msgcat::mcset $gPB(LANG) "MC(other,Status)"                       "Określ parametry"

::msgcat::mcset $gPB(LANG) "MC(other,seq_num,Label)"                "Kolejny numer"
::msgcat::mcset $gPB(LANG) "MC(other,seq_num,Context)"              "Ten przełącznik umożliwia włączenie/wyłączenie wyświetlania kolejnych numerów w kodzie N/C."
::msgcat::mcset $gPB(LANG) "MC(other,seq_num,start,Label)"          "Początek kolejnego numeru"
::msgcat::mcset $gPB(LANG) "MC(other,seq_num,start,Context)"        "Określ początek kolejnego numeru."
::msgcat::mcset $gPB(LANG) "MC(other,seq_num,inc,Label)"            "Przyrost kolejnego numeru"
::msgcat::mcset $gPB(LANG) "MC(other,seq_num,inc,Context)"          "Określ przyrost kolejnego numeru."
::msgcat::mcset $gPB(LANG) "MC(other,seq_num,freq,Label)"           "Częstotliwość kolejnych numerów"
::msgcat::mcset $gPB(LANG) "MC(other,seq_num,freq,Context)"         "Określ częstotliwość kolejnych numerów wyświetlanych w kodzie N/C."
::msgcat::mcset $gPB(LANG) "MC(other,seq_num,max,Label)"            "Maksymalny kolejny numer"
::msgcat::mcset $gPB(LANG) "MC(other,seq_num,max,Context)"          "Określ maksymalną wartość kolejnego numeru."

::msgcat::mcset $gPB(LANG) "MC(other,chars,Label)"                  "Znaki specjalne"
::msgcat::mcset $gPB(LANG) "MC(other,chars,word_sep,Label)"         "Separator słów"
::msgcat::mcset $gPB(LANG) "MC(other,chars,word_sep,Context)"       "Określ znak używany jako separator słów."
::msgcat::mcset $gPB(LANG) "MC(other,chars,decimal_pt,Label)"       "Separator dziesiętny"
::msgcat::mcset $gPB(LANG) "MC(other,chars,decimal_pt,Context)"     "Określ znak używany jako separator dziesiętny."
::msgcat::mcset $gPB(LANG) "MC(other,chars,end_of_block,Label)"     "Koniec bloku"
::msgcat::mcset $gPB(LANG) "MC(other,chars,end_of_block,Context)"   "Określ znak używany jako koniec bloku."
::msgcat::mcset $gPB(LANG) "MC(other,chars,comment_start,Label)"    "Początek komunikatu"
::msgcat::mcset $gPB(LANG) "MC(other,chars,comment_start,Context)"  "Określ znaki używane jako początek wiersza komunikatu operatora."
::msgcat::mcset $gPB(LANG) "MC(other,chars,comment_end,Label)"      "Koniec komunikatu"
::msgcat::mcset $gPB(LANG) "MC(other,chars,comment_end,Context)"    "Określ znaki używane jako koniec wiersza komunikatu operatora."

::msgcat::mcset $gPB(LANG) "MC(other,opskip,Label)"                 "PRZESKOK OPCJONALNY"
::msgcat::mcset $gPB(LANG) "MC(other,opskip,leader,Label)"          "Linia odniesienia linii"
::msgcat::mcset $gPB(LANG) "MC(other,opskip,leader,Context)"        "Linia odniesienia linii PRZESKOKU OPCJONALNEGO"

::msgcat::mcset $gPB(LANG) "MC(other,gm_codes,Label)"               "Wynik kodów G i M na blok"
::msgcat::mcset $gPB(LANG) "MC(other,g_codes,Label)"                "Liczba kodów G na blok"
::msgcat::mcset $gPB(LANG) "MC(other,g_codes,Context)"              "Ten przełącznik umożliwia włączenie/wyłączenie kontrolowania liczby kodów G na blok wyników N/C."
::msgcat::mcset $gPB(LANG) "MC(other,g_codes,num,Label)"            "Liczba kodów G"
::msgcat::mcset $gPB(LANG) "MC(other,g_codes,num,Context)"          "Określ liczbę kodów G na blok wyników N/C."
::msgcat::mcset $gPB(LANG) "MC(other,m_codes,Label)"                "Liczba kodów M"
::msgcat::mcset $gPB(LANG) "MC(other,m_codes,Context)"              "Ten przełącznik umożliwia włączenie/wyłączenie kontrolowania liczby kodów M na blok wyników N/C."
::msgcat::mcset $gPB(LANG) "MC(other,m_codes,num,Label)"            "Liczba kodów M na blok"
::msgcat::mcset $gPB(LANG) "MC(other,m_codes,num,Context)"          "Określ liczbę kodów M na blok wyników N/C."

::msgcat::mcset $gPB(LANG) "MC(other,opt_none,Label)"               "Brak"
::msgcat::mcset $gPB(LANG) "MC(other,opt_space,Label)"              "Przestrzeń"
::msgcat::mcset $gPB(LANG) "MC(other,opt_dec,Label)"                "Ułamek (.)"
::msgcat::mcset $gPB(LANG) "MC(other,opt_comma,Label)"              "Przecinek (,)"
::msgcat::mcset $gPB(LANG) "MC(other,opt_semi,Label)"               "Średnik (;)"
::msgcat::mcset $gPB(LANG) "MC(other,opt_colon,Label)"              "Dwukropek (:)"
::msgcat::mcset $gPB(LANG) "MC(other,opt_text,Label)"               "Ciąg tekstu"
::msgcat::mcset $gPB(LANG) "MC(other,opt_left,Label)"               "Lewy nawias okrągły ("
::msgcat::mcset $gPB(LANG) "MC(other,opt_right,Label)"              "Prawy nawias okrągły )"
::msgcat::mcset $gPB(LANG) "MC(other,opt_pound,Label)"              "Znak funta (\#)"
::msgcat::mcset $gPB(LANG) "MC(other,opt_aster,Label)"              "Gwiazdka (*)"
::msgcat::mcset $gPB(LANG) "MC(other,opt_slash,Label)"              "Ukośnik (/)"
::msgcat::mcset $gPB(LANG) "MC(other,opt_new_line,Label)"           "Nowa linia (\\012)"

# UDE Inclusion
::msgcat::mcset $gPB(LANG) "MC(other,ude,Label)"                    "Zdarzenia użytkownika"
::msgcat::mcset $gPB(LANG) "MC(other,ude_include,Label)"            "Uwzględnij inny plik CDL"
::msgcat::mcset $gPB(LANG) "MC(other,ude_include,Context)"          "Ta opcja umożliwia uwzględnienie w tym postprocesorze odwołania do pliku CDL w pliku definicji."

::msgcat::mcset $gPB(LANG) "MC(other,ude_file,Label)"               "Nazwa pliku CDL"
::msgcat::mcset $gPB(LANG) "MC(other,ude_file,Context)"             "Ścieżka i nazwa pliku CDL, który zostanie powiązany (UWZGLĘDNIONY) w pliku definicji tego postprocesora. Nazwa ścieżki musi rozpoczynać się od zmiennej środowiskowej UG (\\\$UGII) lub być pusta. Jeśli nie określono ścieżki, do zlokalizowania pliku przez UG/NX podczas działania zostanie użyta zmienna UGII_CAM_FILE_SEARCH_PATH."
::msgcat::mcset $gPB(LANG) "MC(other,ude_select,Label)"             "Wybierz nazwę"
::msgcat::mcset $gPB(LANG) "MC(other,ude_select,Context)"           "Wybierz plik CDL, który należy powiązać (UWZGLĘDNIĆ) w pliku definicji tego postprocesora. Domyślnie wybrana nazwa pliku zostanie dołączona przed zmienną \\\$UGII_CAM_USER_DEF_EVENT_DIR/. Nazwę ścieżki można edytować według potrzeb po dokonaniu wyboru."


#+++++++++++++++++
# Output Settings
#+++++++++++++++++
::msgcat::mcset $gPB(LANG) "MC(output,tab,Label)"                   "Ustawienia wyjścia"
::msgcat::mcset $gPB(LANG) "MC(output,Status)"                      "Konfiguruj parametry wyjściowe"

#++++++++++++++
# VNC Controls
#++++++++++++++
::msgcat::mcset $gPB(LANG) "MC(output,vnc,Label)"                   "Wirtualny sterownik N/C"
::msgcat::mcset $gPB(LANG) "MC(output,vnc,mode,std,Label)"          "Niezależne"
::msgcat::mcset $gPB(LANG) "MC(output,vnc,mode,sub,Label)"          "Podrzędne"
::msgcat::mcset $gPB(LANG) "MC(output,vnc,status,Label)"            "Wybierz plik VNC."
::msgcat::mcset $gPB(LANG) "MC(output,vnc,mis_match,Label)"         "Wybrany plik nie jest zgodny z domyślną nazwą pliku VNC.\n Czy chcesz ponownie wybrać ten plik?"
::msgcat::mcset $gPB(LANG) "MC(output,vnc,output,Label)"            "Generuj wirtualny sterownik N/C (VNC)"
::msgcat::mcset $gPB(LANG) "MC(output,vnc,output,Context)"          "Ta opcja umożliwia generowanie wirtualnego sterownika N/C (VNC). Postprocesor utworzony z włączonym sterownikiem VNC może być zatem użyty w ramach ISV."
::msgcat::mcset $gPB(LANG) "MC(output,vnc,main,Label)"              "Główny sterownik VNC"
::msgcat::mcset $gPB(LANG) "MC(output,vnc,main,Context)"            "Nazwa głównego sterownika VNC, która będzie pochodzić z podrzędnego sterownika VNC. Podczas uruchamiania ISV ten postprocesor najprawdopodobniej będzie można znaleźć w katalogu podrzędnego postprocesora VNC. W innym przypadku zostanie użyty postprocesor o tej samej nazwie w katalogu \\\$UGII_CAM_POST_DIR."


::msgcat::mcset $gPB(LANG) "MC(output,vnc,main,err_msg)"                 "Główny sterownik VNC musi być określony dla podrzędnego sterownika VNC."
::msgcat::mcset $gPB(LANG) "MC(output,vnc,main,select_name,Label)"       "Wybierz nazwę"
::msgcat::mcset $gPB(LANG) "MC(output,vnc,main,select_name,Context)"     "Wybierz nazwę sterownika VNC, która będzie pochodzić z podrzędnego sterownika VNC. W czasie wykonywania ISV ten postprocesor najprawdopodobniej będzie można znaleźć w katalogu podrzędnego postprocesora VNC. W innym przypadku zostanie użyty postprocesor o tej samej nazwie w katalogu \\\$UGII_CAM_POST_DIR."

::msgcat::mcset $gPB(LANG) "MC(output,vnc,mode,Label)"                   "Tryb wirtualnego sterownika N/C"
::msgcat::mcset $gPB(LANG) "MC(output,vnc,mode,Context)"                 "Wirtualny sterownik N/C może być niezależny lub podrzędny względem głównego sterownika VNC."
::msgcat::mcset $gPB(LANG) "MC(output,vnc,mode,std,Context)"             "Niezależny sterownik VNC działa niezależnie."
::msgcat::mcset $gPB(LANG) "MC(output,vnc,mode,sub,Context)"             "Podrzędny sterownik VNC jest przede wszystkim zależny od głównego sterownika VNC. Będzie pochodzić z głównego sterownika VNC podczas uruchamiania ISV."
::msgcat::mcset $gPB(LANG) "MC(output,vnc,pb_ver,msg)"                   "Wirtualny sterownik N/C utworzony za pomocą programu Post Builder "
#++++++++++++++
# Listing File
#++++++++++++++
::msgcat::mcset $gPB(LANG) "MC(listing,tab,Label)"                  "Plik listy"
::msgcat::mcset $gPB(LANG) "MC(listing,Status)"                     "Określ parametry pliku listy"

::msgcat::mcset $gPB(LANG) "MC(listing,gen,Label)"                  "Generuj plik listy"
::msgcat::mcset $gPB(LANG) "MC(listing,gen,Context)"                "Ten przełącznik umożliwia włączenie/wyłączenie wyświetlania pliku listy."

::msgcat::mcset $gPB(LANG) "MC(listing,Label)"                      "Elementy pliku listy"
::msgcat::mcset $gPB(LANG) "MC(listing,parms,Label)"                "Komponenty"

::msgcat::mcset $gPB(LANG) "MC(listing,parms,x,Label)"              "Współrzędna X"
::msgcat::mcset $gPB(LANG) "MC(listing,parms,x,Context)"            "Ten przełącznik umożliwia włączenie/wyłączenie wyświetlania współrzędnych X w pliku listy."

::msgcat::mcset $gPB(LANG) "MC(listing,parms,y,Label)"              "Współrzędna Y"
::msgcat::mcset $gPB(LANG) "MC(listing,parms,y,Context)"            "Ten przełącznik umożliwia włączenie/wyłączenie wyświetlania współrzędnych Y w pliku listy."

::msgcat::mcset $gPB(LANG) "MC(listing,parms,z,Label)"              "Współrzędna Z"
::msgcat::mcset $gPB(LANG) "MC(listing,parms,z,Context)"            "Ten przełącznik umożliwia włączenie/wyłączenie wyświetlania współrzędnych Z w pliku listy."

::msgcat::mcset $gPB(LANG) "MC(listing,parms,4,Label)"              "Kąt 4. osi"
::msgcat::mcset $gPB(LANG) "MC(listing,parms,4,Context)"            "Ten przełącznik umożliwia włączenie/wyłączenie wyświetlania kąta 4. osi w pliku listy."

::msgcat::mcset $gPB(LANG) "MC(listing,parms,5,Label)"              "Kąt 5. osi"
::msgcat::mcset $gPB(LANG) "MC(listing,parms,5,Context)"            "Ten przełącznik umożliwia włączenie/wyłączenie wyświetlania kąta 5. osi w pliku listy."

::msgcat::mcset $gPB(LANG) "MC(listing,parms,feed,Label)"           "Posuw"
::msgcat::mcset $gPB(LANG) "MC(listing,parms,feed,Context)"         "Ten przełącznik umożliwia włączenie/wyłączenie wyświetlania posuwu w pliku listy."

::msgcat::mcset $gPB(LANG) "MC(listing,parms,speed,Label)"          "Szybkość"
::msgcat::mcset $gPB(LANG) "MC(listing,parms,speed,Context)"        "Ten przełącznik umożliwia włączenie/wyłączenie wyświetlania prędkości wrzeciona w pliku listy."

::msgcat::mcset $gPB(LANG) "MC(listing,extension,Label)"            "Rozszerzenie pliku listy"
::msgcat::mcset $gPB(LANG) "MC(listing,extension,Context)"          "Określ rozszerzenie pliku listy"

::msgcat::mcset $gPB(LANG) "MC(listing,nc_file,Label)"              "Rozszerzenie pliku wyjściowego N/C"
::msgcat::mcset $gPB(LANG) "MC(listing,nc_file,Context)"            "Określ rozszerzenie pliku wyjściowego N/C"

::msgcat::mcset $gPB(LANG) "MC(listing,header,Label)"               "Nagłówek programu"
::msgcat::mcset $gPB(LANG) "MC(listing,header,oper_list,Label)"     "Lista operacji"
::msgcat::mcset $gPB(LANG) "MC(listing,header,tool_list,Label)"     "Lista narzędzi"

::msgcat::mcset $gPB(LANG) "MC(listing,footer,Label)"               "Stopka programu"
::msgcat::mcset $gPB(LANG) "MC(listing,footer,cut_time,Label)"      "Całkowity czas obróbki"

::msgcat::mcset $gPB(LANG) "MC(listing,format,Label)"                   "Format strony"
::msgcat::mcset $gPB(LANG) "MC(listing,format,print_header,Label)"      "Drukuj nagłówek strony"
::msgcat::mcset $gPB(LANG) "MC(listing,format,print_header,Context)"    "Ten przełącznik umożliwia włączenie/wyłączenie wyświetlania nagłówka strony w pliku listy."

::msgcat::mcset $gPB(LANG) "MC(listing,format,length,Label)"        "Długość strony (wiersze)"
::msgcat::mcset $gPB(LANG) "MC(listing,format,length,Context)"      "Określ liczbę wierszy na stronie pliku listy."
::msgcat::mcset $gPB(LANG) "MC(listing,format,width,Label)"         "Szerokość strony (kolumny)"
::msgcat::mcset $gPB(LANG) "MC(listing,format,width,Context)"       "Określ liczbę kolumn na stronie pliku listy."

::msgcat::mcset $gPB(LANG) "MC(listing,other,tab,Label)"            "Inne opcje"
::msgcat::mcset $gPB(LANG) "MC(listing,output,Label)"               "Wyświetlaj elementy sterujące"

::msgcat::mcset $gPB(LANG) "MC(listing,output,warning,Label)"       "Wyświetlaj komunikaty ostrzegawcze"
::msgcat::mcset $gPB(LANG) "MC(listing,output,warning,Context)"     "Ten przełącznik umożliwia włączenie/wyłączenie wyświetlania komunikatów ostrzegawczych podczas przetwarzania końcowego."

::msgcat::mcset $gPB(LANG) "MC(listing,output,review,Label)"        "Aktywuj narzędzie sprawdzania"
::msgcat::mcset $gPB(LANG) "MC(listing,output,review,Context)"      "Ten przełącznik umożliwia uaktywnienie narzędzia sprawdzania podczas przetwarzania końcowego."

::msgcat::mcset $gPB(LANG) "MC(listing,output,group,Label)"         "Generuj wyświetlanie grupy"
::msgcat::mcset $gPB(LANG) "MC(listing,output,group,Context)"       "Ten przełącznik umożliwia włączenie/wyłączenie kontrolowania wyświetlania grupy podczas przetwarzania końcowego."

::msgcat::mcset $gPB(LANG) "MC(listing,output,verbose,Label)"       "Wyświetl opisowe komunikaty o błędach"
::msgcat::mcset $gPB(LANG) "MC(listing,output,verbose,Context)"     "Ten przełącznik umożliwia wyświetlenie rozszerzonych opisów warunków błędu. Spowoduje niewielkie zmniejszenie prędkości przetwarzania końcowego."

::msgcat::mcset $gPB(LANG) "MC(listing,oper_info,Label)"            "Informacje o operacji"
::msgcat::mcset $gPB(LANG) "MC(listing,oper_info,parms,Label)"      "Parametry operacji"
::msgcat::mcset $gPB(LANG) "MC(listing,oper_info,tool,Label)"       "Parametry narzędzia"
::msgcat::mcset $gPB(LANG) "MC(listing,oper_info,cut_time,,Label)"  "Czas obróbki"


#<09-19-00 gsl>
::msgcat::mcset $gPB(LANG) "MC(listing,user_tcl,frame,Label)"       "Źródło Tcl użytkownika"
::msgcat::mcset $gPB(LANG) "MC(listing,user_tcl,check,Label)"       "Źródłowy plik Tcl użytkownika"
::msgcat::mcset $gPB(LANG) "MC(listing,user_tcl,check,Context)"     "Ten przełącznik umożliwia wyświetlenie własnego pliku Tcl"
::msgcat::mcset $gPB(LANG) "MC(listing,user_tcl,name,Label)"        "Nazwa pliku"
::msgcat::mcset $gPB(LANG) "MC(listing,user_tcl,name,Context)"      "Określ nazwę pliku Tcl, który należy wyświetlić dla tego postprocesora"

#++++++++++++++++
# Output Preview
#++++++++++++++++
::msgcat::mcset $gPB(LANG) "MC(preview,tab,Label)"                  "Podgląd plików postprocesora"
::msgcat::mcset $gPB(LANG) "MC(preview,new_code,Label)"             "Nowy kod"
::msgcat::mcset $gPB(LANG) "MC(preview,old_code,Label)"             "Stary kod"

##---------------------
## Event Handler
##
::msgcat::mcset $gPB(LANG) "MC(event_handler,tab,Label)"            "Programy obsługi zdarzeń"
::msgcat::mcset $gPB(LANG) "MC(event_handler,Status)"               "Wybierz zdarzenie, aby wyświetlić procedurę"

##---------------------
## Definition
##
::msgcat::mcset $gPB(LANG) "MC(definition,tab,Label)"               "Definicje"
::msgcat::mcset $gPB(LANG) "MC(definition,Status)"                  "Wybierz obiekt, aby wyświetlić zawartość"

#++++++++++++++
# Post Advisor
#++++++++++++++
::msgcat::mcset $gPB(LANG) "MC(advisor,tab,Label)"                  "Doradca postprocesora"
::msgcat::mcset $gPB(LANG) "MC(advisor,Status)"                     "Doradca postprocesora"

::msgcat::mcset $gPB(LANG) "MC(definition,word_txt,Label)"          "WORD_SEPARATOR"
::msgcat::mcset $gPB(LANG) "MC(definition,end_txt,Label)"           "END_OF_BLOCK"
::msgcat::mcset $gPB(LANG) "MC(definition,seq_txt,Label)"           "SEQUENCE_NUM"
::msgcat::mcset $gPB(LANG) "MC(definition,include,Label)"           "UWZGLĘDNIJ"
::msgcat::mcset $gPB(LANG) "MC(definition,format_txt,Label)"        "FORMAT"
::msgcat::mcset $gPB(LANG) "MC(definition,addr_txt,Label)"          "SŁOWO"
::msgcat::mcset $gPB(LANG) "MC(definition,block_txt,Label)"         "BLOK"
::msgcat::mcset $gPB(LANG) "MC(definition,comp_txt,Label)"          "BLOK złożony"
::msgcat::mcset $gPB(LANG) "MC(definition,post_txt,Label)"          "BLOK postprocesora"
::msgcat::mcset $gPB(LANG) "MC(definition,oper_txt,Label)"          "Pozorny BLOK komunikatu"

#+++++++++++++
# Balloon
#+++++++++++++
::msgcat::mcset $gPB(LANG) "MC(msg,odd)"                            "Nieparzysta liczba argumentów opcjonalnych"
::msgcat::mcset $gPB(LANG) "MC(msg,wrong_list_1)"                   "Nieznane opcje"
::msgcat::mcset $gPB(LANG) "MC(msg,wrong_list_2)"                   ". Musi być jednym z:"

#+++++++++++++++++
# Event UI Labels
#+++++++++++++++++

### Program Start
::msgcat::mcset $gPB(LANG) "MC(event,start_prog,name)"              "Początek programu"

### Operation Start
::msgcat::mcset $gPB(LANG) "MC(event,opr_start,start_path,name)"    "Początek ścieżki"
::msgcat::mcset $gPB(LANG) "MC(event,opr_start,from_move,name)"     "Od ruchu"
::msgcat::mcset $gPB(LANG) "MC(event,opr_start,fst_tool,name)"      "Pierwsze narzędzie"
::msgcat::mcset $gPB(LANG) "MC(event,opr_start,auto_tc,name)"       "Automatyczna zmiana narzędzia"
::msgcat::mcset $gPB(LANG) "MC(event,opr_start,manual_tc,name)"     "Ręczna zmiana narzędzia"
::msgcat::mcset $gPB(LANG) "MC(event,opr_start,init_move,name)"     "Początkowy ruch"
::msgcat::mcset $gPB(LANG) "MC(event,opr_start,fst_move,name)"      "Pierwszy ruch"
::msgcat::mcset $gPB(LANG) "MC(event,opr_start,appro_move,name)"    "Ruch dojazdu"
::msgcat::mcset $gPB(LANG) "MC(event,opr_start,engage_move,name)"   "Ruch wejścia"
::msgcat::mcset $gPB(LANG) "MC(event,opr_start,fst_cut,name)"       "Pierwsza ścieżka"
::msgcat::mcset $gPB(LANG) "MC(event,opr_start,fst_lin_move,name)"  "Pierwszy ruch liniowy"
::msgcat::mcset $gPB(LANG) "MC(event,opr_start,start_pass,name)"    "Początek przejścia"
::msgcat::mcset $gPB(LANG) "MC(event,opr_start,cutcom_move,name)"   "Ruch korekcji promieni"
::msgcat::mcset $gPB(LANG) "MC(event,opr_start,lead_move,name)"     "Ruch wejścia"

### Operation End
::msgcat::mcset $gPB(LANG) "MC(event,opr_end,ret_move,name)"        "Ruch wyjścia"
::msgcat::mcset $gPB(LANG) "MC(event,opr_end,rtn_move,name)"        "Ruch powrotu"
::msgcat::mcset $gPB(LANG) "MC(event,opr_end,goh_move,name)"        "Ruch zakończenia"
::msgcat::mcset $gPB(LANG) "MC(event,opr_end,end_path,name)"        "Koniec ścieżki"
::msgcat::mcset $gPB(LANG) "MC(event,opr_end,lead_move,name)"       "Ruch wyjścia"
::msgcat::mcset $gPB(LANG) "MC(event,opr_end,end_pass,name)"        "Koniec przejścia"

### Program End
::msgcat::mcset $gPB(LANG) "MC(event,end_prog,name)"                "Koniec programu"


### Tool Change
::msgcat::mcset $gPB(LANG) "MC(event,tool_change,name)"             "Zmiana narzędzia"
::msgcat::mcset $gPB(LANG) "MC(event,tool_change,m_code)"           "Kod M"
::msgcat::mcset $gPB(LANG) "MC(event,tool_change,m_code,tl_chng)"   "Zmiana narzędzia"
::msgcat::mcset $gPB(LANG) "MC(event,tool_change,m_code,pt)"        "Głowica główna"
::msgcat::mcset $gPB(LANG) "MC(event,tool_change,m_code,st)"        "Głowica pomocnicza"
::msgcat::mcset $gPB(LANG) "MC(event,tool_change,t_code)"           "Kod T"
::msgcat::mcset $gPB(LANG) "MC(event,tool_change,t_code,conf)"      "Konfiguruj"
::msgcat::mcset $gPB(LANG) "MC(event,tool_change,t_code,pt_idx)"    "Indeks głowicy głównej"
::msgcat::mcset $gPB(LANG) "MC(event,tool_change,t_code,st_idx)"    "Indeks głowicy pomocniczej"
::msgcat::mcset $gPB(LANG) "MC(event,tool_change,tool_num)"         "Nr narzędzia T"
::msgcat::mcset $gPB(LANG) "MC(event,tool_change,tool_num,min)"     "Minimum"
::msgcat::mcset $gPB(LANG) "MC(event,tool_change,tool_num,max)"     "Maksimum"
::msgcat::mcset $gPB(LANG) "MC(event,tool_change,time)"             "Czas (s)"
::msgcat::mcset $gPB(LANG) "MC(event,tool_change,time,tl_chng)"     "Zmiana narzędzia"
::msgcat::mcset $gPB(LANG) "MC(event,tool_change,retract)"          "Wyjście"
::msgcat::mcset $gPB(LANG) "MC(event,tool_change,retract_z)"        "Wyjście do Z z"

### Length Compensation
::msgcat::mcset $gPB(LANG) "MC(event,length_compn,name)"            "Kompensacja długości"
::msgcat::mcset $gPB(LANG) "MC(event,length_compn,g_code)"          "Kod G"
::msgcat::mcset $gPB(LANG) "MC(event,length_compn,g_code,len_adj)"  "Dopasuj długość narzędzia"
::msgcat::mcset $gPB(LANG) "MC(event,length_compn,t_code)"          "Kod T"
::msgcat::mcset $gPB(LANG) "MC(event,length_compn,t_code,conf)"     "Konfiguruj"
::msgcat::mcset $gPB(LANG) "MC(event,length_compn,len_off)"         "Rejestr odsunięcia długości"
::msgcat::mcset $gPB(LANG) "MC(event,length_compn,len_off,min)"     "Minimum"
::msgcat::mcset $gPB(LANG) "MC(event,length_compn,len_off,max)"     "Maksimum"

### Set Modes
::msgcat::mcset $gPB(LANG) "MC(event,set_modes,name)"               "Ustaw tryby"
::msgcat::mcset $gPB(LANG) "MC(event,set_modes,out_mode)"           "Tryb wyjścia"
::msgcat::mcset $gPB(LANG) "MC(event,set_modes,g_code)"             "Kod G"
::msgcat::mcset $gPB(LANG) "MC(event,set_modes,g_code,absolute)"    "Bezwzględne"
::msgcat::mcset $gPB(LANG) "MC(event,set_modes,g_code,incremental)" "Przyrostowe"
::msgcat::mcset $gPB(LANG) "MC(event,set_modes,rotary_axis)"        "Oś obrotowa może być przyrostowa"

### Spindle RPM
::msgcat::mcset $gPB(LANG) "MC(event,spindle_rpm,name)"                     "Obr./min wrzeciona"
::msgcat::mcset $gPB(LANG) "MC(event,spindle_rpm,dir_m_code)"               "Kody M kierunku wrzeciona"
::msgcat::mcset $gPB(LANG) "MC(event,spindle_rpm,dir_m_code,cw)"            "W prawo (CW)"
::msgcat::mcset $gPB(LANG) "MC(event,spindle_rpm,dir_m_code,ccw)"           "W lewo (CCW)"
::msgcat::mcset $gPB(LANG) "MC(event,spindle_rpm,range_control)"            "Kontrola zakresu wrzeciona"
::msgcat::mcset $gPB(LANG) "MC(event,spindle_rpm,range_control,dwell_time)" "Przerwa czasowa zmiany zakresu (s)"
::msgcat::mcset $gPB(LANG) "MC(event,spindle_rpm,range_control,range_code)" "Określ kod zakresu"

### Spindle CSS
::msgcat::mcset $gPB(LANG) "MC(event,spindle_css,name)"             "CSS wrzeciona"
::msgcat::mcset $gPB(LANG) "MC(event,spindle_css,g_code)"           "Kod G wrzeciona"
::msgcat::mcset $gPB(LANG) "MC(event,spindle_css,g_code,const)"     "Kod powierzchni stałej"
::msgcat::mcset $gPB(LANG) "MC(event,spindle_css,g_code,max)"       "Kod maksymalnej liczby obr./min"
::msgcat::mcset $gPB(LANG) "MC(event,spindle_css,g_code,sfm)"       "Kod anulowania SFM"
::msgcat::mcset $gPB(LANG) "MC(event,spindle_css,max)"              "Maksymalna liczba obr./min podczas CSS"
::msgcat::mcset $gPB(LANG) "MC(event,spindle_css,sfm)"              "Zawsze tryb IPR dla SFM"

### Spindle Off
::msgcat::mcset $gPB(LANG) "MC(event,spindle_off,name)"             "Wrzeciono wyłączone"
::msgcat::mcset $gPB(LANG) "MC(event,spindle_off,dir_m_code)"       "Kod M kierunku wrzeciona"
::msgcat::mcset $gPB(LANG) "MC(event,spindle_off,dir_m_code,off)"   "Wyłącz"

### Coolant On
::msgcat::mcset $gPB(LANG) "MC(event,coolant_on,name)"              "Chłodziwo wł."
::msgcat::mcset $gPB(LANG) "MC(event,coolant_on,m_code)"            "Kod M"
::msgcat::mcset $gPB(LANG) "MC(event,coolant_on,m_code,on)"         "WŁ."
::msgcat::mcset $gPB(LANG) "MC(event,coolant_on,m_code,flood)"      "Płyn"
::msgcat::mcset $gPB(LANG) "MC(event,coolant_on,m_code,mist)"       "Mgła"
::msgcat::mcset $gPB(LANG) "MC(event,coolant_on,m_code,thru)"       "Przelot"
::msgcat::mcset $gPB(LANG) "MC(event,coolant_on,m_code,tap)"        "Gwintownik"

### Coolant Off
::msgcat::mcset $gPB(LANG) "MC(event,coolant_off,name)"             "Chłodziwo wył."
::msgcat::mcset $gPB(LANG) "MC(event,coolant_off,m_code)"           "Kod M"
::msgcat::mcset $gPB(LANG) "MC(event,coolant_off,m_code,off)"       "Wyłącz"

### Inch Metric Mode
::msgcat::mcset $gPB(LANG) "MC(event,inch_metric_mode,name)"            "Tryb calowo-metryczny"
::msgcat::mcset $gPB(LANG) "MC(event,inch_metric_mode,g_code)"          "Kod G"
::msgcat::mcset $gPB(LANG) "MC(event,inch_metric_mode,g_code,english)"  "Angielskie (cale)"
::msgcat::mcset $gPB(LANG) "MC(event,inch_metric_mode,g_code,metric)"   "Metryczne (milimetry)"

### Feedrates
::msgcat::mcset $gPB(LANG) "MC(event,feedrates,name)"               "Prędkości posuwu"
::msgcat::mcset $gPB(LANG) "MC(event,feedrates,ipm_mode)"           "Tryb cale/min"
::msgcat::mcset $gPB(LANG) "MC(event,feedrates,ipr_mode)"           "Tryb cale/obr."
::msgcat::mcset $gPB(LANG) "MC(event,feedrates,dpm_mode)"           "Tryb stopnie/min"
::msgcat::mcset $gPB(LANG) "MC(event,feedrates,mmpm_mode)"          "Tryb mm/min"
::msgcat::mcset $gPB(LANG) "MC(event,feedrates,mmpr_mode)"          "Tryb mm/obr."
::msgcat::mcset $gPB(LANG) "MC(event,feedrates,frn_mode)"           "Tryb FRN"
::msgcat::mcset $gPB(LANG) "MC(event,feedrates,g_code)"             "Kod G"
::msgcat::mcset $gPB(LANG) "MC(event,feedrates,format)"             "Format"
::msgcat::mcset $gPB(LANG) "MC(event,feedrates,max)"                "Maksimum"
::msgcat::mcset $gPB(LANG) "MC(event,feedrates,min)"                "Minimum"
::msgcat::mcset $gPB(LANG) "MC(event,feedrates,mode,label)"         "Tryby posuwu"
::msgcat::mcset $gPB(LANG) "MC(event,feedrates,mode,lin)"           "Tylko liniowo"
::msgcat::mcset $gPB(LANG) "MC(event,feedrates,mode,rot)"           "Tylko obrotowo"
::msgcat::mcset $gPB(LANG) "MC(event,feedrates,mode,lin_rot)"       "Liniowo i obrotowo"
::msgcat::mcset $gPB(LANG) "MC(event,feedrates,mode,rap_lin)"       "Tylko szybko liniowo"
::msgcat::mcset $gPB(LANG) "MC(event,feedrates,mode,rap_rot)"       "Tylko szybko obrotowo"
::msgcat::mcset $gPB(LANG) "MC(event,feedrates,mode,rap_lin_rot)"   "Szybko liniowo i obrotowo"
::msgcat::mcset $gPB(LANG) "MC(event,feedrates,cycle_mode)"         "Tryb posuwu cyklu"
::msgcat::mcset $gPB(LANG) "MC(event,feedrates,cycle)"              "Cykl"

### Cutcom On
::msgcat::mcset $gPB(LANG) "MC(event,cutcom_on,name)"               "Włącz korekcję promieni"
::msgcat::mcset $gPB(LANG) "MC(event,cutcom_on,g_code)"             "Kod G"
::msgcat::mcset $gPB(LANG) "MC(event,cutcom_on,left)"               "Lewy"
::msgcat::mcset $gPB(LANG) "MC(event,cutcom_on,right)"              "Prawy"
::msgcat::mcset $gPB(LANG) "MC(event,cutcom_on,app_planes)"         "Stosowane płaszczyzny"
::msgcat::mcset $gPB(LANG) "MC(event,cutcom_on,edit_planes)"        "Edytuj kody płaszczyzny"
::msgcat::mcset $gPB(LANG) "MC(event,cutcom_on,reg)"                "Nr korektora prom. D"
::msgcat::mcset $gPB(LANG) "MC(event,cutcom_on,min)"                "Minimum"
::msgcat::mcset $gPB(LANG) "MC(event,cutcom_on,max)"                "Maksimum"
::msgcat::mcset $gPB(LANG) "MC(event,cutcom_on,bef)"                "Wyłącz korekcję promieni przed zmianą"

### Cutcom Off
::msgcat::mcset $gPB(LANG) "MC(event,cutcom_off,name)"              "Wyłącz korekcję promieni"
::msgcat::mcset $gPB(LANG) "MC(event,cutcom_off,g_code)"            "Kod G"
::msgcat::mcset $gPB(LANG) "MC(event,cutcom_off,off)"               "Wyłącz"

### Delay
::msgcat::mcset $gPB(LANG) "MC(event,delay,name)"                   "Wstrzymanie"
::msgcat::mcset $gPB(LANG) "MC(event,delay,seconds)"                "Sekundy"
::msgcat::mcset $gPB(LANG) "MC(event,delay,seconds,g_code)"         "Kod G"
::msgcat::mcset $gPB(LANG) "MC(event,delay,seconds,format)"         "Format"
::msgcat::mcset $gPB(LANG) "MC(event,delay,out_mode)"               "Tryb wyjścia"
::msgcat::mcset $gPB(LANG) "MC(event,delay,out_mode,sec)"           "Tylko sekundy"
::msgcat::mcset $gPB(LANG) "MC(event,delay,out_mode,rev)"           "Tylko obroty"
::msgcat::mcset $gPB(LANG) "MC(event,delay,out_mode,feed)"          "Zależnie od posuwu"
::msgcat::mcset $gPB(LANG) "MC(event,delay,out_mode,ivs)"           "Odwróć czas"
::msgcat::mcset $gPB(LANG) "MC(event,delay,revolution)"             "Obroty"
::msgcat::mcset $gPB(LANG) "MC(event,delay,revolution,g_code)"      "Kod G"
::msgcat::mcset $gPB(LANG) "MC(event,delay,revolution,format)"      "Format"

### Option Stop
::msgcat::mcset $gPB(LANG) "MC(event,opstop,name)"                  "Stop opcjonalny"

### Auxfun
::msgcat::mcset $gPB(LANG) "MC(event,auxfun,name)"                  "Funkcja pom."

### Prefun
::msgcat::mcset $gPB(LANG) "MC(event,prefun,name)"                  "Funkcja przyg."

### Load Tool
::msgcat::mcset $gPB(LANG) "MC(event,loadtool,name)"                "Wczytaj narzędzie"

### Stop
::msgcat::mcset $gPB(LANG) "MC(event,stop,name)"                    "Zatrzymaj"

### Tool Preselect
::msgcat::mcset $gPB(LANG) "MC(event,toolpreselect,name)"           "Wstępny wybór narzędzia"

### Thread Wire
::msgcat::mcset $gPB(LANG) "MC(event,threadwire,name)"              "Gwintuj drut"

### Cut Wire
::msgcat::mcset $gPB(LANG) "MC(event,cutwire,name)"                 "Przetnij drut"

### Wire Guides
::msgcat::mcset $gPB(LANG) "MC(event,wireguides,name)"              "Prowadnice drutu"

### Linear Move
::msgcat::mcset $gPB(LANG) "MC(event,linear,name)"                  "Ruch liniowy"
::msgcat::mcset $gPB(LANG) "MC(event,linear,g_code)"                "Kod G"
::msgcat::mcset $gPB(LANG) "MC(event,linear,motion)"                "Ruch liniowy"
::msgcat::mcset $gPB(LANG) "MC(event,linear,assume)"                "Przyjęty tryb szybki przy maksymalnym posuwie przejazdu"

### Circular Move
::msgcat::mcset $gPB(LANG) "MC(event,circular,name)"                "Ruch kołowy"
::msgcat::mcset $gPB(LANG) "MC(event,circular,g_code)"              "Kod G ruchu"
::msgcat::mcset $gPB(LANG) "MC(event,circular,clockwise)"           "W prawo (CLW)"
::msgcat::mcset $gPB(LANG) "MC(event,circular,counter-clock)"       "W lewo (CCLW)"
::msgcat::mcset $gPB(LANG) "MC(event,circular,record)"              "Rekord kołowy"
::msgcat::mcset $gPB(LANG) "MC(event,circular,full_circle)"         "Pełny okrąg"
::msgcat::mcset $gPB(LANG) "MC(event,circular,quadrant)"            "Ćwiartka"
::msgcat::mcset $gPB(LANG) "MC(event,circular,ijk_def)"             "Definicja IJK"
::msgcat::mcset $gPB(LANG) "MC(event,circular,ij_def)"              "Definicja IJ"
::msgcat::mcset $gPB(LANG) "MC(event,circular,ik_def)"              "Definicja IK"
::msgcat::mcset $gPB(LANG) "MC(event,circular,planes)"              "Stosowane płaszczyzny"
::msgcat::mcset $gPB(LANG) "MC(event,circular,edit_planes)"         "Edytuj kody płaszczyzny"
::msgcat::mcset $gPB(LANG) "MC(event,circular,radius)"              "Promień"
::msgcat::mcset $gPB(LANG) "MC(event,circular,min)"                 "Minimum"
::msgcat::mcset $gPB(LANG) "MC(event,circular,max)"                 "Maksimum"
::msgcat::mcset $gPB(LANG) "MC(event,circular,arc_len)"             "Minimalna długość łuku"

### Rapid Move
::msgcat::mcset $gPB(LANG) "MC(event,rapid,name)"                   "Ruch szybki"
::msgcat::mcset $gPB(LANG) "MC(event,rapid,g_code)"                 "Kod G"
::msgcat::mcset $gPB(LANG) "MC(event,rapid,motion)"                 "Ruch szybki"
::msgcat::mcset $gPB(LANG) "MC(event,rapid,plane_change)"           "Zmiana płaszczyzny roboczej"

### Lathe Thread
::msgcat::mcset $gPB(LANG) "MC(event,lathe,name)"                   "Gwintowanie tokarką"
::msgcat::mcset $gPB(LANG) "MC(event,lathe,g_code)"                 "Kod G gwintu"
::msgcat::mcset $gPB(LANG) "MC(event,lathe,cons)"                   "Stała"
::msgcat::mcset $gPB(LANG) "MC(event,lathe,incr)"                   "Przyrostowe"
::msgcat::mcset $gPB(LANG) "MC(event,lathe,decr)"                   "Malejąco"

### Cycle
::msgcat::mcset $gPB(LANG) "MC(event,cycle,g_code)"                 "Kod G i dostosowanie"
::msgcat::mcset $gPB(LANG) "MC(event,cycle,customize,Label)"        "Dostosuj"
::msgcat::mcset $gPB(LANG) "MC(event,cycle,customize,Context)"      "Ten przełącznik umożliwia dostosowanie cyklu. \n\nDomyślnie podstawową strukturę każdego cyklu można zdefiniować za pomocą ustawień wspólnych parametrów. Wspólne elementy w każdym cyklu są ograniczone do określonej modyfikacji. \n\nWłączenie tego przełącznika umożliwia uzyskanie kontroli nad konfiguracją cyklu. Zmiany dokonane we wspólnych parametrach nie będą mieć wpływu na żaden dostosowany cykl."
::msgcat::mcset $gPB(LANG) "MC(event,cycle,start,Label)"            "Początek cyklu"
::msgcat::mcset $gPB(LANG) "MC(event,cycle,start,Context)"          "Tę opcję można włączyć dla obrabiarek, które wykonują cykle z użyciem bloku początku cyklu (G79...) po zdefiniowaniu cyklu (G81...)."
::msgcat::mcset $gPB(LANG) "MC(event,cycle,start,text)"             "Użyj bloku początku cyklu do wykonania cyklu"
::msgcat::mcset $gPB(LANG) "MC(event,cycle,rapid_to)"               "Szybki - Do"
::msgcat::mcset $gPB(LANG) "MC(event,cycle,retract_to)"             "Wyjście - Do"
::msgcat::mcset $gPB(LANG) "MC(event,cycle,plane_control)"          "Kontrola płaszczyzny cyklu"
::msgcat::mcset $gPB(LANG) "MC(event,cycle,com_param,name)"         "Wspólne parametry"
::msgcat::mcset $gPB(LANG) "MC(event,cycle,cycle_off,name)"         "Cykl wyłączony"
::msgcat::mcset $gPB(LANG) "MC(event,cycle,plane_chng,name)"        "Zmiana płaszczyzny cyklu"
::msgcat::mcset $gPB(LANG) "MC(event,cycle,drill,name)"             "Wiercenie"
::msgcat::mcset $gPB(LANG) "MC(event,cycle,drill_dwell,name)"       "Przerwa czasowa podczas wiercenia"
::msgcat::mcset $gPB(LANG) "MC(event,cycle,drill_text,name)"        "Tekst wiercenia"
::msgcat::mcset $gPB(LANG) "MC(event,cycle,drill_csink,name)"       "Pogłębianie stożkowe podczas wiercenia"
::msgcat::mcset $gPB(LANG) "MC(event,cycle,drill_deep,name)"        "Wiercenie głębokie"
::msgcat::mcset $gPB(LANG) "MC(event,cycle,drill_brk_chip,name)"    "Wiercenie z odwiórowaniem"
::msgcat::mcset $gPB(LANG) "MC(event,cycle,tap,name)"               "Gwintownik"
::msgcat::mcset $gPB(LANG) "MC(event,cycle,bore,name)"              "Wytaczanie"
::msgcat::mcset $gPB(LANG) "MC(event,cycle,bore_dwell,name)"        "Przerwa czasowa podczas wytaczania"
::msgcat::mcset $gPB(LANG) "MC(event,cycle,bore_drag,name)"         "Wytaczanie z przeciągnięciem"
::msgcat::mcset $gPB(LANG) "MC(event,cycle,bore_no_drag,name)"      "Wytaczanie bez przeciągnięcia"
::msgcat::mcset $gPB(LANG) "MC(event,cycle,bore_back,name)"         "Wytaczanie wstecz"
::msgcat::mcset $gPB(LANG) "MC(event,cycle,bore_manual,name)"       "Wytaczanie ręczne"
::msgcat::mcset $gPB(LANG) "MC(event,cycle,bore_manual_dwell,name)" "Przerwa czasowa podczas wytaczania ręcznego"
::msgcat::mcset $gPB(LANG) "MC(event,cycle,peck_drill,name)"        "Wiercenie bez cyklu"
::msgcat::mcset $gPB(LANG) "MC(event,cycle,break_chip,name)"        "Wiercenie z odwiórowaniem"
::msgcat::mcset $gPB(LANG) "MC(event,cycle,drill_dwell_sf,name)"    "Przerwa czasowa podczas wiercenia (pogłębienie czołowe)"
::msgcat::mcset $gPB(LANG) "MC(event,cycle,drill_deep_peck,name)"   "Wiercenie głębokie (bez cyklu)"
::msgcat::mcset $gPB(LANG) "MC(event,cycle,bore_ream,name)"         "Wytaczanie (rozwiercanie)"
::msgcat::mcset $gPB(LANG) "MC(event,cycle,bore_no-drag,name)"      "Wytaczanie bez przeciągnięcia"

##------------
## G Code
##
::msgcat::mcset $gPB(LANG) "MC(g_code,rapid,name)"                  "Ruch szybki"
::msgcat::mcset $gPB(LANG) "MC(g_code,linear,name)"                 "Ruch liniowy"
::msgcat::mcset $gPB(LANG) "MC(g_code,circular_clw,name)"           "Interpolacja kołowa w prawo"
::msgcat::mcset $gPB(LANG) "MC(g_code,circular_cclw,name)"          "Interpolacja kołowa w lewo"
::msgcat::mcset $gPB(LANG) "MC(g_code,delay_sec,name)"              "Opóźnienie (s)"
::msgcat::mcset $gPB(LANG) "MC(g_code,delay_rev,name)"              "Opóźnienie (obr.)"
::msgcat::mcset $gPB(LANG) "MC(g_code,pln_xy,name)"                 "Płaszczyzna XY"
::msgcat::mcset $gPB(LANG) "MC(g_code,pln_zx,name)"                 "Płaszczyzna ZX"
::msgcat::mcset $gPB(LANG) "MC(g_code,pln_yz,name)"                 "Płaszczyzna YZ"
::msgcat::mcset $gPB(LANG) "MC(g_code,cutcom_off,name)"             "Wyłącz korekcję promieni"
::msgcat::mcset $gPB(LANG) "MC(g_code,cutcom_left,name)"            "Korekcja promieni po lewej"
::msgcat::mcset $gPB(LANG) "MC(g_code,cutcom_right,name)"           "Korekcja promieni po prawej"
::msgcat::mcset $gPB(LANG) "MC(g_code,length_plus,name)"            "Dopasowanie dodatnie długości narzędzia"
::msgcat::mcset $gPB(LANG) "MC(g_code,length_minus,name)"           "Dopasowanie ujemne długości narzędzia"
::msgcat::mcset $gPB(LANG) "MC(g_code,length_off,name)"             "Wyłącz dopasowanie długości narzędzia"
::msgcat::mcset $gPB(LANG) "MC(g_code,inch,name)"                   "Tryb calowy"
::msgcat::mcset $gPB(LANG) "MC(g_code,metric,name)"                 "Tryb metryczny"
::msgcat::mcset $gPB(LANG) "MC(g_code,cycle_start,name)"            "Kod początku cyklu"
::msgcat::mcset $gPB(LANG) "MC(g_code,cycle_off,name)"              "Cykl wyłączony"
::msgcat::mcset $gPB(LANG) "MC(g_code,cycle_drill,name)"            "Wiercenie w cyklu"
::msgcat::mcset $gPB(LANG) "MC(g_code,cycle_drill_dwell,name)"      "Przerwa czasowa podczas wiercenia w cyklu"
::msgcat::mcset $gPB(LANG) "MC(g_code,cycle_drill_deep,name)"       "Wiercenie głębokie w cyklu"
::msgcat::mcset $gPB(LANG) "MC(g_code,cycle_drill_bc,name)"         "Wiercenie z odwiórowaniem w cyklu"
::msgcat::mcset $gPB(LANG) "MC(g_code,tap,name)"                    "Gwintowanie w cyklu"
::msgcat::mcset $gPB(LANG) "MC(g_code,bore,name)"                   "Wytaczanie w cyklu"
::msgcat::mcset $gPB(LANG) "MC(g_code,bore_drag,name)"              "Wytaczanie z przeciągnięciem w cyklu"
::msgcat::mcset $gPB(LANG) "MC(g_code,bore_no_drag,name)"           "Wytaczanie bez przeciągnięcia w cyklu"
::msgcat::mcset $gPB(LANG) "MC(g_code,bore_dwell,name)"             "Przerwa czasowa podczas wytaczania w cyklu"
::msgcat::mcset $gPB(LANG) "MC(g_code,bore_manual,name)"            "Wytaczanie ręczne w cyklu"
::msgcat::mcset $gPB(LANG) "MC(g_code,bore_back,name)"              "Wytaczanie wstecz w cyklu"
::msgcat::mcset $gPB(LANG) "MC(g_code,bore_manual_dwell,name)"      "Przerwa czasowa podczas wytaczania ręcznego w cyklu"
::msgcat::mcset $gPB(LANG) "MC(g_code,abs,name)"                    "Tryb bezwzględny"
::msgcat::mcset $gPB(LANG) "MC(g_code,inc,name)"                    "Tryb przyrostowy"
::msgcat::mcset $gPB(LANG) "MC(g_code,cycle_retract_auto,name)"     "Wyjście cyklu (AUTOMATYCZNE)"
::msgcat::mcset $gPB(LANG) "MC(g_code,cycle_retract_manual,name)"   "Wyjście cyklu (RĘCZNE)"
::msgcat::mcset $gPB(LANG) "MC(g_code,reset,name)"                  "Resetuj"
::msgcat::mcset $gPB(LANG) "MC(g_code,fr_ipm,name)"                 "Tryb posuwu (cale/min)"
::msgcat::mcset $gPB(LANG) "MC(g_code,fr_ipr,name)"                 "Tryb posuwu (cale/obr.)"
::msgcat::mcset $gPB(LANG) "MC(g_code,fr_frn,name)"                 "Tryb posuwu (FRN)"
::msgcat::mcset $gPB(LANG) "MC(g_code,spindle_css,name)"            "CSS wrzeciona"
::msgcat::mcset $gPB(LANG) "MC(g_code,spindle_rpm,name)"            "Obr./min wrzeciona"
::msgcat::mcset $gPB(LANG) "MC(g_code,ret_home,name)"               "Powrót do punktu zakończenia"
::msgcat::mcset $gPB(LANG) "MC(g_code,cons_thread,name)"            "Gwint stały"
::msgcat::mcset $gPB(LANG) "MC(g_code,incr_thread,name)"            "Gwint przyrostowy"
::msgcat::mcset $gPB(LANG) "MC(g_code,decr_thread,name)"            "Gwint malejący"
::msgcat::mcset $gPB(LANG) "MC(g_code,feedmode_in,pm)"              "Tryb posuwu (cale/min)"
::msgcat::mcset $gPB(LANG) "MC(g_code,feedmode_in,pr)"              "Tryb posuwu (cale/obr.)"
::msgcat::mcset $gPB(LANG) "MC(g_code,feedmode_mm,pm)"              "Tryb posuwu (mm/min)"
::msgcat::mcset $gPB(LANG) "MC(g_code,feedmode_mm,pr)"              "Tryb posuwu (mm/obr.)"
::msgcat::mcset $gPB(LANG) "MC(g_code,feedmode,dpm)"                "Tryb posuwu (stopnie/min)"

##------------
## M Code
##
::msgcat::mcset $gPB(LANG) "MC(m_code,stop_manual_tc,name)"         "Zatrzymaj/Ręczna zmiana narzędzia"
::msgcat::mcset $gPB(LANG) "MC(m_code,stop,name)"                   "Zatrzymaj"
::msgcat::mcset $gPB(LANG) "MC(m_code,opt_stop,name)"               "Stop opcjonalny"
::msgcat::mcset $gPB(LANG) "MC(m_code,prog_end,name)"               "Koniec programu"
::msgcat::mcset $gPB(LANG) "MC(m_code,spindle_clw,name)"            "Wrzeciono włączone/w prawo"
::msgcat::mcset $gPB(LANG) "MC(m_code,spindle_cclw,name)"           "Wrzeciono włączone/w lewo"
::msgcat::mcset $gPB(LANG) "MC(m_code,lathe_thread,type1)"          "Gwint stały"
::msgcat::mcset $gPB(LANG) "MC(m_code,lathe_thread,type2)"          "Gwint przyrostowy"
::msgcat::mcset $gPB(LANG) "MC(m_code,lathe_thread,type3)"          "Gwint malejący"
::msgcat::mcset $gPB(LANG) "MC(m_code,spindle_off,name)"            "Wrzeciono wyłączone"
::msgcat::mcset $gPB(LANG) "MC(m_code,tc_retract,name)"             "Zmiana narzędzia/Wyjście"
::msgcat::mcset $gPB(LANG) "MC(m_code,coolant_on,name)"             "Chłodziwo wł."
::msgcat::mcset $gPB(LANG) "MC(m_code,coolant_fld,name)"            "Chłodziwo zewnętrzne"
::msgcat::mcset $gPB(LANG) "MC(m_code,coolant_mist,name)"           "Chłodziwo w postaci mgły olejowej"
::msgcat::mcset $gPB(LANG) "MC(m_code,coolant_thru,name)"           "Chłodziwo wewnętrzne"
::msgcat::mcset $gPB(LANG) "MC(m_code,coolant_tap,name)"            "Gwintownik z chłodziwem wewnętrznym"
::msgcat::mcset $gPB(LANG) "MC(m_code,coolant_off,name)"            "Chłodziwo wył."
::msgcat::mcset $gPB(LANG) "MC(m_code,rewind,name)"                 "Przewiń do tyłu"
::msgcat::mcset $gPB(LANG) "MC(m_code,thread_wire,name)"            "Gwintuj drut"
::msgcat::mcset $gPB(LANG) "MC(m_code,cut_wire,name)"               "Przetnij drut"
::msgcat::mcset $gPB(LANG) "MC(m_code,fls_on,name)"                 "Włącz płukanie"
::msgcat::mcset $gPB(LANG) "MC(m_code,fls_off,name)"                "Wyłącz płukanie"
::msgcat::mcset $gPB(LANG) "MC(m_code,power_on,name)"               "Włącz zasilanie"
::msgcat::mcset $gPB(LANG) "MC(m_code,power_off,name)"              "Wyłącz zasilanie"
::msgcat::mcset $gPB(LANG) "MC(m_code,wire_on,name)"                "Włącz drut"
::msgcat::mcset $gPB(LANG) "MC(m_code,wire_off,name)"               "Wyłącz drut"
::msgcat::mcset $gPB(LANG) "MC(m_code,pri_turret,name)"             "Głowica główna"
::msgcat::mcset $gPB(LANG) "MC(m_code,sec_turret,name)"             "Głowica pomocnicza"

##------------
## UDE
##
::msgcat::mcset $gPB(LANG) "MC(ude,editor,enable,Label)"            "Włącz edytor UDE"
::msgcat::mcset $gPB(LANG) "MC(ude,editor,enable,as_saved,Label)"   "Jak zapisano"
::msgcat::mcset $gPB(LANG) "MC(ude,editor,TITLE)"                   "Zdarzenie użytkownika"

::msgcat::mcset $gPB(LANG) "MC(ude,editor,no_ude)"                  "Brak odpowiedniego UDE!"

::msgcat::mcset $gPB(LANG) "MC(ude,editor,int,Label)"               "Całkowite"
::msgcat::mcset $gPB(LANG) "MC(ude,editor,int,Context)"             "Dodaj nowy parametr liczby całkowitej, przeciągając go do listy z prawej strony."

::msgcat::mcset $gPB(LANG) "MC(ude,editor,real,Label)"              "Rzeczywiste"
::msgcat::mcset $gPB(LANG) "MC(ude,editor,real,Context)"            "Dodaj nowy parametr liczby rzeczywistej, przeciągając go do listy z prawej strony."

::msgcat::mcset $gPB(LANG) "MC(ude,editor,txt,Label)"               "Tekst"
::msgcat::mcset $gPB(LANG) "MC(ude,editor,txt,Context)"             "Dodaj nowy parametr łańcucha, przeciągając go do listy z prawej strony."

::msgcat::mcset $gPB(LANG) "MC(ude,editor,bln,Label)"               "Boole'a"
::msgcat::mcset $gPB(LANG) "MC(ude,editor,bln,Context)"             "Dodaj nowy parametr Boole'a, przeciągając go do listy z prawej strony."

::msgcat::mcset $gPB(LANG) "MC(ude,editor,opt,Label)"               "Opcje"
::msgcat::mcset $gPB(LANG) "MC(ude,editor,opt,Context)"             "Dodaj nowy parametr opcji, przeciągając go do listy z prawej strony."

::msgcat::mcset $gPB(LANG) "MC(ude,editor,pnt,Label)"               "Punkt"
::msgcat::mcset $gPB(LANG) "MC(ude,editor,pnt,Context)"             "Dodaj nowy parametr punktu, przeciągając go do listy z prawej strony."

::msgcat::mcset $gPB(LANG) "MC(ude,editor,trash,Label)"             "Edytor - Kosz"
::msgcat::mcset $gPB(LANG) "MC(ude,editor,trash,Context)"           "Z listy z prawej strony można wyrzucić niechciane parametry, przeciągając je do tego kosza."

::msgcat::mcset $gPB(LANG) "MC(ude,editor,event,Label)"             "Zdarzenie"
::msgcat::mcset $gPB(LANG) "MC(ude,editor,event,Context)"           "Tutaj można edytować parametry zdarzenia, klikając LKM."

::msgcat::mcset $gPB(LANG) "MC(ude,editor,param,Label)"             "Zdarzenie - Parametry"
::msgcat::mcset $gPB(LANG) "MC(ude,editor,param,Context)"           "Każdy parametr można edytować, klikając prawy przycisk myszy, lub zmienić ich kolejność, przeciągając je i upuszczając.\n \nParametr w kolorze jasnoniebieskim jest definiowany przez system i nie można go usunąć. \nParametr w kolorze jasnobrązowym (Burlywood) nie jest definiowany przez system i można go zmodyfikować lub usunąć."

::msgcat::mcset $gPB(LANG) "MC(ude,editor,param,edit,Label)"        "Parametry - Opcja"
::msgcat::mcset $gPB(LANG) "MC(ude,editor,param,edit,Context)"      "Aby wybrać opcję domyślną, naciśnij lewy przycisk myszy.\nAby edytować opcję, dwukrotnie naciśnij lewy przycisk myszy."
::msgcat::mcset $gPB(LANG) "MC(ude,editor,param,editor,Label)"      "Typ parametru: "

::msgcat::mcset $gPB(LANG) "MC(ude,editor,pnt,sel,Label)"           "Wybierz"
::msgcat::mcset $gPB(LANG) "MC(ude,editor,pnt,dsp,Label)"           "Wyświetl"

::msgcat::mcset $gPB(LANG) "MC(ude,editor,dlg,ok,Label)"            "OK"
::msgcat::mcset $gPB(LANG) "MC(ude,editor,dlg,bck,Label)"           "Tył"
::msgcat::mcset $gPB(LANG) "MC(ude,editor,dlg,cnl,Label)"           "Anuluj"

::msgcat::mcset $gPB(LANG) "MC(ude,editor,paramdlg,PL,Label)"       "Etykieta parametru"
::msgcat::mcset $gPB(LANG) "MC(ude,editor,paramdlg,VN,Label)"       "Nazwa zmiennej"
::msgcat::mcset $gPB(LANG) "MC(ude,editor,paramdlg,DF,Label)"       "Wartości domyślne"
::msgcat::mcset $gPB(LANG) "MC(ude,editor,paramdlg,PL,Context)"     "Określ etykietę parametru"
::msgcat::mcset $gPB(LANG) "MC(ude,editor,paramdlg,VN,Context)"     "Określ nazwę zmiennej"
::msgcat::mcset $gPB(LANG) "MC(ude,editor,paramdlg,DF,Context)"     "Określ wartość domyślną"
::msgcat::mcset $gPB(LANG) "MC(ude,editor,paramdlg,TG)"             "Przełącznik"
::msgcat::mcset $gPB(LANG) "MC(ude,editor,paramdlg,TG,B,Label)"     "Przełącznik"
::msgcat::mcset $gPB(LANG) "MC(ude,editor,paramdlg,TG,B,Context)"   "Wybierz wartość przełącznika"
::msgcat::mcset $gPB(LANG) "MC(ude,editor,paramdlg,ON,Label)"       "Włącz"
::msgcat::mcset $gPB(LANG) "MC(ude,editor,paramdlg,OFF,Label)"      "Wyłącz"
::msgcat::mcset $gPB(LANG) "MC(ude,editor,paramdlg,ON,Context)"     "Wybierz wartość domyślną jako WŁ"
::msgcat::mcset $gPB(LANG) "MC(ude,editor,paramdlg,OFF,Context)"    "Wybierz wartość domyślną jako WYŁ"
::msgcat::mcset $gPB(LANG) "MC(ude,editor,paramdlg,OL)"             "Lista opcji"
::msgcat::mcset $gPB(LANG) "MC(ude,editor,paramdlg,ADD,Label)"      "Dodaj"
::msgcat::mcset $gPB(LANG) "MC(ude,editor,paramdlg,CUT,Label)"      "Wytnij"
::msgcat::mcset $gPB(LANG) "MC(ude,editor,paramdlg,PASTE,Label)"    "Wklej"
::msgcat::mcset $gPB(LANG) "MC(ude,editor,paramdlg,ADD,Context)"    "Dodaj obiekt"
::msgcat::mcset $gPB(LANG) "MC(ude,editor,paramdlg,CUT,Context)"    "Wytnij obiekt"
::msgcat::mcset $gPB(LANG) "MC(ude,editor,paramdlg,PASTE,Context)"  "Wklej obiekt"
::msgcat::mcset $gPB(LANG) "MC(ude,editor,paramdlg,ENTRY,Label)"    "Opcje"
::msgcat::mcset $gPB(LANG) "MC(ude,editor,paramdlg,ENTRY,Context)"  "Wprowadź obiekt"
::msgcat::mcset $gPB(LANG) "MC(ude,editor,eventdlg,EN,Label)"       "Nazwa zdarzenia"
::msgcat::mcset $gPB(LANG) "MC(ude,editor,eventdlg,EN,Context)"     "Określ nazwę zdarzenia"
::msgcat::mcset $gPB(LANG) "MC(ude,editor,eventdlg,PEN,Label)"      "Nazwa postprocesora"
::msgcat::mcset $gPB(LANG) "MC(ude,editor,eventdlg,PEN,Context)"    "Określ nazwę postprocesora"
::msgcat::mcset $gPB(LANG) "MC(ude,editor,eventdlg,PEN,C,Label)"    "Nazwa postprocesora"
::msgcat::mcset $gPB(LANG) "MC(ude,editor,eventdlg,PEN,C,Context)"  "Ten przełącznik pozwala wybrać, czy ustawić nazwę postprocesora"
::msgcat::mcset $gPB(LANG) "MC(ude,editor,eventdlg,EL,Label)"       "Etykieta zdarzenia"
::msgcat::mcset $gPB(LANG) "MC(ude,editor,eventdlg,EL,Context)"     "Określ etykietę zdarzenia"
::msgcat::mcset $gPB(LANG) "MC(ude,editor,eventdlg,EL,C,Label)"     "Etykieta zdarzenia"
::msgcat::mcset $gPB(LANG) "MC(ude,editor,eventdlg,EL,C,Context)"   "Ten przełącznik pozwala wybrać, czy ustawić etykietę zdarzenia"

::msgcat::mcset $gPB(LANG) "MC(ude,editor,eventdlg,EC,Label)"           "Kategoria"
::msgcat::mcset $gPB(LANG) "MC(ude,editor,eventdlg,EC,Context)"         "Ten przełącznik pozwala wybrać, czy ustawić kategorię"
::msgcat::mcset $gPB(LANG) "MC(ude,editor,eventdlg,EC_MILL,Label)"      "Frez"
::msgcat::mcset $gPB(LANG) "MC(ude,editor,eventdlg,EC_DRILL,Label)"     "Wiercenie"
::msgcat::mcset $gPB(LANG) "MC(ude,editor,eventdlg,EC_LATHE,Label)"     "Tokarka"
::msgcat::mcset $gPB(LANG) "MC(ude,editor,eventdlg,EC_WEDM,Label)"      "Wycinarka"
::msgcat::mcset $gPB(LANG) "MC(ude,editor,eventdlg,EC_MILL,Context)"    "Ustaw kategorię frezu"
::msgcat::mcset $gPB(LANG) "MC(ude,editor,eventdlg,EC_DRILL,Context)"   "Ustaw kategorię wiertła"
::msgcat::mcset $gPB(LANG) "MC(ude,editor,eventdlg,EC_LATHE,Context)"   "Ustaw kategorię tokarki"
::msgcat::mcset $gPB(LANG) "MC(ude,editor,eventdlg,EC_WEDM,Context)"    "Ustaw kategorię wedm"

::msgcat::mcset $gPB(LANG) "MC(ude,editor,EDIT)"                    "Edytuj zdarzenie"
::msgcat::mcset $gPB(LANG) "MC(ude,editor,CREATE)"                  "Utwórz zdarzenie sterowania obrabiarką"
::msgcat::mcset $gPB(LANG) "MC(ude,editor,popup,HELP)"              "Pomoc"
::msgcat::mcset $gPB(LANG) "MC(ude,editor,popup,EDIT)"              "Edytuj parametry użytkownika..."
::msgcat::mcset $gPB(LANG) "MC(ude,editor,param,EDIT)"              "Edytuj..."
::msgcat::mcset $gPB(LANG) "MC(ude,editor,param,VIEW)"              "Wyświetl..."
::msgcat::mcset $gPB(LANG) "MC(ude,editor,popup,DELETE)"            "Usuń"
::msgcat::mcset $gPB(LANG) "MC(ude,editor,popup,CREATE)"            "Utwórz nowe zdarzenie sterowania obrabiarką..."
::msgcat::mcset $gPB(LANG) "MC(ude,editor,popup,IMPORT)"            "Importuj zdarzenia kontroli obrabiarki..."
::msgcat::mcset $gPB(LANG) "MC(ude,editor,popup,MSG_BLANK)"         "Nazwa zdarzenia nie może być pusta!"
::msgcat::mcset $gPB(LANG) "MC(ude,editor,popup,MSG_SAMENAME)"      "Nazwa zdarzenia już istnieje!"
::msgcat::mcset $gPB(LANG) "MC(ude,editor,popup,MSG_SameHandler)"   "Program obsługi zdarzeń już istnieje! \nZmodyfikuj nazwę zdarzenia lub postprocesora, jeśli je zaznaczono!"
::msgcat::mcset $gPB(LANG) "MC(ude,validate)"                       "Brak parametru w tym zdarzeniu!"
::msgcat::mcset $gPB(LANG) "MC(ude,prev,tab,Label)"                 "Zdarzenia użytkownika"
::msgcat::mcset $gPB(LANG) "MC(ude,prev,ude,Label)"                 "Zdarzenia kontroli obrabiarki"
::msgcat::mcset $gPB(LANG) "MC(ude,prev,udc,Label)"                 "Cykle użytkownika"
::msgcat::mcset $gPB(LANG) "MC(ude,prev,mc,Label)"                  "Systemowe zdarzenia kontroli obrabiarki"
::msgcat::mcset $gPB(LANG) "MC(ude,prev,nmc,Label)"                 "Niesystemowe zdarzenia kontroli obrabiarki"
::msgcat::mcset $gPB(LANG) "MC(udc,prev,sys,Label)"                 "Cykle systemowe"
::msgcat::mcset $gPB(LANG) "MC(udc,prev,nsys,Label)"                "Cykle niesystemowe"
::msgcat::mcset $gPB(LANG) "MC(ude,prev,Status)"                    "Wybierz obiekt do zdefiniowania"
::msgcat::mcset $gPB(LANG) "MC(ude,editor,opt,MSG_BLANK)"           "Łańcuch opcji nie może być pusty!"
::msgcat::mcset $gPB(LANG) "MC(ude,editor,opt,MSG_SAME)"            "Łańcuch opcji już istnieje!"
::msgcat::mcset $gPB(LANG) "MC(ude,editor,opt,MSG_PST_SAME)"        "Wklejana opcja już istnieje!"
::msgcat::mcset $gPB(LANG) "MC(ude,editor,opt,MSG_IDENTICAL)"       "Niektóre opcje są identyczne!"
::msgcat::mcset $gPB(LANG) "MC(ude,editor,opt,NO_OPT)"              "Brak opcji na liście!"
::msgcat::mcset $gPB(LANG) "MC(ude,editor,param,MSG_NO_VNAME)"      "Nazwa zmiennej nie może być pusta!"
::msgcat::mcset $gPB(LANG) "MC(ude,editor,param,MSG_EXIST_VNAME)"   "Nazwa zmiennej już istnieje!"
::msgcat::mcset $gPB(LANG) "MC(ude,editor,spindle_css,INFO)"        "To zdarzenie współdzieli UDE z opcją \"Obr./min wrzeciona\""
::msgcat::mcset $gPB(LANG) "MC(ude,import,ihr,Label)"               "Przejmij UDE z postprocesora"

::msgcat::mcset $gPB(LANG) "MC(ude,import,ihr,Context)"             "Ta opcja włącza ten postprocesor, aby przejąć definicję UDE i jej programy obsługi z postprocesora."

::msgcat::mcset $gPB(LANG) "MC(ude,import,sel,Label)"               "Wybierz postprocesor"

::msgcat::mcset $gPB(LANG) "MC(ude,import,sel,Context)"             "Wybierz plik PUI żądanego postprocesora. Zaleca się, aby wszystkie pliki (PUI, Def, Tcl i CDL) były powiązane z przejmowanym postprocesorem w celu umieszczenia ich w tym samym katalogu (folderze) wykorzystywanym podczas uruchamiania."

::msgcat::mcset $gPB(LANG) "MC(ude,import,name_cdl,Label)"          "Nazwa pliku CDL"

::msgcat::mcset $gPB(LANG) "MC(ude,import,name_cdl,Context)"        "Ścieżka i nazwa pliku CDL, który zostanie powiązany z wybranym postprocesorem, zostanie powiązana (UWZGLĘDNIONA) w pliku definicji tego postprocesora. Nazwa ścieżki musi rozpoczynać się od zmiennej środowiskowej UG (\\\$UGII) lub być pusta. Jeśli nie określono ścieżki, do zlokalizowania pliku przez UG/NX podczas działania zostanie użyta zmienna UGII_CAM_FILE_SEARCH_PATH."

::msgcat::mcset $gPB(LANG) "MC(ude,import,name_def,Label)"          "Domyślna nazwa pliku"
::msgcat::mcset $gPB(LANG) "MC(ude,import,name_def,Context)"        "Ścieżka i nazwa pliku definicji wybranego postprocesora, który zostanie powiązany (UWZGLĘDNIONY) w pliku definicji tego postprocesora. Nazwa ścieżki musi rozpoczynać się od zmiennej środowiskowej UG (\\\$UGII) lub być pusta. Jeśli nie określono ścieżki, do zlokalizowania pliku przez UG/NX podczas działania zostanie użyta zmienna UGII_CAM_FILE_SEARCH_PATH."

::msgcat::mcset $gPB(LANG) "MC(ude,import,include_cdl,Label)"       "CDL"
::msgcat::mcset $gPB(LANG) "MC(ude,import,ihr_pst,Label)"           "Postprocesor"
::msgcat::mcset $gPB(LANG) "MC(ude,import,ihr_folder,Label)"        "Folder"
::msgcat::mcset $gPB(LANG) "MC(ude,import,own_folder,Label)"        "Folder"
::msgcat::mcset $gPB(LANG) "MC(ude,import,own,Label)"               "Dołącz własny plik CDL"

::msgcat::mcset $gPB(LANG) "MC(ude,import,own,Context)"             "Ta opcja umożliwia uwzględnienie w tym postprocesorze odwołania do własnego pliku CDL w pliku definicji."

::msgcat::mcset $gPB(LANG) "MC(ude,import,own_ent,Label)"           "Własny plik CDL"

::msgcat::mcset $gPB(LANG) "MC(ude,import,own_ent,Context)"         "Ścieżka i nazwa pliku CDL, powiązanego z tym postprocesorem, który ma być powiązany (UWZGLĘDNIONY) w pliku definicji tego postprocesora. Rzeczywista nazwa pliku zostanie określona podczas zapisu postprocesora. Nazwa ścieżki musi rozpoczynać się od zmiennej środowiskowej UG  (\\\$UGII) lub być pusta. Jeśli nie określono ścieżki, do zlokalizowania pliku przez UG/NX podczas działania zostanie użyta zmienna UGII_CAM_FILE_SEARCH_PATH."

::msgcat::mcset $gPB(LANG) "MC(ude,import,sel,pui,status)"          "Wybierz plik PUI"
::msgcat::mcset $gPB(LANG) "MC(ude,import,sel,cdl,status)"          "Wybierz plik CDL"

##---------
## UDC
##
::msgcat::mcset $gPB(LANG) "MC(udc,editor,TITLE)"                   "Cykl użytkownika"
::msgcat::mcset $gPB(LANG) "MC(udc,editor,CREATE)"                  "Utwórz cykl użytkownika"
::msgcat::mcset $gPB(LANG) "MC(udc,editor,TYPE)"                    "Typ cyklu"
::msgcat::mcset $gPB(LANG) "MC(udc,editor,type,UDC)"                "Użytkownika"
::msgcat::mcset $gPB(LANG) "MC(udc,editor,type,SYSUDC)"             "Zdefiniowane przez system"
::msgcat::mcset $gPB(LANG) "MC(udc,editor,CYCLBL,Label)"            "Etykieta cyklu"
::msgcat::mcset $gPB(LANG) "MC(udc,editor,CYCNAME,Label)"           "Nazwa cyklu"
::msgcat::mcset $gPB(LANG) "MC(udc,editor,CYCLBL,Context)"          "Określ etykietę cyklu"
::msgcat::mcset $gPB(LANG) "MC(udc,editor,CYCNAME,Context)"         "Określ nazwę cyklu"
::msgcat::mcset $gPB(LANG) "MC(udc,editor,CYCLBL,C,Label)"          "Etykieta cyklu"
::msgcat::mcset $gPB(LANG) "MC(udc,editor,CYCLBL,C,Context)"        "Ten przełącznik pozwala ustawić etykietę cyklu"
::msgcat::mcset $gPB(LANG) "MC(udc,editor,popup,EDIT)"              "Edytuj parametry użytkownika..."
::msgcat::mcset $gPB(LANG) "MC(udc,editor,popup,MSG_BLANK)"         "Nazwa cyklu nie może być pusta!"
::msgcat::mcset $gPB(LANG) "MC(udc,editor,popup,MSG_SAMENAME)"      "Nazwa cyklu już istnieje!"
::msgcat::mcset $gPB(LANG) "MC(udc,editor,popup,MSG_SameHandler)"   "Program obsługi zdarzeń już istnieje!\n Zmodyfikuj nazwę zdarzenia cyklu!"
::msgcat::mcset $gPB(LANG) "MC(udc,editor,popup,MSG_ISSYSCYC)"      "Nazwa cyklu należy do typu cyklu systemowego!"
::msgcat::mcset $gPB(LANG) "MC(udc,editor,popup,MSG_SYSCYC_EXIST)"  "Ten rodzaj cyklu systemowego już istnieje!"
::msgcat::mcset $gPB(LANG) "MC(udc,editor,EDIT)"                    "Edytuj zdarzenie cyklu"
::msgcat::mcset $gPB(LANG) "MC(udc,editor,popup,CREATE)"            "Utwórz nowy cykl użytkownika..."
::msgcat::mcset $gPB(LANG) "MC(udc,editor,popup,IMPORT)"            "Importuj cykle użytkownika..."
::msgcat::mcset $gPB(LANG) "MC(udc,drill,csink,INFO)"               "To zdarzenie współdzieli program obsługi z wiertłem!"
::msgcat::mcset $gPB(LANG) "MC(udc,drill,simulate,INFO)"            "To zdarzenie jest cyklem symulowanym."
::msgcat::mcset $gPB(LANG) "MC(udc,drill,dwell,INFO)"               "To zdarzenie współdzieli cykl użytkownika z "


#######
# IS&V
#######
::msgcat::mcset $gPB(LANG) "MC(isv,tab,label)"                      "Wirtualny sterownik N/C"
::msgcat::mcset $gPB(LANG) "MC(isv,Status)"                         "Określ parametry dla ISV"
::msgcat::mcset $gPB(LANG) "MC(isv,review,Status)"                  "Sprawdź polecenia VNC"

::msgcat::mcset $gPB(LANG) "MC(isv,setup,Label)"                    "Konfiguracja"
::msgcat::mcset $gPB(LANG) "MC(isv,vnc_command,Label)"              "Polecenia VNC"
####################
# General Definition
####################
::msgcat::mcset $gPB(LANG) "MC(isv,select_Main)"                    "Wybierz główny plik sterownika VNC dla podrzędnego sterownika VNC."
::msgcat::mcset $gPB(LANG) "MC(isv,setup,machine,Label)"            "Obrabiarka"
::msgcat::mcset $gPB(LANG) "MC(isv,setup,component,Label)"          "Mocowanie narzędzia"
::msgcat::mcset $gPB(LANG) "MC(isv,setup,mac_zcs_frame,Label)"      "Programuj zerowe odniesienie"
::msgcat::mcset $gPB(LANG) "MC(isv,setup,mac_zcs,Label)"            "Komponent"
::msgcat::mcset $gPB(LANG) "MC(isv,setup,mac_zcs,Context)"          "Określ komponent jako baza odniesienia ZCS. Powinien to być komponent nieobrotowy, z którym część jest bezpośrednio lub pośrednio połączona w drzewie kinematyki."
::msgcat::mcset $gPB(LANG) "MC(isv,setup,spin_com,Label)"           "Komponent"
::msgcat::mcset $gPB(LANG) "MC(isv,setup,spin_com,Context)"         "Określ komponent, na którym będą montowane narzędzia. W przypadku postprocesora frezarki powinien to być komponent wrzeciona, a w przypadku postprocesora tokarki - komponent głowicy."

::msgcat::mcset $gPB(LANG) "MC(isv,setup,spin_jct,Label)"           "Węzeł"
::msgcat::mcset $gPB(LANG) "MC(isv,setup,spin_jct,Context)"         "Definiuj węzeł do montowania narzędzi. W przypadku postprocesora frezarki jest to węzeł na środku czoła wrzeciona. Jest to węzeł obrotowy głowicy w przypadku postprocesora tokarki. Będzie to węzeł mocowania narzędzia, jeśli głowica zostanie utwierdzona."

::msgcat::mcset $gPB(LANG) "MC(isv,setup,axis_name,Label)"          "Oś określona na obrabiarce"
::msgcat::mcset $gPB(LANG) "MC(isv,setup,axis_name,Context)"        "Określ nazwy osi, aby je dopasować do konfiguracji kinematyki obrabiarki"




::msgcat::mcset $gPB(LANG) "MC(isv,setup,axis_frm,Label)"           "Nazwy osi NC"
::msgcat::mcset $gPB(LANG) "MC(isv,setup,rev_fourth,Label)"         "Odwróć obrót"
::msgcat::mcset $gPB(LANG) "MC(isv,setup,rev_fourth,Context)"       "Określ kierunek obrotu osi. Może być normalny lub odwrócony. Dotyczy wyłącznie stołu obrotowego."
::msgcat::mcset $gPB(LANG) "MC(isv,setup,rev_fifth,Label)"          "Odwróć obrót"

::msgcat::mcset $gPB(LANG) "MC(isv,setup,fourth_limit,Label)"       "Limit obrotowy"
::msgcat::mcset $gPB(LANG) "MC(isv,setup,fourth_limit,Context)"     "Określ, czy oś obrotowa ma ograniczenia"
::msgcat::mcset $gPB(LANG) "MC(isv,setup,fifth_limit,Label)"        "Limit obrotowy"
::msgcat::mcset $gPB(LANG) "MC(isv,setup,limiton,Label)"            "Tak"
::msgcat::mcset $gPB(LANG) "MC(isv,setup,limitoff,Label)"           "Nie"
::msgcat::mcset $gPB(LANG) "MC(isv,setup,fourth_table,Label)"       "4. oś"
::msgcat::mcset $gPB(LANG) "MC(isv,setup,fifth_table,Label)"        "5. oś"
::msgcat::mcset $gPB(LANG) "MC(isv,setup,header,Label)"             " Tabela "
::msgcat::mcset $gPB(LANG) "MC(isv,setup,intialization,Label)"      "Sterownik"
::msgcat::mcset $gPB(LANG) "MC(isv,setup,general_def,Label)"        "Ustawienie początkowe"
::msgcat::mcset $gPB(LANG) "MC(isv,setup,advanced_def,Label)"       "Inne opcje"
::msgcat::mcset $gPB(LANG) "MC(isv,setup,InputOutput,Label)"        "Specjalne kody NC"

::msgcat::mcset $gPB(LANG) "MC(isv,setup,program,Label)"            "Domyślna definicja programu"
::msgcat::mcset $gPB(LANG) "MC(isv,setup,output,Label)"             "Eksportuj definicję programu"
::msgcat::mcset $gPB(LANG) "MC(isv,setup,output,Context)"           "Zapisz definicję programu w pliku"
::msgcat::mcset $gPB(LANG) "MC(isv,setup,input,Label)"              "Importuj definicję programu"
::msgcat::mcset $gPB(LANG) "MC(isv,setup,input,Context)"            "Pobierz definicję programu z pliku"
::msgcat::mcset $gPB(LANG) "MC(isv,setup,file_err,Msg)"             "Wybrany plik nie jest zgodny z domyślnym typem pliku definicji programu. Czy chcesz kontynuować?"
::msgcat::mcset $gPB(LANG) "MC(isv,setup,wcs,Label)"                "Odsunięcia mocowania"
::msgcat::mcset $gPB(LANG) "MC(isv,setup,tool,Label)"               "Dane narzędzia"
::msgcat::mcset $gPB(LANG) "MC(isv,setup,g_code,Label)"             "Specjalny kod G"
::msgcat::mcset $gPB(LANG) "MC(isv,setup,special_vnc,Label)"        "Specjalny kod NC"

::msgcat::mcset $gPB(LANG) "MC(isv,setup,initial,frame,Label)"      ""
::msgcat::mcset $gPB(LANG) "MC(isv,setup,initial_motion,Label)"     "Ruch"
::msgcat::mcset $gPB(LANG) "MC(isv,setup,initial_motion,Context)"   "Określ początkowy ruch obrabiarki"

::msgcat::mcset $gPB(LANG) "MC(isv,setup,spindle,frame,Label)"      "Wrzeciono"
::msgcat::mcset $gPB(LANG) "MC(isv,setup,spindle_mode,Label)"       "Tryb"
::msgcat::mcset $gPB(LANG) "MC(isv,setup,spindle_direction,Label)"  "Kierunek"
::msgcat::mcset $gPB(LANG) "MC(isv,setup,spindle,frame,Context)"    "Określ początkową jednostkę prędkości i kierunek obrotu wrzeciona"

::msgcat::mcset $gPB(LANG) "MC(isv,setup,feedrate_mode,Label)"      "Tryb szybkości posuwu"
::msgcat::mcset $gPB(LANG) "MC(isv,setup,feedrate_mode,Context)"    "Określ początkową jednostkę posuwu"

::msgcat::mcset $gPB(LANG) "MC(isv,setup,boolean,frame,Label)"      "Definiowanie obiektu Boole'a"
::msgcat::mcset $gPB(LANG) "MC(isv,setup,power_on_wcs,Label)"       "Włącz WCS  "
::msgcat::mcset $gPB(LANG) "MC(isv,setup,power_on_wcs,Context)"     "0 oznacza użycie domyślnej współrzędnej zerowej obrabiarki\n 1 oznacza użycie pierwszego odsunięcia mocowania użytkownika (współrzędna robocza)"

::msgcat::mcset $gPB(LANG) "MC(isv,setup,use_s_leader,Label)"       "Użyto S"
::msgcat::mcset $gPB(LANG) "MC(isv,setup,use_f_leader,Label)"       "Użyto F"


::msgcat::mcset $gPB(LANG) "MC(isv,setup,dog_leg,Label)"            "Szybki segment łączący"
::msgcat::mcset $gPB(LANG) "MC(isv,setup,dog_leg,Context)"          "WŁ spowoduje wykonanie ruchów szybkich w sposób przeznaczony dla segmentów łączących; WYŁ spowoduje wykonanie ruchów szybkich według kodu NC (punkt-do-punktu)."

::msgcat::mcset $gPB(LANG) "MC(isv,setup,dog_leg,yes)"              "Tak"
::msgcat::mcset $gPB(LANG) "MC(isv,setup,dog_leg,no)"               "Nie"

::msgcat::mcset $gPB(LANG) "MC(isv,setup,on_off_frame,Label)"       "Definiowanie WŁ./WYŁ."
::msgcat::mcset $gPB(LANG) "MC(isv,setup,stroke_limit,Label)"       "Limit powłoki"
::msgcat::mcset $gPB(LANG) "MC(isv,setup,cutcom,Label)"             "Korekcja promieni"
::msgcat::mcset $gPB(LANG) "MC(isv,setup,tl_adjust,Label)"          "Dopasuj długość narzędzia"
::msgcat::mcset $gPB(LANG) "MC(isv,setup,scale,Label)"              "Skala"
::msgcat::mcset $gPB(LANG) "MC(isv,setup,macro_modal,Label)"        "Modalne makro"
::msgcat::mcset $gPB(LANG) "MC(isv,setup,wcs_rotate,Label)"         "Obrót WCS"
::msgcat::mcset $gPB(LANG) "MC(isv,setup,cycle,Label)"              "Cykl"

::msgcat::mcset $gPB(LANG) "MC(isv,setup,initial_mode,frame,Label)"     "Tryb wprowadzania"
::msgcat::mcset $gPB(LANG) "MC(isv,setup,initial_mode,frame,Context)"   "Określ początkowy tryb wprowadzania jako bezwzględny lub przyrostowy"

###################
# Input/Out Related
###################
::msgcat::mcset $gPB(LANG) "MC(isv,sign_define,frame,Label)"        ""
::msgcat::mcset $gPB(LANG) "MC(isv,sign_define,rewindstop,Label)"   "Kod zatrzymania przewijania do tyłu"
::msgcat::mcset $gPB(LANG) "MC(isv,sign_define,rewindstop,Context)" "Określ kod zatrzymania przewijania do tyłu"

::msgcat::mcset $gPB(LANG) "MC(isv,control_var,frame,Label)"        "Zmienne sterujące"

::msgcat::mcset $gPB(LANG) "MC(isv,sign_define,convarleader,Label)"     "Linia odniesienia"
::msgcat::mcset $gPB(LANG) "MC(isv,sign_define,convarleader,Context)"   "Określ zmienną sterownika"
::msgcat::mcset $gPB(LANG) "MC(isv,sign_define,conequ,Label)"           "Znak równości"
::msgcat::mcset $gPB(LANG) "MC(isv,sign_define,conequ,Context)"         "Określ kontrolny znak równości"
::msgcat::mcset $gPB(LANG) "MC(isv,sign_define,percent,Label)"          "Znak procentu %"
::msgcat::mcset $gPB(LANG) "MC(isv,sign_define,leaderjing,Label)"       "Ostro #"
::msgcat::mcset $gPB(LANG) "MC(isv,sign_define,text_string,Label)"      "Ciąg tekstu"

::msgcat::mcset $gPB(LANG) "MC(isv,inputmode,frame,Label)"          ""
::msgcat::mcset $gPB(LANG) "MC(isv,input_mode,Label)"               "Tryb początkowy"
::msgcat::mcset $gPB(LANG) "MC(isv,absolute_mode,Label)"            "Bezwzględny"
::msgcat::mcset $gPB(LANG) "MC(isv,incremental_style,frame,Label)"  "Tryb przyrostowy"

::msgcat::mcset $gPB(LANG) "MC(isv,incremental_mode,Label)"         "Przyrostowe"
::msgcat::mcset $gPB(LANG) "MC(isv,incremental_gcode,Label)"        "Kod G"
::msgcat::mcset $gPB(LANG) "MC(isv,incremental_gcode,Context)"      "Używanie G90 G91 do odróżnienia trybu bezwzględnego od trybu przyrostowego"
::msgcat::mcset $gPB(LANG) "MC(isv,incremental_uvw,Label)"          "Specjalna linia odniesienia"
::msgcat::mcset $gPB(LANG) "MC(isv,incremental_uvw,Context)"        "Używanie specjalnej linii odniesienia do odróżnienia trybu bezwzględnego od trybu przyrostowego. Przykład: linia odniesienia X Y Z oznacza pracę w trybie bezwzględnym, linia odniesienia U V W oznacza pracę w trybie przyrostowym."
::msgcat::mcset $gPB(LANG) "MC(isv,incr_x,Label)"                   "X "
::msgcat::mcset $gPB(LANG) "MC(isv,incr_y,Label)"                   "Y "
::msgcat::mcset $gPB(LANG) "MC(isv,incr_z,Label)"                   "Z "
::msgcat::mcset $gPB(LANG) "MC(isv,incr_a,Label)"                   "Czwarta oś "
::msgcat::mcset $gPB(LANG) "MC(isv,incr_b,Label)"                   "Piąta oś "

::msgcat::mcset $gPB(LANG) "MC(isv,incr_x,Context)"                 "Określ specjalną linię odniesienia osi X używaną w stylu przyrostowym"
::msgcat::mcset $gPB(LANG) "MC(isv,incr_y,Context)"                 "Określ specjalną linię odniesienia osi Y używaną w stylu przyrostowym"
::msgcat::mcset $gPB(LANG) "MC(isv,incr_z,Context)"                 "Określ specjalną linię odniesienia osi Z używaną w stylu przyrostowym"
::msgcat::mcset $gPB(LANG) "MC(isv,incr_a,Context)"                 "Określ specjalną linię odniesienia czwartej osi używaną w stylu przyrostowym"
::msgcat::mcset $gPB(LANG) "MC(isv,incr_b,Context)"                 "Określ specjalną linię odniesienia piątej osi używaną w stylu przyrostowym"
::msgcat::mcset $gPB(LANG) "MC(isv,vnc_mes,frame,Label)"            "Wyświetl komunikat VNC"

::msgcat::mcset $gPB(LANG) "MC(isv,vnc_message,Label)"              "Lista komunikatów VNC"
::msgcat::mcset $gPB(LANG) "MC(isv,vnc_message,Context)"            "Jeśli ta opcja jest zaznaczona, wszystkie komunikaty VNC o usuwaniu błędów będą wyświetlane podczas symulacji w oknie komunikatów operacji."

::msgcat::mcset $gPB(LANG) "MC(isv,vnc_mes,prefix,Label)"           "Przedrostek komunikatu"
::msgcat::mcset $gPB(LANG) "MC(isv,spec_desc,Label)"                "Opis"
::msgcat::mcset $gPB(LANG) "MC(isv,spec_codelist,Label)"            "Lista kodów"
::msgcat::mcset $gPB(LANG) "MC(isv,spec_nccode,Label)"              "Kod/łańcuch NC"

################
# WCS Definition
################
::msgcat::mcset $gPB(LANG) "MC(isv,machine_zero,offset,Label)"      "Odsunięcia punktu zerowego maszyny od\nwęzła punktu zerowego obrabiarki"
::msgcat::mcset $gPB(LANG) "MC(isv,wcs_offset,frame,Label)"         "Odsunięcia mocowania"
::msgcat::mcset $gPB(LANG) "MC(isv,wcs_leader,Label)"               " Kod "
::msgcat::mcset $gPB(LANG) "MC(isv,wcs_number,Label)"               "    "
::msgcat::mcset $gPB(LANG) "MC(isv,wcs_offset,origin_x,Label)"      " Odsunięcie wzdłuż osi X  "
::msgcat::mcset $gPB(LANG) "MC(isv,wcs_offset,origin_y,Label)"      " Odsunięcie wzdłuż osi Y  "
::msgcat::mcset $gPB(LANG) "MC(isv,wcs_offset,origin_z,Label)"      " Odsunięcie wzdłuż osi Z  "
::msgcat::mcset $gPB(LANG) "MC(isv,wcs_offset,a_offset,Label)"      " Odsunięcie A  "
::msgcat::mcset $gPB(LANG) "MC(isv,wcs_offset,b_offset,Label)"      " Odsunięcie B  "
::msgcat::mcset $gPB(LANG) "MC(isv,wcs_offset,c_offset,Label)"      " Odsunięcie C  "
::msgcat::mcset $gPB(LANG) "MC(isv,wcs_offset,wcs_num,Label)"       "Układ współrzędnych"
::msgcat::mcset $gPB(LANG) "MC(isv,wcs_offset,wcs_num,Context)"     "Określ numer wymaganego odsunięcia mocowania, które należy dodać"
::msgcat::mcset $gPB(LANG) "MC(isv,wcs_offset,wcs_add,Label)"       "Dodaj"
::msgcat::mcset $gPB(LANG) "MC(isv,wcs_offset,wcs_add,Context)"     "Dodaj nowy układ współrzędnych odsunięć mocowania i określ jego pozycję"
::msgcat::mcset $gPB(LANG) "MC(isv,wcs_offset,wcs_err,Msg)"         "Ten numer układu współrzędnych już istnieje!"
::msgcat::mcset $gPB(LANG) "MC(isv,tool_info,frame,Label)"          "Informacje o narzędziu"
::msgcat::mcset $gPB(LANG) "MC(isv,tool_info,tool_entry,Label)"     "Wprowadź nową nazwę narzędzia"
::msgcat::mcset $gPB(LANG) "MC(isv,tool_info,tool_name,Label)"      "       Nazwa       "

::msgcat::mcset $gPB(LANG) "MC(isv,tool_info,tool_num,Label)"       " Narzędzie "
::msgcat::mcset $gPB(LANG) "MC(isv,tool_info,add_tool,Label)"       "Dodaj"
::msgcat::mcset $gPB(LANG) "MC(isv,tool_info,tool_diameter,Label)"  " Średnica "
::msgcat::mcset $gPB(LANG) "MC(isv,tool_info,offset_usder,Label)"   "   Odsunięcia końcówki   "
::msgcat::mcset $gPB(LANG) "MC(isv,tool_info,carrier_id,Label)"     " ID magazynu "
::msgcat::mcset $gPB(LANG) "MC(isv,tool_info,pocket_id,Label)"      " Identyfikator kieszeni "
::msgcat::mcset $gPB(LANG) "MC(isv,tool_info,cutcom_reg,Label)"     "     KOREKCJA PROM.     "
::msgcat::mcset $gPB(LANG) "MC(isv,tool_info,cutreg,Label)"         "Rejestr "
::msgcat::mcset $gPB(LANG) "MC(isv,tool_info,cutval,Label)"         "Odsunięcie "
::msgcat::mcset $gPB(LANG) "MC(isv,tool_info,adjust_reg,Label)"     " Nr korektora dług. "
::msgcat::mcset $gPB(LANG) "MC(isv,tool_info,tool_type,Label)"      "   Typ   "
::msgcat::mcset $gPB(LANG) "MC(isv,prog,setup,Label)"               "Domyślna definicja programu"
::msgcat::mcset $gPB(LANG) "MC(isv,prog,setup_right,Label)"         "Definicja programu"
::msgcat::mcset $gPB(LANG) "MC(isv,output,setup_data,Label)"        "Określ plik definicji programu"
::msgcat::mcset $gPB(LANG) "MC(isv,input,setup_data,Label)"         "Wybierz plik definicji programu"

::msgcat::mcset $gPB(LANG) "MC(isv,tool_info,toolnum,Label)"        "Nr narzędzia T  "
::msgcat::mcset $gPB(LANG) "MC(isv,tool_info,toolnum,Context)"      "Określ numer narzędzia, które należy dodać"
::msgcat::mcset $gPB(LANG) "MC(isv,tool_info,add_tool,Context)"     "Dodaj nowe narzędzie i określ jego parametry"
::msgcat::mcset $gPB(LANG) "MC(isv,tool_info,add_err,Msg)"          "Ten numer narzędzia już istnieje!"
::msgcat::mcset $gPB(LANG) "MC(isv,tool_info,name_err,Msg)"         "Nazwa narzędzia nie może być pusta!"

###########################
# Special G code Definition
###########################

::msgcat::mcset $gPB(LANG) "MC(isv,g_code,frame,Label)"             "Specjalny kod G"
::msgcat::mcset $gPB(LANG) "MC(isv,g_code,frame,Context)"           "Określ specjalne kody G używane w symulacji"
::msgcat::mcset $gPB(LANG) "MC(isv,g_code,from_home,Label)"         "Z pozycji wyjściowej"
::msgcat::mcset $gPB(LANG) "MC(isv,g_code,return_home,Label)"       "Powrót do punktu zakończenia Pn"
::msgcat::mcset $gPB(LANG) "MC(isv,g_code,mach_wcs,Label)"          "Ruch odniesienia obrabiarki"
::msgcat::mcset $gPB(LANG) "MC(isv,g_code,set_local,Label)"         "Ustaw współrzędną lokalną"

###########################
# Special NC Custom Command
###########################

::msgcat::mcset $gPB(LANG) "MC(isv,spec_command,frame,Label)"       "Specjalne polecenia NC"
::msgcat::mcset $gPB(LANG) "MC(isv,spec_command,frame,Context)"     "Polecenia NC określone dla urządzeń specjalnych"


::msgcat::mcset $gPB(LANG) "MC(isv,spec_pre,frame,Label)"           "Polecenia przetwarzania wstępnego"
::msgcat::mcset $gPB(LANG) "MC(isv,spec_pre,frame,Context)"         "Lista poleceń zawiera wszystkie tokeny lub symbole, które należy przetworzyć przed przekazaniem bloku do analizy współrzędnych"

::msgcat::mcset $gPB(LANG) "MC(isv,spec_command,add,Label)"         "Dodaj"
::msgcat::mcset $gPB(LANG) "MC(isv,spec_command,edit,Label)"        "Edytuj"
::msgcat::mcset $gPB(LANG) "MC(isv,spec_command,delete,Label)"      "Usuń"
::msgcat::mcset $gPB(LANG) "MC(isv,spec_command,title,Label)"       "Polecenie specjalne dla innych urządzeń"
::msgcat::mcset $gPB(LANG) "MC(isv,spec_command,add_sim,Label)"     "Dodaj polecenie SIM w położeniu kursora"
::msgcat::mcset $gPB(LANG) "MC(isv,spec_command,init_sim,Label)"    "Wybierz jedno polecenie"

::msgcat::mcset $gPB(LANG) "MC(isv,spec_command,preleader,Label)"   "Linia odniesienia"
::msgcat::mcset $gPB(LANG) "MC(isv,spec_command,preleader,Context)" "Określ linię odniesienia dla wstępnie przetworzonego polecenia użytkownika."

::msgcat::mcset $gPB(LANG) "MC(isv,spec_command,precode,Label)"     "Kod"
::msgcat::mcset $gPB(LANG) "MC(isv,spec_command,precode,Context)"   "Określ linię odniesienia dla wstępnie przetworzonego polecenia użytkownika."

::msgcat::mcset $gPB(LANG) "MC(isv,spec_command,leader,Label)"      "Linia odniesienia"
::msgcat::mcset $gPB(LANG) "MC(isv,spec_command,leader,Context)"    "Określ linię odniesienia dla polecenia użytkownika."

::msgcat::mcset $gPB(LANG) "MC(isv,spec_command,code,Label)"        "Kod"
::msgcat::mcset $gPB(LANG) "MC(isv,spec_command,code,Context)"      "Określ linię odniesienia dla polecenia użytkownika."

::msgcat::mcset $gPB(LANG) "MC(isv,spec_command,add,Context)"       "Dodaj nowe polecenie użytkownika"
::msgcat::mcset $gPB(LANG) "MC(isv,spec_command,add_err,Msg)"       "Ten token został już obsłużony!"
::msgcat::mcset $gPB(LANG) "MC(isv,spec_command,sel_err,Msg)"       "Wybierz polecenie"
::msgcat::mcset $gPB(LANG) "MC(isv,export,error,title)"             "Ostrzeżenie"

::msgcat::mcset $gPB(LANG) "MC(isv,tool_table,title,Label)"         "Stół narzędzia"
::msgcat::mcset $gPB(LANG) "MC(isv,ex_editor,warning,Msg)"          "To jest polecenie sterownika VNC generowane przez system. Zmiany nie zostaną zapisane."


# - Languages
#
::msgcat::mcset $gPB(LANG) "MC(language,Label)"                     "Język"
::msgcat::mcset $gPB(LANG) "MC(pb_msg_english)"                     "Calowe"
::msgcat::mcset $gPB(LANG) "MC(pb_msg_french)"                      "Francuski"
::msgcat::mcset $gPB(LANG) "MC(pb_msg_german)"                      "Niemiecki"
::msgcat::mcset $gPB(LANG) "MC(pb_msg_italian)"                     "Włoski"
::msgcat::mcset $gPB(LANG) "MC(pb_msg_japanese)"                    "japońskie"
::msgcat::mcset $gPB(LANG) "MC(pb_msg_korean)"                      "koreański"
::msgcat::mcset $gPB(LANG) "MC(pb_msg_russian)"                     "rosyjski"
::msgcat::mcset $gPB(LANG) "MC(pb_msg_simple_chinese)"              "chiński uproszczony"
::msgcat::mcset $gPB(LANG) "MC(pb_msg_spanish)"                     "hiszpański"
::msgcat::mcset $gPB(LANG) "MC(pb_msg_traditional_chinese)"         "chiński tradycyjny"

### Exit Options Dialog
::msgcat::mcset $gPB(LANG) "MC(exit,options,Label)"                 "Opcje zakończenia"
::msgcat::mcset $gPB(LANG) "MC(exit,options,SaveAll,Label)"         "Zakończ i zapisz wszystko"
::msgcat::mcset $gPB(LANG) "MC(exit,options,SaveNone,Label)"        "Zakończ bez zapisywania"
::msgcat::mcset $gPB(LANG) "MC(exit,options,SaveSelect,Label)"      "Zakończ i zapisz wybrane"

### OptionMenu Items
::msgcat::mcset $gPB(LANG) "MC(optionMenu,item,Other)"       "Inne"
::msgcat::mcset $gPB(LANG) "MC(optionMenu,item,None)"        "Brak"
::msgcat::mcset $gPB(LANG) "MC(optionMenu,item,RT_R)"        "Szybki posuw i R"
::msgcat::mcset $gPB(LANG) "MC(optionMenu,item,Rapid)"       "Szybki"
::msgcat::mcset $gPB(LANG) "MC(optionMenu,item,RS)"          "Szybkie wrzeciono"
::msgcat::mcset $gPB(LANG) "MC(optionMenu,item,C_off_RS)"    "Wyłącz cykl, gdy użyto szybkiego wrzeciona"
::msgcat::mcset $gPB(LANG) "MC(optionMenu,item,IPM)"         "CAL/MIN"
::msgcat::mcset $gPB(LANG) "MC(optionMenu,item,FRN)"         "FRN"
::msgcat::mcset $gPB(LANG) "MC(optionMenu,item,IPR)"         "CAL/OBR"
::msgcat::mcset $gPB(LANG) "MC(optionMenu,item,Auto)"        "Automatycznie"
::msgcat::mcset $gPB(LANG) "MC(optionMenu,item,DPM)"         "DPM"
::msgcat::mcset $gPB(LANG) "MC(optionMenu,item,Abs_Inc)"     "Bezwzględny/Przyrostowy"
::msgcat::mcset $gPB(LANG) "MC(optionMenu,item,Abs_Only)"    "Tylko bezwzględny"
::msgcat::mcset $gPB(LANG) "MC(optionMenu,item,Inc_Only)"    "Tylko przyrostowy"
::msgcat::mcset $gPB(LANG) "MC(optionMenu,item,SD)"          "Najkrótsza odległość"
::msgcat::mcset $gPB(LANG) "MC(optionMenu,item,AP)"          "Zawsze dodatni"
::msgcat::mcset $gPB(LANG) "MC(optionMenu,item,AN)"          "Zawsze ujemny"
::msgcat::mcset $gPB(LANG) "MC(optionMenu,item,Z_Axis)"      "Oś Z"
::msgcat::mcset $gPB(LANG) "MC(optionMenu,item,+X_Axis)"     "+Oś X"
::msgcat::mcset $gPB(LANG) "MC(optionMenu,item,-X_Axis)"     "-Oś X"
::msgcat::mcset $gPB(LANG) "MC(optionMenu,item,Y_Axis)"      "Oś Y"
::msgcat::mcset $gPB(LANG) "MC(optionMenu,item,MDD)"         "Wielkość określa kierunek"
::msgcat::mcset $gPB(LANG) "MC(optionMenu,item,SDD)"         "Znak określa kierunek"



