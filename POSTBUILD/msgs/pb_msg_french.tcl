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
#       ::msgcat::mcset pb_msg_french "MC(main,title,Unigraphics)"  "Unigraphics"
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
::msgcat::mcset pb_msg_french "MC(event,misc,subop_start,name)"      "Début du parcours de Sous-opér."
::msgcat::mcset pb_msg_french "MC(event,misc,subop_end,name)"        "Fin du parcours de Sous-opér."
::msgcat::mcset pb_msg_french "MC(event,misc,contour_start,name)"    "Début du contour"
::msgcat::mcset pb_msg_french "MC(event,misc,contour_end,name)"      "Fin du contour"
::msgcat::mcset pb_msg_french "MC(prog,tree,misc,Label)"             "Divers"
::msgcat::mcset pb_msg_french "MC(event,cycle,lathe_rough,name)"     "Ebauche en tournage"
::msgcat::mcset pb_msg_french "MC(main,file,properties,Label)"       "Propriétés Post"

::msgcat::mcset pb_msg_french "MC(ude,editor,popup,MSG_CATEGORY)"    "Un UDE pour un post de fraisage ou de tournage ne peut pas être spécifié avec seulement une catégorie \"Wedm\"."

::msgcat::mcset pb_msg_french "MC(event,cycle,plane_change,label)"   "Déclencher cet événement lorsque le Plan de travail devient Inférieur"
::msgcat::mcset pb_msg_french "MC(format,check_1,error,msg)"         "Le format ne peut pas accepter la valeur des expressions"

::msgcat::mcset pb_msg_french "MC(format,check_4,error,msg)"         "Modifier le format de l'adresse liée avant de quitter cette page ou de sauvegarder ce post."
::msgcat::mcset pb_msg_french "MC(format,check_5,error,msg)"         "Modifier le format avant de quitter cette page ou de sauvegarder ce post."
::msgcat::mcset pb_msg_french "MC(format,check_6,error,msg)"         "Modifier le format de l'adresse liée avant d'entrer dans cette page."

::msgcat::mcset pb_msg_french "MC(msg,old_block,maximum_length)"     "Les noms de Blocs suivants dépassent la limite de longueur:"
::msgcat::mcset pb_msg_french "MC(msg,old_address,maximum_length)"   "Les noms de Mots suivants dépassent la limite de longueur:"
::msgcat::mcset pb_msg_french "MC(msg,block_address,check,title)"    "Vérifie les noms de Bloc et de Mot"
::msgcat::mcset pb_msg_french "MC(msg,block_address,maximum_length)" "Certains noms de Blocs ou de Mots dépassent la limite de longueur."

::msgcat::mcset pb_msg_french "MC(address,maximum_name_msg)"         "La longueur de la chaîne dépasse la limite."

::msgcat::mcset pb_msg_french "MC(ude,import,oth_list,Label)"        "Inclure un autre fichier CDL"
::msgcat::mcset pb_msg_french "MC(ude,import,oth_list,Context)"      "Sélectionnez l'option \\\"Nouveau\\\" dans le menu déroulant (bouton de droite) pour inclure d'autres fichiers CDL avec ce post."
::msgcat::mcset pb_msg_french "MC(ude,import,ihr_list,Label)"        "Reprendre les UDE d'un Post"
::msgcat::mcset pb_msg_french "MC(ude,import,ihr_list,Context)"      "Sélectionnez l'option \\\"Nouveau\\\" dans le menu déroulant (bouton de droite) pour hériter d'un post les définitions d'UDE et les fonctions associées."
::msgcat::mcset pb_msg_french "MC(ude,import,up,Label)"              "Haut"
::msgcat::mcset pb_msg_french "MC(ude,import,down,Label)"            "Bas"
::msgcat::mcset pb_msg_french "MC(msg,exist_cdl_file)"               "Le CDL spécifié a déjà été inclus."

::msgcat::mcset pb_msg_french "MC(listing,link_var,check,Label)"     "Lier les variables TCL aux variables C"
::msgcat::mcset pb_msg_french "MC(listing,link_var,check,Context)"   "Un jeu de variables TCL fréquemment modifiées (telles que \\\"mom_pos\\\") peut être lié directement aux variables C internes afin d'améliorer les performances des post-processeurs. Toutefois, certaines restrictions doivent être observées pour éviter des risques d'erreurs et des différences dans la sortie CN."

::msgcat::mcset pb_msg_french "MC(msg,check_resolution,title)"       "Vérifier la résolution des mouvements linéaires/de rotation"
::msgcat::mcset pb_msg_french "MC(msg,check_resolution,linear)"      "Le paramétrage du format n'accepte peut-être pas la sortie pour la \"Résolution des mouvements linéaires\". "
::msgcat::mcset pb_msg_french "MC(msg,check_resolution,rotary)"      "Le paramétrage du format n'accepte peut-être pas la sortie pour la \"Résolution des mouvements de rotation\". "

::msgcat::mcset pb_msg_french "MC(cmd,export,desc,label)"            "Saisir la description pour les commandes personnalisées exportées"
::msgcat::mcset pb_msg_french "MC(cmd,desc_dlg,title)"               "Description"
::msgcat::mcset pb_msg_french "MC(block,delete_row,Label)"           "Supprimer tous les éléments actifs dans cette ligne"
::msgcat::mcset pb_msg_french "MC(block,exec_cond,set,Label)"        "Condition de sortie"
::msgcat::mcset pb_msg_french "MC(block,exec_cond,new,Label)"        "Nouveau..."
::msgcat::mcset pb_msg_french "MC(block,exec_cond,edit,Label)"       "Editer..."
::msgcat::mcset pb_msg_french "MC(block,exec_cond,remove,Label)"     "Supprimer..."

::msgcat::mcset pb_msg_french "MC(cust_cmd,name_msg_for_cond)"       "Spécifiez un autre nom. \nLa commande Condition de sortie doit être précédée de"

::msgcat::mcset pb_msg_french "MC(machine,linearization,Label)"         "Interpolation de linéarisation"
::msgcat::mcset pb_msg_french "MC(machine,linearization,angle,Label)"   "Angle de rotation"
::msgcat::mcset pb_msg_french "MC(machine,linearization,angle,Context)" "Les points interpolés seront calculés selon la distribution des angles de départ et de fin des axes rotatifs."
::msgcat::mcset pb_msg_french "MC(machine,linearization,axis,Label)"    "Axe de l'outil"
::msgcat::mcset pb_msg_french "MC(machine,linearization,axis,Context)"  "Les points interpolés seront calculés selon la distribution des vecteurs de départ et de fin de l'axe d'outil."
::msgcat::mcset pb_msg_french "MC(machine,resolution,continue,Label)"   "Continuer"
::msgcat::mcset pb_msg_french "MC(machine,resolution,abort,Label)"      "Arrêter"

::msgcat::mcset pb_msg_french "MC(machine,axis,def_lintol,Label)"       "Tolérance par défaut"
::msgcat::mcset pb_msg_french "MC(machine,axis,def_lintol,Context)"     "Tolérance de linéarisation par défaut"
::msgcat::mcset pb_msg_french "MC(sub_post,inch,Lable)"                 "IN"
::msgcat::mcset pb_msg_french "MC(sub_post,metric,Lable)"               "MM"
::msgcat::mcset pb_msg_french "MC(new_sub,title,Label)"                 "Créer un nouveau Post-Processeur secondaire"
::msgcat::mcset pb_msg_french "MC(new,sub_post,toggle,label)"           "Post secondaire"
::msgcat::mcset pb_msg_french "MC(new,sub_post,toggle,tmp_label)"       "Post secondaire pour unités seulement"
::msgcat::mcset pb_msg_french "MC(new,unit_post,filename,msg)"          "Le nouveau post secondaire pour unités de sortie alternatives doit être nommé\n en ajoutant le suffixe \"__MM\" ou \"__IN\" au nom du post principal."
::msgcat::mcset pb_msg_french "MC(new,alter_unit,toggle,label)"         "Unité de sortie alternative"
::msgcat::mcset pb_msg_french "MC(new,main_post,label)"                 "Post principal"
::msgcat::mcset pb_msg_french "MC(new,main_post,warning_1,msg)"         "Seul un post principal complet peut être utilisé pour créer un nouveau post secondaire."
::msgcat::mcset pb_msg_french "MC(new,main_post,warning_2,msg)"         "Le post principal doit être créé ou sauvegardé \n dans Post Builder version 8.0 ou plus récent."
::msgcat::mcset pb_msg_french "MC(new,main_post,specify_err,msg)"       "Le post principal doit être spécifié pour créer un post secondaire."
::msgcat::mcset pb_msg_french "MC(machine,gen,alter_unit,Label)"        "Unités de sortie du post secondaire :"
::msgcat::mcset pb_msg_french "MC(unit_related_param,tab,Label)"        "Paramètres d'unités"
::msgcat::mcset pb_msg_french "MC(unit_related_param,feed_rate,Label)"  "Avance"
::msgcat::mcset pb_msg_french "MC(listing,alt_unit,frame,Label)"        "Post secondaire facultatif pour unités alternatives"
::msgcat::mcset pb_msg_french "MC(listing,alt_unit,default,Label)"      "Par défaut"
::msgcat::mcset pb_msg_french "MC(listing,alt_unit,default,Context)"    "Le nom par défaut du post secondaire pour unités alternatives sera <nom post>__MM ou <nom post>__IN"
::msgcat::mcset pb_msg_french "MC(listing,alt_unit,specify,Label)"      "Spécifier"
::msgcat::mcset pb_msg_french "MC(listing,alt_unit,specify,Context)"    "Spécifier le nom d'un post secondaire pour unités alternatives"
::msgcat::mcset pb_msg_french "MC(listing,alt_unit,select_name,Label)"  "Sélectionner le nom"
::msgcat::mcset pb_msg_french "MC(listing,alt_unit,warning_1,msg)"      "Seul un post secondaire pour unités alternatives peut être sélectionné."
::msgcat::mcset pb_msg_french "MC(listing,alt_unit,warning_2,msg)"      "Le post secondaire sélectionné ne peut pas prendre en charge les unités de sortie alternatives pour ce post."

::msgcat::mcset pb_msg_french "MC(listing,alt_unit,post_name,Label)"    "Post secondaire pour unités alternatives"
::msgcat::mcset pb_msg_french "MC(listing,alt_unit,post_name,Context)"  "NX Post utilisera le post secondaire des unités alternatives, s'il est fourni, pour traiter les unités de sortie alternatives pour ce post."


##--------------------
## New string in v7.5
##
::msgcat::mcset pb_msg_french "MC(machine,axis,violation,user,evt_title)"  "Action définie par l'utilisateur pour Non respect de limite d'axe"
::msgcat::mcset pb_msg_french "MC(event,helix,name)"                       "Mouvement hélicoïdal"
::msgcat::mcset pb_msg_french "MC(event,circular,ijk_param,prefix,msg)"    "Les expressions utilisées dans des Adresses"
::msgcat::mcset pb_msg_french "MC(event,circular,ijk_param,postfix,msg)"   "ne seront pas affectées par ce changement d'option."
::msgcat::mcset pb_msg_french "MC(isv,spec_codelist,default,msg)"          "Cette action rétablira la liste des codes CN spéciaux \net de leurs handlers à l'état datant de l'ouverture ou de la création de ce Post.\n\n Continuer?"
::msgcat::mcset pb_msg_french "MC(isv,spec_codelist,restore,msg)"          "Cette action rétablira la liste des codes CN spéciaux \net de leurs handlers à l'état datant de la dernière consultation de cette page.\n\n Continuer?"
::msgcat::mcset pb_msg_french "MC(msg,block_format_command,paste_err)"     "Le nom d'objet existe déjà... Collage non valable."
::msgcat::mcset pb_msg_french "MC(main,file,open,choose_cntl_type)"        "Choisir une famille de contrôleurs"
::msgcat::mcset pb_msg_french "MC(cust_cmd,import,no_vnc_cmd,msg)"         "Ce fichier ne contient pas de commande VNC nouvelle ou différente."
::msgcat::mcset pb_msg_french "MC(cust_cmd,import,no_cmd,msg)"             "Ce fichier ne contient pas de commande personnalisée nouvelle ou différente."
::msgcat::mcset pb_msg_french "MC(isv,tool_info,name_same_err,Msg)"        "Les noms d'outils ne peuvent pas être identiques."
::msgcat::mcset pb_msg_french "MC(msg,limit_to_change_license)"            "Vous n'êtes pas l'auteur de ce Post. \nVous ne disposerez pas des droits pour le renommer ou changer sa licence."
::msgcat::mcset pb_msg_french "MC(output,other_opts,validation,msg)"       "Le nom du fichier TCL utilisateur doit être spécifié."
::msgcat::mcset pb_msg_french "MC(machine,empty_entry_err,msg)"            "Il y a des entrées vides sur cette page de paramètres."
::msgcat::mcset pb_msg_french "MC(msg,control_v_limit)"                    "La chaîne que vous tentez de coller dépasse \nla limite de longueur ou contient des \nlignes multiples ou des caractères non valables."
::msgcat::mcset pb_msg_french "MC(block,capital_name_msg)"                 "L'initiale du nom de bloc ne peut pas être en majuscule.\n Spécifiez un autre nom."
::msgcat::mcset pb_msg_french "MC(machine,axis,violation,user,Label)"      "Défini par l'utilisateur"
::msgcat::mcset pb_msg_french "MC(machine,axis,violation,user,Handler)"    "Handler"
::msgcat::mcset pb_msg_french "MC(new,user,file,NOT_EXIST)"                "Le fichier utilisateur n'existe pas."
::msgcat::mcset pb_msg_french "MC(new,include_vnc,Label)"                  "Inclure Contrôleur CN virtuel"
::msgcat::mcset pb_msg_french "MC(other,opt_equal,Label)"                  "Signe égal (=)"
::msgcat::mcset pb_msg_french "MC(event,nurbs,name)"                       "Mouvement NURBS"
::msgcat::mcset pb_msg_french "MC(event,cycle,tap_float,name)"             "Taraudage flottant"
::msgcat::mcset pb_msg_french "MC(event,cycle,thread,name)"                "Filetage"
::msgcat::mcset pb_msg_french "MC(ude,editor,group,MSG_NESTED_GROUP)"      "Groupage imbriqué non pris en charge."
::msgcat::mcset pb_msg_french "MC(ude,editor,bmp,Label)"                   "Bitmap"
::msgcat::mcset pb_msg_french "MC(ude,editor,bmp,Context)"                 "Ajouter un nouveau paramètre bitmap en le glissant vers la liste de droite."
::msgcat::mcset pb_msg_french "MC(ude,editor,group,Label)"                 "Groupe"
::msgcat::mcset pb_msg_french "MC(ude,editor,group,Context)"               "Ajouter un nouveau paramètre de groupage en le glissant vers la liste de droite."
::msgcat::mcset pb_msg_french "MC(ude,editor,eventdlg,DESC,Label)"         "Description"
::msgcat::mcset pb_msg_french "MC(ude,editor,eventdlg,DESC,Context)"       "Spécifier des informations sur l'événement"
::msgcat::mcset pb_msg_french "MC(ude,editor,eventdlg,URL,Label)"          "URL"
::msgcat::mcset pb_msg_french "MC(ude,editor,eventdlg,URL,Context)"        "Spécifier l'URL pour la description de l'événement."
::msgcat::mcset pb_msg_french "MC(ude,editor,param,MSG_WRONG_IMAGE_FILE)"  "Le fichier image doit être au format BMP."
::msgcat::mcset pb_msg_french "MC(ude,editor,param,MSG_WRONG_IMAGE_FOLDER)" "Le nom du fichier Bitmap ne doit pas contenir de chemin de répertoire."
::msgcat::mcset pb_msg_french "MC(ude,editor,param,MSG_WRONG_VAR_NAME)"    "Le nom de la variable doit commencer par une lettre."
::msgcat::mcset pb_msg_french "MC(ude,editor,param,MSG_WRONG_KEYWORD)"     "Le nom de la variable ne doit pas utiliser le mot-clé: "
::msgcat::mcset pb_msg_french "MC(ude,editor,status_label)"                "Etat"
::msgcat::mcset pb_msg_french "MC(ude,editor,vector,Label)"                "Vecteur"
::msgcat::mcset pb_msg_french "MC(ude,editor,vector,Context)"              "Ajouter un nouveau paramètre de vecteur en le glissant vers la liste de droite."
::msgcat::mcset pb_msg_french "MC(ude,editor,popup,MSG_URL_FORMAT)"        "L'URL doit être au format \"http://*\" ou \"file://*\" sans barre oblique inverse."
::msgcat::mcset pb_msg_french "MC(ude,editor,popup,MSG_BLANK_HELP_INFO)"   "La description et l'URL doivent être spécifiées."
::msgcat::mcset pb_msg_french "MC(new,MSG_NO_AXIS)"                        "La configuration d'axes doit être sélectionnée pour une machine-outil."
::msgcat::mcset pb_msg_french "MC(machine,info,controller_type,Label)"     "Famille de contrôleurs"
::msgcat::mcset pb_msg_french "MC(block,func_combo,Label)"                 "Macro"
::msgcat::mcset pb_msg_french "MC(block,prefix_popup,add,Label)"           "Ajouter un préfixe de texte"
::msgcat::mcset pb_msg_french "MC(block,prefix_popup,edit,Label)"          "Editer le préfixe de texte"
::msgcat::mcset pb_msg_french "MC(block,prefix,Label)"                     "Préfixe"
::msgcat::mcset pb_msg_french "MC(block,suppress_popup,Label)"             "Supprimer le numéro de séquence"
::msgcat::mcset pb_msg_french "MC(block,custom_func,Label)"                "Macro personnalisée"
::msgcat::mcset pb_msg_french "MC(seq,combo,macro,Label)"                  "Macro personnalisée"
::msgcat::mcset pb_msg_french "MC(func,tab,Label)"                         "Macro"
::msgcat::mcset pb_msg_french "MC(func,exp,msg)"                           "L'expression pour un paramètre de macro ne doit pas être vide."
::msgcat::mcset pb_msg_french "MC(func,edit,name,Label)"                   "Nom de macro"
::msgcat::mcset pb_msg_french "MC(func,disp_name,Label)"                   "Nom de sortie"
::msgcat::mcset pb_msg_french "MC(func,param_list,Label)"                  "Liste de paramètres"
::msgcat::mcset pb_msg_french "MC(func,separator,Label)"                   "Séparateur"
::msgcat::mcset pb_msg_french "MC(func,start,Label)"                       "Caractère de départ"
::msgcat::mcset pb_msg_french "MC(func,end,Label)"                         "Caractère de fin"
::msgcat::mcset pb_msg_french "MC(func,output,name,Label)"                 "Attribut de sortie"
::msgcat::mcset pb_msg_french "MC(func,output,check,Label)"                "Nom du paramètre de sortie"
::msgcat::mcset pb_msg_french "MC(func,output,link,Label)"                 "Caractère de liaison"
::msgcat::mcset pb_msg_french "MC(func,col_param,Label)"                   "Paramètre"
::msgcat::mcset pb_msg_french "MC(func,col_exp,Label)"                     "Expression"
::msgcat::mcset pb_msg_french "MC(func,popup,insert,Label)"                "Nouveau"
::msgcat::mcset pb_msg_french "MC(func,name,err_msg)"                      "Le nom de macro ne doit pas contenir d'espace."
::msgcat::mcset pb_msg_french "MC(func,name,blank_err)"                    "Le nom de macro ne doit pas être vide."
::msgcat::mcset pb_msg_french "MC(func,name,contain_err)"                  "Le nom de macro ne doit contenir que des lettres, chiffres et soulignés."
::msgcat::mcset pb_msg_french "MC(func,tree_node,start_err)"               "Le nom de noeud doit commencer par une lettre en majuscule."
::msgcat::mcset pb_msg_french "MC(func,tree_node,contain_err)"             "Le nom de noeud accepte seulement une lettre, un chiffre ou un souligné."
::msgcat::mcset pb_msg_french "MC(func,help,Label)"                        "Informations"
::msgcat::mcset pb_msg_french "MC(func,help,Context)"                      "Afficher les informations sur l'objet."
::msgcat::mcset pb_msg_french "MC(func,help,MSG_NO_INFO)"                  "Aucune information n'est fournie pour cette macro."


##------
## Title
##
::msgcat::mcset pb_msg_french "MC(main,title,Unigraphics)"             "Unigraphics"
::msgcat::mcset pb_msg_french "MC(main,title,UG)"                      "NX"
::msgcat::mcset pb_msg_french "MC(main,title,Post_Builder)"            "Post Builder"

::msgcat::mcset pb_msg_french "MC(main,title,Version)"                 "Version"
::msgcat::mcset pb_msg_french "MC(main,default,Status)"                "Sélectionner l'option Nouveau ou Ouvrir dans le menu Fichier."
::msgcat::mcset pb_msg_french "MC(main,save,Status)"                   "Sauvegarder le Post."

##------
## File
##
::msgcat::mcset pb_msg_french "MC(main,file,Label)"                    "Fichier"

::msgcat::mcset pb_msg_french "MC(main,file,Balloon)"                  "\ Nouveau, Ouvrir, Enregistrer, \nEnregistrer\ sous, Fermer et Quitter"

::msgcat::mcset pb_msg_french "MC(main,file,Context)"                  "\ Nouveau, Ouvrir, Enregistrer, \nEnregistrer\ sous, Fermer et Quitter"
::msgcat::mcset pb_msg_french "MC(main,file,menu,Context)"             " "

::msgcat::mcset pb_msg_french "MC(main,file,new,Label)"                "Nouveau..."
::msgcat::mcset pb_msg_french "MC(main,file,new,Balloon)"              "Créer un nouveau Post."
::msgcat::mcset pb_msg_french "MC(main,file,new,Context)"              "Créer un nouveau Post."
::msgcat::mcset pb_msg_french "MC(main,file,new,Busy)"                 "Création d'un nouveau Post..."

::msgcat::mcset pb_msg_french "MC(main,file,open,Label)"               "Ouvrir..."
::msgcat::mcset pb_msg_french "MC(main,file,open,Balloon)"             "Editer un Post existant."
::msgcat::mcset pb_msg_french "MC(main,file,open,Context)"             "Editer un Post existant."
::msgcat::mcset pb_msg_french "MC(main,file,open,Busy)"                "Ouverture du Post..."

::msgcat::mcset pb_msg_french "MC(main,file,mdfa,Label)"               "Importer MDFA..."
::msgcat::mcset pb_msg_french "MC(main,file,mdfa,Balloon)"             "Créer un nouveau Post depuis MDFA. "
::msgcat::mcset pb_msg_french "MC(main,file,mdfa,Context)"             "Créer un nouveau Post depuis MDFA. "

::msgcat::mcset pb_msg_french "MC(main,file,save,Label)"               "Enregistrer"
::msgcat::mcset pb_msg_french "MC(main,file,save,Balloon)"             "Enregistrer le Post en cours."
::msgcat::mcset pb_msg_french "MC(main,file,save,Context)"             "Enregistrer le Post en cours."
::msgcat::mcset pb_msg_french "MC(main,file,save,Busy)"                "Sauvegarde du Post..."

::msgcat::mcset pb_msg_french "MC(main,file,save_as,Label)"            "Enregistrer sous..."
::msgcat::mcset pb_msg_french "MC(main,file,save_as,Balloon)"          "Enregistrer le Post sous un nouveau nom."
::msgcat::mcset pb_msg_french "MC(main,file,save_as,Context)"          "Enregistrer le Post sous un nouveau nom."

::msgcat::mcset pb_msg_french "MC(main,file,close,Label)"              "Fermer"
::msgcat::mcset pb_msg_french "MC(main,file,close,Balloon)"            "Fermer le Post en cours."
::msgcat::mcset pb_msg_french "MC(main,file,close,Context)"            "Fermer le Post en cours."

::msgcat::mcset pb_msg_french "MC(main,file,exit,Label)"               "Quitter"
::msgcat::mcset pb_msg_french "MC(main,file,exit,Balloon)"             "Terminer Post Builder."
::msgcat::mcset pb_msg_french "MC(main,file,exit,Context)"             "Terminer Post Builder."

::msgcat::mcset pb_msg_french "MC(main,file,history,Label)"            "Posts récemment ouverts"
::msgcat::mcset pb_msg_french "MC(main,file,history,Balloon)"          "Editer un Post récemment visité."
::msgcat::mcset pb_msg_french "MC(main,file,history,Context)"          "Editer un Post visité dans des sessions Post Builder précédentes."

##---------
## Options
##
::msgcat::mcset pb_msg_french "MC(main,options,Label)"                 "Options"

::msgcat::mcset pb_msg_french "MC(main,options,Balloon)"               " Valider\ les commandes\ personnalisées, Backup\ Post"
::msgcat::mcset pb_msg_french "MC(main,options,Context)"               " "
::msgcat::mcset pb_msg_french "MC(main,options,menu,Context)"          " "

::msgcat::mcset pb_msg_french "MC(main,windows,Label)"                 "Windows"
::msgcat::mcset pb_msg_french "MC(main,windows,Balloon)"               "La liste d'édition des posts"
::msgcat::mcset pb_msg_french "MC(main,windows,Context)"               " "
::msgcat::mcset pb_msg_french "MC(main,windows,menu,Context)"          " "

::msgcat::mcset pb_msg_french "MC(main,options,properties,Label)"      "Propriétés"
::msgcat::mcset pb_msg_french "MC(main,options,properties,Balloon)"    "Propriétés"
::msgcat::mcset pb_msg_french "MC(main,options,properties,Context)"    "Propriétés"

::msgcat::mcset pb_msg_french "MC(main,options,advisor,Label)"         "Post Advisor"
::msgcat::mcset pb_msg_french "MC(main,options,advisor,Balloon)"       "Post Advisor"
::msgcat::mcset pb_msg_french "MC(main,options,advisor,Context)"       "Activer/ Désactiver Post Advisor."

::msgcat::mcset pb_msg_french "MC(main,options,cmd_check,Label)"       "Valider les Commandes personnalisées"
::msgcat::mcset pb_msg_french "MC(main,options,cmd_check,Balloon)"     "Valider les Commandes personnalisées"
::msgcat::mcset pb_msg_french "MC(main,options,cmd_check,Context)"     "Bascules pour Validation des commandes personnalisées"

::msgcat::mcset pb_msg_french "MC(main,options,cmd_check,syntax,Label)"   "Erreurs de syntaxe"
::msgcat::mcset pb_msg_french "MC(main,options,cmd_check,command,Label)"  "Commandes inconnues"
::msgcat::mcset pb_msg_french "MC(main,options,cmd_check,block,Label)"    "Blocs inconnus"
::msgcat::mcset pb_msg_french "MC(main,options,cmd_check,address,Label)"  "Adresse inconnue"
::msgcat::mcset pb_msg_french "MC(main,options,cmd_check,format,Label)"   "Formats inconnus"

::msgcat::mcset pb_msg_french "MC(main,options,backup,Label)"          "Backup Post"
::msgcat::mcset pb_msg_french "MC(main,options,backup,Balloon)"        "Méthode Backup Post"
::msgcat::mcset pb_msg_french "MC(main,options,backup,Context)"        "Créer des copies de sauvegarde lors de la sauvegarde du Post en cours."

::msgcat::mcset pb_msg_french "MC(main,options,backup,one,Label)"      "Backup Original"
::msgcat::mcset pb_msg_french "MC(main,options,backup,all,Label)"      "Backup à chaque sauvegarde"
::msgcat::mcset pb_msg_french "MC(main,options,backup,none,Label)"     "Pas de backup "

##-----------
## Utilities
##
::msgcat::mcset pb_msg_french "MC(main,utils,Label)"                   "Utilitaires"
::msgcat::mcset pb_msg_french "MC(main,utils,Balloon)"                 "\ Choisir\ Variable\ MOM, Installer\ Post"
::msgcat::mcset pb_msg_french "MC(main,utils,Context)"                 " "
::msgcat::mcset pb_msg_french "MC(main,utils,menu,Context)"            " "

::msgcat::mcset pb_msg_french "MC(main,utils,etpdf,Label)"             "Editer le fichier de données de modèles-type Post"

::msgcat::mcset pb_msg_french "MC(main,utils,bmv,Label)"               "Parcourir les variables MOM"
::msgcat::mcset pb_msg_french "MC(main,utils,blic,Label)"              "Parcourir les licences"


##------
## Help
##
::msgcat::mcset pb_msg_french "MC(main,help,Label)"                    "Aide"
::msgcat::mcset pb_msg_french "MC(main,help,Balloon)"                  "Options de l'aide"
::msgcat::mcset pb_msg_french "MC(main,help,Context)"                  "Options de l'aide"
::msgcat::mcset pb_msg_french "MC(main,help,menu,Context)"             " "

::msgcat::mcset pb_msg_french "MC(main,help,bal,Label)"                "Info-bulle"
::msgcat::mcset pb_msg_french "MC(main,help,bal,Balloon)"              "Info-bulle sur les icônes"
::msgcat::mcset pb_msg_french "MC(main,help,bal,Context)"              "Activer/Désactiver l'affichage des info-bulles pour les icônes."

::msgcat::mcset pb_msg_french "MC(main,help,chelp,Label)"              "Aide contextuelle"
::msgcat::mcset pb_msg_french "MC(main,help,chelp,Balloon)"            "Aide contextuelle sur les éléments de Dialogue"
::msgcat::mcset pb_msg_french "MC(main,help,chelp,Context)"            "Aide contextuelle sur les éléments de Dialogue"

::msgcat::mcset pb_msg_french "MC(main,help,what,Label)"               "Que faire?"
::msgcat::mcset pb_msg_french "MC(main,help,what,Balloon)"             "Que pouvez-vous faire ici?"
::msgcat::mcset pb_msg_french "MC(main,help,what,Context)"             "Que pouvez-vous faire ici?"

::msgcat::mcset pb_msg_french "MC(main,help,dialog,Label)"             "Aide sur le Dialogue"
::msgcat::mcset pb_msg_french "MC(main,help,dialog,Balloon)"           "Aide sur ce Dialogue"
::msgcat::mcset pb_msg_french "MC(main,help,dialog,Context)"           "Aide sur ce Dialogue"

::msgcat::mcset pb_msg_french "MC(main,help,manual,Label)"             "Manuel de l'utilisateur"
::msgcat::mcset pb_msg_french "MC(main,help,manual,Balloon)"           "Manuel d'aide de l'utilisateur"
::msgcat::mcset pb_msg_french "MC(main,help,manual,Context)"           "Manuel d'aide de l'utilisateur"

::msgcat::mcset pb_msg_french "MC(main,help,about,Label)"              "A propos de Post Builder"
::msgcat::mcset pb_msg_french "MC(main,help,about,Balloon)"            "A propos de Post Builder"
::msgcat::mcset pb_msg_french "MC(main,help,about,Context)"            "A propos de Post Builder"

::msgcat::mcset pb_msg_french "MC(main,help,rel_note,Label)"           "Notes de diffusion"
::msgcat::mcset pb_msg_french "MC(main,help,rel_note,Balloon)"         "Notes de diffusion"
::msgcat::mcset pb_msg_french "MC(main,help,rel_note,Context)"         "Notes de diffusion"

::msgcat::mcset pb_msg_french "MC(main,help,tcl_man,Label)"            "Manuels de référence Tcl/Tk"
::msgcat::mcset pb_msg_french "MC(main,help,tcl_man,Balloon)"          "Manuels de référence Tcl/Tk"
::msgcat::mcset pb_msg_french "MC(main,help,tcl_man,Context)"          "Manuels de référence Tcl/Tk"

##----------
## Tool Bar
##
::msgcat::mcset pb_msg_french "MC(tool,new,Label)"                     "Nouveau"
::msgcat::mcset pb_msg_french "MC(tool,new,Context)"                   "Créer un nouveau Post."

::msgcat::mcset pb_msg_french "MC(tool,open,Label)"                    "Ouvrir"
::msgcat::mcset pb_msg_french "MC(tool,open,Context)"                  "Editer un Post existant."

::msgcat::mcset pb_msg_french "MC(tool,save,Label)"                    "Enregistrer"
::msgcat::mcset pb_msg_french "MC(tool,save,Context)"                  "Enregistrer le Post en cours."

::msgcat::mcset pb_msg_french "MC(tool,bal,Label)"                     "Info-bulle"
::msgcat::mcset pb_msg_french "MC(tool,bal,Context)"                   "Activer/Désactiver l'affichage des info-bulles pour les icônes."

::msgcat::mcset pb_msg_french "MC(tool,chelp,Label)"                   "Aide contextuelle"
::msgcat::mcset pb_msg_french "MC(tool,chelp,Context)"                 "Aide contextuelle sur les éléments de Dialogue"

::msgcat::mcset pb_msg_french "MC(tool,what,Label)"                    "Que faire?"
::msgcat::mcset pb_msg_french "MC(tool,what,Context)"                  "Que pouvez-vous faire ici?"

::msgcat::mcset pb_msg_french "MC(tool,dialog,Label)"                  "Aide sur le Dialogue"
::msgcat::mcset pb_msg_french "MC(tool,dialog,Context)"                "Aide sur ce Dialogue"

::msgcat::mcset pb_msg_french "MC(tool,manual,Label)"                  "Manuel de l'utilisateur"
::msgcat::mcset pb_msg_french "MC(tool,manual,Context)"                "Manuel d'aide de l'utilisateur"

#=============
# Main Window
#=============

##-----------------
## Common Messages
##
::msgcat::mcset pb_msg_french "MC(msg,error,title)"                    "Erreur Post Builder"
::msgcat::mcset pb_msg_french "MC(msg,dialog,title)"                   "Message Post Builder"
::msgcat::mcset pb_msg_french "MC(msg,warning)"                        "Avertissement"
::msgcat::mcset pb_msg_french "MC(msg,error)"                          "Erreur"
::msgcat::mcset pb_msg_french "MC(msg,invalid_data)"                   "Des données non valables ont été saisies pour le paramètre"
::msgcat::mcset pb_msg_french "MC(msg,invalid_browser_cmd)"            "Commande de Navigateur incorrecte :"
::msgcat::mcset pb_msg_french "MC(msg,wrong_filename)"                 "Le nom de fichier a changé."
::msgcat::mcset pb_msg_french "MC(msg,user_ctrl_limit)"                "Un Post sous licence ne peut pas être utilisé comme \ncontrôleur pour créer un nouveau Post si vous n'êtes pas l'auteur."
::msgcat::mcset pb_msg_french "MC(msg,import_limit)"                   "Vous n'êtes pas l'auteur de ce Post sous licence.\n Les commandes personnalisées ne peuvent pas être importées."
::msgcat::mcset pb_msg_french "MC(msg,limit_msg)"                      "Vous n'êtes pas l'auteur de ce Post sous licence"
::msgcat::mcset pb_msg_french "MC(msg,no_file)"                        "Fichier crypté manquant pour ce Post sous licence."
::msgcat::mcset pb_msg_french "MC(msg,no_license)"                     "Pas de licence appropriée pour exécuter cette fonction."
::msgcat::mcset pb_msg_french "MC(msg,no_license_title)"               "Utilisation hors licence de NX/Post Builder"
::msgcat::mcset pb_msg_french "MC(msg,no_license_dialog)"              "Vous êtes autorisé à utiliser le NX/Post Builder\n sans licence appropriée. Toutefois, vous ne \n pourrez pas enregistrer votre travail."
::msgcat::mcset pb_msg_french "MC(msg,pending)"                        "Le service de cette option sera mis en oeuvre dans une future version."
::msgcat::mcset pb_msg_french "MC(msg,save)"                           "Voulez-vous enregistrer vos modifications\n avant de fermer le Post en cours?"
::msgcat::mcset pb_msg_french "MC(msg,version_check)"                  "Post créé avec version plus récente de Post Builder ne peut pas être ouvert dans cette version."

::msgcat::mcset pb_msg_french "MC(msg,file_corruption)"                "Contenu incorrect dans le fichier de session Post Builder."
::msgcat::mcset pb_msg_french "MC(msg,bad_tcl_file)"                   "Contenu incorrect dans le fichier TCL de votre Post."
::msgcat::mcset pb_msg_french "MC(msg,bad_def_file)"                   "Contenu incorrect dans le fichier de définition de votre Post."
::msgcat::mcset pb_msg_french "MC(msg,invalid_post)"                   "Il faut spécifier au moins un jeu de fichiers TCL et de définition pour votre Post."
::msgcat::mcset pb_msg_french "MC(msg,invalid_dir)"                    "Répertoire inexistant."
::msgcat::mcset pb_msg_french "MC(msg,invalid_file)"                   "Fichier non trouvé ou non valable."
::msgcat::mcset pb_msg_french "MC(msg,invalid_def_file)"               "Impossible d'ouvrir le fichier de définition"
::msgcat::mcset pb_msg_french "MC(msg,invalid_tcl_file)"               "Impossible d'ouvrir de fichier de fonction d'événement"
::msgcat::mcset pb_msg_french "MC(msg,dir_perm)"                       "Vous n'avez pas accès en écriture à ce répertoire:"
::msgcat::mcset pb_msg_french "MC(msg,file_perm)"                      "Vous n'avez pas les droits pour écrire dans"

::msgcat::mcset pb_msg_french "MC(msg,file_exist)"                     "existe déjà. \nLe remplacer malgré tout?"
::msgcat::mcset pb_msg_french "MC(msg,file_missing)"                   "Certains ou tous les fichiers sont manquants pour ce Post.\n Vous ne pouvez pas ouvrir ce post."
::msgcat::mcset pb_msg_french "MC(msg,sub_dialog_open)"                "Vous avez terminé l'édition de toutes les sous-boîtes de dialogue avant de sauvegarder le Post."
::msgcat::mcset pb_msg_french "MC(msg,generic)"                        "Post Builder n'a été mis en oeuvre que pour les Machines de fraisage génériques."
::msgcat::mcset pb_msg_french "MC(msg,min_word)"                       "Un bloc doit contenir au moins un Mot."
::msgcat::mcset pb_msg_french "MC(msg,name_exists)"                    "existe déjà. \nSpécifier un autre nom."
::msgcat::mcset pb_msg_french "MC(msg,in_use)"                         "Ce composant est utilisé.\n Il ne peut pas être détruit."
::msgcat::mcset pb_msg_french "MC(msg,do_you_want_to_proceed)"         "Vous pouvez les considérer comme des éléments de données existants et poursuivre."
::msgcat::mcset pb_msg_french "MC(msg,not_installed_properly)"         "n'a pas été installé correctement."
::msgcat::mcset pb_msg_french "MC(msg,no_app_to_open)"                 "Pas d'application à ouvrir"
::msgcat::mcset pb_msg_french "MC(msg,save_change)"                    "Voulez-vous enregistrer les modifications?"

::msgcat::mcset pb_msg_french "MC(msg,external_editor)"                "Editeur externe"

# - Do not translate EDITOR
::msgcat::mcset pb_msg_french "MC(msg,set_ext_editor)"                 "Vous pouvez utiliser la variable d'environnement EDITOR pour activer votre éditeur de texte favori."
::msgcat::mcset pb_msg_french "MC(msg,filename_with_space)"            "Nom de fichier contenant un espace, non pris en charge."
::msgcat::mcset pb_msg_french "MC(msg,filename_protection)"            "Le fichier sélectionné utilisé par l'un des posts d'édition ne peut pas être écrasé."


##--------------------
## Common Function
##
::msgcat::mcset pb_msg_french "MC(msg,parent_win)"                     "Une fenêtre temporaire requiert de définir sa fenêtre parente."
::msgcat::mcset pb_msg_french "MC(msg,close_subwin)"                   "Vous devez fermer toutes les sous-fenêtres pour activer cet onglet."
::msgcat::mcset pb_msg_french "MC(msg,block_exist)"                    "Un élément du Mot sélectionné existe dans le Modèle-type de bloc."
::msgcat::mcset pb_msg_french "MC(msg,num_gcode_1)"                    "Le nombre de codes G est limité à "
::msgcat::mcset pb_msg_french "MC(msg,num_gcode_2)"                    "par bloc"
::msgcat::mcset pb_msg_french "MC(msg,num_mcode_1)"                    "Le nombre de codes M est limité à "
::msgcat::mcset pb_msg_french "MC(msg,num_mcode_2)"                    "par bloc"
::msgcat::mcset pb_msg_french "MC(msg,empty_entry)"                    "L'entrée ne doit pas être vide."

::msgcat::mcset pb_msg_french "MC(msg,edit_feed_fmt)"                  "Les formats par adresse \"F\" peuvent être édités sur la page des paramètres des Avances"

::msgcat::mcset pb_msg_french "MC(msg,seq_num_max)"                    "La valeur maxi du Numéro de séquence ne doit pas dépasser la capacité Adresse N de"

::msgcat::mcset pb_msg_french "MC(msg,no_cdl_name)"                    "Le nom de Post doit être spécifié."
::msgcat::mcset pb_msg_french "MC(msg,no_def_name)"                    "Le dossier doit être spécifié.\n Doit être de type \"\$UGII_*\"."
::msgcat::mcset pb_msg_french "MC(msg,no_own_name)"                    "Le dossier doit être spécifié.\n Doit être de type \"\$UGII_*\"."
::msgcat::mcset pb_msg_french "MC(msg,no_oth_ude_name)"                "Le nom de l'autre fichier CDL doit être spécifié.\nDoit être de type \"\$UGII_*\"."
::msgcat::mcset pb_msg_french "MC(msg,not_oth_cdl_file)"               "Seul un fichier CDL est autorisé."
::msgcat::mcset pb_msg_french "MC(msg,not_pui_file)"                   "Seul un fichier PUI est autorisé."
::msgcat::mcset pb_msg_french "MC(msg,not_cdl_file)"                   "Seul un fichier CDL est autorisé."
::msgcat::mcset pb_msg_french "MC(msg,not_def_file)"                   "Seul un fichier DEF est autorisé."
::msgcat::mcset pb_msg_french "MC(msg,not_own_cdl_file)"               "Seul son propre fichier CDL est autorisé."
::msgcat::mcset pb_msg_french "MC(msg,no_cdl_file)"                    "Le Post sélectionné n'a pas de fichier CDL associé."
::msgcat::mcset pb_msg_french "MC(msg,cdl_info)"                       "Les fichiers CDL et de définition du Post sélectionné seront référencés (INCLUDE) dans le fichier de définition de ce Post.\n Le fichier TCL du Post sélectionné sera également exécuté par le fichier de fonction d'événement de ce Post au moment du lancement de l'application."

::msgcat::mcset pb_msg_french "MC(msg,add_max1)"                       "Valeur maximale de l'adresse"
::msgcat::mcset pb_msg_french "MC(msg,add_max2)"                       "ne doit pas excéder la capacité de son format, soit"


::msgcat::mcset pb_msg_french "MC(com,text_entry_trans,title,Label)"   "Entrée"

##---------------------------
## Common Navigation Buttons
##
::msgcat::mcset pb_msg_french "MC(nav_button,no_license,Message)"      "Pas de licence appropriée pour exécuter cette fonction."

::msgcat::mcset pb_msg_french "MC(nav_button,ok,Label)"                "OK"
::msgcat::mcset pb_msg_french "MC(nav_button,ok,Context)"              "Ce bouton n'est disponible que sur un sous-dialogue. Il permet d'enregistrer les modifications et de quitter le dialogue."
::msgcat::mcset pb_msg_french "MC(nav_button,cancel,Label)"            "Annuler"
::msgcat::mcset pb_msg_french "MC(nav_button,cancel,Context)"          "Ce bouton n'est disponible que sur un sous-dialogue. Il permet d'enregistrer les et de quitter le dialogue."
::msgcat::mcset pb_msg_french "MC(nav_button,default,Label)"           "Défaut"
::msgcat::mcset pb_msg_french "MC(nav_button,default,Context)"         "Ce bouton permet de rétablir les paramètres d'un composant sur cette boîte de dialogue, aux valeurs qu'ils avaient lorsque le Post a été créé ou ouvert pour la première fois. \n \nToutefois, le nom du composant en question, s'il est présent, sera seulement rétabli à l'état initial de la visite en cours."
::msgcat::mcset pb_msg_french "MC(nav_button,restore,Label)"           "Rétablir"
::msgcat::mcset pb_msg_french "MC(nav_button,restore,Context)"         "Ce bouton permet de rétablir les paramètres sur cette boîte de dialogue, aux valeurs initiales de la visite en cours de ce composant. "
::msgcat::mcset pb_msg_french "MC(nav_button,apply,Label)"             "Appliquer"
::msgcat::mcset pb_msg_french "MC(nav_button,apply,Context)"           "Ce bouton permet de sauvegarder les modifications sans quitter le dialogue actuel. Il rétablira également la condition initiale du présent dialogue. \n \n(Se reporter à Rétablir à propos de la nécessité de la condition initiale)"
::msgcat::mcset pb_msg_french "MC(nav_button,filter,Label)"            "Filtre"
::msgcat::mcset pb_msg_french "MC(nav_button,filter,Context)"          "Ce bouton appliquera le filtre de répertoire et donnera la liste des fichiers qui satisfont à la condition."
::msgcat::mcset pb_msg_french "MC(nav_button,yes,Label)"               "Oui"
::msgcat::mcset pb_msg_french "MC(nav_button,yes,Context)"             "Oui"
::msgcat::mcset pb_msg_french "MC(nav_button,no,Label)"                "Non"
::msgcat::mcset pb_msg_french "MC(nav_button,no,Context)"              "Non"
::msgcat::mcset pb_msg_french "MC(nav_button,help,Label)"              "Aide"
::msgcat::mcset pb_msg_french "MC(nav_button,help,Context)"            "Aide"

::msgcat::mcset pb_msg_french "MC(nav_button,open,Label)"              "Ouvrir"
::msgcat::mcset pb_msg_french "MC(nav_button,open,Context)"            "Ce bouton permet d'ouvrir le Post sélectionné pour l'éditer."

::msgcat::mcset pb_msg_french "MC(nav_button,save,Label)"              "Enregistrer"
::msgcat::mcset pb_msg_french "MC(nav_button,save,Context)"            "Ce bouton est disponible sur la boîte de dialogue Enregistrer sous pour permettre de sauvegarder le Post en cours."

::msgcat::mcset pb_msg_french "MC(nav_button,manage,Label)"            "Gérer..."
::msgcat::mcset pb_msg_french "MC(nav_button,manage,Context)"          "Ce bouton permet de gérer l'historique des Posts récemment visités."

::msgcat::mcset pb_msg_french "MC(nav_button,refresh,Label)"           "Actualiser"
::msgcat::mcset pb_msg_french "MC(nav_button,refresh,Context)"         "Ce bouton actualise la liste en fonction de l'existence des objets."

::msgcat::mcset pb_msg_french "MC(nav_button,cut,Label)"               "Couper"
::msgcat::mcset pb_msg_french "MC(nav_button,cut,Context)"             "Ce bouton retire l'objet sélectionné de la liste."

::msgcat::mcset pb_msg_french "MC(nav_button,copy,Label)"              "Copier"
::msgcat::mcset pb_msg_french "MC(nav_button,copy,Context)"            "Ce bouton copie l'objet sélectionné."

::msgcat::mcset pb_msg_french "MC(nav_button,paste,Label)"             "Coller"
::msgcat::mcset pb_msg_french "MC(nav_button,paste,Context)"           "Ce bouton colle l'objet du presse-papiers dans la liste."

::msgcat::mcset pb_msg_french "MC(nav_button,edit,Label)"              "Editer"
::msgcat::mcset pb_msg_french "MC(nav_button,edit,Context)"            "Ce bouton édite l'objet dans le presse-papiers."

::msgcat::mcset pb_msg_french "MC(nav_button,ex_editor,Label)"         "Utiliser l'Editeur externe"

##------------
## New dialog
##
::msgcat::mcset pb_msg_french "MC(new,title,Label)"                    "Créer un nouveau Post-Processeur"
::msgcat::mcset pb_msg_french "MC(new,Status)"                         "Saisir le nom et sélectionner le paramètre pour le nouveau Post."

::msgcat::mcset pb_msg_french "MC(new,name,Label)"                     "Nom du Post"
::msgcat::mcset pb_msg_french "MC(new,name,Context)"                   "Nom du Post-Processeur à créer"

::msgcat::mcset pb_msg_french "MC(new,desc,Label)"                     "Description"
::msgcat::mcset pb_msg_french "MC(new,desc,Context)"                   "Description du Post-Processeur à créer"

#Description for each selection
::msgcat::mcset pb_msg_french "MC(new,mill,desc,Label)"                "Fraiseuse."
::msgcat::mcset pb_msg_french "MC(new,lathe,desc,Label)"               "Tour."
::msgcat::mcset pb_msg_french "MC(new,wedm,desc,Label)"                "Machine à électro-érosion à fil."

::msgcat::mcset pb_msg_french "MC(new,wedm_2,desc,Label)"              "Machine à électro-érosion à fil 2 axes."
::msgcat::mcset pb_msg_french "MC(new,wedm_4,desc,Label)"              "Machine à électro-érosion à fil 4 axes."
::msgcat::mcset pb_msg_french "MC(new,lathe_2,desc,Label)"             "Tour horizontal 2 axes."
::msgcat::mcset pb_msg_french "MC(new,lathe_4,desc,Label)"             "Tour 4 axes dépendants."
::msgcat::mcset pb_msg_french "MC(new,mill_3,desc,Label)"              "Fraiseuse 3 axes."
::msgcat::mcset pb_msg_french "MC(new,mill_3MT,desc,Label)"            "Fraisage-tournage 3 axes (XZC)"
::msgcat::mcset pb_msg_french "MC(new,mill_4H,desc,Label)"             "Fraiseuse 4 axes avec\n tête de rotation."
::msgcat::mcset pb_msg_french "MC(new,mill_4T,desc,Label)"             "Fraiseuse 4 axes avec\n table de rotation."
::msgcat::mcset pb_msg_french "MC(new,mill_5TT,desc,Label)"            "Fraiseuse 5 axes avec\n tables à double rotation."
::msgcat::mcset pb_msg_french "MC(new,mill_5HH,desc,Label)"            "Fraiseuse 5 axes avec\n têtes à double rotation."
::msgcat::mcset pb_msg_french "MC(new,mill_5HT,desc,Label)"            "Fraiseuse 5 axes avec\n table et tête de rotation."
::msgcat::mcset pb_msg_french "MC(new,punch,desc,Label)"               "Machine de poinçonnage."

::msgcat::mcset pb_msg_french "MC(new,post_unit,Label)"                "Unité de sortie du Post"

::msgcat::mcset pb_msg_french "MC(new,inch,Label)"                     "Pouces"
::msgcat::mcset pb_msg_french "MC(new,inch,Context)"                   "Unité de sortie du post-processeur en pouces"
::msgcat::mcset pb_msg_french "MC(new,millimeter,Label)"               "Millimètres"
::msgcat::mcset pb_msg_french "MC(new,millimeter,Context)"             "Unité de sortie du post-processeur en millimètres"

::msgcat::mcset pb_msg_french "MC(new,machine,Label)"                  "Machine-outil"
::msgcat::mcset pb_msg_french "MC(new,machine,Context)"                "Type de machine-outil pour laquelle est créé le Post-Processeur."

::msgcat::mcset pb_msg_french "MC(new,mill,Label)"                     "Fraiseuse"
::msgcat::mcset pb_msg_french "MC(new,mill,Context)"                   "Machine pour fraisage"
::msgcat::mcset pb_msg_french "MC(new,lathe,Label)"                    "Tour"
::msgcat::mcset pb_msg_french "MC(new,lathe,Context)"                  "Machine pour tournage"
::msgcat::mcset pb_msg_french "MC(new,wire,Label)"                     "Electro-érosion à fil"
::msgcat::mcset pb_msg_french "MC(new,wire,Context)"                   "Machine pour Electro-érosion à fil"
::msgcat::mcset pb_msg_french "MC(new,punch,Label)"                    "Poinçonneuse"

::msgcat::mcset pb_msg_french "MC(new,axis,Label)"                     "Sélection des axes machine"
::msgcat::mcset pb_msg_french "MC(new,axis,Context)"                   "Nombre et type des axes machine"

#Axis Number
::msgcat::mcset pb_msg_french "MC(new,axis_2,Label)"                   "2 axes"
::msgcat::mcset pb_msg_french "MC(new,axis_3,Label)"                   "3 axes"
::msgcat::mcset pb_msg_french "MC(new,axis_4,Label)"                   "4 axes"
::msgcat::mcset pb_msg_french "MC(new,axis_5,Label)"                   "5 axes"
::msgcat::mcset pb_msg_french "MC(new,axis_XZC,Label)"                 "XZC"


#Axis Type
::msgcat::mcset pb_msg_french "MC(new,mach_axis,Label)"                "Axe de machine-outil"
::msgcat::mcset pb_msg_french "MC(new,mach_axis,Context)"              "Sélectionner l'axe de machine-outil"
::msgcat::mcset pb_msg_french "MC(new,lathe_2,Label)"                  "2 axes"
::msgcat::mcset pb_msg_french "MC(new,mill_3,Label)"                   "3 axes"
::msgcat::mcset pb_msg_french "MC(new,mill_3MT,Label)"                 "Fraisage-tournage 3 axes (XZC)"
::msgcat::mcset pb_msg_french "MC(new,mill_4T,Label)"                  "4 axes avec table de rotation"
::msgcat::mcset pb_msg_french "MC(new,mill_4H,Label)"                  "4 axes avec tête de rotation"
::msgcat::mcset pb_msg_french "MC(new,lathe_4,Label)"                  "4 axes"
::msgcat::mcset pb_msg_french "MC(new,mill_5HH,Label)"                 "5 axes avec têtes à double rotation"
::msgcat::mcset pb_msg_french "MC(new,mill_5TT,Label)"                 "5 axes avec tables à double rotation"
::msgcat::mcset pb_msg_french "MC(new,mill_5HT,Label)"                 "5 axes avec tête et table de rotation"
::msgcat::mcset pb_msg_french "MC(new,wedm_2,Label)"                   "2 axes"
::msgcat::mcset pb_msg_french "MC(new,wedm_4,Label)"                   "4 axes"
::msgcat::mcset pb_msg_french "MC(new,punch,Label)"                    "Poinçonneuse"

::msgcat::mcset pb_msg_french "MC(new,control,Label)"                  "Contrôle numérique"
::msgcat::mcset pb_msg_french "MC(new,control,Context)"                "Sélectionner le contrôle numérique Post."

#Controller Type
::msgcat::mcset pb_msg_french "MC(new,generic,Label)"                  "Générique"
::msgcat::mcset pb_msg_french "MC(new,library,Label)"                  "Bibliothèque"
::msgcat::mcset pb_msg_french "MC(new,user,Label)"                     "Utilisateur"
::msgcat::mcset pb_msg_french "MC(new,user,browse,Label)"              "Parcourir"

# - Machine tool/ controller brands
::msgcat::mcset pb_msg_french "MC(new,allen,Label)"                    "Allen Bradley"
::msgcat::mcset pb_msg_french "MC(new,bridge,Label)"                   "Bridgeport"
::msgcat::mcset pb_msg_french "MC(new,brown,Label)"                    "Brown & Sharp"
::msgcat::mcset pb_msg_french "MC(new,cincin,Label)"                   "Cincinnati Milacron"
::msgcat::mcset pb_msg_french "MC(new,kearny,Label)"                   "Kearny & Tracker"
::msgcat::mcset pb_msg_french "MC(new,fanuc,Label)"                    "Fanuc"
::msgcat::mcset pb_msg_french "MC(new,ge,Label)"                       "General Electric"
::msgcat::mcset pb_msg_french "MC(new,gn,Label)"                       "General Numerics"
::msgcat::mcset pb_msg_french "MC(new,gidding,Label)"                  "Gidding & Lewis"
::msgcat::mcset pb_msg_french "MC(new,heiden,Label)"                   "Heidenhain"
::msgcat::mcset pb_msg_french "MC(new,mazak,Label)"                    "Mazak"
::msgcat::mcset pb_msg_french "MC(new,seimens,Label)"                  "Siemens"

##-------------
## Open dialog
##
::msgcat::mcset pb_msg_french "MC(open,title,Label)"                   "Editer le Post"
::msgcat::mcset pb_msg_french "MC(open,Status)"                        "Choisir le fichier PUI à ouvrir."
::msgcat::mcset pb_msg_french "MC(open,file_type_pui)"                 "Fichiers de session Post Builder"
::msgcat::mcset pb_msg_french "MC(open,file_type_tcl)"                 "Fichiers script TCL"
::msgcat::mcset pb_msg_french "MC(open,file_type_def)"                 "Fichiers de définition"
::msgcat::mcset pb_msg_french "MC(open,file_type_cdl)"                 "Fichiers CDL"

##-------------
## Misc dialog
##
::msgcat::mcset pb_msg_french "MC(open_save,dlg,title,Label)"          "Sélectionnez un fichier"
::msgcat::mcset pb_msg_french "MC(exp_cc,dlg,title,Label)"             "Exporter des commandes personnalisées"
::msgcat::mcset pb_msg_french "MC(show_mt,title,Label)"                "Machine-outil"

##----------------
## Utils dialog
##
::msgcat::mcset pb_msg_french "MC(mvb,title,Label)"                    "Navigateur de variables MOM"
::msgcat::mcset pb_msg_french "MC(mvb,cat,Label)"                      "Catégorie"
::msgcat::mcset pb_msg_french "MC(mvb,search,Label)"                   "Rechercher"
::msgcat::mcset pb_msg_french "MC(mvb,defv,Label)"                     "Valeur par défaut"
::msgcat::mcset pb_msg_french "MC(mvb,posv,Label)"                     "Valeurs possibles"
::msgcat::mcset pb_msg_french "MC(mvb,data,Label)"                     "Type de donnée"
::msgcat::mcset pb_msg_french "MC(mvb,desc,Label)"                     "Description"

::msgcat::mcset pb_msg_french "MC(inposts,title,Label)"                "Editer template_post.dat"
::msgcat::mcset pb_msg_french "MC(tpdf,text,Label)"                    "Editer le fichier de données de modèles-type Post"
::msgcat::mcset pb_msg_french "MC(inposts,edit,title,Label)"           "Editer une ligne"
::msgcat::mcset pb_msg_french "MC(inposts,edit,post,Label)"            "Post"


##----------------
## Save As dialog
##
::msgcat::mcset pb_msg_french "MC(save_as,title,Label)"                "Enregistrer sous"
::msgcat::mcset pb_msg_french "MC(save_as,name,Label)"                 "Nom du Post"
::msgcat::mcset pb_msg_french "MC(save_as,name,Context)"               "Le nom sous lequel sauvegarder le Post-Processeur."
::msgcat::mcset pb_msg_french "MC(save_as,Status)"                     "Saisir le nom de fichier du nouveau Post."
::msgcat::mcset pb_msg_french "MC(save_as,file_type_pui)"              "Fichiers de session Post Builder"

##----------------
## Common Widgets
##
::msgcat::mcset pb_msg_french "MC(common,entry,Label)"                 "Entrée"
::msgcat::mcset pb_msg_french "MC(common,entry,Context)"               "Vous spécifierez la nouvelle valeur dans le champ de saisie."

##-----------
## Note Book
##
::msgcat::mcset pb_msg_french "MC(nbook,tab,Label)"                    "Onglet"
::msgcat::mcset pb_msg_french "MC(nbook,tab,Context)"                  "Vous pouvez sélectionner un onglet pour aller à la page de paramètres souhaitée. \n \nLes paramètres situés sous un onglet se répartissent en groupes. Chaque groupe de paramètres est accessible via un autre onglet."

##------
## Tree
##
::msgcat::mcset pb_msg_french "MC(tree,select,Label)"                  "Arborescence de composants"
::msgcat::mcset pb_msg_french "MC(tree,select,Context)"                "Vous pouvez sélectionner un composant pour consulter ou éditer son contenu ou ses paramètres."
::msgcat::mcset pb_msg_french "MC(tree,create,Label)"                  "Créer"
::msgcat::mcset pb_msg_french "MC(tree,create,Context)"                "Créer un nouveau composant en copiant l'article sélectionné."
::msgcat::mcset pb_msg_french "MC(tree,cut,Label)"                     "Couper"
::msgcat::mcset pb_msg_french "MC(tree,cut,Context)"                   "Couper un composant."
::msgcat::mcset pb_msg_french "MC(tree,paste,Label)"                   "Coller"
::msgcat::mcset pb_msg_french "MC(tree,paste,Context)"                 "Coller un composant."
::msgcat::mcset pb_msg_french "MC(tree,rename,Label)"                  "Renommer"

##------------------
## Encrypt dialogs
##
::msgcat::mcset pb_msg_french "MC(encrypt,browser,Label)"              "Liste des licences"
::msgcat::mcset pb_msg_french "MC(encrypt,title,Label)"                "Sélectionner une licence"
::msgcat::mcset pb_msg_french "MC(encrypt,output,Label)"               "Crypter la sortie"
::msgcat::mcset pb_msg_french "MC(encrypt,license,Label)"              "Licence :  "

#++++++++++++++
# Machine Tool
#++++++++++++++
::msgcat::mcset pb_msg_french "MC(machine,tab,Label)"                  "Machine-outil"
::msgcat::mcset pb_msg_french "MC(machine,Status)"                     "Spécifier les paramètres cinématiques de la machine."

::msgcat::mcset pb_msg_french "MC(msg,no_display)"                     "L'image de configuration de cette machine-outil n'est pas disponible."
::msgcat::mcset pb_msg_french "MC(msg,no_4th_ctable)"                  "Le 4ème axe C ne peut pas être une table."
::msgcat::mcset pb_msg_french "MC(msg,no_4th_max_min)"                 "La limite maxi du 4ème axe ne peut pas être égale à la limite mini de l'axe."
::msgcat::mcset pb_msg_french "MC(msg,no_4th_both_neg)"                "Les limites du 4ème axe ne peuvent pas être toutes deux négatives."
::msgcat::mcset pb_msg_french "MC(msg,no_4th_5th_plane)"               "Le plan du 4ème axe ne peut pas être identique à celui du 5ème axe."
::msgcat::mcset pb_msg_french "MC(msg,no_4thT_5thH)"                   "4ème axe table et 5ème axe tête: non autorisé."
::msgcat::mcset pb_msg_french "MC(msg,no_5th_max_min)"                 "La limite maxi du 5ème axe ne peut pas être égale à la limite mini de l'axe."
::msgcat::mcset pb_msg_french "MC(msg,no_5th_both_neg)"                "Les limites du 5ème axe ne peuvent pas être toutes deux négatives."

##---------
# Post Info
##
::msgcat::mcset pb_msg_french "MC(machine,info,title,Label)"           "Informations sur Post"
::msgcat::mcset pb_msg_french "MC(machine,info,desc,Label)"            "Description"
::msgcat::mcset pb_msg_french "MC(machine,info,type,Label)"            "Type de machine"
::msgcat::mcset pb_msg_french "MC(machine,info,kinematics,Label)"      "Cinématique"
::msgcat::mcset pb_msg_french "MC(machine,info,unit,Label)"            "Unité de sortie"
::msgcat::mcset pb_msg_french "MC(machine,info,controller,Label)"      "Contrôle numérique"
::msgcat::mcset pb_msg_french "MC(machine,info,history,Label)"         "Historique"

##---------
## Display
##
::msgcat::mcset pb_msg_french "MC(machine,display,Label)"              "Afficher la machine-outil"
::msgcat::mcset pb_msg_french "MC(machine,display,Context)"            "Cette option affiche la machine-outil"
::msgcat::mcset pb_msg_french "MC(machine,display_trans,title,Label)"  "Machine-outil"


##---------------
## General parms
##
::msgcat::mcset pb_msg_french "MC(machine,gen,Label)"                      "Paramètres généraux"
    
::msgcat::mcset pb_msg_french "MC(machine,gen,out_unit,Label)"             "Unité de sortie du Post :"
::msgcat::mcset pb_msg_french "MC(machine,gen,out_unit,Context)"           "Unité de sortie du Post-Processeur"
::msgcat::mcset pb_msg_french "MC(machine,gen,out_unit,inch,Label)"        "Inch" 
::msgcat::mcset pb_msg_french "MC(machine,gen,out_unit,metric,Label)"      "Métrique"

::msgcat::mcset pb_msg_french "MC(machine,gen,travel_limit,Label)"         "Limites de course des axes linéaires"
::msgcat::mcset pb_msg_french "MC(machine,gen,travel_limit,Context)"       "Limites de course des axes linéaires"
::msgcat::mcset pb_msg_french "MC(machine,gen,travel_limit,x,Label)"       "X"
::msgcat::mcset pb_msg_french "MC(machine,gen,travel_limit,x,Context)"     "Spécifier la limite de course machine sur l'axe X."
::msgcat::mcset pb_msg_french "MC(machine,gen,travel_limit,y,Label)"       "Y"
::msgcat::mcset pb_msg_french "MC(machine,gen,travel_limit,y,Context)"     "Spécifier la limite de course machine sur l'axe Y."
::msgcat::mcset pb_msg_french "MC(machine,gen,travel_limit,z,Label)"       "Z"
::msgcat::mcset pb_msg_french "MC(machine,gen,travel_limit,z,Context)"     "Spécifier la limite de course machine sur l'axe Z."

::msgcat::mcset pb_msg_french "MC(machine,gen,home_pos,Label)"             "Position Home"
::msgcat::mcset pb_msg_french "MC(machine,gen,home_pos,Context)"           "Position Home"
::msgcat::mcset pb_msg_french "MC(machine,gen,home_pos,x,Label)"           "X"
::msgcat::mcset pb_msg_french "MC(machine,gen,home_pos,x,Context)"         "La position Retour machine sur l'axe X par rapport au zéro physique de l'axe. La machine revient à cette position pour le changement d'outil automatique."
::msgcat::mcset pb_msg_french "MC(machine,gen,home_pos,y,Label)"           "Y"
::msgcat::mcset pb_msg_french "MC(machine,gen,home_pos,y,Context)"         "La position Retour machine sur l'axe Y par rapport au zéro physique de l'axe. La machine revient à cette position pour le changement d'outil automatique."
::msgcat::mcset pb_msg_french "MC(machine,gen,home_pos,z,Label)"           "Z"
::msgcat::mcset pb_msg_french "MC(machine,gen,home_pos,z,Context)"         "La position Retour machine sur l'axe Z par rapport au zéro physique de l'axe. La machine revient à cette position pour le changement d'outil automatique."

::msgcat::mcset pb_msg_french "MC(machine,gen,step_size,Label)"            "Résolution des mouvements linéaires"
::msgcat::mcset pb_msg_french "MC(machine,gen,step_size,min,Label)"        "Minimum"
::msgcat::mcset pb_msg_french "MC(machine,gen,step_size,min,Context)"      "Résolution mini"

::msgcat::mcset pb_msg_french "MC(machine,gen,traverse_feed,Label)"        "Avance de franchissement"
::msgcat::mcset pb_msg_french "MC(machine,gen,traverse_feed,max,Label)"    "Maximum"
::msgcat::mcset pb_msg_french "MC(machine,gen,traverse_feed,max,Context)"  "Avance maxi"

::msgcat::mcset pb_msg_french "MC(machine,gen,circle_record,Label)"        "Générer une instruction circulaire"
::msgcat::mcset pb_msg_french "MC(machine,gen,circle_record,yes,Label)"    "Oui"
::msgcat::mcset pb_msg_french "MC(machine,gen,circle_record,yes,Context)"  "Générer une instruction circulaire."
::msgcat::mcset pb_msg_french "MC(machine,gen,circle_record,no,Label)"     "Non"
::msgcat::mcset pb_msg_french "MC(machine,gen,circle_record,no,Context)"   "Générer une instruction linéaire."

::msgcat::mcset pb_msg_french "MC(machine,gen,config_4and5_axis,oth,Label)"    "Autre"

# Wire EDM parameters
::msgcat::mcset pb_msg_french "MC(machine,gen,wedm,wire_tilt)"             "Contrôle de l'inclinaison du fil"
::msgcat::mcset pb_msg_french "MC(machine,gen,wedm,angle)"                 "Angles"
::msgcat::mcset pb_msg_french "MC(machine,gen,wedm,coord)"                 "Coordonnées"

# Lathe parameters
::msgcat::mcset pb_msg_french "MC(machine,gen,turret,Label)"               "Tourelle"
::msgcat::mcset pb_msg_french "MC(machine,gen,turret,Context)"             "Tourelle"
::msgcat::mcset pb_msg_french "MC(machine,gen,turret,conf,Label)"          "Configurer"
::msgcat::mcset pb_msg_french "MC(machine,gen,turret,conf,Context)"        "Lorsque Deux tourelles est sélectionné,  cette option permet de configurer les paramètres."
::msgcat::mcset pb_msg_french "MC(machine,gen,turret,one,Label)"           "Une tourelle"
::msgcat::mcset pb_msg_french "MC(machine,gen,turret,one,Context)"         "Tour à une tourelle"
::msgcat::mcset pb_msg_french "MC(machine,gen,turret,two,Label)"           "Deux tourelles"
::msgcat::mcset pb_msg_french "MC(machine,gen,turret,two,Context)"         "Tour à deux tourelles"

::msgcat::mcset pb_msg_french "MC(machine,gen,turret,conf_trans,Label)"    "Configuration des tourelles"
::msgcat::mcset pb_msg_french "MC(machine,gen,turret,prim,Label)"          "Tourelle principale"
::msgcat::mcset pb_msg_french "MC(machine,gen,turret,prim,Context)"        "Sélectionner la désignation de la tourelle principale."
::msgcat::mcset pb_msg_french "MC(machine,gen,turret,sec,Label)"           "Tourelle secondaire"
::msgcat::mcset pb_msg_french "MC(machine,gen,turret,sec,Context)"         "Sélectionner la désignation de la tourelle secondaire."
::msgcat::mcset pb_msg_french "MC(machine,gen,turret,designation,Label)"   "Désignation"
::msgcat::mcset pb_msg_french "MC(machine,gen,turret,xoff,Label)"          "Décalage en X"
::msgcat::mcset pb_msg_french "MC(machine,gen,turret,xoff,Context)"        "Spécifier le décalage en X."
::msgcat::mcset pb_msg_french "MC(machine,gen,turret,zoff,Label)"          "Décalage en Z"
::msgcat::mcset pb_msg_french "MC(machine,gen,turret,zoff,Context)"        "Spécifier le décalage en Z."

::msgcat::mcset pb_msg_french "MC(machine,gen,turret,front,Label)"         "AVANT"
::msgcat::mcset pb_msg_french "MC(machine,gen,turret,rear,Label)"          "ARRIÈRE"
::msgcat::mcset pb_msg_french "MC(machine,gen,turret,right,Label)"         "DROITE"
::msgcat::mcset pb_msg_french "MC(machine,gen,turret,left,Label)"          "GAUCHE"
::msgcat::mcset pb_msg_french "MC(machine,gen,turret,side,Label)"          "COTÉ"
::msgcat::mcset pb_msg_french "MC(machine,gen,turret,saddle,Label)"        "CHARIOT"

::msgcat::mcset pb_msg_french "MC(machine,gen,axis_multi,Label)"           "Multiplicateurs d'axe"
::msgcat::mcset pb_msg_french "MC(machine,gen,axis_multi,dia,Label)"       "Programmation au diamètre "
::msgcat::mcset pb_msg_french "MC(machine,gen,axis_multi,dia,Context)"     "Ces options permettent d'activer la programmation au diamètre en doublant les valeurs des adresses sélectionnées dans la sortie CN."
::msgcat::mcset pb_msg_french "MC(machine,gen,axis_multi,2x,Label)"        "2X"
::msgcat::mcset pb_msg_french "MC(machine,gen,axis_multi,2x,Context)"      "Cette bascule permet d'activer la programmation au diamètre en doublant les coordonnées sur l'axe X dans la sortie CN."

::msgcat::mcset pb_msg_french "MC(machine,gen,axis_multi,2y,Label)"        "2Y"
::msgcat::mcset pb_msg_french "MC(machine,gen,axis_multi,2y,Context)"      "Cette bascule permet d'activer la programmation au diamètre en doublant les coordonnées sur l'axe Y dans la sortie CN."
::msgcat::mcset pb_msg_french "MC(machine,gen,axis_multi,2i,Label)"        "2I"
::msgcat::mcset pb_msg_french "MC(machine,gen,axis_multi,2i,Context)"      "Cette bascule permet de doubler les valeurs I des instructions circulaires en cas de programmation au diamètre."
::msgcat::mcset pb_msg_french "MC(machine,gen,axis_multi,2j,Label)"        "2J"
::msgcat::mcset pb_msg_french "MC(machine,gen,axis_multi,2j,Context)"      "Cette bascule permet de doubler les valeurs J des instructions circulaires en cas de programmation au diamètre."

::msgcat::mcset pb_msg_french "MC(machine,gen,axis_multi,mir,Label)"       "Sortie miroir"
::msgcat::mcset pb_msg_french "MC(machine,gen,axis_multi,mir,Context)"     "Ces options permettent d'obtenir le symétrique des adresses sélectionnées en écrivant la valeur opposée dans la sortie CN."
::msgcat::mcset pb_msg_french "MC(machine,gen,axis_multi,x,Label)"         "-X"
::msgcat::mcset pb_msg_french "MC(machine,gen,axis_multi,x,Context)"       "Cette bascule permet d'écrire les valeurs opposées des coordonnées sur l'axe X dans la sortie CN."
::msgcat::mcset pb_msg_french "MC(machine,gen,axis_multi,y,Label)"         "-Y"
::msgcat::mcset pb_msg_french "MC(machine,gen,axis_multi,y,Context)"       "Cette bascule permet d'écrire les valeurs opposées des coordonnées sur l'axe Y dans la sortie CN."
::msgcat::mcset pb_msg_french "MC(machine,gen,axis_multi,z,Label)"         "-Z"
::msgcat::mcset pb_msg_french "MC(machine,gen,axis_multi,z,Context)"       "Cette bascule permet d'écrire les valeurs opposées des coordonnées sur l'axe Z dans la sortie CN."
::msgcat::mcset pb_msg_french "MC(machine,gen,axis_multi,i,Label)"         "-I"
::msgcat::mcset pb_msg_french "MC(machine,gen,axis_multi,i,Context)"       "Cette bascule permet d'écrire les valeurs I opposées pour les instructions circulaires dans la sortie CN."
::msgcat::mcset pb_msg_french "MC(machine,gen,axis_multi,j,Label)"         "-J"
::msgcat::mcset pb_msg_french "MC(machine,gen,axis_multi,j,Context)"       "Cette bascule permet d'écrire les valeurs J opposées pour les instructions circulaires dans la sortie CN."
::msgcat::mcset pb_msg_french "MC(machine,gen,axis_multi,k,Label)"         "-K"
::msgcat::mcset pb_msg_french "MC(machine,gen,axis_multi,k,Context)"       "Cette bascule permet d'écrire les valeurs K opposées pour les instructions circulaires dans la sortie CN."

::msgcat::mcset pb_msg_french "MC(machine,gen,output,Label)"               "Méthode de sortie"
::msgcat::mcset pb_msg_french "MC(machine,gen,output,Context)"             "Méthode de sortie"
::msgcat::mcset pb_msg_french "MC(machine,gen,output,tool_tip,Label)"      "Pointe d'outil"
::msgcat::mcset pb_msg_french "MC(machine,gen,output,tool_tip,Context)"    "Sortie par rapport à la pointe d'outil"
::msgcat::mcset pb_msg_french "MC(machine,gen,output,turret_ref,Label)"    "Référence tourelle"
::msgcat::mcset pb_msg_french "MC(machine,gen,output,turret_ref,Context)"  "Sortie par rapport à la référence tourelle"

::msgcat::mcset pb_msg_french "MC(machine,gen,lathe_turret,msg)"           "La désignation de la tourelle principale ne peut pas être identique à celle de la tourelle secondaire."
::msgcat::mcset pb_msg_french "MC(machine,gen,turret_chg,msg)"             "Changer cette option peut nécessiter l'ajout ou la suppression d'un bloc G92 dans les événements de changement d'outil."
# Entries for XZC/Mill-Turn
::msgcat::mcset pb_msg_french "MC(machine,gen,spindle_axis,Label)"             "Axe initial de la broche"
::msgcat::mcset pb_msg_french "MC(machine,gen,spindle_axis,Context)"           "L'axe initial de la broche désigné pour l'outil de fraisage actif peut être spécifié parallèle à l'axe Z ou perpendiculaire à l'axe Z. L'axe d'outil de l'opération doit être cohérent avec l'axe de broche spécifié. Une erreur se produira si le Post ne peut pas atteindre l'axe de broche spécifié. \nCe vecteur peut être remplacé par l'axe de broche spécifié avec une tête."

::msgcat::mcset pb_msg_french "MC(machine,gen,position_in_yaxis,Label)"        "Position sur l'axe Y"
::msgcat::mcset pb_msg_french "MC(machine,gen,position_in_yaxis,Context)"      "La machine a un axe Y programmable pouvant se déplacer lors du contournage. Cette option ne s'applique que si l'axe de broche n'est pas situé suivant l'axe Z."

::msgcat::mcset pb_msg_french "MC(machine,gen,mach_mode,Label)"                "Type d'usinage"
::msgcat::mcset pb_msg_french "MC(machine,gen,mach_mode,Context)"              "Le type d'usinage est soit Fraisage-XZC soit Fraisage-tournage simple."

::msgcat::mcset pb_msg_french "MC(machine,gen,mach_mode,xzc_mill,Label)"       "Fraisage XZC"
::msgcat::mcset pb_msg_french "MC(machine,gen,mach_mode,xzc_mill,Context)"     "Pour un fraisage XZC, une table ou une face du mandrin est assujettie à une machine de fraisage-tournage pour l'axe C. Tous les mouvements XY seront convertis en X et C, X étant une valeur de rayon et C une valeur d'angle."

::msgcat::mcset pb_msg_french "MC(machine,gen,mach_mode,mill_turn,Label)"      "Fraisage-tournage simple"
::msgcat::mcset pb_msg_french "MC(machine,gen,mach_mode,mill_turn,Context)"    "Ce Post de fraisage XZC sera lié à un Post de tournage pour traiter un programme contenant à la fois des opérations de fraisage et de tournage. Le type d'opération détermine quel Post utiliser pour générer les sorties CN."

::msgcat::mcset pb_msg_french "MC(machine,gen,mill_turn,lathe_post,Label)"     "Post de tournage"
::msgcat::mcset pb_msg_french "MC(machine,gen,mill_turn,lathe_post,Context)"   "Un Post de tournage est nécessaire pour un Post de fraisage-tournage simple, pour post-traiter les opérations de tournage d'un programme."

::msgcat::mcset pb_msg_french "MC(machine,gen,lathe_post,select_name,Label)"   "Sélect. Nom"
::msgcat::mcset pb_msg_french "MC(machine,gen,lathe_post,select_name,Context)" "Sélectionner le nom d'un Post de tournage à utiliser dans un Post de fraisage-tournage simple. Il est supposé que ce Post est situé dans le répertoire \\\$UGII_CAM_POST_DIR au moment de l'exécution de NX/Post, sinon sera utilisé un Post de même nom situé dans le répertoire du Post de fraisage."

::msgcat::mcset pb_msg_french "MC(machine,gen,coord_mode,Label)"               "Mode de coordonnées par défaut"
::msgcat::mcset pb_msg_french "MC(machine,gen,coord_mode,Context)"             "Ces options définissent le paramétrage initial du mode de sortie des coordonnées: Polaires (XZC) ou cartésiennes (XYZ). Ce mode peut être modifié par les UDE \\\"SET/POLAR,ON\\\" programmés avec des opérations."

::msgcat::mcset pb_msg_french "MC(machine,gen,coord_mode,polar,Label)"         "Polaires"
::msgcat::mcset pb_msg_french "MC(machine,gen,coord_mode,polar,Context)"       "Sortie des coordonnée en XZC."

::msgcat::mcset pb_msg_french "MC(machine,gen,coord_mode,cart,Label)"          "Cartésiennes"
::msgcat::mcset pb_msg_french "MC(machine,gen,coord_mode,cart,Context)"        "Sortie des coordonnée en XYZ."

::msgcat::mcset pb_msg_french "MC(machine,gen,xzc_arc_mode,Label)"             "Mode des instructions circulaires"
::msgcat::mcset pb_msg_french "MC(machine,gen,xzc_arc_mode,Context)"           "Ces options définissent la sortie des instructions circulaires: mode Polaires (XCR) ou Cartésiennes (XYIJ)."

::msgcat::mcset pb_msg_french "MC(machine,gen,xzc_arc_mode,polar,Label)"       "Polaires"
::msgcat::mcset pb_msg_french "MC(machine,gen,xzc_arc_mode,polar,Context)"     "Sortie circulaire en XCR."

::msgcat::mcset pb_msg_french "MC(machine,gen,xzc_arc_mode,cart,Label)"        "Cartésiennes"
::msgcat::mcset pb_msg_french "MC(machine,gen,xzc_arc_mode,cart,Context)"      "Sortie circulaire en XYIJ."

::msgcat::mcset pb_msg_french "MC(machine,gen,def_spindle_axis,Label)"         "Axe initial de la broche"
::msgcat::mcset pb_msg_french "MC(machine,gen,def_spindle_axis,Context)"       "L'axe initial de broche peut être remplacé par l'axe de broche spécifié avec une tête. \nLe vecteur n'est pas nécessairement unitaire."


##-----------------
## 4-th Axis parms
##
::msgcat::mcset pb_msg_french "MC(machine,axis,fourth,Label)"              "Quatrième axe"

::msgcat::mcset pb_msg_french "MC(machine,axis,radius_output,Label)"       "Sortie du rayon"
::msgcat::mcset pb_msg_french "MC(machine,axis,radius_output,Context)"     "Lorsque l'axe outil est suivant l'axe Z (0,0,1), le Post a le choix de sortir la valeur du rayon (X) des coordonnées polaires: soit \\\"Toujours Positif\\\", soit \\\"Toujours Négatif\\\" soit \\\"Plus courte distance\\\"."

::msgcat::mcset pb_msg_french "MC(machine,axis,type_head,Label)"           "Tête"
::msgcat::mcset pb_msg_french "MC(machine,axis,type_table,Label)"          "Table"

##-----------------
## 5-th Axis parms
##
::msgcat::mcset pb_msg_french "MC(machine,axis,fifth,Label)"               "Cinquième axe"

::msgcat::mcset pb_msg_french "MC(machine,axis,rotary,Label)"              "Axe de rotation"

::msgcat::mcset pb_msg_french "MC(machine,axis,offset,Label)"              "Zéro machine -> Centre de l'axe de rotation"
::msgcat::mcset pb_msg_french "MC(machine,axis,offset,4,Label)"            "Zéro machine -> Centre du 4ème axe"
::msgcat::mcset pb_msg_french "MC(machine,axis,offset,5,Label)"            "Centre du 4ème axe -> Centre du 5ème axe"
::msgcat::mcset pb_msg_french "MC(machine,axis,offset,x,Label)"            "Décalage en X"
::msgcat::mcset pb_msg_french "MC(machine,axis,offset,x,Context)"          "Spécifier de décalage en X de l'axe de rotation."
::msgcat::mcset pb_msg_french "MC(machine,axis,offset,y,Label)"            "Décalage en Y"
::msgcat::mcset pb_msg_french "MC(machine,axis,offset,y,Context)"          "Spécifier de décalage en Y de l'axe de rotation."
::msgcat::mcset pb_msg_french "MC(machine,axis,offset,z,Label)"            "Décalage en Z"
::msgcat::mcset pb_msg_french "MC(machine,axis,offset,z,Context)"          "Spécifier de décalage en Z de l'axe de rotation."

::msgcat::mcset pb_msg_french "MC(machine,axis,rotation,Label)"            "Rotation de l'axe"
::msgcat::mcset pb_msg_french "MC(machine,axis,rotation,norm,Label)"       "Normal"
::msgcat::mcset pb_msg_french "MC(machine,axis,rotation,norm,Context)"     "Régler la direction de rotation de l'axe sur Normal."
::msgcat::mcset pb_msg_french "MC(machine,axis,rotation,rev,Label)"        "Inversé"
::msgcat::mcset pb_msg_french "MC(machine,axis,rotation,rev,Context)"      "Régler la direction de rotation de l'axe sur Inversé."

::msgcat::mcset pb_msg_french "MC(machine,axis,direction,Label)"           "Direction de l'axe"
::msgcat::mcset pb_msg_french "MC(machine,axis,direction,Context)"         "Sélectionner la direction de l'axe."

::msgcat::mcset pb_msg_french "MC(machine,axis,con_motion,Label)"              "Mouvements de rotation consécutifs"
::msgcat::mcset pb_msg_french "MC(machine,axis,con_motion,combine,Label)"      "Combinés"
::msgcat::mcset pb_msg_french "MC(machine,axis,con_motion,combine,Context)"    "Cette bascule permet d'activer/désactiver la linéarisation. Elle activera/désactivera l'option de Tolérance."
::msgcat::mcset pb_msg_french "MC(machine,axis,con_motion,tol,Label)"      "Tolérance"
::msgcat::mcset pb_msg_french "MC(machine,axis,con_motion,tol,Context)"    "Cette option est active seulement si la bascule Combinés est active. Spécifier la tolérance."

::msgcat::mcset pb_msg_french "MC(machine,axis,violation,Label)"           "Gestion du non respect des limites d'axe"
::msgcat::mcset pb_msg_french "MC(machine,axis,violation,warn,Label)"      "Avertissement"
::msgcat::mcset pb_msg_french "MC(machine,axis,violation,warn,Context)"    "Ecrire un avertissement en cas de non respect de limite d'axe."
::msgcat::mcset pb_msg_french "MC(machine,axis,violation,ret,Label)"       "Retrait / Réengagement"
::msgcat::mcset pb_msg_french "MC(machine,axis,violation,ret,Context)"     "Retrait / Réengagement en cas de non respect de limite d'axe. \n \nDans la commande personnalisée PB_CMD_init_rotaty, les paramètres suivants peuvent être ajustés pour obtenir les mouvements souhaités: \n \n   mom_kin_retract_type \n   mom_kin_retract_distance \n   mom_kin_reengage_distance"

::msgcat::mcset pb_msg_french "MC(machine,axis,limits,Label)"              "Limites d'axe (deg)"
::msgcat::mcset pb_msg_french "MC(machine,axis,limits,min,Label)"          "Minimum"
::msgcat::mcset pb_msg_french "MC(machine,axis,limits,min,Context)"        "Spécifier la limite mini de l'axe de rotation (deg)."
::msgcat::mcset pb_msg_french "MC(machine,axis,limits,max,Label)"          "Maximum"
::msgcat::mcset pb_msg_french "MC(machine,axis,limits,max,Context)"        "Spécifier la limite maxi de l'axe de rotation (deg)."

::msgcat::mcset pb_msg_french "MC(machine,axis,incr_text)"                 "Cet axe de rotation peut être incrémenté"

::msgcat::mcset pb_msg_french "MC(machine,axis,rotary_res,Label)"          "Résolution du mouvement de rotation (deg)"
::msgcat::mcset pb_msg_french "MC(machine,axis,rotary_res,Context)"        "Spécifier la résolution du mouvement de rotation (deg)"

::msgcat::mcset pb_msg_french "MC(machine,axis,ang_offset,Label)"          "Décalage angulaire (deg)"
::msgcat::mcset pb_msg_french "MC(machine,axis,ang_offset,Context)"        "Spécifier le décalage angulaire de l'axe (deg)"

::msgcat::mcset pb_msg_french "MC(machine,axis,pivot,Label)"               "Distance de pivot"
::msgcat::mcset pb_msg_french "MC(machine,axis,pivot,Context)"             "Spécifier la distance de pivot."

::msgcat::mcset pb_msg_french "MC(machine,axis,max_feed,Label)"            "Avance maxi (deg/min)"
::msgcat::mcset pb_msg_french "MC(machine,axis,max_feed,Context)"          "Spécifier l'avance maxi (deg/min)."

::msgcat::mcset pb_msg_french "MC(machine,axis,plane,Label)"               "Plan de rotation"
::msgcat::mcset pb_msg_french "MC(machine,axis,plane,Context)"             "Sélectionner XY, YZ, ZX ou Autre pour le Plan de rotation. L'option \\\"Autre\\\" permet de spécifier un vecteur arbitraire."

::msgcat::mcset pb_msg_french "MC(machine,axis,plane,normal,Label)"        "Vecteur normal au plan"
::msgcat::mcset pb_msg_french "MC(machine,axis,plane,normal,Context)"      "Spécifier le vecteur normal au plan comme axe de rotation. \nCe vecteur n'est pas nécessairement unitaire."
::msgcat::mcset pb_msg_french "MC(machine,axis,plane,4th,Label)"           "Normal au plan du 4ème axe"
::msgcat::mcset pb_msg_french "MC(machine,axis,plane,4th,Context)"         "Spécifier un vecteur normal au plan de rotation du 4ème axe."
::msgcat::mcset pb_msg_french "MC(machine,axis,plane,5th,Label)"           "Normal au plan du 5ème axe"
::msgcat::mcset pb_msg_french "MC(machine,axis,plane,5th,Context)"         "Spécifier un vecteur normal au plan de rotation du 5ème axe."

::msgcat::mcset pb_msg_french "MC(machine,axis,leader,Label)"              "Leader de Mot"
::msgcat::mcset pb_msg_french "MC(machine,axis,leader,Context)"            "Spécifier le leader de Mot."

::msgcat::mcset pb_msg_french "MC(machine,axis,config,Label)"              "Configurer"
::msgcat::mcset pb_msg_french "MC(machine,axis,config,Context)"            "Cette option permet de définir les paramètres des 4ème et 5ème axes."

::msgcat::mcset pb_msg_french "MC(machine,axis,r_axis_conf_trans,Label)"   "Configuration des axes de rotation"
::msgcat::mcset pb_msg_french "MC(machine,axis,4th_axis,Label)"            "4ème axe"
::msgcat::mcset pb_msg_french "MC(machine,axis,5th_axis,Label)"            "5ème axe"
::msgcat::mcset pb_msg_french "MC(machine,axis,head,Label)"                " Tête "
::msgcat::mcset pb_msg_french "MC(machine,axis,table,Label)"               " Table "

::msgcat::mcset pb_msg_french "MC(machine,axis,rotary_lintol,Label)"       "Tolérance de linéarisation par défaut"
::msgcat::mcset pb_msg_french "MC(machine,axis,rotary_lintol,Context)"     "Cette valeur sera utilisée comme tolérance par défaut pour linéariser les mouvements de rotation lorsque la commande Post LINTOL/ON est spécifiée avec une/des opération(s) courantes ou suivantes. La commande LINTOL/  peut spécifier une tolérance de linéarisation différente."

#+++++++++++++++++++++
# Program & Tool Path
#+++++++++++++++++++++
::msgcat::mcset pb_msg_french "MC(progtpth,tab,Label)"                 "Programme et Parcours d'outil"

##---------
## Program
##
::msgcat::mcset pb_msg_french "MC(prog,tab,Label)"                     "Programme"
::msgcat::mcset pb_msg_french "MC(prog,Status)"                        "Définir la sortie des événements"

::msgcat::mcset pb_msg_french "MC(prog,tree,Label)"                    "Programme -- Arborescence de séquences"
::msgcat::mcset pb_msg_french "MC(prog,tree,Context)"                  "Un programme CN est divisé en cinq segments: quatre séquences et le parcours d'outil lui-même: \n \n * Séquence de départ du programme \n * Séquence de départ de l'opération \n * Parcours d'outil \n * Séquence de fin d'opération \n * Séquence de fin de programme \n \nChaque séquence est constituée de marqueurs.  Un marqueur indique un événement pouvant être programmé, et se rencontre à un point particulier d'un programme CN.  Vous pouvez attacher chaque marqueur à un groupe donné de codes CN, qui sera écrit lorsque le programme est post-traité.\n \nLe parcours d'outil est constitué de plusieurs événements.  Ils sont divisés en trois groupes: \n \n * Paramètres Machine \n * Mouvements \n * Cycles \n"

::msgcat::mcset pb_msg_french "MC(prog,tree,prog_strt,Label)"          "Séquence de départ du programme"
::msgcat::mcset pb_msg_french "MC(prog,tree,prog_end,Label)"           "Séquence de fin de programme"
::msgcat::mcset pb_msg_french "MC(prog,tree,oper_strt,Label)"          "Séquence de départ de l'opération"
::msgcat::mcset pb_msg_french "MC(prog,tree,oper_end,Label)"           "Séquence de fin d'opération"
::msgcat::mcset pb_msg_french "MC(prog,tree,tool_path,Label)"          "Parcours d'outil"
::msgcat::mcset pb_msg_french "MC(prog,tree,tool_path,mach_cnt,Label)" "Paramètres Machine"
::msgcat::mcset pb_msg_french "MC(prog,tree,tool_path,motion,Label)"   "Mouvement"
::msgcat::mcset pb_msg_french "MC(prog,tree,tool_path,cycle,Label)"    "Cycles fixes"
::msgcat::mcset pb_msg_french "MC(prog,tree,linked_posts,Label)"       "Séquence Posts liés"

::msgcat::mcset pb_msg_french "MC(prog,add,Label)"                     "Séquence -- Ajouter un bloc"
::msgcat::mcset pb_msg_french "MC(prog,add,Context)"                   "Vous pouvez ajouter un nouveau bloc à une séquence en appuyant sur ce bouton et en le glissant vers le Marqueur souhaité. Les blocs peuvent être également attachés à côté, au-dessus ou au-dessous d'un bloc existant."

::msgcat::mcset pb_msg_french "MC(prog,trash,Label)"                   "Séquence -- Corbeille"
::msgcat::mcset pb_msg_french "MC(prog,trash,Context)"                 "Vous pouvez éliminer les blocs inutiles dans la séquence en les glissant vers la corbeille."

::msgcat::mcset pb_msg_french "MC(prog,block,Label)"                   "Séquence -- Bloc"
::msgcat::mcset pb_msg_french "MC(prog,block,Context)"                 "Vous pouvez détruire des blocs inutiles dans la séquence en les glissant vers la corbeille\n \nVous pouvez également activer un menu déroulant en appuyant sur le bouton de droite de la souris. Plusieurs services sont disponibles dans le menu: \n \n * Editer \n * Force la sortie \n * Couper \n * Copier sous \n * Coller \n * Détruire \n"

::msgcat::mcset pb_msg_french "MC(prog,select,Label)"                  "Séquence -- Sélection de bloc"
::msgcat::mcset pb_msg_french "MC(prog,select,Context)"                "Vous pouvez sélectionner le type de Bloc à ajouter à la séquence depuis cette liste. \n\n\ATypes de composants disponibles : \n \n * Nouveau Bloc \n * Bloc CN existant \n * Message Opérateur \n * Commande personnalisée \n"

::msgcat::mcset pb_msg_french "MC(prog,oper_temp,Label)"               "Sélectionner un modèle-type de séquence"
::msgcat::mcset pb_msg_french "MC(prog,add_block,Label)"               "Ajouter un bloc"
::msgcat::mcset pb_msg_french "MC(prog,seq_comb_nc,Label)"             "Affichage combiné Code CN et Blocs"
::msgcat::mcset pb_msg_french "MC(prog,seq_comb_nc,Context)"           "Ce bouton permet d'afficher le contenu d'une séquence en termes de blocs ou de codes CN.\n \nLes codes CN affichent les mots dans l'ordre correct."

::msgcat::mcset pb_msg_french "MC(prog,plus,Label)"                    "Programme -- Bascule Comprimer / Développer"
::msgcat::mcset pb_msg_french "MC(prog,plus,Context)"                  "Ce bouton permet de comprimer ou développer les branches de ce composant."

::msgcat::mcset pb_msg_french "MC(prog,marker,Label)"                  "Séquence -- Marqueur"
::msgcat::mcset pb_msg_french "MC(prog,marker,Context)"                "Les marqueurs d'une séquence indiquent les événements pouvant être programmés, et se rencontrent à un point particulier d'un programme CN. \n \nVous pouvez attacher ou disposer des blocs qui doivent être écrits avec chaque marqueur."

::msgcat::mcset pb_msg_french "MC(prog,event,Label)"                   "Programme -- Evénement"
::msgcat::mcset pb_msg_french "MC(prog,event,Context)"                 "Vous pouvez éditer chaque événement d'un seul clic de souris."

::msgcat::mcset pb_msg_french "MC(prog,nc_code,Label)"                 "Programme -- Code CN"
::msgcat::mcset pb_msg_french "MC(prog,nc_code,Context)"               "Le texte de cette boîte affiche le code CN représentatif à écrire avec ce marqueur ou à partir de cet événement."
::msgcat::mcset pb_msg_french "MC(prog,undo_popup,Label)"              "Annuler"

## Sequence
##
::msgcat::mcset pb_msg_french "MC(seq,combo,new,Label)"                "Nouveau Bloc"
::msgcat::mcset pb_msg_french "MC(seq,combo,comment,Label)"            "Message Opérateur"
::msgcat::mcset pb_msg_french "MC(seq,combo,custom,Label)"             "Commande personnalisée"

::msgcat::mcset pb_msg_french "MC(seq,new_trans,title,Label)"          "Bloc"
::msgcat::mcset pb_msg_french "MC(seq,cus_trans,title,Label)"          "Commande personnalisée"
::msgcat::mcset pb_msg_french "MC(seq,oper_trans,title,Label)"         "Message Opérateur"

::msgcat::mcset pb_msg_french "MC(seq,edit_popup,Label)"               "Editer"
::msgcat::mcset pb_msg_french "MC(seq,force_popup,Label)"              "Forcer la sortie"
::msgcat::mcset pb_msg_french "MC(seq,rename_popup,Label)"             "Renommer"
::msgcat::mcset pb_msg_french "MC(seq,rename_popup,Context)"           "Vous pouvez spécifier le nom de ce composant."
::msgcat::mcset pb_msg_french "MC(seq,cut_popup,Label)"                "Couper"
::msgcat::mcset pb_msg_french "MC(seq,copy_popup,Label)"               "Copier sous"
::msgcat::mcset pb_msg_french "MC(seq,copy_popup,ref,Label)"           "Bloc(s) référencés"
::msgcat::mcset pb_msg_french "MC(seq,copy_popup,new,Label)"           "Nouveaux bloc(s)"
::msgcat::mcset pb_msg_french "MC(seq,paste_popup,Label)"              "Coller"
::msgcat::mcset pb_msg_french "MC(seq,paste_popup,before,Label)"       "Avant"
::msgcat::mcset pb_msg_french "MC(seq,paste_popup,inline,Label)"       "SurDroite"
::msgcat::mcset pb_msg_french "MC(seq,paste_popup,after,Label)"        "Après"
::msgcat::mcset pb_msg_french "MC(seq,del_popup,Label)"                "Détruire"

::msgcat::mcset pb_msg_french "MC(seq,force_trans,title,Label)"        "Forcer la sortie une fois"

##--------------
## Toolpath
##
::msgcat::mcset pb_msg_french "MC(tool,event_trans,title,Label)"       "Evénement"

::msgcat::mcset pb_msg_french "MC(tool,event_seq,button,Label)"        "Sélectionner un modèle-type d'événement"
::msgcat::mcset pb_msg_french "MC(tool,add_word,button,Label)"         "Ajouter un mot"

::msgcat::mcset pb_msg_french "MC(tool,format_trans,title,Label)"      "FORMAT"

::msgcat::mcset pb_msg_french "MC(tool,circ_trans,title,Label)"        "Mouvement circulaire -- Codes des plans"
::msgcat::mcset pb_msg_french "MC(tool,circ_trans,frame,Label)"        " Codes G des plans "
::msgcat::mcset pb_msg_french "MC(tool,circ_trans,xy,Label)"           "Plan XY"
::msgcat::mcset pb_msg_french "MC(tool,circ_trans,yz,Label)"           "Plan YZ"
::msgcat::mcset pb_msg_french "MC(tool,circ_trans,zx,Label)"           "Plan ZX"

::msgcat::mcset pb_msg_french "MC(tool,ijk_desc,arc_start,Label)"          "Départ de l'arc -> Centre"
::msgcat::mcset pb_msg_french "MC(tool,ijk_desc,arc_center,Label)"         "Centre de l'arc -> Départ"
::msgcat::mcset pb_msg_french "MC(tool,ijk_desc,u_arc_start,Label)"        "Départ de l'arc -> Centre non signé"
::msgcat::mcset pb_msg_french "MC(tool,ijk_desc,absolute,Label)"           "Centre de l'arc absolu"
::msgcat::mcset pb_msg_french "MC(tool,ijk_desc,long_thread_lead,Label)"   "Pas de filetage longitudinal"
::msgcat::mcset pb_msg_french "MC(tool,ijk_desc,tran_thread_lead,Label)"   "Pas de filetage transversal"

::msgcat::mcset pb_msg_french "MC(tool,spindle,range,type,Label)"              "Type de gamme de broche"
::msgcat::mcset pb_msg_french "MC(tool,spindle,range,range_M,Label)"           "Code M de gamme distinct (M41)"
::msgcat::mcset pb_msg_french "MC(tool,spindle,range,with_spindle_M,Label)"    "Numéro de gamme avec code M de broche (M13)"
::msgcat::mcset pb_msg_french "MC(tool,spindle,range,hi_lo_with_S,Label)"      "Plage haute/basse avec code S (S+100)"
::msgcat::mcset pb_msg_french "MC(tool,spindle,range,nonzero_range,msg)"       "Le nombre de gammes de broche doit être supérieur à zéro."

::msgcat::mcset pb_msg_french "MC(tool,spindle_trans,title,Label)"         "Table des codes de gamme de broche"
::msgcat::mcset pb_msg_french "MC(tool,spindle_trans,range,Label)"         "Plage"
::msgcat::mcset pb_msg_french "MC(tool,spindle_trans,code,Label)"          "Code"
::msgcat::mcset pb_msg_french "MC(tool,spindle_trans,min,Label)"           "Minimum (RPM)"
::msgcat::mcset pb_msg_french "MC(tool,spindle_trans,max,Label)"           "Maximum (RPM)"

::msgcat::mcset pb_msg_french "MC(tool,spindle_desc,sep,Label)"            " Code M de gamme distinct (M41, M42...) "
::msgcat::mcset pb_msg_french "MC(tool,spindle_desc,range,Label)"          " Numéro de gamme avec code M de broche (M13, M23...)"
::msgcat::mcset pb_msg_french "MC(tool,spindle_desc,high,Label)"           " Gamme haute/basse avec code S (S+100/S-100)"
::msgcat::mcset pb_msg_french "MC(tool,spindle_desc,odd,Label)"            " Gamme paire/impaire avec code S"


::msgcat::mcset pb_msg_french "MC(tool,config,mill_opt1,Label)"            "Numéro d'outil"
::msgcat::mcset pb_msg_french "MC(tool,config,mill_opt2,Label)"            "Numéro d'outil et numéro de correcteur de longueur"
::msgcat::mcset pb_msg_french "MC(tool,config,mill_opt3,Label)"            "Numéro de correcteur de longueur et numéro d'outil"

::msgcat::mcset pb_msg_french "MC(tool,config,title,Label)"                "Configuration de code d'outil"
::msgcat::mcset pb_msg_french "MC(tool,config,output,Label)"               "Sortie"

::msgcat::mcset pb_msg_french "MC(tool,config,lathe_opt1,Label)"           "Numéro d'outil"
::msgcat::mcset pb_msg_french "MC(tool,config,lathe_opt2,Label)"           "Numéro d'outil et numéro de correcteur de longueur"
::msgcat::mcset pb_msg_french "MC(tool,config,lathe_opt3,Label)"           "Index de tourelle et numéro d'outil"
::msgcat::mcset pb_msg_french "MC(tool,config,lathe_opt4,Label)"           "Numéro d'outil de tourelle et numéro de correcteur de longueur"

::msgcat::mcset pb_msg_french "MC(tool,conf_desc,num,Label)"               "Numéro d'outil"
::msgcat::mcset pb_msg_french "MC(tool,conf_desc,next_num,Label)"          "Numéro de l'outil suivant"
::msgcat::mcset pb_msg_french "MC(tool,conf_desc,index_num,Label)"         "Index de tourelle et numéro d'outil"
::msgcat::mcset pb_msg_french "MC(tool,conf_desc,index_next_num,Label)"    "Index de tourelle et numéro de l'outil suivant"
::msgcat::mcset pb_msg_french "MC(tool,conf_desc,num_len,Label)"           "Numéro d'outil et numéro de correcteur de longueur"
::msgcat::mcset pb_msg_french "MC(tool,conf_desc,next_num_len,Label)"      "Numéro de l'outil suivant et numéro de correcteur de longueur"
::msgcat::mcset pb_msg_french "MC(tool,conf_desc,len_num,Label)"           "Numéro de correcteur de longueur et numéro d'outil"
::msgcat::mcset pb_msg_french "MC(tool,conf_desc,len_next_num,Label)"      "Numéro de correcteur de longueur et numéro de l'outil suivant"
::msgcat::mcset pb_msg_french "MC(tool,conf_desc,index_num_len,Label)"     "Index de tourelle, numéro d'outil et numéro de correcteur de longueur"
::msgcat::mcset pb_msg_french "MC(tool,conf_desc,index_next_num_len,Label)"    "Index de tourelle, numéro de l'outil suivant et numéro de correcteur de longueur"

::msgcat::mcset pb_msg_french "MC(tool,oper_trans,title,Label)"            "Message Opérateur"
::msgcat::mcset pb_msg_french "MC(tool,cus_trans,title,Label)"             "Commande personnalisée"

##--------------------------
## Labels for Event dialogs
##
::msgcat::mcset pb_msg_french "MC(event,feed,IPM_mode)"                "Mode IPM (pouce/min)"

##---------
## G Codes
##
::msgcat::mcset pb_msg_french "MC(gcode,tab,Label)"                    "Codes G "
::msgcat::mcset pb_msg_french "MC(gcode,Status)"                       "Spécifier les codes G"

##---------
## M Codes
##
::msgcat::mcset pb_msg_french "MC(mcode,tab,Label)"                    "Codes M "
::msgcat::mcset pb_msg_french "MC(mcode,Status)"                       "Spécifier les codes M"

##-----------------
## Words Summary
##
::msgcat::mcset pb_msg_french "MC(addrsum,tab,Label)"                  "Résumé Mot"
::msgcat::mcset pb_msg_french "MC(addrsum,Status)"                     "Spécifier les paramètres"

::msgcat::mcset pb_msg_french "MC(addrsum,col_addr,Label)"             "Mot"
::msgcat::mcset pb_msg_french "MC(addrsum,col_addr,Context)"           "Vous pouvez éditer une adresse de Mot en cliquant sur son nom avec le bouton de gauche."
::msgcat::mcset pb_msg_french "MC(addrsum,col_lead,Label)"             "Leader/Code"
::msgcat::mcset pb_msg_french "MC(addrsum,col_data,Label)"             "Type de donnée"
::msgcat::mcset pb_msg_french "MC(addrsum,col_plus,Label)"             "Plus (+)"
::msgcat::mcset pb_msg_french "MC(addrsum,col_lzero,Label)"            "Zéro de tête"
::msgcat::mcset pb_msg_french "MC(addrsum,col_int,Label)"              "Entier"
::msgcat::mcset pb_msg_french "MC(addrsum,col_dec,Label)"              "Décimale (.)"
::msgcat::mcset pb_msg_french "MC(addrsum,col_frac,Label)"             "Fraction"
::msgcat::mcset pb_msg_french "MC(addrsum,col_tzero,Label)"            "Zéro de queue"
::msgcat::mcset pb_msg_french "MC(addrsum,col_modal,Label)"            "Modal ?"
::msgcat::mcset pb_msg_french "MC(addrsum,col_min,Label)"              "Minimum"
::msgcat::mcset pb_msg_french "MC(addrsum,col_max,Label)"              "Maximum"
::msgcat::mcset pb_msg_french "MC(addrsum,col_trail,Label)"            "Trailer"

::msgcat::mcset pb_msg_french "MC(addrsum,radio_text,Label)"           "Texte"
::msgcat::mcset pb_msg_french "MC(addrsum,radio_num,Label)"            "Nombre"

::msgcat::mcset pb_msg_french "MC(addrsum,addr_trans,title,Label)"     "MOT"
::msgcat::mcset pb_msg_french "MC(addrsum,other_trans,title,Label)"    "Autres données"

##-----------------
## Word Sequencing
##
::msgcat::mcset pb_msg_french "MC(wseq,tab,Label)"                     "Séquencement des Mots"
::msgcat::mcset pb_msg_french "MC(wseq,Status)"                        "Séquencer les Mots "

::msgcat::mcset pb_msg_french "MC(wseq,word,Label)"                    "Séquence des Mots master"
::msgcat::mcset pb_msg_french "MC(wseq,word,Context)"                  "Vous pouvez séquencer l'ordre des Mots qui apparaissent dans la sortie CN en glissant un Mot à la position souhaitée. \n \nLorsque la couleur du rectangle change pour le Mot que vous glissez, les positions respectives des 2 Mots sont inversées. Si un Mot est glissé et que le séparateur entre les deux Mots change de couleur, le Mot sera inséré entre ces deux Mots. \n \nVous pouvez empêcher l'écriture d'un Mot vers la sortie CN en le désactivant avec la souris. \n \nVous pouvez également manipuler ces Mots en utilisant les options d'un menu déroulant: \n \n * Nouveau \n * Editer \n * Détruire \n * Activer tout \n"

::msgcat::mcset pb_msg_french "MC(wseq,active_out,Label)"              " Sortie - Actif     "
::msgcat::mcset pb_msg_french "MC(wseq,suppressed_out,Label)"          " Sortie - Supprimé "

::msgcat::mcset pb_msg_french "MC(wseq,popup_new,Label)"               "Nouveau"
::msgcat::mcset pb_msg_french "MC(wseq,popup_undo,Label)"              "Annuler"
::msgcat::mcset pb_msg_french "MC(wseq,popup_edit,Label)"              "Editer"
::msgcat::mcset pb_msg_french "MC(wseq,popup_delete,Label)"            "Détruire"
::msgcat::mcset pb_msg_french "MC(wseq,popup_all,Label)"               "Activer tout"
::msgcat::mcset pb_msg_french "MC(wseq,transient_win,Label)"           "MOT"
::msgcat::mcset pb_msg_french "MC(wseq,cannot_suppress_msg)"           "ne peut pas être supprimé.  A été utilisé comme un seul élément dans "
::msgcat::mcset pb_msg_french "MC(wseq,empty_block_msg)"               "Supprimer la sortie de cette adresse génèrera un ou plusieurs blocs vides non valables."

##----------------
## Custom Command
##
::msgcat::mcset pb_msg_french "MC(cust_cmd,tab,Label)"                 "Commande personnalisée"
::msgcat::mcset pb_msg_french "MC(cust_cmd,Status)"                    "Définir des commandes personnalisées"

::msgcat::mcset pb_msg_french "MC(cust_cmd,name,Label)"                "Nom de la commande"
::msgcat::mcset pb_msg_french "MC(cust_cmd,name,Context)"              "Au nom que vous entrez ici sera ajouté le préfixe PB_CMD_ pour obtenir le nom de la commande."
::msgcat::mcset pb_msg_french "MC(cust_cmd,proc,Label)"                "Procédure"
::msgcat::mcset pb_msg_french "MC(cust_cmd,proc,Context)"              "Vous entrerez un script TCL pour définir la fonctionnalité de cette commande. \n \n * Notez que le contenu du script ne sera pas analysé par Post Builder, mais il sera sauvegardé dans le fichier TCL. Vous êtes donc responsable de la bonne syntaxe du script."

::msgcat::mcset pb_msg_french "MC(cust_cmd,name_msg)"                  "Nom de commande personnalisée non valable.\n Spécifier un autre nom."
::msgcat::mcset pb_msg_french "MC(cust_cmd,name_msg_1)"                "est réservé pour les commandes personnalisées.\n Spécifier un autre nom."
::msgcat::mcset pb_msg_french "MC(cust_cmd,name_msg_2)"                "Seuls des noms de commande personnalisés\n VNC tels que PB_CMD_vnc____* sont autorisés.\n  Spécifier un autre nom."

::msgcat::mcset pb_msg_french "MC(cust_cmd,import,Label)"              "Importer"
::msgcat::mcset pb_msg_french "MC(cust_cmd,import,Context)"            "Importer des commandes personnalisées venant d'un fichier TCL sélectionné vers le Post en cours."
::msgcat::mcset pb_msg_french "MC(cust_cmd,export,Label)"              "Exporter"
::msgcat::mcset pb_msg_french "MC(cust_cmd,export,Context)"            "Exporter des commandes personnalisées venant du Post vers un fichier TCL."
::msgcat::mcset pb_msg_french "MC(cust_cmd,import,tree,Label)"         "Importer des commandes personnalisées"
::msgcat::mcset pb_msg_french "MC(cust_cmd,import,tree,Context)"       "Cette liste contient des procédures de commandes personnalisées et d'autres procédures TCL trouvées dans le fichier que vous importez. Vous pouvez obtenir un aperçu du contenu de chaque procédure en sélectionnant l'élément dans la liste d'un seul clic. Toute procédure qui existe déjà dans le Post en cours est identifiée par un indicateur <exists>. Double-cliquez sur un élément pour basculer la case à cocher en regard de l'élément. Ceci permet de sélectionner ou désélectionner une procédure à importer. Par défaut, toutes les procédures sont sélectionnées pour être importées. Désélectionner un élément pour éviter d'écraser une procédure existante."

::msgcat::mcset pb_msg_french "MC(cust_cmd,export,tree,Label)"         "Exporter des commandes personnalisées"
::msgcat::mcset pb_msg_french "MC(cust_cmd,export,tree,Context)"       "Cette liste contient des procédures de commandes personnalisées et d'autres procédures TCL qui existent dans le Post en cours. Vous pouvez obtenir un aperçu du contenu de chaque procédure en sélectionnant l'élément dans la liste d'un seul clic. Double-cliquez sur un élément pour basculer la case à cocher en regard de l'élément. Ceci permet de ne sélectionner que les procédures que vous souhaitez exporter. "

::msgcat::mcset pb_msg_french "MC(cust_cmd,error,title)"               "Erreur de commande personnalisée"
::msgcat::mcset pb_msg_french "MC(cust_cmd,error,msg)"                 "La validation des commandes personnalisées peut être activée ou désactivée en réglant les bascules sur le menu déroulant principal \"Options -> Valider les Commandes personnalisées\"."

::msgcat::mcset pb_msg_french "MC(cust_cmd,select_all,Label)"          "Sélectionner tout"
::msgcat::mcset pb_msg_french "MC(cust_cmd,select_all,Context)"        "Cliquez sur ce bouton pour sélectionner toutes les commandes affichées pour les importer ou les exporter."
::msgcat::mcset pb_msg_french "MC(cust_cmd,deselect_all,Label)"        "Désélectionner tout"
::msgcat::mcset pb_msg_french "MC(cust_cmd,deselect_all,Context)"      "Cliquez sur ce bouton pour désélectionner toutes les commandes."

::msgcat::mcset pb_msg_french "MC(cust_cmd,import,warning,title)"      "Avertissement Importer / Exporter Commande personnalisée"
::msgcat::mcset pb_msg_french "MC(cust_cmd,import,warning,msg)"        "Aucun élément n'a été sélectionné à importer ou exporter."



::msgcat::mcset pb_msg_french "MC(cust_cmd,cmd,msg)"                   "Commandes : "
::msgcat::mcset pb_msg_french "MC(cust_cmd,blk,msg)"                   "Blocs : "
::msgcat::mcset pb_msg_french "MC(cust_cmd,add,msg)"                   "Adresses : "
::msgcat::mcset pb_msg_french "MC(cust_cmd,fmt,msg)"                   "Formats : "
::msgcat::mcset pb_msg_french "MC(cust_cmd,referenced,msg)"            "référencés dans la commande personnalisée "
::msgcat::mcset pb_msg_french "MC(cust_cmd,not_defined,msg)"           "n'ont pas été définis dans le domaine actuel du Post en cours."
::msgcat::mcset pb_msg_french "MC(cust_cmd,cannot_delete,msg)"         "ne peuvent pas être détruits."
::msgcat::mcset pb_msg_french "MC(cust_cmd,save_post,msg)"             "Confirmez-vous de sauvegarder ce Post?"


##------------------
## Operator Message
##
::msgcat::mcset pb_msg_french "MC(opr_msg,text,Label)"                 "Message Opérateur"
::msgcat::mcset pb_msg_french "MC(opr_msg,text,Context)"               "Le texte à afficher comme message opérateur. Les caractères spéciaux nécessaires pour le début et la fin du message seront automatiquement attachés par le Post Builder. Ces caractères sont spécifiés dans la page des paramètres \"Autres données\" sous l'onglet \"Définitions de données CN\"."

::msgcat::mcset pb_msg_french "MC(opr_msg,name,Label)"                 "Nom du message"
::msgcat::mcset pb_msg_french "MC(opr_msg,empty_operator)"             "Un message opérateur ne doit pas être vide."


##--------------
## Linked Posts
##
::msgcat::mcset pb_msg_french "MC(link_post,tab,Label)"                "Posts combinés"
::msgcat::mcset pb_msg_french "MC(link_post,Status)"                   "Définir des Posts liés"

::msgcat::mcset pb_msg_french "MC(link_post,toggle,Label)"             "Lier d'autres Posts à ce Post"
::msgcat::mcset pb_msg_french "MC(link_post,toggle,Context)"           "D'autres Posts peuvent être liés à ce Post pour gérer des machines-outils complexes qui effectuent plusieurs combinaisons des modes de tournage et de fraisage simple."

::msgcat::mcset pb_msg_french "MC(link_post,head,Label)"               "Tête"
::msgcat::mcset pb_msg_french "MC(link_post,head,Context)"             "Une machine-outil complexe peut effectuer ses opérations d'usinage en utilisant divers modes cinématiques dans divers modes d'usinage. Chaque mode cinématique est traité comme une tête indépendante dans NX/Post. Les opérations d'usinage qui doivent être réalisées avec une tête spécifique seront placées ensemble en tant que groupe dans la vue de la méthode Machine-outil ou Usinage. Un UDE \\\"Tête\\\" sera ensuite affecté au groupe pour désigner le nom de cette tête."

::msgcat::mcset pb_msg_french "MC(link_post,post,Label)"               "Post"
::msgcat::mcset pb_msg_french "MC(link_post,post,Context)"             "Un Post est affecté à une tête pour générer les codes CN. "

::msgcat::mcset pb_msg_french "MC(link_post,link,Label)"               "Post lié"
::msgcat::mcset pb_msg_french "MC(link_post,link,Context)"             "[::msgcat::mc MC(link_post,head,Context)] \n\n [::msgcat::mc MC(link_post,post,Context)]"


::msgcat::mcset pb_msg_french "MC(link_post,new,Label)"                "Nouveau"
::msgcat::mcset pb_msg_french "MC(link_post,new,Context)"              "Créer un nouveau lien."

::msgcat::mcset pb_msg_french "MC(link_post,edit,Label)"               "Editer"
::msgcat::mcset pb_msg_french "MC(link_post,edit,Context)"             "Editer un lien."

::msgcat::mcset pb_msg_french "MC(link_post,delete,Label)"             "Détruire"
::msgcat::mcset pb_msg_french "MC(link_post,delete,Context)"           "Détruire un lien."

::msgcat::mcset pb_msg_french "MC(link_post,select_name,Label)"        "Sélect. Nom"
::msgcat::mcset pb_msg_french "MC(link_post,select_name,Context)"      "Sélectionner le nom d'un Post à affecter à une tête. Il est supposé que ce Post est situé dans le répertoire où se trouve le Post principal au moment de l'exécution de NX/Post, sinon sera utilisé un Post de même nom situé dans le répertoire \\\$UGII_CAM_POST_DIR."

::msgcat::mcset pb_msg_french "MC(link_post,start_of_head,Label)"      "Départ de la Tête"
::msgcat::mcset pb_msg_french "MC(link_post,start_of_head,Context)"    "Spécifier les codes CN ou actions à exécuter pour le départ de cette Tête."

::msgcat::mcset pb_msg_french "MC(link_post,end_of_head,Label)"        "Fin de la Tête"
::msgcat::mcset pb_msg_french "MC(link_post,end_of_head,Context)"      "Spécifier les codes CN ou actions à exécuter pour la fin de cette Tête."
::msgcat::mcset pb_msg_french "MC(link_post,dlg,head,Label)"           "Tête"
::msgcat::mcset pb_msg_french "MC(link_post,dlg,post,Label)"           "Post"
::msgcat::mcset pb_msg_french "MC(link_post,dlg,title,Label)"          "Post lié"

#++++++++++++++++++++++
# N/C Data Definitions
#++++++++++++++++++++++
::msgcat::mcset pb_msg_french "MC(nc_data,tab,Label)"                  "Définitions de données CN"

##-------
## BLOCK
##
::msgcat::mcset pb_msg_french "MC(block,tab,Label)"                    "BLOC"
::msgcat::mcset pb_msg_french "MC(block,Status)"                       "Définir les modèles-type de bloc"

::msgcat::mcset pb_msg_french "MC(block,name,Label)"                   "Nom de bloc"
::msgcat::mcset pb_msg_french "MC(block,name,Context)"                 "Saisir le nom du bloc"

::msgcat::mcset pb_msg_french "MC(block,add,Label)"                    "Ajouter un mot"
::msgcat::mcset pb_msg_french "MC(block,add,Context)"                  "Vous pouvez ajouter un nouveau mot à un bloc en appuyant sur ce bouton et en le faisant glisser vers le bloc affiché dans la fenêtre ci-dessous. Le type de Mot qui sera créé est sélectionné dans la boîte située à droite de ce bouton."

::msgcat::mcset pb_msg_french "MC(block,select,Label)"                 "BLOC -- Sélection de Mot"
::msgcat::mcset pb_msg_french "MC(block,select,Context)"               "Vous pouvez sélectionner dans la liste le type de Mot que vous souhaitez ajouter au bloc."

::msgcat::mcset pb_msg_french "MC(block,trash,Label)"                  "BLOC -- Corbeille"
::msgcat::mcset pb_msg_french "MC(block,trash,Context)"                "Vous pouvez éliminer les Mots inutiles dans un bloc en les glissant vers la corbeille."

::msgcat::mcset pb_msg_french "MC(block,word,Label)"                   "BLOC -- Mot"
::msgcat::mcset pb_msg_french "MC(block,word,Context)"                 "Vous pouvez détruire un Mot inutile dans ce bloc en le glissant vers la corbeille. \n \nVous pouvez également activer un menu déroulant en appuyant sur le bouton de droite de la souris. Plusieurs services sont disponibles dans le menu: \n \n * Editer \n * Modifier l'élément -> \n * Facultatif \n * Sans séparateur de mots \n * Forcer la sortie \n * Détruire \n"

::msgcat::mcset pb_msg_french "MC(block,verify,Label)"                 "BLOC -- Vérification de mot"
::msgcat::mcset pb_msg_french "MC(block,verify,Context)"               "Cette fenêtre affiche le code CN représentatif à écrire pour un Mot sélectionné (enfoncé) dans le bloc représenté dans la fenêtre ci-dessus."

::msgcat::mcset pb_msg_french "MC(block,new_combo,Label)"              "Nouvelle adresse"
::msgcat::mcset pb_msg_french "MC(block,text_combo,Label)"             "Texte"
::msgcat::mcset pb_msg_french "MC(block,oper_combo,Label)"             "Message Opérateur"
::msgcat::mcset pb_msg_french "MC(block,comm_combo,Label)"             "Commande"

::msgcat::mcset pb_msg_french "MC(block,edit_popup,Label)"             "Editer"
::msgcat::mcset pb_msg_french "MC(block,view_popup,Label)"             "Affichage"
::msgcat::mcset pb_msg_french "MC(block,change_popup,Label)"           "Modifier l'élément"
::msgcat::mcset pb_msg_french "MC(block,user_popup,Label)"             "Expression définie par l'utilisateur"
::msgcat::mcset pb_msg_french "MC(block,opt_popup,Label)"              "Facultatif"
::msgcat::mcset pb_msg_french "MC(block,no_sep_popup,Label)"           "Sans séparateur de mots"
::msgcat::mcset pb_msg_french "MC(block,force_popup,Label)"            "Forcer la sortie"
::msgcat::mcset pb_msg_french "MC(block,delete_popup,Label)"           "Détruire"
::msgcat::mcset pb_msg_french "MC(block,undo_popup,Label)"             "Annuler"
::msgcat::mcset pb_msg_french "MC(block,delete_all,Label)"             "Supprimer tous les éléments actifs"

::msgcat::mcset pb_msg_french "MC(block,cmd_title,Label)"              "Commande personnalisée"
::msgcat::mcset pb_msg_french "MC(block,oper_title,Label)"             "Message Opérateur"
::msgcat::mcset pb_msg_french "MC(block,addr_title,Label)"             "MOT"

::msgcat::mcset pb_msg_french "MC(block,new_trans,title,Label)"        "MOT"

::msgcat::mcset pb_msg_french "MC(block,new,word_desc,Label)"          "Nouvelle adresse"
::msgcat::mcset pb_msg_french "MC(block,oper,word_desc,Label)"         "Message Opérateur"
::msgcat::mcset pb_msg_french "MC(block,cmd,word_desc,Label)"          "Commande personnalisée"
::msgcat::mcset pb_msg_french "MC(block,user,word_desc,Label)"         "Expression définie par l'utilisateur"
::msgcat::mcset pb_msg_french "MC(block,text,word_desc,Label)"         "Chaîne de texte"

::msgcat::mcset pb_msg_french "MC(block,user,expr,Label)"              "Expression"

::msgcat::mcset pb_msg_french "MC(block,msg,min_word)"                 "Un bloc doit contenir au moins un Mot."

::msgcat::mcset pb_msg_french "MC(block,name_msg)"                     "Nom de bloc non valable.\n Spécifier un autre nom."

##---------
## ADDRESS
##
::msgcat::mcset pb_msg_french "MC(address,tab,Label)"                  "MOT"
::msgcat::mcset pb_msg_french "MC(address,Status)"                     "Définir les Mots"

::msgcat::mcset pb_msg_french "MC(address,name,Label)"                 "Nom du mot"
::msgcat::mcset pb_msg_french "MC(address,name,Context)"               "Vous pouvez éditer le nom d'un Mot."

::msgcat::mcset pb_msg_french "MC(address,verify,Label)"               "MOT -- Vérification"
::msgcat::mcset pb_msg_french "MC(address,verify,Context)"             "Cette fenêtre affiche le code CN représentatif à écrire pour un Mot."

::msgcat::mcset pb_msg_french "MC(address,leader,Label)"               "Amorce"
::msgcat::mcset pb_msg_french "MC(address,leader,Context)"             "Vous pouvez saisir un nombre quelconque de caractères pour le leader d'un Mot, ou sélectionner un caractère dans un menu déroulant avec le bouton de droite."

::msgcat::mcset pb_msg_french "MC(address,format,Label)"               "Format"
::msgcat::mcset pb_msg_french "MC(address,format,edit,Label)"          "Editer"
::msgcat::mcset pb_msg_french "MC(address,format,edit,Context)"        "Ce bouton permet d'éditer le format utilisé par un Mot."
::msgcat::mcset pb_msg_french "MC(address,format,new,Label)"           "Nouveau"
::msgcat::mcset pb_msg_french "MC(address,format,new,Context)"         "Ce bouton permet de créer un nouveau format."

::msgcat::mcset pb_msg_french "MC(address,format,select,Label)"        "MOT -- Sélection du format"
::msgcat::mcset pb_msg_french "MC(address,format,select,Context)"      "Ce bouton permet de sélectionner un format différent pour un Mot."

::msgcat::mcset pb_msg_french "MC(address,trailer,Label)"              "Trailer"
::msgcat::mcset pb_msg_french "MC(address,trailer,Context)"            "Vous pouvez saisir un nombre quelconque de caractères pour le trailer d'un Mot, ou sélectionner un caractère dans un menu déroulant avec le bouton de droite."

::msgcat::mcset pb_msg_french "MC(address,modality,Label)"             "Modal ?"
::msgcat::mcset pb_msg_french "MC(address,modality,Context)"           "Cette option permet de définir la modalité d'un Mot."

::msgcat::mcset pb_msg_french "MC(address,modal_drop,off,Label)"       "Désactivé"
::msgcat::mcset pb_msg_french "MC(address,modal_drop,once,Label)"      "Une fois"
::msgcat::mcset pb_msg_french "MC(address,modal_drop,always,Label)"    "Toujours"

::msgcat::mcset pb_msg_french "MC(address,max,value,Label)"            "Maximum"
::msgcat::mcset pb_msg_french "MC(address,max,value,Context)"          "Vous spécifierez une valeur maximale pour un Mot."

::msgcat::mcset pb_msg_french "MC(address,value,text,Label)"           "Valeur"

::msgcat::mcset pb_msg_french "MC(address,trunc_drop,Label)"           "Tronquer la valeur"
::msgcat::mcset pb_msg_french "MC(address,warn_drop,Label)"            "Avertir l'utilisateur"
::msgcat::mcset pb_msg_french "MC(address,abort_drop,Label)"           "Arrêter le traitement"

::msgcat::mcset pb_msg_french "MC(address,max,error_handle,Label)"     "Gestion des conditions non respectées"
::msgcat::mcset pb_msg_french "MC(address,max,error_handle,Context)"   "Ce bouton permet de spécifier la méthode pour gérer les valeurs maxi non respectées: \n \n * Tronquer la valeur \n * Avertir l'utilisateur \n * Arrêter le traitement \n"

::msgcat::mcset pb_msg_french "MC(address,min,value,Label)"            "Minimum"
::msgcat::mcset pb_msg_french "MC(address,min,value,Context)"          "Vous spécifierez une valeur minimale pour un Mot."

::msgcat::mcset pb_msg_french "MC(address,min,error_handle,Label)"     "Gestion des conditions non respectées"
::msgcat::mcset pb_msg_french "MC(address,min,error_handle,Context)"   "Ce bouton permet de spécifier la méthode pour gérer les valeurs mini non respectées: \n \n * Tronquer la valeur \n * Avertir l'utilisateur \n * Arrêter le traitement \n"

::msgcat::mcset pb_msg_french "MC(address,format_trans,title,Label)"   "FORMAT "
::msgcat::mcset pb_msg_french "MC(address,none_popup,Label)"           "Aucune"

::msgcat::mcset pb_msg_french "MC(address,exp,Label)"                  "Expression"
::msgcat::mcset pb_msg_french "MC(address,exp,Context)"                "Vous pouvez spécifier une expression ou une constante pour un bloc."
::msgcat::mcset pb_msg_french "MC(address,exp,msg)"                    "L'expression pour un élément Bloc ne doit pas être vide."
::msgcat::mcset pb_msg_french "MC(address,exp,space_only)"             "L'expression pour un élément Bloc utilisant un format numérique ne doit pas contenir que des espaces."

## No translation is needed for this string.
::msgcat::mcset pb_msg_french "MC(address,exp,spec_char)"              "\!  \"  \#  \&  \'  \.  \;  \<  \=  \>  \?  \@ \[  \\  \]  \^  \`  \{  \|  \}  \~"

::msgcat::mcset pb_msg_french "MC(address,exp,spec_char_msg)"          "Les caractères spéciaux \n [::msgcat::mc MC(address,exp,spec_char)] \n  ne peuvent pas être utilisés dans une expression pour des données numériques."



::msgcat::mcset pb_msg_french "MC(address,name_msg)"                   "Nom de Mot non valable.\n Spécifier un autre nom."
# - No translation for rapid1, rapid2 & rapid3
::msgcat::mcset pb_msg_french "MC(address,rapid_add_name_msg)"         "rapid1, rapid2 et rapid3 sont réservés par Post Builder.\n Spécifier un autre nom."

::msgcat::mcset pb_msg_french "MC(address,rapid1,desc)"                "Positionnement rapide suivant l'axe longitudinal"
::msgcat::mcset pb_msg_french "MC(address,rapid2,desc)"                "Positionnement rapide suivant l'axe transversal"
::msgcat::mcset pb_msg_french "MC(address,rapid3,desc)"                "Positionnement rapide suivant l'axe de broche"

##--------
## FORMAT
##
::msgcat::mcset pb_msg_french "MC(format,tab,Label)"                   "FORMAT"
::msgcat::mcset pb_msg_french "MC(format,Status)"                      "Définir les formats"

::msgcat::mcset pb_msg_french "MC(format,verify,Label)"                "Format -- Vérification"
::msgcat::mcset pb_msg_french "MC(format,verify,Context)"              "Cette fenêtre affiche le code CN représentatif à écrire en utilisant le format spécifié."

::msgcat::mcset pb_msg_french "MC(format,name,Label)"                  "Nom de format"
::msgcat::mcset pb_msg_french "MC(format,name,Context)"                "Vous pouvez éditer le nom d'un Format."

::msgcat::mcset pb_msg_french "MC(format,data,type,Label)"             "Type de donnée"
::msgcat::mcset pb_msg_french "MC(format,data,type,Context)"           "Vous spécifierez le type de donnée pour un Format."
::msgcat::mcset pb_msg_french "MC(format,data,num,Label)"              "Nombre"
::msgcat::mcset pb_msg_french "MC(format,data,num,Context)"            "Cette option définit le type de donnée d'un Format comme étant numérique."
::msgcat::mcset pb_msg_french "MC(format,data,num,integer,Label)"      "FORMAT -- Nombre de chiffres d'un entier"
::msgcat::mcset pb_msg_french "MC(format,data,num,integer,Context)"    "Cette option spécifie le nombre de chiffres d'un entier ou de la partie entière d'un nombre réel."
::msgcat::mcset pb_msg_french "MC(format,data,num,fraction,Label)"     "FORMAT -- Nombre de chiffres d'une fraction"
::msgcat::mcset pb_msg_french "MC(format,data,num,fraction,Context)"   "Cette option spécifie le nombre de chiffres de la partie décimale d'un nombre réel."
::msgcat::mcset pb_msg_french "MC(format,data,num,decimal,Label)"      "Ecrire le point décimal (.)"
::msgcat::mcset pb_msg_french "MC(format,data,num,decimal,Context)"    "Cette option permet d'écrire les points décimaux dans les codes CN."
::msgcat::mcset pb_msg_french "MC(format,data,num,lead,Label)"         "Ecrire les zéros de tête "
::msgcat::mcset pb_msg_french "MC(format,data,num,lead,Context)"       "Cette option permet de remplir les zéros de tête pour les nombres dans les codes CN."
::msgcat::mcset pb_msg_french "MC(format,data,num,trail,Label)"        "Ecrire les zéros de queue"
::msgcat::mcset pb_msg_french "MC(format,data,num,trail,Context)"      "Cette option permet de remplir les zéros de queue pour les nombres réels dans les codes CN."
::msgcat::mcset pb_msg_french "MC(format,data,text,Label)"             "Texte"
::msgcat::mcset pb_msg_french "MC(format,data,text,Context)"           "Cette option définit le type de donnée d'un Format comme étant une chaîne de texte."
::msgcat::mcset pb_msg_french "MC(format,data,plus,Label)"             "Ecrire le signe (+) en tête"
::msgcat::mcset pb_msg_french "MC(format,data,plus,Context)"           "Cette option permet d'écrire les signes + dans les codes CN."
::msgcat::mcset pb_msg_french "MC(format,zero_msg)"                    "Impossible de faire une copie d'un format Zéro"
::msgcat::mcset pb_msg_french "MC(format,zero_cut_msg)"                "Impossible de détruire un format Zéro"

::msgcat::mcset pb_msg_french "MC(format,data,dec_zero,msg)"           "Au moins une des options Point décimal, Zéros de tête ou Zéros de queue doit être cochée."

::msgcat::mcset pb_msg_french "MC(format,data,no_digit,msg)"           "Les nombres de chiffres pour Entier et Fraction ne doivent pas être tous deux nuls."

::msgcat::mcset pb_msg_french "MC(format,name_msg)"                    "Nom de format non valable.\n Spécifier un autre nom."
::msgcat::mcset pb_msg_french "MC(format,error,title)"                 "Erreur de format"
::msgcat::mcset pb_msg_french "MC(format,error,msg)"                   "Ce format a été utilisé dans des adresses"

##---------------------
## Other Data Elements
##
::msgcat::mcset pb_msg_french "MC(other,tab,Label)"                    "Autres données"
::msgcat::mcset pb_msg_french "MC(other,Status)"                       "Spécifier les paramètres"

::msgcat::mcset pb_msg_french "MC(other,seq_num,Label)"                "Numéro de séquence"
::msgcat::mcset pb_msg_french "MC(other,seq_num,Context)"              "Cette bascule permet d'activer/désactiver l'écriture des numéros de séquence dans les codes CN."
::msgcat::mcset pb_msg_french "MC(other,seq_num,start,Label)"          "Début des numéros de séquence"
::msgcat::mcset pb_msg_french "MC(other,seq_num,start,Context)"        "Spécifier le début des numéros de séquence."
::msgcat::mcset pb_msg_french "MC(other,seq_num,inc,Label)"            "Incrément de numéro de séquence"
::msgcat::mcset pb_msg_french "MC(other,seq_num,inc,Context)"          "Spécifier l'incrément des numéros de séquence."
::msgcat::mcset pb_msg_french "MC(other,seq_num,freq,Label)"           "Fréquence des numéro de séquence"
::msgcat::mcset pb_msg_french "MC(other,seq_num,freq,Context)"         "Spécifier la fréquence des numéros de séquence apparaissant dans les codes CN."
::msgcat::mcset pb_msg_french "MC(other,seq_num,max,Label)"            "Numéro de séquence maximum"
::msgcat::mcset pb_msg_french "MC(other,seq_num,max,Context)"          "Spécifier la valeur maxi des numéros de séquence."

::msgcat::mcset pb_msg_french "MC(other,chars,Label)"                  "Caractères spéciaux"
::msgcat::mcset pb_msg_french "MC(other,chars,word_sep,Label)"         "Séparateur des Mots"
::msgcat::mcset pb_msg_french "MC(other,chars,word_sep,Context)"       "Spécifier un caractère pour séparer les Mots."
::msgcat::mcset pb_msg_french "MC(other,chars,decimal_pt,Label)"       "Point décimal"
::msgcat::mcset pb_msg_french "MC(other,chars,decimal_pt,Context)"     "Spécifier un caractère pour le point décimal."
::msgcat::mcset pb_msg_french "MC(other,chars,end_of_block,Label)"     "Fin de bloc"
::msgcat::mcset pb_msg_french "MC(other,chars,end_of_block,Context)"   "Spécifier un caractère pour la fin de bloc."
::msgcat::mcset pb_msg_french "MC(other,chars,comment_start,Label)"    "Début de message"
::msgcat::mcset pb_msg_french "MC(other,chars,comment_start,Context)"  "Spécifier les caractères à utiliser pour le début d'une ligne de Message opérateur."
::msgcat::mcset pb_msg_french "MC(other,chars,comment_end,Label)"      "Fin de message"
::msgcat::mcset pb_msg_french "MC(other,chars,comment_end,Context)"    "Spécifier les caractères à utiliser pour la fin d'une ligne de Message opérateur."

::msgcat::mcset pb_msg_french "MC(other,opskip,Label)"                 "OPSKIP"
::msgcat::mcset pb_msg_french "MC(other,opskip,leader,Label)"          "Leader de ligne"
::msgcat::mcset pb_msg_french "MC(other,opskip,leader,Context)"        "Leader de ligne OPSKIP"

::msgcat::mcset pb_msg_french "MC(other,gm_codes,Label)"               "Codes G et M écrits par Bloc"
::msgcat::mcset pb_msg_french "MC(other,g_codes,Label)"                "Nombre de codes G par Bloc"
::msgcat::mcset pb_msg_french "MC(other,g_codes,Context)"              "Cette bascule permet d'activer/désactiver le contrôle du nombre de codes G par bloc CN."
::msgcat::mcset pb_msg_french "MC(other,g_codes,num,Label)"            "Nombre de codes G"
::msgcat::mcset pb_msg_french "MC(other,g_codes,num,Context)"          "Spécifier le nombre de codes G par bloc CN."
::msgcat::mcset pb_msg_french "MC(other,m_codes,Label)"                "Nombre de codes M"
::msgcat::mcset pb_msg_french "MC(other,m_codes,Context)"              "Cette bascule permet d'activer/désactiver le contrôle du nombre de codes M par bloc CN."
::msgcat::mcset pb_msg_french "MC(other,m_codes,num,Label)"            "Nombre de codes M par Bloc"
::msgcat::mcset pb_msg_french "MC(other,m_codes,num,Context)"          "Spécifier le nombre de codes M par bloc CN."

::msgcat::mcset pb_msg_french "MC(other,opt_none,Label)"               "Aucune"
::msgcat::mcset pb_msg_french "MC(other,opt_space,Label)"              "Espace"
::msgcat::mcset pb_msg_french "MC(other,opt_dec,Label)"                "Décimale (.)"
::msgcat::mcset pb_msg_french "MC(other,opt_comma,Label)"              "Virgule (,)"
::msgcat::mcset pb_msg_french "MC(other,opt_semi,Label)"               "Point virgule (;)"
::msgcat::mcset pb_msg_french "MC(other,opt_colon,Label)"              "Deux points (:)"
::msgcat::mcset pb_msg_french "MC(other,opt_text,Label)"               "Chaîne de texte"
::msgcat::mcset pb_msg_french "MC(other,opt_left,Label)"               "Parenthèse gauche ("
::msgcat::mcset pb_msg_french "MC(other,opt_right,Label)"              "Parenthèse droite )"
::msgcat::mcset pb_msg_french "MC(other,opt_pound,Label)"              "Signe dièse (\#)"
::msgcat::mcset pb_msg_french "MC(other,opt_aster,Label)"              "Astérisque (*)"
::msgcat::mcset pb_msg_french "MC(other,opt_slash,Label)"              "Barre oblique (/)"
::msgcat::mcset pb_msg_french "MC(other,opt_new_line,Label)"           "Nouvelle ligne (\\012)"

# UDE Inclusion
::msgcat::mcset pb_msg_french "MC(other,ude,Label)"                    "Evénements utilisateur"
::msgcat::mcset pb_msg_french "MC(other,ude_include,Label)"            "Inclure un autre fichier CDL"
::msgcat::mcset pb_msg_french "MC(other,ude_include,Context)"          "Cette option permet au Post d'inclure une référence à un fichier CDL dans son fichier de définition."

::msgcat::mcset pb_msg_french "MC(other,ude_file,Label)"               "Nom du fichier CDL"
::msgcat::mcset pb_msg_french "MC(other,ude_file,Context)"             "Chemin et nom de fichier CDL à référencer (INCLUDE) dans le fichier de définition de ce Post. Le nom de chemin doit commencer par une variable d'environnement UG (\\\$UGII) ou rien.  Si aucun chemin n'est spécifié, UGII_CAM_FILE_SEARCH_PATH sera utilisé pour que UG/NX trouve le fichier lors de l'exécution."
::msgcat::mcset pb_msg_french "MC(other,ude_select,Label)"             "Sélect. Nom"
::msgcat::mcset pb_msg_french "MC(other,ude_select,Context)"           "Sélectionner un fichier CDL à référencer (INCLUDE) dans le fichier de définition de ce post. Par défaut, le nom du fichier sera précédé de \\\$UGII_CAM_USER_DEF_EVENT_DIR/. Vous pourrez éditer le nom du chemin après la sélection."


#+++++++++++++++++
# Output Settings
#+++++++++++++++++
::msgcat::mcset pb_msg_french "MC(output,tab,Label)"                   "Paramètres de sortie"
::msgcat::mcset pb_msg_french "MC(output,Status)"                      "Configurer les paramètres de sortie"

#++++++++++++++
# VNC Controls
#++++++++++++++
::msgcat::mcset pb_msg_french "MC(output,vnc,Label)"                   "Contrôle numérique virtuel"
::msgcat::mcset pb_msg_french "MC(output,vnc,mode,std,Label)"          "Autonome"
::msgcat::mcset pb_msg_french "MC(output,vnc,mode,sub,Label)"          "Subordonné"
::msgcat::mcset pb_msg_french "MC(output,vnc,status,Label)"            "Sélectionner un fichier VNC."
::msgcat::mcset pb_msg_french "MC(output,vnc,mis_match,Label)"         "Le fichier sélectionné ne correspond pas au nom de fichier VNC par défaut.\n Voulez-vous resélectionner le fichier?"
::msgcat::mcset pb_msg_french "MC(output,vnc,output,Label)"            "Générer un Contrôle numérique virtuel (VNC)"
::msgcat::mcset pb_msg_french "MC(output,vnc,output,Context)"          "Cette option permet de générer un Contrôle numérique virtuel (VNC). Un Post créé avec VNC peut alors être utilisé pour ISV."
::msgcat::mcset pb_msg_french "MC(output,vnc,main,Label)"              "VNC Master"
::msgcat::mcset pb_msg_french "MC(output,vnc,main,Context)"            "Le nom du VNC master qui sera exécuté par un VNC subordonné. Lors de l'exécution de ISV, il est supposé que ce Post est situé dans le répertoire où se trouve le VNC subordonné, sinon sera utilisé un Post de même nom situé dans le répertoire \\\$UGII_CAM_POST_DIR."


::msgcat::mcset pb_msg_french "MC(output,vnc,main,err_msg)"                 "Le VNC Master doit être spécifié pour un VNC subordonné."
::msgcat::mcset pb_msg_french "MC(output,vnc,main,select_name,Label)"       "Sélect. Nom"
::msgcat::mcset pb_msg_french "MC(output,vnc,main,select_name,Context)"     "Sélectionner le nom d'un VNC à exécuter par un VNC subordonné. Lors de l'exécution de ISV, il est supposé que ce Post est situé dans le répertoire où se trouve le VNC subordonné, sinon sera utilisé un Post de même nom situé dans le répertoire \\\$UGII_CAM_POST_DIR."

::msgcat::mcset pb_msg_french "MC(output,vnc,mode,Label)"                   "Mode du Contrôle numérique virtuel"
::msgcat::mcset pb_msg_french "MC(output,vnc,mode,Context)"                 "Un Contrôle numérique virtuel peut être soit Autonome, soit Subordonné à un VNC Master."
::msgcat::mcset pb_msg_french "MC(output,vnc,mode,std,Context)"             "Un VNC Autonome est indépendant."
::msgcat::mcset pb_msg_french "MC(output,vnc,mode,sub,Context)"             "Un VNC Subordonné dépend largement de son VNC Master.  Il exécute le VNC Master lors de l'exécution de ISV."
::msgcat::mcset pb_msg_french "MC(output,vnc,pb_ver,msg)"                   "Contrôle numérique virtuel créé avec Post Builder "
#++++++++++++++
# Listing File
#++++++++++++++
::msgcat::mcset pb_msg_french "MC(listing,tab,Label)"                  "Fichier liste"
::msgcat::mcset pb_msg_french "MC(listing,Status)"                     "Spécifier les paramètres du fichier liste"

::msgcat::mcset pb_msg_french "MC(listing,gen,Label)"                  "Générer le fichier liste"
::msgcat::mcset pb_msg_french "MC(listing,gen,Context)"                "Cette bascule permet d'activer/désactiver l'écriture du fichier liste."

::msgcat::mcset pb_msg_french "MC(listing,Label)"                      "Eléments du fichier liste"
::msgcat::mcset pb_msg_french "MC(listing,parms,Label)"                "Composants"

::msgcat::mcset pb_msg_french "MC(listing,parms,x,Label)"              "Coordonnée X"
::msgcat::mcset pb_msg_french "MC(listing,parms,x,Context)"            "Cette bascule permet d'activer/désactiver l'écriture des coordonnées X dans le fichier liste."

::msgcat::mcset pb_msg_french "MC(listing,parms,y,Label)"              "Coordonnée Y"
::msgcat::mcset pb_msg_french "MC(listing,parms,y,Context)"            "Cette bascule permet d'activer/désactiver l'écriture des coordonnées Y dans le fichier liste."

::msgcat::mcset pb_msg_french "MC(listing,parms,z,Label)"              "Coordonnée Z"
::msgcat::mcset pb_msg_french "MC(listing,parms,z,Context)"            "Cette bascule permet d'activer/désactiver l'écriture des coordonnées Z dans le fichier liste."

::msgcat::mcset pb_msg_french "MC(listing,parms,4,Label)"              "Angle du 4ème axe"
::msgcat::mcset pb_msg_french "MC(listing,parms,4,Context)"            "Cette bascule permet d'activer/désactiver l'écriture de l'angle du 4ème axe dans le fichier liste."

::msgcat::mcset pb_msg_french "MC(listing,parms,5,Label)"              "Angle du 5ème axe"
::msgcat::mcset pb_msg_french "MC(listing,parms,5,Context)"            "Cette bascule permet d'activer/désactiver l'écriture de l'angle du 5ème axe dans le fichier liste."

::msgcat::mcset pb_msg_french "MC(listing,parms,feed,Label)"           "Avance"
::msgcat::mcset pb_msg_french "MC(listing,parms,feed,Context)"         "Cette bascule permet d'activer/désactiver l'écriture de l'avance dans le fichier liste."

::msgcat::mcset pb_msg_french "MC(listing,parms,speed,Label)"          "Vitesse"
::msgcat::mcset pb_msg_french "MC(listing,parms,speed,Context)"        "Cette bascule permet d'activer/désactiver l'écriture de la vitesse de broche dans le fichier liste."

::msgcat::mcset pb_msg_french "MC(listing,extension,Label)"            "Extension du fichier liste"
::msgcat::mcset pb_msg_french "MC(listing,extension,Context)"          "Spécifier l'extension du fichier liste"

::msgcat::mcset pb_msg_french "MC(listing,nc_file,Label)"              "Extension du fichier de sortie CN"
::msgcat::mcset pb_msg_french "MC(listing,nc_file,Context)"            "Spécifier l'extension du fichier de sortie CN"

::msgcat::mcset pb_msg_french "MC(listing,header,Label)"               "En-tête de programme "
::msgcat::mcset pb_msg_french "MC(listing,header,oper_list,Label)"     "Liste d'opérations"
::msgcat::mcset pb_msg_french "MC(listing,header,tool_list,Label)"     "Liste d'outils"

::msgcat::mcset pb_msg_french "MC(listing,footer,Label)"               "Fin de programme "
::msgcat::mcset pb_msg_french "MC(listing,footer,cut_time,Label)"      "Durée totale d'usinage"

::msgcat::mcset pb_msg_french "MC(listing,format,Label)"                   "Format de page"
::msgcat::mcset pb_msg_french "MC(listing,format,print_header,Label)"      "Imprimer l'en-tête de page"
::msgcat::mcset pb_msg_french "MC(listing,format,print_header,Context)"    "Cette bascule permet d'activer/désactiver l'écriture de l'en-tête de page dans le fichier liste."

::msgcat::mcset pb_msg_french "MC(listing,format,length,Label)"        "Longueur de page (Lignes)"
::msgcat::mcset pb_msg_french "MC(listing,format,length,Context)"      "Spécifier le nombre de lignes par page dans le fichier liste."
::msgcat::mcset pb_msg_french "MC(listing,format,width,Label)"         "Largeur de page (Colonnes)"
::msgcat::mcset pb_msg_french "MC(listing,format,width,Context)"       "Spécifier le nombre de colonnes par page dans le fichier liste."

::msgcat::mcset pb_msg_french "MC(listing,other,tab,Label)"            "Autres Options"
::msgcat::mcset pb_msg_french "MC(listing,output,Label)"               "Ecrire les éléments de contrôle"

::msgcat::mcset pb_msg_french "MC(listing,output,warning,Label)"       "Ecrire les messages d'avertissement"
::msgcat::mcset pb_msg_french "MC(listing,output,warning,Context)"     "Cette bascule permet d'activer/désactiver l'écriture des messages d'avertissement lors du post-traitement."

::msgcat::mcset pb_msg_french "MC(listing,output,review,Label)"        "Activer l'Outil de vérification"
::msgcat::mcset pb_msg_french "MC(listing,output,review,Context)"      "Cette bascule permet d'activer l'Outil de vérification pendant le post-traitement."

::msgcat::mcset pb_msg_french "MC(listing,output,group,Label)"         "Générer la sortie de groupe"
::msgcat::mcset pb_msg_french "MC(listing,output,group,Context)"       "Cette bascule permet d'activer/désactiver le contrôle de la sortie de groupe lors du post-traitement."

::msgcat::mcset pb_msg_french "MC(listing,output,verbose,Label)"       "Afficher les messages d'erreur complets"
::msgcat::mcset pb_msg_french "MC(listing,output,verbose,Context)"     "Cette bascule permet d'afficher les descriptions complètes pour les conditions d'erreur. Ceci ralentit la vitesse de post-traitement."

::msgcat::mcset pb_msg_french "MC(listing,oper_info,Label)"            "Information d'Opération"
::msgcat::mcset pb_msg_french "MC(listing,oper_info,parms,Label)"      "Paramètres d'Opération"
::msgcat::mcset pb_msg_french "MC(listing,oper_info,tool,Label)"       "Paramètres outil"
::msgcat::mcset pb_msg_french "MC(listing,oper_info,cut_time,,Label)"  "Durée d'usinage"


#<09-19-00 gsl>
::msgcat::mcset pb_msg_french "MC(listing,user_tcl,frame,Label)"       "Exécution TCL utilisateur"
::msgcat::mcset pb_msg_french "MC(listing,user_tcl,check,Label)"       "Exécuter le fichier TCL utilisateur"
::msgcat::mcset pb_msg_french "MC(listing,user_tcl,check,Context)"     "Cette bascule permet d'exécuter votre propre fichier TCL"
::msgcat::mcset pb_msg_french "MC(listing,user_tcl,name,Label)"        "Nom du fichier"
::msgcat::mcset pb_msg_french "MC(listing,user_tcl,name,Context)"      "Spécifier le nom d'un fichier TCL à exécuter pour ce Post"

#++++++++++++++++
# Output Preview
#++++++++++++++++
::msgcat::mcset pb_msg_french "MC(preview,tab,Label)"                  "Aperçu des fichiers Post"
::msgcat::mcset pb_msg_french "MC(preview,new_code,Label)"             "Nouveau Code"
::msgcat::mcset pb_msg_french "MC(preview,old_code,Label)"             "Ancien Code"

##---------------------
## Event Handler
##
::msgcat::mcset pb_msg_french "MC(event_handler,tab,Label)"            "Handlers d'événements"
::msgcat::mcset pb_msg_french "MC(event_handler,Status)"               "Choisir l'événement pour voir la procédure"

##---------------------
## Definition
##
::msgcat::mcset pb_msg_french "MC(definition,tab,Label)"               "Définitions"
::msgcat::mcset pb_msg_french "MC(definition,Status)"                  "Choisir l'élément pour voir le contenu"

#++++++++++++++
# Post Advisor
#++++++++++++++
::msgcat::mcset pb_msg_french "MC(advisor,tab,Label)"                  "Post Advisor"
::msgcat::mcset pb_msg_french "MC(advisor,Status)"                     "Post Advisor"

::msgcat::mcset pb_msg_french "MC(definition,word_txt,Label)"          "WORD_SEPARATOR"
::msgcat::mcset pb_msg_french "MC(definition,end_txt,Label)"           "END_OF_BLOCK"
::msgcat::mcset pb_msg_french "MC(definition,seq_txt,Label)"           "SEQUENCE_NUM"
::msgcat::mcset pb_msg_french "MC(definition,include,Label)"           "INCLUDE"
::msgcat::mcset pb_msg_french "MC(definition,format_txt,Label)"        "FORMAT"
::msgcat::mcset pb_msg_french "MC(definition,addr_txt,Label)"          "MOT"
::msgcat::mcset pb_msg_french "MC(definition,block_txt,Label)"         "BLOC"
::msgcat::mcset pb_msg_french "MC(definition,comp_txt,Label)"          "BLOC composite"
::msgcat::mcset pb_msg_french "MC(definition,post_txt,Label)"          "BLOC Post"
::msgcat::mcset pb_msg_french "MC(definition,oper_txt,Label)"          "Message Opérateur"

#+++++++++++++
# Balloon
#+++++++++++++
::msgcat::mcset pb_msg_french "MC(msg,odd)"                            "Nb impair d'arguments opt."
::msgcat::mcset pb_msg_french "MC(msg,wrong_list_1)"                   "Option(s) inconnues"
::msgcat::mcset pb_msg_french "MC(msg,wrong_list_2)"                   ". Doit être l'un parmi:"

#+++++++++++++++++
# Event UI Labels
#+++++++++++++++++

### Program Start
::msgcat::mcset pb_msg_french "MC(event,start_prog,name)"              "Début du programme"

### Operation Start
::msgcat::mcset pb_msg_french "MC(event,opr_start,start_path,name)"    "Début du parcours"
::msgcat::mcset pb_msg_french "MC(event,opr_start,from_move,name)"     "Mouvement Depuis"
::msgcat::mcset pb_msg_french "MC(event,opr_start,fst_tool,name)"      "Premier outil"
::msgcat::mcset pb_msg_french "MC(event,opr_start,auto_tc,name)"       "Changement d'outil auto"
::msgcat::mcset pb_msg_french "MC(event,opr_start,manual_tc,name)"     "Changement d'outil manuel"
::msgcat::mcset pb_msg_french "MC(event,opr_start,init_move,name)"     "Mouvement initial"
::msgcat::mcset pb_msg_french "MC(event,opr_start,fst_move,name)"      "Premier mouvement"
::msgcat::mcset pb_msg_french "MC(event,opr_start,appro_move,name)"    "Mouvement d'approche"
::msgcat::mcset pb_msg_french "MC(event,opr_start,engage_move,name)"   "Mouvement d'engagement"
::msgcat::mcset pb_msg_french "MC(event,opr_start,fst_cut,name)"       "1er usinage"
::msgcat::mcset pb_msg_french "MC(event,opr_start,fst_lin_move,name)"  "1er mouvement linéaire"
::msgcat::mcset pb_msg_french "MC(event,opr_start,start_pass,name)"    "Début de passe"
::msgcat::mcset pb_msg_french "MC(event,opr_start,cutcom_move,name)"   "Mouvement Corr. Outil"
::msgcat::mcset pb_msg_french "MC(event,opr_start,lead_move,name)"     "Mouvement d'entrée"

### Operation End
::msgcat::mcset pb_msg_french "MC(event,opr_end,ret_move,name)"        "Mouvement de retrait"
::msgcat::mcset pb_msg_french "MC(event,opr_end,rtn_move,name)"        "Mouvement de dégagement"
::msgcat::mcset pb_msg_french "MC(event,opr_end,goh_move,name)"        "Mouvement Gohome"
::msgcat::mcset pb_msg_french "MC(event,opr_end,end_path,name)"        "Fin du parcours"
::msgcat::mcset pb_msg_french "MC(event,opr_end,lead_move,name)"       "Mouvement de sortie"
::msgcat::mcset pb_msg_french "MC(event,opr_end,end_pass,name)"        "Fin de passe"

### Program End
::msgcat::mcset pb_msg_french "MC(event,end_prog,name)"                "Fin du programme"


### Tool Change
::msgcat::mcset pb_msg_french "MC(event,tool_change,name)"             "Changement d'outil"
::msgcat::mcset pb_msg_french "MC(event,tool_change,m_code)"           "Code M"
::msgcat::mcset pb_msg_french "MC(event,tool_change,m_code,tl_chng)"   "Changement d'outil"
::msgcat::mcset pb_msg_french "MC(event,tool_change,m_code,pt)"        "Tourelle principale"
::msgcat::mcset pb_msg_french "MC(event,tool_change,m_code,st)"        "Tourelle secondaire"
::msgcat::mcset pb_msg_french "MC(event,tool_change,t_code)"           "Code T"
::msgcat::mcset pb_msg_french "MC(event,tool_change,t_code,conf)"      "Configurer"
::msgcat::mcset pb_msg_french "MC(event,tool_change,t_code,pt_idx)"    "Index de tourelle principale"
::msgcat::mcset pb_msg_french "MC(event,tool_change,t_code,st_idx)"    "Index de tourelle de secondaire"
::msgcat::mcset pb_msg_french "MC(event,tool_change,tool_num)"         "Numéro d'outil"
::msgcat::mcset pb_msg_french "MC(event,tool_change,tool_num,min)"     "Minimum"
::msgcat::mcset pb_msg_french "MC(event,tool_change,tool_num,max)"     "Maximum"
::msgcat::mcset pb_msg_french "MC(event,tool_change,time)"             "Temps (s)"
::msgcat::mcset pb_msg_french "MC(event,tool_change,time,tl_chng)"     "Changement d'outil"
::msgcat::mcset pb_msg_french "MC(event,tool_change,retract)"          "Retrait"
::msgcat::mcset pb_msg_french "MC(event,tool_change,retract_z)"        "Retrait au Z de"

### Length Compensation
::msgcat::mcset pb_msg_french "MC(event,length_compn,name)"            "Compensation de longueur"
::msgcat::mcset pb_msg_french "MC(event,length_compn,g_code)"          "Code G"
::msgcat::mcset pb_msg_french "MC(event,length_compn,g_code,len_adj)"  "Compensation de longueur d'outil"
::msgcat::mcset pb_msg_french "MC(event,length_compn,t_code)"          "Code T"
::msgcat::mcset pb_msg_french "MC(event,length_compn,t_code,conf)"     "Configurer"
::msgcat::mcset pb_msg_french "MC(event,length_compn,len_off)"         "Registre de décalage de longueur"
::msgcat::mcset pb_msg_french "MC(event,length_compn,len_off,min)"     "Minimum"
::msgcat::mcset pb_msg_french "MC(event,length_compn,len_off,max)"     "Maximum"

### Set Modes
::msgcat::mcset pb_msg_french "MC(event,set_modes,name)"               "Définir les modes"
::msgcat::mcset pb_msg_french "MC(event,set_modes,out_mode)"           "Mode d'écriture"
::msgcat::mcset pb_msg_french "MC(event,set_modes,g_code)"             "Code G"
::msgcat::mcset pb_msg_french "MC(event,set_modes,g_code,absolute)"    "Absolu"
::msgcat::mcset pb_msg_french "MC(event,set_modes,g_code,incremental)" "Incrémental"
::msgcat::mcset pb_msg_french "MC(event,set_modes,rotary_axis)"        "Axe de rotation peut être incrémenté"

### Spindle RPM
::msgcat::mcset pb_msg_french "MC(event,spindle_rpm,name)"                     "RPM de broche"
::msgcat::mcset pb_msg_french "MC(event,spindle_rpm,dir_m_code)"               "Codes M de direction de broche"
::msgcat::mcset pb_msg_french "MC(event,spindle_rpm,dir_m_code,cw)"            "Sens horaire (CW)"
::msgcat::mcset pb_msg_french "MC(event,spindle_rpm,dir_m_code,ccw)"           "Sens antihoraire (CCW)"
::msgcat::mcset pb_msg_french "MC(event,spindle_rpm,range_control)"            "Contrôle de gamme de broche"
::msgcat::mcset pb_msg_french "MC(event,spindle_rpm,range_control,dwell_time)" "Durée de tempo de changement de gamme (s)"
::msgcat::mcset pb_msg_french "MC(event,spindle_rpm,range_control,range_code)" "Spécifier le code de gamme"

### Spindle CSS
::msgcat::mcset pb_msg_french "MC(event,spindle_css,name)"             "VCC de broche "
::msgcat::mcset pb_msg_french "MC(event,spindle_css,g_code)"           "Code G de broche"
::msgcat::mcset pb_msg_french "MC(event,spindle_css,g_code,const)"     "Code de vitesse constante"
::msgcat::mcset pb_msg_french "MC(event,spindle_css,g_code,max)"       "Code de RPM maxi"
::msgcat::mcset pb_msg_french "MC(event,spindle_css,g_code,sfm)"       "Code pour annuler VCC"
::msgcat::mcset pb_msg_french "MC(event,spindle_css,max)"              "RPM maxi pendant VCC"
::msgcat::mcset pb_msg_french "MC(event,spindle_css,sfm)"              "Toujours en mode IPR pour VCC"

### Spindle Off
::msgcat::mcset pb_msg_french "MC(event,spindle_off,name)"             "Broche Désactivée"
::msgcat::mcset pb_msg_french "MC(event,spindle_off,dir_m_code)"       "Code M de direction de broche"
::msgcat::mcset pb_msg_french "MC(event,spindle_off,dir_m_code,off)"   "Désactivé"

### Coolant On
::msgcat::mcset pb_msg_french "MC(event,coolant_on,name)"              "Arrosage ON"
::msgcat::mcset pb_msg_french "MC(event,coolant_on,m_code)"            "Code M"
::msgcat::mcset pb_msg_french "MC(event,coolant_on,m_code,on)"         "Activé"
::msgcat::mcset pb_msg_french "MC(event,coolant_on,m_code,flood)"      "Arrosage"
::msgcat::mcset pb_msg_french "MC(event,coolant_on,m_code,mist)"       "Brouillard"
::msgcat::mcset pb_msg_french "MC(event,coolant_on,m_code,thru)"       "A travers"
::msgcat::mcset pb_msg_french "MC(event,coolant_on,m_code,tap)"        "Taraudage"

### Coolant Off
::msgcat::mcset pb_msg_french "MC(event,coolant_off,name)"             "Arrosage arrêté"
::msgcat::mcset pb_msg_french "MC(event,coolant_off,m_code)"           "Code M"
::msgcat::mcset pb_msg_french "MC(event,coolant_off,m_code,off)"       "Désactivé"

### Inch Metric Mode
::msgcat::mcset pb_msg_french "MC(event,inch_metric_mode,name)"            "Mode Inch Métrique"
::msgcat::mcset pb_msg_french "MC(event,inch_metric_mode,g_code)"          "Code G"
::msgcat::mcset pb_msg_french "MC(event,inch_metric_mode,g_code,english)"  "Anglaises (pouces)"
::msgcat::mcset pb_msg_french "MC(event,inch_metric_mode,g_code,metric)"   "Métriques (millimètres)"

### Feedrates
::msgcat::mcset pb_msg_french "MC(event,feedrates,name)"               "Avances"
::msgcat::mcset pb_msg_french "MC(event,feedrates,ipm_mode)"           "Mode IPM"
::msgcat::mcset pb_msg_french "MC(event,feedrates,ipr_mode)"           "Mode IPR"
::msgcat::mcset pb_msg_french "MC(event,feedrates,dpm_mode)"           "Mode DPM"
::msgcat::mcset pb_msg_french "MC(event,feedrates,mmpm_mode)"          "Mode MMPM"
::msgcat::mcset pb_msg_french "MC(event,feedrates,mmpr_mode)"          "Mode MMPR"
::msgcat::mcset pb_msg_french "MC(event,feedrates,frn_mode)"           "Mode FRN"
::msgcat::mcset pb_msg_french "MC(event,feedrates,g_code)"             "Code G"
::msgcat::mcset pb_msg_french "MC(event,feedrates,format)"             "Format"
::msgcat::mcset pb_msg_french "MC(event,feedrates,max)"                "Maximum"
::msgcat::mcset pb_msg_french "MC(event,feedrates,min)"                "Minimum"
::msgcat::mcset pb_msg_french "MC(event,feedrates,mode,label)"         "Modes d'avance"
::msgcat::mcset pb_msg_french "MC(event,feedrates,mode,lin)"           "Linéaire seulement"
::msgcat::mcset pb_msg_french "MC(event,feedrates,mode,rot)"           "Rotation seulement"
::msgcat::mcset pb_msg_french "MC(event,feedrates,mode,lin_rot)"       "Linéaire et rotation"
::msgcat::mcset pb_msg_french "MC(event,feedrates,mode,rap_lin)"       "Linéaire rapide seulement"
::msgcat::mcset pb_msg_french "MC(event,feedrates,mode,rap_rot)"       "Rotation rapide seulement"
::msgcat::mcset pb_msg_french "MC(event,feedrates,mode,rap_lin_rot)"   "Linéaire et rotation rapide"
::msgcat::mcset pb_msg_french "MC(event,feedrates,cycle_mode)"         "Mode d'avance des cycles"
::msgcat::mcset pb_msg_french "MC(event,feedrates,cycle)"              "Cycle"

### Cutcom On
::msgcat::mcset pb_msg_french "MC(event,cutcom_on,name)"               "Corr. Outil On"
::msgcat::mcset pb_msg_french "MC(event,cutcom_on,g_code)"             "Code G"
::msgcat::mcset pb_msg_french "MC(event,cutcom_on,left)"               "Gauche"
::msgcat::mcset pb_msg_french "MC(event,cutcom_on,right)"              "Droite"
::msgcat::mcset pb_msg_french "MC(event,cutcom_on,app_planes)"         "Plans applicables"
::msgcat::mcset pb_msg_french "MC(event,cutcom_on,edit_planes)"        "Editer les codes des plans"
::msgcat::mcset pb_msg_french "MC(event,cutcom_on,reg)"                "Registre de correction"
::msgcat::mcset pb_msg_french "MC(event,cutcom_on,min)"                "Minimum"
::msgcat::mcset pb_msg_french "MC(event,cutcom_on,max)"                "Maximum"
::msgcat::mcset pb_msg_french "MC(event,cutcom_on,bef)"                "Corr. Outil désactivée avant Changement"

### Cutcom Off
::msgcat::mcset pb_msg_french "MC(event,cutcom_off,name)"              "Corr. Outil désactivée"
::msgcat::mcset pb_msg_french "MC(event,cutcom_off,g_code)"            "Code G"
::msgcat::mcset pb_msg_french "MC(event,cutcom_off,off)"               "Désactivé"

### Delay
::msgcat::mcset pb_msg_french "MC(event,delay,name)"                   "Tempo"
::msgcat::mcset pb_msg_french "MC(event,delay,seconds)"                "secondes"
::msgcat::mcset pb_msg_french "MC(event,delay,seconds,g_code)"         "Code G"
::msgcat::mcset pb_msg_french "MC(event,delay,seconds,format)"         "Format"
::msgcat::mcset pb_msg_french "MC(event,delay,out_mode)"               "Mode d'écriture"
::msgcat::mcset pb_msg_french "MC(event,delay,out_mode,sec)"           "Secondes seulement"
::msgcat::mcset pb_msg_french "MC(event,delay,out_mode,rev)"           "Tours seulement"
::msgcat::mcset pb_msg_french "MC(event,delay,out_mode,feed)"          "Dépend de l'avance"
::msgcat::mcset pb_msg_french "MC(event,delay,out_mode,ivs)"           "Inverse du temps"
::msgcat::mcset pb_msg_french "MC(event,delay,revolution)"             "Tours"
::msgcat::mcset pb_msg_french "MC(event,delay,revolution,g_code)"      "Code G"
::msgcat::mcset pb_msg_french "MC(event,delay,revolution,format)"      "Format"

### Option Stop
::msgcat::mcset pb_msg_french "MC(event,opstop,name)"                  "Opstop"

### Auxfun
::msgcat::mcset pb_msg_french "MC(event,auxfun,name)"                  "Auxfun"

### Prefun
::msgcat::mcset pb_msg_french "MC(event,prefun,name)"                  "Prefun"

### Load Tool
::msgcat::mcset pb_msg_french "MC(event,loadtool,name)"                "Chargement d'outil"

### Stop
::msgcat::mcset pb_msg_french "MC(event,stop,name)"                    "Arrêt"

### Tool Preselect
::msgcat::mcset pb_msg_french "MC(event,toolpreselect,name)"           "Présélection d'outil"

### Thread Wire
::msgcat::mcset pb_msg_french "MC(event,threadwire,name)"              "Enfiler le fil"

### Cut Wire
::msgcat::mcset pb_msg_french "MC(event,cutwire,name)"                 "Couper le fil"

### Wire Guides
::msgcat::mcset pb_msg_french "MC(event,wireguides,name)"              "Guides du fil"

### Linear Move
::msgcat::mcset pb_msg_french "MC(event,linear,name)"                  "Mouvement linéaire"
::msgcat::mcset pb_msg_french "MC(event,linear,g_code)"                "Code G"
::msgcat::mcset pb_msg_french "MC(event,linear,motion)"                "Mouvement linéaire"
::msgcat::mcset pb_msg_french "MC(event,linear,assume)"                "Mode rapide supposé à l'avance de franchissement maxi"

### Circular Move
::msgcat::mcset pb_msg_french "MC(event,circular,name)"                "Mouvement circulaire"
::msgcat::mcset pb_msg_french "MC(event,circular,g_code)"              "Code G de mouvement"
::msgcat::mcset pb_msg_french "MC(event,circular,clockwise)"           "Sens horaire(CLW)"
::msgcat::mcset pb_msg_french "MC(event,circular,counter-clock)"       "Sens antihoraire(CCLW)"
::msgcat::mcset pb_msg_french "MC(event,circular,record)"              "Instruction circulaire"
::msgcat::mcset pb_msg_french "MC(event,circular,full_circle)"         "Cercle Complet"
::msgcat::mcset pb_msg_french "MC(event,circular,quadrant)"            "Quadrant"
::msgcat::mcset pb_msg_french "MC(event,circular,ijk_def)"             "Définition IJK"
::msgcat::mcset pb_msg_french "MC(event,circular,ij_def)"              "Définition IJ"
::msgcat::mcset pb_msg_french "MC(event,circular,ik_def)"              "Définition IK"
::msgcat::mcset pb_msg_french "MC(event,circular,planes)"              "Plans applicables"
::msgcat::mcset pb_msg_french "MC(event,circular,edit_planes)"         "Editer les codes des plans"
::msgcat::mcset pb_msg_french "MC(event,circular,radius)"              "Rayon"
::msgcat::mcset pb_msg_french "MC(event,circular,min)"                 "Minimum"
::msgcat::mcset pb_msg_french "MC(event,circular,max)"                 "Maximum"
::msgcat::mcset pb_msg_french "MC(event,circular,arc_len)"             "Longueur d'arc mini"

### Rapid Move
::msgcat::mcset pb_msg_french "MC(event,rapid,name)"                   "Mouvement rapide"
::msgcat::mcset pb_msg_french "MC(event,rapid,g_code)"                 "Code G"
::msgcat::mcset pb_msg_french "MC(event,rapid,motion)"                 "Mouvement rapide"
::msgcat::mcset pb_msg_french "MC(event,rapid,plane_change)"           "Changement de plan de travail"

### Lathe Thread
::msgcat::mcset pb_msg_french "MC(event,lathe,name)"                   "Filetage"
::msgcat::mcset pb_msg_french "MC(event,lathe,g_code)"                 "Code G de filetage"
::msgcat::mcset pb_msg_french "MC(event,lathe,cons)"                   "Constant"
::msgcat::mcset pb_msg_french "MC(event,lathe,incr)"                   "Incrémental"
::msgcat::mcset pb_msg_french "MC(event,lathe,decr)"                   "Incrémental inverse"

### Cycle
::msgcat::mcset pb_msg_french "MC(event,cycle,g_code)"                 "Code G et Personnalisation"
::msgcat::mcset pb_msg_french "MC(event,cycle,customize,Label)"        "Personnaliser"
::msgcat::mcset pb_msg_french "MC(event,cycle,customize,Context)"      "Cette bascule permet de personnaliser un cycle. \n\nPar défaut, la construction de base de chaque cycle est définie par le paramétrage des Paramètres communs. Ces éléments communs dans chaque cycle sont limités à d'éventuelles modifications. \n\nL'activation de cette bascule permet de prendre le contrôle total sur la configuration d'un cycle. Les modifications apportées aux Paramètres communs n'affecteront plus les cycles personnalisés."
::msgcat::mcset pb_msg_french "MC(event,cycle,start,Label)"            "Départ du cycle"
::msgcat::mcset pb_msg_french "MC(event,cycle,start,Context)"          "Cette option peut être activée pour les machines-outils qui exécutent les cycles avec un bloc de départ de cycle (G79...) après que le cycle a été défini (par G81...)."
::msgcat::mcset pb_msg_french "MC(event,cycle,start,text)"             "Utiliser le bloc de départ de cycle pour exécuter le cycle"
::msgcat::mcset pb_msg_french "MC(event,cycle,rapid_to)"               "Rapide - Vers"
::msgcat::mcset pb_msg_french "MC(event,cycle,retract_to)"             "Retrait - Vers"
::msgcat::mcset pb_msg_french "MC(event,cycle,plane_control)"          "Contrôle du plan des cycles"
::msgcat::mcset pb_msg_french "MC(event,cycle,com_param,name)"         "Paramètres communs"
::msgcat::mcset pb_msg_french "MC(event,cycle,cycle_off,name)"         "Cycle Désactivé"
::msgcat::mcset pb_msg_french "MC(event,cycle,plane_chng,name)"        "Changement de plan du cycle"
::msgcat::mcset pb_msg_french "MC(event,cycle,drill,name)"             "Perçage"
::msgcat::mcset pb_msg_french "MC(event,cycle,drill_dwell,name)"       "Perçage avec tempo"
::msgcat::mcset pb_msg_french "MC(event,cycle,drill_text,name)"        "Texte de perçage"
::msgcat::mcset pb_msg_french "MC(event,cycle,drill_csink,name)"       "Perçage avec fraisure"
::msgcat::mcset pb_msg_french "MC(event,cycle,drill_deep,name)"        "Perçage profond"
::msgcat::mcset pb_msg_french "MC(event,cycle,drill_brk_chip,name)"    "Perçage brise copeaux"
::msgcat::mcset pb_msg_french "MC(event,cycle,tap,name)"               "Taraudage"
::msgcat::mcset pb_msg_french "MC(event,cycle,bore,name)"              "Alésage"
::msgcat::mcset pb_msg_french "MC(event,cycle,bore_dwell,name)"        "Alésage avec tempo"
::msgcat::mcset pb_msg_french "MC(event,cycle,bore_drag,name)"         "Alésage en tirant"
::msgcat::mcset pb_msg_french "MC(event,cycle,bore_no_drag,name)"      "Alésage sans tirer"
::msgcat::mcset pb_msg_french "MC(event,cycle,bore_back,name)"         "Alésage avec retour"
::msgcat::mcset pb_msg_french "MC(event,cycle,bore_manual,name)"       "Alésage manuel"
::msgcat::mcset pb_msg_french "MC(event,cycle,bore_manual_dwell,name)" "Alésage manuel avec tempo"
::msgcat::mcset pb_msg_french "MC(event,cycle,peck_drill,name)"        "Débourrage"
::msgcat::mcset pb_msg_french "MC(event,cycle,break_chip,name)"        "Brise Copeaux"
::msgcat::mcset pb_msg_french "MC(event,cycle,drill_dwell_sf,name)"    "Perçage avec tempo (Dressage)"
::msgcat::mcset pb_msg_french "MC(event,cycle,drill_deep_peck,name)"   "Perçage profond (Débourrage)"
::msgcat::mcset pb_msg_french "MC(event,cycle,bore_ream,name)"         "Alésage (Alésoir)"
::msgcat::mcset pb_msg_french "MC(event,cycle,bore_no-drag,name)"      "Alésage sans tirer"

##------------
## G Code
##
::msgcat::mcset pb_msg_french "MC(g_code,rapid,name)"                  "Mouvement rapide"
::msgcat::mcset pb_msg_french "MC(g_code,linear,name)"                 "Mouvement linéaire"
::msgcat::mcset pb_msg_french "MC(g_code,circular_clw,name)"           "Interpolation circulaire CLW"
::msgcat::mcset pb_msg_french "MC(g_code,circular_cclw,name)"          "Interpolation circulaire CCLW"
::msgcat::mcset pb_msg_french "MC(g_code,delay_sec,name)"              "Tempo (s)"
::msgcat::mcset pb_msg_french "MC(g_code,delay_rev,name)"              "Tempo (tour)"
::msgcat::mcset pb_msg_french "MC(g_code,pln_xy,name)"                 "Plan XY"
::msgcat::mcset pb_msg_french "MC(g_code,pln_zx,name)"                 "Plan ZX"
::msgcat::mcset pb_msg_french "MC(g_code,pln_yz,name)"                 "Plan YZ"
::msgcat::mcset pb_msg_french "MC(g_code,cutcom_off,name)"             "Corr. Outil désactivée"
::msgcat::mcset pb_msg_french "MC(g_code,cutcom_left,name)"            "Corr. Outil Gauche"
::msgcat::mcset pb_msg_french "MC(g_code,cutcom_right,name)"           "Corr. Outil Droite"
::msgcat::mcset pb_msg_french "MC(g_code,length_plus,name)"            "Correcteur de longueur d'outil Plus"
::msgcat::mcset pb_msg_french "MC(g_code,length_minus,name)"           "Correcteur de longueur d'outil Moins"
::msgcat::mcset pb_msg_french "MC(g_code,length_off,name)"             "Correcteur de longueur d'outil OFF"
::msgcat::mcset pb_msg_french "MC(g_code,inch,name)"                   "Mode Inch"
::msgcat::mcset pb_msg_french "MC(g_code,metric,name)"                 "Mode Métrique"
::msgcat::mcset pb_msg_french "MC(g_code,cycle_start,name)"            "Code de départ du cycle"
::msgcat::mcset pb_msg_french "MC(g_code,cycle_off,name)"              "Cycle Désactivé"
::msgcat::mcset pb_msg_french "MC(g_code,cycle_drill,name)"            "Cycle de perçage"
::msgcat::mcset pb_msg_french "MC(g_code,cycle_drill_dwell,name)"      "Cycle de perçage avec tempo"
::msgcat::mcset pb_msg_french "MC(g_code,cycle_drill_deep,name)"       "Cycle de perçage profond"
::msgcat::mcset pb_msg_french "MC(g_code,cycle_drill_bc,name)"         "Cycle de perçage brise copeaux"
::msgcat::mcset pb_msg_french "MC(g_code,tap,name)"                    "Cycle de taraudage"
::msgcat::mcset pb_msg_french "MC(g_code,bore,name)"                   "Cycle d'alésage"
::msgcat::mcset pb_msg_french "MC(g_code,bore_drag,name)"              "Cycle d'alésage en tirant"
::msgcat::mcset pb_msg_french "MC(g_code,bore_no_drag,name)"           "Cycle d'alésage sans tirer"
::msgcat::mcset pb_msg_french "MC(g_code,bore_dwell,name)"             "Cycle d'alésage avec tempo"
::msgcat::mcset pb_msg_french "MC(g_code,bore_manual,name)"            "Cycle d'alésage manuel"
::msgcat::mcset pb_msg_french "MC(g_code,bore_back,name)"              "Cycle d'alésage arrière"
::msgcat::mcset pb_msg_french "MC(g_code,bore_manual_dwell,name)"      "Cycle d'alésage manuel avec tempo"
::msgcat::mcset pb_msg_french "MC(g_code,abs,name)"                    "Mode absolu"
::msgcat::mcset pb_msg_french "MC(g_code,inc,name)"                    "Mode incrémental"
::msgcat::mcset pb_msg_french "MC(g_code,cycle_retract_auto,name)"     "Cycle de retrait (AUTO)"
::msgcat::mcset pb_msg_french "MC(g_code,cycle_retract_manual,name)"   "Cycle de retrait (MANUEL)"
::msgcat::mcset pb_msg_french "MC(g_code,reset,name)"                  "Réinitialiser"
::msgcat::mcset pb_msg_french "MC(g_code,fr_ipm,name)"                 "Mode d'avance IPM"
::msgcat::mcset pb_msg_french "MC(g_code,fr_ipr,name)"                 "Mode d'avance IPR"
::msgcat::mcset pb_msg_french "MC(g_code,fr_frn,name)"                 "Mode d'avance FRN"
::msgcat::mcset pb_msg_french "MC(g_code,spindle_css,name)"            "VCC de broche "
::msgcat::mcset pb_msg_french "MC(g_code,spindle_rpm,name)"            "RPM de broche"
::msgcat::mcset pb_msg_french "MC(g_code,ret_home,name)"               "Retour Home"
::msgcat::mcset pb_msg_french "MC(g_code,cons_thread,name)"            "Filetage constant"
::msgcat::mcset pb_msg_french "MC(g_code,incr_thread,name)"            "Filetage incrémental"
::msgcat::mcset pb_msg_french "MC(g_code,decr_thread,name)"            "Filetage incrémental inverse"
::msgcat::mcset pb_msg_french "MC(g_code,feedmode_in,pm)"              "Mode d'avance IPM"
::msgcat::mcset pb_msg_french "MC(g_code,feedmode_in,pr)"              "Mode d'avance IPR"
::msgcat::mcset pb_msg_french "MC(g_code,feedmode_mm,pm)"              "Mode d'avance MMPM"
::msgcat::mcset pb_msg_french "MC(g_code,feedmode_mm,pr)"              "Mode d'avance MMPR"
::msgcat::mcset pb_msg_french "MC(g_code,feedmode,dpm)"                "Mode d'avance DPM"

##------------
## M Code
##
::msgcat::mcset pb_msg_french "MC(m_code,stop_manual_tc,name)"         "Arrêt/Changement d'outil manuel"
::msgcat::mcset pb_msg_french "MC(m_code,stop,name)"                   "Arrêt"
::msgcat::mcset pb_msg_french "MC(m_code,opt_stop,name)"               "Opstop"
::msgcat::mcset pb_msg_french "MC(m_code,prog_end,name)"               "Fin de programme"
::msgcat::mcset pb_msg_french "MC(m_code,spindle_clw,name)"            "Broche ON/CLW"
::msgcat::mcset pb_msg_french "MC(m_code,spindle_cclw,name)"           "Broche CCLW"
::msgcat::mcset pb_msg_french "MC(m_code,lathe_thread,type1)"          "Filetage constant"
::msgcat::mcset pb_msg_french "MC(m_code,lathe_thread,type2)"          "Filetage incrémental"
::msgcat::mcset pb_msg_french "MC(m_code,lathe_thread,type3)"          "Filetage incrémental inverse"
::msgcat::mcset pb_msg_french "MC(m_code,spindle_off,name)"            "Broche Désactivée"
::msgcat::mcset pb_msg_french "MC(m_code,tc_retract,name)"             "Changement d'outil/Retrait"
::msgcat::mcset pb_msg_french "MC(m_code,coolant_on,name)"             "Arrosage ON"
::msgcat::mcset pb_msg_french "MC(m_code,coolant_fld,name)"            "Arrosage liquide"
::msgcat::mcset pb_msg_french "MC(m_code,coolant_mist,name)"           "Arrosage brouillard"
::msgcat::mcset pb_msg_french "MC(m_code,coolant_thru,name)"           "Arrosage à travers"
::msgcat::mcset pb_msg_french "MC(m_code,coolant_tap,name)"            "Arrosage pour taraudage"
::msgcat::mcset pb_msg_french "MC(m_code,coolant_off,name)"            "Arrosage arrêté"
::msgcat::mcset pb_msg_french "MC(m_code,rewind,name)"                 "Rembobiner"
::msgcat::mcset pb_msg_french "MC(m_code,thread_wire,name)"            "Enfiler le fil"
::msgcat::mcset pb_msg_french "MC(m_code,cut_wire,name)"               "Couper le fil"
::msgcat::mcset pb_msg_french "MC(m_code,fls_on,name)"                 "Rinçage On"
::msgcat::mcset pb_msg_french "MC(m_code,fls_off,name)"                "Rinçage Off"
::msgcat::mcset pb_msg_french "MC(m_code,power_on,name)"               "Alimentation ON"
::msgcat::mcset pb_msg_french "MC(m_code,power_off,name)"              "Alimentation OFF"
::msgcat::mcset pb_msg_french "MC(m_code,wire_on,name)"                "Fil ON"
::msgcat::mcset pb_msg_french "MC(m_code,wire_off,name)"               "Fil OFF"
::msgcat::mcset pb_msg_french "MC(m_code,pri_turret,name)"             "Tourelle principale"
::msgcat::mcset pb_msg_french "MC(m_code,sec_turret,name)"             "Tourelle secondaire"

##------------
## UDE
##
::msgcat::mcset pb_msg_french "MC(ude,editor,enable,Label)"            "Activer l'éditeur UDE"
::msgcat::mcset pb_msg_french "MC(ude,editor,enable,as_saved,Label)"   "Tel que sauvegardé"
::msgcat::mcset pb_msg_french "MC(ude,editor,TITLE)"                   "Evénement utilisateur"

::msgcat::mcset pb_msg_french "MC(ude,editor,no_ude)"                  "Pas d'UDE correspondant."

::msgcat::mcset pb_msg_french "MC(ude,editor,int,Label)"               "Entier"
::msgcat::mcset pb_msg_french "MC(ude,editor,int,Context)"             "Ajouter un nouveau paramètre entier en le glissant vers la liste de droite."

::msgcat::mcset pb_msg_french "MC(ude,editor,real,Label)"              "Réel"
::msgcat::mcset pb_msg_french "MC(ude,editor,real,Context)"            "Ajouter un nouveau paramètre réel en le glissant vers la liste de droite."

::msgcat::mcset pb_msg_french "MC(ude,editor,txt,Label)"               "Texte"
::msgcat::mcset pb_msg_french "MC(ude,editor,txt,Context)"             "Ajouter un nouveau paramètre chaîne en le glissant vers la liste de droite."

::msgcat::mcset pb_msg_french "MC(ude,editor,bln,Label)"               "Booléen"
::msgcat::mcset pb_msg_french "MC(ude,editor,bln,Context)"             "Ajouter un nouveau paramètre booléen en le glissant vers la liste de droite."

::msgcat::mcset pb_msg_french "MC(ude,editor,opt,Label)"               "Option"
::msgcat::mcset pb_msg_french "MC(ude,editor,opt,Context)"             "Ajouter un nouveau paramètre d'option en le glissant vers la liste de droite."

::msgcat::mcset pb_msg_french "MC(ude,editor,pnt,Label)"               "Point"
::msgcat::mcset pb_msg_french "MC(ude,editor,pnt,Context)"             "Ajouter un nouveau paramètre de point en le glissant vers la liste de droite."

::msgcat::mcset pb_msg_french "MC(ude,editor,trash,Label)"             "Editeur -- Corbeille"
::msgcat::mcset pb_msg_french "MC(ude,editor,trash,Context)"           "Vous pouvez éliminer les paramètres inutiles dans la liste de droite en les glissant vers la corbeille."

::msgcat::mcset pb_msg_french "MC(ude,editor,event,Label)"             "Evénement"
::msgcat::mcset pb_msg_french "MC(ude,editor,event,Context)"           "Vous pouvez éditer les paramètres de l'événement avec le bouton de gauche. "

::msgcat::mcset pb_msg_french "MC(ude,editor,param,Label)"             "Evénement -- Paramètres"
::msgcat::mcset pb_msg_french "MC(ude,editor,param,Context)"           "Vous pouvez éditer chaque paramètre par un clic droit ou modifier l'ordre des paramètres avec glisser-déposer.\n \nLe paramètre en bleu clair est défini par le système et ne peut pas être supprimé. \nLe paramètre marron n'est pas un paramètre système et peut être modifié ou détruit."

::msgcat::mcset pb_msg_french "MC(ude,editor,param,edit,Label)"        "Paramètres -- Option"
::msgcat::mcset pb_msg_french "MC(ude,editor,param,edit,Context)"      "Cliquez avec le bouton de gauche pour sélectionner l'option par défaut.\n Double-cliquez pour éditer l'option."
::msgcat::mcset pb_msg_french "MC(ude,editor,param,editor,Label)"      "Type de paramètre: "

::msgcat::mcset pb_msg_french "MC(ude,editor,pnt,sel,Label)"           "Sélection"
::msgcat::mcset pb_msg_french "MC(ude,editor,pnt,dsp,Label)"           "Affichage"

::msgcat::mcset pb_msg_french "MC(ude,editor,dlg,ok,Label)"            "OK"
::msgcat::mcset pb_msg_french "MC(ude,editor,dlg,bck,Label)"           "Arrière"
::msgcat::mcset pb_msg_french "MC(ude,editor,dlg,cnl,Label)"           "Annuler"

::msgcat::mcset pb_msg_french "MC(ude,editor,paramdlg,PL,Label)"       "Label de paramètre"
::msgcat::mcset pb_msg_french "MC(ude,editor,paramdlg,VN,Label)"       "Nom de variable"
::msgcat::mcset pb_msg_french "MC(ude,editor,paramdlg,DF,Label)"       "Valeur par défaut"
::msgcat::mcset pb_msg_french "MC(ude,editor,paramdlg,PL,Context)"     "Spécifier le label de paramètre"
::msgcat::mcset pb_msg_french "MC(ude,editor,paramdlg,VN,Context)"     "Spécifier le nom de variable"
::msgcat::mcset pb_msg_french "MC(ude,editor,paramdlg,DF,Context)"     "Spécifier la valeur par défaut"
::msgcat::mcset pb_msg_french "MC(ude,editor,paramdlg,TG)"             "Bascule"
::msgcat::mcset pb_msg_french "MC(ude,editor,paramdlg,TG,B,Label)"     "Bascule"
::msgcat::mcset pb_msg_french "MC(ude,editor,paramdlg,TG,B,Context)"   "Sélectionner la valeur de bascule"
::msgcat::mcset pb_msg_french "MC(ude,editor,paramdlg,ON,Label)"       "On"
::msgcat::mcset pb_msg_french "MC(ude,editor,paramdlg,OFF,Label)"      "Désactivé"
::msgcat::mcset pb_msg_french "MC(ude,editor,paramdlg,ON,Context)"     "Sélectionner la valeur par défaut ON"
::msgcat::mcset pb_msg_french "MC(ude,editor,paramdlg,OFF,Context)"    "Sélectionner la valeur par défaut OFF"
::msgcat::mcset pb_msg_french "MC(ude,editor,paramdlg,OL)"             "Liste d'option"
::msgcat::mcset pb_msg_french "MC(ude,editor,paramdlg,ADD,Label)"      "Ajouter"
::msgcat::mcset pb_msg_french "MC(ude,editor,paramdlg,CUT,Label)"      "Couper"
::msgcat::mcset pb_msg_french "MC(ude,editor,paramdlg,PASTE,Label)"    "Coller"
::msgcat::mcset pb_msg_french "MC(ude,editor,paramdlg,ADD,Context)"    "Ajouter un élément"
::msgcat::mcset pb_msg_french "MC(ude,editor,paramdlg,CUT,Context)"    "Couper un élément"
::msgcat::mcset pb_msg_french "MC(ude,editor,paramdlg,PASTE,Context)"  "Coller un élément"
::msgcat::mcset pb_msg_french "MC(ude,editor,paramdlg,ENTRY,Label)"    "Option"
::msgcat::mcset pb_msg_french "MC(ude,editor,paramdlg,ENTRY,Context)"  "Saisir un élément"
::msgcat::mcset pb_msg_french "MC(ude,editor,eventdlg,EN,Label)"       "Nom d'événement"
::msgcat::mcset pb_msg_french "MC(ude,editor,eventdlg,EN,Context)"     "Spécifier le nom de l'événement"
::msgcat::mcset pb_msg_french "MC(ude,editor,eventdlg,PEN,Label)"      "Nom du Post"
::msgcat::mcset pb_msg_french "MC(ude,editor,eventdlg,PEN,Context)"    "Spécifier le nom de Post"
::msgcat::mcset pb_msg_french "MC(ude,editor,eventdlg,PEN,C,Label)"    "Nom du Post"
::msgcat::mcset pb_msg_french "MC(ude,editor,eventdlg,PEN,C,Context)"  "Cette bascule permet de déterminer s'il faut définir le nom du Post"
::msgcat::mcset pb_msg_french "MC(ude,editor,eventdlg,EL,Label)"       "Label de l'événement"
::msgcat::mcset pb_msg_french "MC(ude,editor,eventdlg,EL,Context)"     "Spécifier le label de l'événement"
::msgcat::mcset pb_msg_french "MC(ude,editor,eventdlg,EL,C,Label)"     "Label de l'événement"
::msgcat::mcset pb_msg_french "MC(ude,editor,eventdlg,EL,C,Context)"   "Cette bascule permet de déterminer s'il faut définir le nom du label"

::msgcat::mcset pb_msg_french "MC(ude,editor,eventdlg,EC,Label)"           "Catégorie"
::msgcat::mcset pb_msg_french "MC(ude,editor,eventdlg,EC,Context)"         "Cette bascule permet de déterminer s'il faut définir la catégorie"
::msgcat::mcset pb_msg_french "MC(ude,editor,eventdlg,EC_MILL,Label)"      "Fraiseuse"
::msgcat::mcset pb_msg_french "MC(ude,editor,eventdlg,EC_DRILL,Label)"     "Perçage"
::msgcat::mcset pb_msg_french "MC(ude,editor,eventdlg,EC_LATHE,Label)"     "Tour"
::msgcat::mcset pb_msg_french "MC(ude,editor,eventdlg,EC_WEDM,Label)"      "Wedm"
::msgcat::mcset pb_msg_french "MC(ude,editor,eventdlg,EC_MILL,Context)"    "Définir la catégorie de fraiseuse"
::msgcat::mcset pb_msg_french "MC(ude,editor,eventdlg,EC_DRILL,Context)"   "Définir la catégorie de perceuse"
::msgcat::mcset pb_msg_french "MC(ude,editor,eventdlg,EC_LATHE,Context)"   "Définir la catégorie de tour"
::msgcat::mcset pb_msg_french "MC(ude,editor,eventdlg,EC_WEDM,Context)"    "Définir la catégorie d'électro-érosion"

::msgcat::mcset pb_msg_french "MC(ude,editor,EDIT)"                    "Editer l'événement"
::msgcat::mcset pb_msg_french "MC(ude,editor,CREATE)"                  "Créer l'événement de contrôle de machine"
::msgcat::mcset pb_msg_french "MC(ude,editor,popup,HELP)"              "Aide"
::msgcat::mcset pb_msg_french "MC(ude,editor,popup,EDIT)"              "Editer les paramètres définis par l'utilisateur..."
::msgcat::mcset pb_msg_french "MC(ude,editor,param,EDIT)"              "Editer..."
::msgcat::mcset pb_msg_french "MC(ude,editor,param,VIEW)"              "Affichage..."
::msgcat::mcset pb_msg_french "MC(ude,editor,popup,DELETE)"            "Détruire"
::msgcat::mcset pb_msg_french "MC(ude,editor,popup,CREATE)"            "Créer un nouvel événement de contrôle de machine..."
::msgcat::mcset pb_msg_french "MC(ude,editor,popup,IMPORT)"            "Importer des événements de contrôle de machine..."
::msgcat::mcset pb_msg_french "MC(ude,editor,popup,MSG_BLANK)"         "Le nom de l'événement ne doit pas être vide."
::msgcat::mcset pb_msg_french "MC(ude,editor,popup,MSG_SAMENAME)"      "Le nom de l'événement existe."
::msgcat::mcset pb_msg_french "MC(ude,editor,popup,MSG_SameHandler)"   "La fonction d'événement existe. \nModifiez le nom d'événement ou de Post s'il est coché."
::msgcat::mcset pb_msg_french "MC(ude,validate)"                       "Il n'y a pas de paramètre dans cet événement."
::msgcat::mcset pb_msg_french "MC(ude,prev,tab,Label)"                 "Evénements utilisateur"
::msgcat::mcset pb_msg_french "MC(ude,prev,ude,Label)"                 "Evénement de contrôle de machine"
::msgcat::mcset pb_msg_french "MC(ude,prev,udc,Label)"                 "Cycles définis par utilisateur"
::msgcat::mcset pb_msg_french "MC(ude,prev,mc,Label)"                  "Evénements de contrôle de machine du système"
::msgcat::mcset pb_msg_french "MC(ude,prev,nmc,Label)"                 "Evénements de contrôle de machine hors système"
::msgcat::mcset pb_msg_french "MC(udc,prev,sys,Label)"                 "Cycles système"
::msgcat::mcset pb_msg_french "MC(udc,prev,nsys,Label)"                "Cycles non système"
::msgcat::mcset pb_msg_french "MC(ude,prev,Status)"                    "Choisir l'élément à définir"
::msgcat::mcset pb_msg_french "MC(ude,editor,opt,MSG_BLANK)"           "La chaîne d'option ne doit pas être vide."
::msgcat::mcset pb_msg_french "MC(ude,editor,opt,MSG_SAME)"            "La chaîne d'option existe."
::msgcat::mcset pb_msg_french "MC(ude,editor,opt,MSG_PST_SAME)"        "L'option que vous collez existe."
::msgcat::mcset pb_msg_french "MC(ude,editor,opt,MSG_IDENTICAL)"       "Certaines options sont identiques."
::msgcat::mcset pb_msg_french "MC(ude,editor,opt,NO_OPT)"              "Il n'y a pas d'option dans la liste."
::msgcat::mcset pb_msg_french "MC(ude,editor,param,MSG_NO_VNAME)"      "Le nom de la variable ne doit pas être vide."
::msgcat::mcset pb_msg_french "MC(ude,editor,param,MSG_EXIST_VNAME)"   "Le nom de la variable existe."
::msgcat::mcset pb_msg_french "MC(ude,editor,spindle_css,INFO)"        "Cet événement partage les UDE avec \"RPM de broche\""
::msgcat::mcset pb_msg_french "MC(ude,import,ihr,Label)"               "Reprendre les UDE d'un Post"

::msgcat::mcset pb_msg_french "MC(ude,import,ihr,Context)"             "Cette option permet au Post de reprendre la définition des UDE et de leurs fonctions depuis un Post."

::msgcat::mcset pb_msg_french "MC(ude,import,sel,Label)"               "Sélect. Post"

::msgcat::mcset pb_msg_french "MC(ude,import,sel,Context)"             "Sélectionner le fichier PUI du Post souhaité. Il est recommandé de placer dans le même répertoire tous les fichiers (PUI, Def, TCL et CDL) associés à ce Post pour les utiliser lors de l'exécution."

::msgcat::mcset pb_msg_french "MC(ude,import,name_cdl,Label)"          "Nom du fichier CDL"

::msgcat::mcset pb_msg_french "MC(ude,import,name_cdl,Context)"        "Chemin et nom du fichier CDL associé au Post sélectionné qui sera référencé (INCLUDE) dans le fichier de définition de ce Post. Le nom de chemin doit commencer par une variable d'environnement UG (\\\$UGII) ou rien.  Si aucun chemin n'est spécifié, UGII_CAM_FILE_SEARCH_PATH sera utilisé pour que UG/NX trouve le fichier lors de l'exécution."

::msgcat::mcset pb_msg_french "MC(ude,import,name_def,Label)"          "Nom du fichier Def"
::msgcat::mcset pb_msg_french "MC(ude,import,name_def,Context)"        "Chemin et nom du fichier de définition du Post sélectionné qui sera référencé (INCLUDE) dans le fichier de définition de ce Post. Le nom de chemin doit commencer par une variable d'environnement UG (\\\$UGII) ou rien.  Si aucun chemin n'est spécifié, UGII_CAM_FILE_SEARCH_PATH sera utilisé pour que UG/NX trouve le fichier lors de l'exécution."

::msgcat::mcset pb_msg_french "MC(ude,import,include_cdl,Label)"       "CDL"
::msgcat::mcset pb_msg_french "MC(ude,import,ihr_pst,Label)"           "Post"
::msgcat::mcset pb_msg_french "MC(ude,import,ihr_folder,Label)"        "Dossier"
::msgcat::mcset pb_msg_french "MC(ude,import,own_folder,Label)"        "Dossier"
::msgcat::mcset pb_msg_french "MC(ude,import,own,Label)"               "Inclure son propre fichier CDL"

::msgcat::mcset pb_msg_french "MC(ude,import,own,Context)"             "Cette option permet au Post d'inclure la référence à son propre fichier CDL dans son fichier de définition."

::msgcat::mcset pb_msg_french "MC(ude,import,own_ent,Label)"           "Propre fichier CDL"

::msgcat::mcset pb_msg_french "MC(ude,import,own_ent,Context)"         "Chemin et nom du fichier CDL associé à ce Post qui sera référencé (INCLUDE) dans le fichier de définition de ce Post. Le nom du fichier sera déterminé à la sauvegarde de ce Post. Le nom du chemin doit commencer par une variable d'environnement UG (\\\$UGII) ou rien.  Si aucun chemin n'est spécifié, UGII_CAM_FILE_SEARCH_PATH sera utilisé pour que UG/NX trouve le fichier lors de l'exécution."

::msgcat::mcset pb_msg_french "MC(ude,import,sel,pui,status)"          "Sélectionner un fichier PUI"
::msgcat::mcset pb_msg_french "MC(ude,import,sel,cdl,status)"          "Sélectionner un fichier CDL"

##---------
## UDC
##
::msgcat::mcset pb_msg_french "MC(udc,editor,TITLE)"                   "Cycle défini par l'utilisateur"
::msgcat::mcset pb_msg_french "MC(udc,editor,CREATE)"                  "Créer un cycle défini par l'utilisateur"
::msgcat::mcset pb_msg_french "MC(udc,editor,TYPE)"                    "Type de cycle"
::msgcat::mcset pb_msg_french "MC(udc,editor,type,UDC)"                "Défini par utilisateur"
::msgcat::mcset pb_msg_french "MC(udc,editor,type,SYSUDC)"             "Défini par le système"
::msgcat::mcset pb_msg_french "MC(udc,editor,CYCLBL,Label)"            "Label du cycle"
::msgcat::mcset pb_msg_french "MC(udc,editor,CYCNAME,Label)"           "Nom du cycle"
::msgcat::mcset pb_msg_french "MC(udc,editor,CYCLBL,Context)"          "Spécifier le label du cycle"
::msgcat::mcset pb_msg_french "MC(udc,editor,CYCNAME,Context)"         "Spécifier le nom du cycle"
::msgcat::mcset pb_msg_french "MC(udc,editor,CYCLBL,C,Label)"          "Label du cycle"
::msgcat::mcset pb_msg_french "MC(udc,editor,CYCLBL,C,Context)"        "Cette bascule permet de définir le label du cycle"
::msgcat::mcset pb_msg_french "MC(udc,editor,popup,EDIT)"              "Editer les paramètres définis par l'utilisateur..."
::msgcat::mcset pb_msg_french "MC(udc,editor,popup,MSG_BLANK)"         "Le nom du cycle ne doit pas être vide."
::msgcat::mcset pb_msg_french "MC(udc,editor,popup,MSG_SAMENAME)"      "Le nom du cycle existe."
::msgcat::mcset pb_msg_french "MC(udc,editor,popup,MSG_SameHandler)"   "La fonction d'événement existe.\n Modifiez le nom d'événement du cycle."
::msgcat::mcset pb_msg_french "MC(udc,editor,popup,MSG_ISSYSCYC)"      "Le nom du cycle appartient au type de cycle système."
::msgcat::mcset pb_msg_french "MC(udc,editor,popup,MSG_SYSCYC_EXIST)"  "Ce type de cycle système existe."
::msgcat::mcset pb_msg_french "MC(udc,editor,EDIT)"                    "Editer l'événement du cycle"
::msgcat::mcset pb_msg_french "MC(udc,editor,popup,CREATE)"            "Créer un nouveau cycle défini par l'utilisateur..."
::msgcat::mcset pb_msg_french "MC(udc,editor,popup,IMPORT)"            "Importer des cycles définis par l'utilisateur..."
::msgcat::mcset pb_msg_french "MC(udc,drill,csink,INFO)"               "Cet événement partage la fonction avec Perçage."
::msgcat::mcset pb_msg_french "MC(udc,drill,simulate,INFO)"            "Cet événement est un type de cycle simulé."
::msgcat::mcset pb_msg_french "MC(udc,drill,dwell,INFO)"               "Cet événement partage le cycle défini par l'utilisateur avec "


#######
# IS&V
#######
::msgcat::mcset pb_msg_french "MC(isv,tab,label)"                      "Contrôle numérique virtuel"
::msgcat::mcset pb_msg_french "MC(isv,Status)"                         "Spécifier les paramètres pour ISV"
::msgcat::mcset pb_msg_french "MC(isv,review,Status)"                  "Vérifier les commandes VNC"

::msgcat::mcset pb_msg_french "MC(isv,setup,Label)"                    "Configuration"
::msgcat::mcset pb_msg_french "MC(isv,vnc_command,Label)"              "Commandes VNC"
####################
# General Definition
####################
::msgcat::mcset pb_msg_french "MC(isv,select_Main)"                    "Sélectionner le fichier VNC master pour un VNC subordonné."
::msgcat::mcset pb_msg_french "MC(isv,setup,machine,Label)"            "Machine-outil"
::msgcat::mcset pb_msg_french "MC(isv,setup,component,Label)"          "Montage outil"
::msgcat::mcset pb_msg_french "MC(isv,setup,mac_zcs_frame,Label)"      "Référence du zéro programme"
::msgcat::mcset pb_msg_french "MC(isv,setup,mac_zcs,Label)"            "Composant"
::msgcat::mcset pb_msg_french "MC(isv,setup,mac_zcs,Context)"          "Spécifier un composant comme base de référence ZCS. Ce doit être un composant non rotatif auquel est connectée directement ou indirectement la pièce dans l'arborescence cinématique."
::msgcat::mcset pb_msg_french "MC(isv,setup,spin_com,Label)"           "Composant"
::msgcat::mcset pb_msg_french "MC(isv,setup,spin_com,Context)"         "Spécifier un composant sur lequel seront montés les outils. Il doit s'agir d'un composant de broche pour un Post de fraiseuse, et d'un composant de tourelle pour un Post de tour."

::msgcat::mcset pb_msg_french "MC(isv,setup,spin_jct,Label)"           "Articulation"
::msgcat::mcset pb_msg_french "MC(isv,setup,spin_jct,Context)"         "Définir une articulation pour le montage des outils. Il s'agit de l'Articulation au centre de la face de broche pour un Post de fraiseuse. Il s'agit de l'Articulation rotative de la tourelle pour un Post de tour. Si la tourelle est fixe, il s'agit de l'Articulation de montage d'outil."

::msgcat::mcset pb_msg_french "MC(isv,setup,axis_name,Label)"          "Axe spécifié sur Machine-outil"
::msgcat::mcset pb_msg_french "MC(isv,setup,axis_name,Context)"        "Spécifier le nom des axes qui correspondent à la configuration cinématique de votre machine-outil"




::msgcat::mcset pb_msg_french "MC(isv,setup,axis_frm,Label)"           "Noms des axes CN "
::msgcat::mcset pb_msg_french "MC(isv,setup,rev_fourth,Label)"         "Inverser la rotation"
::msgcat::mcset pb_msg_french "MC(isv,setup,rev_fourth,Context)"       "Spécifier la direction de rotation de l'axe. Peut être inverse ou normal. Applicable uniquement à une table de rotation."
::msgcat::mcset pb_msg_french "MC(isv,setup,rev_fifth,Label)"          "Inverser la rotation"

::msgcat::mcset pb_msg_french "MC(isv,setup,fourth_limit,Label)"       "Limites de rotation"
::msgcat::mcset pb_msg_french "MC(isv,setup,fourth_limit,Context)"     "Spécifier si l'axe rotatif a des limites"
::msgcat::mcset pb_msg_french "MC(isv,setup,fifth_limit,Label)"        "Limites de rotation"
::msgcat::mcset pb_msg_french "MC(isv,setup,limiton,Label)"            "Oui"
::msgcat::mcset pb_msg_french "MC(isv,setup,limitoff,Label)"           "Non"
::msgcat::mcset pb_msg_french "MC(isv,setup,fourth_table,Label)"       "4ème axe"
::msgcat::mcset pb_msg_french "MC(isv,setup,fifth_table,Label)"        "5ème axe"
::msgcat::mcset pb_msg_french "MC(isv,setup,header,Label)"             " Table "
::msgcat::mcset pb_msg_french "MC(isv,setup,intialization,Label)"      "Contrôle numérique"
::msgcat::mcset pb_msg_french "MC(isv,setup,general_def,Label)"        "Paramètre initial"
::msgcat::mcset pb_msg_french "MC(isv,setup,advanced_def,Label)"       "Autres Options"
::msgcat::mcset pb_msg_french "MC(isv,setup,InputOutput,Label)"        "Codes CN spéciaux"

::msgcat::mcset pb_msg_french "MC(isv,setup,program,Label)"            "Définition de programme par défaut"
::msgcat::mcset pb_msg_french "MC(isv,setup,output,Label)"             "Exporter la définition de programme"
::msgcat::mcset pb_msg_french "MC(isv,setup,output,Context)"           "Enregistrer la définition de programme vers un fichier"
::msgcat::mcset pb_msg_french "MC(isv,setup,input,Label)"              "Importer la définition de programme"
::msgcat::mcset pb_msg_french "MC(isv,setup,input,Context)"            "Extraire la définition de programme dans un fichier"
::msgcat::mcset pb_msg_french "MC(isv,setup,file_err,Msg)"             "Le fichier sélectionné ne correspond pas au type de fichier de définition de programme par défaut, continuer?"
::msgcat::mcset pb_msg_french "MC(isv,setup,wcs,Label)"                "Décalages d'origine"
::msgcat::mcset pb_msg_french "MC(isv,setup,tool,Label)"               "Données d'outil"
::msgcat::mcset pb_msg_french "MC(isv,setup,g_code,Label)"             "Code G spécial"
::msgcat::mcset pb_msg_french "MC(isv,setup,special_vnc,Label)"        "Code CN spécial"

::msgcat::mcset pb_msg_french "MC(isv,setup,initial,frame,Label)"      ""
::msgcat::mcset pb_msg_french "MC(isv,setup,initial_motion,Label)"     "Mouvement"
::msgcat::mcset pb_msg_french "MC(isv,setup,initial_motion,Context)"   "Spécifier le mouvement initial de la machine-outil"

::msgcat::mcset pb_msg_french "MC(isv,setup,spindle,frame,Label)"      "Broche"
::msgcat::mcset pb_msg_french "MC(isv,setup,spindle_mode,Label)"       "Mode"
::msgcat::mcset pb_msg_french "MC(isv,setup,spindle_direction,Label)"  "Direction"
::msgcat::mcset pb_msg_french "MC(isv,setup,spindle,frame,Context)"    "Spécifier l'unité de vitesse de broche initiale et la direction de rotation"

::msgcat::mcset pb_msg_french "MC(isv,setup,feedrate_mode,Label)"      "Mode d'avance"
::msgcat::mcset pb_msg_french "MC(isv,setup,feedrate_mode,Context)"    "Spécifier l'unité d'avance initiale"

::msgcat::mcset pb_msg_french "MC(isv,setup,boolean,frame,Label)"      "Définition élément Booléen"
::msgcat::mcset pb_msg_french "MC(isv,setup,power_on_wcs,Label)"       "Power On WCS  "
::msgcat::mcset pb_msg_french "MC(isv,setup,power_on_wcs,Context)"     "0 indique que les coordonnées du zéro machine par défaut seront utilisées\n 1 indique que le premier décalage d'origine défini par l'utilisateur (coordonnées de travail) sera utilisé"

::msgcat::mcset pb_msg_french "MC(isv,setup,use_s_leader,Label)"       "S Utilisé"
::msgcat::mcset pb_msg_french "MC(isv,setup,use_f_leader,Label)"       "F Utilisé"


::msgcat::mcset pb_msg_french "MC(isv,setup,dog_leg,Label)"            "Coude Rapide"
::msgcat::mcset pb_msg_french "MC(isv,setup,dog_leg,Context)"          "ON franchit les mouvements rapides avec parcours coudé; OFF franchit les mouvements rapides en fonction du code CN (Point à point)."

::msgcat::mcset pb_msg_french "MC(isv,setup,dog_leg,yes)"              "Oui"
::msgcat::mcset pb_msg_french "MC(isv,setup,dog_leg,no)"               "Non"

::msgcat::mcset pb_msg_french "MC(isv,setup,on_off_frame,Label)"       "Définir On/Off"
::msgcat::mcset pb_msg_french "MC(isv,setup,stroke_limit,Label)"       "Stroke Limit"
::msgcat::mcset pb_msg_french "MC(isv,setup,cutcom,Label)"             "Corr. Outil"
::msgcat::mcset pb_msg_french "MC(isv,setup,tl_adjust,Label)"          "Compensation de longueur d'outil"
::msgcat::mcset pb_msg_french "MC(isv,setup,scale,Label)"              "Echelle"
::msgcat::mcset pb_msg_french "MC(isv,setup,macro_modal,Label)"        "Macro modal"
::msgcat::mcset pb_msg_french "MC(isv,setup,wcs_rotate,Label)"         "Rotation WCS"
::msgcat::mcset pb_msg_french "MC(isv,setup,cycle,Label)"              "Cycle"

::msgcat::mcset pb_msg_french "MC(isv,setup,initial_mode,frame,Label)"     "Mode de saisie"
::msgcat::mcset pb_msg_french "MC(isv,setup,initial_mode,frame,Context)"   "Spécifier le mode de saisie initial comme absolu ou incrémental"

###################
# Input/Out Related
###################
::msgcat::mcset pb_msg_french "MC(isv,sign_define,frame,Label)"        ""
::msgcat::mcset pb_msg_french "MC(isv,sign_define,rewindstop,Label)"   "Code d'arrêt avec rembobinage"
::msgcat::mcset pb_msg_french "MC(isv,sign_define,rewindstop,Context)" "Spécifier le code d'arrêt avec rembobinage"

::msgcat::mcset pb_msg_french "MC(isv,control_var,frame,Label)"        "Variables de contrôle"

::msgcat::mcset pb_msg_french "MC(isv,sign_define,convarleader,Label)"     "Amorce"
::msgcat::mcset pb_msg_french "MC(isv,sign_define,convarleader,Context)"   "Spécifier la variable de contrôle numérique"
::msgcat::mcset pb_msg_french "MC(isv,sign_define,conequ,Label)"           "Signe égal"
::msgcat::mcset pb_msg_french "MC(isv,sign_define,conequ,Context)"         "Spécifier le signe égal du contrôle numérique"
::msgcat::mcset pb_msg_french "MC(isv,sign_define,percent,Label)"          "Signe pourcent %"
::msgcat::mcset pb_msg_french "MC(isv,sign_define,leaderjing,Label)"       "#"
::msgcat::mcset pb_msg_french "MC(isv,sign_define,text_string,Label)"      "Chaîne de texte"

::msgcat::mcset pb_msg_french "MC(isv,inputmode,frame,Label)"          ""
::msgcat::mcset pb_msg_french "MC(isv,input_mode,Label)"               "Mode initial"
::msgcat::mcset pb_msg_french "MC(isv,absolute_mode,Label)"            "Absolu"
::msgcat::mcset pb_msg_french "MC(isv,incremental_style,frame,Label)"  "Mode incrémental"

::msgcat::mcset pb_msg_french "MC(isv,incremental_mode,Label)"         "Incrémental"
::msgcat::mcset pb_msg_french "MC(isv,incremental_gcode,Label)"        "Code G"
::msgcat::mcset pb_msg_french "MC(isv,incremental_gcode,Context)"      "Utilise G90 ou G91 pour distinguer les modes Absolu et Incrémental"
::msgcat::mcset pb_msg_french "MC(isv,incremental_uvw,Label)"          "Amorce spéciale"
::msgcat::mcset pb_msg_french "MC(isv,incremental_uvw,Context)"        "Utilise une amorce spéciale pour distinguer entre Absolu et Incrémental. Ex: Amorce X Y Z indique un mode Absolu, Amorce U V W indique un mode Incrémental."
::msgcat::mcset pb_msg_french "MC(isv,incr_x,Label)"                   "X "
::msgcat::mcset pb_msg_french "MC(isv,incr_y,Label)"                   "Y "
::msgcat::mcset pb_msg_french "MC(isv,incr_z,Label)"                   "Z "
::msgcat::mcset pb_msg_french "MC(isv,incr_a,Label)"                   "Quatrième axe "
::msgcat::mcset pb_msg_french "MC(isv,incr_b,Label)"                   "Cinquième axe "

::msgcat::mcset pb_msg_french "MC(isv,incr_x,Context)"                 "Spécifier l'amorce spécial de l'axe X utilisée dans le mode incrémental"
::msgcat::mcset pb_msg_french "MC(isv,incr_y,Context)"                 "Spécifier l'amorce spécial de l'axe Y utilisée dans le mode incrémental"
::msgcat::mcset pb_msg_french "MC(isv,incr_z,Context)"                 "Spécifier l'amorce spécial de l'axe Z utilisée dans le mode incrémental"
::msgcat::mcset pb_msg_french "MC(isv,incr_a,Context)"                 "Spécifier l'amorce spécial du quatrième axe utilisée dans le mode incrémental"
::msgcat::mcset pb_msg_french "MC(isv,incr_b,Context)"                 "Spécifier l'amorce spécial du cinquième axe utilisée dans le mode incrémental"
::msgcat::mcset pb_msg_french "MC(isv,vnc_mes,frame,Label)"            "Ecrire le message VNC"

::msgcat::mcset pb_msg_french "MC(isv,vnc_message,Label)"              "Lister le message VNC"
::msgcat::mcset pb_msg_french "MC(isv,vnc_message,Context)"            "Si cette option est cochée, tous les messages de débogage VNC seront affichés dans la fenêtre des message de l'opération pendant la Simulation."

::msgcat::mcset pb_msg_french "MC(isv,vnc_mes,prefix,Label)"           "Préfixe du message"
::msgcat::mcset pb_msg_french "MC(isv,spec_desc,Label)"                "Description"
::msgcat::mcset pb_msg_french "MC(isv,spec_codelist,Label)"            "Liste de codes"
::msgcat::mcset pb_msg_french "MC(isv,spec_nccode,Label)"              "Code CN / Chaîne"

################
# WCS Definition
################
::msgcat::mcset pb_msg_french "MC(isv,machine_zero,offset,Label)"      "Décalages du zéro machine depuis\nl'articulation zéro machine"
::msgcat::mcset pb_msg_french "MC(isv,wcs_offset,frame,Label)"         "Décalages d'origine"
::msgcat::mcset pb_msg_french "MC(isv,wcs_leader,Label)"               " Code "
::msgcat::mcset pb_msg_french "MC(isv,wcs_number,Label)"               "    "
::msgcat::mcset pb_msg_french "MC(isv,wcs_offset,origin_x,Label)"      " Décalage en X  "
::msgcat::mcset pb_msg_french "MC(isv,wcs_offset,origin_y,Label)"      " Décalage en Y  "
::msgcat::mcset pb_msg_french "MC(isv,wcs_offset,origin_z,Label)"      " Décalage en Z  "
::msgcat::mcset pb_msg_french "MC(isv,wcs_offset,a_offset,Label)"      " Décalage en A  "
::msgcat::mcset pb_msg_french "MC(isv,wcs_offset,b_offset,Label)"      " Décalage en B  "
::msgcat::mcset pb_msg_french "MC(isv,wcs_offset,c_offset,Label)"      " Décalage en C  "
::msgcat::mcset pb_msg_french "MC(isv,wcs_offset,wcs_num,Label)"       "Système de coordonnées"
::msgcat::mcset pb_msg_french "MC(isv,wcs_offset,wcs_num,Context)"     "Spécifier le numéro de décalage d'origine à ajouter"
::msgcat::mcset pb_msg_french "MC(isv,wcs_offset,wcs_add,Label)"       "Ajouter"
::msgcat::mcset pb_msg_french "MC(isv,wcs_offset,wcs_add,Context)"     "Ajouter un système de coordonnées de décalage d'origine, spécifier sa position"
::msgcat::mcset pb_msg_french "MC(isv,wcs_offset,wcs_err,Msg)"         "Ce numéro de système de coordonnées a déjà existé."
::msgcat::mcset pb_msg_french "MC(isv,tool_info,frame,Label)"          "Infos outil"
::msgcat::mcset pb_msg_french "MC(isv,tool_info,tool_entry,Label)"     "Entrez un nouveau nom d'outil"
::msgcat::mcset pb_msg_french "MC(isv,tool_info,tool_name,Label)"      "       Nom       "

::msgcat::mcset pb_msg_french "MC(isv,tool_info,tool_num,Label)"       " Outil "
::msgcat::mcset pb_msg_french "MC(isv,tool_info,add_tool,Label)"       "Ajouter"
::msgcat::mcset pb_msg_french "MC(isv,tool_info,tool_diameter,Label)"  " Diamètre "
::msgcat::mcset pb_msg_french "MC(isv,tool_info,offset_usder,Label)"   "   Décalages de pointe   "
::msgcat::mcset pb_msg_french "MC(isv,tool_info,carrier_id,Label)"     " ID du porte-outil "
::msgcat::mcset pb_msg_french "MC(isv,tool_info,pocket_id,Label)"      " ID de poche "
::msgcat::mcset pb_msg_french "MC(isv,tool_info,cutcom_reg,Label)"     "     Corr. Outil     "
::msgcat::mcset pb_msg_french "MC(isv,tool_info,cutreg,Label)"         "Registre "
::msgcat::mcset pb_msg_french "MC(isv,tool_info,cutval,Label)"         "Décalage "
::msgcat::mcset pb_msg_french "MC(isv,tool_info,adjust_reg,Label)"     " Correcteur de longueur "
::msgcat::mcset pb_msg_french "MC(isv,tool_info,tool_type,Label)"      "   Type   "
::msgcat::mcset pb_msg_french "MC(isv,prog,setup,Label)"               "Définition de programme par défaut"
::msgcat::mcset pb_msg_french "MC(isv,prog,setup_right,Label)"         "Définition de programme"
::msgcat::mcset pb_msg_french "MC(isv,output,setup_data,Label)"        "Spécifier le fichier de définition de programme"
::msgcat::mcset pb_msg_french "MC(isv,input,setup_data,Label)"         "Sélectionner le fichier de définition de programme"

::msgcat::mcset pb_msg_french "MC(isv,tool_info,toolnum,Label)"        "Numéro d'outil  "
::msgcat::mcset pb_msg_french "MC(isv,tool_info,toolnum,Context)"      "Spécifier le numéro d'outil à ajouter"
::msgcat::mcset pb_msg_french "MC(isv,tool_info,add_tool,Context)"     "Ajouter un nouvel outil, spécifier ses paramètres"
::msgcat::mcset pb_msg_french "MC(isv,tool_info,add_err,Msg)"          "Ce numéro d'outil a déjà existé."
::msgcat::mcset pb_msg_french "MC(isv,tool_info,name_err,Msg)"         "Le nom d'outil ne peut pas être vide."

###########################
# Special G code Definition
###########################

::msgcat::mcset pb_msg_french "MC(isv,g_code,frame,Label)"             "Code G spécial"
::msgcat::mcset pb_msg_french "MC(isv,g_code,frame,Context)"           "Spécifier les codes G spéciaux utilisés dans la Simulation"
::msgcat::mcset pb_msg_french "MC(isv,g_code,from_home,Label)"         "Depuis Home"
::msgcat::mcset pb_msg_french "MC(isv,g_code,return_home,Label)"       "Retour Home"
::msgcat::mcset pb_msg_french "MC(isv,g_code,mach_wcs,Label)"          "Déplacement référentiel machine"
::msgcat::mcset pb_msg_french "MC(isv,g_code,set_local,Label)"         "Définir coordonnées locales"

###########################
# Special NC Custom Command
###########################

::msgcat::mcset pb_msg_french "MC(isv,spec_command,frame,Label)"       "Commandes CN spéciales"
::msgcat::mcset pb_msg_french "MC(isv,spec_command,frame,Context)"     "Commandes CN spécifiées pour appareils spéciaux"


::msgcat::mcset pb_msg_french "MC(isv,spec_pre,frame,Label)"           "Prétraiter les commandes"
::msgcat::mcset pb_msg_french "MC(isv,spec_pre,frame,Context)"         "La liste contient tous les jetons ou symboles qui doivent être traités avant de soumettre un bloc à l'analyse des coordonnées"

::msgcat::mcset pb_msg_french "MC(isv,spec_command,add,Label)"         "Ajouter"
::msgcat::mcset pb_msg_french "MC(isv,spec_command,edit,Label)"        "Editer"
::msgcat::mcset pb_msg_french "MC(isv,spec_command,delete,Label)"      "Détruire"
::msgcat::mcset pb_msg_french "MC(isv,spec_command,title,Label)"       "Commande spéciale pour autres appareils"
::msgcat::mcset pb_msg_french "MC(isv,spec_command,add_sim,Label)"     "Ajouter commande SIM @Curseur"
::msgcat::mcset pb_msg_french "MC(isv,spec_command,init_sim,Label)"    "Sélectionnez une commande"

::msgcat::mcset pb_msg_french "MC(isv,spec_command,preleader,Label)"   "Amorce"
::msgcat::mcset pb_msg_french "MC(isv,spec_command,preleader,Context)" "Spécifier l'amorce pour la commande prétraitée définie par l'utilisateur."

::msgcat::mcset pb_msg_french "MC(isv,spec_command,precode,Label)"     "Code"
::msgcat::mcset pb_msg_french "MC(isv,spec_command,precode,Context)"   "Spécifier l'amorce pour la commande prétraitée définie par l'utilisateur."

::msgcat::mcset pb_msg_french "MC(isv,spec_command,leader,Label)"      "Amorce"
::msgcat::mcset pb_msg_french "MC(isv,spec_command,leader,Context)"    "Spécifier l'amorce pour la commande définie par l'utilisateur."

::msgcat::mcset pb_msg_french "MC(isv,spec_command,code,Label)"        "Code"
::msgcat::mcset pb_msg_french "MC(isv,spec_command,code,Context)"      "Spécifier l'amorce pour la commande définie par l'utilisateur."

::msgcat::mcset pb_msg_french "MC(isv,spec_command,add,Context)"       "Ajouter une nouvelle commande définie par l'utilisateur"
::msgcat::mcset pb_msg_french "MC(isv,spec_command,add_err,Msg)"       "Ce jeton a déjà été traité."
::msgcat::mcset pb_msg_french "MC(isv,spec_command,sel_err,Msg)"       "Choisir une commande"
::msgcat::mcset pb_msg_french "MC(isv,export,error,title)"             "Avertissement"

::msgcat::mcset pb_msg_french "MC(isv,tool_table,title,Label)"         "Table d'outil"
::msgcat::mcset pb_msg_french "MC(isv,ex_editor,warning,Msg)"          "Il s'agit d'une commande VNC générée par le système. Les modifications ne seront pas sauvegardées."


# - Languages
#
::msgcat::mcset pb_msg_french "MC(language,Label)"                     "Langue"
::msgcat::mcset pb_msg_french "MC(pb_msg_english)"                     "Anglais"
::msgcat::mcset pb_msg_french "MC(pb_msg_french)"                      "Français"
::msgcat::mcset pb_msg_french "MC(pb_msg_german)"                      "Allemand"
::msgcat::mcset pb_msg_french "MC(pb_msg_italian)"                     "Italien"
::msgcat::mcset pb_msg_french "MC(pb_msg_japanese)"                    "Japonais"
::msgcat::mcset pb_msg_french "MC(pb_msg_korean)"                      "Coréen"
::msgcat::mcset pb_msg_french "MC(pb_msg_russian)"                     "Russe"
::msgcat::mcset pb_msg_french "MC(pb_msg_simple_chinese)"              "Chinois simplifié"
::msgcat::mcset pb_msg_french "MC(pb_msg_spanish)"                     "Espagnol"
::msgcat::mcset pb_msg_french "MC(pb_msg_traditional_chinese)"         "Chinois traditionnel"

### Exit Options Dialog
::msgcat::mcset pb_msg_french "MC(exit,options,Label)"                 "Options de sortie"
::msgcat::mcset pb_msg_french "MC(exit,options,SaveAll,Label)"         "Quitter en sauvegardant tout"
::msgcat::mcset pb_msg_french "MC(exit,options,SaveNone,Label)"        "Quitter sans sauvegarder"
::msgcat::mcset pb_msg_french "MC(exit,options,SaveSelect,Label)"      "Quitter en sauvegardant les sélectionnés"

### OptionMenu Items
::msgcat::mcset pb_msg_french "MC(optionMenu,item,Other)"       "Autre"
::msgcat::mcset pb_msg_french "MC(optionMenu,item,None)"        "Aucune"
::msgcat::mcset pb_msg_french "MC(optionMenu,item,RT_R)"        "Franchissement rapide et R"
::msgcat::mcset pb_msg_french "MC(optionMenu,item,Rapid)"       "Rapide"
::msgcat::mcset pb_msg_french "MC(optionMenu,item,RS)"          "Broche rapide"
::msgcat::mcset pb_msg_french "MC(optionMenu,item,C_off_RS)"    "Cycle désactivé si Broche rapide"
::msgcat::mcset pb_msg_french "MC(optionMenu,item,IPM)"         "IPM"
::msgcat::mcset pb_msg_french "MC(optionMenu,item,FRN)"         "FRN"
::msgcat::mcset pb_msg_french "MC(optionMenu,item,IPR)"         "IPR"
::msgcat::mcset pb_msg_french "MC(optionMenu,item,Auto)"        "Auto"
::msgcat::mcset pb_msg_french "MC(optionMenu,item,DPM)"         "DPM"
::msgcat::mcset pb_msg_french "MC(optionMenu,item,Abs_Inc)"     "Absolu/Incrémental"
::msgcat::mcset pb_msg_french "MC(optionMenu,item,Abs_Only)"    "Absolu seulement"
::msgcat::mcset pb_msg_french "MC(optionMenu,item,Inc_Only)"    "Incrémental seulement"
::msgcat::mcset pb_msg_french "MC(optionMenu,item,SD)"          "Plus Courte Distance"
::msgcat::mcset pb_msg_french "MC(optionMenu,item,AP)"          "Toujours positif"
::msgcat::mcset pb_msg_french "MC(optionMenu,item,AN)"          "Toujours négatif"
::msgcat::mcset pb_msg_french "MC(optionMenu,item,Z_Axis)"      "Axe Z"
::msgcat::mcset pb_msg_french "MC(optionMenu,item,+X_Axis)"     "Axe X+"
::msgcat::mcset pb_msg_french "MC(optionMenu,item,-X_Axis)"     "Axe X-"
::msgcat::mcset pb_msg_french "MC(optionMenu,item,Y_Axis)"      "Axe des Y"
::msgcat::mcset pb_msg_french "MC(optionMenu,item,MDD)"         "L'amplitude détermine la direction"
::msgcat::mcset pb_msg_french "MC(optionMenu,item,SDD)"         "Le signe détermine la direction"
