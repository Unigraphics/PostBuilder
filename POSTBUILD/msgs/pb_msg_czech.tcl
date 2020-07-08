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
::msgcat::mcset $gPB(LANG) "MC(event,misc,pattern_csys_start,name)"       "Začátek souřadnicového systému sady vzorů"
::msgcat::mcset $gPB(LANG) "MC(event,misc,pattern_csys_end,name)"         "Konec souřadnicového systému sady vzorů"

# Toggle to signal post being able to process and output subprograms
::msgcat::mcset $gPB(LANG) "MC(listing,subprog_out,check,Label)"          "Povolit výstup podprogramu"

::msgcat::mcset $gPB(LANG) "MC(listing,subprog_out,check,Context)"        "Pomocí tohoto přepínače bude jádro postprocesoru NX upozorněno, že je tento postprocesor vybaven možností vytvořit výstup podprogramu."

::msgcat::mcset $gPB(LANG) "MC(address,leader,err_msg)"                   "Úvodní kód adres X, Y, Z, fourth_axis, fifth_axis a N nesmí být konfigurován s výrazem obsahující proměnné.\n\nTato kontrola může být vypnuta pomocí nastavení gPB(ALLOW_VAR_SYS_LEADER) na \"1\" v souboru ui_pb_user_resource.tcl."

#=============================================================================
# pb1872
#=============================================================================
# Event triggered, during lathe roughing cycle, before the last segment of contour geometry is processed.
::msgcat::mcset $gPB(LANG) "MC(event,misc,before_contour_end,name)"       "Před koncem kontury"


#=============================================================================
# pb1847
#=============================================================================
# Toggle to enable post output transition path
::msgcat::mcset $gPB(LANG) "MC(listing,tran_path,check,Label)"            "Výstupní dráha přechodu"

::msgcat::mcset $gPB(LANG) "MC(listing,tran_path,check,Context)"          "Tento přepínač zapne zpracování a provedení výstupu událostí vzniklých z cesty přechodu mezi operacemi pomocí NX/postprocesoru."


#=============================================================================
# pb12.02
#=============================================================================
# Dialog title for displaying the text of FORMAT, ADDRESS & BLOCK's definition
::msgcat::mcset $gPB(LANG) "MC(block,def_popup,Label)"                    "Definice"

::msgcat::mcset $gPB(LANG) "MC(msg,info,obj_undef)"                       "Informace o tomto objektu nejsou zatím nakonfigurovány."

::msgcat::mcset $gPB(LANG) "MC(msg,info,vnc_cmd_by_pb)"                   "Příkaz VNC generovaný aplikací Post Builder pro přenos nastavení z postprocesoru do jeho ovladače VNC."

::msgcat::mcset $gPB(LANG) "MC(msg,info,vnc_util)"                        "Pomocné příkazy VNC definované v PB_CMD_vnc__define_misc_procs."

::msgcat::mcset $gPB(LANG) "MC(msg,info,sim_cmd)"                         "Příkazy SIM, které se mají použít v ovladači simulace."

::msgcat::mcset $gPB(LANG) "MC(msg,info,pb_vnc_cmd)"                      "Příkazy vygenerované aplikací Post Builder pro propojení klíčových událostí postprocesoru s ovladačem VNC."

::msgcat::mcset $gPB(LANG) "MC(msg,info,vnc_broker_cmd)"                  "Zprostředkující příkazy používané v ovladači VNC ke spuštění dalších příkazů."

# Confirmation when user is about to delete an event
::msgcat::mcset $gPB(LANG) "MC(msg,event,delete_confirm)"                 "Opravdu chcete odstranit událost"


#=============================================================================
# pb12.01
#=============================================================================
# User specified how to handle situation of rotary axis limit violation
::msgcat::mcset $gPB(LANG) "MC(event,misc,user_limit_action,name)"        "Uživatelská akce meze osy"

# Skip output of NC code when rotary limit violation has occurred.
::msgcat::mcset $gPB(LANG) "MC(machine,axis,violation,omit,Label)"        "Vynechat výstup"

# Add/edit notes for a set of custom commands to be exported.
::msgcat::mcset $gPB(LANG) "MC(func,edit_note,Label)"                     "Upravit poznámky"

#=============================================================================
# pb12.00
#=============================================================================
# Short for "information about ..."
::msgcat::mcset $gPB(LANG) "MC(block,info_popup,Label)"                   "Informace"

#=============================================================================
# pb11.02
#=============================================================================
# Markers of events taking place at the start & end of cut regions.
::msgcat::mcset $gPB(LANG) "MC(event,misc,region_start_marker,name)"      "Počátek značky oblasti"
::msgcat::mcset $gPB(LANG) "MC(event,misc,region_end_marker,name)"        "Konec značky oblasti"

#=============================================================================
# pb11.01
#=============================================================================
# A comment of Tcl language
::msgcat::mcset $gPB(LANG) "MC(event,combo,tcl_line,Label)"               "Komentář Tcl"

#=============================================================================
# pb10.03
#=============================================================================
::msgcat::mcset $gPB(LANG) "MC(msg,filename_with_spec_char)"              "Název souboru nemůže obsahovat speciální znaky!"
::msgcat::mcset $gPB(LANG) "MC(msg,not_post_comp_file)"                   "Vlastní komponenty postprocesoru není možné vybrat pro toto zahrnutí!"
::msgcat::mcset $gPB(LANG) "MC(listing,output,warning,warn_file)"         "Soubor upozornění"
::msgcat::mcset $gPB(LANG) "MC(listing,output,warning,nc_output)"         "Výstup NC"

#=============================================================================
# pb10.02
#=============================================================================
::msgcat::mcset $gPB(LANG) "MC(machine,resolution,check,Label)"           "Vypnout kontrolu pro aktuální postprocesor"
::msgcat::mcset $gPB(LANG) "MC(main,options,debug,Label)"                 "Vložit ladicí zprávy postprocesoru"
::msgcat::mcset $gPB(LANG) "MC(encrypt,suppress,Label)"                   "Vypnout změnu licence pro aktuální postprocesor"
::msgcat::mcset $gPB(LANG) "MC(main,title,license_control)"               "Řízení licence"

#=============================================================================
# pb902
#=============================================================================
::msgcat::mcset $gPB(LANG) "MC(other,ude_include_def,Label)"              "Zahrnout jiné soubory CDL nebo DEF"
#-----------------------------------------------------------------------------
# Labels for new tapping cycles
#-----------------------------------------------------------------------------
::msgcat::mcset $gPB(LANG) "MC(event,cycle,tap_deep,name)"                "Hluboké závitování"
::msgcat::mcset $gPB(LANG) "MC(event,cycle,tap_break_chip,name)"          "Závitování s přerušením třísky"
::msgcat::mcset $gPB(LANG) "MC(g_code,tap_float,name)"                    "Závitování s vyrov. hlavou"
::msgcat::mcset $gPB(LANG) "MC(g_code,tap_deep,name)"                     "Hluboké závitování"
::msgcat::mcset $gPB(LANG) "MC(g_code,tap_break_chip,name)"               "Závitování s přerušením třísky"
#-----------------------------------------------------------------------------
# Defined strings that did not make it to the local language files.
# - These strings should be included for translation in the later release.
#-----------------------------------------------------------------------------
::msgcat::mcset $gPB(LANG) "MC(event,cycle,plane_change,axis,label)"      "Detekovat změny osy nástroje mezi dírami"
::msgcat::mcset $gPB(LANG) "MC(event,feedrates,mode,rapid)"               "Úkos"
::msgcat::mcset $gPB(LANG) "MC(event,feedrates,mode,cutting)"             "Obrábění"

#=============================================================================
# pb800
#=============================================================================
::msgcat::mcset $gPB(LANG) "MC(event,misc,subop_start,name)"      "Počátek dráhy podoperace"
::msgcat::mcset $gPB(LANG) "MC(event,misc,subop_end,name)"        "Konec dráhy podoperace"
::msgcat::mcset $gPB(LANG) "MC(event,misc,contour_start,name)"    "Počátek kontury"
::msgcat::mcset $gPB(LANG) "MC(event,misc,contour_end,name)"      "Konec kontury"
::msgcat::mcset $gPB(LANG) "MC(prog,tree,misc,Label)"             "Různé"
::msgcat::mcset $gPB(LANG) "MC(event,cycle,lathe_rough,name)"     "Hrubování soustružením"
::msgcat::mcset $gPB(LANG) "MC(main,file,properties,Label)"       "Vlastnosti postprocesoru"

::msgcat::mcset $gPB(LANG) "MC(ude,editor,popup,MSG_CATEGORY)"    "UDE postprocesoru frézování nebo soustružení nemusí být pouze s kategorií \"Drátořez\" určeno!"

::msgcat::mcset $gPB(LANG) "MC(event,cycle,plane_change,label)"   "Detekovat změnu pracovní roviny na nižší"
::msgcat::mcset $gPB(LANG) "MC(format,check_1,error,msg)"         "Formát nemůže pojmout hodnoty výrazů"

::msgcat::mcset $gPB(LANG) "MC(format,check_4,error,msg)"         "Před opuštěním stránky nebo uložením tohoto postprocesoru změňte formát související adresy!"
::msgcat::mcset $gPB(LANG) "MC(format,check_5,error,msg)"         "Před opuštěním stránky nebo uložením tohoto postprocesoru upravte formát!"
::msgcat::mcset $gPB(LANG) "MC(format,check_6,error,msg)"         "Před vstupem na stránku změňte formát související adresy!"

::msgcat::mcset $gPB(LANG) "MC(msg,old_block,maximum_length)"     "Názvy následujících bloků překročily omezení délky:"
::msgcat::mcset $gPB(LANG) "MC(msg,old_address,maximum_length)"   "Názvy následujících slov překročily omezení délky:"
::msgcat::mcset $gPB(LANG) "MC(msg,block_address,check,title)"    "Kontrola názvů bloků a slov"
::msgcat::mcset $gPB(LANG) "MC(msg,block_address,maximum_length)" "Některé názvy bloků nebo slov překročily omezení délky."

::msgcat::mcset $gPB(LANG) "MC(address,maximum_name_msg)"         "Délka řetězce překračuje omezení."

::msgcat::mcset $gPB(LANG) "MC(ude,import,oth_list,Label)"        "Zahrnout jiný soubor CDL"
::msgcat::mcset $gPB(LANG) "MC(ude,import,oth_list,Context)"      "Výběrem možnosti \\\"Nový\\\" v místní nabídce (po kliknutí pravým tlačítkem myši) zahrňte jiné soubory CDL s tímto postprocesorem."
::msgcat::mcset $gPB(LANG) "MC(ude,import,ihr_list,Label)"        "Převzít UDE z postprocesoru"
::msgcat::mcset $gPB(LANG) "MC(ude,import,ihr_list,Context)"      "Výběrem možnosti \\\"Nový\\\" v místní nabídce (po kliknutí pravým tlačítkem myši) převezměte definice UDE a asociované ovladače z postprocesoru."
::msgcat::mcset $gPB(LANG) "MC(ude,import,up,Label)"              "Nahoru"
::msgcat::mcset $gPB(LANG) "MC(ude,import,down,Label)"            "Dolů"
::msgcat::mcset $gPB(LANG) "MC(msg,exist_cdl_file)"               "Určený soubor CDL již byl zahrnut!"

::msgcat::mcset $gPB(LANG) "MC(listing,link_var,check,Label)"     "Propojit proměnné Tcl s proměnnými C"
::msgcat::mcset $gPB(LANG) "MC(listing,link_var,check,Context)"   "Sadu často měněných proměnných, například \\\"mom_pos\\\", je možné propojit přímo s vnitřními proměnnými C a tím zlepšit výkon postprocesingu. Aby nedošlo k chybám a odlišnostem ve výstupu NC, je nutné sledovat určitá omezení."

::msgcat::mcset $gPB(LANG) "MC(msg,check_resolution,title)"       "Kontrola rozlišení lineárního nebo rotačního pohybu"
::msgcat::mcset $gPB(LANG) "MC(msg,check_resolution,linear)"      "Nastavení formátu nemůže pojmout výstup \"Rozlišení lineárního pohybu\"."
::msgcat::mcset $gPB(LANG) "MC(msg,check_resolution,rotary)"      "Nastavení formátu nemůže pojmout výstup \"Rozlišení rotačního pohybu\"."

::msgcat::mcset $gPB(LANG) "MC(cmd,export,desc,label)"            "Vložit popis pro exportované vlastní příkazy"
::msgcat::mcset $gPB(LANG) "MC(cmd,desc_dlg,title)"               "Popis"
::msgcat::mcset $gPB(LANG) "MC(block,delete_row,Label)"           "Odstranit všechny aktivní prvky na tomto řádku"
::msgcat::mcset $gPB(LANG) "MC(block,exec_cond,set,Label)"        "Podmínka výstupu"
::msgcat::mcset $gPB(LANG) "MC(block,exec_cond,new,Label)"        "Nový..."
::msgcat::mcset $gPB(LANG) "MC(block,exec_cond,edit,Label)"       "Upravit..."
::msgcat::mcset $gPB(LANG) "MC(block,exec_cond,remove,Label)"     "Odebrat..."

::msgcat::mcset $gPB(LANG) "MC(cust_cmd,name_msg_for_cond)"       "Zadejte jiná název.  \nPříkaz podmínky výstupu musí začínat"

::msgcat::mcset $gPB(LANG) "MC(machine,linearization,Label)"         "Interpolace linearizace"
::msgcat::mcset $gPB(LANG) "MC(machine,linearization,angle,Label)"   "Úhel otočení"
::msgcat::mcset $gPB(LANG) "MC(machine,linearization,angle,Context)" "Interpolované body budou vypočítány podle distribuce počátečních a koncových úhlu os otočení."
::msgcat::mcset $gPB(LANG) "MC(machine,linearization,axis,Label)"    "Osa nástroje"
::msgcat::mcset $gPB(LANG) "MC(machine,linearization,axis,Context)"  "Interpolované body budou vypočítány podle distribuce počátečních a koncových vektorů os nástrojů."
::msgcat::mcset $gPB(LANG) "MC(machine,resolution,continue,Label)"   "Pokračovat"
::msgcat::mcset $gPB(LANG) "MC(machine,resolution,abort,Label)"      "Zrušit"

::msgcat::mcset $gPB(LANG) "MC(machine,axis,def_lintol,Label)"       "Výchozí tolerance"
::msgcat::mcset $gPB(LANG) "MC(machine,axis,def_lintol,Context)"     "Výchozí tolerance linearizace"
::msgcat::mcset $gPB(LANG) "MC(sub_post,inch,Lable)"                 "PALCE"
::msgcat::mcset $gPB(LANG) "MC(sub_post,metric,Lable)"               "MM"
::msgcat::mcset $gPB(LANG) "MC(new_sub,title,Label)"                 "Vytvořit nový podřízený postprocesor"
::msgcat::mcset $gPB(LANG) "MC(new,sub_post,toggle,label)"           "Podřízený postprocesor"
::msgcat::mcset $gPB(LANG) "MC(new,sub_post,toggle,tmp_label)"       "Dílčí postprocesor omezený na jednotky"
::msgcat::mcset $gPB(LANG) "MC(new,unit_post,filename,msg)"          "Nový dílčí postprocesor pro alternativní výstupní jednotky musí být pojmenován\n přidáním přípony \"__MM\" nebo \"__IN\" za název hlavního postprocesoru."
::msgcat::mcset $gPB(LANG) "MC(new,alter_unit,toggle,label)"         "Alternativní výstupní jednotka"
::msgcat::mcset $gPB(LANG) "MC(new,main_post,label)"                 "Hlavní postprocesor"
::msgcat::mcset $gPB(LANG) "MC(new,main_post,warning_1,msg)"         "K tvorbě nového dílčího postprocesoru je možné použít pouze úplný hlavní postprocesor!"
::msgcat::mcset $gPB(LANG) "MC(new,main_post,warning_2,msg)"         "Hlavní postprocesor musí být vytvořen nebo uložen\n v aplikaci Post Builder verze 8.0 nebo novější."
::msgcat::mcset $gPB(LANG) "MC(new,main_post,specify_err,msg)"       "K tvorbě dílčího postprocesoru je nutné určit hlavní postprocesor!"
::msgcat::mcset $gPB(LANG) "MC(machine,gen,alter_unit,Label)"        "Výstupní jednotky dílčího postprocesoru :"
::msgcat::mcset $gPB(LANG) "MC(unit_related_param,tab,Label)"        "Parametry jednotek"
::msgcat::mcset $gPB(LANG) "MC(unit_related_param,feed_rate,Label)"  "Rychlost posuvu"
::msgcat::mcset $gPB(LANG) "MC(listing,alt_unit,frame,Label)"        "Volitelný dílčí postprocesor alternativních jednotek"
::msgcat::mcset $gPB(LANG) "MC(listing,alt_unit,default,Label)"      "Výchozí nastavení"
::msgcat::mcset $gPB(LANG) "MC(listing,alt_unit,default,Context)"    "Výchozí název dílčího postprocesoru alternativních jednotek bude <název postprocesoru>_MM nebo <název postprocesoru>__IN"
::msgcat::mcset $gPB(LANG) "MC(listing,alt_unit,specify,Label)"      "Určit"
::msgcat::mcset $gPB(LANG) "MC(listing,alt_unit,specify,Context)"    "Určit název podřízeného postprocesoru alternativních jednotek"
::msgcat::mcset $gPB(LANG) "MC(listing,alt_unit,select_name,Label)"  "Vybrat název"
::msgcat::mcset $gPB(LANG) "MC(listing,alt_unit,warning_1,msg)"      "Je možné vybrat pouze dílčí postprocesor alternativních jednotek!"
::msgcat::mcset $gPB(LANG) "MC(listing,alt_unit,warning_2,msg)"      "Vybraný dílčí postprocesor nemůže pro tento postprocesor podporovat alternativní výstupní jednotky!"

::msgcat::mcset $gPB(LANG) "MC(listing,alt_unit,post_name,Label)"    "Dílčí postprocesor alternativních jednotek"
::msgcat::mcset $gPB(LANG) "MC(listing,alt_unit,post_name,Context)"  "Postprocesor NX bude pro tento postprocesor k řízení alternativních výstupních jednotek používat dílčí postprocesor jednotek."


##--------------------
## New string in v7.5
##
::msgcat::mcset $gPB(LANG) "MC(machine,axis,violation,user,evt_title)"  "Uživatelská akce pro porušení meze osy"
::msgcat::mcset $gPB(LANG) "MC(event,helix,name)"                       "Pohyb šroubovice"
::msgcat::mcset $gPB(LANG) "MC(event,circular,ijk_param,prefix,msg)"    "Výrazy použité v adresách"
::msgcat::mcset $gPB(LANG) "MC(event,circular,ijk_param,postfix,msg)"   "nebudou změnou této možnosti ovlivněny!"
::msgcat::mcset $gPB(LANG) "MC(isv,spec_codelist,default,msg)"          "Tato akce obnoví seznam speciálních kódů NC a\n jejich ovladače do stavu, v jakém byly, když byl tento postprocesor otevřen nebo vytvořen.\n\n Chcete pokračovat?"
::msgcat::mcset $gPB(LANG) "MC(isv,spec_codelist,restore,msg)"          "Tato akce obnoví seznam speciálních kódů NC a\n jejich ovladače do stavu, v jakém byly, když byla tato stránka naposledy otevřena.\n\n Chcete pokračovat?"
::msgcat::mcset $gPB(LANG) "MC(msg,block_format_command,paste_err)"     "Název objektu existuje...Vložení je neplatné!"
::msgcat::mcset $gPB(LANG) "MC(main,file,open,choose_cntl_type)"        "Vyberte rodinu řídicích systémů"
::msgcat::mcset $gPB(LANG) "MC(cust_cmd,import,no_vnc_cmd,msg)"         "Tento soubor neobsahuje žádný nový nebo jiný příkaz VNC!"
::msgcat::mcset $gPB(LANG) "MC(cust_cmd,import,no_cmd,msg)"             "Tento soubor neobsahuje žádný nový nebo jiný vlastní příkaz!"
::msgcat::mcset $gPB(LANG) "MC(isv,tool_info,name_same_err,Msg)"        "Názvy nástrojů nemohou být stejné!"
::msgcat::mcset $gPB(LANG) "MC(msg,limit_to_change_license)"            "Nejste autorem tohoto postprocesoru. \nNebudete jej moci přejmenovat ani měnit jeho licenci."
::msgcat::mcset $gPB(LANG) "MC(output,other_opts,validation,msg)"       "Název uživatelského souboru tcl musí být zadán."
::msgcat::mcset $gPB(LANG) "MC(machine,empty_entry_err,msg)"            "Na stránce tohoto parametru se nacházejí prázdné záznamy."
::msgcat::mcset $gPB(LANG) "MC(msg,control_v_limit)"                    "Řetězec, který chcete vložit, nejspíše\n překročil omezení délky nebo\n obsahoval více řádků nebo neplatné znaky."
::msgcat::mcset $gPB(LANG) "MC(block,capital_name_msg)"                 "První písmeno názvu bloku nemůže být velké!\n Zadejte jiný název."
::msgcat::mcset $gPB(LANG) "MC(machine,axis,violation,user,Label)"      "Uživatelem definovaný"
::msgcat::mcset $gPB(LANG) "MC(machine,axis,violation,user,Handler)"    "Ovladač"
::msgcat::mcset $gPB(LANG) "MC(new,user,file,NOT_EXIST)"                "Soubor tohoto uživatele neexistuje!"
::msgcat::mcset $gPB(LANG) "MC(new,include_vnc,Label)"                  "Zahrnout virtuální řídicí systém NC"
::msgcat::mcset $gPB(LANG) "MC(other,opt_equal,Label)"                  "Znak rovná se (=)"
::msgcat::mcset $gPB(LANG) "MC(event,nurbs,name)"                       "Pohyb NURBS"
::msgcat::mcset $gPB(LANG) "MC(event,cycle,tap_float,name)"             "Závitování s vyrov. hlavou"
::msgcat::mcset $gPB(LANG) "MC(event,cycle,thread,name)"                "Závit"
::msgcat::mcset $gPB(LANG) "MC(ude,editor,group,MSG_NESTED_GROUP)"      "Vnořené seskupení není podporováno!"
::msgcat::mcset $gPB(LANG) "MC(ude,editor,bmp,Label)"                   "Rastrový obrázek"
::msgcat::mcset $gPB(LANG) "MC(ude,editor,bmp,Context)"                 "Přidejte nový parametr rastrového obrázku jeho přetažením do seznamu vpravo."
::msgcat::mcset $gPB(LANG) "MC(ude,editor,group,Label)"                 "Skupina"
::msgcat::mcset $gPB(LANG) "MC(ude,editor,group,Context)"               "Přidejte nový parametr seskupování jeho přetažením do seznamu vpravo."
::msgcat::mcset $gPB(LANG) "MC(ude,editor,eventdlg,DESC,Label)"         "Popis"
::msgcat::mcset $gPB(LANG) "MC(ude,editor,eventdlg,DESC,Context)"       "Určit informace o události"
::msgcat::mcset $gPB(LANG) "MC(ude,editor,eventdlg,URL,Label)"          "URL"
::msgcat::mcset $gPB(LANG) "MC(ude,editor,eventdlg,URL,Context)"        "Určit adresu URL pro popis k události"
::msgcat::mcset $gPB(LANG) "MC(ude,editor,param,MSG_WRONG_IMAGE_FILE)"  "Soubor obrázku musí být formátu BMP!"
::msgcat::mcset $gPB(LANG) "MC(ude,editor,param,MSG_WRONG_IMAGE_FOLDER)" "Soubor rastrového obrázku nesmí obsahovat cestu k adresáři!"
::msgcat::mcset $gPB(LANG) "MC(ude,editor,param,MSG_WRONG_VAR_NAME)"    "Název proměnné musí začínat písmenem."
::msgcat::mcset $gPB(LANG) "MC(ude,editor,param,MSG_WRONG_KEYWORD)"     "Název proměnné nemůže obsahovat klíčová slova: "
::msgcat::mcset $gPB(LANG) "MC(ude,editor,status_label)"                "Stav"
::msgcat::mcset $gPB(LANG) "MC(ude,editor,vector,Label)"                "Vektor"
::msgcat::mcset $gPB(LANG) "MC(ude,editor,vector,Context)"              "Přidejte nový parametr vektoru jeho přetažením do seznamu vpravo."
::msgcat::mcset $gPB(LANG) "MC(ude,editor,popup,MSG_URL_FORMAT)"        "Adresa URL musí být ve formátu \"http://*\" or \"file://*\" a nesmí obsahovat zpětné lomítko."
::msgcat::mcset $gPB(LANG) "MC(ude,editor,popup,MSG_BLANK_HELP_INFO)"   "Popis a adresa URL musí být zadány!"
::msgcat::mcset $gPB(LANG) "MC(new,MSG_NO_AXIS)"                        "Konfigurace os pro obráběcí stroj musí být vybrána."
::msgcat::mcset $gPB(LANG) "MC(machine,info,controller_type,Label)"     "Rodina řídicích systémů"
::msgcat::mcset $gPB(LANG) "MC(block,func_combo,Label)"                 "Makro"
::msgcat::mcset $gPB(LANG) "MC(block,prefix_popup,add,Label)"           "Přidat text předpony"
::msgcat::mcset $gPB(LANG) "MC(block,prefix_popup,edit,Label)"          "Přidat text přípony"
::msgcat::mcset $gPB(LANG) "MC(block,prefix,Label)"                     "Předpona"
::msgcat::mcset $gPB(LANG) "MC(block,suppress_popup,Label)"             "Vypnout číslo posloupnosti"
::msgcat::mcset $gPB(LANG) "MC(block,custom_func,Label)"                "Vlastní makro"
::msgcat::mcset $gPB(LANG) "MC(seq,combo,macro,Label)"                  "Vlastní makro"
::msgcat::mcset $gPB(LANG) "MC(func,tab,Label)"                         "Makro"
::msgcat::mcset $gPB(LANG) "MC(func,exp,msg)"                           "Výraz pro parametr makra nemůže být prázdný."
::msgcat::mcset $gPB(LANG) "MC(func,edit,name,Label)"                   "Název makra"
::msgcat::mcset $gPB(LANG) "MC(func,disp_name,Label)"                   "Výstupní název"
::msgcat::mcset $gPB(LANG) "MC(func,param_list,Label)"                  "Seznam parametrů"
::msgcat::mcset $gPB(LANG) "MC(func,separator,Label)"                   "Oddělovač"
::msgcat::mcset $gPB(LANG) "MC(func,start,Label)"                       "Počáteční znak"
::msgcat::mcset $gPB(LANG) "MC(func,end,Label)"                         "Koncový znak"
::msgcat::mcset $gPB(LANG) "MC(func,output,name,Label)"                 "Výstupní atribut"
::msgcat::mcset $gPB(LANG) "MC(func,output,check,Label)"                "Název výstupních parametrů"
::msgcat::mcset $gPB(LANG) "MC(func,output,link,Label)"                 "Znak propojení"
::msgcat::mcset $gPB(LANG) "MC(func,col_param,Label)"                   "Parametr"
::msgcat::mcset $gPB(LANG) "MC(func,col_exp,Label)"                     "Výraz"
::msgcat::mcset $gPB(LANG) "MC(func,popup,insert,Label)"                "Nový"
::msgcat::mcset $gPB(LANG) "MC(func,name,err_msg)"                      "Název makra nemůže obsahovat mezery"
::msgcat::mcset $gPB(LANG) "MC(func,name,blank_err)"                    "Název makra nemůže být prázdný!"
::msgcat::mcset $gPB(LANG) "MC(func,name,contain_err)"                  "Název makra může obsahovat pouze písmena, čísla a znak podtržítka!"
::msgcat::mcset $gPB(LANG) "MC(func,tree_node,start_err)"               "Název uzlu musí začínat velkým písmenem!"
::msgcat::mcset $gPB(LANG) "MC(func,tree_node,contain_err)"             "Název uzlu může obsahovat pouze písmena, čísla a znak podtržítka!"
::msgcat::mcset $gPB(LANG) "MC(func,help,Label)"                        "Informace"
::msgcat::mcset $gPB(LANG) "MC(func,help,Context)"                      "Zobrazí informace o objektu."
::msgcat::mcset $gPB(LANG) "MC(func,help,MSG_NO_INFO)"                  "Pro toto makro nejsou zadány žádné informace."


##------
## Title
##
::msgcat::mcset $gPB(LANG) "MC(main,title,Unigraphics)"             "Unigraphics"
::msgcat::mcset $gPB(LANG) "MC(main,title,UG)"                      "NX"
::msgcat::mcset $gPB(LANG) "MC(main,title,Post_Builder)"            "Post Builder"

::msgcat::mcset $gPB(LANG) "MC(main,title,Version)"                 "Verze"
::msgcat::mcset $gPB(LANG) "MC(main,default,Status)"                "V nabídce Soubor vyberte možnost Nový nebo Otevřít."
::msgcat::mcset $gPB(LANG) "MC(main,save,Status)"                   "Uložte postprocesor."

##------
## File
##
::msgcat::mcset $gPB(LANG) "MC(main,file,Label)"                    "Soubor"

::msgcat::mcset $gPB(LANG) "MC(main,file,Balloon)"                  "\ Nový, Otevřít, Uložit,\n Uložit\ jako, Zavřít a ukončit"

::msgcat::mcset $gPB(LANG) "MC(main,file,Context)"                  "\ Nový, Otevřít, Uložit,\n Uložit\ jako, Zavřít a ukončit"
::msgcat::mcset $gPB(LANG) "MC(main,file,menu,Context)"             " "

::msgcat::mcset $gPB(LANG) "MC(main,file,new,Label)"                "Nový ..."
::msgcat::mcset $gPB(LANG) "MC(main,file,new,Balloon)"              "Vytvoří nový postprocesor."
::msgcat::mcset $gPB(LANG) "MC(main,file,new,Context)"              "Vytvoří nový postprocesor."
::msgcat::mcset $gPB(LANG) "MC(main,file,new,Busy)"                 "Vytváření postprocesoru ..."

::msgcat::mcset $gPB(LANG) "MC(main,file,open,Label)"               "Otevřít ..."
::msgcat::mcset $gPB(LANG) "MC(main,file,open,Balloon)"             "Upraví existující postprocesor."
::msgcat::mcset $gPB(LANG) "MC(main,file,open,Context)"             "Upraví existující postprocesor."
::msgcat::mcset $gPB(LANG) "MC(main,file,open,Busy)"                "Otevírání postprocesoru ..."

::msgcat::mcset $gPB(LANG) "MC(main,file,mdfa,Label)"               "Import MDFA ..."
::msgcat::mcset $gPB(LANG) "MC(main,file,mdfa,Balloon)"             "Vytvoří nový postprocesor z MDFA."
::msgcat::mcset $gPB(LANG) "MC(main,file,mdfa,Context)"             "Vytvoří nový postprocesor z MDFA."

::msgcat::mcset $gPB(LANG) "MC(main,file,save,Label)"               "Uložit"
::msgcat::mcset $gPB(LANG) "MC(main,file,save,Balloon)"             "Uloží rozpracovaný postprocesor."
::msgcat::mcset $gPB(LANG) "MC(main,file,save,Context)"             "Uloží rozpracovaný postprocesor."
::msgcat::mcset $gPB(LANG) "MC(main,file,save,Busy)"                "Ukládání postprocesoru ..."

::msgcat::mcset $gPB(LANG) "MC(main,file,save_as,Label)"            "Uložit jako ..."
::msgcat::mcset $gPB(LANG) "MC(main,file,save_as,Balloon)"          "Uloží postprocesor pod novým názvem."
::msgcat::mcset $gPB(LANG) "MC(main,file,save_as,Context)"          "Uloží postprocesor pod novým názvem."

::msgcat::mcset $gPB(LANG) "MC(main,file,close,Label)"              "Zavřít"
::msgcat::mcset $gPB(LANG) "MC(main,file,close,Balloon)"            "Zavře rozpracovaný postprocesor."
::msgcat::mcset $gPB(LANG) "MC(main,file,close,Context)"            "Zavře rozpracovaný postprocesor."

::msgcat::mcset $gPB(LANG) "MC(main,file,exit,Label)"               "Konec"
::msgcat::mcset $gPB(LANG) "MC(main,file,exit,Balloon)"             "Ukončí aplikaci Post Builder."
::msgcat::mcset $gPB(LANG) "MC(main,file,exit,Context)"             "Ukončí aplikaci Post Builder."

::msgcat::mcset $gPB(LANG) "MC(main,file,history,Label)"            "Nedávno otevřené postprocesory"
::msgcat::mcset $gPB(LANG) "MC(main,file,history,Balloon)"          "Upraví dříve otevřený postprocesor."
::msgcat::mcset $gPB(LANG) "MC(main,file,history,Context)"          "Upraví postprocesor otevřený v dřívějších relacích aplikace Post Builder."

##---------
## Options
##
::msgcat::mcset $gPB(LANG) "MC(main,options,Label)"                 "Možnosti"

::msgcat::mcset $gPB(LANG) "MC(main,options,Balloon)"               " Ověřit\ vlastní\ příkazy, Zálohovat\ postprocesor"
::msgcat::mcset $gPB(LANG) "MC(main,options,Context)"               " "
::msgcat::mcset $gPB(LANG) "MC(main,options,menu,Context)"          " "

::msgcat::mcset $gPB(LANG) "MC(main,windows,Label)"                 "Okna"
::msgcat::mcset $gPB(LANG) "MC(main,windows,Balloon)"               "Seznam postprocesorů úprav"
::msgcat::mcset $gPB(LANG) "MC(main,windows,Context)"               " "
::msgcat::mcset $gPB(LANG) "MC(main,windows,menu,Context)"          " "

::msgcat::mcset $gPB(LANG) "MC(main,options,properties,Label)"      "Vlastnosti"
::msgcat::mcset $gPB(LANG) "MC(main,options,properties,Balloon)"    "Vlastnosti"
::msgcat::mcset $gPB(LANG) "MC(main,options,properties,Context)"    "Vlastnosti"

::msgcat::mcset $gPB(LANG) "MC(main,options,advisor,Label)"         "Poradce postprocesoru"
::msgcat::mcset $gPB(LANG) "MC(main,options,advisor,Balloon)"       "Poradce postprocesoru"
::msgcat::mcset $gPB(LANG) "MC(main,options,advisor,Context)"       "Povolit / zakázat poradce postprocesoru."

::msgcat::mcset $gPB(LANG) "MC(main,options,cmd_check,Label)"       "Ověřit vlastní příkazy"
::msgcat::mcset $gPB(LANG) "MC(main,options,cmd_check,Balloon)"     "Ověřit vlastní příkazy"
::msgcat::mcset $gPB(LANG) "MC(main,options,cmd_check,Context)"     "Přepínače pro ověření vlastních příkazů"

::msgcat::mcset $gPB(LANG) "MC(main,options,cmd_check,syntax,Label)"   "Syntaktické chyby"
::msgcat::mcset $gPB(LANG) "MC(main,options,cmd_check,command,Label)"  "Neznámé příkazy"
::msgcat::mcset $gPB(LANG) "MC(main,options,cmd_check,block,Label)"    "Neznámé bloky"
::msgcat::mcset $gPB(LANG) "MC(main,options,cmd_check,address,Label)"  "Neznámé adresy"
::msgcat::mcset $gPB(LANG) "MC(main,options,cmd_check,format,Label)"   "Neznámé formáty"

::msgcat::mcset $gPB(LANG) "MC(main,options,backup,Label)"          "Zálohovat postprocesor"
::msgcat::mcset $gPB(LANG) "MC(main,options,backup,Balloon)"        "Metoda zálohování postprocesoru"
::msgcat::mcset $gPB(LANG) "MC(main,options,backup,Context)"        "Vytvořit záložní kopie při ukládání rozpracovaného postprocesoru."

::msgcat::mcset $gPB(LANG) "MC(main,options,backup,one,Label)"      "Zálohovat originál"
::msgcat::mcset $gPB(LANG) "MC(main,options,backup,all,Label)"      "Zálohovat při každém uložení"
::msgcat::mcset $gPB(LANG) "MC(main,options,backup,none,Label)"     "Bez zálohy"

##-----------
## Utilities
##
::msgcat::mcset $gPB(LANG) "MC(main,utils,Label)"                   "Pomůcky"
::msgcat::mcset $gPB(LANG) "MC(main,utils,Balloon)"                 "\ Vybrat\ proměnnou\ MOM, Nainstalovat\ postprocesor"
::msgcat::mcset $gPB(LANG) "MC(main,utils,Context)"                 " "
::msgcat::mcset $gPB(LANG) "MC(main,utils,menu,Context)"            " "

::msgcat::mcset $gPB(LANG) "MC(main,utils,etpdf,Label)"             "Upravit datový soubor šablon postprocesorů"

::msgcat::mcset $gPB(LANG) "MC(main,utils,bmv,Label)"               "Procházet proměnné MOM"
::msgcat::mcset $gPB(LANG) "MC(main,utils,blic,Label)"              "Procházet licence"


##------
## Help
##
::msgcat::mcset $gPB(LANG) "MC(main,help,Label)"                    "Nápověda"
::msgcat::mcset $gPB(LANG) "MC(main,help,Balloon)"                  "Možnosti nápovědy"
::msgcat::mcset $gPB(LANG) "MC(main,help,Context)"                  "Možnosti nápovědy"
::msgcat::mcset $gPB(LANG) "MC(main,help,menu,Context)"             " "

::msgcat::mcset $gPB(LANG) "MC(main,help,bal,Label)"                "Bublina s popisem"
::msgcat::mcset $gPB(LANG) "MC(main,help,bal,Balloon)"              "Bublina s popisem u ikon"
::msgcat::mcset $gPB(LANG) "MC(main,help,bal,Context)"              "Zapnout / vypnout zobrazení bublin s popisem u ikon."

::msgcat::mcset $gPB(LANG) "MC(main,help,chelp,Label)"              "Kontextová nápověda"
::msgcat::mcset $gPB(LANG) "MC(main,help,chelp,Balloon)"            "Kontextová nápověda u položek dialogových oken"
::msgcat::mcset $gPB(LANG) "MC(main,help,chelp,Context)"            "Kontextová nápověda u položek dialogových oken"

::msgcat::mcset $gPB(LANG) "MC(main,help,what,Label)"               "Postup"
::msgcat::mcset $gPB(LANG) "MC(main,help,what,Balloon)"             "Možnosti"
::msgcat::mcset $gPB(LANG) "MC(main,help,what,Context)"             "Možnosti"

::msgcat::mcset $gPB(LANG) "MC(main,help,dialog,Label)"             "Nápověda k dialogovému oknu"
::msgcat::mcset $gPB(LANG) "MC(main,help,dialog,Balloon)"           "Nápověda k tomuto dialogovému oknu"
::msgcat::mcset $gPB(LANG) "MC(main,help,dialog,Context)"           "Nápověda k tomuto dialogovému oknu"

::msgcat::mcset $gPB(LANG) "MC(main,help,manual,Label)"             "Uživatelská příručka"
::msgcat::mcset $gPB(LANG) "MC(main,help,manual,Balloon)"           "Příručka uživatelské nápovědy"
::msgcat::mcset $gPB(LANG) "MC(main,help,manual,Context)"           "Příručka uživatelské nápovědy"

::msgcat::mcset $gPB(LANG) "MC(main,help,about,Label)"              "O aplikaci Post Builder"
::msgcat::mcset $gPB(LANG) "MC(main,help,about,Balloon)"            "O aplikaci Post Builder"
::msgcat::mcset $gPB(LANG) "MC(main,help,about,Context)"            "O aplikaci Post Builder"

::msgcat::mcset $gPB(LANG) "MC(main,help,rel_note,Label)"           "Poznámky k verzi"
::msgcat::mcset $gPB(LANG) "MC(main,help,rel_note,Balloon)"         "Poznámky k verzi"
::msgcat::mcset $gPB(LANG) "MC(main,help,rel_note,Context)"         "Poznámky k verzi"

::msgcat::mcset $gPB(LANG) "MC(main,help,tcl_man,Label)"            "Referenční příručky Tcl/Tk"
::msgcat::mcset $gPB(LANG) "MC(main,help,tcl_man,Balloon)"          "Referenční příručky Tcl/Tk"
::msgcat::mcset $gPB(LANG) "MC(main,help,tcl_man,Context)"          "Referenční příručky Tcl/Tk"

##----------
## Tool Bar
##
::msgcat::mcset $gPB(LANG) "MC(tool,new,Label)"                     "Nový"
::msgcat::mcset $gPB(LANG) "MC(tool,new,Context)"                   "Vytvoří nový postprocesor."

::msgcat::mcset $gPB(LANG) "MC(tool,open,Label)"                    "Otevřít"
::msgcat::mcset $gPB(LANG) "MC(tool,open,Context)"                  "Upraví existující postprocesor."

::msgcat::mcset $gPB(LANG) "MC(tool,save,Label)"                    "Uložit"
::msgcat::mcset $gPB(LANG) "MC(tool,save,Context)"                  "Uloží rozpracovaný postprocesor."

::msgcat::mcset $gPB(LANG) "MC(tool,bal,Label)"                     "Bublina s popisem"
::msgcat::mcset $gPB(LANG) "MC(tool,bal,Context)"                   "Zapnout / vypnout zobrazení bublin s popisem u ikon."

::msgcat::mcset $gPB(LANG) "MC(tool,chelp,Label)"                   "Kontextová nápověda"
::msgcat::mcset $gPB(LANG) "MC(tool,chelp,Context)"                 "Kontextová nápověda u položek dialogových oken"

::msgcat::mcset $gPB(LANG) "MC(tool,what,Label)"                    "Postup"
::msgcat::mcset $gPB(LANG) "MC(tool,what,Context)"                  "Možnosti"

::msgcat::mcset $gPB(LANG) "MC(tool,dialog,Label)"                  "Nápověda k dialogovému oknu"
::msgcat::mcset $gPB(LANG) "MC(tool,dialog,Context)"                "Nápověda k tomuto dialogovému oknu"

::msgcat::mcset $gPB(LANG) "MC(tool,manual,Label)"                  "Uživatelská příručka"
::msgcat::mcset $gPB(LANG) "MC(tool,manual,Context)"                "Příručka uživatelské nápovědy"

#=============
# Main Window
#=============

##-----------------
## Common Messages
##
::msgcat::mcset $gPB(LANG) "MC(msg,error,title)"                    "Chyba aplikace Post Builder"
::msgcat::mcset $gPB(LANG) "MC(msg,dialog,title)"                   "Zpráva aplikace Post Builder"
::msgcat::mcset $gPB(LANG) "MC(msg,warning)"                        "Upozornění"
::msgcat::mcset $gPB(LANG) "MC(msg,error)"                          "Chyba"
::msgcat::mcset $gPB(LANG) "MC(msg,invalid_data)"                   "Zapsána neplatná data pro parametr"
::msgcat::mcset $gPB(LANG) "MC(msg,invalid_browser_cmd)"            "Neplatný příkaz prohlížeče :"
::msgcat::mcset $gPB(LANG) "MC(msg,wrong_filename)"                 "Název souboru byl změněn!"
::msgcat::mcset $gPB(LANG) "MC(msg,user_ctrl_limit)"                "Licencovaný postprocesor není možné použít jako řídicí systém\n pro tvorbu nového postprocesoru, když nejste autorem!"
::msgcat::mcset $gPB(LANG) "MC(msg,import_limit)"                   "Nejste autorem tohoto licencovaného postprocesoru.\n Vlastní příkazy není možné importovat!"
::msgcat::mcset $gPB(LANG) "MC(msg,limit_msg)"                      "Nejste autorem tohoto licencovaného postprocesoru!"
::msgcat::mcset $gPB(LANG) "MC(msg,no_file)"                        "Zašifrovaný soubor tohoto licencovaného postprocesoru chybí!"
::msgcat::mcset $gPB(LANG) "MC(msg,no_license)"                     "K provedení této funkce nemáte odpovídající licenci!"
::msgcat::mcset $gPB(LANG) "MC(msg,no_license_title)"               "NX/Post Builder Bez licence"
::msgcat::mcset $gPB(LANG) "MC(msg,no_license_dialog)"              "Aplikaci NX/Post Builder je možné používat\n bez příslušné licence.  Nebudete ovšem\n moci uložit svou práci."
::msgcat::mcset $gPB(LANG) "MC(msg,pending)"                        "Služba této možnosti bude implementována v budoucí verzi."
::msgcat::mcset $gPB(LANG) "MC(msg,save)"                           "Chcete uložit změny\n před zavřením rozpracovaného postprocesoru?"
::msgcat::mcset $gPB(LANG) "MC(msg,version_check)"                  "Postprocesor vytvořený novější verzí aplikace Post Builder není možné v této verzi otevřít."

::msgcat::mcset $gPB(LANG) "MC(msg,file_corruption)"                "Obsah souboru relace aplikace Post Builder není platný."
::msgcat::mcset $gPB(LANG) "MC(msg,bad_tcl_file)"                   "Obsah souboru Tcl postprocesoru není platný."
::msgcat::mcset $gPB(LANG) "MC(msg,bad_def_file)"                   "Obsah souboru definice postprocesoru není platný."
::msgcat::mcset $gPB(LANG) "MC(msg,invalid_post)"                   "Pro postprocesor je nutné určit alespoň jednu sadu souborů Tcl a definice."
::msgcat::mcset $gPB(LANG) "MC(msg,invalid_dir)"                    "Adresář neexistuje."
::msgcat::mcset $gPB(LANG) "MC(msg,invalid_file)"                   "Soubor nebyl nalezen nebo není platný."
::msgcat::mcset $gPB(LANG) "MC(msg,invalid_def_file)"               "Není možné otevřít soubor definice"
::msgcat::mcset $gPB(LANG) "MC(msg,invalid_tcl_file)"               "Není možné otevřít soubor správce události"
::msgcat::mcset $gPB(LANG) "MC(msg,dir_perm)"                       "Nemáte oprávnění k zápisu do adresáře:"
::msgcat::mcset $gPB(LANG) "MC(msg,file_perm)"                      "Nemáte oprávnění k zápisu do"

::msgcat::mcset $gPB(LANG) "MC(msg,file_exist)"                     "již existuje! \nChcete i přesto provést nahrazení?"
::msgcat::mcset $gPB(LANG) "MC(msg,file_missing)"                   "Některé nebo všechny soubory tohoto postprocesoru chybí.\n Postprocesor není možné otevřít."
::msgcat::mcset $gPB(LANG) "MC(msg,sub_dialog_open)"                "Před uložením postprocesoru je nutné dokončit úpravy všech parametrů dílčích dialogových oken!"
::msgcat::mcset $gPB(LANG) "MC(msg,generic)"                        "Aplikace Post Builder je aktuálně implementována pouze pro obecné frézovací stroje."
::msgcat::mcset $gPB(LANG) "MC(msg,min_word)"                       "Blok musí obsahovat alespoň jedno slovo."
::msgcat::mcset $gPB(LANG) "MC(msg,name_exists)"                    "již existuje!\n Zadejte jiný název."
::msgcat::mcset $gPB(LANG) "MC(msg,in_use)"                         "Tato komponenta se momentálně používá.\n Není možné ji odstranit."
::msgcat::mcset $gPB(LANG) "MC(msg,do_you_want_to_proceed)"         "Můžete je považovat za existující datové prvky a pokračovat."
::msgcat::mcset $gPB(LANG) "MC(msg,not_installed_properly)"         "nebyla nainstalována správně."
::msgcat::mcset $gPB(LANG) "MC(msg,no_app_to_open)"                 "Žádná aplikace k otevření"
::msgcat::mcset $gPB(LANG) "MC(msg,save_change)"                    "Chcete uložit změny?"

::msgcat::mcset $gPB(LANG) "MC(msg,external_editor)"                "Externí editor"

# - Do not translate EDITOR
::msgcat::mcset $gPB(LANG) "MC(msg,set_ext_editor)"                 "Pomocí proměnné prostředí EDITOR je možné aktivovat oblíbený textový editor."
::msgcat::mcset $gPB(LANG) "MC(msg,filename_with_space)"            "Název souboru obsahující mezeru není podporován!"
::msgcat::mcset $gPB(LANG) "MC(msg,filename_protection)"            "Vybraný soubor používaný jedním z upravujících postprocesorů není možné přepsat!"


##--------------------
## Common Function
##
::msgcat::mcset $gPB(LANG) "MC(msg,parent_win)"                     "Dočasné okno vyžaduje definici nadřazeného okna."
::msgcat::mcset $gPB(LANG) "MC(msg,close_subwin)"                   "Pro povolení této karty je nutné zavřít všechna podokna."
::msgcat::mcset $gPB(LANG) "MC(msg,block_exist)"                    "Prvek vybraného slova existuje v šabloně bloku."
::msgcat::mcset $gPB(LANG) "MC(msg,num_gcode_1)"                    "Počet G – Kódy jsou omezeny na"
::msgcat::mcset $gPB(LANG) "MC(msg,num_gcode_2)"                    "na blok"
::msgcat::mcset $gPB(LANG) "MC(msg,num_mcode_1)"                    "Počet M – Kódy jsou omezeny na"
::msgcat::mcset $gPB(LANG) "MC(msg,num_mcode_2)"                    "na blok"
::msgcat::mcset $gPB(LANG) "MC(msg,empty_entry)"                    "Položka nesmí být prázdná."

::msgcat::mcset $gPB(LANG) "MC(msg,edit_feed_fmt)"                  "Formáty pro adresu \"F\" je možné upravit na stránce Parametry rychlostí posuvu"

::msgcat::mcset $gPB(LANG) "MC(msg,seq_num_max)"                    "Maximální hodnota čísla posloupnosti nesmí překračovat kapacitu N adresy"

::msgcat::mcset $gPB(LANG) "MC(msg,no_cdl_name)"                    "Název postprocesoru je nutné zadat!"
::msgcat::mcset $gPB(LANG) "MC(msg,no_def_name)"                    "Složku je nutné zadat!\n Vzor musí odpovídat \"\$UGII_*\"!"
::msgcat::mcset $gPB(LANG) "MC(msg,no_own_name)"                    "Složku je nutné zadat!\n Vzor musí odpovídat \"\$UGII_*\"!"
::msgcat::mcset $gPB(LANG) "MC(msg,no_oth_ude_name)"                "Název jiného souboru cdl je nutné zadat!\n Vzor musí odpovídat \"\$UGII_*\"!"
::msgcat::mcset $gPB(LANG) "MC(msg,not_oth_cdl_file)"               "Je povolen pouze soubor CDL!"
::msgcat::mcset $gPB(LANG) "MC(msg,not_pui_file)"                   "Je povolen pouze soubor PUI!"
::msgcat::mcset $gPB(LANG) "MC(msg,not_cdl_file)"                   "Je povolen pouze soubor CDL!"
::msgcat::mcset $gPB(LANG) "MC(msg,not_def_file)"                   "Je povolen pouze soubor DEF!"
::msgcat::mcset $gPB(LANG) "MC(msg,not_own_cdl_file)"               "Je povolen pouze vlastní soubor CDL!"
::msgcat::mcset $gPB(LANG) "MC(msg,no_cdl_file)"                    "Vybraný postprocesor nemá asociovaný soubor CDL."
::msgcat::mcset $gPB(LANG) "MC(msg,cdl_info)"                       "Soubory CDL a definice vybraného postprocesoru budou odkazovány (INCLUDE) v souboru definice tohoto postprocesoru.\n Soubor Tcl vybraného postprocesoru bude dodán také za běhu souborem ovladače události tohoto postprocesoru."

::msgcat::mcset $gPB(LANG) "MC(msg,add_max1)"                       "Maximální hodnota adresy"
::msgcat::mcset $gPB(LANG) "MC(msg,add_max2)"                       "nesmí překračovat kapacitu formátu"


::msgcat::mcset $gPB(LANG) "MC(com,text_entry_trans,title,Label)"   "Vstup"

##---------------------------
## Common Navigation Buttons
##
::msgcat::mcset $gPB(LANG) "MC(nav_button,no_license,Message)"      "K provedení této funkce nemáte odpovídající licenci!"

::msgcat::mcset $gPB(LANG) "MC(nav_button,ok,Label)"                "OK"
::msgcat::mcset $gPB(LANG) "MC(nav_button,ok,Context)"              "Toto tlačítko je dostupné pouze u dílčího dialogového okna. Umožňuje uložit změny a zavřít dialogové okno."
::msgcat::mcset $gPB(LANG) "MC(nav_button,cancel,Label)"            "Storno"
::msgcat::mcset $gPB(LANG) "MC(nav_button,cancel,Context)"          "Toto tlačítko je dostupné pouze u dílčího dialogového okna. Umožňuje zavřít dialogové okno."
::msgcat::mcset $gPB(LANG) "MC(nav_button,default,Label)"           "Výchozí nastavení"
::msgcat::mcset $gPB(LANG) "MC(nav_button,default,Context)"         "Pomocí tohoto tlačítka je možné obnovit parametry komponenty v aktuálním dialogovém okně do stavu, v jakém byly při prvním vytvoření nebo otevření postprocesoru v relaci. \n \nNázev komponenty (pokud existuje) bude obnoven pouze do počátečního stavu, v jakém se nacházel při aktuální návštěvě této komponenty."
::msgcat::mcset $gPB(LANG) "MC(nav_button,restore,Label)"           "Obnovit"
::msgcat::mcset $gPB(LANG) "MC(nav_button,restore,Context)"         "Pomocí tohoto tlačítka je možné obnovit parametry v aktuálním dialogovém okně na počáteční nastavení, v jakém se nacházely při aktuální návštěvě této komponenty."
::msgcat::mcset $gPB(LANG) "MC(nav_button,apply,Label)"             "Použít"
::msgcat::mcset $gPB(LANG) "MC(nav_button,apply,Context)"           "Pomocí tohoto tlačítka je možné uložit změny bez zavření aktuálního dialogového okna. Tím se také stanoví počáteční stav aktuálního dialogového okna. \n \n(Pro uvedení do nastavení v počátečním stavu, viz tlačítko Obnovit)"
::msgcat::mcset $gPB(LANG) "MC(nav_button,filter,Label)"            "Filtr"
::msgcat::mcset $gPB(LANG) "MC(nav_button,filter,Context)"          "Pomocí tohoto tlačítka je možné použít filtr adresářů a zobrazit seznam souborů odpovídající podmínkám."
::msgcat::mcset $gPB(LANG) "MC(nav_button,yes,Label)"               "Ano"
::msgcat::mcset $gPB(LANG) "MC(nav_button,yes,Context)"             "Ano"
::msgcat::mcset $gPB(LANG) "MC(nav_button,no,Label)"                "Ne"
::msgcat::mcset $gPB(LANG) "MC(nav_button,no,Context)"              "Ne"
::msgcat::mcset $gPB(LANG) "MC(nav_button,help,Label)"              "Nápověda"
::msgcat::mcset $gPB(LANG) "MC(nav_button,help,Context)"            "Nápověda"

::msgcat::mcset $gPB(LANG) "MC(nav_button,open,Label)"              "Otevřít"
::msgcat::mcset $gPB(LANG) "MC(nav_button,open,Context)"            "Pomocí tohoto tlačítka je možné otevřít vybraný postprocesor pro úpravy."

::msgcat::mcset $gPB(LANG) "MC(nav_button,save,Label)"              "Uložit"
::msgcat::mcset $gPB(LANG) "MC(nav_button,save,Context)"            "Toto tlačítko je dostupné v dialogovém okně Uložit jako a umožňuje uložit rozpracovaný postprocesor."

::msgcat::mcset $gPB(LANG) "MC(nav_button,manage,Label)"            "Spravovat ..."
::msgcat::mcset $gPB(LANG) "MC(nav_button,manage,Context)"          "Pomocí tohoto tlačítka je možné spravovat historii nedávno navštívených postprocesorů."

::msgcat::mcset $gPB(LANG) "MC(nav_button,refresh,Label)"           "Obnovit"
::msgcat::mcset $gPB(LANG) "MC(nav_button,refresh,Context)"         "Pomocí tohoto tlačítka je možné obnovit seznam tak, aby odpovídal existujícím objektům."

::msgcat::mcset $gPB(LANG) "MC(nav_button,cut,Label)"               "Vyjmout"
::msgcat::mcset $gPB(LANG) "MC(nav_button,cut,Context)"             "Pomocí tohoto tlačítka je možné vyjmout vybrané objekty ze seznamu."

::msgcat::mcset $gPB(LANG) "MC(nav_button,copy,Label)"              "Kopírovat"
::msgcat::mcset $gPB(LANG) "MC(nav_button,copy,Context)"            "Pomocí tohoto tlačítka je možné kopírovat vybraný objekt."

::msgcat::mcset $gPB(LANG) "MC(nav_button,paste,Label)"             "Vložit"
::msgcat::mcset $gPB(LANG) "MC(nav_button,paste,Context)"           "Pomocí tohoto tlačítka je možné vložit objekt ve vyrovnávací paměti zpět do seznamu."

::msgcat::mcset $gPB(LANG) "MC(nav_button,edit,Label)"              "Upravit"
::msgcat::mcset $gPB(LANG) "MC(nav_button,edit,Context)"            "Pomocí tohoto tlačítka je možné upravit objekt ve vyrovnávací paměti!"

::msgcat::mcset $gPB(LANG) "MC(nav_button,ex_editor,Label)"         "Použít externí editor"

##------------
## New dialog
##
::msgcat::mcset $gPB(LANG) "MC(new,title,Label)"                    "Vytvořit nový postprocesor"
::msgcat::mcset $gPB(LANG) "MC(new,Status)"                         "Zadejte název a vyberte parametr pro nový postprocesor."

::msgcat::mcset $gPB(LANG) "MC(new,name,Label)"                     "Název postprocesoru"
::msgcat::mcset $gPB(LANG) "MC(new,name,Context)"                   "Název vytvářeného postprocesoru"

::msgcat::mcset $gPB(LANG) "MC(new,desc,Label)"                     "Popis"
::msgcat::mcset $gPB(LANG) "MC(new,desc,Context)"                   "Popis vytvářeného postprocesoru"

#Description for each selection
::msgcat::mcset $gPB(LANG) "MC(new,mill,desc,Label)"                "Jedná se o frézu."
::msgcat::mcset $gPB(LANG) "MC(new,lathe,desc,Label)"               "Jedná se o soustruh."
::msgcat::mcset $gPB(LANG) "MC(new,wedm,desc,Label)"                "Jedná se o stroj pro drátořez."

::msgcat::mcset $gPB(LANG) "MC(new,wedm_2,desc,Label)"              "Jedná se o dvouosý stroj pro drátořez."
::msgcat::mcset $gPB(LANG) "MC(new,wedm_4,desc,Label)"              "Jedná se o čtyřosý stroj pro drátořez."
::msgcat::mcset $gPB(LANG) "MC(new,lathe_2,desc,Label)"             "Jedná se o dvouosý vodorovný soustruh."
::msgcat::mcset $gPB(LANG) "MC(new,lathe_4,desc,Label)"             "Jedná se o čtyřosý závislý soustruh."
::msgcat::mcset $gPB(LANG) "MC(new,mill_3,desc,Label)"              "Jedná se o tříosou frézu."
::msgcat::mcset $gPB(LANG) "MC(new,mill_3MT,desc,Label)"            "3osá fréza-soustruh (XZC)"
::msgcat::mcset $gPB(LANG) "MC(new,mill_4H,desc,Label)"             "Jedná se o čtyřosou frézu s\n otočnou hlavou."
::msgcat::mcset $gPB(LANG) "MC(new,mill_4T,desc,Label)"             "Jedná se o čtyřosou frézu s\n otočným stolem."
::msgcat::mcset $gPB(LANG) "MC(new,mill_5TT,desc,Label)"            "Jedná se o čtyřosou frézu se\n dvěma otočnými stoly."
::msgcat::mcset $gPB(LANG) "MC(new,mill_5HH,desc,Label)"            "Jedná se o čtyřosou frézu se\n dvěma otočnými hlavami."
::msgcat::mcset $gPB(LANG) "MC(new,mill_5HT,desc,Label)"            "Jedná se o čtyřosou frézu s\n otočnou hlavou a stolem."
::msgcat::mcset $gPB(LANG) "MC(new,punch,desc,Label)"               "Jedná se o stroj pro průstřih."

::msgcat::mcset $gPB(LANG) "MC(new,post_unit,Label)"                "Výstupní jednotka postprocesoru"

::msgcat::mcset $gPB(LANG) "MC(new,inch,Label)"                     "Palce"
::msgcat::mcset $gPB(LANG) "MC(new,inch,Context)"                   "Palce výstupní jednotky postprocesoru"
::msgcat::mcset $gPB(LANG) "MC(new,millimeter,Label)"               "Milimetry"
::msgcat::mcset $gPB(LANG) "MC(new,millimeter,Context)"             "Milimetry výstupní jednotky postprocesoru"

::msgcat::mcset $gPB(LANG) "MC(new,machine,Label)"                  "Obráběcí stroj"
::msgcat::mcset $gPB(LANG) "MC(new,machine,Context)"                "Typ obráběcího stroje, pro který se postprocesor vytváří."

::msgcat::mcset $gPB(LANG) "MC(new,mill,Label)"                     "Frézování"
::msgcat::mcset $gPB(LANG) "MC(new,mill,Context)"                   "Fréza"
::msgcat::mcset $gPB(LANG) "MC(new,lathe,Label)"                    "Soustružení"
::msgcat::mcset $gPB(LANG) "MC(new,lathe,Context)"                  "Soustruh"
::msgcat::mcset $gPB(LANG) "MC(new,wire,Label)"                     "Drátořez"
::msgcat::mcset $gPB(LANG) "MC(new,wire,Context)"                   "Stroj pro drátořez"
::msgcat::mcset $gPB(LANG) "MC(new,punch,Label)"                    "Průstřih"

::msgcat::mcset $gPB(LANG) "MC(new,axis,Label)"                     "Výběr os stroje"
::msgcat::mcset $gPB(LANG) "MC(new,axis,Context)"                   "Počet a typ os stroje"

#Axis Number
::msgcat::mcset $gPB(LANG) "MC(new,axis_2,Label)"                   "2osý"
::msgcat::mcset $gPB(LANG) "MC(new,axis_3,Label)"                   "3osý"
::msgcat::mcset $gPB(LANG) "MC(new,axis_4,Label)"                   "4osý"
::msgcat::mcset $gPB(LANG) "MC(new,axis_5,Label)"                   "5osý"
::msgcat::mcset $gPB(LANG) "MC(new,axis_XZC,Label)"                 "XZC"


#Axis Type
::msgcat::mcset $gPB(LANG) "MC(new,mach_axis,Label)"                "Osa obráběcího stroje"
::msgcat::mcset $gPB(LANG) "MC(new,mach_axis,Context)"              "Vybrat osu obráběcího stroje"
::msgcat::mcset $gPB(LANG) "MC(new,lathe_2,Label)"                  "2osý"
::msgcat::mcset $gPB(LANG) "MC(new,mill_3,Label)"                   "3osý"
::msgcat::mcset $gPB(LANG) "MC(new,mill_3MT,Label)"                 "3osá fréza-soustruh (XZC)"
::msgcat::mcset $gPB(LANG) "MC(new,mill_4T,Label)"                  "4osý s otočným stolem"
::msgcat::mcset $gPB(LANG) "MC(new,mill_4H,Label)"                  "4osý s otočnou hlavou"
::msgcat::mcset $gPB(LANG) "MC(new,lathe_4,Label)"                  "4osý"
::msgcat::mcset $gPB(LANG) "MC(new,mill_5HH,Label)"                 "5osý s dvěma otočnými hlavami"
::msgcat::mcset $gPB(LANG) "MC(new,mill_5TT,Label)"                 "5osý s dvěma otočnými stoly"
::msgcat::mcset $gPB(LANG) "MC(new,mill_5HT,Label)"                 "5osý s otočnou hlavou a stolem"
::msgcat::mcset $gPB(LANG) "MC(new,wedm_2,Label)"                   "2osý"
::msgcat::mcset $gPB(LANG) "MC(new,wedm_4,Label)"                   "4osý"
::msgcat::mcset $gPB(LANG) "MC(new,punch,Label)"                    "Průstřih"

::msgcat::mcset $gPB(LANG) "MC(new,control,Label)"                  "Řídící systém"
::msgcat::mcset $gPB(LANG) "MC(new,control,Context)"                "Vybrat řídicí systém postprocesoru."

#Controller Type
::msgcat::mcset $gPB(LANG) "MC(new,generic,Label)"                  "Obecné"
::msgcat::mcset $gPB(LANG) "MC(new,library,Label)"                  "Knihovna"
::msgcat::mcset $gPB(LANG) "MC(new,user,Label)"                     "Uživatelský"
::msgcat::mcset $gPB(LANG) "MC(new,user,browse,Label)"              "Procházet"

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
::msgcat::mcset $gPB(LANG) "MC(open,title,Label)"                   "Upravit postprocesor"
::msgcat::mcset $gPB(LANG) "MC(open,Status)"                        "Vyberte soubor PUI k otevření."
::msgcat::mcset $gPB(LANG) "MC(open,file_type_pui)"                 "Soubory relace aplikace Post Builder"
::msgcat::mcset $gPB(LANG) "MC(open,file_type_tcl)"                 "Soubory skriptu Tcl"
::msgcat::mcset $gPB(LANG) "MC(open,file_type_def)"                 "Soubory definice"
::msgcat::mcset $gPB(LANG) "MC(open,file_type_cdl)"                 "Soubory CDL"

##-------------
## Misc dialog
##
::msgcat::mcset $gPB(LANG) "MC(open_save,dlg,title,Label)"          "Vyberte soubor"
::msgcat::mcset $gPB(LANG) "MC(exp_cc,dlg,title,Label)"             "Export vlastních příkazů"
::msgcat::mcset $gPB(LANG) "MC(show_mt,title,Label)"                "Obráběcí stroj"

##----------------
## Utils dialog
##
::msgcat::mcset $gPB(LANG) "MC(mvb,title,Label)"                    "Prohlížeč proměnných MOM"
::msgcat::mcset $gPB(LANG) "MC(mvb,cat,Label)"                      "Kategorie"
::msgcat::mcset $gPB(LANG) "MC(mvb,search,Label)"                   "Hledat"
::msgcat::mcset $gPB(LANG) "MC(mvb,defv,Label)"                     "Výchozí hodnota"
::msgcat::mcset $gPB(LANG) "MC(mvb,posv,Label)"                     "Možné hodnoty"
::msgcat::mcset $gPB(LANG) "MC(mvb,data,Label)"                     "Datový typ"
::msgcat::mcset $gPB(LANG) "MC(mvb,desc,Label)"                     "Popis"

::msgcat::mcset $gPB(LANG) "MC(inposts,title,Label)"                "Upravit soubor template_post.dat"
::msgcat::mcset $gPB(LANG) "MC(tpdf,text,Label)"                    "Datový soubor šablon postprocesorů"
::msgcat::mcset $gPB(LANG) "MC(inposts,edit,title,Label)"           "Upravit řádek"
::msgcat::mcset $gPB(LANG) "MC(inposts,edit,post,Label)"            "Postprocesor"


##----------------
## Save As dialog
##
::msgcat::mcset $gPB(LANG) "MC(save_as,title,Label)"                "Uložit jako"
::msgcat::mcset $gPB(LANG) "MC(save_as,name,Label)"                 "Název postprocesoru"
::msgcat::mcset $gPB(LANG) "MC(save_as,name,Context)"               "Název, pod kterým bude postprocesor uložen."
::msgcat::mcset $gPB(LANG) "MC(save_as,Status)"                     "Zadejte nový název souboru postprocesoru."
::msgcat::mcset $gPB(LANG) "MC(save_as,file_type_pui)"              "Soubory relace aplikace Post Builder"

##----------------
## Common Widgets
##
::msgcat::mcset $gPB(LANG) "MC(common,entry,Label)"                 "Vstup"
::msgcat::mcset $gPB(LANG) "MC(common,entry,Context)"               "Zadáte novou hodnotu do vstupního pole."

##-----------
## Note Book
##
::msgcat::mcset $gPB(LANG) "MC(nbook,tab,Label)"                    "Karta Poznámkový blok"
::msgcat::mcset $gPB(LANG) "MC(nbook,tab,Context)"                  "Pro přechod na stránku požadovaného parametru je možné vybrat kartu. \n \nParametry na kartě mohou být rozděleny do skupin. Ke každé skupině parametrů je možné získat přístup pomocí další karty."

##------
## Tree
##
::msgcat::mcset $gPB(LANG) "MC(tree,select,Label)"                  "Strom komponent"
::msgcat::mcset $gPB(LANG) "MC(tree,select,Context)"                "Můžete vybrat komponentu, jejíž obsah nebo parametry chcete zobrazit nebo upravit."
::msgcat::mcset $gPB(LANG) "MC(tree,create,Label)"                  "Vytvořit"
::msgcat::mcset $gPB(LANG) "MC(tree,create,Context)"                "Vytvoří novou komponentu zkopírováním vybrané položky."
::msgcat::mcset $gPB(LANG) "MC(tree,cut,Label)"                     "Vyjmout"
::msgcat::mcset $gPB(LANG) "MC(tree,cut,Context)"                   "Vyjme komponentu."
::msgcat::mcset $gPB(LANG) "MC(tree,paste,Label)"                   "Vložit"
::msgcat::mcset $gPB(LANG) "MC(tree,paste,Context)"                 "Vloží komponentu."
::msgcat::mcset $gPB(LANG) "MC(tree,rename,Label)"                  "Přejmenovat"

##------------------
## Encrypt dialogs
##
::msgcat::mcset $gPB(LANG) "MC(encrypt,browser,Label)"              "Seznam licencí"
::msgcat::mcset $gPB(LANG) "MC(encrypt,title,Label)"                "Vybrat licenci"
::msgcat::mcset $gPB(LANG) "MC(encrypt,output,Label)"               "Šifrovat výstup"
::msgcat::mcset $gPB(LANG) "MC(encrypt,license,Label)"              "Licence :  "

#++++++++++++++
# Machine Tool
#++++++++++++++
::msgcat::mcset $gPB(LANG) "MC(machine,tab,Label)"                  "Obráběcí stroj"
::msgcat::mcset $gPB(LANG) "MC(machine,Status)"                     "Určit parametry kinematiky stroje."

::msgcat::mcset $gPB(LANG) "MC(msg,no_display)"                     "Obraz pro tuto konfiguraci obráběcího stroje není dostupný."
::msgcat::mcset $gPB(LANG) "MC(msg,no_4th_ctable)"                  "Stůl C čtvrté osy není povolen."
::msgcat::mcset $gPB(LANG) "MC(msg,no_4th_max_min)"                 "Maximální mez čtvrté osy nemůže být rovna minimální mezi!"
::msgcat::mcset $gPB(LANG) "MC(msg,no_4th_both_neg)"                "Meze čtvrté osy nemohou být obě záporné!"
::msgcat::mcset $gPB(LANG) "MC(msg,no_4th_5th_plane)"               "Rovina čtvrté osy nemůže být stejná jako rovina páté osy."
::msgcat::mcset $gPB(LANG) "MC(msg,no_4thT_5thH)"                   "Stůl čtvrté osy a hlava páté osy nejsou povoleny."
::msgcat::mcset $gPB(LANG) "MC(msg,no_5th_max_min)"                 "Maximální mez páté osy nemůže být rovna minimální mezi!"
::msgcat::mcset $gPB(LANG) "MC(msg,no_5th_both_neg)"                "Meze páté osy nemohou být obě záporné."

##---------
# Post Info
##
::msgcat::mcset $gPB(LANG) "MC(machine,info,title,Label)"           "Informace o postprocesoru"
::msgcat::mcset $gPB(LANG) "MC(machine,info,desc,Label)"            "Popis"
::msgcat::mcset $gPB(LANG) "MC(machine,info,type,Label)"            "Typ stroje"
::msgcat::mcset $gPB(LANG) "MC(machine,info,kinematics,Label)"      "Kinematika"
::msgcat::mcset $gPB(LANG) "MC(machine,info,unit,Label)"            "Výstupní jednotka"
::msgcat::mcset $gPB(LANG) "MC(machine,info,controller,Label)"      "Řídící systém"
::msgcat::mcset $gPB(LANG) "MC(machine,info,history,Label)"         "Historie"

##---------
## Display
##
::msgcat::mcset $gPB(LANG) "MC(machine,display,Label)"              "Zobrazit obráběcí stroj"
::msgcat::mcset $gPB(LANG) "MC(machine,display,Context)"            "Pomocí této možnosti je možné zobrazit obráběcí stroj"
::msgcat::mcset $gPB(LANG) "MC(machine,display_trans,title,Label)"  "Obráběcí stroj"


##---------------
## General parms
##
::msgcat::mcset $gPB(LANG) "MC(machine,gen,Label)"                      "Obecné parametry"
    
::msgcat::mcset $gPB(LANG) "MC(machine,gen,out_unit,Label)"             "Výstupní jednotka postprocesoru :"
::msgcat::mcset $gPB(LANG) "MC(machine,gen,out_unit,Context)"           "Výstupní jednotka postprocesingu"
::msgcat::mcset $gPB(LANG) "MC(machine,gen,out_unit,inch,Label)"        "Palec" 
::msgcat::mcset $gPB(LANG) "MC(machine,gen,out_unit,metric,Label)"      "Metrické"

::msgcat::mcset $gPB(LANG) "MC(machine,gen,travel_limit,Label)"         "Meze pohybu lineární osy"
::msgcat::mcset $gPB(LANG) "MC(machine,gen,travel_limit,Context)"       "Meze pohybu lineární osy"
::msgcat::mcset $gPB(LANG) "MC(machine,gen,travel_limit,x,Label)"       "X"
::msgcat::mcset $gPB(LANG) "MC(machine,gen,travel_limit,x,Context)"     "Určuje mez pohybu stroje ve směru osy X."
::msgcat::mcset $gPB(LANG) "MC(machine,gen,travel_limit,y,Label)"       "Y"
::msgcat::mcset $gPB(LANG) "MC(machine,gen,travel_limit,y,Context)"     "Určuje mez pohybu stroje ve směru osy Y."
::msgcat::mcset $gPB(LANG) "MC(machine,gen,travel_limit,z,Label)"       "Z"
::msgcat::mcset $gPB(LANG) "MC(machine,gen,travel_limit,z,Context)"     "Určuje mez pohybu stroje ve směru osy Z."

::msgcat::mcset $gPB(LANG) "MC(machine,gen,home_pos,Label)"             "Konečná pozice"
::msgcat::mcset $gPB(LANG) "MC(machine,gen,home_pos,Context)"           "Konečná pozice"
::msgcat::mcset $gPB(LANG) "MC(machine,gen,home_pos,x,Label)"           "X"
::msgcat::mcset $gPB(LANG) "MC(machine,gen,home_pos,x,Context)"         "Konečná pozice osy X stroje s ohledem na fyzickou pozici nulové souřadnice osy.  Stroj se do této pozice vrací kvůli automatické změně nástroje."
::msgcat::mcset $gPB(LANG) "MC(machine,gen,home_pos,y,Label)"           "Y"
::msgcat::mcset $gPB(LANG) "MC(machine,gen,home_pos,y,Context)"         "Konečná pozice osy Y stroje s ohledem na fyzickou pozici nulové souřadnice osy.  Stroj se do této pozice vrací kvůli automatické změně nástroje."
::msgcat::mcset $gPB(LANG) "MC(machine,gen,home_pos,z,Label)"           "Z"
::msgcat::mcset $gPB(LANG) "MC(machine,gen,home_pos,z,Context)"         "Konečná pozice osy Z stroje s ohledem na fyzickou pozici nulové souřadnice osy.  Stroj se do této pozice vrací kvůli automatické změně nástroje."

::msgcat::mcset $gPB(LANG) "MC(machine,gen,step_size,Label)"            "Rozlišení lineárního pohybu"
::msgcat::mcset $gPB(LANG) "MC(machine,gen,step_size,min,Label)"        "Minimum"
::msgcat::mcset $gPB(LANG) "MC(machine,gen,step_size,min,Context)"      "Minimální rozlišení"

::msgcat::mcset $gPB(LANG) "MC(machine,gen,traverse_feed,Label)"        "Rychlost posuvu přejezdu"
::msgcat::mcset $gPB(LANG) "MC(machine,gen,traverse_feed,max,Label)"    "Maximum"
::msgcat::mcset $gPB(LANG) "MC(machine,gen,traverse_feed,max,Context)"  "Maximální rychlost posuvu"

::msgcat::mcset $gPB(LANG) "MC(machine,gen,circle_record,Label)"        "Výstupní kruhový záznam"
::msgcat::mcset $gPB(LANG) "MC(machine,gen,circle_record,yes,Label)"    "Ano"
::msgcat::mcset $gPB(LANG) "MC(machine,gen,circle_record,yes,Context)"  "Výstupní kruhový záznam"
::msgcat::mcset $gPB(LANG) "MC(machine,gen,circle_record,no,Label)"     "Ne"
::msgcat::mcset $gPB(LANG) "MC(machine,gen,circle_record,no,Context)"   "Výstupní lineární záznam"

::msgcat::mcset $gPB(LANG) "MC(machine,gen,config_4and5_axis,oth,Label)"    "Jiný"

# Wire EDM parameters
::msgcat::mcset $gPB(LANG) "MC(machine,gen,wedm,wire_tilt)"             "Řízení naklopení drátů"
::msgcat::mcset $gPB(LANG) "MC(machine,gen,wedm,angle)"                 "Úhly"
::msgcat::mcset $gPB(LANG) "MC(machine,gen,wedm,coord)"                 "Souřadnice"

# Lathe parameters
::msgcat::mcset $gPB(LANG) "MC(machine,gen,turret,Label)"               "Nožová hlava"
::msgcat::mcset $gPB(LANG) "MC(machine,gen,turret,Context)"             "Nožová hlava"
::msgcat::mcset $gPB(LANG) "MC(machine,gen,turret,conf,Label)"          "Konfigurovat"
::msgcat::mcset $gPB(LANG) "MC(machine,gen,turret,conf,Context)"        "Když jsou vybrány dvě nožové hlavy, pomocí této možnosti je možné konfigurovat parametry."
::msgcat::mcset $gPB(LANG) "MC(machine,gen,turret,one,Label)"           "Jedna nožová hlava"
::msgcat::mcset $gPB(LANG) "MC(machine,gen,turret,one,Context)"         "Soustruh s jednou nožovou hlavou"
::msgcat::mcset $gPB(LANG) "MC(machine,gen,turret,two,Label)"           "Dvě nožové hlavy"
::msgcat::mcset $gPB(LANG) "MC(machine,gen,turret,two,Context)"         "Soustruh se dvěma nožovými hlavami"

::msgcat::mcset $gPB(LANG) "MC(machine,gen,turret,conf_trans,Label)"    "Konfigurace nožové hlavy"
::msgcat::mcset $gPB(LANG) "MC(machine,gen,turret,prim,Label)"          "Primární nožová hlava"
::msgcat::mcset $gPB(LANG) "MC(machine,gen,turret,prim,Context)"        "Umožňuje vybrat označení primární nožové hlavy."
::msgcat::mcset $gPB(LANG) "MC(machine,gen,turret,sec,Label)"           "Sekundární nožová hlava"
::msgcat::mcset $gPB(LANG) "MC(machine,gen,turret,sec,Context)"         "Umožňuje vybrat označení sekundární nožové hlavy."
::msgcat::mcset $gPB(LANG) "MC(machine,gen,turret,designation,Label)"   "Označení"
::msgcat::mcset $gPB(LANG) "MC(machine,gen,turret,xoff,Label)"          "Odsazení X"
::msgcat::mcset $gPB(LANG) "MC(machine,gen,turret,xoff,Context)"        "Určuje odsazení X."
::msgcat::mcset $gPB(LANG) "MC(machine,gen,turret,zoff,Label)"          "Odsazení Z"
::msgcat::mcset $gPB(LANG) "MC(machine,gen,turret,zoff,Context)"        "Určuje odsazení Z."

::msgcat::mcset $gPB(LANG) "MC(machine,gen,turret,front,Label)"         "PŘEDNÍ"
::msgcat::mcset $gPB(LANG) "MC(machine,gen,turret,rear,Label)"          "ZADNÍ"
::msgcat::mcset $gPB(LANG) "MC(machine,gen,turret,right,Label)"         "PRAVÝ"
::msgcat::mcset $gPB(LANG) "MC(machine,gen,turret,left,Label)"          "LEVÝ"
::msgcat::mcset $gPB(LANG) "MC(machine,gen,turret,side,Label)"          "STRANA"
::msgcat::mcset $gPB(LANG) "MC(machine,gen,turret,saddle,Label)"        "SADDLE"

::msgcat::mcset $gPB(LANG) "MC(machine,gen,axis_multi,Label)"           "Násobiče osy"
::msgcat::mcset $gPB(LANG) "MC(machine,gen,axis_multi,dia,Label)"       "Programování průměru"
::msgcat::mcset $gPB(LANG) "MC(machine,gen,axis_multi,dia,Context)"     "Pomocí těchto možností je možné povolit programování průměru zdvojnásobením hodnot vybraných adres ve výstupu N/C."
::msgcat::mcset $gPB(LANG) "MC(machine,gen,axis_multi,2x,Label)"        "2X"
::msgcat::mcset $gPB(LANG) "MC(machine,gen,axis_multi,2x,Context)"      "Pomocí tohoto přepínače je možné povolit programování průměru zdvojnásobením souřadnic osy X ve výstupu N/C."

::msgcat::mcset $gPB(LANG) "MC(machine,gen,axis_multi,2y,Label)"        "2Y"
::msgcat::mcset $gPB(LANG) "MC(machine,gen,axis_multi,2y,Context)"      "Pomocí tohoto přepínače je možné povolit programování průměru zdvojnásobením souřadnic osy Y ve výstupu N/C."
::msgcat::mcset $gPB(LANG) "MC(machine,gen,axis_multi,2i,Label)"        "2I"
::msgcat::mcset $gPB(LANG) "MC(machine,gen,axis_multi,2i,Context)"      "Pomocí tohoto přepínače je možné zdvojnásobit hodnoty I kruhových záznamů, když se používá programování průměru."
::msgcat::mcset $gPB(LANG) "MC(machine,gen,axis_multi,2j,Label)"        "2J"
::msgcat::mcset $gPB(LANG) "MC(machine,gen,axis_multi,2j,Context)"      "Pomocí tohoto přepínače je možné zdvojnásobit hodnoty J kruhových záznamů, když se používá programování průměru."

::msgcat::mcset $gPB(LANG) "MC(machine,gen,axis_multi,mir,Label)"       "Zrcadlit výstup"
::msgcat::mcset $gPB(LANG) "MC(machine,gen,axis_multi,mir,Context)"     "Pomocí těchto možností je možné zrcadlit vybrané adresy negací jejich hodnot ve výstupu N/C."
::msgcat::mcset $gPB(LANG) "MC(machine,gen,axis_multi,x,Label)"         "-X"
::msgcat::mcset $gPB(LANG) "MC(machine,gen,axis_multi,x,Context)"       "Pomocí tohoto přepínače je možné negovat souřadnice osy X ve výstupu N/C."
::msgcat::mcset $gPB(LANG) "MC(machine,gen,axis_multi,y,Label)"         "-Y"
::msgcat::mcset $gPB(LANG) "MC(machine,gen,axis_multi,y,Context)"       "Pomocí tohoto přepínače je možné negovat souřadnice osy Y ve výstupu N/C."
::msgcat::mcset $gPB(LANG) "MC(machine,gen,axis_multi,z,Label)"         "-Z"
::msgcat::mcset $gPB(LANG) "MC(machine,gen,axis_multi,z,Context)"       "Pomocí tohoto přepínače je možné negovat souřadnice osy Z ve výstupu N/C."
::msgcat::mcset $gPB(LANG) "MC(machine,gen,axis_multi,i,Label)"         "-l"
::msgcat::mcset $gPB(LANG) "MC(machine,gen,axis_multi,i,Context)"       "Pomocí tohoto přepínače je možné negovat hodnoty I kruhových záznamů ve výstupu N/C."
::msgcat::mcset $gPB(LANG) "MC(machine,gen,axis_multi,j,Label)"         "-J"
::msgcat::mcset $gPB(LANG) "MC(machine,gen,axis_multi,j,Context)"       "Pomocí tohoto přepínače je možné negovat hodnoty J kruhových záznamů ve výstupu N/C."
::msgcat::mcset $gPB(LANG) "MC(machine,gen,axis_multi,k,Label)"         "-K"
::msgcat::mcset $gPB(LANG) "MC(machine,gen,axis_multi,k,Context)"       "Pomocí tohoto přepínače je možné negovat hodnoty K kruhových záznamů ve výstupu N/C."

::msgcat::mcset $gPB(LANG) "MC(machine,gen,output,Label)"               "Metoda výstupu"
::msgcat::mcset $gPB(LANG) "MC(machine,gen,output,Context)"             "Metoda výstupu"
::msgcat::mcset $gPB(LANG) "MC(machine,gen,output,tool_tip,Label)"      "Špička nástroje"
::msgcat::mcset $gPB(LANG) "MC(machine,gen,output,tool_tip,Context)"    "Výstup s ohledem na špičku nástroje"
::msgcat::mcset $gPB(LANG) "MC(machine,gen,output,turret_ref,Label)"    "Reference nožové hlavy"
::msgcat::mcset $gPB(LANG) "MC(machine,gen,output,turret_ref,Context)"  "Výstup s ohledem na referenci nožové hlavy"

::msgcat::mcset $gPB(LANG) "MC(machine,gen,lathe_turret,msg)"           "Označení primární nožové hlavy nemůže být stejné jako označení sekundární nožové hlavy."
::msgcat::mcset $gPB(LANG) "MC(machine,gen,turret_chg,msg)"             "Ke změně této možnosti může být potřeba přidat nebo odstranit blok G92 v událostech Změna nástroje."
# Entries for XZC/Mill-Turn
::msgcat::mcset $gPB(LANG) "MC(machine,gen,spindle_axis,Label)"             "Počáteční osa vřetena"
::msgcat::mcset $gPB(LANG) "MC(machine,gen,spindle_axis,Context)"           "Počáteční osa vřetena označenou pro aktivní nástroj frézování je možné určit buď jako rovnoběžnou s osou Z, nebo kolmou s osou Z.  Osa nástroje operace musí být s určenou osou vřetena konzistentní.  Pokud se postprocesoru nepodaří umístit určenou osu vřetena, zobrazí se chyba. \nTento vektor je možné přepsat osou vřetena určenou s objektem hlavy."

::msgcat::mcset $gPB(LANG) "MC(machine,gen,position_in_yaxis,Label)"        "Pozice na ose Y"
::msgcat::mcset $gPB(LANG) "MC(machine,gen,position_in_yaxis,Context)"      "Stroj má programovatelnou osu Y, po které se může během konturování pohybovat.  Tuto možnost je možné použít pouze, pokud není osa vřetena ve směru osy Z."

::msgcat::mcset $gPB(LANG) "MC(machine,gen,mach_mode,Label)"                "Režim stroje"
::msgcat::mcset $gPB(LANG) "MC(machine,gen,mach_mode,Context)"              "Režim stroje může být buď Fréza XZC, nebo Jednoduchá fréza-soustruh."

::msgcat::mcset $gPB(LANG) "MC(machine,gen,mach_mode,xzc_mill,Label)"       "Fréza XZC"
::msgcat::mcset $gPB(LANG) "MC(machine,gen,mach_mode,xzc_mill,Context)"     "Fréza XZC bude mít stůl nebo stěnu sklíčidla uzamknutu na stroji fréza-soustruh jakožto otočnou osu C.  Všechny pohyby ve směru XY budou převedeny na X a C, kde X značí hodnotu poloměru a C značí úhel."

::msgcat::mcset $gPB(LANG) "MC(machine,gen,mach_mode,mill_turn,Label)"      "Jednoduchá fréza-soustruh"
::msgcat::mcset $gPB(LANG) "MC(machine,gen,mach_mode,mill_turn,Context)"    "Postprocesor frézy XZC bude propojen s postprocesorem soustružení tak, aby zpracoval program obsahující operace frézování i soustružení.  Typ operace určí, jaký postprocesor se má při tvorbě výstupů N/C použít."

::msgcat::mcset $gPB(LANG) "MC(machine,gen,mill_turn,lathe_post,Label)"     "Postprocesor soustružení"
::msgcat::mcset $gPB(LANG) "MC(machine,gen,mill_turn,lathe_post,Context)"   "Postprocesor soustružení je vyžadován u jednoduché frézy-soustruh k postprocesingu operací soustružení v programu."

::msgcat::mcset $gPB(LANG) "MC(machine,gen,lathe_post,select_name,Label)"   "Vybrat název"
::msgcat::mcset $gPB(LANG) "MC(machine,gen,lathe_post,select_name,Context)" "Umožňuje vybrat název postprocesoru soustružení, který se použije v postprocesoru jednoduché frézy-soustruh.  Tento postprocesor se bude pravděpodobně nacházet v adresáři \\\$UGII_CAM_POST_DIR během provozu NX/postprocesoru, v opačném případě bude použit postprocesor se stejným názvem v adresáři, ve kterém se nachází postprocesor frézování."

::msgcat::mcset $gPB(LANG) "MC(machine,gen,coord_mode,Label)"               "Výchozí režim souřadnic"
::msgcat::mcset $gPB(LANG) "MC(machine,gen,coord_mode,Context)"             "Tato možnost určuje, zda bude počáteční nastavení výstupního režimu souřadnic Polární (XZC) nebo Kartézské (XYZ).  Tento režim je možné upravit pomocí UDE \\\"SET/POLAR,ON\\\" naprogramovanými s operacemi."

::msgcat::mcset $gPB(LANG) "MC(machine,gen,coord_mode,polar,Label)"         "Polární"
::msgcat::mcset $gPB(LANG) "MC(machine,gen,coord_mode,polar,Context)"       "Souřadnicový výstup v XZC."

::msgcat::mcset $gPB(LANG) "MC(machine,gen,coord_mode,cart,Label)"          "Kartézské"
::msgcat::mcset $gPB(LANG) "MC(machine,gen,coord_mode,cart,Context)"        "Souřadnicový výstup v XYZ."

::msgcat::mcset $gPB(LANG) "MC(machine,gen,xzc_arc_mode,Label)"             "Režim kruhového záznamu"
::msgcat::mcset $gPB(LANG) "MC(machine,gen,xzc_arc_mode,Context)"           "Tato možnost určuje, zda bude režim výstupu kruhových záznamů Polární (XCR) nebo Kartézský (XYIJ)."

::msgcat::mcset $gPB(LANG) "MC(machine,gen,xzc_arc_mode,polar,Label)"       "Polární"
::msgcat::mcset $gPB(LANG) "MC(machine,gen,xzc_arc_mode,polar,Context)"     "Kruhový výstup v XCR."

::msgcat::mcset $gPB(LANG) "MC(machine,gen,xzc_arc_mode,cart,Label)"        "Kartézské"
::msgcat::mcset $gPB(LANG) "MC(machine,gen,xzc_arc_mode,cart,Context)"      "Kruhový výstup v XYIJ."

::msgcat::mcset $gPB(LANG) "MC(machine,gen,def_spindle_axis,Label)"         "Výchozí osa vřetena"
::msgcat::mcset $gPB(LANG) "MC(machine,gen,def_spindle_axis,Context)"       "Výchozí osa vřetena může být přepsána osou vřetena určenou v objektu hlavy. \nVektor není nutné sjednotit."


##-----------------
## 4-th Axis parms
##
::msgcat::mcset $gPB(LANG) "MC(machine,axis,fourth,Label)"              "Čtvrtá osa"

::msgcat::mcset $gPB(LANG) "MC(machine,axis,radius_output,Label)"       "Výstup poloměru"
::msgcat::mcset $gPB(LANG) "MC(machine,axis,radius_output,Context)"     "Když je osa nástroje ve směru osy Z (0,0,1), postprocesor si může vybrat, zda bude výstup poloměru (X) polárních souřadnic \\\"Vždy kladný\\\", \\\"Vždy záporný\\\" nebo \\\"Nejkratší vzdálenost\\\"."

::msgcat::mcset $gPB(LANG) "MC(machine,axis,type_head,Label)"           "Hlava"
::msgcat::mcset $gPB(LANG) "MC(machine,axis,type_table,Label)"          "Tabulka"

##-----------------
## 5-th Axis parms
##
::msgcat::mcset $gPB(LANG) "MC(machine,axis,fifth,Label)"               "Pátá osa"

::msgcat::mcset $gPB(LANG) "MC(machine,axis,rotary,Label)"              "Osa otáčení"

::msgcat::mcset $gPB(LANG) "MC(machine,axis,offset,Label)"              "Nula stroje ke středu osy otáčení"
::msgcat::mcset $gPB(LANG) "MC(machine,axis,offset,4,Label)"            "Nula stroje ke středu čtvrté osy"
::msgcat::mcset $gPB(LANG) "MC(machine,axis,offset,5,Label)"            "Střed čtvrté osy ke středu páté osy"
::msgcat::mcset $gPB(LANG) "MC(machine,axis,offset,x,Label)"            "Odsazení X"
::msgcat::mcset $gPB(LANG) "MC(machine,axis,offset,x,Context)"          "Určuje odsazení X osy otáčení."
::msgcat::mcset $gPB(LANG) "MC(machine,axis,offset,y,Label)"            "Odsazení Y"
::msgcat::mcset $gPB(LANG) "MC(machine,axis,offset,y,Context)"          "Určuje odsazení Y osy otáčení."
::msgcat::mcset $gPB(LANG) "MC(machine,axis,offset,z,Label)"            "Odsazení Z"
::msgcat::mcset $gPB(LANG) "MC(machine,axis,offset,z,Context)"          "Určuje odsazení Z osy otáčení."

::msgcat::mcset $gPB(LANG) "MC(machine,axis,rotation,Label)"            "Otočení osy"
::msgcat::mcset $gPB(LANG) "MC(machine,axis,rotation,norm,Label)"       "Normální"
::msgcat::mcset $gPB(LANG) "MC(machine,axis,rotation,norm,Context)"     "Umožňuje nastavit směr otočení osy na Normální."
::msgcat::mcset $gPB(LANG) "MC(machine,axis,rotation,rev,Label)"        "Obrácená"
::msgcat::mcset $gPB(LANG) "MC(machine,axis,rotation,rev,Context)"      "Umožňuje nastavit směr otočení osy na Obrácená."

::msgcat::mcset $gPB(LANG) "MC(machine,axis,direction,Label)"           "Směr osy"
::msgcat::mcset $gPB(LANG) "MC(machine,axis,direction,Context)"         "Umožňuje výběr směru osy."

::msgcat::mcset $gPB(LANG) "MC(machine,axis,con_motion,Label)"              "Po sobě jdoucí otočné pohyby"
::msgcat::mcset $gPB(LANG) "MC(machine,axis,con_motion,combine,Label)"      "Kombinované"
::msgcat::mcset $gPB(LANG) "MC(machine,axis,con_motion,combine,Context)"    "Pomocí tohoto přepínače je možné povolit nebo zakázat linearizaci. Tím se povolí nebo zakáže možnost Tolerance."
::msgcat::mcset $gPB(LANG) "MC(machine,axis,con_motion,tol,Label)"      "Tolerance"
::msgcat::mcset $gPB(LANG) "MC(machine,axis,con_motion,tol,Context)"    "Tato možnost je aktivní pouze pokud je aktivní přepínač Kombinované. Umožňuje určit toleranci."

::msgcat::mcset $gPB(LANG) "MC(machine,axis,violation,Label)"           "Zpracování porušení meze osy"
::msgcat::mcset $gPB(LANG) "MC(machine,axis,violation,warn,Label)"      "Upozornění"
::msgcat::mcset $gPB(LANG) "MC(machine,axis,violation,warn,Context)"    "Zobrazí upozornění při porušení mezí os."
::msgcat::mcset $gPB(LANG) "MC(machine,axis,violation,ret,Label)"       "Odjezd / Opakovaný nájezd"
::msgcat::mcset $gPB(LANG) "MC(machine,axis,violation,ret,Context)"     "Provést odjezd nebo opakovaný nájezd při porušení meze osy. \n \nVe vlastním příkazu PB_CMD_init_rotaty je možné úpravou následujících parametru dosáhnout požadovaných pohybů: \n \n   mom_kin_retract_type \n   mom_kin_retract_distance \n   mom_kin_reengage_distance"

::msgcat::mcset $gPB(LANG) "MC(machine,axis,limits,Label)"              "Meze osy (St)"
::msgcat::mcset $gPB(LANG) "MC(machine,axis,limits,min,Label)"          "Minimum"
::msgcat::mcset $gPB(LANG) "MC(machine,axis,limits,min,Context)"        "Určuje minimální mez osy otáčení (St)."
::msgcat::mcset $gPB(LANG) "MC(machine,axis,limits,max,Label)"          "Maximum"
::msgcat::mcset $gPB(LANG) "MC(machine,axis,limits,max,Context)"        "Určuje maximální mez osy otáčení (St)."

::msgcat::mcset $gPB(LANG) "MC(machine,axis,incr_text)"                 "Tato otočná osa může být s přírůstkem"

::msgcat::mcset $gPB(LANG) "MC(machine,axis,rotary_res,Label)"          "Rozlišení otočného pohybu (St)"
::msgcat::mcset $gPB(LANG) "MC(machine,axis,rotary_res,Context)"        "Určuje rozlišení otočného pohybu (St)."

::msgcat::mcset $gPB(LANG) "MC(machine,axis,ang_offset,Label)"          "Úhlové odsazení (St)"
::msgcat::mcset $gPB(LANG) "MC(machine,axis,ang_offset,Context)"        "Určuje úhlové odsazení osy (St)."

::msgcat::mcset $gPB(LANG) "MC(machine,axis,pivot,Label)"               "Vzdálenost otáčení"
::msgcat::mcset $gPB(LANG) "MC(machine,axis,pivot,Context)"             "Určuje vzdálenost otáčení."

::msgcat::mcset $gPB(LANG) "MC(machine,axis,max_feed,Label)"            "Max. rychlost posuvu (St/Min)"
::msgcat::mcset $gPB(LANG) "MC(machine,axis,max_feed,Context)"          "Určuje maximální rychlost posuvu (St/Min)."

::msgcat::mcset $gPB(LANG) "MC(machine,axis,plane,Label)"               "Rovina otáčení"
::msgcat::mcset $gPB(LANG) "MC(machine,axis,plane,Context)"             "Umožňuje vybrat rovinu otáčení XY, YZ, ZX nebo jinou. Pomocí možnosti \\\"Jiný\\\" je možné určit libovolný vektor."

::msgcat::mcset $gPB(LANG) "MC(machine,axis,plane,normal,Label)"        "Normálový vektor roviny"
::msgcat::mcset $gPB(LANG) "MC(machine,axis,plane,normal,Context)"      "Umožňuje určit normálový vektor roviny jako osu otáčení. \nVektor není nutné sjednotit."
::msgcat::mcset $gPB(LANG) "MC(machine,axis,plane,4th,Label)"           "Normála roviny čtvrté osy"
::msgcat::mcset $gPB(LANG) "MC(machine,axis,plane,4th,Context)"         "Určuje normálový vektor roviny pro otáčení čtvrté osy."
::msgcat::mcset $gPB(LANG) "MC(machine,axis,plane,5th,Label)"           "Normála roviny páté osy"
::msgcat::mcset $gPB(LANG) "MC(machine,axis,plane,5th,Context)"         "Určuje normálový vektor roviny pro otáčení páté osy."

::msgcat::mcset $gPB(LANG) "MC(machine,axis,leader,Label)"              "Úvodní kód slova"
::msgcat::mcset $gPB(LANG) "MC(machine,axis,leader,Context)"            "Určuje úvodní kód slova."

::msgcat::mcset $gPB(LANG) "MC(machine,axis,config,Label)"              "Konfigurovat"
::msgcat::mcset $gPB(LANG) "MC(machine,axis,config,Context)"            "Pomocí této možnosti je možné definovat parametry čtvrté a páté osy."

::msgcat::mcset $gPB(LANG) "MC(machine,axis,r_axis_conf_trans,Label)"   "Konfigurace osy otáčení"
::msgcat::mcset $gPB(LANG) "MC(machine,axis,4th_axis,Label)"            "Čtvrtá osa"
::msgcat::mcset $gPB(LANG) "MC(machine,axis,5th_axis,Label)"            "Pátá osa"
::msgcat::mcset $gPB(LANG) "MC(machine,axis,head,Label)"                " Hlava "
::msgcat::mcset $gPB(LANG) "MC(machine,axis,table,Label)"               " Tabulka "

::msgcat::mcset $gPB(LANG) "MC(machine,axis,rotary_lintol,Label)"       "Výchozí tolerance linearizace"
::msgcat::mcset $gPB(LANG) "MC(machine,axis,rotary_lintol,Context)"     "Tato hodnota bude použita jako výchozí tolerance k linearizaci otočných pohybů, když je příkaz postprocesoru LINTOL/ON určen s aktuální nebo předcházející operací.  Příkaz LINTOL/ může určit také jinou toleranci linearizace."

#+++++++++++++++++++++
# Program & Tool Path
#+++++++++++++++++++++
::msgcat::mcset $gPB(LANG) "MC(progtpth,tab,Label)"                 "Program a dráha nástroje"

##---------
## Program
##
::msgcat::mcset $gPB(LANG) "MC(prog,tab,Label)"                     "Program"
::msgcat::mcset $gPB(LANG) "MC(prog,Status)"                        "Definovat výstup událostí"

::msgcat::mcset $gPB(LANG) "MC(prog,tree,Label)"                    "Program -- Strom posloupností"
::msgcat::mcset $gPB(LANG) "MC(prog,tree,Context)"                  "Program N/C je rozdělen do pěti segmentů: čtyř posloupností a tělesa dráhy nástroje: \n \n * Počáteční posloupnost programu \n * Počáteční posloupnost operace \n * Dráha nástroje \n * Koncová posloupnost operace \n * Koncová posloupnost programu \n \nKaždá posloupnost se skládá z řady značek. Značka naznačuje událost, kterou je možné naprogramovat a může se vyskytnout v určité fázi programu N/C. Každou značku je možné připojit s určitým uspořádáním kódů N/C tak, aby byla součástí výstupu při postprocesingu programu. \n \nDráha nástroje se skládá z několika událostí. Ty jsou rozděleny do tří skupin: \n \n * Řízení stroje \n * Pohyby \n * Cykly \n"

::msgcat::mcset $gPB(LANG) "MC(prog,tree,prog_strt,Label)"          "Počáteční posloupnost programu"
::msgcat::mcset $gPB(LANG) "MC(prog,tree,prog_end,Label)"           "Koncová posloupnost programu"
::msgcat::mcset $gPB(LANG) "MC(prog,tree,oper_strt,Label)"          "Počáteční posloupnost operace"
::msgcat::mcset $gPB(LANG) "MC(prog,tree,oper_end,Label)"           "Koncová posloupnost operace"
::msgcat::mcset $gPB(LANG) "MC(prog,tree,tool_path,Label)"          "Dráha nástroje"
::msgcat::mcset $gPB(LANG) "MC(prog,tree,tool_path,mach_cnt,Label)" "Řízení stroje"
::msgcat::mcset $gPB(LANG) "MC(prog,tree,tool_path,motion,Label)"   "Pohyb"
::msgcat::mcset $gPB(LANG) "MC(prog,tree,tool_path,cycle,Label)"    "Předdefinované cykly"
::msgcat::mcset $gPB(LANG) "MC(prog,tree,linked_posts,Label)"       "Posloupnost propojených postprocesorů"

::msgcat::mcset $gPB(LANG) "MC(prog,add,Label)"                     "Posloupnost -- Přidat blok"
::msgcat::mcset $gPB(LANG) "MC(prog,add,Context)"                   "Stisknutím tohoto tlačítka a přetažením bloku na požadovanou značku je možné přidat nový blok do posloupnosti.  Bloky je možné připojit také vedle, nad nebo pod stávající blok."

::msgcat::mcset $gPB(LANG) "MC(prog,trash,Label)"                   "Posloupnost -- Koš"
::msgcat::mcset $gPB(LANG) "MC(prog,trash,Context)"                 "Nechtěné bloky je možné z posloupnosti odstranit jejich přetažením na tento koš."

::msgcat::mcset $gPB(LANG) "MC(prog,block,Label)"                   "Posloupnost -- Blok"
::msgcat::mcset $gPB(LANG) "MC(prog,block,Context)"                 "Nechtěné bloky je možné z posloupnosti odstranit jejich přetažením na koš. \n \nStisknutím pravého tlačítka myši je také možné vyvolat místní nabídku, ve které jdou k dispozici různé příkazy: \n \n * Upravit \n * Vynutit výstup \n * Vyjmout \n * Kopírovat jako \n * Vložit \n * Odstranit \n"

::msgcat::mcset $gPB(LANG) "MC(prog,select,Label)"                  "Posloupnost -- Výběr bloku"
::msgcat::mcset $gPB(LANG) "MC(prog,select,Context)"                "V tomto seznamu je možné vybrat typ komponenty bloku, kterou chcete přidat do posloupnosti. \n\Aktuálně dostupné typy komponent jsou: \n \n * Nový blok \n * Existující blok N/C \n * Zpráva operátoru \n * Vlastní příkaz \n"

::msgcat::mcset $gPB(LANG) "MC(prog,oper_temp,Label)"               "Vybrat šablonu posloupnosti"
::msgcat::mcset $gPB(LANG) "MC(prog,add_block,Label)"               "Přidat blok"
::msgcat::mcset $gPB(LANG) "MC(prog,seq_comb_nc,Label)"             "Zobrazit kombinované bloky kódu N/C"
::msgcat::mcset $gPB(LANG) "MC(prog,seq_comb_nc,Context)"           "Pomocí tohoto tlačítka je možné zobrazit obsah posloupnosti z hlediska bloků nebo kódů N/C. \n \nKódy N/C zobrazí slova v odpovídajícím pořadí."

::msgcat::mcset $gPB(LANG) "MC(prog,plus,Label)"                    "Program -- Přepínač Sbalit / Rozbalit"
::msgcat::mcset $gPB(LANG) "MC(prog,plus,Context)"                  "Pomocí tohoto tlačítka je možné sbalit nebo rozbalit větve této komponenty."

::msgcat::mcset $gPB(LANG) "MC(prog,marker,Label)"                  "Posloupnost -- Značka"
::msgcat::mcset $gPB(LANG) "MC(prog,marker,Context)"                "Značky posloupnosti naznačuje možné události, které je možné naprogramovat a které se mohou vyskytnout v posloupnosti v určité fázi programu N/C. \n \nBloky je možné připojit nebo uspořádat tak, aby byly na výstupu na každé značce."

::msgcat::mcset $gPB(LANG) "MC(prog,event,Label)"                   "Program -- Událost"
::msgcat::mcset $gPB(LANG) "MC(prog,event,Context)"                 "Každou událost je možné upravit jedním kliknutím levým tlačítkem myši."

::msgcat::mcset $gPB(LANG) "MC(prog,nc_code,Label)"                 "Program -- Kód N/C"
::msgcat::mcset $gPB(LANG) "MC(prog,nc_code,Context)"               "Text v tomto poli zobrazuje reprezentativní kód N/C, který bude na výstupu na této značce nebo z této události."
::msgcat::mcset $gPB(LANG) "MC(prog,undo_popup,Label)"              "Zpět"

## Sequence
##
::msgcat::mcset $gPB(LANG) "MC(seq,combo,new,Label)"                "Nový blok"
::msgcat::mcset $gPB(LANG) "MC(seq,combo,comment,Label)"            "Zpráva operátoru"
::msgcat::mcset $gPB(LANG) "MC(seq,combo,custom,Label)"             "Vlastní příkaz"

::msgcat::mcset $gPB(LANG) "MC(seq,new_trans,title,Label)"          "Blok"
::msgcat::mcset $gPB(LANG) "MC(seq,cus_trans,title,Label)"          "Vlastní příkaz"
::msgcat::mcset $gPB(LANG) "MC(seq,oper_trans,title,Label)"         "Zpráva operátoru"

::msgcat::mcset $gPB(LANG) "MC(seq,edit_popup,Label)"               "Upravit"
::msgcat::mcset $gPB(LANG) "MC(seq,force_popup,Label)"              "Vynutit výstup"
::msgcat::mcset $gPB(LANG) "MC(seq,rename_popup,Label)"             "Přejmenovat"
::msgcat::mcset $gPB(LANG) "MC(seq,rename_popup,Context)"           "Můžete určit název tento komponenty."
::msgcat::mcset $gPB(LANG) "MC(seq,cut_popup,Label)"                "Vyjmout"
::msgcat::mcset $gPB(LANG) "MC(seq,copy_popup,Label)"               "Kopírovat jako"
::msgcat::mcset $gPB(LANG) "MC(seq,copy_popup,ref,Label)"           "Odkazované bloky"
::msgcat::mcset $gPB(LANG) "MC(seq,copy_popup,new,Label)"           "Nové bloky"
::msgcat::mcset $gPB(LANG) "MC(seq,paste_popup,Label)"              "Vložit"
::msgcat::mcset $gPB(LANG) "MC(seq,paste_popup,before,Label)"       "Před"
::msgcat::mcset $gPB(LANG) "MC(seq,paste_popup,inline,Label)"       "V linii"
::msgcat::mcset $gPB(LANG) "MC(seq,paste_popup,after,Label)"        "Po"
::msgcat::mcset $gPB(LANG) "MC(seq,del_popup,Label)"                "Odstranit"

::msgcat::mcset $gPB(LANG) "MC(seq,force_trans,title,Label)"        "Vynutit jeden výstup"

##--------------
## Toolpath
##
::msgcat::mcset $gPB(LANG) "MC(tool,event_trans,title,Label)"       "Událost"

::msgcat::mcset $gPB(LANG) "MC(tool,event_seq,button,Label)"        "Vybrat šablonu události"
::msgcat::mcset $gPB(LANG) "MC(tool,add_word,button,Label)"         "Přidat slovo"

::msgcat::mcset $gPB(LANG) "MC(tool,format_trans,title,Label)"      "FORMÁT"

::msgcat::mcset $gPB(LANG) "MC(tool,circ_trans,title,Label)"        "Kruhový posun -- Kódy rovin"
::msgcat::mcset $gPB(LANG) "MC(tool,circ_trans,frame,Label)"        " G-kódy rovin "
::msgcat::mcset $gPB(LANG) "MC(tool,circ_trans,xy,Label)"           "Rovina XY"
::msgcat::mcset $gPB(LANG) "MC(tool,circ_trans,yz,Label)"           "Rovina YZ"
::msgcat::mcset $gPB(LANG) "MC(tool,circ_trans,zx,Label)"           "Rovina ZX"

::msgcat::mcset $gPB(LANG) "MC(tool,ijk_desc,arc_start,Label)"          "Počátek oblouku ke středu"
::msgcat::mcset $gPB(LANG) "MC(tool,ijk_desc,arc_center,Label)"         "Střed oblouku k počátku"
::msgcat::mcset $gPB(LANG) "MC(tool,ijk_desc,u_arc_start,Label)"        "Neoznačený počátek oblouku ke středu"
::msgcat::mcset $gPB(LANG) "MC(tool,ijk_desc,absolute,Label)"           "Absolutní střed oblouku"
::msgcat::mcset $gPB(LANG) "MC(tool,ijk_desc,long_thread_lead,Label)"   "Podélné stoupání závitu"
::msgcat::mcset $gPB(LANG) "MC(tool,ijk_desc,tran_thread_lead,Label)"   "Příčné stoupání závitu"

::msgcat::mcset $gPB(LANG) "MC(tool,spindle,range,type,Label)"              "Typ rozsahu vřetena"
::msgcat::mcset $gPB(LANG) "MC(tool,spindle,range,range_M,Label)"           "Samostatný M-kód rozsahu (M41)"
::msgcat::mcset $gPB(LANG) "MC(tool,spindle,range,with_spindle_M,Label)"    "Číslo rozsahu s M-kódem vřetena (M13)"
::msgcat::mcset $gPB(LANG) "MC(tool,spindle,range,hi_lo_with_S,Label)"      "Velký/malý rozsah s S-kódem (S+100)"
::msgcat::mcset $gPB(LANG) "MC(tool,spindle,range,nonzero_range,msg)"       "Počet rozsahů vřeten musí být větší než nula."

::msgcat::mcset $gPB(LANG) "MC(tool,spindle_trans,title,Label)"         "Tabulka kódů rozsahů vřetena"
::msgcat::mcset $gPB(LANG) "MC(tool,spindle_trans,range,Label)"         "Rozsah"
::msgcat::mcset $gPB(LANG) "MC(tool,spindle_trans,code,Label)"          "Kód"
::msgcat::mcset $gPB(LANG) "MC(tool,spindle_trans,min,Label)"           "Minimum (ot/min)"
::msgcat::mcset $gPB(LANG) "MC(tool,spindle_trans,max,Label)"           "Maximum (ot/min)"

::msgcat::mcset $gPB(LANG) "MC(tool,spindle_desc,sep,Label)"            " Samostatný M-kód rozsahu (M41, M42 ...) "
::msgcat::mcset $gPB(LANG) "MC(tool,spindle_desc,range,Label)"          " Číslo rozsahu s M-kódem vřetena (M13, M23 ...)"
::msgcat::mcset $gPB(LANG) "MC(tool,spindle_desc,high,Label)"           " Velký/malý rozsah s S-kódem (S+100/S-100)"
::msgcat::mcset $gPB(LANG) "MC(tool,spindle_desc,odd,Label)"            " Lichý/sudý rozsah s S-kódem"


::msgcat::mcset $gPB(LANG) "MC(tool,config,mill_opt1,Label)"            "Číslo nástroje"
::msgcat::mcset $gPB(LANG) "MC(tool,config,mill_opt2,Label)"            "Číslo nástroje a číslo odsazení délky"
::msgcat::mcset $gPB(LANG) "MC(tool,config,mill_opt3,Label)"            "Číslo odsazení délky a číslo nástroje"

::msgcat::mcset $gPB(LANG) "MC(tool,config,title,Label)"                "Konfigurace kódu nástroje"
::msgcat::mcset $gPB(LANG) "MC(tool,config,output,Label)"               "Výstup"

::msgcat::mcset $gPB(LANG) "MC(tool,config,lathe_opt1,Label)"           "Číslo nástroje"
::msgcat::mcset $gPB(LANG) "MC(tool,config,lathe_opt2,Label)"           "Číslo nástroje a číslo odsazení délky"
::msgcat::mcset $gPB(LANG) "MC(tool,config,lathe_opt3,Label)"           "Index nožové hlavy a číslo hlavice"
::msgcat::mcset $gPB(LANG) "MC(tool,config,lathe_opt4,Label)"           "Číslo nástroje indexu nožové hlavy a číslo odsazení délky"

::msgcat::mcset $gPB(LANG) "MC(tool,conf_desc,num,Label)"               "Číslo nástroje"
::msgcat::mcset $gPB(LANG) "MC(tool,conf_desc,next_num,Label)"          "Číslo dalšího nástroje"
::msgcat::mcset $gPB(LANG) "MC(tool,conf_desc,index_num,Label)"         "Index nožové hlavy a číslo nástroje"
::msgcat::mcset $gPB(LANG) "MC(tool,conf_desc,index_next_num,Label)"    "Index nožové hlavy a číslo dalšího nástroje"
::msgcat::mcset $gPB(LANG) "MC(tool,conf_desc,num_len,Label)"           "Číslo nástroje a číslo odsazení délky"
::msgcat::mcset $gPB(LANG) "MC(tool,conf_desc,next_num_len,Label)"      "Číslo dalšího nástroje a číslo odsazení délky"
::msgcat::mcset $gPB(LANG) "MC(tool,conf_desc,len_num,Label)"           "Číslo odsazení délky a číslo nástroje"
::msgcat::mcset $gPB(LANG) "MC(tool,conf_desc,len_next_num,Label)"      "Číslo odsazení délky a číslo dalšího nástroje"
::msgcat::mcset $gPB(LANG) "MC(tool,conf_desc,index_num_len,Label)"     "Index nožové hlavy, číslo nástroje a číslo odsazení délky"
::msgcat::mcset $gPB(LANG) "MC(tool,conf_desc,index_next_num_len,Label)"    "Index nožové hlavy, číslo dalšího nástroje a číslo odsazení délky"

::msgcat::mcset $gPB(LANG) "MC(tool,oper_trans,title,Label)"            "Zpráva operátoru"
::msgcat::mcset $gPB(LANG) "MC(tool,cus_trans,title,Label)"             "Vlastní příkaz"

##--------------------------
## Labels for Event dialogs
##
::msgcat::mcset $gPB(LANG) "MC(event,feed,IPM_mode)"                "Režim IPM (Palce/Min)"

##---------
## G Codes
##
::msgcat::mcset $gPB(LANG) "MC(gcode,tab,Label)"                    "G-kódy"
::msgcat::mcset $gPB(LANG) "MC(gcode,Status)"                       "Určit G-kódy"

##---------
## M Codes
##
::msgcat::mcset $gPB(LANG) "MC(mcode,tab,Label)"                    "M-kódy"
::msgcat::mcset $gPB(LANG) "MC(mcode,Status)"                       "Určit M-kódy"

##-----------------
## Words Summary
##
::msgcat::mcset $gPB(LANG) "MC(addrsum,tab,Label)"                  "Souhrn slov"
::msgcat::mcset $gPB(LANG) "MC(addrsum,Status)"                     "Zadejte parametry"

::msgcat::mcset $gPB(LANG) "MC(addrsum,col_addr,Label)"             "Word"
::msgcat::mcset $gPB(LANG) "MC(addrsum,col_addr,Context)"           "Adresu slova je možné upravit kliknutím levým tlačítkem myši na jeho název."
::msgcat::mcset $gPB(LANG) "MC(addrsum,col_lead,Label)"             "Úvodní kód/Kód"
::msgcat::mcset $gPB(LANG) "MC(addrsum,col_data,Label)"             "Datový typ"
::msgcat::mcset $gPB(LANG) "MC(addrsum,col_plus,Label)"             "Plus (+)"
::msgcat::mcset $gPB(LANG) "MC(addrsum,col_lzero,Label)"            "Úvodní nula"
::msgcat::mcset $gPB(LANG) "MC(addrsum,col_int,Label)"              "Celé číslo"
::msgcat::mcset $gPB(LANG) "MC(addrsum,col_dec,Label)"              "Desetinný (.)"
::msgcat::mcset $gPB(LANG) "MC(addrsum,col_frac,Label)"             "Zlomek"
::msgcat::mcset $gPB(LANG) "MC(addrsum,col_tzero,Label)"            "Koncová nula"
::msgcat::mcset $gPB(LANG) "MC(addrsum,col_modal,Label)"            "Modální ?"
::msgcat::mcset $gPB(LANG) "MC(addrsum,col_min,Label)"              "Minimum"
::msgcat::mcset $gPB(LANG) "MC(addrsum,col_max,Label)"              "Maximum"
::msgcat::mcset $gPB(LANG) "MC(addrsum,col_trail,Label)"            "Ukončovač"

::msgcat::mcset $gPB(LANG) "MC(addrsum,radio_text,Label)"           "Text"
::msgcat::mcset $gPB(LANG) "MC(addrsum,radio_num,Label)"            "Číselné"

::msgcat::mcset $gPB(LANG) "MC(addrsum,addr_trans,title,Label)"     "SLOVO"
::msgcat::mcset $gPB(LANG) "MC(addrsum,other_trans,title,Label)"    "Jiné datové prvky"

##-----------------
## Word Sequencing
##
::msgcat::mcset $gPB(LANG) "MC(wseq,tab,Label)"                     "Uspořádání slov"
::msgcat::mcset $gPB(LANG) "MC(wseq,Status)"                        "Uspořádat slova"

::msgcat::mcset $gPB(LANG) "MC(wseq,word,Label)"                    "Hlavní posloupnost slov"
::msgcat::mcset $gPB(LANG) "MC(wseq,word,Context)"                  "Pořadí slov zobrazovaných ve výstupu N/C je možné upravit přetažením slova na požadovanou pozici. \n \nPokud přetahované slovo protíná jiné slovo (má změněnu barvu obdélníku), umístění těchto 2 slov budou prohozena. Pokud je slovo přetaženo nad oddělovač mezi jinými 2 slovy, bude vloženo mezi tato 2 slova. \n \nSlovo je možné ve výstupu do souboru N/C vypnout jedním kliknutím levým tlačítkem myši. \n \nSe slovy je možné manipulovat prostřednictvím možností místní nabídky: \n \n * Nový \n * Upravit \n * Odstranit \n * Aktivovat vše \n"

::msgcat::mcset $gPB(LANG) "MC(wseq,active_out,Label)"              " Výstup - Aktivní     "
::msgcat::mcset $gPB(LANG) "MC(wseq,suppressed_out,Label)"          " Výstup - Vypnutý "

::msgcat::mcset $gPB(LANG) "MC(wseq,popup_new,Label)"               "Nový"
::msgcat::mcset $gPB(LANG) "MC(wseq,popup_undo,Label)"              "Zpět"
::msgcat::mcset $gPB(LANG) "MC(wseq,popup_edit,Label)"              "Upravit"
::msgcat::mcset $gPB(LANG) "MC(wseq,popup_delete,Label)"            "Odstranit"
::msgcat::mcset $gPB(LANG) "MC(wseq,popup_all,Label)"               "Aktivovat vše"
::msgcat::mcset $gPB(LANG) "MC(wseq,transient_win,Label)"           "WORD"
::msgcat::mcset $gPB(LANG) "MC(wseq,cannot_suppress_msg)"           "není možné vypnout.  Bylo používáno jako jeden prvek v"
::msgcat::mcset $gPB(LANG) "MC(wseq,empty_block_msg)"               "Vypnutím výstupu této adresy vznikne jeden nebo více neplatných prázdných bloků."

##----------------
## Custom Command
##
::msgcat::mcset $gPB(LANG) "MC(cust_cmd,tab,Label)"                 "Vlastní příkaz"
::msgcat::mcset $gPB(LANG) "MC(cust_cmd,Status)"                    "Definovat vlastní příkazy"

::msgcat::mcset $gPB(LANG) "MC(cust_cmd,name,Label)"                "Název příkazu"
::msgcat::mcset $gPB(LANG) "MC(cust_cmd,name,Context)"              "Ke zde zadanému názvu bude přidána předpona PC_CMD_ tak, aby odpovídal skutečnému názvu příkazu."
::msgcat::mcset $gPB(LANG) "MC(cust_cmd,proc,Label)"                "Procedura"
::msgcat::mcset $gPB(LANG) "MC(cust_cmd,proc,Context)"              "Funkci tohoto příkazu definujete zadáním skriptu Tcl. \n \n * Obsah skriptu nebude zpracován aplikací Post Builder, místo toho bude uložen v souboru Tcl. To znamená, že je nutné zajistit syntaktickou správnost skriptu."

::msgcat::mcset $gPB(LANG) "MC(cust_cmd,name_msg)"                  "Neplatný název vlastního příkazu.\n Zadejte jiný název"
::msgcat::mcset $gPB(LANG) "MC(cust_cmd,name_msg_1)"                "je rezervován pro speciální vlastní příkazy.\n Zadejte jiný název"
::msgcat::mcset $gPB(LANG) "MC(cust_cmd,name_msg_2)"                "Povoleny jsou pouze názvy vlastních \n příkazů jako je PB_CMD_vnc____*.\n Zadejte jiný název"

::msgcat::mcset $gPB(LANG) "MC(cust_cmd,import,Label)"              "Import"
::msgcat::mcset $gPB(LANG) "MC(cust_cmd,import,Context)"            "Umožňuje do rozpracovaného postprocesoru importovat vlastní příkazy z vybraného souboru Tcl."
::msgcat::mcset $gPB(LANG) "MC(cust_cmd,export,Label)"              "Export"
::msgcat::mcset $gPB(LANG) "MC(cust_cmd,export,Context)"            "Umožňuje z rozpracovaného postprocesoru exportovat vlastní příkazy do souboru Tcl."
::msgcat::mcset $gPB(LANG) "MC(cust_cmd,import,tree,Label)"         "Import vlastních příkazů"
::msgcat::mcset $gPB(LANG) "MC(cust_cmd,import,tree,Context)"       "Tento seznam obsahuje procedury vlastního příkazu a jiné procedury Tcl, které se nacházejí v souboru, který se má importovat.  Náhled obsahu každé procedury je možné zobrazit výběrem položky v seznamu jedním kliknutím levým tlačítkem myši.  Procedura, která se již nachází v rozpracovaném postprocesoru je označena příznakem <existuje>.  Dvojitým kliknutím levým tlačítkem myši na položku můžete přepnout zaškrtávací políčko vedle položky.  Díky tomu je možné vybrat nebo zrušit výběr procedury k importu. Ve výchozím stavu jsou k importu vybrány všechny procedury.  Předejít přepsání existující procedury můžete zrušením výběru libovolné položky."

::msgcat::mcset $gPB(LANG) "MC(cust_cmd,export,tree,Label)"         "Export vlastních příkazů"
::msgcat::mcset $gPB(LANG) "MC(cust_cmd,export,tree,Context)"       "Tento seznam obsahuje procedury vlastního příkazu a jiné procedury Tcl, které existují v rozpracovaném postprocesoru.  Náhled obsahu každé procedury je možné zobrazit výběrem položky v seznamu jedním kliknutím levým tlačítkem myši.  Dvojitým kliknutím levým tlačítkem myši na položku můžete přepnout zaškrtávací políčko vedle položky.  Díky tomu je možné vybrat pouze ty procedury, které chcete exportovat."

::msgcat::mcset $gPB(LANG) "MC(cust_cmd,error,title)"               "Chyba vlastního příkazu"
::msgcat::mcset $gPB(LANG) "MC(cust_cmd,error,msg)"                 "Ověření vlastních příkazů je možné povolit nebo zakázat nastavením přepínačů v rozevírací nabídce položky hlavní nabídky \"Možnosti -> Ověřit vlastní příkazy\"."

::msgcat::mcset $gPB(LANG) "MC(cust_cmd,select_all,Label)"          "Vybrat vše"
::msgcat::mcset $gPB(LANG) "MC(cust_cmd,select_all,Context)"        "Kliknutím na toto tlačítko je možné vybrat všechny příkazy zobrazené k importu nebo exportu."
::msgcat::mcset $gPB(LANG) "MC(cust_cmd,deselect_all,Label)"        "Odebrat vše"
::msgcat::mcset $gPB(LANG) "MC(cust_cmd,deselect_all,Context)"      "Kliknutím na toto tlačítko je možné zrušit výběr všech příkazů."

::msgcat::mcset $gPB(LANG) "MC(cust_cmd,import,warning,title)"      "Upozornění importu / exportu vlastního příkazu"
::msgcat::mcset $gPB(LANG) "MC(cust_cmd,import,warning,msg)"        "K importu nebo exportu nebyla vybrána žádná položka."



::msgcat::mcset $gPB(LANG) "MC(cust_cmd,cmd,msg)"                   "Příkazy : "
::msgcat::mcset $gPB(LANG) "MC(cust_cmd,blk,msg)"                   "Bloky : "
::msgcat::mcset $gPB(LANG) "MC(cust_cmd,add,msg)"                   "Adresy : "
::msgcat::mcset $gPB(LANG) "MC(cust_cmd,fmt,msg)"                   "Formáty : "
::msgcat::mcset $gPB(LANG) "MC(cust_cmd,referenced,msg)"            "odkazované ve vlastním příkazu "
::msgcat::mcset $gPB(LANG) "MC(cust_cmd,not_defined,msg)"           "nebyly v aktuálním rozsahu rozpracovaného postprocesoru definovány."
::msgcat::mcset $gPB(LANG) "MC(cust_cmd,cannot_delete,msg)"         "není možné odstranit."
::msgcat::mcset $gPB(LANG) "MC(cust_cmd,save_post,msg)"             "Chcete tento postprocesor i přesto uložit?"


##------------------
## Operator Message
##
::msgcat::mcset $gPB(LANG) "MC(opr_msg,text,Label)"                 "Zpráva operátoru"
::msgcat::mcset $gPB(LANG) "MC(opr_msg,text,Context)"               "Text, který se má zobrazit jako zpráva operátoru.  Vyžadované speciální znaky pro začátek a konec zprávy budou automaticky připojeny aplikací Post Builder. Tyto znaky jsou určeny na stránce parametru \"Jiné datové prvky\" na kartě \"Definice dat N/C\"."

::msgcat::mcset $gPB(LANG) "MC(opr_msg,name,Label)"                 "Název zprávy"
::msgcat::mcset $gPB(LANG) "MC(opr_msg,empty_operator)"             "Zpráva operátoru nemůže být prázdná."


##--------------
## Linked Posts
##
::msgcat::mcset $gPB(LANG) "MC(link_post,tab,Label)"                "Propojené postprocesory"
::msgcat::mcset $gPB(LANG) "MC(link_post,Status)"                   "Definovat propojené postprocesory"

::msgcat::mcset $gPB(LANG) "MC(link_post,toggle,Label)"             "Propojit jiné postprocesory s tímto postprocesorem"
::msgcat::mcset $gPB(LANG) "MC(link_post,toggle,Context)"           "Pro účely zpracování složitých obráběcích strojů, které provádí kombinaci více než jednoho jednoduchého režimu frézování a soustružení, je možné k tomuto postprocesoru připojit jiné postprocesory."

::msgcat::mcset $gPB(LANG) "MC(link_post,head,Label)"               "Hlava"
::msgcat::mcset $gPB(LANG) "MC(link_post,head,Context)"             "Složité obráběcí stroje mohou provádět operace obrábění pomocí různých sad kinematik v různých režimech obrábění.  S každou sadou kinematik se v NX/Postprocesoru zachází jako s nezávislou hlavou.  Operace obrábění, které musí být provedeny s určitou hlavou, budou seskupeny v obráběcím stroji nebo v zobrazení metody obrábění.  UDE \\\"Hlava\\\" bude poté přiřazeno ke skupině tak, aby fungovalo jako název pro tuto hlavu."

::msgcat::mcset $gPB(LANG) "MC(link_post,post,Label)"               "Postprocesor"
::msgcat::mcset $gPB(LANG) "MC(link_post,post,Context)"             "Postprocesor je k hlavě přiřazen, aby vytvořil kódy N/C."

::msgcat::mcset $gPB(LANG) "MC(link_post,link,Label)"               "Propojený postprocesor"
::msgcat::mcset $gPB(LANG) "MC(link_post,link,Context)"             "[::msgcat::mc MC(link_post,head,Context)] \n\n [::msgcat::mc MC(link_post,post,Context)]"


::msgcat::mcset $gPB(LANG) "MC(link_post,new,Label)"                "Nový"
::msgcat::mcset $gPB(LANG) "MC(link_post,new,Context)"              "Umožňuje vytvořit nové propojení."

::msgcat::mcset $gPB(LANG) "MC(link_post,edit,Label)"               "Upravit"
::msgcat::mcset $gPB(LANG) "MC(link_post,edit,Context)"             "Umožňuje upravit propojení."

::msgcat::mcset $gPB(LANG) "MC(link_post,delete,Label)"             "Odstranit"
::msgcat::mcset $gPB(LANG) "MC(link_post,delete,Context)"           "Umožňuje odstranit propojení."

::msgcat::mcset $gPB(LANG) "MC(link_post,select_name,Label)"        "Vybrat název"
::msgcat::mcset $gPB(LANG) "MC(link_post,select_name,Context)"      "Umožňuje výběr postprocesoru, který má být k hlavě přiřazen.  Pravděpodobně se bude nacházet v adresáři, ve kterém se nachází hlavní postprocesor za běhu NX/Postprocesoru, v opačném případě se použije postprocesor se stejným názvem v adresáři \\\$UGII_CAM_POST_DIR."

::msgcat::mcset $gPB(LANG) "MC(link_post,start_of_head,Label)"      "Počátek hlavy"
::msgcat::mcset $gPB(LANG) "MC(link_post,start_of_head,Context)"    "Určuje kódy N/C nebo akce, které se mají provést na počátku této hlavy."

::msgcat::mcset $gPB(LANG) "MC(link_post,end_of_head,Label)"        "Konec hlavy"
::msgcat::mcset $gPB(LANG) "MC(link_post,end_of_head,Context)"      "Určuje kódy N/C nebo akce, které se mají provést na konci této hlavy."
::msgcat::mcset $gPB(LANG) "MC(link_post,dlg,head,Label)"           "Hlava"
::msgcat::mcset $gPB(LANG) "MC(link_post,dlg,post,Label)"           "Postprocesor"
::msgcat::mcset $gPB(LANG) "MC(link_post,dlg,title,Label)"          "Propojený postprocesor"

#++++++++++++++++++++++
# N/C Data Definitions
#++++++++++++++++++++++
::msgcat::mcset $gPB(LANG) "MC(nc_data,tab,Label)"                  "Definice dat N/C"

##-------
## BLOCK
##
::msgcat::mcset $gPB(LANG) "MC(block,tab,Label)"                    "BLOCK"
::msgcat::mcset $gPB(LANG) "MC(block,Status)"                       "Definovat šablony bloků"

::msgcat::mcset $gPB(LANG) "MC(block,name,Label)"                   "Název bloku"
::msgcat::mcset $gPB(LANG) "MC(block,name,Context)"                 "Zadat název bloku"

::msgcat::mcset $gPB(LANG) "MC(block,add,Label)"                    "Přidat slovo"
::msgcat::mcset $gPB(LANG) "MC(block,add,Context)"                  "Přidat nové slovo k bloku je možné stisknutím tohoto tlačítka a přetažením slova na blok zobrazený v okně níže.  Typ slova, které se vytvoří, bude vybrán ze seznamu na pravé straně tohoto tlačítka."

::msgcat::mcset $gPB(LANG) "MC(block,select,Label)"                 "BLOK -- Výběr slova"
::msgcat::mcset $gPB(LANG) "MC(block,select,Context)"               "Tento seznam umožňuje výběr typu slova, které má být přidáno k bloku."

::msgcat::mcset $gPB(LANG) "MC(block,trash,Label)"                  "BLOK -- Koš"
::msgcat::mcset $gPB(LANG) "MC(block,trash,Context)"                "Nechtěná slova je možné z bloku odstranit jejich přetažením na tento koš."

::msgcat::mcset $gPB(LANG) "MC(block,word,Label)"                   "BLOK -- Slovo"
::msgcat::mcset $gPB(LANG) "MC(block,word,Context)"                 "Nechtěná slova je možné z bloku odstranit jejich přetažením na koš. \n \nStisknutím pravého tlačítka myši je také možné vyvolat místní nabídku, ve které jdou k dispozici různé příkazy: \n \n * Upravit \n * Změnit prvek -> \n * Volitelné \n * Bez oddělovače slov \n * Vynutit výstup \n * Odstranit \n"

::msgcat::mcset $gPB(LANG) "MC(block,verify,Label)"                 "BLOK -- Ověření slova"
::msgcat::mcset $gPB(LANG) "MC(block,verify,Context)"               "V tomto okně je zobrazen reprezentativní kód N/C, který má být na výstupu pro vybrané slovo (snížené) v bloku zobrazeném v okně výše."

::msgcat::mcset $gPB(LANG) "MC(block,new_combo,Label)"              "Nová adresa"
::msgcat::mcset $gPB(LANG) "MC(block,text_combo,Label)"             "Textový prvek"
::msgcat::mcset $gPB(LANG) "MC(block,oper_combo,Label)"             "Zpráva operátoru"
::msgcat::mcset $gPB(LANG) "MC(block,comm_combo,Label)"             "Příkaz"

::msgcat::mcset $gPB(LANG) "MC(block,edit_popup,Label)"             "Upravit"
::msgcat::mcset $gPB(LANG) "MC(block,view_popup,Label)"             "Pohled"
::msgcat::mcset $gPB(LANG) "MC(block,change_popup,Label)"           "Změnit prvek"
::msgcat::mcset $gPB(LANG) "MC(block,user_popup,Label)"             "Uživatelský výraz"
::msgcat::mcset $gPB(LANG) "MC(block,opt_popup,Label)"              "Volitelné"
::msgcat::mcset $gPB(LANG) "MC(block,no_sep_popup,Label)"           "Bez oddělovače slov"
::msgcat::mcset $gPB(LANG) "MC(block,force_popup,Label)"            "Vynutit výstup"
::msgcat::mcset $gPB(LANG) "MC(block,delete_popup,Label)"           "Odstranit"
::msgcat::mcset $gPB(LANG) "MC(block,undo_popup,Label)"             "Zpět"
::msgcat::mcset $gPB(LANG) "MC(block,delete_all,Label)"             "Odstranit všechny aktivní prvky"

::msgcat::mcset $gPB(LANG) "MC(block,cmd_title,Label)"              "Vlastní příkaz"
::msgcat::mcset $gPB(LANG) "MC(block,oper_title,Label)"             "Zpráva operátoru"
::msgcat::mcset $gPB(LANG) "MC(block,addr_title,Label)"             "WORD"

::msgcat::mcset $gPB(LANG) "MC(block,new_trans,title,Label)"        "WORD"

::msgcat::mcset $gPB(LANG) "MC(block,new,word_desc,Label)"          "Nová adresa"
::msgcat::mcset $gPB(LANG) "MC(block,oper,word_desc,Label)"         "Zpráva operátoru"
::msgcat::mcset $gPB(LANG) "MC(block,cmd,word_desc,Label)"          "Vlastní příkaz"
::msgcat::mcset $gPB(LANG) "MC(block,user,word_desc,Label)"         "Uživatelský výraz"
::msgcat::mcset $gPB(LANG) "MC(block,text,word_desc,Label)"         "Řetězec textu"

::msgcat::mcset $gPB(LANG) "MC(block,user,expr,Label)"              "Výraz"

::msgcat::mcset $gPB(LANG) "MC(block,msg,min_word)"                 "Blok musí obsahovat alespoň jedno slovo."

::msgcat::mcset $gPB(LANG) "MC(block,name_msg)"                     "Neplatný název bloku.\n Zadejte jiný název"

##---------
## ADDRESS
##
::msgcat::mcset $gPB(LANG) "MC(address,tab,Label)"                  "WORD"
::msgcat::mcset $gPB(LANG) "MC(address,Status)"                     "Definovat slova"

::msgcat::mcset $gPB(LANG) "MC(address,name,Label)"                 "Název slova"
::msgcat::mcset $gPB(LANG) "MC(address,name,Context)"               "Název slova je možné upravit."

::msgcat::mcset $gPB(LANG) "MC(address,verify,Label)"               "SLOVO -- Ověření"
::msgcat::mcset $gPB(LANG) "MC(address,verify,Context)"             "Toto okno zobrazuje reprezentativní kód N/C, který má být na výstupu pro slovo."

::msgcat::mcset $gPB(LANG) "MC(address,leader,Label)"               "Úvodní kód"
::msgcat::mcset $gPB(LANG) "MC(address,leader,Context)"             "Jako úvodní kód slova můžete zadat libovolný počet znaků nebo vybrat znaky z rozevírací nabídky pomocí pravého tlačítka myši."

::msgcat::mcset $gPB(LANG) "MC(address,format,Label)"               "Formát"
::msgcat::mcset $gPB(LANG) "MC(address,format,edit,Label)"          "Upravit"
::msgcat::mcset $gPB(LANG) "MC(address,format,edit,Context)"        "Pomocí tohoto tlačítka je možné upravit formát, který slovo používá."
::msgcat::mcset $gPB(LANG) "MC(address,format,new,Label)"           "Nový"
::msgcat::mcset $gPB(LANG) "MC(address,format,new,Context)"         "Pomocí tohoto tlačítka je možné vytvořit nový formát."

::msgcat::mcset $gPB(LANG) "MC(address,format,select,Label)"        "SLOVO -- Vybrat formát"
::msgcat::mcset $gPB(LANG) "MC(address,format,select,Context)"      "Pomocí tohoto tlačítka je možné pro slovo vybrat jiný formát."

::msgcat::mcset $gPB(LANG) "MC(address,trailer,Label)"              "Ukončovač"
::msgcat::mcset $gPB(LANG) "MC(address,trailer,Context)"            "Můžete zadat libovolný počet znaků jako ukončovač slova nebo vybrat znaky z rozevírací nabídky pomocí pravého tlačítka myši."

::msgcat::mcset $gPB(LANG) "MC(address,modality,Label)"             "Modální ?"
::msgcat::mcset $gPB(LANG) "MC(address,modality,Context)"           "Pomocí této možnosti je možné nastavit modalitu slova."

::msgcat::mcset $gPB(LANG) "MC(address,modal_drop,off,Label)"       "Vypnuto"
::msgcat::mcset $gPB(LANG) "MC(address,modal_drop,once,Label)"      "Jednou"
::msgcat::mcset $gPB(LANG) "MC(address,modal_drop,always,Label)"    "Vždy"

::msgcat::mcset $gPB(LANG) "MC(address,max,value,Label)"            "Maximum"
::msgcat::mcset $gPB(LANG) "MC(address,max,value,Context)"          "Pomocí této možnosti nastavíte maximální hodnotu slova."

::msgcat::mcset $gPB(LANG) "MC(address,value,text,Label)"           "Hodnota"

::msgcat::mcset $gPB(LANG) "MC(address,trunc_drop,Label)"           "Zkrátit hodnotu"
::msgcat::mcset $gPB(LANG) "MC(address,warn_drop,Label)"            "Upozornit uživatele"
::msgcat::mcset $gPB(LANG) "MC(address,abort_drop,Label)"           "Zrušit proces"

::msgcat::mcset $gPB(LANG) "MC(address,max,error_handle,Label)"     "Zpracování porušení"
::msgcat::mcset $gPB(LANG) "MC(address,max,error_handle,Context)"   "Pomocí tohoto tlačítka je možné určit metodu zpracování porušení maximální hodnoty: \n \n * Zkrátit hodnotu \n * Upozornit uživatele \n * Zrušit proces \n"

::msgcat::mcset $gPB(LANG) "MC(address,min,value,Label)"            "Minimum"
::msgcat::mcset $gPB(LANG) "MC(address,min,value,Context)"          "Pomocí této možnosti nastavíte minimální hodnotu slova."

::msgcat::mcset $gPB(LANG) "MC(address,min,error_handle,Label)"     "Zpracování porušení"
::msgcat::mcset $gPB(LANG) "MC(address,min,error_handle,Context)"   "Pomocí tohoto tlačítka je možné určit metodu zpracování porušení minimální hodnoty: \n \n * Zkrátit hodnotu \n * Upozornit uživatele \n * Zrušit proces \n"

::msgcat::mcset $gPB(LANG) "MC(address,format_trans,title,Label)"   "FORMAT "
::msgcat::mcset $gPB(LANG) "MC(address,none_popup,Label)"           "Nic"

::msgcat::mcset $gPB(LANG) "MC(address,exp,Label)"                  "Výraz"
::msgcat::mcset $gPB(LANG) "MC(address,exp,Context)"                "U bloku je možné určit výraz nebo konstantu."
::msgcat::mcset $gPB(LANG) "MC(address,exp,msg)"                    "Výraz prvku bloku nemůže být prázdný."
::msgcat::mcset $gPB(LANG) "MC(address,exp,space_only)"             "Výraz prvku bloku používající číselný formát nemůže obsahovat pouze mezery."

## No translation is needed for this string.
::msgcat::mcset $gPB(LANG) "MC(address,exp,spec_char)"              "\!  \"  \#  \&  \'  \.  \;  \<  \=  \>  \?  \@ \[  \\  \]  \^  \`  \{  \|  \}  \~"

::msgcat::mcset $gPB(LANG) "MC(address,exp,spec_char_msg)"          "Speciální znaky \n [::msgcat::mc MC(address,exp,spec_char)] \n není možné ve výrazu pro číselná data použít."



::msgcat::mcset $gPB(LANG) "MC(address,name_msg)"                   "Neplatný název slova.\n Zadejte jiný název."
# - No translation for rapid1, rapid2 & rapid3
::msgcat::mcset $gPB(LANG) "MC(address,rapid_add_name_msg)"         "Názvy rapid1, rapid2 a rapid3 jsou rezervované pro interní použití aplikací Post Builder.\n Zadejte jiný název."

::msgcat::mcset $gPB(LANG) "MC(address,rapid1,desc)"                "Rychloposuv po podélné ose"
::msgcat::mcset $gPB(LANG) "MC(address,rapid2,desc)"                "Rychloposuv po příčné ose"
::msgcat::mcset $gPB(LANG) "MC(address,rapid3,desc)"                "Rychloposuv po ose vřetena"

##--------
## FORMAT
##
::msgcat::mcset $gPB(LANG) "MC(format,tab,Label)"                   "FORMAT"
::msgcat::mcset $gPB(LANG) "MC(format,Status)"                      "Definovat formáty"

::msgcat::mcset $gPB(LANG) "MC(format,verify,Label)"                "FORMÁT -- Ověření"
::msgcat::mcset $gPB(LANG) "MC(format,verify,Context)"              "Toto okno zobrazuje reprezentativní kód N/C, který má být na výstupu v určeném formátu."

::msgcat::mcset $gPB(LANG) "MC(format,name,Label)"                  "Název formátu"
::msgcat::mcset $gPB(LANG) "MC(format,name,Context)"                "Název formátu je možné upravit."

::msgcat::mcset $gPB(LANG) "MC(format,data,type,Label)"             "Datový typ"
::msgcat::mcset $gPB(LANG) "MC(format,data,type,Context)"           "Pomocí této možnosti je možné pro formát určit datový typ."
::msgcat::mcset $gPB(LANG) "MC(format,data,num,Label)"              "Číselné"
::msgcat::mcset $gPB(LANG) "MC(format,data,num,Context)"            "Pomocí této možnosti je možné nastavit datový typ formátu na číselný."
::msgcat::mcset $gPB(LANG) "MC(format,data,num,integer,Label)"      "FORMÁT -- Počet celých číslic"
::msgcat::mcset $gPB(LANG) "MC(format,data,num,integer,Context)"    "Pomocí této možnosti je možné určit počet číslic celého čísla nebo celé části desetinného (reálného) čísla."
::msgcat::mcset $gPB(LANG) "MC(format,data,num,fraction,Label)"     "FORMÁT -- Počet desetinných míst"
::msgcat::mcset $gPB(LANG) "MC(format,data,num,fraction,Context)"   "Pomocí této možnosti je možné určit počet číslic v desetinné části reálného čísla."
::msgcat::mcset $gPB(LANG) "MC(format,data,num,decimal,Label)"      "Výstup desetinné tečky (.)"
::msgcat::mcset $gPB(LANG) "MC(format,data,num,decimal,Context)"    "Pomocí této možnosti je možné do výstupu kódu N/C vložit desetinné tečky."
::msgcat::mcset $gPB(LANG) "MC(format,data,num,lead,Label)"         "Výstup počátečních nul"
::msgcat::mcset $gPB(LANG) "MC(format,data,num,lead,Context)"       "Pomocí této možnosti je možné k číslům v kódu N/C přidat počáteční nuly."
::msgcat::mcset $gPB(LANG) "MC(format,data,num,trail,Label)"        "Výstup koncových nul"
::msgcat::mcset $gPB(LANG) "MC(format,data,num,trail,Context)"      "Pomocí této možnosti je možné za desetinná (reálná) čísla v kódu N/C přidat koncové nuly."
::msgcat::mcset $gPB(LANG) "MC(format,data,text,Label)"             "Text"
::msgcat::mcset $gPB(LANG) "MC(format,data,text,Context)"           "Pomocí této možnosti je možné nastavit datový typ formátu na textový řetězec."
::msgcat::mcset $gPB(LANG) "MC(format,data,plus,Label)"             "Výstup počátečního znaménka plus (+)"
::msgcat::mcset $gPB(LANG) "MC(format,data,plus,Context)"           "Pomocí této možnosti je možné do výstupu kódu N/C vložit znaménka plus."
::msgcat::mcset $gPB(LANG) "MC(format,zero_msg)"                    "Formát nuly není možné kopírovat"
::msgcat::mcset $gPB(LANG) "MC(format,zero_cut_msg)"                "Formát nuly není možné odstranit"

::msgcat::mcset $gPB(LANG) "MC(format,data,dec_zero,msg)"           "Je nutné vybrat alespoň jednu z možností Desetinná tečka, Počáteční nuly nebo Koncové nuly."

::msgcat::mcset $gPB(LANG) "MC(format,data,no_digit,msg)"           "Počet číslic celé části a desetinné části nemůže být v obou případech nulový."

::msgcat::mcset $gPB(LANG) "MC(format,name_msg)"                    "Neplatný název formátu.\n Zadejte jiný název."
::msgcat::mcset $gPB(LANG) "MC(format,error,title)"                 "Chyba formátu"
::msgcat::mcset $gPB(LANG) "MC(format,error,msg)"                   "Tento formát byl použit v adresách"

##---------------------
## Other Data Elements
##
::msgcat::mcset $gPB(LANG) "MC(other,tab,Label)"                    "Jiné datové prvky"
::msgcat::mcset $gPB(LANG) "MC(other,Status)"                       "Určit parametry"

::msgcat::mcset $gPB(LANG) "MC(other,seq_num,Label)"                "Číslo posloupnosti"
::msgcat::mcset $gPB(LANG) "MC(other,seq_num,Context)"              "Pomocí tohoto přepínače je možné povolit/zakázat výstup čísel posloupnosti v kódu N/C."
::msgcat::mcset $gPB(LANG) "MC(other,seq_num,start,Label)"          "Počátek čísla posloupnosti"
::msgcat::mcset $gPB(LANG) "MC(other,seq_num,start,Context)"        "Pomocí této možnosti je možné určit počátek čísel posloupnosti."
::msgcat::mcset $gPB(LANG) "MC(other,seq_num,inc,Label)"            "Přírůstek čísla posloupnosti"
::msgcat::mcset $gPB(LANG) "MC(other,seq_num,inc,Context)"          "Pomocí této možnosti je možné určit přírůstek čísel posloupnosti."
::msgcat::mcset $gPB(LANG) "MC(other,seq_num,freq,Label)"           "Frekvence čísla posloupnosti"
::msgcat::mcset $gPB(LANG) "MC(other,seq_num,freq,Context)"         "Pomocí této možnosti je možné určit frekvenci toho, jak často se čísla posloupnosti zobrazují v kódu N/C."
::msgcat::mcset $gPB(LANG) "MC(other,seq_num,max,Label)"            "Maximum čísla posloupnosti"
::msgcat::mcset $gPB(LANG) "MC(other,seq_num,max,Context)"          "Pomocí této možnosti je možné určit maximální hodnotu čísel posloupnosti."

::msgcat::mcset $gPB(LANG) "MC(other,chars,Label)"                  "Speciální znaky"
::msgcat::mcset $gPB(LANG) "MC(other,chars,word_sep,Label)"         "Oddělovač slov"
::msgcat::mcset $gPB(LANG) "MC(other,chars,word_sep,Context)"       "Pomocí této možnosti je možné určit znaky, které se mají použít jako oddělovač slov."
::msgcat::mcset $gPB(LANG) "MC(other,chars,decimal_pt,Label)"       "Desetinná tečka"
::msgcat::mcset $gPB(LANG) "MC(other,chars,decimal_pt,Context)"     "Pomocí této možnosti je možné určit znak, který se použije jako desetinná tečka."
::msgcat::mcset $gPB(LANG) "MC(other,chars,end_of_block,Label)"     "Konec bloku"
::msgcat::mcset $gPB(LANG) "MC(other,chars,end_of_block,Context)"   "Pomocí této možnosti je možné určit znak, který se použije jako konec bloku."
::msgcat::mcset $gPB(LANG) "MC(other,chars,comment_start,Label)"    "Počátek zprávy"
::msgcat::mcset $gPB(LANG) "MC(other,chars,comment_start,Context)"  "Pomocí této možnosti je možné určit znaky, které se použijí jako počátek řádku zprávy operátoru."
::msgcat::mcset $gPB(LANG) "MC(other,chars,comment_end,Label)"      "Konec zprávy"
::msgcat::mcset $gPB(LANG) "MC(other,chars,comment_end,Context)"    "Pomocí této možnosti je možné určit znaky, které se použijí jako konec řádku zprávy operátoru."

::msgcat::mcset $gPB(LANG) "MC(other,opskip,Label)"                 "OPSKIP"
::msgcat::mcset $gPB(LANG) "MC(other,opskip,leader,Label)"          "Odkazová čára"
::msgcat::mcset $gPB(LANG) "MC(other,opskip,leader,Context)"        "Odkazová čára OPSKIP"

::msgcat::mcset $gPB(LANG) "MC(other,gm_codes,Label)"               "Výstup G-kódů a M-kódů na blok"
::msgcat::mcset $gPB(LANG) "MC(other,g_codes,Label)"                "Počet G-kódů na blok"
::msgcat::mcset $gPB(LANG) "MC(other,g_codes,Context)"              "Pomocí tohoto přepínače je možné povolit/zakázat řízení počtu G-kódů na výstupní blok N/C."
::msgcat::mcset $gPB(LANG) "MC(other,g_codes,num,Label)"            "Počet G-kódů"
::msgcat::mcset $gPB(LANG) "MC(other,g_codes,num,Context)"          "Pomocí této možnosti je možné určit počet G-kódů na výstupní blok N/C."
::msgcat::mcset $gPB(LANG) "MC(other,m_codes,Label)"                "Počet M-kódů"
::msgcat::mcset $gPB(LANG) "MC(other,m_codes,Context)"              "Pomocí tohoto přepínače je možné povolit/zakázat řízení počtu M-kódů na výstupní blok N/C."
::msgcat::mcset $gPB(LANG) "MC(other,m_codes,num,Label)"            "Počet M-kódů na blok"
::msgcat::mcset $gPB(LANG) "MC(other,m_codes,num,Context)"          "Pomocí této možnosti je možné určit počet M-kódů na výstupní blok N/C."

::msgcat::mcset $gPB(LANG) "MC(other,opt_none,Label)"               "Nic"
::msgcat::mcset $gPB(LANG) "MC(other,opt_space,Label)"              "Mezera"
::msgcat::mcset $gPB(LANG) "MC(other,opt_dec,Label)"                "Desetinný (.)"
::msgcat::mcset $gPB(LANG) "MC(other,opt_comma,Label)"              "Čárka (,)"
::msgcat::mcset $gPB(LANG) "MC(other,opt_semi,Label)"               "Středník (;)"
::msgcat::mcset $gPB(LANG) "MC(other,opt_colon,Label)"              "Dvojtečka (:)"
::msgcat::mcset $gPB(LANG) "MC(other,opt_text,Label)"               "Řetězec textu"
::msgcat::mcset $gPB(LANG) "MC(other,opt_left,Label)"               "Levá závorka ("
::msgcat::mcset $gPB(LANG) "MC(other,opt_right,Label)"              "Pravá závorka )"
::msgcat::mcset $gPB(LANG) "MC(other,opt_pound,Label)"              "Znak libry (\#)"
::msgcat::mcset $gPB(LANG) "MC(other,opt_aster,Label)"              "Hvězdička (*)"
::msgcat::mcset $gPB(LANG) "MC(other,opt_slash,Label)"              "Lomítko (/)"
::msgcat::mcset $gPB(LANG) "MC(other,opt_new_line,Label)"           "Nový řádek (\\012)"

# UDE Inclusion
::msgcat::mcset $gPB(LANG) "MC(other,ude,Label)"                    "Uživatelské události"
::msgcat::mcset $gPB(LANG) "MC(other,ude_include,Label)"            "Zahrnout jiný soubor CDL"
::msgcat::mcset $gPB(LANG) "MC(other,ude_include,Context)"          "Pomocí této možnosti je možné nastavit, aby tento postprocesor zahrnul odkaz na soubor CDL ve svém souboru definice."

::msgcat::mcset $gPB(LANG) "MC(other,ude_file,Label)"               "Název souboru CDL"
::msgcat::mcset $gPB(LANG) "MC(other,ude_file,Context)"             "Cesta a název souboru CDL, který má být odkazován (INCLUDE) v souboru definice tohoto postprocesoru.  Název cesty musí začínat proměnnou prostředí UG (\\\$UGII) nebo žádnou.  Pokud není určena žádná cesta, použije UG/NX k nalezení souboru za běhu položku UGII_CAM_FILE_SEARCH_PATH."
::msgcat::mcset $gPB(LANG) "MC(other,ude_select,Label)"             "Vybrat název"
::msgcat::mcset $gPB(LANG) "MC(other,ude_select,Context)"           "Umožňuje výběr souboru CDL, který má být odkazován (INCLUDE) v souboru definice tohoto postprocesoru.  Ve výchozím stavu bude na začátek názvu vybraného souboru přidána předpona \\\$UGII_CAM_USER_DEF_EVENT_DIR/.  Název cesty je možné po výběru upravit."


#+++++++++++++++++
# Output Settings
#+++++++++++++++++
::msgcat::mcset $gPB(LANG) "MC(output,tab,Label)"                   "Nastavení výstupu"
::msgcat::mcset $gPB(LANG) "MC(output,Status)"                      "Konfigurovat výstupní parametry"

#++++++++++++++
# VNC Controls
#++++++++++++++
::msgcat::mcset $gPB(LANG) "MC(output,vnc,Label)"                   "Virtuální řídicí systém N/C"
::msgcat::mcset $gPB(LANG) "MC(output,vnc,mode,std,Label)"          "Samostatný"
::msgcat::mcset $gPB(LANG) "MC(output,vnc,mode,sub,Label)"          "Podřízený"
::msgcat::mcset $gPB(LANG) "MC(output,vnc,status,Label)"            "Vybrat soubor VNC."
::msgcat::mcset $gPB(LANG) "MC(output,vnc,mis_match,Label)"         "Vybraný soubor neodpovídá výchozímu názvu souboru VNC.\n Chcete vybrat soubor znovu?"
::msgcat::mcset $gPB(LANG) "MC(output,vnc,output,Label)"            "Generovat virtuální řídicí systém N/C (VNC)"
::msgcat::mcset $gPB(LANG) "MC(output,vnc,output,Context)"          "Pomocí této možnosti je možné vygenerovat virtuální řídicí systém N/C (VNC).  Vytvořený postprocesor se zapnutým VNC může být použit pro ISV."
::msgcat::mcset $gPB(LANG) "MC(output,vnc,main,Label)"              "Hlavní VNC"
::msgcat::mcset $gPB(LANG) "MC(output,vnc,main,Context)"            "Název hlavního VNC, který bude dodán podřízeným VNC.  Za běhu ISV se bude tento postprocesor nejspíše nacházet v adresáři, ve kterém bude podřízený VNC, v opačném případě se použije postprocesor se stejným názvem v adresáři \\\$UGII_CAM_POST_DIR."


::msgcat::mcset $gPB(LANG) "MC(output,vnc,main,err_msg)"                 "Hlavní VNC je nutné určit pro podřízený VNC."
::msgcat::mcset $gPB(LANG) "MC(output,vnc,main,select_name,Label)"       "Vybrat název"
::msgcat::mcset $gPB(LANG) "MC(output,vnc,main,select_name,Context)"     "Umožňuje vybrat název VNC, který bude dodán podřízeným VNC.  Za běhu ISV se bude tento postprocesor nejspíše nacházet v adresáři, ve kterém bude podřízený VNC, v opačném případě se použije postprocesor se stejným názvem v adresáři \\\$UGII_CAM_POST_DIR."

::msgcat::mcset $gPB(LANG) "MC(output,vnc,mode,Label)"                   "Režim virtuálního řídicího systému N/C"
::msgcat::mcset $gPB(LANG) "MC(output,vnc,mode,Context)"                 "Virtuální řídicí systém N/C může být buď Samostatný, nebo Podřízený vůči hlavnímu VNC."
::msgcat::mcset $gPB(LANG) "MC(output,vnc,mode,std,Context)"             "Samostatný VNC je sám o sobě již kompletní."
::msgcat::mcset $gPB(LANG) "MC(output,vnc,mode,sub,Context)"             "Podřízený VNC je z velké části závislý na hlavním VNC.  Dodá hlavní VNC za běhu ISV."
::msgcat::mcset $gPB(LANG) "MC(output,vnc,pb_ver,msg)"                   "Virtuální řídicí systém N/C vytvořený aplikací Post Builder "
#++++++++++++++
# Listing File
#++++++++++++++
::msgcat::mcset $gPB(LANG) "MC(listing,tab,Label)"                  "Soubor výpisu"
::msgcat::mcset $gPB(LANG) "MC(listing,Status)"                     "Určit parametry souboru výpisu"

::msgcat::mcset $gPB(LANG) "MC(listing,gen,Label)"                  "Vygenerovat soubor výpisu"
::msgcat::mcset $gPB(LANG) "MC(listing,gen,Context)"                "Pomocí tohoto přepínače je možné povolit/zakázat výstup souboru výpisu."

::msgcat::mcset $gPB(LANG) "MC(listing,Label)"                      "Prvky souboru výpisu"
::msgcat::mcset $gPB(LANG) "MC(listing,parms,Label)"                "Komponenta"

::msgcat::mcset $gPB(LANG) "MC(listing,parms,x,Label)"              "Souřadnice X"
::msgcat::mcset $gPB(LANG) "MC(listing,parms,x,Context)"            "Pomocí tohoto přepínače je možné povolit/zakázat výstup souřadnice X do souboru výpisu."

::msgcat::mcset $gPB(LANG) "MC(listing,parms,y,Label)"              "Souřadnice Y"
::msgcat::mcset $gPB(LANG) "MC(listing,parms,y,Context)"            "Pomocí tohoto přepínače je možné povolit/zakázat výstup souřadnice Y do souboru výpisu."

::msgcat::mcset $gPB(LANG) "MC(listing,parms,z,Label)"              "Souřadnice Z"
::msgcat::mcset $gPB(LANG) "MC(listing,parms,z,Context)"            "Pomocí tohoto přepínače je možné povolit/zakázat výstup souřadnice Z do souboru výpisu."

::msgcat::mcset $gPB(LANG) "MC(listing,parms,4,Label)"              "Úhel čtvrté osy"
::msgcat::mcset $gPB(LANG) "MC(listing,parms,4,Context)"            "Pomocí tohoto přepínače je možné povolit/zakázat výstup úhlu čtvrté osy do souboru výpisu."

::msgcat::mcset $gPB(LANG) "MC(listing,parms,5,Label)"              "Úhel páté osy"
::msgcat::mcset $gPB(LANG) "MC(listing,parms,5,Context)"            "Pomocí tohoto přepínače je možné povolit/zakázat výstup úhlu páté osy do souboru výpisu."

::msgcat::mcset $gPB(LANG) "MC(listing,parms,feed,Label)"           "Posuv"
::msgcat::mcset $gPB(LANG) "MC(listing,parms,feed,Context)"         "Pomocí tohoto přepínače je možné povolit/zakázat výstup rychlosti posuvu do souboru výpisu."

::msgcat::mcset $gPB(LANG) "MC(listing,parms,speed,Label)"          "Rychlost"
::msgcat::mcset $gPB(LANG) "MC(listing,parms,speed,Context)"        "Pomocí tohoto přepínače je možné povolit/zakázat výstup rychlosti vřetena do souboru výpisu."

::msgcat::mcset $gPB(LANG) "MC(listing,extension,Label)"            "Přípona souboru výpisu"
::msgcat::mcset $gPB(LANG) "MC(listing,extension,Context)"          "Umožňuje určit příponu souboru výpisu"

::msgcat::mcset $gPB(LANG) "MC(listing,nc_file,Label)"              "Přípona výstupního souboru N/C"
::msgcat::mcset $gPB(LANG) "MC(listing,nc_file,Context)"            "Umožňuje určit příponu výstupního souboru N/C"

::msgcat::mcset $gPB(LANG) "MC(listing,header,Label)"               "Záhlaví programu"
::msgcat::mcset $gPB(LANG) "MC(listing,header,oper_list,Label)"     "Seznam operací"
::msgcat::mcset $gPB(LANG) "MC(listing,header,tool_list,Label)"     "Seznam nástrojů"

::msgcat::mcset $gPB(LANG) "MC(listing,footer,Label)"               "Zápatí programu"
::msgcat::mcset $gPB(LANG) "MC(listing,footer,cut_time,Label)"      "Celkový čas obrábění"

::msgcat::mcset $gPB(LANG) "MC(listing,format,Label)"                   "Formát stránky"
::msgcat::mcset $gPB(LANG) "MC(listing,format,print_header,Label)"      "Tisk záhlaví stránky"
::msgcat::mcset $gPB(LANG) "MC(listing,format,print_header,Context)"    "Pomocí tohoto přepínače je možné povolit/zakázat výstup záhlaví stránky do souboru výpisu."

::msgcat::mcset $gPB(LANG) "MC(listing,format,length,Label)"        "Délka stránky (řádky)"
::msgcat::mcset $gPB(LANG) "MC(listing,format,length,Context)"      "Určuje počet řádků na stránku pro soubor výpisu."
::msgcat::mcset $gPB(LANG) "MC(listing,format,width,Label)"         "Šířka stránky (sloupce)"
::msgcat::mcset $gPB(LANG) "MC(listing,format,width,Context)"       "Určuje počet sloupců na stránku pro soubor výpisu."

::msgcat::mcset $gPB(LANG) "MC(listing,other,tab,Label)"            "Další možnosti"
::msgcat::mcset $gPB(LANG) "MC(listing,output,Label)"               "Výstup řídicích prvků"

::msgcat::mcset $gPB(LANG) "MC(listing,output,warning,Label)"       "Výstup zpráv upozornění"
::msgcat::mcset $gPB(LANG) "MC(listing,output,warning,Context)"     "Pomocí tohoto přepínače je možné povolit/zakázat výstup upozornění během postprocesingu."

::msgcat::mcset $gPB(LANG) "MC(listing,output,review,Label)"        "Aktivovat kontrolní nástroj"
::msgcat::mcset $gPB(LANG) "MC(listing,output,review,Context)"      "Pomocí tohoto přepínače je možné aktivovat kontrolní nástroj během postprocesingu."

::msgcat::mcset $gPB(LANG) "MC(listing,output,group,Label)"         "Generovat výstup skupiny"
::msgcat::mcset $gPB(LANG) "MC(listing,output,group,Context)"       "Pomocí tohoto přepínače je možné povolit/zakázat řízení výstupu skupiny během postprocesingu."

::msgcat::mcset $gPB(LANG) "MC(listing,output,verbose,Label)"       "Zobrazit rozvláčné chybové zprávy"
::msgcat::mcset $gPB(LANG) "MC(listing,output,verbose,Context)"     "Pomocí tohoto přepínače je možné zobrazit rozšířené popisy chybových stavů. Tím může dojít k mírnému zpomalení rychlosti postprocesingu."

::msgcat::mcset $gPB(LANG) "MC(listing,oper_info,Label)"            "Informace o operaci"
::msgcat::mcset $gPB(LANG) "MC(listing,oper_info,parms,Label)"      "Parametry operace"
::msgcat::mcset $gPB(LANG) "MC(listing,oper_info,tool,Label)"       "Parametry nástroje"
::msgcat::mcset $gPB(LANG) "MC(listing,oper_info,cut_time,,Label)"  "Čas obrábění"


#<09-19-00 gsl>
::msgcat::mcset $gPB(LANG) "MC(listing,user_tcl,frame,Label)"       "Uživatelský zdroj Tcl"
::msgcat::mcset $gPB(LANG) "MC(listing,user_tcl,check,Label)"       "Dodat uživatelský soubor Tcl"
::msgcat::mcset $gPB(LANG) "MC(listing,user_tcl,check,Context)"     "Pomocí tohoto přepínače je možné dodat vlastní soubor Tcl"
::msgcat::mcset $gPB(LANG) "MC(listing,user_tcl,name,Label)"        "Název souboru"
::msgcat::mcset $gPB(LANG) "MC(listing,user_tcl,name,Context)"      "Tato možnost umožňuje zadat název souboru Tcl, který má být pro tento postprocesor dodán"

#++++++++++++++++
# Output Preview
#++++++++++++++++
::msgcat::mcset $gPB(LANG) "MC(preview,tab,Label)"                  "Náhled souborů postprocesoru"
::msgcat::mcset $gPB(LANG) "MC(preview,new_code,Label)"             "Nový kód"
::msgcat::mcset $gPB(LANG) "MC(preview,old_code,Label)"             "Starý kód"

##---------------------
## Event Handler
##
::msgcat::mcset $gPB(LANG) "MC(event_handler,tab,Label)"            "Ovladače událostí"
::msgcat::mcset $gPB(LANG) "MC(event_handler,Status)"               "Vybrat událost k zobrazení procedury"

##---------------------
## Definition
##
::msgcat::mcset $gPB(LANG) "MC(definition,tab,Label)"               "Definice"
::msgcat::mcset $gPB(LANG) "MC(definition,Status)"                  "Vybrat položku k zobrazení obsahu"

#++++++++++++++
# Post Advisor
#++++++++++++++
::msgcat::mcset $gPB(LANG) "MC(advisor,tab,Label)"                  "Poradce postprocesoru"
::msgcat::mcset $gPB(LANG) "MC(advisor,Status)"                     "Poradce postprocesoru"

::msgcat::mcset $gPB(LANG) "MC(definition,word_txt,Label)"          "WORD_SEPARATOR"
::msgcat::mcset $gPB(LANG) "MC(definition,end_txt,Label)"           "END_OF_BLOCK"
::msgcat::mcset $gPB(LANG) "MC(definition,seq_txt,Label)"           "SEQUENCE_NUM"
::msgcat::mcset $gPB(LANG) "MC(definition,include,Label)"           "INCLUDE"
::msgcat::mcset $gPB(LANG) "MC(definition,format_txt,Label)"        "FORMÁT"
::msgcat::mcset $gPB(LANG) "MC(definition,addr_txt,Label)"          "SLOVO"
::msgcat::mcset $gPB(LANG) "MC(definition,block_txt,Label)"         "BLOK"
::msgcat::mcset $gPB(LANG) "MC(definition,comp_txt,Label)"          "Složený BLOK"
::msgcat::mcset $gPB(LANG) "MC(definition,post_txt,Label)"          "BLOK postprocesoru"
::msgcat::mcset $gPB(LANG) "MC(definition,oper_txt,Label)"          "BLOK prázdné zprávy"

#+++++++++++++
# Balloon
#+++++++++++++
::msgcat::mcset $gPB(LANG) "MC(msg,odd)"                            "Podivný počet volitelných argumentů"
::msgcat::mcset $gPB(LANG) "MC(msg,wrong_list_1)"                   "Neznámé možnosti"
::msgcat::mcset $gPB(LANG) "MC(msg,wrong_list_2)"                   ". Musí být jedna z položek:"

#+++++++++++++++++
# Event UI Labels
#+++++++++++++++++

### Program Start
::msgcat::mcset $gPB(LANG) "MC(event,start_prog,name)"              "Počátek programu"

### Operation Start
::msgcat::mcset $gPB(LANG) "MC(event,opr_start,start_path,name)"    "Počátek dráhy"
::msgcat::mcset $gPB(LANG) "MC(event,opr_start,from_move,name)"     "Posun Od"
::msgcat::mcset $gPB(LANG) "MC(event,opr_start,fst_tool,name)"      "První nástroj"
::msgcat::mcset $gPB(LANG) "MC(event,opr_start,auto_tc,name)"       "Automatická změna nástroje"
::msgcat::mcset $gPB(LANG) "MC(event,opr_start,manual_tc,name)"     "Ruční změna nástroje"
::msgcat::mcset $gPB(LANG) "MC(event,opr_start,init_move,name)"     "Počáteční posun"
::msgcat::mcset $gPB(LANG) "MC(event,opr_start,fst_move,name)"      "První posun"
::msgcat::mcset $gPB(LANG) "MC(event,opr_start,appro_move,name)"    "Posun přiblížení"
::msgcat::mcset $gPB(LANG) "MC(event,opr_start,engage_move,name)"   "Posun nájezdu"
::msgcat::mcset $gPB(LANG) "MC(event,opr_start,fst_cut,name)"       "První řez"
::msgcat::mcset $gPB(LANG) "MC(event,opr_start,fst_lin_move,name)"  "První lineární posun"
::msgcat::mcset $gPB(LANG) "MC(event,opr_start,start_pass,name)"    "Počátek průchodu"
::msgcat::mcset $gPB(LANG) "MC(event,opr_start,cutcom_move,name)"   "Posun poloměrové korekce"
::msgcat::mcset $gPB(LANG) "MC(event,opr_start,lead_move,name)"     "Posun nájezdu"

### Operation End
::msgcat::mcset $gPB(LANG) "MC(event,opr_end,ret_move,name)"        "Posun odjezdu"
::msgcat::mcset $gPB(LANG) "MC(event,opr_end,rtn_move,name)"        "Posun odjezdu"
::msgcat::mcset $gPB(LANG) "MC(event,opr_end,goh_move,name)"        "Konečný posun"
::msgcat::mcset $gPB(LANG) "MC(event,opr_end,end_path,name)"        "Konec dráhy"
::msgcat::mcset $gPB(LANG) "MC(event,opr_end,lead_move,name)"       "Posun odjezdu"
::msgcat::mcset $gPB(LANG) "MC(event,opr_end,end_pass,name)"        "Konec průchodu"

### Program End
::msgcat::mcset $gPB(LANG) "MC(event,end_prog,name)"                "Konec programu"


### Tool Change
::msgcat::mcset $gPB(LANG) "MC(event,tool_change,name)"             "Výměna nástroje"
::msgcat::mcset $gPB(LANG) "MC(event,tool_change,m_code)"           "M-kód"
::msgcat::mcset $gPB(LANG) "MC(event,tool_change,m_code,tl_chng)"   "Výměna nástroje"
::msgcat::mcset $gPB(LANG) "MC(event,tool_change,m_code,pt)"        "Primární nožová hlava"
::msgcat::mcset $gPB(LANG) "MC(event,tool_change,m_code,st)"        "Sekundární nožová hlava"
::msgcat::mcset $gPB(LANG) "MC(event,tool_change,t_code)"           "T-kód"
::msgcat::mcset $gPB(LANG) "MC(event,tool_change,t_code,conf)"      "Konfigurovat"
::msgcat::mcset $gPB(LANG) "MC(event,tool_change,t_code,pt_idx)"    "Index primární nožové hlavy"
::msgcat::mcset $gPB(LANG) "MC(event,tool_change,t_code,st_idx)"    "Index sekundární nožové hlavy"
::msgcat::mcset $gPB(LANG) "MC(event,tool_change,tool_num)"         "Číslo nástroje"
::msgcat::mcset $gPB(LANG) "MC(event,tool_change,tool_num,min)"     "Minimum"
::msgcat::mcset $gPB(LANG) "MC(event,tool_change,tool_num,max)"     "Maximum"
::msgcat::mcset $gPB(LANG) "MC(event,tool_change,time)"             "Čas (s)"
::msgcat::mcset $gPB(LANG) "MC(event,tool_change,time,tl_chng)"     "Výměna nástroje"
::msgcat::mcset $gPB(LANG) "MC(event,tool_change,retract)"          "Odjezd"
::msgcat::mcset $gPB(LANG) "MC(event,tool_change,retract_z)"        "Odjezd k Z z"

### Length Compensation
::msgcat::mcset $gPB(LANG) "MC(event,length_compn,name)"            "Kompenzace délky"
::msgcat::mcset $gPB(LANG) "MC(event,length_compn,g_code)"          "G-kód"
::msgcat::mcset $gPB(LANG) "MC(event,length_compn,g_code,len_adj)"  "Přizpůsobení délky nástroje"
::msgcat::mcset $gPB(LANG) "MC(event,length_compn,t_code)"          "T-kód"
::msgcat::mcset $gPB(LANG) "MC(event,length_compn,t_code,conf)"     "Konfigurovat"
::msgcat::mcset $gPB(LANG) "MC(event,length_compn,len_off)"         "Registr odsazení délky"
::msgcat::mcset $gPB(LANG) "MC(event,length_compn,len_off,min)"     "Minimum"
::msgcat::mcset $gPB(LANG) "MC(event,length_compn,len_off,max)"     "Maximum"

### Set Modes
::msgcat::mcset $gPB(LANG) "MC(event,set_modes,name)"               "Nastavit režimy"
::msgcat::mcset $gPB(LANG) "MC(event,set_modes,out_mode)"           "Režim výstupu"
::msgcat::mcset $gPB(LANG) "MC(event,set_modes,g_code)"             "G-kód"
::msgcat::mcset $gPB(LANG) "MC(event,set_modes,g_code,absolute)"    "Absolutní"
::msgcat::mcset $gPB(LANG) "MC(event,set_modes,g_code,incremental)" "Přírůstek"
::msgcat::mcset $gPB(LANG) "MC(event,set_modes,rotary_axis)"        "Osa otáčení může být přírůstková"

### Spindle RPM
::msgcat::mcset $gPB(LANG) "MC(event,spindle_rpm,name)"                     "Otáčky vřetena"
::msgcat::mcset $gPB(LANG) "MC(event,spindle_rpm,dir_m_code)"               "M-kódy směru vřetena"
::msgcat::mcset $gPB(LANG) "MC(event,spindle_rpm,dir_m_code,cw)"            "Po směru hodin (CW)"
::msgcat::mcset $gPB(LANG) "MC(event,spindle_rpm,dir_m_code,ccw)"           "Proti směru hodin (CCW)"
::msgcat::mcset $gPB(LANG) "MC(event,spindle_rpm,range_control)"            "Řízení rozsahu vřetena"
::msgcat::mcset $gPB(LANG) "MC(event,spindle_rpm,range_control,dwell_time)" "Časová prodleva změny rozsahu (s)"
::msgcat::mcset $gPB(LANG) "MC(event,spindle_rpm,range_control,range_code)" "Určit kód rozsahu"

### Spindle CSS
::msgcat::mcset $gPB(LANG) "MC(event,spindle_css,name)"             "CSS vřetena"
::msgcat::mcset $gPB(LANG) "MC(event,spindle_css,g_code)"           "G-kód vřetena"
::msgcat::mcset $gPB(LANG) "MC(event,spindle_css,g_code,const)"     "Kód konstantní plochy"
::msgcat::mcset $gPB(LANG) "MC(event,spindle_css,g_code,max)"       "Kód maximálních ot/min"
::msgcat::mcset $gPB(LANG) "MC(event,spindle_css,g_code,sfm)"       "Kód ke stornu SFM"
::msgcat::mcset $gPB(LANG) "MC(event,spindle_css,max)"              "Maximální ot/min během CSS"
::msgcat::mcset $gPB(LANG) "MC(event,spindle_css,sfm)"              "Neustálý režim IPR pro SFM"

### Spindle Off
::msgcat::mcset $gPB(LANG) "MC(event,spindle_off,name)"             "Vřeteno vypnuto"
::msgcat::mcset $gPB(LANG) "MC(event,spindle_off,dir_m_code)"       "M-kód směru vřetena"
::msgcat::mcset $gPB(LANG) "MC(event,spindle_off,dir_m_code,off)"   "Vypnuto"

### Coolant On
::msgcat::mcset $gPB(LANG) "MC(event,coolant_on,name)"              "Chlazení je zapnuto"
::msgcat::mcset $gPB(LANG) "MC(event,coolant_on,m_code)"            "M-kód"
::msgcat::mcset $gPB(LANG) "MC(event,coolant_on,m_code,on)"         "ZAPNUTO"
::msgcat::mcset $gPB(LANG) "MC(event,coolant_on,m_code,flood)"      "Kapalina"
::msgcat::mcset $gPB(LANG) "MC(event,coolant_on,m_code,mist)"       "Mlha"
::msgcat::mcset $gPB(LANG) "MC(event,coolant_on,m_code,thru)"       "Skrz"
::msgcat::mcset $gPB(LANG) "MC(event,coolant_on,m_code,tap)"        "Závitování"

### Coolant Off
::msgcat::mcset $gPB(LANG) "MC(event,coolant_off,name)"             "Chlazení je vypnuto"
::msgcat::mcset $gPB(LANG) "MC(event,coolant_off,m_code)"           "M-kód"
::msgcat::mcset $gPB(LANG) "MC(event,coolant_off,m_code,off)"       "Vypnuto"

### Inch Metric Mode
::msgcat::mcset $gPB(LANG) "MC(event,inch_metric_mode,name)"            "Metrický režim v palcích"
::msgcat::mcset $gPB(LANG) "MC(event,inch_metric_mode,g_code)"          "G-kód"
::msgcat::mcset $gPB(LANG) "MC(event,inch_metric_mode,g_code,english)"  "Britské (palce)"
::msgcat::mcset $gPB(LANG) "MC(event,inch_metric_mode,g_code,metric)"   "Metrické (milimetry)"

### Feedrates
::msgcat::mcset $gPB(LANG) "MC(event,feedrates,name)"               "Rychlosti posuvu"
::msgcat::mcset $gPB(LANG) "MC(event,feedrates,ipm_mode)"           "Režim IPM"
::msgcat::mcset $gPB(LANG) "MC(event,feedrates,ipr_mode)"           "Režim IPR"
::msgcat::mcset $gPB(LANG) "MC(event,feedrates,dpm_mode)"           "Režim DPM"
::msgcat::mcset $gPB(LANG) "MC(event,feedrates,mmpm_mode)"          "Režim MMPM"
::msgcat::mcset $gPB(LANG) "MC(event,feedrates,mmpr_mode)"          "Režim MMPR"
::msgcat::mcset $gPB(LANG) "MC(event,feedrates,frn_mode)"           "Režim FRN"
::msgcat::mcset $gPB(LANG) "MC(event,feedrates,g_code)"             "G-kód"
::msgcat::mcset $gPB(LANG) "MC(event,feedrates,format)"             "Formát"
::msgcat::mcset $gPB(LANG) "MC(event,feedrates,max)"                "Maximum"
::msgcat::mcset $gPB(LANG) "MC(event,feedrates,min)"                "Minimum"
::msgcat::mcset $gPB(LANG) "MC(event,feedrates,mode,label)"         "Režimy rychlosti posuvu"
::msgcat::mcset $gPB(LANG) "MC(event,feedrates,mode,lin)"           "Pouze lineární"
::msgcat::mcset $gPB(LANG) "MC(event,feedrates,mode,rot)"           "Pouze otočné"
::msgcat::mcset $gPB(LANG) "MC(event,feedrates,mode,lin_rot)"       "Lineární a otočné"
::msgcat::mcset $gPB(LANG) "MC(event,feedrates,mode,rap_lin)"       "Pouze lineární rychloposuv"
::msgcat::mcset $gPB(LANG) "MC(event,feedrates,mode,rap_rot)"       "Pouze otočný rychloposuv"
::msgcat::mcset $gPB(LANG) "MC(event,feedrates,mode,rap_lin_rot)"   "Lineární a otočný rychloposuv"
::msgcat::mcset $gPB(LANG) "MC(event,feedrates,cycle_mode)"         "Cyklovat režim rychlosti posuvu"
::msgcat::mcset $gPB(LANG) "MC(event,feedrates,cycle)"              "Cyklovat"

### Cutcom On
::msgcat::mcset $gPB(LANG) "MC(event,cutcom_on,name)"               "Poloměrová korekce zapnuta"
::msgcat::mcset $gPB(LANG) "MC(event,cutcom_on,g_code)"             "G-kód"
::msgcat::mcset $gPB(LANG) "MC(event,cutcom_on,left)"               "Levý"
::msgcat::mcset $gPB(LANG) "MC(event,cutcom_on,right)"              "Pravý"
::msgcat::mcset $gPB(LANG) "MC(event,cutcom_on,app_planes)"         "Použitelné roviny"
::msgcat::mcset $gPB(LANG) "MC(event,cutcom_on,edit_planes)"        "Upravit kódy rovin"
::msgcat::mcset $gPB(LANG) "MC(event,cutcom_on,reg)"                "Index poloměrové korekce"
::msgcat::mcset $gPB(LANG) "MC(event,cutcom_on,min)"                "Minimum"
::msgcat::mcset $gPB(LANG) "MC(event,cutcom_on,max)"                "Maximum"
::msgcat::mcset $gPB(LANG) "MC(event,cutcom_on,bef)"                "Poloměrová korekce vypnuta před změnou"

### Cutcom Off
::msgcat::mcset $gPB(LANG) "MC(event,cutcom_off,name)"              "Poloměrová korekce vypnuta"
::msgcat::mcset $gPB(LANG) "MC(event,cutcom_off,g_code)"            "G-kód"
::msgcat::mcset $gPB(LANG) "MC(event,cutcom_off,off)"               "Vypnuto"

### Delay
::msgcat::mcset $gPB(LANG) "MC(event,delay,name)"                   "Zpoždění"
::msgcat::mcset $gPB(LANG) "MC(event,delay,seconds)"                "Sekundy"
::msgcat::mcset $gPB(LANG) "MC(event,delay,seconds,g_code)"         "G-Code"
::msgcat::mcset $gPB(LANG) "MC(event,delay,seconds,format)"         "Formát"
::msgcat::mcset $gPB(LANG) "MC(event,delay,out_mode)"               "Režim výstupu"
::msgcat::mcset $gPB(LANG) "MC(event,delay,out_mode,sec)"           "Pouze sekundy"
::msgcat::mcset $gPB(LANG) "MC(event,delay,out_mode,rev)"           "Pouze otáčky"
::msgcat::mcset $gPB(LANG) "MC(event,delay,out_mode,feed)"          "Závisí na rychlosti posuvu"
::msgcat::mcset $gPB(LANG) "MC(event,delay,out_mode,ivs)"           "Inverzní čas"
::msgcat::mcset $gPB(LANG) "MC(event,delay,revolution)"             "Otáčky"
::msgcat::mcset $gPB(LANG) "MC(event,delay,revolution,g_code)"      "G-Code"
::msgcat::mcset $gPB(LANG) "MC(event,delay,revolution,format)"      "Formát"

### Option Stop
::msgcat::mcset $gPB(LANG) "MC(event,opstop,name)"                  "Zastavení"

### Auxfun
::msgcat::mcset $gPB(LANG) "MC(event,auxfun,name)"                  "Auxfun"

### Prefun
::msgcat::mcset $gPB(LANG) "MC(event,prefun,name)"                  "Prefun"

### Load Tool
::msgcat::mcset $gPB(LANG) "MC(event,loadtool,name)"                "Načíst nástroj"

### Stop
::msgcat::mcset $gPB(LANG) "MC(event,stop,name)"                    "Zastavit"

### Tool Preselect
::msgcat::mcset $gPB(LANG) "MC(event,toolpreselect,name)"           "Předběžný výběr nástroje"

### Thread Wire
::msgcat::mcset $gPB(LANG) "MC(event,threadwire,name)"              "Závitový drát"

### Cut Wire
::msgcat::mcset $gPB(LANG) "MC(event,cutwire,name)"                 "Řezný drát"

### Wire Guides
::msgcat::mcset $gPB(LANG) "MC(event,wireguides,name)"              "Vodicí dráty"

### Linear Move
::msgcat::mcset $gPB(LANG) "MC(event,linear,name)"                  "Lineární pohyb"
::msgcat::mcset $gPB(LANG) "MC(event,linear,g_code)"                "G-kód"
::msgcat::mcset $gPB(LANG) "MC(event,linear,motion)"                "Lineární pohyb"
::msgcat::mcset $gPB(LANG) "MC(event,linear,assume)"                "Předpokládaný režim rychloposuvu při maximálním posuvu přejezdu"

### Circular Move
::msgcat::mcset $gPB(LANG) "MC(event,circular,name)"                "Kruhový posun"
::msgcat::mcset $gPB(LANG) "MC(event,circular,g_code)"              "G-kód pohybu"
::msgcat::mcset $gPB(LANG) "MC(event,circular,clockwise)"           "Po směru hodin (CLW)"
::msgcat::mcset $gPB(LANG) "MC(event,circular,counter-clock)"       "Proti směru hodin (CCLW)"
::msgcat::mcset $gPB(LANG) "MC(event,circular,record)"              "Kruhový záznam"
::msgcat::mcset $gPB(LANG) "MC(event,circular,full_circle)"         "Plná kružnice"
::msgcat::mcset $gPB(LANG) "MC(event,circular,quadrant)"            "Kvadrant"
::msgcat::mcset $gPB(LANG) "MC(event,circular,ijk_def)"             "Definice IJK"
::msgcat::mcset $gPB(LANG) "MC(event,circular,ij_def)"              "Definice IJ"
::msgcat::mcset $gPB(LANG) "MC(event,circular,ik_def)"              "Definice IK"
::msgcat::mcset $gPB(LANG) "MC(event,circular,planes)"              "Použitelné roviny"
::msgcat::mcset $gPB(LANG) "MC(event,circular,edit_planes)"         "Upravit kódy rovin"
::msgcat::mcset $gPB(LANG) "MC(event,circular,radius)"              "Poloměr"
::msgcat::mcset $gPB(LANG) "MC(event,circular,min)"                 "Minimum"
::msgcat::mcset $gPB(LANG) "MC(event,circular,max)"                 "Maximum"
::msgcat::mcset $gPB(LANG) "MC(event,circular,arc_len)"             "Minimální délka oblouku"

### Rapid Move
::msgcat::mcset $gPB(LANG) "MC(event,rapid,name)"                   "Rychlý posun"
::msgcat::mcset $gPB(LANG) "MC(event,rapid,g_code)"                 "G-kód"
::msgcat::mcset $gPB(LANG) "MC(event,rapid,motion)"                 "Rychloposuv"
::msgcat::mcset $gPB(LANG) "MC(event,rapid,plane_change)"           "Změna pracovní roviny"

### Lathe Thread
::msgcat::mcset $gPB(LANG) "MC(event,lathe,name)"                   "Soustružit závit"
::msgcat::mcset $gPB(LANG) "MC(event,lathe,g_code)"                 "G-kód závitu"
::msgcat::mcset $gPB(LANG) "MC(event,lathe,cons)"                   "Konstanta"
::msgcat::mcset $gPB(LANG) "MC(event,lathe,incr)"                   "Přírůstek"
::msgcat::mcset $gPB(LANG) "MC(event,lathe,decr)"                   "Snížení"

### Cycle
::msgcat::mcset $gPB(LANG) "MC(event,cycle,g_code)"                 "G-kód a přizpůsobení"
::msgcat::mcset $gPB(LANG) "MC(event,cycle,customize,Label)"        "Přizpůsobit"
::msgcat::mcset $gPB(LANG) "MC(event,cycle,customize,Context)"      "Pomocí tohoto přepínače je možné přizpůsobit cyklus. \n\nVe výchozím stavu je základní konstrukce každého cyklu definována nastavením Společné parametry. Tyto společné prvky v každém cyklu není možné jakkoliv upravovat. \n\nZapnutím přepínače je možné získat úplnou kontrolu nad konfigurací cyklu.  Změny společných parametrů již nadále neovlivní žádný přizpůsobený cyklus."
::msgcat::mcset $gPB(LANG) "MC(event,cycle,start,Label)"            "Start cyklu"
::msgcat::mcset $gPB(LANG) "MC(event,cycle,start,Context)"          "Tuto možnost je možné zapnout u obráběcích strojů, které provádějí cykly pomocí bloku počátku cyklu (G79...) po definování cyklu (G81...)."
::msgcat::mcset $gPB(LANG) "MC(event,cycle,start,text)"             "Použít blok počátku cyklu ke spuštění cyklu"
::msgcat::mcset $gPB(LANG) "MC(event,cycle,rapid_to)"               "Rychloposuv - K"
::msgcat::mcset $gPB(LANG) "MC(event,cycle,retract_to)"             "Odjezd - K"
::msgcat::mcset $gPB(LANG) "MC(event,cycle,plane_control)"          "Cyklovat řízení roviny"
::msgcat::mcset $gPB(LANG) "MC(event,cycle,com_param,name)"         "Společné parametry"
::msgcat::mcset $gPB(LANG) "MC(event,cycle,cycle_off,name)"         "Cyklus vypnut"
::msgcat::mcset $gPB(LANG) "MC(event,cycle,plane_chng,name)"        "Cyklovat změnu roviny"
::msgcat::mcset $gPB(LANG) "MC(event,cycle,drill,name)"             "Vrtání"
::msgcat::mcset $gPB(LANG) "MC(event,cycle,drill_dwell,name)"       "Vrtání s prodlevou"
::msgcat::mcset $gPB(LANG) "MC(event,cycle,drill_text,name)"        "Vrtání textu"
::msgcat::mcset $gPB(LANG) "MC(event,cycle,drill_csink,name)"       "Vrtání s kuž. zahloubením"
::msgcat::mcset $gPB(LANG) "MC(event,cycle,drill_deep,name)"        "Hluboké vrtání"
::msgcat::mcset $gPB(LANG) "MC(event,cycle,drill_brk_chip,name)"    "Vrtání s přerušením třísky"
::msgcat::mcset $gPB(LANG) "MC(event,cycle,tap,name)"               "Závitování"
::msgcat::mcset $gPB(LANG) "MC(event,cycle,bore,name)"              "Vývrt"
::msgcat::mcset $gPB(LANG) "MC(event,cycle,bore_dwell,name)"        "Vývrt s prodlevou"
::msgcat::mcset $gPB(LANG) "MC(event,cycle,bore_drag,name)"         "Vývrt s tahem"
::msgcat::mcset $gPB(LANG) "MC(event,cycle,bore_no_drag,name)"      "Vývrt bez tahu"
::msgcat::mcset $gPB(LANG) "MC(event,cycle,bore_back,name)"         "Vývrt zpět"
::msgcat::mcset $gPB(LANG) "MC(event,cycle,bore_manual,name)"       "Ruční vývrt"
::msgcat::mcset $gPB(LANG) "MC(event,cycle,bore_manual_dwell,name)" "Ruční vývrt s prodlevou"
::msgcat::mcset $gPB(LANG) "MC(event,cycle,peck_drill,name)"        "Přerušované vrtání"
::msgcat::mcset $gPB(LANG) "MC(event,cycle,break_chip,name)"        "Přerušit třísku"
::msgcat::mcset $gPB(LANG) "MC(event,cycle,drill_dwell_sf,name)"    "Vrtání s prodlevou (zarovnání)"
::msgcat::mcset $gPB(LANG) "MC(event,cycle,drill_deep_peck,name)"   "Hluboké vrtání (přerušované)"
::msgcat::mcset $gPB(LANG) "MC(event,cycle,bore_ream,name)"         "Vývrt (vystružení)"
::msgcat::mcset $gPB(LANG) "MC(event,cycle,bore_no-drag,name)"      "Vývrt bez tahu"

##------------
## G Code
##
::msgcat::mcset $gPB(LANG) "MC(g_code,rapid,name)"                  "Rychloposuv"
::msgcat::mcset $gPB(LANG) "MC(g_code,linear,name)"                 "Lineární pohyb"
::msgcat::mcset $gPB(LANG) "MC(g_code,circular_clw,name)"           "Kruhová interpolace ve směru hodin"
::msgcat::mcset $gPB(LANG) "MC(g_code,circular_cclw,name)"          "Kruhová interpolace proti směru hodin"
::msgcat::mcset $gPB(LANG) "MC(g_code,delay_sec,name)"              "Zpoždění (s)"
::msgcat::mcset $gPB(LANG) "MC(g_code,delay_rev,name)"              "Zpoždění (ot)"
::msgcat::mcset $gPB(LANG) "MC(g_code,pln_xy,name)"                 "Rovina XY"
::msgcat::mcset $gPB(LANG) "MC(g_code,pln_zx,name)"                 "Rovina ZX"
::msgcat::mcset $gPB(LANG) "MC(g_code,pln_yz,name)"                 "Rovina YZ"
::msgcat::mcset $gPB(LANG) "MC(g_code,cutcom_off,name)"             "Poloměrová korekce vypnuta"
::msgcat::mcset $gPB(LANG) "MC(g_code,cutcom_left,name)"            "Poloměrová korekce vlevo"
::msgcat::mcset $gPB(LANG) "MC(g_code,cutcom_right,name)"           "Poloměrová korekce vpravo"
::msgcat::mcset $gPB(LANG) "MC(g_code,length_plus,name)"            "Kladné přizpůsobení délky nástroje"
::msgcat::mcset $gPB(LANG) "MC(g_code,length_minus,name)"           "Záporné přizpůsobení délky nástroje"
::msgcat::mcset $gPB(LANG) "MC(g_code,length_off,name)"             "Přizpůsobení délky nástroje vypnuto"
::msgcat::mcset $gPB(LANG) "MC(g_code,inch,name)"                   "Palcový režim"
::msgcat::mcset $gPB(LANG) "MC(g_code,metric,name)"                 "Metrický režim"
::msgcat::mcset $gPB(LANG) "MC(g_code,cycle_start,name)"            "Kód počátku cyklu"
::msgcat::mcset $gPB(LANG) "MC(g_code,cycle_off,name)"              "Cyklus vypnut"
::msgcat::mcset $gPB(LANG) "MC(g_code,cycle_drill,name)"            "Cyklické vrtání"
::msgcat::mcset $gPB(LANG) "MC(g_code,cycle_drill_dwell,name)"      "Cyklické vrtání s prodlevou"
::msgcat::mcset $gPB(LANG) "MC(g_code,cycle_drill_deep,name)"       "Cyklické hluboké vrtání"
::msgcat::mcset $gPB(LANG) "MC(g_code,cycle_drill_bc,name)"         "Cyklické vrtání s přerušením třísky"
::msgcat::mcset $gPB(LANG) "MC(g_code,tap,name)"                    "Cyklické závitování"
::msgcat::mcset $gPB(LANG) "MC(g_code,bore,name)"                   "Cyklický vývrt"
::msgcat::mcset $gPB(LANG) "MC(g_code,bore_drag,name)"              "Cyklický vývrt s tahem"
::msgcat::mcset $gPB(LANG) "MC(g_code,bore_no_drag,name)"           "Cyklický vývrt bez tahu"
::msgcat::mcset $gPB(LANG) "MC(g_code,bore_dwell,name)"             "Cyklický vývrt s prodlevou"
::msgcat::mcset $gPB(LANG) "MC(g_code,bore_manual,name)"            "Cyklický ruční vývrt"
::msgcat::mcset $gPB(LANG) "MC(g_code,bore_back,name)"              "Cyklický vývrt zpět"
::msgcat::mcset $gPB(LANG) "MC(g_code,bore_manual_dwell,name)"      "Cyklický ruční vývrt s prodlevou"
::msgcat::mcset $gPB(LANG) "MC(g_code,abs,name)"                    "Absolutní režim"
::msgcat::mcset $gPB(LANG) "MC(g_code,inc,name)"                    "Přírůstkový režim"
::msgcat::mcset $gPB(LANG) "MC(g_code,cycle_retract_auto,name)"     "Odjezd cyklu (AUTO)"
::msgcat::mcset $gPB(LANG) "MC(g_code,cycle_retract_manual,name)"   "Odjezd cyklu (RUČNÍ)"
::msgcat::mcset $gPB(LANG) "MC(g_code,reset,name)"                  "Obnovit"
::msgcat::mcset $gPB(LANG) "MC(g_code,fr_ipm,name)"                 "Režim rychlosti posuvu IPM"
::msgcat::mcset $gPB(LANG) "MC(g_code,fr_ipr,name)"                 "Režim rychlosti posuvu IPR"
::msgcat::mcset $gPB(LANG) "MC(g_code,fr_frn,name)"                 "Režim rychlosti posuvu FRN"
::msgcat::mcset $gPB(LANG) "MC(g_code,spindle_css,name)"            "CSS vřetena"
::msgcat::mcset $gPB(LANG) "MC(g_code,spindle_rpm,name)"            "Otáčky vřetena"
::msgcat::mcset $gPB(LANG) "MC(g_code,ret_home,name)"               "Návrat do konečného bodu"
::msgcat::mcset $gPB(LANG) "MC(g_code,cons_thread,name)"            "Konstantní závit"
::msgcat::mcset $gPB(LANG) "MC(g_code,incr_thread,name)"            "Závit s přírůstkem"
::msgcat::mcset $gPB(LANG) "MC(g_code,decr_thread,name)"            "Závit se snížením"
::msgcat::mcset $gPB(LANG) "MC(g_code,feedmode_in,pm)"              "Režim rychlosti posuvu IPM"
::msgcat::mcset $gPB(LANG) "MC(g_code,feedmode_in,pr)"              "Režim rychlosti posuvu IPR"
::msgcat::mcset $gPB(LANG) "MC(g_code,feedmode_mm,pm)"              "Režim rychlosti posuvu MMPM"
::msgcat::mcset $gPB(LANG) "MC(g_code,feedmode_mm,pr)"              "Režim rychlosti posuvu MMPR"
::msgcat::mcset $gPB(LANG) "MC(g_code,feedmode,dpm)"                "Režim rychlosti posuvu DPM"

##------------
## M Code
##
::msgcat::mcset $gPB(LANG) "MC(m_code,stop_manual_tc,name)"         "Zastavit/Ruční změna nástroje"
::msgcat::mcset $gPB(LANG) "MC(m_code,stop,name)"                   "Zastavit"
::msgcat::mcset $gPB(LANG) "MC(m_code,opt_stop,name)"               "Zastavení"
::msgcat::mcset $gPB(LANG) "MC(m_code,prog_end,name)"               "Konec programu"
::msgcat::mcset $gPB(LANG) "MC(m_code,spindle_clw,name)"            "Vřeteno zapnuto/ve směru hodin"
::msgcat::mcset $gPB(LANG) "MC(m_code,spindle_cclw,name)"           "Vřeteno proti směru hodin"
::msgcat::mcset $gPB(LANG) "MC(m_code,lathe_thread,type1)"          "Konstantní závit"
::msgcat::mcset $gPB(LANG) "MC(m_code,lathe_thread,type2)"          "Závit s přírůstkem"
::msgcat::mcset $gPB(LANG) "MC(m_code,lathe_thread,type3)"          "Závit se snížením"
::msgcat::mcset $gPB(LANG) "MC(m_code,spindle_off,name)"            "Vřeteno vypnuto"
::msgcat::mcset $gPB(LANG) "MC(m_code,tc_retract,name)"             "Změna/odjezd nástroje"
::msgcat::mcset $gPB(LANG) "MC(m_code,coolant_on,name)"             "Chlazení je zapnuto"
::msgcat::mcset $gPB(LANG) "MC(m_code,coolant_fld,name)"            "Chlazení kapalinou"
::msgcat::mcset $gPB(LANG) "MC(m_code,coolant_mist,name)"           "Chlazení mlhou"
::msgcat::mcset $gPB(LANG) "MC(m_code,coolant_thru,name)"           "Chlazení skrz"
::msgcat::mcset $gPB(LANG) "MC(m_code,coolant_tap,name)"            "Chlazení závitu"
::msgcat::mcset $gPB(LANG) "MC(m_code,coolant_off,name)"            "Chlazení je vypnuto"
::msgcat::mcset $gPB(LANG) "MC(m_code,rewind,name)"                 "Převinout"
::msgcat::mcset $gPB(LANG) "MC(m_code,thread_wire,name)"            "Závitový drát"
::msgcat::mcset $gPB(LANG) "MC(m_code,cut_wire,name)"               "Řezný drát"
::msgcat::mcset $gPB(LANG) "MC(m_code,fls_on,name)"                 "Vyplachování zapnuto"
::msgcat::mcset $gPB(LANG) "MC(m_code,fls_off,name)"                "Vyplachování vypnuto"
::msgcat::mcset $gPB(LANG) "MC(m_code,power_on,name)"               "Zapnout"
::msgcat::mcset $gPB(LANG) "MC(m_code,power_off,name)"              "Vypnout"
::msgcat::mcset $gPB(LANG) "MC(m_code,wire_on,name)"                "Drát zapnut"
::msgcat::mcset $gPB(LANG) "MC(m_code,wire_off,name)"               "Drát vypnut"
::msgcat::mcset $gPB(LANG) "MC(m_code,pri_turret,name)"             "Primární nožová hlava"
::msgcat::mcset $gPB(LANG) "MC(m_code,sec_turret,name)"             "Sekundární nožová hlava"

##------------
## UDE
##
::msgcat::mcset $gPB(LANG) "MC(ude,editor,enable,Label)"            "Povolit editor UDE"
::msgcat::mcset $gPB(LANG) "MC(ude,editor,enable,as_saved,Label)"   "Jako uloženo"
::msgcat::mcset $gPB(LANG) "MC(ude,editor,TITLE)"                   "Uživatelské událost"

::msgcat::mcset $gPB(LANG) "MC(ude,editor,no_ude)"                  "Žádný odpovídající UDE!"

::msgcat::mcset $gPB(LANG) "MC(ude,editor,int,Label)"               "Celé číslo"
::msgcat::mcset $gPB(LANG) "MC(ude,editor,int,Context)"             "Přidejte nový parametr celého čísla jeho přetažením do seznamu vpravo."

::msgcat::mcset $gPB(LANG) "MC(ude,editor,real,Label)"              "Reálné"
::msgcat::mcset $gPB(LANG) "MC(ude,editor,real,Context)"            "Přidejte nový parametr reálného čísla jeho přetažením do seznamu vpravo."

::msgcat::mcset $gPB(LANG) "MC(ude,editor,txt,Label)"               "Text"
::msgcat::mcset $gPB(LANG) "MC(ude,editor,txt,Context)"             "Přidejte nový textový parametr jeho přetažením do seznamu vpravo."

::msgcat::mcset $gPB(LANG) "MC(ude,editor,bln,Label)"               "Booleovské"
::msgcat::mcset $gPB(LANG) "MC(ude,editor,bln,Context)"             "Přidejte nový booleovský parametr jeho přetažením do seznamu vpravo."

::msgcat::mcset $gPB(LANG) "MC(ude,editor,opt,Label)"               "Možnost"
::msgcat::mcset $gPB(LANG) "MC(ude,editor,opt,Context)"             "Přidejte nový parametr možnosti jeho přetažením do seznamu vpravo."

::msgcat::mcset $gPB(LANG) "MC(ude,editor,pnt,Label)"               "Bod"
::msgcat::mcset $gPB(LANG) "MC(ude,editor,pnt,Context)"             "Přidejte nový parametr bodu jeho přetažením do seznamu vpravo."

::msgcat::mcset $gPB(LANG) "MC(ude,editor,trash,Label)"             "Editor -- Koš"
::msgcat::mcset $gPB(LANG) "MC(ude,editor,trash,Context)"           "Nechtěné parametry je možné ze seznamu vpravo odstranit jejich přetažením na tento koš."

::msgcat::mcset $gPB(LANG) "MC(ude,editor,event,Label)"             "Událost"
::msgcat::mcset $gPB(LANG) "MC(ude,editor,event,Context)"           "Parametry události je možné upravit levým tlačítkem myši."

::msgcat::mcset $gPB(LANG) "MC(ude,editor,param,Label)"             "Událost -- Parametry"
::msgcat::mcset $gPB(LANG) "MC(ude,editor,param,Context)"           "Každý parametr je možné upravit kliknutím pravým tlačítkem myši nebo je možné změnit jejich pořadí přetažením.\n \nSvětle modrý parametr je definován systémem a není možné jej odstranit. \nPískově hnědý parametr není definován systémem a je možné jej upravit nebo odstranit."

::msgcat::mcset $gPB(LANG) "MC(ude,editor,param,edit,Label)"        "Parametry -- Možnost"
::msgcat::mcset $gPB(LANG) "MC(ude,editor,param,edit,Context)"      "Kliknutím levým tlačítkem myši vyberete výchozí možnost.\n Dvojitým kliknutím levým tlačítkem myši možnost upravíte."
::msgcat::mcset $gPB(LANG) "MC(ude,editor,param,editor,Label)"      "Typ parametru: "

::msgcat::mcset $gPB(LANG) "MC(ude,editor,pnt,sel,Label)"           "Vybrat"
::msgcat::mcset $gPB(LANG) "MC(ude,editor,pnt,dsp,Label)"           "Zobrazit"

::msgcat::mcset $gPB(LANG) "MC(ude,editor,dlg,ok,Label)"            "OK"
::msgcat::mcset $gPB(LANG) "MC(ude,editor,dlg,bck,Label)"           "Zadní"
::msgcat::mcset $gPB(LANG) "MC(ude,editor,dlg,cnl,Label)"           "Storno"

::msgcat::mcset $gPB(LANG) "MC(ude,editor,paramdlg,PL,Label)"       "Popisek parametru"
::msgcat::mcset $gPB(LANG) "MC(ude,editor,paramdlg,VN,Label)"       "Název proměnné"
::msgcat::mcset $gPB(LANG) "MC(ude,editor,paramdlg,DF,Label)"       "Výchozí hodnota"
::msgcat::mcset $gPB(LANG) "MC(ude,editor,paramdlg,PL,Context)"     "Určit popisek parametru"
::msgcat::mcset $gPB(LANG) "MC(ude,editor,paramdlg,VN,Context)"     "Určit název proměnné"
::msgcat::mcset $gPB(LANG) "MC(ude,editor,paramdlg,DF,Context)"     "Určit výchozí hodnotu"
::msgcat::mcset $gPB(LANG) "MC(ude,editor,paramdlg,TG)"             "Přepínač"
::msgcat::mcset $gPB(LANG) "MC(ude,editor,paramdlg,TG,B,Label)"     "Přepínač"
::msgcat::mcset $gPB(LANG) "MC(ude,editor,paramdlg,TG,B,Context)"   "Vybrat hodnotu přepínače"
::msgcat::mcset $gPB(LANG) "MC(ude,editor,paramdlg,ON,Label)"       "Zapnuto"
::msgcat::mcset $gPB(LANG) "MC(ude,editor,paramdlg,OFF,Label)"      "Vypnuto"
::msgcat::mcset $gPB(LANG) "MC(ude,editor,paramdlg,ON,Context)"     "Vybrat ZAPNUTO jako výchozí hodnotu"
::msgcat::mcset $gPB(LANG) "MC(ude,editor,paramdlg,OFF,Context)"    "Vybrat VYPNUTO jako výchozí hodnotu"
::msgcat::mcset $gPB(LANG) "MC(ude,editor,paramdlg,OL)"             "Seznam možností"
::msgcat::mcset $gPB(LANG) "MC(ude,editor,paramdlg,ADD,Label)"      "Přidat"
::msgcat::mcset $gPB(LANG) "MC(ude,editor,paramdlg,CUT,Label)"      "Vyjmout"
::msgcat::mcset $gPB(LANG) "MC(ude,editor,paramdlg,PASTE,Label)"    "Vložit"
::msgcat::mcset $gPB(LANG) "MC(ude,editor,paramdlg,ADD,Context)"    "Přidat položku"
::msgcat::mcset $gPB(LANG) "MC(ude,editor,paramdlg,CUT,Context)"    "Vyjmout položku"
::msgcat::mcset $gPB(LANG) "MC(ude,editor,paramdlg,PASTE,Context)"  "Vložit položku"
::msgcat::mcset $gPB(LANG) "MC(ude,editor,paramdlg,ENTRY,Label)"    "Možnost"
::msgcat::mcset $gPB(LANG) "MC(ude,editor,paramdlg,ENTRY,Context)"  "Zadat položku"
::msgcat::mcset $gPB(LANG) "MC(ude,editor,eventdlg,EN,Label)"       "Název události"
::msgcat::mcset $gPB(LANG) "MC(ude,editor,eventdlg,EN,Context)"     "Určit název události"
::msgcat::mcset $gPB(LANG) "MC(ude,editor,eventdlg,PEN,Label)"      "Název postprocesoru"
::msgcat::mcset $gPB(LANG) "MC(ude,editor,eventdlg,PEN,Context)"    "Určit název postprocesoru"
::msgcat::mcset $gPB(LANG) "MC(ude,editor,eventdlg,PEN,C,Label)"    "Název postprocesoru"
::msgcat::mcset $gPB(LANG) "MC(ude,editor,eventdlg,PEN,C,Context)"  "Pomocí tohoto přepínače je možné nastavit název postprocesoru"
::msgcat::mcset $gPB(LANG) "MC(ude,editor,eventdlg,EL,Label)"       "Popisek události"
::msgcat::mcset $gPB(LANG) "MC(ude,editor,eventdlg,EL,Context)"     "Určit popisek události"
::msgcat::mcset $gPB(LANG) "MC(ude,editor,eventdlg,EL,C,Label)"     "Popisek události"
::msgcat::mcset $gPB(LANG) "MC(ude,editor,eventdlg,EL,C,Context)"   "Pomocí tohoto přepínače je možné nastavit popisek události"

::msgcat::mcset $gPB(LANG) "MC(ude,editor,eventdlg,EC,Label)"           "Kategorie"
::msgcat::mcset $gPB(LANG) "MC(ude,editor,eventdlg,EC,Context)"         "Pomocí tohoto přepínače je možné nastavit kategorii"
::msgcat::mcset $gPB(LANG) "MC(ude,editor,eventdlg,EC_MILL,Label)"      "Frézování"
::msgcat::mcset $gPB(LANG) "MC(ude,editor,eventdlg,EC_DRILL,Label)"     "Vrtání"
::msgcat::mcset $gPB(LANG) "MC(ude,editor,eventdlg,EC_LATHE,Label)"     "Soustružení"
::msgcat::mcset $gPB(LANG) "MC(ude,editor,eventdlg,EC_WEDM,Label)"      "Drátové řezání"
::msgcat::mcset $gPB(LANG) "MC(ude,editor,eventdlg,EC_MILL,Context)"    "Nastavit kategorii frézování"
::msgcat::mcset $gPB(LANG) "MC(ude,editor,eventdlg,EC_DRILL,Context)"   "Nastavit kategorii vrtání"
::msgcat::mcset $gPB(LANG) "MC(ude,editor,eventdlg,EC_LATHE,Context)"   "Nastavit kategorii soustružení"
::msgcat::mcset $gPB(LANG) "MC(ude,editor,eventdlg,EC_WEDM,Context)"    "Nastavit kategorii drátového řezání"

::msgcat::mcset $gPB(LANG) "MC(ude,editor,EDIT)"                    "Upravit událost"
::msgcat::mcset $gPB(LANG) "MC(ude,editor,CREATE)"                  "Vytvořit událost řízení stroje"
::msgcat::mcset $gPB(LANG) "MC(ude,editor,popup,HELP)"              "Nápověda"
::msgcat::mcset $gPB(LANG) "MC(ude,editor,popup,EDIT)"              "Upravit uživatelské parametry..."
::msgcat::mcset $gPB(LANG) "MC(ude,editor,param,EDIT)"              "Upravit..."
::msgcat::mcset $gPB(LANG) "MC(ude,editor,param,VIEW)"              "Pohled..."
::msgcat::mcset $gPB(LANG) "MC(ude,editor,popup,DELETE)"            "Odstranit"
::msgcat::mcset $gPB(LANG) "MC(ude,editor,popup,CREATE)"            "Vytvořit novou událost řízení stroje..."
::msgcat::mcset $gPB(LANG) "MC(ude,editor,popup,IMPORT)"            "Import událostí řízení stroje..."
::msgcat::mcset $gPB(LANG) "MC(ude,editor,popup,MSG_BLANK)"         "Název události nemůže být prázdný!"
::msgcat::mcset $gPB(LANG) "MC(ude,editor,popup,MSG_SAMENAME)"      "Událost s tímto názvem již existuje!"
::msgcat::mcset $gPB(LANG) "MC(ude,editor,popup,MSG_SameHandler)"   "Správce události již existuje! \nUpravte název události nebo postprocesoru podle zaškrtnutí!"
::msgcat::mcset $gPB(LANG) "MC(ude,validate)"                       "V této události není žádný parametr!"
::msgcat::mcset $gPB(LANG) "MC(ude,prev,tab,Label)"                 "Uživatelské události"
::msgcat::mcset $gPB(LANG) "MC(ude,prev,ude,Label)"                 "Události řízení stroje"
::msgcat::mcset $gPB(LANG) "MC(ude,prev,udc,Label)"                 "Uživatelské cykly"
::msgcat::mcset $gPB(LANG) "MC(ude,prev,mc,Label)"                  "Systémové události řízení stroje"
::msgcat::mcset $gPB(LANG) "MC(ude,prev,nmc,Label)"                 "Nesystémové události řízení stroje"
::msgcat::mcset $gPB(LANG) "MC(udc,prev,sys,Label)"                 "Systémové cykly"
::msgcat::mcset $gPB(LANG) "MC(udc,prev,nsys,Label)"                "Nesystémové cykly"
::msgcat::mcset $gPB(LANG) "MC(ude,prev,Status)"                    "Vybrat položku k definici"
::msgcat::mcset $gPB(LANG) "MC(ude,editor,opt,MSG_BLANK)"           "Řetězec možnosti nemůže být prázdný!"
::msgcat::mcset $gPB(LANG) "MC(ude,editor,opt,MSG_SAME)"            "Řetězec možnosti již existuje!"
::msgcat::mcset $gPB(LANG) "MC(ude,editor,opt,MSG_PST_SAME)"        "Vkládaná možnost již existuje!"
::msgcat::mcset $gPB(LANG) "MC(ude,editor,opt,MSG_IDENTICAL)"       "Některé možnosti jsou identické!"
::msgcat::mcset $gPB(LANG) "MC(ude,editor,opt,NO_OPT)"              "V seznamu není žádná možnost!"
::msgcat::mcset $gPB(LANG) "MC(ude,editor,param,MSG_NO_VNAME)"      "Název proměnné nemůže být prázdný!"
::msgcat::mcset $gPB(LANG) "MC(ude,editor,param,MSG_EXIST_VNAME)"   "Název proměnné již existuje!"
::msgcat::mcset $gPB(LANG) "MC(ude,editor,spindle_css,INFO)"        "Tato událost sdílí UDE s položkou \"Otáčky vřetena\""
::msgcat::mcset $gPB(LANG) "MC(ude,import,ihr,Label)"               "Převzít UDE z postprocesoru"

::msgcat::mcset $gPB(LANG) "MC(ude,import,ihr,Context)"             "Pomocí této možnosti může tento postprocesor převzít definici UDE a jejich ovladače od postprocesoru."

::msgcat::mcset $gPB(LANG) "MC(ude,import,sel,Label)"               "Vybrat pilíř"

::msgcat::mcset $gPB(LANG) "MC(ude,import,sel,Context)"             "Umožňuje vybrat soubor PUI požadovaného postprocesoru. Všechny soubory (PUI, Def, Tcl a CDL) asociované s přebíraným postprocesorem je doporučeno umístit do téhož adresáře pro využití za běhu."

::msgcat::mcset $gPB(LANG) "MC(ude,import,name_cdl,Label)"          "Název souboru CDL"

::msgcat::mcset $gPB(LANG) "MC(ude,import,name_cdl,Context)"        "Cesta a název souboru CDL asociovaného s vybraným postprocesorem, který bude odkazován (INCLUDE) v souboru definice tohoto postprocesoru.  Název cesty musí začínat proměnnou prostředí UG (\\\$UGII) nebo žádnou.  Pokud není určena žádná cesta, použije UG/NX k nalezení souboru za běhu položku UGII_CAM_FILE_SEARCH_PATH."

::msgcat::mcset $gPB(LANG) "MC(ude,import,name_def,Label)"          "Název souboru Def"
::msgcat::mcset $gPB(LANG) "MC(ude,import,name_def,Context)"        "Cesta a název souboru definice vybraného postprocesoru, který bude odkazován (INCLUDE) v souboru definice tohoto postprocesoru.  Název cesty musí začínat proměnnou prostředí UG (\\\$UGII) nebo žádnou.  Pokud není určena žádná cesta, použije UG/NX k nalezení souboru za běhu položku UGII_CAM_FILE_SEARCH_PATH."

::msgcat::mcset $gPB(LANG) "MC(ude,import,include_cdl,Label)"       "CDL"
::msgcat::mcset $gPB(LANG) "MC(ude,import,ihr_pst,Label)"           "Postprocesor"
::msgcat::mcset $gPB(LANG) "MC(ude,import,ihr_folder,Label)"        "Složka"
::msgcat::mcset $gPB(LANG) "MC(ude,import,own_folder,Label)"        "Složka"
::msgcat::mcset $gPB(LANG) "MC(ude,import,own,Label)"               "Zahrnout vlastní soubor CDL"

::msgcat::mcset $gPB(LANG) "MC(ude,import,own,Context)"             "Pomocí této možnosti je možné nastavit, aby tento postprocesor zahrnul odkaz na vlastní soubor CDL ve svém souboru definice."

::msgcat::mcset $gPB(LANG) "MC(ude,import,own_ent,Label)"           "Vlastní soubor CDL"

::msgcat::mcset $gPB(LANG) "MC(ude,import,own_ent,Context)"         "Cesta a název souboru CDL asociovaného s tímto postprocesorem, který bude odkazován (INCLUDE) v souboru definice tohoto postprocesoru.  Skutečný název souboru bude určen při uložení postprocesoru.  Název cesty musí začínat proměnnou prostředí UG (\\\$UGII) nebo žádnou.  Pokud není určena žádná cesta, použije UG/NX k nalezení souboru za běhu položku UGII_CAM_FILE_SEARCH_PATH."

::msgcat::mcset $gPB(LANG) "MC(ude,import,sel,pui,status)"          "Vybrat soubor PUI"
::msgcat::mcset $gPB(LANG) "MC(ude,import,sel,cdl,status)"          "Vybrat soubor CDL"

##---------
## UDC
##
::msgcat::mcset $gPB(LANG) "MC(udc,editor,TITLE)"                   "Uživatelský cyklus"
::msgcat::mcset $gPB(LANG) "MC(udc,editor,CREATE)"                  "Vytvořit uživatelský cyklus"
::msgcat::mcset $gPB(LANG) "MC(udc,editor,TYPE)"                    "Typ cyklu"
::msgcat::mcset $gPB(LANG) "MC(udc,editor,type,UDC)"                "Uživatelem definovaný"
::msgcat::mcset $gPB(LANG) "MC(udc,editor,type,SYSUDC)"             "Systémové"
::msgcat::mcset $gPB(LANG) "MC(udc,editor,CYCLBL,Label)"            "Popisek cyklu"
::msgcat::mcset $gPB(LANG) "MC(udc,editor,CYCNAME,Label)"           "Název cyklu"
::msgcat::mcset $gPB(LANG) "MC(udc,editor,CYCLBL,Context)"          "Určit popisek cyklu"
::msgcat::mcset $gPB(LANG) "MC(udc,editor,CYCNAME,Context)"         "Určit název cyklu"
::msgcat::mcset $gPB(LANG) "MC(udc,editor,CYCLBL,C,Label)"          "Popisek cyklu"
::msgcat::mcset $gPB(LANG) "MC(udc,editor,CYCLBL,C,Context)"        "Pomocí tohoto přepínače je možné nastavit popisek cyklu"
::msgcat::mcset $gPB(LANG) "MC(udc,editor,popup,EDIT)"              "Upravit uživatelské parametry..."
::msgcat::mcset $gPB(LANG) "MC(udc,editor,popup,MSG_BLANK)"         "Název cyklu nemůže být prázdný!"
::msgcat::mcset $gPB(LANG) "MC(udc,editor,popup,MSG_SAMENAME)"      "Název cyklu již existuje!"
::msgcat::mcset $gPB(LANG) "MC(udc,editor,popup,MSG_SameHandler)"   "Správce události již existuje!\n Upravte název události cyklu!"
::msgcat::mcset $gPB(LANG) "MC(udc,editor,popup,MSG_ISSYSCYC)"      "Název cyklu patří systémovému typu cyklu!"
::msgcat::mcset $gPB(LANG) "MC(udc,editor,popup,MSG_SYSCYC_EXIST)"  "Tento druh systémového cyklu již existuje!"
::msgcat::mcset $gPB(LANG) "MC(udc,editor,EDIT)"                    "Upravit událost cyklu"
::msgcat::mcset $gPB(LANG) "MC(udc,editor,popup,CREATE)"            "Vytvořit nový uživatelský cyklus..."
::msgcat::mcset $gPB(LANG) "MC(udc,editor,popup,IMPORT)"            "Import uživatelských cyklů..."
::msgcat::mcset $gPB(LANG) "MC(udc,drill,csink,INFO)"               "Tato událost sdílí ovladač s vrtákem!"
::msgcat::mcset $gPB(LANG) "MC(udc,drill,simulate,INFO)"            "Tato událost je simulovaným cyklem."
::msgcat::mcset $gPB(LANG) "MC(udc,drill,dwell,INFO)"               "Tato událost sdílí uživatelský cyklus s "


#######
# IS&V
#######
::msgcat::mcset $gPB(LANG) "MC(isv,tab,label)"                      "Virtuální řídicí systém N/C"
::msgcat::mcset $gPB(LANG) "MC(isv,Status)"                         "Určit parametry pro ISV"
::msgcat::mcset $gPB(LANG) "MC(isv,review,Status)"                  "Kontrola příkazů VNC"

::msgcat::mcset $gPB(LANG) "MC(isv,setup,Label)"                    "Konfigurace"
::msgcat::mcset $gPB(LANG) "MC(isv,vnc_command,Label)"              "Příkazy VNC"
####################
# General Definition
####################
::msgcat::mcset $gPB(LANG) "MC(isv,select_Main)"                    "Umožňuje vybrat hlavní soubor VNC pro podřízené VNC."
::msgcat::mcset $gPB(LANG) "MC(isv,setup,machine,Label)"            "Obráběcí stroj"
::msgcat::mcset $gPB(LANG) "MC(isv,setup,component,Label)"          "Upnutí nástroje"
::msgcat::mcset $gPB(LANG) "MC(isv,setup,mac_zcs_frame,Label)"      "Nulová reference programu"
::msgcat::mcset $gPB(LANG) "MC(isv,setup,mac_zcs,Label)"            "Komponenta"
::msgcat::mcset $gPB(LANG) "MC(isv,setup,mac_zcs,Context)"          "Umožňuje určit komponentu jako referenční základnu ZCS. Komponenta nesmí být otočná a součást musí být přímo nebo nepřímo propojena se stromem kinematiky."
::msgcat::mcset $gPB(LANG) "MC(isv,setup,spin_com,Label)"           "Komponenta"
::msgcat::mcset $gPB(LANG) "MC(isv,setup,spin_com,Context)"         "Umožňuje určit komponentu, na které budou nástroje upnuty. U postprocesoru frézování se musí jednat o komponentu vřetena a u postprocesoru soustružení se musí jednat o komponentu nožové hlavy."

::msgcat::mcset $gPB(LANG) "MC(isv,setup,spin_jct,Label)"           "Spoj"
::msgcat::mcset $gPB(LANG) "MC(isv,setup,spin_jct,Context)"         "Umožňuje definovat spoj pro upnutí nástrojů. U postprocesoru frézování se jedná o spoj ve středu plochy vřetena. U postprocesoru soustružení se jedná o otočný spoj nožové hlavy. Pokud je nožová hlava pevná, jedná se o spoj upnutí nástroje."

::msgcat::mcset $gPB(LANG) "MC(isv,setup,axis_name,Label)"          "Osa určená u obráběcího stroje"
::msgcat::mcset $gPB(LANG) "MC(isv,setup,axis_name,Context)"        "Umožňuje určit názvy os podle konfigurace kinematiky obráběcího stroje"




::msgcat::mcset $gPB(LANG) "MC(isv,setup,axis_frm,Label)"           "Názvy os NC"
::msgcat::mcset $gPB(LANG) "MC(isv,setup,rev_fourth,Label)"         "Obrátit otočení"
::msgcat::mcset $gPB(LANG) "MC(isv,setup,rev_fourth,Context)"       "Umožňuje určit směr otáčení osy na obrábění nebo normální.  Tuto možnost je možné použít pouze u otočného stolu."
::msgcat::mcset $gPB(LANG) "MC(isv,setup,rev_fifth,Label)"          "Obrátit otočení"

::msgcat::mcset $gPB(LANG) "MC(isv,setup,fourth_limit,Label)"       "Mez otočení"
::msgcat::mcset $gPB(LANG) "MC(isv,setup,fourth_limit,Context)"     "Určuje, zda má tato osa otáčení meze"
::msgcat::mcset $gPB(LANG) "MC(isv,setup,fifth_limit,Label)"        "Mez otočení"
::msgcat::mcset $gPB(LANG) "MC(isv,setup,limiton,Label)"            "Ano"
::msgcat::mcset $gPB(LANG) "MC(isv,setup,limitoff,Label)"           "Ne"
::msgcat::mcset $gPB(LANG) "MC(isv,setup,fourth_table,Label)"       "Čtvrtá osa"
::msgcat::mcset $gPB(LANG) "MC(isv,setup,fifth_table,Label)"        "Pátá osa"
::msgcat::mcset $gPB(LANG) "MC(isv,setup,header,Label)"             " Tabulka "
::msgcat::mcset $gPB(LANG) "MC(isv,setup,intialization,Label)"      "Řídící systém"
::msgcat::mcset $gPB(LANG) "MC(isv,setup,general_def,Label)"        "Počáteční nastavení"
::msgcat::mcset $gPB(LANG) "MC(isv,setup,advanced_def,Label)"       "Další možnosti"
::msgcat::mcset $gPB(LANG) "MC(isv,setup,InputOutput,Label)"        "Speciální kódy NC"

::msgcat::mcset $gPB(LANG) "MC(isv,setup,program,Label)"            "Výchozí definice programu"
::msgcat::mcset $gPB(LANG) "MC(isv,setup,output,Label)"             "Export definice programu"
::msgcat::mcset $gPB(LANG) "MC(isv,setup,output,Context)"           "Uložit definici programu do souboru"
::msgcat::mcset $gPB(LANG) "MC(isv,setup,input,Label)"              "Import definice programu"
::msgcat::mcset $gPB(LANG) "MC(isv,setup,input,Context)"            "Načíst definici programu ze souboru"
::msgcat::mcset $gPB(LANG) "MC(isv,setup,file_err,Msg)"             "Vybraný soubor neodpovídá výchozímu typu souboru definice programu, chcete pokračovat?"
::msgcat::mcset $gPB(LANG) "MC(isv,setup,wcs,Label)"                "Odsazení upínek"
::msgcat::mcset $gPB(LANG) "MC(isv,setup,tool,Label)"               "Data nástroje"
::msgcat::mcset $gPB(LANG) "MC(isv,setup,g_code,Label)"             "Speciální G-kód"
::msgcat::mcset $gPB(LANG) "MC(isv,setup,special_vnc,Label)"        "Speciální kód NC"

::msgcat::mcset $gPB(LANG) "MC(isv,setup,initial,frame,Label)"      ""
::msgcat::mcset $gPB(LANG) "MC(isv,setup,initial_motion,Label)"     "Pohyb"
::msgcat::mcset $gPB(LANG) "MC(isv,setup,initial_motion,Context)"   "Určit počáteční pohyb obráběcího stroje"

::msgcat::mcset $gPB(LANG) "MC(isv,setup,spindle,frame,Label)"      "Vřeteno"
::msgcat::mcset $gPB(LANG) "MC(isv,setup,spindle_mode,Label)"       "Režim"
::msgcat::mcset $gPB(LANG) "MC(isv,setup,spindle_direction,Label)"  "Směr"
::msgcat::mcset $gPB(LANG) "MC(isv,setup,spindle,frame,Context)"    "Určit počáteční jednotku rychlosti vřetena a směr otáčení"

::msgcat::mcset $gPB(LANG) "MC(isv,setup,feedrate_mode,Label)"      "Režim rychlosti posuvu"
::msgcat::mcset $gPB(LANG) "MC(isv,setup,feedrate_mode,Context)"    "Určit počáteční jednotku rychlosti posuvu"

::msgcat::mcset $gPB(LANG) "MC(isv,setup,boolean,frame,Label)"      "Definice booleovské položky"
::msgcat::mcset $gPB(LANG) "MC(isv,setup,power_on_wcs,Label)"       "Zapnout WCS  "
::msgcat::mcset $gPB(LANG) "MC(isv,setup,power_on_wcs,Context)"     "0 naznačuje použití výchozích souřadnic nuly stroje\n 1 naznačuje použití prvního uživatelského odsazení upínky (pracovní souřadnice)"

::msgcat::mcset $gPB(LANG) "MC(isv,setup,use_s_leader,Label)"       "Použito S"
::msgcat::mcset $gPB(LANG) "MC(isv,setup,use_f_leader,Label)"       "Použito F"


::msgcat::mcset $gPB(LANG) "MC(isv,setup,dog_leg,Label)"            "Rychlá pomocná vynášecí čára"
::msgcat::mcset $gPB(LANG) "MC(isv,setup,dog_leg,Context)"          "Možnost ZAPNUTO znamená přejetí rychloposuvů ve stylu pomocné vynášecí čáry; Možnost VYPNUTO znamená přejetí rychloposuvů podle kódu NC (od bodu k bodu)."

::msgcat::mcset $gPB(LANG) "MC(isv,setup,dog_leg,yes)"              "Ano"
::msgcat::mcset $gPB(LANG) "MC(isv,setup,dog_leg,no)"               "Ne"

::msgcat::mcset $gPB(LANG) "MC(isv,setup,on_off_frame,Label)"       "Definice ZAPNUTO/VYPNUTO"
::msgcat::mcset $gPB(LANG) "MC(isv,setup,stroke_limit,Label)"       "Mez tahu"
::msgcat::mcset $gPB(LANG) "MC(isv,setup,cutcom,Label)"             "Poloměrová korekce"
::msgcat::mcset $gPB(LANG) "MC(isv,setup,tl_adjust,Label)"          "Přizpůsobení délky nástroje"
::msgcat::mcset $gPB(LANG) "MC(isv,setup,scale,Label)"              "Měřítko"
::msgcat::mcset $gPB(LANG) "MC(isv,setup,macro_modal,Label)"        "Modalita makra"
::msgcat::mcset $gPB(LANG) "MC(isv,setup,wcs_rotate,Label)"         "Otočení WCS"
::msgcat::mcset $gPB(LANG) "MC(isv,setup,cycle,Label)"              "Cyklovat"

::msgcat::mcset $gPB(LANG) "MC(isv,setup,initial_mode,frame,Label)"     "Režim vstupu"
::msgcat::mcset $gPB(LANG) "MC(isv,setup,initial_mode,frame,Context)"   "Umožňuje určit počáteční režim vstupu jako absolutní nebo přírůstkový"

###################
# Input/Out Related
###################
::msgcat::mcset $gPB(LANG) "MC(isv,sign_define,frame,Label)"        ""
::msgcat::mcset $gPB(LANG) "MC(isv,sign_define,rewindstop,Label)"   "Kód zastavení převinutí"
::msgcat::mcset $gPB(LANG) "MC(isv,sign_define,rewindstop,Context)" "Umožňuje určit kód zastavení převinutí"

::msgcat::mcset $gPB(LANG) "MC(isv,control_var,frame,Label)"        "Proměnné řízení"

::msgcat::mcset $gPB(LANG) "MC(isv,sign_define,convarleader,Label)"     "Úvodní kód"
::msgcat::mcset $gPB(LANG) "MC(isv,sign_define,convarleader,Context)"   "Umožňuje určit proměnnou řídicího systému"
::msgcat::mcset $gPB(LANG) "MC(isv,sign_define,conequ,Label)"           "Znak rovná se"
::msgcat::mcset $gPB(LANG) "MC(isv,sign_define,conequ,Context)"         "Umožňuje určit řídicí znak rovná se"
::msgcat::mcset $gPB(LANG) "MC(isv,sign_define,percent,Label)"          "Znak procenta %"
::msgcat::mcset $gPB(LANG) "MC(isv,sign_define,leaderjing,Label)"       "Ostrý #"
::msgcat::mcset $gPB(LANG) "MC(isv,sign_define,text_string,Label)"      "Textový řetězec"

::msgcat::mcset $gPB(LANG) "MC(isv,inputmode,frame,Label)"          ""
::msgcat::mcset $gPB(LANG) "MC(isv,input_mode,Label)"               "Počáteční režim"
::msgcat::mcset $gPB(LANG) "MC(isv,absolute_mode,Label)"            "Absolutní"
::msgcat::mcset $gPB(LANG) "MC(isv,incremental_style,frame,Label)"  "Přírůstkový režim"

::msgcat::mcset $gPB(LANG) "MC(isv,incremental_mode,Label)"         "Přírůstek"
::msgcat::mcset $gPB(LANG) "MC(isv,incremental_gcode,Label)"        "G-kód"
::msgcat::mcset $gPB(LANG) "MC(isv,incremental_gcode,Context)"      "Použití G90 G91 k odlišení absolutního a přírůstkového režimu"
::msgcat::mcset $gPB(LANG) "MC(isv,incremental_uvw,Label)"          "Speciální úvodní kód"
::msgcat::mcset $gPB(LANG) "MC(isv,incremental_uvw,Context)"        "Pomocí speciálního úvodního kódu je možné určit, zda se jedná o absolutní nebo přírůstkový režim. Úvodní kód X Y Z naznačuje absolutní režim, úvodní kód U V W značí přírůstkový režim."
::msgcat::mcset $gPB(LANG) "MC(isv,incr_x,Label)"                   "X "
::msgcat::mcset $gPB(LANG) "MC(isv,incr_y,Label)"                   "Y "
::msgcat::mcset $gPB(LANG) "MC(isv,incr_z,Label)"                   "Z "
::msgcat::mcset $gPB(LANG) "MC(isv,incr_a,Label)"                   "Čtvrtá osa "
::msgcat::mcset $gPB(LANG) "MC(isv,incr_b,Label)"                   "Pátá osa "

::msgcat::mcset $gPB(LANG) "MC(isv,incr_x,Context)"                 "Určit speciální úvodní kód osy X použitý v přírůstkovém stylu"
::msgcat::mcset $gPB(LANG) "MC(isv,incr_y,Context)"                 "Určit speciální úvodní kód osy Y použitý v přírůstkovém stylu"
::msgcat::mcset $gPB(LANG) "MC(isv,incr_z,Context)"                 "Určit speciální úvodní kód osy Z použitý v přírůstkovém stylu"
::msgcat::mcset $gPB(LANG) "MC(isv,incr_a,Context)"                 "Určit speciální úvodní kód čtvrté osy použitý v přírůstkovém stylu"
::msgcat::mcset $gPB(LANG) "MC(isv,incr_b,Context)"                 "Určit speciální úvodní kód páté osy použitý v přírůstkovém stylu"
::msgcat::mcset $gPB(LANG) "MC(isv,vnc_mes,frame,Label)"            "Výstup zprávy VNC"

::msgcat::mcset $gPB(LANG) "MC(isv,vnc_message,Label)"              "Seznam zpráv VNC"
::msgcat::mcset $gPB(LANG) "MC(isv,vnc_message,Context)"            "Když je tato možnost zaškrtnuta, všechny ladicí zprávy VNC budou při simulaci zobrazeny v okně pro zprávy operací."

::msgcat::mcset $gPB(LANG) "MC(isv,vnc_mes,prefix,Label)"           "Předpona zprávy"
::msgcat::mcset $gPB(LANG) "MC(isv,spec_desc,Label)"                "Popis"
::msgcat::mcset $gPB(LANG) "MC(isv,spec_codelist,Label)"            "Seznam kódů"
::msgcat::mcset $gPB(LANG) "MC(isv,spec_nccode,Label)"              "Kód NC / Řetězec"

################
# WCS Definition
################
::msgcat::mcset $gPB(LANG) "MC(isv,machine_zero,offset,Label)"      "Odsazení nuly stroje od\nnuly obráběcího stroje"
::msgcat::mcset $gPB(LANG) "MC(isv,wcs_offset,frame,Label)"         "Odsazení upínek"
::msgcat::mcset $gPB(LANG) "MC(isv,wcs_leader,Label)"               " Kód "
::msgcat::mcset $gPB(LANG) "MC(isv,wcs_number,Label)"               "    "
::msgcat::mcset $gPB(LANG) "MC(isv,wcs_offset,origin_x,Label)"      " Odsazení X  "
::msgcat::mcset $gPB(LANG) "MC(isv,wcs_offset,origin_y,Label)"      " Odsazení Y  "
::msgcat::mcset $gPB(LANG) "MC(isv,wcs_offset,origin_z,Label)"      " Odsazení Z  "
::msgcat::mcset $gPB(LANG) "MC(isv,wcs_offset,a_offset,Label)"      " Odsazení A  "
::msgcat::mcset $gPB(LANG) "MC(isv,wcs_offset,b_offset,Label)"      " Odsazení B  "
::msgcat::mcset $gPB(LANG) "MC(isv,wcs_offset,c_offset,Label)"      " Odsazení C  "
::msgcat::mcset $gPB(LANG) "MC(isv,wcs_offset,wcs_num,Label)"       "Souřadnicový systém"
::msgcat::mcset $gPB(LANG) "MC(isv,wcs_offset,wcs_num,Context)"     "Určit číslo odsazení upínky k přidání"
::msgcat::mcset $gPB(LANG) "MC(isv,wcs_offset,wcs_add,Label)"       "Přidat"
::msgcat::mcset $gPB(LANG) "MC(isv,wcs_offset,wcs_add,Context)"     "Přidat nový souřadnicový systém odsazení upínky, určit jeho pozici"
::msgcat::mcset $gPB(LANG) "MC(isv,wcs_offset,wcs_err,Msg)"         "Toto číslo souřadnicového systému již existuje!"
::msgcat::mcset $gPB(LANG) "MC(isv,tool_info,frame,Label)"          "Informace o nástroji"
::msgcat::mcset $gPB(LANG) "MC(isv,tool_info,tool_entry,Label)"     "Zadat nový název nástroje"
::msgcat::mcset $gPB(LANG) "MC(isv,tool_info,tool_name,Label)"      "       Název       "

::msgcat::mcset $gPB(LANG) "MC(isv,tool_info,tool_num,Label)"       " Nástroj "
::msgcat::mcset $gPB(LANG) "MC(isv,tool_info,add_tool,Label)"       "Přidat"
::msgcat::mcset $gPB(LANG) "MC(isv,tool_info,tool_diameter,Label)"  " Průměr "
::msgcat::mcset $gPB(LANG) "MC(isv,tool_info,offset_usder,Label)"   "   Odsazení špičky   "
::msgcat::mcset $gPB(LANG) "MC(isv,tool_info,carrier_id,Label)"     " ID držáku "
::msgcat::mcset $gPB(LANG) "MC(isv,tool_info,pocket_id,Label)"      " ID kapsy "
::msgcat::mcset $gPB(LANG) "MC(isv,tool_info,cutcom_reg,Label)"     "     POLOMĚROVÁ KOREKCE     "
::msgcat::mcset $gPB(LANG) "MC(isv,tool_info,cutreg,Label)"         "Registrovat "
::msgcat::mcset $gPB(LANG) "MC(isv,tool_info,cutval,Label)"         "Odsazení "
::msgcat::mcset $gPB(LANG) "MC(isv,tool_info,adjust_reg,Label)"     " Úprava délky "
::msgcat::mcset $gPB(LANG) "MC(isv,tool_info,tool_type,Label)"      "   Typ   "
::msgcat::mcset $gPB(LANG) "MC(isv,prog,setup,Label)"               "Výchozí definice programu"
::msgcat::mcset $gPB(LANG) "MC(isv,prog,setup_right,Label)"         "Definice programu"
::msgcat::mcset $gPB(LANG) "MC(isv,output,setup_data,Label)"        "Určit soubor definice programu"
::msgcat::mcset $gPB(LANG) "MC(isv,input,setup_data,Label)"         "Vybrat soubor definice programu"

::msgcat::mcset $gPB(LANG) "MC(isv,tool_info,toolnum,Label)"        "Číslo nástroje  "
::msgcat::mcset $gPB(LANG) "MC(isv,tool_info,toolnum,Context)"      "Určit číslo nástroje k přidání"
::msgcat::mcset $gPB(LANG) "MC(isv,tool_info,add_tool,Context)"     "Přidat nový nástroj, určit jeho parametry"
::msgcat::mcset $gPB(LANG) "MC(isv,tool_info,add_err,Msg)"          "Číslo nástroje již existuje!"
::msgcat::mcset $gPB(LANG) "MC(isv,tool_info,name_err,Msg)"         "Název nástroje nemůže být prázdný!"

###########################
# Special G code Definition
###########################

::msgcat::mcset $gPB(LANG) "MC(isv,g_code,frame,Label)"             "Speciální G-kód"
::msgcat::mcset $gPB(LANG) "MC(isv,g_code,frame,Context)"           "Určit speciální G-kódy použité v simulaci"
::msgcat::mcset $gPB(LANG) "MC(isv,g_code,from_home,Label)"         "Z konečného bodu"
::msgcat::mcset $gPB(LANG) "MC(isv,g_code,return_home,Label)"       "Bod návratu do konečného bodu"
::msgcat::mcset $gPB(LANG) "MC(isv,g_code,mach_wcs,Label)"          "Posun základny stroje"
::msgcat::mcset $gPB(LANG) "MC(isv,g_code,set_local,Label)"         "Nastavit lokální souřadnice"

###########################
# Special NC Custom Command
###########################

::msgcat::mcset $gPB(LANG) "MC(isv,spec_command,frame,Label)"       "Speciální příkazy NC"
::msgcat::mcset $gPB(LANG) "MC(isv,spec_command,frame,Context)"     "Příkazy NC určené pro speciální zařízení"


::msgcat::mcset $gPB(LANG) "MC(isv,spec_pre,frame,Label)"           "Provést preprocesing příkazů"
::msgcat::mcset $gPB(LANG) "MC(isv,spec_pre,frame,Context)"         "Seznam příkazů zahrnuje všechny tokeny nebo značky, které je nutné zpracovat před zpracováním souřadnic bloku"

::msgcat::mcset $gPB(LANG) "MC(isv,spec_command,add,Label)"         "Přidat"
::msgcat::mcset $gPB(LANG) "MC(isv,spec_command,edit,Label)"        "Upravit"
::msgcat::mcset $gPB(LANG) "MC(isv,spec_command,delete,Label)"      "Odstranit"
::msgcat::mcset $gPB(LANG) "MC(isv,spec_command,title,Label)"       "Speciální příkaz pro jiná zařízení"
::msgcat::mcset $gPB(LANG) "MC(isv,spec_command,add_sim,Label)"     "Přidat příkaz SIM @Cursor"
::msgcat::mcset $gPB(LANG) "MC(isv,spec_command,init_sim,Label)"    "Vyberte jeden příkaz"

::msgcat::mcset $gPB(LANG) "MC(isv,spec_command,preleader,Label)"   "Úvodní kód"
::msgcat::mcset $gPB(LANG) "MC(isv,spec_command,preleader,Context)" "Umožňuje určit úvodní kód pro uživatelský příkaz po preprocesingu."

::msgcat::mcset $gPB(LANG) "MC(isv,spec_command,precode,Label)"     "Kód"
::msgcat::mcset $gPB(LANG) "MC(isv,spec_command,precode,Context)"   "Umožňuje určit úvodní kód pro uživatelský příkaz po preprocesingu."

::msgcat::mcset $gPB(LANG) "MC(isv,spec_command,leader,Label)"      "Úvodní kód"
::msgcat::mcset $gPB(LANG) "MC(isv,spec_command,leader,Context)"    "Umožňuje určit úvodní kód pro uživatelský příkaz."

::msgcat::mcset $gPB(LANG) "MC(isv,spec_command,code,Label)"        "Kód"
::msgcat::mcset $gPB(LANG) "MC(isv,spec_command,code,Context)"      "Umožňuje určit úvodní kód pro uživatelský příkaz."

::msgcat::mcset $gPB(LANG) "MC(isv,spec_command,add,Context)"       "Přidat nový uživatelský příkaz"
::msgcat::mcset $gPB(LANG) "MC(isv,spec_command,add_err,Msg)"       "Tento token již byl zpracován!"
::msgcat::mcset $gPB(LANG) "MC(isv,spec_command,sel_err,Msg)"       "Vyberte příkaz"
::msgcat::mcset $gPB(LANG) "MC(isv,export,error,title)"             "Upozornění"

::msgcat::mcset $gPB(LANG) "MC(isv,tool_table,title,Label)"         "Tabulka nástrojů"
::msgcat::mcset $gPB(LANG) "MC(isv,ex_editor,warning,Msg)"          "Jedná se o systémem vygenerovaný příkaz VNC. Změny nebudou uloženy."


# - Languages
#
::msgcat::mcset $gPB(LANG) "MC(language,Label)"                     "Jazyk"
::msgcat::mcset $gPB(LANG) "MC(pb_msg_english)"                     "Palcové"
::msgcat::mcset $gPB(LANG) "MC(pb_msg_french)"                      "Francouzština"
::msgcat::mcset $gPB(LANG) "MC(pb_msg_german)"                      "Němčina"
::msgcat::mcset $gPB(LANG) "MC(pb_msg_italian)"                     "Italština"
::msgcat::mcset $gPB(LANG) "MC(pb_msg_japanese)"                    "Japonština"
::msgcat::mcset $gPB(LANG) "MC(pb_msg_korean)"                      "Korejština"
::msgcat::mcset $gPB(LANG) "MC(pb_msg_russian)"                     "Ruština"
::msgcat::mcset $gPB(LANG) "MC(pb_msg_simple_chinese)"              "Jednoduchá čínština"
::msgcat::mcset $gPB(LANG) "MC(pb_msg_spanish)"                     "Španělština"
::msgcat::mcset $gPB(LANG) "MC(pb_msg_traditional_chinese)"         "Tradiční čínština"

### Exit Options Dialog
::msgcat::mcset $gPB(LANG) "MC(exit,options,Label)"                 "Možnosti ukončení"
::msgcat::mcset $gPB(LANG) "MC(exit,options,SaveAll,Label)"         "Ukončit a uložit vše"
::msgcat::mcset $gPB(LANG) "MC(exit,options,SaveNone,Label)"        "Ukončit bez uložení"
::msgcat::mcset $gPB(LANG) "MC(exit,options,SaveSelect,Label)"      "Ukončit a uložit vybrané"

### OptionMenu Items
::msgcat::mcset $gPB(LANG) "MC(optionMenu,item,Other)"       "Jiný"
::msgcat::mcset $gPB(LANG) "MC(optionMenu,item,None)"        "Nic"
::msgcat::mcset $gPB(LANG) "MC(optionMenu,item,RT_R)"        "Rychlé přejetí a R"
::msgcat::mcset $gPB(LANG) "MC(optionMenu,item,Rapid)"       "Úkos"
::msgcat::mcset $gPB(LANG) "MC(optionMenu,item,RS)"          "Rychlé vřeteno"
::msgcat::mcset $gPB(LANG) "MC(optionMenu,item,C_off_RS)"    "Vypnutí cyklu a poté rychlé vřeteno"
::msgcat::mcset $gPB(LANG) "MC(optionMenu,item,IPM)"         "IPM"
::msgcat::mcset $gPB(LANG) "MC(optionMenu,item,FRN)"         "FRN"
::msgcat::mcset $gPB(LANG) "MC(optionMenu,item,IPR)"         "IPR"
::msgcat::mcset $gPB(LANG) "MC(optionMenu,item,Auto)"        "Automaticky"
::msgcat::mcset $gPB(LANG) "MC(optionMenu,item,DPM)"         "DPM"
::msgcat::mcset $gPB(LANG) "MC(optionMenu,item,Abs_Inc)"     "Absolutní/Přírůstkový"
::msgcat::mcset $gPB(LANG) "MC(optionMenu,item,Abs_Only)"    "Pouze absolutní"
::msgcat::mcset $gPB(LANG) "MC(optionMenu,item,Inc_Only)"    "Pouze přírůstkový"
::msgcat::mcset $gPB(LANG) "MC(optionMenu,item,SD)"          "Nejkratší vzdálenost"
::msgcat::mcset $gPB(LANG) "MC(optionMenu,item,AP)"          "Vždy kladný"
::msgcat::mcset $gPB(LANG) "MC(optionMenu,item,AN)"          "Vždy záporný"
::msgcat::mcset $gPB(LANG) "MC(optionMenu,item,Z_Axis)"      "Osa Z"
::msgcat::mcset $gPB(LANG) "MC(optionMenu,item,+X_Axis)"     "+Osa X"
::msgcat::mcset $gPB(LANG) "MC(optionMenu,item,-X_Axis)"     "-Osa X"
::msgcat::mcset $gPB(LANG) "MC(optionMenu,item,Y_Axis)"      "Osa Y"
::msgcat::mcset $gPB(LANG) "MC(optionMenu,item,MDD)"         "Hodnota určuje směr"
::msgcat::mcset $gPB(LANG) "MC(optionMenu,item,SDD)"         "Znaménko určuje směr"



