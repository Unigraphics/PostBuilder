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
#       ::msgcat::mcset pb_msg_italian "MC(main,title,Unigraphics)"  "Unigraphics"
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
::msgcat::mcset pb_msg_italian "MC(event,misc,subop_start,name)"      "Inizio percorso Subop"
::msgcat::mcset pb_msg_italian "MC(event,misc,subop_end,name)"        "Fine percorso Subop"
::msgcat::mcset pb_msg_italian "MC(event,misc,contour_start,name)"    "Inizio contorno"
::msgcat::mcset pb_msg_italian "MC(event,misc,contour_end,name)"      "Fine contorno"
::msgcat::mcset pb_msg_italian "MC(prog,tree,misc,Label)"             "Miscellanea"
::msgcat::mcset pb_msg_italian "MC(event,cycle,lathe_rough,name)"     "Sgrossatura tornitura"
::msgcat::mcset pb_msg_italian "MC(main,file,properties,Label)"       "Proprietà post"

::msgcat::mcset pb_msg_italian "MC(ude,editor,popup,MSG_CATEGORY)"    "Impossibile specificare l'UDE di un post di tornitura o fresatura con una sola categoria di \"Elettroerosione a filo\"."

::msgcat::mcset pb_msg_italian "MC(event,cycle,plane_change,label)"   "Attiva questo evento quando il piano di lavoro si abbassa"
::msgcat::mcset pb_msg_italian "MC(format,check_1,error,msg)"         "Il formato non è predisposto per il valore delle espressioni"

::msgcat::mcset pb_msg_italian "MC(format,check_4,error,msg)"         "Cambiare il formato dell'indirizzo correlato prima di uscire da questa pagina o di salvare il post."
::msgcat::mcset pb_msg_italian "MC(format,check_5,error,msg)"         "Modificare il formato prima di uscire dalla pagina o di salvare il post."
::msgcat::mcset pb_msg_italian "MC(format,check_6,error,msg)"         "Cambiare il formato dell'indirizzo prima di aprire la pagina."

::msgcat::mcset pb_msg_italian "MC(msg,old_block,maximum_length)"     "La lunghezza dei nomi dei seguenti blocchi supera il numero massimo di caratteri consentito:"
::msgcat::mcset pb_msg_italian "MC(msg,old_address,maximum_length)"   "La lunghezza delle seguenti parole supera il numero massimo di caratteri consentito:"
::msgcat::mcset pb_msg_italian "MC(msg,block_address,check,title)"    "Controllo nome blocco e parola"
::msgcat::mcset pb_msg_italian "MC(msg,block_address,maximum_length)" "Alcuni nomi blocco e parola superano il numero di caratteri previsto."

::msgcat::mcset pb_msg_italian "MC(address,maximum_name_msg)"         "La lunghezza della stringa supera il numero di caratteri consentito."

::msgcat::mcset pb_msg_italian "MC(ude,import,oth_list,Label)"        "Includi altri file CDL"
::msgcat::mcset pb_msg_italian "MC(ude,import,oth_list,Context)"      "Selezionare l'opzione \\\"Nuovo\\\" dal menu a comparsa (fare clic con il pulsante destro del mouse) in modo da includere altri file CDL nel post."
::msgcat::mcset pb_msg_italian "MC(ude,import,ihr_list,Label)"        "Eredita UDE dal post A"
::msgcat::mcset pb_msg_italian "MC(ude,import,ihr_list,Context)"      "Selezionare l'opzione \\\"Nuovo\\\" dal menu a comparsa (fare clic con il pulsante destro del mouse) per ereditare le definizioni UDE e gli handler associati al post."
::msgcat::mcset pb_msg_italian "MC(ude,import,up,Label)"              "In alto"
::msgcat::mcset pb_msg_italian "MC(ude,import,down,Label)"            "In basso"
::msgcat::mcset pb_msg_italian "MC(msg,exist_cdl_file)"               "Il file CDL è già stato incluso."

::msgcat::mcset pb_msg_italian "MC(listing,link_var,check,Label)"     "Collega le variabili Tcl alle variabili C"
::msgcat::mcset pb_msg_italian "MC(listing,link_var,check,Context)"   "Un gruppo di variabili Tcl modificate di frequente (come \\\"mom_pos\\\") può essere collegato direttamente alle variabili C in modo da migliorare le prestazioni di postprocessamento. Tuttavia, vanno rispettate alcune limitazioni al fine di evitare possibili errori e differenze nell'output NC."

::msgcat::mcset pb_msg_italian "MC(msg,check_resolution,title)"       "Controlla la risoluzione di movimento lineare/rotatorio"
::msgcat::mcset pb_msg_italian "MC(msg,check_resolution,linear)"      "Con queste impostazioni, il formato non può contenere l'output della \"Soluzione di movimento lineare\"."
::msgcat::mcset pb_msg_italian "MC(msg,check_resolution,rotary)"      "Con queste impostazioni, il formato non può contenere l'output della \"Soluzione di movimento lineare\"."

::msgcat::mcset pb_msg_italian "MC(cmd,export,desc,label)"            "Descrizione dell'input per i comandi personalizzati esportati"
::msgcat::mcset pb_msg_italian "MC(cmd,desc_dlg,title)"               "Descrizione"
::msgcat::mcset pb_msg_italian "MC(block,delete_row,Label)"           "Elimina tutti gli elementi attivi da questa riga"
::msgcat::mcset pb_msg_italian "MC(block,exec_cond,set,Label)"        "Condizione di output"
::msgcat::mcset pb_msg_italian "MC(block,exec_cond,new,Label)"        "Nuovo..."
::msgcat::mcset pb_msg_italian "MC(block,exec_cond,edit,Label)"       "Modifica..."
::msgcat::mcset pb_msg_italian "MC(block,exec_cond,remove,Label)"     "Rimuovi..."

::msgcat::mcset pb_msg_italian "MC(cust_cmd,name_msg_for_cond)"       "Specificare un altro nome.  \nIl comando condizione di output dovrebbe avere il prefisso"

::msgcat::mcset pb_msg_italian "MC(machine,linearization,Label)"         "Interpolazione linearizzazione"
::msgcat::mcset pb_msg_italian "MC(machine,linearization,angle,Label)"   "Angolo rotatorio"
::msgcat::mcset pb_msg_italian "MC(machine,linearization,angle,Context)" "I punti interpolati verranno calcolati in base alla distribuzione degli angoli iniziali e finali degli assi di rotazione."
::msgcat::mcset pb_msg_italian "MC(machine,linearization,axis,Label)"    "Asse utensile"
::msgcat::mcset pb_msg_italian "MC(machine,linearization,axis,Context)"  "I punti interpolati verranno calcolati in base alla distribuzione dei vettori iniziali e finali dell'asse utensile."
::msgcat::mcset pb_msg_italian "MC(machine,resolution,continue,Label)"   "Continua"
::msgcat::mcset pb_msg_italian "MC(machine,resolution,abort,Label)"      "Termina"

::msgcat::mcset pb_msg_italian "MC(machine,axis,def_lintol,Label)"       "Tolleranza predefinita"
::msgcat::mcset pb_msg_italian "MC(machine,axis,def_lintol,Context)"     "Tolleranza linearizzazione predefinita"
::msgcat::mcset pb_msg_italian "MC(sub_post,inch,Lable)"                 "IN"
::msgcat::mcset pb_msg_italian "MC(sub_post,metric,Lable)"               "MM"
::msgcat::mcset pb_msg_italian "MC(new_sub,title,Label)"                 "Crea nuovo postprocessore secondario"
::msgcat::mcset pb_msg_italian "MC(new,sub_post,toggle,label)"           "Post secondario"
::msgcat::mcset pb_msg_italian "MC(new,sub_post,toggle,tmp_label)"       "Post secondario solo unità"
::msgcat::mcset pb_msg_italian "MC(new,unit_post,filename,msg)"          "Il nuovo postprocessore secondario per le unità di output alternative deve essere denominato\n aggiungendo il postfisso \"__MM\" o \"__IN\" al nome del post principale."
::msgcat::mcset pb_msg_italian "MC(new,alter_unit,toggle,label)"         "Unità di output alternativo"
::msgcat::mcset pb_msg_italian "MC(new,main_post,label)"                 "Post principale"
::msgcat::mcset pb_msg_italian "MC(new,main_post,warning_1,msg)"         "Usare solo un post principale completo per creare un post secondario."
::msgcat::mcset pb_msg_italian "MC(new,main_post,warning_2,msg)"         "Il post principale deve essere creato o salvato\n in Post Builder versione 8.0 o successiva."
::msgcat::mcset pb_msg_italian "MC(new,main_post,specify_err,msg)"       "È necessario specificare il post principale per la creazione di un post secondario."
::msgcat::mcset pb_msg_italian "MC(machine,gen,alter_unit,Label)"        "Unità di output post secondario:"
::msgcat::mcset pb_msg_italian "MC(unit_related_param,tab,Label)"        "Parametri unità"
::msgcat::mcset pb_msg_italian "MC(unit_related_param,feed_rate,Label)"  "Velocità di avanzamento"
::msgcat::mcset pb_msg_italian "MC(listing,alt_unit,frame,Label)"        "Post secondario unità alternative opzionali"
::msgcat::mcset pb_msg_italian "MC(listing,alt_unit,default,Label)"      "Predefinito"
::msgcat::mcset pb_msg_italian "MC(listing,alt_unit,default,Context)"    "Nome predefinito del post secondario per le unità alternative deve essere <nome post>__MM o <nome post>__IN"
::msgcat::mcset pb_msg_italian "MC(listing,alt_unit,specify,Label)"      "Specifica"
::msgcat::mcset pb_msg_italian "MC(listing,alt_unit,specify,Context)"    "Specificare il nome di un post secondario per le unità alternative"
::msgcat::mcset pb_msg_italian "MC(listing,alt_unit,select_name,Label)"  "Seleziona nome"
::msgcat::mcset pb_msg_italian "MC(listing,alt_unit,warning_1,msg)"      "È possibile selezionare solo un post secondario per le unità alternative."
::msgcat::mcset pb_msg_italian "MC(listing,alt_unit,warning_2,msg)"      "Il post secondario selezionato non supporta le unità di output alternative di questo post."

::msgcat::mcset pb_msg_italian "MC(listing,alt_unit,post_name,Label)"    "Post secondario unità alternative"
::msgcat::mcset pb_msg_italian "MC(listing,alt_unit,post_name,Context)"  "NX Post usa il post secondario delle unità, se indicato, per gestire le unità di output alternative del post."


##--------------------
## New string in v7.5
##
::msgcat::mcset pb_msg_italian "MC(machine,axis,violation,user,evt_title)"  "Azione definita dall’utente per la violazione del limite asse"
::msgcat::mcset pb_msg_italian "MC(event,helix,name)"                       "Movimento elicoidale"
::msgcat::mcset pb_msg_italian "MC(event,circular,ijk_param,prefix,msg)"    "Le espressioni usate negli indirizzi"
::msgcat::mcset pb_msg_italian "MC(event,circular,ijk_param,postfix,msg)"   "non sono interessate dalle modifiche apportate all'opzione."
::msgcat::mcset pb_msg_italian "MC(isv,spec_codelist,default,msg)"          "L'azione ripristina l'elenco dei codici speciali NC e\nriporta i relativi handler allo stato dell'apertura o della creazione.\n\nContinuare?"
::msgcat::mcset pb_msg_italian "MC(isv,spec_codelist,restore,msg)"          "L'azione ripristina l'elenco dei codici speciali NC e\nriporta i relativi handler allo stato dell'ultima visita.\n\nContinuare?"
::msgcat::mcset pb_msg_italian "MC(msg,block_format_command,paste_err)"     "Nome oggetto già esistente. Operazione Incolla non valida."
::msgcat::mcset pb_msg_italian "MC(main,file,open,choose_cntl_type)"        "Scegli una famiglia controller"
::msgcat::mcset pb_msg_italian "MC(cust_cmd,import,no_vnc_cmd,msg)"         "Il file non contiene alcun comando VNC nuovo o diverso."
::msgcat::mcset pb_msg_italian "MC(cust_cmd,import,no_cmd,msg)"             "Il file non contiene alcun comando personalizzato nuovo o diverso."
::msgcat::mcset pb_msg_italian "MC(isv,tool_info,name_same_err,Msg)"        "I nomi utensile non possono essere uguali."
::msgcat::mcset pb_msg_italian "MC(msg,limit_to_change_license)"            "L'utente non è l'autore del post e \nnon ha l'autorizzazione per rinominare o modificare la licenza."
::msgcat::mcset pb_msg_italian "MC(output,other_opts,validation,msg)"       "Specificare il nome del file utente .tcl."
::msgcat::mcset pb_msg_italian "MC(machine,empty_entry_err,msg)"            "La pagina dei parametri contiene voci vuote."
::msgcat::mcset pb_msg_italian "MC(msg,control_v_limit)"                    "La stringa da incollare potrebbe\n superare i limiti di lunghezza previsti oppure\n contenere linee multiple o caratteri non validi."
::msgcat::mcset pb_msg_italian "MC(block,capital_name_msg)"                 "L'iniziale di un nome blocco non può essere maiuscola.\n Specificare un altro nome."
::msgcat::mcset pb_msg_italian "MC(machine,axis,violation,user,Label)"      "Definito dall'utente"
::msgcat::mcset pb_msg_italian "MC(machine,axis,violation,user,Handler)"    "Handler"
::msgcat::mcset pb_msg_italian "MC(new,user,file,NOT_EXIST)"                "File utente non esistente."
::msgcat::mcset pb_msg_italian "MC(new,include_vnc,Label)"                  "Includi Controller NC virtuale"
::msgcat::mcset pb_msg_italian "MC(other,opt_equal,Label)"                  "Segno di uguale (=)"
::msgcat::mcset pb_msg_italian "MC(event,nurbs,name)"                       "Spostamento NURBS"
::msgcat::mcset pb_msg_italian "MC(event,cycle,tap_float,name)"             "Filettatura mobile"
::msgcat::mcset pb_msg_italian "MC(event,cycle,thread,name)"                "Filettatura"
::msgcat::mcset pb_msg_italian "MC(ude,editor,group,MSG_NESTED_GROUP)"      "Il raggruppamento nidificato non è supportato."
::msgcat::mcset pb_msg_italian "MC(ude,editor,bmp,Label)"                   "Bitmap"
::msgcat::mcset pb_msg_italian "MC(ude,editor,bmp,Context)"                 "Per aggiungere un nuovo parametro bitmap, trascinare il valore nell'elenco a destra."
::msgcat::mcset pb_msg_italian "MC(ude,editor,group,Label)"                 "Gruppo"
::msgcat::mcset pb_msg_italian "MC(ude,editor,group,Context)"               "Per aggiungere un nuovo parametro gruppo, trascinare il valore nell'elenco a destra."
::msgcat::mcset pb_msg_italian "MC(ude,editor,eventdlg,DESC,Label)"         "Descrizione"
::msgcat::mcset pb_msg_italian "MC(ude,editor,eventdlg,DESC,Context)"       "Specificare le informazioni evento"
::msgcat::mcset pb_msg_italian "MC(ude,editor,eventdlg,URL,Label)"          "URL"
::msgcat::mcset pb_msg_italian "MC(ude,editor,eventdlg,URL,Context)"        "Specificare l'URL della descrizione evento"
::msgcat::mcset pb_msg_italian "MC(ude,editor,param,MSG_WRONG_IMAGE_FILE)"  "Il file immagine deve essere in formato bmp."
::msgcat::mcset pb_msg_italian "MC(ude,editor,param,MSG_WRONG_IMAGE_FOLDER)" "Il nome del file bitmap non possono contenere il percorso della directory."
::msgcat::mcset pb_msg_italian "MC(ude,editor,param,MSG_WRONG_VAR_NAME)"    "Il nome variabile deve iniziare con una lettera."
::msgcat::mcset pb_msg_italian "MC(ude,editor,param,MSG_WRONG_KEYWORD)"     "Il nome variabile non può contenere la parola chiave: "
::msgcat::mcset pb_msg_italian "MC(ude,editor,status_label)"                "Stato"
::msgcat::mcset pb_msg_italian "MC(ude,editor,vector,Label)"                "Vettore"
::msgcat::mcset pb_msg_italian "MC(ude,editor,vector,Context)"              "Per aggiungere un nuovo parametro vettore, trascinare il valore nell'elenco a destra."
::msgcat::mcset pb_msg_italian "MC(ude,editor,popup,MSG_URL_FORMAT)"        "Il formato dell'URL deve essere \"http://*\" o \"file://*\" e non deve contenere barre rovesciate."
::msgcat::mcset pb_msg_italian "MC(ude,editor,popup,MSG_BLANK_HELP_INFO)"   "Specificare la descrizione e l'URL."
::msgcat::mcset pb_msg_italian "MC(new,MSG_NO_AXIS)"                        "Selezionare la configurazione asse della macchina utensile."
::msgcat::mcset pb_msg_italian "MC(machine,info,controller_type,Label)"     "Famiglia controller"
::msgcat::mcset pb_msg_italian "MC(block,func_combo,Label)"                 "Macro"
::msgcat::mcset pb_msg_italian "MC(block,prefix_popup,add,Label)"           "Aggiungi testo prefisso"
::msgcat::mcset pb_msg_italian "MC(block,prefix_popup,edit,Label)"          "Modifica testo prefisso"
::msgcat::mcset pb_msg_italian "MC(block,prefix,Label)"                     "Prefisso"
::msgcat::mcset pb_msg_italian "MC(block,suppress_popup,Label)"             "Sopprimi numero di sequenza"
::msgcat::mcset pb_msg_italian "MC(block,custom_func,Label)"                "Macro personalizzata"
::msgcat::mcset pb_msg_italian "MC(seq,combo,macro,Label)"                  "Macro personalizzata"
::msgcat::mcset pb_msg_italian "MC(func,tab,Label)"                         "Macro"
::msgcat::mcset pb_msg_italian "MC(func,exp,msg)"                           "L'espressione di un parametro macro non deve essere vuota."
::msgcat::mcset pb_msg_italian "MC(func,edit,name,Label)"                   "Nome macro"
::msgcat::mcset pb_msg_italian "MC(func,disp_name,Label)"                   "Nome di output"
::msgcat::mcset pb_msg_italian "MC(func,param_list,Label)"                  "Elenco parametri"
::msgcat::mcset pb_msg_italian "MC(func,separator,Label)"                   "Separatore"
::msgcat::mcset pb_msg_italian "MC(func,start,Label)"                       "Carattere iniziale"
::msgcat::mcset pb_msg_italian "MC(func,end,Label)"                         "Carattere finale"
::msgcat::mcset pb_msg_italian "MC(func,output,name,Label)"                 "Attributo di output"
::msgcat::mcset pb_msg_italian "MC(func,output,check,Label)"                "Nome parametro di output"
::msgcat::mcset pb_msg_italian "MC(func,output,link,Label)"                 "Collega carattere"
::msgcat::mcset pb_msg_italian "MC(func,col_param,Label)"                   "Parametro"
::msgcat::mcset pb_msg_italian "MC(func,col_exp,Label)"                     "Espressione"
::msgcat::mcset pb_msg_italian "MC(func,popup,insert,Label)"                "Nuova"
::msgcat::mcset pb_msg_italian "MC(func,name,err_msg)"                      "Il nome macro non deve contenere spazi."
::msgcat::mcset pb_msg_italian "MC(func,name,blank_err)"                    "Il nome macro non deve essere vuoto."
::msgcat::mcset pb_msg_italian "MC(func,name,contain_err)"                  "Il nome macro può contenere solo lettere, numeri e caratteri di sottolineatura."
::msgcat::mcset pb_msg_italian "MC(func,tree_node,start_err)"               "L'iniziale del nome nodo deve essere maiuscola."
::msgcat::mcset pb_msg_italian "MC(func,tree_node,contain_err)"             "Il nome nodo accetta solo lettere, numeri e caratteri di sottolineatura."
::msgcat::mcset pb_msg_italian "MC(func,help,Label)"                        "Informazioni"
::msgcat::mcset pb_msg_italian "MC(func,help,Context)"                      "Mostra informazioni sull'oggetto."
::msgcat::mcset pb_msg_italian "MC(func,help,MSG_NO_INFO)"                  "Nessuna informazione fornita per la macro."


##------
## Title
##
::msgcat::mcset pb_msg_italian "MC(main,title,Unigraphics)"             "Unigraphics"
::msgcat::mcset pb_msg_italian "MC(main,title,UG)"                      "NX"
::msgcat::mcset pb_msg_italian "MC(main,title,Post_Builder)"            "Post Builder"

::msgcat::mcset pb_msg_italian "MC(main,title,Version)"                 "Versione"
::msgcat::mcset pb_msg_italian "MC(main,default,Status)"                "Selezionare Nuovo o Apri nel menu File."
::msgcat::mcset pb_msg_italian "MC(main,save,Status)"                   "Salvare il post."

##------
## File
##
::msgcat::mcset pb_msg_italian "MC(main,file,Label)"                    "File"

::msgcat::mcset pb_msg_italian "MC(main,file,Balloon)"                  "\ Nuovo, Apri, Salva,\n Salva\ con nome, Chiudi e Esci"

::msgcat::mcset pb_msg_italian "MC(main,file,Context)"                  "\ Nuovo, Apri, Salva,\n Salva\ con nome, Chiudi e Esci"
::msgcat::mcset pb_msg_italian "MC(main,file,menu,Context)"             " "

::msgcat::mcset pb_msg_italian "MC(main,file,new,Label)"                "Nuovo..."
::msgcat::mcset pb_msg_italian "MC(main,file,new,Balloon)"              "Crea un nuovo post."
::msgcat::mcset pb_msg_italian "MC(main,file,new,Context)"              "Crea un nuovo post."
::msgcat::mcset pb_msg_italian "MC(main,file,new,Busy)"                 "Creazione nuovo post..."

::msgcat::mcset pb_msg_italian "MC(main,file,open,Label)"               "Apri..."
::msgcat::mcset pb_msg_italian "MC(main,file,open,Balloon)"             "Modifica un post esistente."
::msgcat::mcset pb_msg_italian "MC(main,file,open,Context)"             "Modifica un post esistente."
::msgcat::mcset pb_msg_italian "MC(main,file,open,Busy)"                "Apertura post..."

::msgcat::mcset pb_msg_italian "MC(main,file,mdfa,Label)"               "Importa MDFA..."
::msgcat::mcset pb_msg_italian "MC(main,file,mdfa,Balloon)"             "Crea un nuovo post da MDFA."
::msgcat::mcset pb_msg_italian "MC(main,file,mdfa,Context)"             "Crea un nuovo post da MDFA."

::msgcat::mcset pb_msg_italian "MC(main,file,save,Label)"               "Salva"
::msgcat::mcset pb_msg_italian "MC(main,file,save,Balloon)"             "Salva il post in esecuzione."
::msgcat::mcset pb_msg_italian "MC(main,file,save,Context)"             "Salva il post in esecuzione."
::msgcat::mcset pb_msg_italian "MC(main,file,save,Busy)"                "Salvataggio post..."

::msgcat::mcset pb_msg_italian "MC(main,file,save_as,Label)"            "Salva con nome..."
::msgcat::mcset pb_msg_italian "MC(main,file,save_as,Balloon)"          "Salva il post con un nuovo nome."
::msgcat::mcset pb_msg_italian "MC(main,file,save_as,Context)"          "Salva il post con un nuovo nome."

::msgcat::mcset pb_msg_italian "MC(main,file,close,Label)"              "Chiudi"
::msgcat::mcset pb_msg_italian "MC(main,file,close,Balloon)"            "Chiudi il post in esecuzione."
::msgcat::mcset pb_msg_italian "MC(main,file,close,Context)"            "Chiudi il post in esecuzione."

::msgcat::mcset pb_msg_italian "MC(main,file,exit,Label)"               "Esci"
::msgcat::mcset pb_msg_italian "MC(main,file,exit,Balloon)"             "Chiudi Post Builder."
::msgcat::mcset pb_msg_italian "MC(main,file,exit,Context)"             "Chiudi Post Builder."

::msgcat::mcset pb_msg_italian "MC(main,file,history,Label)"            "Post aperti di recente"
::msgcat::mcset pb_msg_italian "MC(main,file,history,Balloon)"          "Modifica un post aperto in precedenza."
::msgcat::mcset pb_msg_italian "MC(main,file,history,Context)"          "Modifica un post aperto nelle precedenti sessioni del Post Builder."

##---------
## Options
##
::msgcat::mcset pb_msg_italian "MC(main,options,Label)"                 "Opzioni"

::msgcat::mcset pb_msg_italian "MC(main,options,Balloon)"               " Convalida\ Comandi\ personalizzati, backup\ del post"
::msgcat::mcset pb_msg_italian "MC(main,options,Context)"               " "
::msgcat::mcset pb_msg_italian "MC(main,options,menu,Context)"          " "

::msgcat::mcset pb_msg_italian "MC(main,windows,Label)"                 "Windows"
::msgcat::mcset pb_msg_italian "MC(main,windows,Balloon)"               "L'elenco di postmodifica"
::msgcat::mcset pb_msg_italian "MC(main,windows,Context)"               " "
::msgcat::mcset pb_msg_italian "MC(main,windows,menu,Context)"          " "

::msgcat::mcset pb_msg_italian "MC(main,options,properties,Label)"      "Proprietà"
::msgcat::mcset pb_msg_italian "MC(main,options,properties,Balloon)"    "Proprietà"
::msgcat::mcset pb_msg_italian "MC(main,options,properties,Context)"    "Proprietà"

::msgcat::mcset pb_msg_italian "MC(main,options,advisor,Label)"         "Post Advisor"
::msgcat::mcset pb_msg_italian "MC(main,options,advisor,Balloon)"       "Post Advisor"
::msgcat::mcset pb_msg_italian "MC(main,options,advisor,Context)"       "Attiva/Disattiva Post Advisor."

::msgcat::mcset pb_msg_italian "MC(main,options,cmd_check,Label)"       "Convalida comandi personalizzati"
::msgcat::mcset pb_msg_italian "MC(main,options,cmd_check,Balloon)"     "Convalida comandi personalizzati"
::msgcat::mcset pb_msg_italian "MC(main,options,cmd_check,Context)"     "Opzioni di convalida comandi personalizzati"

::msgcat::mcset pb_msg_italian "MC(main,options,cmd_check,syntax,Label)"   "Errori di sintassi"
::msgcat::mcset pb_msg_italian "MC(main,options,cmd_check,command,Label)"  "Comandi sconosciuti"
::msgcat::mcset pb_msg_italian "MC(main,options,cmd_check,block,Label)"    "Blocchi sconosciuti"
::msgcat::mcset pb_msg_italian "MC(main,options,cmd_check,address,Label)"  "Indirizzi sconosciuti"
::msgcat::mcset pb_msg_italian "MC(main,options,cmd_check,format,Label)"   "Formati sconosciuti"

::msgcat::mcset pb_msg_italian "MC(main,options,backup,Label)"          "Backup del post"
::msgcat::mcset pb_msg_italian "MC(main,options,backup,Balloon)"        "Metodo di backup del post"
::msgcat::mcset pb_msg_italian "MC(main,options,backup,Context)"        "Crea copie di backup durante il salvataggio del post in esecuzione."

::msgcat::mcset pb_msg_italian "MC(main,options,backup,one,Label)"      "Backup dell'originale"
::msgcat::mcset pb_msg_italian "MC(main,options,backup,all,Label)"      "Esegui backup ad ogni salvataggio"
::msgcat::mcset pb_msg_italian "MC(main,options,backup,none,Label)"     "Non eseguire backup"

##-----------
## Utilities
##
::msgcat::mcset pb_msg_italian "MC(main,utils,Label)"                   "Utilità"
::msgcat::mcset pb_msg_italian "MC(main,utils,Balloon)"                 "\ Scegli\ la variabile\ MOM, installa il\ post"
::msgcat::mcset pb_msg_italian "MC(main,utils,Context)"                 " "
::msgcat::mcset pb_msg_italian "MC(main,utils,menu,Context)"            " "

::msgcat::mcset pb_msg_italian "MC(main,utils,etpdf,Label)"             "Modifica il file di dati post template"

::msgcat::mcset pb_msg_italian "MC(main,utils,bmv,Label)"               "Individua le variabili MOM"
::msgcat::mcset pb_msg_italian "MC(main,utils,blic,Label)"              "Individua le licenze"


##------
## Help
##
::msgcat::mcset pb_msg_italian "MC(main,help,Label)"                    "Guida"
::msgcat::mcset pb_msg_italian "MC(main,help,Balloon)"                  "Opzioni guida"
::msgcat::mcset pb_msg_italian "MC(main,help,Context)"                  "Opzioni guida"
::msgcat::mcset pb_msg_italian "MC(main,help,menu,Context)"             " "

::msgcat::mcset pb_msg_italian "MC(main,help,bal,Label)"                "Descrizione a fumetto"
::msgcat::mcset pb_msg_italian "MC(main,help,bal,Balloon)"              "Descrizione a fumetto sulle icone"
::msgcat::mcset pb_msg_italian "MC(main,help,bal,Context)"              "Attiva/Disattiva la visualizzazione delle descrizioni sulle icone"

::msgcat::mcset pb_msg_italian "MC(main,help,chelp,Label)"              "Guida contestuale"
::msgcat::mcset pb_msg_italian "MC(main,help,chelp,Balloon)"            "Guida contestuale sugli oggetti dialogo"
::msgcat::mcset pb_msg_italian "MC(main,help,chelp,Context)"            "Guida contestuale sugli oggetti dialogo"

::msgcat::mcset pb_msg_italian "MC(main,help,what,Label)"               "Istruzioni"
::msgcat::mcset pb_msg_italian "MC(main,help,what,Balloon)"             "Soluzioni possibili"
::msgcat::mcset pb_msg_italian "MC(main,help,what,Context)"             "Soluzioni possibili"

::msgcat::mcset pb_msg_italian "MC(main,help,dialog,Label)"             "Guida del dialogo"
::msgcat::mcset pb_msg_italian "MC(main,help,dialog,Balloon)"           "Guida di questo dialogo"
::msgcat::mcset pb_msg_italian "MC(main,help,dialog,Context)"           "Guida di questo dialogo"

::msgcat::mcset pb_msg_italian "MC(main,help,manual,Label)"             "Manuale dell'utente"
::msgcat::mcset pb_msg_italian "MC(main,help,manual,Balloon)"           "Manuale dell'utente"
::msgcat::mcset pb_msg_italian "MC(main,help,manual,Context)"           "Manuale dell'utente"

::msgcat::mcset pb_msg_italian "MC(main,help,about,Label)"              "Informazioni su Post Builder"
::msgcat::mcset pb_msg_italian "MC(main,help,about,Balloon)"            "Informazioni su Post Builder"
::msgcat::mcset pb_msg_italian "MC(main,help,about,Context)"            "Informazioni su Post Builder"

::msgcat::mcset pb_msg_italian "MC(main,help,rel_note,Label)"           "Note di release"
::msgcat::mcset pb_msg_italian "MC(main,help,rel_note,Balloon)"         "Note di release"
::msgcat::mcset pb_msg_italian "MC(main,help,rel_note,Context)"         "Note di release"

::msgcat::mcset pb_msg_italian "MC(main,help,tcl_man,Label)"            "Manuali di riferimento Tcl/Tk"
::msgcat::mcset pb_msg_italian "MC(main,help,tcl_man,Balloon)"          "Manuali di riferimento Tcl/Tk"
::msgcat::mcset pb_msg_italian "MC(main,help,tcl_man,Context)"          "Manuali di riferimento Tcl/Tk"

##----------
## Tool Bar
##
::msgcat::mcset pb_msg_italian "MC(tool,new,Label)"                     "Nuovo"
::msgcat::mcset pb_msg_italian "MC(tool,new,Context)"                   "Crea un nuovo post."

::msgcat::mcset pb_msg_italian "MC(tool,open,Label)"                    "Apri"
::msgcat::mcset pb_msg_italian "MC(tool,open,Context)"                  "Modifica un post esistente."

::msgcat::mcset pb_msg_italian "MC(tool,save,Label)"                    "Salva"
::msgcat::mcset pb_msg_italian "MC(tool,save,Context)"                  "Salva il post in fase di esecuzione."

::msgcat::mcset pb_msg_italian "MC(tool,bal,Label)"                     "Descrizione a fumetto"
::msgcat::mcset pb_msg_italian "MC(tool,bal,Context)"                   "Attiva/Disattiva la visualizzazione delle descrizioni sulle icone"

::msgcat::mcset pb_msg_italian "MC(tool,chelp,Label)"                   "Guida contestuale"
::msgcat::mcset pb_msg_italian "MC(tool,chelp,Context)"                 "Guida contestuale sugli oggetti dialogo"

::msgcat::mcset pb_msg_italian "MC(tool,what,Label)"                    "Istruzioni"
::msgcat::mcset pb_msg_italian "MC(tool,what,Context)"                  "Soluzioni possibili"

::msgcat::mcset pb_msg_italian "MC(tool,dialog,Label)"                  "Guida del dialogo"
::msgcat::mcset pb_msg_italian "MC(tool,dialog,Context)"                "Guida di questo dialogo"

::msgcat::mcset pb_msg_italian "MC(tool,manual,Label)"                  "Manuale dell'utente"
::msgcat::mcset pb_msg_italian "MC(tool,manual,Context)"                "Manuale dell'utente"

#=============
# Main Window
#=============

##-----------------
## Common Messages
##
::msgcat::mcset pb_msg_italian "MC(msg,error,title)"                    "Errore di Post Builder"
::msgcat::mcset pb_msg_italian "MC(msg,dialog,title)"                   "Messaggio di Post Builder"
::msgcat::mcset pb_msg_italian "MC(msg,warning)"                        "Avviso"
::msgcat::mcset pb_msg_italian "MC(msg,error)"                          "Errore"
::msgcat::mcset pb_msg_italian "MC(msg,invalid_data)"                   "Sono stati inseriti dati non validi per questo parametro"
::msgcat::mcset pb_msg_italian "MC(msg,invalid_browser_cmd)"            "Comando browser non valido:"
::msgcat::mcset pb_msg_italian "MC(msg,wrong_filename)"                 "Il nome file è stato modificato."
::msgcat::mcset pb_msg_italian "MC(msg,user_ctrl_limit)"                "Non è possibile usare un post concesso in licenza come controller\n per creare un nuovo post, se non se ne è l'autore."
::msgcat::mcset pb_msg_italian "MC(msg,import_limit)"                   "L'utente non è l'autore di questo post concesso in licenza.\nNon è possibile importare i comandi personalizzati."
::msgcat::mcset pb_msg_italian "MC(msg,limit_msg)"                      "L'utente non è l'autore del post concesso in licenza."
::msgcat::mcset pb_msg_italian "MC(msg,no_file)"                        "Manca il file codificato per il post concesso in licenza."
::msgcat::mcset pb_msg_italian "MC(msg,no_license)"                     "Non si dispone della licenza necessaria per eseguire la funzione."
::msgcat::mcset pb_msg_italian "MC(msg,no_license_title)"               "Uso di NX/Post Builder senza licenza"
::msgcat::mcset pb_msg_italian "MC(msg,no_license_dialog)"              "È consentito usare NX/Post Builder\n senza licenza. Non è però consentito\n salvare il lavoro eseguito."
::msgcat::mcset pb_msg_italian "MC(msg,pending)"                        "L'opzione verrà implementata nella prossima release."
::msgcat::mcset pb_msg_italian "MC(msg,save)"                           "Salvare le modifiche\nprima di chiudere il post?"
::msgcat::mcset pb_msg_italian "MC(msg,version_check)"                  "I post creati con una versione più recente del Post Builder non possono essere aperti in questa versione."

::msgcat::mcset pb_msg_italian "MC(msg,file_corruption)"                "Contenuto incorretto del file della sessione Post Builder."
::msgcat::mcset pb_msg_italian "MC(msg,bad_tcl_file)"                   "Contenuto incorretto del file Tcl del post."
::msgcat::mcset pb_msg_italian "MC(msg,bad_def_file)"                   "Contenuto incorretto del file di definizione del post."
::msgcat::mcset pb_msg_italian "MC(msg,invalid_post)"                   "Specificare almeno un gruppo di file Tcl e di definizione per il Post."
::msgcat::mcset pb_msg_italian "MC(msg,invalid_dir)"                    "La directory non esiste."
::msgcat::mcset pb_msg_italian "MC(msg,invalid_file)"                   "Il file non è stato trovato oppure non è valido."
::msgcat::mcset pb_msg_italian "MC(msg,invalid_def_file)"               "Non è possibile aprire il file di definizioni."
::msgcat::mcset pb_msg_italian "MC(msg,invalid_tcl_file)"               "Non è possibile aprire il file dell'handler di eventi"
::msgcat::mcset pb_msg_italian "MC(msg,dir_perm)"                       "Non si dispone delle autorizzazioni di scrittura necessarie per la directory."
::msgcat::mcset pb_msg_italian "MC(msg,file_perm)"                      "Non si dispone delle autorizzazioni di scrittura necessarie per "

::msgcat::mcset pb_msg_italian "MC(msg,file_exist)"                     "esiste già.\nSostituirli comunque?"
::msgcat::mcset pb_msg_italian "MC(msg,file_missing)"                   "Mancano uno o tutti i file per il post.\nImpossibile aprire il post."
::msgcat::mcset pb_msg_italian "MC(msg,sub_dialog_open)"                "Completare le modifiche di tutti i sottodialoghi dei parametri prima di salvare il post."
::msgcat::mcset pb_msg_italian "MC(msg,generic)"                        "Attualmente il Post Builder è stato implementato solo per le macchine di fresatura generica."
::msgcat::mcset pb_msg_italian "MC(msg,min_word)"                       "Un blocco deve contenere almeno una parola."
::msgcat::mcset pb_msg_italian "MC(msg,name_exists)"                    "esiste già.\nSpecificare un altro nome."
::msgcat::mcset pb_msg_italian "MC(msg,in_use)"                         "Questo componente è in uso.\nNon può essere eliminato."
::msgcat::mcset pb_msg_italian "MC(msg,do_you_want_to_proceed)"         "Possono essere considerati come elementi di dati esistenti. Continuare."
::msgcat::mcset pb_msg_italian "MC(msg,not_installed_properly)"         "non è stato installato correttamente."
::msgcat::mcset pb_msg_italian "MC(msg,no_app_to_open)"                 "Non c'è nessuna applicazione da aprire"
::msgcat::mcset pb_msg_italian "MC(msg,save_change)"                    "Salvare le modifiche?"

::msgcat::mcset pb_msg_italian "MC(msg,external_editor)"                "Editor esterno"

# - Do not translate EDITOR
::msgcat::mcset pb_msg_italian "MC(msg,set_ext_editor)"                 "Usare la variabile di ambiente EDITOR per aprire l'editor di testo desiderato."
::msgcat::mcset pb_msg_italian "MC(msg,filename_with_space)"            "I nomi file contenenti spazi non sono supportati."
::msgcat::mcset pb_msg_italian "MC(msg,filename_protection)"            "Il file selezionato ed usato da uno dei post modifica non può essere sovrascritto."


##--------------------
## Common Function
##
::msgcat::mcset pb_msg_italian "MC(msg,parent_win)"                     "Per aprire una finestra temporanea è necessario definire la finestra padre."
::msgcat::mcset pb_msg_italian "MC(msg,close_subwin)"                   "Chiudere tutte le sottofinestre per attivare la scheda."
::msgcat::mcset pb_msg_italian "MC(msg,block_exist)"                    "Un elemento della parola selezionata esiste già nel template blocco."
::msgcat::mcset pb_msg_italian "MC(msg,num_gcode_1)"                    "Il numero di codici G è limitato a"
::msgcat::mcset pb_msg_italian "MC(msg,num_gcode_2)"                    "per blocco"
::msgcat::mcset pb_msg_italian "MC(msg,num_mcode_1)"                    "Il numero di codici M è limitato a"
::msgcat::mcset pb_msg_italian "MC(msg,num_mcode_2)"                    "per blocco"
::msgcat::mcset pb_msg_italian "MC(msg,empty_entry)"                    "La voce non può essere vuota."

::msgcat::mcset pb_msg_italian "MC(msg,edit_feed_fmt)"                  "I formati dell'indirizzo \"F\" possono essere modificati nella pagina dei parametri della Velocità di avanzamento"

::msgcat::mcset pb_msg_italian "MC(msg,seq_num_max)"                    "Il valore massimo del numero di sequenza non deve superare il numero massimo N di indirizzi stabilito in"

::msgcat::mcset pb_msg_italian "MC(msg,no_cdl_name)"                    "Specificare il nome post."
::msgcat::mcset pb_msg_italian "MC(msg,no_def_name)"                    "La cartella deve essere specificata.\nConformarsi al seguente pattern \"\$UGII_*\"!"
::msgcat::mcset pb_msg_italian "MC(msg,no_own_name)"                    "La cartella deve essere specificata.\nConformarsi al seguente pattern \"\$UGII_*\"!"
::msgcat::mcset pb_msg_italian "MC(msg,no_oth_ude_name)"                "Il nome file cdl deve essere specificato.\nConformarsi al seguente pattern \"\$UGII_*\"!"
::msgcat::mcset pb_msg_italian "MC(msg,not_oth_cdl_file)"               "Sono consentiti solo file CDL."
::msgcat::mcset pb_msg_italian "MC(msg,not_pui_file)"                   "Sono consentiti solo file PUI."
::msgcat::mcset pb_msg_italian "MC(msg,not_cdl_file)"                   "Sono consentiti solo file CDL."
::msgcat::mcset pb_msg_italian "MC(msg,not_def_file)"                   "Sono consentiti solo file DEF."
::msgcat::mcset pb_msg_italian "MC(msg,not_own_cdl_file)"               "Sono consentiti solo file CDL di proprietà."
::msgcat::mcset pb_msg_italian "MC(msg,no_cdl_file)"                    "Il post selezionato non ha un file CDL associato."
::msgcat::mcset pb_msg_italian "MC(msg,cdl_info)"                       "I file di definizione e CDL del post selezionato vengono referenziati (INCLUDE) nel file di definizione del post.\nIl file Tcl del post selezionato verrà anche referenziato dal file dell'handler eventi durante l'esecuzione."

::msgcat::mcset pb_msg_italian "MC(msg,add_max1)"                       "Il valore massimo dell'ndirizzo"
::msgcat::mcset pb_msg_italian "MC(msg,add_max2)"                       "non deve superare il numero stabilito per il formato della"


::msgcat::mcset pb_msg_italian "MC(com,text_entry_trans,title,Label)"   "voce"

##---------------------------
## Common Navigation Buttons
##
::msgcat::mcset pb_msg_italian "MC(nav_button,no_license,Message)"      "Non si dispone della licenza necessaria per eseguire la funzione."

::msgcat::mcset pb_msg_italian "MC(nav_button,ok,Label)"                "OK"
::msgcat::mcset pb_msg_italian "MC(nav_button,ok,Context)"              "Il pulsante è disponibile solo come sottodialogo. Consente di salvare le modifiche e uscire dal dialogo."
::msgcat::mcset pb_msg_italian "MC(nav_button,cancel,Label)"            "Annulla"
::msgcat::mcset pb_msg_italian "MC(nav_button,cancel,Context)"          "Il pulsante è disponibile nei sottodialoghi. Consente di uscire dal dialogo."
::msgcat::mcset pb_msg_italian "MC(nav_button,default,Label)"           "Predefinito"
::msgcat::mcset pb_msg_italian "MC(nav_button,default,Context)"         "Il pulsante consente di ripristinare i parametri del dialogo attuale di un componente ricreando la condizione presente al momento di creazione o apertura del post durante questa sessione. \n \nTuttavia, per il nome del componente (se presente) viene ripristinato solo lo stato del nome riscontrato al momento dell'apertura del componente durante l'operazione."
::msgcat::mcset pb_msg_italian "MC(nav_button,restore,Label)"           "Ripristina"
::msgcat::mcset pb_msg_italian "MC(nav_button,restore,Context)"         "Il pulsante consente di ripristinare i parametri del dialogo attuale presenti nelle impostazioni iniziali al momento dell'accesso corrente al componente.  "
::msgcat::mcset pb_msg_italian "MC(nav_button,apply,Label)"             "Applica"
::msgcat::mcset pb_msg_italian "MC(nav_button,apply,Context)"           "Il pulsante consente di salvare le modifiche senza chiudere il dialogo attuale. L'operazione permette anche di ripristinare le condizioni iniziali del dialogo attuale. \n \n(Vedere Ripristina per le condizioni iniziali)"
::msgcat::mcset pb_msg_italian "MC(nav_button,filter,Label)"            "Filtro"
::msgcat::mcset pb_msg_italian "MC(nav_button,filter,Context)"          "Il pulsante consente di applicare il filtro della directory e di elencare i file che rispondono alle condizioni."
::msgcat::mcset pb_msg_italian "MC(nav_button,yes,Label)"               "Sì"
::msgcat::mcset pb_msg_italian "MC(nav_button,yes,Context)"             "Sì"
::msgcat::mcset pb_msg_italian "MC(nav_button,no,Label)"                "No"
::msgcat::mcset pb_msg_italian "MC(nav_button,no,Context)"              "No"
::msgcat::mcset pb_msg_italian "MC(nav_button,help,Label)"              "Guida"
::msgcat::mcset pb_msg_italian "MC(nav_button,help,Context)"            "Guida"

::msgcat::mcset pb_msg_italian "MC(nav_button,open,Label)"              "Apri"
::msgcat::mcset pb_msg_italian "MC(nav_button,open,Context)"            "Il pulsante consente di aprire il post selezionato per le modifiche."

::msgcat::mcset pb_msg_italian "MC(nav_button,save,Label)"              "Salva"
::msgcat::mcset pb_msg_italian "MC(nav_button,save,Context)"            "Il pulsante disponibile nel dialogo Salva con nome consente di salvare il post in elaborazione."

::msgcat::mcset pb_msg_italian "MC(nav_button,manage,Label)"            "Gestisci..."
::msgcat::mcset pb_msg_italian "MC(nav_button,manage,Context)"          "Il pulsante consente di gestire la cronistoria dei post aperti di recente."

::msgcat::mcset pb_msg_italian "MC(nav_button,refresh,Label)"           "Aggiorna"
::msgcat::mcset pb_msg_italian "MC(nav_button,refresh,Context)"         "Il pulsante consente di aggiornare l'elenco in funzione dell'esistenza degli oggetti."

::msgcat::mcset pb_msg_italian "MC(nav_button,cut,Label)"               "Taglio"
::msgcat::mcset pb_msg_italian "MC(nav_button,cut,Context)"             "Il pulsante consente di 'tagliare' dall'elenco l'oggetto selezionato."

::msgcat::mcset pb_msg_italian "MC(nav_button,copy,Label)"              "Copia"
::msgcat::mcset pb_msg_italian "MC(nav_button,copy,Context)"            "Il pulsante consente di copiare l'oggetto selezionato."

::msgcat::mcset pb_msg_italian "MC(nav_button,paste,Label)"             "Incolla"
::msgcat::mcset pb_msg_italian "MC(nav_button,paste,Context)"           "Il pulsante consente di incollare l'oggetto del buffer nell'elenco. "

::msgcat::mcset pb_msg_italian "MC(nav_button,edit,Label)"              "Modifica"
::msgcat::mcset pb_msg_italian "MC(nav_button,edit,Context)"            "Il pulsante di modificare l'oggetto nel buffer."

::msgcat::mcset pb_msg_italian "MC(nav_button,ex_editor,Label)"         "Usa editor esterno"

##------------
## New dialog
##
::msgcat::mcset pb_msg_italian "MC(new,title,Label)"                    "Crea nuovo post processor"
::msgcat::mcset pb_msg_italian "MC(new,Status)"                         "Inserire il nome e scegliere il parametro per il nuovo post."

::msgcat::mcset pb_msg_italian "MC(new,name,Label)"                     "Nome post"
::msgcat::mcset pb_msg_italian "MC(new,name,Context)"                   "Nome del post processor da creare"

::msgcat::mcset pb_msg_italian "MC(new,desc,Label)"                     "Descrizione"
::msgcat::mcset pb_msg_italian "MC(new,desc,Context)"                   "Descrizione del post processor da creare"

#Description for each selection
::msgcat::mcset pb_msg_italian "MC(new,mill,desc,Label)"                "Questa è una macchina per la fresatura."
::msgcat::mcset pb_msg_italian "MC(new,lathe,desc,Label)"               "Questa è una macchina per la tornitura."
::msgcat::mcset pb_msg_italian "MC(new,wedm,desc,Label)"                "Questa è una macchina per l'elettroerosione a filo."

::msgcat::mcset pb_msg_italian "MC(new,wedm_2,desc,Label)"              "Questa è una macchina per l'elettroerosione a filo a due assi."
::msgcat::mcset pb_msg_italian "MC(new,wedm_4,desc,Label)"              "Questa è una macchina per l'elettroerosione a filo a quattro assi."
::msgcat::mcset pb_msg_italian "MC(new,lathe_2,desc,Label)"             "Questa è una macchina per la tornitura orizzontale a due assi."
::msgcat::mcset pb_msg_italian "MC(new,lathe_4,desc,Label)"             "Questa è una macchina per la tornitura dipendente a quattro assi."
::msgcat::mcset pb_msg_italian "MC(new,mill_3,desc,Label)"              "Questa è una macchina per la fresatura a tre assi."
::msgcat::mcset pb_msg_italian "MC(new,mill_3MT,desc,Label)"            "Tornitura/fresatura a tre assi (XZC)"
::msgcat::mcset pb_msg_italian "MC(new,mill_4H,desc,Label)"             "Questa è una macchina per la fresatura a quattro assi con\n testa di rotazione."
::msgcat::mcset pb_msg_italian "MC(new,mill_4T,desc,Label)"             "Questa è una macchina per la fresatura a quattro assi con\n tavola di rotazione."
::msgcat::mcset pb_msg_italian "MC(new,mill_5TT,desc,Label)"            "Questa è una macchina per la fresatura a cinque assi con\n doppia tavola di rotazione."
::msgcat::mcset pb_msg_italian "MC(new,mill_5HH,desc,Label)"            "Questa è una macchina per la fresatura a cinque assi con\n doppia testa di rotazione."
::msgcat::mcset pb_msg_italian "MC(new,mill_5HT,desc,Label)"            "Questa è una macchina per la fresatura a cinque assi con\n testa e tavola di rotazione."
::msgcat::mcset pb_msg_italian "MC(new,punch,desc,Label)"               "Questa è una macchina per la punzonatura. "

::msgcat::mcset pb_msg_italian "MC(new,post_unit,Label)"                "Unità di misura di output post"

::msgcat::mcset pb_msg_italian "MC(new,inch,Label)"                     "Pollici"
::msgcat::mcset pb_msg_italian "MC(new,inch,Context)"                   "Pollici: unità di misura output post"
::msgcat::mcset pb_msg_italian "MC(new,millimeter,Label)"               "Millimetri"
::msgcat::mcset pb_msg_italian "MC(new,millimeter,Context)"             "Millimetri: unità di misura ouput post"

::msgcat::mcset pb_msg_italian "MC(new,machine,Label)"                  "Macchina utensile"
::msgcat::mcset pb_msg_italian "MC(new,machine,Context)"                "Tipo di macchina utensile per cui creare il post processor."

::msgcat::mcset pb_msg_italian "MC(new,mill,Label)"                     "Fresatura"
::msgcat::mcset pb_msg_italian "MC(new,mill,Context)"                   "Fresatrice"
::msgcat::mcset pb_msg_italian "MC(new,lathe,Label)"                    "Tornitura"
::msgcat::mcset pb_msg_italian "MC(new,lathe,Context)"                  "Tornio"
::msgcat::mcset pb_msg_italian "MC(new,wire,Label)"                     "Elettroerosione a filo"
::msgcat::mcset pb_msg_italian "MC(new,wire,Context)"                   "Elettroerosione a filo"
::msgcat::mcset pb_msg_italian "MC(new,punch,Label)"                    "Punzonatura"

::msgcat::mcset pb_msg_italian "MC(new,axis,Label)"                     "Selezione assi macchina"
::msgcat::mcset pb_msg_italian "MC(new,axis,Context)"                   "Numero e tipo di assi macchina"

#Axis Number
::msgcat::mcset pb_msg_italian "MC(new,axis_2,Label)"                   "A 2 assi"
::msgcat::mcset pb_msg_italian "MC(new,axis_3,Label)"                   "A 3 assi"
::msgcat::mcset pb_msg_italian "MC(new,axis_4,Label)"                   "A 4 assi"
::msgcat::mcset pb_msg_italian "MC(new,axis_5,Label)"                   "A 5 assi"
::msgcat::mcset pb_msg_italian "MC(new,axis_XZC,Label)"                 "XZC"


#Axis Type
::msgcat::mcset pb_msg_italian "MC(new,mach_axis,Label)"                "Asse macchina utensile"
::msgcat::mcset pb_msg_italian "MC(new,mach_axis,Context)"              "Seleziona l'asse macchina utensile"
::msgcat::mcset pb_msg_italian "MC(new,lathe_2,Label)"                  "A 2 assi"
::msgcat::mcset pb_msg_italian "MC(new,mill_3,Label)"                   "A 3 assi"
::msgcat::mcset pb_msg_italian "MC(new,mill_3MT,Label)"                 "Tornitura/Fresatura a tre assi (XZC)"
::msgcat::mcset pb_msg_italian "MC(new,mill_4T,Label)"                  "A quattro assi con tavola di rotazione "
::msgcat::mcset pb_msg_italian "MC(new,mill_4H,Label)"                  "A quattro assi con testa di rotazione "
::msgcat::mcset pb_msg_italian "MC(new,lathe_4,Label)"                  "A 4 assi"
::msgcat::mcset pb_msg_italian "MC(new,mill_5HH,Label)"                 "A cinque assi con doppia testa di rotazione"
::msgcat::mcset pb_msg_italian "MC(new,mill_5TT,Label)"                 "A cinque assi con doppia tavola di rotazione"
::msgcat::mcset pb_msg_italian "MC(new,mill_5HT,Label)"                 "A cinque assi con testa e tavola di rotazione"
::msgcat::mcset pb_msg_italian "MC(new,wedm_2,Label)"                   "A 2 assi"
::msgcat::mcset pb_msg_italian "MC(new,wedm_4,Label)"                   "A 4 assi"
::msgcat::mcset pb_msg_italian "MC(new,punch,Label)"                    "Punzonatura"

::msgcat::mcset pb_msg_italian "MC(new,control,Label)"                  "Controller"
::msgcat::mcset pb_msg_italian "MC(new,control,Context)"                "Selezionare il controller post."

#Controller Type
::msgcat::mcset pb_msg_italian "MC(new,generic,Label)"                  "Generico"
::msgcat::mcset pb_msg_italian "MC(new,library,Label)"                  "Libreria"
::msgcat::mcset pb_msg_italian "MC(new,user,Label)"                     "Dell'utente"
::msgcat::mcset pb_msg_italian "MC(new,user,browse,Label)"              "Sfoglia"

# - Machine tool/ controller brands
::msgcat::mcset pb_msg_italian "MC(new,allen,Label)"                    "Allen Bradley"
::msgcat::mcset pb_msg_italian "MC(new,bridge,Label)"                   "Bridgeport"
::msgcat::mcset pb_msg_italian "MC(new,brown,Label)"                    "Brown & Sharp"
::msgcat::mcset pb_msg_italian "MC(new,cincin,Label)"                   "Cincinnatti Milacron"
::msgcat::mcset pb_msg_italian "MC(new,kearny,Label)"                   "Kearny & Tracker"
::msgcat::mcset pb_msg_italian "MC(new,fanuc,Label)"                    "Fanuc"
::msgcat::mcset pb_msg_italian "MC(new,ge,Label)"                       "General Electric"
::msgcat::mcset pb_msg_italian "MC(new,gn,Label)"                       "General Numerics"
::msgcat::mcset pb_msg_italian "MC(new,gidding,Label)"                  "Gidding & Lewis"
::msgcat::mcset pb_msg_italian "MC(new,heiden,Label)"                   "Heidenhain"
::msgcat::mcset pb_msg_italian "MC(new,mazak,Label)"                    "Mazak"
::msgcat::mcset pb_msg_italian "MC(new,seimens,Label)"                  "Siemens"

##-------------
## Open dialog
##
::msgcat::mcset pb_msg_italian "MC(open,title,Label)"                   "Modifica post"
::msgcat::mcset pb_msg_italian "MC(open,Status)"                        "Scegliere il file PUI da aprire."
::msgcat::mcset pb_msg_italian "MC(open,file_type_pui)"                 "File di sessione Post Builder"
::msgcat::mcset pb_msg_italian "MC(open,file_type_tcl)"                 "File di script Tcl"
::msgcat::mcset pb_msg_italian "MC(open,file_type_def)"                 "File di definizione"
::msgcat::mcset pb_msg_italian "MC(open,file_type_cdl)"                 "File CDL"

##-------------
## Misc dialog
##
::msgcat::mcset pb_msg_italian "MC(open_save,dlg,title,Label)"          "Seleziona un file"
::msgcat::mcset pb_msg_italian "MC(exp_cc,dlg,title,Label)"             "Esporta comandi personalizzati"
::msgcat::mcset pb_msg_italian "MC(show_mt,title,Label)"                "Macchina utensile"

##----------------
## Utils dialog
##
::msgcat::mcset pb_msg_italian "MC(mvb,title,Label)"                    "Browser variabili MOM"
::msgcat::mcset pb_msg_italian "MC(mvb,cat,Label)"                      "Categoria"
::msgcat::mcset pb_msg_italian "MC(mvb,search,Label)"                   "Ricerca"
::msgcat::mcset pb_msg_italian "MC(mvb,defv,Label)"                     "Valore predefinito"
::msgcat::mcset pb_msg_italian "MC(mvb,posv,Label)"                     "Valori possibili"
::msgcat::mcset pb_msg_italian "MC(mvb,data,Label)"                     "Tipo di dati"
::msgcat::mcset pb_msg_italian "MC(mvb,desc,Label)"                     "Descrizione"

::msgcat::mcset pb_msg_italian "MC(inposts,title,Label)"                "Modifica template_post.dat"
::msgcat::mcset pb_msg_italian "MC(tpdf,text,Label)"                    "File di dati post template"
::msgcat::mcset pb_msg_italian "MC(inposts,edit,title,Label)"           "Modifica una linea"
::msgcat::mcset pb_msg_italian "MC(inposts,edit,post,Label)"            "Post"


##----------------
## Save As dialog
##
::msgcat::mcset pb_msg_italian "MC(save_as,title,Label)"                "Salva con nome"
::msgcat::mcset pb_msg_italian "MC(save_as,name,Label)"                 "Nome post"
::msgcat::mcset pb_msg_italian "MC(save_as,name,Context)"               "Il nome con cui salvare il post processor."
::msgcat::mcset pb_msg_italian "MC(save_as,Status)"                     "Inserire in nome del nuovo file post."
::msgcat::mcset pb_msg_italian "MC(save_as,file_type_pui)"              "File di sessione Post Builder"

##----------------
## Common Widgets
##
::msgcat::mcset pb_msg_italian "MC(common,entry,Label)"                 "Voce"
::msgcat::mcset pb_msg_italian "MC(common,entry,Context)"               "Specificare il nuovo valore nel campo di immissione."

##-----------
## Note Book
##
::msgcat::mcset pb_msg_italian "MC(nbook,tab,Label)"                    "Scheda "
::msgcat::mcset pb_msg_italian "MC(nbook,tab,Context)"                  "Si può selezionare una scheda da inserire in una certa pagina di parametri. \n \nI parametri di una scheda possono essere suddivisi in gruppi. Ogni gruppo di parametri può essere aperto tramite un'altra scheda."

##------
## Tree
##
::msgcat::mcset pb_msg_italian "MC(tree,select,Label)"                  "Struttura ad albero componenti"
::msgcat::mcset pb_msg_italian "MC(tree,select,Context)"                "Selezionare il componente da visualizzare oppure modificarne il contenuto o i relativi parametri."
::msgcat::mcset pb_msg_italian "MC(tree,create,Label)"                  "Crea"
::msgcat::mcset pb_msg_italian "MC(tree,create,Context)"                "Crea un nuovo componente copiando l'oggetto selezionato."
::msgcat::mcset pb_msg_italian "MC(tree,cut,Label)"                     "Taglia"
::msgcat::mcset pb_msg_italian "MC(tree,cut,Context)"                   "Taglia un componente."
::msgcat::mcset pb_msg_italian "MC(tree,paste,Label)"                   "Incolla"
::msgcat::mcset pb_msg_italian "MC(tree,paste,Context)"                 "Incolla un componente."
::msgcat::mcset pb_msg_italian "MC(tree,rename,Label)"                  "Assegna nuovo nome"

##------------------
## Encrypt dialogs
##
::msgcat::mcset pb_msg_italian "MC(encrypt,browser,Label)"              "Elenco di licenze"
::msgcat::mcset pb_msg_italian "MC(encrypt,title,Label)"                "Seleziona una licenza"
::msgcat::mcset pb_msg_italian "MC(encrypt,output,Label)"               "Codifica output"
::msgcat::mcset pb_msg_italian "MC(encrypt,license,Label)"              "Licenza:  "

#++++++++++++++
# Machine Tool
#++++++++++++++
::msgcat::mcset pb_msg_italian "MC(machine,tab,Label)"                  "Macchina utensile"
::msgcat::mcset pb_msg_italian "MC(machine,Status)"                     "Specifica i parametri di cinematica macchina."

::msgcat::mcset pb_msg_italian "MC(msg,no_display)"                     "Non è disponibile l'immagine di questa configurazione macchina utensile."
::msgcat::mcset pb_msg_italian "MC(msg,no_4th_ctable)"                  "La tabella C del quarto asse non è consentita."
::msgcat::mcset pb_msg_italian "MC(msg,no_4th_max_min)"                 "Il limite massimo del quarto asse non può essere uguale al limite minimo."
::msgcat::mcset pb_msg_italian "MC(msg,no_4th_both_neg)"                "I limiti del quarto asse non possono essere entrambi negativi."
::msgcat::mcset pb_msg_italian "MC(msg,no_4th_5th_plane)"               "Il piano del quarto asse non può essere uguale a quello del quinto asse."
::msgcat::mcset pb_msg_italian "MC(msg,no_4thT_5thH)"                   "La tavola del quarto asse e la testa del quinto asse non sono consentite."
::msgcat::mcset pb_msg_italian "MC(msg,no_5th_max_min)"                 "Il limite massimo del quinto asse non può essere uguale al limite minimo."
::msgcat::mcset pb_msg_italian "MC(msg,no_5th_both_neg)"                "I limiti del quinto asse non possono essere entrambi negativi."

##---------
# Post Info
##
::msgcat::mcset pb_msg_italian "MC(machine,info,title,Label)"           "Informazioni sul post"
::msgcat::mcset pb_msg_italian "MC(machine,info,desc,Label)"            "Descrizione"
::msgcat::mcset pb_msg_italian "MC(machine,info,type,Label)"            "Tipo di macchina"
::msgcat::mcset pb_msg_italian "MC(machine,info,kinematics,Label)"      "Cinematica"
::msgcat::mcset pb_msg_italian "MC(machine,info,unit,Label)"            "Unità di output"
::msgcat::mcset pb_msg_italian "MC(machine,info,controller,Label)"      "Controller"
::msgcat::mcset pb_msg_italian "MC(machine,info,history,Label)"         "Cronistoria"

##---------
## Display
##
::msgcat::mcset pb_msg_italian "MC(machine,display,Label)"              "Visualizza macchina utensile"
::msgcat::mcset pb_msg_italian "MC(machine,display,Context)"            "L'opzione consente di visualizzare la macchina utensile"
::msgcat::mcset pb_msg_italian "MC(machine,display_trans,title,Label)"  "Macchina utensile"


##---------------
## General parms
##
::msgcat::mcset pb_msg_italian "MC(machine,gen,Label)"                      "Parametri generali"
    
::msgcat::mcset pb_msg_italian "MC(machine,gen,out_unit,Label)"             "Unità di misura output post:"
::msgcat::mcset pb_msg_italian "MC(machine,gen,out_unit,Context)"           "Unità di misura output di postprocessamento"
::msgcat::mcset pb_msg_italian "MC(machine,gen,out_unit,inch,Label)"        "Pollici" 
::msgcat::mcset pb_msg_italian "MC(machine,gen,out_unit,metric,Label)"      "Metrico"

::msgcat::mcset pb_msg_italian "MC(machine,gen,travel_limit,Label)"         "Limiti corsa asse lineare"
::msgcat::mcset pb_msg_italian "MC(machine,gen,travel_limit,Context)"       "Limiti corsa asse lineare"
::msgcat::mcset pb_msg_italian "MC(machine,gen,travel_limit,x,Label)"       "X"
::msgcat::mcset pb_msg_italian "MC(machine,gen,travel_limit,x,Context)"     "Specifica il limite della corsa macchina lungo l'asse X."
::msgcat::mcset pb_msg_italian "MC(machine,gen,travel_limit,y,Label)"       "Y"
::msgcat::mcset pb_msg_italian "MC(machine,gen,travel_limit,y,Context)"     "Specifica il limite della corsa macchina lungo l'asse Y."
::msgcat::mcset pb_msg_italian "MC(machine,gen,travel_limit,z,Label)"       "Z"
::msgcat::mcset pb_msg_italian "MC(machine,gen,travel_limit,z,Context)"     "Specifica il limite della corsa macchina lungo l'asse Z."

::msgcat::mcset pb_msg_italian "MC(machine,gen,home_pos,Label)"             "Posizione home"
::msgcat::mcset pb_msg_italian "MC(machine,gen,home_pos,Context)"           "Posizione home"
::msgcat::mcset pb_msg_italian "MC(machine,gen,home_pos,x,Label)"           "X"
::msgcat::mcset pb_msg_italian "MC(machine,gen,home_pos,x,Context)"         "La posizione home macchina dell'asse X rispetto alla posizione zero fisica dell'asse. La macchina torna in posizione per la sostituzione automatica dell'utensile."
::msgcat::mcset pb_msg_italian "MC(machine,gen,home_pos,y,Label)"           "Y"
::msgcat::mcset pb_msg_italian "MC(machine,gen,home_pos,y,Context)"         "La posizione home macchina dell'asse Y rispetto alla posizione zero fisica dell'asse. La macchina torna in posizione per la sostituzione automatica dell'utensile."
::msgcat::mcset pb_msg_italian "MC(machine,gen,home_pos,z,Label)"           "Z"
::msgcat::mcset pb_msg_italian "MC(machine,gen,home_pos,z,Context)"         "La posizione home macchina dell'asse Z rispetto alla posizione zero fisica dell'asse. La macchina torna in posizione per la sostituzione automatica dell'utensile."

::msgcat::mcset pb_msg_italian "MC(machine,gen,step_size,Label)"            "Risoluzione movimento lineare"
::msgcat::mcset pb_msg_italian "MC(machine,gen,step_size,min,Label)"        "Minimo"
::msgcat::mcset pb_msg_italian "MC(machine,gen,step_size,min,Context)"      "Risoluzione minima"

::msgcat::mcset pb_msg_italian "MC(machine,gen,traverse_feed,Label)"        "Velocità di avanzamento trasversale"
::msgcat::mcset pb_msg_italian "MC(machine,gen,traverse_feed,max,Label)"    "Massimo"
::msgcat::mcset pb_msg_italian "MC(machine,gen,traverse_feed,max,Context)"  "Velocità di avanzamento massima"

::msgcat::mcset pb_msg_italian "MC(machine,gen,circle_record,Label)"        "Output record circolare"
::msgcat::mcset pb_msg_italian "MC(machine,gen,circle_record,yes,Label)"    "Sì"
::msgcat::mcset pb_msg_italian "MC(machine,gen,circle_record,yes,Context)"  "Output record circolare"
::msgcat::mcset pb_msg_italian "MC(machine,gen,circle_record,no,Label)"     "No"
::msgcat::mcset pb_msg_italian "MC(machine,gen,circle_record,no,Context)"   "Output record lineare"

::msgcat::mcset pb_msg_italian "MC(machine,gen,config_4and5_axis,oth,Label)"    "Altro"

# Wire EDM parameters
::msgcat::mcset pb_msg_italian "MC(machine,gen,wedm,wire_tilt)"             "Controllo inclinazione cavo"
::msgcat::mcset pb_msg_italian "MC(machine,gen,wedm,angle)"                 "Angoli"
::msgcat::mcset pb_msg_italian "MC(machine,gen,wedm,coord)"                 "Coordinate"

# Lathe parameters
::msgcat::mcset pb_msg_italian "MC(machine,gen,turret,Label)"               "Torretta"
::msgcat::mcset pb_msg_italian "MC(machine,gen,turret,Context)"             "Torretta"
::msgcat::mcset pb_msg_italian "MC(machine,gen,turret,conf,Label)"          "Configura"
::msgcat::mcset pb_msg_italian "MC(machine,gen,turret,conf,Context)"        "Nella modalità a due torrette, questa opzione consente di configurare i parametri."
::msgcat::mcset pb_msg_italian "MC(machine,gen,turret,one,Label)"           "Una torretta"
::msgcat::mcset pb_msg_italian "MC(machine,gen,turret,one,Context)"         "Macchina per la tornitura a una torretta"
::msgcat::mcset pb_msg_italian "MC(machine,gen,turret,two,Label)"           "Due torrette"
::msgcat::mcset pb_msg_italian "MC(machine,gen,turret,two,Context)"         "Macchina per la tornitura a due torrette"

::msgcat::mcset pb_msg_italian "MC(machine,gen,turret,conf_trans,Label)"    "Configurazione torretta"
::msgcat::mcset pb_msg_italian "MC(machine,gen,turret,prim,Label)"          "Torretta principale"
::msgcat::mcset pb_msg_italian "MC(machine,gen,turret,prim,Context)"        "Seleziona la designazione della torretta principale."
::msgcat::mcset pb_msg_italian "MC(machine,gen,turret,sec,Label)"           "Torretta secondaria"
::msgcat::mcset pb_msg_italian "MC(machine,gen,turret,sec,Context)"         "Seleziona la designazione della torretta secondaria."
::msgcat::mcset pb_msg_italian "MC(machine,gen,turret,designation,Label)"   "Designazione"
::msgcat::mcset pb_msg_italian "MC(machine,gen,turret,xoff,Label)"          "Offset X"
::msgcat::mcset pb_msg_italian "MC(machine,gen,turret,xoff,Context)"        "Specificare l'offset X."
::msgcat::mcset pb_msg_italian "MC(machine,gen,turret,zoff,Label)"          "Offset Z"
::msgcat::mcset pb_msg_italian "MC(machine,gen,turret,zoff,Context)"        "Specificare l'offset Z."

::msgcat::mcset pb_msg_italian "MC(machine,gen,turret,front,Label)"         "PARTE ANTERIORE"
::msgcat::mcset pb_msg_italian "MC(machine,gen,turret,rear,Label)"          "PARTE POSTERIORE"
::msgcat::mcset pb_msg_italian "MC(machine,gen,turret,right,Label)"         "DESTRA"
::msgcat::mcset pb_msg_italian "MC(machine,gen,turret,left,Label)"          "SINISTRA"
::msgcat::mcset pb_msg_italian "MC(machine,gen,turret,side,Label)"          "LATERALE"
::msgcat::mcset pb_msg_italian "MC(machine,gen,turret,saddle,Label)"        "SELLA"

::msgcat::mcset pb_msg_italian "MC(machine,gen,axis_multi,Label)"           "Moltiplicatori asse"
::msgcat::mcset pb_msg_italian "MC(machine,gen,axis_multi,dia,Label)"       "Programmazione diametro"
::msgcat::mcset pb_msg_italian "MC(machine,gen,axis_multi,dia,Context)"     "Le opzioni consentono di attivare la programmazione diametro raddoppiando il valore degli indirizzi selezionati nell'output NC."
::msgcat::mcset pb_msg_italian "MC(machine,gen,axis_multi,2x,Label)"        "2X"
::msgcat::mcset pb_msg_italian "MC(machine,gen,axis_multi,2x,Context)"      "L'opzione consente di attivare la programmazione diametro raddoppiando le coordinate asse X nell'output NC."

::msgcat::mcset pb_msg_italian "MC(machine,gen,axis_multi,2y,Label)"        "2Y"
::msgcat::mcset pb_msg_italian "MC(machine,gen,axis_multi,2y,Context)"      "L'opzione consente di attivare la programmazione diametro raddoppiando le coordinate asse Y nell'output NC."
::msgcat::mcset pb_msg_italian "MC(machine,gen,axis_multi,2i,Label)"        "2I"
::msgcat::mcset pb_msg_italian "MC(machine,gen,axis_multi,2i,Context)"      "L'opzione consente di raddoppiare i valori di I per i record circolari durante l'uso della programmazione diametro."
::msgcat::mcset pb_msg_italian "MC(machine,gen,axis_multi,2j,Label)"        "2J"
::msgcat::mcset pb_msg_italian "MC(machine,gen,axis_multi,2j,Context)"      "L'opzione consente di raddoppiare i valori di J per i record circolari durante l'uso della programmazione diametro."

::msgcat::mcset pb_msg_italian "MC(machine,gen,axis_multi,mir,Label)"       "Copia speculare output"
::msgcat::mcset pb_msg_italian "MC(machine,gen,axis_multi,mir,Context)"     "Le opzioni consentono di eseguire una copia speculare degli indirizzi selezionati trasformandone i valori in valori negativi nell'output NC."
::msgcat::mcset pb_msg_italian "MC(machine,gen,axis_multi,x,Label)"         "-X"
::msgcat::mcset pb_msg_italian "MC(machine,gen,axis_multi,x,Context)"       "L'opzione consente di trasformare le coordinate dell'asse X nelle corrispondenti coordinate negative nell'output NC."
::msgcat::mcset pb_msg_italian "MC(machine,gen,axis_multi,y,Label)"         "-Y"
::msgcat::mcset pb_msg_italian "MC(machine,gen,axis_multi,y,Context)"       "L'opzione consente di trasformare le coordinate dell'asse Y nelle corrispondenti coordinate negative nell'output NC."
::msgcat::mcset pb_msg_italian "MC(machine,gen,axis_multi,z,Label)"         "-Z"
::msgcat::mcset pb_msg_italian "MC(machine,gen,axis_multi,z,Context)"       "L'opzione consente di trasformare le coordinate dell'asse Z nelle corrispondenti coordinate negative nell'output NC."
::msgcat::mcset pb_msg_italian "MC(machine,gen,axis_multi,i,Label)"         "-I"
::msgcat::mcset pb_msg_italian "MC(machine,gen,axis_multi,i,Context)"       "L'opzione consente di trasformare i valori di I dei record circolari nei corrispondenti valori negativi nell'output NC."
::msgcat::mcset pb_msg_italian "MC(machine,gen,axis_multi,j,Label)"         "-J"
::msgcat::mcset pb_msg_italian "MC(machine,gen,axis_multi,j,Context)"       "L'opzione consente di trasformare i valori di J dei record circolari nei corrispondenti valori negativi nell'output NC."
::msgcat::mcset pb_msg_italian "MC(machine,gen,axis_multi,k,Label)"         "-K"
::msgcat::mcset pb_msg_italian "MC(machine,gen,axis_multi,k,Context)"       "L'opzione consente di trasformare i valori di K dei record circolari nei corrispondenti valori negativi nell'output NC."

::msgcat::mcset pb_msg_italian "MC(machine,gen,output,Label)"               "Metodo di ouput"
::msgcat::mcset pb_msg_italian "MC(machine,gen,output,Context)"             "Metodo di ouput"
::msgcat::mcset pb_msg_italian "MC(machine,gen,output,tool_tip,Label)"      "Punta utensile"
::msgcat::mcset pb_msg_italian "MC(machine,gen,output,tool_tip,Context)"    "Output relativo alla punta utensile"
::msgcat::mcset pb_msg_italian "MC(machine,gen,output,turret_ref,Label)"    "Riferimento torretta"
::msgcat::mcset pb_msg_italian "MC(machine,gen,output,turret_ref,Context)"  "Output relativo al riferimento torretta"

::msgcat::mcset pb_msg_italian "MC(machine,gen,lathe_turret,msg)"           "La designazione della torretta principale non può essere uguale alla designazione della torretta secondaria."
::msgcat::mcset pb_msg_italian "MC(machine,gen,turret_chg,msg)"             "La modifica dell'opzione potrebbe comportare l'aggiunta o l'eliminazione di un blocco G92 negli eventi Cambio utensile."
# Entries for XZC/Mill-Turn
::msgcat::mcset pb_msg_italian "MC(machine,gen,spindle_axis,Label)"             "Asse mandrino iniziale"
::msgcat::mcset pb_msg_italian "MC(machine,gen,spindle_axis,Context)"           "L'asse mandrino iniziale dell'untesile di fresatura può essere specificato come parallelo o perpendicolare all'asse Z. L'asse utensile dell'operazione deve corrispondere all'asse mandrino specificato. Se il post non si può posizionare sull'asse mandrino specificato, si verifica un errore.\nIl vettore può essere ridefinito dall'asse mandrino specificato con un oggetto Testa."

::msgcat::mcset pb_msg_italian "MC(machine,gen,position_in_yaxis,Label)"        "Posizione nell'asse Y"
::msgcat::mcset pb_msg_italian "MC(machine,gen,position_in_yaxis,Context)"      "La macchina ha un asse Y programmabile che può essere posizionato durante le operazioni di contornatura. L'opzione può essere usata solo quanto l'asse mandrino non corrisponde all'asse Z."

::msgcat::mcset pb_msg_italian "MC(machine,gen,mach_mode,Label)"                "Modalità macchina"
::msgcat::mcset pb_msg_italian "MC(machine,gen,mach_mode,Context)"              "La macchina può essere in modalità Fresatura XZC oppure Fresatura/Tornitura semplice."

::msgcat::mcset pb_msg_italian "MC(machine,gen,mach_mode,xzc_mill,Label)"       "Fresatura XZC"
::msgcat::mcset pb_msg_italian "MC(machine,gen,mach_mode,xzc_mill,Context)"     "La fresatura XZC si contraddistingue perché una tavola o una faccia mandrino è bloccata su una macchina per la fresatura/tornitura come asse C di rotazione. Tutti i movimenti XY vengono convertiti in X e C dove X è uguale al valore del raggio e C corrisponde all'angolo."

::msgcat::mcset pb_msg_italian "MC(machine,gen,mach_mode,mill_turn,Label)"      "Fresatura/Tornitura semplice"
::msgcat::mcset pb_msg_italian "MC(machine,gen,mach_mode,mill_turn,Context)"    "Il post di fresatura XZC è collegato ad un post di tornitura e viene usato con un programma che contiene operazioni di fresatura e di tornitura. Il tipo di operazione determina quale post usare per produrre gli output NC."

::msgcat::mcset pb_msg_italian "MC(machine,gen,mill_turn,lathe_post,Label)"     "Post di tornitura"
::msgcat::mcset pb_msg_italian "MC(machine,gen,mill_turn,lathe_post,Context)"   "Un post di tornitura consente ad un post di fresatura/tornitura semplice di postprocessare le operazioni di tornitura di un programma."

::msgcat::mcset pb_msg_italian "MC(machine,gen,lathe_post,select_name,Label)"   "Seleziona nome"
::msgcat::mcset pb_msg_italian "MC(machine,gen,lathe_post,select_name,Context)" "L'opzione consente di selezionare il nome del post di tornitura da usare in un post di fresatura/tornitura semplice. Se il post non si trova nella directory \\\$UGII_CAM_POST_DIR in NX/Post runtime, viene usato un post con lo stesso nome presente nella directory di salvataggio del post di fresatura."

::msgcat::mcset pb_msg_italian "MC(machine,gen,coord_mode,Label)"               "Modalità coordinate predefinite"
::msgcat::mcset pb_msg_italian "MC(machine,gen,coord_mode,Context)"             "L'opzione consente di definire le impostazioni iniziali per le coordinate di output come polari (XZC) o cartesiane (XYZ). La modalità può essere modificata intervenendo sull'UDE \\\"SET/POLAR, ON\\\" programmato con le operazioni."

::msgcat::mcset pb_msg_italian "MC(machine,gen,coord_mode,polar,Label)"         "Polare"
::msgcat::mcset pb_msg_italian "MC(machine,gen,coord_mode,polar,Context)"       "Coordinate di output in XZC."

::msgcat::mcset pb_msg_italian "MC(machine,gen,coord_mode,cart,Label)"          "Cartesiano"
::msgcat::mcset pb_msg_italian "MC(machine,gen,coord_mode,cart,Context)"        "Coordinate di output in XYZ."

::msgcat::mcset pb_msg_italian "MC(machine,gen,xzc_arc_mode,Label)"             "Modalità record circolare"
::msgcat::mcset pb_msg_italian "MC(machine,gen,xzc_arc_mode,Context)"           "L'opzione consente di definire la modalità polare (XCR) oppure cartesiana (XYIJ) per l'output dei record circolari. "

::msgcat::mcset pb_msg_italian "MC(machine,gen,xzc_arc_mode,polar,Label)"       "Polare"
::msgcat::mcset pb_msg_italian "MC(machine,gen,xzc_arc_mode,polar,Context)"     "Output circolare in XCR."

::msgcat::mcset pb_msg_italian "MC(machine,gen,xzc_arc_mode,cart,Label)"        "Cartesiano"
::msgcat::mcset pb_msg_italian "MC(machine,gen,xzc_arc_mode,cart,Context)"      "Output circolare in XYIJ."

::msgcat::mcset pb_msg_italian "MC(machine,gen,def_spindle_axis,Label)"         "Asse mandrino iniziale"
::msgcat::mcset pb_msg_italian "MC(machine,gen,def_spindle_axis,Context)"       "L'asse mandrino iniziale può essere ridefinito dall'asse mandrino specificato con un oggetto Testa.\nNon è necessario unire il vettore."


##-----------------
## 4-th Axis parms
##
::msgcat::mcset pb_msg_italian "MC(machine,axis,fourth,Label)"              "Quarto asse"

::msgcat::mcset pb_msg_italian "MC(machine,axis,radius_output,Label)"       "Output raggio"
::msgcat::mcset pb_msg_italian "MC(machine,axis,radius_output,Context)"     "Quando l'asse utensile si trova lungo l'asse Z (0,0,1), il post può produrre il raggio (X) delle coordinate polari in modo che sia \\\"Sempre positivo\\\", \\\"Sempre negativo\\\" o sulla \\\"Distanza più corta\\\"."

::msgcat::mcset pb_msg_italian "MC(machine,axis,type_head,Label)"           "Testa"
::msgcat::mcset pb_msg_italian "MC(machine,axis,type_table,Label)"          "Tavola"

##-----------------
## 5-th Axis parms
##
::msgcat::mcset pb_msg_italian "MC(machine,axis,fifth,Label)"               "Quinto asse"

::msgcat::mcset pb_msg_italian "MC(machine,axis,rotary,Label)"              "Asse di rotazione"

::msgcat::mcset pb_msg_italian "MC(machine,axis,offset,Label)"              "Zero macchina su centro asse di rotazione"
::msgcat::mcset pb_msg_italian "MC(machine,axis,offset,4,Label)"            "Zero macchina su centro quarto asse"
::msgcat::mcset pb_msg_italian "MC(machine,axis,offset,5,Label)"            "Centro quarto asse su centro quinto asse"
::msgcat::mcset pb_msg_italian "MC(machine,axis,offset,x,Label)"            "Offset X"
::msgcat::mcset pb_msg_italian "MC(machine,axis,offset,x,Context)"          "Specificare l'offset X dell'asse di rotazione."
::msgcat::mcset pb_msg_italian "MC(machine,axis,offset,y,Label)"            "Offest Y"
::msgcat::mcset pb_msg_italian "MC(machine,axis,offset,y,Context)"          "Specificare l'offsest Y dell'asse di rotazione."
::msgcat::mcset pb_msg_italian "MC(machine,axis,offset,z,Label)"            "Offset Z"
::msgcat::mcset pb_msg_italian "MC(machine,axis,offset,z,Context)"          "Specificare l'offset Z dell'asse di rotazione."

::msgcat::mcset pb_msg_italian "MC(machine,axis,rotation,Label)"            "Rotazione asse"
::msgcat::mcset pb_msg_italian "MC(machine,axis,rotation,norm,Label)"       "Normale"
::msgcat::mcset pb_msg_italian "MC(machine,axis,rotation,norm,Context)"     "Impostare la direzione della rotazione su Normale."
::msgcat::mcset pb_msg_italian "MC(machine,axis,rotation,rev,Label)"        "Senso inverso"
::msgcat::mcset pb_msg_italian "MC(machine,axis,rotation,rev,Context)"      "Impostare la direzione della rotazione su Senso inverso."

::msgcat::mcset pb_msg_italian "MC(machine,axis,direction,Label)"           "Direzione asse"
::msgcat::mcset pb_msg_italian "MC(machine,axis,direction,Context)"         "Selezionare la direzione asse."

::msgcat::mcset pb_msg_italian "MC(machine,axis,con_motion,Label)"              "Movimenti di rotazione consecutivi"
::msgcat::mcset pb_msg_italian "MC(machine,axis,con_motion,combine,Label)"      "Combinato"
::msgcat::mcset pb_msg_italian "MC(machine,axis,con_motion,combine,Context)"    "Il parametro consente di attivare/disattivare la linearizzazione. Attiva/Disattiva l'opzione Tolleranza."
::msgcat::mcset pb_msg_italian "MC(machine,axis,con_motion,tol,Label)"      "Tolleranza"
::msgcat::mcset pb_msg_italian "MC(machine,axis,con_motion,tol,Context)"    "L'opzione viene attivata solo se il parametro Combinato è attivo. Specifica la Tolleranza."

::msgcat::mcset pb_msg_italian "MC(machine,axis,violation,Label)"           "Gestione violazione limiti asse"
::msgcat::mcset pb_msg_italian "MC(machine,axis,violation,warn,Label)"      "Avviso"
::msgcat::mcset pb_msg_italian "MC(machine,axis,violation,warn,Context)"    "Avvisi di output per violazione limite asse."
::msgcat::mcset pb_msg_italian "MC(machine,axis,violation,ret,Label)"       "Stacco/Riattacco"
::msgcat::mcset pb_msg_italian "MC(machine,axis,violation,ret,Context)"     "Stacco/Riattacco se si verifica una violazione del limite asse. \n \nIl comando personalizzato PB_CMD_init_rotaty consente di regolare i seguenti parametri in modo da ottenere gli spostamenti desiderati: \n \n   mom_kin_retract_type \n   mom_kin_retract_distance \n   mom_kin_reengage_distance"

::msgcat::mcset pb_msg_italian "MC(machine,axis,limits,Label)"              "Limiti asse (gradi)"
::msgcat::mcset pb_msg_italian "MC(machine,axis,limits,min,Label)"          "Minimo"
::msgcat::mcset pb_msg_italian "MC(machine,axis,limits,min,Context)"        "Specificare il limite dell'asse di rotazione minimo (gradi)."
::msgcat::mcset pb_msg_italian "MC(machine,axis,limits,max,Label)"          "Massimo"
::msgcat::mcset pb_msg_italian "MC(machine,axis,limits,max,Context)"        "Specificare il limite dell'asse di rotazione massimo (gradi)."

::msgcat::mcset pb_msg_italian "MC(machine,axis,incr_text)"                 "L'asse di rotazione può essere incrementale"

::msgcat::mcset pb_msg_italian "MC(machine,axis,rotary_res,Label)"          "Risoluzione movimento di rotazione (gradi)"
::msgcat::mcset pb_msg_italian "MC(machine,axis,rotary_res,Context)"        "Specificare la risoluzione movimento di rotazione (gradi)."

::msgcat::mcset pb_msg_italian "MC(machine,axis,ang_offset,Label)"          "Offset angolare (gradi)"
::msgcat::mcset pb_msg_italian "MC(machine,axis,ang_offset,Context)"        "Specificare l'offset angolare asse (gradi)."

::msgcat::mcset pb_msg_italian "MC(machine,axis,pivot,Label)"               "Distanza perno"
::msgcat::mcset pb_msg_italian "MC(machine,axis,pivot,Context)"             "Specificare la distanza perno."

::msgcat::mcset pb_msg_italian "MC(machine,axis,max_feed,Label)"            "Velocità di avanzamento massima (gradi/minuto)"
::msgcat::mcset pb_msg_italian "MC(machine,axis,max_feed,Context)"          "Specificare la velocità di avanzamento massima (gradi/minuto)."

::msgcat::mcset pb_msg_italian "MC(machine,axis,plane,Label)"               "Piano di rotazione"
::msgcat::mcset pb_msg_italian "MC(machine,axis,plane,Context)"             "Selezionare XY, YZ, ZX o Altro come piano di rotazione. L'opzione\\\"Altro\\\" consente di specificare un vettore arbitrario."

::msgcat::mcset pb_msg_italian "MC(machine,axis,plane,normal,Label)"        "Vettore normale al piano"
::msgcat::mcset pb_msg_italian "MC(machine,axis,plane,normal,Context)"      "Specificare il vettore normale al piano come asse di rotazione. \nNon occorre unire il vettore."
::msgcat::mcset pb_msg_italian "MC(machine,axis,plane,4th,Label)"           "Normale al piano quarto asse"
::msgcat::mcset pb_msg_italian "MC(machine,axis,plane,4th,Context)"         "Specificare un vettore normale al piano per la rotazione del quarto asse."
::msgcat::mcset pb_msg_italian "MC(machine,axis,plane,5th,Label)"           "Normale al piano quinto asse"
::msgcat::mcset pb_msg_italian "MC(machine,axis,plane,5th,Context)"         "Specificare un vettore normale al piano per la rotazione del quinto asse."

::msgcat::mcset pb_msg_italian "MC(machine,axis,leader,Label)"              "Word Leader"
::msgcat::mcset pb_msg_italian "MC(machine,axis,leader,Context)"            "Specificare Word Leader."

::msgcat::mcset pb_msg_italian "MC(machine,axis,config,Label)"              "Configura"
::msgcat::mcset pb_msg_italian "MC(machine,axis,config,Context)"            "L'opzione consente di definire il quarto e il quinto parametro."

::msgcat::mcset pb_msg_italian "MC(machine,axis,r_axis_conf_trans,Label)"   "Configurazione asse di rotazione"
::msgcat::mcset pb_msg_italian "MC(machine,axis,4th_axis,Label)"            "Quarto asse"
::msgcat::mcset pb_msg_italian "MC(machine,axis,5th_axis,Label)"            "Quinto asse"
::msgcat::mcset pb_msg_italian "MC(machine,axis,head,Label)"                " Testa "
::msgcat::mcset pb_msg_italian "MC(machine,axis,table,Label)"               " Tavola "

::msgcat::mcset pb_msg_italian "MC(machine,axis,rotary_lintol,Label)"       "Tolleranza linearizzazione predefinita"
::msgcat::mcset pb_msg_italian "MC(machine,axis,rotary_lintol,Context)"     "Il valore viene usato come tolleranza predefinita per linearizzare i movimenti di rotazione nel momento in cui viene specificato un comando post LINTOL/ON con le operazioni attuali o precedenti. Il comando LINTOL/ può anche specificare una tolleranza di linearizzazione diversa."

#+++++++++++++++++++++
# Program & Tool Path
#+++++++++++++++++++++
::msgcat::mcset pb_msg_italian "MC(progtpth,tab,Label)"                 "Programma e percorso utensile"

##---------
## Program
##
::msgcat::mcset pb_msg_italian "MC(prog,tab,Label)"                     "Programma"
::msgcat::mcset pb_msg_italian "MC(prog,Status)"                        "Definire l'output degli eventi"

::msgcat::mcset pb_msg_italian "MC(prog,tree,Label)"                    "Programma -- struttura ad albero sequenza"
::msgcat::mcset pb_msg_italian "MC(prog,tree,Context)"                  "Un programma NC è suddiviso in cinque segmenti composti da quattro (4) sequenze e il corpo del percorso utensile. \n \n * Sequenza di avvio programma \n * Sequenza di avvio operazione \n * Percorso utensile \n * Sequenza di fine operazione \n * Sequenza di fine programma \n \nLe singole sequenze sono formate da una serie di contrassegni. Un contrassegno indica un evento che può essere programmato e può verificarsi in una fase particolare di un programma NC. È possibile allegare ogni contrassegno ad una disposizione particolare di codici NC da produrre quando il programma viene postprocessato. \n \nIl percorso utensile è formato da vari eventi che vengono suddivisi in tre (3) gruppi: \n \n * Controllo macchina \n * Movimenti \n * Cicli \n"

::msgcat::mcset pb_msg_italian "MC(prog,tree,prog_strt,Label)"          "Sequenza di avvio programma"
::msgcat::mcset pb_msg_italian "MC(prog,tree,prog_end,Label)"           "Sequenza di fine programma"
::msgcat::mcset pb_msg_italian "MC(prog,tree,oper_strt,Label)"          "Sequenza di avvio operazione"
::msgcat::mcset pb_msg_italian "MC(prog,tree,oper_end,Label)"           "Sequenza di fine operazione"
::msgcat::mcset pb_msg_italian "MC(prog,tree,tool_path,Label)"          "Percorso utensile"
::msgcat::mcset pb_msg_italian "MC(prog,tree,tool_path,mach_cnt,Label)" "Controllo macchina"
::msgcat::mcset pb_msg_italian "MC(prog,tree,tool_path,motion,Label)"   "Movimento"
::msgcat::mcset pb_msg_italian "MC(prog,tree,tool_path,cycle,Label)"    "Cicli predefiniti"
::msgcat::mcset pb_msg_italian "MC(prog,tree,linked_posts,Label)"       "Sequenza di post collegati"

::msgcat::mcset pb_msg_italian "MC(prog,add,Label)"                     "Sequenza -- aggiungi blocco"
::msgcat::mcset pb_msg_italian "MC(prog,add,Context)"                   "Per aggiungere un nuovo blocco ad una sequenza, premere questo pulsante e trascinarlo nel Contrassegno corrispondente. I blocchi possono inoltre essere allegati vicino, sopra o sotto ai blocchi già presenti."

::msgcat::mcset pb_msg_italian "MC(prog,trash,Label)"                   "Sequenza -- cestino"
::msgcat::mcset pb_msg_italian "MC(prog,trash,Context)"                 "I blocchi da eliminare dalla sequenza possono essere trascinati in questo cestino."

::msgcat::mcset pb_msg_italian "MC(prog,block,Label)"                   "Sequenza -- blocco"
::msgcat::mcset pb_msg_italian "MC(prog,block,Context)"                 "I blocchi da eliminare dalla sequenza possono essere trascinati nel cestino.\n \nPremendo il pulsante destro del mouse è anche possibile accedere ad un menu a comparsa che attiva vari servizi:  \n \n * Modifca \n * Forza output\n * Taglia \n * Copia come \n * Incolla \n * Elimina \n"

::msgcat::mcset pb_msg_italian "MC(prog,select,Label)"                  "Sequenza -- selezione blocco"
::msgcat::mcset pb_msg_italian "MC(prog,select,Context)"                "Selezionare il tipo di componente Blocco da aggiungere alla sequenza scegliendo dal seguente elenco. \n\AI tipi di componenti disponibili sono: \n \n * Nuovo blocco\n * Blocco NC esistente\n * Messaggio operatore \n * Comando personalizzato \n"

::msgcat::mcset pb_msg_italian "MC(prog,oper_temp,Label)"               "Seleziona un template per la sequenza"
::msgcat::mcset pb_msg_italian "MC(prog,add_block,Label)"               "Aggiungi blocco"
::msgcat::mcset pb_msg_italian "MC(prog,seq_comb_nc,Label)"             "Visualizza blocchi codice NC combinati"
::msgcat::mcset pb_msg_italian "MC(prog,seq_comb_nc,Context)"           "Questo pulsante consente di visualizzare il contenuto di una sequenza in termini di blocchi o di codici NC.\n \nI codici NC visualizzato le parole nell'ordine corretto."

::msgcat::mcset pb_msg_italian "MC(prog,plus,Label)"                    "Programma -- pulsante Riduci/Espandi"
::msgcat::mcset pb_msg_italian "MC(prog,plus,Context)"                  "Questo pulsante consente di ridurre o espandere le diramazioni del componente."

::msgcat::mcset pb_msg_italian "MC(prog,marker,Label)"                  "Sequenza -- contrassegno"
::msgcat::mcset pb_msg_italian "MC(prog,marker,Context)"                "I contrassegni di una sequenza indicano quali eventi possono essere programmati e si possono verificare in sequenza durante una determinata fase di un programma NC.\n \nÈ possibile allegare/disporre i blocchi di cui eseguire l'output in ogni contrassegno."

::msgcat::mcset pb_msg_italian "MC(prog,event,Label)"                   "Programma -- evento"
::msgcat::mcset pb_msg_italian "MC(prog,event,Context)"                 "È possibile modificare ogni evento con un semplice clic sul pulsante sinistro del mouse."

::msgcat::mcset pb_msg_italian "MC(prog,nc_code,Label)"                 "Programma -- codice NC"
::msgcat::mcset pb_msg_italian "MC(prog,nc_code,Context)"               "Il testo contenuto nel riquadro visualizza il codice NC di cui eseguire l'output nel contrassegno o dall'evento."
::msgcat::mcset pb_msg_italian "MC(prog,undo_popup,Label)"              "Annulla operazione"

## Sequence
##
::msgcat::mcset pb_msg_italian "MC(seq,combo,new,Label)"                "Nuovo blocco"
::msgcat::mcset pb_msg_italian "MC(seq,combo,comment,Label)"            "Messaggio operatore"
::msgcat::mcset pb_msg_italian "MC(seq,combo,custom,Label)"             "Comando personalizzato"

::msgcat::mcset pb_msg_italian "MC(seq,new_trans,title,Label)"          "Blocco"
::msgcat::mcset pb_msg_italian "MC(seq,cus_trans,title,Label)"          "Comando personalizzato"
::msgcat::mcset pb_msg_italian "MC(seq,oper_trans,title,Label)"         "Messaggio operatore"

::msgcat::mcset pb_msg_italian "MC(seq,edit_popup,Label)"               "Modifica"
::msgcat::mcset pb_msg_italian "MC(seq,force_popup,Label)"              "Forza output"
::msgcat::mcset pb_msg_italian "MC(seq,rename_popup,Label)"             "Assegna nuovo nome"
::msgcat::mcset pb_msg_italian "MC(seq,rename_popup,Context)"           "Specificare il nome di questo componente."
::msgcat::mcset pb_msg_italian "MC(seq,cut_popup,Label)"                "Taglio"
::msgcat::mcset pb_msg_italian "MC(seq,copy_popup,Label)"               "Copia come"
::msgcat::mcset pb_msg_italian "MC(seq,copy_popup,ref,Label)"           "Blocco referenziato"
::msgcat::mcset pb_msg_italian "MC(seq,copy_popup,new,Label)"           "Nuovo blocco"
::msgcat::mcset pb_msg_italian "MC(seq,paste_popup,Label)"              "Incolla"
::msgcat::mcset pb_msg_italian "MC(seq,paste_popup,before,Label)"       "Prima"
::msgcat::mcset pb_msg_italian "MC(seq,paste_popup,inline,Label)"       "In linea"
::msgcat::mcset pb_msg_italian "MC(seq,paste_popup,after,Label)"        "Dopo"
::msgcat::mcset pb_msg_italian "MC(seq,del_popup,Label)"                "Elimina"

::msgcat::mcset pb_msg_italian "MC(seq,force_trans,title,Label)"        "Forza output una volta"

##--------------
## Toolpath
##
::msgcat::mcset pb_msg_italian "MC(tool,event_trans,title,Label)"       "Evento"

::msgcat::mcset pb_msg_italian "MC(tool,event_seq,button,Label)"        "Seleziona template evento"
::msgcat::mcset pb_msg_italian "MC(tool,add_word,button,Label)"         "Aggiungi parola"

::msgcat::mcset pb_msg_italian "MC(tool,format_trans,title,Label)"      "FORMATO"

::msgcat::mcset pb_msg_italian "MC(tool,circ_trans,title,Label)"        "Movimento circolare -- codici piano"
::msgcat::mcset pb_msg_italian "MC(tool,circ_trans,frame,Label)"        " Codici G piano "
::msgcat::mcset pb_msg_italian "MC(tool,circ_trans,xy,Label)"           "Piano XY"
::msgcat::mcset pb_msg_italian "MC(tool,circ_trans,yz,Label)"           "Piano YZ"
::msgcat::mcset pb_msg_italian "MC(tool,circ_trans,zx,Label)"           "Piano ZX"

::msgcat::mcset pb_msg_italian "MC(tool,ijk_desc,arc_start,Label)"          "Inizio arco a centro"
::msgcat::mcset pb_msg_italian "MC(tool,ijk_desc,arc_center,Label)"         "Centro arco a inizio"
::msgcat::mcset pb_msg_italian "MC(tool,ijk_desc,u_arc_start,Label)"        "Inizio arco a centro senza segno"
::msgcat::mcset pb_msg_italian "MC(tool,ijk_desc,absolute,Label)"           "Centro arco assoluto"
::msgcat::mcset pb_msg_italian "MC(tool,ijk_desc,long_thread_lead,Label)"   "Attacco filettatura longitudinale"
::msgcat::mcset pb_msg_italian "MC(tool,ijk_desc,tran_thread_lead,Label)"   "Attacco filettatura trasversale"

::msgcat::mcset pb_msg_italian "MC(tool,spindle,range,type,Label)"              "Tipo di intervallo mandrino"
::msgcat::mcset pb_msg_italian "MC(tool,spindle,range,range_M,Label)"           "Codice intervallo M separato (M41)"
::msgcat::mcset pb_msg_italian "MC(tool,spindle,range,with_spindle_M,Label)"    "Numero intervalli con codice M mandrino (13) "
::msgcat::mcset pb_msg_italian "MC(tool,spindle,range,hi_lo_with_S,Label)"      "Intervallo alto/basso con codice S (S+100)"
::msgcat::mcset pb_msg_italian "MC(tool,spindle,range,nonzero_range,msg)"       "Il numero di intervalli mandrino deve essere superiore a zero."

::msgcat::mcset pb_msg_italian "MC(tool,spindle_trans,title,Label)"         "Tabella di codici intervallo mandrino"
::msgcat::mcset pb_msg_italian "MC(tool,spindle_trans,range,Label)"         "Intervallo"
::msgcat::mcset pb_msg_italian "MC(tool,spindle_trans,code,Label)"          "Codice"
::msgcat::mcset pb_msg_italian "MC(tool,spindle_trans,min,Label)"           "Minimo (giri/minuto)"
::msgcat::mcset pb_msg_italian "MC(tool,spindle_trans,max,Label)"           "Massimo (giri/minuto)"

::msgcat::mcset pb_msg_italian "MC(tool,spindle_desc,sep,Label)"            " Codice intervallo M separato (M41, M42...) "
::msgcat::mcset pb_msg_italian "MC(tool,spindle_desc,range,Label)"          " Numero di intervalli con codice M mandrino (M13, M23...)"
::msgcat::mcset pb_msg_italian "MC(tool,spindle_desc,high,Label)"           " Intervallo alto/basso con codice S (S+100/S-100)"
::msgcat::mcset pb_msg_italian "MC(tool,spindle_desc,odd,Label)"            " Intervallo pari/dispari con codice S"


::msgcat::mcset pb_msg_italian "MC(tool,config,mill_opt1,Label)"            "Numero utensile"
::msgcat::mcset pb_msg_italian "MC(tool,config,mill_opt2,Label)"            "Numero utensile e numero offset lunghezza"
::msgcat::mcset pb_msg_italian "MC(tool,config,mill_opt3,Label)"            "Numero offset lunghezza e numero utensile"

::msgcat::mcset pb_msg_italian "MC(tool,config,title,Label)"                "Configurazione codice utensile"
::msgcat::mcset pb_msg_italian "MC(tool,config,output,Label)"               "Output"

::msgcat::mcset pb_msg_italian "MC(tool,config,lathe_opt1,Label)"           "Numero utensile"
::msgcat::mcset pb_msg_italian "MC(tool,config,lathe_opt2,Label)"           "Numero utensile e numero offset lunghezza"
::msgcat::mcset pb_msg_italian "MC(tool,config,lathe_opt3,Label)"           "Indice torretta e numero utensile"
::msgcat::mcset pb_msg_italian "MC(tool,config,lathe_opt4,Label)"           "Numero utensile indice torretta e numero offset lunghezza"

::msgcat::mcset pb_msg_italian "MC(tool,conf_desc,num,Label)"               "Numero utensile"
::msgcat::mcset pb_msg_italian "MC(tool,conf_desc,next_num,Label)"          "Prossimo numero utensile"
::msgcat::mcset pb_msg_italian "MC(tool,conf_desc,index_num,Label)"         "Indice torretta e numero utensile"
::msgcat::mcset pb_msg_italian "MC(tool,conf_desc,index_next_num,Label)"    "Indice torretta e prossimo numero utensile"
::msgcat::mcset pb_msg_italian "MC(tool,conf_desc,num_len,Label)"           "Numero utensile e numero offset lunghezza"
::msgcat::mcset pb_msg_italian "MC(tool,conf_desc,next_num_len,Label)"      "Prossimo numero utensile e numero offset lunghezza"
::msgcat::mcset pb_msg_italian "MC(tool,conf_desc,len_num,Label)"           "Numero offset lunghezza e numero utensile"
::msgcat::mcset pb_msg_italian "MC(tool,conf_desc,len_next_num,Label)"      "Numero offset lunghezza e prossimo numero utensile"
::msgcat::mcset pb_msg_italian "MC(tool,conf_desc,index_num_len,Label)"     "Indice torretta, numero utensile e numero offset lunghezza"
::msgcat::mcset pb_msg_italian "MC(tool,conf_desc,index_next_num_len,Label)"    "Indice torretta, prossimo numero utensile e numero offset lunghezza"

::msgcat::mcset pb_msg_italian "MC(tool,oper_trans,title,Label)"            "Messaggio operatore"
::msgcat::mcset pb_msg_italian "MC(tool,cus_trans,title,Label)"             "Comando personalizzato"

##--------------------------
## Labels for Event dialogs
##
::msgcat::mcset pb_msg_italian "MC(event,feed,IPM_mode)"                "Modalità IPM (pollici/minuto)"

##---------
## G Codes
##
::msgcat::mcset pb_msg_italian "MC(gcode,tab,Label)"                    "Codici G"
::msgcat::mcset pb_msg_italian "MC(gcode,Status)"                       "Specificare codici G"

##---------
## M Codes
##
::msgcat::mcset pb_msg_italian "MC(mcode,tab,Label)"                    "Codici M"
::msgcat::mcset pb_msg_italian "MC(mcode,Status)"                       "Specificare codici M"

##-----------------
## Words Summary
##
::msgcat::mcset pb_msg_italian "MC(addrsum,tab,Label)"                  "Riepilogo parole"
::msgcat::mcset pb_msg_italian "MC(addrsum,Status)"                     "Specifica parametri"

::msgcat::mcset pb_msg_italian "MC(addrsum,col_addr,Label)"             "Parola"
::msgcat::mcset pb_msg_italian "MC(addrsum,col_addr,Context)"           "L'indirizzo di una parola può essere modificato facendo clic con il pulsante destro del mouse sul nome della parola."
::msgcat::mcset pb_msg_italian "MC(addrsum,col_lead,Label)"             "Leader/Codice"
::msgcat::mcset pb_msg_italian "MC(addrsum,col_data,Label)"             "Tipo di dati"
::msgcat::mcset pb_msg_italian "MC(addrsum,col_plus,Label)"             "Più (+)"
::msgcat::mcset pb_msg_italian "MC(addrsum,col_lzero,Label)"            "Zero iniziale"
::msgcat::mcset pb_msg_italian "MC(addrsum,col_int,Label)"              "Numero intero"
::msgcat::mcset pb_msg_italian "MC(addrsum,col_dec,Label)"              "Decimale (.)"
::msgcat::mcset pb_msg_italian "MC(addrsum,col_frac,Label)"             "Frazione"
::msgcat::mcset pb_msg_italian "MC(addrsum,col_tzero,Label)"            "Zero finale"
::msgcat::mcset pb_msg_italian "MC(addrsum,col_modal,Label)"            "Modale ?"
::msgcat::mcset pb_msg_italian "MC(addrsum,col_min,Label)"              "Minimo"
::msgcat::mcset pb_msg_italian "MC(addrsum,col_max,Label)"              "Massimo"
::msgcat::mcset pb_msg_italian "MC(addrsum,col_trail,Label)"            "Finale"

::msgcat::mcset pb_msg_italian "MC(addrsum,radio_text,Label)"           "Testo"
::msgcat::mcset pb_msg_italian "MC(addrsum,radio_num,Label)"            "Numerico"

::msgcat::mcset pb_msg_italian "MC(addrsum,addr_trans,title,Label)"     "PAROLA"
::msgcat::mcset pb_msg_italian "MC(addrsum,other_trans,title,Label)"    "Altri elementi di dati"

##-----------------
## Word Sequencing
##
::msgcat::mcset pb_msg_italian "MC(wseq,tab,Label)"                     "Sequenza parole"
::msgcat::mcset pb_msg_italian "MC(wseq,Status)"                        "Sequenza delle parole"

::msgcat::mcset pb_msg_italian "MC(wseq,word,Label)"                    "Sequenza parole master"
::msgcat::mcset pb_msg_italian "MC(wseq,word,Context)"                  "Si può definire un ordine di parole per l'output in NC selezionando e trascinando le parole nella posizione desiderata.\n \nQuando la parola trascinata è in direzione dell'altra parola (il colore del rettangolo cambia), la posizione delle due parole viene invertita. Se una parola viene trascinata in direzione del separatore di due parole, verrà inserita tra le due parole. \n \nPer evitare che una parola venga inclusa nel file di output NC, disattivarla usando il mouse. \n \nLe parole possono anche essere gestite selezionando le opzioni di un menu a comparsa: \n \n * Nuovo \n * Modifica \n * Elimina \n * Attiva tutto \n"

::msgcat::mcset pb_msg_italian "MC(wseq,active_out,Label)"              " Output - attivo     "
::msgcat::mcset pb_msg_italian "MC(wseq,suppressed_out,Label)"          " Output - soppresso "

::msgcat::mcset pb_msg_italian "MC(wseq,popup_new,Label)"               "Nuovo"
::msgcat::mcset pb_msg_italian "MC(wseq,popup_undo,Label)"              "Annulla operazione"
::msgcat::mcset pb_msg_italian "MC(wseq,popup_edit,Label)"              "Modifica"
::msgcat::mcset pb_msg_italian "MC(wseq,popup_delete,Label)"            "Elimina"
::msgcat::mcset pb_msg_italian "MC(wseq,popup_all,Label)"               "Attiva tutto"
::msgcat::mcset pb_msg_italian "MC(wseq,transient_win,Label)"           "PAROLA"
::msgcat::mcset pb_msg_italian "MC(wseq,cannot_suppress_msg)"           "non può essere soppreso. È stato usato come elemento semplice in "
::msgcat::mcset pb_msg_italian "MC(wseq,empty_block_msg)"               "La soppressione dell'output di questo indirizzo produce blocchi vuoti non validi."

##----------------
## Custom Command
##
::msgcat::mcset pb_msg_italian "MC(cust_cmd,tab,Label)"                 "Comando personalizzato"
::msgcat::mcset pb_msg_italian "MC(cust_cmd,Status)"                    "Definisci comando personalizzato"

::msgcat::mcset pb_msg_italian "MC(cust_cmd,name,Label)"                "Nome comando"
::msgcat::mcset pb_msg_italian "MC(cust_cmd,name,Context)"              "Il nome inserito a questo punto viene prefissato con PB_CMD_ in modo da diventare un effettivo nome di comando."
::msgcat::mcset pb_msg_italian "MC(cust_cmd,proc,Label)"                "Procedura"
::msgcat::mcset pb_msg_italian "MC(cust_cmd,proc,Context)"              "Inserire uno script Tcl per definire la funzionalità del comando. \n \n * Notare che il contenuto dello script non verrà analizzato dal Post Builder, ma sarà salvato nel file Tcl. L'utente sarà quindi responsabile della correttezza sintattica dello script."

::msgcat::mcset pb_msg_italian "MC(cust_cmd,name_msg)"                  "Nome comando personalizzato non valido.\n Specificare un altro nome"
::msgcat::mcset pb_msg_italian "MC(cust_cmd,name_msg_1)"                "è riservato ad alcuni specifici comandi personalizzati.\nImmettere un altro nome"
::msgcat::mcset pb_msg_italian "MC(cust_cmd,name_msg_2)"                "Sono consentiti solo nomi di comandi personalizzati simili a\n PB_CMD_vnc____*.\n Specificare un altro nome"

::msgcat::mcset pb_msg_italian "MC(cust_cmd,import,Label)"              "Importa"
::msgcat::mcset pb_msg_italian "MC(cust_cmd,import,Context)"            "Importa i comandi personalizzati dal file Tcl selezionato al post in esecuzione."
::msgcat::mcset pb_msg_italian "MC(cust_cmd,export,Label)"              "Esporta"
::msgcat::mcset pb_msg_italian "MC(cust_cmd,export,Context)"            "Esporta i comandi personalizzati dal post in esecuzione al file Tcl."
::msgcat::mcset pb_msg_italian "MC(cust_cmd,import,tree,Label)"         "Importa comandi personalizzati"
::msgcat::mcset pb_msg_italian "MC(cust_cmd,import,tree,Context)"       "L'elenco contiene le procedure relative ai comandi personalizzati e altre procedure Tcl che si trovano nel file da importare. È possibile visualizzare in anteprima il contenuto di ogni procedura facendo clic con il pulsante sinistro del mouse sull'oggetto da selezionare. Tutte le procedure già presenti nel post in corso vengono identificate con il messaggio <esiste>. Facendo doppio clic con il pulsante sinistro del mouse su un oggetto si attiva la casella di controllo vicina all'oggetto. L'operazione consente di selezionare o deselezionare la procedura da importare. Per impostazione predefinita, tutte le procedure vengono selezionate per l'esportazione. È possibile deselezionare gli oggetti per evitare di sovrascrivere operazioni esistenti."

::msgcat::mcset pb_msg_italian "MC(cust_cmd,export,tree,Label)"         "Esporta comandi personalizzati"
::msgcat::mcset pb_msg_italian "MC(cust_cmd,export,tree,Context)"       "L'elenco contiene le procedure relative ai comandi personalizzati e altre procedure Tcl che si trovano nel file post da importare. È possibile visualizzare in anteprima il contenuto di ogni procedura facendo clic con il pulsante sinistro del mouse sull'oggetto da selezionare. Facendo doppio clic con il pulsante sinistro del mouse su un oggetto si attiva la casella di controllo vicina all'oggetto. L'operazione consente di selezionare solo le procedure da importare."

::msgcat::mcset pb_msg_italian "MC(cust_cmd,error,title)"               "Errore comando personalizzato"
::msgcat::mcset pb_msg_italian "MC(cust_cmd,error,msg)"                 "La convalida dei comandi personalizzati può essere attivata o disattivata impostando le opzioni della voce di menu a discesa \"Optioni->Convalida comandi personalizzati\"."

::msgcat::mcset pb_msg_italian "MC(cust_cmd,select_all,Label)"          "Seleziona tutto"
::msgcat::mcset pb_msg_italian "MC(cust_cmd,select_all,Context)"        "Fare clic su questo pulsante per selezionare tutti i comandi visualizzati da importare o esportare."
::msgcat::mcset pb_msg_italian "MC(cust_cmd,deselect_all,Label)"        "Deseleziona tutto"
::msgcat::mcset pb_msg_italian "MC(cust_cmd,deselect_all,Context)"      "Fare clic su questo pulsante per deselezionare tutti i comandi."

::msgcat::mcset pb_msg_italian "MC(cust_cmd,import,warning,title)"      "Avviso di importazione/esportazione comandi personalizzati"
::msgcat::mcset pb_msg_italian "MC(cust_cmd,import,warning,msg)"        "Non è stato selezionato alcun oggetto da importare o esportare."



::msgcat::mcset pb_msg_italian "MC(cust_cmd,cmd,msg)"                   "Comandi: "
::msgcat::mcset pb_msg_italian "MC(cust_cmd,blk,msg)"                   "Blocchi: "
::msgcat::mcset pb_msg_italian "MC(cust_cmd,add,msg)"                   "Indirizzi: "
::msgcat::mcset pb_msg_italian "MC(cust_cmd,fmt,msg)"                   "Formati: "
::msgcat::mcset pb_msg_italian "MC(cust_cmd,referenced,msg)"            "referenziato nei comandi personalizzati "
::msgcat::mcset pb_msg_italian "MC(cust_cmd,not_defined,msg)"           "non sono stati definiti nell'ambito attuale del post in corso."
::msgcat::mcset pb_msg_italian "MC(cust_cmd,cannot_delete,msg)"         "non può essere eliminato."
::msgcat::mcset pb_msg_italian "MC(cust_cmd,save_post,msg)"             "Salvare comunque il post?"


##------------------
## Operator Message
##
::msgcat::mcset pb_msg_italian "MC(opr_msg,text,Label)"                 "Messaggio operatore"
::msgcat::mcset pb_msg_italian "MC(opr_msg,text,Context)"               "Testo da visualizzare come messaggio operatore. I caratteri speciali richiesti per l'inizio e la fine del messaggio verranno automaticamente allegati dal Post Builder. Tali caratteri vengono specificati nel parametro \"Altri elementi di dati\" nella scheda \"Definizioni di dati NC\"."

::msgcat::mcset pb_msg_italian "MC(opr_msg,name,Label)"                 "Nome messaggio"
::msgcat::mcset pb_msg_italian "MC(opr_msg,empty_operator)"             "I messaggi operatore non devono essere vuoti."


##--------------
## Linked Posts
##
::msgcat::mcset pb_msg_italian "MC(link_post,tab,Label)"                "Postprocessor collegati"
::msgcat::mcset pb_msg_italian "MC(link_post,Status)"                   "Definire i postprocessor collegati"

::msgcat::mcset pb_msg_italian "MC(link_post,toggle,Label)"             "Allega altri post a questo"
::msgcat::mcset pb_msg_italian "MC(link_post,toggle,Context)"           "È possibile allegare altri post al fine di gestire macchine utensili complesse che eseguono più di una combinazione in modalità di fresatura e tornitura."

::msgcat::mcset pb_msg_italian "MC(link_post,head,Label)"               "Testa"
::msgcat::mcset pb_msg_italian "MC(link_post,head,Context)"             "Una macchina utensile complessa può eseguire lavorazioni che usano gruppi diversi di cinematica in modalità di lavorazione diverse. Ogni gruppo di cinematica viene considerato come Testa indipendente da NX/Post. Le operazioni di lavorazione da eseguire con una testa specifica vengono raggruppate nella vista Macchina utensile oppure nella vista Metodo di lavorazione. Una \\\"Testa\\\" UDE viene quindi assegnata al gruppo per indicare il nome corrispondente."

::msgcat::mcset pb_msg_italian "MC(link_post,post,Label)"               "Post"
::msgcat::mcset pb_msg_italian "MC(link_post,post,Context)"             "Un post viene assegnato ad una Testa per produrre i codici NC."

::msgcat::mcset pb_msg_italian "MC(link_post,link,Label)"               "Un post collegato"
::msgcat::mcset pb_msg_italian "MC(link_post,link,Context)"             "[::msgcat::mc MC(link_post,head,Context)] \n\n [::msgcat::mc MC(link_post,post,Context)]"


::msgcat::mcset pb_msg_italian "MC(link_post,new,Label)"                "Nuovo"
::msgcat::mcset pb_msg_italian "MC(link_post,new,Context)"              "Creare un nuovo collegamento."

::msgcat::mcset pb_msg_italian "MC(link_post,edit,Label)"               "Modifica"
::msgcat::mcset pb_msg_italian "MC(link_post,edit,Context)"             "Modificare un collegamento."

::msgcat::mcset pb_msg_italian "MC(link_post,delete,Label)"             "Elimina"
::msgcat::mcset pb_msg_italian "MC(link_post,delete,Context)"           "Eliminare un collegamento."

::msgcat::mcset pb_msg_italian "MC(link_post,select_name,Label)"        "Seleziona nome"
::msgcat::mcset pb_msg_italian "MC(link_post,select_name,Context)"      "Selezionare il nome del post da assegnare alla testa. Il post dovrebbe trovarsi nella stessa directory del post principale durante l'esecuzione NX/Post. In caso contrario, viene usato un post con lo stesso nome presente nella directory \\\$UGII_CAM_POST_DIR."

::msgcat::mcset pb_msg_italian "MC(link_post,start_of_head,Label)"      "Inizio testa"
::msgcat::mcset pb_msg_italian "MC(link_post,start_of_head,Context)"    "Specificare i codici NC o azioni da eseguire all'inizio della testa."

::msgcat::mcset pb_msg_italian "MC(link_post,end_of_head,Label)"        "Fine testa"
::msgcat::mcset pb_msg_italian "MC(link_post,end_of_head,Context)"      "Specificare i codici NC o azioni da eseguire alla fine della testa. "
::msgcat::mcset pb_msg_italian "MC(link_post,dlg,head,Label)"           "Testa"
::msgcat::mcset pb_msg_italian "MC(link_post,dlg,post,Label)"           "Post"
::msgcat::mcset pb_msg_italian "MC(link_post,dlg,title,Label)"          "Post collegato"

#++++++++++++++++++++++
# N/C Data Definitions
#++++++++++++++++++++++
::msgcat::mcset pb_msg_italian "MC(nc_data,tab,Label)"                  "Definizioni di dati NC"

##-------
## BLOCK
##
::msgcat::mcset pb_msg_italian "MC(block,tab,Label)"                    "BLOCCO"
::msgcat::mcset pb_msg_italian "MC(block,Status)"                       "Definire i template dei blocchi"

::msgcat::mcset pb_msg_italian "MC(block,name,Label)"                   "Nome blocco"
::msgcat::mcset pb_msg_italian "MC(block,name,Context)"                 "Inserire il nome blocco"

::msgcat::mcset pb_msg_italian "MC(block,add,Label)"                    "Aggiungi parola"
::msgcat::mcset pb_msg_italian "MC(block,add,Context)"                  "Per aggiungere una nuova parola ad un blocco, premere il pulsante e trascinarlo nel blocco visualizzato nella finestra sottostante. Il tipo di parola creata viene selezionato nrll'elenco situato sul lato destro del pulsante."

::msgcat::mcset pb_msg_italian "MC(block,select,Label)"                 "BLOCCO -- selezione parola"
::msgcat::mcset pb_msg_italian "MC(block,select,Context)"               "Selezionare il tipo di componente Blocco da aggiungere alla sequenza scegliendo dal seguente elenco. "

::msgcat::mcset pb_msg_italian "MC(block,trash,Label)"                  "BLOCCO -- cestino"
::msgcat::mcset pb_msg_italian "MC(block,trash,Context)"                "Le parole da eliminare da un blocco possono essere trascinate nel cestino."

::msgcat::mcset pb_msg_italian "MC(block,word,Label)"                   "BLOCCO -- parola"
::msgcat::mcset pb_msg_italian "MC(block,word,Context)"                 "Le parole da eliminare da un blocco possono essere trascinate nel cestino.\n \nPremendo il pulsante destro del mouse è anche possibile accedere ad un menu a comparsa che attiva vari servizi: \n \n * Modifica\n * Modifica elemento -> \n * Opzionale \n * Nessun separatore di parole \n * Forza output \n * Elimina \n"

::msgcat::mcset pb_msg_italian "MC(block,verify,Label)"                 "BLOCCO -- controllo parola"
::msgcat::mcset pb_msg_italian "MC(block,verify,Context)"               "La finestra visualizza il codice NC rappresentativo da stampare per la parola selezionata nel blocco visualizzato nella finestra sovrastante."

::msgcat::mcset pb_msg_italian "MC(block,new_combo,Label)"              "Nuovo indirizzo"
::msgcat::mcset pb_msg_italian "MC(block,text_combo,Label)"             "Testo"
::msgcat::mcset pb_msg_italian "MC(block,oper_combo,Label)"             "Messaggio operatore"
::msgcat::mcset pb_msg_italian "MC(block,comm_combo,Label)"             "Comando"

::msgcat::mcset pb_msg_italian "MC(block,edit_popup,Label)"             "Modifica"
::msgcat::mcset pb_msg_italian "MC(block,view_popup,Label)"             "Vista"
::msgcat::mcset pb_msg_italian "MC(block,change_popup,Label)"           "Cambia elemento"
::msgcat::mcset pb_msg_italian "MC(block,user_popup,Label)"             "Espressione definita dall'utente"
::msgcat::mcset pb_msg_italian "MC(block,opt_popup,Label)"              "Opzionale"
::msgcat::mcset pb_msg_italian "MC(block,no_sep_popup,Label)"           "Nessun separatore di parole"
::msgcat::mcset pb_msg_italian "MC(block,force_popup,Label)"            "Forza output"
::msgcat::mcset pb_msg_italian "MC(block,delete_popup,Label)"           "Elimina"
::msgcat::mcset pb_msg_italian "MC(block,undo_popup,Label)"             "Annulla operazione"
::msgcat::mcset pb_msg_italian "MC(block,delete_all,Label)"             "Elimina tutti gli elementi attivi"

::msgcat::mcset pb_msg_italian "MC(block,cmd_title,Label)"              "Comando personalizzato"
::msgcat::mcset pb_msg_italian "MC(block,oper_title,Label)"             "Messaggio operatore"
::msgcat::mcset pb_msg_italian "MC(block,addr_title,Label)"             "PAROLA"

::msgcat::mcset pb_msg_italian "MC(block,new_trans,title,Label)"        "PAROLA"

::msgcat::mcset pb_msg_italian "MC(block,new,word_desc,Label)"          "Nuovo indirizzo"
::msgcat::mcset pb_msg_italian "MC(block,oper,word_desc,Label)"         "Messaggio operatore"
::msgcat::mcset pb_msg_italian "MC(block,cmd,word_desc,Label)"          "Comando personalizzato"
::msgcat::mcset pb_msg_italian "MC(block,user,word_desc,Label)"         "Espressione definita dall'utente"
::msgcat::mcset pb_msg_italian "MC(block,text,word_desc,Label)"         "Stringa di testo"

::msgcat::mcset pb_msg_italian "MC(block,user,expr,Label)"              "Espressione"

::msgcat::mcset pb_msg_italian "MC(block,msg,min_word)"                 "Un blocco deve contenere almento una parola."

::msgcat::mcset pb_msg_italian "MC(block,name_msg)"                     "Nome blocco non valido.\n Specificare un altro nome."

##---------
## ADDRESS
##
::msgcat::mcset pb_msg_italian "MC(address,tab,Label)"                  "PAROLA"
::msgcat::mcset pb_msg_italian "MC(address,Status)"                     "Definisci parole"

::msgcat::mcset pb_msg_italian "MC(address,name,Label)"                 "Nome parola"
::msgcat::mcset pb_msg_italian "MC(address,name,Context)"               "Il nome di una parola può essere modificato."

::msgcat::mcset pb_msg_italian "MC(address,verify,Label)"               "PAROLA -- controllo"
::msgcat::mcset pb_msg_italian "MC(address,verify,Context)"             "La finestra visualizza il codice NC rappresentativo da stampare per una parola."

::msgcat::mcset pb_msg_italian "MC(address,leader,Label)"               "Inizio"
::msgcat::mcset pb_msg_italian "MC(address,leader,Context)"             "Si può inserire un numero qualsiasi di caratteri da aggiungere davanti alla parola oppure selezionare un carattere in un menu a comparsa usando il pulsante destro del mouse."

::msgcat::mcset pb_msg_italian "MC(address,format,Label)"               "Formato"
::msgcat::mcset pb_msg_italian "MC(address,format,edit,Label)"          "Modifica"
::msgcat::mcset pb_msg_italian "MC(address,format,edit,Context)"        "Il pulsante consente di modificare il formato usato per una parola."
::msgcat::mcset pb_msg_italian "MC(address,format,new,Label)"           "Nuovo"
::msgcat::mcset pb_msg_italian "MC(address,format,new,Context)"         "Il pulsante consente di creare un nuovo formato."

::msgcat::mcset pb_msg_italian "MC(address,format,select,Label)"        "PAROLA -- seleziona formato"
::msgcat::mcset pb_msg_italian "MC(address,format,select,Context)"      "Il pulsante consente di selezionare un altro formato per una parola."

::msgcat::mcset pb_msg_italian "MC(address,trailer,Label)"              "Fine"
::msgcat::mcset pb_msg_italian "MC(address,trailer,Context)"            "Si può inserire un numero qualsiasi di caratteri da aggiungere dopo la parola oppure selezionare un carattere in un menu a comparsa usando il pulsante destro del mouse."

::msgcat::mcset pb_msg_italian "MC(address,modality,Label)"             "Modale?"
::msgcat::mcset pb_msg_italian "MC(address,modality,Context)"           "L'opzione consente di impostare la modalità di una parola."

::msgcat::mcset pb_msg_italian "MC(address,modal_drop,off,Label)"       "Off"
::msgcat::mcset pb_msg_italian "MC(address,modal_drop,once,Label)"      "Una volta"
::msgcat::mcset pb_msg_italian "MC(address,modal_drop,always,Label)"    "Sempre"

::msgcat::mcset pb_msg_italian "MC(address,max,value,Label)"            "Massimo"
::msgcat::mcset pb_msg_italian "MC(address,max,value,Context)"          "Specificare il valore massimo per una parola."

::msgcat::mcset pb_msg_italian "MC(address,value,text,Label)"           "Valore"

::msgcat::mcset pb_msg_italian "MC(address,trunc_drop,Label)"           "Tronca valore"
::msgcat::mcset pb_msg_italian "MC(address,warn_drop,Label)"            "Avvisa utente"
::msgcat::mcset pb_msg_italian "MC(address,abort_drop,Label)"           "Interruzione processo"

::msgcat::mcset pb_msg_italian "MC(address,max,error_handle,Label)"     "Gestione violazioni"
::msgcat::mcset pb_msg_italian "MC(address,max,error_handle,Context)"   "Il pulsante consente di specificare il metodo con cui gestire eventuali violazione del valore massimo: \n \n * Tronca valore \n * Avvisa utente \n * Interrompi procedura \n"

::msgcat::mcset pb_msg_italian "MC(address,min,value,Label)"            "Minimo"
::msgcat::mcset pb_msg_italian "MC(address,min,value,Context)"          "Specificare il valore minimo per una parola."

::msgcat::mcset pb_msg_italian "MC(address,min,error_handle,Label)"     "Gestione violazioni"
::msgcat::mcset pb_msg_italian "MC(address,min,error_handle,Context)"   "Il pulsante consente di specificare il metodo con cui gestire eventuali violazione del valore minimo:\n \n * Tronca valore \n * Avvisa utente \n * Interrompi procedura \n"

::msgcat::mcset pb_msg_italian "MC(address,format_trans,title,Label)"   "FORMATO "
::msgcat::mcset pb_msg_italian "MC(address,none_popup,Label)"           "Nessuno"

::msgcat::mcset pb_msg_italian "MC(address,exp,Label)"                  "Espressione"
::msgcat::mcset pb_msg_italian "MC(address,exp,Context)"                "È possibile specificare un'espressione o a una costante per un Blocco."
::msgcat::mcset pb_msg_italian "MC(address,exp,msg)"                    "Le espressioni di un elemento blocco non devono essere vuote."
::msgcat::mcset pb_msg_italian "MC(address,exp,space_only)"             "L'espressione di un elemento blocco che usa un formato numerico non può essere formata solo da spazi."

## No translation is needed for this string.
::msgcat::mcset pb_msg_italian "MC(address,exp,spec_char)"              "\!  \"  \#  \&  \'  \.  \;  \<  \=  \>  \?  \@ \[  \\  \]  \^  \`  \{  \|  \}  \~"

::msgcat::mcset pb_msg_italian "MC(address,exp,spec_char_msg)"          "Non è possibile usare caratteri speciali \n [::msgcat::mc MC(address,exp,spec_char)] \n nell'espressione per i dati numerici."



::msgcat::mcset pb_msg_italian "MC(address,name_msg)"                   "Nome parola non valido.\n Specificare un altro nome."
# - No translation for rapid1, rapid2 & rapid3
::msgcat::mcset pb_msg_italian "MC(address,rapid_add_name_msg)"         "rapid1, rapid2 and rapid3 sono funzioni riservate per uso interno da Post Builder.\n Specificare un altro nome."

::msgcat::mcset pb_msg_italian "MC(address,rapid1,desc)"                "Posizionamento rapido lungo l'asse longitudinale"
::msgcat::mcset pb_msg_italian "MC(address,rapid2,desc)"                "Posizionamento rapido lungo l'asse trasversale"
::msgcat::mcset pb_msg_italian "MC(address,rapid3,desc)"                "Posizionamento rapido lungo l'asse mandrino"

##--------
## FORMAT
##
::msgcat::mcset pb_msg_italian "MC(format,tab,Label)"                   "FORMATO"
::msgcat::mcset pb_msg_italian "MC(format,Status)"                      "Definisce i formati"

::msgcat::mcset pb_msg_italian "MC(format,verify,Label)"                "FORMATO -- controllo"
::msgcat::mcset pb_msg_italian "MC(format,verify,Context)"              "La finestra visualizza il codice NC rappresentativo da stampare usando il formato specificato."

::msgcat::mcset pb_msg_italian "MC(format,name,Label)"                  "Nome formato"
::msgcat::mcset pb_msg_italian "MC(format,name,Context)"                "Il nome di un formato può essere modificato."

::msgcat::mcset pb_msg_italian "MC(format,data,type,Label)"             "Tipo di dati"
::msgcat::mcset pb_msg_italian "MC(format,data,type,Context)"           "Specificare il tipo di dati per un formato."
::msgcat::mcset pb_msg_italian "MC(format,data,num,Label)"              "Numerico"
::msgcat::mcset pb_msg_italian "MC(format,data,num,Context)"            "L'opzione consente di definire il tipo di dati di un formato come Numerico."
::msgcat::mcset pb_msg_italian "MC(format,data,num,integer,Label)"      "FORMATO -- cifre di un numero intero"
::msgcat::mcset pb_msg_italian "MC(format,data,num,integer,Context)"    "L'opzione consente di specificare il numero di cifre di un numero intero oppure la parte numero intero di un numero reale."
::msgcat::mcset pb_msg_italian "MC(format,data,num,fraction,Label)"     "FORMATO -- cifre di una frazione"
::msgcat::mcset pb_msg_italian "MC(format,data,num,fraction,Context)"   "L'opzione consente di specificare il numero di cifre della parte frazionale di un numero reale."
::msgcat::mcset pb_msg_italian "MC(format,data,num,decimal,Label)"      "Punto decimale di output (.) "
::msgcat::mcset pb_msg_italian "MC(format,data,num,decimal,Context)"    "L'opzione consente di effettuare l'output di punti decimali nel codice NC."
::msgcat::mcset pb_msg_italian "MC(format,data,num,lead,Label)"         "Zeri iniziali di output"
::msgcat::mcset pb_msg_italian "MC(format,data,num,lead,Context)"       "L'opzione consente di aggiungere zeri iniziali ai numeri specificati in codice NC."
::msgcat::mcset pb_msg_italian "MC(format,data,num,trail,Label)"        "Zeri finali di output"
::msgcat::mcset pb_msg_italian "MC(format,data,num,trail,Context)"      "L'opzione consente di aggiungere zeri finali ai numeri reali specificati in codice NC."
::msgcat::mcset pb_msg_italian "MC(format,data,text,Label)"             "Testo"
::msgcat::mcset pb_msg_italian "MC(format,data,text,Context)"           "L'operazione definisce il tipo di dati di un formato come stringa di testo."
::msgcat::mcset pb_msg_italian "MC(format,data,plus,Label)"             "Segno più iniziale di output (+)"
::msgcat::mcset pb_msg_italian "MC(format,data,plus,Context)"           "L'operazione consente di effettuare l'output dei segni più nel codice NC."
::msgcat::mcset pb_msg_italian "MC(format,zero_msg)"                    "Impossibile eseguire una copia formato zero"
::msgcat::mcset pb_msg_italian "MC(format,zero_cut_msg)"                "Impossibile eliminare un formato zero"

::msgcat::mcset pb_msg_italian "MC(format,data,dec_zero,msg)"           "Selezionare almeno un'opzione tra le seguenti: punto decimale, zeri iniziali o zeri finali."

::msgcat::mcset pb_msg_italian "MC(format,data,no_digit,msg)"           "I numeri interi e le frazioni non possono avere entrambi zero cifre."

::msgcat::mcset pb_msg_italian "MC(format,name_msg)"                    "Nome formato non valido.\n Specificare un altro nome."
::msgcat::mcset pb_msg_italian "MC(format,error,title)"                 "Errore di formato"
::msgcat::mcset pb_msg_italian "MC(format,error,msg)"                   "Il formato è stato usato negli indirizzi"

##---------------------
## Other Data Elements
##
::msgcat::mcset pb_msg_italian "MC(other,tab,Label)"                    "Altri elementi di dati"
::msgcat::mcset pb_msg_italian "MC(other,Status)"                       "Specificare i parametri"

::msgcat::mcset pb_msg_italian "MC(other,seq_num,Label)"                "Numero di sequenza"
::msgcat::mcset pb_msg_italian "MC(other,seq_num,Context)"              "L'opzione consente di attivare/disattivare l'output dei numeri di sequenza in codice NC."
::msgcat::mcset pb_msg_italian "MC(other,seq_num,start,Label)"          "Inizia numeri di sequenza"
::msgcat::mcset pb_msg_italian "MC(other,seq_num,start,Context)"        "Specificare l'inizio dei numeri di sequenza"
::msgcat::mcset pb_msg_italian "MC(other,seq_num,inc,Label)"            "Incremento numero di sequenza"
::msgcat::mcset pb_msg_italian "MC(other,seq_num,inc,Context)"          "Specificare l'incremento dei numeri di sequenza."
::msgcat::mcset pb_msg_italian "MC(other,seq_num,freq,Label)"           "Frequenza numero di sequenza"
::msgcat::mcset pb_msg_italian "MC(other,seq_num,freq,Context)"         "Specificare la frequenza dei numeri di sequenza come appare nel codice NC."
::msgcat::mcset pb_msg_italian "MC(other,seq_num,max,Label)"            "Numero di sequenza massimo"
::msgcat::mcset pb_msg_italian "MC(other,seq_num,max,Context)"          "Specificare il valore massimo dei numeri di sequenza."

::msgcat::mcset pb_msg_italian "MC(other,chars,Label)"                  "Caratteri speciali"
::msgcat::mcset pb_msg_italian "MC(other,chars,word_sep,Label)"         "Separatore parole"
::msgcat::mcset pb_msg_italian "MC(other,chars,word_sep,Context)"       "Specificare il carattere da usare come separatore di parole."
::msgcat::mcset pb_msg_italian "MC(other,chars,decimal_pt,Label)"       "Punto decimale"
::msgcat::mcset pb_msg_italian "MC(other,chars,decimal_pt,Context)"     "Specificare il carattere da usare come punto decimale."
::msgcat::mcset pb_msg_italian "MC(other,chars,end_of_block,Label)"     "Fine blocco"
::msgcat::mcset pb_msg_italian "MC(other,chars,end_of_block,Context)"   "Specificare il carattere da usare come fine del blocco."
::msgcat::mcset pb_msg_italian "MC(other,chars,comment_start,Label)"    "Inizio messaggio"
::msgcat::mcset pb_msg_italian "MC(other,chars,comment_start,Context)"  "Specificare i caratteri da usare come inizio di riga di un messaggio  operatore."
::msgcat::mcset pb_msg_italian "MC(other,chars,comment_end,Label)"      "Fine messaggio"
::msgcat::mcset pb_msg_italian "MC(other,chars,comment_end,Context)"    "Specificare i caratteri da usare come fine di riga di un messaggio operatore."

::msgcat::mcset pb_msg_italian "MC(other,opskip,Label)"                 "OPSKIP"
::msgcat::mcset pb_msg_italian "MC(other,opskip,leader,Label)"          "Leader riga"
::msgcat::mcset pb_msg_italian "MC(other,opskip,leader,Context)"        "OPSKIP Leader riga"

::msgcat::mcset pb_msg_italian "MC(other,gm_codes,Label)"               "Output codici G e M per blocco"
::msgcat::mcset pb_msg_italian "MC(other,g_codes,Label)"                "Numero di codici G per blocco"
::msgcat::mcset pb_msg_italian "MC(other,g_codes,Context)"              "L'opzione consente all'operatore di attivare/disattivare il controllo del numero di codici G per blocco di output NC."
::msgcat::mcset pb_msg_italian "MC(other,g_codes,num,Label)"            "Numero di codici G"
::msgcat::mcset pb_msg_italian "MC(other,g_codes,num,Context)"          "Specificare il numero di codici G per blocco di output NC."
::msgcat::mcset pb_msg_italian "MC(other,m_codes,Label)"                "Numero di codici M"
::msgcat::mcset pb_msg_italian "MC(other,m_codes,Context)"              "L'opzione consente all'operatore di attivare/disattivare il controllo del numero di codici M per blocco di output NC."
::msgcat::mcset pb_msg_italian "MC(other,m_codes,num,Label)"            "Numero di codici M per blocco"
::msgcat::mcset pb_msg_italian "MC(other,m_codes,num,Context)"          "Specificare il numero di codici M per blocco di ouput NC."

::msgcat::mcset pb_msg_italian "MC(other,opt_none,Label)"               "Nessuno"
::msgcat::mcset pb_msg_italian "MC(other,opt_space,Label)"              "Spazio"
::msgcat::mcset pb_msg_italian "MC(other,opt_dec,Label)"                "Decimale (.)"
::msgcat::mcset pb_msg_italian "MC(other,opt_comma,Label)"              "Virgola (,)"
::msgcat::mcset pb_msg_italian "MC(other,opt_semi,Label)"               "Punto e virgola (;)"
::msgcat::mcset pb_msg_italian "MC(other,opt_colon,Label)"              "Due punti (:)"
::msgcat::mcset pb_msg_italian "MC(other,opt_text,Label)"               "Stringa di testo"
::msgcat::mcset pb_msg_italian "MC(other,opt_left,Label)"               "Aperta parentesi ("
::msgcat::mcset pb_msg_italian "MC(other,opt_right,Label)"              "Chiusa parentesi )"
::msgcat::mcset pb_msg_italian "MC(other,opt_pound,Label)"              "Cancelletto (\#)"
::msgcat::mcset pb_msg_italian "MC(other,opt_aster,Label)"              "Asterisco (*)"
::msgcat::mcset pb_msg_italian "MC(other,opt_slash,Label)"              "Barra (/)"
::msgcat::mcset pb_msg_italian "MC(other,opt_new_line,Label)"           "Nuova riga (\\012)"

# UDE Inclusion
::msgcat::mcset pb_msg_italian "MC(other,ude,Label)"                    "Eventi definiti da utente"
::msgcat::mcset pb_msg_italian "MC(other,ude_include,Label)"            "Includi altri file CDL"
::msgcat::mcset pb_msg_italian "MC(other,ude_include,Context)"          "L'opzione abilita il post ad includere riferimenti ad un file CDL nel file di definizioni."

::msgcat::mcset pb_msg_italian "MC(other,ude_file,Label)"               "Nome file CDL"
::msgcat::mcset pb_msg_italian "MC(other,ude_file,Context)"             "Percorso e nome di un file CDL da referenziare (INCLUDE) nel file di definizioni del post. Il nome percorso deve iniziare con una variable di ambiente UG (\\\$UGII). Quando non viene specificato un percorso, UGII_CAM_FILE_SEARCH_PATH verrà usato da UG/NX per individuare il file durante l'esecuzione."
::msgcat::mcset pb_msg_italian "MC(other,ude_select,Label)"             "Seleziona nome"
::msgcat::mcset pb_msg_italian "MC(other,ude_select,Context)"           "Percorso e nome di un file CDL da referenziare (INCLUDE) nel file di definizioni di questo post. Per impostazione predefinita, al nome file selezionato viene aggiunto il prefisso \\\$UGII_CAM_USER_DEF_EVENT_DIR/. Il nome percorso può essere modificato secondo le esigenze dopo la selezione."


#+++++++++++++++++
# Output Settings
#+++++++++++++++++
::msgcat::mcset pb_msg_italian "MC(output,tab,Label)"                   "Impostazioni di output"
::msgcat::mcset pb_msg_italian "MC(output,Status)"                      "Configura parametri di output"

#++++++++++++++
# VNC Controls
#++++++++++++++
::msgcat::mcset pb_msg_italian "MC(output,vnc,Label)"                   "Controller NC virtuale"
::msgcat::mcset pb_msg_italian "MC(output,vnc,mode,std,Label)"          "Autonomo"
::msgcat::mcset pb_msg_italian "MC(output,vnc,mode,sub,Label)"          "Subordinato"
::msgcat::mcset pb_msg_italian "MC(output,vnc,status,Label)"            "Selezionare un file VNC."
::msgcat::mcset pb_msg_italian "MC(output,vnc,mis_match,Label)"         "Il file selezionato non corrisponde al nome file VNC predefinito.\n Riselezionare il file?"
::msgcat::mcset pb_msg_italian "MC(output,vnc,output,Label)"            "Genera controller virtuale NC (VNC)"
::msgcat::mcset pb_msg_italian "MC(output,vnc,output,Context)"          "L'opzione consente di generare un controller virtuale NC (VNC). Un post creato con VNC può essere usato per ISV."
::msgcat::mcset pb_msg_italian "MC(output,vnc,main,Label)"              "VNC master"
::msgcat::mcset pb_msg_italian "MC(output,vnc,main,Context)"            "Il nome del master VNC referenziato da un VNC subordinato. Durante l'esecuzione di ISV, se il post non si trova nella stessa directory del VNC subordinato, viene usato un post con lo stesso nome presente nella directory \\\$UGII_CAM_POST_DIR."


::msgcat::mcset pb_msg_italian "MC(output,vnc,main,err_msg)"                 "Specificare il VNC master  del VNC subordinato."
::msgcat::mcset pb_msg_italian "MC(output,vnc,main,select_name,Label)"       "Seleziona nome"
::msgcat::mcset pb_msg_italian "MC(output,vnc,main,select_name,Context)"     "Selezionare il nome del VNC da referenziare con un VNC subordinato. Durante l'esecuzione di ISV, se il post non si trova nella stessa directory del VNC subordinato, viene usato un post con lo stesso nome presente nella directory \\\$UGII_CAM_POST_DIR."

::msgcat::mcset pb_msg_italian "MC(output,vnc,mode,Label)"                   "Modalità controller virtuale NC"
::msgcat::mcset pb_msg_italian "MC(output,vnc,mode,Context)"                 "Un controller virtuale NC può essere autonomo oppure subordinato ad una VNC master."
::msgcat::mcset pb_msg_italian "MC(output,vnc,mode,std,Context)"             "Un VNC autonomo è un'unità a se stante."
::msgcat::mcset pb_msg_italian "MC(output,vnc,mode,sub,Context)"             "Un VNC subordinato dipende ampiamente dal VNC master. Fa riferimento al VNC master durante l'esecuzione ISV."
::msgcat::mcset pb_msg_italian "MC(output,vnc,pb_ver,msg)"                   "Controller virtuale NC creato con Post Builder "
#++++++++++++++
# Listing File
#++++++++++++++
::msgcat::mcset pb_msg_italian "MC(listing,tab,Label)"                  "File elenco"
::msgcat::mcset pb_msg_italian "MC(listing,Status)"                     "Specificare i parametri del file elenco"

::msgcat::mcset pb_msg_italian "MC(listing,gen,Label)"                  "Genera file elenco"
::msgcat::mcset pb_msg_italian "MC(listing,gen,Context)"                "L'opzione consente di attivare/disattivare l'output del file elenco."

::msgcat::mcset pb_msg_italian "MC(listing,Label)"                      "Elementi file elenco"
::msgcat::mcset pb_msg_italian "MC(listing,parms,Label)"                "Componenti"

::msgcat::mcset pb_msg_italian "MC(listing,parms,x,Label)"              "Coordinata X"
::msgcat::mcset pb_msg_italian "MC(listing,parms,x,Context)"            "L'opzione consente di attivare/disattivare l'output della coordinata X nel file elenco."

::msgcat::mcset pb_msg_italian "MC(listing,parms,y,Label)"              "Coordinata Y"
::msgcat::mcset pb_msg_italian "MC(listing,parms,y,Context)"            "L'opzione consente di attivare/disattivare l'output della coordinata Y nel file elenco."

::msgcat::mcset pb_msg_italian "MC(listing,parms,z,Label)"              "Coordinata Z"
::msgcat::mcset pb_msg_italian "MC(listing,parms,z,Context)"            "L'opzione consente di attivare/disattivare l'output della coordinata Z nel file elenco."

::msgcat::mcset pb_msg_italian "MC(listing,parms,4,Label)"              "Angolo quarto asse"
::msgcat::mcset pb_msg_italian "MC(listing,parms,4,Context)"            "L'opzione consente di attivare/disattivare l'ouput del quarto angolo nel file elenco."

::msgcat::mcset pb_msg_italian "MC(listing,parms,5,Label)"              "Angolo quinto asse"
::msgcat::mcset pb_msg_italian "MC(listing,parms,5,Context)"            "L'opzione consente di attivare/disattivare l'ouput del quinto angolo nel file elenco."

::msgcat::mcset pb_msg_italian "MC(listing,parms,feed,Label)"           "Avanzamento"
::msgcat::mcset pb_msg_italian "MC(listing,parms,feed,Context)"         "L'opzione consente di attivare/disattivare l'output  avanzamento nel file elenco."

::msgcat::mcset pb_msg_italian "MC(listing,parms,speed,Label)"          "Velocità"
::msgcat::mcset pb_msg_italian "MC(listing,parms,speed,Context)"        "L'opzione consente di attivare/disattivare l'output velocità mandrino nel file elenco."

::msgcat::mcset pb_msg_italian "MC(listing,extension,Label)"            "Estensione file elenco"
::msgcat::mcset pb_msg_italian "MC(listing,extension,Context)"          "Specificare l'estensione file elenco"

::msgcat::mcset pb_msg_italian "MC(listing,nc_file,Label)"              "Estensione file di output NC"
::msgcat::mcset pb_msg_italian "MC(listing,nc_file,Context)"            "Specificare l'estensione del file di ouput"

::msgcat::mcset pb_msg_italian "MC(listing,header,Label)"               "Intestazione programma"
::msgcat::mcset pb_msg_italian "MC(listing,header,oper_list,Label)"     "Elenco di operazioni"
::msgcat::mcset pb_msg_italian "MC(listing,header,tool_list,Label)"     "Elenco utensili"

::msgcat::mcset pb_msg_italian "MC(listing,footer,Label)"               "Piè di pagina programma"
::msgcat::mcset pb_msg_italian "MC(listing,footer,cut_time,Label)"      "Tempo di lavorazione totale"

::msgcat::mcset pb_msg_italian "MC(listing,format,Label)"                   "Formato di pagina"
::msgcat::mcset pb_msg_italian "MC(listing,format,print_header,Label)"      "Stampa intestazione di pagina"
::msgcat::mcset pb_msg_italian "MC(listing,format,print_header,Context)"    "L'opzione consente di attivare/disattivare l'output dell'intestazione di pagina in un file elenco."

::msgcat::mcset pb_msg_italian "MC(listing,format,length,Label)"        "Lunghezza pagina (righe)"
::msgcat::mcset pb_msg_italian "MC(listing,format,length,Context)"      "Specificare il numero di righe per pagina per il file elenco."
::msgcat::mcset pb_msg_italian "MC(listing,format,width,Label)"         "Larghezza pagina (colonne)"
::msgcat::mcset pb_msg_italian "MC(listing,format,width,Context)"       "Specificare il numero di colonne per pagina per il file elenco."

::msgcat::mcset pb_msg_italian "MC(listing,other,tab,Label)"            "Altre opzioni"
::msgcat::mcset pb_msg_italian "MC(listing,output,Label)"               "Output elementi di controllo"

::msgcat::mcset pb_msg_italian "MC(listing,output,warning,Label)"       "Output messaggi di avviso"
::msgcat::mcset pb_msg_italian "MC(listing,output,warning,Context)"     "L'opzione consente di attivare/disattivare l'output di messaggi di avviso durante il postprocessamento. "

::msgcat::mcset pb_msg_italian "MC(listing,output,review,Label)"        "Attiva strumento di revisione"
::msgcat::mcset pb_msg_italian "MC(listing,output,review,Context)"      "L'opzione consente di attivare/disattivare lo strumento di revisione durante il postprocessamento."

::msgcat::mcset pb_msg_italian "MC(listing,output,group,Label)"         "Genera output gruppo"
::msgcat::mcset pb_msg_italian "MC(listing,output,group,Context)"       "L'opzione consente di attivare/disattivare il controllo dell'output gruppo durante il postprocessamento."

::msgcat::mcset pb_msg_italian "MC(listing,output,verbose,Label)"       "Visualizza messaggi di errore dettagliati"
::msgcat::mcset pb_msg_italian "MC(listing,output,verbose,Context)"     "L'opzione consente di visualizzare le descrizioni dettagliate delle condizioni di errore. Attivando l'opzione si rallentano leggermente le operazioni di postprocessamento."

::msgcat::mcset pb_msg_italian "MC(listing,oper_info,Label)"            "Informazioni operazione"
::msgcat::mcset pb_msg_italian "MC(listing,oper_info,parms,Label)"      "Parametri operazione"
::msgcat::mcset pb_msg_italian "MC(listing,oper_info,tool,Label)"       "Parametri utensile"
::msgcat::mcset pb_msg_italian "MC(listing,oper_info,cut_time,,Label)"  "Tempo di lavorazione"


#<09-19-00 gsl>
::msgcat::mcset pb_msg_italian "MC(listing,user_tcl,frame,Label)"       "Sorgente Tcl utente"
::msgcat::mcset pb_msg_italian "MC(listing,user_tcl,check,Label)"       "File Tcl sorgente utente "
::msgcat::mcset pb_msg_italian "MC(listing,user_tcl,check,Context)"     "L'opzione consente di referenziare i propri file Tcl."
::msgcat::mcset pb_msg_italian "MC(listing,user_tcl,name,Label)"        "Nome file"
::msgcat::mcset pb_msg_italian "MC(listing,user_tcl,name,Context)"      "Specificare il nome di un file Tcl da referenziare per il post."

#++++++++++++++++
# Output Preview
#++++++++++++++++
::msgcat::mcset pb_msg_italian "MC(preview,tab,Label)"                  "Anteprima file post"
::msgcat::mcset pb_msg_italian "MC(preview,new_code,Label)"             "Nuovo codice"
::msgcat::mcset pb_msg_italian "MC(preview,old_code,Label)"             "Vecchio codice"

##---------------------
## Event Handler
##
::msgcat::mcset pb_msg_italian "MC(event_handler,tab,Label)"            "Handler di eventi"
::msgcat::mcset pb_msg_italian "MC(event_handler,Status)"               "Scegliere l'evento di cui visualizzare la procedura"

##---------------------
## Definition
##
::msgcat::mcset pb_msg_italian "MC(definition,tab,Label)"               "Definizioni"
::msgcat::mcset pb_msg_italian "MC(definition,Status)"                  "Scegliere l'oggetto di cui visualizzare il contenuto"

#++++++++++++++
# Post Advisor
#++++++++++++++
::msgcat::mcset pb_msg_italian "MC(advisor,tab,Label)"                  "Post Advisor"
::msgcat::mcset pb_msg_italian "MC(advisor,Status)"                     "Post Advisor"

::msgcat::mcset pb_msg_italian "MC(definition,word_txt,Label)"          "WORD_SEPARATOR"
::msgcat::mcset pb_msg_italian "MC(definition,end_txt,Label)"           "END_OF_BLOCK"
::msgcat::mcset pb_msg_italian "MC(definition,seq_txt,Label)"           "SEQUENCE_NUM"
::msgcat::mcset pb_msg_italian "MC(definition,include,Label)"           "INCLUDE"
::msgcat::mcset pb_msg_italian "MC(definition,format_txt,Label)"        "FORMATO"
::msgcat::mcset pb_msg_italian "MC(definition,addr_txt,Label)"          "PAROLA"
::msgcat::mcset pb_msg_italian "MC(definition,block_txt,Label)"         "BLOCCO"
::msgcat::mcset pb_msg_italian "MC(definition,comp_txt,Label)"          "BLOCCO composito"
::msgcat::mcset pb_msg_italian "MC(definition,post_txt,Label)"          "BLOCCO post"
::msgcat::mcset pb_msg_italian "MC(definition,oper_txt,Label)"          "Messaggio operatore"

#+++++++++++++
# Balloon
#+++++++++++++
::msgcat::mcset pb_msg_italian "MC(msg,odd)"                            "Numero dispari di argomenti opzione"
::msgcat::mcset pb_msg_italian "MC(msg,wrong_list_1)"                   "Opzioni sconosciute"
::msgcat::mcset pb_msg_italian "MC(msg,wrong_list_2)"                   ". Deve essere uno di:"

#+++++++++++++++++
# Event UI Labels
#+++++++++++++++++

### Program Start
::msgcat::mcset pb_msg_italian "MC(event,start_prog,name)"              "Inizio programma"

### Operation Start
::msgcat::mcset pb_msg_italian "MC(event,opr_start,start_path,name)"    "Inizio percorso"
::msgcat::mcset pb_msg_italian "MC(event,opr_start,from_move,name)"     "Movimento Da"
::msgcat::mcset pb_msg_italian "MC(event,opr_start,fst_tool,name)"      "Primo utensile"
::msgcat::mcset pb_msg_italian "MC(event,opr_start,auto_tc,name)"       "Cambio utensile automatico"
::msgcat::mcset pb_msg_italian "MC(event,opr_start,manual_tc,name)"     "Cambio utensile manuale"
::msgcat::mcset pb_msg_italian "MC(event,opr_start,init_move,name)"     "Movimento iniziale"
::msgcat::mcset pb_msg_italian "MC(event,opr_start,fst_move,name)"      "Primo movimento"
::msgcat::mcset pb_msg_italian "MC(event,opr_start,appro_move,name)"    "Movimento di avvicinamento"
::msgcat::mcset pb_msg_italian "MC(event,opr_start,engage_move,name)"   "Movimento di attacco"
::msgcat::mcset pb_msg_italian "MC(event,opr_start,fst_cut,name)"       "Primo taglio"
::msgcat::mcset pb_msg_italian "MC(event,opr_start,fst_lin_move,name)"  "Primo movimento lineare"
::msgcat::mcset pb_msg_italian "MC(event,opr_start,start_pass,name)"    "Inizio passata"
::msgcat::mcset pb_msg_italian "MC(event,opr_start,cutcom_move,name)"   "Movimento cutcom"
::msgcat::mcset pb_msg_italian "MC(event,opr_start,lead_move,name)"     "Movimento di attacco"

### Operation End
::msgcat::mcset pb_msg_italian "MC(event,opr_end,ret_move,name)"        "Movimento di stacco"
::msgcat::mcset pb_msg_italian "MC(event,opr_end,rtn_move,name)"        "Movimento di ritorno"
::msgcat::mcset pb_msg_italian "MC(event,opr_end,goh_move,name)"        "Movimento Gohome"
::msgcat::mcset pb_msg_italian "MC(event,opr_end,end_path,name)"        "Fine percorso"
::msgcat::mcset pb_msg_italian "MC(event,opr_end,lead_move,name)"       "Movimento di stacco"
::msgcat::mcset pb_msg_italian "MC(event,opr_end,end_pass,name)"        "Fine passata"

### Program End
::msgcat::mcset pb_msg_italian "MC(event,end_prog,name)"                "Fine programma"


### Tool Change
::msgcat::mcset pb_msg_italian "MC(event,tool_change,name)"             "Cambio utensile"
::msgcat::mcset pb_msg_italian "MC(event,tool_change,m_code)"           "Codice M"
::msgcat::mcset pb_msg_italian "MC(event,tool_change,m_code,tl_chng)"   "Cambio utensile"
::msgcat::mcset pb_msg_italian "MC(event,tool_change,m_code,pt)"        "Torretta principale"
::msgcat::mcset pb_msg_italian "MC(event,tool_change,m_code,st)"        "Torretta secondaria"
::msgcat::mcset pb_msg_italian "MC(event,tool_change,t_code)"           "Codice T"
::msgcat::mcset pb_msg_italian "MC(event,tool_change,t_code,conf)"      "Configura"
::msgcat::mcset pb_msg_italian "MC(event,tool_change,t_code,pt_idx)"    "Indice torretta principale"
::msgcat::mcset pb_msg_italian "MC(event,tool_change,t_code,st_idx)"    "Indice torretta secondaria"
::msgcat::mcset pb_msg_italian "MC(event,tool_change,tool_num)"         "Numero utensile"
::msgcat::mcset pb_msg_italian "MC(event,tool_change,tool_num,min)"     "Minimo"
::msgcat::mcset pb_msg_italian "MC(event,tool_change,tool_num,max)"     "Massimo"
::msgcat::mcset pb_msg_italian "MC(event,tool_change,time)"             "Tempo (sec)"
::msgcat::mcset pb_msg_italian "MC(event,tool_change,time,tl_chng)"     "Cambio utensile"
::msgcat::mcset pb_msg_italian "MC(event,tool_change,retract)"          "Stacco"
::msgcat::mcset pb_msg_italian "MC(event,tool_change,retract_z)"        "Stacca fino alla Z di"

### Length Compensation
::msgcat::mcset pb_msg_italian "MC(event,length_compn,name)"            "Compensazione lunghezza"
::msgcat::mcset pb_msg_italian "MC(event,length_compn,g_code)"          "Codice G"
::msgcat::mcset pb_msg_italian "MC(event,length_compn,g_code,len_adj)"  "Regola lunghezza utensile"
::msgcat::mcset pb_msg_italian "MC(event,length_compn,t_code)"          "Codice T"
::msgcat::mcset pb_msg_italian "MC(event,length_compn,t_code,conf)"     "Configura"
::msgcat::mcset pb_msg_italian "MC(event,length_compn,len_off)"         "Registro offset lunghezza"
::msgcat::mcset pb_msg_italian "MC(event,length_compn,len_off,min)"     "Minimo"
::msgcat::mcset pb_msg_italian "MC(event,length_compn,len_off,max)"     "Massimo"

### Set Modes
::msgcat::mcset pb_msg_italian "MC(event,set_modes,name)"               "Modalità gruppo"
::msgcat::mcset pb_msg_italian "MC(event,set_modes,out_mode)"           "Modalità di output"
::msgcat::mcset pb_msg_italian "MC(event,set_modes,g_code)"             "Codice G"
::msgcat::mcset pb_msg_italian "MC(event,set_modes,g_code,absolute)"    "Assoluto"
::msgcat::mcset pb_msg_italian "MC(event,set_modes,g_code,incremental)" "Incrementale"
::msgcat::mcset pb_msg_italian "MC(event,set_modes,rotary_axis)"        "L'asse di rotazione può essere incrementale"

### Spindle RPM
::msgcat::mcset pb_msg_italian "MC(event,spindle_rpm,name)"                     "Giri/min mandrino"
::msgcat::mcset pb_msg_italian "MC(event,spindle_rpm,dir_m_code)"               "Codici M di direzione mandrino"
::msgcat::mcset pb_msg_italian "MC(event,spindle_rpm,dir_m_code,cw)"            "Senso orario (CW)"
::msgcat::mcset pb_msg_italian "MC(event,spindle_rpm,dir_m_code,ccw)"           "Senso antiorario (CCW)"
::msgcat::mcset pb_msg_italian "MC(event,spindle_rpm,range_control)"            "Controllo intervallo mandrino"
::msgcat::mcset pb_msg_italian "MC(event,spindle_rpm,range_control,dwell_time)" "Tempo sosta cambio intervallo (sec)"
::msgcat::mcset pb_msg_italian "MC(event,spindle_rpm,range_control,range_code)" "Specifica codice intervallo"

### Spindle CSS
::msgcat::mcset pb_msg_italian "MC(event,spindle_css,name)"             "CSS mandrino"
::msgcat::mcset pb_msg_italian "MC(event,spindle_css,g_code)"           "Codice G mandrino"
::msgcat::mcset pb_msg_italian "MC(event,spindle_css,g_code,const)"     "Codice superficie costante"
::msgcat::mcset pb_msg_italian "MC(event,spindle_css,g_code,max)"       "Codice giri/min max"
::msgcat::mcset pb_msg_italian "MC(event,spindle_css,g_code,sfm)"       "Codice per eliminare SFM"
::msgcat::mcset pb_msg_italian "MC(event,spindle_css,max)"              "Giri/min max durante CSS"
::msgcat::mcset pb_msg_italian "MC(event,spindle_css,sfm)"              "Usare sempre la modalità pollici/giro per l'SFM"

### Spindle Off
::msgcat::mcset pb_msg_italian "MC(event,spindle_off,name)"             "Disattiva mandrino"
::msgcat::mcset pb_msg_italian "MC(event,spindle_off,dir_m_code)"       "Codice M direzione mandrino"
::msgcat::mcset pb_msg_italian "MC(event,spindle_off,dir_m_code,off)"   "Off"

### Coolant On
::msgcat::mcset pb_msg_italian "MC(event,coolant_on,name)"              "Refrigerante attivo"
::msgcat::mcset pb_msg_italian "MC(event,coolant_on,m_code)"            "Codice M"
::msgcat::mcset pb_msg_italian "MC(event,coolant_on,m_code,on)"         "ON"
::msgcat::mcset pb_msg_italian "MC(event,coolant_on,m_code,flood)"      "Flood"
::msgcat::mcset pb_msg_italian "MC(event,coolant_on,m_code,mist)"       "Nebulizzazione"
::msgcat::mcset pb_msg_italian "MC(event,coolant_on,m_code,thru)"       "Passante"
::msgcat::mcset pb_msg_italian "MC(event,coolant_on,m_code,tap)"        "Filettatura"

### Coolant Off
::msgcat::mcset pb_msg_italian "MC(event,coolant_off,name)"             "Refrigerante disattivato"
::msgcat::mcset pb_msg_italian "MC(event,coolant_off,m_code)"           "Codice M"
::msgcat::mcset pb_msg_italian "MC(event,coolant_off,m_code,off)"       "Off"

### Inch Metric Mode
::msgcat::mcset pb_msg_italian "MC(event,inch_metric_mode,name)"            "Modalità sistema metrico/anglossassone"
::msgcat::mcset pb_msg_italian "MC(event,inch_metric_mode,g_code)"          "Codice G"
::msgcat::mcset pb_msg_italian "MC(event,inch_metric_mode,g_code,english)"  "Anglosassone (pollici)"
::msgcat::mcset pb_msg_italian "MC(event,inch_metric_mode,g_code,metric)"   "Sistema metrico decimale (millimetri)"

### Feedrates
::msgcat::mcset pb_msg_italian "MC(event,feedrates,name)"               "Velocità di avanzamento"
::msgcat::mcset pb_msg_italian "MC(event,feedrates,ipm_mode)"           "Modalità pollici/min"
::msgcat::mcset pb_msg_italian "MC(event,feedrates,ipr_mode)"           "Modalità pollici/giro"
::msgcat::mcset pb_msg_italian "MC(event,feedrates,dpm_mode)"           "Modalità DPM"
::msgcat::mcset pb_msg_italian "MC(event,feedrates,mmpm_mode)"          "Modalità mm/min"
::msgcat::mcset pb_msg_italian "MC(event,feedrates,mmpr_mode)"          "Modalità mm/giro"
::msgcat::mcset pb_msg_italian "MC(event,feedrates,frn_mode)"           "Modalità FRN"
::msgcat::mcset pb_msg_italian "MC(event,feedrates,g_code)"             "Codice G"
::msgcat::mcset pb_msg_italian "MC(event,feedrates,format)"             "Formato"
::msgcat::mcset pb_msg_italian "MC(event,feedrates,max)"                "Massimo"
::msgcat::mcset pb_msg_italian "MC(event,feedrates,min)"                "Minimo"
::msgcat::mcset pb_msg_italian "MC(event,feedrates,mode,label)"         "Modalità avanzamento"
::msgcat::mcset pb_msg_italian "MC(event,feedrates,mode,lin)"           "Solo lineare"
::msgcat::mcset pb_msg_italian "MC(event,feedrates,mode,rot)"           "Solo rotazione"
::msgcat::mcset pb_msg_italian "MC(event,feedrates,mode,lin_rot)"       "Lineare e di rotazione"
::msgcat::mcset pb_msg_italian "MC(event,feedrates,mode,rap_lin)"       "Solo lineare rapido"
::msgcat::mcset pb_msg_italian "MC(event,feedrates,mode,rap_rot)"       "Solo rotazione rapida"
::msgcat::mcset pb_msg_italian "MC(event,feedrates,mode,rap_lin_rot)"   "Lineare e rotazione rapida"
::msgcat::mcset pb_msg_italian "MC(event,feedrates,cycle_mode)"         "Modalità avanzamento ciclo"
::msgcat::mcset pb_msg_italian "MC(event,feedrates,cycle)"              "Ciclo"

### Cutcom On
::msgcat::mcset pb_msg_italian "MC(event,cutcom_on,name)"               "Cutcom attivo"
::msgcat::mcset pb_msg_italian "MC(event,cutcom_on,g_code)"             "Codice G"
::msgcat::mcset pb_msg_italian "MC(event,cutcom_on,left)"               "Sinistra"
::msgcat::mcset pb_msg_italian "MC(event,cutcom_on,right)"              "Destra"
::msgcat::mcset pb_msg_italian "MC(event,cutcom_on,app_planes)"         "Piani applicabili"
::msgcat::mcset pb_msg_italian "MC(event,cutcom_on,edit_planes)"        "Modifica codici piano"
::msgcat::mcset pb_msg_italian "MC(event,cutcom_on,reg)"                "Registro cutcom"
::msgcat::mcset pb_msg_italian "MC(event,cutcom_on,min)"                "Minimo"
::msgcat::mcset pb_msg_italian "MC(event,cutcom_on,max)"                "Massimo"
::msgcat::mcset pb_msg_italian "MC(event,cutcom_on,bef)"                "Disattiva cutcom prima del cambio"

### Cutcom Off
::msgcat::mcset pb_msg_italian "MC(event,cutcom_off,name)"              "Cutcom disattivo"
::msgcat::mcset pb_msg_italian "MC(event,cutcom_off,g_code)"            "Codice G"
::msgcat::mcset pb_msg_italian "MC(event,cutcom_off,off)"               "Off"

### Delay
::msgcat::mcset pb_msg_italian "MC(event,delay,name)"                   "Ritardo"
::msgcat::mcset pb_msg_italian "MC(event,delay,seconds)"                "Secondi"
::msgcat::mcset pb_msg_italian "MC(event,delay,seconds,g_code)"         "Codice G"
::msgcat::mcset pb_msg_italian "MC(event,delay,seconds,format)"         "Formato"
::msgcat::mcset pb_msg_italian "MC(event,delay,out_mode)"               "Modalità di output"
::msgcat::mcset pb_msg_italian "MC(event,delay,out_mode,sec)"           "Solo secondi"
::msgcat::mcset pb_msg_italian "MC(event,delay,out_mode,rev)"           "Solo giri"
::msgcat::mcset pb_msg_italian "MC(event,delay,out_mode,feed)"          "Dipende dalla velocità di avanzamento"
::msgcat::mcset pb_msg_italian "MC(event,delay,out_mode,ivs)"           "Ritardo inversamente proporzionale"
::msgcat::mcset pb_msg_italian "MC(event,delay,revolution)"             "Rivoluzioni"
::msgcat::mcset pb_msg_italian "MC(event,delay,revolution,g_code)"      "Codice G"
::msgcat::mcset pb_msg_italian "MC(event,delay,revolution,format)"      "Formato"

### Option Stop
::msgcat::mcset pb_msg_italian "MC(event,opstop,name)"                  "Opstop"

### Auxfun
::msgcat::mcset pb_msg_italian "MC(event,auxfun,name)"                  "Auxfun"

### Prefun
::msgcat::mcset pb_msg_italian "MC(event,prefun,name)"                  "Prefun"

### Load Tool
::msgcat::mcset pb_msg_italian "MC(event,loadtool,name)"                "Carica utensile"

### Stop
::msgcat::mcset pb_msg_italian "MC(event,stop,name)"                    "Stop"

### Tool Preselect
::msgcat::mcset pb_msg_italian "MC(event,toolpreselect,name)"           "Preselezione utensile"

### Thread Wire
::msgcat::mcset pb_msg_italian "MC(event,threadwire,name)"              "Cavo filettatura"

### Cut Wire
::msgcat::mcset pb_msg_italian "MC(event,cutwire,name)"                 "Taglia cavo"

### Wire Guides
::msgcat::mcset pb_msg_italian "MC(event,wireguides,name)"              "Guide cavo"

### Linear Move
::msgcat::mcset pb_msg_italian "MC(event,linear,name)"                  "Movimento lineare"
::msgcat::mcset pb_msg_italian "MC(event,linear,g_code)"                "Codice G"
::msgcat::mcset pb_msg_italian "MC(event,linear,motion)"                "Movimento lineare"
::msgcat::mcset pb_msg_italian "MC(event,linear,assume)"                "Modalità rapida dedotta per avanzamento trasversale max"

### Circular Move
::msgcat::mcset pb_msg_italian "MC(event,circular,name)"                "Movimento circolare"
::msgcat::mcset pb_msg_italian "MC(event,circular,g_code)"              "Codice G movimento"
::msgcat::mcset pb_msg_italian "MC(event,circular,clockwise)"           "Senso orario (CW)"
::msgcat::mcset pb_msg_italian "MC(event,circular,counter-clock)"       "Senso antiorario (CW)"
::msgcat::mcset pb_msg_italian "MC(event,circular,record)"              "Record circolare"
::msgcat::mcset pb_msg_italian "MC(event,circular,full_circle)"         "Cerchio completo"
::msgcat::mcset pb_msg_italian "MC(event,circular,quadrant)"            "Quadrante"
::msgcat::mcset pb_msg_italian "MC(event,circular,ijk_def)"             "Definizione IJK"
::msgcat::mcset pb_msg_italian "MC(event,circular,ij_def)"              "Definizione IJ"
::msgcat::mcset pb_msg_italian "MC(event,circular,ik_def)"              "Definizione IK"
::msgcat::mcset pb_msg_italian "MC(event,circular,planes)"              "Piani applicabili"
::msgcat::mcset pb_msg_italian "MC(event,circular,edit_planes)"         "Modifica codici piano"
::msgcat::mcset pb_msg_italian "MC(event,circular,radius)"              "Raggio"
::msgcat::mcset pb_msg_italian "MC(event,circular,min)"                 "Minimo"
::msgcat::mcset pb_msg_italian "MC(event,circular,max)"                 "Massimo"
::msgcat::mcset pb_msg_italian "MC(event,circular,arc_len)"             "Lunghezza arco minima"

### Rapid Move
::msgcat::mcset pb_msg_italian "MC(event,rapid,name)"                   "Movimento rapido"
::msgcat::mcset pb_msg_italian "MC(event,rapid,g_code)"                 "Codice G"
::msgcat::mcset pb_msg_italian "MC(event,rapid,motion)"                 "Movimento rapido"
::msgcat::mcset pb_msg_italian "MC(event,rapid,plane_change)"           "Variazione piano di lavoro"

### Lathe Thread
::msgcat::mcset pb_msg_italian "MC(event,lathe,name)"                   "Filettatura su tornio"
::msgcat::mcset pb_msg_italian "MC(event,lathe,g_code)"                 "Codice G filettatura"
::msgcat::mcset pb_msg_italian "MC(event,lathe,cons)"                   "Costante"
::msgcat::mcset pb_msg_italian "MC(event,lathe,incr)"                   "Incrementale"
::msgcat::mcset pb_msg_italian "MC(event,lathe,decr)"                   "Decrementale"

### Cycle
::msgcat::mcset pb_msg_italian "MC(event,cycle,g_code)"                 "Codice G e personalizzazione"
::msgcat::mcset pb_msg_italian "MC(event,cycle,customize,Label)"        "Personalizza"
::msgcat::mcset pb_msg_italian "MC(event,cycle,customize,Context)"      "L'opzione consente di personalizzare un ciclo. \n\nPer impostazione predefinita, il vincolo di base è definito per ogni ciclo dalle impostazioni dei parametri comuni. Gli elementi comuni ad ogni ciclo non sono modificabili. \n\nAbilitando l'opzione, si ottiene il controllo completo della configurazione di un ciclo. Le modifiche apportate ai parametri comuni non hanno effetto su alcun ciclo personalizzato."
::msgcat::mcset pb_msg_italian "MC(event,cycle,start,Label)"            "Inizio ciclo"
::msgcat::mcset pb_msg_italian "MC(event,cycle,start,Context)"          "L'opzione può essere attivata per le macchine utensili che eseguono cicli basati su un blocco iniziale (G79...) dopo che il ciclo è stato definito (G81...)."
::msgcat::mcset pb_msg_italian "MC(event,cycle,start,text)"             "Usa Blocco iniziale ciclo per eseguire il ciclo"
::msgcat::mcset pb_msg_italian "MC(event,cycle,rapid_to)"               "Rapido - a"
::msgcat::mcset pb_msg_italian "MC(event,cycle,retract_to)"             "Stacco - a"
::msgcat::mcset pb_msg_italian "MC(event,cycle,plane_control)"          "Controllo piano del ciclo"
::msgcat::mcset pb_msg_italian "MC(event,cycle,com_param,name)"         "Parametri comuni"
::msgcat::mcset pb_msg_italian "MC(event,cycle,cycle_off,name)"         "Ciclo OFF"
::msgcat::mcset pb_msg_italian "MC(event,cycle,plane_chng,name)"        "Cambio piano del ciclo"
::msgcat::mcset pb_msg_italian "MC(event,cycle,drill,name)"             "Foratura"
::msgcat::mcset pb_msg_italian "MC(event,cycle,drill_dwell,name)"       "Sosta foratura"
::msgcat::mcset pb_msg_italian "MC(event,cycle,drill_text,name)"        "Testo foratura"
::msgcat::mcset pb_msg_italian "MC(event,cycle,drill_csink,name)"       "Esegui svasatura"
::msgcat::mcset pb_msg_italian "MC(event,cycle,drill_deep,name)"        "Foratura profonda"
::msgcat::mcset pb_msg_italian "MC(event,cycle,drill_brk_chip,name)"    "Rompi truciolo foratura"
::msgcat::mcset pb_msg_italian "MC(event,cycle,tap,name)"               "Filettatura"
::msgcat::mcset pb_msg_italian "MC(event,cycle,bore,name)"              "Alesatura"
::msgcat::mcset pb_msg_italian "MC(event,cycle,bore_dwell,name)"        "Sosta alesatura"
::msgcat::mcset pb_msg_italian "MC(event,cycle,bore_drag,name)"         "Resistenza alesatura"
::msgcat::mcset pb_msg_italian "MC(event,cycle,bore_no_drag,name)"      "Alesatura senza resistenza"
::msgcat::mcset pb_msg_italian "MC(event,cycle,bore_back,name)"         "Alesatura indietro"
::msgcat::mcset pb_msg_italian "MC(event,cycle,bore_manual,name)"       "Alesatura manuale"
::msgcat::mcset pb_msg_italian "MC(event,cycle,bore_manual_dwell,name)" "Sosta alesatura manuale"
::msgcat::mcset pb_msg_italian "MC(event,cycle,peck_drill,name)"        "Foratura profonda"
::msgcat::mcset pb_msg_italian "MC(event,cycle,break_chip,name)"        "Rompi truciolo"
::msgcat::mcset pb_msg_italian "MC(event,cycle,drill_dwell_sf,name)"    "Sosta spianatura (punto di attacco foratura)"
::msgcat::mcset pb_msg_italian "MC(event,cycle,drill_deep_peck,name)"   "Foratura profonda (profondità)"
::msgcat::mcset pb_msg_italian "MC(event,cycle,bore_ream,name)"         "Alesatura (alesatura)"
::msgcat::mcset pb_msg_italian "MC(event,cycle,bore_no-drag,name)"      "Alesatura senza resistenza"

##------------
## G Code
##
::msgcat::mcset pb_msg_italian "MC(g_code,rapid,name)"                  "Movimento rapido"
::msgcat::mcset pb_msg_italian "MC(g_code,linear,name)"                 "Movimento lineare"
::msgcat::mcset pb_msg_italian "MC(g_code,circular_clw,name)"           "Interpolazione circolare, senso orario"
::msgcat::mcset pb_msg_italian "MC(g_code,circular_cclw,name)"          "Interpolazione circolare, senso antiorario"
::msgcat::mcset pb_msg_italian "MC(g_code,delay_sec,name)"              "Ritardo (sec)"
::msgcat::mcset pb_msg_italian "MC(g_code,delay_rev,name)"              "Ritardo (rev)"
::msgcat::mcset pb_msg_italian "MC(g_code,pln_xy,name)"                 "Piano XY"
::msgcat::mcset pb_msg_italian "MC(g_code,pln_zx,name)"                 "Piano ZX"
::msgcat::mcset pb_msg_italian "MC(g_code,pln_yz,name)"                 "Piano YZ"
::msgcat::mcset pb_msg_italian "MC(g_code,cutcom_off,name)"             "Cutcom disattivo"
::msgcat::mcset pb_msg_italian "MC(g_code,cutcom_left,name)"            "Cutcom sx"
::msgcat::mcset pb_msg_italian "MC(g_code,cutcom_right,name)"           "Cutcom dx"
::msgcat::mcset pb_msg_italian "MC(g_code,length_plus,name)"            "Regola lunghezza utensile (più)"
::msgcat::mcset pb_msg_italian "MC(g_code,length_minus,name)"           "Regola lunghezza utensile (meno)"
::msgcat::mcset pb_msg_italian "MC(g_code,length_off,name)"             "Regola lunghezza utensile (inattivo)"
::msgcat::mcset pb_msg_italian "MC(g_code,inch,name)"                   "Modalità pollici"
::msgcat::mcset pb_msg_italian "MC(g_code,metric,name)"                 "Modalità sistema metrico decimale"
::msgcat::mcset pb_msg_italian "MC(g_code,cycle_start,name)"            "Codice inizio ciclo"
::msgcat::mcset pb_msg_italian "MC(g_code,cycle_off,name)"              "Ciclo OFF"
::msgcat::mcset pb_msg_italian "MC(g_code,cycle_drill,name)"            "Ciclo di foratura"
::msgcat::mcset pb_msg_italian "MC(g_code,cycle_drill_dwell,name)"      "Sosta ciclo di foratura"
::msgcat::mcset pb_msg_italian "MC(g_code,cycle_drill_deep,name)"       "Ciclo di foratura in profondità"
::msgcat::mcset pb_msg_italian "MC(g_code,cycle_drill_bc,name)"         "Ciclo di foratura rompi truciolo"
::msgcat::mcset pb_msg_italian "MC(g_code,tap,name)"                    "Ciclo di filettatura"
::msgcat::mcset pb_msg_italian "MC(g_code,bore,name)"                   "Ciclo di alesatura"
::msgcat::mcset pb_msg_italian "MC(g_code,bore_drag,name)"              "Ciclo di alesatura (con resistenza)"
::msgcat::mcset pb_msg_italian "MC(g_code,bore_no_drag,name)"           "Ciclo di alesatura (senza resistenza)"
::msgcat::mcset pb_msg_italian "MC(g_code,bore_dwell,name)"             "Sosta ciclo di alesatura"
::msgcat::mcset pb_msg_italian "MC(g_code,bore_manual,name)"            "Ciclo di alesatura manuale "
::msgcat::mcset pb_msg_italian "MC(g_code,bore_back,name)"              "Ciclo di alesatura indietro"
::msgcat::mcset pb_msg_italian "MC(g_code,bore_manual_dwell,name)"      "Sosta ciclo di alesatura manuale"
::msgcat::mcset pb_msg_italian "MC(g_code,abs,name)"                    "Modalità assoluta"
::msgcat::mcset pb_msg_italian "MC(g_code,inc,name)"                    "Modalità incrementale"
::msgcat::mcset pb_msg_italian "MC(g_code,cycle_retract_auto,name)"     "Stacco ciclo (AUTO)"
::msgcat::mcset pb_msg_italian "MC(g_code,cycle_retract_manual,name)"   "Stacco ciclo (MANUALE)"
::msgcat::mcset pb_msg_italian "MC(g_code,reset,name)"                  "Ripristino"
::msgcat::mcset pb_msg_italian "MC(g_code,fr_ipm,name)"                 "Modalità velocità di avanzamento pollici/min"
::msgcat::mcset pb_msg_italian "MC(g_code,fr_ipr,name)"                 "Modalità velocità di avanzamento pollici/giro"
::msgcat::mcset pb_msg_italian "MC(g_code,fr_frn,name)"                 "Modalità velocità di avanzamento FRN"
::msgcat::mcset pb_msg_italian "MC(g_code,spindle_css,name)"            "CSS mandrino"
::msgcat::mcset pb_msg_italian "MC(g_code,spindle_rpm,name)"            "Giri/min mandrino"
::msgcat::mcset pb_msg_italian "MC(g_code,ret_home,name)"               "Torna al punto Home"
::msgcat::mcset pb_msg_italian "MC(g_code,cons_thread,name)"            "Filettatura costante"
::msgcat::mcset pb_msg_italian "MC(g_code,incr_thread,name)"            "Filettatura incrementale"
::msgcat::mcset pb_msg_italian "MC(g_code,decr_thread,name)"            "Filettatura decrementale"
::msgcat::mcset pb_msg_italian "MC(g_code,feedmode_in,pm)"              "Modalità velocità di avanzamento pollici/min"
::msgcat::mcset pb_msg_italian "MC(g_code,feedmode_in,pr)"              "Modalità velocità di avanzamento pollici/giro"
::msgcat::mcset pb_msg_italian "MC(g_code,feedmode_mm,pm)"              "Modalità velocità di avanzamento mm/min"
::msgcat::mcset pb_msg_italian "MC(g_code,feedmode_mm,pr)"              "Modalità velocità di avanzamento mm/giro"
::msgcat::mcset pb_msg_italian "MC(g_code,feedmode,dpm)"                "DPM modalità velocità di avanzamento"

##------------
## M Code
##
::msgcat::mcset pb_msg_italian "MC(m_code,stop_manual_tc,name)"         "Stop/Cambio utensile manuale"
::msgcat::mcset pb_msg_italian "MC(m_code,stop,name)"                   "Stop"
::msgcat::mcset pb_msg_italian "MC(m_code,opt_stop,name)"               "Opstop"
::msgcat::mcset pb_msg_italian "MC(m_code,prog_end,name)"               "Fine programma"
::msgcat::mcset pb_msg_italian "MC(m_code,spindle_clw,name)"            "Mandrino ON/senso orario"
::msgcat::mcset pb_msg_italian "MC(m_code,spindle_cclw,name)"           "Mandrino senso antiorario"
::msgcat::mcset pb_msg_italian "MC(m_code,lathe_thread,type1)"          "Filettatura costante"
::msgcat::mcset pb_msg_italian "MC(m_code,lathe_thread,type2)"          "Filettatura incrementale"
::msgcat::mcset pb_msg_italian "MC(m_code,lathe_thread,type3)"          "Filettatura decrementale"
::msgcat::mcset pb_msg_italian "MC(m_code,spindle_off,name)"            "Mandrino OFF"
::msgcat::mcset pb_msg_italian "MC(m_code,tc_retract,name)"             "Cambio/Stacco utensile"
::msgcat::mcset pb_msg_italian "MC(m_code,coolant_on,name)"             "Refrigerante attivo"
::msgcat::mcset pb_msg_italian "MC(m_code,coolant_fld,name)"            "Fuoriuscita di refrigerante"
::msgcat::mcset pb_msg_italian "MC(m_code,coolant_mist,name)"           "Nebbia di refrigerante"
::msgcat::mcset pb_msg_italian "MC(m_code,coolant_thru,name)"           "Refrigerante thru"
::msgcat::mcset pb_msg_italian "MC(m_code,coolant_tap,name)"            "Refrigerante filettatura"
::msgcat::mcset pb_msg_italian "MC(m_code,coolant_off,name)"            "Refrigerante disattivo"
::msgcat::mcset pb_msg_italian "MC(m_code,rewind,name)"                 "Riavvolgi"
::msgcat::mcset pb_msg_italian "MC(m_code,thread_wire,name)"            "Cavo filetto"
::msgcat::mcset pb_msg_italian "MC(m_code,cut_wire,name)"               "Taglia cavo"
::msgcat::mcset pb_msg_italian "MC(m_code,fls_on,name)"                 "Getto ON"
::msgcat::mcset pb_msg_italian "MC(m_code,fls_off,name)"                "Getto OFF"
::msgcat::mcset pb_msg_italian "MC(m_code,power_on,name)"               "Acceso"
::msgcat::mcset pb_msg_italian "MC(m_code,power_off,name)"              "Spento"
::msgcat::mcset pb_msg_italian "MC(m_code,wire_on,name)"                "Cavo ON"
::msgcat::mcset pb_msg_italian "MC(m_code,wire_off,name)"               "Cavo OFF"
::msgcat::mcset pb_msg_italian "MC(m_code,pri_turret,name)"             "Torretta principale"
::msgcat::mcset pb_msg_italian "MC(m_code,sec_turret,name)"             "Torretta secondaria"

##------------
## UDE
##
::msgcat::mcset pb_msg_italian "MC(ude,editor,enable,Label)"            "Attiva editor UDE"
::msgcat::mcset pb_msg_italian "MC(ude,editor,enable,as_saved,Label)"   "Salvato"
::msgcat::mcset pb_msg_italian "MC(ude,editor,TITLE)"                   "Evento definito dall'utente"

::msgcat::mcset pb_msg_italian "MC(ude,editor,no_ude)"                  "Nessun UDE pertinente"

::msgcat::mcset pb_msg_italian "MC(ude,editor,int,Label)"               "Numero intero"
::msgcat::mcset pb_msg_italian "MC(ude,editor,int,Context)"             "Aggiungere un nuovo parametro numero intero trascinando il valore nell'elenco a destra."

::msgcat::mcset pb_msg_italian "MC(ude,editor,real,Label)"              "Reale"
::msgcat::mcset pb_msg_italian "MC(ude,editor,real,Context)"            "Aggiungere un nuovo parametro numero reale trascinando il valore nell'elenco a destra."

::msgcat::mcset pb_msg_italian "MC(ude,editor,txt,Label)"               "Testo"
::msgcat::mcset pb_msg_italian "MC(ude,editor,txt,Context)"             "Aggiungere un nuovo parametro stringa trascinando il valore nell'elenco a destra."

::msgcat::mcset pb_msg_italian "MC(ude,editor,bln,Label)"               "Booleano"
::msgcat::mcset pb_msg_italian "MC(ude,editor,bln,Context)"             "Aggiungere un nuovo parametro booleano trascinando il valore nell'elenco a destra."

::msgcat::mcset pb_msg_italian "MC(ude,editor,opt,Label)"               "Opzione"
::msgcat::mcset pb_msg_italian "MC(ude,editor,opt,Context)"             "Aggiungere un nuovo parametro di opzione trascinando il valore nell'elenco a destra."

::msgcat::mcset pb_msg_italian "MC(ude,editor,pnt,Label)"               "Punto"
::msgcat::mcset pb_msg_italian "MC(ude,editor,pnt,Context)"             "Aggiungere un nuovo parametro di opzione trascinando il valore nell'elenco a destra."

::msgcat::mcset pb_msg_italian "MC(ude,editor,trash,Label)"             "Editor -- cestino"
::msgcat::mcset pb_msg_italian "MC(ude,editor,trash,Context)"           "I parametri da eliminare dall'elenco sulla destra possono essere trascinati nel cestino."

::msgcat::mcset pb_msg_italian "MC(ude,editor,event,Label)"             "Evento"
::msgcat::mcset pb_msg_italian "MC(ude,editor,event,Context)"           "Per modificare i parametri dell'evento, usare il pulsante MB1 del mouse."

::msgcat::mcset pb_msg_italian "MC(ude,editor,param,Label)"             "Evento -- parametri"
::msgcat::mcset pb_msg_italian "MC(ude,editor,param,Context)"           "Modificare i parametri facendo clic sul pulsante destro del mouse oppure modificare l'ordine dei parametri con un'operazione Trascina e rilascia.\n \nIl parametro azzurro è definito dal sistema e non può essere eliminato. \nIl parametro color nocciola non è definito dal sistema e può quindi essere modificato o eliminato."

::msgcat::mcset pb_msg_italian "MC(ude,editor,param,edit,Label)"        "Parametri -- opzioni"
::msgcat::mcset pb_msg_italian "MC(ude,editor,param,edit,Context)"      "Fare clic sul pulsante destro del mouse per selezionare l'opzione predefinita.\n Fare doppio clic sul pulsante destro del mouse per modificare questa opzione."
::msgcat::mcset pb_msg_italian "MC(ude,editor,param,editor,Label)"      "Tipo parametro: "

::msgcat::mcset pb_msg_italian "MC(ude,editor,pnt,sel,Label)"           "Seleziona"
::msgcat::mcset pb_msg_italian "MC(ude,editor,pnt,dsp,Label)"           "Visualizza"

::msgcat::mcset pb_msg_italian "MC(ude,editor,dlg,ok,Label)"            "OK"
::msgcat::mcset pb_msg_italian "MC(ude,editor,dlg,bck,Label)"           "Indietro"
::msgcat::mcset pb_msg_italian "MC(ude,editor,dlg,cnl,Label)"           "Annulla"

::msgcat::mcset pb_msg_italian "MC(ude,editor,paramdlg,PL,Label)"       "Etichetta parametro"
::msgcat::mcset pb_msg_italian "MC(ude,editor,paramdlg,VN,Label)"       "Nome variabile"
::msgcat::mcset pb_msg_italian "MC(ude,editor,paramdlg,DF,Label)"       "Valore predefinito"
::msgcat::mcset pb_msg_italian "MC(ude,editor,paramdlg,PL,Context)"     "Specificare l'etichetta parametro"
::msgcat::mcset pb_msg_italian "MC(ude,editor,paramdlg,VN,Context)"     "Specificare il nome della variabile"
::msgcat::mcset pb_msg_italian "MC(ude,editor,paramdlg,DF,Context)"     "Specificare il valore predefinito"
::msgcat::mcset pb_msg_italian "MC(ude,editor,paramdlg,TG)"             "Attiva/Disattiva"
::msgcat::mcset pb_msg_italian "MC(ude,editor,paramdlg,TG,B,Label)"     "Attiva/Disattiva"
::msgcat::mcset pb_msg_italian "MC(ude,editor,paramdlg,TG,B,Context)"   "Selezionare il valore di attivazione"
::msgcat::mcset pb_msg_italian "MC(ude,editor,paramdlg,ON,Label)"       "ON"
::msgcat::mcset pb_msg_italian "MC(ude,editor,paramdlg,OFF,Label)"      "OFF"
::msgcat::mcset pb_msg_italian "MC(ude,editor,paramdlg,ON,Context)"     "Selezionare ON come valore predefinito"
::msgcat::mcset pb_msg_italian "MC(ude,editor,paramdlg,OFF,Context)"    "Selezionare OFF come valore predefinito"
::msgcat::mcset pb_msg_italian "MC(ude,editor,paramdlg,OL)"             "Elenco di opzioni"
::msgcat::mcset pb_msg_italian "MC(ude,editor,paramdlg,ADD,Label)"      "Aggiungi"
::msgcat::mcset pb_msg_italian "MC(ude,editor,paramdlg,CUT,Label)"      "Taglio"
::msgcat::mcset pb_msg_italian "MC(ude,editor,paramdlg,PASTE,Label)"    "Incolla"
::msgcat::mcset pb_msg_italian "MC(ude,editor,paramdlg,ADD,Context)"    "Aggiungi un oggetto"
::msgcat::mcset pb_msg_italian "MC(ude,editor,paramdlg,CUT,Context)"    "Taglia un oggetto"
::msgcat::mcset pb_msg_italian "MC(ude,editor,paramdlg,PASTE,Context)"  "Incolla un oggetto"
::msgcat::mcset pb_msg_italian "MC(ude,editor,paramdlg,ENTRY,Label)"    "Opzione"
::msgcat::mcset pb_msg_italian "MC(ude,editor,paramdlg,ENTRY,Context)"  "Apri un oggetto"
::msgcat::mcset pb_msg_italian "MC(ude,editor,eventdlg,EN,Label)"       "Nome evento"
::msgcat::mcset pb_msg_italian "MC(ude,editor,eventdlg,EN,Context)"     "Specifica il nome evento"
::msgcat::mcset pb_msg_italian "MC(ude,editor,eventdlg,PEN,Label)"      "Nome post"
::msgcat::mcset pb_msg_italian "MC(ude,editor,eventdlg,PEN,Context)"    "Specifica il nome post"
::msgcat::mcset pb_msg_italian "MC(ude,editor,eventdlg,PEN,C,Label)"    "Nome post"
::msgcat::mcset pb_msg_italian "MC(ude,editor,eventdlg,PEN,C,Context)"  "L'opzione consente di impostare il nome post"
::msgcat::mcset pb_msg_italian "MC(ude,editor,eventdlg,EL,Label)"       "Etichetta evento"
::msgcat::mcset pb_msg_italian "MC(ude,editor,eventdlg,EL,Context)"     "Specificare l'etichetta evento"
::msgcat::mcset pb_msg_italian "MC(ude,editor,eventdlg,EL,C,Label)"     "Etichetta evento"
::msgcat::mcset pb_msg_italian "MC(ude,editor,eventdlg,EL,C,Context)"   "L'opzione consente di impostare l'etichetta evento"

::msgcat::mcset pb_msg_italian "MC(ude,editor,eventdlg,EC,Label)"           "Categoria"
::msgcat::mcset pb_msg_italian "MC(ude,editor,eventdlg,EC,Context)"         "L'opzione consente di impostare la categoria"
::msgcat::mcset pb_msg_italian "MC(ude,editor,eventdlg,EC_MILL,Label)"      "Fresatura"
::msgcat::mcset pb_msg_italian "MC(ude,editor,eventdlg,EC_DRILL,Label)"     "Foratura"
::msgcat::mcset pb_msg_italian "MC(ude,editor,eventdlg,EC_LATHE,Label)"     "Tornitura"
::msgcat::mcset pb_msg_italian "MC(ude,editor,eventdlg,EC_WEDM,Label)"      "Elettroerosione a filo"
::msgcat::mcset pb_msg_italian "MC(ude,editor,eventdlg,EC_MILL,Context)"    "Imposta categoria di fresatura"
::msgcat::mcset pb_msg_italian "MC(ude,editor,eventdlg,EC_DRILL,Context)"   "Imposta categoria di foratura"
::msgcat::mcset pb_msg_italian "MC(ude,editor,eventdlg,EC_LATHE,Context)"   "Imposta categoria di tornitura"
::msgcat::mcset pb_msg_italian "MC(ude,editor,eventdlg,EC_WEDM,Context)"    "Imposta categoria di elettroerosione a filo"

::msgcat::mcset pb_msg_italian "MC(ude,editor,EDIT)"                    "Modifica evento"
::msgcat::mcset pb_msg_italian "MC(ude,editor,CREATE)"                  "Crea evento di controllo macchina"
::msgcat::mcset pb_msg_italian "MC(ude,editor,popup,HELP)"              "Guida"
::msgcat::mcset pb_msg_italian "MC(ude,editor,popup,EDIT)"              "Modifica i parametri definiti dall'utente..."
::msgcat::mcset pb_msg_italian "MC(ude,editor,param,EDIT)"              "Modifica..."
::msgcat::mcset pb_msg_italian "MC(ude,editor,param,VIEW)"              "Visualizza..."
::msgcat::mcset pb_msg_italian "MC(ude,editor,popup,DELETE)"            "Elimina"
::msgcat::mcset pb_msg_italian "MC(ude,editor,popup,CREATE)"            "Crea un nuovo evento di controllo macchina..."
::msgcat::mcset pb_msg_italian "MC(ude,editor,popup,IMPORT)"            "Importa eventi di controllo macchina..."
::msgcat::mcset pb_msg_italian "MC(ude,editor,popup,MSG_BLANK)"         "Il nome evento non può essere vuoto."
::msgcat::mcset pb_msg_italian "MC(ude,editor,popup,MSG_SAMENAME)"      "Il nome evento esiste."
::msgcat::mcset pb_msg_italian "MC(ude,editor,popup,MSG_SameHandler)"   "L'handler di eventi esiste già. \nModificare il nome dell'evento o del post, se selezionato."
::msgcat::mcset pb_msg_italian "MC(ude,validate)"                       "L'evento non contiene parametri."
::msgcat::mcset pb_msg_italian "MC(ude,prev,tab,Label)"                 "Eventi definiti da utente"
::msgcat::mcset pb_msg_italian "MC(ude,prev,ude,Label)"                 "Eventi di controllo macchine"
::msgcat::mcset pb_msg_italian "MC(ude,prev,udc,Label)"                 "Cicli definiti dall'utente"
::msgcat::mcset pb_msg_italian "MC(ude,prev,mc,Label)"                  "Eventi di controllo macchina definiti dal sistema"
::msgcat::mcset pb_msg_italian "MC(ude,prev,nmc,Label)"                 "Eventi di controllo macchina non definiti dal sistema"
::msgcat::mcset pb_msg_italian "MC(udc,prev,sys,Label)"                 "Cicli di sistema"
::msgcat::mcset pb_msg_italian "MC(udc,prev,nsys,Label)"                "Cicli non di sistema"
::msgcat::mcset pb_msg_italian "MC(ude,prev,Status)"                    "Selezionare l'oggetto da definire"
::msgcat::mcset pb_msg_italian "MC(ude,editor,opt,MSG_BLANK)"           "La stringa di opzione non può essere vuota."
::msgcat::mcset pb_msg_italian "MC(ude,editor,opt,MSG_SAME)"            "La stringa di opzione esiste già."
::msgcat::mcset pb_msg_italian "MC(ude,editor,opt,MSG_PST_SAME)"        "L'opzione che è stata incollata esiste già."
::msgcat::mcset pb_msg_italian "MC(ude,editor,opt,MSG_IDENTICAL)"       "Alcune opzioni sono identiche."
::msgcat::mcset pb_msg_italian "MC(ude,editor,opt,NO_OPT)"              "L'elenco non contiene opzioni."
::msgcat::mcset pb_msg_italian "MC(ude,editor,param,MSG_NO_VNAME)"      "Il nome della variabile non può essere vuoto."
::msgcat::mcset pb_msg_italian "MC(ude,editor,param,MSG_EXIST_VNAME)"   "Esiste già una variabile con questo nome."
::msgcat::mcset pb_msg_italian "MC(ude,editor,spindle_css,INFO)"        "L'evento condivide l'UDE con \"Mandrino giri/min\""
::msgcat::mcset pb_msg_italian "MC(ude,import,ihr,Label)"               "Eredita UDE dal post A"

::msgcat::mcset pb_msg_italian "MC(ude,import,ihr,Context)"             "L'opzione consente al post di ereditare la definizione IDE e gli handler corrispondenti."

::msgcat::mcset pb_msg_italian "MC(ude,import,sel,Label)"               "Seleziona post"

::msgcat::mcset pb_msg_italian "MC(ude,import,sel,Context)"             "Selezionare il file PUI del post. Si consiglia di inserire tutti i file (PUI, Def, Tcl e CDL) associati al post ereditato nella stessa directory (cartella) per l'uso."

::msgcat::mcset pb_msg_italian "MC(ude,import,name_cdl,Label)"          "Nome file CDL"

::msgcat::mcset pb_msg_italian "MC(ude,import,name_cdl,Context)"        "Il nome file e del percorso del file CDL associato al post selezionato che viene referenziato (INCLUDE) dal file di definizione del post. Il nome del percorso può iniziare con una variabile di ambiente UG (\\\$UGII). Se non viene specificato un percorso, UG/NX usa la variabile UGII_CAM_FILE_SEARCH_PATH per individuare il file durante l'esecuzione.  "

::msgcat::mcset pb_msg_italian "MC(ude,import,name_def,Label)"          "Nome file di definizione"
::msgcat::mcset pb_msg_italian "MC(ude,import,name_def,Context)"        "Il nome file e del percorso del file di definizione del post selezionato che viene referenziato (INCLUDE) dal file di definizione del post. Il nome del percorso può iniziare con una variabile di ambiente UG (\\\$UGII). Se non viene specificato un percorso, UG/NX usa la variabile UGII_CAM_FILE_SEARCH_PATH per individuare il file durante l'esecuzione. "

::msgcat::mcset pb_msg_italian "MC(ude,import,include_cdl,Label)"       "CDL"
::msgcat::mcset pb_msg_italian "MC(ude,import,ihr_pst,Label)"           "Post"
::msgcat::mcset pb_msg_italian "MC(ude,import,ihr_folder,Label)"        "Cartella"
::msgcat::mcset pb_msg_italian "MC(ude,import,own_folder,Label)"        "Cartella"
::msgcat::mcset pb_msg_italian "MC(ude,import,own,Label)"               "Includere il proprio file CDL"

::msgcat::mcset pb_msg_italian "MC(ude,import,own,Context)"             "L'opzione abilita il post consentendo di includere il riferimento al proprio file CDL nel file di definizione."

::msgcat::mcset pb_msg_italian "MC(ude,import,own_ent,Label)"           "File di proprietà CDL"

::msgcat::mcset pb_msg_italian "MC(ude,import,own_ent,Context)"         "Il nome file e del percorso del file CDL associato a questo post e referenziato (INCLUDE) dal file di definizione del post. Il nome effettivo del percorso viene determinato al momento del salvataggio del post. Il nome del percorso può iniziare con una variabile di ambiente UG (\\\$UGII). Se non viene specificato un percorso, UG/NX usa la variabile UGII_CAM_FILE_SEARCH_PATH per individuare il file durante l'esecuzione. "

::msgcat::mcset pb_msg_italian "MC(ude,import,sel,pui,status)"          "Seleziona file PUI"
::msgcat::mcset pb_msg_italian "MC(ude,import,sel,cdl,status)"          "Seleziona file CDL"

##---------
## UDC
##
::msgcat::mcset pb_msg_italian "MC(udc,editor,TITLE)"                   "Ciclo definito dall'utente"
::msgcat::mcset pb_msg_italian "MC(udc,editor,CREATE)"                  "Crea ciclo definito dall'utente"
::msgcat::mcset pb_msg_italian "MC(udc,editor,TYPE)"                    "Tipo di ciclo"
::msgcat::mcset pb_msg_italian "MC(udc,editor,type,UDC)"                "Definito da utente"
::msgcat::mcset pb_msg_italian "MC(udc,editor,type,SYSUDC)"             "Definito dal sistema"
::msgcat::mcset pb_msg_italian "MC(udc,editor,CYCLBL,Label)"            "Etichetta ciclo"
::msgcat::mcset pb_msg_italian "MC(udc,editor,CYCNAME,Label)"           "Nome ciclo"
::msgcat::mcset pb_msg_italian "MC(udc,editor,CYCLBL,Context)"          "Specificare etichetta ciclo"
::msgcat::mcset pb_msg_italian "MC(udc,editor,CYCNAME,Context)"         "Specificare nome ciclo"
::msgcat::mcset pb_msg_italian "MC(udc,editor,CYCLBL,C,Label)"          "Etichetta ciclo"
::msgcat::mcset pb_msg_italian "MC(udc,editor,CYCLBL,C,Context)"        "L'opzione consente di impostare l'etichetta ciclo"
::msgcat::mcset pb_msg_italian "MC(udc,editor,popup,EDIT)"              "Modifica i parametri definiti dall'utente..."
::msgcat::mcset pb_msg_italian "MC(udc,editor,popup,MSG_BLANK)"         "Il nome ciclo non può essere vuoto."
::msgcat::mcset pb_msg_italian "MC(udc,editor,popup,MSG_SAMENAME)"      "Il nome ciclo esiste già."
::msgcat::mcset pb_msg_italian "MC(udc,editor,popup,MSG_SameHandler)"   "Questo handler di eventi esiste già.\nModificare il nome evento ciclo."
::msgcat::mcset pb_msg_italian "MC(udc,editor,popup,MSG_ISSYSCYC)"      "Il nome ciclo appartiene al tipo Ciclo di sistema."
::msgcat::mcset pb_msg_italian "MC(udc,editor,popup,MSG_SYSCYC_EXIST)"  "Questo tipo di Ciclo di sistema esiste già."
::msgcat::mcset pb_msg_italian "MC(udc,editor,EDIT)"                    "Modifica evento ciclo"
::msgcat::mcset pb_msg_italian "MC(udc,editor,popup,CREATE)"            "Crea nuovo ciclo definito dall'utente..."
::msgcat::mcset pb_msg_italian "MC(udc,editor,popup,IMPORT)"            "Importa cicli definiti dall'utente..."
::msgcat::mcset pb_msg_italian "MC(udc,drill,csink,INFO)"               "L'evento condivide il gestore con la foratura."
::msgcat::mcset pb_msg_italian "MC(udc,drill,simulate,INFO)"            "L'evento è un tipo di cicli simulati."
::msgcat::mcset pb_msg_italian "MC(udc,drill,dwell,INFO)"               "L'evento condivide il ciclo definito dall'utente con "


#######
# IS&V
#######
::msgcat::mcset pb_msg_italian "MC(isv,tab,label)"                      "Controller NC virtuale"
::msgcat::mcset pb_msg_italian "MC(isv,Status)"                         "Specificare i parametri di ISV"
::msgcat::mcset pb_msg_italian "MC(isv,review,Status)"                  "Revisione i comandi VNC"

::msgcat::mcset pb_msg_italian "MC(isv,setup,Label)"                    "Configurazione"
::msgcat::mcset pb_msg_italian "MC(isv,vnc_command,Label)"              "Comandi VNC"
####################
# General Definition
####################
::msgcat::mcset pb_msg_italian "MC(isv,select_Main)"                    "Selezionare il file VNC master di un VNC subordinato."
::msgcat::mcset pb_msg_italian "MC(isv,setup,machine,Label)"            "Macchina utensile"
::msgcat::mcset pb_msg_italian "MC(isv,setup,component,Label)"          "Montaggio utensile"
::msgcat::mcset pb_msg_italian "MC(isv,setup,mac_zcs_frame,Label)"      "Riferimento allo zero programma"
::msgcat::mcset pb_msg_italian "MC(isv,setup,mac_zcs,Label)"            "Componente"
::msgcat::mcset pb_msg_italian "MC(isv,setup,mac_zcs,Context)"          "Specificare un componente come base del riferimento ZCS. Scegliere un componente non di rotazione a cui la parte viene collegata direttamente o indirettamente nella struttura ad albero di cinematica."
::msgcat::mcset pb_msg_italian "MC(isv,setup,spin_com,Label)"           "Componente"
::msgcat::mcset pb_msg_italian "MC(isv,setup,spin_com,Context)"         "Specificare un componente su cui verranno montati gli utensili. Scegliere il componente mandrino per un post di fresatura e il componente torretta per un post di tornitura."

::msgcat::mcset pb_msg_italian "MC(isv,setup,spin_jct,Label)"           "Giunzione"
::msgcat::mcset pb_msg_italian "MC(isv,setup,spin_jct,Context)"         "Definire una giunzione su cui montare gli utensili. Scegliere la giunzione al centro della faccia mandrino per un post di fresatura, la giunzione torretta di rotazione per un post di tornitura oppure la giunzione di montaggio utensile, se la torretta è fissa."

::msgcat::mcset pb_msg_italian "MC(isv,setup,axis_name,Label)"          "Asse specificato sulla macchina utensile"
::msgcat::mcset pb_msg_italian "MC(isv,setup,axis_name,Context)"        "Specificare i nomi asse da abbinare alla configurazione di cinematica della macchina utensile."




::msgcat::mcset pb_msg_italian "MC(isv,setup,axis_frm,Label)"           "Nomi asse NC"
::msgcat::mcset pb_msg_italian "MC(isv,setup,rev_fourth,Label)"         "Rotazione inversa"
::msgcat::mcset pb_msg_italian "MC(isv,setup,rev_fourth,Context)"       "Specificare la direzione di rotazione dell'asse. Può essere normale oppure invertita. L'opzione si applica solo alle tavole di rotazione."
::msgcat::mcset pb_msg_italian "MC(isv,setup,rev_fifth,Label)"          "Rotazione inversa"

::msgcat::mcset pb_msg_italian "MC(isv,setup,fourth_limit,Label)"       "Limite di rotazione"
::msgcat::mcset pb_msg_italian "MC(isv,setup,fourth_limit,Context)"     "Specificare se questo asse di rotazione ha limiti"
::msgcat::mcset pb_msg_italian "MC(isv,setup,fifth_limit,Label)"        "Limite di rotazione"
::msgcat::mcset pb_msg_italian "MC(isv,setup,limiton,Label)"            "Sì"
::msgcat::mcset pb_msg_italian "MC(isv,setup,limitoff,Label)"           "No"
::msgcat::mcset pb_msg_italian "MC(isv,setup,fourth_table,Label)"       "Quarto asse"
::msgcat::mcset pb_msg_italian "MC(isv,setup,fifth_table,Label)"        "Quinto asse"
::msgcat::mcset pb_msg_italian "MC(isv,setup,header,Label)"             " Tavola "
::msgcat::mcset pb_msg_italian "MC(isv,setup,intialization,Label)"      "Controller"
::msgcat::mcset pb_msg_italian "MC(isv,setup,general_def,Label)"        "Impostazione iniziale"
::msgcat::mcset pb_msg_italian "MC(isv,setup,advanced_def,Label)"       "Altre opzioni"
::msgcat::mcset pb_msg_italian "MC(isv,setup,InputOutput,Label)"        "Codici speciali NC"

::msgcat::mcset pb_msg_italian "MC(isv,setup,program,Label)"            "Definizione programma predefinito"
::msgcat::mcset pb_msg_italian "MC(isv,setup,output,Label)"             "Esporta definizione programma"
::msgcat::mcset pb_msg_italian "MC(isv,setup,output,Context)"           "Salva definizione programma in un file"
::msgcat::mcset pb_msg_italian "MC(isv,setup,input,Label)"              "Importa definizione programma"
::msgcat::mcset pb_msg_italian "MC(isv,setup,input,Context)"            "Carica nuovo definizione programma da file"
::msgcat::mcset pb_msg_italian "MC(isv,setup,file_err,Msg)"             "Il file selezionato non corrisponde al tipo di file di definizione programma predefinito. Continuare?"
::msgcat::mcset pb_msg_italian "MC(isv,setup,wcs,Label)"                "Offset attrezzo"
::msgcat::mcset pb_msg_italian "MC(isv,setup,tool,Label)"               "Dati utensile"
::msgcat::mcset pb_msg_italian "MC(isv,setup,g_code,Label)"             "Codice G speciale"
::msgcat::mcset pb_msg_italian "MC(isv,setup,special_vnc,Label)"        "Codice NC speciale"

::msgcat::mcset pb_msg_italian "MC(isv,setup,initial,frame,Label)"      ""
::msgcat::mcset pb_msg_italian "MC(isv,setup,initial_motion,Label)"     "Movimento"
::msgcat::mcset pb_msg_italian "MC(isv,setup,initial_motion,Context)"   "Specificare il movimento iniziale della macchina utensile"

::msgcat::mcset pb_msg_italian "MC(isv,setup,spindle,frame,Label)"      "Mandrino"
::msgcat::mcset pb_msg_italian "MC(isv,setup,spindle_mode,Label)"       "Modalità"
::msgcat::mcset pb_msg_italian "MC(isv,setup,spindle_direction,Label)"  "Direzione"
::msgcat::mcset pb_msg_italian "MC(isv,setup,spindle,frame,Context)"    "Specificare l'unità di misura della velocità iniziale mandrino e la direzione di rotazione"

::msgcat::mcset pb_msg_italian "MC(isv,setup,feedrate_mode,Label)"      "Modalità Velocità di avanzamento"
::msgcat::mcset pb_msg_italian "MC(isv,setup,feedrate_mode,Context)"    "Specificare l'unità di misura della velocità di avanzamento iniziale "

::msgcat::mcset pb_msg_italian "MC(isv,setup,boolean,frame,Label)"      "Definizione booleano"
::msgcat::mcset pb_msg_italian "MC(isv,setup,power_on_wcs,Label)"       "Attiva il sistema di coordinate di lavoro  "
::msgcat::mcset pb_msg_italian "MC(isv,setup,power_on_wcs,Context)"     "0 indica la coordinata di zero macchina predefinita usare\n 1 indica l'offset del primo attrezzo definito dall'utente (coordinate di lavoro) "

::msgcat::mcset pb_msg_italian "MC(isv,setup,use_s_leader,Label)"       "S usato"
::msgcat::mcset pb_msg_italian "MC(isv,setup,use_f_leader,Label)"       "F usato"


::msgcat::mcset pb_msg_italian "MC(isv,setup,dog_leg,Label)"            "Dogleg rapido"
::msgcat::mcset pb_msg_italian "MC(isv,setup,dog_leg,Context)"          "L'opzione ON consente di eseguire movimenti trasversali rapidi in forma di zeta, l'opzione OFF consente di eseguire movimenti trasversali rapidi seguendo il codice NC (punto a punto)."

::msgcat::mcset pb_msg_italian "MC(isv,setup,dog_leg,yes)"              "Sì"
::msgcat::mcset pb_msg_italian "MC(isv,setup,dog_leg,no)"               "No"

::msgcat::mcset pb_msg_italian "MC(isv,setup,on_off_frame,Label)"       "Definizione ON/OFF"
::msgcat::mcset pb_msg_italian "MC(isv,setup,stroke_limit,Label)"       "Limite corsa"
::msgcat::mcset pb_msg_italian "MC(isv,setup,cutcom,Label)"             "Cutcom"
::msgcat::mcset pb_msg_italian "MC(isv,setup,tl_adjust,Label)"          "Regola lunghezza utensile"
::msgcat::mcset pb_msg_italian "MC(isv,setup,scale,Label)"              "Scala"
::msgcat::mcset pb_msg_italian "MC(isv,setup,macro_modal,Label)"        "Modale macro"
::msgcat::mcset pb_msg_italian "MC(isv,setup,wcs_rotate,Label)"         "Rotazione sistema di coordinate di lavoro"
::msgcat::mcset pb_msg_italian "MC(isv,setup,cycle,Label)"              "Ciclo"

::msgcat::mcset pb_msg_italian "MC(isv,setup,initial_mode,frame,Label)"     "Inserisci modalità"
::msgcat::mcset pb_msg_italian "MC(isv,setup,initial_mode,frame,Context)"   "Specificare la modalità di input iniziale scegliendo tra assoluta o incrementale"

###################
# Input/Out Related
###################
::msgcat::mcset pb_msg_italian "MC(isv,sign_define,frame,Label)"        ""
::msgcat::mcset pb_msg_italian "MC(isv,sign_define,rewindstop,Label)"   "Codice stop/riavvolgi"
::msgcat::mcset pb_msg_italian "MC(isv,sign_define,rewindstop,Context)" "Specificare il codice stop/riavvolgi"

::msgcat::mcset pb_msg_italian "MC(isv,control_var,frame,Label)"        "Variabili di controllo"

::msgcat::mcset pb_msg_italian "MC(isv,sign_define,convarleader,Label)"     "Inizio"
::msgcat::mcset pb_msg_italian "MC(isv,sign_define,convarleader,Context)"   "Specificare la variabile del controller"
::msgcat::mcset pb_msg_italian "MC(isv,sign_define,conequ,Label)"           "Segno di uguale"
::msgcat::mcset pb_msg_italian "MC(isv,sign_define,conequ,Context)"         "Specificare il segno di uguale di controllo"
::msgcat::mcset pb_msg_italian "MC(isv,sign_define,percent,Label)"          "Segno di percentuale %"
::msgcat::mcset pb_msg_italian "MC(isv,sign_define,leaderjing,Label)"       "Acuto #"
::msgcat::mcset pb_msg_italian "MC(isv,sign_define,text_string,Label)"      "Stringa di testo"

::msgcat::mcset pb_msg_italian "MC(isv,inputmode,frame,Label)"          ""
::msgcat::mcset pb_msg_italian "MC(isv,input_mode,Label)"               "Modalità iniziale"
::msgcat::mcset pb_msg_italian "MC(isv,absolute_mode,Label)"            "Assoluto"
::msgcat::mcset pb_msg_italian "MC(isv,incremental_style,frame,Label)"  "Modalità incrementale"

::msgcat::mcset pb_msg_italian "MC(isv,incremental_mode,Label)"         "Incrementale"
::msgcat::mcset pb_msg_italian "MC(isv,incremental_gcode,Label)"        "Codice G"
::msgcat::mcset pb_msg_italian "MC(isv,incremental_gcode,Context)"      "Usare G90 o G91 per distinguere tra la modalità assoluta o incrementale"
::msgcat::mcset pb_msg_italian "MC(isv,incremental_uvw,Label)"          "Inizio speciale"
::msgcat::mcset pb_msg_italian "MC(isv,incremental_uvw,Context)"        "Usando un inizio speciale, si può distinguere tra la modalità assoluta e incrementale. Ad esempio: l'inizio X, Y o Z si riferisce alla modalità assoluta, mentre l'inizio U, V o W fa riferimento alla modalità incrementale."
::msgcat::mcset pb_msg_italian "MC(isv,incr_x,Label)"                   "X "
::msgcat::mcset pb_msg_italian "MC(isv,incr_y,Label)"                   "Y "
::msgcat::mcset pb_msg_italian "MC(isv,incr_z,Label)"                   "Z "
::msgcat::mcset pb_msg_italian "MC(isv,incr_a,Label)"                   "Quarto asse "
::msgcat::mcset pb_msg_italian "MC(isv,incr_b,Label)"                   "Quinto asse "

::msgcat::mcset pb_msg_italian "MC(isv,incr_x,Context)"                 "Specificare l'inizio speciale usato nello stile incrementale per l'asse X"
::msgcat::mcset pb_msg_italian "MC(isv,incr_y,Context)"                 "Specificare l'inizio speciale usato nello stile incrementale per l'asse Y"
::msgcat::mcset pb_msg_italian "MC(isv,incr_z,Context)"                 "Specificare l'inizio speciale usato nello stile incrementale per l'asse Z"
::msgcat::mcset pb_msg_italian "MC(isv,incr_a,Context)"                 "Specificare l'inizio speciale usato per il quarto asse nello stile incrementale"
::msgcat::mcset pb_msg_italian "MC(isv,incr_b,Context)"                 "Specificare l'inizio speciale usato per il quinto asse nello stile incrementale"
::msgcat::mcset pb_msg_italian "MC(isv,vnc_mes,frame,Label)"            "Messaggio VNC di output"

::msgcat::mcset pb_msg_italian "MC(isv,vnc_message,Label)"              "Elenca messaggi VNC"
::msgcat::mcset pb_msg_italian "MC(isv,vnc_message,Context)"            "Selezionando l'opzione, tutti i messaggi di messa a punto VNC vengono visualizzati nella finestra di messaggi operazione durante la simulazione."

::msgcat::mcset pb_msg_italian "MC(isv,vnc_mes,prefix,Label)"           "Prefisso messaggio"
::msgcat::mcset pb_msg_italian "MC(isv,spec_desc,Label)"                "Descrizione"
::msgcat::mcset pb_msg_italian "MC(isv,spec_codelist,Label)"            "Elenco di codici"
::msgcat::mcset pb_msg_italian "MC(isv,spec_nccode,Label)"              "Stringa/Codice NC"

################
# WCS Definition
################
::msgcat::mcset pb_msg_italian "MC(isv,machine_zero,offset,Label)"      "Offset dello zero macchina dalla\ngiunzione zero macchina utensile"
::msgcat::mcset pb_msg_italian "MC(isv,wcs_offset,frame,Label)"         "Offset attrezzi"
::msgcat::mcset pb_msg_italian "MC(isv,wcs_leader,Label)"               " Codice "
::msgcat::mcset pb_msg_italian "MC(isv,wcs_number,Label)"               "    "
::msgcat::mcset pb_msg_italian "MC(isv,wcs_offset,origin_x,Label)"      " Offset X  "
::msgcat::mcset pb_msg_italian "MC(isv,wcs_offset,origin_y,Label)"      " Offset Y  "
::msgcat::mcset pb_msg_italian "MC(isv,wcs_offset,origin_z,Label)"      " Offset Z  "
::msgcat::mcset pb_msg_italian "MC(isv,wcs_offset,a_offset,Label)"      " Offset A  "
::msgcat::mcset pb_msg_italian "MC(isv,wcs_offset,b_offset,Label)"      " Offset B  "
::msgcat::mcset pb_msg_italian "MC(isv,wcs_offset,c_offset,Label)"      " Offset C  "
::msgcat::mcset pb_msg_italian "MC(isv,wcs_offset,wcs_num,Label)"       "Sistema di coordinate"
::msgcat::mcset pb_msg_italian "MC(isv,wcs_offset,wcs_num,Context)"     "Specificare il valore dell'offset attrezzo da aggiungere"
::msgcat::mcset pb_msg_italian "MC(isv,wcs_offset,wcs_add,Label)"       "Aggiungi"
::msgcat::mcset pb_msg_italian "MC(isv,wcs_offset,wcs_add,Context)"     "Aggiungere un sistema di coordinate per l'offset dell'attrezzo e specificarne la posizione"
::msgcat::mcset pb_msg_italian "MC(isv,wcs_offset,wcs_err,Msg)"         "Questo numero di sistema di coordinate è già stato usato."
::msgcat::mcset pb_msg_italian "MC(isv,tool_info,frame,Label)"          "Informazioni utensile"
::msgcat::mcset pb_msg_italian "MC(isv,tool_info,tool_entry,Label)"     "Inserire un nuovo nome utensile"
::msgcat::mcset pb_msg_italian "MC(isv,tool_info,tool_name,Label)"      "       Nome       "

::msgcat::mcset pb_msg_italian "MC(isv,tool_info,tool_num,Label)"       " Utensile "
::msgcat::mcset pb_msg_italian "MC(isv,tool_info,add_tool,Label)"       "Aggiungi"
::msgcat::mcset pb_msg_italian "MC(isv,tool_info,tool_diameter,Label)"  " Diametro   "
::msgcat::mcset pb_msg_italian "MC(isv,tool_info,offset_usder,Label)"   "   Offset punte   "
::msgcat::mcset pb_msg_italian "MC(isv,tool_info,carrier_id,Label)"     " ID supporto "
::msgcat::mcset pb_msg_italian "MC(isv,tool_info,pocket_id,Label)"      " ID tasca "
::msgcat::mcset pb_msg_italian "MC(isv,tool_info,cutcom_reg,Label)"     "     CUTCOM     "
::msgcat::mcset pb_msg_italian "MC(isv,tool_info,cutreg,Label)"         "Registra "
::msgcat::mcset pb_msg_italian "MC(isv,tool_info,cutval,Label)"         "Offset "
::msgcat::mcset pb_msg_italian "MC(isv,tool_info,adjust_reg,Label)"     " Regolazione lunghezza "
::msgcat::mcset pb_msg_italian "MC(isv,tool_info,tool_type,Label)"      "   Tipo   "
::msgcat::mcset pb_msg_italian "MC(isv,prog,setup,Label)"               "Definizione programma predefinito"
::msgcat::mcset pb_msg_italian "MC(isv,prog,setup_right,Label)"         "Definizione programma"
::msgcat::mcset pb_msg_italian "MC(isv,output,setup_data,Label)"        "Specificare il file di definizione del programma"
::msgcat::mcset pb_msg_italian "MC(isv,input,setup_data,Label)"         "Selezionare il file di definizione del programma"

::msgcat::mcset pb_msg_italian "MC(isv,tool_info,toolnum,Label)"        "Numero utensile  "
::msgcat::mcset pb_msg_italian "MC(isv,tool_info,toolnum,Context)"      "Specificare il numero dell'utensile da aggiungere"
::msgcat::mcset pb_msg_italian "MC(isv,tool_info,add_tool,Context)"     "Aggiungere un nuovo utensile. Specificare i parametri."
::msgcat::mcset pb_msg_italian "MC(isv,tool_info,add_err,Msg)"          "Questo numero di utensile è già stato usato."
::msgcat::mcset pb_msg_italian "MC(isv,tool_info,name_err,Msg)"         "Il campo nome utensile non può essere vuoto."

###########################
# Special G code Definition
###########################

::msgcat::mcset pb_msg_italian "MC(isv,g_code,frame,Label)"             "Codice G speciale"
::msgcat::mcset pb_msg_italian "MC(isv,g_code,frame,Context)"           "Specificare i codici G speciali usati in simulazione"
::msgcat::mcset pb_msg_italian "MC(isv,g_code,from_home,Label)"         "Dal punto Home"
::msgcat::mcset pb_msg_italian "MC(isv,g_code,return_home,Label)"       "Torna al punto Home"
::msgcat::mcset pb_msg_italian "MC(isv,g_code,mach_wcs,Label)"          "Movimento datum della macchina"
::msgcat::mcset pb_msg_italian "MC(isv,g_code,set_local,Label)"         "Imposta coordinata locale"

###########################
# Special NC Custom Command
###########################

::msgcat::mcset pb_msg_italian "MC(isv,spec_command,frame,Label)"       "Comandi NC speciali"
::msgcat::mcset pb_msg_italian "MC(isv,spec_command,frame,Context)"     "Comandi NC specificati per i dispositivi speciali"


::msgcat::mcset pb_msg_italian "MC(isv,spec_pre,frame,Label)"           "Comandi di preprocessamento"
::msgcat::mcset pb_msg_italian "MC(isv,spec_pre,frame,Context)"         "L'elenco di comandi include tutti i token e i simboli da processare prima che un blocco venga analizzato in modo da definire le coordinate"

::msgcat::mcset pb_msg_italian "MC(isv,spec_command,add,Label)"         "Aggiungi"
::msgcat::mcset pb_msg_italian "MC(isv,spec_command,edit,Label)"        "Modifica"
::msgcat::mcset pb_msg_italian "MC(isv,spec_command,delete,Label)"      "Elimina"
::msgcat::mcset pb_msg_italian "MC(isv,spec_command,title,Label)"       "Comando speciale per altri dispositivi"
::msgcat::mcset pb_msg_italian "MC(isv,spec_command,add_sim,Label)"     "Aggiungi il comando SIM @Cursor"
::msgcat::mcset pb_msg_italian "MC(isv,spec_command,init_sim,Label)"    "Selezionare un comando"

::msgcat::mcset pb_msg_italian "MC(isv,spec_command,preleader,Label)"   "Inizio"
::msgcat::mcset pb_msg_italian "MC(isv,spec_command,preleader,Context)" "Specificare gli spazi iniziali per il comando di preprocessamento definito dall'utente."

::msgcat::mcset pb_msg_italian "MC(isv,spec_command,precode,Label)"     "Codice"
::msgcat::mcset pb_msg_italian "MC(isv,spec_command,precode,Context)"   "Specificare gli spazi iniziali per il comando di preprocessamento definito dall'utente."

::msgcat::mcset pb_msg_italian "MC(isv,spec_command,leader,Label)"      "Inizio"
::msgcat::mcset pb_msg_italian "MC(isv,spec_command,leader,Context)"    "Specificare gli spazi iniziali per il comando definito dall'utente."

::msgcat::mcset pb_msg_italian "MC(isv,spec_command,code,Label)"        "Codice"
::msgcat::mcset pb_msg_italian "MC(isv,spec_command,code,Context)"      "Specificare gli spazi iniziali per il comando definito dall'utente."

::msgcat::mcset pb_msg_italian "MC(isv,spec_command,add,Context)"       "Aggiungi nuovo comando definito dall'utente"
::msgcat::mcset pb_msg_italian "MC(isv,spec_command,add_err,Msg)"       "Questo token è già stato gestito."
::msgcat::mcset pb_msg_italian "MC(isv,spec_command,sel_err,Msg)"       "Scegliere un comando"
::msgcat::mcset pb_msg_italian "MC(isv,export,error,title)"             "Avviso"

::msgcat::mcset pb_msg_italian "MC(isv,tool_table,title,Label)"         "Tabella utensili"
::msgcat::mcset pb_msg_italian "MC(isv,ex_editor,warning,Msg)"          "Questo è un comando VNC generato dal sistema. Le modifiche non verranno salvate."


# - Languages
#
::msgcat::mcset pb_msg_italian "MC(language,Label)"                     "Lingua"
::msgcat::mcset pb_msg_italian "MC(pb_msg_english)"                     "Inglese"
::msgcat::mcset pb_msg_italian "MC(pb_msg_french)"                      "Francese"
::msgcat::mcset pb_msg_italian "MC(pb_msg_german)"                      "Tedesco"
::msgcat::mcset pb_msg_italian "MC(pb_msg_italian)"                     "Italiano"
::msgcat::mcset pb_msg_italian "MC(pb_msg_japanese)"                    "Giapponese"
::msgcat::mcset pb_msg_italian "MC(pb_msg_korean)"                      "Coreano"
::msgcat::mcset pb_msg_italian "MC(pb_msg_russian)"                     "Russo"
::msgcat::mcset pb_msg_italian "MC(pb_msg_simple_chinese)"              "Cinese semplificato"
::msgcat::mcset pb_msg_italian "MC(pb_msg_spanish)"                     "Spagnolo"
::msgcat::mcset pb_msg_italian "MC(pb_msg_traditional_chinese)"         "Cinese tradizionale"

### Exit Options Dialog
::msgcat::mcset pb_msg_italian "MC(exit,options,Label)"                 "Opzioni di uscita"
::msgcat::mcset pb_msg_italian "MC(exit,options,SaveAll,Label)"         "Esci e salva tutto"
::msgcat::mcset pb_msg_italian "MC(exit,options,SaveNone,Label)"        "Esci senza salvare"
::msgcat::mcset pb_msg_italian "MC(exit,options,SaveSelect,Label)"      "Esci salvando gli elementi selezionati"

### OptionMenu Items
::msgcat::mcset pb_msg_italian "MC(optionMenu,item,Other)"       "Altro"
::msgcat::mcset pb_msg_italian "MC(optionMenu,item,None)"        "Nessuno"
::msgcat::mcset pb_msg_italian "MC(optionMenu,item,RT_R)"        "Traversa e R rapidi"
::msgcat::mcset pb_msg_italian "MC(optionMenu,item,Rapid)"       "Rapido"
::msgcat::mcset pb_msg_italian "MC(optionMenu,item,RS)"          "Mandrino rapido"
::msgcat::mcset pb_msg_italian "MC(optionMenu,item,C_off_RS)"    "Ciclo OFF e poi mandrino rapido"
::msgcat::mcset pb_msg_italian "MC(optionMenu,item,IPM)"         "pollici/min"
::msgcat::mcset pb_msg_italian "MC(optionMenu,item,FRN)"         "FRN"
::msgcat::mcset pb_msg_italian "MC(optionMenu,item,IPR)"         "pollici/giro"
::msgcat::mcset pb_msg_italian "MC(optionMenu,item,Auto)"        "Automatico"
::msgcat::mcset pb_msg_italian "MC(optionMenu,item,DPM)"         "DPM"
::msgcat::mcset pb_msg_italian "MC(optionMenu,item,Abs_Inc)"     "Assoluto/Incrementale"
::msgcat::mcset pb_msg_italian "MC(optionMenu,item,Abs_Only)"    "Solo assoluto"
::msgcat::mcset pb_msg_italian "MC(optionMenu,item,Inc_Only)"    "Solo incrementale"
::msgcat::mcset pb_msg_italian "MC(optionMenu,item,SD)"          "Distanza più breve"
::msgcat::mcset pb_msg_italian "MC(optionMenu,item,AP)"          "Sempre positivo"
::msgcat::mcset pb_msg_italian "MC(optionMenu,item,AN)"          "Sempre negativo"
::msgcat::mcset pb_msg_italian "MC(optionMenu,item,Z_Axis)"      "Asse Z"
::msgcat::mcset pb_msg_italian "MC(optionMenu,item,+X_Axis)"     "Asse +X"
::msgcat::mcset pb_msg_italian "MC(optionMenu,item,-X_Axis)"     "Asse -X"
::msgcat::mcset pb_msg_italian "MC(optionMenu,item,Y_Axis)"      "Asse Y"
::msgcat::mcset pb_msg_italian "MC(optionMenu,item,MDD)"         "La grandezza determina la direzione"
::msgcat::mcset pb_msg_italian "MC(optionMenu,item,SDD)"         "Il segno determina la direzione"
